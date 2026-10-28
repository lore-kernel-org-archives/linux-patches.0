Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215677;
	b=4jt5jGWjQd9Zl5iipq+EHsVPDFrYanki5MVhNgAWVz5pp1PCkBR35zEWDf5uviMI19mF
	 hg6+2lDsJY9qQrpwxc7PQsE2u8VhVdQ/a5PnvlG9FlY1JhIeGYG59QGoVMVOnreZwJg+w
	 04gyfBgr+nrVmWdh0v3JVqSuckJZ/m44wnQ9U8VNFFUy0DWbi6s5HUAqDNW35t4ZukQ9k
	 /OQ2PEE631O3Fne0oWQBaRFhhIM+NI+2ISqOoi61+4t49M6i4C+Msq+a7CDX0jWbRiuuI
	 WTSiffQGDs8Sn2FRGTBpVMHck8z9u/bpyubBhlRFItPtAFWmWYBkulQkH3140HcqCwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GhVUEtIiZhbofSOAQcqAGNo1RXuoGulH5RseFb5RfTc=;
	b=zjWgW2GoTxMPwsTRfRZIJFY3elyuGpt5EXtlpkXYmjsycM1zHpiDdrIVuRzwxZUndKtR
	 yjHz5kCKVDTbM173KDMz8GYBygMpQQZEMk+lJ6TggSlldEiWmdMnHP61TwIFe6c9L/sFg
	 3qbaRJeYsHZuh3R+uVk0HXdmHv5dvNZA59aHBiib+T7fhPs8EdUn//a3cnS5oDMgiG+ds
	 edVEoY2hPkGfk/9EGWjRVWGtMRNSus6zJZDTxuOAuHBRBgq2nyKzmOPdUg4zTKsTLgZdq
	 +5FiKuQ4y9ix9dbezouCI8Nn75/lW1dqQDMF0G6sxGd9XCMUHu2Z69nAdMlirOyI4mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxPdsajV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8411E606A31C;
	Wed, 28 Oct 2026 19:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UxPdsajV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B621F01825;
	Wed, 28 Oct 2026 19:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215677;
	bh=GhVUEtIiZhbofSOAQcqAGNo1RXuoGulH5RseFb5RfTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UxPdsajVu4o9p8c/r29M2qvwIe2/rkzmGdGSvE2/xUYm6zhzKOEI1ISdXKhEsvIuw
	 skjVWxCTBVKX1i4kdi1QUDbLGXXrPXquSVCsGj2nCHY0lW374uehCNn1X34ejWpZoV
	 zS24HYV0mSLYRYeSE9hfZiJ1gJ0ezo6GlNcjZDyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1294/1887] netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()
Date: Wed, 28 Oct 2026 17:56:30 +0100
Message-ID: <20261028170528.871901648@linuxfoundation.org>
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

[ Upstream commit 8aecf0bbcc72605592134c917c222207d8f63ab0 ]

Incoming skbs passing through netfilter flowtable offload hooks (or XFRM
offload path) might already carry a ref-counted dst_entry assigned during
earlier RX or routing steps.

Calling skb_dst_set_noref() when skb already holds a ref-counted dst
overwrites skb->_skb_refdst, leaking the previous dst_entry reference
count and triggering a DEBUG_NET_WARN_ON_ONCE assertion in
skb_dst_check_unset():

  WARNING: at skb_dst_check_unset include/linux/skbuff.h:1170
  WARNING: at skb_dst_set_noref include/linux/skbuff.h:1234
  WARNING: at nf_flow_offload_ip_hook+0xf6c/0x2b60 net/netfilter/nf_flow_table_ip.c:864

Drop any existing dst_entry reference with skb_dst_drop(skb) before
setting the non-referenced flowtable destination.

Fixes: 2a79fd3908ac ("netfilter: nf_flow_table: attach dst to skbs")
Reported-by: syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a71b141.9511d2ce.1fc5b9.033b.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20260804093328.1831847-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_ip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 523228e969ab4..cd744ac065cd0 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -262,6 +262,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 				      struct dst_entry *dst)
 {
 	skb_orphan(skb);
+	skb_dst_drop(skb);
 	skb_dst_set_noref(skb, dst);
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
@@ -417,6 +418,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		outdev = rt->dst.dev;
 		skb->dev = outdev;
 		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
 		ret = NF_STOLEN;
@@ -678,6 +680,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 		outdev = rt->dst.dev;
 		skb->dev = outdev;
 		nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 		neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
 		ret = NF_STOLEN;
-- 
2.53.0



