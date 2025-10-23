Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012061.outbound.protection.outlook.com [52.101.43.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72A0F274B55;
	Thu, 23 Oct 2025 18:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761243776; cv=fail; b=IfYC1RF7gKWHlXmZq88Et23libiJrHZ2dwO450iYGghZr4JX8WV+wlnRpGHnlo+cScU++YxYNhu/iI+zmMa+d6qGNsI8NJ60h4ttJ/H9IxoaAAmVNqxhpYjgL+LmX9HudhzRWNH/zukJAiWYu0Xpc/LlZ6gTtdToFYCpU5Qc4f4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761243776; c=relaxed/simple;
	bh=0Ow6WIfum05+NV3s07cmJJK+Q9RrZACZ1BJAdc+Fu6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XcaDlSVMeUwnn1goF6TWscahLtDAyH1ixOEcNfOAMfJLKnGR6XdWKUOaN71EuarupJ+pGdG601noPiYWJxK9kJtznjch15jzxxbY1gRXiDSW4diOIpzz9eXXo2rrFM+5AsmcmieaD8QTy41iE/a2AFD7e+LjNqeNh7twjYe2DW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NbpiqdGF; arc=fail smtp.client-ip=52.101.43.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NbpiqdGF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yud/ZHGp0BVpgBkKlW1z99MvpgDGKS5rwMJfQpI/nJuQoVcn83BsDxgLFNrNYyTaSQ7NI1xXifFk/gLB8AaO5+ydTKYMnB2UfUjcc3SiwUvfCypKewr2PUfxZcB/4eZDyOqjtxjjDz+eJxLbbio/vku5sKvUL+3RapPV/5evAPDHCtnUHFzzFx6zOl3uK07RQr1XRNzCGtLX/nyu+69lRDdhYIrhN0S5eo1fxTvVueH/Hq5z+nQrqfeup2ybCjx+9+/e9MW3dELyIz76LizQBFObaSST1tPiGHCzRPLDzPGNGPOR2zMhXpg/aen6HXRYaa3InahN2fHDwqMW8Pk19g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zi0O33gDe6E0FzaHccrT+TUdHQKM8LVf5va5yaENw/k=;
 b=NsePNwZD94KDYWzMd4cqrDDfJxLmdznYELPF2RGbjCgNLvd/56Y1qMSO4L5Xn9GG6ZGzwBYRqJ/jr+qcS1qcjisHQHGdUOxIG39gHnNgZ/IfMIl2fPn5/lPIh0fhSxD3U6WgAmeh5Pnyj2uN4jPoo/3P8d2sdhmJ3XCXt2uYt5HM2xHESeq80KmGGB7/pcsluzznMpO0QeKsOX0mP79TBNV0v4wVF0BwwxoAm/MPTeJgrme+fSBDGdVvb+c2nmN0QWoWOkIo9gi1i4C/7u4Tek+YA5f1SItxoz5Ryf3fkXVAs/wF1/BghfyH65yoRdh0PffTRhVQpotDPdRYPHXCLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zi0O33gDe6E0FzaHccrT+TUdHQKM8LVf5va5yaENw/k=;
 b=NbpiqdGFnhQQYoXACniqMCgtVXU2KRtbxVI5sZH7KqYNraF+9G2T6clql43GkE0WiWkbuoUXK3m1wbQQinRjj9K+kLnuWHmifjdfriA863aKy5MA3SmkmcfVuusKMoG5nz967dJISUs3hVSCYtYXPZPRqGQbkbkHRxebKehGeDy3GQwe6Fh0HbmgAHR1zxZGi24+lXB1K6AmrwD3uDLW9UEHedgr+4yc5fkGbIpzXCaSAMDdIE9XNBIleJ5K+OTaL2Di9uTRwANOxe6cqSpemh/DQUz5jbNdR8LAXPqaiDVzCGE1H1ySsoNGfMzJCjiDMddwgOhHVgRHJPwVdkVRMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by IA1PR12MB6164.namprd12.prod.outlook.com (2603:10b6:208:3e8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 18:22:46 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 18:22:46 +0000
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
Subject: [PATCH v3 03/10] iommupt: Use the incoherent start/stop functions for PT_FEAT_DMA_INCOHERENT
Date: Thu, 23 Oct 2025 15:22:31 -0300
Message-ID: <3-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v3-634ccd3efce0+16d38-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0172.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::27) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|IA1PR12MB6164:EE_
X-MS-Office365-Filtering-Correlation-Id: 8350244c-d2a5-4521-fac2-08de12612a20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hyHSqIVm1bVWz1ase2uVC++zf7iuPe6FTRwzRb8lYhvXpeuplwzlHyTilnxl?=
 =?us-ascii?Q?EzPnyo3Q1IR85RJl7v+C7r/+4RQXfUyS/x5YuqX2bkDujWevfxRpgQv3ta/T?=
 =?us-ascii?Q?O8k201zFWu1u5nfPmHQ70l9iSs31T2s/9I4WoHY8SMPtOO2Sb7d7ZgMaL0HZ?=
 =?us-ascii?Q?vaKiiqmzUo6hhtJF9VZX3ukckxje+Reku2HLwTpyKR3dhBCecCp/el0bxru3?=
 =?us-ascii?Q?vKGBypx+Rrt5V8sJOHTMpR+mtwkQ0hjsq7jVZd0GRRC7z9ubsIwDNTf5TPa6?=
 =?us-ascii?Q?ZuwimgpFSDRMaOrOZctCzTAFhuKn82PgtnMUuVXfIDttpeDp2b5g2nm/43qU?=
 =?us-ascii?Q?mvguPaxwg8qw/5TNrQ03TWWw+pdQmAzMYtylNxduZuAzr6EP2x6fv01gh7Pi?=
 =?us-ascii?Q?dptGz1wJ9RZHfpV1t4iY2O0Xm9ur9ooF5a6Mk/7RJ/hOgRGaXKTT9IAqEXmq?=
 =?us-ascii?Q?HSAaDTRbh+AvwNTelsrBS6Zwmq7uMTNWN84C80AwME0ruf+bITXRmkb0Us+5?=
 =?us-ascii?Q?uqOMuRQqHCyBttHsOivmvDThZKHkqPdmng+Y7fEE1T4L9W+7cyv4vvZ74iDf?=
 =?us-ascii?Q?oPQ4O+2nCPsJk+iMKlWUETqZANLEiXOB8B6LxxOtsY6d91heHSSuvlWYKvtP?=
 =?us-ascii?Q?RptXJzM1xLDGp/ugRF5y5KnPoWWWCxzGJ5zgmPJF0w2S1RcdAEfHnKs+cePP?=
 =?us-ascii?Q?49sHySbdLCJx7NkKwlfzQZCX3qDz0t/C99dJiCLoqEzPSpdJFrvWo/JJkK/r?=
 =?us-ascii?Q?vPCoad6LUckw+Ud0AuBIVVmFWOD9ZpXfSAz0LCikypJuHvWkyCQNvMkCsLzQ?=
 =?us-ascii?Q?SqZirV29gA5z5B8jv11mORH6lsIlvUU7stuk9WmHEy/uK0KItS1oY5LADsuN?=
 =?us-ascii?Q?0YajLqgDrRpZZo+uNSL+zjuvwdkljcqd2aofHL2A66XIBA2Ibt6pSHKR5/DB?=
 =?us-ascii?Q?2P9fYIJ0BNVqt8l+uvTQ0WskNv5w9RlR1QsTAlFB34YySRZiiF9rmm7TS9FF?=
 =?us-ascii?Q?36PxaXK/AtVRx31lYNcTYSaGsRTJSZ8ld7Ir5Vp70kcslwpa6LmovDOGjHrM?=
 =?us-ascii?Q?bqpA92um3s6GuhlmafICwy3D40ZnzdxYUIwQIAMsv02ZIURX4JXvFTeSFC90?=
 =?us-ascii?Q?MUNj1+q8LdwjQ2nBr2g75yXd4qdUbGn3Bl33D6esexuDEwxekznHPx2ZmPfN?=
 =?us-ascii?Q?Dbw+OumNZIj/5RSX+iuVE0ABJTBwYyJ6H9KSbmjddQAG8DjWFLokAglncoCH?=
 =?us-ascii?Q?XSPq7gZLB7j6GNoMz0BtAfe6NZN82U9gn+QJW7i5G2uPKrUV55IJ6FPIkVSq?=
 =?us-ascii?Q?Z4a7cIJdKHqTv6RLYjRjxzb9a7IpOP9bqw9ktFMZnt/71q7g9vrQejScr5nM?=
 =?us-ascii?Q?tCxtKw0vc/3e9kXSwHdJQ9QvCC8QWHpBG6BnW+Mhw3xB648q/iR9uBRM3pJW?=
 =?us-ascii?Q?AiPc33dSPjC2+F/4HrEX92l1XfzhP0ea?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vb7Qx+CywHYuVZd6yyn/PMG2PmpMUI8jNoKzcMrNbOiZz1hEA2FLXGrxcoYm?=
 =?us-ascii?Q?zqkYXeistbO25ULQTVOriH3V4z/wSu6SdSRKYQRk7H20iHnqVIhELiOeDY3q?=
 =?us-ascii?Q?jVggFGEIS3EQFeMuI10kgg5C3/kS0HGlFRGqD/y8IrRkITQ2ptLoun+sdBII?=
 =?us-ascii?Q?vlacsX1w/jcKQDuMSOQUIrdLVOv9sEtlhoMtnIJjiUe4An787YJLEMmVrO0k?=
 =?us-ascii?Q?11Tq3w5vb9KXlD9xjMw8ChVoCbgmCjBmi5i7uDiJTCv1iaq5fGnT+oVt1C3K?=
 =?us-ascii?Q?tghjCsxnuzeuW2OXTMrIwE5zNvFXh8ygRW58Ys6lspVXcHKPM3lSGDpQCdZK?=
 =?us-ascii?Q?YQZ9iPzBuvBcDav5LeZd6n/sgPdvVZJEblIKqoT+ia/zTVed3fUIbBkQCDpU?=
 =?us-ascii?Q?RlLTpqUrjdjH1YV4F5myFf3HbO62+VJ5UTPuPqsKYThIfln7RTvl7qnxDCQj?=
 =?us-ascii?Q?87we80kPgVtjb4vmTWICJ3Le+BFch3uhFmKs512ZVWx72MRnbUmkwLUInHcI?=
 =?us-ascii?Q?FiNdL0VG6uQvSDQKVrO+DlPOdxesWX2+18PcEsLh/WA/XmNT+IwbDyaGhTZ8?=
 =?us-ascii?Q?+7NJPxALgYvQuR/QNkGViubNuaLG7Q7dKf2WV9YByk83zaQSaxrRzWdNL+D/?=
 =?us-ascii?Q?YC4X1BaLhO06PugFIWlELXhsKSu3zT+OqaExV/0qT3P320DOdTOGSt96Mefl?=
 =?us-ascii?Q?enZrwYWwECNtf4xAkKjz5xUHqlzyEssjnkWdsURgyocuGq6gGlkhPZKYlBhE?=
 =?us-ascii?Q?YNmk/Xx3ckce75aBohp+UtY5v8LsAPU1nDl3Zk2G1g3bNF722Kv5rZmCq9/b?=
 =?us-ascii?Q?dXrREKTkZt45kdyijZPgVsk5WNrjoL7ocRUS6Ki4KVyd3pEj/1EXLLgKgGjB?=
 =?us-ascii?Q?9w0lzDN3gu6b6fThCPhxdje0MuM0HMWvKba7pYAMirvDbPreQ8oD2h2Ge5Qw?=
 =?us-ascii?Q?YVuDI5ivucvd9tDgKJXyMISOqYxr+rm4HtZsmBRmBVe12w1MwF03FF5/v7Lz?=
 =?us-ascii?Q?K6GjLfWKbralhXjsOxcAZY/uN0AbEnkNsjzseZMDRO69BZdmVIJitQEJKDbk?=
 =?us-ascii?Q?B/qjw55vyUlAHWXDGYlyPhWi1ettaiXTirbVYRTAfF86EeczHmuhXet7m0zI?=
 =?us-ascii?Q?koqIjMIhpGk9sQRNLlRKS66FUDb5LgAqQigYpy7aqxYAnIh/3Bknfz+v3cuv?=
 =?us-ascii?Q?Zpkd4REUAUzvm2hiiZUWDIZgio8BjC/FLbP2cN5V8uFiVfdwV26+/8qdeM9I?=
 =?us-ascii?Q?RedMFm1lxKMP0eXzuy065FljskiUhgXrzgGNWgqDaxnPRYryik0iLVlA7265?=
 =?us-ascii?Q?rK4Vs2MKcPMreHAsz2/Bnvcqzv003sVsvPUT6yPYIUhBPp++ePxlBaVyuKg/?=
 =?us-ascii?Q?9UtoKVgW48Mv4bNHL130dN8IVOIIPZxjkvlG+ImzUtP0RK8sltB+t7hyPLuy?=
 =?us-ascii?Q?Z/GUcqIqpRlPa+BPEKOFwW/vJ12snFJB4TZa0JVw00FoqWLl7pduHzuCDb9E?=
 =?us-ascii?Q?ZH5L/GP7Zx2hmZe72DzcDWBAmsVLLEyGdisc0VJlKWqXPDastJjZm5DB13d9?=
 =?us-ascii?Q?Pg1Ng6HXSyD5jAQyKEBdnSwHgvX5wUgvA6eAnn5W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8350244c-d2a5-4521-fac2-08de12612a20
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 18:22:46.4439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QmUyAZhUyEZYu3pQ7l1FqqIpGd0DHFwQqS3MtS3Rpldfw3Bm5dRSVHOIXDGQIya9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6164

This is the first step to supporting an incoherent walker, start and stop
the incoherence around the allocation and frees of the page table memory.

The iommu_pages API maps this to dma_map/unmap_single(), or arch cache
flushing calls.

Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h    | 89 ++++++++++++++++++++------
 drivers/iommu/generic_pt/kunit_iommu.h |  1 +
 drivers/iommu/generic_pt/pt_defs.h     |  5 +-
 include/linux/generic_pt/common.h      |  6 ++
 include/linux/generic_pt/iommu.h       |  7 ++
 5 files changed, 88 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 142001f5aa83fd..2cad07da995aaa 100644
--- a/drivers/iommu/generic_pt/iommu_pt.h
+++ b/drivers/iommu/generic_pt/iommu_pt.h
@@ -24,6 +24,10 @@ static void gather_range_pages(struct iommu_iotlb_gather *iotlb_gather,
 {
 	struct pt_common *common = common_from_iommu(iommu_table);
 
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_stop_incoherent_list(free_list,
+						 iommu_table->iommu_device);
+
 	if (pt_feature(common, PT_FEAT_FLUSH_RANGE_NO_GAPS) &&
 	    iommu_iotlb_gather_is_disjoint(iotlb_gather, iova, len)) {
 		iommu_iotlb_sync(&iommu_table->domain, iotlb_gather);
@@ -329,35 +333,55 @@ static int __collect_tables(struct pt_range *range, void *arg,
 	return 0;
 }
 
-static inline struct pt_table_p *table_alloc_top(struct pt_common *common,
-						 uintptr_t top_of_table,
-						 gfp_t gfp)
+enum alloc_mode {ALLOC_NORMAL, ALLOC_DEFER_COHERENT_FLUSH};
+
+/* Allocate a table, the empty table will be ready to be installed. */
+static inline struct pt_table_p *_table_alloc(struct pt_common *common,
+					      size_t lg2sz, gfp_t gfp,
+					      enum alloc_mode mode)
 {
 	struct pt_iommu *iommu_table = iommu_from_common(common);
+	struct pt_table_p *table_mem;
 
+	table_mem = iommu_alloc_pages_node_sz(iommu_table->nid, gfp,
+					      log2_to_int(lg2sz));
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT) &&
+	    mode == ALLOC_NORMAL) {
+		int ret = iommu_pages_start_incoherent(
+			table_mem, iommu_table->iommu_device);
+		if (ret) {
+			iommu_free_pages(table_mem);
+			return ERR_PTR(ret);
+		}
+	}
+	return table_mem;
+}
+
+static inline struct pt_table_p *table_alloc_top(struct pt_common *common,
+						 uintptr_t top_of_table,
+						 gfp_t gfp,
+						 enum alloc_mode mode)
+{
 	/*
 	 * Top doesn't need the free list or otherwise, so it technically
 	 * doesn't need to use iommu pages. Use the API anyhow as the top is
 	 * usually not smaller than PAGE_SIZE to keep things simple.
 	 */
-	return iommu_alloc_pages_node_sz(
-		iommu_table->nid, gfp,
-		log2_to_int(pt_top_memsize_lg2(common, top_of_table)));
+	return _table_alloc(common, pt_top_memsize_lg2(common, top_of_table),
+			    gfp, mode);
 }
 
 /* Allocate an interior table */
 static inline struct pt_table_p *table_alloc(const struct pt_state *parent_pts,
-					     gfp_t gfp)
+					     gfp_t gfp, enum alloc_mode mode)
 {
-	struct pt_iommu *iommu_table =
-		iommu_from_common(parent_pts->range->common);
 	struct pt_state child_pts =
 		pt_init(parent_pts->range, parent_pts->level - 1, NULL);
 
-	return iommu_alloc_pages_node_sz(
-		iommu_table->nid, gfp,
-		log2_to_int(pt_num_items_lg2(&child_pts) +
-			    ilog2(PT_ITEM_WORD_SIZE)));
+	return _table_alloc(parent_pts->range->common,
+			    pt_num_items_lg2(&child_pts) +
+				    ilog2(PT_ITEM_WORD_SIZE),
+			    gfp, mode);
 }
 
 static inline int pt_iommu_new_table(struct pt_state *pts,
@@ -370,13 +394,15 @@ static inline int pt_iommu_new_table(struct pt_state *pts,
 	if (PT_WARN_ON(!pt_can_have_table(pts)))
 		return -ENXIO;
 
-	table_mem = table_alloc(pts, attrs->gfp);
+	table_mem = table_alloc(pts, attrs->gfp, ALLOC_NORMAL);
 	if (IS_ERR(table_mem))
 		return PTR_ERR(table_mem);
 
 	phys = virt_to_phys(table_mem);
 	if (!pt_install_table(pts, phys, attrs)) {
-		iommu_free_pages(table_mem);
+		iommu_pages_free_incoherent(
+			table_mem,
+			iommu_from_common(pts->range->common)->iommu_device);
 		return -EAGAIN;
 	}
 
@@ -389,7 +415,9 @@ static inline int pt_iommu_new_table(struct pt_state *pts,
 		pt_load_single_entry(pts);
 		if (PT_WARN_ON(pt_table_pa(pts) != phys)) {
 			pt_clear_entries(pts, ilog2(1));
-			iommu_free_pages(table_mem);
+			iommu_pages_free_incoherent(
+				table_mem, iommu_from_common(pts->range->common)
+						   ->iommu_device);
 			return -EINVAL;
 		}
 	}
@@ -615,8 +643,9 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 		}
 
 		new_level = pts.level;
-		table_mem = table_alloc_top(
-			common, _pt_top_set(NULL, pts.level), map->attrs.gfp);
+		table_mem =
+			table_alloc_top(common, _pt_top_set(NULL, pts.level),
+					map->attrs.gfp, ALLOC_DEFER_COHERENT_FLUSH);
 		if (IS_ERR(table_mem))
 			return PTR_ERR(table_mem);
 		iommu_pages_list_add(&free_list, table_mem);
@@ -633,6 +662,16 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 		new_top_of_table = _pt_top_set(pts.table, pts.level);
 	}
 
+	/*
+	 * Avoid double flushing, flush it once after all pt_install_table()
+	 */
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
+		ret = iommu_pages_start_incoherent_list(
+			&free_list, iommu_table->iommu_device);
+		if (ret)
+			goto err_free;
+	}
+
 	/*
 	 * top_of_table is write locked by the spinlock, but readers can use
 	 * READ_ONCE() to get the value. Since we encode both the level and the
@@ -665,6 +704,9 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 	return 0;
 
 err_free:
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_stop_incoherent_list(&free_list,
+						 iommu_table->iommu_device);
 	iommu_put_pages_list(&free_list);
 	return ret;
 }
@@ -988,6 +1030,9 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 	 * The driver has to already have fenced the HW access to the page table
 	 * and invalidated any caching referring to this memory.
 	 */
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_stop_incoherent_list(&collect.free_list,
+						 iommu_table->iommu_device);
 	iommu_put_pages_list(&collect.free_list);
 }
 
