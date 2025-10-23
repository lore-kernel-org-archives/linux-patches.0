Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010056.outbound.protection.outlook.com [52.101.46.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DB3348442;
	Thu, 23 Oct 2025 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243769; cv=fail; b=FujxvfE8REVjLJFRuX4SprmdpweqJFv/vB0d7EwZP1j0GL3T4uWjVUXXujjIaaPXT86fDz5t4iuySHWkbQ3KsGhcXRLxcYv6a5CbEX6pRJEZd9m5thn0F6pyMNE/sw59BP1+yjYRNO/HhEl86+RrCAXFiIvqvHvOqokISYPtGFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243769; c=relaxed/simple;
	bh=e8IDXAisKIKnkMxthbzIKVGmHwgNER7Q7CcPwj2zWzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NyzR0ry8Q62NmLjJ1Y6ogpUoKqJzQy9f2mL3M/WChYwJZFz4J1c9++d6pig3TmN7hCzPnSqT89OEQlotKZ/nI5uJZmKVIDN/CD8fDuFwQu9TlMgdPaJWxHEQlhksduQUjtS2MjqbgXi3c/TtUfLXqxZAumY6tlcZEXTqXtf6Vxs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hevoQwBf; arc=fail smtp.client-ip=52.101.46.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hevoQwBf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cACEtvuZVqSv7Dr0PtJohL7haOrXLF1T5F/r8h/WVMZK/JXmHEDXSDjpj4kECuDwdsVdrtVf9CXhZxLVSbuq8xpEjsZJJHLV7NH4ly1EZuk9txsKOjx/Wsu+XF6+RACRUm0W++cPrhysG6NMXKSXeaAnZTeQiAbYQ4z7MnGXi6CTGX/jGD7yLTKXanNQIS/m43kY0MLkOLqhExXwj5yiYGYT0PRFx5RzBDzleNwutN8DzElgjJLMrzh8nYBlg35FqereRTENNHXao4C/2d7QtZkBpdYhRswOHwMzwB8G4jVXXKNHE9tWkp2JLQzfZ4t43oAOvFPYYAowrx/MfWzMKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvcD/Rgd4f9OX2d6UWpMSaIokpfW/USxcH7XNcERiCQ=;
 b=HgPfjz4bXK2BUfS/Ls8mKiOHnV8LIjtRDvldMiFbtWUe+61D9CtivtMld9j590uu79BaZxw1FMbPYm6LSWLK8JeiC4QcCmtR8UHJVy7ljmUptosNIVY/myUneHz5QMH1pnc/tEcP0Br1F1xZLpMHELvjBsjngVlC8XeAbgUUlwEXdJaHIfRudLC/+c1qPt/bUBmGu0rdP7Y+R6rnvGWVGBJj1VT/QvfLJfYx4wr0Y/ocogMyllKNScPtGfB5w6RkIIbFdDdimxL7RBOfIQSJhIZu4LCvziND9uATExhCdzApjtakceKVWVuJguVZw+Yd/e9iEHcvE/xB7E9MH3aoGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvcD/Rgd4f9OX2d6UWpMSaIokpfW/USxcH7XNcERiCQ=;
 b=hevoQwBfckMCnjuePA98j/iI4ZYxBGkVa1Ip3GY6r1PmfZlauXix0k65jDIsT387Z7UV12xE7v/5udeLEqt4AeNPTz9xeWAnwK6h6KWX2sIO82NWJkf3LMeYzC3fbf+6wYsErxiXr8BieP6OX+peMfMcAOc2XNlV4unZXp+b9yBB4XuNLYs4bOjvbVrp+yZW/n3IxPPauTjn4xR3hea5SR6//Ss9TlESq8oYRl2vz+MBAfTU4U3szT4tr3VmeA+PuSBfVE4nubDBnWSdkRcJ/+M9Jrc/mMN/tSbkHKwH7UzA6qU4dTOVRlTrzyAkzVG/0knPmB0S+IcWQ2JZKhJOoA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:42 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:41 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH v3 04/10] iommupt: Flush the CPU cache after any writes to the page table
Date: Thu, 23 Oct 2025 15:22:32 -0300
Message-ID: <4-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:a03:180::40) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: f275cb9e-77cc-49c6-435d-08de126126fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3DcJsqOOKDRqn3QwBTNK5V/tjHBGuPwGk05A5nAZU7ANEfnnC3Gcb3su7zE4?=
 =?us-ascii?Q?sfRJTvw1/nU/S64pbI0w39iBJMTo63kqEvCd9yIN/CaRnNvSA78DpNaAUud6?=
 =?us-ascii?Q?M47fYNwuLed97gX+M5fhFL09hIthQR3LJ4/7dfCxjoh/osgwtF3oBDWQZqxL?=
 =?us-ascii?Q?BD/2ZBv8TqjRoYaot5O544sDX/OcAZ+upDsUKfnA3GBJ4rrE9Q5jhd1wkMR3?=
 =?us-ascii?Q?OxJzr8gCjeg/LmsU4G8NDIH0jZismJJylSxMydYKOHsW1A6NK3QDWGuasgGt?=
 =?us-ascii?Q?BEkyfrKMQCSpN+74EIxhAPsuH821U7k5BkLRCteuMtvNbcsHVpu2Ypyir+tx?=
 =?us-ascii?Q?lfW9HiyrvwRMNqI+I0hUOxB+lbq5pcmR1XAj+xAYhto0yetPfwaNMmeDsPW7?=
 =?us-ascii?Q?11VhqKS3aw1mlgX9rUcURCUg682wFkB5zX+JJjvD/fvstB11JiBF4COOp2kk?=
 =?us-ascii?Q?0Uq3BzSPSC2v87tOSYaqSxXZTHhaI4HULJ1QB/ls66b33KGL8CyY44Pka3si?=
 =?us-ascii?Q?h472x3JM+zNXuRQPeKKBj3xUHr0lHu6TOb1P0iUqV2JYVjwT81ebYgKdOWEd?=
 =?us-ascii?Q?MY3xMijpn/P0O9Kz6z6tZWDuW4biObkZERPGz9EAsRHBvOwIcuQ+152WvMwX?=
 =?us-ascii?Q?uGzeZqsxxrITDfvriWr6MBMPhZPW3GwMmglGxJnbiu+XXH1DiKmaMjs+upNK?=
 =?us-ascii?Q?2rI6BoHuunbRI+/by5D4kW+MUHLa7TWh7mXzq9iO5N6M53UkNwDSm2lUPwFj?=
 =?us-ascii?Q?dnn+oc3qq7eu5JMcHifh4JksTvVBvmHgx4U8fpWaFA1w+OBtfmwTmf1Vm+Ji?=
 =?us-ascii?Q?9HmgHLnBWnVJjiBvsgcZe8JGM6YNAFLFwNaOpOTkNn8UQmpniP0BXyyDCodM?=
 =?us-ascii?Q?kxRVGwdGVCL77WyrllFCJiFMA68ng8QCftYhDbOoasn6DUUFpcaPhRXqjHq6?=
 =?us-ascii?Q?1ssxPY+VPjCc8IJgjoEj38DiyfwHMWK+6FPX0mCqIv3sXZbA5VICRVt1OBeK?=
 =?us-ascii?Q?jvCatmPW0pp7QFiCPx2xisnJAxWLzhvgWopEMAfcTj7vjTZ/CxSkI0seaXP3?=
 =?us-ascii?Q?2w1ei2PaMH/UZwX8OOI5DpYN/Miam7na2wLCQpphZNz4zp8y9kSolMf/cwjf?=
 =?us-ascii?Q?cXkXH/aXyqVNV/EbykGLp+Q1d7EtrjPI5IVxBMY6hEp031gv0eDMcWD5oy3E?=
 =?us-ascii?Q?7+thSV/OCVXfgPHROrzNJupzkf5o4Y4PwRRkZpfMM9r8E0ykBUV2dGw4IPZw?=
 =?us-ascii?Q?QvsBBAuEThdb3DY6qYT7RIDJL0QnkwebTSANAL12qW0/sr89yaZhQZ7eMbpS?=
 =?us-ascii?Q?aA6VzuSViL8/DFCR696gO8Xs6pBDY+Jned0YvCChrz17mz7wmUFMHa+yJMq1?=
 =?us-ascii?Q?DQ8U/QMJ7VJJEIGEbq4sTjr3hN/HdMiPH1O72c1uInULFyBptpqJMTY4vrqE?=
 =?us-ascii?Q?P3MAXo2wa7d9xFHVID5No/uy9MKOiYhv?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?i2oA4tTeGQUUCuaxuk5Ta7h2eua+J9zgSGjKU3/zr1UJXG2M6I9JCYJhKoc/?=
 =?us-ascii?Q?BG6V1myRfr+yGDEJcph6xx4Ru2lA6Jt+wxRWMQeRTIwELaZ2XjltV+WHUEWy?=
 =?us-ascii?Q?XZnZV4mhvt0RIbjJLcmY5p8SyC+zhYT0YmyzTG+A2CDWhWDgFyeyQ3qq27tu?=
 =?us-ascii?Q?fXyOqCQTNQ1rTXUGyxdsH7T+JomzmbCseQHZ6Y7KFYpJ0zwNDILlvuDkScBp?=
 =?us-ascii?Q?S5sY1rz7Ql/Bp7zi74Y+9Msdu2FPJaVwlzNbotuebt4tq6YK6NpQARoNWGUq?=
 =?us-ascii?Q?ouSCM4HgZ7MdZlxHzt7vzeLx1bXS5BNPacBU5jfjf1FNjQTdJ1QqU85yUJGb?=
 =?us-ascii?Q?AluiRB8LLqyqf5FBquSgSwA8Ec/+xJNdMKEQlyVjYQLBP7su2hLdGpZ1MNKQ?=
 =?us-ascii?Q?XoxtjCc0bBEPcOjfANuEy5q+xOVArXD26Bc6M8/BkX4VTVHB+1qsKzifhE8s?=
 =?us-ascii?Q?hipN/pwD6xLHK4OlNscYdVpBQDU5C8Q4U/akewaBw3GlrUgqZKs9k8d41f3z?=
 =?us-ascii?Q?DpyF47wCq47UQH0q9q23FuHpllWOIWNgBdim2zRHSfzOEGnXXXdl3NR6iK7y?=
 =?us-ascii?Q?VkeDnOurvQIBT/i7KPC/+bYi1H1oyajlY0zp2XolNjPDqv9lAlp1McSCnzy3?=
 =?us-ascii?Q?3cAkQOStRkBhR05RmOue33BZhI4tc82wjzQwEr9VSFzYRZEGDA+Fb81+FmBa?=
 =?us-ascii?Q?FHGg/IltN2m0y08mYSuAdDJ3Y8J3Z/t+kBhiBCjCnqjBrusaWN4y5rRxoFPf?=
 =?us-ascii?Q?E33VKaX1yzdXtkZJJgQo6u/fU7TzJTGOOj2xFoERqx3tSYpGNhhSLzqiZDAQ?=
 =?us-ascii?Q?baN9NPul2NIo2b+70BVNp2L0gWcQX7Mph5XqupysMaVf62z4yAuDQtC+N04r?=
 =?us-ascii?Q?GhgXa7kVPE/BHIKGBYH+AcNhD8FrQjRC0bfjrV6AwiiyvPaWkzADe6c6/LQF?=
 =?us-ascii?Q?lKe74KZDBxVwGC3vW84Q6hLiI4JbrBgh/5RMlB25lKqqrGbowXqS/bgKpE0E?=
 =?us-ascii?Q?atLld4ELx5sWDG6LvS4NuBLSZk7dRXLnEhKp7AwPbwtmHDbPWCNqRu6Tn+Nc?=
 =?us-ascii?Q?5QeCIGexxJyHgUTqpg25MYWLqOCLxN4/nwM/rmx0DfMM480C3Ub3aP53gO59?=
 =?us-ascii?Q?bGLPuH+nznRtcmDzGRtBWIG2iloXpN7t5e2i08lTCkskzWyXVmHoiRYptdDm?=
 =?us-ascii?Q?zpnO+KQVEs9V4BuE0ytX+RsSC/9p0lCf0OE68uTajvl2U0W7/Jkn+1mRXTsD?=
 =?us-ascii?Q?oqZ3UFBdm5ot3IPD0e7OvLLqsefpoPcOcQeWo7DYJ0uzEL4HtORab/AyuPZW?=
 =?us-ascii?Q?mBL0tS0YPYG6MwNUY5kODln6nTTdjE8rDKbt8KhkxZXwvbMp8rNzxG3bYqAu?=
 =?us-ascii?Q?ADaaRxYE/rxtVPx4RpsKeuDmvSIj7btu6gbaThmzuwoAbF9X4aDpjUVbGMOX?=
 =?us-ascii?Q?DVt8rVMSmyxZSHxYKjj4YiGqAMBkElLUjrv5dfC4TOIK8ZiXCQazjCy7zniB?=
 =?us-ascii?Q?XLZjR65toTfKMDU29rm677jY6A5aY5AXQeLRr/mYyVRQ2EYhGdO2wpMLe+c7?=
 =?us-ascii?Q?rt3pMaB80HjBZQwTR1SY86hs9TcNSJFECXoyqjTg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f275cb9e-77cc-49c6-435d-08de126126fa
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:41.2207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+OHY7XFBYBfPPKa1l/BBFjdU2efgr//cu1/LTRLffz0OuZNRY2U4Lx6Ep2vvM24
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

