Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C631762806;
	Tue, 23 Jan 2024 00:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971224; cv=none; b=e6Q6tWtO2ka5hBTHpFIqjZkM34gFNAWZTi/yX7XqXXzl0FxW88mpZ+6q1HVCquVUgRAkDQRUoKsjivkGEkbcZ6qM1XJHWK/0jtWu6k7m1k8j4PfBe63gX4X7KnhnvLlvkBZJfNyln9AJ6IlpNw+5Yf40Idv8aUeI85tpjeRJNII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971224; c=relaxed/simple;
	bh=7eyMmtMHOUIlTa67Qf0FWLuOQ5/p+eclpS5GCGtyemY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BLwSAuSxgcI1FS0VRFv3nsHqDM1tORGV2POMNpjTp8ZkYXVRpswSldmowRJ1Ev/wdpbM5uJOpMlwOHy1tF+HYkrrsIzGZVo5vXsv5SCyXOg7TbArcFEeYSW//MNhO65x63VaVdVuusMCxCr7SKAvseXVYgVqNqI7V8avBtjbG1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPjtRXRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPjtRXRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61412C43390;
	Tue, 23 Jan 2024 00:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971224;
	bh=7eyMmtMHOUIlTa67Qf0FWLuOQ5/p+eclpS5GCGtyemY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPjtRXREq3ed5gTwugwTUgo0q8/QrVhtFxcR7BolnXFCtpQBHgBlx0zDxhQqFin7v
	 ri+BmIAaYVUAzKL5Sd9OISfbXAFT41Z7N36vHdJeUshuJNlyb6t7BQswSj/jAHnJ/6
	 obcSxll56TN44ETo/868pit5/Qr5tVs/6KMzuoIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 206/417] drm/msm/dpu: Drop enable and frame_count parameters from dpu_hw_setup_misr()
Date: Mon, 22 Jan 2024 15:56:14 -0800
Message-ID: <20240122235759.068006652@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Jessica Zhang <quic_jesszhan@quicinc.com>

[ Upstream commit 3313c23f3eab698bc6b904520ee608fc0f7b03d0 ]

Drop the enable and frame_count parameters from dpu_hw_setup_misr() as they
are always set to the same values.

In addition, replace MISR_FRAME_COUNT_MASK with MISR_FRAME_COUNT as
frame_count is always set to the same value.

Fixes: 7b37523fb1d1 ("drm/msm/dpu: Move MISR methods to dpu_hw_util")
Signed-off-by: Jessica Zhang <quic_jesszhan@quicinc.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/572009/
Link: https://lore.kernel.org/r/20231213-encoder-fixup-v4-2-6da6cd1bf118@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c    |  4 ++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c |  4 ++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c |  6 +++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h |  4 ++--
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c   |  6 +++---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.h   |  3 ++-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c | 19 +++++--------------
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h |  9 +++------
 8 files changed, 22 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 6c0ffe8e4adb..5a5821e59dc1 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2014-2021 The Linux Foundation. All rights reserved.
  * Copyright (C) 2013 Red Hat
  * Author: Rob Clark <robdclark@gmail.com>
@@ -124,7 +124,7 @@ static void dpu_crtc_setup_lm_misr(struct dpu_crtc_state *crtc_state)
 			continue;
 
 		/* Calculate MISR over 1 frame */
-		m->hw_lm->ops.setup_misr(m->hw_lm, true, 1);
+		m->hw_lm->ops.setup_misr(m->hw_lm);
 	}
 }
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
index 547f9f2b9fcb..b0eb881f8af1 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_encoder.c
@@ -2,7 +2,7 @@
 /*
  * Copyright (C) 2013 Red Hat
  * Copyright (c) 2014-2018, 2020-2021 The Linux Foundation. All rights reserved.
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  *
  * Author: Rob Clark <robdclark@gmail.com>
  */
@@ -257,7 +257,7 @@ void dpu_encoder_setup_misr(const struct drm_encoder *drm_enc)
 		if (!phys->hw_intf || !phys->hw_intf->ops.setup_misr)
 			continue;
 
-		phys->hw_intf->ops.setup_misr(phys->hw_intf, true, 1);
+		phys->hw_intf->ops.setup_misr(phys->hw_intf);
 	}
 }
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
index 7e210ba0b104..384558d2f960 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
  */
 
@@ -322,9 +322,9 @@ static u32 dpu_hw_intf_get_line_count(struct dpu_hw_intf *intf)
 	return DPU_REG_READ(c, INTF_LINE_COUNT);
 }
 
-static void dpu_hw_intf_setup_misr(struct dpu_hw_intf *intf, bool enable, u32 frame_count)
+static void dpu_hw_intf_setup_misr(struct dpu_hw_intf *intf)
 {
-	dpu_hw_setup_misr(&intf->hw, INTF_MISR_CTRL, enable, frame_count, 0x1);
+	dpu_hw_setup_misr(&intf->hw, INTF_MISR_CTRL, 0x1);
 }
 
 static int dpu_hw_intf_collect_misr(struct dpu_hw_intf *intf, u32 *misr_value)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h
