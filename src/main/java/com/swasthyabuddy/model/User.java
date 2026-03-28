package com.swasthyabuddy.model;

public class User {

    private int    id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String role;     // PATIENT or DOCTOR
    private String phone;
    private String gender;
    private String bloodGroup;

    public User() {}

    public User(int id, String firstName, String lastName,
                String email, String role, String phone) {
        this.id        = id;
        this.firstName = firstName;
        this.lastName  = lastName;
        this.email     = email;
        this.role      = role;
        this.phone     = phone;
    }

    // Getters
    public int    getId()         { return id; }
    public String getFirstName()  { return firstName; }
    public String getLastName()   { return lastName; }
    public String getEmail()      { return email; }
    public String getPassword()   { return password; }
    public String getRole()       { return role; }
    public String getPhone()      { return phone; }
    public String getGender()     { return gender; }
    public String getBloodGroup() { return bloodGroup; }

    // Setters
    public void setId(int id)                  { this.id        = id; }
    public void setFirstName(String firstName) { this.firstName = firstName; }
    public void setLastName(String lastName)   { this.lastName  = lastName; }
    public void setEmail(String email)         { this.email     = email; }
    public void setPassword(String password)   { this.password  = password; }
    public void setRole(String role)           { this.role      = role; }
    public void setPhone(String phone)         { this.phone     = phone; }
    public void setGender(String gender)       { this.gender    = gender; }
    public void setBloodGroup(String bg)       { this.bloodGroup = bg; }
}