Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573675E0E33;
	Mon, 19 Oct 2026 14:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418560; cv=none; b=ge7lVD7eGtSki/l+TRZ4rBPL/uTXe57a0CO/i+QaB72/dihaBI+tXEEV2WOsge2T+kNjjFrjuHks30l9biH869xMLVfAvFGzhBHTPqJ9OdngjOxoidGjerBfLGCR7MYud6USAWDrVIy/7h9SnvMxth9uWcSQU6+NHqSTpMpeoSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418560; c=relaxed/simple;
	bh=phjmY77R9vdp2YNlR9ThV9kchmk5itDqPndXdPMMfhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iwPuaqwqEEWXpcScZoX21t6OUEfhcZoR1wMGcuAmO5KXWXB/TsNSIfG120Z5Uf2BrtAUIGz+bavSHQ33zvoNM4t6N1MkyM/5JutU3RP5oshJbr7vRp2KxLFP/o9E7bthPE7Jmjv55hwmS2SYOk57YZ7BBc3mPCJa92EzhNxuQfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aQa5Bjz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aQa5Bjz4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988231F000C5;
	Mon, 19 Oct 2026 14:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418558;
	bh=XgjQpS2/rMqW43pBel9lhFNhDOjVOLpqBUk6j73sCpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQa5Bjz4YsCTamSzypmFThC4dydqVhe+WF1Rcnntgv0LRNeEvw1wB3sNXpOEX5IyX
	 DaAhIVH94zE2a7IgjaYAMbUqY6HuFvrXqTs6krLVT/MbpVB2WdNlWOSROXGKqBcWOi
	 bn33kdTCemqiLv96JZ2oHvN/ssS1Gzm7RbdoCLRjGMs+kb5ShjuJNVAY/EAJUSC2Ix
	 h1npwxDKuqkUIv1ivHbp9otQVe3Q0XIXY3LmHB6+IEQSQzlN9P9QQBqOjWA7IijhF/
	 Q0ZxpcIn60CNPXZe05mAUUyVEOc1q7E0bI/XU3QSs3gGo7RwCBlky7ElGqk8nYD/Qa
	 ebbRWOQdJZ2nw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dmitry Osipenko <digetx@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	=?UTF-8?q?Jonas=20Schw=C3=B6bel?= <jonasschwoebel@yahoo.de>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	pgaikwad@nvidia.com,
	sboyd@kernel.org,
	bmasney+clk@redhat.com,
	jbrunet+clk@baylibre.com,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	linux-clk@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] clk: tegra: support 48MHz clock for pll_p_out1
Date: Mon, 19 Oct 2026 09:50:24 -0400
Message-ID: <20261019135441.1420968-333-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Transfer-Encoding: 8bit

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 46e31d69a547530fbef499bde888b6bb45a1deac ]

UEFI on Surface2 sets pll_p_out1 to 48MHz which is not supported by kernel
and causes BUG() early on. Add 48MHz clock support for pll_p_out1.

Acked-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Jonas Schwöbel <jonasschwoebel@yahoo.de>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **v7.3-rc4** (mainline). The change is a one-line
parent-rate case that stops a deterministic early-boot `BUG()` when UEFI
leaves `pll_p_out1` at 48 MHz. Surrounding `_calc_rate` logic has been
in-tree since 2013, so this is a self-contained crash fix, not a new
API.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[clk: tegra:] [support] [allow pll_p_out1 parent rate 48 MHz
in `_calc_rate` so firmware-programmed 48 MHz does not hit `BUG()`]**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Acked-by:** Thierry Reding `<treding@nvidia.com>` (Tegra maintainer)
- **Signed-off-by:** Dmitry Osipenko (author; long-time Tegra clk
  contributor)
- **Signed-off-by:** Jonas Schwöbel
- **Signed-off-by:** Svyatoslav Ryhel (submitter)
- **Signed-off-by:** Brian Masney (clk maintainer who applied it)
- **No Fixes:** tag (expected)
- **No Cc: stable** (expected)
- **No Reported-by / Tested-by / Link:**
- Ignore any Sasha Levin SOB if present in a candidate wrapper; none on
  the real commit `46e31d69a5475`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** UEFI on Microsoft Surface 2 programs `pll_p_out1` to 48 MHz.
  `_calc_rate()` only accepted 9.6 MHz and 28.8 MHz in that switch arm;
  48 MHz fell into `default:` which prints an error and calls `BUG()`.
- **Symptom:** kernel `BUG()` during early clock init (boot crash).
- **Root cause:** missing parent-rate case in the out-of-table PLL
  calculator used when PLLA’s freq table has no matching input rate.
