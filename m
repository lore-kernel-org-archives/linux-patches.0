Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902E24FB9C8;
	Mon, 19 Oct 2026 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418101; cv=none; b=JpkACvrFP+ouGoWrDhnilVMl/HGlxm/Cd6FQHgP4Jw2ovHENEeUvJEUe5GllSAxtI9RVkh8HsbZuVehDZYtYehqs5cAa6/VowoiOcUuNQ6bFNddpvQZzXPtH6Q7qFyGSkWySVaBe14NI333vPywJVCc7bre93EW2Ffee8fxKCh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418101; c=relaxed/simple;
	bh=gpt8FEJHz1+S4gOVs6LOvjK1m+Z2FLthcasCJKM43vM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hfrb66K3FcTjU89Bfem7k2yXUGfzPGAM7pC01blT3Lk9GWZzcmWzW+C25BLsFrZVspykWRRNim6tXPObJqM+xJuE0o1fU41rs4v/yNhdgQUv3geKSbP8tKjLK6FLJl1vZCXlYuZc7tUYveIqXGz8a1W0rzSFWwLFyQGvoH2fhIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k5iR44kX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k5iR44kX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2259E1F000C8;
	Mon, 19 Oct 2026 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418098;
	bh=p7dQuIYTx5ffWc1FZrQEt22Lmki8g5R6kxN/Ih3uynY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5iR44kX5YCJh5crQypslIIQBhbiqeSUv+dPjXfmf+8UuT6apjLdKkXPPPvVFyo6u
	 VJzq1cy3bcv4gZ0ODcMV7s8fHA6EnGAQkslFPkQdHtL6G4PQFcGWXTXCIFb7Jk/1/H
	 2/ovptFYjnGwM2+87qiPdFgklk8MWxifBY8ga12jVooRYYD2zke7DSpsz0L3mIyG/p
	 DJUv2VY79GcWVnwZubXsHSQsGtdT3KO8e1r+sCMTXHQt33L+Nqy1SYNUxhTXB1wGt7
	 0OkRb5l7Gm6GjKmk5veYClrD2Rzw2j3hYrLKotnyFHEBbObLHHNos+7XDVIsY25qPk
	 fqOl87RZZSH5A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Colin Foster <colin.foster@in-advantage.com>,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	michal.simek@amd.com,
	anatoliy.klymenko@amd.com,
	linux-clk@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] clk: clocking-wizard: fix clock difference detection
Date: Mon, 19 Oct 2026 09:45:02 -0400
Message-ID: <20261019135441.1420968-11-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Colin Foster <colin.foster@in-advantage.com>

[ Upstream commit 006ba909c240b832c876b7aed29c6beec9d1f5e5 ]

Reviewed-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The
change is a one-line restoration of `abs()` in Xilinx Clocking Wizard
divisor search: unsigned wrap made frequencies below the request look
like ~2^64 error, so they were ignored.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[clk / xilinx clocking-wizard] [fix] [clock difference
detection]** — restore correct closest-match comparison when computed
frequency is below the requested rate.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record (from `git show 006ba909c240b`):
- Reviewed-by: Shubhrajyoti Datta \<shubhrajyoti.datta@amd.com\>
  (Xilinx/AMD clocking-wizard author)
- Reviewed-by: Brian Masney \<bmasney@redhat.com\> (clk co-maintainer;
  also committer)
- Signed-off-by: Colin Foster \<colin.foster@in-advantage.com\> (author)
- Signed-off-by: Brian Masney \<bmasney@redhat.com\>
- No Fixes:, Cc: stable, Reported-by, Tested-by, Link, or Acked-by in
  the **merged** commit
- Absence of Fixes/Cc:stable is expected for this review pipeline and is
  not a negative

The merged git message has **no body**. The mailing-list submission did
(see Phase 4).

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Merged commit: subject + tags only.

