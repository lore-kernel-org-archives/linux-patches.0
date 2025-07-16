Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2067.outbound.protection.outlook.com [40.107.212.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC712BCF5C;
	Wed, 16 Jul 2025 19:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752695885; cv=fail; b=fx6WQTOvsxX3eIWz14cIQ3TmtMy0KwiPcRrqfAme8OZe0HZLOFWnK4yeL4G1DkX90SVJn0XuAhcqfZvTSAe30uw8bq8fHjxPAxX4soyu4dQ2W3g4zJO06oZQaz3HLLFX6KTXyhamvC6se4kY4b13rg7xSn0fq0opk0Zkexxjm0Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752695885; c=relaxed/simple;
	bh=IEj9EpxuliXfiVTd43ldgAUsoaDSj9dtOBuXtxWLERQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZUhoC0J/K9TR/ptWTvkZXjX6i/gbWqxC5nr5HODUeRAh9dG/70EHDUSf++2YGTzjmdYgMxeD9zsvCquv/wBqRtbV4b+Og+13jdQn0ylBZ2l59KeEjXqwJ5Dv43YVg/YKP13EhKviyyzoFn2qn4Ea1O/bUz5kbJrBWVjhPbgLqDY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iqCIcbmm; arc=fail smtp.client-ip=40.107.212.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iqCIcbmm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gbLFb91moFvWKHge6qCfLBTAIcYwudObm3uu1pguIcXb/ZUJbSYbl5tEyu1QMoU62o13GrL72CzWLGDhXH8wSHxUY85GdofvPV4h0bZgeG6drHGF248DAea6kUkFMMHRvhGy8haNdywRoLL5YCPTw/HqYq/U3rnyr/deHdx69svOtp/YI55oNF+JXHF0dtUoC5xRCW9CCDQOEP7EVBdahVIheP+rGcmLRVzDPDAO7XtkzH3svPqzlGXMqottuV9nqqpKJTJ2MkTAx1AbXvSbkdPxqcc/eqvK9lGus6505kN8oXZwLbD6q/fsneUam7VRmbCnrJ8AOp5eEwXCsLVeoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PXXgN97f3DqfCFvyDUM3ILxUjdZ4LwOYDAm2GxHLa54=;
 b=xlfshZMbypmzEwvgonLTRp+x4WSs2edcnwL8dhHm9jULt+hSihaBt93o4nSEPzAwFOML3oMhH1eXjsIraDS8fksqQSt27q2VLBe30LMLq82h8wxqtvt+cLPSWV5GRgCD2eCzPC0RMtGmyko2JU7cTbHzcBFjSY2ak6xl96NodKe5Hd8T92YXzhKjvj0oA4xWNNZ5tYbayWOyWVcz/SIBd/nR4VT/Gao886uFquTd7Z40tXvzfKlGrqqA1jCKXKK/Z9WlpGJAZVgw1VbYsrvJFji+r2nETzd/zjArZbriVR2RCttY+YDw+IcnzHQ+Nh5syyRlDfoUS1X9dPgQAA4gkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXXgN97f3DqfCFvyDUM3ILxUjdZ4LwOYDAm2GxHLa54=;
 b=iqCIcbmmRMBCYBVUCUEclpww1EuXACS0T0zyhPqRI2C8IQ6H2XWsMplfjoAdMD4i5UVkqgxNaseVFTF90v6FkcC23ZTEaJApa+LNP2VA7YgBGcmaW3edMyIUgPOF07pGmkfkrFM0G6hPkGpx6QbfcoCCjeO5rZLpZLmfk6KVT0/11lvRc3Ga7OVYoya2+MkKdZIlSNWzlTaxx9pB/KvPMMDGOLAfnqBJ1X2Icr1axo5DOPM4TpFX3BjKb83k0Q+tALjbatTBxGiSJ8LcZtcb1cDJabAM63CA9zz71MLGQETv2pWItmjGS+nlHon3t1VQb5kRvhiyoJmfWMvgVsXTOA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7560.namprd12.prod.outlook.com (2603:10b6:8:133::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Wed, 16 Jul
 2025 19:57:52 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 19:57:52 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: [PATCH 3/9] iommupt: Use the incoherent start/stop functions for PT_FEAT_DMA_INCOHERENT
Date: Wed, 16 Jul 2025 16:57:39 -0300
Message-ID: <3-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR12CA0029.namprd12.prod.outlook.com
 (2603:10b6:208:a8::42) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7560:EE_
X-MS-Office365-Filtering-Correlation-Id: 5feb31a6-ade3-409d-3551-08ddc4a30b08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xu82SKutohdJeCp9apkHbkFmrOMkbLMoau4VXWtbAn2Mhhyp2W5XbPXZCZt5?=
 =?us-ascii?Q?/0hlXrv4e16q9jQDLWLKjCIHETwH1UpWfuuBDMQXGc711cz8kKi81s0NkGD/?=
 =?us-ascii?Q?F6GVz1bKWk+YoxYeb62cRXQVdUgMkuKINQsUnT+4PgwgHfS1/mrz1U20+tS8?=
 =?us-ascii?Q?IwfKd0y+AYOluvjaFVa0hpnsTAPJHy5F6swhAVJM/cy058zaCWqniF0YDzL1?=
 =?us-ascii?Q?zmCWcbJh10iycu5O97nmO94pykDJiYQV81LqUaNeMR2SG1+cPypIcdtXjQFx?=
 =?us-ascii?Q?YaIDm9PX/WmQd6kPRIf/m5Fg/QfjdOj11PNrh99cpl/TR3Lwdi1C7OU5KIpn?=
 =?us-ascii?Q?68u3Q/gSi5pqx16Xlq9We8BYIaIW0czikC2RBTXsK+NeHt8Wlz5FZV6mDCg6?=
 =?us-ascii?Q?1WuzQ+CPanvB3uSVCTMdGL8dlYBriBydr7cQ0IWz8Bz8cc2zfmA+oKlnL0Cy?=
 =?us-ascii?Q?LUshFXY9sb/2RovDrU6MT248fd+RncZIULktgMRU4L5COBPfjbf2S5OD4ln2?=
 =?us-ascii?Q?/gtb06lOMj5UnjX+5CUpjkuiQqQ9azpeFLcHwq5x2K/YS9obcLA0ztTzS5iK?=
 =?us-ascii?Q?60uWKUVe6WMPW18xTcsPyPkySnAbqNqRZUpTPVQ5yDGu3R1dIspAU1js1NYP?=
 =?us-ascii?Q?96fmZ702+FkgdKb2RODToYTC6AmBNUhheJTHxFgeiBjVN43ShT0yLaBwROl1?=
 =?us-ascii?Q?C0MxBRDwf4V3DjbA9cYPzjNAjMAbSmKr/Gz2K73L16dihxVO+4pOT4rhCUIY?=
 =?us-ascii?Q?KBFefSZFZZl/qe6x+nLGmaDXVEdbSHWIpTPgYuIyHfSJGrKr0XnigvV3h6Bd?=
 =?us-ascii?Q?Y53wm5xn88RsZzmVQjso63ncyCz9tNotlAuLqAadSsaIi7EQso/WP4fMsGRw?=
 =?us-ascii?Q?B1tkQskDZvdPR9mTMZ3KgMQYy6zw0pJF0rKBVPrivp6QWqYEvmCYUNBAT4LC?=
 =?us-ascii?Q?fVJ2rnm+qQHdERV/3CLE7RUyDUrGQhmn8viZ8EeAwt+dQNaZiQRcHNrrJHND?=
 =?us-ascii?Q?1Exo/b3qddr1MtGidR2tlxUBNUfwZniZ27TSstCmElbr2qFmVc0K3aokpcsq?=
 =?us-ascii?Q?TJsVgvbPjHT1tBK2Mcvr7WK0UY6IkWLaOFw366NNykuQAO678XRYZzm5yauD?=
 =?us-ascii?Q?XBhE3Zxaq02d/5MoAGmR91Ic9jHgDEbLK9GwYrSRZ4c7QhvNp/zAKwy3vF+Q?=
 =?us-ascii?Q?u/W+rsuNZTr6wTivJX4ftk3HSKd2w2LFe7y+oEIZmOSciadivxIndb69EvBt?=
 =?us-ascii?Q?acvl5KSjOJ91ofj+bom3rNKMe3rGQ5B1gWJqKs0hbKflecG9fsO2z4SFlPnd?=
 =?us-ascii?Q?nCVg6QF2mFcfja0c30WeyMYsTZiiCZEez/ziT84LI7ih1WguwTQbF2pFCgHr?=
 =?us-ascii?Q?VGyagQqLdYhdRZqzbBD7MjQpZZimjvxpDGPnAmzMm0FzT7IGBwQgTNUtDILn?=
 =?us-ascii?Q?caZ3Q//2+PM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/cSfYijLc+gLSlvZssKN/IpMb3HbCGmOw8ofrHp95mT9YXNPMpIPnRlgzgK8?=
 =?us-ascii?Q?Q5JdjXIiOfAwdq8C+2DF5cuacWBvTtaXk4R7FiwkCTyPm4yEmIiJZkPR2ZHE?=
 =?us-ascii?Q?oIO4KHiG/WFooR/sZbktYeV4dPs/B8Ieol1RtwavBGK4dUZWgAtIoRn5OAU+?=
 =?us-ascii?Q?h2KdShnBiXRUtjMYEUYc5pcnCuKyTAXhup0puw+e9gZb5sUBk09x2FJJtWCF?=
 =?us-ascii?Q?EwuUuNaKIhRg5uCF7FshHrIM775RqNEFlEnIGYLN1/dQiWo2ByxBThubhjam?=
 =?us-ascii?Q?8t9Z3/qGg9KrY0XVr6uTmuXZi4QH4e8+Ajx+x8IvYVVgS4RCOTDqzvAoqcyQ?=
 =?us-ascii?Q?4mSHU4iTPXPh9+v3D9CDJjk7uHmmz8KIfGe/ij5bFa7Z+NFJWNcg1rI0YIn+?=
 =?us-ascii?Q?8+9rhaPWvgDnnq8JuszNiUyZ8IDFQDV1wFLIvAmMLAz5Uz1vU1upXuo46AE1?=
 =?us-ascii?Q?qT5oJ4ADeN0ZxO/OuYC8e8Oid9VHuai4/JnwooH+HPmi+NgvZNQCDMM+Dbh0?=
 =?us-ascii?Q?J/dOrvq8AkgOm7CYqNFtkfiVsuDT5JOWAKIPjmqwXPMqqRN2P4RQBRWAVylW?=
 =?us-ascii?Q?4B01sT8yHTK/5CDUWEEqo2Aod8SHmYunPZTisutAnD0kHk13SG9CarkZHd5C?=
 =?us-ascii?Q?GeMOo86ENsB4ajQUBlpIW6jBKIHAAGQkxge5lxYkvQsHsxbBq5Tnw0wyRDrK?=
 =?us-ascii?Q?1AnQLQaJ30UvUWdUsrx9doYKbDXLL1LrsW+QKYsuSZf3pSm3wxCzd8ai5tXj?=
 =?us-ascii?Q?FnP81VCUsZTYKbKAZRyXCMx09PcJ4Gm/AJ0VUizgnmfhCSAOb7lKlLTv6Nr+?=
 =?us-ascii?Q?LzHBPY32YU9Ih6GleKODn8DsLsT8JVrWIORx3gVHu+DK7vz9QZz9c+PosyRi?=
 =?us-ascii?Q?Dgo3q2hsJCQTcxk/T4N0JSi/tkJygWaEUB/MFvnHc3wfQ4u5OMahsvODr5qh?=
 =?us-ascii?Q?jMuy5717aCd8COkezpIxOy/bMMRQWdHlHmQW/tRkJiEoAhXsMUtFpidGCPeV?=
 =?us-ascii?Q?irlF5uguhnVciiJyj1xcybcQ61mVlwuhNiAlLSWoPGoKB3UkHlmnaIT3PYHN?=
 =?us-ascii?Q?X5f9R3yyenr69T41a/v08sP4JJ6sqrTUcdD0uLeex6/OzCSxB0JWj0AG8/S5?=
 =?us-ascii?Q?UPOFlplYqB7JnLBllAXRVjmGgtBu0KN5KbDDliiLS0KdIYSWySrNqFBKc+LA?=
 =?us-ascii?Q?Q3tGrdIkIWtu3o4N3FkrJZNSj5Ej9l0Gt30q2gKoYx4AhmkTIPIpT/Ii7MBN?=
 =?us-ascii?Q?4qGHdqV2M/C+Ak2lIIpnWShaMihx4mGnC7Bo6fesHXO0Gt4uulEBmJoME8hM?=
 =?us-ascii?Q?j/JYa2GbMFffFf6Wx29QVzy4hZd3C8ygeivkug7eu2Asm1X55hjxwoRo+e4O?=
 =?us-ascii?Q?wCyaLXfWZIjs+H47Bo7iC6mGvj83mCqCemVAhk312tbx0gNcUOHqpoF4hopE?=
 =?us-ascii?Q?ATgxjZQhZJdgjFKKOTDzP2ATQavndj0fcgcokFIUVOZJkwyxsQ+mb7JgeIYv?=
 =?us-ascii?Q?JnX2WUV67tli0l/ogmUCodpw5teVVpgDJ2ZVYWFDqECaO2zw0AdswOIzLkmp?=
 =?us-ascii?Q?CWmS/ilAi7n8SRx+b8JzTTZD9kamx/rT0dHIlgHJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5feb31a6-ade3-409d-3551-08ddc4a30b08
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 19:57:50.2733
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eI8Q6I9BlxUFPrdDjMFW6ZOB1sC8bAsXNE2wokPX5oRZ+qGG9hwQkh7roGNi3OZo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7560

This is the first step to supporting an incoherent walker, start and stop
the incoherence around the allocation and frees of the page table memory.

The iommu_pages API maps this to dma_map/unmap_single(), or arch cache
flushing calls.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/generic_pt/iommu_pt.h    | 81 ++++++++++++++++++++------
 drivers/iommu/generic_pt/kunit_iommu.h |  1 +
 drivers/iommu/generic_pt/pt_defs.h     |  3 +
 include/linux/generic_pt/common.h      |  6 ++
 include/linux/generic_pt/iommu.h       |  6 ++
 5 files changed, 80 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index b2893de39bcf26..a22d45c95e1391 100644
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
@@ -327,35 +331,55 @@ static int __collect_tables(struct pt_range *range, void *arg,
 	return 0;
 }
 
-static inline struct pt_table_p *table_alloc_top(struct pt_common *common,
-						 uintptr_t top_of_table,
-						 gfp_t gfp)
+enum alloc_mode {ALLOC_NORMAL, ALLOC_KEEP_INCOHERENT};
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
@@ -368,7 +392,7 @@ static inline int pt_iommu_new_table(struct pt_state *pts,
 	if (unlikely(!pt_can_have_table(pts)))
 		return -ENXIO;
 
-	table_mem = table_alloc(pts, attrs->gfp);
+	table_mem = table_alloc(pts, attrs->gfp, ALLOC_NORMAL);
 	if (IS_ERR(table_mem))
 		return PTR_ERR(table_mem);
 
@@ -606,8 +630,9 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 		}
 
 		new_level = pts.level;
-		table_mem = table_alloc_top(
-			common, _pt_top_set(NULL, pts.level), map->attrs.gfp);
+		table_mem =
+			table_alloc_top(common, _pt_top_set(NULL, pts.level),
+					map->attrs.gfp, ALLOC_KEEP_INCOHERENT);
 		if (IS_ERR(table_mem))
 			return PTR_ERR(table_mem);
 		iommu_pages_list_add(&free_list, table_mem);
@@ -624,6 +649,16 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
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
@@ -656,6 +691,9 @@ static int increase_top(struct pt_iommu *iommu_table, struct pt_range *range,
 	return 0;
 
 err_free:
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_stop_incoherent_list(&free_list,
+						 iommu_table->iommu_device);
 	iommu_put_pages_list(&free_list);
 	return ret;
 }
@@ -971,6 +1009,9 @@ static void NS(deinit)(struct pt_iommu *iommu_table)
 	 * The driver has to already have fenced the HW access to the page table
 	 * and invalidated any caching referring to this memory.
 	 */
+	if (pt_feature(common, PT_FEAT_DMA_INCOHERENT))
+		iommu_pages_stop_incoherent_list(&collect.free_list,
+						 iommu_table->iommu_device);
 	iommu_put_pages_list(&collect.free_list);
 }
 
@@ -1063,6 +1104,7 @@ static void pt_iommu_zero(struct pt_iommu_table *fmt_table)
 	memset_after(fmt_table, 0, iommu.domain);
 
 	/* The caller can initialize some of these values */
+	iommu_table->iommu_device = cfg.iommu_device;
 	iommu_table->hw_flush_ops = cfg.hw_flush_ops;
 	iommu_table->nid = cfg.nid;
 }
