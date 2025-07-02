package com.bet99.bugs;

import com.bet99.bugs.entities.BugEntity;
import com.bet99.bugs.models.BugDto;
import com.bet99.bugs.models.Severity;
import com.bet99.bugs.models.Status;
import com.bet99.bugs.mappers.BugMapper;
import com.bet99.bugs.repositories.BugRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;

@Service
@Transactional
public class BugService {

    private final BugRepository bugRepository;
    private final BugMapper bugMapper;

    public BugService(BugRepository bugRepository, BugMapper bugMapper) {
        this.bugRepository = bugRepository;
        this.bugMapper = bugMapper;
    }

    public List<BugDto> getBugs(Severity severity) {
        return (severity == null ? bugRepository.findAll() : bugRepository.findBySeverity(severity))
                .stream().map(bugMapper::toDto).toList();
    }

    public BugDto addBug(BugDto bugDto) {
        BugEntity entity = bugMapper.toEntity(bugDto);
        BugEntity savedEntity = bugRepository.save(entity);
        return bugMapper.toDto(savedEntity);
    }
}
