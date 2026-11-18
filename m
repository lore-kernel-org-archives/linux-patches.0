Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041222;
	b=pna2X6Q78uVqyxBgp4AUFQ8xlFI8fHTSmcd8xMYbLLAoob3uHn8JJ76EMp6+FXIhff0g
	 xtWAirqgOIKqxTOQsNKbKUd27sBaWwDNXHnThcIE3Zdv73AanhaRFk1Efffeh/TXceZyn
	 WdA93vRIoFpm07k7fIzyTY9r+ne28b90n/9vyIMyGryjXAObQy9EmkMEYcdxFAIaTQEk7
	 RfUan+T4QSiuI7o31D4GnD0xVg/6L3QvjZDvW9dFuJ1ichSLrCUFAJ/j1FFSmVvA6Nb2E
	 s2dPigGH9szENXsbbCQyvYR1gxMOrI9H0QmTOaTaUnvqyUe5hmfz1bpVnWMNe2QcxqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Od1Di+MHSaKImb5FrRmfG2/qF8yyNhK+jbQLSxAHIRw=;
	b=q7iCzz9rdnoJVhinKkxmWx5FHxYq6TBt2dZ0j1RTHVCGlD3JscagOntk9wq6GPLBzsiV
	 cC4RiUjugd453HDNii+zzUqN9zGs8tsaVAMFZ5Ylvrq6nALr1IO9iptW35UOpbTYfvRs/
	 C3FzBuKokFopWFj15C5vYu/IaOCPo4ITrWdqZgd8wt8NIfaJmSBtXvu5vF6+uVUbdyGXL
	 itx/KEL2WmOzyKVwsNIzKDOl/GtIUFBt9EVej+6vYCer933zj9jMWEVvZ6a8hvjFftlg4
	 g2t7ZAqyOREjjQ7320/NZz5I0OX5IzNjVvmg5zEpGmFdZoFoA1wZMiv9dkJ/Up/HmyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E47BsJIe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DC9606A320;
	Wed, 18 Nov 2026 22:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E47BsJIe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B3D1F000C4;
	Wed, 18 Nov 2026 22:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041222;
	bh=Od1Di+MHSaKImb5FrRmfG2/qF8yyNhK+jbQLSxAHIRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E47BsJIe3sTSBrG18DmT8oCTAHEDYtt5tF6LO/IwqJUCoLAnQpMFhyqZwZJu0ZXIA
	 QTYldjPBqMmvihVad3R6CDbHL05PBIPuXFPpd/5OXdx7e61VXJSlW/NZxFGo/gwkEK
	 qEeMmjZK3CA4bBjyoqDhsGlwaxW8zik8ZxZutHE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2736/3318] RDMA/mlx5: Cancel deferred page-fault EQ work before teardown
Date: Wed, 18 Nov 2026 15:55:58 +0100
Message-ID: <20261118150442.882642206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 98e7a55ec8a4d..f5db9f832fa73 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1598,8 +1598,8 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
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



