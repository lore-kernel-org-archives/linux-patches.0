Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA8D67726;
	Tue, 23 Jan 2024 02:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975295; cv=none; b=kLy27CAi6Q5wD7C0FkjLT98QXAIAsJtQlXLGlCYwvyaQbKqCi0aXRtLHxLZ4FTKNYomWT7a48eM32RmVVeM9LT896mRU8itPmE0R+3WmFSrCxpOzjD44NFdmlHhl23ZDuc5XWBiDda9y1YpFToTOBfmgUR5Qb31/Fi11l6h8/6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975295; c=relaxed/simple;
	bh=xVqTIhZbLYKxRYI8LHyieqHM4S/lBtK+89CpBmkAKfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZaT0H+YP9nwd7+r7xmJP1Ob2wL6JCbcHwSNilNcZEmQe/IIMicfvKHOICFULxjuELSpkiXXJPFQx8BTlftDaIaLR6ikFhCHH/SDo9p5MfNPDPxM9IxYbw8ApCpZMBUA48wjTkMXWjjjVcptr5a3XrpFKD9svnc9DyOA0d6IdoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFSxmuL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFSxmuL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD221C43390;
	Tue, 23 Jan 2024 02:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975294;
	bh=xVqTIhZbLYKxRYI8LHyieqHM4S/lBtK+89CpBmkAKfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jFSxmuL9Zr3S00iHIpsL/Fzj/EwaVwpjCC9+wo6aGP2aPIzffp24TAGG5pti3lx1o
	 4sSBGS2CRIiwxCkpxnzOgVx4vcCgtjtQsj6lAYiPfqjqh6XSD0FWWPld5LXJiDjt42
	 rM1fvHOVcNWPWyoASGFc2Low2wt+ou1VGram5AKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Paloma Arellano <quic_parellan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 259/583] drm/msm/dpu: correct clk bit for WB2 block
Date: Mon, 22 Jan 2024 15:55:10 -0800
Message-ID: <20240122235819.932421587@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit e843ca2f30e630675e2d2a75c96f4844f2854430 ]

On sc7280 there are two clk bits for WB2: vbif_cli and clk_ctrl. While
programming the VBIF params of WB, the driver should be toggling the
former bit, while the sc7180_mdp, sc7280_mdp and sm8250_mdp structs
list the latter one.

Correct that to ensure proper programming sequence for WB2 on these
platforms.

Fixes: 255f056181ac ("drm/msm/dpu: sc7180: add missing WB2 clock control")
Fixes: 3ce166380567 ("drm/msm/dpu: add writeback support for sc7280")
Fixes: 53324b99bd7b ("drm/msm/dpu: add writeback blocks to the sm8250 DPU catalog")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Tested-by: Paloma Arellano <quic_parellan@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/570185/
Link: https://lore.kernel.org/r/20231203002437.1291595-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
index 5f9b437b82a6..ee781037ada9 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_0_sm8250.h
@@ -32,7 +32,7 @@ static const struct dpu_mdp_cfg sm8250_mdp = {
 		[DPU_CLK_CTRL_DMA2] = { .reg_off = 0x2bc, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA3] = { .reg_off = 0x2c4, .bit_off = 8 },
 		[DPU_CLK_CTRL_REG_DMA] = { .reg_off = 0x2bc, .bit_off = 20 },
-		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x3b8, .bit_off = 24 },
+		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x2bc, .bit_off = 16 },
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h
index d030c08636b4..69d3f7e5e095 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h
@@ -25,7 +25,7 @@ static const struct dpu_mdp_cfg sc7180_mdp = {
 		[DPU_CLK_CTRL_DMA0] = { .reg_off = 0x2ac, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA1] = { .reg_off = 0x2b4, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA2] = { .reg_off = 0x2c4, .bit_off = 8 },
-		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x3b8, .bit_off = 24 },
+		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x2bc, .bit_off = 16 },
 	},
 };
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
index 3b5061c4402a..9195cb996f44 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
@@ -25,7 +25,7 @@ static const struct dpu_mdp_cfg sc7280_mdp = {
 		[DPU_CLK_CTRL_DMA0] = { .reg_off = 0x2ac, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA1] = { .reg_off = 0x2b4, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA2] = { .reg_off = 0x2c4, .bit_off = 8 },
-		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x3b8, .bit_off = 24 },
+		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x2bc, .bit_off = 16 },
 	},
 };
 
-- 
2.43.0



