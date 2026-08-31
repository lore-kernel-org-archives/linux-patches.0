Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861AB442FBD;
	Mon, 31 Aug 2026 13:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183235; cv=none; b=dBmKgRHQ3ouwodwLbDNVi+GBb6Djupq3lByLP8AqXKmfHZjhyde6xisn6fyOdMTXKd2x6/T6uYVu8PfoqjbxLfPh4BqB5JbomYsjxztQmgrVpGDJOBYsb/wsc17y/Bgd96nVYW8BCu2i/8dqvAx3V/j09ibcVQLbtXk5bmsp3wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183235; c=relaxed/simple;
	bh=mkI9VswO56vZpnoBoy57oMtE7LXg6haYUYV0vOybfec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y0WCRBgrwmNZHAFpDPKxRQ9aDbmAROoOXthsEEhdSG+NHXNL1yRY2RNaYUkhZnmm/mL8lJ3+PDkc/30X0he45lG0T0u4675MqrIN4ulOLqc1A66SRAggyfgcTt/ReFErzq0O4Ji2Qs3PRNTD5WlUpbwt6MS/RadclYhAMQpd8L8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bPI0vGdP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bPI0vGdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A5F1F000E9;
	Mon, 31 Aug 2026 13:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183233;
	bh=aFkks/A+ol/d7cAt7ToE7M6SYub+EULEhxRYoYglep4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPI0vGdPkpdCMBDXclBwL/391cBZmIK/CutUHWc7KHM8UB1Ar3WDNLK44QMSA8zKl
	 8VrHDA1joCHFXPZprb8CKxgh8ddQfokLsCFHGbKVThaB6KJFQV4kLjUUuj296WfPwO
	 VNM2NHgCRneZiHasctbMxk/9dvbUsNlHytF4RiOCSBLp3D7dThtCvTwwx0HiGygGbi
	 S2lVegIDkRG3fbIWzqgXw39XSR7GmGcqDLPmSS7F3v79315d1UsZyPwAqxM0CrUsBr
	 5V14i1qlR6Y8ddI2zeCifd9MxwLfRR1sCKYzv4+lMHVEdfj6EeD8jfxZS930dsGjtI
	 JMeU/lQdqPU+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] mmc: renesas_sdhi: Add OF entry for RZ/G2N SoC
Date: Mon, 31 Aug 2026 09:20:53 -0400
Message-ID: <20260831133314.4125787-25-sashal@kernel.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 5ce500d31a1625d8fe7ede950201b8df076bdd48 ]

The RZ/G2N (R8A774B1) SoC was previously handled via the generic
"renesas,rcar-gen3-sdhi" fallback compatible string. However, because
the SDHI IP on RZ/G2N is identical with the R-Car M3-N (R8A77965), it
requires the specific quirks and configuration defined in
`of_r8a77965_compatible` rather than the generic Gen3 data.

Add the explicit "renesas,sdhi-r8a774b1" match entry to map it correctly.
Note that the DT binding file renesas,sdhi.yaml does not need an update
as the entry for this SoC is already present.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `mmc: renesas_sdhi: Add OF entry for RZ/G2N
SoC`

