Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2043.outbound.protection.outlook.com [40.107.93.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C61EA32;
	Tue,  4 Jun 2024 00:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717460176; cv=fail; b=uh52Vwjfx+EfTNDmSPYXDSg+U4hRBox1rrirZDP5jzXEtRBLaSZH70sEIs5o5sJsIDLT6Hcr+mW9sNNxtvxD9etF14uYbw+BbMXKlXXmfutIsUXqrTIqqBC98mBCL3yrDm1HDrcTwzttuyuydWrMkCm7ODSKZVRb+Fh8pCTMAvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717460176; c=relaxed/simple;
	bh=D0zuZfMep735qoTzV6NJe6pTjZaHiMc4WUr5tLYCp0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ujBg+MhT6WbuJ8i5jHyB9MnBR8AUsQMhctSyzuwUme8J1E7ECCZ7H0a4qi+Hj/eGXd9RZIq1GL8mxQJnS+ZGtqf5aN/kpdPBAThYKhlkPXUERcyNPcUuDA26ALlY0FnPTv6RfcQtOAkohFTP/XtgyStA5WoX/J0O0ZxH4SkbNvQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T1YmO/Ty; arc=fail smtp.client-ip=40.107.93.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T1YmO/Ty"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cTyWmc4v0oct8nDYnhiyHUoOC/nJH9V8CoM6XwY2ex8Jm9lea+ZXHHTzfdqrnHto9wmMnrLvTdb0ocEXSPJd47szy1nPaqm94b8jn0EqlbX0Xj6O/MqvSjCM0nZFjXi5uNasB7KHHpOUA3OBTUbpestb7h7KyOX689w7B8+KQ1hnZYSSiynU/XJo3Kt7db/dvWpYi+4kqVHe2hNitx5cDs90CTqdqVcAj1h80fEt+NOV5a+8QI7iqqu00YJkC8Oi52HPwZc9ouBWy9rD/KkubTiMPDOuBEoHcR4pvnBCcdpI7sKwf4cGRD7l0TgxVD6uWF6toxTa4RoCr0acZmELgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6AlqI4tMSD8sTiY4rQTFvp3rNKpaA+uSeIf7pGRpoZo=;
 b=BhPmlrRXatNJ44PP7sAAqJorJczOzP9UVyj0grTP88ndjefuhlW+zKroNB0+GEotbCwmj7XgwgObdqSt/mhYbdHx3GXkIazW/+DurPOM4fWMH8nn3aLJKHyqBgY9VAv706GTItcfXpDSVHhP6/rcgJ5v6fKCix6G4XEpXAJYF9YQwgpiR7Z0ryfu+/N9goa695EhYrp26AH8Rgr6D5A/E5ggDovAJplGpaLudMaHHT3YcvdUengJYbeVPWK/j1JQLq8wue87yTskSwWiFI1FUbD/mxYJ2ZAya6ZCysWk42JfnhO/YGAYX49PhiL5PT3ulP94qVCboaTbHwXTHqgJdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6AlqI4tMSD8sTiY4rQTFvp3rNKpaA+uSeIf7pGRpoZo=;
 b=T1YmO/TyjKD5kUX3dRXEJUoTnsPwnZrvh0WwLI2ZmEKimEMwhtRxIBpg80MUYXWqZY2F2bv/hZTuuR5psYbZN7d/GszEkFmUIcrP6urfyo8cugpYv0lBipk2hQUoApEY7mDvJyw7vBhOH1lg9uV6V2tpkoUzdp0NSuYs0wIhohOoe5dnn/x7p88aCHk5BuF9ZzaNZSKJiluNvHAxdo3Hng8luknme7juiXEnn11V+tblbABDrNvA+CWYk/v4PdYQNgXjZ8cmCwqQJRF4YhhZYCeV4E5xPP7ZLQRRo/QU3QPVo9VA4GOgjlj01j0Hu+T1l9zhw5PShe+9pCeA/+5Wcg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN0PR12MB6296.namprd12.prod.outlook.com (2603:10b6:208:3d3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Tue, 4 Jun
 2024 00:16:05 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 00:16:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v8 12/14] iommu/arm-smmu-v3: Test the STE S1DSS functionality
Date: Mon,  3 Jun 2024 21:15:57 -0300
Message-ID: <12-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
In-Reply-To: <0-v8-6f85cdc10ce7+563e-smmuv3_newapi_p2b_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0004.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::9) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN0PR12MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: eb006444-4b9d-4d38-dcde-08dc842b84d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+XpzGMEnUWz8VCjn97UMh/TGclu6/l6AsIiW8fpyw1Rpa4rKxUYthW9p8mB3?=
 =?us-ascii?Q?08+ymr3Es7uGKEPrh+S0aOsRnwHGmbMH0fft1sktizNT2rpUlteGSuVeoNbD?=
 =?us-ascii?Q?qEUjz6r5686NCl/+XxuvFpurRlW++5ijFkgPV3x0mD5aNeYc0wVQ8sg8JbwY?=
 =?us-ascii?Q?Nsasq7gYathxC8XzXJsOFeMDBkb8gP/g90gmF6x1uKu/d1GVnVmcwp44Lflg?=
 =?us-ascii?Q?r0JpjfLXQejMGxf21tkGLHHVTMicrCevfywy7VrJJdfI9cwNiqKyBC2tdWdZ?=
 =?us-ascii?Q?uaY3qpzjQAPYGKVgT6ArXyDHwvsamSVk5Cpuyl5AbKmz3GtTF6gAqxHQJKYR?=
 =?us-ascii?Q?qaaLlq6pppKCSeCd+MnX4hjMD6Io37EZHyUJb/dJHlKhDguSfcMe7HwCQ30E?=
 =?us-ascii?Q?a2U2BJNVgue2mj7f6Oi/WlxvysCnnXKfF1fJZMGTGUcM/UhFbeqpwgYoP/jy?=
 =?us-ascii?Q?VKVdrPBqdE4O9gkoLyyZ36SRGjCC7fStmfOTzj3WG7MZM3xkfQ+u/QDhN3/m?=
 =?us-ascii?Q?bY5wrzMcjVxiJSEIWr5O5Y8lm2vRJtDIKnpwd0Lf7pSaSPaGlmTMArF2HYDy?=
 =?us-ascii?Q?qlZRWBwQTCxfvs57Kb+w9nI3SdbTAROLYSmIbiGpFT9ouOgeU07YPG6l2lHb?=
 =?us-ascii?Q?O0FnymzGsYPK6NF19jrXdzXmsVW15LBRfSUz8NZ0hzqC9i+jbwnt+MVkMmUm?=
 =?us-ascii?Q?e+pBwsMR49MgiXlAXRBodhzjXwXxmOB6oITzyGnwvpaTzH2nh2Iq3oowqxSe?=
 =?us-ascii?Q?46KVAbL58su+bHOMPhZA43cNSrWPPg7UcUXSFKw5JtNOgGBtjM21yCIWvUxH?=
 =?us-ascii?Q?AxewJn+wK920A+WvtGmMoKFq7yZwf6MB1Rygwzg3AWhiTsSf8gm0HKijROSc?=
 =?us-ascii?Q?FIsJ1O7sY90poDlAFLFWX4EoxrAbLVJZth725XhEqjZFq7HpeIfmGDCJCROq?=
 =?us-ascii?Q?LKWhHDsBOAg102tAJqA48fAQ+sVSPxhLNkSQV4rR64gahJVnB5D1zZvERlFz?=
 =?us-ascii?Q?gTiewhQp9W/wLcYXdfDCD9hr45Eu6755bYI8+Uh72lfZUxu2kbyCTWgt0sDl?=
 =?us-ascii?Q?IOs/3Jdab0wYIeZ8ThEhdU11mqeqOtodSdIvSAqZ7yjGloLNBKly3GdkiT5B?=
 =?us-ascii?Q?Qg7lAvB2oDeRbPzCcv/lLC0I8P6UNcseq77Xiu/cvtlm4dwRD5ZhmRk8bore?=
 =?us-ascii?Q?vT6iC0M95xHpey6zafBc2bubeyV6MYXAYBZYlS1j63kt7NDZ4CzfRBG6apcz?=
 =?us-ascii?Q?H7l5WZuoKPzGCDyEOtwnlq9u3GOdbt2R5/1HmOKgww=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DL37Pu+GZSMGtSVRGnsMCztSycs1aIbnjSuYMXmUQiOAAOqnD8d7KTd00qDJ?=
 =?us-ascii?Q?5fFTvlY42b4FAwYkjwraFA86EbAFmOzSlMHYH6j8dSeNxJVVvPuJj84jGEoE?=
 =?us-ascii?Q?dNwbhlVPLkhGEVxTj6TGva9Rjh8ulKf6H3glo6p25Wbh/E5PorP+BPrFk0sF?=
 =?us-ascii?Q?R5NMLe/QAWehSm+wYajQyP+lz+qHrb5mMq//MaHmBnwn+gzPBghYpKhKkYvs?=
 =?us-ascii?Q?TJIUaGqZNs2hR97E4zBP9YcmkyNKca8MHF+RjuJz1G+i7gSCyMuFNbbe3ja7?=
 =?us-ascii?Q?DNMYwafeIU+JSv4B28k3TNao+wViBXI14XNl4+JdipJj9iZRQ13PDJzt4G1g?=
 =?us-ascii?Q?y1TyvLL0rX49L+SL3ZGPV73ycQy6pa8oauwN9DCllIID5YSOjTgTNylTtpS8?=
 =?us-ascii?Q?jGpgq+xMEMswz+k8qILZDWxG1FeBwLfmJTNTB9Ka7t0CCvFmfaxFtltmcpGq?=
 =?us-ascii?Q?4ZGeoF2NNwdu4f5UpjCKfu15IWYbMpyqOdaWHA4OE/EPRoCf3+vmtyzJFGuK?=
 =?us-ascii?Q?NLpxR3vdxiDHNGd1gVwVRyzuABVmb9J32/aa1ANUpyX/5aXwvv6z3pAbWjQJ?=
 =?us-ascii?Q?lN7TqUayxklz7wnudvWQzDHR5NVaveTy0tLx0FSck4RcN/6rbWZldMS2V2XM?=
 =?us-ascii?Q?2qJw/m+He1+s5L33VbAEvFELGscndR5/euBtXZtHmq9Hbo4OMKbkZPUU/tXF?=
 =?us-ascii?Q?o5lg7i9HZhG8vQtXmqZOPoe6adiqP4R233yzBwrr2wNQuWYCTjoTfEUVFA2z?=
 =?us-ascii?Q?tv+5WLt2BRUXdHpThhYMA8RVPo1gvAW3KaUOcL9pwVtwUToWgU1+UW6FkiRN?=
 =?us-ascii?Q?lpKz/7cODkNuj6wilApKXAYQ2fpWk6FPtXDRorkRavdhCyyGiAW35nnhQHg9?=
 =?us-ascii?Q?bfvFujJf9amrUbYBT/lxV5MofG3qjjIsTlMWaXeb5/XLB5VAWATyaUW96lGq?=
 =?us-ascii?Q?L211TmK3755hx17fMY/CKvxxb3DwWJPpFlGYYdbCVTIqW/fJPG5AUQfnlzWv?=
 =?us-ascii?Q?CI+Jv0JUDfuJ/BbTOKcH/0pipcQr6lRb325yHGLbOblaxmy3DCxFr4kHPDI/?=
 =?us-ascii?Q?/YW8aRSrGc+cZjhVadUsG+Z35/a0sung1SOCD73MlijbglKHMOd4WGLbQVEd?=
 =?us-ascii?Q?RTrEkvoBUk/jtqiC7ts/09NY1ct+Tef87ehR2oQO13YLlaXHt9IeYk6pl/az?=
 =?us-ascii?Q?ah/WgFRoHpm2l8IhyFgMKKnk5DWmmo8+3MKkJFaooqi9YskvUhEsJ0tUNaBT?=
 =?us-ascii?Q?rUzkl3FtM/mxKVrQqJfaC+I632v4xZ0t7PyXw3qnE28HxAmnYH9wsDhENAe7?=
 =?us-ascii?Q?tNtzMKySDnARhP5X/EQnPcEBzTNnHxSn6okfxpgNAohbpIBCf3Tfea+/R2ls?=
 =?us-ascii?Q?kBn0Wl3mMhzxwD6ZPQa6i9Lzw5UE3nlGKcsKOtNUveG0y2WFcBTKL8d8Zd4k?=
 =?us-ascii?Q?76YgGSThaPrEFFmuhKsElAKobQvsGPU5jXAGgUGPJxCLl8uef2NwDf6Y1mF7?=
 =?us-ascii?Q?VkC+XV4KyRp1k9sJr4vfthEPJhxMIDmU+BMWpBelcpmQPinhA5qL6wHCgLV/?=
 =?us-ascii?Q?K4CfmzT1BGzTHVnRZAo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb006444-4b9d-4d38-dcde-08dc842b84d3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 00:16:02.8352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSOQs9wUaFusGRR7iFccNYaq4l/j0xJMFEzCxJqwaQCjt7ujLxh/LEypsxT3ZzGh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6296

