package com.eNoLJ.baseball.domain.member;

import org.springframework.data.repository.CrudRepository;

import java.util.List;


public interface MemberRepository extends CrudRepository<Member, Long> {

    List<Member> findAllByTeamId(Long teamId);
}
