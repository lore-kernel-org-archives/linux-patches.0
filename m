Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1C3303CAC;
	Sat, 25 Oct 2025 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408902; cv=none; b=FAgUsoZWUdwgzXVJQqPEdc3QyTJT0cG4gJf/t4wF7/kKqGDOsU375DQtYWOGt6i/SALnN2yFJNQfY+cxCk3fxAdh6KMhxPl9UYvHw/wjRpCiNlmEFKPOA/BFzVaWPvEZmws5w88BPTWqLUPjH/Eek9DL6AzmMkDCWpaSRndljfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408902; c=relaxed/simple;
	bh=DJwMTGCHXRhfDzx4ZOYsBCGoCzIY7KlUstQ8H0jpo9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X/6t2tk2wBC54PCOt5o3+TfJ+ipussBiYcxKRWLWbwdX4eYMmLUF+IJxzCfHSYVctP9tfkDwMmaeA/0AcBPJF5Icq+7u30masdwXM5lrtgoY5D3k4IcWrAQyvcovi6NNjfDjoDdqslVa71EXlZCpTVGOnTHhoajEVVarQviRKrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GWGzLq1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GWGzLq1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C6BC4CEF5;
	Sat, 25 Oct 2025 16:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408902;
	bh=DJwMTGCHXRhfDzx4ZOYsBCGoCzIY7KlUstQ8H0jpo9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWGzLq1cStB+tKRho7tORUTGQHnoLRUBTbsIScQvHqILnEra1Dh2lQ6slzO9Di4/b
	 hqddJ9Wdcgoyc4u8qXKV+N2kJC7lb/zkhWeKQfKKswhrcbCDHj8hiaSM3LCANvknCN
	 tPSLUqStBZeSYGIBu8cmL0iHnFV9Fu2VDdnbMvs81eVWRbEHV9voLJneI2CnysxO6t
	 slXniFIoxngLU0H+JfNjUGZcbatPqFLnPsBFyCnTJ5qYZNUUQMc6LYPGS4Dm36eWZW
	 Eq2xPuwWIy95q5Qbz78tVg84bvwPz9bhW1wqPFISjnxGp4bwlA2KdMbgcuVe1GKR6v
	 K2y2JXHYEvmbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lijo Lazar <lijo.lazar@amd.com>,
	Ce Sun <cesun102@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	christian.koenig@amd.com,
	Hawking.Zhang@amd.com,
	mario.limonciello@amd.com,
	alexandre.f.demers@gmail.com,
	asad.kamal@amd.com,
	kevinyang.wang@amd.com,
	jonathan.kim@amd.com
Subject: [PATCH AUTOSEL 6.17] drm/amdgpu: Release hive reference properly
Date: Sat, 25 Oct 2025 11:55:53 -0400
Message-ID: <20251025160905.3857885-122-sashal@kernel.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit c1456fadce0c99175f97e66c2b982dd051e01aa2 ]

xgmi hive reference is taken on function entry, but not released
correctly for all paths. Use __free() to release reference properly.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Ce Sun <cesun102@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Analysis Complete

**Answer: YES**

This commit should be backported to stable kernel trees.

---

## Comprehensive Analysis

### Bug Description

This commit fixes a **kobject reference leak** in the AMDGPU driver's
PCI error handling code. The function `amdgpu_pci_error_detected()`
obtains an XGMI hive reference at function entry via
`amdgpu_get_xgmi_hive(adev)` but only releases it in one out of multiple
return paths, causing the reference to leak in the following cases:

**Leak Paths (lines 6940-6990 in amdgpu_device.c):**

1. **`pci_channel_io_normal` case** (line 6952): Returns
   `PCI_ERS_RESULT_CAN_RECOVER` without calling
   `amdgpu_put_xgmi_hive(hive)` - **LEAK**

2. **`pci_channel_io_frozen` with unsupported link reset** (line 6963):
   Returns `PCI_ERS_RESULT_DISCONNECT` when
   `amdgpu_dpm_is_link_reset_supported()` returns false - **LEAK**

3. **`pci_channel_io_perm_failure` case** (line 6986): Returns
   `PCI_ERS_RESULT_DISCONNECT` without releasing - **LEAK**

4. **Default fallthrough** (line 6990): Returns
   `PCI_ERS_RESULT_NEED_RESET` without releasing - **LEAK**

**Only correct path:** The `pci_channel_io_frozen` case (line 6980)
properly calls `amdgpu_put_xgmi_hive(hive)` after unlocking the mutex.

