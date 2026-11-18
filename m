Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017602;
	b=YcyZP0+1D/bzn4oH05b4ygojCq/usGHTf+8oIE/uPTFkB35+ZPsbvmgaClDg7yFm8Ar1
	 gXxOVEiWLFKdAWf7mm0430r1RxDFEU0AgWSe2EyaB2+5+/PKkUV3U64/lNIS8uKXmkqn1
	 MivenSfgqNaqZiw/82Hh+vMit55xGw8HpbDM7NmAs90DL9KxMg3Uzpa7FVKq0wnmbQxKu
	 /lD4Hj09NFY6d4p4k5yXSrZSwIZlnNjeq4Wnwm0hEVKjDb19DfcU5nSUw3Za2lurESnFl
	 5/mKuy4cenWKFxcI69rLhJdSE1vX6a7N8j2TpgTXR1yVJQ4Lu7AgaTCDTROAB9VxeJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017602;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qSy7fb2IXfXTJutY/jo38BHD0YiUVrr93ru6t7Vu79E=;
	b=L5btO/CEUcA84M2PTo6KMXcLigfRe+XOLiyxbcBKLHXMia3p/D0njz5co8oejFLGW6A0
	 WkuQQt4ZiFHqAMd3Bs3+HZ2DK6KOm9QSiymcdtiXP2+bGA1hphE3tPjcgOtFtRDmzSKLo
	 JeVwtnKXjBuSGlLJ/Yt9X01ff1/ZglJWM1Cs1hQ6i1xCnKrXmS0G4c1LtLSOSbcddRNgU
	 lz/Op76fke9lr0iruoAN77PtRC3JiUEUvwbyzW0sTh4qEt6oTDTIv77otEFYwjEXAQoL8
	 /Y0l5/2clhBndZCcRa/qplUxj2QNocGk1iMqMASkxnapnFIetKB+r0NQSn8cN+0Wfeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBCus6js;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD01B606A335;
	Wed, 18 Nov 2026 16:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hBCus6js
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484061F000C4;
	Wed, 18 Nov 2026 16:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017602;
	bh=qSy7fb2IXfXTJutY/jo38BHD0YiUVrr93ru6t7Vu79E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBCus6jsKSYuLONn0R4h7ibEdj5vzqxbDu2Gw8pHjR2DdDy5JXOJHBd4uaqwWi98b
	 Jkq9mNBiN8PT/aK0RKwZl/ZfFjZdwNF7n7DhPMugeub0jYGA+FyrzIqd24pF3Likcg
	 JUmhxVSBajmf0NquNEMY5LOeNC3r0lB8L1ELEuhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0942/2651] RDMA/mlx5: Initialize QP/RQ/SQ resource refcount before publishing it
Date: Wed, 18 Nov 2026 15:36:22 +0100
Message-ID: <20261118150321.791282076@linuxfoundation.org>
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
index 77ddab666ecdc..8b5bd33a7f0fb 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -167,6 +167,10 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
 	int err;
 
 	qp->common.res = rsc_type;
+	refcount_set(&qp->common.refcount, 1);
+	init_completion(&qp->common.free);
+	qp->pid = current->pid;
+
 	spin_lock_irq(&table->lock);
 	err = radix_tree_insert(&table->tree,
 				qp->qpn | (rsc_type << MLX5_USER_INDEX_LEN),
@@ -175,10 +179,6 @@ static int create_resource_common(struct mlx5_ib_dev *dev,
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



