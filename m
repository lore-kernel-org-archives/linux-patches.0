Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2055.outbound.protection.outlook.com [40.107.93.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CAE514E2F9;
	Wed, 27 Mar 2024 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711562927; cv=fail; b=aa2TDmYaJA49X1l5BwfSIR29tNV7xcuPpvo0SAYe4F8Cqdxnlq/1as090f3YpkM1HnFp53d0xtnTjs0NRY7qNAHHXLCt9WnAEhjjHxnusRqMhxNYRFqrDNhUFUROg3yEqeQOyDcf3QoomydAcBikg4KQZbHRarRvsYbVAmrnI64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711562927; c=relaxed/simple;
	bh=o0E8mEFD4xKNW05qQAiTSiDJDmaGYSZ6suJOIj1yIeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OPgCZ0DmWKZKddw6HMAXDeisljXyvCtV7OpPkvkgBicZl/w5YNmCX/lKCyAokORwkI878PXuO/W1fSAwPcaTqvSFgq1Qg1B7PpHiD+im6+ZRLEbEYQjXxoVFNsU9z5Pz6/WDhNo1W5egIV4OZrktvShVn9Q+XlL8kH5QV2Lxtdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lg/qj9K0; arc=fail smtp.client-ip=40.107.93.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lg/qj9K0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TJcTqXlJ6hYoR+BKpirzqlgopBlDFW9Ld7sE9kV0nGAq07gw1eZhG/mTHn7ahUNn34tmFRZ49WeSoYuQHouoSjxkmqv+O4kjeUas0jkvjXB0o09HVUCUvAJ23TP6ahisyuSLEti7VwNmk5DERs7ZGfqfADXLGPz2Bk3WE12xKE9RzafKvOKY998HoGrcNdV/0nnKzkhmombI78GCi+iLjjvk3AcEDJDuYIzMDfPc+EJYIFaYDUiX6D5QNFspESkpVhdYjD9h+8i2OwvZmwHXVDI1Lx602W5KafcsYS/ZgUnHy/lJHxGJD3UAE39SyZQcFcqLuOARVf/424b8YAtogw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XTP6lyihEdsKvKw2lgOnHuzKPKxDE+Enop2SXZ/QG1c=;
 b=ZTduprZY2L1AtxULnLKsj8BWgcWqqxZTrpwaU2fAL8pXe1r30x174WYTupqQJF+Pu5wIcd+KbV12Fbyz7nBmvPzBLiWhXzmSIPkaJ+ucfWMfQ7ps/rSyVEf/hGrTiTZCQVtNHAyfn8k0SkFuJVfs58PZLC6G+qSLg++XSkLvnV6+YTD3ErWHe3Md4RyKNU9L5Xrr8vruU9gdZzHiYpxf/WSjFSVdlBiJtq1FgMdrJ9Bv8TOKimb2gWtck0WmtPbDYF60VKFqqfeJPtt/k0LYjBY+MWJDxnTwFd0qSD9PAd+S6Lh/X1hk/n13OsdAit38+A5AOoVJKGbt5zLkzZ20gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XTP6lyihEdsKvKw2lgOnHuzKPKxDE+Enop2SXZ/QG1c=;
 b=lg/qj9K0v1p65dm0e3AyhyR/LNRN0jSTswGDyxkLpkMdYkmKWlfs2Nd5On6iCD6UWy+SZ98cFzvJQnnS8T0LCBCT+S2RGcJuFGC6nhimeEDiCrljIRf6R2I/vYAl3U9zsTV71rzRtex1ziBWniFO5djt18aukfJEg1TPm4DzgJqEJ3sld21eSjbVhCDKrCVKlQUE9T6aKUURxUYZKiCUa7TT8U+VlGj0VQuIAvC7TC3NVM2mRzaDpv1yvdnLgR/px3FI/1/8kMnk7alOzXXKmq+VYRKc6njBh4cVGROl9i+jLjstxK2JfoQuzkOic3yveEEmypbH7b745Vs9bM/Y7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH0PR12MB8487.namprd12.prod.outlook.com (2603:10b6:610:18c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 18:08:29 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 18:08:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Kevin Tian <kevin.tian@intel.com>,
	kernel test robot <lkp@intel.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Tony Zhu <tony.zhu@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v6 26/29] iommu/arm-smmu-v3: Bring back SVA BTM support
Date: Wed, 27 Mar 2024 15:08:12 -0300
Message-ID: <26-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:208:236::10) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: 4df2b653-3a64-43cc-80cd-08dc4e88e1a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C0DEJgV1YY1gQ0n2D7oMjFSejwi+Kh7RR8qj5N5Y0+6HLQ2CGqHdv1HRXb5y9uY8ogmhraR+xpZ8RW+bn4BzXMMWGOJi2kq1oi5fSlrMZkvTilB5XWK4ng34Yc7FLotZ552Fs6SU21NdjXFTzO7zl24Y31/Cn/e8DdIAZHnFuKtrLeA6Bm1x7ZGix3fSwBYnW7nnYuEQYKn5qySmiCmbxsVm6KGjrGcqcHgPC980EUPprQ15TR+JXyWOpDs1LsA5skO5SZGG2Bor1QXf4aeDZANEel74QtwK90bbMtpXuzHXWqvx9k8yKMUVBeQb+2I4zNUcYtiseZB4Wv/XrLEllWpJZuu5dGlq+8QgejZEJwPUQLzRe/C6b+LRk1cwvmXZXAUbeeks9iyvdYy0QP3YkaEpVFppjNs1xTcDWQsrrGlXQEV5xA9K0qcVjXXKyAJllkRMWnHtD4PYF6V5J8D9Dt7jzVi1JxwI4Ztb8zsKdlfLl/UPjhuSqGrIMe9EHDtYuwNWl0WJ2J1ffUEG0WetYnLxxw+JhQNzFp/rlrBZQCQxOnLZqcvpyOAwpXLQYw9rdcsqT3UQZexWAc9DdD7wLXNLHsaWsyQowuNXapX5bHeeYs0g69Shy1rbgcjKD2mj5xcx5RRuB4/RNwvQiPTZuQx0FsaaI/E2jB0726NrQHc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KdHUafB60ZZ5XYq07Tk1ObQMxj0EkLCmIbDNHzz2TrGrOlBFZ4XI+h0ZwGKy?=
 =?us-ascii?Q?o2m1OTqXVA3hAqvdTiyKD8sgGq6iR00zHlMx8jI6lncu8u0BVnLw0UK89dtF?=
 =?us-ascii?Q?ESg1e/23idXnTHWI49Th5+x86Z0EKWkdvIY4pey2gXs7SS1P0S3BzQLYXiqN?=
 =?us-ascii?Q?iDKBEiLUxE6yHUFw1VJe3rtDSpzjaRmatSdeYL8MnoqUZTTuoezBMz6Yxc8E?=
 =?us-ascii?Q?NHI9oh9FfeYZ2eQWnsO1DRoQlHlWqihHCPvOuSjJ7/Gf26C/r+WGpDkeBq4Q?=
 =?us-ascii?Q?pBwr3lDpG8BeKGsNh5g/UQ0vEXeqqIbQJUAKxDkWNRjXUoJzzVlcOjK52C/Y?=
 =?us-ascii?Q?PUKkneS1O8GswP+RMTcGNiK8lt66vHMru/tlmS5L7sO/ETMS5nF0V/+M5LKp?=
 =?us-ascii?Q?nG+ctrX1l50xjQeUJxDL/sulp75lHaY+Gn373Xn7IuuPp3ZkqWmr6stAyuX3?=
 =?us-ascii?Q?MPIZA57SQp3bll0x0z4Sy15OO/0hm6FrWdYL1/Lzog9/rL8fXpclIiWf+zvu?=
 =?us-ascii?Q?az9zT1o43ypYVqpjvxXGrp81tu9vigWp3jeeEGuHWmERXVCQyhjqOTjaJDc5?=
 =?us-ascii?Q?YBh7flLTFMcyO3lvVZp+dVJNtvjWZ1FEkZuI339Sw6+4YY3c+y9ZKMe631d+?=
 =?us-ascii?Q?1oh9bKAnb0D1cJQQnHQ2tNJYxqYBquz5YlAzLRTuUpGpZIgutDZ7Yo5ChenD?=
 =?us-ascii?Q?GsZYpKyrl7CJ+uQt0prTV/Rl+B4PjAOL31KzwjJNsMTT2KqGs1R85qDfTy7o?=
 =?us-ascii?Q?rYJljahvmShwrVhFfVu6JUINx5P82IKCnUr+P+9gbnBInPtomQdoV8PW22cm?=
 =?us-ascii?Q?2VYq+LrY7uLPwA5F8hG2Zo6Jd+ThUiCoYHj1M2PQGiBlKOU8svRnNxSoL46T?=
 =?us-ascii?Q?N7jFNsCr5mTrnLqCIQ/QlY+nN0J30PJ/4R7uF977m34PrC2i1pu1h4rnJZk8?=
 =?us-ascii?Q?6cPAnX01zbnQgahPrKRLlF1/SFZq4pesOFlAQrmxHYdYbXAYOKWj3KnsfDll?=
 =?us-ascii?Q?gWyNyHrxRBe85rnfZE7KdOUKL0ufobK0+mlQJNgrnHhcCH4VZAwM/jQC7R5J?=
 =?us-ascii?Q?8+H2pblqHWJ7fVolF1KOmUG+AOLNCqZBZ8oryQ3vsKb1f1yRKZjuyKm6Gs4E?=
 =?us-ascii?Q?wuVTBgP8LtIb4CZ9Uf1wchoWu9q+oYYK7Jelk54NSk4Yghe2Q4JvQZJ5keLI?=
 =?us-ascii?Q?oqIX9YHdH60z76xVjzFngU7Jgdk03E6gf7YSLCoIKMn7awuW3cs9a6LK1PJd?=
 =?us-ascii?Q?+NU5XENEkfTeZUh67fasDqLXv2I65rmCHGduKxoai9CbUShjF3w6OTDsG0Ye?=
 =?us-ascii?Q?QCauo3fcR+0pDhWcX8OdCIXrxiKAajibwKJPMwSgcyjQlpkLgEXZALoJdh6y?=
 =?us-ascii?Q?uqGkHebKAVJd25QIV1MNobDz0NYpMV6mvOGHLN0BxysbQWEpWTNhSM3CRW7C?=
 =?us-ascii?Q?0Mbauj6Vp5Vk0bamV9k8tmdr9jRStWGnHh7j0c/OsBcZeI3gLxR+52liGiUi?=
 =?us-ascii?Q?cPguOW7L7c0Rv5NhfoF3nXmL9OBIa4J3SfUpMDFMWIGqd9VFiZ/CRkfR90s6?=
 =?us-ascii?Q?p9/51tFqkpd1zwGJnN/Q8g4TBqWfDqA+kCgPjLEi?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4df2b653-3a64-43cc-80cd-08dc4e88e1a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 18:08:18.9887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /IyMa5OqYX4cW8ARdfRnZ9MOmNavtYlt/RMc1LYjpGC+6eBl4copl0F+78YagsFZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

