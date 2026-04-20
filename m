Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB203B19CA;
	Mon, 20 Apr 2026 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691400; cv=none; b=Ie3GW0HRsNJAN/w7/YxpBP+Gd77rPzpCCAwPVYLbX6zjqjpLoqYyiDiCuLsPlBiaQk8MbrcXAyPAdR42Hu+vZ4b+38UIV4uYvSDFw+KTKui82v/Tu3U6iNPQVNL3v6O6DeCxDwy2PUCzWbvJzkmel/xKUy5g35r/cS6TiWCS5gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691400; c=relaxed/simple;
	bh=ilHKaWdBK9xAIgteGoH8Gkqxmn+NqMVwZI2GHoTdqIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mp/rqSi25lXrlnFz1yWrVMtY0i+sMmOr/bzA20nJgR+YMq3Lof/F1enIM1/rgtl+f7iAJmh/ZDsvSE2CYY0GrDtwk4frX5ZMQTcyCg1JoYRlDByyB8tw4Rz6lAqrkAYoPcuwsiPoctlpoB7V2ndopLeAagdScO/HmBgAh2YZtvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bd9SDOXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bd9SDOXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00E7C2BCB4;
	Mon, 20 Apr 2026 13:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691400;
	bh=ilHKaWdBK9xAIgteGoH8Gkqxmn+NqMVwZI2GHoTdqIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bd9SDOXHWs2S0ECF3LnSmz1dpo5hqs0mAWu+oJbfVkIy6qAXPEqgVRFdPjs2xsPKS
	 0vFHCaPr5UY38wyEi/nd2zcIUV0NNCf4FkRxbaTJxrJ/BgqnYVgpSwbJYRPj86jO0f
	 4WQTVbzITeeXEg5ZIQUih20r6w/9Ozs9DRWJybNdZ6nUGlYxSVBcRXX3iAppQ0TfNS
	 tjzrUhAYbBL6cVbhsQa5+UX4gKElMUfhLtFjzBLVC2HRtryZFgNk3y2Oos8WelU8cF
	 ruMryhFDZplHMUmpXpdm1VQmOTBgc1riB6Ic5QIe65rJej2ZH7/Zch1n//1ft8rQOO
	 j1K0yk+Zi9Tzw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Likun Gao <Likun.Gao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.12] drm/amdgpu: fix DF NULL pointer issue for soc24
Date: Mon, 20 Apr 2026 09:16:37 -0400
Message-ID: <20260420132314.1023554-3-sashal@kernel.org>
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

From: Likun Gao <Likun.Gao@amd.com>

[ Upstream commit 50808826a64b4957b7088c789e539dd0a75a1560 ]

If DF function not initialized, NULL pointer issue
will happen on soc24.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information I need. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
- **Subsystem:** `drm/amdgpu` (AMD GPU driver)
- **Action verb:** "fix" - explicitly a bug fix
- **Summary:** Fix NULL pointer dereference when DF functions are not
  initialized on soc24

Record: [drm/amdgpu] [fix] [NULL pointer dereference when df.funcs is
NULL in soc24_common_hw_init]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by:** Likun Gao (author)
- **Reviewed-by:** Hawking Zhang (AMD architect/maintainer for amdgpu)
- **Signed-off-by:** Alex Deucher (amdgpu subsystem maintainer)
- No Fixes: tag, no Cc: stable tag, no Reported-by (expected for manual
  review)

Record: Reviewed by Hawking Zhang (AMD subsystem architect) and merged
by Alex Deucher (amdgpu maintainer). Strong trust signal.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The body says: "If DF function not initialized, NULL pointer issue will
happen on soc24." This describes a concrete crash scenario: when
`adev->df.funcs` is NULL and code dereferences it to check `->hw_init`.

Record: [Bug: NULL pointer dereference] [Symptom: kernel oops/crash
during GPU hw_init or resume] [Root cause: missing NULL check before
dereferencing df.funcs pointer]

### Step 1.4: DETECT HIDDEN BUG FIXES
Not hidden - this is an explicit "fix" for a NULL pointer dereference.

Record: Not a hidden fix, explicitly labeled as a fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **Files:** 1 file changed (`drivers/gpu/drm/amd/amdgpu/soc24.c`)
- **Lines:** 1 line modified (replacing one condition with a guarded
  condition)
- **Function:** `soc24_common_hw_init()`
- **Scope:** Single-line surgical fix

Record: [soc24.c: 1 line changed in soc24_common_hw_init()] [Scope:
single-line surgical fix]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Before:

```481:481:drivers/gpu/drm/amd/amdgpu/soc24.c
        if (adev->df.funcs->hw_init)
```

After:
```c
        if (adev->df.funcs && adev->df.funcs->hw_init)
```

The code was dereferencing `adev->df.funcs` (which can be NULL) to check
`hw_init`. The fix adds a NULL guard.

