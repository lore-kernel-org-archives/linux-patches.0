Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B283BD24A;
	Mon, 20 Apr 2026 13:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691027; cv=none; b=ei/XqVV4BCp0FZNN9+V9ylINHFXQql+4rdVO7sh+BLWEATNpHsMwCqvhAZf01lzShl3RtwF2u38CxECq/CY1IkS0JCQTtWQeAGTEiRnjBrrAdoGhns6+qEehXNjoEtui4nJru2IxcL02RChX8bVLFCnh3P7y8I3UVBfKB/SkMFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691027; c=relaxed/simple;
	bh=Qu7sIifMmeg/AZ9+nTE5yMeiMhpoOCQI2zjYQC5ILxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qWym6OXo0ncxNuafjuKbxogXsoWDED1o+X0ooBrb0Zc91Jgi5Z1LE+fPIuOiLjgI3ZOtsQKE4D8NaLk9spYe/5Xuxy6QwX6oP9r1Hh1nmbocHyi5XZVazpdJy8VAEwCho3UMjM6Jzzutrl8G2O+JW/EkqwmLiCinxGhkuhpJkgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MlMNpOvq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MlMNpOvq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F08C2BCB4;
	Mon, 20 Apr 2026 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691027;
	bh=Qu7sIifMmeg/AZ9+nTE5yMeiMhpoOCQI2zjYQC5ILxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlMNpOvqvKpTDv9bxPxcadzN53x1WGSrOwgo+Shm4L4LQfIA3c/Rse98Wd+3ac1Rv
	 GA5cD5eyvO43maXM8zWP3R0+woexjOCMzVbPbEYJPP8uV2GZyNiL9PXxv/OwSM1+5o
	 hbZJYDiyWWPM4a/LGeI/FtsgUsuVRaVkrEfdoA1ueqX/4sopDjeK8T4qD6w/BqQT12
	 teiezll3etlPtJcr0cBsi+HXSXyLSCgwDpwHGm5vPi/JXpPudKyCMNdiiOL5Sw8Swy
	 8WvBLCkTnfb1g3R7s7RbeoElWT+L70ZByFDYJPO0R58E0V0lz2osaNJlKdOk0Vj8XL
	 k9nV/8kwcaPXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alvin1 Chen <alvin1.chen@lcfc.corp-partner.google.com>,
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
Subject: [PATCH AUTOSEL 7.0-6.19] drm/panel-edp: Add BOE NV153WUM-N42, CMN N153JCA-ELK, CSW MNF307QS3-2
Date: Mon, 20 Apr 2026 09:08:37 -0400
Message-ID: <20260420131539.986432-51-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alvin1 Chen <alvin1.chen@lcfc.corp-partner.google.com>

[ Upstream commit d51f217957ca1fa3a151000e86a192231284595b ]

The raw EDIDs for each panel:

BOE: NV153WUM-N42
00 ff ff ff ff ff ff 00 09 e5 b3 0d 00 00 00 00
11 23 01 04 a5 21 15 78 03 af e5 97 5e 58 92 28
1f 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 9c 3e 80 c8 70 b0 3c 40 30 20
36 00 49 ce 10 00 00 1a 00 00 00 fd 00 28 3c 4c
4c 10 01 0a 20 20 20 20 20 20 00 00 00 fe 00 42
4f 45 20 43 51 0a 20 20 20 20 20 20 00 00 00 fc
00 4e 56 31 35 33 57 55 4d 2d 4e 34 32 0a 01 92

70 20 79 02 00 81 00 15 74 1a 00 00 03 01 28 3c
00 00 60 49 60 49 3c 00 00 00 00 80 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 cb 90

CMN: N153JCA-ELK
00 ff ff ff ff ff ff 00 0d ae 6b 15 00 00 00 00
16 23 01 04 a5 21 15 78 03 08 82 93 59 53 8e 27
1e 4f 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 42 3c 80 a0 70 b0 24 40 30 20
a6 00 49 cd 10 00 00 1a 00 00 00 fd 00 28 3c 4a
4a 10 01 0a 20 20 20 20 20 20 00 00 00 fe 00 43
4d 4e 0a 20 20 20 20 20 20 20 20 20 00 00 00 fc
00 4e 31 35 33 4a 43 41 2d 45 4c 4b 0a 20 01 d5

70 20 79 02 00 25 01 09 94 5a 02 94 5a 02 28 3c
80 81 00 13 72 1a 00 00 03 01 28 3c 00 00 00 00
00 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 ae 90

