package com.bet99.bugs.controllers;

import com.bet99.bugs.models.Severity;
import com.bet99.bugs.models.Status;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BugController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("severities", Severity.values());
        model.addAttribute("statuses", Status.values());
        return "home";
    }

}
