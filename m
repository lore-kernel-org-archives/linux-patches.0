Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811DA481241;
	Mon, 20 Apr 2026 13:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691897; cv=none; b=uBatNQklXoOgE/BDTtFSahLVzyJR24KQzNTUv7sHxQbMl+VXBRD+UKr1I3i/MaKPb5olWeaKdSyzVlBNERfsD7ZVSdwdr82qMv6YtpyOtl1iuXa0eUWh6V+HE3NDh/RIPmDLgKnIpjCIVsPQMub24VomosUttWjWEg0ozIAM8to=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691897; c=relaxed/simple;
	bh=lqXv5gxENQT44k4x7SJliy5KPGN8NVdQvbn5CUZy7Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrsZdccVSMTKSqxcWWTTBIJqRSihgL0FWkYvNSBgXXWodYEx7QzQ+ZbSTi4YEgYal5xbtc49VU3jsANobUmCV7aq2AuuO43c++F3TmS/c3IVEYqsiFnlhZ8uBddps/2HUwvpawidDteSMAupEbtRr5gzSPS3M5qMQ8d2YWSLnow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqDHNFRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqDHNFRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D13DC2BCB4;
	Mon, 20 Apr 2026 13:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691897;
	bh=lqXv5gxENQT44k4x7SJliy5KPGN8NVdQvbn5CUZy7Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cqDHNFRq+/WkdOWJkFKcXcvUSuY93uZLZWmA+7z2E3aXsugIUr6vDcVjHifRmrklI
	 LJeDvSU62Bu9SLZWfPGSY2FaD3KSvVrhPhBYUHcy6birQdRW1rkTdfdAI7e9O1eaGl
	 JBS9smMUdXBaPVFHVtbxMGBRcbH86jwA428r+4TXubDrn34qzHGwYMBYgyctLKRubv
	 pyfZoTt1yZq6OQ34JTn7zhUXPX3ES6Venf/jztvGrMZVAq0AvL1j/YsnzM5Ek7KyTb
	 2FY215hAsg7b6OJxIcuELLEefxUWaMsh0lKPtXog6dVcmlURyZZdGuGdAqY/GdZNW4
	 U8MI/vpMhSsoQ==
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
Subject: [PATCH AUTOSEL 7.0-6.19] drm/panel-edp: Change BOE NV140WUM-N64 timings
Date: Mon, 20 Apr 2026 09:20:51 -0400
Message-ID: <20260420132314.1023554-257-sashal@kernel.org>
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
Content-Transfer-Encoding: 8bit

From: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>

[ Upstream commit bbe814bcb961ed2f30706ffdc806f18150709d2d ]

This screen timing requires a backlight off time of more than 100ms
from the end of the data stream to avoid screen flickering and red
light caused by screen material limitations.

Signed-off-by: Haikun Zhou <zhouhaikun5@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260226083235.2176689-1-zhouhaikun5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/panel-edp`
- Action verb: "Change" (timing adjustment)
- Summary: Changes timing parameters for BOE NV140WUM-N64 panel to fix
  screen flickering

**Step 1.2: Tags**
- Signed-off-by: Haikun Zhou (author from Huaqin, a Google hardware
  partner)
- Reviewed-by: Douglas Anderson (subsystem maintainer for panel-edp)
- Signed-off-by: Douglas Anderson (committed by maintainer)
- Link: patch.msgid.link URL
- No Fixes: tag (expected for autoselect candidate)
- No Cc: stable (expected)

**Step 1.3: Commit Body**
The commit message explicitly describes a hardware issue: "This screen
timing requires a backlight off time of more than 100ms from the end of
the data stream to avoid screen flickering and red light caused by
screen material limitations."
- Bug: Missing disable delay causes screen flickering and red light
  artifacts
- Symptom: Visible display artifacts when powering off panel
- Root cause: Hardware limitation of this specific panel requires T9
  timing (backlight off to end of video data) of >100ms

**Step 1.4: Hidden Bug Fix Detection**
This IS a bug fix disguised as a "change timings" commit. The original
panel entry used timings copied from a similar panel (NV140WUM-N41),
which lacked the disable delay needed by this specific panel. The fix
addresses a real user-visible display defect.

Record: [Hardware timing bug fix] [Screen flickering and red light on
panel disable]

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/gpu/drm/panel/panel-edp.c`)
- Lines added: ~7 (new struct + entry change)
- Lines removed: ~1 (old entry replaced)
- Functions: No functions modified - only data structures changed

**Step 2.2: Code Flow Change**
Two hunks:
1. Adds a new `delay_200_500_e200_d100` struct with `.disable = 100`
   field
