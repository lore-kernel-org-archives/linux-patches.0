Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D72F8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:08:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2F3C433C8;
	Sun, 16 Jul 2023 20:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538135;
	bh=hDYVcA37Jsjq4DxGhrkLzFD8ntrUeRutJplVYvDg37g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4NjIGvaISVkk0zu+Wdc+4WIxRdpZtkTKlNO7uLwXqq03Jnwc7LxlrJSlGeX9ptaR
	 GzFLhnSV+AfbM5hufZxKjOGqtjVgBwfm3m4Zxign25Dxp3lJAd4LNxFVi8mgDcpKlh
	 GoR33mqSG0cezrgkug3RrASq13MYNhazIkZC3pP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuogee Hsieh <quic_khsieh@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 342/800] drm/msm/dpu: set DSC flush bit correctly at MDP CTL flush register
Date: Sun, 16 Jul 2023 21:43:15 +0200
Message-ID: <20230716194957.024917542@linuxfoundation.org>
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

From: Kuogee Hsieh <quic_khsieh@quicinc.com>

[ Upstream commit 12cef323c903bd8b13d1f6ff24a9695c2cdc360b ]

The CTL_FLUSH register should be programmed with the 22th bit
(DSC_IDX) to flush the DSC hardware blocks, not the literal value of
22 (which corresponds to flushing VIG1, VIG2 and RGB1 instead).

Changes in V12:
-- split this patch out of "separate DSC flush update out of interface"

Changes in V13:
-- rewording the commit text

Changes in V14:
-- drop 'DSC" from "The DSC CTL_FLUSH register" at commit text

Fixes: 77f6da90487c ("drm/msm/disp/dpu1: Add DSC support in hw_ctl")
Signed-off-by: Kuogee Hsieh <quic_khsieh@quicinc.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Patchwork: https://patchwork.freedesktop.org/patch/539496/
Link: https://lore.kernel.org/r/1685036458-22683-2-git-send-email-quic_khsieh@quicinc.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
index bbdc95ce374a7..e57faf5906a8b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_ctl.c
@@ -542,7 +542,7 @@ static void dpu_hw_ctl_intf_cfg_v1(struct dpu_hw_ctl *ctx,
 		DPU_REG_WRITE(c, CTL_MERGE_3D_ACTIVE,
 			      BIT(cfg->merge_3d - MERGE_3D_0));
 	if (cfg->dsc) {
-		DPU_REG_WRITE(&ctx->hw, CTL_FLUSH, DSC_IDX);
+		DPU_REG_WRITE(&ctx->hw, CTL_FLUSH, BIT(DSC_IDX));
 		DPU_REG_WRITE(c, CTL_DSC_ACTIVE, cfg->dsc);
 	}
 }
-- 
2.39.2



