Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035552;
	b=UFbTjzHbizuiBt3bjeVPwwb+Tiua+9/LGM90RE56wm7qD557iG0LEhP+baE09XaoTGOF
	 nnJilhv4cYqGRIcDE7FdeTl7serSu+qgaClxflNtuL3j8UzpLyKejAum828hYcvDwbz78
	 e98p1PRKTSMRIsskZR5dF++YM5kkaT+JAkbqU1hPnE5zoVvOtoovBKvsWG5hy+pN+dtjM
	 oEdhfz6sLzW8fUxw+5WoXN8pkwCEAW4CsMKb0yCKFLFo1ffEGUgAb15TdmRbMkXO52xHe
	 uECCpWy5Sv7cb/w+sTlmhykU50gGIWjuidpqjFcvkaH7fyVA0GZ44JvtuvMHMF99TMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z5uV7TpgKuakQG0cPf0KacmwEY3/w5FR1Er1JE/7iY8=;
	b=zO6O08fcUKv3nJXLfHGaaSQPx+2vJWdChK/V0Smz+8nmDy3EJeSOfb7dnpm1H3RfLlj7
	 5VFEGltI9fcU2C4mnc6G056qbKUjBSHjCKeWdcetnj/A1M47WxwScFZqIqFJZ1WfE7NWi
	 lp4yjZOHYcAhPT6EHAbZWoQbEn1VOOIBIzEgR9NzRd2eVHrkNl5gW3SJd3YumMdr0BmvN
	 hmdWGhDsQTCXKE3Zkb1xmpQmzsxcxrVxRul9DXdHheA46M8apzImztbx0V2wfSlVhlKk0
	 oZQoKlKWdwnpQXRvwIrhwlT3cNzJY6ijW7zUZ8Hwj5axOe+/hs0G5aQFy65nukuWEtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1/58lB95";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D682606A31C;
	Wed, 18 Nov 2026 20:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1/58lB95
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBFE01F000C4;
	Wed, 18 Nov 2026 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035552;
	bh=Z5uV7TpgKuakQG0cPf0KacmwEY3/w5FR1Er1JE/7iY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1/58lB95wigOUFD1Mygdg7daauijJzeJyFlLOu99k7fs8qLCpUGrb/PJ9M5ho07+H
	 V0/wPK9TUR4LE0pf7lxtbkNJ5ctiZvRh/gGGJQAA1ZWMCH1ViolLt1abrGCEt9TF8X
	 +ghnbith28gqMR9g5Iqia5pvyU/VU6Iz85yzKXXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0699/3318] SUNRPC: Copy the deferred RPC Call from the head buffer
Date: Wed, 18 Nov 2026 15:22:01 +0100
Message-ID: <20261118150339.322088292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

commit 2192a56b0686599358909c3e12e9a366f5b5d452 upstream.

svc_defer() snapshots the RPC Call for replay once a pending cache
upcall resolves. It copies the Call starting (rq_arg.len -
head[0].iov_len) bytes before head[0].iov_base, a back-up that once
covered a transport header. No transport has had one since commit
983084b2672c ("SUNRPC: Remove svc_rqst::rq_xprt_hlen"), so the two
lengths are meant to be equal.

An RPCSEC_GSS Call breaks that assumption. Unwrapping the integrity
service truncates rq_arg.len by the length of the trailing checksum,
and unwrapping the privacy service leaves rq_arg.len short by an
amount the client sets with trailing bytes after the wrap token.
Neither adjusts head[0].iov_len. Both lengths are size_t, so the
subtraction underflows and the copy starts past head[0].iov_base.
Every deferred integrity Call replays a shifted snapshot.

A deferred replay skips GSS verification, so a shifted snapshot runs
as an authenticated Call. With the privacy service the offset is
client-chosen. A forged Call placed in that window, naming another
user's GSS context handle, runs under that identity.

Copy the Call from head[0].iov_base. Refuse to defer a Call whose
length runs past the head buffer, so the copy cannot read out of
bounds.

Fixes: 260c1d1298f6 ("svc: Add transport hdr size for defer/revisit")
Cc: stable@vger.kernel.org
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Reported-by: Yilin Zhang <yilinzhang@moonshot.ai>
Link: https://patch.msgid.link/20260902133101.48914-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svc_xprt.c |   22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

--- a/net/sunrpc/svc_xprt.c
+++ b/net/sunrpc/svc_xprt.c
@@ -1171,13 +1171,8 @@ static void svc_revisit(struct cache_def
 }
 
 /*
- * Save the request off for later processing. The request buffer looks
- * like this:
- *
- * <xprt-header><rpc-header><rpc-pagelist><rpc-tail>
- *
- * This code can only handle requests that consist of an xprt-header
- * and rpc-header.
+ * Save the request off for later processing. Only a Call that fits
+ * entirely in rq_arg.head[0] can be deferred.
  */
 static struct cache_deferred_req *svc_defer(struct cache_req *req)
 {
@@ -1190,8 +1185,11 @@ static struct cache_deferred_req *svc_de
 		dr = rqstp->rq_deferred;
 		rqstp->rq_deferred = NULL;
 	} else {
-		size_t skip;
 		size_t size;
+
+		if (rqstp->rq_arg.len > rqstp->rq_arg.head[0].iov_len)
+			return NULL;
+
 		/* FIXME maybe discard if size too large */
 		size = sizeof(struct svc_deferred_req) + rqstp->rq_arg.len;
 		dr = kmalloc(size, GFP_KERNEL);
@@ -1205,9 +1203,7 @@ static struct cache_deferred_req *svc_de
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 
-		/* back up head to the start of the buffer and copy */
-		skip = rqstp->rq_arg.len - rqstp->rq_arg.head[0].iov_len;
-		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base - skip,
+		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base,
 		       dr->argslen << 2);
 	}
 	dr->xprt_ctxt = rqstp->rq_xprt_ctxt;
@@ -1230,17 +1226,13 @@ static noinline int svc_deferred_recv(st
 
 	trace_svc_defer_recv(dr);
 
-	/* setup iov_base past transport header */
 	rqstp->rq_arg.head[0].iov_base = dr->args;
-	/* The iov_len does not include the transport header bytes */
 	rqstp->rq_arg.head[0].iov_len = dr->argslen << 2;
 	rqstp->rq_arg.page_len = 0;
-	/* The rq_arg.len includes the transport header bytes */
 	rqstp->rq_arg.len     = dr->argslen << 2;
 	rqstp->rq_prot        = dr->prot;
 	memcpy(&rqstp->rq_addr, &dr->addr, dr->addrlen);
 	rqstp->rq_addrlen     = dr->addrlen;
-	/* Save off transport header len in case we get deferred again */
 	rqstp->rq_daddr       = dr->daddr;
 	rqstp->rq_respages    = rqstp->rq_pages;
 	rqstp->rq_xprt_ctxt   = dr->xprt_ctxt;


