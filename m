Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B15B33A712
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302192; cv=none; b=jvHjq5oaieqCnjWT8B6DcqjiOxKWt9pTGDG+Vzmt20OUIVN3TBy9ClwFpEszNC10L9LU6mstXrxHSx6qXdtKHQOB2oaD5i3h6zo3ka5myyaf2dTvxAIqowlTkderjTkwzkTJQPpAw0oi/Fg6FAvmNImaSELYw+HOB9+RNP5eo1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302192; c=relaxed/simple;
	bh=anVva9eqOPW9aAAGdl3h/hczm+ZzX4z5ulPk5MiCwGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l8tybN1DzkeKJPOjjkuExCee6AmGazd3sy1fzLhXOOsUMP8VkjreftG+gMO4N2GCn1I1psjM5g+fSy1ShIggvjF7hRrdRIMwkeD/zhYw9Q7sEzL4m/AitIiSfkHWJsgU9DBqt6hiiOFcVDe16s0tZhLLchILvkH/WTiuK1402s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ut0j/6aZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ut0j/6aZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942CCC19423;
	Sat, 28 Feb 2026 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302192;
	bh=anVva9eqOPW9aAAGdl3h/hczm+ZzX4z5ulPk5MiCwGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ut0j/6aZL+CiPelG9jP1c/K0elAwExC4yKS9ymKbYh5anZqROSt92Wka83C5PCbpY
	 OdYI0Cd6D0Z2cD7z+CqpaRDC/Qd5eC63vqJKIgfO5DN/6SPA352fX0uCmR5O++vnw0
	 mcQT1w51DOhD8vnvmDiWyUYDyjWxuEQpjpJ3lx3nVyE3CTbveGdDYRon6xFQ4eofmg
	 hvIdgCFgLLHr8bC8L2W/8MT/XZjx5KaboP7KnZc3VAjeMQO1whqe1YAsfK2IQ69hV7
	 DpO/II5iGr/bjLOJ+rvmQyveY4P87QIYKpVIi2hMIm6NawGALggqwWbCPsgN0LNV2y
	 9JNyRuUgpzy1A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/283] svcrdma: Clean up comment in svc_rdma_accept()
Date: Sat, 28 Feb 2026 13:05:36 -0500
Message-ID: <20260228180709.1583486-194-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 86f45461b1851..e26d1a7035e55 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -391,18 +391,22 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
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
@@ -411,7 +415,6 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		newxprt->sc_max_requests = rq_depth - 2;
 		newxprt->sc_max_bc_requests = 2;
 	}
-	newxprt->sc_fc_credits = cpu_to_be32(newxprt->sc_max_requests);
 	ctxts = rdma_rw_mr_factor(dev, newxprt->sc_port_num, RPCSVC_MAXPAGES);
 	ctxts *= newxprt->sc_max_requests;
 	newxprt->sc_sq_depth = rq_depth + ctxts;
-- 
2.51.0

