Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73075334685;
	Fri, 27 Mar 2026 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625148; cv=fail; b=m0VJ++BmYpT67w7M2uRCBRGYiH50pwL3wzFxTnxsSuu+r/UjaGBjzN8xtvz2+mZzXnuCJNUE5rdInfsc7/cLbrh71fKcQLS6FWDIM0VsQEOV3pBwinFKjYYTeEkPbMOUO/ULfL7rcDr8xdGMaeVCSkUMTCx4F/Z9njAj6YwPJYg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625148; c=relaxed/simple;
	bh=UCkQJZFnaoSMiiUSB1vkt1bNtO+Z2oJaBAcANSPv4EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WMCEjnEtJQIdwP20vkGUWujuc8V+t6lgqvOjVOdy6Dg6tLmpxgp2X5PFlxd2hdupAggVIkaM6Zf/SGOhr3/c4EcPE3xBXcXi1/e+5AKHrX1mzcarNCn+cv3YTSe4hNqQfBDdnR47YqUbXgIEmehV1cqPMWuRttg50gOyq5JHz/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DzDF+vmG; arc=fail smtp.client-ip=40.107.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DzDF+vmG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l1XRJkc6siVTfoZFY0zNVzFYM3/lvuotO/hUUu1vEVflHRqUma+x/6vKcccQwX/OnK/MP9o3DImlevuO2Dw94ZGnd5a18hj6Wi8ePFljd0r5NJDDQ0JzTulXElcMrBUDZPmSayWRuME96Bon0HOQmocYR/kG0Wnb8zE1PtNihoI+4UBt09PdqyMMTXydo1ldcGADnzjQnkpz9iZ/zIG8VnQYuHdUI5b28LifYi+Ja6Le6y0xMMlN0K1hQRkXtUef+bEJ4GkTIiPiUmNxqaSOeKm2GW3ULjxZ/yZ0Y5OnQzunAESP7SKq75rSmf63wlwCps+Kcloe6P/dW8V4fsvYCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MO/USKMf+utS3IYjZZJ3NALBVFhbtomoyvvh+55zKKM=;
 b=HyVzQeTESuHdKQFSlf70svWG/wrqJXtlXuX0HGBeJ4hmm0beMSjTEjwpu9P3VXaYdX/Hf4bdet3rwL+wNIXNdMu0zghKqW14dHDf/KBOG/SzXDr3zE06hJG3eX5NDOD1cniii/IGwNSqj/ml/0vzgbIAJ/Sazv3/ITis6YvRMKM9fNbQYHT0C3N68Tqki1OH3NyiGDgQdCVaAoKGranelKbhZxJ2dDmGQg76gsT0nfsQHmFDb5PuVzDIM3NhBfhVHxZYXErdy0H5WFVTITOmpDTy0kjkuKzf4sSK8Lri1H/LQ3zc3WxPpfYPHjxkGlUiSu9V6XHqhMRw5yxDO75B1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MO/USKMf+utS3IYjZZJ3NALBVFhbtomoyvvh+55zKKM=;
 b=DzDF+vmGWI0g2OJah2J4A6CyuSXr6yteEA+EDyNgbfdCiA2soFVFrJJaOyQf9L2gMBlgloo0EmTpnwsu8okzVO1e1aS8T8Lc2xPQdr6ccf+Z9CSsOCWH2gVrmQW0tRMgIDXn0o9fVYCJ9p2NvpYuG3VbvpyIl3WoLA7tIn5nx0F6N6PRLxQmn/YYzP3aMkx9izePoeqQu1juwmibwUmhVFdLAEB5jKy+5Go4R09Q46Odt/wA//fH07F1x41r5CvpqWAxT9qsZ2Q1vZzMDea/PAcEBkYg9xWkZ8qWzrAbIvuymzyA/Y1lO43V+t+EPC84KS3cEqo6MPh9w6WlW+5Tww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:25:39 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:25:39 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 4/4] iommu/vt: Simplify calculate_psi_aligned_address()
