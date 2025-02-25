Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F6220F094;
	Tue, 25 Feb 2025 19:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512399; cv=fail; b=ZkrafWg3EBDcnh0UIIxtYoLiRNyw/81d/qLxsCl2QHY/+ysG1P3Nou4BdJRZB2owUHoVjFrB+VxIWTR/7J1IbSKeJwx+yEI0SOgeNlNRUvCFLVgkNC9Cvfo3DF/DN0aTiJMP5L1YbUu+gczfhhITK4nI/cICfdU2O/iTgRJkKB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512399; c=relaxed/simple;
	bh=HJlkF9aDxRAPFwP347Fr+zZ2LLJm677J2OxPQd0PJuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=EzQyHg6RnlWFvyEVFLGun1gvttvK+IYQNVraE3LxU2lf0Vv0uDV93SsAl6L1A/eBTrxOkArtN6NYVrudBCYVsGyihm0hf8VSV4GhwEL2L4t98hx+aIWyhw2sBvHy3AJM7GK4ALL6+qQol92fXzf4yMngdYfELR53E/hapBpy410=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=TOZax70o; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="TOZax70o"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ikbygNzzb46M5NPNZTHPSsiVsA3GfYc2yww5Hqb0neYUwRIBeX7vY1h02uVY8XKIUEOFsNjJ2JuGkJtQ7ldIDz01inesQd9doUpJAoo4QYT7A+JzlMEmsdUzuLpME0+GD5OHPVZlcyjN2/LNsanfzPUi2Ax9kPMwOKBCumIWwVeOwDE4CUMt4FJ7Ou6isG4Q18AkDAJ5/vSiCPtMpOB/K/N7+sNjhc2NnmU/Snn0B2JAno3LjOtCbtzE9tgTg0cYwDKmh6Ek7HOaf0uaSCSn5pRCVIcDhJuV2Rsh9+EBz2PNx1Up9Jf0fckouzvroyocP4hc9rOGxmGbQJZiMQnRAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dPf81LYv24k1H0WNyYZTTWnYuLDWWG+WywJNc1hBVE=;
 b=q/AjGJz+iFDuSO5qSled5/Cr+BlMbXdi84Grh4q/+OFch/c0zirSpY6GAL2w70Om/T4hwnO/xXbyF2Fg9OZSBAGEiMap2v5nxeX64Ze90rO9/iGJJ1D32VwuffjhhOIPpSRbFqPIvdMSUZ5B+alWO621CgEcz6Zs+S1STu+4SGIy4bUMxjcphxgRvflWMh1DpCyyljxw3DJTRVHdLXZJid2yaB3m44WTQEKCQwXF4bruvuIsGYsorzdiX/pTQ2E0jp3zosLUDWH4YKzfEgN5vOErUgtNPbg/6aHDVd52nH6tiK0EHVsQMrIoA8RAkVRUpEmOVBQgKouvU+MvN+CRGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dPf81LYv24k1H0WNyYZTTWnYuLDWWG+WywJNc1hBVE=;
 b=TOZax70oDzLf0XWeDRDW6LI1AaXWIdvpnTaublidTXKNOngXU1EbE9MWDAUeMlOMkfFTodNmt2cENUeZCV1SGYX4wEIFJ81Kc9ilc+LzlaT/3QT6hJ1KQVbNbLO76c3hm11sJXqAVQQeDCUS/iiOJYKVh09mGluFEGBkU5sl9SrX+y5zIK/mg9lA7PwTv7TxkMEfZLzrnfrI3+BJYtrjHrN2cPHepu94kMkgfq89fX8FWSKiHjQgtO7lpErctnZRSYyz0CTC/JhjIN9IyU+F1aiyVKXNyih3e9XaHXV/Lsi+Miyk3stoS1B42IHqZIr1+HnbE3MSCmglBiN48+yXcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6617.namprd12.prod.outlook.com (2603:10b6:208:38c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Tue, 25 Feb
 2025 19:39:50 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:50 +0000
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
Subject: [PATCH v3 15/23] iommu/pages: Move the __GFP_HIGHMEM checks into the common code
Date: Tue, 25 Feb 2025 15:39:32 -0400
Message-ID: <15-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0019.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::27)
 To CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6617:EE_
