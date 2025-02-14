Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743B6267706;
	Fri, 14 Feb 2025 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552890; cv=fail; b=Hk6CQlq+M7eE1P/7BalQdii7xu/O0z+4xAm0WazlNDMC2NR22yemDiZ7bl6jToXguo11TGMUtlvGcZNNA+smjkNF3MUoMdT0h6vYCiD2iWE5l4uvjzJhlZdeVOpaNvshzQH31whPtGqy5J761nkXbhEU0ChnPns2E1vsgoEebk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552890; c=relaxed/simple;
	bh=7yJ7d8bS9ncI3ve1dTOFO3seHQPC8RX3yZcnaeB7Zi8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Mkt/l9qgVedaJFQOTp7Xxxo9UfwOKj7s6igKlDXUI/r/7ccvp+l3kuvaCYQ+iQabzOE9A70vY2z7m+XD99LB53EECihFBbKIt+o5bEROIP+vnzyhiTEVZH8KBsj6qOgsuA2JWZGfGvsw/UvTdcnGEsHlBEvl0lt/9gQbivlT/Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cDwT8mwf; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cDwT8mwf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSl/+62fEWPt7arSqyaVsSHWBy3HbJRn2ayWJnuW12h9PJYlpMXVD0F6dwGFuN00oJ9869E5KCiZi7eFGImmnRGAfFff0kjg95TrsZDRlhnepWipFGX2b2XUTgd7saVW+1x44I3RUATtxVa2b81ksyMxQO/iG8XsFZKdWvFJ8wgVal19Sl3x5huIPXF0eEvrTcrL/hbLMHoZMzJIQ/UzmUfLACb4s4M9vQQwown/zl7KLThKkF0h9O+alR5pZwlkgT7/Ux9C9ARQUQpI1n4+16Y5Ka2CFl4U2NdopkiVcEVncqs8E2ONmOpkGjCIjdi9fo/CBOeCNeuUt9xoLXv3vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mas+9VJdd+VVBrRCB5moPF5PiMpgodcWyc8/IEiSRLo=;
 b=Yp/vyHQDaVjyqzSANu7lohM+4f1k6kV5Ru68C2c+YGloR+VPXrR8kFFx8C6BBLaVSsrBxCmuz4mbJAUvS9LLmeBGUmOq7ZsX2BiiEOF/DOW6Tawdg/zQkeNVdHQHUFpqbmh+jggzDb1hRAjWxGQU8mD4+XS+rr/MZdRMlJ4u4WhqnsRs2VkyRn1Qu4So6FSAZO9zxOA2cT0W53IH3Tf/9NDDrX9gJOX9C3iNe5CBgoSyI2xKRuJ3FBNZYeKtkvGPT0mGrUwBy1B5l0Dt+MAebNE3+PMnsWSxJrOvojAMwLHb1zUCSC+qUVfgU+z9mmBUC/O7coNil6j/QIp/2Xppcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mas+9VJdd+VVBrRCB5moPF5PiMpgodcWyc8/IEiSRLo=;
 b=cDwT8mwfyqdSgpQMOWMtINTdzQJLhzeCAzW5X1dzBM5Q/thHDc0BBWUynuc5VPpD5M6MyhMYKlGQJUmK8AkXu6yoUvUkd5E/FBVOr7kvUxIqYFP9PDO3M6SD+wkKOUG1a7DQg9T84rypZRzouoS5Jr2vqK0rRr8k3hHSdVOZ9Sx2XSP/3fOPSz3rX6fwO8L+dnm+43JhETjwyzAPSpwo9Iuos68fcixRwdsOp50dVP6PH+PpKNBGJFx2QYx4XoYCqF7dX/O/xw8qW8F8y975lCh0eL8xtk2D75EFt/7tBMV5bTM/jOGCg+UCFBVhtBE4MPLmF5+o2gosvxA/UEnk5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.12; Fri, 14 Feb
 2025 17:08:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:00 +0000
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
Subject: [PATCH v2 00/23] iommu: Further abstract iommu-pages
Date: Fri, 14 Feb 2025 13:07:33 -0400
Message-ID: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0109.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 082434e3-02e5-4e3c-793c-08dd4d1a216d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8t2OU0Jf+jzuaiQOfU7t5bfCFmcBJTRVZjItHO0wsfZLZWPwfTzQqyhS42Ig?=
 =?us-ascii?Q?R4NGTkywFN8k5wnPiX6LbIOqeCI/QNoqHqKXVJ/rJkRS91vMb66Q9W/3IYvY?=
 =?us-ascii?Q?0XJ0UJqVrhEHDiM4Fts+46KK6ePeJZHgRKIU6OqssMw3ppU5gp+58MyjxjwH?=
 =?us-ascii?Q?WNSIhuPQMnq145Qh6UpwGw+1pN8zjenn82Y6tNxrnmPemRBKXb1BAtH2f5Dq?=
 =?us-ascii?Q?XXnODPbdrvC9CDs56wt1Esb2CJSOP6QDlH3QIQu/rBClWsODr/BoqVTVPQRC?=
 =?us-ascii?Q?WXGRpfpA2pG4Fy4XZzwjFAQzbsE/Yhpepc59nGkqkJWdMpDg3/QDwqU3q60O?=
 =?us-ascii?Q?id65gDGlQmgUfI2q4OCS3QvcIGd7ROh8EpVbF4cddkj6SXlmGeZkRFD9kWlO?=
 =?us-ascii?Q?cxFn6sGCZ4eEO6mVYKhVOOCRQMPxrHFdA5R1qb382YDgtwKe5FaSRvzY5Hzu?=
 =?us-ascii?Q?WudmE1rc7hj70rTVhCqdOhpriuJ20h0SVJxVPxdvJ0GrEjfiY9Txyc5dXo2l?=
 =?us-ascii?Q?fLrIPThLQSJNAkw9UW33HOWuF0hRsn18d9kElxNr1pqfH3vjV4mqnkjDSY2V?=
 =?us-ascii?Q?LJOCADZojBQVSZGt1t5JClV1dgJIGpL+9L9Ljb36Ed3HGK/MSySH0tYjwPAF?=
 =?us-ascii?Q?TfV1muccHKHQ/JrAUub6OrURD5C3aqQoVySvAlIX2bkxH0dhdBI8uhFVJQsd?=
 =?us-ascii?Q?G7Ll56aeY9UbFl9bSiDhj6QuuGikRz4Y2p+0EoI5Xev7nbMOsHFLo2SZ9Sbv?=
 =?us-ascii?Q?8dx+EfzaTWrbHgA26N/y8v2NGdp9GlnyLLHqd1NQy+U9Ex/ov41f2cqKMG8X?=
 =?us-ascii?Q?eGLHPahdjzSw1u+I8ZOXn3f7ynCp4XyzRJex9zx1BO3zkKAqV1EorT771DV/?=
 =?us-ascii?Q?SmVQEHawjvH/A8q4O+k+koqXW8FrAkxQtuvLehY08z6wv9ZhH0NWFG8reBfn?=
 =?us-ascii?Q?hYY2SRR0J5/znodzkHa333kHUsiFzxIWO0pbzybmeAuFHDFWEzL6+c+FZpjo?=
 =?us-ascii?Q?dP4Em+L0g11Hkr0m5zRK8Adk7MTDkSPuGXl9P8L3/LqXe7RgtDz8mcheXEin?=
 =?us-ascii?Q?27lTJ8mQK66apf66ha+epV3qQBThBA4HnmDEZGj/pOcf0qjizo3DoLdK0oaa?=
 =?us-ascii?Q?cMs3UyNw+4/qXrT1YVl+GxI7AHbuupJDkYlLC4mMKBDM/Q1dmn/50NUOO5Kl?=
 =?us-ascii?Q?xqAoZsIoLRSxC4AymqYIjEnrSVH0glCLDBH1GQdXxYC4qK+A2keM3qkj3bUP?=
 =?us-ascii?Q?DkqyzDfIy2EpF2JL7CC/KSHx3rrd+bv91NM5J0RyEpg53OmS2g195oYXY9xI?=
 =?us-ascii?Q?fT7bODjsUDh9uKN8rAgQajdKyS4DAEGVwMcq0mNsGOe4ZjMZdTSykJE/AVyL?=
 =?us-ascii?Q?NuWAFmtIIbR/2eqExtJqKJDYJBKYnZ57q6c+2vd/BDGXt01Y//ZXzguK7jDE?=
 =?us-ascii?Q?hsWtYFPEaUM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s9ZL9HVSq39zc5CicoQ/oFKC5mpFygpv0iFibi97/eaodwQREVpLLvqKcrv5?=
 =?us-ascii?Q?mhe/4FRyT637AfRtyb1BMFqdlqwInSNHCpPxVw4dJ59bbDfjsH0NvS76kgak?=
 =?us-ascii?Q?qWkKAuWdixBjjdfUC2C+CirnVd5ZsietYg72spMSsqQ2UFd00ML90xjYRNfd?=
 =?us-ascii?Q?4ryA9n/mfzENxWN/EaIhRmICtHY5AKAvwfNjqf4izWuRXmkBbgwu6EsNGwHB?=
 =?us-ascii?Q?mogLtcvC8sBls3RLkLn8hU5zcfvzQ2zzMt9thep46LbkBIwogLkiVjbG4qGv?=
 =?us-ascii?Q?/2qDSfQI6RSV7v2GqJZRjxHKNpiYjVz4jE2V43XtHnl8zJfXFdK7iuPrBWAW?=
 =?us-ascii?Q?9N0PdAXzrm5thaA/v/tiWdiW7aSKmIW4vdCtd1SEIsleg+vrRSNiJKVPMRXF?=
 =?us-ascii?Q?j0zpp9Rv5Sg4d42V2IDw40zPiasqhnyK6DRnuHEjlNOVncOZpl1fHRBANcQJ?=
 =?us-ascii?Q?lr3wVrF4cYZssENYKMpR0hHjlIzGwy8WG09wwMxV2xSEjKDDIqWDRjGAWAGg?=
 =?us-ascii?Q?GnJojJQUSuxvVF6g4Aitnrsxw/WAJczE5/jXXeEj4xaGzrSBkXIsLH2uPUV4?=
 =?us-ascii?Q?XQ+bWG5gGqv3n6L10HgeXzDHXHOZb8KWlhs0tw+1hN7NoX01XFIevbCkpb7o?=
 =?us-ascii?Q?3o83/B8jxY7jhMXW6gTHZWO1Ei8V8PunvqKP3Q+SyfZt6rqGdXKpeFco+csL?=
 =?us-ascii?Q?JUcy9VbQR0OCCQyKqK67f6qYFNUkp7lccwXhlduoMyjsz2r+QrHUIg6/qSFQ?=
 =?us-ascii?Q?Rj/HU/mCTcdYVpEaUEb+4+ydKx2I4bPAUy+4PhrLiQN+i6Cfq6FxWWuzlOAU?=
 =?us-ascii?Q?vIbab9O6ww6wHjrddMhlWBzPJXQs2MDE6g0mz7hK3q+ulJuGO5Q7mAxgy5SO?=
 =?us-ascii?Q?lae6zdf6bVUsJNmWEWj5T+KT0d3oEOj7F4PE69+6FRKiJtGw7TD/39eKxzPT?=
 =?us-ascii?Q?CFzDqjMkxSyZY3+uTxit7hZ/pOHvhblr58wU67v6rfvdTZ0EWxZFNh75y6En?=
 =?us-ascii?Q?72PeLjrPGCqCs/zz8e1U1jo5bNcWg3NL1EUZjGvze1MShwPCkQrQfqO3wuER?=
 =?us-ascii?Q?bOagfGqjfcNMaGIWwNOrkpk509j4CvPZYtx8wuJAnYYiG6ui2FwXnr+izmoG?=
 =?us-ascii?Q?RGsTf6GffyOa3xp4wP7dU5EhARSTmcrkeceYrKYbkUNWS+OnyLKOngVd/5pe?=
 =?us-ascii?Q?B2+QaMlCDg1nzL/IPKVw4ZfDdKXCoVA5zbBkiuPuay2/nY35cyWwZBRNS71W?=
 =?us-ascii?Q?bix20KFjT6YLMoARjJPH0a/ODtwK//m40etok/E1SGWLDAOLdXpSyEY4NUIr?=
 =?us-ascii?Q?DX0R7th/SmisFmUcZ64sPi6GYRqQ4Aj8vpgMv09x996bT6Xd1hPrffrYCYJC?=
 =?us-ascii?Q?tM+xYXHztyD1tpadAmQF/V8+aHP/2ujx4oZ+6xdnEq7mH1nxkP6U9dqqYofn?=
 =?us-ascii?Q?7moUeXUP4gMANizrUTETBJEpomJMr3n1qKapa/IB0rR9LBF5aVwnJ8zLXFFF?=
 =?us-ascii?Q?6btmtHew7+cOjuw/mniKgrjZtJ/BW5vSvXY+79jNgNV7rqA1xfn4zYc86Enb?=
 =?us-ascii?Q?/i7fGzygz1TaLX4Ag7Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 082434e3-02e5-4e3c-793c-08dd4d1a216d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.3594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c6KLlhwy6g7Q//7QPesIwtppBm2zxZy31/AyvzP46aPehXjiQN1I2Oen2aMratpv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

