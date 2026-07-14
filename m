Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013005.outbound.protection.outlook.com [40.107.201.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D1F2DFA4A;
	Tue, 14 Jul 2026 18:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.5
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784054783; cv=fail; b=sRKuulJJ1nMfY1nU7ptSfmNsz0Er16sUX3ATc2iMRn/MwCpqNFbJs3Bb8DC6K3diXJc7f43E7Q4+O0nmwo6Gn/L2YeFIbAHHV3w01vc88oiX1Vr9YXnq1Ob2XJom5ERachwOuFU6d1fnNjZFaSi1cczqF2Pbx/c01oTUXAP2UCY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784054783; c=relaxed/simple;
	bh=jGXz8JU+TnVhXWo/HJ63fy/Rh8WZLyWFPHXzzJS4TXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UIZp3P+fglcspAMpSycm7lWfA7WxCTLk0clKivnkLP4dyhm8WvkZ+7WodqujtyK9Hs4m/Ya4giPQf6G5ia47SmASncmkgbbjemOXXTWzSip9VylpL3E1lpUywajhAHlN3YasUEQRYNZyAgdVuUjq7CakgML34hkq6UvMwGtgftE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Vn1drNv/; arc=fail smtp.client-ip=40.107.201.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Vn1drNv/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hlZ8PQgZbdZOgF8XW9H7TTwj3Ok78YOgMV0lw6QF/qvR9dULzc3cmyQsp4EweVJ6CKcC6x02ybNpfDCMP/KslVxg2fvmx+5Kg/nULf5rwIMPVT0GZeDBgvlDUm+QGJz9XZ91VDqh/+De5qM7xqju0zmLbob2Opc7bTAVzD15q2Pt7AZTJkm38pZ8hB2Ky9qU8aPXVUMvIuzjPM+WuxzvWKsF1KoIr+WD8GnDuVu4nIBY6s/qdBFkqFH57vbD9edtvJJwuvxXKmtSKkv7K4ObDIdZeZ9X+7tLkMwsb9Gt6DrHHGp7BhMB1bA8+1UPkgq/MF1LnjJN75JJW/ijvwtTPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4MHxwRuBWSPH/6ij+r0mROoCyHIipldQDPurQV2sQFM=;
 b=snClu/5AZkUoZm22keC8VUiy5WUSN9kvwycwMNHz6FjhPK0LtiJ0hffJLlmYQY0x6RxZf8xxbMhteFdXdyeVZflDL9pE+5idL2hicLF/ypE91ToX1ec/OmQniN+DFQnZiS5dT0QcQBtDu91RhhT5Cf1rVv29a1n8Yg1D9+v1Qg4gyQ4frCTrzm1EuyYH1uHQMmWsvtzR/b6DuQdR8eW3RCrwlYKOLHL9wiTrR54EmkprJtWaUt6Jo8wahErQYPYMplKGeLePl558hRsRNhOFcA7yabWh0Z5TOrQcjP5f/L6R/KoMtsbtgf1KLoqSDvKMDsv1BFz8knPZ8o39MbpVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4MHxwRuBWSPH/6ij+r0mROoCyHIipldQDPurQV2sQFM=;
 b=Vn1drNv/nAWb1t3wsc1sGI1XXXS0dInMHS6GvsQ/OO3Sb24FtH253Dwb/uTxsMIkZfTuwYMAwIjG0aZAdEYOE/SpQY01TpXThRvqkhSkbhslg8Xm6RzpHaeov7niBFVoKlMM/INBB9FlHD8JcCSA64MovvIHI7aOa6vQfLCU3IJtdz8+TCBkmVfZU80834aeILoav4kmNrGJGm9pjLVLHQwIMFYd+UeKNTwyU6v0VvvKOLXF6WIx0I9OaHMNoeiU3yyBqmicxQfPLoHi8+MEcaDZdFCfbfISUnyNsK47CmejurMGu4/stewCGrgGTnY6TcPJG+4lTQvcvHv3DLpu6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 18:46:11 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 18:46:11 +0000
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
Subject: [PATCH v3 5/8] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Tue, 14 Jul 2026 15:46:05 -0300
Message-ID: <5-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v3-4e7f64f4e094+85e-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0539.namprd03.prod.outlook.com
 (2603:10b6:408:131::34) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f2d0cbc-04b9-4f31-1a6a-08dee1d82ba0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|376014|7416014|366016|1800799024|3023799007|56012099006|22082099003|18002099003|11063799006;
X-Microsoft-Antispam-Message-Info:
	YruHSA8iLIhK905qznq0H1hYoUraZjLAslQqlHAjJH+/y7rcWQ1CgAXcCf3eoO0uQn+3+YlUHJt/oezlDy3mJ9lFqiXngazO1i07/ZparoL6o+dHMrn+XKQBEWhvMUwF0nqbztogxC7ic7xy0mDDIt4ZNyetqD0WyV8seUpxjhnDK1xs4nXf7ir/8z6v6d/EMsfkF1vu+lO4zXTO1T2cn36gcr2Xbk5FiuurNgAPozEpL0Cd8wTmYP3fLq+ugMSXr81VardtgUqKMpkvlCoUiVSxPRoA0TgKD089Djhype1eCeAk9dfDb4eYzzVxCnawnAZRxp3+R4cN04ISj+x9waSogEgMVEBCzI36eEzg0v8yArIBPTZ4IvsHDdzqKQCbgo+cvW6/KoSMzSzsGUQhx4f+SrFa1k8qRzwds63ItTABc5H9s7vrrW98qFSOBFrlkU/aNXpPdqqpTAWqJmlQLZ5Vy/aaH2ljI+3DZJnDOLLdlq+BX9bnr/72RMGQlpDH7qpI5Tg+y3tR+6Y6Bi1udkZ/OJGil6yQWCYkelc8va0g6tv9PyCmgOWXoL/FEu428qPZZQsrX5TX3CLwXZgOVBbCNzliG+4A7r2OCGW+iwg26uwGJAuPz+m6BW8FMaD9GaRC45cjtpwfUW3XIbUJjpu3SKgJPb9D3/HiGmhdSKw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(366016)(1800799024)(3023799007)(56012099006)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nK6dxKW17QVMUVW35xD9m3j412zYv1s5npX0zcqAIc4eJV852y14u3kK+du1?=
 =?us-ascii?Q?bdPZkcbk6xUCV/K2D/nZb7FSB272RIpTROJ7A2QLpgQG1GRlKVuNGtiWrzX4?=
 =?us-ascii?Q?SwGM1JNm7/vTAgL8Ermkh2M+CGGruMIFo/AZZjvnqsV752gtTEEfKsAPZCZh?=
 =?us-ascii?Q?OWg4RidT2yyZY3M/CeAFuXJfc5cAxgKTzpfXZWvz/SYn7VCr/9UaVauDdLFY?=
 =?us-ascii?Q?t9RmHEAeXSpnSrZCF7jlSrWP+M4vPzcX3vpToA8v12unOBtH88RXMO6S1ioo?=
 =?us-ascii?Q?KbmMgt4AjPIqhEa3v/FSAkBdFvkpte9xsrcvlCrchTFLtPHg9gh2WbVBbczH?=
 =?us-ascii?Q?xGJTVU5kaWDtw249UpnmHxc8EScXedDW21ejG5VgpDRa6eBzTxno5N5/EHx8?=
 =?us-ascii?Q?nWDq6kIugkvqxliVpIZe0pLUVk6cp3XpMU3+IlpNR65l91/EepH2hrGlndrB?=
 =?us-ascii?Q?SGIXe8WxVnid5S3rL9s3/pozq9T5ttzcnApFTXNEXjmnvQGr9/k12JXcCsZ3?=
 =?us-ascii?Q?K2DECeiFXf4AGXlDxNVo0b5dgde18cctKwxO7W0m9Nc34aUPjXLNebLFaeJN?=
 =?us-ascii?Q?SaoAQ/0hgFC0S2W4Hb5wMyiVIary8QTWBbMFjIBceO7PxO4TQslOGG86O5z5?=
 =?us-ascii?Q?+GchCwaMnW0W9H55qfWrAZm8fIKhV9iDlm24ihgc83ByAQYVaIQnA8/WqQvm?=
 =?us-ascii?Q?/uKc7reMcJpqkISXt14dmeGO4xmEFVJ4JkoyAVg4pdLNqonm6+VfQLIByd2S?=
 =?us-ascii?Q?4r4sX4k7tvPwFZbh4Z77uEhL82sDs/EuUaFe6n0r5gwHYqv4T+vIMFiSQFFr?=
 =?us-ascii?Q?RvpVHBpmc7//yS/jIq4bV12J0lCASs60WLujOmJUR93LelNQu7B5j8knevwf?=
 =?us-ascii?Q?6fETRvs02gBH80948EOjlhdN3q6iDP6A5tiqBWKpe+TbGGasqPmiUwQc7Q+8?=
 =?us-ascii?Q?xApAMRuz52OKRro1niPGgQF0Xd2rxpwBJhuT0XVccxE+V3tcWbg0o8UwK7Sa?=
 =?us-ascii?Q?vTse1rABLh2aIgf6FeCg0wyr6AmZd5eENmdSvOy8f3h9ruq21z33eBWZmu7/?=
 =?us-ascii?Q?l2RX2E0Eyj5cvLBzpeJdU6xuIFI1+Z6JlgT5Us32xDdmDzHkSFfwoF1R9NMW?=
 =?us-ascii?Q?XuyrHTmG2Mu4UUGCSaFF2cE6fcIlXw9Mmvkb0epg202qzTI5g+qMk8XkaKP5?=
 =?us-ascii?Q?haBs5fa7z43RgNJiQEw6Zs+rY6MwPCxoriXhnu5mxrfiDHjmViLQzcdH3UJ2?=
 =?us-ascii?Q?DNPrYN9oP0tnxDSCnXX9//iZKzNTILtmiYkQ3GV0bezBrF6y5MMn+I3xBsYx?=
 =?us-ascii?Q?WYxBBwkZqLmoPs3fxLloCncz62FkBa7jodQW7c4teiiByXf3Wg6mmt4Be4p8?=
 =?us-ascii?Q?PNb+mIToYCyR/I8FRQhc2bMl+K3ZtTYKIYPYHcdkCAkPHSj7sItiei4f1TMR?=
 =?us-ascii?Q?8+mAgLs0jnfAFuh/AX2zekv3eWjVO1XSae3dD1W0S1PtXmvvM+DblnZN43/9?=
 =?us-ascii?Q?2W6alFLYk8F2Q7M+RtD/8VWNtMKfdEhllCSkUEWo0F2DlmQXeWbCgc2rdg3a?=
 =?us-ascii?Q?HXwF8HBWmOqEBVaPWy1Djzs+9LTnDUW9VVuroSIp6tAHJsHVgxirkS1VGoTb?=
 =?us-ascii?Q?XwjZ+v2/9hu6+3SMx7uFxp3GWhnuHxXYEfGW3L1BlDhhLZpzYY8wDLGnfVU9?=
 =?us-ascii?Q?2AUKTeAVkrvUVIatO43Ca0l6FS8tUdvMaGP7W38KidHna+yK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f2d0cbc-04b9-4f31-1a6a-08dee1d82ba0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 18:46:09.8245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6CJ6gU0QCIpoh/xBVNdJsjY1z3ZPohFtZFQO595+kr0F9v1sj2Iy1TL4sJL2v8uQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on
if the instance supports RIL or not, otherwise it is always the same.

This avoids redundant calculations for each invs entry.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 128 ++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  11 ++
 2 files changed, 78 insertions(+), 61 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 03ca10bb2da99f..c712b4d003ec76 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2417,32 +2417,15 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
 	return !(address & GENMASK_U64(pgsz_lg2 - 1, 0));
 }
 
