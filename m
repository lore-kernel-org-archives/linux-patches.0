Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA91557267E;
	Wed,  9 Sep 2026 14:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964732; cv=none; b=DtQkIa7fXfTqYVHM2ohrQvxalp4EVWd9+2GEYKmAXHiMUmnUe8t7ZUh2st6WN3Xp9ccZizT5HxRIuh2D6QZQ6k5Eby2XIfXx5ffupGwj8wmRJSeQqChZMYOBYQWbI71BcABuizvBlJ5w1LSedV7I1FjDStOVNC4c+VAVHS9XNx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964732; c=relaxed/simple;
	bh=IMo61MvCnU36Zb7/nC+lCbk6fUn6YMPNVaYEx+TV+T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNB3QlQwezPzlZN/rAuJ/WAwLjPhKPKMSBatW5HBJX52ygzw4lagmKKvCHIT5FuGZ8kIHFDIpgxDNTDal/WmCx4oj+BzVo4ne9Jj0IdkFQ8i+6+WZC0PkuY0aM/0Uy+A93TDzxjTS1Y0yM8juh6svIeo9HMZmllPbhPHmmrADWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVN4UjVW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVN4UjVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7541F00A3A;
	Wed,  9 Sep 2026 14:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964731;
	bh=lONiGVCyk728GKwHkoSauL6UyMyGKZU0yhNvKVO0lM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UVN4UjVW+poX6YFr/AKtFEOxQWjQh0md1DR9UJi7umSFM35CinBHA38NOInRjQREb
	 9SN1LN9g/GUw1n2oUOvPWjvvLlLBZ47ZxsPta7XZiL0a4Rp9axfKGg0V+ciEuRDtxJ
	 C2LglpitJls7yOm6+xoSkq9SvaYAm9H1530vQdg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 525/583] ipv4: use dst4_mtu() instead of dst_mtu()
Date: Wed,  9 Sep 2026 15:43:30 +0200
Message-ID: <20260909134255.886409375@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fe8570186f100b6cc499b2f7705946baf1388cde ]

When we expect an IPv4 dst, use dst4_mtu() instead of dst_mtu()
to save some code space.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260130210303.3888261-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 870a9e42ecc6 ("tcp: clamp route advmss to TCP_MIN_MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c                     |    2 +-
 net/ipv4/ip_output.c                |    4 ++--
 net/ipv4/ip_sockglue.c              |    2 +-
 net/ipv4/ipmr.c                     |    2 +-
 net/ipv4/netfilter/nf_reject_ipv4.c |    2 +-
 net/ipv4/tcp_ipv4.c                 |   13 ++++++-------
 net/ipv6/sit.c                      |    2 +-
 7 files changed, 13 insertions(+), 14 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -790,7 +790,7 @@ void __icmp_send(struct sk_buff *skb_in,
 
 	/* RFC says return as much as we can without exceeding 576 bytes. */
 
-	room = dst_mtu(&rt->dst);
+	room = dst4_mtu(&rt->dst);
 	if (room > 576)
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1303,7 +1303,7 @@ static int ip_setup_cork(struct sock *sk
 		return -EFAULT;
 
 	cork->fragsize = ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+			 dst4_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
 
 	if (!inetdev_valid_mtu(cork->fragsize))
 		return -ENETUNREACH;
@@ -1442,7 +1442,7 @@ struct sk_buff *__ip_make_skb(struct soc
 	pmtudisc = READ_ONCE(inet->pmtudisc);
 	if (pmtudisc == IP_PMTUDISC_DO ||
 	    pmtudisc == IP_PMTUDISC_PROBE ||
-	    (skb->len <= dst_mtu(&rt->dst) &&
+	    (skb->len <= dst4_mtu(&rt->dst) &&
 	     ip_dont_fragment(sk, &rt->dst)))
 		df = htons(IP_DF);
 
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -1634,7 +1634,7 @@ int do_ip_getsockopt(struct sock *sk, in
 		val = 0;
 		dst = sk_dst_get(sk);
 		if (dst) {
-			val = dst_mtu(dst);
+			val = dst4_mtu(dst);
 			dst_release(dst);
 		}
 		if (!val)
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1895,7 +1895,7 @@ static int ipmr_prepare_xmit(struct net
 			return -1;
 	}
 
-	if (skb->len+encap > dst_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
+	if (skb->len+encap > dst4_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
 		/* Do not fragment multicasts. Alas, IPv4 does not
 		 * allow to send ICMP, so that packets will disappear
 		 * to blackhole.
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -303,7 +303,7 @@ void nf_send_reset(struct net *net, stru
 		goto free_nskb;
 
 	/* "Never happens" */
-	if (nskb->len > dst_mtu(skb_dst(nskb)))
+	if (nskb->len > dst4_mtu(skb_dst(nskb)))
 		goto free_nskb;
 
 	nf_ct_attach(nskb, oldskb);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -373,7 +373,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct dst_entry *dst;
-	u32 mtu;
+	u32 mtu, dmtu;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
@@ -385,15 +385,14 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 	/* Something is about to be wrong... Remember soft error
 	 * for the case, if this connection will not able to recover.
 	 */
-	if (mtu < dst_mtu(dst) && ip_dont_fragment(sk, dst))
+	dmtu = dst4_mtu(dst);
+	if (mtu < dmtu && ip_dont_fragment(sk, dst))
 		WRITE_ONCE(sk->sk_err_soft, EMSGSIZE);
 
-	mtu = dst_mtu(dst);
-
 	if (inet->pmtudisc != IP_PMTUDISC_DONT &&
 	    ip_sk_accept_pmtu(sk) &&
-	    inet_csk(sk)->icsk_pmtu_cookie > mtu) {
-		tcp_sync_mss(sk, mtu);
+	    inet_csk(sk)->icsk_pmtu_cookie > dmtu) {
+		tcp_sync_mss(sk, dmtu);
 
 		/* Resend the TCP packet because it's
 		 * clear that the old packet has been
@@ -1817,7 +1816,7 @@ struct sock *tcp_v4_syn_recv_sock(const
 #endif
 	tcp_ca_openreq_child(newsk, dst);
 
-	tcp_sync_mss(newsk, dst_mtu(dst));
+	tcp_sync_mss(newsk, dst4_mtu(dst));
 	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -963,7 +963,7 @@ static netdev_tx_t ipip6_tunnel_xmit(str
 	iph6 = ipv6_hdr(skb);
 
 	if (df) {
-		mtu = dst_mtu(&rt->dst) - t_hlen;
+		mtu = dst4_mtu(&rt->dst) - t_hlen;
 
 		if (mtu < IPV4_MIN_MTU) {
 			DEV_STATS_INC(dev, collisions);


