Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B5715699E;
	Tue, 30 Jul 2024 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357139; cv=none; b=Z9xjKCKmoEU0BVEzMgvmVft+An5RN0rX1eUQmv+0ZQJS7VqeZXU2OQUkHNQxUK4fzUvfLKWGMPj8ZqDSuwBrt78eRPkm2yoWzVHvVKYmcvP+EQeunEZxffjlnI+5JUApYFPYWX7JMBtRVZekzxXo+qw0X3jPHO2Y/Hs7SwCxpZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357139; c=relaxed/simple;
	bh=TuPGVofSTDbUJeogxri2zOklkzaXZO57V8wEHlFcxJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRlEHFkBeMYe1XwOXiMVl+gzpwa6FKZHP/bp71+KBJIsVzMPQnTyK+6QAf+rGEPddoPjFa10HZkrsZcbPhSQbeZoVHb4/WvaXD+4L3stimzoKplwpo1dfKcg47VdjyhibmdrRzIaoVSMi6nY0UUQz8InfeQtknEk5A7ngsH4dpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvX3uceS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvX3uceS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41350C32782;
	Tue, 30 Jul 2024 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357139;
	bh=TuPGVofSTDbUJeogxri2zOklkzaXZO57V8wEHlFcxJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvX3uceSPZZW/JlQsE1rN4g3lMByLSkJ3Osf0561S7ML5N3I5ZdQ9US7bE2sxWxrW
	 bPG6rjh80UZPqknmXzs7SmRjaq7i6rOzgeLYHLnBmOOLSDGIHCb4BH+nnrRoywousL
	 2Ul/x665jEVMI59QAAsOvIdgLG6kJZHyCXYOAdtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 223/568] drm/msm/dpu: drop validity checks for clear_pending_flush() ctl op
Date: Tue, 30 Jul 2024 17:45:30 +0200
Message-ID: <20240730151648.598523273@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index 5fb7e2e10801d..e454b80907121 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1672,8 +1672,7 @@ void dpu_encoder_trigger_kickoff_pending(struct drm_encoder *drm_enc)
 		phys = dpu_enc->phys_encs[i];
 
 		ctl = phys->hw_ctl;
-		if (ctl->ops.clear_pending_flush)
-			ctl->ops.clear_pending_flush(ctl);
+		ctl->ops.clear_pending_flush(ctl);
 
 		/* update only for command mode primary ctl */
 		if ((phys == dpu_enc->cur_master) &&
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 870a1f5060e30..a81a9ee71a86c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -528,8 +528,7 @@ static void dpu_encoder_phys_wb_disable(struct dpu_encoder_phys *phys_enc)
 	}
 
 	/* reset h/w before final flush */
-	if (phys_enc->hw_ctl->ops.clear_pending_flush)
-		phys_enc->hw_ctl->ops.clear_pending_flush(phys_enc->hw_ctl);
+	phys_enc->hw_ctl->ops.clear_pending_flush(phys_enc->hw_ctl);
 
 	/*
 	 * New CTL reset sequence from 5.0 MDP onwards.
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
index 1c242298ff2ee..dca87ea78e251 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
@@ -81,7 +81,8 @@ struct dpu_hw_ctl_ops {
 
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



