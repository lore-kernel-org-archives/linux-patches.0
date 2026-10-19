Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6CC547055;
	Mon, 19 Oct 2026 13:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418123; cv=none; b=Sj8s7N20dzmql6+BZxwi6KpJBsJaDS1uQO7VmeUcC7gNuN1kJJxVRp58yvEdnuSwC8qT0PICZSi1kR0ydBCMT/XDtuJXPspa/QvMy242iMVrVe1DscOBH92HwLY3KhxdywoibGPrL72lx1U6O0nEHOm9jKha5v3Vv2dhmzLXsNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418123; c=relaxed/simple;
	bh=6MkNtGr4amCWFbF87aKQUi2Elw82i+dKvZ0St44wBxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHv6VLkRGYB4+HFC4VNwKvWthPa3R4zlOzcwJ+hqs9DRXNr2t0tMOOrboLZPJrNSzrdPfZxGG11WtoxSSOqWOamRBO5XT1fsbfI3kcd/ZpmAOXsznWzMpIYlGyeq8z3QeplionOeDtC3g+7NFCE6qfyAMAR+pBMjfm4YVFXRkpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UdkQ333E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UdkQ333E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23221F000C6;
	Mon, 19 Oct 2026 13:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418121;
	bh=5/1jcJJIxX8v0UySJxP1SWO0UmoewAoWmMe6s3O/mbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UdkQ333Evo2RiWHbejzCh7Q1i2pm32dyAwpHgCVY6rldqY7PFj+AHvNdSWQGUNeyQ
	 rW1hqWX80gEiFZYrO6yw3cHyJllsn2RubwjyW9+kSjqNvoM/nbOL1MDVyXAGsOGCRL
	 pad5mibffMFKBffmF6vceSePsMoI+x0kTB/qVJgY3sYfprbGQfQEO7WeKXTx2rOOys
	 by/JSd8uY8nmZ8Mcgg4Cjge6GmUMxBvm0kM53FKKZHiKHG+lqVgLuoplZRhAQjrPtg
	 5LDn58u/5Owqm9QApvOlUV6ljlQncPz0aiGIBJW82PHiSI9MLoZmh8Xza8KrKOtc0M
	 uQwLhLofd9xKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Weiji Wang <nebclllo0444@gmail.com>,
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
Subject: [PATCH AUTOSEL 6.18] drm/panel-edp: Add BOE NE140QDM-NX2
Date: Mon, 19 Oct 2026 09:45:17 -0400
Message-ID: <20261019135441.1420968-26-sashal@kernel.org>
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

From: Weiji Wang <nebclllo0444@gmail.com>

[ Upstream commit 354b9c43d36ce9b41e48b2d67c5d9b953a0e9d64 ]

Add timing from datasheet for BOE NE140QDM-NX2.

edid-decode (hex):

00 ff ff ff ff ff ff 00 09 e5 f2 0a 00 00 00 00
20 1f 01 04 a5 1e 13 78 03 ee 96 a3 54 4c 99 26
0f 4e 51 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 60 d2 00 a0 a0 40 32 60 30 20
35 00 2e bd 10 00 00 18 c8 9d 00 a0 a0 40 32 60
30 20 35 00 2e bd 10 00 00 18 00 00 00 fd 00 30
78 c6 c6 36 01 0a 20 20 20 20 20 20 00 00 00 fe
00 4e 45 31 34 30 51 44 4d 2d 4e 58 32 20 01 f8

70 13 79 00 00 03 01 14 30 69 00 05 ff 09 9f 00
2f 00 1f 00 3f 06 31 00 02 00 04 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 4d 90

Signed-off-by: Weiji Wang <nebclllo0444@gmail.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/82fc6395-3425-4f71-ba58-813856cee61d@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[drm/panel-edp] [Add] [one-line BOE NE140QDM-NX2 panel-id /
delay table entry]`

**Step 1.2: Tags**
Record:
- `Signed-off-by: Weiji Wang <nebclllo0444@gmail.com>` (author)
- `Reviewed-by: Douglas Anderson <dianders@chromium.org>` (listed `R:`
  for this driver in MAINTAINERS)
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>` (applied via
  drm-misc)
- `Link: https://patch.msgid.link/82fc6395-3425-4f71-ba58-
  813856cee61d@gmail.com`
- No `Fixes:`, no `Cc: stable`, no `Reported-by`, no `Tested-by` tag
  (author later said they verified on `next-20260726` in the v1 thread)
