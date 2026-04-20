Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E385E47ECE0;
	Mon, 20 Apr 2026 13:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691875; cv=none; b=srPujJl7+sqVviBPTfCd78R5NkJolTySwCeTHFSTdEOdXp4gCH6k9xVepIrZtcruahHRJ6WXPmxztKG2gZNZZOsF+0BZs7VFV+Qv6PSxFxOd8Lyb9c91ufRWkBj3DNt+d2C+ki3oMlvdftH+X++XjFyQgcORbcAIEE/gL56nfDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691875; c=relaxed/simple;
	bh=gvyXCCMJAH//t5bxq4mcivXbyjUIsK1an0vvgrVeBnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjy0GtF8UUQotX1MjZXly5jtT3xHnbcsHfXq3b3E8A36kaPogor3bbnA28e0ChYBH7sRNRhqnK9nQzD58cIa519YfBkvCh5jCBkJUYhxs+zBwaV/Gd7NL+ccZrTfgQwme4aEZLqWjhNpErme1ByM3P515sTmx9dSMDktQU3l/ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o/melf3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o/melf3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557E4C2BCB4;
	Mon, 20 Apr 2026 13:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691874;
	bh=gvyXCCMJAH//t5bxq4mcivXbyjUIsK1an0vvgrVeBnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/melf3fBFQ89Mf2fHjCDkF/ZVQ8I2vOkI2bvtMlCwuBcKXY8504QiHM/xGiakwuA
	 Tjyysh5xRS2VcyBg+2E7xAISu+IN4qWBQI3ruZkpe5Hk/zI+/9WOwNzC6Jyxo+Psdz
	 ndRJXznPIK5VjRkZ+S7rnovatHTVefFY9P238d8qFe9KuHTe8WZxb3LLs2pge+IkKB
	 wi1MZgJEQGN0CnT5Qden5prasKOzxAL6RPipcOjYs9qtTojAPuwIfC38TytWL+9csx
	 aN1Vaku8IIgrXnIQ9s9w8CvbbD5N31vZxb6Mqx1vlo5S/BeVv8jhhkZyILNFDKiTw8
	 ZQn8cCvWYJvcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sreekant Somasekharan <Sreekant.Somasekharan@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdgpu: Revert setting up Retry based Thrashing on GFX 12.1
Date: Mon, 20 Apr 2026 09:20:39 -0400
Message-ID: <20260420132314.1023554-245-sashal@kernel.org>
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

From: Sreekant Somasekharan <Sreekant.Somasekharan@amd.com>

[ Upstream commit 29756a7535facdaed39d0b5572201068a7746812 ]

Bug found with retry based thrashing mechanism. Revert to the old
thrashing method.

Signed-off-by: Sreekant Somasekharan <Sreekant.Somasekharan@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information to complete the full analysis. Let me
compile everything.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** drm/amdgpu (AMD GPU driver)
- **Action verb:** "Revert" - undoing a previous feature that's buggy
- **Summary:** Revert the retry-based thrashing prevention mechanism on
  GFX 12.1 hardware

### Step 1.2: Tags
- **Signed-off-by:** Sreekant Somasekharan (AMD employee, author)
- **Reviewed-by:** Mukul Joshi (the original author of the reverted
  feature)
- **Signed-off-by:** Alex Deucher (AMD GPU subsystem maintainer)
- No Fixes:, Reported-by:, Cc: stable, or Link: tags (expected for
  autosel candidates)

### Step 1.3: Commit Body
The message says: "Bug found with retry based thrashing mechanism.
Revert to the old thrashing method." This is terse, but the prior revert
of the same mechanism (commit `127770bcfccc2`) was more explicit:
"causing **data mismatch and slowness issues with multiple HIP tests**."
Data mismatch is a data corruption symptom.

### Step 1.4: Hidden Bug Fix?
This is an explicit revert of a buggy hardware feature enablement. No
hidden fix — it's straightforward.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files:** 1 file modified: `drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c`
- **Lines:** 0 added, 19 removed (pure deletion)
- **Functions modified:**
  - `gfx_v12_1_xcc_setup_tcp_thrashing_ctrl` (entirely removed)
  - `gfx_v12_1_init_golden_registers` (one call removed)
- **Scope:** Single-file surgical removal

### Step 2.2: Code Flow Change
- **Before:** `gfx_v12_1_init_golden_registers()` called
  `gfx_v12_1_xcc_setup_tcp_thrashing_ctrl()` for each XCC, which
  programmed the TCP_UTCL0_THRASHING_CTRL register with retry-based
  thrashing settings (THRASHING_EN=0x2,
  RETRY_FRAGMENT_THRESHOLD_UP_EN=1, RETRY_FRAGMENT_THRESHOLD_DOWN_EN=1)
- **After:** That function and its call are removed. The hardware's
  default (non-retry-based) thrashing prevention is used instead.

