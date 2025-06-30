package com.bet99.bugs.models;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class BugDto {
    private Long id;

    @NotBlank
    @Size(max = 255)
    private String bugTitle;

    @NotBlank
    @Size(max = 255)
    private String description;

    @NotNull
    private Severity severity;

    @NotNull
    private Status status;
}
