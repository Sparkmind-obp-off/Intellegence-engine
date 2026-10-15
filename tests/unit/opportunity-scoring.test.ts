import { describe, expect, it } from "vitest";
import { scoreOpportunity } from "../../src/domain/opportunity-scoring";

describe("scoreOpportunity", () => {
  it("returns bounded deterministic score and version", () => {
    const result = scoreOpportunity({
      independentSources: 5,
      repeatedPain: 1,
      buyingIntent: 1,
      reachability: 1,
      competitionClarity: 1,
      freshness: 1,
      counterEvidence: 0,
    });
    expect(result.score).toBe(90);
    expect(result.version).toBe("baseline-v1");
  });

  it("clamps invalid or out-of-range values", () => {
    const result = scoreOpportunity({
      independentSources: -10,
      repeatedPain: 5,
      buyingIntent: -2,
      reachability: Number.NaN,
      competitionClarity: 0,
      freshness: 0,
      counterEvidence: 9,
    });
    expect(result.score).toBe(0);
  });
});
