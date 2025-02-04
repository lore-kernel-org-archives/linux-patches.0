Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2077.outbound.protection.outlook.com [40.107.212.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E06218E81;
	Tue,  4 Feb 2025 18:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738694122; cv=fail; b=hipJviDKdeTgT0bkXWCXkwQvbLENfzb/o32YmlIq9yoNM3P+U+sNhMeDnZBTWPyGWYDavJbjtS3W5blnsL/xFinYtkG5Nwj2Iv6bArFKdFHXnwmXs2mb9ijnUXVcpzdg4RRCl5EEodEYYsO5wJY7i+lfc9W9yk9uO4zt/ktq2Q4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738694122; c=relaxed/simple;
	bh=NxWZ3GKme+1H9irWRUCNT7aZlGUlBLq+ptZ4Qf8Og2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fNAPVBbYehQuHLV4OYf4Tp8QSay09Io1xPjjWv8ztwGWLn6l64JknNyRI8LVbDBEIjPzbK1IbU6R8HO8kW99knXsNsElhqkg8kAB7z2RQp8w8PW2AGTz7fRcdMiZrl9fsbWGwMnL0hpVcSSfOsJGLEF/DQbIzjDyj4Q6LpN2X8w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CaPeWO7v; arc=fail smtp.client-ip=40.107.212.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CaPeWO7v"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYfXL8OVn+xWjOiE5NWYdKG06Wo4P/6UBLN5TJgqyPFM2lE+g3Bek8D83FDk4+owGQy5M2dVPyqLvTN2amX1Fgx7CcADYJDeZXpCwoCUo+Og5zUVCSVjL/Q8qJQ2sTncWWG/x8ScDQkvy0EereLWV/Vbz/QGBZvQ1T4iHljjDgerJPpLEMw/uxUHqJFOynaTKKglfBbu5xjJ2BzIdVMsOmfNpMjjKaCGfcURH5RjILrCbYhL69iCxNHpqBS1BSlrq9d+w23YpepoeXokXrmsCqs2Y7U7LALlVipdE8WqUMn2q4fAAjyns02fZD/cqOEv87/s2uq7g+v+8Ysf33ag1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pehSZxileB9X678yOtRWmxp/vUvAKDMKRvSnDyrCZUo=;
 b=W6i53ClZq/rJKhXqAkwcJlz6WOHAMy2qKKzF10D5mUfsif26e23L2GUZtCEjTThbHI7y0jKjt64+jD4skRDZ8u03okefI1xndHF3x0Bv5iRg7ObVHlHFGY1Yf32g9/cT7dZOdyq5giZzAjQy5CQFOrR1zyvbQIKzCUbBT/ZX8GdRDqN4iua6Kauh7TSdSsjj8UM5tgWmMClyrpIBf/mAoikHwmppwct/84w+nI26AgEHRA0iO5fApRvxGz8P69FpUZf2H0ovUvZEJhAlEdd2hU6jPiDlf+15HjNrgS0+XK0rOtv2ya2GcI/Kf1FwU7zbOkMB84TK+xlmLEP+o+HLYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pehSZxileB9X678yOtRWmxp/vUvAKDMKRvSnDyrCZUo=;
 b=CaPeWO7vWWJ54cDwfNfQHQGk1BEByWdI0eUgVUG5f+QlPr/pcHwbuC/ipHTsvp9krwpUkE4TTwgpEjPeKjFEWwaIwRN+jtBu87j2oUuf7cu+RY8VgqBLiZHHsEzd+3feMJBy36PEpPvJE+BbaSqzaNFEzBy2/Xc9rotpQhw0cphKLxPQS85rrDBwSos33Hd4sGPCEv7cyt68hDsWj+HzXXmjshn7c1IfIKiUotytodrENtoUrAj+dB7ECjXl+XtLe1lqcdV6WRj4OmSa9KTZBGLcRj5hQab5zAmyc1i8cYqHyye3KBzIICKvav/A5B66WONRQrYur71V+hgeZ1xS4A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6573.namprd12.prod.outlook.com (2603:10b6:930:43::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Tue, 4 Feb
 2025 18:35:08 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 18:35:08 +0000
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
Subject: [PATCH 09/19] iommu/riscv: Convert to use struct iommu_pages_list
Date: Tue,  4 Feb 2025 14:34:50 -0400
Message-ID: <9-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v1-416f64558c7c+2a5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0002.namprd15.prod.outlook.com
 (2603:10b6:207:17::15) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6573:EE_
X-MS-Office365-Filtering-Correlation-Id: c631d5b3-4b67-4149-1ac2-08dd454aa3ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J7T9Y/JDfe94NHrtnqbHOCuOY70GYXxAH4AVtwddL0uHFhKSAF7w/XLiN7PS?=
 =?us-ascii?Q?jb6BUhAcwTrvWFBg+iOl/8YFXv2B2dY+3ZstMMbEzggBV4KxukM56sAAjOWE?=
 =?us-ascii?Q?ybufsqs7dxYQwDUImoYCZTVyQKEr5WPF8tbrhMZ0aNy3CmrbN1Emx01cbHkm?=
 =?us-ascii?Q?QEqdppTEwMLxgVl/osFLBl3TzO2Y/GGmElx4fv1gALWCmDCblkfcPSM0e5FS?=
 =?us-ascii?Q?0Mtt2Ny+id9hcxYCLBOqD2eN1509ae2vJYbzXjslfqyfjFey4LwIW5y8p05H?=
 =?us-ascii?Q?eq7QQciVgBfAf9R27gSGvdRK1tCWpHGJ5TnZ52UI8m+s40GJ368h4NtFykIy?=
 =?us-ascii?Q?OX3nT/hoFOemZLCgH0YK9meKtsmqrN+2T/LzqnHWrpYgz4QbO9o+GBJQLkad?=
 =?us-ascii?Q?vv0MGBbjmr0FLYJNaubP/zklO/QjF5C9hkVzLKYjR9TIp9oHSBJDR4CdcfDm?=
 =?us-ascii?Q?nkbSLu9DX9zkxmq8ulXUKwyBhw/GgaNJUpxOPaGea2gf2kEoBqQ3cQoiHZ59?=
 =?us-ascii?Q?sQpk8Wn8VBImr2GSdq427Wra3n+PD4P2AV4V7tKEFR3pt7GYU7SLEJYZOTWd?=
 =?us-ascii?Q?vWSydwz7bxl56lz2CxFS+cEc4Q/jvUGRgN58rjZvBjlxyqNnAk3gJ4KKfY8p?=
 =?us-ascii?Q?Ag/d+gOntX3wIDm/ui7jRBAuNowyHtEoS4H7UOZkIYAgHz9zwpXP0CNdGNvQ?=
 =?us-ascii?Q?gUp+03Yoerf6fsUu2O9uvoE1hlepu7MY+GOzF9S23gmj6QJZaQOc9HK5eHdJ?=
 =?us-ascii?Q?iGCVAYy3EShqHEhvFUauG57SNKYvUZQ5NMXPYE1RhBCFmdIeaG/2/f+zDmw7?=
 =?us-ascii?Q?9Rvnz8UFRY1yrm5On0SYOpRkvNBgmalcqpBCZ9SjqqB9bqrb/cffxQOz7/lw?=
 =?us-ascii?Q?67yZnQMsBOQghAHQHM2dq3Gth1ViYM71OiTBXbphBqmbJW570m7H6w1GLsBU?=
 =?us-ascii?Q?s+eZyIszmGROCb05pv9ATIPteGQo4NpU7C6ruk2OP/vgI4lK932LqhVfU4FP?=
 =?us-ascii?Q?yHoORwX0VZrBcQlNB+hJDvX9ektKzVf7/DCekyiwudeblCgqfTQtcw9tSui5?=
 =?us-ascii?Q?T80dw0QCKM+aukJ9jVJk0UotT/7mwNnf1GUyalP+PFxIaw6Yyffa59JZhOWm?=
 =?us-ascii?Q?ABGUGrPpB1AOebkBGxPwZY9eJS+3DLrLMZqaZNAXGA435cRTSUGYoVe/+HXh?=
 =?us-ascii?Q?Yuc6nQ8wxJK9sUxXreAR43tsoZESi56grR9n8Mw3uc7CG3K5XSSPAHpLDY2T?=
 =?us-ascii?Q?qx1bcvALE1ofHjFxlxoPSWeKq7fflahhMpwit4d8r/QDwJCCBf5/2v7yKxIY?=
 =?us-ascii?Q?kF9Go4iJJIhUPxnTY/dbHIziJP7yTXkWfrOif596Qlp9f6vODK7TFdQRkWNq?=
 =?us-ascii?Q?I3HcsQ8aGumvgko5TKrsvLkvwzPMpeo/aysfYZG/fkqN8driO9O0d+NOQqU4?=
 =?us-ascii?Q?ayruGM5LAuw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7HwtENCxYxMl65rTcf+k8vrUy/AnMbci8r18TZQWjzkt4KUBqGk3VcCQawGX?=
 =?us-ascii?Q?Asj3ovxC1NSIn5VvQ8XgUn8iKI3zqvTIvKzpmDmNsKVb8jD4IJAU+d4vDOoU?=
 =?us-ascii?Q?Y7P/dmf9/OLHOc3ayTY6iXiiI/B4Vh4NNLOqjitXW0WDiozfu2yOa4wk14Ib?=
 =?us-ascii?Q?sr3cKW4qTOwnOkk0G89naksh6ESkxAYUHcCLE05fuFRUqDoKIX/VPbtq7brw?=
 =?us-ascii?Q?v6KC6iCAWj08bBNq/pEPYvWxlxkMuwta61PGsVfavGPJ3ZBCz+dKKCbiH9HW?=
 =?us-ascii?Q?Vl1tALDUWiuaJ18gbinX8Fhg5ztLziSdVFDyMphVl3WarH6pGmYKrwkxlpB/?=
 =?us-ascii?Q?vT6xIL3RHnxHhe1iSf42SGd/FCn3jcCSpa8xaZ8adU05Vq2kM65QJRls3lqT?=
 =?us-ascii?Q?82077ojvWgRGITMSZ0iMO5+ta5xYZfE4uf9FbZAkYcEVNg2PlwBF4RmJUs28?=
 =?us-ascii?Q?EHbxKWP4kw2Aevg5uG9J7dsz4ev6XMPgbTR2ZyRjkAGnjzRhbijyNrussHFz?=
 =?us-ascii?Q?NaFLZ+RQ3AZ7f9ISkyb1Nl08oK2jNb4mj4DPedAdX22Zu5gQUr2LpiAgNgl4?=
 =?us-ascii?Q?K1sZoYKHtVthwAuTwtfcWjndy+10E0Dm3S/gX/P8edk5o1d7u5iqM9IVW1KI?=
 =?us-ascii?Q?FLmFw1irK7vtl8VkX7+8H70kDN7IDxTg5MGihZAL8MMQNUjmjk5nLjW99X4H?=
 =?us-ascii?Q?gbv+u9U492j5dAtcnIEQUOllMTOqfWDiZHw6tksI1OuBdvY8Vln7ujtd3eMS?=
 =?us-ascii?Q?DXx7CieP7seh0n6q8gSWfadsdy03HFggZBbBhBXy3fkS+3ZQKMsBTo8tVndf?=
 =?us-ascii?Q?HpPzEWsuq81ELvsDsyvepKfiMfHDkekXEDQT/FzvnQr5//LvrwQ2TqzY0YUb?=
 =?us-ascii?Q?WQgBkWnHLHZdupnDeC4Lsh5VMxNEb8e4rU0nrM1MEfuyJU0jqv0coYWMaNR/?=
 =?us-ascii?Q?Tu9qODcdwWmDTRB5C/nc2lF1cnri3AYaus0cp3B/SDqZSLo53EhAwiOt0cz2?=
 =?us-ascii?Q?Qh3hBP3guXtTnaiW3mX60v7/eB6y+7UTUTDWz6kwD9GwYnakcnBotv7guUuk?=
 =?us-ascii?Q?nN4QPYRGYfooy6T7Av/M/IlfOUc0S/z/sdZ2ME0M1E+Qz0bNwxrc9T5o/xKs?=
 =?us-ascii?Q?i0sY2jebSTYpCLLDKtWaP6VgY8PC90SW4kG27JDkVVs3HlOogjsXkbJg8aj8?=
 =?us-ascii?Q?nOTUIVHk6n965pjVUIxzp3GjW7bOPYfcV5iX0AgKUbk8IB9/P3cx0VL+ncP+?=
 =?us-ascii?Q?0REZMHvXeOIxEDDjfcgHdLvln0c1+L4ST1oAlvmPI1MbSmkKztkxrW+Vg7GS?=
 =?us-ascii?Q?WCv5ZK8s3P6EO93NWUd4rIAPzh/KCpigVZ/Wxx+CkbNSLt2U6fStR7T/cGle?=
 =?us-ascii?Q?qqPeSp4MkPmbILJMsWoTQUFjKrmyTTHUlFqWJaiqPBFCpBOgum16Kwrk85FP?=
 =?us-ascii?Q?wnJTcwLmbntf0I1gdAkKDuHFb5gJpY/mV7x0SBnSGgHdLtyWE+JRmuhOIGh8?=
 =?us-ascii?Q?m8qpTdM2N3itl0DDe8Jqn0YDYn6Em1wtEIyvDv46LS2ouVgJTzQNhB7Ggrq5?=
 =?us-ascii?Q?jgYmKVKrNOQhInr7Y0Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c631d5b3-4b67-4149-1ac2-08dd454aa3ef
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 18:35:03.8461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GbtKUu06T7BBiQHyr5Lr8ngF0vQQz1v6jtF4HaTsqWvcGI4K4pzLqcLb3zyEoloP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6573

Change the internal freelist to use struct iommu_pages_list.

riscv uses this page list to free page table levels that are replaced
with leaf ptes.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/riscv/iommu.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index 6e7df7273426da..549bd8d0615d75 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1085,7 +1085,8 @@ static void riscv_iommu_iotlb_sync(struct iommu_domain *iommu_domain,
 #define _io_pte_entry(pn, prot)	((_PAGE_PFN_MASK & ((pn) << _PAGE_PFN_SHIFT)) | (prot))
 
 static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
-				 unsigned long pte, struct list_head *freelist)
+				 unsigned long pte,
+				 struct iommu_pages_list *freelist)
 {
 	unsigned long *ptr;
 	int i;
@@ -1103,7 +1104,7 @@ static void riscv_iommu_pte_free(struct riscv_iommu_domain *domain,
 	}
 
 	if (freelist)
-		list_add_tail(&virt_to_page(ptr)->lru, freelist);
+		iommu_pages_list_add(freelist, ptr);
 	else
 		iommu_free_page(ptr);
 }
@@ -1192,7 +1193,7 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 	unsigned long *ptr;
 	unsigned long pte, old, pte_prot;
 	int rc = 0;
-	LIST_HEAD(freelist);
+	struct iommu_pages_list freelist = IOMMU_PAGES_LIST_INIT(freelist);
 
 	if (!(prot & IOMMU_WRITE))
 		pte_prot = _PAGE_BASE | _PAGE_READ;
@@ -1223,7 +1224,7 @@ static int riscv_iommu_map_pages(struct iommu_domain *iommu_domain,
 
 	*mapped = size;
 
-	if (!list_empty(&freelist)) {
+	if (!iommu_pages_list_empty(&freelist)) {
 		/*
 		 * In 1.0 spec version, the smallest scope we can use to
 		 * invalidate all levels of page table (i.e. leaf and non-leaf)
-- 
2.43.0

