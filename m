Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2085.outbound.protection.outlook.com [40.107.100.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6E723AE67;
	Tue,  8 Apr 2025 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744133056; cv=fail; b=OxiZi1aUxRDuB+cmxmSLxlEBPyBPdUbLom2g119GPoi32T8bjkhiLbm0PNAJiMgcVrJTdAwPoB6PkWGVNOmDZ7jQ+n3/KkEbsXZ718jj8miq2uWM/gwy34kNA6qzXMsUdENnqS4WoTqhzcpNyNKqqQbCt3i89y96PzS/cpc1hVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744133056; c=relaxed/simple;
	bh=PBjzKD0Ru4vZtce32vFpJi2/wXppdCS08MPS+1YDBtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i+mbsKB2uvGZcSQNM1LUzz1FDb87SUKQ/mLQZIp29GoOgwqR/62stVtBRIPrNKhc3T5Xn4N6bPDZAJ2yJ7g1+N80b+WdPOK+U40vU6RucGksISHe65OH785br3PyIBC0BIcGb4AfGUiJ+6R360Lobb5xafIyE7Aev5rXvo6s2qg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NNNwoFEP; arc=fail smtp.client-ip=40.107.100.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NNNwoFEP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ydvKFL5QvzfdfyDrJNCjTIkXK/HZZxXpdPvnL9QL25hgCxfH92vR3zj80e1wgj8qDBgip8X/CDL6Z6HsQ5d+nfKAW8KpTh4sxtkpjwpEtvVHFH6EKu7m1Y0BSWkXAcpp055HUGezdkK1/zLJ8rL6b5VebEHH2k6teCyeRD7wVyHi2xnIS/x99LcKYRaVzA6cFtdu69FJt3zmDRTHl1lpv6l50ui8GXBCrHpgBLxn8eri/BQyTvjifYtYZqSGLe0/TO4K9opYYEweojM+k4xVaE6L5SB0JZe4Z7jY4/ifyp0UreicxA0VmJXPB1kcv++aLzl0ch8y0CJsulIH8gQRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q7qlmcwgHfvHAJ421sDqetbE4As5dkLnaGFvN3HG6/0=;
 b=WrbJxeOw65vnYpSNHyBvNQmlqOGMm8D/E90tchHhgV+BwaiTSUjZG++ix1CNjKgOkqRQJb1ZeZKvMahApmoyQL8NasllOR7jX14+7jcKxVpoULJyc5x0eiSoOFVwvWEGxHt/SfWNdmJfQa9VNSMMop0m7rU3R4igKw2HEEZtLjim2buVsCVfopIQDv8ekL2UnU1RcH8YqhdcdEZCYa2dRF/k21KT/sl/LV+4JzRpzYsrYUKlpFKpM854CADuwnoKT5F2aLbfaH2VSTEGHG4vq3Ku5aFslngcz7CW+xnWWjYnqJWDiBip48QbQHjq5Fz2vCGpfG/EhbFFzSJCFBpd8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q7qlmcwgHfvHAJ421sDqetbE4As5dkLnaGFvN3HG6/0=;
 b=NNNwoFEPG4rkNxSIqeRtDsR8VJpe/njVllm42bKq7uhp+bmvSJeLv/4w4X4TjZ31Gm4vdwpmzkbpp5taIBuOBT7++hFRSuHTJDASRd+W4aZ5dvNp6RpdgDYXNVPGyW/TptVdMozZM30VliqBKx6Cd5eGixj7M4nOd94pkdYJnsH8kEl7eJroRmaKrxYdb7KsCD2cJIV9K4A+/ehBQMNGF+ero8m7Lk230ZpXAbF2YBXBDmzQelQzZhr31Cj1n0d0+E2TqKiNmKa6fNrzg2lBX69+9hBtpf4eeq1zT5SG/Hk3upNfLFJ9ji6dZhjDqL73DeFGqHXBVMMlTyjlMaDR1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY3PR12MB9579.namprd12.prod.outlook.com (2603:10b6:930:10a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 17:24:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 17:24:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Albert Ou <aou@eecs.berkeley.edu>,
	asahi@lists.linux.dev,
	David Woodhouse <dwmw2@infradead.org>,
	Heiko Stuebner <heiko@sntech.de>,
	iommu@lists.linux.dev,
	Janne Grunau <j@jannau.net>,
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
	Neal Gompa <neal@gompa.dev>,
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
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	David Rientjes <rientjes@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v4 20/23] iommu/pages: Remove iommu_alloc_page/pages()
Date: Tue,  8 Apr 2025 13:54:08 -0300
Message-ID: <20-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:208:23b::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY3PR12MB9579:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f150fb3-6009-473f-2988-08dd76c22c15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4IIpxLmmf7I+oyLA3A5NZBuRX0q5y6H0ATbw06DhprtDPW1FeS6D1gnzsxRt?=
 =?us-ascii?Q?LJHkzQv9O6FSIrWJLqO3htZeUxAQ5maLDZJ/yZFPcxknlUmOSz6gV8TyQD/e?=
 =?us-ascii?Q?C+AmIOMHhJu/aRenCxTRnFUJkLhrFmxWTYPE1E8AMex0A5MDMG7g7cWtdpWh?=
 =?us-ascii?Q?KNcjgf+9Uy3ZmCYoP6TsmdFzTe8Z92cBDpk9FUVCbZJKyW4HoXKPQi6j3Dnm?=
 =?us-ascii?Q?ih6eo7hwwQZoWRYXF53TPwSR7ROFyuUcC/G5ajLIejIpmGx/G9JuGCo+gpU2?=
 =?us-ascii?Q?mS2QLeagGmA3CKpbAMzUI3uQELS6z763r5BGMzgHE6CPtLvhdUq45Vsqfttm?=
 =?us-ascii?Q?NOp4C40HPTnJG5L7lLe8weU5Fdx8kEEda63pH9VQ5qz4IvBLi5Y+cDJ7fsWS?=
 =?us-ascii?Q?yto4ODbSSEhZ1PlAYNEwaVn0oJD3xfcEWWCA3HGyXhRcTMOq16eP2RjLfGWY?=
 =?us-ascii?Q?BZyOwjzL1AynTjswZnzRYL7zi0AwEtfcg7Je40AHD5K96mNuwKqSuJjFm82F?=
 =?us-ascii?Q?DMb1uzr1vrc82UfRcA41sADqi042th3OSq8NeGgGeoWNfYsKOBrMCbn/Zq9P?=
 =?us-ascii?Q?3gekjX/SZejuaaMC+YL3KGyuXN/Gwz7x+GrrlYgvZfZu587ZTFAYj7qSS+w2?=
 =?us-ascii?Q?hXRTbfujpy0xUEOnxYGoR+4ziPSDIGUxIhsPFCthSl8PoqwWEG55RetMMxH5?=
 =?us-ascii?Q?URmN32zroGLALtTojtsaJ5cK233IA8seH4YAZMzprTAMUOQ3JQecagpPf6nV?=
 =?us-ascii?Q?w72TJakxHHfcr9f9Zhs2Xk9F4fMzW9KoangIICJl/5eEbnzS7tF+JC/VwUkT?=
 =?us-ascii?Q?fqpXmgS5qBxONhpy7vE5du8Op9BPbXOaKLAXzacVxf6rlnQ1jByswqIh+lOU?=
 =?us-ascii?Q?t71G+NVfIJIxRACwgnGj/xLgV0H61h2M1fdRa8RAwXOgffokO9Whpgu+WjMs?=
 =?us-ascii?Q?5m4/ksmdznkvQwIuUVVemsqH7K1nbGD0D7gx211qrHQxBwmQDZo4EvYX+ooe?=
 =?us-ascii?Q?59CjyqCwhje0DM/R9mjHnKkkwlgtNm2ytOGCf+/2YuFijoc/rc5hTOKr5Eju?=
 =?us-ascii?Q?O215wrIqfHsgKYe8SSCCHzgXoaGc3jRh/smCfu6J5E1lyMFCWJ0x68AanJb2?=
 =?us-ascii?Q?XF1DuHBZw9oinEkko1iT7bdAP5A89mCka/Js3kcwzelpkvdt3magfmOi8PiU?=
 =?us-ascii?Q?Uct6czC9AcUSPmYWp4upyKUtCV0pWygu3yRto0p8b5xjBv/jFBau7hKr9uqp?=
 =?us-ascii?Q?2m3Xip9Stufd5SzixwLKGIh/rE2B9xBzQl29TCTCufdCC1ZY0KXMx9QZ+lrb?=
 =?us-ascii?Q?7wilVM5vi7N6D1iktuGWUsMqPa4DZLnMjUjWCeXFEZ7PYPBc+M1MQHM9iV14?=
 =?us-ascii?Q?kRSYTPsc8qF+BGSiRQOjpICyOKTR5mpD1tFTXZXm7sskdaV+QaGvvSV3eJc8?=
 =?us-ascii?Q?zRcxWA7iQVyWPaMDItRE7V2ZpcrviQTj8+WmanbIcHnDSkUaP9vxkw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0JcEUfiCz1BLOpmWLsCEAWp8vPJXiNP230qcgkDypnQdwgXgCx/CQPEJIOhL?=
 =?us-ascii?Q?mGJ1zYLCS05ZvHkXieL0DT1dju+0P3e2NakbqmEydNK/ZiX2HRPfpopPr0/V?=
 =?us-ascii?Q?qMw3MyKNOWvOq+MdaDPaPLCnfiEEQZQtYohSUY+hPzPcz0RVL80wY+TsvbQW?=
 =?us-ascii?Q?0Rkyp4WzdQobF4Ee5UhdzEQDNTqD7pveREhGJVLb1VRPniA/LtNPsQnZ33WX?=
 =?us-ascii?Q?B+Et/cBHlcMDj13ijB8WGNU34UAXQUM9wtUZ6BX+rrwBRq7wDuas+TQbIJpI?=
 =?us-ascii?Q?/n2fsqTHfTcd501ZRVIOKQvFwaqqO/fv4aUyTXeHo+ZoefrliMCFwscyoLA+?=
 =?us-ascii?Q?6HvH9DTfUi9MsDIvPfIwSm1W6GXHzZ74KeMhnu+lNDluThw6Toucx8cpcW8w?=
 =?us-ascii?Q?LCc4RE1iJkEBTeuxSwCvJJPmx+woFGhnALRHWQRvJ8L5seSLP2kpQSmD4Kpx?=
 =?us-ascii?Q?4mEXTcXp4EGOnerfmKIwfS/i4oPHcB0MZ8Ckzonqm9/3B7+mU0DyBtzxs4b2?=
 =?us-ascii?Q?7SKD13VhV2U1wt0SHnvguHogxE362dwAcOmbiXxJ2Tchp8obvovFVd1rTv79?=
 =?us-ascii?Q?tW6SgpwyUOYRzXCRvmk6leiGwt6Utrz0vt4WU9snDleKrimaJ/PO8A4MyOUp?=
 =?us-ascii?Q?FPBxVaFxj5/X2occdQVnGeOwG0REZAkg+LQUSTlnsbf1/yeVE3zdf09yzYOt?=
 =?us-ascii?Q?ncQ/MHX6z2XORIldWV8dw4KTzORny79JrJUFGtqJ2MQ/gCODjcSZkww/uWz3?=
 =?us-ascii?Q?OCsziOepab8ApAHhWRYQeTMY/nxZWeybXOfO33ugyFAe5RoULb8ilWdqvjaQ?=
 =?us-ascii?Q?0xgwIjWZETdte+Rls3+mJJHiX0YvVFFWjAvxRVHP568o8IMFM1U3ET64NFE/?=
 =?us-ascii?Q?yTlPbzAJQA87ufOvGTXw66KGvG3U0cxpORXQDXevnUxNKx7nB8UyHyz5GcAK?=
 =?us-ascii?Q?wJEsQhk44ujAmLgJ0ZO5UBfjT264RETJuwQ9Wp3XfDz7trC82Cc7PiPITYaC?=
 =?us-ascii?Q?LXNdL+Y0ScPXGe+AXfJRpBrXMbpMBIxhfdRRiuNCkHRqipr38oIHw6lPKVZ7?=
 =?us-ascii?Q?dN0nYflFLg75LE+U7jQkNGVzokiCiWUBjXwBcEszPTJK7lWzGmwb8G70QqzW?=
 =?us-ascii?Q?6iibRo9UG/73zhf2dNcNQZWM9fJx3f998FnJaMCaJ0vpkgeixtR7CWKAKJ6B?=
 =?us-ascii?Q?DwUhDfNsDHBsb51BVHlKDhXn/LylbbwRUkif4Q90OjyjzOS4F65WYIC8xdCn?=
 =?us-ascii?Q?/ImaWyLyZ6DJelNdXFU94Hm862KTbRcljzBm4ra1XgGBIUf0NM/ZPCJK5sTu?=
 =?us-ascii?Q?YJvWT0rnpapohDFSePmfV0BLxahfWfeOImHaD5/PRixOjUlnxlpa0cC1HmXY?=
 =?us-ascii?Q?KH3dHrJERhcom2X+4ZXHIl8r+AAPkFioeOQwQfbECvD8wMk4lyzOIKvYWGZc?=
 =?us-ascii?Q?UwExh3j60QsE0RNAWyO4soeJ7NmiX1/WiyBcJQuW78OvcJkWfWOMCYv36l5G?=
 =?us-ascii?Q?LjqAhDSF1VBJ6YLreBoQI+t0iNf2PNRd24AW0GM+txN/WKPJ6Vd7MvUF2EzY?=
 =?us-ascii?Q?HYziS0/xnN78RHef/qEHDIIuKqFMu3pm0BYzkiRP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f150fb3-6009-473f-2988-08dd76c22c15
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 17:24:09.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5wAKUblXdH907AvUbbGs13Pf+fMSfS4fI6Y8+mXM2PXcrIpcvRO5y4g94i3fL+rb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY3PR12MB9579

A few small changes to the remaining drivers using these will allow
them to be removed:

- Exynos wants to allocate fixed 16K/8K allocations
- Rockchip already has a define SPAGE_SIZE which is used by the
  dma_map immediately following, using SPAGE_ORDER which is a lg2size
- tegra has size constants already for its two allocations

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/exynos-iommu.c   |  4 ++--
 drivers/iommu/iommu-pages.h    | 26 --------------------------
 drivers/iommu/rockchip-iommu.c |  6 ++++--
 drivers/iommu/tegra-smmu.c     |  4 ++--
 4 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 8c14073febf07a..62fd66c5381a22 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -902,11 +902,11 @@ static struct iommu_domain *exynos_iommu_domain_alloc_paging(struct device *dev)
 	if (!domain)
 		return NULL;
 
-	domain->pgtable = iommu_alloc_pages(GFP_KERNEL, 2);
+	domain->pgtable = iommu_alloc_pages_sz(GFP_KERNEL, SZ_16K);
 	if (!domain->pgtable)
 		goto err_pgtable;
 
-	domain->lv2entcnt = iommu_alloc_pages(GFP_KERNEL, 1);
+	domain->lv2entcnt = iommu_alloc_pages_sz(GFP_KERNEL, SZ_8K);
 	if (!domain->lv2entcnt)
 		goto err_counter;
 
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 3c4575d637da6d..4513fbc76260cd 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -100,20 +100,6 @@ static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
 	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
 }
 
