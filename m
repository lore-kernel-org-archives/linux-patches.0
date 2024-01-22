Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C8D6A320;
	Tue, 23 Jan 2024 02:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975345; cv=none; b=DHKN0lVSoaeSMlSU63zbSkqo5fUjRtDB+KFiQw/0A3/ct66HyzETGG5mul9fH9xZz1UXxXLDtcwzrC3f2OTdtrh8n5gleAeTZ3FwUTk4pYRX8fbWfKbWeFd8HQUAqmgXYKZ8uYpTPvSAfUUmeJAomrVOeHbydGbfuPKUyeioJVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975345; c=relaxed/simple;
	bh=G03V0MO601oyhjy+/uT4cAsBUzgp8Me1YiEz7qmtitc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i0yvSmA4qul3NqWfxsVzcS7BYT/Stuid7V+0nh4txDaZCzU6/PuxRGfyw+/WyrAee+ZnXNXbtn+oTeQpn6Lwg5Mh0CA1dPSRyM+fLCxBq5Nbgd6jEr3UsvPT/Itx8vTIQFz26JXItAjbFywJ+iP9RcUkAcdW+Anh2Gdeoeax5jc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FEdTurdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FEdTurdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766E3C43394;
	Tue, 23 Jan 2024 02:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975345;
	bh=G03V0MO601oyhjy+/uT4cAsBUzgp8Me1YiEz7qmtitc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEdTurdyd6x7p2+z0yaEIvn9hPoQUuNQgMod6ff8KK0E1tzzT9pfn2A71Vp3zOJkb
	 +Hieb/ZU+8XYjsmAm4wf+VEr4m6gEuuMScTaTe3208wMGiToCAuaT1WDWmKfEfS2An
	 ph7oPewaluri+yk3qaLeCWX85opjptSJSXQV9Yeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/583] drm/msm/dpu: Set input_sel bit for INTF
Date: Mon, 22 Jan 2024 15:55:34 -0800
Message-ID: <20240122235820.659483383@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 980fffd0c69e5df0f67ee089d405899d532aeeab ]

Set the input_sel bit for encoders as it was missed in the initial
implementation.

Reported-by: Rob Clark <robdclark@gmail.com>
Closes: https://gitlab.freedesktop.org/drm/msm/-/issues/39
Fixes: 91143873a05d ("drm/msm/dpu: Add MISR register support for interface")
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/572007/
Link: https://lore.kernel.org/r/20231213-encoder-fixup-v4-1-6da6cd1bf118@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c   | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c | 9 +++++++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h | 3 ++-
 4 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
index 8ec6505d9e78..bce8783d644c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
@@ -320,7 +320,7 @@ static u32 dpu_hw_intf_get_line_count(struct dpu_hw_intf *intf)
 
 static void dpu_hw_intf_setup_misr(struct dpu_hw_intf *intf, bool enable, u32 frame_count)
 {
-	dpu_hw_setup_misr(&intf->hw, INTF_MISR_CTRL, enable, frame_count);
+	dpu_hw_setup_misr(&intf->hw, INTF_MISR_CTRL, enable, frame_count, 0x1);
 }
 
 static int dpu_hw_intf_collect_misr(struct dpu_hw_intf *intf, u32 *misr_value)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
index d1c3bd8379ea..a34cf8c979cb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
@@ -83,7 +83,7 @@ static void dpu_hw_lm_setup_border_color(struct dpu_hw_mixer *ctx,
 
 static void dpu_hw_lm_setup_misr(struct dpu_hw_mixer *ctx, bool enable, u32 frame_count)
 {
-	dpu_hw_setup_misr(&ctx->hw, LM_MISR_CTRL, enable, frame_count);
+	dpu_hw_setup_misr(&ctx->hw, LM_MISR_CTRL, enable, frame_count, 0x0);
 }
 
 static int dpu_hw_lm_collect_misr(struct dpu_hw_mixer *ctx, u32 *misr_value)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c
index 9d2273fd2fed..da04a914b065 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c
@@ -481,9 +481,13 @@ void _dpu_hw_setup_qos_lut(struct dpu_hw_blk_reg_map *c, u32 offset,
 		      cfg->danger_safe_en ? QOS_QOS_CTRL_DANGER_SAFE_EN : 0);
 }
 
+/*
+ * note: Aside from encoders, input_sel should be set to 0x0 by default
+ */
 void dpu_hw_setup_misr(struct dpu_hw_blk_reg_map *c,
 		u32 misr_ctrl_offset,
-		bool enable, u32 frame_count)
+		bool enable, u32 frame_count,
+		u8 input_sel)
 {
 	u32 config = 0;
 
@@ -494,7 +498,8 @@ void dpu_hw_setup_misr(struct dpu_hw_blk_reg_map *c,
 
 	if (enable) {
 		config = (frame_count & MISR_FRAME_COUNT_MASK) |
-			MISR_CTRL_ENABLE | MISR_CTRL_FREE_RUN_MASK;
+			MISR_CTRL_ENABLE | MISR_CTRL_FREE_RUN_MASK |
+			((input_sel & 0xF) << 24);
 
 		DPU_REG_WRITE(c, misr_ctrl_offset, config);
 	} else {
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h
index 1f6079f47071..f7061fcc97f7 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h
@@ -360,7 +360,8 @@ void _dpu_hw_setup_qos_lut(struct dpu_hw_blk_reg_map *c, u32 offset,
 void dpu_hw_setup_misr(struct dpu_hw_blk_reg_map *c,
 		u32 misr_ctrl_offset,
 		bool enable,
-		u32 frame_count);
+		u32 frame_count,
+		u8 input_sel);
 
 int dpu_hw_collect_misr(struct dpu_hw_blk_reg_map *c,
 		u32 misr_ctrl_offset,
-- 
2.43.0



