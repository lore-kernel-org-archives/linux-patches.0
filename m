Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD37267706;
	Fri, 14 Feb 2025 17:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552886; cv=fail; b=JKgh1oie2+55wWNT30NEGeFJZDsOeoDncHiui4wY9HHFRXP2v7gtSj2sHZTMd+3pfhJqvi52lffaVn5Bj5+imXw1J8SlZ8QUDR7IqRr7HPoTnM8WhJKZtEvsG9gxfWfuI7pv/k5UHrK43lftz6Q5KUtil6p23ILtTHc7ZZRx4ao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552886; c=relaxed/simple;
	bh=wwNVnHB2OsGTLCM3s4VYTqFhBFiT2e//BVMNO1/Zfps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RQ+bhQ7oBbMaBsGeCQbdQ7uhBHGrAaA1pC7lmLHQyqmIKi1qyBabbugrTJUtBWvS9T6d+cE9M4MEXpngfDjR6pc7StfvPsmTBFxjgBanBsNTBcxId8k6NTfHz7MFEdBeIaTOtAy81JABa7DFMPbjfLOCZisvHq/Ejykr5Tn74Qs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=E3Id5F+Z; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="E3Id5F+Z"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ad4iqR7whvpTrMw9jpHEbYo+XTRK0x5DSu47lKl9wkUFegAClv+QSYwpS5uw0QG1nJ2yGy4Ad2kJthLT788aVbNGiiuxkeIQCdgfj8jQ3eCd4kWbDo0KEtMQSiNxdWYdr5cWjs6VAAzzQ03Y4Eoe27VKjbKx/1lDAwMW52W8LcNwL3UqMTMiAmV3lLk912Cw7KYJQp0TKznyAHvmMw5NiljH2AzYXdz2pqLcnjAxzERrQyHu2LkHNFLJGk9o5iHLUXWgEbO1jp+4A79K2C0wUm9TquG3d3qHalemVY7Ln13pWla4g4wkZLX3Wo756FgKhFxmu0oQYWPUxzp8Yw/z1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kHBdLiM8EsPfQljrW84NWoTAP/CDelQRTX7MyrlSfc=;
 b=PJskPQnkLFay58DiKEwl5laLHHeyq0VBLsJQs4OFXiqKe5uX02q4uXMrBExckDUtw/RvN2bOzP+tpZ4Up+0q6v/+iBT+Thd+plaxTSjixgQ52vPTj5lTx2R6hRoURGSUXtpSe7EUF1eDD8caUCzsgi/pdguKa6QfOHFgiiVxg7sKtnk0GDU4J5GJk2eYf+FoXejSb6HbDP3K1Qh9tgpWavCwNHV+2qviDvAMtWIp4Z84ep+RiRQHeNKC56DtFVfrC/w1UXnqii65PwU3qEkNHi2iaXvuzPcfl9GjSWGtFuljn/Z9hrwtW0Ktd0kAAby3o8ZLcR2+RJ9KIFU79BLE+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kHBdLiM8EsPfQljrW84NWoTAP/CDelQRTX7MyrlSfc=;
 b=E3Id5F+ZUEPEZ75hSeLVG6gqE/hD3OIQc+Dwi1CDFSjty9eVLTOABBNjvAS4dMuu4RMUUl5M8Hup07gNtUoONqhG7YFijgDOCrzuk9ljzS/qsiKoDZpNJMERWZtIfNtyNAbJn4y22G02XVIgfSBtoQlhX5D6OE7OXWOgDDRtbM/ZlGAEBl4E/eTFAGxhx0SWPULTdO0czAq3IDpLkoA5fMD/NDDpr2nghzP5uv90RhJZHnRgRh3vkvVzw7emhEEqhpxZWxf8IXoSarHDJRWBNJ1o7QHcROwCLg+x54YpZ3uhnrUnf3rCiZM4DHgp13g/AJzde9G7kO4uec6BX6ykKw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.12; Fri, 14 Feb
 2025 17:07:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:07:59 +0000
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
Subject: [PATCH v2 15/23] iommu/pages: Move the __GFP_HIGHMEM checks into the common code
Date: Fri, 14 Feb 2025 13:07:48 -0400
Message-ID: <15-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0046.namprd02.prod.outlook.com
 (2603:10b6:207:3d::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e74a3f1-e1c9-41c6-caf3-08dd4d1a2145
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jwC5ODP86rV15J21QBqZasYmIB6xaM3/AkH+zx+ebsckgeWuhTA3Xhuxwhw5?=
 =?us-ascii?Q?1oFpijvIxPQp7mnOgTrIM2LGp3mJB76CPyz+oIrEw1yUT3ZzZ6LpWblzeHvt?=
 =?us-ascii?Q?7Jpp8fVU0byegZDMB/acfLaXTxwbNfgC7U5dtdyLFmzdlY28zWswHm9WCL/c?=
 =?us-ascii?Q?JAj3RBgtk4N9p8a+buIaURo0u1d0jPXFrWCymzVvpPZHx56MtG3za6zvuHXd?=
 =?us-ascii?Q?AFGlYRbW7UTWnc3dY7hCWfR+DYYz4lsSU0UNG48VrzQOWZMmZ8ejvrRxhvmU?=
 =?us-ascii?Q?t5htppn8/6LeDtL2GH7ELu9LMZ6TvER7Nn/ma453ExDTbdCNjm5FDVQcrOZr?=
 =?us-ascii?Q?mXqVY+v6dFNi2dCKhINVxHBvmaGH+4cnmRKwB5m+Uk9ns4C3OPp5ni9NwBUv?=
 =?us-ascii?Q?WKPoINDJ8/esrA4TqCWvuuGFHL3GUJArSNshiQ42jRk3jK4UgejllI03I2mO?=
 =?us-ascii?Q?AHGBC9Ms9/8P/1GjNW+JH5jw1rhzjBM58GJENFrh3hcjIeVjOBsiEtdHMLhM?=
 =?us-ascii?Q?cBgmaY/chGGcwdrEEQG21RiBdfGKXZ3npQDtin1kpIOs5Mriritxe3U+K/Wk?=
 =?us-ascii?Q?iWWOP4dTNJYTw3md8kW98z3OY+ls2tnBetARn/XCO8Q/ZQPgpfIJXw7k1uKZ?=
 =?us-ascii?Q?Rs1rLAA4PGCYmL4f38uiN13kuKP0noib2ElI8t+UD8lUskVOT4mHgze9Z+Cc?=
 =?us-ascii?Q?e3bG+AqSQG49KTageZSxaK5Hmdux+A0cpI88kGK1UkyTg9PWvsTbDOnjJITa?=
 =?us-ascii?Q?pQeAbS/j0i/jGDcKLL/xr3sG0d6XEu90DhPYVpvnKPpKhNxnbgze6fYD+Y3i?=
 =?us-ascii?Q?dw/5ASj/Zkl5GLHOBhTPTpNlyrik7N+HTz+lkug3JHW1c+snfo6gvPUBfc+q?=
 =?us-ascii?Q?Ej7+aoB7HXJ2vdta5rVt+ocmyDrdtgKmJ/hcKVgNhHB7hqCjWuFVMKYgDv6q?=
 =?us-ascii?Q?+p7MbMs+igRSTvVsXGjR6P8rUJg9iiNklm/5R61MCc7uw+W/7Qr/wd48kUM3?=
 =?us-ascii?Q?YufAH1Ejg6FQZvosFW5A2v1XQ+EUsIyxhfZQJalJ95BCnqPXdSHevV71JK+x?=
 =?us-ascii?Q?2QwjVVFqOnryU963fPrYk6mCJ9yySPORzxFp4+PYTg3IBoDcfD+UbWXn+1bX?=
 =?us-ascii?Q?OWT7Nz/wvDaxlmFSecbzjwpbanKLwQmBqLkolPwv9Ff0mnDH7lbtK2UIA347?=
 =?us-ascii?Q?aDHUWizDodz82v4NoDx69qpmHS1jdyIYItu0l1zizi6i/vbEBYXODw1bNrJs?=
 =?us-ascii?Q?mUvmai4cL/dYpYkWT1uzrACjaffmgeXQLoBP719ek6/xCxa9/AfjJE9UKkvJ?=
 =?us-ascii?Q?JWP8HVsGioxjX4yzV8U04NyM8k7VMVPkoIRaCqPQNe/EQ35ipaKhQTZCyGc7?=
 =?us-ascii?Q?BjxtjV4OS+WrgYNZTZD63nVAUGoI2BNjQ/Pw2E7wB9wlO0s84OIAzP9iMXwe?=
 =?us-ascii?Q?iQeQvm+qV9I=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T76/ir8464zoUOmzSMv8NO+JloBgeVNMrY8zrTXMVa5siPyfu3O6/Eh4iwoK?=
 =?us-ascii?Q?GREXHp9Ly9/5M6CkjkMzgLnc0+M7ezXiCuYFTOqnYIWWakGrQ0JXCi5ZZNnD?=
 =?us-ascii?Q?tA5F8QBuHLqMAfOujuB2uVdUnWOmYD676E77+3TWcNUe+WRWrFKkUfS9/hfn?=
 =?us-ascii?Q?u0bToD13a2Smddk1XsIKz4HFdVrlBvxFtV3jonVcHJebf9mM445cQVmyhPK7?=
 =?us-ascii?Q?Q7xCk4uoUkg+bEF79/BHy/Gm/2fkJquhoOiC7WeXoY7HZUaJBqX11oIIfbdK?=
 =?us-ascii?Q?z1TdSdeLLxmLBQlRrx4OtD+qKYpxqf85mrfKGYRejtpG9MqeF3jHTLBqWxwK?=
 =?us-ascii?Q?QmhH9f1WlGATwTMALlQKVI7UnBEpKa7qUvdtuyi2zlEmsQAY4g+bNv8dwZCK?=
 =?us-ascii?Q?IbW/fDeyBOzQQ0gaT9tZymfX7hTY/vGMkKX4BHzGWXsfLAEU/J/C0o7dJwRC?=
 =?us-ascii?Q?T1lFKr3lslFZ/MWTtv1ibe57Gi/vnuh1gPN9ay4SBOHx5dLLXuaMvJwJgXPm?=
 =?us-ascii?Q?t3tvFadOeNpvJ7ljvZn5bcWtwpYzpcCCf7WvtHYiOn9gLJh3VS28m36EOUem?=
 =?us-ascii?Q?fZbycDBMfAQkaVi+ue2cxqV5C3l5c01594HctBIGXS79CkOZd2Z4BmuxFiXR?=
 =?us-ascii?Q?WQVTx1FOkJegPgf0nHKDX9bpfgVefh+d3lER64W4kO5VnzWROYiZMxnXzTi5?=
 =?us-ascii?Q?mJuNxw/XqjEuGQUdx5if4bYWBE9HWLO9ljxFVvJGvRQ1033swRgDvH4EItLq?=
 =?us-ascii?Q?InuKI5YGQ1qATJbudgofCxJqQLuChZwS37WHlZgvOoi0v23yDd3Q8BuIQffM?=
 =?us-ascii?Q?CU75/bOnAxzPxo3fK+2itY62fI72ZF765WViZIdklaq9BPbURXd0HvSQyGAp?=
 =?us-ascii?Q?XBzPqMnchM3XKvOjoKWViAxFlBO0A1sd5fEvHCY1Mjorbhp+ss/hFos4oyn8?=
 =?us-ascii?Q?QvvbWGGIYH8YLiPkKsyI1tZkpV4n70wkkZ+mMfcyJO15F0X8mr+5gOBea4kB?=
 =?us-ascii?Q?Prplfn5aZe7TovUMOMg5wPmhgaJ5oxu5wxTrLaqdf9BBab0U4An6ZOWvXAMq?=
 =?us-ascii?Q?RCpsBhOr2tFan0KuYcS4LYEJgrWpt+YUu+NvqEtZMkBLwL/URByUQoOZehwT?=
 =?us-ascii?Q?9POubMEuR4r9XKCCiqOOipl7Qi1qsq2TErE8hQYxiCMGSNYSAj9HL5I/xnr1?=
 =?us-ascii?Q?0FswbBjUwDFlKzJf8F1nkO/y7/kGro4lhqzCwMSF7AVz8KdSbxihQ6bqQa9N?=
 =?us-ascii?Q?UXdiI2SvEHDYxWWzV7Nb3QSVVyxVvmJwNYsVDt/8DyXF4i8MakxArn5Nw9GS?=
 =?us-ascii?Q?Vom7AfoxLzboCLPCaxIjU1WN5qeRyJRvEajQeB595lHHUU5HnNcYFvMZKZad?=
 =?us-ascii?Q?00J5LN0xUxcEWZVOyvu1kMfYEtBKNWp224M8QuSMhgLtLisiv2J3BpnMgADm?=
 =?us-ascii?Q?YomkuEvz/zWWI8e4c6sQ7UQLaLNR9j/x/5kTkPceiSigsvhLHqOfSxVIcq1L?=
 =?us-ascii?Q?Rcw2VVk4ofXxFJdPLk614lwlANMMOBKNqqze4SWGrSzX/f1hRhneZUq/bCki?=
 =?us-ascii?Q?0y2ctDu5ZSicREF6U+haweOws2mzz5hZ22J+Ellj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e74a3f1-e1c9-41c6-caf3-08dd4d1a2145
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.1085
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UMFg0Cmmcq037seq/Drc+gkPVjXwEnFx3j1XR/BAQUSlzgIeR+9guLzlp9Mwj0pC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

The entire allocator API is built around using the kernel virtual address,
it is illegal to pass GFP_HIGHMEM in as a GFP flag. Block it in the common
code. Remove the duplicated checks from drivers.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/io-pgtable-arm.c  | 2 --
 drivers/iommu/io-pgtable-dart.c | 1 -
 drivers/iommu/iommu-pages.c     | 4 ++++
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 62df2528d020b2..08d0f62abe8a09 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -267,8 +267,6 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	dma_addr_t dma;
 	void *pages;
 
-	VM_BUG_ON((gfp & __GFP_HIGHMEM));
-
 	if (cfg->alloc)
 		pages = cfg->alloc(cookie, size, gfp);
 	else
diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index 7efcaea0bd5c86..ebf330e67bfa30 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -111,7 +111,6 @@ static void *__dart_alloc_pages(size_t size, gfp_t gfp)
 {
 	int order = get_order(size);
 
-	VM_BUG_ON((gfp & __GFP_HIGHMEM));
 	return iommu_alloc_pages(gfp, order);
 }
 
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index a6b8ef653fc427..0369f0d51c3412 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -37,6 +37,10 @@ void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
 	const unsigned long pgcnt = 1UL << order;
 	struct folio *folio;
 
+	/* This uses page_address() on the memory. */
+	if (WARN_ON(gfp & __GFP_HIGHMEM))
+		return NULL;
+
 	/*
 	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
 	 * alloc_pages_node() did.
-- 
2.43.0

