Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC231EEC9;
	Tue, 10 Sep 2024 09:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962225; cv=none; b=PZBo0Pnu+WlFqEuN5X2jmFOCarlkd4OpHT45Z3tMTBB7M0XUhvuFUlXYVnJnloAGcGKi7CnynYRZq4W5cD6TOKDMK9fAA7TuNKk6oP3+G2WJtMdUe9SM6XEueewmKZjQBDXh6L+Ruxs1s3SVuZqXLSRbM4e719LzNdGgKLeSMlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962225; c=relaxed/simple;
	bh=n/NQI/bF5Tf1+5ajBsYKa41DBhwrJv/biF2hjmCeW0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIANFdxzFEbzfcnzhs43WGyOCM2ErRQyM1FT5937trxbaw1DXD7kuIZKrOpkEBsPY+CBjeYVA6h9YSRa3QzgSAXR8qrD0zJkeNR639msRaZK7vyntIWgujpsuSqKHOJsXVt56433hyKECH2jYK0PnUOn9DcY/QQyNQawcAs1R3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJf4UTHf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJf4UTHf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05556C4CECE;
	Tue, 10 Sep 2024 09:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962225;
	bh=n/NQI/bF5Tf1+5ajBsYKa41DBhwrJv/biF2hjmCeW0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJf4UTHfvWmuMfBirxV7CN1c1/rbmzQ4y9SkikazcQ5qZFJ9dGvRBW8PXuF2V9IbV
	 /WQT1DauGVj3XaXUQoi8Gwr5KKQrB4AZGagWWftHQiF4jKEjWn/QbRTeDDrbqCnlVS
	 gQfEvPaRsX6ZyIGrVnSSgQxIkJgcyF7Qp6JjTufU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	devi priya <quic_devipriy@quicinc.com>,
	Amandeep Singh <quic_amansing@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 337/375] clk: qcom: ipq9574: Update the alpha PLL type for GPLLs
Date: Tue, 10 Sep 2024 11:32:14 +0200
Message-ID: <20240910092633.902101095@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



