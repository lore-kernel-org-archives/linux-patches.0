Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DCC92798ED;
	Tue, 26 Aug 2025 11:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208653; cv=none; b=scULxTTKB3OG50anv9Gu1OI5RNI/GAdVrlpIu4dOMPOoDDhXOAIizySSmtL+mz4nuDeFrI98Uynqn20Ke9fUrdf2IiJszubIKddJ6n4Lqqk7qV30oUc2AA8LnK3XgOA5qSaAlXYpg/hB2JzeF2b51sviCiD3lxKJONsNvNkI6ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208653; c=relaxed/simple;
	bh=Xv8C1+LDqp1sqTFtlCrNnRhVoywj2DvnkkhGdgaaJPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBjJKuyCWNWWzTRnIPtnFZU54HcsF6QpcwuwyI6dgnLqYZA+INT73MlDUvUKML/xq1fuN50aEfEboul7nbw6np6/4aFLHoSybH2SpLR14ZpfJiBzuwB28AKPUhnPEnN9fFJeVeg7KDW4zD/P3una/Vk1R8g2W+b0stZU8ortE/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kJ53KUG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kJ53KUG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C973EC4CEF1;
	Tue, 26 Aug 2025 11:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208653;
	bh=Xv8C1+LDqp1sqTFtlCrNnRhVoywj2DvnkkhGdgaaJPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kJ53KUG0//kGfj/joFFjY1W8KVprrm0ozkcTGfDcltwwTojp2XrOYb8RT5M2n3RC1
	 OtIkiiJEhrFEk9h2S1t8K7qqhJs4niihGwS7l8ZOfirsXrn7vfm7hfrXZPyX5ZCvbB
	 +4//Di0r9WxAVvzAe3Y94Fb6ivNMEPOAj0la1Z1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/322] PCI: imx6: Add i.MX8Q PCIe Endpoint (EP) support
Date: Tue, 26 Aug 2025 13:10:08 +0200
Message-ID: <20250826110920.630944423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 687aedb73a401addf151c5f60e481e574b4c9ad9 ]

Add support for the i.MX8Q series (i.MX8QM, i.MX8QXP, and i.MX8DXL) PCIe
Endpoint (EP). On the i.MX8Q platforms, the PCI bus addresses differ
from the CPU addresses. However, the DesignWare (DWC) driver already
handles this in the common code.

Link: https://lore.kernel.org/r/20241119-pci_fixup_addr-v8-7-c4bfa5193288@nxp.com
Signed-off-by: Frank Li <Frank.Li@nxp.com>
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Richard Zhu <hongxing.zhu@nxp.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Stable-dep-of: c523fa63ac1d ("PCI: imx6: Add IMX8MQ_EP third 64-bit BAR in epc_features")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -72,6 +72,7 @@ enum imx_pcie_variants {
 	IMX8MQ_EP,
 	IMX8MM_EP,
 	IMX8MP_EP,
+	IMX8Q_EP,
 	IMX95_EP,
 };
 
@@ -1103,6 +1104,16 @@ static const struct pci_epc_features imx
 	.align = SZ_64K,
 };
 
+static const struct pci_epc_features imx8q_pcie_epc_features = {
+	.linkup_notifier = false,
+	.msi_capable = true,
+	.msix_capable = false,
+	.bar[BAR_1] = { .type = BAR_RESERVED, },
+	.bar[BAR_3] = { .type = BAR_RESERVED, },
+	.bar[BAR_5] = { .type = BAR_RESERVED, },
+	.align = SZ_64K,
+};
+
 /*
  * BAR#	| Default BAR enable	| Default BAR Type	| Default BAR Size	| BAR Sizing Scheme
  * ================================================================================================
@@ -1695,6 +1706,14 @@ static const struct imx_pcie_drvdata drv
 		.epc_features = &imx8m_pcie_epc_features,
 		.enable_ref_clk = imx8mm_pcie_enable_ref_clk,
 	},
+	[IMX8Q_EP] = {
+		.variant = IMX8Q_EP,
+		.flags = IMX_PCIE_FLAG_HAS_PHYDRV,
+		.mode = DW_PCIE_EP_TYPE,
+		.epc_features = &imx8q_pcie_epc_features,
+		.clk_names = imx8q_clks,
+		.clks_cnt = ARRAY_SIZE(imx8q_clks),
+	},
 	[IMX95_EP] = {
 		.variant = IMX95_EP,
 		.flags = IMX_PCIE_FLAG_HAS_SERDES |
@@ -1724,6 +1743,7 @@ static const struct of_device_id imx_pci
 	{ .compatible = "fsl,imx8mq-pcie-ep", .data = &drvdata[IMX8MQ_EP], },
 	{ .compatible = "fsl,imx8mm-pcie-ep", .data = &drvdata[IMX8MM_EP], },
 	{ .compatible = "fsl,imx8mp-pcie-ep", .data = &drvdata[IMX8MP_EP], },
+	{ .compatible = "fsl,imx8q-pcie-ep", .data = &drvdata[IMX8Q_EP], },
 	{ .compatible = "fsl,imx95-pcie-ep", .data = &drvdata[IMX95_EP], },
 	{},
 };