Mailing-list body (from b4 mbox, not in git): unsigned “rollover” in
`diff = freq - rate`. Frequencies below the request produced diffs like
`18446744073708237796` (2^64 wrap) and were not considered. Author
included before/after traces at 133312500 Hz / parent 99999000 Hz.

Cover letter: this is patch **1/3** of “clock-wizard fixups”. The series
also optimizes exact-match search (2/3) and removes the 20 kHz
`WZRD_MIN_ERR` cutoff (3/3). Cover letter: the 20 kHz check made **out-
of-tree consumers fail `clk_set_rate`**; patch 1 is the separate
difference-calculation bug.

Record: **[Bug: unsigned underflow when freq \< rate] [Symptom: wrong
closest match and/or -EBUSY from set_rate/determine_rate] [Root cause:
abs() dropped in a later refactor] [No version tags in the commit
itself]**

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not hidden.** Subject says “fix”. It is a real comparison bug,
not cleanup.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/clk/xilinx/clk-xlnx-clock-wizard.c` — **1 insertion, 1
  deletion**
- Function: `clk_wzrd_get_divisors()`
- Scope: **single-file surgical one-liner**
- Versal sibling `clk_wzrd_get_divisors_ver()` is **not** changed
  (already uses `abs()`)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Before: `diff = freq - rate` with `freq`/`diff` as `u64`. If `freq <
rate`, subtraction wraps. `best_diff` starts at `-1ULL`. Wrapped diffs
lose to any over-rate candidate; if every candidate is under-rate,
`best_diff` stays huge and `return best_diff < WZRD_MIN_ERR ? 0 :
-EBUSY` returns **-EBUSY** (20 kHz threshold still present in the parent
of this commit).

After: `diff = abs(freq - rate)` so both sides of the target compete;
closest match wins.

Path: clock **determine_rate / set_rate** for non-Versal Clocking Wizard
(dynamic reconfig / fractional M and O).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[Logic / correctness + unsigned wrap]** — `abs()` was dropped
when 7681f64e6404ed switched the search to `u64` and `best_diff`.
Original v6.4 code in 595c88cda65d30 used `diff = abs(freq - rate)`.
This restores that.

Kernel `abs()` on the `u64` difference works here: wrap of a small Hz
delta becomes a negative `signed long long`, then `abs()` yields the
true delta. Clock Hz values are far below 2^63. Same pattern as the
Versal function.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: **Obviously correct, minimal, matches the pre-regression and
Versal code.** Regression risk is low: set_rate may now succeed with a
slightly-below rate instead of failing or picking a worse over-rate.
That is the intended fix. `abs_diff()` would be cleaner with matching
types, but reviewers accepted `abs()`, and it matches the sibling.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Current `abs()` line: **006ba909c240b** (this commit), 2026-06-29
- Surrounding fractional search: **7681f64e6404ed** (“calculate dividers
  fractional parts”), 2025-01-06, **v6.13-rc1**
- Function introduced: **595c88cda65d30** (v6.4-rc1) **with abs()
  already**
- 7681f64e **removed** `abs()` and used `diff = freq - rate`

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Buggy commit is **7681f64e6404ed**, ancestor
of HEAD (`git merge-base --is-ancestor`).

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: 3-patch series, same author/date:
1. **006ba909c240b** — this fix (1/3)
2. **9329714414d1f** — early-out on exact match (optimization, 2/3)
3. **54ed94b709e03** — drop 20 kHz `WZRD_MIN_ERR` (3/3)

This patch is **standalone**. It does not need 2/3 or 3/3. With the 20
kHz check still present, `abs()` is what lets a close **under**-rate
pass `best_diff < 20000` instead of wrapping to -EBUSY.

Related: **4adf593c6fc5a** overflow fix in the same file (`Cc: stable`,
Fixes: 7681f64e). **e0a94c6bb5b48** (v6.18-rc1) already used `abs()` on
the Versal path.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Colin Foster is not the historical driver author (that is
Shubhrajyoti Datta / AMD). Datta reviewed this. Foster’s three clocking-
wizard commits are this series.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: Needs `clk_wzrd_get_divisors()` with `u64` `freq`/`diff` as in
7681f64e. That is in this tree. **Applies standalone.** `abs()` is in
`include/linux/math.h`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 006ba909c240b` →
  https://patch.msgid.link/20260629205346.3228886-2-colin.foster@in-
  advantage.com
