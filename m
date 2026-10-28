Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214122;
	b=P+J4egCgjugT3ST9c86BBz/eFae42M3whReS98dAfS18sE3l8ziIAIF1DkYkFUu8LxOK
	 wZLWUVj0M6L5daT7SCFltd8TzKJv4KMS/mISQfT4whZH3E6rcpeUsKHjSrC8FTlmlTJnC
	 uoVEl1wIfPckqns8oYVHC7K643nAG0P807iGxjNLWEESRs4hOmlVoNJFy8Ei63YlMe+7D
	 8Pmie4lRwTVNj1lxsaNdB692fyZ++Q5sji6fnlu4mWaYbOVHiCDKoDgNqJl/FSGJPLHkM
	 Z4xkl0dqiLNx8jx2kXBvTpKm/8sT8jRpVeDVhSp07bs/vUxwRNH+Nvoo7wXLMJsyi7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1TAGXT1+cqnwqoQLNIpXzRDNXD217cX3R/c6QiyC4I=;
	b=gx6eD0VQ9TPeXblgZkX7ytY8J6DkpvF0DvsPT2u/qZFpuUbXo58XGNP+D408J+FYSZR9
	 HUnzMvxrm75d+6yWhzZigQAX5338pRVEWsuctxJ8LriycVm1QT/MeoVnvQqw6jzA6Xh/f
	 DiVbRSsUvO9HrkcSizd06Ru2/ATMyV8Nterdi46IbzNAzOls8iVFgPyq2ZfzYzGP8BaPT
	 iE6tjxyIvR+04qM42Xmn51jtIxgpxTbEbLdxe6TAB77QrlCyM1wrqIMVDV87LlVlA0xsj
	 y4GdaPjc5cYIb5xzteIIkLZ1gAxmD/jMbUDKNy9vSWfAiQpXXIKxIagnMmUipj4cLPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JA251R32;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24035606A31A;
	Wed, 28 Oct 2026 19:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JA251R32
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409401F01828;
	Wed, 28 Oct 2026 19:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214121;
	bh=V1TAGXT1+cqnwqoQLNIpXzRDNXD217cX3R/c6QiyC4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JA251R32QP0Q/rVXR4ydDMJimL2MHALcz9hfKtstNHPFbIvd+wuocLT7DLml2o4Da
	 p0xVt5AOnVk0qng3Y4k0KYphmwPwAzzjvu+riN824UfApqELVq+UB1PpEtkbKrHsj5
	 sWr3PKwPFsw9OiFDmuyroQPziN9mWVTpoEDqxg3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0746/1887] RDMA/mlx5: Remove implicit ODP cache entry
Date: Wed, 28 Oct 2026 17:47:22 +0100
Message-ID: <20261028170516.422697004@linuxfoundation.org>
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

From: Aharon Landau <aharonl@nvidia.com>

[ Upstream commit 18b1746bddf5e7f6b2618966596d9517172a5cd7 ]

Implicit ODP mkey doesn't have unique properties. It shares the same
properties as the order 18 cache entry. There is no need to devote a
special entry for that.

Link: https://lore.kernel.org/r/20230125222807.6921-3-michaelgur@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 20 +++++---------------
 include/linux/mlx5/driver.h      |  1 -
 2 files changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 6eb86a475ce91..27bde04ebc1df 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -424,6 +424,7 @@ static void mlx5_ib_page_fault_resume(struct mlx5_ib_dev *dev,
 static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 						unsigned long idx)
 {
+	int order = order_base_2(MLX5_IMR_MTT_ENTRIES);
 	struct mlx5_ib_dev *dev = mr_to_mdev(imr);
 	struct ib_umem_odp *odp;
 	struct mlx5_ib_mr *mr;
@@ -436,7 +437,8 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	if (IS_ERR(odp))
 		return ERR_CAST(odp);
 
-	mr = mlx5_mr_cache_alloc(dev, &dev->cache.ent[MLX5_IMR_MTT_CACHE_ENTRY],
+	BUILD_BUG_ON(order > MKEY_CACHE_LAST_STD_ENTRY);
+	mr = mlx5_mr_cache_alloc(dev, &dev->cache.ent[order],
 				 imr->access_flags);
 	if (IS_ERR(mr)) {
 		ib_umem_odp_release(odp);
@@ -1613,20 +1615,8 @@ void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 {
 	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return;
-
-	switch (ent->order - 2) {
-	case MLX5_IMR_MTT_CACHE_ENTRY:
-		ent->ndescs = MLX5_IMR_MTT_ENTRIES;
-		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
-		ent->limit = 0;
-		break;
-
-	case MLX5_IMR_KSM_CACHE_ENTRY:
-		ent->ndescs = mlx5_imr_ksm_entries;
-		ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
-		ent->limit = 0;
-		break;
-	}
+	ent->ndescs = mlx5_imr_ksm_entries;
+	ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
 }
 
 static const struct ib_device_ops mlx5_ib_dev_odp_ops = {
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0e8705c3a460d..6948767d52522 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -747,7 +747,6 @@ enum {
 
 enum {
 	MKEY_CACHE_LAST_STD_ENTRY = 20,
-	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
 	MAX_MKEY_CACHE_ENTRIES
 };
-- 
2.53.0