- **Version info:** none in the message. Cover letter (v2 0/1) says the
  case is aligned with NVIDIA downstream 3.4 tegra114 logic.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not a hidden fix.** Subject says “support” but the body is
explicit: this prevents `BUG()`. It is a firmware/hardware compatibility
quirk, not a new clock API.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/clk/tegra/clk-pll.c` (+1 / −0)
- **Function:** `_calc_rate()`
- **Scope:** single-file, one `case 48000000:` added next to existing
  9.6/28.8 MHz cases

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `parent_rate == 48000000` → `default` → `pr_err` +
  `BUG()`.
- **After:** same arm as 9.6/28.8 MHz: `cfreq = parent_rate /
  (parent_rate / 1000000)` (1 MHz for 48 MHz), then existing M/N/P
  calculation and range checks.
- **Path:** clock-init `clk_set_rate()` on PLLA (and any other PLL using
  default `_calc_rate`). Error path only in the sense that the old path
  was a fatal default; this is the out-of-table rate calculator, not a
  new userspace API.

Verified boot path in this tree:
- Tegra114 `init_table` sets `TEGRA114_CLK_PLL_A` to 564480000 (`clk-
  tegra114.c`).
- `tegra_init_from_table()` calls `clk_set_rate()`.
- PLLA parent is `"pll_p_out1"` (`tegra114_audio_plls[]`).
- `pll_a_freq_table[]` only lists 9600000 and 28800000 input rates, so
  `_get_table_rate()` fails and `_calc_rate()` runs.
- That is the `BUG()` the commit describes.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** (h) hardware/firmware workaround + (g) logic: missing
  switch case that caused (kernel `BUG()`).
- **Mechanism:** firmware leaves a valid PLLP divider output of 48 MHz;
  the calculator treated it as an impossible reference and crashed.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Quality:** obviously correct. Same formula already used for the
  other PLLP_OUT1 rates. Tegra maintainer acked it.
- **Minimal:** one line, no API/data-structure change.
- **Regression risk:** very low. Extra parent rate only changes the 48
  MHz path; other rates unchanged.
- **Nuance (verified):** tegra114 PLLA uses `pllp_nmp.divm_width = 5`,
  so `divm_max` is 31. For 48 MHz, `cfg->m = 48`, which can fail the
  existing `cfg->m > divm_max` check and return `-EINVAL` instead of
  programming PLLA. That is still far better than `BUG()`:
  `clk_pll_set_rate()` then `WARN_ON`s and returns. Completeness of PLLA
  programming is a separate issue; the crash is fixed.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Switch and `BUG()` introduced in **`8f8f484bf355e5`** (“clk: tegra:
  add Tegra specific clocks”, Prashant Gaikwad, 2013-01-11; in v3.9
  era).
- 9.6/28.8 MHz formula adjusted in **`e52d7c04bb3911`** (2015).
- 48 MHz case added by **`46e31d69a5475`** (this commit).
- Buggy missing-rate behavior has been present for ~13 years.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Not applicable. Introduced by the original
2013 Tegra clk driver, not a recent regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `clk-pll.c` commits are unrelated (GFP helpers,
`determine_rate`, RPM). This commit is **standalone**, not patch X/Y of
a clk series. Author/submitter Tegra DT work around the same time
(TF600T, grouper, tegra114 EMC) does not need to land with this 1-line
clk case.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Dmitry Osipenko is a regular Tegra clk contributor (`Don't allow
zero clock rate`, PLLU config, gate refcounting, etc.). Submitter Ryhel
resubmitted with maintainer Ack. Applied by Brian Masney.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** Diff only adds a `case` label. `_calc_rate`, the
9.6/28.8 arm, and `BUG()` default all exist in this file independently
of later refactors. Can apply standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **b4 dig:**
  https://patch.msgid.link/20260427132447.118272-2-clamor95@gmail.com
- **v1:** 2026-04-17 `20260417073452.23342-2-clamor95@gmail.com`
- **v2 / resend:** 2026-04-27 (cover + patch); Thierry Ack 2026-05-28
- Cover letter: “Fix this by adding 48MHz clock support… aligned with
  downstream 3.4 kernel for tegra114 logic”
- **No NAK.** Only reviewer reply was Thierry’s **Acked-by**.
- **No Cc: stable** in review (absence is not a negative).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record: Recipients included Stephen Boyd, Michael Turquette, Thierry
Reding, Jonathan Hunter, linux-clk, linux-tegra. **Thierry Reding
acked.** Right maintainers were on the thread.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot link. Description is a concrete
firmware+hardware trigger (Surface 2 UEFI), not theoretical. Surface 2
has **no in-tree DT** (tegra114 boards present: dalmore, roth, tn7,
asus-tf701t only). Users still hit this with UEFI + out-of-tree/work-in-
progress DT; the clk driver is in-tree for all Tegra114.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Series is **v2 0/1 + 1/1**. Self-contained. No sibling patch
required for the `BUG()` fix.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** — lore.kernel.org returned 403 (Anubis). Original
linux-tegra/linux-clk thread was retrieved via `b4 dig -m`; no stable-
list discussion in that mbox.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS
Record: **`_calc_rate()`** only.

Step 5.2: TRACE CALLERS
Record:
- Default `pll->params->calc_rate` in `_tegra_clk_register_pll()` for
  non-PLLM PLLs.
- Called from **`clk_pll_set_rate()`** and
  **`clk_pll_determine_rate()`** when `_get_table_rate()` misses.
- Tegra210 PLLs use `tegra210_pll_fixed_mdiv_cfg` instead; this path is
  **tegra20/30/114/124**.
- Context: boot clock init and later audio PLL rate changes. Not a
  syscall-hot path, but **every boot** on affected firmware.

Step 5.3: TRACE CALLEES
Record: Integer divider math only (`cfreq`, `m`/`n`/`p`). No allocation,
no locks inside `_calc_rate`. `clk_pll_set_rate` takes `pll->lock` after
calc.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
`tegra114_clock_init` → `tegra_clk_apply_init_table` →
`tegra_init_from_table` → `clk_set_rate(pll_a, 564480000)` →
`clk_pll_set_rate` → `_calc_rate`.
**Reachable from boot on Tegra114 when parent is 48 MHz.** Unprivileged
userspace is not required; firmware state is enough.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same `_calc_rate` switch is the single shared calculator. No
duplicate 48 MHz holes in sibling functions. Freq tables still lack 48
MHz PLLA rows (out-of-table path is intentional, per comment).

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Tree: **`git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`**,
  `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`.
- `git merge-base --is-ancestor 46e31d69a5475 HEAD` → **already in this
  checkout** (landed in v7.3-rc1).
- The **vulnerable pattern** (`_calc_rate` switch + `BUG()` on unknown
  parent rate) is here and dates to 2013. The 48 MHz hole is what this
  commit fills. This is not post-7.3 code; older stables that still lack
  the case have the bug.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on any tree that still has the 9.6/28.8 arm
without `case 48000000:`. Context in this file is stable. No backport
rewrite needed.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This **is** the fix (`46e31d69a5475`). No earlier alternate 48
MHz handling in `clk-pll.c`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **drivers/clk/tegra** — SoC clock driver. **IMPORTANT** for
NVIDIA Tegra 20/30/114/124, not core-mm/VFS. Boot-blocking on those
SoCs.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature driver (2013), still receiving fixes. This is a long-
standing hole, not churn from a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Platform/firmware-specific:** Tegra boards whose firmware sets
`pll_p_out1` to 48 MHz. Documented trigger is **Surface 2 UEFI**. Any
tegra20/30/114/124 PLL using default `_calc_rate` with that parent rate.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: **Every boot** with that firmware, during CAR init table
application. Not a race. Not unprivileged-syscall; **unusable machine**
if you boot Linux on that hardware.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **`BUG()` on boot → CRITICAL** for affected devices (oops/panic,
system does not come up). After the fix, worst case on tegra114 is
`-EINVAL` + `WARN_ON` if M overflows, not a hard `BUG()`.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** high for those devices (boot vs die); moderate overall
  (narrow hardware).
- **Risk:** very low (one `case` label, existing formula).
- **Ratio:** strongly favors taking it. Matches the **hardware quirk**
  stable exception (USB/PCI quirk analogue: one-line table addition so
  existing driver survives real firmware).

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Deterministic early-boot `BUG()`, verified via init_table →
  `clk_set_rate(pll_a)` → `_calc_rate`.
- One-line, obviously correct, same math as 9.6/28.8 MHz.
- Acked by Tegra maintainer Thierry Reding; applied by clk maintainer.
- Code path present since 2013; no prerequisites.
- Hardware/firmware quirk, not a new UAPI.

**AGAINST:**
- Subject looks like a feature (“support 48MHz”).
- Surface 2 DT is not in mainline; user population is small.
- PLLA 5-bit M may still reject the computed `m=48` (WARN instead of
  BUG). Incomplete programming, but the crash is gone.
- No syzbot/CVE/Fixes tag (expected for this review queue).

**UNRESOLVED:**
- Stable-list discussion (lore 403).
- Whether every tegra114 board with 48 MHz pll_p_out1 can actually lock
  PLLA after this; downstream 3.4 used this same case.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one case, maintainer Ack, in
   mainline since v7.3-rc1.
2. Fixes a real bug that affects users? **PASS** — UEFI Surface 2 (and
   same firmware pattern) `BUG()` at boot.
3. Important issue? **PASS** — boot `BUG()`, severity CRITICAL for that
   hardware.
4. Small and contained? **PASS** — +1 line, one function.
5. No new features or APIs? **PASS** — quirk: accept a parent rate the
   hardware/firmware already programs. No new sysfs/uapi/driver.
6. Can apply to the local tree? **PASS** — surrounding `_calc_rate`
   exists; patch is a single case add (already present on this 7.3-rc4
   HEAD because the candidate came from this lineage).

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Hardware quirk/workaround** (firmware-programmed clock the
driver must not `BUG()` on). Analogous to USB/PCI quirk table entries.

Step 9.4: MAKE YOUR DECISION
This is a surgical boot-crash fix for a real firmware configuration. It
meets stable rules and the quirk exception. Limited hardware does not
disqualify it: obscure-device quirks are routinely taken. Incomplete
PLLA table entries do not restore the `BUG()`, so they are not a reason
to reject.

What problem it solves: Tegra `_calc_rate()` treated 48 MHz `pll_p_out1`
as illegal and called `BUG()` while setting PLLA during clock init.
Surface 2 UEFI programs that rate.

Risk vs benefit: one `case` vs a boot panic. Benefit dominates.

Concerns: no in-tree Surface 2 DT; possible later `-EINVAL` if M
overflows. Neither makes the `BUG()` acceptable to leave in stable.

Verification:
- [Phase 1] Tags: Acked-by Thierry Reding; SOBs Osipenko, Schwöbel,
  Ryhel, Masney; no Fixes/Cc-stable/Reported-by
- [Phase 2] Diff: +1 line `case 48000000:` in `_calc_rate()` in
  `drivers/clk/tegra/clk-pll.c`
- [Phase 2] tegra114 `init_table` sets PLLA 564480000; parent
  `pll_p_out1`; freq table has no 48 MHz input → `_calc_rate` on boot
- [Phase 2] `divm_width=5` → m=48 may `-EINVAL` after the fix; `BUG()`
  still avoided
- [Phase 3] git blame: switch/`BUG()` from `8f8f484bf355e5` (2013); this
  commit `46e31d69a547530fbef499bde888b6bb45a1deac`
- [Phase 3] `git merge-base --is-ancestor 46e31d69a5475 HEAD` → already
  in this 7.3-rc4 tree
- [Phase 3] No Fixes tag; standalone; no prerequisite commits
- [Phase 4] `b4 dig -c 46e31d69a5475` → lore patch-id match; v1
  2026-04-17, v2 2026-04-27
- [Phase 4] `b4 dig -a`: v1 then v2 (“aligned with downstream 3.4”)
- [Phase 4] `b4 dig -w`: linux-clk, linux-tegra, Thierry, Boyd, Hunter
- [Phase 4] mbox: Thierry Acked-by; no NAK
- [Phase 4] lore WebFetch 403; stable list UNVERIFIED
- [Phase 5] callers: `clk_pll_set_rate`, `clk_pll_determine_rate`;
  default calc_rate for non-PLLM
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; Makefile
  7.3.0-rc4; file and BUG() default present
- [Phase 6] No other 48 MHz pll_p_out1 fix in this file
- [Phase 7] clk/tegra, important for Tegra SoCs
- [Phase 8] Failure mode: `BUG()` at boot, CRITICAL for affected
  firmware
- UNVERIFIED: stable@ discussion; whether PLLA actually locks at 564.48
  MHz with 48 MHz parent on Surface 2 hardware

**YES**

 drivers/clk/tegra/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/tegra/clk-pll.c b/drivers/clk/tegra/clk-pll.c
index 591b9f0c155a0..e48ca3f4b5f86 100644
--- a/drivers/clk/tegra/clk-pll.c
+++ b/drivers/clk/tegra/clk-pll.c
@@ -575,6 +575,7 @@ static int _calc_rate(struct clk_hw *hw, struct tegra_clk_pll_freq_table *cfg,
 		break;
 	case 9600000:
 	case 28800000:
+	case 48000000:
 		/*
 		 * PLL_P_OUT1 rate is not listed in PLLA table
 		 */
-- 
2.53.0

