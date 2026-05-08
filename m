Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 106433F6618;
	Fri,  8 May 2026 14:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778252010; cv=fail; b=AhsqwzjVPggKlfyVwbampDbdupscDKv4HgRgi0qiKx9laRW5kU3o5Kej96+I22dZRzcAt7nGC7/0X/ZA3UYLfbNtpdLgHW1dL++FxefxcN6791C0NXj8aYvJ19mg8gVYeOsDfNXxOQ6B7stmXZ0d01wQFzBl9x2pZsc5avhlIWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778252010; c=relaxed/simple;
	bh=vJbnsBs0niZzp75wuB675mTmP+rqN39RVAogsoyZLd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BWY0V9VlQ49UCjmucwJrxhLhOc1IZavm5XnKYfv6FMPVFYqMhg7o+n6OR7No1JJf2i/oF6tSNav0lPNFdZA0S/03kxRUoJgaW6RiIR/v3rOKFpjDvVsHyypKXf6kLas1TWei/ZvaJiPrwcZAHe3atsKEocTJ/BThnYzJGkdvALo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JFBY8ubf; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JFBY8ubf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lUqRxMrZdoj41oTzIWifN7pAzPcd8PTS/qwpjwMn5+S1oVGL+xvPH9NNtr8tbfTLgOvzHQXzInccMN9Q+r/cfM1+iaIloerG7oeuR7LMdkGTdj0osBAQ0IeE+WmcDJKa6+PsDJGVA2zw87UIJYZpMV7k/IlzsqiXvRZbWzTY5yZh3K80QOTZZjaxeaEMHKU8b+wuoIVFLXYPOcV7bl9cz/u3K8nKrsO0PvHOgfLpP9UMl1JVvcmoARL7onwHRW75F2l/YdK1MFpIUz3RHOM4ujoYxYC651URIjtVohnm4Er80Pyd7gDo0giHD74ZOpjZF5/ze4TWCGfXsh1ybvUcbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWTiN9M1VUK7A3RQjPJqTXsPCqjuWwZ7u5ix59wsSf8=;
 b=O5DZ3gt6F9eVQ0f+ppjUTCWdUgTCGwyOZXk22co0NaSZjgtsDw0zK0eSkDnEbWY8BpGZHok++vaH85dxuiRBQm+H1/OcEoakYIzn4lpGzWkxWU5ZyOvwiXiJCjSzrs449U9Z9hfXlneBhxFFeQAtec6vxympElU+C4Xu/cW3i4CySu7EnC+BGP+S67mhDolzleuy6PrMvr0nFb7sAwxcwxaqtHEV66pqBeRD4wSqyXItzLnD9yEsTI8Dd4KQuk7KlzBOD4FczYGTtzD86rlVypMqLYrFUb7yCH6Qrd3YXakkAPaL3LriOrAgKSwU9I7NJZGle3trsi+jwUKO4rnADQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GWTiN9M1VUK7A3RQjPJqTXsPCqjuWwZ7u5ix59wsSf8=;
 b=JFBY8ubfkvg+Lbd8NUf4gmGI++AV/BUfT+Fc+BaVks3ygix7r7+WKjm0DDG5OWBRPVna/z0mRNA62Q/RWBQAYhEEc2IloIafYupPva1f+oh5Uke9lucSRuRbnW57KcdHZIxhZkA1veIb5dd3N7R77Rpn5fZQ02UgbP5sCW8ZyAfMsS3cJtyOKLI/bYeVWDYeA/XbSSe0u6o80U8vcKS+sKI1JR4vs//h4XGZcWSRYAnnmrB+54eGEo/5gAh14D/mr2HGal0ePNKjTd5Y0ycC7BwhkvrVePkC9uBxqJdcWWyjP6wjszz59dBt94jTgZV6OAly8FrFTOAWvbV0cbUFyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:10 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:10 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 4/8] iommu/riscv: Enable PT_FEAT_DETAILED_GATHER and pass gather to iotlb_inval
