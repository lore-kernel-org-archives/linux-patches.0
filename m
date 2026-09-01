Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783EF48F824;
	Tue,  1 Sep 2026 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285019; cv=fail; b=BmfT3EomMdjnPcEsSRSNaunMcFmrgUhKUPzcBJ+OmZJj2sS638ro0vLjgOG0bGh12TuGIs6pk8J2A6Tlbmhv9i6RAfrKZmkf0yo25/RXB9+qqqogCXUvZ+qUTognx45JWh6M3XcByV9FsfC+D6pJ4YNtd1nDKYJ82DCT5B2aPWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285019; c=relaxed/simple;
	bh=TKIgLZCEAoHFOG4GN6s2gSl5ryIh2WKWFCmiADqWVDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Za4O6CBQQ/CYn41H6w4Ap5V2VwrUs3z0Cy3QfkmOkANw4+rUY4HbG0ZNuzeUU9xcBwyMvFrHctTK0GOVKCkrrtGOx9qgNi80d5pMF/YTRAIthlczrs4TFBDGHNCfI4wClvfH1yf+m38/tIxORyj/Vkt8iqF905Vw9REbwgLfAbo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=raYLVEn1; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="raYLVEn1"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evagFZJ6hsKIk/VDA//uR+fB2Q8rg4G1XxHGu+sXJTHuwXukYHI3n9K0u14JzyAFzgC3phyBM5CJ7XBjL4rrYWvOvRnLti4owBbwwzGKVJmaT9ZHo2rNoz0imngtRaicm0rZfJkB3uUNcyM8qSkRWAzM2LxpC94Pj6VrEuJ+ZHr9lgbqrxXPXv3OEivvM4P7n/H+0IAvMWbFvOn/1oJaaNy2jowCLCsFgba0NCxxDGUt4mvYpcsDvY3+BzKF//G0oeEdPhFcJyACkYC940+CNnssrBvpPOyAuvpj8KJIMg8NtoZOok/z8sWgNQ/1PPZTi3keLDoazY+1A5vrJqJb9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NeonVMUyaAH0FUdnlo20l4YXhyAF/eQCgzeP0P51qQk=;
 b=vW3xWm5fCXec1XKuZNeAxchSfWEV2mR0hoeE27IMzFO1OPpxkB/zToiRVCt2TNNzfV6bvavLxAHdoanMHkzDIb41BwhpjszsUuy5w9DG46wzhs22gP47w0L3VwlJn0BuEdd3I6n3/P8owAv4CXYtJx+CHSVmwiHK5Mdrx4Cmz0nZnh9z8QFMt6AjhUzvJ0YW/QPBop4KdA41aWgPyKyBQJw2t0v9HS6d1SZTJVUNUUSUry5fJNEM2ammDvbx/VfTCAI8I8W3b1Y7Vov7dzVotitVXF9mOr+DjRWC5+2cyC7ND+zEGi5PaL8yoWePpqV/mZah6imG8pFydVkLo1V2fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeonVMUyaAH0FUdnlo20l4YXhyAF/eQCgzeP0P51qQk=;
 b=raYLVEn1uj0q2hy7F6UIUdMJ/C5C8MEfEmj9dPtMTmtG6SU03MNSChezr8c+nRKz1lR9fwu2qQ+xgyp89kzoCYiGl3CCmyR+WBzfUAvjbVkbjH2hCTHke9QrR/8sSjjR0HpIksygt1CF357UpizWiH0GE5AMMegTcvBlGbGB2P/9rNk4791JpPX2s2q7fLzfEvgBjZ2P5FMRYZhClRPYmIoDWoJNAL5Kr1lZlG6nmhxNtkKLsvdlDHjl6ninXyhRj8BGMyAzoCLW2ntVBcXkj4fpONMUeZ5wV7cG8YvzUG9ZQO3Ft6BxXrT82ANJSNOxtXOa0I5yY2jH1ayWFBgdjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:04 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:04 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v5 8/9] iommu/arm-smmu-v3: Change how the tlbi describes the invalidation
