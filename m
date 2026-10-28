Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214516;
	b=zYuGaJ1HODdzxmfAczhSO2NAYavOIpiHDlxk0Xtm5vyzkknd/dK5JFlZ6zHCX+WWjqC+
	 vdHE23K1s98rx91fMFHtNj2uhfDjsMTfRufg7Wwg1zroIhjC7dvOwMCfCtTHcmuD7Lrjw
	 yoFQ+Kij75PL5f39d0YqeCI59RuiqgHVZ6NS2/E/JTEDWirnYTfDPPH9oDfGsKK4bd53Y
	 Uxe0bs0i+2dZpA5q3RNmWh9/lTGVVtaQ0hqhMzozBwJXMZyD0nJcckppktNmPW6XIgBi8
	 Rs9uDNtT2LShKV/xXOxndUiw+Syh0NmwoujAgnRsD7/7gKiWUzLOMNi0I3EFcMnar9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5uwkEiwjd7QDysTZB/c/yjmhPW58JmD+U4yEdTbz4xI=;
	b=GzTXu1dg+sMbew8e5vn2ilrQ+0VUmB5u8uqLFqi5bmiqtT0NXPaoFKcoy2ri1wMtcvVB
	 y4FAKDqhCnoKawK/2UD9Xx8cCpIjAbizZIYCJzqWuJ+U4SW7hCqD/Wur/fYMZmKWQofIN
	 iIVve7gwgZGEtCsiJzmAyBviU4Y43unEQgbPKr6M/F59lPaAs8AoD1I94BtmP2wVFVglh
	 0MgsNYRbtxgeRxBysPM5utuSnEDPekc+PP5r2bdXIjXn1tQYrUg/ECV8p3b/wd631KFBj
	 y7FHx5MWFdIP1WcgUop1uXJmDFR3ki4CAvGdPK9J5v23smqgbc1vLpp63S40/d+qvmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kii9cEL9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60FC606BF8F;
	Wed, 28 Oct 2026 19:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kii9cEL9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188A21F031E2;
	Wed, 28 Oct 2026 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214515;
	bh=5uwkEiwjd7QDysTZB/c/yjmhPW58JmD+U4yEdTbz4xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kii9cEL9SupmTcelceYXnNpMpbKYu29roRWNsfOx/4sYSzUyXRJ75+FoOXcXbOxak
	 /HxqmNc56v2wj/xVOpQBuUFBM3CJH+WIAR2bi0ibDIgeqMdiw0ycFJ+wHbrkTsgX7O
	 3E69JIHvIOvurO+1hH4VWJtGunI95W/vOyNGuXVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Tresidder <rtresidd@electromag.com.au>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0885/1887] net: stmmac: Prevent DSA tags from breaking COE
Date: Wed, 28 Oct 2026 17:49:41 +0100
Message-ID: <20261028170519.560706384@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Romain Gantois <romain.gantois@bootlin.com>

[ Upstream commit c2945c435c999c63e47f337bc7c13c98c21d0bcc ]

Some DSA tagging protocols change the EtherType field in the MAC header
e.g.  DSA_TAG_PROTO_(DSA/EDSA/BRCM/MTK/RTL4C_A/SJA1105). On TX these tagged
frames are ignored by the checksum offload engine and IP header checker of
some stmmac cores.

On RX, the stmmac driver wrongly assumes that checksums have been computed
for these tagged packets, and sets CHECKSUM_UNNECESSARY.

Add an additional check in the stmmac TX and RX hotpaths so that COE is
deactivated for packets with ethertypes that will not trigger the COE and
IP header checks.

Fixes: 6b2c6e4a938f ("net: stmmac: propagate feature flags to vlan")
Cc: <stable@vger.kernel.org>
Reported-by: Richard Tresidder <rtresidd@electromag.com.au>
Link: https://lore.kernel.org/netdev/e5c6c75f-2dfa-4e50-a1fb-6bf4cdb617c2@electromag.com.au/
Reported-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://lore.kernel.org/netdev/c57283ed-6b9b-b0e6-ee12-5655c1c54495@bootlin.com/
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: ee0aace5f844 ("net: stmmac: Correctly handle Rx checksum offload errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 37 ++++++++++++++++++-
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f72367ecdb879..e641739efe29c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4335,6 +4335,28 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+/**
+ * stmmac_has_ip_ethertype() - Check if packet has IP ethertype
+ * @skb: socket buffer to check
+ *
+ * Check if a packet has an ethertype that will trigger the IP header checks
+ * and IP/TCP checksum engine of the stmmac core.
+ *
+ * Return: true if the ethertype can trigger the checksum engine, false
+ * otherwise
+ */
+static bool stmmac_has_ip_ethertype(struct sk_buff *skb)
+{
+	int depth = 0;
+	__be16 proto;
+
+	proto = __vlan_get_protocol(skb, eth_header_parse_protocol(skb),
+				    &depth);
+
+	return (depth <= ETH_HLEN) &&
+		(proto == htons(ETH_P_IP) || proto == htons(ETH_P_IPV6));
+}
+
 /**
  *  stmmac_xmit - Tx entry point of the driver
  *  @skb : the socket buffer
@@ -4395,6 +4417,17 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	WARN_ON(tx_q->tx_skbuff[first_entry]);
 
 	csum_insertion = (skb->ip_summed == CHECKSUM_PARTIAL);
+	/* Packets that won't trigger the COE e.g. most DSA-tagged packets will
+	 * have to be checksummed in software.
+	 */
+	if (csum_insertion && !stmmac_has_ip_ethertype(skb)) {
+		if (unlikely(skb_checksum_help(skb)))
+			goto dma_map_err;
+		csum_insertion = !csum_insertion;
+		/* skb_checksum_help() may have linearized the skb */
+		nopaged_len = skb_headlen(skb);
+		nfrags = skb_shinfo(skb)->nr_frags;
+	}
 
 	if (likely(priv->extend_desc))
 		desc = (struct dma_desc *)(tx_q->dma_etx + entry);
@@ -4958,7 +4991,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	stmmac_rx_vlan(priv->dev, skb);
 	skb->protocol = eth_type_trans(skb, priv->dev);
 
-	if (unlikely(!coe))
+	if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
 		skb_checksum_none_assert(skb);
 	else
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -5458,7 +5491,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_rx_vlan(priv->dev, skb);
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-		if (unlikely(!coe))
+		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
 			skb_checksum_none_assert(skb);
 		else
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.53.0



