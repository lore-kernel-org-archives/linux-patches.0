Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A72268C7E;
	Fri, 14 Feb 2025 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739552910; cv=fail; b=eHF24RfTZ0iyYdnzOPWDOj/nNuAvRuWxDZF25jfJW7QMiyu3xHRtHhUXGSyG8MBL6ACAzzkMQFHKgE3onA0MSSocPXQpUHUR8Cwc89zA6ZNShPpe6fW6zwy3Ew8k+dswwRN2Q9JXbdE+7/yUKamoRsPJPw2hX7Hl4wc+QWrK1H0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739552910; c=relaxed/simple;
	bh=g2kNsYOnPN6XKJx8tQ3CbBmwzgccXIxJayPqLhXr2Gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tA4rWqpNSLt/16AVSQ8nbTvQWWKSLRzV3MahOMnxiEHZq99cIBc2BcVj8h/WYBmbTzpUTthjhLDBArqFOOU+0NYxv4o2Wm/cU5TisUV5Wa5B8SHhmbblJ1tjIOFx5xumX29h8YTxZZvLc3l/19PYH9gbK9NDoAwGrb4h0hwm0xI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Muk7eDeE; arc=fail smtp.client-ip=40.107.237.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Muk7eDeE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q3XSqcgKb5SuaFo5pTmRb5UUmGYAGU84MnpljStwvxLuEwaayGf6bX/LtUjrYAR+E47XxOmvH30VMq3gezyvVyTLAnbjoshQ3AHdp2UXuE4c67aWzjr9BKIoWvDUuvZrgFza0WJtgQK5Gpl5teNE3t0vsRB7Yndk4T6JmIS89uc+eX8zTHLhPau2+RbdZM8TA+npFUoh/kkOEg/xF6njqFFh3MW+inTXXxifLMsgKw6piYSin30/3Ee+wzrtGw2JfIG1t0y2TeauYSjaItABIrlYQxHDXMtGnvrPx2g0u0pifen7ffqIotlKDSnj4u6guTbvVCA6L3OuG9+S2fYLNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qZZU0z84bQbXb9QrZHUYkGWiEuo7c48yiDBi1O4KPts=;
 b=zJoR12gkEZDfsU6o25xGsj1dDSDziqI/agehLd3AupklE/XhAKmO802wE29HgVYuUQLF/qE+Hjwr+qI1P77WR2sZKu7ppgQQ7HSQroEiuKPCH3Xj4xRZqq6xRw9yzofNQpzUGlSz6R0fa0xsWHo554K941ErKiX5pw7Zw9dRSP83lM+8NrABudavDM8EPYKcysLcnxs2lbIqpdQyi3VNzOTUxqaY7B6EzAR83kxoBzhYbXoF7hxE2jKyviSb3xFT2VLPHIpOlPVEWzuxdGVh1dOIhEGFf7ZJqqLISX+9R0VcI4wL0BsiPC86J7XDUHLRfxOeJjtJF4RH7Hxq5DuILw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qZZU0z84bQbXb9QrZHUYkGWiEuo7c48yiDBi1O4KPts=;
 b=Muk7eDeEVDEIl7qx5/SQstpG7emhd518Ut8HVPIZPynpvTrE/1LpbTvkN9ShcABBKBkY23qYSdoBTyYVbAEXS8sFwVnhBZn27X/iOMeGaCR/JrjylMNJYuW91y1BNjPvIgDHGrrNRpCl2AlHwgODZ/58IN2IxaWrApW7rCv+8mMG7kGerTLNWuXkbJ+2DXY5Nxo8j4ALsNI7JN6txHe5Gb9FqS9narVm7bwAZHyJf7e2wtR0cUi6E16vqaFdBvqeTOdTe3FUYQxCnuSpT85LSCBLsN9eFmRMY1UTraoBMys4juYn6TEZ/RbhiizUSncuevYI80ChmuMW4seS+CbYNQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB9175.namprd12.prod.outlook.com (2603:10b6:510:2e6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.15; Fri, 14 Feb
 2025 17:08:16 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%6]) with mapi id 15.20.8445.013; Fri, 14 Feb 2025
 17:08:16 +0000
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
Subject: [PATCH v2 16/23] iommu/pages: Allow sub page sizes to be passed into the allocator
Date: Fri, 14 Feb 2025 13:07:49 -0400
Message-ID: <16-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v2-545d29711869+a76b5-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0029.namprd14.prod.outlook.com
 (2603:10b6:208:23e::34) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB9175:EE_
