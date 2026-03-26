Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010066.outbound.protection.outlook.com [52.101.46.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBDB38CFFF;
	Thu, 26 Mar 2026 19:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774553441; cv=fail; b=o5VeDxLDc2ALHZK1Z9eQeAJ1CAHCDb3mYgWsyw6HC5wwrAvoFeuFHFqGI8ut+RiBbPyl77h+pS51OMR+yZ68XcPix+h7hJbjdtNnL0wJ0KR/xSWerq9btUg0Sbg57TLqNF1gku58O7yfex7LuuhurAXW4+Utwq5bbGnQwNxXuGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774553441; c=relaxed/simple;
	bh=75JQiVKtUltp8/W0yVwFDx4cAfUFHeWl6hehCvOfelE=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=RcymsbTe6XQO3uAo+aBbsSJ17XutttF/tV2Fgr4CSOmSqzFqHLOCWJ3BuJklf4EfkpW3AYh9ShfGYAXY78YQutuOwzBSl5TXGyM3myqauSoFQVeWLeJpFEGsoW4ork5FuJz3Ro5qIJT2Je4kc7tCMRt5KJQ6x+gJf89g526ZkNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=h2uoVHrf; arc=fail smtp.client-ip=52.101.46.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h2uoVHrf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QEYdeqzHct/od3vzEjR8phPQ3vI5US4MtnhIR1Q0AKa+JfCxmK/ipKYbRodZR4kHA/fAJHLHJ8EP2UE6rq1p0UDQiczrBAy5qMQrgeFR8RSciL+8djmZsbK1fRCQIz6nsvHZtEbnFTfkQQ2eO+Qz8tjhLCR5Ak54gNQ243NBhrHd9LxE+uMgeGJw4EtcqrpwwVNfCsnAGgdU1Q2AkGDG+/SIX6iv3eS6dMExA5CMF06uYCtwVDbwSSb0akIqJbjItFrO1WLlXnPp+dDNV/V/yJVAHjwG3WrsZY1PnfKdVmtleTMn2hevmJKGw9RC2zJMt/t/FdzSDkIhkLCl+50ukw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HYn2QjFbRxYqVdNQGGzC1zEuZL34pRdVWqsPNIkJ68=;
 b=WzJVwXSJsBPnXgFIkUHCSgOVUOAYnQ1omZzcXVpE/iygM9kbegqQ4jhjXpVjb6GXPvmk3z7NQIpPgMmhCKUC4rVTWiIYdGGj1taT3trO97STygYESLnm99rheE662JnCoF0lw2PRq71OB777FX+lA/ZDMMwSpUcPEm9docuz3MqHePAZubj1MBMeFRjprZWbegaQ5B8C7/FPP7+R5bu5cd9/7sR+fabi6+tunMNLTQCYea3aYLi2KJ/Pd4ZmItA7LFNAGWCm+oe9t9/3zzr3ZSxrw0Lu3+8soWwLv6yMZBHdUzY7mYM1r28nlp+55bhWhQhgSgaNKSquOsXpmA/qYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HYn2QjFbRxYqVdNQGGzC1zEuZL34pRdVWqsPNIkJ68=;
 b=h2uoVHrfb3HsTl1h4397TkK5UYRxzAcjD+TTswV3bI7mJzAf0w8k3LxtrOIUdgEn6BzjFeDRcXglz8a+H1INjQ7RqKzHLpLTsbkwZ06mbWr/uxf/PdhcUHDQPufkA8Gljh7jt7PWm6KSE2+4uB+zgfAXttkn0DYN16xKGQIE7ARA9DwrAJnCq+TdoCISUfaaaA0u5Y5LMzmNFID8tLaPbGErda3TKkKnUHpt8Rf+FM3FrYlNQOhdOVasSbEikzjJbKAvrXHGPNJ3/lHmMvLiivIFJkQHCUh86AfzYAjcKLvfpKTzcqNfdMemyxnkEKwEvdgQeKjUezh2z8zuGvQqfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by DS7PR12MB9043.namprd12.prod.outlook.com (2603:10b6:8:db::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.8; Thu, 26 Mar 2026 19:30:33 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%6]) with mapi id 15.20.9745.019; Thu, 26 Mar 2026
 19:30:33 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
