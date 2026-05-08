Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012018.outbound.protection.outlook.com [52.101.48.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AD63F6609;
	Fri,  8 May 2026 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778251999; cv=fail; b=GmCbbyBXJtNDb5kCC3d4/z1dytoEPkYeK9S+eLaOOstYnsY+8Os624QMkzmdyvN7yFgIh17tfh9EBpOphB+f5YFWRmX1HQ7GGLCyI6lVaZy9EhH30DvtFk04fOJYWl2bo1YypWA0s5Z+hi6kPtbHTj/bALNs80u3Hr7ABJBdCtc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778251999; c=relaxed/simple;
	bh=0VGkGf4vXU7VmCzKFkBEl2LNUaZr71xsR3rmyfKFIyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=D4lXh4YIzjtshQp28SpH63QbUqmGoabONr3Ue8mbk0ZqCGsgCDxSmq/uI9tB7ihHfdyN3zSjb6EOhLm3h3LtsqFHGKMukUzympDYlGemUqKBU8eLq6gfP9wV56jUHeR4Iq01FVv4rf2JdsK+aDEmax1coznAMbBTP9lS8sNb8dw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bn8vcTLU; arc=fail smtp.client-ip=52.101.48.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bn8vcTLU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jM41FmLrTeCkVoEISs+nPTDWRcBhyerRa/AkQmaoCOA+IeKIMZJjqFBpI2SIC4PYrw2MXdIZD+F1vhVee/9qMu1Ncqoh49SC9G3I31mKWIn8pUtP8e7V9E/zN0KcydbpB9GtqXUxI/L5u30+rxkE4Ra18E3qYxveyJQ48R1z3z+vJqtKAD3pY4K4WXKj0pGkBs+oblCymWPOZhKgWb8FuU6bfpEPjWN1quc+cxh59NSxQ1sqffNZnP7Zv9T7xUsbe7qKOMQ1PctFh33futQ5kcKjCh9srqWPwONyiincmX2hCfEhYd8x+rQI5Ry0vxisJHJXAD8MbvMGHqlAuyLqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWZwPd2/s+hegZJsVVJ11ki8YnpJTXD8aqR/QGIS6Yw=;
 b=toM8sn2S9xjeizPjTzfFYKTyyU1tbsQC6CTbbmNPmPs/kJg6EO7gCXqgwOdoQJzTjnOULKjSH8bNP+xFjlHpvm7M3JfpR0YGiINIye/g5kQM/Hx2ADvrDumaQ0SrkYGKX9fGkO4bj1MYhyG4po9QivRgjEk55pu08tUqvBFiTyBIm7IckZQw4uBL3cwnNiHnTN+Dry38sXMIZrmScQlNj+2PxtrFoS+e2eS5yFNiZGGr0Lg0lmTXnCIx7m3tQoPJPNqD4nE00hwBnGgZz6HGBgKwuVA+1bzxTazs2x7FB0AyfXoQaTEkC8Y9AtxliJ5v/wfxKap2zOGGJu7aEJetdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWZwPd2/s+hegZJsVVJ11ki8YnpJTXD8aqR/QGIS6Yw=;
 b=bn8vcTLUd30eIK9BovgKjPQDLZYinc15BsgqyhhrhFH1WrWEm7SKsTqNQKiEdYo2qBVjMgwDANlWrqE9S/VM9dtl4/J3iD9KkgirM3JE+86W7ykkECvXvhRiFOdXRAP5YSkXNbzvz7A1cLZQdbUp6eUDeA3QnHWPYfaQQuWhpHkuZPbXJMXVO6EFau/nxUj8O8O3WV7X9qdyOw2qYHxtobTLdlQW76gGbr3AxSswzBDrheMRIUz7V3quNYk3jaLprHimL0HFzJphbALyfYR9iigeizPSkHqCHRZZGF7QkHGZ9XRc3/bQBebT7yBJZ5BLXz57O4FDR+GJW+5ZS/t3lw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MN0PR12MB6224.namprd12.prod.outlook.com (2603:10b6:208:3c0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.20; Fri, 8 May
 2026 14:53:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:09 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alexandre Ghiti <alex@ghiti.fr>,
	Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>
Cc: Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH v2 2/8] iommupt: Add struct iommupt_pending_gather
Date: Fri,  8 May 2026 11:53:01 -0300
Message-ID: <2-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN0PR04CA0067.namprd04.prod.outlook.com
 (2603:10b6:408:ea::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MN0PR12MB6224:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d5ee695-3211-44a9-a197-08dead118461
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|7416014|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	gZN/P599JK92mrZ/r7oSyi8nEEsTs/SnK/iUfzd4f4b4Sdi5I4r9wYePZ3kfAk9HOeUcNSDJTwo0R2VcAv408cDBN2udpKuT1jXzP69uCtKiVBeuLyzosWH42lz3Fpg/oVNga1k4xZWEAkQMZzBhAMto9v8PyP7DZe9lKnA77MEitzuBGyevvw82L1yO8nu6ejpkZDoHeYBNR6E0THehRAohW0ctPYCWHgKHOszXbp55QTyX+DJF+bfWvI2av3x2onvYxneuy1ZGkZ8BQvXfNSYrGMStq8ol3oRorFSLzai8brWn0NQTpzn7ZuAKNrqERscyXkxVIE+kb+3YHJJSYBn6BGQUdmpI7HrgbwD097WnTFbh2LXwO+Y4oQUdmvt1fUmOGsF6GWg6IGxFvo4XHbC+QUs5SwMNzAc/CsyBgQMvT0GP72BKFRBSlKNRuMPoUr4dj2A+fXdOh73pfk/gOqk7hh4vpAkS2YU6tWIe1YWyxOsuIVmh6Gc/PcvbQhSCJF9OcDkh7dH/mVolDX8DB5Zrrpwlz++CTEULLQD7MdksZaQE7wbU00EE6KjfPT75HMl/fOb4THSghB5cqJ12ziznd0Nu+DdBh6hUzfRM2iNI+O0mvi4LKs8nn0hBiT4HVklT9NJMrtAltVJ0TFoa0+K/7rQsokc3933NmiT3EwblCH+tYes9CwcjgYluLVZ/YqLUJckAQbfBOOxuF6uIhKxmTvFoirJCqTcI4ZS4yyM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?K9wxs5L9R97eGN9e8R9UAKIy6kj+A21YzbnuNXUp0pHke4chE1O0ztfEnpRw?=
 =?us-ascii?Q?YkNpYTPRqkYmsKmYNusugwmR1TkVvhFNOK6FOrd+9wPl5Ec/0ySd3DKAQR91?=
 =?us-ascii?Q?RwCEmPaDQ8AJaC2Z377E0/YEYyVa4+l+4j19DSP+J/WjfONTJLUflNTnhku8?=
 =?us-ascii?Q?Agg9zIUEV5dPgq5W5NCdmy4coWR7p6deeQ+DANcbW+Ah/g4QiYn71e3w3QDZ?=
 =?us-ascii?Q?7cxoguHur4hKNmv+3XqGOmKRS95Jxt2Wc+oUfgDXWV7rvxg/geDKS+8+Dc48?=
 =?us-ascii?Q?nPAFPsMPGLhQuoVYJiLuWM9rtON5AhFbLSdQv7oL/+yH+hPx54m/uzlLH3k0?=
 =?us-ascii?Q?NjH9MZ3tzHmQQhQ+Wpr2j/BU7AgP5xxH/npRA3OaVsYcUcSJUmEMLXiIZh9L?=
 =?us-ascii?Q?BoU+SUQhB1VrQK/+a7PkfKQLw/OlToNfvm0TA6PMKeUGpWMVImJR0LLuoeqs?=
 =?us-ascii?Q?BRoKfsP7HyUpIj5hM0482EAuSqV0u5HXE7Y5YRhd2EZoZoNp+NgnHD9ANYs7?=
 =?us-ascii?Q?8rGxvAKUzrGGtN65jbHPiulhLJOu35yRm3RtAeopg9sCP/1GITopVDPwZSrz?=
 =?us-ascii?Q?iwgy9prRJ7ztyPSWuzjpv/ShpO2N2auCdfvFREnKTOOqJqxiduEl1p6dbCV4?=
 =?us-ascii?Q?GCQtuUMMGsRcSF931Osrj3tnNCBySzSF2sMqsjzrvf9wOFQ8//X+b0Y6BEXE?=
 =?us-ascii?Q?vcUGcEXC15AkUmclyV21LZvx5hyFF7O4r34HaWBCuU2EF8eAuOsQ3yWbKF83?=
 =?us-ascii?Q?CKM5twZzM4bA/iUpBiIIt3zzFFCSp5tyvcwZnxDrNw2HuyfL4GiD4QbLHILO?=
 =?us-ascii?Q?8bwMa6sOvQro7v2arz/9VwOsQPL3KTkU219FdDTo9jv44xXvs246zRhVptbm?=
 =?us-ascii?Q?EiEd8vpGAtSYMgf1+Gv3cGMfKlGTdhF9m7MUPt9l1B4+uYzPA78KoZY/ykuA?=
 =?us-ascii?Q?H4QUsU/Vnx4hKa9CAMbfyxJl8hox7ywl/o41OSZxqGKzZSdXKC+3bGpTlAb7?=
 =?us-ascii?Q?rKOOnfotxlh4WeEBBL7px43BUnqZ5sHzHR8FJeAzY9DcfrW1UvBK5LyqxMv+?=
 =?us-ascii?Q?5ABMrszMVmtSpc9FNXqhL7F27QPuFUrA8xI2852d0QTViNaLROHQbsSYEDYX?=
 =?us-ascii?Q?MwhVGKMUqiN7VYJFBxW+bEF8u6w+w47fWr5BiF6kwMpdNYZTjRMjV94QKc/n?=
 =?us-ascii?Q?EzVP/tUTMq+bgAPTrkNfu2/goqw0nOBaKNoXTJmQucxegcZuBqe/X6IyB721?=
 =?us-ascii?Q?a6FDb85mnqPYM7TYkoyP3WTRL9ZVLdOGelP1E9XNRtjHMWlKWIqeGYEdNlzz?=
 =?us-ascii?Q?hdx7lEi/If0Tt0nuCqroLTr7bh934xQjMCVG9+h8XOIi684DZ0dRYjGBm4Ih?=
 =?us-ascii?Q?fhvaWXNHUlM4/kv3VnrX5D2T5hLfbbl6c3kDtvOcBT81t11ivZJk9Dzi2Rdm?=
 =?us-ascii?Q?caTnCmUGG3sLUlbqdaRfZv+w/RQHSaNbwrHeytS2YLcCBThdjIg9ugnWyeoZ?=
 =?us-ascii?Q?dlLhzbm7nKKK12rFp5EWjrCm8RnK36giS8yeNTSgXmF2kuWP8hRAQYS71Qqi?=
 =?us-ascii?Q?jK4El3E4vcsz610jHZmhJxrp2EiZHZOthgfs8y2VD5bSzLqbehtlnZk109f3?=
 =?us-ascii?Q?bFksfd9FNLPrvEcLx2D/Fm8HEQ90eVJp0PhV3ZEQV5LIx4deDlypMGN4NQV8?=
 =?us-ascii?Q?qmhEbd7KUEBzn3/kC3w2JOFeeBjNZQ/sqBgRwQnes210Z5at?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d5ee695-3211-44a9-a197-08dead118461
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:08.3676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gBoyMTfKtykKRqddNJGt2zro80/ZTndyeA+gKWXDX2oahgXng6FC5Dk4ctC/LBCW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6224

Add a struct to keep track of all the things that are pending to be
merged into the gather. The way gather merging works, the pending
range is checked against the current gather, and the current gather
can be flushed before the pending things are added.

Thus, if new things have to be recorded in the gather they need to be
kept in the pending struct until after the gather is optionally
flushed.

The next patch adds new items to the gather and the pending struct.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 75 ++++++++++++++++++-----------
 1 file changed, 47 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 19b6daf88f2ab1..5ec135cf43e2d6 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -40,15 +40,27 @@ static void flush_writes_item(const struct pt_state *pts)
 			PT_ITEM_WORD_SIZE);
 }
 
