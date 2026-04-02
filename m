Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010025.outbound.protection.outlook.com [52.101.201.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F10793D8904;
	Thu,  2 Apr 2026 22:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775170554; cv=fail; b=qgMIsRD66wOT5kc+2+2WFr09oLF26aRcdksvSOm7PjebF0/v7ebpbL8KKLtD5i3Y6n+Uv/Qt/U8cqCN1ZJlwcUh5xj2pCOpR+0xr88d1cwOra+QpX/gWfkWmlKppmyRJJnD+9TSc7XFbM7cu5ajcaltyfNnFxsdt1a8YaGVfX0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775170554; c=relaxed/simple;
	bh=ZF2ikjLZ1nKE/myCtFJCvpLym6cSLrAVp1IAH6t5KOU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=OIfZQJenfDoIhpx+dIf2gvRnIE8EXs7x3smOZtsxU2u5ReAT1bCgaovMVIAHOz5fxzPv1QzllPDzSJ26+7JcxJhOEgIUCd96hf20kvCsKWwu/Ck1Bwz7VLI9XCkwRpFDNU1hbsBPgPT+0X2mczoiZ3T3bxKseDNxSRO0t/l3uW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HBvyXeGF; arc=fail smtp.client-ip=52.101.201.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HBvyXeGF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fdLs77QCyeX5+6yAPn7doIkNSMFixdZG3jUWo/6CZOcmp+QKnOMo8WPwEHDTrFa36lQjO7urcytzh5ijkTc74JmsxCNXnUKam2K85hZMNmUnQGki+AhB6tXmbfiZHoiYKkYN0fpnMTgMONOEd+V0ODxydyTJx0ib9KgEDmpNykFCMrxKC/H0utH4rlcf33zbkS8WCJTf1M+t6BPtc4HJVQboKHr/sajdDSAN0IJV7RPocZVbgNqVq2Dxzby13JD3Mw3dxlTzC8GnicwRZocieJswZWEp0+IM8ii9GFF7zyM9fu8Mq+g4tF4+QOyuEFWva4888k8EtF7ABqniE8pD5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcEzinxkM0wrlPPou5jGFQ0j11nV8zoaQ9uYYXcinek=;
 b=oMDsqfzH1DrG8gXGu2k8n8IF5DcKfVbMndKcuTHOlEpIgKvPUYsrYwzfljP2y2rfq3yLKovbGFTb5uUqqKsOwyItZqwoYB9v3IIIZYK5uyDju2GfXNHgeCKTFdh17aI5xaYOpVnL8CW+lLPU5qjq9c69hElPEXgrDSXVe2rRvTsFDxh4b1wiguNyZFHnRKnWKe4B3nABjoDf2Y1BHEqc297Snzxy2nm4rpP1AUFNSkmEy5P4qPX54Wt6t+vNc/LYLj+LXqY986qBtR0mrujmjcR/yyhy9gYDRCGVrPOSWwZYWsh8a/zZQkvmkMWkPa9RuLxy7CbCMtUYPCiLoUmuGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcEzinxkM0wrlPPou5jGFQ0j11nV8zoaQ9uYYXcinek=;
 b=HBvyXeGFaAAiphbvljzvYpJR1+NhXgrCGjKypYvdAAp9+OhhvT1JGWPmbO2cTJkug7xppkZ45AQvfAcPjoPyy7VS8wBFkYxcgUNuhxnE3VaM8X3nBKpqZoCf8JhTyt2FztPdaU0Y5H4GKybV19v4D5Ph8RuoGqghgS/iutbsfhnJqjr464SaBZL5nvdWj3vShkHyCy1F2XNafHJNaJkLFnYkrD3id9I6S4amAb+mT5oY62aW/w1I0mNgxC/g6OXLfTnGJ11KIltMQ/KRsuLQXV5YWT6QApaoBepNTPoAoKott/oZ4fHQI5UOgOr9ncaREzKCvcQc2XUznxHO9cNPxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN2PR12MB4341.namprd12.prod.outlook.com (2603:10b6:208:262::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Thu, 2 Apr
 2026 22:55:46 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.017; Thu, 2 Apr 2026
 22:55:46 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH v2] iommu/vt: Simplify calculate_psi_aligned_address()
Date: Thu,  2 Apr 2026 19:55:45 -0300
Message-ID: <0-v2-895748900b39+5303-iommupt_inv_vtd_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P221CA0041.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:5b5::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN2PR12MB4341:EE_
X-MS-Office365-Filtering-Correlation-Id: 87353a63-91d6-4eb9-bcdd-08de910af9ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	byK5LO8hR3SQ4PotNhQJX9INcMHP9AZ547m9dPgDEpd5qVeapTIYcyFG9j0TL6k7bbJe/owD07ShFm9U2aaj3A9o6d9P8jEAalCboqOfiuCWFygw/ufifzMvYFa0A2pR/74Xyr4Xg0x++mW/6bj3SWvQdWWpMXpD11bVvnj4r4L4t2qTY6McJzT54CGiYSUUENSdm9tPnrXiJm/ztsYoXsGlYMZMcjR/JRChGcyybP3n7pEtpUnc9NfC2r4G871g5g7y3PLVWaT5uSnYapOc/WxWSP/tBd9y/lTVCs/zBLhZQdH/IV3Hcnd4tOU42V31enW86Z2pJemeuXHpmdtBNdfHfG49XS0r+4DLMtehx+4Q4iCYBat8EypwxyTnFk4FpgbozAoNGHE/OiO+/+e41AnZt13oFSAWB2JpAWee+WN2CWGOm6E9bd2X+XUMHb4hB/sZlDbsiGyxe5S29NlDt4xZrD5BjqWwUdMXoVD8W9UHzEapKhS9UGkuRm0YENmgS95PjO/0c4Q91xoNZT+74mRhb/7FaIny3Ku4fktYCaMw2Ieh7Y9bIs2Kvtrp6mHGqoAHZqUp+Gwo+CA+w/VDRcWdHQv/IGtAwHXXzxlNlt/D1mk0rNje9xHLBssIP7FCW2oJ7az3FiOzxma+81aGRtT1rP4QzASJV17dGtTLWS/7JnUcX6Bgs3yN6CEvqdQPE5cIx3pHcKOytI9LL8wvM0K4HyMv8yXhXFTb0WpS16c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UmdbryEabzwE74WmVDkuzY6p6jA4bVYdlNbEhSJ74N+b6uCfY/2sn7Ssi4CF?=
 =?us-ascii?Q?I+uF4oVb54A/Ak/TnWxQ+HdanBPpXi0qKvZvJMnI0X9sPUIsS1kwdkyunswU?=
 =?us-ascii?Q?FH6vUGZLWLEwHL8sweHJCJdCJt2HP9hWIVenCF9s6eKPsfxqg6h5HMmf3pnB?=
 =?us-ascii?Q?r0Wb6EWFawWuKB/cBd+v1GEu4f3iJKdRnvmiTzSEuQWUJ0dBqw6oM6lTBDj8?=
 =?us-ascii?Q?jRbCLv2RCqnTr0JHABjZcTj2O/m78tWox/Wp5zzIt3w16AI0izBGY42PKXEP?=
 =?us-ascii?Q?1Ub6LK3cpVj89lM/4OQnF/kU1EXgjNTjrq9/N4ZMewGR/nvsRNzvO6viPbqP?=
 =?us-ascii?Q?0mFo1hyVnfHlwngZ2dLADL9MRMSNDa2AYFEy/0rjfFzz2bFa6eHAnOtEC7l4?=
 =?us-ascii?Q?x9XEZu0UREuihywq+HVe3GCVwuR9wmcqacoLVVeBU5+fuVBc5banlqYt3WDu?=
 =?us-ascii?Q?OKjVr+86eNXL5ghUseljhfapuJYde3x9qJkuigbwQdI8JFRu4S3hLyQLx3fz?=
 =?us-ascii?Q?ZZUUs6hxif+YX5wdnLKCeLM2DeRNSI7rNz/jWWu7rm7qbOUPzJ+de0HnPP3C?=
 =?us-ascii?Q?ht2YIL2k71yKIMgRl9u3GyFcNjwJg2TU5C2uKwE8LGIc3LcPu9jpkQtVuFgT?=
 =?us-ascii?Q?saUjkLETow5Q3Nm18T9vSP3dOr1Xr6vebIG2fOHlyyfnst3MnPcNaPj4J1qS?=
 =?us-ascii?Q?q95Dn2Ndh7/3yZh4lNIDrQ/PFFpyx7IW6skUbha76QHJrQ/2AraO8kCiMx7L?=
 =?us-ascii?Q?2C9B8hL43Erx/B4r2Vz6uS6mpgOQ2nBsjbatb0Qkmm0C/YatUdiBJlEhN6ZF?=
 =?us-ascii?Q?/zrSP6hj2kvIJuxtA7wO8s32DXwFKrYuYt+PgNJTgjChYgWQD8GhenovWfKi?=
 =?us-ascii?Q?dbdi7+yDwFn1NjSVOxYI+OKsdqPKZYvglbzEaxx7YJKAA0bmBi55rOaAtCLF?=
 =?us-ascii?Q?7HahVfpA+whT1qJ+Bd0P4NXzQjH6N81/36IbZ0irB2Tvm4qc8k84PySwZJuC?=
 =?us-ascii?Q?9Ks1O8kIyYZcBKhuJG1cbjdwpVc/MyCisfd4lQaJqf8gn7lX3D2V0CxRvyaW?=
 =?us-ascii?Q?DP9d4bd2eAT5LuKwSZ2kvb2MFkr3+R52Tf9IBBvyT/JxpdVWHKKgPX6cEA8J?=
 =?us-ascii?Q?JFC77mKLBFQfK3KaKi8vnpHfn9uAMoJaI9pyKNHkXj9kuTgzmVZMUsXX2zIN?=
 =?us-ascii?Q?AnnuWfWvtn9AF737stAEBav7mj+hj7T/fo+s+dcBrykDfC6MTkEJ5y1mK718?=
 =?us-ascii?Q?JpBatWv/dI2pWQQR15cJEmvbYrLpSdNgjtdUJLAjz+9C9b5Vhk9JUiHYjutG?=
 =?us-ascii?Q?iFOF5DJgU0aZIlaYZeFxb73dZ4Net6TvsO7u1Vm/6rY119JC5REG495V5PeE?=
 =?us-ascii?Q?NZpwNM/y+/hiIaNXxVq+wkBR0wYZvGAYiVZqnnPIs3bvOq2crsmcu6M59EHw?=
 =?us-ascii?Q?UCuauS9tsPkFujamxv1j2b2aT5mZTdrnU1D8b7bR0pxzl0HYgMigxegvjgAg?=
 =?us-ascii?Q?Gy0IBWEu1Ge5J0KN//Qr7280307V0S4CM26AfFWJFCce2J41HHF3gXf/cxh8?=
 =?us-ascii?Q?5hdw8wVgun/U9dEf5SKJlW+UdVG39q/qewfp8nd2kKwaS9RM9Gw4iLYPG16c?=
 =?us-ascii?Q?kgnjRNH2en/pBviXwtsk0/BrvH1pQ7Olcbal1TvMVlWCh5fasQfHwSEakObr?=
 =?us-ascii?Q?Wa+ACnK5O/X7M8aVVk+YKgV4Rhnbgveq6GP8uekwOO0e2CeC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87353a63-91d6-4eb9-bcdd-08de910af9ec
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2026 22:55:46.4671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NPWGlM8fE+LuoHl6Q1ibe5PPYQH2Yukov8y/eTq/WCVdPYqgP7L9XcgWLi6dLAz3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4341

This is doing far too much math for the simple task of finding a
power of 2 that fully spans the given range. Use fls directly on
the xor which computes the common binary prefix.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/cache.c | 49 ++++++++++++++-----------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

v2: Change to "if (unlikely(sz_lg2 >= BITS_PER_LONG))" for 32 bit issues

diff --git a/drivers/iommu/intel/cache.c b/drivers/iommu/intel/cache.c
index be8410f0e84144..fdc88817709f29 100644
--- a/drivers/iommu/intel/cache.c
+++ b/drivers/iommu/intel/cache.c
@@ -254,37 +254,29 @@ void cache_tag_unassign_domain(struct dmar_domain *domain,
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
-
-	/*
-	 * PSI masks the low order bits of the base address. If the
-	 * address isn't aligned to the mask, then compute a mask value
-	 * needed to ensure the target range is flushed.
-	 */
-	if (unlikely(bitmask & pfn)) {
-		unsigned long end_pfn = pfn + pages - 1, shared_bits;
+	unsigned int sz_lg2;
 
+	/* Compute a sz_lg2 that spans start and last */
+	start &= GENMASK(BITS_PER_LONG - 1, VTD_PAGE_SHIFT);
+	sz_lg2 = fls_long(start ^ last);
+	if (sz_lg2 <= 12) {
+		*size_order = 0;
+		return start;
+	}
+	if (unlikely(sz_lg2 >= BITS_PER_LONG)) {
 		/*
-		 * Since end_pfn <= pfn + bitmask, the only way bits
-		 * higher than bitmask can differ in pfn and end_pfn is
-		 * by carrying. This means after masking out bitmask,
-		 * high bits starting with the first set bit in
-		 * shared_bits are all equal in both pfn and end_pfn.
+		 * MAX_AGAW_PFN_WIDTH triggers full invalidation in all
+		 * downstream users.
 		 */
-		shared_bits = ~(pfn ^ end_pfn) & ~bitmask;
-		mask = shared_bits ? __ffs(shared_bits) : MAX_AGAW_PFN_WIDTH;
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
@@ -441,12 +433,7 @@ void cache_tag_flush_range(struct dmar_domain *domain, unsigned long start,
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

base-commit: 0f0423083d9ca07c49b5771848425c032a89089b
-- 
2.43.0

