Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2044.outbound.protection.outlook.com [40.107.244.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C361692B6;
	Wed,  6 Dec 2023 17:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U4FtBIR0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcuKrJ+eHCsnatuGwtUBt9ag7Nz9I5A0lUJvWSrzT5oe8cb5VV42nCJYggzD1x0sN7K5tQPd7ncI71OUPrMKVWv8axGV79pGbCJ3APcb03zipd5RVGtzZN55Xs4EhTBK91QrKgcKiekaps95s7F2Deb7u4rt1jW4HX94/RuqqQTe+m0u5uyjtyNOolmR9Y/QSfAT+bwl39yz5PQVyuMt2OX1emb6mcppQCLGPS3kclVMZoodmES7TNTMflL3wWHBLQrCDhETpzNKdFum8bgHaaO8xRyqtv0X4v5r3vIPe4Npx3YvP3S2S6MA4koKS2qs2p2JL8gcm/xeAa3J6jzybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OTGz3qIaECpLc7wVaNfV9wng7AosVZuvH9ccjI3ex4=;
 b=DLitG49i0X+9/3tCiJCnjNIWJ/ASzxjytoPMx3GRu00uykRTohVvnJPxi68QaXrWaaijYSw11vYfAh90nTKz3IHWEFU/4clK7jiQeYQHTVlpuagHpIJmaV08ywiUozsma9kiQavNyfxJ+KlW8f3sphzTT8d1YNwvu8ia93Q9YYGxnN2TDPbj4dMIaJRLal8P8eNcoBqldLy4n5DJ6ZoK3V8BuId3IkPeFNOqDZx08r7kxPXFAAwa4JuRvt5qtovz/vbjPmc768BNbBbsmp0BxQCB1jCAt1Q9B89Sz4H6pYkCk0VAOOD5q7urTKU2A/T8x0oEJi8qBh6TnQj+0SRcVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OTGz3qIaECpLc7wVaNfV9wng7AosVZuvH9ccjI3ex4=;
 b=U4FtBIR0y7nAQmixxNthsTtbsru7L97GUD7Qqy0GAX8vd4QYAI+76HVGy6syOpLcOOJnHEFTAQKtXSmhuRkmm1awHOvZGm5C5TbDOAbVJT838brWSb91YI7BFgRfCzz6C+q9DnEBRn6Q9XggZomfazXz7KCQX/HvlPdbV6BG9MYv+z1ONznHrMX9IuuEOp30QCjKyCR+Tp4gtftIXTPeHWhQsTXYQU3voVhXgdpWliq6EwQ69maq/tdGY0UW2+j2SNlfFMgmD3llunEPULvRaD7bXEV8HImXlB9LmHwBjgVHxz5lAoa1lH4+aXd7cRpj2dmBAb599vXu2jJzgYbcDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.34; Wed, 6 Dec
 2023 17:28:43 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 17:28:43 +0000
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
Subject: [PATCH v3 20/27] iommu: Add ops->domain_alloc_sva()
Date: Wed,  6 Dec 2023 13:28:26 -0400
Message-ID: <20-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
In-Reply-To: <0-v3-9083a9368a5c+23fb-smmuv3_newapi_p2_jgg@nvidia.com>
References:
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0017.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bc88469-475e-4831-66b5-08dbf680c6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	N+K/KGbpmAfU+DZA4YRcMmHkSSrZvtqy/SCM2GnPnv/hzsKkVL0ioqaVCNMP6a7O/Xoo6TckxA0Zz6A5vgJr4laT+ktyp7ZOZj8qvOPBAJ8CSro8eS0WnM5oVEJOJJ14ewTAzimRdoaUg+YNG2kvls2zVc25gUrHHCI9JB10p3zMSJxMYexxZeg9hr93KCAOC06ntVGRu8su7g9HYmgeCsP4XAya/2CuIkNbZAZq/3MR5MIsYkRC1QqXC1RSYDBkEYp72qnp5IXkHDJRfYA4Pos0cXnwAQCoOQTfciKeIEYVLtO42fT+IdB6z2rSkdDhsGY7Tu4xe63VY6iGnkNY+ZeEgag2iUqyS75ZOEAidIOXEOXpf5qCXA9H5Y98bguJRIZeryLxt2l1V/85avFoIc+S/XvfyMqYado3+IEJS8PSw8XA8zbkNfzv0qnNRATKr7nZkSooE/3EbdbShOnAEzdmcy7lYcdbscw2BulgbTQOKQspI5ekmrCxszgxyvmf/bRlLR85ptSkXynZ22SclJnWlR9sI1ZdavE4v+AEODRZQlLqC0stzbCCTILfUrA8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(136003)(366004)(396003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(6666004)(6486002)(478600001)(38100700002)(83380400001)(66946007)(6512007)(2616005)(66476007)(6506007)(8676002)(2906002)(4326008)(54906003)(7416002)(5660300002)(86362001)(36756003)(41300700001)(66556008)(8936002)(316002)(110136005)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?dYOSobRA6pt+aSr70d9GYOXQ0RHiBV6vv4xF7uQjdCRENODCtr+HDnLzs0uz?=
 =?us-ascii?Q?PcF1Kko6+TMa8+ibSO2o8f3082CCx2qdpU9xHWnKN2NoDUTIWptmtDh7Gyd4?=
 =?us-ascii?Q?a0bOmDd+Ob7gmZnBitkR+h3RCNgxLdvMFidBzVfDdsJ1ct096uRvn2hnUOTc?=
 =?us-ascii?Q?YU7yRNCmzYneyluAfUe05WqDjko38vx+mVQG2DGifM40bpkCgGPSvG91bXME?=
 =?us-ascii?Q?2L+5RqTRe5AO0sLjhObVNjj3d9fm4OxtMXY8BUB0BWNxYbUVvE8aONd4L4p/?=
 =?us-ascii?Q?rMTZP5aC3VPOTxDlaj3d2lcXVjaD4WcqbqHsOFox0PuIHXfW1wjkAR6aHoK6?=
 =?us-ascii?Q?a5l6qh8o5y5retmkW4puGYxZi022fIPkQi03gDck71VPxI4cQfUhfYA3udHE?=
 =?us-ascii?Q?2QgDxvXv9dlob7CkRshcFLFMBZXzEzuCTeSRYYicv0SgPaPKW+l/zK7LCxvb?=
 =?us-ascii?Q?XHFHXk0tKBlwQB9AlyxnLLuESQQefv8fVJ1BZdmagtOFsRO+9UFg5p0hGBl5?=
 =?us-ascii?Q?mYUoVW1JE8507KRojj8rgx9BHVUhVztWc76rwIQS0tF/kGigT1FDHDKnbc8X?=
 =?us-ascii?Q?U/7PKf6yss/UIrWcaAmH/5aCDaIJ1XVFubbR2lipTfwUeDMYniYQuKpcY0li?=
 =?us-ascii?Q?Kq0f1j5obUFzP6a+WdjhnP6lRyBEBTDmN2wETOdgLWzNHYWU2OF2JLqKIO/I?=
 =?us-ascii?Q?o/ipmiMamxSNf5uGvpKsxU+s0lNXhLkZjv32n3qm3C8LPOcsgNCfs5j9Q4c2?=
 =?us-ascii?Q?9Ejsn5wtmyuR7Uw243YXbDKpL+NpjOFVPhhdHnAsCHHaDw/HAPLjIfEbB4qY?=
 =?us-ascii?Q?flCa8kgF/OrDNX7NAYBkEh5DdA2Pg5T8xhWt08ZmjZq8x/4wJFxvgilVtF5/?=
 =?us-ascii?Q?lLmG3lhKzJCj4evEREl1bVROLZ6NFsinspIlHUlOd38wMj2MN6n9EvfNdXZJ?=
 =?us-ascii?Q?jvx5r4sdirTyhnzI8PotJkQkJEkMzo+VJcPNb9460EPJlUmAxWGv/uXJAzln?=
 =?us-ascii?Q?anZLRBAx/gDsSsOsu3qlQhYk9E+rdauSGjJDnnTE4BSmsuQ6y241R+iQN52W?=
 =?us-ascii?Q?pMhjdw9Dq5xY8p1vvMqT0tVyy1am7yX4xRc0+MyTlKUIB5nSS6IRhrFebAmH?=
 =?us-ascii?Q?JXUbnubfdg2tPmLPJuMAnmn6/kkpOzVvcy5z0VwMJAm7cTllhYtk7+5XGmBf?=
 =?us-ascii?Q?Otr9Q/TIJ82BXHMsa6CG4dUfwV5RmQgzg9yCQgYv6sg2J0S8Y4IdnaNCX+1i?=
 =?us-ascii?Q?K56UL6mfxxMnmjotWy87F6qT7HFHxpbxpu14HDdRIROGmaI9GWtiV7AX2Yoo?=
 =?us-ascii?Q?MgMmXa8wpwpAW3l5PPHCeSQxp9Exsn+WNsAj2CW90ukoK8aATnFD0nJnlmSa?=
 =?us-ascii?Q?qJ85yMTvhyOL7YAbz+J/k75hK78dgHQVQiwC5srZduDEi2lW0AUH90YZp7HX?=
 =?us-ascii?Q?GIdSns10a6g/R1Vlu6H4jDrXTchMUN2EpvWZG1Z6pn9BeOBInl5sAr7Y+dWC?=
 =?us-ascii?Q?2xEt7praXyOJu0nDfjM6qmH2N+G5WGoe3ocrZpLtd44OT9rHWMADr9W1TaVn?=
 =?us-ascii?Q?5Ge1Ea4k8jBudJniTQmUtas/Ruz6Wa6wu7B+0VWG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bc88469-475e-4831-66b5-08dbf680c6ed
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 17:28:35.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PMMZ4Fvyt2vet3wcb2SuB8ImOt96ZdYAt0uTb7juI6t8gTcZSL8hElHXkNJQytcL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360

Make a new op that receives the device and the mm_struct that the SVA
domain should be created for. Unlike domain_alloc_paging() the dev
argument is never NULL here.

This allows drivers to fully initialize the SVA domain and allocate the
mmu_notifier during allocation. It allows the notifier lifetime to follow
the lifetime of the iommu_domain.

Since we have only one call site, upgrade the new op to return ERR_PTR
instead of NULL.

Change SMMUv3 to use the new op.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 12 +++++++++---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     |  2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     |  6 +++++-
 drivers/iommu/iommu-sva.c                       |  4 ++--
 drivers/iommu/iommu.c                           | 12 +++++++++---
 include/linux/iommu.h                           |  3 +++
 6 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
index 5894785aa901e8..991daffbee31aa 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
@@ -638,7 +638,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
 
 static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
 {
-	kfree(domain);
+	kfree(to_smmu_domain(domain));
 }
 
 static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
@@ -646,14 +646,20 @@ static const struct iommu_domain_ops arm_smmu_sva_domain_ops = {
 	.free			= arm_smmu_sva_domain_free
 };
 
-struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned type)
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm)
 {
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
 	struct arm_smmu_domain *smmu_domain;
 
 	smmu_domain = arm_smmu_domain_alloc();
 	if (!smmu_domain)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
+
+	smmu_domain->domain.type = IOMMU_DOMAIN_SVA;
 	smmu_domain->domain.ops = &arm_smmu_sva_domain_ops;
+	smmu_domain->smmu = smmu;
 
 	return &smmu_domain->domain;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10dc7edd40e1b1..d09505acd4f8ce 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3229,8 +3229,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.identity_domain	= &arm_smmu_identity_domain,
 	.blocked_domain		= &arm_smmu_blocked_domain,
 	.capable		= arm_smmu_capable,
-	.domain_alloc		= arm_smmu_sva_domain_alloc,
 	.domain_alloc_paging    = arm_smmu_domain_alloc_paging,
+	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
 	.probe_device		= arm_smmu_probe_device,
 	.release_device		= arm_smmu_release_device,
 	.device_group		= arm_smmu_device_group,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index c1181e456b7d5f..48871c8ee8c88c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -808,7 +808,8 @@ int arm_smmu_master_enable_sva(struct arm_smmu_master *master);
 int arm_smmu_master_disable_sva(struct arm_smmu_master *master);
 bool arm_smmu_master_iopf_supported(struct arm_smmu_master *master);
 void arm_smmu_sva_notifier_synchronize(void);
-struct iommu_domain *arm_smmu_sva_domain_alloc(unsigned int type);
+struct iommu_domain *arm_smmu_sva_domain_alloc(struct device *dev,
+					       struct mm_struct *mm);
 void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 				   struct device *dev, ioasid_t id);
 #else /* CONFIG_ARM_SMMU_V3_SVA */
