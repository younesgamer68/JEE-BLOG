package model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String username;
    private String email;
    private String password;
    private String firstName;
    private String lastName;
    private String bio;
    private String filiere;
    private int semester;
    private boolean emailValidated;
    private String validationToken;
    private Timestamp createdAt;

    public User() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }
    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }
    public String getFiliere() { return filiere; }
    public void setFiliere(String filiere) { this.filiere = filiere; }
    public int getSemester() { return semester; }
    public void setSemester(int semester) { this.semester = semester; }
    public boolean isEmailValidated() { return emailValidated; }
    public void setEmailValidated(boolean emailValidated) { this.emailValidated = emailValidated; }
    public String getValidationToken() { return validationToken; }
    public void setValidationToken(String validationToken) { this.validationToken = validationToken; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
