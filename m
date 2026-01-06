Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010028.outbound.protection.outlook.com [52.101.85.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27AD33F381;
	Tue,  6 Jan 2026 15:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767712062; cv=fail; b=IxvqbVmtzEzvY6Gy9Q91FaMwFjgnw4gmRMTccvqcIxVi+peJAf5b09zvLxNhLMwBGMXW4xKkn6RbSiFnNWuR5U4V5l5SmoPRRCaesoqsfiSsh67W5a48fL1fncuob9swuDHNIKsvWDXPG4YZ80vq6y1XDtWG0FhgUEHBfyVqsl4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767712062; c=relaxed/simple;
	bh=IdD12XJilTcGoVpzlDeKvKjRl8C9jSYjRQWpUCa6o78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dxz3QDSYzp6TLAsutqM5ZMQpdqK7TivMAH2bIIe/q6Zv6/Tm2QUiZFaS9tfm46L957U4ezJR5SvZaDcKEW1PFVsZO/UfKHQb0F/Yc3fFC5rYhCAWYRg364mAQ1JAwV0zWDkJh9SdbAVEZSVwP9gtut0bzGAEtzpOLp2lqAT/jVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cY6lo3At; arc=fail smtp.client-ip=52.101.85.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cY6lo3At"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A99QP+Cowzmik/eDQrPXaOJVhk2TkFZKYAu9wbSip9Ng0T94jHashVLgY9vbi6h2YA0Lsy4zP4jMd7NRU+7bTg3QmTqRJp3vyHJ6suW87pD+MTMh7Rwry0+J4wpYMdYaAIkvvipPrb57YwRgreffPcefwcORe9/BNOVZGt6AyJSwv9GSY7PNym9kaghkvIVLVbY9sLnWoqyFhta/L8YnPk7W1rsv3yST3gb1wJd59EhxTbPKGRap9DIRjya6imBgVDNf+wUbo2zki3yjD49OcI5sBWAb+nhm0ET6Q2LDjMZ/BagI4dkoK9fJM850FJ+Kc6WGaQPbK07BWGUUQAF5nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c+Fyq83gbICl2/Ydain8RYKxY6cWW8AdUwkVFqys1/Q=;
 b=vhaW6DuBeO13ANxJ0bFHlTK4i+GOd4vYt/QZeQY6VniVlblQbuyEGHmGp3w0JroeExW2y/HF6hQQM2t46rn15j/2SELuA5/RT04GThGi5MOJOb/TV2h3zIOpE1WWJ6p+NbUBS+FVwWf+Y7OMDGnob976HnH1tBgpaSXt8UilSL2y9iHVm//8UvwGP7SstIDaqKW7FGy3pBpniHlPrYBspAbiQAQw6NSwQupbZrlx0rXzjI79lPbkxFFuxQ6tvpxXQlY7NrYfhxRE6jkvIBi8m79L0piOB9R3qY0ZhoppU/Ppec7eVvLWB64YNx196HmTPhhiFViRztkWNXjmo591fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c+Fyq83gbICl2/Ydain8RYKxY6cWW8AdUwkVFqys1/Q=;
 b=cY6lo3At411lVxP4JwIt7DiBOf9pjR+VOol2krf0OY7VNEly+xNsueWQdYZTfqCcnC0c0vSO1W7FB19h+Ze4/WoJB3A6sIagBDvSMcdwB+6ZawrGQi0mdJI/BGCpuXXdAxXVM4Xl1xMAl5c90j4Z3egZNskbMvVgT3VYKb1Nc4XmKMg6p5jHcG+b4AEFLetLM8U+NsSNwTm3u0zRR87QFi7CDsuAlmTWS0BiWQ6N2vC6a9WkQLl14UPJuG73plw4sZ5Gl2Kylff267KL19OSbvairKoK8i0fKuBBvx3U03xCAAvHAK6JHWHzvB2qF1PI4jLrSrNSzg0E6Ch0rFWG3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by IA1PR12MB6434.namprd12.prod.outlook.com (2603:10b6:208:3ae::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 15:06:58 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9499.002; Tue, 6 Jan 2026
 15:06:58 +0000
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
Cc: lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>,
	patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: [PATCH v2 3/5] iommu/riscv: Use the generic iommu page table
Date: Tue,  6 Jan 2026 11:06:47 -0400
Message-ID: <3-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
In-Reply-To: <0-v2-b11ebca8abb6+c096-iommu_pt_riscv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0118.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::33) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|IA1PR12MB6434:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b1f3e5-40c8-4250-b25a-08de4d3539c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/RixCVVGlpSQjoJvKUiOUCJw9irHdycOEzRbTgHe43GYjbgC4/W6e9auuWcD?=
 =?us-ascii?Q?9Ro5DRQbvCJ5+n6x1rdkZ8WYnTE2NOT7SrV67ont2fVvYGkuHup9gumP5gf7?=
 =?us-ascii?Q?1/VUFfO3vgbILfr1vzjrLK7QU2sdWYUWHLfUeLShF4oNBrIAyiJgAE10qTAm?=
 =?us-ascii?Q?QH5AlyzsSzGdjarRZHc4/J4nF9EGpTxKWyGzumr/JLL53LwL3BrXJyq7/2hH?=
 =?us-ascii?Q?UcOABsWOlDZw/vOtGx9FyruJmUTwoRk07Ps6cef8A2txj1V5hlOB/niHOSDR?=
 =?us-ascii?Q?C/KImOiGYgeN6yLbSjILaPshBVfzd3rV6RZtMElgNgLYws275A18klkN9fXI?=
 =?us-ascii?Q?8xGmMjPVfbRmF+nrnx7AKkiLl7GrbstRHRiDX7ea4qfCnNujq8KmWioiDAVc?=
 =?us-ascii?Q?hPEEz7dcjy36FOtIy9MbcGTQInR0U8rSaq81t8iJbqRDno8Kq5be5nbmbu+z?=
 =?us-ascii?Q?HpmBf9Axtca5Rsx0p9uy6LX4TszRu0slz/nEmdJZscWBPmRAbBFRO8DEcuGp?=
 =?us-ascii?Q?YFYk09hEcpJF3560quMqM8HhOFJ2BH666+M3TSUxTMcHKM8O/le49AVPsQBU?=
 =?us-ascii?Q?MWixXy02AUKRGIy9YZ66BtzaX2wes020b8SIklFsDakFAtZUCMgaOBy1OeiO?=
 =?us-ascii?Q?zkAlsyjHUfbrNHL5teSofpheXCgTFIfxax9JGoPsMT1iMkARTZksIuYUP66J?=
 =?us-ascii?Q?S4ZVYAQL4Fy1tubEOmSC9QErPiVjwKEOSPGUuvJ0IOP5rTYxezMMKjK86LZF?=
 =?us-ascii?Q?a6kSQxrJ4nKHv0SvuOt4+BE8djsNUgdfIWb/jIxi7aaRXc3AAj9x3/NJEwK9?=
 =?us-ascii?Q?AQZR6DMIYcYu/LPxkMcTs2HzzXOkJbvoUulmq+8FLNKS0jtWfIO8+9vt/WIT?=
 =?us-ascii?Q?GWYSijoR6D3hB1SeLaU+1L2ieg9FJlKMCi2xQreJkH6Gox+Y35VF1jSNYWEo?=
 =?us-ascii?Q?3hLosUq8m5FCbNT87aiyBeFLNcQwf1IMNO0bRDu0YoWrQgWEfEQO13sWuBFf?=
 =?us-ascii?Q?XfdVO0AD7RIRVS07qhBO33isB6sIWNnUFxlif9EPcVW4we1PR+x1B1FieL6A?=
 =?us-ascii?Q?AWPFggUY+qnFKVvqYapGCdtEGP58IdRqU4NNajT7NoW3c1T8tBOTjmvV8i8r?=
 =?us-ascii?Q?rQzMpBYCRRhcHnMA1hbvrSBB7jW2DFdLEtlTCs4tL06/IFNzUcsI5GrMWY/m?=
 =?us-ascii?Q?RzmRDqzcEKOhe5y9JPhiJMyxzjd+ElTk24NCKsm9wr5r6inJxMb8iVFg3lDN?=
 =?us-ascii?Q?0PuN08ZoMR4OJNgt/XH686FQoVw9kmQwdp/HQ+BTtSPhqCF1myxR+L8VX46x?=
 =?us-ascii?Q?fb5p/gAJsFvFokwfcUMS+EAkPE5peUdvqA0RkzelS5t7PFhXM4Z4WII0eRx+?=
 =?us-ascii?Q?+p8QMjgzE+RPCnbZl1Wkxa+AiizzaYs6OxGjv1tnygVwOmJroL17rLgLpGE7?=
 =?us-ascii?Q?a1+9oxAwy9e13FQkFtgHgx3qwBUuYhylHJpUfSyIi4EMKocQNkp/1L+J4Dc+?=
 =?us-ascii?Q?LH2duEvUpkaKuWs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nTcU3cVQkskEhtaRW0ivKpOvT9fzWmUBKDTDWadfbTSvFdLz0tUSAT80sMDw?=
 =?us-ascii?Q?S5vILubAYFdUnmY1Dkuu4bKKx4sO6ykceQnnnwyXSE83PlXN6yLTnhT9t6bn?=
 =?us-ascii?Q?SGNSZjDs4eb5QIuK0bZYgS0MWJ+Q7oaI9+E4I9zBK6+vQn1CbS1g2ErQKPat?=
 =?us-ascii?Q?qeGS6ap1qknqMrhnmD4AybIbpHJdwh4L6OV5beb88KqPesUwMyBbZo9A/X80?=
 =?us-ascii?Q?yrJYwY+AwDADHT2KE2mEllTGOCjQ5HKIgZlcpbIApZ+7CpAt6/llxawllL3L?=
 =?us-ascii?Q?C6ZICjAZ0kpKY56HZS7qkCpqr7urKtoRNM9d+t1un9RI1wPyfvsAWuWjywlx?=
 =?us-ascii?Q?Fsx8xhaStOHB7tI3J4IkuifCJ5aTK/U+5v+ImT+UOFpy9hEFD8Q4Uhiu/l+A?=
 =?us-ascii?Q?B5X/kZ13cBs8zWx3ixGX7Q3fD/vu/IIHgqOxFnBD00ALwxY9+FgzuJgOdP0Y?=
 =?us-ascii?Q?Xfw/qeyzJFFZlqXT7zuBNLqaXhhl9RMfaEYDcxdEGqqJnX7wX5zsGgBwvE3j?=
 =?us-ascii?Q?oDPHDQLFuPBpNGp5V2vR5K1ApmsXx7y/R20mkrXHXJFqRbJG3bAqLvZO3F9M?=
 =?us-ascii?Q?B9ZIuj/8tiqwAVCUjULAM18ntSpiafJGVSX/J8jP79pTykY+ENdF/0+KjQ2D?=
 =?us-ascii?Q?oZSBanh03s34bte9sZ5Pvw9RJMhha9abALkJnNeHBQpr8nLg2FdiVmTVzYFN?=
 =?us-ascii?Q?elK8QJNtC1UFe97sK8+I/PC1mS/5UKF5NcSQ+3MDSnWfCcND5GyIPpaSlfW1?=
 =?us-ascii?Q?DmiKno36fy+ajpj+mzpbHhTMvi6QTQun222wrzE0dzaAeCWV/NUP/b2B7RpO?=
 =?us-ascii?Q?7x53YyXdU8/dwuyhBvvOMccwLXA/+3HeZTbBlCR11RzHUK+lJrpKOdSE5Wi/?=
 =?us-ascii?Q?uaYxtwOEaU4OyI8kIELF8dmAhYXuDaD1CyB/xb46tKVP53/OAMpQb6NGjcnB?=
 =?us-ascii?Q?lSNsMTPTvvGSjDxRgpX4rOitjKSGRD30G0Aq/6yEK+6IJpBbqND9nuHOBUqx?=
 =?us-ascii?Q?E2E+/RSCienF1INrAyO+nse00IL3xKO1LAhBgZxe0d8ddK2WJ6pPIRXvfE0i?=
 =?us-ascii?Q?7BEA4z1y0bsdJLqRqDSQl5dZgMbk5i8RIcpOwHMko9a+vly5Y+03siXnPIOB?=
 =?us-ascii?Q?vmaVHNOKVNV0sTe+461JIomxvL3SmJxRrM9799kh+3SGO0wx+x1A9eHrMpP3?=
 =?us-ascii?Q?dP8v0wdQ9v8vlEUXc55+Zqba7H7Syz4hb16Zo9wwX9jRx0cLXDvOx33K1oI1?=
 =?us-ascii?Q?52bOvxBfGL6xnxMAKRTbWKVBQbWz/lnsWUcp++Fs8n13inedV1yBmF5Kztml?=
 =?us-ascii?Q?ECNIT+uKMDSJY6YDOnpoXh9/Fh+3q7a12LHOKdNO+MuG/u+NIPbz4G557AEX?=
 =?us-ascii?Q?d8aTRC63x65FXVTRooLz0qAxjr22GR+GAt1lTE8rIE1fnTpiXiE6ewGx+19q?=
 =?us-ascii?Q?rbsEk7rVWDjWgBtBL2lZdOrkEA2kPXrw6Mh5OJGP/RGUpsR/Dz/T4Fypw3mM?=
 =?us-ascii?Q?NwNF2Sfamc3ZiQ3ETxD3LiQU5jwLkUBBvXIPn0dixsUQsUFFKI+HfwcL3rhl?=
 =?us-ascii?Q?pkKva4W6MZaQbzyVWcVUp79O/Y8DVLFGJgUfKPN1WSNPTcTMmpKxtD73wQ7U?=
 =?us-ascii?Q?HFRE8YXU/tf+cKrdLHNbt1G8QJCJPGQ3XZaI6Q4T+RjPgH7zkA/o960WdUAe?=
 =?us-ascii?Q?tbUbeJiTVW/fo/vqfmabgTOWqvKCl6H3gRVap6Xnya/CC5ley1SM1WUILncj?=
 =?us-ascii?Q?7myJJDeqfA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b1f3e5-40c8-4250-b25a-08de4d3539c0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:06:54.6987
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7HKikpqra7hHAZOI/J00DZhK8//Szca+WUTzLy2EHZpwt7xEGrr6tygqDXNyGX8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6434

This is a fairly straightforward conversion of the RISC-V iommu driver to
use the generic iommu page table code.

Invalidation stays as it is now with the driver pretending to implement
simple range based invalidation even though the HW is more like ARM SMMUv3
than AMD where the HW implements a single-PTE based invalidation. Future
work to extend the generic invalidate mechanism to support more ARM-like
semantics would benefit this driver as well.

Delete the existing page table code.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/Kconfig |   3 +
 drivers/iommu/riscv/iommu.c | 287 +++++-------------------------------
 2 files changed, 39 insertions(+), 251 deletions(-)

diff --git a/drivers/iommu/riscv/Kconfig b/drivers/iommu/riscv/Kconfig
index c071816f59a67b..a329ec634cf1c5 100644
--- a/drivers/iommu/riscv/Kconfig
+++ b/drivers/iommu/riscv/Kconfig
@@ -6,6 +6,9 @@ config RISCV_IOMMU
 	depends on RISCV && 64BIT
 	default y
 	select IOMMU_API
+	select GENERIC_PT
+	select IOMMU_PT
+	select IOMMU_PT_RISCV64
 	help
 	  Support for implementations of the RISC-V IOMMU architecture that
 	  complements the RISC-V MMU capabilities, providing similar address
diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index f57a5b457076e0..c02878f00294b5 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -21,6 +21,7 @@
 #include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/pci.h>
+#include <linux/generic_pt/iommu.h>
 
 #include "../iommu-pages.h"
 #include "iommu-bits.h"
@@ -806,14 +807,15 @@ static int riscv_iommu_iodir_set_mode(struct riscv_iommu_device *iommu,
 
 /* This struct contains protection domain specific IOMMU driver data. */
 struct riscv_iommu_domain {
-	struct iommu_domain domain;
+	union {
+		struct iommu_domain domain;
+		struct pt_iommu_riscv_64 riscvpt;
+	};
 	struct list_head bonds;
 	spinlock_t lock;		/* protect bonds list updates. */
 	int pscid;
-	int numa_node;
-	unsigned int pgd_mode;
-	unsigned long *pgd_root;
 };
+PT_IOMMU_CHECK_DOMAIN(struct riscv_iommu_domain, riscvpt.iommu, domain);
 
 #define iommu_domain_to_riscv(iommu_domain) \
 	container_of(iommu_domain, struct riscv_iommu_domain, domain)
@@ -1076,156 +1078,9 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 
-	riscv_iommu_iotlb_inval(domain, gather->start, gather->end);
-}
-
-#define PT_SHIFT (PAGE_SHIFT - ilog2(sizeof(pte_t)))
-
-#define _io_pte_present(pte)	((pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE))
-#define _io_pte_leaf(pte)	((pte) & _PAGE_LEAF)
-#define _io_pte_none(pte)	((pte) == 0)
-#define _io_pte_entry(pn, prot)	((_PAGE_PFN_MASK & ((pn) << _PAGE_PFN_SHIFT)) | (prot))
-
-static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
-				 unsigned long pte,
-				 struct iommu_pages_list *freelist)
-{
-	unsigned long *ptr;
-	int i;
-
-	if (!_io_pte_present(pte) || _io_pte_leaf(pte))
-		return;
-
-	ptr = (unsigned long *)pfn_to_virt(__page_val_to_pfn(pte));
-
-	/* Recursively free all sub page table pages */
-	for (i = 0; i < PTRS_PER_PTE; i++) {
-		pte = READ_ONCE(ptr[i]);
-		if (!_io_pte_none(pte) && cmpxchg_relaxed(ptr + i, pte, 0) == pte)
-			riscv_iommu_pte_free(domain, pte, freelist);
-	}
-
-	if (freelist)
-		iommu_pages_list_add(freelist, ptr);
-	else
-		iommu_free_pages(ptr);
-}
-
-static unsigned long *riscv_iommu_pte_alloc(struct riscv_iommu_domain *domain,
-					    unsigned long iova, size_t pgsize,
-					    gfp_t gfp)
-{
-	unsigned long *ptr = domain->pgd_root;
-	unsigned long pte, old;
-	int level = domain->pgd_mode - RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV39 + 2;
-	void *addr;
-
-	do {
-		const int shift = PAGE_SHIFT + PT_SHIFT * level;
-
-		ptr += ((iova >> shift) & (PTRS_PER_PTE - 1));
-		/*
-		 * Note: returned entry might be a non-leaf if there was
-		 * existing mapping with smaller granularity. Up to the caller
-		 * to replace and invalidate.
-		 */
-		if (((size_t)1 << shift) == pgsize)
-			return ptr;
-pte_retry:
-		pte = READ_ONCE(*ptr);
-		/*
-		 * This is very likely incorrect as we should not be adding
-		 * new mapping with smaller granularity on top
-		 * of existing 2M/1G mapping. Fail.
-		 */
-		if (_io_pte_present(pte) && _io_pte_leaf(pte))
-			return NULL;
-		/*
-		 * Non-leaf entry is missing, allocate and try to add to the
-		 * page table. This might race with other mappings, retry.
-		 */
-		if (_io_pte_none(pte)) {
-			addr = iommu_alloc_pages_node_sz(domain->numa_node, gfp,
-							 SZ_4K);
-			if (!addr)
-				return NULL;
-			old = pte;
-			pte = _io_pte_entry(virt_to_pfn(addr), _PAGE_TABLE);
-			if (cmpxchg_relaxed(ptr, old, pte) != old) {
-				iommu_free_pages(addr);
-				goto pte_retry;
-			}
-		}
-		ptr = (unsigned long *)pfn_to_virt(__page_val_to_pfn(pte));
-	} while (level-- > 0);
-
-	return NULL;
-}
-
-static unsigned long *riscv_iommu_pte_fetch(struct riscv_iommu_domain *domain,
-					    unsigned long iova, size_t *pte_pgsize)
-{
-	unsigned long *ptr = domain->pgd_root;
-	unsigned long pte;
-	int level = domain->pgd_mode - RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV39 + 2;
-
-	do {
-		const int shift = PAGE_SHIFT + PT_SHIFT * level;
-
-		ptr += ((iova >> shift) & (PTRS_PER_PTE - 1));
-		pte = READ_ONCE(*ptr);
-		if (_io_pte_present(pte) && _io_pte_leaf(pte)) {
-			*pte_pgsize = (size_t)1 << shift;
-			return ptr;
-		}
-		if (_io_pte_none(pte))
-			return NULL;
-		ptr = (unsigned long *)pfn_to_virt(__page_val_to_pfn(pte));
-	} while (level-- > 0);
-
-	return NULL;
-}
-
-static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
-				 unsigned long iova, phys_addr_t phys,
-				 size_t pgsize, size_t pgcount, int prot,
-				 gfp_t gfp, size_t *mapped)
-{
-	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	size_t size = 0;
-	unsigned long *ptr;
-	unsigned long pte, old, pte_prot;
-	int rc = 0;
-	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
-
-	if (!(prot & IOMMU_WRITE))
-		pte_prot = _PAGE_BASE | _PAGE_READ;
-	else
-		pte_prot = _PAGE_BASE | _PAGE_READ | _PAGE_WRITE | _PAGE_DIRTY;
-
-	while (pgcount) {
-		ptr = riscv_iommu_pte_alloc(domain, iova, pgsize, gfp);
-		if (!ptr) {
-			rc = -ENOMEM;
-			break;
-		}
-
-		old = READ_ONCE(*ptr);
-		pte = _io_pte_entry(phys_to_pfn(phys), pte_prot);
-		if (cmpxchg_relaxed(ptr, old, pte) != old)
-			continue;
-
-		riscv_iommu_pte_free(domain, old, &freelist);
-
-		size += pgsize;
-		iova += pgsize;
-		phys += pgsize;
-		--pgcount;
-	}
-
-	*mapped = size;
-
-	if (!iommu_pages_list_empty(&freelist)) {
+	if (iommu_pages_list_empty(&gather->freelist)) {
+		riscv_iommu_iotlb_inval(domain, gather->start, gather->end);
+	} else {
 		/*
 		 * In 1.0 spec version, the smallest scope we can use to
 		 * invalidate all levels of page table (i.e. leaf and non-leaf)
@@ -1234,71 +1089,20 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 		 * capability.NL (non-leaf) IOTINVAL command.
 		 */
 		riscv_iommu_iotlb_inval(domain, 0, ULONG_MAX);
-		iommu_put_pages_list(&freelist);
+		iommu_put_pages_list(&gather->freelist);
 	}
-
-	return rc;
-}
-
-static size_t riscv_iommu_unmap_pages(struct iommu_domain *iommu_domain,
-				      unsigned long iova, size_t pgsize,
-				      size_t pgcount,
-				      struct iommu_iotlb_gather *gather)
-{
-	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	size_t size = pgcount << __ffs(pgsize);
-	unsigned long *ptr, old;
-	size_t unmapped = 0;
-	size_t pte_size;
-
-	while (unmapped < size) {
-		ptr = riscv_iommu_pte_fetch(domain, iova, &pte_size);
-		if (!ptr)
-			return unmapped;
-
-		/* partial unmap is not allowed, fail. */
-		if (iova & (pte_size - 1))
-			return unmapped;
-
-		old = READ_ONCE(*ptr);
-		if (cmpxchg_relaxed(ptr, old, 0) != old)
-			continue;
-
-		iommu_iotlb_gather_add_page(&domain->domain, gather, iova,
-					    pte_size);
-
-		iova += pte_size;
-		unmapped += pte_size;
-	}
-
-	return unmapped;
-}
-
-static phys_addr_t riscv_iommu_iova_to_phys(struct iommu_domain *iommu_domain,
-					    dma_addr_t iova)
-{
-	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	size_t pte_size;
-	unsigned long *ptr;
-
-	ptr = riscv_iommu_pte_fetch(domain, iova, &pte_size);
-	if (!ptr)
-		return 0;
-
-	return pfn_to_phys(__page_val_to_pfn(*ptr)) | (iova & (pte_size - 1));
 }
 
 static void riscv_iommu_free_paging_domain(struct iommu_domain *iommu_domain)
 {
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
-	const unsigned long pfn = virt_to_pfn(domain->pgd_root);
 
 	WARN_ON(!list_empty(&domain->bonds));
 
 	if ((int)domain->pscid > 0)
 		ida_free(&riscv_iommu_pscids, domain->pscid);
 
-	riscv_iommu_pte_free(domain, _io_pte_entry(pfn, _PAGE_TABLE), NULL);
+	pt_iommu_deinit(&domain->riscvpt.iommu);
 	kfree(domain);
 }
 
@@ -1324,13 +1128,16 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
 	struct riscv_iommu_domain *domain = iommu_domain_to_riscv(iommu_domain);
 	struct riscv_iommu_device *iommu = dev_to_iommu(dev);
 	struct riscv_iommu_info *info = dev_iommu_priv_get(dev);
+	struct pt_iommu_riscv_64_hw_info pt_info;
 	u64 fsc, ta;
 
-	if (!riscv_iommu_pt_supported(iommu, domain->pgd_mode))
+	pt_iommu_riscv_64_hw_info(&domain->riscvpt, &pt_info);
+
+	if (!riscv_iommu_pt_supported(iommu, pt_info.fsc_iosatp_mode))
 		return -ENODEV;
 
-	fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, domain->pgd_mode) |
-	      FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, virt_to_pfn(domain->pgd_root));
+	fsc = FIELD_PREP(RISCV_IOMMU_PC_FSC_MODE, pt_info.fsc_iosatp_mode) |
+	      FIELD_PREP(RISCV_IOMMU_PC_FSC_PPN, pt_info.ppn);
 	ta = FIELD_PREP(RISCV_IOMMU_PC_TA_PSCID, domain->pscid) |
 	     RISCV_IOMMU_PC_TA_V;
 
