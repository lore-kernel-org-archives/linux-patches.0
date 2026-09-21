Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010024.outbound.protection.outlook.com [52.101.61.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA89477E2E;
	Mon, 21 Sep 2026 23:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.24
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790034948; cv=fail; b=nrxMG08tkLSX00X0h2JQhNoNDqf0WqErz+evY2b0SFytf//whkiGT6wsG/wj3Pjip5tkmGmwnkbRLN1v43zJDaFkxvZG9Hc5mmzF7ide2XRzQ9+E0BS5cnAB+crBEDIYoV2t/IaUv5s9Kouy8UmwYYdHH+2uehfx/yUJrNGyn8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790034948; c=relaxed/simple;
	bh=PsDKJbdBkps6gSG7ClQQQAHM8gMbbpCqKB90eUhDupw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=W5Kbqp41ihwKg64gxWis/1Z9Be2Bp01YEvZya4NT8L71DIVwqIevkvPYGsV6/5abqlQHBo1R3NccZ10k8c9f81mYIBV3zTg1PKqpiJ2h5bT+OKOsmKJs46V8jIbkcLfveGoH0j0Agzy+IbE5VDSEslF+5RO2gdrOBlMJlqrF+KA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pTfjcNuF; arc=fail smtp.client-ip=52.101.61.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pTfjcNuF"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nTD/pWRPz+MeX8NakpmsV1U4xvKs5gETFGtoeDtDk6SNBRPKzJrEwurZMwmfJtDGOLWUC4f2GeXwwjSdwVKLG0W494dUUtEoHslGBp/dvGgfUKfkR+D67EY6c29WmrUfKr4FAFp7xv+c3+iycS8D3VmCljkm1LOjIIR+WXZUxSQ0eXkKSMwYJswDhXTyj2tu3jHaTicTN08rsUDNXY120LyaVEMUfJSf4xTs6VKfbxOSsISXziXUybcdD8ezVpyi9GwOJCsBOMG/EW0FxiGBuVSvwDplEbyLssiqzE/Vgz3/XYT1ZE+IObotZLIoDQzov0aB9oF+ucC56ycSJNmvSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pkPHpaMYuNVxtkCCNC3zER+uTiKZ36xLD9LnIKht8n8=;
 b=p6Y7A0B25M0EjHXphdpaTq8fPGNysOCgA6LSgFRQoyvVT/DsIUE/lxyXy6UuzLm4mhQl3tbrD2YL/t5fIt9dbUna14J7W7aQI8byECpLixF7p+OZ2d2ZgqiMOe541L89PJtkrzYbzv5bGQGYBJrFbNwPGaIK2cjtlsGmlAkbzGorDX6jcoRUdZuSi61T+lApXFp/86ei5fyrTIr6SibCnkTjNHV2wn2ObyVO0F4FJAr30keM69Y49bvY1UZZ1gIeg40yFsmjTy12Hv7FzQmbyQzsxIgM5WuLFahxsQIT0SjwZjh/kL/xb/smIh/BHC1WJrpA6naKKb/eW7sUjFRcSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pkPHpaMYuNVxtkCCNC3zER+uTiKZ36xLD9LnIKht8n8=;
 b=pTfjcNuFSNK8cdrdzByKcCMLnqLZas8iqOwAAO+8yEk33g/ARFZq0MH31BSJl8BPKh3lzZa3uAxstMv0Rr0HnVuXWtU13wphCfd4jJU6lOm+Jk5Pyw5NtRfHEY/Up2jvH9ORAzitfNE4IbvlAj7QmU64TDWdkMMoNT7xQq04+8qgROjcF32PzVl1PLdNQ7FIAx8/06u5Bz+M6139TZvEZtBlJvuyyDSmQWTFn5Iq/3Kp8D1kKnLhAI3rkXQIwyTEtMLAIr7aMm4fjMUeeziyH4e+f4DIK7nwhKYgNVvcqTy5ymg0fV5bSlB9lckU5oOBjkf93j88dq1HpaT9Umnhew==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14) by CH0PR12MB8487.namprd12.prod.outlook.com
 (2603:10b6:610:18c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.13; Mon, 21 Sep
 2026 23:55:25 +0000
Received: from LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5]) by LY0PR12MB325698.namprd12.prod.outlook.com
 ([fe80::b65f:1548:5b35:e2b5%5]) with mapi id 15.21.0428.015; Mon, 21 Sep 2026
 23:55:25 +0000
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
Subject: [PATCH v7 5/9] iommu/arm-smmu-v3: Keep track in arm_smmu_invs if range invalidation is used
Date: Mon, 21 Sep 2026 20:55:13 -0300
Message-ID: <5-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
In-Reply-To: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA1PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:806:2cf::10) To LY0PR12MB325698.namprd12.prod.outlook.com
 (2603:10b6:408:3bb::14)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LY0PR12MB325698:EE_|CH0PR12MB8487:EE_
