Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D29D340A6B;
	Sat,  3 Oct 2026 01:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790990632; cv=fail; b=LvP+HXFbequhiFWen21ZT+280w6X9oj2n6CAyWFgVOwCKWojiAphdMLheyl3kWaOP6uLcWwD1v18k6rayFx1TN1l5xTnulRe9C8kRAxZkJLJI7dBMPHJPeTKFRuHBhors66YKaClzmITk2jOHjff3C3sAmZz8BtV1YcNpuSDHOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790990632; c=relaxed/simple;
	bh=Kdg6sRl3zFaxxQVN6Lsh2yIm/8NRLfdDAlJNYaJaUFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=E8uprDctbZcUWlu4coZxYkBapx2UnDZLUr5ENCzMCzL+vq6Jzu8MJsftBzAP4UUZxeOY+UyZS78zLyN0ftj5fnAhw/njOR063KQQ6b6M97ObMLL8tuI3Hf7xz+6+rSEyOt0Hb90LyRDCK7/1gKz2LDxY5jq8oXbXKtN5gQYNtmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=POK0yDXa; arc=fail smtp.client-ip=40.107.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="POK0yDXa"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QLRFmeZv6trhlSj6VcAR/C427U9J3Gj3qYUZzU4GF3e/VD5uNMGKO5/61qUPUjuBJranlIV1ypZQP/rsome+p+JDSJMWpEGQaNYTcolNblKGyb0ghjfEGkNCupYfkFlmuZhBFrB+DtOe/DszAWTW48zZlarBhjIYF9dhtI5I5CITepgy0vHVVGyD8LjVYJkkZG3EbHlEJYfd2GjfQ3JIaHCNGOvgEMBWGz7gjD2OHMunLEvMvh+YuAG2u9UtG9J9olKc1srFmGNnDtqMshmFVZPYSw+LnPc3mo2pnwG2/VCPm9cBUYneWSmL/ha+Tj9ITuitWnoFHwurONQ4Il/Ssg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IwgZe2x+1oxG19dWxTG3Nlb1KBjkFXZ/4cBvqE++qZg=;
 b=AIN7jIpatp9YUPVJyYP5e/giG37GjJkEbVpt2Vo+edIr/FUhlsV67ymP0E6c5bT87KZeZLQrX023V+IE3e0Qtdj8pOsFFsveGLYsdBccJsT9zPtf00o8wym5rgWmrBQPzjezAJHWu1OZyrmYUZ+WhtaC6xJyYgAR6UwxPXVAd0KBxVf/3LR0tbdZYPjS1ygAUqYUZn1zj6Pg372vvflX4ANa4ef6IFNZWqc19zYF/UDJV6vBkOTZoKCxLlcS1SQlzWfH0q1MiLJsh+3JDSY02QZYuFKWOTgI7WVBGtyMdCm6QkjeGjqksnJ5UsOoHQj19qeP+USyb9YwLFy9JW43RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwgZe2x+1oxG19dWxTG3Nlb1KBjkFXZ/4cBvqE++qZg=;
 b=POK0yDXalja6QKMEtlCqG6t3LXLesY8yjvAvSkh6JkRn9z1HVwPGzjRvheVL+zLeaC7PFYHmOD7TagWlJKQQeesti7F+Wq8whax1ObAzNMFAmQR/sdQUiuCwRSbWvKa3UFZJEUH+7jxw0epjp9/UXrSgIeh18gPCEuKWxT4ZxZDK78DYB/H+iY/bPUf2QZGj7/V0Dq9F1QIiuqU/JNeDhaUyBsQYlwjvWI31RsnLXD7vefaP3nerV/+jPPSyTGNvZTccdK4N+eqgo6xTGVI/jX7mBpbBMj6Ui4joLmMQt3ITgpOLyRT9J4/8mlgMCqYlmq0uzb8lWpAPIUtUd2HecQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by DM4PR12MB6615.namprd12.prod.outlook.com
 (2603:10b6:8:8d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Sat, 3 Oct
 2026 01:23:33 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0472.016; Sat, 3 Oct 2026
 01:23:33 +0000
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
Subject: [PATCH v8 5/9] iommu/arm-smmu-v3: Keep track in arm_smmu_invs if range invalidation is used
Date: Fri,  2 Oct 2026 22:23:24 -0300
Message-ID: <5-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v8-1eaaed5e0433+3d3d2d-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0159.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::14) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|DM4PR12MB6615:EE_
X-MS-Office365-Filtering-Correlation-Id: 605e8abf-5f1d-48b8-a03f-08df20ecf0cc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|23010399003|10067099003|11063799006|56012099006|3023799007|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info:
	ND0NTHiiM0235xpNIvwmByMEwelGj3D0Y93Y0p7Ph5j9WULT7YZktYY+eTDDzUvhswC0igekZbCTAbeWbrdqKnYBhuFchwrEHtUIB3rlBQ8cFuaUiYS2ndYiam3h4OEADSG/eYZOZYoxBjP/0hHmOxrCa6fHU15zmEihT/YyKcXtFtbxtJEXbGXkF6ilzWyvCIODG9FIRWJFY5xkvbpU+aXOH34RfHjq6wjfNhcP4p82s86ntQMfwS3lINR9sKTUlabU/iC+hjsR2tJ2baGvthxhYYiPtN9QGnk0vlmSla2/4iGIDJNG/Akeebg7E9PLPWW0SVC4ZJvG32UP+zHl8ba40MzgMLaC9068960wwO2UHpyjFbBPtEZrdnPdA1WXay9CDzU1zwmcThQQseN1mSLxmyLe/7TYMaWw+1mkFMNY9xvUAwXqXlye4QfjJB8xZo3e0I0pSYkH4xfnyX87V2+fIlcq5STDC9J9rOhGflS1ieJIi0hFEUFVYcqj4cy/jvGC7PtsFqKmd4BPn7NvvRjozzYAIE2yHGZoRS5AxQBcYX/wFKn1wxAEJnmTKYBczkaONgb877GgvHAgYUa3Qoz09vnO2MiZ+DAaIHek8JuVI+I+EX+zldBLNc51+kur2MHzpNu02OJOH/jcrX7zkub/GsOB73z/H9EF7DhgcmUqg4ZBQrfoHFSuhvZTYGx8xDWF/T9JQwCQOg7UxtAoIA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(23010399003)(10067099003)(11063799006)(56012099006)(3023799007)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Ko1BkijFiVcBqh8KCKV6GKFxpcm5q/GpWN35uwxgVbsqMLeCnz5bLfzLcKaR?=
 =?us-ascii?Q?Vh7ph9Y/pdJqeM+KAm3gLv7Jwe3gkgAVXVgTFKJyY0BcMa06h+iVX3aYdFjq?=
 =?us-ascii?Q?AXh574DA1wJd1raYo19lUadaQOFZ2Niq5BnbL7hWoBncruXgzgg8uKrec4Py?=
 =?us-ascii?Q?oJVpOShWdPgzQOAPx+CV7R78Um3NqqrNppmWjo8U46i/Ur1qxBNlRZbE1z0K?=
 =?us-ascii?Q?ouyKuMG6Hb773qqSerN78JQ5LnkBsjoobjSTU+4ooscvAzCBGFjZJDV6bgLF?=
 =?us-ascii?Q?d59pgHBnOJ4PoYerHk8+skR7XjPT/Cp1hztrYh/3pRQADra8p3mf5ZDRmgyy?=
 =?us-ascii?Q?m+BIx5wLcOxXhWyhoKXE0/FX6pEfM02k23G9hIOANVqXUemNnx9Pd28+rIp7?=
 =?us-ascii?Q?mXr02llTVUbwAyTUgKdsMzdZex7ZwwnhCO2G3myP8BA3ahBAIDtUX5kMNZ7C?=
 =?us-ascii?Q?r+nbrZ3W106R/03ggsVme8jURVdy5rmek+4eECxpN23xV2JeA8WfYy4/0Jtz?=
 =?us-ascii?Q?wilkcE6q7rkN856oSM9DnhH2cEyHIEKX3Ad/B+yVoe7K2BJujPk6A2tVWkA1?=
 =?us-ascii?Q?/Gyv+USCGO/NgiT6ZdxT/7yCLapAGjffM4M38f7XnZwKEB3KpRqQliE8t+F1?=
 =?us-ascii?Q?HdYyvO8AzWBDpCw/OND+UT3cyAiS4k03JTMrOdys2k9Ge3NBNvw3kKE+2EeJ?=
 =?us-ascii?Q?blOGdtgsfIi8KwkgSDMB/UYIQGP9P08F07MJt0eDTabtknPfzpSMJl4bjo/+?=
 =?us-ascii?Q?QvSP5BU58Hc1PndMupY/UHpVjrKEml2B0lEU6Kunx/3/vFz2oxZ0mfuXlYcv?=
 =?us-ascii?Q?Z16VblX2gOalo5EC2S36l3B+CZisGpHbAt4QE5Xw+zffaeXXY+4tKD6AP+a2?=
 =?us-ascii?Q?9gTHmAh00us99takkYlxk7iJ/LMduzwUhOLG6xM1+vSa2hilRxjc2tV2jLfs?=
 =?us-ascii?Q?c3/teSDWTbXeyudi26yE7C0nzlQMJtGswTST0VIajjebgcw7gn6ckO/jeTrr?=
 =?us-ascii?Q?FSjmGB9JmhirvpXfkiYulnNhvqLK/KRSoLmwJ7cIW2nRv0tmiSVNKaRmUxvj?=
 =?us-ascii?Q?B/w8ZFRlI/CRHKGLGnIvLspBiK/6kTfI6zUvP02SNWNbEheChQBMpbljJ04w?=
 =?us-ascii?Q?3fh2WyzkKmzW3Y1aIvRXMic0DlIc839BZsNwwV05bCsMG9dzxbW5apOPLCkg?=
 =?us-ascii?Q?D9NO0fWZK+Sw28CsUbu9WiN/U58WpTSJTY4+05qsKpHszdhhBjbjOAkNFPaW?=
 =?us-ascii?Q?E3u9/7RRUF6DKAzGvS85v6c3/vMmCnTO2KEmPL2L1roSnC0Kqg1dt1LadS4I?=
 =?us-ascii?Q?+NwlRoF1Pe+5BiXisnkt3KAxeYEKUs862Sq5EdPGnW/sY2+LT82jtZYeXPYL?=
 =?us-ascii?Q?wSfnprMs9PJs/5V3C0jjtaNEIBaTZuvHapEAIzYPmoRUOy9gzF4P35mXBXgT?=
 =?us-ascii?Q?DRdzu7fIBteF2IkYGj6xBSqHCqNYspp9OrhzDFB4V/vtY8glkf4MMRtm+gkr?=
 =?us-ascii?Q?BKWOqiya+yGmj53CkqwNhW0NLxaKzUnIWzt2jzSvCWU7ezPiMyQGBqzE1uwF?=
 =?us-ascii?Q?QG2R3SrAQD+Ht4C+7d9g4W69p3kKePMYuaVhZgXFizSGmUb2TgFC5HzyKVA5?=
 =?us-ascii?Q?xMqSepb80qWCaXUSpHjfIyVf/cR2kIZBp3rAlLHASlAsS/iMGPCMYmlHmnsH?=
 =?us-ascii?Q?M6kklSC0fjb4zZJjib1CTttWJgjNRNjtp6biToSZ2pD2fKhy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 605e8abf-5f1d-48b8-a03f-08df20ecf0cc
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2026 01:23:33.6485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hFsQKk+GMiX+u06EI4J5yGm4OadKmSwFUeE+st9Qv8OGeehGAsOEN03pLCBsVyiy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6615