This is part of the consolidated iommu page table work, it brings the
allocator I previously sketched to all drivers.

iommu-pages is a small abstraction for allocating page table pages that
iommu drivers use. It has a few properties that distinguish it from the
other allocators in the kernel:

 - Allocations are always power of two, and always physically aligned to
   their size
 - Allocations can be threaded on a list, in atomic contexts without
   memory allocations. The list is only used for freeing batch of pages
   (ie after IOTLB flush as the mm does)
 - Allocations are accounted for in the secondary page table counters
 - Allocations can sometimes be less than a full CPU page, 1/4 and 1/16 are
   some common sub page allocation sizes.
 - Allocations can sometimes be multiple CPU pages
 - In future I'd like atomic-safe RCU free of the page lists, as the mm does

Make the API tighter and leak fewer internal details to the
callers. Particularly this series aims to remove all struct page usage
related to iommu-pages memory from all drivers, this is things such as:

 struct page
 virt_to_page()
 page_to_virt()
 page_to_pfn()
 pfn_to_page()
 dma_map_page()
 page_address()
 page->lru

Once drivers no longer use struct page convert iommu-pages to folios and
use a private memory descriptor. This should help prepare iommu for
Matthew's memdesc project and clears the way to using more space in the
struct page for iommu-pages features in future.

