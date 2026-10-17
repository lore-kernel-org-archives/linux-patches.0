Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D58B3A0B38;
	Sat, 17 Oct 2026 17:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259674; cv=none; b=RsXJxXORutU1GUe2t/BQyoEEp5JGnJxlNmqqssLi0AhcHvP03x5NGcouFu2AK/p09QeCl36Z9NiyLnEnMmHsYAwvQsP8hn6JEu9LhECYVc+zSmtw5amWPVmWtdWJ2VpfINJAn0X8ECG7gCp+Km7sySAiL+hCW07ZiZiKvD+T89c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259674; c=relaxed/simple;
	bh=CmsRj3VBPobUdfugvpd5l77NmXIGSufLf7+XJHBgTEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Er4mFzS/neHkv2XfWJKWPScUMuZpii/hsiL9rK7TMBvP98bnVrQQlKxsOvGzpESToUB/kZjOD1w0GnO21UVwr8WMlKup9neEnATrep2Yt6yf5Gi8hRk7LyH++QacPqso/qQW/fAEP6hahdAb1q71+DkRsYWdMKlhp7Vi7NYyKLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PqF3mMZ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PqF3mMZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5EF1F000C4;
	Sat, 17 Oct 2026 17:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259672;
	bh=kyCDIQjaFiYsxatifjlE6U9H2R//oHVIdeFFZMLkwQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PqF3mMZ0L5zoW/vZo3N+s7Th90/8EO/t/atq47gEXNmIYZmw8g19sD53E7456cv7q
	 DsyVWUhy1939LRVpadRzDzvg4YUhRxMvqEGJv+bezUAHZ9HSu1AzDGEhICBiSSdjLT
	 w3LRGCEYvht0aNl7Ub8hQKDVHngXr4EMsxcn3X9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1293/1674] SUNRPC: make various functions static, or not exported.
Date: Sat, 17 Oct 2026 17:59:25 +0200
Message-ID: <20261017160504.333292210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit f2b27e1d72527f94f030b6356b3187576e60885b ]

Various functions are only used within the sunrpc module, and several
are only use in the one file.  So clean up:

These are marked static, and any EXPORT is removed.
  svc_rcpb_setup()
  svc_rqst_alloc()
  svc_rqst_free()  - also moved before first use
  svc_rpcbind_set_version()
  svc_drop() - also moved to svc.c

These are now not EXPORTed, but are not static.
  svc_authenticate()
  svc_sock_update_bufs()

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: c479bde671cb ("sunrpc: defer rq_argp and rq_resp free until after RCU grace period")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc.h     |  9 -------
 include/linux/sunrpc/svcauth.h |  1 -
 include/linux/sunrpc/svcsock.h |  2 --
 net/sunrpc/sunrpc.h            |  4 +++
 net/sunrpc/svc.c               | 48 ++++++++++++++++++----------------
 net/sunrpc/svc_xprt.c          |  9 -------
 net/sunrpc/svcauth.c           |  1 -
 net/sunrpc/svcsock.c           |  1 -
 8 files changed, 29 insertions(+), 46 deletions(-)

diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index d4558fefd9b4e..e1afc35e961d1 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -397,17 +397,13 @@ struct svc_procedure {
  */
 int sunrpc_set_pool_mode(const char *val);
 int sunrpc_get_pool_mode(char *val, size_t size);
-int svc_rpcb_setup(struct svc_serv *serv, struct net *net);
 void svc_rpcb_cleanup(struct svc_serv *serv, struct net *net);
 int svc_bind(struct svc_serv *serv, struct net *net);
 struct svc_serv *svc_create(struct svc_program *, unsigned int,
 			    int (*threadfn)(void *data));
-struct svc_rqst *svc_rqst_alloc(struct svc_serv *serv,
-					struct svc_pool *pool, int node);
 bool		   svc_rqst_replace_page(struct svc_rqst *rqstp,
 					 struct page *page);
 void		   svc_rqst_release_pages(struct svc_rqst *rqstp);
-void		   svc_rqst_free(struct svc_rqst *);
 void		   svc_exit_thread(struct svc_rqst *);
 struct svc_serv *  svc_create_pooled(struct svc_program *prog,
 				     struct svc_stat *stats,
@@ -443,11 +439,6 @@ int		   svc_generic_rpcbind_set(struct net *net,
 					   u32 version, int family,
 					   unsigned short proto,
 					   unsigned short port);
-int		   svc_rpcbind_set_version(struct net *net,
-					   const struct svc_program *progp,
-					   u32 version, int family,
-					   unsigned short proto,
-					   unsigned short port);
 
 #define	RPC_MAX_ADDRBUFLEN	(63U)
 
diff --git a/include/linux/sunrpc/svcauth.h b/include/linux/sunrpc/svcauth.h
index 61c455f1e1f50..63cf6fb26dcc1 100644
--- a/include/linux/sunrpc/svcauth.h
+++ b/include/linux/sunrpc/svcauth.h
@@ -151,7 +151,6 @@ struct auth_ops {
 
 struct svc_xprt;
 
-extern enum svc_auth_status svc_authenticate(struct svc_rqst *rqstp);
 extern rpc_authflavor_t svc_auth_flavor(struct svc_rqst *rqstp);
 extern int	svc_authorise(struct svc_rqst *rqstp);
 extern enum svc_auth_status svc_set_client(struct svc_rqst *rqstp);
diff --git a/include/linux/sunrpc/svcsock.h b/include/linux/sunrpc/svcsock.h
index 9e6ecc3526e77..01a547fa447cf 100644
--- a/include/linux/sunrpc/svcsock.h
+++ b/include/linux/sunrpc/svcsock.h
@@ -61,8 +61,6 @@ static inline u32 svc_sock_final_rec(struct svc_sock *svsk)
  */
 void		svc_recv(struct svc_rqst *rqstp);
 void		svc_send(struct svc_rqst *rqstp);
-void		svc_drop(struct svc_rqst *);
-void		svc_sock_update_bufs(struct svc_serv *serv);
 int		svc_addsock(struct svc_serv *serv, struct net *net,
 			    const int fd, char *name_return, const size_t len,
 			    const struct cred *cred);
diff --git a/net/sunrpc/sunrpc.h b/net/sunrpc/sunrpc.h
index d4a362c9e4b3b..e3c6e3b63f0ba 100644
--- a/net/sunrpc/sunrpc.h
+++ b/net/sunrpc/sunrpc.h
@@ -36,7 +36,11 @@ static inline int sock_is_loopback(struct sock *sk)
 	return loopback;
 }
 
+struct svc_serv;
+struct svc_rqst;
 int rpc_clients_notifier_register(void);
 void rpc_clients_notifier_unregister(void);
 void auth_domain_cleanup(void);
+void svc_sock_update_bufs(struct svc_serv *serv);
+enum svc_auth_status svc_authenticate(struct svc_rqst *rqstp);
 #endif /* _NET_SUNRPC_SUNRPC_H */
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 68f31611c22cc..a5e73b6959373 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -32,6 +32,7 @@
 #include <trace/events/sunrpc.h>
 
 #include "fail.h"
+#include "sunrpc.h"
 
 #define RPCDBG_FACILITY	RPCDBG_SVCDSP
 
@@ -458,7 +459,7 @@ struct svc_pool *svc_pool_for_cpu(struct svc_serv *serv)
 	return &serv->sv_pools[pidx];
 }
 
-int svc_rpcb_setup(struct svc_serv *serv, struct net *net)
+static int svc_rpcb_setup(struct svc_serv *serv, struct net *net)
 {
 	int err;
 
@@ -470,7 +471,6 @@ int svc_rpcb_setup(struct svc_serv *serv, struct net *net)
 	svc_unregister(serv, net);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(svc_rpcb_setup);
 
 void svc_rpcb_cleanup(struct svc_serv *serv, struct net *net)
 {
@@ -737,7 +737,20 @@ svc_release_buffer(struct svc_rqst *rqstp)
 			put_page(rqstp->rq_pages[i]);
 }
 
-struct svc_rqst *
+static void
+svc_rqst_free(struct svc_rqst *rqstp)
+{
+	folio_batch_release(&rqstp->rq_fbatch);
+	svc_release_buffer(rqstp);
+	if (rqstp->rq_scratch_page)
+		put_page(rqstp->rq_scratch_page);
+	kfree(rqstp->rq_resp);
+	kfree(rqstp->rq_argp);
+	kfree(rqstp->rq_auth_data);
+	kfree_rcu(rqstp, rq_rcu_head);
+}
+
+static struct svc_rqst *
 svc_rqst_alloc(struct svc_serv *serv, struct svc_pool *pool, int node)
 {
 	struct svc_rqst	*rqstp;
@@ -772,7 +785,6 @@ svc_rqst_alloc(struct svc_serv *serv, struct svc_pool *pool, int node)
 	svc_rqst_free(rqstp);
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(svc_rqst_alloc);
 
 static struct svc_rqst *
 svc_prepare_thread(struct svc_serv *serv, struct svc_pool *pool, int node)
@@ -1006,24 +1018,6 @@ void svc_rqst_release_pages(struct svc_rqst *rqstp)
 	}
 }
 
-/*
- * Called from a server thread as it's exiting. Caller must hold the "service
- * mutex" for the service.
- */
-void
-svc_rqst_free(struct svc_rqst *rqstp)
-{
-	folio_batch_release(&rqstp->rq_fbatch);
-	svc_release_buffer(rqstp);
-	if (rqstp->rq_scratch_page)
-		put_page(rqstp->rq_scratch_page);
-	kfree(rqstp->rq_resp);
-	kfree(rqstp->rq_argp);
-	kfree(rqstp->rq_auth_data);
-	kfree_rcu(rqstp, rq_rcu_head);
-}
-EXPORT_SYMBOL_GPL(svc_rqst_free);
-
 void
 svc_exit_thread(struct svc_rqst *rqstp)
 {
@@ -1173,6 +1167,7 @@ static int __svc_register(struct net *net, const char *progname,
 	return error;
 }
 
+static
 int svc_rpcbind_set_version(struct net *net,
 			    const struct svc_program *progp,
 			    u32 version, int family,
@@ -1183,7 +1178,6 @@ int svc_rpcbind_set_version(struct net *net,
 				version, family, proto, port);
 
 }
-EXPORT_SYMBOL_GPL(svc_rpcbind_set_version);
 
 int svc_generic_rpcbind_set(struct net *net,
 			    const struct svc_program *progp,
@@ -1596,6 +1590,14 @@ svc_process_common(struct svc_rqst *rqstp)
 	goto sendit;
 }
 
+/*
+ * Drop request
+ */
+static void svc_drop(struct svc_rqst *rqstp)
+{
+	trace_svc_drop(rqstp);
+}
+
 /**
  * svc_process - Execute one RPC transaction
  * @rqstp: RPC transaction context
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 5440d6b50efa5..f44bba40fcf76 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -874,15 +874,6 @@ void svc_recv(struct svc_rqst *rqstp)
 }
 EXPORT_SYMBOL_GPL(svc_recv);
 
-/*
- * Drop request
- */
-void svc_drop(struct svc_rqst *rqstp)
-{
-	trace_svc_drop(rqstp);
-}
-EXPORT_SYMBOL_GPL(svc_drop);
-
 /**
  * svc_send - Return reply to client
  * @rqstp: RPC transaction context
diff --git a/net/sunrpc/svcauth.c b/net/sunrpc/svcauth.c
index 1619211f0960a..93d9e949e2652 100644
--- a/net/sunrpc/svcauth.c
+++ b/net/sunrpc/svcauth.c
@@ -98,7 +98,6 @@ enum svc_auth_status svc_authenticate(struct svc_rqst *rqstp)
 	rqstp->rq_authop = aops;
 	return aops->accept(rqstp);
 }
-EXPORT_SYMBOL_GPL(svc_authenticate);
 
 /**
  * svc_set_client - Assign an appropriate 'auth_domain' as the client
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 2c22677563330..e3010eb060930 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1435,7 +1435,6 @@ void svc_sock_update_bufs(struct svc_serv *serv)
 		set_bit(XPT_CHNGBUF, &svsk->sk_xprt.xpt_flags);
 	spin_unlock_bh(&serv->sv_lock);
 }
-EXPORT_SYMBOL_GPL(svc_sock_update_bufs);
 
 /*
  * Initialize socket for RPC use and create svc_sock struct
-- 
2.53.0



