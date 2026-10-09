Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010069.outbound.protection.outlook.com [52.101.56.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAF841A914;
	Fri,  9 Oct 2026 20:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791576868; cv=fail; b=GGCJ86rpVzeHkyCFCbxbzSw3MpbHsPngPuGuBjmL/TQXBFP9LiGA1H4ERtZKvM2kGp2lhIfVb2Bh54XpK2rUH0Va6ELBB8nRw6CORLy6E1Lb78r1nZPhcUgNb3rns8Y4VZyTJJ2d3hc7d+sZ5EubuxNNTHP+I9sZlwp92Qt1rHg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791576868; c=relaxed/simple;
	bh=3U9YnhzLZ5GGR1u8E4PtlbFFa8NJxVrHqDorgMekfUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Dx3f1zRigvXDLMOpN1f9QXX/ADCTgO7Ex51gIVQqL/+t15eXVM4N4HRHgP7e7UlT7HpkM2VWLe/5TOfh0SerREpSIJpwE19o5AzBT2Iy8U7gE8rwO2bzDOLQcboQX6mQFKneuscOJHEmhGY2IWCWqsun1ffTdt8SMvDy1WUbzEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i1uT2tZ2; arc=fail smtp.client-ip=52.101.56.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i1uT2tZ2"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sWJZWtQNmLIVjQBDK7t3PROk6XI4RTCtL6pQWhVpTYrO68Ss6toaAObYTXvEjV/OTsvodkbx68vI4tRntT+ud5IOZdMw7+mqO0iiff64V8TCScxoFGYGHgSHAKB2KF1SkrraGe0tF71cZY6sdDVWUxpWowvgFwm7yCzMQDDGu92lo/Z+D/eiT2HhCzioxWifdliYgbXQrqEPOBSygPAhY2EOopNtD98cMA15PM+Nr35tOSCnlyonBZ1J838xdq1dVX26BZg5bu0p+hi22NxZZTeI1kF1kFA68dxkRGSdfCd7c2gZ+iPqeD7jujt/o2i3DsSG7zvrS8Gn+T4v54GOsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AjSsTM9dn3VrkQezd6gVSQR2HX71jW7U84DNER0SLFU=;
 b=RkqVFXrwDy2uIAgXAIMP7ztmobGPWBW9pRGhf1cKT3ikG5GDSF9q5Alkm2hpKy4GnNNaPV4AGK1GDlR82hoP5VY2CoV1kdtNui1kstQ+o+jWuk4QOaQyG0xXYSg4+tIfNj6WNEUFSVhlc18eWCo2FyqF/kWUHSdEeOMsL+uggUoEdXUTziuu+t/f/1GPN4AHbOWA5UaR0gxrKHV66hYyuFJsVvvR43QWzofb5Lniae93EvhoJhXXVeR3HjnikF2F0M5RwI2+lOIxb5+SvNW3c/Q6h4vRlUXYXfqxf/dk3ptfAe73ZpMYMug3XLbmQBVlK2o2xPzsFwY08rU2WBq3GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AjSsTM9dn3VrkQezd6gVSQR2HX71jW7U84DNER0SLFU=;
 b=i1uT2tZ2VswI2T3lFulHmtDML93rPvfSiEDu/WLu1yh8Tn6Dh7CQp30MOnuK9VY8fF3udmxoE8b9OB9QRAZRpZBRXMNGG9fgKRw5RQw7e+8XaYH6F4mPuMhyo+PQBoWICPSSJaqh4dBXJw3ztHZGQ0Yht2XmjCsdMHZ7RyEPK3tSnZ8/ZMTyidB+GISMoVi52twF7x5R/4XgRdE0Ye5hP2z1+3v7pmhx85G01E5HL/QR/7eDDMF+3BEBjmpGss5z3gDQ/8QPFJ/ojFSg3S8J07WWwEzEGwn4lOnUQ7eVB8Gi5PA/0cbj0e/FJTZ20MYb04XHaqY9QBdQxlCTzu1hwg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DSVPR12MB999174.namprd12.prod.outlook.com
 (2603:10b6:8:389::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Fri, 9 Oct
 2026 20:14:20 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0496.015; Fri, 9 Oct 2026
 20:14:20 +0000
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
Subject: [PATCH v9 2/2] iommu/arm-smmu-v3: Support the DS expansion of range invalidation SCALE
Date: Fri,  9 Oct 2026 17:14:18 -0300
Message-ID: <2-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v9-e1637b95096d+d83ffe-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0015.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::22) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DSVPR12MB999174:EE_
X-MS-Office365-Filtering-Correlation-Id: 884dc782-7b37-45d8-c6cc-08df2641e6e7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|22082099003|10067099003|18002099003|11063799006|56012099006|5023799004;
X-Microsoft-Antispam-Message-Info:
	dcNzuonKO3/VuTQUlUC1uc6lVKShdHUXpcVk2JQ+3VoipqeMtTQPPaasaZX9wkkchQR+TMLQJ99aKzWN4t3HlpxRhg/Veq+7BqvfJqH5Kwif3bR76jS7Wchbl/BQNsko6x6eAbhp5bcQhYUyZFA8k1PyYPoVlCqAIFSMGmiItfo9DDoU3g36gE/U4uF2LpXgL+G9H4F2Gg1kpM8dcOF3zUF6EabKYhlXQJsOxukjpN+oSM6cxyBsBXXmaFd2ZB5Otnj41LGlwoLkvBVcT8KP9hrQB6o9LU5Oc5R+guqy5UvLHI+wY7qQpWEErfAk9vgl9CukOKwGIi+IC+Xk50Jtk22Z5rddIovxw2aeLAOT6bXum6E4rf3aEG6NEOlcLdX4SFZvLXUCbDkGR3smIit0yy52koebPE6e+38IeBUmRyllIGxg6/hFGRLCYKkRZYjjWZNyrtz+Mhg23svfnJBp+a4ZujUgpMCq747rMKL8DFejrWcUxOC3LV8vxeTykHutP9GpjSgnwXfWDaVI5CSnioHe11NkKlmxrczIKVgYgIlelMcRj6FfzOWk8hkqkHGRZ+nEnu0VcYe5JKnL/+roIkj0hQKE/eFf1dHotBuArqLOKnq+bPXtADGKZ+biLeFUOoAzUYRDvzrY617MVBS/DAgXTPfyXT57tcuerV7WOjo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(22082099003)(10067099003)(18002099003)(11063799006)(56012099006)(5023799004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+xj5YngbL37BS7y6p4W0uwc342sjgAxROwzBzUHzNCg3RmJGYgDqA26q56gc?=
 =?us-ascii?Q?mlpuVoYOLyXP5tSTXbGZudSux8hFa6h1tWmGdaDFrywU+Tr+5Bqh/76Q+Twb?=
 =?us-ascii?Q?aj4EgCvBsFqMbJrPiBpau7XGEROXGQHjBJaFpB+zHgYqAvt1Y47zjZRYv4fG?=
 =?us-ascii?Q?skLQ8dRL3eLSvKiuGwuKFHP8dc+2fjNJXJQsTWITHAZ8rYh2ir2kX9uxb/7t?=
 =?us-ascii?Q?FskaAtTMeaUO3IUta/lH856EYpGt8Pv/+ilHK6nrgIuRGKaA+3JqBkeor9Pj?=
 =?us-ascii?Q?eK1/eta2zNpeNlL5g1llQ0UN99S4yYtPxpkQ0ccrFbhntcYfZg0a0B1eGEzK?=
 =?us-ascii?Q?LZQow56zYvjkzYllo31LtEs66ZMeCTPkKT1A1hVvwyQa0N2Me3nlD4OFH0o5?=
 =?us-ascii?Q?wqxjQmyxOlc+7XMI3stDluMUJjZkdEH+YkdVKKw7kXb2qLR3Y+qOAnFFKc2k?=
 =?us-ascii?Q?DlhyUWifm9d4u3yEMssMz6x1OqlY1bG/YVYrBncQx4sdXi5YaqRyRDYF0T/9?=
 =?us-ascii?Q?Qz2zmE1X0GbBtBxuf1Wcqd2+EfwW4/e5hfcfAib07xyfTAdIL9YgR1GZND9N?=
 =?us-ascii?Q?g4fYCUrbGMOKmUUouq4CO+4rWv+RJR02czxNZlrjlSZ7m4SEAnOyJxWOp3F6?=
 =?us-ascii?Q?U+dxxrKWE+ZQzIoV6SDVh9UFYMWrozgx4DINwEAl290uQjoMYo78RWumJKB9?=
 =?us-ascii?Q?PkatPdRd3iKZgioBFv2awVHv/Nlohc4y15fQF62sdG0ToAR08dWAaXCQBHpe?=
 =?us-ascii?Q?L0fNZTqUALzpPGJM3QHXuy6LFzY0TN90Wx92BE/2n1BQjVW/TMgFVAHtOxPI?=
 =?us-ascii?Q?YJVc7+o6kPFSVo07l5+LysU5WT1i3+Hy6RTyE4JmRSShP2ZURmwJMjOk3EVS?=
 =?us-ascii?Q?JbiuR8HezSELzllYSJEHrBcUuG8XMRrKo/a/beqjwGBvVDt/C3EW1dmHX7a3?=
 =?us-ascii?Q?Gbqs+agCrODGvfaUJwt5Kbi7kEoJ2hw5bFsQq5qRfqMTNMjyin7oGmWUs2FI?=
 =?us-ascii?Q?GryKtuqYIMgzismbd8BDj0+kPZnvLFOQLJGu3AJjPAJbJl7yN72kEVxTdWI2?=
 =?us-ascii?Q?riPked2Oy/mib6AkWiSAeA1PlQ9BacKTrXLJe86uwp1wG7MfbTKWyA89d2Zq?=
 =?us-ascii?Q?c0q0W6eCp68tg+jV0UVG4xuycZNarME51ptUqraYOj7QJi60EwcoWFHv0D3R?=
 =?us-ascii?Q?1v+hK+bDJnSblupJbnGETCY0X4eJB+4oZVC/xUA2lslyvArRHG3701xo929e?=
 =?us-ascii?Q?shsKzVDld817ac8nB3ZhrqrpJDrJYv8yHVcDD0PhNblmYjQFxWMHrKcEv+qp?=
 =?us-ascii?Q?eXxDap48jh3b2pE9tUAEZ0hNmI+li9BG6+liYs3xr7eSZ6xmhKmuq5FhU7Jk?=
 =?us-ascii?Q?wmSxX1aAOmj4LYmg5apu6hK78fUaQwzeDgBQ0XOPpQCZ49ZFtDMFydNwFF2w?=
 =?us-ascii?Q?rJmKic7MrRx5YoBdGyFmNYfwZYAwgSuiPThtaunquzAGtTaWwSR6zp6cfGM4?=
 =?us-ascii?Q?AlYmzLLYWAwKn60Wklj+uFB7J1xwW6Zb09++HgOQQTeAo7NSK85P9bmNeGkk?=
 =?us-ascii?Q?HFLd0yBzqhyaR/lnOQ8bNo2rmLOaBok8ZoueQPmFJ3Ce2EAM2sYduoX7h934?=
 =?us-ascii?Q?6azYmFbatREmya1KwNo+dOhDwI+fCRwzvnbEx/GWsn0jgCYcdhDTRdcZn//Z?=
 =?us-ascii?Q?DSj5Opn6VMteIeZnxaLzj53h9CdtXwRElJqAoAbaVegIetie?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 884dc782-7b37-45d8-c6cc-08df2641e6e7
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 20:14:19.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l54YEGbB3aC2U6vtkGzDC4YtleLojn/bnn14N1Hp5J8DrW52ZYqe4ZM4J+zR++PC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSVPR12MB999174

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
index 6c6588477e7301..819cc54612486f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1065,9 +1065,19 @@ static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
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
 
@@ -2659,7 +2669,8 @@ static unsigned int arm_smmu_compute_range_ttl(u8 leaf_bitmap, u8 table_bitmap,
  * CONT is covered by one command.
  */
 static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
-				     bool single_range_inv)
+				     bool single_range_inv,
+				     unsigned int scale_max)
 {
 	u8 tgsz_lg2 = tlbi->tgsz_lg2;
 	unsigned int ttl = arm_smmu_compute_range_ttl(
@@ -2681,7 +2692,7 @@ static void arm_smmu_tlbi_calc_range(struct arm_smmu_tlbi *tlbi,
 	 * address beyond alignment to tg (so long as TTL=0).
 	 */
 	first.scale = arm_smmu_range_inv_calc_scale(num_tg);
-	if (first.scale > 31) {
+	if (first.scale > scale_max) {
 		/* Range too large for a single command do full invalidation */
 		tlbi->range.use_full_inv = true;
 		return;
@@ -2952,12 +2963,13 @@ void arm_smmu_domain_tlbi(struct arm_smmu_tlbi *tlbi,
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
index b08c112875d3b6..7106bd3a8bd7f6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -765,9 +765,10 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
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
@@ -797,8 +798,8 @@ struct arm_smmu_invs {
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

