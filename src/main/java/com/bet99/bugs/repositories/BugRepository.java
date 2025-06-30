package com.bet99.bugs.repositories;

import com.bet99.bugs.entities.BugEntity;
import com.bet99.bugs.models.Severity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BugRepository extends JpaRepository<BugEntity, Long> {
    List<BugEntity> findBySeverity(Severity severity);
}
