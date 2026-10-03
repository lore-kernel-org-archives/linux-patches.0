Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD55325726;
	Sat,  3 Oct 2026 01:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990671; cv=fail; b=av30K6NeaFc/FuxIxqlXKrouFGJhyL7+K5S8pQxGMQKcyL+agNgvH6VN6uwCz9UWVJ4dzEdeKcdhMw897VEqWRQm+09ZySW0FloDVgUZVeN7C2WXlPVdXeeiB0u9ivi8hcNmyy+uScpSnfPw9F3ttbm7GbamId+JbzBPzWxJHZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990671; c=relaxed/simple;
	bh=z1ijBKQaQQxDtWcOVf15nOBP2CzNkgQXDH/VOAj9dkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eTX4yIt4oFNfdAqtXYKQby6KJ14MNKRO5e+/hszKz31kyWgBiHM5J4IK8enIe0yP7puV+EefVavC3YGO94xcq9buQCqOkIzpHDcvF3ZePTVVEjutrdumTpUTXc/hhcZ3QMwOyFSU/pBO/GPuHVJflDvCh7wvhg/MJ4l1v4rvU6Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C5hlpHUE; arc=fail smtp.client-ip=40.107.208.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C5hlpHUE"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A4JRIkApZCYSv6NRoGesVTV40QEJCcE3oTXJNEDIBkQ0YK/GUDqSFKodmc7s/TxnGE+W7lbJ1jQHtgEcVwAPW1YHwk26wbDVK/ePS9Gp4uWN44+jWsEkT7EwTvQN2TPHNstMJexOxh15f8ieonKkoJbjdFWeFM7C2toOB0I9GZFKrsb/fraEoFO7nvLwgWh+40pm1nXV36RQHluOuZc32ryqRnPtXYp5E0Ysrpl9ZseKDpec5WIAHgn+HMAWwXX35Yiony8pO6coVB5ctxNZeQSZ0FVLDNHMQP5yRJ3y12As/WS53kEAGD2Iev8WqgSqLG/FGqqDBKtCm66J9pHauQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=le1RqcvrtV871poBn1WOiwlKpiuMw1bMt2neYQkWhPA=;
 b=Z1sy4+cBHLlhzkPox+WeIu/Jf5gCYJ0Vg4iqrsKG5vnQT1c5E/lq+dGl14o4PxFXjFnbCtc5NL8oO88I854bXtyruDUzW9NXTC/byxm7xH+hXEqaSBWbNliIdILvPZADBWJ/M/ulIgw7J8gac+pREqcd0X/sfDCl54HYqLUv0y4sDCkp6HatVKUSDGryVIJRHhgCN/3/nWz/Mo7DmXvVmHid4z9HeYZBkKjYZFMuO81MqXE13WaLe6ga4NAdhV1gSy+Mihs3OquJqiMJt6NY1GGyZrhKHXUBOttL6shTUqk0yg82qPq1JVkkhziQFVHFPq9f71yqo3IUmJuq3lLeWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=le1RqcvrtV871poBn1WOiwlKpiuMw1bMt2neYQkWhPA=;
 b=C5hlpHUEPwvHAqcMrYFW5eDcYwqQ9t6Ix+bc4cBHVk0CfKZIKndzV8pFYYHCoL5KU4uEI4gtZQFpdVYUigX+hfiLPYR8v2FSGZCKAanwuqUMLZewQS5g4RovrL363rSCw5nNFqU38XGwxHDE8D2dsPQoJ4ZmC7KLCcxnfBzuB9sMwsTUlmuaZAD4nLd6/wUUBylsg/mM38jwZN6DrTDUiR9K7dMvGLjtteH7MHG5/LpckVOq8e3KHAbVztw3nkBTp/0FSOEwbxfZXmTSoPOleesLxAh8yCdWKOZOIppo6ZiHca3xMkacPaBeaSdsBqBt5NyoZ4Fu/v/dmL2kuwjkrQ==
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
 01:23:32 +0000
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
Subject: [PATCH v8 6/9] iommu/arm-smmu-v3: Precompute the invalidation commands
Date: Fri,  2 Oct 2026 22:23:25 -0300
Message-ID: <6-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0006.namprd05.prod.outlook.com
 (2603:10b6:a03:254::11) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 739a8cbb-1031-458d-f4da-08df20ecef96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|11063799006|10067099003|56012099006|22082099003|18002099003|3023799007|921020;
