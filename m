Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CDD11706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F44FC433C8;
	Mon, 11 Sep 2023 14:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443540;
	bh=5bsPloSkr1GpG1WwvWZyDoKEE2sHRr2Wc2oM/hnA+yA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Quzd/pEvQEqbuTVm1jb0c0l5QkpsGKiwgPjR1H+CNFIqO1XooVodAWecD/XMEqTqE
	 T3B/dYJ6ddrsD3jb7kcdMY67S0KWVFzEqVFmEBjTZX5vU+qGUqIfFNdJxQRqxKiufF
	 ES6roQP+E9gVR/ihhOI86fdUwk1nGExsgpQNoLUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 413/737] clk: qcom: gcc-sc8280xp: Add missing GDSCs
Date: Mon, 11 Sep 2023 15:44:32 +0200
Message-ID: <20230911134702.154335843@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 4712eb7ff85bd3dd09c6668b8de4080e02b3eea9 ]

There are 10 more GDSCs that we've not been caring about, and by extension
(and perhaps even more importantly), not putting to sleep. Add them.

Fixes: d65d005f9a6c ("clk: qcom: add sc8280xp GCC driver")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20230620-topic-sc8280_gccgdsc-v2-3-562c1428c10d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc8280xp.c | 100 ++++++++++++++++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/drivers/clk/qcom/gcc-sc8280xp.c b/drivers/clk/qcom/gcc-sc8280xp.c
index 43c518e5c986b..57bbd609151cd 100644
--- a/drivers/clk/qcom/gcc-sc8280xp.c
+++ b/drivers/clk/qcom/gcc-sc8280xp.c
@@ -6896,6 +6896,96 @@ static struct gdsc emac_1_gdsc = {
 	.flags = RETAIN_FF_ENABLE,
 };
 
+static struct gdsc usb4_1_gdsc = {
+	.gdscr = 0xb8004,
+	.pd = {
+		.name = "usb4_1_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE,
+};
+
+static struct gdsc usb4_gdsc = {
+	.gdscr = 0x2a004,
+	.pd = {
+		.name = "usb4_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = RETAIN_FF_ENABLE,
+};
+
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
+static struct gdsc hlos1_vote_mmnoc_mmu_tbu_sf0_gdsc = {
+	.gdscr = 0x7d054,
+	.pd = {
+		.name = "hlos1_vote_mmnoc_mmu_tbu_sf0_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
+static struct gdsc hlos1_vote_mmnoc_mmu_tbu_sf1_gdsc = {
+	.gdscr = 0x7d06c,
+	.pd = {
+		.name = "hlos1_vote_mmnoc_mmu_tbu_sf1_gdsc",
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
+static struct gdsc hlos1_vote_turing_mmu_tbu2_gdsc = {
+	.gdscr = 0x7d0a0,
+	.pd = {
+		.name = "hlos1_vote_turing_mmu_tbu2_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
+static struct gdsc hlos1_vote_turing_mmu_tbu3_gdsc = {
+	.gdscr = 0x7d0a4,
+	.pd = {
+		.name = "hlos1_vote_turing_mmu_tbu3_gdsc",
+	},
+	.pwrsts = PWRSTS_OFF_ON,
+	.flags = VOTABLE,
+};
+
 static struct clk_regmap *gcc_sc8280xp_clocks[] = {
 	[GCC_AGGRE_NOC_PCIE0_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie0_tunnel_axi_clk.clkr,
 	[GCC_AGGRE_NOC_PCIE1_TUNNEL_AXI_CLK] = &gcc_aggre_noc_pcie1_tunnel_axi_clk.clkr,
@@ -7376,6 +7466,16 @@ static struct gdsc *gcc_sc8280xp_gdscs[] = {
 	[USB30_SEC_GDSC] = &usb30_sec_gdsc,
 	[EMAC_0_GDSC] = &emac_0_gdsc,
 	[EMAC_1_GDSC] = &emac_1_gdsc,
+	[USB4_1_GDSC] = &usb4_1_gdsc,
+	[USB4_GDSC] = &usb4_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_HF0_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_hf0_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_HF1_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_hf1_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_SF0_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_sf0_gdsc,
+	[HLOS1_VOTE_MMNOC_MMU_TBU_SF1_GDSC] = &hlos1_vote_mmnoc_mmu_tbu_sf1_gdsc,
+	[HLOS1_VOTE_TURING_MMU_TBU0_GDSC] = &hlos1_vote_turing_mmu_tbu0_gdsc,
+	[HLOS1_VOTE_TURING_MMU_TBU1_GDSC] = &hlos1_vote_turing_mmu_tbu1_gdsc,
+	[HLOS1_VOTE_TURING_MMU_TBU2_GDSC] = &hlos1_vote_turing_mmu_tbu2_gdsc,
+	[HLOS1_VOTE_TURING_MMU_TBU3_GDSC] = &hlos1_vote_turing_mmu_tbu3_gdsc,
 };
 
 static const struct clk_rcg_dfs_data gcc_dfs_clocks[] = {
-- 
2.40.1



