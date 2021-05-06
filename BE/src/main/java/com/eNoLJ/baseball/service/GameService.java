package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.web.dto.GameEntryDTO;
import com.eNoLJ.baseball.web.dto.MemberDTO;
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
}
