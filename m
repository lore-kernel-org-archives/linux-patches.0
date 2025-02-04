Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0B8218AA8;
	Tue,  4 Feb 2025 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694119; cv=fail; b=GXg7dsTo6C94NfFwjy9P+1JEw/lh88iq6FVIpCRCAmkB+wcv5pH0PWise2Q+qcwWvW19nPUbuWctkeb8gWYhYDjndGoXGHMtMxMN13cmxktE/E1/o6YayYbPLEtMfUKdM9haIrvnWjuATcr6wy9lCdPpdu4f2vro4JOjD2DKWiI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694119; c=relaxed/simple;
	bh=Yj5Z0Fx6r3/mhQd+H2Prx75xg3cBg6e2ojN1W+mFSZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hdC3kMHnJzH2/4WNI0Uvr+lFOJ4N5Sj32V8gpTgT3HTKXj03Oowt5L83395mDVmJRoK+jWghGQFncqox+bCOCo7uEjtcwdCk9yfXdo6kXADh7uVZHyA02PdxUFcAktp8zyJeAG1vNikIoF2KPLt2YZYqNVLgpoM/KBtzg+XRKGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jyN+MUlk; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jyN+MUlk"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tvVGHSdZMlK/hMF+WOKUpqGRe+Agz0X80DH05ep7d0/na/CNgNde6qX3dFYJ0tzV+DdrK58l/Eu+kNjC7N+XzqqAhNOe4YDnMM2TES2NK5EIVfoc43fBqp9hgUlvJKCaySCCtbPsyJ5JuI09nPuVvlR5RcB26fyBc7mABMK6vskar/h7hjqRks9EY4VwtK/XPiHx48TFPYtwKgCjxu4qtAe4xupkWlV+rwm50madVu5xK2EELLANaUEr+MO4/q36sVziLQFOzw+JYZ42DTXfzyhyh6pAk4jQXxT7AR6k2MrXgTTZA9phqUQHfOqn6TS3kRccZ4EK6mzDZwZZ8ttUfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAlfrFK8+1fOZhSDoLW+fnhg1BB82j87BA7quiVLBas=;
 b=xlXsx0KvVLj/HJ2Hc62Rgv99br/iKeBRMkxbJCbMKK62yqqkc5gfnZbvU15INP2B/G/iJqSdei+wc0ej5Mmm+oNRgXR3mbOLoVajaRnbSKRNjzwg6gERHi9XP9VW6HgPEIwA6NyM1mbXiBBbBy8ZuJdV5uTeQshQ6R0+YsBTk928mJ2R7vhPKo5KMy6g5J2iejhuKQ1SarkH69JGIyI25k9eRiU++UNrp83seG5H9l8S64VNs7vnijTFOJ+Ep88dQTYEjKqTslHRERyTN/Blad2Lo6nBvinVtWuDG092PD9forvQHAKmwQTlbrya3nzFylaJignLH8pva80Kx8yDGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xAlfrFK8+1fOZhSDoLW+fnhg1BB82j87BA7quiVLBas=;
 b=jyN+MUlkQ+ptifqdrL7Rxe3cMfsGs5FpIl/eVWQc/Vn+wblfdEFkoScRjhunx++F8Y9NUskL5UBRKiY9QjVP3k0Vr4sHtukOK0P/5UGgJ7rsrqOR9j/ay5aQ8vNOZAufCF330AI65ZOw+ZLEA8kWqTBgDebaNJSnjFlSPw3e7eIt7Z5wsQUPudmdmZISI/b/MEiQUXXS3LAZy1e00wHgTeVdY1BXsL1/R/5jrxaANsR82umGxG40L1OhINYZmUUe4Uzq9Z0V5CHy6HWNWmJ7HudLrcqqNnmKltndH1YoymAUUv4QT4KJ2h+QkxLn6jxV0+3ndEVnqsq0K3gOvJwsEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8226.namprd12.prod.outlook.com (2603:10b6:208:403::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:11 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:11 +0000
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
Subject: [PATCH 06/19] iommu/pages: De-inline the substantial functions
Date: Tue,  4 Feb 2025 14:34:47 -0400
Message-ID: <6-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0028.namprd14.prod.outlook.com
 (2603:10b6:208:23e::33) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 10ae9e99-4ea1-4802-76d6-08dd454aa4a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n9qXpLPioRXiyQRkFOYZvzTqFFm0QtaEPCLwnLKBWxWfQ3RpxLcFZroCAmYp?=
 =?us-ascii?Q?4yx+kHPjjHCEqM2uz+D/ppAzcru70+tBH6v1J5cll7LgHG40qGJGhYXQVsYr?=
 =?us-ascii?Q?Ak0pabDyWC0xaw6N7yEQPNb9an38Q1x0N8s7dOt7DGPuRnxHvBsTCJyQYeTO?=
 =?us-ascii?Q?cqm7FGT/NxOuoHD7Jgl8z+vNbenRBIavoeym0VtkaKsV6Ek4MpEVZtBBOoy7?=
 =?us-ascii?Q?uSUi6baAUBB1PsFxq5qk2F3ISg1fXkLWl5n2vOrOL4ka2md9eZnCQLBpcxH7?=
 =?us-ascii?Q?BjnEGKTf4pSDHYnyBbP6ws6qdwWbROfHf3ISpIelPt/2nntg9UAs4BymYL0m?=
 =?us-ascii?Q?34+QNLBT317urijPrXv3ZIVSREJsWHVywuTTTdGe3d5dYLB0lJteFxrrj3XY?=
 =?us-ascii?Q?qtLBG73NlZFyZavuTWGI+0I1t2Im130SHlejCVkhecwvaU8vb9zQy/rELhVk?=
 =?us-ascii?Q?tZLXnRPESIpwV6ErReNSW5Vl0Zo4lhYFYVvzSoooEZVw9lprS0AuXDlJoOg+?=
 =?us-ascii?Q?1IlX2hDaPTMeZj34nyYaGqiF+OvPtQexiuZZv0SVuHThDAv+8gwLOhrFh0xv?=
 =?us-ascii?Q?zEtE49o2y0fDsKQeFUJSYi1CmUQGfbH/7UKRqPoRDoEBaeMcPZZOyDW90lFV?=
 =?us-ascii?Q?DrmXYJQgauzPx47kHyp5EqiT9swH4EzjpotLu3g8jeJDmCTiWbQLqLLYk/t6?=
 =?us-ascii?Q?0iniH9e3Az0N/hIwqYqEzUhQxYykysEE84icT0M/YkO+QxpA7vwWuGiQ0vAY?=
 =?us-ascii?Q?W31cIPzkQ5eR5HD8DTsSe8CHl9XiHmyZi0q5JytF+4pWQBnUokbTZXJ7tqJv?=
 =?us-ascii?Q?2i3yiscfsaZee0/gsh8Omfyap3JdgEgIVFhLYiYu2DJfPfe02RnjRFvHN6Pr?=
 =?us-ascii?Q?FtV+i/6bjNHLIa4+OXLX0o53G6+H5r6wGhD5wuI7TtVvMO2I+Z4Ds0CCy3IJ?=
 =?us-ascii?Q?7gR1pw741RQ1iogcwlMzKHFx+Oq+rLsmQu58YF8yPZMvPRRuvq0UHhKGhXbz?=
 =?us-ascii?Q?6FJPUMmqUS08Vx6S/o9pGaPe/xK9ztqmxtrPZzNqmkJyFku5y2F4SPuOM4Wn?=
 =?us-ascii?Q?Dug0DnTQ5V8OuCOGXZaj3xXHRiLu+ofEOLdZOUNLJvZ4BNDEhrs5gKPjfNhO?=
 =?us-ascii?Q?oIEyxuyRntU0NQPD5WIdICUICpQJqZKXd9URYZgMxuXs82kxTzAFm3ObF3bH?=
 =?us-ascii?Q?DHWFLn+ykvEUdPAglNOX6BgVQzLOP8BKOf50mjN34bbCZjIoYY556v+HYGmL?=
 =?us-ascii?Q?D09nMZYgPkuYRL6rWr+dZHaM8suEeU4syK2WpNo/14D9nAr+5h5IZqaBhrWX?=
 =?us-ascii?Q?aV2EzmN6WJF2eLas8nObjDZPi3xGJxjuSgwso99ilYd92TraWcXDoJkVHT8S?=
 =?us-ascii?Q?6pwsvDzT+xsxeLx7yqTBu3pacFKg8C4g0NP9S9UsEWf1S512Xe84xYfBhVzp?=
 =?us-ascii?Q?2dLaUPIT9y8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y8b2DOF4lerJ0pH9OGtSZO9nnGpJ1K3o1yh1zeoA32LgBj6ZI/eWzCDj2bO2?=
 =?us-ascii?Q?Ak6wcs0XsOeo4Vtx55fbwXEtsBswgv7Y7Txd5UFrBaE3cL/g5XBwRH7jdNlo?=
 =?us-ascii?Q?nuq7Ul17j5lG4+V+Uc2m9pOllBdCnB6yWRM18ze1SSqB75Uv/NnaYVosXUb/?=
 =?us-ascii?Q?HhHJCqI5DvGHsETWEdJzJCF+nvHyo19pz2C+XQRsFWG+J6nAibXtxxs/oJju?=
 =?us-ascii?Q?5GZOEPCVTKFEVxEO1H9J+a+w1wE3RK+EKzuA3afAcsdzw8ceY4UogAt7kQlu?=
 =?us-ascii?Q?WmLIlc1dykUSE92pD2mTHGL1+zyeo+r0+EvfSSSScPTP66NIBO/bgvWbCI3e?=
 =?us-ascii?Q?U/JJrzVNA8eDElyl2boeQIqEqgSyg550NysmE0Po1xYMVg+RIXHesqGWNxE8?=
 =?us-ascii?Q?3m5SAiNHp7Kk+q/AsqpkXSEBlhPKYVD0OY23C2d7sS3tjVdgQC1EEVnTKV2+?=
 =?us-ascii?Q?qBallcY+vjnRXGHgdMgZ/jO92LLVu6UzxnS+AKwjjfio8HH37yr8n2vbdxYq?=
 =?us-ascii?Q?9xxe136CWxVyctMiBEFu1nSXV5ErmEhw/a1Y7pa+rhEV3U/uF8XOoLviLmzI?=
 =?us-ascii?Q?B1/1Tcp7KuQ9KioEkjoFL6OY0iR067CJYICfWTgv/FaXTNNU/kMhwwDLlm/v?=
 =?us-ascii?Q?WOIAjD3ns5tRs+uCcOC6486BZB2JiqNtTUAgMX92p89K7SktmN2goJCZReeG?=
 =?us-ascii?Q?+zFGHERD0mctB+dL0EFyDU8TWt6Zu2UgzV8iRR1fDAnj5AZX5eaDNzlVNnEd?=
 =?us-ascii?Q?hj1mMzGJeElBGb+jJ5X9PCvv9vqP9upZH9/LKH0OKQJkr7GpDaw3sCAIkDWC?=
 =?us-ascii?Q?+kvgyQcR0SAinojOoI8lQboBvx3POv02fhHpQpzU7HTbdMrN4UX8/yxylelw?=
 =?us-ascii?Q?gPAv5Maj7kJCrYyv2VTskpu6ffJBq2ZLR7H1hHdU2vIJlw7fFlyTJKvdFZ9K?=
 =?us-ascii?Q?qrSC1143P0TEHIz1sA23ZJggU08meCF1XF6uXqMrWEw9OX1+Xz166j+o5CNc?=
 =?us-ascii?Q?qOKD/OPDB0ZhkbRVH3SMaBa5b90856g8hV2X0kNUOQLVvH3xH7slErU5soSu?=
 =?us-ascii?Q?jd/I4doqrnoxwilG3JR/KLNfYyhEn0aq2FNvcLocV8DtF6zMKRy1ILoeq2RN?=
 =?us-ascii?Q?OdLSthS8Y4tnyuNqO70OZg03nKs8TtlPk5ZCGnfy15fc+kqZzwj44roGCOyA?=
 =?us-ascii?Q?NMzU7S1xHZEHgkMYgTDcGniXo1hW2RMk4ajwxz1mhO+nGd1/6KkzO5w12R2f?=
 =?us-ascii?Q?b6chysVGbiJOZzMH9PoB8rNjlo2lKW7uSiUAknYhi+a2oJbLalar6PbN4jwY?=
 =?us-ascii?Q?a/4g28qrxQOCSX0o1u+DStsBS3EB36VrYH7uISmQ20dbLV9FoykZThFBGcuN?=
 =?us-ascii?Q?zVsCfn7MUcabiqcV1Dy2mh47BUj450qRC5libL+pv6ONkOyxs9fNpXLWQiyj?=
 =?us-ascii?Q?sGTir4fmkenSqlZDv3huCwbD7jtxLZl/j2CwNdHr8sgfCI6DMOpN1AC3gD1/?=
 =?us-ascii?Q?480gOzyUxoxbbzzTuvLVnF00G2pFbJ/9bWebVNeNZ3RuxqtSZYnQkd42dJX2?=
 =?us-ascii?Q?qPoFCIzZkLDRzjyz2qM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ae9e99-4ea1-4802-76d6-08dd454aa4a0
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:05.0347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lp941imDkWsqoCsh1gjC+kvfnoAfedHOnlmMVrB47aBam2zoa4Z4eUFx6T+oZB8D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8226

These are called in a lot of places and are not trivial. Move them to the
core module.

Tidy some of the comments and function arguments, fold
__iommu_alloc_account() into its only caller, change
__iommu_free_account() into __iommu_free_page() to remove some
duplication.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/Makefile      |   1 +
 drivers/iommu/iommu-pages.c |  84 ++++++++++++++++++++++++++++++
 drivers/iommu/iommu-pages.h | 101 ++----------------------------------
 3 files changed, 90 insertions(+), 96 deletions(-)
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
index 00000000000000..0fece3758408ae
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
+ * freed either by calling iommu_free_page() or via iommu_put_pages_list().
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
+ * iommu_free_page - free page of any  order
+ * @virt: virtual address of the page to be freed.
+ *
+ * Frees the allocation from iommu_alloc_pages_node()
+ */
+void iommu_free_page(void *virt)
+{
+	if (!virt)
+		return;
+	__iommu_free_page(virt_to_page(virt));
+}
+EXPORT_SYMBOL_GPL(iommu_free_page);
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
index b15e0f85b3f739..6045e1f90a40cb 100644
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
+void iommu_free_page(void *virt);
+void iommu_put_pages_list(struct list_head *head);
 
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
@@ -104,40 +49,4 @@ static inline void *iommu_alloc_page(gfp_t gfp)
 	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
 }
 
-/**
- * iommu_free_page - free page of any  order
- * @virt: virtual address of the page to be freed.
- */
-static inline void iommu_free_page(void *virt)
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

