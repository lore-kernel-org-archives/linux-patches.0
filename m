Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C2F5625F1;
	Mon, 31 Aug 2026 13:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184071; cv=none; b=dd0uKFfXS3wzhZgKVX4ybSx9iRdeFfx5OOGPHdbz6WK6j82NN08NSmfAT2B4dgsGffYewd1lwV6kcGeARAp6bSYJlOEcfEIWva7RTQmPK5ym/cqLsfpDJ/aJ/OVS71OFiviVV5asn3nT8M7YyWbl4WaaRCadWQPsV/K27joSRhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184071; c=relaxed/simple;
	bh=d/+qTE+S1G8figkIt1tPb02WEiXy8XXxiaFt/6cQP0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q6PzhPup16wByQ+RDGYEcU9RVzf0HMXwvpUU9Yz1wy9sVyyvkOPEXIoePc6d9DoXNw+dQ0X2L01crKTkTD9tIac2p7NSW4bJAQkHH0nFnbS+uMmskMmJ69GQvZmUrFKIGh3v5Blz3/IoFv9QYGKOluL/x+6hKoJsytEwQw8/5+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OPZj4yKZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OPZj4yKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182AA1F01558;
	Mon, 31 Aug 2026 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184068;
	bh=oOn+Hi3zVKHz6uhWiJTCswABnSbvQCFUZOJ78CHASiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OPZj4yKZy7Wpg8Kp3C+soVtbKzgVQSrdqLSOGOxTOXKJP3oClKmOSXoy9/ClbRuMj
	 6/xfB5zOvwgJJW6Uh4rK1CLEjxMLGk3lzaU10e02y1Dwo43lZzVxJ06/ZfyMWr56mE
	 NxYVwaBZJW9O59Ch+3J4xsg3mkQXiblgmH4WoQ/YEwnMb1dYEsN+N3WqKx9Hb2RNcX
	 03FsTAoSAFNyAtt6KsobaPUOvXEvjNibas+ZC1UjXtSt0XxgWSC6Cy3+urz67pAb0a
	 hvIMMh3V5O9EEqisf14hvy88/uGssYT7Giq19zuql4afav9Yrw6Q9ipTZ4/YSciJJV
	 qwCDPEm2zVn+A==
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
Subject: [PATCH AUTOSEL 6.18] drm/panel-edp: Add AUO B140XTN07.5, AUO B140HAK03.5, AUO B116XTN02.3, AUO B140XTK02.4, AUO B140HAN07.7
Date: Mon, 31 Aug 2026 09:28:20 -0400
Message-ID: <20260831133314.4125787-472-sashal@kernel.org>
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

[ Upstream commit 4c34cdb93ea187b46d287a77a8946268a7d24286 ]

The raw EDIDs for each panel:

AUO B140XTN07.5
00 ff ff ff ff ff ff 00 06 af 90 02 00 00 00 00
00 1e 01 04 95 1f 11 78 03 c0 d5 8f 56 58 93 29
20 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 e2 50 00 1e 30 26 16
36 00 35 ad 10 00 00 18 df 13 56 e2 50 00 1e 30
26 16 36 00 35 ad 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 48 0f 1b 7d 20 20 20 00 09

AUO B140HAK03.5
00 ff ff ff ff ff ff 00 06 af 9f 3c 00 00 00 00
00 1f 01 04 95 1f 11 78 03 f5 65 8f 55 5a 93 2a
1f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 b0 36 80 a0 70 38 24 40 10 10
3e 00 35 ae 10 00 00 18 75 24 80 a0 70 38 24 40
10 10 3e 00 35 ae 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 14 0e 1e 7d 20 20 20 01 02

70 20 79 02 00 22 00 14 df 22 02 84 7f 07 9f 00
0f 80 0f 00 37 04 23 00 02 00 0d 00 25 00 09 df
22 02 df 22 02 28 3c 80 81 00 10 72 1a 00 00 03
01 28 3c 00 00 60 50 60 50 3c 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 3f 90

AUO B116XTN02.3
00 ff ff ff ff ff ff 00 06 af ba 49 00 00 00 00
00 23 01 04 95 1a 0e 78 02 6b f5 91 55 54 91 27
22 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 e2 50 00 1e 30 26 16
36 00 00 90 10 00 00 18 df 13 56 e2 50 00 1e 30
26 16 36 00 00 90 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 50 05 18 7d 20 20 20 00 7f