Record: [Before: unconditional dereference of df.funcs -> After: guarded
dereference with NULL check first]

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Category: NULL pointer dereference (d)**
- `adev->df.funcs` can be NULL if the DF IP version doesn't match any
  known version in `amdgpu_discovery.c`
- The code dereferences this NULL pointer to check `->hw_init`
- This causes a kernel oops

Record: [NULL pointer dereference] [df.funcs can be NULL when DF IP
version is unrecognized; the fix adds a standard guard consistent with
soc15.c patterns]

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct: the pattern `if (ptr && ptr->member)` is idiomatic
  C null-guard
- Consistent: `soc15.c` already uses `if (adev->df.funcs &&
  adev->df.funcs->hw_init)` and `if (adev->df.funcs &&
  adev->df.funcs->sw_init)` - the exact same pattern
- Minimal: single condition addition, no behavior change when df.funcs
  is non-NULL
- Regression risk: zero - the only change is skipping the call when
  funcs is NULL (which would crash otherwise)

Record: [Obviously correct, minimal, zero regression risk. Matches
existing patterns in soc15.c]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The buggy line was introduced by commit `73048bda46c308` ("drm/amdgpu:
Fix atomics on GFX12") by David Belanger on 2024-06-10. This commit
added the DF hw_init call to soc24_common_hw_init but omitted the NULL
check for `adev->df.funcs`, unlike how soc15.c handles it.

Record: [Buggy code introduced by 73048bda46c308, present in v6.11+]

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present (expected for review candidates).

Record: [No Fixes: tag, but the implicit fix target is 73048bda46c308]

### Step 3.3: CHECK FILE HISTORY
soc24.c was created by `98b912c50e449` (first in v6.11). The buggy
commit `73048bda46c308` was also added in v6.11. The file has had ~20
subsequent commits (refactoring handle pointers, etc.), but none touched
this specific df.funcs line.

Record: [Standalone fix, no prerequisites beyond the original buggy
commit]

### Step 3.4: CHECK THE AUTHOR
Likun Gao is a regular AMD GPU contributor with multiple recent commits
to the amdgpu subsystem. The reviewer (Hawking Zhang) is the original
soc24.c creator and AMD architect.

Record: [Author is a regular AMD contributor; reviewer is the subsystem
architect]

### Step 3.5: DEPENDENCIES
This fix has no dependencies. It simply adds a NULL check guard to an
existing conditional. It will apply to any tree that contains commit
`73048bda46c308`.

Record: [No dependencies, standalone fix]

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: PATCH DISCUSSION
Found the original submission at
[spinics](https://www.spinics.net/lists/amd-gfx/msg138858.html).
Submitted by Alex Deucher on March 6, 2026. No objections or NAKs
visible. It was part of a batch of AMD GPU fixes.

Record: [Found submission on amd-gfx list, no objections, submitted in a
batch of fixes by the maintainer]

### Step 4.2: REVIEWERS
Reviewed by Hawking Zhang (AMD architect), signed off by Alex Deucher
(subsystem maintainer). Both are the top-level amdgpu maintainers.

Record: [Reviewed and merged by subsystem maintainers]

### Step 4.3-4.5: BUG REPORT / RELATED PATCHES / STABLE HISTORY
No syzbot report, no explicit bug report URL. This appears to be an
internally-discovered issue at AMD.

Record: [Internal AMD finding, no external bug report]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.2: KEY FUNCTIONS AND CALLERS
`soc24_common_hw_init()` is called:
1. During GPU initialization via the `amd_ip_funcs` table (line 588:
   `.hw_init = soc24_common_hw_init`)
2. During resume via `soc24_common_resume()` (line 524-527)

Both are common execution paths for any system with soc24 hardware.

### Step 5.3-5.4: WHY df.funcs CAN BE NULL
In `amdgpu_discovery.c`, `adev->df.funcs` is set in a switch on
`DF_HWIP` version. The default case is `break` (no assignment). If a
soc24 device has a DF IP version not in the list, `df.funcs` remains
NULL. This is the exact trigger.

### Step 5.5: SIMILAR PATTERNS
Verified: `soc15.c` consistently uses the guarded pattern:
- Line 1253: `if (adev->df.funcs && adev->df.funcs->sw_init)`
- Line 1264: `if (adev->df.funcs && adev->df.funcs->sw_fini)`
- Line 1498: `if (adev->df.funcs &&
  adev->df.funcs->get_clockgating_state)`
- `gmc_v9_0.c` also guards with `if (adev->df.funcs && ...)`

soc24.c is the ONLY file missing this guard.

Record: [All other callers guard df.funcs with NULL check; soc24.c is
the sole exception]

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE TREES
- `soc24.c` first appeared in v6.11
- The buggy commit `73048bda46c308` is in v6.11+
- Therefore the bug exists in stable trees: **6.11.y, 6.12.y, 7.0.y**
- Not present in 6.6.y or earlier (soc24.c doesn't exist there)

Record: [Bug exists in 6.11.y, 6.12.y, 7.0.y]

### Step 6.2: BACKPORT COMPLICATIONS
The fix is a single-line change. No conflicting refactoring has touched
this specific line. Clean apply expected.

Record: [Expected clean apply to all affected stable trees]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
- **Subsystem:** GPU driver (drm/amdgpu) - IMPORTANT
- AMD GPUs are extremely common in desktop and laptop systems
- soc24 corresponds to RDNA4 generation (GC 12.0.x) - recent and
  actively shipping hardware

Record: [drm/amdgpu] [IMPORTANT - affects users of recent AMD GPUs]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
All users with soc24 (RDNA4) AMD GPU hardware where the DF IP version
doesn't match a listed version in discovery.

### Step 8.2: TRIGGER CONDITIONS
The crash triggers during:
- GPU hardware initialization (every boot)
- GPU resume from suspend (every suspend/resume cycle)
These are unavoidable common paths.

### Step 8.3: FAILURE MODE SEVERITY
**CRITICAL** - NULL pointer dereference causes a kernel oops, crashing
the system during boot or resume. The GPU driver is essential for
display output.

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit:** Prevents kernel oops on boot/resume for soc24 users -
  VERY HIGH
- **Risk:** 1-line addition of a NULL check, zero chance of regression -
  VERY LOW
- **Ratio:** Extremely favorable

Record: [Benefit: VERY HIGH (prevents crash), Risk: VERY LOW (1-line
NULL guard)]

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting:**
- Fixes a NULL pointer dereference (kernel oops/crash)
- Affects GPU init and resume paths (common, unavoidable paths)
- Single-line fix, obviously correct
- Matches existing defensive patterns in soc15.c, gmc_v9_0.c,
  amdgpu_ras.c
- Reviewed by AMD architect (Hawking Zhang), merged by subsystem
  maintainer (Alex Deucher)
- Zero regression risk
- Affects actively-shipping hardware (RDNA4)

**AGAINST backporting:**
- None identified

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - standard NULL guard, matches
   existing patterns, reviewed by maintainers
2. Fixes a real bug? **YES** - NULL pointer dereference → kernel oops
3. Important issue? **YES** - system crash during GPU init/resume
   (CRITICAL)
4. Small and contained? **YES** - 1 line changed in 1 file
5. No new features or APIs? **YES** - purely defensive check
6. Can apply to stable? **YES** - clean apply expected for 6.11.y+

### Step 9.3: EXCEPTION CATEGORIES
Not an exception case; this is a standard bug fix that meets all normal
criteria.

### Step 9.4: DECISION
This is a textbook stable backport candidate: a one-line NULL pointer
check that prevents a kernel oops during GPU initialization and resume
on recent AMD hardware.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by: Hawking Zhang, SOB: Likun Gao,
  Alex Deucher
- [Phase 2] Diff analysis: 1 line changed in soc24_common_hw_init(),
  adds `adev->df.funcs &&` guard
- [Phase 3] git blame: buggy code introduced in commit 73048bda46c308
  (v6.11), "Fix atomics on GFX12"
- [Phase 3] git merge-base: confirmed 73048bda46c308 is in v6.11+,
  soc24.c first added in v6.11
- [Phase 4] Found original submission at spinics amd-gfx list, no NAKs
  or concerns
- [Phase 5] Grep for `adev->df.funcs`: soc15.c, gmc_v9_0.c, amdgpu_ras.c
  all use NULL guard; soc24.c is the only exception
- [Phase 5] amdgpu_discovery.c: df.funcs assignment has a `default:
  break` that leaves funcs NULL for unrecognized DF versions
- [Phase 5] soc24_common_resume() calls soc24_common_hw_init(),
  confirming crash on both init and resume
- [Phase 6] Bug exists in 6.11.y, 6.12.y, 7.0.y; not in 6.6.y or earlier
  (soc24.c not present)
- [Phase 8] Failure mode: NULL deref -> kernel oops during GPU
  init/resume, severity CRITICAL

**YES**

 drivers/gpu/drm/amd/amdgpu/soc24.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/soc24.c b/drivers/gpu/drm/amd/amdgpu/soc24.c
index ecb6c3fcfbd15..984262936545f 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc24.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc24.c
@@ -484,7 +484,7 @@ static int soc24_common_hw_init(struct amdgpu_ip_block *ip_block)
 	if (adev->nbio.funcs->remap_hdp_registers)
 		adev->nbio.funcs->remap_hdp_registers(adev);
 
-	if (adev->df.funcs->hw_init)
+	if (adev->df.funcs && adev->df.funcs->hw_init)
 		adev->df.funcs->hw_init(adev);
 
 	/* enable the doorbell aperture */
-- 
2.53.0

