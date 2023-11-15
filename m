Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6038943AAE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oabb78+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 106CBC4E77A;
	Wed, 15 Nov 2023 20:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081648;
	bh=/dSX5qNd97LZxCOtIoLeAzkvTYu3eGXuGJ8hq0HETcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oabb78+iw8G21+FaAvxiqUJG5FwgW2Re2zXVQ/oacBnKqhlDJD/btVF92lxs/nqwm
	 6DISC6qlB3O+Ql2vlKfO78yjgVJZcuXjL1rMi8/8CCAnntAcco3ENLjD8MP959l5Ku
	 ns3v/gZbWlU5r18qL9f5TVLAYumqK8Cib9zyQzcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/191] clk: qcom: mmcc-msm8998: Add hardware clockgating registers to some clks
Date: Wed, 15 Nov 2023 15:45:13 -0500
Message-ID: <20231115204646.846217878@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>

[ Upstream commit fa92f3b093d6ca624f42d444d5a206f8724b6bb3 ]

Hardware clock gating is supported on some of the clocks declared in
there: ignoring that it does exist may lead to unstabilities on some
firmwares.
Add the HWCG registers where applicable to stop potential crashes.

This was verified on a smartphone shipped with a recent MSM8998
firmware, which will experience random crashes without this change.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Link: https://lore.kernel.org/r/20210114221059.483390-9-angelogioacchino.delregno@somainline.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 9906c4140897 ("clk: qcom: mmcc-msm8998: Don't check halt bit on some branch clks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/mmcc-msm8998.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/clk/qcom/mmcc-msm8998.c b/drivers/clk/qcom/mmcc-msm8998.c
index dd68983fe22ef..0f7c2a48ef2e6 100644
--- a/drivers/clk/qcom/mmcc-msm8998.c
+++ b/drivers/clk/qcom/mmcc-msm8998.c
@@ -1211,6 +1211,8 @@ static struct clk_rcg2 vfe1_clk_src = {
 
 static struct clk_branch misc_ahb_clk = {
 	.halt_reg = 0x328,
+	.hwcg_reg = 0x328,
+	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x328,
 		.enable_mask = BIT(0),
@@ -1241,6 +1243,8 @@ static struct clk_branch video_core_clk = {
 
 static struct clk_branch video_ahb_clk = {
 	.halt_reg = 0x1030,
+	.hwcg_reg = 0x1030,
+	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x1030,
 		.enable_mask = BIT(0),
@@ -1315,6 +1319,8 @@ static struct clk_branch video_subcore1_clk = {
 
 static struct clk_branch mdss_ahb_clk = {
 	.halt_reg = 0x2308,
+	.hwcg_reg = 0x2308,
+	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0x2308,
 		.enable_mask = BIT(0),
@@ -2496,6 +2502,8 @@ static struct clk_branch mnoc_ahb_clk = {
 
 static struct clk_branch bimc_smmu_ahb_clk = {
 	.halt_reg = 0xe004,
+	.hwcg_reg = 0xe004,
+	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0xe004,
 		.enable_mask = BIT(0),
@@ -2511,6 +2519,8 @@ static struct clk_branch bimc_smmu_ahb_clk = {
 
 static struct clk_branch bimc_smmu_axi_clk = {
 	.halt_reg = 0xe008,
+	.hwcg_reg = 0xe008,
+	.hwcg_bit = 1,
 	.clkr = {
 		.enable_reg = 0xe008,
 		.enable_mask = BIT(0),
-- 
2.42.0



