Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624849;
	b=C4TFSnb+cF8UQnaFBQiIGcq2IYI/EDgt+CWo2oSZ6L0L8C9tOFI20WWH/8BRGKzyjxxe
	 oxdBNUhXRQNlq3Mwz/Q/ReWfDcXOvs3QKRBYwhX7loJiw/enhA+MS4BtQgkmBtJS1atwJ
	 dGld/5ZqEiL8pgHsbaRoPYVOaeKzRwxuvBCA2QoPwmo4A1JOCVEgc8dqp3/8yWgJOOEsQ
	 2SKagNKFXeoGe6fEGxypSR85zxJvSC2TfUT2DT2TQIHy2PtJYk1pnQl7RO7l3F1KRs61q
	 5uhDXN2KTwdMvfrIcuIWBsp1iwwUEB5Xwc4ZksP39SRfa0FjHbp8wPcbOc0f/UPQkUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JKMjm8eEuEKJucVpFYx27zfT9/17TsTAkQJqeLRtiDk=;
	b=IJHaHGCM1U2jJgjgaKE8NFdkOxXuGs/qxPiMoAMneOJaZTQeycx4NaQyopunUbZISILN
	 WAczje7s2A9sKbKfjZ1sf2kb+mGbxzcK0cZZE5tBH/4UXf1C55awqf/KlEFCF1TS3v2cE
	 0LSaBFbkEfGpUqkS3BTcdl/PgT7ysRdjxs/cQaaJG9yBPj9651yEhY9gOYLboMl33TR5+
	 QwdG+10b8K/90iUsjWOSjPtGRnr6qEV6zr4mo6RXnXimUyKRwbIAT+c6flaQzxr90Zvfl
	 v6pXWid6+LV9Qx4Lvj7lVRZNFYXCUhZXg13jctbpEPJog7weGOtXc3qrkXQG5DLiygA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEd69H6F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 278D5606A31E;
	Wed, 25 Nov 2026 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oEd69H6F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B310A1F000CF;
	Wed, 25 Nov 2026 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624848;
	bh=JKMjm8eEuEKJucVpFYx27zfT9/17TsTAkQJqeLRtiDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEd69H6FWZW+B1O9ZsyT7hsQBIJqK4xF25xMXyU+mLuJXHgsKdlURCChZXCZxWUS9
	 yPYt7flUbuS0bJET5DWADeeA0XNVd+IPzC2LJSRxule1g4j909zSpbnTVgBbdCshGm
	 0RRbmARaFWDaQNSusIGbYKAPO8OsU4cSTnzwlROw=
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
Subject: [PATCH 6.12 271/816] calipso: do not charge request socket options to the listener
Date: Wed, 25 Nov 2026 15:30:19 +0100
Message-ID: <20261125143855.482976010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 78a96469d6c8e..9e32a732ecbff 100644
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
index c4c541b1ef5d8..23dce6f57576a 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -1285,7 +1285,7 @@ static void ipv6_renew_option(int renewtype,
  * not copied into the new set of options.
  *
  * The new set of options is allocated from the socket option memory
- * buffer of @sk.
+ * buffer of @sk, or with kmalloc() if @sk is NULL.
  */
 struct ipv6_txoptions *
 ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
@@ -1313,7 +1313,8 @@ ipv6_renew_options(struct sock *sk, struct ipv6_txoptions *opt,
 		return NULL;
 
 	tot_len += sizeof(*opt2);
-	opt2 = sock_kmalloc(sk, tot_len, GFP_ATOMIC);
+	opt2 = sk ? sock_kmalloc(sk, tot_len, GFP_ATOMIC) :
+		    kmalloc(tot_len, GFP_ATOMIC);
 	if (!opt2)
 		return ERR_PTR(-ENOBUFS);
 
-- 
2.53.0



