Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2E913E204;
	Tue, 23 Jan 2024 01:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971982; cv=none; b=MtfgdbYTxrBfgRP5x+OZWRSSenLkoNC0m941MGoHfRUxXDFXqLE+VOi9S4HdNfMJYfsolbtO9xkQTipW3rYtGudin6cSKHSXPPuK3QwJNwRdesDghWnsICMQbqC52MZfsxx0J9m3qpRr46IC7LilI1zXuR0aQVjx8Rf5r94eZ4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971982; c=relaxed/simple;
	bh=aQHPbnPMv2EDr5J17mdrmULTWE5p640PFHzIY4cacE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B1G0YMvnLd3NZO8UkKesLm0Vhp+vFsqCuJApsgw0fmBYNrOhO1iULu9O82LpZwiXf3jB8gCL1evqDNv17MPD0fFHW+hSKXo+6gKR63nB450i1Hdifh6EyiwmN77Vz3nm7CB2SibBzc0LL6dWm9OJ2cJf6e3ThaYgEn0/HwsILso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fj4jORHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fj4jORHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C35DC433C7;
	Tue, 23 Jan 2024 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971982;
	bh=aQHPbnPMv2EDr5J17mdrmULTWE5p640PFHzIY4cacE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fj4jORHeRx7dFdhIEu/7cG7iMnFln+b1Ca5iImlvLWGIiEEG28Ykyf28l+E39jBPt
	 /fM/U7Vy81B7nrND4E7LnF4B27AOnJzh81wlaShw5f2WzZohayD4rTQ7xO3O4ZYCSc
	 z3MZpu6VkCqAArdR/elQP1xHhX2w/T3YPplFQ1fI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/286] mlxsw: spectrum_acl_tcam: Reorder functions to avoid forward declarations
Date: Mon, 22 Jan 2024 15:59:47 -0800
Message-ID: <20240122235742.884210382@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 194ab9476089bbfc021073214e071a404e375ee6 ]

Move the initialization and de-initialization code further below in
order to avoid forward declarations in the next patch. No functional
changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 483ae90d8f97 ("mlxsw: spectrum_acl_tcam: Fix stack corruption")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlxsw/spectrum_acl_tcam.c        | 130 +++++++++---------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 08d91bfa7b39..ab897b8be39f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -29,71 +29,6 @@ size_t mlxsw_sp_acl_tcam_priv_size(struct mlxsw_sp *mlxsw_sp)
 #define MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_MIN 3000 /* ms */
 #define MLXSW_SP_ACL_TCAM_VREGION_REHASH_CREDITS 100 /* number of entries */
 
-int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
-			   struct mlxsw_sp_acl_tcam *tcam)
-{
-	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
-	u64 max_tcam_regions;
-	u64 max_regions;
-	u64 max_groups;
-	int err;
-
-	mutex_init(&tcam->lock);
-	tcam->vregion_rehash_intrvl =
-			MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_DFLT;
-	INIT_LIST_HEAD(&tcam->vregion_list);
-
-	max_tcam_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-					      ACL_MAX_TCAM_REGIONS);
-	max_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_REGIONS);
-
-	/* Use 1:1 mapping between ACL region and TCAM region */
-	if (max_tcam_regions < max_regions)
-		max_regions = max_tcam_regions;
-
-	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
-	if (!tcam->used_regions) {
-		err = -ENOMEM;
-		goto err_alloc_used_regions;
-	}
-	tcam->max_regions = max_regions;
-
-	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
-	tcam->used_groups = bitmap_zalloc(max_groups, GFP_KERNEL);
-	if (!tcam->used_groups) {
-		err = -ENOMEM;
-		goto err_alloc_used_groups;
-	}
-	tcam->max_groups = max_groups;
-	tcam->max_group_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-						 ACL_MAX_GROUP_SIZE);
-
-	err = ops->init(mlxsw_sp, tcam->priv, tcam);
-	if (err)
-		goto err_tcam_init;
-
-	return 0;
-
-err_tcam_init:
-	bitmap_free(tcam->used_groups);
-err_alloc_used_groups:
-	bitmap_free(tcam->used_regions);
-err_alloc_used_regions:
-	mutex_destroy(&tcam->lock);
-	return err;
-}
-
-void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_tcam *tcam)
-{
-	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
-
-	ops->fini(mlxsw_sp, tcam->priv);
-	bitmap_free(tcam->used_groups);
-	bitmap_free(tcam->used_regions);
-	mutex_destroy(&tcam->lock);
-}
-
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_acl_rule_info *rulei,
 				   u32 *priority, bool fillup_priority)
@@ -1546,6 +1481,71 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_acl_tcam_vregion_rehash_end(mlxsw_sp, vregion, ctx);
 }
 
+int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
+			   struct mlxsw_sp_acl_tcam *tcam)
+{
+	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
+	u64 max_tcam_regions;
+	u64 max_regions;
+	u64 max_groups;
+	int err;
+
+	mutex_init(&tcam->lock);
+	tcam->vregion_rehash_intrvl =
+			MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_DFLT;
+	INIT_LIST_HEAD(&tcam->vregion_list);
+
+	max_tcam_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core,
+					      ACL_MAX_TCAM_REGIONS);
+	max_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_REGIONS);
+
+	/* Use 1:1 mapping between ACL region and TCAM region */
+	if (max_tcam_regions < max_regions)
+		max_regions = max_tcam_regions;
+
+	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
+	if (!tcam->used_regions) {
+		err = -ENOMEM;
+		goto err_alloc_used_regions;
+	}
+	tcam->max_regions = max_regions;
+
+	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
+	tcam->used_groups = bitmap_zalloc(max_groups, GFP_KERNEL);
+	if (!tcam->used_groups) {
+		err = -ENOMEM;
+		goto err_alloc_used_groups;
+	}
+	tcam->max_groups = max_groups;
+	tcam->max_group_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
+						  ACL_MAX_GROUP_SIZE);
+
+	err = ops->init(mlxsw_sp, tcam->priv, tcam);
+	if (err)
+		goto err_tcam_init;
+
+	return 0;
+
+err_tcam_init:
+	bitmap_free(tcam->used_groups);
+err_alloc_used_groups:
+	bitmap_free(tcam->used_regions);
+err_alloc_used_regions:
+	mutex_destroy(&tcam->lock);
+	return err;
+}
+
+void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_acl_tcam *tcam)
+{
+	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
+
+	ops->fini(mlxsw_sp, tcam->priv);
+	bitmap_free(tcam->used_groups);
+	bitmap_free(tcam->used_regions);
+	mutex_destroy(&tcam->lock);
+}
+
 static const enum mlxsw_afk_element mlxsw_sp_acl_tcam_pattern_ipv4[] = {
 	MLXSW_AFK_ELEMENT_SRC_SYS_PORT,
 	MLXSW_AFK_ELEMENT_DMAC_32_47,
-- 
2.43.0



