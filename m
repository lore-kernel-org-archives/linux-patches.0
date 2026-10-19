Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77095D7CA1;
	Mon, 19 Oct 2026 14:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418515; cv=none; b=BaMiOc+e3T00CCMAAvWZAMFWe8aNm2RKM4q77hRRSE3Kd9/Reb4WFuwgqCQRgJWulFasS3aX3aQ/6cF1lpDs013xQFbBcK88E22q5PTnS3PM8381WtJm1/Ny0VFLkFPb9vi3B+ZrOqmKgsUfy9i+OlvpTTZDAt+d/6pn3nlcXts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418515; c=relaxed/simple;
	bh=ySLNsBrlRCzTR2nLg8mBh6uqeGNK2/UeG9mxjqFVSak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XPHFkwRvliZmkhh6orZdIfrVGOaUUhcc15lC8sqF4N366QwmVsYhQgGpeP1YyPONt08+6UE3Pd9U6XE4bQwOsN07/EizahP/z0vdPWyDI5kgC4bZ24ALTb7X2+kZXmcuyWaLapRB954AvDhYQbenSSSZJMnpD7Ep8N4KobOERu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K6ibStXY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K6ibStXY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785EB1F000C6;
	Mon, 19 Oct 2026 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418512;
	bh=8RndOT4KZvRzJ72Zs4ghL3mZz03S5UyfL5M7Fa9CMsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6ibStXYBdEzKqH2BBGv0rQ//0OnSlv7ieQlXb/KIDmm1PrN1tS7u1ZQOE+wyZ+zh
	 /8S3fGTB2RXCp3RHguIsSBR5cUJantnewmtS7fwRRX3nVi87LkjpqInRU+8hT6wwJK
	 Ou4dQ398VBaCZ1IBgJ66SaX1bkp/J+f8FqRE0oFcftjcUcov9IbY4siX6OLHLf3Sod
	 eEskyNcxZGG2/eqpQseho/6zGumlzR4EJiiiUH1d6L7lkrf6FvUZA7q+2GBysZ2Rna
	 uw9+n4Plo4yD0K3Gt5l7JyYHTfzU3cB0MSskAWoj6nLSxWUMZdHrWsy57NoncvpjUj
	 qECmHY0DRb4ZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>,
	neil.armstrong@linaro.org,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] drm/panel-edp: Support MB116AS01'3 edp panel
Date: Mon, 19 Oct 2026 09:49:52 -0400
Message-ID: <20261019135441.1420968-301-sashal@kernel.org>
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

From: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>

[ Upstream commit 844e71ba7d7a50c5ffa29d147afaeaafb19b39e4 ]

MB116AS01'3 raw edid:
00 ff ff ff ff ff ff 00 21 63 03 12 00 00 00 00
00 23 01 04 95 1a 0e 78 23 e7 05 9c 5b 56 93 27
21 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 36 1c 56 92 50 00 1c 30 60 18
a8 00 00 90 10 00 00 18 00 00 00 fd 00 28 3c 30
30 07 01 0a 20 20 20 20 20 20 00 00 00 fe 00 48
4b 43 20 4d 59 20 20 20 20 0a 20 20 00 00 00 fe
00 4d 42 31 31 36 41 53 30 31 27 33 20 20 01 cb

70 20 79 02 00 22 00 14 1c 1a 01 84 55 05 91 00
5f 00 17 00 ff 02 1b 00 09 00 07 00 2b 00 06 27
00 28 3b 00 00 81 00 13 72 1a 00 00 03 01 28 3c
00 00 00 00 00 00 3c 00 00 00 00 25 01 09 1c 1a
01 1c 1a 01 28 3c 80 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 e7 90

Signed-off-by: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260701013018.2621972-1-zhouhaikun5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Local tree is **6.18.y** (`v6.18.53`, `VERSION=6 PATCHLEVEL=18`). The
MB116AS01'3 table entry is **not** in `v6.18.53`. The driver, HKC table,
`delay_200_500_e80`, and unknown-panel `WARN_ON` path are present. This
is a one-line panel ID / quirk for an existing driver.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: `[drm/panel-edp] [Support] [add MB116AS01'3 eDP panel table
entry]`
- Subsystem: `drm/panel-edp`
- Verb: "Support" — hardware enablement / ID addition, not a refactor

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- `Signed-off-by: Haikun Zhou <zhouhaikun5@huaqin.corp-
  partner.google.com>` (author; Huaqin/Google partner)
