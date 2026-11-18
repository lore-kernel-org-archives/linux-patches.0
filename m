Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031428;
	b=3hYXhEuSi4a6Mk9f0KBvgS7tmfRww9yTVcVeJysshXxfqlxRA3bWcmicMHi6g8raVacS
	 UlKSuUgsDP5MLk1zj7SBaNohMKwyBpuWp47fvq3RijiHsr4pQb+dyrg31EtXu8jhJBoc+
	 Z59UzJZSe/vaoufyBJso+F2S+MyZRLaObCinXiGowiZdURz/O3x7JOvB/jy+CrQ7HtPKT
	 BhlTq13uW7lLKJ32zMjw2dm5z2xY4Oj3HiK47I+vnDzaKrpeUHZdMwHx8mZmSnuo/VayB
	 cjdlWbEFan6vwyAv+unsn6wuri2W2wfupt2CBcI2l1OfHCKWvO+7HszBMRZ/PCUeRFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WudXFjGkKqUIU6TlCw54dzCH6ksj5YVkifU241yxL1Q=;
	b=v7IThSM+jqAzNhtm8AqBmaDtcnZdt1TEg8yWCVm9J+uNWzaBprokvy8ywKsnoSjagK48
	 KGbUX3YG6AwZro1VUmjFu7hsJE5ey+dAv7+eyCCaS1e6HsvyJwMIZ1VlsiYkPObL4G0w7
	 0xDWzDo8bxk5IDd+rf6WpRCXfc/90XFFq1g8Rs2gRsAxw/Cey6En8Z3Gl1YGKzU9dR1uL
	 3GJykE85n3wEWq2b6cyW8N9mOQD5cWMYb/TpvY5BviAyydTl1RiUtqCftlDfgmb7M+AEi
	 liiP2rH4LojgJ0aXpYKA0Jf664UvJLPXe6EN8ollWvhx6j8E8uFOJoB1fKwFVZS25YA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PaBu+OP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C80606A31C;
	Wed, 18 Nov 2026 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1PaBu+OP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DC21F000C4;
	Wed, 18 Nov 2026 19:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031427;
	bh=WudXFjGkKqUIU6TlCw54dzCH6ksj5YVkifU241yxL1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1PaBu+OPnhInhKsAtOjKMePRdF5LLTUOJQuBkFh+Ya73UAnA6JC4PmFaIkuEFlezt
	 +A9B2aZmc9UPoQ5/WCq+aH1SM4bGjUquz6fb0dcxJOk86tjG6tof3v+TXODYfJL0Oe
	 M0aGL3YjpyT9gBkd8nqeMm1SB3Aj2eLrQl+DH7iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1053/1756] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:53:00 +0100
Message-ID: <20261118150052.134459185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
index 4fb1b24da97e8..edaa3383aba83 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1843,8 +1843,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
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



