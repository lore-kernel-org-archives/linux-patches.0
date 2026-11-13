Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590621;
	b=w8E0Yd5nxJGYyyYj/wtWc6TV/WpFLhp5DfTfyMrljePeFsS9DGkenJ1reKL6FJMcSw9H
	 idwfwj/JShz08llsGzBxfSl9I+sSbmg3MomTDSidpzaPJnoImtuJReCwTWmXp077FTRwG
	 4+idX+r16cB7qpvos19wxdBrxRPq2OjvcU1beAIE2EeGy7I4B6Io3E2NiqWSfVgNjsYHp
	 +mxKY49ItZBurRZTlJqL0cdeq7qfD3z9u0YcCszT2aOTHy+VZjvG81I2Pk+L1EKLFOTGY
	 fIerAIM0b+iVWXex0UT47hJsXV+u3j78nmlHhddpDnyXGXBvZxOz/CMDYuE28Tv2h3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590621;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3bM61dkHkOYew2Q56B2keOXpRUbSSaFv//Eys63GPiM=;
	b=E95ttMHLr9yRcSG4BWSdrXWHoYprn1sbAQcqeKhxFZI9tl8ZBHrKWIfqrT6V2jFnRvxU
	 3GZiMBq8yhGdv1CirO3KPSRKzGwB9Z6mwslK782Gm8o64ubAYFcw/mvGlrwxwjVmGJ2vx
	 h20b9U7WX0KauReYWw7Pw1/tnebpAYPF8PAJ5fXu41tZC2jQH+/U7JdklPP68LuEu2cDC
	 xiT+8nnq867nwDxr7+CGYT5v+gBHmg/uLX/wgFgywc9Ndeg3z+syTi0t3DuviV9SrGVzR
	 Zs4+9xjU27qPclRs9RURXkFo4ACCuPruOQVJ8BcKj62LoSzyM0KleTaOCkD/fFX1RsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emj84V+M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33528607586F;
	Fri, 13 Nov 2026 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=emj84V+M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F131F000C6;
	Fri, 13 Nov 2026 17:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590621;
	bh=3bM61dkHkOYew2Q56B2keOXpRUbSSaFv//Eys63GPiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emj84V+MR1tZrKiMcWtjsHVa1yXVpbgT4PXTnQCitqTcuVBdOKg5miXXeYzKvbBWq
	 zqFywoQx3VTdhoKyG8Eg+P8Xo1WpPA4g1funU1WulmKDQhmE3hYn438LkJdIz89XPV
	 rKHk7Y9jsVgGcC8SkHRVgUnaXmjYAjanFmt/cd4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 545/686] ipmr: only copy pktinfo to cache reports
Date: Fri, 13 Nov 2026 10:51:18 -0500
Message-ID: <20261113153839.969616178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 94a6736bb5abe6b2ef38490d0cab19c1c6a7c71f ]

ipmr_cache_report() prepares IP_PKTINFO on the original skb. The
ipv4_pktinfo_prepare() helper updates skb->cb and clears the pktinfo fields
when packet info is disabled. Since the skb can continue through the data
path, preserve and restore its original control block around the helper.

The original implementation copies the entire control block to the report
skb. For synthetic RTM_GETROUTE packets, NETLINK_CB data is interpreted as
IPCB by the raw IPv4 receive path. With IP_RECVOPTS or IP_RETOPTS enabled,
corrupted option offsets cause out-of-bounds reads or a stack buffer
overflow. WHOLEPKT and WRVIFWHOLE reports also inherit stale IP option
offsets when their header is prepended.

Clear the report skb control block. Only prepare and copy pktinfo when the
input skb has an IPv4 header. Synthetic route-query skbs use NETLINK_CB,
not IPCB, so leave their report control block zeroed. Restore pkt->cb after
preparing pktinfo for regular IPv4 packets.

Fixes: bb7403655b3c ("ipmr: support IP_PKTINFO on cache report IGMP msg")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Link: https://lore.kernel.org/netdev/20260903113055.GA90787@shredder/
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/0545f0c83f5ee2f6696210f87268e811ef655715.1792476357.git.zhilinz@nebusec.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index cd587d84f388e..5133fd14029e2 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1055,6 +1055,7 @@ static void ipmr_cache_resolve(struct net *net, struct mr_table *mrt,
 static int ipmr_cache_report(const struct mr_table *mrt,
 			     struct sk_buff *pkt, vifi_t vifi, int assert)
 {
+	unsigned char pkt_cb[sizeof(pkt->cb)];
 	const int ihl = ip_hdrlen(pkt);
 	struct sock *mroute_sk;
 	struct igmphdr *igmp;
@@ -1110,8 +1111,6 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		msg = (struct igmpmsg *)skb_network_header(skb);
 		msg->im_vif = vifi;
 		msg->im_vif_hi = vifi >> 8;
-		ipv4_pktinfo_prepare(mroute_sk, pkt, false);
-		memcpy(skb->cb, pkt->cb, sizeof(skb->cb));
 		/* Add our header.
 		 * Note that code, csum and group fields are cleared.
 		 */
@@ -1122,6 +1121,15 @@ static int ipmr_cache_report(const struct mr_table *mrt,
 		skb->transport_header = skb->network_header;
 	}
 
+	memset(skb->cb, 0, sizeof(skb->cb));
+	/* Route queries from ipmr_get_route() carry NETLINK_CB, not IPCB. */
+	if (ip_hdr(pkt)->version) {
+		memcpy(pkt_cb, pkt->cb, sizeof(pkt_cb));
+		ipv4_pktinfo_prepare(mroute_sk, pkt, false);
+		*PKTINFO_SKB_CB(skb) = *PKTINFO_SKB_CB(pkt);
+		memcpy(pkt->cb, pkt_cb, sizeof(pkt_cb));
+	}
+
 	igmpmsg_netlink_event(mrt, skb);
 
 	/* Deliver to mrouted */
-- 
2.53.0