Date: Tue,  1 Sep 2026 14:49:57 -0300
Message-ID: <8-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0267.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::22) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 079c0273-ce34-47a8-23f8-08df085171e8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|921020|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	VrJaLvnplbYfdHjORTYs85gZG8KdwK39rz/3R0xZJAoKpS0SGKBRAhHml02XW31LgXvFFUVFOIM74rYdGJjEaljjH0T+xDxLQDERUExlNl5YXKB72t+IgL++cuyQ+QzZij8HLy1fjIu5EsO/7jd5b1sT0ZK8DkV41o7X/dY37QbwIBKZ7g7eMvXNG08C30tyELj8Dg1W9/cmGUqfefNTK3UTjvscTjWkKHg/vGBAlcIdLfHX/XT2M/pfpMuhTnQUUOtpdlZpq6DF0Oxf2s3DOZDpO6l177ooKPDZButIdh0I6N6TntBclL+Jb9gDadozFT1pb7z3zQdWoqLpHIraL0lRjZbQnmY+Bjj2cMWPT9iuIjSDCfc37jCvCsQN/QYvUjQl4lyBhdKb/E+iLwJ63DDoi+Ww982fND6tMuJeIYLW0vfsZ0NZHRY9x97Wo08FOgeXPYWZg5vYCX5pQyHac5lLLuEt9BZA+B03ghphya1rrWUUdB54Q7jxMPfxsfkrigvBlfXrevNPonm8BRULvO4dljnlOnengSB+7jKf4vaqzyIG25VK7C7v5zIbNI63F0dHjPMnjqz5wTYmfOZpwi3AKpd5mXEDKhvusMIkxNbTram3TAQN4l1GdxotYPfvzphAKHOhmpqAt6edc4cxvuIhGJzHdTt8jkFUz2aojNjiOcT+nn9yyqcIrfrJRjmEhy87aPA8CCaf1AcsjvFQJA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(921020)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dZCaODHFMVv8L5QTABDf45eIXK5ZMY+pnTm7KoDvxvzaCjzbLEwGz8e3AtHW?=
 =?us-ascii?Q?OXFp1YL7bJ10PUlgbgoIPs9TbsbhqtsewqZcH/UdwhaWMRzC/HQvAuliUcsp?=
 =?us-ascii?Q?Nn5YeDMJ5M+r4YbrIS8u84dDo4m6IvIl05h8pV1WLYyDiC9nkBzThubOXKHc?=
 =?us-ascii?Q?15WNDLApKk0sHTBPRH4lY7LkuSSb23+WCzjDwtYNcwgfF31aDaOPlZyeCdtO?=
 =?us-ascii?Q?mshamHQBZn//DgV0zpnfJjnCW+mO3p5UOU+62LZpXe/emrRKRHVLcwUc0xQb?=
 =?us-ascii?Q?556b4sQJ7SBqbSRSsKn7j5qPM8sZZMqkO0fmlCpWkESnS9cgdXBUy2syu/iY?=
 =?us-ascii?Q?y8JkhUp2+AG986O7bWAfdcgQb+7+yiAORRK68Vf3AeWjPJi5vb7ajTWdSEs3?=
 =?us-ascii?Q?DKxVT7Qk2I6AFD/c8PLN6V5DWauw3Yn3xN8zSH46x19NBkSbaBC+/GYNcGzu?=
 =?us-ascii?Q?wyi0HXptaYpeR/fmptUeJKmJv8G7xlN+T9SH7ydjpgZ6CaLQTDg+mv/gHm7y?=
 =?us-ascii?Q?bPgbIsy+ROBD7ZIaD/oVoK2sI3PpdWxN8Axb0QAdpKw8POvd5rHmMi08wTAv?=
 =?us-ascii?Q?z0ufctr8oKHlPhRJOEBrKxXkn+jBg5/Xn4L4j6Z+8k0GPd3FzTiisattozCt?=
 =?us-ascii?Q?w+I6YJd9TlsNx2eaxkA1RdpLuAWkiLrcXQnfrna50J3aI54V3nYN+vmx2jn6?=
 =?us-ascii?Q?ZF2qrdbuwSRTU96pxOzlWNvxQ4s9d/+3AN766ZHzrw7M5VvIzeuL0S9PXmqX?=
 =?us-ascii?Q?mkgYs51Q7iReR7WuZZQsLkeQtA7KlvZvjJAtMR6m4Orn0GvO/iF1mvhFvLza?=
 =?us-ascii?Q?8xRt+bgRAn/TCULEDIi9R9LztkeM+vkG8pmFyvX6AIcNqGaFagL90l4S10uz?=
 =?us-ascii?Q?NWXYeT1wn+ydr5FH3gE8702shRr9PBpODYHTN7aCyC+N0uCw/s5IjlMfwXUx?=
 =?us-ascii?Q?7YbKD/OIxQeSzMVZ4kbEaQ2ELFALck7r1ckCz/Lq4m+L4L35SUj+h/0AJPtk?=
 =?us-ascii?Q?JK2Tf0f+85Z70FVWAdh4kXp4TkABEFEW1vZqKvtz/+FRWOLw7ZEXhP4Jb9Xd?=
 =?us-ascii?Q?/UpngGczJHCE4HdqJBE8n76DqCBN3JH+HkXMZcGIVTPmfvXikB4DXPooIOIw?=
 =?us-ascii?Q?NPzEIyHsJn06Tm8aMwo+imKW091O93sxXMTRe1R0DXChb3FD2zga/gJLmCN5?=
 =?us-ascii?Q?u90pLX8O+aKFUAw6f99uWFjbnjm0UBwh3c1W/Y7pqjYhFBg7DIuzkORrShuf?=
 =?us-ascii?Q?KxPFjzD2Ow1VBQbbhUMRFq/Wz0oSVVGPicy6oqLXGK8n+TFTT2ypbpDaTPwA?=
 =?us-ascii?Q?uNj94RlRNzqmFpHQW5J2TJ4ZC2sIioNt41mVklRni+XfJNRJcP8KBP5Yhky9?=
 =?us-ascii?Q?IgJ9mjr2F7H56NcV3k/WDyj5fq9nMDQFmX6wpeoapwCoMCbOj7o+K14/j23D?=
 =?us-ascii?Q?qrz6C7lKZv2Lg2r1jvovLFsPJ1PMPWUiyhoRV74HIDV9cJhKORC+x4vUeX0d?=
 =?us-ascii?Q?CSg5qyFycJSEO1uU9dj0DNkJmovbFwi7CXBZu2fXOwfA7pvCGYEBaMijUh4B?=
 =?us-ascii?Q?dVp/0zFgNps+Xuyp/JrgIRpNP8X01ZeWHE/ZwqyQW4mamA+nPopPSrUGC878?=
 =?us-ascii?Q?vARQePL90KLUssRmy4XQMf1R5Fh2tbOxcaTgY98waORnkNZLH6sVvYQJaZo7?=
 =?us-ascii?Q?hSV2DRt/tNS62KK0EZWnLesMYDDv3cUwlCy76OBYsC0tGjyt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 079c0273-ce34-47a8-23f8-08df085171e8
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:01.2202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ClU3t97Ri5IK3ug0xLhS1QoBhH3U6Ej73oxX/pdLSk7B8sG8QenpSZ7DLn1cDT7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

