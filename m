Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85457221270;
	Mon,  9 Jun 2025 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749489261; cv=fail; b=UOV1bjR7GAyQmklOEIpgmOtBHqHDdrVN3udDMx6EyQFqkJXJ+MWKivx2jowNLMNMXA2NjWrCyasN+Uq5RCIzssNSyeey9/WTeGs+BNoDq3tXZZXu/9hMbpCt+QT83P6WDxxNPQIVTT0dBUIcNCwYa+qQUx8DlQRqgRSxmqLNF00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749489261; c=relaxed/simple;
	bh=Jn1YSnDgr/O3wrGdtUL1bWnMbx2v1XoB966y6cvU7oY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZLTjhuJnZuE9xKSHzXpkTJRoTxEbrs3vRcJGFHwEa2xRqHCbkisKo9AmgNf2QkS+ysJHNVrsCn/9UdsAdCVUXB7+tXsNkqmjadKFPD2PYKT8QvAyHJqCW7d3jBM+86ZRqskb5286J3mNjKttFnJisVLURM5YLGsot8qjAexKag4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=fbjCxGC7; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="fbjCxGC7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x1LirazFfQXroaRbTLQmI0h2twBsnKwLGTuXcXRLgYSbnxbamY+WkgsYWHJGruaMtypeDCJh2ywISxX3gxHywBXjOTQ0r8B3AqpJHz4sATj7cAXsCEOQrK6+p0zyjNfTKk4M/QIBgwuZ4+sLkpti91TU2a4HlAXSnCotw4dH4IFMAu04X5Xz9hbzER9kK6JyKdBcfyofyrT1YOIIt0vJw4ov0YIIkq15x/LEbkXS6I9UZFsJPDxqC/D5T3c95PHy9wY9fpaGvNOzO5q5qcjfGKpW6uDm2ekyDUhfazOQhQVkL+wqMuIpqrk3793yf5N7OdBejUMTDBR/acJdQUhL2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c3Qx28sIkR4pw6uQv60v6Qq12/WNmC8TCGzjZNOYm04=;
 b=U9FBqhkkLuxD+ZjvExWquPKCJiUlMvv0mQ/tP9JBvavo8sH4zQTls64MI7SV8KDigy/AoNX6ldAFc6jI8rVxN9wztVO9mMHBL2p4H9OY0jrr+Lid66k3FUc56upmcO9F/MUdpt+/sGBm+3a2QtBHCnSaIywzY1s7BJDYy7Ul9K9XJpMdgm+PAZ9sg7BWuqYw2cRH8JcSxCtThItPAcf4pQUPka+CG3DHmYCGkj+Oi9ZTBJ8grYMOFOdcuCoklrHrrjfWRensjddySoWiqnzTC+fabqfz6sOAugImYZ4Cm9Rb8VzHZ0+R7Z9DmqQGQrhXD+PBtG7Dh62OTZSsY+uBjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c3Qx28sIkR4pw6uQv60v6Qq12/WNmC8TCGzjZNOYm04=;
 b=fbjCxGC7lMcP5GyCg2R0qvfX+zYKZwMtVlW3mjnKu1COP/RsrDIedK5/p1VBUUZqMCUC3hn0d+nVUfqMcJmM4yZwrrfQhvmtLlNEacyXVxe15OKC2uZL602CVk4M+IqyYUDrlsTdbmyZWR9DiQy0bvDa4xo1zNQQRWFB/hWOqNvkZP/udN+wdaCtYdSCoow7BNT45E+qbdDrE+95GXFsOOjw/L3W9JTzTySyz/8R+LnpFJdW/UZLbmjTvTh7yaeFJuuwD2dY8PYMTAkRvwK9e/4WWDzbThwhe15Mk4kf50gDyuKZsOv2xBLeFmx8P2B8rKz2vPRrmLa247L2+D8IsQ==