X-MS-Office365-Filtering-Correlation-Id: a77c6a32-54b4-4843-30e1-08df183bcc8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|1800799024|7416014|366016|10067099003|56012099006|11063799006|3023799007|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	TEbiq2i+jf9ouozhd4gBwYEbPYGrSTy8SRMfFUNHH5eZzOhwQSEMcGLh3GgTX9vyPzwfYnt9MT0g3oYwV1ThS6bMIqNwM7pPZzsioVsOcBy7PE3ywhiBJmdIe8/qELzEYR11aXSvuUFPzhM4oAkVLpB+xO/ECt/EUdW0F5ijuGe2c9muFylWRSOBb/Eb9jfuL8aD7bUZTe5zOVVM2ah6QU5ZIgJR/ScJLRnSDR4FtvMpDvPy5u//fgsyyXDInfGnulrbLCxijGikSI8OaI8Vys37C6f6GI+qDzIGlDUgrWo9wF0w0qwbeNmrgH9Wqx0defbn0Hb6rTKmSgh5kQ+oSP7+M3GjNhxG4sDTk7sDjw+5EFMc6UJmSmudDMRhAOTNGnwttfArN1yv7ypi8onr6JzaPNv/pgRPE54iWaxhZ7TA5DMxrEoH9mc4wHr18GHCFLAoxVDvO4XHGY/uOdBO1PRgb9J0AUDPm2HoQ575+zWPV85YD7DopXaOz57Scx2HzrakIan+AkfmW248m79LDO3DEYud2muyQ55mAlIjSSlBHNivo/s25vE7kNO6gq+nCBC34WSgp2ZhGRWmGrinXfeTlZQOzLe9B67tg8ODfpDOYwKUxZqxRs+cDiKwoYBOGUDF/cyIoYURgoQJKSa8ULccyLNQ0tHb87dJ4xg98O45/vG3cDJGBZcijZKDdXMuU12ZSHbSNmdJll6zi+ngEQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LY0PR12MB325698.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(7416014)(366016)(10067099003)(56012099006)(11063799006)(3023799007)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?EHZ8w0mWijTlwOModmkjQaeQVMUf6x+lmJ3rCwzL3hAyxBjDPAzMNL8EpU7n?=
 =?us-ascii?Q?r10uSGf21CEOpSK0JYsWpJRjzxza3ABSKIioKMQrIf9PrlWlwpASE8JjncOQ?=
 =?us-ascii?Q?Vu5E4OQeugF1E3QEPQPagDt+DfBn5IhVquWURF2rrpmfD7MUsbn/nfz7rcEx?=
 =?us-ascii?Q?IMFrP43xCAfZsTfPd/uzCWBc0Xvfj2f6SYt6OBnncUbipk8NZL9vbhGs1LbS?=
 =?us-ascii?Q?R3lPNsH7Oee8n2vdDn2qRBIRFCf5gFCVhgwk3uSZ9BlePFLCuJkZtX+7uQA8?=
 =?us-ascii?Q?69ItBNUN5z/ODd5K76c9ySYgedC/qwQHJeUmdaLutN/5nBOky4pYm5qOhEkf?=
 =?us-ascii?Q?vA5OgcFup1zYZ8egv7gyG4As5w0TcPfsMQaDpY0I9T2lebHehgHP9aTR40pc?=
 =?us-ascii?Q?3l8EVBc5OKjWo1nFIb1/vMnbb6Vbi31/Ah89LoKHPRvq/F2XJcBsdiAhmAF4?=
 =?us-ascii?Q?xlTeCnOEA/h5wVDBDSAh2MTxrYc+z1ddiQEeZ7dUnxfMr5VnOKEfGpYIjOzw?=
 =?us-ascii?Q?WInTuAcOM619mRU3ejJo86ojzcP933Q+khWmouKSidd3mdxwaXBU7zSemEPb?=
 =?us-ascii?Q?gY8zyEdKnDvf4Sigtyg6ZDfGICv6CIhpEOGcNDm46Vgxdlq5GYSKM+G2LW2l?=
 =?us-ascii?Q?7H23gr+O6burW0fFNz3IaCevUHD7Ywari7H3yglgJuAfvNsShUS//f70DI4T?=
 =?us-ascii?Q?utZWtIq8w3bBtytv296HD4lwSrrxTTe1HQJkJB3o7OAdsHIW2tiqeupr4Jtv?=
 =?us-ascii?Q?iQhCEwbmPDIpgpd5eQBOvM8IFUuwBJTRi7ksf5RvO/Yet2z6ktbJIuUXVQ1C?=
 =?us-ascii?Q?AisPrxpnKaAn4oLOB7bQYm10zCvikqk4l9PQSzgZBvrYwcae2Hb+sKlG624k?=
 =?us-ascii?Q?TcNm7gCPvnvoBazlU7Bq5fC9vsEmVVqpbx8TqW2bft11o2gyLgDVv2UcUHsp?=
 =?us-ascii?Q?ONieGdIkA2hnsHmdwcIg/eftqLIU/iL9k1ZcikOk1O32AI4Btou9PxYhXAnb?=
 =?us-ascii?Q?P/ainGKDa9JaueZQqdem5AT+F7+V98Cy7UdEvuLCz6F7OEV0VkKjjXsdKUuZ?=
 =?us-ascii?Q?saxXG1qZjRyix1UZuhWPotVIoHIGc2iHMaMXbtLxGuPbpm6NXzJQ4Yuk86/8?=
 =?us-ascii?Q?oke8mb0gII7vpojoOut0qIDMZ/oT7xj8t4cVOvAJOHPQ84EjfjwduBXwRj4k?=
 =?us-ascii?Q?3MsF/8BOyKT23N5792TMpYAzKJjf3SjaG++81UlVDKb2895sp6cnIXuPaJNg?=
 =?us-ascii?Q?NvslPbA69qnNl8P1M8+dzCH7C1Bk37eGk1mKRlPAtJTMuVHo0Y5CWQ93wEFt?=
 =?us-ascii?Q?gkeXkKGAS2pG/5JqTIYAIj3DFbvajhrbo0+nQZ4LZ+AOXEs4FkXSO0xjDOQq?=
 =?us-ascii?Q?Oke1Qoq4BM6DvtmGxiYeob6j1iQQSyMMXQPTyaMihdW62nnwJkzAoo/f7Hal?=
 =?us-ascii?Q?uiMwSDmp2YVu/cQ0MRoGaWnKc0hNumlTiO4lt269OZjB8UuKCfspEOy7oZzh?=
 =?us-ascii?Q?NOIWf6pnzi72bqLJhk2leRXeXf2Mv3j4drbwdwXo0x6wmNRRncLO96nu4h3m?=
 =?us-ascii?Q?pgwWpDQFbds68Wb53wXvM6GQWEw2Z+ecq0mlXPzXgTdWB/1YwoUMmDw+Q7Dk?=
 =?us-ascii?Q?uYo39tuXgRBlEYo5xm4OsHaeNtYfwLJzsjDpjOE1Pnzm7HllB+1Zfzi5S48X?=
 =?us-ascii?Q?TBBkeIZU+GwpDvSE3YU9auQMXqXRc8EFrIQHCnjq5UrPOB/5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a77c6a32-54b4-4843-30e1-08df183bcc8e
