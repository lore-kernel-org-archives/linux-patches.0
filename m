Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A12B4A27;
	Tue, 23 Jan 2024 00:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969594; cv=none; b=eQvaMG3yalQFwOQ+d77jB8pmtaWD9al83/m7HXHI+nDqYAeVOdgSKuO+4DAGYxf+LBKSYtcYIIK4p4irN6Hoa9k2j9eau/+fpHjpBzHNsZkOfcsshXFj7Qgp8SJF0FIpgNQADkkrNrPWVjPISN33ijXC9ZQ3vX+EvsZlWv2Ty+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969594; c=relaxed/simple;
	bh=OJ4Deh6PVb8P1OUlCjOIWJQztUqLfV0dEOwjyVHWhTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P135o/QizH1c//d4pvz6DTZOV2E1Pt9x+VuN2PIbr/MccWflT/8C1P8PpvsPm3MDAXYr/zvsSDZVB209jESky633m45apv/AcRxwEbHGHr+nZTOn8H21s5Uxbh3h1VKOnekdNIvvFtNnxON1KSqJr3IvPsXWTNJcTbkSPE1azyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1OjZS/wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1OjZS/wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A88C433B1;
	Tue, 23 Jan 2024 00:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969594;
	bh=OJ4Deh6PVb8P1OUlCjOIWJQztUqLfV0dEOwjyVHWhTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1OjZS/wrDjvoyG/CCDB7S+eH5iY5LHuxkp8/cwyfDKRXK/m7oQrnuQ2qrarTz5hs/
	 YJszzXBvj1am5F9VmDkSCPpFiWgWL3XbAnjttdmMrKg+qrOMGhcp6xgvkEV3hWrvAW
	 HDN++lg3A9x1xInaoBZivU9nQfqgJQGwfKqlgoH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@gmail.com>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 321/641] drm/msm/dpu: Set input_sel bit for INTF
Date: Mon, 22 Jan 2024 15:53:45 -0800
Message-ID: <20240122235827.928568594@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index e8b8908d3e12..813bfde6832a 100644
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
index 18b16b2d2bf5..b328fe22abde 100644
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
index 4bea139081bc..3feb6043e251 100644
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



