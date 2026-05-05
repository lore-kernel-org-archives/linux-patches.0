Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717523DDDC4;
	Tue,  5 May 2026 09:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974802; cv=none; b=PvhinCG79IR0fstlnvH1sRU+P1gqKNZ3oY7oS8SXJjb75vswHyy8QnJqjZlvpskfJmvWJmDsios7H6P/3OWiuC/MVjE1+dlBLbBg3NNuQWGDrBak/3OcAooEnuWGhpMxXS71xS+ShKvMCQPpswmBkfN3uwvFVez2MwotonO6I0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974802; c=relaxed/simple;
	bh=XQCROlKft5wVj5I9yTAn2YjpISfn8SpYZY1bJexHqxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NIMcv7ctczPJnMjllkAQKPWxUCH8f0gAXmUM8EPKZIRaiSrY1YBDIL3JDLbqnrGUjOlf3bkOqPr4ecL9Qc2x9eeNT+7Ae4IbiXhZwoWKPtXYxDq8JBa0NNJLoe+oiHFDvn3VY8uZsythr+s3poDyHs9lOwOFfhzDtTumH0vjk6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IBCDcP3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IBCDcP3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070F2C2BCB4;
	Tue,  5 May 2026 09:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974802;
	bh=XQCROlKft5wVj5I9yTAn2YjpISfn8SpYZY1bJexHqxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBCDcP3ISBaVcx4upCyMln9GHHVc6P7dLw7QOAcqm8KshUBDANb2Yo5481ns19S1W
	 u2Y7LI+LmM40tQQXLpKmMVI/R7Q/JXwwt7nQQVC8iXkJ4HBWFhChWitCW+YyaA9ZMe
	 6mq/KlQRK6n4w1a95Vz5H7Cr4U5e3YC90AuPmS+LZtLwx2vH09jNiIySmhwtdZ8z/7
	 ogDqwMjRE3EIOLc80Fuotk2g5JMkGbBOd1IGH7qPXsk7R7wTGj/toU+KQc5R9mHQ1+
	 k6i0fGyM7z7HbSCt8T8baQUOTluvfFEmNzfdztSRQd8ARfG8vUnc0L6B05caC8Uxsl
	 yxySiO3iBKhqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: YuanShang <YuanShang.Mao@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	christian.koenig@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0] drm/amdkfd: check if vm ready in svm map and unmap to gpu
Date: Tue,  5 May 2026 05:51:45 -0400
Message-ID: <20260505095149.512052-29-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260505095149.512052-1-sashal@kernel.org>
References: <20260505095149.512052-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YuanShang <YuanShang.Mao@amd.com>

[ Upstream commit d0f5711fa14a09c010537375cf34893cd33bc2ee ]

Don't map or unmap svm range to gpu if vm is not ready for updates.

Why: DRM entity may already be killed when the svm worker try to
update gpu vm.

Signed-off-by: YuanShang <YuanShang.Mao@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 55f8e366c326980174a4f2b9501b524d8eb25135)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics
Step 1.1 Record: Subsystem `drm/amdkfd`, action verb `check`, intent:
avoid SVM GPU VM map/unmap when the AMDGPU VM cannot accept updates.

Step 1.2 Record: Tags found in the actual commit: `Signed-off-by:
YuanShang <YuanShang.Mao@amd.com>`, `Reviewed-by: Philip Yang
<philip.yang@amd.com>`, `Signed-off-by: Alex Deucher
<alexander.deucher@amd.com>`. No `Fixes:`, no `Reported-by:`, no
`Tested-by:`, no `Cc: stable`.

Step 1.3 Record: The commit says the SVM worker may try to update a GPU
VM after the DRM scheduler entity has already been killed. The user-
visible symptom was verified from the lore thread: “Trying to push to a
killed entity”, SDMA timeout, GPU reset, and a hung
`svm_range_restore_work` kworker blocked in `dma_fence_wait_timeout()`
via `svm_range_validate_and_map()`.

