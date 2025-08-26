Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2054.outbound.protection.outlook.com [40.107.96.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEF532E7BCC;
	Tue, 26 Aug 2025 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756229216; cv=fail; b=K+qR88DgHD+Hl64IsC49ozHvWi6TcylBsSx8bzbZFgj0VI4QszM1Tsfd5ylHCEUsEU/Ddm7e0sAOHA+M+U3er/CekD2JAivAm5gBmbfdy4QKxOAsBZMt5fejDLOdDNHY2jw+DoECLzKSNvz0/dBR0yTTG18m9oOqNRX8vbA4zCo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756229216; c=relaxed/simple;
	bh=8hMTjMQdJxT30o4LhLH5kGUGy1xkk5xJ2rVi9FcmGDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Cwzfrl/Efj0merERM57OJNCererftprNW3HR+TMCQuEoKcWA/ZiUuLIgXQAIktFBA9aHi+wdp85vIiXG8adRneyDcwo4blWpKqCyJ4f+UzuixtMO2kaa856lAT2/K8apGju7pgvvL/+IA6eUcXxXso5q95sn8Htp1IeLidTvI0w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OrxMZAm3; arc=fail smtp.client-ip=40.107.96.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OrxMZAm3"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gqr+8X73bfIXhzE7+d5sKNUdJhvvLqxffleFxBGMPyLp8bdNdDjPg1lP69rSnColyOXWmmE8RCAxfPtCc3e2VduvrAO08VNMMCJNH8KqRSyESZ55uoyXZ+np9uKF5bzFIK7+MI4jSvaftyJ7HDjz9UqaQO1lqRrfNCMYVTUR5SliPUuc4mOTEs9FYEyheT++YFmcMLgubGDeJPP4fhgdJvxvQwoAsEUiP0V/Ufhhxnl2tXf68j8p5HTiqNahO482jFlPOvdO5ZDqM+9292mCxbaqCnQvcgJQeDZOAJyM2oqlwiFHTYbniL19zNEzb/V0mP8aU8SQHdMIh8U6Mll6Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQN6EkADWsuwuQcFevQFRAFxSmsRmwTKW78HQO0eaQ4=;
 b=KmPSxmGjNSN/UkPRbHCmg6SNbDTehyhnHXU7E2/bbhXB+6z0mVmRcQQJeD08TU61T8l1UsFy4nzHRJGe+woIbz7EguBayRnP3h+CUvqlOyZpnLO1nCU8k2SIKPT3WhFXdyDUX3uT7+YMtFi2UR6uMyOJq0pha/XQbL182cdtPSLRZkd7p0rq0l3PdNjUQEesWrcf/yybchqD4U7Wq44xYMPcdY6uLYxjrNfWdbpsiIWdbIjXccdSFAygv5TKREbFb3vUzYSG3SGExPIhAc0fdH6lxRLHooeiVOD9WCG08C4IN1wDgTR6FkVSO/+SsiKvk2tZ3RKN16T5nOIjuicQ9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IQN6EkADWsuwuQcFevQFRAFxSmsRmwTKW78HQO0eaQ4=;
 b=OrxMZAm3ug5pVSgHtAMKQINdSopk27mnt43hZlOdTb99QItP8d/p2lCmZzSf8YGdH9QyzFTsgirO1IhTsvM29OtDGOP1jwOC+UzPR027WtwJiiHflBRwmfxzgCPp31GFK6tdxLfwzZQsQOuAWpUeBIoM67UN8gpsDOXQYKo4ReNDWSiZFh1sMJtkH47ZytT6053h/eQG9lQnaLAN+0FpHYs4eNj7iXH3bMkvl7JocjGI6Qw44OUb+czFX6kbUnoSxTMEUtI/dlgEixKGSuhNuqglk94xFyIJr7CUWOxRw08r+gDVbDN2a+ygoCVqIlBITUCEzsItnMN0y0tt71DT3w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SA1PR12MB8641.namprd12.prod.outlook.com (2603:10b6:806:388::18)
 by MN2PR12MB4222.namprd12.prod.outlook.com (2603:10b6:208:19a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.20; Tue, 26 Aug
 2025 17:26:47 +0000
Received: from SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0]) by SA1PR12MB8641.namprd12.prod.outlook.com
 ([fe80::9a57:92fa:9455:5bc0%4]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 17:26:46 +0000
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
Subject: [PATCH v2 03/10] iommupt: Use the incoherent start/stop functions for PT_FEAT_DMA_INCOHERENT
Date: Tue, 26 Aug 2025 14:26:26 -0300
Message-ID: <3-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
In-Reply-To: <0-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0048.namprd17.prod.outlook.com
 (2603:10b6:a03:167::25) To SA1PR12MB8641.namprd12.prod.outlook.com
 (2603:10b6:806:388::18)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR12MB8641:EE_|MN2PR12MB4222:EE_
X-MS-Office365-Filtering-Correlation-Id: ab545527-aebb-444c-c5a9-08dde4c5b9de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mfIgYIwkmG9ZHRyXgm+MaNbiw3hvUyigVwo+FWXqtvvqSMc3J82fSJSX3YA4?=
 =?us-ascii?Q?A9+/Nn2LHKJQJ7hP7V/oo+2w2dUNlVNoEos+8QHAUB0JWTBnVOOiRIh75P51?=
 =?us-ascii?Q?QIBzIZhCl0ay4fA3wD/vk44qBBYDEKsAbu7gUCGXdO2PCdwytHT7ossT/Yxy?=
 =?us-ascii?Q?cfVzc6p+MgNR2i5D6iHa92OaMiYAWBffMOUKyyGwuiiKyBIBwD7vePxa26vN?=
 =?us-ascii?Q?GTR9GpWWBcBKKrGE5nJSCLhPX9ec5JaSM0NNJ5H3F2ZDB0Vk9OlwHjyL4eRQ?=
 =?us-ascii?Q?eYDs0fDk0P8GuIvrmNmOiKok69IfZnaZ4m9lsmMB+4NaL+70Dmj6v2S+9LLI?=
 =?us-ascii?Q?WuopmkgiYi9W2eQeuLGEJxUpaDfrTzDXISd/ZqQkjH+PE0HyebYHPntbvH6o?=
 =?us-ascii?Q?xtz/Un3RWdiwUapB/UTRA8h8D7YRaCXl+15TYhSPXUsZTRsb1lwHSH+etaKj?=
 =?us-ascii?Q?pJ+7lTTmHBUT3FysQNzus+0OxLqasNQ3ZvAUuWeBoEWOAWinUZsrnjJLNiU5?=
 =?us-ascii?Q?E81WyYrOHS9uqEcKQlO6SSiHO/5yTTxkOB+VhyUZ9fJD99bdH6/c7+JQIJiZ?=
 =?us-ascii?Q?tqJG5Rhy82bmwFBtI9bTE3lNmOHzjCa/jF3UGT8gKndZequW5wb+PFeuoHL/?=
 =?us-ascii?Q?SmhDkkHhsshWE2o2QEv+vJCDqeOWy1mLrfnTKzcPAqzebe2Egvzrks7ZqpO8?=
 =?us-ascii?Q?ve47xEFLB0dO1mU2Ib/LJcYYTDBr8bsh9X3ZVzHxZmRhixuGLB2tRqzEDdp6?=
 =?us-ascii?Q?fo/wkAv+NJokY1gY/XZLMyJNnfu5LftZFUvab1bfjgaoTbRqPPzXo7Z6bPq7?=
 =?us-ascii?Q?pxjJUyHWDRJnCLMYmWejJaL+VwKUPrrlZ/u6hPdjIUpSSxeqhTjPYszMuEZR?=
 =?us-ascii?Q?vKPZ2BcMfmqOZsrfVKl/+9QZA4gm9bRK9ilwk2s6yQW6zhI+TnY6+8JemoTU?=
 =?us-ascii?Q?H6sTXgNEJ81rYiQTqql4r4gBIauZ6G0oYpfOKK/Ok4oIMrpqIFqnHpKmlkYs?=
 =?us-ascii?Q?WCf9TzhTHAqckAjd31e0Vip6rGcD8Y68gmw2SuKoZ/O+hIngi4pbAY0/8Pl0?=
 =?us-ascii?Q?IL3AdhBOhTvrbGZO55qMUeGua7cxiozNySVAcaY/JuyOX37TxDMpwqUUxVgq?=
 =?us-ascii?Q?pT6vldOMYqE27lnz1y+xTTy2T79WMdpS0wLUhsrr/Njrr47FSQiQoRgGOUx/?=
 =?us-ascii?Q?gvnZuE2aXWviKoEPijlKHgcvtcRTdfJxNGbkhcQGbbH3Bg6IEYzefYD6Ud3j?=
 =?us-ascii?Q?RDkL1O3EaonCxWHkd4ypDjIRuVwvZ89/TJtpF76uuQNku9zc7W4UpayQGNLf?=
 =?us-ascii?Q?XUbxqb0bed3XjN4860hLYuJslGiUjgbEksuA4xVEp5cT1MQndbOYH6WlZT2/?=
 =?us-ascii?Q?mcjMyX2MQypFHMCvy103WXPikAIh27EGfE61F2VmFzer34TA+8Pw0oD4OSDT?=
 =?us-ascii?Q?/YiagxKPJQ4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB8641.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TGDjuLUnhWVPJN6Km0VuexDmanlPbhNa34AbcWQwao5/4SL0M62zHTGWzjOv?=
 =?us-ascii?Q?7+qCgUdlP+lRHWzYf8CWNK71h+k+b5DpH3Kx1ksEudA+ML3IdgF00B2hbqUF?=
 =?us-ascii?Q?VVdPKSlUbbsNqW9iW8izA3bx1ziCZetjYWl0WDvjq+ReZ8qqmOUY+csEkhOB?=
 =?us-ascii?Q?+nf+gIvaEL5K9oIUcw2c+tvGVm2YuUJNFnf7rKeBR0x8aX92EaQhSD5wfR6l?=
 =?us-ascii?Q?+oolFXiL7MS+dIseDZooL+GJYffLbdCvCLJxjmnIJlitj7X1Qteq8Y+0m/ld?=
 =?us-ascii?Q?Ezxw28Ah5LfbY4biub/tR+Ob2cm/5NhHcSlyPh+abiANw3y3UZh/JsOK0D8g?=
 =?us-ascii?Q?FCqh4OVE43X7xJYS8VJgHaChiH0I3xOJYqBFRUcJeyNK7fsPwtWc0RsNK4/W?=
 =?us-ascii?Q?531ONr7ap8tM//9WUFucm3wiD7GLVw0aBa3DdAvEv14R3A+m85o7F5TmIgLW?=
 =?us-ascii?Q?h6Jc6ljSqWx5f867fiQTh8wJ6k766MQQjoo3QY67uEHRJmniV+MiOkVkjcEl?=
 =?us-ascii?Q?gjw0ZMePSQyWCSlzg63H8JnLN/Qw9s+IJEMODYy7BSlusjqDAcmZiKn3e8jS?=
 =?us-ascii?Q?4hsxJMElwLFMYOYmk7oBI7OmvsIrrn1Lx1gwfPij1epzQ5yaYj2tAbGviKcV?=
 =?us-ascii?Q?DqdDSiwI3CRWRFCI/KMH91CFaOZ/k+A4w+ac/hLAPl6Kvsm25CsKF3lhSFiV?=
 =?us-ascii?Q?X9s8KlBJSHY5ntwwebp2HOvjWPzHBMzUStC+XHlTr3RZBdU6DCkiSBSrhXU4?=
 =?us-ascii?Q?EnV+jGR3QYrBMEqhZsl0qlMJ9Rsl3mT5Wxp1rBbLGNInNcVEQLE+ufw6pY3m?=
 =?us-ascii?Q?M6Ty2eFqj3UG4yENfJ2n4qtsvlpRA1Izoi1fZNCqsEpTnOGtD7IAROyvZ3Bw?=
 =?us-ascii?Q?GOqkm+vUDx0rdD7e8tpYjw/WO12K8zEJKgIq5rhwMdh42cFYQm0oWUE1pMGR?=
 =?us-ascii?Q?0AfC3J3Cy3WRzYgHINOwJ7foiQS/FEeJRUTGPch0NxoBm5qW3olEJIW6cIUU?=
 =?us-ascii?Q?hd5gDIqtJYPa588ISRI+iybpHZS2QlDlWgaN+f/5BEtsYCCL8NtfXdDZBGpZ?=
 =?us-ascii?Q?6tGsWk4OI/13Hn8uyhAElmjXpFHUkkwUIcBXUPGerIf1HcnBKoDDbfw2JTEE?=
 =?us-ascii?Q?rlI3sUiQngbDS9DAjaYE9NHbEP+rGmW8jNc1r8WELq0lgS/s8PivCrsR68LG?=
 =?us-ascii?Q?enkMilhgaWTip5FOgx6m/HrK9b+IKYR8Fq1G6hLJi/IkZo0yQ/wnI3wUOkov?=
 =?us-ascii?Q?N0uHj/SxtNKdjh0C5PV5UTcWgJdQwnY1ULxqFwSvEHjTR5Bq/BPyyo2l1DdH?=
 =?us-ascii?Q?tImlVfiQyocRV5Hgkz0W9VZjm4xmu3Bfk5NFGaBSbJZiQ3Dp4nt/ByCQfQoe?=
 =?us-ascii?Q?d8ry5Tp6xpq1C/7gXQkBcboEt22OkEl9OYjU9USUwSm71aKBssNnquYBD7me?=
 =?us-ascii?Q?WXk0DoDHH19ANuSh1X+fayScEMkxXiAH+x8I4HH5NfNINXgTT7ukCsWVOqKv?=
 =?us-ascii?Q?B7uHSJbzINWREmy023+jO0nJBmt5GleT8Rc64UU9owEKraLEMU9COVHiSORz?=
 =?us-ascii?Q?TTAowPROSDUinW9mIcVUvkX4i+lCEeK10DVqAq59?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab545527-aebb-444c-c5a9-08dde4c5b9de
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB8641.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 17:26:44.3617
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ANbPqsnCDQljw/HIuOH20emL4sU5vaKx1vKUOj29veTn+wp2t9E0cQwWDB573IPq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4222

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
 include/linux/generic_pt/iommu.h       |  7 +++
 5 files changed, 81 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/generic_pt/iommu_pt.h b/drivers/iommu/generic_pt/iommu_pt.h
index 2a6c1bc2bc9be7..4789fe5361cb3a 100644
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
@@ -1107,11 +1149,16 @@ int pt_iommu_init(struct pt_iommu_table *fmt_table,
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
index 960281046e62b3..5dc3a960a8989e 100644
--- a/include/linux/generic_pt/iommu.h
+++ b/include/linux/generic_pt/iommu.h
@@ -57,6 +57,13 @@ struct pt_iommu {
 	 * table walkers.
 	 */
 	int nid;
+
+	/**
+	 * @iommu_device - Device pointer used for any DMA cache flushing when
+	 * PT_FEAT_DMA_INCOHERENT. This is the iommu device that created the
+	 * page table which must have dma ops that perform cache flushing.
+	 */
+	struct device *iommu_device;
 };
 
 /**
-- 
2.43.0

