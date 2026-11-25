Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618813;
	b=G/+/uIRhmWlkmUqSVERHZFO3Ycrm7sVFB8q+ZELGa8bMehMWnYnIk3sOHy3PbfIXRBeF
	 xdc+8QQ9HgnAovvHGtQt3kuGw2oX/Ppm+1eIFc+gbvfTAmlVBwNJpgBiP1/56WMYhk6nx
	 j/MTKmW2qvbKAoLR6VaX1tH8o96tH1UQi6Ls3nlzINhDBBrdeXSWRxHbPufq6O/LNTuqS
	 R4kHdPacmCl8LyAjQSiIZVwrTjYnMl7056r5mXLkpOYGvMj6gmONa54Ju1iTM+PzUAzzS
	 in2n91O1lFmR9/gK/CRN7q8jfCa76Uh6qlocIUIQPaIj7TA+pwrPZ9jHCSjO/BY33Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SGYaQb4EpkHZrrs/dzUyssDZDGNJIw6AdfxvJP3+HiI=;
	b=f5sTf96Yh9A/JWxZYK32QQv7dDOGTblAnqFNJNAW2+HfePcOzLLo8ez2lHGLBhlxdhx8
	 6KdCXhhyBEksJutAxu5l1Wywl0ccJDlVlDgYUuvkYqKH7rZRSvZNMc96Q0NM8dq+yrUNc
	 C6U842RNi17okLPcDQuGrpQawBPq9tek0Ewt8jRbNCmCcPC4tTeNWq3DZZ+AI6Iit56ee
	 mL/+8QpnXQMhKsUeaSa+IJgMr7/De63lf+sm4Fi0/bpW37F3Cg3IlTKp5sbkIcjtUWxoH
	 lFR1Ao/uhgaKTrywNSp4u0XzlGvDYjlLdkX/jbGmGwBPbp9G4pPDqYrA1YeBy9xGXUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqfvIf2g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D282D606A327;
	Wed, 25 Nov 2026 15:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqfvIf2g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1C71F000C0;
	Wed, 25 Nov 2026 15:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618813;
	bh=SGYaQb4EpkHZrrs/dzUyssDZDGNJIw6AdfxvJP3+HiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqfvIf2gw3LVMv8s8zMcUN5ve3moEuzi3cJSDATXYcNTTunJvhJiuIbH8u5xeAuN6
	 RiD8jjwlrfuHuLmpSXFGSyJ3RmEhV2sPaLbEg1FvJ4DGFjiY8MhPAW+HoJyIb751r2
	 KUs2yiTrPEEnbfl34BHJemJXFb9jU5r0fu33eTJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raag Jadav <raag.jadav@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0396/1005] drm/xe/gt: Use GT ordered workqueue for wedging
Date: Wed, 25 Nov 2026 15:28:54 +0100
Message-ID: <20261125143831.021873771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 8801081e5991e4939dc2d04564c46f33c3efe18d ]

Currently, xe_gt_declare_wedged() stops GuC CT and initiates exec queue
teardown synchronously. This can result in tdr timeout in cases where
the device is declared wedged while jobs are still in-flight.

Introduce a worker for GT specific wedge handling and queue the teardown
on GT ordered workqueue, so we don't disrupt the scheduler while jobs
are still in-flight.

While at it, introduce for_each_initialized_gt() macro and use it for
wedging GT. This helps avoid races in case the device is declared wedged
in probe sequence before GT is initialized.

Fixes: c9474b726b93 ("drm/xe: Wedge the entire device")
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20261022051303.282805-2-raag.jadav@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 913d394eb2be6536c66995affde44255d1e36493)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c   |  2 +-
 drivers/gpu/drm/xe/xe_device.h   |  4 ++++
 drivers/gpu/drm/xe/xe_gt.c       | 39 ++++++++++++++++++++++++--------
 drivers/gpu/drm/xe/xe_gt_types.h |  9 ++++++++
 drivers/gpu/drm/xe/xe_guc.c      |  1 -
 5 files changed, 44 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index e76edcf15159e..f161f010d0ef4 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -1482,7 +1482,7 @@ void xe_device_declare_wedged(struct xe_device *xe)
 			dev_name(xe->drm.dev));
 	}
 