S1DSS brings in quite a few new transition pairs that are
interesting. Test to/from S1DSS_BYPASS <-> S1DSS_SSID0, and
BYPASS <-> S1DSS_SSID0.

Test a contrived non-hitless flow to make sure that the logic works.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c  | 113 +++++++++++++++++-
 1 file changed, 108 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
index d7e022bb9df530..e0fce31eba54dd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c
@@ -144,6 +144,14 @@ static void arm_smmu_v3_test_ste_expect_transition(
 	KUNIT_EXPECT_MEMEQ(test, target->data, cur_copy.data, sizeof(cur_copy));
 }
 
+static void arm_smmu_v3_test_ste_expect_non_hitless_transition(
+	struct kunit *test, const struct arm_smmu_ste *cur,
+	const struct arm_smmu_ste *target, unsigned int num_syncs_expected)
+{
+	arm_smmu_v3_test_ste_expect_transition(test, cur, target,
+					       num_syncs_expected, false);
+}
+
 static void arm_smmu_v3_test_ste_expect_hitless_transition(
 	struct kunit *test, const struct arm_smmu_ste *cur,
 	const struct arm_smmu_ste *target, unsigned int num_syncs_expected)
@@ -155,6 +163,7 @@ static void arm_smmu_v3_test_ste_expect_hitless_transition(
 static const dma_addr_t fake_cdtab_dma_addr = 0xF0F0F0F0F0F0;
 
 static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
+					   unsigned int s1dss,
 					   const dma_addr_t dma_addr)
 {
 	struct arm_smmu_master master = {
@@ -164,7 +173,7 @@ static void arm_smmu_test_make_cdtable_ste(struct arm_smmu_ste *ste,
 		.smmu = &smmu,
 	};
 
-	arm_smmu_make_cdtable_ste(ste, &master, true, STRTAB_STE_1_S1DSS_SSID0);
+	arm_smmu_make_cdtable_ste(ste, &master, true, s1dss);
 }
 
 static void arm_smmu_v3_write_ste_test_bypass_to_abort(struct kunit *test)
@@ -194,7 +203,8 @@ static void arm_smmu_v3_write_ste_test_cdtable_to_abort(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &abort_ste,
 						       NUM_EXPECTED_SYNCS(2));
 }
