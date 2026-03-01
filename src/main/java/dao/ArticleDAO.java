package dao;

import model.Article;
import java.sql.*;
import java.util.*;

public class ArticleDAO {

    public static final int PAGE_SIZE = 6;

    public boolean create(Article article) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO articles(author_id,title,content) VALUES(?,?,?)")) {
            ps.setInt(1, article.getAuthorId());
            ps.setString(2, article.getTitle());
            ps.setString(3, article.getContent());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public List<Article> findAll() {
        List<Article> list = new ArrayList<>();
        String sql = "SELECT a.*,u.username FROM articles a JOIN users u ON a.author_id=u.id ORDER BY a.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Article> findPage(int page) {
        List<Article> list = new ArrayList<>();
        int offset = (page - 1) * PAGE_SIZE;
        String sql = "SELECT a.*,u.username FROM articles a JOIN users u ON a.author_id=u.id ORDER BY a.created_at DESC LIMIT ? OFFSET ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, PAGE_SIZE);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countAll() {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM articles");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public int getTotalPages() {
        return (int) Math.ceil((double) countAll() / PAGE_SIZE);
    }

    public Article findById(int id) {
        String sql = "SELECT a.*,u.username FROM articles a JOIN users u ON a.author_id=u.id WHERE a.id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<Article> findByAuthor(int authorId) {
        List<Article> list = new ArrayList<>();
        String sql = "SELECT a.*,u.username FROM articles a JOIN users u ON a.author_id=u.id WHERE a.author_id=? ORDER BY a.created_at DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, authorId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public boolean update(Article article) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("UPDATE articles SET title=?,content=?,updated_at=CURRENT_TIMESTAMP WHERE id=? AND author_id=?")) {
            ps.setString(1, article.getTitle());
            ps.setString(2, article.getContent());
            ps.setInt(3, article.getId());
            ps.setInt(4, article.getAuthorId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean delete(int articleId, int authorId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("DELETE FROM articles WHERE id=? AND author_id=?")) {
            ps.setInt(1, articleId); ps.setInt(2, authorId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    private Article mapRow(ResultSet rs) throws SQLException {
        Article a = new Article();
        a.setId(rs.getInt("id"));
        a.setAuthorId(rs.getInt("author_id"));
        a.setAuthorUsername(rs.getString("username"));
        a.setTitle(rs.getString("title"));
        a.setContent(rs.getString("content"));
        a.setCreatedAt(rs.getTimestamp("created_at"));
        a.setUpdatedAt(rs.getTimestamp("updated_at"));
        return a;
    }
}