@@ -1078,6 +1123,7 @@ static void pt_iommu_zero(struct pt_iommu_table *fmt_table)
 	memset_after(fmt_table, 0, iommu.domain);
 
 	/* The caller can initialize some of these values */
+	iommu_table->iommu_device = cfg.iommu_device;
 	iommu_table->driver_ops = cfg.driver_ops;
 	iommu_table->nid = cfg.nid;
 }
@@ -1123,11 +1169,16 @@ int pt_iommu_init(struct pt_iommu_table *fmt_table,
 	     pt_feature(common, PT_FEAT_DYNAMIC_TOP)))
 		return -EINVAL;
 
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT) &&
+	    WARN_ON(!iommu_table->iommu_device))
+		return -EINVAL;
+
 	ret = pt_iommu_init_domain(iommu_table, &iommu_table->domain);
 	if (ret)
 		return ret;
 
-	table_mem = table_alloc_top(common, common->top_of_table, gfp);
+	table_mem = table_alloc_top(common, common->top_of_table, gfp,
+				    ALLOC_NORMAL);
 	if (IS_ERR(table_mem))
 		return PTR_ERR(table_mem);
 	pt_top_set(common, table_mem, pt_top_get_level(common));
diff --git a/drivers/iommu/generic_pt/kunit_iommu.h b/drivers/iommu/generic_pt/kunit_iommu.h
index d541235632aa69..5d4f269627d574 100644
--- a/drivers/iommu/generic_pt/kunit_iommu.h
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -139,6 +139,7 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
 
 	priv->fmt_table.iommu.nid = NUMA_NO_NODE;
 	priv->fmt_table.iommu.driver_ops = &pt_kunit_driver_ops;
