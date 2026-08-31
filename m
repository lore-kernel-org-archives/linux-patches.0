Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD844429CE9;
	Mon, 31 Aug 2026 13:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183209; cv=none; b=oKp0iZxjN9mi4exH536cZhqty5j7+1tZm80tIE3nibGy8qo8QmpIzPzT2hM1sVoY82XHVkhhjn+BYHViavuSDr5IWupECaYv4BE9hpEESZo19qbedog0ZNa6/2XVfXbsTF+cqXhlTOKEcpYwEN2OVw986VKm/ATGUFX87qdMF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183209; c=relaxed/simple;
	bh=1YVcFeLfY4xqm3RixxqW0U+vVsjxFLhrq1mFFv3nnaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uFFd3rYmEDZIwHOFZHYZ61iegRGWsMehpP5q+19vIlQeayiY481jij/Jzwwf7OAyvROBBsyYe/Z6BWVCjl7U4W/U35tPbWWHvT/kWy4DMotzcmyEZKkW1qVp96lBTncxp4TDD4pVfzrrKoYlGOSz1xmyKBntMlo0RPzzw/sDmDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dpXhtKUd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dpXhtKUd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB68F1F00A3E;
	Mon, 31 Aug 2026 13:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183207;
	bh=s/ySp6tpAiWTs38eF7/dkv/CrRdEcZL8fgTVLdmpmVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dpXhtKUdB2FugOqN7iBL4MJUhBC0ZXSlhpRgb09gfB8glCYZMAES7M8L2Tjy432hi
	 VSRvmgNBcvjD8zea9YIAoDyOBqMYeOSL3yybFu+9ZExqUv2N2niRgTA5vaaE17R9rA
	 T1EfgbsbuwaF+49xlLI4OblmEqHV0R/TV3d4c7z7qKBJxCma+wyfAEWfbrERNbySwH
	 oAveX9iHGk2wrnYXFXITJRTRdWCWSz/jzmLgFx9W2cavQELjBaoYhvxCzSon0xw9R+
	 J6iEe301Q4JFapZUSSzCUrhI6LQKA/BUFqF3Jd7wSRqQWbMZPsiuK3ApNnVifr8ON0
	 ja6Fbov1z0jXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-mmc@vger.kernel.org,
	linux-renesas-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] mmc: renesas_sdhi: Add OF entry for RZ/G2E SoC
Date: Mon, 31 Aug 2026 09:20:36 -0400
Message-ID: <20260831133314.4125787-8-sashal@kernel.org>
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

[ Upstream commit ebf7f2198ac4817bd2929cf83c697cefa8bf36a9 ]

The RZ/G2E (R8A774C0) SoC was previously handled via the generic
"renesas,rcar-gen3-sdhi" fallback compatible string. However, because
the SDHI IP on RZ/G2E is identical with the R-Car E3 (R8A77990), it
requires the specific quirks and configuration defined in
`of_r8a77990_compatible` rather than the generic Gen3 data.

Add the explicit "renesas,sdhi-r8a774c0" match entry to map it correctly.
Note that the DT binding file renesas,sdhi.yaml does not need an update
as the entry for this SoC is already present.

Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
Record: `[mmc: renesas_sdhi] [Add] Add OF entry for RZ/G2E SoC — maps
RZ/G2E (R8A774C0) SDHI to correct SoC-specific quirks data`

**Step 1.2 — Tags**
Record:
- Fixes: — absent (expected for manual review)
- Reported-by: — none
- Tested-by: — none
- Reviewed-by: Geert Uytterhoeven, Wolfram Sang
- Acked-by: — none
- Link: — none in commit message
- Cc: stable@vger.kernel.org — absent in upstream commit (present on
  patch 1/3 of the series only)
- Signed-off-by: Lad Prabhakar, Ulf Hansson

Notable: reviewed by Renesas/MMC subsystem experts; part of a 3-patch
series.

