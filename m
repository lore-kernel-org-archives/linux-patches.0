Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2050.outbound.protection.outlook.com [40.107.93.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19946D1B9;
	Tue,  5 Dec 2023 19:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dshqDPjt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I9BP2H1ylcKeRU09i+LhRm0QLRQVeRbDUED33EwEZvMTWFx+/BQL4nSN69RaCvI22exh+TP05LHVaJ61CVfZ4m216pC/+4TnsLFaWvXe4CGEPyImH1UEBvRaLZ2L0cbs0SjM+y+QnftYgfErKEN7PIYwY321yeLmkwRwbf3E76kQ2DHaqL8Zrb/iSTUb7n1q/kigEbdZJakgBBlANODXZYHojdPIKyuKTI/bxtHXgIe/QUkLGXIRcTjIGoxqojfBdt2gQrhtWd20fhxIsnoxAPeNi+s0lK/9OV3ujhCpdcIsk5wcIY2J4GYWzN9XuPA3rWf4X/w3plD27IIBrIAVtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZmAf375QS/QIfnKWC5I6BI3OubL/+ztcJEFFeqSZkUg=;
 b=fVdxHaTkwrtdL3J5w48VQuRo9z4QCG1OV+NrMPINrcHfZNv0+Vl9cd9bIiprAXBI/+vA7S0ZceEg2MuLM8wtl49ncIdQRdcME8vYT+SYfaXCUHM2tUu6PsQMvfjiEuzRVYZ+mjxlWDcghzyR2wByiBEmyNaJEF9q6t0uCzF1ErC6laOyp+cJ3Q2am9ZJWQMVi+dk32J5XR6iVR7uzSY/x6S3Im4F65lS+R077dKmCWYEE6J7KIA5YcGoMP7t0Pwiv7CWcsqxs7f8+6JH36qhsZ4zbeOWVzZuiHZECSvXi5eDP7nKNarK6QXCpCX1TGd01zKWgN7EkWewnVyDp1imBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZmAf375QS/QIfnKWC5I6BI3OubL/+ztcJEFFeqSZkUg=;
 b=dshqDPjthfAXBbGNB3cztj4AZ2bbtQraGbpffDJD2o7rGIPAcSQDIDbV8pspSgftASHAyW7//lvVgugJfJzV7h464ld1Gywf9kdxhkejQ4dFxaCbsdTed6UMIpFcCCzp8W6jvjkGEC94HFvURJWweQhOk8/gdN5ZHJAnqY30xINKXAXKq+znh3tMMRJ9nZeU6bQwKyHU2/TkBcD2IEgzKAgeCPnEg9DqRAaSdyoOkCquf/NrFeYJWGEAfvsqOMbmmoGAsKwbIAltKiyeOoyW1dKrgonKX7YEieelB3QoKt61OA4F5fg3Z7E3W831QSvfr1AaDBcZws3wW09zTzc0pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:56 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 18/19] iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to finalize
Date: Tue,  5 Dec 2023 15:14:50 -0400
Message-ID: <18-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0003.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e711edb-ec9e-43b0-ec70-08dbf5c6753d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	w2ZZf8A5kKnBIZC8mLBv+q3smQy6zeyRnTdpbDA8PGWsHKqwWMzqVMVUtBqPeMZgPZcgslfazxxa+LhQUQrElkFiB09qeJLAK9IrF2iqFLwHPpoKNGcwsB0z7w66EVbNLsLawzKIasq0OfYxRsTl3iIAhuOxmKe+MG5J/Qr/dy5ROkWLBTbV0eohfYUpu6j7BCIWipze1LGODrPjBoZ4EZw6POU0eVH6Lm1LUExlWyQ7k/E7TWOLdICedJI4Is5sZzgXeARnq6fSFFPkQM2GBS0KA7Tw5RDBO9VNslS3vTN16L3d2JDgVo/eIJJ+Sqg9gS2083xw7rV3UBo4E6k6TS5PcbpBAVeRpqP6qLYtlW4YOEDUAv7vHKaR3p0nhR/ceVCrndnmm2Zm8BfNHcLxD9Z/0uSzaKvqvnlvp8QKDkiDzMc7wnbBfbixcd6/FfAkubj5nERwAr7AOmoRMP4/NiRV/2Fn318oaDZdHaY2I7np+oT1cdDxUCOxVP4/RdrAaXFpXMfePSkrK+M6nShGmbkZC67TVEk6UrS/FwRxrI2NPtV33e/3KkntBeqxtJC6
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IA/2TshBuqORR4GqRE4gQzhi7pGjVsOGwPkA6LRbJTCD4nKbF8ExfSEtXTPQ?=
 =?us-ascii?Q?WowlAepAlRE59Ow3SMvypgA1+vBx6VF18R91apSXQRfhtEFjUNCTtqZcR1UK?=
 =?us-ascii?Q?ht95qy5JlhZreHIlDKC+A2o2mRVrnsQ9+AY3FABee5Us46/alwwrMrCmIw8I?=
 =?us-ascii?Q?+MXDWgeee0dTc6o2+D9umUxPUkhUKWrwXZYvdkC0C53lUXwFk7mVmUc0VMMU?=
 =?us-ascii?Q?0S97A97DGwZ9IHT83DU2umUB/82+sDwzFyjyFxR4+0zf/wAYqtDdrGlvNt7K?=
 =?us-ascii?Q?wgZcgWCpsoWA3hb7P/kUuZDSvLy7ecl6tsNicIKFrKfonq+njVdmEi2zRWCY?=
 =?us-ascii?Q?Nb3vd0HIKe/VlYM20p5I6bK07tFhvD4+NluF48VQ1PtVHZR1V4QGkgjgqksi?=
 =?us-ascii?Q?a/PbnARi/EEfv3LuFGP2NDLq4/vou/D7Hx5U5gI4gkgtrt+rd9CerqXzX63r?=
 =?us-ascii?Q?xQOMpSI8X4pV9NRruxGX4vV3lxk1fXxKfGINNuaH4cWIBFcg3haAyAVTdwCC?=
 =?us-ascii?Q?X8OM5cW+4OVbRhsy+tfVzbKcSxDMHSPPn/LRP56b4mu/P9tCja1Lpmrmi15u?=
 =?us-ascii?Q?UfraJ9lciHAnOTIdDzCIEVT7hwROSYdQwg8wVIyhqnew1DUPjeXYzxhnySgV?=
 =?us-ascii?Q?gSRblSVDX/FwXsMb6KzeCZ3S1ZdWDmZxs2bLWDBFelIo4/+urhkNp4yZk5/U?=
 =?us-ascii?Q?SD2tow928cRwJ17eWqUK8tGxq6hSl8YPD0jNMVg22/28n30B6K8r2I4Ax684?=
 =?us-ascii?Q?F5UZt+kFaer+HyFa4RauPQTpaK1xLJ6NVgc3DUcUAEj2B2RlFGF7PLmH6FyX?=
 =?us-ascii?Q?17XTf0Au1nhhIVcvoRFlZyoCp0MFwnae3gV+84DFQ+LyLHWktTuzsZV+hgkJ?=
 =?us-ascii?Q?6JHFxPyqxmtMW1e6itpXuVe0Q4AHv4E7zAAs6FDPANPFVW2coQq40IhCj386?=
 =?us-ascii?Q?VD37OTGPA+tTjTkBdw37zn7YAbcmbnB8rhozzndZ+uH3tBhQnfoMoOaPXmx3?=
 =?us-ascii?Q?zr36Wqu89HwSPybu+SSkG97Ma6hBq2wiGNYekWCMrgUiWJZZJ2YEemjkrO3b?=
 =?us-ascii?Q?6iHsPHl2YJHmlzAzTjllxlRVQ3N6xmF44PsVqYIXw/sSQUgFErRs7b3pJkQ0?=
 =?us-ascii?Q?mDlLPjw0SC1V6LQw1XWKXg5eIoxviqQ9SvAlWaW+lCAuuBPOQo3v/9tzVCVn?=
 =?us-ascii?Q?8exNxMSlh0DC78mDL8EmpSnFFw/ZaWLdisuFndXm+1OLg3XwkBBRUP+Afsc/?=
 =?us-ascii?Q?BS35lHsSj+QUjvevuAP3tZm0MUHrJr0lgIgY8fjTwckTRbt08Lrd94ujjkKd?=
 =?us-ascii?Q?WQyLGgpCoT+BnATG55n/FbKUN8lyEDIQDyuGxqJpbgLfnde13gI3lCHKU/m/?=
 =?us-ascii?Q?xXqE9vYmNZSCsHWoFiXsog+2yzis4VVoRbKr50luwMSd/4T94Xgk+kXhsbAJ?=
 =?us-ascii?Q?5r9KHun7S41zcKqC3uJM91JKDVqsmPgLJCvXLXsBBLeRuILbastMvxMYYmvk?=
 =?us-ascii?Q?ykk1hRTUKM8Jdj4e/tv54YXBxlPJQjzATAkmm0bBsRq6dCKnf5lNKF8fTcJP?=
 =?us-ascii?Q?eA+eq4a9hQCYxV8RQszyJZzXxCnVSUY8RMU5FedM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e711edb-ec9e-43b0-ec70-08dbf5c6753d
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:52.3389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GtVyoIIRxSDqaONdCBIw2twBw4Q4Ece8NMXNeuS3LyrlNQ/zOzhRRRJotYrS3Xo6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

Instead of putting container_of() casts in the internals, use the proper
type in this call chain. This makes it easier to check that the two global
static domains are not leaking into call chains they should not.

Passing the smmu avoids the only caller from having to set it and unset it
in the error path.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 34 ++++++++++-----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 8269e2fed6038b..873343109a90bb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -87,6 +87,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 };
 
 static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
