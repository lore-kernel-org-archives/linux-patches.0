Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DE367E93;
	Wed,  6 Dec 2023 17:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="GMia8uFP"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9x7HLZP8tkQM3r3fJ/xzzgbjMeqbiiblI1xZfLQMUbl5Dp5LfxD5yQMtVx1h6nnHv+PaI9BVd/Ye3SjuBcnuBb6b+Vc8n2lMF8XobD/aLpAjuEnqzkiJfVNgTju4RGu00wsWhLTMwJThnoplYrNAZi4Zphv0cRC7CTVCAHuEGSZP4sPt+UQB1G09gdgVV8BMq1m0sKJ8a+8tDCZuZq73Rd7YndYERk/MdNtwoPX8plxkDUs1obKj3wIK0GLRlnDI0JcEeFZbCINJ97vnF5QExK5xB6c8BFw0XI7DR7iteuFwudjC6uV9TEEP/KZ8Q9uvaXZmDbkqDkLrgcYi2sIMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4P0uOcMEkquT8nUC4TUk/YzRXYLI2mKWd4hhBUDzMRs=;
 b=UB2WsteKBJy7Xhp66GyJsD8phZ5yFzz92DUdsWi0b0YDm4lW9TVXp1wvsA922xs3wW26RAa2yt54PSCWLnDTtstaCR94ZI98fWykzaEqzbwirKke2dNLBmo24xcBLfQbeaInkZlZFmAx51pi7ou+P+Oy8jSMHf2o2LWuYQ8EE88590IszfBxAzWCA1v2NekRrOI3X9ZOWhl2uV9tEDB+FQCvI2PxM/zhKx5hNkDM4idMjid1OGpiQiuEHtyc9uORnb3driukNyN9wguW30OqBgzTamC3q9Z5itgkY35/6UqYx12H+GjDPs8Xv0ozplrYIUY6dDTfFc4S7J9wazmWrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4P0uOcMEkquT8nUC4TUk/YzRXYLI2mKWd4hhBUDzMRs=;
 b=GMia8uFPllH631cANib1m++xOh+zrKjT1JtXlOOaMTG9Rg+RTOdiAqJ1VdXu0m6SSpS3wdwRM/zwm2Q8FWi3ZCYsS67zRFY7JLcRR6cHCPNi/PdgBvF1kbImYQmfStfR0xERiMu9KQrXJoaJETc/1op93qABL579RYM2aMI+0ByrMmMpGdmv2reIqa0786Ri6UKg3jBVUkQERE8qsPRoK5a+/mMC9uDizHUmHV+2jyTtnDUYR86aOVfnmfO2sQvGgCuLULvb72VMbd47VrJKBwYsW0n4QGwjZHxYImq55WA54eLE/JDBgH/4siyIr/ReQ+7c5lpeKF+/eqtlQcYLtg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:35 +0000
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
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH v3 01/27] iommu/arm-smmu-v3: Check that the RID domain is S1 in SVA
Date: Wed,  6 Dec 2023 13:28:07 -0400
Message-ID: <1-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: e88347d4-2b4b-42da-37ab-08dbf680c5db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ejgc5lL9+XflL52xYkIxg/96rtDLQ/F2rJOozAgGAe5WEXqHP//KVBNimP0r8CDzQdrAonY2cF3NDG6VYWwpqbXPv7JP6Kzjy/PuqfNrIAxAl3TR7bIZQ0dtzq2LmiikeOwmh5eBYUKNfoQo92y8tLmOXs7atVdk+5Rc61F8oUXm3YTRVWLtZwvjNmCHfWpXbWKbR/H32k0tganvhJOy55z51j29xHIqAL/3r4djKCPRcrDNVBbf4EeblcIeU8Ls38KOG23PPFkALJI27dDTeeofNSajP9VecuavCf5z5nHWkD0OL/Gsrk5VtZfSzigUTgZt4RsYreR3+gk7xlBaOaGOCYFu1MQubvarBdb1Tm9D8BhFqjbxwYePhRPTpi9oaKGm4it/baxuZCILUlB+ufoqXbQwaku2uS/VkYIoejIqWkRHB3aO/SKe+3nm3JBKA30vIYB1qCr1iDzcqSSyBezO3K5FcztXvdqNbTkLOqzqyfCxAYja/IFdCZxC7UfjMlthvTqD/124VS5QGKbSNDSbM5gBiW1pf0GuAENPnNP4f9Cs+8uA7YH9CyH/hNtmjmjWIimC3PRWyav1Wf0w7fMM22iInGOlFmlnhenKdNo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4JJ6H8PnI8TXwjavVbzolKlXyZe0/OUu0PbVsVN6xgmDNRnqVwIaRvi5hfaN?=
 =?us-ascii?Q?OBKTvOZ4xOOr92aR6xK/iUyRkfJqO4N1KmOINtMn2b/tXWd/allKXXUJCg5G?=
 =?us-ascii?Q?L9IOT4pwVBemlWbrTnvCdfyoAXhxGFxswl4hCyhuAvy4af8Z088Pkk1gdW6Q?=
 =?us-ascii?Q?9xRjThhYrSUSI1LaIi6SK+UQev3EWx5JG2yqiOWW4G1AgmUYeOWEbYNIIUiy?=
 =?us-ascii?Q?AlZOP3gTNw+v1pl11keK9D6BLnpe5eo4vFvpvsezxN3lbm+OBorao8mtVdtp?=
 =?us-ascii?Q?dInv5DdhW3BDbVfpRwLiY1l80Dgud+bIgih3fA8tAh1E44DX4lxk9eYu3goe?=
 =?us-ascii?Q?aZMhGCcJYCJI+arSy6Zw+8u+r86nR1FeuBmadhlEfDrXQgsu313Tz7rfoQ/T?=
 =?us-ascii?Q?Z1M69uMn1gb+12gNyJXP5wiQt4EavFL7XpOy75LK2EHPABC4GavaQ2JONY3o?=
 =?us-ascii?Q?nFFg4fRph4IZeg4sPTY7PNjSTX/l/z3YoJmJVyhK4RS5rplu/rSKv6Ej4Zc7?=
 =?us-ascii?Q?kSpcbRKkqLWKgoKtO8g+WLWAKddbuj3TQYKvF1hbZAvOAOHdI7mS/FYDljit?=
 =?us-ascii?Q?fR3uiIkHuFKrQjy2FSI2uw4DH6NZ6dQFOU9pjUznp7NRstnHl7dd1B99T7tW?=
 =?us-ascii?Q?J3d/fVMq5HAKoejL8Mo+HcnQkvkJfTeIx0xtWWbE0GFHArPNGkN3r1P/exbe?=
 =?us-ascii?Q?tkUQWnPDoqGZ//qgt1tzjU+RWh6F/ih0pzmIbvsAvtR6v4g0VdJFbt2RHQX9?=
 =?us-ascii?Q?pJXC8hnhkPdDSa4ODVFs6fYxjNC5LPKkc6Wewrsp1xyqeTKD+NqRB9AinNJ4?=
 =?us-ascii?Q?qopNDzafCXyFaumVVVWmPxAOk9/ts7tEUgNmH62fGwr/64k/XLQHWsmdI1+8?=
 =?us-ascii?Q?lcphG3I2r7pxCJEZk3VnZXqI1tpnoojzMFfwgF9O/vobOvWzUA+MyCeZr5fI?=
 =?us-ascii?Q?AHerLFF6yWenQR2V21Fv3tkwQB2mucaw+Zy9XE4QP/Ayi991zx4WilIsMv3B?=
 =?us-ascii?Q?uRx2gLpmz928hjIOwFqeFWSXf30BO6CVDjhBM+Tvv/VhfV8qxN0ZdQpvhsHA?=
 =?us-ascii?Q?yV9NiOnwG0TczzB3JHmIOfb5WiXRLBuSErUiO17K4NyH4Y6fyGpyLEHQEj/K?=
 =?us-ascii?Q?mPjn/tZb0QZXgGW7hVf8EL9h5yFQVfOvUIVWWstfUkr1UUWFJcSGPvirzyQI?=
 =?us-ascii?Q?/GEyDYH1Hgy1LD+tedB4qFXnfTcmZDIlsw2W8M5AFjRCQcislpibK5IGVp3G?=
 =?us-ascii?Q?SE/N45uNNkC4e/Su88sdI+LHsXyv4HR87QyGgsxN6pW5ZgUnPev/PyYD13q2?=
 =?us-ascii?Q?Ev8/+F5Ojy6zDdC+x3uDiOMv7g03v/3tekQ0neonte6RL0xsgbMB3R3mGniQ?=
 =?us-ascii?Q?OvyrDJUe6REeO2g9JOTLb3/eD8bBAo5ZyJT53NQnzium98AlBhi21/uBdGWa?=
 =?us-ascii?Q?31nZ/TIlW9QfVQxpKTrArA0pF5wo5rE+kioAPq5Z/gsppFYTTjZB4wN07a4n?=
 =?us-ascii?Q?xFcy7ljBZBQ42Mw30j5SQ5vH7wQAR4qZ5m0JQt5cD7cfsoUAZ6dBLVuEf+Bo?=
 =?us-ascii?Q?itRc2ZQRFGbZqAH8+C2Ib//6HkNsXTIF+SHOotl9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e88347d4-2b4b-42da-37ab-08dbf680c5db
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:34.0356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RHveC0IHE+AmTLcsXxVWW8TfaxImugZsflEBIpNdPxAajikY8azhJJFBtuxAjLEn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

