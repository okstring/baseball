package com.eNoLJ.baseball.web.dto;

import com.eNoLJ.baseball.domain.game.Game;

public class DefenseTeamDTO {

    private final String teamName;
    private final int score;
    private final PitcherDTO pitcher;

    public DefenseTeamDTO(String teamName, int score, PitcherDTO pitcher) {
        this.teamName = teamName;
        this.score = score;
        this.pitcher = pitcher;
    }

    public static DefenseTeamDTO createDefenseTeamDTO(Game game, PitcherDTO pitcher) {
        return new DefenseTeamDTO(game.getHomeTeamName(), game.getHomeTeamScore(), pitcher);
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
