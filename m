Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2087.outbound.protection.outlook.com [40.107.102.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E3A202C3E;
	Sat, 14 Jun 2025 06:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749882967; cv=fail; b=nHd6bOsZeuK5AHZFSLrOgIj0oBtyOljAsy5jipHGEhad/7+1ntGN720RB+V6Vyzt3yKajK4AwWU4Pbdli6lgi9dJVFCIa7JljBfM/zzT6feW5PkjtRBRoo663ORxee2ZRXmIANzBfRtzSfE5ZYTbHZWjaMV13PRPB3mSVeMWeoE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749882967; c=relaxed/simple;
	bh=by8HZ9Fj2vREdVi70wxBWvRRRHOF3nFP+nBYtihdZ2E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YrU3hBlf1UG0yYb2U3sbxu3POb15SM7Sy1lZju604Wr+M60N4jmP+Ip9mPaOM3Cd3wztM4oqakt9dCkHyId3fcHy077fjLxphb7hq/V3i6ZfDXFlxXiHAs63mdaDROJUPP74QNKpzQ0SXroK1PUfPy4AqZlrTuOr/+bL8yn9ToI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bYr2YLbz; arc=fail smtp.client-ip=40.107.102.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bYr2YLbz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jO44TVXrEhvH7s0RD2aV8aDIwaHILl2TAjOPwsZfnBpr5703hJH6xUKQKLLStHixvK/LEBZnFWM3kjSTGiwYzU0aHd5+XrL61xpp6/jlVUaIu0eoTsegagcfbj4Zb3/rBguZmweFfKNWdeAvUVYQhdGRqbBWUYhBHq79F8qKKNOvA6veYxFtafYP8Ekc8eevxNVI8tfLEaujvaMWpJH68DUHK6K3NpEQKS5RjzxBAUouFJeyL3FmnwiNFmfm4p/jT29t9An9eyahFYbNObqU0o7DqLxxaRgDaDkvvkEYA/cxML5dtRsqKDESEoeQNI08MoRR0xOlaIEaQYntt2jddw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+VHj2gT7ME9hnnw1cSS8kRIhCrMG4HDzA+C0aPiHQmQ=;
 b=V+du2L1CX7v42ArK/3sxM8HhxRKciP9mOF98d2GhY5MSHGR873xpE8spftqalCP3Bky64KHanTjwHub7eE2nhF4tPtGUBVEyychPN5dUCw8rbAXQ51cCIGrEkb8YnWDsILVLVPc6P3qI298FWYvPgt9FkCK0MwoE8pu/XY2NDsPu/3Z79xwYnimAktOFjjv8/h7aUAjioBMQRXjZOV0ociMCQy0fZLSBscAOjHJPkFEMJr13HDBOtTAQSjTDMt0xv3zH8ToOU9soxarJBaV0u93a8DDadontV8St8qHkO9iGVmPVRE1S8RXlPc95ycDA5PvdLMSO8wJaD6rty/xHLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+VHj2gT7ME9hnnw1cSS8kRIhCrMG4HDzA+C0aPiHQmQ=;
 b=bYr2YLbzW4Ju3v1LBXOJCUioNnYPe5wQx+raHbsu6VWtD8zovsxxU1zEwfZwryQGuzHno9H8LwXYLOmd/HEvVIHdxDKjBRJsMqt+4gYCsX/8xkjOrWi0UXfj7D94Vbo2T5/7vfNa0EdUntfBsLPrwQopE396VxQIF4IZPDs2UvDjba04Z4Ae9KKfl1GkxU8g1BsKGs3jE7bymtkyrlBp5C4K6MQ6BUw4DEKSAUbT+B5wRIy3RKlFJgYkqkoi2uBtERngr5UbTnysEuEcfg1878G/CgM3JlLVCpnaD5Y5DfqBRe9OpTu6ygeiQU9T4BUNRJ/rgNpJjGgzZ+odehAvqQ==
Received: from BL6PEPF00013E07.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:8) by PH0PR12MB7790.namprd12.prod.outlook.com
 (2603:10b6:510:289::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Sat, 14 Jun
 2025 06:35:57 +0000
Received: from MN1PEPF0000F0E3.namprd04.prod.outlook.com
 (2a01:111:f403:f901::4) by BL6PEPF00013E07.outlook.office365.com
 (2603:1036:903:4::4) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.23 via Frontend Transport; Sat,
 14 Jun 2025 06:35:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E3.mail.protection.outlook.com (10.167.242.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Sat, 14 Jun 2025 06:35:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 13 Jun
 2025 23:35:41 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Fri, 13 Jun
 2025 23:35:41 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.11) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Fri, 13 Jun 2025 23:35:40 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<praan@google.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<iommu@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <baolu.lu@linux.intel.com>
Subject: [PATCH v2 10/14] iommu/arm-smmu-v3: Replace arm_vsmmu_alloc with arm_vsmmu_init
Date: Fri, 13 Jun 2025 23:35:22 -0700
Message-ID: <64e4b4c33acd26e1bd676e077be80e00fb63f17c.1749882255.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749882255.git.nicolinc@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E3:EE_|PH0PR12MB7790:EE_
X-MS-Office365-Filtering-Correlation-Id: 0feb6dce-9194-4c00-a9fb-08ddab0db7ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NaPRCOSrYffE8bSskY48q8ijD75nSuWAd2ZpubTMt+ZE7u5U/0sWI5b7+DH1?=
 =?us-ascii?Q?IVSiAzm+hasw8sQ9cKdGlQlKkvi+Ztco0qwyFsvI6XivRwcRjNpam5056Rm5?=
 =?us-ascii?Q?W1GYsMULVCCRUXfFZkf9aDdTIabCpA5kn0CfBQaV5uIa9fU/OhKeaMcZF/eu?=
 =?us-ascii?Q?LtVsxHCydMQFaHPumLi5lG6l8JA2YmuNivKzng2gm+zOXCPEzzkPGrp/R9/S?=
 =?us-ascii?Q?aHxXqGGmgHAVxaxQ1ZytBU1wHlc8at1cn4z37aSIS0vG/L1Y6v0WNIyUGGac?=
 =?us-ascii?Q?GJ5VAzXKcI5Cd2uVAvJeuDyLkBffJxL+B6xfaaAZLdgSVPakFppPAs15y5le?=
 =?us-ascii?Q?LrHvojoRrHWi8wrSpjtX0bYzjheXkhq+tukQuW/NIqC7/eEB8Dpco8JDjj1Q?=
 =?us-ascii?Q?tbHA/jZ6Ecf58zLPF/nxrqoKP8J10dX5UpyMH4Z840YpSk0OtGJ/9PhNPaoI?=
 =?us-ascii?Q?X7DA6ZcXgEULj/rnX95aVi4HIHxfR/b5aDNmAlUy2JYy2UWo4OwTxqRKYVF3?=
 =?us-ascii?Q?4AVi/zLPotOoPHBvy5oJH21xho1FWSPTx9iZqLq5OsJadu3rcuSf1Ktm0j/x?=
 =?us-ascii?Q?l7Hh6ZP5xRHwI4qPP14T1xnAaKu3NMPFrIq2Fx6kw59BTZzLr68M3Jt8Qbs9?=
 =?us-ascii?Q?eOa73W+p55amzYod+CHQxGcZcpoOXAO5uIHL1h50ncO2dhQklBO1966ECHm0?=
 =?us-ascii?Q?d+q7GsJ32yYDFz4DELNqAtr1f6s0/AdasUeC2EIId4hIGt1+MzrI/OgvePPQ?=
 =?us-ascii?Q?TcSXD0ETNtA+mr5K+W68/WT9RemHLsOT1GTjFHS+b3n7qIBOZWuKpPvjzmKZ?=
 =?us-ascii?Q?4x0/EUJhYZ/meecJUaoutfZS3ZVx14BlEEaWPgeoXrOMeSq+qtv8nV5yEE/I?=
 =?us-ascii?Q?KJ+M2qYt2WQH9vDCCxw8KdhLRiua419BlaM50Lwb2OGNFGrS8NTU+EcV9p4B?=
 =?us-ascii?Q?nRBvMfQwQ907/sylK2g83vr1LsU7/jOPeOPhT9hP4dbWOW7fwC6/CbYEhDAy?=
 =?us-ascii?Q?71ujxfqhgiJ6goFRO6PcKHNK3vzSfDhuUft9/VA/4g52kMVG/QqxbApL/YVb?=
 =?us-ascii?Q?4dreufa2QZl2cPjag7GOnQu9vCGKWjfJ9z/BKyY4a2lRJmppPjC1WTExEWJw?=
 =?us-ascii?Q?dtmsSDoIf1t3iJ4iGIlhA1b18vyOM1lVBWpkZw8M8FZzCCiQqBfVvSC1lcsZ?=
 =?us-ascii?Q?YnMiiixFIBA75NjlLJ09BKw9rfC3mWROB/UyUWgiSWIn2kdakOmzq35cIjVY?=
 =?us-ascii?Q?grgknhOJUm5Se3jLBtypwVlW1714nlsS8C2iz3qY6L0F7T66FS5OXN0hvlVu?=
 =?us-ascii?Q?NcBpBfvghHh5h4tY9JXZZp4qK6Lf4iyq+N8ew2dvex/CDVkT8jm32Ovc+snJ?=
 =?us-ascii?Q?IWdifA1zW9RhOcgUIQJlJg8bpTXVdmQCTBZEcWhDrMmRhRaT2VyFelUeomNX?=
 =?us-ascii?Q?b8yCpqe0S7hVne2SpoX73yDp4AcKSAkru9QONQKGr1l0q95cfhpipQuxiSpY?=
 =?us-ascii?Q?TmH0VdWNyUfvDm2ZbLOyCQPSGRZaAcF/PLFu?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2025 06:35:56.3032
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0feb6dce-9194-4c00-a9fb-08ddab0db7ea
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E3.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7790

To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
are introduced.

Sanitize the inputs and report the size of struct arm_vsmmu on success, in
arm_smmu_get_viommu_size().

Place the type sanity at the last, becase there will be soon an impl level
get_viommu_size op, which will require the same sanity tests prior. It can
simply insert a piece of code in front of the IOMMU_VIOMMU_TYPE_ARM_SMMUV3
sanity.

The core will ensure the viommu_type is set to the core vIOMMU object, and
pass in the same dev pointer, so arm_vsmmu_init() won't need to repeat the
same sanity tests but to simply init the arm_vsmmu struct.

Remove the arm_vsmmu_alloc, completing the replacement.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 11 +++--
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 46 ++++++++++---------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  3 +-
 3 files changed, 32 insertions(+), 28 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ea41d790463e..bb39af84e6b0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1034,18 +1034,19 @@ struct arm_vsmmu {
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
-struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
-				       struct iommu_domain *parent,
-				       struct iommufd_ctx *ictx,
-				       unsigned int viommu_type);
+size_t arm_smmu_get_viommu_size(struct device *dev,
+				enum iommu_viommu_type viommu_type);
+int arm_vsmmu_init(struct iommufd_viommu *viommu,
+		   struct iommu_domain *parent_domain);
 int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
 				    struct arm_smmu_nested_domain *nested_domain);
 void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state);
 void arm_smmu_master_clear_vmaster(struct arm_smmu_master *master);
 int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster, u64 *evt);
 #else
