Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2052D226D1E;
	Mon,  2 Jun 2025 14:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875159; cv=none; b=Rw3LUg5xeHY1IvLHS2w5ZbL/auLYiLAOdlD4YrY5kFLd64ruUWJrz1yHiYXP2WrmdlSHBcL5TR6PMwWRwubOKnkM8W+0TioSDiSuz1zvsFFgWbAvu+Alzzh+ZUkzBntuYIsSM/BdKyHm6faj9ANvWKpFM17/z4x4/aJKuKRwXT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875159; c=relaxed/simple;
	bh=4y+f1DWjQzKYPdJGyenWFo50HUNijjrDvl1PvFoWI6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HX1mEQCTMbu2lj4Oo/9RkZ9kDOFAfzieQBHPZ/qk6CA55TcykuKV1A+P5D6fSQpbHctgjD24f7eCS8o18npgcufmdBuzCL9YHIx+ze1cHjF+FaE+imjZXJnY9ITVDSZaU17fqXilbk0PQcN6+TUNuSBknSzv+L1mhNldsSkHjCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QT60LR0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QT60LR0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D637C4CEEB;
	Mon,  2 Jun 2025 14:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875159;
	bh=4y+f1DWjQzKYPdJGyenWFo50HUNijjrDvl1PvFoWI6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QT60LR0H7AdLVX6YoDAx706rD0k1k7BTy3dIOtJME3tswoPA6RVehmOrjDl/UqK+r
	 Xov5I319HTNF3Lfle5Jk+7dSm4aHjF8pulnq87VwcWxo/35FDBGr6fzlCmrkDjjspm
	 RHORqgBZHIaUQBvSnPZ5RnaEgWg3Yw0olMA8fPkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Ryan Matthews <ryanmatthews@fastmail.com>
Subject: [PATCH 5.10 029/270] PCI: imx6: Skip controller_id generation logic for i.MX7D
Date: Mon,  2 Jun 2025 15:45:14 +0200
Message-ID: <20250602134308.391161562@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

commit f068ffdd034c93f0c768acdc87d4d2d7023c1379 upstream.

The i.MX7D only has one PCIe controller, so controller_id should always be
0. The previous code is incorrect although yielding the correct result.

Fix by removing "IMX7D" from the switch case branch.

Fixes: 2d8ed461dbc9 ("PCI: imx6: Add support for i.MX8MQ")
Link: https://lore.kernel.org/r/20241126075702.4099164-5-hongxing.zhu@nxp.com
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
[Because this switch case does more than just controller_id
 logic, move the "IMX7D" case label instead of removing it entirely.]
Signed-off-by: Ryan Matthews <ryanmatthews@fastmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1092,11 +1092,10 @@ static int imx6_pcie_probe(struct platfo
 		if (IS_ERR(imx6_pcie->pcie_aux))
 			return dev_err_probe(dev, PTR_ERR(imx6_pcie->pcie_aux),
 					     "pcie_aux clock source missing or invalid\n");
-		fallthrough;
-	case IMX7D:
 		if (dbi_base->start == IMX8MQ_PCIE2_BASE_ADDR)
 			imx6_pcie->controller_id = 1;
-
+		fallthrough;
+	case IMX7D:
 		imx6_pcie->pciephy_reset = devm_reset_control_get_exclusive(dev,
 									    "pciephy");
 		if (IS_ERR(imx6_pcie->pciephy_reset)) {


