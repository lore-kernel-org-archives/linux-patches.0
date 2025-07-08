Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B642E3385;
	Tue,  8 Jul 2025 16:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993019; cv=none; b=fkGgHkp9gMGRIhfgz3qTfqMG09MRasHeLPr/RERPWON4+x/XzEO8QaRdYOE1cJ/CT5WdOdyvX6EIUK/QgpQADi4aOdEgYkwn009Yr/SJshZHtVoyK193xswH4DcvO7PVQdJgp7Bx5r7baaMxSBw6UHnHxc1sBfXbTkE0LyA4A7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993019; c=relaxed/simple;
	bh=f5PoDmSIt5Uv4/Z1cegBDj0TWjvA/7tHfZOUhRYVleg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PgxAK4ySB8KqTshFSCjvHEPgpbeAvgVcNMiYXOVIK5OraJrgRlzo88cfa/CiJTWgqtoxHlNyAggp+C4nEqpXlpQPEW+6cZxadVbbisvPRq8ZVgT+URXk/h7QBWLvRXVi3Uv+rsiW4udLREASqvGdgrcYkH1NmyQBuO3pRerdERg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCYC0rgd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCYC0rgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A0DC4CEED;
	Tue,  8 Jul 2025 16:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993018;
	bh=f5PoDmSIt5Uv4/Z1cegBDj0TWjvA/7tHfZOUhRYVleg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCYC0rgdj6WT4LZbKB4NRsRT+zHphx9na/13n0NafV1JAQRTxnPd82gj23musti/N
	 bwwecJS8pKxA3Wo9hRSPRcb2ztq8bs9rbYzFMsV/nPOnHY/gzoDeOu3Qm0CtyIeUc4
	 oObN/J9DwVtYrYQZg7e4CnyiYQT5bKSdPSzh2z7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Nirmoy Das <nirmoy.das@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/232] drm/xe: Replace double space with single space after comma
Date: Tue,  8 Jul 2025 18:22:34 +0200
Message-ID: <20250708162245.571559021@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gote <nitin.r.gote@intel.com>

[ Upstream commit cd89de14bbacce1fc060fdfab75bacf95b1c5d40 ]

