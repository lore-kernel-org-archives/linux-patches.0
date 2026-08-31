Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44D2B51E426;
	Mon, 31 Aug 2026 13:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183829; cv=none; b=byifGnzFU7mtY3hW1wAiHjBnruLcBz8lJOqN4fzZZcWPinshf+T/QkFusn2S8cWO70R6fJuAyImJiTbbfvaygpEhvYeEP5Ri05QpOBliqw3kUjttOO/8WpHGrAsIbPTuFX7SXUaNb3w2BDjDqKuorNACdDT81SRdLtbA3v/gcWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183829; c=relaxed/simple;
	bh=CGt0N1tLOFpwGA8/d4GAdlCO8d3EpknSs7/J7jBe4OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MAJADYHWX0wll+Tm9euoZvusZrMQwcG2SGVYTWRhDYdjH0ufbXr33pO3IsQMTwhALRE4T5eMkWB6l79N/yw58JW7XpCAs+voIUoDQDOCoNpTyab2aMHKvTdMYwIlHlyqsDKqJB9DJVOMUaG9BK1nw9R/jr+f4KV/ROz05qNLWvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WS9Lrsog; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WS9Lrsog"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92DD21F00A3E;
	Mon, 31 Aug 2026 13:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183827;
	bh=ydfY7BP33vtEWqKTd0X509IVv9E5NYTqO71gDIaSIrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WS9Lrsog3kLykR0jf5npacD7P4gkC8BnFu+OVHzjIOdRscGS3XojWfFKEZTXpxoOa
	 AcaBtZzrj26PbrUoxIf3w+O7GS0a4695paP1iJc58Ag/6d0ritfYtdbmJyxxXeBnyz
	 ucD0CJYq9VSv+jOeBQ4XERq4RZymrQlRqlMSlLz80gIyFNFH+k7s/LTmkhUYNQiIbu
	 J9gDmjUUjTDyfgTCNgqw/+U9IZ8KKH3tHyehLPhduZiya7WAJXq3QUmsQ6VdpJnktH
	 vqqgNg6NoUjJgoeboQwk/N20qHto0uoo6x4g8tWA2o0sker+ITTH9rcicgPpYOZb0J
	 jwzKxhwZQTF8A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Sasha Levin <sashal@kernel.org>,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	linux-renesas-soc@vger.kernel.org,
	linux-clk@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: renesas: cpg-mssr: Add number of clock cells check
Date: Mon, 31 Aug 2026 09:25:56 -0400
Message-ID: <20260831133314.4125787-328-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7f0c422c7fbfd9294ff9321ada0c63561e5c6ea0 ]

The number of clock cells is not validated in the clock provider's
clk_src_get() callback.  Add the missing check.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/46e010659ffdffd5e3541369f3b65d43ebe236ec.1777562043.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject line
**Record:** `[clk: renesas: cpg-mssr]` `[Add]` — add missing validation
of clock specifier cell count in the CPG/MSSR clock provider callback.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Geert Uytterhoeven `<geert+renesas@glider.be>`
  (author)
- **Reviewed-by:** Biju Das `<biju.das.jz@bp.renesas.com>` (Renesas
  maintainer)
- **Link:** https://patch.msgid.link/46e010659ffdffd5e3541369f3b65d43ebe
  236ec.1777562043.git.geert+renesas@glider.be
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot tags
- Notable: maintainer review present; no external bug report

### Step 1.3: Body analysis
**Record:**
- **Bug:** `cpg_mssr_clk_src_twocell_get()` uses `clkspec->args[0]` and
  `clkspec->args[1]` without verifying `clkspec->args_count == 2`
- **Symptom:** malformed or short clock specifiers can reach the
  callback; `args[1]` is read unconditionally at function entry
- **Root cause:** missing input validation in the OF clock provider
  `clk_src_get` callback
- No kernel version, stack trace, or reproduction steps in the message

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although the subject says "Add … check", this is a real
correctness bug: the function dereferences two specifier cells without
confirming two cells were supplied. Same-file helper
`cpg_mssr_is_pm_clk()` already enforces `args_count == 2`.

---

