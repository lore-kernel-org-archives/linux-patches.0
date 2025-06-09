Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2063.outbound.protection.outlook.com [40.107.223.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E958C21FF4E;
	Mon,  9 Jun 2025 17:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489253; cv=fail; b=X/UUFcFAXNNDwRGA6JygpCK1lXi8++5ol144IsvfYN7prXIhMOnn8aGbd6OgPwntz2FEE2+dkcxtAogXLemQXFso+deDchWYzy5r8V/Rv2qqT0/EkBE6xlsWb5RbP+/9dM5J1e73FwyEVuVNGBeGl21TwDlJudMxXjBz9pmZohc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489253; c=relaxed/simple;
	bh=uExJOJj72q+nuyG2aQ4qk/xyAD2DciH2GDKfEe7D9V0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WLKf0StACbjK2pRKsNoqbxarr0KqhvoqtW1crLw/xX3lMAcUW9deqNBPamtMxq2xooYwIRJdoGTFKSgt6E/yJXUf4xWaInCb30xPk3LRa6FeVxDzf+PM0KX3k6YotPZ/uJa5oRGLTmidSpoHmtzeznDgq+cfj0Fp+zhcud6tO4o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=P3vF5YdC; arc=fail smtp.client-ip=40.107.223.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="P3vF5YdC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TUq3mQjqAaZ8gVWKESZjVmU7MWMdovlEO+jZD3hvPRYchORyA3g2Z9oY/8SthdBQNM+EqAncFmOMrXI/kAYG+m7/NYF5sedl2kdB3Gygi8f1dFjE9HMMgWl3F9sq6qYD+8DF8AgtGrwtn74mdTjgVluCJWMK++etuFqhtPeP/eV8rHHOt6g4F8CPgaV6DD9uH18C+4g03z5g/1fmvak7keyW286FS1gWOnOM4Ptsg44VzQng/1uiNJp1YaDQOCaeNHQhdo+bcOoOhhVZpquGGORGp+/NDHsTLnv/dFwf7qWvIXJ3/F/dcuLMETsn0CH0OqxJMcy+fDF5vED4gIH1nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bMTVWdvuHaqbSGRiTvBhe0GTsk/ada2eK96vEW0+gxE=;
 b=CyNSp5F/oNICi//FlqH8vxFz5CAiO3jW9+shdggHzykZOnzGu9SwbJEF5ID9YED7SPQi7JWF38BqvGC3s9mi8cOfR+Pl7wMDWnbjGcdlriIQnYAj+UKZUG9PDxMJwOB76TRod3v8LNWqepJbwIbPkEUJLFotwtLWVnsV/mUsxQZN+PgB9Jrrms60tK50uBchOPOtTBomK44s/b+AKjDNsrGico216aCJTZVAE0/JLVtV0UYdU19g8h7nu35EpeFWPCJTGquLtC/TJMq3i30c85i+ecmLjeShdeYOcE+a+kYfE/19yFuaE1ifzpLTFlogSoO5RfykujFysE8NYS6a5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bMTVWdvuHaqbSGRiTvBhe0GTsk/ada2eK96vEW0+gxE=;
 b=P3vF5YdCqHSObocrNERTIKopmRQsNtXKieLTWbZGL1HtGncAmU1pVIWlbRMAdTJC4yLI/SeehR3UbSknP/Ns6/tNLolwCI+oB7Mew+Z95D7acdV6JIeozOPtxp9s6VYYSkcHOnYr7Mx2aN6kbVbhZJXbEWgMQswuB9NwpjdO8tc32xm+mIyKvXgJaP3dSPJchOvc/3h7fZ8UVBlnVqJad4jnSBI7/Xun0HJM6yM7k9eJskZDLC3HlYiyltYPs/kgfkr2o1FFmQFfsPEeA+Ks7vsUKSA/iI6LjbOivcVwp619ICqOoH7HzWQawNBsqB67Q+7XEj8/dVUp4emllLAtmA==
Received: from MN0P223CA0004.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:52b::14)
 by CY5PR12MB6107.namprd12.prod.outlook.com (2603:10b6:930:28::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.36; Mon, 9 Jun
 2025 17:14:08 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:52b:cafe::f2) by MN0P223CA0004.outlook.office365.com
 (2603:10b6:208:52b::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.35 via Frontend Transport; Mon,
 9 Jun 2025 17:14:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:08 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:51 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:50 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:49 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 07/12] iommu/arm-smmu-v3: Implement arm_smmu_get_viommu_size and arm_vsmmu_init
