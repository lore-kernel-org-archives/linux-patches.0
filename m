Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444C152630F;
	Mon, 19 Oct 2026 14:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418563; cv=none; b=KA1EMPkXf1t2wsoRaKHleYlMzPfdA08st12zAjcsyokQppSWAADDp0Jaoet/Rjht9vv8VPIr4ryQ7kbRmKXsDaxdqDlN+Qj+Py2Xa2+/1BRoMRHBUP7HnxsnyaHwq0BDkHJQ4AI+vTzZhr2uzvOc/U9lISQ8Q+WQwXBf1jjBBYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418563; c=relaxed/simple;
	bh=AOsWfJuoJDvX7ByDM7Vf7LfNMc4cy7pjSELySqeZQi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6prRQA3yP3TtriMYMO6OUe/oQoajUSr2eZFUTwfUcgW70ZUr/h8rO4ZXLEt+fAtkpXP5/rn99AzYtUYgFYbVqCSeVpnGGrNX9pwroKpRc07wxSMRuDVNWI77xX5ULSXy3D/4LEiclOohurXk2NlyL5mOJYjCZxsWCVSCt9QTuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yb+UmcD3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yb+UmcD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77D31F000C4;
	Mon, 19 Oct 2026 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418561;
	bh=Vkm5se3sleZ4W01YvoOsLxYeEyqn9p7dB6Bn8zv0Cgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yb+UmcD39/UrVj8yqe9pjGbNTxyQUMEOdVaPID8jPWu9JSqMR/UZ5j4cvKTZIPWUJ
	 pdQuVYz9f8x4vKH9ifqh8qtuwcB0qWaAknY55XAqpcL5vUCe341byJjmWG63Mi7SkU
	 JPeCiD4prJ1gY/8tcZFmSsyRYo+efD3ouEVkFa17gXt7C6j3gSgSrrwaGZ/RhYeu4R
	 gCEsdc2hmkcJxt+UhFK25+2bC4gG6gaDf5gg2BLDUgcr2A+VHiEPVc3v8/4EMAHJT2
	 YI4nIqxnffG/qyC1VyhMlpJhMA2L8BzMJ/MiRG2eBjyLoFNz2tsA8iC/9Rjrz0z7i9
	 PFwpT8fzE5jRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Damon Ding <damon.ding@rock-chips.com>,
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
Subject: [PATCH AUTOSEL 6.18-6.6] drm/panel-edp: Add BOE NE160QDM-NY1 panel
Date: Mon, 19 Oct 2026 09:50:26 -0400
Message-ID: <20261019135441.1420968-335-sashal@kernel.org>
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

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit be4f10d44757211fd656fa57f37034657f26c883 ]

Add an entry for the BOE NE160QDM-NY1 eDP panel. The panel's AUX
backlight functionality is verified and working on the RK3576 EVB1
board.

edid-decode (hex):

00 ff ff ff ff ff ff 00 09 e5 85 09 00 00 00 00
1c 1e 01 04 b5 22 15 78 03 7c e5 a4 55 4c 9f 26
0f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 6b 6e 00 a0 a0 40 84 60 30 20
36 00 58 d7 10 00 00 1a 00 00 00 fd 0c 3c a5 1f
1f 4e 01 0a 20 20 20 20 20 20 00 00 00 fe 00 42
4f 45 20 43 51 0a 20 20 20 20 20 20 00 00 00 fe
00 4e 45 31 36 30 51 44 4d 2d 4e 59 31 0a 01 ed

02 03 1d 00 e3 05 80 00 e6 06 05 01 6a 6a 24 6d
1a 00 00 02 03 3c a5 00 04 6a 24 6a 24 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ff

Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260625071916.744686-1-damon.ding@rock-chips.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line eDP panel ID for a driver that already exists in
6.18.y. That matches the stable device-ID exception, and unknown panels
already `WARN_ON` on probe.

Local tree: **6.18.53** (`v6.18.53-5049-g0f0bdc2b0dffb`, Makefile
`VERSION=6 PATCHLEVEL=18 SUBLEVEL=53`). Upstream commit `be4f10d44757`
is **not** in `v6.18.53`; `panel-edp.c` and `delay_200_500_e50` are.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Record: `[drm/panel-edp] [Add] [BOE NE160QDM-NY1 panel table entry]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- Record: No `Fixes:` (expected). No `Reported-by` / `Tested-by` / `Cc:
  stable`.
- `Reviewed-by: Douglas Anderson <dianders@chromium.org>` (panel-edp
  reviewer in MAINTAINERS)
- `Signed-off-by: Damon Ding <damon.ding@rock-chips.com>` (author)
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>` (drm-misc
  maintainer path)
