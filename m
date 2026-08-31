Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F904E9B00;
	Mon, 31 Aug 2026 13:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183623; cv=none; b=jz4qvlFVT9oexeJ3T+8sY8OpQT3Yshh6Z7OY62r84ZaedngprYqJN6h2+FtVHzhFBIrGjcUP6UZ7JKgmkjPwNIxT2KSSJKfiO30dVlx9n3yntKVOkn8UiYNMnCz01WvSW0z4r5O7Wxl2H7TFmcMUzNsp2PqVojvfJbUAcjZ+qb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183623; c=relaxed/simple;
	bh=7VU6EBvKdu9V2132/+pAb/fWDhTlUWMzrPyzYRRQtqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qIwtLYb7i27Pgz04Qtr0huM8Q/3NpDkqcGlWih6Cku1NNTU6BITLdmhi4a0+AhXj/QE+10DmA1yxvYnrDLTWaWpb1hbE2R/6/OTiQGolhSocHql4iSOEe4z31rWFOYAM5QV9NW5twGea0h5WtlE6SkkHzx9qGk/ryuP7CX5ID6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nahUJm9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nahUJm9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 240FF1F000E9;
	Mon, 31 Aug 2026 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183621;
	bh=16fH6e5R7tsJGJsq534FImcYfyPN+jw0vbm2JZqfOLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nahUJm9PoKWebUxDQBgEVjxxES8IVlQDoAg4jDxBIna8y3Kr2wXARB/sE/VGXkigN
	 ni3TXA16sQ1TfmzrZ6uogqfNButAVh/x/+SDTTvq+5HRopRMBw5/Kw1DnoBZD0dUZX
	 YdvwjAZtHF9baPEqE2iAa49HX5VsQokUUIMCkqqmOg3OSdjAtYNEvYWOTLxrS+clWp
	 dOz+nEMIFu0fH74ZQrWBGSLXHtGlTCw7Hnx7EpqcKhDJRqmYFn9VhtSnechrKUcVdZ
	 UjZVuj3ylduS5YghZCFXfxOLJv544CzQYCyxfQLcCbXLUV57LNMgYOFzYvgY3GBTle
	 sGcukEcQRXDog==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] ata: libata-core: Disable LPM on some WD drives
Date: Mon, 31 Aug 2026 09:23:51 -0400
Message-ID: <20260831133314.4125787-203-sashal@kernel.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 356d8241cf3c7b07a4a491dbab43b5a41513ca86 ]

According to a user report WDC WD100EFGX-68CPLN0 and WDC WD102KFBX-68M95N0
have problems with LPM.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220693
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 — Subject line**
- Record: `[ata: libata-core]` `[Disable]` — Add ATA device quirks to
  disable Link Power Management (LPM) on two specific Western Digital
  drive models.

**Step 1.2 — Tags**
- Record:
  - `Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220693`
  - `Signed-off-by: Niklas Cassel <cassel@kernel.org>` (author/subsystem
    maintainer)
  - `Signed-off-by: Damien Le Moal <dlemoal@kernel.org>` (libata
    maintainer)
  - No `Fixes:`, `Reported-by:`, `Tested-by:`, `Reviewed-by:`, or `Cc:
    stable@vger.kernel.org` tags
  - Notable: bugzilla closure link; maintainer sign-offs from libata
    maintainers

**Step 1.3 — Body analysis**
- Record:
  - **Bug:** WDC WD100EFGX-68CPLN0 and WDC WD102KFBX-68M95N0 have
    problems with LPM
  - **Symptom (from bugzilla):** "SATA bus goes offline after a while"
    (bug 220693, reported 2025-10-22)
  - **Version info:** None in commit message
  - **Root cause (from patch comment):** Existing
    `ATA_QUIRK_WD_BROKEN_LPM` only applies to SATA Gen1 drives; these
    modern WD models need unconditional `ATA_QUIRK_NOLPM`

**Step 1.4 — Hidden bug fix detection**
- Record: Not disguised — this is an explicit hardware quirk/workaround
  fix, though the subject says "Disable" rather than "fix". Classic
  device-specific LPM workaround pattern.

---

## Phase 2: Diff Analysis

**Step 2.1 — Change inventory**
- Record:
  - Files: `drivers/ata/libata-core.c` (+8 lines, 0 removed)
  - Functions: modifies `__ata_dev_quirks[]` static table only
  - Scope: single-file, surgical quirk-table addition

