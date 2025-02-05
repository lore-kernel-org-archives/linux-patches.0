Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C721FECA4;
	Wed,  5 Feb 2025 14:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767008; cv=none; b=UATzRb0d6u1A5bfy/ztIGr+nqVk1PrGR7v+QKexar/Kk7YWPOo7lrV5tZcLe+Lndgx/OUlAZ7GIP7Eeol6appu5JU4tATQVX967dZUEJAJJfNTdQC+c25h6Yqp2iezG4KSV2CPMjUzwfXD2OdUO2pPAoL3fprGhu6TXyhNKhvH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767008; c=relaxed/simple;
	bh=5gvcdQ+7BlYOmfN65pyw5l5zr1T2ERyuFByKdTa48Jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/QUHe//4BsmP8QKJaLX86+D+VILHVgO7imt3ibY3IlWTZDAVaZJQ7SOLd+ynMYY6EDLBv88eszuTb0MXhI6S5yzhjWYFUztosf0efQo2XxAONfBzVXB4ESmOgfzD8k6wAh2x46spFlNRUJzkJwt3zPpwS22mV78eddRZhEPutw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kk1bxx6J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kk1bxx6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0A7C4CED1;
	Wed,  5 Feb 2025 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767007;
	bh=5gvcdQ+7BlYOmfN65pyw5l5zr1T2ERyuFByKdTa48Jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kk1bxx6JGnJx5wK3cdf1/MYEoZEQZiYqS8vc8Gwb8crm/AfnTjRrfZX/UlNX4l+gV
	 hQv78bql40RxXw8DpBYs3gOXS7ul0HI0AQT4wAhAtSeFoCIzNg5jQ/k0TIFlC9OWDi
	 AUALANl4ylvYXUYMoROkV8+zGxEL0bdZOqeXrgXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasant Hegde <vasant.hegde@amd.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 318/623] iommu/amd: Change amd_iommu_pgtable to use enum protection_domain_mode
Date: Wed,  5 Feb 2025 14:41:00 +0100
Message-ID: <20250205134508.387323977@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 13b4ec749163710e3d188d2fed7405308b1b1e73 ]

Currently it uses enum io_pgtable_fmt which is from the io pagetable code
and most of the enum values are invalid. protection_domain_mode is
internal the driver and has the only two valid values.

Fix some signatures and variables to use the right type as well.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/5-v2-9776c53c2966+1c7-amd_paging_flags_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Stable-dep-of: 082f1bcae8d1 ("iommu/amd: Fully decode all combinations of alloc_paging_flags")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/init.c      | 14 +++++++-------
 drivers/iommu/amd/iommu.c     | 34 +++++++++++++++++-----------------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 1d384b2c6e28e..6eb0af2e03390 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -41,7 +41,7 @@ void amd_iommu_disable(void);
 int amd_iommu_reenable(int mode);
 int amd_iommu_enable_faulting(unsigned int cpu);
 extern int amd_iommu_guest_ir;
-extern enum io_pgtable_fmt amd_iommu_pgtable;
+extern enum protection_domain_mode amd_iommu_pgtable;
 extern int amd_iommu_gpt_level;
 extern unsigned long amd_iommu_pgsize_bitmap;
 
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 0e0a531042acb..db4b52aae1fcf 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -152,7 +152,7 @@ struct ivmd_header {
 bool amd_iommu_dump;
 bool amd_iommu_irq_remap __read_mostly;
 
-enum io_pgtable_fmt amd_iommu_pgtable = AMD_IOMMU_V1;
+enum protection_domain_mode amd_iommu_pgtable = PD_MODE_V1;
 /* Guest page table level */
 int amd_iommu_gpt_level = PAGE_MODE_4_LEVEL;
 
@@ -2145,7 +2145,7 @@ static void print_iommu_info(void)
 		if (amd_iommu_xt_mode == IRQ_REMAP_X2APIC_MODE)
 			pr_info("X2APIC enabled\n");
 	}
-	if (amd_iommu_pgtable == AMD_IOMMU_V2) {
+	if (amd_iommu_pgtable == PD_MODE_V2) {
 		pr_info("V2 page table enabled (Paging mode : %d level)\n",
 			amd_iommu_gpt_level);
 	}
@@ -3059,10 +3059,10 @@ static int __init early_amd_iommu_init(void)
 	    FIELD_GET(FEATURE_GATS, amd_iommu_efr) == GUEST_PGTABLE_5_LEVEL)
 		amd_iommu_gpt_level = PAGE_MODE_5_LEVEL;
 
