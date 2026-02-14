Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A59017B506;
	Sat, 14 Feb 2026 01:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031053; cv=none; b=Zmrs8kLNVdZjEOZ9WmnWhZt1F93MdrvEkSwwXpK45L5NyEaAEbCeS/kZNSZmqLnbTo70+wQHBGiC+d0JkBJwd+KoFIuDMwLAw9a/uEteVZFPK1nOMlQJzXedXV5OaVkXdqwBVfVeyf6mMi4nKablQmSp1Y6JcfzzeQhnbNZ4d/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031053; c=relaxed/simple;
	bh=p71mMz0IC1MIscie+d7MkQBSyCRrnzfcrjqGsOqFv8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sD0v2agWlTq1M1BAn90tENmRZrfJkiroipzQRUc6WoLKQZl1fvfAPjZBKqTAuEhxevWyWV/BNbPOEPO6WPZTfTrFMCfScTPnqbUMB+mrrWd3tZrznuDdhYbkyCkOUp2mz3Z5431cIMPKwWjvuKqyNOLNq16Imcx8ChP1ejel/O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXGgAL0O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXGgAL0O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18833C16AAE;
	Sat, 14 Feb 2026 01:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031052;
	bh=p71mMz0IC1MIscie+d7MkQBSyCRrnzfcrjqGsOqFv8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXGgAL0OoexfiPMUcAohbp50QEEBGph1c8C8xwe5MhCQ6/xNbSs3S62glfb9P7beW
	 tIc89t7cpdk/xacxxTns3k4+J6ycARV0YX0FpdpJIcS/loj0Eb8Ju2mzWEHdBQw5qp
	 ywjtAK9OnprJ3fqUw163PwWIzWnYA7tyFdCsMnwsNI1W5kSOugSKy0C+OiJKhK9ncr
	 PYJSicZMPM/WH9h+riIRh48kj55+saXFBEPEp490k+EfOE2wrkuMcAggBx5zpODHbP
	 svQccXTTEscNEdv1diO3yVM65EsYn6scPO8b66YEpyDKHHzLNl/L2Oo3cYaxSU1tRt
	 miCmEIhOaGcoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/xe/vm: Skip ufence association for CPU address mirror VMA during MAP
Date: Fri, 13 Feb 2026 19:58:40 -0500
Message-ID: <20260214010245.3671907-40-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>

[ Upstream commit 7f08cc5b3cc3bf6416f8b55bff906f67ed75637d ]

The MAP operation for a CPU address mirror VMA does not require ufence
association because such mappings are not GPU-synchronized and do not
participate in GPU job completion signaling.

Remove the unnecessary ufence addition for this case to avoid -EBUSY
failure in check_ufence of unbind ops.

Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251125075628.1182481-6-himal.prasad.ghimiray@intel.com
Signed-off-by: Himal Prasad Ghimiray <himal.prasad.ghimiray@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The code structure in v6.15 is identical to the code being patched. The
fix would apply cleanly.

---

## Complete Analysis

### 1. Commit Message Analysis

The subject "drm/xe/vm: Skip ufence association for CPU address mirror
VMA during MAP" clearly describes a fix that avoids an unnecessary
operation that causes failures. The key phrase is "avoid -EBUSY failure
in check_ufence of unbind ops" - this explicitly identifies the user-
visible bug.

### 2. Code Change Analysis

The change is minimal - a 2-line modification adding a condition:

```c
case DRM_GPUVA_OP_MAP:
- vma_add_ufence(op->map.vma, ufence);
+   if (!xe_vma_is_cpu_addr_mirror(op->map.vma))
+       vma_add_ufence(op->map.vma, ufence);
    break;
```

### 3. Bug Mechanism (Detailed)

The bug flow is:

1. **User performs MAP on a CPU address mirror VMA with a user fence
   sync**: The MAP operation goes through `vm_bind_ioctl_ops_execute()`
   → `ops_execute()`. Since CPU address mirror VMAs don't produce GPU
   page table updates at MAP time (they use fault-based binding),
   `vm_ops_setup_tile_args()` returns `number_tiles == 0`, and
   `ops_execute()` returns `-ENODATA`.

