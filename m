Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2040.outbound.protection.outlook.com [40.107.244.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8366C6D1B4;
	Tue,  5 Dec 2023 19:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="H9soRwnK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmXUSR4TtOocRoVrvcl24hyeCojUoDJ7Yp5xtlRxfFmYGBr4wC7h6DpmNpb6/Ei/J3yFx5sGr/sWe3pU3vEELOSGcsPkRq3m9hRfd/C+J3lPlCBMpxPuZY7Zcv0YbM6peNw83K2vRDTs7G1uwJlszV4N1zuzPLDYJhJcSz8T8IeRlSYXZgsn8cRbqIxayyc1V60g9LMEjTbROzNPuqzy9+ugZJQAD7axsJU1sk3NELIt85FyILY2e4OHfjUuBcYP/NUH5Kxs0toHuwxLTGUZ9Js/4aHf0RNBeOcpo/ucknir3xp5sH1g0h86MUDTP8W6QmGHoaMRDAmEUAPcUCLURQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p0FmlzvkeV/FFaaSQCt9IXu1ax85M8gaab8w1TvQq/A=;
 b=JUniM+jlpp36tG3AN23UioQgoK3Vu385a/MQ1AG5rrye7TqgVpl4tjRtXPbRidOi743o2rPj9BTgYhm9mB4qRHlqEhHcbvIgY86zWxjizH0RGoZ4aL5JpKfgEyGRU5lylqQ7h8bhvEs7zqSCdj/l7Frb6WnWqSIEVBq8hbmyEUuRuot3zeTMWGgyE/uMFdl2IHqzgnrAeu0QNBGPJmvQpjNlynb3tt5rwnEYXarArNcOeBE6ck1tAxQXlaf7KHtyZ0YpI44sgQwhIt55Z22jOmDg8aZUz1mwksJPv0BqwStfGFe6En15KXD1L4d/Ku1stgpGcbdW1Vzu8wdeuOyjIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0FmlzvkeV/FFaaSQCt9IXu1ax85M8gaab8w1TvQq/A=;
 b=H9soRwnKgDuurqqaZJ1Lzg8ROlg4VbwvLgTr234Y3WwHILlZ79yXBV9FSrYVklU2TWKpSoS4gImaNOMXox6OF6zp2cWCV/xATreLHOJOA8/af6tqD47xV/BmpdKnNLUxE0DZbRJtmrmC1HrFeh/1ydVImG2RV+Bwgt/CTQVKLsWPxq4TX+DpMAvqgi+gGNWmvBYfxYmfZCbu4Rw1fHaamCzUwE682SmUb9vjEBiS3LzKU9cVLmFnIueC7kFl9AixR5jaFvPbfZbv+13m33GdwS2Ocyu2jxLXppWwCkttmGd1PUa5dx3DlSB1TgFyh9ZHmzUF5B8TX3MO+DOt8+FBEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Tue, 5 Dec
 2023 19:14:53 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Tue, 5 Dec 2023
 19:14:53 +0000
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
Subject: [PATCH v3 05/19] iommu/arm-smmu-v3: Consolidate the STE generation for abort/bypass
Date: Tue,  5 Dec 2023 15:14:37 -0400
Message-ID: <5-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v3-d794f8d934da+411a-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0343.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6588:EE_
X-MS-Office365-Filtering-Correlation-Id: fd8e38e4-be2e-4232-2a68-08dbf5c674fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vjUVWQEeHa6P3eH1vKPg0Q1lLQkjH7GPFFY07IiQkhJG2XnjDiCKcTYh4wIqK3TAg7KCwf7Sm7/2DZKmAolkoOI9G8PsFT5Z25y2AVKGHwRcq54BTkPkXb8I7dXPxyl1UD1mKOO/t04IpsVwQ0QUitUPoqTXRTLy0GKyZU5My/Mfokn8u0qBiuF3XEmN8+xFR8+pdRoLKuR3MitsK/9URw3GYyloWcnVNb/FvixjqSthp3M49rX+vyi9c80Jyv9cCX7kjj+FIHKknnSIekwK1nlorVmGo7CJaSiXwj+hmnlkxamdN1V0Iz9UPwVWdjf/K6MKwP7osGHcQmOua5NNno/4vVu6EJHbMNlUNhv/rov2zuGoRRWAQZKq/h/MK19zZ1EMTe1qTrtaPR+HPjVnVecDoyKcdBZyKaaMmiSX9pq8EcLfFkO8rfuMpaKpd3VVGHYQIGgYGomX72BaHHd4eTdy0G62k11ZieqPsDpwmLSGtYLoQKWLaYLEAIycZAuVDxXk7tKsTMAl1lm+IPyuI9fHwlRpRGlyQDUjy0PfpPUsAVMYYHTwrBRkXRU6lIod+l+My1acxbA+g0y0u0Gjc7GPcih/jcV57+/AZmX6eCI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(478600001)(6512007)(6506007)(8936002)(6486002)(2616005)(26005)(6666004)(54906003)(66476007)(110136005)(66556008)(8676002)(66946007)(4326008)(316002)(83380400001)(38100700002)(7416002)(36756003)(5660300002)(2906002)(86362001)(41300700001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nYRi7++yw4N2kfAquXVuYaPElPi52pchXqOEVcmjhjQZEkGvMmLGlVKwzYkJ?=
 =?us-ascii?Q?M6g20Tdj1B/gNxEieNebDpdqq60o4CBh9W10fpheZxuMBGNB8jxTWbYtIhW6?=
 =?us-ascii?Q?3zFj64gpAGOU/we08rWHGpEYx8gyeYVKdeDkwDosKxzJZ6zmAnskkKCdOCD3?=
 =?us-ascii?Q?n/ao/rHNvvF8yB3wU25JH4kpwsvP2QgChO2trLnpRUtdpHtfBlqPV8c4ufol?=
 =?us-ascii?Q?9CETBGDs3lnbU8ZzKRG8MxoiNB+JKXobUxd6fWTk0XoTGopKyAb92P8uyVfy?=
 =?us-ascii?Q?GJrsZ5LI6I2BO8Jo2Bl5EXG9/BvkESakBhWaC8IqLVBJYFfMtQ+y2sdUChJn?=
 =?us-ascii?Q?ZG791Ecc+7qu9mi8tOiEpyG6B06SpMJzIblwXCwg1rZT0niA9FaAAuaUt3NG?=
 =?us-ascii?Q?YH5pb0kmpzAwVaBWmvwRZnGMEWywH2wh9ybSCV9NDu3dGDSKoH4uT1cXF1z6?=
 =?us-ascii?Q?DXd9EF7eBHlreyTfIJu6VgbcCmgEEVpJwWQA1FeT7dOOWCjqlUKSXAF+5d6a?=
 =?us-ascii?Q?KBQx2yHLE/Sx5cCujRhCUQgZ3DF9cuMkaNwxGaq6jJJNsL0aEcYAJ9m3FpXN?=
 =?us-ascii?Q?b40p+tCwLmEQcCPslzzHw0hvq7MLEIIi/UpAUqT+Z3+QG/WlubCb18Ht6it5?=
 =?us-ascii?Q?boBmdeCjXwMk+yrO7ZqKOWjLwGlfBVdWAsjUeg4SgUa202CGt8LuiDQDOLZC?=
 =?us-ascii?Q?JXJMjGRpOsSuXivtK+NlRYYN1pwNhP0i46w3D5dLoSyk+weHOzuFB3OUZ35q?=
 =?us-ascii?Q?ntHMm+0YUcTME78VVWl/K19uRhtdNwPEUJry1l0Vsa3uijiUC8om0f3cxCb3?=
 =?us-ascii?Q?CI15nci+XYbAanBHlURVLSMPMAaS305TRxb5w8C/heMKJLD/idiq8/SBkhz5?=
 =?us-ascii?Q?d7br9SpEwILr65XWqUqpFlQ1hr8h8xXMlh95O1S27Exdt6XhcrMhxEOkez6r?=
 =?us-ascii?Q?kEauK2y5dnszmgqeKaGJ9MxUrBj85y46ykcHNIoGjYhpQA2ntbxUoeQY0Kh3?=
 =?us-ascii?Q?bRUxT08BH8fc5mTH2veWlv9zwnmH+jKfLMc0leQ2xPtLdzXkbitvX/gUKqvn?=
 =?us-ascii?Q?uy1gU7ZNw/V3uh9wcnrooJ5hUTVWwLNMigQLfRvXZTKzAcao0GEjNu8KOma/?=
 =?us-ascii?Q?EsFsrIsOkcQmM+k1Ay+XBRNLYOxIdOAdUt/5jC2chUTdbfu/P8dl8DfOXxUa?=
 =?us-ascii?Q?sJc9okLPKhWIv7lisj9SlNb0jDKz/4sHoWIINk+nl9kQ3GlpcNouiDO1nkbX?=
 =?us-ascii?Q?JIA3yOTqc3uYEOZyl7xD+jp8FO+KMeiP58rF5jDjXgCo8TV+Yw2qWB5bDHlY?=
 =?us-ascii?Q?tovX7JKCUA7Q997mYX0LD7ZCpbQ76V/EwXYx6oqIjVE+5lwkCdzdSWrTlfW0?=
 =?us-ascii?Q?Qk1PQ6nc5/VMUCI3VbBmwo44w9leCW41qYZcaV9jw55+PdcfweUrckNvDxUI?=
 =?us-ascii?Q?8E31lixbdfEVlR5lKyIMB3Tg/+DdMcJ19Zf4+3/UTKzTpESYmxJ1ue5G336S?=
 =?us-ascii?Q?FvL8QQTpmoFeR3WzYM/s2UVMVt8wixC/DsU9F07fKTnzhDcv5fLcdcv3wjiU?=
 =?us-ascii?Q?rJ7qEMsQmjTGz0C8+1nxHCar4/D/cwHFATE9b0GF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd8e38e4-be2e-4232-2a68-08dbf5c674fb
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2023 19:14:51.9155
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEcNgMsVXoBZby4kxQvtE313Si9NEHBEjt7OfgdoO9BQAi3VGNnaePYhdf/g+10Y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6588

This allows writing the flow of arm_smmu_write_strtab_ent() around abort
and bypass domains more naturally.

Note that the core code no longer supplies NULL domains, though there is
still a flow in the driver that end up in arm_smmu_write_strtab_ent() with
NULL. A later patch will remove it.

Remove the duplicate calculation of the STE in arm_smmu_init_bypass_stes()
and remove the force parameter. arm_smmu_rmr_install_bypass_ste() can now
simply invoke arm_smmu_make_bypass_ste() directly.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 89 +++++++++++----------
 1 file changed, 47 insertions(+), 42 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 0934f882b94e94..0a4bf1cbe42293 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1443,6 +1443,24 @@ static void arm_smmu_write_ste(struct arm_smmu_device *smmu, u32 sid,
 	}
 }
 
+static void arm_smmu_make_abort_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT));
+}
+
+static void arm_smmu_make_bypass_ste(struct arm_smmu_ste *target)
+{
+	memset(target, 0, sizeof(*target));
+	target->data[0] = cpu_to_le64(
+		STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS));
+	target->data[1] = cpu_to_le64(
+		FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+}
+
 static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 				      struct arm_smmu_ste *dst)
 {
@@ -1453,37 +1471,31 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 	struct arm_smmu_domain *smmu_domain = master->domain;
 	struct arm_smmu_ste target = {};
 
-	if (smmu_domain) {
-		switch (smmu_domain->stage) {
-		case ARM_SMMU_DOMAIN_S1:
-			cd_table = &master->cd_table;
-			break;
-		case ARM_SMMU_DOMAIN_S2:
-			s2_cfg = &smmu_domain->s2_cfg;
-			break;
-		default:
-			break;
-		}
+	if (!smmu_domain) {
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(&target);
+		else
+			arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(smmu, sid, dst, &target);
+		return;
+	}
+
+	switch (smmu_domain->stage) {
+	case ARM_SMMU_DOMAIN_S1:
+		cd_table = &master->cd_table;
+		break;
+	case ARM_SMMU_DOMAIN_S2:
+		s2_cfg = &smmu_domain->s2_cfg;
+		break;
+	case ARM_SMMU_DOMAIN_BYPASS:
+		arm_smmu_make_bypass_ste(&target);
+		arm_smmu_write_ste(smmu, sid, dst, &target);
+		return;
 	}
 
 	/* Nuke the existing STE_0 value, as we're going to rewrite it */
 	val = STRTAB_STE_0_V;
 
-	/* Bypass/fault */
-	if (!smmu_domain || !(cd_table || s2_cfg)) {
-		if (!smmu_domain && disable_bypass)
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-		else
-			val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
-
-		target.data[0] = cpu_to_le64(val);
-		target.data[1] = cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG,
-						STRTAB_STE_1_SHCFG_INCOMING));
-		target.data[2] = 0; /* Nuke the VMID */
-		arm_smmu_write_ste(smmu, sid, dst, &target);
-		return;
-	}
-
 	if (cd_table) {
 		u64 strw = smmu->features & ARM_SMMU_FEAT_E2H ?
 			STRTAB_STE_1_STRW_EL2 : STRTAB_STE_1_STRW_NSEL1;
@@ -1529,21 +1541,15 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 }
 
 static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