- `Reviewed-by: Douglas Anderson <dianders@chromium.org>` (panel-edp
  reviewer in MAINTAINERS)
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>` (maintainer
  applied it)
- `Link: https://patch.msgid.link/20260701013018.2621972-1-
  zhouhaikun5@huaqin.corp-partner.google.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc: stable` (absence
  expected for this review)
- Ignored: `Signed-off-by: Sasha Levin` and `[Upstream commit ...]`
  (pipeline markers)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- Bug description: the panel is missing from `edp_panels[]`. The body is
  the raw EDID (base block + extension), not a crash log.
- Symptom: unmatched generic `edp-panel` uses conservative delays and
  hits `WARN_ON(!detected_panel)` at probe.
- Version info: none in the message. Author date is 2026-07-01; `v6.18`
  is 2025-11-30, so this landed after this series branched.
- Root cause: HKC ID `0x1203` was not in the delay/quirk table.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is an explicit panel ID / power-
sequencing quirk. That is the same class as PCI/USB ID additions.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/gpu/drm/panel/panel-edp.c` (`+1 / -0`)
- Function/table: `edp_panels[]`
- Scope: single-file, one-line surgical addition

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- Before: HKC `0x1203` is not in `edp_panels[]`. `find_edp_panel()`
  returns NULL.
- After: match `EDP_PANEL_ENTRY('H', 'K', 'C', 0x1203,
  &delay_200_500_e80, "MB116AS01'3")`.
- Path: `panel_edp_probe()` → compatible `"edp-panel"` →
  `generic_edp_panel_probe()` → EDID panel ID lookup.
- After match: `desc->delay = *detected_panel->delay` (`hpd_absent=200`,
  `unprepare=500`, `enable=80`).
- Unmatched: `WARN_ON` plus `panel_edp_set_conservative_timings()`
  (`unprepare=2000`, `enable=200`).

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **Hardware workaround / device ID** (category h).
- Mechanism: EDID mfg `HKC` (bytes `21 63`) and product `0x1203` (bytes
  `03 12`) were not mapped to delays. The panel name in EDID descriptor
  0xFE is `MB116AS01'3` (`0x27` = `'`).