X-MS-Office365-Filtering-Correlation-Id: d066f1a4-bf42-46bd-8b01-08dd4d1a2329
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zDCFRhiypnyIL+upunc32C1WqC6+jM0ib/XWdpBH48icFRFZnbDJnN79besI?=
 =?us-ascii?Q?feqHcab0LrmPVwuWTSKWuo5NMZFs5gPW9Fu28Mc/D7dzmoEuYqEedTT++x05?=
 =?us-ascii?Q?kaRc472DfVzLpDMgnegaqMDYyKUzI8yImToHApy566mKITCV1fh5m+VelpxJ?=
 =?us-ascii?Q?6v4wJVn3Ulu0K83cKRgYwP6xpjhC4zJQhR8dRBATkLCDgZHy0cXRJuKct2Xm?=
 =?us-ascii?Q?2l6/JiL1mW+jXFpWCpNWxouoC4BRXNjbDmEV3+pZu4M6Cp9HXBU0ODC1j2U2?=
 =?us-ascii?Q?WQNpRT1BZd+DYlqUV0ZLTJU/surFMcIfLKYlJpdAaSZqx702kzswZGO5rpie?=
 =?us-ascii?Q?Ok25QV1K32mBFnpOYo0T4q4IunemgreNNH8OF2FIDEuoQo7OgoWg1kkSwWOD?=
 =?us-ascii?Q?nh+VNeu+D0qpfX6w62z6TH917Sbd/gygAu8zK2TzKZvggnAiNoOjWpY9P8cO?=
 =?us-ascii?Q?0qDQB96IEnvA1cWdxPyGLYAwjxEqZDBu/NI4Dn5U1blLBYYQh6tpsQJIWKvV?=
 =?us-ascii?Q?ftYqRrdDgEvT/0xrh5SZ97OESQUkZAdKn1IfWjM1ZfXq4wLy8ve9YBzOMwgX?=
 =?us-ascii?Q?pxq0oje8EVae+9RuG5lxnGW3eCqUUTiCeUDJlnHzGRXQoLDdRqEE/W9vEMp9?=
 =?us-ascii?Q?Oy+KuUAjA0zyOMPGwBzHyq+2oPBGlK5TTX91Dt1pSS9JvTGaDcxaag7fNGGw?=
 =?us-ascii?Q?0DHmBsr4UNZ0RdggdR4Xyn53IE3gXaZor33TcAyf49PUYZrcgc0ggweTfYIo?=
 =?us-ascii?Q?00MS3cbe4L7BGkF/ZNs0E4BA2eHeRm4DWcMBTIDNsvVkDgYiXXCoGez1hZ+q?=
 =?us-ascii?Q?HBEA+kc7BgEKjkfEmJU357jPjM/OojS1nAVtMEU7/0fGevasi/AewhcNsz8K?=
 =?us-ascii?Q?5nQwzZe9G/88Ix2hBtTjvgAhg65IqUTO0MqLlh1UJ0s8No+PQJy4YUiHGm66?=
 =?us-ascii?Q?OqPTxSJjraiCcivDhMUTwYVv86YZCDvQuYk4awiBkHa1yXy5WvGNGm/vE1pj?=
 =?us-ascii?Q?TrVqGKAtMWZbwCJJmk0Bb/OZUEzOF3XnNl+iAUdji5ePtGN1cS2DyJJacK/A?=
 =?us-ascii?Q?8f3U6n1oy79+lwyaMv+N8O6Hb2KU8sj/AIutli67uo7zscX2YEgbuJ3+LLzO?=
 =?us-ascii?Q?LUuGPgmxt+cGlpzxvRUvlVE695bG1c6rQZKPR0SfjEka6GzrcTS0aur0bkxW?=
 =?us-ascii?Q?+ve8p4T7uRO3stXa7eJXMjayX4ifoTBiUTM4hVRS5ry1LSfSoTeOyJ205Q6O?=
 =?us-ascii?Q?vlvCbLB2/DRSI2ywZ8BbSUPM/UnpWm4EUf8pSp8AxpmYKQAg/4uslyOW5gx4?=
 =?us-ascii?Q?T0C2XDK480u/frfK3Hrf2GcbLz3RzxijDkLW8VARcUzpXra77rgLZntXCLf+?=
 =?us-ascii?Q?BR23kJutxhhpQ9EfV/UONPOCQIVnu/t7gJmgYELk1FCgkp3D9IKI6DgSyQZi?=
 =?us-ascii?Q?rIMsurnsxQk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fCysqJkV9UBf5sdd0/F3keeHHWSmUAzeEc20KHq+yI1lcceX840YwRuHUwaj?=
 =?us-ascii?Q?Ah4GsFq9yLOQm+y7OJ9B7Dx2P3Txbcej7jGPZY5oSWdZk+WLf45UraelufZy?=
 =?us-ascii?Q?s/Apg5V0Y1wRbCxxjwaW67TwrFPS7zhRC1MKTYWSFa7RHhW5zpg531GqT8yw?=
 =?us-ascii?Q?HRItJP1Aq2hRDJiiYHaUIItHfNCsFuMRlJl12FriMMSb/BzOl4SX8W/Ebvl2?=
 =?us-ascii?Q?M1+BwzAht9uAcItvH2U5MigVH2VWWtdr+2TyfpmnWjjHdtaFir0NgEPonokL?=
 =?us-ascii?Q?i1Jt/ZGkapFtJ3fGMf3NwhGA31L/IvUUgpWxN2i9BF85LTeBQumW1FXHG/W4?=
 =?us-ascii?Q?LL2+4pxqX1TjKgP9VOfVRMTfayRKGdCzPm9IUs1+e+YrFzDPXsZnW+NHc4fh?=
 =?us-ascii?Q?+fu8HTawRdC5bH5GnghIuesSK44ZWjuDzAJNpc7ajESCMuU5z2h3Avu5vLbl?=
 =?us-ascii?Q?7zrmm2PV5IOGBNVuMa+hjVbh/WuJ14s+a63VD4SkpJaos35aMCGsV9EgzgWE?=
 =?us-ascii?Q?YFDIlejOuuupBKxub93qyLaxXVg8/2+W3uldh/WqlXfNnAkKTkTBASylKRcf?=
 =?us-ascii?Q?IdVn4osH3HMcAHG0q5fGGyJpf3OIoEABeq4xFWIDprsNpUY60vKc63HuFuLy?=
 =?us-ascii?Q?R77OPIBKRjqLLIM2LtX6SDr/SVrcUf01XSun2qTbrvqwjuR4UcztboeCMAj3?=
 =?us-ascii?Q?Ghf17eslyf27EVicUIgYKk4cAy4bFqP/0FIW/DoAnGjTFR/T7Ohbum6M4/S3?=
 =?us-ascii?Q?3+Hh71z0m/jzfCdkz4WZs9BBF7lsLTQ7gUazKmcLqWt+k8HJLAKlCmOTlfbA?=
 =?us-ascii?Q?/o/NAXPRefDD+8yfoa7he+q0Kep1gkHiIdXMq0dyZeJXZLTQTvprR+mZ7j6q?=
 =?us-ascii?Q?z240O9OkyLTiIeRhiw6h3XLiIX2C9dzYMi8Hp5UtiEFtlq4ayDYwDnqN9lWb?=
 =?us-ascii?Q?/W/HmtBLX2maW8jnQ404KbZLe5nT0obR5nssemo8mgTjCQC/P0C+/PqOM+KW?=
 =?us-ascii?Q?5GblhJqKRAhJQXH4Gufi1LImHOFka1VSFVnohNGXAE8tzRlu4KG9hHDBsEnL?=
 =?us-ascii?Q?PdNKZj1N918T/cYK8wCt9q/8P/qoxr8k6XKtp8c+sCmioWxtN3/BxBnO5g8y?=
 =?us-ascii?Q?blYVv6JIyjunCbRrI8XfjLvHRNotnOMALTNhYM3DJ4eMXKz8WNrhI8VM3Pqq?=
 =?us-ascii?Q?/pjXuSa4W8Z25skAYXTm5Ev4T5MtEL1LsXq/TwH9iIgEOQ2/VH5/ky6DvCF9?=
 =?us-ascii?Q?LW9MzO3Or2bppMfZOf09e53GbGXp1VY2k1WAxo8uGmHmSgnqaELasboELRod?=
 =?us-ascii?Q?RkHj4xLh876dy+U5awJ6YJrsx+ejvYxiRo721KdzQer1y0mxKb5NBLFsVRZr?=
 =?us-ascii?Q?7CgmDEPI/c00X7+TVzjA6gDrodDkwGNZfHRd0Pz6QvWjEg7Glynhu5poiVYi?=
 =?us-ascii?Q?/aYL3TmC4o997CPJb+uNyeqVCODCIZ06xyyX4A6I5ll6dPHf9E7IAtB6lxNC?=
 =?us-ascii?Q?O3zNV8GLza9MdkUkCNoVDtkyy14599aDSCc5fmQKmTMq69lW0rWDNLpfbsZ9?=
 =?us-ascii?Q?f8HZSYrzslQvEN/CnPE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d066f1a4-bf42-46bd-8b01-08dd4d1a2329
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2025 17:08:01.4015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P2lbqZayQpbLCTsK4iAmSRbMaZrKHlRjImdlYanSLF/iZFLUJfXQxayRoGum2neP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9175

