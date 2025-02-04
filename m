Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8F0218E9B;
	Tue,  4 Feb 2025 18:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694123; cv=fail; b=qlA3HBMX1UjHTmMr3yJH081bAsZlYdO62x8vHV0+vkVH/6loVxZ7jIpUKSwPJLL4fUfk20xt3+L2HyxzVBBUSmgQ3cMCbVQozJVEGVi8VAIM71BweK9lBSpFztJrl0YPoszVaGILqWYKxfy2uyMoykh0hwO9IoxNV8MyatPEg3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694123; c=relaxed/simple;
	bh=vn5pkMgyiUd2CHDMFNvB/WUJsTeWFTJZUsL5/wlKZKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=If5ONQtvDRx2MlvmeAygKfnnp3lfuVDlQjck0JCBJ1sebgAb0wQArreukWHywO2GM4a8QRRu71RNjBsuZTDi4hLZ5PVdsm+1CD6JOj+msgZh6Wm1PRdv1BVFNdspiEPbJIvOp5W5h9ibooiqDWuPrwRY3BlxSuwZOy0rN8l0Cy0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gQy4rvEr; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gQy4rvEr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ngdx/UqoNhDj98QrLigeL4VlHaxjBAhg36uD7cTZIGa6cHBMgWVgfE/PjXL1AhDbhHpRXqVsz7VCpFthdEQ2gUmBB2wA+MMyWeg2PZRM0XQHbwlR3n6YLWcu7ZhdDEEfDOKrIqy42nOoWhAx0hd1a9SIG3QEHbAxPGm/hNRwgkv7BNAUUQFKyxls15LczL8iEKOOUtL3dyjqpnHE/Fv30dQOJs3qq6b4+l2R7HPV1ui1T0q8kK/M1iQHuTHTVqF6UOiI03dpl+ui5xWCmoJuFxbvRAm1i1Rl2Q7BxJAocEXvsSlNVzzl3Q+cEeb1qm8n3Lt4+6rpbrIvN/qvGAs8dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=crLoqiiF/9UUXAPwMK3+epJ8tOtusmUpUxeQoMMsbz0=;
 b=DIj7M5re2JTAJ6qkAfuOCFLZTlg0LCSnqZvcLSta1ATW7VpA8FHRHdbMa5FFkDzqUkFdGdQ+v/BBBWixr7miG+pvNXMR6ELKSw2E8RHV5wgxx7NBb24nzK0WNAiZi3c0x9zpykkLMqvsbrV//+nT1/jjCeL+4DCBt37UD192dS9JcEGmh3ol7muLFlMUWjBJG+IauT/A9zDR93lccrO52tI7tgtXvGSoljdtV1pw8Jtn7K990ICCorG1I4upmX4uv8GAoehdj2AblL3/gdqqQw/tcsfwt+fvE/3YDj5u0roYafqmQcjCHe6Y24VVhSJV92jMnqb7r7B5Cpd+3aq+Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=crLoqiiF/9UUXAPwMK3+epJ8tOtusmUpUxeQoMMsbz0=;
 b=gQy4rvErd/VK3L7E08wADCWWELpjMtDeWLtM7n24NCgn8JWKlIFXDJgw4a+SF74AdOJRYpJov5TbqsNRZ2DJvFLmmThDcZ69xhExWa5BRohEW1oWcEjoQ4rtNL+2S4qVSZdBOk5gEclj4tBoECH9ygOzUcSB7UJXqlzSn2jIMcdcmMXelLAojfY2dobqMSaNniGSQULBPnOcIzc3s5rdCbR+E0tWVON3i/hHCEMxr/o4dpbjkJaIiDm7zLMZYQnPest1tNKxRf5/bJojlklHoKJKgVIy+H8xsU4wF94A3Bl+nunSp+BEAQbNTqkJX4ZKs14Lr7nma4Ws1sZ3ZfjDFg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PR12MB8226.namprd12.prod.outlook.com (2603:10b6:208:403::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:13 +0000
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
Subject: [PATCH 03/19] iommu/pages: Remove __iommu_alloc_pages()/__iommu_free_pages()
Date: Tue,  4 Feb 2025 14:34:44 -0400
Message-ID: <3-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:207:17::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PR12MB8226:EE_
X-MS-Office365-Filtering-Correlation-Id: 82aebcec-3b48-4dfa-0826-08dd454aa4f2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XvGk5/zvJxoxlo2kwnqYhgnBAtA0mbQkcrYs+stNb2slDc7bDEWuIP6lCAYR?=
 =?us-ascii?Q?ryW0QiuGXhC5wQldHo1GL1s1Q09ngKyS49I7zi5gzpsvyncy/CGkCURL14Pr?=
 =?us-ascii?Q?rbXPdINmLwJAfaR06UdpxwNHSkECcg411nlYVKvg6W/kDK9CB1z06lm5s3Vu?=
 =?us-ascii?Q?l7m7Ia87yP9SPmG1RApXxor+7MyozYpp1FnAptS00AeF3TzO1FE3fjdQ8UY2?=
 =?us-ascii?Q?NHoobdImNzvxFQ+DbxzQTfjQcaG9yf9VOaHPfDyPjJBNsv7H5b7fLcdt4deL?=
 =?us-ascii?Q?VZgsEahWpiaSzHrExd2/WtwytnooM1AaRS0xfp4y9kZuDiW5DEEoq/jcdEgr?=
 =?us-ascii?Q?WTYU+z/x2xWoB6eK8SSvrEQrbDkMUCm9H8Vp03sKkMWjD3C5RpGfak9zAoFV?=
 =?us-ascii?Q?+n7TL9NiGnRGzzOEnVwcgrGmh1ipSt8rNscG2iseOGwj9bew0c+3dqBe1yvc?=
 =?us-ascii?Q?JtL8TG+AeqvI82ypTBt4UQxgAvRwzzezYvI2Nb0t/QV1h6wvdusX2WCFLYk9?=
 =?us-ascii?Q?Z5uz/TYDmRfhw2/CJlxEsI/YdpwaUrSULHmjjMCiN6hQcMisUx3hbHP3U44k?=
 =?us-ascii?Q?/FHvwA6qQk+4DzTYQcdka7kb4pBcpWJlGEVWMD7JAod86lhS+3x+XL3JqeN9?=
 =?us-ascii?Q?59kaZOFbaD3FDUdjZS/Dv+tMkcFNck0fCvShmh5e2yLNi5Q/kuQ9l81fKNTF?=
 =?us-ascii?Q?mD2y5k9reRLzMNyzc1qGmStOvGAr/f3604ziy4BHQHNtjGRx9fuLtphwlUtZ?=
 =?us-ascii?Q?HFjHbk2Y3tIdJUzylFkD9GNuu0q8HKT0Pqt/wKM/mHomNcf4ngLOpNz8F6Bx?=
 =?us-ascii?Q?ToefJGSI26nCNWCahulXrUub0uoeOHJ9baOKdqOzqtp/jx1ouVQD+C92muyP?=
 =?us-ascii?Q?+r7Cz+76sTwmYBniELaKMthdkiPwrcOpxikKMQwd0N2bmLjR5LIKP+jmhGZp?=
 =?us-ascii?Q?wJBRyTUWIsajNky721SHQ9r8gJcXStTVw9Qq2AiHyk5CWMFHq6rqr6QtiPrp?=
 =?us-ascii?Q?+Js5x/7zlN6OfnzNoY9ZYgFBupakAHXFQYMKcq9j8VjqqryDF4ihSeC+SHt1?=
 =?us-ascii?Q?pEgzwE8N3epxivpnvct/XpLYRvOv4bpZ9uiY4S/Yd6tsZa837oMGujw3hZ3J?=
 =?us-ascii?Q?TA2qcHhtKWoYTsVgsQPFT0RDy75EkbiAlzPo0CQA8aod+trznY1ylBiF+0bW?=
 =?us-ascii?Q?G4WmChfMlZCpjoPYPtrbhqGG5tWEtWOLix7lUDG5WAAXaMhxrO0a1Rk0ZylY?=
 =?us-ascii?Q?kluO0EhyPx3DT2kIFGUKxVazka2nfnTGlYuo7ut1PxkPTSfmFrNsqTGcs+ex?=
 =?us-ascii?Q?X8T0Gre4WKubEjMXg/x6EHtixZVgRq8jqbg4uIY6+LwZLeKXTBamIaL/AXG6?=
 =?us-ascii?Q?YPEy3ZGoSeWUdPZx9m6EzkuvXSNfd3sIw0E193s/sT1aNut5nJRdgSq1iSlx?=
 =?us-ascii?Q?jh3Ln01K3pc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ffBXiOpmvDjMkaUl6ZwevFbnq0jVvszdm6veSp7prY2zZoPHYrPJZPiUnyMf?=
 =?us-ascii?Q?iG1pfYzpSlFHfq3goF5ELvA18FuA15IlXeexn0WYeSa9F+9agLf6uMwkhVMS?=
 =?us-ascii?Q?MZrRKDvizmy3a+UfcZbP5EZucXwq3R90V/SaHUD1ewM6A5EGotkUrSdGoZnb?=
 =?us-ascii?Q?VvcSdNxB4wB5NKWGJv+vkKq5KvokY2pAiYtPgIAqr5tDHs0qosPJTLrGvO2S?=
 =?us-ascii?Q?aCTXJ3rFVTC/zWVrfqTONe/lnGilShQsg7Vnk0sl5DGGnnJGwz7QfoDaWKhM?=
 =?us-ascii?Q?M9OUFt3En6zxCmzCmdL6PFzN3QtCy7P43+OjR+tVmhPXzkec8H6o2QBM1jSS?=
 =?us-ascii?Q?S7Y4+2zlGexgD+fgcg0+WtykVBpsolCkTgahwEXBqZOOl7OOoeg30x/Bjta2?=
 =?us-ascii?Q?XWPyMx96LU4rSaPyECIXqN99L8sDni22WvPUbDK7Icrg2qG7xL/dpnzAm7Si?=
 =?us-ascii?Q?suW3PRpJ/OCxC7e3rmIpAbBC+xRlFDFqLtZWzBh7JYB6+jZrh96eVgtog6JI?=
 =?us-ascii?Q?+M5Ob4DGrX1MUK7c2RVcY9UlvfgH8vF6HkSTZXAgFJ5KZjLzTukfqNaEgNoE?=
 =?us-ascii?Q?dqxzyumwQcoa2W2Guw/KM2SJjbs7dWEkaOkyBT6tXk0ghi2QXrOc2346q/qZ?=
 =?us-ascii?Q?Scnu9zS05jl22O5hpMFrRXgxoxdRSF/0EZqAwj+h3XhTrfBxCpkwYfqvDrmH?=
 =?us-ascii?Q?XZrfIb7cduKFttzeX4OyuXw50DKjY5HB0QtQcIYFeNcarPanirHJNPjOrxXP?=
 =?us-ascii?Q?Zfx+NgpMwDOUDA4w19lgH22w0u4myD+UzowPHPK383Hp16DFJ7qPnkmUfh0u?=
 =?us-ascii?Q?FqWw9YWCCs+cxSW1PVporpzCBwxoaZKlQ62zUR2A67FZp8ihljfvTRgeWnib?=
 =?us-ascii?Q?4j4pyrhlsWrgOPohUu1kUkBq0yNZ+e8P/dClMvfEMP3ZWC2SNYPJZ8inM4lW?=
 =?us-ascii?Q?p9oqr633eteAsij8B5IGsUblhrXrf2ujz6izVerwu4YIQmDFIlWbjnJgRa87?=
 =?us-ascii?Q?BLMmJbCy4kRs5LWKN6jpMS8qICfV++9rpQ7iCL2TeMMAz0iZ96YtnnAc7tQg?=
 =?us-ascii?Q?DHdQO6cDPrVcOydykl8oztJ9WNlvdgUZJu8kOFtkrRgSjae7KzeZmD0/UqEo?=
 =?us-ascii?Q?J6leQXDxnSSaUMBzvqrPMY+2+yZbZddQnin39Y7MnBrcb6mxeksolF37byZO?=
 =?us-ascii?Q?Dbws0qY9zrz1GMLEVaIv5qagqqO42WRx7M0CsN2NhFEUcRHuJLLq90egB0ZO?=
 =?us-ascii?Q?PzP/QPhCklbtYg2O48sqbAgFscllxahD6SFkQ/NbDjkePukBATxqUtbd6ree?=
 =?us-ascii?Q?NtRFCUTYHPICfPwg6lVLRZs08zV79sw3zOJRT17AaGpNm6KIytKXbuMo/d5H?=
 =?us-ascii?Q?eysswfM5NTXtC3OL+dxw0IhN5XCLtKpp2TqOA0F33E5z+bNXZAB9rr1NIcwd?=
 =?us-ascii?Q?lUHLsRquMO5oQHfTsqIa8V8OiB/Z0flus+dagLGG5j8WNgLbRsAD/8ckdX4U?=
 =?us-ascii?Q?+1+NVxS5B3hy0APgC+fYQO7fiPZUzrdLDBNEsyV7lboHDOlZMSm7MBPwi5mD?=
 =?us-ascii?Q?VSUIuHcwJ3wkgbUJfaY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82aebcec-3b48-4dfa-0826-08dd454aa4f2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:05.5842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVOflMwNOz7/iYfr7ii/8qdBTbYY6kCdSlgCouxu/tlqST/4ecaqXPO7gG9T20tL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8226

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

