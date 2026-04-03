Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010033.outbound.protection.outlook.com [52.101.61.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9931DA62E;
	Fri,  3 Apr 2026 12:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.33
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775219215; cv=fail; b=fw/2bYcHsGMJfVBLAnzYT8uKHJf/VRABZeN/ZIjLcyEzi67rNcgrV+1n2Mf9ZeVggTIV/ku0VMkmrunAU+nlhj3Si4XyNGF7Ob8LhbP0v1lMSzYhs/P+XqGI2MW+JssW3RoqsC8sMA3d2v0uM69SCR4R1qmt+YaTFpIYnthOCSA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775219215; c=relaxed/simple;
	bh=pmUqtDilEiLGMJC23IEbXjPURlf72CICdkurWtJBURs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LRNaubVCwcMjF+9IVL9QghStu6QH8m9hKPqQjF7OXMujVlzokVo/hRst6XebRCZzgTjXc+03S3LXQaceMdwXdGwJU5MTeDf3EKjUYq1JCy/mm59PJZ45DtcdpLgEgCtxZprhQAdODNsRw239vlyEc66+8wnVjFWSk8tyeRjuCQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=DskkKyVy; arc=fail smtp.client-ip=52.101.61.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="DskkKyVy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VJ4+JgWow5Y9WAd3I2fDI/lT9Z9vnLGoa1qk0XNGrYt2UqTBpZ6ygNHWI/tWxzkDH87e5AiMQnkv+3zKp6fMhndl/4uHaJQLFLYwC4qzwefIAldEJWOdwvCeXd+mWOj3ELojSAYfuLta8t+/shE4wI8KnshqXmWlUE2yK8KyQhmpXKzVeR+JQfK1t9aKSPdfMRxiHOZ7Hx0vZkvkNpjFDakxGjmLtvIpWXs4EMm8Puf2webwWkjvYjcsQOXTFF0nP+Xm5ZIhqm6E1oNrIq86WBq2Xp9BxbC/r0BmcoAcrgL9WPM69Km+y6M2sPNSKHGmCHA9lbIG0RtyxosS3KsAsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0xA0Wtj7MAeZA/udUYl7CHSgARpClHco9N6qYECN+w=;
 b=Vmx54IgfvpKmsph7K6lDoLeEhV4DSNI0tJvH9gklyaqw+E2tmn8rTD98ZQHJ3gEmteklY1KKcqN3Mw80l+s7zgs99sCQh8M/IPtr8sIyUN5QZjluXBj2R0KrcnS5ahqtdOnQ9t2eJLLQRrdGMqpFdBZBiGFF3IY+o+PKKaFxQoFOavbrEIFC9X0QY0p6qpVFcSaPMAP3WP9fnN52AeeN0kzW3DzcwMZzErzhpueJrzwqh3pKPRFs7Bgdo+rD88bWqKn5VjKLBxjokeryj2ugcrA8LgnTlT+Byf4yrqI6tZZqCuCYYlVDShh3lUu+ZypB8ERt9N4BeSKD+MH7Gg37/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z0xA0Wtj7MAeZA/udUYl7CHSgARpClHco9N6qYECN+w=;
 b=DskkKyVyXrf5bSbaIS2X3M1NZ7+8z+XOmbQlNzzcc059G3m2ehWFTskOjXG9eFUT+Jp2fGRI9YGC5dziaR1llvhXtS5W+VjIkMYg3RFZisOAO9WoLyH8LRxfDnq0pqeFrzdRuZef7KyfubRwpD5MeCi+9LterXtzKyzXI1hMUoduVMqmdAJJY+fmKloHqiZ6UZZEzSgJY5diTv9nyY9D6k9dMxGsL7yNCtcCJit7vItdcG1gLf3210gCxD8IP2T6z+nH32s+QolqslzXTTcokhNnv2A3LIu12+krgg1HvNOKy9B6PvzaRiPOrJkhBCW/V3RKxkoXheBFBZTOoA+zhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by DS0PR12MB7608.namprd12.prod.outlook.com (2603:10b6:8:13b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Fri, 3 Apr
 2026 12:26:48 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%5]) with mapi id 15.20.9769.017; Fri, 3 Apr 2026
 12:26:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev,
	Wei Wang <wei.w.wang@hotmail.com>
