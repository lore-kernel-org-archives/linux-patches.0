Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8E98F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36FEC433C7;
	Sun, 16 Jul 2023 20:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538316;
	bh=rA9VdaFnEnEmgSlQ1VWi6+beP01FCDZyIPfzin2sG/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c8z/Qv1cZ6M/7MPxBHcazWDCnrJR9iZ0FP2bh8DDaZiq2CSafTyvILovJ000CMBpC
	 eNJRudOSAqSWC25SSd7xoRetE0q3RENQK94f1ISf4Lx+M7xEcdpFjTj80cD0g4Ys2g
	 4pj8w5KRSHH4ExFLgznYEfvyS/04a6RtjXGlLJAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 408/800] drm/msm/dpu: Drop unused poll_timeout_wr_ptr PINGPONG callback
Date: Sun, 16 Jul 2023 21:44:21 +0200
Message-ID: <20230716194958.548592881@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit a2623e72c52b2cf258b34675a8ff38c66e7d26fb ]

This callback was migrated from downstream when DPU1 was first
introduced to mainline, but never used by any component.  Drop it to
save some lines and unnecessary confusion.

Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/534215/
Link: https://lore.kernel.org/r/20230411-dpu-intf-te-v4-12-27ce1a5ab5c6@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 0b78be614c50 ("drm/msm/dpu: fix sc7280 and sc7180 PINGPONG done interrupts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.c    | 18 ------------------
 .../gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.h    |  6 ------
 2 files changed, 24 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.c
index 0fcad9760b6fc..b18efd640abd6 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.c
@@ -144,23 +144,6 @@ static bool dpu_hw_pp_get_autorefresh_config(struct dpu_hw_pingpong *pp,
 	return !!((val & BIT(31)) >> 31);
 }
 
-static int dpu_hw_pp_poll_timeout_wr_ptr(struct dpu_hw_pingpong *pp,
-		u32 timeout_us)
-{
-	struct dpu_hw_blk_reg_map *c;
-	u32 val;
-	int rc;
-
-	if (!pp)
-		return -EINVAL;
-
-	c = &pp->hw;
-	rc = readl_poll_timeout(c->blk_addr + PP_LINE_COUNT,
-			val, (val & 0xffff) >= 1, 10, timeout_us);
-
-	return rc;
-}
-
 static int dpu_hw_pp_enable_te(struct dpu_hw_pingpong *pp, bool enable)
 {
 	struct dpu_hw_blk_reg_map *c;
@@ -280,7 +263,6 @@ static void _setup_pingpong_ops(struct dpu_hw_pingpong *c,
 	c->ops.get_vsync_info = dpu_hw_pp_get_vsync_info;
 	c->ops.setup_autorefresh = dpu_hw_pp_setup_autorefresh_config;
 	c->ops.get_autorefresh = dpu_hw_pp_get_autorefresh_config;
-	c->ops.poll_timeout_wr_ptr = dpu_hw_pp_poll_timeout_wr_ptr;
 	c->ops.get_line_count = dpu_hw_pp_get_line_count;
 	c->ops.setup_dsc = dpu_hw_pp_setup_dsc;
 	c->ops.enable_dsc = dpu_hw_pp_dsc_enable;
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.h
index c00223441d990..cf94b4ab603b5 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_pingpong.h
@@ -107,12 +107,6 @@ struct dpu_hw_pingpong_ops {
 	bool (*get_autorefresh)(struct dpu_hw_pingpong *pp,
 				u32 *frame_count);
 
-	/**
-	 * poll until write pointer transmission starts
-	 * @Return: 0 on success, -ETIMEDOUT on timeout
-	 */
-	int (*poll_timeout_wr_ptr)(struct dpu_hw_pingpong *pp, u32 timeout_us);
-
 	/**
 	 * Obtain current vertical line counter
 	 */
-- 
2.39.2



