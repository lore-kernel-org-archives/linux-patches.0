Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C71624A2E2E;
	Mon, 20 Apr 2026 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691964; cv=none; b=kWZUX+PNRPPPKCklKItPaew9B/YHGOB2UfuQ7YXcbiWiY9hbUwLkvcQ77R78jFe8HPMTfd3NqdJ+/4Gn6ko0CWzirvLK1wqnDeA484oZp4QbYzxcecnKm1fmPBXJ20fMHR/NJjI2IFCCkJbB1KHBbKYI/248VhYYx+iU96/69nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691964; c=relaxed/simple;
	bh=Bz0MYcCSoXg0+rbrkRMf3Fd9aHfOgXPlHPxrXeALiP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNM8Mkx3e4B1awtgcfMre/XC9Z4QBF6fnRPSKrcl+i186bu0ZS9//1dPoJQ1tLkoZWLlDVDyhMPl3owJNwwuLUZkie1W9Pnp2AojGjxkGbeRvS94uTjusNtXuw6ezDeXUnahVTivsXL7KYFt2bv3K6hHqP7oSKByBOcEfZRr4gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lxWTs3q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lxWTs3q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EAEC2BCB6;
	Mon, 20 Apr 2026 13:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691964;
	bh=Bz0MYcCSoXg0+rbrkRMf3Fd9aHfOgXPlHPxrXeALiP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lxWTs3q/y96smcEUmTZoS24lgvc3zD5gRfFxvhYrR5F/30psMevFiOK3Qdww1Dd9/
	 IUiXys20jzdgkT7IlrFAUKBypRisboH7zIaety/eiUCEGe12Yu2nY5tijGBLCvBHaO
	 AUciCz20v1shGwY+DNf9i539cpcj9iNAYahaLtNDDNs/TanF8V8qwqnsMNfpB6Q0om
	 od5OPMumJsx0IlNbg7vBsD/PhW4pI2TFMuUZKc5J7R5qvXsT90QlMIUZoT9flxFvBU
	 Ds9U25oAJt+uDJ54cnBKB7AILPsV1Hu8O9UYd8fe3v7sh3gklNQzEytmee9pXzmLrt
	 dU8gCYt962Qng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Cong Yang <yangcong5@huaqin.corp-partner.google.com>,
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
Subject: [PATCH AUTOSEL 7.0-6.18] drm/panel-edp: Add CMN N116BCL-EAK (C2)
Date: Mon, 20 Apr 2026 09:21:28 -0400
Message-ID: <20260420132314.1023554-294-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
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

From: Cong Yang <yangcong5@huaqin.corp-partner.google.com>

[ Upstream commit 3d65e4c276b32c03450261d114e495fda03c8e97 ]

Add support for the CMN N116BCL-EAK (C2) panel, pleace the EDID here for
subsequent reference.

edid-decode (hex):

00 ff ff ff ff ff ff 00 0d ae 7a 11 00 00 00 00
08 22 01 04 95 1a 0e 78 03 46 a5 9c 5b 53 8b 24
1d 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 e6 1e 56 e2 50 00 3c 30 30 20
a6 00 00 90 10 00 00 1a 00 00 00 fd 00 28 3c 32
32 08 01 0a 20 20 20 20 20 20 00 00 00 fe 00 43
4d 4e 0a 20 20 20 20 20 20 20 20 20 00 00 00 fe
00 4e 31 31 36 42 43 4c 2d 45 41 4b 0a 20 01 80

70 20 79 02 00 25 01 09 fc 34 01 fc 34 01 28 3c
80 81 00 10 72 1a 00 00 03 01 28 3c 00 00 00 00
00 00 3c 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 2f 90

Signed-off-by: Cong Yang <yangcong5@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260130030456.2080748-1-yangcong5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I now have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: drm/panel-edp
- **Action verb**: "Add" — adding a new panel entry
- **Summary**: Adding support for a new hardware revision (C2) of the
  CMN N116BCL-EAK eDP panel