+#define arm_smmu_get_viommu_size NULL
 #define arm_smmu_hw_info NULL
-#define arm_vsmmu_alloc NULL
+#define arm_vsmmu_init NULL
 
 static inline int
 arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index e4fd8d522af8..9f59c95a254c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -382,25 +382,14 @@ static const struct iommufd_viommu_ops arm_vsmmu_ops = {
 	.cache_invalidate = arm_vsmmu_cache_invalidate,
 };
 
-struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
-				       struct iommu_domain *parent,
-				       struct iommufd_ctx *ictx,
-				       unsigned int viommu_type)
+size_t arm_smmu_get_viommu_size(struct device *dev,
+				enum iommu_viommu_type viommu_type)
 {
-	struct arm_smmu_device *smmu =
-		iommu_get_iommu_dev(dev, struct arm_smmu_device, iommu);
 	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent);
-	struct arm_vsmmu *vsmmu;
-
-	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
-		return ERR_PTR(-EOPNOTSUPP);
+	struct arm_smmu_device *smmu = master->smmu;
 
 	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	if (s2_parent->smmu != master->smmu)
-		return ERR_PTR(-EINVAL);
+		return 0;
 
 	/*
 	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the exact HW
@@ -408,7 +397,7 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 	 * any change to remove this.
 	 */
 	if (WARN_ON(smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
-		return ERR_PTR(-EOPNOTSUPP);
+		return 0;
 
 	/*
 	 * Must support some way to prevent the VM from bypassing the cache
@@ -420,19 +409,32 @@ struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 	 */
 	if (!arm_smmu_master_canwbs(master) &&
 	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
-		return ERR_PTR(-EOPNOTSUPP);
+		return 0;
 
-	vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
-				     &arm_vsmmu_ops);
-	if (IS_ERR(vsmmu))
-		return ERR_CAST(vsmmu);
+	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
+		return 0;
+
+	return VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
+}
+
+int arm_vsmmu_init(struct iommufd_viommu *viommu,
+		   struct iommu_domain *parent_domain)
+{
+	struct arm_vsmmu *vsmmu = container_of(viommu, struct arm_vsmmu, core);
+	struct arm_smmu_device *smmu =
+		container_of(viommu->iommu_dev, struct arm_smmu_device, iommu);
+	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent_domain);
+
+	if (s2_parent->smmu != smmu)
+		return -EINVAL;
 
 	vsmmu->smmu = smmu;
 	vsmmu->s2_parent = s2_parent;
 	/* FIXME Move VMID allocation from the S2 domain allocation to here */
 	vsmmu->vmid = s2_parent->s2_cfg.vmid;
 
-	return &vsmmu->core;
+	viommu->ops = &arm_vsmmu_ops;
+	return 0;
 }
 
 int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster, u64 *evt)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10cc6dc26b7b..181d07bc1a9d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3688,7 +3688,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.page_response		= arm_smmu_page_response,
 	.def_domain_type	= arm_smmu_def_domain_type,
-	.viommu_alloc		= arm_vsmmu_alloc,
+	.get_viommu_size	= arm_smmu_get_viommu_size,
+	.viommu_init		= arm_vsmmu_init,
 	.user_pasid_table	= 1,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
-- 
2.43.0