+static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_device *smmu);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -2215,12 +2217,12 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
 	kfree(smmu_domain);
 }
 
-static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
+static int arm_smmu_domain_finalise_s1(struct arm_smmu_device *smmu,
+				       struct arm_smmu_domain *smmu_domain,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
 	int ret;
 	u32 asid;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
 	typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr = &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
 
@@ -2252,11 +2254,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
 	return ret;
 }
 
-static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
+static int arm_smmu_domain_finalise_s2(struct arm_smmu_device *smmu,
+				       struct arm_smmu_domain *smmu_domain,
 				       struct io_pgtable_cfg *pgtbl_cfg)
 {
 	int vmid;
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_s2_cfg *cfg = &smmu_domain->s2_cfg;
 
 	/* Reserve VMID 0 for stage-2 bypass STEs */
@@ -2269,17 +2271,17 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
 	return 0;
 }
 
-static int arm_smmu_domain_finalise(struct iommu_domain *domain)
+static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_device *smmu)
 {
 	int ret;
 	unsigned long ias, oas;
 	enum io_pgtable_fmt fmt;
 	struct io_pgtable_cfg pgtbl_cfg;
 	struct io_pgtable_ops *pgtbl_ops;
-	int (*finalise_stage_fn)(struct arm_smmu_domain *,
-				 struct io_pgtable_cfg *);
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
-	struct arm_smmu_device *smmu = smmu_domain->smmu;
+	int (*finalise_stage_fn)(struct arm_smmu_device *smmu,
+				 struct arm_smmu_domain *smmu_domain,
+				 struct io_pgtable_cfg *pgtbl_cfg);
 
 	/* Restrict the stage to what we can actually support */
 	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1))
