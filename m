Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2604652F88;
	Sat, 25 Oct 2025 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408810; cv=none; b=Na/tLh1Ea/k0Ay2bOhO3DANDjG9jka6ND1J0G+HKJ/+Skk4s15nkE4Eea0I264ERBBg/1A/qBHAF0LtzRYaqEs2kJKV29idsnkg5nm/QIXMfx9fR0yc65xDFTPYfBuKQ3HWeyw3QOoNkZeURW21oSWLHr+DcKG/ZGtAtcIj33bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408810; c=relaxed/simple;
	bh=BbdPKyoALXBBFw090ux1IWCknNoIk1TKUHThzaMOe9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNyn8lTvkQ4tzUP8TingJ7qCxhFY3zz6QAjG6aFP/Kxk/NluaZ4J+mVErXDvyyVlhSzkhpt7e2sKPe89ycdEapgX3njuJCt1oNtlv3kJtiu/KRQXJADsouF+n+JOVEOHt6dYnDti866iV77fOrOJOj9/WvIgs6kJDT/ZnM5UvjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tUnnaUkk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tUnnaUkk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2EC7C4CEF5;
	Sat, 25 Oct 2025 16:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408810;
	bh=BbdPKyoALXBBFw090ux1IWCknNoIk1TKUHThzaMOe9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUnnaUkk3Hc3701sh+DfvuZlhNcekQanPu84lrP3Cl8SZFxW7WfflpquDlGZgGYCK
	 fjzjvCwE0jFv056XWaclDqCv8fPaUHOCzMpBVuQYZWVCq98ozVeZerAPcE3A5JmxVp
	 xgdGLFGyY77Tr0HjlnZE68utzDbT4OgmXOZr5ynnKdz+Njfl6ZbYJm8JJ80vQ7GOjD
	 Vfp/yMwdmaZ6IaEEDor92wfBUXLPlI4F4PWgd7tp81i9D0otbXvb2jWG5favHd96v+
	 xxK+jDzd7cd8nUiUigNUFePkpyndiMC/NNjLDrdyT0gGd1oCL0XL0viNxRYXuVSs4z
	 5mLOB3WALts8g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ausef Yousof <Ausef.Yousof@amd.com>,
	Leo Chen <leo.chen@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	austin.zheng@amd.com,
	jun.lei@amd.com
Subject: [PATCH AUTOSEL 6.17-6.12] drm/amd/display: fix dml ms order of operations
Date: Sat, 25 Oct 2025 11:55:09 -0400
Message-ID: <20251025160905.3857885-78-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ausef Yousof <Ausef.Yousof@amd.com>

[ Upstream commit 02a6c2e4b28ff31f7a904c196a99fb2efe81e2cf ]

[why&how]
small error in order of operations in immediateflipbytes
calculation on dml ms side that can result in dml ms
and mp mismatch immediateflip support for a given pipe
and thus an invalid hw state, correct the order to align
with mp.

Reviewed-by: Leo Chen <leo.chen@amd.com>
Signed-off-by: Ausef Yousof <Ausef.Yousof@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis Complete

Based on my comprehensive investigation of this commit, here is my
determination:

**Backport Status: YES**

---

## Executive Summary

This commit fixes a critical order of operations bug in the AMD display
driver's DML2 (Display Mode Library 2) bandwidth calculation code that
has existed since DML2 was introduced in kernel v6.7. The fix is a
single-line change that adds parentheses to correct the calculation of
total immediate flip bytes, preventing potential hardware state
mismatches that can lead to display corruption or system instability.

---

## Detailed Technical Analysis

### The Bug (display_mode_core.c:6532)

**Before:**
```c
mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes
+
    mode_lib->ms.NoOfDPP[j][k] *
mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] +
    mode_lib->ms.MetaRowBytes[j][k];
```

**After:**
```c
mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes
+
    mode_lib->ms.NoOfDPP[j][k] *
(mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] +
    mode_lib->ms.MetaRowBytes[j][k]);
```

### What Changed

Due to C operator precedence, the original code evaluated as:
```
Total += (NoOfDPP * PDEAndMetaPTEBytesPerFrame) + MetaRowBytes
```

The corrected code properly evaluates as:
```
Total += NoOfDPP * (PDEAndMetaPTEBytesPerFrame + MetaRowBytes)
```

### Impact Analysis

1. **Calculation Error**: When `NoOfDPP[j][k] > 1` (multiple display
   pipes active), the code underestimated `TotImmediateFlipBytes` by:
  ```
  (NoOfDPP[j][k] - 1) * MetaRowBytes[j][k]
  ```

2. **Downstream Effects**:
   - `TotImmediateFlipBytes` is passed to `CalculateFlipSchedule()` at
     line 6555
   - Used to calculate `ImmediateFlipBW` bandwidth allocation
   - Underestimated total → overestimated per-pipe bandwidth
   - Can incorrectly determine immediate flip is supported when it
     shouldn't be
   - Results in "dml ms and mp mismatch" (display mode vs mode
     programming)
   - Leads to **invalid hardware state** (per commit message)

3. **User-Visible Symptoms**: Potential display corruption, flickering,
   hangs, or crashes on AMD GPUs using DML2

