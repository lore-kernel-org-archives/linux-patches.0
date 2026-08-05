Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6DB3E00B0;
	Wed,  5 Aug 2026 19:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957355; cv=fail; b=TgAC+vpcB6G7mQS4g2LcbHG0KNi/CHDlyfKX+NVpAQq5bXegKHrftzM3OTG3YJbcyLvGRmCPcWVqe0P9wyqHhEvK+0udpNCR426wODC/zExFn5A4UWb1rscG2kT9UA1asG5ip/GftQGiyNoRPHvpRXN5l9nMHwvIYr1ZBpaJv2M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957355; c=relaxed/simple;
	bh=C05+ElGtDmirx1rR7xmzOt6KkV5hLTLb4o8UydgQ8+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F1601xQVHvmiidTi2YV9TiazDx4M05zO1C0f8h0iMxgLE4aACSyEgWZbAo1VKduhDRP3suuIK/YcgrBasXcxOY8ASt2WXeRu9YozAKOZrz2lKEQOm+GN9BFZnccnG3cyOB5BxBHm3HWRGEZtp4rUf9ZkIN61sdeBaEBC0Crbiew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=AIQ5pBwF; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="AIQ5pBwF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i6qNZf9GhZtxxFA3ZWJqR7/sMu3dgPW5GjuzxrY/4ylCxGNBm4tbqYHvArCVLoMPst/jtcnN60LxSFzlbojuPvQWhvXYXXuzezvk48sxfln3nhUs1NDWMaBFsQPSMf6MKFdshZpESZyGbl1UX7zVZxcyn/ha4vLeAPBJ5IMOoabHPfd2SHkV7b7h46nPZnIVEfMpaMq4yxf3SX/DIzWkWZ4pqmJifubulGKXJOH1RtgQHn6JLz9N2T2sInrB/c+2CrjXaffox3GClymUHnUERRbKL/01ed/l2BaxNW39R7W65vOliN9KtgmNNgAGNznRM1AWrwXLapqJ+wlddyFjAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TJDOUKRzbs2vSUeXHLZBShJtdhnEa2Ky7W68QQD9RyY=;
 b=XMayWQDBL+im+uZUVQ2bMrG8xToG6FkduKVH+jEb3diScBw/V0ZPY612e6xAhZL5ubRfZsvNamhPSqTpXKYsyugiZLAvclryaxCkmAs3Sw1D9yc5tcKyVZQA5JIRQX+gc61Q6ASVdQ7PInoVX2Min/qm5UL3D9RTdDXcglR2nG4AxwgGsXiQxidB5wHcb2g1ys/BG/D86ZI5VgArxecB1IUlvFQZkxRUVnvPGpRn0swmQWTHKRbJ1CRG3XKOJThf78gBjWGExYmUjOypTIkUOGItCBgrVI2AVJ2Sc4++BgiEPAKIHQef3Rc6VY8Z8DpCEFrs3ySt+g2oi5RJzvASsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TJDOUKRzbs2vSUeXHLZBShJtdhnEa2Ky7W68QQD9RyY=;
 b=AIQ5pBwF3RcbBD/ORVtstjUOijb5Q6pz1f0C2y9HiPhKX83TE+Jnk3JAJRMjInuy2zDc/GZEroehA9aBtk/gTUzCVNpeh12bzPytPU0sfshZiDz9mnaST9AlyPZenKhSjqTl3gYd3wzT6Ouf6nqTRwrg1jubveQC/v2FPmB08eB3F204wFwJDQcSUIpsimrQpaJiUXUf0nO/ME3of7v/VF6SJ0mP4EK/Crz2ye0zOcchsL+f5fATQ6fSC6SHYuiHj4rkxeqycXYU1D8F7xwt2FttrYhT+xg50tDAcPsV2zoCuwf0J+NM4GTsJ5nHT2XHFBbbZaTm2Sk7XSTA9vgXoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:29 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:29 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v4 2/8] iommu/arm-smmu-v3: Move pgsize out of arm_smmu_inv