- Ignore pipeline `Signed-off-by: Sasha Levin` / `[Upstream commit ...]`
  if present

**Step 1.3: Body**
Record:
- Claimed intent: add datasheet timing for BOE NE140QDM-NX2.
- Failure mode is not a crash dump; it is missing table data for a real
  eDP panel identified by EDID.
- Included raw EDID (base + CTA). Manufacturer `09 e5` is BOE; product
  `f2 0a` little-endian is `0x0af2`; ASCII descriptor is `NE140QDM-NX2`.
- Root cause: generic `edp-panel` path looks up power-seq delays by
  panel ID; this ID was absent.

**Step 1.4: Hidden bug fix?**
Record: Not a disguised UAF/leak. It is hardware-table enablement.
Without the row, `generic_edp_panel_probe()` hits
`WARN_ON(!panel->detected_panel)` and falls back to conservative delays
(2000 ms unprepare / 200 ms enable). That is a real user-visible issue
for this panel (warning + slow suspend/resume), not style cleanup.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/gpu/drm/panel/panel-edp.c` (+1 / −0)
- Function/data: `edp_panels[]` only
- Scope: single-file, one table row

**Step 2.2: Code flow**
Record:
- Before: BOE IDs jump from `0x0ae8` (NV140WUM-N41) to `0x0b09`
  (NV140FHM-NZ). `0x0af2` is unknown.
- After: `EDP_PANEL_ENTRY('B', 'O', 'E', 0x0af2,
  &delay_200_500_e50_p2e80, "NE140QDM-NX2")`.
- Path: probe of compatible `"edp-panel"` → `generic_edp_panel_probe()`
  → `find_edp_panel()` → copy `*delay` into `desc`. Modes still come
  from EDID (`override_edid_mode` is not set).

**Step 2.3: Bug mechanism**
Record: **Hardware ID / quirk table** (device-ID exception). Not a
memory-safety bug. Missing identity causes:
1. `WARN_ON` splat at probe
2. `panel_edp_set_conservative_timings()`: `unprepare=2000`,
   `enable=200`, vs datasheet delays `hpd_absent=200`, `unprepare=500`,
   `enable=50`, `prepare_to_enable=80`

**Step 2.4: Fix quality**
Record: Obviously correct one-liner using an existing delay blob. Sorted
by product ID. Regression risk is confined to this panel ID; other
panels are untouched. Commit text says “timing” but the row only sets
**power sequencing**; that matches the driver’s design comment “Update
the delay; everything else comes from EDID”.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- New line is commit `354b9c43d36ce` (Weiji Wang, 2026-07-28).
- Neighbors: `0x0ae8` from `993d36ac99efe` (2024), `0x0b09` from
  `c03dd019f0b56` (2025).
- `delay_200_500_e50_p2e80` introduced in `f4ccd9fea2270` (2023-12-14),
  present long before this change.
- Driver file from `5f04e7ce392db` (2021-09-20).

**Step 3.2: Fixes: tag**
Record: None. Bug is “this panel ID was never listed”, not a regression
from a specific SHA.

**Step 3.3: File history**
Record: Many similar `drm/panel-edp: Add …` one-liners. Standalone; not
`N/M`. Parent `eb7979f6014a1` already has the delay struct and
surrounding BOE rows. `git grep 0x0af2` on the parent: not present.

**Step 3.4: Author**
Record: Only this commit by Weiji Wang in `drivers/gpu/drm/`. Douglas
Anderson is `R: DRM DRIVER FOR GENERIC EDP PANELS` and both reviewed and
applied it.

**Step 3.5: Prerequisites**
Record: Needs `EDP_PANEL_ENTRY`, `edp_panels[]`, and
`delay_200_500_e50_p2e80`. All exist in this checkout. Applies
standalone.

---

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record:
- `b4 dig -c 354b9c43d36ce` → https://patch.msgid.link/82fc6395-3425-
  4f71-ba58-813856cee61d@gmail.com
- v1: 2026-07-24, https://patch.msgid.link/697e79c2-98a9-4bb3-b5fb-
  db327cbe1bce@gmail.com
  Used unsorted `0x0af2` with `delay_200_500_e80`.
- v2: 2026-07-28 (applied). Changelog: sort fix +
  `delay_200_500_e50_p2e80`.
- Doug on v2: mailer wrapped/tabs-to-spaces; he fixed and pushed to drm-
  misc-next as `354b9c43d36ce`. `Reviewed-by` given. No NAK.
- v1 review: sort bug; asked if datasheet vs guess. Author: Panelook
  datasheet; T4+T5+T6+T8-min given. Doug recommended
  `delay_200_500_e50_p2e80`. Author confirmed T7/T8 match and verified
  on `next-20260726`.
- No reviewer `Cc: stable`.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: Weiji Wang, Doug Anderson, `dri-devel@lists.freedesktop.org`,
`linux-kernel@vger.kernel.org`. Right reviewer and list.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Hardware addition from someone with the
panel/datasheet. EDID in the message is the identification evidence.

**Step 4.4: Series**
Record: Single patch, v1→v2 only.

**Step 4.5: stable@**
Record: lore HTTP fetch returned 403. `b4` threads have no stable
discussion. Not used as a negative signal.

---

## Phase 5: Semantic analysis

**Step 5.1: Functions**
Record: No function body change. Data: `edp_panels[]`. Consumers:
`find_edp_panel()`, `generic_edp_panel_probe()`.

**Step 5.2: Callers**
Record:
- `panel_edp_probe()` if DT compatible is `"edp-panel"`
- `panel_edp_platform_probe()` / AUX-bus probe → `panel_edp_probe()`
- Context: device probe (boot / connector bring-up), not IRQ/hot path

**Step 5.3: Callees**
Record: `find_edp_panel()` walks `edp_panels`; on hit, `desc->delay =
*panel->detected_panel->delay`.

**Step 5.4: Reachability**
Record: Yes, from normal laptop/embedded eDP probe when the panel EDID
is BOE `0x0af2`. Unprivileged users do not program the ID; it is
firmware/EDID. Impact is display power-seq and a kernel warning at
probe.

**Step 5.5: Similar patterns**
Record: The table is full of the same `EDP_PANEL_ENTRY` pattern
(including other BOE NE140QDM parts, e.g. `0x0b1e` NE140QDM-N6A). This
is the standard way this driver is extended.

---

## Phase 6: Local tree (this checkout)

**Step 6.1: Does the code exist here?**
Record:
- Tree: `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`; `make
  kernelversion` = `7.3.0-rc4`
- `drivers/gpu/drm/panel/panel-edp.c` present; `CONFIG_DRM_PANEL_EDP` in
  Kconfig
- `delay_200_500_e50_p2e80` at lines 1768–1773
- `edp_panels[]` and `WARN_ON` unknown-panel path at 829–833
- Line 2060 already has this entry because `354b9c43d36ce` **is an
  ancestor of HEAD**. That is mainline history, not a reason to treat
  the change as “already selected for stable”.

**Step 6.2: Backport difficulty**
Record: Clean apply: one sorted row, delay symbol already in this tree.
No API/struct change.

**Step 6.3: Related fixes already here?**
Record: No other `NE140QDM-NX2` / `0x0af2` commit besides this one. No
alternate fix.

---

## Phase 7: Subsystem context

**Step 7.1:**
Record: DRM panel (`drivers/gpu/drm/panel/`). Criticality: **IMPORTANT**
for systems using generic eDP (`edp-panel`), typical
laptops/Chromebooks/ARM boards. Not mm/net core; not staging.

**Step 7.2:**
Record: Active table (many recent `Add` commits). Mature lookup/delay
design since ~2021–2023.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: Driver/config-specific: `CONFIG_DRM_PANEL_EDP` + DT `"edp-
panel"` + BOE product ID `0x0af2`. No effect on other panels.