@@ -203,7 +213,8 @@ static void arm_smmu_v3_write_ste_test_abort_to_cdtable(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &abort_ste, &ste,
 						       NUM_EXPECTED_SYNCS(2));
 }
@@ -212,7 +223,8 @@ static void arm_smmu_v3_write_ste_test_cdtable_to_bypass(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &ste, &bypass_ste,
 						       NUM_EXPECTED_SYNCS(3));
 }
@@ -221,11 +233,54 @@ static void arm_smmu_v3_write_ste_test_bypass_to_cdtable(struct kunit *test)
 {
 	struct arm_smmu_ste ste;
 
-	arm_smmu_test_make_cdtable_ste(&ste, fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
 	arm_smmu_v3_test_ste_expect_hitless_transition(test, &bypass_ste, &ste,
 						       NUM_EXPECTED_SYNCS(3));
 }
 
+static void arm_smmu_v3_write_ste_test_cdtable_s1dss_change(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+	struct arm_smmu_ste s1dss_bypass;
+
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&s1dss_bypass, STRTAB_STE_1_S1DSS_BYPASS,
+				       fake_cdtab_dma_addr);
+
+	/*
+	 * Flipping s1dss on a CD table STE only involves changes to the second
+	 * qword of an STE and can be done in a single write.
+	 */
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &ste, &s1dss_bypass, NUM_EXPECTED_SYNCS(1));
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &s1dss_bypass, &ste, NUM_EXPECTED_SYNCS(1));
+}
+
+static void
+arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass(struct kunit *test)
+{
+	struct arm_smmu_ste s1dss_bypass;
+
+	arm_smmu_test_make_cdtable_ste(&s1dss_bypass, STRTAB_STE_1_S1DSS_BYPASS,
+				       fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &s1dss_bypass, &bypass_ste, NUM_EXPECTED_SYNCS(2));
+}
+
+static void
+arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass(struct kunit *test)
+{
+	struct arm_smmu_ste s1dss_bypass;
+
+	arm_smmu_test_make_cdtable_ste(&s1dss_bypass, STRTAB_STE_1_S1DSS_BYPASS,
+				       fake_cdtab_dma_addr);
+	arm_smmu_v3_test_ste_expect_hitless_transition(
+		test, &bypass_ste, &s1dss_bypass, NUM_EXPECTED_SYNCS(2));
+}
+
 static void arm_smmu_test_make_s2_ste(struct arm_smmu_ste *ste,
 				      bool ats_enabled)
 {
@@ -285,6 +340,48 @@ static void arm_smmu_v3_write_ste_test_bypass_to_s2(struct kunit *test)
 						       NUM_EXPECTED_SYNCS(2));
 }
 
