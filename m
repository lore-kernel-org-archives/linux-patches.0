Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFD635AC20
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302740; cv=none; b=YjqeczxznIMIOkKTFApXAcpoKuvxFbpEODNvQTZ1AhegOl/a9dAcQW3m/hJYt4nTXkBN7IPsM/0NYaVBFcaL3AHpy8rJGFaFcoGaEIRVQc3Fn4mzVwR8WmpbXwq0jiKCud9wbcKSC0sHo3NHUM7ERlShHEOYqwJkyrdaEIZvC3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302740; c=relaxed/simple;
	bh=oFw+3Tor05ueRxkJM5olOcIh07SCIidaybS+57p/wCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+SGPKK7w6fPKxm2LCYB7hkFvV1jupIV/tI7GB3zFer9s+Dp0qjadbB+6MEEgGM3Cf+dzR8JWktfWxYdrt2XlePDliTEBv7bbvZDbmI9W8l3RcGIXXKUWSIFKUFfzWbuJsPdqPX4TF4fCvbEH9LoQxQkeigtp52h+ntPQWQoaJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHhvPpgb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHhvPpgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9289C19423;
	Sat, 28 Feb 2026 18:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302740;
	bh=oFw+3Tor05ueRxkJM5olOcIh07SCIidaybS+57p/wCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHhvPpgb6KkM9UIZMo4R9KXrUznueDj2jKsTEacC4R2r40GIADtoFD08dB8kEj3lH
	 moa52LVHdYjcN7fm3QanltX+PprvdH3lkeGoFYWXxVe/x3/kLKqAWdlGerewQunqMn
	 vTLou3R1I3dvNjDHB+iH7SkswEr6KYuMZ+8zimenaAddwXz0ElptYMKcZjoeFMF3d2
	 piZCDDN84fkJ++akoLxscTnaJh5l+vap43zhnG0AHMZCApIsTXdKiqie2S9eREtw9c
	 R0bkknYcB4qXHCo3d+ostyGd3js1REc+fdxw4RwJvm2kohmBGgwhvDHdDvGSedWJTs
	 fXk1ODai5kmxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/147] svcrdma: Clean up comment in svc_rdma_accept()
Date: Sat, 28 Feb 2026 13:16:53 -0500
Message-ID: <20260228181736.1605592-105-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit fc2e69db82c1ac506cd7f539a3ab66d51d3380dc ]

The comment that starts "Qualify ..." applies to only some of the
following code paragraph. Re-arrange the lines so the comment makes
more sense.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index d6c9814644c6a..429ed159e9251 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -393,18 +393,22 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	dev = newxprt->sc_cm_id->device;
 	newxprt->sc_port_num = newxprt->sc_cm_id->port_num;
 
-	/* Qualify the transport resource defaults with the
-	 * capabilities of this particular device */
+	newxprt->sc_max_req_size = svcrdma_max_req_size;
+	newxprt->sc_max_requests = svcrdma_max_requests;
+	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
+	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
+	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
+
+	/* Qualify the transport's resource defaults with the
+	 * capabilities of this particular device.
+	 */
+
 	/* Transport header, head iovec, tail iovec */
 	newxprt->sc_max_send_sges = 3;
 	/* Add one SGE per page list entry */
 	newxprt->sc_max_send_sges += (svcrdma_max_req_size / PAGE_SIZE) + 1;
 	if (newxprt->sc_max_send_sges > dev->attrs.max_send_sge)
 		newxprt->sc_max_send_sges = dev->attrs.max_send_sge;
-	newxprt->sc_max_req_size = svcrdma_max_req_size;
-	newxprt->sc_max_requests = svcrdma_max_requests;
-	newxprt->sc_max_bc_requests = svcrdma_max_bc_requests;
-	newxprt->sc_recv_batch = RPCRDMA_MAX_RECV_BATCH;
 	rq_depth = newxprt->sc_max_requests + newxprt->sc_max_bc_requests +
 		   newxprt->sc_recv_batch;
 	if (rq_depth > dev->attrs.max_qp_wr) {
@@ -413,7 +417,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_requests = rq_depth - 2;
 		newxprt->sc_max_bc_requests = 2;
 	}
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 	ctxts = rdma_rw_mr_factor(dev, newxprt->sc_port_num, RPCSVC_MAXPAGES);
 	ctxts *= newxprt->sc_max_requests;
 	newxprt->sc_sq_depth = rq_depth + ctxts;
-- 
2.51.0

