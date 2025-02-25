Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7537C21149F;
	Tue, 25 Feb 2025 19:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512404; cv=fail; b=VytenCgEB4OdfXTjqU1bA476uzpB4ppMjq/oX48wdlF9Gj8I3UPOS/Caxc6Jaxj9GkKUD9b27KxyzP/Eh91Qd3NXQGP3nVbdpnUrpMlGJRu4jDvDVKUZhF7S5SG2nkv82SHSxlWydoNrqrI4McVIWd9sdaKyT5QX6DQ7QXjHCWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512404; c=relaxed/simple;
	bh=ogvvwA/tIsBYRtt0lDTtipXUDUqA/0zHgYO3cLmp5jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=j6kF12++yo7U3WCxat+rce2Sca60I+adWv9YoSYZMAgnBzkbB1MIwN8cTw/l4xUncqB5M/woLIRBbsSvArVZo9bWHvZxUH60sstos+fRNh8EeZ0rnMTIqS86m3dQdtNQFpFhA+0OO+LeoaGvqubG5VD7lVspg2KIjlJo9DtMImo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X4TESPgO; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X4TESPgO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L9I21fvTC2TLwfktupYoloI6NJhe67jDZTv9n6EGkhjUpFSDQ6chiHVASTNA54/ee69r8t0NcV+7hMVbeyEi5oCYebDHCY3u+c+hozvEtxcfAhTxyzVgV589LzVuQSx4Jgx9C27llgqOfStnVpgx4iPkr4rQU5Ji38cT5PH1WNS/NyGNsoiziqMDLbxT0oYnzHvD0NWomSLR5kuKREZyoVqPDpwsxgg3W7YjJoc07F1QA2/kIpzl7TY9p7sk3arcq9QJBeg0B9baPjadTxFbA1+ffWp9mp8mJwshamidEcJ2e7unbNdd+ep8Rd04/UDdd3vCDuSA/l0ZE0m5lXoVPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X6A6UusVFQr82ajZ1Da/82uCTzVd280yf5a82o0SYc0=;
 b=gRsSulc0+n8HxY1byXWVmTKteUAGQtHhdF4gFXQIjlc27txn/FNA9XOdCMMJdVhu3gh8ktHgSNQHBDKtDsuQ3oA3nbGQbZkGbWlUxBlMW8KppDAycZtNHFqIDxLKnFPDtdagMvVuCYO21anAUQUlPsBJKKO0vty17CKGLBO15Baevzbh2WfCO3gyHjxJV0Iq91tyCff8QPMKDPh6Cg680euJhq71NdZhvOQg5KfOpxQ2gBZ2ZIWLZjxohNvJBfU2bT4FC1zDmtQkXdhcuQTWAbyi9IWcrwahlnKNM7oAZgHOQ8NBiM5tjWrshbeR43wXGYhTylmVqb8ycKqw11AH2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X6A6UusVFQr82ajZ1Da/82uCTzVd280yf5a82o0SYc0=;
 b=X4TESPgOOGF4eoXeHkMwzhoZXxnuSGEVx4bWhv3yNtEGNj+qYPyG/EDHNSXggibQO9sCPjeUvkOKILRSrconxkD7uB4+7YKki9XvrwNYvs9+spOi2P8RkJqHXfsY/RZxAxGR2gn2kbUn8LTIpP6gGtP+DpYUJASNxheX8R1yC/vmGo+nDj/nW6+b0F8aPZuQzgaPXjgAeSBBL+nUlz49Icjohxv3uiYi3FWE1Q1VlxoSTzwiO1pXqtGmQww1yHw7C8kQK2fXwld8tMSYopHicwcS8qxIWiWS88ieIsipWZPt1vVvCGWni9cG/fQE+NaKGpkP0HVhxMuPuTiNELvKXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:53 +0000
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
Subject: [PATCH v3 16/23] iommu/pages: Allow sub page sizes to be passed into the allocator
Date: Tue, 25 Feb 2025 15:39:33 -0400
Message-ID: <16-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0124.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: e9caceef-3c0a-4b0c-76a7-08dd55d42834
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?chapDkHQoWPLnyE2BBOooMxyS5ATOD6O6cv3OssuKUNAaGWfAWk/jEULPF6J?=
 =?us-ascii?Q?bf/DC/GJxrLOSlcaGe+Rke3vTRW7qJ+a/jq4Hvy7vBrTYePlhmoEKuf1YVHg?=
 =?us-ascii?Q?5eJho7QysWRIlDMAQgB0MguQdSXPQmZhZyDeB46suQJ/O4q/0uUwTGlSv/wt?=
 =?us-ascii?Q?JPSBJezrLeYUyPTocWjFWlltE2fTAOWEhpn62R57Bf/wqpETEGEvRWLMVGU5?=
 =?us-ascii?Q?9f9/mj7HfhNEZP+31At4KoriYnt+DMFJxbMppQO78sbYhQmZsRCinZM1gwA9?=
 =?us-ascii?Q?yK+Icx0lFDx7GJk/EpGu00mybNwo9fcAMYAbU3PfgDOIGvcZStvLz6aPHE0b?=
 =?us-ascii?Q?3im6ox/ZzxZy8h1y/RbnVQ8dDy1PaLhK/L5MS7fVVPdL5SuloUg2+vtISwEp?=
 =?us-ascii?Q?8jcWkFsAnNNKg5O7EymAD3NULl3J8+HY2DiKPAya7FzRfF/edJiOfJlaYfxq?=
 =?us-ascii?Q?iU2HI3Uy9wuVw+/DGd4wApvLX3+Wc/00Q7zFyKRpaxXEea2o6/xpZcrPkPDG?=
 =?us-ascii?Q?z42Vn71IX8YBhVJYb47zGZBlkRkLHj7I6ZLX16TlIqAAM9XQmqgt7rYkKuwu?=
 =?us-ascii?Q?/Iqrmt2x+qOQxgqjvTM/VmDlGyDZ8pqH8p9rp9URZUfmQdOHwSbLPJZe8R1D?=
 =?us-ascii?Q?0HGMCjSogsxLsfeHrGKOdzzcbDKc5s6dAq4VNwoIGWpCfMTyrOH8qmuSFN7w?=
 =?us-ascii?Q?yjyR4QiIsVH7yfEr1cuq2vjScieZleibqrkHCLkpu4k27G/rcWVChLUsMkJs?=
 =?us-ascii?Q?Wo251CzCoycl4/0CAG65C4Ym0RIjq6lA8FptPQYThG+ErGoyw4bwxsoHNxxF?=
 =?us-ascii?Q?N8/u/cHGKpakms49WMd/t8ReqM07mxi/S1wcYeiSuow6dX5pYOxrpgI+WvJD?=
 =?us-ascii?Q?/6fFxBz6JvBguFDLgAqdkf90js5qAa/58ubdev3GgTD2GvKcTXVV9pnFb8ra?=
 =?us-ascii?Q?zPrK3tUwduZYzZgrsdQhNuCbYo+tceji+FkmTWEep2B088Ma/tIzJE17Pxwr?=
 =?us-ascii?Q?WQB/Bfn/fVqm6vMEIQRGRRYd5Iuucnu18Vx4XEDvFwOZhpCxyY4xlEnU1Y4O?=
 =?us-ascii?Q?8/Wy2iOSL92tY36ja8H7PA5YjBXd4ofSqrqeVx7Nr1JphkF6QcmlC+KBmJ/3?=
 =?us-ascii?Q?aIvocSxxVCdVOfk4gWFOM11rYenlEwh4y12wehoiY6c4W5kB9ueG0Q0Kh+Z4?=
 =?us-ascii?Q?zN4kZGC5AdZdif3gZ5o3gfxNhiclNl7DhzBVNKbykgOymPdQcdIBGZHRXakw?=
 =?us-ascii?Q?xKK44FtJZvUr2I2CBvMrcjr0CrkVbnYnvm4RvUfYUWa3kEhJue5FhJi2TgkX?=
 =?us-ascii?Q?SzzYNJ6edO9EyiZlmKwDAjThR1Kt36WeaFTHBN3N+zh2APcNNDbq9UWVp9d0?=
 =?us-ascii?Q?KDfF2q8oUDPdQx1jAvzW8km3GHOzxa+BBeMPoALLZnwP9UlKs4qIqiRnZ7EA?=
 =?us-ascii?Q?8fWg3i6zchY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Min4LbN7JYo/IuA39ayLsZY6n/Hnc67MYtvhVj9AgXYh/YQYjGPR6KhMu9GJ?=
 =?us-ascii?Q?xcasg6VF63P1WQDNpHuDe4jHcbuUwCKKwJRSaJ9JLHO1a8Zv/5j57bQBcPGr?=
 =?us-ascii?Q?np27xSYXn3bWfnhfcTRamaXcbRoJUxVJcwD9/Sdv3Rzi+n4UpIqo0caFKQ+P?=
 =?us-ascii?Q?ingm02J/HmKcLmRiDkjPHMCy4AcXDf2cdzoXtTocsQbihi4buX89b70ipYIn?=
 =?us-ascii?Q?XrihrhKFKFlCZvS9UO49DD2r1kUHMdrH3qlzFWLHkYCYsyM8tR4XsYNq04Nv?=
 =?us-ascii?Q?m7A6XCJSJy14ZpeH+8qSIc+wKiU7YuHK+g1y9mPHWVqVnzLFpMtapL501Urr?=
 =?us-ascii?Q?QTBUP59cxAyn56VhkA0IfY430ZiL1MvioohjrBSfDPQKM41Girh8sTd1kDCm?=
 =?us-ascii?Q?x8otIQoKEdpZAUIpLTqugDbeYp2a+ULuHkf7+cngfJ3UYplYtd1sfkCaryh4?=
 =?us-ascii?Q?sv/9yVz4lB1IgOtDVc5cOiUwYtErt81rC08J6AUQScgugRGTCvPGany0s3SW?=
 =?us-ascii?Q?FqfHu/Wli8k9x/D0O1Bd6zB3f2Nq0oXCyt7FXG9pcq7HptJve3gA0drqNNjU?=
 =?us-ascii?Q?gemnfopuQuR21HsmHsSPT4DOXqur/FV6UYvM4X/RTBBTZgHaEFOkuUBzmMfy?=
 =?us-ascii?Q?PzdgAdBkiO6CMQUoLCwwZW6Tba7/AXzq0iX8PkG9MVIaWZZyKMq9bx7h211c?=
 =?us-ascii?Q?R1RhjN7uWKFhclHjRc+spKd8bubLtDIhGPEJFPgJwJZ8tpwrhl6WD1+Ibllq?=
 =?us-ascii?Q?9fSSINBHF8l5FyJ6Sln1mSBk5GJMjROkHZRmZNc0BJgF/8+k5b0TSEWdi1mU?=
 =?us-ascii?Q?RlpGsRTKD/8EPf4qCYhOtVKg6Uee+4LKLFvbEHQyyuysBSAwJWGHnpFLEeM/?=
 =?us-ascii?Q?1T8Aiulovo9Mtx1FRpcAX0C8dhVI9/0S5OcX2BKmrXTnk85b5dHBtjayGFaW?=
 =?us-ascii?Q?NV8Wfg60VCjH/6c5S89mxzinq1NOuMlfXcX32MBtsm4DCDd2siSO05sd+W1q?=
 =?us-ascii?Q?BOF7V5w73lSb1EuGw3vXCbR6GATaiZXqguQTWw3ZYR+AM8G8m+PfnxUrlRdU?=
 =?us-ascii?Q?1Fgap0PAHwAqeB1RhVEY1FXiaX6vOdzK9s23P+S712ihiV/B5XqcmXFLdUMs?=
 =?us-ascii?Q?O1YPk+Ltz71CeZ9UPI+6Vkxpnihmpv6PO0Q/SygercDdrSRSmbkOR2Gq+i1w?=
 =?us-ascii?Q?jgzFEstu7GEcQpGwlePASSYUisT5hb16VaCHiZiAaVKQCctYzJg7adwvdLR8?=
 =?us-ascii?Q?ueK5kRd+z7Ps9fH8QLFO5TMV0jdv1oQC/u0MaeHhc6prYARYGMpxMyYqT3pm?=
 =?us-ascii?Q?Pbll/rmW2lBdiw+qGJmKpB32Tvz/6APJe55gnaX+XO1Kh1YonfjbbwwsgunB?=
 =?us-ascii?Q?fkws4O1N2XMublBg7Ksa2C/Qa12LQNo5LXzITEuL6FnK3HDhzTXWXi0JDJDe?=
 =?us-ascii?Q?H7AEMAyOUQJL+5bZ+1TmQU5o9cP4QcSoUvBLLlJh9YSdrMGJUAt6Q+9WJRfE?=
 =?us-ascii?Q?liIHXPnYybGHJkFz9xjj5bW29eK9h2U8mZCIIrYM7ZAUTbdoUFmuNgsQa2Cm?=
 =?us-ascii?Q?Cz/m5Eg12D9pCBIK1IJoyHZSH1yRosbO+16AO1Vl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9caceef-3c0a-4b0c-76a7-08dd55d42834
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:45.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rek95SU6I31uuKmBx6ij4XQSUga59Ey7weVvujMoPHJp8EqmEzU5YbWdP+78+Ihf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

