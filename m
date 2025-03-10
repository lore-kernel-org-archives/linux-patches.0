Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9205B231A2A;
	Mon, 10 Mar 2025 17:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628959; cv=none; b=OAHLBgnyLRBhQkMCLGzuhOCEW4NDk4CNSwiR66PirKjBClayjnNNEjxq8XyAyZVnvX5mOcwF7AxxTl6omIi7Lrngo7HQC6H+yia2Ol6f+HefuUMxlj/LcZfvvZHwZzfHgTby4rPf8AZdGQ1oinPozkOp/5t7mqe685elUB72XTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628959; c=relaxed/simple;
	bh=8E8v6e1dJmnw0qtmXu1sv02ZUDhzxsiTV76nolcJrPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2ajnY9RTGeT338Say8xaMv07idMYGSMzZTiUUnE50LFHWttiPkGcqw/uy5or9opa0j1uCQ5nsoHkYBHHCUCQmqQLZ/n8eFaSP+xTD2G4gx42F4dmINDJX9ZwMnn9bCp4iwwQ0gUzP2yPHbiqXSpbllEOV/3lPlNuUZ5eldDrAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rNqniytk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rNqniytk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CA9C4CEE5;
	Mon, 10 Mar 2025 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628959;
	bh=8E8v6e1dJmnw0qtmXu1sv02ZUDhzxsiTV76nolcJrPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rNqniytkKBtfmZEptR3y+HyjPDwUB0FxSEI/tXiOxCysucucyB0k57LY1vw2LEdDf
	 01BlsZmdpHxHFcAFBWwBYSE2ns2SzwRMIm7kkj2tu/DSgUW0JOeGb86coYH/YfOY+p
	 Uwv6meZ83UKAtMDAohM6RVnZM9NA08eLkSLHE5Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 129/620] RDMA/mlx5: Remove iova from struct mlx5_core_mkey
Date: Mon, 10 Mar 2025 17:59:35 +0100
Message-ID: <20250310170550.691397047@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit cf6a8b1b24d675afc35a01cccd081160014a0125 ]

iova is already stored in ibmr->iova, no need to store it here.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Stable-dep-of: 235f23840219 ("RDMA/mlx5: Fix indirect mkey ODP page count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c            |  1 -
 drivers/infiniband/hw/mlx5/mr.c              | 16 ++++++++--------
 drivers/infiniband/hw/mlx5/odp.c             |  8 ++++----
 drivers/net/ethernet/mellanox/mlx5/core/mr.c |  1 -
 drivers/vdpa/mlx5/core/resources.c           |  1 -
 include/linux/mlx5/driver.h                  |  1 -
 6 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index ef3585af40263..55e2873351240 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -1317,7 +1317,6 @@ static int devx_handle_mkey_indirect(struct devx_obj *obj,
 	mkey->key = mlx5_idx_to_mkey(
 			MLX5_GET(create_mkey_out, out, mkey_index)) | key;
 	mkey->type = MLX5_MKEY_INDIRECT_DEVX;
-	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
 	devx_mr->ndescs = MLX5_GET(mkc, mkc, translations_octword_size);
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 191078b6e9129..768aba0987cce 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -916,12 +916,13 @@ static struct mlx5_cache_ent *mr_cache_ent_from_order(struct mlx5_ib_dev *dev,
 }
 
 static void set_mr_fields(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
-			  u64 length, int access_flags)
+			  u64 length, int access_flags, u64 iova)
 {
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
 	mr->ibmr.length = length;
 	mr->ibmr.device = &dev->ib_dev;
+	mr->ibmr.iova = iova;
 	mr->access_flags = access_flags;
 }
 
@@ -979,11 +980,10 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 
 	mr->ibmr.pd = pd;
 	mr->umem = umem;
-	mr->mmkey.iova = iova;
 	mr->mmkey.size = umem->length;
 	mr->mmkey.pd = to_mpd(pd)->pdn;
 	mr->page_shift = order_base_2(page_size);
-	set_mr_fields(dev, mr, umem->length, access_flags);
+	set_mr_fields(dev, mr, umem->length, access_flags, iova);
 
 	return mr;
 }
