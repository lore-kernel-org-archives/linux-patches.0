Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169E8217F50;
	Tue,  4 Feb 2025 18:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694115; cv=fail; b=X/dFSNCDoiPN/jLrYAHX9X+TZ/RKpcBGHgGeU/qdIMVsHVf5MNt0532I5wflP9ZZXrAMaciW+/UQwVCJ6vrgQwvYqk+foTI53dxEW7hAsZW5WczJS9Q8v5e9UZB0rvcIa1DdTklC5B+kNjMGCzXOc2vaEOWp/MempcvqiigXUUQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694115; c=relaxed/simple;
	bh=rV/FBMcr0V+InT1V6ZcMCb2hi3pJD+cHT7FZgIxDi54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Hxk+WSnq/EOQY1IrTgEYtLefVWPNFXCcv1814JdL0yGuOUryxCqB8ofW3ZVRUHYSfBl0/Qzb2LMSYCaH5P0fcU1cqiWqwIX2E/x04xz9jXYbB5BYgfZRTP3m4nHKR2zEzH5aLc5pv1HjqhwLMzl8ACWQ9pouJE3IIw3TyvFeF4c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mrv4rK7c; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mrv4rK7c"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hadxVq8xvHHSCPk/LyqKG9HnErsj8xMov2JA1FCf0OFDAPaFV/Wz+fyjEockuYpHN1x6A3NThXhDxYpuzaVK1wet0lQC3LkN0W+ak2hD3owFizCRslqh4KCwtJmM45qOPgPi/JLZ+b64M62mYTbRn0cDyjeIchHMgRsyoCyapmeL++AQDGFnB7Jvfs54nAfIgkoEMG2t4iebZ11nox/va77io+IpLXD/MvYj1JuCzrKK76QSf4jm3pdT+1USy41YAx93QfCwtVdt+heundoQgWPag9Sg9FkO+J0l9a98Vq39NzfmeLJSzLK6LkPS5myVGQSpKibVaHaVk6gn9TleXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ydUxFe2/srm3BK3d+fonjToOk59w952KjUuqYkbtf4=;
 b=SvZvr8Xjt8pCwFadJkSJN+iR4dVzm62i3IJWwi5JE2EKrRJm5wvf7+o5gjuN89cRiROQ9nqdeRyWRjf6/9iuQSWuKhnwKergxg3R/dRziP9WDPm8tw0hw5d/P+14597Qm13+vxkFAeBejABxYajVTUCt84dXZivgOB8ibJ2O+hUxhRNg/G8i8dH2Gd6pcFvpsApi/1hvi8OWrIbbkce1Jt/oXrE9ys2RmgtoY1+O3VfvfepxCtZfCMJcTa+riAoQm4MdOIixlOQI+67sQChsXOVZmhQgQhox+7EEoP2+AiJc9+XLqO76c+gE+Wym4YxuD+gm8zWIDXBN6paxslVYLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ydUxFe2/srm3BK3d+fonjToOk59w952KjUuqYkbtf4=;
 b=mrv4rK7cQlUxORXars7c2+hWFDvGOoTzaCQEE10EUXHvDEH6rZoxZGQ9pnlMocpo9CJ6DDfgoX/1huSbyxK4Mvx5CgSlQ5dE2HUH/C8wFuEPHQtDWFFCBeP3IOqcYRvc2lfTtxJg0thzIGZv+JokOJ4XL/dssLPM3htvhjuRXU1FOnFSXSwdU6kTnFVWyT+Ddf4AweAn2YsobL1KtU7mglApDdMmSo2Ri7LHTTQT20qQumT5oS1PZEQCJCb5Gi6Loxj8mZIeseSZpw/S6DMBvvv8kpSiOxIgvwb0Cv0Kz20sHdj5TQjmYoVyLgEGNQBWTSRAoBM00sNxYEpL8T2lVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:05 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:05 +0000
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
Subject: [PATCH 02/19] iommu/tegra: Do not use struct page as the handle for pts
Date: Tue,  4 Feb 2025 14:34:43 -0400
Message-ID: <2-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0364.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 7726609c-fa79-488e-44b3-08dd454aa364
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VVibHr5DRlcXvcbSomsbcR30K9uG91W+flBvza2l3pxrPdkJwXf2S+x1YvYN?=
 =?us-ascii?Q?6OobgbhL21+wxyC+GcZe0xfqZuGGuXHnUZKROVqnJD6ZSjqlQ0QSYZMIwPng?=
 =?us-ascii?Q?c6fsg7L6Q/DvzokkJm2BGrv74cF7qF1KM6In9TgfPW+81XhgREZ3b+I5vS0q?=
 =?us-ascii?Q?jrcKM59YDnzlGt/Ck1iELgGtF+OZjWv6TxVvDAtqJfbli4aibklfrYLiqhLp?=
 =?us-ascii?Q?+gbshy2bR0t4AbJucqoSIX5+LBLnQ11evT30Sz1cGTMm4Zwy1VPyTClSTjg6?=
 =?us-ascii?Q?RjXt0zIPyTAelwT4nSy37mjGLJ2e/VgzunydJtdXl+s7zJPUWhANzE8BfkR0?=
 =?us-ascii?Q?1/Ghr906BLHqNVHM4GE0bir85LKC+6FluM7XgmpBfv5boImSluC4EAYJxYsQ?=
 =?us-ascii?Q?63cGE4d/EiXTy8w5q/ARNI5RgV+h5H2VYJ2C0CKbukjJ047vWYIYkhBw9P0c?=
 =?us-ascii?Q?Lcpx4YT1jsTBDmsgKB5wD5Q19ynwvjmEKtZoWZwbdXlUTuTpj0olnHL2QwGN?=
 =?us-ascii?Q?xnzdHyab1mRRTtC6mYhDHO0hon4NhlBPbfnPylniaUKOszXIdUgTvlVEEoVU?=
 =?us-ascii?Q?k4+8fYBDo7Brryy8mIRn/3QN1c7WpDDj9lN7ApYvjb60rcH2xRZvqzG4EqJd?=
 =?us-ascii?Q?2S35ycbobTBSuzz5WpXirnV8sNnr4WvfqeOtZV+4t3gDar1hQgJbJYqnqwkM?=
 =?us-ascii?Q?gSXEND66P5kbrfEk83B5SOpkgmfW/yb5EcSolcNk3RQKzKVv4jCgC4mGVl3m?=
 =?us-ascii?Q?D+pbueLWzYkbxbffcRtCd7hV0OtIMpLP/D1mH555XP7KXBwm3YPYqvgYrXDy?=
 =?us-ascii?Q?Y/HOJ+61Szanl1sOXdABNWDVnIz2T/u7FyBLNqU+3fc+plicuFjYTv2iTylC?=
 =?us-ascii?Q?cyYbeInPUHYcs7OZQ20Fs1Vq9I1PAh0n4QLeu5c90Te/4BmqJE0JvnoXj+oq?=
 =?us-ascii?Q?Q8Act3rYEA6GajgUbaNBtHy8EdtWqcZZHNyReuYM9Ne0uUWUBIHZMbilE9EH?=
 =?us-ascii?Q?Cz+s57yQTjlchX0YxGEt3mEGoOdN+lsUzVdVDMmW3P0/J7gp7byAz4H5S7u3?=
 =?us-ascii?Q?iF1GAuMcTusJJlgRtj+Os8v5X0UUheiTYpBFihH3nujlSo2QZZrGUFpqljcO?=
 =?us-ascii?Q?z3YbVki2bvyEpZp7eijy43pbNRRa8+2k4VR4Yg6u3ulYv+JFX9rzXtZAxppj?=
 =?us-ascii?Q?aTrTiNaoE9CeVUK6McVmqHtd4DIwIzyqNNMF1oKgICRH46/FX1M/n67H1CIP?=
 =?us-ascii?Q?wItrXSRUg4faWC/m1SuwtHf2CQx3yegtRqRqsVuw3Obp5JjLRSeElc/KDS5Q?=
 =?us-ascii?Q?0+AIx22ymgHa8L97fMaR9+O/ww/VqiifC1oYXqrhud1+EHOoClUcArdLD1aH?=
 =?us-ascii?Q?lTLdeGPCKI6Qh9eZYACCUP/MXbrHrEi49EDRqgNLnMk0kZQHxsmIrhTZK8L9?=
 =?us-ascii?Q?5Q17E4PPxEM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?57uUfGQ9rEi+APgCxmHs5S2nmP6gGH6DuloprW+tEM+oDLgVlKszJWepa4Xi?=
 =?us-ascii?Q?RXcAzS8ydVWAd1Xra5pQrbdymdn6xj2z+eFm/cIfQ/qK8xe4mZggdv1PB1rk?=
 =?us-ascii?Q?+kVOj40azJ/ByMP8Rq8ojrYBpvRWvnTudNAKWRyZr7xTn386G27qQvNbVbBF?=
 =?us-ascii?Q?ZchXXpv3pAdxGpz0ebTr0s642lV4bXJxp9SnzKC+Q/xJ5J4rQwROtqW6rb00?=
 =?us-ascii?Q?6v/kYt74AtrVkRlR9akyZ+Ft0dXbbZylo3pdDRPBANl0xi8q9ekB6mb0Wl/z?=
 =?us-ascii?Q?JdwdeWX1EveQ+bv81Kdq+X2Be0/23/zpBcrTVSdAzHb0RQeP+VhoE7oejx/7?=
 =?us-ascii?Q?m3zTAmYdtbe57kA8UyE7vkEml5ymGi/xh631HK+z0SdlUe0OEwMz98X6Hfq9?=
 =?us-ascii?Q?qo6nwGYpDgG4sXL4ffwz749V3sC4f3XkWaCSSNYDsFkJ4On0DVN9duVXGr+K?=
 =?us-ascii?Q?dAoylcUdwPoIzn3an6qcLF830fl0U54MTeZmHJpCvf9iWZig4sK2yd/CqA7Y?=
 =?us-ascii?Q?NTf6tqQox+yYjxkZPo1MFZgk3flV+4MdmLIx67C7M0Q+mCN4GfAL1x3TFAsU?=
 =?us-ascii?Q?2xC6J+x8ll6XOowgEIHHjH6h9oBaRozOT+dQlgjPyPf75+jSKoOgLUvVubjl?=
 =?us-ascii?Q?+8cPi4coAuNgzo+r9R+2aqFN4pU6qFk+t2ODqhIT93iYYWEkMkBRFlEbKz9T?=
 =?us-ascii?Q?hPkqyrpdD0JzoKt0Lysb1+ftH6sAz0NJrhhZ74NvHzvCatHzLc0exUBhtVY+?=
 =?us-ascii?Q?Yg2VyHnct5Hg4LxqGwJhvIoME7hpEu9noBgb/eMmdI9SVjRZWn1QU7zj/OL3?=
 =?us-ascii?Q?dT92Ew1CDA66kPdAfzanwcd9lEK9pHCJicHvsTxl8hNNCjq155ZKbwjy+asj?=
 =?us-ascii?Q?FLaTh7XSR3hgbZr3XEP8gLQ2wUNLkDXy6TXPhQYr8TC9q/Qv5bKAzNVJh3gX?=
 =?us-ascii?Q?dtTQcBZ2Ti3JdYIxIqBfHbhMPR5Hn/0GQzPEYedqBVDMIlPXLTCN+SY/+l6j?=
 =?us-ascii?Q?Z2Im5g26n4NATaY6s35YTFQqRfHmFEhCDaf2Awbf5h1Av5/LUAecsQbQ7a+Q?=
 =?us-ascii?Q?OipkxEF43hsqy1JbiZD7bYONmXUJn8CrqdvR45RlBHJW+/S5XN861QQrZYZv?=
 =?us-ascii?Q?Dbdu6J/T5itwGdVoBaBoI5yK77oEcXFGgqH5sdGozBmbG21ey5ZIc7BBRFG/?=
 =?us-ascii?Q?jVwxcXYiWagHkvBBT5ElNYlc0uEMrcMyJgfXV4f4kyKXUF29452FxVa0r8rP?=
 =?us-ascii?Q?lg7dkS9CJ+uOD2zvZBAyQ3iCDF+iZtSsDZgD7y/7ezOQo7/z3kMyqmGlMa2M?=
 =?us-ascii?Q?YILJNv12CP2yMucH86FXb1PyU8svIod2YUHnatO9MktjbT+cw/xV8r9EzSda?=
 =?us-ascii?Q?WHWyb4E8OwtHYJ1WxwoT+LCdLe9tfn3Ic5F/LEUV59qvtYXxSzX8Vpyxap80?=
 =?us-ascii?Q?ocEo2nzichA4IFZfyKsB5EwUOq1hbtyXZNAZI16maXaI9032EbIn7YGFGKbO?=
 =?us-ascii?Q?1IkSSNsyZD3l/a+FFPotGItd4knL4LHUqFxwFBhCCm2rBiBmbIEHmL5rTSnX?=
 =?us-ascii?Q?Owb1jA1kb9AQjoUK5aM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7726609c-fa79-488e-44b3-08dd454aa364
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:02.9845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxjQWjdPTLHJUqGz39/vamb4yuixxXWMH5vuFOqvaWKxtgJ7271lfJF4r9kSuOjI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Instead use the virtual address and dma_map_single() like as->pd
uses. Introduce a small struct tegra_pt instead of void * to have some
clarity what is using this API and add compile safety during the
conversion.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 68 ++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 717bcd3b8de7dc..1e85141c80548d 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -51,13 +51,15 @@ struct tegra_smmu {
 	struct iommu_device iommu;	/* IOMMU Core code handle */
 };
 