Subject: [PATCH v2 5/5] iommu/amd: Control INVALIDATE_IOMMU_PAGES PDE from the gather
Date: Fri,  3 Apr 2026 09:26:44 -0300
Message-ID: <5-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
In-Reply-To: <0-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0026.namprd02.prod.outlook.com
 (2603:10b6:207:3c::39) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|DS0PR12MB7608:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bfedd2a-3ef0-4bc6-252e-08de917c4611
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	bnOTBUgQlYvUcXg7ZkQMuiqDMZL0Uuvz6Bv31VJIvk7jR/NQXkRcibBLCzp8P8tB0E20usZsYDatzDnuThCo0lcfxDvGvcGe21ulLOi7AhfiCzndGkGmwXUtIQFQuRHPE5Vb3qP9AclGmYnODVyF8kicaE9pLDvTQJS8aZCeLru+Djvl67et871Ap6geqgzZdgcCiAVbVDk8lnFXv40AsuoXXCfS8VDChqy3UAWcbB+9724Y+2xv8M78F7iQL3OYbgZWVToKhr4LrNjMe60tYHjaKkXj4RnB5uPfrtvGXo+KgTxgimcnmUIYQ2CXJaKI4NWPVuADRxfbTYDEkyQOUFgDkNwUainTxnjtgD/2APVkl3xzYzhsR75bA9XE3sbLUNkGvW0GWxsjHm8ZHzM9fZ+cGkbeXleqgeE4E24Q6FcIqgHPYrBAPka+CPghW0c3Y2uGVz1JuDubkgZOm4Z2vuIBDDm3rbpMvnvUFmWawpZmbIt9eo4CKBcrWe23LGbdlvVjxHdy4AbpRJS3ep5hVHA8AqDmrrEzgr6Zg/rdpyASI2dcxcF3pOb+ooonEcZ5Gr2kn/Mmmsh/JYeUBDFrqvUNVBPpsB/Sw8KLHAtaDBYtiLgB22cCIzegx8JcohnhnXBuR7j23UhM9dQ+nZ11bX619X7AXfd2v1JR2tPZnoiKWBcOYG+uJ/IL6qza3ZLVhTea50ahlqiWue/HqurrKnf8kpMWIHOfRLsChjzOFwk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6x6mhaZ4dofb49zelJAG1ERPjbijXGtwdNnA+rszn8fh/L1MY4VfzCdpCR/Z?=
 =?us-ascii?Q?GWKzJ2I6GB2J6w/gBgMm90lsAOQShxhLOvaQ/y9Z1vBldvekwoe/MmkAGzsP?=
 =?us-ascii?Q?ymQP5cgVCOJmey37706IhfEtE0yy9w+WPRa/guQikYD9mMN+NiCscmLkGvUK?=
 =?us-ascii?Q?f0Hnmjvf2bpNZp631xAyKgQ2PNZ8RuRtfiiqHJMJiaNwcfp9vt/oN0MiFnKg?=
 =?us-ascii?Q?NLvo2L03NMM0I5QYWTgcTPEYTx+Tti6jcK3GoyvYXUMIdV6Jw51F08TBszyd?=
 =?us-ascii?Q?NGH+nuRrReyefRGCJsIXDRbWjuXZsLb1y7URlyICjyQTNZRrIwTGqwk8tv8F?=
 =?us-ascii?Q?ggYKRXuTGta4T7z1nT0qOaU91n0gJHYLuJpxSfv7RmmFGKUZ34pbnSUbFurJ?=
 =?us-ascii?Q?rWxF+rZMsLYDa6MLHOvq2U6dFoVPvm2yDaek+9rJTuLA91nwEwyPYs+20AKu?=
 =?us-ascii?Q?BxVV6Rf/2+ZtwcUpMuqp4qALcjJmco+FDDoaSJt6YdpqEXdpbCZq6Q9NPQd0?=
 =?us-ascii?Q?Q2KKha/1gTHh24eWmG38Xy1HeUnYs7sfN4eq+7n381wpl4E6gt5sI9gKvFeD?=
 =?us-ascii?Q?RMtl5N5wmT+bQjjMCpBN9iJCYryrv1rD+bnkT8zZhBzRaJTsD1TkR37eH2LT?=
 =?us-ascii?Q?xWFO31mHLga44anbxylJIeKtXdypjQ77I+50Zm/KrHUwGSxkV9OvJ7YtWgMX?=
 =?us-ascii?Q?pxrfqBkakzCiNKknwCB+vjCQY6UxiG9GnsSsRUmbPUq1FUS4v6W340aKefWG?=
 =?us-ascii?Q?fzGZmxoX4HXBTTKzInbCYvd61HF95PCqF/QKEwGnVZGEG2erUL4Sq1LX1m60?=
 =?us-ascii?Q?jOJZA0SIh9nYKPBaJ4HW8+JxBDKmIzLIWPGH5UQchJ/hUy73oOoyxT3gEr9B?=
 =?us-ascii?Q?hQmDOijrwASMhsmN6jkvKmyimykY7g2i38BmiMJ/f1zGn8Y4QKv17oDltbKJ?=
 =?us-ascii?Q?+Fo2wsu8LiEdgviTrSHpGNF/o7VJPalKkVEw9KNc0SkdzZnuIj2qz4j3SsTe?=
 =?us-ascii?Q?6FyKt/GHfdNtLUe0qTFARmYVYVs0HlNTVOehKdpXP3VRP2NHzMzXUohIp2Y1?=
 =?us-ascii?Q?eUdmJ2PYvUrVEydLKUSR4BmbXPutkd8Kj7qCnoxo4nUW9ldJPhNnXO5CQ3yp?=
 =?us-ascii?Q?7pTpBhlgJBUcsLanFIvWhidDFjoqRJfL/sZ5QgP/1/EcNDzeROZ96IhkzyS/?=
 =?us-ascii?Q?eFhVaCxEJ2tEybBaFt5mpMWOfa4OOm1sF0wFVtWq9ZbQw0lGkrW1Beh5m2pK?=
 =?us-ascii?Q?ae5hAU78Id776IgSw7r3Vp3B9CHEIGDC9sR+cTRjULQW0QR5WYrVyeJXiPG0?=
 =?us-ascii?Q?wwv6TDIML59wDIvZMWOB14UXxciWIeiMnxgoZ5vPwDvZgce6TWWEHNANiQ8A?=
 =?us-ascii?Q?yKkKt0qDBDLpt+7lX8nm/mk+I1bqPC09tQAAJXLtCHkYyvjxApw9BDLKsZYC?=
 =?us-ascii?Q?KY6t1fRCg+qHIf5ylZ6FOzqg/8lqPyh3DA5pBnAPnLolGTY2T7f3pwjTl2ed?=
 =?us-ascii?Q?ZC4H5ZQKacVyP6kbL5sDgL0kZgKEs7wrxsZNf4wL75WhKYfouSgV+ysEyWQi?=
 =?us-ascii?Q?BF+EcXDhACO/lGzJ5EA9nUmF91Ifwy3CLFYvBbO0sSS3ccnjvg4jIw+Gh+uT?=
 =?us-ascii?Q?5RdHNcDJ55tbHrSyQ7SK6nGRRJDfxdeWoK/GCUDZbKeBoyUrq14JQMJWuIrP?=
 =?us-ascii?Q?fzLZIUkeqZEneL2EIzZfmFWEalpIQZCqo1gX6cyFPax+EPqj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bfedd2a-3ef0-4bc6-252e-08de917c4611
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2026 12:26:47.6069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fYQWF6L2U2YV+lcteVwuA7THJOmuhxgmmEAwXgC7c+qTwRIZxQsSk8Gevco+X2sN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7608

