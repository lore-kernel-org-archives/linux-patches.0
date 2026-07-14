Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011036.outbound.protection.outlook.com [40.107.208.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462C241A93D;
	Tue, 14 Jul 2026 18:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054791; cv=fail; b=fUS1CyBnKyrKfoePc1tJBt3AD2BSD4evEV/JFOCzJ3DP0QKV23w/1UGnuac1+8fqevZMmhvzhwl35ccTaziTLJ4huNAu7LybLkBfGtMkzcmOLyABfJoORfpm+RiunG2hJStGzEpcr1i4vj9sgnx2+6ttQu5d5tb+3Z2GmlcylIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054791; c=relaxed/simple;
	bh=uqiulW779LdUVc+BlYvM21wlgoUgLFeJUJB5zN59GSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gptITNIaszjT32j6AvRf6ucztdD0WU27BBwd08xEgYTY/sGjOYIqadabsQWX6y//USyFifkLweQ4nhPC+rsyXXPMoJHgXqShtasegc7N7Rxs/V7I6vNyZc6x5ptYhhQfQXfCowNVQDL9b2fa/p60wLfGAKavkSlIapA5eMIAjLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ofvVtYAT; arc=fail smtp.client-ip=40.107.208.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ofvVtYAT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gxm6Kj1WV5guo/qbuFAWZ9t5XDwxvrEdV++Xdmv8s4VaEdr8ZvkG5Mb29Jgd2g4o4DSGkFh5ipFOp4KkyQjV+Uf70RmSQI92W9pnJbiytb9rCxC+SlbTa3fLNLd7rpqHUrF3Y1gcRMiTmmAgBeaUhsoY6vICStQml9X9dse9HOG+QYB1SZBTAfjPkwNTa7niuODNADy3M4iySUtJ2g9dg8/GnruTdhrWoA2DGsaTgAmx5Jm5bi5A+1jbdofi+OVUKlOkkYZM22OLefzOakTEtz2wWfa4jXZLkd0W4oo7aNi0duekR8s+SbmrUdX5FA7nCb5YyxNMx8/0gCPWR9InEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fHmhMg/qEqjpVWavrex61a7wYmeLnvlxxxhhpWrjS3I=;
 b=F+kHUj6vWO8KNZEV0G1gzVmYqB4wXPbAIkUyJylt0CHrnleuVxpV3w9WFODz44jnHZZbDxjv1efUoFPTYYGLy7gM9NuDnVCFKBpQ+m/zpg2lr+0JVW2+pc1BVjqRPpj6DzUIlADkKV6WHk6dq4w7CPcFVPGUzhnh4gMuhZN6T6zh4wZ5eAjZgoerPqmkMFleVf1JEmA1ZfIxKHXpXL6AdiYgKbHNSVPhjiixwABdOK7MS1Tht7gfs2J3ulOm9LW82VoLL4Z96idxt2LBXJxGg01K905+hg7Qq4QTXVp8/EUEatdSwHa9TxmS+C58j8TuGudZRxmsmp8ZFt8fAmIjbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHmhMg/qEqjpVWavrex61a7wYmeLnvlxxxhhpWrjS3I=;
 b=ofvVtYATeZd18f78eaIWkbhF1VnN9DFRdWtaVI8MbcUsvFe0CTYrNeuot/BAFBSPQKd7OprdSx0fnBkGYOWA6RonIbMEd62sG8I55QriS8QmpO6RJl70+dDM7643t09ooCp3sNexeA5wgwhiOKlid1wccDp+mIIYGdYMDfac4juQd9EW5JxEbEsEo4W2j8eZHo8gBNJlvCTlocQSziQrCjuKQhEe+60m+XJOhwAcK1UJ8cfXmE4Na9vAsTkV3f/AIx4/yleixL3EHaQC1e853a7tVA9esOAsnEyuvJ6a5WjS7VBxSH8Hosf09lvgUwol2Lv9pcdqmqKipYoP93WrPQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ5PPFC41ACEE7B.namprd12.prod.outlook.com (2603:10b6:a0f:fc02::9a0) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.10; Tue, 14 Jul
 2026 18:46:22 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:20 +0000
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
Subject: [PATCH v3 4/8] iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
Date: Tue, 14 Jul 2026 15:46:04 -0300
Message-ID: <4-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9P221CA0023.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:408:10a::11) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ5PPFC41ACEE7B:EE_
X-MS-Office365-Filtering-Correlation-Id: ce963a77-a33a-4df7-a5c1-08dee1d82d35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|23010399003|7416014|1800799024|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	IwjFDgrHgBuux5omgnEX8JGupxIoyXgKu8TSRI0wuqhRnsnuJzaoYS1B3WrTMJ7b3Zvi7eAIZg1RecmJnwsqA8GV59TvCBG7Nee1KafmaKRl63X2P4Xz8QQbIcMMlmmf5b10dxBScSIM/++aPd/QDl6m5hxmsUyFopw0nVuc4SruSrqfuVW/RkaWL/Rz9oWHnWcZrQmzc6344E+MF+i0xs4yP1z/vQ8JU5MQ/xoFHOw7ZcuGFpqEY6O/BPfnijPwfe1O+I/SjTFB/kEITvZRsoTyNQYMiIq6Gv9GRAJlPOjKMHGd3WWpD1SxReYIk8/6QUTN7ZHMomZj9K1MsxNXa4TJtPnxh+zj7/b7rEcMcFkA4zK98YTxUawD/OxIC/iLNGj2smO3dtQ/0FJCRQKM00b4ZiFnbS54MiPGK95/AxiyiHwgvhTEAWo0Fb6AA33r5L3heIXY+kh5mVIKNBeW/9jnl3ndGOLkyh/5gjgyhLzCm3tgPDSiiiIStGPsXqsfujmksBnoPflSjku/bO2MkIHh41ZDOX7olvucM1lTycsvdmNz5JRgT+1PddmCgDZprFu8hh4FFTuByeZoIjffR5lWZyaRPoKeT3ZT5p4/OfKoIrT/fJyW4Y4GgpFYSciw5h4qMLmIypAlLhQ4RGrHELezAj0G2yIAw5Ee9M2HYzg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(23010399003)(7416014)(1800799024)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mfLI0zTFnOJ0nOhy/TizYmT04lUEVyfXUHbMLsDJMfBq20yejxsx2YK+vZOA?=
 =?us-ascii?Q?5p6KRnq80lC3yj7rpEHkF7cc32rAvBTDS6P7Rwh7AcuS6dDf9YrJ+9hwiIWd?=
 =?us-ascii?Q?tfRK5y7I0TqVD1eYQAZ6hqgOglQafJZNA3jthpYmmQ+G0zafNKtrZUVvaq6y?=
 =?us-ascii?Q?FwqlZ3grdk47sgmHhTt2nz7zKv6/yKPlVK+DXnHw4yWwC34kOi2vpnGKEanI?=
 =?us-ascii?Q?NrfQiAYJK7owAPbm5/0aLWiINnMNWv7nxoz14XQr3SebHRgGIDHpA7EaPjvj?=
 =?us-ascii?Q?MbkwSQpf5s6StjfYf1ioi9/Eeluxfis2oGETozAUhwMQdUnaJ1RT82r5wLPa?=
 =?us-ascii?Q?KCoOq573uxFkvicvvJcu5cZV4pdxF64t2/CZTXt75FDq/CCBOWNscw9WQn7+?=
 =?us-ascii?Q?uv+fFg5UJtr8SsdL8aa90zEEFJ//ZnRGpwG3H77Pz8pWm7xBbqiQa8Bk9D1V?=
 =?us-ascii?Q?T5Y/1GZyHeUahcwK2yjWgX9Jxg4h2G9n95DwHBqkCFH/sw/0DYmiq83jnZw2?=
 =?us-ascii?Q?fROtbnKr7vfAEHF+lzwakWRIuqOMmw3jOR1ejjZOj3CjVKgv0BaMQ8BmMh8b?=
 =?us-ascii?Q?1SqQ+TQDwCyId3GSC5I59ersHEW+UNHPPuuoVOUlgKdJAjvUsCc8uo05Uy/p?=
 =?us-ascii?Q?swNntD5yPZr20Vuc4/Bv+EyOQ+YVDKTrMEGCp84Amccza2TUdZuhXH9vhp1P?=
 =?us-ascii?Q?7fdtzJZeom5oUGC2D/CoorR+1WH4/j2aUFsJQ45HWp0TfDz6Lkgtk3Mg/hRf?=
 =?us-ascii?Q?z7l4Ir+k/QKvckWO7/5ElXgYTL58aRusjurVHh1ZhGRxB0o3EAKIWN5Zk6Ov?=
 =?us-ascii?Q?eWQ8cG5Dij30yqHRi72jXk+zIMXKkImB0LQ2ZR8OgYvfe/235UWxqFibh1l/?=
 =?us-ascii?Q?qOHXj+ECdmiM0d8OGODJjKRyWGVTNxXIOmYu+gJQX7n3t+wZ7BuMOVRnT12f?=
 =?us-ascii?Q?Cc/c2YJcup4dWSJz1ELFb18CSYMCmTRBTgJHAn35au/a5p/9Hq8OjNG7HXza?=
 =?us-ascii?Q?XBHTE5CtPmlkPkYRCCajE4UsBdKVKikdaVFUOjjWJbHBem1NQiblHaT0vAy5?=
 =?us-ascii?Q?G+feTsku9UBLxhdrJeGi9iRaaHZCLof4N5pk63BUK1QWWjojg0PRm3HqpQE2?=
 =?us-ascii?Q?3mDpF87fzBcDo2sg3DA6EY+G27TCvJ0FxSgZmu7Zd/sUn87ngxZBuk+9EzFo?=
 =?us-ascii?Q?waHiKEX2twOQsaGJYwSDLYplz6gQe7Wg42UTxEjSC9eY6swoW3Uh5LREa6eq?=
 =?us-ascii?Q?Olja33sGA8hMQDmqO7lBQdSVSl3an+tKNbq1vSgmV5hMXl1k0R+qbqxH78+1?=
 =?us-ascii?Q?RnFdon6ntewAq7aw2IgzuN6aln9LIPtVyChwfmpWSH56GYenwzkS37d9+duC?=
 =?us-ascii?Q?JzG0svvmzGtd1b9XzfQsGFA3Sk1ml++bfds2RI1YAMntPnFF3I3oTTm7hmZn?=
 =?us-ascii?Q?aJrmDUC2vqCnet7hbNeMla7kc8pqmLq83XSJOBaVct4xoM8X95eMul8WZa/P?=
 =?us-ascii?Q?YFem9iqLgXFRQD3l9HUe36WbnQuIAwX7el6GlxlKrmJkt2DaMkhIU2JnQkB9?=
 =?us-ascii?Q?XfGIDtH6p7pTkGS6/9DLmBbL6GLDfhkQvCl3DFM7oN/0QDVhVFJfM30DLjHx?=
 =?us-ascii?Q?UxZFytmDSG7CnFcwxZBnHFy7w+KLT4OgjMBl2F+jq9ixDetf1Os0/45lTyus?=
 =?us-ascii?Q?uj3/PJzY3uKFyQyv0VLHN4OkycB6v27Lv7mbLOAWmLe+XWUd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce963a77-a33a-4df7-a5c1-08dee1d82d35
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:12.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pP27CuBLqSuJ5Pmd5KMa9flhehWb4vme5BlCBbwwxkoyNeOtIrruPBdHFH9bdYl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFC41ACEE7B