This code only works if the RID domain is a S1 domain and has already
installed the cdtable.

Add a to_smmu_domain_safe() which does a robust conversion from
struct iommu_domain to the struct arm_smmu_domain.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c |  7 +++++--
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |  7 +++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 353248ab18e76d..bd0566381c58a9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -379,8 +379,11 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm)
 	int ret;
 	struct arm_smmu_bond *bond;
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct iommu_domain *domain = iommu_get_domain_for_dev(dev);
-	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_safe(iommu_get_domain_for_dev(dev));
+
+	if (!smmu_domain || smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
+		return -ENODEV;
 
 	if (!master || !master->sva_enabled)
 		return -ENODEV;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f3900a3d52524a..0f3bbc4a2addc8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2486,14 +2486,13 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
 
 static void arm_smmu_detach_dev(struct arm_smmu_master *master)
 {
-	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
-	struct arm_smmu_domain *smmu_domain;
+	struct arm_smmu_domain *smmu_domain =
+		to_smmu_domain_safe(iommu_get_domain_for_dev(master->dev));
 	unsigned long flags;
 
-	if (!domain || !(domain->type & __IOMMU_DOMAIN_PAGING))
+	if (!smmu_domain)
 		return;
 
-	smmu_domain = to_smmu_domain(domain);
 	arm_smmu_disable_ats(master, smmu_domain);
 
 	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 154808f96718df..6f62184eaa2434 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -740,6 +740,20 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 	return container_of(dom, struct arm_smmu_domain, domain);
 }
 
+/*
+ * Check that the domain type has an arm_smmu_domain struct. The global static
+ * IDENTITY and BLOCKED domains do not.
+ */
+static inline struct arm_smmu_domain *
+to_smmu_domain_safe(struct iommu_domain *domain)
+{
+	if (!domain)
+		return NULL;
+	if (domain->type & __IOMMU_DOMAIN_PAGING)
+		return to_smmu_domain(domain);
+	return NULL;
+}
+
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 extern struct arm_smmu_ctx_desc quiet_cd;
-- 
2.43.0

