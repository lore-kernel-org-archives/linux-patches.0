Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2052.outbound.protection.outlook.com [40.107.236.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2110219A2A3;
	Thu, 12 Jun 2025 17:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749748722; cv=fail; b=uzqfZIpWQo6mqOkt+eJwrmJzat6LOXhBj3jsvb35Je9yGB2YJanUPW9bxJYYx6CNYYyQOMY969cviwa5tuHc2qDPkVs19WG5QbbKeXF+OVPK+Rfh4PXZ/fap5JAX1aAqFhFkzXLVbvqIPqeeUsA8THpUcL+61dRWSBigOtWB568=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749748722; c=relaxed/simple;
	bh=DwG9cwzVS/GF+CpYTR1fuFgF+K949oAlcwc7sI8wsDs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oouI7a2HmtBUCLXT3iKowWnvjSLUmyILVH0RoR/Z/lJS3qys8JWFndM/qKipazzEXOET+EcVgMHhnEPiFWPTcYwL19QtYk9/mtf0yzdA/4QuTQXuIUUd/m3liTHe3iId8oZZkVbXhqQnche5eEzqG0GSUx5kO4vqKAce1am5Qmw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ri95mwKZ; arc=fail smtp.client-ip=40.107.236.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ri95mwKZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kn1qIZii5FgrkvQjcXY3xsTsN5FelsO96fkEVGCKLcCkoiQ+K6TdRrvpID1VXT/p0zOXMy0V/F/KpIBKKQSMrMKUaE0crWR8OUaJI7UDKh9ReoTAhyRbO5dSPYMc2ObDYzP0IDqCkswIWUp66r80r5NtxOgK1fp/EkagZY0DR2nhnjl3o2A+nckUTrFED4SRB8zsNQ09TtgoM4vKjACw11qrSiimrzNboisEYb9aUJOcbTZgUSF+c60A/RK2VIXZGogF0O8VgHhQEPN/9WiOf7bQLZseoIr+Jd9WwKSWNiqVTSoGyb0G7bU9KfBfUfAEthDfOkvS2MezchOp3LoIjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/QHqWUBL9tixbYxZlMXAPDyRypAcJoqwUk88QBoGlY0=;
 b=CEeajWAXbh2qo1UHFKFt/ud7QcNq5eG6+4sEdQZ0cGM5uVJbKKJ19hvkRRVUl9WecH0itDQTPwXENxF7ZqvHvuuAjYNyhWhPQvVJdnoK2a1+tfxVzWcdTFoVuOuPHfcMTQVpib7OPJJy23PbhaKQsgyb44QWX0Ht68oJsBoNDvDGoGUzgH2Kd4I0saP8l1u+kDYw8Pz5bTPx3LxdBDgI91vlUWULVEInuriXJxJcuVWThP992PkU5OoEYa3cGHVX023K0yvSzhUKDOm46YsAspKplJ3gQngrJOxL//SpTs3TQpbQaxzX9nX6kBs7opdtR/ZKHqNZl+Z/+96RIJu/OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/QHqWUBL9tixbYxZlMXAPDyRypAcJoqwUk88QBoGlY0=;
 b=ri95mwKZ646dsYSmreiXDgbXu/VAVdN0gDfVeHDkeNNx5pFAi/0JAfng/iUydCl/mkOKis57mo405qeVxvTcn3Lu/2SYAxEP9DmQH7qhmuB1kznjxSvYv9PWWfgpfhqK6i3gXsHavTCJe9dJMRiK1ZyIoibm2rQN2HfCYKzE0l/txUKCwyZmL2pK2TCUn7kBJQNGK99MpkqVNjiTe/GZNgE0x/7POKU/XAjlYVmk8/O/+F13KSka7x0gV4B2DkI7bEJ5fn3iJFVtnwa9gp0aTzkwMXpZmZA/kEgPah4kcSE9+VNaZtSX0qPKtDxWTHl3oiyf/lwdz0LyKj0jxGS1Qw==
Received: from BLAPR03CA0138.namprd03.prod.outlook.com (2603:10b6:208:32e::23)
 by MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 17:18:37 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:208:32e:cafe::f6) by BLAPR03CA0138.outlook.office365.com
 (2603:10b6:208:32e::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.22 via Frontend Transport; Thu,
 12 Jun 2025 17:18:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8835.15 via Frontend Transport; Thu, 12 Jun 2025 17:18:37 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 12 Jun
 2025 10:18:23 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Thu, 12 Jun
 2025 10:18:23 -0700
Received: from nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 12 Jun 2025 10:18:20 -0700
Date: Thu, 12 Jun 2025 10:18:18 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: Re: [PATCH v1 07/12] iommu/arm-smmu-v3: Implement
 arm_smmu_get_viommu_size and arm_vsmmu_init
Message-ID: <aEsL2mxfO0x3isog@nvidia.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <55b1d69b2cceb685d4eb728a7a53572a9147993a.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB52764E40612C1293699E43F98C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52764E40612C1293699E43F98C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|MN2PR12MB4373:EE_
X-MS-Office365-Filtering-Correlation-Id: 951b2209-c55e-42c8-a63a-08dda9d52b56
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|7416014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KMapU/4r7Y3z39YpTL4RE3Ky8uhnfdLtdILEDMP+SHdV2kX+9xB4Asu57z9p?=
 =?us-ascii?Q?rhwhPFkRJ5Z20ASQ2LX+DDo2uVnZ4BFXr7us3OPIQm0QSYolthpqnqdcZSrL?=
 =?us-ascii?Q?uCvGpg7D1w74SBHs5XqvtwKM+JCW6T3sYGJQo737CA9cP/YQOqPACCl3iyYu?=
 =?us-ascii?Q?XEmzlmar+T2hm53d0e8wWjmHqjTYBNe0zSZ7I+u5UmqxQvqQFmK+C+o0dMpe?=
 =?us-ascii?Q?XHsAiAbzmpYc/2U9JxL2Qf2gFcUec9slyGYsjY8SBXSGMcKOvp0K+I780xgw?=
 =?us-ascii?Q?aAGUFSV2GuFVbU7QYJnA3d8HzgGrO8ZST/4U+H1ZZf7s+qfpmdjBBZfK4gwl?=
 =?us-ascii?Q?NOsuL+kSUP1T1xHJXmnYB4uco5Uw/MEgnY938Ted8/PW6x6RF+DI3grSsqYh?=
 =?us-ascii?Q?/7L51ecCvOOCeOM1r65bzSiUJvTgLK/teXPhVoX3Q/Q//UCge7EH718p5mUb?=
 =?us-ascii?Q?gUQFLKmGMR3JyIK9kTYP8T9cB/IMOWFNnG3wl3Hb5ByyCuIwdIDrZajQsZMs?=
 =?us-ascii?Q?M0r5KEqTS+HdSzzH43xrMg6tgLwT/+Ao3IOi2TXeYM8LUKpC/IdOultBo2bS?=
 =?us-ascii?Q?Hs94JSnSAAIpp8nWwyDaItokYfkkN0dYLW79BWxXabODkPk00asUJZbIWkeN?=
 =?us-ascii?Q?CDkgDj0XzT01QgQVOCV6DvtlqE9YptsFXVHqgq2gZ2xwe6AfMKEw/X1kohaw?=
 =?us-ascii?Q?eXrcA9uVXUGhPLg9yVr6Tv9nLU86jz/SWeGvaQ7GXRQjvMvDxb3xxER5CwoH?=
 =?us-ascii?Q?CWWZqRNsrGjkLRL+mweCUoKOhQym0j9EE8Gi5Z3SX5T4USPOGap0EYQbtT2n?=
 =?us-ascii?Q?w3BgtEnUacx5vOpDpxmtBDs9Om8mt4u/vXzi4Ro/iZNh3C4vYKBHnVDW7Qhg?=
 =?us-ascii?Q?KSvtmeDxAD/S2TwR6RmmAWnVBo7RTY80D+tQhx6sAsBFWsE3qEkeyk2oVnQ2?=
 =?us-ascii?Q?4dCUgEYhvvkQ2SV8PlbCetRLvb1h7JO0juCXzwzvWmzTlasfvglAcnvQ/HU/?=
 =?us-ascii?Q?E+buN9ZgDfxGVRKt53MzfXMpffI2oxJbhqCIubg1EEumqiMV+eMlR1r0H7Tk?=
 =?us-ascii?Q?PbknDoQPiM/qNov9In9p7uQIoCqul9fN1TTsTa/iXPWjhNm1UV18UcpW1b+Y?=
 =?us-ascii?Q?pwbNzc5ZY44wBf3KIdlkSBKIQl5+qrUQWP5exgPWSsZAVh2V+AKk5oT1Ivdl?=
 =?us-ascii?Q?llVNAgrVSoxh2OFpgZDf02PecT5PM+A5mXjKA/NNKoqpv94LlqhA/51/G81j?=
 =?us-ascii?Q?QAPWkhpkGF+qN7lSrdIv4QtCJsoVlgAIsevZw/kfTyrpwUZjb5GwQaX1vwg2?=
 =?us-ascii?Q?PiAeWxYcq8k4ukCk/5xkKSDca8lXIIKd8Hck8e7Tm2+F3erEiv7QqcCgcsqc?=
 =?us-ascii?Q?zGVLvBnUoHCwj9jFjcxocIddduv4Slb8sC8QOe/wcPjTpyXpshiqmVOkO/gP?=
 =?us-ascii?Q?qYlRq1XGUEpqV2fw7eOJcr7ocDghspcKnFFdg1xrHRvpNWCvh+7ApzqSboAE?=
 =?us-ascii?Q?CCcYI/BL2v40c4tMxZZFEGgseHx3ar5F7Iqe?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(7416014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 17:18:37.4600
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 951b2209-c55e-42c8-a63a-08dda9d52b56
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4373

On Thu, Jun 12, 2025 at 08:20:30AM +0000, Tian, Kevin wrote:
> > From: Nicolin Chen <nicolinc@nvidia.com>
> > Sent: Tuesday, June 10, 2025 1:14 AM
> > 
> > +int arm_smmu_get_viommu_size(enum iommu_viommu_type
> > viommu_type,
> > +			     struct device *dev, size_t *viommu_size)
> > +{
> > +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > +	struct arm_smmu_device *smmu = master->smmu;
> > +
> > +	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the
> > exact HW
> > +	 * defect is needed to determine if arm_vsmmu_cache_invalidate()
> > needs
> > +	 * any change to remove this.
> > +	 */
> > +	if (WARN_ON(smmu->options &
> > ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * Must support some way to prevent the VM from bypassing the
> > cache
> > +	 * because VFIO currently does not do any cache maintenance.
> > canwbs
> > +	 * indicates the device is fully coherent and no cache maintenance is
> > +	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't
> > make
> > +	 * things non-coherent using the memattr, but No-Snoop behavior is
> > not
> > +	 * effected.
> > +	 */
> > +	if (!arm_smmu_master_canwbs(master) &&
> > +	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> > +		return -EOPNOTSUPP;
> 
> it's more intuitive to check it first.

Agreed. But I kinda intentionally left it here. The SMMU driver
will have something like an impl_op->get_viommu_size in the HW
queue series. That can simply insert a piece:
===============================================================
@@ -415,6 +415,12 @@ int arm_smmu_get_viommu_size(enum iommu_viommu_type viommu_type,
            !(smmu->features & ARM_SMMU_FEAT_S2FWB))
                return -EOPNOTSUPP;

+       if (smmu->impl_ops && smmu->impl_ops->vsmmu_size &&
+           viommu_type == smmu->impl_ops->vsmmu_type) {
+               *viommu_size = smmu->impl_ops->vsmmu_size;
+               return 0;
+       }
+
        if (viommu_type != IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
                return -EOPNOTSUPP;

===============================================================

Otherwise, this following patch has to move the type check again.

> btw does it make sense to also add below here?
> 	if (s2_parent->smmu != master->smmu)
> 		return ERR_PTR(-EINVAL);

I can't find a legit reason to forward the s2_parent to run this
sanity. "struct device *" is forwarded since the driver needs to
know the smmu pointer: A for the compatibility checks; b for the
smmu->impl_ops mentioned above.

Thanks
Nicolin
