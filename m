Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE18134751;
	Tue, 23 Apr 2024 13:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713878071; cv=fail; b=QIgTNIYV9hSffDPPtYEEts1kpQ6SMxrITTcUa+3gKEPNHZrJMVDf7O4Ei1n7nPTqPb6jvTRlISblVYc5hixCfmITBqEAH8cWCFXSFLAVVSiYKddBeHRVI5R3KrqT3VuCfBPbP2dsrd4mMf1zxn7ABlR6I4HD02Cyq4nji0obK2A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713878071; c=relaxed/simple;
	bh=YwcM35b4CppivsMz/N6q8PT43B+8cjh2B846YZrVTEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jt1HJ4ee6oIzubP1L3S1hf4HVbK3u/cmFjbo++rv7d244GkQfIUp0cuHv0BoCBrX2ZNM9Z5t+tp1JY1YJoi2qbfSwTKmZGvRbM4PWqv/+NQcbW02Ri2HhO2o+S+1cHNKmzoZDUVZcD1hbKNug5tBk1sxa6QpU5oU3Pz1xfVmCtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=oMnFOqm7; arc=fail smtp.client-ip=40.107.244.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="oMnFOqm7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LcWdo6+FYrNTwk2lhKIcZ6DWVXdOqbRyLwfUZwpAPepV/o686NTlQ7mIgS+YIYlpJtWG1ZGSqoyPfKD5MXDlqhKRdCBsESZlMWNIIeynkCU/gGPRA7EEfCMS9SQLTIuDx0onaG0TxwRk5mQueDHvP/BVOlVXaAK258BBs3NzjBdeU3j3I8qiMx0lAu5q3do3GYQJMJN8u/lunCFHHmTtp0tj6YU4P/cr60AccSXJjFwBdUpvpzANAx+9T2fqO7niqpU3JIMRG2S6poT8ZxNDO0iYhcLbn99Pb9OQ+jzOvyIOtk1XaGxVLgcJVcu26VKGB/rSWUw2OzDRgPqylrmnOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P9Gc0ljTfkZiDfNYJqusXC0QJBdqdT4d4ljYV+FyCtw=;
 b=HRE14Fzq/zWksYpypY2qKuEWckv6vQZRNXyEXaFSuM3Y3gYYlFWJJvy+DnDh4CfPp7Cuxm0GLOZn6Q7m1aRfeIdYAr02secJV7rrdHGRD+vabew//ZHzwqPCMyiI5Tc+9n6cn88oP5ejXdBWjDwXppkMbGX3/hu8ucZgg0WDXn9fVSPomTLtLqNdSdvY7B/P5OZixM7mz+EJ2Us44uAV2aOrmwddt6cZ10JOKBhAZ6TiTBvE3gRhmL7sgWFI92sXxswR83bA68hgwkl3F/SBVDgdEPefW719KxFdoJjSjX77rg39KHdvCvTDiJrdwjWscEca4mey4RIjAlLAb5T95Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P9Gc0ljTfkZiDfNYJqusXC0QJBdqdT4d4ljYV+FyCtw=;
 b=oMnFOqm74eTJ3vMRract2uKTd2nLuQOei6j5eCyouPFcL2TGaabZvh1UQIAV8X7NPFxeutHJ9qbobFXHcnVBEvgS8SUzSrgn++bZJuBv0uB+4dQb2Q9JmTc5o5o4GoVEGEUmrs7aETFYh9CKW8KCebwLR79wCQ75iTyO+gW/g96Opq3ENXQ/sIA6dVOlcP3GqPCim3UuQ4UjkDYYNV3ROQmAnjamgy4ew8y2TIzeTiWxTJ1LdZq2KtTgdCnPpfHyMjWTpa6J2kM+i0ISaD6gMjzs2T92h56BfIzDE+COnjVJE8fh/4XIvVxg5fF5vaQlAOPAUCLd2tPwwYcsAvIkCg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BL3PR12MB6593.namprd12.prod.outlook.com (2603:10b6:208:38c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 13:14:19 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 13:14:19 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v8 8/9] iommu/arm-smmu-v3: Build the whole CD in arm_smmu_make_s1_cd()
