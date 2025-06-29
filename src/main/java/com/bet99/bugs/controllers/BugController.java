package com.bet99.bugs.controllers;

import com.bet99.bugs.BugService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BugController {

    private final BugService bugService;

    public BugController(BugService bugService) {
        this.bugService = bugService;
    }

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("bugs", bugService.getAllBugDtos());
        return "home";
    }

}
