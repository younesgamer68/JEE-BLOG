package model;

import java.sql.Timestamp;

public class Comment {
    private int id;
    private int articleId;
    private int authorId;
    private String authorUsername;
    private String content;
    private Timestamp createdAt;

    public Comment() {}

    public Comment(int id, int articleId, int authorId, String content, Timestamp createdAt) {
        this.id = id;
        this.articleId = articleId;
        this.authorId = authorId;
        this.content = content;
        this.createdAt = createdAt;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getArticleId() { return articleId; }
    public void setArticleId(int articleId) { this.articleId = articleId; }

    public int getAuthorId() { return authorId; }
    public void setAuthorId(int authorId) { this.authorId = authorId; }

    public String getAuthorUsername() { return authorUsername; }
    public void setAuthorUsername(String authorUsername) { this.authorUsername = authorUsername; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
