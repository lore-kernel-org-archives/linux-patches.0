Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A2F46D2D2;
	Tue, 21 Jul 2026 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660279; cv=none; b=O57XlHhxl+BTW++Nvy/pS1835P5+Il4ar1aM2yu5exjznxqBLM1YC0cb9Tp+Kb1R12BQf4f0b81keHMF9IOndVR2vB8syCpY45ioE822/CzdThqbo/9s7iH5AjuJZlyYXVqV1oGhgAPrVzjD8nuvQbFQEafiCZC6iC8c+PiE254=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660279; c=relaxed/simple;
	bh=gZyk8jRvQDEbg+X7DpNWkCCgsTdoKR5f2zL4UYlr5BA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gn0PskwE1TYqfPGYoh2puxh4Z7rNdbxC4ZEtLVvdVBnCxbbCI4ca4ocMDmBiPn7Fo6GWyKIv9GZlVf03VyCRePMRa601T0AQLPYPbYCw0DguYzHVTZOIOvyBDN+JCdY3lXjTGHz3ZW7nkWnpHjep9bO4IfXXsvuP3CogU01ZUMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AmvIINHP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AmvIINHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA601F00A3D;
	Tue, 21 Jul 2026 18:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660271;
	bh=hd5KP7DJ9d3bSrZjgrBqn6Bd8XU28T3M+eUg1cj64hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AmvIINHPIKb/VXEDfGAHkgbmzjrqLivWJSpUGb17XGV8F67YciJnZOovKdePkCTm+
	 M0Td3PuU3FicEhqZ6UbfULBqdV5Eij4n5CDscfX2ucCH/BsZL5w7EX8VNZWKxWtMyM
	 bV81RPcCI9cZq2XfmUpbu+Z7LKDPJYNBSQkhLfI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0915/2077] clk: spacemit: k3: Switch to pll2_d6 as parent for PCIe clock
Date: Tue, 21 Jul 2026 17:09:48 +0200
Message-ID: <20260721152614.395586881@linuxfoundation.org>
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

From: Yixun Lan <dlan@kernel.org>

[ Upstream commit d8a4cef90b1a4ae9196a5bfba683eb9a0c75acdc ]

According to SpacemiT updated docs, the PCIe master and slave clock's
parent is the pll2_d6 clock, so fix it.

Fixes: e371a77255b8 ("clk: spacemit: k3: add the clock tree")
Link: https://patch.msgid.link/20260511-06-pci-clk-fix-v2-1-c9a5e563bab3@kernel.org
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/spacemit/ccu-k3.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/spacemit/ccu-k3.c b/drivers/clk/spacemit/ccu-k3.c
index bb8b75bdbdb30d..1a53b14739fed0 100644
--- a/drivers/clk/spacemit/ccu-k3.c
+++ b/drivers/clk/spacemit/ccu-k3.c
@@ -947,16 +947,16 @@ static const struct clk_parent_data edp1_pclk_parents[] = {
 };
 CCU_MUX_GATE_DEFINE(edp1_pxclk, edp1_pclk_parents, APMU_LCD_EDP_CTRL, 18, 1, BIT(17), 0);
 
-CCU_GATE_DEFINE(pciea_mstr_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_A, BIT(2), 0);
-CCU_GATE_DEFINE(pciea_slv_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_A, BIT(1), 0);
-CCU_GATE_DEFINE(pcieb_mstr_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_B, BIT(2), 0);
-CCU_GATE_DEFINE(pcieb_slv_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_B, BIT(1), 0);
-CCU_GATE_DEFINE(pciec_mstr_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_C, BIT(2), 0);
-CCU_GATE_DEFINE(pciec_slv_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_C, BIT(1), 0);
-CCU_GATE_DEFINE(pcied_mstr_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_D, BIT(2), 0);
-CCU_GATE_DEFINE(pcied_slv_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_D, BIT(1), 0);
-CCU_GATE_DEFINE(pciee_mstr_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_E, BIT(2), 0);
-CCU_GATE_DEFINE(pciee_slv_clk, CCU_PARENT_HW(axi_clk), APMU_PCIE_CLK_RES_CTRL_E, BIT(1), 0);
+CCU_GATE_DEFINE(pciea_mstr_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_A, BIT(2), 0);
+CCU_GATE_DEFINE(pciea_slv_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_A, BIT(1), 0);
+CCU_GATE_DEFINE(pcieb_mstr_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_B, BIT(2), 0);
+CCU_GATE_DEFINE(pcieb_slv_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_B, BIT(1), 0);
+CCU_GATE_DEFINE(pciec_mstr_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_C, BIT(2), 0);
+CCU_GATE_DEFINE(pciec_slv_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_C, BIT(1), 0);
+CCU_GATE_DEFINE(pcied_mstr_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_D, BIT(2), 0);
+CCU_GATE_DEFINE(pcied_slv_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_D, BIT(1), 0);
+CCU_GATE_DEFINE(pciee_mstr_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_E, BIT(2), 0);
+CCU_GATE_DEFINE(pciee_slv_clk, CCU_PARENT_HW(pll2_d6), APMU_PCIE_CLK_RES_CTRL_E, BIT(1), 0);
 
 static const struct clk_parent_data emac_1588_parents[] = {
 	CCU_PARENT_NAME(vctcxo_24m),
-- 
2.53.0