2. Changes the NV140WUM-N64 panel entry from `&delay_200_500_e200` to
   `&delay_200_500_e200_d100`

Before: `panel_edp_disable()` is called with `.disable = 0` (not set),
so `msleep()` is skipped.
After: `panel_edp_disable()` is called with `.disable = 100`, so a 100ms
delay is inserted.

**Step 2.3: Bug Mechanism**
Category: Hardware workaround / timing fix. The panel's physical
material requires a minimum backlight-off-to-data-end delay (T9 in eDP
timing diagrams) that was not being enforced.

**Step 2.4: Fix Quality**
- Obviously correct: just adds a timing delay value, following the exact
  pattern used by many other panels
- Minimal/surgical: new struct + one table entry change
- Regression risk: Essentially zero. Only adds a 100ms delay for this
  specific panel model. Cannot affect other panels.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
The buggy code (the panel entry without disable delay) was introduced in
commit `82928cc1c2b2b` ("drm/panel-edp: Add BOE NV140WUM-N64") on
2025-07-31, first appearing in v6.18. That commit explicitly notes
"Timings taken from NV140WUM-N41" - the timings were copied from a
different panel, which explains why they were incomplete.

**Step 3.2: Fixes Tag**
No Fixes: tag present. The implicit fix target is 82928cc1c2b2b.

**Step 3.3: Related Changes**
Very similar commits exist:
- `9b3700b15cb58`: "Add disable to 100ms for MNB601LS1-4" - identical
  pattern, same author company (Huaqin)
- `1511d3c4d2bb3`: "Add 50ms disable delay for four panels" - same
  pattern, same company

Both of those had explicit `Fixes:` tags and were accepted.

**Step 3.4: Author**
Haikun Zhou is from Huaqin (a Google Chromebook hardware partner). The
company has submitted multiple panel timing fixes. Douglas Anderson, the
reviewer/committer, is the subsystem maintainer for panel-edp.

**Step 3.5: Dependencies**
This commit is fully standalone. The new `delay_200_500_e200_d100`
struct is self-contained. It only requires the original panel entry
(82928cc1c2b2b) to exist, which is in v6.18+.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1-4.5:**
The lore.kernel.org website blocked automated access (Anubis anti-bot
protection). However, I verified:
- The b4 dig for the original panel addition found the submission at `lo
  re.kernel.org/all/20250731215635.206702-4-alex.vinarskis@gmail.com/`
- The fix was reviewed and committed by Douglas Anderson (subsystem
  maintainer)
- Analogous fixes from the same company (1511d3c4d2bb3, 9b3700b15cb58)
  had Fixes: tags and were presumably accepted for stable

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Key Functions**
No functions are modified. Only data structures (const struct
definitions and table entries) are changed.

**Step 5.2-5.3: How the disable delay is used**
The `.disable` field is consumed in `panel_edp_disable()` (line
391-399):

```391:399:drivers/gpu/drm/panel/panel-edp.c
static int panel_edp_disable(struct drm_panel *panel)
{
        struct panel_edp *p = to_panel_edp(panel);

        if (p->desc->delay.disable)
                msleep(p->desc->delay.disable);

        return 0;
}
```

This is called from the DRM panel framework whenever the panel is being
disabled (e.g., screen off, suspend).

**Step 5.4: Call Chain**
`panel_edp_disable()` is called via the `drm_panel_funcs.disable`
callback, which is invoked by the DRM framework during display pipeline
teardown. This is a common path triggered on every screen
disable/suspend.

**Step 5.5: Similar Patterns**
Many panels already use disable delays: `d200`, `d50`, `d10`, `d100`
variants exist. This follows an established, well-tested pattern.