Subject: [PATCH] iommu/dma: Always allow DMA-FQ when iommupt provides the iommu_domain
Date: Thu, 26 Mar 2026 16:30:32 -0300
Message-ID: <0-v1-9901ec033f96+3cc9-iommupt_fq_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN0PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:208:52f::21) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|DS7PR12MB9043:EE_
X-MS-Office365-Filtering-Correlation-Id: 94ce8636-575f-44b9-ec10-08de8b6e2624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	o/SV464ZVQ4U3/wmYRUyWP9PdIGmLinNUPG2oIG+LRY+nUl/DwpvWmYGb1iG3SDl35bLUpPR1ARDFWN3JswMV3+4dvyI30sBVTOWGoW0hA7lkQbSpCZyBYq+GC13YeVwPV1LzpmWbZ09RvUCdIUDw+n4Lsj52MttSnmXktsXj2jWVMP+xZUANc7KWt3LRdXrR3kZZDDw/aL4ac415IxZJBNTwUGnh07uWQ5wcyh049rs3kkStJKJ3LBznXQr59iKUrLGvHh2vgBe0nHaA+oCcpyT2mJEyfoCQYER97lP4nDjh9bPzx/xjqBwN33j7M+5LLKpXwz2fX7HbL65rMg5DNqgn5lK3cMk/frB/xAEvIfWH3VlDqcgFztYZFaErIJhrjPiS9SuTbbZSEbIG3NJWFc9jx9jyhdwJrYV8iQ9U0isQxPxp2GXL+zWhs9/wpB3NLOk69IouS/rx7gNrKFh73CBDowkxeUhRFiyXIhBBMM8NVkVcQGURe4nK369N4qCEJ57ULzuN6kP1wNS/kCqYx/j7z3UOFwSlg+PRK9dmgsOqnnflDbxemQrdG7Kk0zG2nhalbHpdomfO7R8z0OsTR85y0rdYRdbQMIuLtftfGkfZsHA7i+pHKf+hQZuqVSImVj52odZAU9okhwA/sVBhBLnO5xA9n8Fyx2WUdwpfstrlkXLArLe43bjeAamM85ArBNjLqOlvsMS44mYoaE342DYPns9QXf4Hm5uTOkodm8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?V5EqGPkhNFzUJlhSYELv+zUBxC5URj24ozPLYESyTd6J3gPJ2vkyd7KHe/zs?=
 =?us-ascii?Q?Hn7W2SbZg/iDIiH7JaV8P9PLXblBq1AUDmsnzf1aMKKCgsw+M1kf4s9F3n7/?=
 =?us-ascii?Q?I+mvxKX8vJyk0U4edAaeDsGdYu+WwuPCWkYFAj7oxeYG7Q1W4GPrqiape0oH?=
 =?us-ascii?Q?CsWfGDhDuwBGiMOV79AsrZ7oHNf7QNsTgTrzNrgej4LmDyTdQkhoZEbsalIL?=
 =?us-ascii?Q?mBY6Zc/oLYRU3sGm14vam0rFlr4T3y5kI/SupHIZcrv63bz/5S5Eu+vjb5AR?=
 =?us-ascii?Q?Jza/BcbFvYLnx2LchQtjo2qI2mYnS/iaoWYQYFu4gHS+sizSiG8WwYVnDuj3?=
 =?us-ascii?Q?FP/hxepc7ho3TcaDSgFOOmJEbP3HzJJPyOKmqkklf5RMpNA7T46Wz3KpfoyC?=
 =?us-ascii?Q?7j3nj+wM7Yqd+e5uoEE2RBhNWVXdmhlvYv/wv7ia4xQz/MnwYjggCF6rc7Jl?=
 =?us-ascii?Q?YzDzT51xgXiIIEDEU2s1UCKh/R2nVc1ENd33xwbTfZbIdN6TRSP7xEcVvWEu?=
 =?us-ascii?Q?CwFUaYeAOVg181DN0a0jQn+1w/rdKn0g3rq9rVU3CXD1RVo8c9rd2Ux2r2Y4?=
 =?us-ascii?Q?p54z65Lpt3QwWXIoYtmArxFf5JJY2O3U1d10kdjOC7PfnWjBM6DtUmJyPvqP?=
 =?us-ascii?Q?QWy28cOtymx1Gnv3zRWHMB8rJI9YCFuEQAxM4q63mvlGcFnw8e24ENk9fSJS?=
 =?us-ascii?Q?2npM00NHjwmWDbn2QLq+dEM12aSTG4mFYKB0FXlkSSkW/m1+X2Koai2/xknZ?=
 =?us-ascii?Q?oMH4YyVHAfho5Kn0PUhPQ3s8VGnCAwQudwf+YK4utGJtShcN6rxJEjui9lUP?=
 =?us-ascii?Q?GWSBQNiz25IHof2/YBMz+wiTNLsd3R7OLb1vD5vGtP0udyaUSv1aONSzkSx6?=
 =?us-ascii?Q?mT3+IruSEEG8xb4wafV6s68OalJfvX/K6apVYv+KNd5KIlyEtw2dNQkmYRMh?=
 =?us-ascii?Q?sp9z2y10wIAbvg2G5p3AhNLFLj+8pTw6jb/R4e9jhaBEAslf7Pzi9fSTcaI4?=
 =?us-ascii?Q?hLQ8f9BVdq9H/rCSjugStfslfubEu6haAE/9OMGaDDUtA3FbHPtL9nusIwii?=
 =?us-ascii?Q?T/eujovfB3p1gmTq/mwgK7uBQMbUCVaG7JOhUOTk6wzoD8ggokPsyEgfhwKe?=
 =?us-ascii?Q?6kqoG0hiarxgGk1LczSg8pmxSvN0p11Hya1NSCa0B1IIuFYEU1FOBLiK1LF4?=
 =?us-ascii?Q?V362NGJoSujFdbQ3Qq5Zu1377I/um0XFNjymb2Wffh+66Hh5zth8v9xMkhod?=
 =?us-ascii?Q?Gr71qTX7nZV3HM7C5D3XbeX4QPmdI1cUCGt3eedzyD1/bWIoFwZWM6qecBDz?=
 =?us-ascii?Q?tdY3zC3z/DwvZE2ieLod1JIUu2aSJlXb33QWx5n01vUZVJdaLlcFRDGipjUa?=
 =?us-ascii?Q?Tle70Ph/gjAvhpbpSGIYrUL7iGrn+G1nW0yihkwIuKWAsrcSdFz2HYXKrAo9?=
 =?us-ascii?Q?n8LnpKdIEhzGBLK8GID5sn5TI3l3pUhWZiAPBs1gCIIsv1PHfN1EUGl8X2Th?=
 =?us-ascii?Q?y2Y3QWVUc1gGcy8yVtR32CKIzYSYRRfbjCVtHUl6LS+nNNRKW5eagY3v4htY?=
 =?us-ascii?Q?2DZALGT09NfRSK524pPsnUwOIcna8jy8WJYTnijauusO0t31OiJnBENZwYuU?=
 =?us-ascii?Q?DL+nRu8Fu8o6DY3j3tnQtlnnC+7iTfieXtjoElXeOT2tfMT8JRYdtI9bFZYd?=
 =?us-ascii?Q?2XQ4TCIub6H+MKrBzfjzdE1Meecb2ZUZ93YaBiS7OHhcYSwM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94ce8636-575f-44b9-ec10-08de8b6e2624
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2026 19:30:33.7789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZLyxG1BX6xlo8RsmHtM2LS2kXWkMrgUzSxIJT/SBI1SAs79eBFo2vDoQbxJ71uYy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9043