Date: Fri,  8 May 2026 11:53:03 -0300
Message-ID: <4-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:408:ea::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: eafe4784-0ac7-42dd-7378-08dead11854e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	25368kXcEXZdIGvMAboiSb7ngYFGt027tfe3CkI9KkK+UF+/GH99W/pYY3TqRBiXaHmLoy0P4BZh7PiNjdeFxni3KWDMdV/MA28iliAjoA4JBC9yWiBhkrun2GY2rCOysAV8oLnCPsLDU+dMYNvs16zmhPbe5XqsFWDfchiLyzAk4ZIrwGezzahUN4JBrwO8gZxlwLtV/f9oyxVS9OnXQfDDcl3gaJ4vAMAaVcLVq26eYujBdpOfX1+WaK73v8lFiD22U3RA+6Q7bO7uo9QcKgmjt+WGmOT+NlAbkXcSKmnTJ8UnI8rteo6qklmEI8SloP4risx+sRAwxOZ71/45KC4KWiLm0DuOcBdfJbJWjVxRA3u1DvZrLjN9edD5nB5yXP8O7djkJV4M7IzU1KcNXLUdhA3o0l4tu9Oy8utfewHj3kAx16BAHuWXEN6EdviI40BySNNd36LndagFdiHg0VIUZ615cbDYXPQeJT45orgVu/3VjYJzK/U6YSQ6ynm/k0Z7C/W+5jJQT+VYCsLFnhCZ0GJivCw9TGn8gVVibVv0tuOpG0Oe6vdlrC9hzWtpCz8kx3ptcu3ey852kNJ7CKjYEc3Z4w2rOfbJ57KQ0vXk4Zs/qtzbFQ0YR8AVYBIT3XpchvcIaUf8D0FuLTa+7aR7ebMWyxME2NsJTTmZJbvmVPovYMQkI/tn7J+60QtnT8uXbmcB7wvk22tDtp+kG366AfcKfQCwLZMs8tijsMbf8irT9IIPk2TYqI+cqlrm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EYw9Lcz2FXL0hquU7OHbYtS5WIbvGDJenTtjXTmpzF/QwxrGQditRJn1cTso?=
 =?us-ascii?Q?t3+y1ki5m5anhmXMxqtH3Md8k7IdI169d3XxpFXq+qSk/5z71RG/JW8nurjn?=
 =?us-ascii?Q?QepQ/l6NOAEp9j758QGewF0LyZVpuIy4xsFbqbt4F7RMTI2sStiTjYYMR2LK?=
 =?us-ascii?Q?307ogQatrm5k0lM8ZFcneaXRAFOvq5Z5Dd4lgB+tAy1UJYjj0HVJ+uEpLGs1?=
 =?us-ascii?Q?J+aCnYI2NrEfyeevEyrTpcqktogkD7+6pJQITrQCNLS6Ba8MWCiGrFrRSXaH?=
 =?us-ascii?Q?H32FIdkmB90j/WxYbVT0WrsRM9IZoITxued/RyZUlovxYVFDloka22NM/y6r?=
 =?us-ascii?Q?890410dT1n5ai3v4gxA84Ycs1/FjXQ3WgJtSXURwCCl5F1QQls4tB4C7+ku4?=
 =?us-ascii?Q?sxsy/spTch44eHCgRkMqjJtJcDIyfGt0ngA30JF1kPpGhWwgJnAyoM0c6ozf?=
 =?us-ascii?Q?dQsN09tBSzXUNl5s/Bcg3sn4XcBSwPqCJcSBwWc0n8DJOdBVL2PKlvghRr4F?=
 =?us-ascii?Q?Yw4+fqDGZMgKgsF088ijsfZPyhPoSJu+I37PW0maYFSU1Own7yYcSYwxTFH6?=
 =?us-ascii?Q?sqSwMy5Pecpj3zty6CQ6PweQsGEznjE1AtDisBqXtqurwg9syDxITi5TO/es?=
 =?us-ascii?Q?lwIrV6xwpmUH2IV/hrpnbu6rojmqOFN8sIP7NNInDib1JSuKmMeV2hK+tmMZ?=
 =?us-ascii?Q?jsQuMeONGqWEl1kbicyPzyEmELAoBUBl2X9jFupDJa5w6G3qHsn1g7cE3QZX?=
 =?us-ascii?Q?vVgmD/xpHvrRZWCFABzrRrVdGJf/nVSa/4vT7c2v/ZEJDViAj0PCYIloHaJT?=
 =?us-ascii?Q?1FM8ElH9LqrRHY6HP1l/4RcVa80WKOPv+PyWSHBu4v1GaqpW5YX0aHI4JRxt?=
 =?us-ascii?Q?JI95KdVq9RLbsZ3cZ7undtsORaNjXeGKEA6VkKtMifXy7BGsCDa0ciAg0MiZ?=
 =?us-ascii?Q?+v3pIH2J2Go09pmfsn+mSj3TyJtAOZNVk7XbnQDGTYnIJnqlJRlu3jBPTco2?=
 =?us-ascii?Q?8vBAq/S57ZsCH1MP+ePOYEV7skdPFVmOn6gQhMSPjSNSG2n49wxIN4PMnnsq?=
 =?us-ascii?Q?iMg1PpwSQUsPuRbD0HMOR1PIFUQWBlRhn/ePFj/vPx6P91MOYYX8R0moO10l?=
 =?us-ascii?Q?i5Gsi3i8FfaCZtDdmhuLSpQtwjUiBWuSUBpAbbhhG+AOVfYaFxqoFYBLIVDT?=
 =?us-ascii?Q?BohEUgSFsd8lLRO3jDzZjVucYunFj4nca8Ot99MmEjA001OTj06IjCBuj9lj?=
 =?us-ascii?Q?JFV42im6yeCVJLsm5XtE8mvICIqA1qPTiVStLvd1JG0LTnuHV8VM5lotx68L?=
 =?us-ascii?Q?0DSPeEAXmsCc9r9B+7YvUUiVPMu+j23nrytgnAr5fzPJQFne7u/Yo6iSpKA+?=
 =?us-ascii?Q?PGYp4swpqnhap75GuUAtUn5Yg5rtjTXIQH1BSBIslJ26EFamj6notskNtole?=
 =?us-ascii?Q?9crtKDU1cInEh7wIt+f0ZKFbrxsLrt4czMXby+R0I8Z5up9lFpywmmYYLYmS?=
 =?us-ascii?Q?JaSyOKFzKBxKiWCiOsyaPpjMmAr0I7kmmc2UDdA4Bm/sp6B/3/2dS/YtICkR?=
 =?us-ascii?Q?d9+e5y8NIxkz663uqdBXsIm/qqdopZJz8saZJvOIlbOWrWJdyOupzwpVSMl3?=
 =?us-ascii?Q?0ZjbA/hUsC6WgDgE5bTK6vzd78gTDgVgyJg9CehqGzTg8n0CuOBLvnBWti/C?=
 =?us-ascii?Q?SuRQmntxA0LKefFYFDRedvqiv3yQDtIofGjQ+uCysJ4h+hml?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafe4784-0ac7-42dd-7378-08dead11854e
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:09.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZDIPnmBhHvRUjKOYFxHpjVDiXmiYHxww8rCmcSJe5mVDZVZcKiLGl3fwL8ZOgI5O
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

