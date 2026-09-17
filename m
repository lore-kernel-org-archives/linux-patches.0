Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC8D531633;
	Thu, 17 Sep 2026 17:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666106; cv=none; b=Da8ik5zSsy+7Be308m21u+Atxb2zsdwyja72eVLGQt/ZTdBkETBunJNKLfAmQy0zgoQCRdw/ucAv9JnYZiS7ZzjMV6h79mvEy8YdxmdiFnjBUF5RIPd0MT84phuwwnGOZxBhtdt+R00WStRj77j2G3AS42YfweZl/ukSJgxXGw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666106; c=relaxed/simple;
	bh=jyBT4EcTaXtkFRwqSBXHBpzhf6wvUzWEapqDErTbGL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8SGUtLFHEmEsU+EOq441Oa1hEEW49OXQN2cPZnZDZsKmP3U2L8HJ5pQHC32txdHjbzsQzvnPbvPYtiQm0Xh3HCUBXEaS9da7aaXwqMyhXE8Nx229oZr6ZGz+hZUVeiTo7L2vvNeSKvVEFaQUh/NIhzW4H8+KFjlAC0lGi8tT4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SnbAACFx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SnbAACFx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E8761F000FF;
	Thu, 17 Sep 2026 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666104;
	bh=/L1e6ZtraohZS8FAkwbDFDG3Dd5w8ObeAninO9idXwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SnbAACFxF4lHzymLmFXRQl9QAGVEFn4TXcMJ5HueknrCVSa9XzXKdNDVhPCiiIf0S
	 Kp+Wpl1tc81DNokxtMwsGU1VASktvPNnDS7SbTpTeza3D84WlomJaPpKrmTL8kJRoE
	 X7XPkR7QepWN9GeOK8I+cZPxoXwZBy+zPfzhEwl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yicong Hui <yiconghui@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0899/1250] net/micrel: Fix typos in micrel driver code comments
Date: Thu, 17 Sep 2026 16:11:34 +0100
Message-ID: <20260917151616.356264851@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 541c41a9077a4..b7cf2ee9115fd 100644
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
index 0369e80b01bec..4afbb40bc0e4a 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -477,7 +477,7 @@ static int ks8851_net_open(struct net_device *dev)
  * ks8851_net_stop - close network device
  * @dev: The device being closed.
  *
- * Called to close down a network device which has been active. Cancell any
+ * Called to close down a network device which has been active. Cancel any
  * work, shutdown the RX and TX process and then place the chip into a low
  * power state whilst it is not being used.
  */
diff --git a/drivers/net/ethernet/micrel/ks8851_spi.c b/drivers/net/ethernet/micrel/ks8851_spi.c
index 28a7ff7644bb5..b9e68520278d0 100644
--- a/drivers/net/ethernet/micrel/ks8851_spi.c
+++ b/drivers/net/ethernet/micrel/ks8851_spi.c
@@ -39,7 +39,7 @@ static int msg_enable;
  *
  * The @lock ensures that the chip is protected when certain operations are
  * in progress. When the read or write packet transfer is in progress, most
- * of the chip registers are not ccessible until the transfer is finished and
+ * of the chip registers are not accessible until the transfer is finished and
  * the DMA has been de-asserted.
  */
 struct ks8851_net_spi {
@@ -296,7 +296,7 @@ static unsigned int calc_txlen(unsigned int len)
 
 /**
  * ks8851_tx_work - process tx packet(s)
- * @work: The work strucutre what was scheduled.
+ * @work: The work structure what was scheduled.
  *
  * This is called when a number of packets have been scheduled for
  * transmission and need to be sent to the device.
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index cdde19b8edc46..60223f03482da 100644
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