**Step 2.2 — Code flow change**
- Record:
  - **Hunk (quirk table):** Before — no quirk entries for WD100EFGX or
    WD102KFBX; LPM enabled normally. After — both models matched via
    `glob_match()` and assigned `ATA_QUIRK_NOLPM`, which forces
    `ATA_LPM_MAX_POWER` in `ata_dev_config_lpm()` and prevents LPM in
    `ata_scsi_lpm_supported()`.

**Step 2.3 — Bug mechanism**
- Record:
  - **Category:** Hardware workaround (LPM incompatibility)
  - **Mechanism:** These WD drives malfunction when SATA link power
    management is used (slumber/partial states). Without the quirk,
    `ata_dev_config_lpm()` does not disable LPM. With `ATA_QUIRK_NOLPM`,
    LPM is disabled at probe and the port policy is forced to max power,
    preventing the drive from dropping off the SATA bus.

**Step 2.4 — Fix quality**
- Record:
  - Obviously correct: uses established `ATA_QUIRK_NOLPM` mechanism
    already used for ADATA, Seagate, Samsung, and other drives in the
    same table
  - Minimal and surgical: two model strings plus explanatory comment
  - Regression risk: very low; only affects exact model matches; trade-
    off is slightly higher power consumption on those drives (standard
    accepted cost of NOLPM quirks)

---

## Phase 3: Git History Investigation

**Step 3.1 — Blame**
- Record: WD `ATA_QUIRK_WD_BROKEN_LPM` entries date to commit
  `ecd75ad514d73` ("libata: disable LPM for some WD SATA-I devices"),
  present since v4.6 era. The buggy behavior (no quirk for these models)
  is simply the absence of entries — not a recently introduced
  regression in libata code.

**Step 3.2 — Fixes: tag**
- Record: N/A — no `Fixes:` tag present.

**Step 3.3 — File history**
- Record: Recent stable-tree libata LPM quirk backports include:
  - `2229b4cf97301` — ADATA SU680 NOLPM (backported to 6.18.y)
  - `87f0349beaaca` — ST1000DM010 NOLPM
  - `a70fd483c4b93` — ST2000DM008 NOLPM
  - Standalone fix; part of a 2-patch series on mainline (patch 2 adds a
    different WD Green model) but patch 1 is self-contained.

**Step 3.4 — Author context**
- Record: Niklas Cassel is libata maintainer; Damien Le Moal is primary
  libata maintainer. Both signed off. Maintainer applied series to
  `for-7.2-fixes` per lore reply.

**Step 3.5 — Dependencies**
- Record: No dependencies. `ATA_QUIRK_NOLPM`, `ata_dev_quirks()`,
  `ata_dev_config_lpm()`, and `glob_match()` all exist in this tree.
  Applies cleanly (`git apply --check` passed).

---

## Phase 4: Mailing List and External Research

**Step 4.1 — Original discussion**
- Record:
  - Lore URL:
    https://patch.msgid.link/20260728111310.722450-5-cassel@kernel.org
  - Series: v1 only (no further revisions)
  - Damien Le Moal: "Applied to for-7.2-fixes. Thanks!"
  - No NAKs; no explicit stable nomination in thread

**Step 4.2 — Reviewers**
- Record: CC'd to `linux-ide@vger.kernel.org`, Damien Le Moal, Ronald
  Garcia Vazquez (likely reporter contact). Maintainers directly
  involved.

**Step 4.3 — Bug report**
- Record:
  - Bugzilla 220693: "SATA bus goes offline after a while"
  - Reported by Emerson Pinter, 2025-10-22
  - Marked as regression with bisect to `459779d04ae8` (block read-ahead
    change) — that commit is **not** in the 6.18.y tree; the LPM quirk
    fix addresses the drive-specific failure mode regardless
  - Severity: disk/bus disappearance is a serious usability and
    potential data-integrity issue

**Step 4.4 — Related patches**
- Record: Patch 2/2 (`WD Green 2.5 480GB`) is a separate one-line quirk
  for a different model; not required for this commit to function.

**Step 4.5 — Stable list**
- Record: No stable-list discussion found for this specific commit.
  Precedent: ADATA SU680 NOLPM quirk (`2229b4cf97301`) was explicitly
  nominated with `Cc: stable@vger.kernel.org` and backported to 6.18.y.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 — Key functions**
