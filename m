Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8411DA3D;
	Tue,  3 Dec 2024 15:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238914; cv=none; b=ErWFPksaxV08mrZVZJ54Gcn4IFUD8yczn0yM82VcH3JlzpZTBW/Pd4bT35K2tidzMRpiCgTmQLs2R/4LLzHv9TJsjL5SRY25lP1bz/7zxD30Ey3bT7yif16WZ3SSJRfxp4i77qhtAb+cPMeB4ALVyRaqCdYq7ufkGTtoTC6EtEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238914; c=relaxed/simple;
	bh=RQaJoVTR2Xi4HYn7vAMGzQQsBkmzcpfnSmQiJ7W0eWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGbSDdTBTjPHcfCuyBDrvYguKVGAc0DWVDHtDPeCVlJZ+IXiahCH91y1g89Wf00lbqLx+yL5twgBHN+0op4GDyQ2qpePRFM/vJshC4fB9wheb5vQb7NqVKS1Vj6n5yE+A5kpVS1cTdOTXeegeTmFIxO6CeaGhHgtbdYswNfAfdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkR7f+E2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkR7f+E2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3203DC4CECF;
	Tue,  3 Dec 2024 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238914;
	bh=RQaJoVTR2Xi4HYn7vAMGzQQsBkmzcpfnSmQiJ7W0eWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkR7f+E2+sw+3v9KdrkflADu2Y9jbDd/NR4HiLvK6Qpio4sbi/KHwWdlulKUK1Flf
	 fr3qiiEIlxHLSjSH38cixiOZc8hC3e9A8b0gho7Ns2nM7sdnsP1zIsCBXHC97uW3G8
	 h4YqGCZB9N4OvdoZzIxjJWb025e7QW2mPpXlR6SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 409/817] iommu/amd: Rename struct amd_io_pgtable iopt to pgtbl
Date: Tue,  3 Dec 2024 15:39:41 +0100
Message-ID: <20241203144011.845786734@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 670b57796c5dc1ca58912132cad914cf4b3c0cdd ]

There is struct protection_domain iopt and struct amd_io_pgtable iopt.
Next patches are going to want to write domain.iopt.iopt.xx which is quite
unnatural to read.

Give one of them a different name, amd_io_pgtable has fewer references so
call it pgtbl, to match pgtbl_cfg, instead.

Suggested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/6-v2-831cdc4d00f3+1a315-amd_iopgtbl_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 016991606aa0 ("iommu/amd/pgtbl_v2: Take protection domain lock before invalidating TLB")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h |  4 ++--
 drivers/iommu/amd/io_pgtable.c      | 12 ++++++------
 drivers/iommu/amd/io_pgtable_v2.c   | 14 +++++++-------
 drivers/iommu/amd/iommu.c           | 14 +++++++-------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 2b76b5dedc1d9..90a2e4790bffd 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -527,7 +527,7 @@ struct amd_irte_ops;
 #define AMD_IOMMU_FLAG_TRANS_PRE_ENABLED      (1 << 0)
 
 #define io_pgtable_to_data(x) \
-	container_of((x), struct amd_io_pgtable, iop)
+	container_of((x), struct amd_io_pgtable, pgtbl)
 
 #define io_pgtable_ops_to_data(x) \
 	io_pgtable_to_data(io_pgtable_ops_to_pgtable(x))