**Step 1.3 — Body analysis**
Record:
- Bug: RZ/G2E SDHI was matched via generic `renesas,rcar-gen3-sdhi`
  fallback instead of SoC-specific quirks
- Symptom: missing R-Car E3 (R8A77990) quirks — HS400 calibration table
  and manual tap correction
- Root cause: DTS uses `renesas,sdhi-r8a774c0` as primary compatible,
  but driver OF table lacked that entry
- Version info: none explicit; binding already documents
  `renesas,sdhi-r8a774c0`

**Step 1.4 — Hidden bug fix?**
Record: Yes — presented as “add OF entry” but fixes incorrect hardware
configuration. Cover letter documents measured eMMC HS400 bandwidth
improvements on RZ/G2E (read 159472 → 180781 KB/s, write 126355 → 127725
KB/s).

---

## Phase 2: Diff Analysis

**Step 2.1 — Inventory**
Record:
- Files: `drivers/mmc/host/renesas_sdhi_internal_dmac.c` (+1 line)
- Function: `renesas_sdhi_internal_dmac_of_match[]` (static OF match
  table)
- Scope: single-file, surgical (1 line)

**Step 2.2 — Code flow**
Record:
- Before: `renesas,sdhi-r8a774c0` not in table → OF match falls through
  to `renesas,rcar-gen3-sdhi` → `of_rcar_gen3_compatible` (no quirks)
- After: `renesas,sdhi-r8a774c0` → `of_r8a77990_compatible` (R-Car E3
  quirks: `sdhi_quirks_r8a77990`)
- Path: device probe during MMC controller initialization on RZ/G2E
  boards

**Step 2.3 — Bug mechanism**
Record:
- Category: (h) Hardware workaround / quirk mapping
- Mechanism: wrong `of_device_id` → wrong `quirks` pointer → missing
  `hs400_calib_table` and `manual_tap_correction` in
  `renesas_sdhi_probe()`

**Step 2.4 — Fix quality**
Record: Obviously correct — RZ/G2E SDHI IP is identical to R-Car E3;
same mapping pattern as already-backported G2H fix. Minimal regression
risk.

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
Record: `of_r8a77990_compatible` introduced in `71b7597c63d2d`
(2021-07-29, Yoshihiro Shimoda). Present in v6.18.44.

**Step 3.2 — Fixes: tag**
Record: N/A — no Fixes: tag.

**Step 3.3 — Related changes**
Record:
- `77223211f44db` (2018): added SDHI nodes to `r8a774c0.dtsi` with
  `renesas,sdhi-r8a774c0` compatible
- `535ff092b6860`: G2H sibling fix already backported to v6.18.44 with
  `Cc: stable@vger.kernel.org`
- Series on master: G2H (`f48ee497`), G2N (`5ce500d31a162`), G2E
  (`ebf7f2198ac48`) — patches are independent one-liners
- G2N OF entry not in stable; G2E not in stable

**Step 3.4 — Author context**
Record: Lad Prabhakar — Renesas contributor; same author as G2H fix
already in stable.

**Step 3.5 — Dependencies**
Record: Standalone. `of_r8a77990_compatible` and `sdhi_quirks_r8a77990`
exist in tree. Backport adds one line; in 6.18.44 (no `r8a774b1` entry)
it fits after `sdhi-mmc-r8a77470` and before `sdhi-r8a774e1`.

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Discussion**
Record:
- URL:
  https://patch.msgid.link/20260519135342.623943-4-prabhakar.mahadev-
  lad.rj@bp.renesas.com
- Series: v2 0/3 — “Add OF entries for RZ/G2H, RZ/G2N, and RZ/G2E SoCs”
- Cover letter documents HS400 eMMC test results on all three SoCs
- No NAKs found; reviewed by Wolfram Sang and Geert Uytterhoeven

**Step 4.2 — Reviewers**
Record: Ulf Hansson (MMC maintainer), Wolfram Sang, Geert Uytterhoeven,
linux-mmc@, linux-renesas-soc@ CC’d.

