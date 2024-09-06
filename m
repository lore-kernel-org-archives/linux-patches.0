Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE8D1CBE83;
	Fri,  6 Sep 2024 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725637688; cv=fail; b=YdPKcgt0WOqFM7esGlSqlXbyEgLs55Zx33u/EWx86/FFtuKh37qdmBc5e5HlwVBuGkPKmvrwlC8jBvg8IFNbq4LpdvUzphHBu+3HZk0PlqIPRv0lxjaFwTYrBodSXkT+8zl2zsa+K7xE02q93H1ERwEZrtTrtfsnXyYUhw2QXxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725637688; c=relaxed/simple;
	bh=ljwcWC0ZP+6djJeCmqhfQMN8x8PjrX2FGgnYrbR6vEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gA/soFkuXPZz2dxyXBNHAFjVuFEkPpzzE8e1oQtytw2VkTPWJFvrpta3fbBqewLM4O34LrR84sEtNOzN9of6XGz/oqz42kyBtUM0B3PcLlBHigL7i+iPTDApY0muti3hqOrW38xW6K05aRG7uLU2stMxems+Nu4+IxG2gtcvtnU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rvWnm94V; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rvWnm94V"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rddvEnZG/utWjKEB2P4OOgxW3xEvs9eIA+NzGelv8o4V16w/iPosfpqF89grZwv5fJjx99ic+4FEUswHf7EXVV2iRCVQtkDnNhlSlnltSHltm8/PSpYOFlasU/lRKT5/OBOPet4OxJtDMA6MajaFpDIl3vehgN2wBVp8d0aB4YXwiWqIGlyZV2wNlC4PJsXk9wsxmtWZ6tae0iOl0PcC9YwwrEgV/56nIGPJcKTaqtWygbIzYw2HK96Ag4Ejhc8YjzdlzlG/dSs5VDCXaWrMVwOVIPCiwLKsAWrvTmnhvuyUUybvvYGXuAqUi4pkTBQQc7MVAlkB4zIL0lmvaiG2Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Iew0CgRP/kyNnXTBtf0n1fqA4yCeeQwjgKjKrVeDomc=;
 b=IZgx8hwCmMVUv5+7wrqDl1AYfKtIYiItCDjRFKP29XEEqzYRBRkpxe0CwjMFNjbZetZvU099WWTWeV64oVQVlhdVK/GMfDz1c3VhcFxV7RL9NoHUb45kecX1abg2GkT+2GYIOfUT1iBd8yvKSxX1bMF7D0Fmak1H5OM5NDzNNi6NkdyB9E2w7758ytgOLONIxuJWv94ht+TP0NufkMh5VkXuGZfBaxCNgRu3CbcekM0AisOLTNQ+QQ9ZVGPGNRYQwpbJ0XdjIpJL6rdl4DJE5Kj7+mTqqn2UGnyOCwMKXcWkLxP/ytQYmmGwW52rLXD10HcJQToNFaK4JgYFCJOFsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Iew0CgRP/kyNnXTBtf0n1fqA4yCeeQwjgKjKrVeDomc=;
 b=rvWnm94VdiwaG8LgZXslQqCrCsWRWNJzHWH7OBu9MHI5zmRhikGC2XkwoqZ1fZFYlsLl+TqzAHT3VO1zkXg4waZhVGh6ZoOVbL3BLJQgLXNWTF81D6PtR2d5uNVdjerO5C7Z7INevz9TNFt94x5tK1wWeuXoTC1zdr1iaNVaBDkfPayAI/mey/7DCNfCgevlVi1sYTfdSWcDKDCceETiQne/lZBaIolh1zB5+hcU3Q8rMuRomqSiCr248L9nJhlp2ZjaM/+GIb2zfFkKDfCiu0pjGwHTzTkFa3eqa0U6zE9atC40ZsWpQ/tPM+in6z5cld2cTth2hB+RpRfm4c31Vw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6792.namprd12.prod.outlook.com (2603:10b6:806:267::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Fri, 6 Sep
 2024 15:47:57 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 15:47:57 +0000
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
Subject: [PATCH v4 6/8] iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
Date: Fri,  6 Sep 2024 12:47:53 -0300
Message-ID: <6-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <0-v4-6416877274e1+1af-smmuv3_tidy_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:208:52c::31) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 19934ae8-1a91-4e47-988a-08dcce8b4710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1dvzezGSddsP8DN3bh73yQQNUCiRb9ZB9ZFeQ0TCpTp+jH6cBvm871p2uO/U?=
 =?us-ascii?Q?QU4YFS9O3CRREtIiZhW/xvyD40UxK+yCrQ81spY38jkk4RhUszxAPrhdgb5M?=
 =?us-ascii?Q?00RoxpeHTfh2lEFNSnr4D/hBoc1I3eGXThMT4T5I7pRC6GvXVAnlMAMu6eiU?=
 =?us-ascii?Q?J0CTGcDc1+BWIQx3AjPfcwhG3uk+er4mGHofDfS+mTGFe8+PUoL4tMPvm3V5?=
 =?us-ascii?Q?xAsY2oCdtK1tgvuv5jb+DGAhWnUQcj+DwSQv24IOGBvut2ZGS9Lh4R5ApYDk?=
 =?us-ascii?Q?feALdBN1+z2Do0gNdtlNVunOwfRAPDCgHBHlxXwWxVHM+p123KFPfExtM2Yd?=
 =?us-ascii?Q?YIk0MJfPNMeCymd57DQ//NpjnUgohcdxgL/bj2HHsrjeZSR/hGxE4xbV/Bgr?=
 =?us-ascii?Q?QFOAzEBROGwSBFE6YCW3Y6HLIzMvofun1K/V0PIc/XLFNe+AlOXPvWH+lhmd?=
 =?us-ascii?Q?r7YAgkY3SMxv6hshaSngKEzVlLthTv6OZlROMOsRle4yrM6giaKQZxnzLdAB?=
 =?us-ascii?Q?xre4McVhhtglloa1zPzjW9h/0X94Tgikin3yQHSrrBtyCPU/Kma/NpOzCFB0?=
 =?us-ascii?Q?xa32obQVn1GZz/xY8qS5XK/PPg83JCutBqWHlgK1qXJubWOjYqCC+rKAzOPQ?=
 =?us-ascii?Q?6fCZzq7VFkRKHPbIp5OA5IJPP9pnk4gJXf7SDMO8lQyV01BUDQfCKoM7Khl/?=
 =?us-ascii?Q?NvvhE5W0+4z4lopHHC1fCVpc/EwQOLqIm241lesGjv3ljVGycDNDLG6akOG/?=
 =?us-ascii?Q?Klk08zd1GU6hSVnuVRDOvR//Bgo+a/g1WZHwtWJq8Z3V9Mfve7bLcRv3DS1C?=
 =?us-ascii?Q?+kNaPQg+h3Qp4CYFkLAEf+l+4+Effs8NqMGiPLBB/kdrg19AiuhM4MzzThYN?=
 =?us-ascii?Q?nlXjPW3AFw3d9rxHfOgAQtVecxUx5IwURwCW62o5UUuHP0ukhHbHEn+6D4TU?=
 =?us-ascii?Q?vsIx/6I6XyQBanbf8WNvL3w7JzIKD3e5NEC3Xz4dTqG21u2klcBrmnzG+RCp?=
 =?us-ascii?Q?ek9ku7KZEA6QZc5Nrm51Uptyon0ZDtoiXUaosmGwfhpFZcZXG4pAfsvB3371?=
 =?us-ascii?Q?w7QwLHKzIQzumvJkKM2X4y//4EjIK5xYx1wVvaes0Cq0yn8DMB22RXdIMRQ/?=
 =?us-ascii?Q?MY0A2gzDeFm+jNpI/2FuZGyGPOB0tDN0E2TrFYKBwZhkHTmOUEFZ15Yt/6ql?=
 =?us-ascii?Q?ruOUQU9NvFsXlrCE5r1CBWLlftav17uX5qe8ES9hy/ryC9CTYKBkocAZ5l88?=
 =?us-ascii?Q?kBvM4p38WNaDDcyxQKhRKLtDhQav2+QqjU4jyHboxhN1hboDOaneY49zhAT6?=
 =?us-ascii?Q?FpjZ1NmeIf/HuP5XAAAxPgzuPJkDSby6RrnSC7drN/CTmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cs7c3MkCrq3D4rRHzI1GK4nhDTuR9ygljoGs565b71ofLxcOkceyc6t1GX42?=
 =?us-ascii?Q?viNazychRkbgqFIbjjnZw4UzQXA5pFx9jY6TJQT1T2jwXJca0d7fqYsnEsJM?=
 =?us-ascii?Q?KjyhCS0P2IXImy+fN3WfwJABxGPsJeMirMVlEx0YbogWdHSf6l7FE+xtIwU+?=
 =?us-ascii?Q?V3F4WkA7TqrPm0YKd1ES5OJWpwfjpZ6pTPmdUUZiB4b0UXfStqCzWrzRi427?=
 =?us-ascii?Q?UpQS4GAYhG2kYdFGsmoBOuQbd0AohWjMj7S5wtq3eDIKBPeJ/0pe/cxFpV4R?=
 =?us-ascii?Q?5lEmmoWRQr0W3TUAnyTwiKmjV51S5419c1cNI8uG+podDOK+W2tLVAAYN0Rj?=
 =?us-ascii?Q?pRpz3do93ckEtafKxz8HIZkBn2uWycn9WNCl4qDhsST/RH3n4syuxlrnYGpv?=
 =?us-ascii?Q?eCk23RSYrdCFDoUOadpr13mdOHyNLQ/SnzVvdXClDLpJRWnoo82beWE8WFua?=
 =?us-ascii?Q?caOL2UcAUFIa6maRKJzJbelvornpXevWNYTxC8hdU0sHi6TExlbb3kq33Jkp?=
 =?us-ascii?Q?jdv2ULY/xyXHXnQ4640uxXq0wch1ueyNtxFGUTqXLG8H4ent6Z26XkaVGB9V?=
 =?us-ascii?Q?x7cgg0DkHIkoPN4/3UiPG9z9zzgazSEUk7U6pEY/Iga6JJ0bBRJAqJerTqDv?=
 =?us-ascii?Q?Uif9FW2kMJAmPzZYshv3j63af2op7FUEuGRUPvGc487TH0zXu0u1X5QP+HkG?=
 =?us-ascii?Q?u6NZmTdgHkyysCZ+CEjZhLsyKF9dw2Yjwo5yDrOmShtIZvPLTCdNgAQkRAPA?=
 =?us-ascii?Q?699CHX4tKgDgS//qfWre5CnQg2z/bYwMjv/E7oOkLD1utvMgmMTn+T1/dRjd?=
 =?us-ascii?Q?uwAWBT1ktnFud8/oAn0d9T7MRfFWrSnIu+37nWmg6CF9L3knWkM9AyKiYVL7?=
 =?us-ascii?Q?SUb5AaZFvavrZhtcaGisLY3khDXSrvOrjsEuVyp8jzyz0y+Sk/iIUCcTj83Q?=
 =?us-ascii?Q?aRdY3aMzH3lyThdFEjzQLBoP/rwZpWzqLDkQ1OrKcblPoLYUTkY+HJNEWihh?=
 =?us-ascii?Q?VSoJ6B5NV14xmuxl8JOudUzonD/kt1EKYkTXCHBVOb9aas6f/hiSDcmz5GLp?=
 =?us-ascii?Q?jHsF6sxUtC5xo4f3rg0rcVJZeLsvXBH+P6hIMU6VTbOoNCmNavjmkfnU+26g?=
 =?us-ascii?Q?s8GBQbI5RxfxOj2HxUb6xah8kHW3eqpvsxlubIdJfA2xbZJqb/olkl11NkG6?=
 =?us-ascii?Q?VcfwPbmJ4UjSvUS+iYV4AiF3o5aq9SanjPAuk1XrfxKsRuUCAG+CR7PUR4nU?=
 =?us-ascii?Q?0hS76Bxvkbh2/+vUFS49yKnQnXVlmLwtB8DZTw/P9Nb9+j6ebufRTmzICGjR?=
 =?us-ascii?Q?oqIxRyhpR/j/lSTIQBJFphVlystpwiCI/VZb/1EGNDZHF9dMhlHRGDHEzZlq?=
 =?us-ascii?Q?FR6neBMv2mxU0ASBNlxQEer8S/o19xJP9HE6uXj1L3J/g/HX1DnNA0M0KoJd?=
 =?us-ascii?Q?n5bfEw/1vt1j7bOzbFbEiT4RTLsqX7O4RcL/2y43/I1XwikYq65zU6wAdPc6?=
 =?us-ascii?Q?QU3dmjTeCdPF/DIH9TEV6wo3bhA4HR6uODWqph2iXmCienboTEKiWqv5trOu?=
 =?us-ascii?Q?ca7Nf5hHdWKRMJKOLjjNOrqVj9Sqy1jTX7Dn3nCT?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19934ae8-1a91-4e47-988a-08dcce8b4710
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 15:47:56.9115
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZTfoGI65HmjunT3tTUSReZEjcy5IY1GYHMVQk2MUF6yjRnLhAiDkdcHSHb3dzzB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6792