X-Microsoft-Antispam-Message-Info:
	1HiL09sPmLnbBaQEz0mH42QTUpGwL4DjbyLY/nEzCGP2g7qmo0/O0kXlsPOvDRyifWesIAQeJJ4Zad3iJMRFJ7wplvEkT/7LNSbgALsGy5KnHC6+2Sk7YhrnNBMiLOEEvaSf/yXheaJOaIjCqyrCUOX44+oOinnQj5p7/AeMMSgKU/X6EiMoriiod7Znc03QnyYd4vWU8MH8NULJipwxtZlCQT7dMi58Yiap8CPuBR4xwsC8ag5n/KO/7cxD8QxeALHcb+COOVp1V4VoCc4PWzc0+l079VTEnTsyzZPmVNIMxwOZwaYzSZNiNkfOTegq73kMm8G2Rg29Wmz1ZLeEz8IGW6aw53ZTWoBn98Q2qUv1HVwazMHUhmGKHmt9xaM9C6w9tpuwKDmoAZ+q5RAqFFqWkH2emp+ccS2u9EL1bhQQkAp0vffWZnPC/koz7ogR0WfvdgmX2UWvpraDxoe1AdwZ+Y7KsWFQ6pfR6OW4dcfvNyA6tGLatzFsv65e/aEIL48kFUKA67X/Thi+3ljn7kHy/pLSL6hod/qkL53+3YquKisAOND6IrH1SBLh2DMkdJ9vTWpZrEBMLBFVUYkxkOg26cFARoS8dfGhy8ddH9cSySgDfVnFaUA467BgaWU3ZS/kX1Sc+G+9dq/vrrkQgdcfldpdwRLpRfQ5jlqo3swiW08sQxNAWty3pb0ZSXALzRkmH+0xIIKooD3gjaB6ew==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?I3fxoaVV7xAoyBIsArpiYjM7ZkTenU/s7YVWtaV6b3TSt/nkU3CMESaA6MLA?=
 =?us-ascii?Q?4qKyDzAboZe0X2NTopmXgGyOM65zz1xa2N5PO/1u90ke1ORZNzmpWG490oLv?=
 =?us-ascii?Q?cd4phlqCEg+pi/a3MQLOv6kQ1Cj9+NIXtr5SfVEt1E7WyAq494Jml3dMCFzP?=
 =?us-ascii?Q?mg67pNgFO9P6Z2D5oBg0NV1qHXSBb17PyrQP0uv9M+9g/Dyca1DYr5WufvQ+?=
 =?us-ascii?Q?nz7XRXHMrZCROb9+tMyvmiNAUH/8yjdnuQMJffPIY8rlzzA1Ya5Xi6XQlAmp?=
 =?us-ascii?Q?i3nVFgAc0XThxdH6lZpuSA8078ctQiQia9VaFhDt3wfldD24iiIm9UQ9V+do?=
 =?us-ascii?Q?+bTaAVjktzQ4WK4S43LQa2RJ7BZ9fDIkb0eY2loUqQD+EObSkShHRJAliH9Q?=
 =?us-ascii?Q?rqEyPY6fVgonGea8622xldSQiRO9lcLfiwAtRAvIf+IIJjPajw/UPPir5VIB?=
 =?us-ascii?Q?5hNGCQHR5w+b+sike76E3EdqhoW3HsHqQTPEZ8cnEmA4PWI9CwReGPJX6hK8?=
 =?us-ascii?Q?e/txlGJxjB6Us4t5ck8IcUd6XUrYZhJ3R2GZr1p2V6ZsSijXTbwFT6Z8IkQG?=
 =?us-ascii?Q?rSTgj23JZg1j/0nAyBSaoSESjGoF7whqos3uFHpbhTe2wMfE0lO550WMECrN?=
 =?us-ascii?Q?v8hsW7qEZekBqSjAW5UPrWpbawUJ2A5uT7zhH2YxIjt5sDkY4MJu17oShUIC?=
 =?us-ascii?Q?kzUlQudSEiet9IS1vUTi//RZ++QsPbGk2LyNVuJys8va9WqI+6CZ7fByyP/l?=
 =?us-ascii?Q?hQ5q5nrPa62xgXLs+Tg8VlXVQdOcLoGrml1XwrRa8/wfBLp+FqztfQP3j54J?=
 =?us-ascii?Q?QQ/f07eRWimTnNo2RRoWuZMd/qh5TlG3Z3KUpybS+M+q0hPwC2NtW3UQCjYn?=
 =?us-ascii?Q?1f/nza2Ro4gQzztMjK4JZI9mh60oG3gI5bkFIYgHmGVvw+gzGs5i0ocZp05u?=
 =?us-ascii?Q?j+t5Og/7UCb9/3/9SYbPkahokXkNKVX0UsuI6OTQLm3icNW12Vgc2Hf/j/+/?=
 =?us-ascii?Q?yZODCMLlwO18kue5ZJtaEtigsxPwgFlB03zmnvuFmJPC7bHLsEAKf/AWjYaD?=
 =?us-ascii?Q?iwN+vbCG39Ip8DqCC+6+HQxCAyid60X2CnUXyvpbDnhFjYZ4ECY8ZyHwclWP?=
 =?us-ascii?Q?hUrD11+pDLlkB169fyKhvO7SkvSVnTs9QhgRHl+BNGDxcJaJsFB3NcOVzQNM?=
 =?us-ascii?Q?yMFBOvv+aykTAdpBjq8gYGHR2DKgDrYNr4maqvAllB+r/rbWFIcAofXFt4bz?=
 =?us-ascii?Q?Zrt5XI1LcBTwJ7bdGr6ilMAXkCrhRDkFVUJH5U+EG7nNJ60Umz2gssiGpTla?=
 =?us-ascii?Q?RQIidMiSgq2SF1VeF6ausa4pOgexVhcaBrvxb8igONcyNo1ZF1aT/fGvIULq?=
 =?us-ascii?Q?bnGtzb84+3b2qcYqljGn2bHK0b7EkaPM/DmTmHK9uSSQjM7CWzvQtHKymrVj?=
 =?us-ascii?Q?r++NA1UNk1V1pVhz4ADKx8pC5St8Z53z0Jm6CJ1rzjsQCbDzS3ZpFmTwuwrl?=
 =?us-ascii?Q?xTFdHVp7lFaWjuAPSLfZuSYyIGri/tgxeecnvg2JTV2hZoo+V1oreaHozA/J?=
 =?us-ascii?Q?iFN5qyEkhfLobMiOBMFMQM9hOFxOGrr4fK7erOjZIPJWoOr71adspUTjkt4Q?=
 =?us-ascii?Q?1jlB0D1Fypa0DnO+7JHjQtpMQ2C5Iq6TW8Lwoa+DCrYh3ykGJmyxNkm9ER/F?=
 =?us-ascii?Q?oLPvJrAoximQqjsyVyYO3BvJlcW0O1Cv+4mV4Jrm702I+QOs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 739a8cbb-1031-458d-f4da-08df20ecef96
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.6189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHNHU6rashVQJreOFsaSJPc+TouEVnSSTNLoU3MstOuhZzSGBMoZGlGyYsNzYwes
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

