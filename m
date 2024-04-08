Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7B97D07E;
	Mon,  8 Apr 2024 13:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583704; cv=none; b=K/NCy8m0VC+zrpKTltXejV4fGXc1D1qSGGoNHMGtMkHXJbCNeGcjl2FGsg9B6i9P1wbWQlONddbF2gW/FUH1o3D71LHECjHjiqyvXU6oR30Kh5Dm9UxMrA8CaFF92jpnCJW7HB05W7HgvivbpquWE19ZrsGf5M5Bc5SkZ3ZxA40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583704; c=relaxed/simple;
	bh=/hamboRy9zBADc6OtqkfxY8yxxxOUD4r6JCpoQBp6Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rZvsLhQj48qHH7219okNvgjFjy88/GdMeWm0RSVKMYh2TkQ0RQjwfo9EKIk0yy4afZpyDi6g1NrVoyPve56BBYNOWogjwxXExDXnoVFlBvvj4tNJGokIw2E/UmhpkQ0CYl93pLFCaEb0sAz0t8cP9M8Tv/OFmTaAcY5a/YiZOsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DzLxq/6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzLxq/6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17503C433C7;
	Mon,  8 Apr 2024 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583704;
	bh=/hamboRy9zBADc6OtqkfxY8yxxxOUD4r6JCpoQBp6Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzLxq/6HGkh6gNo2KJx+xIp7HFgtT9Or+1G4n7nTkHBRodusBZd2eg2WHdv4d2Reh
	 0O7SnGjtklNnEKrsD9rVJJhua6ASXNHvOhKS5dXGKdkx1QOY72vX/a7cC8BXHi9kha
	 1UzezCHzfH9Pm45WTIvTNAOwVd2VhGzfGB+fiq5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 276/690] SUNRPC: Rename svc_close_xprt()
Date: Mon,  8 Apr 2024 14:52:22 +0200
Message-ID: <20240408125409.609787064@linuxfoundation.org>
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

[ Upstream commit 4355d767a21b9445958fc11bce9a9701f76529d3 ]

Clean up: Use the "svc_xprt_<task>" function naming convention as
is used for other external APIs.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfsctl.c                           | 2 +-
 include/linux/sunrpc/svc_xprt.h            | 2 +-
 net/sunrpc/svc.c                           | 2 +-
 net/sunrpc/svc_xprt.c                      | 9 +++++++--
 net/sunrpc/xprtrdma/svc_rdma_backchannel.c | 2 +-
 5 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 8fec779994f7b..16920e4512bde 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -790,7 +790,7 @@ static ssize_t __write_ports_addxprt(char *buf, struct net *net, const struct cr
 out_close:
 	xprt = svc_find_xprt(nn->nfsd_serv, transport, net, PF_INET, port);
 	if (xprt != NULL) {
-		svc_close_xprt(xprt);
+		svc_xprt_close(xprt);
 		svc_xprt_put(xprt);
 	}
 out_err:
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index 8bcb6ccf32839..30c645583cd06 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -135,7 +135,7 @@ void	svc_xprt_received(struct svc_xprt *xprt);
 void	svc_xprt_enqueue(struct svc_xprt *xprt);
 void	svc_xprt_put(struct svc_xprt *xprt);
 void	svc_xprt_copy_addrs(struct svc_rqst *rqstp, struct svc_xprt *xprt);
-void	svc_close_xprt(struct svc_xprt *xprt);
+void	svc_xprt_close(struct svc_xprt *xprt);
 int	svc_port_is_privileged(struct sockaddr *sin);
 int	svc_print_xprts(char *buf, int maxlen);
 struct	svc_xprt *svc_find_xprt(struct svc_serv *serv, const char *xcl_name,
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 7c7cf0d4ffcb0..6a52942c501c5 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1408,7 +1408,7 @@ svc_process_common(struct svc_rqst *rqstp, struct kvec *argv, struct kvec *resv)
 	svc_authorise(rqstp);
 close_xprt:
 	if (rqstp->rq_xprt && test_bit(XPT_TEMP, &rqstp->rq_xprt->xpt_flags))
-		svc_close_xprt(rqstp->rq_xprt);
+		svc_xprt_close(rqstp->rq_xprt);
 	dprintk("svc: svc_process close\n");
 	return 0;
 
diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
index 87433ce9cb15a..19c11b3253f8d 100644
--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1078,7 +1078,12 @@ static void svc_delete_xprt(struct svc_xprt *xprt)
 	svc_xprt_put(xprt);
 }
 
-void svc_close_xprt(struct svc_xprt *xprt)
+/**
+ * svc_xprt_close - Close a client connection
+ * @xprt: transport to disconnect
+ *
+ */
+void svc_xprt_close(struct svc_xprt *xprt)
 {
 	trace_svc_xprt_close(xprt);
 	set_bit(XPT_CLOSE, &xprt->xpt_flags);
@@ -1093,7 +1098,7 @@ void svc_close_xprt(struct svc_xprt *xprt)
 	 */
 	svc_delete_xprt(xprt);
 }
-EXPORT_SYMBOL_GPL(svc_close_xprt);
+EXPORT_SYMBOL_GPL(svc_xprt_close);
 
 static int svc_close_list(struct svc_serv *serv, struct list_head *xprt_list, struct net *net)
 {
diff --git a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
index 16897fcb659c1..85c8cdda98b18 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_backchannel.c
@@ -198,7 +198,7 @@ static int xprt_rdma_bc_send_request(struct rpc_rqst *rqst)
 
 	ret = rpcrdma_bc_send_request(rdma, rqst);
 	if (ret == -ENOTCONN)
-		svc_close_xprt(sxprt);
+		svc_xprt_close(sxprt);
 	return ret;
 }
 
-- 
2.43.0