-static void arm_smmu_cmdq_batch_add_ril(struct arm_smmu_device *smmu,
-					struct arm_smmu_cmdq_batch *cmds,
-					struct arm_smmu_cmd *cmd, bool leaf,
-					u64 address, unsigned int num,
-					unsigned int scale, u8 ttl, u8 tg_enc)
-{
-	cmd->data[0] |= FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
-			FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
-	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
-		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | address;
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-}
-
 /*
- * Issue a single range TLBI command covering [iova, iova+size). Returns true if
- * successful, false if the range is too large for a single command.
+ * Generate a single range TLBI command covering [iova, iova+size). Sets
+ * use_full_inv if the range is too large for a single command.
  *
  * The algorithm finds the smallest SCALE where the range (in tg-sized pages)
  * fits in the 5-bit NUM field (max 32 units of 2^SCALE pages). This may widen
  * the invalidation range.
  */
-static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
-					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	u64 cur_tg = tlbi->iova >> tgsz_lg2;
@@ -2452,8 +2435,9 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	unsigned int scale;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
+	tlbi->range.data1 =
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | (cur_tg << tgsz_lg2);
 
 	/*
 	 * Determine what level the granule is at. For non-leaf, both
@@ -2471,10 +2455,9 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	if (num_tg == 1) {
 		if (!ttl)
 			ttl = 3;
-		arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
-					    cur_tg << tgsz_lg2, 0, 0, ttl,
-					    tg_enc);
-		return true;
+		tlbi->range.data0 = 0;
+		tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
+		return;
 	}
 
 	/*
@@ -2498,7 +2481,8 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
 	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
@@ -2510,38 +2494,28 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	    !arm_smmu_ttl_addr_aligned(cur_tg << tgsz_lg2, tgsz_lg2, ttl))
 		ttl = 0;
 
-	arm_smmu_cmdq_batch_add_ril(smmu, cmds, cmd, tlbi->leaf_only,
-				    cur_tg << tgsz_lg2,
-				    DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1,
-				    scale, ttl, tg_enc);
-	return true;
+	tlbi->range.data0 =
+		FIELD_PREP(CMDQ_TLBI_0_NUM,
+			   DIV_ROUND_UP_ULL(num_tg, 1ULL << scale) - 1) |
+		FIELD_PREP(CMDQ_TLBI_0_SCALE, scale);
+	tlbi->range.data1 |= FIELD_PREP(CMDQ_TLBI_1_TTL, ttl);
 }
 
 /*
  * One TLBI command per IOTLB entry, assuming the entries are all at least
- * iopte_granule sized. Returns false if too many commands would be needed which
- * indicates too high a latency. The threshold is similar to MAX_DVM_OPS in
- * arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
+ * iopte_granule sized. Sets use_full_inv if too many commands would be needed
+ * which indicates too high a latency. The threshold is similar to MAX_DVM_OPS
+ * in arch/arm64/include/asm/tlbflush.h for the 4k PAGE_SIZE.
  */