Date: Fri, 27 Mar 2026 12:25:37 -0300
Message-ID: <4-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0014.namprd13.prod.outlook.com
 (2603:10b6:208:256::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 7aedabf5-62b9-44b9-246b-08de8c151976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	5Lh4m0s7NVFWoVm9j52pUbyBqgnZUt+ShSs7VQxYDrD9QYa4pyN9MWBB/uaNedoJ8TLbWMkzDRgITjcTLfRojNvZlShkv/bnRceT6s8n9WsOLG5ezkuhM8aIOM/8c0u6BEWN9V3JnopVB1Xf77CKRHn6SyI7bBBEuG88BJVzuVYLwIgJBQtqQp1bj9/aDh/YadwVXxc11fgyJEckGkAMO+GL889TMraJ3Enk6vfym3R0A19d43akRTljaFSNWTOVmvc2v7coLj6pVFjm6D2rr3Z8uyAFsJ9cPZzFl5zIyx6jjPglRtnoREwG29qmsvpoTOAn0Ru55bCP70e2FNbgLi97pduw5IMNRRfvnXn8NKA9QOmKWB76PgYN1SPfHtDAdm0oBFhWXAj3thAzhN6WiZY8N6+Ahv8UarIQVxhLIRR5jMF1E1BOd3+9uLdwShajTXyll7tajtQS0QtfGlitZk5e/dHhcoovPr5iesHu9BhFIfDqGh5FaSSbO3RUJquFDPQFOxa+Uakst20hpRfWqW43P0BBJVS1ctMk+ECxMrmYcWyoTBQ6LOIcCu2QQ5ehQRcvw6ZyPJZzoD74JlYFpu2CCoJRFx2KmnE/C3l+xRRT0BrtnPuhUrB6EjKa9PTbRfvbFUgSYHzw12VOg9bM+VcbiI5GtitnB25DL1GxmmUFToQ0vFdpOhrgAmsiRhS2iB+2oBoRHkOwDqulJOMh+70rUxBn5pSyrU82CdAfT50=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cy+LMpNCSS5nIWDsPQTDOZHRELyF+nZ4+T/nQDvbZn8FIlSxRmede4NW/QkJ?=
 =?us-ascii?Q?lBvOE5K6PY+2EAS6xHiKcm/qQilWB0B2pQEwpTOExLJyIaEReBBz6HrPDLZk?=
 =?us-ascii?Q?WgoSzLKOt1Ge7u9Z8YOCAyQr/aXQ8EisXvNZFUMJVw31kLDOekosyKvi7F1K?=
 =?us-ascii?Q?SwUiHELMsAs8OU/R5cMZx4QGGEFuVa2PaKDPgUbdGYAKqFpH32K5z+Ii/1ml?=
 =?us-ascii?Q?5UmsgxYagymNBxgyJj8rfXCpuWaiNaiqRKpPL1saDkap9eUXchx+5d5EnDss?=
 =?us-ascii?Q?E1u3LvmcuFb0pgQc/SSpLHCtettaE2rKq/34aLyBicLMAf7Y45OkH+mxBcoB?=
 =?us-ascii?Q?YrytxqpIyXjKCZWZO1CDkqlgVq4yJSblt7USv/rrKBc8/0itdgoreejLFUXt?=
 =?us-ascii?Q?KaHdO5okb6dHtX8F6dysAuvl+Hnrf8qHxqNnjXw5Y/kvbF4dNJeVwFra69Z6?=
 =?us-ascii?Q?DYmUXSTKPeuFDlo6M5i/ubuImQFUodCmS0ts+CxUQb7bs9R7Jbthy1Ql4l0s?=
 =?us-ascii?Q?sIhgvBb3PM9CzHD49dN5HNcbcoqKrZ2BvowVqv8PhzDIbzK0ZAA8YUUW1D6W?=
 =?us-ascii?Q?uNYfEwQwaRDrKlyg8nQU0G9ngYBqvN+Mdn7ZEvm8Ry7pkIug+lYKKpmPh7t3?=
 =?us-ascii?Q?PhjIlvMPc/8CHg6NPwMvTVRwxz6QkIDVmGKUBbSc842Wxd1D7djLScJy4OzU?=
 =?us-ascii?Q?5lIBsdHbtHjlDt1vnUICarnOhIvpml03rLgAunnnbZ6PZKclAJwH1jeI8FW5?=
 =?us-ascii?Q?VlqKg8ddcYPG9dtBZC6yRhyuN34OM2T1hstV25psqYqjUIV4Ta93j1Flr4Gh?=
 =?us-ascii?Q?QiawaC8GJyFKn28Vwaj2cD2u63QbOKUDehBqtz7DTWlHTE1Er9TYGnxCwgup?=
 =?us-ascii?Q?ww7GMuZe1te3kXpxIURWSqTXXvlmgsQyJsWnx17P9Be4f4dYLxYnbZnreoM3?=
 =?us-ascii?Q?mCXIM/md0pbj3Eo2WWognsH1wR0dVVc9Sbz7vPGjhKhlMFp7Q9nwz1uhe/Ad?=
 =?us-ascii?Q?VBZjsHGjGNf82iI/V5Mjmn84Z5Thdge/UHclL3UCUrlBFsJRiQavTGh54/oq?=
 =?us-ascii?Q?oGOAitGwZxnRKFCez1NvIrBotiHsAoAviXwEHFjA8RgB5LLk5U+x7aVnxZKB?=
 =?us-ascii?Q?1U4HO486122POQ+iskdkEoaLoLsG0eBZwk1NRoaK9B6BBLYyyWGhkXfq4QS/?=
 =?us-ascii?Q?EirxTNQol+Cai1NTLrxI2DeNbJ0ZIyFEddMBqluzXecm2YxnUpuy8J4hF0I3?=
 =?us-ascii?Q?dJYwl0ZpPX+6rWM7aHnm8BHospM2+eSZ7ZZhlg4IChnugN23xjzJRB8zWq76?=
 =?us-ascii?Q?EIN9Hw8DFCflPSwBkC79wWuT6X1WrSyPND9Cwue6sOwb/mvrmVD4bydTvkjw?=
 =?us-ascii?Q?qox1WveSny8xtIjqMzrqspWeaUBq6dUQjWBv+Mp0wHVlgFpy0Naxz/xlLqn+?=
 =?us-ascii?Q?t1tWtyJgXHh2I0s87HjicJkulW5QMuBDn8ZPbqghZhvVNOTEoXDGTQUz3lUl?=
 =?us-ascii?Q?xxp8sRWv/+nrQoAxzNSN6gwOXSatc92RhqfEN0VzoJ5W2j5rf4MAwTpyqHBw?=
 =?us-ascii?Q?JO0X3irnwzKiYmqLV0GpKwhPYCgiX+n1G2POE2J1WqIosb/wV/wWBWAaka9y?=
 =?us-ascii?Q?GQl0hOU9oLgmKYOOL3jkiQsOq/0nPyZ9Cena26AQ+dUEV1ClhIYRJu/XMFxn?=
 =?us-ascii?Q?jLxmmtMZKEiiOkvxV9b6p9DQU7f+HN0pqmkOGH+Ap/Gy1odU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7aedabf5-62b9-44b9-246b-08de8c151976
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:25:38.4727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0v/J56bUJc0aShSFKfclhO2ppsZSDNEJfj1RlKhfHgxrwJmMuH/1Yf5TDoSZmEsL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

This is doing far too much math for the simple task of finding a
power of 2 that fully spans the given range. Use fls directly on
the xor which computes the common binary prefix.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c | 49 ++++++++++++-------------------------
 1 file changed, 16 insertions(+), 33 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 31d4bfba1842bf..10402a0f0ed7da 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -254,37 +254,25 @@ void cache_tag_unassign_domain(struct dmar_domain *domain,
 }
 
 static unsigned long calculate_psi_aligned_address(unsigned long start,
-						   unsigned long end,
-						   unsigned long *_mask)
+						   unsigned long last,
+						   unsigned long *size_order)
 {
-	unsigned long pages = aligned_nrpages(start, end - start + 1);
-	unsigned long aligned_pages = __roundup_pow_of_two(pages);
-	unsigned long bitmask = aligned_pages - 1;
-	unsigned long mask = ilog2(aligned_pages);
-	unsigned long pfn = IOVA_PFN(start);
+	unsigned int sz_lg2;
 
-	/*
-	 * PSI masks the low order bits of the base address. If the
-	 * address isn't aligned to the mask, then compute a mask value
-	 * needed to ensure the target range is flushed.
-	 */
-	if (unlikely(bitmask & pfn)) {
-		unsigned long end_pfn = pfn + pages - 1, shared_bits;
-
-		/*
-		 * Since end_pfn <= pfn + bitmask, the only way bits
-		 * higher than bitmask can differ in pfn and end_pfn is
-		 * by carrying. This means after masking out bitmask,
-		 * high bits starting with the first set bit in
-		 * shared_bits are all equal in both pfn and end_pfn.
-		 */
-		shared_bits = ~(pfn ^ end_pfn) & ~bitmask;
-		mask = shared_bits ? __ffs(shared_bits) : MAX_AGAW_PFN_WIDTH;
+	/* Compute a sz_lg2 that spans start and last */
+	start &= GENMASK(BITS_PER_LONG - 1, VTD_PAGE_SHIFT);
+	sz_lg2 = fls_long(start ^ last);
+	if (sz_lg2 <= 12) {
+		*size_order = 0;
+		return start;
+	}
+	if (unlikely(sz_lg2 >= MAX_AGAW_PFN_WIDTH)) {
+		*size_order = MAX_AGAW_PFN_WIDTH;
+		return 0;
 	}
 
-	*_mask = mask;
-
-	return ALIGN_DOWN(start, VTD_PAGE_SIZE << mask);
+	*size_order = sz_lg2 - VTD_PAGE_SHIFT;
+	return start & GENMASK(BITS_PER_LONG - 1, sz_lg2);
 }
 
 static void qi_batch_flush_descs(struct intel_iommu *iommu, struct qi_batch *batch)
@@ -441,12 +429,7 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 	struct cache_tag *tag;
 	unsigned long flags;
 
-	if (start == 0 && end == ULONG_MAX) {
-		addr = 0;
-		mask = MAX_AGAW_PFN_WIDTH;
-	} else {
-		addr = calculate_psi_aligned_address(start, end, &mask);
-	}
+	addr = calculate_psi_aligned_address(start, end, &mask);
 
 	spin_lock_irqsave(&domain->cache_lock, flags);
 	list_for_each_entry(tag, &domain->cache_tags, node) {
-- 
2.43.0

