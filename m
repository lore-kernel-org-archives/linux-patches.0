Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011039.outbound.protection.outlook.com [40.107.208.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F2534E745;
	Sat,  3 Oct 2026 01:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990666; cv=fail; b=S0DtpuB2+Q+N/0+hC7TINBlSQHzdDHosMKyjO3As74qHVr3cSPf/FzdnzZqH5s9DYa46sNCUIibtGz3Bg8tQ2UXRdzheROK1GtZkwkmphyUPJ9vjpPe+NwG4Jp2GeKVXnSEULzvIWcbuc+CV7KuvotniU7Hxs3h7gWKJs0jS0mw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990666; c=relaxed/simple;
	bh=lGH/OLv/SiiibV7qSl6sR9z3IRRg4kJshyPa0G5PHfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F2xnIWhYc9HNG5IBwgBDBGvHcaJw+n9/irL0q5hDC5cc4tQmzee2lXObkDOZfO7U0A21NkoQrTbVMpOa6Os3AJtLCcWXn8fhVlsvrVTHnpueZrq6BpMJu8mmca3e1hdlxNXEp2txe5qEP7cRpTz76R23GNGpMmbiquPOehVGEL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=LjnSVKyp; arc=fail smtp.client-ip=40.107.208.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="LjnSVKyp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o21IGeSimhtquHihBZhbo+DyW/uuN1BcGoWrMGAgrI78sfWTNckiX+KFmyUqk2OYpmHV++5Yz20MrIjSDiYZiCZFX0boFnUiN6ndbaAL+cnY0IZd8w/Uv2RIHKchLpmAgEm3hRrf5Jv7iuyzRNyNpkSo1w3bLUNKO8hBJDf4sg7Jtd36ZD41ndu+BKB+QxA0+GvXoBuf0LJM9u8CxwhcyyYPPG6HRCnLEyDEXDBPpR0FQlx/3Axg3Ju9cym8oAx4C9gheqU9DgTpdKJ6xNLNtbWpsIlKZC3HoNmq6NsPaujiLJNU0kWSJeBnleuo4S7Eki9kjY7p+UA/KAamce2QVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8k6fsBtHK6OQ8X8CF973OW2V9SwPnqeUUvlJkwhiMLs=;
 b=UQzOsBqSsu8pCl/rvDOdzc143nZsMTePP4P/Q421Ej8xPmru+0LJGBomYTSeMPpJHuMuvbFZQx6cxr52KsmoFClq+LAGc/bE/eLjmORqWPYdvENGztYp/kyEc8C7s3HZ2IWAFVvtgjVRV1hv8rTdxe121xZ8bp6Fb9OBrGZVHp/S1vcX2+sIB9J+BmqRPc8pIHOtFt2tyxghQtUTxg/USdujCGwokoBBT5HXw97SuSLETcW4gilCOLiQvVFW4QTKrOkEJpIvMl2KUUlyIfzPr+3gtxLLT/pQB/4VVfpxDa3eFIlC8QM/UxI6Oyqdh1kX1LeUqpd/1m6fmQtlr49n8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8k6fsBtHK6OQ8X8CF973OW2V9SwPnqeUUvlJkwhiMLs=;
 b=LjnSVKyp4P8SEK3urvsx8UppF9M7RsiHwu+YSRaTata81g6EoJpZWd489v8o2pRW2qTfoQkBjSCqJcESDuSseLwKC5m74eyTFc6+DLj2ssSWzsLp2rZYgw6ZQCt0zZ27cuPaUSPmcAp8eYw6lzcawAkTptTick0llmALz5L3hxJzhgQxTMle8ru7LXaqQPxNq9NcQVKnQTzVWPXSwHcmUQHfWDBBUJSuiJ31SX/UUmPDM5jiOsd+FMuu2C8NLhi7YzGuo1OctwlsURPJeKqn7f1dQlWzkJF4caCEplKC3C+KhJX7Ak/16wTHrSyEpvpFWAFf+zX6sa1+UigTaDob5w==
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
Subject: [PATCH v8 9/9] iommu/arm-smmu-v3: Support the DS expansion of range invalidation SCALE
Date: Fri,  2 Oct 2026 22:23:28 -0300
Message-ID: <9-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0030.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::35) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e3bee9-e658-43b6-0ea3-08df20ecef7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|23010399003|1800799024|5023799004|11063799006|10067099003|56012099006|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	nSakcE67zdsNiUGJTO2/LF/sSeg1FmkkEAh51eeJJtKE479QgmbnK7TvYVxXYoNxNvG+mrejTo9c8wD5qffjL6wn0MAsnzLTRgFanAk3AvjhF8VxRvO0AuGUR0M3ok2szBjcw4XFzS7RBfx8qiN/RBjMxRk9DCQ3++gZy8XAuGlO+Gg4G3onp18qBgTCjhMAOMVlPHRCb2T2h5Xl7AKxcie6G1FC5OHnRY44ffRGB6YDCm6ePI9me6/r68s/ztq8bgbCgekfstLqsqlNTat9yFs6ilk1nSWOM0WdelrI621HZQfE4LIO6EpcAh0YXGt0gdDDXl0vbfPZ4S/xVrGDHjOWXB0TPqrCSwTb/tuRLYYsyvVVFlHVGJbR2gquCI3AccvBs2ygcStZmoHjKXoUfG8Y2BNVWGrQfyYrmawbN4t//kSNWYN4hYiU2F4WQ7OX50ru7B8s28MaeYNGvL66h4xKaLFqr1hcQJHMotwfXBs3OCcA+v6nrdEmudx89vKrF3RCDMws3gn8q1RX7wcD2VrjYbAXCTgsX8qbejPgNjDd7JhogqHE3NqSW16YXyxoa2r5B+hVLnnLzhqGn/0999cXvx9B6ushrUEiWGL62asA9qKMntkXO2hwoyXDocNp+2eluUW5vnUdJ6HZoSMYiv41dtnIhHscADAuQCKc8rmgcaJ89ImR6vtYK9RZZcRwBwxmSLjdYxcXDxDCxjrK0w==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(23010399003)(1800799024)(5023799004)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AaGTAV3y8hDspjAxS3oF8Nx4oeglpWwhr4U53glZvE4uiaIMVbB/4HqikGfX?=
 =?us-ascii?Q?xVAg1ii16QhQhPV8Ew1a+Cyp7TEUFOmqXVfJ8WFmVN9Tp7YzcPkOC20A+o5+?=
 =?us-ascii?Q?tv5Tmcf+afRQqXITYnz3BVO93YoXmz6osuKiuRh0NyEPLPIqFlAv2V5cAf4r?=
 =?us-ascii?Q?14/KR61Puwlp5S0g8Iv/QWPTOdnfzdwwI3jMuSISycRyfDtu8mN1xZi+hEtw?=
 =?us-ascii?Q?Kb5B0ls1KJe145FJeaE0tb6WsB3t0KMxLFHCJqBCKQ8EB4iKZ2Vpjteyn6E9?=
 =?us-ascii?Q?uAw/1PcFAd6uFEzATB7HMbqexihWMIFEN8V9kIHKP2MtPci6o6TowRuelcpp?=
 =?us-ascii?Q?KHQpAaJUvonwfiZ8TQo9drGpsuhn1GZSOpvlIIssBlsUp1Rtvno3B9X6xj4V?=
 =?us-ascii?Q?uyrHAwMeOW4Scuac0/BUAup8qEWkfRv6Ah1GN9mquV9pBujq/tvIBfqPbWTy?=
 =?us-ascii?Q?o8bD9rnWLWlQyj7mkEyhw0K969aGcFgUA6WSmSNq55zHg9Nu37lYAvnl2iV1?=
 =?us-ascii?Q?BXwjI5TmuVp5iO2vSUlJTboOW+qH5xBznFKxEeIONXNop9O/K1BkKv9auNoz?=
 =?us-ascii?Q?jvoTKbwTHLnIaLMx8Wij5aUSExTuzndk/R1ioLJCsGRSaFUf1AHOiukJv4PA?=
 =?us-ascii?Q?2IamNWKxa096AfqY9lC6pBZetvGJpe3stDfQ5nIWL0kZc9LFi9fSVGZYLFXD?=
 =?us-ascii?Q?W+R+5m9AKbi/yWMnljwEgbbjRkk8Gfso9VyYMUZDrFvTdG0dQ/hGwHlGbQBa?=
 =?us-ascii?Q?WL2JZBnSn+Ux5IIoZW0HPsAbZUwywnl7aC8MFjUJlr/aJVE4SDnywbCwQbc9?=
 =?us-ascii?Q?6+rZbePaNfyn//aNuSzQsstj1I/upn7xnyCGn9NaVZCuFRdiUSxXrP4uizOO?=
 =?us-ascii?Q?2LMbKD3Nu+IRYtSF4OB2Icip5X5E/CvSJ1+l0oiZ7zM810u5Flf9G8UNJzev?=
 =?us-ascii?Q?foZO4J72OD7B15tnAYbdtlJtHTb8FgszpwNdF5rhgKQUOhFbtbr14LSdKEON?=
 =?us-ascii?Q?jitnMxkbp9tYYFB6BSeu+03wyI04Co2jdSgn/2BC81i+uCtCuII5Tu5Sm53E?=
 =?us-ascii?Q?fjgUqPulBFmMLRCrup52mpz/ysP1Txzkn+6BT4uz0OHHUsBNKLX9J/49p3jG?=
 =?us-ascii?Q?iYETi1SjJtaHGqKuYLxa4JO9HeaIlvcuKKW1J4t+Ie+iuFQKJsNNDhso3DSc?=
 =?us-ascii?Q?So8pFCJ9/NkL+JE1734T71f1/MsxVXLKhB5r2u7l6MCQzrhyjhMZiY8tLUIW?=
 =?us-ascii?Q?IZtjx8oMWxvcTb/7+ssfEdQ4DKyY7oe8AeAWp0ltANNa4Q/G5VQUjQAUeZdp?=
 =?us-ascii?Q?gIh6b87gtR/y3vb1U4THdSkgXfw0wML7/W0Neec5xLfWXul/LULPKsyqvjPG?=
 =?us-ascii?Q?R7iM2S9lNUNnG/cklryOqU18MLDUz+t5mvgqLr7LzZFZYbQ+YnkQMHLbY7Uh?=
 =?us-ascii?Q?0ukXcglJALrTSEGL3wyYNsNoFuFq4vkcuf4+SW8bHYbGzAAqzGqU4UC2DYcW?=
 =?us-ascii?Q?TYZpjOiYFg0croO2aSGajjZCL7lgoOo1eIpCltsCvRmJUCoqeYVYQhXkkFu8?=
 =?us-ascii?Q?N5uvQyph7kLWx8Ng5G+J5mGvOC80sMhyUkU9GZrkt6weLnJh1eDoTHvnc5ut?=
 =?us-ascii?Q?Ozfr2OnGwdl02S36/0LN/x7hDB9SbEx9L0wrxvvOq27OuINgbfg62KA+WOML?=
 =?us-ascii?Q?y3cGYFvtOeprWXXMuNh4wJXpiFsUn7Ll0sdTBN5BZhEZG5dv?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e3bee9-e658-43b6-0ea3-08df20ecef7e
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:31.4353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZxgUnPGPFbAE6NIUfnvL8eznQSZbl9MUERKNOD15kHL5xD7Ko0nN/T12aDCeuwND
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

