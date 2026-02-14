Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734CA1DDA18;
	Sat, 14 Feb 2026 01:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771031028; cv=none; b=bDs+CfXu2d5tn9AnkqnSTSJd9Tt9BVH5jgLhSgK2AzVIladXKUUVJo/gcR2HYXfToxJUVPvNorlfUW7tRHpP70QmBie0jAimjv5+tR+t/lcOGpp2KGzFUulyeoNeGpRpfnhHp35iG7wxXtZN1ZU0ftSO5P0NIIH85ic6frunOKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771031028; c=relaxed/simple;
	bh=hPlRERp8e3a9mf1CRq/xjD5rlY6nXdliey2/9dXtfhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYNc23J1ZV4K+bJaJxmjND/dOGazSd9SjkiTTwh8kfE7OiWymECBhSqw0tNzZx960CgdCWiy+9GEx0glif6hfAwzcBPvbTFpKos8tip1JxNVxbnQyqpdd422+FbiBn2b/1eYDjPGs1NV45nqjXFRd/u01tYqHMFr/DMIeCAeLQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dW7rIQfh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dW7rIQfh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F96C19424;
	Sat, 14 Feb 2026 01:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771031028;
	bh=hPlRERp8e3a9mf1CRq/xjD5rlY6nXdliey2/9dXtfhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dW7rIQfhvpb7N/oHEHqA4MKR+Cg+a4gW95akkUQqHaz3UpIU5/vfzecZKmSWI95x+
	 ucE0OU+nfXbPG+ALWYGZxOpBYcP8aEjV9JvYJbn9f8hO2nIv5LZH0a8Y1l0s+1Rr30
	 b7G17WxKJIaaPscCenjsNU4rg/eJrhUyCLE/ehrFGvFY3wE20jAxCTvCPGR8iaJCcO
	 2GuwfLAlATTcRDNEIZNCU4wAxrIeXdl6ptxNEJtlMa96pLaDJEC6d8vNUxfzF5XE3t
	 Z9JY1UVGLAjFALBtCs149xifpJ6uLDsy9PDLevfK591XjiGz63BIZHuNPtPd4IqFad
	 z2ntDbnFoU+Pw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com,
	intel-xe@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.19-6.18] drm/xe: Covert return of -EBUSY to -ENOMEM in VM bind IOCTL
Date: Fri, 13 Feb 2026 19:58:29 -0500
Message-ID: <20260214010245.3671907-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214010245.3671907-1-sashal@kernel.org>
References: <20260214010245.3671907-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 6028f59620927aee2e15a424004012ae05c50684 ]

xe_vma_userptr_pin_pages can return -EBUSY but -EBUSY has special
meaning in VM bind IOCTLs that user fence is pending that is attached to
the VMA. Convert -EBUSY to -ENOMEM in this case as -EBUSY in practice
means we are low or out of memory.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://patch.msgid.link/20251122012502.382587-2-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The v6.18 code exactly matches the "before" state of the diff. The patch
would apply cleanly to v6.18.y.

---

## Complete Analysis

### 1. COMMIT MESSAGE ANALYSIS

The subject "drm/xe: Covert return of -EBUSY to -ENOMEM in VM bind
IOCTL" (note: "Covert" is a typo for "Convert") describes a fix for
incorrect error code semantics. The commit message explains that
`xe_vma_userptr_pin_pages` can return -EBUSY, but -EBUSY has a
**dedicated meaning** in VM bind IOCTLs: it signals that a user fence
attached to the VMA is pending. Returning -EBUSY from a memory
allocation failure path causes userspace to misinterpret the error.

The commit has a "Reviewed-by:" tag from Tejas Upadhyay and is authored
by Matthew Brost, a key Intel Xe driver developer. No "Reported-by:"
tags, suggesting this was found through code review/development rather
than user reports.

### 2. CODE CHANGE ANALYSIS

The change is minimal (10 lines added, 1 changed in a single file). It
wraps the `xe_vma_userptr_pin_pages` call in the `new_vma()` function
with a brace block, adds a check for `err == -EBUSY`, and converts it to
`-ENOMEM` with a well-documented comment explaining the rationale.

The bug mechanism:
1. `new_vma()` is called during VM bind IOCTL operations for MAP
   operations
2. For userptr VMAs, it calls `xe_vma_userptr_pin_pages()`
3. This function calls `drm_gpusvm_get_pages()` which calls
   `hmm_range_fault()`
