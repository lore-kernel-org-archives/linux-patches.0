Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B3120FAAD;
	Tue, 25 Feb 2025 19:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512400; cv=fail; b=tssAC9lvV1Jevj8OPIvdMy3kedzbdZH1FhuC60DLDU+TVLai/1aGua425KAZ63IxqNt1G9iDwJADVUIU4hf7Xmb0I9S+WngL1eFC3DNxuNYS8LC3j2CcOoGQMNKPNV/UNZJi5IgoepHRXMyZxXLgBij8NWQnlYsbu2YcX7vxO/s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512400; c=relaxed/simple;
	bh=4R5BTzUp5fA2R3oY7auvW5s1qNh+zdUpWt3ZY1AxcYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RGisbxsoH6cBKqy7ehjlr8WklAPV9Kw5IfaFNlEr5RnIhbdk5pzq6XK5/5pBnnbWf8q0t2gCtuFOzWvSRQ/B3iXGfDk1AQDURIdgGLTyS0ghnQ7TcoK//3XinhziKHsCcFBQs3KsAK0U8YGZcP3fROr93+Q0arHjEq4cDijUaLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Pzv4dxIg; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Pzv4dxIg"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ErzDhaRy+aumJ5IU66eaVJYtVCjDir8YhGuP+OZccBGognFRdEjTPkzbo79nDHxb5TCk1CyhJqa5oDbxlDKKwTya6arXuhaWajhCuTt+nMBNl1DC0cuzFukPOop213NlnnyjiYxZ2Jmj5OPfRv1v0eaNP47B6j02YjKWGMqKLuFqSH9Ne6JP/VCojELyB6M7iP/+1nD15RTiTYOBN1mGp+N6TnJooLjzlwNpYKycUBtsdVv1msEub9KDXRZlE8fi2y9M9mswt4G9p2MjVyu/LnzKsonmdX+Ea7BtXL3CAVOh/dPT4Ti3yEcwOgu+R52ktWVC+p4zXYrygz09uXsmlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vw5Cp5Mjc7+T41JVGcMLjG1zB7uj96jnTGRvLRPyMlo=;
 b=ryvTZviC9sBO9DvB7hCglzZ0yBsrp2aEbuzhs2Iekc2CHy1C+21bEz+ln0503xu/9TusXmTA3gnyJ2lmmgLQvC6LtSsIlTuUQBR40X6F+B0noAupqI5MWzxgP2VhrgptIKVfkj9Lbs6w6U1SweKV0avUO8Ga5J+VHFZzuMD8m6LWgidI2boVls/m+cxglSvpS87iWmRhFof1hBiOH9at90MjgVCRYP6kWgwtWVqCIU63wVgtHfxffX4GnpAOZrgId9BCRy/eodrtQu9ibBwPMrWYKlXHWJr2Alc3aSXkbP69X/o5p4uFnkRJZpRzbDvDj/azYFt+uqdDrNbEqy6PdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vw5Cp5Mjc7+T41JVGcMLjG1zB7uj96jnTGRvLRPyMlo=;
 b=Pzv4dxIgxLGQjk90UdGYx27/AxxMIms17Hmk7LUmAdZnvT7lWob++uYP/PS9/7ZKE6S6I15RafCh5Mvdxg96fmljkOtapM53cjbIq257OaZy/1GxVdD4a9Uk3//bQH0FJs3Nxh1d5HEypCT9+a8c6AHMQSpPndVerPShoJObxkLzAdkbY0L5Wch27GaayX8QOipUX3vhjg46laL6NPJnmPlUIv12rBsnLKuO9Nvez3prLb7uu4skpBYXFLXFIcbPEsEDtpopW+rPsarVWD6NsHrXp2qaCh8oE2hZyo2tYM+eVWkGW6BYtriU0UVYnDFADC35/vPFPu7Ye9GaBcJRCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:47 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:47 +0000
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
Subject: [PATCH v3 08/23] iommu/vtd: Use virt_to_phys()
Date: Tue, 25 Feb 2025 15:39:25 -0400
Message-ID: <8-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0074.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:84::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 9cdc372c-1af1-4975-e9fb-08dd55d42743
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AfvR0yQPfMtoo9kR5KCmwffga7+NtI/HfO3Og+K/+Q54U+p9TohR6wzHB98X?=
 =?us-ascii?Q?lApHNVc5SRCvWgLFWtgh+agCiWtU9ctjOx50SxDeHvRYczYJssAqNkcNaZYU?=
 =?us-ascii?Q?tiJj37NFlc86kSa+bgQkVH+HAWy1Dl58XZZbFxRPs2aUgcONdPYox63/KPKW?=
 =?us-ascii?Q?Ma6pHeD7S8QWvfNNzuXMmdSGigomD/kNK7QfU839aih/JJm80G7kMX5bT/Id?=
 =?us-ascii?Q?47vEmMS+cAeErgpOncE5r11Lp9xpJ0V3NWnxTXlYz1DeuaxEelublPmL1Xmo?=
 =?us-ascii?Q?JY+On2yIHwCiykkJmAX6s/RaiEPNxQtO2CgrcUOHq0PUsoQjco1pt/YLxmsd?=
 =?us-ascii?Q?cPISS5nDYaYS0pKi180EsAq1KXMShz68CjmWNX4Ud2HecV7BOy+yw5wihH5N?=
 =?us-ascii?Q?WktVALMjLlIdn2WBPCVvr6vANhwIoqwKR1A2WeLrjN/qxCMja4OIzj/5tBx3?=
 =?us-ascii?Q?l7VZ47FGifI/zFEktmRoaCQit4VfjO5aSrZag+S8X/ZrcfPV3pkoXv3XWotq?=
 =?us-ascii?Q?RdGiND5h3K7juwLXEjezU1Ykp6yqNY3yFjGl2kXJLuFo8pv7yJsbme0iaLSe?=
 =?us-ascii?Q?iKeYyA354ivcAhtr3OPKSQbl4kfXZfUdAetrfXfNkEfujwIOXBqGNcuYXihq?=
 =?us-ascii?Q?sAOvNpA5YORBLZrpVsIkyTX5L0bvqeyiXjVum9Qx1DNOYzC/eZP+JEKnYLdk?=
 =?us-ascii?Q?BvwZ+gjftJvHxPqFlI8TjoxRsa92TOZSVLOrRLP2X9MfPix0upZ5/NwthVbp?=
 =?us-ascii?Q?m0YzQ/S874dzjJx5XrMIEFcelv2+jrBoOKL8spEkSPZbBM5buNNjXm9PRl+9?=
 =?us-ascii?Q?F59p2gVCtYhCPI4VO+ff6dktyKr/Iqu0YqgdrbghQJvbVlDMQd918WF5XHZN?=
 =?us-ascii?Q?Hhro9qVLrlVyJmVasUKKSkVPk8bz0BHHsci4hl7XvR1v24e1hJ+wFVyliL9B?=
 =?us-ascii?Q?dRKJdGAvBeKYhsMvBbsOYVyPx29lR5gMcm4vMNAJhVYZ+hw7t+YMmpu1/2L5?=
 =?us-ascii?Q?oQV+45bE25LnE2cUAYokXWrJihLeNBZd9wVUkQa+SVOgiZyZRUL4tMfEfDb3?=
 =?us-ascii?Q?NNLNmKd6sIritMGCQO3g4OQIfoBzXDHegoN7rx+DqZgZKj8G4zwpXgzap7VC?=
 =?us-ascii?Q?M94i2o+p8alEwtf+sRfL1aXorXK4rFze9x+NxZtINIjb8tEmJfi7JUojqFbK?=
 =?us-ascii?Q?uKhI0+AZMQanY8FColyYG0jSUtdC565OvoppHvPrRTcLNHHqcKovDQNwXUrM?=
 =?us-ascii?Q?Pr2MgHTrrDgIQFemgPcGcea4wZnRLV51i3XIohtKIUzvjQQqr1JrBJjmcKvQ?=
 =?us-ascii?Q?f4b9GjaOyiHf5++WdkTBdFkZozv2pfd99rt78oijlkKK+FDEaGkOXXEUoMHl?=
 =?us-ascii?Q?hZDe0+CvGg9Ipjw5/qtXuxc2FNwgI0uzudVAT7Aa+pGrahEndyTDP9oDaDkf?=
 =?us-ascii?Q?/R805cr8hyY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PUf1ipa7hNjmy3uQpvdVXKJZjvlK/llF8SS8sKxeeWO20oAK6Tfjes0xuER8?=
 =?us-ascii?Q?p/dPvONztxjhfpJ6dovmxoDOMdpDuSzGhIa+lOryVj8rswjzLS1VJQKU9s0K?=
 =?us-ascii?Q?2u+nrb/Ok9lfvFzXkY74rjYQwG/xhJqdUbHu7y6MhrpHmmDs7WG3LxdNWAFt?=
 =?us-ascii?Q?q5lT9L6VXE9NOI4cBtH6STqaoq4hd/R6U0MUFE0shcy+9IKgg9RJ1X6jnIgi?=
 =?us-ascii?Q?bt+V9HEXk7vy3Ur2JNB9punUfT6PQM76eC3TjuQqzwQLlXaE6g+2F9DaIO3e?=
 =?us-ascii?Q?xivMEPWXP62VrunGoNgNbU5+iOJdwapU96bzHo1kDQlwTIk3Gn67v1jXg19G?=
 =?us-ascii?Q?fliszFSBgQHymCTYluAt1wXO47gyqyhdzekFuxn5YkyAxuA8YVfBYPmxzkq1?=
 =?us-ascii?Q?H9YQTkxrBuJXJqFUA1KHrEk+EZ14vDQ8NqcfaAW8Gxn3rOkt7KN8C9aPpT6T?=
 =?us-ascii?Q?qqsyMWx9pgCPhgfI636aDBLP2d1c0GH4Zj7jJjV9NLGQ+5MrOZamlfmT9EtR?=
 =?us-ascii?Q?L3aUIxH91otqiMzoMPBMTR7TBsz4AnBNXojGcED85XwmDRZrYHH+VASQe/Bd?=
 =?us-ascii?Q?jKT71xv47TkumxOy5FRqg0AmcuSJZ1Iwlp4aSKlysHx+Cufx/Xqklnt6RTVP?=
 =?us-ascii?Q?eVC4luf8+EHNk7auH2MpxApS66puPGmcr7B0yHeqgZGyzKVl9BjwOujekJ+Y?=
 =?us-ascii?Q?pL/WdTlEQwaE1XcTzKkBEw0d+O2uiy/z5rurpO7i6FNSXPTUWHm/IDoiXHfi?=
 =?us-ascii?Q?quGa7k6ot1m+M7qrLccH9eHPJpo5KeKvDq4jXA0sZzLvrE+ielTkjMpUdBVk?=
 =?us-ascii?Q?MxW6pf9Hn+BQudMxT//EzJAkOx2DOLH0JtIQnDpOzekrZyPhC0DRya6CH6An?=
 =?us-ascii?Q?0zDYYXFqwDN1gt5YxEDKauIbPIDxQ/0CzHlF+YrY6c10u0xqv0LoFw/Wgeaz?=
 =?us-ascii?Q?MttwJU5b30+8niT8uNrvfMtUlCR/LaAwl4gdeAJBKCRLVElpnrfwBvX7p88S?=
 =?us-ascii?Q?ivWMFyYzCfohYxRLjmNKQWPEzZwJB9OotrFVJb7zp4zjCDmVmwIKdTtcmYAl?=
 =?us-ascii?Q?MPbqUeX5Pwci6rL6kxzNVvlVPbJ/MDw+O816VEXfNSmGMvIICL03WW9EJqRY?=
 =?us-ascii?Q?sesec5unSDsgaTAF7o86srh4R938DEEQfrXaZlM80kL3E1HYAONXKkxG/2In?=
 =?us-ascii?Q?RY3FxJ8vustFPrU5xWpoOU5QnjGkcwQTuq7NBsbS0JPzVZzojnwFZhfs1CHE?=
 =?us-ascii?Q?bYPArn02fAnACY4n6upBHiHwtOfgKEP7I5rUNnZqHaV5DbeIhSGJ9XTs9mBN?=
 =?us-ascii?Q?lTUkSxMa1osXtLaquzDUbs2hSpVg82rpky+Igb9ZcgkbmditPlj+ojN7A1eb?=
 =?us-ascii?Q?XTqZwMKoCrcb4NEG9elxsGeM9IpOmTgvjCAvjiR6blN/r+a597tROCzNBsiz?=
 =?us-ascii?Q?WArz6q8Ykx6PIHQXM3cBmoafLeta9qOm7N2+kP4rWBv8okL2oIyGm6+tyBQE?=
 =?us-ascii?Q?r6FuAKIhbiPw1SQAjFBGNZ7qHtL1qtKDS0wYizYQ7xB8PzuqWKNG/8hV0xga?=
 =?us-ascii?Q?COzgLjpHSGW8JKfKuc2CRNJXMnjoUtOlUpRAO5nd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9cdc372c-1af1-4975-e9fb-08dd55d42743
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:44.0457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XVt3fMTQitOEnDNGEocZt5pVG72gM/OppuykYk1z9MaAhsve7X92TT9TmLpjyLgA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

