Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E6520ADE6;
	Tue, 25 Feb 2025 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512389; cv=fail; b=RjGqYdd3WhZukktDRbV5hcUI02OSdMWdkAstjIddl3HmLNJxw4+HVpLvjYvboNR2tq9pl+zjzG3uqIay21TfRS69eJO4dpYFDG+vVNO8u+kkkYWBW++a+LHBNalwwyXQoXapqVHC52h/VZCV98JBox77KyfkPyx6j3TM/1DVpm0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512389; c=relaxed/simple;
	bh=UtzKKSBnaS8lFZPW0jL6yaEcdSrKtxLoeFbl758erko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SyBtrpJrIns3qeVCFgLxuO+20oKo+8tCuS+QFnXHPCtv57rH4G4gWkeQ9hOEuw3Z8teNwhLLW4tz5y+TO8b5B3HicF1HwNEJ372GTgmTRABcn/clJz5cHa5Za52oNTk1Qg18LsMNyHtk6fPb/RwVjLFacfyZN1cGmWHe9lJWA9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=COd8qII5; arc=fail smtp.client-ip=40.107.237.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="COd8qII5"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IbK3qWoc8OB8T2JRrEJR3LiQizIHqvXP3HP/QUCj9FAKlratpa29cFqvE5mtRvDT6MnAzabfRN1/el+v7hYBPBNgFwGUTXVp68gsq3xwUk1j2uPgoBb6ziZAx6g9VQdw7PMkJn+jHzwbRueinLAXJtjcggUZjIPJMapHNZOlTaZEf37KTb8cNBcN0bhepknBKpdYxFFLImVxXlyJ9faAV+0Hk+EPOetfqSgw2/nwfFkPLP2FGqj1qMteHcqJT1kpVG9PjG2qbdt6nnqLOeSKjsIHy+gHC7QMtY/+kLiO9hnWyb8Yqk5sI+w5psstwAYTsnGteSTDczQ/lZ30ekfa2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KYH33h7k/qpe+6EAOIHWfkZhWMg4vY1I6a3/YmcazLo=;
 b=lZDl9SIT+DnVxnypxsDJ56+8k0CadPFBPxg0Ef34G6xbFXXnliEiclFUAs4sVtm2kSIw4HsCk+D0huKm6pdHvrvy6NTW8R5WzBsRjyU4nPGafi19Fhb1BaXrs7NtCG8gXwveDwYktm/9jLw1j9F4WQJDZ6bKamDHV96MjtVovYcBhaGwbvJQOODnKQRQVMPUgodObArQLabFETarP08onGxHn2DrXYXuGcsVf9L8j5+vynZ5T3SUqIWNAwIkt3EG7b0Ye6+cuoGMpUdSDqS2JhJS1B966TEjwcyU3xyKFCcs4DeanJc9O85ONEVYi7JqvNvVjID+R8jzJNA3eExBPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KYH33h7k/qpe+6EAOIHWfkZhWMg4vY1I6a3/YmcazLo=;
 b=COd8qII5CRAiJZ/9d79R5vMuzqR7e3zOjc8t9VYjkIw27CRuTYVagNFisobkXkjPeqrVqr3cuU+GNC2AqBRp3cON9bmJcWpRVq808KRaqr0eBAYyWCqmbsxRdRjb5COtV4EP/Gp55xpoBjxEUSjB3yETUEjTrdvNzeCiTJTBdm9/OYAneSWTTTm4xPDMwrdHWfSgt+/HQodZ7dAlLy/VudFJ/X52gbMUu/fQluguB9u/HBD9euV81mFW35cfbG/OmD04kPv0O44fdd8hx2IiIEm00dk48BrD6GMFO8c2Qg6RVmDRVF6zcZA9B6w0VH57nimTWmSvWyXq+3R/ZyQqfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.18; Tue, 25 Feb
 2025 19:39:43 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 19:39:42 +0000
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
Subject: [PATCH v3 04/23] iommu/pages: Make iommu_put_pages_list() work with high order allocations
Date: Tue, 25 Feb 2025 15:39:21 -0400
Message-ID: <4-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v3-e797f4dc6918+93057-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0065.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::20) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: 24555f48-feed-4604-2c11-08dd55d4264a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f8x0VIiCJtpGLJG8JB6x4Ab4S4pzt5kQzsTpNSqfKdCSa8WGGApmlajkhsDa?=
 =?us-ascii?Q?5W4X285PIimklcO3amXvqPXIisiOaaxU693oFfSVRqKFikvK1lXpS7OKKr5g?=
 =?us-ascii?Q?sGZV0y0Gv3HUSugxP1XylQJ34oNB+j80pdzt/ZJfnCEvSfBcF0/4wO/gMLUo?=
 =?us-ascii?Q?AcnuenYPjDZAn8FskS+Yf0SSKnXs2QSeE2xQFAY6HfTfSaHNBQOkF+e4dXpz?=
 =?us-ascii?Q?NBff4R6fRS1hIAYfwr9aRo79NL/5WT7wbnklsKKsWxQX0fylit966e773Cxb?=
 =?us-ascii?Q?WBrafynkpZhQ0G8PSnfhQH/oT95zIlwfSIIBfw8FdoWnykILrzgH2TpX67mx?=
 =?us-ascii?Q?Y/C7dmrSarCRgC3EfKJs9UqXPQLjRPW9XOOMwh4M+I1yS617dKalU+5GwAhi?=
 =?us-ascii?Q?SOj6FewIH5w1nm/Vm8IASEYWYVW/zdehehE4+iGj+rHhk8WpXxeuGxDg95Py?=
 =?us-ascii?Q?dqU5bRcrYmSyROo6fytpEADPjtHbRbXom/kvaNAZmnjGGb5LUJA4CcNvX87C?=
 =?us-ascii?Q?v0sXZPnaVVOLgWQuDEXoJoE8AYjAXnoYAIdEgPQYzA0FUdah6d86u375R8w9?=
 =?us-ascii?Q?E15wpfmwYIIBCdenWQcJqEwekB8LHj7oWeSzJLdEGRa3i3cO1RBYCNES0OuZ?=
 =?us-ascii?Q?Qkb7GzhnrCMC/RjWaP3sYGRG5B6hf3bFSrmw0yN7fpq/5fvFc6G4JF55bSAm?=
 =?us-ascii?Q?btTDhD0yS95kV+EPe65HxKPRz3yOSSl5/M2Dj3Sh8z6L6fhG66CjaLmABl5f?=
 =?us-ascii?Q?wmV61wHuj/dlT56LqM4ZFxpN8CsUd8rVr3H8A7KE6AgUjr4svR+1HPQYmCaU?=
 =?us-ascii?Q?9k4TrkXj4RBTgC5iNNxSOWG4oijD1zBm6OeU6qnWSVmQFqzSPTMraWdnUXUv?=
 =?us-ascii?Q?PJZhbqDXeR+DYoaHG3ETg44U5lo6dgYhwSPx2/hFOIXlGcQD9uLo7Lyv4ga/?=
 =?us-ascii?Q?pj5wytzMWMsNyrnWctqYYfPY4J8QpXKkBrPtTgiLQi2w6Vs76yz6NCS4ON9w?=
 =?us-ascii?Q?UYnEkX8ZIZh6afwKQRP4QZRd4LIUvYWfxg1RS/QCPeW4Z3T0EeYoBt5VUaHD?=
 =?us-ascii?Q?PEzPuXHa/epdQHiEM4L373RSLp3tuSgAUbzvYNeLs0h6lG28ayipx79idDYg?=
 =?us-ascii?Q?QISaBKpmMALMp19HaG4pBX3Rb8S9N6RSsUzgUwSWAtMOJj9bty/w+CmWEcG6?=
 =?us-ascii?Q?H0OYuDnnY5tfJqGxrp8UyxqLM8Vrw3yVN6flsD3oLABOmSKAyy62GEVEYFlR?=
 =?us-ascii?Q?bWeXElUTGwaCt8kGVa2QCXYYLodD7mlFWH0eH9IvtqXKoPRXA56x2XXkSiJ4?=
 =?us-ascii?Q?/z2flOW6TImPm2KB9c1U3Wfv0hivaI+lRAYd+8gRQeu85p0/HbKa70GWBGCY?=
 =?us-ascii?Q?Vm0O83Y/+aL+jRci9nfDWXNRmgtgbrJREQeWwrJftWmYg4Z+4VaZJ5A7ooD4?=
 =?us-ascii?Q?7BdSGWTW05o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iu/geuCnLWYzM+4A25tOBElQVLSojk8UbYwk7j0wHFBlBdyYJknCElcicVx8?=
 =?us-ascii?Q?JGtsuKi93N+Df6lEi3ItJknol9cjPP2XXigaONj2zAka9tbWWOvwpTD/E0qu?=
 =?us-ascii?Q?lVQEsNENjQxPPlc/EVDc34jM9zglMYg0YE/AhMKBCjsCae7qI7SoTOzSqoFx?=
 =?us-ascii?Q?3eU63DbiwhBGFnmqyKtLHuqZFY7OSla49KvuK4nX9CtWIrK2rB2nIoSArxtc?=
 =?us-ascii?Q?KlZTLj7BJ8IrK/ropRTI2zs5n9wSdAQbeEIA1bjQrL9JZPEAFAOMNC+NeiuN?=
 =?us-ascii?Q?qUUPXflbmkBuCC9WASQbRNo3xON06UZ/r08UyeUWvibAv6B6lQbGGsGYLkG5?=
 =?us-ascii?Q?3NBOmUKfffZM0+5aHRpL+pHsjov5vBKIo8cutMWdG5XfphtvhPNSGxfvaPWX?=
 =?us-ascii?Q?2a/eyu20GgabymLVBKaIaYEzrkG+T1MKkDTPMEP2pw8kEBZ0VOFr8hQDm0za?=
 =?us-ascii?Q?Hv1XxJXoerAn7LXSHI/gdL4fdplqxacZQPGj7/+pM1EG7nRIH6tniIkqRl7Q?=
 =?us-ascii?Q?rDyZtWpPqCrvT0kq8fmKYWeqp0qmI6kOGjpHkCgoT1OntMFDZ0anzdiCFvj7?=
 =?us-ascii?Q?Qa3ol06GA76xyJa1Y5ca/FAldTH02Xwcx4vj9sgMliNoJT0Nf0YT6nbkJP+Q?=
 =?us-ascii?Q?q2YIZ+Af63iy0aQOixY38j4nFWrnhoz3ZRNMEEwwBnhWFX08xu+JqluEILQr?=
 =?us-ascii?Q?pdrLg0T5Ho8GNx1YxfC2rYZ0szM4o+S1gO2zLe57zcRlG8uL8GJCxryb75Iz?=
 =?us-ascii?Q?UCs42eUrzF7QS+fBt9pdQEL1hs3sphfH7j4QplHEg5bLBFozpbsck9FFT34g?=
 =?us-ascii?Q?cS26qKd6x3sXjHtMihc1GQPFiB9hKl/6Z3akoRYv3f329Irg+Kw068R/RjFc?=
 =?us-ascii?Q?S5V2lWLa1A8m+aGahbnnBGsXdLoG0DaxQ2yJzkoh5lu7Oj1aqMpu5sZh5X6p?=
 =?us-ascii?Q?e9w9GWDpm/4a9V9WbbXM7ecpm9lgayzi6eM/+GYRO8ZilyTJlDnhcxWG/l0Y?=
 =?us-ascii?Q?H6aT7/byGZvDo3V28SxHKaOP9wor0CvtgBhuDtfpdQAVT60kJgqTCRKv1o1k?=
 =?us-ascii?Q?rYqhp7MRRyK8fcbCyNThNowk9xQSEX5BqEyClKLBOu/NpSLpTBSZMVnGEhn0?=
 =?us-ascii?Q?5bMXV53LWoi6JtQuqu5BAI8V+KRKfPc+lahTa6sMDA37I9SCqA3JpOJc8teR?=
 =?us-ascii?Q?IdGVEfBDBD3i1gZCzaaZffeLwg/NG2LRxHSsJ36eTIGsYtP4qNnpHrv7pqzJ?=
 =?us-ascii?Q?TvXJTW3vgb9ulr08wCvSg1/+pkAm7SvA+9+szNnCk4f0dztGzu1kYvuekPZA?=
 =?us-ascii?Q?FO5LALqAUtl16hV5gMUDz5NgLPbfD6fZcipFvWRA1IqBTSQadIsPdC8lE7je?=
 =?us-ascii?Q?rnxcxys0ov6FFcE9KLk+mIg/kNVlMnj3Ib9o6eohufCw/huL5QglBS6bvB7K?=
 =?us-ascii?Q?4IoFsDWBE5JNcSuYHlG1QTFo5AhOYCQ8l61Z0NNKnwrAKbkxcV/zq7O0yypQ?=
 =?us-ascii?Q?4cX54fiCVID1dfJRCTMe4t7b/yHreavw32xE6favHXz+g4QXe8pX8XqNxurL?=
 =?us-ascii?Q?MLC5NJNnWSJNwbJ5taiDKF9korqTFlONNavgiR0+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24555f48-feed-4604-2c11-08dd55d4264a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 19:39:42.3121
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: apTkL4bt8k+Tv2264p3yF/eEcWNANt2wzxieEQEtF4w37OMJRnJsd+0nexPT2wbU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

