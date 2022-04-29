module main

struct Article {
	id	int		[primary; sql: serial]
	title string
	text string
}

pub fn (app &App) find_all_articles() []Article {
	return sql app.db {
		select from Article
	}
}

pub fn (app &App) find_article(article_id int) ?Article {
	return sql app.db {
		select from Article where id == article_id
	}
}
