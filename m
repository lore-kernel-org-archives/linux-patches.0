Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215032;
	b=GZGlsdRhEe1FcbVFP8L++xjFRqI1mPPOChxmN4jaNA+RRqQeA0JIg4j4k+7WPR4sYj4w
	 0h19lVdo68GEKRZcibxexFm7RtUFrQ6HaEFRlW74BaXG1F6L7TI+TxpNu6Ewq8apiA+po
	 NFfrb0qZMfIdKbsqhiYrght2JJ5+AH4NCCvO6ZsjL89q/uWEWHfBkPGPOdnS4E3LA1oMG
	 nKdliBjYH6zf02Nnf9NgRHHAghFygk3CpIJ2Nd2otXBLCrvlCq9imNgTlfK1uOweK3BO/
	 he5+3TnkTcyQKrchQjbdwMWKCeoO3l4uOXeC3AK1iWefecg29VMa9E/+FQ7InitNYYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pJU+Bx5Q9gv7q8Q6r33VAV3wKDK4XBtDKUc8c9dAJnI=;
	b=TWzO0MZykb/flWGfr3ubOq9LPZOs+qfiehl85qlfT1llMEEc8o5PWMAv+t/R6IeK/ETI
	 NVHNWVcQeIppOJZRW4XKOP+w8/ZUoZKUynCpzfCrC7TCfhShd/YLQticwHe/cUYpcVm5p
	 jJatouO3gSsE+pmcY26k5NDqdH38RmGPFdapSzAAsx9wtxexVhbG3jCbMGQxygigapnPY
	 8JVav+1HjGlUX5+yfLKnBOQZrErGDr1rOeVoqzyPpb4ULjhgcj8EdCbKKrR0fCfgaMroT
	 Py3hZp+yAn77MFn9xDtAgl0A77FNT0vyo/Eu4pkusXM7XNZMLAXMBn0bozzfcAVdhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w8/jzy1J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD691606A31A;
	Wed, 28 Oct 2026 19:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8/jzy1J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4751F01825;
	Wed, 28 Oct 2026 19:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215031;
	bh=pJU+Bx5Q9gv7q8Q6r33VAV3wKDK4XBtDKUc8c9dAJnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8/jzy1JaAuX80ASqXIy3q9g5H32oFoIxXFeBWYvC/lQpq0iAYydWOtnJnvelkdfP
	 w0swBB89S1/H0pwG2et8Kt5JSZReX+9EXp8LVGULwx/GHLN/6Afo3qZVX/f4n4FuG0
	 /dwtamShQhz5g1ZBb8/R8EsGu5yHbz4IRRwkS1og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1068/1887] Revert "net/smc: Introduce TCP ULP support"
Date: Wed, 28 Oct 2026 17:52:44 +0100
Message-ID: <20261028170523.712451367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: D. Wythe <alibuda@linux.alibaba.com>

[ Upstream commit df31a6b0a3057e66994ad6ccf5d95b9b9514f033 ]

This reverts commit d7cd421da9da2cc7b4d25b8537f66db5c8331c40.

As reported by Al Viro, the TCP ULP support for SMC is fundamentally
broken. The implementation attempts to convert an active TCP socket
into an SMC socket by modifying the underlying `struct file`, dentry,
and inode in-place, which violates core VFS invariants that assume
these structures are immutable for an open file, creating a risk of
use after free errors and general system instability.

Given the severity of this design flaw and the fact that cleaner
alternatives (e.g., LD_PRELOAD, BPF) exist for legacy application
transparency, the correct course of action is to remove this feature
entirely.

Fixes: d7cd421da9da ("net/smc: Introduce TCP ULP support")
Link: https://lore.kernel.org/netdev/Yus1SycZxcd+wHwz@ZenIV/
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
Reviewed-by: Tony Lu <tonylu@linux.alibaba.com>
Reviewed-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260128055452.98251-1-alibuda@linux.alibaba.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 113 +++++++----------------------------------------
 1 file changed, 17 insertions(+), 96 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 75d9036282298..4c158cde1f504 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -3275,8 +3275,8 @@ static const struct proto_ops smc_sock_ops = {
 	.splice_read	= smc_splice_read,
 };
 
