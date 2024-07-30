Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2CF155CB3;
	Tue, 30 Jul 2024 16:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358255; cv=none; b=QMITfDf+FK9RU7B7xfQGKQgNA8zwolve1dHsTdcUoNafxStB+HolEPmJPDwrbJ9K5+8jqwlg14aFQOIWSS5dult2NGI3C2QXfKHIx9pLTFETV+sFwthSqETb659arY46A4eNTTh84FMJt6BX9aXBo3A2Iad5IqhYhfLeOUM0el4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358255; c=relaxed/simple;
	bh=QvTBFMZDBkVgYH4bvZcp79ePTr059fJyCpfEajQEtnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oJVWpcvdMF2uyVTxz2Ss4/A+x1l2KXR26ydnIjgziU02DbL46CRG2nBlc70H1s+pz6mypALEyHxgFu8fEeKc9W2fbHBq8Jz1z1dmjZq+hgZ9YUWsebggZJN7tn/0JF0uSVEjDaZ40qWHyqiIY3Ba42PYHlS1TfUfvWXt5oMc4sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qo6KH1Mt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qo6KH1Mt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52CF6C4AF0A;
	Tue, 30 Jul 2024 16:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358255;
	bh=QvTBFMZDBkVgYH4bvZcp79ePTr059fJyCpfEajQEtnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qo6KH1Mtdzg//ZSbvV6PuD3KGRkaZ9CwIP3MsdXXitkSZdmcwCcaJJAfByKSz9FcP
	 dNdDJU4o67yh/msUaq2RFcS2zm1k986vywIz+mou0I/Ut/TDisecrxpRpv/dcEPiOl
	 CkTMqMjMVmDtIu1mmFXjWkyfWupNG0zuLtdzDBWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 339/809] drm/msm/dpu: drop validity checks for clear_pending_flush() ctl op
Date: Tue, 30 Jul 2024 17:43:35 +0200
Message-ID: <20240730151738.013398696@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abhinav Kumar <quic_abhinavk@quicinc.com>

[ Upstream commit 3d68e3dedd4b48f0358bdc187277e3315d8aa559 ]

clear_pending_flush() ctl op is always assigned irrespective of the DPU
hardware revision. Hence there is no needed to check whether the op has
been assigned before calling it.

Drop the checks across the driver for clear_pending_flush() and also
update its documentation that it is always expected to be assigned.

changes in v2:
	- instead of adding more validity checks just drop the one for clear_pending_flush
	- update the documentation for clear_pending_flush() ctl op
	- update the commit text reflecting these changes

changes in v3:
	- simplify the documentation of clear_pending_flush

Fixes: d7d0e73f7de3 ("drm/msm/dpu: introduce the dpu_encoder_phys_* for writeback")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/464fbd84-0d1c-43c3-a40b-31656ac06456@moroto.mountain/T/
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/600241/
Link: https://lore.kernel.org/r/20240620201731.3694593-1-quic_abhinavk@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c         | 3 +--
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c | 3 +--
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h          | 3 ++-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 708657598cce4..697ad4a640516 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1743,8 +1743,7 @@ void dpu_encoder_trigger_kickoff_pending(struct drm_encoder *drm_enc)
 		phys = dpu_enc->phys_encs[i];
 
 		ctl = phys->hw_ctl;
-		if (ctl->ops.clear_pending_flush)
-			ctl->ops.clear_pending_flush(ctl);
+		ctl->ops.clear_pending_flush(ctl);
 
 		/* update only for command mode primary ctl */
 		if ((phys == dpu_enc->cur_master) &&
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 356dca5e5ea94..882c717859cec 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -538,8 +538,7 @@ static void dpu_encoder_phys_wb_disable(struct dpu_encoder_phys *phys_enc)
 	}
 
 	/* reset h/w before final flush */
-	if (phys_enc->hw_ctl->ops.clear_pending_flush)
-		phys_enc->hw_ctl->ops.clear_pending_flush(phys_enc->hw_ctl);
+	phys_enc->hw_ctl->ops.clear_pending_flush(phys_enc->hw_ctl);
 
 	/*
 	 * New CTL reset sequence from 5.0 MDP onwards.
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
index ef56280bea932..4401fdc0f3e4f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
@@ -83,7 +83,8 @@ struct dpu_hw_ctl_ops {
 
 	/**
 	 * Clear the value of the cached pending_flush_mask
-	 * No effect on hardware
+	 * No effect on hardware.
+	 * Required to be implemented.
 	 * @ctx       : ctl path ctx pointer
 	 */
 	void (*clear_pending_flush)(struct dpu_hw_ctl *ctx);
-- 
2.43.0



