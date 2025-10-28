Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476564A23;
	Tue, 28 Oct 2025 00:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761612007; cv=none; b=sdtA+/f+1H7J7rwXMJyDqLy8+9l0HzAbDZlcj8GSBSUaYdgESP+Wng+aEqDmwoBCCdXjnEnQO36pfvj9wIohEclPJpSXNmFRCn6B7kkinm1Z58kOwqPMlCu9R8ekjBFYyBU+1IwUp8aFCqO6tNjIIWDFfWGEXiYd9SgiGo1HGyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761612007; c=relaxed/simple;
	bh=TqwRwFFs387iVOAkocf+ezDLn2LssS+JbPqVIryJlgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u4QnCg6dFhhYXS5DaKO4qOk+PGFfCrrLpR1CnCnE6v9cyD35suAPLCpHRJQoDZ2ao0WecWFPmqMrWtfhkuEXIbXRRX4fqOPEu+HeY83+yXuadNSj16GTzW2yUxhBw5dOrwBxyCsACqKYWimhkKP4DhhSdxx2Z2UYbTdNf18f9aQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y6BwfASZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y6BwfASZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE2DC116B1;
	Tue, 28 Oct 2025 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761612007;
	bh=TqwRwFFs387iVOAkocf+ezDLn2LssS+JbPqVIryJlgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y6BwfASZ0SqfzKqTqd8s/dvlLex7+2mGPzmEnI5WKxGadqzmwrsaBy+PZEJ3rI+7t
	 jZS73PbTzrk4PUzRIlG4fbYGbVoSQY2ZQ/d2RtQ8Q9ti6IqDDdScFc5tHNRuSxRqc4
	 db1h7vN8tZ3io68vrzJcJ05CzvQL7MMIBBVMgcCBTMggW/2o5pXz8S6Eai19GqIBH+
	 8sSUpOCOoydar5IV9TEUqbSJmh3ic1qs6fjhw5hta9bSXWEFQWW+z+BKhmmdwBnfI1
	 fd14GjYKj690V6my0hspU2NxcHyAjewZx1NRIof0FXrO7fD4D7oD1GP6pFZeA4xV8L
	 YllJJi5U+x4MQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Felix.Kuehling@amd.com,
	amd-gfx@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.17] drm/amdkfd: fix suspend/resume all calls in mes based eviction path
Date: Mon, 27 Oct 2025 20:38:55 -0400
Message-ID: <20251028003940.884625-11-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251028003940.884625-1-sashal@kernel.org>
References: <20251028003940.884625-1-sashal@kernel.org>
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

From: Jonathan Kim <jonathan.kim@amd.com>

[ Upstream commit 079ae5118e1f0dcf5b1ab68ffdb5760b06ed79a2 ]

Suspend/resume all gangs should be done with the device lock is held.

Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## BACKPORT RECOMMENDATION: YES

### Summary
This commit fixes a **locking correctness bug** in the AMD KFD (GPU
compute) driver's MES-based eviction path. The bug allows
suspend_all_queues_mes() and resume_all_queues_mes() to be called
without holding the required device queue manager lock, creating race
conditions that can cause GPU hangs and system instability.

---

### Semantic Analysis Tools Used

1. **mcp__semcode__find_function**: Located evict_process_queues_cpsch,
   suspend_all_queues_mes, resume_all_queues_mes, and
   kfd_evict_process_device functions
2. **mcp__semcode__find_callers**: Identified 4 direct callers of
   kfd_evict_process_device:
   - kfd_set_dbg_ev_from_interrupt (debug interrupts)
   - kfd_dbg_send_exception_to_runtime (ioctl handler)
   - kfd_signal_vm_fault_event_with_userptr (VM fault handler)
   - cik_event_interrupt_wq (interrupt handler)
3. **mcp__semcode__find_callchain**: Traced call paths showing user-
   space can trigger this via kfd_ioctl_set_debug_trap