Improve the API to work directly on sizes instead of order, the drivers
generally have HW specs and code paths that already have specific sizes.
Pass those sizes down into the allocator to remove some boiler plate
get_order() in drivers. This is cleanup to be ready for a possible sub
page allocator some day.

This is on github: https://github.com/jgunthorpe/linux/commits/iommu_pages

v2:
 - Use struct tegra_pd instead of u32 *
 - Use dma_unmap_single() instead of unmap_page in tegra
 - Fix Tegra SIZE_PT typo
 - Use iommu_free_pages() as the free function name instead of
   iommu_free_page()
 - Remove numa_node_id() and use the NUMA_NO_NODE path with numa_mem_id()
 - Make all the allocation APIs use size only, fully remove order and lg2
   versions
 - Round up the riscv queue size, use SZ_4K in riscv not PAGE_SIZE
 - Convert AMD to use kvalloc for CPU memory and fix the device table to
   round up to 4K
 - Use PAGE_ALIGN instead of get_order in AMD iommu_alloc_4k_pages()
v1: https://patch.msgid.link/r/0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (23):
  iommu/terga: Do not use struct page as the handle for as->pd memory
  iommu/tegra: Do not use struct page as the handle for pts
  iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
  iommu/pages: Make iommu_put_pages_list() work with high order
    allocations
  iommu/pages: Remove the order argument to iommu_free_pages()
  iommu/pages: Remove iommu_free_page()
  iommu/pages: De-inline the substantial functions
  iommu/vtd: Use virt_to_phys()
  iommu/pages: Formalize the freelist API
  iommu/riscv: Convert to use struct iommu_pages_list
  iommu/amd: Convert to use struct iommu_pages_list
  iommu: Change iommu_iotlb_gather to use iommu_page_list
  iommu/pages: Remove iommu_put_pages_list_old and the _Generic
  iommu/pages: Move from struct page to struct ioptdesc and folio
  iommu/pages: Move the __GFP_HIGHMEM checks into the common code
  iommu/pages: Allow sub page sizes to be passed into the allocator
  iommu/amd: Change rlookup, irq_lookup, and alias to use kvalloc()
  iommu/amd: Use roundup_pow_two() instead of get_order()
  iommu/riscv: Update to use iommu_alloc_pages_node_lg2()
  iommu: Update various drivers to pass in lg2sz instead of order to
    iommu pages
  iommu/pages: Remove iommu_alloc_page/pages()
  iommu/pages: Remove iommu_alloc_page_node()
  iommu/pages: Remove iommu_alloc_pages_node()

 drivers/iommu/Makefile              |   1 +
 drivers/iommu/amd/amd_iommu_types.h |   8 --
 drivers/iommu/amd/init.c            |  91 +++++-------
 drivers/iommu/amd/io_pgtable.c      |  38 +++--
 drivers/iommu/amd/io_pgtable_v2.c   |  12 +-
 drivers/iommu/amd/iommu.c           |   6 +-
 drivers/iommu/amd/ppr.c             |   2 +-
 drivers/iommu/dma-iommu.c           |   9 +-
 drivers/iommu/exynos-iommu.c        |  12 +-
 drivers/iommu/intel/dmar.c          |  10 +-
 drivers/iommu/intel/iommu.c         |  52 +++----
 drivers/iommu/intel/iommu.h         |  26 +---
 drivers/iommu/intel/irq_remapping.c |  11 +-
 drivers/iommu/intel/pasid.c         |  13 +-
 drivers/iommu/intel/pasid.h         |   1 -
 drivers/iommu/intel/prq.c           |   7 +-
 drivers/iommu/io-pgtable-arm.c      |   9 +-
 drivers/iommu/io-pgtable-dart.c     |  23 +--
 drivers/iommu/iommu-pages.c         | 117 +++++++++++++++
 drivers/iommu/iommu-pages.h         | 211 +++++++++-------------------
 drivers/iommu/riscv/iommu.c         |  43 +++---
 drivers/iommu/rockchip-iommu.c      |  14 +-
 drivers/iommu/sun50i-iommu.c        |   6 +-
 drivers/iommu/tegra-smmu.c          | 111 ++++++++-------
 include/linux/iommu.h               |  16 ++-
 25 files changed, 425 insertions(+), 424 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.c


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.43.0