X-MS-Exchange-CrossTenant-AuthSource: LY0PR12MB325698.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 23:55:22.5485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oP1Rsh172/DTYs2SNay593x/90QlnkbdqpvrEp1af5s5E6bqA5p8K+K5J9GQO5ek
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8487

Summarize if any of the inv entries will use range invalidation and if any
need ARM_SMMU_OPT_FULL_CONT_RANGE_INV. The next patch will use this to
avoid range invalidation pre-calculations unless the range commands will
be used.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 38 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 19 ++++++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 +++
 3 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index add671363c828c..81ceaf97b88c07 100644
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
 	KUNIT_EXPECT_EQ(test, invs->num_invs, num_invs);
 	KUNIT_EXPECT_EQ(test, invs->num_trashes, num_trashes);
+	KUNIT_EXPECT_TRUE(test, invs->has_range_inv);
+	KUNIT_EXPECT_TRUE(test, invs->has_full_cont_range_inv);
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
+	KUNIT_EXPECT_FALSE(test, test_a->has_full_cont_range_inv);
 
 	/* Test1: merge invs1 (new array) */
 	test_b = arm_smmu_invs_merge(test_a, &invs1);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 5daebe06556c44..703a4ce562eecd 100644
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
+		if (inv->smmu->options & ARM_SMMU_OPT_FULL_CONT_RANGE_INV)
+			invs->has_full_cont_range_inv = true;
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
index 2717bf2f3f3607..748becd41160c6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -758,6 +758,9 @@ static inline bool arm_smmu_inv_is_ats(const struct arm_smmu_inv *inv)
  *               Must not be greater than @num_invs
  * @rwlock: optional rwlock to fence ATS operations
  * @has_ats: flag if the array contains an INV_TYPE_ATS or INV_TYPE_ATS_FULL
+ * @has_range_inv: flag if any entry's SMMU supports range invalidation
+ * @has_full_cont_range_inv: flag if any entry's SMMU requires the CONT range
+ *                           invalidation workaround
  * @rcu: rcu head for kfree_rcu()
  * @inv: flexible invalidation array
  *
@@ -787,6 +790,8 @@ struct arm_smmu_invs {
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