Store the required cmd data in the tlbi and just copy it out when
processing each item in the invs list. The cmd form only depends on if the
instance supports range invalidation or not, otherwise it is always the
same.

This avoids redundant calculations for each invs entry.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 147 +++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  12 +-
 2 files changed, 94 insertions(+), 65 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7a5f4b54f3066f..26490d11767266 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2540,12 +2540,12 @@ static struct arm_smmu_range_inv arm_smmu_range_inv_init_end(u64 last_tg,
 	return range_inv;
 }
 
-static void arm_smmu_cmdq_batch_add_range_inv(
-	struct arm_smmu_device *smmu, struct arm_smmu_cmdq_batch *cmds,
-	struct arm_smmu_cmd *ref_cmd, bool leaf_only,
-	const struct arm_smmu_range_inv *range_inv, u8 ttl, u8 tg_enc)
+static void
+arm_smmu_tlbi_add_range_cmd(struct arm_smmu_tlbi *tlbi,
+			    const struct arm_smmu_range_inv *range_inv, u8 ttl,
+			    u8 tg_enc)
 {
-	struct arm_smmu_cmd cmd;
+	struct arm_smmu_cmd *cmd = &tlbi->range.cmds[tlbi->range.num_cmds++];
 	unsigned int tgsz_lg2 = tg_enc * 2 + 10;
 	u64 iova = range_inv->start_tg << tgsz_lg2;
 	unsigned int num = range_inv->num - 1;
@@ -2574,19 +2574,16 @@ static void arm_smmu_cmdq_batch_add_range_inv(
 	if (!num && !range_inv->scale && !ttl)
 		tg_enc = 0;
 
-	cmd.data[0] = ref_cmd->data[0] | FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
-		      FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
-	cmd.data[1] = ref_cmd->data[1] |
-		      FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf_only) |
-		      FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
-		      FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
-	arm_smmu_cmdq_batch_add_cmd_p(smmu, cmds, &cmd);
+	cmd->data[0] = FIELD_PREP(CMDQ_TLBI_0_NUM, num) |
+		       FIELD_PREP(CMDQ_TLBI_0_SCALE, range_inv->scale);
+	cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, tlbi->leaf_only) |
+		       FIELD_PREP(CMDQ_TLBI_1_TTL, ttl) |
+		       FIELD_PREP(CMDQ_TLBI_1_TG, tg_enc) | iova;
 }
 
 /*
- * Issue up to two range TLBI commands covering [iova, iova+size). Returns true
- * if successful, false if the range is too large to fit into range invalidation
- * commands.
+ * Generate up to two range TLBI command payloads covering [iova, iova+size).
+ * Sets use_full_inv if the range is too large to represent.
  *
  * Normally the first range invalidation is the largest representable span which
  * does not exceed the requested range. If necessary, the second range
@@ -2594,15 +2591,12 @@ static void arm_smmu_cmdq_batch_add_range_inv(
  * is anchored at the end. Any excess coverage from the second range
  * invalidation overlaps the first instead of exceeding the requested range.
  *
- * If a SVA is being invalidated and the SMMU has the
- * ARM_SMMU_OPT_FULL_CONT_RANGE_INV errata this produces only a single range
- * invalidation and overinvalidates to ensure any potential CONT is covered with
- * a single range invalidation.
+ * For SVA on an invs containing an SMMU with ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
+ * produce only a single range invalidation and overinvalidate so any potential CONT is
+ * covered by one command.
  */
