Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C1D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F425C433D2;
	Mon, 22 May 2023 19:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784802;
	bh=If7dSYNEmbtgm+g7U5yPrX2WCtHur/1nKeSJ8qTnTvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOBnea1UDfawFoiPlBa+JuW23OJioWN2UNLcM5ppWftzuNZulXrVQXXA0Eeyl7SZw
	 F6RguegghxpgtqVHlLSKKSIkAN+ANurD7T012e62ZXz6iybLzAa2UBW7nyXhYFRUp3
	 j8QWMCLqZcivSYIfzpwoyI8prVfnbhuD7N2i4+eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 207/364] drm/msm/dpu: drop smart_dma_rev from dpu_caps
Date: Mon, 22 May 2023 20:08:32 +0100
Message-Id: <20230522190417.898806462@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
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

[ Upstream commit dcb3f7c9042d1c1aa637b58d47bd45c00b2ac153 ]

The code doesn't use dpu_caps::smart_dma_rev field. It checks if the
corresponding feature is enabled in the SSPP features. Drop the
smart_dma_rev field completely.

Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/527369/
Link: https://lore.kernel.org/r/20230316161653.4106395-31-dmitry.baryshkov@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 701f69183d4d ("drm/msm/dpu: Fix PP_BLK_DIPHER -> DITHER typo")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c | 13 -------------
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h |  2 --
 2 files changed, 15 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 9fe4fc95ab65f..e7b29b118eb5a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -317,7 +317,6 @@ static const struct dpu_caps msm8998_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0x7,
 	.qseed_type = DPU_SSPP_SCALER_QSEED3,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V1,
 	.ubwc_version = DPU_HW_UBWC_VER_10,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -332,7 +331,6 @@ static const struct dpu_caps msm8998_dpu_caps = {
 static const struct dpu_caps qcm2290_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_LINE_WIDTH,
 	.max_mixer_blendstages = 0x4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2,
 	.has_dim_layer = true,
 	.has_idle_pc = true,
 	.max_linewidth = 2160,
@@ -343,7 +341,6 @@ static const struct dpu_caps sdm845_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED3,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2,
 	.ubwc_version = DPU_HW_UBWC_VER_20,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -359,7 +356,6 @@ static const struct dpu_caps sc7180_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0x9,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2,
 	.ubwc_version = DPU_HW_UBWC_VER_20,
 	.has_dim_layer = true,
 	.has_idle_pc = true,
@@ -371,7 +367,6 @@ static const struct dpu_caps sm6115_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_LINE_WIDTH,
 	.max_mixer_blendstages = 0x4,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_10,
 	.has_dim_layer = true,
 	.has_idle_pc = true,
@@ -383,7 +378,6 @@ static const struct dpu_caps sm8150_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED3,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_30,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -399,7 +393,6 @@ static const struct dpu_caps sc8180x_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED3,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_30,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -415,7 +408,6 @@ static const struct dpu_caps sc8280xp_dpu_caps = {
 	.max_mixer_width = 2560,
 	.max_mixer_blendstages = 11,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_40,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -429,7 +421,6 @@ static const struct dpu_caps sm8250_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_40,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -443,7 +434,6 @@ static const struct dpu_caps sm8350_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_40,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -457,7 +447,6 @@ static const struct dpu_caps sm8450_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_40,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -471,7 +460,6 @@ static const struct dpu_caps sm8550_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0xb,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2, /* TODO: v2.5 */
 	.ubwc_version = DPU_HW_UBWC_VER_40,
 	.has_src_split = true,
 	.has_dim_layer = true,
@@ -485,7 +473,6 @@ static const struct dpu_caps sc7280_dpu_caps = {
 	.max_mixer_width = DEFAULT_DPU_OUTPUT_LINE_WIDTH,
 	.max_mixer_blendstages = 0x7,
 	.qseed_type = DPU_SSPP_SCALER_QSEED4,
-	.smart_dma_rev = DPU_SSPP_SMART_DMA_V2,
 	.ubwc_version = DPU_HW_UBWC_VER_30,
 	.has_dim_layer = true,
 	.has_idle_pc = true,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
index 2c5bafacd609c..2531aac97a779 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
@@ -394,7 +394,6 @@ struct dpu_rotation_cfg {
  * @max_mixer_blendstages max layer mixer blend stages or
  *                       supported z order
  * @qseed_type         qseed2 or qseed3 support.
- * @smart_dma_rev      Supported version of SmartDMA feature.
  * @ubwc_version       UBWC feature version (0x0 for not supported)
  * @has_src_split      source split feature status
  * @has_dim_layer      dim layer feature status
@@ -409,7 +408,6 @@ struct dpu_caps {
 	u32 max_mixer_width;
 	u32 max_mixer_blendstages;
 	u32 qseed_type;
-	u32 smart_dma_rev;
 	u32 ubwc_version;
 	bool has_src_split;
 	bool has_dim_layer;
-- 
2.39.2



