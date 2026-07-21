Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D3B43CEC8;
	Tue, 21 Jul 2026 20:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666935; cv=none; b=GlP6zAFvYwzPEU3pBzVcDlQGQgweR89N23Xjn5nkJSZwx9SHsXIwCMaJNr7G3OO8OtI8GSZuXRJtsUQQsHbes+JPkV086wvebdi+mQaqc7UsBraGe7Q0PSzBcD7XBR+LxFRNNnICvefSYXNvhRE2PcqbQPTLyF6VAONUz8bhKFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666935; c=relaxed/simple;
	bh=dmBDhAgWWtBWVA/0CMUSA4i4ElAFEHsIlz6VsHPTjXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWPZJWKriKIptIthp1qrYDiTddGxZ2ju5GcwPgo7xuz3vrlfACZFu/3Wdc4jNb36Ca08KWxtb0/vCdaaJ/sQTyGRmXN32TkE8ThcqAoKteU5yOsHRl2V2rYf3SUf0brUXfNpbHwgj/i5ZKWr/XU4fWUAkeKtkNYjHjn87UBYSZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8hFXiOq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8hFXiOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FCC11F000E9;
	Tue, 21 Jul 2026 20:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666932;
	bh=9IL8YnCx/OfEQ3O7wj60WvD4W27+goJb2a3Jg0Up3oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8hFXiOqecKGLfzEYeKOHMPp5wZIx/riZR0mVZJGJHUFZ+GQabbEHD74W2AcAuitF
	 AaN63+DHBEc8FQJjsgtqQtCQBx/ixpfAhWY5fw8p3+o8HuD6Y2VCQ/kLbdSdBkwpVo
	 By+n/UaaK6Elv3nuYQBbvQ8ahW7sN3xuUbC62ZXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0868/1266] net: usb: lan78xx: move functions to avoid forward definitions
Date: Tue, 21 Jul 2026 17:21:45 +0200
Message-ID: <20260721152501.270870994@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f5bcf150fd9ed3..36a7ece093ae23 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -817,6 +817,156 @@ static void lan78xx_update_stats(struct lan78xx_net *dev)
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
@@ -2747,156 +2897,6 @@ static int lan78xx_urb_config_init(struct lan78xx_net *dev)
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