+struct tegra_pt;
+
 struct tegra_smmu_as {
 	struct iommu_domain domain;
 	struct tegra_smmu *smmu;
 	unsigned int use_count;
 	spinlock_t lock;
 	u32 *count;
-	struct page **pts;
+	struct tegra_pt **pts;
 	u32 *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
@@ -155,6 +157,10 @@ static inline u32 smmu_readl(struct tegra_smmu *smmu, unsigned long offset)
 #define SMMU_PDE_ATTR		(SMMU_PDE_READABLE | SMMU_PDE_WRITABLE | \
 				 SMMU_PDE_NONSECURE)
 
+struct tegra_pt {
+	u32 val[SMMU_NUM_PTE];
+};
+
 static unsigned int iova_pd_index(unsigned long iova)
 {
 	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
@@ -564,11 +570,9 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 	smmu_flush(smmu);
 }
 
-static u32 *tegra_smmu_pte_offset(struct page *pt_page, unsigned long iova)
+static u32 *tegra_smmu_pte_offset(struct tegra_pt *pt, unsigned long iova)
 {
-	u32 *pt = page_address(pt_page);
-
-	return pt + iova_pt_index(iova);
+	return &pt->val[iova_pt_index(iova)];
 }
 
 static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
@@ -576,19 +580,19 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	struct page *pt_page;
+	struct tegra_pt *pt;
 