4. **Git history analysis**: Determined bug was introduced in v6.12
   (commit 9a16042f02cd0) and fixed in v6.18-rc2

---

### Code Analysis

**The Bug (OLD CODE in kfd_dqm_evict_pasid_mes):**
```c
dqm_lock(dqm);
if (qpd->evicted) { ... }
dqm_unlock(dqm);  // ← Lock released here

ret = suspend_all_queues_mes(dqm);  // ← Called WITHOUT lock
ret = dqm->ops.evict_process_queues(dqm, qpd);
ret = resume_all_queues_mes(dqm);  // ← Called WITHOUT lock
```

The old code released the dqm lock, then called suspend/resume without
re-acquiring it. This violates the locking contract stated in the commit
message: "Suspend/resume all gangs should be done with the device lock
is held."

**The Fix (NEW CODE in evict_process_queues_cpsch):**
```c
dqm_lock(dqm);  // ← Lock held from start
if (dqm->dev->kfd->shared_resources.enable_mes) {
    retval = suspend_all_queues_mes(dqm);  // ← Called WITH lock
    if (retval) goto out;
}
// ... eviction work ...
if (dqm->dev->kfd->shared_resources.enable_mes) {
    retval = resume_all_queues_mes(dqm);  // ← Called WITH lock
}
out:
    dqm_unlock(dqm);  // ← Lock held until end
```

The fix moves suspend/resume calls inside evict_process_queues_cpsch
where the dqm lock is held throughout the entire operation. It also:
- Eliminates the buggy kfd_dqm_evict_pasid_mes wrapper entirely
- Improves error handling with early exit on suspend failure
- Changes error path from continuing with `retval = err` to immediately
  exiting with `goto out`

---

### Impact Assessment

**Severity: Medium-High**
- **User-triggerable:** YES - via ioctl (kfd_ioctl_set_debug_trap) and
  VM fault handlers
- **Affected kernels:** v6.12 through v6.17 (6 major versions)
- **Subsystem criticality:** GPU compute device queue management
- **Potential consequences:**
  - Race conditions during queue eviction
  - GPU hangs and device state corruption
  - System instability
  - Possible kernel crashes

**Scope: Well-contained**
- Changes confined to AMD KFD driver (drivers/gpu/drm/amd/amdkfd/)
- Only affects MES-based queue eviction path
- No architectural changes or API modifications
- Eliminates 44 lines of buggy code, adds proper locking discipline

---

### Stable Tree Compliance

✅ **Fixes an important bug:** Locking correctness issue causing race
conditions
✅ **Does not introduce new features:** Pure bug fix
✅ **No architectural changes:** Refactors existing code path
✅ **Minimal regression risk:** Simplifies code and improves locking
discipline
✅ **Self-contained:** Limited to single driver subsystem
✅ **User-impacting:** Affects systems running AMD GPU compute workloads

⚠️ **Missing Fixes: tag:** The commit doesn't have "Fixes:
9a16042f02cd0" tag, but this doesn't disqualify it from backporting

---

### Recommendation Rationale

1. **Clear bug with clear fix:** The commit message explicitly states
   the locking requirement that was violated
2. **User-reachable code path:** Semantic analysis confirmed user-space
   can trigger this via ioctl
3. **Multi-version impact:** Bug has existed since v6.12 (June 2024),
   affecting 6 kernel versions
4. **Low backport risk:** Code change is straightforward - moves
   function calls inside locked region
5. **Historical precedent:** Similar locking fixes in this subsystem
   have been backported (e.g., commit 70df8273ca0ce)

This commit should be backported to **stable kernels v6.12+** to prevent
GPU hangs and system instability on AMD compute workloads.

 .../drm/amd/amdkfd/kfd_device_queue_manager.c | 73 ++++++-------------
 1 file changed, 21 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 6c5c7c1bf5eda..6e7bc983fc0b6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -1209,6 +1209,15 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 	pr_debug_ratelimited("Evicting process pid %d queues\n",
 			    pdd->process->lead_thread->pid);
 
