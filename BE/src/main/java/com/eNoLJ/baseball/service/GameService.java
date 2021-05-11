package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.domain.game.GameRepository;
import com.eNoLJ.baseball.domain.member.MemberRepository;
import com.eNoLJ.baseball.domain.team.Team;
import com.eNoLJ.baseball.domain.team.TeamRepository;
import com.eNoLJ.baseball.exception.EntityNotFoundException;
import com.eNoLJ.baseball.exception.ErrorMessage;
import com.eNoLJ.baseball.web.dto.*;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static com.eNoLJ.baseball.web.dto.GameEntryDTO.createGameEntryDTO;

@Service
public class GameService {

    private final GameRepository gameRepository;

    public GameService(GameRepository gameRepository) {
        this.gameRepository = gameRepository;
    }

    public List<GameEntryDTO> getGameList() {
        return gameRepository.findAll().stream()
                .map(game -> createGameEntryDTO(game.getTeamByType(Type.HOME), game.getTeamByType(Type.AWAY)))
                .collect(Collectors.toList());
    }

    public List<MemberDTO> getMembersByTeamName(String teamName) {
        return findTeamByTeamName(teamName).getMembers().stream()
                .map(MemberDTO::createMemberDTO)
                .collect(Collectors.toList());
    }

    private Team findTeamByTeamName(String teamName) {
        return findAllTeam().stream()
                .filter(team -> team.verifyTeamName(teamName))
                .findFirst()
                .orElseThrow(EntityNotFoundException::new);
    }

    private List<Team> findAllTeam() {
        return this.gameRepository.findAll().stream()
                .map(Game::getTeams)
                .flatMap(Collection::stream)
                .collect(Collectors.toList());
    }

    public GameInfoResponseDTO startGameByTeamName(String teamName) {
        RoundInfoDTO roundInfoDTO = new RoundInfoDTO(2, 1, 2, 1, false, true, false);
        OffenceTeamDTO offenceTeamDTO = new OffenceTeamDTO("Marvel", 5, new HitterDTO("류현진", 0.377 , 1, 0));
        DefenseTeamDTO defenseTeamDTO = new DefenseTeamDTO("Captin", 1, new PitcherDTO("최동원", 39));
        List<String> story = new ArrayList<>();
        story.add("스트라이크");
        story.add("볼");
        story.add("볼");
        story.add("볼");
        story.add("스트라이크");
        return new GameInfoResponseDTO("Captin", roundInfoDTO, offenceTeamDTO, defenseTeamDTO, story);
    }

    public GameInfoResponseDTO pitchGame(GameInfoRequestDTO requestDTO) {
        return new GameInfoResponseDTO(requestDTO.getPlayTeam(), requestDTO.getRoundInfo(), requestDTO.getOffenceTeam(), requestDTO.getDefenseTeam(), requestDTO.getStory());
    }

    public GameScoresResponseDTO getGameScores() {
        List<Integer> homeTeamScores = new ArrayList<>();
        homeTeamScores.add(1);
        homeTeamScores.add(2);
        homeTeamScores.add(2);
        List<Integer> awayTeamScores = new ArrayList<>();
        awayTeamScores.add(1);
        awayTeamScores.add(0);
        awayTeamScores.add(0);
        awayTeamScores.add(0);
        GameScoresDTO homeTeam = new GameScoresDTO("Marvel", homeTeamScores);
        GameScoresDTO awayTeam = new GameScoresDTO("Captin", awayTeamScores);
        return new GameScoresResponseDTO(homeTeam, awayTeam);
    }

    public List<MemberScoreDTO> getGameScoresByTeam(String teamName) {
        List<MemberScoreDTO> memberScoreDTOList = new ArrayList<>();
        memberScoreDTOList.add(new MemberScoreDTO(1L, "김광진", 1, 1, 0));
        memberScoreDTOList.add(new MemberScoreDTO(2L, "이동규", 1, 0, 1));
        memberScoreDTOList.add(new MemberScoreDTO(3L, "김진수", 1, 0, 1));
        memberScoreDTOList.add(new MemberScoreDTO(4L, "박영권", 1, 1, 0));
        memberScoreDTOList.add(new MemberScoreDTO(5L, "추신수", 1, 1, 0));
        memberScoreDTOList.add(new MemberScoreDTO(6L, "이용대", 1, 0, 1));
        memberScoreDTOList.add(new MemberScoreDTO(7L, "류현진", 1, 0, 1));
        memberScoreDTOList.add(new MemberScoreDTO(8L, "최동수", 1, 0, 1));
        memberScoreDTOList.add(new MemberScoreDTO(9L, "한양범", 1, 1, 0));
        return memberScoreDTOList;
    }
}
