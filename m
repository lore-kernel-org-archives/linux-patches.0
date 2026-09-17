Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3F44ABBB0;
	Thu, 17 Sep 2026 18:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670553; cv=none; b=ql2jlnBOgFGKonzT9t/5Sw8smLDksjJ6y8L3R8QCo5uBqFH2Y9LQvDj1ykrU38eCECX4C4TXcEFrsWhN6EElvj+n2YNQp9BSCGg+XxFEMWvWAQOjmfQ+hA3OQs7wfbwtkmxVKhtgGQjPCyl+xqk+2X9SWI4Boz+dS9C/B9WKKjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670553; c=relaxed/simple;
	bh=LCs5fZ42LMynFvKuY9fSCiOycL8iHXr9hlZGEJxTbCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmyfgE2Z6iA1GSEe3PNRK3RsX/7xYASvAVNqN9SIl5r09oq6g2ZBusdhw7papK/ftG7WypDuCpjfe2tEErKlaVNPf87FRKJ8rR81xMPC1QmpDuU0pQUen3n9VJx6s8oP23PDPvwfTxHm+/TA7RTGeyjvi5Rc6XzWieuaqUZOY30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ng4j1hNp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ng4j1hNp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790C61F000FF;
	Thu, 17 Sep 2026 18:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670552;
	bh=SXGTiNuOdatZjpd5HIJpKuyG+iEfgsWYitXNLUaFjyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ng4j1hNpYTUEXdulSTnVuaABQ/ApbcOsdr4ySv3fRtVqjKr4gaNedflkWhLG1m6tc
	 NoHsafd08tVUTcfSel9+uwoaVWrrLK9tEK27dhU8ZsyVXr8FId7LLjqG1JEwpexK0s
	 uZ+16/BCIwLlFO5119gken1QrFoB0CWV2XtM/UY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0698/1102] net: macb: rename bp->sgmii_phy field to bp->phy
Date: Thu, 17 Sep 2026 16:10:41 +0100
Message-ID: <20260917151557.820161693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Théo Lebrun <theo.lebrun@bootlin.com>

[ Upstream commit 3f7e51cd5fbf4d970b14956ee9464515bb40666f ]

The bp->sgmii_phy field is initialised at probe by init_reset_optional()
if bp->phy_interface == PHY_INTERFACE_MODE_SGMII. It gets used by:
 - zynqmp_config: "cdns,zynqmp-gem" or "xlnx,zynqmp-gem" compatibles.
 - mpfs_config: "microchip,mpfs-macb" compatible.
 - versal_config: "xlnx,versal-gem" compatible.

Make name more generic as EyeQ5 requires the PHY in SGMII & RGMII cases.

Drop "for ZynqMP SGMII mode" comment that is already a lie, as it gets
used on Microchip platforms as well. And soon it won't be SGMII-only.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Théo Lebrun <theo.lebrun@bootlin.com>
Link: https://patch.msgid.link/20251023-macb-eyeq5-v3-4-af509422c204@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 38b6be101006 ("net: macb: fix NULL pointer dereference on unbind with fixed-link")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb.h      |  2 +-
 drivers/net/ethernet/cadence/macb_main.c | 26 ++++++++++++------------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
index 2847278d9cd48..3552cd0a28b2c 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1316,7 +1316,7 @@ struct macb {
 
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
 
-	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
+	struct phy		*phy;
 
 #ifdef MACB_EXT_DESC
 	uint8_t hw_dma_cap;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 67b16aca565ce..23aef4b00e83c 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3107,7 +3107,7 @@ static int macb_open(struct net_device *dev)
 
 	macb_init_hw(bp);
 
-	err = phy_power_on(bp->sgmii_phy);
+	err = phy_power_on(bp->phy);
 	if (err)
 		goto reset_hw;
 
@@ -3123,7 +3123,7 @@ static int macb_open(struct net_device *dev)
 	return 0;
 
 phy_off:
-	phy_power_off(bp->sgmii_phy);
+	phy_power_off(bp->phy);
 
 reset_hw:
 	macb_reset_hw(bp);
@@ -3154,7 +3154,7 @@ static int macb_close(struct net_device *dev)
 	phylink_stop(bp->phylink);
 	phylink_disconnect_phy(bp->phylink);
 
-	phy_power_off(bp->sgmii_phy);
+	phy_power_off(bp->phy);
 
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
@@ -4881,13 +4881,13 @@ static int init_reset_optional(struct platform_device *pdev)
 
 	if (bp->phy_interface == PHY_INTERFACE_MODE_SGMII) {
 		/* Ensure PHY device used in SGMII mode is ready */
-		bp->sgmii_phy = devm_phy_optional_get(&pdev->dev, NULL);
+		bp->phy = devm_phy_optional_get(&pdev->dev, NULL);
 
-		if (IS_ERR(bp->sgmii_phy))
-			return dev_err_probe(&pdev->dev, PTR_ERR(bp->sgmii_phy),
+		if (IS_ERR(bp->phy))
+			return dev_err_probe(&pdev->dev, PTR_ERR(bp->phy),
 					     "failed to get SGMII PHY\n");
 
-		ret = phy_init(bp->sgmii_phy);
+		ret = phy_init(bp->phy);
 		if (ret)
 			return dev_err_probe(&pdev->dev, ret,
 					     "failed to init SGMII PHY\n");
@@ -4916,7 +4916,7 @@ static int init_reset_optional(struct platform_device *pdev)
 	/* Fully reset controller at hardware level if mapped in device tree */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
 	}
 
@@ -4924,7 +4924,7 @@ static int init_reset_optional(struct platform_device *pdev)
 
 err_out_phy_exit:
 	if (ret)
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 
 	return ret;
 }
@@ -5324,7 +5324,7 @@ static int macb_probe(struct platform_device *pdev)
 	mdiobus_free(bp->mii_bus);
 
 err_out_phy_exit:
-	phy_exit(bp->sgmii_phy);
+	phy_exit(bp->phy);
 
 err_out_free_netdev:
 	free_netdev(dev);
@@ -5348,7 +5348,7 @@ static void macb_remove(struct platform_device *pdev)
 	if (dev) {
 		bp = netdev_priv(dev);
 		unregister_netdev(dev);
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
@@ -5375,7 +5375,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	int err;
 
 	if (!device_may_wakeup(&bp->dev->dev))
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 
 	if (!netif_running(netdev))
 		return 0;
@@ -5512,7 +5512,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 	int err;
 
 	if (!device_may_wakeup(&bp->dev->dev))
-		phy_init(bp->sgmii_phy);
+		phy_init(bp->phy);
 
 	if (!netif_running(netdev))
 		return 0;
-- 
2.53.0



