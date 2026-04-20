Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D303FADF1;
	Mon, 20 Apr 2026 13:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691574; cv=none; b=T6IitUxOnw+YmEP/iBDOvoL2/XEAYFzeJ91G+7DWszd5kIQK+Fzre1vedoRwZLPtEu4ZEXHsiXgyFOKQd5nhIXw/aRJvX9GKZJ6W7UbvdC+B3W9ADdE3oJtP1MB1lrXUUAR+kPSUI2U3alSdpBHwPrr/SyeX/SlxYqFhoKpfGkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691574; c=relaxed/simple;
	bh=1FfShN0lxD5kueaKBwoKCRafm8VIHXcVBgIjBXL4Jjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyDt+zn3lOVDP7UEvJtxofOWgbYvyOzGhwNUidiAlI06G8WPiUr9QmK1y7oHuKZgS5em0Q3tgZVfB3gu08EQkVzgYp80j2e0YNPunrc90g8IMdO2rUqQMyaWQF6uxbswJyqmb6wLIpO5GdfeDmc2vjNJ0WmSLPV+LfbPm4YeHFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDAmuY1f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDAmuY1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7274CC2BCB8;
	Mon, 20 Apr 2026 13:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691574;
	bh=1FfShN0lxD5kueaKBwoKCRafm8VIHXcVBgIjBXL4Jjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDAmuY1f+I7bqbKRmiRleAthjT9Vc7avLT+kIuH+WEs7zq6HdQiP2v3pu3ITsou7C
	 wbtYZRZjuCjF/NFxF7YxpnRxl/ATM/JCiiIewR0y6X/Ub8OyCk4dOcY4XyaV5ebC8K
	 Z1wkvmj0oJJ3gg+1Wmca2txtns5PrdycR9prnBVvGO8RmTCe2SKSVww1zsYucvB5UR
	 imJv7Lf1DOaUVXTRh037LFx9eIVg2f96RNmJY+RyNmUP+UiebnHuCuBruMpJyhGLoT
	 BxS1dd9LkWLs+pK1L9BA9OAFvFjSQ/ngzZqBEKw8RXC4VbL4CjAdBsGghrl56pxRTc
	 be8VY1T/okg7A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jesse Zhang <Jesse.Zhang@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Jesse Zhang <Jesse.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] drm/amdgpu/vcn4.0.3: gate per-queue reset by PSP SOS program version
Date: Mon, 20 Apr 2026 09:18:23 -0400
Message-ID: <20260420132314.1023554-109-sashal@kernel.org>
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

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit 16df395a55c635649dd3cf41d61bd685d3fd7a98 ]

Add a PSP SOS firmware compatibility check before enabling VCN per-queue
reset on vcn_v4_0_3.

Per review, program check is sufficient: when PSP SOS program is 0x01,
require fw version >= 0x0036015f; otherwise allow per-queue reset.

Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Jesse Zhang <Jesse.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a complete analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem prefix: `drm/amdgpu/vcn4.0.3`
- Action verb: "gate" (restrict/conditionally enable)
- Summary: Gate VCN per-queue reset feature behind a PSP SOS firmware
  version check.

Record: [drm/amdgpu/vcn4.0.3] [gate] [Add firmware compatibility check
before enabling per-queue reset]

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>` - AMD GPU firmware/IP
  maintainer
- `Suggested-by: Lijo Lazar <lijo.lazar@amd.com>` - The approach was
  suggested by the reviewer
- `Signed-off-by: Jesse Zhang <Jesse.zhang@amd.com>` - Author
- `Signed-off-by: Alex Deucher <alexander.deucher@amd.com>` - AMD DRM
  subsystem maintainer
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable tag (expected)
- No Reported-by tag

Record: Reviewed and suggested by Lijo Lazar (AMD), committed by Alex
Deucher (subsystem maintainer). No explicit bug reporter or syzbot
involvement.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
The commit explains that PSP SOS firmware compatibility must be checked
before enabling VCN per-queue reset. Specifically: when PSP SOS program
is 0x01, firmware version must be >= 0x0036015f. Otherwise (other
programs), per-queue reset is allowed. This prevents enabling a reset
path that the firmware doesn't support.

Record: Bug: per-queue reset enabled without firmware version gating,
leading to attempted resets on firmware that doesn't support it.
Symptom: failed per-queue resets that fall back to full GPU reset. Root
cause: missing firmware capability check.

**Step 1.4: DETECT HIDDEN BUG FIXES**
This is a firmware compatibility fix. "Gate" means "restrict to
compatible configurations." Without it, per-queue reset is attempted on
incompatible firmware, which fails. This is a real bug fix - enabling a
feature on hardware/firmware that doesn't support it.

Record: Yes, this is a real bug fix - it prevents incorrect feature
enablement on incompatible firmware.

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c` (+18, -1)
- New function: `vcn_v4_0_3_is_psp_fw_reset_supported()` (15 lines)
- Modified function: `vcn_v4_0_3_late_init()` (1 line condition change)
- Scope: Single-file surgical fix