iommupt always supports the semantics required for DMA-FQ, when drivers
are converted to use it they automatically get support.

Detect iommpt directly instead of using IOMMU_CAP_DEFERRED_FLUSH and
remove IOMMU_CAP_DEFERRED_FLUSH from converted drivers.

This will also enable DMA-FQ on RISC-V.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/iommu.c   |  2 --
 drivers/iommu/dma-iommu.c   | 13 ++++++++++++-
 drivers/iommu/intel/iommu.c |  2 --
 3 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 528ebdd26d71c9..daa9eac1184748 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2991,8 +2991,6 @@ static bool amd_iommu_capable(struct device *dev, enum iommu_cap cap)
 		return amdr_ivrs_remap_support;
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:
 		return true;
-	case IOMMU_CAP_DEFERRED_FLUSH:
-		return true;
 	case IOMMU_CAP_DIRTY_TRACKING: {
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev);
 
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 5dac64be61bb27..fbed93f8bf0adb 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -14,6 +14,7 @@
 #include <linux/device.h>
 #include <linux/dma-direct.h>
 #include <linux/dma-map-ops.h>
+#include <linux/generic_pt/iommu.h>
 #include <linux/gfp.h>
 #include <linux/huge_mm.h>
 #include <linux/iommu.h>
@@ -648,6 +649,15 @@ static void iommu_dma_init_options(struct iommu_dma_options *options,
 	}
 }
 
+static bool iommu_domain_supports_fq(struct device *dev,
+				     struct iommu_domain *domain)
+{
+	/* iommupt always supports DMA-FQ */
+	if (iommupt_from_domain(domain))
+		return true;
+	return device_iommu_capable(dev, IOMMU_CAP_DEFERRED_FLUSH);
+}
+
 /**
  * iommu_dma_init_domain - Initialise a DMA mapping domain
  * @domain: IOMMU domain previously prepared by iommu_get_dma_cookie()
@@ -706,7 +716,8 @@ static int iommu_dma_init_domain(struct iommu_domain *domain, struct device *dev
 
 	/* If the FQ fails we can simply fall back to strict mode */
 	if (domain->type == IOMMU_DOMAIN_DMA_FQ &&
-	    (!device_iommu_capable(dev, IOMMU_CAP_DEFERRED_FLUSH) || iommu_dma_init_fq(domain)))
+	    (!iommu_domain_supports_fq(dev, domain) ||
+	     iommu_dma_init_fq(domain)))
 		domain->type = IOMMU_DOMAIN_DMA;
 
 	return iova_reserve_iommu_regions(dev, domain);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 5dca8e525c73c8..80b183e207e59b 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3212,8 +3212,6 @@ static bool intel_iommu_capable(struct device *dev, enum iommu_cap cap)
 
 	switch (cap) {
 	case IOMMU_CAP_CACHE_COHERENCY:
-	case IOMMU_CAP_DEFERRED_FLUSH:
-		return true;
 	case IOMMU_CAP_PRE_BOOT_PROTECTION:
 		return dmar_platform_optin();
 	case IOMMU_CAP_ENFORCE_CACHE_COHERENCY:

base-commit: 447597c362ec566082b75688f2a8883771c066d5
-- 
2.43.0