**Step 8.2: Trigger**
Record: Every probe of that panel (boot / display init). Not a race. Not
a syscall exploit path.

**Step 8.3: Failure mode**
Record:
- `WARN_ON` on unknown panel (MEDIUM as a warning, but intentional
  “please add this ID” splat)
- Conservative delays: extra ~1.5 s unprepare vs 500 ms (user-visible
  resume/power-off lag)
- Panel is still expected to work; this is enablement + warning/latency,
  not panic
- Severity: **MEDIUM** as a bug; **high value** as a device-ID exception

**Step 8.4: Risk-benefit**
Record:
- Benefit: correct power-seq and no warning for this hardware; same
  class as PCI/USB ID adds
- Risk: very low (1 line, ID-matched only)
- Ratio: favorable

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- Existing driver; only a new panel ID + existing delay pointer
- Matches the documented **new device ID** / hardware-quirk exception
- Prevents `WARN_ON` + 2000 ms conservative unprepare for BOE NE140QDM-
  NX2
- 1 line, sorted, uses `delay_200_500_e50_p2e80` already in this tree
- EDID in the message matches vendor/product/name
- Reviewed and applied by the panel-edp reviewer; v2 delay choice came
  from datasheet discussion
- Author verified on `next-20260726`

AGAINST:
- Not a UAF/crash/security fix
- Unknown panel still functions with conservative timings
- No `Fixes:` / `Cc: stable` (expected for this review path)
- Commit subject is enablement (“Add …”), not “fix”