**Local tree:** `v6.18.44` (stable/linux-6.18.y)
**Upstream commit:** `5ce500d31a1625d8fe7ede950201b8df076bdd48`

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[mmc/renesas_sdhi]` `[Add]` — Add explicit OF device-tree
match entry for RZ/G2N (R8A774B1) SoC SDHI controller.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Lad Prabhakar, Ulf Hansson (MMC maintainer)
- **Reviewed-by:** Wolfram Sang (Renesas SDHI maintainer), Geert
  Uytterhoeven (Renesas DT maintainer)
- **No Fixes:** tag
- **No Reported-by:** tag
- **No Cc: stable** in the committed upstream message (present in
  mailing-list submission for the series)
- **No Link:** tags

Notable: Both subsystem maintainers reviewed; this is patch 2/3 of a
series nominating all three RZ/G2 patches for stable.

### Step 1.3: Body Analysis
**Record:**
- **Bug:** RZ/G2N SDHI nodes use `"renesas,sdhi-r8a774b1"` as primary
  compatible, but the driver lacked an explicit OF match entry. Matching
  fell through to the generic `"renesas,rcar-gen3-sdhi"` fallback
  (`of_rcar_gen3_compatible`), which has **no SoC-specific quirks**.
- **Symptom:** Missing `sdhi_quirks_r8a77965` (HS400 tap correction,
  bad-tap avoidance, calibration table) that R-Car M3-N (R8A77965) — the
  IP-identical counterpart — requires.
- **Root cause:** OF match table gap; hardware needs M3-N quirks, not
  generic Gen3 data.
- **Version info:** RZ/G2N DTS SDHI nodes have existed since v5.5
  (2019); bug present whenever quirk-based OF matching has been used.

### Step 1.4: Hidden Bug Fix?
**Record:** Yes. Despite "Add OF entry" wording, this is a **hardware
quirk/workaround fix**. Without it, HS400 eMMC operates with wrong (or
no) tap calibration. Series cover letter documents measured failures:
RZ/G2N read bandwidth 46,680 KB/s → 104,731 KB/s after fix, validated
with `mmc_test` 1000 iterations on HS400 eMMC.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/mmc/host/renesas_sdhi_internal_dmac.c` (+1 line)
- **Functions modified:** None (data table only:
  `renesas_sdhi_internal_dmac_of_match[]`)
- **Scope:** Single-file, surgical, 1-line addition

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `"renesas,sdhi-r8a774b1"` not in OF table →
  `of_device_get_match_data()` matches fallback `"renesas,rcar-
  gen3-sdhi"` → `of_rcar_gen3_compatible` (`.quirks = NULL`).
- **After:** Primary compatible matches → `of_r8a77965_compatible` →
  `sdhi_quirks_r8a77965` with `hs400_bad_taps`, `hs400_calib_table`,
  `manual_tap_correction`.
- **Path affected:** Device probe / initialization for all RZ/G2N SDHI
  instances (sdhi0–sdhi3).

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware workaround / logic correctness
fix.**
- `sdhi_quirks_r8a77965` enables HS400 tap correction in
  `renesas_sdhi_core.c` (`manual_tap_correction`, `hs400_bad_taps`,
  `hs400_calib_table` code paths).
- Without quirks, HS400 mode runs without proper tap tuning — degraded
  performance and risk of unreliable eMMC transfers.

### Step 2.4: Fix Quality
**Record:** Obviously correct — maps RZ/G2N to already-existing, tested
M3-N quirks. Minimal diff, zero API changes. Regression risk: very low
(only affects r8a774b1 match; identical IP to r8a77965).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** OF match table introduced incrementally.
`of_r8a77965_compatible` added in `71b7597c63d2dd` (2021). RZ/G2N DTS
SDHI nodes added in `6317736729acb` (2019, v5.5). The explicit r8a774b1
OF entry was never added until this 2026 commit. Bug has been latent
since quirk-based OF matching was refactored.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag. Original DTS commit `6317736729acb` is
in this tree.

### Step 3.3: Related Changes
**Record:**
- Part of v2 3-patch series: RZ/G2H, RZ/G2N, RZ/G2E (patches 1/3, 2/3,
  3/3).
- **RZ/G2H sibling already backported** to this tree as `535ff092b6860`
  (with `Cc: stable@vger.kernel.org`, Greg Kroah-Hartman SOB).
- RZ/G2N and RZ/G2E patches from the same series are **not yet** in
  6.18.44.
- Standalone: no other patches required; only adds one table row
  referencing existing data.

### Step 3.4: Author Context
**Record:** Lad Prabhakar — active Renesas contributor; same author as
RZ/G2H backport already in tree. Ulf Hansson (MMC maintainer) committed.

### Step 3.5: Dependencies
**Record:** No dependencies. `of_r8a77965_compatible` and
`sdhi_quirks_r8a77965` already exist in 6.18.44. `r8a774b1.dtsi` SDHI
nodes with `"renesas,sdhi-r8a774b1"` compatible present. Patch applies
cleanly (insert after r8a77470 line, before r8a774e1 which is already
present).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** `b4 dig -c 5ce500d31a162` →
https://patch.msgid.link/20260519135342.623943-3-prabhakar.mahadev-
lad.rj@bp.renesas.com
Series v2 (0/3 + 3 patches). Latest revision applied to mainline. No
NAKs found.

