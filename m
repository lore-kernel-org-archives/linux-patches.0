Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012064.outbound.protection.outlook.com [52.101.43.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3990B3515EA;
	Wed, 12 Aug 2026 20:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786565384; cv=fail; b=Zt6X1/hhmaB168+Vy+x0BLTo9XH6rDjs4FxmzGDdJaWWRdIEQ3GwrSHcNu863fP580qV19na7iCVVdrImN8mEIHxPaM7AwMTqFWEkBcUo0RUyB/KkhKWr+TPMcxfn00RLB4dYrKypa8xWdRpCk1RHc/IxdtQyAUN1tok6f46zlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786565384; c=relaxed/simple;
	bh=XoZYiCokfWh9HDOFAtNX9wvg8fYqjleBN0pvxQNfY+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=afCre4V7r4hSB64jsl32jEIqDs6KiTY+H2AQDEcr5dPTRxI1tIfjSiL+4Hfse5VRHtI1NRV3llFWaVVuDHiB3kMF1RHY65i23dJj6TzVAfliRw2pBfsy5qVOGqaiksU+oHHszdayR9CNQJzq4wA2rkvDIptdwoR4ct3lTdISP+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PH/8GcAx; arc=fail smtp.client-ip=52.101.43.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PH/8GcAx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZrkCU+e9bh9UNlQfpS/SJ4tEqacJlTObwcb/cVbKkrrWcEA33SbMpeynxJKb7ULUymE77RlMIMDWFfIRdj2fC/UbLjgB2lp7SurvPozemU9Cl7OLPwDU22zT2FIiCTXIbTlIDY2Oqfc95MwDH4MNEkKWNaT8PGKdM/WFcypluGWjndWVxqXoE83VGsBesHOVOhQnhpvuZuiECxGg00RqTcdLzU/8BFaalY2s+svDil+wvWGp+7RU8dP8awNG6w2NwR47QB38FuXMg9mj9P0gk3Y9ynNGceIAXDajxz6V/CFyFfvKTY3nTOD3q8mQW6C95oQgbTFY/bK4JzD/QYgcjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ag+dOkt5nNWXtXz5QR65pxJGYKw7u6WUmyU+Czn143Y=;
 b=RicgOyeUsp1JufGI5+ZIQxjNAuBZj3/gaI10yHQ1b1M5tW8KXPhgiAJhM9Ao1f7YPnql7d3Zlipg+cPyNHF21DIYAs8QRfwMOnmsnXOynmXZpVwIkKtImL+aJ6ta3rakJt6KtOC+CVAbb2WKacj/mEvCzke7qUfDV56X4G0z4MdVuTKCFnX7NCVJ4GQEPxQ6FuZEjEaa7J9PHaKY3a0/tohktc4wuIEX9PiDfAWX/ChQWx+9sgPZUw7MMv5qbblTswkb0G+fgX3OeC5bOXhSfJzDEBrKLsFqGtKSzUuFmOFpb/jrLIGUywFbhF+CxeFXtD8Zo3fCC9co4f6cmwEbfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ag+dOkt5nNWXtXz5QR65pxJGYKw7u6WUmyU+Czn143Y=;
 b=PH/8GcAxpEhuDZ6DA5bDgLOhx/xePSD5BJEFv5qfM4s2UhQ23FyJELDXLFFw+RNHfXAa1B7nkO4rizbtjDJEIR7IOLCxFu18JTMUTGhwJ79RcUOBOnwuyjg1a56S6R6lQhkxHpj2LsSFdZjHqZQf5aABWcvy56nRzrBzOKcmeZfwH0KZbLTnMZKPCS0HgkH86f6MKS37L8HYzzBP2WbfsJroGtnIk/EZg4paG2zBAJv6jsuF2ZzR1hcxlOtzVaNNrmJAnzxI8bwt6q98IuLV1WxNcaGF9OSKKOjanS/GQbuuyD+iMM3pNRSuW5TIE6vq5OWvI94U5WAZAEPJi8UJrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CY3PR12MB9629.namprd12.prod.outlook.com (2603:10b6:930:101::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Wed, 12 Aug
 2026 20:09:31 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.011; Wed, 12 Aug 2026
 20:09:31 +0000
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
Subject: [PATCH v2 3/9] iommupt/armv8: Add the 64 bit ARMv8 page table format
Date: Wed, 12 Aug 2026 17:09:19 -0300
Message-ID: <3-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
In-Reply-To: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT1PR01CA0120.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2c::29) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CY3PR12MB9629:EE_
X-MS-Office365-Filtering-Correlation-Id: ff333339-cae5-43be-70b3-08def8ad9c31
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|6133799003|22082099003|56012099006|10067099003|11063799006|3023799007|18002099003;
X-Microsoft-Antispam-Message-Info:
	dzDYsYq+xXmSLgD0t13GVynqQreSKNhHVsJDVJnzKFq1VOEkgYCpFvzUHih2QnYgmTvIqR/Z6c9bsGhjOyf8tbBqKYvR0aVjLgejrkdhP7HTtKAJ0S8ULb7OwgBs7ozOOV04CuJ9Bp7oZpQMtsxfy5wtlX/nRQiA3n4VQMy5KgC6hEasA5NWrHc57xoyzFtVskyMClSb5v6qguuFRAgQdWaIDa+XmcFU0gwtEP+ghgaC4YbnRg43dIewBrz09dYCV3S2xOYtw7JmfN4raikHF73B0Ltt69WRyFy+L4qGPh12SOU+SmHG0EkqN57JIpnYgIcP7JMeHxAkP9a+tgQjWnGfFMloCTxkUl4P9a20/1RSEpmu8DjauZB+TZcZRqo/qyjr2l6OKvqf4DbF3huccfMtkRr7a5MzwldqceTTqGjsDQLUM4fUnGyvTiFNRFixdpe3HaauRAcmAc3eL7l5Gsy2Xjrch0mkKcCrWIrCrYAuJQf4TgODrVFNareX1l5IHq9HvL5Hz8fbQ8bPKt7o/WyztA1Fn9nUexXkg++rGR+YZKQ66A3STaG6BmlBalLfVOe00s6mcBklBok2o/XGe5kUd7PSSZ4qcfKN0evdCY9Wv+FdzsxYWWj3jwcBtprzeS193pjWCogilU6sGPZmaJVqDcmJUWlAeC5eGxy+MqM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(6133799003)(22082099003)(56012099006)(10067099003)(11063799006)(3023799007)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MRzLe0Wjc/kG2hdxQKznQMEsNIg2p/nzBpjYqEp2nQXwISWo8HFm1+2Ydu5Z?=
 =?us-ascii?Q?fSQd0eNoUeVl/XvoSfhUrbqNTWFBTCrw6VYnBnQ/R5bpDWRZd8NQvXw7DYQs?=
 =?us-ascii?Q?gGtBPAsklZlwDhZ+1FwGODPQLPY6ZEel5RM2XOGfp3qPgb5F2Sj/uHIUnZ70?=
 =?us-ascii?Q?dO2eQVOXSg8/mh0YXk5ppYJ3cxEll4NkOLPL72NMVjkjEhJ0yKZBEjJXP7Yr?=
 =?us-ascii?Q?xbZ1ljPShtPAcLtxowSucV5xuARmLaQFZlk+KcICosPqSr1YUhVXRt+fpG7G?=
 =?us-ascii?Q?aATCMZ98jru3pDJIc3DcEhYvWey9Qx2XOhEVg5nAUT0GBdvz7DetqVKC5+Ph?=
 =?us-ascii?Q?lOEo1yKSSEGIF0eitHtyVQhEdM21otrStn2mJ6AAX+ZjyFAJRjod+9IypLgd?=
 =?us-ascii?Q?+bTiqN9vAJzESmP8E9sqr3QhQk0qID5aqgQ1Iv1k25KhzqVDQstVAHCZb5kl?=
 =?us-ascii?Q?v4Eucn+rIKeML27HUVsCEwuOFwc+D/xbOfOtJ2xiuNbIbKcicznNDYCtjWkG?=
 =?us-ascii?Q?oVwdh2sHhwBjEWTeWKDVUaoGgFyoANtiZ6H5jzRzqgtLN2h5FacnZkg1Qm5h?=
 =?us-ascii?Q?vcD/lBSgTFdAlajIJNjV2xAvFIt57MG+O9qbJYw2NeUs7hc3VhjSJtbelgUr?=
 =?us-ascii?Q?eWK//xWPqUpjBxazELwXuBQccGcxcPcI+6bfcOMVWsVNYis2ke/4AdgJyzhm?=
 =?us-ascii?Q?xiGPe0Va7JC6tTBsUX+J4EXxB/6HAs5IbPo7YLDkEna9Hf7BVrDylQHd4yon?=
 =?us-ascii?Q?i0AeMz9uq/rBKOUHq+HhjV8KfmCtu2FMyFBAiZ5jq2hKe0Z1NuJvZAE5EKJB?=
 =?us-ascii?Q?gfDtD2ZWnQ2bhzrEizLWRzx9yGzjOgIoRaEV58G9D3XHwZIiux+BcUOsDbgs?=
 =?us-ascii?Q?G3aGVPaAMmCyDAYMgdGwJS9IjAtP6nuQHhuIJix+6CTYRe7yEJ5/EDaQzZlA?=
 =?us-ascii?Q?xuJOLcasQlnvsMjpCGN/5RqEjXaY0bSJn8EQ4pU09OvyPxFngXaC2gzCGYhU?=
 =?us-ascii?Q?x7NxZRGDQyReIKA7hAdKKWjnFqNpJ8pDovW2J/icwKm0HoHIAwhqaNoWqQdk?=
 =?us-ascii?Q?IZwL1HMODUg+sHUeo8SBKs1BrV929Rkvfg6oQbTmZxGDiYAUHuDLMSnW7Wsd?=
 =?us-ascii?Q?0rt/ivlXCGEDzfyGiPjqbdmIPX3qj6JqSEMxKh4zLAbi3OlZ6sgAeij/T4XI?=
 =?us-ascii?Q?lbAoKuNcI+F4cCKKLnO0Um5VaWJ4onsm9tfRQ4fvPMHdXq9Ezer6vMypTbDD?=
 =?us-ascii?Q?NJIEzIxHZRc+Z3pn9DIUuetnuVsUjYNv8FVfI5ByrdVxbNwS4Yp34XzUQiYx?=
 =?us-ascii?Q?UbA3WjisWTeEWsosyjDPMin8v1zvWRTHJIQYxXoFkkEdMGCrK5LIaP04XXBZ?=
 =?us-ascii?Q?IWcj0/wpHWtEaSrK/Pu7m5Jt/ZsYdxwcW+xfdSVpuhCQaP0SQ+xJbOxt8Q9M?=
 =?us-ascii?Q?nL2MasUFre2Q494ngvkn9SzWW7UQVE3raJugzV3EPVKDLsD1nIzUb8Clg83K?=
 =?us-ascii?Q?cz04teniy1YC4YdSWaj+yFn/f/h37L/DKcXUIWC0Ro1anI8s6jYsbW/Ky6WU?=
 =?us-ascii?Q?l1ZLW5u8/nLYD6/6B3Szwq8XyBDSbLvk9gHPNeF6oqastDNCdjYzNb4cezdl?=
 =?us-ascii?Q?M/gFjK855M+p0KdJFd6WDQ0yrg+/VLskDb01lPrX2uxC3E39bjwqSUSpdVvq?=
 =?us-ascii?Q?yUa9gnK1gHnnWadyWXwAePV8Ow3u9VW3MpifN+LjA9D2ANdiTjkSHsMU5b4R?=
 =?us-ascii?Q?D6548cK1Rw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff333339-cae5-43be-70b3-08def8ad9c31
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 20:09:27.1437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: trHMhfCSkl5XLuthImq8Spa2bMWZ8YSNbjxgIWq2/i3rOskGHOuWv74iGT3NhpHe
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9629

The features, format and naming is taking from the ARMv8 VMSAv8-64
chapter. By far ARMv8 is the most complex format supported by generic page
table, with the largest number of options and configurations.

ARMv8 uses almost all the features of the common implementation:

 - Contiguous pages
 - Leaf pages at many levels
 - Variable starting top level
 - Variable size top level supporting concatenated tables with a high
   order top table allocation
 - Dirty tracking
 - Low (TTB0) or high (TTB1) starting VA
 - Software bits

Compared to the io-pgtable version this also implements the contiguous
page hint, and supports dirty readback from the S2. It always will use S2
concatenation to avoid a table walk instead of only using it when required
by the spec. This closer to the original io-pgtable version which tried to
use it sometime when not mandatory. The cost is an increased case of high
order allocations for the table top. When a S1 is supported by HW only
VFIO creates S2s so a high order allocation failure is OK. If S2 is only
supported then the iommu core will perform the S2's table top allocations
during early boot, and that is OK too.

iommupt's incoherent flushing algorithm was modeled after the ARM
io-pgtable version so there is no change here.

Additionaly it includes implementations for the LPA, LVA, and LPA2
features however they will be compiled off for the iommu build until a
driver actually needs thems. With these features it can support the "level
-1" to produce a 5 level table similar to x86, as well as all the
different placements of OA bits defined by the spec.

This is supported by a compare test that creates parallel iommupt and
io-pgtable instances with matching parameters and validates that every
tree level is the "same" across several meaningful tests. It covers the S2
concatenated pages, the recent bugs found in the io-pgtable logic and a
range of VA sizes.

Add the generic page table API component and generic definitions for
ARMv8.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/fmt/armv8.h      | 481 ++++++++++++++++++++++
 drivers/iommu/generic_pt/fmt/defs_armv8.h |  23 ++
 include/linux/generic_pt/common.h         |  36 ++
 3 files changed, 540 insertions(+)
 create mode 100644 drivers/iommu/generic_pt/fmt/armv8.h
 create mode 100644 drivers/iommu/generic_pt/fmt/defs_armv8.h

diff --git a/drivers/iommu/generic_pt/fmt/armv8.h b/drivers/iommu/generic_pt/fmt/armv8.h
new file mode 100644
index 00000000000000..96be469d477fca
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/armv8.h
@@ -0,0 +1,481 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * The page table format described by ARM DDI 0487 L.b, Chapter D8
+ * "The AArch64 Virtual Memory System Architecture" (VMSAv8-64).
+ * With the right cfg this will also implement the VMSAv8-32 Long
+ * Descriptor format.
+ *
+ * This was called io-pgtable-arm.c and ARM_xx_LPAE_Sx.
+ *
+ * NOTE! The level numbering is consistent with the Generic Page Table API, but
+ * is reversed from what the ARM documents use.
+ *
+ *   generic_pt | ARM | 4K TG       | 16K TG     | 64K TG
+ *   -----------+-----+-------------+------------+--------------
+ *   0          |   3 | 4KB (64KB)  | 16KB (2MB) | 64KB (2MB)
+ *   1          |   2 | 2MB (32MB)  | 32MB (1GB) | 512MB (16GB)
+ *   2          |   1 | 1GB (16GB)  | 64GB       | 4TB (128TB)
+ *   3          |   0 | 512GB (8TB) | 128TB      | -
+ *   4          |  -1 | 256TB       | -          | -
+ * Supported contiguous size in brackets
+ */
+#ifndef __GENERIC_PT_FMT_ARMV8_H
+#define __GENERIC_PT_FMT_ARMV8_H
+
+#include "defs_armv8.h"
+#include "../pt_defs.h"
+
+#include <asm/page.h>
+#include <linux/bitfield.h>
+#include <linux/bits.h>
+#include <linux/container_of.h>
+#include <linux/errno.h>
+#include <linux/limits.h>
+#include <linux/sizes.h>
+#include <linux/string.h>
+
+/*
+ * Aid for understanding how the spec numerology relates to the code. Note the
+ * expression "level > ARMLx" means any ARMLy such that level < x
+ */
+enum {
+	ARML3 = 0,
+	ARML2 = 1,
+	ARML1 = 2,
+	ARML0 = 3,
+	ARMLn1 = 4,
+};
+
+enum {
+	PT_MAX_TOP_LEVEL = PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) ? ARMLn1 :
+								      ARML0,
+	PT_ITEM_WORD_SIZE = sizeof(u64),
+};
+
+enum {
+	PT_MAX_OUTPUT_ADDRESS_LG2 =
+		(PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA)) ? 52 : 48,
+	/* See armv8pt_iommu_fmt_init() */
+	PT_MAX_VA_ADDRESS_LG2 =
+		(PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA2) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LVA) |
+		 PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA)) ? 52 : 48,
+
+	/*
+	 * D24.2.195 TTBR_ELx BADDR:
+	 *
+	 * Bits A[(x-1):0] of the stage 1 translation table base address are
+	 * zero. Address bit x is the minimum address bit required to align the
+	 * translation table to the size of the table. x is calculated based on
+	 * LOG2(StartTableSize), as described in VMSAv9-128. The smallest
+	 * permitted value of x is 5.
+	 *
+	 * R_KBLCR requires the table to be aligned to its own size.
+	 *
+	 * SMMU S2TTB additionally says: In addition, a 64-byte minimum
+	 * alignment on starting-level translation table addresses is imposed
+	 * when S2TG selects 64KB granules and the effective S2PS value
+	 * indicates 52-bit output. In this case bits [5:0] are treated as zero.
+	 */
+	PT_TOP_PHYS_MASK = GENMASK_ULL(51, 5),
+};
+
+/* Common PTE bits */
+enum {
+	ARMV8PT_FMT_VALID = BIT(0),
+	ARMV8PT_FMT_PAGE = BIT(1),
+	ARMV8PT_FMT_TABLE = BIT(1),
+	ARMV8PT_FMT_NS = BIT(5),
+	ARMV8PT_FMT_SH = GENMASK(9, 8),
+	ARMV8PT_FMT_AF = BIT(10),
+
+	/* 64K FEAT_LPA: OA[51:48] in bits[15:12], Figures D8-14/15 */
+	ARMV8PT_FMT_OA52_LPA = GENMASK_ULL(15, 12),
+	/* 4K/16K FEAT_LPA2 (DS=1): OA[51:50] in bits[9:8], Figures D8-14/15 */
+	ARMV8PT_FMT_OA52_LPA2 = GENMASK_ULL(9, 8),
+
+	ARMV8PT_FMT_CONTIG = BIT_ULL(52),
+	ARMV8PT_FMT_UXN = BIT_ULL(53),
+	ARMV8PT_FMT_PXN = BIT_ULL(54),
+	ARMV8PT_FMT_NSTABLE = BIT_ULL(63),
+};
+
+/* S1 PTE bits */
+enum {
+	ARMV8PT_FMT_ATTRINDX = GENMASK(4, 2),
+	ARMV8PT_FMT_AP = GENMASK(7, 6),
+	ARMV8PT_FMT_nG = BIT(11),
+};
+
+enum {
+	ARMV8PT_SH_IS = 3,
+	ARMV8PT_SH_OS = 2,
+
+	ARMV8PT_RGN_NC = 0,
+	ARMV8PT_RGN_WBWA = 1,
+
+	ARMV8PT_AP_UNPRIV = 1,
+	ARMV8PT_AP_RDONLY = 2,
+};
+
+enum {
+	ARMV8PT_MAIR_ITEM = GENMASK_U32(7, 0),
+
+	ARMV8PT_MAIR_ATTR_IDX_NC = 0,
+	ARMV8PT_MAIR_ATTR_IDX_CACHE = 1,
+	ARMV8PT_MAIR_ATTR_IDX_DEV = 2,
+	ARMV8PT_MAIR_ATTR_IDX_INC_OCACHE = 3,
+
+	ARMV8PT_MAIR_ATTR_NC = 0x44,
+	ARMV8PT_MAIR_ATTR_WBRWA = 0xff,
+	ARMV8PT_MAIR_ATTR_DEVICE = 0x04,
+	ARMV8PT_MAIR_ATTR_INC_OWBRWA = 0xf4,
+};
+
+/* S2 PTE bits */
+enum {
+	ARMV8PT_FMT_S2MEMATTR = GENMASK(5, 2),
+	ARMV8PT_FMT_S2AP = GENMASK(7, 6),
+};
+
+enum {
+	SZLG2_4K = 12,
+	SZLG2_16K = 14,
+	SZLG2_64K = 16,
+};
+
+enum {
+	/*
+	 * For !S2FWB these code to:
+	 *  1111 = Normal outer write back cacheable / Inner Write Back Cacheable
+	 *         Permit S1 to override
+	 *  0101 = Normal Non-cachable / Inner Non-cachable
+	 *  0001 = Device / Device-nGnRE
+	 * For S2FWB these code to:
+	 *  0110 Force Normal Write Back
+	 *  0101 Normal* is forced Normal-NC, Device unchanged
+	 *  0001 Force Device-nGnRE
+	 */
+	ARMV8PT_MEMATTR_FWB_WB = 6,
+	ARMV8PT_MEMATTR_OIWB = 0xf,
+	ARMV8PT_MEMATTR_NC = 5,
+	ARMV8PT_MEMATTR_DEV = 1,
+
+	ARMV8PT_S2AP_READ = 1,
+	ARMV8PT_S2AP_WRITE = 2,
+};
+
+#define common_to_armv8pt(common_ptr) \
+	container_of_const(common_ptr, struct pt_armv8, common)
+#define to_armv8pt(pts) common_to_armv8pt((pts)->range->common)
+
+/* Runtime granule accessors */
+static inline u8 armv8pt_tgsz_lg2(const struct pt_state *pts)
+{
+	return to_armv8pt(pts)->tgsz_lg2;
+}
+
+static inline u64 armv8pt_fmt_oa48(unsigned int tgsz_lg2)
+{
+	return GENMASK_ULL(47, tgsz_lg2);
+}
+
+/*
+ * The generic implementations cannot be used if PT_GRANULE_LG2SZ is dynamic.
+ */
+static inline unsigned int armv8pt_table_item_lg2sz(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+
+	return tgsz_lg2 + (tgsz_lg2 - ilog2(PT_ITEM_WORD_SIZE)) * pts->level;
+}
+#define pt_table_item_lg2sz armv8pt_table_item_lg2sz
+
+static inline unsigned int armv8pt_pgsz_lg2_to_level(struct pt_common *common,
+						     unsigned int pgsize_lg2)
+{
+	unsigned int tgsz_lg2 = common_to_armv8pt(common)->tgsz_lg2;
+
+	return (pgsize_lg2 - tgsz_lg2) / (tgsz_lg2 - ilog2(sizeof(u64)));
+}
+#define pt_pgsz_lg2_to_level armv8pt_pgsz_lg2_to_level
+
+static inline bool armv8pt_has_system_page_size(const struct pt_common *common)
+{
+	return common_to_armv8pt(common)->tgsz_lg2 == PAGE_SHIFT;
+}
+#define pt_has_system_page_size armv8pt_has_system_page_size
+
+static inline pt_oaddr_t armv8pt_oa(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+	u64 entry = pts->entry;
+	pt_oaddr_t oa;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2)) {
+		/* 4K/16K with DS=1: OA[49:granule] direct, OA[51:50] in [9:8] */
+		oa = entry & GENMASK_ULL(49, tgsz_lg2);
+		oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52_LPA2, entry))
+		      << 50;
+	} else {
+		oa = entry & GENMASK_ULL(47, tgsz_lg2);
+		if (PT_SUPPORTED_FEATURE(PT_FEAT_ARMV8_LPA) &&
+		    tgsz_lg2 == SZLG2_64K)
+			oa |= ((pt_oaddr_t)FIELD_GET(ARMV8PT_FMT_OA52_LPA,
+						     entry))
+			      << 48;
+	}
+	return oa;
+}
+
+static inline pt_oaddr_t armv8pt_table_pa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_table_pa armv8pt_table_pa
+
+/*
+ * Return a block or page entry pointing at a physical address. Returns the
+ * address adjusted for the item in a contiguous case.
+ */
+static inline pt_oaddr_t armv8pt_item_oa(const struct pt_state *pts)
+{
+	return armv8pt_oa(pts);
+}
+#define pt_item_oa armv8pt_item_oa
+
+static inline bool armv8pt_can_have_leaf(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+
+	/*
+	 * Tables D8-16/17 (4K), D8-26/27 (16K), D8-35/36 (64K).
+	 *
+	 * When FEAT_LPA2, one additional level gains block descriptors:
+	 *   4K:  ARM level 0 (pt 3) gains 512GB blocks
+	 *   16K: ARM level 1 (pt 2) gains 64GB blocks
+	 * ARM Level -1 (pt 4) is always table-only.
+	 */
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2)) {
+		if (tgsz_lg2 == SZLG2_4K && pts->level > ARML0)
+			return false;
+		if (tgsz_lg2 == SZLG2_16K && pts->level > ARML1)
+			return false;
+		if (tgsz_lg2 == SZLG2_64K && pts->level > ARML2)
+			return false;
+	} else {
+		if (tgsz_lg2 == SZLG2_4K && pts->level > ARML1)
+			return false;
+		if (tgsz_lg2 == SZLG2_16K && pts->level > ARML2)
+			return false;
+		if (tgsz_lg2 == SZLG2_64K &&
+		    pts->level > (pts_feature(pts, PT_FEAT_ARMV8_LPA) ? ARML1 :
+									ARML2))
+			return false;
+	}
+	return true;
+}
+#define pt_can_have_leaf armv8pt_can_have_leaf
+
+/* Number contiguous entries that ARMV8PT_FMT_CONTIG will join at this level */
+static inline unsigned short
+armv8pt_contig_count_lg2(const struct pt_state *pts)
+{
+	unsigned int tgsz_lg2 = armv8pt_tgsz_lg2(pts);
+
+	if (tgsz_lg2 == SZLG2_4K)
+		return ilog2(16); /* 64KB, 32MB */
+	else if (tgsz_lg2 == SZLG2_16K && pts->level == ARML2)
+		return ilog2(32); /* 1GB */
+	else if (tgsz_lg2 == SZLG2_16K && pts->level == ARML3)
+		return ilog2(128); /* 2M */
+	else if (tgsz_lg2 == SZLG2_64K)
+		return ilog2(32); /* 2M, 16G */
+	return ilog2(1);
+}
+#define pt_contig_count_lg2 armv8pt_contig_count_lg2
+
+static inline unsigned int
+armv8pt_entry_num_contig_lg2(const struct pt_state *pts)
+{
+	if (pts->entry & ARMV8PT_FMT_CONTIG)
+		return armv8pt_contig_count_lg2(pts);
+	return ilog2(1);
+}
+#define pt_entry_num_contig_lg2 armv8pt_entry_num_contig_lg2
+
+static inline pt_vaddr_t armv8pt_full_va_prefix(const struct pt_common *common)
+{
+	if (pt_feature(common, PT_FEAT_ARMV8_TTBR1))
+		return PT_VADDR_MAX;
+	return 0;
+}
+#define pt_full_va_prefix armv8pt_full_va_prefix
+
+static inline unsigned int armv8pt_num_items_lg2(const struct pt_state *pts)
+{
+	/*
+	 * It is not allowed to call pt_num_items_lg2() at the top level, this
+	 * API restriction is specifically an optimization avoid overheads
+	 * dealing with concatenated tables here.
+	 */
+	PT_WARN_ON(pts->level == pts->range->top_level);
+	return armv8pt_tgsz_lg2(pts) - ilog2(sizeof(u64));
+}
+#define pt_num_items_lg2 armv8pt_num_items_lg2
+
+static inline enum pt_entry_type armv8pt_load_entry_raw(struct pt_state *pts)
+{
+	const u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 entry;
+
+	pts->entry = entry = READ_ONCE(*tablep);
+	if (!(entry & ARMV8PT_FMT_VALID))
+		return PT_ENTRY_EMPTY;
+	/* R_RWMFF/Table D8-48: ARM level 3 has only Page descriptors */
+	if (pts->level != ARML3 && (entry & ARMV8PT_FMT_TABLE))
+		return PT_ENTRY_TABLE;
+
+	/* Must be a block or page, don't check the page bit on level 0 */
+	return PT_ENTRY_OA;
+}
+#define pt_load_entry_raw armv8pt_load_entry_raw
+
+static inline void
+armv8pt_install_leaf_entry(struct pt_state *pts, pt_oaddr_t oa,
+			   unsigned int oasz_lg2,
+			   const struct pt_write_attrs *attrs)
+{
+	unsigned int isz_lg2 = pt_table_item_lg2sz(pts);
+	u64 *tablep = pt_cur_table(pts, u64);
+	u64 entry;
+
+	if (!pt_check_install_leaf_args(pts, oa, oasz_lg2))
+		return;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		entry = ARMV8PT_FMT_VALID |
+			(oa & GENMASK_ULL(49, armv8pt_tgsz_lg2(pts))) |
+			FIELD_PREP(ARMV8PT_FMT_OA52_LPA2, oa >> 50) |
+			attrs->descriptor_bits;
+	else {
+		entry = ARMV8PT_FMT_VALID |
+			(oa & GENMASK_ULL(47, armv8pt_tgsz_lg2(pts))) |
+			attrs->descriptor_bits;
+		/* 64K FEAT_LPA: OA[51:48] in [15:12] */
+		if (pts_feature(pts, PT_FEAT_ARMV8_LPA))
+			entry |= FIELD_PREP(ARMV8PT_FMT_OA52_LPA, oa >> 48);
+	}
+
+	/*
+	 * R_RWMFF/Table D8-48: at ARM level 3 the leaf is a Page descriptor
+	 * with bit[1]=1; at other levels it is a Block with bit[1]=0.
+	 */
+	if (pts->level == ARML3)
+		entry |= ARMV8PT_FMT_PAGE;
+
+	if (oasz_lg2 != isz_lg2) {
+		u64 *end;
+
+		entry |= ARMV8PT_FMT_CONTIG;
+		tablep += pts->index;
+		end = tablep + log2_to_int(armv8pt_contig_count_lg2(pts));
+		for (; tablep != end; tablep++) {
+			WRITE_ONCE(*tablep, entry);
+			entry += (u64)1 << isz_lg2;
+		}
+	} else {
+		WRITE_ONCE(tablep[pts->index], entry);
+	}
+	pts->entry = entry;
+}
+#define pt_install_leaf_entry armv8pt_install_leaf_entry
+
+static inline bool armv8pt_install_table(struct pt_state *pts,
+					 pt_oaddr_t table_pa,
+					 const struct pt_write_attrs *attrs)
+{
+	u64 entry;
+
+	if (pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+			(table_pa & GENMASK_ULL(49, armv8pt_tgsz_lg2(pts))) |
+			FIELD_PREP(ARMV8PT_FMT_OA52_LPA2, table_pa >> 50);
+	else {
+		entry = ARMV8PT_FMT_VALID | ARMV8PT_FMT_TABLE |
+			(table_pa & GENMASK_ULL(47, armv8pt_tgsz_lg2(pts)));
+		/* 64K FEAT_LPA: OA[51:48] in [15:12] */
+		if (pts_feature(pts, PT_FEAT_ARMV8_LPA))
+			entry |= FIELD_PREP(ARMV8PT_FMT_OA52_LPA,
+					    table_pa >> 48);
+	}
+
+	return pt_table_install64(pts, entry);
+}
+#define pt_install_table armv8pt_install_table
+
+static inline void armv8pt_attr_from_entry(const struct pt_state *pts,
+					   struct pt_write_attrs *attrs)
+{
+	u64 mask = ARMV8PT_FMT_AF | ARMV8PT_FMT_UXN | ARMV8PT_FMT_PXN |
+		   ARMV8PT_FMT_ATTRINDX | ARMV8PT_FMT_AP | ARMV8PT_FMT_nG |
+		   ARMV8PT_FMT_S2MEMATTR | ARMV8PT_FMT_S2AP;
+
+	/* Tables D8-52/53: with LPA2 bits [9:8] are OA[51:50], not SH */
+	if (!pts_feature(pts, PT_FEAT_ARMV8_LPA2))
+		mask |= ARMV8PT_FMT_SH;
+	attrs->descriptor_bits = pts->entry & mask;
+}
+#define pt_attr_from_entry armv8pt_attr_from_entry
+
+static inline void armv8pt_clear_entries(struct pt_state *pts,
+					 unsigned int num_contig_lg2)
+{
+	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
+	u64 *end = tablep + log2_to_int(num_contig_lg2);
+
+	for (; tablep != end; tablep++)
+		WRITE_ONCE(*tablep, 0);
+}
+#define pt_clear_entries armv8pt_clear_entries
+
+static inline unsigned int armv8pt_max_sw_bit(struct pt_common *common)
+{
+	/*
+	 * Stage 2 bit [55] is the NS field in Realm state (Table D8-53),
+	 * so it cannot be used as a software bit for stage 2.
+	 */
+	if (pt_feature(common, PT_FEAT_ARMV8_S2))
+		return 2;
+	return 3;
+}
+#define pt_max_sw_bit armv8pt_max_sw_bit
+
+static inline u64 armv8pt_sw_bit(unsigned int bitnr)
+{
+	if (__builtin_constant_p(bitnr) && bitnr > 3)
+		BUILD_BUG();
+
+	/*
+	 * D8.3 Tables D8-50 through D8-53: Bits marked IGNORED in Table
+	 * descriptors and "Reserved for software use" in Block and Page
+	 * descriptors.
+	 *
+	 * Bits [58:56] are safe for all descriptor types at both stage 1
+	 * and stage 2.  Bit [55] is additionally available at stage 1
+	 * (Table D8-52).
+	 */
+	switch (bitnr) {
+	case 0 ... 2:
+		return BIT_ULL(56 + bitnr);
+	case 3:
+		return BIT_ULL(55);
+	default:
+		PT_WARN_ON(true);
+		return 0;
+	}
+}
+#define pt_sw_bit armv8pt_sw_bit
diff --git a/drivers/iommu/generic_pt/fmt/defs_armv8.h b/drivers/iommu/generic_pt/fmt/defs_armv8.h
new file mode 100644
index 00000000000000..d6c74dc3b574cf
--- /dev/null
+++ b/drivers/iommu/generic_pt/fmt/defs_armv8.h
@@ -0,0 +1,23 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (c) 2024-2026, NVIDIA CORPORATION & AFFILIATES
+ *
+ * VMSAv8-64 translation table in AArch64 mode
+ *
+ */
+#ifndef __GENERIC_PT_FMT_DEFS_ARMV8_H
+#define __GENERIC_PT_FMT_DEFS_ARMV8_H
+
+#include <linux/generic_pt/common.h>
+#include <linux/types.h>
+
+typedef u64 pt_vaddr_t;
+typedef u64 pt_oaddr_t;
+
+struct armv8pt_write_attrs {
+	u64 descriptor_bits;
+	gfp_t gfp;
+};
+#define pt_write_attrs armv8pt_write_attrs
+
+#endif
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 07ef1c8341a4f8..dd97304ffaccc5 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -162,6 +162,42 @@ enum {
 	PT_FEAT_AMDV1_FORCE_COHERENCE,
 };
 
+struct pt_armv8 {
+	struct pt_common common;
+	u8 tgsz_lg2;
+};
+
+enum {
+	/* Use the upper address space instead of lower */
+	PT_FEAT_ARMV8_TTBR1 = PT_FEAT_FMT_START,
+	/*
+	 * Large Physical Address Extension (for 64k):
+	 *  - HW must support a 4TB block descriptor
+	 *  - HW must decode the additional OA in PTE bits[15:12]
+	 */
+	PT_FEAT_ARMV8_LPA,
+	/*
+	 * Large Physical Address 2 Extension (for 4/16k):
+	 *  - HW must support TSZ=12 (52 bit VA)
+	 *  - HW must support a 5 level walk (table level -1), 4k only
+	 *  - HW must support 16 entries in ARM L0, 16k only
+	 *  - HW must support a 512GB block descriptor in 4k
+	 *                       64GB block descriptor in 16k
+	 *  - HW must decode the additional OA in PTE bits[9:8]
+	 *  - HW must support DS=1
+	 */
+	PT_FEAT_ARMV8_LPA2,
+	/*
+	 * Large Virtual Address Extension (for S1 64k):
+	 *  - HW must support S1.TSZ=12 (52 bit VA)
+	 */
+	PT_FEAT_ARMV8_LVA,
+	/* Use the Stage 2 format instead of Stage 1 */
+	PT_FEAT_ARMV8_S2,
+	/* For S2 uses the Force Write Back coding of the S2MEMATTR */
+	PT_FEAT_ARMV8_S2FWB,
+};
+
 struct pt_vtdss {
 	struct pt_common common;
 };
-- 
2.43.0

