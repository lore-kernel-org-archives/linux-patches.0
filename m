Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017600;
	b=PyemVh/SzkMHGf7yBbks0ZEdrWHtXR2L5WbTAUL99quQHvAY6DtrNLB8X3avcsY8q8Yq
	 xI11ju3WL3EKYxyJ4GqukaQVSB9CEVRsR7w6F90nUJuU/nu4YYHCEGzt6nwEY09qX030q
	 /wFbya+MAV+pAU2jswZROD9Bosh+8nLyQOLi90imIZIH4H8T44+SYFiFE4UOABbJxaB+q
	 I/+9WtTdwnQ4lmv9vDhrXJ9pQKx6reuIivi8MP0GnjGwdsfuT0xBo8Lxsk48qPCapXqOd
	 ghS1/xvNchbSqTAP1WIRZzvF53QcA0cdO/kDA7V0BjTslnJMaaiRSknRplSLR20XP+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2mYnOz5dLK5Ex99Z1Q/YbdYA+aawgYuEDxWe2vsamko=;
	b=jR/RZIETEgSt/ECGMMBFX4IkTjbyahBdGz3CPajf9twAGjvc0C4INypKCVBb0yrdtV+d
	 Rd/dZEwuWu9lG2CPPrau0Lj2UM5Dvl7V1vZBheifUs+GBJrZIOHa6HgvD55Eflh898ESa
	 4DZFliq5A5PS9Uc4aUsczR9ywD7kv+h7MMVy9mpvrsg431majkSmi9mTHPEJQ+k0t1ioB
	 RTVz+w4JpqDwcWqhLONLsnm6stXoiZdIPKUecrRGaERvdfHrXWwR8BgQ3JonrLAmEtcuC
	 DjOLfPCWDQ0RtkJ2SGox1CJvAzLYH9ueoVWCSKCoHZeVCLNgaNXwVhmAFgjYDa0/hVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK5f6C4y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2564F606A339;
	Wed, 18 Nov 2026 16:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK5f6C4y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4281F000C4;
	Wed, 18 Nov 2026 15:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017600;
	bh=2mYnOz5dLK5Ex99Z1Q/YbdYA+aawgYuEDxWe2vsamko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TK5f6C4y2FBb/CGEb63iEq4HScmovVI+6sWg3xuSqDBRMaGCF6W/17Ni++PE3lcm/
	 n7HhSRwd4jwhOnMW6gFNyZPzrbw/F4KetyyQGrxRvGo8xccRgmvtGhnd6YXNKGSsoV
	 eqh2oc8SMOtBB7oCdslZOAvxi7e4G5J3etsc1CVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0941/2651] RDMA/mlx5: Set QP event handler before firmware QPC insertion
Date: Wed, 18 Nov 2026 15:36:21 +0100
Message-ID: <20261118150321.755049717@linuxfoundation.org>
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

[ Upstream commit 05a078c97eb0bb7158526dae414b853737692485 ]

Four QP creation paths assigned base->container_mibqp and
base->mqp.event after the firmware create call that inserts the QP into
dev->qp_table.tree. A firmware error EQE in that window reaches
qp->event() with a NULL pointer.

Move both assignments before the firmware call.

Also set ibqp.qp_num inside mlx5_qpc_create_qp() before
create_resource_common() so an EQE arriving early does not observe
qp_num==0.

In addition, add a WARN_ON_ONCE(!qp->event) guard in
rsc_event_notifier() as a safeguard for future regressions.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-14-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c  | 22 ++++++++++------------
 drivers/infiniband/hw/mlx5/qpc.c | 10 ++++++++++
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0f95898182e3d..60dda72c2d0b2 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1624,6 +1624,8 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 		if (err)
 			return err;
 
+		sq->base.container_mibqp = qp;
+		sq->base.mqp.event = mlx5_ib_qp_event;
 		err = create_raw_packet_qp_sq(dev, udata, attrs, sq, in, pd,
 					      to_mcq(init_attr->send_cq));
 		if (err)
