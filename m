Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D41254B06;
	Thu, 17 Apr 2025 14:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744900078; cv=fail; b=ebe7nPwlM5Bhg6Ao0llOt0RjT51dbVRkUdZsU1N54p9jvDtRvJkjByurG7feFCFl+1Tpo3s1i53mRU6HMmbv/B3ALug4rEW9ixKXqj177M+MwJ+rsdLo1OeIX662TBExh95bG4TYSt8xFXVidGUDarnNDIkATSxHBSjQ81n+fgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744900078; c=relaxed/simple;
	bh=Pb1zhRcfCgPI9bBaYybXtysqWgdpnP2UdZyouUPH9EI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=OCKwi61tQw1ds2eYmhEkwUXgch6yCYz2qz6eszAJv3kcjow2/E1/JdWiL70sJt1LVnbIPmEUFqP/u6mMhT35j2Qb0R4OhZtzzbRajjZY4uohF9DardAmn9MlRTbPnDaO04nHkzpxpZzCd1UqLbZPiBVve2MdGAWN6Ic55MdDuks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=O17gAwDv; arc=fail smtp.client-ip=40.107.101.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="O17gAwDv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bL34IYKPpUH2LXvDcQI9lHvocSQU/fgvClxSCE8MyhTIdVrVd3rDvPlLISjXbqG0y56/uLW4HqBOhkFiukFOkAtjFqt5otzvgmiWrwC+GY2Vv5xvkLNpyxOEoU/W83fWzK0ug9hSWI0CaXjDI5W3AUojKe+H2CgssImNEQ5Y79n8gX7cuv5S6We0pE1s2S+266hZnsHrI/Oy99DTFlXlAvCEsNxE7UmMKNPuVpaRVEZO5g25JYht4hxLZiz8bAVkGdxv3+FT46zDaa4lYUQJkdMTehLoBefaovww4n6iXg0EmLFBvVnFkbdwmZq90W909G/q+qegNi4FhQH9i6YoAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+Pss+HgP86hSM5BcHRiFRYVz+9HrB2stTnijiD0OBg=;
 b=aRDBcqyzJTfRkJTNdW0XQpMTRNS7jIAGembYlx/W1S98OAHiRhahgyKjnLzImxUeUKtRfDFSJdBIRelvQ9+Fcu3/FHkezjxDYMBCm4fAczjsQ5dU0pLkwnp1fLvdY7Q74wiRLIsML2acq//EnNCq0G/OKpMUCHWnA7mwz6I/pI2E6KxGR50xZyFiKelEqXR7OMoBuxQLehWZyi6wzw3jQqR5vbmNhLfzH140CPdlURD53fucHryOrhNWtujFrW03L/pMLuN8RNYGK2EODFZqQn/3SX/HHa05dIaWGdHZwlOry5oT/aQiIr/1Va+fmal8EL7uuCvC7Dmabu8djHWqbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+Pss+HgP86hSM5BcHRiFRYVz+9HrB2stTnijiD0OBg=;
 b=O17gAwDvY0eFj/rlKuQtgTapFSLnLoHhQE/XalhqJlnluw7NASNm7RAvWvZUAa2uZf93IajoH1CA9ejKhg0oWUy2dlqFVuhzjwwLGDA7bknv8UozkGpKvS+TNr5yvFlil88tEF/85hgDxsyupgQxj+V1G4BUhRMAPwNgVTvgIvwhzOlgpAUmvLlkNr+Wm72d8maNCxiLAvbe8TdqH807b0Uvh2lfM34ERYQ/nQvcIE9Dd25QNXYKLAi+ojxxpOjRcEHmTd+YYsqTHx5pPbxm9ha6BBaiixJFboBO5fC7TP9uwTSod1EUqHL/IAernYFShlnGtRviG03gxolVAw9pNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.22; Thu, 17 Apr
 2025 14:27:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8632.030; Thu, 17 Apr 2025
 14:27:53 +0000