Date: Wed,  5 Aug 2026 16:15:20 -0300
Message-ID: <2-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0023.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::28) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 5faf8265-4961-4d76-7e22-08def325e968
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	CC5FGtTnC8e7BRsQL5u1maM9bXaEYguik80SR5d3++c9GxqTYphV84go4cKpzIZXW79p3+iHOCudXE/xiD+KwavDk9FgENh9ZGKgEDmUYp0dqAiBzSJrriIZn0spdTnoeSDTbLIqd8+CRcYEUl1OHAP45WbqXmr20OTe09RHSbXnFo4t0OpGS+V7Zcf14E8XFgJetJVc+FfEyGoL2MHpTlydsWbFzWPultXno9i5B9BxKaNU8c42DRsTrRaHx1FokncbtBUtRyuBxuJ/xcksayqwnHVdhDg6xN3ZYrgTvferJZApEHlfM8IuwAkWmGHiCm/UnaKVyKSZUYOjToJgXfm21QRcG2ghnFcIvhVxZw/LyMx7VlDgpWW1TZyc4Dnk7xMdQPCTBX6yY3J12FyyQo4STISsU97Iq9JFUmxyrNDJJsYjmx6Z08TDUG/LDtfxQ362LUdezCBqRJCDDxqiugTBELkpEc5qCIsjMsq0OAiuJjQ6GZjjgRscFBH2L+OiYZzVF4QW1NPlssQwLw+fRzuw2bHuoWYSutUv+pqLAeJYO2vmpP1f2uA7qbfjV3Um1Z2EO7PgPtwXCkOpEkg+wzvDJnJ3G9bTCiwhUM9u8GarC7gl627DXzdfZyGesXxZkBEQrs2Qv8oOoCGJfuhZNoCKZ7LAeJ+uup42H/pl3e8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G465gBpwGJ/RqoFabplyBm2m68MaaDoFiBjwckCFbZlXWb4STFRSourNdiUW?=
 =?us-ascii?Q?DR0j1ECVoXx5EGIEAYhnsZ3leYuZzEk3T1LLJH2XtcyXoEFx10D7JNZ80UlQ?=
 =?us-ascii?Q?bI2ffCsbg2eeXrkEuUBX7YK2i1g8V7OoWRiU/ukwfIf3gocig+uonieI5mL9?=
 =?us-ascii?Q?M9uhP9Fxx+/lZSHqFtzQfFdOne/eJ1aZudkUIwe1n9bJ4WTD5/8TELlbvhPv?=
 =?us-ascii?Q?b3KfoyGW/80XIrC8DTN4hPqMXfqPIuKXSGGz4Tsh9fECmStE8HAvFy2gDI5F?=
 =?us-ascii?Q?1Mh/4MZbIFuPo6zRj2A9ZDZ05KDWdeiN2L9kKKqf5KEVAf7svK3k9phnQ+Cb?=
 =?us-ascii?Q?vsj17aWfqyDwsN0aonVGLHuhwvTd8Z84YPKxn3l1QKjOmqGR0k+eplsUECRk?=
 =?us-ascii?Q?zQapxcc7jJd5dkrw1x1k0DytxWA4TOmSchZu8j2LJl4SBd1sxmcGsQldGEhm?=
 =?us-ascii?Q?dEcrRvBv/Vgul9J6IUdlsmqIuhdOKyAh+eA5kHsk5zDsqSC0uFEF6MHL3DgV?=
 =?us-ascii?Q?ekaq4nOgCVesye1/0DX2cSPDhfbeJf9ICXDTt9GLqzg3klQfL4ZzKGoLry9L?=
 =?us-ascii?Q?gc1Y57trpEyy8H6CqXb7pkrW6m9JOEmeOqJ/w2xkekhHjfDkwYQ8CjkTQcN6?=
 =?us-ascii?Q?06/is+J+ez14NpRuXR/9RqmTGkx8hsrBlf8Z/K10jKIzFJTBGEKZGXzUF3Py?=
 =?us-ascii?Q?BAaP5QerXo9eCIiidxtSnBLjkWCiFdRDo8YaMuR+QNHpMLDITfvpZMhkaG6b?=
 =?us-ascii?Q?QDyzsV6pUL/uyycltobg4jwCPSj+irdm5eZMztM6tqxD9tpVhB8z6nHmlfJF?=
 =?us-ascii?Q?zEBmMODRb01YPx75ALoDbFA9fGXMeVrdrzQqyqpufKfyrujDDoFplbJxIOEp?=
 =?us-ascii?Q?Dg2c3KUV/N/sphqSMCPKNzDK+tyjc8TvG6IRM93Gj8ak2xUouWWtWe12q7GE?=
 =?us-ascii?Q?V1FEPMWRIJ2uwKr5y5+N/ZOIMVAUP58sxadtLlSc/V1d4hFitvMEtBaj95rs?=
 =?us-ascii?Q?OxtFxJoqmEAYzjlYvBLQ2RoGOPh1y2Gm+/99KdJeDSFt3XeI1kiFkr6QziJl?=
 =?us-ascii?Q?RtEX404jJeAOEpFYVtAnXl74yxcuCHFa1eVeCYKlWANErsCO9PLmmnm/8b96?=
 =?us-ascii?Q?71bKHY9IfbVXVLywhenfs0Wrt65WUvb0856fYkRwnC0JgP4ygHJcAYGSdpWF?=
 =?us-ascii?Q?Iked2OJfl5kcqlzZI++U0M/DHVbp+PIxDX6BnTV0HLqmb6YLBarGTfAr0XG+?=
 =?us-ascii?Q?nvYTr3GkVtXOcmOD+I9L+e1jQLFIvhKGXE2i5AGXr4FLkZ4xhT6+/AhPQg7p?=
 =?us-ascii?Q?nkuQSBXgPTANk1RkFqp82ApkRoBoja1wV9LBjEMSuSDgIWKNWI3xIGNl9z1T?=
 =?us-ascii?Q?mJSBs8cImEpSscAxNAU29e8/RjjrKKg1TlxPpZkeCBH67AY3N2ug+IJ25n8W?=
 =?us-ascii?Q?fQWbTfXr8BfNLtzE/JsqA5VRlZH+BP1ImwbWQxpOoxaUQsHihj7h5GHI7Xsg?=
 =?us-ascii?Q?X8Z230EAKXsSCJ72u5vcpFiLjDezViqAotyR3YKHW6FlydsrO8nwhswN+krg?=
 =?us-ascii?Q?Y2OtZ8PX43CfHHzVYOgAQFQNtP68QR2xhqHi9tcpjGHYUQYXOH8UsT20pF26?=
 =?us-ascii?Q?ljrx7sTc6Q0tziQJ0wHhfLjYFPyfFuXGcbpII928UH63VUan/e7Dy0C3UhZI?=
 =?us-ascii?Q?NhyeofF1LQqPxTKq97NR/OZGR3Ye7lFvAXxNJnzVLJEZLhmkU6OOI5gWcnIv?=
 =?us-ascii?Q?ZFxQCD6htA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5faf8265-4961-4d76-7e22-08def325e968
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:29.0835
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HBiHoC5DSlxQ5D9rS0aeklxCEC+zltQMCH/iUBIwLiR+FvlZnXI3P1yO4/tuB/Zv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

