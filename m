Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2086.outbound.protection.outlook.com [40.107.237.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9CC135A71;
	Tue,  6 Feb 2024 15:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707232394; cv=fail; b=pA6C9Zy1XHvWf8cjRU6GjI4yCp2LznGYUMDTZGsnxuUiDpK4MVm7b5RR4qn+EDfs5w2y0XLEAFMJRNVHH+DE22Nth+ps5mdQYIzOr4hgVP8u3MpxYw4NFP7lq++91cQZ0nDq8WvlCabGMUxVBSerG8pHKdfNVfPGxpwVmNNz8JQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707232394; c=relaxed/simple;
	bh=xgLZfsNk6CKanVcn3l0ZaQe5gvvvf5Xx+b9nkNz6D0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=i0dVqu4umE2rMHTP86Bs/pV0NEM41XSaFlL54amToOjEGkDAKf7BJBZ+ElXmk5PthnPCgCbpcph7QM7aIhj8rJ3YL39NyoeXNSfmWwud+UYvWU/9JyYPPMfS+crY0kqBvMtaZd55gkZRiIE33vXuMRUZJBUM7k1Ijsl3rS6mtnE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iQX1QLSx; arc=fail smtp.client-ip=40.107.237.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iQX1QLSx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhRbiNfxEeEmM1RI7mIeKh0SW5khwDoGcRpBhd7k+TBu3t8lw1b8teg1ogD6PWOlskkeWJ6D8i+BuwDxfYg3AFr6r8H9eKTDs7g3oodkImu+E/XesE+NOTfq4S0O8lcK7822mPSFJB+GiAEVAYLsizOCEAVtqoji8f0tLA20Ig6TzRsYmu213gaa+K6CylDroiQeOt1xW1ppvcNhqGXeC/12yiN8EOMGTwgLJ2wDSwqZN6YNvNuH0vZxqANhhL0BQMweCXlIkFf55CZ7wHyKa6gEe4JAFlmYEFSwmFo4f5lJrKLx9AfPvIHmdXOXZVi/j+3tVLCmdD+jww84lw2vjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsFErtEFV3maUSqhykvMDMh7NNOem07IZG8xZFo30z0=;
 b=Kf/HjbX0uhZkj4xfHCOsw7/de45HSgR2TOgKsT+7DGUt79A3KpMtXOPWCtmFo19se3qckM6jVSmR19wPMspZM8m+/7vxFvA4QNZNS9GTWADo3SG8rekBzpYJj6SUDUlYUcIywrvp9CQoqRIqFtsC+SRlM5NzCqkjFaCzOxu8rYyY2wVb6/9bxstngYvoSuNH/fweAOCjVuXD0qOiTz5dlzVjQd86d1/ZWF8H4Q5bzBfqYFQDZ5HhUGAQ0j305gLCvwwnxkySufC3S/2VcJyJcNv36t2vKIctN2gjCqA19Sow59GwT4Hpg/++KfkWmyygPqltydbfNdRwx16TKfKLTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsFErtEFV3maUSqhykvMDMh7NNOem07IZG8xZFo30z0=;
 b=iQX1QLSxezM/3W/RWDWAn+WHFSfBKHQ/kfwrFI7TbQC5CRaU/XzCvgSgQBquB1ejWl4PzlNl5p+kn0ozip46bUy8FRxqcGufpCSkBcd/pQX939y+0r4tYjsLfaPgPTs0ucds9qf0dE0895bVWKwJCCD6YzAoS8AEnz0xISVtS0yfUoMEfiJu1d1UzZbaONobkpG+i2qAyvV4SuS4bcjonOUz9zPodyAfYnqs42HfqWovoyd8gwaSBeHlwyWTqMAVXw+5HRRZUiHIyiwfRAxSb9k2+GD+pC6SgGW9jqeVmFUFP6m8Tmj1QFbCWglBpZo1EX9h7Pas0IC451Z0tKDCIQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6733.namprd12.prod.outlook.com (2603:10b6:a03:477::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Tue, 6 Feb
 2024 15:13:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Tue, 6 Feb 2024
 15:13:02 +0000
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
Subject: [PATCH v5 11/17] iommu/arm-smmu-v3: Remove arm_smmu_master->domain
Date: Tue,  6 Feb 2024 11:12:48 -0400
Message-ID: <11-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
In-Reply-To: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0006.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::11) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6733:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dbad165-385a-4cc3-5874-08dc272618bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dS/xgbIkPBmEZdABCsb1xmV+QP5XbklYLBXLgVgjhLB30kZ0txIUGY6akSleXzj4tmw0lj5k4RMYlpX3TfimisgSRR2NGHuX/Qm3wl+r2FNQ1+it8990H4L7qzSJgiyR+Ltw5vb4V+6jgldAzbYcLacboNXCy7icTQROLfMEN0X/USNc+TqTvwdNjuXHDV2CV0ZRrJ0lyyCyNI6WsOm/ii+kOkqFr3nhJ8wka8tQHa1V6TRJ+H5KAO2a5qWqY0Nx/Qhi88pI52lRty6QI+iNp0lIe/RbkXHxyl4oG82yuc6lI4c3AAG3CZfXF7Tum/emKJCU9ELVrLq0HGUpuXxBm9+MjyeFC5hu/5eZZUua99pKg/GiRsKcgIgRJ57D7ohYh2NJUzbNHMIgrBXNq61ZxYJPjnxM9a+fxAQeTqXPhzMLfMGjDVQpvzNvZiCFi4b1ap4VP44+VU1tXEdlmGyYosX5QiWtqNr49nOCh6Bhn0x4FL9WLlskdGJm87Wj5qEVlKUdRHPURlsLoqWppTv362umW0iWyN4Z9qHLdiADo92Jlq7/EBnIymKFplhALy9z
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(366004)(376002)(396003)(136003)(230922051799003)(64100799003)(186009)(1800799012)(451199024)(54906003)(316002)(83380400001)(110136005)(38100700002)(2616005)(6506007)(6666004)(26005)(2906002)(7416002)(6512007)(6486002)(86362001)(5660300002)(478600001)(8676002)(66946007)(66556008)(4326008)(8936002)(36756003)(66476007)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MJMGH3fFnzIhD7LhJk2JLHArUHcETl4Wd1Roc0u9KySxu1YEKtZZINxpLieo?=
 =?us-ascii?Q?raxw1BWvLOY6LtTtQQ4VTKmNVYKMhvChl3/XoCRAdZQ0UrDEZ1DJvp5MzhdR?=
 =?us-ascii?Q?2UrikpYlkmcGtAsZEh7XxFPYFMJhI//c7Dq61+ODPITnui6WyKDT+RGFnHc9?=
 =?us-ascii?Q?Azwy5TaxYqePEByb79kYKYC4QJGPr8Mm8FKqdAPM1S+63oppSd2OAPtPF8Pu?=
 =?us-ascii?Q?RNOqh5zBDkZRc9uuchP5TnHQcMutbEKHgAfNGiEAmUvrZlo2wzVw4bbyrEQb?=
 =?us-ascii?Q?1uGueNZpQRTTYEGsSyphOZDJ5HOYOM4kTTPBxwXeQ+T7flZ3i7SzS4LGTtVP?=
 =?us-ascii?Q?fAK739RZXeC/We2wUhebBchzuvL8L3C5oSbUAx3wKnRHT0yTbO7yf8H2YCbI?=
 =?us-ascii?Q?Gx58mbAa7/QrVBNVg6ACtwRph+7cONMtfDWg+PT+xq+uafs58DKA0UGHg0D6?=
 =?us-ascii?Q?4Vu+jf/g7icfuaIXafLR2zrdQ5FZ43PzkilmUsflvNILL4yPjSCFY8U6k1nK?=
 =?us-ascii?Q?ubCOo/S2Ta8quP/C9IWr+Lw4rs1GudRNPnZ3jBFVO0WjDNYmg6i00Gc3Jyfj?=
 =?us-ascii?Q?5qWXdadgQfKM+NOb69Yp1oolDD461Rp+AvqcfdHYAAvfFgiaGxdfMS0Xgna1?=
 =?us-ascii?Q?TA9TlIXcn17O4GtObhaV3cwhsjOH/akVSyZqwb1Q3rHUTB1kd2Ff0b23Vkxj?=
 =?us-ascii?Q?YoTA6isF+LNJGPlPXrpVBros0ac87b/RuJBCDx3en1qfwl4Ds8ougHOU4CQo?=
 =?us-ascii?Q?ZJ2UCpwNr2DMS3B1r8muXODIaBvRNJdEtuiumQwe+Q2FEPwcZHc3MyzYpdrq?=
 =?us-ascii?Q?rjoqw83pDHJvLVHxBngQ/mdny82pwFzNjGRTsa8hTSOTLpLXJd5VpmD9dgSR?=
 =?us-ascii?Q?B+OzjuXt5F8kkp3w0B8HdLBO4g9PD2dL1PufPbX92kENxWVYSFQSmgt+qzh3?=
 =?us-ascii?Q?3mcBXqKDdoXJzMiJulSIP46PNC2FNvRmkVEZ/xTrsjNYmoj8eqc8cfl4Kvog?=
 =?us-ascii?Q?ET9jX25RVJIRb6YjgKnOgxLTFLITjFseTbaKT/YTTq+gweouufhZSiQtkBnP?=
 =?us-ascii?Q?2HzMrqivT6McyUK54lDeqpRWib40nytPZK9XXmHmG3TDi4/fKucQN9qVOjGi?=
 =?us-ascii?Q?0Qhbeah8c6VZYtlPfID6/HlsaZH0crljk0EgQshUJRbpHiY8UzqKvb6uzAHf?=
 =?us-ascii?Q?ZPy3mrfoUeTbQhWcN4vKO6egdnLMtl8e2QeN6sOPz2SQxIETb3mbYPxUmVzB?=
 =?us-ascii?Q?KeHLDrP6O8CFZnZ2sN7RFWxCKnRAevx0p6OuXocbylDv2dw04u9F7F+Ru3yG?=
 =?us-ascii?Q?j7sm8I//YPnKDvdI3Jut4ljMh0espWF0xJWzI35a3HJcrctCWgllMACV/qtg?=
 =?us-ascii?Q?J5lannY9fquKTVwCF3/qCoF8UnfyS5Wk0rb3MBn+P3IUdYzQJuzoiOgaFerl?=
 =?us-ascii?Q?qQOwGOLfVpkOZst2JrgQ8CNPYj5WdGE54TnmA+huhgSQ9oUElBXMch+E+3DP?=
 =?us-ascii?Q?CwAHjuZe9SNSBD9X+halF0XFkXV7RGH8b8Tfbu/z1eaM2G/klG+dOQCxQZtX?=
 =?us-ascii?Q?yJaVmKiMprZHYXe92QlqthnKsdRXtfLo8dS3UsS1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dbad165-385a-4cc3-5874-08dc272618bc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 15:12:55.8158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UBLWSZNW6hCn0Z4+JsZawq5aN1/kDcLACRtTGEoC5p5iKnEH3FPArQYd/2De7IQi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6733

Introducing global statics which are of type struct iommu_domain, not
struct arm_smmu_domain makes it difficult to retain
arm_smmu_master->domain, as it can no longer point to an IDENTITY or
BLOCKED domain.

The only place that uses the value is arm_smmu_detach_dev(). Change things
to work like other drivers and call iommu_get_domain_for_dev() to obtain
the current domain.

The master->domain is subtly protecting the domain_head against being
unused, change the domain_head to be INIT'd when the master is not
attached to a domain instead of garbage/zero.

Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Moritz Fischer <moritzf@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 26 ++++++++-------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
 2 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 133f13f33df124..a98707cd1efccb 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2560,19 +2560,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
+	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
+	struct arm_smmu_domain *smmu_domain;
 	unsigned long flags;
-	struct arm_smmu_domain *smmu_domain = master->domain;
 
-	if (!smmu_domain)
+	if (!domain)
 		return;
 
+	smmu_domain = to_smmu_domain(domain);
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
-	master->domain = NULL;
 	master->ats_enabled = false;
 }
 