Date: Thu, 17 Apr 2025 11:27:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>, iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-rockchip@lists.infradead.org,
	linux-samsung-soc@vger.kernel.org, linux-sunxi@lists.linux.dev,
	linux-tegra@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Neal Gompa <neal@gompa.dev>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Holland <samuel@sholland.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Sven Peter <sven@svenpeter.dev>,
	Thierry Reding <thierry.reding@gmail.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Krishna Reddy <vdumpa@nvidia.com>, Chen-Yu Tsai <wens@csie.org>,
	Will Deacon <will@kernel.org>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v4 00/23] iommu: Further abstract iommu-pages
Message-ID: <20250417142752.GH823903@nvidia.com>
References: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
 <aAEPWXaBocqgsvbR@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aAEPWXaBocqgsvbR@8bytes.org>
X-ClientProxiedBy: BL1PR13CA0165.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d24a9bb-f326-43d6-bfdc-08dd7dbc09fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ua071eoIyZDNInqT7XuSKqbNGpCYw/Nvfxy1QmvcEXmCcgtygnvgNCDoniUB?=
 =?us-ascii?Q?1hzlhUducFhqFolnhYF/bkkHOsR+mug/lDQEGE2ydt4uvrxs1h3va2L5oPia?=
 =?us-ascii?Q?4JZbHXeNLcnda8mkF4ZsUNjz7wbAHlXTlr4Ssq1j0+vGchBxr2FutpvKQLhP?=
 =?us-ascii?Q?ZOUUD6+V2Y1MgrH3MdkWNwMm0x/Xmgo9HaDJwpU9JK/2gk7C0ixzzJ0MWFGd?=
 =?us-ascii?Q?Odk0+a3dS2FtFG8F6D618jbBgX4AsbZ4RiGDLLwYWDKS3nsnP/BIQv7xm/Fw?=
 =?us-ascii?Q?wf1Nn+AlxbW+U+R0G4fQLElFKs7cBAA26Yroku6xF9yISgF9vCPo84Ec2SGz?=
 =?us-ascii?Q?+OT29PtNN4En16fuwYwpG0U3MIzasTy44iw4cYM9gawwO9jdclntm4GNi7+E?=
 =?us-ascii?Q?3qTaNZuU62pB9aFhal7n1+jR/vYIMtzfXx8wd1NuVPuZO4qNE3uRIcG2wNNq?=
 =?us-ascii?Q?n/KpRBvYFPnjkkdFac86R5Lx1vKbraAs0oEGvBj80arRYlJxgX69GFGUd4mt?=
 =?us-ascii?Q?RDgWK/e/2YxRjWZVWaxEamBOkRenoGCw0h7cMHJW952Rd89TNwegoENv4M/Z?=
 =?us-ascii?Q?8P8y76Ju0arSyvbJvnUgjuxZCfob8LhWuGr5jUEDCmVoCSZP27PIczK8C9Bi?=
 =?us-ascii?Q?gKqsQUtf1w+WcAmNrzv6BUIzOV6puR/5XY4THZ0a+VaybpCEZXPCTI/9D17U?=
 =?us-ascii?Q?ZEHr7DUJCqKffAvjJYuNQOw5J9tQRA8um+jTN6XqlzFfBa+V8GXs2YaaxUrU?=
 =?us-ascii?Q?/WgvaUcZBUwdyqFxEUyQw71e4nFcP1d3Q018DQUol4iQwQcI8fCWClNoTLYo?=
 =?us-ascii?Q?GrwfZ2ZRUewOZ0xwWviTPRPDES31I/Ff90sKhqsd/NXTZhTEGUwdscSX3W8n?=
 =?us-ascii?Q?T5AUsRLd2NckqVsac4CQco8lvynrVECPjqZi5Laf0koQRFLLV1Y5M8ZFHefF?=
 =?us-ascii?Q?5WUiNWyAHbnFnTZaUlQV5TQg/xEliNHxqBCcMWYDJcFgo9B27LcXqYuRSadq?=
 =?us-ascii?Q?Yt52ZYLk8M/MiO9gILHxf043okZovxfgTOXXyhpgCkGGBTkwQUnQQrfFaABQ?=
 =?us-ascii?Q?Tb5if45tQQ726csmZC0SkPWEAHAVgMtCzz2tltCN397LrPL0wrzS6y5oEBT2?=
 =?us-ascii?Q?vVLXrq13ekZRLnTzWOQ8Ax4h8s6bll83DoLJ/K9sUy1/7521gzhWyScr0ua6?=
 =?us-ascii?Q?2/J9cZ+4G1TYllrI2nMqKm5YkB4u1UsubTwLKzy9rBPjMo59iDVwkFbLO2bL?=
 =?us-ascii?Q?ozCFmhg5sXbXSXPbNTgPB1q63ouH78xDZN3GifvRXzBqo/LOjN77uyp9USpU?=
 =?us-ascii?Q?kAY0p2Ln5osyMc/dfvu+W2vveipPC8jzmoe8YYN1pYfwH0iv775HjIZs5/1K?=
 =?us-ascii?Q?X5S9NkDgo6mWcrEqfvqMTr94VsryOHd3bCtLX58Un0jxXx54m6mTcoWEVAl3?=
 =?us-ascii?Q?asoEuRHjSxs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N1LhYDE4zUIQBgUYSYC98qkkASuN3ya301jh2u/jsJuU26XiZBeXDD6OXPYa?=
 =?us-ascii?Q?Qug2pQntmMEkkNKBAs0tZPgOJM8GE+Juxbs2Xs26WBeH80VD+OKKUevjSVmq?=
 =?us-ascii?Q?HURGHRHwfpG5G6gjV0gStOeGUyLiyj7RqOd72koZedMf0P9ahZbUJvwm3hME?=
 =?us-ascii?Q?KSVLv9NRzWHcIXBUyxxBjQ/2hpsGGTMJdzFGuapBSafayA5bhNZf+GGGRvhZ?=
 =?us-ascii?Q?TWg9WA+j3h+Mdf0YTw3y0JiUUcesGZRvYh1UwU3hnSwPr41dmPtOHIHKpCwH?=
 =?us-ascii?Q?0mjGCPPfUM+98YphYqbFNt/TNTT4eAcnhdzrLouzBkpASbr+4LsPLW2iWjwm?=
 =?us-ascii?Q?EP0t6Cp0/aMoVw+ajkfYTYvfcsV5pPvecs5MfKSPFBwVxdEoZSnKx3ehqd/l?=
 =?us-ascii?Q?uvW9pl/Ivy2/VlNFpxKnH+UGltEGOjLTQkDK+rpo8e1G2EQzBMgFkSuKpHqr?=
 =?us-ascii?Q?U7m6AvVOM3fem+Lhj9P4BNGFfZ2PzrRMvKhD0WzZmj3TNiUdeTttutTbzpOL?=
 =?us-ascii?Q?XvloAT3mkyLtLeh19o/OGFuF8AKZ5a1HQuBHLVpwTya6UxHRsEOO8QxZY+/a?=
 =?us-ascii?Q?QnZuRb1JfTba5Fj2Zo2mRpUIJs/V468rDdJmDI/FTU7ySnpza0avmLrQPDDW?=
 =?us-ascii?Q?6EoZE/nHNIsebkjk5F5Fm1dScYEYl1ohn9Gd9jefwZfwFeAoMotu6nSYlKOx?=
 =?us-ascii?Q?QgetFcXJKLW0fhqvVUkGhMvV88ZgYMYQ8lnA7qJK2mWiUw3Ujbv70w1hXlzg?=
 =?us-ascii?Q?nnAE16I9AM8oSo40w63k+z2+/O23+fqefxCBMv4GrjTp1199o03cdtYfHElH?=
 =?us-ascii?Q?X2Qm9FauKp2fB4PQRdyWzmvhcKw7HzI1bl6vYP67D4N99ZcRPSzwN8lAmgGJ?=
 =?us-ascii?Q?fIQd2wdFJxG8E5ky6e9EH9TaFx698cbGdA5wwl2a5Zg7kCtuP07ioJljX3P9?=
 =?us-ascii?Q?zty23NXZTmL71Ixnu1UVA7H5qSuCO9XhjTk7NevuvEgtl8acsB86L79LV5uv?=
 =?us-ascii?Q?Jk1nsA2SAtAqbSG+dSR9AAi90e42hZGqWT8cru9ml4YXiv6guIh6fbtiq/iq?=
 =?us-ascii?Q?3NTK1QiKWSOcQv84PaCLrZp1OZfgbhyYPmRjeQOG29pRkPEyqg1hU9DXVm4r?=
 =?us-ascii?Q?AWlqNx0BWhvwYBZgB/SCVgB5iLI6wBzOMKlYrIdg5cYIo5teD5f7Rf3Lcd6G?=
 =?us-ascii?Q?Gk6Kqh1v9q9MCP+vxtfXSKsN0YpYRxAuScBDrUglFhALK8oLImLPPMwFNMe/?=
 =?us-ascii?Q?RJAPDkRNBXpoTjTDa/jHehEjolZLGf1FS4Kg8zVeUE/mZvDqyQyR47vGZma0?=
 =?us-ascii?Q?9MCejxHcto4aBLtZJtKR5lExdKNLxFH0aUrTNB6uZ8d8FmGff+d7UDZND25C?=
 =?us-ascii?Q?EJJ7uJ4Wb8MK+fIAFAuSIOlKzH9bS3CUf8Ow9BCUUuG7skSV9jsmlf87RTc6?=
 =?us-ascii?Q?3Zq6CmD37K2fY6grIl/xtmw+Jz5SbATpriNvZBieizDRAj+g5XYNpDb5vg8M?=
 =?us-ascii?Q?REW2rDLkYAtxOnNd7HJBU6BVbtN2ro0D4RiCiCqCAZ86SReDLes+lpbb6NTl?=
 =?us-ascii?Q?DqKfxkseLjaoEXw/7Uy9kzhe4lbQBSGN7YHfRIZC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d24a9bb-f326-43d6-bfdc-08dd7dbc09fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2025 14:27:53.3030
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D5vaOKUM5EtTDnj3JoWpE0owZxmpMDBh8ifI8rgLspgpbAqsKsTx7u+TE/SHPCYd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302

