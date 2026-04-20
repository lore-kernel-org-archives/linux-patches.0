Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20EB3AEF52;
	Mon, 20 Apr 2026 13:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776692016; cv=none; b=ZnmUl+S3w3UBsiUC9a4eUSfwTEPZKqBLwDKVQLgZEqKIdhxzpdr9ZjkKb+4/WEDwWculprJC+TMHGg4i142qgSIam1qmYxjQsypOcGbG52ZCOj7KzX82dqAftyJFCK57uZIguoJ0KC1kdsyGLDuEah0z1/99hka7QoOSjEwP9kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776692016; c=relaxed/simple;
	bh=s4M4waw6ZN/1VibM+5jzihcPF2zsR7PUNpdnLQZ6PxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r0nqI5wBgmBe9850VuMXV1RP9zehK6k3l8l8voxKfeZG6aFCkTLO5kHghxUCr7S/SwvjuDD3AawGXGe9/bz9cyMmHP1KjVXBO5q0dgjM/SXNWkZJqUMxUqqHfH6fE8XwzMQoduCAHCjxrPpuTUjJ6Y4xEvYiEeDJJtxImv0cqSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Erj3yWPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Erj3yWPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E69C2BCB9;
	Mon, 20 Apr 2026 13:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776692015;
	bh=s4M4waw6ZN/1VibM+5jzihcPF2zsR7PUNpdnLQZ6PxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Erj3yWPC6OLSA+3LLb2iJYlwhkDpZd4mnBESbKiuYuZBAB3YEcPou0gcEy9deN5G1
	 Gm+zSG8YZBSZjm6ND9OooOL0fpPA/BpSz+llmj3xY8Gov/tioJDGJRQaQ0oTbCvEBM
	 529OYkSUA8rJXhNCJfM9paCJO5uvglPIss9+fAu6kIz0y1eMBs9dCg+9LJMGSY2I3/
	 /eiXJVMgjSSXlI8a/QjfcZFds8jh5CK3CeMAG+hI7Dm/E/0xAxc/a+DF8ipDMFgB3o
	 BKel16r690aht2PLoHVojlMd9YmAVpeAeQWVOF+StE8kbwJXZ9TkATgDSV2hTK9gGQ
	 M2HiOrGLCdeVw==
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
Subject: [PATCH AUTOSEL 7.0-6.18] drm/panel-edp: Add AUO B116XAT04.1 (HW: 1A)
Date: Mon, 20 Apr 2026 09:21:57 -0400
Message-ID: <20260420132314.1023554-323-sashal@kernel.org>
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

From: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>

[ Upstream commit 2cb217301e0df17f7107a1b0941b28d4053eae8b ]

Add support for the AUO - B116XAT04.1 (HW: 1A) panel.
This panel is used on MT8186 Chromebooks

The raw EDID:
00 ff ff ff ff ff ff 00 06 af ba 89 00 00 00 00
0c 23 01 04 95 1a 0e 78 02 9e a5 96 59 58 96 28
1b 50 54 00 00 00 01 01 01 01 01 01 01 01 01 01
01 01 01 01 01 01 ce 1d 56 ea 50 00 1a 30 30 20
46 00 00 90 10 00 00 18 df 13 56 ea 50 00 1a 30
30 20 46 00 00 90 10 00 00 18 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02
00 10 48 ff 0f 3c 7d 0c 0a 2a 7d 20 20 20 00 21

Signed-off-by: Terry Hsiao <terry_hsiao@compal.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patch.msgid.link/20260122032904.3933-1-terry_hsiao@compal.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a thorough analysis. Let me walk
through all phases.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `drm/panel-edp`
- **Action verb**: "Add" — adding a new panel ID entry
- **Summary**: Adds EDID product ID 0x89ba for the AUO B116XAT04.1 (HW
  revision 1A) panel used on MT8186 Chromebooks.

Record: [drm/panel-edp] [Add] [New EDID product ID for existing panel
model, different HW revision]

### Step 1.2: Tags
- **Signed-off-by**: Terry Hsiao (author, Compal/Google partner) and
  Douglas Anderson (subsystem maintainer)
- **Reviewed-by**: Douglas Anderson (subsystem maintainer for Chromebook
  panel-edp)
- **Link**: patch.msgid.link URL (lore.kernel.org blocked by Anubis)
- No Fixes: tag (expected — this is a device ID addition, not a
  traditional bug fix)
- No Reported-by (expected — hardware enablement, not a bug report)
- No Cc: stable (expected — that's why it's under review)

Record: Reviewed and committed by subsystem maintainer Douglas Anderson.
Author is a regular contributor (same author as prior 6-panel batch
commit d4b9b6da5777b).

### Step 1.3: Commit Body
The body provides the raw EDID hex dump for the panel. The EDID shows
manufacturer AUO, product ID 0x89ba. The panel is used on MT8186
Chromebooks. Without this entry, the panel-edp driver cannot match this
specific panel by its EDID, meaning the panel won't be properly
initialized.