@@ -548,7 +548,7 @@ struct gcr3_tbl_info {
 
 struct amd_io_pgtable {
 	struct io_pgtable_cfg	pgtbl_cfg;
-	struct io_pgtable	iop;
+	struct io_pgtable	pgtbl;
 	int			mode;
 	u64			*root;
 	u64			*pgd;		/* v2 pgtable pgd pointer */
diff --git a/drivers/iommu/amd/io_pgtable.c b/drivers/iommu/amd/io_pgtable.c
index 5278ba3f676c4..dab1cf53b1f3f 100644
--- a/drivers/iommu/amd/io_pgtable.c
+++ b/drivers/iommu/amd/io_pgtable.c
@@ -542,7 +542,7 @@ static int iommu_v1_read_and_clear_dirty(struct io_pgtable_ops *ops,
  */
 static void v1_free_pgtable(struct io_pgtable *iop)
 {
-	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
+	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
 	LIST_HEAD(freelist);
 
 	if (pgtable->mode == PAGE_MODE_NONE)
@@ -570,12 +570,12 @@ static struct io_pgtable *v1_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	cfg->oas            = IOMMU_OUT_ADDR_BIT_SIZE;
 	cfg->tlb            = &v1_flush_ops;
 
-	pgtable->iop.ops.map_pages    = iommu_v1_map_pages;
-	pgtable->iop.ops.unmap_pages  = iommu_v1_unmap_pages;
-	pgtable->iop.ops.iova_to_phys = iommu_v1_iova_to_phys;
-	pgtable->iop.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
+	pgtable->pgtbl.ops.map_pages    = iommu_v1_map_pages;
+	pgtable->pgtbl.ops.unmap_pages  = iommu_v1_unmap_pages;
+	pgtable->pgtbl.ops.iova_to_phys = iommu_v1_iova_to_phys;
+	pgtable->pgtbl.ops.read_and_clear_dirty = iommu_v1_read_and_clear_dirty;
 
-	return &pgtable->iop;
+	return &pgtable->pgtbl;
 }
 
 struct io_pgtable_init_fns io_pgtable_amd_iommu_v1_init_fns = {
diff --git a/drivers/iommu/amd/io_pgtable_v2.c b/drivers/iommu/amd/io_pgtable_v2.c
index f9227cbf75dfe..de60f6f4cb2f9 100644
--- a/drivers/iommu/amd/io_pgtable_v2.c
+++ b/drivers/iommu/amd/io_pgtable_v2.c
@@ -234,7 +234,7 @@ static int iommu_v2_map_pages(struct io_pgtable_ops *ops, unsigned long iova,
 			      int prot, gfp_t gfp, size_t *mapped)
 {
 	struct protection_domain *pdom = io_pgtable_ops_to_domain(ops);
-	struct io_pgtable_cfg *cfg = &pdom->iop.iop.cfg;
+	struct io_pgtable_cfg *cfg = &pdom->iop.pgtbl.cfg;
 	u64 *pte;
 	unsigned long map_size;
 	unsigned long mapped_size = 0;
@@ -281,7 +281,7 @@ static unsigned long iommu_v2_unmap_pages(struct io_pgtable_ops *ops,
 					  struct iommu_iotlb_gather *gather)
 {
 	struct amd_io_pgtable *pgtable = io_pgtable_ops_to_data(ops);
-	struct io_pgtable_cfg *cfg = &pgtable->iop.cfg;
+	struct io_pgtable_cfg *cfg = &pgtable->pgtbl.cfg;
 	unsigned long unmap_size;
 	unsigned long unmapped = 0;
 	size_t size = pgcount << __ffs(pgsize);
@@ -346,7 +346,7 @@ static const struct iommu_flush_ops v2_flush_ops = {
 
 static void v2_free_pgtable(struct io_pgtable *iop)
 {
-	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, iop);
+	struct amd_io_pgtable *pgtable = container_of(iop, struct amd_io_pgtable, pgtbl);
 
 	if (!pgtable || !pgtable->pgd)
 		return;
@@ -369,16 +369,16 @@ static struct io_pgtable *v2_alloc_pgtable(struct io_pgtable_cfg *cfg, void *coo
 	if (get_pgtable_level() == PAGE_MODE_5_LEVEL)
 		ias = 57;
 
-	pgtable->iop.ops.map_pages    = iommu_v2_map_pages;
-	pgtable->iop.ops.unmap_pages  = iommu_v2_unmap_pages;
-	pgtable->iop.ops.iova_to_phys = iommu_v2_iova_to_phys;
+	pgtable->pgtbl.ops.map_pages    = iommu_v2_map_pages;
+	pgtable->pgtbl.ops.unmap_pages  = iommu_v2_unmap_pages;
+	pgtable->pgtbl.ops.iova_to_phys = iommu_v2_iova_to_phys;
 
 	cfg->pgsize_bitmap = AMD_IOMMU_PGSIZES_V2,
 	cfg->ias           = ias,
 	cfg->oas           = IOMMU_OUT_ADDR_BIT_SIZE,
 	cfg->tlb           = &v2_flush_ops;
 
-	return &pgtable->iop;
+	return &pgtable->pgtbl;
 }
 
 struct io_pgtable_init_fns io_pgtable_amd_iommu_v2_init_fns = {
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 881f6c589257c..b63f0d1bb3251 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2265,7 +2265,7 @@ void protection_domain_free(struct protection_domain *domain)
 	WARN_ON(!list_empty(&domain->dev_list));
 
 	if (domain->iop.pgtbl_cfg.tlb)
-		free_io_pgtable_ops(&domain->iop.iop.ops);
+		free_io_pgtable_ops(&domain->iop.pgtbl.ops);
 
 	if (domain->id)
 		domain_id_free(domain->id);
@@ -2373,7 +2373,7 @@ static struct iommu_domain *do_iommu_domain_alloc(unsigned int type,
 	domain->domain.geometry.aperture_start = 0;
 	domain->domain.geometry.aperture_end   = dma_max_address();
 	domain->domain.geometry.force_aperture = true;
-	domain->domain.pgsize_bitmap = domain->iop.iop.cfg.pgsize_bitmap;
+	domain->domain.pgsize_bitmap = domain->iop.pgtbl.cfg.pgsize_bitmap;
 
 	if (iommu) {
 		domain->domain.type = type;
@@ -2494,7 +2494,7 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 				    unsigned long iova, size_t size)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 
 	if (ops->map_pages)
 		domain_flush_np_cache(domain, iova, size);
@@ -2506,7 +2506,7 @@ static int amd_iommu_map_pages(struct iommu_domain *dom, unsigned long iova,
 			       int iommu_prot, gfp_t gfp, size_t *mapped)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 	int prot = 0;
 	int ret = -EINVAL;
 
@@ -2553,7 +2553,7 @@ static size_t amd_iommu_unmap_pages(struct iommu_domain *dom, unsigned long iova
 				    struct iommu_iotlb_gather *gather)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 	size_t r;
 
 	if ((domain->pd_mode == PD_MODE_V1) &&
@@ -2572,7 +2572,7 @@ static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  dma_addr_t iova)
 {
 	struct protection_domain *domain = to_pdomain(dom);
-	struct io_pgtable_ops *ops = &domain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &domain->iop.pgtbl.ops;
 
 	return ops->iova_to_phys(ops, iova);
 }
@@ -2650,7 +2650,7 @@ static int amd_iommu_read_and_clear_dirty(struct iommu_domain *domain,
 					  struct iommu_dirty_bitmap *dirty)
 {
 	struct protection_domain *pdomain = to_pdomain(domain);
-	struct io_pgtable_ops *ops = &pdomain->iop.iop.ops;
+	struct io_pgtable_ops *ops = &pdomain->iop.pgtbl.ops;
 	unsigned long lflags;
 
 	if (!ops || !ops->read_and_clear_dirty)
-- 
2.43.0