- Fix: add the existing `delay_200_500_e80` preset (already used by many
  11.6" BOE/CMN entries).

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: one table row, sorted under existing HKC entries
  (`0x1203` before `0x2d51`).
- Minimal; no unrelated edits.
- Regression risk: very low. Lookup is ID-specific; other panels
  unchanged.
- `delay_200_500_e80` already exists in this tree (verified at `panel-
  edp.c:1760` on `v6.18.53`).

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Table introduced with `panel-edp` split: `5f04e7ce392db` ("Split eDP
  panels out of panel-simple").
- HKC rows already in `v6.18` / `v6.18.53` (`0x2d51`, `0x2d5b`
  MB116AN01, `0x2d5c` MB116AN01-2).
- `delay_200_500_e80` from `4d53cf8147950` ("Add several generic edp
  panels"), present in this tree.
- This ID is new; the table and delay helper are old.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. N/A. The gap is a missing table row, not a
later regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `v6.18..v6.18.53` already contains many similar one-line panel adds
  (AUO, BOE, CSW, LG, Sharp, mt8189 Chromebook panels).
- Standalone; not `patch X/Y`.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record:
- Haikun Zhou has other `panel-edp` ID/delay commits (`CSW MNB601LS1-4`,
  `CMN N116BCJ-EAK`).
- Reviewer Douglas Anderson is `R:` for "DRM DRIVER FOR GENERIC EDP
  PANELS" in MAINTAINERS.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: None. Needs only `EDP_PANEL_ENTRY`, HKC table, and
`delay_200_500_e80`, all in `v6.18.53`. Dry-run against the `v6.18.53`
blob: hunk applied (offset -5). Standalone apply: yes.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 9e55b14301666`: V2 at https://patch.msgid.link/202607010130
  18.2621972-1-zhouhaikun5@huaqin.corp-partner.google.com
- `b4 dig -a`:
  - v1 2026-06-29: `MB116AS01-3` (hyphen), msgid
    `20260629012200.248066-1-...`
  - v2 2026-07-01: `MB116AS01'3` (apostrophe, matches EDID)
- Applied version is v2.
- Doug Anderson: Reviewed-by and pushed to drm-misc-next as
  `844e71ba7d7a`.
- No NAK found.
- UNVERIFIED: exact v1 review text (lore 403, MARC 404). Name change
  v1→v2 is verified from the two patches.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`):
- To/Cc: `dianders@chromium.org`, `neil.armstrong@linaro.org`,
  `sam@ravnborg.org`, `dri-devel@lists.freedesktop.org`, `linux-
  kernel@vger.kernel.org`, `daniel@ffwll.ch`, `airlied@gmail.com`
- Subsystem reviewer included and signed off.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No syzbot/bugzilla. Evidence is the EDID dump in the patch.
Author is a hardware partner, typical for ChromeOS panel IDs.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone 1/1. drm-misc pull for 7.3-rc1 lists it under
**panel-edp: quirks** with MB116AS01 (https://lists.openwall.net/linux-
kernel/2026/08/20/246).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search returned 403. UNVERIFIED: no
stable-list thread found. Official `v6.18.53` already took the same
class of panel-edp ID patches, so there is no local policy against this
type.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: No function body change. Data: `edp_panels[]`. Consumers:
`find_edp_panel()`, `generic_edp_panel_probe()`.

Step 5.2: TRACE CALLERS
Record:
- `find_edp_panel()` ← `generic_edp_panel_probe()`
- `generic_edp_panel_probe()` ← `panel_edp_probe()` when OF compatible
  is `"edp-panel"`
- `panel_edp_probe()` ← `panel_edp_platform_probe()` /
  `panel_edp_dp_aux_ep_probe()`
- Context: device probe / display bring-up, not IRQ-hot.

Step 5.3: TRACE CALLEES
Record: Table is data only. Probe reads EDID, matches ID, copies
`panel_delay`. Delays used in `panel_edp_prepare_once()` (`hpd_absent`)
and `panel_edp_enable()` (`enable`).

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace does not call this directly. Plug in the panel
(Chromebook/laptop DT `edp-panel` on DP AUX) and it runs at
probe/resume. Reachable on machines with this HKC panel.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same file is a long ID table. HKC already has three entries.
Many sibling "Add … panel" commits are already in official 6.18.y.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: Yes. `v6.18.53` has `edp_panels[]`, HKC rows,
`find_edp_panel()`, and:
```
if (WARN_ON(!panel->detected_panel)) {
    ... "Unknown panel ... using conservative timings"
```
`MB116AS01` / `0x1203` is **not** in `v6.18` or `v6.18.53`. Bug =
missing quirk for hardware that this driver already enumerates.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: Clean apply to `v6.18.53` (dry-run succeeded, offset -5).
Surrounding HKC context matches. Difficulty: clean apply.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No other MB116AS01'3 / HKC `0x1203` fix in this series. Nearby
HKC MB116AN01 entries do not cover `0x1203`.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: `drivers/gpu/drm/panel/` — DRM panel. Criticality: **IMPORTANT**
for devices with this panel (blank/slow display, boot `WARN_ON`);
**PERIPHERAL** for everyone else (ID match is a no-op).

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Mature table, still getting ID/quirk adds. Official 6.18.y
already backports them. Not a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: Driver-specific / hardware-specific: machines whose eDP EDID is
HKC `0x1203` (MB116AS01'3), typically ChromeOS/partner laptops. No
effect on other panels.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: Every probe of `"edp-panel"` with that EDID (boot and often
resume). Not a race. Unprivileged users do not trigger it except by
using the device.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Without the entry: `WARN_ON` stack on probe (noisy, can trip panic-on-
  warn) **plus** conservative delays (2s unprepare vs 500ms; 200ms
  enable vs 80ms). Conservative path is designed so the panel still
  usually works.
- Failure mode: boot warning + slower power sequencing, not a universal
  oops.
- Severity: **MEDIUM** for affected hardware (warning + wrong timings);
  **LOW** globally.
- Still qualifies under the device-ID / quirk exception.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- Benefit: high for that panel (correct T3/T12-style delays, no
  `WARN_ON`); zero for others.
- Risk: very low (1 line, existing delay struct, ID-gated).
- Ratio: strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
FOR:
- One-line ID/quirk in an existing driver (`panel-edp.c` /
  `edp_panels[]`).
- Matches stable exceptions: **device ID** and **hardware quirk** (drm-
  misc pull even labeled it "panel-edp: quirks").
- Avoids `WARN_ON` and 2s conservative unprepare on this panel.
- `delay_200_500_e80`, HKC table, and lookup path exist in this 6.18
  tree.
- Reviewed and applied by the panel-edp maintainer.
- Official 6.18.y already contains many identical panel-edp ID
  backports.
- Applies cleanly to `v6.18.53`.

AGAINST:
- Not a UAF/crash/corruption fix for all users; unmatched panels usually
  still work with conservative delays.
- No `Reported-by` from end users; vendor EDID add.

UNRESOLVED:
- Exact v1 review comments (lore/MARC fetch failed).
- Whether this was discussed on stable@ (lore/stable 403).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one sorted table row;
   maintainer Reviewed-by and merged.
2. Fixes a real bug that affects users? **PASS** — missing quirk:
   `WARN_ON` + wrong power delays on this panel.
3. Important issue? **PASS** under the device-ID/quirk exception (boot
   warning + incorrect sequencing on real hardware). Not a core panic.
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — no new driver, syscall, or
   userspace API; only a table ID.
6. Can apply to the local tree? **PASS** — dry-run against `v6.18.53`
   succeeded.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Device ID addition to existing driver** and **hardware
quirk/workaround**. Automatic YES class.

Step 9.4: MAKE YOUR DECISION
This tree is 6.18.y. The driver already identifies unknown eDP panels
and warns. Adding HKC `0x1203` is the same kind of ID/quirk 6.18.y
already takes. Benefit is real for that hardware; risk is negligible.

What it solves for stable users: Chromebook/laptop panels with EDID HKC
`0x1203` get the intended 200/500/80 ms sequencing and stop hitting the
unknown-panel `WARN_ON`.

Risk vs benefit: one ID-gated line vs boot warning and multi-second
conservative delays. Favor backport.

Verification:
- [Phase 1] Tags: Haikun Zhou SOB, Douglas Anderson Reviewed-by + SOB,
  lore msgid link; no Fixes/Reported-by/Cc:stable
- [Phase 1] Body is raw EDID; decoded mfg HKC (`0x2163`) product
  `0x1203`; name `MB116AS01'3`
- [Phase 2] Diff: +1 `EDP_PANEL_ENTRY` in `edp_panels[]`; delay
  `&delay_200_500_e80`
- [Phase 2] Unmatched path: `WARN_ON` + `unprepare=2000`/`enable=200` in
  `generic_edp_panel_probe()` (verified in this tree and `v6.18.53`)
- [Phase 3] `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`; `make
  kernelversion` → 6.18.53
- [Phase 3] `git merge-base --is-ancestor 9e55b14301666 v6.18.53` → NO
  (not in official 6.18.53)
- [Phase 3] `git grep MB116AS01 v6.18.53 -- panel-edp.c` → not present;
  HKC `0x2d51/0x2d5b/0x2d5c` present
- [Phase 3] `delay_200_500_e80` present at line 1760 on `v6.18.53`
- [Phase 3] `v6.18..v6.18.53` already has multiple `drm/panel-edp: Add …
  panel` commits
- [Phase 4] `b4 dig -c`: V2 lore URL; `b4 dig -a`: v1 hyphen name, v2
  apostrophe; `b4 dig -w`: dianders, dri-devel, drm maintainers
- [Phase 4] LKML: Doug Reviewed-by, pushed `844e71ba7d7a` to drm-misc-
  next
- [Phase 4] drm 7.3-rc1 pull lists MB116AS01 under panel-edp quirks
- [Phase 4] UNVERIFIED: v1 review text; stable@ discussion (HTTP
  403/404)
- [Phase 5] Call chain: `panel_edp_probe` → `generic_edp_panel_probe` →
  `find_edp_panel`; delays used in prepare/enable
- [Phase 6] Dry-run `patch --dry-run` of this commit onto `v6.18.53`
  `panel-edp.c`: succeeded (offset -5)
- [Phase 7] MAINTAINERS: Douglas Anderson is `R:` for panel-edp.c
- [Phase 8] Severity: WARN_ON + wrong delays on this panel; ID-gated so
  other hardware unaffected

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index f2ae333a32d8c..0da04d75e4e96 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2061,6 +2061,7 @@ static const struct edp_panel_entry edp_panels[] = {
 
 	EDP_PANEL_ENTRY('E', 'T', 'C', 0x0000, &delay_50_500_e200_d200_po2e335, "LP079QX1-SP0V"),
 
+	EDP_PANEL_ENTRY('H', 'K', 'C', 0x1203, &delay_200_500_e80, "MB116AS01'3"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d51, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5b, &delay_200_500_e200, "MB116AN01"),
 	EDP_PANEL_ENTRY('H', 'K', 'C', 0x2d5c, &delay_200_500_e200, "MB116AN01-2"),
-- 
2.53.0