Received: from BN9PR03CA0285.namprd03.prod.outlook.com (2603:10b6:408:f5::20)
 by CY8PR12MB7538.namprd12.prod.outlook.com (2603:10b6:930:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Mon, 9 Jun
 2025 17:14:11 +0000
Received: from BL02EPF0001A100.namprd03.prod.outlook.com
 (2603:10b6:408:f5:cafe::3e) by BN9PR03CA0285.outlook.office365.com
 (2603:10b6:408:f5::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8792.23 via Frontend Transport; Mon,
 9 Jun 2025 17:14:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL02EPF0001A100.mail.protection.outlook.com (10.167.242.107) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Mon, 9 Jun 2025 17:14:10 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 9 Jun 2025
 10:13:53 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 9 Jun
 2025 10:13:53 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 9 Jun 2025 10:13:52 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: <jgg@nvidia.com>, <kevin.tian@intel.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<ddutile@redhat.com>, <yi.l.liu@intel.com>, <peterz@infradead.org>,
	<jsnitsel@redhat.com>, <praan@google.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<baolu.lu@linux.intel.com>
Subject: [PATCH v1 09/12] iommu: Deprecate viommu_alloc op
Date: Mon, 9 Jun 2025 10:13:32 -0700
Message-ID: <7f5ee636500d42895915334f7215c06170db81d4.1749488870.git.nicolinc@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A100:EE_|CY8PR12MB7538:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cb6a847-d9a3-42c6-a7ff-08dda7790d1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|82310400026|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9lVaRVorLPkOTTuytGwi1rUEF38ysCvfypFDgSwzwmuxJa8LX5taFNY5NnrL?=
 =?us-ascii?Q?cYlqn7zhf76/UXHRbeLb9nzXAAhlmh09+XWx0uKYSM4k0Y2egT29YVYh28qv?=
 =?us-ascii?Q?mvD0lDvomT2no3zrG+Nb23+9ByV3gLOMCb+MdH1VMQzwq2uCTEwpDpw20cJh?=
 =?us-ascii?Q?lSK/+JAjy3juku8J6QdVpJSqOc7CywOFye6dF1t8oXvSZ32SY7pnE0Ik1rXr?=
 =?us-ascii?Q?Gr4DLsR1f7so8HTWICaqoGgpfU+GmGR2ywB2r8qepIGzeWs/HKpAmMXJD3mQ?=
 =?us-ascii?Q?e73ijJjPtADSIXOdmq9IB3TMXj68fWSXlA+rmOwLvWJqkuDP7Zbm/mEnXOiH?=
 =?us-ascii?Q?8yor8CkwV6NI4R1D/EM5rXz/nC3gKReacTaIdbWYi4e3WpUk00N1PR0ivutr?=
 =?us-ascii?Q?VM8Ml2rEHqiEAxn9SmWI36NH7bHDlKBMBzQUW0GhsQ9yO0Q0tCH/wjVNUDpx?=
 =?us-ascii?Q?uVQLVZwbc0bdIO47vGwk6H06HWZgCbG1hMEuJzBF4YQ+EgL+J3hQ88iZ8Fhf?=
 =?us-ascii?Q?V7Uu0Wir6/HSVIUutuVu/ULDckN2paCtd61es4c6jH47JGTWt3PCWNgBa/pX?=
 =?us-ascii?Q?HK63giy7A5ioVrenOsDOR/n5QxzelV2BvDAy0+xqXP+rul7UvUoBg6QmEKEE?=
 =?us-ascii?Q?40c9dvP1X/62tZHGafoZoI14UHVAg3SldEhad0HjIges62aoUu0oegiKesRK?=
 =?us-ascii?Q?JIlynXCyPGIJlliJu79/t/mBzrHI8ZBdGVl5Y+iUUWqvv95XrTacEhIvZ8cL?=
 =?us-ascii?Q?jDgVUNjtG3Bm3ZrJBMYC0j07OoUUaBZ65lJ8MLz6v8AdiU29XXeFEqMqxLBm?=
 =?us-ascii?Q?h+C/0PVjwwoUEfzW8+qStDHicEMEgGLKBpbP61o2Z/pGp/xUvA6ticmQzheg?=
 =?us-ascii?Q?Zg4ZYCoQMWILZ0COTy2YTGjccxIrAjw+Evbp7bQMX40yzD5KUej4Hac2nLUX?=
 =?us-ascii?Q?SoCvsgMEtiu4nlIqdnEB4T7cb/vNwWRkz/NX7QxItnVBaZ1P4IrTqbi6UkvY?=
 =?us-ascii?Q?0TRBNADTc7ObAvdwmd0LLQt8QZIzyvCMHKGWPza+8N6Bqnj9kQMGUn7fld8z?=
 =?us-ascii?Q?1BziSv/eMa2ZnOm/5/+WiFlLmk2h8LzfoNKdwi1SCTL/tF/UHKQyD5iA8Vjz?=
 =?us-ascii?Q?nH123DLE0agdlZeyOKMa5KWNtVm1i4juFbsSMLCSY/MHu/NfLOz5uGJY21W1?=
 =?us-ascii?Q?noHpFcciAL7A65VuUXFxKPYqA+Jdso183O640N0j8i9mbt60uyGZ4LcsHrLp?=
 =?us-ascii?Q?h2xdUecS6IvUwTOqhRx7SL99tzPHRzOFrcoYLwJqPwfxpsJkYIusc9lHQsMe?=
 =?us-ascii?Q?nt8AwLQrBYuMBbZ/zSfyzRpI3iRrRx6Fr4H30o83P4BJBKHdsW73YaGYQWRt?=
 =?us-ascii?Q?TNhAK9mq2rFsshG1ffu4rZQUsk/VoUST33vwKg+qh6GfSeEmQlh11hr3d2B9?=
 =?us-ascii?Q?00DKouVJHSYM4BDlyop8Ud75A2yIWS0SemQeI1fk3yQFkr9Ms73Xu7PKbhUO?=
 =?us-ascii?Q?1Y+4huoqBno1etBDp/5iWiBj0bgQJ92afY0q?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(82310400026)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 17:14:10.7439
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb6a847-d9a3-42c6-a7ff-08dda7790d1d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A100.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7538

Now, iommufd uses the get_viommu_size and viommu_init ops instead.

Remove the iommu_alloc op and all the drivers implementaitons.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  5 --
 include/linux/iommu.h                         | 11 ----
 include/linux/iommufd.h                       | 18 -------
 .../arm/arm-smmu-v3/arm-smmu-v3-iommufd.c     | 53 -------------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  1 -
 drivers/iommu/iommufd/selftest.c              | 22 --------
 6 files changed, 110 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 2357459099f4..3f5e3db7ae1c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1038,10 +1038,6 @@ int arm_smmu_get_viommu_size(enum iommu_viommu_type viommu_type,
 			     struct device *dev, size_t *viommu_size);
 int arm_vsmmu_init(struct iommufd_viommu *viommu,
 		   struct iommu_domain *parent_domain);
-struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
-				       struct iommu_domain *parent,
-				       struct iommufd_ctx *ictx,
-				       unsigned int viommu_type);
 int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
 				    struct arm_smmu_nested_domain *nested_domain);
 void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state);
