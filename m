Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ECC121170B;
	Tue, 25 Feb 2025 19:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512407; cv=fail; b=o9D1plVkHkqRkyQkPIo/oV8gbiPbsGJHfnPVZiuskojdyDhRFaZxG58iozxN8beOaa7CXPNUeYWswo9qcpOZKZT+Bbv5s/AXffqumir3QHit5EMarduAOiMX5lrtQI1J1FpnygljUDEXfYu6i9D3h2Aop76aF0fmapBihHeSOIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512407; c=relaxed/simple;
	bh=21sDTYvOsw8JAjUbnYsFitxDaAXThFfUt+N1cQUqpjo=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=Oi7PFwyvOAvlbXYYag0SEZ+gLEP+GcOSwEUHRQM5T3Clh5wt3iTtQ0K7jYKEBXLj/XzqUQTLpg/tQnyb6Hzr/72P0Irfk1TXCXsH7tnsApFZmoRqMjqfNIE1ycCGOqNL0wo3KIKUeq0upWyZAWOW/GCdK4E9NWCNNh6A0C6bxKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tGSASG/a; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tGSASG/a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7ISxJ8WrumIQvu/35naKm+ZCPx+gBrRBzX+BKWaFOOKTGJBrgjBLMf3yZuzQRzoCgzBO+lrQniDLI1TLPQwjjwPwo5FZAoOsQwEMLSqWNYxuT6i+oKKlrr9G42i+e68CdvBpsGBB9bm155WbrdqcftT5+0Al1wFG6wwykoYjI4SsOnJ7OIHRfMlnxjzmEFqVXAI06nXGbmHDPLMRrp+N5y9lPqW2d8qFb++Bq1rAB/3kgcQiWrOUnNo9e642328MWGLKnTI2P17u/I7z6CgDa62jaqH8Fjc5gl/q4YhuuvV4d4pdBBMwp6cgH87bvRaojZe9fgdClX2aZ0LiTWpVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/s7YTzT1hhJHfR8eyjjYlD0DXi4YHs1HX3Ke2czWTo=;
 b=Ya6hD8Iu17IlzDI1tZa7B1j8mthZjpGwDS6/myV1TufnuH3DifR717CHRDafASKUtx6f4xJNbD1ULxcjSNIW8l2eC0XTq4K0eUkxuP/OuFfawJuNuS0vMXTmM/KdZviCqjp182mpLE/Dn54NzqbsHw1pTcTRO37q6UzWsbQpeGvyVG5VR/OvMf2OdGthXqvV9XEKT9IiJCCaJmpXRGSOnuh+sRUe7V5fBb3S5kwQYWWQQoojPLLmuXDFGbjfDRF5Fu64YuXU70nvy4d+MUkSITjZptlPhsXiYr8k47cM/+wPP4VyRJ4FIIXIUdV+/eg4Ui2j3tZ9amRysTGT5clhbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/s7YTzT1hhJHfR8eyjjYlD0DXi4YHs1HX3Ke2czWTo=;
 b=tGSASG/aCWY+Cs0Blu/8pEdA4iSi851n4Kx8O07l67trFuzZGGG1L8v/2IdPMMisP8TcDaxPoVWePbhy60NPphCxUxkW9WgylCl5DIKsGV9Gwyxq6eB8kGjiBB/VR2kqoi09aCT4o9osA9wQAVLhV2ygVBQCnOq4IGVzn+hwTqEdNK4q5JZMGxsA3mpeYmelxqlSbaUgqY73vPulrXwwf5kR1bdD3+bkUXnZ3i8kuhFSeP+ZVP0GgWaReWfa3Nt4RiDkR72qClxECdYIHxi5ShJSHVJin6deR7q9YmLfyGQPJT5lsTV7hdmPgf3e2bCPb3RCJ1XUUoEvYEWApn8g4g==
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
Subject: [PATCH v3 00/23] iommu: Further abstract iommu-pages
Date: Tue, 25 Feb 2025 15:39:17 -0400
Message-ID: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0122.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:87::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: d2a45919-15c7-49bc-75e7-08dd55d42924
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BH2umvZwkj0IdQVksw8MylcNODTTigzvABzcqB/Ug+HQB+k+rRvOQVUDNj9Q?=
 =?us-ascii?Q?7iBphyAjLxpc9SwQo4wttJlMJT8jDKhesAJDVQF12dzSSQbF8uBUxAqX0PGA?=
 =?us-ascii?Q?O9XOjELm4VA6nnOfEP5e9kUA383NUprVe/4tBPXUzFoCcO2HwCV/4kd5tpgV?=
 =?us-ascii?Q?ALFK6c1+TqTSqIX001ontEAs+8ztmGuTY9dwEm4e3EfIkFOZW4U2nXnLT5dQ?=
 =?us-ascii?Q?snAC3RJsJi8phaU5RWdF9m+FvAh10ZC3EFgXM+RzIdd9yoLe2XBVoGXlQACU?=
 =?us-ascii?Q?ehiZhDSG07t2q+D21/OOusv/NqMsP536OvMzBVTEKhBMeiRd8lwHlQj7bQNN?=
 =?us-ascii?Q?bCPqK6fN/BpNxjJONGIG2hDdLVuvZSmww85Rjsc6XpLWkhGvrLtdsq0YzVww?=
 =?us-ascii?Q?b0goOLecOXiM3yoEezWCDPx6NcHqXxgYrlCeiL71rjApNIszJopcw6FqZd2y?=
 =?us-ascii?Q?U8dr0GUJsaoDUmalwRSrekUz17MSZ8upo5eoqVbVQ6at+Cm/3QaiCR2jOFUU?=
 =?us-ascii?Q?Te2dWzm877G9BbJs+7NEFoV3p+Iem4kqkoaLJwliwuVydFZJi19QdCDL6/am?=
 =?us-ascii?Q?Sf6r+SinIkP5dqWjgmRWQG5XfN1ZgyF7k3gyTPIFjQ8reeCrB9OO7Cf62q6D?=
 =?us-ascii?Q?HG5wnNnletWrLdgtbqD5MNzVDnRJpxZ5N+dlMJh31RLHPplg0C3yCsW25+is?=
 =?us-ascii?Q?xJhqrk25iwf5N1CBHs/7jd4cxYkjLQzYQ4t5YZlqdNQeT1rTJRXiykm21Lgx?=
 =?us-ascii?Q?o5nNLT2ERkHbTKiJLITmG1O48SVvv2KcuFqjA7YywAeKXWxHag97Yw3OHmJA?=
 =?us-ascii?Q?jkcVSz74BNpEba8ETRtcmODgoMZt1mTAupEKTD3RgmQ6Bvp8WFpTlX6KBSXi?=
 =?us-ascii?Q?lriZblh0D1qQJo+KpC66Mjsj986We6rGPi8vlQgCvt4ThBOjuDoEqHtud0kE?=
 =?us-ascii?Q?sfi5tJ+aWtK+xqTU2lSCAg6QMRoh1kWiUhWBAgN83pFiPTAyprwJib668s9n?=
 =?us-ascii?Q?WZ1tEXMjzf3+1UxmSbF3iC9QFZ5E0ygjiasCJE39CT6wIhpPslthjcsDoBz3?=
 =?us-ascii?Q?PtBm5OgEtv0Io/0E0pthVvOuJjYZUSX8yj/KmjEAkTpG6CKQyw/k47fOVfw2?=
 =?us-ascii?Q?XsxGAQBgAOokYbFQFO817JTPoRm/WoosAPDIYjcUcUR9RUYnD6EzWcLer2bb?=
 =?us-ascii?Q?ESTTU860HUj1PgO2x34SXOmeZWULJjLQtfCOfkhqF68eEUxgkDiG0WxJVZV1?=
 =?us-ascii?Q?pMPmO3uCYgbaS/I26nfNn6mz9uXWOHfHd6E3RrVk+L5H+UyfAfLMD/uvg1tP?=
 =?us-ascii?Q?BgwOvV5+Q2kz24dnTV4xVmoHV+gPdIGl6rxCByoO0h8CItQtSJbB3zw4EYsJ?=
 =?us-ascii?Q?llGWkktaSj4ffVnH9oDI9qVMrL9YI+TBIjSXXY7feq+5A3PXRC8rmXl8ZAFQ?=
 =?us-ascii?Q?oxBUhlNEUtU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/CMjx/azLMJS/AdYEtOG4Gzcw18SBRJfWgertc9UyubTeEp65JOUq7GPVo/c?=
 =?us-ascii?Q?jk39ubu3P4ecQASb20rNTUgWq3eSyQqWq4ZnUQXphlaE+M9vEMMJ54Yo1Y5M?=
 =?us-ascii?Q?jAeNj8rQ4yHqW/XM2hHnrUaE9o6n8In9C9W90GywvCbTEB9ZNLiBdmLdqgQJ?=
 =?us-ascii?Q?iXbPBmfMTtDbkpIzKDoBF8zqJpmDANCeHaFQ0mnFeKq9QF73wyAkocLc7y8r?=
 =?us-ascii?Q?t2xsBp/1UITLGiKNT5L7kj7iGcrwWM8uG2XB5v4DoLq0HBcfK/WY1u175SQA?=
 =?us-ascii?Q?i5e4beyAblCU2Oj6TtKjcR7jLUmDYd2c4yrXoc92ECovMxNFlim7Qd8+j4eJ?=
 =?us-ascii?Q?gWnKNMbbiTvv5kxCz7g++so1vkEIXfNW22J4ahFx7GtpHUamhCGogZlqvdsa?=
 =?us-ascii?Q?SUaes4ddLxS9JOHfSavwb+eZwcuHxj5GjAbPmj1hbgZnUmNxrxTIF1YEWjzF?=
 =?us-ascii?Q?OZMiRpSLrzF3PzSmZ5JXWcCQ3ni/jKctdkgjyL3wdSAUcW9zg7aMhOGnSSAg?=
 =?us-ascii?Q?aLn6a4mXqHF0/TYZQovIcQ4O7ewVaHOHtz3TGhAqY/nRYuWwwHHKQKZDv5/E?=
 =?us-ascii?Q?TIh60It6VQSxN0VLznUk1rXz+2lpVQkHci43dc9XEmkiDVIo97iMChCOiMx8?=
 =?us-ascii?Q?VefU5VIKyztt5VZgjkiPIX1AEgPmycdIcI8mZfBPNfwLGjcIrY362ocpIChS?=
 =?us-ascii?Q?VTnukSy9h9Gk977arux+H1IuK8AEXzg0eUzKsbvE/zYjdbXM7hg4e3zR03Ue?=
 =?us-ascii?Q?XyKbqJotnO8yAcwoP+cphtnojPi5t0OlaTFkbdQafKwa9xi3UzVFJ7R1yQXL?=
 =?us-ascii?Q?lWNFiuPUL8Gs719Wtg7tqvmk3WtZoVZfFm1Kz5aB5SiJH+DaSDfTG8TGLQhb?=
 =?us-ascii?Q?E6dITpZiTkC49z9+5J5NnZvJEEqZpvaVo/Um9ZGBQQf+FSdN1Vk2E2RRyumF?=
 =?us-ascii?Q?MgU0oGakzyyLQL91MnMS4qRrQexg6f/DbahS4k0AjLwpG5d4QK4EM/VzTxfO?=
 =?us-ascii?Q?e4hZ9FaP1mXAwgby/EGUVctRgzjlvPEUfgIqshbZDontVfxgY4mdj9gduv46?=
 =?us-ascii?Q?Q6bicpfqvMuEv+sIWcg4m4LGXCeGrh3JeunOqalPJDK0n0W7eoTpvin/BE/S?=
 =?us-ascii?Q?1NZmK/CmQfxVD+zOOCanCZL76IIdZstYKc1TrNftWPyfk4p7neW79OTknhp9?=
 =?us-ascii?Q?O/ziPbRFkgANL/tCKF4dieNGGUtszz606o4ei5aKs0sEBFkYT7wFMQax3oF2?=
 =?us-ascii?Q?8LLI/ghzJ+ccS+GwJh+168gl4YS0NouTh4fjQfU4xjFXrcePy0bn+SYRYt9I?=
 =?us-ascii?Q?W5+XmLgbNkuU1fyxW99d3fpkJxOhBWOGDlJxmtiinJZud2PlJkRnCLxUh6nF?=
 =?us-ascii?Q?45BlCSDJvzrITfJmXTPZksAK4U4tg5J77HYBf0aKtowNUMtd9GX2ySnC+6KT?=
 =?us-ascii?Q?f9fzUOHRuIA4FYJ+E9h7GQKq7eaFW242Mq5eWrgWjbhMXZSfc8I9tmgR5tkt?=
 =?us-ascii?Q?lxXoemCQjEv4JliFswPZGOK6ljWoCCaa4/wJf6N75Pt8bb0e1tGSGvR1oEnt?=
 =?us-ascii?Q?rTDKDiXh1u3Xomgy64+/IC4+ABBy2hh6flHNqjcr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2a45919-15c7-49bc-75e7-08dd55d42924
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:47.0020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tWtr0Z7h20RYBm+72+bEuEdWsWreumKGD28n9+2eKrDdHb1PkkhgJBqvrthU5MMj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

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

v3:
 - Fix comments
 - Rename __iommu_free_page() to __iommu_free_desc()
 - Retain the max IMR table size comment in vt-d
v2: https://patch.msgid.link/r/0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com
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
 drivers/iommu/intel/irq_remapping.c |  12 +-
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
 25 files changed, 426 insertions(+), 424 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.c


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.43.0