- `Link:
  https://patch.msgid.link/20260625071916.744686-1-damon.ding@rock-
  chips.com`
- Ignored: `[Upstream commit be4f10d44757…]`, `Signed-off-by: Sasha
  Levin` (candidate pipeline)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
- Record: [Bug] Generic `edp-panel` probe looks up EDID vendor/product
  in `edp_panels[]`. BOE 0x0985 is missing, so this panel is treated as
  unknown.
- [Symptom] Kernel `WARN_ON` on probe plus conservative delays
  (`unprepare=2000`, `enable=200`) instead of the panel’s 500/50 ms
  sequence. AUX backlight was verified on RK3576 EVB1.
- [Version] None stated.
- [Root cause] Missing table entry; timings otherwise come from EDID.

**Step 1.4: DETECT HIDDEN BUG FIXES**
- Record: Not a disguised cleanup. It is a device-ID addition. The
  unknown-panel path also fires a deliberate `WARN_ON`, so the ID stops
  a real boot warning.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- Record: `drivers/gpu/drm/panel/panel-edp.c` +1 / −0. One function/data
  object: `edp_panels[]`. Single-file surgical change.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- Record: Before: BOE IDs jump 0x0979 → 0x098d. After: 0x0985 maps to
  `&delay_200_500_e50` named `"NE160QDM-NY1"`. Only the generic EDID
  lookup path in `generic_edp_panel_probe()` is affected.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
- Record: [Category] Hardware ID / quirk table. [Mechanism] Missing EDID
  product ID; `find_edp_panel()` returns NULL → `WARN_ON` + conservative
  delays. The new row uses an existing delay struct.

**Step 2.4: ASSESS THE FIX QUALITY**
- Record: Obviously correct: one `EDP_PANEL_ENTRY` in vendor/product
  sort order. EDID bytes `09 e5 85 09` decode to BOE + 0x0985.
  Regression risk is very low (only this ID). No API, lock, or lifetime
  changes.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Record: Surrounding BOE rows date from 2021–2026. Table machinery:
  `5f04e7ce392db` (2021-09-20, split from panel-simple) and
  `5540cf8f3e8da` (generic EDID-probed panels). Both are ancestors of
  `v6.18.53`.

**Step 3.2: FOLLOW THE FIXES: TAG**
- Record: No `Fixes:` tag. Not applicable. The “bug” is an absent ID,
  not a later regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
- Record: `v6.18.53` already has many `drm/panel-edp: Add …` ID patches
  (72 log hits). Standalone; not `patch X/Y`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
- Record: Damon Ding has another panel-edp ID add (`LP079QX1-SP0V`).
  Reviewer Douglas Anderson is listed under “DRM DRIVER FOR GENERIC EDP
  PANELS”.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
- Record: Needs `EDP_PANEL_ENTRY`, `delay_200_500_e50`, and
  `edp_panels[]` — all present in `v6.18.53`. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
- Record: `b4 dig -c be4f10d44757` →
  https://patch.msgid.link/20260625071916.744686-1-damon.ding@rock-
  chips.com
- `b4 dig -a`: single **v1**, no later revisions.
- Doug Anderson: `Reviewed-by` and pushed to drm-misc-next as
  `be4f10d44757`. No NAKs, no stable discussion in-thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
- Record: `b4 dig -w` To/Cc: Douglas Anderson, Neil Armstrong, drm-misc
  maintainers, `dri-devel`, `linux-kernel`. Right audience.

**Step 4.3: SEARCH FOR THE BUG REPORT**
- Record: No syzbot/bugzilla. Author tested AUX backlight on RK3576
  EVB1. Panelook lists this as a 16" eDP laptop panel (Lenovo FRUs);
  that is third-party catalog data, not a kernel bug report.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