Record: [drm/panel-edp] [Add] [New device ID for CMN N116BCL-EAK C2
panel revision]

### Step 1.2: Tags
- **Signed-off-by**: Cong Yang (author), Douglas Anderson
  (maintainer/committer)
- **Reviewed-by**: Douglas Anderson (drm/panel-edp maintainer at
  Chromium)
- **Link**: patch.msgid.link (standard commit link)
- No Fixes: tag (expected)
- No Cc: stable tag (expected)
- No Reported-by (hardware enablement, not a bug report)

Record: Reviewed and signed by subsystem maintainer Douglas Anderson. No
bug tags (expected for device ID addition).

### Step 1.3: Commit Body
The body includes the full EDID dump for the panel with ID 0x117a (CMN
N116BCL-EAK C2). The EDID is included "for subsequent reference" —
standard practice for panel-edp entries. No bug is described because
this is hardware enablement, not a bug fix.

Record: [No bug described - hardware ID addition] [Panel would not be
recognized without this entry] [Chromebook panel hardware]

### Step 1.4: Hidden Bug Fix Detection
This is not a hidden bug fix. It's a straightforward device ID addition
to enable hardware. Without this entry, systems with the C2 revision
panel would not use the correct timing parameters, potentially causing
display initialization issues.

Record: [Not a hidden bug fix — device ID addition for hardware support]

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 (`drivers/gpu/drm/panel/panel-edp.c`)
- **Lines added**: 1
- **Lines removed**: 0
- **Functions modified**: None (data table only)
- **Scope**: Single-line addition to a static const data table

Record: [1 file, +1 line, data table entry only, minimal scope]

### Step 2.2: Code Flow Change
The single line added:
```c
EDP_PANEL_ENTRY('C', 'M', 'N', 0x117a, &delay_200_500_e80_d50, "N116BCL-
EAK"),
```
This adds a new entry to the `edp_panels[]` array, which is a lookup
table mapping panel EDID manufacturer/product IDs to timing parameters.
Before: panel ID 0x117a would not match any entry. After: it matches
with the correct `delay_200_500_e80_d50` timing.

Record: [Before: panel 0x117a unrecognized, After: panel recognized with
correct timing]

### Step 2.3: Bug Mechanism
Category: **Hardware workaround / device ID addition**. The
`EDP_PANEL_ENTRY` macro creates a table entry with vendor ID
('C','M','N' = Chi Mei / Innolux), product ID (0x117a), delay timings,
and name string. This is a device ID table entry, not a code logic
change.

Record: [Device ID addition — hardware enablement table entry]

### Step 2.4: Fix Quality
- Obviously correct: Yes — identical pattern to 200+ other entries in
  the same table
- Minimal/surgical: Yes — 1 line
- Regression risk: Zero — only affects systems with this specific panel
  ID
- Red flags: None

Record: [Obviously correct, minimal, zero regression risk]

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The surrounding lines show entries added by multiple authors from
2022-2025. The same panel name (N116BCL-EAK) already exists with product
ID 0x115f (added by same author in commit 518867b093942, July 2025). The
new entry is for a different hardware revision (C2) with product ID
0x117a.

Record: [Same panel model already has an entry for 0x115f. This is a new
revision C2 with 0x117a. Table has been active since kernel 5.16.]

### Step 3.2: Fixes Tag
No Fixes: tag — expected for device ID additions.

Record: [N/A — no Fixes: tag, expected for hardware enablement]

### Step 3.3: File History
The file has 140 commits, almost all of which are panel ID additions.
This is one of the most frequently updated data tables in the kernel.

Record: [Active file with 140+ commits, mostly panel ID additions.
Standalone single commit.]

### Step 3.4: Author
Cong Yang is from Huaqin (a Google Chromebook manufacturing partner).
They have contributed multiple panel entries for Chromebook hardware.

Record: [Author is Chromebook hardware partner. Maintainer (dianders)
reviewed and applied.]

