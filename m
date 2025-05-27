Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C082925FA1D;
	Tue, 27 May 2025 17:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365217; cv=none; b=uhZL6llSU7jINbewlxjCdf9EpY4dFuzuzzSwGxwr4KLUsxBRzdD6cXiaNYD9AIWzhacqwaluAhn37RZFk9JZMqcqYj8J4qR9yEgwfEz8pjIWuW77Pt5VxWLHUAi5TWFMljo7BqBdkbrnGpiQpK5MwjHU9vMr9+U6+JxCqqVq0JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365217; c=relaxed/simple;
	bh=LHJD2AWLchEXXTbL9LNU4yog1CZ+IZDxNF+92dxC9to=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnxnNQeEcHEk2CxAcjS8s/dLMAzYdc0B78PuWwXD5qPbv6nIY0xNrFj7muId6RYcvILeSiNYB3s5CGa6e0UpjFTq0dGqLL9DuFslTClsIoCvrcuqgady2lA+QH4WH2f+SbVjtynXgKYQC1UXLhWRudDrvqKu1kQocyi19H4bniQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IGmav5eH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IGmav5eH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261D0C4CEE9;
	Tue, 27 May 2025 17:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365217;
	bh=LHJD2AWLchEXXTbL9LNU4yog1CZ+IZDxNF+92dxC9to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IGmav5eHZ/i3NkibzIQhmkt+rG4CT7ZpHjD+/uZPE/RNXyWjWJIl/v6CUlC0A/XUH
	 7oX708WH3QPIWzLx5u6h51W0wcocMt8z0XtGPapAypkOHJ50AIj+NLeSC9SOPQr/zf
	 QokdlKXG9J14Hbk0q13m0j5WiIz9T5Ww6z6xo/ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/626] net/mlx5: Change POOL_NEXT_SIZE define value and make it global
Date: Tue, 27 May 2025 18:23:17 +0200
Message-ID: <20250527162457.378801822@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 80df31f384b4146a62a01b3d4beb376cc7b9a89e ]

Change POOL_NEXT_SIZE define value from 0 to BIT(30), since this define
is used to request the available maximum sized flow table, and zero doesn't
make sense for it, whereas some places in the driver use zero explicitly
expecting the smallest table size possible but instead due to this
define they end up allocating the biggest table size unawarely.

In addition move the definition to "include/linux/mlx5/fs.h" to expose the
define to IB driver as well, while appropriately renaming it.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250219085808.349923-3-tariqt@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c    | 6 ++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h    | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 3 ++-
 include/linux/mlx5/fs.h                                 | 2 ++
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 8587cd572da53..bdb825aa87268 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -96,7 +96,7 @@ static int esw_create_legacy_fdb_table(struct mlx5_eswitch *esw)
 	if (!flow_group_in)
 		return -ENOMEM;
 
-	ft_attr.max_fte = POOL_NEXT_SIZE;
+	ft_attr.max_fte = MLX5_FS_MAX_POOL_SIZE;
 	ft_attr.prio = LEGACY_FDB_PRIO;
 	fdb = mlx5_create_flow_table(root_ns, &ft_attr);
 	if (IS_ERR(fdb)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
index c14590acc7726..f6abfd00d7e68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
@@ -50,10 +50,12 @@ mlx5_ft_pool_get_avail_sz(struct mlx5_core_dev *dev, enum fs_flow_table_type tab
 	int i, found_i = -1;
 
 	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--) {
-		if (dev->priv.ft_pool->ft_left[i] && FT_POOLS[i] >= desired_size &&
+		if (dev->priv.ft_pool->ft_left[i] &&
+		    (FT_POOLS[i] >= desired_size ||
+		     desired_size == MLX5_FS_MAX_POOL_SIZE) &&
 		    FT_POOLS[i] <= max_ft_size) {
 			found_i = i;
-			if (desired_size != POOL_NEXT_SIZE)
+			if (desired_size != MLX5_FS_MAX_POOL_SIZE)
 				break;
 		}
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
index 25f4274b372b5..173e312db7204 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.h
@@ -7,8 +7,6 @@
 #include <linux/mlx5/driver.h>
 #include "fs_core.h"
 
-#define POOL_NEXT_SIZE 0
-
 int mlx5_ft_pool_init(struct mlx5_core_dev *dev);
 void mlx5_ft_pool_destroy(struct mlx5_core_dev *dev);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index 711d14dea2485..d313cb7f0ed88 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -161,7 +161,8 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 		ft_attr.flags |= (MLX5_FLOW_TABLE_TUNNEL_EN_REFORMAT |
 				  MLX5_FLOW_TABLE_TUNNEL_EN_DECAP);
 
-	sz = (chain == mlx5_chains_get_nf_ft_chain(chains)) ? FT_TBL_SZ : POOL_NEXT_SIZE;
+	sz = (chain == mlx5_chains_get_nf_ft_chain(chains)) ?
+		FT_TBL_SZ : MLX5_FS_MAX_POOL_SIZE;
 	ft_attr.max_fte = sz;
 
 	/* We use chains_default_ft(chains) as the table's next_ft till
diff --git a/include/linux/mlx5/fs.h b/include/linux/mlx5/fs.h
index b744e554f014d..db5c9ddef1702 100644
--- a/include/linux/mlx5/fs.h
+++ b/include/linux/mlx5/fs.h
@@ -40,6 +40,8 @@
 
 #define MLX5_SET_CFG(p, f, v) MLX5_SET(create_flow_group_in, p, f, v)
 
+#define MLX5_FS_MAX_POOL_SIZE BIT(30)
+
 enum mlx5_flow_destination_type {
 	MLX5_FLOW_DESTINATION_TYPE_NONE,
 	MLX5_FLOW_DESTINATION_TYPE_VPORT,
-- 
2.39.5



