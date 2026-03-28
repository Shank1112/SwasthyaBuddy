package com.swasthyabuddy.model;

import java.util.ArrayList;
import java.util.List;

public class Prediction {

    private int          id;
    private int          userId;
    private String       symptoms;
    private String       diseaseName;
    private int          confidence;      // 0-100
    private String       description;
    private String       createdAt;
    private List<String> precautions;     // e.g. ["Rest", "Stay hydrated"]

    public Prediction() {}

    public Prediction(String diseaseName, int confidence, String description) {
        this.diseaseName = diseaseName;
        this.confidence  = confidence;
        this.description = description;
        this.precautions = new ArrayList<>();
    }

    // ── Getters
    public int          getId()           { return id; }
    public int          getUserId()       { return userId; }
    public String       getSymptoms()     { return symptoms; }
    public String       getName()         { return diseaseName; }
    public int          getConfidence()   { return confidence; }
    public String       getDescription()  { return description; }
    public String       getCreatedAt()    { return createdAt; }
    public List<String> getPrecautions()  { return precautions != null ? precautions : new ArrayList<>(); }

    // ── Setters
    public void setId(int id)                      { this.id          = id; }
    public void setUserId(int userId)              { this.userId      = userId; }
    public void setSymptoms(String symptoms)       { this.symptoms    = symptoms; }
    public void setName(String name)               { this.diseaseName = name; }
    public void setConfidence(int confidence)      { this.confidence  = confidence; }
    public void setDescription(String desc)        { this.description = desc; }
    public void setCreatedAt(String createdAt)     { this.createdAt   = createdAt; }
    public void setPrecautions(List<String> precs) { this.precautions = precs; }
}