CSW: MNF307QS3-2
00 ff ff ff ff ff ff 00 0e 77 29 15 00 00 00 00
13 23 01 04 a5 21 15 78 03 9c 81 96 5d 5a 94 28
1e 51 56 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 1a 3f 80 04 71 b0 23 40 30 20
36 00 49 cd 10 00 00 18 00 00 00 fd 00 28 3c 4a
4a 10 01 0a 20 20 20 20 20 20 00 00 00 fe 00 43
4f 53 54 20 54 39 0a 20 20 20 20 20 00 00 00 fc
00 4d 4e 46 33 30 37 51 53 33 2d 32 0a 20 01 5c

70 20 79 02 00 81 00 15 74 1a 00 00 03 01 28 3c
00 00 60 46 60 46 3c 00 00 00 00 8d 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 c4 90

Signed-off-by: Alvin1 Chen <alvin1.chen@lcfc.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260319050938.556235-1-alvin1.chen@lcfc.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis. Let me
compile the findings.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/panel-edp`
- Action: "Add" (three new panel entries)
- Summary: Adding panel IDs for BOE NV153WUM-N42, CMN N153JCA-ELK, CSW
  MNF307QS3-2
- Record: [drm/panel-edp] [Add] [Three new eDP panel ID entries to
  existing driver table]

**Step 1.2: Tags**
- `Signed-off-by: Alvin1 Chen <alvin1.chen@lcfc.corp-
  partner.google.com>` — author, Google Corp Partner (Lenovo/LCFC)
- `Reviewed-by: Douglas Anderson <dianders@chromium.org>` — the
  drm/panel-edp subsystem maintainer reviewed it
- `Signed-off-by: Douglas Anderson <dianders@chromium.org>` — maintainer
  applied/signed off on it
- `Link: https://patch.msgid.link/20260319050938.556235-1-
  alvin1.chen@lcfc.corp-partner.google.com` — patch submission link
- No Fixes: tag (expected for device ID additions)
- No Cc: stable (expected)
- Record: Reviewed and signed off by subsystem maintainer Douglas
  Anderson. Author is from LCFC/Google partnership (Chromebook
  hardware).

**Step 1.3: Commit Body**
- Contains raw EDID hex dumps for all three panels as
  documentation/proof
- No bug description (this is hardware enablement, not a fix per se)
- Record: Commit body is EDID data only — standard for panel-edp
  additions.

**Step 1.4: Hidden Bug Fix Detection**
- This is not a disguised bug fix. It is a straightforward hardware
  enablement (device ID addition) to an existing driver. Without the
  entry, panels are unrecognized and may not work or use incorrect
  timings.
- Record: Not a hidden bug fix; it's a device ID addition which is an
  explicit exception category for stable.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/gpu/drm/panel/panel-edp.c`)
- Lines added: 3 (one `EDP_PANEL_ENTRY` line per panel)
- Lines removed: 0
- Functions modified: none (only data table entries)
- Record: Single file, +3 lines, static data table only. Ultra-minimal
  scope.

**Step 2.2: Code Flow Change**
- Three new entries added to the `edp_panels[]` static const array:
  1. `EDP_PANEL_ENTRY('B', 'O', 'E', 0x0db3, &delay_200_500_e80,
     "NV153WUM-N42")` — inserted between 0x0d73 and 0x0ddf (sorted
     order)
  2. `EDP_PANEL_ENTRY('C', 'M', 'N', 0x156b, &delay_200_500_e80_d50,
     "N153JCA-ELK")` — inserted between 0x1565 and 0x162b (sorted order)
  3. `EDP_PANEL_ENTRY('C', 'S', 'W', 0x1529, &delay_200_500_e80_d50,
     "MNF307QS3-2")` — inserted after 0x1519 (sorted order)
- Before: These three panels were unrecognized by the driver
- After: These panels are matched by their EDID panel ID and get proper
  timing delays
- Record: Data-only additions in sorted order. No behavior change for
  any existing panel.

**Step 2.3: Bug Mechanism**
- Category (h): Hardware workaround / device ID addition
- The delay structures referenced (`delay_200_500_e80` at line 1753 and
  `delay_200_500_e80_d50` at line 1759) already exist in the file and
  are used by dozens of other panels
- Record: Device ID addition to existing data table. Uses pre-existing
  delay structures.

**Step 2.4: Fix Quality**
- Obviously correct: Each entry follows identical pattern to ~198
  existing entries
- Minimal/surgical: 3 lines, data only
- Regression risk: Zero — entries only match specific panel IDs; no
  existing panels are affected
