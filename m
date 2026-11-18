Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024648;
	b=0fVmQdb8BwAR9/ybfpI2DX4CjDi3oG/GlCeiFTC6xOMZqPG8bYYndyGvjgEP6xvnhvT4
	 RTvuQiruXG3j3mMSbWtHp5w9H32UniWSgk767+JmfGQKB/9dkC2Bn6sHLlBHeLQVhMhuj
	 4LifBrEGdWWwh4JbbOW1tG5SkqGJb+aS5KzNjoaK4fmGCJuh/SWcmrUcIhibi77uANK03
	 iEdnbEDdu82wJflocFqmL8xPrlSRnBr4ZzO5yuVMfkFKbp14cMYxWNEOga26YATEQQAG6
	 3qwxGxFXGI+4w8aE0vjdNoDlvHVKufrjoNBgJekuly58+zHvr7YjRbeS0YHgwB83t9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lBrfCWEAg+n2h+12s/BArSxrW3JrL7vUiMWFosMksMY=;
	b=B7S9NL/gqS1wtW7jUAssqx7Y53TKS4byXaL+GMkZnFMXYLv3p2+gR+pe3GZmMp3XKrOF
	 GctVHhAZ7BbDbIg46tjlwjXaRTxUuQUViUQrxZNCL9Pzshr6SBx67+LwVcB3lbh5Vt79e
	 H42CE6tIbv02gM4bZmNZZkM4+VYzQPOYahEQgZ/6mBR8ipZ0bygu8msIqwqsJI0OWJ4+n
	 esEJmv/HshfD6cRRg+HmDfW7uK5nSggH4TBBXwznMJmsJ6c51YVZcQ9WGKpGko06eMnL4
	 skDsE9Aif9FBfLznz5Jfuxwe1bu82E2h4mnTSRgGP8Lgmt0PNk8gfl7kHWqMBqYm5mA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RmSKXNN/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB024606A325;
	Wed, 18 Nov 2026 17:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RmSKXNN/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4DB1F000C8;
	Wed, 18 Nov 2026 17:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024648;
	bh=lBrfCWEAg+n2h+12s/BArSxrW3JrL7vUiMWFosMksMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmSKXNN/u8vA5Xn2z7+IP/WKjZRod8/d+QxU6gksAZL/j7jZY907V0RYgK59PENaZ
	 VeaqkChKM+nq2mOFRhM4f9j4gCbIyYN5ZbEPZEIa9X6uSlaYt5QvwfY6Fh3sC8zQu2
	 QLxHHKPqer4PnXxv8J4u/rpBXob+HXQVXPjnOrGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0800/2151] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:42:15 +0100
Message-ID: <20261118150151.214283808@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bcb6b324af506..38def085ee267 100644
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



