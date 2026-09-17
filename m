Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF473DB339;
	Thu, 17 Sep 2026 18:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671529; cv=none; b=DoyqTQocjsqMrhAq2GBZHKkZyGyEjB3pFLMZQerepmD0vhJ/IROtC/FKBr4wBbTN4S28tFTgaHtSXvNCVf9dF6AOCSdgBJY5wNDkHfGpthWJsRrTQVIHo2GcG6Z5UV6WXF3oZkWCdN2nSgJvAGD2rm982A/kMWjYg+98zL0RrRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671529; c=relaxed/simple;
	bh=KAOiMMaJYR2OLZDq2w4ff5o5uPLAz7PoFxAMpLUWNd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqfjHxcMxwqgQQyhozD2YWM21xHHnLfGE2XgXOTCwe14wLXXD0hWkrktTqM+eLYgPVjWoZxLKRuZxFTHOC67gfDNakIB6FvHiiXb08x2fI10C7Ub94Wr2BK2WjBR2H9T72XbJ0b9FeXSiYJkvDNRxUdN1meeXVj7OU30WSpxQvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXCJU+Zq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXCJU+Zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556961F000FF;
	Thu, 17 Sep 2026 18:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671527;
	bh=alWEjj4DOF+XfJbzTsTavSnnX6a37/SlNcmeY9kvFRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rXCJU+ZqFWgOjJjtMjta/s4pnmBonr1ED+lDG3kpRWzAV4N3k2BlRPsP70fzOk1Kp
	 HKsZ9/gZapWr+1uIgRS6U7vaImeMX2xs63kocLWOXJ8uFw0+hZb6brdT0J/EhclveY
	 CJnt7hlYS3dL2/KJVh2G9bW1HAOFPsL3Sx87aCkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0968/1102] ipv4: use dst4_mtu() instead of dst_mtu()
Date: Thu, 17 Sep 2026 16:15:11 +0100
Message-ID: <20260917151604.983635839@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -789,7 +789,7 @@ void __icmp_send(struct sk_buff *skb_in,
 
 	/* RFC says return as much as we can without exceeding 576 bytes. */
 
-	room = dst_mtu(&rt->dst);
+	room = dst4_mtu(&rt->dst);
 	if (room > 576)
 		room = 576;
 	room -= sizeof(struct iphdr) + icmp_param.replyopts.opt.opt.optlen;
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1305,7 +1305,7 @@ static int ip_setup_cork(struct sock *sk
 		return -EFAULT;
 
 	cork->fragsize = ip_sk_use_pmtu(sk) ?
-			 dst_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
+			 dst4_mtu(&rt->dst) : READ_ONCE(rt->dst.dev->mtu);
 
 	if (!inetdev_valid_mtu(cork->fragsize))
 		return -ENETUNREACH;
@@ -1440,7 +1440,7 @@ struct sk_buff *__ip_make_skb(struct soc
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
@@ -1896,7 +1896,7 @@ static void ipmr_queue_xmit(struct net *
 
 	dev = dst_dev_rcu(&rt->dst);
 
-	if (skb->len+encap > dst_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
+	if (skb->len+encap > dst4_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
 		/* Do not fragment multicasts. Alas, IPv4 does not
 		 * allow to send ICMP, so that packets will disappear
 		 * to blackhole.
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -296,7 +296,7 @@ void nf_send_reset(struct net *net, stru
 		goto free_nskb;
 
 	/* "Never happens" */
-	if (nskb->len > dst_mtu(skb_dst(nskb)))
+	if (nskb->len > dst4_mtu(skb_dst(nskb)))
 		goto free_nskb;
 
 	nf_ct_attach(nskb, oldskb);
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -367,7 +367,7 @@ void tcp_v4_mtu_reduced(struct sock *sk)
 {
 	struct inet_sock *inet = inet_sk(sk);
 	struct dst_entry *dst;
-	u32 mtu;
+	u32 mtu, dmtu;
 
 	if ((1 << sk->sk_state) & (TCPF_LISTEN | TCPF_CLOSE))
 		return;
@@ -379,15 +379,14 @@ void tcp_v4_mtu_reduced(struct sock *sk)
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
@@ -1806,7 +1805,7 @@ struct sock *tcp_v4_syn_recv_sock(const
 #endif
 	tcp_ca_openreq_child(newsk, dst);
 
-	tcp_sync_mss(newsk, dst_mtu(dst));
+	tcp_sync_mss(newsk, dst4_mtu(dst));
 	newtp->advmss = tcp_mss_clamp(tcp_sk(sk), dst_metric_advmss(dst));
 
 	tcp_initialize_rcv_mss(newsk);
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -971,7 +971,7 @@ static netdev_tx_t ipip6_tunnel_xmit(str
 	iph6 = ipv6_hdr(skb);
 
 	if (df) {
-		mtu = dst_mtu(&rt->dst) - t_hlen;
+		mtu = dst4_mtu(&rt->dst) - t_hlen;
 
 		if (mtu < IPV4_MIN_MTU) {
 			DEV_STATS_INC(dev, collisions);