Flush the CPU cache for the page table memory after each set of writes to
the page table. The iommu should have visibility to the updated entries as
soon as the map/unmap/etc operations return, like normal coherent hardware
does.

The caches also have to be flushed before any gather can be submitted to
the driver.

Implement the same solution to the race as io-pgtable-arm by using a
software PTE bit to track if a table entry has been flushed or not. If
another thread is still flushing then another concurrent map operation
could return without IOMMU visibility to a required table entry. The SW
bit will tell the second thread to also flush the cache.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h | 65 +++++++++++++++++++++++++++--
 1 file changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 2cad07da995aaa..1dcd85620f9b9c 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -17,6 +17,29 @@
 #include <linux/cleanup.h>
 #include <linux/dma-mapping.h>
 
+enum {
+	SW_BIT_CACHE_FLUSH_DONE = 0,
+};
+
+static void flush_writes_range(const struct pt_state *pts,
+			       unsigned int start_index, unsigned int end_index)
+{
+	if (pts_feature(pts, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_flush_incoherent(
+			iommu_from_common(pts->range->common)->iommu_device,
+			pts->table, start_index * PT_ITEM_WORD_SIZE,
+			(end_index - start_index) * PT_ITEM_WORD_SIZE);
+}
+
+static void flush_writes_item(const struct pt_state *pts)
+{
+	if (pts_feature(pts, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_flush_incoherent(
+			iommu_from_common(pts->range->common)->iommu_device,
+			pts->table, pts->index * PT_ITEM_WORD_SIZE,
+			PT_ITEM_WORD_SIZE);
+}
+
 static void gather_range_pages(struct iommu_iotlb_gather *iotlb_gather,
 			       struct pt_iommu *iommu_table, pt_vaddr_t iova,
 			       pt_vaddr_t len,
@@ -195,6 +218,10 @@ static void record_dirty(struct pt_state *pts,
 				dirty_len);
 
 	if (!(dirty->flags & IOMMU_DIRTY_NO_CLEAR)) {
+		/*
+		 * No write log required because DMA incoherence and atomic
+		 * dirty tracking bits can't work together
+		 */
 		pt_entry_make_write_clean(pts);
 		iommu_iotlb_gather_add_range(dirty->dirty->gather,
 					     pts->range->va, dirty_len);
@@ -406,6 +433,11 @@ static inline int pt_iommu_new_table(struct pt_state *pts,
 		return -EAGAIN;
 	}
 
+	if (pts_feature(pts, PT_FEAT_DMA_INCOHERENT)) {
+		flush_writes_item(pts);
+		pt_set_sw_bit_release(pts, SW_BIT_CACHE_FLUSH_DONE);
+	}
+
 	if (IS_ENABLED(CONFIG_DEBUG_GENERIC_PT)) {
 		/*
 		 * The underlying table can't store the physical table address.
@@ -466,6 +498,7 @@ static int clear_contig(const struct pt_state *start_pts,
 			 * the gather
 			 */
 			pt_clear_entries(&pts, ilog2(1));
+			flush_writes_item(&pts);
 
 			iommu_pages_list_add(&collect.free_list,
 					     pt_table_ptr(&pts));
@@ -523,6 +556,8 @@ static int __map_range_leaf(struct pt_range *range, void *arg,
 		pts.index += step;
 	} while (pts.index < pts.end_index);
 
+	flush_writes_range(&pts, start_index, pts.index);
+
 	map->oa = oa;
 	return ret;
 }
@@ -557,6 +592,21 @@ static int __map_range(struct pt_range *range, void *arg, unsigned int level,
 			}
 		} else {
 			pts.table_lower = pt_table_ptr(&pts);
+			/*
+			 * Racing with a shared pt_iommu_new_table()? The other
+			 * thread is still flushing the cache, so we have to
+			 * also flush it to ensure that when our thread's map
+			 * completes all the table items leading to our mapping
+			 * are visible.
+			 *
+			 * This requires the pt_set_bit_release() to be a
+			 * release of the cache flush so that this can acquire
+			 * visibility at the iommu.
+			 */
+			if (pts_feature(&pts, PT_FEAT_DMA_INCOHERENT) &&
+			    !pt_test_sw_bit_acquire(&pts,
+						    SW_BIT_CACHE_FLUSH_DONE))
+				flush_writes_item(&pts);
 		}
 
 		/*
@@ -597,6 +647,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
 			return -EADDRINUSE;
 		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
 				      &map->attrs);
+		/* No flush, not used when incoherent */
 		map->oa += PAGE_SIZE;
 		return 0;
 	}
@@ -736,10 +787,14 @@ static int check_map_range(struct pt_iommu *iommu_table, struct pt_range *range,
 	return 0;
 }
 
-static int do_map(struct pt_range *range, bool single_page,
-		  struct pt_iommu_map_args *map)
+static int do_map(struct pt_range *range, struct pt_common *common,
+		  bool single_page, struct pt_iommu_map_args *map)
 {
-	if (single_page) {
+	/*
+	 * The __map_single_page() fast path does not support DMA_INCOHERENT
+	 * flushing to keep its .text small.
+	 */
+	if (single_page && !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
 		int ret;
 
 		ret = pt_walk_range(range, __map_single_page, map);
@@ -842,7 +897,7 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
 
 	PT_WARN_ON(map.leaf_level > range.top_level);
 
-	ret = do_map(&range, single_page, &map);
+	ret = do_map(&range, common, single_page, &map);
 
 	/*
 	 * Table levels were freed and replaced with large items, flush any walk
@@ -944,6 +999,8 @@ static __maybe_unused int __unmap_range(struct pt_range *range, void *arg,
 	} while (true);
 
 	unmap->unmapped += log2_mul(num_oas, pt_table_item_lg2sz(&pts));
+	flush_writes_range(&pts, start_index, pts.index);
+
 	return ret;
 }
 
-- 
2.43.0

