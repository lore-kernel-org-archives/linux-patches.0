Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15192301022;
	Sat, 25 Oct 2025 16:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408794; cv=none; b=hDHcykNjyzZxW/AwdP7D4Hr02tRFvpsB+4FnfhA4T2BBUEMy5/0NmwXzOr4GZ7lB+EEo5SuFmWsPDtmfil1iX6kUH748UafeDGPRsCBNDxjRcloeSJy6PqHQMu9OI/EEvKy2vvXMDdVRCLo0ou9rIqNTcxWrFTjYr5FetyI9zjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408794; c=relaxed/simple;
	bh=6G/gvk48evdMBUemFgDfd5CZY6KsXKzKU0k9aBxnDNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EwX7gbJ3fmzTOUj0mX/21BAlPneNikTbF86qCkhiDcOQbOieuJEEdUYo12Y7cILCLCih5CCcq/ZVS2rzwWAfa6RmTNudfCjkXk1X2A3YO7+pfiVKTpsSeH0JgJ1VZspJ/jfFY7OMCQwN/5qyQUknxsB8AiVMn4XHwKUSfq4Qr6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIauK5VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIauK5VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4992C4CEF5;
	Sat, 25 Oct 2025 16:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408794;
	bh=6G/gvk48evdMBUemFgDfd5CZY6KsXKzKU0k9aBxnDNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIauK5VYMUA362OEEwc+Uzgv51oV3T13bwxLmDEvQrKCM7/laHd5a0U6Dkp7QlsZp
	 Mknj5N+3cfz4/CBM7q6rEbpCMYOO51al/gwahewkQ2NB+2o1LdTpBkCZZVwDmCg1Ao
	 c8EN0Se0IGOpIvhJnFbhppdsZ6ErvDrLU71zr8uSjprRlatICuquMylyXWwrcwnzwI
	 ojMEF3E669VRrobPZ/drG1exnJtGLnKOdwRRU6CD5AetPRNWrACJpjLsizi9KnwcW8
	 doUD1I5jiOW65DPIwNqrsWBNxHu0eFNUqF83gUFPWVYQXGJrdac9UFv/UjZurNBPwr
	 ccLJC8zur4L1Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Riana Tauro <riana.tauro@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	lucas.demarchi@intel.com,
	thomas.hellstrom@linux.intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/xe: Set GT as wedged before sending wedged uevent
Date: Sat, 25 Oct 2025 11:55:04 -0400
Message-ID: <20251025160905.3857885-73-sashal@kernel.org>
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

From: Riana Tauro <riana.tauro@intel.com>

[ Upstream commit 90fdcf5f89e9288c153923f16a60e6f7da18ba76 ]

Userspace should be notified after setting the device as wedged.
Re-order function calls to set gt wedged before sending uevent.

Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Raag Jadav <raag.jadav@intel.com>
Signed-off-by: Riana Tauro <riana.tauro@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250826063419.3022216-4-riana.tauro@intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: YES (with dependency)

**Answer: YES** - This commit should be backported to stable kernel
trees, but ONLY together with its prerequisite commit 60439ac3f2354
("drm/xe: Add a helper function to set recovery method").

---

## Comprehensive Analysis

### Race Condition Being Fixed

This commit addresses a critical **Time-of-Check-to-Time-of-Use (TOCTOU)
race condition** in the device wedging error path.

**The Problem (OLD CODE):**
```c
if (!atomic_xchg(&xe->wedged.flag, 1)) {
    // Set device as wedged
    xe->needs_flr_on_fini = true;
    drm_err(&xe->drm, ...);

    // BUG: Send uevent to userspace HERE
    drm_dev_wedged_event(&xe->drm, ...);
}

// Wedge GTs AFTER userspace notification
for_each_gt(gt, xe, id)
    xe_gt_declare_wedged(gt);
```

**The Race:**
1. Thread sets `xe->wedged.flag = 1`
2. Thread sends uevent to userspace notifying of wedged state
3. **Userspace receives notification and may check device state**
4. **BUT: GTs are NOT yet wedged!**
5. Thread finally calls `xe_gt_declare_wedged()` which:
   - Stops submission via `xe_guc_submit_wedge()`
   - Stops command transport via `xe_guc_ct_stop()`
   - Resets TLB invalidation via `xe_tlb_inval_reset()`

**The Impact:**
Userspace receiving the wedged uevent might:
- Query device state and see inconsistent information
- Initiate recovery procedures on a partially-wedged device
- Experience race conditions in error handling logic
- See submissions still active when device should be fully wedged

### The Fix (NEW CODE)

The commit reorders operations to ensure atomicity from userspace's
perspective:

```c
if (!atomic_xchg(&xe->wedged.flag, 1)) {
    xe->needs_flr_on_fini = true;
    drm_err(&xe->drm, ...);
}  // ← Close the atomic block

// Wedge ALL GTs FIRST (always executed)
for_each_gt(gt, xe, id)
    xe_gt_declare_wedged(gt);

// Then notify userspace (always executed if flag is set)
if (xe_device_wedged(xe)) {
    if (!xe->wedged.method)
        xe_device_set_wedged_method(xe, ...);
    drm_dev_wedged_event(&xe->drm, xe->wedged.method, NULL);
}
```

This ensures that:
1. Device wedged flag is set
2. **ALL GTs are fully wedged (submissions stopped, CT stopped, TLB
   reset)**
3. **ONLY THEN is userspace notified**

### Code Changes Analysis

**From xe_device.c:1260-1280:**

The key changes are:
1. **Moved closing brace** - The uevent call is moved OUT of the `if
   (!atomic_xchg(...))` block