- Record: Standalone 1/1 series. No prerequisite panel patches.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
- Record: lore.kernel.org/stable returned HTTP 403. Unverified whether
  stable@ already discussed this ID. Same class of adds is already in
  6.18.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- Record: Data only: `edp_panels[]`. Consumers: `find_edp_panel()`,
  `generic_edp_panel_probe()`.

**Step 5.2: TRACE CALLERS**
- Record: `find_edp_panel()` ← `generic_edp_panel_probe()` ←
  `panel_edp_probe()` when DT compatible is `"edp-panel"`. Also
  `panel_edp_platform_probe` / DP-AUX probe. Probe-time, not interrupt.

**Step 5.3: TRACE CALLEES**
- Record: Lookup is a table walk (`drm_edid_match` / `panel_id`
  compare). Match copies `delay_200_500_e50`. Miss calls
  `panel_edp_set_conservative_timings()` after `WARN_ON`.

**Step 5.4: FOLLOW THE CALL CHAIN**
- Record: Userspace cannot call this directly. Any machine with
  `compatible = "edp-panel"` and this EDID hits it at boot (Chromebooks,
  Qualcomm laptops, Rockchip EVBs, etc.).

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
- Record: Same one-line `EDP_PANEL_ENTRY` pattern used throughout the
  table. No duplicate BOE 0x0985.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
- Record: Yes. `v6.18.53` `panel-edp.c` has 0x0979 then 0x098d; 0x0985
  is absent. `git merge-base --is-ancestor be4f10d44757 v6.18.53` is
  false. `delay_200_500_e50` and the unknown-panel `WARN_ON` are
  present.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
- Record: Clean apply. Insertion point and neighbors match the upstream
  diff. Expected difficulty: clean apply.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
- Record: No other 0x0985 / NE160QDM-NY1 entry in `v6.18.53`. (HEAD on
  `autosel` already has the candidate; that is pipeline state, not a
  reason to skip the technical YES.)

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Record: [drm/panel-edp] [IMPORTANT] — common generic eDP path for
  ARM/laptop panels, not core mm/VFS. `DRM_PANEL_EDP` depends on `OF`.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
- Record: Active; 6.18.y already backports many panel IDs. Mature table
  plus ongoing ID adds.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
- Record: Driver/config-specific: `CONFIG_DRM_PANEL_EDP` + this BOE
  panel + generic `edp-panel`. RK3576 EVB1 DTS is in 6.18.53 (main DTS
  has HDMI, not eDP; matching is EDID-based so any `edp-panel` board
  with this module benefits).

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
- Record: Every probe of this panel. Not a race. Unprivileged users do
  not trigger it; boot/display init does. Common for that hardware.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Record: [WARN_ON + conservative 2s unprepare] [MEDIUM]. Display
  usually still works; boot warning and slow power sequencing are the
  user-visible issues. Without the ID, AUX backlight can still work
  (author’s point is that it was tested once identified).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Record: [Benefit: high for those panels — stops WARN_ON, correct
  delays] [Risk: very low, +1 table line] [Ratio: strongly favors
  backport]

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Stable rule: “fix a real bug **or just add a device ID**”
  (`Documentation/process/stable-kernel-rules.rst`).
- Explicit exception: new IDs in an existing driver.
- One line; uses existing `delay_200_500_e50`.
- Stops `WARN_ON(!panel->detected_panel)` in
  `generic_edp_panel_probe()`.
- Reviewed and merged by the panel-edp reviewer.
- Driver and helpers exist in this 6.18.y tree; apply is clean.
- Same class of commits is already routine in this series.

AGAINST:
- Not a crash/UAF/CVE.
- Affects only this panel.
- No `Cc: stable` (not a negative under these rules).

UNRESOLVED:
- lore.kernel.org/stable search was 403.
- Upstream RK3576 EVB1 DTS does not describe the eDP panel; hardware
  enablement still depends on DT/`edp-panel` on the board.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — v1 accepted; tested on
   RK3576 EVB1; maintainer R-b.
2. Fixes a real bug that affects users? **PASS** — missing ID is the
   documented device-ID case; also avoids WARN_ON.
3. Important issue? **PASS** as device-ID exception (WARN_ON is MEDIUM,
   not panic).
4. Small and contained? **PASS** — +1 line, one file.
5. No new features or APIs? **PASS** — ID only, existing driver.
6. Can apply to the local tree? **PASS** — context identical in
   `v6.18.53`.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
