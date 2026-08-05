Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012012.outbound.protection.outlook.com [40.107.209.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5221F3E0C57;
	Wed,  5 Aug 2026 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785957369; cv=fail; b=njRS0iq+CwiKxt75klLbFdmQVhJJ+rNKfLgjVoZgO7t9cn8UjZagy8sh3yX0o5ZfODH4pCIHk+E4mCfbiF5ZJWCDZzQ30nNh47qKwye6HhRNBgRYxw/bU9dKOhJtLD+KkcWAAF7Sr6pX06hFJv7dUDDxwT9kObM82yt1U27cki0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785957369; c=relaxed/simple;
	bh=/ZZpfXNYRiM/sCJlVWWQZbCd/dnvTvCn5dcivyViNJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=n2kOKAtgFukAzL2KvdFHCiU8+2jxg5fo5sIqlTFax85Yle5w8AiliO2G5M+mHSBH0TRd8RZ4ang2Nae3VYqJbeeaxihvKXGTH/lB2a8lzPYySbA0lQw+QNHTdVUoTIjBwAgAmW6gfg+FaEqDuUjFWF4RqOExWskF/ENKL/ifv2Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=di17o31N; arc=fail smtp.client-ip=40.107.209.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="di17o31N"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Nb+buzgyTCp0RTJCO3OutSfvccCgDxCthY3Jddej7A6wWz273wzOL4fvJJA4Ixr3JrJWmLpTx+T9QzjAeTj+PvLnck+4SlFEVszrmDeUDiiPya+FKfnEHOZjJ90EInPFolooxVz/LE+ME5AWyfHErS5nrh0XV6D2qkcOFEBEwI5ozFVt+0OsJS5L/rG0hi64/8LnsDuVnxvBqEM4qguk3V17H24caHDPYyx3SI0yADTllzo1bvCkGtqd/9EulRzw4gRuaSR7mhcPMQZXE6vREGE7W6H5wBXjGn93RSvWBLSstSgE2zygVQL/6dTw1qvOYaeIydaEto6sP6DYrr7Lug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKKRCBlqmfghV+o1u/j3QUArykIXYZQYJXdu6AksOkc=;
 b=IumVscG3U5l1Iv4AunCtXgRIX2HXpXeROCTs8/uxOmbUeY/a3YleTBbUCvxuz9sEmsraCZ2Rm62GmNo4h/vd6Q1eIk2ODNbP5vZ4qlMW6IPDYgYE2SAcnpkM/KwA1vKT9c92Njc38BLFjSWUeSRj9J9ZBL30jBu9H4S8jcUe6FggiZup1SAqUe554p1XIoh+r3Ikp6CZcKKT6T874LHXMpNxeBR781evv/5uSGeOin2ND/x8UKzbxL3VUfty54fEneZaWAHnEVSpl3FjVh2YRh1Q5SESH5xQVkycN8LAkWYNRzM5EmNLZPn0RFzrJ6avxQvwjTS9bx2SWfe5oYNnXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKKRCBlqmfghV+o1u/j3QUArykIXYZQYJXdu6AksOkc=;
 b=di17o31N/lIu3nfF/EmJW594J0YRJCJCWUAQu1HqDbBnli0jvTpIxPiMMMMdYiYLJAkF27DoU2kG4gpGOmglzNziwBkeYYTdbmjGku/QEQltvFVz9lO8mximGza2tIn8uOlLFRwvrUP5Ab+z9Cyc912vWGVzv4WMs1cYfe+n1AOe4NjjV7rA/EuS9sqIZjFHTSn/hKkTi+LEb1wtHXxzUBqoKzFjWun4vsekNSZs/887nLiOp615GA9rN/EA/eUl7LUoeoWOHzLzh6QOSdz0NOUNXitXmLTT3wFaM6wY6n9WSFYBWHY7RX7O1BO7kyxvxtchba3iTWW4NPY/PPtuyg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY1PR12MB9601.namprd12.prod.outlook.com (2603:10b6:930:107::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.16; Wed, 5 Aug
 2026 19:15:30 +0000
Received: from CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3]) by CY1PR12MB9601.namprd12.prod.outlook.com
 ([fe80::cd76:b497:475f:4de3%4]) with mapi id 15.21.0270.017; Wed, 5 Aug 2026
 19:15:30 +0000
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
Subject: [PATCH v4 5/8] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Wed,  5 Aug 2026 16:15:23 -0300
Message-ID: <5-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v4-1802653d8886+492-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0081.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::27) To CY1PR12MB9601.namprd12.prod.outlook.com
 (2603:10b6:930:107::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY1PR12MB9601:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2b5f08-8091-4735-5c20-08def325ea2c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|56012099006|10067099003|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	U7IKF0OPh6oup881sasbOxsTBbNOlwaaYoiUTTvWeLnkort79QTBxzpeFhbq4y4dm5K1ad9pohF7oBoUTBktEoFAPo4Jti7SLjYu4SXxbeRed0Rxb7zHCfLOsVLf/qymutPNJN53COFpD8vB7Hd3gcmbIGVN2kMYuCV+xIr4CSw0HXC9HZketCmFXNYeJDIBgv9dwVOm33H8RVjLbYhr8TdbOwfqkPVGtdEfC8Jf/mhWtvEiGN+IqsOoJgB/PHB11YLwR3C8dfVkzCBPaHNy4QYVPtflBJm45CyEjPTBB+beUTHSpR3odBhGqMsxLPc20GNEPU+1pQX0s8SOQ81Rcf0TrKIiCaxjTiNJ7o6U6gnuO6LrncGWlxbL20WjHFF/fvj8V7IzaiiOUYFYFuGVCVUQvSJo9lp8LYm+l0VaHEy0Uv9P8D01KKRxypfY56UXvXDeS0hGSbyS4tCtIhmCc+glizKNpb9QVLdb2a9V9aZdXxHRL24tgvzq710ZcGRWmnM0a1Pj2wS4Bd9dCLfgw7txSqxYaVkYyh+vrEfMCaE5/J9Mja3/FypEP1Icbs5HcxkXV47C5DTsUXnhLO16QIKEJL+m00sRwaH2YLuab7ARogXqrHDDiGBWHivVfJ/Y5/ALGUcazOzl8m6eR9vRBtjAqQT7m9L4WaY+sI1m18Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY1PR12MB9601.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PjispF7IkuXRCk+qwnkyUxfDh896Cd4/Rm6fKTXLOXFjGg3vzaP2YQZmZ2eC?=
 =?us-ascii?Q?783M1KSbfwM/Sqj6+e8KPzsuHVlETYDpE6/Lx6bu5sBEaBDd0Z1L/VFbJTGK?=
 =?us-ascii?Q?n/xK+bnU5cR7nNyPe7Pxwhddo9w7+UDoGUx/DlST+XRruYfBkQEzBdWcIUyD?=
 =?us-ascii?Q?MXK2iGT730J0ibbUyCqPMMh2mIUlzivvQO6qBqdfKD0jyPZi2UYHXjAEya2J?=
 =?us-ascii?Q?FNfr9wOqG+wTDLtcW7nxPFwCf8kMjwpSmmm6HSj5pyyGY0kKpcL2ByZgW2+I?=
 =?us-ascii?Q?GcDwx86hRf5tfbg90N7ia5zoN5mAX+ALJ9Yc4h5iJrpbKpDrv/jvVjbVDIbj?=
 =?us-ascii?Q?pxpYQia8SZFvHoVzGrtgnqzGNKAJMXqELoZs9IofgAhA5w+ZQsBlA8gM9/+W?=
 =?us-ascii?Q?WPtE43Fb76gC+llokKLSwP7hkDzMfsyk3GZLd7+Jzsx69LQgCGoDk1QTfCxN?=
 =?us-ascii?Q?ww6AWBpORuExGt7D3Tnk7m3H7lEU6iuYKOk92DpGSz0hxVzp8coP+ibW/sXl?=
 =?us-ascii?Q?7rsd1fJKZcm+OJTB9PRtMqDEnVxFm7olL32uQVoZJhNdCikWjLjB7ilmlS3l?=
 =?us-ascii?Q?P4t90Ca54eKoGsACGYyjS3n1+nArT5TrxpXILqhkaJmWcCLZUmhwdoNnZAdV?=
 =?us-ascii?Q?JUNDrIS6b9wrnD0qETqwygXd9hLIqKbQQocrC3/CBopj9oZLX/YPEIM0aZQn?=
 =?us-ascii?Q?vzW+WRFxSBlHj1OgEpIqG4U4eObddzJJMudUTrtN6gDZiA0NIpwU7nq0zpkg?=
 =?us-ascii?Q?lrE1tEtL6fPFLyODrKwB5aLa8vWcagi3rLj2DMxZ/NGvbtapVEu+3W5ORyOA?=
 =?us-ascii?Q?ZpCDed9xzjiKObkDEOGyK4Py9M2B+Wogjxdpo4KZAu3rKO+UiM0wX0EmU8nS?=
 =?us-ascii?Q?70J916fW1oLmMPhEL7YzYociiodrDJytScANvAQ5hRupOhFsiJGxR9rt9zFY?=
 =?us-ascii?Q?ofB1FY/DOqFA3S5hqOht/4FIzQFzTjEcECDxfNlvWP90OC/75Nj5v449+6Pb?=
 =?us-ascii?Q?tzeF6GZkOz3AZ2uLZPUIWcQ5L68PfSeRydfkW9Fn0UbEeDKLPj1nX1dKdYaW?=
 =?us-ascii?Q?cr0GMk1W+3h676pdVWgUNCatIUciTNzvStBliotmrjOu8TYP1Pw7KUsYre0O?=
 =?us-ascii?Q?NF08oJ4zb2WUPTzC6SgahRXmAcbkqihNVI/2SvwSMh6TL2ii+VcJHNMUSIRD?=
 =?us-ascii?Q?C7epOlp6mN2nfVB50PDgm6hK/yyZt64AYs/+xyUK+D/3L2TkKuJoxzytXse2?=
 =?us-ascii?Q?/psdPytKav5D9Ct5untfF+SXTPKPJrc24yriBeLohCf0Ed0BWmedr7tin0uX?=
 =?us-ascii?Q?3koR3ArQC9Du1EYEVRlbLm5Y3hotLhnbqArwZ5i0Lr6kS1WqPsijtI+Pg8z6?=
 =?us-ascii?Q?QJlN4iceFSb6gGJOzXuiUfUSXhXs6BKh90egvXFUMkiOdbsb3Xhao8opHDY6?=
 =?us-ascii?Q?lwx0EEE6JSTVHbYvf/faebDHD9nim/O8Z/PEhoCeanY+SIahGbMQ6cTlyRRN?=
 =?us-ascii?Q?5iLhxGBvyuSNzSIjBRAH710CJLHa0rpRQfPqvj7kXSxryRNBAz5CIMpksYhB?=
 =?us-ascii?Q?Rj2lhD9UDqlZU/7F+cTknnYrwRiaOAu0mE/jwzWC9bSyATIUkyUHlJPBaR5I?=
 =?us-ascii?Q?UBlgNr9LukK7MbUy+tX5uqyjXWwUwByUBFi9EtYabUUh5AC2X8MD6oPAF/oe?=
 =?us-ascii?Q?yI+eFUFlgZZ3kAqW37ITNw8S9tMISnGtv5tav5RVsRtAX7Aaw859ZlAf2CaX?=
 =?us-ascii?Q?Ny6c446iHQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2b5f08-8091-4735-5c20-08def325ea2c
X-MS-Exchange-CrossTenant-AuthSource: CY1PR12MB9601.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 19:15:30.3901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8ANuNlTz3Igb3Frq/ZdyC2a9BlrU5eINM79VfxOm9aWp8r9dylKam91eT4TyRRx3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on
if the instance supports RIL or not, otherwise it is always the same.

This avoids redundant calculations for each invs entry.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 128 ++++++++++----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  11 ++
 2 files changed, 78 insertions(+), 61 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 057e180bfe15be..55a47a5bdc184f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2482,32 +2482,15 @@ static bool arm_smmu_ttl_addr_aligned(u64 address, unsigned int tg,
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
@@ -2517,8 +2500,9 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	unsigned int scale;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
+	tlbi->range.data1 =
+		FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | (cur_tg << tgsz_lg2);
 
 	/*
 	 * Determine what level the granule is at. For non-leaf, both
@@ -2536,10 +2520,9 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
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
@@ -2563,7 +2546,8 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		/*
 		 * Range too large for a single command, use full invalidation.
 		 */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
 	/* 16K granule TTL=1 is reserved (Section 4.4.1) */
@@ -2575,38 +2559,28 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
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
@@ -2626,16 +2600,32 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
@@ -2654,8 +2644,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	bool used_s12_vmall = false;
@@ -2752,6 +2742,13 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2782,6 +2779,15 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
@@ -2790,10 +2796,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
index fde1819148195a..4f57cd58197b0a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -814,6 +814,17 @@ struct arm_smmu_tlbi {
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