AUO B140XTK02.4
00 ff ff ff ff ff ff 00 06 af a8 67 00 00 00 00
28 20 01 04 95 1f 11 78 03 c0 d5 8f 56 58 93 29
20 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 e2 50 00 1e 30 26 16
36 00 35 ad 10 00 00 18 df 13 56 e2 50 00 1e 30
26 16 36 00 35 ad 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 11 23 21 6e 20 20 20 00 8e

AUO B140HAN07.7
00 ff ff ff ff ff ff 00 06 af ad c7 00 00 00 00
21 21 01 04 a5 1f 11 78 03 fa 95 92 56 5a 92 2a
20 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 56 37 80 bc 70 38 28 40 10 10
3e 00 35 ae 10 00 00 18 e4 24 80 bc 70 38 28 40
10 10 3e 00 35 ae 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 3c ff 0f 3c 96 23 10 28 96 20 20 20 01 66

70 20 79 02 00 22 00 14 5b 29 02 84 7f 07 bb 00
0f 80 0f 00 37 04 27 00 02 00 0d 00 25 01 09 5b
29 02 5b 29 02 28 3c 80 81 00 10 6f 1a 00 00 03
01 28 3c 00 00 8b 11 8b 11 3c 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 c0 90

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260506170607.10813-2-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/panel-edp AUO Panel Entries

