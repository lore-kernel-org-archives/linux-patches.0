Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017583;
	b=RmEJ9FAvVvkgcPUVFBlwJIgQ+sMpgKAAlXMHOBuCSoaeS9wXKp8G+3bMw0kozt8R+a7X
	 FBmP9UCYSaXQRFVHdR7JWaI53w6HNaZOTDlY27Z3XC5CyvaDONqa34o1SHkfUH3p8x6fP
	 D6IhiryRPERciwXWA96ax7InlEFIGIxY40Dvjf6DtLMaGa6srmgj2LOzZZyNhmAiYaEom
	 rJT3MgA0kZiBJPfGn+mxHBEGM4gAXUlr7egeubtF9U1IGkQSM8GVkrAz9VaY6fHJ0GwGP
	 SNdznvDg44Payru7jvpfatHqlyQhbW5yv5fMc5N9DV+tP3VtCsd8o2ZDy3osgHh9uIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017583;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DVi9rYlv4gGeg4YvUWTnOoJFgNhnYNwtmzF5SqtiIc4=;
	b=pu4L9S5tLjsm0Mw0WtvVdZ97ZHQH0hb2pv/gR7wXlnaeRXjTRvF+MFB+SOC4WguxDWy6
	 1KAuVlOFlxS5uNIfQckP+yxCyEa6CZBvRtDV8hUtgjvu4LUABnwHtEbsWV7OESbhHWPkT
	 +3JqK+uthJhmh75rLsDINi+oJVOe7DDIOQmw3ViM16664lPIhI3EuDDO1w0oEh+YAyIkd
	 KDh4PLS2897X9kBU9W05vP4yu2LKKUw8omq4wijQJhNuz8/cNFYhAY3s3mtiaFuJb0eIC
	 8epJZ8D9Y/uM8nlktpEmvvEzbh+2qBtmApEudFkoJKh2ZG5sdpWva0EjEY5KnNnS+9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKkMlLrX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E52D606A32A;
	Wed, 18 Nov 2026 15:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LKkMlLrX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B33A1F000C4;
	Wed, 18 Nov 2026 15:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017583;
	bh=DVi9rYlv4gGeg4YvUWTnOoJFgNhnYNwtmzF5SqtiIc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKkMlLrXYcW4nVk929zcH9G+tTwiu+Jzd0+Ae8xp9reglLB9umj8o/jdEPtCnn+rY
	 rjoCxs04uE2wEnZdFlvFpPkodQYYgWJdYQY900jL3JADZeaakI3LHF9LVXABS99uYg
	 c8ivmnChkIebUsno3Zx51z8dk0pvyqlAl6QYyDDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0936/2651] RDMA/vmw_pvrdma: Pin QP and SRQ rings writable to match device DMA write access
Date: Wed, 18 Nov 2026 15:36:16 +0100
Message-ID: <20261118150321.579429664@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 89abac4b60b708037595255ea2614b6967c86ee5 ]

pvrdma embeds a pvrdma_ring_state header directly inside the QP and SRQ
ring buffers, and the hypervisor writes cons_head into that header.
Pinning with access=0 does not force a private page copy (no
FOLL_WRITE), so the hypervisor may write into a shared page.

Pass IB_ACCESS_LOCAL_WRITE for all three rings. The SRQ ring_state is
not currently used by the driver but is pinned writable for consistency.

Fixes: 29c8d9eba550 ("IB: Add vmw_pvrdma driver")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-4-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  | 6 ++++--
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c | 3 ++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
index e939cd5ce40b0..53cc49f2b8c9f 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c
@@ -270,7 +270,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 				/* set qp->sq.wqe_cnt, shift, buf_size.. */
 				qp->rumem = ib_umem_get_va(ibqp->device,
 							   ucmd.rbuf_addr,
-							   ucmd.rbuf_size, 0);
+							   ucmd.rbuf_size,
+							   IB_ACCESS_LOCAL_WRITE);
 				if (IS_ERR(qp->rumem)) {
 					ret = PTR_ERR(qp->rumem);
 					goto err_qp;
@@ -282,7 +283,8 @@ int pvrdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *init_attr,
 			}
 
 			qp->sumem = ib_umem_get_va(ibqp->device, ucmd.sbuf_addr,
-						   ucmd.sbuf_size, 0);
+						   ucmd.sbuf_size,
+						   IB_ACCESS_LOCAL_WRITE);
 			if (IS_ERR(qp->sumem)) {
 				if (!is_srq)
 					ib_umem_release(qp->rumem);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
index 345ec486a223a..3252c2eb405a1 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c
@@ -146,7 +146,8 @@ int pvrdma_create_srq(struct ib_srq *ibsrq, struct ib_srq_init_attr *init_attr,
 	if (ret)
 		goto err_srq;
 
-	srq->umem = ib_umem_get_va(ibsrq->device, ucmd.buf_addr, ucmd.buf_size, 0);
+	srq->umem = ib_umem_get_va(ibsrq->device, ucmd.buf_addr, ucmd.buf_size,
+				   IB_ACCESS_LOCAL_WRITE);
 	if (IS_ERR(srq->umem)) {
 		ret = PTR_ERR(srq->umem);
 		goto err_srq;
-- 
2.53.0