Record: [Hardware enablement for Chromebook panel] [Without this, panel
won't be recognized] [MT8186 platform]

### Step 1.4: Hidden Bug Fix Detection
This is not a disguised bug fix — it's an explicit device ID addition.
However, missing panel entries cause real user impact: the display won't
work properly on affected Chromebooks.

Record: [Not a hidden bug fix; straightforward device ID addition with
real user impact]

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Change Inventory
- **Files changed**: 1 (`drivers/gpu/drm/panel/panel-edp.c`)
- **Lines added**: 1
- **Lines removed**: 0
- **Functions modified**: None (only the `edp_panels[]` static data
  table)
- **Scope**: Single-line addition to a data table

Record: [1 file, +1 line, no function logic changes, minimal scope]

### Step 2.2: Code Flow Change
The single added line:
```c
EDP_PANEL_ENTRY('A', 'U', 'O', 0x89ba, &delay_200_500_e50,
"B116XAT04.1"),
```
Inserted in sorted order (between 0x8594 and 0x8bba) into the
`edp_panels[]` table. This uses the standard `EDP_PANEL_ENTRY` macro
with the well-established `delay_200_500_e50` timing struct (used by 80+
other panels).

Record: [Before: panel ID 0x89ba not recognized. After: panel matched
and properly initialized with standard timing]

### Step 2.3: Bug Mechanism
Category: **Hardware enablement / Device ID addition**. Not a bug fix
per se, but enables hardware that doesn't work without it.

Record: [Device ID addition. Existing entry 0xc4b4 covers one HW
revision; this adds HW revision 1A with EDID 0x89ba]

### Step 2.4: Fix Quality
- Obviously correct: single-line table entry using the same macro and
  timing parameters as ~80 other AUO panels
- Minimal/surgical: 1 line
- Regression risk: effectively zero — only affects panels with EDID
  product ID 0x89ba
- Reviewed by the subsystem maintainer

Record: [Obviously correct, minimal, zero regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The surrounding entries in the table come from various commits dating
back to 2022 (d049a24b15d8c1, March 2022) through 2025. The `panel-
edp.c` file and `edp_panels[]` table have existed since at least kernel
5.18.

Record: [Panel table infrastructure has been in the kernel since at
least v5.18; file is stable and well-established]

### Step 3.2: No Fixes Tag
Not applicable — this is a device ID addition, not a bug fix referencing
an introduced regression.

### Step 3.3: File History
The file sees frequent panel ID additions. The last 20 commits are
almost all panel additions by various authors, showing this is a
standard, routine operation.

Record: [Extremely active file for panel additions; this is a routine
operation]

### Step 3.4: Author History
Terry Hsiao has at least 2 commits in this file: the earlier 6-panel
batch (d4b9b6da5777b, July 2024) and a name fix (21e97d3ca814e). This is
a regular contributor who works on Chromebook panel enablement.

Record: [Author is a repeat contributor to this file, working on
Chromebook panel support]

### Step 3.5: Dependencies
None. The `EDP_PANEL_ENTRY` macro and `delay_200_500_e50` struct exist
in all stable trees that have `panel-edp.c`. This is a self-contained,
standalone one-line addition.

Record: [No dependencies. Fully standalone.]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1–4.5: Mailing List
The lore.kernel.org site is blocked by Anubis anti-bot protection.
However, we know:
- The patch was submitted by Terry Hsiao on 2026-01-22
- It was reviewed by Douglas Anderson (the panel-edp subsystem
  maintainer)
- Douglas Anderson also committed it (Signed-off-by)
- The patch link is
  `patch.msgid.link/20260122032904.3933-1-terry_hsiao@...`

Record: [Could not fetch lore discussion due to Anubis protection.
Reviewed and committed by subsystem maintainer Douglas Anderson.]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1–5.5: Function Analysis
No functions are modified. The change is purely data — a new entry in
the static `edp_panels[]` table. This table is searched by the panel-edp
driver's probe path to match panels by EDID product ID. When a match is
found, the corresponding timing delays are applied.

The `EDP_PANEL_ENTRY` macro is used 196 times in this file. The
`delay_200_500_e50` timing struct is used by 80+ entries. This is
entirely routine.

Record: [Data-only change to a well-established lookup table. No logic
changes.]

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The `panel-edp.c` file exists in stable trees including 6.6.y (confirmed
via `git log v6.6..v6.6.80`). The `EDP_PANEL_ENTRY` macro and
`delay_200_500_e50` struct exist in all active stable trees.

Record: [File and infrastructure exist in 6.6.y and all newer stable
trees]

### Step 6.2: Backport Complications
This is a one-line addition to a sorted table. It will apply cleanly to
any stable tree that has the surrounding entries. Minor context
adjustment might be needed if nearby entries differ, but the table is
insertion-order agnostic for functionality.

Record: [Expected clean apply or trivial context adjustment]

### Step 6.3: Related Fixes Already in Stable
The earlier entry for the same panel (0xc4b4) from commit d4b9b6da5777b
may or may not be in stable trees. Even if it isn't, this entry stands
alone — it matches a different EDID product ID.

Record: [No related fixes needed; this is independent]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: `drm/panel` — Display panel drivers
- **Criticality**: IMPORTANT — panels are essential for display output.
  This specifically affects Chromebooks (MT8186 platform), which are
  widely deployed devices.

Record: [drm/panel, IMPORTANT criticality, Chromebook platform]

### Step 7.2: Activity Level
Very active — 20+ recent commits are all panel additions. This is a
well-maintained, high-traffic area.

Record: [Highly active subsystem]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is Affected
Users of MT8186 Chromebooks with the AUO B116XAT04.1 (HW: 1A) panel.
Without this entry, the display panel won't be properly initialized,
meaning the screen won't work correctly.

Record: [Users of specific Chromebook hardware]

### Step 8.2: Trigger Conditions
Triggered at boot time during panel probe. Every boot on affected
hardware.

Record: [Every boot on affected Chromebook models. 100% reproducible.]

### Step 8.3: Failure Mode Severity
Without the panel entry: the display may not initialize properly or may
fall back to a generic mode with incorrect timing. This is a hardware
enablement issue.

Record: [Display malfunction on affected hardware. Severity: HIGH for
affected users.]

### Step 8.4: Risk-Benefit Ratio
- **BENEFIT**: Enables display on Chromebooks with this specific panel
  revision. HIGH for affected users.
- **RISK**: Effectively zero. One-line data table addition using
  existing macros/timing. Cannot affect any other hardware.
- **Ratio**: Extremely favorable.

Record: [High benefit, near-zero risk]

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Classic device ID addition to existing driver (explicit exception
  category)
- Single line added, zero regression risk
- Uses well-established macro and timing parameters (80+ other panels
  use same timing)
- Reviewed and committed by subsystem maintainer (Douglas Anderson)
- Enables real hardware (MT8186 Chromebooks) for real users
- No dependencies on other patches
- Will apply cleanly to stable trees

**AGAINST backporting:**
- No evidence against. This is as clean as a backport candidate gets.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — single table entry, reviewed
   by maintainer
2. Fixes a real bug? **YES** — enables hardware that doesn't work
   without it
3. Important issue? **YES** — display doesn't work on affected
   Chromebooks
4. Small and contained? **YES** — 1 line
5. No new features or APIs? **YES** — only a data table entry
6. Can apply to stable trees? **YES** — trivially

### Step 9.3: Exception Category
**Device ID addition to existing driver** — this is explicitly listed as
a common exception that is almost always YES for stable.

### Step 9.4: Decision
This is a textbook device ID addition — one line, zero risk, real
hardware enablement, reviewed by the subsystem maintainer.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by and Signed-off-by from Douglas
  Anderson (subsystem maintainer)
- [Phase 2] Diff analysis: 1 line added to `edp_panels[]` table using
  `EDP_PANEL_ENTRY` macro with `delay_200_500_e50`
- [Phase 2] Verified `delay_200_500_e50` is used by 80+ entries;
  `EDP_PANEL_ENTRY` used 196 times
- [Phase 3] git blame: surrounding table entries date from 2022–2025,
  stable infrastructure
- [Phase 3] git log --author: Terry Hsiao has 2 prior commits in this
  file (d4b9b6da5777b, 21e97d3ca814e)
- [Phase 3] Existing entry for same panel model (0xc4b4) exists at line
  1922, from commit d4b9b6da5777b
- [Phase 4] b4 dig on related commit d4b9b6da5777b: found lore thread,
  confirms same author pattern
- [Phase 4] UNVERIFIED: Could not read lore discussion for this specific
  commit due to Anubis protection
- [Phase 5] Data-only change, no function logic modified
- [Phase 6] File confirmed present in 6.6.y stable tree (6 commits found
  in v6.6..v6.6.80 range)
- [Phase 6] `EDP_PANEL_ENTRY` macro exists at line 1859,
  `delay_200_500_e50` widely used — both in stable
- [Phase 8] Failure mode: display not recognized on MT8186 Chromebooks;
  severity HIGH for affected users
- [Phase 8] Risk: near-zero (data table entry, only matches specific
  EDID 0x89ba)

**YES**

 drivers/gpu/drm/panel/panel-edp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-edp.c b/drivers/gpu/drm/panel/panel-edp.c
index 679f4af5246d8..108569490ed59 100644
--- a/drivers/gpu/drm/panel/panel-edp.c
+++ b/drivers/gpu/drm/panel/panel-edp.c
@@ -1915,6 +1915,7 @@ static const struct edp_panel_entry edp_panels[] = {
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x723c, &delay_200_500_e50, "B140XTN07.2"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x73aa, &delay_200_500_e50, "B116XTN02.3"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8594, &delay_200_500_e50, "B133UAN01.0"),
+	EDP_PANEL_ENTRY('A', 'U', 'O', 0x89ba, &delay_200_500_e50, "B116XAT04.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0x8bba, &delay_200_500_e50, "B140UAN08.5"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xa199, &delay_200_500_e50, "B116XAN06.1"),
 	EDP_PANEL_ENTRY('A', 'U', 'O', 0xa7b3, &delay_200_500_e50, "B140UAN04.4"),
-- 
2.53.0