Avoid using double space, ",  " in function or macro parameters
where it's not required by any alignment purpose. Replace it with
a single space, ", ".

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240823080643.2461992-1-nitin.r.gote@intel.com
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Stable-dep-of: ad40098da5c3 ("drm/xe/guc: Explicitly exit CT safe mode on unwind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_reg_defs.h | 2 +-
 drivers/gpu/drm/xe/xe_guc.c           | 2 +-
 drivers/gpu/drm/xe/xe_guc_ct.c        | 4 ++--
 drivers/gpu/drm/xe/xe_irq.c           | 4 ++--
 drivers/gpu/drm/xe/xe_trace_bo.h      | 2 +-
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_reg_defs.h b/drivers/gpu/drm/xe/regs/xe_reg_defs.h
index 23f7dc5bbe995..51fd40ffafcb9 100644
--- a/drivers/gpu/drm/xe/regs/xe_reg_defs.h
+++ b/drivers/gpu/drm/xe/regs/xe_reg_defs.h
@@ -128,7 +128,7 @@ struct xe_reg_mcr {
  *       options.
  */
 #define XE_REG_MCR(r_, ...)	((const struct xe_reg_mcr){					\
-				 .__reg = XE_REG_INITIALIZER(r_,  ##__VA_ARGS__, .mcr = 1)	\
+				 .__reg = XE_REG_INITIALIZER(r_, ##__VA_ARGS__, .mcr = 1)	\
 				 })
 
 static inline bool xe_reg_is_valid(struct xe_reg r)
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 52df28032a6ff..c67d4807f37df 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -985,7 +985,7 @@ int xe_guc_mmio_send_recv(struct xe_guc *guc, const u32 *request,
 		BUILD_BUG_ON(FIELD_MAX(GUC_HXG_MSG_0_TYPE) != GUC_HXG_TYPE_RESPONSE_SUCCESS);
 		BUILD_BUG_ON((GUC_HXG_TYPE_RESPONSE_SUCCESS ^ GUC_HXG_TYPE_RESPONSE_FAILURE) != 1);
 
-		ret = xe_mmio_wait32(gt, reply_reg,  resp_mask, resp_mask,
+		ret = xe_mmio_wait32(gt, reply_reg, resp_mask, resp_mask,
 				     1000000, &header, false);
 
 		if (unlikely(FIELD_GET(GUC_HXG_MSG_0_ORIGIN, header) !=
diff --git a/drivers/gpu/drm/xe/xe_guc_ct.c b/drivers/gpu/drm/xe/xe_guc_ct.c
index 1f74f6bd50f31..483c2b521a2d1 100644
--- a/drivers/gpu/drm/xe/xe_guc_ct.c
+++ b/drivers/gpu/drm/xe/xe_guc_ct.c
@@ -182,7 +182,7 @@ int xe_guc_ct_init(struct xe_guc_ct *ct)
 	spin_lock_init(&ct->fast_lock);
 	xa_init(&ct->fence_lookup);
 	INIT_WORK(&ct->g2h_worker, g2h_worker_func);
-	INIT_DELAYED_WORK(&ct->safe_mode_worker,  safe_mode_worker_func);
+	INIT_DELAYED_WORK(&ct->safe_mode_worker, safe_mode_worker_func);
 	init_waitqueue_head(&ct->wq);
 	init_waitqueue_head(&ct->g2h_fence_wq);
 
@@ -851,7 +851,7 @@ static bool retry_failure(struct xe_guc_ct *ct, int ret)
 #define ct_alive(ct)	\
 	(xe_guc_ct_enabled(ct) && !ct->ctbs.h2g.info.broken && \
 	 !ct->ctbs.g2h.info.broken)
-	if (!wait_event_interruptible_timeout(ct->wq, ct_alive(ct),  HZ * 5))
+	if (!wait_event_interruptible_timeout(ct->wq, ct_alive(ct), HZ * 5))
 		return false;
 #undef ct_alive
 
diff --git a/drivers/gpu/drm/xe/xe_irq.c b/drivers/gpu/drm/xe/xe_irq.c
index 5f2c368c35adb..14c3a476597a7 100644
--- a/drivers/gpu/drm/xe/xe_irq.c
+++ b/drivers/gpu/drm/xe/xe_irq.c
@@ -173,7 +173,7 @@ void xe_irq_enable_hwe(struct xe_gt *gt)
 		if (ccs_mask & (BIT(0)|BIT(1)))
 			xe_mmio_write32(gt, CCS0_CCS1_INTR_MASK, ~dmask);
 		if (ccs_mask & (BIT(2)|BIT(3)))
-			xe_mmio_write32(gt,  CCS2_CCS3_INTR_MASK, ~dmask);
+			xe_mmio_write32(gt, CCS2_CCS3_INTR_MASK, ~dmask);
 	}
 
 	if (xe_gt_is_media_type(gt) || MEDIA_VER(xe) < 13) {
@@ -504,7 +504,7 @@ static void gt_irq_reset(struct xe_tile *tile)
 	if (ccs_mask & (BIT(0)|BIT(1)))
 		xe_mmio_write32(mmio, CCS0_CCS1_INTR_MASK, ~0);
 	if (ccs_mask & (BIT(2)|BIT(3)))
-		xe_mmio_write32(mmio,  CCS2_CCS3_INTR_MASK, ~0);
+		xe_mmio_write32(mmio, CCS2_CCS3_INTR_MASK, ~0);
 
 	if ((tile->media_gt &&
 	     xe_hw_engine_mask_per_class(tile->media_gt, XE_ENGINE_CLASS_OTHER)) ||
diff --git a/drivers/gpu/drm/xe/xe_trace_bo.h b/drivers/gpu/drm/xe/xe_trace_bo.h
index ba0f61e7d2d6b..4ff023b5d040d 100644
--- a/drivers/gpu/drm/xe/xe_trace_bo.h
+++ b/drivers/gpu/drm/xe/xe_trace_bo.h
@@ -189,7 +189,7 @@ DECLARE_EVENT_CLASS(xe_vm,
 			   ),
 
 		    TP_printk("dev=%s, vm=%p, asid=0x%05x", __get_str(dev),
-			      __entry->vm,  __entry->asid)
+			      __entry->vm, __entry->asid)
 );
 
 DEFINE_EVENT(xe_vm, xe_vm_kill,
-- 
2.39.5



