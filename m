Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99F1483819;
	Mon, 31 Aug 2026 13:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183481; cv=none; b=W9xkrsiHq3lKmPpvZJV3KK9P3zOOG0aAtQmCXqwiDq4ZNarjkiCcbYTEdilHp54xhdjEEZRGZFwXGAoztfSHmKIp0tA38lavZUnROhgVRnY9B3MTyAP14kJQYH8jbXEZJXhfiit7yt9kCXqBRTWkB6cCZD5QdJcxBDOK0TmUx0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183481; c=relaxed/simple;
	bh=+AaUSYS4rM+XeJ00SBEZldwTEaVjBX7ueB2GCU5nJek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DpFc+EDYsoCNwobK2QMtrYwdyXKGw82o2iGD5etsjCh033y2X0tFhKg1XOfTt8uvFXuPzieuG34AA83cD8VI1SPb6VGdI9IIAxSewehVGxriw8R1XLNRmTJL0BVMI3rxLFpE1v89XGjWbh4obnYrNRxtmAoiAPuj5acvFIhLrF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lvIO4CSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lvIO4CSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78CD1F00ACF;
	Mon, 31 Aug 2026 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183478;
	bh=1wCQEcFpl/B+wO/Qkouxwj4AAi2rZhGCxN2sojejBKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lvIO4CSuo4B3PnsQ3qEKF1b3WzUAaUe0DaCGdRBIkslF+qVmhrz56yEc3/y4+ajIR
	 twjt8ClOZxYUM7NaCbXBgHgxobbAMJMLAijWEOS9Ybp1R9GOyWTanwHyvNJhRbyZQL
	 TNS6t59s5SXy8MVJ7x5dKS74ZBFeYZxrns6NVClXwxSwXCJwORiBy5N3ThE+GaUIP3
	 EMTqWPrCuyFMMedgBqEby2GhKevI4Qe7yjH7iwKf5laMhXqz5R7WPvcfycMJJXfcOc
	 WvP/1NH62MUVbAtmrecYsxuUB383tNDqab+m9j+HbFj4kKugMqRl5DaEr45NxYDE9u
	 rdbKIiOFgFeRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen-Yu Tsai <wenst@chromium.org>,
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
Subject: [PATCH AUTOSEL 6.18] drm/panel-edp: Add AUO B133HAN06.6 and BOE NV133FHM-N4F V8.0
Date: Mon, 31 Aug 2026 09:22:28 -0400
Message-ID: <20260831133314.4125787-120-sashal@kernel.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 5dd1ff95c623b8118ccaae3242119b8552f7b98f ]

These two panels are found in MT8195 Dojo, a.k.a. the HP Chromebook
x360 13b-ca0xxx laptop.

Only the BOE entry was tested on an actual device. The AUO entry is
solely based on the provided datasheet.

raw EDIDs:

AUO B133HAN06.6 (from the datasheet)

00 ff ff ff ff ff ff 00 06 af 8f cb 00 00 00 00
2f 1d 01 04 95 1d 11 78 03 93 05 92 58 59 90 29
1d 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 14 37 80 b8 70 38 24 40 10 10
3e 00 25 a5 10 00 00 18 b8 24 80 b8 70 38 24 40
10 10 3e 00 25 a5 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 14 0e 1d 7d 20 20 20 00 77

BOE NV133FHM-N4F V8.0 (from an actual panel)

00 ff ff ff ff ff ff 00 09 e5 25 0a 00 00 00 00
2c 1f 01 04 95 1d 11 78 03 28 65 97 59 54 8e 27
1e 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 a4 39 80 c8 70 38 50 40 30 20
36 00 26 a5 10 00 00 1a 6d 26 80 c8 70 38 50 40
30 20 36 00 26 a5 10 00 00 1a 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 0d 40 ff 0a 3c 7d 0f 0f 1f 7d 00 00 00 00 d2

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260512045454.1505733-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
# Stable Backport Analysis: drm/panel-edp panel ID additions

