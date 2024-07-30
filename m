Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60B018E02B;
	Tue, 30 Jul 2024 16:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356091; cv=none; b=BLVke6Y+W5XruERg9iNz8HSqY/2vrsAwC4mzbQF5Q2kcmzBLcSqrvfUS+8AbMoidfNaOyhJTNFyE8Fozt5C17W76rL3IkSvHVWsQVoFJqorYsD71FeVi8ouYEl+Foq9PnvoeHYqBdf/0JpH8/KBLztnj8hWZJxTwOHnghgJ8S+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356091; c=relaxed/simple;
	bh=1RY2qIpCBzFeDbLaZRC6MAQk+QX2qLTxsHE90v3K7C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEci1PWM1r27lyof/8qrUut5bwW1Ae4euY8xvCB8vITm+efjJnHnhsKb1yQupa7Ed0eEicf+AQ3w8jOCJafqTl289XZey0mE+xr1B1dj3thgUa2buPQZxzWJgxLp8BnWD0SNXfmHaYQg9PpVLXtSHhmwnVt30zkE9INCFcYo1Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uALUEj5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uALUEj5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B90C32782;
	Tue, 30 Jul 2024 16:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356091;
	bh=1RY2qIpCBzFeDbLaZRC6MAQk+QX2qLTxsHE90v3K7C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uALUEj5aKYgbm+y4PCd/LnGuET18xhZozpK7R8fTpG5FOsxSZesNeyP6B0wmsVI1I
	 lc6OGp3sg15kfJNUg8OTZIlJiCrz3g2OkITs8VQH4Gx0psAkNupHNyNaE6d3P6LTua
	 bX5b/Sc0HNZcM6FWKNNOIbXDjPBK+iI41vq2n6mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/440] drm/msm/dpu: drop validity checks for clear_pending_flush() ctl op
Date: Tue, 30 Jul 2024 17:46:28 +0200
Message-ID: <20240730151621.932487664@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3632f0768aa9e..1bf41a82cd0f9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -1653,8 +1653,7 @@ void dpu_encoder_trigger_kickoff_pending(struct drm_encoder *drm_enc)
 		phys = dpu_enc->phys_encs[i];
 
 		ctl = phys->hw_ctl;
-		if (ctl->ops.clear_pending_flush)
-			ctl->ops.clear_pending_flush(ctl);
+		ctl->ops.clear_pending_flush(ctl);
 
 		/* update only for command mode primary ctl */
 		if ((phys == dpu_enc->cur_master) &&
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
index 42c7e378d504d..05a09d86e1838 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder_phys_wb.c
@@ -548,8 +548,7 @@ static void dpu_encoder_phys_wb_disable(struct dpu_encoder_phys *phys_enc)
 	}
 
 	/* reset h/w before final flush */
-	if (phys_enc->hw_ctl->ops.clear_pending_flush)
-		phys_enc->hw_ctl->ops.clear_pending_flush(phys_enc->hw_ctl);
+	phys_enc->hw_ctl->ops.clear_pending_flush(phys_enc->hw_ctl);
 
 	/*
 	 * New CTL reset sequence from 5.0 MDP onwards.
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.h
index 96c012ec84676..ec5265771cdf7 100644
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



