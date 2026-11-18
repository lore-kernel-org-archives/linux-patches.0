Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058917;
	b=HBEoyXaQ6IHdVsbIegiq8tCNeJmqQlfXKhZTtFRPvUA6XbChQDZIQKWfbjN1asqTlws/
	 dCVuFwEKaHK0RlLUmS1OIFhzV67xg2exRFFgbHkF0nouH5ElAc3UrDL5OFJgsK+9xEv1o
	 0do4Nl78z2+ZhRJ/YH4dOe74kFCU825zoWtHCT4PcFBn9reyQ3fidIyUGtH3mIZVSrvj9
	 NfdP0bjC2C2L27979JUyHgVmQlR4VqokwhoM3bn7fC9aETs4tPL0jrXbMHQMdISImRISh
	 1OuZG7J2HIvP/JG0+Y0F/giT+szI8yAUks82QPiCYjPZiwkqAwZqHyr5CN7Ja3SqDDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XGBbnFInffFpnHlUn2JZT7vInJP+HC1goaI2JP/zoUE=;
	b=AlU4x83p3+Uqcd8f6spubXYzLA/FOkvEdbtsasY7+1X2aZ2+U4D//DHMc+vpE/Yjt5BF
	 C/qguYAe822V7o+xzyfr1wJ0zAozuP3pcYdW58Y71YoWNcgHDZSNImIllsTlDbe596zd1
	 uJJfqhNJuUXApk+PQvSAA7MGljphadh7e51NX/aOm0ObI/sug8R6vqp8ap+jQ17VcbnOa
	 RjnJrV9taV8cqqsyoHTd6oLDaTSlUrUzfcZY2hpxLWQNr5YzC+LlUtzpQMKELQ8QBOW1V
	 bNbPTga9ANjQtsoV7jgkt4O97fklGBntb0KO8rAYvq4NQOW4H1LvFqZ/0WXhpUryMug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="x/5MncIX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACABA606A320;
	Thu, 19 Nov 2026 03:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=x/5MncIX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077591F000C5;
	Thu, 19 Nov 2026 03:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058917;
	bh=XGBbnFInffFpnHlUn2JZT7vInJP+HC1goaI2JP/zoUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/5MncIXezax2qiOZZcy3DwYxzzKG9lIeNzDcb7f6hGivifokSha38LMHbg/4YvVl
	 svTx7fN9U2zT8TNmBX11ykpVl9JgCiW7ggj8I35KibB5KD0SCD4QQc7BeplGZ0Pq6l
	 Y6AV6dpjU7nsEv6qRcmmVMlfgm9B3IX/gCF+8eQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0656/1848] net: bgmac: enable interrupts only after NAPI is ready
Date: Wed, 18 Nov 2026 15:44:54 +0100
Message-ID: <20261118145943.258274648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit ac1f6e58cb77bb66b8811f7d98703e0f076a8f65 ]

bgmac_open() calls bgmac_chip_init(), which unmasks the interrupts and
enables the MAC receiver, before request_irq() and napi_enable().
bgmac_enet_resume() also enables NAPI only after bgmac_chip_init().

When frames arrive in that window, the first RX interrupt masks all
interrupts in bgmac_interrupt() and calls napi_schedule() on a NAPI
instance that is still disabled, so nothing is scheduled. Nothing
unmasks the interrupts again, the RX ring fills up and the interface
stays deaf until it is brought down and up without traffic.

On an Asus RT-N16 (BCM4716) a single "ip link set eth0 down/up" while
a host sends UDP to the router left INT_MASK at 0, INT_STATUS with RX
pending and the RX DMA idle on a full ring, with the RX packet and
interrupt counters no longer moving. With this change, 10 of 10 such
cycles recovered on their own.

Request the IRQ and enable NAPI before the chip is initialized.

Fixes: dd4544f05469 ("bgmac: driver for GBit MAC core on BCMA bus")
Fixes: f3537b3494c0 ("net: ethernet: bgmac: driver power manangement")
Cc: stable@vger.kernel.org
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261010070011.60403-1-rosenp@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bgmac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bgmac.c b/drivers/net/ethernet/broadcom/bgmac.c
index a4f6143e66fe9..19177f90c2329 100644
--- a/drivers/net/ethernet/broadcom/bgmac.c
+++ b/drivers/net/ethernet/broadcom/bgmac.c
@@ -1183,9 +1183,6 @@ static int bgmac_open(struct net_device *net_dev)
 	if (err)
 		return err;
 
-	/* Specs say about reclaiming rings here, but we do that in DMA init */
-	bgmac_chip_init(bgmac);
-
 	err = request_irq(bgmac->irq, bgmac_interrupt, IRQF_SHARED,
 			  net_dev->name, net_dev);
 	if (err < 0) {
@@ -1195,6 +1192,9 @@ static int bgmac_open(struct net_device *net_dev)
 	}
 	napi_enable(&bgmac->napi);
 
+	/* Specs say about reclaiming rings here, but we do that in DMA init */
+	bgmac_chip_init(bgmac);
+
 	phy_start(net_dev->phydev);
 
 	netif_start_queue(net_dev);
@@ -1609,10 +1609,10 @@ int bgmac_enet_resume(struct bgmac *bgmac)
 	if (rc)
 		return rc;
 
-	bgmac_chip_init(bgmac);
-
 	napi_enable(&bgmac->napi);
 
+	bgmac_chip_init(bgmac);
+
 	netif_tx_lock(bgmac->net_dev);
 	netif_device_attach(bgmac->net_dev);
 	netif_tx_unlock(bgmac->net_dev);
-- 
2.53.0



