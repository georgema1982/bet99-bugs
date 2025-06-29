package com.bet99.bugs.controllers;

import com.bet99.bugs.BugService;
import com.bet99.bugs.models.BugDto;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/bugs")
public class BugRestController {

    private final BugService bugService;

    public BugRestController(BugService bugService) {
        this.bugService = bugService;
    }

    @PostMapping
    public BugDto createBug(@RequestBody BugDto bugDto) {
        bugService.addBugDto(bugDto);
        return bugDto;
    }
}
