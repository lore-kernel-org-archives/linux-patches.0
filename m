Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485EE211469;
	Tue, 25 Feb 2025 19:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512405; cv=fail; b=Wblzt4akRgvdzHKWm/ec2IGUVb2g8i3nQ3ln7I5FMkVYQ7ulxCNiJCa/NoNeJBrU56vd4Iqj09WoxAS05wUesYd/vLc+jWCSjd7Y0Nfs3MPR//Cw5/s0y1WOi8XhUzMwusEYzrSJYHEi0b9F8Y5tKA/WvQFKcu0xHa/FRUrFFto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512405; c=relaxed/simple;
	bh=XoveCJejIRXy1Zec7B3NsW2mJlGmC3DCyhto/Jc1ejk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hrOmsfJd6LpEsL/EW/cqlsB1pJuxqJyqhrs0ypRJNiMIRd812oRE2793dk8Z2wwaivHYKlBuHGFtVFElGRoEcs5IEnQNWot2XIhsfwrMtPMXmPHXGAJVxuFSianMNHXQ0OXif4KuzYZcu2Hhbn0FFbDO4wFvtq+0w0D1K25j0aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O1yVZvmc; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O1yVZvmc"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SumnYdUPeyyhPCKC81kjdz+IaBscpcPHZzfSwMxEPuICP7I688pTvscxRi1J1MpuvUhcJYpDFjsDSFmJcZVpku01ASet20WHn/9twyQvcEvWVe1OlzxDDBp4IovJ0bibdEczKSbxxpYmeedR522oP/Hofop6uYNXpZ192ge2gdRhS7eWV45Baf3kEoCLnh2+qtIRyxEvXOYo//WcTvx9ortAb5en47i/PV1orFPJb2Ljd0uZXdfclWFy9uOj4rTCMwlTqrIoxwykcLdc5icD7JlPUtwQz1lpLz1sqlOsPL88WTnZG8KjCElC4iSQsBIyiWUfk//3VUsIDMCC9YkOOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t14qw9rsbrQKKTV4F+UBlPyihRaqJ51xQT1Ck4nXJN8=;
 b=IlOzD95CAEpzJKpkGx7xobC44uDeCCdtCt3ft5fYfXweDBHvhrE1OGLa3c5tsTyrreuIMFHcIY1S0+ijhGotNEEP1SJfjetw5pZSj5aRMjQ8PUPkwYtYQsPUG2M9ARizUmw1+yGp35wkLtg6jyZoxronRLVSfGZK+hg0pE9QQ6YJ9OrAq/t51dLn1ESEbMHDvOKatcZvoB2XRaWuEOh+XNZLIcuwYNbGnHF1RFHQW2hOIhscPiA/A4cU3WSWGUYXV6kCtJWsMNYzSdSf7+r9j0CLShB/3ROrjzeSyeb3fdzVH8WN1gg9MoQAaBokAG78mmC55WQJHvWD4RYlRY6AFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t14qw9rsbrQKKTV4F+UBlPyihRaqJ51xQT1Ck4nXJN8=;
 b=O1yVZvmcXG27J3SfYi+/ZALk9agOr9bxgsuOH+s1zYUIfaC9r/UNDLpqZIvJchBtSqiUwNy48ts4kO12jp5dcFq7VfJYm2uS5a8yKN9QtqDGMP+cXiRCNs63k5hEEPHuSnuaA2OxR41AIdTuD5d0YZ/7xoSq5mPjqdT0oOPN/suqjb1urkCnY1WwaxV6gffXfFi2UWQP2uIbwJqnBT35BZ1ElD9c2u+P2R5xjJ6WIjegUrnXoKdkvuun6zB+ahSYCf5HA0gBqhNVHO1wsnx3zxUzVHS4RPMVWSkhqA/aZrgcpWLD8I2ORA0Cs+xarvHhx8pOuzO1DUe9mFnNDOwqOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org,
	linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hector Martin <marcan@marcan.st>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>