Generally drivers have a specific idea what their HW structure size should
be. In a lot of cases this is related to PAGE_SIZE, but not always. ARM64,
for example, allows a 4K IO page table size on a 64K CPU page table
system.

Currently we don't have any good support for sub page allocations, but
make the API accommodate this by accepting a sub page size from the caller
and rounding up internally.

This is done by moving away from order as the size input and using size:
  size == 1 << (order + PAGE_SHIFT)

Following patches convert drivers away from using order and try to specify
allocation sizes independent of PAGE_SIZE.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 29 +++++++++++++++---------
 drivers/iommu/iommu-pages.h | 44 ++++++++++++++++++++++++++++++++-----
 include/linux/iommu.h       |  6 ++---
 3 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index 0369f0d51c3412..4637eeb80254c7 100644
--- a/drivers/iommu/iommu-pages.c
+++ b/drivers/iommu/iommu-pages.c
@@ -23,24 +23,32 @@ IOPTDESC_MATCH(memcg_data, memcg_data);
 static_assert(sizeof(struct ioptdesc) <= sizeof(struct page));
 
 /**
- * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
- *                          specific NUMA node
+ * iommu_alloc_pages_node_sz - Allocate a zeroed page of a given size from
+ *                             specific NUMA node
  * @nid: memory NUMA node id
  * @gfp: buddy allocator flags
- * @order: page order
+ * @size: Memory size to allocate, rounded up to a power of 2
  *
- * Returns the virtual address of the allocated page. The page must be
- * freed either by calling iommu_free_page() or via iommu_put_pages_list().
+ * Returns the virtual address of the allocated page. The page must be freed
+ * either by calling iommu_free_page() or via iommu_put_pages_list(). The
+ * returned allocation is round_up_pow_two(size) big, and is physically aligned
+ * to its size.
  */
