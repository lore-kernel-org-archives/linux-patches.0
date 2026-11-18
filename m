Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044457;
	b=I99CSVN1dLm+PAEOnax+JJjRpKYgCbs5XFvw9d6qq5ur+KSbQoSKnftnY5O0iYTp/3z/
	 +9le173YI1yJy/GNPusvhD6LS6Ii9h98eoA6NrQKi/5xBGnm1h8WEAaEWIXu2+lmijObw
	 DG8aBFjSB7LjP5FxXsN57zLYjsMGpYhGKVxzKRls8W2AHVF3ysfREWl/9/1JSO2eCoJu9
	 1gbTTcXh5RcluPhj2tuULEuzGhJ1gh/AqN+uDD/3yXKUS4zj8xFECWwMUKOnLBFVHOC6s
	 Vgmh6nJbnjuxdv89YWt+j37jAJLSo2/DRehUrvzoJiny6ghd8WKqFKAiYKh4FV89QNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8AeN8R6NO8FCweh461O89kSwujDOmPbe5E/Xgo9Fa2g=;
	b=gDXdAFwBAMxbDhZIK6P8mV7LPKxs3I7y44bMZqlzDIPLV8tEzMCfqL8WDmg7Xa0ohuOS
	 eYe5RBX8bnyjMwXRuAWaKkuwDa0JKmwyutjgyTaKTa7E8i1Nv0VlX1yqgeIH0dsilrUrx
	 fbYwgCXSEpbTS/8gsU31XO0tv5NJm57aNNiXl+IThbb0ghE0gmFOY5HPzo6KCTKKv7Hfw
	 5+eClDrigpugIb7VMi1L9ojiItq1BvUavjxjUpuAfTkj4RtG+KpOe7uUjN2247DJE4DgY
	 recjBFAqZ4R3vqdIDd2SG20ZoXkvpEzW5WHv3v7drEp9S7dUya6FKIwgekP28IBoO6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBnwPlBP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F67F606A31C;
	Wed, 18 Nov 2026 23:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBnwPlBP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767211F000C4;
	Wed, 18 Nov 2026 23:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044457;
	bh=8AeN8R6NO8FCweh461O89kSwujDOmPbe5E/Xgo9Fa2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBnwPlBP1NJpFoaMmUABCRDUNqiSll749sx1Mhz0rEICX0piTZCvCCVXebzWlN69F
	 IkkUIzpM/SJ9gSRxNDjXglST1QF1b1D0XmDoP0ZUb+2fwhr3RKUjN7HdzoRf/WIs73
	 JaMvJfshFEcd9jZW5cK8OwL2Qp82gq96pjlxXXnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jisheng Zhang <jszhang@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0525/2857] net: stmmac: dont clear network statistics in .ndo_open()
Date: Wed, 18 Nov 2026 15:25:59 +0100
Message-ID: <20261118150220.370824465@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jisheng Zhang <jszhang@kernel.org>

[ Upstream commit 2eb85b750512cc5dc5a93d5ff00e1f83b99651db ]

FWICT, the common style in other network drivers: the network
statistics are not cleared since initialization, follow the common
style for stmmac.

Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/20230717160630.1892-2-jszhang@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 19bdaeed3904c..7ce54375fb349 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3811,10 +3811,6 @@ static int __stmmac_open(struct net_device *dev,
 		}
 	}
 
-	/* Extra statistics */
-	memset(&priv->xstats, 0, sizeof(struct stmmac_extra_stats));
-	priv->xstats.threshold = tc;
-
 	priv->rx_copybreak = STMMAC_RX_COPYBREAK;
 
 	buf_sz = dma_conf->dma_buf_sz;
@@ -7434,6 +7430,8 @@ int stmmac_dvr_probe(struct device *device,
 #endif
 	priv->msg_enable = netif_msg_init(debug, default_msg_level);
 
+	priv->xstats.threshold = tc;
+
 	/* Initialize RSS */
 	rxq = priv->plat->rx_queues_to_use;
 	netdev_rss_key_fill(priv->rss.key, sizeof(priv->rss.key));
-- 
2.53.0



