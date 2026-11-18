Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025627;
	b=kvHsVzOpyj9B1uqM1HUjPE3kQyq1IqoYkWJ+uy5EKK9mt11JJYLq+yIe18cMr2W+RZ2D
	 aQ2/yDbFZboAlmUf4fHcVQY28budANa+2ZBaIX2Aa9oaW7yfrDYhenm128fnCscKb0OSA
	 NVUT7sXaaSeF5Py54cgFcpI6j2PxQTCXbrJAL8EPb/i7NZrqNz+rrgNs51p0ptSPQh9L4
	 QWkxG97S+pY+K1BnnTbnqzN1q6GtdwZGSBNnNo3KEz0eRkFivKlnPj8FzpEa4v1fYpvKc
	 JvjFvcEL/nPwX8X7GIjhvRrJo/DFVczNkH0DbNwNtTQlOnF8ksRav+dVDJfx6feKpEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025627;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JwrqRm2AaJ073at3GwlemOOUlSIaAlvDdKBo3g7zeJY=;
	b=KDq+7k0Gv2TPqZ5fE88NoU0k9La6ZwJB2LxBUWHRjIQHFVl5qRqyCaAt4lYZFZLLOXem
	 ULVawZF5CSYr5BCZD+e1q0+j3oDzaZCRocn70TTICKxEmT8pK8qfqd5tAhW5+PjPDg2Yw
	 ffthWcvqcBk0/mIgBeeAOZFJ3zo8wAKHVPEFAiFNOEAFtEPvZcB0V6bYcYFZJE7iORBB4
	 Xak4h3yEGZMG5I5nhJBwQvqBMtJNnnDdqRBcfrHnhTjrZLM7lBdu+nES8SdM+KGJhWP1q
	 0hbj5/r29zPyhAS3o2DCPIV666Ee2Cm1DV7yfJ3DRwBpA70WCQXMIMLlaryLkckzGTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1cJyDK7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453EE606A31C;
	Wed, 18 Nov 2026 18:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B1cJyDK7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 935BE1F000C4;
	Wed, 18 Nov 2026 18:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025627;
	bh=JwrqRm2AaJ073at3GwlemOOUlSIaAlvDdKBo3g7zeJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B1cJyDK7iOa1fgK1gLzci7gpemnbAKCxbY1yywnmv4nyo52dhYdFwRMUwZ2WevmOb
	 qxV6wdG4XgG2GqYKUQFWCXuCzom6+XaUi6qz8AOgFlLieVVh0bVcZmWZxUbEIWoukO
	 gNU6/J3K50Zw/VTTVmBl64zBCAAvwbmCvmLR1GCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1145/2151] tcp: populate inet->cork.fl.u.ip6 in tcp_v6_connect()
Date: Wed, 18 Nov 2026 15:48:00 +0100
Message-ID: <20261118150203.900432304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 19bdb267f733ac92dcf5cf126bfcec1f9281c8c5 ]

Instead of using private @fl6 and @final variables
use respectively inet->cork.fl.u.ip6 and np->final.