-	for_each_gt(gt, xe, id)
+	for_each_initialized_gt(gt, xe, id)
 		xe_gt_declare_wedged(gt);
 
 	if (xe_device_wedged(xe)) {
diff --git a/drivers/gpu/drm/xe/xe_device.h b/drivers/gpu/drm/xe/xe_device.h
index 6c4cfaebc44a0..1bfd641fea278 100644
--- a/drivers/gpu/drm/xe/xe_device.h
+++ b/drivers/gpu/drm/xe/xe_device.h
@@ -139,6 +139,10 @@ static inline bool xe_device_uc_enabled(struct xe_device *xe)
 	for_each_gt((gt__), (tile__)->xe, (id__)) \
 		for_each_if((gt__)->tile == (tile__))
 
+#define for_each_initialized_gt(gt__, xe__, id__) \
+	for_each_gt((gt__), (xe__), (id__)) \
+		for_each_if(READ_ONCE((gt__)->initialized))
+
 static inline struct xe_force_wake *gt_to_fw(struct xe_gt *gt)
 {
 	return &gt->pm.fw;
diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 57e302604f3dc..ca7f9b806bac9 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -172,6 +172,7 @@ static void xe_gt_enable_comp_1wcoh(struct xe_gt *gt)
 }
 
 static void gt_reset_worker(struct work_struct *w);
+static void gt_wedge_worker(struct work_struct *w);
 
 static int emit_job_sync(struct xe_exec_queue *q, struct xe_bb *bb,
 			 long timeout_jiffies, bool force_reset)
@@ -543,6 +544,8 @@ int xe_gt_init_early(struct xe_gt *gt)
 	xe_gt_mcr_init_early(gt);
 	xe_pat_init(gt);
 
+	INIT_WORK(&gt->reset.worker, gt_reset_worker);
+	INIT_WORK(&gt->wedge.worker, gt_wedge_worker);
 	return 0;
 }
 
@@ -621,16 +624,21 @@ static int gt_init_with_gt_forcewake(struct xe_gt *gt)
 	return 0;
 }
 
-static void gt_reset_worker_disable(void *arg)
+static void gt_worker_disable(void *arg)
 {
 	struct xe_gt *gt = arg;
 
+	WRITE_ONCE(gt->initialized, false);
+
 	if (disable_work_sync(&gt->reset.worker))
 		/*
 		 * If gt_reset_worker was halted from executing, take care of
 		 * releasing the rpm reference here.
 		 */
 		xe_pm_runtime_put(gt_to_xe(gt));
+
+	if (disable_work_sync(&gt->wedge.worker))
+		xe_pm_runtime_put(gt_to_xe(gt));
 }
 
 static int gt_init_with_all_forcewake(struct xe_gt *gt)
@@ -703,7 +711,7 @@ static int gt_init_with_all_forcewake(struct xe_gt *gt)
 		xe_gt_sriov_pf_init_hw(gt);
 
 	/* Last action registered here so devres drains resets before teardown */
-	err = devm_add_action_or_reset(xe->drm.dev, gt_reset_worker_disable, gt);
+	err = devm_add_action_or_reset(xe->drm.dev, gt_worker_disable, gt);
 	if (err)
 		return err;
 
@@ -715,7 +723,7 @@ static void xe_gt_fini(void *arg)
 	struct xe_gt *gt = arg;
 	int i;
 
-	gt_reset_worker_disable(gt);
+	gt_worker_disable(gt);
 
 	for (i = 0; i < XE_ENGINE_CLASS_MAX; ++i)
 		xe_hw_fence_irq_finish(&gt->fence_irq[i]);
