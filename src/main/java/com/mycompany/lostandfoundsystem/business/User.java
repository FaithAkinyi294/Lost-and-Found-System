/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.lostandfoundsystem.business;

import java.io.Serializable;

// This is a Plain Old Java Object (POJO) to hold user data
public class User implements Serializable {
    private String username;

    public User() {} // Default constructor

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}