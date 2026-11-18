Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034000;
	b=gPqL09NwfNeV25jxYshvsb26eAZEdlKvRUEzq5DggKFGb5Zvv03prtvNj6CfQCNaI0h2
	 xElVJpQIQhw/EWPoP68/LGYNEh680JrvF5jselgktW+t6augMIfU3fdh/niLHyBw74AYx
	 JAjGfC1skeaBGo7LpqWlLR3STZHyQq3DIXAkI9y0mIEM0kiCX5A9T5sN/+o2CPIdjM0m9
	 cUdIkSJ/3Z73vlH5qJuXUiu9W9Vj0aXUZS+CJrVYjzyuC+bw2JoUw9UYcZMqHSYQQB3bJ
	 wI6N8wXNgAqvJG7EGRwX4pZKOE2RBnXRYGNuIk3wR4f+dwsnryMoEO8woIeqKbjbFqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034000;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGuPJ1+VzkBjyCCmd2IY15HOKbwIb5joXGQm2p6WDoU=;
	b=koKTbJzRmHtmlFOw8EUZ1uD03fRuzSZo7iqXRYr7Id82g3RHrtFXXw1XPqGxcFOlzo+0
	 iGw/9e41CLt6hd0gWYqiTI2Itk++2dVeEcUyvzttWb2CQZklPhIZPpetdGUBsrtTgcEKy
	 LqXqSyixjCTh/CNVpGAtP74V3DVjD3QLvgLXN6pXa5RlZcMDZyNkg32dgWf0UcT2ugWLQ
	 kyW4qMfMOW1Cyx0iivvPCYpNEF5LHv2eE8zs4l4KOB6Zd/b6/rl8OPFuRW4/x9dfuhqQO
	 3FL+IC6TQfWWOj4UJhosHXa9h07+Q0NsSjrWfexzmgbgv76ldJTNHcpdlX/MH46nVCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAkOCY4B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC9DF606A32C;
	Wed, 18 Nov 2026 20:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gAkOCY4B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0461F000C4;
	Wed, 18 Nov 2026 20:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034000;
	bh=gGuPJ1+VzkBjyCCmd2IY15HOKbwIb5joXGQm2p6WDoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gAkOCY4BVpgurCD9AnM8dBqIp2sYiA1Sd3OPNPM2i67hfg/aThZFjdLaxheZmr9Db
	 yagcdSF5rVt9h/aag7TqYvYqXCjBDanTB0h84qqH8ESsiiT8tt+uUVwXEjazxH1AfC
	 J9X/xl8X/ycshR1qPVypoGafV9wEC+2Vgvc0BRKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mariano Baragiola <mbaragiola@linux.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0215/3318] wifi: wilc1000: validate monitor transmit frame headers
Date: Wed, 18 Nov 2026 15:13:57 +0100
Message-ID: <20261118150321.404703682@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mariano Baragiola <mbaragiola@linux.com>

[ Upstream commit 9d96e037ff90a2fc81a841b2002d500a5a4a5351 ]

wilc_wfi_mon_xmit() reads the radiotap length before ensuring that the
fixed header is present. After stripping that header, it reads the frame
type and all three 802.11 addresses without checking how much frame data
remains.

A truncated monitor injection can therefore cause out-of-bounds reads.
Validate the radiotap header first, use the common 802.11 helper to check
the variable header length, and require a complete three-address header
before using the addresses. This covers QoS and four-address data headers
while rejecting short control headers that this path cannot classify.

Signed-off-by: Mariano Baragiola <mbaragiola@linux.com>
Link: https://patch.msgid.link/20260728192610.2236361-1-mbaragiola@linux.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/mon.c | 30 +++++++++++++++----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/mon.c b/drivers/net/wireless/microchip/wilc1000/mon.c
index c3d27aaec2974..c0fde3b0d8aab 100644
--- a/drivers/net/wireless/microchip/wilc1000/mon.c
+++ b/drivers/net/wireless/microchip/wilc1000/mon.c
@@ -142,6 +142,9 @@ static int mon_mgmt_tx(struct net_device *dev, const u8 *buf, size_t len)
 static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 				     struct net_device *dev)
 {
+	struct ieee80211_radiotap_header_fixed *rtap_hdr;
+	struct ieee80211_hdr_3addr *hdr;
+	unsigned int hdr_len;
 	u32 rtap_len, ret = 0;
 	struct wilc_wfi_mon_priv  *mon_priv;
 	struct sk_buff *skb2;
@@ -153,13 +156,26 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	if (!mon_priv)
 		return -EFAULT;
 
+	if (skb->len < sizeof(*rtap_hdr))
+		goto drop;
+
+	rtap_hdr = (void *)skb->data;
+	if (rtap_hdr->it_version)
+		goto drop;
+
 	rtap_len = ieee80211_get_radiotap_len(skb->data);
-	if (skb->len < rtap_len)
-		return -1;
+	if (rtap_len < sizeof(*rtap_hdr) || skb->len < rtap_len)
+		goto drop;
 
 	skb_pull(skb, rtap_len);
+	hdr_len = ieee80211_get_hdrlen_from_skb(skb);
+	if (hdr_len < sizeof(*hdr))
+		goto drop;
 
-	if (skb->data[0] == 0xc0 && is_broadcast_ether_addr(&skb->data[4])) {
+	hdr = (void *)skb->data;
+
+	if (ieee80211_is_deauth(hdr->frame_control) &&
+	    is_broadcast_ether_addr(hdr->addr1)) {
 		skb2 = dev_alloc_skb(skb->len + sizeof(*cb_hdr));
 		if (!skb2)
 			return -ENOMEM;
@@ -191,8 +207,8 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 	skb->dev = mon_priv->real_ndev;
 
-	ether_addr_copy(srcadd, &skb->data[10]);
-	ether_addr_copy(bssid, &skb->data[16]);
+	ether_addr_copy(srcadd, hdr->addr2);
+	ether_addr_copy(bssid, hdr->addr3);
 	/*
 	 * Identify if data or mgmt packet, if source address and bssid
 	 * fields are equal send it to mgmt frames handler
@@ -207,6 +223,10 @@ static netdev_tx_t wilc_wfi_mon_xmit(struct sk_buff *skb,
 	}
 
 	return ret;
+
+drop:
+	dev_kfree_skb(skb);
+	return NETDEV_TX_OK;
 }
 
 static const struct net_device_ops wilc_wfi_netdev_ops = {
-- 
2.53.0



