Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012066.outbound.protection.outlook.com [52.101.53.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3FB3BB139;
	Mon,  6 Jul 2026 16:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783355218; cv=fail; b=PzJIyRr4B/8wSevwwN1Y4Gv+JvJJyBFoYTYAN7D66bFENLdbmjVmi51LFBjRGgNrOkNCcv07r67PYXc63PLA9u4wFvu4aX6h656F+O0il2pSGjaBZKjqT+nNpvtlOo/C6wh3wTMY1ING0k38fGMFvENhVprpISYt7BZurEVoDOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783355218; c=relaxed/simple;
	bh=PhAZC6IoI2vwiMrHQuiQvPEC+mKfynJwWa8CAscdotY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=LAskmRAypfk3r7XdCjF0WgjLHTam8DjKJTfn26dDkTOoqiqdwScQwvlKVsAiS+1Tqqvhids2SnHWcBFy8errLdaXta0t+bIShceWXK0C54qe0zQI0m7jE/HQ3FSjhxEz3HeefKCJZvSnSh9ruJrTChJeVCAi7Sh8pwb09cT4YPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=beRnSzpm; arc=fail smtp.client-ip=52.101.53.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="beRnSzpm"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t2qFdAISWnUwu/bxezY7vWE8faVevzqwKH9YUOIsCQ4rvpFM2lmYy6qX7q8bTKpVlIWYhHYV0ig593c/EAWu2GZWmn3MEEh3uSzdP/7isxJAShHQDA4KQabdUrLO0Cn19zmhN5x6Sc1ruaywIV/I5KJ5eDepNqnqsQ6zDAGK2kea45+ClBZji8Z0/ZrCBjsIPS9ep2IN55pi1vGK7+lBeUC7JG5xXVIn1fJmKz2SybBe0FLSmD9fm6XmWJRsLjlFmVxn0kUJFhTCg7JRzgSrIHXsJ4wSvBUt4M6xH2JbG0XlRDMpmqS87Laa4DSs4foTnXoydvCrzBXT7i64z1tzoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kdi28TRDpYpWhUoV7RF76vyA4HIVYF2F35g2OD71OyQ=;
 b=FwQjTHLrahia+XWgMVj3Ee614l1bB7uRkdOxCTRM46loivN4M/HNNSz0SfUl52wTR7SsJ/33JU1bx4FNtNYkHomOp2WW9l0Et8XyYCsUkuAnkhWpf/M2WbXaXEwdElJYZyKcWRp9lQLCPgiR89CKun5YlFxHS7X8bw184wCEOo4n23n8m/e9gZpEpVqoUeqJMzWFC3Ft1QNHe80vG2jmj7CyMWpzN905GI2lnCAV7zwtR0MSadEk/RCsDD/pKpOBt4iGekVlBSWSgNyOme44XRwEodW7EKE6U1VGtr8RVY2FkTSJOU1NDe8hQohRinNtdyu63FVephjY9HCVlhEnkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kdi28TRDpYpWhUoV7RF76vyA4HIVYF2F35g2OD71OyQ=;
 b=beRnSzpmMKG/toxjq/DrOiJ2kuHfuMGClPWFBLcLoVMTYX08PWrGD7fFIj2AULVSlnHp7BQZF09Z5bMRXtslZAZP2l4Luh4NQnNPK1IkXUv34AAsTG7uydRKRkUAQ8j+iFOuoC6MXbfy84w0gtPDunxO2npW/s6PC88hqnjQCRuMmv3NJwh/BY5QFV2428vjAqQ6o/NgyAGfkIdjkZjmGU1316OQ5+cCsRNXUKurGiCoU+AoM2eueuM3WLC34EKF+VaTJ6ceCeRX7RluytjIBTq3FVeasGLEYsHgQOSJOF23tsQ5cKVvNXgUK0V21x4W2V1OHcAQCEoaI3FxHemicw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by CH3PR12MB8535.namprd12.prod.outlook.com (2603:10b6:610:160::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Mon, 6 Jul
 2026 16:26:49 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Mon, 6 Jul 2026
 16:26:48 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 4/8] iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
Date: Mon,  6 Jul 2026 13:26:41 -0300
Message-ID: <4-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: IA1P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::9) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|CH3PR12MB8535:EE_
X-MS-Office365-Filtering-Correlation-Id: e4e8552f-2de4-40fd-c62c-08dedb7b60dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|18002099003|22082099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	Q2kCNNAdhJ79kuUjomjpdTd5rGahxL/JX9E4W6HzPV3g32NIfupFThrq86oP09kOEG8hMI47gsI+3XWjyyxZUl377HrBKs5PR1RCbJ30w1V5ty67XqZacVV4cIwcVkL2QHiH4hO0IMnSJWDMIQsUizmUq1ukgyERxPTJ9YFJMWLOzlsdJZslB0rd0KJ8/vVNKu6VPQZJEfxJsDWgz9NgMkcco3A7wlojyp+n31Z+8pVoiGtzgaksJhNmNrTFgF0aPy+2Z9OeO1AcxsUUVZPalZIxAkhtQ0tx4vGheGiRDQ3HhhPfKLRL2hZdVE+NUjrBWr/6HXndgvvsQEa8QbT+2aOMYw5Vn5IpwZOicoFCOMkmdEikgQmwQ11B/xXtwGsW+nUVGFuA4593ahw6tSHH0fjehnirlEVb8AmZ6NX502XTfBjVS0Hez3NlUdRy8cKAqZ5knNkKw20WCxs52APgy2gb7DPWGlyzDzp8CEkCnb5v7eVhPKK3kZAYttl69kxb1g+QUNGhn59a1NL2L5+PsCnaS4lR5gLAcF6UxZtSoekWtZbg798Wj26+TqWXA4+/A/voYXKu+kZyzXjfFvVjRQwC5MwGT48ZDnXI/oWjKxS34PcG5+QuPsP1Vyy63uI7J9bi+bUM4Bb6xLlHOOeQYz6jg1x5L22rJ5TqIU4Lq3w=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(18002099003)(22082099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g3yleBCisn7LkGGtTFtGBNq3gMmGxIUihqhy7l5uRZj0d/loccplHy7U5ksu?=
 =?us-ascii?Q?2lLKuYqlAGVy79hsxcRbfrCqFF1jHBV6qKvP8xrWbZggMJni7f0tpA+wSdYI?=
 =?us-ascii?Q?zgCcptQ60JiGu4oyCSC1GpFBzqjxkB4tlyit0BvxPFRgLQVn3bOzJcTlmxXI?=
 =?us-ascii?Q?dhINoqmY1bTC/803OnZOfWki97UAVQoA0p5uNXPhpy60TmbMsnz3UT63XJfs?=
 =?us-ascii?Q?aLfyIEzkyemOOnWfzy2Vvjk5yznf9RCLLGwzO+gkPOeNGhp+negVj0rLgtsw?=
 =?us-ascii?Q?oFtxhEsEKudNT43AGFvWRQoVlZKObIHz3+3gB2ndLPrLI1rGjVwpjyoc+4de?=
 =?us-ascii?Q?+6TUX+oMyFOBeMOepudj8STEl8V6rQvNYiImhcf10ATGIOVKLpgOTXUqFp8P?=
 =?us-ascii?Q?hjRY3ip0HJONMXR90nqW1yS6fuz3LPq8pV5lMDDDsKei7o5D4BX83NCo9znd?=
 =?us-ascii?Q?DDxinyjhuYMDjJMac3ggUBEktWMicdKFgrBBA3SDwcsaVZTE3opz30ZTR0t6?=
 =?us-ascii?Q?kLGT6sxbkE1LVFQ2vQjws/a5MqCMST2raul+uxi4wUXbSnW6T96Qf46IAKlK?=
 =?us-ascii?Q?T+yS/ua/qpeS6vpGC/STQeljOr3Z9hGUIQWqBdqo08aTBoq3IHWRfvGcYviz?=
 =?us-ascii?Q?lUzGojjvx6J0Ti90CzuaR1aOQOatzYE6j9AIGgUtlsxIvYOunRSXSgyCcyKd?=
 =?us-ascii?Q?swFuEaEAAjdbPmJPZ/dVG+HsdikKn/qHtqBbK44nbr/C+iZom8Sy1qkfMOhf?=
 =?us-ascii?Q?QtnIXhyt5C4xrCw1G5ytS6wZ8jyIJA4GqRDVeDU9UpVGmZtLBJCqCTxtwajp?=
 =?us-ascii?Q?Itu70lQsIIhTNiEgVM8/1oImcA4SAapAFxNhslWz0RtoX1eSEeHb8hcN+WeS?=
 =?us-ascii?Q?zEs7CWBjn+sOR26jUfZhjXc8xljZMTGNbXaJ5gIGn6yOilniX1wl8l8nzpeV?=
 =?us-ascii?Q?O+C/Nh5O95ySpHadiMB/zdMwKlVMWtE+Ec5XNPNEhtrsBT9y6PWUhfI9NpBD?=
 =?us-ascii?Q?2ue6Yp1L4x7cIkmu41xasEvLMXHRJMYUMFhlLgFslzjdEtqjumgrZp+pvv/g?=
 =?us-ascii?Q?HqGpzxjXcKMCAroNrHiuqzv71NcEFlvyFZ0iIM4U8ZSVRjfO7kc2Uott3g2z?=
 =?us-ascii?Q?8axLKTozx7v0OBqcmTUvjj4lTX2sMpcLu5h6F2y9pMYXgPYyF2Q1jyHYMPhW?=
 =?us-ascii?Q?s8bkgB4McPfVq0yWdijW9oC1icQBtkrbU2vnm3sb1DDFIhF3tQdR/jrdFj3q?=
 =?us-ascii?Q?V4x0IciF/+nZfwpwBd7ARQ72VApuZwsErO2UKUBIEIXfJJFrKYw+jIh4qW/W?=
 =?us-ascii?Q?G3PI2x6V4olR5+bd/zapiS8kVii/VqSW2PC7ngeGcRtx9q5ljcneRemAuclQ?=
 =?us-ascii?Q?gEY98W2B70NAxzJbQ8K9XHyR3HtYDBqg0uwbCjGTBgPetkq9HaexAbMmXoG8?=
 =?us-ascii?Q?tpELbtD/kscGB7j1v6aUXs4HvlRsZvRiv/QpiQwqGbZDMudtmCVKN7VEOkaD?=
 =?us-ascii?Q?7nHynS/2lkJ9dLhN9KAWlI3figN6YAZzDZ4SfQ6UGiL/aM5WrbB+bGS/cCb0?=
 =?us-ascii?Q?e2LnJLY9Oi6jOY8WmoXRrO+imBVSnj0nrRim45mjFXF9AwdPo9gV7On25sfG?=
 =?us-ascii?Q?v7onQ2cxK8OQVnbUT/SgXIdDN2UjNiTEyVgmhgnmHKSxiSxNZ4G8+ucixgSf?=
 =?us-ascii?Q?EUiX5hPgvXGep3YagCf67Us34B8JWi9spLrbbuiyMJGcySWJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4e8552f-2de4-40fd-c62c-08dedb7b60dc
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2026 16:26:48.8180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTlIqtMttBhZ5Uiwz/ilYiKlc4/uHYz6ckB4pf/3vT6/hZGN7RaS3wtC55Vtz4gR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8535

Summarize if any of the inv entries will use RIL. The next patch will use
this to avoid RIL pre-calculations unless RIL is being used by the
invalidation.

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
index 1ad642e09eb92d..02323fd7709f07 100644
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
index 2fc695817671fe..3ef55f8af63d90 100644
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

