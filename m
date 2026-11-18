Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053137;
	b=pp0KP1ccfAl2ZIp29XUmqUTnoPqbJQIQOh6NadSNr9QxmNODjhY2NSlBe5tWJHC1uAnm
	 VWMBmuZa2a/bwDC+t7NdXQ6Npx2ZcdgAq65PBAf0KomOaEQLytbav6oDyCQeXaiad18yc
	 rXKnVWaB+ppG/ZYnQIVZisg1AI5gshLejsosTmNXDtT9T8tVG3UiU6ZC3ArgEHWFOesyu
	 aeD5qOrLVK4D66OGMMUDq/2R8lKkcWKpTUuuMZeSt6sFNPhTLfwIf3Ope4iDXmBw3+Id8
	 GcbnutjzMCFzymyhQnkm1etmrDuXmW/TEz2yoWzDru+qhhujhQ+JNmXIIFt6RMwIimg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mMaoT/fDQ8OsKLt8luuBgZxkFv/lxYoPdVLz2MVJPJY=;
	b=wKjvqzmrQEr2Sv5t6rjkoVM8pyTUWDJrX39B2I+Qy674jw1CG0Ci9EgV34c0XmStQMLw
	 5DfIZhPuVE09tJ07kJViqEiK/4BWI49FefkUxCFM6Ca96x8pGRSUEzF498cxFLtC8+d4L
	 p/Fn5t6wP/0b8rBzwx4UO0ALAiTAFHvuvi+YS2rdBkhtpJV38gFnJSOmRIJb+G32ghJbW
	 9KCxJNbTy74IJNueoV2I3Go8EMI/oSEDY4qDcq7rk2hSb7ZgqVpWQd96tO3sxKQ/Z5RHi
	 eShrl5NCOKD1bskV6jYRTVkA+9Msz316s9qIIKw7RNqCE8FRWvfepl/lB5rEXWid13Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="B/g+eP7O";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391A9606A32A;
	Thu, 19 Nov 2026 01:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B/g+eP7O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A76D1F000C5;
	Thu, 19 Nov 2026 01:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053137;
	bh=mMaoT/fDQ8OsKLt8luuBgZxkFv/lxYoPdVLz2MVJPJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B/g+eP7Opuw8czOKkYYXNDSVIT//qGmN9eMD9Z3ik90ZvFfFRacelyPLMo3HToItK
	 SA6naFKARkUhpMKXBUKSozXDqw+eL2GIdkF5djbuELXrCL0/ij+LgZUej+WaJma2pe
	 uZ5QGrzRgRON1pBMGHea9qWl77ZF8b7hbWfbDbtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0812/2214] net: bgmac: enable interrupts only after NAPI is ready
Date: Wed, 18 Nov 2026 15:41:28 +0100
Message-ID: <20261118150043.950408006@linuxfoundation.org>
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
index 3b42674b9df6d..4239fbb866fd3 100644
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



