Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013045.outbound.protection.outlook.com [40.107.201.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B945C30EF8F;
	Thu, 17 Sep 2026 00:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.201.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789604887; cv=fail; b=R72nhIHD1S+1eKajCJ4uQISl2j0PGgpSx4fhVLWLL9YttFAA1A2U5LuxsDsx/TqlTC9BPX1qtzQuuZJ/7Mnp/fVBaQ2IdJV7B6UJ7Vv8+S3+esO0yIWdweVMTP0c1mo7FIGoCGqgMDBDj+rfvf6taa01BnexjIdyefCGOvBwtXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789604887; c=relaxed/simple;
	bh=STCJrnvVelzu6P5dAOo3mNpV4Qh/WQUH8DgPtoed1Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=HsuaQue0BpBg7Cm/i+ifh7zI4bWgDW1pC6xWtC2sDzNfVN/crJTmPIQzHy0PoOPBFLu0TCNEVdnUJKmL2NPDc4aFpzOF+VbjMqUpRDNYc30zueLZIZwoTC0+IKzdUgRERGV5qvAzv944uzCl/ceijjCbbInXd+K7fNDNvsa8Io4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c6CcNJxU; arc=fail smtp.client-ip=40.107.201.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c6CcNJxU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kukzw1y1mEbylweovnjFq4S9+YImfabXh4qItqG+4Nrm/6fkNhV+EGZH6CeR4nsjO698Wupgt8co7tzn7xtTh2gR7qhRvFCKiR/5B8WkJD4sFmMgwNyHiiFZOkB/AgREtO6PRxKug5GqKuuR9VgNjGO6Ib49ZSWCni7EsluEU9YJ6Kg9OjrFjFVLWDBaTu7O8sNqVdyUUw2ioUTvkPB3eKiEql+e4yjguEorqsCCpv+qDoK32pl7paCesufGX3JZP873Voztl5bTI1LlVrLCyUVQmxPCSPo8m3fTwxtP6WnMdH23S/1n41FPvurt+uKfecAGZ0NTPBTy/gv/Tc3i1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gzej5rd2laNn+OLTur3VJxYPi4V9fiLZz5GxZYBp+M8=;
 b=HGCeLqnsLG8MnlLLksV2RFwDdCgyqYFzsTJ8B1y26XXGiTLPmvUIIY/Z3JX81y6rJDqn9NdGLgRzcrcumxykevtVbw+3/VHAeEXrRcv87j5hPUgvgc0oMj6bS+C0PdXdeJwItd0G8CAUVtb5MWWPevbPMXitsC3BWhEAakwPnURQQN6IkQc+DiJa+I2fgH6PRtV8ucOCO4bMxPU9IfHB92ycnwxWrrkVc8JK1Gr6TAEb29jiWVGRJ4YppKLt0sgThNj3/nTw10tTCotTgu2WdU95qMZpfgJRMWlBPugm5/qiqRfX2pO3pPHFU21P+Q/91/uEtCrMxb67//7xgZ56uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gzej5rd2laNn+OLTur3VJxYPi4V9fiLZz5GxZYBp+M8=;
 b=c6CcNJxUeOvtJ06Ch1o8XYag9Scs2YwDkxSjdO4y7WEip5hjXXGhbjJQmBsOr4W9pod6+bc0Fdh4WBYWJqLz6BFRU2xjYjG6h8qx+xeRe9KJZwfL6u2te9XwMmKspmwTaOgnVSEPdYv3m95sxpod665rBxnZcARRvjqbKbuN6A4ObjzxP6QIteptc67ffrnBIsYdrqWQlBoOsxd0hxfQehawFECB1y2zMSCzfJchUHR2cJvL6+BEt5qq93iVbARVcREQjV8YG2TrdKKORCKI+BXR5Yoxn5Bwwdvk4Qb0Usgwz8gnzXTPBQAvMA7WgKlAN0O6BMji9dTzHVUZnaaJrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6160.namprd12.prod.outlook.com
 (2603:10b6:8:a7::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.9; Thu, 17 Sep
 2026 00:27:54 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0428.011; Thu, 17 Sep 2026
 00:27:54 +0000
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
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: [PATCH v6 9/9] iommu/arm-smmu-v3: Support the DS expansion of RIL's SCALE
Date: Wed, 16 Sep 2026 21:27:50 -0300
Message-ID: <9-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v6-9cd17417d355+281836-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR14CA0002.namprd14.prod.outlook.com
 (2603:10b6:208:23e::7) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6160:EE_
X-MS-Office365-Filtering-Correlation-Id: b1368b55-8039-4d8e-64f3-08df145282bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|23010399003|366016|1800799024|921020|5023799004|11063799006|10067099003|18002099003|56012099006|22082099003;
X-Microsoft-Antispam-Message-Info:
	Qobgf1+qg7NOo7LdaT0+YmMbDcPenAbp88rCWNUWjr0ZWvb0wfrhmLnydyj8RGFCIXDk+1eD6fa1nK6yePa3HYrBkIL1KEp9K4KwH0kJGuNyYbKRGE6h1g8R/k7ZiOQ0BxZlXLqC+KV2SJEipr9aa2KX+W7wIZQOLwzPrqLONNsJu6rtE1Q52FknoEwmMl3l55LzpkCASO32LG+fFzFmJdowZ/rHD90aapCAbo53PhNmm8WzQ2fOlubvhe+7W7WYQkHkIrfw2QjvjvlyjxDksXvGkCr1pNBYjRY1rvaRNszqR9ZuIYkG9Q8vv875euAtkKztUK8inqPau4pI6Z9Y4u7TDhjXuk8igvki4Bkq5scHJ6dXDEky4lTirXRA95TK6oTgYF+/XpWyVA6AoER8f+AIKlXMXlqQVIWhHcDeaMPzUgJIqVBWc8OWShyVOTR6FI3hmFRumDpBEINJbA251PRxQn5i2D/J0KZS8MHHsYr0ANvArVD1VmBjg/8f68SfYM6RWp9hv9cfI9kvKczoRa2Ir9YObY3xPtAvboG2SG9IMfjm/YhBKmqpD+toDoLFzofTqXnBViEbyfKW7U8EkT1SBs2WSR9TDYjN/Mby4cxoseQzmP+6gueU7rdpJR2TgMrxPD4K/ZdDQZH41HR0gTLByAeI8Tks2Dj1kzjBUR6qKC6Y8Brq64n5N520X2s4pOruuTSMTiVOwQRg8dhboA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(366016)(1800799024)(921020)(5023799004)(11063799006)(10067099003)(18002099003)(56012099006)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qn4YOnFhuzadT3L/rI7ydQ1dO5uJfKYcfTBo+abKiFVU1FoVDMQ/MA/pcLAi?=
 =?us-ascii?Q?gmARWQ7zdcb4y4rGYKWYb/oN2GInbXa0X8302CeSUf0aX+E2tAt6I/ywUoSv?=
 =?us-ascii?Q?LcqBkyf2ZrSF3KGgafh4SsqMww0plt3UrSoOpHPrqXAHw/KHk0sIWsXXmdNJ?=
 =?us-ascii?Q?NWiahPGXeEKQ8TRLDS/c6qa5YQyOQStlM4ONmTuRW5mLNlMIr5BZ82U5iRGX?=
 =?us-ascii?Q?AvSgc8TkCv5KGaZGcnxkOUlKea3Jut/6F5FsuSDrzMqfQVHO88d3dq8Jv7/h?=
 =?us-ascii?Q?SNcBb5dwXs6oGKBZjrmdl4OU94Azi4mC7b20pp6jHTUJEAXk1lzxmb1a5/Vw?=
 =?us-ascii?Q?ilDzzH1c9qGTMBRQo3Au64YVpDJlwMVkM+enjWxW0lmntNtRKEN0MNFp5tvQ?=
 =?us-ascii?Q?5S5Zj6Zp/sDs5Cn0UtuDJ08LYejbwL+pQ5ALb0saic7ki3J9ttAj2knE00Rr?=
 =?us-ascii?Q?4SEFXP+kOu9m9yg56tn0gVpXWRnEYdDS1JbQNKB9qwikQEtMB+D0M0xycLHu?=
 =?us-ascii?Q?24hGyhCn8R/fJxwMTpXRdsUF7cK3xj8arYWoTN6q8FBpIb71lTB095JJ27Oj?=
 =?us-ascii?Q?oc0AZO+r9G9Z7OVzvtuxBNq/RR5rqoq3Lfz2H0/NsmcQiLvTSMNcT3T7DNcN?=
 =?us-ascii?Q?HLFeGdF2wrHukiS+3mBh1ozvSBgSefsHqg1IZ0ytR34ct8VkhCZdca7dv2fs?=
 =?us-ascii?Q?ot11w42ZaY51khDtDC4pfPk7OCELm7Fd4rgSLpVmlRh6pqakNUosEXIHW1Ry?=
 =?us-ascii?Q?TrHToVZxhiJjB1pzND7YCz0upki6EDBFwfDXZJyjNPjJe1Dy4HroVIeSnZ60?=
 =?us-ascii?Q?dKMCvg896bxDp7BK+VxcIFk1SnWNILW53jlOcHFSmvpfdDTXqHNLpw6QKQL+?=
 =?us-ascii?Q?Qqgzm+Yu7qjq6cCg2cuntpaeytvY7oS5Hn9grbRp5y4uB2NwRwXBJbiB7axJ?=
 =?us-ascii?Q?as6imMZz57wRtOD3DxM31A3z4L+iYyg8ghMRTfnCRO0FsVwq5L6sSeugow9l?=
 =?us-ascii?Q?or4QMKtrMKKRi93oLra3vlZUPaveOsaDqzXjw/sabpfKt6UWWnLVwGVUA/xX?=
 =?us-ascii?Q?C960IvGX7IINyeA4xgLWZ8/PlrnphZIpP4c+GyUIKU4XgAO9GOkVun0UEkzB?=
 =?us-ascii?Q?yJGixp7AvzQBKzvcbG/XtUTUe8U7T3qI7hAZRv7v6MBexebUvYWj4RipJ41M?=
 =?us-ascii?Q?APbKsRegNK6QlQZyNJ0xk7pv0hcTJ+gly2Ae66PhimcGcz+OtXV3MKw3YG6g?=
 =?us-ascii?Q?+hKtvzM6doe/dL4MHB0jIKIC15pHgqh9oripy+15vgM4b33YfpOcMFRw01h1?=
 =?us-ascii?Q?ihC8azfDeO1tK9Woy/RcfnDysbyXogLqB0wFqh17/i4IozwUOcWFblLLjoVv?=
 =?us-ascii?Q?siBaN+o0JYo8IZmAbSsApZfJS4hjh4yDc3RMwweSDu2w/1gEG7x4q2nrlQxO?=
 =?us-ascii?Q?EzE8S8vhWSbuFlMoha/i8lokg72EuyE5mSD9YW46GmjLyitYI8nC+rd/ZHv8?=
 =?us-ascii?Q?uFRl5z1eSxXPAMXOia6sTPkOdaaubSMLG+JvLys7WYFCm9t3uZPt2V4H/Q9q?=
 =?us-ascii?Q?TVzIdNc7yOJe4+bKhYVlOxvi+Ezd1EHTr/Vvwfqayn7XN/E8aL5MR3m5fhpK?=
 =?us-ascii?Q?0gIJkuTD3ghXhig8Nzztx4AJAQFsL74PYMMIbu6V3Msh4ykVyb8D2/oTt2/l?=
 =?us-ascii?Q?gfUp9LtyadD98OuxuzCZ+H8zMn+U+K97+C8ro8iXNhcH21yk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1368b55-8039-4d8e-64f3-08df145282bd
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2026 00:27:52.3873
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKqi0HNWBcErXimajgTmuU3cXwsNeyoRm5BLrsesveELCwILyWEHIwcaLhmEH/Ch
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6160

If DS is supported then SCALE can go up to 39. Compute a scale max that is
compatible for the entire invs list.

Replace the has_range_inv in the invs list with a 0 range_inv_scale_max
means no RIL.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c   |  4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c    | 18 +++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h    |  5 +++--
 3 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 6f8917ff33a02b..ca734c14106418 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -647,7 +647,7 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 {
 	KUNIT_EXPECT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
-	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_EQ(test, invs->range_inv_scale_max, 31);
 	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_ril);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
@@ -709,7 +709,7 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 	/* New array */
 	test_a = arm_smmu_invs_alloc(0);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
-	KUNIT_EXPECT_FALSE(test, test_a->has_range_inv);
+	KUNIT_EXPECT_EQ(test, test_a->range_inv_scale_max, 0);
 	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_ril);
 
 	/* Test1: merge invs1 (new array) */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 21d340c1a90de8..3747cac6353a92 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1060,9 +1060,15 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 		invs->has_ats = true;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		invs->has_range_inv = true;
+		unsigned int scale_max;
+
 		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
 			invs->has_full_cont_ril = true;
+
+		scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
+		if (!invs->range_inv_scale_max ||
+		    scale_max < invs->range_inv_scale_max)
+			invs->range_inv_scale_max = scale_max;
 	}
 }
 