Now that AMD uses iommupt, it is easy to make use of the PDE bit. If
the gather has no free list then no page directory entries were
changed.

Pass GN/PDE through the invalidation call chain in a u32 flags field
that is OR'd into data[2] and set it properly from the gather.

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/amd/amd_iommu.h |  2 +-
 drivers/iommu/amd/iommu.c     | 78 +++++++++++++++++++----------------
 2 files changed, 44 insertions(+), 36 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
index 92410b9cf544a9..1a6d9cae7b23b9 100644
--- a/drivers/iommu/amd/amd_iommu.h
+++ b/drivers/iommu/amd/amd_iommu.h
@@ -88,7 +88,7 @@ int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag);
  */
 void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, u64 last);
+				  u64 address, u64 last, u32 flags);
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 				     ioasid_t pasid, u64 start, u64 last);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e3842b23481c99..c804ea49624a1f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1301,8 +1301,9 @@ static inline u64 build_inv_address(u64 address, u64 last)
 	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
 }
 
-static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start, u64 last,
-				  u16 domid, ioasid_t pasid, bool gn)
+static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start,
+				  u64 last, u16 domid, ioasid_t pasid,
+				  u32 flags)
 {
 	u64 inv_address = build_inv_address(start, last);
 
@@ -1311,19 +1312,17 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start, u64 last,
 	cmd->data[1] |= domid;
 	cmd->data[2]  = lower_32_bits(inv_address);
 	cmd->data[3]  = upper_32_bits(inv_address);
-	/* PDE bit - we want to flush everything, not only the PTEs */
-	cmd->data[2] |= CMD_INV_IOMMU_PAGES_PDE_MASK;
-	if (gn) {
+	cmd->data[2] |= flags;
+	if (flags & CMD_INV_IOMMU_PAGES_GN_MASK)
 		cmd->data[0] |= pasid;
-		cmd->data[2] |= CMD_INV_IOMMU_PAGES_GN_MASK;
-	}
 	CMD_SET_TYPE(cmd, CMD_INV_IOMMU_PAGES);
 }
 
 static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
