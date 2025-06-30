package com.bet99.bugs.controllers;

import com.bet99.bugs.BugService;
import com.bet99.bugs.models.BugDto;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/bugs")
public class BugRestController {

    private final BugService bugService;

    public BugRestController(BugService bugService) {
        this.bugService = bugService;
    }

    @GetMapping
    public ResponseEntity<List<BugDto>> getAllBugs() {
        return ResponseEntity.ok(bugService.getAllBugs());
    }

    @PostMapping
    public ResponseEntity<BugDto> createBug(@RequestBody BugDto bugDto) {
        return ResponseEntity.ok(bugService.addBug(bugDto));
    }
}
