Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8BF218823;
	Tue,  4 Feb 2025 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694120; cv=fail; b=ToNzBdiWkRlq2brOzbmuiYj9dpR+qyxMqNZA0G2YXZGlDbYjt+jxas2V2g/5mCH5Ws3D+FVmLG8NAVBTBSBIkQ9RCMjcC0uOkPNbyUykVFJDPIOKDiIlN9KGl5kHYH0EcTQOtbPA5rMcrIhh+MeSOplUl5ZuKjTJy8Zivp+8+YM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694120; c=relaxed/simple;
	bh=s5e5DUymGPLO0YtA7iJ8HdLlH5WuARUOpxcHCWVQ8w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JixulqBtFEI+M5nxcQ4aFrpnkwho3SFyawUQGCfT8L1GT1/3Tc4Q0SdxyJH8FzTjP4v0a4N/6eynWIrSlpgm3nVopaE+40eCidAISwat31mA7MC75SZmjhNWz9uMKx+PaoTqnVFhhUfk4/iLHTs+E2O2v7Z/wZofnf+XKU6riRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qL5qL9kw; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qL5qL9kw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nn+jePi8T1HDxzmqtBWhdd1id/UwcV2sE2hL/05bHAk7zQmkxz4Q9GRAjX7fGkSWlo53OwHGhYZGdqBw4Fx8peTc9wp4GlGKR8iG++SqzyFwa1bgrfkX8ew6qyJ/5rFPQ52UJLGF2u+GxvpmuFQwf3W9HAup4iB1sqOH2s5o/JnLAsqtjG1nxmUCL4uNDyEPHMSG6CV9Bg2uf5YGajweCqedlhVWGCG4Vl+HmrxQ1wSe5pZrfgUZBOz8bwAxFjzedJjeVdc3P4jq6dR6mHsE8/P6ylujHykVJdXFTPEoMUVHpKmhnpoqAYTakhnwyW75xGnd+qu3NTsCInz7iVnOHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+Jd9ZOr7iF7NB50mSaOh8isl5yH0slEur+V0mVwQ0c=;
 b=RetAxVy9FDbzGW1gQkJS6vIJUVkxRpnyJT7lYvoNHhpzBtEVhR4rZg1TXiudGOiR8nAQPD8sRxtNis58mzGx4+6M5DnujXDl3/fal11ImkDeKNGs4CFltFZBu4FsV2XOPONV9CEqrRkTqnrqAC4vLcaOqc2FNDVwO0+XwrlSkSRRTkprATMJ0zSiDbg9G/3f+41T9ZiTwsHdCWmTxDxfbuxtMG+SXZ8DpLWdKbWQCaWTyPbXTW3eeYPDZ1dWvaGkzxyJrF0Aw6FTTWnECTvZ2AaFTpA/YMD45s1aV/C5zrlk7gj4ITh/8TnGCAMR9EA3mgdf40DSzEP4CRNHVpuDlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+Jd9ZOr7iF7NB50mSaOh8isl5yH0slEur+V0mVwQ0c=;
 b=qL5qL9kwJfMvAlE9vm8iV8gcIeVbRhWsKhSxYOSi4SCnD8u/jsD34GdiqzKLkTqVO5+Qt7+hLZWDXyaJUb4xYG7RZZTbBttRvKOF3a9vW0GPPEo1CLAvr1dsBUOQoBYkA3TLHRmzZdre5ZZerduj1zGBkb0h8/qHrbU3jvpjIjnmkp3Asrxaa9Ndnelfpcrx47OG7+I3mu5h/aezfdM88pXTjm4wLYmb/2Dtd5ssjXj/Ec20gyTmcOyeeVbiosYhtmvpRay3AYscnK02BwK68oOJ6w34gP9RjTNPr7mPohgz3A8aSa07NpJnzTVrbFJRmUpJfWFB3p6zDcBOAoH2Pw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:07 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:07 +0000
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
Subject: [PATCH 14/19] iommu/pages: Move the __GFP_HIGHMEM checks into the common code
Date: Tue,  4 Feb 2025 14:34:55 -0400
Message-ID: <14-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:208:91::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: 757083d8-0006-4863-e83d-08dd454aa3b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CCiSO6yA7O0GBIFiBqdEucm+zwwlnplPcduQjTr1lL8DLScvsr8gAmAVhPCn?=
 =?us-ascii?Q?x+SEm9fFrpohnR8dVOiuydFJqsDOvUm7Uy3kuGN50rRvhXs/qTaSI+OH9oaO?=
 =?us-ascii?Q?iQgRrT7pS+GUhDDkuj6AusanvPsc+vH76SgziGtsAqOs1M9zsD2L6QHFDyGW?=
 =?us-ascii?Q?hTd6zDrdIrKIoRV7L3irK6CpQxAOq/S7YNKxPoQuDQHqJF2vStTQT78b2GeU?=
 =?us-ascii?Q?2sdZsKmSqviWx3K1B9hG3nZ3NWB2SUy3V6khpmNbyPdXnSkKPOk9f8rjUMzx?=
 =?us-ascii?Q?Rq/RyFR5laDy8jXYLO1Y6urwM4OSRMF6J6DZIf3yDvN3zp959uyNcvSmMBN6?=
 =?us-ascii?Q?g79Yl0PyVEh2twxYOh+Abqqm/jEF5jpiR4LuQn0pIJQEuIjGL3A+gUIit/ds?=
 =?us-ascii?Q?DAsXCjpW9gDlB9W5ypOJXYqe2qRScktFr4WjxDc4HD1HgwAnfTHP9pqkiE1y?=
 =?us-ascii?Q?J15F45V7besaakyjPvuqbl6AfEpw6GyJbGnoUS6gjIVpVgeEWwWRmvkG0qp7?=
 =?us-ascii?Q?gyY3ksqSiZ1dGZ5Z4dSMGqpHkE8wZeaVlfACP+uBwuwZmmBQA7goMaqwPyM6?=
 =?us-ascii?Q?ET742eeBqnLVwH+GKDKwkNj1ybKHzZNpj/fluvxRJ38Ok8ENL/qG/a/TiqBu?=
 =?us-ascii?Q?oK2NrAyn26X4lhSSUaarEx/Mk1+otn75FXofVvcMw+ILjCwlsVYPK3DQSMZH?=
 =?us-ascii?Q?wcObi3fkB6srCMonUXN7iWt7Oh+zGBXqRtQgVpOuPggYwXWTJurDCLFWF7BL?=
 =?us-ascii?Q?7SFtszwyqp6qTOoGpPCnLnP6yBTL2mFeUaPARJU54QC5fzna1gzkCp8PiKbM?=
 =?us-ascii?Q?1Uj+Z4FW2fQw4RgMyvrof9FRnl7SzLzd2kmDSGPbzqStv0e6eF+7/H3cowqf?=
 =?us-ascii?Q?zHlJkhzoqRoEpWeUmFW6Yp1Z46/IklySSzPyY0TzU0g9MvozTKjkOcnoaYjT?=
 =?us-ascii?Q?ukeByY62jan36HfxG+J+U3YfqCqVvPUXZOYgR7IdlLRotO9lwnHKhJkXqzId?=
 =?us-ascii?Q?ua0HnFeWuWmsOoZXiFs7Bo8EDkBK8/7HLArny8ColOs4kksdeB/2Coy2B0HY?=
 =?us-ascii?Q?G/D23KZ+qno55opSdOSBhVvIRtoHwbQuCr6t++X+5ML3x8aus0hwAorb8cOP?=
 =?us-ascii?Q?FZfYUpn67waYmioe+rywqOF2Gzpu9fjlrWB5uBS0dsY4tOOiLomQKQFMMeNI?=
 =?us-ascii?Q?lM3poC4joodJ30VV/kyYJHqKjSYRKnycxcm+KPH8VE09JkFlFtD9ZSyMIABw?=
 =?us-ascii?Q?J3p/O5FxzwaGd0D4rNaGYLFcmIbbdYrBF1QaDKupt8tKMuvZiQa7oSA7bX9n?=
 =?us-ascii?Q?mwSi1zpcoEai0epLXk1tn/d5RyOLq3tkbMjZ7PzGnxiP0YEFdudIdS7DiIX0?=
 =?us-ascii?Q?A40jxCX2P/ntmENg4+JW6juSAXQ4c5BT8pawnMXupf1CDD6vdbNj8avFQ06Z?=
 =?us-ascii?Q?KoNnaclMleA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KIHvuaFMh7T4Mb/PcetrFtffVfBurxM2FSrYKzDwnAQf8azpsXk0VIuySPy1?=
 =?us-ascii?Q?0xYM6/Tb5GRhZv0ne3XTwrm1Hn2audUSEquuJY3d9q8kaLUKTJHxhwvumK/Z?=
 =?us-ascii?Q?k4poRSYmBoSQEdjCVEyiQoIJPWnkO9bzqiPZH6n95SXQQuaE8xDs8XDS99Vz?=
 =?us-ascii?Q?PIUgI0hggB4uy3MAg0NsY+yaxQc/dWW5klsKKlu0kdWS2cL29p+NYNeMZ0tl?=
 =?us-ascii?Q?DfIWC3KUjDxfSLrLIT2g7fqcgzbPv2a133acE99FLoOiNS73WD0FDasCyzQP?=
 =?us-ascii?Q?4YzbLcyuEOdwSfRfZfm2DcsN07kD+YG2B7RQ+3p4fm0tCnWkeT8DhyFCb0lg?=
 =?us-ascii?Q?ckHLuxAOmMi4x3CT79YujAhKvbSxew5HdQ/vQ6LbtcmYyq7NA2MZ5s6yEot0?=
 =?us-ascii?Q?KWOAiMfjwq6cFbxvYv8emITWCFcULLGE1yDBp+Ak1p+mS0jBGN306qX2WX83?=
 =?us-ascii?Q?NcB0vYP+NUfFFV9RCjZiYXq136At1pVVKHwCvtI6In/XWrFt84Beiw8TZd8S?=
 =?us-ascii?Q?nu2jaHsl3ZLOFI6a2AD4CJ4EAWJvn5lfwCksb7vpuji8xURD4jgPgyaPPOAo?=
 =?us-ascii?Q?PSzaOB7DKOVcjegbvGfuStSnmK/zsexuqD3F0ONqeU6H3T8blLQK5XJYywiZ?=
 =?us-ascii?Q?v+Mt3A6H6m3e9sC5YsJ7gFpZ7w6sloGyHeapcVmnZ55/GztUC8WSz7dTQBk9?=
 =?us-ascii?Q?3BipBQQTkeDyMop2SR9+QYasFWSxkyZtCEm/iORd5YgKYXtDo7Gydp29jCOw?=
 =?us-ascii?Q?e6X7jii0d+wPcP13sUjy6DCKU0+QPVKYQmo5rCfqFLspi+G2wdF42cU/h9uK?=
 =?us-ascii?Q?PqIaRDwl6MEJouTYHom3+FvLsMyH4MmZOwLcxKzNpLTbJMEMrRDnLNNKCDoy?=
 =?us-ascii?Q?Xx2D8UtBK+jtRc4jPZO7ys+tgXgM7PASgChRW4VByWpBveFz+T+0mf8kdztR?=
 =?us-ascii?Q?ekjWeQf588TocvLfEfMWcXf1ELbTG08KCsidok7fJclk9xbLg1aMUw/XdZMd?=
 =?us-ascii?Q?Hz/v2VYoX1BBbxCJWihuWoYhkck3j6EHMo0NZHX8Owc9J5ABqrokzWoBORls?=
 =?us-ascii?Q?kP2lwJQ7RzshgoIb+zgLMZioPHpCmUImgYbhWTXl1Ur2ZRU2OUGY8Nm2zSwE?=
 =?us-ascii?Q?Jd19jW4iy3xBNM+19dnMA5ZJQYoBJRDc02/BiFetIE/r6QViVvgr8F3BQ6fn?=
 =?us-ascii?Q?rV9qlxbq6844kLqyNISumzvvptx17Pl+N8kWxcuHmahVEzORp2H+24GlNbn7?=
 =?us-ascii?Q?VgnwSrTPU7tY9W7PO1DmO1RlKJR0BMH3pespZHWRcO9FntI6dTYl9UbcSSeH?=
 =?us-ascii?Q?3YOYZ9pDQLNtS1Lq3Px46O4emv2i9q7DfJf/adqP6ID1LmiAmuiNhHT/qsm7?=
 =?us-ascii?Q?kSMHvoaStHpPVqHj8URGck4+lIA3QCN2c4twvKTifzJHlkJDGLJ8SglOH9Q7?=
 =?us-ascii?Q?CEvITyZ20i4Ot8dJ6DtUYGaroaDFjw6aX+gnkkjNkqrDypCzocsqOoBBjtVC?=
 =?us-ascii?Q?O/5ZIdlDKm073hwDWyBdKcabAfqtXZ/qhjsa/MHDkzEhnLy5Yetk4yoLyUjW?=
 =?us-ascii?Q?YCimxNe81KWqZSk6liE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 757083d8-0006-4863-e83d-08dd454aa3b2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:03.5720
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y+j5iHn58pM1HrzgzldRtaO8d5QfwXcs1Yqd9k+jqHbWENBOHbtoa2iUC8ApWhwy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

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
index b4c3729076376b..8727d8e1e02f45 100644
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
index f7b939d4b7d0b9..a4cbd8a8a2976e 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -111,7 +111,6 @@ static void *__dart_alloc_pages(size_t size, gfp_t gfp)
 {
 	int order = get_order(size);
 
-	VM_BUG_ON((gfp & __GFP_HIGHMEM));
 	return iommu_alloc_pages(gfp, order);
 }
 
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index f7def716997af4..47ee9ad4a40d4d 100644
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

