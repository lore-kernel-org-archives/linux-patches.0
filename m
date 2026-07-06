Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010040.outbound.protection.outlook.com [52.101.56.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF366433BA8;
	Mon,  6 Jul 2026 16:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355226; cv=fail; b=FrbESHbEzNJNr87swiSxdKHQJ8sxjEU4Q1bb+aCd9WC4mzGZmrbac9Z2DEh+BdBUBCzuAf7BMtQOp4QqXzfY8yYaoKBskkjl12pYUbEX+iVwQfPxk22KR9uW4tHcCA1anqeMaQMLmel7kHWXdjT6eZKW4vWHdaTBP9mbJIk7SFU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355226; c=relaxed/simple;
	bh=sS0HQu9iszxwXdQrNLEyzpn0A8GGvs07eoROWEfmGZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TD5Qt6hc1dMJO74G7gCNFTUG03kooYJnMwjcCUmgnf/W6+UUfECwcx252F54opuqF3j1PIwaE3D1REcVgzEpHVJWuJERwuU+uq33+g7mRtjlCho/eUgRRAUGMrlSpnRhrF/ST3QDi77gFDrkgAxEFqgJ7tO8LDBL2wI8eFGzWek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IzyUG+Md; arc=fail smtp.client-ip=52.101.56.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IzyUG+Md"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LNkOeH6oCi8eXnm5VmlNMvbbC0P5tDHaymKm8O11LiytTt2RuAS9JT+DnCn39dvl6O2AvCqxf9KopWlE4JB+JgG2mKgZu3BoMtllqyRBtAO/SJQxUsyExwLV/HRTapV/L3oM/h+DMhzNq6HbjP2Y05RjpMRq1R/rAdHqImjWYVu+7yP7muc2spBa0juVpLupieBmLJgNtQJ1YpYT1fiwDRF8kJoMkizxF452RXWCiv6jFktZ6WFEJXzUch3gGLBmnxxc6rH6s3GBsAU8gBuG7dcDX5rIGL4+owjsSFv/5wAU5Bzu+ZdfaSwX6y5HiTxfgXUh+DUP6EbTvMNawqXNqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kV0QRwe1w98x1enYus7Kdk2VDvIH39/ggDTdcCCBlSY=;
 b=TIfrKZacwBqwgC5Dy+KPbqsu4K2Z83rZUfZ219l7uaYSdU8FyshkhDZhmvu9qGiUTajxYIfFbfBYeZahMwDG54kBp6gHlQqUprostacXfOUK0lsECNkXfM0zrpYF8cBxnB64TqhP5yth3TZL2Ul9E/3hsk1OS4OS+DvNAzURi5Iz0I2W5yPGXXzNc+AipSinSHSZabeL+II4+SdXXkW3+Fr1oBv+3V4u32bJpB5WjWU57dwjGgdUycmdKKoNMWsfTVLfjIMCA29LU5OF2pcPq4ZXwV2u7wV9oFnLPIf7xGD2gFBIhBeAchGdgEw0H4EDKkVr1Zv6DvUp1TK1KPuRxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kV0QRwe1w98x1enYus7Kdk2VDvIH39/ggDTdcCCBlSY=;
 b=IzyUG+MdmkkQQt3lbf4j2tXr3ltZvTtlfy5kS0w2gcF94b067lgS/o+9yKw6SmP0+oYQWsbLj9wpopp4efNGJibNsxlunaBwbfe31041Ml5AK3OqIJPzstUn0FBrSt+ctPBcE3a7x5IxwYObXQ6qycl1fsrnomlQrNg+thMPQOSwXt5AjgdFLPUVOZGrEvtGQyYKAVZ57YGGJtimXTum9hpxE2a7Xc23bsST4zTLR0Fq+v/3sYHa19gLdD/h6nhopJbXJ2JseCpdcttYKTwr/AnYB087Z4PTgug0KHuVjmb4dIf+kQ+oGnWI0d3uI+vieH+mV8Xpin3Xn+eVRIhEig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SN7PR12MB7956.namprd12.prod.outlook.com (2603:10b6:806:328::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:52 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
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
Subject: [PATCH v2 6/8] iommu/arm-smmu-v3: Populate the tlbi at the top of the call chain
Date: Mon,  6 Jul 2026 13:26:43 -0300
Message-ID: <6-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR04CA0056.namprd04.prod.outlook.com
 (2603:10b6:408:d4::30) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SN7PR12MB7956:EE_
X-MS-Office365-Filtering-Correlation-Id: 56a679ed-cff2-4cd3-e0d4-08dedb7b622b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	ZJxgVMiezHJsevCPjQU1rzO1yFj+dZlmGGucBYh3xcWxJ7Cbm6mlaCw2Oj+esQJQErq2VR6gMCXNsHv0p5m5NUc1xGXlRHZruIM0cYHJ3ClZSs31UUxC6Uk8lhZPuvrynQS9ZBnmkVxVu23okBvt1d+SoFldvDvw6nJPDu46qyMwvWBydEeXqkBC5F1i3V094yOe+1o8aTGBJjfmqzcg3PqxH6iAHQz4GSGceSVgBFwR4ZEyWUNPryD0VnV9XzWHdQJFbjmMdHEInPSljO+Te9oGBUHq3x130GrS1j+dlHIycnDPGXsRyP6ZZvnxgX8vywpP3JlBvhQNAo6ZbCB0wdZSkOGbCrqbbEj1eBBagv2wMhtHoKodGB4wVS8pxGj+lfd/48VoAqGnlnHwbaP3CCk5ylabQE3yeJaZJFto3XPM6l6JF1BJm6Dj2WQwc8sLOCxLrrdIgTIw2H8/jgbhLP1jGNtIqQ6KkWngjkuQzFsJJ6RXwPb+UWDzliCQXl5sS1tMPyPNtlfkTnHm3zDQj9sFEDWkbIbPtSG+MzE+QlIofZVNnCxSGYqaWwazj8rWKx9J+tynDFZU1Ozdr08oBOkYddVBkJkgfB6ElA09hDw9ry/0mylky2slAXfiKObtaRDhE6lE9i9kExuDjUmNqu6BLowt5FpF2GGTfIDagLU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5DsOxSCkvJd8YOzLJ614/NBQUTyUNuG4dF/4ZhM32Ogyclj3RNppz8KAM8sM?=
 =?us-ascii?Q?6JHHzrOt2X1nNu/eMAbLDZZJV6PD69txAkAuO2826qCGacqg1OsgtoXA5a5V?=
 =?us-ascii?Q?P3mu46F2tEPQLQbi3XDIaLcW3hZtqU2vX2SMgWvHZ2tPm1A/KrjYb0xxG4so?=
 =?us-ascii?Q?1MITukFx6niiShDcQ5Cpu/aX01FmpDfxW8Zhk4s0lK1rDIFlcVcJIFlhrct0?=
 =?us-ascii?Q?GNtgNJ3HhlGMZIkRpviiM9r+1aYjujRUwy59qEtafzZxOB8KwjyA0ycvRVlC?=
 =?us-ascii?Q?E17b9+flSL6dejFDfoOaG8c3nUqkGheDqKgVq3WkGgOFin0tQbHGohJoNZiP?=
 =?us-ascii?Q?MI+NLY+VqqLlQTs9vgq8lmoQE3r4execxCKcklPPNWxSJJ5JSG2FloyR04Qc?=
 =?us-ascii?Q?KRKsClrTwrVoykDPubwWsfKEDBWDM/fXjkCeApxbZLrXXXj/Z8JRlPUkJQhQ?=
 =?us-ascii?Q?2evTT4BbVdR6CEic2z6NJftIP0/KHkQaPs3tiT3roD6BoPL4XI0kh8LcIQkD?=
 =?us-ascii?Q?i48R47yFvfxzRkkM3nSMK9JBapLcvun9OPRE2yFE6Fz01+K8vlp/3TAzKYKa?=
 =?us-ascii?Q?FwleX9H41H/HPEkvkhkcJzT0ZPFMtdiXjM88EcFFPkdPzNa6V2Aw/7eQrPBS?=
 =?us-ascii?Q?CnEZfu2fweX9xgWhnKrjHzOqcgg7RyQm+OBUnlRcQSKvWxHTeUPQn7u7Z/do?=
 =?us-ascii?Q?eWpqTviVDQCcLuVj9/UiKgPQLatycTRM3BcDoJ0dw0ugL6dquVOfcCDVCjE5?=
 =?us-ascii?Q?BG4TjT3+HLdJVTl4kdcTo729DHqMRaHakhD+98AAlj4WgHH9G//qeOegc5HM?=
 =?us-ascii?Q?barQzh+JboiMZcRpDslEvBIBvEBs9aSUqTujVA0T0ROqoc30PdPwYoiZkGWm?=
 =?us-ascii?Q?ArsHqdLooS4N+LnPoXp2OwPtIBFMtLRQu7WfAtWfWSqmc4zv41XudKGP2ejj?=
 =?us-ascii?Q?eDwWQtb9dPpvO8Eo+UC26pkxSKYsqMfeRT/1h3gZGFtZG/T39q3dV+F2zE+T?=
 =?us-ascii?Q?EApjS/TPgo7S4TU8EK5Eqy3wo1Me7gU9nhbkUnCenshNOQWY8DUoUnGwWkJx?=
 =?us-ascii?Q?f8sLR5oeLT64g6j263biXtpgsGa81iNEV+c91p0DsrrdWSC7uyWlnlBJaIws?=
 =?us-ascii?Q?KQuOfep7a7Xlv3ZMPsTZpRnKGH2Tyl3QOzhs0fjGw8E5ffdY79xke0wEkwiM?=
 =?us-ascii?Q?ZtW4NoQHJbqq9duMoIiDvqX1KP7A7+m7mLmRFiFLvGOLKH3/BPHS3Jd2DpaB?=
 =?us-ascii?Q?gJ1jQmnwU4loytHz1dpI1ADrwfKk2I5CdgnIMisurZ1eQy9FgwSe3onvuFee?=
 =?us-ascii?Q?vNwCoZH6ugzoa53+bBWP1ulCvRIPjW6cyPUKPsnTzsBnIWFqgziM5bbSL+Ii?=
 =?us-ascii?Q?a9L8uKGtSNhsLOnL9tQ8xulnVqFUBPxzvIavLmW2HV/ScdrVesdQDIeHHEoo?=
 =?us-ascii?Q?zHYhX1LbR9Z4KleC3XY98yWAQNvenqSzffCQ40SqaAY6r0B1Qyv3yh3E6s+f?=
 =?us-ascii?Q?p6cM4W2TAeQuu3LqAJ8si0SORNb0Fu/vEqg6Y6SQqZnZrd7r9gIZXlobgi5D?=
 =?us-ascii?Q?ijQX00fz4vRiiOHCRSjCQ2UPo7jKBbP6n2DyQSJy+jh8PrakGnX/RjUGSGsl?=
 =?us-ascii?Q?WvPnylnKL3hBqv2TqvZ+KOZ+zNSSpGg1RlR3AjdnFgO8y0EF/DYd0XWKwG8/?=
 =?us-ascii?Q?3cA6bubyemhamOunvtm3mgZXxt2Rd3eEcMj6PhfiDqAKRvtJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56a679ed-cff2-4cd3-e0d4-08dedb7b622b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:51.0058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9kndz8F68jeRQIDJMz0XLYF+U6arlItX6v4D8s/w6JFl/LnOpuZTXDmd8fZZ/k+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7956

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
index 5d4dde3d1cfe87..e6001913e2b043 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -139,16 +139,19 @@ static void arm_smmu_mm_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
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
index fbe3e5dc42f964..2e477f15080148 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2661,25 +2661,12 @@ static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
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
@@ -2709,14 +2696,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2727,10 +2714,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2750,8 +2737,14 @@ static void arm_smmu_tlb_inv_walk(unsigned long iova, size_t size,
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
@@ -4018,14 +4011,18 @@ static void arm_smmu_flush_iotlb_all(struct iommu_domain *domain)
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
index 9d262ef6076225..5f97d1a63ebbfd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1169,13 +1169,18 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
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

