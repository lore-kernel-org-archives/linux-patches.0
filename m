Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1E5415F15;
	Tue, 21 Jul 2026 19:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663330; cv=none; b=Bf5r6rGrzQ7HwjYwdnpFwTDHLlHGvSdKuLgPi1aKqrOT5heX8q2guyMk7GQIPmBFwZySbzov6yc7ELOxTkwXxDYxcXNUY8JlxQVbC+z3rdZ82DMvCuvj0B/2oxJ7WqYntMAuuPJ8rOWpemwTNkteOuF19OUgEM3tlhMlnqanyNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663330; c=relaxed/simple;
	bh=dhXHm5CMdOoqhElCdHfN2dclCExNKJjUmPLcDniOQH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbGaEQUlq0Zq/puUwnFpAy7nKwl/L1vKuxqasgsDvu2eAcnqZLx6mjXGeAvlGJ/asOQwV7XnjGAwSuHYPbP8NY3aVQjpY2SPkbjIxNfNA9FLbwFWVxIp7KdMAfoolfrcEwpQIs2iN+nP567HQh3TPl1jAP/Vrbhcl2jX3qcGqOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XshYBiKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XshYBiKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E596A1F000E9;
	Tue, 21 Jul 2026 19:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663329;
	bh=2K8tGfNuB86zqooWbRbRePt55FI86yLzIHncr3BuHlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XshYBiKYkq4h8biL9kalgFiIY3+sSj/cvg6V0PFYLsdH/nmBA0B8SQEebykKdS/Bn
	 NTvaYH9d6H0243WDmIvmuwhmJGILKBs6yUdbn1Cf/vCjuk6zgtE3D80UCBmOu5uf1A
	 OOR05QNhuTaKPuPKZl3H6i917IXJxNZL9MKHjo54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0780/1276] net: usb: lan78xx: move functions to avoid forward definitions
Date: Tue, 21 Jul 2026 17:20:23 +0200
Message-ID: <20260721152503.531147441@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 39aa1d620d10cdd276f4728da50f136dbe939643 ]

Move following functions to avoid forward declarations in the code:
- lan78xx_start_hw()
- lan78xx_stop_hw()
- lan78xx_flush_fifo()
- lan78xx_start_tx_path()
- lan78xx_stop_tx_path()
- lan78xx_flush_tx_fifo()
- lan78xx_start_rx_path()
- lan78xx_stop_rx_path()
- lan78xx_flush_rx_fifo()

These functions will be used in an upcoming PHYlink migration patch.

No modifications to the functionality of the code are made.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241204084142.1152696-4-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 60444706aa17 ("net: usb: lan78xx: disable VLAN filter in promiscuous mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 300 +++++++++++++++++++-------------------
 1 file changed, 150 insertions(+), 150 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 8647980df0059b..66907819b1d14b 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -812,6 +812,156 @@ static void lan78xx_update_stats(struct lan78xx_net *dev)
 	usb_autopm_put_interface(dev->intf);
 }
 