X-MS-Office365-Filtering-Correlation-Id: ad6c3280-57dc-49a2-04a2-08dd55d427d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uEXJ2ItWHzgjAsE/d5eqs1dTAr2VMmOPT/eXKm59vQxMxZKUsUh2O4Bkdo4f?=
 =?us-ascii?Q?+nycweMZJ/FjgrNwl8I6MJQaBhG1dO2ZU84K0CT6FRef89dpPBkBx5Etwd/0?=
 =?us-ascii?Q?nyBlahpqIfvyM5FWEF4T9kzxoWtojeNWHmr/6kSvpQr4DxasgvZewlGOFKA2?=
 =?us-ascii?Q?TBUufy3LLjzl8FfzqswPNQufI466hBxxbuoRHXUCdQOE2Q4Jt2rWqGv0UZFH?=
 =?us-ascii?Q?VlR0ufEBQIZpn7v1h2SNX1FDdK4quiUu+SunoESHgLr8y3dhGVZZP5mvQukw?=
 =?us-ascii?Q?ekN6IR83WOheOSaHuqERNVbg2be27IIFcx4RZz2MlURlOaPIuYDiVDeJDG3g?=
 =?us-ascii?Q?hsPnEIg7qr33Ui+23j4I5tUXm+ZLJoH21KSArQhnpNa8g9gnfvdROHFHfuVb?=
 =?us-ascii?Q?057epmlmn4n28Q785Q+ZBLqbUBunPtnwiwnwTNTuZHyD+9HKxDou6QEi1fNt?=
 =?us-ascii?Q?DmMgnLSaGlGE56ZkZ6Vx/bAlMvkEgB7NwxP5w8FPu9Fp1KU96fVturm5g7P+?=
 =?us-ascii?Q?JtkQ1XlUd0Dg1X27I5dxB94hMEp9eayhR/ZfExMZHcDuYNXitzLhL0GJVMJk?=
 =?us-ascii?Q?z4KHyzbKaUQmiALiIVSjhN3CDZ+f17xf1ArVZPj3JU7We9o17HjO2WL4/OfS?=
 =?us-ascii?Q?M5B+BYP+SmstKjW7qlS9KwJhnyZE8rPG2BYiH0ZtBxLMvoBT6WYsVkJudn6h?=
 =?us-ascii?Q?76hrbQmONNEW7hvVMoiYygB8SoxQ0dyjQgYlZ2fiT+gtojDSe05UdEyZqGxN?=
 =?us-ascii?Q?bxRqb/YrTplOrWcj72ytQ+BCxRdIS/3U2iQNnfmjFVZADrjxFYZJwKVVaYDu?=
 =?us-ascii?Q?ig+ydHzlkVSRxduCNNbFqx9bejA/Eo6/5/sUHuMDngnNUMmqBzBeejJTOwXJ?=
 =?us-ascii?Q?FnMJGNqmu8fnjNRB1Ahqh/ViZOCyrLawpP2DmA2pyaIJFOOTmzOE5WM1+t+Z?=
 =?us-ascii?Q?IXJ33mxgXAKuu3dxrQ/k89Xs3gIkNrEbE4JBji8RF7f0TA4VKFEJL9Gz5tJF?=
 =?us-ascii?Q?h2OYBGuF090bu0E3Rrw7deBEej55J9+YBfeSwvBc0IsCzmlVslI6B3HTiMJD?=
 =?us-ascii?Q?dunvAKf3GUYlpTJpa8Js9S+xP6uEtdiI6FiE+/ZckdXpxpEQEwnx41p2j0IT?=
 =?us-ascii?Q?/UHisDjHcd2oAhbgb19LUyU/IRLKJJhN/XwNO4RwYAtaTMr9Md+rmL38vK3q?=
 =?us-ascii?Q?vTHReDX5tGvVNGqfuk0R5vLsMsKdslXP2TtXPQEL9jEF97adY6D2UJ/WZVZO?=
 =?us-ascii?Q?sI291pKxo/bMmmxGVUOZyEl6FscBlAqTV5oCPx56su1ODYZq0cxBsM9PbdY3?=
 =?us-ascii?Q?lh7RVFPuqsohxUZlWpv70FkaGfVHnvfuV5006TkBOJkKGUsQTdrL8CzuWblP?=
 =?us-ascii?Q?CPAQ3TgqjJ6fwH4IUqExggpLYTklat+mU3lK+X7xGGTzmqgSiiqHGkcZV6yC?=
 =?us-ascii?Q?r2UDEII0kXk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kk2bfi/YztGO9a3ad7ldI6TAObsZ/9+bjf/HlzLjtuzC+Ir2TK0ogRgCcNv2?=
 =?us-ascii?Q?JIZjJp2jzf00bus/jGFtn4sVoejKQSZvfMvVqQgps94kaDrG/oBTX+diTh1h?=
 =?us-ascii?Q?zoZTfkPSAf/DdBTc2epaaPLtaNMFCS9zmGoCY95AzOJfCLjC7e/A91P0GTek?=
 =?us-ascii?Q?PQhYr8fVyuND2M3QmR8pxsriUkM/yIObKUzI3eaF/0x8nv40tABJjdJ01QHr?=
 =?us-ascii?Q?YTrX40px4MlvfME59GCpnVqVTqeboiZRuiPwhmTcF9mh+CU2cqOMYBpLWsNL?=
 =?us-ascii?Q?ctmqIVAxD3M+sttuN0SLCZIJjH0pqSZUQczAkRpMTxPXRZQIBylulZyj2B7l?=
 =?us-ascii?Q?mThJCLrG30lJ9291/6pQx0M+EO6IYAFNxcDvGuhn8KVqYmKycSA2La0gcVpr?=
 =?us-ascii?Q?xr9GsXlPSVmSvNG50z4fAJ8JBljRUImWSJMcb53WFFZRLNaKO1D4gBhqUijx?=
 =?us-ascii?Q?B8U/OhJHz78UoBkh0QEO4tpPW9YWbLByqcdj3rCu24oFuw6EmnUrrUTfv1WK?=
 =?us-ascii?Q?RPzBPGfkGyOyPi3q1IIVMCTekdu4yVAl1TCqsbuTiCu8eRL9JrnTQ8tef6HG?=
 =?us-ascii?Q?jqcIt8ULxmwegJhHi/eB8RYxL3fTSnM3i29LhoT8/d/ugn9IA2xPSIOptVvN?=
 =?us-ascii?Q?2VrjsRsQX2LaMljFVLU5H8KKCY8QEuxP4skh0e5s+6Diuvj7/yDB/Dspajl8?=
 =?us-ascii?Q?Ow0pGhk8+ZsXm0/Bjj6yH16CohZeqmhc/ReIpVRtJ63xft5BpHh8RwfEHjW3?=
 =?us-ascii?Q?ats4twy/8eLRriJmwoSwq7ynqQoeZrXw4ChUE0a5SR0TiDD01TM2NGnsBM5m?=
 =?us-ascii?Q?Na3h4+I1lC3xvGeKWpo2D4Y1AasMIHqPH9wxiETehLz3aZ6e25lbz1T04+nS?=
 =?us-ascii?Q?dDUCtM7D4Lc1Xa/YKkWrHwmbwYsN9afmAqj7DvtxcT1ImHE6aCPldAf9xWwh?=
 =?us-ascii?Q?xqoRbBoAkwIE7Asw+uzuHuS0WPCuJtpvN3yaY1IvXGZOIQYNyYC7hX7nh+Jx?=
 =?us-ascii?Q?sX9qS2hnKvlmaFrttkXpCqcaE2n2MsZlkHeD5ouXoFQUgtIkSlbwULQktiAr?=
 =?us-ascii?Q?q+mFVgQFagKiu708isun9O8UPbHawity800r6DKItIbxY1UpEHpJWaYxxV+R?=
 =?us-ascii?Q?zNCoV4nXv7PMmLlAs8wyC9gn5aWCl1I+AGHM8ObDcsaZsHhbHNff+kjBLlWP?=
 =?us-ascii?Q?Qd5YJIDIUQKsc/tMScNW1vNhyE9yoeqURqJEQzDEvNHVaGI0J6hyu9OP8Ofs?=
 =?us-ascii?Q?uUjke17ndB8lslJ/GlUuvpHu+XBVgjTe8XktXgBrT7SPTm5QL4dTnreZ4D5W?=
 =?us-ascii?Q?rpfWn0sdf5AG0VkEWDkFVCwR6lW5YJmS7l5ly4yEdNFEl3mazR42GS6stXRK?=
 =?us-ascii?Q?2h1nv2gZUN71oq6/tSGdrnBJcDGq3aVNL0ifGq+128Xxr02XFtcWgdB/rVfS?=
 =?us-ascii?Q?kkDXnaAdT2Z6BkO0wQDjjs3HqepKhcVplxi3vh7O1TTAWF9THjpkllZyecpw?=
 =?us-ascii?Q?W8uO0ZXrVwETn1DOS0k1lnbIVpLvK/DPecsrAGpUW1+g4ii6suc8kcCoM8Q2?=
 =?us-ascii?Q?1bBUQKhdMWn4CkyzrCQCWaERJokSVhpqWgpPMQ8m?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad6c3280-57dc-49a2-04a2-08dd55d427d7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:44.9665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5jgCY3B9QXlQBiCdxz3TAYzTJTazNDJjGf1+EjHq4pcnT7vfXfMEnSCvlJUJRtU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6617

The entire allocator API is built around using the kernel virtual address,
it is illegal to pass GFP_HIGHMEM in as a GFP flag. Block it in the common
code. Remove the duplicated checks from drivers.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
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
index 7efcaea0bd5c86..ebf330e67bfa30 100644
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