**Local tree:** `v6.18.43` (Linux 6.18.43)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[drm/panel-edp]` `[Add]` — Add five AUO eDP panel IDs
(B140XTN07.5, B140HAK03.5, B116XTN02.3, B140XTK02.4, B140HAN07.7) to the
panel lookup table.

### Step 1.2: Commit Tags
**Record:**
- **Signed-off-by:** Terry Hsiao `<terry_hsiao@compal.corp-
  partner.google.com>` (author)
- **Reviewed-by:** Douglas Anderson `<dianders@chromium.org>`
  (Chromium/DRM maintainer)
- **Signed-off-by:** Douglas Anderson `<dianders@chromium.org>`
- **Link:** https://patch.msgid.link/20260506170607.10813-2-
  terry_hsiao@compal.corp-partner.google.com
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  or syzbot tags
- Notable: Reviewed by Chromium DRM maintainer; author is a
  Compal/Google partner engineer (Chromebook hardware context)

### Step 1.3: Body Analysis
**Record:**
- **Bug description:** Not explicitly stated. The commit documents raw
  EDID dumps for five AUO panels and adds them to `edp_panels[]`.
- **Symptom/failure mode:** Implicit — without table entries,
  `generic_edp_panel_probe()` cannot match these panel IDs and falls
  back to conservative power-sequencing delays with a `WARN_ON`.
- **Version info:** None in the message.
- **Root cause:** These AUO panel EDID product IDs are absent from the
  `edp_panels[]` lookup table, so the driver cannot apply the correct
  `delay_200_500_e50` power-sequencing profile.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — disguised as "Add" but functionally a **hardware quirk
fix**. The `panel-edp` driver maps EDID panel IDs to power-sequencing
delays (`hpd_absent`, `unprepare`, `enable`). Missing entries cause
wrong delays and a `WARN_ON` at probe. This is the same class of fix as
other panel-edp entries already backported to this tree.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
**Record:**
- **Files:** `drivers/gpu/drm/panel/panel-edp.c` only (+5 lines)
- **Functions modified:** None — only the `edp_panels[]` static table
- **Scope:** Single-file, surgical table additions

| Panel ID | Product ID | Delay Profile |
|----------|-----------|---------------|
| B140XTN07.5 | 0x0290 | delay_200_500_e50 |
| B140HAK03.5 | 0x3c9f | delay_200_500_e50 |
| B116XTN02.3 | 0x49ba | delay_200_500_e50 |
| B140XTK02.4 | 0x67a8 | delay_200_500_e50 |
| B140HAN07.7 | 0xc7ad | delay_200_500_e50 |

### Step 2.2: Code Flow Change
**Record:**
- **Before:** `find_edp_panel()` returns NULL for these five EDID
  product IDs → `WARN_ON` + conservative timings (`unprepare=2000`,
  `enable=200`).
- **After:** `find_edp_panel()` matches the panel → correct
  `delay_200_500_e50` applied (`hpd_absent=200`, `unprepare=500`,
  `enable=50`).
- **Path affected:** `generic_edp_panel_probe()` during device probe
  (boot and resume).

### Step 2.3: Bug Mechanism
**Record:** **Category (h): Hardware workaround / panel quirk.** Missing
EDID-to-delay mapping causes incorrect power-sequencing timings during
panel prepare/enable/unprepare. The driver explicitly documents that
unknown panels get suboptimal conservative delays and a `WARN_ON` to
flag the gap.

### Step 2.4: Fix Quality
**Record:**
- **Quality:** Obviously correct — same `delay_200_500_e50` used for all
  other AUO panels in the table; entries inserted in sorted
  vendor/product-ID order.
- **Regression risk:** Very low — five new table rows, no logic changes.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** The `edp_panels[]` table was introduced in `5d324e5159d9e`
(Linux 6.18-rc8 merge, Nov 2025). The five product IDs from this commit
are **not present** in the current tree. Similar AUO entries (e.g.,
B140QAX01.H at `0bd968c04acfb`, B140HAN06.4 at `6ca4647a74155`) were
added via stable backports.

### Step 3.2: Fixes: Tag
**Record:** Not applicable — no Fixes: tag.

### Step 3.3: Related Commits
**Record:**
- Part of v1 4-patch series by Terry Hsiao (cover letter in local mbox:
  `20260507_terry_hsiao_...mbx`)
- This patch (1/4) is **standalone** — only adds AUO entries; no
  dependency on patches 2–4
- Precedent in this tree: `0bd968c04acfb` (AUO B140QAX01.H),
  `6ca4647a74155` (AUO B140HAN06.4), `b173ba3365ff0` (BOE panel)

### Step 3.4: Author Context
**Record:** Terry Hsiao has no prior commits in this tree's
`drivers/gpu/drm/panel/` history. Douglas Anderson (reviewer) is the
Chromium/DRM maintainer who has reviewed and signed off on prior panel-
edp stable backports in this tree.

### Step 3.5: Dependencies
**Record:** No dependencies. The `panel-edp` driver, `EDP_PANEL_ENTRY`
macro, `delay_200_500_e50`, and `edp_panels[]` table all exist in
v6.18.43. Patch applies cleanly at five sorted insertion points.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- Lore URL blocked by bot protection (WebFetch failed)
- Local mbox `20260507_terry_hsiao_drm_panel_edp_add_and_update_multiple
  _auo_boe_cmn_and_ivo_panels.mbx` confirms v1 submission, patch 1/4
- Cover letter: "add support for new panels from AUO, BOE, CMN, and IVO
  to the panel-edp driver"
- No stable nomination or NAK found in available local mbox content

### Step 4.2: Reviewers
**Record:** Reviewed-by and Signed-off-by Douglas Anderson (Chromium DRM
maintainer). Author domain (`compal.corp-partner.google.com`) indicates
Chromebook OEM context.

### Step 4.3: Bug Reports
**Record:** No external bug reports, syzbot links, or user crash
reports. Impact inferred from driver behavior when panel IDs are
missing.

### Step 4.4: Series Context
**Record:** 4-patch series; this commit is patch 1/4 and is self-
contained. Other patches add BOE/CMN/IVO entries and fix a CMN panel
name — not required for this fix.

### Step 4.5: Stable List History
**Record:** Not searched (lore blocked). Precedent established locally
by prior panel-edp backports in this 6.18.y tree.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** No functions modified. Affected data: `edp_panels[]` table,
consumed by `find_edp_panel()`.

### Step 5.2: Callers
**Record:** `find_edp_panel()` called from `generic_edp_panel_probe()`
(line 805), which is called from `panel_edp_probe()` during platform
device probe — standard display initialization at boot and resume.

### Step 5.3: Callees
**Record:** `find_edp_panel()` iterates `edp_panels[]`, matching via
`drm_edid_match()` then `panel_id`. Matched entry's `delay` pointer is
copied into `desc->delay`.

### Step 5.4: Reachability
**Record:** Triggered on any system using the generic `panel-edp` driver
with one of these five AUO panels. Common on Chromebooks and laptops.
Not userspace-triggerable directly, but affects every boot/resume on
affected hardware.

### Step 5.5: Similar Patterns
**Record:** Multiple AUO entries already exist (e.g., 0x235c and 0x73aa
both named "B116XTN02.3" — AUO reuses product IDs). Adding 0x49ba as
another "B116XTN02.3" entry follows the established pattern for handling
AUO ID reuse.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (v6.18.43)

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** The `panel-edp` driver and `edp_panels[]` table
exist (since 6.18-rc8). The five product IDs (0x0290, 0x3c9f, 0x49ba,
0x67a8, 0xc7ad) are **absent** — confirmed by grep. Panels with these
IDs currently hit the unknown-panel fallback path.

### Step 6.2: Backport Complications
**Record:** **Clean apply expected.** All five insertion anchor points
verified in the local table:
- 0x0290 before 0x04a4
- 0x3c9f after 0x30ed, before 0x403d
- 0x49ba after 0x435c, before 0x52b0
- 0x67a8 after 0x643d, before 0x723c
- 0xc7ad after 0xc4b4, before 0xc9a8

### Step 6.3: Related Fixes Already Present?
**Record:** No fix for these five panel IDs. Related AUO panel entries
(B140QAX01.H, B140HAN06.4) were already backported separately.

---

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **drivers/gpu/drm/panel** — IMPORTANT (display subsystem).
Affects users of specific eDP panel hardware on ARM/Chromebook platforms
using the generic panel-edp driver.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained — three panel-edp commits in this 6.18.y
tree since the driver landed.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of laptops/Chromebooks with these five AUO eDP panels
using the `panel-edp` generic driver. Platform-specific, not universal.

### Step 8.2: Trigger Conditions
**Record:** Every boot and display resume on affected hardware. Common
operational path, not a rare edge case. Not a security vector.

### Step 8.3: Failure Mode Severity
**Record:**
- **Without fix:** `WARN_ON` at probe; conservative delays
  (`unprepare=2000ms`, `enable=200ms`) instead of correct
  (`unprepare=500ms`, `enable=50ms`). Driver comment says conservative
  timings "highly likely" to work, but wrong power sequencing can cause
  blank display, flicker, or suspend/resume failures on some panels.
- **Severity:** MEDIUM — hardware enablement / display reliability, not
  kernel crash or data corruption.

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** MEDIUM — enables correct power sequencing on shipping
  Chromebook/laptop hardware; eliminates WARN_ON spam.
- **Risk:** VERY LOW — five table rows, no logic changes, same delay
  profile as dozens of existing AUO entries.
- **Ratio:** Favorable — minimal risk, real hardware benefit,
  established backport pattern in this tree.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Hardware quirk / panel ID addition to existing driver (explicit stable
  exception)
- Same pattern as `0bd968c04acfb` and `6ca4647a74155` already backported
  to this 6.18.y tree
- Five-line, obviously correct change reviewed by Chromium DRM
  maintainer
- Driver and infrastructure fully present in v6.18.43
- Wrong power sequencing can cause display failures on affected hardware
- Clean apply with no dependencies

**AGAINST backporting:**
- No explicit bug report or crash description in commit message
- Conservative fallback exists (display may work without the fix)
- Not a security, corruption, or crash fix — display reliability only
- Affects specific hardware, not all users

**Unresolved:** Lore thread content unavailable (bot protection). No
independent user bug reports found.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — same delay as other AUO
   panels; Reviewed-by maintainer
2. Fixes a real bug affecting users? **PASS** — missing panel ID causes
   wrong power-sequencing delays
3. Important issue? **PASS (MEDIUM)** — display reliability on shipping
   hardware; hardware quirk category
4. Small and contained? **PASS** — 5 lines, one file
5. No new features or APIs? **PASS** — panel ID entries to existing
   driver (allowed exception)
6. Can apply to local tree? **PASS** — driver present, clean apply at
   verified anchor points

### Step 9.3: Exception Category
**Record:** **Hardware quirk/workaround** — panel-specific power-
sequencing delay mapping, analogous to USB/PCI quirk table entries. Same
category as prior panel-edp backports in this tree.

### Step 9.4: Decision Rationale

This commit adds five AUO eDP panel entries to the existing `panel-edp`
driver's lookup table so the correct power-sequencing delays are applied
at probe. Without these entries, affected panels on Chromebooks and
laptops fall back to conservative timings with a `WARN_ON`, which can
cause display initialization or suspend/resume issues.

The change is trivial (5 lines), obviously correct (reuses the standard
AUO `delay_200_500_e50` profile), reviewed by the Chromium DRM
maintainer, and follows the exact pattern of panel-edp entries already
backported to this 6.18.y tree. It falls squarely in the hardware quirk
exception category for stable kernels.

---

## Verification

- **[Phase 1]** Parsed commit message and tags from user query and local
  mbox
- **[Phase 1]** Confirmed Reviewed-by: Douglas Anderson; no
  Fixes:/Reported-by:/syzbot tags
- **[Phase 2]** Diff analysis: 5 `EDP_PANEL_ENTRY` lines added to
  `edp_panels[]` in `panel-edp.c`
- **[Phase 2]** Read `delay_200_500_e50` definition: hpd_absent=200,
  unprepare=500, enable=50
- **[Phase 2]** Read `panel_edp_set_conservative_timings()`:
  unprepare=2000, enable=200
- **[Phase 2]** Read `generic_edp_panel_probe()` lines 805–825: unknown
  panel → WARN_ON + conservative fallback
- **[Phase 3]** `git describe HEAD`: v6.18.43-1-gc7f0dac02d232 (Linux
  6.18.43)
- **[Phase 3]** `git blame` on edp_panels[]: table from 5d324e5159d9e
  (6.18-rc8); no entries for the five new IDs
- **[Phase 3]** `git log --grep`: found prior panel-edp backports
  0bd968c04acfb, 6ca4647a74155, b173ba3365ff0
- **[Phase 3]** Grep for 0x0290/0x3c9f/0x49ba/0x67a8/0xc7ad: no matches
  — IDs absent from tree
- **[Phase 4]** Read local mbox `20260507_terry_hsiao_...mbx`: confirmed
  v1 patch 1/4, cover letter context
- **[Phase 4]** WebFetch lore URL: blocked by bot protection — thread
  content unavailable
- **[Phase 5]** Traced call chain: `panel_edp_probe` →
  `generic_edp_panel_probe` → `find_edp_panel`
- **[Phase 6]** Verified all five insertion anchor points exist in local
  `edp_panels[]` table (lines 1887–1924)
- **[Phase 6]** Confirmed `panel-edp.c` driver exists in v6.18.43 with
  full table infrastructure
- **[Phase 8]** Assessed failure mode: wrong power sequencing, MEDIUM
  severity, no crash/corruption

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index be827729c4fb7..c1ea17a0040be 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1885,6 +1885,7 @@ static const struct panel_delay delay_80_500_e50_d50 = {
  * Sort first by vendor, then by product ID.
  */
 static const struct edp_panel_entry edp_panels[] = {
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x0290, &delay_200_500_e50, "B140XTN07.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x04a4, &delay_200_500_e50, "B122UAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x0ba4, &delay_200_500_e50, "B140QAX01.H"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x105c, &delay_200_500_e50, "B116XTN01.0"),
@@ -1900,17 +1901,20 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x239b, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x255c, &delay_200_500_e50, "B116XTN02.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x30ed, &delay_200_500_e50, "G156HAN03.0"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x3c9f, &delay_200_500_e50, "B140HAK03.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x403d, &delay_200_500_e50, "B140HAN04.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAN04.0"),
 	EDP_PANEL_ENTRY2('A', 'U', 'O', 0x405c, &auo_b116xak01.delay, "B116XAK01.0",
 			 &auo_b116xa3_mode),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x435c, &delay_200_500_e50, "Unknown"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x49ba, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x52b0, &delay_200_500_e50, "B116XAK02.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x582d, &delay_200_500_e50, "B133UAN01.0"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x615c, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x635c, &delay_200_500_e50, "B116XAN06.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x639c, &delay_200_500_e50, "B140HAK02.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x643d, &delay_200_500_e50, "B140HAN06.4"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x67a8, &delay_200_500_e50, "B140XTK02.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x723c, &delay_200_500_e50, "B140XTN07.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x73aa, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
@@ -1918,6 +1922,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xa199, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xa7b3, &delay_200_500_e50, "B140UAN04.4"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc4b4, &delay_200_500_e50, "B116XAT04.1"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc7ad, &delay_200_500_e50, "B140HAN07.7"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xc9a8, &delay_200_500_e50, "B140QAN08.H"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xcdba, &delay_200_500_e50, "B140UAX01.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xd497, &delay_200_500_e50, "B120XAN01.0"),
-- 
2.53.0

