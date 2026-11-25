Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624822;
	b=PLQJY17Rc93+NmEiqCUy+g+8lSrCzQk7v6nf+PR/HAAYgr3joFXUA20RLzFkqPtWBwhA
	 sw/4CK6d8+/p9QPwko1Pz0ZfOxgchmGkDnUf1Lnky+m0y4rP1B/LR9vCY3v92zx20lB+D
	 U6sdjLT9tsUy//o4cVBPJXMLPAtfbOs78vKQMOcLwHBODRJ7fYiBgM8/0KjkoOUWtf9DU
	 Go+7s3tGwnX3opx4MHzjzTnDpbilx/JaXMLmW1CnJ/5Tgh+xDfqHmj13fnAVubEpq1Gaz
	 oKwkn6AAz00SY36m1R9Rq7hBtXB0h9jreCbVmdzA5zWmJB+rgCouHn+qo6+bwu3FhRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0WRjm08jIRhBNlWx0vhKWLZMscbG09VKdJBRU7SJhj0=;
	b=HcPmajMFd3XEjDjt5kH9TGEVpLRFnwHabDZ4zl4smarlZyIyBmwa1xxDVhq4Peh4pZhB
	 k0a2VOpdzmv4Xbb/xYUSfyf1WVdk22QmUOELQTUO+mTp6S0yf6dhz3TJbGjQ8RyWVCKo2
	 Iw59fsUnTXpbCyZ1j7C9YE/KQpYfPCG7aP6GIvO6uS7490TyqPvBEM8kk14QV4dJ9ZTZk
	 Zj9XHXS10UoJZAsv4DjUh9WJWcYJ/x3WPD4lpqLO0NdZkbOjF1LlamblFKFae69iWrpUu
	 quMPEUETwUGHAU2x3u6IbEH80oTMRmdfqrcNGl90BsT1hUHg1RwRwxZgpycDAX/W9nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASf5nkRQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798DC606A337;
	Wed, 25 Nov 2026 16:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASf5nkRQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4ED1F000D0;
	Wed, 25 Nov 2026 16:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624821;
	bh=0WRjm08jIRhBNlWx0vhKWLZMscbG09VKdJBRU7SJhj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASf5nkRQRjI/LFn4jRWcMFSkeqqqWqbMhEc1q6F2YT9qsJiFV9/01rw/I8G6NCfMT
	 SqpM3TBqFGdIJZGIlQNjtLirh0BCNQ6ZICJeB33C9pD7IxwvGt6tpxHyHJLpqrkKas
	 r8gc6/ZHQvlV4MTG9BSIKEWy1B/4cz4/DB+d0U9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 316/816] ipvlan: make outbound skb headers writable
Date: Wed, 25 Nov 2026 15:31:04 +0100
Message-ID: <20261125143856.512936254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 268ea41a17d52..fea77f2855e8c 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -425,7 +425,8 @@ static noinline_for_stack int ipvlan_process_v4_outbound(struct sk_buff *skb)
 		.flowi4_mark = skb->mark,
 	};
 
-	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
+	if (!pskb_network_may_pull(skb, sizeof(struct iphdr)) ||
+	    skb_cow_head(skb, 0))
 		goto err;
 
 	ip4h = ip_hdr(skb);
@@ -491,7 +492,8 @@ static int ipvlan_process_v6_outbound(struct sk_buff *skb)
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