+	if (dqm->dev->kfd->shared_resources.enable_mes) {
+		pdd->last_evict_timestamp = get_jiffies_64();
+		retval = suspend_all_queues_mes(dqm);
+		if (retval) {
+			dev_err(dev, "Suspending all queues failed");
+			goto out;
+		}
+	}
+
 	/* Mark all queues as evicted. Deactivate all active queues on
 	 * the qpd.
 	 */
@@ -1221,23 +1230,27 @@ static int evict_process_queues_cpsch(struct device_queue_manager *dqm,
 		decrement_queue_count(dqm, qpd, q);
 
 		if (dqm->dev->kfd->shared_resources.enable_mes) {
-			int err;
-
-			err = remove_queue_mes(dqm, q, qpd);
-			if (err) {
+			retval = remove_queue_mes(dqm, q, qpd);
+			if (retval) {
 				dev_err(dev, "Failed to evict queue %d\n",
 					q->properties.queue_id);
-				retval = err;
+				goto out;
 			}
 		}
 	}
-	pdd->last_evict_timestamp = get_jiffies_64();
-	if (!dqm->dev->kfd->shared_resources.enable_mes)
+
+	if (!dqm->dev->kfd->shared_resources.enable_mes) {
+		pdd->last_evict_timestamp = get_jiffies_64();
 		retval = execute_queues_cpsch(dqm,
 					      qpd->is_debug ?
 					      KFD_UNMAP_QUEUES_FILTER_ALL_QUEUES :
 					      KFD_UNMAP_QUEUES_FILTER_DYNAMIC_QUEUES, 0,
 					      USE_DEFAULT_GRACE_PERIOD);
+	} else {
+		retval = resume_all_queues_mes(dqm);
+		if (retval)
+			dev_err(dev, "Resuming all queues failed");
+	}
 
 out:
 	dqm_unlock(dqm);
@@ -3098,61 +3111,17 @@ int kfd_dqm_suspend_bad_queue_mes(struct kfd_node *knode, u32 pasid, u32 doorbel
 	return ret;
 }
 
-static int kfd_dqm_evict_pasid_mes(struct device_queue_manager *dqm,
-				   struct qcm_process_device *qpd)
-{
-	struct device *dev = dqm->dev->adev->dev;
-	int ret = 0;
-
-	/* Check if process is already evicted */
-	dqm_lock(dqm);
-	if (qpd->evicted) {
-		/* Increment the evicted count to make sure the
-		 * process stays evicted before its terminated.
-		 */
-		qpd->evicted++;
-		dqm_unlock(dqm);
-		goto out;
-	}
-	dqm_unlock(dqm);
-
-	ret = suspend_all_queues_mes(dqm);
-	if (ret) {
-		dev_err(dev, "Suspending all queues failed");
-		goto out;
-	}
-
-	ret = dqm->ops.evict_process_queues(dqm, qpd);
-	if (ret) {
-		dev_err(dev, "Evicting process queues failed");
-		goto out;
-	}
-
-	ret = resume_all_queues_mes(dqm);
-	if (ret)
-		dev_err(dev, "Resuming all queues failed");
-
-out:
-	return ret;
-}
-
 int kfd_evict_process_device(struct kfd_process_device *pdd)
 {
 	struct device_queue_manager *dqm;
 	struct kfd_process *p;
-	int ret = 0;
 
 	p = pdd->process;
 	dqm = pdd->dev->dqm;
 
 	WARN(debug_evictions, "Evicting pid %d", p->lead_thread->pid);
 
-	if (dqm->dev->kfd->shared_resources.enable_mes)
-		ret = kfd_dqm_evict_pasid_mes(dqm, &pdd->qpd);
-	else
-		ret = dqm->ops.evict_process_queues(dqm, &pdd->qpd);
-
-	return ret;
+	return dqm->ops.evict_process_queues(dqm, &pdd->qpd);
 }
 
 int reserve_debug_trap_vmid(struct device_queue_manager *dqm,
-- 
2.51.0