Record: 1 file changed, 18 insertions, 1 deletion. Functions: new
`vcn_v4_0_3_is_psp_fw_reset_supported()`, modified
`vcn_v4_0_3_late_init()`. Single-file surgical fix.

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
- **Before**: `vcn_v4_0_3_late_init()` checks
  `amdgpu_dpm_reset_vcn_is_supported(adev) && !amdgpu_sriov_vf(adev)` to
  enable per-queue reset. No firmware version check.
- **After**: Same check, but now also calls
  `vcn_v4_0_3_is_psp_fw_reset_supported(adev)` which extracts the PSP
  program version from firmware version field and requires version >=
  0x0036015f for program 0x01.
- This is an initialization-time check; it only runs once during
  `late_init`.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: (h) Hardware workaround / firmware compatibility fix.
The new function extracts `pgm = (fw_ver >> 8) & 0xFF` and for program
1, requires `fw_ver >= 0x0036015f`. This follows the exact same pattern
as `vcn_v5_0_1` which checks `adev->psp.sos.fw_version >= 0x00450025`.

Without this check, `AMDGPU_RESET_TYPE_PER_QUEUE` is set on systems
where PSP firmware can't handle it. When a VCN timeout occurs,
`amdgpu_job_timedout()` -> `amdgpu_ring_reset()` ->
`vcn_v4_0_3_ring_reset()` -> `amdgpu_dpm_reset_vcn()` is called. If PSP
can't handle it, the reset fails, the driver logs "VCN reset fail" and
falls through to a full GPU reset.

Record: Firmware compatibility fix. Missing version check causes per-
queue reset to be attempted on incompatible firmware, leading to reset
failures and unnecessary full GPU resets.

**Step 2.4: ASSESS THE FIX QUALITY**
- Obviously correct: simple version comparison
- Minimal and surgical: 18 lines, single file, follows established
  pattern from vcn_v5_0_1
- Regression risk: extremely low. Worst case: per-queue reset disabled
  when it should be enabled (fallback to full GPU reset, which was the
  old behavior anyway)
- No API changes, no lock changes, no data structure changes

Record: Fix quality: excellent. Follows established pattern. Regression
risk: very low.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- `vcn_v4_0_3_late_init()` was introduced by commit 655d6403ad143 (Jesse
  Zhang, 2025-08-13), first in v6.18-rc1
- The `!amdgpu_sriov_vf(adev)` condition was added by c156c7f27ecdb
  (Shikang Fan, 2025-11-19), also in v6.18

Record: Buggy code (missing firmware check) was introduced in v6.18-rc1
with commit 655d6403ad143.

**Step 3.2: FOLLOW THE FIXES TAG**
No Fixes: tag present. This is expected for autosel candidates.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Between the late_init introduction (655d6403ad143) and this fix, the
file has had several changes including rework of reset handling
(d25c67fd9d6fe), DPG pause mode handling (de93bc353361f), and JPEG ring
test ordering fix (91544c45fa6a1). The fix applies cleanly on top of the
current state with the sriov check.

Record: The fix is standalone, no prerequisites beyond the existing
late_init function (which is already in the tree).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Jesse Zhang is a regular AMD GPU driver contributor with many commits in
the amdgpu subsystem, including the original late_init callback, SDMA
fixes, and queue reset work.

Record: Author is a regular AMD driver contributor, familiar with the
subsystem.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
The fix depends only on `vcn_v4_0_3_late_init()` existing (commit
655d6403ad143) and access to `adev->psp.sos.fw_version`. Both exist in
the current tree. The fix is self-contained.

Record: No additional dependencies. Applies standalone.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
b4 dig could not find the patch (possibly due to the AMD internal
submission process), but the mail-archive.com search found both V1 and
V2.

- V1: `[PATCH] drm/amdgpu/vcn4.0.3: gate VCN reset on PSP FW for MP0
  13.0.6` - included an IP version switch (13.0.6 specific)
- V2: `[PATCH V2] drm/amdgpu/vcn4.0.3: gate per-queue reset by PSP SOS
  program version` - simplified per Lijo's review feedback

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Lijo Lazar (AMD IP/firmware expert) reviewed both versions and gave
Reviewed-by on V2. He suggested the simplification (program check alone
is sufficient). Alex Deucher (AMD DRM subsystem maintainer) committed
it.

Record: Thoroughly reviewed by AMD maintainers. V1 was revised per
feedback.