@@ -1635,9 +1637,6 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 			resp->sqn = sq->base.mqp.qpn;
 			resp->comp_mask |= MLX5_IB_CREATE_QP_RESP_MASK_SQN;
 		}
-
-		sq->base.container_mibqp = qp;
-		sq->base.mqp.event = mlx5_ib_qp_event;
 	}
 
 	if (qp->rq.wqe_cnt) {
@@ -2093,13 +2092,13 @@ static int create_xrc_tgt_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	}
 
 	base = &qp->trans_qp.base;
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
 		return err;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2237,14 +2236,14 @@ static int create_dci(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
 	}
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 
 	kvfree(in);
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2433,6 +2432,8 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 		qp->flags &= ~IB_QP_CREATE_PCI_WRITE_END_PADDING;
 	}
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	if (init_attr->qp_type == IB_QPT_RAW_PACKET ||
 	    qp->flags & IB_QP_CREATE_SOURCE_QPN) {
 		qp->raw_packet_qp.sq.ubuffer.buf_addr = ucmd->sq_buf_addr;
@@ -2447,8 +2448,6 @@ static int create_user_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
 	if (MLX5_CAP_GEN(mdev, ece_support))
 		params->resp.ece_options = MLX5_GET(create_qp_out, out, ece);
 
@@ -2578,14 +2577,13 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 	    MLX5_CAP_GEN(mdev, go_back_n))
 		MLX5_SET(qpc, qpc, retry_mode, MLX5_QP_RM_GO_BACK_N);
 
+	base->container_mibqp = qp;
+	base->mqp.event = mlx5_ib_qp_event;
 	err = mlx5_qpc_create_qp(dev, &base->mqp, in, inlen, out);
 	kvfree(in);
 	if (err)
 		goto err_create;
 
-	base->container_mibqp = qp;
-	base->mqp.event = mlx5_ib_qp_event;
-
 	get_cqs(qp->type, attr->send_cq, attr->recv_cq,
 		&send_cq, &recv_cq);
 	spin_lock_irqsave(&dev->reset_flow_resource_lock, flags);
diff --git a/drivers/infiniband/hw/mlx5/qpc.c b/drivers/infiniband/hw/mlx5/qpc.c
index a7a4f9420271a..77ddab666ecdc 100644
--- a/drivers/infiniband/hw/mlx5/qpc.c
+++ b/drivers/infiniband/hw/mlx5/qpc.c
@@ -146,6 +146,8 @@ static int rsc_event_notifier(struct notifier_block *nb,
 	case MLX5_RES_RQ:
 	case MLX5_RES_SQ:
 		qp = (struct mlx5_core_qp *)common;
+		if (WARN_ON_ONCE(!qp->event))
+			goto out;
 		qp->event(qp, event_type);
 		/* Need to put resource in event handler */
 		return NOTIFY_OK;
@@ -258,6 +260,14 @@ int mlx5_qpc_create_qp(struct mlx5_ib_dev *dev, struct mlx5_core_qp *qp,
 
 	qp->uid = MLX5_GET(create_qp_in, in, uid);
 	qp->qpn = MLX5_GET(create_qp_out, out, qpn);
+	/* Set ibqp.qp_num before create_resource_common() inserts the QP into
+	 * the radix tree and makes it visible to EQE processing.  The
+	 * assignment in create_qp() happens only after this function returns,
+	 * leaving a window where an arriving EQE would observe qp_num == 0.
+	 * create_qp() still overrides this with 0/1 for QP0/QP1, and sets it
+	 * independently for DCT (which does not go through this function).
+	 */
+	to_mibqp(qp)->ibqp.qp_num = qp->qpn;
 
 	err = create_resource_common(dev, qp, MLX5_RES_QP);
 	if (err)
-- 
2.53.0



