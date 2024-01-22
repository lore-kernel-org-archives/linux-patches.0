Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E433C3F;
	Tue, 23 Jan 2024 00:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969554; cv=none; b=mCjNbx59oAKzurvDtrKFR5MiEr1QA+UiudTFMUUn9vwiAkHKkwWOwWP5gakyW3BxoJ9bIQSg0ATRZ4QylyftlCVsp8x0STaLMVqn6ymY7Sw8jsa0N8fHKpXfILSLBjAYkBh4t9sR/C1A9pvKVX6RfZLGLDNGifsd8AxqpIgqK3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969554; c=relaxed/simple;
	bh=4XAdUTkwvuspe5LGNEDXTxm7l+cs5GcAFI4nIsOVFCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d53gos2wMrLnGnoOTQyrfphTShBRcsI/65joEkOK7lcvURBKGPorRKmlAqW6+4ynjN0C5BpO9Xr6mYe6UvoccBjwA+kdY5PYQXhHy5I5TwqMKNjwMsJM1q/4w0OXZNITnNklxhHhkmxZ6SbB216H1W32FzOK42L2QZ7kWDDT5+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LlebctFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LlebctFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA4CC43394;
	Tue, 23 Jan 2024 00:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969553;
	bh=4XAdUTkwvuspe5LGNEDXTxm7l+cs5GcAFI4nIsOVFCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LlebctFh+XCzLh4usHodwZsv2WNopC9zV4sU+tFXo7EKJsul/pwAl/6j41Kk2V/66
	 2TVgMRDj26uS4/oOEwZMXIQ3V0nXLBNfq9LUX/1O6pCMlggAWd0Sm4Nd29PubAgGrp
	 iDJxgwUDkX8wEr6XO7j9qUrSKEhCwlhaRIHev8VA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 288/641] drm/msm/dpu: populate SSPP scaler block version
Date: Mon, 22 Jan 2024 15:53:12 -0800
Message-ID: <20240122235826.910375651@linuxfoundation.org>
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

[ Upstream commit 46b1f1b839cad600de3ad7ed999bd0155c528746 ]

The function _dpu_hw_sspp_setup_scaler3() passes and
dpu_hw_setup_scaler3() uses scaler_blk.version to determine in which way
the scaler (QSEED3) block should be programmed. However up to now we
were not setting this field. Set it now, splitting the vig_sblk data
which has different version fields.

Reported-by: Marijn Suijten <marijn.suijten@somainline.org>
Fixes: 9b6f4fedaac2 ("drm/msm/dpu: Add SM6125 support")
Fixes: 27f0df03f3ff ("drm/msm/dpu: Add SM6375 support")
Fixes: 3186acba5cdc ("drm/msm/dpu: Add SM6350 support")
Fixes: efcd0107727c ("drm/msm/dpu: add support for SM8550")
Fixes: 4a352c2fc15a ("drm/msm/dpu: Introduce SC8280XP")
Fixes: 0e91bcbb0016 ("drm/msm/dpu: Add SM8350 to hw catalog")
Fixes: 100d7ef6995d ("drm/msm/dpu: add support for SM8450")
Fixes: 3581b7062cec ("drm/msm/disp/dpu1: add support for display on SM6115")
Fixes: dabfdd89eaa9 ("drm/msm/disp/dpu1: add inline rotation support for sc7280")
Fixes: f3af2d6ee9ab ("drm/msm/dpu: Add SC8180x to hw catalog")
Fixes: 94391a14fc27 ("drm/msm/dpu1: Add MSM8998 to hw catalog")
Fixes: af776a3e1c30 ("drm/msm/dpu: add SM8250 to hw catalog")
Fixes: 386fced3f76f ("drm/msm/dpu: add SM8150 to hw catalog")
Fixes: b75ab05a3479 ("msm:disp:dpu1: add scaler support on SC7180 display")
Fixes: 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/570098/
Link: https://lore.kernel.org/r/20231201234234.2065610-2-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../msm/disp/dpu1/catalog/dpu_5_0_sm8150.h    |  8 +-
 .../msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h   |  8 +-
 .../msm/disp/dpu1/catalog/dpu_8_1_sm8450.h    |  8 +-
 .../gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c    | 95 ++++++++++++++-----
 .../gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h    |  3 +-
 5 files changed, 87 insertions(+), 35 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
