Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C1348875
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302602; cv=none; b=rGCpgerNqviDqYSl7yFsOLul9La4inDvzW4gsGuHFh3+bxRT/Nnyn1debx0T9Y1oh0p7zRF5o10YcU2xSWh77LwYxLUjP12QBtK8RvWdVHq3VnWt2B5GyjaJmR8WQcIgGt9tWbcJ597k2d4mVIF0WBioWMPaS72Ogxsbs8anIa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302602; c=relaxed/simple;
	bh=Dyu/h/xRJr7Bra6YeHSDsk79CLI+t8u2wAn+QXdS99s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5ZxFY0qRbq67z1X5WmAH9QlDa0YR2t0T+Pn3rK/Rxx41XLzED75zIVPyCGtRBmCgyHx/lIsTtNeXzA+Z1ZsGP+pgBaUVwG05/XeD4sNRsZNo9ylQvh29f+jKB6kLGE60mLxgj4V1S3qNc1zKLLIb8IdVprqiVmwuN9oxuW1who=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KmRiSZen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KmRiSZen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32212C19424;
	Sat, 28 Feb 2026 18:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302602;
	bh=Dyu/h/xRJr7Bra6YeHSDsk79CLI+t8u2wAn+QXdS99s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmRiSZen0oo5E+aYnu5JvoLz3s5FOb5KYvdTN8YQWcqiupxwdyu/rENiTmyc9pfmj
	 sy8Q3DBu7lnHa/Q6SIN1ihFotYWSBcBkg/EXujJvxGXjA8vNPlW0RD1tdxafBtW90A
	 p/6hiP6gmOhuV9G1/ZC62045zwanFbULyPD/2Go0aZq2Lt2prV+UtNqUFPXgP5b/wV
	 a38+xjjZAWxQHU+P3YepBFwskU09SRU72rhr5fHHFyz0MUD5qKI64f7DrzCH+fE1S4
	 lWLHNZu5qDyW9AHKKzjNfIPWBZAuVRAQt0y5QLXLJZRMQN+F50zq7To8FWzPSYkXmD
	 mrUqrskfDmXHw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/164] svcrdma: Clean up comment in svc_rdma_accept()
Date: Sat, 28 Feb 2026 13:14:15 -0500
Message-ID: <20260228181505.1600663-116-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 7b7e882c7a508..31e6f4a14bbc0 100644
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

