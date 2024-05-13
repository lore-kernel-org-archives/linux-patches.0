Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2058.outbound.protection.outlook.com [40.107.236.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9782C60;
	Mon, 13 May 2024 21:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715635430; cv=fail; b=g2qfaHcxfAFBChmnjiI+Rszq8AHbtCRerQWMYHJst7kgblrKYMnxeaMf/0QLsBYs+qSk05IQqRdaDubwaCnDHU1T7kqAAEpGYdZcD+iSyX3tNw0A5eekrlENBnfo0glztpzuJF8GRV3igSE2DhyDkOmDMpsUK5Sj4l+d+rxt86k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715635430; c=relaxed/simple;
	bh=dPDT20hs8R129tr5nFFZ3k2xT3WObaGe4wQj/6Gljzk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ukCnjIV2KU7cftvAGtGNu6cp/+p74IMJB2GSIa45VkTzsd5q2w5qG0cchADL3d0Ekmb9HdtZHudjfOgyz/WEAP+3ZHqnrHHO3n+n6wSByM4I+wmruEQX3Hv2i7uWMzIfrJojrlFDul/arrWcdlJZAPgG/Eim4dGW3guLU+coj8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FFk5ra/q; arc=fail smtp.client-ip=40.107.236.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FFk5ra/q"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z/Zk8uXrUfti4LeCwoxYLVdI4XY2mBsOjhFQWLtjPHiUy4bs/VReLxHBHaemPQ5anQB9DJthm4vA9386sicTtAZeQ2TI5AokyzAhmNTfLed8OMvdK0UgKyDJRcRqsMkMLxzJMWX0D6gQNeEtJ+BTdFZqFkocmceejnUOv7gS/BSC40lS7XZAgMRPc6aY3+lqbpZuAf6HN3TkF9OdcoAZb6R7rKyI8iZqWplqpRjKnseRqTCWPIhP0nUHQqz/ilRIWQRALM0Ctjlma7XItBR/27VDWAQNb7LpC9amlu9EQ7063/ByNgrG7AXDq0Q/COMDm1L3C1U8g+aqpAZfWpoBYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9baCXAvWFCc7Jko+v93IbZdpwBBGN8+WdNq9abpN9vA=;
 b=QCe6a/CJRPcbNe4Y4zFxgLHYqlRmn+2Ux/Ug+2IU6FuQw7cQvL/LzaOtnb3QWDo+FtKXkxG5UlmJnL1Uldi2EkbZVfP2qmbWAAecr1oE3I2urp8tVR1nVQOEiyek8uVW0ntiEB/LT4QrmzRiQXNe8Akp55Dr92UBBn1UopWjAAUA9AGPb/EvQZZqzl4wVeZ16Ht2UmxwXOcHn96F/jQ5Q6zMhH7IrT4X0gQqems45yk9Xgt1S4Qx7QC/2oRZT4eD3qjVRAhAgK5t8lQM3zsWDc6EMivbT7wNbVuHoNo3F69ecqvu8+1Nul4eR8csGVVCCp5gIie591J+ZzXUOrURsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9baCXAvWFCc7Jko+v93IbZdpwBBGN8+WdNq9abpN9vA=;
 b=FFk5ra/qJAk2g2ezjrcgsb3nNXCV/a/7cuFY66Ol8Ruc6AimEgbFeAk+wCvcTVVYVGZvXSHizxsFHQduQU12MbQUxuaN2cXU3qMFZj0Pn7VqOpfc2yqcms33jeFXPe+wKUokzWeGur6JkvmSnn2hWLEAdZj9u6fP1K4Zp/h9698izhJaBe3wzpdUjpa7I1kEmT70M2hC6ihufeDJo+N+BiehcMRjOR7jDTDb71sCJTZ8jhgppviFMNtgBF+dEWsJGKuKyp/Ef8VIaaTgh2U6G2dPIyJhYNOcAjGsqurOZ77O2ENAxr4ibMJxsTM73inc1MaXYmp8bDRhhaFuJosCKw==
Received: from BL1PR13CA0368.namprd13.prod.outlook.com (2603:10b6:208:2c0::13)
 by IA1PR12MB6187.namprd12.prod.outlook.com (2603:10b6:208:3e5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 21:23:42 +0000
Received: from BL6PEPF0001AB51.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::d2) by BL1PR13CA0368.outlook.office365.com
 (2603:10b6:208:2c0::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.22 via Frontend
 Transport; Mon, 13 May 2024 21:23:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB51.mail.protection.outlook.com (10.167.242.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 21:23:42 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 14:23:23 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 14:23:23 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 13 May 2024 14:23:20 -0700
Date: Mon, 13 May 2024 14:23:18 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 10/14] iommu/arm-smmu-v3: Put the SVA mmu notifier in
 the smmu_domain
Message-ID: <ZkKExvnPkHWjedAX@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <10-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <10-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB51:EE_|IA1PR12MB6187:EE_
X-MS-Office365-Filtering-Correlation-Id: d51d7fc1-7127-4ddb-d693-08dc7392f6c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|82310400017|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uKbON5VS4TKxtWTp5NRAx4VaAMMggQ57Jzsu8WqZO+/wP5fk67oV2G0lQ+ap?=
 =?us-ascii?Q?s8ZK9W6Iq97jY8VAw5OIVV3atkIVnRq+ZEjd0Z/cpnVJ84wGc9kO58QN51iQ?=
 =?us-ascii?Q?1Nb+o9fHgvmeb/ZQtjp3ICif8zOvEgR3EKkS5h9szgGAlGw6lctvpgCoIUbR?=
 =?us-ascii?Q?Z5c4p+6TaAXxuzLPNVrL/WdS3Ki3vUpOprjrFPLV3y+RHdY7IaVTEOAZrL9c?=
 =?us-ascii?Q?l2BttBhhfZtYpTd8ccjoTOLYwHiFC7LFTqx1zh8JrkTRk1R0HE4MyGZ/FMDM?=
 =?us-ascii?Q?2rNy4u0zXF8uHkgdx8KqIucq9QhLMLMeq/d0yQBNeMttRUJ4hk7hCag5MoIw?=
 =?us-ascii?Q?ERGgxvKsKe41THJBlgN413oP0AiSko3CVwe8cJef4vZz7YqNT2EVo5Dsk7xA?=
 =?us-ascii?Q?JUoUzynVTngO5yTyuQTLplfJIe25KNVQnTXqV8gWPLDWMVmImHI9ORNkh3ps?=
 =?us-ascii?Q?mJL8/xyagb2sSXOGvyq7MbkrjvN4rhpsJEPn89CgRpk+dpeyjPYAAjj0m4Zm?=
 =?us-ascii?Q?CEw79KBIUFLVxM6RUvjB0C0xqJ7+KR0Wn10bLcrI4LQGgzFuPDZcn9u8Wrdr?=
 =?us-ascii?Q?klZrQ3+BBBHPCLEA7PYI2NmuGMx0GEfDt7WUwPE5M/mhLrYTJYlmRZ8fJNHZ?=
 =?us-ascii?Q?V4I+ktbhKbV+4nE9yBNup4F4Q6wBHnCUclIll6ZJ0adKyjGL9XkoA4YXFHE3?=
 =?us-ascii?Q?B+XYxq/6oqQZLhRvYfRhxdlHm+XNABedC/YYI/Ld07Wl6rKNPKqB9NC2cqr/?=
 =?us-ascii?Q?+/hNW50iPDsbyaI+3dyUZIW/GtqXA0pBbX9iXZY6gjbQTsBDRcFJ0oOWpO7W?=
 =?us-ascii?Q?lPhT1e1aHEOcfO/XnP3p/QFUuLHa44G/UtuocfrX/E8kvf/iUCx2iAwwZwhI?=
 =?us-ascii?Q?j/tuftyA03E5gCecja4yiHzrkS3/GGKSUyTQ8usEfB7xfggJqS3lYY7QooMB?=
 =?us-ascii?Q?+YwMzE7TTwZUBLV2x+0xAM0ljFKcp6YeLwlLtcPEoMMzI72mHLB07cUjUOXd?=
 =?us-ascii?Q?L9qpSW1LOn/PBMNTnxoX0JFO9SSooUJBjYGOpO5RNgr2VF8Tr0azpPeTlfnP?=
 =?us-ascii?Q?Ym0me7VPzoG2Np5jPboe6aln/5IynylwcSS+dHUvkAocYSYmkzW7/aP95MdN?=
 =?us-ascii?Q?Mrw5Nt4QZjny0cwcAy4xTLYhiTlopmjU3szwPzfmN4S97A0wXhnBDKj8xCmm?=
 =?us-ascii?Q?R58gzC+nEIpYisrz7ofdnPDGwVZ7Xaa00EDaYvcWVAzgd+yIUrgTpxi8gu82?=
 =?us-ascii?Q?Ci83AeMS04rY7zwQEsE6lhUllaEEeH5R+4FxtjOKCmOZSgEsLVwxxJ90AVxP?=
 =?us-ascii?Q?9QmrDtStrpeQbCQfuYZo0sEvBe439nY+l54ASYM8TPet8g3Mpne6wlvlCx94?=
 =?us-ascii?Q?vJ/QrBv7c8ZHr5V7u5eJMnmTu223?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(36860700004)(376005)(82310400017)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 21:23:42.0422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d51d7fc1-7127-4ddb-d693-08dc7392f6c9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB51.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6187

On Wed, May 08, 2024 at 03:57:18PM -0300, Jason Gunthorpe wrote:
> This removes all the notifier de-duplication logic in the driver and
> relies on the core code to de-duplicate and allocate only one SVA domain
> per mm per smmu instance. This naturally gives a 1:1 relationship between
> SVA domain and mmu notifier.
> 
> It is a significant simplication of the flow, as we end up with a single
> struct arm_smmu_domain for each MM and the invalidation can then be
> shifted to properly use the masters list like S1/S2 do.
> 
> Remove all of the previous mmu_notifier, bond, shared cd, and cd refcount
> logic entirely.
> 
> The logic here is tightly wound together with the unusued BTM
> support. Since the BTM logic requires holding all the iommu_domains in a
> global ASID xarray it conflicts with the design to have a single SVA
> domain per PASID, as multiple SMMU instances will need to have different
> domains.
> 
> Following patches resolve this by making the ASID xarray per-instance
> instead of global. However, converting the BTM code over to this
> methodology requires many changes.
> 
> Thus, since ARM_SMMU_FEAT_BTM is never enabled, remove the parts of the
> BTM support for ASID sharing that interact with SVA as well.
> 
> A followup series is already working on fully enabling the BTM support,
> that requires iommufd's VIOMMU feature to bring in the KVM's VMID as
> well. It will come with an already written patch to bring back the ASID
> sharing using a per-instance ASID xarray.
> 
> https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/
> https://lore.kernel.org/linux-iommu/26-v6-228e7adf25eb+4155-smmuv3_newapi_p2_jgg@nvidia.com/
> 
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

>  static void arm_smmu_mmu_notifier_free(struct mmu_notifier *mn)
>  {
> -	kfree(mn_to_smmu(mn));
> +	struct arm_smmu_domain *smmu_domain =
> +		container_of(mn, struct arm_smmu_domain, mmu_notifier);
> +
> +	kfree(smmu_domain);

Would it be cleaner to refactor mn_to_smmu to mn_to_smmu_domain?

Otherwise, would it feel simpler by just
	kfree(container_of(mn, struct arm_smmu_domain, mmu_notifier));

Thanks
Nicolin
