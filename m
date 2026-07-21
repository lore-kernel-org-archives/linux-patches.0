Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7552DEA74;
	Tue, 21 Jul 2026 18:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660376; cv=none; b=n7PoCjRTsswJ0JXdD4Btbg0ncOTEZyoiIQlX4DdqjhQjFuqlJvlZcB5yd5KZXXeXgNo1nBaYTN7zBO0h1dMEnUOmgJPiLMou4GJpGR3qEa+3/Du5nwF6fNiXKOH5iQINsBwl3hXzw3p3p8MdfDQa0zTrZY/OZwv5yMavPdZOrYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660376; c=relaxed/simple;
	bh=Quoqd6e8OH5USLRa5j4QlC7BNjkF+IrALC+BtxNUK3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rk0yCggI7G5LR8IsAiwpaVjg6cXybUZ+2VVZD6j/S66ugSRQo9hpdZ7vu63aiZ1IGlkmXP7JHT5Q+/dpEarZ5e/eFV6vmclsW21EEUAlXxN3Z7FcIv4th6kMRY7ziEWqQvdZ7ra07+iDmo9ylNGfCc2DQnYy3XkNsdS2YzGxNBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MEPMJ2BM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MEPMJ2BM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEE11F000E9;
	Tue, 21 Jul 2026 18:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660374;
	bh=TgMB2jRw2lKABaLtA4F0f+LQGRObTTQNxjplZox/GOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MEPMJ2BMtz9KTw3YVSKj3kRUwCJl8NrVDlyZvXHGtB9HCEExn5Z3ajwQw6qCVHAMp
	 13w9+o4gLjxA6YAtEeHWM4vSdYt3ilC4fdOLF+oIUbF0PX1MuwgC/6ZyImAIbxI7fF
	 Qe/bGuWgNqKEx0jwBEUfAlukVb2QgBva/MTfufCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0955/2077] clk: qcom: camcc-x1e80100: Add support for camera QDSS debug clocks
Date: Tue, 21 Jul 2026 17:10:28 +0200
Message-ID: <20260721152615.345953797@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>

[ Upstream commit 1e6ae74ac6f28ace7a0eb84897c6e17bb044e5de ]

Add support for camera QDSS debug clocks on X1E80100 platform which
are required to be voted for camera icp and cpas usecases. This change
aligns the camcc driver to the new ABI exposed from X1E80100 camcc
bindings that supports these camcc QDSS debug clocks.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Jagadeesh Kona <jagadeesh.kona@oss.qualcomm.com>
Fixes: 76126a5129b5 ("clk: qcom: Add camcc clock driver for x1e80100")
Link: https://lore.kernel.org/r/20260507-purwa-videocc-camcc-v5-4-fc3af4130282@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-x1e80100.c | 64 +++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/clk/qcom/camcc-x1e80100.c b/drivers/clk/qcom/camcc-x1e80100.c
index 81f579ff699334..c12994af42cfc4 100644
--- a/drivers/clk/qcom/camcc-x1e80100.c
+++ b/drivers/clk/qcom/camcc-x1e80100.c
@@ -1052,6 +1052,31 @@ static struct clk_rcg2 cam_cc_mclk7_clk_src = {
 	},
 };
 
+static const struct freq_tbl ftbl_cam_cc_qdss_debug_clk_src[] = {
+	F(19200000, P_BI_TCXO, 1, 0, 0),
+	F(60000000, P_CAM_CC_PLL8_OUT_EVEN, 8, 0, 0),
+	F(75000000, P_CAM_CC_PLL0_OUT_EVEN, 8, 0, 0),
+	F(150000000, P_CAM_CC_PLL0_OUT_EVEN, 4, 0, 0),
+	F(300000000, P_CAM_CC_PLL0_OUT_MAIN, 4, 0, 0),
+	{ }
+};
+
+static struct clk_rcg2 cam_cc_qdss_debug_clk_src = {
+	.cmd_rcgr = 0x13938,
+	.mnd_width = 0,
+	.hid_width = 5,
+	.parent_map = cam_cc_parent_map_0,
+	.freq_tbl = ftbl_cam_cc_qdss_debug_clk_src,
+	.hw_clk_ctrl = true,
+	.clkr.hw.init = &(const struct clk_init_data) {
+		.name = "cam_cc_qdss_debug_clk_src",
+		.parent_data = cam_cc_parent_data_0,
+		.num_parents = ARRAY_SIZE(cam_cc_parent_data_0),
+		.flags = CLK_SET_RATE_PARENT,
+		.ops = &clk_rcg2_shared_ops,
+	},
+};
+
 static const struct freq_tbl ftbl_cam_cc_sfe_0_clk_src[] = {
 	F(345600000, P_CAM_CC_PLL6_OUT_EVEN, 1, 0, 0),
 	F(432000000, P_CAM_CC_PLL6_OUT_EVEN, 1, 0, 0),
@@ -2182,6 +2207,42 @@ static struct clk_branch cam_cc_mclk7_clk = {
 	},
 };
 
+static struct clk_branch cam_cc_qdss_debug_clk = {
+	.halt_reg = 0x13a64,
+	.halt_check = BRANCH_HALT,
+	.clkr = {
+		.enable_reg = 0x13a64,
+		.enable_mask = BIT(0),
+		.hw.init = &(const struct clk_init_data) {
+			.name = "cam_cc_qdss_debug_clk",
+			.parent_hws = (const struct clk_hw*[]) {
+				&cam_cc_qdss_debug_clk_src.clkr.hw,
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
+static struct clk_branch cam_cc_qdss_debug_xo_clk = {
+	.halt_reg = 0x13a68,
+	.halt_check = BRANCH_HALT,
+	.clkr = {
+		.enable_reg = 0x13a68,
+		.enable_mask = BIT(0),
+		.hw.init = &(const struct clk_init_data) {
+			.name = "cam_cc_qdss_debug_xo_clk",
+			.parent_hws = (const struct clk_hw*[]) {
+				&cam_cc_xo_clk_src.clkr.hw,
+			},
+			.num_parents = 1,
+			.flags = CLK_SET_RATE_PARENT,
+			.ops = &clk_branch2_ops,
+		},
+	},
+};
+
 static struct clk_branch cam_cc_sfe_0_clk = {
 	.halt_reg = 0x133c0,
 	.halt_check = BRANCH_HALT,
@@ -2398,6 +2459,9 @@ static struct clk_regmap *cam_cc_x1e80100_clocks[] = {
 	[CAM_CC_PLL6_OUT_EVEN] = &cam_cc_pll6_out_even.clkr,
 	[CAM_CC_PLL8] = &cam_cc_pll8.clkr,
 	[CAM_CC_PLL8_OUT_EVEN] = &cam_cc_pll8_out_even.clkr,
+	[CAM_CC_QDSS_DEBUG_CLK] = &cam_cc_qdss_debug_clk.clkr,
+	[CAM_CC_QDSS_DEBUG_CLK_SRC] = &cam_cc_qdss_debug_clk_src.clkr,
+	[CAM_CC_QDSS_DEBUG_XO_CLK] = &cam_cc_qdss_debug_xo_clk.clkr,
 	[CAM_CC_SFE_0_CLK] = &cam_cc_sfe_0_clk.clkr,
 	[CAM_CC_SFE_0_CLK_SRC] = &cam_cc_sfe_0_clk_src.clkr,
 	[CAM_CC_SFE_0_FAST_AHB_CLK] = &cam_cc_sfe_0_fast_ahb_clk.clkr,
-- 
2.53.0



