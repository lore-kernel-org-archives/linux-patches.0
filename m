Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024654;
	b=wO25gcQx3yxniGUzwvBpKxpk3rGNSq+l1HRogZ+j75xYBae9erQr4kTaxRSXF+AeuLFM
	 0AcAefaa9tGMpelGPkOYo67OtxKZ8jqBz1jqvX9ZfQPbTev565YSRFbOjyhORvSN0z1mh
	 1ylixoiJcwHt5y0tCnG5kR4ora7GG59wgNgnKwix1Zsvyoy2apwefk8MnwgQ47jlrerj7
	 deE0B20T/8tvLMtkSI2ulOTvTbPKK9FrQ+UGXELttofWgWKTZAUx2l/t6x0nttSb2B0wD
	 tgQY2KQdyhzZ4DDdnUrIO8HFfxFlQmG+G6xMSO/qW5jymor6CnMnayX/JkjhiiyO0YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WXFCxPsjOMiSGS3TVGbgpkhr8we49eSyKAVjlioAn5w=;
	b=h6BMJXqkefPTyghoXzde5vPyyC8JJ0ArHC8+EdV38cKEhEjkQxv0Y9JhkO/pE1/mL+3s
	 HJHSr8Iwif428Mrio1Hon4J+k6Pa6IhXig61W+XaFnvIgfGokdm2aulCN0ZTf1a8eqrvg
	 AGx09zZ9GwAw2+DXSiE0x5CtEXbXZqlC96kmF9Iq4vKxRY3VH1rLXThinVVQ0TNEzj2SS
	 Ny1ezQ/BBAVf+RZd0fkn/8BkQQEKFqHFntoJ9AomE0EZHy7PLErWKJY6v2/a3WfuPZ314
	 A/zLjH181DaFJLNXFKHPKKY06h5FTuN53reCCcwKSsvRP84ChBdMlffKMq/PDMJc87Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9Lyq3tW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CA9606A320;
	Wed, 18 Nov 2026 17:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9Lyq3tW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4A01F000C4;
	Wed, 18 Nov 2026 17:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024654;
	bh=WXFCxPsjOMiSGS3TVGbgpkhr8we49eSyKAVjlioAn5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9Lyq3tW1i2HzyKGJjjyE1JnbiD/NnlokmsjjDeGztALX2J4CEHJ8FjRXlBh8tTJk
	 R3A1qAXp1kN9Plcg9sCaQ+xjrAudZqq8R5ZEygRti6RybwVSi1b1XNyNEKsN0HEHVm
	 G4cOdjBQbyK/Y9dFybQp3bdfpvXUHpJcCIaeKVaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0802/2151] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:42:17 +0100
Message-ID: <20261118150151.281829958@linuxfoundation.org>
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

[ Upstream commit 829a0e65deff3f826a7870a52404aeaf1a3fec3f ]

create_resource_common() inserted the resource into the radix tree
before its initialization was complete. A firmware EQE in that window
finds a zero refcount_t and calls refcount_inc() on it; the refcount API
treats this as a use-after-free, saturates the counter, and permanently
breaks the resource's lifecycle tracking.

Move the initialization before the radix_tree_insert().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-15-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qpc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index 146d03ae40bd9..67ed45f3ae17f 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -165,6 +165,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -173,10 +177,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	if (err)
 		return err;
 
-	refcount_set(&qp->common.refcount, 1);
-	init_completion(&qp->common.free);
-	qp->pid = current->pid;
-
 	return 0;
 }
 
-- 
2.53.0



