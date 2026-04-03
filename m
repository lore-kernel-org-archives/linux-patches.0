Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F975376BF4;
	Fri,  3 Apr 2026 12:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775219219; cv=fail; b=frjbliVA8K+KJgcxSolai6jY9T9nQqtLbVARYFhZyYOB4BD+6VHJu3kZcczYy6M4Cyjm5nhSRUngQ1rDr3Cr93QeOTH9EoWdJOvWW4oDpgiU23UNnCNod8S2OhWPm+cJ2wkJiyjiJu5Z2Zm2+isl4FObfMBmpL/qH1aTTxBkKQs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775219219; c=relaxed/simple;
	bh=qzL3xiDLCkTlQOXUtV4F/wXXdf02UnKvkOruL/e9lhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tVIjRKG8aih8NGpIo76qHiBEjuButcp/AMi5mct0NpqxodE4Ohz51TKNhSW772AlqgfDXjJmSowZP0ss8DxEbWOK0epszPYckoDrH5ppxa8mDKxqbDVd9tvux5FOs6Odhf1WvsXvyqGHp6KxTtdpLDNQmMLfZSkX1IrUvRx3Y9I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lBbdxBIM; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lBbdxBIM"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXXk/d2BrQI6gFHIz5Px/ygN9cNtnL6GJY02y+SJybluIHOSeWyl4MNOLN1yH+sBvvZN+zcDwoWi3MZAd9cV3GWH2s9aNokrlun0T8A4Y7EaLhMEQ1ftxnwJg9L7HjKeEt6QorACFSsN40ZZFZSiFLxFeAJsrAeVrvBiIIXuG8FY6KVsKuwmr4OfZFVM9NYYzr2tGcNYylOfoc6C96LkleVrqrUFOZXglZIE/nUTOpgGU2PIe7n4aROZovW2tLRUu9ZdieR7R7NoG0qSRMqAxV8rjTBnrGZXSIM7e0ZXioZThxk06gNWHL/5G8sF70xon94chBB7baHreUpxQOomZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BGPsL77bDWZOszudCW9q+RE6es25GRd8ujwUU80+hdg=;
 b=N8uEFYQEg2HZDgT7cALbsCEAY0AjUIjp6LIDHr7e38wFdbdeWR4i2xda9BKGmAYFsA88izOiosWfI4PKVPNECLBLiqIOKDBJ7J7AuDxYY7dNZJYzTGks9QKC2sXd8H0ftSZ971K7cl8WwG3i7xBobslSJjb/mrg1eQLv0b7W2+35OHapJfjUb42jPwe9wiVJfiXGYia3+4Nt8tNUadQEesM6eDpfxmN/UvYQumcQ1mMEGjgHOVXKWPT3lUx+a8xxHqtZZCCIexR3jEQAqYmpOWD7/Mvpx2/4kFh780C1M2KsFTkGm6jOpJIexpAblXaT0wJW4m2VCXBZnzevFhCuuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BGPsL77bDWZOszudCW9q+RE6es25GRd8ujwUU80+hdg=;
 b=lBbdxBIMpbG7qemfVRIn1fEwBNhAhEOOch6mAzgIrK5AKLwywtfmqTEEr6WkcZcin1ndYEIr3rihYtsJzpsfKcRBhgKxKsfiws+Xfu+VQVCP/1KQ14sNv/1qc4+PAMea6TCmBAhwy3ELWbf3Siu0OiqlKKuZJUfPQ10axWTaVYl41TL0wL9cGul60YmYD/gkjfEPrC3PFQZE5jnk5bob2gnHMLJSFuLZlLHaQcU2Qf7nMvoO5VQauKf6urs6zswwDzT1euiKx/Y4IdLKSq8w3ikHk2HV7pemvRr8gdyualbjgGdpgZkVi663p/jetGUHM2sPAVlufdEFN17no+o49g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7278.namprd12.prod.outlook.com (2603:10b6:510:222::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Fri, 3 Apr
 2026 12:26:48 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 12:26:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v2 3/5] iommu/amd: Have amd_iommu_domain_flush_pages() use last
