module main

import vweb
import time
import sqlite

struct App {
	vweb.Context
pub mut:
	db sqlite.DB
}

fn main() {
	app := App{
		db: sqlite.connect(':memory:') or { panic(err) }
	}
	sql app.db {
		create table Article
	}
	first_article := Article {
		title: 'First article!'
		text: 'V is cool!'
	}
	second_article := Article {
		title: 'Second article'
		text: 'What to write next?'
	}

	sql app.db {
		insert first_article into Article
		insert second_article into Article
	}
	vweb.run(app, 8081)
}

['/index']
pub fn (mut app App) index () vweb.Result {
	message := 'Hello Vorld vide veb!'
	return $vweb.html()
}

['/time']
pub fn (mut app App) time () vweb.Result {
	time := time.now()
	formatted_time := time.format()
	return app.text(formatted_time)
}

['/blog']
pub fn (mut app App) blog () vweb.Result {
	articles := app.find_all_articles()
	return $vweb.html()
}
['/new']
pub fn (mut app App) new () vweb.Result {
	return $vweb.html()
}

[post]
pub fn (mut app App) new_article(title string, text string) vweb.Result {
	if title == '' ||  text == '' {
		return app.text('Empty text')
	}
	article := Article {
		title: title
		text: text
	}
	sql app.db {
		insert article into Article
	}
	return app.redirect('/blog')
}

