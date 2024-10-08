Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646751DFDAC;
	Tue,  8 Oct 2024 13:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394202; cv=none; b=kVJP7p4Ws1DCgM4GqVzuFtWsBsIufa1mkicmrLM0LkFcdPCm3gLcqzlKHIuPiGMC+gagdxprpenSA3pFE0t1z96WPkj8TtQGRbyPPpLiDvpRC4+Q1PES3c/1KTatqa76LV2waJXaSXJ1HUtpOQvD/QS6k2tFGkOhINs2oPmpSok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394202; c=relaxed/simple;
	bh=MDFR5Vr4EYHDXVDG7hAHvUuEukT1dyK3PEfKl54Fm8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOuQbED56uXL0iO6Y55BF+0EEvAJl7r36XFP7uJ0l9mQLqXWu8h7KrYqlXxznrBR7B6YWpJ+pPdPOalG3yJK96XLLC6AO9RC7cbDIKKvFzd9TWdWRhmwenpKSnoND0TOUiAzNbaSVZnU7I25b4dRdYLWR4Ol+B7QynuoobC4Ns4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLpbY9Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLpbY9Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46DAC4CEC7;
	Tue,  8 Oct 2024 13:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394202;
	bh=MDFR5Vr4EYHDXVDG7hAHvUuEukT1dyK3PEfKl54Fm8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLpbY9Jru5HoxEJRqEDu1BzYm2qMJ26gpWzHpRSzWVP6v6JZyPEPCS7svtiU+sY3Z
	 73UxwHXq+30a6NuE+FH0uQdYlybOmPIqeLwpf4m+/F0yFVyR4l7ciP2suPPGmUIYSG
	 vwdesDEANFGeFSk6rdLPXMQUpwhIpNfORVbyx/j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Satya Priya Kakitapalli <quic_skakitap@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 360/386] clk: qcom: gcc-sc8180x: Add GPLL9 support
Date: Tue,  8 Oct 2024 14:10:05 +0200
Message-ID: <20241008115643.549097882@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

From: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>

[ Upstream commit 818a2f8d5e4ad2c1e39a4290158fe8e39a744c70 ]

Add the missing GPLL9 pll and fix the gcc_parents_7 data to use
the correct pll hw.

Fixes: 4433594bbe5d ("clk: qcom: gcc: Add global clock controller driver for SC8180x")
Cc: stable@vger.kernel.org
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Satya Priya Kakitapalli <quic_skakitap@quicinc.com>
Link: https://lore.kernel.org/r/20240812-gcc-sc8180x-fixes-v2-3-8b3eaa5fb856@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8180x.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sc8180x.c b/drivers/clk/qcom/gcc-sc8180x.c
index 283bda4d1e701..ec0c45881c67a 100644
--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -142,6 +142,23 @@ static struct clk_alpha_pll gpll7 = {
 	},
 };
 
+static struct clk_alpha_pll gpll9 = {
+	.offset = 0x1c000,
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_TRION],
+	.clkr = {
+		.enable_reg = 0x52000,
+		.enable_mask = BIT(9),
+		.hw.init = &(const struct clk_init_data) {
+			.name = "gpll9",
+			.parent_data = &(const struct clk_parent_data) {
+				.fw_name = "bi_tcxo",
+			},
+			.num_parents = 1,
+			.ops = &clk_alpha_pll_fixed_trion_ops,
+		},
+	},
+};
+
 static const struct parent_map gcc_parent_map_0[] = {
 	{ P_BI_TCXO, 0 },
 	{ P_GPLL0_OUT_MAIN, 1 },
@@ -241,7 +258,7 @@ static const struct parent_map gcc_parent_map_7[] = {
 static const struct clk_parent_data gcc_parents_7[] = {
 	{ .fw_name = "bi_tcxo", },
 	{ .hw = &gpll0.clkr.hw },
-	{ .name = "gppl9" },
+	{ .hw = &gpll9.clkr.hw },
 	{ .hw = &gpll4.clkr.hw },
 	{ .hw = &gpll0_out_even.clkr.hw },
 };
@@ -4419,6 +4436,7 @@ static struct clk_regmap *gcc_sc8180x_clocks[] = {
 	[GPLL1] = &gpll1.clkr,
 	[GPLL4] = &gpll4.clkr,
 	[GPLL7] = &gpll7.clkr,
+	[GPLL9] = &gpll9.clkr,
 };
 
 static const struct qcom_reset_map gcc_sc8180x_resets[] = {
-- 
2.43.0



