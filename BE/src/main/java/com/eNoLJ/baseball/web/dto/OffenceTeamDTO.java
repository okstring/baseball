package com.eNoLJ.baseball.web.dto;

public class OffenceTeamDTO {

    private final String teamName;
    private final int score;
    private final HitterDTO hitter;

    public OffenceTeamDTO(String teamName, int score, HitterDTO hitter) {
        this.teamName = teamName;
        this.score = score;
        this.hitter = hitter;
    }

    public String getTeamName() {
        return teamName;
    }

    public int getScore() {
        return score;
    }

    public HitterDTO getHitter() {
        return hitter;
    }
}