-				  u64 start, u64 last, ioasid_t pasid, bool gn)
+				  u64 address, u64 last,
+				  ioasid_t pasid, bool gn)
 {
-	u64 inv_address = build_inv_address(start, last);
+	u64 inv_address = build_inv_address(address, last);
 
 	memset(cmd, 0, sizeof(*cmd));
 
@@ -1522,7 +1521,8 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
 	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
 		struct iommu_cmd cmd;
 		build_inv_iommu_pages(&cmd, 0, U64_MAX,
-				      dom_id, IOMMU_NO_PASID, false);
+				      dom_id, IOMMU_NO_PASID,
+				      CMD_INV_IOMMU_PAGES_PDE_MASK);
 		iommu_queue_command(iommu, &cmd);
 	}
 
@@ -1534,14 +1534,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
 	struct iommu_cmd cmd;
 
 	build_inv_iommu_pages(&cmd, 0, U64_MAX,
-			      dom_id, IOMMU_NO_PASID, false);
+			      dom_id, IOMMU_NO_PASID,
+			      CMD_INV_IOMMU_PAGES_PDE_MASK);
 	iommu_queue_command(iommu, &cmd);
 
 	iommu_completion_wait(iommu);
 }
 
 static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
-					 u64 start, u64 last)
+					 u64 start, u64 last, u32 flags)
 {
 	int ret = 0;
 	struct amd_iommu_viommu *aviommu;
@@ -1559,7 +1560,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
 			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
 				 iommu->devid, gdom_info->hdom_id);
 			build_inv_iommu_pages(&cmd, start, last, gdom_info->hdom_id,
-					      IOMMU_NO_PASID, false);
+					      IOMMU_NO_PASID, flags);
 			ret |= iommu_queue_command(iommu, &cmd);
 		}
 		xa_unlock(&aviommu->gdomid_array);
@@ -1614,14 +1615,14 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu)
 /*
  * Command send function for flushing on-device TLB
  */
-static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 start,
+static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 address,
 			      u64 last, ioasid_t pasid, bool gn)
 {
 	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
 	struct iommu_cmd cmd;
 	int qdep = dev_data->ats_qdep;
 
-	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, start,
+	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address,
 			      last, pasid, gn);
 
 	return iommu_queue_command(iommu, &cmd);
@@ -1673,8 +1674,8 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
 	return ret;
 }
 
-static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
-				 u64 last)
+static int domain_flush_pages_v2(struct protection_domain *pdom,
+				 u64 start, u64 last, u32 flags)
 {
 	struct iommu_dev_data *dev_data;
 	struct iommu_cmd cmd;
@@ -1685,8 +1686,9 @@ static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
 		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 		u16 domid = dev_data->gcr3_info.domid;
 
-		build_inv_iommu_pages(&cmd, start, last,
-				      domid, IOMMU_NO_PASID, true);
+		build_inv_iommu_pages(&cmd, start, last, domid,
+				      IOMMU_NO_PASID,
+				      flags | CMD_INV_IOMMU_PAGES_GN_MASK);
 
 		ret |= iommu_queue_command(iommu, &cmd);
 	}
@@ -1694,8 +1696,8 @@ static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
 	return ret;
 }
 
-static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
-				 u64 last)
+static int domain_flush_pages_v1(struct protection_domain *pdom,
+				 u64 start, u64 last, u32 flags)
 {
 	struct pdom_iommu_info *pdom_iommu_info;
 	struct iommu_cmd cmd;
@@ -1705,7 +1707,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
 	lockdep_assert_held(&pdom->lock);
 
 	build_inv_iommu_pages(&cmd, start, last,
-			      pdom->id, IOMMU_NO_PASID, false);
+			      pdom->id, IOMMU_NO_PASID, flags);
 
 	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
 		/*
@@ -1724,7 +1726,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
 	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
 	 */
 	if (!list_empty(&pdom->viommu_list))