index 643dd10bc030..e75339b96a1d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_intf.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
  */
 
@@ -80,7 +80,7 @@ struct dpu_hw_intf_ops {
 	void (*bind_pingpong_blk)(struct dpu_hw_intf *intf,
 			bool enable,
 			const enum dpu_pingpong pp);
-	void (*setup_misr)(struct dpu_hw_intf *intf, bool enable, u32 frame_count);
+	void (*setup_misr)(struct dpu_hw_intf *intf);
 	int (*collect_misr)(struct dpu_hw_intf *intf, u32 *misr_value);
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
index 2dd9f9185cfc..cc04fb979fb5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2015-2021, The Linux Foundation. All rights reserved.
  */
 
@@ -99,9 +99,9 @@ static void dpu_hw_lm_setup_border_color(struct dpu_hw_mixer *ctx,
 	}
 }
 
-static void dpu_hw_lm_setup_misr(struct dpu_hw_mixer *ctx, bool enable, u32 frame_count)
+static void dpu_hw_lm_setup_misr(struct dpu_hw_mixer *ctx)
 {
-	dpu_hw_setup_misr(&ctx->hw, LM_MISR_CTRL, enable, frame_count, 0x0);
+	dpu_hw_setup_misr(&ctx->hw, LM_MISR_CTRL, 0x0);
 }
 
 static int dpu_hw_lm_collect_misr(struct dpu_hw_mixer *ctx, u32 *misr_value)
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.h
index 652ddfdedec3..0a050eb247b9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_lm.h
@@ -1,5 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2015-2021, The Linux Foundation. All rights reserved.
  */
 
@@ -57,7 +58,7 @@ struct dpu_hw_lm_ops {
 	/**
 	 * setup_misr: Enable/disable MISR
 	 */
-	void (*setup_misr)(struct dpu_hw_mixer *ctx, bool enable, u32 frame_count);
+	void (*setup_misr)(struct dpu_hw_mixer *ctx);
 
 	/**
 	 * collect_misr: Read MISR signature
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c
index 119dc07d6ab5..1b7439ae686a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
  */
 #define pr_fmt(fmt)	"[drm:%s:%d] " fmt, __func__, __LINE__
@@ -454,9 +454,7 @@ u64 _dpu_hw_get_qos_lut(const struct dpu_qos_lut_tbl *tbl,
  * note: Aside from encoders, input_sel should be set to 0x0 by default
  */
 void dpu_hw_setup_misr(struct dpu_hw_blk_reg_map *c,
-		u32 misr_ctrl_offset,
-		bool enable, u32 frame_count,
-		u8 input_sel)
+		u32 misr_ctrl_offset, u8 input_sel)
 {
 	u32 config = 0;
 
@@ -465,16 +463,9 @@ void dpu_hw_setup_misr(struct dpu_hw_blk_reg_map *c,
 	/* Clear old MISR value (in case it's read before a new value is calculated)*/
 	wmb();
 
-	if (enable) {
-		config = (frame_count & MISR_FRAME_COUNT_MASK) |
-			MISR_CTRL_ENABLE | MISR_CTRL_FREE_RUN_MASK |
-			((input_sel & 0xF) << 24);
-
-		DPU_REG_WRITE(c, misr_ctrl_offset, config);
-	} else {
-		DPU_REG_WRITE(c, misr_ctrl_offset, 0);
-	}
-
+	config = MISR_FRAME_COUNT | MISR_CTRL_ENABLE | MISR_CTRL_FREE_RUN_MASK |
+		((input_sel & 0xF) << 24);
+	DPU_REG_WRITE(c, misr_ctrl_offset, config);
 }
 
 int dpu_hw_collect_misr(struct dpu_hw_blk_reg_map *c,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h
index dffad0a83781..4ae2a434372c 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_util.h
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * Copyright (c) 2022 Qualcomm Innovation Center, Inc. All rights reserved.
+ * Copyright (c) 2022-2023 Qualcomm Innovation Center, Inc. All rights reserved.
  * Copyright (c) 2015-2021, The Linux Foundation. All rights reserved.
  */
 
@@ -13,7 +13,7 @@
 #include "dpu_hw_catalog.h"
 
 #define REG_MASK(n)                     ((BIT(n)) - 1)
-#define MISR_FRAME_COUNT_MASK           0xFF
+#define MISR_FRAME_COUNT                0x1
 #define MISR_CTRL_ENABLE                BIT(8)
 #define MISR_CTRL_STATUS                BIT(9)
 #define MISR_CTRL_STATUS_CLEAR          BIT(10)
@@ -350,10 +350,7 @@ u64 _dpu_hw_get_qos_lut(const struct dpu_qos_lut_tbl *tbl,
 		u32 total_fl);
 
 void dpu_hw_setup_misr(struct dpu_hw_blk_reg_map *c,
-		u32 misr_ctrl_offset,
-		bool enable,
-		u32 frame_count,
-		u8 input_sel);
+		u32 misr_ctrl_offset, u8 input_sel);
 
 int dpu_hw_collect_misr(struct dpu_hw_blk_reg_map *c,
 		u32 misr_ctrl_offset,
-- 
2.43.0