**Step 4.3 — Bug report**
Record: No external bug report; author-provided benchmark data in cover
letter.

**Step 4.4 — Series context**
Record: 3 independent patches; G2H (1/3) already backported to 6.18.44;
G2E (3/3) is self-contained.

**Step 4.5 — Stable list**
Record: `Cc: stable@vger.kernel.org` on patch 1/3 (G2H) only; series
author intended stable consideration for the family of fixes.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
Record: `renesas_sdhi_internal_dmac_of_match[]`,
`renesas_sdhi_internal_dmac_probe()` → `renesas_sdhi_probe()`

**Step 5.2 — Callers**
Record: platform driver probe during device enumeration; triggered when
RZ/G2E SDHI nodes are enabled (e.g. EK874 `sdhi0`, `sdhi3`).

**Step 5.3 — Callees**
Record: `of_device_get_match_data()` → quirks applied in
`renesas_sdhi_probe()` for HS400 calibration (`hs400_calib_table`) and
tap correction (`manual_tap_correction`).

**Step 5.4 — Reachability**
Record: Boot-time probe on RZ/G2E boards with SD/MMC enabled. EK874
enables `sdhi0` (SD UHS) and `sdhi3` (SDIO WLAN). Userspace cannot
directly trigger, but all storage I/O on these interfaces is affected.

**Step 5.5 — Similar patterns**
Record: Same pattern as G2H (`r8a774e1` → `of_r8a7795_compatible`),
already backported to this tree.

---

## Phase 6: Cross-Reference Against Local Tree (v6.18.44)

**Step 6.1 — Buggy code exists?**
Record: Yes. `r8a774c0.dtsi` SDHI nodes use `renesas,sdhi-r8a774c0`
since 2018; driver OF table in v6.18.44 lacks this entry. Commit
`ebf7f2198ac48` not in tree.

**Step 6.2 — Backport complications**
Record: Clean apply — one line. Insert before existing `r8a774e1` entry
(G2H backport already present).

**Step 6.3 — Related fixes present?**
Record: G2H fix (`535ff092b6860`) backported; G2E fix absent.

---

## Phase 7: Subsystem Context

**Step 7.1 — Subsystem**
Record: `drivers/mmc/host` — IMPORTANT (MMC/SD/eMMC storage on embedded
Renesas RZ/G2E)

**Step 7.2 — Activity**
Record: Actively maintained; recent G2H backport shows ongoing stable
attention for this driver.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
Record: RZ/G2E (R8A774C0) users — EK874, CAT874 boards and derivatives.
Config: `CONFIG_MMC`, Renesas SDHI internal DMAC.

**Step 8.2 — Trigger conditions**
Record: Any boot with SDHI enabled on RZ/G2E. Common on reference
boards. Not userspace-triggerable but affects all MMC I/O.

**Step 8.3 — Failure mode severity**
Record: Suboptimal HS400/HS200 operation — measured ~13% read bandwidth
loss on eMMC; missing tap correction risks data integrity at high
speeds. Severity: MEDIUM-HIGH for embedded storage reliability.

**Step 8.4 — Risk-benefit**
Record: Benefit HIGH for RZ/G2E users (proven performance fix, correct
hardware quirks). Risk VERY LOW (1 line, uses existing data structures,
precedent with G2H backport).

---

## Phase 9: Final Synthesis

**Evidence FOR:**
- Fixes real hardware misconfiguration on shipping RZ/G2E boards
- Documented eMMC HS400 performance improvement
- 1-line, obviously correct hardware quirk mapping
- Same pattern as G2H fix already backported to v6.18.44
- Reviewed by subsystem maintainers
- `of_r8a77990_compatible` prerequisite exists in tree since 2021
- DTS binding and nodes already present since 2018

**Evidence AGAINST:**
- Performance-focused rather than crash/corruption explicitly reported
  (but HS400 without proper calibration can cause silent errors)
