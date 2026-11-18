Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026227;
	b=JYwl4rgpmwHSSgRiYzPv0elRueKjBKz9HgJsnCZs5aWZ2CygvTL3gPqjS/RdFob8W5Od
	 RMop/nrSPCCivPPP63TpQ/CYwNbC/yiUpTjTXpPPxIXplLfL7x4oRVHqkNIsm39evSj2n
	 tAwe2CIpQaRHRkF9A9aWcFt9qF8yN8O/N72DZlzCrFvGBJdH1jtNXSevJ90lFx8uXDtpC
	 TCN80xcwvZkWPj+3hBYuMJtJBi1de+MoPyamSpf6qa852/lVkr93icHX90WMlmfQ9/MuR
	 R4d8XGOohPzJ85lEWHhbwaBprnPxHrJ1lNVdpUb0N9W6qNbvgKpwORCNpvCrl690Nng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wDBcKX9vpFQVWmWx3y4xmERMch3gdoZSZ2iC1WIjqfM=;
	b=E5PAAasjmo9Iq5hBSOJj9ukjUNMTgtlT4NDt5lpKs6tuvo4ODszL/4Y91BJdV/POAQjZ
	 2M7snw+3PGatHYQzrglMqDdVq4ucL2Mq3hmRPmzberFJatEVXJ7lcbe1QlstNl+KSclXV
	 R3qlnWFH1FC0Y5YjKMmsaSjz+GAo6X+BbJoHmirCcT1O29LpDJfBAr6sTddahi49gH8Pf
	 SLQGjyDKya4hkDiBQ9mea2Qm+QSPxqb9WIVeTDH2A26fOtUAFQItqeqEbqHMcSh/HNq/U
	 7eb8pH6uuF16SD1gNA0Tph/B4WwT7iaUE3BKsNaD3GHHVMhViwIMWlqAUT5+BFKtL9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5aAHMPI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABED60A261A;
	Wed, 18 Nov 2026 18:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u5aAHMPI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DAC81F000C4;
	Wed, 18 Nov 2026 18:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026227;
	bh=wDBcKX9vpFQVWmWx3y4xmERMch3gdoZSZ2iC1WIjqfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u5aAHMPIGTnQE1Bi4miiRPk8l5ne7ldTL0G0Of+iMs8yAc8w5Mp3dZPoFgKfJYzJX
	 1B25JN0tXaOKqU9iagvR4g08PGnZiMOC9rdKIERTF3k2TyPthKJ905elrgG1RiNCfT
	 JXA52xoWrvR4f5iUzbeGX8+kGxQUgC3p8xLAsSqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1333/2151] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:51:08 +0100
Message-ID: <20261118150210.623642233@linuxfoundation.org>
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
index 5cd1968a33d0d..796378cbf2a25 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1879,8 +1879,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
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