alloc_pages_node(, order) needs to be paired with __free_pages(, order) to
free all the allocated pages. For order != 0 the return from
alloc_pages_node() is just a page list, it hasn't been formed into a
folio.

However iommu_put_pages_list() just calls put_page() on the head page of
an allocation, which will end up leaking the tail pages if order != 0.

Fix this by using __GFP_COMP to create a high order folio and then always
use put_page() to free the full high order folio.

__iommu_free_account() can get the order of the allocation via
folio_order(), which corrects the accounting of high order allocations in
iommu_put_pages_list(). This is the same technique slub uses.

As far as I can tell, none of the places using high order allocations are
also using the free list, so this not a current bug.

Fixes: 06c375053cef ("iommu/vt-d: add wrapper functions for page allocations")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index 0ca2437989a0e1..26b91940bdc146 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -38,8 +38,9 @@ static inline void __iommu_alloc_account(struct page *page, int order)
  * @page: head struct page of the page.
  * @order: order of the page
  */
-static inline void __iommu_free_account(struct page *page, int order)
+static inline void __iommu_free_account(struct page *page)
 {
+	unsigned int order = folio_order(page_folio(page));
 	const long pgcnt = 1l << order;
 
 	mod_node_page_state(page_pgdat(page), NR_IOMMU_PAGES, -pgcnt);
@@ -57,7 +58,8 @@ static inline void __iommu_free_account(struct page *page, int order)
  */
 static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp, int order)
 {
-	struct page *page = alloc_pages_node(nid, gfp | __GFP_ZERO, order);
+	struct page *page =
+		alloc_pages_node(nid, gfp | __GFP_ZERO | __GFP_COMP, order);
 
 	if (unlikely(!page))
 		return NULL;
@@ -115,8 +117,8 @@ static inline void iommu_free_pages(void *virt, int order)
 		return;
 
 	page = virt_to_page(virt);
-	__iommu_free_account(page, order);
-	__free_pages(page, order);
+	__iommu_free_account(page);
+	put_page(page);
 }
 
 /**
@@ -143,7 +145,7 @@ static inline void iommu_put_pages_list(struct list_head *page)
 		struct page *p = list_entry(page->prev, struct page, lru);
 
 		list_del(&p->lru);
-		__iommu_free_account(p, 0);
+		__iommu_free_account(p);
 		put_page(p);
 	}
 }
-- 
2.43.0