Date: Mon, 9 Jun 2025 10:13:30 -0700
Message-ID: <55b1d69b2cceb685d4eb728a7a53572a9147993a.1749488870.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1749488870.git.nicolinc@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|CY5PR12MB6107:EE_
X-MS-Office365-Filtering-Correlation-Id: 42e15f66-4bd9-4513-7ce7-08dda7790bad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hHJDvmYKGBjtkrRLS0B21wg/rJ2gDZx+fUZ1qhG5VY2fPBytgXT+Iibxq8Kd?=
 =?us-ascii?Q?2MoiGPbZKldiMntAkvZhecCaA8inSLozF9xmeA+VgDQL3LpRIEFhlr0ueK07?=
 =?us-ascii?Q?BEoqT9CDJGBd4GaIMijL4Xt+xqi7v+RrFwamfS6nu6TW9hzi2+ziSTuEbaRM?=
 =?us-ascii?Q?7n0zlznwlXs/SRkzs3p9FIZ81jef/MUTV9+NhAM5jinBweQNGt0q6rc22/hp?=
 =?us-ascii?Q?yAyHwq1YaokjMf7szQ8fVm0rBZfG3Mf/z7KUvAOmnzIbCIfIRzbISwmzDY2T?=
 =?us-ascii?Q?41VA/sRsQhgx7p58pz9BWMG5Efp9gF8CO+M/2ePc9GXXke+UjwpL1jSrhvMY?=
 =?us-ascii?Q?gIqGjKlC/4ExaSIn+SJZV5hRBjjUng0SVVsyXwauRa/y/YNQCY+/K3kjBQep?=
 =?us-ascii?Q?Rgu898AXnvO0oUYqM2ZcUxsA+ckdVrlqtacRWlY+YZY1rE3XkZSkbZ/c9djW?=
 =?us-ascii?Q?8mCy5kE2maxg6fzswr39mjJHJxYhh+d8o+LsNt8/gKN87t+RzjIz4OT9jWDa?=
 =?us-ascii?Q?FGCCL4uEYgQGkyqhojXGKgmheuXEzOFg1F35VmGCUTA8F+s4RorwhPT5YO2c?=
 =?us-ascii?Q?BJTkONHXyV5pRgzXUf0J5XDj8vZudHcXro/UWhxuDXWnr4aMJs7BgR9aAlLT?=
 =?us-ascii?Q?wN9Peud7hIja//Syt21e1+SfZUp7p83OawEGN2AOARB/fOAflmjvv4fg+Ar4?=
 =?us-ascii?Q?SAXTCr5AV8zFK8AxL5WV4usJBRBNJXYpAD/W/9pvC0vha1T9OnL9TRQzjRqz?=
 =?us-ascii?Q?8XfpSQ9nNVf9KD8+Kck7M+iio41rFQOhIB5tLWDjEcysWS/X7wsOXAcTREzE?=
 =?us-ascii?Q?Gy+q/HFyWbgx2rhfRCRLSrsOE+lpOz4EDYqxawagKLlKoC9vxKfBM5ksMZlW?=
 =?us-ascii?Q?0xO7QxZ57E9DdEysGrbFA2+GmtxTfMHyi1qHRDOQCxlBi4HAd6BA8wIveIRq?=
 =?us-ascii?Q?yrkXjM3xVjUTH9aqvYDHZp2cyIjTxCN0rYCSTWyw0S/Biwpmkip00HcJJe4h?=
 =?us-ascii?Q?2XJDnrwUuqqJJDmz5pQEss302cMt9aub2H75MTUSFh7QUw5FwA59xbmryk/2?=
 =?us-ascii?Q?22Iwlh7BNVd9KpviyuJJrCJHbs4FXZNL1W+ta+JHsu+6w9+1OweKZ6PtSU5e?=
 =?us-ascii?Q?/RRLreLEOl0GJGreaEIuox0g/Cz1YEGdMwi+96UnnUoDOEx/w6ijMN6zLZb4?=
 =?us-ascii?Q?vKAOgapiBu8N9kdogGaijisLnLYwGnfuXIwlvqFPFpAjPWrtVRTAm98yrroB?=
 =?us-ascii?Q?9y7oWl/+pvVSY4VgeIAUNmLvUBrhqzKYycXH6omD2t10GcHKHpZN0Onc5oLe?=
 =?us-ascii?Q?jYtOyPx0qs80Ji6gfZcwWGxd973vOjFxjRbqoY8tREo7EeitOCb39JJqXi+e?=
 =?us-ascii?Q?8MOc42XHar3JKo9zvyJnvTH3yzwwCjosZThMVeNUbPrR9r1Jl1cEUE3E802j?=
 =?us-ascii?Q?d2LhGV47PKY1OwC5ECBt6qAO+it/uJZVR83b941Tz2zQJ4qDnpWv4SqmsSfK?=
 =?us-ascii?Q?DaF0iI/0ZuSQkyw1fVbC80oFNp2hASGW4Bpz?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:08.3264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 42e15f66-4bd9-4513-7ce7-08dda7790bad
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6107

