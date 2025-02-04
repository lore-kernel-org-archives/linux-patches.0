Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3B32185BC;
	Tue,  4 Feb 2025 18:35:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694117; cv=fail; b=fiuO+8qgG1oKpyHF62ekaZZKB6SEnZUo157hauy881Az0+Yb+BvPns9CPzyIeySCmcHlc6V8kGgPhMWg8rjLy5KTWMreot4bNl2bnubuylcv+WUAUzkSanojfvb0tpAbDpuvU1dGhQzhuwBMCLAztMJ0jL3e9qrmtNTjILA6e7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694117; c=relaxed/simple;
	bh=6mYkUqHR/AXqY1FNthUUnaoNSCouleVXf+o3bjTMa2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=dRkh52ODC3y7zoJhmhweGKRO8UcrDDd98Z2X40mVgVjXCuYA+177Q7dJ1hrB0TL+7LuKRERwuh5BTRmsCz7oj+tuveNlY8nNXX/Xm4FR5CgUJFAQWktyzNS54Nk6rUIl4MRoBuo50f8ABIXHiqTX15Ul/pO/wtlT/TzATnQ5lmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=cZW4fQj/; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cZW4fQj/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHGp+laojcb53bOoqR2/k759TOChigqaS/aEUywBZIYUClSk9O8BWjKoAsL7zGHnUaccq0selzr09vR2cBLP4QWXNQtjtm3rfghIp8oxxcT3eyHheOuTbkvM4mM4c5oeP1Mjxjt4XVTomExnLrvzIJF+Cbwi/E/mXmFIFx9WI8MYKA1L1X1v9+qPE45X7+60JQ2cKYzOL44k1YJKYNm4YoShUbOYZnzZG2Xj7Wi8e5UxHfhagaZpcl4c4mPNAWD1fUQhrmsj8eOXpAFGYpB6OF25FdMaK6aL3DsZHjb1GIcwncs33MCrk83ZMHEdW31ZA4qkYaNqXX6zC+QUmegwUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4Dpa5GSk1Xh5/Doqv+/p9pvngrqwQ8vKayJhC5qSUM=;
 b=HwX4SdSmztmqOSmmgGElWsBBN79mtgygCM9S4kX0QKN1WkZjkArOM8gUEq7actzp7aZrUHXEochGs445AbLltSzbTS1PfeT4rLVQ0RiaFtXmMSG9OZVNdXFkzq/iyD/NKK0L3MfYSagPr6p1lLUulD8k0moCUwYgZyMy2j9JlxWTb91/R4JvZxeQ1MHNO8PF6bMhRvCvYpwL+bKYl2A774WZ/7NWZsgQBRvGtwT7qNLrbT/xP/nEotLRaS42rSGazsvmG/MRcK+WGtBEovsYuJH4bXLfTbE3OXnL7eC/dDhxmLAR1TfhwwWHpisgESdvhhY/Qgpk44vt/A2gIqVgkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4Dpa5GSk1Xh5/Doqv+/p9pvngrqwQ8vKayJhC5qSUM=;
 b=cZW4fQj/TM4ZlUAy2viLnXWyhZ7cWCF8YjC3iZxuRnnJSC8Uur2Rl2JEHWejAKDH5WmJDKuPx4ARvSuF1yswv0EgNS7ZXeLYGrpA1UEe/4fNmERxU5Pnvq0qUg0SGu/D+UEoQjusZwnW3y0mzpdEri/5K2z1b1EJI4TUZ9OLjcitTyP5vCIQe1zFJLkQe6dvdPKtJG8GygwoFULVRTF089rc5NyNcSqlmruFX+8X8cUbPQZ6/jJlXjlCFdpSHGYRHF97azrrSkM+uHm6fvB4/f64DmPr06LkF4kMUtAXwr23fgmQjj/mKecA2XFipTddla56VZFEYAiRIglaZ8lWsQ==
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
Subject: [PATCH 01/19] iommu/terga: Do not use struct page as the handle for as->pd memory
Date: Tue,  4 Feb 2025 14:34:42 -0400
Message-ID: <1-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0363.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: bb825a95-fdd3-437c-8f92-08dd454aa379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OPzP+PLyfUSZxB8g29pXBl8vaEIye+rzKgP3iW2rHr1iaKo75i3kPLgi2Ijo?=
 =?us-ascii?Q?1129K0DP7zPrvPGsXiROCOSg8dhk0Zd2acaqlFygRkoyoCJlaBXIIYmfQbpC?=
 =?us-ascii?Q?sMG3zdKlmAIO98e29IzCw1jPdi1SIMPAoqTFiaFdnBC4NWERtvf4bl1J8169?=
 =?us-ascii?Q?rk8GcvzLn9nKCIF8ktICjs3qHztSCMUTIzl2sjtCUjfYvbvtbS76nQovLdT3?=
 =?us-ascii?Q?RYjDRINCy7315Fh0JPwG9Vq92JwnO3/dPSGA3E3hzL+yW0XpshOZSJaeR7Ja?=
 =?us-ascii?Q?kQIIpPmUQUl6AueBGr9GEWemOZvMLbNdwHE0DPBvjbq7qR4Q2npzmJZa+oli?=
 =?us-ascii?Q?qh5sn0f0ZNjUnnRnffRkPjexLadcYZAsNJSQlCUISX8YHftd1tzBmqoEG3YQ?=
 =?us-ascii?Q?C1CYAAl9W9lQrdLOObBofArqpegdbmDzXNGuvFWyKvdef7Xb0oiwvfSEJSij?=
 =?us-ascii?Q?ebpWRv2CUs7K0CCkJ/RU1Wvyv6SEQrtXZbaX/G+21XRlHGZ8mTLoy+EGY0ab?=
 =?us-ascii?Q?TRPC+xBDnu8zNR85ar4mFara67IZ/niqLKXPuKeiZ67bnQ5YxBliRC6/JIcO?=
 =?us-ascii?Q?qKFv1350B9ppo6L78atM4kGhxb/dO356N7tvYJtzlX5EEWwNi4UvscVHrB+l?=
 =?us-ascii?Q?D45enGVitUeLu/0GqYiA1og1byxvxl4cpfl5ThE2xd2OlXrMO/w45sYMRTI9?=
 =?us-ascii?Q?awnfoeKo3958vfl9/j1gqrHhB6s6+qVangXLd8cjA79NYRLQfW66zEaZfw0d?=
 =?us-ascii?Q?F9OyZ3/pr3qy7g0hqFBe7ZrMjwf5bzvMPbADB7uG6XSqYkuQD/Nwl4Xw5mAC?=
 =?us-ascii?Q?lOxeycdVc7rytA/eyAijWfhGzsM4y4MXvuKZBzL//lmJj83Fuff+NW0xQ4YJ?=
 =?us-ascii?Q?/lLRb+HWb0FcbyFi/HQmx1ut87Fx6TTuo7Rt3N+KjbH5Uyd4cwAadHqPlnHW?=
 =?us-ascii?Q?a/4p0WoQh57zlo40ggTpVqMw19wgMg8Zh7AuQ3zVa6QGdY7MlRB2d0Tr181n?=
 =?us-ascii?Q?XdI4RazDAdLgwJunRBZmnmrvB/I1c722//mWnxfJ8pfC+qBADZtaKGkTq31R?=
 =?us-ascii?Q?++YYK9FLuWhMr9gyoLyyrpSQiezqlepqwRPqrxmLjjbB5Z2ip7ZOx2zIyriA?=
 =?us-ascii?Q?62gwxbcom5Sbip53dfyjClexYTjoEbTuLqHj5MMbPxdt1KpCjoxEIbDC/t0B?=
 =?us-ascii?Q?AKHZTBB12G3WOrYJ2UiaUkIvocoYiUTvGKYBKfDykWaOYvPbzVcx3SwcUuET?=
 =?us-ascii?Q?oaOAnA3umd9FvfgXPSCECYspcibes7YKGI0YAXdmhgF8o09kfxGL9Yzckxe4?=
 =?us-ascii?Q?RFeiTvyvZ898eajW9fwGRScjzsrWRj5ZLOFnHx8ztu7TY3LXlWPyYJR41aG2?=
 =?us-ascii?Q?5uuz9wvT95alAzCBQHvPB2fmgemr7uFOuuMHGGCmoulsiBi0xUkYSQTbmjwC?=
 =?us-ascii?Q?U7A9/dHu+8A=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/zlXtoqwbxU3XyCjwYcNdcUeBXnywFzY82sKSeThqoKo20PNcbD2Um2sI4dZ?=
 =?us-ascii?Q?hInU/+X8m5r7y3GbHe/gIWLI2YCrJZGoa/xC5yRnaEqk74BUW1780fLHz4gv?=
 =?us-ascii?Q?C55lpazuvT8wfBTqqPS47+ZUH9xap52Y0+CRi0W3qCsWlfGe9+st7ufjarsr?=
 =?us-ascii?Q?fg828vRrfOL1BNc0ZNSrZGajJidza5gX8z9bzdZ17TYHvT7PbDGSacjULiSS?=
 =?us-ascii?Q?RgrAqSg6kSw/Rnu7X4Her5NUGkc/9q2fQeVax22j1tq2qtOdONBMNeRK6W65?=
 =?us-ascii?Q?bt8TdOuKfr7OoMOM8tVXjBBSz/F2JRqb8HgFqCrsuIR6k9xCvDejaPvL9TO4?=
 =?us-ascii?Q?Dr1dOJdTjbJ1gCmg8XjKn25L01YTJxLcTy1sKR8BdOTj2idnFzEH8wcCM9wr?=
 =?us-ascii?Q?nbNpiUsWo29tEn84FaElPSSPEG4q/cPDNR9kPqNSfvbSfg32fVC450crnCwp?=
 =?us-ascii?Q?orjq5oImcreOh7EinBOQiPoceBo/9gJPHmloi+JamvdML1VzXX5kQ6YXgGh5?=
 =?us-ascii?Q?mweR3vgWoljPwZuVJxNJ4JDIimUMZPmEa0a5ZTaTPah6MfNh6vLq5tqOrDEV?=
 =?us-ascii?Q?jDeCPRikMiBYxzj4zE2NqRTb7sC+VG4EsvtuQcM+zyB/nTd0klsT420P6Db2?=
 =?us-ascii?Q?ihNYYpezeQybN1lF2hpx97vAYnGyqqhybCrGkdpsocRovLJ62KcCoxZFtr35?=
 =?us-ascii?Q?yRN9WvR6GTqvoTxGcwzhBGfU7DBu3gE4u9xjrPzpP5JZoaojplB8yFKkK9Mw?=
 =?us-ascii?Q?6fcL6+NO+On80f3jMAb69Cewv196UpJYG53+mw0RYizf490HSXjhefnlGAg6?=
 =?us-ascii?Q?DqsA+fZpI3RVrIopqNoLv50hZFLT5C3wAsW8SkTMV0M8u4JoylYoGNBvhxM2?=
 =?us-ascii?Q?Zs4IkXR4fGSs8s/ywhcbnYO7pIHTQ9UQ3W7vtPvLu6OsQOkuCF7zRQd5NXNl?=
 =?us-ascii?Q?sCrdvTW6/tpr02zZphEkLWMgGQ6avrB9Th6S5wGRc3m2NGqQ+FRdxbR6IX2k?=
 =?us-ascii?Q?qGS+GIYZSjSdB7bpSkRwZCiLvoOH1Y00LAwxZYb5G2FtNcXvHmzGvj0i83G1?=
 =?us-ascii?Q?6bhFNR3qivvt1G94msJ1eEa+s3xQGNbYe4llHmwalQZISN4geH1825JHwiw8?=
 =?us-ascii?Q?/nsrHkZ95aJKbd12vzbKYhMcl5ZtJOxlWnFascQitqKgR+sDL4xERowc87ha?=
 =?us-ascii?Q?Yl5OsvITd6WkDErryyxbE3w3PpYxX3si47YAfqFWdAiABve/+L3Qzf/JZAxC?=
 =?us-ascii?Q?gaGiLIabbfWBhcu3D3k6ug5jayUhrgQ60I7+7f247HdCWd3mU9zDYfO15ZRn?=
 =?us-ascii?Q?f0DJoSB2bkS7ua3k97RKEDthDgnAorsqvIfr3YRgSz32bpEQIKV7rzMFtfmQ?=
 =?us-ascii?Q?2+qGUvotYcTX0eQ1LHXhf9lI7+BI9LkgnE3TYLcm06frElU68NKJ9cGa9nST?=
 =?us-ascii?Q?ewMHIKLgpbbHaE9MWu5bCawuvJT+JmgyTUjUBWfk7Q6pqBWTDn+oyK5aIGTW?=
 =?us-ascii?Q?HNcr743ys9MaMHijNbFm+t7dNPWaOw881B5jXfXDjZFDjSbW1gDyEtTceHJl?=
 =?us-ascii?Q?s42bB/rqmvusObraOHY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb825a95-fdd3-437c-8f92-08dd454aa379
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:03.1503
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m1XOl7gEa9bCvo9M6JSaJTLYdxJSidWdNKSFiObTna/zmF0EDr//1ZCkUXsM98gE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Instead use the virtual address. Change from dma_map_page() to
dma_map_single() which works directly on a KVA.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 7f633bb5efef16..717bcd3b8de7dc 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -58,7 +58,7 @@ struct tegra_smmu_as {
 	spinlock_t lock;
 	u32 *count;
 	struct page **pts;
-	struct page *pd;
+	u32 *pd;
 	dma_addr_t pd_dma;
 	unsigned id;
 	u32 attr;
@@ -284,7 +284,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
 
-	as->pd = __iommu_alloc_pages(GFP_KERNEL | __GFP_DMA, 0);
+	as->pd = iommu_alloc_page(GFP_KERNEL | __GFP_DMA);
 	if (!as->pd) {
 		kfree(as);
 		return NULL;
@@ -292,7 +292,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 
 	as->count = kcalloc(SMMU_NUM_PDE, sizeof(u32), GFP_KERNEL);
 	if (!as->count) {
-		__iommu_free_pages(as->pd, 0);
+		iommu_free_page(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -300,7 +300,7 @@ static struct iommu_domain *tegra_smmu_domain_alloc_paging(struct device *dev)
 	as->pts = kcalloc(SMMU_NUM_PDE, sizeof(*as->pts), GFP_KERNEL);
 	if (!as->pts) {
 		kfree(as->count);
-		__iommu_free_pages(as->pd, 0);
+		iommu_free_page(as->pd);
 		kfree(as);
 		return NULL;
 	}
@@ -417,8 +417,8 @@ static int tegra_smmu_as_prepare(struct tegra_smmu *smmu,
 		goto unlock;
 	}
 
-	as->pd_dma = dma_map_page(smmu->dev, as->pd, 0, SMMU_SIZE_PD,
-				  DMA_TO_DEVICE);
+	as->pd_dma =
+		dma_map_single(smmu->dev, as->pd, SMMU_SIZE_PD, DMA_TO_DEVICE);
 	if (dma_mapping_error(smmu->dev, as->pd_dma)) {
 		err = -ENOMEM;
 		goto unlock;
@@ -548,7 +548,7 @@ static void tegra_smmu_set_pde(struct tegra_smmu_as *as, unsigned long iova,
 {
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
-	u32 *pd = page_address(as->pd);
+	u32 *pd = as->pd;
 	unsigned long offset = pd_index * sizeof(*pd);
 
 	/* Set the page directory entry first */
@@ -577,14 +577,12 @@ static u32 *tegra_smmu_pte_lookup(struct tegra_smmu_as *as, unsigned long iova,
 	unsigned int pd_index = iova_pd_index(iova);
 	struct tegra_smmu *smmu = as->smmu;
 	struct page *pt_page;
-	u32 *pd;
 
 	pt_page = as->pts[pd_index];
 	if (!pt_page)
 		return NULL;
 
-	pd = page_address(as->pd);
-	*dmap = smmu_pde_to_dma(smmu, pd[pd_index]);
+	*dmap = smmu_pde_to_dma(smmu, as->pd[pd_index]);
 
 	return tegra_smmu_pte_offset(pt_page, iova);
 }
@@ -619,9 +617,7 @@ static u32 *as_get_pte(struct tegra_smmu_as *as, dma_addr_t iova,
 
 		*dmap = dma;
 	} else {
-		u32 *pd = page_address(as->pd);
-
-		*dmap = smmu_pde_to_dma(smmu, pd[pde]);
+		*dmap = smmu_pde_to_dma(smmu, as->pd[pde]);
 	}
 
 	return tegra_smmu_pte_offset(as->pts[pde], iova);
@@ -645,8 +641,7 @@ static void tegra_smmu_pte_put_use(struct tegra_smmu_as *as, unsigned long iova)
 	 */
 	if (--as->count[pde] == 0) {
 		struct tegra_smmu *smmu = as->smmu;
-		u32 *pd = page_address(as->pd);
-		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, pd[pde]);
+		dma_addr_t pte_dma = smmu_pde_to_dma(smmu, as->pd[pde]);
 
 		tegra_smmu_set_pde(as, iova, 0);
 
-- 
2.43.0

