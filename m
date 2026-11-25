Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618713;
	b=RD4/i6bOJfZTUgoeAx9G7tjOv7LRvpqQYs0gpl1ax+V6BalnZTMM7EhDIQ7jbmiCR/pf
	 4Y0+rDd8w18u/F6aNNGlMzJ5/3t5Gv+IzzRTRE61BswZlLTUqE8znSyvvURp+zEmB+qSH
	 68/bkdmER8LUTslk00W9RVXyC2VsnYkCJ5ToUUX0PYEw/SIjtP2egdeSWwqzknNUA7FZN
	 BgerFuKcDk0bNaBuwfiynPI2v0smbrpdWksfS2sUaqVPVP4CDi64a45nKhemJ4kTkNjF2
	 aj3GS6NaYegqtTbrnw2UfT62WRF1TC15eT/41MSEPSCg++l8u/D41iLipmz3IRtzC0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618713;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1MHfdICgab79kS+IuqI+gzLAztGzc1wGSQf8tLGKh8k=;
	b=L8W53iQB+T3qk5Ncxdb11EiX04Ar1W7OJN8ZKOkRdr3RNO7lE1vDyo62Xq+chZ7ExPxC
	 kCzfPHloTa4aCzPDR/bLgXLxU++CZ598HnOesphCfNm8RXBx9nLdML7D5IRaCg0iQDReL
	 QK6Alhv9Q5ZwnPPOehvVHZVEYIQj1q2zIgc4XImzC8jx3Ir0eWRhysnilgyHXZdW3Ngke
	 8Rh1tWCI9egcEwopTSk+Z3Fu65cR3+Q/8uroR5kBayok0V/HHFqgkqDkryOI/m9ReU315
	 /lF1yUiPay3mGGGzZX+vOovuUDSh0qbAcClmL0OpMG6/Y9khcDsN5oN7ap21JFbK3ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlEqttSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBAC606A31E;
	Wed, 25 Nov 2026 14:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BlEqttSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC501F000C6;
	Wed, 25 Nov 2026 14:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618713;
	bh=1MHfdICgab79kS+IuqI+gzLAztGzc1wGSQf8tLGKh8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BlEqttSMHMVJdLCVPn4NNOwmRXONvqkUqXD+GXfWGUlhg7nAUu/FkePVbG3LAmoBY
	 TdFZv1gDLEt41TJUrZ3LJmybnKkOrQ/qhCuxklvDViQVfA0EVeH0BQGXlyV8DSdmyZ
	 yvR7G22E6sjGXiNoDXWUBGNPk+o/FZ5e5mA0b00M=
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
Subject: [PATCH 7.3 0367/1005] calipso: do not charge request socket options to the listener
Date: Wed, 25 Nov 2026 15:28:25 +0100
Message-ID: <20261125143830.331276282@linuxfoundation.org>
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
index e399a42e30839..4cd0ae9313b32 100644
--- a/net/ipv6/calipso.c
+++ b/net/ipv6/calipso.c
@@ -1219,7 +1219,7 @@ static int calipso_req_setattr(struct request_sock *req,
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 
-	txopts = ipv6_renew_options(sk, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
+	txopts = ipv6_renew_options(NULL, req_inet->ipv6_opt, IPV6_HOPOPTS, new);
 
 	kfree(new);
 
@@ -1227,10 +1227,8 @@ static int calipso_req_setattr(struct request_sock *req,
 		return PTR_ERR(txopts);
 
 	txopts = xchg(&req_inet->ipv6_opt, txopts);
-	if (txopts) {
-		atomic_sub(txopts->tot_len, &sk->sk_omem_alloc);
+	if (txopts)
 		txopt_put(txopts);
-	}
 
 	return 0;
 }
@@ -1260,14 +1258,12 @@ static void calipso_req_delattr(struct request_sock *req)
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
index 3ef3c2635581a..b523de2e5b7a1 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1281,7 +1281,7 @@ static void ipv6_renew_option(int renewtype,
  * not copied into the new set of options.
  *
  * The new set of options is allocated from the socket option memory
- * buffer of @sk.
+ * buffer of @sk, or with kmalloc() if @sk is NULL.
  */
 struct ipv6_txoptions *
 ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
@@ -1309,7 +1309,8 @@ ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
 		return NULL;
 
 	tot_len += sizeof(*opt2);
-	opt2 = sock_kmalloc(sk, tot_len, GFP_ATOMIC);
+	opt2 = sk ? sock_kmalloc(sk, tot_len, GFP_ATOMIC) :
+		    kmalloc(tot_len, GFP_ATOMIC);
 	if (!opt2)
 		return ERR_PTR(-ENOBUFS);
 
-- 
2.53.0



