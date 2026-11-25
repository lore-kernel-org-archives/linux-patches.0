Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619581;
	b=E1bJtgJKRxCRHBU8U+Kz3jsGJTdsKGXgWQeXATIc+1hhV2I9LvrBQw0wX1xsqBG7B1sq
	 mXl0xiIAFo7Nj8cCOH5j9fqp6l6iXeG7W4Birnf1RfTNejVUIIyNTtGIa5IHkd3Yp9D/N
	 GLB1XH33fWreLwKG/uVYeCknWVBM8mKW4Zy7EW9cU3GzyhmSecZ463LKfgBQMnenEujyT
	 6e4IOnsc8nIzLUO38e2Be6NEi4s+28x+upXDwLddZOnOo5puw75ZTaJAzsAAfHSpvmtqf
	 cstqcyuuljvMxsvDC/Aq+brk3A9ES2HMhEzO26o/ZO5DrUVT7hbszs+55qQq6FCvFjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619581;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JkaN6o63N/fMcCvO1SLf9F+dVq/NdCuniLZIZ/rHW0Q=;
	b=2V3wPkScNguyImLXbgY1aVInaHVsY/z72W1ocRYq2WMHTourOC/6AYIdFD2OgoiI9TzY
	 vyHbIyTqPYeqLYN8JFBg029nOn8i89eeYA/cNGAMX28gRg/xd3mtw9Q6TDvSA6zrUioeR
	 BzPMLIACYlIAk2P/5oqBSS9DwLsdVc4K46j1R9stckDlQwRHskVHoSyX4v+I45ybwipA2
	 nvRcE7SJLycFBXCCYFOKz1/L/gLwSUSwC24Gagf3sj3GYbvh86I5m20qpgCF147SpKA5P
	 PS5tOE1jCpAIVNanoNdSNEytYub0YlV83FhOg4uWXaIVKuJS0fyrFVIBHihM4kA1lyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sb5ampf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3A1606A323;
	Wed, 25 Nov 2026 15:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sb5ampf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4291F000C0;
	Wed, 25 Nov 2026 15:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619581;
	bh=JkaN6o63N/fMcCvO1SLf9F+dVq/NdCuniLZIZ/rHW0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sb5ampf9wImFPyUbB+jP6Dv6OvsWvJ+BWyui/EhngCUVgME3fUOHBI/LDVeUnYiVY
	 ctyZDr9i+rKLnq6pZ9rCHiqF0BdojYE18v/IX8YWB4CGGtOuICHKXuxPv5ImuJ3rJX
	 Lj/PRpqr9tB9sNg7Cg/BDG1Hd4PLt92h4J3B7Wck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <x-professor@outlook.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0641/1005] tcp: free saved_syn after an RCU grace period
Date: Wed, 25 Nov 2026 15:32:59 +0100
Message-ID: <20261125143836.768832782@linuxfoundation.org>
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

From: Yingjie Wang <x-professor@outlook.com>

commit 2b9fd1a0abf0c1c7200be7a33cfeeca1c68089b6 upstream.

tcp_reqsk_record_syn() allocates saved_syn separately from its request
socket. bpf_sock_ops_get_syn() can load that pointer while processing a
retransmitted SYN under RCU.

There are two ownership transfers which can let another CPU reclaim the
allocation while such a reader is still using it.

First, tcp_move_syn() transfers req->saved_syn to a newly created child
socket. The child can be closed and tcp_saved_syn_free() can reclaim the
allocation before a reader of the old request finishes.

Second, inet_reqsk_clone() shallow-copies request_sock during request
migration. After reqsk_migrate_reset() clears the old request pointer, the
migrated clone owns it. However, a reader which already loaded the pointer
from the old request can still be using it when the clone is released.

I found this through LLM-assisted concurrency fuzzing.

Mark the request-socket saved_syn pointer as RCU protected and use RCU
accessors for its reads and updates. Keep the full-socket pointer plain
because all of its accesses hold the socket lock. Embed an rcu_head in
struct saved_syn and use kfree_rcu() in both teardown paths. This lets a
request-side reader which loaded the object before an ownership transfer
finish.

