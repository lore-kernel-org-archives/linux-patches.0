Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF09E7C6C8;
	Mon,  8 Apr 2024 13:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583696; cv=none; b=f6XFPs0ZTei/W5HWQb0+qO6iSKdLuRqPSpevkVDh/Zu23X6QJb3/GTaFBDXrq8DmXYcauuT2wt9U3Xf9vlR1tqkcR+eOdfd9EjlfxCKNkPmMHU445mtm7RxkQktUytXfDK8wt+g3Y/BANQCjxDKS3mx+PCoyRW9Q77CCkHFd4XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583696; c=relaxed/simple;
	bh=adM++6lCQH0JErvLWDMowsP5s/feEwJ5HVctGiNbV5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AX9J0/bKwAlWQ5KgjR3n2HIqH/wY782/DFCdSiHlP2694JtlA8DzatAAkI/KYbLEICszPMoL6KhHglffASB7Z3ba0rUGXbFnRKRDE0k3hZIccqW6tMwKFnChd70D5qmTGpG0Gzh9xDQt7S7p4h9knmF2EfHPSv/1n4Ks+n/0ep8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9yLvIiF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9yLvIiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657A1C433F1;
	Mon,  8 Apr 2024 13:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583695;
	bh=adM++6lCQH0JErvLWDMowsP5s/feEwJ5HVctGiNbV5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9yLvIiF/ubaW5rgx7BL2d0PlE7sPbW6K+ZjN4y17I+RXX35M/JGwZVHS49WgLca8
	 GETEuMERi7ip8AG18T3zjCbUgSri/VQIdk3UgkPSSYUlFFYcGkSVRDWEAwO5iWsCWD
	 gaY0ezmB+gSKntNCaLwJT95MWXSJRT2eS0IxbcJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 275/690] SUNRPC: Rename svc_create_xprt()
Date: Mon,  8 Apr 2024 14:52:21 +0200
Message-ID: <20240408125409.578944576@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 352ad31448fecc78a2e9b78da64eea5d63b8d0ce ]

Clean up: Use the "svc_xprt_<task>" function naming convention as
is used for other external APIs.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svc.c                  |  4 ++--
 fs/nfs/callback.c               | 12 ++++++------
 fs/nfsd/nfsctl.c                |  8 ++++----
 fs/nfsd/nfssvc.c                |  8 ++++----
 include/linux/sunrpc/svc_xprt.h |  7 ++++---
 net/sunrpc/svc_xprt.c           | 24 +++++++++++++++++++-----
 6 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/lockd/svc.c b/fs/lockd/svc.c
index f5b688a844aa5..bba6f2b45b64a 100644
--- a/fs/lockd/svc.c
+++ b/fs/lockd/svc.c
@@ -197,8 +197,8 @@ static int create_lockd_listener(struct svc_serv *serv, const char *name,
 
 	xprt = svc_find_xprt(serv, name, net, family, 0);
 	if (xprt == NULL)
-		return svc_create_xprt(serv, name, net, family, port,
-						SVC_SOCK_DEFAULTS, cred);
+		return svc_xprt_create(serv, name, net, family, port,
+				       SVC_SOCK_DEFAULTS, cred);
 	svc_xprt_put(xprt);
 	return 0;
 }
diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
index 7a810f8850632..c1a8767100ae9 100644
--- a/fs/nfs/callback.c
+++ b/fs/nfs/callback.c
@@ -45,18 +45,18 @@ static int nfs4_callback_up_net(struct svc_serv *serv, struct net *net)
 	int ret;
 	struct nfs_net *nn = net_generic(net, nfs_net_id);
 
-	ret = svc_create_xprt(serv, "tcp", net, PF_INET,
-				nfs_callback_set_tcpport, SVC_SOCK_ANONYMOUS,
-				cred);
+	ret = svc_xprt_create(serv, "tcp", net, PF_INET,
+			      nfs_callback_set_tcpport, SVC_SOCK_ANONYMOUS,
+			      cred);
 	if (ret <= 0)
 		goto out_err;
 	nn->nfs_callback_tcpport = ret;
 	dprintk("NFS: Callback listener port = %u (af %u, net %x)\n",
 		nn->nfs_callback_tcpport, PF_INET, net->ns.inum);
 