+static void arm_smmu_v3_write_ste_test_s1_to_s2(struct kunit *test)
+{
+	struct arm_smmu_ste s1_ste;
+	struct arm_smmu_ste s2_ste;
+
+	arm_smmu_test_make_cdtable_ste(&s1_ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_s2_ste(&s2_ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &s1_ste, &s2_ste,
+						       NUM_EXPECTED_SYNCS(3));
+}
+
+static void arm_smmu_v3_write_ste_test_s2_to_s1(struct kunit *test)
+{
+	struct arm_smmu_ste s1_ste;
+	struct arm_smmu_ste s2_ste;
+
+	arm_smmu_test_make_cdtable_ste(&s1_ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_s2_ste(&s2_ste, true);
+	arm_smmu_v3_test_ste_expect_hitless_transition(test, &s2_ste, &s1_ste,
+						       NUM_EXPECTED_SYNCS(3));
+}
+
+static void arm_smmu_v3_write_ste_test_non_hitless(struct kunit *test)
+{
+	struct arm_smmu_ste ste;
+	struct arm_smmu_ste ste_2;
+
+	/*
+	 * Although no flow resembles this in practice, one way to force an STE
+	 * update to be non-hitless is to change its CD table pointer as well as
+	 * s1 dss field in the same update.
+	 */
+	arm_smmu_test_make_cdtable_ste(&ste, STRTAB_STE_1_S1DSS_SSID0,
+				       fake_cdtab_dma_addr);
+	arm_smmu_test_make_cdtable_ste(&ste_2, STRTAB_STE_1_S1DSS_BYPASS,
+				       0x4B4B4b4B4B);
+	arm_smmu_v3_test_ste_expect_non_hitless_transition(
+		test, &ste, &ste_2, NUM_EXPECTED_SYNCS(3));
+}
+
 static void arm_smmu_v3_test_cd_expect_transition(
 	struct kunit *test, const struct arm_smmu_cd *cur,
 	const struct arm_smmu_cd *target, unsigned int num_syncs_expected,
@@ -438,10 +535,16 @@ static struct kunit_case arm_smmu_v3_test_cases[] = {
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_cdtable),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_to_bypass),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_cdtable),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_cdtable_s1dss_change),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s1dssbypass_to_stebypass),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_stebypass_to_s1dssbypass),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_abort),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_abort_to_s2),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_bypass),
 	KUNIT_CASE(arm_smmu_v3_write_ste_test_bypass_to_s2),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s1_to_s2),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_s2_to_s1),
+	KUNIT_CASE(arm_smmu_v3_write_ste_test_non_hitless),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_clear),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_s1_change_asid),
 	KUNIT_CASE(arm_smmu_v3_write_cd_test_sva_clear),
-- 
2.45.2

