Received: from PH8PR06CU001.outbound.protection.outlook.com (mail-westus3azon11012019.outbound.protection.outlook.com [40.107.209.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45455325726;
	Sat,  3 Oct 2026 01:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.209.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990745; cv=fail; b=ZTIsn2RVkNW8FhjjaW2bZRgWcLir5xxklIeDWI22wLka3hyBNs3ZdEltlkF/hiYawDsLHNEvBnFgxcgplmPLvhdB8mDFZb/uX9ONgRE+RYRaaKVHU2mkv3FmTXPKBQRDVli2/CuSbWG0JdJnBJAADz22wy0xBjuW+nI8AJcEEqE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990745; c=relaxed/simple;
	bh=nr5SlCv7DMjQY0uxN6FppK7xDq53reB7A2fXtoCdBs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=g4mdg+pZItRVP0v29p4oiP5LpTEU/HCuw0XjCDd/C/ynDUdrLpvHFUrJ8x/l51U0BOz4JpWCM3oes1YnWyWMjbIO+P8uCurPJ/aIVcI+5BcrlsHmCg2F+EjNtIJcJPxAOpXy9N3HTd5ltDzr9HS9xx5hi8G5sUvi3wdfbUJ9U44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CmzoBITP; arc=fail smtp.client-ip=40.107.209.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CmzoBITP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JQJs0TlvZ5aHVN6OHzrmlCYXRDYa3Ix60bdRpTIz4OkPQzkoMNAx8ziZG9bTuG7OUhhVfD6Dnvu96S4g/SIaCLmmfMCG5+9EFoMOfFOjd2c1LhuNCZdcH/SFMBF1CTwmfFcmdHE+WWJaJQrDpcANr9Nv2KdZbhU7ik41JzRtgwFW8PLoFSxH6ThaRo3ZaRRkJlnzGYLLHxexH1vBZrAXSE+mGGiVBtgGrwfCEdcNcsEldAbkOaToLQnevidQyVgKO0N/7G11knWuJ+NSnKr8ZiEDkf42kJN9z1GaPJkFbNWbWJWLtM+f41EjGCUVcO5tjGa5r8bpgURjuCKFBEO8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5glH9DmziBjBYl5fIYQ9mjjg3MikVsgEtKtEeeS8Iuw=;
 b=uM7FJGZ6WVhn4C4NIFuXigP8Fdh/O2lza7hRQ7mGinxvgD1wIGhoMBdCaOS02xMLtIlYQm22B2BUae5vXzoOvObo3f0WKKYDLtevaDrZTuDbJOu9K5E/wqqfGmZh7WCKO7LabfxSWwNZiKds/0gTiG+Gx4rlG/zHQsug786mH7iSrGYJk2AoTyAffzGw7KiVhF5O/GZy13xZYSKtcCuRZK2x0HKG26f0VUX4J/dUdM1sQVW4nz2aj/zN9xAPgUJctIqzcvn7r1S3sucNu/eeD7evM2WpPczAigdL2g1BdXaUD4/CGBiIsCgD9xWDTQ07L8jE+Kkv69Y6ar/CmbZ+og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5glH9DmziBjBYl5fIYQ9mjjg3MikVsgEtKtEeeS8Iuw=;
 b=CmzoBITPTMvzuZDqydEHttt+6sGVzRKYEu3oLW2hAjnAbMX537IBBZNBgMxtB/GBa91EKE6V7EO/uuwsHmUTy8pNuY2GXn2AWhH/MWgQjn5sh8ro6hRyg9joScjXixeOSdH/e8QAl7RoIzzc3lASjrkO5hAcRFmAlgjXXyHB3NuE1aCDa+WSwF4/yBHJZhASERop4aMTwAo21Ii4WemOu0KzMjqTrIxP8f4SXsa+4l22TxlMeDmYae3SyocQWHl3O32lHl0xK/3dUi+/Y35qSOiewOd1DHxw528QyPSPS0QelcPlaNTAX5M5zToWw2IR5VtXwwuLnBaoMlYSZNhtng==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CH3PR12MB7641.namprd12.prod.outlook.com
 (2603:10b6:610:150::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.26; Sat, 3 Oct
 2026 01:23:32 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 01:23:31 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <peaan@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v8 2/9] iommu/arm-smmu-v3: Pass the parameters for the invalidation in a struct
Date: Fri,  2 Oct 2026 22:23:21 -0300
Message-ID: <2-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:254::35) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 98a18f75-2551-45fc-3b6d-08df20ecef74
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|6133799003|11063799006|10067099003|56012099006|22082099003|18002099003|3023799007|921020;
X-Microsoft-Antispam-Message-Info:
	qQBa/oubEdCrCjK55MyG2jdljXYV1ArOdd1HM5OvaO/3jI9LYNCKDzYWb/2Mu/IvfUEnd2e50GrL4Kma4vk0rLIFVB4+tIv3lF9yRlxLrbH8x6ZCVFIto3/Edg3KLbK5i3mFmXZcAiKxh3pRS4+d+qmaEHgg+6cC6uPCKBvH9FAbMlm3iQY3chWei8323m2LLYnMoH8oSp7ZVYXIjjZD4CgueFR8L9mhUk+9efl80Fn0+XUuJCkzfGnnoyAo21OqRBXuB4yViup8R28AfV9OnmtIOQj+XVZTSt+9bj8D+X48NgKSu4z8i0K9zz5FXBBNushjnaKXFeRmllL85KxVzh4WxwdxWZ3DNhVEL54yZmPaIASJMK+YqQ4EQAjEfQiW6DrRot/gyYJSBhe0jfXFxEQjWE4/SCtolYRQXiWA+bsLloCPJbtSoaqnwZCBLWyUl5KbRjEYKROPZw4vavvm8DVwzcUWbL0hnyoODBnaF/hq7rsLja5kYlq4UmSjDxe5OxpJtq7i//WRqq4MiSWo7X+AEB29UxdItmUYylzkDH3wmy+cYZe/AVcdcMx/ddaakHg0lH22xuNM97bUesGEtFgF//1hitS/ch7DY0eFHkCTM7QDq5xY19qb/hK0PXo+CrKVo99SEhU05e7H8A3c6IX3UCxdm99IbKtjoMo93xgsyZA/MCcY+fd7JQOeuqhY7yHVOGT8w+iXwoPXbJe5ew==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(6133799003)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uFudxhTv82+DIXzoH+wv5gNMB338MG11nLlr59db1MwojQjwQkNdB/QEtrUY?=
 =?us-ascii?Q?sXS+HYyFmhHSQJBZiBxhWmOOaqGyimBBIb0VN0DXBl/lRp3KEQs5YFV8pdmD?=
 =?us-ascii?Q?3dATfNBEKe12hOL+3Fg0FbZFsB0mnv3ujMBHqKWrHxPMFGThcBT9Jo6OftSG?=
 =?us-ascii?Q?QFsyVw0IsLK7/TR4NBtto6FTAJ/GvA6rvA2EEInCbyt7DcHtOtwq33QjyJWC?=
 =?us-ascii?Q?7/fV9iE6Xb5oa4fUJJdnJW36Gqui2PDKNwmCkB40rYPKIJCMUJEUJqo6kO0G?=
 =?us-ascii?Q?/duw2zxBB1ptmTx9CSh55Q/DXxgN18I/MpLhmeiaZErJ0d33P5JrIkNIHNlQ?=
 =?us-ascii?Q?vuidvT2CAbEAswX5zOX4LoL/aEwxff579iE8jUZ97WQ0lwrj+HgVTxK4vvwG?=
 =?us-ascii?Q?q/tGI+fbE3EjwbZ8JeaVMkHSZeqmrMnx18pDyxA4zPliKbgkIWAiMZRdpy+g?=
 =?us-ascii?Q?sNHXphu/aOqjoscwV7ewYXIKYTkztGGcuW33MIhPTc4Ty+xHxcsGCkN3W5RN?=
 =?us-ascii?Q?HILizNSAoKKDFVy1rx1kpG/Qhujn3MKP8QjUbaUqdT1b2UMF/l/xUIhdjo4A?=
 =?us-ascii?Q?YPK/TC3hsxEpv9acagRWdIdNbcHi+4w2KCd3rfy/MebuB5hB0QZLB+K53QNz?=
 =?us-ascii?Q?o/awI2b7nZEl2kFWVPR++mZDfTg/p2TNXZhaGVdi6g0IXGVlvsnzZbK5LPUO?=
 =?us-ascii?Q?kySaexnGtqOrzjEUtXduFrDVI8e6qyj5XRqw5uPwwr670rrkTk6ZVtENdZW9?=
 =?us-ascii?Q?DnHarkaAJPkEYMEapUhYJA3C7spc6Ltz3i1WCLkNwD76wW7E2Y7DfiitTc+Q?=
 =?us-ascii?Q?mq2dLEbY7kwjBwHIG5HPszDFDynKzD4yCqmYSMzlridiWivC3x3uTbY83WFq?=
 =?us-ascii?Q?vV2gePnPMHRvWhMzYKT+NpoewaYG8HbZBWrTRP7hpvmHQHg7+2j28jotJQlD?=
 =?us-ascii?Q?5ESQxPnE2RWpVGOvXTRvPsc/zLwO21PlQDePW+g2YCN04PqaPUiCT60vfErA?=
 =?us-ascii?Q?5rQfH5JjIBEjGcctNYr0TlaS74gycSG1vO3Uj8BltyWl3sPw0G2z+NsEtLBA?=
 =?us-ascii?Q?xKA9MoE6OdYDkoDq7/rT5xG5TJrU5Kh8RW55Fs0bB8U9eqCXbRVYh1OH5OC5?=
 =?us-ascii?Q?UXspV132fy9F9JHLUBYn+mtTE5XrkclVG+361vK1TaWgaiUA+AgdO7H6Tw+D?=
 =?us-ascii?Q?K9K2ucyxB6rKvXN7Dbt+74rgKYq050G1LATD6vaYAMmdR2UA902HXDUcVXti?=
 =?us-ascii?Q?3w57yYCpFkc2AvOnDM/wTr9Tq3rNTPRvbXbnMeMbQ3RX1Ucyr0p1I0Jl5Frx?=
 =?us-ascii?Q?rL2i6QOP7v4U1iFmAgwwHJpALncUHKhgL9nHCwNQgJNOUaACspdK6VI5mcSf?=
 =?us-ascii?Q?Cz3eS8vSh9fttfDWpJVAbxVSUYigwHZdaK2E0Willu+R2UCOgqr5pAckjPGf?=
 =?us-ascii?Q?Vpqz1rcjVWl5fs18G2CzKtBvxRfH2jC3+A5z9aLDvKgQsrA9C2g0oJRnuvv9?=
 =?us-ascii?Q?UP/kVtym9XTdOgs7JX1ww6yIKPkTJwbSEOl7dnl1DWFyMWoGW4o/KVjRIRxD?=
 =?us-ascii?Q?v/cXZSHtpq0TiS6Rm4g3ooyQ3xDtZ90lkTkuQl07Os7j2qlwzFBfyneqCUaX?=
 =?us-ascii?Q?10EW4Sx54i2LDmMgN3yxrLgKfqscIGY3QNUpPBNPXupG/xIKCMK99AUhK0pt?=
 =?us-ascii?Q?XC/LYml7x8mRjS/qfUgOsbwXtW7Nd/ABBgNnglTJR7V/ruHI?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98a18f75-2551-45fc-3b6d-08df20ecef74
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.4166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zJYDueEQbSSRF1A9GmPNLGslGdJ0la7KAJ9DjAeA5z5on83HyfFnPrelNX9U0/43
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

From: Jason Gunthorpe <jgg@ziepe.ca>

These parameters go to a lot of different functions and the next patches
will add more. Put them into a struct to keep things tidy.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 90 ++++++++++-----------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  9 +++
 2 files changed, 53 insertions(+), 46 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 502745984a5364..bcdeb9a47df7bd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2385,8 +2385,8 @@ static irqreturn_t arm_smmu_combined_irq_handler(int irq, void *dev)
 	return IRQ_WAKE_THREAD;
 }
 
