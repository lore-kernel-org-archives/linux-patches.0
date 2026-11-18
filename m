Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055135;
	b=vPzJjonyDYJxQlPTeJLXZc+B8dmq/2XZphdO+5+xNlORj4zP18JxiJy9T+mSNyz+gQc9
	 nq4CdcCV7qY+1lRJPEOZPdzKWd8DFAgrJwbWTMNRTUMr19bywf5kyt700tB2uNOFqwvAK
	 HfRSclfN3xkrB6p02PC0ox0M2cYlXX/261Jp1rM9fJQYsNlNf8PoA1dn/Sv8qJ4WPJdv6
	 c961FenAOlWKAoJGOxnc38wPGGAxh3VUCuaoYL4SWPlzP7bjxESee6i7cIbZMGNxXibrx
	 UnlceRFfywar5yKJwJnCEB+fxabzTKDbgJSL+HieksXyts/th74qOh0aC49bMOD88cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055135;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LOGk/ymLADFdXtIHJUM+ErReTdGBe6sQtXb327RQvqQ=;
	b=n4G9CWpfbQptvLfR6tJB9664LmHM6lWy768P2CDfM5gVInbNLiM/3gEULaRTdCCZAv6t
	 /udqmiR08xcthADtpZrca6UeSoByQUIp4TgvrNRv7PdkRM3cXSpZrFdoRX5M/F0c4qV0b
	 mZAaDgURNailOXL65qrdpbs4vMmplVh2MPlbqpesYIyK+d/kZ0Ja3RVBMiQRLYgIaRm+z
	 SPu2VDUcJOu3AGxtTRvclr7khFInq0PCM46AmfRuWx29eqFpbnjkbEmKpcu7Db10lL5pJ
	 /sC+UgwU4ESCsAv3d/VZ0d5XnFwGo5m2qjE7m/aC/k/7eIuLfBEQ2NxT8l+ppGYdfgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7sE0eIB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAB2606A31C;
	Thu, 19 Nov 2026 02:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7sE0eIB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D646F1F000C4;
	Thu, 19 Nov 2026 02:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055135;
	bh=LOGk/ymLADFdXtIHJUM+ErReTdGBe6sQtXb327RQvqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7sE0eIB2aIDYCjVBBiC/yzjqh/F/u8L2Uu9qopjpLmD1/gSw2idfjoU7Twu1E0yu
	 XAW8AdJpDaD1Xypety7knWe2uaGFAHANmuu+ploBxc/f9iif7Mxcm71iDvl7lsJ4Mc
	 IYq2Jc+Fxn7sbBpQcPAEJiILRuMD3EaTeGNbDtbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1524/2214] ata: sata_dwc_460ex: Use temporary variable for struct device
Date: Wed, 18 Nov 2026 15:53:20 +0100
Message-ID: <20261118150113.116468966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f1550f27f8a92a4d29329aeeb28b743365abceae ]