This follows commit e3f33b0a1d89 ("ipv4: free inet_opt and ireq_opt
after an RCU grace period"), which fixed the same ownership-transfer
pattern for IPv4 options.

The issue was confirmed with KASAN on v7.3-16007-g36aad21d50d1 using
temporary kernel instrumentation to widen the reader and request-migration
window. KASAN reported a slab-use-after-free read in
bpf_sock_ops_get_syn(), with the allocation freed by __reqsk_free() from
reqsk_timer_handler(). The same explicit migration test completed without
a report with deferred reclamation. A patched kernel without the delay
instrumentation also completed a successful migration and seven saved-SYN
reads without a KASAN report.

Fixes: 0813a841566f ("bpf: tcp: Allow bpf prog to write and parse TCP header option")
Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <x-professor@outlook.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/38fa9f2cc476502e9b1c1fef09ebba1df5dd5901.1793795528.git.x-professor@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/tcp.h             |    6 +++---
 include/net/request_sock.h      |    3 ++-
 net/core/filter.c               |    2 +-
 net/ipv4/inet_connection_sock.c |    6 +++---
 net/ipv4/tcp_input.c            |    2 +-
 5 files changed, 10 insertions(+), 9 deletions(-)

--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -612,13 +612,13 @@ static inline void fastopen_queue_tune(s
 static inline void tcp_move_syn(struct tcp_sock *tp,
 				struct request_sock *req)
 {
-	tp->saved_syn = req->saved_syn;
-	req->saved_syn = NULL;
+	tp->saved_syn = unrcu_pointer(req->saved_syn);
+	RCU_INIT_POINTER(req->saved_syn, NULL);
 }
 
 static inline void tcp_saved_syn_free(struct tcp_sock *tp)
 {
-	kfree(tp->saved_syn);
+	kfree_rcu(tp->saved_syn, rcu);
 	tp->saved_syn = NULL;
 }
 
--- a/include/net/request_sock.h
+++ b/include/net/request_sock.h
@@ -39,6 +39,7 @@ struct request_sock_ops {
 };
 
 struct saved_syn {
+	struct rcu_head rcu;
 	u32 mac_hdrlen;
 	u32 network_hdrlen;
 	u32 tcp_hdrlen;
@@ -68,7 +69,7 @@ struct request_sock {
 	struct timer_list		rsk_timer;
 	const struct request_sock_ops	*rsk_ops;
 	struct sock			*sk;
-	struct saved_syn		*saved_syn;
+	struct saved_syn __rcu		*saved_syn;
 	u32				secid;
 	u32				peer_secid;
 	u32				timeout;
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6188,7 +6188,7 @@ static int bpf_sock_ops_get_syn(struct b
 			 * not be available.  It has to resort to
 			 * saved_syn (if it is saved).
 			 */
-			saved_syn = inet_reqsk(sk)->saved_syn;
+			saved_syn = rcu_dereference(inet_reqsk(sk)->saved_syn);
 		else
 			saved_syn = tcp_sk(sk)->saved_syn;
 
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -869,7 +869,7 @@ reqsk_alloc_noprof(const struct request_
 	req_to_sk(req)->sk_prot = sk_listener->sk_prot;
 	sk_node_init(&req_to_sk(req)->sk_node);
 	sk_tx_queue_clear(req_to_sk(req));
-	req->saved_syn = NULL;
+	RCU_INIT_POINTER(req->saved_syn, NULL);
 	req->syncookie = 0;
 	req->num_timeout = 0;
 	req->num_retrans = 0;
@@ -908,7 +908,7 @@ void __reqsk_free(struct request_sock *r
 	req->rsk_ops->destructor(req);
 	if (req->rsk_listener)
 		sock_put(req->rsk_listener);
-	kfree(req->saved_syn);
+	kfree_rcu(unrcu_pointer(req->saved_syn), rcu);
 	kmem_cache_free(req->rsk_ops->slab, req);
 }
 
@@ -979,7 +979,7 @@ static void reqsk_queue_migrated(struct
 
 static void reqsk_migrate_reset(struct request_sock *req)
 {
-	req->saved_syn = NULL;
+	RCU_INIT_POINTER(req->saved_syn, NULL);
 #if IS_ENABLED(CONFIG_IPV6)
 	inet_rsk(req)->ipv6_opt = NULL;
 	inet_rsk(req)->pktopts = NULL;
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7636,7 +7636,7 @@ static void tcp_reqsk_record_syn(const s
 			saved_syn->network_hdrlen = skb_network_header_len(skb);
 			saved_syn->tcp_hdrlen = tcp_hdrlen(skb);
 			memcpy(saved_syn->data, base, len);
-			req->saved_syn = saved_syn;
+			RCU_INIT_POINTER(req->saved_syn, saved_syn);
 		}
 	}
 }