+	priv->fmt_table.iommu.iommu_device = priv->dummy_dev;
 	priv->domain.ops = &kunit_pt_ops;
 	ret = pt_iommu_init(&priv->fmt_table, &priv->cfg, GFP_KERNEL);
 	if (ret) {
diff --git a/drivers/iommu/generic_pt/pt_defs.h b/drivers/iommu/generic_pt/pt_defs.h
index 819057de50d82c..c25544d72f979a 100644
--- a/drivers/iommu/generic_pt/pt_defs.h
+++ b/drivers/iommu/generic_pt/pt_defs.h
@@ -48,13 +48,16 @@ enum {
 /*
  * When in debug mode we compile all formats with all features. This allows the
  * kunit to test the full matrix. SIGN_EXTEND can't co-exist with DYNAMIC_TOP or
- * FULL_VA.
+ * FULL_VA. DMA_INCOHERENT requires a SW bit that not all formats have
  */
 #if IS_ENABLED(CONFIG_DEBUG_GENERIC_PT)
 enum {
 	PT_ORIG_SUPPORTED_FEATURES = PT_SUPPORTED_FEATURES,
 	PT_DEBUG_SUPPORTED_FEATURES =
 		UINT_MAX &
+		~((PT_ORIG_SUPPORTED_FEATURES & BIT(PT_FEAT_DMA_INCOHERENT) ?
+			   0 :
+			   BIT(PT_FEAT_DMA_INCOHERENT))) &
 		~((PT_ORIG_SUPPORTED_FEATURES & BIT(PT_FEAT_SIGN_EXTEND)) ?
 			  BIT(PT_FEAT_DYNAMIC_TOP) | BIT(PT_FEAT_FULL_VA) :
 			  BIT(PT_FEAT_SIGN_EXTEND)),
diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
index 10b8250659b98b..3f80a3889ecc30 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -85,6 +85,12 @@ enum {
  * position.
  */
 enum pt_features {
+	/**
+	 * @PT_FEAT_DMA_INCOHERENT: Cache flush page table memory before
+	 * assuming the HW can read it. Otherwise a SMP release is sufficient
+	 * for HW to read it.
+	 */
+	PT_FEAT_DMA_INCOHERENT,
 	/**
 	 * @PT_FEAT_FULL_VA: The table can span the full VA range from 0 to
 	 * PT_VADDR_MAX.
diff --git a/include/linux/generic_pt/iommu.h b/include/linux/generic_pt/iommu.h
index afe6e581f12f96..574e5f46200b74 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -57,6 +57,13 @@ struct pt_iommu {
 	 * table walkers.
 	 */
 	int nid;
+
+	/**
+	 * @iommu_device: Device pointer used for any DMA cache flushing when
+	 * PT_FEAT_DMA_INCOHERENT. This is the iommu device that created the
+	 * page table which must have dma ops that perform cache flushing.
+	 */
+	struct device *iommu_device;
 };
 
 /**
-- 
2.43.0

