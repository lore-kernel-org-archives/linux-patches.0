Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010025.outbound.protection.outlook.com [52.101.193.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A852738E124;
	Mon, 18 May 2026 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779133439; cv=fail; b=UrqkDM2ND4aZ3+Chep+jiY1juYwAAZ3nLDf0OrX7DyZY00G3+P0GiLM+PmlgaogHX5E/Hf28POFfP5N6mhUNv3DZ5Eir4euqfS4fg3skPq/D/4Wnd4sLTiqYwJo2CAcTrFkFrYH6KoTND5QcNZRxwlfdv1M22C4IgdJmHdo/4gk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779133439; c=relaxed/simple;
	bh=J/Gds95Lr8M2uMVI+mvVo6nUC5vZY/lE8ftoPcfSJ40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=p2yOuUnZa1YwPxYEC2iJ1vCYU/cDjjtL2RoVPRGnm2f+HqK/dSililtVt/Gp+hjAeano60bu3CrvWQOm7MAeLeuoPiGBV8cv9r8B4z/lXKslx7DhpRNSyLl4d+M+hf7Lhh3x9oZJoqMK7W/y0x/CQRduTE8HEI++PNbLjQGSkik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=e1QPuafR; arc=fail smtp.client-ip=52.101.193.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="e1QPuafR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KhtOD783P+DDqJO7gl/2lwJxVHeAhraj6KLnmJYu4dXcRnOdU5UWMxLrj0/dfcfQvP+TUCM0lK6hNDdLDShV6liro+pP1o2KC7iXtowzOAvMHf3gOR6T91z4bdnMqMMGyw3GiflXaJgrBhtZ0MhsIJ0/TyCJ0XMtyGSRgZhQ2f8hnaYUeKP48U6QKGz9m0oI2uCxkmWmle7gRAUY9gvYvv5zitkpnmfcNJFMn3s3yiWJREj2Ggi8yIQK+ju6Qj6Gbu6u7+5OClELtz8z+coOEPS/nSzHLdd5CnDmmcTlbyqT2n97mcH8rkbODQVlvxVk/Xb8PbQDlzIyowSBVSaMaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=etvv2U4FKsy2HZdjgWxHRqD+z5PRay/+07+XMhAoOQM=;
 b=AbJqzP8PTr6DyIhlD2Ubxn35ePaRLO0lr/svfH1CPY0cubRvB0LNdWBSeMEL7DwPff3jrq38YP+WZcJfwirPG67O4vGUEXVGJN6dOBb5mBXbg4J21yYZq4RGEGfdqZnc7B0Wmy04JVfx0tPa3Qn9zjH14otblS9TIWYwNGZSSuGDvyEfSq59SoyhXWyl2MsWgexKuiQQ7IP4VZ4RRPLNzcvclsW+G+kcHAwT3FIbK6h8OvLAbHXmSMTY6NnrHOcUkhbJ4J5CqS3xsnmU/tVGrPmN+ZlKLJgyfUA9WHCYDuVqECll6NS/qh7FRG/YbuHg05FqpZbezzGOZwIevWtx/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=etvv2U4FKsy2HZdjgWxHRqD+z5PRay/+07+XMhAoOQM=;
 b=e1QPuafRKg4YQ+Mp/zXS9ADyPncpvHJOqvBJ2Z+SycHj0ssyc8nq201W3QzynDvoWuMt717QfR5cqbzA9vlnY97401L5FDCnv0cDBqSSi48fiyLuAVt7iX+RasCTHxVWQsX3aSyYlAH8BYgpi6/wK0eQbmD3ZQ2yy5Iy6n/2Wurks+hRMVc75/TulgvkYbWp0hnhr0q7L2g4hKlMcTNDvthBx/LSgB9aCoQciZqpP82EXGkPzPz7yPM8fUbRjTm80SkVvjV8MbVa/nTsY4qu8MK4oD7FZMKyaqiLT0nslnh63g71UiDucdyq/YGv+cuxkYqOidSmK4Ijq5aBC/EIfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS3PR12MB999239.namprd12.prod.outlook.com (2603:10b6:8:38c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 19:43:50 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 19:43:50 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Mon, 18 May 2026 16:43:43 -0300
Message-ID: <6-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v1-5b1ac97a5403+6588f-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0124.namprd03.prod.outlook.com
 (2603:10b6:208:32e::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS3PR12MB999239:EE_
X-MS-Office365-Filtering-Correlation-Id: a24918cc-5990-4b41-535c-08deb515c76c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	d0YHDnXQ9A3dr/MMvVYLajAmTfkF7pbeOJTsurU9WxfSldwtoccv1UlCy2zs8LHghtES9Fn8ASUqWC0mRbRi/qsN/rBJqVAGwTeeLAZbgj2wtuA2YP5ddKad30FldB4fc05Cf6ragI4EdHVTwV6mw7xsNkb90Wj7bayEuoPAHyrjNP0PUQKDYfLaG9foXQ0boQeK4z95MAh9oFrGhhuocvfdqdhtCdqlc+jHoWBhQeHdY4g55fVV3AAj0XokGPR9sLt4CCLuUscklB4jZ62+tqrwAx/3dW6DfoJO0eG8sulFRrYJWecReSTzSXvN+yldTMhv4JGZwkZ19bvSP5gfyYbQLt1e6+dVFgI6hgHM1HDleAidJjn7UlF3KLZ3rvJWuH3RhzmAJGKSno71cTj2VMZOqF618kflnDAcII1RBQE7mFqU/CuGRqu+g2PQDub61HqJdgwb84DTpezRE35cVgMlz/rvPdfpT5XncTKRDLWQELCoJgdZ+Y/IDaQUya66dWyVb7pMoYjHRiqaz/w9aliI2mbp+Z68WH9EDYppSltIBndDiySVnT2ExAGTVcScGmlzVUwXYmPElCKMwgLuWWIde7Zs0ztKjs5GVfL0CIsdSZljyrxuO3WoG70szYvwNvQJeOXn4pFsDuH7aT3LQQcVu2C3FsYslyTWfNxS6+iKvkJhVPCVP3MnOjnN6key
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3tdlHAwdkDwu4ZuhFC6hc2S1liuc8ipby9kHqQvXPsQ80hu2bqZiG27MbpTo?=
 =?us-ascii?Q?620UFnQv6A/I4W2bnnSHTHfLSjxASwQrBhgRp13GkkToSoDSySDN9kzz+CeO?=
 =?us-ascii?Q?O+FL72dETOhJil9flETZ4wTM5lAa83ee/aa9PcrLtegCPPTpse/rQ8lYFl9Q?=
 =?us-ascii?Q?HertE/opxcJmtHHqdr2nmbcdq2wbEQBzzHPNW0NQaKixSSuDdwU4vIwGyAnX?=
 =?us-ascii?Q?8M9RK/Unby6kecSmvUGXOd/tVv1sKEtgdp8QJLl4eh0nAjuXHU1SywubiH53?=
 =?us-ascii?Q?3LVe4TF7ir3yiFkvpzAspBhbje4E3+Sy+OXbkbL5JKmmL41GVEuq4WTzeWGj?=
 =?us-ascii?Q?+av6RAwoquru36/bEcsYXoudDHE4NT5Px6UNeug4ffWOR487Av33URm/9ZQ7?=
 =?us-ascii?Q?kZOOaec4mbSjPOcAZ0RAZhext0b4g2opook304Ta1mAvR6bqcyHgsIuU2JUC?=
 =?us-ascii?Q?8hWS0j55TJMg2MHoNOFyRx0WfDYu8e2izVRCu3rhhJBGyF1G/dFUWfmxpvw3?=
 =?us-ascii?Q?ISwtXnYS3fjWTSzvr3tZxwls+V8EWDyuuxpMupFQMDf5I1YMkU7nrqvGyiyp?=
 =?us-ascii?Q?qJ1C+LvuK15YamQpeRaPO8aAtQTUDIwenxJEYr3i3MHEpTdgYIfssHPYN2o7?=
 =?us-ascii?Q?IBN5KHb/6vU9Kp/YnIPT5CpDCjVlpxir3rGj7LBfkg0ibLDk5ReIttymV5Dd?=
 =?us-ascii?Q?lTPR6TcRfaK0KMIMu2dn/8O4bpE7QZfle61W7BM6VH+hgUvVig1NYPIfIBzG?=
 =?us-ascii?Q?7+Veh7X6f9E+kUdDnftqzKPLU/l/N5FrpRGTNFSTLqoFefuwhKaz4R1VYo4B?=
 =?us-ascii?Q?31YZrdYJr3rXQwznCmyRZPxrSQwrkzb6CpHl1VPL24+taKC9ZTsJWVYwVxnz?=
 =?us-ascii?Q?5kCkSQhs7NI/rCTLOJRQOZPxoNNLuAJVmdlmwKLuqF/2kJ+GGKaGa5N93zFx?=
 =?us-ascii?Q?JO5DVafX6kfBXQjdmtYAjh73W1KE35y9DSTIlVe2PlPBu/GnoQJuU/szYca8?=
 =?us-ascii?Q?c7pTT/pcxZnUjUSe3Z1Dn4Wd8r2mt0qZYMywOf8AMhoHI8eiQKYsu5u4ExYU?=
 =?us-ascii?Q?3tsKs3xdRjP56wybkx5Jx4N+OLZVZZmoi1/ldRTSLjYZXlmKVDprnE7etPpV?=
 =?us-ascii?Q?ROlf9rFNi+iPXhrOdwks3mPCn3iHIInNPW0/IWVILT7ar6zCpMjchGkKsrYx?=
 =?us-ascii?Q?0F6BHG+WH9D+oXa7O9xjKgrfOk+Qx1F/uQcg4U0b+vB/zAYIw5wk3cEokD7o?=
 =?us-ascii?Q?LdVhQlImxlTXZfGhb+nexsSDHJfk4ahdTYaI5GCu/Zhpm3eoW7vnmOrmbQx7?=
 =?us-ascii?Q?P36B1iAiHMFOvz+WzJ+8LlwVturg+wrM3hZlOIQpzLjme8J26SQ0QDCUBemw?=
 =?us-ascii?Q?bYnV6AUAr5/knb/5hLpDd9tyIjG+U77gu4aiGyXPdgGonVxPBkV9HEtQ/lyb?=
 =?us-ascii?Q?nwh8M5fQis7Qrb3BjX12K66A01Rbxzkx74xKOEClMv12NAsQmzDEzKWKgzfB?=
 =?us-ascii?Q?HxOQJ8UncH6VS62ITPi1/nw4YzAQtuc11FsS7yV6rv3bcmXErtrue2obf5D1?=
 =?us-ascii?Q?4WJvFT5YUrTVsbNc7lyX7cdpDyxNYh8JWNkPpMDsnYI1csURl8CavSPqgYok?=
 =?us-ascii?Q?66kqLhtUJPJEdNoNkH+HZ3Cm/fww4QESc281GtOYcrIgC+YCrF0Onx86X7gf?=
 =?us-ascii?Q?orC7lRAgWcmfUR/Uh8JbCSVxLbqvEHxTkFrttdjB3RTpVIje?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24918cc-5990-4b41-535c-08deb515c76c
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 19:43:47.9919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0sxPKr3mG58v7S2yQgBBELoYzGs8+Ffx4lDiS+OMMBkYt0yLL9OZT33xuzUvx4BN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR12MB999239

Each of these has their own unique situation, populate the tlbi right
at the top and pass it into arm_smmu_domain_inv_range(). They will
diverge further when the iommupt invalidation scheme is introduced.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 21 ++++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 51 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 13 +++--
 3 files changed, 45 insertions(+), 40 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 4649717df151ba..c708fefb053771 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -129,16 +129,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
-	size_t size;
+	struct arm_smmu_tlbi tlbi = {
+		.smmu_domain = smmu_domain,
+		.iova = start,
+		/*
+		 * The mm_types defines vm_end as the first byte after the end
+		 * address, different from IOMMU subsystem using the last
+		 * address of an address range.
+		 */
+		.size = end - start,
+		.iopte_granule = PAGE_SIZE,
+	};
 
-	/*
-	 * The mm_types defines vm_end as the first byte after the end address,
-	 * different from IOMMU subsystem using the last address of an address
-	 * range. So do a simple translation here by calculating size correctly.
-	 */
-	size = end - start;
-
-	arm_smmu_domain_inv_range(smmu_domain, start, size, PAGE_SIZE, false);
+	arm_smmu_domain_tlbi(&tlbi);
 }
 
 static void arm_smmu_mm_release(struct mmu_notifier *mn, struct mm_struct *mm)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9aa08f782e8986..94f742de90330c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2642,25 +2642,12 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
 	}
 }
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf)
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi)
 {
-	struct arm_smmu_tlbi tlbi = {
-		.smmu_domain = smmu_domain,
-		.iova = iova,
-		.size = size,
-		.iopte_granule = granule,
-		.leaf_only = leaf,
-	};
 	struct arm_smmu_invs *invs;
 
-	if (!size || size == SIZE_MAX) {
-		tlbi.single.use_full_inv = true;
-		tlbi.range.use_full_inv = true;
-	} else {
-		arm_smmu_tlbi_calc_single(&tlbi);
-	}
+	if (!tlbi->single.use_full_inv)
+		arm_smmu_tlbi_calc_single(tlbi);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2690,14 +2677,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	smp_mb();
 
 	rcu_read_lock();
-	invs = rcu_dereference(smmu_domain->invs);
+	invs = rcu_dereference(tlbi->smmu_domain->invs);
 
 	/* Only precaculate RIL if it will be used. */
 	if (invs->has_range_inv) {
-		if (!tlbi.range.use_full_inv)
-			arm_smmu_tlbi_calc_range(&tlbi);
+		if (!tlbi->range.use_full_inv)
+			arm_smmu_tlbi_calc_range(tlbi);
 	} else {
-		tlbi.range.use_full_inv = true;
+		tlbi->range.use_full_inv = true;
 	}
 
 	/*
@@ -2708,10 +2695,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		arm_smmu_domain_tlbi_inv(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(tlbi, invs);
 	}
 
 	rcu_read_unlock();
@@ -2731,8 +2718,14 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	struct arm_smmu_tlbi tlbi = {
+		.smmu_domain = smmu_domain,
+		.iova = iova,
+		.size = size,
+		.iopte_granule = granule,
+	};
 
-	arm_smmu_domain_inv_range(smmu_domain, iova, size, granule, false);
+	arm_smmu_domain_tlbi(&tlbi);
 }
 
 static const struct iommu_flush_ops arm_smmu_flush_ops = {
@@ -3994,14 +3987,18 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_tlbi tlbi = {
+		.smmu_domain = to_smmu_domain(domain),
+		.iova = gather->start,
+		.size = gather->end - gather->start + 1,
+		.iopte_granule = gather->pgsize,
+		.leaf_only = true,
+	};
 
 	if (!gather->pgsize)
 		return;
 
-	arm_smmu_domain_inv_range(smmu_domain, gather->start,
-				  gather->end - gather->start + 1,
-				  gather->pgsize, true);
+	arm_smmu_domain_tlbi(&tlbi);
 }
 
 static phys_addr_t
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index b5e214b428d644..95da62d64df171 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1168,13 +1168,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
 		       struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
 		       struct arm_smmu_cd *cd, struct iommu_domain *old);
 
-void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
-			       unsigned long iova, size_t size,
-			       unsigned int granule, bool leaf);
+void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi);
 
 static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
-	arm_smmu_domain_inv_range(smmu_domain, 0, 0, 0, false);
+	/* Prefilled for invalidate all */
+	struct arm_smmu_tlbi tlbi = {
+		.smmu_domain = smmu_domain,
+		.single.use_full_inv = true,
+		.range.use_full_inv = true,
+	};
+
+	arm_smmu_domain_tlbi(&tlbi);
 }
 
 void __arm_smmu_cmdq_skip_err(struct arm_smmu_device *smmu,
-- 
2.43.0

