Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047078;
	b=mGfchIvV9PEea6OptMoR/NDF+rjwcDZb+KW386feDULwlWKpxyvUkPskavkFQi7I5V0L
	 dwHMLcMkeuS3vVaOFaqWBlb4a/KqffV6uaMjvaGuhDRl5g2TPGq2yEFO/GpbuQnhvDD0H
	 LuOfdYqMUjWdjF30NwMdJNmQ+ZmyoOmDebB9VpD3BGUa9gUuFV1WN08viNh6fZoA/eFC6
	 LMRviRybzYGG4o6j0NbuN5Jfkr5NEy2qFoU04rxvJwqN0MJzqm222bEcTXk8GGlo1mUA4
	 j0RQ7KiqvBrLdShoJxDlUI/Lkc3WCZBK4Cw+Sj9uU00wM9D59PotDe49lVLNZJ5P3Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BNRww4bfXcZGbOfL3WeyYfHjcMelnyB4DOdlo93IynA=;
	b=PKKhrhe8AMqSYqTuSZV+F/teos6AOecgo2PVhI/GUwrj+vSFvyoZuugNiK1N8emn+7yX
	 PqhGHC3T1eQQBDXOuQdu40pxMbhu993+m/XuhWtnUcmvVpI30x7Y/9qD6ZqVJp96JrpHw
	 ojGfPWoBoC2MU+sZuycDjTKL9UJNTyYy6X246gUJf0DymnRJruyfW+2dokIuQUgDh+n4Y
	 Eep5Eh8HqtKqZ8P1GLzYDr+U3WYsKcsFEfs5IppZB++10/MEEY71ho9F5xctZy1gfIBlX
	 CDPsGaqYHOLjhxatfdiEJdviGyYRmHh/yMmD8lrASfqfhxCyW/LHIlw83Dez+wTOTWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dkvz5sCE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C612A606A31C;
	Thu, 19 Nov 2026 00:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dkvz5sCE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29EFB1F000C4;
	Thu, 19 Nov 2026 00:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047078;
	bh=BNRww4bfXcZGbOfL3WeyYfHjcMelnyB4DOdlo93IynA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dkvz5sCEbXYHJMbb2W4xNaTApX8VSALmxHsBLm1C0GvUxgtgytZlqlm+zNsR/lCbu
	 SjiAayy9/4rkkpkZf+KVNWWaU1AKPnSBFplyhZJWUIrrMPqF2NNKMJgBRKWW79l5ka
	 ILmyE1szjV9ZOJcVKYZ9TfFoAxbr9YQl4AnOZzEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Sashiko <sashiko-bot@kernel.org>,
	Ruide Cao <caoruide123@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1470/2857] mptcp: fix MP_CAPABLE token migration when cloning reqsk
Date: Wed, 18 Nov 2026 15:41:44 +0100
Message-ID: <20261118150254.236668912@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Ruide Cao <caoruide123@gmail.com>

[ Upstream commit 2093bc7fa50056fef8620d2b82bcb2e9a0a5575d ]

TCP request migration clones pending request sockets with
inet_reqsk_clone().  For MPTCP MP_CAPABLE requests this byte-copies the
token_node hlist state into the clone even though the token table still
names the original request, and the following warning can be seen:

  WARNING: net/mptcp/token.c:364 at mptcp_token_destroy_request+0x2b0/0x330, CPU#2: swapper/2/0
  CPU: 2 UID: 0 PID: 0 Comm: swapper/2 Not tainted 7.2.0-rc5-00353-gc27e36054537 #10 PREEMPT(full)
  RIP: 0010:mptcp_token_destroy_request (net/mptcp/token.c:364 (discriminator 1))
  Call Trace:
   <IRQ>
   subflow_v4_req_destructor (net/mptcp/subflow.c:694)
   __reqsk_free (net/ipv4/inet_connection_sock.c:906)
   reqsk_timer_handler (include/net/request_sock.h:137 net/ipv4/inet_connection_sock.c:1147)
   call_timer_fn (kernel/time/timer.c:1748)

Move token request ownership from the original request to the clone under
the token bucket lock.  Make mptcp_token_accept() and
mptcp_token_destroy_request() re-check token_node under the same lock and
treat an already moved or removed request as a normal race instead of
warning.  This also keeps token bucket chain_len accounting balanced.

If a passive MP_CAPABLE socket cannot claim the token, destroy the
provisional MPTCP socket and let the subflow fall back rather than
installing a socket with mismatched token ownership.  Mark that path as a
passive handshake fallback so MPCapableFallbackACK records the downgrade.

