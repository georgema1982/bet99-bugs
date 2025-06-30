package com.bet99.bugs.mappers;

import com.bet99.bugs.models.BugDto;
import com.bet99.bugs.entities.BugEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface BugMapper {
    BugDto toDto(BugEntity entity);
    BugEntity toEntity(BugDto dto);
}
