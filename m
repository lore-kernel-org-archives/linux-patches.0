Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061739;
	b=1KpZfI+zAWpKXh7uC7kLQPryTQmyVUqhxCsNyMVvgNTG+7645p9sOCT/brwehuuZ03IW
	 XnpuGHPY9X26w25/KAZLcwcGF/OD//HyuBhaNXml5Fc2ELYqRxANFI8eJXuMDm6B6ioHu
	 P28STCNSMqadToyQ+nIVYENrISDyee9S9LKBnm83ocEwODXZkRhGsNiXEBQRS86+qP14I
	 Nu3C0u+dYHvvzMbanSxwQgIkXhkMUNQqmjaiL/upn4hQ7IRzByNl+3QsM12PA2jyUFagL
	 TL/ATm3shIPhvMrwEXf39CUMayudp5A40OgDyQ2tc7yHn+IX6YFZhe+gLpcwABFZaCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K16fdZ0+LJk8K8yWxfPjFU7YknRjBEHXuTgnQdYNIvk=;
	b=38152MwGG3WCXRUvBzYrpJ7DylaMtVLfJ4jbHeZFqP8G12ezWP6No9XYN9QLaKjKCH0f
	 aEe1GYfEFR5N1p5MA+BjxPz5GDA6MWZK+U6iDKEHHgO+kCBqioynGzAoYRzRBOsheNuXX
	 JfwTK7JWTvFEmxMeixwq4uyRL440AZHKgT6zrg/W9/epUbOTDatHchLkq/oHWs+LVrxzs
	 bP1P+oVjcxrXSrsv5XQ0GuWbr3pWNDRc1BDFW5PbMzBU8Du3TJd6uIaoiaBM1dvnuYqFf
	 AlKFq5wnO13Ooxf0g5bgqBFk1T4Xs80DjTu+3y9tGwCB48DT0DWy2WwoFtJC9sjtorg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLRBdbLn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C67606A326;
	Sat,  7 Nov 2026 14:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fLRBdbLn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CAF1F0089F;
	Sat,  7 Nov 2026 14:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061738;
	bh=K16fdZ0+LJk8K8yWxfPjFU7YknRjBEHXuTgnQdYNIvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fLRBdbLnpr+OxdaX/WpBtCxmBP3SaFUaIfdzgi/ltNHK9B9MjPVuvGb8qbm793OL2
	 CAMIm/plgYbQwb0mcRZ5L5w+muyjdZF56q+A0ai22ybZ26eRUyxGMV6MhAVnCeIb6k
	 PR85GbznYRgSscS7su51XdN7MQmj6WaHDJWppKmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0779/1536] SUNRPC: Copy the deferred RPC Call from the head buffer
Date: Sat,  7 Nov 2026 08:46:35 -0500
Message-ID: <20261107135019.417528553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1182,13 +1182,8 @@ static void svc_revisit(struct cache_def
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
@@ -1201,8 +1196,11 @@ static struct cache_deferred_req *svc_de
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
@@ -1216,9 +1214,7 @@ static struct cache_deferred_req *svc_de
 		dr->daddr = rqstp->rq_daddr;
 		dr->argslen = rqstp->rq_arg.len >> 2;
 
-		/* back up head to the start of the buffer and copy */
-		skip = rqstp->rq_arg.len - rqstp->rq_arg.head[0].iov_len;
-		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base - skip,
+		memcpy(dr->args, rqstp->rq_arg.head[0].iov_base,
 		       dr->argslen << 2);
 	}
 	dr->xprt_ctxt = rqstp->rq_xprt_ctxt;
@@ -1241,17 +1237,13 @@ static noinline int svc_deferred_recv(st
 
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


