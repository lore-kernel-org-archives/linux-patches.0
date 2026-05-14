Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011009.outbound.protection.outlook.com [40.107.208.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7E22BB1D;
	Thu, 14 May 2026 00:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778717492; cv=fail; b=uoverkhpRxYwGXjk2DkJ/oRHWpqCQ8CtlzhMtVMZYV6CDuuwaEWn7JaSwPLo/IvhtPds6LwD1cXFSlf2fXaLBkK2C81quPw3rQXA+SMTqWX+tZ/zXSugrielyBlgDiMOVgCQ5j5j0wT3F6ZPZX56HDGPByJBULfSbDmNCUJwZOc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778717492; c=relaxed/simple;
	bh=+wrGYLkfeNZurEt8qE8ZKekG7kTTh806qP7Qj/Hq2SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cz5+31bnvmJGEzmUv21wqIORHaZ4B1j3T3lThDXSBW9lvyYWgI8dkV2ZfUHAey7A44M7CkVPS4OjSQi0Rt42bMYa1Op2llOAcpr3ZaOe3VyNlxWwoAk9vaBNvi1VIcF8UJTZYvrY5RnsDertF7hZqcFpjd/82mdCWK2x+1PJ01I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hkQs24uH; arc=fail smtp.client-ip=40.107.208.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hkQs24uH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cSIheG1U3txsQnVwpU5+ab9Hwrr1sEKnmMD18PYsRZ0/rOJKGrls+PexswzbQundG+LRr75KZK4YIkcXGhKPyvE1s24HWXYhNQorO6x5oyb7A+uO7t3JMtnuU1UXYGaiyQhJe9LLg21SE99uDIcuoxXrCytk1ES9JIXmUxuyH+2ZSMmRklCZFUMc6OGQABp3NcfH56h41gWaBFxOjPvdwecfYhfsyWIXSer+7lL5nT+6erbcHLHRb6R6YwnmIghl+ySgrjhUqLHZ4YaSmRtgaPg5oAJVmQuQN3P3K0LUxtz/vFJferqLb2mMdr40tv46kqBdO2ICHE+G/kzIkSp3PQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2lf7eEXhgYnkVI6ojF/mhExOms1nmkYMNEtaW7t7eks=;
 b=kRaWTML3uI8APrnajhs4xBFUZayUqlEgp0azqWJBHL83KOMKrVrWmCypGs5J+tDDtAuut/9HCfWKuqvE/IbO1Knx+9IgDIx2YCLb3u5AGa1NmfT654AEmIcvfwjMRi7lN/Hc3aGUzyds0b441C+s+l8SGD/OV0izRfNhGL3vDUUWdays9wIEpncNTddAloecpqfjJRYDqSxCTMt31J0tQPbtxlbJ2VLWUa2DvkRWDXAIe64bp6lHGYfwqtJN+fku1hoQXMu8GMmsANn7qt027SXcsJpbuytDR+HdFMO260tpPqrhPOC4qHA7SVTJJpFYtCw2aJqGf9lkknPUeANMcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2lf7eEXhgYnkVI6ojF/mhExOms1nmkYMNEtaW7t7eks=;
 b=hkQs24uHpmQ006kEg5CFmb4e/jJcIIsYJdDFX0S6i90vEO59GWdVVC5nKdPl2q7ck+Ztln9P0FTI7nYawUgRC78iaWnZ5OXVNILNM6gK7+RUgum01aevlDnKpD34HOBLfE+fN77o/8ukielT2mWMqghVqC/YA+BVyY9MI9xXPAztLwgiKNnEqR/stlec/nhJfeW87YAWZE8KKZ/QdEScac3Le8Gof3wp2Jmu7PKx6wemfLyZFZ0Q/W9/I/XQGb6aOrOcRIE/H9JvJa8O1Zo+J3gZtWwYN1kNKgg5Am9XI15BB+HcJbPAzcc31inG41UydgxMVRqlZHlWGqv0G147sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:317::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 00:11:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9913.009; Thu, 14 May 2026
 00:11:22 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v3 3/5] iommu/amd: Have amd_iommu_domain_flush_pages() use last