@@ -1050,7 +1046,6 @@ int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster, u64 *evt);
 #else
 #define arm_smmu_get_viommu_size NULL
 #define arm_smmu_hw_info NULL
-#define arm_vsmmu_alloc NULL
 #define arm_vsmmu_init NULL
 
 static inline int
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index e42a28971182..6389bb1915dc 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -607,14 +607,6 @@ iommu_copy_struct_from_full_user_array(void *kdst, size_t kdst_entry_size,
  *               resources shared/passed to user space IOMMU instance. Associate
  *               it with a nesting @parent_domain. It is required for driver to
  *               set @viommu->ops pointing to its own viommu_ops
- * @viommu_alloc: Allocate an iommufd_viommu on a physical IOMMU instance behind
- *                the @dev, as the set of virtualization resources shared/passed
- *                to user space IOMMU instance. And associate it with a nesting
- *                @parent_domain. The @viommu_type must be defined in the header
- *                include/uapi/linux/iommufd.h
- *                It is required to call iommufd_viommu_alloc() helper for
- *                a bundled allocation of the core and the driver structures,
- *                using the given @ictx pointer.
  * @pgsize_bitmap: bitmap of all possible supported page sizes
  * @owner: Driver module providing these ops
  * @identity_domain: An always available, always attachable identity
@@ -669,9 +661,6 @@ struct iommu_ops {
 			       struct device *dev, size_t *viommu_size);
 	int (*viommu_init)(struct iommufd_viommu *viommu,
 			   struct iommu_domain *parent_domain);
-	struct iommufd_viommu *(*viommu_alloc)(
-		struct device *dev, struct iommu_domain *parent_domain,
-		struct iommufd_ctx *ictx, unsigned int viommu_type);
 
 	const struct iommu_domain_ops *default_domain_ops;
 	unsigned long pgsize_bitmap;
diff --git a/include/linux/iommufd.h b/include/linux/iommufd.h
index 423e08963d90..bf41b242b9f6 100644
--- a/include/linux/iommufd.h
+++ b/include/linux/iommufd.h
@@ -234,22 +234,4 @@ static inline int iommufd_viommu_report_event(struct iommufd_viommu *viommu,
 	 BUILD_BUG_ON_ZERO(offsetof(drv_struct, member)) +                     \
 	 BUILD_BUG_ON_ZERO(!__same_type(struct iommufd_viommu,                 \
 					((drv_struct *)NULL)->member)))
-
-/*
- * Helpers for IOMMU driver to allocate driver structures that will be freed by
- * the iommufd core. The free op will be called prior to freeing the memory.
- */
-#define iommufd_viommu_alloc(ictx, drv_struct, member, viommu_ops)             \
-	({                                                                     \
-		drv_struct *ret;                                               \
-									       \
-		static_assert(__same_type(struct iommufd_viommu,               \
-					  ((drv_struct *)NULL)->member));      \
-		static_assert(offsetof(drv_struct, member.obj) == 0);          \
-		ret = (drv_struct *)_iommufd_object_alloc(                     \
-			ictx, sizeof(drv_struct), IOMMUFD_OBJ_VIOMMU);         \
-		if (!IS_ERR(ret))                                              \
-			ret->member.ops = viommu_ops;                          \
-		ret;                                                           \
-	})
 #endif
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
index 482a49f5c10c..2f79e9a58a5d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
@@ -438,59 +438,6 @@ int arm_vsmmu_init(struct iommufd_viommu *viommu,
 	return 0;
 }
 
-struct iommufd_viommu *arm_vsmmu_alloc(struct device *dev,
-				       struct iommu_domain *parent,
-				       struct iommufd_ctx *ictx,
-				       unsigned int viommu_type)
-{
-	struct arm_smmu_device *smmu =
-		iommu_get_iommu_dev(dev, struct arm_smmu_device, iommu);
-	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
-	struct arm_smmu_domain *s2_parent = to_smmu_domain(parent);
-	struct arm_vsmmu *vsmmu;
-
-	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
-		return ERR_PTR(-EOPNOTSUPP);
-
-	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	if (s2_parent->smmu != master->smmu)
-		return ERR_PTR(-EINVAL);
-
-	/*
-	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the exact HW
-	 * defect is needed to determine if arm_vsmmu_cache_invalidate() needs
-	 * any change to remove this.
-	 */
-	if (WARN_ON(smmu->options & ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	/*
-	 * Must support some way to prevent the VM from bypassing the cache
-	 * because VFIO currently does not do any cache maintenance. canwbs
-	 * indicates the device is fully coherent and no cache maintenance is
-	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't make
-	 * things non-coherent using the memattr, but No-Snoop behavior is not
-	 * effected.
-	 */
-	if (!arm_smmu_master_canwbs(master) &&
-	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
-		return ERR_PTR(-EOPNOTSUPP);
-
-	vsmmu = iommufd_viommu_alloc(ictx, struct arm_vsmmu, core,
-				     &arm_vsmmu_ops);
-	if (IS_ERR(vsmmu))
-		return ERR_CAST(vsmmu);
-
-	vsmmu->smmu = smmu;
-	vsmmu->s2_parent = s2_parent;
-	/* FIXME Move VMID allocation from the S2 domain allocation to here */
-	vsmmu->vmid = s2_parent->s2_cfg.vmid;
-
-	return &vsmmu->core;
-}
-
 int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster, u64 *evt)
 {
 	struct iommu_vevent_arm_smmuv3 vevt;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index eef1fbd68914..181d07bc1a9d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3690,7 +3690,6 @@ static struct iommu_ops arm_smmu_ops = {
 	.def_domain_type	= arm_smmu_def_domain_type,
 	.get_viommu_size	= arm_smmu_get_viommu_size,
 	.viommu_init		= arm_vsmmu_init,
-	.viommu_alloc		= arm_vsmmu_alloc,
 	.user_pasid_table	= 1,
 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
 	.owner			= THIS_MODULE,
diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
index b0de205a2303..2f072f1b1dad 100644
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -795,27 +795,6 @@ static int mock_viommu_init(struct iommufd_viommu *viommu,
 	return 0;
 }
 
-static struct iommufd_viommu *mock_viommu_alloc(struct device *dev,
-						struct iommu_domain *domain,
-						struct iommufd_ctx *ictx,
-						unsigned int viommu_type)
-{
-	struct mock_iommu_device *mock_iommu =
-		iommu_get_iommu_dev(dev, struct mock_iommu_device, iommu_dev);
-	struct mock_viommu *mock_viommu;
-
-	if (viommu_type != IOMMU_VIOMMU_TYPE_SELFTEST)
-		return ERR_PTR(-EOPNOTSUPP);
-
-	mock_viommu = iommufd_viommu_alloc(ictx, struct mock_viommu, core,
-					   &mock_viommu_ops);
-	if (IS_ERR(mock_viommu))
-		return ERR_CAST(mock_viommu);
-
-	refcount_inc(&mock_iommu->users);
-	return &mock_viommu->core;
-}
-
 static const struct iommu_ops mock_ops = {
 	/*
 	 * IOMMU_DOMAIN_BLOCKED cannot be returned from def_domain_type()
@@ -835,7 +814,6 @@ static const struct iommu_ops mock_ops = {
 	.user_pasid_table = true,
 	.get_viommu_size = mock_get_viommu_size,
 	.viommu_init = mock_viommu_init,
-	.viommu_alloc = mock_viommu_alloc,
 	.default_domain_ops =
 		&(struct iommu_domain_ops){
 			.free = mock_domain_free,
-- 
2.43.0