Step 1.4 Record: This is a hidden bug fix despite the neutral “check”
wording. It prevents submitting VM update jobs to a stopped/killed VM
update entity, which otherwise can leave fences unsignaled and hang
worker context.

## Phase 2: Diff Analysis
Step 2.1 Record: One file changed:
`drivers/gpu/drm/amd/amdkfd/kfd_svm.c`, 11 insertions. Modified
functions: `svm_range_unmap_from_gpu()` and `svm_range_map_to_gpu()`.
Scope: single-file surgical fix.

Step 2.2 Record: Before, both SVM unmap and map directly called
`amdgpu_vm_update_range()`. After, both first call `amdgpu_vm_ready(vm)`
and return `-EINVAL` if the VM is not ready. Affected path is VM page
table update submission from SVM map/unmap, including restore worker and
MMU notifier/unmap paths.

Step 2.3 Record: Bug category is synchronization/lifetime correctness
around process teardown. `amdgpu_vm_ready()` in current mainline
verifies the VM is not evicting, has no evicted PTs, and its
immediate/delayed VM update scheduler entities are not stopped. The fix
avoids queueing jobs after those entities are killed.

Step 2.4 Record: Fix quality is good: 11 lines, no new API, no feature,
no data structure changes. Regression risk is low, mainly early
returning `-EINVAL` when VM updates cannot run anyway. Backport risk is
higher for older trees because `amdgpu_vm_ready()` only gained stopped-
entity checks in commit `f101c13a8720c7`; older stable trees need that
or an equivalent prerequisite for this patch to address the killed-
entity failure.

## Phase 3: Git History Investigation
Step 3.1 Record: Blame shows SVM map/unmap infrastructure was introduced
by `f80fe9d3c114` (“drm/amdkfd: map svm range to GPUs”, first in
`v5.14-rc1`) and later reshaped by commits including `6c1a7867734`
(`v5.18-rc1`). The missing readiness guard has existed in these SVM
paths for a long time.

Step 3.2 Record: No `Fixes:` tag, so no direct target to follow.

Step 3.3 Record: Recent file history contains many SVM fixes, including
UAF, address conversion, PTE clearing, restore work, and retry-fault
race fixes. Related commit `597eb70f7ff7` / upstream `10c382ec6c6d`
(“drm/amdkfd: Don’t clear PT after process killed”) added an
`amdgpu_vm_ready()` guard in a different KFD GPUVM path and was
explicitly stable-tagged.

Step 3.4 Record: `git log --author='YuanShang' -10 --
drivers/gpu/drm/amd/amdkfd` produced no reachable prior commits in this
checkout. The patch was reviewed by Philip Yang, a regular AMD KFD
contributor, and committed by Alex Deucher.

Step 3.5 Record: Dependency identified: `f101c13a8720c7` (“drm/amdgpu:
fix task hang from failed job submission during process kill”) teaches
`amdgpu_vm_ready()` to check stopped VM update entities. Without it,
this candidate’s guard does not fully detect the killed-entity condition
in older stable trees.

## Phase 4: Mailing List And External Research
Step 4.1 Record: `b4 dig -c 55f8e366c326...` found the original
submission at `https://patch.msgid.link/20260326103656.487304-1-
YuanShang.Mao@amd.com`. `b4 dig -a` found only v1, standalone. WebFetch
to lore was blocked by Anubis, but `b4 dig -m` retrieved the mbox
successfully.

Step 4.2 Record: `b4 dig -w` showed original recipients were YuanShang
and `amd-gfx@lists.freedesktop.org`. The thread later included Christian
König and Philip Yang.

Step 4.3 Record: No separate bugzilla/syzbot link. The thread itself
contains the bug log: killed entity error, SDMA timeout, GPU reset,
recovered wedge, and hung kworker in `svm_range_restore_work`.

Step 4.4 Record: Philip Yang stated the earlier “Don’t clear PT after
process killed” patch fixed one path and this patch fixes another path,
then gave `Reviewed-by: Philip Yang <philip.yang@amd.com>`. No NAKs
found.