-void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
+void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
 {
-	const unsigned long pgcnt = 1UL << order;
+	unsigned long pgcnt;
 	struct folio *folio;
+	unsigned int order;
 
 	/* This uses page_address() on the memory. */
 	if (WARN_ON(gfp & __GFP_HIGHMEM))
 		return NULL;
 
+	/*
+	 * Currently sub page allocations result in a full page being returned.
+	 */
+	order = get_order(size);
+
 	/*
 	 * __folio_alloc_node() does not handle NUMA_NO_NODE like
 	 * alloc_pages_node() did.
@@ -61,12 +69,13 @@ void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order)
 	 * This is necessary for the proper accounting as IOMMU state can be
 	 * rather large, i.e. multiple gigabytes in size.
 	 */
+	pgcnt = 1UL << order;
 	mod_node_page_state(folio_pgdat(folio), NR_IOMMU_PAGES, pgcnt);
 	lruvec_stat_mod_folio(folio, NR_SECONDARY_PAGETABLE, pgcnt);
 
 	return folio_address(folio);
 }
-EXPORT_SYMBOL_GPL(iommu_alloc_pages_node);
+EXPORT_SYMBOL_GPL(iommu_alloc_pages_node_sz);
 
 static void __iommu_free_page(struct ioptdesc *iopt)
 {
@@ -82,7 +91,7 @@ static void __iommu_free_page(struct ioptdesc *iopt)
  * iommu_free_pages - free pages
  * @virt: virtual address of the page to be freed.
  *
- * The page must have have been allocated by iommu_alloc_pages_node()
+ * The page must have have been allocated by iommu_alloc_pages_node_sz()
  */
 void iommu_free_pages(void *virt)
 {
@@ -96,7 +105,7 @@ EXPORT_SYMBOL_GPL(iommu_free_pages);
  * iommu_put_pages_list - free a list of pages.
  * @list: The list of pages to be freed
  *
- * Frees a list of pages allocated by iommu_alloc_pages_node().
+ * Frees a list of pages allocated by iommu_alloc_pages_node_sz().
  */
 void iommu_put_pages_list(struct iommu_pages_list *list)
 {
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index f4578f252e2580..3c4575d637da6d 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -46,14 +46,14 @@ static inline struct ioptdesc *virt_to_ioptdesc(void *virt)
 	return folio_ioptdesc(virt_to_folio(virt));
 }
 
-void *iommu_alloc_pages_node(int nid, gfp_t gfp, unsigned int order);
+void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size);
 void iommu_free_pages(void *virt);
 void iommu_put_pages_list(struct iommu_pages_list *list);
 
 /**
  * iommu_pages_list_add - add the page to a iommu_pages_list
  * @list: List to add the page to
- * @virt: Address returned from iommu_alloc_pages_node()
+ * @virt: Address returned from iommu_alloc_pages_node_sz()
  */
 static inline void iommu_pages_list_add(struct iommu_pages_list *list,
 					void *virt)
@@ -84,16 +84,48 @@ static inline bool iommu_pages_list_empty(struct iommu_pages_list *list)
 	return list_empty(&list->pages);
 }
 