## Phase 2: Diff Analysis

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/clk/renesas/renesas-cpg-mssr.c` (+3 / -0)
- **Function:** `cpg_mssr_clk_src_twocell_get()`
- **Scope:** single-file, surgical (3 lines)

### Step 2.2: Code flow change
**Record:**
- **Before:** reads `clkspec->args[1]` immediately, then switches on
  `args[0]`
- **After:** returns `-EINVAL` if `args_count != 2`, then same logic
- **Path affected:** every clock lookup through this provider (probe,
  consumer `clocks` properties, `of_clk_get_from_provider()`)

### Step 2.3: Bug mechanism
**Record:** **Category:** input validation / logic correctness
**Mechanism:** with `args_count < 2`, `args[1]` may not have been
populated by the caller; with `args_count > 2`, extra cells are silently
ignored. Either can yield wrong clock index/type selection. Not a
classic buffer overflow (`args[]` is fixed-size), but can return the
wrong `struct clk *` or pass bad indices into `priv->clks[]` lookup.

### Step 2.4: Fix quality
**Record:** Obviously correct, minimal, matches existing pattern in the
same file (`cpg_mssr_is_pm_clk`, line 561) and `ux500_twocell_get()`.
Regression risk: very low; only rejects previously-accepted invalid
specifiers.

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:** Current function body dates to merge `5d324e5159d9e` in this
tree's limited history; file copyright shows CPG/MSSR driver present
since 2015. The missing validation is long-standing, not a recent
regression.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related file history
**Record:** Recent `renesas-cpg-mssr.c` changes in this tree are reset-
timing fixes (`f57b5f2ad106a`, `b1c7a8145137c`). No related args_count
fix already present. Patch is standalone (3/3 in series; patches 1–2 are
rzg2l refactors).

### Step 3.4: Author context
**Record:** Geert Uytterhoeven is the Renesas clock subsystem
maintainer. Biju Das reviewed.

### Step 3.5: Dependencies
**Record:** None. Applies cleanly (`git apply --check` on upstream
commit `7f0c422c7fbfd` succeeded). Self-contained.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original discussion
**Record:**
- **URL:** https://patch.msgid.link/46e010659ffdffd5e3541369f3b65d43ebe2
  36ec.1777562043.git.geert+renesas@glider.be
- **Series:** v1, 3 patches — "clk: renesas: Miscellaneous fixes and
  cleanups"
- **Reviewer feedback:** Biju Das: "Thanks for the patch" + `Reviewed-
  by`
- **Stable nomination:** none in thread
- **NAKs/concerns:** none

### Step 4.2: Reviewers (b4 dig -w)
**Record:** CC'd: Michael Turquette, Stephen Boyd (clk maintainers),
Biju Das, linux-renesas-soc, linux-clk.

### Step 4.3: Bug report
**Record:** N/A — no external bug report or syzbot link.

### Step 4.4: Related patches
**Record:** Patches 1–2 are rzg2l refactors/cleanups, not required for
this fix.

### Step 4.5: Stable list
**Record:** Not searched separately; no stable discussion found in patch
thread.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key functions
**Record:** `cpg_mssr_clk_src_twocell_get()` (modified); context:
`cpg_mssr_is_pm_clk()`, `cpg_mssr_attach_dev()`,
`cpg_mssr_common_init()`.

### Step 5.2: Callers
**Record:** Registered via `of_clk_add_provider(np,
cpg_mssr_clk_src_twocell_get, priv)` at line 1192. Invoked indirectly by
`of_clk_get_hw_from_clkspec()` → `of_clk_get()`, `of_clk_get_by_name()`,
`of_clk_get_from_provider()` (exported). Reachable during device
probe/boot on Renesas DT platforms.

### Step 5.3: Callees
**Record:** array indexing into `priv->clks[]`, `dev_err()`,
`clk_get_rate()`, `IS_ERR()` checks.

### Step 5.4: Reachability
**Record:** Yes — common boot/probe path for Renesas R-Car/RZ boards
using `renesas,cpg-mssr` with `#clock-cells = <2>`. Normal OF parsing
usually supplies correct `args_count`, but `of_clk_get_from_provider()`
is exported and the callback has no framework-level cell-count guard.

### Step 5.5: Similar patterns
**Record:** Same file: `cpg_mssr_is_pm_clk()` checks `args_count != 2`.
Other Renesas drivers (`rzg2l-cpg.c`, `rzv2h-cpg.c`) check in PM paths
but not in their `*_twocell_get()` callbacks. `ux500_twocell_get()` does
check in the provider callback.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy code present?
**Record:** **Yes.** Tree is **linux-6.18.y** (`git describe HEAD` →
`v6.18.43-1-gc7f0dac02d232`, `make kernelversion` → `6.18.43`).
`cpg_mssr_clk_src_twocell_get()` at line 341 lacks the `args_count`
check. Upstream fix commits `7f0c422c7fbfd` / stable `1c79ea845f76d` are
**not** ancestors of current HEAD.

### Step 6.2: Backport complications
**Record:** Clean apply verified. Function is non-`static` in current
tree (was `static` in patch context); hunk still applies.

### Step 6.3: Related fixes already present?
**Record:** No — `git log --grep="clock cells check"` finds nothing on
current branch; grep confirms no `args_count` check in
`cpg_mssr_clk_src_twocell_get()`.

---

## Phase 7: Subsystem Context

### Step 7.1: Subsystem / criticality
**Record:** `drivers/clk/renesas/` — **IMPORTANT** (platform clock
provider for Renesas SoCs; affects boot and all clocked peripherals).

### Step 7.2: Activity
**Record:** Active in 6.18.y (recent reset-timing fixes in same file).

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who is affected
**Record:** Users of Renesas CPG/MSSR platforms (R-Car, RZ families)
with `CONFIG_CLK_RENESAS`. Not universal, but real production embedded
hardware.

### Step 8.2: Trigger conditions
**Record:** Malformed clock specifier (`args_count != 2`) reaching the
provider callback — e.g. direct `of_clk_get_from_provider()` misuse, or
non-standard caller paths. Normal DT parsing with `#clock-cells = <2>`
(binding-mandated) usually provides 2 cells. **Likelihood: low** for
well-formed DT; **non-zero** for internal/exported API misuse.