-static int __smc_create(struct net *net, struct socket *sock, int protocol,
-			int kern, struct socket *clcsock)
+static int smc_create(struct net *net, struct socket *sock, int protocol,
+		      int kern)
 {
 	int family = (protocol == SMCPROTO_SMC6) ? PF_INET6 : PF_INET;
 	struct smc_sock *smc;
@@ -3306,102 +3306,33 @@ static int __smc_create(struct net *net, struct socket *sock, int protocol,
 	/* default behavior from limit_smc_hs in every net namespace */
 	smc->limit_smc_hs = net->smc.limit_smc_hs;
 
-	rc = 0;
-	if (!clcsock) {
-		rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
-				      &smc->clcsock);
-		if (rc) {
-			sk_common_release(sk);
-			goto out;
-		}
-
-		/* smc_clcsock_release() does not wait smc->clcsock->sk's
-		 * destruction;  its sk_state might not be TCP_CLOSE after
-		 * smc->sk is close()d, and TCP timers can be fired later,
-		 * which need net ref.
-		 */
-		sk = smc->clcsock->sk;
-		sk->sk_net_refcnt = 1;
-		get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
-		sock_inuse_add(net, 1);
-	} else {
-		smc->clcsock = clcsock;
+	rc = sock_create_kern(net, family, SOCK_STREAM, IPPROTO_TCP,
+			      &smc->clcsock);
+	if (rc) {
+		sk_common_release(sk);
+		goto out;
 	}
 
+	/* smc_clcsock_release() does not wait smc->clcsock->sk's
+	 * destruction;  its sk_state might not be TCP_CLOSE after
+	 * smc->sk is close()d, and TCP timers can be fired later,
+	 * which need net ref.
+	 */
+	sk = smc->clcsock->sk;
+	sk->sk_net_refcnt = 1;
+	get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
+	sock_inuse_add(net, 1);
+
 out:
 	return rc;
 }
 
-static int smc_create(struct net *net, struct socket *sock, int protocol,
-		      int kern)
-{
-	return __smc_create(net, sock, protocol, kern, NULL);
-}
-
 static const struct net_proto_family smc_sock_family_ops = {
 	.family	= PF_SMC,
 	.owner	= THIS_MODULE,
 	.create	= smc_create,
 };
 
-static int smc_ulp_init(struct sock *sk)
-{
-	struct socket *tcp = sk->sk_socket;
-	struct net *net = sock_net(sk);
-	struct socket *smcsock;
-	int protocol, ret;
-
-	/* only TCP can be replaced */
-	if (tcp->type != SOCK_STREAM || sk->sk_protocol != IPPROTO_TCP ||
-	    (sk->sk_family != AF_INET && sk->sk_family != AF_INET6))
-		return -ESOCKTNOSUPPORT;
-	/* don't handle wq now */
-	if (tcp->state != SS_UNCONNECTED || !tcp->file || tcp->wq.fasync_list)
-		return -ENOTCONN;
-
-	if (sk->sk_family == AF_INET)
-		protocol = SMCPROTO_SMC;
-	else
-		protocol = SMCPROTO_SMC6;
-
-	smcsock = sock_alloc();
-	if (!smcsock)
-		return -ENFILE;
-
-	smcsock->type = SOCK_STREAM;
-	__module_get(THIS_MODULE); /* tried in __tcp_ulp_find_autoload */
-	ret = __smc_create(net, smcsock, protocol, 1, tcp);
-	if (ret) {
-		sock_release(smcsock); /* module_put() which ops won't be NULL */
-		return ret;
-	}
-
-	/* replace tcp socket to smc */
-	smcsock->file = tcp->file;
-	smcsock->file->private_data = smcsock;
-	smcsock->file->f_inode = SOCK_INODE(smcsock); /* replace inode when sock_close */
-	smcsock->file->f_path.dentry->d_inode = SOCK_INODE(smcsock); /* dput() in __fput */
-	tcp->file = NULL;
-
-	return ret;
-}
-
-static void smc_ulp_clone(const struct request_sock *req, struct sock *newsk,
-			  const gfp_t priority)
-{
-	struct inet_connection_sock *icsk = inet_csk(newsk);
-
-	/* don't inherit ulp ops to child when listen */
-	icsk->icsk_ulp_ops = NULL;
-}
-
-static struct tcp_ulp_ops smc_ulp_ops __read_mostly = {
-	.name		= "smc",
-	.owner		= THIS_MODULE,
-	.init		= smc_ulp_init,
-	.clone		= smc_ulp_clone,
-};
-
 unsigned int smc_net_id;
 
 static __net_init int smc_net_init(struct net *net)
@@ -3521,17 +3452,9 @@ static int __init smc_init(void)
 		goto out_sock;
 	}
 
-	rc = tcp_register_ulp(&smc_ulp_ops);
-	if (rc) {
-		pr_err("%s: tcp_ulp_register fails with %d\n", __func__, rc);
-		goto out_ib;
-	}
-
 	static_branch_enable(&tcp_have_smc);
 	return 0;
 
-out_ib:
-	smc_ib_unregister_client();
 out_sock:
 	sock_unregister(PF_SMC);
 out_proto6:
@@ -3561,7 +3484,6 @@ static int __init smc_init(void)
 static void __exit smc_exit(void)
 {
 	static_branch_disable(&tcp_have_smc);
-	tcp_unregister_ulp(&smc_ulp_ops);
 	sock_unregister(PF_SMC);
 	smc_core_exit();
 	smc_ib_unregister_client();
@@ -3585,5 +3507,4 @@ MODULE_AUTHOR("Ursula Braun <ubraun@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("smc socket address family");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_SMC);
-MODULE_ALIAS_TCP_ULP("smc");
 MODULE_ALIAS_GENL_FAMILY(SMC_GENL_FAMILY_NAME);
-- 
2.53.0



