package dao;

import model.User;
import java.sql.*;

public class UserDAO {

    // ----------------------------------------------------------------
    //  REGISTRATION
    // ----------------------------------------------------------------
    public boolean register(User user) {
        String sql = "INSERT INTO users (username,email,password,first_name,last_name,bio,filiere,semester,email_validated,validation_token) VALUES (?,?,?,?,?,?,?,?,?,?)";
        try (Connection con = DBConnection.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getFirstName());
            ps.setString(5, user.getLastName());
            ps.setString(6, user.getBio());
            ps.setString(7, user.getFiliere());
            ps.setInt(8, user.getSemester());
            ps.setBoolean(9, false);
            ps.setString(10, user.getValidationToken());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ----------------------------------------------------------------
    //  LOOKUPS
    // ----------------------------------------------------------------
    public User findByEmail(String email) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE email=?")) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public User findById(int id) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?")) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // ----------------------------------------------------------------
    //  EMAIL VALIDATION
    // ----------------------------------------------------------------
    public boolean validateEmail(String token) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE users SET email_validated=1,validation_token=NULL WHERE validation_token=?")) {
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ----------------------------------------------------------------
    //  PROFILE UPDATE
    // ----------------------------------------------------------------
    public boolean updateProfile(User user) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE users SET first_name=?,last_name=?,bio=?,filiere=?,semester=? WHERE id=?")) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getBio());
            ps.setString(4, user.getFiliere());
            ps.setInt(5, user.getSemester());
            ps.setInt(6, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ----------------------------------------------------------------
    //  EXISTENCE CHECKS
    // ----------------------------------------------------------------
    public boolean emailExists(String email) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE email=?")) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    public boolean usernameExists(String username) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE username=?")) {
            ps.setString(1, username);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ----------------------------------------------------------------
    //  FORGOT PASSWORD — store reset token (expires in 30 min)
    // ----------------------------------------------------------------
    public boolean setResetToken(String email, String token) {
        // Expires 30 minutes from now (stored as epoch millis in a TEXT column)
        long expiresAt = System.currentTimeMillis() + 30L * 60 * 1000;
        String sql = "UPDATE users SET reset_token=?, reset_token_expires=? WHERE email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setLong(2, expiresAt);
            ps.setString(3, email);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Returns the user if the token is valid AND not expired.
     * Returns null if not found or expired.
     */
    public User findByResetToken(String token) {
        String sql = "SELECT * FROM users WHERE reset_token=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                long expires = rs.getLong("reset_token_expires");
                if (expires > 0 && System.currentTimeMillis() > expires) {
                    return null; // expired
                }
                return mapRow(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    /**
     * Sets a new hashed password and clears the reset token.
     */
    public boolean resetPassword(String token, String newHashedPassword) {
        String sql = "UPDATE users SET password=?, reset_token=NULL, reset_token_expires=NULL WHERE reset_token=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, newHashedPassword);
            ps.setString(2, token);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }

    // ----------------------------------------------------------------
    //  INTERNAL ROW MAPPER
    // ----------------------------------------------------------------
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setPassword(rs.getString("password"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setBio(rs.getString("bio"));
        u.setFiliere(rs.getString("filiere"));
        u.setSemester(rs.getInt("semester"));
        u.setEmailValidated(rs.getBoolean("email_validated"));
        u.setValidationToken(rs.getString("validation_token"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        return u;
    }
}