- G2E patch lacks explicit `Cc: stable` (G2H had it)
- Part of a 3-patch series (but each patch is independent)

**Stable rules checklist:**
1. Obviously correct and tested? **PASS** — reviewed, benchmarked
2. Fixes real bug affecting users? **PASS** — wrong quirks on RZ/G2E
   since 2018
3. Important issue? **PASS** — storage performance/reliability on
   embedded platform
4. Small and contained? **PASS** — 1 line
5. No new features/APIs? **PASS** — maps to existing quirks
6. Can apply to local tree? **PASS** — clean one-line backport

**Exception category:** Hardware quirk/workaround (OF match → correct
quirks table)

---

## Verification

- [Phase 1] Parsed commit `ebf7f2198ac48` on master; tags: Reviewed-by
  Geert, Wolfram; no Fixes/Reported-by
- [Phase 2] Diff: +1 line in `renesas_sdhi_internal_dmac_of_match[]`
- [Phase 3] `git describe HEAD`: v6.18.44; `of_r8a77990_compatible` from
  `71b7597c63d2d` (2021)
- [Phase 3] SDHI DTS nodes since `77223211f44db` (2018); G2H backport
  `535ff092b6860` in stable
- [Phase 3] `ebf7f2198ac48` not ancestor of HEAD (not in stable)
- [Phase 4] `b4 dig -c ebf7f2198ac48`: lore thread found; v2 3/3 series
- [Phase 4] Cover letter: HS400 benchmark data for RZ/G2E
- [Phase 4] `Cc: stable` only on patch 1/3 (G2H)
- [Phase 5] Verified `sdhi_quirks_r8a77990` has `hs400_calib_table` +
  `manual_tap_correction`
- [Phase 5] EK874 DTS: `sdhi0` and `sdhi3` enabled
- [Phase 6] `r8a774c0` in driver OF table: absent; in DTS: present
- [Phase 6] Current stable OF table read at lines 279–295 confirms
  missing `r8a774c0` entry

This commit should be backported to the v6.18.44 stable tree. It
corrects a long-standing hardware quirk mapping bug for RZ/G2E SDHI,
follows the same pattern as the already-backported G2H fix, and is a
minimal one-line change with demonstrated user impact.

**YES****Verdict: YES** — backport to v6.18.44.

This is a one-line OF match-table fix for RZ/G2E (R8A774C0) SDHI.
Without it, the driver falls back to generic Gen3 quirks instead of the
R-Car E3-specific ones (`of_r8a77990_compatible`), which hurts HS400
eMMC performance and tuning on boards like EK874.

It matches the G2H fix already in this stable tree (`535ff092b6860`), is
small and self-contained, and should apply cleanly as a single line
before the existing `r8a774e1` entry.

 drivers/mmc/host/renesas_sdhi_internal_dmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/renesas_sdhi_internal_dmac.c b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
index 8bc1c3209edb0..6cca38e32b991 100644
--- a/drivers/mmc/host/renesas_sdhi_internal_dmac.c
+++ b/drivers/mmc/host/renesas_sdhi_internal_dmac.c
@@ -280,6 +280,7 @@ static const struct of_device_id renesas_sdhi_internal_dmac_of_match[] = {
 	{ .compatible = "renesas,sdhi-r7s9210", .data = &of_rza2_compatible, },
 	{ .compatible = "renesas,sdhi-mmc-r8a77470", .data = &of_rcar_gen3_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774b1", .data = &of_r8a77965_compatible, },
+	{ .compatible = "renesas,sdhi-r8a774c0", .data = &of_r8a77990_compatible, },
 	{ .compatible = "renesas,sdhi-r8a774e1", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a7795", .data = &of_r8a7795_compatible, },
 	{ .compatible = "renesas,sdhi-r8a77961", .data = &of_r8a77961_compatible, },
-- 
2.53.0

