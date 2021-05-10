package com.eNoLJ.baseball.domain.team;

import org.springframework.data.annotation.Id;

public class Team {

    @Id
    private Long id;
    private String name;

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }
}