Date: Tue, 23 Apr 2024 10:14:13 -0300
Message-ID: <8-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v8-4c4298c63951+13484-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0380.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BL3PR12MB6593:EE_
X-MS-Office365-Filtering-Correlation-Id: 53bd938a-04eb-4d09-5e35-08dc63974668
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fAN1eb2OKhmiddXAPYSyhmriJvgDpC+OkgK1m3V8Ut9JyDDoMlax8F+z6/0z?=
 =?us-ascii?Q?pSsfgRG1nV3WXJPeprhYx7TzsikPDUDSumkDxod1JjBEvG1vD8OtZbVsHUw4?=
 =?us-ascii?Q?zfsRhSyY0B9jDFmGJCCBwtS3DzcNVndGSMCUeEQNsrHryB+Y5LtQL0uVQ/s2?=
 =?us-ascii?Q?8vilVTBuazm33s+qe1l80elR5CbZo/+HedCXvVfNAhspFdDCSs9yHh4wvRAM?=
 =?us-ascii?Q?zRcnyLm+PRR9obHSdq3VizwrtaxaFst2ZHdhf60D7vjveiKyZPSkaajwwyQk?=
 =?us-ascii?Q?HwxwFxVwhM4sQoDSKGXTbhsxVvlOZjYoNnj6V0dDwOLBprvZKcZ2+92bk690?=
 =?us-ascii?Q?3fUs/3YemYyzv0QZx/6CrRTF7Pk44cUGUZkcMkj/8uYgUWcoD9s/YMMB4Qcs?=
 =?us-ascii?Q?N3Nz23udRkSYZG9o5KhD1NWGhpCQ1M7zDmx16A/2rz1nY4NgCayw6uCG5lKN?=
 =?us-ascii?Q?/Tgb2T1/GOkHHTI2b55bjJOEgiMcLCfku/pP2aMIJEZ/zz1kLfjnWQLcKXN9?=
 =?us-ascii?Q?IA64CEYKx0wSkPwzW+0BI5Dw9uuKsK14XX2ZzbeYU12TXxjy8JNQpjw71EX0?=
 =?us-ascii?Q?o01HEXGZPNUBRcNXtIuyayu+/g3GBQWn+YyGPFbed0KwZ6/O54IdSwDMpcw9?=
 =?us-ascii?Q?vEg+xUC8msh0zDaNyT0dD/6YV5YhUVqZKLRnZ4z+u4zBhrFChsuYEcAJYZmL?=
 =?us-ascii?Q?sFQsGtRQEIiNl3MOwsJ3ks5Iiw8rdZp10xESVxsBzd6ODiu0ugza6Q89yY2h?=
 =?us-ascii?Q?rlJIwRI7lpkRVY2qA9VUpKQPDWRmczjbYbFmnIELAz6D6IFlNL4sNzU/ac/h?=
 =?us-ascii?Q?8j+cIRHmFhycZxk/3XxYRn1MiXD+khAE6d6ZnIn5/NhGyeJcE+6wIjPJIg1c?=
 =?us-ascii?Q?0OVbblPMgHbD7VNYduShuWxMYPH+Nozvg5Eb6PK7fYJrUspYjsXdtV11/Eeg?=
 =?us-ascii?Q?Zsh+1+iM2rmOMpvxppXFr4bRiit6Uf6U9Ai/0ZNbcu51amu0NQk21BrHU5Aa?=
 =?us-ascii?Q?yVrzDRWfqLH0nc9AlhEo2PYShQO8KoD8uZ8ba/oxfo0JdEDwAtqgfX1T1/N8?=
 =?us-ascii?Q?8w8g8HmrX2Bp/EjfZ9Gm7K1D6fzqVETueQguZExaYzsMqcxxhxYLtaYVkpoO?=
 =?us-ascii?Q?Mc/kUnmcl8p0l86NW2+a9de4F+7d+Ck9ldyYafN8tapVel2AI0e9Kg88CW61?=
 =?us-ascii?Q?wbr0VKE/BA0dWs1IAPjWuCQ22e/gAnIL3CVJQRSRFWaRi7AJLMOw1eLT2yZ/?=
 =?us-ascii?Q?WcCT/Mdq8mE9tpjZpd5+CfJx+gkrNqf7gcGeBhsPoQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4jtrQiL+rKdnjQBjWwGTpIUmA71i4cxuHAg3GHQZ1QaYksOrejyL8im74By?=
 =?us-ascii?Q?WBL0Qf/ftlDS4RLtLkZDUlKkmVkdMM6bmbNJ5VDT1b+KKv4JrMS+fHHL02cc?=
 =?us-ascii?Q?qGW5VE3w2tUVeh2EKQB7pvx2Xe2oRg4rdDJbM8BY9e5v9iPWA9C0fL1P2Fjx?=
 =?us-ascii?Q?ukew/4eoVCB5o1f6P+aGwWJKeM7++02Bpe4xSmoXML5laEi4DDOhyEhHjVa9?=
 =?us-ascii?Q?AyIfFjNj9tvNFJuUWuiEBPDQv2BBBoS4i38cYm4Eed6mYSoQ34wZaHr65PPp?=
 =?us-ascii?Q?X5cnmNW3YtNOE6/UPD2jGFRxGkvllUP4LKFNImsc/rW5jkmHSAnods3h+JHI?=
 =?us-ascii?Q?v4dd16qc68TsDI531Frk70akwGh5vIs2NKEXxdVLLUgVxHWLnkJCj/kaOQIS?=
 =?us-ascii?Q?KUrztk8rKjiSp5UVtcr09RFZIlG9e1I5y76j18XMX3oOhleqFnU1MbTAEpsu?=
 =?us-ascii?Q?Z5JCqmG1fNO04XWO/5S2B94sxUjTpGMRJqgUu7SViYK74IDPtlDjTwHL7ytS?=
 =?us-ascii?Q?UYTbNQVJF0pb3MkAgxnfPM8JRD3ZbEwCa89eu/6LS8zCBQkDlWkymiv5Rqju?=
 =?us-ascii?Q?3UHRNbWX/PxJHzLnbDOejE2+74lxfs0m/rIS2j4N6wXsSDiPkFUAGIVAL5Se?=
 =?us-ascii?Q?GYwM8ydNQ1Y/2SqVNRHaR9oUMfTjEsT4J/2cLOh+6W1x71vXl7ezbdhtNavk?=
 =?us-ascii?Q?b0/bb7+Vv4fmyVUCxpz3GYtOlZ5wrcr0tI0foA1IpkcXDUlf1NNjmS8EJnG4?=
 =?us-ascii?Q?GB+zjl01YN5PLm4rmrxduqjyiGOHunelK/RDoT+7ek1c/Wn/Wtz6WXMA+XC6?=
 =?us-ascii?Q?6OOSVFLXAWRyLt4lSi132kF04vPjGy9WZ89llkgzTkM+E9LkaU2e13JYRp9G?=
 =?us-ascii?Q?19KXaXFW5nla8TguiagQELy1lyP5B2/eWaC62tk5cy35EIhr0oqdudaWwsxN?=
 =?us-ascii?Q?09qGKnASq5HaddxV+7Cc2ORm8wKPTGGWQB8cOC6UQ6VaP7WCqZczkF3bXXU8?=
 =?us-ascii?Q?oCYkO2od56QTLSKvRsdQUXYAOITMFU1jFdRp+SYW88HStK0H7xh2Ji4oNeMX?=
 =?us-ascii?Q?9y0Bhk2GFDv3jbnRe86MsV1p1mBKIU2UFaIoibZZvU806GGvQcHddvGs1TVM?=
 =?us-ascii?Q?Mt7p3yTMu1k4L7QONFI7CYBrn0R86uyp71lBlfJVtnla+cSHEuIkwhhOxCSc?=
 =?us-ascii?Q?Txo+YS5H/wPxb5X3IDtTN3HOIHyDaoQNGgNe9rR887UOkWwP84AUr7SO6JnS?=
 =?us-ascii?Q?EMethF3NpUY06ID7CCDUOSR3DVZWVmczhephez8XZp19ueA2uNjp1M5fx5Ug?=
 =?us-ascii?Q?ZRg/3EdkXIX6cmiIixJ5HY/zWbbor852+h7q51rrRqZOIMw7n4Syi9vPExe3?=
 =?us-ascii?Q?nZzFpnioZcnuif5Vfd++m7S0hu/IhyLX3KPmXfj4paEX6macje2XgwRSIp/k?=
 =?us-ascii?Q?VdpiZwnSbzYM1TZMfxq+c/b9i1khoc9koGi/WrC6TrJgn7z0p834vc6wOGI+?=
 =?us-ascii?Q?xuqGRvXjggrTL/1v/Hssif4011hfe44r+vWuzFbDRJvzYixdwjMSLdcU3dRK?=
 =?us-ascii?Q?Q/rnisk/h7JMiHbxUNAqWznUMdGCK4etG1H6LjWO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53bd938a-04eb-4d09-5e35-08dc63974668
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 13:14:15.3536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c9k4VVxHX7QNW1RxFpAGPjxD2fHIsqDs5OPaGFKot8gqwp1fT6mzidkA1O+PtCr9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6593

