Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622141;
	b=1xsqa+MYxVprh1swn5cD3x71c32IXk13nQacn8Hs3cxbNJ0u8yvXxO+zYv3ABJSARYI1
	 DHAhekqcmN7+8F7HtE6wRA5Kipn5K4AbDzzgiiVflqGa73NqV5Jz5BhwSa0l6H7JR/pQE
	 IfZvsBagCSm4jV7I4YEFcKnTp7y+aUP7cvJxzk9JFfhqBkFqbBkeVQFPmU78gqCLloX0l
	 lpwKmPhBAL8KokCmqoN7jZM1KwJvTsbs7aBNt9mDZ4Fx2fkQADmx9W//YGeHWdwv1qkhM
	 1JTB8s/cSSa5kd60mRxIwJDf3AXXfEpmf7gPBZNj/c8HOV80RuI4f1BanTeiXijb7Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622141;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BeLCW3vEHN2cFc4EXF/cbngwvpYt+U6a7Fhr8lDl41w=;
	b=AvPSTQDjGz0KWFgcIfYdPNtZdo9qdzvsePVRdB4njrgMWz8xGeRLfmAxShQaMK2ZUE2v
	 oSudMCA763XC9Z/Y9hz0tTr9hjbzP5IQGAF3Fi9eicJ9vq1mraXa3ohHWtAMaCW35WuyZ
	 xqZHUt+GXZPe0QKzxK4guxgoR9wqmtqa1CoaO3dl+/12JU5T7PlzlSluCXwEhqS3fAoez
	 ZuLPuDegBsYXp0KJuIBo+tJPRuYIm7B+x/10y7y2IK54oLpPJifnQuzvh1N9qbbcsgFvx
	 a9UOQ6w4MQ/igxP02anP1U/WdWIVgXbM0TnMdoEa0IQj6eCy2QIXmBRWQ1wRClnCFlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z68T+mpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED68606A32C;
	Wed, 25 Nov 2026 15:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z68T+mpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3326B1F000C6;
	Wed, 25 Nov 2026 15:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622140;
	bh=BeLCW3vEHN2cFc4EXF/cbngwvpYt+U6a7Fhr8lDl41w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z68T+mppjcXjKrCJqIynmKxXbFQFo4QT8kxUQmvKcc6R5R4tRZaGLlOgNqfz4hmUp
	 UZBxEFIemgoUbmU6LuCFoiqWKEphRJXObBMI8La5JUFeB5SfhRHDwIF8Z8fnVc2O1p
	 uiCAyEEjN7ZTURzYQLJcNMZU2Tt2nIHmWaluJRU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 435/990] net/mlx5e: Release IPsec root table reference on RX setup failure
Date: Wed, 25 Nov 2026 15:30:02 +0100
Message-ID: <20261125143832.283904034@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index d8325c0f97c19..be973235c9ff0 100644
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



