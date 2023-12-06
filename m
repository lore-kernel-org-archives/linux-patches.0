Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD965675BC;
	Wed,  6 Dec 2023 17:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="cTjR8zb0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMcinf0hBL+oARYEB9tW5oYXUez1u3oeaUo85XR900npKvvFep2kblaXEqXq62vyKroENHCA4oOKuRNNXdwP2XI73CtdTSke+XJnmQCcQbPJwCe0uNvYLw9s+hxZUVbQ2zCnqRN/nVLrsbFLgLUKFtJwyB11uukSGidekEJyRzB0dWmb4EpiLLGNqZrfdsH1AFrvQN7/C2Ug8EfFQoLe4bk3ItnHRchEmLmF+cP18/d0dxUH8FrPE517Ouuc4z06EieQz4JYxwLUqn+IP4c6hLgNzGRoDPIhqI1pPcAbbqgt9ctabgZ5JUtv/J5nGi51Wty+7EyHErsi13xIv+mv4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p3rxQR5ReyI12IY96LBqICVfizbG777B0eb+yQcJlP0=;
 b=dPxhDysNxPK0BsLzE/HXnIMjTuKjvi2yXo48UfTa49u1UtP8/hYHJsPwDBNuOkUOjzP4ZBDQBMHbnQO1PQCBfkDajGZUGWJCgQf/mp+aBOI+GtrYl8XIxGfgrEiwGddqS72uAJoeyLGXvC7yTIVaz6BS3xfD8tBHaoHWHAWG3KFQh/oDSgcrYA+7CVDTE37uIEjlXrjR+sHfvOFLV2a1+OqxEAA2rWxMFLpkHLV/Y6+YMrHNVk6yMl0fYmkyWwK3NKOWajiJEqjCh7z9BxdHkD7R1A5nJs8l4ccv7mQWvAEs2CfbpCkmJvR1DEcL7iVysUKcaWJTXEG1S1tL2PaIgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p3rxQR5ReyI12IY96LBqICVfizbG777B0eb+yQcJlP0=;
 b=cTjR8zb0F2q0q7HHNQs74SBqPHb5W5Ewj2k2MGpaVVa0Pccnnr1p8Wo2OYXfON967gPCDMcI1Q9eOawj5nOCdqMI60MrbiHqVPtfbzPmJk193Pl0kpmJcz6kXVeNac+4NW2+3B4lVBsLaoNQF4t5lvtPZa0jVKn494indQu8oY1ooLVdcImX6320KMSvbR6TicWvoj1PsWgD5HKjMY8MJgGnVSHlPJgo866cfShyNDRvxboPq/x7SdicIwOZMy9UOKGeLxwV3IENfzWD5CDJY3a4oc92hkPh1bomTFnC9FJShJNRc6QcHfr8IQwcQ7tJxviTjN7Vs4z3AvLVq/B7BQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7364.namprd12.prod.outlook.com (2603:10b6:930:50::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.25; Wed, 6 Dec
 2023 17:28:34 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:34 +0000
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
Subject: [PATCH v3 18/27] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Wed,  6 Dec 2023 13:28:24 -0400
Message-ID: <18-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7364:EE_
X-MS-Office365-Filtering-Correlation-Id: 82d38760-fff1-459c-6071-08dbf680c5c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	aV1Wwx3fCnC6BG/fWF9yZ45Jl9L3mQnPeIUp8ylCd+PzyKP7MJAGdHTb6SS/nyQ5iaQsxc4dKBqKzr0Q6T+n5gXrYuDsf6+PuFpBvcxRBHxIUQq5ItCx9zUd0iGnd3dXYgb0EoZNmaTWO1xmwFO1X2Tr8DyGvjnWLMldIlc4lIc01IC5NJY5D5vsJQ1a/iUWAaniiy+omjrFW9GIsKuJLUToTMlIFZ50rSZ911nZhmnpQO9y5UsadUXjcCbPkEkw5NQaN4nZUQ/ay3npJ9yACGKK6k2J12vM4RuJo9e2rp60/NTQHOx1J68mvmmAQkneCJDPZY+nio3DuAoZf3AA93ltJFzO5oamuPPXT0AWo0j72UKfr61w5x15xVwdq7ekV1FZef7Ujr1Ww2zTwLrCTN2j7FE0ZeJU6OQaBA+e6+926CXodESkj5yRB9TGLBoPN70wzObNeQ+uVlEnMkAQ+ywRCNFDwSlf8v0VvRu6B8fjdQXj1TeVmL459oPh/C7rOJI+QnuTERZrE3Ycv+Evso8EPYI7ipqpdJ4Kdl1NLGAXmmTP5iZVH1c2etHCmrtX
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(396003)(39860400002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(8936002)(8676002)(4326008)(2906002)(38100700002)(83380400001)(7416002)(41300700001)(36756003)(86362001)(5660300002)(6666004)(26005)(6512007)(66556008)(6486002)(478600001)(2616005)(66946007)(110136005)(54906003)(66476007)(6506007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Kt1uN62LTTkaawu/fsm9lTFaQkZekTL5SvuNJo0yoJ0K/fp4XUrkZIjFv1z3?=
 =?us-ascii?Q?C75XS7DJfNrhWBanqWIuIH8UzLgME9Vtbj6sZM+Kb2ORRk26UL+WeIsMqMFS?=
 =?us-ascii?Q?JnG+pdq+tc8uta52YmGVBCoJDAjaZQs5UbzyEjOLnteYbNaLcir2v1bf9Ljp?=
 =?us-ascii?Q?ZKUj7nsNwLELV9aVQiobap8s4E4k+ITWi4alMchGTbPFNiHoz85iSjfNM8gr?=
 =?us-ascii?Q?Oh2egnm6HomLXUOFy5TxFifsDndG/VHf+OYJ4X+jytpWB360kJR8Nfx0tNuB?=
 =?us-ascii?Q?oPgn+s+bXDG6NYlE4ozXvHo9bmW7Nc1I9Et0xf0Gb5ZCyTGOFuZ/QzQKnNi6?=
 =?us-ascii?Q?Zic2ixpI4dxFeJOX5u/8X0KsE3vRMRcsilErJnjhjyFz0oKJYwH8k1cjbxox?=
 =?us-ascii?Q?FvKd0Q1YYXWKKxrPUY3aCQ1kEXXrU2Cg8u5tpVStKnKmRbQ03gN5MumRvtzZ?=
 =?us-ascii?Q?q/5036bgmmeSyPVdI4AeWjo5711EnpYS9UpeBmW8ATJfqYPzvLJZfNplhAPl?=
 =?us-ascii?Q?Ffcp+aU48VXE5T6pHPhgBTaoH++yiFm0N//PBKl/rwKMVLK7+dZTpHMelod8?=
 =?us-ascii?Q?GYvB6zLz3u+eVMK1PIFzHoFMmrOU+fU9hpPDcFtu81x5rDyGQp7hMoUD4bRK?=
 =?us-ascii?Q?19CQru5orMRdU+HucC4f8fFtburE0iuGbIGwyYTu0fQxNd8LIVz/MpX59c+2?=
 =?us-ascii?Q?6FugWMZDSEULf6xcRlLKazrMi44+T96hOyAvBzXoHH+aGwMXnRRQI/jxtojI?=
 =?us-ascii?Q?jEk1i+wTOZ4hdrLbQL+eMT7qh9o9Im5uKUxU7h9Vdv7VAia7DgHVIvXkdCx1?=
 =?us-ascii?Q?JKEJ5SJ9kbLLEpboYUc/Q1xXHsF0auJ9dd+lF0wbRlHe7BXTXR5J2EGVAdb0?=
 =?us-ascii?Q?8WZYfGMCgxzJOIWP44Mnmu9AFwpcRh6AUc6zMRn+dn6RzDHgVDP5yLbs08LS?=
 =?us-ascii?Q?50yBKmkwPNsHxG7NsPPlx/jR1xmr2JlV/FRh7nhxBkhb7WQ9Fo/LSNJOyjAS?=
 =?us-ascii?Q?/2ps1kQ+81WkGGI4BJqFugfZOz1BW6Vu9IwHZ/oWs3d3YotAt7q3VNhhMFDN?=
 =?us-ascii?Q?p2H0Vz1HFepgWay0uPH2h3d9uq7oPDHTCQvqHUruE1iLgIdiVUScs02Pg2SP?=
 =?us-ascii?Q?XLZoBLBwPVWKsPW6O89mTvk02vY3SM3767ijKFS2bpp5WQgRSd71E/lZgBIP?=
 =?us-ascii?Q?vZxJ51dw5rNt+3zKRg26+eOtbnMfTP6BkZzFughv9+aDUXEUQd9TFl3mm+Us?=
 =?us-ascii?Q?OufGpD4W3Iiq7Szk7+TPxg/Awy8ZsGeS5bzeKv8+o7B1iaVYR62SsyDSImYD?=
 =?us-ascii?Q?GsHL8u6AqfqDWFC1/29k+TBCLK4naFMuPV+QLShHVSdPSMLtOWly1A3j0jZ/?=
 =?us-ascii?Q?bcTxDJenPAO4Ddb07xIQ74uSXysQ6+2Nj1z/S24qEgwK+C0JuT7dXG/+UWQB?=
 =?us-ascii?Q?korIVfUDhtvxvjEaurdzWMn1dhPxIxxGmuIyeMCAyjEJ3DBi8oliJ1jUJdHq?=
 =?us-ascii?Q?CP9lA6HXZWIHmyojpwUwJE6TINSSkg/WYUuUgta5nKKOz7j2fNvwjuDOhnfq?=
 =?us-ascii?Q?/RgdIpF8Q8C7yaNB/W4JxXmMwba3lWH9iLWbLwvs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82d38760-fff1-459c-6071-08dbf680c5c3
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:33.8370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ag8pXhTYKR/j66B7wmhQDEFa1mH4sVsXPIBLut5VoncaMjxFecHpM1DQ4AnQSsSK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7364

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 12 +++----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 34 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 ++--
 3 files changed, 30 insertions(+), 23 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 2f818b24d931c2..5894785aa901e8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -646,14 +646,14 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
+	smmu_domain = arm_smmu_domain_alloc();
+	if (!smmu_domain)
 		return NULL;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
 
-	return domain;
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a6cd4699ddcc76..5db78e6e03dcfd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2228,23 +2228,10 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-	return NULL;
-}
-
-static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+struct arm_smmu_domain *arm_smmu_domain_alloc(void)
 {
 	struct arm_smmu_domain *smmu_domain;
 
-	/*
-	 * Allocate the domain and initialise some of its data structures.
-	 * We can't really do anything meaningful until we've added a
-	 * master.
-	 */
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
 		return NULL;
@@ -2254,6 +2241,23 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
 	spin_lock_init(&smmu_domain->devices_lock);
 	INIT_LIST_HEAD(&smmu_domain->mmu_notifiers);
 
+	return smmu_domain;
+}
+
+static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
+{
+	struct arm_smmu_domain *smmu_domain;
+
+	smmu_domain = arm_smmu_domain_alloc();
+	if (!smmu_domain)
+		return NULL;
+
+	/*
+	 * Allocate the domain and initialise some of its data structures.
+	 * We can't really do anything meaningful until we've added a
+	 * master.
+	 */
+
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 
@@ -3207,7 +3211,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f72aebaf95f981..c1181e456b7d5f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -765,7 +765,8 @@ to_smmu_domain_safe(struct iommu_domain *domain)
 {
 	if (!domain)
 		return NULL;
-	if (domain->type & __IOMMU_DOMAIN_PAGING)
+	if (domain->type & __IOMMU_DOMAIN_PAGING ||
+	    domain->type == IOMMU_DOMAIN_SVA)
 		return to_smmu_domain(domain);
 	return NULL;
 }
@@ -773,6 +774,8 @@ to_smmu_domain_safe(struct iommu_domain *domain)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, int ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
@@ -805,7 +808,7 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
-- 
2.43.0

