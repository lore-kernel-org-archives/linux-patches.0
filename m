Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049513;
	b=LfzkWnSv3BNyYgF8KYP00wvM2ZwIqe2+FLhAcePmVy3ifmr4leWHU1rZwTRdh6mYrWJn
	 QLpC+dUNWcfbxSpOHcH7oi1isiXwRvA2pBjkJzPXGAHuc3+XevLZuiUEROsYmhiF3KorI
	 /PjBzP3NuOZ8rwI1DFYgZkkpjOxgSur5W3taQN8VlLwJydKAjVZZbUVDtBk0vGqHjOf4Q
	 3amlf7rupEmI1FqGoHXLxX5TDbwMlhLYn7B9gaC4jlr7Aem7h9rjpEwiXk5PLcvd4tmhf
	 ndUWi/GXD/vSvCHjx4pYFBm9ZyDBJ+hH2fpFdIXA2SDRw1hXDZ2ERGegoNorh9iPTJA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Wgh5qZqg1lkJ63qpHoKesJTDN+cMQvcMJtJVk+RwKDM=;
	b=XceeoeTlWX27yQkf9GeFGnBeRNkz92uUYsGcP7Dy/Yn7Sno0RuSUkoD3qMMkJEQSL9wh
	 Qf3vYIJLmL/MEL6WvXthjZ90WHx0zfjGSLAG1ns2s6GcbU+gVuUWnUZoBoM9Pcr+ZkOMw
	 d8TJQOFiakPJ1Z7axsC10Hpr1S7mUPvkZaMFOcIDxDW3T8AZmNu9iZPT3b3MiWCq64U4g
	 XcDbHpEPf1XkxDRrTGa7BFXYe91chWOLYYeeFnDKylVDZEFeYTGgLN/pclDpxxlfjO9uN
	 ln0PWH0nEgvcHviM7oPRkPeESKVnkGz+N4Ewjw12MU60kMU04sJa6b4d+hXfvMBps5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trF5OxUW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81B4606A31C;
	Thu, 19 Nov 2026 00:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=trF5OxUW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A6D1F000C4;
	Thu, 19 Nov 2026 00:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049513;
	bh=Wgh5qZqg1lkJ63qpHoKesJTDN+cMQvcMJtJVk+RwKDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=trF5OxUWigm3Nk9WINknpQjuvArw/PtzMrcMZLWOPxtOPnaW6XscagdYxd1eyEuLD
	 m1i9R0OqSIxAd5M6hV22uSH/3Ow/9+5ZBOxUPYMQljx72gmZDfSRVEFODm7w4vKjym
	 fM4zIR78RPmoXzI79hDFbvVCf++/HQNUqQgaHTKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2361/2857] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:56:35 +0100
Message-ID: <20261118150326.532089978@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index d2ef2ff88ccdf..b396050f165e5 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1602,8 +1602,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
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



