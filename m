Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211761;
	b=PP9UdiD83ROqivFh8DPfB8WsaOSxkWk5znApgzfy7Bxryj1XbZ2fP3q+pu91rnd7OnN7
	 4Lt93g1KSq+KjLVZIJAWEraxiRSJGNrF1q3z0SbnnrYMWtkW6juhFKiMb/xPslJHP7Oll
	 tEzzJmNUwKCbHHjp7jkIhjfCzhXzFkw8Ot52LKjBAu6CmB+m/5qZ0kG8HxhKnAv5gS7+L
	 HrzyqCfCXK4DGYJ7AjBEUW1kiTXnyE955HuXEUY/3MtLzw4SXorIiWmb9v6jvDCoPptFr
	 HCzATtRGobRGmyRqF1+oLhVqvG2sLq3aUDnOxzIToKgockF4Q1Kiin3o7CJdN1TqWfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F8hK+uRlz6uA9zEX3Hy7AsbQ+HH8RzQQgMoIWTNPW3M=;
	b=vn5so073KVZ6ayjns8LV02QB1iFzlAcAV/YeL9sDMw29dZ9kZBKC9q8qyJSDkFnDB0Q+
	 5l/j+8yLyCA40dlVKk78I3MR8UcwJ80UQ+6+KN8CRBNrExfMfLlZUvskWXHuj3ngR3fYf
	 b4EEx+hItlml/q6JedWfyyBFT7RYlkUDMgE8ZWWy9BAtdRG2j5UxPBi12o8ZkM6vcvMAy
	 zBh930LGKo+sWwj+cZmuoNFQNT6EgqmuP5IoJyoojh/iKqACwAryiQUoLKB/SaK30/RL0
	 TjRUzKcVSiysBWrCOp58MScw+/9zgTZPpXz5/GWeQzhqMTeEtKMmVeNpWtXXaDFrJ0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dalieIoX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1617B606A326;
	Wed, 28 Oct 2026 18:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dalieIoX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BED1F01825;
	Wed, 28 Oct 2026 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211760;
	bh=F8hK+uRlz6uA9zEX3Hy7AsbQ+HH8RzQQgMoIWTNPW3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dalieIoXCb72i5sssHVoJqbePDJzucaD2dvV2p0JhyMTFnaCbQQmqIgq0Ggb1FhPj
	 az+MdKm2LYYGhKcqFH4u1q/RF/fOB9DJx59BkAUCHPoA9KEEIOeQqYdY8zkmNJJvOa
	 lAUZWqjEpquQd9NmxeS7IO/y+kr8ch6ge79pv/gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 491/571] netlink: avoid hashing the network namespace pointer
Date: Wed, 28 Oct 2026 18:00:38 +0100
Message-ID: <20261028170019.679844597@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit f88bb3606e4bd11ee035b682cddc2999e604609a ]

The netlink rhashtable key includes a raw struct net pointer and a
user-controlled port ID. Both /proc/net/netlink and socket diagnostics
expose the table's bucket order. By binding and rebinding chosen
NETLINK_USERSOCK port IDs, an unprivileged reader can distinguish equal
buckets and recover the low bits of the Jenkins hash. Its 32-bit seed
and the limited set of kernel-image slides can then be searched offline
to recover the address of init_net.

Use the namespace's unique, non-address net_cookie in the comparison
key instead. It is assigned before the per-net initializers run and
remains unchanged for the namespace's lifetime. The lookup key and
object hash are still built by netlink_compare_arg_init(), keeping
lookup, insertion, removal and rehashing consistent while preserving
namespace separation. Neither public table walker needs to change.

Reading the socket's namespace cookie in netlink_compare() is safe
under RCU, including during namespace teardown. netlink_release()
removes the socket from the hash table and defers its final put with
call_rcu(). cleanup_net() runs the per-net exit methods and waits for
outstanding RCU callbacks with rcu_barrier() before freeing namespace
storage.

Unlike ns.ns_id, net_cookie is also available and initialized during
setup_net() in older stable kernels, making the change straightforward
to backport to v5.15 and later.

Fixes: c428ecd1a21f ("netlink: Move namespace into hash key")
Assisted-by: LLM
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008011359.63727-2-kylebot@openai.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netlink/af_netlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 63065d2449509..3671071482a02 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -463,7 +463,7 @@ netlink_unlock_table(void)
 
 struct netlink_compare_arg
 {
-	possible_net_t pnet;
+	u64 net_cookie;
 	u32 portid;
 };
 
@@ -478,14 +478,14 @@ static inline int netlink_compare(struct rhashtable_compare_arg *arg,
 	const struct netlink_sock *nlk = ptr;
 
 	return nlk->portid != x->portid ||
-	       !net_eq(sock_net(&nlk->sk), read_pnet(&x->pnet));
+	       sock_net(&nlk->sk)->net_cookie != x->net_cookie;
 }
 
 static void netlink_compare_arg_init(struct netlink_compare_arg *arg,
 				     struct net *net, u32 portid)
 {
 	memset(arg, 0, sizeof(*arg));
-	write_pnet(&arg->pnet, net);
+	arg->net_cookie = net->net_cookie;
 	arg->portid = portid;
 }
 
-- 
2.53.0



