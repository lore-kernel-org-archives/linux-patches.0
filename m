Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214530;
	b=G4CnkNolmtLwYtdTvjTzK/dOor0+R6cSnnowjwK5yzgfzI5S4Jz+fHAG60Dru0LgAfcp
	 3kDbPlhYMC5QHGzOf8ih5TkJBq5r1ZkFBzzBlDqLx+6/d9/5Kf6GO0Tw1OVixBQJ8x17v
	 72A63rMytfTUFMbl10AsKRUNinTaUyE1V9s+wcYF5+1OI4/2GXAMxd4YV9J3mOSvVT2Gn
	 EIbm0jw0CnfcW5OV4vxfMjlwgx20T/mARbJ8EWrOEKhcybESaE1a6KqaTp6unO8uu4NV0
	 mBBiVwFwsEZBNom+BHAMLVNqCbtC/v5Rgglfg5vVWdiC43e1dCWZal4GQW8KhwUiTVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kc8pT2NAzm5jH2/0dgLCrvy4uVcoNOytkEx4tRIvFQw=;
	b=CGhV30yND+m6sCbwpR+2hv/jsSntJDAdybVThcOtl3Pg24fpjHKEpQdBxW80+dsGjJ7c
	 wPvMkggYPFVAu4tfYea/bkCMA68Uhr0TOOPIPj3RzgUayD4ZmxXiHWNQvpgTqWUIQD+zU
	 kBVpPx6BD2MsYQ/G8Mv6UtZhn0IQiuUStWVTyqS1kjkIipRrPv7ViOdmYlUYDZ+xh/pMN
	 ssNVCO0bGVnqvcvj5IsP/qeUU17GELYWAZwG+MlZtgYOgD2eKgBEk/D8+1t1/VFISSrFq
	 G7TesNepKX6/PsrJGubFssHGkoEPeZCccky19uOzL4gotrlivFHf3kM1CrLRoYUTQmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3PeEmhn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3824C606BFB4;
	Wed, 28 Oct 2026 19:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l3PeEmhn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B83E1F01825;
	Wed, 28 Oct 2026 19:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214529;
	bh=kc8pT2NAzm5jH2/0dgLCrvy4uVcoNOytkEx4tRIvFQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l3PeEmhnWffhaAreMoy5GyZpNuB8bTa2MRno7MjNu9HPQPNHNJqj7Q/vLZw+ZBRaB
	 DOkph+lcSpylg3iTu2YppgooQBtwtbPp21G6eD/RqIYE+yRe717iCeG6NgkTYxjkyq
	 EOfrSJX5307iq4KG/hr3E7usklLiq3x+ENHZd94A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0890/1887] mlx5: Fix default values in create CQ
Date: Wed, 28 Oct 2026 17:49:46 +0100
Message-ID: <20261028170519.672431787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Akiva Goldberger <agoldberger@nvidia.com>

[ Upstream commit e5eba42f01340f73888dfe560be2806057c25913 ]

Currently, CQs without a completion function are assigned the
mlx5_add_cq_to_tasklet function by default. This is problematic since
only user CQs created through the mlx5_ib driver are intended to use
this function.

Additionally, all CQs that will use doorbells instead of polling for
completions must call mlx5_cq_arm. However, the default CQ creation flow
leaves a valid value in the CQ's arm_db field, allowing FW to send
interrupts to polling-only CQs in certain corner cases.

These two factors would allow a polling-only kernel CQ to be triggered
by an EQ interrupt and call a completion function intended only for user
CQs, causing a null pointer exception.

Some areas in the driver have prevented this issue with one-off fixes
but did not address the root cause.

This patch fixes the described issue by adding defaults to the create CQ
flow. It adds a default dummy completion function to protect against
null pointer exceptions, and it sets an invalid command sequence number
by default in kernel CQs to prevent the FW from sending an interrupt to
the CQ until it is armed. User CQs are responsible for their own
initialization values.

Callers of mlx5_core_create_cq are responsible for changing the
completion function and arming the CQ per their needs.

Fixes: cdd04f4d4d71 ("net/mlx5: Add support to create SQ and CQ for ASO")
Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Acked-by: Leon Romanovsky <leon@kernel.org>
Link: https://patch.msgid.link/1762681743-1084694-1-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cq.c               | 11 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/cq.c  | 23 +++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 -
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   | 17 ++++++-----
 .../mellanox/mlx5/core/steering/dr_send.c     | 28 +++++--------------
 drivers/vdpa/mlx5/net/mlx5_vnet.c             |  6 ++--
 include/linux/mlx5/cq.h                       |  1 +
 7 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 886e9560e913e..b5c2e0e1d82b2 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -1009,15 +1009,18 @@ int mlx5_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	if (cq->create_flags & IB_UVERBS_CQ_FLAGS_IGNORE_OVERRUN)
 		MLX5_SET(cqc, cqc, oi, 1);
 
