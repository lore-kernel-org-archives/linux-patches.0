Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C49513567;
	Wed, 30 Sep 2026 16:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785229; cv=none; b=U9zUcQYHnfdLVmPP82F356DrKtRsbIcNEiJ8vLJwk7h8z0vl6VJnVBO+aQJbYflv/3sdqQXEiEhxYNhaIM+c7E2N8POpGvvYSiwxCsUa0Wfyh9sBCI5Wgpfz+lsRKdeMEu7nRs271oht1M/JikYOeDDUxUpAyvv6cAzsy1x/iYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785229; c=relaxed/simple;
	bh=Tm7IxzkDOJrxk/M2817OSUwRqZZPfjqjc5N+LjtxmZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=reTjobTd4Z4iacMdCkntiA/zQbuYOhIdOP8ph+ZFUQEQ/W/5n9Q33hW0rc+JKiuuQocmGqhqg15K6GdvvY/je9CT1kO/r1XsDoUBHM2PnevksyK9S/6biCPzXYlxoYLbqWhxeIKow3PVjaO+jbP21sF+SWX0ipDN+aLaX25hV7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ToQ9w6q3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ToQ9w6q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E311F000FF;
	Wed, 30 Sep 2026 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785220;
	bh=SMm5ndJYUkkwBApvwaryIgsUhKBiP+7rk8Cks/+aElQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToQ9w6q3Mlwzf/39q0iE0Xy7/0LrupK3jMGXJ3pt25S7N084EQH51+67DJpBc5Sds
	 zm6BQ3qIja7KSzDRsXlfvBUQkjorC3SFuFt7O75Ao0HXV/ZoJu5mN6P/bc0b+nXVBU
	 7Jc8w/TnzbRDXfAXpk2KcX9NCD6hEWKneE+50v1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	=?UTF-8?q?Th=C3=A9o=20Lebrun?= <theo.lebrun@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 431/982] net: macb: rename bp->sgmii_phy field to bp->phy
Date: Wed, 30 Sep 2026 17:19:27 +0200
Message-ID: <20260930152426.055153089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0d3c6eb72163f..9d825e3b4d945 100644
--- a/drivers/net/ethernet/cadence/macb.h
+++ b/drivers/net/ethernet/cadence/macb.h
@@ -1311,7 +1311,7 @@ struct macb {
 
 	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
 
-	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
+	struct phy		*phy;
 
 #ifdef MACB_EXT_DESC
 	uint8_t hw_dma_cap;
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 513a1267a6ef7..e33ff04797f7d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3034,7 +3034,7 @@ static int macb_open(struct net_device *dev)
 
 	macb_init_hw(bp);
 
-	err = phy_power_on(bp->sgmii_phy);
+	err = phy_power_on(bp->phy);
 	if (err)
 		goto reset_hw;
 
@@ -3050,7 +3050,7 @@ static int macb_open(struct net_device *dev)
 	return 0;
 
 phy_off:
-	phy_power_off(bp->sgmii_phy);
+	phy_power_off(bp->phy);
 
 reset_hw:
 	macb_reset_hw(bp);
@@ -3081,7 +3081,7 @@ static int macb_close(struct net_device *dev)
 	phylink_stop(bp->phylink);
 	phylink_disconnect_phy(bp->phylink);
 
-	phy_power_off(bp->sgmii_phy);
+	phy_power_off(bp->phy);
 
 	spin_lock_irqsave(&bp->lock, flags);
 	macb_reset_hw(bp);
@@ -4780,13 +4780,13 @@ static int init_reset_optional(struct platform_device *pdev)
 
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
@@ -4815,7 +4815,7 @@ static int init_reset_optional(struct platform_device *pdev)
 	/* Fully reset controller at hardware level if mapped in device tree */
 	ret = device_reset_optional(&pdev->dev);
 	if (ret) {
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 		return dev_err_probe(&pdev->dev, ret, "failed to reset controller");
 	}
 
@@ -4823,7 +4823,7 @@ static int init_reset_optional(struct platform_device *pdev)
 
 err_out_phy_exit:
 	if (ret)
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 
 	return ret;
 }
@@ -5195,7 +5195,7 @@ static int macb_probe(struct platform_device *pdev)
 	mdiobus_free(bp->mii_bus);
 
 err_out_phy_exit:
-	phy_exit(bp->sgmii_phy);
+	phy_exit(bp->phy);
 
 err_out_free_netdev:
 	free_netdev(dev);
@@ -5219,7 +5219,7 @@ static int macb_remove(struct platform_device *pdev)
 	if (dev) {
 		bp = netdev_priv(dev);
 		unregister_netdev(dev);
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 		mdiobus_unregister(bp->mii_bus);
 		mdiobus_free(bp->mii_bus);
 
@@ -5249,7 +5249,7 @@ static int __maybe_unused macb_suspend(struct device *dev)
 	u32 tmp;
 
 	if (!device_may_wakeup(&bp->dev->dev))
-		phy_exit(bp->sgmii_phy);
+		phy_exit(bp->phy);
 
 	if (!netif_running(netdev))
 		return 0;
@@ -5365,7 +5365,7 @@ static int __maybe_unused macb_resume(struct device *dev)
 	int err;
 
 	if (!device_may_wakeup(&bp->dev->dev))
-		phy_init(bp->sgmii_phy);
+		phy_init(bp->phy);
 
 	if (!netif_running(netdev))
 		return 0;
-- 
2.53.0



