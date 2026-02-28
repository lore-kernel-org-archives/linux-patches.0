Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63373359A74
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302419; cv=none; b=m35rqfGOCx4cjygSiYnKFRK2mDABQGbWZznuMqPC0OFb4iSPU3ocMNaV5SJ6bDIoB+109F8wGOcK7dSw4EOmaNUeN9pAtNj8frHvaFxJQq7JUzmQfN/vhn+kd0AgpxX6LIC4AK4V3nEG7ZZ3zaGiZCn1Vb+n1tigE7+7S11rXj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302419; c=relaxed/simple;
	bh=Dyu/h/xRJr7Bra6YeHSDsk79CLI+t8u2wAn+QXdS99s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmt1TCL3LgWRab0V4QlLREpodQid9vpp0nydO1y5PMENiaXEcNO2AGwdXqSonWR/OEwzim74yvv/v+iv2kYVoq9MBNjXd9iVzREJZVrmGuS5AbQP1Sim1zETzyvuzNifnzvhIGfowRmHHsew/TXgeoU40E2boNH2UWEa65vNX7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZE0zy3Ow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZE0zy3Ow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1645C116D0;
	Sat, 28 Feb 2026 18:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302419;
	bh=Dyu/h/xRJr7Bra6YeHSDsk79CLI+t8u2wAn+QXdS99s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZE0zy3Ow6jpjAju2NBpmI5M+f8Mswmhi3E1oUPSwOuMz7QP/zFzTzzD4J7Lz9ivDH
	 Mj/+5U3BlkMHU5wH8RCZax3qlR8gbgQn9Xj7g4jDzsmzphTKlGaBdRS+ol/8qrjj9p
	 xmfNktkEjfR96gqFahWNc7SLIr2EZ1g2Q0RxtEUGV9Tsd+x4Ih3Njfm33jAewqanIJ
	 tMg2xDaWb1j7d8FBERJlprIbaN10mLF+zYUzI4TQK7EY+WIjKyd3jXAeTVbC/yEpyr
	 4b6GU0wZadUSpJ+eE+Fy+UZPw53qQ8Na6ATkB6qU2pAeSG6Qty+vVtdd8UWG9arQR/
	 Chv86Wpp30laA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/232] svcrdma: Clean up comment in svc_rdma_accept()
Date: Sat, 28 Feb 2026 13:10:07 -0500
Message-ID: <20260228181127.1592657-154-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