Use temporary variable for struct device to make code neater.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Stable-dep-of: e137035fcd66 ("ata: sata_dwc_460ex: Don't enable interrupt if libATA core registration fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_dwc_460ex.c | 37 ++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 7b0b320e4e825..41a37a3dddb9e 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -219,9 +219,10 @@ static int sata_dwc_dma_get_channel_old(struct sata_dwc_device_port *hsdevp)
 {
 	struct sata_dwc_device *hsdev = hsdevp->hsdev;
 	struct dw_dma_slave *dws = &sata_dwc_dma_dws;
+	struct device *dev = hsdev->dev;
 	dma_cap_mask_t mask;
 
-	dws->dma_dev = hsdev->dev;
+	dws->dma_dev = dev;
 
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
@@ -229,8 +230,7 @@ static int sata_dwc_dma_get_channel_old(struct sata_dwc_device_port *hsdevp)
 	/* Acquire DMA channel */
 	hsdevp->chan = dma_request_channel(mask, sata_dwc_dma_filter, hsdevp);
 	if (!hsdevp->chan) {
-		dev_err(hsdev->dev, "%s: dma channel unavailable\n",
-			 __func__);
+		dev_err(dev, "%s: dma channel unavailable\n", __func__);
 		return -EAGAIN;
 	}
 
@@ -240,19 +240,20 @@ static int sata_dwc_dma_get_channel_old(struct sata_dwc_device_port *hsdevp)
 static int sata_dwc_dma_init_old(struct platform_device *pdev,
 				 struct sata_dwc_device *hsdev)
 {
-	struct device_node *np = pdev->dev.of_node;
+	struct device *dev = &pdev->dev;
+	struct device_node *np = dev->of_node;
 
-	hsdev->dma = devm_kzalloc(&pdev->dev, sizeof(*hsdev->dma), GFP_KERNEL);
+	hsdev->dma = devm_kzalloc(dev, sizeof(*hsdev->dma), GFP_KERNEL);
 	if (!hsdev->dma)
 		return -ENOMEM;
 
-	hsdev->dma->dev = &pdev->dev;
+	hsdev->dma->dev = dev;
 	hsdev->dma->id = pdev->id;
 
 	/* Get SATA DMA interrupt number */
 	hsdev->dma->irq = irq_of_parse_and_map(np, 1);
 	if (hsdev->dma->irq == NO_IRQ) {
-		dev_err(&pdev->dev, "no SATA DMA irq\n");
+		dev_err(dev, "no SATA DMA irq\n");
 		return -ENODEV;
 	}
 
@@ -1201,6 +1202,8 @@ static const struct ata_port_info sata_dwc_port_info[] = {
 
 static int sata_dwc_probe(struct platform_device *ofdev)
 {
+	struct device *dev = &ofdev->dev;
+	struct device_node *np = dev->of_node;
 	struct sata_dwc_device *hsdev;
 	u32 idr, versionr;
 	char *ver = (char *)&versionr;
@@ -1210,12 +1213,11 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	struct ata_host *host;
 	struct ata_port_info pi = sata_dwc_port_info[0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
-	struct device_node *np = ofdev->dev.of_node;
 	struct resource *res;
 
 	/* Allocate DWC SATA device */
-	host = ata_host_alloc_pinfo(&ofdev->dev, ppi, SATA_DWC_MAX_PORTS);
-	hsdev = devm_kzalloc(&ofdev->dev, sizeof(*hsdev), GFP_KERNEL);
+	host = ata_host_alloc_pinfo(dev, ppi, SATA_DWC_MAX_PORTS);
+	hsdev = devm_kzalloc(dev, sizeof(*hsdev), GFP_KERNEL);
 	if (!host || !hsdev)
 		return -ENOMEM;
 
@@ -1225,7 +1227,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	base = devm_platform_get_and_ioremap_resource(ofdev, 0, &res);
 	if (IS_ERR(base))
 		return PTR_ERR(base);
-	dev_dbg(&ofdev->dev, "ioremap done for SATA register address\n");
+	dev_dbg(dev, "ioremap done for SATA register address\n");
 
 	/* Synopsys DWC SATA specific Registers */
 	hsdev->sata_dwc_regs = base + SATA_DWC_REG_OFFSET;
@@ -1239,16 +1241,15 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	/* Read the ID and Version Registers */
 	idr = sata_dwc_readl(&hsdev->sata_dwc_regs->idr);
 	versionr = sata_dwc_readl(&hsdev->sata_dwc_regs->versionr);
-	dev_notice(&ofdev->dev, "id %d, controller version %c.%c%c\n",
-		   idr, ver[0], ver[1], ver[2]);
+	dev_notice(dev, "id %d, controller version %c.%c%c\n", idr, ver[0], ver[1], ver[2]);
 
 	/* Save dev for later use in dev_xxx() routines */
-	hsdev->dev = &ofdev->dev;
+	hsdev->dev = dev;
 
 	/* Get SATA interrupt number */
 	irq = irq_of_parse_and_map(np, 0);
 	if (irq == NO_IRQ) {
-		dev_err(&ofdev->dev, "no SATA DMA irq\n");
+		dev_err(dev, "no SATA DMA irq\n");
 		return -ENODEV;
 	}
 
@@ -1260,7 +1261,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	}
 #endif
 
-	hsdev->phy = devm_phy_optional_get(hsdev->dev, "sata-phy");
+	hsdev->phy = devm_phy_optional_get(dev, "sata-phy");
 	if (IS_ERR(hsdev->phy))
 		return PTR_ERR(hsdev->phy);
 
@@ -1275,7 +1276,7 @@ static int sata_dwc_probe(struct platform_device *ofdev)
 	 */
 	err = ata_host_activate(host, irq, sata_dwc_isr, 0, &sata_dwc_sht);
 	if (err)
-		dev_err(&ofdev->dev, "failed to activate host");
+		dev_err(dev, "failed to activate host");
 
 	/* Enable SATA Interrupts */
 	sata_dwc_enable_interrupts(hsdev);
@@ -1301,7 +1302,7 @@ static int sata_dwc_remove(struct platform_device *ofdev)
 	sata_dwc_dma_exit_old(hsdev);
 #endif
 
-	dev_dbg(&ofdev->dev, "done\n");
+	dev_dbg(dev, "done\n");
 	return 0;
 }
 
-- 
2.53.0



