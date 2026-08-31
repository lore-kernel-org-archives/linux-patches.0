Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C315538D62;
	Mon, 31 Aug 2026 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183930; cv=none; b=K2Koaf8ElgMJLl3dr3a4xJM0gjcHAWNlqN1GaanbiESYdDBDCEZPqI0rgPEzZ9U1T/xUYZeoc5VPvFMyd4IAS7vkL/7aGnO7t+tpaWyaAn8Eik0XYdFSr1d2IHbZU4BjzWxIZLH6kaPVW68SqKm2pg2hZUnTY+TQUauhX4fiTHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183930; c=relaxed/simple;
	bh=WxMIzKlNYlP4ysh3Rt1CyxaOBPOLCMwy2yPTL8yeioY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CfFI5wfm4GCohMKgBeOunBEGj7cFJJNgcWXfOgj6GJGeDaLmmVNW5UQ3qlC6xPw8JG/XBR9jUABmptTYtMZDFZWCeBJrLi9tztTlP/A8YQY4AFQtYr8Zqf/qniS8yIpdEVG2Za8LCkKpU+DYBHDntNgS/fevlZwnxmrUe5uoXjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QvWoi8FG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QvWoi8FG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1423C1F000E9;
	Mon, 31 Aug 2026 13:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183926;
	bh=TjMfBZZn7+QO5Fcxtz741lDPmRz3T3sRXBvHnbkWb5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvWoi8FG0sfYwo6+f1KMhRqGGoS2dc5iv9Fv8A0v2N2eOouuZBnqSQndR5SfIuFg4
	 rW395T8Q29uTBuAw/leEg3kIbSrQ+ljSc/X4ztjdwe9K4iP2eKDhAjfplmKbwMdRw0
	 2dMTcc5Cr6ANl6+X6Asv/4UhWecsRxLJwgd4gbkwtgfRPrk7Qj3woqn8JD2JQIbCRn
	 vqgY7u4dzeDmTWb2wr4Tjmby+mu4yv6xXGH95QSsSXj2O3ov4liOmKktXg+tMScP8K
	 I9mMa0/3Rrc2Xd8P8qIqPTH32huVnVx3TBFe0mjC6309WkqoVIO+OtmbBEMybUYjGF
	 dc7gv6BrPacRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>,
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
Subject: [PATCH AUTOSEL 6.18] drm/panel-edp: Add BOE NT140WHM-N4T, BOE NT140WHM-T05, BOE NV140FHM-N40
Date: Mon, 31 Aug 2026 09:26:53 -0400
Message-ID: <20260831133314.4125787-385-sashal@kernel.org>
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

From: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>

[ Upstream commit a58ff7da4835e76a5ffc078ecfd2773de90e5d8c ]

The raw EDIDs for each panel:

BOE NT140WHM-N4T
00 ff ff ff ff ff ff 00 09 e5 0d 09 00 00 00 00
01 1e 01 04 95 1f 11 78 03 f8 45 96 57 54 92 28
23 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 a9 1d 56 d0 50 00 24 30 30 20
36 00 35 ae 10 00 00 1a c6 13 56 d0 50 00 24 30
30 20 36 00 35 ae 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 11 11 21 7d 00 00 00 00 65

BOE NT140WHM-T05
00 ff ff ff ff ff ff 00 09 e5 85 0b 00 00 00 00
01 21 01 04 95 1f 11 78 03 ea a5 93 5c 58 8f 29
1d 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 c7 1d 56 e2 50 00 1e 30 30 20
36 00 35 ae 10 00 00 1a da 13 56 e2 50 00 1e 30
30 20 36 00 35 ae 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 11 11 21 7d 00 00 00 00 4e

BOE NV140FHM-N40
00 ff ff ff ff ff ff 00 09 e5 6f 0c 00 00 00 00
19 21 01 04 a5 1f 11 78 03 21 35 97 59 57 8f 29
23 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 c2 37 80 cc 70 38 28 40 6c 30
aa 00 35 ae 10 00 00 1a 2c 25 80 cc 70 38 28 40
6c 30 aa 00 35 ae 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 36 ff 0a 3c 96 09 0a 19 96 00 00 00 01 57

