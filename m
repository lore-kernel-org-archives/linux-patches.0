Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017592;
	b=nbGemBgX3z9eomPIa03UfkSVCxCVTgeQLupkwYBoMA6baf5AALG+qo4QjM0cZMa55Dpt
	 8sNKb3ZWPuNtkfx/itrkdfJM0Emuk6pojVcYWx0/VNi6+ix9OwSX+UDxcZscBwmU56a6M
	 roRSD+euhmKhdRNh5chmsZK9YWx5GoLu4hswC4j39vsPJzwN8kC2n1cfXnSEE7SKN8cuh
	 AlfzhPDdn9rLI2pX+MLi/4nPUXecfeAf3OBbVsDzq/HSYc2ZFU8xnKHGpBPaAKDscIk/N
	 BiGpoaD+f2yCi6RAxiYponpZsOyWuVy3IZjcxF3i3GXG1fjSlI4hAgQjxehRb3XJCeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rDMSAzOWq1TSB37ncxsw8oeeKnD6ycM1rDj7h+LUnuE=;
	b=rtFWK7Vuy7xWc4Qek2bBlnYlz8WCbkg8GL12Rz9f1xokEpzNTt/8vsQg34NLLfKRvsbX
	 0OgIdUMFsaf9uSwOs+R4NwnZcOaphziliW5Bn2DLaZiEXmhF2TD7J94VGtC6nHKtop2Tr
	 O0hEusjmL1zQRpPUAKmBevQ2+XhdK6KcfUXJak714TFWhoZW/+kZCnoLyoy9ETr1/LcCA
	 KeCDCUoAbXyJ6tYBv/XAd4qqWEmXDg5DivBVJ894DYvzHtg0trdykyjc/aXj24uNhBaMU
	 godDYj3qmOv/yww2gzHe4f8EBFFjTYC4Q1SPnFEfd4x8ISqHvR2wCRc+BaklMJ88Hzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EagXfD3u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC113606A31C;
	Wed, 18 Nov 2026 15:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EagXfD3u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B611F000C4;
	Wed, 18 Nov 2026 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017591;
	bh=rDMSAzOWq1TSB37ncxsw8oeeKnD6ycM1rDj7h+LUnuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EagXfD3uWajlLjj1QdxuWRBJp7djzpbrREvV7ctf0ggwLSMvmzmVdyq08FXoAFSQT
	 brYdMU3cQEbbbrnW4Qb31ykvy89DnKwYdRqyuDt0cDMER7yfXZWJ4HMLmwTQQynDqJ
	 39AnPNf1LRoHGC2bNiUdxL66dpIIb8MdI8Jd421E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0939/2651] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:36:19 +0100
Message-ID: <20261118150321.687689839@linuxfoundation.org>
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

[ Upstream commit d2aa15620e98dc4c6516944397ebea03b7a62b90 ]

mlx5_cmd_create_srq() stores the SRQ into the xarray before
srq->msrq.event was assigned. A firmware SRQ event arriving in that
window calls through a NULL pointer.

Move the assignment before mlx5_cmd_create_srq().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-12-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index a973c1b7515f7..6a4a937d97ce9 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -284,6 +284,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -292,8 +293,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.53.0



