Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA80F4A441D;
	Wed, 30 Sep 2026 17:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790209; cv=none; b=ZDn0Cf27xDaljt78y14mmGgOk4gcyRBjo1sH5rxganGjvdKwyxTNqBCIr8nCSXbfjxsEi1eVU8pdzhI20QAvEefcAxKae5ROrkEg5QEfzA7is2sYqyGdejlayK4/FzXqAsO0PnVhYckMHsgvWjLxiI0KZDkBPo3Oyod/pWWhSVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790209; c=relaxed/simple;
	bh=riTGfvFC9DwjP7kqGQkUIf3Cmz8iGxmRc8HR0fMm1d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6Tg4voXPaUUd24/dGPDOMOTdATtosQ7OpjMfpEaNR3wK3gZyKZIdEm9poJp6ePgxCdHKATJGny9NUDwexW/udgK1Qpv0EkxFzCDqB/fmQKLhaTsf+C0DcZslQaESZg9qLzQXvHt0dEXLXbhSXZAcqrGSIzU0/ndqmontUad5Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSONwmu0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSONwmu0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3681F000FF;
	Wed, 30 Sep 2026 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790207;
	bh=1BQYqAZlt89/+MZt84nvRGQTJxSQxYFmzxTA85Tvols=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSONwmu0oYyQLYlXVWKnhhmre3KbGZvpN+xxvE7vsIxs6OmtGM7kb1NfV8yk4EWxg
	 KY0L6xR5aLY518GKLp3uzZ45r6O4L7B7advc3xrPZY+vpBWtKcbIZPaiWjNgcyW/yH
	 gT++glb0VbBrS5C4MJZsxVRQDCFdnaEO9ztsmgdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 749/877] ipv6: make ipv6_pinfo.saddr_cache a boolean
Date: Wed, 30 Sep 2026 17:27:40 +0200
Message-ID: <20260930152430.858449010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

[ Upstream commit 3fbb2a6f3a70c27a6a2be80d131970608c0f84d0 ]

ipv6_pinfo.saddr_cache is either NULL or &np->saddr.

We do not need 8 bytes, a boolean is enough.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250916160951.541279-2-edumazet@google.com
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 8d6cd1885085 ("ipv6: flowlabel: cap duplicate leases per socket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ipv6.h             |    4 ++--
 include/net/ip6_route.h          |    4 ++--
 net/ipv6/af_inet6.c              |    2 +-
 net/ipv6/inet6_connection_sock.c |    2 +-
 net/ipv6/ip6_output.c            |    3 ++-
 net/ipv6/route.c                 |    4 ++--
 net/ipv6/tcp_ipv6.c              |    4 ++--
 7 files changed, 12 insertions(+), 11 deletions(-)

--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -214,10 +214,10 @@ struct inet6_cork {
 struct ipv6_pinfo {
 	struct in6_addr 	saddr;
 	struct in6_pktinfo	sticky_pktinfo;
-	const struct in6_addr		*daddr_cache;
 #ifdef CONFIG_IPV6_SUBTREES
-	const struct in6_addr		*saddr_cache;
+	bool			saddr_cache;
 #endif
+	const struct in6_addr		*daddr_cache;
 
 	__be32			flow_label;
 	__u32			frag_size;
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -230,7 +230,7 @@ static inline const struct rt6_info *skb
  */
 static inline void ip6_dst_store(struct sock *sk, struct dst_entry *dst,
 				 const struct in6_addr *daddr,
-				 const struct in6_addr *saddr)
+				 bool saddr_set)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 
@@ -238,7 +238,7 @@ static inline void ip6_dst_store(struct
 	sk_setup_caps(sk, dst);
 	np->daddr_cache = daddr;
 #ifdef CONFIG_IPV6_SUBTREES
-	np->saddr_cache = saddr;
+	np->saddr_cache = saddr_set;
 #endif
 }
 
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -856,7 +856,7 @@ int inet6_sk_rebuild_header(struct sock
 			return PTR_ERR(dst);
 		}
 
-		ip6_dst_store(sk, dst, NULL, NULL);
+		ip6_dst_store(sk, dst, NULL, false);
 	}
 
 	return 0;
--- a/net/ipv6/inet6_connection_sock.c
+++ b/net/ipv6/inet6_connection_sock.c
@@ -106,7 +106,7 @@ static struct dst_entry *inet6_csk_route
 		dst = ip6_dst_lookup_flow(sock_net(sk), sk, fl6, final_p);
 
 		if (!IS_ERR(dst))
-			ip6_dst_store(sk, dst, NULL, NULL);
+			ip6_dst_store(sk, dst, NULL, false);
 	}
 	return dst;
 }
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1103,7 +1103,8 @@ static struct dst_entry *ip6_sk_dst_chec
 	 */
 	if (ip6_rt_check(&rt->rt6i_dst, &fl6->daddr, np->daddr_cache) ||
 #ifdef CONFIG_IPV6_SUBTREES
-	    ip6_rt_check(&rt->rt6i_src, &fl6->saddr, np->saddr_cache) ||
+	    ip6_rt_check(&rt->rt6i_src, &fl6->saddr,
+			 np->saddr_cache ? &np->saddr : NULL) ||
 #endif
 	   (fl6->flowi6_oif && fl6->flowi6_oif != dst_dev(dst)->ifindex)) {
 		dst_release(dst);
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3049,9 +3049,9 @@ void ip6_sk_dst_store_flow(struct sock *
 		      &sk->sk_v6_daddr : NULL,
 #ifdef CONFIG_IPV6_SUBTREES
 		      ipv6_addr_equal(&fl6->saddr, &np->saddr) ?
-		      &np->saddr :
+		      true :
 #endif
-		      NULL);
+		      false);
 }
 
 static bool ip6_redirect_nh_match(const struct fib6_result *res,
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -293,7 +293,7 @@ static int tcp_v6_connect(struct sock *s
 	inet->inet_rcv_saddr = LOOPBACK4_IPV6;
 
 	sk->sk_gso_type = SKB_GSO_TCPV6;
-	ip6_dst_store(sk, dst, NULL, NULL);
+	ip6_dst_store(sk, dst, NULL, false);
 
 	icsk->icsk_ext_hdr_len = 0;
 	if (opt)
@@ -1435,7 +1435,7 @@ static struct sock *tcp_v6_syn_recv_sock
 
 	memcpy(newnp, np, sizeof(struct ipv6_pinfo));
 
-	ip6_dst_store(newsk, dst, NULL, NULL);
+	ip6_dst_store(newsk, dst, NULL, false);
 
 	newsk->sk_v6_daddr = ireq->ir_v6_rmt_addr;
 	newnp->saddr = ireq->ir_v6_loc_addr;


