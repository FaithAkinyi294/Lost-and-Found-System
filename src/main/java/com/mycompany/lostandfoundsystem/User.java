/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.lostandfoundsystem;

/**
 *
 * @author user
 */

import java.io.Serializable;

public class User implements Serializable {
    private String username;

    public User() {} // Required no-arg constructor

    // EL calls this via ${user.username}
    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }
}
