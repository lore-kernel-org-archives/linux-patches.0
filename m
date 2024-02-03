Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF911198;
	Sat,  3 Feb 2024 04:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933869; cv=none; b=jXdhfFOSHOrozc2ESIfuwsAVKj3JGTN7Wx1uNWJDDQXApHdk8wIbzx704hliAUrZXxxqZ4yJ5ZhSs7puOn1atGi62Fx4AjDD937wzqfovYbkEB5DRWOMKLzE3/kQc61hDwOfndCh4G9DXSAMiuroDE+k9IFhlyyU2qA55g02q10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933869; c=relaxed/simple;
	bh=yYN4jJyxYlpcON42lThOz6rmeuC+c0aO58VhcRcmAMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kp5W/0O7zlVwGJEWPDXWPGPz3chOMOlbBzYoAj2PCbAOavWMBgXFcwf6Xl0Dh5uRWod9M9qqqVR0SMD7f9UDqRomNCNiNQW22GXr8ax951KAgpxYkIbjvC38rMWu0Zu4XvW9eLhwafo4v3A0CDo6GubslfV0FYBCIdQuI9C+qgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OH/lUXCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OH/lUXCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A716DC433F1;
	Sat,  3 Feb 2024 04:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933869;
	bh=yYN4jJyxYlpcON42lThOz6rmeuC+c0aO58VhcRcmAMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OH/lUXCUf+xinj0OvyVA1DystwwvnnoUrmsTLqABW+52ccaFkBhg5Ql6W0EKgtS9X
	 9f31Whw8KNLf7Yk3xhtZK3M8tRr2XG4Ptr/FCxPpeOY+wMABcxm+u4lxj+k+EGzq7f
	 d/cV6UNlGEVY5WFdPg37OZJLdfMTNzILnx5R6yq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 207/353] drm/msm/dpu: enable writeback on SM8350
Date: Fri,  2 Feb 2024 20:05:25 -0800
Message-ID: <20240203035410.242872526@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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
index 1709ba57f384..022b0408c24d 100644
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
@@ -298,6 +299,21 @@ static const struct dpu_dsc_cfg sm8350_dsc[] = {
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
@@ -393,6 +409,8 @@ const struct dpu_mdss_cfg dpu_sm8350_cfg = {
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



