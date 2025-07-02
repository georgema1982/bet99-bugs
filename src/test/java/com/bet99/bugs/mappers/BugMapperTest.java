package com.bet99.bugs.mappers;

import com.bet99.bugs.models.BugDto;
import com.bet99.bugs.entities.BugEntity;
import com.bet99.bugs.models.Severity;
import com.bet99.bugs.models.Status;
import org.junit.jupiter.api.Test;
import org.mapstruct.factory.Mappers;

import static org.junit.jupiter.api.Assertions.*;

public class BugMapperTest {

    private static final String BUG_TITLE = "Bug Title";
    private static final String BUG_DESCRIPTION = "Bug Description";
    private static final String ANOTHER_BUG_TITLE = "Another Bug";
    private static final String ANOTHER_BUG_DESCRIPTION = "Another Description";

    private final BugMapper bugMapper = Mappers.getMapper(BugMapper.class);

    @Test
    void testToDto_givenEntity_expectDtoWithSameFields() {
        BugEntity entity = new BugEntity();
        entity.setId(1L);
        entity.setBugTitle(BUG_TITLE);
        entity.setDescription(BUG_DESCRIPTION);
        entity.setSeverity(Severity.HIGH);
        entity.setStatus(Status.OPEN);

        BugDto dto = bugMapper.toDto(entity);

        assertNotNull(dto);
        assertEquals(1L, dto.getId());
        assertEquals(BUG_TITLE, dto.getBugTitle());
        assertEquals(BUG_DESCRIPTION, dto.getDescription());
        assertEquals(Severity.HIGH, dto.getSeverity());
        assertEquals(Status.OPEN, dto.getStatus());
    }

    @Test
    void testToEntity_givenDto_expectEntityWithSameFields() {
        BugDto dto = BugDto.builder()
                .id(2L)
                .bugTitle(ANOTHER_BUG_TITLE)
                .description(ANOTHER_BUG_DESCRIPTION)
                .severity(Severity.LOW)
                .status(Status.CLOSED)
                .build();

        BugEntity entity = bugMapper.toEntity(dto);

        assertNotNull(entity);
        assertEquals(2L, entity.getId());
        assertEquals(ANOTHER_BUG_TITLE, entity.getBugTitle());
        assertEquals(ANOTHER_BUG_DESCRIPTION, entity.getDescription());
        assertEquals(Severity.LOW, entity.getSeverity());
        assertEquals(Status.CLOSED, entity.getStatus());
    }
}