If DS is supported then SCALE can go up to 39. Compute a scale max that is
compatible for the entire invs list.

Replace the has_range_inv in the invs list with a 0 range_inv_scale_max
to mean range invalidation is unavailable.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  |  4 ++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 22 ++++++++++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +++--
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index 5a4e45e1512589..3a0fef761daea8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -647,7 +647,7 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 {
 	KUNIT_ASSERT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
-	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_EQ(test, invs->range_inv_scale_max, 31);
 	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_range_inv);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
@@ -715,7 +715,7 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 	test_a = arm_smmu_invs_alloc(0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_a);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
-	KUNIT_EXPECT_FALSE(test, test_a->has_range_inv);
+	KUNIT_EXPECT_EQ(test, test_a->range_inv_scale_max, 0);
 	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_range_inv);
 
 	/* Test1: merge invs1 (new array) */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7053f00dfb7d90..9cd25afa78978e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1066,9 +1066,19 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
 		invs->has_ats = true;
 
 	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
-		invs->has_range_inv = true;
+		unsigned int scale_max;
+
 		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)
 			invs->has_full_cont_range_inv = true;
+
+		/*
+		 * SCALE increases to 6 bits when SMMU_IDR5.DS == 1, values
+		 * above 39 are treated as 39 (H.a 4.4.1.1)
+		 */
+		scale_max = (inv->smmu->features & ARM_SMMU_FEAT_DS) ? 39 : 31;
+		if (!invs->range_inv_scale_max ||
+		    scale_max < invs->range_inv_scale_max)
+			invs->range_inv_scale_max = scale_max;
 	}
 }
 
