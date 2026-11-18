Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030225;
	b=ooR8lzVeplQsmMD+Ks8fCPBJl0OTtstM0CjmuHCDp1hfjreRFjoG33KoJrxzh02oMewG
	 QVQDYjEO64wl3nf6X5ZSBPJQxJeoEtJpc3svtgVJeTDzZHOazv0H3KgHJ9Brx4ZlZZSnT
	 JR9IDbwnQh5gj+OQ9IwFRbz6nxdBSsMt1w2h7+V3WzTXRQE8YCqfrwZOCWQVzV+2wRrXU
	 005sjscUCdBoq1x/zut9NYZkjPvLiXjjMiOzG3URMRHkcP6vKz/eV9eSeJp+8y9c58sx3
	 7jk0iYYT9cHrpHluxJ8BGL3I9Sg2HZxkDqAgPTxBNCmDgYdfkY2c7wKkCO68WnTH2og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030225;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qPTzvzVIfoTm7pBVY30aKUWeLqXhkpzeYXousSncPRE=;
	b=k0te41/odRwMbaIuVfDB+KwxiJap2FEdszClJiWDF217Nb2r6yvtSkPLCdlM0rCjmKrW
	 N2RMQdxZ9iP7rITF7VokK+HstAijCul1/m3XXqyT/NDgBiNwIPxsHz+zBnE95c2fxrjf5
	 yl578mDzGRaezlfVnrszzjnZgwuVNQqiXlnUzjuiz5RWZG/gMdPwMd4ljz8h5llxFDol8
	 3d+DfS2LfN+SoCiACM2BkicFaKASsOznF95h6ewa4ODIQokmGpkGDXFS2G79+8ghDI4b/
	 zvui4xwwduGYeB+ZuoDpkGPBYQV2ym1UZIXq/u8Npgm54N9zb+bZE2aIyQxXu+rcTzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9oZRioq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603B0606DD0A;
	Wed, 18 Nov 2026 19:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y9oZRioq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E751F000C4;
	Wed, 18 Nov 2026 19:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030225;
	bh=qPTzvzVIfoTm7pBVY30aKUWeLqXhkpzeYXousSncPRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y9oZRioqkmHH7tFdOsch9uoX1rnJJKAnfjiDBnEufIeIyJvPTrtxvpdEIPUCtWJ1i
	 vbyyMqv0cHHeCjDNErYqOz8my60h6DN6wah3z9PEiAfQDKlskT8x+ZWUycvF8I5syq
	 3PXWDF7pBmQGd5TZhq4GHmuAeEoja1z5XMkCa9Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0629/1756] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:45:56 +0100
Message-ID: <20261118150033.918962110@linuxfoundation.org>
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



