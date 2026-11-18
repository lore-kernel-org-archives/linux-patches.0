Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058003;
	b=Lchaq8gdZTFvjOllvor5GDbQs7lPzCG00jrGqxikolNSHwYOPdSsb5vLfQkFXTqFYVWP
	 Ll4abvPhmRIIuTZFtfv3zhVqfcsSxFy4E4hewd2rOQEfG4SD6WJ7TERUqUcwxk5Cxang/
	 FGo8afxxKQT4HRrApyfipERL31H33TPlgs533h9bSO+ALA5K9MeF4Qyav/f8y44w5vd5U
	 EVRrv8nrRl6D4oGA42n+32f8uP526teMaWQYivYY800papBMXkOabETNDch9AQHqPzmld
	 BcbSgkTtOhhQhnF3jjx0W4XA88HjHtQSZFWNL0FFeIGD4MuVnhNSzy4z+ub5MQHTc9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058003;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JLXW+vBJ9OujUdATuczoGqkY9JsawokHvE0hPNKNZ20=;
	b=5dSoi0S9JTHtnGyZ5sw9Yf7oeaGSVyc1T1t4IUGTzJ4m5UujnEu21eUDMiDoFYFaCqXh
	 yhjtOzA/U8x60tN1WaT718RDfDGIEuEHCbH6bdZWiuFgWlDN2Vw3BEG3myNP4er1j22M1
	 y2Fci+eoTUsskMImhM7NDVqhZT8bVHpjsTIb7Kh3cQrecGYJhr2PPTrUguDJ5pFeweBUy
	 ZUHgWvGz7QCa4QSRN2qfH6VBJKd/JlU5Q1HMA5FyAJgBnAxNZP0afdYHNA2AyUHrAWPu3
	 yKUsNDX8HU6uL9anQy5H7+x0FKZk2cUvcB4lX3GxzGZw6C3Rg2eBbktmWK8PWDpf/nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwmYt98y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BEE0606A320;
	Thu, 19 Nov 2026 03:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mwmYt98y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9BD1F000C4;
	Thu, 19 Nov 2026 03:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058003;
	bh=JLXW+vBJ9OujUdATuczoGqkY9JsawokHvE0hPNKNZ20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwmYt98y3nH0MIRFJn/ubZT7KfJ2nVxOQb/dkOkAdEegpoZjmx+WjL9qceU2vFrJ5
	 d8PgUu51SSdUCPzYsZ4huCzs/9G/mWDWW4xfWT0qYlA95B/adhAcxx+behUNVBixoA
	 TbnHWvZ75IDgBY/EAb9wfJjj3FNL2TgG40GjkDus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0331/1848] inet: reject unhashed sockets during established lookups
Date: Wed, 18 Nov 2026 15:39:29 +0100
Message-ID: <20261118145926.073040559@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 4e2b3ef19e0e04adca38442f07dd6bc93c712bf1 ]

TCP established ehash lookups are lockless. The socket caches involved
use SLAB_TYPESAFE_BY_RCU, so memory can be reused before an RCU reader
that retained its old address has finished.

After a tuple match, __inet_lookup_established() and
__inet6_lookup_established() acquire a reference and repeat the tuple
check. They do not check whether the new object is hashed. If the
address is reused for a socket with the same tuple, the lookup can
acquire a reference to the new object and return it while its nulls node
is unhashed.

A PoC that drives reuse with a SYN cookie request socket reproduced the
crash. The new request socket is unhashed and has a NULL rsk_listener.
A lookup that had loaded the address of the old request socket acquired
the reference published by tcp_get_cookie_sock() and returned the new
object. tcp_v4_rcv() then read sk_state through the NULL listener.