Step 4.5 Record: Stable-specific web search could not be verified
because WebFetch to lore/stable timed out or hit Anubis. No stable
nomination for this exact patch found in the mbox.

## Phase 5: Code Semantic Analysis
Step 5.1 Record: Key functions: `svm_range_unmap_from_gpu()`,
`svm_range_map_to_gpu()`.

Step 5.2 Record: Callers verified: `svm_range_unmap_from_gpu()` is
called by `svm_range_unmap_from_gpus()`, reached from CPU unmap/MMU
notifier handling and SVM validation with PROT_NONE.
`svm_range_map_to_gpu()` is called by `svm_range_map_to_gpus()`, reached
from `svm_range_validate_and_map()`.

Step 5.3 Record: Key callees: both changed functions call
`amdgpu_vm_update_range()`. For SDMA VM updates, that path
allocates/submits an AMDGPU job; `amdgpu_job_submit()` arms the
scheduler job and calls `drm_sched_entity_push_job()`.

Step 5.4 Record: Reachability verified: `svm_range_restore_work()` calls
`svm_range_validate_and_map()`, which calls `svm_range_map_to_gpus()`
and then `svm_range_map_to_gpu()`. The lore log shows exactly this call
chain in a hung kworker. GPU page fault and MMU notifier paths also
reach the same validation/unmap functions.

Step 5.5 Record: Similar pattern verified: `amdgpu_amdkfd_gpuvm.c`
already has an `amdgpu_vm_ready()` guard with the comment “VM entity
stopped if process killed”; `amdgpu_cs.c` and `amdgpu_gem.c` also check
VM readiness before clearing freed mappings.

## Phase 6: Stable Tree Analysis
Step 6.1 Record: The SVM map/unmap functions exist in `v5.15`, `v6.1`,
`v6.6`, and `v6.8`, and none of those extracted versions had the new
guards. The reported log was from Ubuntu `6.8.0-90-generic`, confirming
a stable-derived affected kernel.

Step 6.2 Record: Backport difficulty: minor to moderate. `v6.8`, `v6.6`,
and `v6.1` have the same conceptual functions but older
`amdgpu_vm_update_range()` signatures. `v5.15` uses older
`amdgpu_vm_bo_update_mapping()` in this path. Older trees also need
`f101c13a8720c7` or equivalent stopped-entity readiness logic.

Step 6.3 Record: Related fix `597eb70f7ff7`/`10c382ec6c6d` addresses a
different process-kill VM update path and was stable-tagged. It does not
cover SVM map/unmap; Philip Yang explicitly confirmed this patch fixes
another path.

## Phase 7: Subsystem Context
Step 7.1 Record: Subsystem is AMDGPU KFD SVM/HMM GPU memory management.
Criticality: important, affecting AMD compute users using KFD SVM, GPU
page faults, migration, and process teardown.

Step 7.2 Record: Subsystem is active; recent history shows many SVM
correctness fixes. The bug is in a mature path present since `v5.14+`,
not just brand-new code.

## Phase 8: Impact And Risk
Step 8.1 Record: Affected population is driver/config/hardware specific:
AMDGPU KFD users with SVM-capable compute workloads.

Step 8.2 Record: Trigger requires SVM VM update work racing with forced
process kill or teardown after VM scheduler entities are stopped. The
lore log verifies a real trigger. Whether it is fully unprivileged
depends on render/KFD device permissions and was not independently
verified.

Step 8.3 Record: Failure mode is severe: verified killed-entity error,
SDMA ring timeout, GPU reset, recovered device wedge, and hung kworker
for more than 245 seconds. Severity: HIGH, arguably CRITICAL for
affected systems.

Step 8.4 Record: Benefit is high for affected AMD KFD users because it
avoids a real hung-task/GPU-reset failure. Risk is low in mainline-
shaped code because the fix only refuses impossible VM updates. Risk for
older stable trees is manageable but requires prerequisite/backport care
around `amdgpu_vm_ready()` semantics.