BTM support is a feature where the CPU TLB invalidation can be forwarded
to the IOMMU and also invalidate the IOTLB. For this to work the CPU and
IOMMU ASID must be the same.

Retain the prior SVA design here of keeping the ASID allocator for the
IOMMU private to SMMU and force SVA domains to set an ASID that matches
the CPU ASID.

This requires changing the ASID assigned to a S1 domain if it happens to
be overlapping with the required CPU ASID. We hold on to the CPU ASID so
long as the SVA iommu_domain exists, so SVA domain conflict is not
possible.

With the asid per-smmu we no longer have a problem that two per-smmu
iommu_domain's would need to share a CPU ASID entry in the IOMMU's xarray.

Use the same ASID move algorithm for the S1 domains as before with some
streamlining around how the xarray is being used. Do not synchronize the
ASID's if BTM mode is not supported. Just leave BTM features off
everywhere.

Audit all the places that touch cd->asid and think carefully about how the
locking works with the change to the cd->asid by the move algorithm. Use
xarray internal locking during xa_alloc() instead of double locking. Add a
note that concurrent S1 invalidation doesn't fully work.

Note that this is all still dead code, ARM_SMMU_FEAT_BTM is never set.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 133 ++++++++++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  15 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   2 +-
 3 files changed, 129 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 95d8d2d283c916..11e295f70a89b4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -14,12 +14,33 @@
 
 static DEFINE_MUTEX(sva_lock);
 
