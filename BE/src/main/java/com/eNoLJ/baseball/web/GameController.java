package com.eNoLJ.baseball.web;

import com.eNoLJ.baseball.service.GameService;
import com.eNoLJ.baseball.web.dto.GameEntryDTO;
import com.eNoLJ.baseball.web.dto.MemberDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
public class GameController {

    public final GameService gameService;
    private final Logger logger = LoggerFactory.getLogger(GameController.class);

    public GameController(GameService gameService) {
        this.gameService = gameService;
    }

    @GetMapping("/games")
    public List<GameEntryDTO> viewGameList() {
        logger.info("게임 목록 요청");
        return gameService.getGameList();
    }

    @GetMapping("/members/{teamName}")
    public List<MemberDTO> viewMembers(@PathVariable String teamName) {
        logger.info("{}팀의 선수 목록 요청", teamName);
        return gameService.getMembersByTeamName(teamName);
    }


}