@@ -2660,7 +2670,8 @@ static unsigned int arm_smmu_compute_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * CONT is covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
-				     bool single_range_inv)
+				     bool single_range_inv,
+				     unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_ttl(
@@ -2682,7 +2693,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
 	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
-	if (first.scale > 31) {
+	if (first.scale > scale_max) {
 		/* Range too large for a single command do full invalidation */
 		tlbi->range.use_full_inv = true;
 		return;
@@ -2953,12 +2964,13 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
 	 * The invs generation ensures this matches the instances being
 	 * invalidated.
 	 */
-	if (invs->has_range_inv) {
+	if (invs->range_inv_scale_max) {
 		if (!tlbi->range.use_full_inv) {
 			arm_smmu_tlbi_calc_range(
 				tlbi,
 				smmu_domain->stage == ARM_SMMU_DOMAIN_SVA &&
-					invs->has_full_cont_range_inv);
+					invs->has_full_cont_range_inv,
+				invs->range_inv_scale_max);
 		}
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8950e23cb956ca..cc808bc80c51ef 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -763,9 +763,10 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
- * @has_range_inv: flag if any entry's SMMU supports range invalidation
  * @has_full_cont_range_inv: flag if any entry's SMMU requires the CONT range
  *                           invalidation workaround
+ * @range_inv_scale_max: max SCALE usable by all range-capable SMMUs, or 0 if
+ *                       no SMMU supports range invalidation
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -795,8 +796,8 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
-	bool has_range_inv;
 	bool has_full_cont_range_inv;
+	u8 range_inv_scale_max;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

