Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6FDE330B2D;
	Fri, 27 Mar 2026 15:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625150; cv=fail; b=jr9Yh64uLfPZ8AHAmUbIWBmw01w1Ybwpfv3YjFwUFuArfmVj8yje2+PWIs3Xs5NJYsCbCTRYk8XFTK0MV3D6SN0yEfnqfhiEssa1GQ/wbvaddJYAnP6iQJ8SgCmJjyVGz6P8t5F5ZJ/1HC+DKpDpa7mG/WQPsSYTPOfSLLSayPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625150; c=relaxed/simple;
	bh=Mr6nFPsLToEs5uWHXJCCq6NzfbUshno3oZl8x6+2M/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DugKZZH693aRwsY/MZesM3U1Jh8MgVHk+MmFgq4dFu0/PeDXCUbfJcOi5Ps65IQ2ytiNJJdLV7xY0YhGeOsiToPhsEFr3dpBVsBzUj3AMjqzUyvkQoroT6LoHVvTfjTRR1d0NZas4iZ29DjU4hxTAcHj63UiSDXC0SkP2U9Hq28=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=utbhtHP6; arc=fail smtp.client-ip=40.107.201.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="utbhtHP6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MAjlmL65ttvbi36A6LTyGIq+LZabWwFIec7ekpybDJIy35Ni3Vsji+WlbMe2EZWt6MNSuP2rDXbGHKznUoYIeBK4c7VCeBHWA5b/k76b//6v87/U81jyCxiyTLijCLZ+KKQGalRVKHXsLlejoO/4rwLtiKFZOf67IXslTYz9row6mecjM7v6DIS21qZvyndkl9CHbaovUssrn0uY+G4eCjY+SgClj4nhWYz2JoNl9YTOyMm/qhopHw4iWGUlC8dwCMBs4TYtYRFmHRmFckwEr0Cm5JxAvL/9s76j8HGGdgTasL2BKwHFDitg1YD2jCpbCfs3UTtwk0g08KqGiflVdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aq40Iesc0XNfjsopooSjiyb6DaCdtzMx73XGY08XWBo=;
 b=SkNA0YBrnDo9zCBmAyZ9P641eJCaijJDIemDQa2eepKgWDrP6CdBv2KA9Qjb2f4jJby4yt+CUFV/SBCpgwR3BK5YCW+cM/ejsv0oOsqgRyQzsZ31t5HO81SgexSRH70Ruebzi32Fy1z1fR8FCwOv7rEJSZeML06xOme7ldtGGga/3cKOxU68JDXmkc5eRr1eRSkkoJIEA6+ZVJTZwDEvbo3nz4Ub9LPwGkEJqs3o5nVxuGXfckqANt5SJfU0YGszYpDpuNTh6YY9qzAknsasLKrOg4Dk4i5nT3XUcC2Km7KtrgETN7gaj5qN5LoZz6RQvsJZTiw06tE00w7r18S6lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aq40Iesc0XNfjsopooSjiyb6DaCdtzMx73XGY08XWBo=;
 b=utbhtHP6oDxuqF2tP8zacVLXr8JxW23q0NcEdHr+nO4cOUJoKFgd9yUvngU12IKWdLOanjHj47GXHIKr7IbT2O7KHp9OHppxzfc5fSdfI3ZdW7CAoueBjA2iq1/i0glpCqJqandELuIROT5nL8VotSYJfSCx5J7NFYPP8vtoO9/46YjbgBa3H3eI5faC3w8K9Br99pFp42rE5S+IYmt4I5rNa0GkwpKtVGNMB7kFq0w8viQHpJDX/B5TicwjGO9vr7DAHUJFU2TbptsiEDu4j3CsJ2yDr5v1kti0/CdEEc1jkggTPihu2p1fbprUebRbDiG+BVd6sRjac0WlS4J0bA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:25:40 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:25:40 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 3/4] iommu/vtd: Remove the remaining pages along the invalidation path