-static struct arm_smmu_cmd
-arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
+static struct arm_smmu_cmd arm_smmu_atc_inv_to_cmd(u32 sid, int ssid,
+						   struct arm_smmu_tlbi *tlbi)
 {
 	size_t log2_span;
 	size_t span_mask;
@@ -2408,8 +2408,8 @@ arm_smmu_atc_inv_to_cmd(u32 sid, int ssid, unsigned long iova, size_t size)
 	 * This has the unpleasant side-effect of invalidating all PASID-tagged
 	 * ATC entries within the address range.
 	 */
-	page_start	= iova >> inval_grain_shift;
-	page_end	= (iova + size - 1) >> inval_grain_shift;
+	page_start = tlbi->iova >> inval_grain_shift;
+	page_end = (tlbi->iova + tlbi->size - 1) >> inval_grain_shift;
 
 	/*
 	 * In an ATS Invalidate Request, the address must be aligned on the
@@ -2484,20 +2484,23 @@ static void arm_smmu_tlb_inv_context(void *cookie)
 
 static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd, bool leaf,
-					  unsigned long iova, size_t size,
-					  size_t granule, size_t pgsize)
+					  struct arm_smmu_cmd *cmd,
+					  struct arm_smmu_tlbi *tlbi,
+					  size_t pgsize)
 {
-	unsigned long end = iova + size, num_pages = 0, tg = pgsize;
+	size_t inv_range = tlbi->iopte_size;
+	unsigned long iova = tlbi->iova;
+	unsigned long end = iova + tlbi->size;
+	unsigned long num_pages = 0;
+	unsigned int tg = pgsize;
 	u64 orig_data0 = cmd->data[0];
-	size_t inv_range = granule;
 	u8 ttl = 0, tg_enc = 0;
 
-	if (WARN_ON_ONCE(!size))
+	if (WARN_ON_ONCE(!tlbi->size))
 		return;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		num_pages = size >> tg;
+		num_pages = tlbi->size >> tg;
 
 		/* Convert page size of 12,14,16 (log2) to 1,2,3 */
 		tg_enc = (tg - 10) / 2;
@@ -2510,8 +2513,8 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * want to use a range command, so avoid the SVA corner case
 		 * where both scale and num could be 0 as well.
 		 */
-		if (leaf)
-			ttl = 4 - ((ilog2(granule) - 3) / (tg - 3));
+		if (tlbi->leaf_only)
+			ttl = 4 - ((ilog2(tlbi->iopte_size) - 3) / (tg - 3));
 		else if ((num_pages & CMDQ_TLBI_RANGE_NUM_MAX) == 1)
 			num_pages++;
 	}
