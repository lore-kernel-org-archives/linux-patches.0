Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3334431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7293DC433D2;
	Wed, 15 Mar 2023 12:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884083;
	bh=GenWt9EoROky7ir7/lF2MejqZRegq3lB/AeMVa0ETo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIZozLnbl09Y/OaidOfo43K6gdyDFWtctAN1AS9H3lgFv1I01wfyqglfq3W+O7Jpg
	 fxlDhssHKRqvCpvxbs4i+JDh8FSlRB3roRYY29CiM08+9/sOnYsbv0V6CJVq+bnqAa
	 Z8uJpkdpDhN0pPqoCGX+xo2OLVsURU3UZkV1H/p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 071/141] drm/msm/dpu: fix len of sc7180 ctl blocks
Date: Wed, 15 Mar 2023 13:12:54 +0100
Message-Id: <20230315115742.131244644@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ce6bd00abc220e9edf10986234fadba6462b4abf ]

Change sc7180's ctl block len to 0x1dc.

Fixes: 7bdc0c4b8126 ("msm:disp:dpu1: add support for display for SC7180 target")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/522210/
Link: https://lore.kernel.org/r/20230211231259.1308718-5-dmitry.baryshkov@linaro.org
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index ffcd90ba3e81e..55d0218314794 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -635,19 +635,19 @@ static const struct dpu_ctl_cfg sdm845_ctl[] = {
 static const struct dpu_ctl_cfg sc7180_ctl[] = {
 	{
 	.name = "ctl_0", .id = CTL_0,
-	.base = 0x1000, .len = 0xE4,
+	.base = 0x1000, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 9),
 	},
 	{
 	.name = "ctl_1", .id = CTL_1,
-	.base = 0x1200, .len = 0xE4,
+	.base = 0x1200, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 10),
 	},
 	{
 	.name = "ctl_2", .id = CTL_2,
-	.base = 0x1400, .len = 0xE4,
+	.base = 0x1400, .len = 0x1dc,
 	.features = BIT(DPU_CTL_ACTIVE_CFG),
 	.intr_start = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR2, 11),
 	},
-- 
2.39.2



