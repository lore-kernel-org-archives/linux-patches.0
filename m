Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF5DA342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301748; cv=none; b=BKrj4x6XFxVHofv+nwFIeqawICuWK1xFoQQ+7prkWNxeL9XKTuNKbei0qQIFH3rhN/7eE/DznojQ3aDdqoYN/Gl29xlqEGOq5JqDSj9sHTcA9+yBy4/DiXi/Q0gN7AbjIzOzNq6B9NZIhQSmrUtScfe3cBa4KnRwxm0sNeIsZ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301748; c=relaxed/simple;
	bh=IIGxQldHs8cRQBGrxUf4rh5RrjDNtXoJD23FnyhGgNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2XeJfxxH0WCaaGlkJoBzKRzLU+jWhjLDbx4Cj/EJGYipZdLXlnAKU8O95uxUqcGH2Oh8WQUEBuE6pSN+MpYs1kFNEnmA9XSW+OUQquWDBK7hEWzBf2UNYjYAAfmtLVztcOvEGZjz4EDOj6fsrzdSqO4msiSSfuNSp2L4Rg2tMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fw821req; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fw821req"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D68CC19423;
	Sat, 28 Feb 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301748;
	bh=IIGxQldHs8cRQBGrxUf4rh5RrjDNtXoJD23FnyhGgNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw821reqasIxewHZXzZd2BXnts4/V9/EQqV8OgZCJZ9gBRZ2FlJrvnZx9PGjnOzQH
	 S3UZ2KzhnF3qcG+IS34b61S58L2Q4/lNE5LHzepNG/cgsAnAANdd64nYHDNeK/D2qm
	 6NMfQNDiE+EXHmneSIyI9dX5ey/uIhheubh/Bukq+vL8vwWVIpBAHiP2HJ1mO5+87a
	 q7oeuiJlu/wMTcuFDaS/OnBRyArYTaHUNFrrweLzcD1stsEjr1j/AwA9yEkicGeVK8
	 r76aPBEiyB5b8GHm4lMfv8ofLbDs3Hwmh/uF/5YAPXHSDOYzlRpaPG4zBrtNUNQ/we
	 YNBkc9LC2klMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Mahadevan P <mahadevan.p@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/385] drm/msm/disp/dpu: add merge3d support for sc7280
Date: Sat, 28 Feb 2026 12:56:13 -0500
Message-ID: <20260228180011.1568201-151-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 2f153e0b5c6a9..d53ab3d886262 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
@@ -13,6 +13,7 @@ static const struct dpu_caps sc7280_dpu_caps = {
 	.has_dim_layer = true,
 	.has_idle_pc = true,
 	.max_linewidth = 2400,
+	.has_3d_merge = true,
 	.pixel_ram_size = DEFAULT_PIXEL_RAM_SIZE,
 };
 
@@ -142,18 +143,25 @@ static const struct dpu_pingpong_cfg sc7280_pp[] = {
 		.base = 0x6b000, .len = 0,
 		.features = BIT(DPU_PINGPONG_DITHER),
 		.sblk = &sc7280_pp_sblk,
-		.merge_3d = 0,
+		.merge_3d = MERGE_3D_1,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 10),
 	}, {
 		.name = "pingpong_3", .id = PINGPONG_3,
 		.base = 0x6c000, .len = 0,
 		.features = BIT(DPU_PINGPONG_DITHER),
 		.sblk = &sc7280_pp_sblk,
-		.merge_3d = 0,
+		.merge_3d = MERGE_3D_1,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 11),
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
@@ -259,6 +267,8 @@ const struct dpu_mdss_cfg dpu_sc7280_cfg = {
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

