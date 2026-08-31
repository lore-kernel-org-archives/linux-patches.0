Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F414949F6;
	Mon, 31 Aug 2026 13:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183521; cv=none; b=BQ0rSxll/z1QPFDcBVCtXPBqNnoA/bGtq10qkqDVZaOA55i8FyEeMrRquCTsF90cEySTudxMuB+sHMJZvvqeo1l1in95MUudkJfWN7c4dX+tPUYfnm/1sNjm+4og8LJl68YF3WzXDnaWwz4x52X9NeG6ad0qZqjDCB5mthCiIaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183521; c=relaxed/simple;
	bh=t74y8aa8QALT2W0gIPlQC5NFgC0c+HZvEOge4iu8Sks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rlrvmee/1Qm32p5j4zdRX3B7H0EER7bpdVYjo4CEoTTP93kNC2GWLXfFotlQRmmdghGxc29A7EMcMmQ8xiKmKQVPxtXbuoPMrgqx9uG+gtY8VVGp24eVgMZ6uIU5X/V7CrIMwnkFVPZa7BWzby36A6UzbbvrQv7bP0TTJ+q1Uew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ghe0hboe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ghe0hboe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131F31F00ACF;
	Mon, 31 Aug 2026 13:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183518;
	bh=zfzcXDm9TmxpRXccnfiV7B/t46lKO3BgYscXgmPgskc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghe0hboehe+ZHPCTZsIniB1NGortNfTP5jSpooxCtril4sBeZFkU8re7z3K1SeNUX
	 yjo8NP1pw/asOKe3YY0yMq4jufgTGrHGZPdX2BIcaSw5+BK/5WiSX2KUwdtg4NHmf5
	 KvpDhkq+fihA78/woEDk9Kih7V56MDw1VZFMzynuS85FSs6Hw8HKcE93aWBBH1Rf/s
	 2nhh4mHYmbImdBqlbA8WkR/xtVj2tE+VC91t9uzgVN0riwvH/J0Yyu5Y6YsMxJQKsC
	 DH/4H4qVJsGCVib2482l13y3Tzd02TA8wdYCL1D6UBUvElHr2FC4V7ACumHC08QV/Q
	 Pm8l+gxCoxZNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Michael Trimarchi <michael@amarulasolutions.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	maarten.lankhorst@linux.intel.com,
	mripard@kernel.org,
	tzimmermann@suse.de,
	airlied@gmail.com,
	simona@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] drm/panel: simple: Add AM-1280800W8TZQW-T00H
Date: Mon, 31 Aug 2026 09:22:52 -0400
Message-ID: <20260831133314.4125787-144-sashal@kernel.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 6acb810ebc5d8dea5c250326c14dc44e32dc8e92 ]

Add Ampire, AM-1280800W8TZQW-T00H 10.1" TFT LCD panel timings.

Co-developed-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260515082232.1766586-2-dario.binacchi@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: drm/panel: simple: Add AM-1280800W8TZQW-T00H