-static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
-					   struct arm_smmu_cmdq_batch *cmds,
-					   struct arm_smmu_cmd *cmd,
-					   struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_single(struct arm_smmu_tlbi *tlbi)
 {
 	unsigned long num_ops = tlbi->size / tlbi->iopte_size;
-	unsigned long iova = tlbi->iova;
-	unsigned long i;
 
-	if (!num_ops || num_ops > 512)
-		return false;
-
-	for (i = 0; i < num_ops; i++) {
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
-			       (iova & ~GENMASK_U64(11, 0));
-		arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, cmd);
-		iova += tlbi->iopte_size;
+	if (!num_ops || num_ops > 512) {
+		tlbi->single.use_full_inv = true;
+		return;
 	}
-	return true;
+	tlbi->single.num = num_ops;
 }
 
 static void arm_smmu_inv_all_cmd(struct arm_smmu_inv *inv,
@@ -2561,16 +2535,32 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmd *cmd,
 				       struct arm_smmu_tlbi *tlbi)
 {
+	u64 iova = tlbi->iova;
+	unsigned int i;
+
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		if (arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi))
-			return false;
-	} else {
-		if (arm_smmu_cmdq_batch_add_single(inv->smmu, cmds, cmd, tlbi))
-			return false;
+		if (tlbi->range.use_full_inv) {
+			arm_smmu_inv_all_cmd(inv, cmds, cmd);
+			return true;
+		}
+		cmd->data[0] |= tlbi->range.data0;
+		cmd->data[1] = tlbi->range.data1;
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+		return false;
 	}
 
