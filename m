Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774026;
	b=sXZAt8o9WBz0SrP7TTnP7G0i54xX7KcINRmyg3lhrOziwdG0piatDvhuTD7WSTPR7sYH
	 cQtD9ybfhPiGzTPpkj3x6qv2Q2GD/3Pbm4hIC+XssdMV2v1Ojj6QPVJ5aoGtNABwjH/vS
	 XmBUA2Xg8xCn164g35fMtzkLHgYeQMJNF+4W8ep5Qdtcp/MMNEpj2OaDWY6MTJDXllrHG
	 zAgSyOTRKxrUgy7XT2wm4p5dTHEPOD2lYGAa/IIaomyG6wL6PM4r6IUtjqKH8cd3REn2G
	 3IoVL+C2xARpDjEJJKab0dBsIoh36VLuiV/6Wd7EZADN1YqZJyPFp1C4V1hHK1oLWNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fRececC8v2Sl6jxGLA9dSW6jJ8Zw6P4pMQLEaeSi0d8=;
	b=cBwx+bTJ3cV4XjB5bCv3MZzbNtdW1DYmWdFRlA4lT13FYegiMPqfU7gy0qFSde7DctGq
	 CGkgny/UKdkCNHaaYJUlJjesk8yS0Zu2c8OWmcPLCO4aTxd6MfygLg23liIMraNvg8VKl
	 wbHCtXP82UJ+rZFvNAQuVdKE73KTxAwDPnGkZZdy+syEVNfikh/EodOSnQcPcj0RcMvJf
	 P7k5B12A1Fn5hu8X7VqbMLiQdFtqDiwWqZVXMf0eQA7yLQxrxokG8uASvTROPsbrrQ/tD
	 giisUp1SfDURnLshI98VXovCljbIyA2TaPEkzAznbtLof32pgvhbg3EZZQeaJO0WZoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="00X/SKCq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8706F606A31D;
	Fri, 23 Oct 2026 16:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=00X/SKCq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7CBE1F01825;
	Fri, 23 Oct 2026 16:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774026;
	bh=fRececC8v2Sl6jxGLA9dSW6jJ8Zw6P4pMQLEaeSi0d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00X/SKCqjA41ToZAmeI6ZrjvkiOUIvdYd26ddXgAK3h5hOtgGW5mW2G+mlIVLBN+b
	 zkZcy6a8xqU3Wh5v9cUf2jOPrUGFE62NIYZTT8lTnEaoZi1HL0RjmYLlo6xrXGGgXw
	 gkFhCDNXw8w7nR1VHEFVpGiGSbWPBtXDMZZ5SD14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Simon Horman <horms@kernel.org>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 058/193] netlink: avoid hashing the network namespace pointer
Date: Fri, 23 Oct 2026 18:35:35 +0200
Message-ID: <20261023163715.578351217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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
index c41fef11e518f..6c0aabca5dbad 100644
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



