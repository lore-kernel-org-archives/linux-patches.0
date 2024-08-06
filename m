Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2088.outbound.protection.outlook.com [40.107.212.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC38F17556C;
	Tue,  6 Aug 2024 23:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722987100; cv=fail; b=hPJnkLWe4I35bhxo8UvL1lXsp9V57JCoNah1OSdP1YSJFYhXaAkJvi4cQBKZspX9DGsUL2/bi6WRNgcjo85P12DtLv+158W7RFv/ZBXFPVduY2zuttYERp0PgYm9iCCdVscou8Wypgjy0NXkBSNiG5ZZbfys06iuzVVM9BFOLg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722987100; c=relaxed/simple;
	bh=G5Rh6ZhS90JC+E6pn5LbtguMzc3aJH6nQAusoaxv4/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LzrIdQ/TAFiAxnaRQJ2I3CyAa9QIoIPp7k+fzGmI6Voe9wdlEaY9LNzpS/Sl5j9M1fcO8ICHg9CZTqD1Cb06+bqeJl/YqrDco8QVDRnPQuC9Xdbd5fPnwjK0HJnzPbXcpV15f8SBrch/65FxdGekECQcVGgCbQZp0Sh57BeWcgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rSeq7ns3; arc=fail smtp.client-ip=40.107.212.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rSeq7ns3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qxg9Y3tWusQX/WIxIpAUZeXyw5S/xHDm20Lt43GhAmjcUEOhJxev4zpmc64KD/LFe0/S0A+glx6n2ZMqQ8pD9GlnKwJO7vd44x+LJ3gT5Mtk6EDhsUecfEqQxCrg3OqKg6XikDgTbD1/LGXy0JU/t2JQGHQGS8m1o6wk+r9rao/OSKd1/P02aJVvcModZW905MFAWxwCigQzZf+mJXRUdJIW446YfvbaF13Y3NQiYrioFsnfwHo7U5OAjyhgY/zBYOeTHAyal91I/q83ld9KfEHPczuWI8yKP5oEfJ6iUkMq4TOsAH0wVxj87YzzkDfR31QvUoa6zat1QidRTm6e4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KZZoo2aiGFcC8GHomd95Q5u1fLWQlnX/Du5UTasLzFw=;
 b=LxF3iJk0lZZRSgju+ihe6UVdUadViP0ZSdk7EgJQ7kx4Bv3+v5D4efJ/d7Njgl7hDhYaPhuBjnUkS3vjCCeBVn7+De677Ndfyx50Q2pmSEuWetfN1U5UFXfSBivR5xGrefAjzZe+j0KcyAa+uSUQ9pWo5YrbsV6yOToEMWsIjhRRYVjx4XOWY7clnS+uXg3ix48ahVoVQ9FPIoxHS+FhFWjtDeAVI4iq1UWYzmvGlY26y7ZljA8/PTbG7607GizUwXh1yYxkLhPQzwGytKbG9T+UvlGu+FHe0iU4JjWPrvN7+4nj0BCLpTy8zgSqNVmqlMObDbO4BSR4eGUh6btsnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KZZoo2aiGFcC8GHomd95Q5u1fLWQlnX/Du5UTasLzFw=;
 b=rSeq7ns3YR4xSIgnUMS3kkiWesnAdQVbqUOlLiAcU86rx5FlF4AjvWxs+MBzvTJFhkHWX+rpOhWwy/V01XO2N1+0cD4dxBcDv06vIbCdD80OvcOyCSJOfFx2cUaeFwmbPxQo7ZwXvtZRrYOmyvwF0suA7MuQMGGMMRbv4gGx7psKqfiYlI5rv6IXMQH/MKLi/rC+9JK3Uh2nrJIuEabXjyuA/mfjdAQYID5UnAN7SNhK5ENTfKDwy+JeYqnKth9wNQPuoxmLiA9alnq37AFdqRibBmwi/QMGh34QZ2H1km2HYVLPIKpKbsWl7VIWbTYolcsKW39LNBMg4Qplns4JNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by MN0PR12MB6248.namprd12.prod.outlook.com (2603:10b6:208:3c0::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26; Tue, 6 Aug
 2024 23:31:29 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.008; Tue, 6 Aug 2024
 23:31:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v3 3/9] iommu/arm-smmu-v3: Add types for each level of the 2 level stream table
Date: Tue,  6 Aug 2024 20:31:17 -0300
Message-ID: <3-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0097.namprd03.prod.outlook.com
 (2603:10b6:408:fd::12) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|MN0PR12MB6248:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e256306-6d11-4138-2189-08dcb66fe351
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ecggRX0cu87zXlHYLQQEKSB056S4w/Agb/f4CcsmLsMY4aFBTQ/4lBkUEOLE?=
 =?us-ascii?Q?mnv9DrOSH9zu+BPt5IhrM/unlkbfGPuhZpQ36+1nh+e+RdLqfTj7HYNcnnjX?=
 =?us-ascii?Q?fjcQZIchqMPo2sOY/ReH5iGVyKiENRuCcSK22cWPMPLVcmJfSeZ5ZjRi6hcL?=
 =?us-ascii?Q?imQAwR3LKIr0w8tXcDR2xHTRK814Q8CZc5K3t3UmTDTEMhbthX1O3W0gxmZH?=
 =?us-ascii?Q?/xGSQ0Vg+2gUriKr6RsmxzJEiK53Be35vMWfs24EWlAw+3cE2CLKIrg78KGH?=
 =?us-ascii?Q?uj9AErnLMR57Vh8+ND9H9kkWaxwE0DowVHFHhaqoBCFqseZV1JHS7UnpJe5d?=
 =?us-ascii?Q?h0vGSCFRIgYrLO12RuMvhBAKGDWn9a19PAxWsL2APvXNA/hxaFHzP0is7jGc?=
 =?us-ascii?Q?ugvwlUfHDQzN/AWFV+BOk7dI3e6LzzncBXnb1jemxlZfcGlT0IqN/tqcdUzk?=
 =?us-ascii?Q?WxQR0/95DhhnH5qeeq8nyCcOdctx9mDfgEqk8VncoXIL1t7mP2CWRvcQLvnp?=
 =?us-ascii?Q?JfcGHIdH0ogTBljAuJd6ASIS//cdWvURAybVAgVuAgm/azSnvZEZCIvghqg1?=
 =?us-ascii?Q?J1DxXppKKztXNZMSUIGeC8rlUzTU838vDrJWJNZqBuqefoXXQBTBjpV14UXj?=
 =?us-ascii?Q?o4pZkqOwHt+lmmskip7v7YNNNN5q9B1YmMfb305FzFj0gpL2OZrD3gCvvNt5?=
 =?us-ascii?Q?nZ8sx2LRfjs6rgSLwKEDIn/+pM1RABZy/Yi9rF9Jg0lXy1Q8x1XR5Sgq3cm4?=
 =?us-ascii?Q?JqQAoITl7MHwrtSXo4+AA8SfY3k/2PPOP1tezzjBKWptl8F8EQgbI8zXf+3j?=
 =?us-ascii?Q?7bnQ3hd8Db8uTHxcjOErQZ7V5nQYwNkiGUvxFkaYTwcCS3kiNenLIG9QhNs9?=
 =?us-ascii?Q?XhTg/ngBFOJM3aPjV5A8j3+fm/RWdLYpARtLI2w/EK9vMqWFyMi3Xo/ngoAf?=
 =?us-ascii?Q?1JOF3XxJ0rMcONoesuAOdp4RxMDxwFI/Brq96qGVdPLWX7WF07GsjDb1+4Bl?=
 =?us-ascii?Q?rznE+y5nzh3pHUVRaU6G1VJqdyv1ZJDoqSOY95hlqyGtYJnBQilJdCifMXKu?=
 =?us-ascii?Q?1Zn60QbX0Ri4L9czwRGW25TUNDdmiJ/UCaGAl7qKNAlmDAUTg5qrZIVzFVYN?=
 =?us-ascii?Q?0aGWwf0trEDfwmIr4Y/8YeEtEyxIcKz1kkSHbWubAAitXLZ5Nj9/gLCKXldc?=
 =?us-ascii?Q?ysZhU4VZ8C+rklm0zG6YMMVZz5EBoqsRnjb07w8a8AkG1k9Y8I9F8nVqw7Rr?=
 =?us-ascii?Q?REmQjiIraFuTeMVIy3X/apUrLQPWcVsfCzcF3OdLWZh9kAYMSq5xIbcdQpeX?=
 =?us-ascii?Q?5eaSOj8MtxaPafQV+Tv2FOWdzlABHPGc53ddkna42uWtKg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8YzzTKxtUTZ2e2ZrSedLsTopgNg9lrmWblBSaytYpusqFgtww6gVn8BgbIQ0?=
 =?us-ascii?Q?x9rQCAd5GHQaQVAJxTIGeyA27JFkZgwVbTeAMHYoQ8Lf9jRX8U6cptYTqH/n?=
 =?us-ascii?Q?kS1xc7fsBj8MOWTCaERs8vbZQvteeVrcPAJy9I04Nf+u1C89TSF3NHnijJIu?=
 =?us-ascii?Q?5K9rWPBjCdSvq7zZzbgINLEHzB0mi4IHg/9RQunIqDREpFbp8+jPBQyqtrGb?=
 =?us-ascii?Q?cGkyzTxgGdeKsT76hE/SuhPCaS1CPCGLBiDXsov2LDDIyllNQKPue626oJIF?=
 =?us-ascii?Q?X4Dqp21iadMnjhaASxGpljUEszyTb/Yye83448hLA3onR172VC4KtRau4wPV?=
 =?us-ascii?Q?TyWRf0qO6PsgLxfb/GdUJXr6TS4gAWmvfD/gIhOUM1EPkRHqdD2J9kpY2d0l?=
 =?us-ascii?Q?sqrR2ZwqzZoE9efhyTrRV/PB4engpx9xJ6BHR51fQDkNwJOxCAe6lHlmasXf?=
 =?us-ascii?Q?k6QDhuEmD/2649MME3tTZj6Db2m69QINhiKxzCIUNUjQ0qD0C4KuPN4rCDBr?=
 =?us-ascii?Q?NZ55a8Kxz4Ic/9LfgA66hzyb8F3naq+fZa72b8lQY6OhOYbaZMiBOQz2escj?=
 =?us-ascii?Q?9+5zZyThnVy/Mses93nfx2vzqP3WzAWhk7VkUG9/Ug5INpLqI3bR5IUQlZQm?=
 =?us-ascii?Q?3sPMGtEjmjP1GiGyt2fCc84oFpqnNpiFaAVNB9Be8K6W9/ITTb84UZTH25my?=
 =?us-ascii?Q?JPS8MuDJZfQfmSEs9XwdA1heCDjjsGIAzC8FriKvB8jtfVlptH9nR6X1vTCl?=
 =?us-ascii?Q?nN8o1DE+xlsmN3yBAtWbgIZC27q7nak5H1n5yRWFMLR+NKyCu818+dJPWT2w?=
 =?us-ascii?Q?BeWKCI0Q7l/STkExOO/mTeAJfmqb9zWDCkCs4kNorVH0SNS+RuTnnUlZCJjD?=
 =?us-ascii?Q?U15Zyb8dzmZPkXr497N9waue5Y3DkXxXotLTZUYmUGGSQvrTJlUgoeOkCOJw?=
 =?us-ascii?Q?Dm8OXnhMKLmLgrwevZ4wjbz5FF69+paZ5aB2ZEUeSWxt7mUblwrOohGfvkZ7?=
 =?us-ascii?Q?PheDeH4Lvbzr4aiean/fgOFJa34i3C9r0AEYRYiH/XPWoR2HpyjWBT7sLshE?=
 =?us-ascii?Q?OJ9EjXa1ONJBb5lozTev/jX6DK8qpJiL1wr44ujQgkFsUWmk8sqL8CdOHAcG?=
 =?us-ascii?Q?ulYt36yp+5vAnJZvLg3uhzZ8Rc66EJsX2cHegesYQK2OiNs4DIzK23aSVeZT?=
 =?us-ascii?Q?+X9yDRnRdGiMwBpC+zc7Kr9GSQkI1W/5K2EruK8xrtn4y681XWvyvC0hsqj7?=
 =?us-ascii?Q?Q7ECL0aqR87gJX1AVA6VpP8T8jxOYgZBIvgOvNmTsZvvmHcdNlt1o/Iax5YK?=
 =?us-ascii?Q?P69OFMy1ZBwePp1n1SrlT6rwtXUxfiGRVEJa9bofB1bbDGoiZTsv8F26XSF9?=
 =?us-ascii?Q?x7I0q/DBHSAr46+Kn7SVzzq8jIu4SssxRchGoKrXXzywv8pTDz0/1GR7/nE5?=
 =?us-ascii?Q?6/DX2zbb3i6Df33ehGRuJ8W1wa8Qd+NJ/zOkH4gJaIsNxq2wNCOaxI3yTaLu?=
 =?us-ascii?Q?A4l+0rqQ6qHFNoRzob8SMipBz17XmvJeCajnNZYC5nAhsTIu+88hNRp5qrUC?=
 =?us-ascii?Q?Z6Tx0SZwS2sciiqBFNI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e256306-6d11-4138-2189-08dcb66fe351
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 23:31:25.2023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfJ93bj14vWS5tSXYxNha9OuwXdpGdCgaLLFgRYX3UsEHKX5g2TdhV63iUBugfFl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6248

Add types struct arm_smmu_strtab_l1 and l2 to represent the HW layout of
the descriptors, and use them in most places, following patches will get
the remaing places. The size of the l1 and l2 HW allocations are
sizeof(struct arm_smmu_strtab_l1/2).

This provides some more clarity than having raw __le64 *'s and sizes
computed via macros.

Remove STRTAB_L1_DESC_DWORDS.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 22 +++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 10 ++++++++--
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a695e5f8fc2880..7a2d102fc11eb0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1458,7 +1458,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 }
 
 /* Stream table manipulation functions */
