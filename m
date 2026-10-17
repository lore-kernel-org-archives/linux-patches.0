Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176ED339365;
	Sat, 17 Oct 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253559; cv=none; b=U/5Rc+dwJW0kH9cWq5yIC1GTZJiaoI8KCjYxu+fxfUOjNzgvuRJDbrCgHDYZkmLE8zYaCY4K5NJJgtePcGv9kIJ2WrYKLP5p/oiRpl6kGazdYqjGxCQIUnekWQP7kMb3ua6IJES8xnDm9oPpJ5qq9jzcUNX66pLdZaLCMR0OCpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253559; c=relaxed/simple;
	bh=PjwkKKb9gGyQRv6m5yD1RzUQ+xSt3jH1IaK8lArulmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q6YyonNML32ch4cK+GlKLhp3mY4G+PUscKVDWRNBBLjgjPsj96RezyJIP1XoOtFypts3JXwMzz9ztLUWPerpFEUGl0CmSrOwStwgZx/ofluT9fLONE0UzknEQCLxOjJvrc+SJ9TnwZw45kP72OKQxxEC+NA6InuKkKXw3QMo04E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oJ6rkD8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oJ6rkD8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E1861F000C4;
	Sat, 17 Oct 2026 16:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253558;
	bh=IDMYSfuuQ/F5PL36yqXD36BVwplaB78+k+Xf9gl4EXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oJ6rkD8/RPkLImb4hR3we8ZFyP8C7EsYQRGk07ZTHe9Mnmzh3oJDmZzT2TzcpkrlY
	 eTwwwBLb+oZAzjCXKbFGtophZDTRZN1wD0BL+TmTwHZ1PKSbElqLz3AW+Smouj+KWd
	 37X+dcISqGDiTBkJieBefDoMic5iELwAGbRn4+AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 116/869] net/mlx5: HWS, Remove unused element array
Date: Sat, 17 Oct 2026 17:49:17 +0200
Message-ID: <20261017160040.017067192@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit b2ae16214ffeda3e1c25223eebe19f85b0876181 ]

Remove the array of elements wrapped in a struct because in reality only
the first element was ever used.

Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/1744312662-356571-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2c0a959bebdc ("net/mlx5: HWS, Fix memory leak in hws_pool_buddy_init error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mlx5/core/steering/hws/mlx5hws_pool.c     | 55 ++++++++-----------
 .../mlx5/core/steering/hws/mlx5hws_pool.h     |  6 +-
 2 files changed, 23 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
index 048b97de07625..866e6938e340c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.c
@@ -293,7 +293,7 @@ static int hws_pool_create_resource_on_index(struct mlx5hws_pool *pool,
 }
 
 static struct mlx5hws_pool_elements *
-hws_pool_element_create_new_elem(struct mlx5hws_pool *pool, u32 order, int idx)
+hws_pool_element_create_new_elem(struct mlx5hws_pool *pool, u32 order)
 {
 	struct mlx5hws_pool_elements *elem;
 	u32 alloc_size;
@@ -311,21 +311,21 @@ hws_pool_element_create_new_elem(struct mlx5hws_pool *pool, u32 order, int idx)
 		elem->bitmap = hws_pool_create_and_init_bitmap(alloc_size - order);
 		if (!elem->bitmap) {
 			mlx5hws_err(pool->ctx,
-				    "Failed to create bitmap type: %d: size %d index: %d\n",
-				    pool->type, alloc_size, idx);
+				    "Failed to create bitmap type: %d: size %d\n",
+				    pool->type, alloc_size);
 			goto free_elem;
 		}
 
 		elem->log_size = alloc_size - order;
 	}
 