@@ -1110,11 +1152,16 @@ int pt_iommu_init(struct pt_iommu_table *fmt_table,
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
index cca4e72efcaa04..45ecfa8ca5fa6c 100644
--- a/drivers/iommu/generic_pt/kunit_iommu.h
+++ b/drivers/iommu/generic_pt/kunit_iommu.h
@@ -139,6 +139,7 @@ static int pt_kunit_priv_init(struct kunit *test, struct kunit_iommu_priv *priv)
 
 	priv->fmt_table.iommu.nid = NUMA_NO_NODE;
 	priv->fmt_table.iommu.hw_flush_ops = &pt_kunit_flush_ops;
+	priv->fmt_table.iommu.iommu_device = priv->dummy_dev;
 	priv->domain.ops = &kunit_pt_ops;
 	ret = pt_iommu_init(&priv->fmt_table, &priv->cfg, GFP_KERNEL);
 	if (ret) {
diff --git a/drivers/iommu/generic_pt/pt_defs.h b/drivers/iommu/generic_pt/pt_defs.h
index 3673566708495d..869965883e6e51 100644
--- a/drivers/iommu/generic_pt/pt_defs.h
+++ b/drivers/iommu/generic_pt/pt_defs.h
@@ -55,6 +55,9 @@ enum {
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
index 7729008f17c799..1b97bbfaa4f90a 100644
--- a/include/linux/generic_pt/common.h
+++ b/include/linux/generic_pt/common.h
@@ -84,6 +84,12 @@ enum {
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
index 960281046e62b3..7cec42a8efbb04 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -57,6 +57,12 @@ struct pt_iommu {
 	 * table walkers.
 	 */
 	int nid;
+
+	/**
+	 * @iommu_device - Device pointer used for any DMA cache flushing when
+	 * PT_FEAT_DMA_INCOHERENT.
+	 */
+	struct device *iommu_device;
 };
 
 /**
-- 
2.43.0