@@ -2635,7 +2641,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
-				     bool single_ril)
+				     bool single_ril,
+				     unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_ttl(
@@ -2657,7 +2664,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
 	first.scale = arm_smmu_ril_calc_scale(num_tg);
-	if (first.scale > 31) {
+	if (first.scale > scale_max) {
 		/* Range too large for a single command do full invalidation */
 		tlbi->range.use_full_inv = true;
 		return;
@@ -2921,12 +2928,13 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	 * Only precalculate RIL if it will be used, invs generation ensures
 	 * this matches the instances used for invalidation.
 	 */
-	if (invs->has_range_inv) {
+	if (invs->range_inv_scale_max) {
 		if (!tlbi->range.use_full_inv) {
 			arm_smmu_tlbi_calc_range(
 				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-					invs->has_full_cont_ril);
+					invs->has_full_cont_ril,
+				invs->range_inv_scale_max);
 		}
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 3f701a6d917647..65fa94e8651493 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,8 +758,9 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
- * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @has_full_cont_ril: flag if any entry's SMMU requires the CONT RIL workaround
+ * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs, or 0 if
+ *                       no SMMU supports range invalidation
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -789,8 +790,8 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
-	bool has_range_inv;
 	bool has_full_cont_ril;
+	u8 range_inv_scale_max;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