Generally drivers have a specific idea what their HW structure size should
be. In a lot of cases this is related to PAGE_SIZE, but not always. ARM64,
for example, allows a 4K IO page table size on a 64K CPU page table
system.

Currently we don't have any good support for sub page allocations, but
make the API accommodate this by accepting a sub page size from the caller
and rounding up internally.

This is done by moving away from order as the size input and using size:
  size == 1 << (order + PAGE_SHIFT)

Following patches convert drivers away from using order and try to specify
allocation sizes independent of PAGE_SIZE.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 29 +++++++++++++++---------
 drivers/iommu/iommu-pages.h | 44 ++++++++++++++++++++++++++++++++-----
 include/linux/iommu.h       |  6 ++---
 3 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index a7eed09420a231..4cc77fddfeeb47 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -23,24 +23,32 @@ IOPTDESC_MATCH(memcg_data, memcg_data);
 static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
 
 /**
- * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
- *                          specific NUMA node
+ * iommu_alloc_pages_node_sz - Allocate a zeroed page of a given size from
+ *                             specific NUMA node
  * @nid: memory NUMA node id
  * @gfp: buddy allocator flags
- * @order: page order
+ * @size: Memory size to allocate, rounded up to a power of 2
  *
- * Returns the virtual address of the allocated page. The page must be
- * freed either by calling iommu_free_pages() or via iommu_put_pages_list().
+ * Returns the virtual address of the allocated page. The page must be freed
+ * either by calling iommu_free_pages() or via iommu_put_pages_list(). The
+ * returned allocation is round_up_pow_two(size) big, and is physically aligned
+ * to its size.
  */