As explained in commit 85d05e281712 ("ipv6: change inet6_sk_rebuild_header()
to use inet->cork.fl.u.ip6"):

TCP v6 spends a good amount of time rebuilding a fresh fl6 at each
transmit in inet6_csk_xmit()/inet6_csk_route_socket().

TCP v4 caches the information in inet->cork.fl.u.ip4 instead.

After this patch, active TCP ipv6 flows have correctly initialized
inet->cork.fl.u.ip6 structure.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260206173426.1638518-6-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 86a19284425f ("net: psp: require an established connection for association setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 47 +++++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 761cafdc8d2e8..022e67db27198 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -136,15 +136,15 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 {
 	struct sockaddr_in6 *usin = (struct sockaddr_in6 *) uaddr;
 	struct inet_connection_sock *icsk = inet_csk(sk);
-	struct in6_addr *saddr = NULL, *final_p, final;
 	struct inet_timewait_death_row *tcp_death_row;
 	struct ipv6_pinfo *np = tcp_inet6_sk(sk);
+	struct in6_addr *saddr = NULL, *final_p;
 	struct inet_sock *inet = inet_sk(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct net *net = sock_net(sk);
 	struct ipv6_txoptions *opt;
 	struct dst_entry *dst;
-	struct flowi6 fl6;
+	struct flowi6 *fl6;
 	int addr_type;
 	int err;
 
@@ -154,14 +154,15 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	if (usin->sin6_family != AF_INET6)
 		return -EAFNOSUPPORT;
 
-	memset(&fl6, 0, sizeof(fl6));
+	fl6 = &inet_sk(sk)->cork.fl.u.ip6;
+	memset(fl6, 0, sizeof(*fl6));
 
 	if (inet6_test_bit(SNDFLOW, sk)) {
-		fl6.flowlabel = usin->sin6_flowinfo&IPV6_FLOWINFO_MASK;
-		IP6_ECN_flow_init(fl6.flowlabel);
-		if (fl6.flowlabel&IPV6_FLOWLABEL_MASK) {
+		fl6->flowlabel = usin->sin6_flowinfo & IPV6_FLOWINFO_MASK;
+		IP6_ECN_flow_init(fl6->flowlabel);
+		if (fl6->flowlabel & IPV6_FLOWLABEL_MASK) {
 			struct ip6_flowlabel *flowlabel;
-			flowlabel = fl6_sock_lookup(sk, fl6.flowlabel);
+			flowlabel = fl6_sock_lookup(sk, fl6->flowlabel);
 			if (IS_ERR(flowlabel))
 				return -EINVAL;
 			fl6_sock_release(flowlabel);
@@ -210,7 +211,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	}
 
 	sk->sk_v6_daddr = usin->sin6_addr;
-	np->flow_label = fl6.flowlabel;
+	np->flow_label = fl6->flowlabel;
 
 	/*
 	 *	TCP over IPv4
@@ -258,24 +259,24 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	if (!ipv6_addr_any(&sk->sk_v6_rcv_saddr))
 		saddr = &sk->sk_v6_rcv_saddr;
 
-	fl6.flowi6_proto = IPPROTO_TCP;
-	fl6.daddr = sk->sk_v6_daddr;
-	fl6.saddr = saddr ? *saddr : np->saddr;
-	fl6.flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
-	fl6.flowi6_oif = sk->sk_bound_dev_if;
-	fl6.flowi6_mark = sk->sk_mark;
-	fl6.fl6_dport = usin->sin6_port;
-	fl6.fl6_sport = inet->inet_sport;
-	if (IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) && !fl6.fl6_sport)
-		fl6.flowi6_flags = FLOWI_FLAG_ANY_SPORT;
-	fl6.flowi6_uid = sk_uid(sk);
+	fl6->flowi6_proto = IPPROTO_TCP;
+	fl6->daddr = sk->sk_v6_daddr;
+	fl6->saddr = saddr ? *saddr : np->saddr;
+	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
+	fl6->flowi6_oif = sk->sk_bound_dev_if;
+	fl6->flowi6_mark = sk->sk_mark;
+	fl6->fl6_dport = usin->sin6_port;
+	fl6->fl6_sport = inet->inet_sport;
+	if (IS_ENABLED(CONFIG_IP_ROUTE_MULTIPATH) && !fl6->fl6_sport)
+		fl6->flowi6_flags = FLOWI_FLAG_ANY_SPORT;
+	fl6->flowi6_uid = sk_uid(sk);
 
 	opt = rcu_dereference_protected(np->opt, lockdep_sock_is_held(sk));
-	final_p = fl6_update_dst(&fl6, opt, &final);
+	final_p = fl6_update_dst(fl6, opt, &np->final);
 
-	security_sk_classify_flow(sk, flowi6_to_flowi_common(&fl6));
+	security_sk_classify_flow(sk, flowi6_to_flowi_common(fl6));
 
-	dst = ip6_dst_lookup_flow(net, sk, &fl6, final_p);
+	dst = ip6_dst_lookup_flow(net, sk, fl6, final_p);
 	if (IS_ERR(dst)) {
 		err = PTR_ERR(dst);
 		goto failure;
@@ -285,7 +286,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	tcp_death_row = &sock_net(sk)->ipv4.tcp_death_row;
 
 	if (!saddr) {
-		saddr = &fl6.saddr;
+		saddr = &fl6->saddr;
 
 		err = inet_bhash2_update_saddr(sk, saddr, AF_INET6);
 		if (err)
-- 
2.53.0



