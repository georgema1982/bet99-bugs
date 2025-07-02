package com.bet99.bugs.services;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.contains;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import com.bet99.bugs.BugService;
import com.bet99.bugs.entities.BugEntity;
import com.bet99.bugs.mappers.BugMapper;
import com.bet99.bugs.models.BugDto;
import com.bet99.bugs.models.Severity;
import com.bet99.bugs.models.Status;
import com.bet99.bugs.repositories.BugRepository;

@ExtendWith(MockitoExtension.class)
public class BugServiceTest {

    @Mock
    private BugRepository bugRepository;

    @Mock
    private BugMapper bugMapper;

    @InjectMocks
    private BugService bugService;

    @Test
    void testAddBug_givenValidBugDto_expectSavedBugDtoWithId() {
        BugDto bugDto = BugDto.builder()
                .id(null)
                .bugTitle("Test Bug")
                .description("Test Description")
                .severity(Severity.HIGH)
                .status(Status.OPEN)
                .build();

        BugEntity bugEntity = new BugEntity();

        when(bugMapper.toEntity(bugDto)).thenReturn(bugEntity);
        when(bugRepository.save(bugEntity)).thenReturn(bugEntity);

        BugDto savedDto = BugDto.builder()
                .id(1L)
                .bugTitle("Test Bug")
                .description("Test Description")
                .severity(Severity.HIGH)
                .status(Status.OPEN)
                .build();
        when(bugMapper.toDto(bugEntity)).thenReturn(savedDto);

        BugDto result = bugService.addBug(bugDto);

        assertNotNull(result);
        assertEquals(savedDto, result);
        verify(bugRepository).save(bugEntity);
    }

    @Test
    void testGetBugs_givenNoSeverity_expectAllBugsReturned() {
        BugEntity bugEntity1 = new BugEntity();
        BugEntity bugEntity2 = new BugEntity();

        BugDto bugDto1 = BugDto.builder()
                .id(1L)
                .bugTitle("Bug1")
                .description("Desc1")
                .severity(Severity.LOW)
                .status(Status.OPEN)
                .build();

        BugDto bugDto2 = BugDto.builder()
                .id(2L)
                .bugTitle("Bug2")
                .description("Desc2")
                .severity(Severity.HIGH)
                .status(Status.CLOSED)
                .build();

        when(bugRepository.findAll()).thenReturn(List.of(bugEntity1, bugEntity2));
        when(bugMapper.toDto(bugEntity1)).thenReturn(bugDto1);
        when(bugMapper.toDto(bugEntity2)).thenReturn(bugDto2);

        List<BugDto> result = bugService.getBugs(null);

        assertThat(result, contains(bugDto1, bugDto2));
        verify(bugRepository).findAll();
    }

    @Test
    void testGetBugs_givenSeverityLow_expectOnlyLowSeverityBugsReturned() {
        BugEntity bugEntity1 = new BugEntity();
        BugEntity bugEntity2 = new BugEntity();

        BugDto bugDto1 = BugDto.builder()
                .id(3L)
                .bugTitle("Bug3")
                .description("Desc3")
                .severity(Severity.LOW)
                .status(Status.OPEN)
                .build();

        BugDto bugDto2 = BugDto.builder()
                .id(4L)
                .bugTitle("Bug4")
                .description("Desc4")
                .severity(Severity.LOW)
                .status(Status.CLOSED)
                .build();

        when(bugRepository.findBySeverity(Severity.LOW)).thenReturn(List.of(bugEntity1, bugEntity2));
        when(bugMapper.toDto(bugEntity1)).thenReturn(bugDto1);
        when(bugMapper.toDto(bugEntity2)).thenReturn(bugDto2);

        List<BugDto> result = bugService.getBugs(Severity.LOW);

        assertThat(result, contains(bugDto1, bugDto2));
        verify(bugRepository).findBySeverity(Severity.LOW);
    }
}