**Local tree:** `v6.18.43-1-gc7f0dac02d232` (kernel version **6.18.43**)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/panel-edp]` **`Add`** — Add AUO B133HAN06.6 and BOE
NV133FHM-N4F V8.0 panel entries to the EDID-based panel timing table.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Chen-Yu Tsai `<wenst@chromium.org>` (author)
- **Reviewed-by:** Douglas Anderson `<dianders@chromium.org>`
- **Signed-off-by:** Douglas Anderson `<dianders@chromium.org>`
- **Link:**
  https://patch.msgid.link/20260512045454.1505733-1-wenst@chromium.org
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org, or
  syzbot tags

Notable: Reviewed-by from a Chromium DRM developer; BOE panel tested on
hardware per commit body.

### Step 1.3: Body analysis
**Record:**
- **Bug/problem:** Panels on HP Chromebook x360 13b-ca0xxx (MT8195 Dojo)
  are not in the `edp_panels[]` table, so the driver cannot apply
  correct eDP power-sequencing delays.
- **Symptom:** Without a table match, `generic_edp_panel_probe()`
  triggers `WARN_ON(!panel->detected_panel)` and falls back to
  conservative timings (`unprepare=2000ms`, `enable=200ms`), which can
  cause display initialization/resume problems.
- **Hardware:** MT8195 Dojo platform; BOE NV133FHM-N4F V8.0 tested on
  device; AUO B133HAN06.6 from datasheet only.
- **Root cause:** Missing EDID panel-ID → delay-profile mapping for
  these two product IDs (`0xcb8f` AUO, `0x0a25` BOE).

### Step 1.4: Hidden bug fix?
**Record:** Yes. Although labeled "Add", this is a hardware-timing quirk
fix. Unknown panels get wrong power-sequencing delays and a `WARN_ON` on
every probe. Adding the entries supplies panel-specific delays needed
for reliable display operation.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/gpu/drm/panel/panel-edp.c` (+2 lines)
- **Functions modified:** None directly; changes are in static
  `edp_panels[]` table
- **Scope:** Single-file, surgical panel-ID addition

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (AUO):** Inserts `EDP_PANEL_ENTRY('A','U','O', 0xcb8f,
  &delay_200_500_e50, "B133HAN06.6")` after `0xc9a8`.
  - Before: AUO `0xcb8f` unmatched → conservative fallback.
  - After: Matched → `desc->delay = *panel->detected_panel->delay` with
    standard AUO delay profile.
- **Hunk 2 (BOE):** Inserts `EDP_PANEL_ENTRY('B','O','E', 0x0a25,
  &delay_200_500_e50_po2e200, "NV133FHM-N4F V8.0")` after `0x0a1b`.
  - Before: BOE `0x0a25` unmatched → conservative fallback.
  - After: Matched → delay profile including
    `powered_on_to_enable=200ms` (same profile as existing NV133FHM-N42
    at `0x0717`).

### Step 2.3: Bug mechanism
**Record:** **Hardware quirk / panel timing table entry** (allowed
stable exception). `find_edp_panel()` returns NULL for unknown IDs;
probe path then uses overly conservative delays unsuitable for these
panels' eDP power sequencing.

### Step 2.4: Fix quality
**Record:** Fix is minimal and follows established patterns in the same
table. BOE uses the same `delay_200_500_e50_po2e200` profile as a
related NV133FHM panel already in-tree. AUO uses the common
`delay_200_500_e50` profile used by many AUO entries. Regression risk is
very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Insertion-point lines in current tree date to
`6bda50f4333fa` (Nov 29, 2025), which added the entire `panel-edp.c`
driver to 6.18. The missing panel entries are absent because this commit
has not been applied yet—not because the code is structurally different.

### Step 3.2: Fixes: tag
**Record:** N/A — no Fixes: tag present.

### Step 3.3: Related file history
**Record:** Recent panel-edp additions already in this 6.18.y tree:
- `0bd968c04acfb` — Add AUO B140QAX01.H panel
- `6ca4647a74155` — Add AUO B140HAN06.4
- `b173ba3365ff0` — Add BOE NV140WUM-T08 panel

Same pattern of single-line `EDP_PANEL_ENTRY` additions. Standalone; not
part of a multi-patch series.

### Step 3.4: Author context
**Record:** Chen-Yu Tsai (Chromium) is a regular MT8195/Chromebook
contributor. Douglas Anderson (Chromium DRM) reviewed. No other commits
from this author in `panel-edp.c` in this tree, but the subsystem
maintainership pattern matches other Chromium panel additions.

### Step 3.5: Dependencies
**Record:** No dependencies. Requires only:
- `panel-edp.c` driver (present since 6.18)
- `delay_200_500_e50` and `delay_200_500_e50_po2e200` delay structs
  (both present at lines 1818+ in current tree)
- `EDP_PANEL_ENTRY` macro (present)

Patch applies cleanly at verified insertion points (after
`0xc9a8`/`0xcdba` and `0x0a1b`/`0x0a36`).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:** Link tag points to patch.msgid.link thread. **Could not
fetch** — lore.kernel.org and patch.msgid.link blocked by Anubis bot
protection. `b4 dig -c` could not run because the upstream commit hash
is not in this checkout.

