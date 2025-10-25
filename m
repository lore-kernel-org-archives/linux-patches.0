Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089C32957B6;
	Sat, 25 Oct 2025 16:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409440; cv=none; b=p98aze3ETV8JlygAGaRHAuOemRu9aVew4ruKFEUlvYMbqzJxd8fSD3XAzLnvq7xeMZKBTc2SowWJAVEJi+tnOBY0OSaVZC8TL+fJ0hLLKP8qOGvYjPg5JBh9aYW/lhjZDhuFVgnxzCnlOdxtTA4E++7hN/6rDRjHqR9BxCD+/fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409440; c=relaxed/simple;
	bh=jAUAGc3/HxQ29xGurEjm09vOsPd9iGHIf1o9bg8G0E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M1nzh72gngR/R7xvekAajMyllBmnyk6N8dbcR5LXwkjbJmZ27BzLexMyXJCqjZsUDzPaiwXLPr3lArTVZYdiqZtVMGCuOPVd9ttBHcoR1VpEwBWGkhQTy+YPsRhmyhXqNd5N2z7a7S2FP0j6uQlQ60zo3MrgRkt/SeQD2OZsIQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hEId4Z2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hEId4Z2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD43FC4CEFB;
	Sat, 25 Oct 2025 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409439;
	bh=jAUAGc3/HxQ29xGurEjm09vOsPd9iGHIf1o9bg8G0E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hEId4Z2TJThiuo3ixmOQ5xVEZgteFaGws4uIVzFhBNCkPok6JqCWDFOXGXneWfZQz
	 ynLLpv1iDUS5QWERa1CdJpYToJsPysiosdnO3vZztQWMWGP7vZ7pkz+PZlaXvUP4Q+
	 FGBJjRfQFs/vrU0u/C/iIJISCPy1NuLNjnQukBX2EuGQKbm0Tt8Z//DZUQG3OSw2xm
	 Humk46ELJuqhGTAUhHOBcSrUy0a8F7BkzrqXiMONZ9f8PJcn/3vWtUljajWxlPP+Pm
	 DLv6uHvAOhiJc83uoaHB1/kP58Xo9IJVlvzqoWqzZPZqWJAwphnUlffRu7rd8f1nny
	 lTqAq82llNDkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	srinivasan.shanmugam@amd.com,
	sunil.khatri@amd.com,
	Tong.Liu01@amd.com,
	alexandre.f.demers@gmail.com,
	mario.limonciello@amd.com
Subject: [PATCH AUTOSEL 6.17-5.15] drm/amdgpu: Use memdup_array_user in amdgpu_cs_wait_fences_ioctl
Date: Sat, 25 Oct 2025 11:59:17 -0400
Message-ID: <20251025160905.3857885-326-sashal@kernel.org>
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

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit dea75df7afe14d6217576dbc28cc3ec1d1f712fb ]

Replace kmalloc_array() + copy_from_user() with memdup_array_user().

This shrinks the source code and improves separation between the kernel
and userspace slabs.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT DECISION: NO

Based on my comprehensive analysis of this commit, I recommend **NOT**
backporting it to stable kernel trees.

---

## DETAILED ANALYSIS

### 1. COMMIT OVERVIEW

**Change Summary:**
- Replaces `kmalloc_array()` + `copy_from_user()` with
  `memdup_array_user()`
- Location: `drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c` in
  `amdgpu_cs_wait_fences_ioctl()`
- Size: 19 lines changed (5 insertions, 14 deletions)
- Author: Tvrtko Ursulin (DRM developer)
- Maintainer: Alex Deucher (AMD GPU subsystem)

**Code Changes:**
```c
// OLD CODE:
fences = kmalloc_array(fence_count, sizeof(struct drm_amdgpu_fence),
GFP_KERNEL);
if (fences == NULL)
    return -ENOMEM;
fences_user = u64_to_user_ptr(wait->in.fences);
if (copy_from_user(fences, fences_user, sizeof(...) * fence_count)) {
    r = -EFAULT;
    goto err_free_fences;
}

// NEW CODE:
fences = memdup_array_user(u64_to_user_ptr(wait->in.fences),
                          wait->in.fence_count,
                          sizeof(struct drm_amdgpu_fence));
if (IS_ERR(fences))
    return PTR_ERR(fences);
```

### 2. SECURITY ANALYSIS

**Security Benefits Identified:**

1. **Heap Isolation** (Primary Security Benefit):
   - `memdup_array_user()` uses dedicated "user_buckets" slabs
     (introduced in kernel 6.11 via commit d73778e4b8675)
   - Prevents mixing kernel and userspace allocations in the same slab
     caches
   - Mitigates heap exploitation techniques:
     - Heap spraying attacks
     - Use-after-free exploitation
     - Cross-cache attacks
   - Real-world exploit mitigation (per commit d73778e4b8675: prctl
     PR_SET_VMA_ANON_NAME and setxattr exploits)

