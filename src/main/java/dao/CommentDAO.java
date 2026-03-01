package dao;

import model.Comment;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CommentDAO {

    // ------------------------------------------------------------------ INSERT
    public boolean create(Comment comment) {
        String sql = "INSERT INTO comments (article_id, author_id, content) VALUES (?,?,?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comment.getArticleId());
            ps.setInt(2, comment.getAuthorId());
            ps.setString(3, comment.getContent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ FIND BY ARTICLE
    public List<Comment> findByArticle(int articleId) {
        List<Comment> list = new ArrayList<>();
        String sql = "SELECT c.*, u.username FROM comments c JOIN users u ON c.author_id = u.id WHERE c.article_id = ? ORDER BY c.created_at ASC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, articleId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ------------------------------------------------------------------ DELETE
    public boolean delete(int commentId, int authorId) {
        String sql = "DELETE FROM comments WHERE id=? AND author_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, commentId);
            ps.setInt(2, authorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ------------------------------------------------------------------ MAP ROW
    private Comment mapRow(ResultSet rs) throws SQLException {
        Comment c = new Comment();
        c.setId(rs.getInt("id"));
        c.setArticleId(rs.getInt("article_id"));
        c.setAuthorId(rs.getInt("author_id"));
        c.setAuthorUsername(rs.getString("username"));
        c.setContent(rs.getString("content"));
        c.setCreatedAt(rs.getTimestamp("created_at"));
        return c;
    }
}