-	arm_smmu_inv_all_cmd(inv, cmds, cmd);
-	return true;
+	if (tlbi->single.use_full_inv) {
+		arm_smmu_inv_all_cmd(inv, cmds, cmd);
+		return true;
+	}
+
+	for (i = 0; i < tlbi->single.num; i++) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+			       (iova & ~GENMASK_U64(11, 0));
+		iova += tlbi->iopte_size;
+		arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds, cmd);
+	}
+	return false;
 }
 
 static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
@@ -2589,8 +2579,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	bool used_s12_vmall = false;
@@ -2687,6 +2677,13 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	};
 	struct arm_smmu_invs *invs;
 
+	if (!size || size == SIZE_MAX) {
+		tlbi.single.use_full_inv = true;
+		tlbi.range.use_full_inv = true;
+	} else {
+		arm_smmu_tlbi_calc_single(&tlbi);
+	}
+
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
 	 * an invalidation array. In the meantime, a domain attachment mutates
@@ -2717,6 +2714,15 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_lock();
 	invs = rcu_dereference(smmu_domain->invs);
 
+	/*
+	 * Only precalculate RIL if it will be used, invs generation ensures
+	 * this matches the instances used for invalidation.
+	 */
+	if (invs->has_range_inv) {
+		if (!tlbi.range.use_full_inv)
+			arm_smmu_tlbi_calc_range(&tlbi);
+	}
+
 	/*
 	 * Avoid locking unless ATS is being used. No ATC invalidation can be
 	 * going on after a domain is detached.
@@ -2725,10 +2731,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(&tlbi, invs);
+		arm_smmu_domain_tlbi_inv(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5fce48859ffd7d..e1dcfb99b5e413 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -811,6 +811,17 @@ struct arm_smmu_tlbi {
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
 	bool leaf_only;
+
+	struct {
+		bool use_full_inv;
+		u16 num;
+	} single;
+
+	struct {
+		bool use_full_inv;
+		u32 data0;
+		u64 data1;
+	} range;
 };
 
 struct arm_smmu_evtq {
-- 
2.43.0