70 20 79 02 00 25 01 09 8c 2d 02 8c 2d 02 28 3c
80 81 00 10 6f 1a 00 00 03 01 28 3c 00 00 53 4a
53 4a 3c 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 e4 90

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260506170607.10813-3-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/panel-edp BOE Panel Additions

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (kernel 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/panel-edp]` `[Add]` — Add three BOE eDP panel entries
(NT140WHM-N4T, NT140WHM-T05, NV140FHM-N40) with power-sequencing delay
profiles.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Terry Hsiao `<terry_hsiao@compal.corp-
  partner.google.com>` (author)
- **Reviewed-by:** Douglas Anderson `<dianders@chromium.org>`
  (drm/panel-edp maintainer)
- **Signed-off-by:** Douglas Anderson `<dianders@chromium.org>`
  (maintainer merge)
- **Link:** `https://patch.msgid.link/20260506170607.10813-3-
  terry_hsiao@compal.corp-partner.google.com`
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot tags
- Notable: Reviewed and merged by subsystem maintainer; no user bug
  reports cited

### Step 1.3: Body Analysis
**Record:**
- **Bug description:** None stated. Commit provides raw EDID dumps for
  three BOE 14" eDP panels and adds matching entries to the
  `edp_panels[]` timing table.
- **Symptom/failure mode:** Without entries, panels fall back to
  conservative (non-optimized) power-sequencing delays with a `WARN_ON`
  (verified in `generic_edp_panel_probe()`).
- **Version info:** None in message.
- **Root cause:** Panels need panel-specific eDP power-sequencing
  delays; the generic fallback is intentionally conservative and
  suboptimal.

### Step 1.4: Hidden Bug Fix?
**Record:** No — this is explicit hardware enablement / timing quirk
data, not a disguised crash or leak fix. Wrong delays can still cause
flicker or suspend/resume issues on real hardware, but the commit does
not document a specific failure.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/gpu/drm/panel/panel-edp.c` (+3 lines)
- **Functions modified:** None; only `edp_panels[]` static table
- **Scope:** Single-file, surgical hardware-quirk addition

### Step 2.2: Code Flow Change
**Record:**
| Hunk | Before | After |
|------|--------|-------|
| `0x090d` entry | Unknown BOE panel → conservative timings |
`NT140WHM-N4T` → `delay_200_500_e50` |
| `0x0b85` entry | Unknown BOE panel → conservative timings |
`NT140WHM-T05` → `delay_200_500_e50` |
| `0x0c6f` entry | Unknown BOE panel → conservative timings |
`NV140FHM-N40` → `delay_200_500_e50` |

Affected path: `generic_edp_panel_probe()` → `find_edp_panel()` →
`desc->delay` applied during `panel_edp_prepare()` /
`panel_edp_enable()`.

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware workaround / panel timing quirk.**
Panels are identified by EDID panel ID at probe; missing entries trigger
`panel_edp_set_conservative_timings()` (`unprepare=2000ms`,
`enable=200ms`) instead of optimized `delay_200_500_e50`
(`hpd_absent=200`, `unprepare=500`, `enable=50`).

### Step 2.4: Fix Quality
**Record:** Obviously correct — EDID product IDs in the commit message
match the hex IDs in the table (`0x090d`, `0x0b85`, `0x0c6f`). All three
reuse an existing, widely-used delay profile already used by dozens of
BOE entries in this tree. Minimal regression risk.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Insertion points are in the BOE section of `edp_panels[]`,
last touched in this tree by `b173ba3365ff0` (NV140WUM-T08, Jan 2026)
and `5d324e5159d9e` (base 6.18 merge, Nov 2025). The table structure and
`find_edp_panel()` logic are mature.

### Step 3.2: Fixes: Tag
**Record:** N/A — no Fixes: tag.

### Step 3.3: Related Changes
**Record:** Part of Terry Hsiao's v1 4-patch series (`20260507_...mbx`),
patch 2/4. This patch is standalone — it only adds three table rows and
does not depend on patches 1, 3, or 4. Similar panel additions already
in this 6.18.y tree: `0bd968c04acfb`, `6ca4647a74155`, `b173ba3365ff0`.

### Step 3.4: Author Context
**Record:** Terry Hsiao (Compal/Google Chromebook partner). Douglas
Anderson reviewed and signed off — he is the drm/panel-edp maintainer
and author of much of this driver.

### Step 3.5: Dependencies
**Record:** None. `delay_200_500_e50` and `EDP_PANEL_ENTRY` macro both
exist in the local tree. Applies cleanly at sorted insertion points.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:** Local mbox `20260507_terry_hsiao_drm_panel_edp_add_and_updat
e_multiple_auo_boe_cmn_and_ivo_panels.mbx` contains the v1 submission.
`b4 dig -c` could not be run (no upstream commit hash in this checkout).
Lore URL blocked by bot protection.

