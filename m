Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2080.outbound.protection.outlook.com [40.107.100.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B740D267707;
	Fri, 14 Feb 2025 17:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552884; cv=fail; b=tmvbWNxk2wN0duZE0qYi7WCjENOVrRwFKdNbIk6t0z+KU7XQa7QYoEZqQiPO8DzTJKyVaeXibk2kakRYwt6V2l0lgTMEeuKufITLS/KtltV1hTI+OHIMsayYLN9x6QBRXdLaoSHxggCItHK98kOTnGOTiIBt2Kbtn/ecKC4/11g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552884; c=relaxed/simple;
	bh=vn5pkMgyiUd2CHDMFNvB/WUJsTeWFTJZUsL5/wlKZKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OLjF7u8EQiU5s5hNHg4WK+hGYo9QyTWKNwVhDxtFsuZ8vJlPrVpuKUUgxNceWzDL29qx4L0xHBX9qGLEZrfgjQSTOFCpWFKdqW/iRWJq4pNk7ZAqyIKUhTlKH8beHz4UE/k6KH7A7UvEWbnYVv2NuUJ2KWz2qFYXfm/mic/xfvo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kQIlAAov; arc=fail smtp.client-ip=40.107.100.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kQIlAAov"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KS8AFPdY9sIRzysey+W9JEvwpKUORZf+Xp/oKyT18ggygwas20TBqHrfy+8M++lvru8IOpR2G+mLEE/74OIOgFukrGmlSIrlAIDbE0hO0IgtneenVFkQ966XQjF5Q6Wi0WrhZSUzzc1PNRz6vg0GxhEsbAzdd/LUPCGizroJc/UY0tjKplyZ8dQgZrZe3R0yY6EvT793f/wXhTiDD0ulSv95F2kv6SOOvMCMddTbjx2SnRVf75EspDqmn22kjhAeaAv1jggPHyHbffSLtolAITLT4hukcAWcVmVYsnU3yr/ltdOiJbPm9s/93BQUzZeiz0a0eEJox2P/s6w/GajUfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crLoqiiF/9UUXAPwMK3+epJ8tOtusmUpUxeQoMMsbz0=;
 b=S16BA44gqc54ALYi7NNAW8ml3zjk7VuZMF+uFbWGBcpxM2bclv3Pb+C2cPRel5aBYHRFFq6I/FpN45VIhXFpLnqs9WDbnf4dbto1Fbjxg3gl7iaxNuejEIa69wbJsJq9OPHB8N9jTHNHQzWrnvfE5IamUKiWUQXGBNYAP00dfVDutWJFmqi46QC6JgwHqFPisaN41pyxkc+8/5nntozS75laSan3vST2Sg+2RhQ8G4EavqBz0fXzBbsFI5G1R6w8y1gdmiwwsgKmkzTEQxWgD+Tv/fJjUxDRXzAmrASAY3+qSYEzmpE97sl02+vz8AEr6iKHw8e/2qZaxlConHsstw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crLoqiiF/9UUXAPwMK3+epJ8tOtusmUpUxeQoMMsbz0=;
 b=kQIlAAovwRSXyriddp0FwAoMrnW/VZ+ScWUwojuMqSg4v0chSS5euEA+w0R27HmqaOcGVXk4YwJ8y8GdggI4ZAmwTKclOgLGO3mbsW/gzgLMIaDponwEc5Mz182JlkSiHaxuTR9yhzyqPpPVahue3zWuJyTc83MRV1U/1XodpBozLNDUerWwnE/AjWYYv9ytFtZzzqbrztFhITfz7ieu3gz4njElXxQF/oNDR3aQg7gRp0Ap562yWk3ORrCACN/TpX3ranKVQJwqD6k+IBXmG1WzccBrjyTdLSrVcNAb+hJiZn5vIv2CkuA72THvtHxJJ6PMY49g41rn/IEjwxg0+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS7PR12MB5768.namprd12.prod.outlook.com (2603:10b6:8:77::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.12; Fri, 14 Feb
 2025 17:07:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:07:58 +0000
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
Subject: [PATCH v2 03/23] iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
Date: Fri, 14 Feb 2025 13:07:36 -0400
Message-ID: <3-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0012.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::25) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS7PR12MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 640bd7c3-0f82-4dfa-23f2-08dd4d1a212f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/cZFPzpMiUn665erE/ezDsHLV3088rp99R4Js7tNsroQp3AE9d7kDVgkffX4?=
 =?us-ascii?Q?vg1vSvG9ZBxl/25pbvsHG1c4x8pOymDGuSqfzejJhjtI4DIjmQ/LIYFDwBnQ?=
 =?us-ascii?Q?tXwJhAdDwUhLpkmmXWCdHubTwYHCnvqtr80xDPOBzzeMItUugTFbU5anLmAS?=
 =?us-ascii?Q?IVQ+D/a5IIVJZm395Wm7W6e6CNWsycSeOsPCUjFYp4UCnq6x9Kua4VvOkp+6?=
 =?us-ascii?Q?VeiaBadIs0RsgbvCJgTgZasUaHZVs/PcOneGErT5MwBiHGCPAHnqtNQhnJN6?=
 =?us-ascii?Q?aTIx2i89FYUcQslrwqkkdUezKg4BQ2uryU2dWF00GRoxyFoti6Q/7V6tnvDD?=
 =?us-ascii?Q?Es9NbBZAhonzSHovyGhBxdR5FnIt4q4wuWApdCtxKwz1UXCYw5CD+/Coy0Z0?=
 =?us-ascii?Q?v1cE0cn5S+PfJu0LbvQupiuzKRJWYxs3eceJ7RhVviWbj64edo8H2L10GLJJ?=
 =?us-ascii?Q?6NdesWeJh8sldSa4R84kEVVOk7hA+iHXV2T2H5rcuVHu8aisydJzJLUJlxBI?=
 =?us-ascii?Q?huqb1vgr0Yu32gOQN8h9Db/6j1YdGyEiMoFoX6CB9+zJeIoCxpn0FLKTknPU?=
 =?us-ascii?Q?dRIGWCua63KmhbyNqQjTJHUf1BWWwKOaEyrVrcy7HZ0PPbcSEPeABFoA8+QA?=
 =?us-ascii?Q?Db6jTyRpDlihvfsrGG9t62I0GcBtNAFVeO+93oRqBgpCksO5zx0sZe4NS3Zw?=
 =?us-ascii?Q?6uAKvrF1gGliZ2+q0CQd5lhjbpBxl01ZX1sBFS2RiAw/mecV9iqrgxB5b0ER?=
 =?us-ascii?Q?ZNAKodTlK0OIWNDWQVTt53C19yKYZK+J5eqYS3FMtIyk38GiJZ8Q+yGpMWUy?=
 =?us-ascii?Q?eHRYvQVkxgYvetIJ4qMjdccn6bzMOYQ7dRUXXru5qItTVeTcfeqQUsYXGKI+?=
 =?us-ascii?Q?90mzTEEoobk0eyKXfUc5d2DoXH9f10V2j90HdqrzeIXVpmqN5zPNMP5fa7uk?=
 =?us-ascii?Q?76pFhxTIuX9t/4+T6cs8giCfsLTNwZWWVOyfgJDuM8PyyhfMlG2NZViGf+bT?=
 =?us-ascii?Q?CX282JUFCm0Fj2EhNfs+AnYsWlQhuXY0YmOCUkifaG/Rw/PXe7DK9HL4km7Q?=
 =?us-ascii?Q?HdODp97vNTRCPjDd0XDITFEtc/V0TKnAtS5+VRpjKRjD3bXDuseZCed4RsKr?=
 =?us-ascii?Q?IwXUpz0Wlln1mb+LkcPv/QpIq3pzV9eyfTEiKvWooVvWQeZo4InzospRWRTx?=
 =?us-ascii?Q?yFKEEAWnZZF12y9GlKy3B8oFOTGPKgldTuT2t/h1+N/bCUegov1FNpoVyb2d?=
 =?us-ascii?Q?OsdJRTpFX6gHGHLZrbcvKSDsomVDrOgzoGCZtkNLV3UfcV8cZqihorA/qIGR?=
 =?us-ascii?Q?3lj75QzVcHlyPSVx1gj5/NA2Hux8mKb5YYbHCIgyUdt94HFiRLPI5jJBUsAE?=
 =?us-ascii?Q?ugyrZaG3yZjnzUNplAqW9T4Q9l2oeQrRbwR8PV4T/mt9ZNl+YtyceHKwKPsc?=
 =?us-ascii?Q?rt7KrujLzPI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XDRFb6+BdSXytbS5fFwRPEzZXKITa85tIdTIRVrEqMihV6sixBz1vAIq/Oke?=
 =?us-ascii?Q?tna9ort2HTEb09y7wyNhh7rKXS50+Nd15hParWIdYOtE757tb3RxhCj6YAAD?=
 =?us-ascii?Q?U4MG6liZq/CONd5Ln9hrkAMtz5tDLRGmzIjiqeMPZI9d8e3PB19+tyNcAuo0?=
 =?us-ascii?Q?ByAE5lXOKnfgeSOvmlAR9sx+zS62i31JoIWrChAOrHrd3TBWMjRuCRs1DRka?=
 =?us-ascii?Q?7g9B9c5r33xEWRHqUDSCx3sl2iusMJ0WrIgTL24BvJgPHAHxB5yLacSLPIGg?=
 =?us-ascii?Q?mXyWtkfXiZQca+rh9w0JiyHCkuPiue8uBa+8m8ec1o551VdznlD4xrS9jhTf?=
 =?us-ascii?Q?kWRSTgTH2fyvKhG5AcrI2TWXENqBmlnUi6mK4Hl3t5lDWOyHTxtEs6DT9WZM?=
 =?us-ascii?Q?TSSDbtOKz5stTX1zF1Diav+NzNfRbqsuhU/KfIfnZtbR1yGwbkfJlswevzEm?=
 =?us-ascii?Q?k7c7A2iqXRVAZ/i/MJ9bdEGMnO0hpZM9qS1rUIAEStddxh6z64hAcOkui1B9?=
 =?us-ascii?Q?lU5BTmQ16S4YL1dYDN4VH4iWCAZGdzgSX2BC+N4AXVp8QCTUiwKPpuaDZF4y?=
 =?us-ascii?Q?5CDkBz8BKbJuC4T6ca4bQjF95B/4Bl4E38Hwt/B6hUQOf3MQgNe5xCAbhZ+x?=
 =?us-ascii?Q?XOqxdl/ZzRFsNTDSEudmGOqDTMj7WKZn0x0Fj8357iPuVnTWa2iQ+DmOmmwK?=
 =?us-ascii?Q?Der64UrVap/v216BZtIeIOBy2pFdPw+anz/Zr5U4E7gmnWZwTlB7aD9Nj5jh?=
 =?us-ascii?Q?M8jLqMMAju+eZ6WxJyTZEONARqStOZUtSMRKsizox8G0jozXND8Fi34vMfRS?=
 =?us-ascii?Q?VS6XWaavD8k25zjzhV6/Ut7JTLU/z0AJsheaS3gqu2ygmr9Vf8bBrMjXDGru?=
 =?us-ascii?Q?xcWvd95TptltEOZQMhcZECY8PL1QUYZtbbZAKiGLUQEsnf5AzjARded1zlQZ?=
 =?us-ascii?Q?erXkNC8ERK1svrN/O3laeRxgDwyTscNwhnUnXdgID7Ey/QQjpbrRmB1JFwh5?=
 =?us-ascii?Q?8LksSUrWsvMSO+5xFaIjuxAPf4UoIT9i1PsiD5rTdUoJUDjsw/XXaVkWXe/s?=
 =?us-ascii?Q?ivXnD5hkX83hSe0VylLWX5HHgjmcdsMjq8O8vPxcKAf/wBRfFrupTVjOHxKY?=
 =?us-ascii?Q?oSuJCiPL7saXsRMy4qSHktSNCkN7MhgLV3UUX6SyMkXo8oOjMMKuoC/DYYaN?=
 =?us-ascii?Q?ymnaZUZPeKM0sKMLhujcxNtTLYMpn39Ed51VDYERBJkct3ZG14q3DAJByhLX?=
 =?us-ascii?Q?Lw6BlcUTw57khfebA+D3qKwqbzxqx8ceU+yyWAiXDesL8jqb7j+uC5gLSY2e?=
 =?us-ascii?Q?1PLR1aZQZT65av+WyabJoH5YDAG2QO3R/uKGx5rURUbtWSSIUDj6jTwpYOpu?=
 =?us-ascii?Q?cSNug6H4z98XyGWlrkJZQtn7RE33zMCyTbr4rfchlVjJrfwcOUlxkD2+uwK8?=
 =?us-ascii?Q?bdnwVxpOnjdiAu2TNAdBQX2xq9m+ITu+uRKpqYIPnigfBzGa6/KIw3lAgWkW?=
 =?us-ascii?Q?eMWYLqUftMYHlSQquav3PHwGgXBvE9Wg6kCi2k80Fa+mLt9H3bd4ML8wE1G7?=
 =?us-ascii?Q?EgRwjRzkUjioWVKsJuc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 640bd7c3-0f82-4dfa-23f2-08dd4d1a212f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:07:58.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kOKdJuFSbqDuzjLH/sdawxVGcxf57kcyfAGJ0wkYhz6hxLgLBbX35GajK5KgowLr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5768

These were only used by tegra-smmu and leaked the struct page out of the
API. Delete them since tega-smmu has been converted to the other APIs.

In the process flatten the call tree so we have fewer one line functions
calling other one line functions.. iommu_alloc_pages_node() is the real
allocator and everything else can just call it directly.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.h | 49 ++++++-------------------------------
 1 file changed, 7 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 82ebf00330811c..0ca2437989a0e1 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -46,40 +46,6 @@ static inline void __iommu_free_account(struct page *page, int order)
 	mod_lruvec_page_state(page, NR_SECONDARY_PAGETABLE, -pgcnt);
 }
 
