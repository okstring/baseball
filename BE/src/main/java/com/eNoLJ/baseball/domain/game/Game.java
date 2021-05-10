package com.eNoLJ.baseball.domain.game;

import org.springframework.data.annotation.Id;

public class Game {

    @Id
    private Long id;
    private String choiceTeamName;
    private Long homeTeamId;
    private Long awayTeamId;

    public Long getId() {
        return id;
    }

    public String getChoiceTeamName() {
        return choiceTeamName;
    }

    public Long getHomeTeamId() {
        return homeTeamId;
    }

    public Long getAwayTeamId() {
        return awayTeamId;
    }
}