- Record: `__ata_dev_quirks[]` (modified), `ata_dev_quirks()`
  (consumer), `ata_dev_config_lpm()` (applies NOLPM),
  `ata_scsi_lpm_supported()` (checks NOLPM)

**Step 5.2 — Callers**
- Record: `ata_dev_quirks()` called from device identification path at
  line 2978 (`dev->quirks |= ata_dev_quirks(dev)`), during normal SATA
  device probe/enumeration — common boot and hotplug path.

**Step 5.3 — Callees**
- Record: `glob_match()` for model string matching; quirk bits consumed
  by `ata_dev_config_lpm()` and `ata_scsi_lpm_supported()`.

**Step 5.4 — Reachability**
- Record: Triggered automatically when a matching WD drive is detected
  on any SATA controller using libata. No special config needed beyond
  `CONFIG_ATA`.

**Step 5.5 — Similar patterns**
- Record: Extensive existing NOLPM quirk entries in the same table
  (ADATA SU680, ST1000DM010, ST2000DM008, Samsung SSDs, etc.) —
  identical fix pattern.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 — Buggy code in tree**
- Record: Local tree is **Linux 6.18.44** (`v6.18.44-2-g1b9e1abadee04`,
  detached from `stable/linux-6.18.y`). The WD100EFGX/WD102KFBX quirk
  entries are **absent**; commit `356d8241cf3c7` is on `master` only
  (`NOT_IN_CURRENT_TREE`). The quirk infrastructure and
  `ATA_QUIRK_NOLPM` are fully present. Bug affects any user with these
  drive models on 6.18.y.

**Step 6.2 — Backport complications**
- Record: Clean apply confirmed. Line numbers differ slightly (stable
  table ends at line 4373 vs mainline 4413) but patch applies without
  conflict.

**Step 6.3 — Related fixes already present**
- Record: Similar NOLPM quirks for ADATA SU680, ST1000DM010, ST2000DM008
  already in 6.18.y. No duplicate fix for these WD models.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 — Subsystem criticality**
- Record: `drivers/ata/` — IMPORTANT (storage stack; affects users with
  affected hardware)

**Step 7.2 — Subsystem activity**
- Record: Actively maintained in 6.18.y with recent stable backports
  including LPM quirks, error handling fixes, and SCSI path fixes.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 — Who is affected**
- Record: Users with WDC WD100EFGX-68CPLN0 or WDC WD102KFBX-68M95N0
  drives on any libata SATA port. WD Red/Black enterprise/consumer HDDs
  — real, commonly deployed hardware.

**Step 8.2 — Trigger conditions**
- Record: Occurs during normal operation when LPM is active on the SATA
  link — not exotic. Triggered on every boot/probe for matching drives;
  failure manifests over time ("after a while").

**Step 8.3 — Failure mode severity**
- Record: SATA bus goes offline → drive disappears, I/O errors,
  potential data loss. Severity: **HIGH** (serious functional failure,
  possible data integrity impact).

**Step 8.4 — Risk-benefit**
- Record:
  - Benefit: **High** for affected hardware — restores reliable disk
    operation
  - Risk: **Very low** — 8-line quirk addition, exact model match only,
    established mechanism
  - Ratio: strongly favors backport

---

## Phase 9: Final Synthesis

**Step 9.1 — Evidence summary**

FOR backporting:
- Fixes real user-reported bug (bugzilla 220693)
- Hardware quirk — explicit stable exception category
- Identical pattern to NOLPM quirks already backported to 6.18.y
- Small, surgical, applies cleanly
- Subsystem maintainer authored and applied
- Serious failure mode (SATA bus offline)

AGAINST backporting:
- No `Tested-by:` on this specific commit (minor; ADATA quirk had one)
- No explicit `Cc: stable` tag (not a negative signal per instructions)
- Bugzilla regression bisect points elsewhere, but fix targets
  documented LPM failure mode

**Step 9.2 — Stable rules checklist**
1. Obviously correct and tested? **PASS** — standard quirk mechanism;
   maintainer-reviewed
2. Fixes a real bug affecting users? **PASS** — bugzilla user report,
   SATA bus offline