-/**
- * __iommu_alloc_pages - allocate a zeroed page of a given order.
- * @gfp: buddy allocator flags
- * @order: page order
- *
- * returns the head struct page of the allocated page.
- */
-static inline struct page *__iommu_alloc_pages(gfp_t gfp, int order)
-{
-	struct page *page;
-
-	page = alloc_pages(gfp | __GFP_ZERO, order);
-	if (unlikely(!page))
-		return NULL;
-
-	__iommu_alloc_account(page, order);
-
-	return page;
-}
-
-/**
- * __iommu_free_pages - free page of a given order
- * @page: head struct page of the page
- * @order: page order
- */
-static inline void __iommu_free_pages(struct page *page, int order)
-{
-	if (!page)
-		return;
-
-	__iommu_free_account(page, order);
-	__free_pages(page, order);
-}
-
 /**
  * iommu_alloc_pages_node - allocate a zeroed page of a given order from
  * specific NUMA node.
@@ -110,12 +76,7 @@ static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
  */
 static inline void *iommu_alloc_pages(gfp_t gfp, int order)
 {
-	struct page *page = __iommu_alloc_pages(gfp, order);
-
-	if (unlikely(!page))
-		return NULL;
-
-	return page_address(page);
+	return iommu_alloc_pages_node(numa_node_id(), gfp, order);
 }
 
 /**
@@ -138,7 +99,7 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
  */
 static inline void *iommu_alloc_page(gfp_t gfp)
 {
-	return iommu_alloc_pages(gfp, 0);
+	return iommu_alloc_pages_node(numa_node_id(), gfp, 0);
 }
 
 /**
@@ -148,10 +109,14 @@ static inline void *iommu_alloc_page(gfp_t gfp)
  */
 static inline void iommu_free_pages(void *virt, int order)
 {
+	struct page *page;
+
 	if (!virt)
 		return;
 
-	__iommu_free_pages(virt_to_page(virt), order);
+	page = virt_to_page(virt);
+	__iommu_free_account(page, order);
+	__free_pages(page, order);
 }
 
 /**
-- 
2.43.0