2. **Proper GFP Flag Usage**:
   - Old: `GFP_KERNEL` (general kernel allocation)
   - New: `GFP_USER` (includes `__GFP_HARDWALL` - NUMA/cpuset
     enforcement)
   - More semantically correct for userspace-triggered allocations in
     ioctl handlers

3. **Overflow Protection** (Maintained):
   - Both old and new code use `check_mul_overflow()` to prevent integer
     overflow
   - Old: Checked in `kmalloc_array()`
   - New: Checked in `memdup_array_user()` wrapper (lines 36-37 of
     include/linux/string.h)

**Security Assessment:**
This is a **proactive hardening measure** that improves defense in
depth, but does NOT fix a specific reported vulnerability, CVE, or
exploitable bug.

### 3. STABLE KERNEL RULES COMPLIANCE

Checking against `/Documentation/process/stable-kernel-rules.rst`:

| Requirement | Status | Details |
|-------------|--------|---------|
| Must exist in mainline | ✅ YES | Commit dea75df7afe14 is in mainline |
| Obviously correct & tested | ✅ YES | Simple API conversion, well-
tested pattern |
| Under 100 lines | ✅ YES | Only 19 lines changed |
| Fix real bug that bothers people | ❌ **NO** | **This is a code
cleanup/hardening change** |
| Has stable tag from maintainer | ❌ **NO** | No `Cc:
stable@vger.kernel.org` in commit message |

**Critical Rule Violation:**

From stable-kernel-rules.rst line 15-31:
> "It must either fix a real bug that bothers people or just add a
device ID... No 'trivial' fixes without benefit for users (spelling
changes, whitespace cleanups, etc)"

This commit:
- Does NOT have a `Fixes:` tag pointing to a bug
- Does NOT reference a CVE or security vulnerability
- Does NOT have a stable tag from the maintainer
- Is described in the commit message as: *"This shrinks the source code
  and improves separation between the kernel and userspace slabs"*
- Primary purpose: Code cleanup + proactive hardening

### 4. FUNCTIONAL ANALYSIS

**Error Handling Changes:**
- Old: Returns `-ENOMEM` or `-EFAULT`
- New: Can return `-ENOMEM`, `-EFAULT`, or `-EOVERFLOW`
- The new `-EOVERFLOW` return is only for pathological inputs
  (fence_count * sizeof > SIZE_MAX) that would have caused undefined
  behavior in the old code anyway

**API Compatibility:**
- No userspace ABI changes
- Return values remain compatible
- Function behavior unchanged

**Risk Assessment:**
- **Regression risk: VERY LOW** - This is a straightforward API
  conversion
- **Side effects: NONE** - Behavior is identical except for slab
  allocation source
- **Testing: IMPLICIT** - memdup_array_user() is widely used (21+
  conversions found in drivers/)

### 5. HISTORICAL CONTEXT

**Similar Commits Pattern:**

Research shows:
- 21+ `memdup_array_user()` conversions in drivers between Sept 2023 -
  Jan 2024
- None of these conversions have stable tags
- They are part of a kernel-wide API modernization effort
- Example: Commits c4ac100e9ae25 (vmemdup_array_user in amdgpu_bo_list),
  d4b6274cbf0b0 (amdgpu_cs_pass1)

**Previous Security Issues in this Function:**

Historical bugs in `amdgpu_cs_wait_fences_ioctl()`:
- eb174c77e258f (2017): Fixed over-bound array access (oops)
- 9f55d300541cb (2023): Fixed integer overflow in amdgpu_cs_pass1

**None of these historical bugs would have been prevented by this
change.**

### 6. INFRASTRUCTURE DEPENDENCIES

**Critical Dependency:**
- Requires `user_buckets` infrastructure (commit d73778e4b8675)
- Available since: **Kernel 6.11** (July 2024)
- The security benefit ONLY applies if user_buckets exists
- On kernels < 6.11, this would just be code cleanup without security
  improvement

**memdup_array_user() availability:**
- Introduced: Kernel 6.7 (commit 313ebe47d7555, Sept 2023)
- Backported to some stable trees as part of the helper function
  addition

### 7. MAINTAINER INTENT

**Explicit Signals:**
- ❌ No `Cc: stable@vger.kernel.org` tag
- ❌ No `Fixes:` tag
- ❌ No mention of security vulnerability
- ✅ Described as "shrinks source code" (code cleanup)
- ✅ Secondary benefit: "improves separation" (hardening)