@@ -854,5 +855,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
 						 ioasid_t id)
 {
 }
+
+#define arm_smmu_sva_domain_alloc NULL
+
 #endif /* CONFIG_ARM_SMMU_V3_SVA */
 #endif /* _ARM_SMMU_V3_H */
diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
index b78671a8a9143f..a52b206793b420 100644
--- a/drivers/iommu/iommu-sva.c
+++ b/drivers/iommu/iommu-sva.c
@@ -87,8 +87,8 @@ struct iommu_sva *iommu_sva_bind_device(struct device *dev, struct mm_struct *mm
 
 	/* Allocate a new domain and set it on device pasid. */
 	domain = iommu_sva_domain_alloc(dev, mm);
-	if (!domain) {
-		ret = -ENOMEM;
+	if (IS_ERR(domain)) {
+		ret = PTR_ERR(domain);
 		goto out_unlock;
 	}
 
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index f17a1113f3d6a3..899d73062f6e67 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -3543,9 +3543,15 @@ struct iommu_domain *iommu_sva_domain_alloc(struct device *dev,
 	const struct iommu_ops *ops = dev_iommu_ops(dev);
 	struct iommu_domain *domain;
 
-	domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
-	if (!domain)
-		return NULL;
+	if (ops->domain_alloc_sva) {
+		domain = ops->domain_alloc_sva(dev, mm);
+		if (IS_ERR(domain))
+			return domain;
+	} else {
+		domain = ops->domain_alloc(IOMMU_DOMAIN_SVA);
+		if (!domain)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	domain->type = IOMMU_DOMAIN_SVA;
 	mmgrab(mm);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ec289c1016f5f2..7bd8c898e67559 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -346,6 +346,7 @@ static inline int __iommu_copy_struct_from_user(
  *                     Upon failure, ERR_PTR must be returned.
  * @domain_alloc_paging: Allocate an iommu_domain that can be used for
  *                       UNMANAGED, DMA, and DMA_FQ domain types.
+ * @domain_alloc_sva: Allocate an iommu_domain for Shared Virtual Addressing.
  * @probe_device: Add device to iommu driver handling
  * @release_device: Remove device from iommu driver handling
  * @probe_finalize: Do final setup work after the device is added to an IOMMU
@@ -386,6 +387,8 @@ struct iommu_ops {
 		struct device *dev, u32 flags, struct iommu_domain *parent,
 		const struct iommu_user_data *user_data);
 	struct iommu_domain *(*domain_alloc_paging)(struct device *dev);
+	struct iommu_domain *(*domain_alloc_sva)(struct device *dev,
+						 struct mm_struct *mm);
 
 	struct iommu_device *(*probe_device)(struct device *dev);
 	void (*release_device)(struct device *dev);
-- 
2.43.0