-void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
+void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 {
-	const unsigned long pgcnt = 1UL << order;
+	unsigned long pgcnt;
 	struct folio *folio;
+	unsigned int order;
 
 	/* This uses page_address() on the memory. */
 	if (WARN_ON(gfp & __GFP_HIGHMEM))
 		return NULL;
 
+	/*
+	 * Currently sub page allocations result in a full page being returned.
+	 */
+	order = get_order(size);
+
 	/*
 	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
 	 * alloc_pages_node() did.
@@ -61,12 +69,13 @@ void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
 	 * This is necessary for the proper accounting as IOMMU state can be
 	 * rather large, i.e. multiple gigabytes in size.
 	 */
+	pgcnt = 1UL << order;
 	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, pgcnt);
 	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, pgcnt);
 
 	return folio_address(folio);
 }
-EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
+EXPORT_SYMBOL_GPL(iommu_alloc_pages_node_sz);
 
 static void __iommu_free_desc(struct ioptdesc *iopt)
 {
@@ -82,7 +91,7 @@ static void __iommu_free_desc(struct ioptdesc *iopt)
  * iommu_free_pages - free pages
  * @virt: virtual address of the page to be freed.
  *
- * The page must have have been allocated by iommu_alloc_pages_node()
+ * The page must have have been allocated by iommu_alloc_pages_node_sz()
  */
 void iommu_free_pages(void *virt)
 {
@@ -96,7 +105,7 @@ EXPORT_SYMBOL_GPL(iommu_free_pages);
  * iommu_put_pages_list - free a list of pages.
  * @list: The list of pages to be freed
  *
- * Frees a list of pages allocated by iommu_alloc_pages_node().
+ * Frees a list of pages allocated by iommu_alloc_pages_node_sz().
  */
 void iommu_put_pages_list(struct iommu_pages_list *list)
 {
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index f4578f252e2580..3c4575d637da6d 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -46,14 +46,14 @@ static inline struct ioptdesc *virt_to_ioptdesc(void *virt)
 	return folio_ioptdesc(virt_to_folio(virt));
 }
 
-void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
+void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size);
 void iommu_free_pages(void *virt);
 void iommu_put_pages_list(struct iommu_pages_list *list);
 
 /**
  * iommu_pages_list_add - add the page to a iommu_pages_list
  * @list: List to add the page to
- * @virt: Address returned from iommu_alloc_pages_node()
+ * @virt: Address returned from iommu_alloc_pages_node_sz()
  */
 static inline void iommu_pages_list_add(struct iommu_pages_list *list,
 					void *virt)
@@ -84,16 +84,48 @@ static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
 	return list_empty(&list->pages);
 }
 