@@ -2626,8 +2627,6 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 	arm_smmu_detach_dev(master);
 
-	master->domain = smmu_domain;
-
 	/*
 	 * The SMMU does not support enabling ATS with bypass. When the STE is
 	 * in bypass (STE.Config[2:0] == 0b100), ATS Translation Requests and
@@ -2646,10 +2645,8 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 	case ARM_SMMU_DOMAIN_S1:
 		if (!master->cd_table.cdtab) {
 			ret = arm_smmu_alloc_cd_tables(master);
-			if (ret) {
-				master->domain = NULL;
+			if (ret)
 				goto out_list_del;
-			}
 		} else {
 			/*
 			 * arm_smmu_write_ctx_desc() relies on the entry being
@@ -2657,17 +2654,13 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 			 */
 			ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID,
 						      NULL);
-			if (ret) {
-				master->domain = NULL;
+			if (ret)
 				goto out_list_del;
-			}
 		}
 
 		ret = arm_smmu_write_ctx_desc(master, IOMMU_NO_PASID, &smmu_domain->cd);
-		if (ret) {
-			master->domain = NULL;
+		if (ret)
 			goto out_list_del;
-		}
 
 		arm_smmu_make_cdtable_ste(&target, master);
 		arm_smmu_install_ste_for_dev(master, &target);
@@ -2693,7 +2686,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 out_list_del:
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
-	list_del(&master->domain_head);
+	list_del_init(&master->domain_head);
 	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
 
 out_unlock:
@@ -2894,6 +2887,7 @@ static struct iommu_device *arm_smmu_probe_device(struct device *dev)
 	master->dev = dev;
 	master->smmu = smmu;
 	INIT_LIST_HEAD(&master->bonds);
+	INIT_LIST_HEAD(&master->domain_head);
 	dev_iommu_priv_set(dev, master);
 
 	ret = arm_smmu_insert_master(smmu, master);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index cbf4b57719b7b9..587f99701ad30f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -696,7 +696,6 @@ struct arm_smmu_stream {
 struct arm_smmu_master {
 	struct arm_smmu_device		*smmu;
 	struct device			*dev;
-	struct arm_smmu_domain		*domain;
 	struct list_head		domain_head;
 	struct arm_smmu_stream		*streams;
 	/* Locked by the iommu core using the group mutex */
-- 
2.43.0