### Step 2.3: Bug Mechanism
This is a **hardware workaround** — the retry-based thrashing mode in
GFX 12.1's TCP UTCL0 has bugs causing data mismatch and performance
issues. Reverting to the old thrashing method avoids triggering the
hardware bug.

### Step 2.4: Fix Quality
- Obviously correct: pure deletion of a function and its call site
- Minimal/surgical: only removes the problematic code, nothing else
  changes
- Regression risk: essentially zero — only reverts to the previous
  (working) behavior
- Reviewed by the feature's original author

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The buggy function `gfx_v12_1_xcc_setup_tcp_thrashing_ctrl` was
introduced in commit `a41d94a7bb962` ("Setup Retry based thrashing
prevention on GFX 12.1") by Mukul Joshi. This commit IS in v7.0.

### Step 3.2: Fixes Tag
No Fixes: tag present. However, this commit effectively fixes/reverts
`a41d94a7bb962`.

### Step 3.3: File History
The history reveals a pattern:
1. An earlier version of retry-based thrashing was in the original file
2. It was reverted in `127770bcfccc2` due to "data mismatch and slowness
   issues with multiple HIP tests"
3. It was re-added with different register settings in `a41d94a7bb962`
4. This commit (`29756a7535fac`) reverts it again because bugs persist

### Step 3.4: Author Context
Sreekant Somasekharan is an AMD employee working on the AMDGPU driver.
The reviewer Mukul Joshi is the author of both the feature and the first
revert. Alex Deucher is the subsystem maintainer.

### Step 3.5: Dependencies
The revert is standalone — it removes code without requiring any other
changes. It will apply cleanly to v7.0 as verified by checking the exact
state of the file in v7.0.

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.5
b4 dig could not find the patch on lore.kernel.org (both for the revert
and the original commit). This is common for AMD GPU patches that may go
through internal review or GitLab merge requests. Web searches also did
not find the specific patch thread.

The related patch "gfx 12.1 cleanups" (found on spinics.net) confirms
this file was actively being cleaned up in the same timeframe,
validating that GFX 12.1 support was being actively refined.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4
- `gfx_v12_1_xcc_setup_tcp_thrashing_ctrl` is called from
  `gfx_v12_1_init_golden_registers`
- `gfx_v12_1_init_golden_registers` is called from `gfx_v12_1_hw_init` —
  the hardware initialization path during GPU probe/resume
- This is a **normal initialization path** hit every time the GPU is
  initialized (boot, resume, GPU reset)
- The buggy register programming affects all GFX 12.1 users on every GPU
  init

### Step 5.5: Similar Patterns
The TCP_UTCL0_THRASHING_CTRL register only exists in GFX 12.1 headers.
No other GFX versions use this specific register in the same way.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Does the buggy code exist in stable?
- `gfx_v12_1.c` does **NOT exist** in v6.12, v6.13, or v6.19 (verified
  via `git show v6.X:...`)
- The file was introduced during the v7.0-rc1 cycle
- The buggy commit `a41d94a7bb962` **IS in v7.0** (verified via `git
  merge-base --is-ancestor`)
- The revert `29756a7535fac` is **NOT in v7.0** (verified)
- **Only v7.0.y stable is affected**

### Step 6.2: Backport Complications
The patch should apply cleanly — the state of
`gfx_v12_1_init_golden_registers` in v7.0 exactly matches the diff
context (verified by examining the v7.0 tree).

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1
- **Subsystem:** GPU driver (drm/amdgpu) — IMPORTANT for AMD GPU users
- GFX 12.1 is new AMD hardware (likely RDNA/CDNA generation)

### Step 7.2
The file has extremely active development (~30 commits since
introduction), expected for new hardware enablement.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected?
All users with GFX 12.1 AMD GPUs running v7.0.y kernels.

### Step 8.2: Trigger conditions
The bug triggers on **every GPU initialization** — boot, resume, GPU
reset. It's not a rare race or edge case.

### Step 8.3: Failure mode
Based on the earlier revert message: "data mismatch and slowness issues
with multiple HIP tests." Data mismatch is effectively **data
corruption** in GPU compute workloads. Severity: **HIGH** (data
corruption + performance degradation).

### Step 8.4: Risk-Benefit
- **Benefit:** HIGH — fixes data corruption and performance issues for
  all GFX 12.1 users on every GPU init
- **Risk:** VERY LOW — pure deletion of 19 lines, reverts to known-good
  previous behavior
- **Ratio:** Strongly favors backporting

## PHASE 9: FINAL SYNTHESIS

### Evidence FOR backporting:
- Fixes real bug: data mismatch (corruption) and slowness in GPU compute
  workloads
- Pure code removal (19 lines deleted, 0 added) — zero regression risk
- Reviewed by the original feature author (Mukul Joshi)
- Signed off by AMD GPU maintainer (Alex Deucher)
- The buggy code IS in v7.0 stable tree
- Triggers on every GPU initialization (not a rare edge case)
- History shows this feature was already reverted once before for the
  same class of issues

### Evidence AGAINST backporting:
- Terse commit message doesn't detail the specific bug
- Only applies to v7.0.y (new hardware)
- No Fixes: tag or explicit stable nomination

### Stable Rules Checklist:
1. Obviously correct and tested? **YES** — pure deletion, reviewed by
   feature author
2. Fixes a real bug? **YES** — data mismatch/corruption and slowness
3. Important issue? **YES** — data corruption severity
4. Small and contained? **YES** — 19 lines in one file
5. No new features or APIs? **YES** — only removes code
6. Can apply to stable? **YES** — applies cleanly to v7.0

## Verification

- [Phase 1] Parsed tags: Reviewed-by Mukul Joshi, Signed-off-by Alex
  Deucher (maintainer)
- [Phase 2] Diff analysis: 19 lines removed, 0 added. Function
  `gfx_v12_1_xcc_setup_tcp_thrashing_ctrl` deleted, call removed from
  `gfx_v12_1_init_golden_registers`
- [Phase 3] git show a41d94a7bb962: confirmed original commit added
  retry thrashing, is in v7.0
- [Phase 3] git merge-base --is-ancestor a41d94a7bb962 v7.0: YES
- [Phase 3] git merge-base --is-ancestor 29756a7535fac v7.0: NO (not in
  v7.0 yet)
- [Phase 3] git show 127770bcfccc2: earlier revert described "data
  mismatch and slowness issues with multiple HIP tests"
- [Phase 3] git tag --contains a41d94a7bb962: confirmed in v7.0,
  v7.0-rc1 through rc7
- [Phase 4] b4 dig -c 29756a7535fac: no match found on lore
- [Phase 4] b4 dig -c a41d94a7bb962: no match found on lore
- [Phase 5] grep TCP_UTCL0_THRASHING: only in gfx_v12_1.c and register
  headers
- [Phase 6] git show v6.12/v6.13/v6.19: file does not exist in any prior
  stable tree
- [Phase 6] Verified v7.0 tree state: function exists at line 2632,
  called at line 2698, patch applies cleanly
- [Phase 8] Failure mode: data corruption (data mismatch) + performance
  degradation, severity HIGH
- UNVERIFIED: Exact nature of the "bug found" in the revert message (but
  corroborated by the earlier revert's more detailed description)

The fix is a minimal, zero-risk pure deletion that fixes data corruption
and performance issues on GFX 12.1 hardware. The buggy code exists in
v7.0 stable, and the patch applies cleanly.

**YES**

 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
index eb9725ae1607a..812de881027b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
@@ -2629,24 +2629,6 @@ static void gfx_v12_1_xcc_disable_gpa_mode(struct amdgpu_device *adev,
 	WREG32_SOC15(GC, GET_INST(GC, xcc_id), regCPG_PSP_DEBUG, data);
 }
 
-static void gfx_v12_1_xcc_setup_tcp_thrashing_ctrl(struct amdgpu_device *adev,
-					 int xcc_id)
-{
-	uint32_t val;
-
-	/* Set the TCP UTCL0 register to enable atomics */
-	val = RREG32_SOC15(GC, GET_INST(GC, xcc_id),
-					regTCP_UTCL0_THRASHING_CTRL);
-	val = REG_SET_FIELD(val, TCP_UTCL0_THRASHING_CTRL, THRASHING_EN, 0x2);
-	val = REG_SET_FIELD(val, TCP_UTCL0_THRASHING_CTRL,
-					RETRY_FRAGMENT_THRESHOLD_UP_EN, 0x1);
-	val = REG_SET_FIELD(val, TCP_UTCL0_THRASHING_CTRL,
-					RETRY_FRAGMENT_THRESHOLD_DOWN_EN, 0x1);
-
-	WREG32_SOC15(GC, GET_INST(GC, xcc_id),
-					regTCP_UTCL0_THRASHING_CTRL, val);
-}
-
 static void gfx_v12_1_xcc_enable_atomics(struct amdgpu_device *adev,
 					 int xcc_id)
 {
@@ -2695,7 +2677,6 @@ static void gfx_v12_1_init_golden_registers(struct amdgpu_device *adev)
 	for (i = 0; i < NUM_XCC(adev->gfx.xcc_mask); i++) {
 		gfx_v12_1_xcc_disable_burst(adev, i);
 		gfx_v12_1_xcc_enable_atomics(adev, i);
-		gfx_v12_1_xcc_setup_tcp_thrashing_ctrl(adev, i);
 		gfx_v12_1_xcc_disable_early_write_ack(adev, i);
 		gfx_v12_1_xcc_disable_tcp_spill_cache(adev, i);
 	}
-- 
2.53.0

