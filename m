Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215227;
	b=njFU3ZVBjQqpEWeyJS2Fsdwrb8aj5JdNtyyzzY+77gvOO4+5zBBQvPaYKJLfbhJWX+ex
	 1ZGzbE0K+4dXXcRfNDCjUofgZgJrLRml1nz0eAIMlA2sPiRwXPVpN9ULo0dwxam+4c4vE
	 6bcYKyOg6I40n0TB7UBXRtQGKoBwIuefSg60HYpbY/3Nr1dmXYoQyKg08HtpuTX4546L1
	 St60OdSzqz1noP1BsiDO78+DBsr8Z2yd8+yBdn3BiCpWx85jTuVwpeCHe3k3iGQRnJ5zr
	 PDeJfyuxgO4pv9RgpsxPE1EdFapIHTq8Rl/IkLkFLC72H3TGP/hfuFnNkN1EUrQf7kA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKrAE1QMQgOJm80o8TkUmqvp8rMsUl78FxWQAkxyQZs=;
	b=NIp0sx7LzS5oa0nGp9Bmuj+HRr4LvpxKSiNNmqVqTZs/T7V6TwBA3A1Nv+oQBnVs+HfA
	 j11JvtRH2Ac6rGehnQQh4RH8e0t04eOiRKp8S91lik6gQkip1sQbFHlAiUYlewF8iMzz/
	 M1VswSR0h3QxSJHFl4zHnImIK/utVp4RPfoLBXXubtLwxZ4CY9CgQpF9eVcuLIv9LCV+l
	 xwVLjr3Nfd8jD5hipfH+8c+L5e69jTFt9WdDDRJNLUJ7SlwphBryD1Ng+4K+iRJxr3F3p
	 xT1TRRUmIBVCnVLxTHxZPSJa6nhZz/w4nQ8wjAqbif9caAgU8DnpR4pyHUNe3VfiC+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="0bDGBK/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F70E606A31C;
	Wed, 28 Oct 2026 19:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bDGBK/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C034F1F01825;
	Wed, 28 Oct 2026 19:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215227;
	bh=aKrAE1QMQgOJm80o8TkUmqvp8rMsUl78FxWQAkxyQZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bDGBK/YYtDf3vMM3EmcgT9aITCC/SQ9D3+YGg2pgJLguyubDheQGTvuVZqNG5uHJ
	 ndHhrJzJkpGjMa8yxSHYNpZrbJQIx0WC8fKgBICQtia9d4Mlcq0lx47Zwcu6pGL2bq
	 xICwazfwC5fNgaEcpCA1GPRCNnfpHAmriLp/LGXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1093/1887] net/mlx5: Add generic getters for other functions caps
Date: Wed, 28 Oct 2026 17:53:09 +0100
Message-ID: <20261028170524.279508663@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 47d0c500d76c7b1d220c47cd875763fef04eba2e ]

Downstream patch requires to get other function GENERAL2 caps while
mlx5_vport_get_other_func_cap() gets only one type of caps (general).
Rename it to represent this and introduce a generic implementation
of mlx5_vport_get_other_func_cap().

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 894e036a24a2 ("net/mlx5: Fix slab-out-of-bounds in mlx5_query_nic_vport_mac_list")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h        | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c          | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c            | 6 ++++--
 include/linux/mlx5/vport.h                                 | 2 ++
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 3e2f28c08b2b5..004f869661f35 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3905,7 +3905,7 @@ static int mlx5_esw_query_vport_vhca_id(struct mlx5_eswitch *esw, u16 vport_num,
 	if (!query_ctx)
 		return -ENOMEM;
 
-	err = mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx);
+	err = mlx5_vport_get_other_func_general_cap(esw->dev, vport_num, query_ctx);
 	if (err)
 		goto out_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 67c1afc1df8f5..33b546c0eda67 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -315,7 +315,8 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev, bool suspend);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
-int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
+#define mlx5_vport_get_other_func_general_cap(dev, fid, out)		\
+	mlx5_vport_get_other_func_cap(dev, fid, out, MLX5_CAP_GENERAL)
 
 void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work);
 static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 10b9dc2aaf06f..cf2ab6dacdd74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -4,6 +4,7 @@
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
 #include "pci_irq.h"
@@ -101,7 +102,7 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 		goto out;
 	}
 
-	ret = mlx5_vport_get_other_func_cap(dev, function_id, query_cap);
+	ret = mlx5_vport_get_other_func_general_cap(dev, function_id, query_cap);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 2fbad258520f0..81006690db017 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1166,14 +1166,16 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
-int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out,
+				  u16 opmod)
 {
-	u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
 	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
 
+	opmod = (opmod << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
 	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
 	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
 	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
 	MLX5_SET(query_hca_cap_in, in, other_function, true);
 	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 }
+EXPORT_SYMBOL_GPL(mlx5_vport_get_other_func_cap);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index aad53cb72f179..7f31432f44c2c 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -132,4 +132,6 @@ int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
 int mlx5_nic_vport_unaffiliate_multiport(struct mlx5_core_dev *port_mdev);
 
 u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev);
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out,
+				  u16 opmod);
 #endif /* __MLX5_VPORT_H__ */
-- 
2.53.0



