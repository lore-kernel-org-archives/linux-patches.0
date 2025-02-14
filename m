Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B849267B9B;
	Fri, 14 Feb 2025 17:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552900; cv=fail; b=mGVQOalMvpvq2u0oT5eM5AXmcp0uFbo7ZyFlotO4n7u1uvADxCpJvaP5WsN0Dq6Tl0etbaFo1ljPEl4gnMcuxw0yDiSV9hpmsug1AOZ3q6m6xA6fmQDSz1Lcq4wqpiElmtE/0Ic7NbaSijzRW950jB4xWXz28H5hlCX3OVisbic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552900; c=relaxed/simple;
	bh=W6Uus0t58ez/B1AhoofQWCo1OGcDA90jPLMxirmMtBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YLwmJJfZXnsCcAlSmslzp31Sumsw99Hg3+XZWczB5IkU9CJ+c581jcIVDa3B+hvpXBSSgODqGz3LLBwBeycxSiI06HvWXBsLqkF3SDuirCp2ws4SyJBcne53zhZ2cNfbtiZYZzB26fDO2NdbDKBfhSUyN8UouxG0uhsRevIours=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=S1QkLCUA; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="S1QkLCUA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DUy58ovA1p2LGjt2AvmuUj15TE6Dp+ALAnuQS4b2aH1pGJF9OAgF5aYZV0SeCl+SBtpPH2k3+PoSHAIZstnG8lh6C06Vvk0d1cULaJkelexonKEF3AqvwizklTrRJAOtPMP+mTX9V6oSDe+lOScEWKSNVeMB4vPvTZc/imG8O/e5aWP4pPQSeMQfai5+iE4K5xuy1fYjxrenfDGSJhd/B+9vCSk9H1hRmOr7zcJG0fB+D3piiWcSjDV73TTrNY0MBuPfO+lpBBu4od68WOn6BARUVpaVIB8BECvz2KnZnctK2e+xmqlac/UxtfiHjFg/hqEQ7iK86aj6xXStaemkmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+GoiDYRV+OIDEEhJo+udCSIygEd3petayce6lj2L54E=;
 b=BzyKGwy2mg5yX7ZdfSFrCqtWZQh/9N9ZTcEk7xrW3AADDh+VOb5HQqnOcIMAqCJihDJGh8yNgsi1sBwcG4TWexppTV+p40q0m35d0oI6fF6/mMt0u/PhRsHhMWEO7p1W24ShALApjgDClPdSN0qFMzvLyuSD1QWnAqGHbjljJvKTFXsLnhLBNYgPRM+Iu3/Y2a+HJy87nDEU005coh2b9W4EPbDKK1gEnjsBf7s0TfxMwsv+K/iz+DVzoJQz2TV9cLHjFCO/8Qhz/KAFAKC3gprSRrbX8qKNiNOFPIzbWlP6gdApSQ59jjM47RfYg1w4qO2NIoP3ziCWEYcoXY6C3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+GoiDYRV+OIDEEhJo+udCSIygEd3petayce6lj2L54E=;
 b=S1QkLCUAo1DQXd2LBAS8ci7zW+rag1kWuXv13gVJE84KYipIQTyeYhNqm0Jdkn9p5TAMgHncEySxeA86Djxwk75aYOwvdrIiE2ueLkDIcBY3Vl7Zq0z1LpKEWHXVJhprcX59FR9zSfIhP1YHZEDhO5Ynl3py/XIQBKw1auhXKePQ+FBnO5RBLu+1No7h1pUJzzvbtNIKQzFy2xRHopW3SsXNDN8XTtN2oCbTZEUVuzFxN8aXR+vxjkoX7crPbaL6EpNdp4blG7zgyG47GlqI211EFmsKxFRq1e4gZA+nqdL7/wjsVnLrFi+ljYD8KISb5T3JMnXxtiZU8VE+dVxLiQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:06 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:06 +0000
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
Subject: [PATCH v2 08/23] iommu/vtd: Use virt_to_phys()
Date: Fri, 14 Feb 2025 13:07:41 -0400
Message-ID: <8-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0026.namprd14.prod.outlook.com
 (2603:10b6:208:23e::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: 81f3bb53-0ce0-4407-d301-08dd4d1a2204
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pEk+SUJo5Bx0LeZ6T68q1u8oX5QWOsR4SdxjhPjqJK2jUwKmviaEkOgs0BiT?=
 =?us-ascii?Q?RMVl6kXwVKj+k/Sdf5qXJdG2YeJOk0iYhbsMTCCWthwO8mGh9vS1b4h4zhRI?=
 =?us-ascii?Q?5qFlTc5F+MfqiOXVaExCY6qgK8PRKbsURqiShPR8vINxEyD2D38fVNMBC2z/?=
 =?us-ascii?Q?+8eVQ3VpvdnqEtc6Cz25cvu4/91JTffe5FaKcsYjpx0iazpZn77Kh4EumWFq?=
 =?us-ascii?Q?wN2gX+U/fgM7slgWp7Ml09WeXPehLmUIc7j6FRa4fJ56K90ibZ44yDrU0iio?=
 =?us-ascii?Q?w7b0AEyqiHPMHaQMNiuUkKT8qbAuvZ+J6QLUkza8ggY5Pf0MW6SZuDVm8M57?=
 =?us-ascii?Q?6XgIq5Z6gsD4RyQm4NaBeYDTeA2/hKvcHLGA8Bue3ceywgGRJ2YLL4t/GZ8s?=
 =?us-ascii?Q?iq7A8sfVBb1hEElxlzey4e4iz32ddhfgDXmmCM2aj1/2kUgwu1DCsMBesxCc?=
 =?us-ascii?Q?U6J1R/naMeQ6GuDlLHJj18fAytwhaQYcStYG8V/1LFBiW0KE5rU5IDiOs0+j?=
 =?us-ascii?Q?fCanBpJ1Gs+wnox6HBuOJI9PXfQ/KfMPrVQHm4Oq7COwtaJR0KyTviZ3uXJh?=
 =?us-ascii?Q?60RTeUlIR/1JNX4v1EFTRSlwZHHxLEd4dkiI8Z1n8xa64yg8sf0w2bHapR/f?=
 =?us-ascii?Q?DseBZuCPhnMm7PePuo49sTM8+cWg85GeIhwLzinZomlSOJOubVEf4vr3Twlk?=
 =?us-ascii?Q?YEHTgrbIUJEtrO6OZiZDKrhByvuxJLJtQRDywRA8DhwGlq3r+YZahyzhWkFd?=
 =?us-ascii?Q?sFnZjWz7t+7xLz09CgJEE4N3lgJhX1RJKQq6nHJPGAphwi1hWcTNk83+6jwi?=
 =?us-ascii?Q?bxj+up7QiRDTJ/foPNscWjzoun4Jk+Dy2m0zkbmZQCMpAcoxzza0liJJ5vlC?=
 =?us-ascii?Q?IElMnDuHfm5B6JThYc+/l99cREfUr9129/ZA7x15QhEyG94RE6vfCZjBRNK9?=
 =?us-ascii?Q?dFpzr5p9Exd5P44abuBncwu7l45ysTT2GeuLbL9k8VXBgj0gTklwn9AGG1lb?=
 =?us-ascii?Q?XewFrykhRD2+UTWMh2EetdjrGrin+OmtRD3gJQPT4d2QdRJBkTkzhz3Xy2VY?=
 =?us-ascii?Q?xygPqalDCGPp6k6y50TvZ6EYv0yBlRVcPB4wP1yGPinWZuYwbsS1WjDSDQI3?=
 =?us-ascii?Q?0GWTfu6NVk0iKRL5cZpfobJ38mjunrgJkaEqYks6XCK03eniMqAmYKmK6NTf?=
 =?us-ascii?Q?fO37yTokYC6FxMRtiBXiJiZerMD2o1MD/LmLlt59wFZIjl9cdK13EXMEgOLw?=
 =?us-ascii?Q?4SEBhi9slnijTamY/8Q3jq3ESzNSda6YxxuWb4G962poYLICVmk6/50gCj/P?=
 =?us-ascii?Q?0MiNfHhGAk6AnnVn1E72+M8A/awiOXdfFeydiGq5tpyY0pNZcGUcXUIZfUDH?=
 =?us-ascii?Q?yWFSihBtV/3GyClKPumESRwTp6uWiHMplzL7JxGrqyuq6Ir97L3cC6K5xjKF?=
 =?us-ascii?Q?ZN9D8wpMgL8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1AX2tBltEgax8tlJ3xMp6GZ32y0qRyrg6U6xMyEAs/jbLiC1af/V8+SUSVkI?=
 =?us-ascii?Q?pvUowKEG0ZvckN2TGuDbpTVkW7Ed/KPMR3yVxe1f+97kS69RzLetn+7pZGzG?=
 =?us-ascii?Q?dcu/qHIjVogMbUf5KbxlE7+7i8sUPf7zOdnkDRiYIqWW+n7U14Ej0lYzvG4m?=
 =?us-ascii?Q?0sRr3K+PKSp1vMbT8b9RJ1LJSVxN17LcyNtYHg3pxswASIBHxjl7GiaLZrsC?=
 =?us-ascii?Q?ATuPsdhUePNXKlRlVWmAJYlGu2tF5zp/kRC9Xlcvh5MuJCgEjANWFAv4YWr/?=
 =?us-ascii?Q?bf2QC7mDfAbGJoCciJ2H0D4t1e8deWojbLzF2wjDucRGg6UFkuLiK3qv3Syi?=
 =?us-ascii?Q?aiMqDa/KkkbhQAGx+TLgnhK8QbP/HQcRZO+i1n+oKFjkF4ZYmIJYNXr/i0Af?=
 =?us-ascii?Q?n8zOQHEdgI7lN+El+5Q2rrpupBX+cCkz44/qm50/sVLv5NXEVmq3DPf1vVIb?=
 =?us-ascii?Q?IYoLdjkfFI2w6TINt1feJbIh4ESfGfMlf31R6Ds2lwL1L+WoQh8PeAtOFvDi?=
 =?us-ascii?Q?J+0XNSK0ADYNfYbqxA48Zem8bJ8ukQKGkoLw09efenLCT6wqjHeRCZ076jsl?=
 =?us-ascii?Q?AQkfRv5dX83ICqZzY7lBmPHvBzXNxRT/Vy9e884gHpOIFrbSiUjqY9ytZRbn?=
 =?us-ascii?Q?m4PUrRWuiPBCeRyuS2cCuSaJAH8UDc41awuj3jDK/32dFXxyGwlWHeSIgfIu?=
 =?us-ascii?Q?b1HTp4fGKTezHwpdHK+sl3/PX4xR1mWe/3Al12PVtjAe3BASXW0frFLC5z11?=
 =?us-ascii?Q?AiUc12/cIgL6bGcvako13hEEWXOD4eqXP8FCEjNVdpS12Do6cr8KqFVqF1F+?=
 =?us-ascii?Q?1+QN5tOuHCF9OS8HU0Gn7vcmRkjlqpy8u1/YLQYBsvDSPixeTksK1w4ohRMv?=
 =?us-ascii?Q?Pq+jI1lz1vc/dUyGHkXf89/cy+2Of0uXQAXNuyQABVS6s35ZxF3Kcjl4tyGl?=
 =?us-ascii?Q?JM5Yruot9tPrObmtQ9vK8WMv4Z1AGNV+QSbJGK+eYZafL2t4dj+f8NcI2ttO?=
 =?us-ascii?Q?AMPQ4cymSDIuczemZBlp7z+uifuiGRXD4MOVtbeD6APU0QJ72GIukJtapj5T?=
 =?us-ascii?Q?/uLIiCEIKLGMwiGHbPBt9qQpqTsJ6iDIWgzqY7OBNKkjdVCihl3+GV0XI46d?=
 =?us-ascii?Q?0K3GwntnRLIMyCouW4dfT73kL30TR2pRDoqotuYPrf2sSIXlE4jx9agv80ky?=
 =?us-ascii?Q?Vx1iEd4XB6s9YoUN5IiHZW7nbmnbXGt8yFgp6jxPF2EoFRpjLl+jBUyBdkVL?=
 =?us-ascii?Q?qCwHVMSPtIhSGirXWZ5Vnohy5khKOCIUUMmos5+OzTakt9flriSCEBO3eTVr?=
 =?us-ascii?Q?C7n9PhsraYPgY1uGNnScUjsRKWW5/SpM7fIljlBcAZH087lqkdFJk6cZU6qN?=
 =?us-ascii?Q?G+xQgeQ95SfuIU7D2/tGcxAVMtS0ouxFiZ79OXTnZbA3e4H146LHQS8UgkzT?=
 =?us-ascii?Q?BibwHDiMY/zlw1Nc1+S2kBNlAyTetS3oJnkZMvZTJtjNEgZIpqynx58m+uwN?=
 =?us-ascii?Q?9zGLf3+9hbaEK/w8pS9jvMMwC5uao0f0a86lQiEcdRAxGIt8HAhH5KuhRQbm?=
 =?us-ascii?Q?Rlojv7ay8thcw5tVFtg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81f3bb53-0ce0-4407-d301-08dd4d1a2204
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:59.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xto0QSs2bKQq2d/JCg0v3p0wZ9nSLBHSiY3feZn7a3QsWp+L//6GYySwLEPJ0Ks5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

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

