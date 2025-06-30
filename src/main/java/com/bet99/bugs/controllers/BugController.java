package com.bet99.bugs.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BugController {

    @GetMapping("/")
    public String home() {
        return "home";
    }

}