- Record: Fix quality is perfect. No regression risk whatsoever.

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The surrounding entries were added by various contributors between
  2024-2025
- The `edp_panels[]` table has been growing steadily; 68 commits to this
  file since 2024-01-01
- Record: Table has existed for many kernel versions. This is a very
  mature, well-maintained data structure.

**Step 3.2: Fixes Tag**
- No Fixes: tag (expected for device ID additions)
- Record: N/A

**Step 3.3: File History**
- This file receives frequent panel additions (68 commits in ~2 years)
- No prerequisite commits needed — the delay structures and macro
  already exist
- Record: Standalone commit, no dependencies.

**Step 3.4: Author's Commits**
- Alvin1 Chen has no prior commits in this tree for panel-edp.c
- Author is from LCFC (Lenovo manufacturing partner, Google Chromebook
  program)
- Douglas Anderson (reviewer/signer) is the drm/panel-edp maintainer
  with 10+ commits here
- Record: Author is a hardware partner contributor. Maintainer reviewed
  and applied.

**Step 3.5: Dependencies**
- No dependencies. The `EDP_PANEL_ENTRY` macro (line 1859),
  `delay_200_500_e80` (line 1753), and `delay_200_500_e80_d50` (line
  1759) all exist in the current stable tree.
- Record: Fully standalone. All referenced structures present.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Discussion**
- b4 dig could not find the commit (it's not yet in this tree)
- Lore is protected by Anubis bot-filtering
- Link in commit message:
  `patch.msgid.link/20260319050938.556235-1-alvin1.chen@lcfc.corp-
  partner.google.com`
- Record: Could not fetch lore discussion due to anti-bot measures.
  However, the patch is reviewed and signed-off by the subsystem
  maintainer.

**Step 4.2: Reviewers**
- Douglas Anderson (dianders@chromium.org) is THE maintainer for
  drm/panel-edp (verified by his 10+ commits to this file and his
  reviewer/signer role)
- Record: Subsystem maintainer reviewed and applied the patch.

**Step 4.3-4.5: Bug Reports / Related Patches / Stable History**
- No bug report (this is hardware enablement, not a bug fix)
- This is a single standalone patch (not part of a series)
- Record: N/A for bug reports. Standalone single patch.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Functions and Call Chains**
- No functions are modified. The change is to a static const data table
  `edp_panels[]`
- This table is looked up during panel probing when EDID is read from
  the connected display
- If a panel ID matches, the associated delay timings are used; if no
  match, generic/conservative timings are used
- Record: Data table lookup only. No code flow changes.

**Step 5.5: Similar Patterns**
- There are 198 existing `EDP_PANEL_ENTRY` entries in this file, all
  following the identical pattern
- Record: Extremely well-established pattern.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code in Stable Trees**
- The `panel-edp.c` driver and `edp_panels[]` table exist in 7.0 and all
  active stable trees
- The `EDP_PANEL_ENTRY` macro and both referenced delay structures exist
- Record: All infrastructure present in stable trees.

**Step 6.2: Backport Complications**
- The patch will apply cleanly to the 7.0 tree — the surrounding entries
  (0x0d73, 0x0ddf, 0x1565, 0x162b, 0x1519) all exist at the expected
  positions
- Older stable trees may need minor context adjustment if some
  surrounding entries don't exist, but the additions are independent and
  can be trivially placed
- Record: Clean apply expected for 7.0. Minor fuzz possible for older
  trees.

**Step 6.3: Related Fixes Already in Stable**
- No related fixes — these are new panel IDs not previously added
- Record: No prior entries for these panels.

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem**
- Subsystem: DRM panel (drivers/gpu/drm/panel/) — display panel driver
- Criticality: IMPORTANT — affects users with specific laptop panels
  (likely Chromebooks)
- Record: Display driver, important for hardware enablement.

**Step 7.2: Activity**
- Very active: 68 commits since 2024, regular panel additions
- Record: Actively maintained, frequent contributions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- Users with laptops containing BOE NV153WUM-N42, CMN N153JCA-ELK, or
  CSW MNF307QS3-2 panels
- Likely Chromebook users (Google Corp Partner author, Chromium
  reviewer)
- Record: Hardware-specific; affects users with these specific panels.

**Step 8.2: Trigger Conditions**
- Every boot on affected hardware — panel detection happens during
  display initialization
- Without the entry, the panel may work with generic timings but could
  have display issues
- Record: Triggered every boot on affected hardware.

**Step 8.3: Failure Mode**
- Without this fix: Panel uses generic/conservative timings; may result
  in display flickering, incorrect initialization, or suboptimal
  performance
- With this fix: Panel gets correct vendor-specified timing delays
- Record: Severity MEDIUM — hardware enablement for display panels.

**Step 8.4: Risk-Benefit**
- BENEFIT: Enables proper display support for real hardware
  (laptops/Chromebooks)
- RISK: Virtually zero — 3 lines of static data, only matched by
  specific panel IDs, no effect on any other hardware
- Record: Very high benefit-to-risk ratio.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**
- FOR: Device ID addition to existing driver (explicit exception
  category); 3 lines; zero regression risk; reviewed by subsystem
  maintainer; uses existing infrastructure; standalone patch
- AGAINST: Nothing substantive
- UNRESOLVED: Could not access lore discussion (Anubis blocking)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — identical pattern to 198 existing
   entries, reviewed by maintainer
2. Fixes a real bug that affects users? YES — enables hardware support
   for real panels
3. Important issue? MEDIUM — hardware doesn't get optimal timings
   without it
4. Small and contained? YES — 3 lines, single file, data only
5. No new features or APIs? YES — no new features, just device IDs
6. Can apply to stable trees? YES — all infrastructure exists

**Step 9.3: Exception Category**
- **NEW DEVICE IDs** — adding panel IDs to an existing driver. This is
  an explicit YES exception category.

**Step 9.4: Decision**
This is a textbook device ID addition — the most common and safest type
of stable backport.

## Verification

- [Phase 1] Parsed tags: Reviewed-by and Signed-off-by from Douglas
  Anderson (maintainer)
- [Phase 2] Diff analysis: +3 lines, all EDP_PANEL_ENTRY additions to
  static const data table
- [Phase 2] Verified delay_200_500_e80 exists at line 1753,
  delay_200_500_e80_d50 at line 1759
- [Phase 2] Verified EDP_PANEL_ENTRY macro defined at line 1859
- [Phase 2] Verified entries inserted in sorted order (0x0db3 between
  0x0d73/0x0ddf, 0x156b between 0x1565/0x162b, 0x1529 after 0x1519)
- [Phase 3] git blame: surrounding entries present from various authors
  (2024-2025)
- [Phase 3] git log: 68 commits to this file since 2024, very active
- [Phase 3] Verified author has no prior commits; maintainer Douglas
  Anderson has 10+ commits here
- [Phase 4] b4 dig: could not find commit (not in tree). Lore blocked by
  Anubis.
- [Phase 5] No functions modified; data table only
- [Phase 6] All referenced structures confirmed present in 7.0 tree;
  patch applies cleanly
- [Phase 6] 198 existing EDP_PANEL_ENTRY entries confirm the
  pattern/infrastructure is stable
- UNVERIFIED: Could not read lore discussion thread; however maintainer
  sign-off provides sufficient confidence

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 260fa18b0f78a..c073ea87008de 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1999,6 +1999,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cfa, &delay_200_500_e50, "NV116WHM-A4D"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d45, &delay_200_500_e80, "NV116WHM-N4B"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d73, &delay_200_500_e80, "NE140WUM-N6S"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0db3, &delay_200_500_e80, "NV153WUM-N42"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0ddf, &delay_200_500_e80, "NV116WHM-T01"),
 
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1130, &delay_200_500_e50, "N116BGE-EB2"),
@@ -2035,6 +2036,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x14d6, &delay_200_500_e80_d50, "N140BGA-EA4"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x14e5, &delay_200_500_e80_d50, "N140HGA-EA1"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1565, &delay_200_500_e80, "N156HCA-EAB"),
+	EDP_PANEL_ENTRY('C', 'M', 'N', 0x156b, &delay_200_500_e80_d50, "N153JCA-ELK"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x162b, &delay_200_500_e80_d50, "N160JCE-ELL"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x7402, &delay_200_500_e200_d50, "N116BCA-EAK"),
 
@@ -2053,6 +2055,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x146e, &delay_80_500_e50_d50, "MNE007QB3-1"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x147c, &delay_200_500_e50_d100, "MNE007QB3-1"),
 	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1519, &delay_200_500_e80_d50, "MNF601BS1-3"),
+	EDP_PANEL_ENTRY('C', 'S', 'W', 0x1529, &delay_200_500_e80_d50, "MNF307QS3-2"),
 
 	EDP_PANEL_ENTRY('E', 'T', 'C', 0x0000, &delay_50_500_e200_d200_po2e335, "LP079QX1-SP0V"),
 
-- 
2.53.0