### Step 4.2: Reviewers
**Record:** Reviewed-by and Signed-off-by: Douglas Anderson
(maintainer). Author domain: `compal.corp-partner.google.com`
(Chromebook OEM).

### Step 4.3: Bug Reports
**Record:** None. No Reported-by, syzbot, or bugzilla links.

### Step 4.4: Series Context
**Record:** v1 2/4 of a 4-patch series adding AUO/BOE/CMN/IVO panels
plus one CMN correction. This commit is independently applicable.

### Step 4.5: Stable List Discussion
**Record:** No stable-specific discussion found in the local mbox. No
stable nomination in patch headers.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `find_edp_panel()`, `generic_edp_panel_probe()`,
`panel_edp_prepare_once()`, `panel_edp_enable()` — only the table data
feeding these is changed.

### Step 5.2: Callers
**Record:** `generic_edp_panel_probe()` called from `panel_edp_probe()`
during device probe. `panel_edp_prepare_once()` / `panel_edp_enable()`
called on every display power-on/resume via DRM panel ops — common
laptop/Chromebook path.

### Step 5.3: Callees
**Record:** Timing delays drive `msleep()` / `panel_edp_wait()` in
prepare/enable/disable paths; `regulator_enable()`, HPD polling.

### Step 5.4: Reachability
**Record:** Triggered at boot and on every suspend/resume for machines
using `panel-edp` with these BOE panels. Userspace cannot directly
trigger, but all display users are affected.

### Step 5.5: Similar Patterns
**Record:** Dozens of identical one-line `EDP_PANEL_ENTRY` additions in
this file; three recent ones already backported to 6.18.y in this
checkout.

---

## PHASE 6: CROSS-REFERENCE WITH LOCAL TREE

### Step 6.1: Buggy Code Present?
**Record:** Yes. The three panel IDs (`0x090d`, `0x0b85`, `0x0c6f`) are
**not** in the local tree (grep returned no matches). Unknown panels
currently hit the conservative-timing fallback. The driver and full
`edp_panels[]` table exist.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** Insertion points verified against
current file: after `div class="highlight">0x0849`, after `0x0b66`,
after `0x0c26` — all in correct sorted order.