The RIL logic has long had a FIXME that there is not enough
information to properly compute the RIL. There is also subtly not
enough information to properly compute the single stride either.

Change tlbi to use the information format that iommupt is going to
use for ARM. This prepares the invalidation code to support iommupt
and fixes two small limitations with the current code.

iommupt is designed to accumulate all invalidation into a single
gather, then the iommu driver should issue a small number of commands
to execute the gather to control invalidation latency. This is in
contrast to io-pgtable-arm.c which generates many gather flushes and
direct walk cache flushes as it progresses.

To accommodate this the gather will accumulate "damage" in bitmaps,
one for leaf changes and one for table changes. This is enough
information for SMMUv3 to compute the proper stride for single
invalidation and to generate ideal hints for range invalidation.

Change the inner workings of the tlbi process to directly use this
new-style gather description with the idea that the iommupt
conversion will just direct assign the gather fields to the tlbi.

Rework the three places creating the tlbi to express their needs in
terms of the new bitmaps.

1) Simple iotlb invalidation always gets a single range of leaf
   levels, so it can set a single leaf bit

2) Walk invalidation is expected to clear the table and all the leaves it
   could contain. Set a single table bit and all the leaf bits.

   There is a weakness in the existing io-pgtable where it double
   invalidates the leaves, once through the arm_smmu_tlb_inv_walk() then
   again through the gather. Since these are separate operations they are
   not capped by the invalidation count limits and a single unmap may end
   up doing thousands of tlbi commands. Eventually converting to iommupt's
   gather only approach will correct this.