@@ -1093,7 +1093,7 @@ static void *mlx5_ib_create_xlt_wr(struct mlx5_ib_mr *mr,
 	wr->pd = mr->ibmr.pd;
 	wr->mkey = mr->mmkey.key;
 	wr->length = mr->mmkey.size;
-	wr->virt_addr = mr->mmkey.iova;
+	wr->virt_addr = mr->ibmr.iova;
 	wr->access_flags = mr->access_flags;
 	wr->page_shift = mr->page_shift;
 	wr->xlt_size = sg->length;
@@ -1345,7 +1345,7 @@ static struct mlx5_ib_mr *reg_create(struct ib_pd *pd, struct ib_umem *umem,
 	}
 	mr->mmkey.type = MLX5_MKEY_MR;
 	mr->umem = umem;
-	set_mr_fields(dev, mr, umem->length, access_flags);
+	set_mr_fields(dev, mr, umem->length, access_flags, iova);
 	kvfree(in);
 
 	mlx5_ib_dbg(dev, "mkey = 0x%x\n", mr->mmkey.key);
@@ -1392,7 +1392,7 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 
 	kfree(in);
 
-	set_mr_fields(dev, mr, length, acc);
+	set_mr_fields(dev, mr, length, acc, start_addr);
 
 	return &mr->ibmr;
 
@@ -1769,7 +1769,7 @@ static int umr_rereg_pas(struct mlx5_ib_mr *mr, struct ib_pd *pd,
 	}
 
 	mr->ibmr.length = new_umem->length;
-	mr->mmkey.iova = iova;
+	mr->ibmr.iova = iova;
 	mr->mmkey.size = new_umem->length;
 	mr->page_shift = order_base_2(page_size);
 	mr->umem = new_umem;
@@ -1840,7 +1840,7 @@ struct ib_mr *mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		mr->umem = NULL;
 		atomic_sub(ib_umem_num_pages(umem), &dev->mdev->priv.reg_pages);
 
-		return create_real_mr(new_pd, umem, mr->mmkey.iova,
+		return create_real_mr(new_pd, umem, mr->ibmr.iova,
 				      new_access_flags);
 	}
 
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 66e53e895d341..6ff65aaafcaa4 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -430,7 +430,7 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	mr->umem = &odp->umem;
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
-	mr->mmkey.iova = idx * MLX5_IMR_MTT_SIZE;
+	mr->ibmr.iova = idx * MLX5_IMR_MTT_SIZE;
 	mr->parent = imr;
 	odp->private = mr;
 
@@ -500,7 +500,7 @@ struct mlx5_ib_mr *mlx5_ib_alloc_implicit_mr(struct mlx5_ib_pd *pd,
 	}
 
 	imr->ibmr.pd = &pd->ibpd;
-	imr->mmkey.iova = 0;
+	imr->ibmr.iova = 0;
 	imr->umem = &umem_odp->umem;
 	imr->ibmr.lkey = imr->mmkey.key;
 	imr->ibmr.rkey = imr->mmkey.key;
@@ -736,7 +736,7 @@ static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
 
-	if (unlikely(io_virt < mr->mmkey.iova))
+	if (unlikely(io_virt < mr->ibmr.iova))
 		return -EFAULT;
 
 	if (mr->umem->is_dmabuf)
@@ -745,7 +745,7 @@ static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
 	if (!odp->is_implicit_odp) {
 		u64 user_va;
 
-		if (check_add_overflow(io_virt - mr->mmkey.iova,
+		if (check_add_overflow(io_virt - mr->ibmr.iova,
 				       (u64)odp->umem.address, &user_va))
 			return -EFAULT;
 		if (unlikely(user_va >= ib_umem_end(odp) ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
index 174f71ed52800..d239d559994fa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
@@ -52,7 +52,6 @@ int mlx5_core_create_mkey(struct mlx5_core_dev *dev,
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
-	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->key = (u32)mlx5_mkey_variant(mkey->key) | mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
diff --git a/drivers/vdpa/mlx5/core/resources.c b/drivers/vdpa/mlx5/core/resources.c
index 15e266d0e27a5..14d4314cdc295 100644
--- a/drivers/vdpa/mlx5/core/resources.c
+++ b/drivers/vdpa/mlx5/core/resources.c
@@ -215,7 +215,6 @@ int mlx5_vdpa_create_mkey(struct mlx5_vdpa_dev *mvdev, struct mlx5_core_mkey *mk
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	mkey_index = MLX5_GET(create_mkey_out, lout, mkey_index);
-	mkey->iova = MLX5_GET64(mkc, mkc, start_addr);
 	mkey->size = MLX5_GET64(mkc, mkc, len);
 	mkey->key |= mlx5_idx_to_mkey(mkey_index);
 	mkey->pd = MLX5_GET(mkc, mkc, pd);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 62d60a515b038..8f0c321674a88 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -364,7 +364,6 @@ enum {
 };
 
 struct mlx5_core_mkey {
-	u64			iova;
 	u64			size;
 	u32			key;
 	u32			pd;
-- 
2.39.5