-static void __maybe_unused
-arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
+static int arm_smmu_realloc_s1_domain_asid(struct arm_smmu_device *smmu,
+					   struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_master_domain *master_domain;
+	u32 old_asid = smmu_domain->cd.asid;
 	struct arm_smmu_cd target_cd;
 	unsigned long flags;
+	int ret;
+
+	lockdep_assert_held(&smmu->asid_lock);
+
+	/*
+	 * FIXME: The unmap and invalidation path doesn't take any locks but
+	 * this is not fully safe. Since updating the CD tables is not atomic
+	 * there is always a hole where invalidating only one ASID of two active
+	 * ASIDs during unmap will cause the IOTLB to become stale.
+	 *
+	 * This approach is to hopefully shift the racing CPUs to the new ASID
+	 * before we start programming the HW. This increases the chance that
+	 * racing IOPTE changes will pick up an invalidation for the new ASID
+	 * and we achieve eventual consistency. For the brief period where the
+	 * old ASID is still in the CD entries it will become incoherent.
+	 */
+	ret = xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid, smmu_domain,
+		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	if (ret)
+		return ret;
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
 	list_for_each_entry(master_domain, &smmu_domain->devices, devices_elm) {
@@ -35,6 +56,10 @@ arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
 					&target_cd);
 	}
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
+
+	/* Clean the ASID we are about to assign to a new translation */
+	arm_smmu_tlb_inv_asid(smmu, old_asid);
+	return 0;
 }
 
 static u64 page_size_to_cd(void)
