Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7DE2ECEA7;
	Tue, 17 Jun 2025 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175894; cv=none; b=Fb0Lq5s8tLl3MwKXDkDiQwC9lpk/DwffslGJAyhmCkj/wX4vzJSmywYB63/eWz3MXRKX35W1PcikgNyetc9rRaL8A0IcNBGEMCyFDIiUDM5LVoXnoBccwNTLgUdSbofHwAFtKroMFwvsGQpPVPH26ChHOPyhpQHBBGf1MaKop1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175894; c=relaxed/simple;
	bh=eyMqCVPb8QByxGN0jqAReKFHf+Vpu8n9y9R4yLTKuZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIL8HtgB4R85mj6FZGl6cRjnRwHBqSoYqPxYbPmF7o1LGlk6Ik40eTUZgkIr+YoUvmJuIXJSouOl9yeWkxU44RoMPqFtiFhV3fDutrjcCEBtubswSym6/quyDUb4XrCuHhXRBPwl+6rkylQAbSkS7mR7iM6lzXbBQ8qEuQL1Eqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUt8WET/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUt8WET/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE0DC4CEE3;
	Tue, 17 Jun 2025 15:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175893;
	bh=eyMqCVPb8QByxGN0jqAReKFHf+Vpu8n9y9R4yLTKuZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUt8WET/awJ9QuaNGjtphsNH1ojpP9j3Iwu4lhUTc6iPiupsv8nsswSEfAQDPxzoT
	 BkPUMMQEgZ3ahGakI9Ffw87YS/gfQWsIQdrmDBKvrmt+OKhrjgsXouwC7P+i2oiRu/
	 w43TCRIL8cVG8xT5g2GggkNXddRevNd9AxGzDj5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 132/780] drm/msm/dpu: remove DSC feature bit for PINGPONG on MSM8953
Date: Tue, 17 Jun 2025 17:17:20 +0200
Message-ID: <20250617152456.881584958@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5232a29ebc74df4abf790147a06db451d824cd92 ]

The MSM8953 platform doesn't have DSC blocks nor does have it DSC
registers in the PINGPONG block. Drop the DPU_PINGPONG_DSC feature bit
from the PINGPONG's feature mask and, as it is the only remaining bit,
drop the .features assignment completely.

Fixes: 7a6109ce1c2c ("drm/msm/dpu: Add support for MSM8953")
Reported-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/640303/
Link: https://lore.kernel.org/r/20250301-dpu-fix-catalog-v2-3-498271be8b50@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
index eea9b80e2287a..16c12499b24bb 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_1_16_msm8953.h
@@ -100,14 +100,12 @@ static const struct dpu_pingpong_cfg msm8953_pp[] = {
 	{
 		.name = "pingpong_0", .id = PINGPONG_0,
 		.base = 0x70000, .len = 0xd4,
-		.features = PINGPONG_MSM8996_MASK,
 		.sblk = &msm8996_pp_sblk,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 8),
 		.intr_rdptr = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 12),
 	}, {
 		.name = "pingpong_1", .id = PINGPONG_1,
 		.base = 0x70800, .len = 0xd4,
-		.features = PINGPONG_MSM8996_MASK,
 		.sblk = &msm8996_pp_sblk,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 9),
 		.intr_rdptr = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 13),
-- 
2.39.5



