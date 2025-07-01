package com.bet99.bugs.controllers;

import com.bet99.bugs.BugService;
import com.bet99.bugs.models.BugDto;
import com.bet99.bugs.models.Severity;

import jakarta.validation.Valid;

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
    public ResponseEntity<List<BugDto>> getBugs(@RequestParam(required = false) Severity severity) {
        return ResponseEntity.ok(bugService.getBugs(severity));
    }

    @PostMapping
    public ResponseEntity<BugDto> createBug(@RequestBody @Valid BugDto bugDto) {
        return ResponseEntity.ok(bugService.addBug(bugDto));
    }
}
