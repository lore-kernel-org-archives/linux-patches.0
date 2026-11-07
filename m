Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064943;
	b=rqcQ/JLYGmMHpAl7dAPiDP17zurG4yon/umbANZB8cPswQ4DFJQZlx06NWLBzhx/HtAS
	 xbb8vcA+oRU+JrsYlGLEZn8y6PQo+kq1ulAxLypZuN7+lJX+CES2fcKtSML+yX+Bw8dZ8
	 Qg/ZDszAftUZnpV9nl0piDRVh3UN4yhgBlpAXV5+uYREsE0arrUzw87WUn7sgOZtYKled
	 5abz2oDg4fvfDeTZzXTmG7Q+anZf0glZ5Tvc2xDGYQbmOXUu8OSty/WdyP0iC+jvBlJB0
	 XO3VlBQt9Odft5yTLXM05RmjQWO1jcOl1mEc5yqox9lQ7pNkxEKp2xsYIJK6PPJOp2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OHcBeenjDKP4KOWKR6agDXTqn+B/NdqxXKfFN4a8HSw=;
	b=XMea9sr3jBZKzP1KcUmLfnUZRQpOJBH9s4Btb6lwDE21c89rgLu3yat84QefHcG4FBMn
	 6KWtnB5WBUOpcQEqrlgr8ztNGz9rQnnki/LDnmSMtnS4p2VBf3KV2LqGV537ZgYI5mZNm
	 WaXvrzeIm1GgnD/2TXagUjEucfxU6eEL5ch9Fejnuxot/fK8DluS197sQiK1FTmrERv8M
	 btAtm5v3NJ2U2IWb6BaagXoXTgmBlBI7sUFlGcRCxkGB0UazMijd9gNuLzGguYnQIl+56
	 cPYxuDUz0tFZ4qPRIf/k/uJorUQWAMt8beQy/ZWDTdUPmw2ODNaUzU6mHJbCS0doHhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGPW8Vg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44692606A331;
	Sat,  7 Nov 2026 15:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZGPW8Vg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AD61F0089F;
	Sat,  7 Nov 2026 15:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064943;
	bh=OHcBeenjDKP4KOWKR6agDXTqn+B/NdqxXKfFN4a8HSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZGPW8Vg6hSnxcIiuT/AGCjbJWbJP9nxh1W3rJpIGHn4D5VyxEgnGGuGr2QLROtDa1
	 5nECpaer8lwT9rmBB9YuxN/rpnFUgl7uheTqMw+LU97Ai7VB91TYrj4cSxUtzWkckq
	 Xo3xuxsS9z9pQDc4e+hhM59y58aUCxRE7kS0xuoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0831/1257] net: bgmac: enable interrupts only after NAPI is ready
Date: Sat,  7 Nov 2026 08:52:07 -0500
Message-ID: <20261107135002.285922622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 3e9c57196a397..1835266fdd09f 100644
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
@@ -1608,10 +1608,10 @@ int bgmac_enet_resume(struct bgmac *bgmac)
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