-	if (hws_pool_create_resource_on_index(pool, alloc_size, idx)) {
-		mlx5hws_err(pool->ctx, "Failed to create resource type: %d: size %d index: %d\n",
-			    pool->type, alloc_size, idx);
+	if (hws_pool_create_resource_on_index(pool, alloc_size, 0)) {
+		mlx5hws_err(pool->ctx, "Failed to create resource type: %d: size %d\n",
+			    pool->type, alloc_size);
 		goto free_db;
 	}
 
-	pool->db.element_manager->elements[idx] = elem;
+	pool->db.element = elem;
 
 	return elem;
 
@@ -359,9 +359,9 @@ hws_pool_onesize_element_get_mem_chunk(struct mlx5hws_pool *pool, u32 order,
 {
 	struct mlx5hws_pool_elements *elem;
 
-	elem = pool->db.element_manager->elements[0];
+	elem = pool->db.element;
 	if (!elem)
-		elem = hws_pool_element_create_new_elem(pool, order, 0);
+		elem = hws_pool_element_create_new_elem(pool, order);
 	if (!elem)
 		goto err_no_elem;
 
@@ -451,16 +451,14 @@ static int hws_pool_general_element_db_init(struct mlx5hws_pool *pool)
 	return 0;
 }
 
-static void hws_onesize_element_db_destroy_element(struct mlx5hws_pool *pool,
-						   struct mlx5hws_pool_elements *elem,
-						   struct mlx5hws_pool_chunk *chunk)
+static void
+hws_onesize_element_db_destroy_element(struct mlx5hws_pool *pool,
+				       struct mlx5hws_pool_elements *elem)
 {
-	if (unlikely(!pool->resource[chunk->resource_idx]))
-		pr_warn("HWS: invalid resource with index %d\n", chunk->resource_idx);
-
-	hws_pool_resource_free(pool, chunk->resource_idx);
+	hws_pool_resource_free(pool, 0);
+	bitmap_free(elem->bitmap);
 	kfree(elem);
-	pool->db.element_manager->elements[chunk->resource_idx] = NULL;
+	pool->db.element = NULL;
 }
 
 static void hws_onesize_element_db_put_chunk(struct mlx5hws_pool *pool,
@@ -471,7 +469,7 @@ static void hws_onesize_element_db_put_chunk(struct mlx5hws_pool *pool,
 	if (unlikely(chunk->resource_idx))
 		pr_warn("HWS: invalid resource with index %d\n", chunk->resource_idx);
 
-	elem = pool->db.element_manager->elements[chunk->resource_idx];
+	elem = pool->db.element;
 	if (!elem) {
 		mlx5hws_err(pool->ctx, "No such element (%d)\n", chunk->resource_idx);
 		return;
@@ -483,7 +481,7 @@ static void hws_onesize_element_db_put_chunk(struct mlx5hws_pool *pool,
 
 	if (pool->flags & MLX5HWS_POOL_FLAGS_RELEASE_FREE_RESOURCE &&
 	    !elem->num_of_elements)
-		hws_onesize_element_db_destroy_element(pool, elem, chunk);
+		hws_onesize_element_db_destroy_element(pool, elem);
 }
 
 static int hws_onesize_element_db_get_chunk(struct mlx5hws_pool *pool,
@@ -504,18 +502,13 @@ static int hws_onesize_element_db_get_chunk(struct mlx5hws_pool *pool,
 
 static void hws_onesize_element_db_uninit(struct mlx5hws_pool *pool)
 {
-	struct mlx5hws_pool_elements *elem;
-	int i;
+	struct mlx5hws_pool_elements *elem = pool->db.element;
 
-	for (i = 0; i < MLX5HWS_POOL_RESOURCE_ARR_SZ; i++) {
-		elem = pool->db.element_manager->elements[i];
-		if (elem) {
-			bitmap_free(elem->bitmap);
-			kfree(elem);
-			pool->db.element_manager->elements[i] = NULL;
-		}
+	if (elem) {
+		bitmap_free(elem->bitmap);
+		kfree(elem);
+		pool->db.element = NULL;
 	}
-	kfree(pool->db.element_manager);
 }
 
 /* This memory management works as the following:
@@ -526,10 +519,6 @@ static void hws_onesize_element_db_uninit(struct mlx5hws_pool *pool)
  */
 static int hws_pool_onesize_element_db_init(struct mlx5hws_pool *pool)
 {
-	pool->db.element_manager = kzalloc(sizeof(*pool->db.element_manager), GFP_KERNEL);
-	if (!pool->db.element_manager)
-		return -ENOMEM;
-
 	pool->p_db_uninit = &hws_onesize_element_db_uninit;
 	pool->p_get_chunk = &hws_onesize_element_db_get_chunk;
 	pool->p_put_chunk = &hws_onesize_element_db_put_chunk;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.h
index 621298b352b24..f4258f83fdbf7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_pool.h
@@ -87,14 +87,10 @@ struct mlx5hws_pool_elements {
 	bool is_full;
 };
 
-struct mlx5hws_element_manager {
-	struct mlx5hws_pool_elements *elements[MLX5HWS_POOL_RESOURCE_ARR_SZ];
-};
-
 struct mlx5hws_pool_db {
 	enum mlx5hws_db_type type;
 	union {
-		struct mlx5hws_element_manager *element_manager;
+		struct mlx5hws_pool_elements *element;
 		struct mlx5hws_buddy_manager *buddy_manager;
 	};
 };
-- 
2.53.0