-	ret = svc_create_xprt(serv, "tcp", net, PF_INET6,
-				nfs_callback_set_tcpport, SVC_SOCK_ANONYMOUS,
-				cred);
+	ret = svc_xprt_create(serv, "tcp", net, PF_INET6,
+			      nfs_callback_set_tcpport, SVC_SOCK_ANONYMOUS,
+			      cred);
 	if (ret > 0) {
 		nn->nfs_callback_tcpport6 = ret;
 		dprintk("NFS: Callback listener port = %u (af %u, net %x)\n",
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 68b020f2002b7..8fec779994f7b 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -772,13 +772,13 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 	if (err != 0)
 		return err;
 
-	err = svc_create_xprt(nn->nfsd_serv, transport, net,
-				PF_INET, port, SVC_SOCK_ANONYMOUS, cred);
+	err = svc_xprt_create(nn->nfsd_serv, transport, net,
+			      PF_INET, port, SVC_SOCK_ANONYMOUS, cred);
 	if (err < 0)
 		goto out_err;
 
-	err = svc_create_xprt(nn->nfsd_serv, transport, net,
-				PF_INET6, port, SVC_SOCK_ANONYMOUS, cred);
+	err = svc_xprt_create(nn->nfsd_serv, transport, net,
+			      PF_INET6, port, SVC_SOCK_ANONYMOUS, cred);
 	if (err < 0 && err != -EAFNOSUPPORT)
 		goto out_close;
 
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index a1765e751b739..5790b1eaff72b 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -293,13 +293,13 @@ static int nfsd_init_socks(struct net *net, const struct cred *cred)
 	if (!list_empty(&nn->nfsd_serv->sv_permsocks))
 		return 0;
 
-	error = svc_create_xprt(nn->nfsd_serv, "udp", net, PF_INET, NFS_PORT,
-					SVC_SOCK_DEFAULTS, cred);
+	error = svc_xprt_create(nn->nfsd_serv, "udp", net, PF_INET, NFS_PORT,
+				SVC_SOCK_DEFAULTS, cred);
 	if (error < 0)
 		return error;
 
-	error = svc_create_xprt(nn->nfsd_serv, "tcp", net, PF_INET, NFS_PORT,
-					SVC_SOCK_DEFAULTS, cred);
+	error = svc_xprt_create(nn->nfsd_serv, "tcp", net, PF_INET, NFS_PORT,
+				SVC_SOCK_DEFAULTS, cred);
 	if (error < 0)
 		return error;
 
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 05a3ccd837f57..8bcb6ccf32839 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -127,9 +127,10 @@ int	svc_reg_xprt_class(struct svc_xprt_class *);
 void	svc_unreg_xprt_class(struct svc_xprt_class *);
 void	svc_xprt_init(struct net *, struct svc_xprt_class *, struct svc_xprt *,
 		      struct svc_serv *);
-int	svc_create_xprt(struct svc_serv *, const char *, struct net *,
-			const int, const unsigned short, int,
-			const struct cred *);
+int	svc_xprt_create(struct svc_serv *serv, const char *xprt_name,
+			struct net *net, const int family,
+			const unsigned short port, int flags,
+			const struct cred *cred);
 void	svc_xprt_received(struct svc_xprt *xprt);
 void	svc_xprt_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_put(struct svc_xprt *xprt);
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 5a6d4ccb4a607..87433ce9cb15a 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -286,7 +286,7 @@ void svc_add_new_perm_xprt(struct svc_serv *serv, struct svc_xprt *new)
 	svc_xprt_received(new);
 }
 
-static int _svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
+static int _svc_xprt_create(struct svc_serv *serv, const char *xprt_name,
 			    struct net *net, const int family,
 			    const unsigned short port, int flags,
 			    const struct cred *cred)
@@ -322,21 +322,35 @@ static int _svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
 	return -EPROTONOSUPPORT;
 }
 
-int svc_create_xprt(struct svc_serv *serv, const char *xprt_name,
+/**
+ * svc_xprt_create - Add a new listener to @serv
+ * @serv: target RPC service
+ * @xprt_name: transport class name
+ * @net: network namespace
+ * @family: network address family
+ * @port: listener port
+ * @flags: SVC_SOCK flags
+ * @cred: credential to bind to this transport
+ *
+ * Return values:
+ *   %0: New listener added successfully
+ *   %-EPROTONOSUPPORT: Requested transport type not supported
+ */
+int svc_xprt_create(struct svc_serv *serv, const char *xprt_name,
 		    struct net *net, const int family,
 		    const unsigned short port, int flags,
 		    const struct cred *cred)
 {
 	int err;
 
-	err = _svc_create_xprt(serv, xprt_name, net, family, port, flags, cred);
+	err = _svc_xprt_create(serv, xprt_name, net, family, port, flags, cred);
 	if (err == -EPROTONOSUPPORT) {
 		request_module("svc%s", xprt_name);
-		err = _svc_create_xprt(serv, xprt_name, net, family, port, flags, cred);
+		err = _svc_xprt_create(serv, xprt_name, net, family, port, flags, cred);
 	}
 	return err;
 }
-EXPORT_SYMBOL_GPL(svc_create_xprt);
+EXPORT_SYMBOL_GPL(svc_xprt_create);
 
 /*
  * Copy the local and remote xprt addresses to the rqstp structure
-- 
2.43.0