@@ -2318,17 +2320,18 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
 	if (!pgtbl_ops)
 		return -ENOMEM;
 
-	domain->pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
-	domain->geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
-	domain->geometry.force_aperture = true;
+	smmu_domain->domain.pgsize_bitmap = pgtbl_cfg.pgsize_bitmap;
+	smmu_domain->domain.geometry.aperture_end = (1UL << pgtbl_cfg.ias) - 1;
+	smmu_domain->domain.geometry.force_aperture = true;
 
-	ret = finalise_stage_fn(smmu_domain, &pgtbl_cfg);
+	ret = finalise_stage_fn(smmu, smmu_domain, &pgtbl_cfg);
 	if (ret < 0) {
 		free_io_pgtable_ops(pgtbl_ops);
 		return ret;
 	}
 
 	smmu_domain->pgtbl_ops = pgtbl_ops;
+	smmu_domain->smmu = smmu;
 	return 0;
 }
 
@@ -2520,10 +2523,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	mutex_lock(&smmu_domain->init_mutex);
 
 	if (!smmu_domain->smmu) {
-		smmu_domain->smmu = smmu;
-		ret = arm_smmu_domain_finalise(domain);
-		if (ret)
-			smmu_domain->smmu = NULL;
+		ret = arm_smmu_domain_finalise(smmu_domain, smmu);
 	} else if (smmu_domain->smmu != smmu)
 		ret = -EINVAL;
 
-- 
2.43.0

