Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B483DD86A;
	Thu, 17 Sep 2026 18:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670899; cv=none; b=ZmqgrwacvSuFA3P4sRuF+ybwVKGTTZUP6e8uDEoXBemfBIhAiPfHI7rTIzBcuhN2ybci07tvc/KmdJhAsHu3M3HxpdvQ5CZ5Y87p/qOT6u0DnwBtXGXcd+FvvbAy/KG7L0kCsFoI3TMi30yi+tpF6VQoh9nrHl8c+62N6ZtyRI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670899; c=relaxed/simple;
	bh=6hy6xyxqRPlgyabJA+mvd5oBv8PUrjlT+paZnt8TrL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AUBLeRuA8Jee4Eb6JJ9beJqOx+8UNxJwV7kv9RQAllVrSWw5p7nqaRIkRzfHyyfs82pCIzSbsNvqTBkx1CiUPaWOpV0k4cW61gKM03akLUNByGD20cdtv1HqKWSF7doQRkPtCU88Dv2hxXIdd40Dem9+uqr4YOs6MdpbHrDzEu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8+QOaPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8+QOaPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D88A61F000FF;
	Thu, 17 Sep 2026 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670897;
	bh=YormLDP/fLYPJ/VewwGz9gax1+IShXBJGJSJ0PFDd7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u8+QOaPxVayhxPmpjwOXuFT49LpUaXgbrmaeIVrjrSv0X3sKpx9ObvWsEQokUNq0z
	 XySprFse/xUiqud2h86MD1tqHdKpMjsSEDcpFm3hB75Op9UZLabAOZ8fGkPOENKSu9
	 q+DHizL15aaYyVSpuViwpoTclJbTHP1obcagY83Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0758/1102] net/micrel: Fix typos in micrel driver code comments
Date: Thu, 17 Sep 2026 16:11:41 +0100
Message-ID: <20260917151559.459253277@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ddd87ef71caf7..a1ceaea369d0b 100644
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
index a7a198507374b..1db2ef1a8212b 100644
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
index dc1d9f7745658..ce683e18a978b 100644
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