Date: Wed, 13 May 2026 21:11:18 -0300
Message-ID: <3-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v3-233e3af938b7+f1-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0031.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: f80c855e-8019-4acf-1415-08deb14d5443
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|11063799003|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	WaPcKkmy4WESSxFczvZG59jw3QBo1QB+ibWIJO+lFUJ6sNl2YPXy91rLnSJSxZE31N9BPIZtOfF2WlqgqHZ1G1b1fjgubesnpRDzNDwiSpnp55KnRBhIHbeyF8vwui+wa+5q9cRXI9+6XdTPoEmuULLyrrmDK91ltqv97eHVqTZilGfiYEGMLkuUEOucj6mpWdFF50gfISBbX9U0hiU83m+Hyt3Ix5gV8oR/phV3e3bvOL2EBwOzjHKlsucwaufZtnkauCLwAEuJU3J2qvv+jsXKIUHV4/urslldIuvR7jiwQi5yOGLELNsLhfmARm961M9vj9pyN0HB/NTyG1xz8KbuvF3rKHr3/nDf1uHKJH2kRU4nv9c7kjbWwAsBadeSNBLP91L3uaZhp2Oj/0Gg8NQEtDWIbz9xOP5zNGuqWhb4bRgGbQGu2dHPeXbpboCWt0w53O3YaO2tsgkAwop3XVZU5Bt4xHUVPqUOSiprUxcLcunhzUL/JykxAbF0QcoqaP4SdXFjrfAgrCPVbbgbtIcziIWcdpbYkhZqLAFEC8/+k+B3Cy5HBDngeXoCQw1Ls6oXvzN4QTWBTcGyatVTkbamX+ejtkZjv6MB9dZFv4PGT9C850CwxjlvGZeZ+p1UNxlOIQ0DIbeNa+tBXSm0fW+i+UuDJBphNZ0TRgp0zCR/PsXo2dT5hBq+dIPg0cQ5
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(11063799003)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zG5Uh0KOtgoL0woOMsYZPpkM/hz8+tS6A20OOqu31LJQ77kfcrp2slysWOp4?=
 =?us-ascii?Q?LgvrAfG/zfThfOG00Y6YB7cbuZxkqavW44cu7DM4h1v+Fe6hWTTvUzcxcXy6?=
 =?us-ascii?Q?PcHHHRHm7cZ9ygliuWoJ7QO9YNjTTWBxRsA1VMbfn1Auc+H+tVU/Qc+WVg9j?=
 =?us-ascii?Q?uyLk441OK5tq3+g3uZF2rsPro+GIWnUrVw5JkbBfi/75vIcyXK61zrUnHSf9?=
 =?us-ascii?Q?qUQ7UDSmmNPHwTNIkY6xQ6T2PJouEymPms/8Lc1ywoFwxNts/TLKDlZywyFA?=
 =?us-ascii?Q?BdzfPSKc1BjOzK2OHSj9rlxTVkYyuWUoIOxJowMFbov8d6Ka+Xjo1LToHcPD?=
 =?us-ascii?Q?b8LOgDfjqkRPEMdFUAF0VnDmF8RruHmwd+3wjVe7pf0rjRHAtI4vD8Nopl26?=
 =?us-ascii?Q?FVXAK1EjoyRIiE9wN3Z+5wrsuBNeKD4iVe3qIv8/YXHIEuVXbNk/IIq253hh?=
 =?us-ascii?Q?UGkJa1KgeeT8KPVKV80FyvELC9fUnbjYEMA5zSx+jVzUARdQ0ef+xXq1Pgy6?=
 =?us-ascii?Q?wqw2/keyTxSQJvYhSuY0vspq9iYMdLsTveee/VWj7RuEpZlFtf9TaUgcSgvB?=
 =?us-ascii?Q?rDsFzCj/gfVyS9Upcfb+CsiPKODRoN9Dc4mq0fme8/pLaeF7YV9kjUdNxxjR?=
 =?us-ascii?Q?ddZy4gLyV8K/dbHCBpVxoblddV+A3lbe2fWTwO2F+mLVHX84gfGGgqRPNGMM?=
 =?us-ascii?Q?ddC4kxWqbNq6QxfCyRmU0xvppo6SzMn8djiYmNwrgSz4UPRI441hszRIx0NV?=
 =?us-ascii?Q?v7+pBEZ9i+NU/PyS8tKxtFCP6UqqYcy/Nyi2ZmbDOMFDKRNFoNLcnzSTRsIh?=
 =?us-ascii?Q?lHW159vbhIBdePbqNPepydxQxcfqaxZW8re3TNO+pYV0Tv3DICwcoxXmuwU7?=
 =?us-ascii?Q?8hoSbxRdj6GlPyqxdiWep2N0lmf/KiJHgsxvkAmVmqOroEoX8SP2eV9kAkwG?=
 =?us-ascii?Q?WTF27eNok/aTaw4z88NDfPkO0JonDJGuJ9Fu7EDbin994LMOC2PnKF8Ccckc?=
 =?us-ascii?Q?1DIsjg1uziTshW6ENF+kH+J+coAXe+nboXBqqGj7PPklV1eD53458W9Pt8Uf?=
 =?us-ascii?Q?P5OmRUJjPbUPIPga9gPSoZEGyw2OW8NWPNXiodkCL5uw6resLTdiR+kP0NQz?=
 =?us-ascii?Q?dXsps1ODu1ziHB2d0t+EcuIUBxWxm8kvZoc0502oSNuKI2UeO7YNCa3iHK1r?=
 =?us-ascii?Q?BsRsp2CU8xzvAVis3qLG0rNjgofw8aaY9v4ZY4txbogReu7KS2QMEPiJ59Yp?=
 =?us-ascii?Q?s347A22fTtCbk3wT1ssAm/QZqhdZ9ZA+7K0aZe8QbgglzqYu1yJX2Bn0eGNH?=
 =?us-ascii?Q?ukXDR+z5qwVN+iWW4vJkRJOPWw5DgkAas6oVuB9zTSsElbsvTQ76M6yeNWyR?=
 =?us-ascii?Q?4yH3bfAWomAKxfqT0sHMV93bkuibYznKvEXtvmsNtB+wtxX81JNoKytd2blo?=
 =?us-ascii?Q?BWQ2EJd9Tx6JbGMNNUbrDpUD5EhzYQ9XR7NSl4U5fYmQqpKsmQ7Hkecd9qnb?=
 =?us-ascii?Q?1BBBH+rOCfK7hJInblCCeBTj038Ioy2OkrAV4cnUL84NsANNhO6xg+ZBsInV?=
 =?us-ascii?Q?RHCEcPKmteuk75xsV7xZNkIz8JMh2bwYh2dZYO0JtR0LgcDGu0/4cfjDuuWg?=
 =?us-ascii?Q?qM9+h4gistWbp4Ynp21RG1T7c7S1QgPycgCS/fY5URJoNcfjiAbfA27d6e6f?=
 =?us-ascii?Q?GrbFYUJ1pTWoftpKDfE60c2J/XcsKZDlX/wP2d2FFAaWpXGp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f80c855e-8019-4acf-1415-08deb14d5443
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 00:11:21.8584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGo9aZiAxqJoO5Q5dDPgHJb9/d5gHuCSJo4gTkZo8sqkqNNnFoQhBsfPjdjN/68a
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