On Thu, Apr 17, 2025 at 04:25:29PM +0200, Joerg Roedel wrote:
> > Jason Gunthorpe (23):
> >   iommu/terga: Do not use struct page as the handle for as->pd memory
> >   iommu/tegra: Do not use struct page as the handle for pts
> >   iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
> >   iommu/pages: Make iommu_put_pages_list() work with high order
> >     allocations
> >   iommu/pages: Remove the order argument to iommu_free_pages()
> >   iommu/pages: Remove iommu_free_page()
> >   iommu/pages: De-inline the substantial functions
> >   iommu/pages: Formalize the freelist API
> >   iommu/riscv: Convert to use struct iommu_pages_list
> >   iommu/amd: Convert to use struct iommu_pages_list
> >   iommu: Change iommu_iotlb_gather to use iommu_page_list
> >   iommu/pages: Remove iommu_put_pages_list_old and the _Generic
> >   iommu/pages: Move from struct page to struct ioptdesc and folio
> >   iommu/pages: Move the __GFP_HIGHMEM checks into the common code
> >   iommu/pages: Allow sub page sizes to be passed into the allocator
> >   iommu/amd: Change rlookup, irq_lookup, and alias to use kvalloc()
> >   iommu/amd: Use roundup_pow_two() instead of get_order()
> >   iommu/riscv: Update to use iommu_alloc_pages_node_lg2()
> >   iommu: Update various drivers to pass in lg2sz instead of order to
> >     iommu pages
> >   iommu/pages: Remove iommu_alloc_page/pages()
> >   iommu/pages: Remove iommu_alloc_page_node()
> >   iommu/amd: Use iommu_alloc_pages_node_sz() for the IRT
> >   iommu/vtd: Remove iommu_alloc_pages_node()
> 
> Applied to the new iommu-pages branch. I think this has the potential to
> become a conflict nightmare, let's see how it goes in this cycle.

I haven't had much trouble rebasing it, so fingers crossed, thanks

Jason
