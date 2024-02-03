Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60BC3CF58;
	Sat,  3 Feb 2024 04:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933620; cv=none; b=PrX+VAva3EodLCzQlQWVpUzuM3oDQufzyAOwkDzTEc21jU2afs6B971TK8xB87C/9nGGLVJqqbSxSwMIpdSVs1x35SegHOMeux7wmvHh8egBL+1/GHaD0dS7d2rygFNKXi8HO4sLAz8bOjYJqpheL14ZIMuNhudtQT6ZGMZq4Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933620; c=relaxed/simple;
	bh=p8Ev3G+JDMpzO5bBfQmRjKItd0AZUblnn9HKFjIvpPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WC4r5OytMZJWBKO5vcF5sBYD3SnjVKFz2NYCmlnQrWDZdFxfT8FGjpBaL6vpZgHJ8ngKzDBccsLle/lzHFZz02Cioc63YcIdNyGSLUfNABPbXzibUHmVEaFE9cHFWLpzMUSYA5kVNFcehCdkGGv52zgFp9QK8E4P6b5OymeDsSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFRtevxg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFRtevxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE37C43394;
	Sat,  3 Feb 2024 04:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933620;
	bh=p8Ev3G+JDMpzO5bBfQmRjKItd0AZUblnn9HKFjIvpPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFRtevxgvILIGgnzs411aLpTJdWaPBwr3eseK67Ov5Xkh2VwDtoRwYOpOtpt1qzKO
	 SvDaMO5xkalsSLrwxF+mKG0G7BPmb1VgLLj8WuCnuALIwSrDG6dVxI/D6W/l/qM31r
	 1sYrpFhuYly/dGPGxGW5RxIFxvsMYJ9fFYYdQH0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/322] drm/msm/dpu: enable writeback on SM8350
Date: Fri,  2 Feb 2024 20:04:53 -0800
Message-ID: <20240203035405.573933488@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit c2949a49dfe960e952400029e14751dceff79d38 ]

Enable WB2 hardware block, enabling writeback support on this platform.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/570188/
Link: https://lore.kernel.org/r/20231203002743.1291956-3-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
index f8d16f9bf528..428bcbcfbf19 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/catalog/dpu_7_0_sm8350.h
@@ -31,6 +31,7 @@ static const struct dpu_mdp_cfg sm8350_mdp = {
 		[DPU_CLK_CTRL_DMA1] = { .reg_off = 0x2b4, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA2] = { .reg_off = 0x2bc, .bit_off = 8 },
 		[DPU_CLK_CTRL_DMA3] = { .reg_off = 0x2c4, .bit_off = 8 },
+		[DPU_CLK_CTRL_WB2] = { .reg_off = 0x2bc, .bit_off = 16 },
 		[DPU_CLK_CTRL_REG_DMA] = { .reg_off = 0x2bc, .bit_off = 20 },
 	},
 };
@@ -304,6 +305,21 @@ static const struct dpu_dsc_cfg sm8350_dsc[] = {
 	},
 };
 
+static const struct dpu_wb_cfg sm8350_wb[] = {
+	{
+		.name = "wb_2", .id = WB_2,
+		.base = 0x65000, .len = 0x2c8,
+		.features = WB_SM8250_MASK,
+		.format_list = wb2_formats,
+		.num_formats = ARRAY_SIZE(wb2_formats),
+		.clk_ctrl = DPU_CLK_CTRL_WB2,
+		.xin_id = 6,
+		.vbif_idx = VBIF_RT,
+		.maxlinewidth = 4096,
+		.intr_wb_done = DPU_IRQ_IDX(MDP_SSPP_TOP0_INTR, 4),
+	},
+};
+
 static const struct dpu_intf_cfg sm8350_intf[] = {
 	{
 		.name = "intf_0", .id = INTF_0,
@@ -401,6 +417,8 @@ const struct dpu_mdss_cfg dpu_sm8350_cfg = {
 	.dsc = sm8350_dsc,
 	.merge_3d_count = ARRAY_SIZE(sm8350_merge_3d),
 	.merge_3d = sm8350_merge_3d,
+	.wb_count = ARRAY_SIZE(sm8350_wb),
+	.wb = sm8350_wb,
 	.intf_count = ARRAY_SIZE(sm8350_intf),
 	.intf = sm8350_intf,
 	.vbif_count = ARRAY_SIZE(sdm845_vbif),
-- 
2.43.0