### Step 3.5: Dependencies
Uses existing `delay_200_500_e80_d50` timing structure and
`EDP_PANEL_ENTRY` macro. Both have existed since the file was created.
No dependencies on other commits.

Record: [No dependencies. Uses existing infrastructure. Fully
standalone.]

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: Patch Discussion
From the b4 mbox fetch: the thread has 2 messages. This is V2 of the
patch. V1 used "N116BCL-EAK-c2" as the name string; review feedback
requested changing it to "N116BCL-EAK" (matching the naming convention
of other entries). Douglas Anderson replied with "Reviewed-by" and
"Pushed to drm-misc-next", committing it as 3d65e4c276b3.

Record: [V2 patch. V1 had minor naming issue fixed in V2. Maintainer
reviewed and pushed. No objections.]

### Step 4.2: Reviewers
From the mbox headers: Sent to DRM maintainers (neil.armstrong,
jesszhan, maarten.lankhorst, mripard, tzimmermann, airlied, simona) and
the DRM panel maintainer (dianders, treapking). CC'd dri-devel and
linux-kernel. Douglas Anderson reviewed and applied.

Record: [All appropriate maintainers and mailing lists were CC'd.
Subsystem maintainer reviewed.]

### Steps 4.3-4.5: Bug Report / Related Patches / Stable Discussion
No bug report (hardware enablement). No related patches needed. No prior
stable discussion found.

Record: [N/A — hardware enablement, not bug fix]

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function Analysis
The `edp_panels[]` table is looked up during panel probe. When a panel's
EDID is read, its manufacturer/product ID is matched against this table
to find the correct timing parameters. Without a matching entry, the
panel either uses generic/conservative timings or may fail to initialize
properly.

Record: [Table is queried during panel probe on every eDP panel
initialization. Affects Chromebooks using this specific panel.]

### Step 5.5: Similar Patterns
There are 200+ identical `EDP_PANEL_ENTRY` lines in the same table. This
pattern is universally used for all eDP panel identification.

Record: [Identical pattern used 200+ times in the same table]

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The `panel-edp.c` file and `edp_panels[]` table exist in all stable
trees since 5.16. The `delay_200_500_e80_d50` structure and
`EDP_PANEL_ENTRY` macro are present in all relevant stable trees.

Record: [File and infrastructure exist in all active stable trees
(6.1.y, 6.6.y, 6.12.y, 7.0.y)]

### Step 6.2: Backport Complications
The insertion point (between 0x1163 and 0x1247 entries) may differ in
older stable trees that don't have all the intermediate panel entries.
However, the line can be inserted anywhere in the CMN section in sorted
order — minor fuzz is expected but the patch should apply or be
trivially adaptable.

Record: [May need minor context adjustment in older stable trees.
Trivially adaptable.]

### Step 6.3: Related Fixes
No related fixes already in stable for this specific panel ID.

Record: [No prior fixes for panel ID 0x117a in stable]

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem
- **Subsystem**: DRM/Display (drivers/gpu/drm/panel/)
- **Criticality**: IMPORTANT — display panels affect user experience on
  Chromebooks and laptops

Record: [DRM display panel driver, IMPORTANT criticality, affects
Chromebook users]

### Step 7.2: Activity
Extremely active file — 140 commits, mostly panel additions. Panel-edp
is one of the most actively maintained data tables in the kernel,
specifically for Chromebook eDP panel support.

Record: [Very active, continuously updated]

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Affected Users
Users with Chromebooks or laptops using the CMN N116BCL-EAK C2 panel
revision. This is a specific Chromebook panel manufactured by
Huaqin/Google partners.

Record: [Driver-specific: Chromebook users with this panel model]

### Step 8.2: Trigger Conditions
Every boot on affected hardware. Without this entry, the panel may use
suboptimal timing, potentially causing display issues during
initialization.

Record: [Triggers on every boot of affected hardware]

### Step 8.3: Failure Severity
Without the entry: display may not initialize properly or may use
conservative/wrong timings. With the entry: display works correctly with
manufacturer-specified timings.