@@ -2550,7 +2553,7 @@ static void arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		 * command and something would be very broken if iova had them
 		 * set.
 		 */
-		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
 			       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
 			       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) |
 			       (iova & ~GENMASK_U64(11, 0));
@@ -2591,13 +2594,13 @@ static bool arm_smmu_cmdq_batch_add_range_inv(struct arm_smmu_device *smmu,
 	return true;
 }
 
-static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
-				      size_t granule)
+static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu,
+				      struct arm_smmu_tlbi *tlbi)
 {
 	size_t max_tlbi_ops;
 
 	/* 0 size means invalidate all */
-	if (!size || size == SIZE_MAX)
+	if (!tlbi->size || tlbi->size == SIZE_MAX)
 		return true;
 
 	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
@@ -2610,32 +2613,31 @@ static bool arm_smmu_inv_size_too_big(struct arm_smmu_device *smmu, size_t size,
 	 * invalidation feature, where there can be too many per-granule TLBIs,
 	 * resulting in a soft lockup.
 	 */
-	max_tlbi_ops = 1 << (ilog2(granule) - 3);
-	return size >= max_tlbi_ops * granule;
+	max_tlbi_ops = 1 << (ilog2(tlbi->iopte_size) - 3);
+	return tlbi->size >= max_tlbi_ops * tlbi->iopte_size;
 }
 
 /* Used by non INV_TYPE_ATS* invalidations */
 static void arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
 				       struct arm_smmu_cmdq_batch *cmds,
 				       struct arm_smmu_cmd *cmd,
-				       bool single_range_inv, bool leaf,
-				       unsigned long iova, size_t size,
-				       unsigned int granule)
+				       struct arm_smmu_tlbi *tlbi)
 {
 	struct arm_smmu_cmd nsize_cmd;
 
-	if (arm_smmu_inv_size_too_big(inv->smmu, size, granule))
+	if (arm_smmu_inv_size_too_big(inv->smmu, tlbi))
 		goto full_inv;
 
-	if (single_range_inv && size > granule) {
+	if (tlbi->has_cont && tlbi->size > tlbi->iopte_size &&
+	    (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
 		if (!arm_smmu_cmdq_batch_add_range_inv(inv->smmu, cmds, cmd,
-						       iova, size, inv->pgsize))
+						       tlbi->iova, tlbi->size,
+						       inv->pgsize))
 			goto full_inv;
 		return;
 	}
 
-	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, leaf, iova, size,
-				      granule, inv->pgsize);
+	arm_smmu_cmdq_batch_add_range(inv->smmu, cmds, cmd, tlbi, inv->pgsize);
 	return;
 
 full_inv:
@@ -2660,10 +2662,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
-					unsigned long iova, size_t size,
-					unsigned int granule,
-					bool single_range_inv, bool leaf)
+static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
+					struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_cmdq_batch cmds = {};
 	struct arm_smmu_inv *cur;
@@ -2693,20 +2693,16 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 		case INV_TYPE_S1_ASID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     cur->id, 0);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd,
-						   single_range_inv, leaf, iova,
-						   size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID:
 			cmd = arm_smmu_make_cmd_tlbi(cur->size_opcode,
 						     0, cur->id);
-			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd,
-						   single_range_inv, leaf, iova,
-						   size, granule);
+			arm_smmu_inv_to_cmdq_batch(cur, &cmds, &cmd, tlbi);
 			break;
 		case INV_TYPE_S2_VMID_S1_CLEAR:
 			/* CMDQ_OP_TLBI_S12_VMALL already flushed S1 entries */
-			if (arm_smmu_inv_size_too_big(cur->smmu, size, granule))
+			if (arm_smmu_inv_size_too_big(cur->smmu, tlbi))
 				break;
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
@@ -2717,7 +2713,7 @@ static void __arm_smmu_domain_inv_range(struct arm_smmu_invs *invs,
 			arm_smmu_cmdq_batch_add_cmd(
 				smmu, &cmds,
 				arm_smmu_atc_inv_to_cmd(cur->id, cur->ssid,
-							iova, size));
+							tlbi));
 			break;
 		case INV_TYPE_ATS_FULL:
 			arm_smmu_cmdq_batch_add_cmd(
@@ -2748,10 +2744,14 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 			       unsigned long iova, size_t size,
 			       unsigned int granule, bool leaf)
 {
+	struct arm_smmu_tlbi tlbi = {
+		.iova = iova,
+		.size = size,
+		.iopte_size = granule,
+		.has_cont = smmu_domain->stage == ARM_SMMU_DOMAIN_SVA,
+		.leaf_only = leaf,
+	};
 	struct arm_smmu_invs *invs;
-	bool single_range_inv =
-		smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-		(smmu_domain->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV);
 
 	/*
 	 * An invalidation request must follow some IOPTE change and then load
@@ -2791,12 +2791,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		unsigned long flags;
 
 		read_lock_irqsave(&invs->rwlock, flags);
-		__arm_smmu_domain_inv_range(invs, iova, size, granule,
-					    single_range_inv, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 		read_unlock_irqrestore(&invs->rwlock, flags);
 	} else {
-		__arm_smmu_domain_inv_range(invs, iova, size, granule,
-					    single_range_inv, leaf);
+		__arm_smmu_domain_inv_range(&tlbi, invs);
 	}
 
 	rcu_read_unlock();
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 0a1bb75467dbda..f0839cc767dd68 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -810,6 +810,15 @@ static inline struct arm_smmu_invs *arm_smmu_invs_alloc(size_t num_invs)
 	return new_invs;
 }
 
+struct arm_smmu_tlbi {
+	unsigned long iova;
+	size_t size;
+	/* page or block size of the leaf iopte */
+	unsigned int iopte_size;
+	bool has_cont;
+	bool leaf_only;
+};
+
 struct arm_smmu_evtq {
 	struct arm_smmu_queue		q;
 	struct iopf_queue		*iopf;
-- 
2.43.0