-		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last);
+		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last, flags);
 
 	return ret;
 }
@@ -1733,8 +1735,8 @@ static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
  * TLB invalidation function which is called from the mapping functions.
  * It flushes range of PTEs of the domain.
  */
-static void __domain_flush_pages(struct protection_domain *domain, u64 start,
-				 u64 last)
+static void __domain_flush_pages(struct protection_domain *domain,
+				 u64 address, u64 last, u32 flags)
 {
 	struct iommu_dev_data *dev_data;
 	int ret = 0;
@@ -1745,9 +1747,9 @@ static void __domain_flush_pages(struct protection_domain *domain, u64 start,
 
 	if (pdom_is_v2_pgtbl_mode(domain)) {
 		gn = true;
-		ret = domain_flush_pages_v2(domain, start, last);
+		ret = domain_flush_pages_v2(domain, address, last, flags);
 	} else {
-		ret = domain_flush_pages_v1(domain, start, last);
+		ret = domain_flush_pages_v1(domain, address, last, flags);
 	}
 
 	list_for_each_entry(dev_data, &domain->dev_list, list) {
@@ -1755,20 +1757,20 @@ static void __domain_flush_pages(struct protection_domain *domain, u64 start,
 		if (!dev_data->ats_enabled)
 			continue;
 
-		ret |= device_flush_iotlb(dev_data, start, last, pasid, gn);
+		ret |= device_flush_iotlb(dev_data, address, last, pasid, gn);
 	}
 
 	WARN_ON(ret);
 }
 
 void amd_iommu_domain_flush_pages(struct protection_domain *domain,
-				  u64 address, u64 last)
+				  u64 address, u64 last, u32 flags)
 {
 	lockdep_assert_held(&domain->lock);
 
 	if (likely(!amd_iommu_np_cache) ||
 	    unlikely(address == 0 && last == U64_MAX)) {
-		__domain_flush_pages(domain, address, last);
+		__domain_flush_pages(domain, address, last, flags);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
 		domain_flush_complete(domain);
@@ -1794,7 +1796,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 			sz_lg2 = min_t(unsigned int, sz_lg2, __ffs64(address));
 
 		flush_last = address + (1ULL << sz_lg2) - 1;
-		__domain_flush_pages(domain, address, flush_last);
+		__domain_flush_pages(domain, address, flush_last, flags);
 		if (check_add_overflow(flush_last, 1, &address))
 			break;
 	}
@@ -1806,7 +1808,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 /* Flush the whole IO/TLB for a given protection domain - including PDE */
 static void amd_iommu_domain_flush_all(struct protection_domain *domain)
 {
-	amd_iommu_domain_flush_pages(domain, 0, U64_MAX);
+	amd_iommu_domain_flush_pages(domain, 0, U64_MAX,
+				     CMD_INV_IOMMU_PAGES_PDE_MASK);
 }
 
 void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
@@ -1816,7 +1819,9 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
 	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
 
 	build_inv_iommu_pages(&cmd, start, last,
-			      dev_data->gcr3_info.domid, pasid, true);
+			      dev_data->gcr3_info.domid, pasid,
+			      CMD_INV_IOMMU_PAGES_GN_MASK |
+			      CMD_INV_IOMMU_PAGES_PDE_MASK);
 	iommu_queue_command(iommu, &cmd);
 
 	if (dev_data->ats_enabled)
@@ -2606,7 +2611,8 @@ static int amd_iommu_iotlb_sync_map(struct iommu_domain *dom,
 		return 0;
 
 	spin_lock_irqsave(&domain->lock, flags);
-	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1);
+	amd_iommu_domain_flush_pages(domain, iova, iova + size - 1,
+				     CMD_INV_IOMMU_PAGES_PDE_MASK);
 	spin_unlock_irqrestore(&domain->lock, flags);
 	return 0;
 }
@@ -2628,7 +2634,9 @@ static void amd_iommu_iotlb_sync(struct iommu_domain *domain,
 	unsigned long flags;
 
 	spin_lock_irqsave(&dom->lock, flags);
-	amd_iommu_domain_flush_pages(dom, gather->start, gather->end);
+	amd_iommu_domain_flush_pages(dom, gather->start, gather->end,
+				     iommu_pages_list_empty(&gather->freelist) ?
+				     0 : CMD_INV_IOMMU_PAGES_PDE_MASK);
 	spin_unlock_irqrestore(&dom->lock, flags);
 	iommu_put_pages_list(&gather->freelist);
 }
-- 
2.43.0