Date: Fri,  3 Apr 2026 09:26:42 -0300
Message-ID: <3-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0095.namprd03.prod.outlook.com
 (2603:10b6:208:32a::10) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7278:EE_
X-MS-Office365-Filtering-Correlation-Id: cd7cc7ad-7985-49c8-1ad3-08de917c4610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	nzYVnw+yU5PDfei25shAo2DXQKMwvxaRcMz0h9skbZcqSji3Y7egEyVzUEqQvzD2To7M1N/37rAZwtXvxtrMnFT4iD6LTu/T+oD9B4oi8RABZk0p0RwQi/ZCYXxKOg+jupSb8Rw3lA5xnLnBvxVcYqZARGARQcPmcEX2vYOb3x5WETJu4L0727BYYC+QcXYlb4hp+UHpDi5I3llunZIvC7Cc2jL9yy5m+7QkyjOIwy0gqN4WlJmyU2+PodOncKjzCG3BB78m/FFsy4bRLytAZgqIdDqbOYQFuUsNzhcot6A/ZOkXCd/Sg0XANtbaNsaI1Dd10Ogm56tEa66DcObLouvzVuBTRwfsmJZFknxmo/6jUg1SsX+FnSoPS6GbsvHNrrGgUYrUIatxUSbU3cAIjY15LyrfaYBwTteQXemh6FK4psaf3YvQvCruIyBJ3TeQO/K7awaQIpZU6n9yoH6iHrUAturFtJcX58mjI8qSoYum8tzjduE5ddxHfB4HovY/Tz4PHZ9OGKk0jF8TcJn1UInuGOF4WVtHoUaHvZZGsts6Yy82cwj4peNqa8mTM88oKD4VKce3sEH0jC4U/XYH0/8Raqqz1VGg1u4Q8aIrQ5tYTcRIbjQ+5xANQjDxjkhqM73pjlGX1WuNP3uzBO1WduVG4iDNRHZ/pJLlim6JfgZUaLpqtAvPRDrTz8Y/F55GERSlF7Kkc5g75UBqCjVkxjIgb3jSTXyUgJuL//ctF9s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ywbNMKUWRD7TR4D+6fDicMBkhoFWssimX+F01uy/A11FKyegdd8Gs1raHKqG?=
 =?us-ascii?Q?x1YQApyP3JDFoAVCBILb6Bq6VxBD4pBBvM3btdbu/wnS8p6yFKysqDCnghEI?=
 =?us-ascii?Q?QgFCzp6fherDgtWxaHvVID6m8zPaVLdkFtiPm10ZN+wUQje3HV3p4JDfhqBY?=
 =?us-ascii?Q?F6VHlY1bQ8lNjClR1rib5xrXQlVwEAKPzR2qJqnM7g6fqlqR/9p2JtI5NciU?=
 =?us-ascii?Q?rk41CpMIMazdHB/UOP7YReLOSEvqClvUp+fGCrQEeWNkyEURXco91IPYxIFT?=
 =?us-ascii?Q?sDd8rnKfXLd/wGapzHnwwqcvpfX/1rQNLt2P8DuzQ0GzqpLozFWDQuTfUymA?=
 =?us-ascii?Q?9EHZL4z2WIksjprBJsgRANNT19z12XDPHG3ltw3NRl91Mfo4zo0tGh+NGYu8?=
 =?us-ascii?Q?e+/9//JNM2UA/gd+qGVMbGA4N35PL8kIuAjKz/hwZo8IWXrabEuB5Eu0qshy?=
 =?us-ascii?Q?dxjm6Bvc5z/A5swDJhIztL/P35xKXZlR+tWmuO3aOzbmTEbmuvtrOnMEbs0l?=
 =?us-ascii?Q?oLrV01LEp9bB8Cc7dM6hXQzZED70l4vOepR+NxyXzryFOJ1NqIvgi1WNp3Dr?=
 =?us-ascii?Q?HZkygLfbj7lV7lGFnMyp1F1NkjTvHOLkquIUZo/hwZK5pWAhLx5ZcwLsyb71?=
 =?us-ascii?Q?5B31MgPtV3W2xICHv1ZZSO//fvB9oTxUqnpQ3GuXyUFA5VyXdjA9Bktdf8ly?=
 =?us-ascii?Q?/bsGee4/G9VRKlyC0o88zQv/fty1DsExx0xcsXRcW/qBO4jvf9nkN01FRkWG?=
 =?us-ascii?Q?CY4Mxs1lV1V9rKHGgKIBPgkRwwE1jepg0OtLcspSbkqRcG2IYpOTRoF3kgR9?=
 =?us-ascii?Q?twIGceQrb34biIdKBmX4xqXS6Q/od9P6W3i9zXduwVV7tXViI2gY6VQSRfq4?=
 =?us-ascii?Q?JebFK+4Qduj0xycSaWj0aJGMR5c2Tzz/FmHob0DoqYKJQA2Fd2OVqS0ybX//?=
 =?us-ascii?Q?XUWWnoj2LYl5RTr+6KEzMvhlzIFrguHV8e0r5Lo4J1ZWDkPBdMoAQM4Ppy3r?=
 =?us-ascii?Q?SOz5DsUfMK/NLNAxCL3hg6P6I9mi9PjlkVGsJ2vxWFMGPJCobel0sNzpH3Cf?=
 =?us-ascii?Q?P58/ICsauZHmTEFrSe7Pt/uUjLT8IlkJmYFPwdGWp9sY31X/kJ6xMAsATUfo?=
 =?us-ascii?Q?P6TlyUqDPUzt7APsWf4NboXW4o1bTkcgWRVBQMKoGvi1ENh1Qt5Xo4gsszxY?=
 =?us-ascii?Q?2xtWV6Eu9hz7FiqgNUp19uVqjC/kHIrC5sAcLfthQRewRB3XREeZw6QdaSvf?=
 =?us-ascii?Q?oBgtNo2+K/d5U+3mHM4izoTDqRvZSKKrhhu2cOr/h2AZWelHwHNibvTaRDyn?=
 =?us-ascii?Q?XAH/sz0zjUKYoEwHa7qY4Xd6M7uXkFxiWo/LDlSrxdGJx5gPGPpCffm3gwFR?=
 =?us-ascii?Q?lhdRSMcXxP9xQ6eEJrNUspSBqcY/IObpcI8v6z/pzFlbBNHvt6dzttSDOdi9?=
 =?us-ascii?Q?MXuPf+bKWEPqCJl/XxzpTi0f5aIlEDbvRZzSH667PgHM1koTCJLId9bqT8ot?=
 =?us-ascii?Q?w/64vzlG+AK+8qoKfBVH+By3RV2Rx23NSC9qm6X0o3And2FAryXPARt14kln?=
 =?us-ascii?Q?NFQvnwgcr/5HMGKC+q5Z7KACLXfHVXjwpWvGfzKQpLsPCAltxxKrFyz9neZB?=
 =?us-ascii?Q?ArhwhbqxT9+pcRGABiUVJIOEcJcETIzR4MItIZXNHKIZJ2RcxpNr3BtAP79Q?=
 =?us-ascii?Q?dAmdrwcBiqxF5lJg2f9fgLlcSa7IeBZ6tEYwZgwjoMMenchz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7cc7ad-7985-49c8-1ad3-08de917c4610
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 12:26:47.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a7beo1ySyuMN2iVrDZCUASWWXUF0ZdsipbDvocqPs1UezV7FkFAQbLn43K9Urtev
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7278

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
index 9ea40ab8398048..a058017eef2777 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1762,12 +1762,13 @@ static void __domain_flush_pages(struct protection_domain *domain, u64 start,
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