### Step 4.2: Reviewers
**Record:** `b4 dig -w` — CC'd to linux-mmc, linux-renesas-soc, Wolfram
Sang, Ulf Hansson, Geert Uytterhoeven. Both Renesas and MMC maintainers
reviewed.

### Step 4.3: Bug Report
**Record:** No external bug report. Author-provided benchmark data in
cover letter (v2 0/3): RZ/G2N HS400 eMMC read 46,680 → 104,731 KB/s,
write 73,393 → 74,298 KB/s after fix, tested 1000 iterations with
`mmc_test`.

### Step 4.4: Series Context
**Record:** 3-patch series for RZ/G2H/G2N/G2E. Each patch is independent
(one line each). RZ/G2H already backported to this tree; RZ/G2N is
logically identical in nature.

### Step 4.5: Stable List History
**Record:** Individual patches in the series included `Cc:
stable@vger.kernel.org` in mailing-list submissions. RZ/G2H was
subsequently backported to 6.18.y, establishing precedent for this
series.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `renesas_sdhi_internal_dmac_of_match[]` (data), consumed by
`renesas_sdhi_internal_dmac_probe()`.

### Step 5.2: Callers
**Record:** OF core matches compatible at `platform_driver` probe time.
Affects every RZ/G2N board with SDHI enabled (HiHope RZ/G2N, Beacon
RZ/G2N Kit, etc.).

### Step 5.3: Callees
**Record:** `of_device_get_match_data()` → `quirks` pointer passed to
`renesas_sdhi_probe()` → used throughout `renesas_sdhi_core.c` for HS400
tuning.

### Step 5.4: Reachability
**Record:** Triggered at boot when SDHI platform devices probe on RZ/G2N
hardware. Common embedded/industrial path; affects eMMC rootfs on these
boards.

### Step 5.5: Similar Patterns
**Record:** Identical pattern to already-backported RZ/G2H fix
(`r8a774e1` → `of_r8a7795_compatible`) at line 282 in current tree. Same
series, same mechanism.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** `r8a774b1.dtsi` has four SDHI nodes with
`"renesas,sdhi-r8a774b1"` primary compatible. Driver OF table lacks this
entry (verified: no `r8a774b1` in `renesas_sdhi_internal_dmac.c`). Falls
back to generic gen3 without quirks.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** File structure matches upstream
diff context. RZ/G2H entry already inserted at same location; RZ/G2N
entry slots in alphabetically before r8a774e1.

### Step 6.3: Related Fixes Already Present?
**Record:** RZ/G2H fix (`535ff092b6860`) present. RZ/G2N fix **not**
present. No alternate fix for r8a774b1.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** `drivers/mmc/host` — IMPORTANT (block storage / eMMC).
Platform-specific (Renesas RZ/G2N arm64).

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent Renesas SDHI OF entries added
(RZ/G2H, RZ/V2H, RZ/G2L family).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** RZ/G2N (R8A774B1) platform users — embedded/industrial
boards (HiHope, Beacon, etc.) using SDHI/eMMC.

### Step 8.2: Trigger Conditions
**Record:** Every boot with SDHI enabled on RZ/G2N. Not timing-
dependent; deterministic misconfiguration. Unprivileged users interact
via eMMC I/O on these systems.

### Step 8.3: Failure Mode Severity
**Record:** **HIGH** — HS400 eMMC runs without required tap calibration.
Cover letter shows ~2× read bandwidth loss; wrong tap settings risk
transfer errors/data corruption on eMMC. Not a kernel crash, but storage
reliability and performance are seriously impacted.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for affected hardware — restores correct HS400
  quirks, validated performance improvement.
- **Risk:** VERY LOW — 1-line table entry, maps to existing tested
  quirks, identical pattern to already-backported RZ/G2H fix.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Fixes real hardware misconfiguration on RZ/G2N since v5.5