-/**
- * iommu_alloc_pages - allocate a zeroed page of a given order
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_lg2()
- */
-static inline void *iommu_alloc_pages(gfp_t gfp, int order)
-{
-	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp,
-					 1 << (order + PAGE_SHIFT));
-}
-
 /**
  * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
  *                          specific NUMA node
@@ -141,16 +127,4 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
 	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
 }
 
-/**
- * iommu_alloc_page - allocate a zeroed page
- * @gfp: buddy allocator flags
- *
- * returns the virtual address of the allocated page
- * Prefer to use iommu_alloc_pages_lg2()
- */
-static inline void *iommu_alloc_page(gfp_t gfp)
-{
-	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, PAGE_SIZE);
-}
-
 #endif	/* __IOMMU_PAGES_H */
diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index f1b49370dfa3d0..22f74ba33a0e38 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -730,7 +730,8 @@ static u32 *rk_dte_get_page_table(struct rk_iommu_domain *rk_domain,
 	if (rk_dte_is_pt_valid(dte))
 		goto done;
 
-	page_table = iommu_alloc_page(GFP_ATOMIC | rk_ops->gfp_flags);
+	page_table = iommu_alloc_pages_sz(GFP_ATOMIC | rk_ops->gfp_flags,
+					  SPAGE_SIZE);
 	if (!page_table)
 		return ERR_PTR(-ENOMEM);
 
@@ -1062,7 +1063,8 @@ static struct iommu_domain *rk_iommu_domain_alloc_paging(struct device *dev)
 	 * Each level1 (dt) and level2 (pt) table has 1024 4-byte entries.
 	 * Allocate one 4 KiB page for each table.
 	 */
-	rk_domain->dt = iommu_alloc_page(GFP_KERNEL | rk_ops->gfp_flags);
+	rk_domain->dt = iommu_alloc_pages_sz(GFP_KERNEL | rk_ops->gfp_flags,
+					     SPAGE_SIZE);
 	if (!rk_domain->dt)
 		goto err_free_domain;
 
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 7ad1b3c7c7fce2..61897d50162dd7 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -295,7 +295,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
 
-	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
+	as->pd = iommu_alloc_pages_sz(GFP_KERNEL | __GFP_DMA, SMMU_SIZE_PD);
 	if (!as->pd) {
 		kfree(as);
 		return NULL;
@@ -695,7 +695,7 @@ static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	pt = iommu_alloc_page(gfp | __GFP_DMA);
+	pt = iommu_alloc_pages_sz(gfp | __GFP_DMA, SMMU_SIZE_PT);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
-- 
2.43.0

