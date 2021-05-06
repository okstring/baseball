package com.eNoLJ.baseball.web.dto;

public class HitterDTO {

    private final String name;
    private final double AVG;
    private final int TPA;
    private final int hits;

    public HitterDTO(String name, double AVG, int TPA, int hits) {
        this.name = name;
        this.AVG = AVG;
        this.TPA = TPA;
        this.hits = hits;
    }

    public String getName() {
        return name;
    }

    public double getAVG() {
        return AVG;
    }

    public int getTPA() {
        return TPA;
    }

    public int getHits() {
        return hits;
    }
}
