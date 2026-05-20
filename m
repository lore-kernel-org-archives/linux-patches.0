Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37A3BE64B;
	Wed, 20 May 2026 18:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301050; cv=none; b=lHphKOUFSf/VqcNdH4ZwMNpZBwcD2aie/JQGPlZJhirhIGCSWPLWguP9ZDnNIytlt7gxrGgWkdyIVvgc7OqEaOVg38Xs+WkODPMbwReDg/548Zqcg7xAjFReQOHAX2mlhVPuERCUq4ZBKqgATiSlyEzVIw50c3aR1ejoWxpnrlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301050; c=relaxed/simple;
	bh=q/ifJei6YYwInVkyVLqK7AXKH41/Kh7JhyUwSFW3DO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRQAHvQjPNKLfonMlPLjwVzc4zScQ6VISZhTFYlSfdhj0HheyOrOz76RrW3TFH8OwZcybKa7zNtr5rtwXNni/r46WNKHkK1YM/ZVwWJ2iOmmIxfnmokwu/gFfBQxU1A9C9rHuMEyPwTIzuay7h8/X1b5XGwJsWqnIFM+rtcnxU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trtIo/qO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trtIo/qO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725171F000E9;
	Wed, 20 May 2026 18:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301048;
	bh=aoQNONnmPRGAzE00BHhwxP1PMXXeVVJGkB3qtajSkHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trtIo/qOa//JVNnIdqJvVjvPkC2sU4LkLj7jdX+m0n14cuTZseFbKCgfB2IOpBSRG
	 YyVBZ3OFOi/RGXdgKXH5jorz6n1OhY10tWvc1mTGLRkWIIQEFkBU7NhKjB6thaMrva
	 8lWxoOc8Be3NoiCTJVsSn0xncWUz9w8Zpc63wIYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Val Packett <val@packett.cool>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/666] clk: qcom: gcc-sc8180x: Add missing GDSCs
Date: Wed, 20 May 2026 18:20:18 +0200
Message-ID: <20260520162120.082870336@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 3565741eb985a8a7cc6656eb33496195468cb99e ]

There are 5 more GDSCs that we were ignoring and not putting to sleep,
which are listed in downstream DTS. Add them.

Fixes: 4433594bbe5d ("clk: qcom: gcc: Add global clock controller driver for SC8180x")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Val Packett <val@packett.cool>
Link: https://lore.kernel.org/r/20260312112321.370983-3-val@packett.cool
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8180x.c | 50 ++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sc8180x.c b/drivers/clk/qcom/gcc-sc8180x.c
index 31e788e22ab4a..55dabf6259b29 100644
--- a/drivers/clk/qcom/gcc-sc8180x.c
+++ b/drivers/clk/qcom/gcc-sc8180x.c
@@ -4266,6 +4266,51 @@ static struct gdsc usb30_mp_gdsc = {
 	.flags = POLL_CFG_GDSCR,
 };
 
+static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc = {
+	.gdscr = 0x7d050,
+	.pd = {
+		.name = "hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
+static struct gdsc hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc = {
+	.gdscr = 0x7d058,
+	.pd = {
+		.name = "hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
+static struct gdsc hlos1_vote_mmnoc_mmu_tbu_sf_gdsc = {
+	.gdscr = 0x7d054,
+	.pd = {
+		.name = "hlos1_vote_mmnoc_mmu_tbu_sf_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
+static struct gdsc hlos1_vote_turing_mmu_tbu0_gdsc = {
+	.gdscr = 0x7d05c,
+	.pd = {
+		.name = "hlos1_vote_turing_mmu_tbu0_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
+static struct gdsc hlos1_vote_turing_mmu_tbu1_gdsc = {
+	.gdscr = 0x7d060,
+	.pd = {
+		.name = "hlos1_vote_turing_mmu_tbu1_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
 static struct clk_regmap *gcc_sc8180x_clocks[] = {
 	[GCC_AGGRE_NOC_PCIE_TBU_CLK] = &gcc_aggre_noc_pcie_tbu_clk.clkr,
 	[GCC_AGGRE_UFS_CARD_AXI_CLK] = &gcc_aggre_ufs_card_axi_clk.clkr,
@@ -4595,6 +4640,11 @@ static struct gdsc *gcc_sc8180x_gdscs[] = {
 	[USB30_MP_GDSC] = &usb30_mp_gdsc,
 	[USB30_PRIM_GDSC] = &usb30_prim_gdsc,
 	[USB30_SEC_GDSC] = &usb30_sec_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_HF0_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_HF1_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_SF_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_sf_gdsc,
+	[HLOS1_VOTE_TURING_MMU_TBU0_GDSC] = &hlos1_vote_turing_mmu_tbu0_gdsc,
+	[HLOS1_VOTE_TURING_MMU_TBU1_GDSC] = &hlos1_vote_turing_mmu_tbu1_gdsc,
 };
 
 static const struct regmap_config gcc_sc8180x_regmap_config = {
-- 
2.53.0