### Step 8.3: Failure mode severity
**Record:** Wrong clock returned or invalid index used → peripheral mis-
clocking, probe failure, or subtle hardware misbehavior. Unlikely kernel
panic (index range checks exist), but **MEDIUM** severity for embedded
correctness; not CRITICAL (no demonstrated crash/CVE).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** closes a real validation gap; aligns with same-file and
  cross-driver practice
- **Risk:** negligible (3-line guard, returns `-EINVAL`)
- **Ratio:** favorable, though absolute benefit is modest without a
  reported failure

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence summary

**FOR:**
- Real missing validation in a clock provider callback
- Same file already validates `args_count` in `cpg_mssr_is_pm_clk()`
- Trivial, maintainer-reviewed, applies cleanly
- Buggy code confirmed in 6.18.43
- Wrong clock lookup on SoC platforms is a meaningful failure mode

**AGAINST:**
- No user report, crash, or syzbot finding
- Normal OF/DT paths enforce cell count via `#clock-cells`
- Borderline on stable "important issue" threshold
- Part of a "fixes and cleanups" series alongside pure refactors

**UNRESOLVED:** No proof of real-world trigger on production boards.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — 3-line guard; reviewed by
   subsystem maintainer (no runtime test cited)
2. Fixes a real bug? **PASS** — uses specifier cells without validating
   count
3. Important issue? **PASS (borderline)** — correctness/hardware mis-
   clocking, not demonstrated crash/security
4. Small and contained? **PASS** — 3 lines, one function
5. No new features/APIs? **PASS**
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** None (not device ID, quirk, DT, build, or docs fix).

### Step 9.4: Decision rationale
For **linux-6.18.y**, the vulnerable code exists, the fix is surgical
and maintainer-vetted, and it closes an inconsistency that could yield
incorrect clock resolution on Renesas platforms. While no crash report
exists and normal DT parsing mitigates exposure, the fix is zero-risk
defensive correctness in a hardware-critical path — appropriate for
stable.

---

## Verification

- [Phase 1] Parsed commit message and tags from user query and `git show
  7f0c422c7fbfd`
- [Phase 2] Read current `renesas-cpg-mssr.c` lines 341–393; confirmed
  unconditional `args[1]` read
- [Phase 2] Compared with `cpg_mssr_is_pm_clk()` line 561 `args_count`
  check
- [Phase 3] `git blame` on function; `git log` on file
- [Phase 3] `git apply --check` on upstream patch: clean apply
- [Phase 3] `git merge-base --is-ancestor 7f0c422c7fbfd HEAD` → exit 1
  (fix not in tree)
- [Phase 4] `b4 dig -c 1c79ea845f76d`: found lore URL
- [Phase 4] `b4 dig -a`: v1 series, patch 3/3 standalone
- [Phase 4] `b4 dig -w`: clk + Renesas maintainers CC'd
- [Phase 4] Read `/tmp/cpg-mssr-thread.mbox`: Biju Das Reviewed-by, no
  stable nomination
- [Phase 5] Traced `of_clk_add_provider` → `of_clk_get_hw_from_clkspec`
  call chain in `clk.c`
- [Phase 5] Grep `args_count != 2` across `drivers/clk/`
- [Phase 6] `git describe HEAD` → v6.18.43; `make kernelversion` →
  6.18.43
- [Phase 6] Confirmed missing check in checked-out tree
- [Phase 6] Read DT binding `renesas,cpg-mssr.yaml`: `#clock-cells`
  const 2
- [Phase 8] Read `struct of_phandle_args` in `include/linux/of.h`:
  `args_count` + `args[MAX_PHANDLE_ARGS]`

**YES****Result:** Backport to **linux-6.18.y** is recommended.

The missing `args_count != 2` check in `cpg_mssr_clk_src_twocell_get()`
is a real validation gap (the function reads `args[1]` unconditionally).
The fix is 3 lines, applies cleanly to 6.18.43, and matches the existing
check in `cpg_mssr_is_pm_clk()` in the same file. No crash reports, but
it's low-risk defensive correctness on Renesas CPG/MSSR platforms.

**YES****Upstream commit:** `7f0c422c7fbfd` — *clk: renesas: cpg-mssr:
Add number of clock cells check* (Geert Uytterhoeven, Apr 30 2026).
There is also a stable-prepared variant at `1c79ea845f76d` referencing
that upstream SHA.

In the checked-out **linux-6.18.y** tree (`v6.18.43`), neither commit is
present yet; the missing validation is still in
`cpg_mssr_clk_src_twocell_get()`. Backport recommendation remains
**YES**.

 drivers/clk/renesas/renesas-cpg-mssr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index a0a68ec0490f7..87ede1ee64d7a 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -349,6 +349,9 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
 	struct clk *clk;
 	int range_check;
 
+	if (clkspec->args_count != 2)
+		return ERR_PTR(-EINVAL);
+
 	switch (clkspec->args[0]) {
 	case CPG_CORE:
 		type = "core";
-- 
2.53.0