Record: [Display initialization — MEDIUM to HIGH for affected users]

### Step 8.4: Risk-Benefit
- **Benefit**: HIGH for affected hardware users — enables correct panel
  operation
- **Risk**: VERY LOW — 1-line data table addition, cannot affect any
  other hardware
- **Ratio**: Very favorable

Record: [HIGH benefit, VERY LOW risk, strongly favorable ratio]

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Single-line device ID addition to existing driver (classic stable
  exception)
- Zero regression risk — only affects specific panel hardware ID
- Reviewed by subsystem maintainer Douglas Anderson
- Uses existing timing structure and macro — no new code
- Enables correct panel operation for Chromebook hardware
- Driver and infrastructure exist in all active stable trees

**AGAINST backporting:**
- Not a bug fix in the traditional sense (hardware enablement)
- Affects only users with this specific panel revision

**UNRESOLVED:**
- Exact Chromebook models using this panel (likely mt8189-based, given
  the author's other commits)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — identical pattern to 200+
   other entries, reviewed by maintainer
2. **Fixes a real bug?** Enables hardware support (device ID addition
   exception)
3. **Important issue?** YES for affected hardware users
4. **Small and contained?** YES — 1 line, 1 file
5. **No new features or APIs?** Correct — data table entry only
6. **Can apply to stable?** YES — may need trivial context adjustment

### Step 9.3: Exception Category
**YES — Device ID addition to existing driver.** This is explicitly
called out as an allowed exception in stable kernel rules. The driver
already exists; only the panel identifier is new.

### Step 9.4: Decision
This is a textbook device ID addition — a single-line entry in an
existing panel identification table, using existing timing structures,
reviewed by the subsystem maintainer, with zero regression risk. It
falls squarely into the "new device IDs to existing drivers" exception
category for stable backports.

## Verification

- [Phase 1] Parsed tags: Reviewed-by Douglas Anderson (maintainer),
  signed by maintainer, no Fixes/stable tags (expected)
- [Phase 2] Diff analysis: +1 line in edp_panels[] table, adds
  EDP_PANEL_ENTRY for CMN 0x117a
- [Phase 3] git blame: surrounding entries from 2022-2025, same panel
  name 0x115f added July 2025
- [Phase 3] git show 3d65e4c276b3: confirmed mainline commit exists with
  identical diff
- [Phase 3] git log --author: author contributed multiple Chromebook
  panel entries
- [Phase 4] b4 mbox: found 2-message thread, V2 patch, maintainer
  reviewed and pushed to drm-misc-next
- [Phase 4] Mailing list: V1→V2 evolution (name string change), no
  objections
- [Phase 5] Table is queried during panel probe, affects every boot on
  affected hardware
- [Phase 6] panel-edp.c exists since 5.16 (commit 5f04e7ce392db, Sept
  2021), present in all active stable trees
- [Phase 6] delay_200_500_e80_d50 and EDP_PANEL_ENTRY macro exist in
  current tree (verified via grep)
- [Phase 8] 1-line data table addition, zero risk to other hardware
- UNVERIFIED: Exact stable tree context differences (but trivially
  adaptable for a sorted table entry)

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 108569490ed59..c9eacfffd5b29 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -2014,6 +2014,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1160, &delay_200_500_e80_d50, "N116BCJ-EAK"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1161, &delay_200_500_e80, "N116BCP-EA2"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1163, &delay_200_500_e80_d50, "N116BCJ-EAK"),
+	EDP_PANEL_ENTRY('C', 'M', 'N', 0x117a, &delay_200_500_e80_d50, "N116BCL-EAK"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x1247, &delay_200_500_e80_d50, "N120ACA-EA1"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x124c, &delay_200_500_e80_d50, "N122JCA-ENK"),
 	EDP_PANEL_ENTRY('C', 'M', 'N', 0x142b, &delay_200_500_e80_d50, "N140HCA-EAC"),
-- 
2.53.0