-	if (amd_iommu_pgtable == AMD_IOMMU_V2) {
+	if (amd_iommu_pgtable == PD_MODE_V2) {
 		if (!amd_iommu_v2_pgtbl_supported()) {
 			pr_warn("Cannot enable v2 page table for DMA-API. Fallback to v1.\n");
-			amd_iommu_pgtable = AMD_IOMMU_V1;
+			amd_iommu_pgtable = PD_MODE_V1;
 		}
 	}
 
@@ -3185,7 +3185,7 @@ static void iommu_snp_enable(void)
 		goto disable_snp;
 	}
 
-	if (amd_iommu_pgtable != AMD_IOMMU_V1) {
+	if (amd_iommu_pgtable != PD_MODE_V1) {
 		pr_warn("SNP: IOMMU is configured with V2 page table mode, SNP cannot be supported.\n");
 		goto disable_snp;
 	}
@@ -3464,9 +3464,9 @@ static int __init parse_amd_iommu_options(char *str)
 		} else if (strncmp(str, "force_isolation", 15) == 0) {
 			amd_iommu_force_isolation = true;
 		} else if (strncmp(str, "pgtbl_v1", 8) == 0) {
-			amd_iommu_pgtable = AMD_IOMMU_V1;
+			amd_iommu_pgtable = PD_MODE_V1;
 		} else if (strncmp(str, "pgtbl_v2", 8) == 0) {
-			amd_iommu_pgtable = AMD_IOMMU_V2;
+			amd_iommu_pgtable = PD_MODE_V2;
 		} else if (strncmp(str, "irtcachedis", 11) == 0) {
 			amd_iommu_irtcachedis = true;
 		} else if (strncmp(str, "nohugepages", 11) == 0) {
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 081a5dbe7ba7b..e0c12dc44340c 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2297,32 +2297,30 @@ struct protection_domain *protection_domain_alloc(int nid)
 	return domain;
 }
 
-static int pdom_setup_pgtable(struct protection_domain *domain, int pgtable)
+static int pdom_setup_pgtable(struct protection_domain *domain)
 {
 	struct io_pgtable_ops *pgtbl_ops;
+	enum io_pgtable_fmt fmt;
 
-	switch (pgtable) {
-	case AMD_IOMMU_V1:
-		domain->pd_mode = PD_MODE_V1;
+	switch (domain->pd_mode) {
+	case PD_MODE_V1:
+		fmt = AMD_IOMMU_V1;
 		break;
-	case AMD_IOMMU_V2:
-		domain->pd_mode = PD_MODE_V2;
+	case PD_MODE_V2:
+		fmt = AMD_IOMMU_V2;
 		break;
-	default:
-		return -EINVAL;
 	}
 
-	pgtbl_ops =
-		alloc_io_pgtable_ops(pgtable, &domain->iop.pgtbl.cfg, domain);
+	pgtbl_ops = alloc_io_pgtable_ops(fmt, &domain->iop.pgtbl.cfg, domain);
 	if (!pgtbl_ops)
 		return -ENOMEM;
 
 	return 0;
 }
 
-static inline u64 dma_max_address(int pgtable)
+static inline u64 dma_max_address(enum protection_domain_mode pgtable)
 {
-	if (pgtable == AMD_IOMMU_V1)
+	if (pgtable == PD_MODE_V1)
 		return ~0ULL;
 
 	/* V2 with 4/5 level page table */
@@ -2334,8 +2332,9 @@ static bool amd_iommu_hd_support(struct amd_iommu *iommu)
 	return iommu && (iommu->features & FEATURE_HDSUP);
 }
 
-static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
-						  int pgtable)
+static struct iommu_domain *
+do_iommu_domain_alloc(struct device *dev, u32 flags,
+		      enum protection_domain_mode pgtable)
 {
 	bool dirty_tracking = flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
@@ -2346,7 +2345,8 @@ static struct iommu_domain *do_iommu_domain_alloc(struct device *dev, u32 flags,
 	if (!domain)
 		return ERR_PTR(-ENOMEM);
 
-	ret = pdom_setup_pgtable(domain, pgtable);
+	domain->pd_mode = pgtable;
+	ret = pdom_setup_pgtable(domain);
 	if (ret) {
 		pdom_id_free(domain->id);
 		kfree(domain);
@@ -2384,13 +2384,13 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
 		if (!amd_iommu_pasid_supported())
 			return ERR_PTR(-EOPNOTSUPP);
 
-		return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V2);
+		return do_iommu_domain_alloc(dev, flags, PD_MODE_V2);
 	}
 
 	/* Allocate domain with v1 page table for dirty tracking */
 	if (flags & IOMMU_HWPT_ALLOC_DIRTY_TRACKING) {
 		if (amd_iommu_hd_support(iommu))
-			return do_iommu_domain_alloc(dev, flags, AMD_IOMMU_V1);
+			return do_iommu_domain_alloc(dev, flags, PD_MODE_V1);
 
 		return ERR_PTR(-EOPNOTSUPP);
 	}
-- 
2.39.5



