package com.eNoLJ.baseball.web.dto;

public class PitcherDTO {

    private final String name;
    private final int pit;

    public PitcherDTO(String name, int pit) {
        this.name = name;
        this.pit = pit;
    }

    public String getName() {
        return name;
    }

    public int getPit() {
        return pit;
    }
}