4. `hmm_range_fault()` can return -EBUSY when there's contention/memory
   pressure
5. After retries with timeout, `drm_gpusvm_get_pages` propagates -EBUSY
   out
6. This -EBUSY bubbles up to userspace through `new_vma` ->
   `vm_bind_ioctl_ops_parse` -> `xe_vm_bind_ioctl`
7. BUT -EBUSY in VM bind means "user fence is still pending" (see
   `check_ufence()` at line 2862-2875)
8. Userspace interprets -EBUSY as a fence pending signal, not an OOM
   condition

### 3. CLASSIFICATION

This is a **bug fix** that corrects incorrect IOCTL error semantics.
When a VM bind fails because HMM couldn't fault pages due to memory
pressure, userspace should receive -ENOMEM (indicating memory pressure)
rather than -EBUSY (which implies "try again later, fence is pending").
Returning the wrong error code could cause userspace GPU drivers (like
Mesa) to enter incorrect error recovery paths.

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed**: +10/-1 in a single file
- **Risk**: Very low. The change is purely error code translation on a
  specific error path
- **Subsystem**: Intel Xe GPU driver - a newer driver with an active
  user base
- **Could this break something?** Extremely unlikely. If userspace was
  incorrectly handling -EBUSY from this path by waiting for a fence, the
  fix actually improves behavior by returning a more actionable error
  code

### 5. USER IMPACT

- Users of Intel Xe GPUs (discrete and integrated, newer Intel hardware)
- Impact when triggered: Under memory pressure, the VM bind IOCTL
  returns wrong error code. Userspace may enter incorrect error handling
  path (expecting fence completion rather than memory pressure recovery)
- Trigger condition: Memory pressure causing HMM range fault timeouts -
  uncommon but possible under real workloads with heavy GPU usage

### 6. STABILITY INDICATORS

- Reviewed-by: Tejas Upadhyay (Intel)
- Author: Matthew Brost (Intel, core xe developer)
- Part of a 2-patch series, but this patch is self-contained (the
  companion commit 9fb1f1256e419 adds additional timeout, but -EBUSY
  already can happen without it)

### 7. DEPENDENCY CHECK

- The commit modifies `new_vma()` in `xe_vm.c`. The code structure
  matches v6.18 but NOT v6.12-v6.17 (different `new_vma` structure)
- The underlying `drm_gpusvm_get_pages` was introduced in v6.18 (via the
  drm_gpusvm move to xe_userptr.c)
- For v6.12.y (the most relevant LTS), the same bug exists but via
  `xe_hmm_userptr_populate_range`, and the fix would need manual
  adaptation
- For v6.18.y, the fix applies cleanly

### 8. ADDITIONAL OBSERVATIONS

The PREFETCH path at line 2740 has the same unhandled -EBUSY issue but
is NOT fixed by this commit. This is a minor concern but doesn't
invalidate the fix's value for the MAP path.

### VERDICT

This is a real bug fix that corrects incorrect IOCTL error semantics in
the Xe GPU driver. The wrong error code (-EBUSY vs -ENOMEM) could cause
userspace to mishandle memory pressure situations by thinking a fence is
pending. The fix is small, well-contained, low-risk, and has been
reviewed. It applies cleanly to v6.18.y (and conceptually to older trees
with adaptation). While the trigger condition (HMM timeout under memory
pressure) is not extremely common, the consequences of wrong error
handling in userspace can be significant (infinite waits, incorrect
retry behavior).

**YES**

 drivers/gpu/drm/xe/xe_vm.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 095bb197e8b05..9781209dd26ed 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -2451,8 +2451,17 @@ static struct xe_vma *new_vma(struct xe_vm *vm, struct drm_gpuva_op_map *op,
 		if (IS_ERR(vma))
 			return vma;
 
-		if (xe_vma_is_userptr(vma))
+		if (xe_vma_is_userptr(vma)) {
 			err = xe_vma_userptr_pin_pages(to_userptr_vma(vma));
+			/*
+			 * -EBUSY has dedicated meaning that a user fence
+			 * attached to the VMA is busy, in practice
+			 * xe_vma_userptr_pin_pages can only fail with -EBUSY if
+			 * we are low on memory so convert this to -ENOMEM.
+			 */
+			if (err == -EBUSY)
+				err = -ENOMEM;
+		}
 	}
 	if (err) {
 		prep_vma_destroy(vm, vma, false);
-- 
2.51.0