RISC-V can use the information from PT_FEAT_DETAILED_GATHER to
compute the best stride to generate the single TLB invalidations.

Pass the gather down to the lower functions and create a full-range
gather for the flush-all callback.

Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/iommu_riscv64.c |  4 +-
 drivers/iommu/riscv/iommu.c                  | 44 +++++++++++++-------
 2 files changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/generic_pt/fmt/iommu_riscv64.c b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
index cbf60fffa9bf7d..b18fc4d109f538 100644
--- a/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
+++ b/drivers/iommu/generic_pt/fmt/iommu_riscv64.c
@@ -6,6 +6,8 @@
 #define PT_FMT_VARIANT 64
 #define PT_SUPPORTED_FEATURES                                  \
 	(BIT(PT_FEAT_SIGN_EXTEND) | BIT(PT_FEAT_FLUSH_RANGE) | \
-	 BIT(PT_FEAT_RISCV_SVNAPOT_64K))
+	 BIT(PT_FEAT_RISCV_SVNAPOT_64K) |                      \
+	 BIT(PT_FEAT_DETAILED_GATHER))
+#define PT_FORCE_ENABLED_FEATURES BIT(PT_FEAT_DETAILED_GATHER)
 
 #include "iommu_template.h"
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index a31f50bbad3535..556d5dc9c58681 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -929,12 +929,28 @@ static void riscv_iommu_bond_unlink(struct riscv_iommu_domain *domain,
 #define RISCV_IOMMU_IOTLB_INVAL_LIMIT	(2 << 20)
 
 static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
-				    unsigned long start, unsigned long end)
+				    struct iommu_iotlb_gather *gather)
 {
+	unsigned long start;
+	unsigned long end;
 	struct riscv_iommu_bond *bond;
 	struct riscv_iommu_device *iommu, *prev;
 	struct riscv_iommu_command cmd;
 
+	/*
+	 * When non-leaf page table entries were changed, the base spec
+	 * requires a full PSCID invalidation (AV=0) since there is no
+	 * way to do targeted non-leaf invalidation without the NL
+	 * extension. Force global invalidation to preserve correctness.
+	 */
+	if (gather->pt.table_levels_bitmap) {
+		start = 0;
+		end = ULONG_MAX;
+	} else {
+		start = gather->start;
+		end = gather->end;
+	}
+
 	/*
 	 * For each IOMMU linked with this protection domain (via bonds->dev),
 	 * an IOTLB invaliation command will be submitted and executed.
@@ -1145,8 +1161,14 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
 static void riscv_iommu_iotlb_flush_all(struct iommu_domain *iommu_domain)
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
+	struct iommu_iotlb_gather gather = {
+		.start = 0,
+		.end = ULONG_MAX,
+		.pt.leaf_levels_bitmap = 0xFF,
+		.pt.table_levels_bitmap = 0xFE,
+	};
 
-	riscv_iommu_iotlb_inval(domain, 0, ULONG_MAX);
+	riscv_iommu_iotlb_inval(domain, &gather);
 }
 
 static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
@@ -1154,19 +1176,8 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 
-	if (iommu_pages_list_empty(&gather->freelist)) {
-		riscv_iommu_iotlb_inval(domain, gather->start, gather->end);
-	} else {
-		/*
-		 * In 1.0 spec version, the smallest scope we can use to
-		 * invalidate all levels of page table (i.e. leaf and non-leaf)
-		 * is an invalidate-all-PSCID IOTINVAL.VMA with AV=0.
-		 * This will be updated with hardware support for
-		 * capability.NL (non-leaf) IOTINVAL command.
-		 */
-		riscv_iommu_iotlb_inval(domain, 0, ULONG_MAX);
-		iommu_put_pages_list(&gather->freelist);
-	}
+	riscv_iommu_iotlb_inval(domain, gather);
+	iommu_put_pages_list(&gather->freelist);
 }
 
 static void riscv_iommu_free_paging_domain(struct iommu_domain *iommu_domain)
@@ -1267,7 +1278,8 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 	 */
 	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
 			      BIT(PT_FEAT_FLUSH_RANGE) |
-			      BIT(PT_FEAT_RISCV_SVNAPOT_64K);
+			      BIT(PT_FEAT_RISCV_SVNAPOT_64K) |
+			      BIT(PT_FEAT_DETAILED_GATHER);
 	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
 	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
-- 
2.43.0

