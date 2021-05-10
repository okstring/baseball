package com.eNoLJ.baseball.domain.member;

import org.springframework.data.annotation.Id;

public class Member {

    @Id
    private Long id;
    private String name;
    private double avg;
    private Long teamId;

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public double getAvg() {
        return avg;
    }

    public Long getTeamId() {
        return teamId;
    }
}
