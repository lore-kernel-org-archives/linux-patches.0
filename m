Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F834C6EE1;
	Mon, 20 Apr 2026 13:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691982; cv=none; b=RkepwP5TFAIfg8uytGWGSD/ZAXdrwuv36g1GmE0PXsb2CtoeLWnq0L07gDXo9R8tAqisQQC/CQsA5OI0sFGmRCEvJPREVJWJaLg352hDI0R+GfN1Bd9RUkXK0ywptWIiykFkOMBhpXWp2j14BiiHF0X1tSchqhq5YtZm/21BL9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691982; c=relaxed/simple;
	bh=F25UWTVoXxyJ+BPRUSSCjj0W9ZCJy+A1CCOh8EOuGJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jLQQ2/ysa7uH/3hySPY8SGSAtPPVWlc/dUqz9z8ZQCWm+Gn72wxYaeLSUuoX8P5v6R6bR3OYDTyDovAl1PdyJVh/pqqXe4nGP7qQyvG6wnatZlFcRW0bci4bGAf3ggD6lGpRqTGRt/x6BSegvzw4j9DyPjK0zhdLs2kHO45p5Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D5vPuwyS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D5vPuwyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCA3C2BCB6;
	Mon, 20 Apr 2026 13:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691982;
	bh=F25UWTVoXxyJ+BPRUSSCjj0W9ZCJy+A1CCOh8EOuGJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5vPuwySqztejAkOXd/W4LgePXbgSavxL5Oo8xCeDV8bme//TYDn9bXCJ+sYyUQNN
	 tHXYr5H9U8zEWa4CM5gJiNXHIkQRuayMxAf0xGxamPY0Qd7j3/DjpsjzoT+3oND2Du
	 1FKnmtfAv7Ec8rYZ93ut5OA90xQLoaVf1b/kwLVH2X+vNYIZIJXbkCV3+Mwj6Hn7R3
	 m4vSUFMtPsXe+rCMqxS7d/QFErnNVuWtJa3S6Hn3d+TQp0rykzmGGkunzoiAELsUkb
	 IXr2oc49Zx6blkIASjrwfIwFDZZ0Zfc6MRyIDrrJ8p0oCofjluBWPABi5sj82zoBtG
	 JiEbMiYMfu2tw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Asad Kamal <asad.kamal@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu: Add default reset method for soc_v1_0
Date: Mon, 20 Apr 2026 09:21:38 -0400
Message-ID: <20260420132314.1023554-304-sashal@kernel.org>
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

From: Asad Kamal <asad.kamal@amd.com>

[ Upstream commit eb737fb303dd73ceb0f646fc2e696595e576056f ]

Add mode2 as default reset method for soc_v1_0

v2: Remove unnecessary overrides while selecting reset method (Lijo)
v4: Add dev_warn_once (Lijo)

Signed-off-by: Asad Kamal <asad.kamal@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the evidence I need. Let me compile my analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `drm/amdgpu`
- Action verb: "Add" (default reset method)
- Summary: Adds mode2 as the default reset method for soc_v1_0.
- Record: [drm/amdgpu] [Add] [Default reset method for soc_v1_0 -
  filling in a missing required callback]

**Step 1.2: Tags**
- Signed-off-by: Asad Kamal (author, AMD developer)
- Reviewed-by: Lijo Lazar (AMD engineer, specifically requested changes
  in v2 and v4)
- Signed-off-by: Alex Deucher (AMD GPU subsystem maintainer)
- No Fixes: tag (expected), no Cc: stable, no Reported-by, no Link.
- Record: Reviewed by AMD engineer, signed off by subsystem maintainer.
  No syzbot or bug reports.

**Step 1.3: Commit Body**
- The commit message is minimal: "Add mode2 as default reset method for
  soc_v1_0"
