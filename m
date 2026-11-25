Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619017;
	b=xodfbZwf1+JY8RdK14LDj/QWff4iRA70dTf5mIn0/O3HYso/uD5LN2tWmAvBGgd3DeNM
	 nVyC0WMFE+m+yF9FvDmemFmaqpMAC4QCIqGB9JB3nTC2SwmfVnukvfBUNFVIpMenGp2yJ
	 sKZVMkfslZPAVBW4Tx7pZmVih//gryEL1YoDs234163N8kQkNbtTESrg6n0wdkG0f2snE
	 qURS1wKiAy2Asy3E3cj1tNd8IAuJv7wD/8zvo0wel2FquDrDVt2ETjlydBHK7fdiPCNPS
	 ZWpSbCN8zysB1vnS9hbf2FnGGuJEk/Iz5V3k30JWLhetcBJEs3qwTnyHvPp+qhr0scA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6dLUZ58n2/RKEX17YTDpQVUGT60n7gXgM1x3dMawHv8=;
	b=bQkIlN2NkWYe5HFf8P4cRAqppk4EZgwn1qxOM7HPbKs5L4LUUDcecPB7s9ubMtYLTNjL
	 nQWkVIURzcw+WLbSIqBWCYdnlWdu9qsTKyVz9sgTF7WorI9Q1d2doQm9f2mAjWYJkqteK
	 AjsxlKn/IVgL2RnNJ/MYPkJYbGN3mKI16x9DZVX0WHTAQAUF0AMk4PUo2IXfXhKKZP9mv
	 Pye4VbC84rfgXTSC1fD2d+vfVDQt9EC4duNS7BbxStKvrqNDJScHMcuhmzn9ZhyVn4bc/
	 m+CeHs2qdXtdWBNxBfHp+0R5gomQKHDCnP7A1Xn/KyMwRP0OIMj1t7CNnFh/4kXBNdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4giy5kY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58939606A321;
	Wed, 25 Nov 2026 15:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y4giy5kY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D741F000CF;
	Wed, 25 Nov 2026 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619016;
	bh=6dLUZ58n2/RKEX17YTDpQVUGT60n7gXgM1x3dMawHv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y4giy5kYtycunE8j2WS8qU180Seb428bFnI6Scru0ne5ZfgcFKhjIQPlWOt0FXc+M
	 frg9WT+ScSkfXMQ9k7F2MPujuzuvhqLI2bRo2qtyxqMFqXQdQ73Dgu0VA2YWerYlgp
	 IyjtkRRhTn0T60PtvbRzhcI/H4BU88e0o05UiQHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0463/1005] ipvlan: make outbound skb headers writable
Date: Wed, 25 Nov 2026 15:30:01 +0100
Message-ID: <20261125143832.590754602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit a45dbf182137275f44ad7c8bc8acd23f7af6b2cf ]

In L3 and L3S modes, ipvlan_process_v4_outbound() and
ipvlan_process_v6_outbound() hand the skb to ip_local_out() and
ip6_local_out(). The IP output path assumes it owns the network header:
__ip_local_out() rewrites tot_len and the header checksum, and
transport-mode XFRM can memmove the network header into the headroom
when xfrm_skb_check_space() finds enough room, without copying.

The skb reaching ipvlan can have its header shared with another skb,
for example after an AF_PACKET tap on the ipvlan device or a tc mirred
mirror action. pskb_network_may_pull() only makes the header linear;
it does not unshare an already linear head. The writes above then
modify the other skb. If that skb is on the receive path and its IPv4
header was already validated, IPv4 option processing can use the
modified header, write past the linear data, and corrupt
skb_shared_info.

Use skb_cow_head() before taking header pointers and entering the local
IP output path, like ip_forward() does with skb_cow() before it touches
the header. Only checking skb_header_cloned() is enough here: skbs that
TCP transmits are clones of the write-queue skb, whose header area has
been released with __skb_header_release(). Their headers are private,
so they are not copied, which avoids a reallocation for every TCP
segment sent through an ipvlan slave.

If the allocation fails, the existing error accounting and drop paths
are used. L2 mode is unaffected.

[edumazet: use skb_cow_head() instead of skb_unclone() to avoid
 copying every TCP segment, reword changelog]

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261104113530.986664-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 7ad12dc7845c8..d2afc2ec896e0 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -438,7 +438,8 @@ static noinline_for_stack int ipvlan_process_v4_outbound(struct sk_buff *skb)
 		.flowi4_mark = skb->mark,
 	};
 
-	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)) ||
+	    skb_cow_head(skb, 0))
 		goto err;
 
 	ip4h = ip_hdr(skb);
@@ -504,7 +505,8 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	int err, ret = NET_XMIT_DROP;
 
-	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr))) {
+	if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)) ||
+	    skb_cow_head(skb, 0)) {
 		DEV_STATS_INC(dev, tx_errors);
 		kfree_skb(skb);
 		return ret;
-- 
2.53.0



