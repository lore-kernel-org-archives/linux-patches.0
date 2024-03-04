Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B67A7D3EA;
	Mon,  4 Mar 2024 23:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595877; cv=fail; b=Pf0pkPVAyGUXoaDHzG4fOGb2M2fuU9jxbXJlnjERi2TX547XPNUPxFjK+owJwl3ZOUOWbdLGus/R0B8DOussiJwyOKTQTvAgaKTBZm7EjsP7Ex01UcdAQ2bU4E8uU5MIvN+3B36mrfFQOZ1MnUUDSyAB6Pxc+VSogXwb8X3KXOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595877; c=relaxed/simple;
	bh=YJEEO7VUzoJ63KZPH9JlGIKeZu+LV1XmzbItBEEXjqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ef8UaP6VodjcAD9fxPt8p/tKaBaxKgckw8OJjVnFHvaHBCSorTMyvF/Kb/PAsgBhKEewzRpwul8GxCqOEA9Z2SJGInjID1aKjqBIqX6jPyC1/J6PHOaGe8YCDIXk2CHmW7PEgFAKf9RNN3nzBoZqPdVtHmza3wRvQkdxE47wL7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q/vftsRt; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q/vftsRt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P129rT1tsOI2S1xX0e/o4FIa5QEavFutLVIYG5VNeRP0dl4hMMU+OVUb7iXnW2pxNZl1KYiIG79Acm9N8mUDJChm62X3zvWm3+gVZ8aoa4xKD5hGE+VCEmV5eIlXav+lgXUVXnQHPnHC9SBGj3PXWiWnhNH4g0ICEdY/k7FnCIzyg6tkIs0DN40l1tWd5i0R4auEPmrg5nVehMSFszj9KeCT0Au74pg1b1O1PZLrhk7BholjggEXqQOwbLAIsMi3Aw/p7bGfN+pNF480v4A+SeVX+LvGTvFPby2pi8xZni45jc2+GoX5eIoyi1XaFAhTv30W1SGkRi1AXTcHNDKQuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cOo5/ZtnB4k9EoUv3CZhd0c+iW3BoAwAPvBhbX299gA=;
 b=mOrrqn3yhfyscGbTWnX1MaUxy9Cn17zQCpR3Ivj8ZW/3jxRljYoMtEegaw/JqptGZn5mgtOPUhL0rwevtmIKOhL2/XLqgwAxiFnkTdFP19B0HX9Ry4yr4Pb+HCKhmtPIcqyPZReVNcaZTZtIisSqgNqbcjI7UB4RtQHIlwMdQ6XUHSQZUsE0CaZ3zjQucPzy/t4xbeSg1kDHPNA6FnayhITJ1FpsXiwKMn/6udFa07iYP/dNkIAOxNiFJ3t2plP1rZjv5AY0oa5Rv2EH7KZanIYdJVmJz9RvuczFMHyDwMvpOyW6fnQNC84Cnz1fIqBvpDCa5O18eF7G6VcaC5Hbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cOo5/ZtnB4k9EoUv3CZhd0c+iW3BoAwAPvBhbX299gA=;
 b=q/vftsRtJeLQDG31aG+FBhaoow+Ng+P1Is41SjI8AfgGrv7Ob9hCDM2PJAAPKM7c2176IZqUhd4v8Ig3lxqWZ6okp+6NIMYQXv67//h/AOOe4jCBpDoTr7s7InvSFU6oORc98Fj9iRRJsbEYV+PmPf/lCDKgxdPoRGfbwldQNumL9bTvasRNDy4Src3tvoDJ4PNxU/lf6Gqex62IW55BwlJmnrhnYwWl4h27m5eJvb6fq/OxRZBix+7sivtBSQP6hG8hTdJFXG9Wm1DbadZu4Z88eu6HJMUl3GAChTkZz2C2syickX9c1WS3QLZysRvMpISOuGYZvPpGmlw+mrs3xg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB6584.namprd12.prod.outlook.com (2603:10b6:8:d0::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7339.39; Mon, 4 Mar 2024 23:44:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c33c:18db:c570:33b3%5]) with mapi id 15.20.7339.035; Mon, 4 Mar 2024
 23:44:25 +0000
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
Subject: [PATCH v5 18/27] iommu/arm-smmu-v3: Make SVA allocate a normal arm_smmu_domain
Date: Mon,  4 Mar 2024 19:44:06 -0400
Message-ID: <18-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013E0D.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB6584:EE_
X-MS-Office365-Filtering-Correlation-Id: 68ecf098-385f-4bd3-1ce5-08dc3ca501fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	st0ItxhNopp7Mx4eqFxuHLOl0oq81sjtoQRsIkGACxwsGqHKfdIoiHMxMrbernonNUzJIndZgUw07gbuCgDNyC/lrMdcTZ5J34XF7X7Kk9JeuYtGDApTmsvqajnYnPBdoTHggrbFrbKuWc2GzNYhuqLV63qhPwhbRolvwA0QY7R0tOHegM/BFNBwcwTWCeSrd2UVCGWhhYQz47fDZrISxLeBbHIu+LzgMvkbuLHkWUmFNP5llZVsl8PBMM8plyvDi3W5JbcK6z8j3jFB2CdWsIGLfTY1YVw8tKHK/3aYK7B1gw555umxwQgDySIGNshP8PsRp3AwU2uEsBRvANVEjt3wfspRO3SaOhhhwpAKuTGLNve3omBAffxM/M5EmwyT0oNUMS9WX4SEMxgjEaKGpTfIe+huBCTrYHhXA/Rh8fhaMlNF3BkyLppXqqIu1cLAx9ICsccN1zARDPQbUyoyqZRi4ELmQK/B2S0E0eYgYu4Gevim3kumL67UMxTeCEGm9OHckTAY0S1mU1M2YcFVKErYoj6ZL0UQ5joEB2u27G0Q2vLTexJs/ubt41CSm0oKul08FxA7IlpYu9C1BcIMBFLB4IqSdTNPGJW7vt1IQYIvrwhrerXx1BfY2y+ySqgnCDkk/17NZsNRYtmRm7p1r0ZeosWnbf5DISIjvjRjllE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bTwoEiEaDZBabmGRQE2yW5k5vmLbP1T0Fl3wC0vMhF4kKKiQuDMUXZva2tzi?=
 =?us-ascii?Q?kZ+5NA73e2Y1J85hRMvQqp2cYCTQV8/+Wwya+AFkmVNHv+TJHd14D7uC/8cf?=
 =?us-ascii?Q?Y4ZkDOiyb8DfAijIyGSwmaAEHcQ9RZMwp+NKd3UGehEK2ROkzX8MOVAGph31?=
 =?us-ascii?Q?/FgCUlxV/yqpr3k3mXdfHaR83CqFvmoL2kJF2PNrHSc9F1T+KPEbdosohzwk?=
 =?us-ascii?Q?a5VFuLxO4ysPMr2rsSX+aahXBB5GkvdUOqi3l0V/dAczKR/RVM70iHqiXtv7?=
 =?us-ascii?Q?n6QGFtQw/FRszds7OsScTRpE+PMFwbef7XN1BWbgmuLOxA4TIAWoUjRxIO0j?=
 =?us-ascii?Q?V7Aj6biKgtc4xQsCzgJmPpNQImu16ACNa4QJh+YPIX8kmcW0A3TK8PSVylrj?=
 =?us-ascii?Q?ac3GWWjZ94nsA8H/2caMWfyAyb6YatiV/TWpqJYKGvNjuw5UAgwXWaIYzxaR?=
 =?us-ascii?Q?kUvMuAmz50N6dyX4NBRbuY6oOtV7Z67Dx7FiI4JhxSajEcKVTIWHDctg+eJK?=
 =?us-ascii?Q?YiOv3+bMlbD7a3MD2wscvOQLfQcoiyyiGnpom2ei7E438Ge2iXmE79ftTyhs?=
 =?us-ascii?Q?uQCMj4JFM7xazJj1aCu472MjpJew34e4oku/A0N8nMrq84HIkZQdTw6VuNuL?=
 =?us-ascii?Q?2iqGQDeTjXJIG6u3cyt7Geq5NfRg+IRRLScVJMl0oJmXcCfv8pm4r961TLOr?=
 =?us-ascii?Q?1iwPvxR05nVaJD6aEzxuwulG/I+yvFiVFwcEI7WJujNno7aja+JowfxDZ8zO?=
 =?us-ascii?Q?syw9yUdMtE/Ygi67dtSr09wA6wGzgKYd8hOztPAW9VpE2wtfMSrYRgdGSx8d?=
 =?us-ascii?Q?7QA8TikfC9hoJZIYSHdVdba8ttZQ4R2oT5fjMr5n+a7a0/fX5lu2Iwbjjmyn?=
 =?us-ascii?Q?yTr2oN+6wRU/HiObJEMb61RHk8p9bj3xnKKo+h7ca4l1QoZBbg9L2FBY5Bjs?=
 =?us-ascii?Q?6UfI1RL988qi7cvsl92+fLzn+nUsNB8Q3dTkFIc3YbltZRzOUMYXFLV5C8PH?=
 =?us-ascii?Q?G6tYAh2GuzUTjlcktzgDh76XgS5CAueVlt9vEE0Fz5XUmP8gRaMZiNFCmyYH?=
 =?us-ascii?Q?1TV44peM85ajD+bmxsOhJfixnSaOpJpY169SBrcVzeZyY7pjLZgdAAwn2g74?=
 =?us-ascii?Q?cC9bI9HRbqaNrKB5bgG4M9vaijEZoSeoU6Lrptjg8atjq/L65RV9Nj04/Irl?=
 =?us-ascii?Q?UwnRYBhj9p0iYb1VwxC/ffy8grNLK039SWY4B/3OIqWq4ztlsrHjGwAE7gVa?=
 =?us-ascii?Q?nvrCrp0xnOn/epsfBHBXUQR4I5emBLMr+LTnkDbq3f9TCRpxB1G0N3zO+eMr?=
 =?us-ascii?Q?n5CNm/MzlXCf73DOba7UBG0rpz4ZK/1QQhQzc9UtWfDdGFr3zlVpaxo7MwBm?=
 =?us-ascii?Q?JPFtKRD0qfhtM5K5qxWszf7hDWoOd8LIUMWehJXL8bB3mZwn3IMGeoCsLODz?=
 =?us-ascii?Q?mammr0eLW45/RBdKZ5svb9WY8DU7LD2UjVbMtW3XYfBdwDBr599lvRzMeThq?=
 =?us-ascii?Q?81CSgMqT1bIQwjS9+Y3HPFxr6/j0lGp7JH7C/83ReT9ydIlENaHFT3KdKia7?=
 =?us-ascii?Q?vhZSRt6noBOGhGsLp+0EHiQJlp73YbcsLPM1up7x?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68ecf098-385f-4bd3-1ce5-08dc3ca501fa
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2024 23:44:18.0983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8vKmzzJmay7KaxNSaKjh70c036cHicym/ScqfQKEo+BgASOU3wKV4Td/Quyqjs6u
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6584

