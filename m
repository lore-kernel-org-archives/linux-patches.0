Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011045.outbound.protection.outlook.com [40.93.194.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD5E247ECF2;
	Tue,  1 Sep 2026 17:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788285017; cv=fail; b=a7kjQBrLUUIQ08o77G2ieoC0eMR29YWXPo8tmNKbZp85MFOSrbgut6RULqcPCE3B/fJ45iKlcp64c4vqwpDHBwBzbrtjzENTGZTtt247qPg/CveRbSfCOpEv6WiLmA8qVDkMmrcFqWTKknILJMdPRvo/+uBXL3KKF9iQ6rg7HZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788285017; c=relaxed/simple;
	bh=RTt7v/nc9F7zEmXxOvPYZDZywJ/Bz/NX46iFPFoyW2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=aSsfGvqJMRBxblRAxaiqCmbtImQRImozGhVIh/ZNnIQpINWlukg/f+z2uJJr50KqxBo03aHNA6EghaF3ODl89be6DU+aHJHSUlALopa6xouuj6/XilfXN0p0dzEh/1adCUvu51vtmbPs/Kn8/Y//5jJgDr5xPyQP35uYYZn1MiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NKXe1Z9a; arc=fail smtp.client-ip=40.93.194.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NKXe1Z9a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S2R/BsUjU97qqlQaUhrnOBkEI5591oeqiHqUzqklJTTY64B0c3dQbiOa2g7/LiTZNblymDGlbg8+kmQ5QPPXWKyc+At9Mb7gNFLDjJ7BXuODXNJXYezJdQvQO4LyXiOi1r+lA7ZpGiqBQ9SWcYMWRlfSXW7VYyMxzOYWx/trt8tvhISupsL55xDUFwRAXlEd0nuRwrDtF71QpWXT8ppYGoEftsKuTSJ/XWzaLn+CoUGsBYyc87bA8vKlZokXl8CMn+DZ+mtrJUMRKiI7d3QBOwbGT1zjNdnqcbGfDszIGkRwVSFm7TeKOfT3Opz6u7yoiA1jU9lUYAyf8jVOH2qTLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5LfeHDzSxXHon8xFZ/G6BTxfH7AxF+QW8dN35OUffHo=;
 b=G8dDEaaKdzye2GnMGDTnhwfSXZfq7jJ/c+oXKIv7NKgdUg877LnDQLgYGQpDZU5HuO82YQECbt0XiV3jKvYbAGuV6hc2rM3JaZujysqwSpThECEugXzrRf/qQKHZg05MAbvOErqreaPqvsF/sQQKxMeZ0100iMIHZ9CsYf7NJjEIESPWi1MKwC2sabaif0B4GG+8Ftgp5/TyoLTQVb5dgm8jtCTODnOigSqCZvAquBNx0wgbQwwFH+lqLB7H44IPvir5yCzY92WOJOjoSEl+FEs7g7rZjjt8cwPQKCSRQlhBtfnHAh/dtn0CAVqqrzVzsLLmuBbeAvH/oJf5xcVfcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5LfeHDzSxXHon8xFZ/G6BTxfH7AxF+QW8dN35OUffHo=;
 b=NKXe1Z9a8F/QOEvn/+tIpJB105kJBLg9XrepLNFnubuS3jhwPae0o8dIBqXmwh9Eu3SkU4BCrxk3v/y3CXK0qwfeRtWuyYgVRE8y6adOLoGBDUAncGWQcZDJbMnwn5S3tYl1HDdMSkQGxCgfbOCMmHg+ofWjyunPjZbSFrPIoefICnqvujzDXUpZUUfM2HMvaFi7CnCL4uoxV1PSjGXIina9mvwqRp+oXwHg8VAgdFAqEimGPltbf4R4Grg0Skhx1iEC3jd3N4eZjbUXBwLMsgxfPzir86okcnul9p3GVDRuH0lc4NRWhcgDrt68PU8s1OisC2EnkNl4y8qXk636mw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SJ2PR12MB8848.namprd12.prod.outlook.com (2603:10b6:a03:537::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.12; Tue, 1 Sep
 2026 17:50:04 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 17:50:04 +0000
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
Subject: [PATCH v5 5/9] iommu/arm-smmu-v3: Keep track in the arm_smmu_invs if RIL is used
Date: Tue,  1 Sep 2026 14:49:54 -0300
Message-ID: <5-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v5-b810cf379bfc+13d738-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0011.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d1::24) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SJ2PR12MB8848:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d509e00-1222-4980-1c78-08df0851729a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|921020|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	GeHpO+vSkjeLJciwoUF6fJsfv+DJk7t/9+eSFqIyFpHihj/raXxc7pgwPT6iEhdb4KPkspVfEdGZR4U0ivP+UaGBFF5y1LAkvzbVB1mRexit7sqOGaVL76Lo231aBaL1oL5IUpedvYWEeg7B23/NmPEeEiBv3SqA8QbFIrEX9/Vrk6Dhv/UWcKILkn3nqbcl+1XVx65W/NyeeVIJze6mwdLSHPjmWzK5XPp9cQPqqOVquCHLGKxWtxp+/oSlXNIYAgxqNi6t828VNRYFwAs2kEbVoI42Q5A2rNF1ak5OwzxEDEmSNLtKzYW4xDn6eIL5fnLXnz5kLDC90lSVSstaUo7zCkYJmqK6tDDbPx+bx4VD4Oabr+B1fmmbniZnNZg5OJyXG0swmaR5Xcq1yygKdq0japoA/7ZcA3zPP82oGi1i6PG7XvEgZfGiI7+CX/JYKWUNcz39wmhvtQOFwT+zTX1L+51qnDQZVyrQ1Ry71Yh3qrdKsg4SxRzUG6RWxFGiPlNutGMbkqLIRf1HlbiYtjy/dAd+PdCVDAq3BCVk+NF4eiFqwnRnxfosfdd6vXoxPihXpwmkm81TFcL4XVYgyskz6sm03t8wXBK8ZQ2fKm0okhdxQFt3js7JrqY7ZJ4AHPnv2t9ueUpjScy3MuaIzMeAXf+8ZGkQ76T8rjIVvYCuabfW7Qx+okBn812UDrCiem0Kd1YpZiXbNygj/ugRPw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(921020)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5JHnYwhXmR/LPUqrOLlPuweMOEbIbIek6/hJIQWLkVNqtnlT5b9nN7JVxbvL?=
 =?us-ascii?Q?3WHqYdXDew62E5KvrPRBlVP3i5uQiDH9XMQwnFsAP3A5Qoud8LXx6OWu71xz?=
 =?us-ascii?Q?ORLrwaCVX6ac7B7MoCxxI/+vkDFAsHYlUjQIrZD7q+tkf/I+oWz7UomkICeQ?=
 =?us-ascii?Q?nAlNTsgTBYoXK5z1RnuQQuvtLxRJBndVMEz8TRmRr1zCtea9fHWj/8MTN7Hp?=
 =?us-ascii?Q?kbPfYPavLuZi93e2lqSA9JRPS7OgDmPmLaLegDyOq8Aj9XB2/yVnOvtM6Hba?=
 =?us-ascii?Q?ZccHQ2xnIyl9SNGJZZMYG0o/hAeX2X1EjfzDQPl6JHHrGMyLqhdfNKXZcIZf?=
 =?us-ascii?Q?AOYse1VkIKUNLAv92X0EITCBPvdgv+Vxtk3DJS5/wo9cOsAbenEQScmgYiVB?=
 =?us-ascii?Q?8C+Kl2V3syIm/hqcGlwqzhqL0JNXY6DiOf+/cRBlxP5b0cHb6oFBhY7A18U4?=
 =?us-ascii?Q?UeEYgCVuhQqkimWnYbZgp53E/foDx5TOKr+Cu/srEd4nuah9Ya3sQmokU2aP?=
 =?us-ascii?Q?6K3QDPufQ5kkbUv9PxDQvwV917j4XEK5YZlBkjvC3kZzbQgkY7d8M3ztuphU?=
 =?us-ascii?Q?5ego4wIEeJF02faCsY3b0ZOGKymqdcbXSw31uXZg/MuVftQxZPIQxUHC/1zF?=
 =?us-ascii?Q?mYXdiXoexb+SPdQHh2bzoz8ccHE3bLQAOVrKWel10sRHbnWy0+7zWEekCwac?=
 =?us-ascii?Q?49QGsRx4EDJAfV1cjmZPkMqRmX/VlU+JU5Q060R3cQ4f2WpKZO+/SCTu3ISs?=
 =?us-ascii?Q?S+8QP9S2WNXkcaVtsbUuY0Owy+M++/ptFGEU7UyialAU2WyINT+e9oEoOmC2?=
 =?us-ascii?Q?hMMi4vf8uedFtBo4XYauIerTKt5zxPF0Xwo/mGyWZW4g7q6ryziU2k+qwSoP?=
 =?us-ascii?Q?b7jwxcrAjuVCgKnJhaDtSQZTTie/Oc0+jdoV4PgPYj3csNXkd75hwZgaRYlx?=
 =?us-ascii?Q?Z4zpvWyTKIM9N5c5kXLPSu23AYrFOk1YWqj1LEhIlOI53mojF5R+TMj4BG5p?=
 =?us-ascii?Q?W4DonAbt4OLV55GJZWPftOrgnZXkF1+mADd5W172GqLIOIOdsfCBVKEuKtTg?=
 =?us-ascii?Q?JkvntnfmldBRQcpZ1w/d5RIpuRuHqJbVUpIMaEmOHZDfg261YUCiPbDPVBZz?=
 =?us-ascii?Q?tCluxOGeiQKmLQbth9qTjZqUcZHxqZ7X9gEO7GjabsVXNVGXS8YNdssRuZv5?=
 =?us-ascii?Q?xc7/FFaZWwWjCmdb5eIVO48D4UwsDfjw0D1uu5ZIhbbz4PllkopUWYuizIU7?=
 =?us-ascii?Q?JU+4VA7xweUviXLi0DvFNAJFjp+jOlzUyBUXaORE1mlhxsxigytmt38bTfCK?=
 =?us-ascii?Q?QC3KFdT04d6e4dOZVMFA/svJmAQo0wC9D/KU3GZ1Do9ee1w9+1BUTPPbLI6c?=
 =?us-ascii?Q?2l97ORllCz4HVB1vJM7SBM4QkDaH4pWk0KyA+YB7tzKRCqmm01ohJhrCwBIm?=
 =?us-ascii?Q?ppOGmhypnJsZW51mwwICLDlYkxgmepUQxLmog2NgTV74RD8aJDFJ+uLAxLua?=
 =?us-ascii?Q?2jQE5Wp4LmCFixZUixVWozhDZNh5Hh9GTZIgYFnNpuLbz7UlLoNLdqr0y2KR?=
 =?us-ascii?Q?oTc7eC+BZwZySXumhZWHKv/F3dV8PMm2LOQLj2ppbUc2avINOJyfKHz/nGOi?=
 =?us-ascii?Q?OCyAx2NKccGl8jFAVnaEJOWYuzk5V7oXZBt3CHGLlz5QmhdHz6hunY4nzDYZ?=
 =?us-ascii?Q?+aGCBQC10PEurOxt6gkeRwVstFI1PnSPRG60FbjMcSP9gdpH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d509e00-1222-4980-1c78-08df0851729a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 17:50:02.1229
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 45oxtFduN/TyXQzJOJPZv2iCssMY/pzOwBl2jm+l2Xc2mw0ry4YcQ4pbWdqTk8tr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8848

Summarize if any of the inv entries will use RIL and if any need
ARM_SMMU_OPT_FULL_CONT_RIL. The next patch will use this to avoid RIL
pre-calculations unless RIL is being used by the invalidation.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 38 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 19 ++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 ++
 3 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c828c..6f8917ff33a02b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -24,7 +24,9 @@ struct arm_smmu_test_writer {
 static struct arm_smmu_ste bypass_ste;
 static struct arm_smmu_ste abort_ste;
 static struct arm_smmu_device smmu = {
-	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR
+	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR |
+		    ARM_SMMU_FEAT_RANGE_INV,
+	.options = ARM_SMMU_OPT_FULL_CONT_RIL,
 };
 static struct mm_struct sva_mm = {
 	.pgd = (void *)0xdaedbeefdeadbeefULL,
@@ -645,6 +647,8 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 {
 	KUNIT_EXPECT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
+	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_ril);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
 		KUNIT_EXPECT_EQ(test, READ_ONCE(invs->inv[num_invs].users),
@@ -655,37 +659,37 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 
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
@@ -705,6 +709,8 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 	/* New array */
 	test_a = arm_smmu_invs_alloc(0);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+	KUNIT_EXPECT_FALSE(test, test_a->has_range_inv);
+	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_ril);
 
 	/* Test1: merge invs1 (new array) */
 	test_b = arm_smmu_invs_merge(test_a, &invs1);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 9b79d7a5389812..68dd7b69392737 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1053,6 +1053,19 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
 	return arm_smmu_inv_cmp(cur_l, &invs_r->inv[next_r]);
 }
 
+static void arm_smmu_invs_update_caps(struct arm_smmu_invs *invs,
+				      const struct arm_smmu_inv *inv)
+{
+	if (arm_smmu_inv_is_ats(inv))
+		invs->has_ats = true;
+
+	if (inv->smmu->features & ARM_SMMU_FEAT_RANGE_INV) {
+		invs->has_range_inv = true;
+		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RIL)
+			invs->has_full_cont_ril = true;
+	}
+}
+
 /**
  * arm_smmu_invs_for_each_cmp - Iterate over two sorted arrays computing for
  *                              arm_smmu_invs_merge() or arm_smmu_invs_unref()
@@ -1123,8 +1136,7 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 		 */
 		if (new != new_invs->inv)
 			WARN_ON_ONCE(arm_smmu_inv_cmp(new - 1, new) == 1);
-		if (arm_smmu_inv_is_ats(new))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, new);
 		new++;
 	}
 
@@ -1234,8 +1246,7 @@ struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs)
 
 	arm_smmu_invs_for_each_entry(invs, i, inv) {
 		new_invs->inv[num_invs] = *inv;
-		if (arm_smmu_inv_is_ats(inv))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, inv);
 		num_invs++;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8b075e05d900aa..4b9f04825eefa2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,6 +758,8 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
+ * @has_full_cont_ril: flag if any entry's SMMU requires the CONT RIL workaround
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -787,6 +789,8 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
+	bool has_range_inv;
+	bool has_full_cont_ril;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