### Step 6.3: Related Fixes Already Present?
**Record:** No — these three panel IDs are absent. Other patches from
the same series (AUO B140HAN07.7, CMN/IVO panels) are also not present.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/gpu/drm/panel` — DRM panel driver. **Criticality:
IMPORTANT** (display on laptops/Chromebooks; not universal core kernel,
but affects all users of affected hardware).

### Step 7.2: Activity
**Record:** Actively maintained — three panel-edp additions backported
to this 6.18.y tree in recent months.

---

## PHASE 8: IMPACT AND RISK

### Step 8.1: Who Is Affected
**Record:** Users of laptops/Chromebooks with BOE NT140WHM-N4T,
NT140WHM-T05, or NV140FHM-N40 eDP panels using the generic `panel-edp`
driver.

### Step 8.2: Trigger Conditions
**Record:** Every boot and resume when these panels are present. Common
on new Chromebook hardware from Compal/Google ecosystem.

### Step 8.3: Failure Mode Severity
**Record:** Without fix: `WARN_ON` + conservative timings. Display
likely still works (driver comment: "highly likely"), but with wrong
power-sequencing delays that can cause flicker, slow resume, or
intermittent display failures. **Severity: MEDIUM** (functional
degradation, not kernel crash or data corruption).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** Correct power sequencing for three real panels;
  eliminates WARN splat; matches established stable practice for this
  driver in 6.18.y
- **Risk:** Very low — 3 lines, existing delay profile, maintainer-
  reviewed
- **Ratio:** Favorable for stable

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backport:**
- Stable exception category: hardware quirk / panel timing table entry
  (analogous to device ID additions)
- Tiny, obviously correct, maintainer-reviewed
- Applies cleanly to 6.18.43
- Identical patch type already backported to this tree (`0bd968c04acfb`,
  `6ca4647a74155`, `b173ba3365ff0`)
- Wrong eDP power sequencing can cause real suspend/resume/display
  issues
- Standalone within a series

**AGAINST backport:**
- No documented crash, security issue, or user bug report
- Fallback conservative timings exist — not a hard failure
- Arguably "new hardware support" rather than fixing a regression
- Panels may be on very new Chromebooks not yet widespread on 6.18.y

**Unresolved:** No upstream commit hash in this checkout; lore thread
inaccessible; no Tested-by on specific hardware models named in commit.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — EDID IDs verified;
   maintainer reviewed; delay profile matches sibling BOE panels
2. Fixes real bug affecting users? **PASS** (borderline) — fixes
   incorrect power sequencing for known hardware; fallback works but is
   suboptimal
3. Important issue? **PASS (MEDIUM)** — display reliability / suspend-
   resume, not crash/corruption
4. Small and contained? **PASS** — 3 lines, one file
5. No new features/APIs? **PASS** — table entries only, no API change
6. Can apply to local tree? **PASS** — driver and dependencies present;
   clean apply

### Step 9.3: Exception Category
**Record:** Hardware quirk / panel timing workaround — the stable-rules
exception for quirks that fix real-world hardware behavior. Same
category as the panel-edp additions already in 6.18.y.

### Step 9.4: Decision Rationale
For 6.18.43, this commit adds three BOE panel timing entries to an
existing, actively-maintained driver. The pattern is routinely accepted
for stable in this tree. While not a crash fix, correct eDP power
sequencing is a hardware quirk fix with low risk and clear benefit for
affected laptop/Chromebook users. Precedent in this exact tree strongly
supports backporting.

---

## Verification

- [Phase 1] `git describe HEAD` → v6.18.43; parsed subject, tags, body
  from user-provided commit
- [Phase 1] No Fixes:/Reported-by:/syzbot tags found
- [Phase 2] Diff: 3 `EDP_PANEL_ENTRY` lines in `panel-edp.c`
- [Phase 2] Read `generic_edp_panel_probe()` lines 759–832: unknown
  panel → `WARN_ON` + conservative timings
- [Phase 2] Read `panel_edp_set_conservative_timings()` lines 740–754:
  unprepare=2000, enable=200
- [Phase 2] Read `delay_200_500_e50` lines 1739–1743: hpd_absent=200,
  unprepare=500, enable=50
- [Phase 2] Verified EDID bytes → panel IDs: 0x090d, 0x0b85, 0x0c6f
- [Phase 3] `git log --oneline -5 -- drivers/gpu/drm/panel/panel-edp.c`
  → recent panel additions present
- [Phase 3] `git show 0bd968c04acfb`, `b173ba3365ff0`, `6ca4647a74155` →
  identical patch type already in 6.18.y
- [Phase 3] `git blame -L 1981,1983` → insertion context confirmed
- [Phase 4] Read local mbox/cover files; Reviewed-by: Douglas Anderson
  confirmed
- [Phase 4] `b4 dig` failed (no commit hash); lore URL blocked by bot
  protection
- [Phase 4] No stable nominations found in mbox
- [Phase 5] Grep `desc->delay` → delays used in prepare/enable/disable
  paths
- [Phase 6] Grep for `0x090d|0x0b85|0x0c6f|NT140WHM-N4T` → **not
  present** in local tree
- [Phase 6] Grep for `delay_200_500_e50` → present; `EDP_PANEL_ENTRY`
  macro present
- [Phase 6] Verified insertion points at lines 1956, 1981, 1983 match
  diff context
- [Phase 7] Three prior panel-edp backports confirmed in `git log
  --grep`
- [Phase 8] Failure mode: conservative fallback, WARN_ON — severity
  MEDIUM, not CRITICAL

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index c1ea17a0040be..105074d8cf765 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1959,6 +1959,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x08b2, &delay_200_500_e200, "NT140WHM-N49"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0848, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0849, &delay_200_500_e200, "Unknown"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x090d, &delay_200_500_e50, "NT140WHM-N4T"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09c3, &delay_200_500_e50, "NT116WHM-N21,836X2"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x094b, &delay_200_500_e50, "NT116WHM-N21"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0951, &delay_200_500_e80, "NV116WHM-N47"),
@@ -1984,8 +1985,10 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b43, &delay_200_500_e200, "NV140FHM-T09"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b56, &delay_200_500_e80, "NT140FHM-N47"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b66, &delay_200_500_e80, "NE140WUM-N6G"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b85, &delay_200_500_e50, "NT140WHM-T05"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c20, &delay_200_500_e80, "NT140FHM-N47"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c26, &delay_200_500_p2e200, "NV140WUM-T08"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c6f, &delay_200_500_e50, "NV140FHM-N40"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c93, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cb6, &delay_200_500_e200, "NT116WHM-N44"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cf6, &delay_200_500_e200, "NV140WUM-N64"),
-- 
2.53.0

