Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010015.outbound.protection.outlook.com [40.93.198.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF2B3F6613;
	Fri,  8 May 2026 14:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778252000; cv=fail; b=e8cMxFmzXloO8dgA4s7L7dyOAT3Grtycd05qmiq7bfzhYoaehZfq6Oj/vNAB14retAaDlmFLDG2i3WZ80Pm61QtT28OXcG3ayXyoukP2ERiyyF/89Yh4UrP5cOe4MozQ4DFRXo2f4e9WjC2tQsIDr5NOO/n8xLwnPFAY+Ps1Npw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778252000; c=relaxed/simple;
	bh=KCE2K3Uk37LMWwNNpCmefZ4nQzvmgJYJjWf+G7SzkfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=AlOb1+oIP2KOxPzJodY99p2eacTBWx4y6AKyWK0L+oxo2D06ruedQtCcodN0IJ4wNED7nO3nBpFySKVZErnifkCD6yHkd4U65MZRfNR0uzmO/tZLVJMw9SCUNyTHiNSumTWxtS8DESK3Qhe0Nv5jaal/iPucA+OWdvoWtjB1VXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VYoOo+I9; arc=fail smtp.client-ip=40.93.198.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VYoOo+I9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j/7hlRY1/Vi0Gaxdo50I/8VdEBNV06Rp2xAflwVGFp8Y0TMem97xXRemYIdzFMveODUGo9z6l9ivI4QKsAaQUHykFeJRJaFlSTssQAh5fh9yQxBBtARg7C/vDhpk0MoGzV7oy6iLvOSviU+Brcwd6DPfNz7yHQFYbIvajAXfwNQAi9hA/e8iUbqi+4olJDSaV0YkQ0hSzPK4u5mnfnDGdzzbKfaK8pJAfiS7yHdM9Zr74/dsTJ/wdQOxiIFvAzXVMSEYV/L1RASQCCVSFwu0rlZZr5JRk90O2MPR/0Hq5U9lhrWsF/YXS4wWypye54fVol9e/Qmd76otSexm9dF7Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LjLysUi/HcpqrgT5EbE6zj8/XevIAyfkAeC+wBphLsg=;
 b=BsAO+xMAbYPzkCaroG5WtultjAkXsIerudo7tw5Un2mSt5YhxeKBXdUe22ot0WROk8MN8M0eHs6R6yA+tvAMO0K1tPV3sXVR/hiuA/7El1XqQrQz+kiRsUp2J4C/GGzydSWTFu97M0trpNwLlAs5mYLUf/uW+mR508zlcHhofHrCH2jwxQF/yzjmzHURKATVRidZlqsdJ5OllKEStWzhI72sNn/XlIrDz7EDPrScvjSIWZw7LWXzsjULSOoScZfRphCE7twaVZp6SLcJSyhHar96e23vGIUNESviWnwAw6JfAxM+0kaAdn12Ddpq3ErQb8RmC/fu0SdlOWegoKwkuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjLysUi/HcpqrgT5EbE6zj8/XevIAyfkAeC+wBphLsg=;
 b=VYoOo+I9kOC7b5zH9pSPCJMHnJBrlk1xkQv861HA9Qvev7pMNHN1nxA44D0NDUVvUxVLTAac/wEm5J0PvTUUVhCoP4rhJYyKNe65cwtVRNivf5HJLiSNNdNJna9DM60WisfeO1ilS6hx3O1iIfLrxg2J56Wxk7XlztYMthU6QCG5ewtC9T78GsaZeMbnk/vA9CjAQymk86cF55TZVf9kNbtyOED9S3qdR9wq05JFGufpHj2dG3LoF4G4YmM+yAb3JTraRrfhdqJd0w8a2bVCEJY5xoPnzUKwQDswII76yY72xBT1qaxUNDDEooGos05ChhvyjH9NV1GknZK5iocpJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB7176.namprd12.prod.outlook.com (2603:10b6:806:2bd::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.19; Fri, 8 May
 2026 14:53:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.017; Fri, 8 May 2026
 14:53:11 +0000
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
Subject: [PATCH v2 3/8] iommupt: Add PT_FEAT_DETAILED_GATHER
Date: Fri,  8 May 2026 11:53:02 -0300
Message-ID: <3-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v2-b5156f657dc1+25f-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0106.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB7176:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cb05ac3-f5e4-423b-4e4d-08dead118623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|921020|56012099003|22082099003|3023799003;
X-Microsoft-Antispam-Message-Info:
	wB5dxUCuqDWTpJny3WabdkkVq7W2ZFZghkJSHuJH64e6vwxzvQsL82P6CTLUqNpsB+WobiR5EhGT2Ea5nDXogBQJaEBEyfTzmeZVtKWeP/9y1/I6SIaghsSUxGORNORS8RJijI7HsPVEk9H3GVwzk2wZe+zr635uPQeqKylZ/9lvl3uEwgfhzJltLqQTr3Yzj4ABcvZ1P6miQuPLXSCJRNjoM+kWALEgsXJPc9pt/HteBV2AxzhiQXUL3GmjHx+DM0sJDVE+C9tpsMQLZQCl5JkkEJYCCTWTsXSzZRxrth+x9yfvxrFIsN1KmQ2Bf9pFicaVG03CdoLDSYkE2mi8MkffscQOuXhMVl/r5soHRU3//R68twuUY/WRLt3k+HMOJfCCDRB8ziHEaYe9DcHQghY0x2XHMvyf6NQzm4FB4z+yvO2BmPQLAEquvBuQKQnhHEHKQmdgPe8NDqSDsAwCGrUn68q4hKKEDQV+Ne8hCnmrtf+oP1tr9srCz2f7DK2QSJ/fog17RmOAhFMse+fWLZRYBmb/i/7uOOoLgo2aZ5+sk472uGDQC5GSvftKa7WAd5+zpct7SJYjCkAB4EMmplKrqYjPJ/XDgFjarOQe2VYDuB3PRpJqD7WxZgtsxT5uX2wQZFX+04FyzgRv+ozOeehdgfmsI3CjpsVYXxl/j+JR4rgjcWR4tWmTXv7KdUnceVQfLUSTLYtGtZ/0Zcl6XKRwDroh+1u1HqF2HjXJNdQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(921020)(56012099003)(22082099003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zVFTFIvEplTisDlZz5hhSH96ge3ZpZkudpT/3idNHx5ai3WFNCtBiRsMyjYH?=
 =?us-ascii?Q?FODTbC6sxwZiWrAc9ivbeWr2j2kVbetbn1y0eaThCuIikBcGPDANdcT1Ojae?=
 =?us-ascii?Q?h3FCqjj597GtmwG4sMCf0zNxyVDsgCdj6gBmqz8gsrPfH+Ty47VdkFexQYoa?=
 =?us-ascii?Q?P7DgC5W0ipHgpegvXtcXuSHbcFVr/rr2xtgaW+j5uWSNyhxC47Z+FlHacpfh?=
 =?us-ascii?Q?RBP7G32mT70+F2CBlJlcenI6Ps1r7dN7oGbKkbrlAiixB4jC5QxbVW8KeByz?=
 =?us-ascii?Q?vjaYkzWyzUgPr3b2iFxW+wB8VTVKVj+DGqo7ACSfLixd3CXUYhUUTF9A+yuy?=
 =?us-ascii?Q?+FSvw5eUe9LAMF971zYxfZTet2zYuuYolS9+0FlkqxXuXNc7X4wsKCIY99Z/?=
 =?us-ascii?Q?rFefMeKPJ1DtkC0LmcQkPsKgRq93PZTT2S/pzj61k4DLKGfYKFG6PtsdKI9y?=
 =?us-ascii?Q?wHneNvh72856Qu/ZWBfxAxdwqI7V5shcbFhmcOcBhROd+qwqzNKxdMXcmZTL?=
 =?us-ascii?Q?ryO6rVE/J4dJfLohpEJx5mhVmTxUBQjWdpVKPAOVgL1pfd+ZqmFD6GEAd8iQ?=
 =?us-ascii?Q?BFjZwak6A9biy/0+Nc8NEnuh1PZZlkdLf7uUtDh7S75To53mviVTwLBTxN50?=
 =?us-ascii?Q?bHqTznOVd5yNC/OxCQn1ushSatR2bjwjKH75NGYUvkRtOvW6rq+HwiW3p0tn?=
 =?us-ascii?Q?h9MLZ5b4q0AP3eTqfyDOJhYq9byR7aTuag1nCB92FpTEQntw1t8NgnAbSzDw?=
 =?us-ascii?Q?mNpGN6rsgjoAODzq6WOkzXzvzVOW+swHJx0KyDpLywPlGcw8Ftw1p+BHXZYs?=
 =?us-ascii?Q?Ma7/7E1xuXF3juRHBD7YYW3G5sAFgPmN4HtjnUEtimWjSqHwzjyXejOO20eF?=
 =?us-ascii?Q?QwvrUkSadcWaM7iEAAsFfAzAwta198R3HGN80Me7kuGiuFykFxuwRXU/6gBF?=
 =?us-ascii?Q?dquC8pfPCMe90mPNLJgUzlGy5f8vQOLS05b5h6cbCHYBA1cYDg55sD+LU7Fa?=
 =?us-ascii?Q?S1EUq99AXNxMcJ/nDPtEPbPjsYveah/Bmrxd4KDWosZoyk9JsK0t9/Qx+pyt?=
 =?us-ascii?Q?Er96EAp8IzSWJAqowVrX0ak4HcSRg0RhAzJWFhl68oyEFlflnADL84613V3f?=
 =?us-ascii?Q?p9SkBu7opoXP8fKpFFiWd1JLCD0NanIBUxBA5jvyEDZbJNdftA7JVlWBJWTh?=
 =?us-ascii?Q?uFopumwL3DH0WKep+a7el4o0LY2fgp+jGruNaASfsTGFoje6YeK25ot07DQ7?=
 =?us-ascii?Q?W1LKLdflXJOaGCvSzHZfjQjSgapaMCY23giQgYjsic4DxCq8CWEzSNXH3p3T?=
 =?us-ascii?Q?nXf1NOdAELqLq6PDXJTx7JS3ENqZFGDLXPmMaH8PaDUJYCruMAZYSjNOdDhj?=
 =?us-ascii?Q?r2cHC00zbMUcXflTFQN61OQZVV/VAnbzTv0ryYtoEkihrsdFAuENC5xYrXEK?=
 =?us-ascii?Q?aOCmamRidzLmBuDhXvFfHjFthlg02BikrkciRwOkCH3oQpRyTlRJfpTGoWk4?=
 =?us-ascii?Q?BreRnTpX9pzdXeSI0eME46JSOXpucyLWogrDwOOLzrVAK9rTVtsbGUITmIrF?=
 =?us-ascii?Q?zeURB2z4jRmfTmgbKQ9k4bJn1fbuWr/hzQtKeOZ9Dv/RHGcMta/Cdbkz1rjJ?=
 =?us-ascii?Q?Mvgku3CybOEWfBevODd5+eCRLE8K/pTrtq8MkfPBBVso6GPsv7qhqQJCO3g0?=
 =?us-ascii?Q?6YrxMgXYWPDNuFML21CVZn6wXbevx6VyqD484zUETbt/I9Eq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cb05ac3-f5e4-423b-4e4d-08dead118623
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2026 14:53:11.1375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ehjfZDTx5u9q04PVo/zm9J0R2tHXozh2WeLSFPjV/LVz520Q4F7Lq6a1w0gnKp73
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7176

Generating the ARM SMMUv3 and RISC-V invalidation commands optimally
requires some additional details from iommupt:

- leaf_levels_bitmap is used to compute the ARM Range Invalidation
  Table Top Level hint

- leaf_levels_bitmap is also used to compute the stride when
  generating single invalidations to invalidate once per leaf

- table_levels_bitmap also computes the ARM TTL for future cases when
  there are no leaves

Put these under a feature since only two drivers need to calculate
them.

This is also useful for the coming kunit iotlb invalidation test to
know more about what invalidation is happening.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 23 ++++++++++++++++++++++
 include/linux/generic_pt/common.h   |  5 +++++
 include/linux/iommu.h               | 30 ++++++++++++++++++++++++-----
 3 files changed, 53 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 5ec135cf43e2d6..61c6d79c712cfa 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -43,6 +43,8 @@ static void flush_writes_item(const struct pt_state *pts)
 struct iommupt_pending_gather {
 	struct iommu_iotlb_gather *iotlb_gather;
 	struct iommu_pages_list free_list;
+	u8 leaf_levels_bitmap;
+	u8 table_levels_bitmap;
 };
 
 static void gather_add_table(struct iommupt_pending_gather *pending,
@@ -50,6 +52,17 @@ static void gather_add_table(struct iommupt_pending_gather *pending,
 			     struct pt_table_p *table)
 {
 	iommu_pages_list_add(&pending->free_list, table);
+	if (pts_feature(pts, PT_FEAT_DETAILED_GATHER))
+		pending->table_levels_bitmap |= BIT(pts->level);
+}
+
+static void gather_add_leaf(struct iommupt_pending_gather *pending,
+			    const struct pt_state *pts)
+{
+	if (!pts_feature(pts, PT_FEAT_DETAILED_GATHER))
+		return;
+
+	pending->leaf_levels_bitmap |= BIT(pts->level);
 }
 
 static void gather_range_pending(struct iommupt_pending_gather *pending,
@@ -86,6 +99,15 @@ static void gather_range_pending(struct iommupt_pending_gather *pending,
 
 	iommu_pages_list_splice(&pending->free_list, &iotlb_gather->freelist);
 	INIT_LIST_HEAD(&pending->free_list.pages);
+
+	if (pt_feature(common, PT_FEAT_DETAILED_GATHER)) {
+		iotlb_gather->pt.leaf_levels_bitmap |=
+			pending->leaf_levels_bitmap;
+		iotlb_gather->pt.table_levels_bitmap |=
+			pending->table_levels_bitmap;
+		pending->leaf_levels_bitmap = 0;
+		pending->table_levels_bitmap = 0;
+	}
 }
 
 #define DOMAIN_NS(op) CONCATENATE(CONCATENATE(pt_iommu_, PTPFX), op)
@@ -1059,6 +1081,7 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 			 */
 			num_contig_lg2 = pt_entry_num_contig_lg2(&pts);
 			pt_clear_entries(&pts, num_contig_lg2);
+			gather_add_leaf(&unmap->pending, &pts);
 			num_oas += log2_to_int(num_contig_lg2);
 			if (pts.index < flush_start_index)
 				flush_start_index = pts.index;
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index fc5d0b5edadc08..230347f00353bc 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -134,6 +134,11 @@ enum pt_features {
 	 * significant amount of page table.
 	 */
 	PT_FEAT_FLUSH_RANGE_NO_GAPS,
+	/**
+	 * @PT_FEAT_DETAILED_GATHER: Fill in the struct iommu_iotlb_gather pt
+	 * sub structure with information about which levels were changed.
+	 */
+	PT_FEAT_DETAILED_GATHER,
 	/* private: */
 	PT_FEAT_FMT_START,
 };
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index a9e89911c90f24..bf8a77a164e4db 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -360,11 +360,31 @@ struct iommu_iotlb_gather {
 	 *       flushed (inclusive)
 	 */
 	unsigned long		end;
-	/**
-	 * @pgsize: The interval at which to perform the flush, only used
-	 *          by arm-smmu-v3
-	 */
-	size_t			pgsize;
+
+	union {
+		/**
+		 * @pgsize: The interval at which to perform the flush, only
+		 *          used by arm-smmu-v3
+		 */
+		size_t pgsize;
+		struct {
+			/**
+			 * @pt.leaf_levels_bitmap: Bitmap of generic_pt
+			 * levels where leaf entries were unmapped. Bit 0
+			 * means the leaf only level. If 0 no leafs
+			 * were unmapped.
+			 */
+			u8 leaf_levels_bitmap;
+			/**
+			 * @pt.table_levels_bitmap: Bitmap of generic_pt levels
+			 * of table entries that were removed. Bit 0 is never
+			 * set, bit 1 means a table of all leafs was removed.
+			 * When freelist is empty this must be 0.
+			 */
+			u8 table_levels_bitmap;
+		} pt;
+	};
+
 	/**
 	 * @freelist: Removed pages to free after sync, only used by
 	 *            iommupt
-- 
2.43.0

