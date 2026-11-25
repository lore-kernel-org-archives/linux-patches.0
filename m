Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621767;
	b=q68K52/lNH8GxK7atj+HetKqdDR1PccVNI/pD6ZDJ3SuQSpW1+vTFxthlbG5U4CsDuzO
	 Co4nZvzcJU5cjzMgMOActHdNZRXGK/rYd/esLbCny943zFxciw2N57Oh1LrUzCJiWmun9
	 nw6US1PPP+pk041OFI6vJhXURohWCuNLvaQZ/48Vd+XbCT9UGwSwXhT8mKP/9cjFLvEkC
	 59AmBe1o2TiZU9Ov5VJfqRNP8YwOjSzSG5+5BbP+K9jFb52c19sdrgtkTT+Q4+5N+ynnp
	 eX0s47ZV2DVUW93rW+szrSSwC9M6DijEFZDinLNuOJJEWRj6NlUDsLdEF+90JrmRDzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FY9TbKbDC+GYfStePA1DHQuUhvmdSM/1oHjQZCTxbvs=;
	b=vt/8WJV+fz9Ua0xFXisHoo8GUKqO9IJ5DHPWkRxc9mKEMAvHo7tO7Fjc1uvbkr1cQfHD
	 Zl3tHBz8xV8KCHd1zaQ/UhD1+gscZj2x8w34AqYrgNMRA79RU6h4O9kywCtWqNjd51/qP
	 zOX/gg4p2xvbKb1lujgwrPJQ9ZtbRywfRKiY3wZIE2P1oTrtVAAZ7DQSHcl3pH2qEs2xx
	 UY/dgO1dD5LAmdyrDKwzFHIyTnb47nLIeO4lpWXKEa4kDkKRQcy99auJt9hQCtqMzRRje
	 elwiUG8Ocp9bno5bU7aWP54QULIXStYvbZQ971Vn0BscyTKU4qJR2qkGfaScL1CEGQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0/s2tpuS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CD3606A32C;
	Wed, 25 Nov 2026 15:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0/s2tpuS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 673801F000D3;
	Wed, 25 Nov 2026 15:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621766;
	bh=FY9TbKbDC+GYfStePA1DHQuUhvmdSM/1oHjQZCTxbvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0/s2tpuSHhVJSC8SbgPVimRJJatUjH1clKob77Lhe0eacGkXe9yhG6/70DCKCIv0N
	 z+OzFddkdqhySJ4XWDnjInWpmnKKG4VuZ6IiDZiYy3Uu51hr3goZNNWsZSxNMaNGvB
	 PgrKtrjDhFUbqwuLBEUsHnvJDkZMpqhPc8Vj208k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paul Moore <paul@paul-moore.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 330/990] calipso: do not charge request socket options to the listener
Date: Wed, 25 Nov 2026 15:28:17 +0100
Message-ID: <20261125143829.817412009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit b4a2cc6d748d3056a25812dcf5f5377a59afd02f ]

calipso_req_setattr() and calipso_req_delattr() allocate ireq->ipv6_opt
with ipv6_renew_options(), which charges the listener sk_omem_alloc
through sock_kmalloc().

tcp_v6_reqsk_destructor() frees ireq->ipv6_opt without uncharging it,
so each request socket leaks its options size from the listener
budget. Once sysctl_optmem_max is reached, sock_kmalloc() fails,
calipso_req_setattr() returns -ENOBUFS, and tcp_v6_route_req() drops
all subsequent SYN packets. __sk_destruct() also reports an optmem
leakage when the listener is destroyed.

Uncharging in tcp_v6_reqsk_destructor() would not be correct: after a
migration, req->rsk_listener is no longer the socket that was charged.

These options belong to the request socket, there is no reason to
charge them to the listener. Change ipv6_renew_options() to use
kmalloc() when its sk argument is NULL, and use this from
calipso_req_setattr() and calipso_req_delattr(),
like cipso_v4_req_setattr() which uses kzalloc().

Note:

After this patch, calipso_req_setattr() and calipso_req_delattr()
no longer need the listener. Commit 10876da918fa ("calipso: Fix
null-ptr-deref in calipso_req_{set,del}attr().") could be reverted
in net-next (also removing the then unused sk variables), so that
CALIPSO works with SYN cookies.

Fixes: e1adea927080 ("calipso: Allow request sockets to be relabelled by the lsm.")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/netdev/179378292255.488856.6917577451813010963@kernel.org/
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Paul Moore <paul@paul-moore.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Link: https://patch.msgid.link/20261104150318.1156620-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/calipso.c | 12 ++++--------
 net/ipv6/exthdrs.c |  5 +++--
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/ipv6/calipso.c b/net/ipv6/calipso.c
index 5775ab1c39c04..ae0cf6520f21c 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1220,7 +1220,7 @@ static int calipso_req_setattr(struct request_sock *req,
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
-	txopts = ipv6_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
+	txopts = ipv6_renew_options(NULL, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
 
 	kfree(new);
 
@@ -1228,10 +1228,8 @@ static int calipso_req_setattr(struct request_sock *req,
 		return PTR_ERR(txopts);
 
 	txopts = xchg(&req_inet->ipv6_opt, txopts);
-	if (txopts) {
-		atomic_sub(txopts->tot_len, &sk->sk_omem_alloc);
+	if (txopts)
 		txopt_put(txopts);
-	}
 
 	return 0;
 }
@@ -1261,14 +1259,12 @@ static void calipso_req_delattr(struct request_sock *req)
 	if (calipso_opt_del(req_inet->ipv6_opt->hopopt, &new))
 		return; /* Nothing to do */
 
-	txopts = ipv6_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
+	txopts = ipv6_renew_options(NULL, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
 
 	if (!IS_ERR(txopts)) {
 		txopts = xchg(&req_inet->ipv6_opt, txopts);
-		if (txopts) {
-			atomic_sub(txopts->tot_len, &sk->sk_omem_alloc);
+		if (txopts)
 			txopt_put(txopts);
-		}
 	}
 	kfree(new);
 }
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 38f15948237c6..f680df587769c 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1284,7 +1284,7 @@ static void ipv6_renew_option(int renewtype,
  * not copied into the new set of options.
  *
  * The new set of options is allocated from the socket option memory
- * buffer of @sk.
+ * buffer of @sk, or with kmalloc() if @sk is NULL.
  */
 struct ipv6_txoptions *
 ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
@@ -1312,7 +1312,8 @@ ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
 		return NULL;
 
 	tot_len += sizeof(*opt2);
-	opt2 = sock_kmalloc(sk, tot_len, GFP_ATOMIC);
+	opt2 = sk ? sock_kmalloc(sk, tot_len, GFP_ATOMIC) :
+		    kmalloc(tot_len, GFP_ATOMIC);
 	if (!opt2)
 		return ERR_PTR(-ENOBUFS);
 
-- 
2.53.0



