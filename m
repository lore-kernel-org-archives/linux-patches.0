Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CECE923C8C1;
	Tue,  8 Apr 2025 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131273; cv=fail; b=K7fJxh7dfQYbmsg3bfugmYnra1ZikSO8IXHKeJ2hVz3lXfYERxOayWnmuvQTEft4uO+npyAJ0uB1guCjtR8KVdfi92ZN8MAqLRqTHuTC/4alNtIOMqxAfskf0CUygjIyuYg3rs5PcBjZQcfoKeqStoiuH6qKKPT0RZWjQGr98dw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131273; c=relaxed/simple;
	bh=uLo1bFs/yKgW34CDL6y+dR0YKz1Mi/5MfUXnumkjWWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=iDrO63n7WvXqbr75t60rMnx2XuUDGHG0+xjpVBf1s+ElSGcJUFXmZaPpjdkBOk4zFLjTbPw+jZtBH/n+6eT+88jaLRQIln+/WsRm1QCnBLxFQf0DUON4+S4fCc1nKaVXVHlXPHJ64xlyz7KwmCu8PtLPqOfF/kvv2Qx2FemxWkk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q/Dv79Ya; arc=fail smtp.client-ip=40.107.92.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q/Dv79Ya"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CbuAwrmV4W7pCsXdKSnr21en8tyGx4vdu2rQwCMv8sQ9c1+VhItzX/wmhtfMHaU7s0Nk2YSsCB1V4OlCS07XaP4LoAQHB/RuuLYR70dBKa+TVxsu437w6hGqt2v7ZPMLE9z1E4KQgZGdSsJ9HcpHgX1Udapk4Bmwujo/RILPvb20QgVDzCl7WtmGCsNvOMLaMcULKmQD42PAxCS1BcfzHxA/p50yx4fPAe9E0Jq9kQ24Pds1APs3mSYLeNHuYryrc/VrOfkctQrZnuFb9pe+Bk3t9bLiKTbfkVlmOEB5/g0N4NJ7by07e6FdIXLXNTpyqDZbqeatgeiQa/jW/ThgTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bBNST4THBS9DADg0qEI/c1+ZsFnLYj/Z34pwoczjR1c=;
 b=hXFxo5uBjeJFHEhFQYNHE34itW3N6LlRxllypi+qsfnUSEkBxQY9xfuqcq1ayvL/MSOjI3sEkjmcX0BrjxJLGzfScssfpJbdlCQZ8pAby8V+w0FIw6gfc7FgkDFlrSkNKwRx4fGdg78gP3/h9VfEXLL1XEPDG5m8BYWnE8QjFOG9fGQ7FVuDBCx+ZXss2h3cgJslJumrjRYVVLZvecul+pZrJAaKYzdGt+tfEjypqpVEFDHhw8yLWDhLiD2JMcm7vrqjftz/HybjUYlLzMZWCNZfeg18MpgBNiZ6rbaiofD22TNid0V8PfWYZbU1cqsisAEJl7cTy7tMkdX0PjJMZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bBNST4THBS9DADg0qEI/c1+ZsFnLYj/Z34pwoczjR1c=;
 b=Q/Dv79YavDQo0ZFCjpmqr7MNCdYc6h+cS09IRURhagVcmu3rnOO5F4JyF8x5M2m2mk1QLPJh3J0G6s8t87VEcXDtv76R6wNgUO3a6mH0lDPXXFRQaekTHLiXEIV/FRSxHjkTrumqD7xKt7dKmJTvjmRpFtlULs/R48LmSLiFD0ljLa/Qm7V0oiLptTyTyEsFC8j8IqEAqiUlQhXnmY3UaHLD8Dzn84a/+CYO5+OvLxS0QG/YgTafMhUjbMjvWM4eyGkgqdNlWrYyu5SRctzEq316E4MANqZUgpucfn7/odPXB9PfANViA9rQibaEkp8ZzJzyu8z5JQ/WixrgnLrb4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL1PR12MB5971.namprd12.prod.outlook.com (2603:10b6:208:39a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:20 +0000
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
Subject: [PATCH v4 14/23] iommu/pages: Move the __GFP_HIGHMEM checks into the common code
Date: Tue,  8 Apr 2025 13:54:02 -0300
Message-ID: <14-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:408:fb::21) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL1PR12MB5971:EE_
X-MS-Office365-Filtering-Correlation-Id: 47160a7c-d94c-4bf9-9fdd-08dd76bdfef3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n4JwgpjF9PTwaVsUMfaf1Pea8Cjkgoc41sYQISLfHkTli7r9L0I8T+sz8E/V?=
 =?us-ascii?Q?zjEAGQBQvTDQPftIqq+DI2n+n/bL4m4tjjy7wNs3j0ss3kl+VX29LTTF+GTx?=
 =?us-ascii?Q?h+MVHfnegI7+0lraSiSK4aDz6O9ALs0VpQoXeD9DgLjd/qIa845G2u4D5+g6?=
 =?us-ascii?Q?CebgNf9OPQt6ntukVvd6CE9CCz/iYrFpzHLBtxCFcYtDiz15CkYkwTi1cgA+?=
 =?us-ascii?Q?bBSI1y9+B4HuS0TzRbk91w54NKzYTvw/yFbUOh4sDOmHL0XxZD5hZDGxak6Y?=
 =?us-ascii?Q?PkVt6R9Jsxka+PL7MnokUnNrFxlaEFWVXBtEsx3fez4ylQukMrEL5MCoQ8BZ?=
 =?us-ascii?Q?TG6N8OkLrnujJdLCHiiqwf+WFsVV+AVM+60p8iA6DIW96KWp2p0l6ucrhZS2?=
 =?us-ascii?Q?z8Sunc/fMKX/+llCbGF2TNxE7BpsKz71p5SNpjOE3shGEo1g+HAJQUcrHca7?=
 =?us-ascii?Q?iN8TqIy+6nBUVNRjwCPGg7TFO3TLG1aTntWT4NnHYSsojhi01OOt55aDUc0F?=
 =?us-ascii?Q?huEQWU48js2VkuNsUZxReyWCqGt7Xnu5qKJj0c5JGaXUxxF54BtAI6iyzZ/Z?=
 =?us-ascii?Q?tNYiwjlTcYqwaSILBsnihZm9d/H7dm92Hy/rels92SXULis/D134EcR5beVN?=
 =?us-ascii?Q?5ZQW2hrU66SG7W+5x09nAaueQ/5Gd0YYENuvQ61pm90AfgbVsLeaV8IHTK1z?=
 =?us-ascii?Q?lib5Ei+0xs+ubQzXaLpAsB4HXxrPnL00M/iWNNQ7WQ1nAKnBpKekyDB+bCau?=
 =?us-ascii?Q?TYhDDzkd9/7dXlipbInaBRlXmUZtFCJ6nMVy7vH2rAR0xd+81rznmrrY9oes?=
 =?us-ascii?Q?vCPZuucBphWhsMzIc4eLmx9/r8SFjIjH5EkwIPG7S0EV4VWKkKpgys5nwtdG?=
 =?us-ascii?Q?UURorJtm/EKGnzuN+fmoEI3zEvWRc2vE96GAO8L2CycvefFMHEiKNqrGeEod?=
 =?us-ascii?Q?xFNifi99rca+LFBuEIlUofhnloVIOn0IiNWb5i2hPavluEGJrtloMBqWJTLP?=
 =?us-ascii?Q?4r7xXQHJe9FlgULOQlw8Au2yvkZU2o6kExoohiSpG8OpIb5qBEupH7jvlVov?=
 =?us-ascii?Q?/jrKGyTAygMTUYqei08iNBTOfPumRVwxrkZapXPqxjBU48gn+Xs23lDb4hYA?=
 =?us-ascii?Q?FMfXAq7IA3Kd1FSIimbHlEVC8bywY1N6Te0xjO137q6mZwVPwQTQZq1PJcDc?=
 =?us-ascii?Q?MOOsQN6qDvGCd23kfRNnf8vVs1xs6u8D9rUc72yZugjq3J5eugykj9TAFEzF?=
 =?us-ascii?Q?PhewlQq4rsIUWElVLIK5W4BmQkXppcL4+veK6vICjhfIHz5Z+lVTI+pvmijs?=
 =?us-ascii?Q?Jzt85h6W37FNn/gYkTDjB13xH34NocJ5/ASJlX1n96VB1/w4iRs1ZFnlQmIn?=
 =?us-ascii?Q?1lCLXHHt/vBc5NhnlQtJCwddlo+VBhobamhNWNXOhA9/MxIE2gzAuy0pr1lI?=
 =?us-ascii?Q?NVPVnfpvKvs070/CprK9FRvOgyghvCz3ciJUoKum7eyINuRSi5C8iw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?D52o+FLo1K0N4l4USLz1jWpqnkum6JnlJlzaKF/YVvTt+7B3oPkzV1X6Nz0n?=
 =?us-ascii?Q?dQHmh8vkngPY3scLYzNE0qbXLzXwjvrQfzqq5rBiHaaZ6JViaq8cveGwjzje?=
 =?us-ascii?Q?vZkBtybJWEtFLRc6vZEFMbbs3Mr4i/Fqh6PNmxdFNb3HgT7a2GIvgSFK24fz?=
 =?us-ascii?Q?eph5A7fC7QB3suOFc4tspD8otS7gek9IEpcQZAIU6N3pFwocHwxRBXob0G1g?=
 =?us-ascii?Q?d51iPuIBa5pCUsivZiOVizXt/n64GFVR09MgSfM+p9PqwoQpBb/8VlMUFCmE?=
 =?us-ascii?Q?80HXEcqhOcoLQd8izKaxyqVPPRsQJbCgEHDAuKeOUV5wigvw7dKCUgpvBkPx?=
 =?us-ascii?Q?T3PHXxBjEDzr5kCoLoQDhU1VNXeLcL6rbLo65iRUn/4fC2NccMd2ezLyCO1j?=
 =?us-ascii?Q?jt9gbZLyBhzBMY3E+dbs3de3QhfmSuYe7HXbxw6NK0tzVjfN03Ks7djko1wu?=
 =?us-ascii?Q?m59MFDEhI0gZhWEL4YykVGIMhczCC/6iz8nCcCekWuFJ+bt7v1lVMsJYYuvP?=
 =?us-ascii?Q?K5LcJaRGCalfZSuEuit0tdGSwutWsOWWOjVaZX1VkYCfybudq7lIvHD2gVwi?=
 =?us-ascii?Q?5cOlKsf28TRaSmUijJUa8a+QF2GH2Gm55U+++s+rjfUjrq3+wnbElH7fuaTQ?=
 =?us-ascii?Q?Wa/05CSW5rRYRBhylxfvoktJnNcxo3tGH5AGHEABC6e26adNfCaewjQRFACp?=
 =?us-ascii?Q?HVHv9/teRD7B3l0fmA+f09ymkdcCwQ/tv2kyjLY8xuHUmONE+5OjPmw75cEd?=
 =?us-ascii?Q?iiWQojtyWsnQGi2S1Cvhj2XzHXnYJwIxqmVNYlbOMj6yStyppewsKQZBv2+Y?=
 =?us-ascii?Q?kVNDQlgfZpJhtdjq0BsfYZ61dn+8alw2Fl370HxrgarS/diRlficV5eYS4Z1?=
 =?us-ascii?Q?AFiowXT3SyTt1WXztVUYbwyHjq+7ih87vtttFjprB4seCdRzJ/X1z9+StxIZ?=
 =?us-ascii?Q?9E0+pqFmw5l5FvMNHCYGEzHorRO2cMPOfLIsq/z5KVgm/oJhiYw96okUQygG?=
 =?us-ascii?Q?5u9HBFIpB4dx42hJgjeG7oVMqjl6YFHW9SEzEeVQcGGCxh6CYzEoNbdEbpKD?=
 =?us-ascii?Q?EnjXWSJVzq3GGFseMuhrP9QvlzL/AANF7O3WJJuoTzWB8DyV8WE+NE8XpPTv?=
 =?us-ascii?Q?URbSZOukNY/C65fgZWaqe6dROnggygWJYNYGFxxuFeSnb/dB4qRdaORAG0P8?=
 =?us-ascii?Q?8GJ8LBahKrwV5/bdRTs8QG/2NE6e67ECGpPrf5+hbTTXoBT7g5XVnM3cKIYZ?=
 =?us-ascii?Q?vR82sA/ye0ljFQWLKUCKkNBaP1lkGg64ANtz/OlhN+o6Ds8ykNRkTV4fC3+I?=
 =?us-ascii?Q?pA1DpLGlAaotr8qe7k/B21bCmx3kqkoYqNws8AQXxxVSkN5Fm4ALZeAYl40g?=
 =?us-ascii?Q?3ZimtqjFSJ16YRVXd4Ok765P2xksRBuxs6jRYgZd2zQrPhASvtnzrtIzm8nx?=
 =?us-ascii?Q?FDRcgvCqydq/byybUkh5lj9n5bZyk4O/aeueBIQSNunTut2kFS/R3uC/gGwP?=
 =?us-ascii?Q?l3rsWWqbnEeR9MA9vDXme4FVjh0RxUvzvBoqTc/9RDb0g33nB1qTKh55FZmq?=
 =?us-ascii?Q?jQ2Eiw/ISlk/za6zKE3lqsjhlfDCvSjW+Z7t2PuB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47160a7c-d94c-4bf9-9fdd-08dd76bdfef3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:15.8495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZO8LL3OauZehwbkHBs7ruTsW6Tc1Kxy7xetDxOrv5kQKjEtF5ZisaXXClh6RcQW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5971

The entire allocator API is built around using the kernel virtual address,
it is illegal to pass GFP_HIGHMEM in as a GFP flag. Block it in the common
code. Remove the duplicated checks from drivers.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
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
index c80ccc753b5e60..8b5403aae8c0ca 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -111,7 +111,6 @@ static void *__dart_alloc_pages(size_t size, gfp_t gfp)
 {
 	int order = get_order(size);
 
-	VM_BUG_ON((gfp & __GFP_HIGHMEM));
 	return iommu_alloc_pages(gfp, order);
 }
 
diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 3077df642adb1f..a7eed09420a231 100644
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