-static void gather_range_pages(struct iommu_iotlb_gather *iotlb_gather,
-			       struct pt_iommu *iommu_table, pt_vaddr_t iova,
-			       pt_vaddr_t len,
-			       struct iommu_pages_list *free_list)
+struct iommupt_pending_gather {
+	struct iommu_iotlb_gather *iotlb_gather;
+	struct iommu_pages_list free_list;
+};
+
+static void gather_add_table(struct iommupt_pending_gather *pending,
+			     const struct pt_state *pts,
+			     struct pt_table_p *table)
 {
+	iommu_pages_list_add(&pending->free_list, table);
+}
+
+static void gather_range_pending(struct iommupt_pending_gather *pending,
+				 struct pt_iommu *iommu_table, pt_vaddr_t iova,
+				 pt_vaddr_t len)
+{
+	struct iommu_iotlb_gather *iotlb_gather = pending->iotlb_gather;
 	struct pt_common *common = common_from_iommu(iommu_table);
 
 	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
-		iommu_pages_stop_incoherent_list(free_list,
+		iommu_pages_stop_incoherent_list(&pending->free_list,
 						 iommu_table->iommu_device);
 
 	/*
@@ -72,7 +84,8 @@ static void gather_range_pages(struct iommu_iotlb_gather *iotlb_gather,
 		iommu_iotlb_gather_add_range(iotlb_gather, iova, len);
 	}
 
-	iommu_pages_list_splice(free_list, &iotlb_gather->freelist);
+	iommu_pages_list_splice(&pending->free_list, &iotlb_gather->freelist);
+	INIT_LIST_HEAD(&pending->free_list.pages);
 }
 
 #define DOMAIN_NS(op) CONCATENATE(CONCATENATE(pt_iommu_, PTPFX), op)
@@ -341,7 +354,7 @@ static int __maybe_unused NS(set_dirty)(struct pt_iommu *iommu_table,
 }
 
 struct pt_iommu_collect_args {
-	struct iommu_pages_list free_list;
+	struct iommupt_pending_gather pending;
 	/* Fail if any OAs are within the range */
 	u8 check_mapped : 1;
 };
@@ -358,7 +371,8 @@ static int __collect_tables(struct pt_range *range, void *arg,
 
 	for_each_pt_level_entry(&pts) {
 		if (pts.type == PT_ENTRY_TABLE) {
-			iommu_pages_list_add(&collect->free_list, pts.table_lower);
+			gather_add_table(&collect->pending, &pts,
+					 pts.table_lower);
 			ret = pt_descend(&pts, arg, __collect_tables);
 			if (ret)
 				return ret;
@@ -493,15 +507,18 @@ static int clear_contig(const struct pt_state *start_pts,
 	struct pt_range range = *start_pts->range;
 	struct pt_state pts =
 		pt_init(&range, start_pts->level, start_pts->table);
-	struct pt_iommu_collect_args collect = { .check_mapped = true };
+	struct pt_iommu_collect_args collect = {
+		.check_mapped = true,
+		.pending.iotlb_gather = iotlb_gather,
+		.pending.free_list = IOMMU_PAGES_LIST_INIT(
+			collect.pending.free_list),
+	};
 	int ret;
 
 	pts.index = start_pts->index;
 	pts.end_index = start_pts->index + step;
 	for (; _pt_iter_load(&pts); pt_next_entry(&pts)) {
 		if (pts.type == PT_ENTRY_TABLE) {
-			collect.free_list =
-				IOMMU_PAGES_LIST_INIT(collect.free_list);
 			ret = pt_walk_descend_all(&pts, __collect_tables,
 						  &collect);
 			if (ret)
@@ -514,12 +531,11 @@ static int clear_contig(const struct pt_state *start_pts,
 			pt_clear_entries(&pts, ilog2(1));
 			flush_writes_item(&pts);
 
-			iommu_pages_list_add(&collect.free_list,
-					     pt_table_ptr(&pts));
-			gather_range_pages(
-				iotlb_gather, iommu_table, range.va,
-				log2_to_int(pt_table_item_lg2sz(&pts)),
-				&collect.free_list);
+			gather_add_table(&collect.pending, &pts,
+					 pts.table_lower);
+			gather_range_pending(
+				&collect.pending, iommu_table, range.va,
+				log2_to_int(pt_table_item_lg2sz(&pts)));
 		} else if (pts.type != PT_ENTRY_EMPTY) {
 			return -EADDRINUSE;
 		}
@@ -962,7 +978,7 @@ static int NS(map_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
 }
 
 struct pt_unmap_args {
-	struct iommu_pages_list free_list;
+	struct iommupt_pending_gather pending;
 	pt_vaddr_t unmapped;
 };
 
@@ -1025,8 +1041,8 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 			 * succeed in clearing the lower table levels.
 			 */
 			if (fully_covered) {
-				iommu_pages_list_add(&unmap->free_list,
-						     pts.table_lower);
+				gather_add_table(&unmap->pending, &pts,
+						 pts.table_lower);
 				pt_clear_entries(&pts, ilog2(1));
 				if (pts.index < flush_start_index)
 					flush_start_index = pts.index;
@@ -1065,8 +1081,11 @@ static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
 			      dma_addr_t len,
 			      struct iommu_iotlb_gather *iotlb_gather)
 {
-	struct pt_unmap_args unmap = { .free_list = IOMMU_PAGES_LIST_INIT(
-					       unmap.free_list) };
+	struct pt_unmap_args unmap = {
+		.pending.iotlb_gather = iotlb_gather,
+		.pending.free_list = IOMMU_PAGES_LIST_INIT(
+			unmap.pending.free_list),
+	};
 	struct pt_range range;
 	int ret;
 
@@ -1076,8 +1095,7 @@ static size_t NS(unmap_range)(struct pt_iommu *iommu_table, dma_addr_t iova,
 
 	pt_walk_range(&range, __unmap_range, &unmap);
 
-	gather_range_pages(iotlb_gather, iommu_table, iova, unmap.unmapped,
-			   &unmap.free_list);
+	gather_range_pending(&unmap.pending, iommu_table, iova, unmap.unmapped);
 
 	return unmap.unmapped;
 }
@@ -1111,10 +1129,11 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 	struct pt_common *common = common_from_iommu(iommu_table);
 	struct pt_range range = pt_all_range(common);
 	struct pt_iommu_collect_args collect = {
-		.free_list = IOMMU_PAGES_LIST_INIT(collect.free_list),
+		.pending.free_list = IOMMU_PAGES_LIST_INIT(
+			collect.pending.free_list),
 	};
 
-	iommu_pages_list_add(&collect.free_list, range.top_table);
+	iommu_pages_list_add(&collect.pending.free_list, range.top_table);
 	pt_walk_range(&range, __collect_tables, &collect);
 
 	/*
@@ -1122,9 +1141,9 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 	 * and invalidated any caching referring to this memory.
 	 */
 	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
-		iommu_pages_stop_incoherent_list(&collect.free_list,
+		iommu_pages_stop_incoherent_list(&collect.pending.free_list,
 						 iommu_table->iommu_device);
-	iommu_put_pages_list(&collect.free_list);
+	iommu_put_pages_list(&collect.pending.free_list);
 }
 
 static const struct pt_iommu_ops NS(ops) = {
-- 
2.43.0