## Phase 9: Final Synthesis
Step 9.1 Record: Evidence for backporting: real user log, severe
hang/GPU reset, small surgical fix, reviewed by Philip Yang, related
already-stable process-kill fix shows same class of bug, affected code
exists in stable-derived kernels. Evidence against: no `Fixes:` or `Cc:
stable`, and older trees need dependency/backport adjustment.
Unresolved: exact clean-apply status for every active stable branch was
not tested.

Step 9.2 Record: Stable rules checklist: obviously correct and reviewed:
yes, with dependency caveat. Fixes real bug: yes, verified by lore log.
Important issue: yes, hung task/GPU reset. Small and contained: yes, 11
lines in one file. No new feature/API: yes. Applies to stable: likely
needs minor backport adjustment and `f101c13a8720c7` or equivalent for
older trees.

Step 9.3 Record: No exception category applies; this is not a device ID,
quirk, DT, build, or documentation-only patch.

Step 9.4 Record: Decision is to backport, but not as an isolated blind
cherry-pick to older stable trees. It should be taken with the stopped-
entity readiness prerequisite/backport so `amdgpu_vm_ready()` actually
detects the process-kill condition.

## Verification
- Phase 1: Parsed target commit with `git show`; confirmed tags and no
  `Fixes:`/stable tag.
- Phase 2: Diff verified as 11 insertions in
  `svm_range_unmap_from_gpu()` and `svm_range_map_to_gpu()`.
- Phase 3: `git blame` verified SVM map/unmap history; `git describe
  --contains` placed the original SVM mapping in `v5.14-rc1` and later
  function reshaping in `v5.18-rc1`.
- Phase 3: `git show f101c13a8720c7` verified `amdgpu_vm_ready()` gained
  stopped-entity checks.
- Phase 3: `git show 597eb70f7ff7` verified the related stable-tagged
  “Don’t clear PT after process killed” guard in another path.
- Phase 4: `b4 dig`, `b4 dig -a`, `b4 dig -w`, and decoded mbox verified
  the lore thread, single v1 patch, recipients, log, Christian’s “Looks
  correct”, and Philip’s `Reviewed-by`.
- Phase 5: `rg` and file reads traced map/unmap callers through
  `svm_range_validate_and_map()` and `svm_range_restore_work()`.
- Phase 6: Extracted `v5.15`, `v6.1`, `v6.6`, and `v6.8` files; verified
  the affected SVM functions exist without the new guard.
- Phase 8: Lore log verified severity: killed entity, SDMA timeout, GPU
  reset, device wedge recovery, and hung kworker.
- UNVERIFIED: WebFetch lore/stable searches were blocked/timed out, and
  I did not test applying the patch to each stable branch.

**YES**

 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 080242f9981b0..addb86803d9ae 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1363,6 +1363,12 @@ svm_range_unmap_from_gpu(struct amdgpu_device *adev, struct amdgpu_vm *vm,
 
 	pr_debug("CPU[0x%llx 0x%llx] -> GPU[0x%llx 0x%llx]\n", start, last,
 		gpu_start, gpu_end);
+
+	if (!amdgpu_vm_ready(vm)) {
+		pr_debug("VM not ready, canceling unmap\n");
+		return -EINVAL;
+	}
+
 	return amdgpu_vm_update_range(adev, vm, false, true, true, false, NULL, gpu_start,
 				      gpu_end, init_pte_value, 0, 0, NULL, NULL,
 				      fence);
@@ -1440,6 +1446,11 @@ svm_range_map_to_gpu(struct kfd_process_device *pdd, struct svm_range *prange,
 	pr_debug("svms 0x%p [0x%lx 0x%lx] readonly %d\n", prange->svms,
 		 last_start, last_start + npages - 1, readonly);
 
+	if (!amdgpu_vm_ready(vm)) {
+		pr_debug("VM not ready, canceling map\n");
+		return -EINVAL;
+	}
+
 	for (i = offset; i < offset + npages; i++) {
 		uint64_t gpu_start;
 		uint64_t gpu_end;
-- 
2.53.0