Currently the SVA domain is a naked struct iommu_domain, allocate a struct
arm_smmu_domain instead.

This is necessary to be able to use the struct arm_master_domain
mechanism.

Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 19 ++++++-----
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 34 +++++++++++--------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 ++-
 3 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 82b9c4d4061c3d..d633316f2e45bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -654,7 +654,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -662,14 +662,17 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(void)
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
 {
-	struct iommu_domain *domain;
+	struct arm_smmu_domain *smmu_domain;
 
-	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-	if (!domain)
-		return NULL;
-	domain->ops = &arm_smmu_sva_domain_ops;
+	if (type != IOMMU_DOMAIN_SVA)
+		return ERR_PTR(-EOPNOTSUPP);
 
-	return domain;
+	smmu_domain = arm_smmu_domain_alloc();
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+
+	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index dd7f841cd19b3c..2db2b822292a87 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -2291,23 +2291,10 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
 	}
 }
 
-static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
-{
-
-	if (type == IOMMU_DOMAIN_SVA)
-		return arm_smmu_sva_domain_alloc();
-	return ERR_PTR(-EOPNOTSUPP);
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
 		return ERR_PTR(-ENOMEM);
@@ -2317,6 +2304,23 @@ static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
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
+	if (IS_ERR(smmu_domain))
+		return ERR_CAST(smmu_domain);
+
+	/*
+	 * Allocate the domain and initialise some of its data structures.
+	 * We can't really do anything meaningful until we've added a
+	 * master.
+	 */
+
 	if (dev) {
 		struct arm_smmu_master *master = dev_iommu_priv_get(dev);
 		int ret;
@@ -3288,7 +3292,7 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7e1f6af4ce4e79..c47e07d695bef2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -759,6 +759,8 @@ static inline struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
 extern struct xarray arm_smmu_asid_xa;
 extern struct mutex arm_smmu_asid_lock;
 
+struct arm_smmu_domain *arm_smmu_domain_alloc(void);
+
 void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid);
 struct arm_smmu_cd *arm_smmu_get_cd_ptr(struct arm_smmu_master *master,
 					u32 ssid);
@@ -791,7 +793,7 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(void);
+struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
-- 
2.43.2