### Step 4.2: Reviewers
**Record:** Reviewed-by and Signed-off-by from Douglas Anderson
(Chromium DRM developer). UNVERIFIED: full recipient list via `b4 dig
-w`.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Hardware enablement
driven by Chromebook platform need (MT8195 Dojo).

### Step 4.4: Related patches
**Record:** Same author/subsystem pattern as Terry Hsiao's May 2026
batch of panel-edp additions (separate series in workspace mbox files).
This commit is standalone (1/1).

### Step 4.5: Stable list discussion
**Record:** UNVERIFIED — could not search lore stable list due to access
restrictions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** Affected lookup path: `find_edp_panel()` → called from
`generic_edp_panel_probe()`.

### Step 5.2: Callers
**Record:** `generic_edp_panel_probe()` is invoked during `panel_edp`
device probe on platforms using `compatible = "edp-panel"`. MT8195
Cherry/Dojo DTS in this tree uses this compatible string.

### Step 5.3: Callees
**Record:** `find_edp_panel()` uses `drm_edid_match()` and panel-ID
comparison against `edp_panels[]`. On match, `desc->delay =
*panel->detected_panel->delay` sets power-sequencing parameters used by
`panel_edp_prepare()`, `panel_edp_enable()`, and suspend/resume paths.

### Step 5.4: Reachability
**Record:** Triggered at boot on every MT8195 Dojo machine with these
panels — common Chromebook laptop path, not an obscure config option.

### Step 5.5: Similar patterns
**Record:** BOE NV133FHM-N4F V8.0 uses identical delay profile to
existing `NV133FHM-N42` (`0x0717`). Many AUO entries use
`delay_200_500_e50`. Consistent with table conventions.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** `panel-edp.c` exists; `edp_panels[]` table exists;
`0xcb8f` and `0x0a25` entries are **absent** (grep confirmed no
matches). MT8195 Dojo platform support exists
(`arch/arm64/boot/dts/mediatek/mt8195-cherry-dojo-r1.dts`,
`mt8195-cherry.dtsi` with `compatible = "edp-panel"`).

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion anchor lines (`0xc9a8`,
`0x0a1b`) match exactly between patch context and current tree.

### Step 6.3: Related fixes already present?
**Record:** No — panel IDs not present. Similar panel additions
(B140QAX01.H, B140HAN06.4, NV140WUM-T08) are already in this 6.18.y
tree, establishing precedent.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem
**Record:** `drivers/gpu/drm/panel/` — DRM panel driver. **Criticality:
IMPORTANT** (display subsystem; affects laptop users on supported
platform, not universal core kernel).

### Step 7.2: Activity
**Record:** `panel-edp.c` is new in 6.18 (added Nov 2025); actively
receiving panel-ID additions in this stable series.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of HP Chromebook x360 13b-ca0xxx (MT8195 Dojo) and any
other systems shipping AUO B133HAN06.6 or BOE NV133FHM-N4F V8.0 panels
with the generic `edp-panel` driver. Platform-specific, driver-specific.

### Step 8.2: Trigger conditions
**Record:** Every boot and resume when EDID reports panel IDs `0xcb8f`
or `0x0a25`. Highly likely on affected hardware — not a rare race.

### Step 8.3: Failure mode severity
**Record:** Without fix: `WARN_ON` on probe + wrong power-sequencing
delays (2000ms unprepare vs. 500ms; missing `powered_on_to_enable` for
BOE). Can cause black screen, flicker, or failed resume. **Severity:
MEDIUM-HIGH** for affected users (display reliability, not kernel
crash/security).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables correct display power sequencing on real shipping
  Chromebook hardware already supported in this tree.
- **Risk:** Very low — two table entries, no logic changes, delay
  profiles already used by other panels.
- **Ratio:** Strong benefit, minimal risk.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real display issue on HP Chromebook x360 13b (MT8195 Dojo) —
  platform in this tree
- BOE entry tested on hardware
- Tiny, surgical change (2 lines)
- Follows established pattern; similar commits already in 6.18.y
- Hardware quirk / panel-ID exception category
- Clean apply to current tree
- Reviewed-by from Chromium DRM developer

**AGAINST backport:**
- AUO entry untested (datasheet only) — minor concern, standard practice
  for this table
- Not a crash/security/data-corruption fix — display reliability issue
- Lore discussion unverified

**Unresolved:** Mailing list thread content; whether stable was
explicitly nominated in review.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — BOE tested; AUO follows
   datasheet + standard delay profile
