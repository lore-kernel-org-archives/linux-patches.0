Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215994;
	b=spSrbUzTyNF/fyODSd+QMHTXx4+71QiC92jIzfOR1PgA+wvUBBK0J1eLzr5BLEJbpBJH
	 pJAk8W4YfkTLyQcUpPHbcuVmHQYItN/EFcCi7GjDec8PhiUZ1Q8IXaoqLEB4RFbuB62fw
	 6cDvJIbQ1aK4AsWFj8+DUE8T52LG5UmBb+u0XL/9mmZxNDOV7bvHBSgDZ3XeGjm1myy2m
	 qVC0UQ211rjd44v8uJfZqTocmK6bIlGXg6sZeQf3E6FgrA4Lm6PiE9fA+nxS068/vRUxi
	 JW7gwK9UK02by3OiAhLZybQvS7IhLUKEtIklsff+aV+zIq3kEHdkmVpWJcyDp0EcVbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CuDQfdJCLwaSUdAJRlFXvDcl37HO2K7c9mhLyVg7vPg=;
	b=0ECdLL/pBiZ/y2yxISdYzliNuUTHYcexJpRx909uejN0xgMVH/NOhqlKxytXQQ9CXSe9
	 4JmIcWHocJXl+KWx/JC/RkrL8ziRFzWWrhezMd4TFFjE0QpGBkkChWw948jlzffq4mbdp
	 hVMOJ/B6VqFKJ/cm5ulUFyRE7dLSEUEDAvARJTDZ9DfFV3nJrbUC960hLB5UEM7vWcBAN
	 Oz9cGyccFNe6/he785ZJQiyv14HXwZuGEAUtXaI+76bsMldFzR9Oz4WE+lhjG44QgnasX
	 Oz2+aumLpt6oYdONSlIxxOPKZQrZ1Hwn4191QFkiciIJEbUjP4tjFYeA1JbFz7DR71A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GB6PD9KE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5F606A31A;
	Wed, 28 Oct 2026 19:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GB6PD9KE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CEF1F01825;
	Wed, 28 Oct 2026 19:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215993;
	bh=CuDQfdJCLwaSUdAJRlFXvDcl37HO2K7c9mhLyVg7vPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GB6PD9KEzMAoyKGsdekUnYC0WdbRU2rglckLNjYh4n8wQ7xJNB3ryT5DMHzDY+Azn
	 eWdef8UhYDPJky4PvWtNvFDWRI6tswS5Vc/DOR5UZZ8zXDy8s9R9bPGN3u2RaGTmTC
	 ViZd21O11cqXK3A97wt6srYlWUYI4Q+A6CS7OJl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1403/1887] SUNRPC: Rename automatic variables in unwrap_priv_data()
Date: Wed, 28 Oct 2026 17:58:19 +0100
Message-ID: <20261028170531.377637525@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f4a59e822f8116baf51a9fc86590e4391bd542d2 ]

Clean up: To help orient readers, name the stack variables to match
the XDR field names.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: a919c5c88769 ("SUNRPC: svcauth_gss: enforce krb5 token minimum length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/auth_gss/svcauth_gss.c | 38 ++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index ccb38a5406067..07e6b8c5dbe1a 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -983,16 +983,28 @@ fix_priv_head(struct xdr_buf *buf, int pad)
 	}
 }
 
+/*
+ * RFC 2203, Section 5.3.2.3
+ *
+ *	struct rpc_gss_priv_data {
+ *		opaque databody_priv<>
+ *	};
+ *
+ *	struct rpc_gss_data_t {
+ *		unsigned int seq_num;
+ *		proc_req_arg_t arg;
+ *	};
+ */
 static int
-unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gss_ctx *ctx)
+svcauth_gss_unwrap_priv(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq,
+			struct gss_ctx *ctx)
 {
-	u32 priv_len, maj_stat;
+	u32 len, seq_num, maj_stat;
 	int pad, remaining_len, offset;
-	u32 rseqno;
 
 	clear_bit(RQ_SPLICE_OK, &rqstp->rq_flags);
 
-	priv_len = svc_getnl(&buf->head[0]);
+	len = svc_getnl(&buf->head[0]);
 	if (rqstp->rq_deferred) {
 		/* Already decrypted last time through! The sequence number
 		 * check at out_seq is unnecessary but harmless: */
@@ -1002,14 +1014,14 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	 * request to the end, where head[0].iov_len is just the bytes
 	 * not yet read from the head, so these two values are different: */
 	remaining_len = total_buf_len(buf);
-	if (priv_len > remaining_len)
+	if (len > remaining_len)
 		goto unwrap_failed;
-	pad = remaining_len - priv_len;
+	pad = remaining_len - len;
 	buf->len -= pad;
 	fix_priv_head(buf, pad);
 
-	maj_stat = gss_unwrap(ctx, 0, priv_len, buf);
-	pad = priv_len - buf->len;
+	maj_stat = gss_unwrap(ctx, 0, len, buf);
+	pad = len - buf->len;
 	/* The upper layers assume the buffer is aligned on 4-byte boundaries.
 	 * In the krb5p case, at least, the data ends up offset, so we need to
 	 * move it around. */
@@ -1025,8 +1037,8 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	if (maj_stat != GSS_S_COMPLETE)
 		goto bad_unwrap;
 out_seq:
-	rseqno = svc_getnl(&buf->head[0]);
-	if (rseqno != seq)
+	seq_num = svc_getnl(&buf->head[0]);
+	if (seq_num != seq)
 		goto bad_seqno;
 	return 0;
 
@@ -1034,7 +1046,7 @@ unwrap_priv_data(struct svc_rqst *rqstp, struct xdr_buf *buf, u32 seq, struct gs
 	trace_rpcgss_svc_unwrap_failed(rqstp);
 	return -EINVAL;
 bad_seqno:
-	trace_rpcgss_svc_seqno_bad(rqstp, seq, rseqno);
+	trace_rpcgss_svc_seqno_bad(rqstp, seq, seq_num);
 	return -EINVAL;
 bad_unwrap:
 	trace_rpcgss_svc_unwrap(rqstp, maj_stat);
@@ -1652,8 +1664,8 @@ svcauth_gss_accept(struct svc_rqst *rqstp)
 			/* placeholders for length and seq. number: */
 			svc_putnl(resv, 0);
 			svc_putnl(resv, 0);
-			if (unwrap_priv_data(rqstp, &rqstp->rq_arg,
-					gc->gc_seq, rsci->mechctx))
+			if (svcauth_gss_unwrap_priv(rqstp, &rqstp->rq_arg,
+						    gc->gc_seq, rsci->mechctx))
 				goto garbage_args;
 			rqstp->rq_auth_slack = RPC_MAX_AUTH_SIZE * 2;
 			break;
-- 
2.53.0