index 9392ad2b4d3f..c022e57864a4 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_0_sm8150.h
@@ -77,7 +77,7 @@ static const struct dpu_sspp_cfg sm8150_sspp[] = {
 		.name = "sspp_0", .id = SSPP_VIG0,
 		.base = 0x4000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_0,
+		.sblk = &sm8150_vig_sblk_0,
 		.xin_id = 0,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG0,
@@ -85,7 +85,7 @@ static const struct dpu_sspp_cfg sm8150_sspp[] = {
 		.name = "sspp_1", .id = SSPP_VIG1,
 		.base = 0x6000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_1,
+		.sblk = &sm8150_vig_sblk_1,
 		.xin_id = 4,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG1,
@@ -93,7 +93,7 @@ static const struct dpu_sspp_cfg sm8150_sspp[] = {
 		.name = "sspp_2", .id = SSPP_VIG2,
 		.base = 0x8000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_2,
+		.sblk = &sm8150_vig_sblk_2,
 		.xin_id = 8,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG2,
@@ -101,7 +101,7 @@ static const struct dpu_sspp_cfg sm8150_sspp[] = {
 		.name = "sspp_3", .id = SSPP_VIG3,
 		.base = 0xa000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_3,
+		.sblk = &sm8150_vig_sblk_3,
 		.xin_id = 12,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG3,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
index 9ffc8804a6fc..cb0758f0829d 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_5_1_sc8180x.h
@@ -76,7 +76,7 @@ static const struct dpu_sspp_cfg sc8180x_sspp[] = {
 		.name = "sspp_0", .id = SSPP_VIG0,
 		.base = 0x4000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_0,
+		.sblk = &sm8150_vig_sblk_0,
 		.xin_id = 0,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG0,
@@ -84,7 +84,7 @@ static const struct dpu_sspp_cfg sc8180x_sspp[] = {
 		.name = "sspp_1", .id = SSPP_VIG1,
 		.base = 0x6000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_1,
+		.sblk = &sm8150_vig_sblk_1,
 		.xin_id = 4,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG1,
@@ -92,7 +92,7 @@ static const struct dpu_sspp_cfg sc8180x_sspp[] = {
 		.name = "sspp_2", .id = SSPP_VIG2,
 		.base = 0x8000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_2,
+		.sblk = &sm8150_vig_sblk_2,
 		.xin_id = 8,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG2,
@@ -100,7 +100,7 @@ static const struct dpu_sspp_cfg sc8180x_sspp[] = {
 		.name = "sspp_3", .id = SSPP_VIG3,
 		.base = 0xa000, .len = 0x1f0,
 		.features = VIG_SDM845_MASK,
-		.sblk = &sdm845_vig_sblk_3,
+		.sblk = &sm8150_vig_sblk_3,
 		.xin_id = 12,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG3,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h
index d18145c226da..72b0f547242f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_8_1_sm8450.h
@@ -76,7 +76,7 @@ static const struct dpu_sspp_cfg sm8450_sspp[] = {
 		.name = "sspp_0", .id = SSPP_VIG0,
 		.base = 0x4000, .len = 0x32c,
 		.features = VIG_SC7180_MASK_SDMA,
-		.sblk = &sm8250_vig_sblk_0,
+		.sblk = &sm8450_vig_sblk_0,
 		.xin_id = 0,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG0,
@@ -84,7 +84,7 @@ static const struct dpu_sspp_cfg sm8450_sspp[] = {
 		.name = "sspp_1", .id = SSPP_VIG1,
 		.base = 0x6000, .len = 0x32c,
 		.features = VIG_SC7180_MASK_SDMA,
-		.sblk = &sm8250_vig_sblk_1,
+		.sblk = &sm8450_vig_sblk_1,
 		.xin_id = 4,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG1,
@@ -92,7 +92,7 @@ static const struct dpu_sspp_cfg sm8450_sspp[] = {
 		.name = "sspp_2", .id = SSPP_VIG2,
 		.base = 0x8000, .len = 0x32c,
 		.features = VIG_SC7180_MASK_SDMA,
-		.sblk = &sm8250_vig_sblk_2,
+		.sblk = &sm8450_vig_sblk_2,
 		.xin_id = 8,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG2,
@@ -100,7 +100,7 @@ static const struct dpu_sspp_cfg sm8450_sspp[] = {
 		.name = "sspp_3", .id = SSPP_VIG3,
 		.base = 0xa000, .len = 0x32c,
 		.features = VIG_SC7180_MASK_SDMA,
-		.sblk = &sm8250_vig_sblk_3,
+		.sblk = &sm8450_vig_sblk_3,
 		.xin_id = 12,
 		.type = SSPP_TYPE_VIG,
 		.clk_ctrl = DPU_CLK_CTRL_VIG3,
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index a1aada630780..7056c08b9957 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -249,14 +249,17 @@ static const uint32_t wb2_formats[] = {
  * SSPP sub blocks config
  *************************************************************/
 
+#define SSPP_SCALER_VER(maj, min) (((maj) << 16) | (min))
+
 /* SSPP common configuration */
-#define _VIG_SBLK(sdma_pri, qseed_ver) \
+#define _VIG_SBLK(sdma_pri, qseed_ver, scaler_ver) \
 	{ \
 	.maxdwnscale = MAX_DOWNSCALE_RATIO, \
 	.maxupscale = MAX_UPSCALE_RATIO, \
 	.smart_dma_priority = sdma_pri, \
 	.scaler_blk = {.name = "scaler", \
 		.id = qseed_ver, \
+		.version = scaler_ver, \
 		.base = 0xa00, .len = 0xa0,}, \
 	.csc_blk = {.name = "csc", \
 		.id = DPU_SSPP_CSC_10BIT, \
@@ -268,13 +271,14 @@ static const uint32_t wb2_formats[] = {
 	.rotation_cfg = NULL, \
 	}
 
-#define _VIG_SBLK_ROT(sdma_pri, qseed_ver, rot_cfg) \
+#define _VIG_SBLK_ROT(sdma_pri, qseed_ver, scaler_ver, rot_cfg) \
 	{ \
 	.maxdwnscale = MAX_DOWNSCALE_RATIO, \
 	.maxupscale = MAX_UPSCALE_RATIO, \
 	.smart_dma_priority = sdma_pri, \
 	.scaler_blk = {.name = "scaler", \
 		.id = qseed_ver, \
+		.version = scaler_ver, \
 		.base = 0xa00, .len = 0xa0,}, \
 	.csc_blk = {.name = "csc", \
 		.id = DPU_SSPP_CSC_10BIT, \
@@ -298,13 +302,17 @@ static const uint32_t wb2_formats[] = {
 	}
 
 static const struct dpu_sspp_sub_blks msm8998_vig_sblk_0 =
-				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 2));
 static const struct dpu_sspp_sub_blks msm8998_vig_sblk_1 =
-				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 2));
 static const struct dpu_sspp_sub_blks msm8998_vig_sblk_2 =
-				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 2));
 static const struct dpu_sspp_sub_blks msm8998_vig_sblk_3 =
-				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(0, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 2));
 
 static const struct dpu_rotation_cfg dpu_rot_sc7280_cfg_v2 = {
 	.rot_maxheight = 1088,
@@ -313,13 +321,30 @@ static const struct dpu_rotation_cfg dpu_rot_sc7280_cfg_v2 = {
 };
 
 static const struct dpu_sspp_sub_blks sdm845_vig_sblk_0 =
-				_VIG_SBLK(5, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(5, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 3));
 static const struct dpu_sspp_sub_blks sdm845_vig_sblk_1 =
-				_VIG_SBLK(6, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(6, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 3));
 static const struct dpu_sspp_sub_blks sdm845_vig_sblk_2 =
-				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 3));
 static const struct dpu_sspp_sub_blks sdm845_vig_sblk_3 =
-				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED3);
+				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 3));
+
+static const struct dpu_sspp_sub_blks sm8150_vig_sblk_0 =
+				_VIG_SBLK(5, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 4));
+static const struct dpu_sspp_sub_blks sm8150_vig_sblk_1 =
+				_VIG_SBLK(6, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 4));
+static const struct dpu_sspp_sub_blks sm8150_vig_sblk_2 =
+				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 4));
+static const struct dpu_sspp_sub_blks sm8150_vig_sblk_3 =
+				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED3,
+					  SSPP_SCALER_VER(1, 4));
 
 static const struct dpu_sspp_sub_blks sdm845_dma_sblk_0 = _DMA_SBLK(1);
 static const struct dpu_sspp_sub_blks sdm845_dma_sblk_1 = _DMA_SBLK(2);
@@ -327,34 +352,60 @@ static const struct dpu_sspp_sub_blks sdm845_dma_sblk_2 = _DMA_SBLK(3);
 static const struct dpu_sspp_sub_blks sdm845_dma_sblk_3 = _DMA_SBLK(4);
 
 static const struct dpu_sspp_sub_blks sc7180_vig_sblk_0 =
-				_VIG_SBLK(4, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(4, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 0));
 
 static const struct dpu_sspp_sub_blks sc7280_vig_sblk_0 =
-			_VIG_SBLK_ROT(4, DPU_SSPP_SCALER_QSEED4, &dpu_rot_sc7280_cfg_v2);
+			_VIG_SBLK_ROT(4, DPU_SSPP_SCALER_QSEED4,
+				      SSPP_SCALER_VER(3, 0),
+				      &dpu_rot_sc7280_cfg_v2);
 
 static const struct dpu_sspp_sub_blks sm6115_vig_sblk_0 =
-				_VIG_SBLK(2, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(2, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 0));
 
 static const struct dpu_sspp_sub_blks sm6125_vig_sblk_0 =
-				_VIG_SBLK(3, DPU_SSPP_SCALER_QSEED3LITE);
+				_VIG_SBLK(3, DPU_SSPP_SCALER_QSEED3LITE,
+					  SSPP_SCALER_VER(2, 4));
 
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_0 =
-				_VIG_SBLK(5, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(5, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 0));
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_1 =
-				_VIG_SBLK(6, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(6, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 0));
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_2 =
-				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 0));
 static const struct dpu_sspp_sub_blks sm8250_vig_sblk_3 =