- Hardware quirk/workaround (explicit stable exception category)
- 1-line, surgical, reviewed by subsystem maintainers
- Tested on real hardware (mmc_test, 1000 iterations, HS400)
- Sibling RZ/G2H patch from same series already in 6.18.44
- Series nominated for stable on mailing list
- All prerequisites present in tree

**AGAINST backport:**
- No user crash report or CVE
- Platform-specific (not universal)
- RZ/G2E patch from same series also missing (incomplete series, but
  each patch is independent)

**Unresolved:** None material to the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — maps to existing M3-N
   quirks; benchmarked on hardware.
2. Fixes a real bug affecting users? **PASS** — wrong SDHI quirks on
   RZ/G2N boards.
3. Important issue? **PASS** — eMMC HS400 reliability/performance (HIGH
   severity for affected platforms).
4. Small and contained? **PASS** — 1 line, 1 file.
5. No new features or APIs? **PASS** — existing quirks, new OF table row
   only.
6. Can apply to local tree? **PASS** — prerequisites present, clean
   apply expected.

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround — maps SoC to correct existing
quirks table entry. Same category as the already-backported RZ/G2H fix.

### Step 9.4: Decision Rationale

This commit fixes a long-standing gap where RZ/G2N SDHI hardware was
probed without the M3-N-specific HS400 tuning quirks it requires. The
bug exists in 6.18.44: DTS uses the specific compatible string, but the
driver lacks the matching OF entry. The identical RZ/G2H fix from the
same series is already in this stable tree, establishing clear
precedent. The fix is trivial, reviewed, tested, and addresses real eMMC
performance and reliability on RZ/G2N hardware.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from `git show
  5ce500d31a162`
- **[Phase 1]** Confirmed no Fixes:/Reported-by: in upstream commit
- **[Phase 2]** Verified diff: +1 line in
  `renesas_sdhi_internal_dmac_of_match[]`
- **[Phase 2]** Read `of_r8a77965_compatible` and `sdhi_quirks_r8a77965`
  at lines 204–248
- **[Phase 2]** Read `renesas_sdhi_internal_dmac_probe()` at lines
  581–600 — quirks from OF match data
- **[Phase 2]** Read HS400 quirk usage in `renesas_sdhi_core.c` (lines
  404, 555)
- **[Phase 3]** `git describe HEAD` → v6.18.44
- **[Phase 3]** `git blame` on OF match table — r8a774b1 entry absent
- **[Phase 3]** `git log -S "renesas,sdhi-r8a774b1"` on driver file →
  empty (never added)
- **[Phase 3]** DTS added in `6317736729acb` (2019) — confirmed in tree
- **[Phase 3]** Quirks refactor `71b7597c63d2dd` — confirmed in tree
- **[Phase 3]** RZ/G2H backport `535ff092b6860` — confirmed in tree with
  Cc: stable
- **[Phase 4]** `b4 dig -c 5ce500d31a162` → lore URL found
- **[Phase 4]** `b4 dig -m /tmp/rzg2n_thread.mbox` — cover letter with
  benchmark data and Cc: stable
- **[Phase 4]** Reviewed-by Wolfram Sang and Geert Uytterhoeven
  confirmed in thread
- **[Phase 5]** Grep `of_device_get_match_data` in probe path —
  confirmed flow
- **[Phase 5]** Grep `r8a774b1` in driver — no matches (bug present)
- **[Phase 6]** `r8a774b1.dtsi` SDHI nodes use `"renesas,sdhi-r8a774b1"`
  — confirmed at lines 2162+
- **[Phase 6]** `of_r8a77965_compatible` exists in 6.18.44 — confirmed
- **[Phase 6]** Commit NOT in current HEAD — `git log --grep="RZ/G2N"`
  on driver returns only unrelated entries
- **[Phase 8]** Cover letter benchmarks: RZ/G2N read 46680→104731 KB/s —
  from mbox

**YES**

 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 6816d491b0bf0..8bc1c3209edb0 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -279,6 +279,7 @@ static const struct renesas_sdhi_of_data_with_quirks of_rza2_compatible = {
 static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
-- 
2.53.0

