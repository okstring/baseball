package com.eNoLJ.baseball.web.dto;

public class DefenseTeamDTO {

    private final String teamName;
    private final int score;
    private final PitcherDTO pitcher;

    public DefenseTeamDTO(String teamName, int score, PitcherDTO pitcher) {
        this.teamName = teamName;
        this.score = score;
        this.pitcher = pitcher;
    }

    public String getTeamName() {
        return teamName;
    }

    public int getScore() {
        return score;
    }

    public PitcherDTO getPitcher() {
        return pitcher;
    }
}