3. Important issue? **PASS** — drive/bus failure, HIGH severity
4. Small and contained? **PASS** — 8 lines, one file
5. No new features or APIs? **PASS** — quirk table entries only
6. Can apply to local tree? **PASS** — clean apply verified

**Step 9.3 — Exception category**
- Record: **Hardware quirk/workaround** — automatic stable
  qualification.

**Step 9.4 — Decision rationale**

This commit adds two model-specific `ATA_QUIRK_NOLPM` entries for WD
drives that drop off the SATA bus when LPM is enabled. The fix uses
infrastructure already present and proven in 6.18.y through prior NOLPM
backports. It is not in the current 6.18.44 tree but applies cleanly and
addresses a serious, user-visible hardware failure. This is textbook
stable material.

---

## Verification

- [Phase 1] Parsed commit `356d8241cf3c7`: subject, tags, body, bugzilla
  link
- [Phase 2] Full diff reviewed: 8 lines added to `__ata_dev_quirks[]` in
  `drivers/ata/libata-core.c`
- [Phase 3] `git describe HEAD`: v6.18.44 (6.18.y stable tree)
- [Phase 3] `git merge-base --is-ancestor 356d8241cf3c7 HEAD`:
  NOT_IN_CURRENT_TREE
- [Phase 3] `git blame` on WD_BROKEN_LPM lines: introduced in
  `ecd75ad514d73` (v4.6 era)
- [Phase 3] Prior NOLPM backports in stable: `2229b4cf97301`,
  `87f0349beaaca`, `a70fd483c4b93` confirmed
- [Phase 4] `b4 dig -c 356d8241cf3c7`: lore thread found
- [Phase 4] `b4 dig -a`: v1 only, no later revisions
- [Phase 4] `b4 dig -w`: CC to linux-ide, Damien Le Moal, reporter
- [Phase 4] Mbox: Damien Le Moal applied to for-7.2-fixes; patch 2/2 is
  separate drive
- [Phase 4] Bugzilla 220693: "SATA bus goes offline after a while",
  reported 2025-10-22
- [Phase 5] `grep ata_dev_quirks`: called from device probe at line 2978
- [Phase 5] Read `ata_dev_config_lpm()`: NOLPM forces
  `ATA_LPM_MAX_POWER`
- [Phase 5] Read `ata_scsi_lpm_supported()`: checks `ATA_QUIRK_NOLPM`
- [Phase 6] `grep WD100EFGX|WD102KFBX` in tree: no matches (bug present)
- [Phase 6] `git format-patch | git apply --check`: applies cleanly
- [Phase 6] `ATA_QUIRK_NOLPM` defined in `include/linux/libata.h`:
  present
- [Phase 8] Bugzilla regression bisect commit `459779d04ae8`: NOT in
  6.18.y tree (irrelevant to applicability)

**YES**The background checks finished and match the earlier analysis:

- **Master search:** Found commit `356d8241cf3c7` — "ata: libata-core:
  Disable LPM on some WD drives"
- **Tree check:** That commit is on `master` only, **not** in the
  current 6.18.44 stable checkout

The backport recommendation stands: **YES** — add the two WD
`ATA_QUIRK_NOLPM` entries for WD100EFGX and WD102KFBX; the patch applies
cleanly to this tree.

 drivers/ata/libata-core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index f0753f5e57a8e..ae1e5f82026c5 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4372,6 +4372,14 @@ static const struct ata_dev_quirks_entry __ata_dev_quirks[] = {
 	{ "WDC WD3000JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 	{ "WDC WD3200JD-*",		NULL,	ATA_QUIRK_WD_BROKEN_LPM },
 
+	/*
+	 * WD drives with LPM issues (irrespective of supported SATA speeds).
+	 * (Unlike ATA_QUIRK_WD_BROKEN_LPM, which is only applied if the drive
+	 * exposes SATA Gen1 speed support, and SATA Gen1 speed support only.)
+	 */
+	{ "WDC WD100EFGX-68CPLN0",	NULL,	ATA_QUIRK_NOLPM },
+	{ "WDC WD102KFBX-68M95N0",	NULL,	ATA_QUIRK_NOLPM },
+
 	/*
 	 * This sata dom device goes on a walkabout when the ATA_LOG_DIRECTORY
 	 * log page is accessed. Ensure we never ask for this log page with
-- 
2.53.0