+	if (udata) {
+		cq->mcq.comp = mlx5_add_cq_to_tasklet;
+		cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
+	} else {
+		cq->mcq.comp  = mlx5_ib_cq_comp;
+	}
+
 	err = mlx5_core_create_cq(dev->mdev, &cq->mcq, cqb, inlen, out, sizeof(out));
 	if (err)
 		goto err_cqb;
 
 	mlx5_ib_dbg(dev, "cqn 0x%x\n", cq->mcq.cqn);
-	if (udata)
-		cq->mcq.tasklet_ctx.comp = mlx5_ib_cq_comp;
-	else
-		cq->mcq.comp  = mlx5_ib_cq_comp;
 	cq->mcq.event = mlx5_ib_cq_event;
 
 	INIT_LIST_HEAD(&cq->wc_list);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
index 4caa1b6f40ba4..d21c14bb3ecfc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
@@ -66,8 +66,8 @@ void mlx5_cq_tasklet_cb(struct tasklet_struct *t)
 		tasklet_schedule(&ctx->task);
 }
 
-static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
-				   struct mlx5_eqe *eqe)
+void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
+			    struct mlx5_eqe *eqe)
 {
 	unsigned long flags;
 	struct mlx5_eq_tasklet *tasklet_ctx = cq->tasklet_ctx.priv;
@@ -84,7 +84,15 @@ static void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq,
 	}
 	spin_unlock_irqrestore(&tasklet_ctx->lock, flags);
 }
+EXPORT_SYMBOL(mlx5_add_cq_to_tasklet);
 
+static void mlx5_core_cq_dummy_cb(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe)
+{
+	mlx5_core_err(cq->eq->core.dev,
+		      "CQ default completion callback, CQ #%u\n", cq->cqn);
+}
+
+#define MLX5_CQ_INIT_CMD_SN cpu_to_be32(2 << 28)
 /* Callers must verify outbox status in case of err */
 int mlx5_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 		   u32 *in, int inlen, u32 *out, int outlen)
@@ -110,10 +118,19 @@ int mlx5_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 	cq->arm_sn     = 0;
 	cq->eq         = eq;
 	cq->uid = MLX5_GET(create_cq_in, in, uid);
+
+	/* Kernel CQs must set the arm_db address prior to calling
+	 * this function, allowing for the proper value to be
+	 * initialized. User CQs are responsible for their own
+	 * initialization since they do not use the arm_db field.
+	 */
+	if (cq->arm_db)
+		*cq->arm_db = MLX5_CQ_INIT_CMD_SN;
+
 	refcount_set(&cq->refcount, 1);
 	init_completion(&cq->free);
 	if (!cq->comp)
-		cq->comp = mlx5_add_cq_to_tasklet;
+		cq->comp = mlx5_core_cq_dummy_cb;
 	/* assuming CQ will be deleted before the EQ */
 	cq->tasklet_ctx.priv = &eq->tasklet_ctx;
 	INIT_LIST_HEAD(&cq->tasklet_ctx.list);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f05fe8074b755..6daaafc7ff9d6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1862,7 +1862,6 @@ static int mlx5e_alloc_cq_common(struct mlx5e_priv *priv,
 	mcq->set_ci_db  = cq->wq_ctrl.db.db;
 	mcq->arm_db     = cq->wq_ctrl.db.db + 1;
 	*mcq->set_ci_db = 0;
-	*mcq->arm_db    = 0;
 	mcq->vector     = param->eq_ix;
 	mcq->comp       = mlx5e_completion_event;
 	mcq->event      = mlx5e_cq_error_event;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 12abe991583a8..23eadac8c79b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -437,6 +437,14 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 		cqe->op_own = MLX5_CQE_INVALID << 4 | MLX5_CQE_OWNER_MASK;
 	}
 
+	conn->cq.mcq.cqe_sz     = 64;
+	conn->cq.mcq.set_ci_db  = conn->cq.wq_ctrl.db.db;
+	conn->cq.mcq.arm_db     = conn->cq.wq_ctrl.db.db + 1;
+	*conn->cq.mcq.set_ci_db = 0;
+	conn->cq.mcq.vector     = 0;
+	conn->cq.mcq.comp       = mlx5_fpga_conn_cq_complete;
+	conn->cq.mcq.uar        = fdev->conn_res.uar;
+
 	inlen = MLX5_ST_SZ_BYTES(create_cq_in) +
 		sizeof(u64) * conn->cq.wq_ctrl.buf.npages;
 	in = kvzalloc(inlen, GFP_KERNEL);
@@ -468,16 +476,7 @@ static int mlx5_fpga_conn_create_cq(struct mlx5_fpga_conn *conn, int cq_size)
 	if (err)
 		goto err_cqwq;
 
