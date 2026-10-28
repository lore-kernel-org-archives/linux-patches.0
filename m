Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216340;
	b=v5JexCoaEHlySx9PJ1HDvJ8r3F7W5cRtgNSX82JDhAfVst8LSmLkHLRwr+I5IxA5Ql9P
	 BwU0oSkTbED8LmclO2C8GrzqEAM0XC+OnTG2svH1e2jD/Dav6EAKVgnVIxMsfCN/XPXlf
	 KLZdUejKZkj1K7C2Pjr1GNA7yjPht//8OBdOOiQgGV8ECOiIfnGjdfDdYbwmVwXLwMdix
	 pxBjq/RT93KqoSQ2d16rLrMmyBQise5POXAFB11BFVno7fxtGwXGJKRp1ix1AEbLJ3uOo
	 C1BKA1OqxZhYTUq4ADe3XcVYGgw0X/IpHCUGcOB58qI0C/7kTHLzMDEFLFY769Dz3oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R0NQlPLBrt+sFEbPjaKy93dxgblJjXqkI/3CjGZE9II=;
	b=hTIfptAEuEYWX61FqseXW2AAt4fhFpuOl+tCz1xLQPXogRv5we8Uc73QpDO2Sj8xPO/0
	 68AoExkZ93uepqtIHnC4XZLGJBxD+no2ABWG4XZFwS9XsjIvXU33pa0njJBdlp0TxaP3Y
	 seyk6Wdt3aTlja1GBSlkeIelCzPNIBo6jH9pCgTzA1VZx8mbruSz5VBSrV84tqMi/l0qS
	 wHRMzwCBjR4MOnxfmTfs0JvLG4VZ0oyRmSSuFdIz/bSQYQCJMv7QsdnL3sOG9Lc0XIF/v
	 s9J9BFKdb0VDVJVAQFMTrpCUEJw1K33b9DnXhJerMe3339i32AhnSSwxIYb1Zhsa6jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHU1CI0H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9833D606A31C;
	Wed, 28 Oct 2026 19:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHU1CI0H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F991F01825;
	Wed, 28 Oct 2026 19:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216339;
	bh=R0NQlPLBrt+sFEbPjaKy93dxgblJjXqkI/3CjGZE9II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHU1CI0HNb0+VURwC0aYoY3gSo/pA+GtygmepiuLO9rv98iSUxCfBjPBb2WPuSNGp
	 /SG3g2647k9+fmyJe43QljybeFfqOZo5OKnKonnBvTA5kQf364KovgoRXRK8G23Fg9
	 Fe6Zgd90haEcZSY/pOS/foSzeZFDA+DXAZCqZglk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1524/1887] ip6mr: do not clone dst in ip6mr_cache_report()
Date: Wed, 28 Oct 2026 18:00:20 +0100
Message-ID: <20261028170534.144353066@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 235b42b5860189eb8c27c36435ad932cae65a734 ]

IPv6 input attaches a non-refcounted (NOREF) dst to skbs under RCU.
When an ingress multicast packet misses MFC lookup,
ip6mr_cache_unresolved() places the skb onto the unresolved queue,
escaping the receive-side RCU grace period.

If the underlying route is deleted and freed, and the MFC queue is later
resolved with a wrong parent interface, ip6_mr_forward() invokes
ip6mr_cache_report(..., MRT6MSG_WRONGMIF), which executes
dst_clone(skb_dst(pkt)) on the freed dst entry, triggering a slab
use-after-free.

Report packets queued to mroute6_sk (a raw socket) and netlink
notifications do not require an attached dst entry.

Fix this by:
1. Removing dst_clone() in ip6mr_cache_report() and ensuring report skbs
   do not hold a dst.
2. Dropping skb_dst before queuing unresolved skbs in
   ip6mr_cache_unresolved(), matching the fact that multicast
   forwarding resolves outgoing routes anew via ip6_route_output().

Fixes: 67f415dd2906 ("ipv6: convert rx data path to not take refcnt on dst")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Link: https://patch.msgid.link/20260818172755.4083692-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 944097e9d9873..b677f48179c87 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1128,7 +1128,6 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 	msg->im6_src = ipv6_hdr(pkt)->saddr;
 	msg->im6_dst = ipv6_hdr(pkt)->daddr;
 
-	skb_dst_set(skb, dst_clone(skb_dst(pkt)));
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 	}
 
@@ -1138,6 +1137,7 @@ static int ip6mr_cache_report(const struct mr_table *mrt, struct sk_buff *pkt,
 		return -EINVAL;
 	}
 
+	skb_dst_drop(skb);
 	mrt6msg_netlink_event(mrt, skb);
 
 	/* Deliver to user space multicast routing algorithms */
@@ -1217,6 +1217,7 @@ static int ip6mr_cache_unresolved(struct mr_table *mrt, mifi_t mifi,
 			skb->dev = dev;
 			skb->skb_iif = dev->ifindex;
 		}
+		skb_dst_drop(skb);
 		skb_queue_tail(&c->_c.mfc_un.unres.unresolved, skb);
 		err = 0;
 	}
-- 
2.53.0