Date: Fri, 27 Mar 2026 12:25:36 -0300
Message-ID: <3-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-f175e27af136+11647-iommupt_inv_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0013.namprd13.prod.outlook.com
 (2603:10b6:208:256::18) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: 2db455b5-aa15-4b69-3bb3-08de8c151991
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	i75lePnt1mdCq/veS3IIQKUWtiPoygznQNKpLbjPBjjE41kDmETII66I2jNBYbJ9Rct/PQ2NXXQHh2UAobCYMaYImoXbxiRBShujmshQ6xzNQWJ7YYcxbP3v78fqBNn+1LJXaX2b+CbQqCQfdY5vU/G4e5mLMWXQbblKXjbqEe4UtEmokqjz25wjLqZcx20Q1ikx3B03vgJM5CzRQx6f3ObYdEkh1I7ll/Pj1GpvA4Et4JVVLoO5G+wb1imDasyQ4m+h12zblVPU1dsYr8AulbdlM47vt0VF+lQ3Xsu+nkOzTPqhDl3tii8ixA4NX6ErQVo0HGyusipJ0nhGHNVBGRFS6aSkuBLasKIl7ZkFWnrVcer6yWTNPvjFFZYHGBqgEUrhjjJo8RGyXbYx5ZZjPHTwCySGf3fz9W8OTuzfE5bgiA0malxrH2dZEmLIs8hxv1RmI27RkgBYHUZIK6rRw5/P9x/1LcWSRWmG8bRUVZZgMJQP4NIweqXPvOl6wCo9X95Bw5FiLr4rS+pQo4hACiBJz14X6h+nEUG8OTpfeKtIy9iDBZxezGnvo6QvvOiMVbs6nFLNawuEzjZ1pPfKlO4iE4uySZJjrwB6kxoaM0KLYPNRlHFj4zZpq140fSY2opKvHW9VFnNMOuti/lY6XksmvSVXjg/4qo0xq+y9oYzHl6v9AFr32hYW8mmpGUL4cyPoWSKEL6fAH49zGSgA6T6Td2EMQHB0FZyIJe8Nc9M=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?guFJ6B78hJ1xs9tpbvAULDTvv1kNpk5/skkmFiHsA+YBOjcvramPwzPIMhPE?=
 =?us-ascii?Q?kqYkNyK9hxICyPODZAwS0AiCgWbyvVnEFbt6cxXw6jp2xQ/Ik2r9cTdpUq13?=
 =?us-ascii?Q?TzxBXUU9FApdBm8eCOsgWOlfd+f2e7jQYHBNN36ot+CRJJjy6T684nVKYg4A?=
 =?us-ascii?Q?69Z57YpYsjcY/sooM62Ia+xOUUKYqt3magH+zCm5kxzzqdBocLobwRyCmZKB?=
 =?us-ascii?Q?ABjB7IGxTyFLIOd9mjkBcHdijgf27J6DRIq/Te94L0qZSjaS0hj+CU7GwmOJ?=
 =?us-ascii?Q?pnr6fzByrOSxrLH9/0MKRMHhxthlHNv5uSQ/yExV22gtb21wYpxz9S6yB6F7?=
 =?us-ascii?Q?3OZsNvdmDt0fQsiL1WRZtqGJ+gl4bcWF0nF0Dw6QCAuzxP01CRsY2mFDhwEx?=
 =?us-ascii?Q?VILXc15iFEvU3cypYvRYkNB/hcbfx9ndrbgGoqNQFQHq7HVDVVSPE4d/V7GR?=
 =?us-ascii?Q?H1ytfQ2dGxOijiVy4K6x8+nWtBwl/jBq/582SyRLxO2kai/zof/Y3it50IFq?=
 =?us-ascii?Q?EYM1mM0f295rlT/wWZc+sXcvBPrUZFy82N+nHEwDDjR/MRvLxrlBqDpWn8lm?=
 =?us-ascii?Q?18DrOpLl22GA0PjIU+Eh2ZUNvt4I+yxoWuF3HmfX9DzEBU/QE3Qvtraqgc0Y?=
 =?us-ascii?Q?JkCG/BMO1aK/kJIpUskQTuwSi+zCi+DfJKmPt7ILcQCJFbQhOf/dWysIAVso?=
 =?us-ascii?Q?xfyeN0cj5sFq4wMRQyvLxmwvt61awJuXb31J7OxuA+qe9zmwNzztiJ+QjLnx?=
 =?us-ascii?Q?bEh3hbga9Fn4lYi7j13g/vEEUTbgYYmNkNPqWh2M53gNzHMiikEJ65Bz6Oq/?=
 =?us-ascii?Q?Q/fjmW3V03xjuq1g0T82iX0+N0GIHVCpGWLGa2SEi/lonIiN4Qz+B+0AnoDo?=
 =?us-ascii?Q?eKUhgxpedbIimx+nLiLlJB6GB5Ws6T42HLFUuN7sRrSyYsIz2oiuEzoxISID?=
 =?us-ascii?Q?J/ALwYMgpW6qWBV7u4YJONkFNqNoQrVHYYJvGrLUo14K0Lmnm1oztBMsEANW?=
 =?us-ascii?Q?rRpvEjHilurfVs+xOUOHPD86DLU9GPlCxUsmX2fydZ+AS+THt0ge8jFn1QRZ?=
 =?us-ascii?Q?rT1doN/89qb0vXQ2FN/ZC0RKFNBv2CLsy8kaeDRv5oRWIKXAYfMYny55tOj2?=
 =?us-ascii?Q?lKuVOD0w+S8pIMCmZ7ze5uUplBL7Ja7bnEfQfmJGs6x9YTFLt93OY5WLNPFE?=
 =?us-ascii?Q?0nlL/6dc/p+UgaGOvkwKKmTnt7wbccxj3upcL10St4UXvCs2qAfZf8iZ4fUF?=
 =?us-ascii?Q?BKUTrr5iO5xa7gEDvN76sCvcZuA4nm5fDAChYEOULERWnAvpwILsjsxur7fw?=
 =?us-ascii?Q?IJyZ9wN/uLctAkOwU5joAB7s8vEgd7+nGhmLPwLK1ueU4foO1xqpMET378B1?=
 =?us-ascii?Q?Crsr6fkhyig5qS0ruGZ3XawjAcZJR2Mop9QcDgJpEC1pPrGU+QuKPcWp9B/t?=
 =?us-ascii?Q?QbQcwUMtKxCdEcWF+VrDwsoBL0IXqgNPhVnF8MmqA68/MVSpOF0tXKvA4K2F?=
 =?us-ascii?Q?Tffi2gWEIbWITI8Ts3CSc30oftVgd40oxS2ByUqVtfELGwdy1ScWQFtf//Zt?=
 =?us-ascii?Q?ykagzT0fHHvRDC36da+OrpMEHSw6FTB5aY2Vs2Ghzm36cxOmUVZJxU3jRP/r?=
 =?us-ascii?Q?mAOoVE5Gs5TU4bAmKYtpbwy0QZADI9m9qjAdps32YUdugfexNaRgutPUIoZC?=
 =?us-ascii?Q?3x+zCgn4rD9787dcznkHTr2A5gI+qe+MjE0Fl+SDfm3NBRuC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db455b5-aa15-4b69-3bb3-08de8c151991
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:25:38.6241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66Hl9zNlAD3u68AamCM+3/dWEzZmy+3jHRHKuWyI44xBZOg5zbEPHBcIQb3YQNgA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

