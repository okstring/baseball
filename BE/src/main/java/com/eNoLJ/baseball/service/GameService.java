package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.web.dto.*;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class GameService {

    public List<GameEntryDTO> getGameList() {
        List<GameEntryDTO> gameEntryDTOList = new ArrayList<>();
        gameEntryDTOList.add(new GameEntryDTO("Marvel", "Captin"));
        gameEntryDTOList.add(new GameEntryDTO("Tigers", "Twins"));
        gameEntryDTOList.add(new GameEntryDTO("Dodgers", "Rockets"));
        gameEntryDTOList.add(new GameEntryDTO("Pintos", "Heros"));
        return gameEntryDTOList;
    }

    public List<MemberDTO> getMembersByTeamName(String teamName) {
        List<MemberDTO> memberDTOList = new ArrayList<>();
        memberDTOList.add(new MemberDTO(1L, "김광진", 0.311));
        memberDTOList.add(new MemberDTO(2L, "이동규", 0.322));
        memberDTOList.add(new MemberDTO(3L, "김진수", 0.333));
        memberDTOList.add(new MemberDTO(4L, "박영권", 0.344));
        memberDTOList.add(new MemberDTO(5L, "추신수", 0.355));
        memberDTOList.add(new MemberDTO(6L, "이용대", 0.366));
        memberDTOList.add(new MemberDTO(7L, "류현진", 0.377));
        memberDTOList.add(new MemberDTO(8L, "최동수", 0.388));
        memberDTOList.add(new MemberDTO(9L, "한양범", 0.399));
        return memberDTOList;
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