- v2: Removed unnecessary overrides (Lijo's suggestion)
- v4: Added dev_warn_once (Lijo's suggestion)
- No bug description, no stack trace, no reproduction steps.
- Record: The message describes feature completion but the underlying
  issue is that `soc_v1_0_asic_funcs` has a NULL `.reset_method`
  pointer.

**Step 1.4: Hidden Bug Fix Detection**
- This IS a hidden bug fix. The `amdgpu_asic_reset_method()` macro at
  `amdgpu.h:1454` dereferences `.reset_method` directly with NO null
  check. Without this patch, any call to
  `amdgpu_asic_reset_method(adev)` on soc_v1_0 hardware dereferences a
  NULL function pointer, causing a kernel oops.
- Record: YES, this is a hidden bug fix - fixes NULL pointer dereference
  of missing `.reset_method` callback.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Single file: `drivers/gpu/drm/amd/amdgpu/soc_v1_0.c`
- +24 lines added, 0 removed
- Functions modified: `soc_v1_0_asic_reset` (filled in stub),
  `soc_v1_0_asic_funcs` (added callback)
- Functions added: `soc_v1_0_asic_reset_method` (new function)
- Record: Single-file, +24 lines, surgical fix

**Step 2.2: Code Flow Change**
- BEFORE: `soc_v1_0_asic_reset` was a stub returning 0 (no-op).
  `.reset_method` was NULL in `soc_v1_0_asic_funcs`.
- AFTER: `soc_v1_0_asic_reset_method` selects Mode2 reset for specific
  hardware configs, or returns the module param default.
  `soc_v1_0_asic_reset` dispatches based on the selected method.
  `.reset_method` callback is populated.

**Step 2.3: Bug Mechanism**
- Category: NULL pointer dereference + missing functionality
- The `amdgpu_asic_reset_method` macro (amdgpu.h:1454) calls
  `(adev)->asic_funcs->reset_method((adev))` without NULL check.
  Multiple callers in `amdgpu_device.c` and `amdgpu_reset.c` invoke this
  during GPU reset paths. Without `.reset_method` set, this is a NULL
  deref crash.
- Record: NULL pointer dereference in GPU reset path. All other SoC
  variants (si, cik, vi, soc15, soc21, soc24, nv) set `.reset_method` —
  soc_v1_0 was the only one missing it.

**Step 2.4: Fix Quality**
- Obviously correct — follows exact same pattern as soc24, soc21, soc15,
  etc.
- Minimal and surgical
- Low regression risk — only affects soc_v1_0 hardware
- Minor dead code: `return 0;` after the switch in `soc_v1_0_asic_reset`
  is unreachable (both cases return), but harmless.
- Record: High quality fix, follows established patterns, low regression
  risk.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- The buggy code (stub `soc_v1_0_asic_reset` and missing
  `.reset_method`) was introduced in commit `297b0cebbcc3a`
  ("drm/amdgpu: Add soc v1_0 support") by Hawking Zhang on 2025-12-08.
  The original commit even noted "reset placeholders" in its changelog
  (v3).
- Record: Bug introduced in 297b0cebbcc3a, v7.0-rc1. Explicitly noted as
  "placeholder" in original commit.

**Step 3.2: No Fixes: tag to follow.**

**Step 3.3: File History**
- 11 commits touch soc_v1_0.c, all building out the new soc_v1_0 driver.
  No intermediate fix for the reset method issue.
- Record: Standalone fix. No prerequisites needed beyond the initial
  soc_v1_0 support.

**Step 3.4: Author**
- Asad Kamal is an AMD developer with multiple commits in the PM and GPU
  subsystem.
- Alex Deucher (AMD GPU maintainer) signed off and submitted the patch
  series.
- Record: Author is AMD developer, maintainer signed off.

**Step 3.5: Dependencies**
- The companion patch "Disable reset on init for soc_v1_0" starts from
  this commit's output hash (bd7043729e6a3), so it depends on this
  patch. This patch does NOT depend on any other uncommitted patches.
- Record: This patch is standalone and applies independently. A
  companion patch depends on it.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Patch Discussion**
- Found on spinics: `https://www.spinics.net/lists/amd-
  gfx/msg138861.html`
- Part of a series of soc_v1_0 fixes posted by Alex Deucher on
  2026-03-06
- The series includes ~12 related patches for soc_v1_0 and related
  hardware
- Patch went through v1 → v2 (removed unnecessary overrides) → v4 (added
  dev_warn_once)
- No explicit stable nomination in the discussion
- Record: Found submission thread. Multi-revision patch, review-driven
  improvements. No NAKs.

**Step 4.2: Reviewers**
- Reviewed-by: Lijo Lazar (AMD engineer who provided specific feedback
  driving v2 and v4 changes)
- Signed-off-by: Alex Deucher (subsystem maintainer)
- Record: Properly reviewed by AMD engineers.

**Step 4.3: Bug Report**
- No formal bug report or syzbot report. This is a proactive fix for
  missing functionality that would crash on GPU reset.
- Record: No bug report; proactive fix for obviously broken code.

**Step 4.4: Related Patches**
- Companion patch "Disable reset on init for soc_v1_0" removes the
  always-true `need_reset_on_init` logic. This is NOT in the 7.0 tree
  yet.
- Record: Companion patch exists but this commit is standalone.

**Step 4.5: Stable Discussion**
- No stable-specific discussion found.
- Record: No stable discussion.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: Functions**
- New: `soc_v1_0_asic_reset_method`
- Modified: `soc_v1_0_asic_reset`, `soc_v1_0_asic_funcs`

**Step 5.2: Callers**
- `amdgpu_asic_reset_method(adev)` is called from:
  - `amdgpu_device.c:3216` — `amdgpu_device_check_vram_lost()` (during
    reset)
  - `amdgpu_device.c:4179` — `amdgpu_device_xgmi_reset_work()` (XGMI
    reset)
  - `amdgpu_device.c:6114` — `amdgpu_device_set_mp1_state()` (during
    reset)
  - `amdgpu_device.c:6158` — `amdgpu_device_suspend_display_audio()`
    (during reset)
  - `amdgpu_reset.c:113` — XGMI reset path
  - `amdgpu_ras.c:4885` — RAS error handling
- These are all common GPU reset/recovery code paths.
- Record: The NULL `.reset_method` is dereferenced from multiple common
  code paths during GPU hang recovery.

**Step 5.3-5.5: Call Chain / Similar Patterns**
- Every other SoC variant (si, cik, vi, nv, soc15, soc21, soc24) has
  `.reset_method` populated. soc_v1_0 was the only one missing it.
- Record: Systematic omission — soc_v1_0 was incomplete compared to all
  sibling drivers.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Buggy Code Existence**
- soc_v1_0.c was introduced in v7.0-rc1 (commit 297b0cebbcc3a). It
  exists in v7.0.
- Only relevant for 7.0.y stable tree.
- Record: Bug exists in 7.0.y only.

**Step 6.2: Backport Complications**
- The diff applies against the base hash `26e7566a5479c`, which is the
  current state in v7.0. Should apply cleanly.
- Record: Clean apply expected for 7.0.y.

**Step 6.3: Related Fixes in Stable**
- No related fixes found in stable.
- Record: None.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1: Subsystem**
- `drivers/gpu/drm/amd/amdgpu` — AMD GPU driver
- Criticality: IMPORTANT — affects users of AMD GPUs with GC 12.1
  hardware
- Record: GPU driver, IMPORTANT criticality.

**Step 7.2: Activity**
- Very active subsystem — 40 changes between v7.0-rc1 and v7.0 in amdgpu
  alone.
- Record: Highly active, new hardware being brought up.

## PHASE 8: IMPACT AND RISK

**Step 8.1: Affected Users**
- Users with soc_v1_0 (GC 12.1) AMD GPU hardware running kernel 7.0.y
- Record: Driver-specific, but for current-gen AMD hardware.

**Step 8.2: Trigger Conditions**
- Any GPU hang or error that triggers the GPU reset recovery path will
  hit the NULL deref.
- GPU hangs can happen during normal operation (driver bugs, power
  management issues, etc.)
- Record: Triggered by GPU reset, which can happen during normal GPU
  usage.

**Step 8.3: Failure Mode**
- NULL pointer dereference → kernel oops/panic
- Severity: CRITICAL
- Record: Kernel crash during GPU reset recovery.

**Step 8.4: Risk-Benefit**
- BENEFIT: HIGH — prevents kernel crash on GPU reset for soc_v1_0
  hardware
- RISK: LOW — 24 lines in a single file, follows exact pattern of all
  sibling SoC variants, only affects soc_v1_0 hardware
- Record: High benefit, low risk.

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Fixes NULL pointer dereference (kernel crash) — CRITICAL severity
- Small, contained (24 lines, single file)
- Follows exact pattern of all other SoC variants (si, cik, vi, nv,
  soc15, soc21, soc24)
- Reviewed by AMD engineer, signed off by AMD GPU subsystem maintainer
- The bug is in code shipped in v7.0; users with this hardware will hit
  it on any GPU hang
- Standalone patch, no dependencies

AGAINST backporting:
- No explicit Cc: stable or Fixes: tag (expected — that's why it's being
  reviewed)
- Could be seen as "feature completion" rather than "bug fix"
- Very new code (soc_v1_0 only in v7.0)
- No reported user impact yet (hardware may be very new)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — follows identical pattern in 7
   other SoC variants, reviewed by AMD
2. Fixes a real bug? YES — NULL pointer dereference on GPU reset
3. Important issue? YES — kernel crash (CRITICAL)
4. Small and contained? YES — 24 lines, single file
5. No new features? BORDERLINE — adds required callback, but the
   functionality is not "new" (all other variants have it)
6. Can apply to stable? YES — applies cleanly to 7.0.y

**Step 9.3: Exception Categories**
- Not a standard exception category, but fixes a crash in new hardware
  support that shipped in v7.0.

**Step 9.4: Decision**
The missing `.reset_method` callback in `soc_v1_0_asic_funcs` causes a
NULL pointer dereference whenever GPU reset is triggered on this
hardware. This is a CRITICAL crash bug. The fix is 24 lines, self-
contained, follows established patterns from all other AMD GPU SoC
variants, and was reviewed by AMD engineers including the subsystem
maintainer. While it could be characterized as "completing" the driver,
the practical effect is fixing a kernel crash.

## Verification

- [Phase 1] Parsed tags: Reviewed-by: Lijo Lazar, Signed-off-by: Alex
  Deucher (maintainer). No syzbot/Fixes/Cc:stable.
- [Phase 2] Diff analysis: +24 lines in soc_v1_0.c. Adds
  `soc_v1_0_asic_reset_method` function, fills in `soc_v1_0_asic_reset`
  stub, populates `.reset_method` in asic_funcs.
- [Phase 2] Verified: `amdgpu_asic_reset_method` macro at amdgpu.h:1454
  dereferences `.reset_method` with NO null check.
- [Phase 2] Verified: All other SoC variants (si, cik, vi, nv, soc15,
  soc21, soc24) have `.reset_method` set. soc_v1_0 is the only one
  missing it.
- [Phase 3] git blame: buggy stub introduced in commit 297b0cebbcc3a
  (2025-12-08), present since v7.0-rc1. Original commit described it as
  "reset placeholders."
- [Phase 3] git tag: 297b0cebbcc3a is contained in v7.0-rc1, v7.0.
- [Phase 3] git log: 11 commits touch soc_v1_0.c, none fix the reset
  method issue.
- [Phase 4] Found original submission: spinics.net/lists/amd-
  gfx/msg138861.html — part of series by Alex Deucher on 2026-03-06
- [Phase 4] Patch evolved v1→v2→v4, review-driven improvements, no NAKs
- [Phase 4] Companion patch "Disable reset on init for soc_v1_0" exists
  and depends on this commit
- [Phase 5] Verified callers: `amdgpu_asic_reset_method()` called from
  amdgpu_device.c:3216, 4179, 6114, 6158 and amdgpu_reset.c:113 — all
  GPU reset code paths
- [Phase 6] Code exists only in v7.0 (soc_v1_0 introduced in v7.0-rc1)
- [Phase 8] Failure mode: NULL deref → kernel oops on GPU reset,
  severity CRITICAL
- UNVERIFIED: Whether any users have actually triggered this crash
  (hardware is very new)

**YES**

 drivers/gpu/drm/amd/amdgpu/soc_v1_0.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c b/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
index 59ab952d5cce4..ca66a0169c781 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc_v1_0.c
@@ -229,8 +229,31 @@ static bool soc_v1_0_need_reset_on_init(struct amdgpu_device *adev)
 	return false;
 }
 
+static enum amd_reset_method
+soc_v1_0_asic_reset_method(struct amdgpu_device *adev)
+{
+	if ((adev->gmc.xgmi.supported && adev->gmc.xgmi.connected_to_cpu) ||
+	    (amdgpu_ip_version(adev, MP1_HWIP, 0) == IP_VERSION(15, 0, 8))) {
+		if (amdgpu_reset_method != -1)
+			dev_warn_once(adev->dev, "Reset override isn't supported, using Mode2 instead.\n");
+
+		return AMD_RESET_METHOD_MODE2;
+	}
+
+	return amdgpu_reset_method;
+}
+
 static int soc_v1_0_asic_reset(struct amdgpu_device *adev)
 {
+	switch (soc_v1_0_asic_reset_method(adev)) {
+	case AMD_RESET_METHOD_MODE2:
+		dev_info(adev->dev, "MODE2 reset\n");
+		return amdgpu_dpm_mode2_reset(adev);
+	default:
+		dev_info(adev->dev, "Invalid reset method Not supported\n");
+		return -EOPNOTSUPP;
+	}
+
 	return 0;
 }
 
@@ -244,6 +267,7 @@ static const struct amdgpu_asic_funcs soc_v1_0_asic_funcs = {
 	.need_reset_on_init = &soc_v1_0_need_reset_on_init,
 	.encode_ext_smn_addressing = &soc_v1_0_encode_ext_smn_addressing,
 	.reset = soc_v1_0_asic_reset,
+	.reset_method = &soc_v1_0_asic_reset_method,
 };
 
 static int soc_v1_0_common_early_init(struct amdgpu_ip_block *ip_block)
-- 
2.53.0

