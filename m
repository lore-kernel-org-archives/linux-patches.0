Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF4E33A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302103; cv=none; b=KiqlfGn7yIPWzQrRDyJOf+wpzoHHXaehCbBtFmpOB1/9Rj8slycHah6qEQ3Rh0EuASxxiEm+vX4BhgOjKo92NG0+j+uQR8YjSb3sJ/Nhwv4CioIi2OJ1MmDOb8Sd0RcBmq5EwtEtgPyNdgKCjIwjdrngBcesrMplgI1aC9CzaqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302103; c=relaxed/simple;
	bh=R0hTfXyUKW4fM+sLUl3oKUHa7mszd+qH6NDEkfKlZgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qX69vcPL1BA2iMldBv7YgJDjsaR3oTtW+aPvet8OIuUmAM1IyN25KiiKuQCg7qZwP/HnCPMtSK+LdkkT6HKXuFgCf/iFB9DA7RcHy2iHkiTaKowkR3sv/MmETPwXswQg9PkdzmwB2vR3tUgmP96LC8xHzV3PklnNcff0HPBKTBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LboyWNSS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LboyWNSS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B979C19423;
	Sat, 28 Feb 2026 18:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302103;
	bh=R0hTfXyUKW4fM+sLUl3oKUHa7mszd+qH6NDEkfKlZgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LboyWNSSJW10UDmUlqPSAGaMJLsdYduHXTJucx+SN4mzKdmrQfYntVIlBqjiVPwon
	 a0FeM3U7vWRJXFmTIy3G4je7iyEnjkYInaFsdAlPf7tCcD7Za2f+zR6p9+5Gtf6edZ
	 bvY8uuvXt4PL2+jnO/FEv8HZCi2dXQCiAU5d60u6kUVN3D5SNvAzU3ji+8l5tdZwHT
	 Q/ZN0FBQKnmEoGNWwpTcRlMbrqtifIkQYmIntlobPZ0GhhnFR33Zp3i0XsnkbvFvZn
	 UyIHfXBF3b4Q+r9h5Z5EAqzuQ0y6YRVKvqjdtrmzv3u5MoVQtiFbfi0h1x4n1jXLdG
	 oOsRxg+bmlAqw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mahadevan P <mahadevan.p@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/283] drm/msm/disp/dpu: add merge3d support for sc7280
Date: Sat, 28 Feb 2026 13:03:52 -0500
Message-ID: <20260228180709.1583486-90-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mahadevan P <mahadevan.p@oss.qualcomm.com>

[ Upstream commit 2892de3f4f985fa779c330468e2f341fdb762ccd ]

On SC7280 targets, display modes with a width greater than the
max_mixer_width (2400) are rejected during mode validation when
merge3d is disabled. This limitation exists because, without a
3D merge block, two layer mixers cannot be combined(non-DSC interface),
preventing large layers from being split across mixers. As a result,
higher resolution modes cannot be supported.

Enable merge3d support on SC7280 to allow combining streams from
two layer mixers into a single non-DSC interface. This capability
removes the width restriction and enables buffer sizes beyond the
2400-pixel limit.

Fixes: 591e34a091d1 ("drm/msm/disp/dpu1: add support for display for SC7280 target")
Signed-off-by: Mahadevan P <mahadevan.p@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/696713/
Link: https://lore.kernel.org/r/20260101-4k-v2-1-712ae3c1f816@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
index 9195cb996f444..cbaca4bf2864a 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
@@ -14,6 +14,7 @@ static const struct dpu_caps sc7280_dpu_caps = {
 	.has_dim_layer = true,
 	.has_idle_pc = true,
 	.max_linewidth = 2400,
+	.has_3d_merge = true,
 	.pixel_ram_size = DEFAULT_PIXEL_RAM_SIZE,
 };
 
@@ -145,7 +146,7 @@ static const struct dpu_pingpong_cfg sc7280_pp[] = {
 		.base = 0x6b000, .len = 0,
 		.features = BIT(DPU_PINGPONG_DITHER),
 		.sblk = &sc7280_pp_sblk,
-		.merge_3d = 0,
+		.merge_3d = MERGE_3D_1,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 10),
 		.intr_rdptr = -1,
 	}, {
@@ -153,12 +154,19 @@ static const struct dpu_pingpong_cfg sc7280_pp[] = {
 		.base = 0x6c000, .len = 0,
 		.features = BIT(DPU_PINGPONG_DITHER),
 		.sblk = &sc7280_pp_sblk,
-		.merge_3d = 0,
+		.merge_3d = MERGE_3D_1,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 11),
 		.intr_rdptr = -1,
 	},
 };
 
+static const struct dpu_merge_3d_cfg sc7280_merge_3d[] = {
+	{
+		.name = "merge_3d_1", .id = MERGE_3D_1,
+		.base = 0x4f000, .len = 0x8,
+	},
+};
+
 /* NOTE: sc7280 only has one DSC hard slice encoder */
 static const struct dpu_dsc_cfg sc7280_dsc[] = {
 	{
@@ -265,6 +273,8 @@ const struct dpu_mdss_cfg dpu_sc7280_cfg = {
 	.mixer = sc7280_lm,
 	.pingpong_count = ARRAY_SIZE(sc7280_pp),
 	.pingpong = sc7280_pp,
+	.merge_3d_count = ARRAY_SIZE(sc7280_merge_3d),
+	.merge_3d = sc7280_merge_3d,
 	.dsc_count = ARRAY_SIZE(sc7280_dsc),
 	.dsc = sc7280_dsc,
 	.wb_count = ARRAY_SIZE(sc7280_wb),
-- 
2.51.0