3) SVA invalidation has no idea what the MM did, so it will set all
   the bits in the bitmaps.

   This corrects another weakness where the RIL invalidation logic
   was generating hints assuming the #2 rules which isn't correct
   for SVA.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  29 ++-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 176 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  24 ++-
 3 files changed, 177 insertions(+), 52 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 47eba08bd1161f..07ba4e7910ab84 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -140,17 +140,34 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
 {
 	struct arm_smmu_domain *smmu_domain =
 		container_of(mn, struct arm_smmu_domain, mmu_notifier);
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = start,
+		.start = start,
+		.last = end - 1,
 		/*
-		 * The mm_types defines vm_end as the first byte after the end
-		 * address, different from IOMMU subsystem using the last
-		 * address of an address range.
+		 * No information comes from the mm, assume the worst case that
+		 * it changed every table level. The way this is hooked into the
+		 * mm is tricky, the range won't be expanded to include an
+		 * entire table level if one was removed like the iommu gather
+		 * does. Thus even if this is a 4k invalidation it may be
+		 * including any table level too.
 		 */
-		.size = end - start,
-		.iopte_size = PAGE_SIZE,
+		.table_levels_bitmap = 0xfe,
 	};
+	u8 pmd_lg2sz = (tgsz_lg2 - 3) * 1 + tgsz_lg2;
+
+	/*
+	 * If the size is small then we can infer the invalidation is PTE only
+	 * and set the PTE level only. Otherwise it could be some other
+	 * combination so just set them all. This allows RIL to use TTL=3 in
+	 * cases of PTE only changes. The mm must not try to partially
+	 * invalidate pmd/etc.
+	 */
+	if (end - start < BIT_U64(pmd_lg2sz))
+		tlbi.leaf_levels_bitmap = 1;
+	else
+		tlbi.leaf_levels_bitmap = 0xff;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b9efba3404c68b..b99229a5bbacca 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2397,8 +2397,8 @@ static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start = tlbi->iova >> inval_grain_shift;
-	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
+	page_start = tlbi->start >> inval_grain_shift;
+	page_end = tlbi->last >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2512,16 +2512,11 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 {
 	struct arm_smmu_cmd *cmd =
 		&tlbi->range.cmds[tlbi->range.num_cmds++];
-	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
-	u64 iova = ril->start_tg << tgsz_lg2;
+	u64 iova = ril->start_tg << tlbi->tgsz_lg2;
 	unsigned int num = ril->num - 1;
 
-	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
-	if (WARN_ON(tgsz_lg2 == 14 && ttl == 1))
-		ttl = 0;
-
 	/* Verify address alignment for the TTL hint */
-	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tgsz_lg2, ttl))
+	if (ttl && !arm_smmu_ttl_addr_aligned(iova, tlbi->tgsz_lg2, ttl))
 		ttl = 0;
 
 	/*
@@ -2529,9 +2524,8 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 	 * and causes CERROR_ILL. Single tg uses NUM=0, SCALE=0 with a TTL hint
 	 * to target only the exact leaf entry.
 	 *
-	 * For a single tg invalidation a 0 TTL can come from places like the
-	 * SVA path that don't have enough information to get a TTL, or as a
-	 * side of effect of the splitting.
+	 * For a single tg invalidation a 0 TTL can come as a side of effect of
+	 * the splitting.
 	 *
 	 * A single-TG invalidation cannot reach this point if it is part of a
 	 * CONT group, so it is safe to transform it into a single invalidation.
@@ -2542,14 +2536,83 @@ static void arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
 
 	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
 		       FIELD_PREP(CMDQ_TLBI_0_SCALE, ril->scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+				  !tlbi->table_levels_bitmap) |
 		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
 }
 
+static int arm_smmu_bitmap_to_level(u8 bitmap)
+{
+	return 3 - (int)__ffs(bitmap);
+}
+
 /*
- * Generate up to two range TLBI command payloads covering [iova, iova+size).
- * Sets use_full_inv if the range is too large to represent.
+ * Compute the TTL hint from leaf/table level bitmaps. 0 ttl means no hint
+ * invalidate all levels.
+ */
+static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
+					 u8 tgsz_lg2)
+{
+	int ttl;
+
+	if (leaf_bitmap) {
+		/* If TTL is used then only leaves at the TTL are invalidated */
+		if (!is_power_of_2(leaf_bitmap))
+			return 0;
+
+		ttl = arm_smmu_bitmap_to_level(leaf_bitmap);
+		if (table_bitmap) {
+			int table_ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+			/*
+			 * A RIL invalidation with !leaf_only clears out all
+			 * table levels above the leaf level ttl only.
+			 */
+			if (table_ttl > ttl)
+				return 0;
+		}
+	} else if (table_bitmap) {
+		/*
+		 * Table-only invalidation. Spec says:
+		 *  For operations with Leaf=0, invalidation of cached Table
+		 *  descriptors for the address and scope additionally occurs at
+		 *  levels between the start of the walk and the level before
+		 *  the last level given by TTL.
+		 * Choose a TTL hint that covers the only target table
+		 * descriptor levels.
+		 */
+		ttl = arm_smmu_bitmap_to_level(table_bitmap) + 1;
+
+		/*
+		 * 16K granule, ARM TTL=1 is reserved (SMMUv3 H.a Section
+		 * 4.4.1.1) if DS=0, avoid it always for table invalidations
+		 * since we don't know what instance this will be applied to
+		 * yet.
+		 */
+		if (tgsz_lg2 == 14 && ttl == 1)
+			return 0;
+	} else {
+		/* Both bitmaps zero is not allowed */
+		WARN_ON(true);
+		return 0;
+	}
+
+	/*
+	 * Assumes the page table is formed properly and does not trigger the
+	 * 16k TTL=1 condition for leaf-only unless DS is enabled.
+	 *
+	 * ARM level -1 never has a leaf so something has gone wrong. ARM Level
+	 * 0 cannot be hinted because ttl=0 means no-hint.
+	 */
+	if (WARN_ON(ttl < 0))
+		return 0;
+	return ttl;
+}
+
+/*
+ * Generate up to two range TLBI command payloads covering [start, last]. Sets
+ * use_full_inv if the range is too large to represent.
  *
  * Normally the first RIL is the largest representable span which does not
  * exceed the requested range. If necessary, the second RIL is the smallest
@@ -2565,21 +2628,14 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 				     bool single_ril)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
-	struct arm_smmu_ril_range first = { .start_tg = tlbi->iova >>
+	unsigned int ttl = arm_smmu_compute_ttl(
+		tlbi->leaf_levels_bitmap, tlbi->table_levels_bitmap, tgsz_lg2);
+	struct arm_smmu_ril_range first = { .start_tg = tlbi->start >>
 							tgsz_lg2 };
-	u64 last_tg = (tlbi->iova + tlbi->size - 1) >> tgsz_lg2;
+	u64 last_tg = tlbi->last >> tgsz_lg2;
 	u64 num_tg = last_tg - first.start_tg + 1;
 	u8 tg_enc = (tgsz_lg2 - 10) / 2;
 	struct arm_smmu_ril_range trail;
-	u8 ttl = 0;
-
-	/*
-	 * Determine what level the granule is at. For non-leaf, both
-	 * io-pgtable and SVA pass a nominal last-level granule because they
-	 * don't know what level(s) actually apply, so leave TTL=0.
-	 */
-	if (tlbi->leaf_only)
-		ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tgsz_lg2 - 3));
 
 	/*
 	 * The spec defines the invalidated range as:
@@ -2620,20 +2676,44 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 }
 
 /*
- * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Sets use_full_inv if too many commands would be needed
- * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
- * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * Compute the stride for non-RIL single-page invalidation. Returns the log2
+ * stride of the lowest affected level. Single invalidation removes all IOPTEs
+ * that contain the IOVA invalidated, and we can reliably assume that the
+ * architected page size and table sizes (not contiguous!) are reflected in the
+ * IOTLB. Thus if there is a 2M leaf entry we only need to issue a single IOTLB
+ * invalidation within that 2M IOVA.
+ */
+static u8 arm_smmu_tlbi_calc_stride(struct arm_smmu_tlbi *tlbi)
+{
+	u8 combined = tlbi->table_levels_bitmap | tlbi->leaf_levels_bitmap;
+	u8 tg_szlg2 = tlbi->tgsz_lg2;
+
+	if (WARN_ON(!combined))
+		return U8_MAX;
+	return (tg_szlg2 - 3) * __ffs(combined) + tg_szlg2;
+}
+
+/*
+ * One TLBI command per stride-sized entry. Sets use_full_inv if too many
+ * commands would be needed. The threshold is similar to MAX_DVM_OPS in
+ * arch/arm64/include/asm/tlbflush.h.
  */
 static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