The resulting crash was:

  BUG: kernel NULL pointer dereference, address: 0000000000000012
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  ...
  Oops: Oops: 0000 [#1] SMP NOPTI
  CPU: 4 UID: 0 PID: 0 Comm: swapper/4 Not tainted 7.3.0-00591-g0e135910deec #1 PREEMPT(lazy)
  ...
  RIP: 0010:tcp_v4_rcv+0x44e/0x1280
  ...
  R10: 0000000000000001 R11: 00000000024ca8c0 R12: 0000000000000000
  ...
  CR2: 0000000000000012 CR3: 0000000103d50004 CR4: 0000000000770ef0
  ...
  Call Trace:
   <IRQ>
   ? raw_local_deliver+0xae/0x240
   ip_protocol_deliver_rcu+0x2d/0x180
   ip_local_deliver_finish+0x84/0x100
   ip_sublist_rcv_finish+0x5f/0x70
   ip_sublist_rcv+0x12a/0x1d0
   ip_list_rcv+0xfd/0x130
   __netif_receive_skb_list_core+0x223/0x250
   netif_receive_skb_list_internal+0x1d2/0x2c0
   ? try_fill_recv+0x39/0x7b0
   napi_complete_done+0x74/0x170
   virtnet_poll+0x445/0x600
   __napi_poll+0x27/0x1e0
   net_rx_action+0x2fe/0x3b0
   handle_softirqs+0xc2/0x2c0
   __irq_exit_rcu+0x74/0xd0
   common_interrupt+0x7f/0x90
   </IRQ>
  ...
  Kernel panic - not syncing: Fatal exception in interrupt

After taking a reference, check whether the nulls node is unhashed in
both IPv4 and IPv6 established lookups. If it is unhashed or the tuple
no longer matches, drop the reference and restart the lookup.

Lookups racing with the TIME_WAIT hashdance, or with a request being
replaced by its child, now restart and find the new socket instead of
returning the old one.

Request sockets that were never inserted into ehash can have a nonzero
refcount, and a stale lookup can hold a transient reference. Therefore,
when SYN cookie, Fast Open, and request migration paths fail after
setting a nonzero refcount, release the references held by those paths
with reqsk_put() instead of freeing the request directly.

Fixes: 079096f103fa ("tcp/dccp: install syn_recv requests into ehash table")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261029214219.1035176-2-imv4bel@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Hyunwoo Kim: Request migration is not present in 5.10.y, so omit the
  net/ipv4/inet_connection_sock.c changes. Keep the pre-rename
  INET_MATCH() function name used by 5.10.y. ]
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c  | 5 +++--
 net/ipv4/syncookies.c       | 2 ++
 net/ipv4/tcp_input.c        | 4 +++-
 net/ipv6/inet6_hashtables.c | 4 +++-
 4 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 9b7c845245274..ff5c972d7deab 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -420,8 +420,9 @@ struct sock *__inet_lookup_established(struct net *net,
 		if (likely(INET_MATCH(net, sk, acookie, ports, dif, sdif))) {
 			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				goto out;
-			if (unlikely(!INET_MATCH(net, sk, acookie,
-						 ports, dif, sdif))) {
+			if (unlikely(hlist_nulls_unhashed_lockless(&sk->sk_nulls_node) ||
+				     !INET_MATCH(net, sk, acookie, ports, dif,
+						 sdif))) {
 				sock_gen_put(sk);
 				goto begin;
 			}
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 29fb93cb32286..c9eed9bb4b151 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -217,6 +217,8 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 
 		bh_unlock_sock(child);
 		sock_put(child);
+		reqsk_put(req);
+		return NULL;
 	}
 	__reqsk_free(req);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 111d582dbba3b..58e92af1398ea 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -7009,7 +7009,9 @@ int tcp_conn_request(struct request_sock_ops *rsk_ops,
 		if (!inet_csk_reqsk_queue_add(sk, req, fastopen_sk)) {
 			bh_unlock_sock(fastopen_sk);
 			sock_put(fastopen_sk);
-			goto drop_and_free;
+			/* tcp_disconnect() already dropped one reqsk ref. */
+			reqsk_put(req);
+			goto drop;
 		}
 		sk->sk_data_ready(sk);
 		bh_unlock_sock(fastopen_sk);
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 21b4fc835487b..69aefbae17125 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -77,7 +77,9 @@ struct sock *__inet6_lookup_established(struct net *net,
 		if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 			goto out;
 
-		if (unlikely(!inet6_match(net, sk, saddr, daddr, ports, dif, sdif))) {
+		if (unlikely(hlist_nulls_unhashed_lockless(&sk->sk_nulls_node) ||
+			     !inet6_match(net, sk, saddr, daddr, ports, dif,
+					  sdif))) {
 			sock_gen_put(sk);
 			goto begin;
 		}
-- 
2.53.0



