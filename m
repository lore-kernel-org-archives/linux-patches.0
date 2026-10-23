Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774547;
	b=zPk7Kvdm9sMGPJIR9x0XuVXt9AlkCsoXcDh1+69V533ywmmJE7n6gqz7jIjPdiqhS09+
	 qXkJR+BnlED8VVQtLl3VGNGQHa7x3PxLNVqg+OFobyYGR+jsRaMpY1H59lgZ59ytigCfg
	 gti0e2G/uoZSmqrRTz3lk8tiFw+IIuxWI9bKbPMoo3rmk+HI/qXKFe0cDb2Mw59UncGsS
	 fCpLB4x/ANbNUJbe6EbTkZXWoq2yvTPtICigGo2O5hoRwOgSxWoXFSdlxlF5nTW69pTzZ
	 B6tnfk9jm7ckW23JqNS1B6UJG+LvQY3lDrMpxX1qKFSSIPTFppyuhpjhL7CbsakU0XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774547;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZjkwtzbdH6nwbq6Nvs4+PVnhQbzVmWlPucpBeYJj0g=;
	b=AhuHgqoCYQTRJhDa1TmqIaBxKhfu769BdoCp0Fz1baQ6NZEwnG241hMqhGYEZA1EUXEx
	 IM4G4zAguA6y6BTTFwcXGIUC/KvPj+uEAGebG4/XzkwzXSq1FLjIbJbTp20gm41TZDGFG
	 byI5xnp7lEp3PJ5/E9wU//v42LNPShejUjBpzYUbMXQg9vlPJLqWX7ab3Sf9sfGxd2vJL
	 9fTQDkehkocQXPx1ouGBN4lRfsn3IKq2/kgSmj/mG6IUZrxEkP4fJvL9CMcNj4ixiFZxP
	 2Ao3Cl9O+m/wNPyBOApCYZs3iUQNpUlfDGGg/XzHSNR6WuQm/Hfu02o5+iiV01OuE3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+3knK3J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04B55606A31A;
	Fri, 23 Oct 2026 16:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+3knK3J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539481F01825;
	Fri, 23 Oct 2026 16:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774546;
	bh=TZjkwtzbdH6nwbq6Nvs4+PVnhQbzVmWlPucpBeYJj0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+3knK3J0YfFSv+4XHYmGzJJO/OeV+GTOISJKRCCgARO+QymyIBus9gByqQ7RPrUO
	 OLQyM5BBVvoOBnjna91fMYPMpLXzarunSUvRJOhqAaps4bS0TJF9o+U57wVPZIWWPq
	 MDF/pR95hToNictdYCtVF8rsPiSxP/R4Oza5uT5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 076/242] net: hisilicon: hip04_eth: Move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:38 +0200
Message-ID: <20261023163715.576716303@linuxfoundation.org>
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

[ Upstream commit 0d9342701f14ec0a9465772b7cd5d515c1ecd818 ]

hip04_mac_probe() calls of_phy_connect() before ndev->netdev_ops is
assigned. phy_attach_direct() -> phy_link_topo_add_phy() reads
dev->netdev_ops through netdev_need_ops_lock() since the commit in
question, so probing crashes with a NULL pointer dereference when
CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261008022656.3592191-3-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index fc2c47dcfaabe..d0409de5c5531 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -976,6 +976,8 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
+	ndev->netdev_ops = &hip04_netdev_ops;
+
 	priv->phy_node = of_parse_phandle(node, "phy-handle", 0);
 	if (priv->phy_node) {
 		priv->phy = of_phy_connect(ndev, priv->phy_node,
@@ -989,7 +991,6 @@ static int hip04_mac_probe(struct platform_device *pdev)
 
 	INIT_WORK(&priv->tx_timeout_task, hip04_tx_timeout_task);
 
-	ndev->netdev_ops = &hip04_netdev_ops;
 	ndev->ethtool_ops = &hip04_ethtool_ops;
 	ndev->watchdog_timeo = TX_TIMEOUT;
 	ndev->priv_flags |= IFF_UNICAST_FLT;
-- 
2.53.0



