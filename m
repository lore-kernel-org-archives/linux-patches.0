Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3C747A;
	Tue, 23 Jan 2024 00:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969531; cv=none; b=TW5gLsqjNXMolcGK8eGOzFXjRTVg+FND2Rql0bU+VnQSm+usEC6Cm8RqLppalWf14gKaroaDZauf+tn2LuvSL4SzzkP3v+WjKxdUWOOKxRTQ+obyd/RBZIlobf/uk74fnu7wPO3MD6VtTVGfS1h9p3PRk49GYB+bmEaT184b26M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969531; c=relaxed/simple;
	bh=opMfgBB5v5wqqf3NNQRJYCjDgAlzX1V4V8wN4YIzJxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvPi4J9J9mpFyNrnaYMIqwfyfDlWCL1dWqTR7NSMqimnp/9QDlSbbT2AOgcL7WvoduxBC/OGYe5typXmriiH8FAOepg+qAMd4bYLhvOrXlFayjXc9mjDGXTeIXXw9NWY5ggS/PdPTFFA3u8LOzhxiHfNYx6FCjBcrhN3wdczXN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgoT5f9W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgoT5f9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC64BC433A6;
	Tue, 23 Jan 2024 00:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969530;
	bh=opMfgBB5v5wqqf3NNQRJYCjDgAlzX1V4V8wN4YIzJxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgoT5f9WVWNqbNp0JiwMUlmEt254BSAwtLnr457/xZ4fxe8mCX5dtEj/8W+ZuqWP5
	 Feqr6/Eb37B+U4wQS4CN6Q+NhCgahzNjfT3x6zvHmvTwl9Qks63qRXhwccODnHmTe8
	 Q0ii6rx6Y4Q/XbVlA8s2AuSNYXKPF8XnX95xFsmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Paloma Arellano <quic_parellan@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 290/641] drm/msm/dpu: correct clk bit for WB2 block
Date: Mon, 22 Jan 2024 15:53:14 -0800
Message-ID: <20240122235826.965904616@linuxfoundation.org>
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
index 94278a3e3483..9f8068fa0175 100644
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
index c0d88ddccb28..9bfa15e4e645 100644
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
index 15942fa5a8e0..b9c296e51e36 100644
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



