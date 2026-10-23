Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774565;
	b=ZIZm4h/eZVwO4iynf6dCx3HsK54jGjMUEQPlzVTGp7pBCYUX6vB3eGRgtwlatZCVLBE9
	 CRPMCqtVOrNvqvdzsNdLIQVVDPStMuVmdNEc+Mgg7+NKjYNaM8a/bZ2rKBprOxQAHJrKu
	 Vf0VQjJBhVbTqlBDti+YM0otj2vhODyOfqMqHezqgnaALqsypqk+VaQj29RKTjcxST4Rh
	 foV+FWtCSq7R7PYuoBa6iQygCqKo6f7RamkVUfUM0F63fM658cII9qd2kWOAsJOaWT3g4
	 OfDezlFwQC+OXHDeT7R0xFLdiTgOUtJTb3n7RPRiiIiRLGSX4+cBoym6bGw1+Omthtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/V6x0+FB/Kqx0jH7UKo78GVKWv15ZvUA0M+GQjv7YyI=;
	b=gZG1EHzh92g2kyMqwpLCWZ9zpVIYO7D/KDgIdNXcBtK3aylOwGOfDL6Et6CLDMzYFdrs
	 Y7LfbXwCfKj4B4kfP+j7kxcBOYOtCqAhNjRTls4yqs4XcU7xkUSEAVfFcts8Gwujp/oV4
	 EMiIz3VzO7x6rF7t7UEsoDfdn0WN6+D0/3eZqgjJNG7FvDlWm9qi2kySgAeM/oVEbuZbQ
	 X9RF4Z4i/UhNSv77g2Pnu9s2yf7POOR4qeVL155ShynaD8ig+7aSn/wcIza9eempbPEDs
	 Li8ZcpVTdJFkLwocjczyyS+7GcvGeYITty40A8XB+t8twa0zx3bP01UBB7SxP3nDYpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pF/t7vMj";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C26606A31D;
	Fri, 23 Oct 2026 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pF/t7vMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA761F01825;
	Fri, 23 Oct 2026 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774564;
	bh=/V6x0+FB/Kqx0jH7UKo78GVKWv15ZvUA0M+GQjv7YyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pF/t7vMjZdyyAj1qEVkNu50XGuuR2Ld7TpLM69g7ikHb35X7GY/YGK83CW5ZS6MWI
	 92RqsJARxG62Ki8fB0Z3ny/i9gJfNBE+hcSGbOS/LjzIWTrB8wOvslYj6GQaShLRdw
	 dcJYqzr69CJa7LitAoHmIr6tutuYbntrmopbfBys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 082/242] net: ti: icssm-prueth: Move setting of netops to fix crash
Date: Fri, 23 Oct 2026 18:38:44 +0200
Message-ID: <20261023163715.717236981@linuxfoundation.org>
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

[ Upstream commit 955bb7cf680d8699ce94c73539af882840a9be43 ]

icssm_prueth_netdev_init() calls of_phy_get_and_connect() before
ndev->netdev_ops is assigned. phy_attach_direct() ->
phy_link_topo_add_phy() reads dev->netdev_ops through
netdev_need_ops_lock() since the commit in question, so probing crashes
with a NULL pointer dereference when CONFIG_NET_SHAPER is enabled.

Assign netdev_ops before the PHY attach, as was done for emac in commit
7c9f391ec89c ("net: emac: move setting of netops to fix crash").

Fixes: ded86da4bbb7 ("net: ethtool: relax ethnl_req_get_phydev() locking assertion")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20261008022656.3592191-10-mmyangfl@gmail.com
Reviewed-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssm/icssm_prueth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/icssm/icssm_prueth.c b/drivers/net/ethernet/ti/icssm/icssm_prueth.c
index b7e94244355a3..b42c98e861e08 100644
--- a/drivers/net/ethernet/ti/icssm/icssm_prueth.c
+++ b/drivers/net/ethernet/ti/icssm/icssm_prueth.c
@@ -1563,6 +1563,8 @@ static int icssm_prueth_netdev_init(struct prueth *prueth,
 	}
 	ether_addr_copy(emac->mac_addr, ndev->dev_addr);
 
+	ndev->netdev_ops = &emac_netdev_ops;
+
 	/* connect PHY */
 	emac->phydev = of_phy_get_and_connect(ndev, eth_node,
 					      icssm_emac_adjust_link);
@@ -1590,7 +1592,6 @@ static int icssm_prueth_netdev_init(struct prueth *prueth,
 	}
 
 	ndev->dev.of_node = eth_node;
-	ndev->netdev_ops = &emac_netdev_ops;
 
 	netif_napi_add(ndev, &emac->napi, icssm_emac_napi_poll);
 
-- 
2.53.0