If the speculative clone later loses the inet_ehash_insert() ownership
arbitration, the original request may find that its token was already moved
and fall back to plain TCP.  The clone destructor then releases the token
reservation and keeps chain_len balanced.  This trades an exceptionally
rare fallback for eliminating the warning and persistent accounting drift.

Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/86e2514b533bf4d55d4aa2fdbf1404022e8c9430.1776149210.git.caoruide123%40gmail.com
Signed-off-by: Ruide Cao <caoruide123@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261013-net-mptcp-misc-fixes-7-3-rc8-v1-4-932c9b182fc7@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted MPTCP socket cleanup to the existing state-management and per-protocol orphan-counter APIs. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/protocol.c   | 29 +++++++++++++++----
 net/mptcp/protocol.h   |  4 ++-
 net/mptcp/subflow.c    |  6 +++-
 net/mptcp/token.c      | 65 ++++++++++++++++++++++++++++++++++++++----
 net/mptcp/token_test.c |  4 +--
 5 files changed, 93 insertions(+), 15 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2084503567789..9bdfcbaacb59a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3372,6 +3372,21 @@ static void mptcp_copy_ip_options(struct sock *newsk, const struct sock *sk)
 	rcu_read_unlock();
 }
 
+static void mptcp_sk_clone_destroy(struct sock *nsk)
+{
+	inet_sk_state_store(nsk, TCP_CLOSE);
+	/* inet_csk_prepare_forced_close() clears TCP sock_ops state via
+	 * tcp_sk(), but nsk is an MPTCP master socket; keep the inet-level
+	 * destroy preparation here.
+	 */
+	bh_unlock_sock(nsk);
+	sock_put(nsk);
+	sock_set_flag(nsk, SOCK_DEAD);
+	this_cpu_inc(*nsk->sk_prot->orphan_count);
+	inet_sk(nsk)->inet_num = 0;
+	inet_csk_destroy_sock(nsk);
+}
+
 struct sock *mptcp_sk_clone_init(const struct sock *sk,
 				 const struct mptcp_options_received *mp_opt,
 				 struct sock *ssk,
@@ -3436,11 +3451,6 @@ struct sock *mptcp_sk_clone_init(const struct sock *sk,
 	list_add(&mptcp_subflow_ctx(ssk)->node, &msk->conn_list);
 	sock_hold(ssk);
 
-	/* new mpc subflow takes ownership of the newly
-	 * created mptcp socket
-	 */
-	mptcp_token_accept(subflow_req, msk);
-
 	/* set msk addresses early to ensure mptcp_pm_get_local_id()
 	 * uses the correct data
 	 */
@@ -3448,6 +3458,14 @@ struct sock *mptcp_sk_clone_init(const struct sock *sk,
 	mptcp_propagate_sndbuf(nsk, ssk);
 
 	mptcp_rcv_space_init(msk, ssk);
+
+	if (!mptcp_token_accept(subflow_req, msk)) {
+		list_del_init(&mptcp_subflow_ctx(ssk)->node);
+		WRITE_ONCE(msk->first, NULL);
+		sock_put(ssk);
+		mptcp_sk_clone_destroy(nsk);
+		return NULL;
+	}
 	bh_unlock_sock(nsk);
 
 	/* note: the newly allocated socket refcount is 2 now */
@@ -3977,6 +3995,7 @@ static struct proto mptcp_prot = {
 	.get_port	= mptcp_get_port,
 	.forward_alloc_get	= mptcp_forward_alloc_get,
 	.sockets_allocated	= &mptcp_sockets_allocated,
+	.orphan_count		= &tcp_orphan_count,
 
 	.memory_allocated	= &tcp_memory_allocated,
 	.per_cpu_fw_alloc	= &tcp_memory_per_cpu_fw_alloc,
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 31ea91b45363c..b27f672993605 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -778,9 +778,11 @@ static inline void mptcp_token_init_request(struct request_sock *req)
 }
 
 int mptcp_token_new_request(struct request_sock *req);
+void mptcp_token_move_request(struct request_sock *req,
+			      struct request_sock *new_req);
 void mptcp_token_destroy_request(struct request_sock *req);
 int mptcp_token_new_connect(struct sock *sk);
-void mptcp_token_accept(struct mptcp_subflow_request_sock *r,
+bool mptcp_token_accept(struct mptcp_subflow_request_sock *r,
 			struct mptcp_sock *msk);
 bool mptcp_token_exists(u32 token);
 struct mptcp_sock *mptcp_token_get_sock(struct net *net, u32 token);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index df85e8ac0d3d1..b192a4d8b707c 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -81,6 +81,8 @@ void mptcp_subflow_reqsk_clone(struct request_sock *req,
 	}
 
 	new_subflow_req->msk = msk;
+
+	mptcp_token_move_request(req, new_req);
 }
 
 static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
@@ -811,8 +813,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 
 		if (ctx->mp_capable) {
 			ctx->conn = mptcp_sk_clone_init(listener->conn, &mp_opt, child, req);
-			if (!ctx->conn)
+			if (!ctx->conn) {
+				fallback = true;
 				goto fallback;
+			}
 
 			owner = mptcp_sk(ctx->conn);
 
diff --git a/net/mptcp/token.c b/net/mptcp/token.c
index f52ee7b26aed1..d64ab69098a88 100644
--- a/net/mptcp/token.c
+++ b/net/mptcp/token.c
@@ -178,6 +178,43 @@ int mptcp_token_new_connect(struct sock *sk)
 	return 0;
 }
 
+/**
+ * mptcp_token_move_request - move request token ownership to a clone
+ * @req: original request socket
+ * @new_req: cloned request socket
+ *
+ * Move the token hash entry from the original request to its clone.
+ */
+void mptcp_token_move_request(struct request_sock *req,
+			      struct request_sock *new_req)
+{
+	struct mptcp_subflow_request_sock *subflow_req = mptcp_subflow_rsk(req);
+	struct mptcp_subflow_request_sock *new_subflow_req;
+	struct mptcp_subflow_request_sock *pos;
+	struct token_bucket *bucket;
+
+	new_subflow_req = mptcp_subflow_rsk(new_req);
+
+	if (hlist_nulls_unhashed_lockless(&subflow_req->token_node)) {
+		mptcp_token_init_request(new_req);
+		return;
+	}
+
+	bucket = token_bucket(subflow_req->token);
+	spin_lock_bh(&bucket->lock);
+	if (hlist_nulls_unhashed(&subflow_req->token_node)) {
+		mptcp_token_init_request(new_req);
+	} else {
+		pos = __token_lookup_req(bucket, subflow_req->token);
+		if (pos == subflow_req)
+			hlist_nulls_replace_init_rcu(&subflow_req->token_node,
+						     &new_subflow_req->token_node);
+		else
+			mptcp_token_init_request(new_req);
+	}
+	spin_unlock_bh(&bucket->lock);
+}
+
 /**
  * mptcp_token_accept - replace a req sk with full sock in token hash
  * @req: the request socket to be removed
@@ -185,22 +222,33 @@ int mptcp_token_new_connect(struct sock *sk)
  *
  * Called when a SYN packet creates a new logical connection, i.e.
  * is not a join request.
+ *
+ * Return: true on success.
  */
-void mptcp_token_accept(struct mptcp_subflow_request_sock *req,
+bool mptcp_token_accept(struct mptcp_subflow_request_sock *req,
 			struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_request_sock *pos;
 	struct token_bucket *bucket;
+	bool ret = false;
 
 	bucket = token_bucket(req->token);
 	spin_lock_bh(&bucket->lock);
+	if (hlist_nulls_unhashed(&req->token_node))
+		goto unlock;
 
-	/* pedantic lookup check for the moved token */
 	pos = __token_lookup_req(bucket, req->token);
-	if (!WARN_ON_ONCE(pos != req))
-		hlist_nulls_del_init_rcu(&req->token_node);
+	if (pos != req)
+		goto unlock;
+
+	hlist_nulls_del_init_rcu(&req->token_node);
 	__sk_nulls_add_node_rcu((struct sock *)msk, &bucket->msk_chain);
+	ret = true;
+
+unlock:
 	spin_unlock_bh(&bucket->lock);
+
+	return ret;
 }
 
 bool mptcp_token_exists(u32 token)
@@ -349,16 +397,21 @@ void mptcp_token_destroy_request(struct request_sock *req)
 	struct mptcp_subflow_request_sock *pos;
 	struct token_bucket *bucket;
 
-	if (hlist_nulls_unhashed(&subflow_req->token_node))
+	if (hlist_nulls_unhashed_lockless(&subflow_req->token_node))
 		return;
 
 	bucket = token_bucket(subflow_req->token);
 	spin_lock_bh(&bucket->lock);
+	if (hlist_nulls_unhashed(&subflow_req->token_node))
+		goto unlock;
+
 	pos = __token_lookup_req(bucket, subflow_req->token);
-	if (!WARN_ON_ONCE(pos != subflow_req)) {
+	if (pos == subflow_req) {
 		hlist_nulls_del_init_rcu(&pos->token_node);
 		bucket->chain_len--;
 	}
+
+unlock:
 	spin_unlock_bh(&bucket->lock);
 }
 
diff --git a/net/mptcp/token_test.c b/net/mptcp/token_test.c
index 5d984bec1cd86..8fbf69b8172d3 100644
--- a/net/mptcp/token_test.c
+++ b/net/mptcp/token_test.c
@@ -91,7 +91,7 @@ static void mptcp_token_test_accept(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, 0,
 			mptcp_token_new_request((struct request_sock *)req));
 	msk->token = req->token;
-	mptcp_token_accept(req, msk);
+	KUNIT_EXPECT_TRUE(test, mptcp_token_accept(req, msk));
 	KUNIT_EXPECT_PTR_EQ(test, msk, mptcp_token_get_sock(&init_net, msk->token));
 
 	/* this is now a no-op */
@@ -114,7 +114,7 @@ static void mptcp_token_test_destroyed(struct kunit *test)
 	KUNIT_ASSERT_EQ(test, 0,
 			mptcp_token_new_request((struct request_sock *)req));
 	msk->token = req->token;
-	mptcp_token_accept(req, msk);
+	KUNIT_EXPECT_TRUE(test, mptcp_token_accept(req, msk));
 
 	/* simulate race on removal */
 	refcount_set(&sk->sk_refcnt, 0);
-- 
2.53.0