-	conn->cq.mcq.cqe_sz     = 64;
-	conn->cq.mcq.set_ci_db  = conn->cq.wq_ctrl.db.db;
-	conn->cq.mcq.arm_db     = conn->cq.wq_ctrl.db.db + 1;
-	*conn->cq.mcq.set_ci_db = 0;
-	*conn->cq.mcq.arm_db    = 0;
-	conn->cq.mcq.vector     = 0;
-	conn->cq.mcq.comp       = mlx5_fpga_conn_cq_complete;
-	conn->cq.mcq.uar        = fdev->conn_res.uar;
 	tasklet_setup(&conn->cq.tasklet, mlx5_fpga_conn_cq_tasklet);
-
 	mlx5_fpga_dbg(fdev, "Created CQ #0x%x\n", conn->cq.mcq.cqn);
 
 	goto out;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index ef19a66f52335..5a9fb24856ab9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -748,12 +748,6 @@ static int dr_prepare_qp_to_rts(struct mlx5dr_domain *dmn)
 	return 0;
 }
 
-static void dr_cq_complete(struct mlx5_core_cq *mcq,
-			   struct mlx5_eqe *eqe)
-{
-	pr_err("CQ completion CQ: #%u\n", mcq->cqn);
-}
-
 static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 				      struct mlx5_uars_page *uar,
 				      size_t ncqe)
@@ -789,6 +783,13 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 		cqe->op_own = MLX5_CQE_INVALID << 4 | MLX5_CQE_OWNER_MASK;
 	}
 
+	cq->mcq.cqe_sz = 64;
+	cq->mcq.set_ci_db = cq->wq_ctrl.db.db;
+	cq->mcq.arm_db = cq->wq_ctrl.db.db + 1;
+	*cq->mcq.set_ci_db = 0;
+	cq->mcq.vector = 0;
+	cq->mcq.uar = uar;
+
 	inlen = MLX5_ST_SZ_BYTES(create_cq_in) +
 		sizeof(u64) * cq->wq_ctrl.buf.npages;
 	in = kvzalloc(inlen, GFP_KERNEL);
@@ -813,27 +814,12 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_dev *mdev,
 	pas = (__be64 *)MLX5_ADDR_OF(create_cq_in, in, pas);
 	mlx5_fill_page_frag_array(&cq->wq_ctrl.buf, pas);
 
-	cq->mcq.comp  = dr_cq_complete;
-
 	err = mlx5_core_create_cq(mdev, &cq->mcq, in, inlen, out, sizeof(out));
 	kvfree(in);
 
 	if (err)
 		goto err_cqwq;
 
-	cq->mcq.cqe_sz = 64;
-	cq->mcq.set_ci_db = cq->wq_ctrl.db.db;
-	cq->mcq.arm_db = cq->wq_ctrl.db.db + 1;
-	*cq->mcq.set_ci_db = 0;
-
-	/* set no-zero value, in order to avoid the HW to run db-recovery on
-	 * CQ that used in polling mode.
-	 */
-	*cq->mcq.arm_db = cpu_to_be32(2 << 28);
-
-	cq->mcq.vector = 0;
-	cq->mcq.uar = uar;
-
 	return cq;
 
 err_cqwq:
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index 74d295312466f..a599259af8632 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -594,6 +594,8 @@ static int cq_create(struct mlx5_vdpa_net *ndev, u16 idx, u32 num_ent)
 	vcq->mcq.set_ci_db = vcq->db.db;
 	vcq->mcq.arm_db = vcq->db.db + 1;
 	vcq->mcq.cqe_sz = 64;
+	vcq->mcq.comp = mlx5_vdpa_cq_comp;
+	vcq->cqe = num_ent;
 
 	err = cq_frag_buf_alloc(ndev, &vcq->buf, num_ent);
 	if (err)
@@ -633,10 +635,6 @@ static int cq_create(struct mlx5_vdpa_net *ndev, u16 idx, u32 num_ent)
 	if (err)
 		goto err_vec;
 
-	vcq->mcq.comp = mlx5_vdpa_cq_comp;
-	vcq->cqe = num_ent;
-	vcq->mcq.set_ci_db = vcq->db.db;
-	vcq->mcq.arm_db = vcq->db.db + 1;
 	mlx5_cq_arm(&mvq->cq.mcq, MLX5_CQ_DB_REQ_NOT, uar_page, mvq->cq.mcq.cons_index);
 	kfree(in);
 	return 0;
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index cb15308b5cb0b..804432fd0f271 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -183,6 +183,7 @@ static inline void mlx5_cq_put(struct mlx5_core_cq *cq)
 		complete(&cq->free);
 }
 
+void mlx5_add_cq_to_tasklet(struct mlx5_core_cq *cq, struct mlx5_eqe *eqe);
 int mlx5_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
 		   u32 *in, int inlen, u32 *out, int outlen);
 int mlx5_core_create_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
-- 
2.53.0