-				      unsigned int nent, bool force)
+				      unsigned int nent)
 {
 	unsigned int i;
-	u64 val = STRTAB_STE_0_V;
-
-	if (disable_bypass && !force)
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_ABORT);
-	else
-		val |= FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_BYPASS);
 
 	for (i = 0; i < nent; ++i) {
-		strtab->data[0] = cpu_to_le64(val);
-		strtab->data[1] = cpu_to_le64(FIELD_PREP(
-			STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
-		strtab->data[2] = 0;
+		if (disable_bypass)
+			arm_smmu_make_abort_ste(strtab);
+		else
+			arm_smmu_make_bypass_ste(strtab);
 		strtab++;
 	}
 }
@@ -1571,7 +1577,7 @@ static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
 		return -ENOMEM;
 	}
 
-	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT, false);
+	arm_smmu_init_bypass_stes(desc->l2ptr, 1 << STRTAB_SPLIT);
 	arm_smmu_write_strtab_l1_desc(strtab, desc);
 	return 0;
 }
@@ -3194,7 +3200,7 @@ static int arm_smmu_init_strtab_linear(struct arm_smmu_device *smmu)
 	reg |= FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
 	cfg->strtab_base_cfg = reg;
 
-	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents, false);
+	arm_smmu_init_bypass_stes(strtab, cfg->num_l1_ents);
 	return 0;
 }
 
@@ -3905,7 +3911,6 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 	iort_get_rmr_sids(dev_fwnode(smmu->dev), &rmr_list);
 
 	list_for_each_entry(e, &rmr_list, list) {
-		struct arm_smmu_ste *step;
 		struct iommu_iort_rmr_data *rmr;
 		int ret, i;
 
@@ -3918,8 +3923,8 @@ static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu)
 				continue;
 			}
 
-			step = arm_smmu_get_step_for_sid(smmu, rmr->sids[i]);
-			arm_smmu_init_bypass_stes(step, 1, true);
+			arm_smmu_make_bypass_ste(
+				arm_smmu_get_step_for_sid(smmu, rmr->sids[i]));
 		}
 	}
 
-- 
2.43.0