**Step 4.3: SEARCH FOR THE BUG REPORT**
No explicit bug report link. The ticket reference FWDEV-159155 is an
AMD-internal tracker. Lijo noted in review that internal ticket
references shouldn't be in comments.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
This is a standalone single patch, not part of a series. VCN v5.0.1
already had the same pattern (firmware version gating) from commit
5886090032ec8.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Could not access lore.kernel.org directly due to bot protection. No
evidence of explicit stable nomination found in the mail-archive
discussion.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
- New: `vcn_v4_0_3_is_psp_fw_reset_supported()` - called only from
  `vcn_v4_0_3_late_init()`
- Modified: `vcn_v4_0_3_late_init()` - called during driver
  initialization

**Step 5.2: TRACE CALLERS**
`vcn_v4_0_3_late_init` is registered as the `.late_init` callback in the
IP function table. It's called once during device initialization by the
amdgpu IP block management code.

**Step 5.3-5.4: DOWNSTREAM IMPACT**
If `AMDGPU_RESET_TYPE_PER_QUEUE` is incorrectly set,
`amdgpu_job_timedout()` (amdgpu_job.c:134-155) will attempt per-queue
reset via `vcn_v4_0_3_ring_reset()` which calls
`amdgpu_dpm_reset_vcn()`. If firmware doesn't support it, this fails,
and the driver falls through to a full GPU reset - a much more
disruptive event that resets all GPU engines.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
VCN v5.0.1 already has the same firmware version gating pattern
(`vcn_v5_0_1_late_init`, line 125). GFX v11, v12, and SDMA v4.4.2 also
gate per-queue reset behind firmware version checks. This is a well-
established pattern.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

**Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?**
The `vcn_v4_0_3_late_init()` function (with per-queue reset enablement
but without firmware version check) was introduced in v6.18-rc1 (commit
655d6403ad143). It exists in stable trees 6.18.y and newer. The VCN per-
queue reset implementation itself was in v6.16+, but the late_init
enablement path is the specific code this fixes.

Record: Buggy code exists in 6.18.y and newer stable trees.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
The patch applies directly against the current state of `vcn_v4_0_3.c`.
For 6.18.y, the patch should apply cleanly as the `vcn_v4_0_3_late_init`
function with the same context lines exists there.

Record: Expected clean apply to 6.18.y+.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE**
No related firmware version check fix for vcn_v4_0_3 has been applied to
stable. The sriov check (c156c7f27ecdb) was cherry-picked to stable with
Cc: stable tag, but that's a different fix.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
- Subsystem: `drivers/gpu/drm/amd/amdgpu` - AMD GPU driver
- Criticality: IMPORTANT - AMD GPUs are widely used in servers (MI-
  series) and workstations

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Very actively developed. VCN v4.0.3 specifically is for data center GPUs
(Instinct series with multiple VCN instances).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Users with AMD GPUs that use VCN v4.0.3 (data center/MI-series GPUs)
running PSP SOS firmware program 0x01 with version < 0x0036015f.

Record: Driver-specific, but for important data center hardware.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Trigger: A VCN (video encode/decode) job times out, causing the
scheduler to attempt a per-queue reset. With incompatible firmware, the
per-queue reset fails, forcing a full GPU reset.

Record: Triggered by VCN job timeout (can happen during normal video
workloads). The per-queue reset attempt itself is the trigger for the
bug.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
- Without fix: Failed per-queue reset → full GPU reset (disrupts ALL GPU
  workloads, not just VCN)
- A full GPU reset on a data center GPU is highly disruptive
- Severity: HIGH (unnecessary disruptive full GPU reset instead of
  contained per-queue reset)

Record: Failure mode: unnecessary full GPU reset instead of graceful
fallback to non-per-queue behavior. Severity: HIGH for data center use.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- BENEFIT: Prevents failed per-queue resets and unnecessary full GPU
  resets on systems with older firmware
- RISK: Very low. 18 lines, single file, initialization-only code,
  follows established pattern. Worst case: per-queue reset incorrectly
  disabled → falls back to full GPU reset (same as not having per-queue
  reset at all, the previous behavior)

Record: High benefit, very low risk.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Fixes a real firmware compatibility bug (per-queue reset attempted on
  unsupported firmware)
- Small (18 lines), surgical, single-file change
- Follows established pattern from vcn_v5_0_1
- Reviewed by AMD maintainer Lijo Lazar, committed by subsystem
  maintainer Alex Deucher
- Went through V1→V2 revision with reviewer feedback
- Prevents unnecessary full GPU resets on data center hardware
- Very low regression risk
- Self-contained, no dependencies