-static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
-					  struct arm_smmu_cmdq_batch *cmds,
-					  struct arm_smmu_cmd *cmd,
-					  struct arm_smmu_tlbi *tlbi)
+static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
+				     bool single_range_inv)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	struct arm_smmu_range_inv first = { .start_tg = tlbi->iova >>
@@ -2613,9 +2607,6 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	struct arm_smmu_range_inv trail;
 	u8 ttl = 0;
 
-	if (!tlbi->size)
-		return false;
-
 	/*
 	 * Determine what level the granule is at. For non-leaf, both io-pgtable
 	 * and SVA pass a nominal last-level granule because they don't know
@@ -2636,11 +2627,11 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
 	if (first.scale > 31) {
 		/* Range too large for a single command do full invalidation */
-		return false;
+		tlbi->range.use_full_inv = true;
+		return;
 	}
 
-	if (tlbi->has_cont &&
-	    (smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)) {
+	if (single_range_inv) {
 		/*
 		 * Produce a single invalidation by rounding up and disabling
 		 * the trailer.
@@ -2656,40 +2647,27 @@ static bool arm_smmu_cmdq_batch_add_range(struct arm_smmu_device *smmu,
 		trail = arm_smmu_range_inv_init_end(
 			last_tg, num_tg - ((u64)first.num << first.scale));
 	}
-	arm_smmu_cmdq_batch_add_range_inv(smmu, cmds, cmd, tlbi->leaf_only,
-					  &first, ttl, tg_enc);
+	arm_smmu_tlbi_add_range_cmd(tlbi, &first, ttl, tg_enc);
 
 	if (trail.num)
-		arm_smmu_cmdq_batch_add_range_inv(
-			smmu, cmds, cmd, tlbi->leaf_only, &trail, ttl, tg_enc);
-	return true;
+		arm_smmu_tlbi_add_range_cmd(tlbi, &trail, ttl, tg_enc);
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
@@ -2709,16 +2687,37 @@ static bool arm_smmu_inv_to_cmdq_batch(struct arm_smmu_inv *inv,
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
+		for (i = 0; i < tlbi->range.num_cmds; i++) {
+			struct arm_smmu_cmd range_cmd = tlbi->range.cmds[i];
+
+			range_cmd.data[0] |= cmd->data[0];
+			range_cmd.data[1] |= cmd->data[1];
+			arm_smmu_cmdq_batch_add_cmd_p(inv->smmu, cmds,
+						      &range_cmd);
+		}
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
@@ -2737,8 +2736,8 @@ static inline bool arm_smmu_invs_end_batch(struct arm_smmu_inv *cur,
 	return false;
 }
 
-static void __arm_smmu_domain_inv_range(struct arm_smmu_tlbi *tlbi,
-					struct arm_smmu_invs *invs)
+static void arm_smmu_domain_tlbi_inv(struct arm_smmu_tlbi *tlbi,
+				     struct arm_smmu_invs *invs)
 {
 	struct arm_smmu_inv *used_s12_vmall = NULL;
 	struct arm_smmu_cmdq_batch cmds = {};
@@ -2833,11 +2832,17 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 		.iova = iova,
 		.size = size,
 		.iopte_size = granule,
-		.has_cont = smmu_domain->stage == ARM_SMMU_DOMAIN_SVA,
 		.leaf_only = leaf,
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
@@ -2868,6 +2873,20 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
 	rcu_read_lock();
 	invs = rcu_dereference(smmu_domain->invs);
 
+	/*
+	 * Only precompute range invalidation commands when they will be used.
+	 * The invs generation ensures this matches the instances being
+	 * invalidated.
+	 */
+	if (invs->has_range_inv) {
+		if (!tlbi.range.use_full_inv) {
+			arm_smmu_tlbi_calc_range(
+				&tlbi,
+				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
+					invs->has_full_cont_range_inv);
+		}
+	}
+
 	/*
 	 * Avoid locking unless ATS is being used. No ATC invalidation can be
 	 * going on after a domain is detached.
@@ -2876,10 +2895,10 @@ void arm_smmu_domain_inv_range(struct arm_smmu_domain *smmu_domain,
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
index 8b71e6cc19f29d..bc520698863e57 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -834,8 +834,18 @@ struct arm_smmu_tlbi {
 	unsigned int iopte_size;
 	/* Base Translation Granule of the page table */
 	u8 tgsz_lg2;
-	bool has_cont;
 	bool leaf_only;
+
+	struct {
+		bool use_full_inv;
+		u16 num;
+	} single;
+
+	struct {
+		bool use_full_inv;
+		u8 num_cmds;
+		struct arm_smmu_cmd cmds[2];
+	} range;
 };
 
 struct arm_smmu_evtq {
-- 
2.43.0