UNRESOLVED:
- lore.kernel.org via WebFetch was 403; thread recovered with `b4`
- No stable@ thread found
- Exact laptop SKUs using this panel not identified beyond the EDID

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (1-line table add; maintainer
   review; author verified)
2. Real bug affecting users? **PASS** (missing ID → warning + wrong
   delays on real hardware)
3. Important (crash/security/corruption/deadlock)? **PASS via
   exception** (device ID / panel quirk; warning + bad power-seq). Not
   CRITICAL memory safety.
4. Small and contained? **PASS** (+1 line, one file)
5. No new features/APIs? **PASS** (no new driver, syscall, or userspace
   ABI; ID in existing table)
6. Can apply to this tree? **PASS** (driver, macro, delay struct, and
   sort neighbors all present)

**Step 9.3: Exception**
Record: **New device ID / hardware quirk** on an existing driver
(`EDP_PANEL_ENTRY` is this driver’s ID table).

**Step 9.4: Decision**
This is the eDP equivalent of adding a PCI/USB ID: a one-line table
entry so existing `panel-edp` uses datasheet power sequencing instead of
the unknown-panel `WARN_ON` + conservative delays. This tree has every
prerequisite. Benefit is real for owners of this panel; risk is
negligible.

### What the commit solves for this tree
On `v7.3-rc4`, generic `"edp-panel"` devices read EDID and look up
`edp_panels[]`. BOE `0x0af2` (NE140QDM-NX2) had no row, so probe warned
and used 2000/200 ms conservative delays. The patch adds that row with
`delay_200_500_e50_p2e80`. Display modes remain EDID-driven.

### Risk vs benefit
Very low risk, contained to one product ID. Benefit is working/faster
power sequencing and no warning for that panel—standard stable device-ID
material.

---

Verification:
- [Phase 1] Parsed subject/tags/body from `git show 354b9c43d36ce`; EDID
  `09 e5 f2 0a` + `NE140QDM-NX2` checked against the new `BOE, 0x0af2`
  row
- [Phase 2] Diff is +1 line in `edp_panels[]`;
  `generic_edp_panel_probe()` / `WARN_ON` /
  `panel_edp_set_conservative_timings()` read in `panel-edp.c`
- [Phase 3] `git blame -L 2058,2062`; `git log -L
  :delay_200_500_e50_p2e80:…` → `f4ccd9fea2270`; parent has no `0x0af2`;
  `git merge-base --is-ancestor 354b9c43d36ce HEAD` → yes
- [Phase 3] No `Fixes:`; author log only this DRM commit
- [Phase 4] `b4 dig -c 354b9c43d36ce` / `-a` / `-w` / `-m`; v1 mbox (7
  messages) with Doug’s sort + delay review; v2 applied despite wrap
- [Phase 4] WebFetch lore → 403; discussion taken from b4 mboxes instead
- [Phase 5] Call path: `"edp-panel"` → `panel_edp_probe()` →
  `generic_edp_panel_probe()` → `find_edp_panel()`
- [Phase 6] `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`;
  `VERSION=7 PATCHLEVEL=3 SUBLEVEL=0 EXTRAVERSION=-rc4`; delay struct
  and table present
- [Phase 7] MAINTAINERS: `R: Douglas Anderson` for `panel-edp.c`;
  Kconfig `DRM_PANEL_EDP`
- [Phase 8] Failure mode verified: unknown panel → WARN_ON + unprepare
  2000 / enable 200
- UNVERIFIED: stable@ archive (lore HTTP 403); specific machine models
  shipping this panel

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 614c63e95c357..65e2f68b919ef 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1989,6 +1989,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0a6a, &delay_200_500_e80, "NV140WUM-N44"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ac5, &delay_200_500_e50, "NV116WHM-N4C"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ae8, &delay_200_500_e50_p2e80, "NV140WUM-N41"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0af2, &delay_200_500_e50_p2e80, "NE140QDM-NX2"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b09, &delay_200_500_e50_po2e200, "NV140FHM-NZ"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b1e, &delay_200_500_e80, "NE140QDM-N6A"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0b34, &delay_200_500_e80_d50, "NV122WUM-N41"),
-- 
2.53.0