The top of the 2 level CD table is (at most) 1024 entries big, and two
high order allocations are required. One of __le64 which is programmed
into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
CPU pointer (16k).

There are two copies of the l2ptr_dma, one is stored in the struct
arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
use. Instead of storing two copies just decode the value from the __le64.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 42 +++++++++------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 18 insertions(+), 25 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c69d50e39b21eb..3c33ebffbe62de 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1217,31 +1217,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
 	arm_smmu_cmdq_batch_submit(smmu, &cmds);
 }
 
-static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
-					struct arm_smmu_l1_ctx_desc *l1_desc)
+static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
 {
-	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
-
-	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
-					    &l1_desc->l2ptr_dma, GFP_KERNEL);
-	if (!l1_desc->l2ptr) {
-		dev_warn(smmu->dev,
-			 "failed to allocate context descriptor table\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static void arm_smmu_write_cd_l1_desc(__le64 *dst,
-				      struct arm_smmu_l1_ctx_desc *l1_desc)
-{
-	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
-		  CTXDESC_L1_DESC_V;
+	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
 
 	/* The HW has 64 bit atomicity with stores to the L2 CD table */
 	WRITE_ONCE(*dst, cpu_to_le64(val));
 }
 
+static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
+{
+	return le64_to_cpu(*src) & CTXDESC_L1_DESC_L2PTR_MASK;
+}
+
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid)
 {
@@ -1281,13 +1269,18 @@ static struct arm_smmu_cd *arm_smmu_alloc_cd_ptr(struct arm_smmu_master *master,
 
 		l1_desc = &cd_table->l1_desc[idx];
 		if (!l1_desc->l2ptr) {
-			__le64 *l1ptr;
+			dma_addr_t l2ptr_dma;
+			size_t size;
 
-			if (arm_smmu_alloc_cd_leaf_table(smmu, l1_desc))
+			size = CTXDESC_L2_ENTRIES * sizeof(struct arm_smmu_cd);
+			l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
+							    &l2ptr_dma,
+							    GFP_KERNEL);
+			if (!l1_desc->l2ptr)
 				return NULL;
 
-			l1ptr = cd_table->cdtab + idx * CTXDESC_L1_DESC_DWORDS;
-			arm_smmu_write_cd_l1_desc(l1ptr, l1_desc);
+			arm_smmu_write_cd_l1_desc(&cd_table->cdtab[idx],
+						  l2ptr_dma);
 			/* An invalid L1CD can be cached */
 			arm_smmu_sync_cd(master, ssid, false);
 		}
@@ -1480,7 +1473,8 @@ static void arm_smmu_free_cd_tables(struct arm_smmu_master *master)
 
 			dma_free_coherent(smmu->dev, size,
 					  cd_table->l1_desc[i].l2ptr,
-					  cd_table->l1_desc[i].l2ptr_dma);
+					  arm_smmu_cd_l1_get_desc(
+						  &cd_table->cdtab[i]));
 		}
 		kfree(cd_table->l1_desc);
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 33a8bee1b82e3b..8b5628771b9671 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -619,7 +619,6 @@ struct arm_smmu_ctx_desc {
 
 struct arm_smmu_l1_ctx_desc {
 	struct arm_smmu_cd		*l2ptr;
-	dma_addr_t			l2ptr_dma;
 };
 
 struct arm_smmu_ctx_desc_cfg {
-- 
2.46.0

