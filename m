Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056026;
	b=wPYmULM0Fceq6TGEcpaL+Ss524JpG7o3wY/XPzL8d/3AYyI79xlhUxsXsOnHAIzA/qIx
	 RbQbYv7SHBvqwlTL+GDT+qFi7AzgyBqhOEKuX5yg86fKde2QRc7OXZB1FJbKXwdh3U9oU
	 nwanG+Ydl1pBROXclh2MmgNkItHlLDGCwJGlSck9l00Zi+VVdj8es0ZLPhW/EClspXuSL
	 01zHBY9GFzR3f2kQWJp1owqy9pyCwkmZk2BYWVAlCungTi6huCy+ZrokjyMizpDgPF1qz
	 +mMdQHNFIih5UJj3VnJUhTo8HNuv3su7xg2qVMfD+PKgzLh2gABhI+i3QzUku9XrUoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056026;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0xf1aCpMOtWnhreyGWhazBFoq3/4cRfJjjaKcP6SAGc=;
	b=ieQTY7lo4S1dx6qtszwAGs0ioWRYS+fNQHXfEKZtRlyxnU+AnccibN23ntW8Mv3WGYWR
	 j4AH3U3xC/aBBoqvgq/vqQGxgzzLISjslKTlubG2eCD/9yzf15/duvPOXpV92SlDZQQ7u
	 dci3jztAMKa6qEYQfzz4MrCYNMdRZV7CeTyqnJOHNUpTnK5cJvsIGY/keU50b9WM22YRd
	 dwUZFvmi5Tk47tyrghX+1N0WxQe1bA235qwwq/HR9pX9nw9K5tyN+Jm1ew3Pz5sBf+52G
	 52RMS0CVuvsuJx00hCHd38yeEH6WNoKk0KFH9zfAnYfN4pp1Hoz4s849uzDPfuNbPXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZ8AugY6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ABB606A31C;
	Thu, 19 Nov 2026 02:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZ8AugY6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED8DF1F000C4;
	Thu, 19 Nov 2026 02:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056026;
	bh=0xf1aCpMOtWnhreyGWhazBFoq3/4cRfJjjaKcP6SAGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZ8AugY6tEwtjll5WRqwrUh7o7xmrcDqCdq49yqnOd6XPHkO2cZw3+E6PP+J+nGgR
	 bJ+ZYmi2/gJ99vKmO++COuLhMkvwoOs1nBT74CKos7CB4ZogZnDPlG4E1Rt7Iuf6+V
	 apIukT/RgOJxYt3T7MC2yIks0u5fhkTXJ5xWV0dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1841/2214] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:58:37 +0100
Message-ID: <20261118150125.071367921@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit aea64024ac37d29e99b82b315a56a9145dc0bc23 ]

Page-fault EQ work can remain queued after the notifier is disabled.
Destroying the EQ before cancelling that work can let the worker access
freed EQ memory.

Cancel the deferred work before destroying the EQ.

Fixes: d5d284b829a6 ("{net,IB}/mlx5: Move Page fault EQ and ODP logic to RDMA")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Link: https://patch.msgid.link/20261007234216.2765-1-prathameshdeshpande7@gmail.com
Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index ec18f8dda94f9..3e46b852b8b79 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1604,8 +1604,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	if (!eq->core)
 		return 0;
 	mlx5_eq_disable(dev->mdev, eq->core, &eq->irq_nb);
-	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	cancel_work_sync(&eq->work);
+	err = mlx5_eq_destroy_generic(dev->mdev, eq->core);
 	destroy_workqueue(eq->wq);
 	mempool_destroy(eq->pool);
 
-- 
2.53.0



