Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE293238155;
	Tue,  8 Apr 2025 16:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744131270; cv=fail; b=Nxo0kSWGIeqUS4g/06GnRMhE/YJQrwwrrJqSb3Xc58MNa8QXXsqnTPPegjyeEhrdr5JNZzJKhDE1G9Aifvub8iBCJkl8lNvWleMYo5YmiuYDApgz08ELWMKbNWmVZQSdXwuJARWw/eGWAbBT7uylXK+oQvxlPkPXRBpC2XlxEhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744131270; c=relaxed/simple;
	bh=2qdxGaG+HZr7cfZYTfxCHJMlIZiKttZiC50ABGltvcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eBK9vHKC29Cc2yMfKTWVF5wW31fTSn56wucWMpmj6aG/MbsWoQR8ZjS3TdN3p6gk/COVA2k+oTDzHjRkvScVzACz9X+nbzvdopmgfJYZovzwJS76e0R9FsfrnjrxPcbnU32IbuI7eAI6TfulJGhvKqtknZaqXb9E5iEiJeOTuoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T728knmC; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T728knmC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d5l2NT1rI6NrOzzGGM+HQDPUBbGr+bxGPPcGO/grpnpNyJ2eyMwA9xpkIkkQgzQlqA18n3vqh/uQApVHeTSTm/BATbA3WYFQ2T76JFy/zGcHF4ug1GEt8KdrFk/VNNcmPDHaYvL2pBj6RWIJUg0QPkV0//JBmr+1Iyj48jBiY1xuXcnnn0iG91d7TTCoPJyyGo/o2HvAb9SdIYbtDrORZHxZE/k16DrBSQI/mZWAC7IWRtW75/OTUS5Dh4tfAnMTZGLYeU+KwWyaTgz1AUzBS6eKxp1T42qDUKvApOlA7D0AgVuqaO0exwBFL94CLzApWi7gNOc+973FeCxNcuECow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T3u7AsFxB746z0bYN8M2y9aXb/pCnGPljTmYm951kXU=;
 b=nDCuxQvQ83VcHibFb61eLBdhjzUeJ3DIjADKWjjdrLJln4fRFvK5r4gbF7hJICfU+RaZaCcUZOR/o+bCUaZegHgTS1MugYJ6VzkNz5x+/6bNiV5En32zhliNUA6URLHcO2K2qXOvz8hYKVJARmW8Z8XG8gV1rzcXxCUs5gGmqvV2BduhT1i17dmsPLK/Qen7SnN0FEjV1ObYOZjplifkWzBQ66y1Pa42pQYuB/nKrNAzFsRzt2ifjdjxapXgZtf2OuLLqzMxwf99J23N913OGFblHkDxKmsUxk6a+zML0tiW/6IY+GGBY/XMTWsK0J0LyFdAfyI3kLCDpDO7EqIeHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T3u7AsFxB746z0bYN8M2y9aXb/pCnGPljTmYm951kXU=;
 b=T728knmCmvjX5Zh1h04H36FO7XFigbxZil4zJcFxcSx1pe4of3CmPRXVX6KHohq2KNkb3uiXhvV1HHEccU38WhiDucPKJy4x+UIwWE6VCbQMLUqsZZmvKUKk42jir7G1sR8+A+nDaPNiZYR2BQ5lqKwbiNWZ8IdB3qBAvq1cfhe9cDNS2FLulPmOwTWt6ctoSo0yu9/7R//vEEHenX98+o0N7u4+X8ODboTkibWCIxzqXqTPW8R3B4M04yJ7SdBQ6nT54ALDlxYhBgCy7K/9AXMBrwcMl5k8+LhJAgKiDgpsn3ObuKFtsfwbwmpLCb6HDQpFIatvcyviVEkFjSLSSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8001.namprd12.prod.outlook.com (2603:10b6:806:340::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Tue, 8 Apr
 2025 16:54:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8606.028; Tue, 8 Apr 2025
 16:54:23 +0000
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
Subject: [PATCH v4 15/23] iommu/pages: Allow sub page sizes to be passed into the allocator
Date: Tue,  8 Apr 2025 13:54:03 -0300
Message-ID: <15-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
In-Reply-To: <0-v4-c8663abbb606+3f7-iommu_pages_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR15CA0062.namprd15.prod.outlook.com
 (2603:10b6:208:237::31) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8001:EE_