-static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
+static void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
+					  dma_addr_t l2ptr_dma)
 {
 	u64 val = 0;
 
@@ -1466,7 +1467,7 @@ static void arm_smmu_write_strtab_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 	val |= l2ptr_dma & STRTAB_L1_DESC_L2PTR_MASK;
 
 	/* The HW has 64 bit atomicity with stores to the L2 STE table */
-	WRITE_ONCE(*dst, cpu_to_le64(val));
+	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
 struct arm_smmu_ste_writer {
@@ -1678,9 +1679,8 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 	if (desc->l2ptr)
 		return 0;
 
-	desc->l2ptr = dmam_alloc_coherent(
-		smmu->dev, STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste),
-		&l2ptr_dma, GFP_KERNEL);
+	desc->l2ptr = dmam_alloc_coherent(smmu->dev, sizeof(*desc->l2ptr),
+					  &l2ptr_dma, GFP_KERNEL);
 	if (!desc->l2ptr) {
 		dev_err(smmu->dev,
 			"failed to allocate l2 stream table for SID %u\n",
@@ -1688,9 +1688,11 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_initial_stes(desc->l2ptr, STRTAB_NUM_L2_STES);
-	arm_smmu_write_strtab_l1_desc(&cfg->strtab[arm_smmu_strtab_l1_idx(sid)],
-				      l2ptr_dma);
+	arm_smmu_init_initial_stes(desc->l2ptr->stes, STRTAB_NUM_L2_STES);
+	arm_smmu_write_strtab_l1_desc(
+		(struct arm_smmu_strtab_l1 *)&cfg
+			->strtab[arm_smmu_strtab_l1_idx(sid)],
+		l2ptr_dma);
 	return 0;
 }
 
@@ -2449,7 +2451,7 @@ arm_smmu_get_step_for_sid(struct arm_smmu_device *smmu, u32 sid)
 	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
 		/* Two-level walk */
 		return &cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)]
