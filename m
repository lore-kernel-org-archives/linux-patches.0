Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010029.outbound.protection.outlook.com [52.101.201.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2044E3D9DC4;
	Fri, 10 Apr 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.201.29
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775836639; cv=fail; b=UBTwkjisJJJGuDumWtGLka0QIcYBjJ6VUKw2Bd2gQuzf7R5MhtPeIKu5WWkq941a45aycTTFkZoxzlFxk2vqLCZZxkwT4xhBufFfNOgBrpDuyUuO8pNXdgBPdBF1MLpmZsJAvYtGVbROaOtuKTJnhuaxyie89O6EMGcailEtx9Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775836639; c=relaxed/simple;
	bh=kmgHZujuNEHjANfg0oboBK9wTJHz3sSk/xyQ9zHYq/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OE2RygSpCUPRhduIlnDShIoeZFQVI3Nef2lnaEC8Pg4WZpPmrPUUO+dlsBVaZAGqowLinn+kC4eObWEBdtga5jzAdhop62cN8rOxnInJ1n5Mlm6yD8iULAEpDqbqhN+YvNoIxVsphSlyzuC3glh0b9f7kdRo7bwpfTfMx0Uzlt8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LHi+Uwsn; arc=fail smtp.client-ip=52.101.201.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LHi+Uwsn"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T5AdyYv3erlAkR0XhNVqm98xgemip4Ef/l1uvaNGchQMIedNuzZFT9A+h+53TNGHz2e6Yt6ywUlCEUQuxXJTVPgD3nUoRIFiGoJJSo4X1VcmWu1mz0Myf/TUo7BrKhPgGjCmntNA+bi8azovWLrvK8ea0gmXL9JVLVzeFMg70yauKuczh/nyW6Fj2vo/h2WX4txzGC76cF0hZj1glNYpAxh1e4RuuM+ocdkw+1IydzE1z41vMJb5/s3U3h8kspW+8MBnxcdZEvzSHV+dvj4W0UbeThWZ7imdw7fl4kBaP9GklL1jj99D7W7zWRAbPI6yhPYWhFDsHtJEtiysJe47+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oPy1Lw2WijCiyHlwuqe9pM7kTvZYBzrvFpNnnfwEiE=;
 b=YIspp/bK4rrkHcwW7a9dCELPsfjYJH0bZg19EcxkFlsIMdUra7A2whrP1RoQ5cCyYKa2tAnFhDt2pv06Sb6bd9v0WfjkFsStqTErJl5t5DdArPVD3e4SVD4eXIj4YZ6vpJu+l7v727NKfRUPhgWH0jwoGNfUDvvD0CSfaDYTrUz+o/VaUd67dy5lydEN3sboijGz+lkUVCw1eAm6DdJJWQ/7/Y1G9UEcft62I8sw56jn/8j54JMvMB5u2y7vsXDDpze00QP5cPC7AkIydGb1odqnjnpiAoMCpYDB57dI94GeUzpQefU8j538m1H3ymya1RhGgPZLH11nD3f9dqt6ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oPy1Lw2WijCiyHlwuqe9pM7kTvZYBzrvFpNnnfwEiE=;
 b=LHi+UwsnZuGjKJu5j8YV/pMhxJKvvM68XJJoVEvgn9z9lslIy4PJN2A6SMiSQVqDb9141JFtozyNd+Sald8sEfKSa2el5w7XCH4xW7ix7P7kBt/Gp9YT7diyB/cFmpImFekB+hCXN2MgGLNH4qjW/sPDV5NfW9CrERhHB8aHK3CH0lT/HfpbOpDasNK/dTwUKOiJwQnuFgihPd/hlhEpjdgTiJndx0yvkj5Yd7kJi7sv/tOxl7XchkG9Jgd5y8oiJLXbaHEj4Cg4Mztvw/xmFpqKs9JBa86oUcOhLhuEehaN/gCcxjXZWzh60dg0qeq7eXEqAeT0kBleyPVALzTurg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by MW4PR12MB7285.namprd12.prod.outlook.com (2603:10b6:303:22e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.34; Fri, 10 Apr
 2026 15:57:12 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9791.032; Fri, 10 Apr 2026
 15:57:12 +0000
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
Subject: [PATCH 3/7] iommupt: Add PT_FEAT_DETAILED_GATHER
Date: Fri, 10 Apr 2026 12:57:04 -0300
Message-ID: <3-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
In-Reply-To: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0102.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|MW4PR12MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: ceebc443-5a91-4054-4704-08de9719d2bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	2K9uZd4gqhsJia5jBBoxJYqJeKnCmWuBlW6xsGtZqpXRpz84V9dRbMOygoaLy+2nW8ordtvsAj8/RjCxj/pUZ3TtwrwmAlAdrQAqM+DcqQrczXmaShfU29XK46qbfsMuJqA7gUeyBWqVzr/naxYvZkA4Ylb/V6RwrOMnXlX4YDr95VY7Pk9MhlZnXAPUQ1rOpSAlx3ykna6vduGexsGkCLGMgOzyxoXnh+0zTW/UfTrCgd78ScPpIunDQ1DQiMkZ1uG2OVMlnuXSwXDNv33JqYyU5k8FTkUISOxct6Yd/lOH1gj00V/qd/36VQ2kbnw86ciIto2MBKSIzvHLv6ca8fSxFiXExpaPBv2DB1ocZzCjYTxdgQHDw0pzLudzU6JUEEtKVoggkKF13mPjIZ88uKDjJFUjt1LzPkQOkEDhrNByhQbB+rc3M1aSCI6298FYXUAiytn7ejNgaQh65bzJdwNYlvJASWMN0LC3GxMssjuEYnXOJ5sBGMQdPkDjgHgH0/Ge7dB+UvZkyYxAYiQbjUIYAAjGF8u6YJQXYD6cbtf4N7CCDdveXCFfqrceKw/p9pWeXx6alWz5zT8C50WIMwPpRjRoy0jM6OUr0CBLDhLff6AoB5C4ZD7PkCC5ClQ79YYFL6qYL78uJZA33duZiFKKlNgLJGmnwrmtYLaAyqGWotiLa1psHCInUe5UuKBCYTgPCWs0bnTEqFMD1PFJlTUo0HDgKZFF2dTfE4g5muz7oCl8TkVf3B+7rqLYR3uTr+whH4kxcOM/dvFJrAjV4g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ob6Tx4H6xMpr+soVs8lhzohdNBPlyTPi7nDTvu+QsWAyRwcfGvTkJDTuiIhH?=
 =?us-ascii?Q?QAApKF0y0riXg6RzGiizg0o5yyC2KZIB5ETKYD0kr5T2Ora4fXT435w87Dh1?=
 =?us-ascii?Q?epvTFOrG0/NMlp5ErsHbRFwQnvUT5c4nNVjhhKr1kieat9tTWni+dLHC8eGq?=
 =?us-ascii?Q?03hEmtCrwi4SgkbqSFqJ6GUd61hAlYfln8hivu0ftAAsG7JcPeqiYnn8OCnS?=
 =?us-ascii?Q?eMv+h7pXa1nY/U/LeIIs6Chu/9U4PV7FEc4kzLCv4BRAbaGPs7ndTxHpr5qg?=
 =?us-ascii?Q?sNPFe9QOtGjdoZ6vaaiwvZHMIY/yYatSUH5Zdq0s+HHoSu0VmmnXqF9Ugx6x?=
 =?us-ascii?Q?zoe8Cw4kSyZ08ki0NHY7XOKZnA1chCT/oJFmvoDU/9T2PRKJb/UAvJmbu2L/?=
 =?us-ascii?Q?lDii3UVnMjIplEduMkN3eVSKGiOl77YMh+KbZdHszNLTWnU74Or3Mg1nYTIU?=
 =?us-ascii?Q?8eRRggXb6oofHOGpwUZ/6ijjbaMzuOm7GATFosQmcV3WEVbhJfQVvQFywAzH?=
 =?us-ascii?Q?N2S4AkQ+IaW1pu/elXWKnq7jECN69teXY3DCgsMs2O7k1oZgP4tKelZGItuL?=
 =?us-ascii?Q?5zv1mwxAJvnD/nwuFa3aQMgtgFQKTqgvZn48JCS0rDu6Rs3BOIXqMt7/REkc?=
 =?us-ascii?Q?P1fmfBsyzxCBC8fw00QsWhxsIqoRkEAN5E2jpSsSC3WQXp4dYH3Jg5fc8rDX?=
 =?us-ascii?Q?fQ1Y01hEM+8+HmCkgqpuTMf4tKdnH3qmN2vHY2XI0SLAtqrgcvif0N9+zN6t?=
 =?us-ascii?Q?f1VZP3Fv58IFkXodLqwchWgeI3o+Ec9t354tqJ/R3+xzzsmj0iU3a7kATuWT?=
 =?us-ascii?Q?75vLYFKAdHpx6d8kyX7nZCymVjXBf3btRusgQxl+xbo8owBCiHYwisQ5bwIy?=
 =?us-ascii?Q?PbTmTDegpRVPQmmskwVO4U0Vp51yhWw01W90/DOgYtZg9LQY5clzamHsBepv?=
 =?us-ascii?Q?6G0X94wSwVwpZN7N3ua3iR4TeE2fQY2KmbIHxkeh45pPbIgSmzcP3jeFpDMS?=
 =?us-ascii?Q?I9DBBEQ7WgBwqgakXJskNsWMIx2mGlyhM7e3nAElJlUvgEGUwcZ3BLETcxfJ?=
 =?us-ascii?Q?HkBN1cOzZM15/tBGa41l3VunxzFgj+jyKCu79DOtw69qQD8jCji1FUVJKstB?=
 =?us-ascii?Q?RxQAHFSZPaVSGnjoUpvp00vu/+M84JgQNocFSrMzmwv9w/OG+z9ieH32uH6O?=
 =?us-ascii?Q?vATIfsURB6SPhWjFb/Jb1jMEgPpSjDokafsTUtICGF2FgqK2domaWzEXtouP?=
 =?us-ascii?Q?wiINRJEVOR3yTdTqxRglhZovvzbJ3OMdbfi+HUr/dDsCoAp7iib8tGn1H88t?=
 =?us-ascii?Q?h2mbfzJ1FVlz9rQw2oWgpUfvXTr9WbaZSbPN2KK6HXBLfwPorfxVkmKRFeuL?=
 =?us-ascii?Q?uAEyp/Qmi9G3gCrP/tA/k43cc+VdclyCrx+onYa/iN2mwsysgNAovG7ZtgZ5?=
 =?us-ascii?Q?idiKMKUoKVwvWcRaqeC1eNRelZFKX+pEzh1F/NP62+/pKucu6KiWph1d8PwH?=
 =?us-ascii?Q?PEOBXJdfKlEjSektdKKJT4BeQXOPHRM3o5ZtTf6cMMe1sevLJpL8Y9OuyUr5?=
 =?us-ascii?Q?ggDFniZgq+Vx+NfXjH3xQgitdj6Mq4OjXNi/kwvqAy/GWIvagZ9t7MLb4j/t?=
 =?us-ascii?Q?QDs3gfsgv7n7Mv26K/R9OoBwOW54yd68vdtGmMlaerTOJQhNf/nwMxBa5NAa?=
 =?us-ascii?Q?qSBb7GzMEWOW3ufP7nu/PKpjMan9+wBq2EN5tZfPguBn71qA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceebc443-5a91-4054-4704-08de9719d2bd
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 15:57:10.3757
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D3uly8Cx415IVs4aX72KWd+yOV+PYjfN5BfqTI32EBop7nM2a580OBHfo1QvQ5X5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7285

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
index 47a559616706a1..0abe234fd12c33 100644
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

