package com.eNoLJ.baseball.web.dto;

public class MemberScoreDTO {

    private final Long id;
    private final String name;
    private final int TPA;
    private final int hits;
    private final int out;

    public MemberScoreDTO(Long id, String name, int TPA, int hits, int out) {
        this.id = id;
        this.name = name;
        this.TPA = TPA;
        this.hits = hits;
        this.out = out;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public int getTPA() {
        return TPA;
    }

    public int getHits() {
        return hits;
    }

    public int getOut() {
        return out;
    }
}