-	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
+	u8 stride_lg2 = arm_smmu_tlbi_calc_stride(tlbi);
+	unsigned long num_ops;
 
+	if (stride_lg2 == U8_MAX) {
+		tlbi->single.use_full_inv = true;
+		return;
+	}
+	num_ops = (tlbi->last - tlbi->start + 1) >> stride_lg2;
 	if (!num_ops || num_ops > 512) {
 		tlbi->single.use_full_inv = true;
 		return;
 	}
 	tlbi->single.num = num_ops;
+	tlbi->single.stride_lg2 = stride_lg2;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2653,7 +2733,7 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
-	u64 iova = tlbi->iova;
+	u64 iova = tlbi->start;
 	unsigned int i;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
@@ -2678,9 +2758,10 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 	}
 
 	for (i = 0; i < tlbi->single.num; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF,
+					  !tlbi->table_levels_bitmap) |
 			       (iova & ~GENMASK_U64(11, 0));
-		iova += tlbi->iopte_size;
+		iova += BIT_U64(tlbi->single.stride_lg2);
 		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
 	}
 	return false;
@@ -2876,12 +2957,16 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
 				  size_t granule, void *cookie)
 {
 	struct arm_smmu_domain *smmu_domain = cookie;
+	u8 tgsz_lg2 = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = iova,
-		.size = size,
-		.iopte_size = 1 << smmu_domain->tgsz_lg2,
+		.start = iova,
+		.last = iova + size - 1,
 	};