- `b4 dig -a`: only **PATCH v2 1/3** (v2: rebase + signoffs). v1 not in
  the matched thread.
- Saved mbox: cover + 3 patches, **no reply NAKs** in that thread
- WebFetch/curl to lore.kernel.org: **403** — discussion beyond the mbox
  is UNVERIFIED

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` To/Cc: linux-clk, linux-arm-kernel, linux-kernel,
Shubhrajyoti Datta, Michal Simek, Brian Masney, Stephen Boyd, Michael
Turquette.

Record: **Clk lists + clk maintainers CC’d; Reviewed-by from AMD driver
author and Brian Masney.**

**Step 4.3: SEARCH FOR THE BUG REPORT**
No syzbot/bugzilla. Evidence is the author’s traces (unsigned wrap
~2^64) and cover-letter `clk_set_rate` failures.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: **v2 0/3 “clock-wizard fixups”.** 1/3 is this logic fix; 2/3
optimization; 3/3 policy (allow error ≥ 20 kHz). 1/3 does not depend on
the others.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search returned **403**. UNVERIFIED
whether stable@ discussed it.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP: **not available**. Used grep + callers in this file.

**Step 5.1: KEY FUNCTIONS**
Record: **`clk_wzrd_get_divisors()`** only.

**Step 5.2: TRACE CALLERS**
- `clk_wzrd_dynamic_all_nolock()` → `clk_wzrd_dynamic_all()` →
  `clk_wzrd_clk_div_all_ops.set_rate`
- `clk_wzrd_determine_rate_all()` →
  `clk_wzrd_clk_div_all_ops.determine_rate`

Versal ops use `clk_wzrd_get_divisors_ver()`, already using `abs()`.

**Step 5.3: TRACE CALLEES**
`div64_u64`, `DIV_ROUND_CLOSEST_ULL`, writes into
`divider->{m,m_frac,d,o,o_frac}`. No allocation/locking inside the
search.

**Step 5.4: FOLLOW THE CALL CHAIN**
Probe registers outputs with `clk_wzrd_clk_div_all_ops` for non-Versal
dynamic-reconfig Clocking Wizard (`xlnx,clocking-wizard`, v5.2, v6.0).
`clk_set_rate` / `clk_round_rate` from consumers (display pixel clocks
were the reason fractional M/O were added).

Record: **Reachable from userspace/driver clock APIs on that IP. Not a
syscall bug by itself; standard clk consumer path.**

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Versal `clk_wzrd_get_divisors_ver()` already has `diff = abs(freq -
rate)` (e0a94c6bb5b48). Original non-Versal code had abs() until
7681f64e dropped it.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **v7.3-rc4** / Makefile **7.3.0-rc4**
- File and `clk_wzrd_get_divisors()` **exist**
- HEAD already has `diff = abs(freq - rate)` because **006ba909c240b is
  an ancestor** (`git merge-base --is-ancestor` → yes). `git describe
  --contains` → **v7.3-rc1**
- Bug introduced **v6.13** (7681f64e), long before 7.3
- Pre-fix code (parent of 006ba909) still had `diff = freq - rate` and
  `WZRD_MIN_ERR` 20000

This is **not** “bug added after this branch.” The driver and the
regression are part of this 7.3 line.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
On **this** checkout the one-liner is already applied; a second apply
would not change anything. Against the pre-fix function the hunk is
context-identical (one line). Expected difficulty: **clean apply** on a
tree that still has `diff = freq - rate`.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This exact fix **is** in HEAD, plus 2/3 and 3/3. That is the
mainline landing, not a separate in-tree workaround. No competing
alternate fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **`drivers/clk/xilinx/`** — Xilinx Clocking Wizard
(`CONFIG_COMMON_CLK_XLNX_CLKWZRD`, `depends on OF`). **PERIPHERAL /
platform-specific** (FPGA/SoC), but it is the clock provider for that
IP, including pixel-clock accuracy.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Active through 2025–2026 (fractional dividers, Versal, overflow
fix, this series). Mature in-tree driver, not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** —
`COMMON_CLK_XLNX_CLKWZRD`, non-Versal Clocking Wizard with dynamic
reconfig / fractional search. Not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: **`clk_set_rate` / determine_rate** when the closest achievable
frequency is below the request, or when under-rate candidates must
compete with worse over-rate ones. Common for arbitrary pixel/device
rates. Unprivileged userspace can hit it if a consumer exposes clock
control; typically a device driver at probe/modeset.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Wrong clock chosen or `clk_wzrd_get_divisors()` returns
-EBUSY** so rate set fails. Not oops/UAF/deadlock. Author showed
wraparound and `clk_set_rate` failure in the series. **Severity:
MEDIUM** (functional breakage on that hardware, including display
clocks).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record: **Benefit: medium** for Clocking Wizard users (correct closest
rate; fewer false -EBUSY). **Risk: very low** (1 line, same as
old/Versal code). **Ratio: favorable.**

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real unsigned wrap; traces show ~2^64 diffs for freq \< rate
- Regression: 595c88cd used `abs()`; 7681f64e dropped it in v6.13
- Restores closest-match; can avoid -EBUSY under the 20 kHz check
- 1 line, obviously correct
- Reviewed by AMD driver author and clk co-maintainer
- Driver and function exist in this 7.3 tree; bug predates 7.3
- Standalone; not a new API

AGAINST:
- Merged commit message has no body (explanation only on list)
- Not crash/security/corruption
- Peripheral Xilinx FPGA/SoC driver
- Cover letter also talks about OOT consumers and patch 3’s 20 kHz
  policy
- Author’s 133312500 Hz sample still picked the over-rate 19500 Hz
  candidate; abs() matters when the **best** match is below the request
- lore.kernel.org HTTP 403; no stable@ thread verified

UNRESOLVED:
- Full v1 review thread
- Whether stable@ already took this (403)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — wrap math is clear; author
   posted before/after; two Reviewed-by
2. Fixes a real bug that affects users? **PASS** — wrong diffs; set_rate
   can fail or pick a worse rate
3. Important issue? **PASS** (medium) — not a panic, but the driver’s
   job is correct rates; pixel-clock path was the reason fractional
   search exists
4. Small and contained? **PASS** — 1 line, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — same function is here; HEAD
   already contains this commit as of v7.3-rc1, which means 7.3’s own
   code already includes the fix. That does not make the fix unsuitable;
   it confirms the code matches.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: **None** (not a device ID, quirk, DT, build, or docs exception).
It is a normal small correctness fix.

**Step 9.4: MAKE YOUR DECISION**

This tree is 7.3-rc4 and already contains the line, because the commit
landed in v7.3-rc1. The decision is still whether this is appropriate
**for this tree’s code**, not whether the pipeline already “selected”
it.

It is a **v6.13 regression** (accidental drop of `abs()`), one line,
reviewed, and it fixes real closest-rate / -EBUSY behavior on Xilinx
Clocking Wizard. That meets stable rules for this checkout. Later series
patches (search micro-opt, dropping 20 kHz) are separate and not
required.

===============================================================
DETAILED EXPLANATION
===============================================================

**Problem:** `clk_wzrd_get_divisors()` ranked candidates with unsigned
`freq - rate`. Any frequency below the request wrapped to ~2^64, so
those configs were ignored. Combined with `best_diff < 20000`, that
yields **-EBUSY** when the only close match is slightly low, or a
**worse higher** clock when a closer lower one exists. That is exactly
the fractional-divider accuracy the v6.13 work was supposed to provide
(pixel clocks).

**Why it matters here:** This 7.3 tree has that search (7681f64e).
Consumers of `xlnx,clocking-wizard` that call `clk_set_rate` can fail or
lock the IP to the wrong rate.

**Stable rules:** Small, obvious, real bug, no new API. Risk is a
correct rate instead of failure/wrong rate.

**Concerns:** Empty merged commit message; not a crash. Series 3/3 is a
policy change and should not be required. No backport rework is needed
on a tree that still has `diff = freq - rate`.

===============================================================
Verification:
- [Phase 1] `git show 006ba909c240b`: subject+tags only; Reviewed-by
  Datta and Masney; no Fixes/stable
- [Phase 1] b4 mbox body: wraparound explanation and traces (133312500
  Hz)
- [Phase 2] Diff: one line `diff = freq - rate` → `diff = abs(freq -
  rate)` in `clk_wzrd_get_divisors`
- [Phase 2] Parent still has `return best_diff < WZRD_MIN_ERR ? 0 :
  -EBUSY` with `WZRD_MIN_ERR` 20000
- [Phase 2] `include/linux/math.h`: `abs()` signed conversion; Hz deltas
  fit
- [Phase 3] blame: abs line is 006ba909; search from 7681f64e6404ed
  (v6.13-rc1)
- [Phase 3] 595c88cda65d30 originally used `diff = abs(freq - rate)`;
  7681f64e removed it
- [Phase 3] `git merge-base --is-ancestor 006ba909c240b HEAD` → yes;
  `--contains` → v7.3-rc1
- [Phase 3] Series 006ba909, 9329714414d1f, 54ed94b709e03; this patch is
  1/3 standalone
- [Phase 4] `b4 dig -c`:
  patch.msgid.link/20260629205346.3228886-2-colin.foster@in-
  advantage.com
- [Phase 4] `b4 dig -a`: v2 1/3 only in match; cover v2 rebase +
  signoffs
- [Phase 4] `b4 dig -w`: linux-clk, Boyd, Turquette, Datta, Simek,
  Masney
- [Phase 4] WebFetch/curl lore: 403; stable@ discussion UNVERIFIED
- [Phase 5] Callers: `clk_wzrd_dynamic_all_nolock`,
  `clk_wzrd_determine_rate_all` (non-Versal ops)
- [Phase 5] Versal sibling already `abs()` via e0a94c6bb5b48 (v6.18-rc1)
- [Phase 6] `git describe HEAD` v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` 7.3.0-rc4
- [Phase 6] HEAD already has `diff = abs(freq - rate)` at lines 375 and
  416
- [Phase 7] Kconfig `COMMON_CLK_XLNX_CLKWZRD`; compatibles
  xlnx,clocking-wizard{,-v5.2,-v6.0}
- [Phase 8] Failure mode: wrong rate or -EBUSY on set_rate; severity
  MEDIUM
- UNVERIFIED: v1 thread contents; stable@ history (lore 403)
===============================================================

**YES**

 drivers/clk/xilinx/clk-xlnx-clock-wizard.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
index dbef983eb4252..4ef0595f7d993 100644
--- a/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
+++ b/drivers/clk/xilinx/clk-xlnx-clock-wizard.c
@@ -406,7 +406,7 @@ static int clk_wzrd_get_divisors(struct clk_hw *hw, unsigned long rate,
 			if (o < omin || o > omax)
 				continue;
 			freq = DIV_ROUND_CLOSEST_ULL(vco_freq, o);
-			diff = freq - rate;
+			diff = abs(freq - rate);
 			if (diff < best_diff) {
 				best_diff = diff;
 				divider->m = m >> 3;
-- 
2.53.0