2. Fixes real bug affecting users? **PASS** — wrong panel delays on real
   hardware
3. Important issue? **PASS** — display reliability on shipping
   Chromebook (MEDIUM-HIGH)
4. Small and contained? **PASS** — 2 lines, one file
5. No new features/APIs? **PASS** — panel table entries only (allowed
   exception)
6. Can apply to local tree? **PASS** — driver, delay structs, and
   insertion points all present

### Step 9.3: Exception category
**Record:** **Hardware quirk / panel timing workaround** — adding EDID
panel-ID entries with power-sequencing delays to an existing driver,
analogous to USB/PCI quirks and device-ID additions.

### Step 9.4: Decision rationale

This commit should be backported to **Linux 6.18.y**. The `panel-edp`
driver and MT8195 Dojo platform are both present in this tree, but these
panel IDs are missing. Without them, affected Chromebooks get incorrect
eDP power-sequencing delays and a `WARN_ON` on every probe. The fix is
two lines, uses delay profiles already in the table, and matches the
pattern of panel additions already accepted into this stable series.

---

## Verification

- [Phase 1] Parsed subject, tags, body; identified hardware enablement
  intent and BOE on-device testing
- [Phase 2] Diff analysis: 2 `EDP_PANEL_ENTRY` lines added to
  `edp_panels[]`
- [Phase 3] `git describe HEAD`: v6.18.43-1-gc7f0dac02d232; `make
  kernelversion`: 6.18.43
- [Phase 3] `git blame` on lines 1918-1925, 1966-1972: table from
  `6bda50f4333fa` (Nov 2025)
- [Phase 3] `git log --grep=panel-edp`: similar additions
  `0bd968c04acfb`, `6ca4647a74155`, `b173ba3365ff0` already in tree
- [Phase 3] Grep `0xcb8f|0x0a25|B133HAN06|NV133FHM-N4F` in panel-edp.c:
  no matches — entries absent
- [Phase 3] Verified insertion anchors `0xc9a8`, `0xcdba`, `0x0a1b`
  exist at lines 1921, 1922, 1969
- [Phase 3] Verified `delay_200_500_e50` and `delay_200_500_e50_po2e200`
  exist at line 1818+
- [Phase 4] WebFetch lore.kernel.org and patch.msgid.link: **FAILED**
  (Anubis bot block)
- [Phase 4] `b4 dig -c`: **NOT RUN** — upstream commit hash not in
  checkout
- [Phase 5] Read `generic_edp_panel_probe()` lines 759-825: confirmed
  NULL `detected_panel` → WARN_ON + conservative timings
- [Phase 5] Read `find_edp_panel()` lines 2091-2113: confirmed lookup
  mechanism
- [Phase 5] Confirmed NV133FHM-N42 (`0x0717`) uses same
  `delay_200_500_e50_po2e200` profile
- [Phase 6] Grep Dojo DTS: `mt8195-cherry-dojo-r1.dts` and
  `mt8195-cherry.dtsi` with `compatible = "edp-panel"` present
- [Phase 6] Confirmed patch context matches current file structure for
  clean apply
- [Phase 8] Failure mode: wrong delays + WARN_ON on display probe;
  severity MEDIUM-HIGH for affected laptops
- **UNVERIFIED:** Mailing list review discussion and stable nomination
  comments
- **UNVERIFIED:** Whether AUO panel is actually shipped on Dojo SKUs
  (commit says both found on platform; only BOE tested)

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 105074d8cf765..c6d1dfdd64f2e 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1924,6 +1924,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc4b4, &delay_200_500_e50, "B116XAT04.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc7ad, &delay_200_500_e50, "B140HAN07.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc9a8, &delay_200_500_e50, "B140QAN08.H"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0xcb8f, &delay_200_500_e50, "B133HAN06.6"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xcdba, &delay_200_500_e50, "B140UAX01.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xd497, &delay_200_500_e50, "B120XAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xf390, &delay_200_500_e50, "B140XTN07.7"),
@@ -1973,6 +1974,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09ae, &delay_200_500_e200, "NT140FHM-N45"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x09dd, &delay_200_500_e50, "NT116WHM-N21"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a1b, &delay_200_500_e50, "NV133WUM-N63"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a25, &delay_200_500_e50_po2e200, "NV133FHM-N4F V8.0"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a36, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a3e, &delay_200_500_e80_d50, "NV116WHM-N49"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a5d, &delay_200_500_e50, "NV116WHM-N45"),
-- 
2.53.0