**Local tree:** Linux **6.18.44** (`v6.18.44`, `stable/linux-6.18.y`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[drm/panel: simple]` `[Add]` — Add Ampire
AM-1280800W8TZQW-T00H 10.1" TFT LCD panel timings to the existing
`panel-simple` driver.

### Step 1.2: Tags
**Record:**
- **Co-developed-by:** Michael Trimarchi
  \<michael@amarulasolutions.com\>
- **Signed-off-by:** Michael Trimarchi, Dario Binacchi
- **Reviewed-by:** Dmitry Baryshkov
  \<dmitry.baryshkov@oss.qualcomm.com\> (DRM/panel reviewer)
- **Signed-off-by:** Neil Armstrong \<neil.armstrong@linaro.org\>
  (maintainer ack)
- **Link:** https://patch.msgid.link/20260515082232.1766586-2-
  dario.binacchi@amarulasolutions.com
- **No** Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org,
  or syzbot tags
- **Notable:** Part of a 2-patch v2 series (patch 2/2); patch 1/2 adds
  the DT binding

### Step 1.3: Body analysis
**Record:**
- **Bug description:** None — this is hardware enablement, not a bug
  fix.
- **Symptom without patch:** A device tree node with `compatible =
  "ampire,am-1280800w8tzqw-t00h"` will not match `panel-simple`, so the
  display will not probe and no framebuffer will come up.
- **Root cause:** Missing `panel_desc` / `drm_display_mode` entry and
  missing OF compatible in `platform_of_match[]`.
- **Version info:** None in the message.

### Step 1.4: Hidden bug fix?
**Record:** No. This is a straightforward device-ID / panel-timing
addition. It does not fix leaks, races, crashes, or corruption in
existing code paths.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File changed:** `drivers/gpu/drm/panel/panel-simple.c` only (+28
  lines)
- **Functions modified:** None (only static data and one
  `platform_of_match[]` entry)
- **Scope:** Single-file, surgical data addition

### Step 2.2: Code flow change
**Record:**
- **Hunk 1 (after `ampire_am_1280800n3tzqw_t00h`):** Adds
  `ampire_am_1280800w8tzqw_t00h_mode` (1280×800, 72.4 MHz pixel clock,
  different vsync from the N3 sibling) and
  `ampire_am_1280800w8tzqw_t00h` descriptor (8 bpc, LVDS, RGB888 SPWG).
  - Before: only the N3 variant is known.
  - After: W8 variant is also known.
- **Hunk 2 (`platform_of_match[]`):** Adds `{ .compatible =
  "ampire,am-1280800w8tzqw-t00h", .data = &ampire_am_1280800w8tzqw_t00h
  }`.
  - Before: probe fails for W8 compatible strings.
  - After: probe succeeds and uses W8-specific timings.

### Step 2.3: Bug mechanism
**Record:** **Category h) — hardware workarounds / device enablement.**
Not a software bug fix; adds OF compatible + timings for a new panel
variant on an existing driver.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High — mirrors the existing `am-1280800n3tzqw-t00h`
  pattern exactly.
- **Regression risk:** Very low — purely additive static data; no logic
  or locking changes.
- **Minor note:** W8 mode struct omits `.flags = DRM_MODE_FLAG_PHSYNC |
  DRM_MODE_FLAG_PVSYNC` present on the N3 sibling; this matches the
  submitted upstream patch and was reviewed as-is.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** On `origin/master`, the W8 panel code is present at lines
823–846 and in `platform_of_match`. In the local 6.18.44 tree, the
insertion point after `ampire_am_1280800n3tzqw_t00h` (lines 797–821) and
the matching `platform_of_match` entry (line 4966) already exist. The W8
entry is absent — this is new mainline content not yet in 6.18.y.

### Step 3.2: Fixes: tag
**Record:** Not applicable — no Fixes: tag.

### Step 3.3: Related file history
**Record:**
- Sibling panel `am-1280800n3tzqw-t00h` is already in this tree and used
  by in-tree DTS files (`imx6q-icore-ofcap10.dts`, `px30-engicam-
  px30-core-ctouch2-of10.dts`, `stm32mp157a-icore-
  stm32mp1-ctouch2-of10.dts`).
- On `stable/linux-6.6.y`, the nearly identical sibling addition was
  backported: `bca684e69c4ce` (+29 lines, same vendor/subject pattern).
- `w8tzqw` appears only in `panel-simple.c` and `panel-simple.yaml` on
  mainline — no in-tree DTS references anywhere.

### Step 3.4: Author context
**Record:** Amarula Solutions (same vendor ecosystem as Engicam boards
using the N3 panel). Dmitry Baryshkov reviewed; Neil Armstrong signed
off. Same maintainer chain as prior Ampire panel additions.

### Step 3.5: Dependencies
**Record:** Part of a 2-patch series:
1. `dt-bindings: display: simple: Add AM-1280800W8TZQW-T00H` (Acked-by:
   Conor Dooley)
2. `drm/panel: simple: Add AM-1280800W8TZQW-T00H` (this commit)

This driver patch is self-contained and applies cleanly to 6.18.44. The
binding patch is a companion but not a compile-time prerequisite for the
driver itself.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **b4 am** on msgid
  `20260515082232.1766586-2-dario.binacchi@amarulasolutions.com` found
  the v2 series (2 patches).
- **Link:** https://patch.msgid.link/20260515082232.1766586-1-
  dario.binacchi@amarulasolutions.com
- **b4 dig -c** on merge commit `0fd8b67e27ff7` failed (merge commit,
  not the original patch).
- **No Cc: stable** nominations found in the mbox thread.
- **No NAKs** found in the retrieved mbox.

### Step 4.2: Reviewers
**Record:** Dmitry Baryshkov (Reviewed-by), Conor Dooley (Acked-by on
bindings), Neil Armstrong (Signed-off-by). Appropriate DRM/DT reviewers
involved.

### Step 4.3: Bug report
**Record:** Not applicable — no bug report, syzbot link, or user crash
report.

### Step 4.4: Series context
**Record:** 2-patch v2 series. v2 changes were alphabetical ordering and
correcting WQVGA → WXGA in the binding comment. No board DTS included in
the series.

### Step 4.5: Stable list history
**Record:** No stable-list discussion found for this specific panel.
Sibling `AM-1280800N3TZQW-T00H` was previously backported to 6.6.y.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** No functions modified. Data consumed by
`panel_simple_get_desc()` → `of_device_get_match_data()` via
`platform_of_match[]`.

### Step 5.2: Callers
**Record:** `panel_simple_platform_probe()` and DSI probe paths call
`panel_simple_probe()`, which calls `panel_simple_get_desc()`. Any
platform device with `compatible = "ampire,am-1280800w8tzqw-t00h"` would
use the new descriptor. Triggered at boot during DRM/display
initialization on affected embedded boards.

### Step 5.3: Callees
**Record:** Standard panel-simple probe path: mode/timing setup,
connector registration. No new allocation or locking paths introduced.

### Step 5.4: Reachability
**Record:** Reachable on any system with a DT node using this compatible
and `CONFIG_DRM_PANEL_SIMPLE`. Not userspace-triggered, but affects
display bring-up on boot for matching hardware.

### Step 5.5: Similar patterns
**Record:** Identical pattern to `ampire_am_1280800n3tzqw_t00h` already
in this tree (29-line sibling addition backported to 6.6.y as
`bca684e69c4ce`).

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Does the “buggy” code exist?
**Record:** The `panel-simple` driver and the sibling N3 Ampire panel
entry exist in 6.18.44. The W8 compatible is **missing** — boards using
it cannot get display support. The gap was introduced when W8 support
landed in mainline after the 6.18 branch point.

### Step 6.2: Backport complications
**Record:** **Clean apply expected.** Insertion point (`after
ampire_am_1280800n3tzqw_t00h` and in `platform_of_match[]`) is present
and unchanged. `git diff HEAD origin/master` shows exactly this 28-line
addition among broader mainline drift.

### Step 6.3: Related fixes already present?
**Record:** No equivalent W8 entry in this tree. Sibling N3 panel is
present. No duplicate fix found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** **drivers/gpu/drm/panel** — IMPORTANT for embedded/display
platforms; not universal core kernel, but critical for affected
hardware.

### Step 7.2: Subsystem activity
**Record:** `panel-simple.c` is mature with extensive static panel
tables. This follows established conventions.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** **Platform-specific** — embedded boards (Engicam/Amarula
ecosystem) using the Ampire AM-1280800W8TZQW-T00H 10.1" LVDS panel.
Requires `CONFIG_DRM_PANEL_SIMPLE`.

### Step 8.2: Trigger conditions
**Record:** Boot on hardware with DT `compatible =
"ampire,am-1280800w8tzqw-t00h"`. **No in-tree DTS currently uses this
compatible** on mainline or 6.18.44. Impact is for downstream/custom DTS
or future board additions.

### Step 8.3: Failure mode severity
**Record:** Without the patch: panel probe failure → **no display**
(MEDIUM functional impact for affected hardware; not a crash,
corruption, or security issue).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** Enables display on W8-variant Ampire panels; follows
  established stable exception for device-ID additions; direct precedent
  from sibling N3 backport to 6.6.y.
- **Risk:** Very low — 28 lines of static data, no behavioral change for
  existing panels.
- **Ratio:** Favorable for stable, under the explicit “add a device ID”
  exception in `stable-kernel-rules.rst`.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Explicitly permitted by `Documentation/process/stable-kernel-
  rules.rst`: *“It must either fix a real bug that bothers people or
  just add a device ID.”*
- Falls under the device-ID / DT-binding exception category in the
  evaluation guidelines.
- Small (28 lines), contained, obviously correct, reviewed.
- `panel-simple` driver and sibling N3 panel already exist in 6.18.44.
- Applies cleanly to this tree.
- Already in mainline (prerequisite met).
- Identical precedent: `bca684e69c4ce` backported the N3 sibling to
  6.6.y (+29 lines).

**AGAINST backport:**
- Not a bug fix — pure hardware enablement.
- No in-tree DTS uses this compatible yet (no demonstrated user impact
  in 6.18.44 today).
- Ideally paired with patch 1/2 (DT binding yaml update).
- No stable nomination or user bug report.

**Unresolved:** Whether a specific shipping board on 6.18.y already uses
this panel in downstream trees (not verifiable from this tree).

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — reviewed by Dmitry
   Baryshkov; mirrors existing N3 entry.
2. Fixes a real bug affecting users? **PASS (via device-ID exception)**
   — not a software bug, but enables hardware that otherwise cannot
   work.
3. Important issue? **PASS (moderate)** — display failure on affected
   hardware; not crash/security.
4. Small and contained? **PASS** — 28 lines, one file.
5. No new features or APIs? **PASS** — new OF compatible on existing
   driver; standard stable device-ID pattern.
6. Can apply to local tree? **PASS** — clean apply to existing `panel-
   simple.c`.

### Step 9.3: Exception category
**Record:** **NEW DEVICE ID / DT binding addition** to an existing
driver (`panel-simple`). Same category as PCI/USB ID additions and prior
Ampire panel additions backported to stable.

### Step 9.4: Decision rationale

This commit does not fix a kernel bug, but it adds a device identifier
(OF compatible + panel timings) to an existing, in-tree driver. That is
explicitly allowed for stable trees per `stable-kernel-rules.rst` and
matches the established pattern of backporting Ampire `panel-simple`
additions (the N3 sibling was backported to 6.6.y in an essentially
identical 29-line patch). The change is low-risk, applies cleanly to
Linux 6.18.44, and is already in mainline. The companion DT binding
patch should ideally be backported alongside it, but this driver commit
alone is valid stable material.

---

## Verification

- **[Phase 1]** Parsed subject, tags, body from provided commit message
  and mbox.
- **[Phase 1]** `b4 am
  20260515082232.1766586-2-dario.binacchi@amarulasolutions.com`:
  confirmed v2 2-patch series; Reviewed-by Dmitry Baryshkov; Acked-by
  Conor Dooley on patch 1/2.
- **[Phase 2]** Diff analysis: +28 lines in `panel-simple.c`; static
  data + one `platform_of_match` entry.
- **[Phase 3]** `git describe HEAD`: v6.18.44 / 6.18.44 on
  `stable/linux-6.18.y`.
- **[Phase 3]** `git grep "am-1280800w8tzqw-t00h" origin/master`: only
  in `panel-simple.c` and `panel-simple.yaml` on mainline; absent from
  HEAD.
- **[Phase 3]** `git show bca684e69c4ce --stat`: sibling N3 panel
  backported to 6.6.y (+29 lines, same pattern).
- **[Phase 3]** `git log stable/linux-6.6.y --grep="1280800"`: N3 panel
  + binding + bpc fix backported to 6.6.y.
- **[Phase 4]** `b4 dig -c 0fd8b67e27ff7`: no match (merge commit).
- **[Phase 4]** Read mbox `v2_20260515_dario_binacchi_dt_bindings_displa
  y_simple_add_am_1280800w8tzqw_t00h.mbx`: no Cc: stable; 2-patch series
  confirmed.
- **[Phase 5]** `grep panel_simple_probe/panel_simple_get_desc` in
  `panel-simple.c`: standard probe path via
  `of_device_get_match_data()`.
- **[Phase 6]** `grep "am-1280800w8tzqw"`: zero matches in local tree.
- **[Phase 6]** `grep "am-1280800n3tzqw"`: present in `panel-simple.c`
  and three in-tree DTS files.
- **[Phase 6]** `git diff HEAD origin/master --
  drivers/gpu/drm/panel/panel-simple.c`: W8 addition is a clean 28-line
  insert at expected location.
- **[Phase 6]** `git show origin/master:panel-simple.c | rg
  "1280800w8"`: confirmed mainline has full W8 definition.
- **[Phase 7]** Read `Documentation/process/stable-kernel-rules.rst`:
  confirms device-ID additions are valid stable material.
- **[Phase 8]** `git grep "am-1280800w8tzqw-t00h" origin/master`: no DTS
  references — no in-tree board uses this panel yet.

**YES**The background lookups finished and line up with the earlier
analysis:

- **Pickaxe search** (`am-1280800w8tzqw-t00h` on `origin/master`): only
  surfaced merge commit `0fd8b67e27ff7`, not the original panel patch —
  the change is buried in a merge, which is why a direct subject/hash
  search was needed.
- **Broader pickaxe search** (with `--all`): slow and similarly
  unhelpful for finding the real introducing commit.
- **`b4 dig -c 0fd8b67e27ff7`**: no lore match on that RDMA merge
  commit.

The useful trace came from **`b4 am`** on the patch msgid, which found
the v2 2-patch series (DT binding + driver). That supports the **YES**
verdict for 6.18.44: a small device-ID addition to an existing driver,
with the companion binding patch ideally backported alongside it.

 drivers/gpu/drm/panel/panel-simple.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index ef1c4b9299ee4..878a5dc7748fb 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -820,6 +820,31 @@ static const struct panel_desc ampire_am_1280800n3tzqw_t00h = {
 	.connector_type = DRM_MODE_CONNECTOR_LVDS,
 };
 
+static const struct drm_display_mode ampire_am_1280800w8tzqw_t00h_mode = {
+	.clock = 72400,
+	.hdisplay = 1280,
+	.hsync_start = 1280 + 40,
+	.hsync_end = 1280 + 40 + 80,
+	.htotal = 1280 + 40 + 80 + 40,
+	.vdisplay = 800,
+	.vsync_start = 800 + 10,
+	.vsync_end = 800 + 10 + 18,
+	.vtotal = 800 + 10 + 18 + 10,
+};
+
+static const struct panel_desc ampire_am_1280800w8tzqw_t00h = {
+	.modes = &ampire_am_1280800w8tzqw_t00h_mode,
+	.num_modes = 1,
+	.bpc = 8,
+	.size = {
+		.width = 217,
+		.height = 136,
+	},
+	.bus_flags = DRM_BUS_FLAG_DE_HIGH,
+	.bus_format = MEDIA_BUS_FMT_RGB888_1X7X4_SPWG,
+	.connector_type = DRM_MODE_CONNECTOR_LVDS,
+};
+
 static const struct drm_display_mode ampire_am_480272h3tmqw_t01h_mode = {
 	.clock = 9000,
 	.hdisplay = 480,
@@ -4965,6 +4990,9 @@ static const struct of_device_id platform_of_match[] = {
 	{
 		.compatible = "ampire,am-1280800n3tzqw-t00h",
 		.data = &ampire_am_1280800n3tzqw_t00h,
+	}, {
+		.compatible = "ampire,am-1280800w8tzqw-t00h",
+		.data = &ampire_am_1280800w8tzqw_t00h,
 	}, {
 		.compatible = "ampire,am-480272h3tmqw-t01h",
 		.data = &ampire_am_480272h3tmqw_t01h,
-- 
2.53.0

