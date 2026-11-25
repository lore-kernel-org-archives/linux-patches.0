Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619129;
	b=pMINyHmY3gDWJCBd3R9drJyOQmxinpurepnJkOg++gIpKqqa7z6BBbW/cpmPC4rymv5t
	 0uVkAPfJdwU8WzIAcBfMqmtWOi0MXxYTfPEt1r5nSFSwxalrRjMNYYDkllANC1OeJpUKh
	 TgF6n0lTjrNRoPlTcbeY4hrKKo+R6pYXomCWFHS3OVOMCRAZHPSYKY4OccHeCc2ZHErxz
	 AWtlxuLg1p+lp6gDuL1n5R89Sfgqz88/YgDXLCRgEMihEPtxzYvgK4ReiDEMWbrt283xU
	 RxItBRlz7ITsQySsz6+cFjc9kRUylPjWZOXFgJzeJxTgs3o7rEOSjyPIF+LL9BY2cWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619129;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h/fd3B16Av7iEx4vWwRIT35b62dBJ6fYvP8EOm5OPzg=;
	b=trz+Eh3beaT6k512AiQ6jbArdrmGdHg/oQ1fz6AndFxRpXUj1kTcE3OV6dsntHHFeovM
	 ETi8EvYHhuFgbo9uKGShYWlD4RXflQJ19Cuy15NnC4g57j4AUnG85tDpBku6ZiqxhhQBJ
	 cgx2jJ5yRXyLhvptcAATM8/mLt6sZHXaYvt95XRUOb6PHr6MGlzb6uPie45+GUa5tpPVR
	 +DXc4O9fIwrP/dTt5cs9wSgb0euaR6dCbaIrXqkyLxQZmeAqiRSdTWT8Wkt6OXcPy+TF3
	 Hl8Q6cchOc6XihiOHoO7DMNHrPgIG374blIGV7dx0pguHPwUUoalmcUO7Dse2zF7vsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDCtj99B;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02CB0606A31E;
	Wed, 25 Nov 2026 15:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wDCtj99B
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033961F000D2;
	Wed, 25 Nov 2026 15:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619128;
	bh=h/fd3B16Av7iEx4vWwRIT35b62dBJ6fYvP8EOm5OPzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDCtj99Bie3dWuQ3hY45A/S7Ejlw77VZh+YHCm0s8O+fMdHQpvhLAuwrg4e5Ck4N/
	 +3TRN4fNJzyDioGENuhtzh15Df9EPcp/cOUINVHSuReTIkqNHOikQ70b/EqvS6Hmd5
	 k+TAxhurqACjLQTtt/qck3ip9yGdrAiaMurplA6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0497/1005] net/mlx5e: Release IPsec root table reference on RX setup failure
Date: Wed, 25 Nov 2026 15:30:35 +0100
Message-ID: <20261125143833.387018387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit e8303b58108519ff103241442c0a7602fa106af5 ]

Switchdev RX setup takes a root-chain table reference before creating
its flow tables. If creation fails, rx_get() returns without
incrementing the RX reference count, so rx_destroy() never releases the
chain reference.

Extract the cleanup logic in a counter-partner to the function acquiring
the root table ref, and call it on error to properly release everything.
Also call it from the normal destroy path to reduce code duplication.

mlx5_esw_ipsec_rx_status_pass_dest_get() ignored chain table acquisition
errors, returning success with an error pointer as the destination. The
new unwind could then release a reference that was never taken.
Propagate the error so cleanup only runs after a successful get.

Discovered by Sashiko. Not triggered as it's an unlikely error path.

Fixes: 1762f132d542 ("net/mlx5e: Support IPsec packet offload for RX in switchdev mode")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261105211637.1083978-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 20 +++++++++++--------
 .../mellanox/mlx5/core/esw/ipsec_fs.c         | 15 ++++++++++++--
 .../mellanox/mlx5/core/esw/ipsec_fs.h         |  6 ++++++
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 8ffa8068e90ac..fd9fbf3593330 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -720,6 +720,16 @@ static void ipsec_rx_sa_selector_destroy(struct mlx5_core_dev *mdev,
 	mlx5_destroy_flow_table(rx->ft.sa_sel);
 }
 