Half the code was living in arm_smmu_domain_finalise_s1(), just move it
here and take the values directly from the pgtbl_ops instead of storing
copies.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Mostafa Saleh <smostafa@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 47 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  3 --
 2 files changed, 18 insertions(+), 32 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f021268dab4763..3817bc99d7e319 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1309,15 +1309,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 			 struct arm_smmu_domain *smmu_domain)
 {
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
+	const struct io_pgtable_cfg *pgtbl_cfg =
+		&io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
+	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
+		&pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	memset(target, 0, sizeof(*target));
 
 	target->data[0] = cpu_to_le64(
-		cd->tcr |
+		FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
+		FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
 #ifdef __BIG_ENDIAN
 		CTXDESC_CD_0_ENDI |
 #endif
+		CTXDESC_CD_0_TCR_EPD1 |
 		CTXDESC_CD_0_V |
+		FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
 		CTXDESC_CD_0_AA64 |
 		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
 		CTXDESC_CD_0_R |
@@ -1325,9 +1335,9 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
 		CTXDESC_CD_0_ASET |
 		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
 		);
-
-	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
-	target->data[3] = cpu_to_le64(cd->mair);
+	target->data[1] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.ttbr &
+				      CTXDESC_CD_1_TTB0_MASK);
+	target->data[3] = cpu_to_le64(pgtbl_cfg->arm_lpae_s1_cfg.mair);
 }
 
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
@@ -2284,13 +2294,11 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 }
 
 static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int ret;
 	u32 asid;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