Summarize if any of the inv entries will use RIL. The next patch will use
this to avoid RIL pre-calculations unless RIL is being used by the
invalidation.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 30 +++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 18 ++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  2 ++
 3 files changed, 31 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c828c..785dd21bd68b7a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -655,37 +655,37 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 
 static struct arm_smmu_invs invs1 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, },
-		 { .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
-		 { .type = INV_TYPE_ATS, .id = 3, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 3, }, },
 };
 
 static struct arm_smmu_invs invs2 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 4, },
-		 { .type = INV_TYPE_ATS, .id = 5, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 4, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, },
 };
 
 static struct arm_smmu_invs invs3 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
-		 { .type = INV_TYPE_ATS, .id = 6, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 6, }, },
 };
 
 static struct arm_smmu_invs invs4 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
 };
 
 static struct arm_smmu_invs invs5 = {
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
 };
 
 static void arm_smmu_v3_invs_test(struct kunit *test)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index b40ae0d1355477..03ca10bb2da99f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -988,6 +988,18 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 	return arm_smmu_inv_cmp(cur_l, &invs_r->inv[next_r]);
 }
 
+static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
+				      const struct arm_smmu_inv *inv)
+{
+	if (arm_smmu_inv_is_ats(inv))
+		invs->has_ats = true;
+
+	if (!(inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV))
+		return;
+
+	invs->has_range_inv = true;
+}
+
 /**
  * arm_smmu_invs_for_each_cmp - Iterate over two sorted arrays computing for
  *                              arm_smmu_invs_merge() or arm_smmu_invs_unref()
@@ -1058,8 +1070,7 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 		 */
 		if (new != new_invs->inv)
 			WARN_ON_ONCE(arm_smmu_inv_cmp(new - 1, new) == 1);
-		if (arm_smmu_inv_is_ats(new))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, new);
 		new++;
 	}
 
@@ -1169,8 +1180,7 @@ struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs)
 
 	arm_smmu_invs_for_each_entry(invs, i, inv) {
 		new_invs->inv[num_invs] = *inv;
-		if (arm_smmu_inv_is_ats(inv))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, inv);
 		num_invs++;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 47241c0ef54cde..5fce48859ffd7d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -755,6 +755,7 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -784,6 +785,7 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
+	bool has_range_inv;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

