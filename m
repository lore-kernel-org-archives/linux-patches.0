Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774544;
	b=jnY2KNZj6BI5iQ/kQnIivOD0KeXc8ORjj58Pop+QoWjbE2ZfXymoJ2esIKYey12UouFG
	 tioA/oJxAFZrW4iNwoajphPsjiugfq8M71BSmv7lD/Zczihlxx57O7MBn1Xta14tWZHJh
	 GTQ1XKzx8fO4AtDoU0cfUIpdEhhNMx7XSxKoDPnKv6qfDCk6pIh5PWy43NNa8jUlej3Ro
	 WrYdrt7wQXr5BTb4M9mCRu2T8FG/Kr7QBGi5uEhV/iqv2sLutqCKCV4NnZor8tA9k0xlh
	 KWRfMjsZK2lI3Om1ecRqOr+xbVQCzNsfuf4d1mUK+4p9s0/APiKSzL2BUx3BaQrrkOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1JVf7Usdc1IyZ6qLH/jqqI2SS8x0zQBycjYG++CChk=;
	b=gwx4wW5iOOSruQHFxGgipftbw/mtJuj8DW0k6eIx/YWNGTODMSn1ANxu/p5RvNZQShFP
	 7+rt/OOL/WhbXf3T9Zi6vTF2fJDa2FSLxUIpHzJgiBYai7aDLmTZrZ6YLtYydh1h5gps2
	 qN32FsuY5NE7fnOqIRPrR0Bk6MJ0DpQURzCGKxA8ZZlzMYGcMBBf8dkdi+e9+q7zW9Ce+
	 4coOsHikfgjiXGsPN8F3qjAlCoMwzvDpyJwrrypL7iJbcXhUsBYdOwLcYkDW/cJFMwMCA
	 hpoIsIsWtJtLKbI37hw0XVXlyPJ2w1CNntqzKbkNZm5RyUQClgkrbtsrzadpjf8+GUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="fqL5yG/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13828606A31A;
	Fri, 23 Oct 2026 16:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fqL5yG/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B00D1F01825;
	Fri, 23 Oct 2026 16:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774543;
	bh=Q1JVf7Usdc1IyZ6qLH/jqqI2SS8x0zQBycjYG++CChk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fqL5yG/+w6Ml+SrmIzmUIbbqI+9HuaAQD8nOW8LAad7m8w6gSxPJEEX2SBP48hL/z
	 bHjFYdB4aQVAc9zDHRmKgY1QMdIHcfRo5/wahnquGlkHydCnvI/LPXYVM66wv0Hifq
	 yNbd+DpAOqYVeby19PyOVb/wi5igIrXe5zckO028=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 075/242] net: hisilicon: hisi_femac: Move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:37 +0200
Message-ID: <20261023163715.553744396@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 444889dfa27b54b39026e962464b1f8f9093e1ea ]

hisi_femac_drv_probe() connects the PHY before dev->netdev_ops is
assigned. phy_attach_direct() -> phy_link_topo_add_phy() reads
dev->netdev_ops through netdev_need_ops_lock() since the commit in
question, so probing crashes with a NULL pointer dereference when
CONFIG_NET_SHAPER is enabled.

  phy_link_topo_add_phy from phy_attach_direct+0xec/0x37c
  of_phy_get_and_connect from hisi_femac_drv_probe+0x1f4/0x558
  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20261008022656.3592191-2-mmyangfl@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hisi_femac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hisi_femac.c b/drivers/net/ethernet/hisilicon/hisi_femac.c
index d244a40df4309..016605e86f0b0 100644
--- a/drivers/net/ethernet/hisilicon/hisi_femac.c
+++ b/drivers/net/ethernet/hisilicon/hisi_femac.c
@@ -830,6 +830,8 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 		hisi_femac_phy_reset(priv);
 	}
 
+	ndev->netdev_ops = &hisi_femac_netdev_ops;
+
 	phy = of_phy_get_and_connect(ndev, node, hisi_femac_adjust_link);
 	if (!phy) {
 		dev_err(dev, "connect to PHY failed!\n");
@@ -850,7 +852,6 @@ static int hisi_femac_drv_probe(struct platform_device *pdev)
 
 	ndev->watchdog_timeo = 6 * HZ;
 	ndev->priv_flags |= IFF_UNICAST_FLT;
-	ndev->netdev_ops = &hisi_femac_netdev_ops;
 	ndev->ethtool_ops = &hisi_femac_ethtools_ops;
 	netif_napi_add_weight(ndev, &priv->napi, hisi_femac_poll,
 			      FEMAC_POLL_WEIGHT);
-- 
2.53.0



