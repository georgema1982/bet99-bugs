package com.bet99.bugs.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
public class BugDto {
    private Long id;
    private String bugTitle;
    private String description;
    private Severity severity;
    private Status status;
}