+/**
+ * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @order: page order
+ *
+ * Returns the virtual address of the allocated page.
+ * Prefer to use iommu_alloc_pages_node_lg2()
+ */
+static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
+					   unsigned int order)
+{
+	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
+}
+
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
  * @gfp: buddy allocator flags
  * @order: page order
  *
  * returns the virtual address of the allocated page
+ * Prefer to use iommu_alloc_pages_lg2()
  */
 static inline void *iommu_alloc_pages(gfp_t gfp, int order)
 {
-	return iommu_alloc_pages_node(NUMA_NO_NODE, gfp, order);
+	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp,
+					 1 << (order + PAGE_SHIFT));
+}
+
+/**
+ * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @size: Memory size to allocate, this is rounded up to a power of 2
+ *
+ * Returns the virtual address of the allocated page.
+ */
+static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
+{
+	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
 /**
@@ -102,10 +134,11 @@ static inline void *iommu_alloc_pages(gfp_t gfp, int order)
  * @gfp: buddy allocator flags
  *
  * returns the virtual address of the allocated page
+ * Prefer to use iommu_alloc_pages_node_lg2()
  */
 static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
 {
-	return iommu_alloc_pages_node(nid, gfp, 0);
+	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
 }
 
 /**
@@ -113,10 +146,11 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
  * @gfp: buddy allocator flags
  *
  * returns the virtual address of the allocated page
+ * Prefer to use iommu_alloc_pages_lg2()
  */
 static inline void *iommu_alloc_page(gfp_t gfp)
 {
-	return iommu_alloc_pages_node(NUMA_NO_NODE, gfp, 0);
+	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, PAGE_SIZE);
 }
 
 #endif	/* __IOMMU_PAGES_H */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 166d8e1bcb100d..b74c9f3dbcce1d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -327,9 +327,9 @@ typedef unsigned int ioasid_t;
 #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
 
 /*
- * Pages allocated through iommu_alloc_pages_node() can be placed on this list
- * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
- * can be used this way!
+ * Pages allocated through iommu_alloc_pages_node_sz() can be placed on this
+ * list using iommu_pages_list_add(). Note: ONLY pages from
+ * iommu_alloc_pages_node_sz() can be used this way!
  */
 struct iommu_pages_list {
 	struct list_head pages;
-- 
2.43.0