Sanitize the inputs and report the size of struct arm_vsmmu on success, in
arm_smmu_get_viommu_size().

The core will ensure the viommu_type is set to the core vIOMMU object, and
pass in the same dev pointer, so arm_vsmmu_init() won't need to repeat the
same sanity tests but to simply init the arm_vsmmu struct.

The arm_vsmmu_alloc() will be cleaned up once the transition is done.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  6 ++
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 56 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  2 +
 3 files changed, 64 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index ea41d790463e..2357459099f4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1034,6 +1034,10 @@ struct arm_vsmmu {
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_IOMMUFD)
 void *arm_smmu_hw_info(struct device *dev, u32 *length, u32 *type);
+int arm_smmu_get_viommu_size(enum iommu_viommu_type viommu_type,
+			     struct device *dev, size_t *viommu_size);
+int arm_vsmmu_init(struct iommufd_viommu *viommu,
+		   struct iommu_domain *parent_domain);
 struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 				       struct iommu_domain *parent,
 				       struct iommufd_ctx *ictx,
@@ -1044,8 +1048,10 @@ void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state);
 void arm_smmu_master_clear_vmaster(struct arm_smmu_master *master);
 int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster, u64 *evt);
 #else
+#define arm_smmu_get_viommu_size NULL
 #define arm_smmu_hw_info NULL
 #define arm_vsmmu_alloc NULL
+#define arm_vsmmu_init NULL
 
 static inline int
 arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index e4fd8d522af8..482a49f5c10c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -382,6 +382,62 @@ static const struct iommufd_viommu_ops arm_vsmmu_ops = {
 	.cache_invalidate = arm_vsmmu_cache_invalidate,
 };
 
+int arm_smmu_get_viommu_size(enum iommu_viommu_type viommu_type,
+			     struct device *dev, size_t *viommu_size)
+{
+	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct arm_smmu_device *smmu = master->smmu;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
+		return -EOPNOTSUPP;
+
+	/*
+	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the exact HW
+	 * defect is needed to determine if arm_vsmmu_cache_invalidate() needs
+	 * any change to remove this.
+	 */
+	if (WARN_ON(smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
+		return -EOPNOTSUPP;
+
+	/*
+	 * Must support some way to prevent the VM from bypassing the cache
+	 * because VFIO currently does not do any cache maintenance. canwbs
+	 * indicates the device is fully coherent and no cache maintenance is
+	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't make
+	 * things non-coherent using the memattr, but No-Snoop behavior is not
+	 * effected.
+	 */
+	if (!arm_smmu_master_canwbs(master) &&
+	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
+		return -EOPNOTSUPP;
+
+	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
+		return -EOPNOTSUPP;
+
+	*viommu_size = VIOMMU_STRUCT_SIZE(struct arm_vsmmu, core);
+	return 0;
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
+
+	vsmmu->smmu = smmu;
+	vsmmu->s2_parent = s2_parent;
+	/* FIXME Move VMID allocation from the S2 domain allocation to here */
+	vsmmu->vmid = s2_parent->s2_cfg.vmid;
+
+	viommu->ops = &arm_vsmmu_ops;
+	return 0;
+}
+
 struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
 				       struct iommu_domain *parent,
 				       struct iommufd_ctx *ictx,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10cc6dc26b7b..eef1fbd68914 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3688,6 +3688,8 @@ static struct iommu_ops arm_smmu_ops = {
 	.get_resv_regions	= arm_smmu_get_resv_regions,
 	.page_response		= arm_smmu_page_response,
 	.def_domain_type	= arm_smmu_def_domain_type,
+	.get_viommu_size	= arm_smmu_get_viommu_size,
+	.viommu_init		= arm_vsmmu_init,
 	.viommu_alloc		= arm_vsmmu_alloc,
 	.user_pasid_table	= 1,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
-- 
2.43.0