AGAINST backporting:
- No explicit Cc: stable (expected for autosel)
- No Fixes: tag pointing to specific broken commit
- No user-reported bug (AMD internal tracking reference FWDEV-159155)
- Could be viewed as "hardening" rather than fixing a crash
- Relatively new code (v6.18+), limited stable tree exposure

UNRESOLVED:
- Could not access lore.kernel.org directly to check for stable-specific
  discussions
- Don't know how many users have the specific old firmware configuration

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **Yes** - simple version comparison,
   reviewed by AMD maintainer
2. Fixes a real bug? **Yes** - prevents failed per-queue resets with
   incompatible firmware
3. Important issue? **Yes** - prevents unnecessary full GPU resets (HIGH
   severity for data center)
4. Small and contained? **Yes** - 18 lines, 1 file
5. No new features or APIs? **Correct** - gates an existing feature
6. Can apply to stable trees? **Yes** - should apply cleanly to 6.18.y+

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
This could be classified as a hardware/firmware quirk/workaround -
gating feature enablement based on firmware version. These are typically
YES for stable.

**Step 9.4: MAKE YOUR DECISION**
This is a firmware compatibility fix that prevents the driver from
enabling a reset path on firmware that doesn't support it. Without it,
VCN job timeouts on affected systems lead to failed per-queue resets and
unnecessary full GPU resets. The fix is small, surgical, well-reviewed,
follows an established pattern, and has very low regression risk.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Lijo Lazar, Suggested-by Lijo
  Lazar, Signed-off-by Jesse Zhang and Alex Deucher. No Fixes: or Cc:
  stable (expected).
- [Phase 2] Diff analysis: 18 lines added (new helper + condition
  change), single file `vcn_v4_0_3.c`.
- [Phase 3] git blame: `vcn_v4_0_3_late_init()` introduced by commit
  655d6403ad143 in v6.18-rc1. Sriov check added by c156c7f27ecdb in
  v6.18.
- [Phase 3] git tag --contains: late_init commit first in v6.18, queue
  reset impl in v6.16, this PSP check in v7.0.
- [Phase 3] git log author: Jesse Zhang is a regular AMD GPU driver
  contributor.
- [Phase 4] mail-archive.com: Found V1 and V2 submissions. V1 had IP
  version switch, V2 simplified per Lijo's review ("The program check
  itself should be good enough").
- [Phase 4] Lijo Lazar gave Reviewed-by on V2, noted internal ticket
  reference should be removed.
- [Phase 5] `vcn_v4_0_3_late_init()` is called once during
  initialization; affects `AMDGPU_RESET_TYPE_PER_QUEUE` flag which gates
  reset behavior in `amdgpu_job_timedout()`.
- [Phase 5] vcn_v5_0_1 already has same firmware version gating pattern
  at line 125.
- [Phase 6] Buggy code present in 6.18.y+ stable trees. Patch expected
  to apply cleanly.
- [Phase 8] Failure mode: failed per-queue reset → full GPU reset.
  Severity: HIGH for data center.
- UNVERIFIED: Could not access lore.kernel.org directly (bot
  protection). Used mail-archive.com as alternate source for discussion.
- UNVERIFIED: Exact population of affected users with old firmware is
  unknown, but AMD filed internal tracking ticket FWDEV-159155.

**YES**

 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index e78526a4e521e..ff3013b97abd1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -134,6 +134,21 @@ static int vcn_v4_0_3_early_init(struct amdgpu_ip_block *ip_block)
 	return 0;
 }
 
+static bool vcn_v4_0_3_is_psp_fw_reset_supported(struct amdgpu_device *adev)
+{
+	uint32_t fw_ver = adev->psp.sos.fw_version;
+	uint32_t pgm = (fw_ver >> 8) & 0xFF;
+
+	/*
+	 * FWDEV-159155: PSP SOS FW must be >= 0x0036015f for program 0x01
+	 * before enabling VCN per-queue reset.
+	 */
+	if (pgm == 1)
+		return fw_ver >= 0x0036015f;
+
+	return true;
+}
+
 static int vcn_v4_0_3_late_init(struct amdgpu_ip_block *ip_block)
 {
 	struct amdgpu_device *adev = ip_block->adev;
@@ -141,7 +156,9 @@ static int vcn_v4_0_3_late_init(struct amdgpu_ip_block *ip_block)
 	adev->vcn.supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->vcn.inst[0].ring_enc[0]);
 
-	if (amdgpu_dpm_reset_vcn_is_supported(adev) && !amdgpu_sriov_vf(adev))
+	if (amdgpu_dpm_reset_vcn_is_supported(adev) &&
+	    vcn_v4_0_3_is_psp_fw_reset_supported(adev) &&
+	    !amdgpu_sriov_vf(adev))
 		adev->vcn.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 
 	return 0;
-- 
2.53.0

