Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8793B3BF2;
	Wed, 30 Sep 2026 19:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795466; cv=none; b=uzuh+aeefNOIfFE0SsBg5lnI9zCwemQ18tmpskjCf+8vmlPrNEa7YfmaZ2sOKVbYV1/XWr4sueD+dNlC7/JEGulGBFigvx8otcFfkFAL2YRdKQuXavKf49r3TUzpotCTLFJOej1g6tRELMYGneuafuSyAjT6z4zeZruwVM9AqN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795466; c=relaxed/simple;
	bh=yEivTVrMai+z+aD6I8h+iRTfrXHz+F91ZHqNy73OwmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cKgm4+/4HvL79eJjtcM6iMIDdxCUd60ausHg8fQWswCFAEsPxneCPuD78Wkf+rleB9l2B9RuF0FQyT2vbnUluLIjlbiuXv5X9s/IuKOEFxEOF3LV+dWZaAQE524IqXuh6S1xcc1+G+Vv2Iz6/WDn9F1uI8YDFu38yyTQ9tjBLcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekV9pMM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekV9pMM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E851F000FF;
	Wed, 30 Sep 2026 19:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795464;
	bh=oP6HFf6u5HvDnKEsW01IGf6OZfu0kWQrLXfp63kYtL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekV9pMM7hov/ZzkS+o0FrlPromd7acS1Vid4C49VYSN1HXDzA/taF4tn/Ch1L6huB
	 RfwFg9txOExuCRxf8i9e/MU4dgCqGitzIdqj4SJH+Lj15juHQFTgCC2pMfh4hWDxv8
	 MxFGH4qh2tV1pyVs0i+vblz+sg39JruqFIjuZgbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0564/1193] net/micrel: Fix typos in micrel driver code comments
Date: Wed, 30 Sep 2026 17:20:48 +0200
Message-ID: <20260930152446.771818547@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Yicong Hui <yiconghui@gmail.com>

[ Upstream commit c2b733da93bf607d6c6f925b4d40598e6bb516be ]

Fix various typos and misspellings in code comments in the
drivers/net/ethernet/micrel directory

Signed-off-by: Yicong Hui <yiconghui@gmail.com>
Link: https://patch.msgid.link/20260118121001.136806-3-yiconghui@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 66ef5adb7544 ("net: ks8851: Fix receiver error in 100BASE-TX mode following software power-down")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/ks8842.c        | 4 ++--
 drivers/net/ethernet/micrel/ks8851_common.c | 2 +-
 drivers/net/ethernet/micrel/ks8851_spi.c    | 4 ++--
 drivers/net/ethernet/micrel/ksz884x.c       | 4 ++--
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index c11b118dc4158..de2ef3c1150d7 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -242,7 +242,7 @@ static void ks8842_reset(struct ks8842_adapter *adapter)
 		msleep(10);
 		iowrite16(0, adapter->hw_addr + REG_GRR);
 	} else {
-		/* The KS8842 goes haywire when doing softare reset
+		/* The KS8842 goes haywire when doing software reset
 		* a work around in the timberdale IP is implemented to
 		* do a hardware reset instead
 		ks8842_write16(adapter, 3, 1, REG_GRR);
@@ -312,7 +312,7 @@ static void ks8842_reset_hw(struct ks8842_adapter *adapter)
 	/* aggressive back off in half duplex */
 	ks8842_enable_bits(adapter, 32, 1 << 8, REG_SGCR1);
 
-	/* enable no excessive collison drop */
+	/* enable no excessive collision drop */
 	ks8842_enable_bits(adapter, 32, 1 << 3, REG_SGCR2);
 
 	/* Enable port 1 force flow control / back pressure / transmit / recv */
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index b1e9d1495c019..7c336e0a4b8ae 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -493,7 +493,7 @@ static int ks8851_net_open(struct net_device *dev)
  * ks8851_net_stop - close network device
  * @dev: The device being closed.
  *
- * Called to close down a network device which has been active. Cancell any
+ * Called to close down a network device which has been active. Cancel any
  * work, shutdown the RX and TX process and then place the chip into a low
  * power state whilst it is not being used.
  */
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 50afe8c11178e..a1d0918b8edd4 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -41,7 +41,7 @@ static int msg_enable;
  *
  * The @lock ensures that the chip is protected when certain operations are
  * in progress. When the read or write packet transfer is in progress, most
- * of the chip registers are not ccessible until the transfer is finished and
+ * of the chip registers are not accessible until the transfer is finished and
  * the DMA has been de-asserted.
  */
 struct ks8851_net_spi {
@@ -298,7 +298,7 @@ static unsigned int calc_txlen(unsigned int len)
 
 /**
  * ks8851_tx_work - process tx packet(s)
- * @work: The work strucutre what was scheduled.
+ * @work: The work structure what was scheduled.
  *
  * This is called when a number of packets have been scheduled for
  * transmission and need to be sent to the device.
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index c5aeeb964c17a..39e8749907408 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -1166,7 +1166,7 @@ struct ksz_port_info {
  * @tx_cfg:		Cached transmit control settings.
  * @rx_cfg:		Cached receive control settings.
  * @intr_mask:		Current interrupt mask.
- * @intr_set:		Current interrup set.
+ * @intr_set:		Current interrupt set.
  * @intr_blocked:	Interrupt blocked.
  * @rx_desc_info:	Receive descriptor information.
  * @tx_desc_info:	Transmit descriptor information.
@@ -2096,7 +2096,7 @@ static void sw_dis_prio_rate(struct ksz_hw *hw, int port)
 }
 
 /**
- * sw_init_prio_rate - initialize switch prioirty rate
+ * sw_init_prio_rate - initialize switch priority rate
  * @hw: 	The hardware instance.
  *
  * This routine initializes the priority rate function of the switch.
-- 
2.53.0