@@ -1345,37 +1152,32 @@ static int riscv_iommu_attach_paging_domain(struct iommu_domain *iommu_domain,
 }
 
 static const struct iommu_domain_ops riscv_iommu_paging_domain_ops = {
+	IOMMU_PT_DOMAIN_OPS(riscv_64),
 	.attach_dev = riscv_iommu_attach_paging_domain,
 	.free = riscv_iommu_free_paging_domain,
-	.map_pages = riscv_iommu_map_pages,
-	.unmap_pages = riscv_iommu_unmap_pages,
-	.iova_to_phys = riscv_iommu_iova_to_phys,
 	.iotlb_sync = riscv_iommu_iotlb_sync,
 	.flush_iotlb_all = riscv_iommu_iotlb_flush_all,
 };
 
 static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 {
+	struct pt_iommu_riscv_64_cfg cfg = {};
 	struct riscv_iommu_domain *domain;
 	struct riscv_iommu_device *iommu;
-	unsigned int pgd_mode;
-	dma_addr_t va_mask;
-	int va_bits;
+	int ret;
 
 	iommu = dev_to_iommu(dev);
 	if (iommu->caps & RISCV_IOMMU_CAPABILITIES_SV57) {
-		pgd_mode = RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV57;
-		va_bits = 57;
+		cfg.common.hw_max_vasz_lg2 = 57;
 	} else if (iommu->caps & RISCV_IOMMU_CAPABILITIES_SV48) {
-		pgd_mode = RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV48;
-		va_bits = 48;
+		cfg.common.hw_max_vasz_lg2 = 48;
 	} else if (iommu->caps & RISCV_IOMMU_CAPABILITIES_SV39) {
-		pgd_mode = RISCV_IOMMU_DC_FSC_IOSATP_MODE_SV39;
-		va_bits = 39;
+		cfg.common.hw_max_vasz_lg2 = 39;
 	} else {
 		dev_err(dev, "cannot find supported page table mode\n");
 		return ERR_PTR(-ENODEV);
 	}
+	cfg.common.hw_max_oasz_lg2 = 56;
 
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
@@ -1383,42 +1185,23 @@ static struct iommu_domain *riscv_iommu_alloc_paging_domain(struct device *dev)
 
 	INIT_LIST_HEAD_RCU(&domain->bonds);
 	spin_lock_init(&domain->lock);
-	domain->numa_node = dev_to_node(iommu->dev);
-	domain->pgd_mode = pgd_mode;
-	domain->pgd_root = iommu_alloc_pages_node_sz(domain->numa_node,
-						     GFP_KERNEL_ACCOUNT, SZ_4K);
-	if (!domain->pgd_root) {
-		kfree(domain);
-		return ERR_PTR(-ENOMEM);
-	}
+	cfg.common.features = BIT(PT_FEAT_SIGN_EXTEND) |
+			      BIT(PT_FEAT_FLUSH_RANGE);
+	domain->riscvpt.iommu.nid = dev_to_node(iommu->dev);
+	domain->domain.ops = &riscv_iommu_paging_domain_ops;
 
 	domain->pscid = ida_alloc_range(&riscv_iommu_pscids, 1,
 					RISCV_IOMMU_MAX_PSCID, GFP_KERNEL);
 	if (domain->pscid < 0) {
-		iommu_free_pages(domain->pgd_root);
-		kfree(domain);
+		riscv_iommu_free_paging_domain(&domain->domain);
 		return ERR_PTR(-ENOMEM);
 	}
 
-	/*
-	 * Note: RISC-V Privilege spec mandates that virtual addresses
-	 * need to be sign-extended, so if (VA_BITS - 1) is set, all
-	 * bits >= VA_BITS need to also be set or else we'll get a
-	 * page fault. However the code that creates the mappings
-	 * above us (e.g. iommu_dma_alloc_iova()) won't do that for us
-	 * for now, so we'll end up with invalid virtual addresses
-	 * to map. As a workaround until we get this sorted out
-	 * limit the available virtual addresses to VA_BITS - 1.
-	 */
-	va_mask = DMA_BIT_MASK(va_bits - 1);
-
-	domain->domain.geometry.aperture_start = 0;
-	domain->domain.geometry.aperture_end = va_mask;
-	domain->domain.geometry.force_aperture = true;
-	domain->domain.pgsize_bitmap = va_mask & (SZ_4K | SZ_2M | SZ_1G | SZ_512G);
-
-	domain->domain.ops = &riscv_iommu_paging_domain_ops;
-
+	ret = pt_iommu_riscv_64_init(&domain->riscvpt, &cfg, GFP_KERNEL);
+	if (ret) {
+		riscv_iommu_free_paging_domain(&domain->domain);
+		return ERR_PTR(ret);
+	}
 	return &domain->domain;
 }
 
@@ -1674,3 +1457,5 @@ int riscv_iommu_init(struct riscv_iommu_device *iommu)
 	riscv_iommu_queue_disable(&iommu->cmdq);
 	return rc;
 }
+
+MODULE_IMPORT_NS("GENERIC_PT_IOMMU");
-- 
2.43.0

