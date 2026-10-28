Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214119;
	b=J6Ph9w7QscCzUGyTnujVfhw8qEZZWPf2qotp+mQ0NVtKZTco47hIB6zlmHPMTUu7Xr/L
	 OjsNHFTS0j1k4l2WNTILmS0Ze4yrSmjA5OK4J7mmHEL6d0yLx1CQXEOVbsr4qXBA/Sf8n
	 JDNlFEKJq6Xavkpkpd3FSlDyh098vITFMBak49zZMeyu4m7v8h9SoX7VpD61UWu/wj8fR
	 Kd8HPZGI8cyLonmH1xsaaRVWbYR8slx16Dxw2INnjPrsMOjwjhUv+PuQd10FS7NUQPngR
	 OSx1FHUa+nEy1H7cddPFDxhiVK6sAgVIy9HbTuBJslSa1NkMIM41+RIM7guNCFLbpMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EHlT1J398PSlYzNyPTKhs6Jk97aYvdAlYbd876WZwPY=;
	b=cx34WpTOVesvlA/hlUFTHgIkEWbKWGt10qXCuyY9QpmSEBoPCzh0zmrJETirNg1C8NAD
	 wvnI38L2hJE6A852AZYIPbr5H+Bqu4kbHEJfplQSRGLrDoGW5b7fIfUlQbH4eH+VshIcl
	 DjPHWubgk5Dnw5xo0/EEhkaHjmCAninC2NorNFg5gviXHE59dSl0SDJdAAXJ3O7r79o1X
	 7N1f7OOcNN7+nm2BmICngXXEcuElM9wHXLK9LOIHOaCCWxFfndTcIn7e4x5ljJi/JRa4W
	 6BE0wOx0q+lg6ZWdK2MrlLfjFWPwrlauZWqnWfGh+9w0wa4j9zKX0eSKRrgof9lmSlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ty5UfBUn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E365606A32E;
	Wed, 28 Oct 2026 19:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ty5UfBUn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDF71F01828;
	Wed, 28 Oct 2026 19:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214119;
	bh=EHlT1J398PSlYzNyPTKhs6Jk97aYvdAlYbd876WZwPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ty5UfBUnulnm7i2rI8b0fbsncyPczJGRzOGMDVvJYGClw9qN+phc7ovk/bljuj3KB
	 AxkAxzOPuDN90vl8OUJTfyUkKX9HBm5uIaA+4JsDDJEqy0F96ywvH7QHTNXU4qLyrr
	 E4ZmKMBwY/WEvsd7lZDfE376CRSjwEBanV8dcS3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aharon Landau <aharonl@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0745/1887] RDMA/mlx5: Dont keep umrable page_shift in cache entries
Date: Wed, 28 Oct 2026 17:47:21 +0100
Message-ID: <20261028170516.401229491@linuxfoundation.org>
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

[ Upstream commit a2a88b8e22d1b202225d0e40b02ad068afab2ccb ]

mkc.log_page_size can be changed using UMR. Therefore, don't treat it as a
cache entry property.

Removing it from struct mlx5_cache_ent.

All cache mkeys will be created with default PAGE_SHIFT, and updated with
the needed page_shift using UMR when passing them to a user.

Link: https://lore.kernel.org/r/20230125222807.6921-2-michaelgur@nvidia.com
Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 -
 drivers/infiniband/hw/mlx5/mr.c      | 3 +--
 drivers/infiniband/hw/mlx5/odp.c     | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e8e285233b355..3f805e935943c 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -759,7 +759,6 @@ struct mlx5_cache_ent {
 	char                    name[4];
 	u32                     order;
 	u32			access_mode;
-	u32			page;
 	unsigned int		ndescs;
 
 	u8 disabled:1;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 6dfd425e28c1a..58f2d645404e6 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -297,7 +297,7 @@ static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_mkc_octo_size(ent->access_mode, ent->ndescs));
-	MLX5_SET(mkc, mkc, log_page_size, ent->page);
+	MLX5_SET(mkc, mkc, log_page_size, PAGE_SHIFT);
 }
 
 /* Asynchronously schedule new MRs to be populated in the cache. */
@@ -765,7 +765,6 @@ int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 		if (ent->order > mkey_cache_max_order(dev))
 			continue;
 
-		ent->page = PAGE_SHIFT;
 		ent->ndescs = 1 << ent->order;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		if ((dev->mdev->profile.mask & MLX5_PROF_MASK_MR_CACHE) &&
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index aa24d395a2dc8..6eb86a475ce91 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1616,14 +1616,12 @@ void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 
 	switch (ent->order - 2) {
 	case MLX5_IMR_MTT_CACHE_ENTRY:
-		ent->page = PAGE_SHIFT;
 		ent->ndescs = MLX5_IMR_MTT_ENTRIES;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
 		ent->limit = 0;
 		break;
 
 	case MLX5_IMR_KSM_CACHE_ENTRY:
-		ent->page = MLX5_KSM_PAGE_SHIFT;
 		ent->ndescs = mlx5_imr_ksm_entries;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_KSM;
 		ent->limit = 0;
-- 
2.53.0