Cc: Bagas Sanjaya <bagasdotme@gmail.com>,
	Joerg Roedel <jroedel@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 07/23] iommu/pages: De-inline the substantial functions
Date: Tue, 25 Feb 2025 15:39:24 -0400
Message-ID: <7-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0130.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: 84fb99ca-5682-464e-1023-08dd55d4282e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1f6q3rjUD19VZQadwVunWAZcoFkxlruVGl5Py4MJn6nfcRQWifkCovBQ4YC3?=
 =?us-ascii?Q?rd20Ehb9tKLplCCRl38asr28RM/g/ez26cS5zWrxTT52mE41Nju+A5EIGXvC?=
 =?us-ascii?Q?+2ItKGJOqmm4pTI5T23TBUckOr0m4rPHUR6gXSb8tAp+eYZJB39DPQN49M6A?=
 =?us-ascii?Q?oYeA7kjWPQTzn5U/FxX7rFqrmcGXZNNQWdDNDC3wEE1qczk/UQFLVVXyK1hB?=
 =?us-ascii?Q?0hZPvIcrnuvLmx/obJIZY88vCb7cdFIU5AeCJcPhF2C4sBlI3BwvmY7y2b2M?=
 =?us-ascii?Q?HllUQO/9qRWtf4eWBUlQJA6E6aUldAR44AUv7SrmZQ9XHsSmDXmXCg6c9oU/?=
 =?us-ascii?Q?zWpRDnrHyrOR6sC6oSbnMPu790gi/kemncrtM8b4vYdssJEdnFWEkc4MJFD2?=
 =?us-ascii?Q?plB0uCa6i7QgORDjNYQhVDAQVH+7H4RFAcANXkhLSmbL0rkhgxSURKCEGXuj?=
 =?us-ascii?Q?bdpSq6hJcItuGu+haQ2p4lXckZE/M+0ZYTwQIWJ7+3hBNGCzsUoEJs06VDyL?=
 =?us-ascii?Q?wHspEEQHa0zxbXQNZN9LGvYl/wlAfiixT2qMamME7FE4urLsKlnxYRB6wfoQ?=
 =?us-ascii?Q?XdfuUzB2qczWJiXjJRDqgGrA/sU49VPE6hNlumxjrcFsx/cJji9BgZSunMOt?=
 =?us-ascii?Q?GBkb1nURIk15RLJaPAT5YIgWOzcI2DymsQZ0tJMQy9zKDrnRRFkaFF78l4pf?=
 =?us-ascii?Q?7SIXYs8ew5qU1kzT3Rl8S2+Z0G7E3/5u7jipc2rCIgzvmWWOxkz5wmleuw/J?=
 =?us-ascii?Q?B+xHlDXOD1XFC+/UQ1tIQgGNQK71yBM1o918ZwKWlmY27KO+0uru/TCUvoYh?=
 =?us-ascii?Q?13j3677O2rGYc2Hs9Dm8eQfq4CqpMgSg2MrC9CXv9yBJnX0OFPh/mZEZOoOQ?=
 =?us-ascii?Q?TGeD4YYh6qtY9CBR1Vki6SsF7z7zJNaVYTVWau6jUrm9DqzHiqSE+qOoGKJ5?=
 =?us-ascii?Q?3rGCL2IbUjctfixiyrYiWliBwhxLwm/xU57rFmPpsksm4r1DSPKBMYHtu0F0?=
 =?us-ascii?Q?rn6Qt+6Zo39kc0Xm2e4mnSqXcW7SflBFxJBZZqCI+qQfxLV/25RfefTmAvEl?=
 =?us-ascii?Q?XSRjQavR3zWPvYj5QQvoSFfLHTrm9E5UHEgCkVLFs5p7RMYEh9fG/g0dyvE6?=
 =?us-ascii?Q?e70FUfCmt25WuEeeClc7bwGNUdQSt8+kthgjPwSv4LsNJOXBzqHUqvPcA70R?=
 =?us-ascii?Q?5Jq3rm4SEzajV3pjhbW9FkqmwKnk3Ln9dF3nFM4wSEX6arnzobR8DST2c9x3?=
 =?us-ascii?Q?LuefQOt9IH/Afg21YfLrsvO04N2E4/d2YcuSaEO7YyostmGAPH/GlcnTpgqn?=
 =?us-ascii?Q?wRTmywjf7bQWgwTCDePa4ul76v7V3QtNJ6sFHvJ6pKOEhHrG5hzjGwUJBhSc?=
 =?us-ascii?Q?pO+KS9Rh1eJeiWrqXHgkRFtuYu610IzFKqDURMUXBAxPCA78Z9FtODhpsDVJ?=
 =?us-ascii?Q?f1WZEsl/dNs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HRajH4MfmrsT8G+A/E3fGKlHiNYYJuW8Q5UcfAJQGZjS1dQTNM0N3V7VioJg?=
 =?us-ascii?Q?clxJUlzTWLhAO/dJTxMCs8s+O6atuGUuQ1S6BxaWVNx4jE42mGoQfOtNqwPP?=
 =?us-ascii?Q?olDzFskZgIzpm9Hdy7zdhVslp2K3gQYTTVv7VeiC6nE4c1r2V9Jcp1BZwQpH?=
 =?us-ascii?Q?wXy6Gu03M8x3TuYsKY39GeF4mFdrPWEDhfhlGBmuIGjp6myNgHLZFIxIPybb?=
 =?us-ascii?Q?UEYUP1AaO1UQpi/UNo108Lggu7aU+59fbN1jNR/W8bi+pyFSVqMWjcJhDaGG?=
 =?us-ascii?Q?qMZJ+u9mLFZqWtLtynAUth3TWJCkTcSv6wDjwpEhuYXlDFH4k9gDdfLTLaHu?=
 =?us-ascii?Q?WIwSejbe/oBgfhg4Yqqv0w98vSdgJFSk3RIehxmlPDqt2Jt7Vhf68uSN1f6M?=
 =?us-ascii?Q?5HVD7q1n/5QMUUImepgv+dgJaDi1DqRwbJ1NdknPu2M9GO4FSuf4GbVCcRT3?=
 =?us-ascii?Q?wbAZXC5SYrc1Cd+EpW5ajrqco1UNgyF/AI9vpUVC3gdtUdU0h9ZwnPXFn0il?=
 =?us-ascii?Q?1OBo6yMVJtToiZG8udwFNczbnXVZwExXnX+lcsOQEsfCSgPLh4c6tnZBTXcS?=
 =?us-ascii?Q?QyNtPgEwMOnhjJ3qUleSm1SMyjDG/gBe5mANvDeVMgD4LwixF1ePRgqtoAtF?=
 =?us-ascii?Q?LUd5moYBiNohOBj8N50EehE7KuxpDeWmjesQ05qizDRXXlAqFUg+vqMjfaQ3?=
 =?us-ascii?Q?w0yS/dEXk4s7jZ0E/qez41jJ+fdMrE4CIjz1xS3e3S7+BvbpV0y5CPpG5X9n?=
 =?us-ascii?Q?DmYPsN6DjMWOmKN0CCjDyLeHuqBUAHNFxrVQI6NbQjh+pz128jQzI0IxsbCD?=
 =?us-ascii?Q?NDXl3j8Fa6RwAy+zzYKeYTp2OPG1eNX578zNbnOJlFx3izATWp8i0qVv6a/R?=
 =?us-ascii?Q?goQGTZZXUpFDBVM7Zwplj0JJOTBKJk1KaJXhVvhCUVg9bY9kNpx14nMYnucI?=
 =?us-ascii?Q?qvISTX6837VKgGyCgiDFPSh55LJXV3smeLYdrD75cRxBs2LpXM8qaDJTGehn?=
 =?us-ascii?Q?2EhgG2IstZReO5DRLhzhv8VDlZz1+m1TmlIQE6JF58s7F263hOdVDKXCR3X+?=
 =?us-ascii?Q?/MRSa514VmsM4MmIoFq9iDYQCMRVCK7g+P/GDY2XYvalsom4Rcp2JS3ejAvn?=
 =?us-ascii?Q?m0O1Vibt10L1WAHUCYTQBoT7o70ks0pgg+h8hYKA2w2ky3JTzIMoRfaqGDeW?=
 =?us-ascii?Q?JCF9zbmC/zV7Uzdh3cKqM0BcWClgV9KaFJuynss8GKTgwv6RoO4gPLt3GD/C?=
 =?us-ascii?Q?7rguqOHDjS+eepEYkdOLNJJgcZqXTvsU+wBrAs7MCLYNcVVyNRAF++si1LpR?=
 =?us-ascii?Q?ehaOJa1blEhX6vDNC2MatzznP5LyTpbuq/2M5f5Nratu5ZMJNXkQvnPISw+X?=
 =?us-ascii?Q?fvtrzYq9zsvwn4+iMb1neGS6DCUWFdOz867u0LkHyO75e3e/1/jeu6dsUxQm?=
 =?us-ascii?Q?y/R+yaX4kXZx5OExDt1fYdDr7LMKzqm6+5ogzX9dC1+bp5JqF5ITI+7NAw2a?=
 =?us-ascii?Q?MVxA4iSZrRxM7/O6h7Tpwj9bPtBoQYu0nTzq81YH857zh3UODpBIRCYIhVg6?=
 =?us-ascii?Q?hBaqeaeDZeQis2sE7YTX4hLhMtMQBJrDwJHKGi+q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84fb99ca-5682-464e-1023-08dd55d4282e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:45.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R0DNdeV7ddTL0JGuzxTx5qE8r+oxFCeGwdbotG/WsV8he3mVUq3BZD1injRIKqsN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

