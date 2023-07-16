Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCBD8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12144C433C8;
	Sun, 16 Jul 2023 20:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538042;
	bh=XXonAq+0fvF7sUGPm7qYILO4ClJY6V23u++f0iYQs+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMBFp6Wv3w8K77+QRhGRjVFyYI6qpsDqpbvI2zFE9kIMyYOeAl0YPfygxkCBMUShg
	 S9WcT0qqTn6fYQkGxe1B8JbLmlIbh8J2lwlBvg4WLEFDWLt4vn7FB98tPnybjG4+zb
	 QeYmwhWr/hsfuCC+iVMFMmxSoP8N5iMBFcakBnAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 276/800] drm/msm/dpu: Use V4.0 PCC DSPP sub-block in SC7[12]80
Date: Sun, 16 Jul 2023 21:42:09 +0200
Message-ID: <20230716194955.503064163@linuxfoundation.org>
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

[ Upstream commit 853b292b92d50d1b30628c92229e93d670304e51 ]

According to various downstream sources the PCC sub-block inside DSPP is
version 4.0 since DPU 4.0 and higher, including SC7[12]80 at DPU version
6.2 and 7.2 respectively.  After correcting the version this struct
becomes identical to sm8150_dspp_sblk which is used all across the
catalog: replace uses of sc7180_dspp_sblk with that and remove
the struct definition for sc7180_dspp_sblk entirely.

Fixes: 4259ff7ae509e ("drm/msm/dpu: add support for pcc color block in dpu driver")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/537899/
Link: https://lore.kernel.org/r/20230518-dpu-sc7180-pcc-version-v1-1-ec9ca4949e3e@somainline.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h | 2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c         | 5 -----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h
index a46b11730a4d4..b08b3e9237b3a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_6_2_sc7180.h
@@ -76,7 +76,7 @@ static const struct dpu_lm_cfg sc7180_lm[] = {
 
 static const struct dpu_dspp_cfg sc7180_dspp[] = {
 	DSPP_BLK("dspp_0", DSPP_0, 0x54000, DSPP_SC7180_MASK,
-		 &sc7180_dspp_sblk),
+		 &sm8150_dspp_sblk),
 };
 
 static const struct dpu_pingpong_cfg sc7180_pp[] = {
diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
index 6b2c7eae71d99..9248479c60101 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
@@ -83,7 +83,7 @@ static const struct dpu_lm_cfg sc7280_lm[] = {
 
 static const struct dpu_dspp_cfg sc7280_dspp[] = {
 	DSPP_BLK("dspp_0", DSPP_0, 0x54000, DSPP_SC7180_MASK,
-		 &sc7180_dspp_sblk),
+		 &sm8150_dspp_sblk),
 };
 
 static const struct dpu_pingpong_cfg sc7280_pp[] = {
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
index 5d994bce696f9..5369b1e61ba7f 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c
@@ -453,11 +453,6 @@ static const struct dpu_dspp_sub_blks msm8998_dspp_sblk = {
 		.len = 0x90, .version = 0x10007},
 };
 
-static const struct dpu_dspp_sub_blks sc7180_dspp_sblk = {
-	.pcc = {.id = DPU_DSPP_PCC, .base = 0x1700,
-		.len = 0x90, .version = 0x10000},
-};
-
 static const struct dpu_dspp_sub_blks sm8150_dspp_sblk = {
 	.pcc = {.id = DPU_DSPP_PCC, .base = 0x1700,
 		.len = 0x90, .version = 0x40000},
-- 
2.39.2



