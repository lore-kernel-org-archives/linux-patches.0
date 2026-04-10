Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012041.outbound.protection.outlook.com [52.101.48.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF243DA5BE;
	Fri, 10 Apr 2026 15:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836647; cv=fail; b=Iep8WpRk58XXgg48Us4nRLsOqASRh4crYZ5bro8hU3mSzc3P6ZSm4yNGmdOkMnnvOx8arqu+aAOSwV2rE/c4Suu5GtX0YXTFsyAIJ6TAbQcd8Yg4JZIBGzy05A7Uz2N02HeJWngMsSDRxJIPcu6fn3xScUGtHbgwUpWOclrSij4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836647; c=relaxed/simple;
	bh=0VGkGf4vXU7VmCzKFkBEl2LNUaZr71xsR3rmyfKFIyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=DIm2fywNrMFBpt8x0tGg8RP0acKND4goijpnEP+Bgw7+QTefWFB5ZcCF5yn/8BMMmRHALVN6CgmHytPDTzRJ5rmTswwON5IUk+ihSd723LmOKc6BprfUoB+dVtDPDkhayzIUIrg0Qi7E0fYpb0yF0C8rzMaFKRkmfEmpxHIcpmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=tHGlx1cf; arc=fail smtp.client-ip=52.101.48.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="tHGlx1cf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ifxjjZlWeiwX7e7toaJVsKtw8IiJNRmNLVeC1fpJmvmXwX3GSVO6ninK8xOvFzJz1RT9V/uNqqvLU9/23cJDEP3YCnDkMk7QxLFmXrBPQ2yBe+MaisMrV5/dI7rgdQtMzjAp/CLT7oRfK8q2xHxk6fc60Vh56iF3VLvjG4SsCyGLoU/hHf+nEEcisKCV+A9FYfMk9NdAVApNBP4r/AoSf/zBqxtrhXvLkRjH05r04qFlG1n4XguFoVl6RsdA92SggSCyVlFPCT3wmt/NuxtrBU/pVs926BARHA+2BaRw0/1XoDEO0PESfcQJh6Fi1g8hNXd3yxBeXHajlQPfCd078w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWZwPd2/s+hegZJsVVJ11ki8YnpJTXD8aqR/QGIS6Yw=;
 b=lefKUCTLR8QVJkdsuYuGJCEVjqq2Jd6ma/Ly+VuE3/XWHVs8BvQpKds+C1Kz1JxxffFyJUa3OFLyIN3zXwQHa7nvfMYBIVGsIozBT5Hl81gWX7KtAoCrGUXm5NWH8ux2REo7o+CaaxAcdsTsFQ81flyB1aoYmKAKTctEf5gAir7Lki0LoMDs8/qDjbJCbuoM2NfeDh4uNBrNyUwuwoCsFFBz0KHezPmFEG87xMm5/g3VWl2+2VW+lXhGrAT1UWTiaK0V23FRyaksW9LlxmlhaS5BC0y5tGFehPXB4uzf1aQguXkSELO6EdqOV1JUgKXBMAGP8Bmd4CcDZJqsXbylfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWZwPd2/s+hegZJsVVJ11ki8YnpJTXD8aqR/QGIS6Yw=;
 b=tHGlx1cfrqJ/1P03TDOeoOow84ywjD/3BHEuuKyy+JMo3GmcQvDd4uaB3xnUMSnLZ2xMNxwkhsLPxZuXei1y87JYKbGNBn09Bfv7e7y6lFj3qoilX79Xwnze2m2pT77Bp2xPyJHIBEWByT0uJJBtJZ4zP4AXsLpBMVXrIt9/Hq219VSPBcKfsePo9N+sDnnivo9+AQT22O+uXaYz+d71GPeeCafojFL1nfQkcy9l0KkaLiJWdohLE7BoK0cHgFPYSbNubdkrV+nWH/+QI1UQDxmq77gGmHP/ZqEglZ+dxikDivl9X8+kAzsPx6A0aQpqHSq/lJev6/SIWaRpOmA7LQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ0PR12MB5674.namprd12.prod.outlook.com (2603:10b6:a03:42c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.33; Fri, 10 Apr
 2026 15:57:17 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:17 +0000
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
Cc: Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	patches@lists.linux.dev
Subject: [PATCH 2/7] iommupt: Add struct iommupt_pending_gather
Date: Fri, 10 Apr 2026 12:57:03 -0300
Message-ID: <2-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0108.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::25) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ0PR12MB5674:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c18207b-056f-4df4-1e59-08de9719d436
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	QwBan6izFTgRAA8QRhrF0mvbOTHUje98hOFxbzAp4jLAlUgE29trCHD+RopQvroZZYkw5zkPgA51ScEuvyZpxe8jrCb/fJIDbSA2lhxaZdFvLiXaS8cwV7eNjc+7EiVCVfwyAH0hl79espvaxk2WZGJG4rg/0CwSmCAvnUDbFCIp5zNRwB2dVx6hRYkaeShcb4YY1/aObY7WwtxshYaYDSzLb0OL8Jnu0+3NkHw0DrytEDS3CG9cm29zp2kwSRwE6YmvoVyLfETD/lQzVxYvOAsIMCDU09+YY0wWlx+ldclvDoYuQL6/WY1BozTo2PY4cUYxvzNNnQsFg2iQvuCCv3K77v9LnuMxIPHy1I/cPrwHC/EDTK9WDQbtbQ2+m8rYk+PpEmELPRrub2sz73DFus9OUF/OsNGIxxlRcm/K/qZfHXTK/ZfSiCMNFhQ3n6Qx1O5Tx9td1btIofZ6lHgtNPswfk2PQ3XWLkvJIjdLZeD+mRuLrVEdYZ74xowOkcApZkOd2hpNG1jx8tuaeSIX47b+RBjkKsPZzQE2AsH/3bNJ80BInf4mMF15BI2ENYcPXxwjnyEo9MujVeTcj30sMdK1oGW5Oh8Eoc9XJem74T6VoqEeraLS7HKT2ow1rJxVXV7/CiLaHGfg3MVl99KIk771fSStjnhvEuWTVrnZGyDEu5qWdAkLGdWzw5ymZV3a6rXG5ScKPquXawLGVwdhjH4SRuhv6pJvoZL3DqAY8R6ZBviBRNyPC5CCNC2hakGLVcpu5t6wirUNsjuN7j/joQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3JdJDzruVl5SfDjyjw4SuV0kfwSAxI9FmlO/Tuo5JDN7pHPGbjdrrD1tnkT2?=
 =?us-ascii?Q?NyuodWjEcMIr72JuTDfhxnezFcbldpPaPmgwKJShu8es9jyTt6ucnBRaYPoP?=
 =?us-ascii?Q?UuOciL3rH/KSeguIxRe8jt/sCRQhLnQCBZgJmxDjnpCHGxw8DB4AY3F/H4LY?=
 =?us-ascii?Q?zDj/1zsBVchrUOyzoLDlpMCJcp5xMLC4urrHvTJn2HeYhVpLvUtPGWLezDD7?=
 =?us-ascii?Q?iTD5vx8HMaKzAc+0Yjxuz3CkzzvMPCmfAjRO0i24RJbPJWx/zUEpvCTN6jwq?=
 =?us-ascii?Q?xlk+ohn4HfEm86jHFQc7AhLzEwaXagcoHz40WoHl74TXe8nRe+vrhQFyo4mT?=
 =?us-ascii?Q?h6p1r5WAi/KwFtUh1GCnuU66YhaRaxINC+9gVk2e27Czmx6UMOhn7HiXz6Rc?=
 =?us-ascii?Q?ikSfcc0qJ+LnFKxM0RSVG+Xd+lXHH4kn812MUt13yPi4zznp1b2xtIfBnjln?=
 =?us-ascii?Q?UM8ZlTVgKsrnUi6H3KqB7rxgooomtGiyDKMn0eXzPhMA1ZGlWXOOCM+dyOiC?=
 =?us-ascii?Q?cOIId5SYPPS2len2Uckya0fYv9EfSJ7wh2otpaVgYY373WyOT61lKX+eG/6j?=
 =?us-ascii?Q?8da+o5ASALYy8undk5aXRc9uuhyunkGzI0psvUvxqkQegGHKRM+gx/NeUkQq?=
 =?us-ascii?Q?YRUwUTYVUn1YMSwPKZUTX+L0xiek9cxXWJ4O5ATrCBlaI0iwQbZIcBoKiOiy?=
 =?us-ascii?Q?3cB0pzyYDCBZBp5I7xMjogFui6Sl1iJr7VzZJ68rE8V5Gw7KaOQbIlBX5Afi?=
 =?us-ascii?Q?9NPcq9+zGwLJAiPg7FlUlkmdukTY2P74xA3T201UZpkGiGHhuU8+XePkZ0zN?=
 =?us-ascii?Q?f3lkgv1rYgZg2imcwTHERbb/WW1WdQ/tG4NFjgrwnDEEfTKkpmUcZccWoTqi?=
 =?us-ascii?Q?9QP9rH2t4axmbbeU/iNPGPqvjClVBveKkL/rTXTYnbKpJKRRdkf712NURGF9?=
 =?us-ascii?Q?7LqDKiC/sK9+EifW/WG/tALRJOux/2dQLiFY6k+1aiKwHCKx6KZJoiM9hOCx?=
 =?us-ascii?Q?ONrvApFcHiLJcTV2h9ZhDC0XYIR7wD8gm5CBl8NAkAkpMikAC+jtU4JSWw5H?=
 =?us-ascii?Q?PKr5c1RmXlb6pngemFELPY+UxRAC+5T80PQmnmks7K0FJngQ8UCwKGFJXAKD?=
 =?us-ascii?Q?NvgyO5M/cfGyHCZ16qv9m+s2Xf6CHLmnAe1cGGdu78VwU0kTjIwqHq8uQewA?=
 =?us-ascii?Q?OAysMWtAjQArVoh4qqIJFOb3QVlPbHfeyvG4zq0tde1KTkG9nRHuaXnzy+ru?=
 =?us-ascii?Q?SQL9bg0TpZhkfwWuRbayTOCumSqbVTid76lg/Cl13F0vbYNyGjUwIBi+XJzr?=
 =?us-ascii?Q?gefaO/3m3J55ip8oZo69m1atOPIbsUHVuCXopmZOZvH3/wQh606rLE0l+7oG?=
 =?us-ascii?Q?VFheoUlmNt1Tfr/ZkJL1hTtDo2Y6Ls/7DvVrx3Q0zCAvvTCejTX9v7y9Z/md?=
 =?us-ascii?Q?lwx2/qgpnnmE33K92S+dmbScJomLwd4bAQ/sI0tql7wv2kTwxusP6Aw2JcKe?=
 =?us-ascii?Q?YAwALpONC91ytrbwfBwE04TWSAkOuVzQVpRURxbkiSZJSGh34QMCa3Jq3JEz?=
 =?us-ascii?Q?OQcD7rX+rweGyhhOIf0qHCJsAQhIRKNalO7zK7wwobC+9FZXFbKUteIWRWv0?=
 =?us-ascii?Q?Vr7wkj+qGXSrFhePETHnzjmFL1IArFaArTjxGUKNwHIq8as5IRtw0G2m9h43?=
 =?us-ascii?Q?khBKPXMmnWt3P+J5Nvzsf8BAJC9ZA/w4RaGGh+1ZMv3WwuIg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c18207b-056f-4df4-1e59-08de9719d436
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:12.6662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KLt61o2wauNR8H9iip3ShEmpp+EXqnhiMsCcyUwIESkEhYMLmfwog0dqRGQs0aZG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5674

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