X-MS-Office365-Filtering-Correlation-Id: ba9976d4-8768-4b62-a0f0-08dd76bdff71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A0XgeSTq3xTq5knkPYkOo40mcqqXlwYCjj7W87se6lrJ+TPU53bSabOiuynI?=
 =?us-ascii?Q?lUV+auOKmedoXTrxYRNZfw3DpTk4rsW1KOtsqvhQC/qFzANYrZmcJG5EUYCr?=
 =?us-ascii?Q?8L9V86B3EQDBmrVDb2WMIV6iTFfqHfYN/BI+T/vUdYHh4jce+1Ego1VkvhB/?=
 =?us-ascii?Q?mTGfbtsv4Lt4JRnf7ooziOlIjq/Wo3kj256KjJbvVdFrxmLSoQfTPlJOYuje?=
 =?us-ascii?Q?0bt//XFwm0BBVtxUfioJaKi/rZicULHFhFnzgjnLFOy6L+PRmL5IYfjHY0ro?=
 =?us-ascii?Q?guBplFrKSEAA88JViOa8BrLDFBHV9erk5Je8tKJV/ijP5Fz1Jarfilk9Wi6T?=
 =?us-ascii?Q?Yu1mytvt8glHZdYgPqJJmg4zj24GzUIT9inHhWkWuaWyP8SRnKiN6I44usPj?=
 =?us-ascii?Q?To4YRTz9P7TQ+MK3AkV/XvmtcKiQDqgq8hVNJvqe5HhB3HgYW/sEmTeY6yNq?=
 =?us-ascii?Q?iSQvX7k+ePs4ssgMKUmyFP+AjG8h2Q82kiz4s64V3MPv8VC/XZXr7byxedCK?=
 =?us-ascii?Q?e7CZXBqCKuau+uNW2R/m6mYCY9HWElMjFWWsYh3BRG8G+1cgTHuA+sGy5mPo?=
 =?us-ascii?Q?q/ll4Njr6ZaHPY9Pd9KzxeSJ/hZTfCvLUcHGjVk/n9WNHwYboSPmuEM18w1n?=
 =?us-ascii?Q?+0nKkGQqqSNc9bzdLdJDMD3bBW7T5OsUObXeQNQMY9174xpTKX1b94x2jn2l?=
 =?us-ascii?Q?Vmo9b5kRxYc02dP7lUPHhmVDnbM7L4RqMa2wCUthS2CAXz5/gVRaDvnqfmpv?=
 =?us-ascii?Q?m2maPc5nRX5VHBMbyuTeOTKRNlCi61OYfHlPa2SL0NaXEFFPV4KkJXZfm6/w?=
 =?us-ascii?Q?0pDLD8gTXodmSvCw9aqqj4ELIxy3nPApSsg1v9z/7OttG3By46U9jbUlIZit?=
 =?us-ascii?Q?ntFyGJWgfXxNjB1rc/F+IVGSO2Zvmhh1Dqu8/KgwH5tQUO/bcy/FDwMooAsg?=
 =?us-ascii?Q?8TbluGr3JUaULjogMipXjuIr6U0CHaoxNYTE7UdjMpw3YRXSLYPtmQ23Giwb?=
 =?us-ascii?Q?DX6pz5C0PM6GzjYqkqYgve+CzlV+Vm3Lzmk3XHuEtLciUiS1ea3ZoZJcZPcP?=
 =?us-ascii?Q?8W3VBBXNejHPcOL0YVVPgU5Hlq5dAxOuqQBQ6mteRSKCRMXa35HwfAehrNUh?=
 =?us-ascii?Q?r6uVyevsmnnx2Cts2AtJQfyuedeE+oVCyRlZ6LdC1B9h48FrIc/BFLcGD/m2?=
 =?us-ascii?Q?S7FhDwSwVlL/gtEcAbn6WHH2o1FB/2EGnYZrP/p55tsjYLB01fcyn2e6w4l4?=
 =?us-ascii?Q?XH6X4t/B8tBLz8XKtqgujPIkZKe4I9XRZWRl99aDVVgrR3sCu3l4GGhNrsMQ?=
 =?us-ascii?Q?+VAetrKZk7hTP/eVH3hxmtGR23uy/XpbdxDgfJKYy++AZEYAbFl2yNhPdJlx?=
 =?us-ascii?Q?fkuGFEkGwLX+KUP+9b4LdynJJUq/oDD6h933Su2eXaAu9NQ1PfVHtVXbac5U?=
 =?us-ascii?Q?ra7YkY8JZv9H7MkPGCIYWOtPPP8IrWo+2LQ3zQGxr+mykGWpXUPeYw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9+RjPH+gwmC2zHmZQQR/SJKCQszWlP4pmM6HPCGVFiKkeaMd4WLCJvW+QI37?=
 =?us-ascii?Q?fUHWVmNbMC3e5lBT/FaBpe5LWak6qMgEhf9L2r6afMtBW8fwAW01psYPlKsq?=
 =?us-ascii?Q?YrpYL6aZ9u3La5ulHiPyNsGAn1KRj2v4K/FObncholIjwrrTjohdMQfXq68X?=
 =?us-ascii?Q?j0Ie4vQroqSzQY8TysBqhP9jIAM3RgVI8OnktXbblYn7IyTYxANAjIAtALia?=
 =?us-ascii?Q?qtWQkm3tBygC8MfJco9+50wNvJHbNCczZi/2XBYudJqcPSQ/wQoxNsY8LrSr?=
 =?us-ascii?Q?SdEUmu0ReOpKyeCbpKsaF6ap64KCQy8GR0sAJkIvnIGww+eCJdNMk3ppc3gZ?=
 =?us-ascii?Q?DFWdR0wgHBIVn4EvVMPFW+KFCPRpm3VSlu4QmkhlXPaqOH+8H+30buIrXRws?=
 =?us-ascii?Q?hrVKoI/fHpyI5OJuasrDyJX0fYj3D+zFJkos4mVELrQ2Vsoy3H50ItdWFSVS?=
 =?us-ascii?Q?xtXjbPJP/ELlQ389Hm7qzWz1R5MjCeEIL25NKwxydFiIwCFRjpyXiZP6nsph?=
 =?us-ascii?Q?Qr/mXIfhNAcI+W/fX3VRhkxFlUd973BWdfQtf8b71gBEpyNfLhwgGk43Vwiu?=
 =?us-ascii?Q?IQiv0TdNbAumhSFbtavPFEVxd7iMy3vOREGu0BzOYBuEs/b2H+H8vPGj3v6m?=
 =?us-ascii?Q?k5+PkX5SZR786qSVBYL2MzWjyAyi5tYInm3tp8VHmN0w0U+yJh98xc6Ve7O3?=
 =?us-ascii?Q?MKJkjcPOeWt2hch6CdcbVnq17h3YTldlflifgbY/GOaphIZt2sA0PHwWPoh9?=
 =?us-ascii?Q?WXXEsErNmzcAIbjDeCBM7zuUPxRg9AHfU8O4JD9+ZjkxdLho0UF42w/Z04kX?=
 =?us-ascii?Q?RE25PcjHGDJkSlpcJq8xkxESliVWTfkgxP4PGjzCmeSO3hmQE9Lz4cpvbwKU?=
 =?us-ascii?Q?AVXTaI3Jui/brOTYnxJSQ+sQXBk8Ftl61YrthRpXYTSTmhn19uEPXanGS9Cv?=
 =?us-ascii?Q?ZqqYAm59jUuxinanKpPo813zJ0zW6dIpQiMJri1OGI6PyCiP/3/wcMtBLgrb?=
 =?us-ascii?Q?YFjWs5fHcs7EySJhf5E/UaQw6WhK+x9uCwWRJrA/vES2MEK6yyxChCVgSYKR?=
 =?us-ascii?Q?L1/zJyuBlJv69YyAUXeLm38aCTtQeq2uiTOgFC6rwt6GHm/J3L7bHLfmabHY?=
 =?us-ascii?Q?aDnccAgCuuQ3BwKSVDt8SShbgZgqiUPz9iscpVBRpRVoPN4lackLqrxdYb0/?=
 =?us-ascii?Q?sZCuaovF3yPvimnuLkvj5HZuMRvtzDc7IFEabg5tXKXGQ7lkrm4xiIvgSrSm?=
 =?us-ascii?Q?673WKMEb7yDX9TN0xOWinoQqq2sGx1StpbX3SCXvdMNknI1u2xXMbYCrlz2k?=
 =?us-ascii?Q?Hf3gWBdYd/yS8IWyZoY4mZRz6V7w30LoHVXUyI7ZeD6KKoRUMrEWwlJrtIuM?=
 =?us-ascii?Q?B1+glA8EQrYZquVf0T30dPZyZLFPCXlefZZ3gmAgVM2XmUWAainQCtCMgZDG?=
 =?us-ascii?Q?jWcfMmzYW8oto0dYl3DZ8XX8qkhvnxEAZq6ohIP9c4U9fbTBV4MYL34eM66E?=
 =?us-ascii?Q?byccpHS6it5C4IRssH7260rmdKqYhPEeYCyIJEF7tg+CJdgI5x6NIUmtfOhv?=
 =?us-ascii?Q?NpBxCRjG7igdVzAGflkuOMnMwj9paBRJICxLuT1f?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba9976d4-8768-4b62-a0f0-08dd76bdff71
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2025 16:54:16.8280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7BJby5vuJxYjPgnRbe8kuDgwb2mu5PaHsMuujE9vS8MSrl3nkGvFoPSRnK8n84xG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8001

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

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Tested-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/iommu-pages.c | 29 +++++++++++++++---------
 drivers/iommu/iommu-pages.h | 44 ++++++++++++++++++++++++++++++++-----
 include/linux/iommu.h       |  6 ++---
 3 files changed, 61 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/iommu-pages.c b/drivers/iommu/iommu-pages.c
index a7eed09420a231..4cc77fddfeeb47 100644
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
- * freed either by calling iommu_free_pages() or via iommu_put_pages_list().
+ * Returns the virtual address of the allocated page. The page must be freed
+ * either by calling iommu_free_pages() or via iommu_put_pages_list(). The
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
 
 static void __iommu_free_desc(struct ioptdesc *iopt)
 {
@@ -82,7 +91,7 @@ static void __iommu_free_desc(struct ioptdesc *iopt)
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
index 3fb62165db1992..062818b518221f 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -342,9 +342,9 @@ typedef unsigned int ioasid_t;
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