- Record: **Device ID addition to existing driver** (`EDP_PANEL_ENTRY` =
  EDID vendor/product ID).

**Step 9.4: DECISION**
Backport. This is the standard panel-edp ID add: hardware support plus
removal of a probe `WARN_ON`, with negligible risk on 6.18.y.

---

### What problem it solves for stable users

Boards using generic `edp-panel` with a BOE NE160QDM-NY1 (EDID BOE
0x0985) currently miss the table, hit `WARN_ON` every boot, and use
2000/200 ms conservative delays instead of 500/50 ms. Adding the ID
matches how this driver is meant to be extended.

### Risk vs benefit

Benefit: correct sequencing and no warning on that panel. Risk: one
sorted table row, no behavior change for other IDs.

### Concerns

None for this tree. No extra commits required. Ignore pipeline markers
(`[Upstream commit]`, Sasha SOB, presence on `autosel`).

---

Verification:
- [Phase 1] Parsed subject/tags: Add panel ID; R-b dianders; Link msgid
  20260625071916.744686-1; no Fixes/syzbot
- [Phase 1] Body: AUX backlight tested on RK3576 EVB1; full EDID dump
- [Phase 2] Diff: +1
  `EDP_PANEL_ENTRY('B','O','E',0x0985,&delay_200_500_e50,"NE160QDM-
  NY1")` in `edp_panels[]`
- [Phase 2] EDID `09 e5 85 09` → BOE + product 0x0985 (verified against
  commit hex)
- [Phase 2] `generic_edp_panel_probe()`:
  `WARN_ON(!panel->detected_panel)` then
  `panel_edp_set_conservative_timings()` (unprepare 2000, enable 200)
- [Phase 3] `git describe HEAD` / `make kernelversion`: 6.18.53
- [Phase 3] `git merge-base --is-ancestor be4f10d44757 v6.18.53`: **no**
  (not in the release)
- [Phase 3] `git grep NE160QDM-NY1 v6.18.53 -- panel-edp.c`: missing
- [Phase 3] `delay_200_500_e50` at `v6.18.53:panel-edp.c:1746`;
  neighbors 0x0979 then 0x098d — clean insert
- [Phase 3] Driver added `5f04e7ce392db` (2021); generic table
  `5540cf8f3e8da`; both in 6.18.53
- [Phase 3] `git log v6.18.53 --grep='drm/panel-edp: Add'`: 72 similar
  ID commits already in this series
- [Phase 4] `b4 dig -c be4f10d44757`: v1 only; lore msgid as in Link
- [Phase 4] `b4 dig -a`: no v2+
- [Phase 4] `b4 dig -w`: dianders, dri-devel, drm-misc maintainers
- [Phase 4] Anderson reply: Reviewed-by + pushed drm-misc-next
  `be4f10d44757`; no NAK
- [Phase 4] lore.kernel.org/stable: **UNVERIFIED** (HTTP 403)
- [Phase 5] Callers: `panel_edp_probe` → `generic_edp_panel_probe` if
  `compatible = "edp-panel"`
- [Phase 5] No duplicate 0x0985 in `panel-edp.c`
- [Phase 6] `rk3576-evb1-v10.dts` exists in v6.18.53; no eDP panel node
  in that DTS (EDID match still applies wherever `edp-panel` is used)
- [Phase 7] MAINTAINERS: “DRM DRIVER FOR GENERIC EDP PANELS”, R: Douglas
  Anderson
- [Phase 8] Failure: WARN_ON + slow unprepare; not oops; device-ID
  exception still applies
- UNVERIFIED: stable@ archive discussion; how many shipping laptops use
  this exact module

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 792923b1d7878..f2ae333a32d8c 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1975,6 +1975,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0964, &delay_200_500_e50, "NV133WUM-N61"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x096e, &delay_200_500_e50_po2e200, "NV116WHM-T07 V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0979, &delay_200_500_e50, "NV116WHM-N49 V8.0"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0985, &delay_200_500_e50, "NE160QDM-NY1"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x098d, &boe_nv110wtm_n61.delay, "NV110WTM-N61"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0993, &delay_200_500_e80, "NV116WHM-T14 V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09ad, &delay_200_500_e80, "NV116WHM-N47"),
-- 
2.53.0

