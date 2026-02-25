Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411041D5ABA;
	Wed, 25 Feb 2026 01:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983088; cv=none; b=T+6Y5aRoaBuaexvd6L8eQa2QBbGNlOoNaj2T2isacGhnSdOPFVRoldqgixwcmx/cFMg3GDhF4VgUtZQoZuUISj3bMjuXupxU9iUeBBzJJi4JLhxwZELzXSxdLGFTvFbWvpqNxEATsJPtgZAamT4+dvyNJOyeNqjCYWeU31ljlT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983088; c=relaxed/simple;
	bh=0XWvAiQjbld8vm+99SokePp/JaOChoBMaaM/EDAfnjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKb2nfxZuA+Ps/rd1f/ej/7kPLB7O9uhC48TxEpCrFHwechaXwbvEeqELyiXfGW/wIEzf8xtpfJUD01gQvsP5Ya8j1qWzVy5w3U7e+Is1RozAJjsGhTRzKVud2sfI9OMf2wa3t7g2Erx6h4AUDTcKG66JLijPxdo8DGMzBwe350=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASs3kfhe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASs3kfhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE877C116D0;
	Wed, 25 Feb 2026 01:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983087;
	bh=0XWvAiQjbld8vm+99SokePp/JaOChoBMaaM/EDAfnjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASs3kfhe0ZG9rmeAYgOmIxoKiO6Sd2jCdrijWhMuKVabxyMHbv6WkaeQc1H0CfB9U
	 QP6OtSPRf6sU6DkayQ1P5TmyAn6HnGTZc2qNtHEWXgK9qXK+wWiuwBZ/Oi+HsXu/1P
	 VoTkaef/s1sFWdqw82s4Li88zO3TDWMxZOS05lcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahadevan P <mahadevan.p@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 247/781] drm/msm/disp/dpu: add merge3d support for sc7280
Date: Tue, 24 Feb 2026 17:15:56 -0800
Message-ID: <20260225012405.766206459@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 8f978b9c34520..2f8688224f343 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_2_sc7280.h
@@ -13,6 +13,7 @@ static const struct dpu_caps sc7280_dpu_caps = {
 	.has_dim_layer = true,
 	.has_idle_pc = true,
 	.max_linewidth = 2400,
+	.has_3d_merge = true,
 	.pixel_ram_size = DEFAULT_PIXEL_RAM_SIZE,
 };
 
@@ -134,17 +135,24 @@ static const struct dpu_pingpong_cfg sc7280_pp[] = {
 		.name = "pingpong_2", .id = PINGPONG_2,
 		.base = 0x6b000, .len = 0,
 		.sblk = &sc7280_pp_sblk,
-		.merge_3d = 0,
+		.merge_3d = MERGE_3D_1,
 		.intr_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 10),
 	}, {
 		.name = "pingpong_3", .id = PINGPONG_3,
 		.base = 0x6c000, .len = 0,
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
@@ -247,6 +255,8 @@ const struct dpu_mdss_cfg dpu_sc7280_cfg = {
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