2. **Reordered operations** - `for_each_gt()` loop moved BEFORE the
   uevent
3. **Added new guard** - `if (xe_device_wedged(xe))` wraps the uevent
   notification
4. **Uses new infrastructure** - References `xe->wedged.method` (from
   dependency commit)

### Behavioral Changes

**Minor behavioral change:** The uevent is now sent on every call after
the flag is set (not just the first call). However, this is likely
benign because:

1. Most callers check `xe_device_wedged()` before calling (see
   xe_gt.c:816, xe_guc_submit.c:1038)
2. These are error recovery paths that shouldn't execute repeatedly
3. Userspace should handle wedged events idempotently anyway

### Critical Dependency

**This commit has a HARD DEPENDENCY on commit 60439ac3f2354** ("drm/xe:
Add a helper function to set recovery method") which:

1. Adds `xe->wedged.method` field to `struct xe_device`
   (xe_device_types.h:544)
2. Adds `xe_device_set_wedged_method()` function (xe_device.c:1186)
3. Modifies `drm_dev_wedged_event()` call to use `xe->wedged.method`

**Without this dependency, the commit will NOT compile!**

The code in lines 1274-1276 references:
```c
if (!xe->wedged.method)
    xe_device_set_wedged_method(xe, DRM_WEDGE_RECOVERY_REBIND |
                                DRM_WEDGE_RECOVERY_BUS_RESET);
```

And line 1279 uses:
```c
drm_dev_wedged_event(&xe->drm, xe->wedged.method, NULL);
```

Both require the infrastructure from commit 60439ac3f2354.

### Backporting Criteria Evaluation

1. **Does it fix a bug that affects users?** ✓ YES
   - Fixes a race condition in critical error handling
   - Affects device recovery and error reporting
   - Can cause inconsistent state reporting to userspace

2. **Is the fix relatively small and contained?** ✓ YES
   - Just 8 lines added, 4 lines removed
   - Single function modified
   - Localized to xe_device_declare_wedged()

3. **Does it have clear side effects beyond fixing the issue?** ✓ NO
   - Only minor behavioral change (potential multiple uevents)
   - No new functionality added
   - No API changes

4. **Does it include major architectural changes?** ✓ NO
   - Simple code reordering
   - No new subsystems or abstractions

5. **Does it touch critical kernel subsystems?** ⚠ YES (but contained)
   - Touches DRM Xe driver (Intel GPU driver)
   - Critical for device error handling
   - But change is confined to xe driver only

6. **Is there explicit mention of stable tree backporting?** ✗ NO
   - No `Cc: stable@vger.kernel.org` tag
   - No `Fixes:` tag

7. **Does it follow stable tree rules?** ✓ YES
   - Important bugfix (race condition)
   - Minimal risk of regression
   - No new features
   - Confined to single driver

### Risk Assessment

**Risk Level: LOW**

**Reasons:**
- The reordering is logically sound and correct
- Code has been reviewed by maintainers (Reviewed-by: Matthew Brost)
- No reverts found in subsequent commits
- The potential multiple-uevent issue is mitigated by caller checks
- Change is contained to error handling paths

**Testing considerations:**
- Error paths are inherently difficult to test
- Requires triggering GT reset failures or GuC load failures
- May need fault injection testing

### Recommendation

**YES - Backport this commit, BUT as part of a series with its
dependency.**

**Required commits for backport (in order):**
1. **60439ac3f2354** - "drm/xe: Add a helper function to set recovery
   method"
2. **90fdcf5f89e92** - "drm/xe: Set GT as wedged before sending wedged
   uevent" (this commit)

**Rationale:**
- Fixes a real race condition that can cause inconsistent device state
- Small, contained, and low-risk change
- Important for proper error handling and recovery
- Has clear benefit for users with Intel Xe GPUs
- No known regressions or issues

**Target stable trees:**
- Any stable kernel that includes the DRM Xe driver
- Likely 6.8+ (when Xe driver was merged)

**Note:** The commits should be backported as a pair in the correct
order to maintain compilation and functionality.

 drivers/gpu/drm/xe/xe_device.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 1c9907b8a4e9e..d399c2628fa33 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -1157,8 +1157,10 @@ static void xe_device_wedged_fini(struct drm_device *drm, void *arg)
  * xe_device_declare_wedged - Declare device wedged
  * @xe: xe device instance
  *
- * This is a final state that can only be cleared with a module
+ * This is a final state that can only be cleared with the recovery method
+ * specified in the drm wedged uevent. The default recovery method is
  * re-probe (unbind + bind).
+ *
  * In this state every IOCTL will be blocked so the GT cannot be used.
  * In general it will be called upon any critical error such as gt reset
  * failure or guc loading failure. Userspace will be notified of this state
@@ -1192,13 +1194,15 @@ void xe_device_declare_wedged(struct xe_device *xe)
 			"IOCTLs and executions are blocked. Only a rebind may clear the failure\n"
 			"Please file a _new_ bug report at https://gitlab.freedesktop.org/drm/xe/kernel/issues/new\n",
 			dev_name(xe->drm.dev));
+	}
+
+	for_each_gt(gt, xe, id)
+		xe_gt_declare_wedged(gt);
 
+	if (xe_device_wedged(xe)) {
 		/* Notify userspace of wedged device */
 		drm_dev_wedged_event(&xe->drm,
 				     DRM_WEDGE_RECOVERY_REBIND | DRM_WEDGE_RECOVERY_BUS_RESET,
 				     NULL);
 	}
-
-	for_each_gt(gt, xe, id)
-		xe_gt_declare_wedged(gt);
 }
-- 
2.51.0