-	pt_page = as->pts[pd_index];
-	if (!pt_page)
+	pt = as->pts[pd_index];
+	if (!pt)
 		return NULL;
 
 	*dmap = smmu_pde_to_dma(smmu, as->pd[pd_index]);
 
-	return tegra_smmu_pte_offset(pt_page, iova);
+	return tegra_smmu_pte_offset(pt, iova);
 }
 
 static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
-		       dma_addr_t *dmap, struct page *page)
+		       dma_addr_t *dmap, struct tegra_pt *pt)
 {
 	unsigned int pde = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
@@ -596,21 +600,21 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 	if (!as->pts[pde]) {
 		dma_addr_t dma;
 
-		dma = dma_map_page(smmu->dev, page, 0, SMMU_SIZE_PT,
-				   DMA_TO_DEVICE);
+		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PD,
+				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			__iommu_free_pages(page, 0);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
 			dma_unmap_page(smmu->dev, dma, SMMU_SIZE_PT,
 				       DMA_TO_DEVICE);
-			__iommu_free_pages(page, 0);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
-		as->pts[pde] = page;
+		as->pts[pde] = pt;
 
 		tegra_smmu_set_pde(as, iova, SMMU_MK_PDE(dma, SMMU_PDE_ATTR |
 							      SMMU_PDE_NEXT));
@@ -633,7 +637,7 @@ static void tegra_smmu_pte_get_use(struct tegra_smmu_as *as, unsigned long iova)
 static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/*
 	 * When no entries in this page table are used anymore, return the
@@ -646,7 +650,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 		tegra_smmu_set_pde(as, iova, 0);
 
 		dma_unmap_page(smmu->dev, pte_dma, SMMU_SIZE_PT, DMA_TO_DEVICE);
-		__iommu_free_pages(page, 0);
+		iommu_free_page(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -666,16 +670,16 @@ static void tegra_smmu_set_pte(struct tegra_smmu_as *as, unsigned long iova,
 	smmu_flush(smmu);
 }
 
-static struct page *as_get_pde_page(struct tegra_smmu_as *as,
-				    unsigned long iova, gfp_t gfp,
-				    unsigned long *flags)
+static struct tegra_pt *as_get_pde_page(struct tegra_smmu_as *as,
+					unsigned long iova, gfp_t gfp,
+					unsigned long *flags)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/* at first check whether allocation needs to be done at all */
-	if (page)
-		return page;
+	if (pt)
+		return pt;
 
 	/*
 	 * In order to prevent exhaustion of the atomic memory pool, we
@@ -685,7 +689,7 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	page = __iommu_alloc_pages(gfp | __GFP_DMA, 0);
+	pt = iommu_alloc_page(gfp | __GFP_DMA);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
@@ -696,13 +700,13 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	 * if allocation succeeded and the allocation failure isn't fatal.
 	 */
 	if (as->pts[pde]) {
-		if (page)
-			__iommu_free_pages(page, 0);
+		if (pt)
+			iommu_free_page(pt);
 
-		page = as->pts[pde];
+		pt = as->pts[pde];
 	}
 
-	return page;
+	return pt;
 }
 
 static int
@@ -712,15 +716,15 @@ __tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
 {
 	struct tegra_smmu_as *as = to_smmu_as(domain);
 	dma_addr_t pte_dma;
-	struct page *page;
+	struct tegra_pt *pt;
 	u32 pte_attrs;
 	u32 *pte;
 
-	page = as_get_pde_page(as, iova, gfp, flags);
-	if (!page)
+	pt = as_get_pde_page(as, iova, gfp, flags);
+	if (!pt)
 		return -ENOMEM;
 
-	pte = as_get_pte(as, iova, &pte_dma, page);
+	pte = as_get_pte(as, iova, &pte_dma, pt);
 	if (!pte)
 		return -ENOMEM;
 
-- 
2.43.0