**Maintainer Intent Analysis:**
The author and maintainer explicitly did NOT request stable backporting.
This is significant - if they believed this fixed a real security issue,
they would have tagged it for stable.

### 8. WHY NOT BACKPORT

**Primary Reasons:**

1. **Not a bug fix** - This is a proactive code improvement, not fixing
   a reported issue
2. **No maintainer request** - No stable tag indicates maintainers don't
   consider it stable-worthy
3. **Violates stable rules** - Rule 15 requires fixing "real bugs that
   bother people"
4. **Part of larger effort** - This is one of many API modernization
   commits
5. **No user-visible issue** - No crash, no data corruption, no
   performance problem being addressed

**Secondary Considerations:**

6. **Limited backport window** - Only applicable to 6.11+ (where
   user_buckets exists)
7. **Questionable value** - On older kernels, this is just code cleanup
   without security benefit
8. **Sets bad precedent** - Backporting code cleanups violates stable
   tree philosophy

### 9. SPECIFIC CODE EXAMINATION

**Function Context:**
```c
int amdgpu_cs_wait_fences_ioctl(struct drm_device *dev, void *data,
struct drm_file *filp)
```
- This is a DRM ioctl handler (userspace interface)
- Used by: `DRM_IOCTL_DEF_DRV(AMDGPU_WAIT_FENCES, ...)`
- Purpose: Wait for GPU command submission fences to complete
- User controls: `fence_count` and `fences` array pointer
- Critical path: No - this is a synchronization operation, not
  performance-critical

**Callers Analysis (via semcode):**
- Direct callers: None (it's an ioctl entry point)
- Invoked via: DRM ioctl dispatcher from userspace applications

**Historical Issues:**
Looking at git history, this specific function has had:
- Over-bound access bugs (fixed in 2017)
- NULL pointer issues (fixed)
- Memory leaks (fixed)

**None were related to allocation method.**

### 10. CONCLUSION

**Backport Recommendation: NO**

This commit should NOT be backported to stable kernel trees because:

1. ✗ **Primary**: Violates stable rule requiring "real bugs that bother
   people"
2. ✗ **Maintainer Intent**: No stable tag = no backport request
3. ✗ **Classification**: This is code modernization/cleanup, not a bug
   fix
4. ✗ **Dependency**: Requires 6.11+ infrastructure for security benefit
5. ✗ **Precedent**: Backporting would set bad precedent for non-fixes

**Alternative Recommendation:**

If kernel distributors want to improve heap security, they should:
- Focus on backporting the `user_buckets` infrastructure (commit
  d73778e4b8675) to older stable trees FIRST
- Then consider a coordinated batch of memdup_array_user conversions
- Work with maintainers to properly tag and coordinate such efforts

**Final Note:**

While this commit provides real security hardening value, the stable
kernel tree is specifically for **fixing bugs**, not proactive
improvements. The absence of a stable tag from experienced kernel
maintainers (Tvrtko Ursulin and Alex Deucher) is a strong signal that
this should remain in mainline only.

The security improvement is real but indirect - it's part of a defense-
in-depth strategy, not a targeted fix for a known vulnerability. Such
changes belong in new kernel releases, not stable backports.

 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index d3f220be2ef9a..d541e214a18c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1767,30 +1767,21 @@ int amdgpu_cs_wait_fences_ioctl(struct drm_device *dev, void *data,
 {
 	struct amdgpu_device *adev = drm_to_adev(dev);
 	union drm_amdgpu_wait_fences *wait = data;
-	uint32_t fence_count = wait->in.fence_count;
-	struct drm_amdgpu_fence *fences_user;
 	struct drm_amdgpu_fence *fences;
 	int r;
 
 	/* Get the fences from userspace */
-	fences = kmalloc_array(fence_count, sizeof(struct drm_amdgpu_fence),
-			GFP_KERNEL);
-	if (fences == NULL)
-		return -ENOMEM;
-
-	fences_user = u64_to_user_ptr(wait->in.fences);
-	if (copy_from_user(fences, fences_user,
-		sizeof(struct drm_amdgpu_fence) * fence_count)) {
-		r = -EFAULT;
-		goto err_free_fences;
-	}
+	fences = memdup_array_user(u64_to_user_ptr(wait->in.fences),
+				   wait->in.fence_count,
+				   sizeof(struct drm_amdgpu_fence));
+	if (IS_ERR(fences))
+		return PTR_ERR(fences);
 
 	if (wait->in.wait_all)
 		r = amdgpu_cs_wait_all_fences(adev, filp, wait, fences);
 	else
 		r = amdgpu_cs_wait_any_fence(adev, filp, wait, fences);
 
-err_free_fences:
 	kfree(fences);
 
 	return r;
-- 
2.51.0

