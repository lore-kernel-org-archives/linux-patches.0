Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375881A3BB1;
	Tue, 18 Jun 2024 12:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714453; cv=none; b=QsK5PgHvIgZah4AHxB0E3dBp3yjlb6Tm4hdSomZdOqTpNRarHLNrlEyoGUdcwvyBzJXLUtSPz9IBxSQuVh0n1vnIUGsX27ZlHqCsMokmFqlYx4myYWRtokdeaMWVRvZyqYQFQc/bRg9868jBGyIblb86RRR+2ATi2MDhuP7lFmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714453; c=relaxed/simple;
	bh=Y+U89oqjlGFFCZFizQa0PzJInSQPPd12bb7CRK3ncWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rg9UMdnDLT9T1zDqsSSR7e3oLC/vfRi+MwxTga24DzC6mYlkF7sGZnaVULtIhKmX5r8oazEfruxkQDKDwBQwNrwXklG6w+8BucyHNs5SGA21M+k0FRMgkFIh/XN/0Bt//3P8KoCgkXQY9ZRQdLD0LkIeSSfP5EXeEojEe5WKklg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZN5Gy11r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZN5Gy11r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F9EC4AF1D;
	Tue, 18 Jun 2024 12:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714452;
	bh=Y+U89oqjlGFFCZFizQa0PzJInSQPPd12bb7CRK3ncWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZN5Gy11rPE23RR/6IYeYwriigtwb7VZNcp8Z8gPkamaTO72ORHmB4c57jMI70c6/A
	 wq063wHuOR+jWDOhKirVkPqGJEbUvLZDFz/IOFeNeqI2e99tCfKQZ1xBLeDYSELBD1
	 X4ffhbnOnNDOI0jlj8i9rAXaw4M5yyHJm5na5EOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 001/770] SUNRPC: Rename svc_encode_read_payload()
Date: Tue, 18 Jun 2024 14:27:34 +0200
Message-ID: <20240618123407.343723661@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 03493bca084fdca48abc59b00e06ce733aa9eb7d ]

