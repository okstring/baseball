package com.eNoLJ.baseball.domain.game;

import com.eNoLJ.baseball.domain.inning.Inning;
import com.eNoLJ.baseball.domain.member.Member;
import com.eNoLJ.baseball.domain.team.Team;
import com.eNoLJ.baseball.exception.EntityNotFoundException;
import com.eNoLJ.baseball.web.utils.Type;
import org.springframework.data.annotation.Id;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class Game {

    @Id
    private Long id;
    private String choiceTeamName;
    private List<Team> teams = new ArrayList<>();
    private List<Inning> innings = new ArrayList<>();

    public void choiceTeam(Team team) {
        this.choiceTeamName = team.getName();
    }

    public void addInning(Inning inning) {
        this.innings.add(inning);
    }

    public boolean verifyTeam(Team checkTeam) {
        List<Team> teams = this.teams.stream()
                .filter(team -> team.verifyTeam(checkTeam))
                .collect(Collectors.toList());
        return teams.size() == 1;
    }

    public List<String> getSboHistoryByRecentInning() {
        return innings.get(innings.size() - 1).getSboHistory();
    }

    public Team getTeamByType(Type type) {
        return teams.stream()
                .filter(team -> team.getType() == type)
                .findFirst()
                .orElseThrow(EntityNotFoundException::new);
    }

    public List<Member> getTeamMembersByType(Type type) {
        return getTeamByType(type).getMembers();
    }

    public String getTeamNameByType(Type type) {
        return getTeamByType(type).getName();
    }

    public int getTeamScoreByType(Type type) {
        return innings.stream()
                .mapToInt(inning -> inning.getTotalScoreByTeamId(getTeamByType(type).getId()))
                .sum();
    }

    public int getAwayTeamScore() {
        return innings.stream()
                .mapToInt(inning -> inning.getTotalScoreByTeamId(getAwayTeam().getId()))
                .sum();
    }

    public Long getId() {
        return id;
    }

    public String getChoiceTeamName() {
        return choiceTeamName;
    }

    public List<Team> getTeams() {
        return teams;
    }

    public List<Inning> getInnings() {
        return innings;
    }
}
