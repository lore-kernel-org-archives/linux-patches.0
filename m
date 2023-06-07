Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17713925D
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0831BC433D2;
	Wed,  7 Jun 2023 20:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169493;
	bh=ftejme4eVJD6MZto6fRMcQQPd4H+JZApDIgaQn0AU9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWjhOQZk8tA0LNqHI4kmrA+/RhupJV5ZywTXIWhnib8iW3mqoy2vn+uUUlkI602Lg
	 8Ylyehd5lcKsX/Fea4tWjQ3Pa2zH2p+ya9P5cSJ5Snca4KBQ2QGKEgZ4SOQv9SU5lF
	 wswaf4rAo54KmkCmvUINj5YSNCayoPplkbwLjTrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 072/286] net: renesas: rswitch: Fix return value in error path of xmit
Date: Wed,  7 Jun 2023 22:12:51 +0200
Message-ID: <20230607200925.429165209@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit a60caf039e96d806b1ced893242bae82ba3ccf0d ]

Fix return value in the error path of rswitch_start_xmit(). If TX
queues are full, this function should return NETDEV_TX_BUSY.

Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20230529073817.1145208-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index c4f93d24c6a42..7855d9ef81eb1 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -1487,7 +1487,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 
 	if (rswitch_get_num_cur_queues(gq) >= gq->ring_size - 1) {
 		netif_stop_subqueue(ndev, 0);
-		return ret;
+		return NETDEV_TX_BUSY;
 	}
 
 	if (skb_put_padto(skb, ETH_ZLEN))
-- 
2.39.2



