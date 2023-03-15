Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930BB4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163BDC433EF;
	Wed, 15 Mar 2023 12:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884086;
	bh=PR9rEFnZY/im5fn3akrgbD36diw2rkUJUjJnVcULFqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMnoVNGRijjq/OPpJdvq2QQhj3UKWqiyB7o/qEd79scv+CcFu2fIbEEnhAhvLk3lh
	 c8PNMUIumUkUY8bF5ZVIk/de03Z6JnRA0J7LH14Nc5vJOR5F4OJYYEVplnhStiu/4f
	 P+wtyS+XzJ4+DL//GA8m7RsvdGrZKaWQSVZsUL8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 072/141] drm/msm/dpu: fix sm6115 and qcm2290 mixer width limits
Date: Wed, 15 Mar 2023 13:12:55 +0100
Message-Id: <20230315115742.159565260@linuxfoundation.org>
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

[ Upstream commit da06be8b4fdf3eccf5cf6cbc4a689a43b8ad705b ]

According to vendor DTS files both sm6115 and qcm2290 should have
max_mixer_width set to 2048 (DEFAULT_DPU_LINE_WIDTH). Correct it.

Fixes: 3581b7062cec ("drm/msm/disp/dpu1: add support for display on SM6115")
Fixes: 5334087ee743 ("drm/msm: add support for QCM2290 MDSS")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/522212/
Link: https://lore.kernel.org/r/20230211231259.1308718-6-dmitry.baryshkov@linaro.org
[quic_abhinavk@quicinc.com: fix minor typo in commit message]
Signed-off-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 55d0218314794..1f84168e04fa0 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -287,7 +287,7 @@ static const struct dpu_caps msm8998_dpu_caps = {
 };
 
 static const struct dpu_caps qcm2290_dpu_caps = {
-	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
+	.max_mixer_width = DEFAULT_DPU_LINE_WIDTH,
 	.max_mixer_blendstages = 0x4,
 	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2,
 	.has_dim_layer = true,
@@ -325,7 +325,7 @@ static const struct dpu_caps sc7180_dpu_caps = {
 };
 
 static const struct dpu_caps sm6115_dpu_caps = {
-	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
+	.max_mixer_width = DEFAULT_DPU_LINE_WIDTH,
 	.max_mixer_blendstages = 0x4,
 	.qseed_type = DPU_SSPP_SCALER_QSEED3LITE,
 	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
@@ -1068,7 +1068,7 @@ static const struct dpu_lm_cfg sc7280_lm[] = {
 /* QCM2290 */
 
 static const struct dpu_lm_sub_blks qcm2290_lm_sblk = {
-	.maxwidth = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
+	.maxwidth = DEFAULT_DPU_LINE_WIDTH,
 	.maxblendstages = 4, /* excluding base layer */
 	.blendstage_base = { /* offsets relative to mixer base */
 		0x20, 0x38, 0x50, 0x68
-- 
2.39.2