---

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence in Stable**
The BOE NV140WUM-N64 panel entry was introduced in v6.18. It exists in:
- 6.18.y: YES
- 6.19.y: YES
- 7.0.y: YES (confirmed at line 1990)
- 6.12.y and older: NO (panel entry doesn't exist)

**Step 6.2: Backport Complications**
The `delay_200_500_e200_d100` struct needs to be added. This should
apply cleanly or with trivial context conflicts due to nearby panel
entries that may differ between versions.

**Step 6.3: Related Fixes Already in Stable**
No prior fix for this specific panel's timing issue exists.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1:** DRM panel-edp is an IMPORTANT subsystem - it handles eDP
panels used in laptops (Chromebooks especially). This specific panel is
in the ASUS Zenbook A14 UX3407QA.

**Step 7.2:** The panel-edp file is very actively maintained with
frequent panel additions and timing fixes.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Who Is Affected**
Users with the BOE NV140WUM-N64 panel (EDID ID 0x0cf6), found in
specific ARM64 laptops like the ASUS Zenbook A14 UX3407QA.

**Step 8.2: Trigger Conditions**
Every panel disable (screen off, suspend, power management transition).
Very common operation.

**Step 8.3: Failure Mode Severity**
Screen flickering and red light artifacts - visible display defect.
Severity: MEDIUM (no crash or data corruption, but a user-visible
hardware defect that degrades user experience).

**Step 8.4: Risk-Benefit**
- BENEFIT: Fixes visible screen flickering for users with this specific
  panel. Real hardware users affected.
- RISK: Very low. Adds 100ms delay only for this specific panel. Cannot
  affect any other hardware. Follows an established pattern used by
  dozens of other panels.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence**

FOR backporting:
- Fixes real user-visible hardware defect (screen flickering, red light)
- Tiny, surgical change (new const struct + one table entry change)
- Follows established pattern (identical to dozens of existing delay
  structs)
- Reviewed and committed by subsystem maintainer (Douglas Anderson)
- Hardware quirk/workaround - an explicit exception category for stable
- Analogous fixes (9b3700b15cb58, 1511d3c4d2bb3) were accepted with
  Fixes: tags
- Zero regression risk - only affects one specific panel model
- Panel entry exists in 7.0.y tree

AGAINST backporting:
- No Fixes: tag (but this is expected for autoselect candidates)
- Only affects one specific laptop panel (narrow user base)
- Severity is MEDIUM (display artifacts, not crash/corruption)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES - trivial data change, reviewed by
   maintainer
2. Fixes a real bug? YES - screen flickering on real hardware
3. Important issue? MEDIUM - hardware defect, not crash, but user-
   visible
4. Small and contained? YES - ~8 lines total
5. No new features/APIs? CORRECT - just timing data
6. Can apply to stable? YES - may need minor context adjustment

**Step 9.3: Exception Categories**
YES - this is a hardware quirk/workaround for a specific panel with
broken/insufficient default timing.

**Step 9.4: Decision**
This is a hardware timing quirk fix that falls squarely into the
"hardware workarounds for broken devices" exception category. It's
small, safe, obviously correct, and fixes a real user-visible defect on
specific hardware.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Douglas Anderson (maintainer),
  author from Huaqin (Google partner)
- [Phase 2] Diff analysis: +7 lines new delay struct, 1 line table entry
  change. Data-only change.
- [Phase 3] git show 82928cc1c2b2b: confirmed original panel added in
  v6.18 with timings "taken from NV140WUM-N41"
- [Phase 3] git merge-base: panel entry exists in v6.18+ but NOT in
  v6.17 or earlier
- [Phase 3] git log --grep="disable": found analogous commits
  9b3700b15cb58 and 1511d3c4d2bb3 with same pattern and Fixes: tags
- [Phase 3] grep NV140WUM-N64: confirmed entry at line 1990 using
  `delay_200_500_e200` (no disable)
- [Phase 3] grep delay_200_500_e200_d100: confirmed struct does NOT
  exist yet in tree (needs to be added by this patch)
- [Phase 5] Read panel_edp_disable(): confirmed `.disable` field
  triggers msleep() in disable path
- [Phase 6] Verified code exists in 7.0 tree but NOT in 6.12.y or older
- [Phase 7] Douglas Anderson confirmed as active maintainer (10+ commits
  to this file)
- UNVERIFIED: Could not access lore.kernel.org to check for stable-
  specific discussion (blocked by Anubis)

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index c9eacfffd5b29..260fa18b0f78a 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1788,6 +1788,13 @@ static const struct panel_delay delay_200_500_e200 = {
 	.enable = 200,
 };
 
+static const struct panel_delay delay_200_500_e200_d100 = {
+	.hpd_absent = 200,
+	.unprepare = 500,
+	.enable = 200,
+	.disable = 100,
+};
+
 static const struct panel_delay delay_200_500_e200_d200 = {
 	.hpd_absent = 200,
 	.unprepare = 500,
@@ -1988,7 +1995,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0c93, &delay_200_500_e200, "Unknown"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cb6, &delay_200_500_e200, "NT116WHM-N44"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cf2, &delay_200_500_e200, "NV156FHM-N4S"),
-	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cf6, &delay_200_500_e200, "NV140WUM-N64"),
+	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cf6, &delay_200_500_e200_d100, "NV140WUM-N64"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0cfa, &delay_200_500_e50, "NV116WHM-A4D"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d45, &delay_200_500_e80, "NV116WHM-N4B"),
 	EDP_PANEL_ENTRY('B', 'O', 'E', 0x0d73, &delay_200_500_e80, "NE140WUM-N6S"),
-- 
2.53.0