+static int lan78xx_start_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enable)
+{
+	return lan78xx_update_reg(dev, reg, hw_enable, hw_enable);
+}
+
+static int lan78xx_stop_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enabled,
+			   u32 hw_disabled)
+{
+	unsigned long timeout;
+	bool stopped = true;
+	int ret;
+	u32 buf;
+
+	/* Stop the h/w block (if not already stopped) */
+
+	ret = lan78xx_read_reg(dev, reg, &buf);
+	if (ret < 0)
+		return ret;
+
+	if (buf & hw_enabled) {
+		buf &= ~hw_enabled;
+
+		ret = lan78xx_write_reg(dev, reg, buf);
+		if (ret < 0)
+			return ret;
+
+		stopped = false;
+		timeout = jiffies + HW_DISABLE_TIMEOUT;
+		do  {
+			ret = lan78xx_read_reg(dev, reg, &buf);
+			if (ret < 0)
+				return ret;
+
+			if (buf & hw_disabled)
+				stopped = true;
+			else
+				msleep(HW_DISABLE_DELAY_MS);
+		} while (!stopped && !time_after(jiffies, timeout));
+	}
+
+	ret = stopped ? 0 : -ETIME;
+
+	return ret;
+}
+
+static int lan78xx_flush_fifo(struct lan78xx_net *dev, u32 reg, u32 fifo_flush)
+{
+	return lan78xx_update_reg(dev, reg, fifo_flush, fifo_flush);
+}
+
+static int lan78xx_start_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "start tx path");
+
+	/* Start the MAC transmitter */
+
+	ret = lan78xx_start_hw(dev, MAC_TX, MAC_TX_TXEN_);
+	if (ret < 0)
+		return ret;
+
+	/* Start the Tx FIFO */
+
+	ret = lan78xx_start_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int lan78xx_stop_tx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "stop tx path");
+
+	/* Stop the Tx FIFO */
+
+	ret = lan78xx_stop_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_, FCT_TX_CTL_DIS_);
+	if (ret < 0)
+		return ret;
+
+	/* Stop the MAC transmitter */
+
+	ret = lan78xx_stop_hw(dev, MAC_TX, MAC_TX_TXEN_, MAC_TX_TXD_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* The caller must ensure the Tx path is stopped before calling
+ * lan78xx_flush_tx_fifo().
+ */
+static int lan78xx_flush_tx_fifo(struct lan78xx_net *dev)
+{
+	return lan78xx_flush_fifo(dev, FCT_TX_CTL, FCT_TX_CTL_RST_);
+}
+
+static int lan78xx_start_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "start rx path");
+
+	/* Start the Rx FIFO */
+
+	ret = lan78xx_start_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_);
+	if (ret < 0)
+		return ret;
+
+	/* Start the MAC receiver*/
+
+	ret = lan78xx_start_hw(dev, MAC_RX, MAC_RX_RXEN_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int lan78xx_stop_rx_path(struct lan78xx_net *dev)
+{
+	int ret;
+
+	netif_dbg(dev, drv, dev->net, "stop rx path");
+
+	/* Stop the MAC receiver */
+
+	ret = lan78xx_stop_hw(dev, MAC_RX, MAC_RX_RXEN_, MAC_RX_RXD_);
+	if (ret < 0)
+		return ret;
+
+	/* Stop the Rx FIFO */
+
+	ret = lan78xx_stop_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_, FCT_RX_CTL_DIS_);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+/* The caller must ensure the Rx path is stopped before calling
+ * lan78xx_flush_rx_fifo().
+ */
+static int lan78xx_flush_rx_fifo(struct lan78xx_net *dev)
+{
+	return lan78xx_flush_fifo(dev, FCT_RX_CTL, FCT_RX_CTL_RST_);
+}
+
 /* Loop until the read is completed with timeout called with phy_mutex held */
 static int lan78xx_phy_wait_not_busy(struct lan78xx_net *dev)
 {
@@ -2742,156 +2892,6 @@ static int lan78xx_urb_config_init(struct lan78xx_net *dev)
 	return result;
 }
 
-static int lan78xx_start_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enable)
-{
-	return lan78xx_update_reg(dev, reg, hw_enable, hw_enable);
-}
-
-static int lan78xx_stop_hw(struct lan78xx_net *dev, u32 reg, u32 hw_enabled,
-			   u32 hw_disabled)
-{
-	unsigned long timeout;
-	bool stopped = true;
-	int ret;
-	u32 buf;
-
-	/* Stop the h/w block (if not already stopped) */
-
-	ret = lan78xx_read_reg(dev, reg, &buf);
-	if (ret < 0)
-		return ret;
-
-	if (buf & hw_enabled) {
-		buf &= ~hw_enabled;
-
-		ret = lan78xx_write_reg(dev, reg, buf);
-		if (ret < 0)
-			return ret;
-
-		stopped = false;
-		timeout = jiffies + HW_DISABLE_TIMEOUT;
-		do  {
-			ret = lan78xx_read_reg(dev, reg, &buf);
-			if (ret < 0)
-				return ret;
-
-			if (buf & hw_disabled)
-				stopped = true;
-			else
-				msleep(HW_DISABLE_DELAY_MS);
-		} while (!stopped && !time_after(jiffies, timeout));
-	}
-
-	ret = stopped ? 0 : -ETIME;
-
-	return ret;
-}
-
-static int lan78xx_flush_fifo(struct lan78xx_net *dev, u32 reg, u32 fifo_flush)
-{
-	return lan78xx_update_reg(dev, reg, fifo_flush, fifo_flush);
-}
-
-static int lan78xx_start_tx_path(struct lan78xx_net *dev)
-{
-	int ret;
-
-	netif_dbg(dev, drv, dev->net, "start tx path");
-
-	/* Start the MAC transmitter */
-
-	ret = lan78xx_start_hw(dev, MAC_TX, MAC_TX_TXEN_);
-	if (ret < 0)
-		return ret;
-
-	/* Start the Tx FIFO */
-
-	ret = lan78xx_start_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static int lan78xx_stop_tx_path(struct lan78xx_net *dev)
-{
-	int ret;
-
-	netif_dbg(dev, drv, dev->net, "stop tx path");
-
-	/* Stop the Tx FIFO */
-
-	ret = lan78xx_stop_hw(dev, FCT_TX_CTL, FCT_TX_CTL_EN_, FCT_TX_CTL_DIS_);
-	if (ret < 0)
-		return ret;
-
-	/* Stop the MAC transmitter */
-
-	ret = lan78xx_stop_hw(dev, MAC_TX, MAC_TX_TXEN_, MAC_TX_TXD_);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-/* The caller must ensure the Tx path is stopped before calling
- * lan78xx_flush_tx_fifo().
- */
-static int lan78xx_flush_tx_fifo(struct lan78xx_net *dev)
-{
-	return lan78xx_flush_fifo(dev, FCT_TX_CTL, FCT_TX_CTL_RST_);
-}
-
-static int lan78xx_start_rx_path(struct lan78xx_net *dev)
-{
-	int ret;
-
-	netif_dbg(dev, drv, dev->net, "start rx path");
-
-	/* Start the Rx FIFO */
-
-	ret = lan78xx_start_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_);
-	if (ret < 0)
-		return ret;
-
-	/* Start the MAC receiver*/
-
-	ret = lan78xx_start_hw(dev, MAC_RX, MAC_RX_RXEN_);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-static int lan78xx_stop_rx_path(struct lan78xx_net *dev)
-{
-	int ret;
-
-	netif_dbg(dev, drv, dev->net, "stop rx path");
-
-	/* Stop the MAC receiver */
-
-	ret = lan78xx_stop_hw(dev, MAC_RX, MAC_RX_RXEN_, MAC_RX_RXD_);
-	if (ret < 0)
-		return ret;
-
-	/* Stop the Rx FIFO */
-
-	ret = lan78xx_stop_hw(dev, FCT_RX_CTL, FCT_RX_CTL_EN_, FCT_RX_CTL_DIS_);
-	if (ret < 0)
-		return ret;
-
-	return 0;
-}
-
-/* The caller must ensure the Rx path is stopped before calling
- * lan78xx_flush_rx_fifo().
- */
-static int lan78xx_flush_rx_fifo(struct lan78xx_net *dev)
-{
-	return lan78xx_flush_fifo(dev, FCT_RX_CTL, FCT_RX_CTL_RST_);
-}
-
 static int lan78xx_reset(struct lan78xx_net *dev)
 {
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
-- 
2.53.0