2. **Ufence erroneously stored on VMA**: On the `-ENODATA` path,
   `vm_bind_ioctl_ops_fini(vm, vops, NULL)` is called. This calls
   `op_add_ufence()` → `vma_add_ufence()`, storing a ufence reference on
   the VMA. The ufence is eventually signaled asynchronously via
   `vm_bind_ioctl_signal_fences()`, but there's a window where it hasn't
   signaled yet.

3. **Subsequent unbind fails with -EBUSY**: When a subsequent UNMAP or
   REMAP targets this VMA, `op_lock_and_prep()` calls `check_ufence()`
   (lines 2947, 2962 of `xe_vm.c`). If the ufence hasn't been signaled
   yet, `xe_sync_ufence_get_status()` returns 0, and `check_ufence()`
   returns `-EBUSY`, blocking the entire unbind operation.

4. **Root cause**: CPU address mirror VMAs "are not GPU-synchronized and
   do not participate in GPU job completion signaling." Associating a
   ufence with them is semantically incorrect - there's no GPU work to
   protect against, so the ufence guard on unbind is meaningless and
   harmful.

### 4. Classification

This is a **logic error/bug fix** that prevents spurious `-EBUSY` errors
returned to userspace. It is NOT a feature, cleanup, or refactoring.

### 5. Scope and Risk

- **Lines changed**: 2 (adding a condition check)
- **Files touched**: 1 (`drivers/gpu/drm/xe/xe_vm.c`)
- **Risk**: Very low. The condition `xe_vma_is_cpu_addr_mirror()` is
  already used extensively in this file (23 call sites). The change only
  affects CPU address mirror VMAs during MAP; all other VMA types and
  operations are completely unaffected.
- **Reviewed-by**: Matthew Brost (Intel Xe driver maintainer), providing
  high confidence.

### 6. User Impact

- **Who is affected**: All users of Intel Xe GPU driver SVM (Shared
  Virtual Memory / CPU address mirror) functionality. This is the Intel
  discrete GPU driver used in modern Intel GPUs (Arc, etc.).
- **Severity**: Medium-High. The `-EBUSY` error causes bind ioctls to
  fail, blocking GPU memory management operations. This could cause
  application failures or require workarounds.

### 7. Stability in Stable Trees

- The CPU address mirror VMA feature exists since v6.15 (commit
  `6fd979c2f3315`).
- The `op_add_ufence()` function has identical code in v6.15, v6.18, and
  v6.19.
- The `xe_vma_is_cpu_addr_mirror()` helper exists in all these versions.
- The fix applies cleanly with no dependencies on other patches.

### 8. Dependencies

The fix is **self-contained**. While it's patch 6 of a series (from the
message-id), this specific change only adds a condition to an existing
function using an existing helper. It does not depend on any other
patches in the series.

### Verdict

This is a small, surgical fix for a real user-visible bug (-EBUSY
failures on SVM VMA unbind operations). It meets all stable kernel
criteria: obviously correct, fixes a real bug, small scope, well-
reviewed, no new features, and applies cleanly to stable trees
(v6.15.y+).

**YES**

 drivers/gpu/drm/xe/xe_vm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 9781209dd26ed..612fc5b2539cd 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -3223,7 +3223,8 @@ static void op_add_ufence(struct xe_vm *vm, struct xe_vma_op *op,
 {
 	switch (op->base.op) {
 	case DRM_GPUVA_OP_MAP:
-		vma_add_ufence(op->map.vma, ufence);
+		if (!xe_vma_is_cpu_addr_mirror(op->map.vma))
+			vma_add_ufence(op->map.vma, ufence);
 		break;
 	case DRM_GPUVA_OP_REMAP:
 		if (op->remap.prev)
-- 
2.51.0

