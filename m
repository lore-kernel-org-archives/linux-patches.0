Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222BE331A65;
	Fri, 27 Mar 2026 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774625053; cv=fail; b=Nk2Wv6cyyGZ1bX1ezJ2YATWDU+ejeK5qoqVhebr+2c3O5GyvKp+6Y8aYgSFyFNHKWTzRy5QjyuAW84SOXCHTQmhVU5a/8XOtgoTz0j+P0ZFPifbb5j6yZs4Xl/bO0vCxsMw12Ysfdc+BRLl2Iip7vIwLH6xB2ZxpqQtAfnlByf4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774625053; c=relaxed/simple;
	bh=toWSi5sYOsgwXzNN666XcYY16fdMSSSLj+5RmMrKbcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t0cm8L/j03TT1ngdVy7A7m1Iksmg8WT1PiWwjE6bgt3X2HvM/2sOlwWHcWgGlDsqpdQbmWPSiOEHvxBKE5p486dXlzq57+THxxPGDhcZ6KFTtqNt7u9sDFO+++v7AuSAqaBStpnwMoSD/nTv3gDXxRD86xx0y3ihDAZzCRNSP0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qutJgmK6; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qutJgmK6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=il5s4sFewa3QBDtWluxfU5vwaDXatabK+B6PlI+UqUUAPdccfWisPpYturPMKR4s4vFOIUol1Sezhb+rmeSuVBkriPDSvLJ4Y7fq8DGurr4y0uXSuVcNaevrLRFRoo8Dn4RtDCvKVxZTyPIMzpHVOSElvDmoiMZrs7/sWasT69/onyi8/zgdndN2OncczJADbDqCEQGM3KKQ+bqV6CuARLq7aozmWS0NIyGfggUV+Kdw6sP2eSEMK/jxWNP20F7pWYx5BCrCEZaSp0EnpKIx+i3VfRt+qvg4UjeHZuhlEzX7hAswfXXxkGlj03ucQhESI5pROEXVh2LxT+d1F3mm2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slnWVBj4qCMHQkvx9JIktFOv8fPGMaE9uefMwW2YXi0=;
 b=yCyrs5/1HFzSBrwDWGKRyf25m0dLnqb7sOZeRdK8ZAMpeQ1slE26LgSbJBesdlwqSxbxrE2Dm7C/PaJ8pkNjFlPN/ZGQ9tuOXdWf0QbkdfuYTl4nfdmgLWsgss83nG30Jj/+f4/llyEXNAdyuVxJT+Htc2QsY171LW+9OAKKGoINuZqcHHqKUt/8jg1S06AbcfaIJxiopznF4kKeyqumRkJq0GrSypEfnEKzyY5HSPrK7b6+gJh8vu1CNv46mcPQcujQH0vGko7cP89PilwKGnF1jj8j3KWIcU8G3KxUAUovpLn3IQOlxUiTmf4J/SL7/bAwVuILj8tgFSef3zTszQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slnWVBj4qCMHQkvx9JIktFOv8fPGMaE9uefMwW2YXi0=;
 b=qutJgmK6gDcOrvvQKK68oTBLxygcCVl9V/Zzmfvb8pZN1D1+EyXtvMTK39UuwseYQT/aN9+1U3kilEA8x8dHg1PabBqL/sI2qq99O+WlHek4VIXlW+D+dLzLdkXkOpyXDl+socYWF2uxtlUDC2k9eFLMaRROSk/OdJssosgvzQfdvYkWPy3CMTaCp59kGs4aNxbuOmSCjRS1cdBzApQJQC4x21Pj0kjZm6BxrrM/NLIIh1asbKOAzOQCj6fWvZC16Wqa/OpRrbGKtjBvpXX6Qxx0Z0rRzqfLF4Z1rM+cr12dg0Bs7bvYOKEH/L5IfAklq4ofVm+XT9PSp/DGwIFqTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH8PR12MB7182.namprd12.prod.outlook.com (2603:10b6:510:229::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.8; Fri, 27 Mar
 2026 15:24:02 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9769.006; Fri, 27 Mar 2026
 15:24:01 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH 3/5] iommu/amd: Have amd_iommu_domain_flush_pages() use last
Date: Fri, 27 Mar 2026 12:23:57 -0300
Message-ID: <3-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR16CA0050.namprd16.prod.outlook.com
 (2603:10b6:208:234::19) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH8PR12MB7182:EE_
