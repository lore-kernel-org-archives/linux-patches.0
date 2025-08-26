Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F43C18DF9D;
	Tue, 26 Aug 2025 11:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208655; cv=none; b=Syv8JA4fjOvrdLhOvmbN50pChVGITXY/t/vUNndUVFmXvbGbcUZ/5H3Y8XxKLW3oLLOs3LRW0iZqdp9BhI1rrAYkJbGA5ck73554X7LorRq81wimWz+ZasRd5V8dAssLyW+p3t9rAT0ZiV+iYPkoq/ghllNBG8D8IsztuJtXAxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208655; c=relaxed/simple;
	bh=sbpPqLWeAG6c5rU9SW0Nn2BI8QD4mcxjz83i5CA/7Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDAz8v/ACuzZFqw8Vrac/ZKdpFALSIbRy2mbEIaBCcaxworw7eQe+xSpCFTI+eWxmLl0zQtKQjqcm4eqMs95rx2S1Ah1h9z0I1yDEr7tqjkmgH067xLOIqCF07x/sOlndikUAWtgb9F9VTfUYi73Y8o7djRpqlMSb8L9fJXbYEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v9q+rc4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v9q+rc4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D4BC4CEF1;
	Tue, 26 Aug 2025 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208655;
	bh=sbpPqLWeAG6c5rU9SW0Nn2BI8QD4mcxjz83i5CA/7Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v9q+rc4IQD8xtLtaoz5CoS7vRgaKIVnaVCqoSFxLARjuUX/zB9WfwpymkE34nPaEV
	 gBOsIZ5taHaaUwJh+c4kczU0SozvvptUJqZyvntyKx6CIdG3dtBsGgylTVbPAfOU/s
	 bc2m2VCw3SG3io8bDeGDomy0dmeBKz5tw+rmBZH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Zhu <hongxing.zhu@nxp.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 194/322] PCI: imx6: Add IMX8MQ_EP third 64-bit BAR in epc_features
Date: Tue, 26 Aug 2025 13:10:09 +0200
Message-ID: <20250826110920.656632596@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Zhu <hongxing.zhu@nxp.com>

[ Upstream commit c523fa63ac1d452abeeb4e699560ec3365037f32 ]

IMX8MQ_EP has three 64-bit BAR0/2/4 capable and programmable BARs. For
IMX8MQ_EP, use imx8q_pcie_epc_features (64-bit BARs 0, 2, 4) instead
of imx8m_pcie_epc_features (64-bit BARs 0, 2).

Fixes: 75c2f26da03f ("PCI: imx6: Add i.MX PCIe EP mode support")
Signed-off-by: Richard Zhu <hongxing.zhu@nxp.com>
[bhelgaas: add details in subject]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250708091003.2582846-2-hongxing.zhu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pci-imx6.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pci-imx6.c
+++ b/drivers/pci/controller/dwc/pci-imx6.c
@@ -1676,7 +1676,7 @@ static const struct imx_pcie_drvdata drv
 		.mode_mask[0] = IMX6Q_GPR12_DEVICE_TYPE,
 		.mode_off[1] = IOMUXC_GPR12,
 		.mode_mask[1] = IMX8MQ_GPR12_PCIE2_CTRL_DEVICE_TYPE,
-		.epc_features = &imx8m_pcie_epc_features,
+		.epc_features = &imx8q_pcie_epc_features,
 		.init_phy = imx8mq_pcie_init_phy,
 		.enable_ref_clk = imx8mm_pcie_enable_ref_clk,
 	},