@@ -147,12 +172,12 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 	}
 
 	if (!smmu_domain->btm_invalidation) {
+		ioasid_t asid = READ_ONCE(smmu_domain->cd.asid);
+
 		if (!size)
-			arm_smmu_tlb_inv_asid(smmu_domain->smmu,
-					      smmu_domain->cd.asid);
+			arm_smmu_tlb_inv_asid(smmu_domain->smmu, asid);
 		else
-			arm_smmu_tlb_inv_range_asid(start, size,
-						    smmu_domain->cd.asid,
+			arm_smmu_tlb_inv_range_asid(start, size, asid,
 						    PAGE_SIZE, false,
 						    smmu_domain);
 	}
@@ -181,6 +206,8 @@ static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 		cdptr = arm_smmu_get_cd_ptr(master, master_domain->ssid);
 		if (WARN_ON(!cdptr))
 			continue;
+
+		/* An SVA ASID never changes, no asid_lock required */
 		arm_smmu_make_sva_cd(&target, master, NULL,
 				     smmu_domain->cd.asid,
 				     smmu_domain->btm_invalidation);
@@ -374,6 +401,8 @@ static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 	 * unnecessary invalidation.
 	 */
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(domain->mm);
 
 	/*
 	 * Actual free is defered to the SRCU callback
@@ -387,13 +416,97 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
+static int arm_smmu_share_asid(struct arm_smmu_device *smmu,
+			       struct arm_smmu_domain *smmu_domain,
+			       struct mm_struct *mm)
+{
+	struct arm_smmu_domain *old_s1_domain;
+	int ret;
+
+	/*
+	 * Notice that BTM is never currently enabled, this is all dead code.
+	 * The specification cautions:
+	 *
+	 * Note: Arm expects that SMMU stage 2 address spaces are generally
+	 * shared with their respective PE virtual machine stage 2
+	 * configuration. If broadcast invalidation is required to be avoided
+	 * for a particular SMMU stage 2 address space, Arm recommends that a
+	 * hypervisor configures the STE with a VMID that is not allocated for
+	 * virtual machine use on the PEs
+	 *
+	 * However, in Linux, both KVM and SMMU think they own the VMID pool.
+	 * Unfortunately the ARM design is problematic for Linux as we do not
+	 * currently share the S2 table with KVM. This creates a situation where
+	 * the S2 needs to have the same VMID as KVM in order to allow the guest
+	 * to use BTM, however we must still invalidate the S2 directly since it
+	 * is a different radix tree. What Linux would like is something like
+	 * ASET for the STE to disable BTM only for the S2.
+	 *
+	 * Arguably in a system with BTM the driver should prefer to use a S1
+	 * table in all cases execpt when explicitly asked to create a nesting
+	 * parent. Then it should use the VMID of KVM to enable BTM in the
+	 * guest. We cannot optimize away the resulting double invalidation of
+	 * the S2 :( Or we simply ignore BTM entirely as we are doing now.
+	 */
+	if (!(smmu_domain->smmu->features & ARM_SMMU_FEAT_BTM))
+		return xa_alloc(&smmu->asid_map, &smmu_domain->cd.asid,
+				smmu_domain,
+				XA_LIMIT(1, (1 << smmu->asid_bits) - 1),
+				GFP_KERNEL);
+
+	/* At this point the caller ensures we have a mmget() */
+	smmu_domain->cd.asid = arm64_mm_context_get(mm);
+
+	mutex_lock(&smmu->asid_lock);
+	old_s1_domain = xa_store(&smmu->asid_map, smmu_domain->cd.asid,
+				 smmu_domain, GFP_KERNEL);
+	if (xa_err(old_s1_domain)) {
+		ret = xa_err(old_s1_domain);
+		goto out_put_asid;
+	}
+
+	/*
+	 * In BTM mode the CPU ASID and the IOMMU ASID have to be the same.
+	 * Unfortunately we run separate allocators for this and the IOMMU
+	 * ASID can already have been assigned to a S1 domain. SVA domains
+	 * always align to their CPU ASIDs. In this case we change
+	 * the S1 domain's ASID, update the CD entry and flush the caches.
+	 *
+	 * This is a bit tricky, all the places writing to a S1 CD, reading the
+	 * S1 ASID, or doing xa_erase must hold the asid_lock or xa_lock to
+	 * avoid IOTLB incoherence.
+	 */
+	if (old_s1_domain) {
+		if (WARN_ON(old_s1_domain->domain.type == IOMMU_DOMAIN_SVA)) {
+			ret = -EINVAL;
+			goto out_restore_s1;
+		}
+		ret = arm_smmu_realloc_s1_domain_asid(smmu, old_s1_domain);
+		if (ret)
+			goto out_restore_s1;
+	}
+
+	smmu_domain->btm_invalidation = true;
+
+	ret = 0;
+	goto out_unlock;
+
+out_restore_s1:
+	xa_store(&smmu->asid_map, smmu_domain->cd.asid, old_s1_domain,
+		 GFP_KERNEL);
+out_put_asid:
+	arm64_mm_context_put(mm);
+out_unlock:
+	mutex_unlock(&smmu->asid_lock);
+	return ret;
+}
+
 struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 					       struct mm_struct *mm)
 {
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
-	u32 asid;
 	int ret;
 
 	smmu_domain = arm_smmu_domain_alloc();
@@ -404,12 +517,10 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 	smmu_domain->smmu = smmu;
 
-	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
+	ret = arm_smmu_share_asid(smmu, smmu_domain, mm);
 	if (ret)
 		goto err_free;
 
-	smmu_domain->cd.asid = asid;
 	smmu_domain->mmu_notifier.ops = &arm_smmu_mmu_notifier_ops;
 	ret = mmu_notifier_register(&smmu_domain->mmu_notifier, mm);
 	if (ret)
@@ -419,6 +530,8 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 
 err_asid:
 	arm_smmu_domain_free_id(smmu_domain);
+	if (smmu_domain->btm_invalidation)
+		arm64_mm_context_put(mm);
 err_free:
 	kfree(smmu_domain);
 	return ERR_PTR(ret);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index bdcf9a7039f869..5a2c6d099008ed 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1324,6 +1324,8 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
 		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
+	lockdep_assert_held(&master->smmu->asid_lock);
+
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
@@ -2061,7 +2063,7 @@ static void arm_smmu_tlb_inv_context(struct arm_smmu_domain *smmu_domain)
 
 	if ((smmu_domain->stage == ARM_SMMU_DOMAIN_S1 ||
 	     smmu_domain->domain.type == IOMMU_DOMAIN_SVA)) {
-		arm_smmu_tlb_inv_asid(smmu, smmu_domain->cd.asid);
+		arm_smmu_tlb_inv_asid(smmu, READ_ONCE(smmu_domain->cd.asid));
 	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2) {
 		cmd.opcode = CMDQ_OP_TLBI_S12_VMALL;
 		cmd.tlbi.vmid = smmu_domain->s2_cfg.vmid;
@@ -2305,17 +2307,10 @@ static void arm_smmu_domain_free_paging(struct iommu_domain *domain)
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 				       struct arm_smmu_domain *smmu_domain)
 {
-	int ret;
-	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 
-	/* Prevent SVA from modifying the ASID until it is written to the CD */
-	mutex_lock(&smmu->asid_lock);
-	ret = xa_alloc(&smmu->asid_map, &asid, smmu_domain,
-		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	cd->asid	= (u16)asid;
-	mutex_unlock(&smmu->asid_lock);
-	return ret;
+	return xa_alloc(&smmu->asid_map, &cd->asid, smmu_domain,
+			XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 97c13f9313dcfe..12eabafbb70c9c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -586,7 +586,7 @@ struct arm_smmu_strtab_l1_desc {
 };
 
 struct arm_smmu_ctx_desc {
-	u16				asid;
+	u32				asid;
 };
 
 struct arm_smmu_l1_ctx_desc {
-- 
2.43.2

