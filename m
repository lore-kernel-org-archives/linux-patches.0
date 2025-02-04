Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2305F213E81;
	Tue,  4 Feb 2025 18:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694107; cv=fail; b=tdnDff6LkxTOwsAH1NHUBGUjJU7q7uZI5U2r1NJfSKzO2pjGRDxdvrkicNsXqQUnMv/BQDOwtYDJQUEEXSnDLGWCQrpgQZ3vopGptMsCPOhwS/UADZEU+PchDYKHvKk7DXyrHwuqJw8SXIAFgXNYpxYlDZhbPKywJ5mJUwXTI9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694107; c=relaxed/simple;
	bh=o9Fnvlf+a2N9GHZIUTn74QCkieS4ZHf2GqfF9ToOCwI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=j5XijqQyguppMYw+4T4ggnCMA7uc+5jvj0FJnjiSjPSaUlvqPNUs5tmKqyDdZcFjr87dA1q89apkktaCDu8mTqBYRJVTyIgDEODGlPH1aaDDfkdWFlQQvcAgDfraX3UGjaVeimK4/A6aW5itsQrz5gSAygwAZ/WRZi7OvNelbq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jOWYvj4S; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jOWYvj4S"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pUZFOgC8zXE0IEaoj0uSfZksxm3EehcaCckgiUdSFz1HHWKBafHYjvSSj4KAN4Ax0Tmysj+8qwnoztc9J0JxQ7kNji+azz7OCBljwPBD6+im4HSAKvJxLyb9OXOhcg4cpwb1RjERwmqnXCEEUb+f16BZkt+nj+gIeB/2kRvbPGzNCxcoDwUUYhztypSKz7TR/9Am0/CaGtkcrbp6gNLbXjRJikOED61UzFO9IW5aVPwf0PRqvHKnhYOSL1KpE+VhaZK7P1F6IXuP3efrGFzbO4x0DiFqAqWBoU2g5TP17RFhk55G+XGK+TTD/oO9VEP3HjUpE77swa/+tUy4BRFLEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+vttmH8MA91fMaWrbxdlKEOEfxakCHTjQ+0CbNtGzdk=;
 b=mP+ZwFYOhKM81Nt31inQBQUoKXDs9TEJh/mFZE3SyC16pY2Nhz3wfUEQ7ESFVlMymF2VZ3a6f5MTKwdSfqPIsakLDfgeztiGFuOBInx4x95Y0OnsBmySFH38Af0zMoEhDPtju6+yGS18HHDExlQEwmM0VY3Y57G8A/GgQTN2j+I7sfkN5Q5X4pzNOqmLn6KNTuMRPGUdvM59J3GflJZ9B2ivE3S9yRxxIyxtSJXDPn/BAm8b02hBsnKyF78rF8uOGhVytH+PQH+CdPDS4SyYaC70V99YpId+pMYpNoY1Yp0OAc/dUMaNdurFvQcWA8LUyGN/Bw2nd+3l1w+az+chvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+vttmH8MA91fMaWrbxdlKEOEfxakCHTjQ+0CbNtGzdk=;
 b=jOWYvj4Snipxzwa1pK+axuMO0atTEEr65fVTc+E/trEL9PRcgGufN2pUwFrL+f0JUEpJIUFTadI/B9d5rNsH3YspElh5Deqs/UI/C/2+KTU1Ijr79mnDcY2nJtqwpwmd0u9j1OUvuFXjZqxwrxmvbn54xIBee0KAOmbd3BI5NwEOReAFa+yrugRyweVLwstH5dwiIEo168meZnQJPvZCFLMuC4460BunNK9NeltCfWFI0ZTlUhtX/hsgAddiMF4c9c/QvkyxZjPZ1jKZXhKNejp80C2DEmUaFVCZp2PPtV55dQJ636PANqasM4BNwBBiWSfbGnNpQH9Fba2pF1+MWQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:02 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:02 +0000
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
Subject: [PATCH 00/19] iommu: Further abstract iommu-pages
Date: Tue,  4 Feb 2025 14:34:41 -0400
Message-ID: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0007.namprd15.prod.outlook.com
 (2603:10b6:207:17::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 552f8802-e39a-45aa-1f36-08dd454aa2ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oNBLfKYs9XO7+mX/3JfzHBYyfoOOZP9xHT37emq5FcYIwOUfE5QWfK0g25wJ?=
 =?us-ascii?Q?PrRNZcJQr4DdchUHi3D3gJdlxbXxym52f002AW9vbx3CnH2I1yyFvhYrHMuw?=
 =?us-ascii?Q?h6cX9DVsgXi9zaTHad+mUZzDhzK3/nu/zRwKP0N5eVAyvxfv1ox3bdy7wL0T?=
 =?us-ascii?Q?Qgu/djYecY3yY+KkiUTXRRljlWfuazArCZ9JiwDh19yf/1I3V9+Z2wEhJU07?=
 =?us-ascii?Q?sUDZfUUOY5hwsnqgtvTVu23WbMJZFAXNxwffI+/RQgxkW98au4dXIDCxdJtk?=
 =?us-ascii?Q?LpGUIkKPmJN/noLEXm4jphj2KTsVMBR9t4svYy+HzIr3mcRq+fYs07BMJpq8?=
 =?us-ascii?Q?FJ2Lm0nR1jIv2lfusBPMlqBCxRVymvax5mpUZNKeVQgpzsh6mS0GguVwoHmc?=
 =?us-ascii?Q?wWb2hxaaxHGTMEbjSo2MaFH287mnlL8Le/cPukj62aEw0wAG5nuBGvW+p4sJ?=
 =?us-ascii?Q?dbnaHUtqskhtT0EkgJbVWytph29oyIhKSRNVD/MojhQwcxk/rgx7bXACTaKt?=
 =?us-ascii?Q?xCKH2mt4t6gmpyMYdrp45zHLBdN7zK3UjMHdY7FRcvpycbz00zrK81zEn0up?=
 =?us-ascii?Q?T11I2u5a9ky0B7EetcGpi3AZ/uKbezXcZdr6rJes7xJ78fhmyulFsIXsCF+M?=
 =?us-ascii?Q?x83NVoNJN+EuDT8xopUuyme7wzpb0zfgu79vR8i1CmZpRahZ5+RpKjMzweUi?=
 =?us-ascii?Q?mPoKZLmxP0y6Z7jNrBoAGMzgo0fReDXhKd4ljrRwN2p7knTuI2rXTNkAiuiC?=
 =?us-ascii?Q?AbtiOuSiYvM9H8E7NvncGa8gZDZVjIstFGs1+vuadl3zH4E/+p30zaDubfdr?=
 =?us-ascii?Q?CDbEW2sL9abUekJ6dXVbuOGArYGG4LPGO+DEvDM9uLycTQdO1BFb2ny3OypL?=
 =?us-ascii?Q?Kr7xwUgCrkn1i5ZcPBGBjxaRl7hG0l935njkDpVVM3DPUjTvP69hiovPmZFH?=
 =?us-ascii?Q?2sG16NVaHYS+BC36zEqYgZwDtP4mq84HpQeDeHPN6nVIKFcO3LZc2s4MfXrW?=
 =?us-ascii?Q?6Lxr8riya6lAyT0ky7PKZ9rslZJay3WlIdAarCEzW+p8Gh/upYkDzGHUuV9W?=
 =?us-ascii?Q?sGhWRaAiVkt1XHHUw8R1g2PuMgvPZj22uFz9kyY09HOlIvUF3Zlzr0SB5Rju?=
 =?us-ascii?Q?AQUccAS7CrsqqhuQ6C+iKuNlj0yXuhEetxSpQZRx+5v727WzJdt2l9HwrEBl?=
 =?us-ascii?Q?A4eYCBNsAiL0i/e9iH4KGR+cz9lQDH66QGu0o5Hx9KprB6LNKTDvuuNbggq/?=
 =?us-ascii?Q?D6j7eeXX5Csl+RR2RyoXX5qyI+RQQ15fjRW7OJ4NcUp8CmbD5o1c6t8ORXWI?=
 =?us-ascii?Q?3JFK65DZVAh8KGNEGJl1NYcYzNHBlWMT++UpneTPH6frjLy0g/+I+QiytXDM?=
 =?us-ascii?Q?y2s1DGPZusw/778Jc0zhrEk/+OtE1Ly1PKWt4qeNyGBMXfIhv0bxJ19C6xzh?=
 =?us-ascii?Q?OokucaEXvHo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?glpHBRs2fTKl1NS3As66LsoyNQ9n/KJXhR/O2bGEbTIY9K0pdAhT4iAkT7aE?=
 =?us-ascii?Q?4oz8OJNuZSFOkl4f5Bsi0IcpbYUUhUTdOHDphRHEhg222mYxDGKzzVEXBgYu?=
 =?us-ascii?Q?IdbWgxvEDFKXHZ921vArcYKuB0kFunkcNniuaswXHYLiRUPP/KRbA5zyN2H8?=
 =?us-ascii?Q?CbfZsZQaga1yZLJravVcyjYGJq7mZH5b80ytqPP/gN7ZadOdpQ1E6VuQRzF4?=
 =?us-ascii?Q?k3eB2Q/qMRChVp5oiufwps2WiUd4sE0aMzbh13RuFiAJ/8hgw7XhXG4y2c4e?=
 =?us-ascii?Q?8xhyJMMwSPFdCFtbSIbmjwGRF7B84Nf/wHuJvB8txL/wfsadb4agcJPVNzMN?=
 =?us-ascii?Q?Jmu/n9EI8M4WXyhDPc8FAd8duVekb8KuWeJgs3EyGERxV1QmzzK0vPgWYxfn?=
 =?us-ascii?Q?/MYfd+F3oUVUSDF1n+xHGPDCx9o62rRByDn+dra8+2NZ+td5alvKOgzEN9h4?=
 =?us-ascii?Q?IPeonFDVznUWD06iY9ZPMI7st98CsrEUtfUD5LY8cGRVq8djMd2qSurEnTbt?=
 =?us-ascii?Q?0G6iIhTjEwOykHx8xpWkIWvjTEpfwnOHUnilKufDiPn4HMe74O/kBABw7Xj5?=
 =?us-ascii?Q?Pxml/dagKQ3E7hdp+hPfaEzE0a4myN+CLJl7CJo4mPldVHAW9/j8Dmy+3gYL?=
 =?us-ascii?Q?TIEAmQNGNp96EIuk/8u+jFgRbaCzjawWlp8bJ5O/+UvW//91q+DCjDGr+XCe?=
 =?us-ascii?Q?I15IjjYPBRDhE7PfeEbU61WXa1iswmsOkxheCetjI5noENo3xPPKxQnFZXEJ?=
 =?us-ascii?Q?eaB40nV3qwrPRFqxNfKYaIFUnQ7Hj4y970izGbzwQvOrwgIe5aFocB9W1zH/?=
 =?us-ascii?Q?hA8F0EnJcQzrre7SZr9o0Xm2KN23n9RBA9LyNAnolBblFgRo7iaxG+uoHcr9?=
 =?us-ascii?Q?8IABHwmCbyTHmKz7+nCFvP+4shJZyQsJuyWy28aTKxlJk8sbLE3SYXGqfyPX?=
 =?us-ascii?Q?eG9Wzs8fam4N4XYnD1uthKiaTLyO8LjQGBPKH9vo5L0F9cOqTjMyTFBJ0z2F?=
 =?us-ascii?Q?PHuHj4vzJLjd31rGwSZmxGiogCxFvgmDOhhAgLrl6y96JNXnMZVUvHKrg77S?=
 =?us-ascii?Q?FjHZ2Wz6PsmyMtGPiSQBsRBsvb5mjF+TYkePnlQ9he0ohHunqCexbuPgbKuo?=
 =?us-ascii?Q?xDy4SHkXOYsTu02EkdN7HxDy49FLUXs3cmiL7ZyjSik+PAfM4pv9aGVQuvYv?=
 =?us-ascii?Q?rUf64eVcW6yJC0815JZ37rUQ3/5XM7PSuYndPmr5jyKnp8i42w/JN4cqSGIC?=
 =?us-ascii?Q?tHomMrRiApfRW4T3NMJ2LCXlNxnnFxPc+6oi8CuaYNv13iecl0eMOW58YcyL?=
 =?us-ascii?Q?1AsZD7ycZDOcnT2WgaatE8Kc9N53znos9QXKgLQOZQUtfMa8lYxEQ+0LEWLW?=
 =?us-ascii?Q?hfHuyYqw4ykbNVteJztU/KSnp+KlbLCfTeEx0ViFBxf1u6xbjxUjT1ifqLKW?=
 =?us-ascii?Q?vmvpBqumorR+vsjsljRzILHH4FeEX30iJbDiNZv0kbtgAQvKmY8Pdsetclxj?=
 =?us-ascii?Q?LeGvsCP3tXZKH0P1DlDS1W1bLLEANMqQsqbC4tBorEBsCmxlN/GraEI9JfOs?=
 =?us-ascii?Q?BfyITtn/y0c/ZjmwB6Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 552f8802-e39a-45aa-1f36-08dd454aa2ee
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:02.2335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WiUx7JrZnVDFZhNcZSASbv31Bm8yHjwWYXz7UHl/paHUevymKLIM2QqYBiVbXbBE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

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

Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (19):
  iommu/terga: Do not use struct page as the handle for as->pd memory
  iommu/tegra: Do not use struct page as the handle for pts
  iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
  iommu/pages: Make iommu_put_pages_list() work with high order
    allocations
  iommu/pages: Replace iommu_free_pages() with iommu_free_page()
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
  iommu/amd: Use roundup_pow_two() instead of get_order()
  iommu/riscv: Update to use iommu_alloc_pages_node_lg2()
  iommu: Update various drivers to pass in lg2sz instead of order to
    iommu pages
  iommu/pages: Remove iommu_alloc_page/pages()

 drivers/iommu/Makefile              |   1 +
 drivers/iommu/amd/init.c            |  62 ++++----
 drivers/iommu/amd/io_pgtable.c      |  26 ++--
 drivers/iommu/amd/ppr.c             |   2 +-
 drivers/iommu/dma-iommu.c           |   9 +-
 drivers/iommu/exynos-iommu.c        |  12 +-
 drivers/iommu/intel/dmar.c          |   7 +-
 drivers/iommu/intel/iommu.c         |  27 ++--
 drivers/iommu/intel/iommu.h         |  19 ---
 drivers/iommu/intel/irq_remapping.c |   4 +-
 drivers/iommu/intel/pasid.c         |   3 +-
 drivers/iommu/intel/pasid.h         |   1 -
 drivers/iommu/intel/prq.c           |   4 +-
 drivers/iommu/io-pgtable-arm.c      |  10 +-
 drivers/iommu/io-pgtable-dart.c     |  23 +--
 drivers/iommu/iommu-pages.c         | 119 +++++++++++++++
 drivers/iommu/iommu-pages.h         | 215 +++++++++++-----------------
 drivers/iommu/riscv/iommu.c         |  30 ++--
 drivers/iommu/rockchip-iommu.c      |   6 +-
 drivers/iommu/sun50i-iommu.c        |   6 +-
 drivers/iommu/tegra-smmu.c          |  93 ++++++------
 include/linux/iommu.h               |  16 ++-
 22 files changed, 371 insertions(+), 324 deletions(-)
 create mode 100644 drivers/iommu/iommu-pages.c


base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
-- 
2.43.0