Summarize if any of the inv entries will use range invalidation and if any
need ARM_SMMU_OPT_FULL_CONT_RANGE_INV. The next patch will use this to
avoid range invalidation pre-calculations unless the range commands will
be used.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 38 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 19 ++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +++
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index e52a7d95c919dc..5a4e45e1512589 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -24,7 +24,9 @@ struct arm_smmu_test_writer {
 static struct arm_smmu_ste bypass_ste;
 static struct arm_smmu_ste abort_ste;
 static struct arm_smmu_device smmu = {
-	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR
+	.features = ARM_SMMU_FEAT_STALLS | ARM_SMMU_FEAT_ATTR_TYPES_OVR |
+		    ARM_SMMU_FEAT_RANGE_INV,
+	.options = ARM_SMMU_OPT_FULL_CONT_RANGE_INV,
 };
 static struct mm_struct sva_mm = {
 	.pgd = (void *)0xdaedbeefdeadbeefULL,
@@ -645,6 +647,8 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 {
 	KUNIT_ASSERT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
+	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_range_inv);
 	while (num_invs--) {
 		KUNIT_EXPECT_EQ(test, invs->inv[num_invs].id, ids[num_invs]);
 		KUNIT_EXPECT_EQ(test, READ_ONCE(invs->inv[num_invs].users),
@@ -656,41 +660,41 @@ static void arm_smmu_v3_invs_test_verify(struct kunit *test,
 static struct arm_smmu_invs invs1 = {
 	.max_invs = 3,
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, },
-		 { .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
-		 { .type = INV_TYPE_ATS, .id = 3, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_S2_VMID_S1_CLEAR, .id = 1, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 3, }, },
 };
 
 static struct arm_smmu_invs invs2 = {
 	.max_invs = 3,
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 4, },
-		 { .type = INV_TYPE_ATS, .id = 5, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 4, },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, },
 };
 
 static struct arm_smmu_invs invs3 = {
 	.max_invs = 3,
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
-		 { .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
-		 { .type = INV_TYPE_ATS, .id = 6, }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_S2_VMID, .id = 1, }, /* duplicated */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 5, }, /* recover a trash */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 6, }, },
 };
 
 static struct arm_smmu_invs invs4 = {
 	.max_invs = 3,
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 1 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 1 }, },
 };
 
 static struct arm_smmu_invs invs5 = {
 	.max_invs = 3,
 	.num_invs = 3,
-	.inv = { { .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
-		 { .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
-		 { .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
+	.inv = { { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 2 },
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 10, .ssid = 3 }, /* duplicate */
+		 { .smmu = &smmu, .type = INV_TYPE_ATS, .id = 12, .ssid = 2 }, },
 };
 
 static void arm_smmu_v3_invs_test(struct kunit *test)
@@ -711,6 +715,8 @@ static void arm_smmu_v3_invs_test(struct kunit *test)
 	test_a = arm_smmu_invs_alloc(0);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, test_a);
 	KUNIT_EXPECT_EQ(test, test_a->num_invs, 0);
+	KUNIT_EXPECT_FALSE(test, test_a->has_range_inv);
+	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_range_inv);
 
 	/* Test1: merge invs1 (new array) */
 	test_b = arm_smmu_invs_merge(test_a, &invs1);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 777ec0e8cb0735..7a5f4b54f3066f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1059,6 +1059,19 @@ static inline int arm_smmu_invs_iter_next_cmp(struct arm_smmu_invs *invs_l,
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
+		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)
+			invs->has_full_cont_range_inv = true;
+	}
+}
+
 /**
  * arm_smmu_invs_for_each_cmp - Iterate over two sorted arrays computing for
  *                              arm_smmu_invs_merge() or arm_smmu_invs_unref()
@@ -1129,8 +1142,7 @@ struct arm_smmu_invs *arm_smmu_invs_merge(struct arm_smmu_invs *invs,
 		 */
 		if (new != new_invs->inv)
 			WARN_ON_ONCE(arm_smmu_inv_cmp(new - 1, new) == 1);
-		if (arm_smmu_inv_is_ats(new))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, new);
 		new++;
 	}
 
@@ -1240,8 +1252,7 @@ struct arm_smmu_invs *arm_smmu_invs_purge(struct arm_smmu_invs *invs)
 
 	arm_smmu_invs_for_each_entry(invs, i, inv) {
 		new_invs->inv[num_invs] = *inv;
-		if (arm_smmu_inv_is_ats(inv))
-			new_invs->has_ats = true;
+		arm_smmu_invs_update_caps(new_invs, inv);
 		num_invs++;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index d2dc787349e01c..8b71e6cc19f29d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -763,6 +763,9 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
+ * @has_full_cont_range_inv: flag if any entry's SMMU requires the CONT range
+ *                           invalidation workaround
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -792,6 +795,8 @@ struct arm_smmu_invs {
 	size_t num_trashes;
 	rwlock_t rwlock;
 	bool has_ats;
+	bool has_range_inv;
+	bool has_full_cont_range_inv;
 	struct rcu_head rcu;
 	struct arm_smmu_inv inv[] __counted_by(max_invs);
 };
-- 
2.43.0