Clean up: "result payload" is a less confusing name for these
payloads. "READ payload" reflects only the NFS usage.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c                        |  2 +-
 include/linux/sunrpc/svc.h               |  6 +++---
 include/linux/sunrpc/svc_rdma.h          |  4 ++--
 include/linux/sunrpc/svc_xprt.h          |  4 ++--
 net/sunrpc/svc.c                         | 11 ++++++-----
 net/sunrpc/svcsock.c                     |  8 ++++----
 net/sunrpc/xprtrdma/svc_rdma_sendto.c    |  8 ++++----
 net/sunrpc/xprtrdma/svc_rdma_transport.c |  2 +-
 8 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index dbfa24cf33906..9971d3c295731 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3843,7 +3843,7 @@ static __be32 nfsd4_encode_readv(struct nfsd4_compoundres *resp,
 	read->rd_length = maxcount;
 	if (nfserr)
 		return nfserr;
-	if (svc_encode_read_payload(resp->rqstp, starting_len + 8, maxcount))
+	if (svc_encode_result_payload(resp->rqstp, starting_len + 8, maxcount))
 		return nfserr_io;
 	xdr_truncate_encode(xdr, starting_len + 8 + xdr_align_size(maxcount));
 
diff --git a/include/linux/sunrpc/svc.h b/include/linux/sunrpc/svc.h
index 386628b36bc75..c220b734fa69e 100644
--- a/include/linux/sunrpc/svc.h
+++ b/include/linux/sunrpc/svc.h
@@ -519,9 +519,9 @@ void		   svc_wake_up(struct svc_serv *);
 void		   svc_reserve(struct svc_rqst *rqstp, int space);
 struct svc_pool *  svc_pool_for_cpu(struct svc_serv *serv, int cpu);
 char *		   svc_print_addr(struct svc_rqst *, char *, size_t);
-int		   svc_encode_read_payload(struct svc_rqst *rqstp,
-					   unsigned int offset,
-					   unsigned int length);
+int		   svc_encode_result_payload(struct svc_rqst *rqstp,
+					     unsigned int offset,
+					     unsigned int length);
 unsigned int	   svc_fill_write_vector(struct svc_rqst *rqstp,
 					 struct page **pages,
 					 struct kvec *first, size_t total);
diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index 9dc3a3b88391b..2b870a3f391b1 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -207,8 +207,8 @@ extern void svc_rdma_send_error_msg(struct svcxprt_rdma *rdma,
 				    struct svc_rdma_recv_ctxt *rctxt,
 				    int status);
 extern int svc_rdma_sendto(struct svc_rqst *);
-extern int svc_rdma_read_payload(struct svc_rqst *rqstp, unsigned int offset,
-				 unsigned int length);
+extern int svc_rdma_result_payload(struct svc_rqst *rqstp, unsigned int offset,
+				   unsigned int length);
 
 /* svc_rdma_transport.c */
 extern struct svc_xprt_class svc_rdma_class;
diff --git a/include/linux/sunrpc/svc_xprt.h b/include/linux/sunrpc/svc_xprt.h
index aca35ab5cff24..92455e0d52445 100644
--- a/include/linux/sunrpc/svc_xprt.h
+++ b/include/linux/sunrpc/svc_xprt.h
@@ -21,8 +21,8 @@ struct svc_xprt_ops {
 	int		(*xpo_has_wspace)(struct svc_xprt *);
 	int		(*xpo_recvfrom)(struct svc_rqst *);
 	int		(*xpo_sendto)(struct svc_rqst *);
-	int		(*xpo_read_payload)(struct svc_rqst *, unsigned int,
-					    unsigned int);
+	int		(*xpo_result_payload)(struct svc_rqst *, unsigned int,
+					      unsigned int);
 	void		(*xpo_release_rqst)(struct svc_rqst *);
 	void		(*xpo_detach)(struct svc_xprt *);
 	void		(*xpo_free)(struct svc_xprt *);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index cfe8b911ca013..e4e4e203ecdad 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1626,7 +1626,7 @@ u32 svc_max_payload(const struct svc_rqst *rqstp)
 EXPORT_SYMBOL_GPL(svc_max_payload);
 
 /**
- * svc_encode_read_payload - mark a range of bytes as a READ payload
+ * svc_encode_result_payload - mark a range of bytes as a result payload
  * @rqstp: svc_rqst to operate on
  * @offset: payload's byte offset in rqstp->rq_res
  * @length: size of payload, in bytes
@@ -1634,12 +1634,13 @@ EXPORT_SYMBOL_GPL(svc_max_payload);
  * Returns zero on success, or a negative errno if a permanent
  * error occurred.
  */
-int svc_encode_read_payload(struct svc_rqst *rqstp, unsigned int offset,
-			    unsigned int length)
+int svc_encode_result_payload(struct svc_rqst *rqstp, unsigned int offset,
+			      unsigned int length)
 {
-	return rqstp->rq_xprt->xpt_ops->xpo_read_payload(rqstp, offset, length);
+	return rqstp->rq_xprt->xpt_ops->xpo_result_payload(rqstp, offset,
+							   length);
 }
-EXPORT_SYMBOL_GPL(svc_encode_read_payload);
+EXPORT_SYMBOL_GPL(svc_encode_result_payload);
 
 /**
  * svc_fill_write_vector - Construct data argument for VFS write call
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 3d5ee042c5015..90f6231d6ed67 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -181,8 +181,8 @@ static void svc_set_cmsg_data(struct svc_rqst *rqstp, struct cmsghdr *cmh)
 	}
 }
 
-static int svc_sock_read_payload(struct svc_rqst *rqstp, unsigned int offset,
-				 unsigned int length)
+static int svc_sock_result_payload(struct svc_rqst *rqstp, unsigned int offset,
+				   unsigned int length)
 {
 	return 0;
 }
@@ -635,7 +635,7 @@ static const struct svc_xprt_ops svc_udp_ops = {
 	.xpo_create = svc_udp_create,
 	.xpo_recvfrom = svc_udp_recvfrom,
 	.xpo_sendto = svc_udp_sendto,
-	.xpo_read_payload = svc_sock_read_payload,
+	.xpo_result_payload = svc_sock_result_payload,
 	.xpo_release_rqst = svc_udp_release_rqst,
 	.xpo_detach = svc_sock_detach,
 	.xpo_free = svc_sock_free,
@@ -1209,7 +1209,7 @@ static const struct svc_xprt_ops svc_tcp_ops = {
 	.xpo_create = svc_tcp_create,
 	.xpo_recvfrom = svc_tcp_recvfrom,
 	.xpo_sendto = svc_tcp_sendto,
-	.xpo_read_payload = svc_sock_read_payload,
+	.xpo_result_payload = svc_sock_result_payload,
 	.xpo_release_rqst = svc_tcp_release_rqst,
 	.xpo_detach = svc_tcp_sock_detach,
 	.xpo_free = svc_sock_free,
diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index c3d588b149aaa..c8411b4f3492a 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -979,19 +979,19 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 }
 
 /**
- * svc_rdma_read_payload - special processing for a READ payload
+ * svc_rdma_result_payload - special processing for a result payload
  * @rqstp: svc_rqst to operate on
  * @offset: payload's byte offset in @xdr
  * @length: size of payload, in bytes
  *
  * Returns zero on success.
  *
- * For the moment, just record the xdr_buf location of the READ
+ * For the moment, just record the xdr_buf location of the result
  * payload. svc_rdma_sendto will use that location later when
  * we actually send the payload.
  */
-int svc_rdma_read_payload(struct svc_rqst *rqstp, unsigned int offset,
-			  unsigned int length)
+int svc_rdma_result_payload(struct svc_rqst *rqstp, unsigned int offset,
+			    unsigned int length)
 {
 	struct svc_rdma_recv_ctxt *rctxt = rqstp->rq_xprt_ctxt;
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 5f7e3d12523fe..c895f80df659c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -80,7 +80,7 @@ static const struct svc_xprt_ops svc_rdma_ops = {
 	.xpo_create = svc_rdma_create,
 	.xpo_recvfrom = svc_rdma_recvfrom,
 	.xpo_sendto = svc_rdma_sendto,
-	.xpo_read_payload = svc_rdma_read_payload,
+	.xpo_result_payload = svc_rdma_result_payload,
 	.xpo_release_rqst = svc_rdma_release_rqst,
 	.xpo_detach = svc_rdma_detach,
 	.xpo_free = svc_rdma_free,
-- 
2.43.0