Finish clearing out the size/last/end switching by converting
amd_iommu_domain_flush_pages() to use last-based logic.

This algorithm is simpler than the previous. Ultimately all this wants
to do is select powers of two that are aligned to address and not
longer than the distance to last.

The new version is fully safe for size = U64_MAX and last = U64_MAX.

Finally, the gather can be passed through natively without risking an
overflow in (gather->end - gather->start + 1).

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 44 +++++++++++++----------------------
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 831d457c8dad13..92410b9cf544a9 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, size_t size);
+				  u64 address, u64 last);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 				     ioasid_t pasid, u64 start, u64 last);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 52b91831c73e67..9a541330f599ed 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1761,12 +1761,13 @@ static void __domain_flush_pages(struct protection_domain *domain, u64 start,
 }
 
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, size_t size)
+				  u64 address, u64 last)
 {
 	lockdep_assert_held(&domain->lock);
 
-	if (likely(!amd_iommu_np_cache)) {
-		__domain_flush_pages(domain, address, address + size - 1);
+	if (likely(!amd_iommu_np_cache) ||
+	    unlikely(address == 0 && last == U64_MAX)) {
+		__domain_flush_pages(domain, address, last);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1784,28 +1785,17 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 	 * between the natural alignment of the address that we flush and the
 	 * greatest naturally aligned region that fits in the range.
 	 */
-	while (size != 0) {
-		int addr_alignment = __ffs(address);
-		int size_alignment = __fls(size);
-		int min_alignment;
-		size_t flush_size;
+	while (address <= last) {
+		unsigned int sz_lg2 = ilog2(last - address + 1);
+		u64 flush_last;
 
-		/*
-		 * size is always non-zero, but address might be zero, causing
-		 * addr_alignment to be negative. As the casting of the
-		 * argument in __ffs(address) to long might trim the high bits
-		 * of the address on x86-32, cast to long when doing the check.
-		 */
-		if (likely((unsigned long)address != 0))
-			min_alignment = min(addr_alignment, size_alignment);
-		else
-			min_alignment = size_alignment;
+		if (likely(address))
+			sz_lg2 = min_t(unsigned int, sz_lg2, __ffs64(address));
 
-		flush_size = 1ul << min_alignment;
-
-		__domain_flush_pages(domain, address, address + flush_size - 1);
-		address += flush_size;
-		size -= flush_size;
+		flush_last = address + (1ULL << sz_lg2) - 1;
+		__domain_flush_pages(domain, address, flush_last);
+		if (check_add_overflow(flush_last, 1, &address))
+			break;
 	}
 
 	/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
@@ -1815,8 +1805,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
 static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 {
-	amd_iommu_domain_flush_pages(domain, 0,
-				     CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
+	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
@@ -2616,7 +2605,7 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 		return 0;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	amd_iommu_domain_flush_pages(domain, iova, size);
+	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
 	spin_unlock_irqrestore(&domain->lock, flags);
 	return 0;
 }
@@ -2638,8 +2627,7 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
 	unsigned long flags;
 
 	spin_lock_irqsave(&dom->lock, flags);
-	amd_iommu_domain_flush_pages(dom, gather->start,
-				     gather->end - gather->start + 1);
+	amd_iommu_domain_flush_pages(dom, gather->start, gather->end);
 	spin_unlock_irqrestore(&dom->lock, flags);
 	iommu_put_pages_list(&gather->freelist);
 }
-- 
2.43.0

