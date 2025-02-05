Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90DF1591E3;
	Wed,  5 Feb 2025 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767242; cv=none; b=SzOfnP4KPiQB3lNyFD7ZcO2kPUi48ndbUVbOLfVP8HSro87mLCilocF4Z5+dJAhbvDCTnV+juy4OpD0RcD1dMz7MJwdOO0SCSVWGRlBEM4ZXV/AGRC3m4kaeeMhJFT7tb0ACuvQo/tNnNfAuPCMGfo3Bjl6s+XCmmSvM67Q5ftA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767242; c=relaxed/simple;
	bh=iQmWYVz0K/r65KQXXqJCrLvHHzIVXMbrOgNeXN3RC40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M5q+DNT+CK5av5NxdcUHhci8kURIggOLG1aydDOH3cXku3HsZYJYhDF0brlM1M8KB1GgeHNin8MgaFhIQGoy2GAGMVmc7aIgpW4WXaPkMgYse2npHR6CsEdWn85eV2iz6lb5pY5HVSkd7OtamEfO3afYURdru5p32vMrkN3KKew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czWzLrM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czWzLrM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036D9C4CED1;
	Wed,  5 Feb 2025 14:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767241;
	bh=iQmWYVz0K/r65KQXXqJCrLvHHzIVXMbrOgNeXN3RC40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czWzLrM7NqRZpdk+iQkKNRaWYiCQlvKQaGv/r56HTt9Fm2vrpTXdgNEXHCKeT6Mmy
	 OThriyEVtcbVocZ0nYwLldNpEN900zQZEFALGFCYvHVw1Ixc3kuqWXyYjtb5Qi6WiM
	 MtUDrIsYJoGVyk1Cu0kCQp/Gh816gIoWiO5m1Auk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 428/590] PCI: imx6: Add missing reference clock disable logic
Date: Wed,  5 Feb 2025 14:43:03 +0100
Message-ID: <20250205134511.639288716@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit 93d883f89063744a92006fc356b1c767eb62d950 ]

Ensure the *_enable_ref_clk() function is symmetric by addressing missing
disable parts on some platforms.

Fixes: d0a75c791f98 ("PCI: imx6: Factor out ref clock disable to match enable")
Link: https://lore.kernel.org/r/20241126075702.4099164-7-hongxing.zhu@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-imx6.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/controller/dwc/pci-imx6.c b/drivers/pci/controller/dwc/pci-imx6.c
index 94f5246b3a720..ad3028b755d16 100644
--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -598,10 +598,9 @@ static int imx_pcie_attach_pd(struct device *dev)
 
 static int imx6sx_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 {
-	if (enable)
-		regmap_clear_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
-				  IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
-
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
+			   IMX6SX_GPR12_PCIE_TEST_POWERDOWN,
+			   enable ? 0 : IMX6SX_GPR12_PCIE_TEST_POWERDOWN);
 	return 0;
 }
 
@@ -630,19 +629,20 @@ static int imx8mm_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 {
 	int offset = imx_pcie_grp_offset(imx_pcie);
 
-	if (enable) {
-		regmap_clear_bits(imx_pcie->iomuxc_gpr, offset, IMX8MQ_GPR_PCIE_CLK_REQ_OVERRIDE);
-		regmap_set_bits(imx_pcie->iomuxc_gpr, offset, IMX8MQ_GPR_PCIE_CLK_REQ_OVERRIDE_EN);
-	}
-
+	regmap_update_bits(imx_pcie->iomuxc_gpr, offset,
+			   IMX8MQ_GPR_PCIE_CLK_REQ_OVERRIDE,
+			   enable ? 0 : IMX8MQ_GPR_PCIE_CLK_REQ_OVERRIDE);
+	regmap_update_bits(imx_pcie->iomuxc_gpr, offset,
+			   IMX8MQ_GPR_PCIE_CLK_REQ_OVERRIDE_EN,
+			   enable ? IMX8MQ_GPR_PCIE_CLK_REQ_OVERRIDE_EN : 0);
 	return 0;
 }
 
 static int imx7d_pcie_enable_ref_clk(struct imx_pcie *imx_pcie, bool enable)
 {
-	if (!enable)
-		regmap_set_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
-				IMX7D_GPR12_PCIE_PHY_REFCLK_SEL);
+	regmap_update_bits(imx_pcie->iomuxc_gpr, IOMUXC_GPR12,
+			   IMX7D_GPR12_PCIE_PHY_REFCLK_SEL,
+			   enable ? 0 : IMX7D_GPR12_PCIE_PHY_REFCLK_SEL);
 	return 0;
 }
 
-- 
2.39.5