-				.l2ptr[arm_smmu_strtab_l2_idx(sid)];
+				.l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
 	} else {
 		/* Simple linear lookup */
 		return (struct arm_smmu_ste *)&cfg
@@ -3608,7 +3610,7 @@ static int arm_smmu_init_strtab_2lvl(struct arm_smmu_device *smmu)
 			 ilog2(cfg->num_l1_ents * STRTAB_NUM_L2_STES),
 			 smmu->sid_bits);
 
-	l1size = cfg->num_l1_ents * (STRTAB_L1_DESC_DWORDS << 3);
+	l1size = cfg->num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
 	strtab = dmam_alloc_coherent(smmu->dev, l1size, &cfg->strtab_dma,
 				     GFP_KERNEL);
 	if (!strtab) {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 45ec88c9aa355f..3a8a459f899fd8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -204,7 +204,6 @@
  */
 #define STRTAB_SPLIT			8
 
-#define STRTAB_L1_DESC_DWORDS		1
 #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
 #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
 
@@ -215,6 +214,13 @@ struct arm_smmu_ste {
 };
 
 #define STRTAB_NUM_L2_STES		(1 << STRTAB_SPLIT)
+struct arm_smmu_strtab_l2 {
+	struct arm_smmu_ste stes[STRTAB_NUM_L2_STES];
+};
+
+struct arm_smmu_strtab_l1 {
+	__le64 l2ptr;
+};
 #define STRTAB_MAX_L1_ENTRIES		(1 << 17)
 
 static inline u32 arm_smmu_strtab_l1_idx(u32 sid)
@@ -597,7 +603,7 @@ struct arm_smmu_priq {
 
 /* High-level stream table and context descriptor structures */
 struct arm_smmu_strtab_l1_desc {
-	struct arm_smmu_ste		*l2ptr;
+	struct arm_smmu_strtab_l2	*l2ptr;
 };
 
 struct arm_smmu_ctx_desc {
-- 
2.46.0