pgsize is a constant property of the domain, it is the base translation
granule of the page table (4k, 16k, 64k) in log2.

Store it to the struct arm_smmu_domain based on how the page table was
created.

Pass it around in the tlbi.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  1 +
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 27 ++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 ++++---
 3 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 4cd60d3c450acc..002e50d222ca47 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -338,6 +338,7 @@ struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
 	 * ARM_SMMU_FEAT_RANGE_INV is present
 	 */
 	smmu_domain->domain.pgsize_bitmap = PAGE_SIZE;
+	smmu_domain->tgsz_lg2 = PAGE_SHIFT;
 	smmu_domain->stage = ARM_SMMU_DOMAIN_SVA;
 	smmu_domain->smmu = smmu;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f24138be6448d3..73278cc8c5e5ff 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2463,14 +2463,13 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
 					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi,
-					  size_t pgsize)
+					  struct arm_smmu_tlbi *tlbi)
 {
 	size_t inv_range = tlbi->iopte_size;
 	unsigned long iova = tlbi->iova;
 	unsigned long end = iova + tlbi->size;
 	unsigned long num_pages = 0;
-	unsigned int tg = pgsize;
+	u8 tg = tlbi->tgsz_lg2;
 	u64 orig_data0 = cmd->data[0];
 	u8 ttl = 0, tg_enc = 0;
 
@@ -2579,7 +2578,7 @@ static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi);
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2681,6 +2680,7 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned int granule, bool leaf)
 {
 	struct arm_smmu_tlbi tlbi = {
+		.tgsz_lg2 = smmu_domain->tgsz_lg2,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
@@ -2936,6 +2936,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 		return -ENOMEM;
 
 	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->tgsz_lg2 = __ffs(pgtbl_cfg.pgsize_bitmap);
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 	if (enable_dirty && smmu_domain->stage == ARM_SMMU_DOMAIN_S1)
@@ -3170,15 +3171,13 @@ static void arm_smmu_disable_iopf(struct arm_smmu_master *master,
 
 static struct arm_smmu_inv *
 arm_smmu_master_build_inv(struct arm_smmu_master *master,
-			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid,
-			  size_t pgsize)
+			  enum arm_smmu_inv_type type, u32 id, ioasid_t ssid)
 {
 	struct arm_smmu_invs *build_invs = master->build_invs;
 	struct arm_smmu_inv *cur, inv = {
 		.smmu = master->smmu,
 		.type = type,
 		.id = id,
-		.pgsize = pgsize,
 	};
 
 	if (WARN_ON(build_invs->num_invs >= build_invs->max_invs))
@@ -3230,28 +3229,24 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 			   ioasid_t ssid, struct arm_smmu_domain *smmu_domain)
 {
 	const bool nesting = smmu_domain->nest_parent;
-	size_t pgsize = 0, i;
+	size_t i;
 
 	iommu_group_mutex_assert(master->dev);
 
 	master->build_invs->num_invs = 0;
 
-	/* Range-based invalidation requires the leaf pgsize for calculation */
-	if (master->smmu->features & ARM_SMMU_FEAT_RANGE_INV)
-		pgsize = __ffs(smmu_domain->domain.pgsize_bitmap);
-
 	switch (smmu_domain->stage) {
 	case ARM_SMMU_DOMAIN_SVA:
 	case ARM_SMMU_DOMAIN_S1:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S1_ASID,
 					       smmu_domain->cd.asid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	case ARM_SMMU_DOMAIN_S2:
 		if (!arm_smmu_master_build_inv(master, INV_TYPE_S2_VMID,
 					       smmu_domain->s2_cfg.vmid,
-					       IOMMU_NO_PASID, pgsize))
+					       IOMMU_NO_PASID))
 			return NULL;
 		break;
 	default:
@@ -3263,7 +3258,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 	if (nesting) {
 		if (!arm_smmu_master_build_inv(
 			    master, INV_TYPE_S2_VMID_S1_CLEAR,
-			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID, 0))
+			    smmu_domain->s2_cfg.vmid, IOMMU_NO_PASID))
 			return NULL;
 	}
 