This was only being used to signal that a flush all should be used.
Use mask/size_order >= 52 to signal this instead.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c | 27 +++++++++++----------------
 drivers/iommu/intel/trace.h | 18 ++++++++----------
 2 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index 74ee2002fb9c85..31d4bfba1842bf 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -255,7 +255,6 @@ void cache_tag_unassign_domain(struct dmar_domain *domain,
 
 static unsigned long calculate_psi_aligned_address(unsigned long start,
 						   unsigned long end,
-						   unsigned long *_pages,
 						   unsigned long *_mask)
 {
 	unsigned long pages = aligned_nrpages(start, end - start + 1);
@@ -281,10 +280,8 @@ static unsigned long calculate_psi_aligned_address(unsigned long start,
 		 */
 		shared_bits = ~(pfn ^ end_pfn) & ~bitmask;
 		mask = shared_bits ? __ffs(shared_bits) : MAX_AGAW_PFN_WIDTH;
-		aligned_pages = 1UL << mask;
 	}
 
-	*_pages = aligned_pages;
 	*_mask = mask;
 
 	return ALIGN_DOWN(start, VTD_PAGE_SIZE << mask);
@@ -371,14 +368,13 @@ static bool intel_domain_use_piotlb(struct dmar_domain *domain)
 }
 
 static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *tag,
-				  unsigned long addr, unsigned long pages,
-				  unsigned long mask, int ih)
+				  unsigned long addr, unsigned long mask, int ih)
 {
 	struct intel_iommu *iommu = tag->iommu;
 	u64 type = DMA_TLB_PSI_FLUSH;
 
 	if (intel_domain_use_piotlb(domain)) {
-		if (pages == -1)
+		if (mask >= MAX_AGAW_PFN_WIDTH)
 			qi_batch_add_piotlb_all(iommu, tag->domain_id,
 						tag->pasid, domain->qi_batch);
 		else
@@ -392,7 +388,7 @@ static void cache_tag_flush_iotlb(struct dmar_domain *domain, struct cache_tag *
 	 * is too big.
 	 */
 	if (!cap_pgsel_inv(iommu->cap) ||
-	    mask > cap_max_amask_val(iommu->cap) || pages == -1) {
+	    mask > cap_max_amask_val(iommu->cap)) {
 		addr = 0;
 		mask = 0;
 		ih = 0;
@@ -441,16 +437,15 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 			   unsigned long end, int ih)
 {
 	struct intel_iommu *iommu = NULL;
-	unsigned long pages, mask, addr;
+	unsigned long mask, addr;
 	struct cache_tag *tag;
 	unsigned long flags;
 
 	if (start == 0 && end == ULONG_MAX) {
 		addr = 0;
-		pages = -1;
 		mask = MAX_AGAW_PFN_WIDTH;
 	} else {
-		addr = calculate_psi_aligned_address(start, end, &pages, &mask);
+		addr = calculate_psi_aligned_address(start, end, &mask);
 	}
 
 	spin_lock_irqsave(&domain->cache_lock, flags);
@@ -462,7 +457,7 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 		switch (tag->type) {
 		case CACHE_TAG_IOTLB:
 		case CACHE_TAG_NESTING_IOTLB:
-			cache_tag_flush_iotlb(domain, tag, addr, pages, mask, ih);
+			cache_tag_flush_iotlb(domain, tag, addr, mask, ih);
 			break;
 		case CACHE_TAG_NESTING_DEVTLB:
 			/*
@@ -480,7 +475,7 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
 			break;
 		}
 
-		trace_cache_tag_flush_range(tag, start, end, addr, pages, mask);
+		trace_cache_tag_flush_range(tag, start, end, addr, mask);
 	}
 	qi_batch_flush_descs(iommu, domain->qi_batch);
 	spin_unlock_irqrestore(&domain->cache_lock, flags);
@@ -510,11 +505,11 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 			      unsigned long end)
 {
 	struct intel_iommu *iommu = NULL;
-	unsigned long pages, mask, addr;
+	unsigned long mask, addr;
 	struct cache_tag *tag;
 	unsigned long flags;
 
-	addr = calculate_psi_aligned_address(start, end, &pages, &mask);
+	addr = calculate_psi_aligned_address(start, end, &mask);
 
 	spin_lock_irqsave(&domain->cache_lock, flags);
 	list_for_each_entry(tag, &domain->cache_tags, node) {
@@ -530,9 +525,9 @@ void cache_tag_flush_range_np(struct dmar_domain *domain, unsigned long start,
 
 		if (tag->type == CACHE_TAG_IOTLB ||
 		    tag->type == CACHE_TAG_NESTING_IOTLB)
-			cache_tag_flush_iotlb(domain, tag, addr, pages, mask, 0);
+			cache_tag_flush_iotlb(domain, tag, addr, mask, 0);
 
-		trace_cache_tag_flush_range_np(tag, start, end, addr, pages, mask);
+		trace_cache_tag_flush_range_np(tag, start, end, addr, mask);
 	}
 	qi_batch_flush_descs(iommu, domain->qi_batch);
 	spin_unlock_irqrestore(&domain->cache_lock, flags);
diff --git a/drivers/iommu/intel/trace.h b/drivers/iommu/intel/trace.h
index 6311ba3f1691dd..9f0ab43539ea06 100644
--- a/drivers/iommu/intel/trace.h
+++ b/drivers/iommu/intel/trace.h
@@ -132,8 +132,8 @@ DEFINE_EVENT(cache_tag_log, cache_tag_unassign,
 
 DECLARE_EVENT_CLASS(cache_tag_flush,
 	TP_PROTO(struct cache_tag *tag, unsigned long start, unsigned long end,
-		 unsigned long addr, unsigned long pages, unsigned long mask),
-	TP_ARGS(tag, start, end, addr, pages, mask),
+		 unsigned long addr, unsigned long mask),
+	TP_ARGS(tag, start, end, addr, mask),
 	TP_STRUCT__entry(
 		__string(iommu, tag->iommu->name)
 		__string(dev, dev_name(tag->dev))
@@ -143,7 +143,6 @@ DECLARE_EVENT_CLASS(cache_tag_flush,
 		__field(unsigned long, start)
 		__field(unsigned long, end)
 		__field(unsigned long, addr)
-		__field(unsigned long, pages)
 		__field(unsigned long, mask)
 	),
 	TP_fast_assign(
@@ -155,10 +154,9 @@ DECLARE_EVENT_CLASS(cache_tag_flush,
 		__entry->start = start;
 		__entry->end = end;
 		__entry->addr = addr;
-		__entry->pages = pages;
 		__entry->mask = mask;
 	),
-	TP_printk("%s %s[%d] type %s did %d [0x%lx-0x%lx] addr 0x%lx pages 0x%lx mask 0x%lx",
+	TP_printk("%s %s[%d] type %s did %d [0x%lx-0x%lx] addr 0x%lx mask 0x%lx",
 		  __get_str(iommu), __get_str(dev), __entry->pasid,
 		  __print_symbolic(__entry->type,
 			{ CACHE_TAG_IOTLB,		"iotlb" },
@@ -166,20 +164,20 @@ DECLARE_EVENT_CLASS(cache_tag_flush,
 			{ CACHE_TAG_NESTING_IOTLB,	"nesting_iotlb" },
 			{ CACHE_TAG_NESTING_DEVTLB,	"nesting_devtlb" }),
 		__entry->domain_id, __entry->start, __entry->end,
-		__entry->addr, __entry->pages, __entry->mask
+		__entry->addr, __entry->mask
 	)
 );
 
 DEFINE_EVENT(cache_tag_flush, cache_tag_flush_range,
 	TP_PROTO(struct cache_tag *tag, unsigned long start, unsigned long end,
-		 unsigned long addr, unsigned long pages, unsigned long mask),
-	TP_ARGS(tag, start, end, addr, pages, mask)
+		 unsigned long addr, unsigned long mask),
+	TP_ARGS(tag, start, end, addr, mask)
 );
 
 DEFINE_EVENT(cache_tag_flush, cache_tag_flush_range_np,
 	TP_PROTO(struct cache_tag *tag, unsigned long start, unsigned long end,
-		 unsigned long addr, unsigned long pages, unsigned long mask),
-	TP_ARGS(tag, start, end, addr, pages, mask)
+		 unsigned long addr, unsigned long mask),
+	TP_ARGS(tag, start, end, addr, mask)
 );
 #endif /* _TRACE_INTEL_IOMMU_H */
 
-- 
2.43.0

