package com.bet99.bugs;

import com.bet99.bugs.models.BugDto;
import com.bet99.bugs.models.Severity;
import com.bet99.bugs.models.Status;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class BugService {

    private static final List<BugDto> bugDtos = new ArrayList<>();

    static {
        bugDtos.add(BugDto.builder()
                .id(1L)
                .bugTitle("NullPointerException on Login")
                .description("App crashes with NPE when logging in with empty username.")
                .severity(Severity.HIGH)
                .status(Status.OPEN)
                .build());

        bugDtos.add(BugDto.builder()
                .id(2L)
                .bugTitle("UI Overlap on Dashboard")
                .description("Dashboard widgets overlap on small screens.")
                .severity(Severity.MEDIUM)
                .status(Status.IN_PROGRESS)
                .build());

        bugDtos.add(BugDto.builder()
                .id(3L)
                .bugTitle("Slow Response on Search")
                .description("Search API takes more than 5 seconds to respond.")
                .severity(Severity.LOW)
                .status(Status.RESOLVED)
                .build());
    }

    public List<BugDto> getAllBugDtos() {
        return Collections.unmodifiableList(bugDtos);
    }
}