These are called in a lot of places and are not trivial. Move them to the
core module.

Tidy some of the comments and function arguments, fold
__iommu_alloc_account() into its only caller, change
__iommu_free_account() into __iommu_free_page() to remove some
duplication.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Makefile      |   1 +
 drivers/iommu/iommu-pages.c |  84 +++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h | 103 ++----------------------------------
 3 files changed, 90 insertions(+), 98 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.c

diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 5e5a83c6c2aae2..fe91d770abe16c 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-y += amd/ intel/ arm/ iommufd/ riscv/
 obj-$(CONFIG_IOMMU_API) += iommu.o
+obj-$(CONFIG_IOMMU_SUPPORT) += iommu-pages.o
 obj-$(CONFIG_IOMMU_API) += iommu-traces.o
 obj-$(CONFIG_IOMMU_API) += iommu-sysfs.o
 obj-$(CONFIG_IOMMU_DEBUGFS) += iommu-debugfs.o
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
new file mode 100644
index 00000000000000..31ff83ffaf0106
--- /dev/null
+++ b/drivers/iommu/iommu-pages.c
@@ -0,0 +1,84 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2024, Google LLC.
+ * Pasha Tatashin <pasha.tatashin@soleen.com>
+ */
+#include "iommu-pages.h"
+#include <linux/gfp.h>
+#include <linux/mm.h>
+
+/**
+ * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @order: page order
+ *
+ * Returns the virtual address of the allocated page. The page must be
+ * freed either by calling iommu_free_pages() or via iommu_put_pages_list().
+ */
+void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
+{
+	const unsigned long pgcnt = 1UL << order;
+	struct page *page;
+
+	page = alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
+	if (unlikely(!page))
+		return NULL;
+
+	/*
+	 * All page allocations that should be reported to as "iommu-pagetables"
+	 * to userspace must use one of the functions below. This includes
+	 * allocations of page-tables and other per-iommu_domain configuration
+	 * structures.
+	 *
+	 * This is necessary for the proper accounting as IOMMU state can be
+	 * rather large, i.e. multiple gigabytes in size.
+	 */
+	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
+	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
+
+	return page_address(page);
+}
+EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
+
+static void __iommu_free_page(struct page *page)
+{
+	unsigned int order = folio_order(page_folio(page));
+	const unsigned long pgcnt = 1UL << order;
+
+	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
+	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
+	put_page(page);
+}
+
+/**
+ * iommu_free_pages - free pages
+ * @virt: virtual address of the page to be freed.
+ *
+ * The page must have have been allocated by iommu_alloc_pages_node()
+ */
+void iommu_free_pages(void *virt)
+{
+	if (!virt)
+		return;
+	__iommu_free_page(virt_to_page(virt));
+}
+EXPORT_SYMBOL_GPL(iommu_free_pages);
+
+/**
+ * iommu_put_pages_list - free a list of pages.
+ * @head: the head of the lru list to be freed.
+ *
+ * Frees a list of pages allocated by iommu_alloc_pages_node().
+ */
+void iommu_put_pages_list(struct list_head *head)
+{
+	while (!list_empty(head)) {
+		struct page *p = list_entry(head->prev, struct page, lru);
+
+		list_del(&p->lru);
+		__iommu_free_page(p);
+	}
+}
+EXPORT_SYMBOL_GPL(iommu_put_pages_list);
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index fcd17b94f7b830..e3c35aa14ad716 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -7,67 +7,12 @@
 #ifndef __IOMMU_PAGES_H
 #define __IOMMU_PAGES_H
 