+static void
+ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec,
+			      struct mlx5e_ipsec_rx *rx,
+			      u32 family)
+{
+	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce, family, ipsec->mdev);
+	if (rx == ipsec->rx_esw)
+		mlx5_esw_ipsec_rx_status_pass_dest_put(ipsec);
+}
+
 static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 		       struct mlx5e_ipsec_rx *rx, u32 family)
 {
@@ -739,13 +749,7 @@ static void rx_destroy(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 
 	ipsec_rx_policy_destroy(rx);
 
-	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce, family, mdev);
-
-#ifdef CONFIG_MLX5_ESWITCH
-	if (rx == ipsec->rx_esw)
-		mlx5_chains_put_table(esw_chains(ipsec->mdev->priv.eswitch),
-				      0, 1, 0);
-#endif
+	ipsec_rx_status_pass_dest_put(ipsec, rx, family);
 }
 
 static void ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
@@ -1115,7 +1119,7 @@ static int rx_create(struct mlx5_core_dev *mdev, struct mlx5e_ipsec *ipsec,
 err_fs_ft_sa_sel:
 	mlx5_destroy_flow_table(rx->ft.status);
 err_fs_ft_status:
-	mlx5_ipsec_fs_roce_rx_destroy(ipsec->roce, family, mdev);
+	ipsec_rx_status_pass_dest_put(ipsec, rx, family);
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
index ab50d2c734ede..f8c97954b6eaf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.c
@@ -34,12 +34,23 @@ void mlx5_esw_ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
 int mlx5_esw_ipsec_rx_status_pass_dest_get(struct mlx5e_ipsec *ipsec,
 					   struct mlx5_flow_destination *dest)
 {
-	dest->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
-	dest->ft = mlx5_chains_get_table(esw_chains(ipsec->mdev->priv.eswitch), 0, 1, 0);
+	struct mlx5_flow_table *ft;
+
+	ft = mlx5_chains_get_table(esw_chains(ipsec->mdev->priv.eswitch),
+				   0, 1, 0);
+	if (IS_ERR(ft))
+		return PTR_ERR(ft);
 
+	dest->type = MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
+	dest->ft = ft;
 	return 0;
 }
 
+void mlx5_esw_ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec)
+{
+	mlx5_chains_put_table(esw_chains(ipsec->mdev->priv.eswitch), 0, 1, 0);
+}
+
 int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 					  struct mlx5_flow_act *flow_act)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h
index 514c15258b1d1..bb6f2423078bd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec_fs.h
@@ -12,6 +12,7 @@ void mlx5_esw_ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
 				       struct mlx5e_ipsec_rx_create_attr *attr);
 int mlx5_esw_ipsec_rx_status_pass_dest_get(struct mlx5e_ipsec *ipsec,
 					   struct mlx5_flow_destination *dest);
+void mlx5_esw_ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec);
 int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 					  struct mlx5_flow_act *flow_act);
 void mlx5_esw_ipsec_rx_id_mapping_remove(struct mlx5e_ipsec_sa_entry *sa_entry);
@@ -32,6 +33,11 @@ static inline int mlx5_esw_ipsec_rx_status_pass_dest_get(struct mlx5e_ipsec *ips
 	return -EINVAL;
 }
 
+static inline
+void mlx5_esw_ipsec_rx_status_pass_dest_put(struct mlx5e_ipsec *ipsec)
+{
+}
+
 static inline int mlx5_esw_ipsec_rx_setup_modify_header(struct mlx5e_ipsec_sa_entry *sa_entry,
 							struct mlx5_flow_act *flow_act)
 {
-- 
2.53.0