+	u8 table_levels = BIT((ilog2(size) - tgsz_lg2) / (tgsz_lg2 - 3));
+
+	tlbi.table_levels_bitmap = table_levels;
+	tlbi.leaf_levels_bitmap = table_levels - 1;
 
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
@@ -4152,21 +4237,28 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
 		arm_smmu_tlb_inv_context(smmu_domain);
 }
 
+/*
+ * Called by io-pgtable-arm.c for each run of same pgsize leaf only
+ * invalidation. If it has to change to a different leaf level then it flushes
+ * the gather and starts a fresh one. Thus this always targets only a single
+ * leaf level.
+ */
 static void arm_smmu_iotlb_sync(struct iommu_domain *domain,
 				struct iommu_iotlb_gather *gather)
 {
 	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	unsigned int tg = smmu_domain->tgsz_lg2;
 	struct arm_smmu_tlbi tlbi = {
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
-		.iova = gather->start,
-		.size = gather->end - gather->start + 1,
-		.iopte_size = gather->pgsize,
-		.leaf_only = true,
+		.start = gather->start,
+		.last = gather->end,
 	};
 
-	if (!gather->pgsize)
+	if (WARN_ON(gather->pgsize < BIT(tg)))
 		return;
 
+	tlbi.leaf_levels_bitmap = BIT((ilog2(gather->pgsize) - tg) / (tg - 3));
+
 	arm_smmu_domain_tlbi(&tlbi, smmu_domain);
 }
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 09befe7b284fed..6582203eb7425f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -809,17 +809,31 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 }
 
 struct arm_smmu_tlbi {
-	unsigned long iova;
-	size_t size;
-	/* page or block size of the leaf iopte */
-	unsigned int iopte_size;
+	unsigned long start;
+	unsigned long last;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
 	bool leaf_only;
+	/*
+	 * Level bitmaps use iommupt numbering: bit 0 is the leaf-only level
+	 * (ARM level 3), bit 1 is the next level up (ARM level 2), etc. These
+	 * match the iommu_iotlb_gather.pt fields. Each set bit indicates a
+	 * change at that level. The contiguous hint has no effect on
+	 * invalidation processing because HW can ignore the hint.
+	 *
+	 * The pair selects the invalidation scope:
+	 *   table!=0, leaf==0 : walk cache only
+	 *   table==0, leaf!=0 : leaves only
+	 *   table!=0, leaf!=0 : walk cache + all leaves
+	 *   table==0, leaf==0 : illegal
+	 */
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 
 	struct {
 		bool use_full_inv;
 		u16 num;
+		u8 stride_lg2;
 	} single;
 
 	struct {
@@ -1188,6 +1202,8 @@ static inline void arm_smmu_domain_inv(struct arm_smmu_domain *smmu_domain)
 {
 	/* Prefilled for invalidate all */
 	struct arm_smmu_tlbi tlbi = {
+		.start = 0,
+		.last = ULONG_MAX,
 		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.single.use_full_inv = true,
 		.range.use_full_inv = true,
-- 
2.43.0