@@ -728,8 +736,6 @@ int xe_gt_init(struct xe_gt *gt)
 	int err;
 	int i;
 
-	INIT_WORK(&gt->reset.worker, gt_reset_worker);
-
 	for (i = 0; i < XE_ENGINE_CLASS_MAX; ++i) {
 		gt->ring_ops[i] = xe_ring_ops_get(gt, i);
 		xe_hw_fence_irq_init(&gt->fence_irq[i]);
@@ -759,7 +765,7 @@ int xe_gt_init(struct xe_gt *gt)
 
 	err = gt_init_with_all_forcewake(gt);
 	if (err) {
-		gt_reset_worker_disable(gt);
+		gt_worker_disable(gt);
 		return err;
 	}
 
@@ -775,6 +781,8 @@ int xe_gt_init(struct xe_gt *gt)
 			return err;
 	}
 
+	/* Must be last */
+	WRITE_ONCE(gt->initialized, true);
 	return 0;
 }
 
@@ -1192,6 +1200,15 @@ struct xe_hw_engine *xe_gt_any_hw_engine(struct xe_gt *gt)
 	return NULL;
 }
 
+static void gt_wedge_worker(struct work_struct *w)
+{
+	struct xe_gt *gt = container_of(w, typeof(*gt), wedge.worker);
+
+	xe_uc_declare_wedged(&gt->uc);
+	xe_tlb_inval_reset(&gt->tlb_inval);
+	xe_pm_runtime_put(gt_to_xe(gt));
+}
+
 /**
  * xe_gt_declare_wedged() - Declare GT wedged
  * @gt: the GT object
@@ -1201,8 +1218,12 @@ struct xe_hw_engine *xe_gt_any_hw_engine(struct xe_gt *gt)
  */
 void xe_gt_declare_wedged(struct xe_gt *gt)
 {
-	xe_gt_assert(gt, gt_to_xe(gt)->wedged.mode);
+	struct xe_device *xe = gt_to_xe(gt);
 
-	xe_uc_declare_wedged(&gt->uc);
-	xe_tlb_inval_reset(&gt->tlb_inval);
+	xe_gt_assert(gt, xe->wedged.mode);
+	xe_uc_reset_prepare(&gt->uc);
+
+	xe_pm_runtime_get_noresume(xe);
+	if (!queue_work(gt->ordered_wq, &gt->wedge.worker))
+		xe_pm_runtime_put(xe);
 }
diff --git a/drivers/gpu/drm/xe/xe_gt_types.h b/drivers/gpu/drm/xe/xe_gt_types.h
index a8bbfbdf38494..5bb2d0281a0a5 100644
--- a/drivers/gpu/drm/xe/xe_gt_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_types.h
@@ -213,6 +213,12 @@ struct xe_gt {
 		struct work_struct worker;
 	} reset;
 
+	/** @wedge: state for GT wedge */
+	struct {
+		/** @wedge.worker: worker for GT wedge to be done async */
+		struct work_struct worker;
+	} wedge;
+
 	/** @tlb_inval: TLB invalidation state */
 	struct xe_tlb_inval tlb_inval;
 
@@ -390,6 +396,9 @@ struct xe_gt {
 
 	/** @eu_stall: EU stall counters subsystem per gt info */
 	struct xe_eu_stall_gt *eu_stall;
+
+	/** @initialized: GT is initialized */
+	bool initialized;
 };
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index c988a2a3b7bdb..944f88ee40a0b 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -1837,7 +1837,6 @@ void xe_guc_declare_wedged(struct xe_guc *guc)
 {
 	xe_gt_assert(guc_to_gt(guc), guc_to_xe(guc)->wedged.mode);
 
-	xe_guc_reset_prepare(guc);
 	xe_guc_ct_stop(&guc->ct);
 	xe_guc_submit_wedge(guc);
 }
-- 
2.53.0