X-MS-Office365-Filtering-Correlation-Id: bb5c8530-4219-4d41-4dbe-08de8c14df86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XhWIxBReF4X8ith3XolEKbZhiJTJ4hJ05i7dPIDmk2QO7MzaXMQ9V4I/bvYkSdJe//0PbDfqucPRk7IVCKKNS5YpL3ktEiz0kYx7ujRIklYhgusCqD+pVkAILCo8XU0Pc/pP8eNJxCLyD22CKrNQyJXeLG7wNjv5g+nxiMAcBxxINQ4OwTlMllcpdZTCuw9qHesudn4suTvby5RBJBVlQ/sJ31tON6pOfknKKnn3GGqnNX3DPclqupD2Hha7JGKh9YhchXUJURQdk9g9KOnOREKmqv0hs5FpPmKLoPOTdmJ2rUV5BFMbTv+YpilOF+6VrS4H8r4uVPRdunrjKCMtp6LcAx2hZN6DWi7NjC8bW97wgLBt07pfhfQ3ak4XnrOwLc0kYabN9GdAFB7p2fPg8M+SAmO0dxiAxaJWFjUa+8vxIZgLw5W/HTwbmOlk6x/7ou2G7uJN86s4zXTsVQgGB/48pZpjmJPwMYtGum7aTbwx5C8qfcvJo/ULpr/rfd1tSFMqltCeuuvSU4k8mLj06Iizw154j5l/iYAjhJMAKP46gJtCq1YGLmM5BVIRF/QwJxhZk1G6xLY3iQNJrKiiAg0z0XGPWwS1Sy1QOkj3xou3h6+CfC28MqdL08x+Z4EkDmSRJKvLpSo09jEVzELxb7/6sbKyfgeN9TGRsU1V/ZXW7g5WlZRpsAs9UBB14z4ZbJjNDg18LnFxGbbxZcX4mrFkU+lJveYB8gk3W0SkKyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?jmtE7K9C76APzzDtpGPQll7tbMufD+OqiISZZnh5k1zbiddx+BHdcdI6PVm9?=
 =?us-ascii?Q?rtgSnps7IQHvecIWA5ok8xiRYkay4IJ91nZPN2FywjQGgyRjkFgJvnKjGqRQ?=
 =?us-ascii?Q?Z0bNVtgFj9NeLOv/sUPmbDvcpN8SLG7/BsTdik0jGWrsGylAWQpP9mFiCtfY?=
 =?us-ascii?Q?Uzo90fbVJBmoqU+83j400PMSIvDKG0DDjcOGd/Sz8jMmRLUrT+mm6cNaTlCG?=
 =?us-ascii?Q?TvuqKc8Wvgxe4vCRH4PHMH9exv22toKKm6CQNbNZ507qD/gOhmY1oIS1KbRf?=
 =?us-ascii?Q?ThVPBqIRGGBqiMjs61cQImXUkF/nWBQOCxirsTGwy6rjlPt5zWejMuf35k2e?=
 =?us-ascii?Q?Ty85vc6vrwFUuoUgdFzqvZ/nNN4bG1pMhX6uofxD32VfghmdEV5Ir8ctVRPd?=
 =?us-ascii?Q?i5MUQku2gNt/KR9JGL14Lqp0vZJ9LX5zP5DsGs+qTyeR5SbATsmpBM7a6euS?=
 =?us-ascii?Q?zeW7DTgvTkcxne/oKZEhUAShAYdPO9w6jfvlNjOcjnBHmOM6L2LYcMfN3x5J?=
 =?us-ascii?Q?5pQCO1FoJ/iodQmUqiGMyAA6M9uXPkasRGPxq6Y8iMiCl5rKt+63OCJcg8Pe?=
 =?us-ascii?Q?qLw1bTUJCxSG/MTnFJc8YxKCqtyPVm5UiJJ5YsnkSDvlp8AiZZqXKpOj2a9X?=
 =?us-ascii?Q?dJMiSf+W5xAtRQ6Rchiyey4Xkb0UJDmDHDqLhgqkAQ1+pHDjHEKf2TxmE9pQ?=
 =?us-ascii?Q?1SM14CQhJJW2fLOkGwp/v+mn8gTAhXOcJE5GzELgl6iz689R4i7wrO3GeLho?=
 =?us-ascii?Q?1trdR+WaQ68ZNQawsOLhCxJM7FppWtsGd/dXaWZS/h+nUOwzTIhQgabZkp+3?=
 =?us-ascii?Q?oANZ8Atj+pm78ShSapovfPAYoHeGGQl8oYrel4Pzt9HfzGpIVhy0ZH9qUMmB?=
 =?us-ascii?Q?grTPG6Vw2H809oDN+IIq37ntqLLRiDgsWtk2iSOnVKyqn8fjOPYIaeuxVmcC?=
 =?us-ascii?Q?y61PAPwcpuNDOVGYgid5htWnntVHxoK9So0U4gAQcGia/pDXruKF2JQNOf+f?=
 =?us-ascii?Q?LaSWXKQ+s6mkZt26F074qbA/CSTgfkJEnVN34J5qwnVJBJWXn1FFv19Wms8w?=
 =?us-ascii?Q?t15Y1ysWfgEZvSHq9/Eb/w3N8Zwkl20MAM+S6na5rXnvlsYiYskk/c1aC2N5?=
 =?us-ascii?Q?fskl8KP1Z1mSsbwmbpIIWTF3nqNrXAtz2YaNsxPkNx4vzqfFoTlD6IHbz+SM?=
 =?us-ascii?Q?zTD5Wp0YAClxKIAjPvhf01sTAMgT0qsvcvqSmnnvCjh39gDpUsa1QcEip2BZ?=
 =?us-ascii?Q?sxZE+MmNk3zqCPZLr5OUSTHFGdhvbFJKHyIhbEUjTdXS1pegNbwz4CU+mSFP?=
 =?us-ascii?Q?t5iox+j97WW1dSL7IhIF60ygOUsg9kHxno7A//gJHuJygwUz/+SjWOO5XjGJ?=
 =?us-ascii?Q?rbSeE4gveZWbNeUBGCZDU4mKvWPy4p0xHN7R9HnqlSZj4UcdAiB+I40MbjOZ?=
 =?us-ascii?Q?SRBvnGpcuY8LB8jAB5Ng0892puBs4GOmttcApzNi+QRZDskN+l3duiDubkIJ?=
 =?us-ascii?Q?ohzJSOk/TGRbHf9aEDSuFuyyxppWbqINNH6E/pCiYcYrc56RfCuUIPL8MzSh?=
 =?us-ascii?Q?c5xKxI0GubeBib6GG5D3Hqpp+EnPoGPxVCpeqMtxQkNQSC+XJbSh2eUAxQgp?=
 =?us-ascii?Q?kRZg4Ey08HambtAulea8WMIEU3bi4JEX0c7Kbjv7gam0W4Zk294JqRRPjXhy?=
 =?us-ascii?Q?urowf4Pnd39BU2LPJK75EMW6zpGBBjDLj7Wm3LkxY0EOHAOD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5c8530-4219-4d41-4dbe-08de8c14df86
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2026 15:24:01.2461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3RqcfWdx5V03BkfiYym0GwzYN8Q9ETidAOaJaW3ikxgBNcInT0BoAkQPllUSXIN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7182

Finish clearing out the size/last/end switching by converting
amd_iommu_domain_flush_pages() to use last-based logic.

This algorithm is simpler than the previous. Ultimately all this wants
to do is select powers of two that are aligned to address and not
longer than the distance to last.

The new version is fully safe for size = U64_MAX and last = U64_MAX.

Finally, the gather can be passed through natively without risking an
overflow in (gather->end - gather->start + 1).

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 44 +++++++++++++----------------------
 2 files changed, 17 insertions(+), 29 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index ef4ebecb003494..67d4daaaf6f0ce 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, size_t size);
+				  u64 address, u64 last);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 				     ioasid_t pasid, u64 address, u64 last);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index caab941b531bfe..a3773a145af811 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1762,12 +1762,13 @@ static void __domain_flush_pages(struct protection_domain *domain,
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
@@ -1785,28 +1786,17 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
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
@@ -1816,8 +1806,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
 static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 {
-	amd_iommu_domain_flush_pages(domain, 0,
-				     CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
+	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
@@ -2617,7 +2606,7 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 		return 0;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	amd_iommu_domain_flush_pages(domain, iova, size);
+	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
 	spin_unlock_irqrestore(&domain->lock, flags);
 	return 0;
 }
@@ -2639,8 +2628,7 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
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

