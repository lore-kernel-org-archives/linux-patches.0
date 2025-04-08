Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960AA2356D7;
	Tue,  8 Apr 2025 16:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131259; cv=fail; b=HcWNiEDhdn2U1DYPheh2rTgyPZOKITDpr9jT9kB/VBaWYYdeMVwX3qinBwvVqsnNJpURCkmYavQQZkzKWqPBD86vlwctwWnpk10cAwjyzLyOax8rap5JN8D/DpwBXBkDFEfM0GFmSq++R4pPz8u4TReggqeQl2fTmzUYjY2mz5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131259; c=relaxed/simple;
	bh=PUJDPWYC4/no3qjrmot5lS/lvziKCVxFJbJ7M2H7K6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=URbvy7j3rindSQ6iI7rVVD2OaLEDF6Fod0Qv12eyIMBW1dFOGKpNbNgNHiEcC2LjsUhk1zFgVYmMR2vw7YOSMu1YjrL/u7XdISstfHWt6ijsqkjysUV9bEaIEUL+w6WvmGssvcet6EQiAP0nKIIkzciAIAF4bRLwN+0qu0o0D8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YbFY2Z8O; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YbFY2Z8O"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UrktIlsmMKGESOEhGRG/smSH7s/OD558IBHp4GNAC1/Lpd0+KJbCgVysFiqIsCcd3Ka+lRGW0AOi2tUf479sy+mpRuxVNDpx/Wik5YKhoK5e03ttpoBPhc0eZpBYPzuK4vFz6q9DHmVXoYXHe84FPXRTkEzYCT2VhzSDPXWYA55DSUkeLsn5PjeQcHIe4bhqN0UWvex++/VEaz+DZDA4Zn3gyjesI35GkaHgx+iO0CZKV5p33jp9lzx7DyLUDgBdR5nrz1IsR2nvBqJbrSR/sgDEonTNjageQCBbNbkx3pwEYk7Dh+4tbB8uvHz9gAMzYFRaxK2VqJ9YLQU7wxGsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EzAXJ+TxXeBkUyWUDTLph241TjLT85iu5i9BTjUh1sA=;
 b=wU/eM5QmGqO/7+POcrH1jNt2sDAWNxwdosiUje4OVWAm5OFXLkfNEqilI30W4K6gDb7J7nnCs3sYzeAyuAS4Ti97kQEBLISmJOh2uDMao8QDnhDvQa6+ne+/KNo10krMkA/bfml0/o1YM81Y9oj4ubpVKTNpoRNkrZubFN6Nuccz96rWyxmW73LSMhjbnhOdpSppSDY/xErN6cdkdhLaO5vnxHKk4JS9516SysdFiZB+Q20NyF/KEyh+XiIJbqvMUOFniXmrkeQmvo5zRskU+Qusx1AvnZuk6Oq2I2Y0rwPkndth8WI0ollhNe1TgudJRqy93btYdbB6g8ICxj9iIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EzAXJ+TxXeBkUyWUDTLph241TjLT85iu5i9BTjUh1sA=;
 b=YbFY2Z8OWNJhfIcN2nbPlftg4orvX8d2Av9eF/ts1F4PnOMiSSeMjmZti2kEpL+wmvm/010DSdAIHlAlnZhk7ja0URUT4UGSisKDA62N9i0aOjOsvFmKZnO5xuTXx7IaevXfAQaowRnmlLdcViBD1JfMx6ujOkGqwOyI8Ihflx3S1kKoCw9E/K/jyza/xyPCwRdWLOJ1NdrnscVuRlPGWP9J5yPDYl9lNwVNMR1PArEiUfe/jZvvZt/cjWPhXEmeH9uvSfD8mId8qZGNdn5z94muhXVAKn1r7ptPq0NyNTftZDPtU9+Feelk8/a9qTP0GEQCle61TEUVRe7l4fiC9g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:13 +0000
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
Subject: [PATCH v4 02/23] iommu/tegra: Do not use struct page as the handle for pts
Date: Tue,  8 Apr 2025 13:53:50 -0300
Message-ID: <2-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN8PR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:408:60::38) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c6dcf2c-f5d2-4eab-c165-08dd76bdfd80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CErKKMWjSfx9caXkn8ZydET5FLGyHib++1p5di2PQl5dY6Pdd6wVFhCLC2ki?=
 =?us-ascii?Q?KXA0dfzJ302fYi0qu7FNFNtpFmHvQZEYfuR+3q7eFej/4d9zBsUZmG4pR5QA?=
 =?us-ascii?Q?VMaCA8Q16bzPKXt7otJf6VywwUltemVPK9NugIt3NrUlugW+H3sdkiQ5aR0m?=
 =?us-ascii?Q?fglg2KyHlh3lAcaXTDWurLOsPznNX20lwAOZJratoKjB0keqcRAVPCXClT5z?=
 =?us-ascii?Q?igb3qzQluxEt6ztMfLrkIeJzmqXey8zVDmev+A1DlBxbZyA9VqqU8OaFQFMq?=
 =?us-ascii?Q?IiQiinYBARMHI7PQF5/A9IcTuxKijjC/HuA63K4g1ua9sDZE2jev1wNTh76Z?=
 =?us-ascii?Q?7bz2bkiaW7UqpYuAOXeFMh45W8ILRucIAGgIM6oqDh7tJ28qSUMYLcM0h7kJ?=
 =?us-ascii?Q?rXvIBV76UBprmIVat3Z0Pm5fwVlDtgfps53FK3r8X8mqZb1BGvN3Fa2MR2kY?=
 =?us-ascii?Q?duHRnx0jdXS2CvMxhv8gvAvsyKq2vk0AieMvUg7b64lsJgH6KsgPABtESS9P?=
 =?us-ascii?Q?aHcEKsxOd17/UAKSLKcIfa3oDcfleUhk6lM5UqCSNJHeWA/DY+AiACdjwc3B?=
 =?us-ascii?Q?Gol1yEhzG1xH/5sP/dmU2Nb+6Res6whiwV+e2Ip/3bm58hYJPs6NffMRsLBH?=
 =?us-ascii?Q?eCU+RirFpxWpA7G0CEPiusMm0Ho7J3OMeog2fOveXcJj8NqWRxJHLlDpZYS5?=
 =?us-ascii?Q?zWi0RtyBoXvDdEbdoxCJOLrNDytdVsXzq7Cyn6sgwvX6/sN75QHGJ3PhWVZ6?=
 =?us-ascii?Q?3KicUwnbJQSprC/uki6QmUexaxwfRqkOMERHpO6239AdgzSQRS8fm2PJka85?=
 =?us-ascii?Q?HlcxfGwEE1NTF2+Z3wAnATR24FC47oqA/LqV4ILviRYb/52md76nCkTaOu/M?=
 =?us-ascii?Q?9mWbcO/o7yIWpy+sTjpeUK6mZdcBbshiLXc7SNvWDjWr5M0nMcIdAYlh6uRu?=
 =?us-ascii?Q?w41ndiDT+t53pEO0OpzE4Gg1KDkXuNhoO+QgWCbbVZBCriomamZWRpquQW09?=
 =?us-ascii?Q?mk3axya9OyP6BQfa/+YZT8IV31t48W4D3yajESaAszzhOybHJKj7RAluJl69?=
 =?us-ascii?Q?pnCuJIg08JwWjqa/ilwOXz/9LyTgD78FJP4FXAHyoovsuasMzaCfX4S2BZ5G?=
 =?us-ascii?Q?aReqSoQxn3xBWdLv8KM5RyGsjKQzz35ZFPJklY1ftKBRaQJtZgCiiPgM4+y1?=
 =?us-ascii?Q?MSc/OoUSZU/M1NyzsO5cp+lO0JV2+dGhZ4oEwigBjmGIWeAFKRAoBKFJr4v8?=
 =?us-ascii?Q?sEbXqvrZx79JdTMyM1qN0AiuTWH5TzUG+BAlKwCWNNPO0MHJfPDO4B645oC3?=
 =?us-ascii?Q?XBB6czp7gafO4JOSNhA8mNrIfJqlB7aQsZCepKO08TvNuivHYgWneXm6/QJg?=
 =?us-ascii?Q?nTggr9dmnj3r6LWHTgv7WDlmgxCvgmyYVKI7wWTVoHx5hBJxdawepYC1mBFL?=
 =?us-ascii?Q?rYEoEe09EMzIJBWqxA3xbgttYRP0nvS+NicjlfLTf6i1t+kBu8+6vA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7kHGTI004qhHSMuvkJZdAAYUC4MRfJC87JsmV8z+OAPfKSgrjBztqVi3U1D8?=
 =?us-ascii?Q?AI0NaUgtzygj7kL/9orWrUY382BsdNY2C0Ufvah3tuh8DuiiVKH9cJW5/9HL?=
 =?us-ascii?Q?0c2/ByM/37Zw713DPmJasyXeRcFzWaxmFFZcxn95+BLGyR+70sBbPmPnQj32?=
 =?us-ascii?Q?2+ASRLUArvK08h4pr/ao1W9IaZAv+Zl2OvQOK7m6in+WBlG0wntCBgj5bCAG?=
 =?us-ascii?Q?+Tocg3O+CLUURhPtYU/EA6akm2BaSHSFdJSvBxGaY+63ZlSFGTvRbpOwcPXn?=
 =?us-ascii?Q?ObmYrSb3TixbB1kkD2+/2VZCAnr3i7wLihCj/0mV7DWC1VTXkikdRDH3Y7L3?=
 =?us-ascii?Q?KgtivIT+bUT17q8B7nUvuE6oD/RtEg4wqNaSy/+5Oteg9r7L+dj7GlPERX4i?=
 =?us-ascii?Q?6Ju55EwDDXDSztqDNptz0vCqvnDiDvpwfwzQP3nyiw7lNLlpSlaO2GOhaDXF?=
 =?us-ascii?Q?OZ7+4FSBq38163vLqtxunlthGToyL3Tmu1c8ySJTawnIK8/yXuZ/dCbR7t+V?=
 =?us-ascii?Q?7qsJ1ykdl/erEPzqTbBR0ejOTrqCqgoxRMNSwrSA2mKx5MRcQgv191FUHLF5?=
 =?us-ascii?Q?mcDpjV1L51hG3+Z9rbeRkPOTBpAgL4R/dh+XlvjVR6Nup210kGiGCko922fR?=
 =?us-ascii?Q?j3Cyt92V9i7ahnGhFI6SwGs8KlmPZjg1dC2KT3GdCJ9xJ6VuL+YZXLXpI4P4?=
 =?us-ascii?Q?NwQQW8AfHJdzpZfydmeGMSArzMJLvNPFRZVx65CPmJMstu6XH8hwiF/mGChR?=
 =?us-ascii?Q?QS4dCgsq10rZaF7gIDKVclcdMM3V+sgVWt2XMWUdsyeyCu246yURi47sgv1J?=
 =?us-ascii?Q?PaKuhRJqVZ5oT2VrEkYEwupEU1CNqYdHfwX/uBtZ6Mo9Xf57cBTOD0bB87JI?=
 =?us-ascii?Q?YPH+iFYuBp4r4FAszxEOh12DGXbc8hRG13Lq0aIbqx6X86pRlE+jvO4r2w/o?=
 =?us-ascii?Q?nM8SlF1t1c6h1tWMVon3FcRn89sIFisoOBihL35zBuDBQWbJ4RxiOyWsduan?=
 =?us-ascii?Q?QCVEiA5Lv4dnFtHNwTbQyvFg5YChevzN1ZFdlH6PB3lbr2bcE32x6hoy/GcI?=
 =?us-ascii?Q?EjXgOIRRgA+xjXCiDcs3htgiMDhF8GOknP7RKqKA+EdVpNberW2ELJjwhwNF?=
 =?us-ascii?Q?q2ykQsQTswCZiQ+dvEv6KPOZVrH3nUud6QuqGAAweB2jK6FC8cMnjGUxA7mo?=
 =?us-ascii?Q?o909LMZ0T4XRgz/c8B0EY+nfGmklPwnPjEfeIUt7PvVqX5QaAhhTlWdVfjjP?=
 =?us-ascii?Q?y3tisjK0sMOocyahYPvEKFDoXMEHjO4yiiCrEhgFr6krc2siZxyPQ8mGVVA7?=
 =?us-ascii?Q?L3flaqDNE1I4nB2NCIa0ZOVfacbjB4474pqX20OFrrFsNQvJglhKHP2aEvtG?=
 =?us-ascii?Q?vramkEXJL1fNJe+ydjMleBskhXwoHKT6GoQQ8YmDHYgJAwpcjOuy91Rx1Y/j?=
 =?us-ascii?Q?CmUL1xtxFOlzqgVcaEaBludyRlexBMHbIQB816rodGJKC9aN1UCPUCeVi7i8?=
 =?us-ascii?Q?lPGS8W/PtM0k8QWG2KSMsp5aI/zuL8s58dZHpIR6e7htQ8owXwYJdiGCzbgl?=
 =?us-ascii?Q?GppEss1CyKsNWE2huLqKQgVt6apgGqNSyzlqYeyF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c6dcf2c-f5d2-4eab-c165-08dd76bdfd80
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:13.3137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tgl49oq7UhLcoQO2jlcuIF9nmvrEFZh4H1wjebVPLVizHh+9HWNJCDgQUnUW+6NJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

