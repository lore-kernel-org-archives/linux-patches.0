Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6471C4ED4;
	Tue, 27 Aug 2024 14:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770610; cv=none; b=YkCQ9+kpKZLeXn+4AwVBKfENwfNY9pukF/qwHxryNrxMPgyEj7GYidAxRqCotBGb+f4/le6qWdAkyxUeHXpptg0wGJTpARXjKw6gDWdPwkdeilSs+DJdoERAW0CP8kSmw2YEdgB/BOEsqDx3IEyapePxgGN+kB20JwDAFfdmoXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770610; c=relaxed/simple;
	bh=IBq/USgdp2KUgNEAzoiOAfEcX9hXNTVaukADS3jla1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VkOe9qIut4vts+kU0r8od+5sD8tZBALug8ymYfdGdl3M7246+mhETowWfSasODtajlMyrfLHg42AiCwkj1KeuOEoOSyDDcVQzvj/tSJsbhO7B44WtGmHyxskfms6eG6hF+o+WXMG8zh2OOZgFkAoxpok6wupDC0GFJIifa6x/1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OSZCR/EH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OSZCR/EH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E51AC4FE01;
	Tue, 27 Aug 2024 14:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770610;
	bh=IBq/USgdp2KUgNEAzoiOAfEcX9hXNTVaukADS3jla1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSZCR/EHdlG2dS59mTW2RiXoh3PJednlz8bCOLZ+m++4iXa9RGDLC9tUC+y4K9uWz
	 V4k1OytmMoQ1P1rczxoc4VhkeYYm1XCh1F+QVl+RbVSCS/dWWpsXJqDNe6xm56n30+
	 qZEAm0HnQAYv+IaDsUpc51+RNBtrPNcm2qZDQmfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 280/341] drm/msm/dpu: drop MSM_ENC_VBLANK support
Date: Tue, 27 Aug 2024 16:38:31 +0200
Message-ID: <20240827143854.055969028@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit a08935fc859b22884dcb6b5126d3a986467101ce ]