### The Fix

The commit elegantly solves this by:

1. **Defining a cleanup macro** in `amdgpu_xgmi.h:131`:
  ```c
  DEFINE_FREE(xgmi_put_hive, struct amdgpu_hive_info *, if (_T)
  amdgpu_put_xgmi_hive(_T))
  ```

2. **Using the `__free()` attribute** in `amdgpu_device.c:6940-6941`:
  ```c
  struct amdgpu_hive_info *hive __free(xgmi_put_hive) =
  amdgpu_get_xgmi_hive(adev);
  ```

This ensures automatic cleanup when the `hive` variable goes out of
scope, regardless of which return path is taken.

3. **Removing the manual cleanup** (lines 6980-6982): The explicit
   `amdgpu_put_xgmi_hive(hive)` call is removed since it's now handled
   automatically.

### Historical Context

**Timeline of the bug:**
- **March 2025 (v6.16)**: Commit `8ba904f54148d` ("drm/amdgpu: Multi-GPU
  DPC recovery support") by Ce Sun introduced the XGMI hive reference to
  this function, creating 3 leak paths
- **July 2025 (v6.18-rc1)**: Commit `91c4fd416463a6` ("drm/amdgpu: Set
  dpc status appropriately") by Lijo Lazar added the 4th leak path
- **September 2025 (v6.18-rc1)**: This commit `c1456fadce0c9` by Lijo
  Lazar fixes all leak paths

**Pattern of XGMI hive leaks:** My research found multiple previous
commits fixing similar XGMI hive reference leaks:
- `2efc30f0161b0` (2022): "drm/amdgpu: Fix hive reference count leak"
- `9dfa4860efb8c` (2022): "drm/amdgpu: fix hive reference leak when
  adding xgmi device"
- `1ff186ff32997` (2022): "drm/amdgpu: fix hive reference leak when
  reflecting psp topology info"

This demonstrates that XGMI hive reference management has been error-
prone, making the automatic cleanup approach especially valuable.

### Impact Assessment

**Severity:** Medium to High for affected systems

**Who is affected:**
- Systems with AMD XGMI multi-GPU configurations (MI200/MI300 series
  data center GPUs)
- Only triggers when PCI errors are detected on these systems

**Consequences:**
- **Kobject reference leak**: The XGMI hive kobject's reference count is
  incremented but not decremented
- **Memory leak**: The hive structure cannot be freed even when it
  should be released
- **Accumulation over time**: Repeated PCI errors will continue leaking
  references
- **System instability**: Eventually could lead to memory exhaustion or
  kobject reference count overflow

**Frequency:**
- PCI error detection is typically rare in healthy systems
- More common in systems with hardware issues, RAS (Reliability,
  Availability, Serviceability) testing, or during DPC (Downstream Port
  Containment) events
- The `pci_channel_io_normal` case (early return) is likely the most
  common leak path

### Technical Quality of the Fix

**Strengths:**
- **Modern kernel pattern**: Uses the `__free()` cleanup attribute
  introduced in v6.10
- **Automatic cleanup**: Compiler-enforced, eliminates human error
- **Small and contained**: Only 11 lines changed across 2 files
- **No behavioral changes**: Pure bug fix, no functional modifications
- **Well-tested pattern**: The cleanup infrastructure is widely used and
  battle-tested

**Weaknesses:**
- **Missing Fixes: tag**: Should have included `Fixes: 8ba904f54148d
  ("drm/amdgpu: Multi-GPU DPC recovery support")`
- **No stable tag**: Commit message lacks `Cc: stable@vger.kernel.org`

### Backport Compatibility

**Infrastructure requirements:**
- Requires `include/linux/cleanup.h` with `DEFINE_FREE()` and `__free()`
  support
- First introduced in v6.10 (commit `54da6a0924311`)

**Affected kernel versions:**
- **Bug introduced**: v6.16 (first 3 leak paths)
- **Bug worsened**: v6.18-rc1 (4th leak path added)
- **Bug fixed**: v6.18-rc1 (this commit)

**Backport targets:**
- ✅ v6.16.x stable - Has cleanup.h infrastructure, has the bug
- ✅ v6.17.x stable - Has cleanup.h infrastructure, has the bug
- ❌ v6.15.x and earlier - Bug not present (commit 8ba904f54148d not in
  these versions)
- ❌ v6.9.x and earlier - cleanup.h infrastructure not available

**Backport process:**
- Direct cherry-pick should work without modification
- All dependencies (cleanup.h, DEFINE_FREE) are present in v6.16+

### Why This Should Be Backported

**Meets stable kernel criteria:**

✅ **Fixes a real bug**: Kobject reference leak causing memory leak
✅ **Affects real users**: AMD XGMI multi-GPU systems with PCI errors
✅ **Important bugfix**: PCI error handling is critical for system
reliability
✅ **Small and simple**: Only 11 lines changed, minimal complexity
✅ **Low regression risk**: Pure cleanup fix, no logic changes
✅ **No new features**: Just bug fix, no feature additions
✅ **No architectural changes**: Confined to one function
✅ **Already in mainline**: Present in v6.18-rc1
✅ **Clean dependencies**: Only needs cleanup.h (available since v6.10)

**Additional justification:**

1. **Critical subsystem**: PCI error recovery is essential for system
   stability and RAS features in data center environments

2. **Resource leak accumulation**: Unlike some bugs that have one-time
   impact, this leak accumulates with each PCI error event

3. **Modern cleanup pattern**: This fix demonstrates best practices for
   resource management in the kernel

4. **Prevents future issues**: The automatic cleanup prevents this class
   of bug from being reintroduced

### Recommendation

**BACKPORT TO:**
- linux-6.17.y stable tree
- linux-6.16.y stable tree

**NOT NEEDED FOR:**
- linux-6.15.y and earlier (bug not present)

**SUGGESTED STABLE COMMIT MESSAGE ADDITIONS:**
```
Fixes: 8ba904f54148d ("drm/amdgpu: Multi-GPU DPC recovery support")
Cc: stable@vger.kernel.org # v6.16+
```

### Verification

To verify my analysis, I:

1. ✅ Used semcode MCP tools to analyze function implementations
2. ✅ Examined kobject reference counting mechanism
   (`amdgpu_get_xgmi_hive` calls `kobject_get`, `amdgpu_put_xgmi_hive`
   calls `kobject_put`)
3. ✅ Traced git history to find when the bug was introduced
4. ✅ Verified cleanup.h infrastructure availability across kernel
   versions
5. ✅ Analyzed all code paths in the affected function
6. ✅ Researched related XGMI hive leak fixes
7. ✅ Confirmed the fix is already in mainline (v6.18-rc1)

---

**FINAL VERDICT: YES - This commit should be backported to v6.16.x and
v6.17.x stable kernel trees.**

 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 7 +++----
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h   | 4 ++++
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 274bb4d857d36..56a737df87cc7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -6880,7 +6880,8 @@ pci_ers_result_t amdgpu_pci_error_detected(struct pci_dev *pdev, pci_channel_sta
 {
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	struct amdgpu_device *adev = drm_to_adev(dev);
-	struct amdgpu_hive_info *hive = amdgpu_get_xgmi_hive(adev);
+	struct amdgpu_hive_info *hive __free(xgmi_put_hive) =
+		amdgpu_get_xgmi_hive(adev);
 	struct amdgpu_reset_context reset_context;
 	struct list_head device_list;
 
@@ -6911,10 +6912,8 @@ pci_ers_result_t amdgpu_pci_error_detected(struct pci_dev *pdev, pci_channel_sta
 		amdgpu_device_recovery_get_reset_lock(adev, &device_list);
 		amdgpu_device_halt_activities(adev, NULL, &reset_context, &device_list,
 					      hive, false);
-		if (hive) {
+		if (hive)
 			mutex_unlock(&hive->hive_lock);
-			amdgpu_put_xgmi_hive(hive);
-		}
 		return PCI_ERS_RESULT_NEED_RESET;
 	case pci_channel_io_perm_failure:
 		/* Permanent error, prepare for device removal */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h
index bba0b26fee8f1..5f36aff17e79e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.h
@@ -126,4 +126,8 @@ uint32_t amdgpu_xgmi_get_max_bandwidth(struct amdgpu_device *adev);
 
 void amgpu_xgmi_set_max_speed_width(struct amdgpu_device *adev,
 				    uint16_t max_speed, uint8_t max_width);
+
+/* Cleanup macro for use with __free(xgmi_put_hive) */
+DEFINE_FREE(xgmi_put_hive, struct amdgpu_hive_info *, if (_T) amdgpu_put_xgmi_hive(_T))
+
 #endif
-- 
2.51.0

