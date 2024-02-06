Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2050.outbound.protection.outlook.com [40.107.237.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4E2131E56;
	Tue,  6 Feb 2024 15:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232398; cv=fail; b=I7ZnDWi6APS3NC+P4UwlNQWVG+9AV3JPBTahYA+TIwZhVY/dvt7SmVDNZ82cWO0/CmR0CFtlDENOeYOn/yEGUBOeVlxZK2sD2M/7ZVRf4dLWfkcIWWdWgnAkuqETR+WLkV5plC36yM5ZiNnYBG/1Y8yjyvltFlv4jv10hcaln/c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232398; c=relaxed/simple;
	bh=Lr9mRkMvnnh04DwuM+WhipL104GIBJ3nQOzBzzJkibg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=su84TNtp/B2qUmUAMCACK+drtM1AYG41q890w+CgHGqmk8F+kvrQCDw19Fm0nzCcuJmuuXaNi7C3gI9LklRtiRUxK376PU1j0PLPC2LliF9MgC+RveKQRc6wdDowF4mBUZ6BoSBdwCL+C1zkVOhU5jOw47iRgp/jW2mu9UKfaV8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CuEgqV25; arc=fail smtp.client-ip=40.107.237.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CuEgqV25"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6xRjCWnZ1S+MP2z66SOBt1jqbfu4AMxpJRdkfI4kQawfnHB2h5O+DVWUsIBo+0iF1YpqxH09kbIS/EWb1LCjtrava9yXqYeV/e9gtd/Rco5+Gv+cAtUP6K7mmeBlj4PK8vLNO/twNhU/gFQyqGEAsi0ye4uzP8MuLtJ0MGtkbUVULEaDRfoKgpXCbHqz9SmamJgBMgzKHYd265y8JNdbEQZbQBC3TMn5KZ0CUun3+EzEnJ0IqKzqzG2Y0qrSoo7G/y5wwd1LSXL/kbkfyDmWbU1aqk1b0IO5rUWxC2IHWSfJFL4kp6yXoYRw3NZMMK/8X2N2wyr9jP2+TevvQBOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8uzCZbZUIXBDLszoJSY2OR36PxPIYFQ2QBqrMyC+aQ4=;
 b=ajUN/5l6CDjwTis4uQ/KzHU7ymwjFkHGJxJ8biciblg1ZoErVigpcRZpBqB0n5SmcfbCtsCT6xXlzhsIhHCFKpb52CRq5Nqj1oCwSzSCIR3NHXs70TRxCwLTFK6/jJw3XhWfqkUxPOihEz5VecIXqf0g4VilMcqojgL4a0QlxXOZflyhp5U5uSVIZedo6HJ3HV8R+/LlDuiaArV5fbi7sW8XOEma49mhzs/eNm+XaTPHt/SKJsjxVdhtLWEx6K/ExuGAZ5zM37Wrok6wwqQ/NeEpWKiHhIeINLoHKCbxATDkPwQKqfRrQ0STdojLK1353ade2odAQ+eR9OO5oWUc+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8uzCZbZUIXBDLszoJSY2OR36PxPIYFQ2QBqrMyC+aQ4=;
 b=CuEgqV25wRtNJe0vivvw4VlLUr8Nd3Z2Td/8PIf+1WGn9XibR8g0VJEu7SSB3JaY8n13mwfbVKS0fbolw63OiOVgNnLZZOfROxh9mPFLPL6FZmAOh7j84+5TUguHjDLeEFwmx2MObMYHDDcUNQ0G0v8FcnwC4r8yQ/qeuGKJ1G9wyC532cPvte0cUHyDQBXrxXkTcnP017nzBr8kcAL2OB9J9t9aNA5J5KJ28JQXuMatWZMqXSUr5tOE0nBW7yYnwN5NVEK6Yz84NyFhE3Omim8/F398U+FjcsGIxrv0WRnT73oi4ZmkrPTCGmHCSPGo388cfL69rQbkc54vdO3mtA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:05 +0000
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: [PATCH v5 16/17] iommu/arm-smmu-v3: Pass arm_smmu_domain and arm_smmu_device to finalize
Date: Tue,  6 Feb 2024 11:12:53 -0400
Message-ID: <16-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0006.namprd13.prod.outlook.com
 (2603:10b6:208:160::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 02422cb2-1b74-40af-dfc4-08dc2726192b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	D2vpMqCd++UJrjpTzE3PVQUEGXdtNwm4UAsmiNqdqv2CYuC25ZBkDQIcd5wCSnHd8qfWLA+8txOeTBxauOCQfcqDFakZkaEtCO8QgXhiX5h0VBH2/hk8QXfvQmb5BFYXlECxclHWwplnW2h7nRMhVZn4gQ7clVloqAXwujiYcgRazd4qT6h4XoXdr2/QQYgHMBDah6TSNc+D1YvtmwGrUDF03rfSdjDZ4etQuzTcZ8zvdPQ7cwDfqmbdMjtZF4xvYo4tEJt8QJ1tT9b6a/GzVPtsswgRqOwW9GJcW+qimZQrs+HthzuQWfkN7HvY7ExnESjsFB2z6dkNo3I+pJAyOCSFSBN9A//yfBaPFYISR3Q956U1dTvkq22WNOeb6TwCBcta8ILreHS0YVdSUnDGXJgWQHy2mok6IGVkHuosoHIegRA2NoKRAd8frM3zOVKjMvsKrB9O0P1oM+txg1EjKwYthpjPFnIzy8BEq2yocxCQz+YwpnUuBaUjYToWqPVeSIpSGC+rW/EsT4h3PJJTSVJNdDbRRHrNkZAMAt6w2jw0bFT69Q0/lZ36s2eSmhJ0
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?44igk/2x98ih+N0ruiRIs0OAIJZQ3nB5lFKxhMt4iDUE1yUYAMQCuLfiALjt?=
 =?us-ascii?Q?HGxYfudhpLM3HR6nwQ9sFwDLkmRUWyYy4H2RYs+JHwZ3Pr7+HFcURJ3fsT+Q?=
 =?us-ascii?Q?Devo20fOGef0zIZ2WOS5gIY/oriBq1DSuSAN8Y7VtKupJM9EqlKtOmlNH22F?=
 =?us-ascii?Q?sftikWMDdgpg4g7E7+QWS+fEMqKsxYHIde+e0+DlZ0k70fOvD/hrdFFMpdPn?=
 =?us-ascii?Q?ELQ1sXvwZafHrFHly/eZBtaYe7uDbMxIWrjq1DTEi89CZ2A1Mu5H8lQhRf1g?=
 =?us-ascii?Q?60vFcIZ1w/n6Nq5AZ7iN3jX9obRY235/MzC8+HTlACdIBA6sGk9nQP43QiKI?=
 =?us-ascii?Q?cfyF4vaw3EqiN6ohckkGYdZcowwp5J38P1AqnjNjxlM20oPY/UVl0CjfdeCS?=
 =?us-ascii?Q?7U9XhRpuSOBf8KmUbYyDy4FhmnEeNDgf09E/cTKE75kouE6NeJ9samp/xegu?=
 =?us-ascii?Q?m2AkXjrZ6CDz0crZ685w3fOEE9e+etYOaAjt0GL4Nqr9/3KwkUx89PVm17cU?=
 =?us-ascii?Q?fSY7s2ITtSWWNB7i+uoFCl/MTNHc0cNilTEI/0RyDrc9yeafJ8FS1LzkF/7/?=
 =?us-ascii?Q?JYpGkiJJ1LMK5AAq8eHxNepCGCRf9GTAzorTdY9Tt+woSGozx9C1piwYoDfA?=
 =?us-ascii?Q?VwWHljr+XF40wJEe7IDn5TfCTgqYY8I+mr4iDAtbxojuTVR2oCS9bKgNX4ar?=
 =?us-ascii?Q?L/UGp0KTe6EtKIK4j+71OoiIXtysEp/kGjXkW2SqHru4m9vJOIpV1gVkFRvf?=
 =?us-ascii?Q?8F019YU/lZ3UYNwIzrvbQJErUtXCCjgB9yHOAuorBXsztQjtU1IDlSYt7u3o?=
 =?us-ascii?Q?UXgwTQLjrmCba8KiWZDE3ijsZpPaI6+zNL8FEgC82t1XNvqRMtMgiaUiQH2q?=
 =?us-ascii?Q?eFU1lWtGOEJuDqR1EyK6O0tIreffblPk3nifC3RAE+SEoz9YjUQCaI7tCvGO?=
 =?us-ascii?Q?S5VBFw9PKzZ8WjElFP4n35b4c1rWGN9A6wh9IblowokrlgOQ7gFpmqfSPJIv?=
 =?us-ascii?Q?7NT9rYav7QOU5tMlKDGL/iMt4vuIX3y9hRHLgxYfCVN41X4i7mmlge8OooEG?=
 =?us-ascii?Q?Y3bGQBEV2PDWXxGTDmfvvbDVcWS79OD9vADItdSyyIGuUn6+qQObIO1ao9o2?=
 =?us-ascii?Q?5aXwPTT14GaQI65MQDbz698g1l10BrB9SQyUKdVUDFgaAtrMKfUvi2JlswvL?=
 =?us-ascii?Q?Zd6l8JXG2gaWp+uxWUMpjlFohkXKcT4HbqAO8DqPJlbC1MQFMWeTblAdgWbT?=
 =?us-ascii?Q?qp/TCyitAKeJVugN7KhpN7VcOpQdmyjFwWonhLi0Bq+LlMjIV3qyNB3f7eA5?=
 =?us-ascii?Q?xYScGmb6HLJDZfS+K43dk+6iYMMhQqbEIuY6T7gUcymdkhVhepHo2LkEmHpB?=
 =?us-ascii?Q?+kZgVwMoI/oo3immmo6uiO7fo3doJPAcsWKAjwdiAIYZ8AeMCWiGuvhab6eB?=
 =?us-ascii?Q?ThpuYfMxpSaJlkM6CB9LNhZm3hYTp02FoiabgrzqR8WRm7k61fsvlkCVtrVK?=
 =?us-ascii?Q?fsfvpxc/OQ/bajKTRmLLoU0WVtc6H1CcraAUN0WAT7nJ1Ffiw7o9s6CTejZ9?=
 =?us-ascii?Q?20he7K3SVnm0XXYHCtTat1gtEH5YndftWGoNK2RJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02422cb2-1b74-40af-dfc4-08dc2726192b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:56.5130
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bTNk6GB6E37WHfqVz98+vZiYdzJpyW/SKnzlqLDO+uvsrVIERW7wVZ5KXIHDqrup
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Instead of putting container_of() casts in the internals, use the proper
type in this call chain. This makes it easier to check that the two global
static domains are not leaking into call chains they should not.

Passing the smmu avoids the only caller from having to set it and unset it
in the error path.

Reviewed-by: Michael Shavit <mshavit@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 34 ++++++++++-----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 27a2792a6acd76..7116874c332ffd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -102,6 +102,8 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 };
 
 static void arm_smmu_rmr_install_bypass_ste(struct arm_smmu_device *smmu);
+static int arm_smmu_domain_finalise(struct arm_smmu_domain *smmu_domain,
+				    struct arm_smmu_device *smmu);
 
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
@@ -2295,12 +2297,12 @@ static void arm_smmu_domain_free(struct iommu_domain *domain)
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
 
@@ -2332,11 +2334,11 @@ static int arm_smmu_domain_finalise_s1(struct arm_smmu_domain *smmu_domain,
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
@@ -2349,17 +2351,17 @@ static int arm_smmu_domain_finalise_s2(struct arm_smmu_domain *smmu_domain,
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
@@ -2398,17 +2400,18 @@ static int arm_smmu_domain_finalise(struct iommu_domain *domain)
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
 
@@ -2600,10 +2603,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
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