There are no in-kernel users of MSM_ENC_VBLANK wait type. Drop it
together with the corresponding wait_for_vblank callback.

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/560701/
Link: https://lore.kernel.org/r/20231004031903.518223-1-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: aedf02e46eb5 ("drm/msm/dpu: move dpu_encoder's connector assignment to atomic_enable()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c   |  3 --
 .../gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h  |  1 -
 .../drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c  | 28 -------------------
 .../drm/msm/disp/dpu1/dpu_encoder_phys_vid.c  |  9 +++---
 drivers/gpu/drm/msm/msm_drv.h                 |  2 --
 5 files changed, 4 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 781adb5e2c595..57001543dc220 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2441,9 +2441,6 @@ int dpu_encoder_wait_for_event(struct drm_encoder *drm_enc,
 		case MSM_ENC_TX_COMPLETE:
 			fn_wait = phys->ops.wait_for_tx_complete;
 			break;
-		case MSM_ENC_VBLANK:
-			fn_wait = phys->ops.wait_for_vblank;
-			break;
 		default:
 			DPU_ERROR_ENC(dpu_enc, "unknown wait event %d\n",
 					event);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
index 99997707b0ee9..57a3598f2a303 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys.h
@@ -106,7 +106,6 @@ struct dpu_encoder_phys_ops {
 	int (*control_vblank_irq)(struct dpu_encoder_phys *enc, bool enable);
 	int (*wait_for_commit_done)(struct dpu_encoder_phys *phys_enc);
 	int (*wait_for_tx_complete)(struct dpu_encoder_phys *phys_enc);
-	int (*wait_for_vblank)(struct dpu_encoder_phys *phys_enc);
 	void (*prepare_for_kickoff)(struct dpu_encoder_phys *phys_enc);
 	void (*handle_post_kickoff)(struct dpu_encoder_phys *phys_enc);
 	void (*trigger_start)(struct dpu_encoder_phys *phys_enc);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
index 548be5cf07be8..83a804ebf8d7e 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_cmd.c
@@ -681,33 +681,6 @@ static int dpu_encoder_phys_cmd_wait_for_commit_done(
 	return _dpu_encoder_phys_cmd_wait_for_ctl_start(phys_enc);
 }
 
-static int dpu_encoder_phys_cmd_wait_for_vblank(
-		struct dpu_encoder_phys *phys_enc)
-{
-	int rc = 0;
-	struct dpu_encoder_phys_cmd *cmd_enc;
-	struct dpu_encoder_wait_info wait_info;
-
-	cmd_enc = to_dpu_encoder_phys_cmd(phys_enc);
-
-	/* only required for master controller */
-	if (!dpu_encoder_phys_cmd_is_master(phys_enc))
-		return rc;
-
-	wait_info.wq = &cmd_enc->pending_vblank_wq;
-	wait_info.atomic_cnt = &cmd_enc->pending_vblank_cnt;
-	wait_info.timeout_ms = KICKOFF_TIMEOUT_MS;
-
-	atomic_inc(&cmd_enc->pending_vblank_cnt);
-
-	rc = dpu_encoder_helper_wait_for_irq(phys_enc,
-			phys_enc->irq[INTR_IDX_RDPTR],
-			dpu_encoder_phys_cmd_te_rd_ptr_irq,
-			&wait_info);
-
-	return rc;
-}
-
 static void dpu_encoder_phys_cmd_handle_post_kickoff(
 		struct dpu_encoder_phys *phys_enc)
 {
@@ -735,7 +708,6 @@ static void dpu_encoder_phys_cmd_init_ops(
 	ops->wait_for_commit_done = dpu_encoder_phys_cmd_wait_for_commit_done;
 	ops->prepare_for_kickoff = dpu_encoder_phys_cmd_prepare_for_kickoff;
 	ops->wait_for_tx_complete = dpu_encoder_phys_cmd_wait_for_tx_complete;
-	ops->wait_for_vblank = dpu_encoder_phys_cmd_wait_for_vblank;
 	ops->trigger_start = dpu_encoder_phys_cmd_trigger_start;
 	ops->needs_single_flush = dpu_encoder_phys_cmd_needs_single_flush;
 	ops->irq_control = dpu_encoder_phys_cmd_irq_control;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
index ab26e21871235..daaf0e6047538 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_vid.c
@@ -443,7 +443,7 @@ static void dpu_encoder_phys_vid_enable(struct dpu_encoder_phys *phys_enc)
 		phys_enc->enable_state = DPU_ENC_ENABLING;
 }
 
-static int dpu_encoder_phys_vid_wait_for_vblank(
+static int dpu_encoder_phys_vid_wait_for_tx_complete(
 		struct dpu_encoder_phys *phys_enc)
 {
 	struct dpu_encoder_wait_info wait_info;
@@ -557,7 +557,7 @@ static void dpu_encoder_phys_vid_disable(struct dpu_encoder_phys *phys_enc)
 	 * scanout buffer) don't latch properly..
 	 */
 	if (dpu_encoder_phys_vid_is_master(phys_enc)) {
-		ret = dpu_encoder_phys_vid_wait_for_vblank(phys_enc);
+		ret = dpu_encoder_phys_vid_wait_for_tx_complete(phys_enc);
 		if (ret) {
 			atomic_set(&phys_enc->pending_kickoff_cnt, 0);
 			DRM_ERROR("wait disable failed: id:%u intf:%d ret:%d\n",
@@ -577,7 +577,7 @@ static void dpu_encoder_phys_vid_disable(struct dpu_encoder_phys *phys_enc)
 		spin_lock_irqsave(phys_enc->enc_spinlock, lock_flags);
 		dpu_encoder_phys_inc_pending(phys_enc);
 		spin_unlock_irqrestore(phys_enc->enc_spinlock, lock_flags);
-		ret = dpu_encoder_phys_vid_wait_for_vblank(phys_enc);
+		ret = dpu_encoder_phys_vid_wait_for_tx_complete(phys_enc);
 		if (ret) {
 			atomic_set(&phys_enc->pending_kickoff_cnt, 0);
 			DRM_ERROR("wait disable failed: id:%u intf:%d ret:%d\n",
@@ -682,8 +682,7 @@ static void dpu_encoder_phys_vid_init_ops(struct dpu_encoder_phys_ops *ops)
 	ops->disable = dpu_encoder_phys_vid_disable;
 	ops->control_vblank_irq = dpu_encoder_phys_vid_control_vblank_irq;
 	ops->wait_for_commit_done = dpu_encoder_phys_vid_wait_for_commit_done;
-	ops->wait_for_vblank = dpu_encoder_phys_vid_wait_for_vblank;
-	ops->wait_for_tx_complete = dpu_encoder_phys_vid_wait_for_vblank;
+	ops->wait_for_tx_complete = dpu_encoder_phys_vid_wait_for_tx_complete;
 	ops->irq_control = dpu_encoder_phys_vid_irq_control;
 	ops->prepare_for_kickoff = dpu_encoder_phys_vid_prepare_for_kickoff;
 	ops->handle_post_kickoff = dpu_encoder_phys_vid_handle_post_kickoff;
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index 02fd6c7d0bb7b..182543c92770c 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -78,12 +78,10 @@ enum msm_dsi_controller {
  * enum msm_event_wait - type of HW events to wait for
  * @MSM_ENC_COMMIT_DONE - wait for the driver to flush the registers to HW
  * @MSM_ENC_TX_COMPLETE - wait for the HW to transfer the frame to panel
- * @MSM_ENC_VBLANK - wait for the HW VBLANK event (for driver-internal waiters)
  */
 enum msm_event_wait {
 	MSM_ENC_COMMIT_DONE = 0,
 	MSM_ENC_TX_COMPLETE,
-	MSM_ENC_VBLANK,
 };
 
 /**
-- 
2.43.0



