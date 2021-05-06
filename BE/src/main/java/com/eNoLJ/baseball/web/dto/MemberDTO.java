package com.eNoLJ.baseball.web.dto;

public class MemberDTO {

    private Long id;
    private String name;
    private double AVG;

    public MemberDTO(Long id, String name, double AVG) {
        this.id = id;
        this.name = name;
        this.AVG = AVG;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public double getAVG() {
        return AVG;
    }
}
