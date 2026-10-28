Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212311;
	b=BbjrK2vfY+kofDY/PFcHTGrCW6E//eZ4cVNkN8lPEA71b0ObKgJzCCRLjKtuut6HbUmS
	 SpdGDt1EBb2pZnyNBf052TmGVw0tffr76YZbp4mFU7ic6RLyV6AtAv+wUCbIadOJnrAPu
	 6Xo23nyTRWjkHGvAg0AD9bnh59nTQ/viUlPBp5uNubbfSPHmBkW5L2eBLHo4A27+ZJ0Zd
	 6CtoQS1GITtiMZk1LNZZMbaZNh9MDHDt5eWOoTnkwE5MuBS3OqjebAVWU1AKWRLHdKYcl
	 SsYnDTRbiA7x3n/17lEnNTeffdkc1RJ+VnmMadlMovEtC0OKqW/Mf8x1SE5RtPN5wpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oGhouVnSSNMU/s6p4wF91HfleWr0z2fNHnAkpjGhJRM=;
	b=SkTbnelmIAqB/KgPOEmAAcgKJkekU+Zo21sTHGVM9ZhFho4pEwRpt5wB5CdJlRSaixuu
	 NZcY8lFIGP21ZoP03YsoKXHtylX4g1zAx19ZLZ73Bs9bMT1wAzVYyqWmXV1TSwQWtNwKm
	 ay5JuZMd0BczTwJOweoTfDNiwCYqPAOinRSQOVdVRDds8PxfKTSQs+fBkk395d+X2WSzT
	 pocKFCf7qeiF1jRznwqlL3FzYTsq9Oe82QX2xAcwknsJkZMu2MyoHiP2WU0hvzCD2513c
	 j16MXTrM487AoKcn41S+7V6guSbdhQKcfog9oYNAJqblKmYrjHmvMxVVfgaSj1mzYEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpueFqOX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CA0606A326;
	Wed, 28 Oct 2026 18:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xpueFqOX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4231F01828;
	Wed, 28 Oct 2026 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212311;
	bh=oGhouVnSSNMU/s6p4wF91HfleWr0z2fNHnAkpjGhJRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xpueFqOXDWPcmdXdEtVgMkJVNQTvKtbF9r7FBXPAjZ8NkaXqCQ2uL8FibqzTzXop7
	 6wFVbLUC5Hn7WsYy8FQ+ex9b4JW/iDuwuuzYKDGTnlBFw5AQt2cvEDaF91w8Ws0lZN
	 Dzou7qgrguDMtSXQPdb8bmWRfQoP15KzCCHTfmp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0066/1887] nfsd: size fh_verify server sockaddr slot by xpt_locallen
Date: Wed, 28 Oct 2026 17:36:02 +0100
Message-ID: <20261028170500.734654557@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

[ Upstream commit 71d068490098b1d23c63b2345e40675d3a1ca763 ]

The nfsd_fh_verify and nfsd_fh_verify_err tracepoints declare the
server sockaddr slot sized by xpt_remotelen but fill it from
xpt_local using xpt_locallen:

    TP_STRUCT__entry(
            ...
            __sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
            ...
    )
    TP_fast_assign(
            ...
            __assign_sockaddr(server, &rqstp->rq_xprt->xpt_local,
                              rqstp->rq_xprt->xpt_locallen);
            ...
    )

When xpt_locallen exceeds xpt_remotelen, __assign_sockaddr's memcpy
writes past the reserved ring-buffer slot. In the reverse direction
(xpt_locallen < xpt_remotelen) the slot is oversized and the
unwritten tail leaks prior ring-buffer contents to trace consumers.

The write-past-end case is reachable on NFS/UDP. svc_xprt_set_remote()
is only called from svc_tcp_accept() (net/sunrpc/svcsock.c) and from
the RDMA connect path; svc_create_socket() for UDP calls only
svc_xprt_set_local(), so xpt_remotelen stays 0 for the xprt's
lifetime. Every fh_verify trace for an NFSv2/v3-over-UDP request
then copies 16 or 28 bytes from xpt_local into a zero-byte slot.

The other NFSD tracepoints that record the server address
(NFSD_TRACE_PROC_CALL_FIELDS, NFSD_TRACE_PROC_RES_FIELDS,
SVC_RQST_ENDPOINT_FIELDS) already size the server slot by
xpt_locallen; nfsd_fh_verify and nfsd_fh_verify_err were the only
exceptions.

Fix by sizing the server slot with xpt_locallen so the declared slot
matches the copy length. The client slot and its assignment already
agree on xpt_remotelen and are left untouched.

Fixes: 051382885552 ("NFSD: Instrument fh_verify()")
Fixes: 948755efc951 ("NFSD: Replace dprintk() call site in fh_verify()")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260531-nfsd-testing-v1-1-7bfa481b0540@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 447b3483f94ba..513245b3697cf 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -201,7 +201,7 @@ TRACE_EVENT(nfsd_fh_verify,
 	TP_ARGS(rqstp, fhp, type, access),
 	TP_STRUCT__entry(
 		__field(unsigned int, netns_ino)
-		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)
@@ -240,7 +240,7 @@ TRACE_EVENT_CONDITION(nfsd_fh_verify_err,
 	TP_CONDITION(error),
 	TP_STRUCT__entry(
 		__field(unsigned int, netns_ino)
-		__sockaddr(server, rqstp->rq_xprt->xpt_remotelen)
+		__sockaddr(server, rqstp->rq_xprt->xpt_locallen)
 		__sockaddr(client, rqstp->rq_xprt->xpt_remotelen)
 		__field(u32, xid)
 		__field(u32, fh_hash)
-- 
2.53.0