Instead use the virtual address and dma_map_single() like as->pd
uses. Introduce a small struct tegra_pt instead of void * to have some
clarity what is using this API and add compile safety during the
conversion.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 74 ++++++++++++++++++++------------------
 1 file changed, 39 insertions(+), 35 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index d040400ee34ac7..95e97d1e400468 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -52,6 +52,7 @@ struct tegra_smmu {
 };
 
 struct tegra_pd;
+struct tegra_pt;
 
 struct tegra_smmu_as {
 	struct iommu_domain domain;
@@ -59,7 +60,7 @@ struct tegra_smmu_as {
 	unsigned int use_count;
 	spinlock_t lock;
 	u32 *count;
-	struct page **pts;
+	struct tegra_pt **pts;
 	struct tegra_pd *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
@@ -161,6 +162,10 @@ struct tegra_pd {
 	u32 val[SMMU_NUM_PDE];
 };
 
+struct tegra_pt {
+	u32 val[SMMU_NUM_PTE];
+};
+
 static unsigned int iova_pd_index(unsigned long iova)
 {
 	return (iova >> SMMU_PDE_SHIFT) & (SMMU_NUM_PDE - 1);
@@ -570,11 +575,9 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
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
@@ -582,19 +585,19 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
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
 
 	*dmap = smmu_pde_to_dma(smmu, as->pd->val[pd_index]);
 
-	return tegra_smmu_pte_offset(pt_page, iova);
+	return tegra_smmu_pte_offset(pt, iova);
 }
 
 static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
-		       dma_addr_t *dmap, struct page *page)
+		       dma_addr_t *dmap, struct tegra_pt *pt)
 {
 	unsigned int pde = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
@@ -602,21 +605,21 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 	if (!as->pts[pde]) {
 		dma_addr_t dma;
 
-		dma = dma_map_page(smmu->dev, page, 0, SMMU_SIZE_PT,
-				   DMA_TO_DEVICE);
+		dma = dma_map_single(smmu->dev, pt, SMMU_SIZE_PT,
+				     DMA_TO_DEVICE);
 		if (dma_mapping_error(smmu->dev, dma)) {
-			__iommu_free_pages(page, 0);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
 		if (!smmu_dma_addr_valid(smmu, dma)) {
-			dma_unmap_page(smmu->dev, dma, SMMU_SIZE_PT,
-				       DMA_TO_DEVICE);
-			__iommu_free_pages(page, 0);
+			dma_unmap_single(smmu->dev, dma, SMMU_SIZE_PT,
+					 DMA_TO_DEVICE);
+			iommu_free_page(pt);
 			return NULL;
 		}
 
-		as->pts[pde] = page;
+		as->pts[pde] = pt;
 
 		tegra_smmu_set_pde(as, iova, SMMU_MK_PDE(dma, SMMU_PDE_ATTR |
 							      SMMU_PDE_NEXT));
@@ -639,7 +642,7 @@ static void tegra_smmu_pte_get_use(struct tegra_smmu_as *as, unsigned long iova)
 static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 {
 	unsigned int pde = iova_pd_index(iova);
-	struct page *page = as->pts[pde];
+	struct tegra_pt *pt = as->pts[pde];
 
 	/*
 	 * When no entries in this page table are used anymore, return the
@@ -651,8 +654,9 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-		dma_unmap_page(smmu->dev, pte_dma, SMMU_SIZE_PT, DMA_TO_DEVICE);
-		__iommu_free_pages(page, 0);
+		dma_unmap_single(smmu->dev, pte_dma, SMMU_SIZE_PT,
+				 DMA_TO_DEVICE);
+		iommu_free_page(pt);
 		as->pts[pde] = NULL;
 	}
 }
@@ -672,16 +676,16 @@ static void tegra_smmu_set_pte(struct tegra_smmu_as *as, unsigned long iova,
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
@@ -691,7 +695,7 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
 	if (gfpflags_allow_blocking(gfp))
 		spin_unlock_irqrestore(&as->lock, *flags);
 
-	page = __iommu_alloc_pages(gfp | __GFP_DMA, 0);
+	pt = iommu_alloc_page(gfp | __GFP_DMA);
 
 	if (gfpflags_allow_blocking(gfp))
 		spin_lock_irqsave(&as->lock, *flags);
@@ -702,13 +706,13 @@ static struct page *as_get_pde_page(struct tegra_smmu_as *as,
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
@@ -718,15 +722,15 @@ __tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
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