+/**
+ * iommu_alloc_pages_node - Allocate a zeroed page of a given order from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @order: page order
+ *
+ * Returns the virtual address of the allocated page.
+ * Prefer to use iommu_alloc_pages_node_lg2()
+ */
+static inline void *iommu_alloc_pages_node(int nid, gfp_t gfp,
+					   unsigned int order)
+{
+	return iommu_alloc_pages_node_sz(nid, gfp, 1 << (order + PAGE_SHIFT));
+}
+
 /**
  * iommu_alloc_pages - allocate a zeroed page of a given order
  * @gfp: buddy allocator flags
  * @order: page order
  *
  * returns the virtual address of the allocated page
+ * Prefer to use iommu_alloc_pages_lg2()
  */
 static inline void *iommu_alloc_pages(gfp_t gfp, int order)
 {
-	return iommu_alloc_pages_node(NUMA_NO_NODE, gfp, order);
+	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp,
+					 1 << (order + PAGE_SHIFT));
+}
+
+/**
+ * iommu_alloc_pages_sz - Allocate a zeroed page of a given size from
+ *                          specific NUMA node
+ * @nid: memory NUMA node id
+ * @gfp: buddy allocator flags
+ * @size: Memory size to allocate, this is rounded up to a power of 2
+ *
+ * Returns the virtual address of the allocated page.
+ */
+static inline void *iommu_alloc_pages_sz(gfp_t gfp, size_t size)
+{
+	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, size);
 }
 
 /**
@@ -102,10 +134,11 @@ static inline void *iommu_alloc_pages(gfp_t gfp, int order)
  * @gfp: buddy allocator flags
  *
  * returns the virtual address of the allocated page
+ * Prefer to use iommu_alloc_pages_node_lg2()
  */
 static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
 {
-	return iommu_alloc_pages_node(nid, gfp, 0);
+	return iommu_alloc_pages_node_sz(nid, gfp, PAGE_SIZE);
 }
 
 /**
@@ -113,10 +146,11 @@ static inline void *iommu_alloc_page_node(int nid, gfp_t gfp)
  * @gfp: buddy allocator flags
  *
  * returns the virtual address of the allocated page
+ * Prefer to use iommu_alloc_pages_lg2()
  */
 static inline void *iommu_alloc_page(gfp_t gfp)
 {
-	return iommu_alloc_pages_node(NUMA_NO_NODE, gfp, 0);
+	return iommu_alloc_pages_node_sz(NUMA_NO_NODE, gfp, PAGE_SIZE);
 }
 
 #endif	/* __IOMMU_PAGES_H */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 166d8e1bcb100d..b74c9f3dbcce1d 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -327,9 +327,9 @@ typedef unsigned int ioasid_t;
 #define IOMMU_DIRTY_NO_CLEAR (1 << 0)
 
 /*
- * Pages allocated through iommu_alloc_pages_node() can be placed on this list
- * using iommu_pages_list_add(). Note: ONLY pages from iommu_alloc_pages_node()
- * can be used this way!
+ * Pages allocated through iommu_alloc_pages_node_sz() can be placed on this
+ * list using iommu_pages_list_add(). Note: ONLY pages from
+ * iommu_alloc_pages_node_sz() can be used this way!
  */
 struct iommu_pages_list {
 	struct list_head pages;
-- 
2.43.0

