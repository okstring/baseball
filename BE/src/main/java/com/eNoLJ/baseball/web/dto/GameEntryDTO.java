package com.eNoLJ.baseball.web.dto;

public class GameEntryDTO {

    private final String homeTeamName;
    private final String awayTeamName;

    public GameEntryDTO(String homeTeamName, String awayTeamName) {
        this.homeTeamName = homeTeamName;
        this.awayTeamName = awayTeamName;
    }

    public String getHomeTeamName() {
        return homeTeamName;
    }

    public String getAwayTeamName() {
        return awayTeamName;
    }
}