-				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 0));
+
+static const struct dpu_sspp_sub_blks sm8450_vig_sblk_0 =
+				_VIG_SBLK(5, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 1));
+static const struct dpu_sspp_sub_blks sm8450_vig_sblk_1 =
+				_VIG_SBLK(6, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 1));
+static const struct dpu_sspp_sub_blks sm8450_vig_sblk_2 =
+				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 1));
+static const struct dpu_sspp_sub_blks sm8450_vig_sblk_3 =
+				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 1));
 
 static const struct dpu_sspp_sub_blks sm8550_vig_sblk_0 =
-				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(7, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 2));
 static const struct dpu_sspp_sub_blks sm8550_vig_sblk_1 =
-				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(8, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 2));
 static const struct dpu_sspp_sub_blks sm8550_vig_sblk_2 =
-				_VIG_SBLK(9, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(9, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 2));
 static const struct dpu_sspp_sub_blks sm8550_vig_sblk_3 =
-				_VIG_SBLK(10, DPU_SSPP_SCALER_QSEED4);
+				_VIG_SBLK(10, DPU_SSPP_SCALER_QSEED4,
+					  SSPP_SCALER_VER(3, 2));
 static const struct dpu_sspp_sub_blks sm8550_dma_sblk_4 = _DMA_SBLK(5);
 static const struct dpu_sspp_sub_blks sm8550_dma_sblk_5 = _DMA_SBLK(6);
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
index df024e10d3a3..62445075306a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.h
@@ -265,7 +265,8 @@ enum {
 /**
  * struct dpu_scaler_blk: Scaler information
  * @info:   HW register and features supported by this sub-blk
- * @version: qseed block revision
+ * @version: qseed block revision, on QSEED3+ platforms this is the value of
+ *           scaler_blk.base + QSEED3_HW_VERSION registers.
  */
 struct dpu_scaler_blk {
 	DPU_HW_SUBBLK_INFO;
-- 
2.43.0