-	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
 	refcount_set(&cd->refs, 1);
 
@@ -2298,31 +2306,13 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
 	mutex_lock(&arm_smmu_asid_lock);
 	ret = xa_alloc(&arm_smmu_asid_xa, &asid, cd,
 		       XA_LIMIT(1, (1 << smmu->asid_bits) - 1), GFP_KERNEL);
-	if (ret)
-		goto out_unlock;
-
 	cd->asid	= (u16)asid;
-	cd->ttbr	= pgtbl_cfg->arm_lpae_s1_cfg.ttbr;
-	cd->tcr		= FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
-			  FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
-			  CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64;
-	cd->mair	= pgtbl_cfg->arm_lpae_s1_cfg.mair;
-
-	mutex_unlock(&arm_smmu_asid_lock);
-	return 0;
-
-out_unlock:
 	mutex_unlock(&arm_smmu_asid_lock);
 	return ret;
 }
 
 static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
-				       struct arm_smmu_domain *smmu_domain,
-				       struct io_pgtable_cfg *pgtbl_cfg)
+				       struct arm_smmu_domain *smmu_domain)
 {
 	int vmid;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
@@ -2346,8 +2336,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
 	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
-				 struct arm_smmu_domain *smmu_domain,
-				 struct io_pgtable_cfg *pgtbl_cfg);
+				 struct arm_smmu_domain *smmu_domain);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2390,7 +2379,7 @@ static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
 	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
 	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 5540609069fcd0..392130b840d55b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -587,9 +587,6 @@ struct arm_smmu_strtab_l1_desc {
 
 struct arm_smmu_ctx_desc {
 	u16				asid;
-	u64				ttbr;
-	u64				tcr;
-	u64				mair;
 
 	refcount_t			refs;
 	struct mm_struct		*mm;
-- 
2.43.2

