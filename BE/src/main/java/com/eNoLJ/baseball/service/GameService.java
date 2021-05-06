package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.web.dto.GameEntryDTO;
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
}
