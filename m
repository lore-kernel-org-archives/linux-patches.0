Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209369;
	b=uDrHdaCMPjK+nQZIxfhXN7mYtXAZyyAMvwwR1vHRVlPBZApz9x5OHG0YgjEZXlLLHNwt
	 nxOHSnx558R8XysYt1fSsZwaebVHSABcb2p+g6ICiOrL5PLZlMEaj5nAytq6uv8kcSwbb
	 77aISy4WlQ2q9N2L6W8Qjg0ipUX+8hJLq0OwMahwhGmK0Va9t0RMoNtcXXK1eYmuPtSFx
	 g0QxWbY+7FZckLxyKHBAuOAj89NrS2uEqHXubXFkxT1ThajODLzoPOD50bkGgQeZriz7m
	 Oc7QxD97mfmp89tcL5A9adpEEYR2pOCSj1PCA0Hl0LzvZTqu1Vt/KxaXjkkNEkptObg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rWJL/vgz4xp/jg3hV1va09tT7HWnAsu7YwJUU97yw5s=;
	b=j2F9G81MF8SdyROLb9eBQrf3A/y0xl3g7S9fEHVdnkVk9i7eCeYLWZgsThlYFpe6lt6h
	 MisRA2BZogjudNR315K2GAgP97ME8fR4l3+ystTFNNUijGZZ/02BIKldHS5nKKLmILcQg
	 A5f7k7A1m+R/f2BjMwJyXudXa5+sMjHkoNBo9X3Uq/lBoI9s+bUM+CpS/LsPoCGKLVFXX
	 zn1Dq3tgaE/0AvRcbe4RJioOODiracQi3cfJgW4kwEP/aASPRYnMm0WbhnhTQwT+0obUX
	 uEwincRtoW/zRVca/bealgJhorQeHdVZhVt7oVAgy9GFTK7P9taohqy+uHCs2QlgPVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCeI1gNa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E7606A31D;
	Wed, 28 Oct 2026 17:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nCeI1gNa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC351F01825;
	Wed, 28 Oct 2026 17:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209369;
	bh=rWJL/vgz4xp/jg3hV1va09tT7HWnAsu7YwJUU97yw5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nCeI1gNa22yRssvM/8neWq/t4hze5lw1gcyNxiuW5tcSCzLohBgKudQDWwRmTW7Tn
	 fDJiKKmJ6ejn0SNm2+Vtp7+7lkPRgGCoZEBjtw30n+EBSyb5OBje0qOZHeGclJZZeT
	 bdojy8+NkL0ktiUEZ+mEinGy52mbDot/prFjrjfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Lorenz Bauer <lmb@cloudflare.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 447/516] net: initialize net->net_cookie at netns setup
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028170014.070231043@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3d368ab87cf6681f928de1ddf804d69600671bb2 ]

It is simpler to make net->net_cookie a plain u64
written once in setup_net() instead of looping
and using atomic64 helpers.

Lorenz Bauer wants to add SO_NETNS_COOKIE socket option
and this patch would makes his patch series simpler.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f88bb3606e4b ("netlink: avoid hashing the network namespace pointer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/net_namespace.h |  4 +---
 net/core/filter.c           |  8 +++-----
 net/core/net_namespace.c    | 19 +++----------------
 3 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 1f985b64a666c..004b6fc03d894 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -172,7 +172,7 @@ struct net {
 	struct netns_xfrm	xfrm;
 #endif
 
-	atomic64_t		net_cookie; /* written once */
+	u64			net_cookie; /* written once */
 
 #if IS_ENABLED(CONFIG_IP_VS)
 	struct netns_ipvs	*ipvs;
@@ -238,8 +238,6 @@ extern struct list_head net_namespace_list;
 struct net *get_net_ns_by_pid(pid_t pid);
 struct net *get_net_ns_by_fd(int fd);
 
-u64 __net_gen_cookie(struct net *net);
-
 #ifdef CONFIG_SYSCTL
 void ipx_register_sysctl(void);
 void ipx_unregister_sysctl(void);
diff --git a/net/core/filter.c b/net/core/filter.c
index b885b8b9b4af7..1fc7affeb981d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4762,11 +4762,9 @@ static const struct bpf_func_proto bpf_get_socket_cookie_sock_ops_proto = {
 
 static u64 __bpf_get_netns_cookie(struct sock *sk)
 {
-#ifdef CONFIG_NET_NS
-	return __net_gen_cookie(sk ? sk->sk_net.net : &init_net);
-#else
-	return 0;
-#endif
+	const struct net *net = sk ? sock_net(sk) : &init_net;
+
+	return net->net_cookie;
 }
 
 BPF_CALL_1(bpf_get_netns_cookie_sock, struct sock *, ctx)
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index feee95cf29919..db31dc65e3cdb 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -72,18 +72,6 @@ static unsigned int max_gen_ptrs = INITIAL_NET_GEN_PTRS;
 
 DEFINE_COOKIE(net_cookie);
 
-u64 __net_gen_cookie(struct net *net)
-{
-	while (1) {
-		u64 res = atomic64_read(&net->net_cookie);
-
-		if (res)
-			return res;
-		res = gen_cookie_next(&net_cookie);
-		atomic64_cmpxchg(&net->net_cookie, 0, res);
-	}
-}
-
 static struct net_generic *net_alloc_generic(void)
 {
 	unsigned int gen_ptrs = READ_ONCE(max_gen_ptrs);
@@ -338,6 +326,9 @@ static __net_init int setup_net(struct net *net, struct user_namespace *user_ns)
 	refcount_set(&net->count, 1);
 	refcount_set(&net->passive, 1);
 	get_random_bytes(&net->hash_mix, sizeof(u32));
+	preempt_disable();
+	net->net_cookie = gen_cookie_next(&net_cookie);
+	preempt_enable();
 	net->dev_base_seq = 1;
 	net->user_ns = user_ns;
 	idr_init(&net->netns_ids);
@@ -1170,10 +1161,6 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
-	preempt_disable();
-	__net_gen_cookie(&init_net);
-	preempt_enable();
-
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
-- 
2.53.0