@@ -3274,7 +3269,7 @@ arm_smmu_master_build_invs(struct arm_smmu_master *master, bool ats_enabled,
 		 */
 		if (!arm_smmu_master_build_inv(
 			    master, nesting ? INV_TYPE_ATS_FULL : INV_TYPE_ATS,
-			    master->streams[i].id, ssid, 0))
+			    master->streams[i].id, ssid))
 			return NULL;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0eb90c26ff8697..81f1b61ea29c53 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -736,10 +736,9 @@ struct arm_smmu_inv {
 	u8 size_opcode;
 	u8 nsize_opcode;
 	u32 id; /* ASID or VMID or SID */
-	union {
-		size_t pgsize; /* ARM_SMMU_FEAT_RANGE_INV */
-		u32 ssid; /* INV_TYPE_ATS */
-	};
+
+	/* Only used by INV_TYPE_ATS */
+	u32 ssid;
 
 	int users; /* users=0 to mark as a trash to be purged */
 };
@@ -810,6 +809,8 @@ struct arm_smmu_tlbi {
 	size_t size;
 	/* page or block size of the leaf iopte */
 	unsigned int iopte_size;
+	/* Base Translation Granule of the page table */
+	u8 tgsz_lg2;
 	bool leaf_only;
 };
 
@@ -1057,6 +1058,7 @@ struct arm_smmu_domain {
 	spinlock_t			devices_lock;
 	bool				enforce_cache_coherency : 1;
 	bool				nest_parent : 1;
+	u8				tgsz_lg2;
 
 	struct mmu_notifier		mmu_notifier;
 };
-- 
2.43.0