-#include <linux/vmstat.h>
-#include <linux/gfp.h>
-#include <linux/mm.h>
+#include <linux/types.h>
+#include <linux/topology.h>
 
-/*
- * All page allocations that should be reported to as "iommu-pagetables" to
- * userspace must use one of the functions below.  This includes allocations of
- * page-tables and other per-iommu_domain configuration structures.
- *
- * This is necessary for the proper accounting as IOMMU state can be rather
- * large, i.e. multiple gigabytes in size.
- */
-
-/**
- * __iommu_alloc_account - account for newly allocated page.
- * @page: head struct page of the page.
- * @order: order of the page
- */
-static inline void __iommu_alloc_account(struct page *page, int order)
-{
-	const long pgcnt = 1l << order;
-
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, pgcnt);
-}
-
-/**
- * __iommu_free_account - account a page that is about to be freed.
- * @page: head struct page of the page.
- * @order: order of the page
- */
-static inline void __iommu_free_account(struct page *page)
-{
-	unsigned int order = folio_order(page_folio(page));
-	const long pgcnt = 1l << order;
-
-	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
-	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
-}
-
-/**
- * iommu_alloc_pages_node - allocate a zeroed page of a given order from
- * specific NUMA node.
- * @nid: memory NUMA node id
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the virtual address of the allocated page
- */
-static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
-{
-	struct page *page =
-		alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
-
-	if (unlikely(!page))
-		return NULL;
-
-	__iommu_alloc_account(page, order);
-
-	return page_address(page);
-}
+void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
+void iommu_free_pages(void *virt);
+void iommu_put_pages_list(struct list_head *head);
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
@@ -104,42 +49,4 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
 }
 
-/**
- * iommu_free_pages - free pages
- * @virt: virtual address of the page to be freed.
- *
- * The page must have have been allocated by iommu_alloc_pages_node()
- */
-static inline void iommu_free_pages(void *virt)
-{
-	struct page *page;
-
-	if (!virt)
-		return;
-
-	page = virt_to_page(virt);
-	__iommu_free_account(page);
-	put_page(page);
-}
-
-/**
- * iommu_put_pages_list - free a list of pages.
- * @page: the head of the lru list to be freed.
- *
- * There are no locking requirement for these pages, as they are going to be
- * put on a free list as soon as refcount reaches 0. Pages are put on this LRU
- * list once they are removed from the IOMMU page tables. However, they can
- * still be access through debugfs.
- */
-static inline void iommu_put_pages_list(struct list_head *page)
-{
-	while (!list_empty(page)) {
-		struct page *p = list_entry(page->prev, struct page, lru);
-
-		list_del(&p->lru);
-		__iommu_free_account(p);
-		put_page(p);
-	}
-}
-
 #endif	/* __IOMMU_PAGES_H */
-- 
2.43.0