If all the inlines are unwound virt_to_dma_pfn() is simply:
   return page_to_pfn(virt_to_page(p)) << (PAGE_SHIFT - VTD_PAGE_SHIFT);

Which can be re-arranged to:
   (page_to_pfn(virt_to_page(p)) << PAGE_SHIFT) >> VTD_PAGE_SHIFT

The only caller is:
   ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT)

re-arranged to:
   ((page_to_pfn(virt_to_page(tmp_page)) << PAGE_SHIFT) >> VTD_PAGE_SHIFT) << VTD_PAGE_SHIFT

Which simplifies to:
   page_to_pfn(virt_to_page(tmp_page)) << PAGE_SHIFT

That is the same as virt_to_phys(tmp_page), so just remove all of this.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/intel/iommu.c |  3 ++-
 drivers/iommu/intel/iommu.h | 19 -------------------
 2 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 1e73bfa00329ae..d864eb180642f2 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -737,7 +737,8 @@ static struct dma_pte *pfn_to_dma_pte(struct dmar_domain *domain,
 				return NULL;
 
 			domain_flush_cache(domain, tmp_page, VTD_PAGE_SIZE);
-			pteval = ((uint64_t)virt_to_dma_pfn(tmp_page) << VTD_PAGE_SHIFT) | DMA_PTE_READ | DMA_PTE_WRITE;
+			pteval = virt_to_phys(tmp_page) | DMA_PTE_READ |
+				 DMA_PTE_WRITE;
 			if (domain->use_first_level)
 				pteval |= DMA_FL_PTE_US | DMA_FL_PTE_ACCESS;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 6ea7bbe26b19d5..dd980808998da9 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -953,25 +953,6 @@ static inline unsigned long lvl_to_nr_pages(unsigned int lvl)
 	return 1UL << min_t(int, (lvl - 1) * LEVEL_STRIDE, MAX_AGAW_PFN_WIDTH);
 }
 
-/* VT-d pages must always be _smaller_ than MM pages. Otherwise things
-   are never going to work. */
-static inline unsigned long mm_to_dma_pfn_start(unsigned long mm_pfn)
-{
-	return mm_pfn << (PAGE_SHIFT - VTD_PAGE_SHIFT);
-}
-static inline unsigned long mm_to_dma_pfn_end(unsigned long mm_pfn)
-{
-	return ((mm_pfn + 1) << (PAGE_SHIFT - VTD_PAGE_SHIFT)) - 1;
-}
-static inline unsigned long page_to_dma_pfn(struct page *pg)
-{
-	return mm_to_dma_pfn_start(page_to_pfn(pg));
-}
-static inline unsigned long virt_to_dma_pfn(void *p)
-{
-	return page_to_dma_pfn(virt_to_page(p));
-}
-
 static inline void context_set_present(struct context_entry *context)
 {
 	context->lo |= 1;
-- 
2.43.0