### Verification Against Reference Implementation

I verified this fix aligns with the **existing correct implementation**
in DCN30 DML
(drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c):

```c
v->TotImmediateFlipBytes = v->TotImmediateFlipBytes +
    v->NoOfDPP[i][j][k] * (v->PDEAndMetaPTEBytesPerFrame[i][j][k] +
                           v->MetaRowBytes[i][j][k] +
                           v->DPTEBytesPerRow[i][j][k]);
```

The DCN30 code correctly multiplies `NoOfDPP` by the sum of all byte
components, confirming this fix is correct.

### Historical Context

- **Bug introduced**: Commit 7966f319c66d9 (October 9, 2023) -
  "Introduce DML2"
- **Bug duration**: ~23 months (Oct 2023 → Sep 2025)
- **First fixed in**: v6.18-rc1
- **Affected kernels**: All versions 6.7 through 6.17 contain the bug
- **Total affected stable releases**: 100+ stable point releases across
  11 major kernel versions

---

## Backporting Criteria Assessment

### ✅ Criteria Met

1. **Fixes important bug**: YES
   - Hardware correctness issue affecting display functionality
   - Can cause "invalid hw state" per commit message
   - Affects all DML2 users (AMD GPUs on kernels 6.7+)

2. **Small and contained**: YES
   - Single line change
   - Only adds parentheses to fix operator precedence
   - No functional changes beyond fixing the calculation

3. **Clear side effects**: NO unwanted side effects
   - Only corrects a mathematical calculation
   - Aligns with reference implementation
   - No API changes, no behavioral changes beyond the bugfix

4. **No architectural changes**: YES
   - Pure bugfix with no design changes
   - Maintains existing code structure

5. **Minimal regression risk**: YES
   - Extremely low risk - only corrects arithmetic
   - Has proper review (Reviewed-by: Leo Chen)
   - Has testing (Tested-by: Daniel Wheeler)
   - No follow-up fixes or reverts found

6. **Confined to subsystem**: YES
   - Confined to AMD display driver DML2 module
   - Function: `dml_prefetch_check()` in display_mode_core.c

7. **Stable tree mention**: NO
   - No explicit Cc: stable tag in commit message
   - However, this is a clear bugfix that qualifies under stable rules

### Context Stability

I verified the surrounding code context is **identical** in:
- v6.7 (first version with DML2)
- v6.12 (middle of affected range)
- v6.17 (current)

The patch will apply **cleanly** to all affected stable kernels without
modification.

---

## Similar Patterns in Stable Tree

This commit has similar characteristics to accepted stable backports:
- Small calculation fixes in hardware drivers
- Order of operations corrections
- Hardware state correctness fixes
- Single-line parenthesis additions for precedence fixes

---

## Risk Assessment

**Backport Risk: MINIMAL**

- **Code change complexity**: Trivial (adding parentheses)
- **Testing coverage**: Commit has Tested-by tag
- **Review coverage**: Commit has Reviewed-by tag
- **Dependencies**: None identified
- **Regression potential**: Extremely low
- **Apply cleanly**: Yes, verified across kernel versions

**Not Backporting Risk: MODERATE-HIGH**

- Users continue experiencing incorrect hardware state
- Potential display corruption/flickering/hangs remain unfixed
- Bug affects 100+ stable releases
- Fix is safe and trivial

---

## Recommendation

**YES - This commit SHOULD be backported to stable kernel trees.**

**Target Kernels**: All stable trees from 6.7.y through 6.17.y

**Justification**:
1. Fixes important hardware correctness bug
2. Trivial, surgical change with minimal risk
3. Affects wide range of users (all AMD DML2 GPUs)
4. Clean application to all affected kernels
5. Properly reviewed and tested
6. Aligns with existing correct implementation
7. No dependencies or prerequisites

This is a textbook example of an excellent stable backport candidate: a
small, well-understood fix for a clear bug that affects hardware
correctness with minimal regression risk.

 drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
index 715f9019a33e2..4b9b2e84d3811 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
+++ b/drivers/gpu/drm/amd/display/dc/dml2/display_mode_core.c
@@ -6529,7 +6529,7 @@ static noinline_for_stack void dml_prefetch_check(struct display_mode_lib_st *mo
 				mode_lib->ms.TotImmediateFlipBytes = 0;
 				for (k = 0; k <= mode_lib->ms.num_active_planes - 1; k++) {
 					if (!(mode_lib->ms.policy.ImmediateFlipRequirement[k] == dml_immediate_flip_not_required)) {
-						mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] + mode_lib->ms.MetaRowBytes[j][k];
+						mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * (mode_lib->ms.PDEAndMetaPTEBytesPerFrame[j][k] + mode_lib->ms.MetaRowBytes[j][k]);
 						if (mode_lib->ms.use_one_row_for_frame_flip[j][k]) {
 							mode_lib->ms.TotImmediateFlipBytes = mode_lib->ms.TotImmediateFlipBytes + mode_lib->ms.NoOfDPP[j][k] * (2 * mode_lib->ms.DPTEBytesPerRow[j][k]);
 						} else {
-- 
2.51.0

