package com.eNoLJ.baseball.domain.hitterHistory;

import com.eNoLJ.baseball.domain.member.Member;
import org.springframework.data.annotation.Id;

public class HitterHistory {

    @Id
    private Long id;
    private int tpa;
    private int hits;
    private Long memberId;

    public HitterHistory() {}

    public HitterHistory(int tpa, int hits, Long memberId) {
        this.tpa = tpa;
        this.hits = hits;
        this.memberId = memberId;
    }

    public static HitterHistory createHitterHistory(Member member) {
        return new HitterHistory(1, 0, member.getId());
    }

    public Long getId() {
        return id;
    }

    public int getTpa() {
        return tpa;
    }

    public int getHits() {
        return hits;
    }

    public Long getMemberId() {
        return memberId;
    }
}
