Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC2918A6B9;
	Tue, 10 Sep 2024 10:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964694; cv=none; b=pypCLjUUgfQ2xFi96pAhJc8auCfJDN6HZwiPpXjHUHBEDIhb9eHgW+iU3L9IpAGXBlH7tsby/LToSYDvWGLX5JlatGSc2Vgs6N9y4aUgWe5eek5MxXRUZ5zXYvf3A7U1t1hO1OZWz5L/zCH5nvioXrkWSlddAUqHDzeoLR/+H04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964694; c=relaxed/simple;
	bh=ifdGWo664eVzvkjZs4iB+kjUBi+J34JBWp8PNAKwfZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+apKf9BL9lcA6wyS7QpgOwp3vy7BlPa76Ujl5ButSpB/THiDlal+XIVT+xl68YwrSpg31NqPYC1hvrJ/3rcd95QoDAJbXs0kqGvrz89eSVyO9Dc3WdEjUtD3nBcsvGuS4yrPOALDcX30f1larXwFUKyEzu1ClzzMQcXqC7v8z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GAdsukbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GAdsukbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2385BC4CEC3;
	Tue, 10 Sep 2024 10:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964694;
	bh=ifdGWo664eVzvkjZs4iB+kjUBi+J34JBWp8PNAKwfZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GAdsukbDRfZjhG5a5rh1NJlxhE0h5YLxN9js/WdkHhVmUb3qNN3npMa26KInnU2zw
	 MVp5IvMzGWmLq8vpNNfuATXHa4/NcPJcyteYkCAH4RNfT3dlezGZHt5iu4XvnJINNU
	 XAjQMo3JtojWbYCkreMdcpvmyaL2LwpldINJ0muM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	devi priya <quic_devipriy@quicinc.com>,
	Amandeep Singh <quic_amansing@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/269] clk: qcom: ipq9574: Update the alpha PLL type for GPLLs
Date: Tue, 10 Sep 2024 11:33:50 +0200
Message-ID: <20240910092616.520394839@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

From: devi priya <quic_devipriy@quicinc.com>

[ Upstream commit 6357efe3abead68048729adf11a9363881657939 ]

Update PLL offsets to DEFAULT_EVO to configure MDIO to 800MHz.

The incorrect clock frequency leads to an incorrect MDIO clock. This,
in turn, affects the MDIO hardware configurations as the divider is
calculated from the MDIO clock frequency. If the clock frequency is
not as expected, the MDIO register fails due to the generation of an
incorrect MDIO frequency.

This issue is critical as it results in incorrect MDIO configurations
and ultimately leads to the MDIO function not working. This results in
a complete feature failure affecting all Ethernet PHYs. Specifically,
Ethernet will not work on IPQ9574 due to this issue.

Currently, the clock frequency is set to CLK_ALPHA_PLL_TYPE_DEFAULT.
However, this setting does not yield the expected clock frequency.
To rectify this, we need to change this to CLK_ALPHA_PLL_TYPE_DEFAULT_EVO.

This modification ensures that the clock frequency aligns with our
expectations, thereby resolving the MDIO register failure and ensuring
the proper functioning of the Ethernet on IPQ9574.

Fixes: d75b82cff488 ("clk: qcom: Add Global Clock Controller driver for IPQ9574")
Signed-off-by: devi priya <quic_devipriy@quicinc.com>
Signed-off-by: Amandeep Singh <quic_amansing@quicinc.com>
Link: https://lore.kernel.org/r/20240806061105.2849944-1-quic_amansing@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq9574.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/qcom/gcc-ipq9574.c b/drivers/clk/qcom/gcc-ipq9574.c
index f8b9a1e93bef..cdbbf2cc9c5d 100644
--- a/drivers/clk/qcom/gcc-ipq9574.c
+++ b/drivers/clk/qcom/gcc-ipq9574.c
@@ -65,7 +65,7 @@ static const struct clk_parent_data gcc_sleep_clk_data[] = {
 
 static struct clk_alpha_pll gpll0_main = {
 	.offset = 0x20000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT_EVO],
 	.clkr = {
 		.enable_reg = 0x0b000,
 		.enable_mask = BIT(0),
@@ -93,7 +93,7 @@ static struct clk_fixed_factor gpll0_out_main_div2 = {
 
 static struct clk_alpha_pll_postdiv gpll0 = {
 	.offset = 0x20000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT_EVO],
 	.width = 4,
 	.clkr.hw.init = &(const struct clk_init_data) {
 		.name = "gpll0",
@@ -107,7 +107,7 @@ static struct clk_alpha_pll_postdiv gpll0 = {
 
 static struct clk_alpha_pll gpll4_main = {
 	.offset = 0x22000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT_EVO],
 	.clkr = {
 		.enable_reg = 0x0b000,
 		.enable_mask = BIT(2),
@@ -122,7 +122,7 @@ static struct clk_alpha_pll gpll4_main = {
 
 static struct clk_alpha_pll_postdiv gpll4 = {
 	.offset = 0x22000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT_EVO],
 	.width = 4,
 	.clkr.hw.init = &(const struct clk_init_data) {
 		.name = "gpll4",
@@ -136,7 +136,7 @@ static struct clk_alpha_pll_postdiv gpll4 = {
 
 static struct clk_alpha_pll gpll2_main = {
 	.offset = 0x21000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT_EVO],
 	.clkr = {
 		.enable_reg = 0x0b000,
 		.enable_mask = BIT(1),
@@ -151,7 +151,7 @@ static struct clk_alpha_pll gpll2_main = {
 
 static struct clk_alpha_pll_postdiv gpll2 = {
 	.offset = 0x21000,
-	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT],
+	.regs = clk_alpha_pll_regs[CLK_ALPHA_PLL_TYPE_DEFAULT_EVO],
 	.width = 4,
 	.clkr.hw.init = &(const struct clk_init_data) {
 		.name = "gpll2",
-- 
2.43.0



