Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011046.outbound.protection.outlook.com [52.101.62.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B255939A7F7;
	Fri, 16 Jan 2026 18:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768588070; cv=fail; b=gQhpjnjXZl0USt9sg4y/WkwsnNUHax3nob67fK7nmvaE0WINuHg644ehybZqmo8d4O8VSsKa1eKs68U2m5rfmv6dx+jzvLUI+qghp7bBFrcjvhVKcFgJZGf3APi8r78KlClhpsWGn0Rnvo38Ebm+lQq/iz7m2SlvPDxI7Uq4njc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768588070; c=relaxed/simple;
	bh=UYvktm0JYUJlvghOSwGJ35bzM7CyZMbRCd2TZBPl5+w=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LU1aoXMRiXuZva84hsU/GaUZypxhr+t/PRFj0oxmmbys4oEXI0tRmd6N48V6UeQSAT3y7bulSozWjkwqhY3VuicZPMmXNmjwfF5gDFa9+sAQBd2PSrXSS/TMtLS/7DSxDBGNtLC1CFozbyt+h4cavLPkI5/3IE6NkPwfu/1F6ns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=CbfnrYgA; arc=fail smtp.client-ip=52.101.62.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="CbfnrYgA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q8noG2forEtdP3wvrWPIa+JijIpMcPFSdzI4ODk2OiV9ISh0aGqCN4hHXQLB5CRj7jpHHw5f+IdyCTQyhaZoWa921niJBohpihZPEKM40MWvco0kOWwG3IMSxbMsWOrGaqJrP2peN6t0frNEcFPpOf8c6SqdJfhS4uYitkU8nHDO5aqGsGyuT7LrR76SubFtHhlESQt6CGIpkJzBpQpfUNm8DfzwnUJYi2kNFOQBVu7FxL6TjH2xIaFVOkZ3FQZNNqONBNHwyB/K6k/xvbez2ButdXShW4xp4eylbngA6mw78LtRE/NTf5gGp547B+AWBp6T1ltDdXHFh2EE06KHMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2lDQYSJz6YhqvAlEaZwC2CNiY7ZexF1JaixrWWW8ao=;
 b=FDj0FW2U7CgVcQzFXVtU/U3LctlEDcpUGkwBM9ooPQUeRLGf8umTzmeVGP2BR61FXZL6Bh7ryxFTc74ZdCvOREI1vbq9GKMevh3nc1xAHn+5qi2Hmp0QLEIN5QPXp3kPis+mUrWms69anVS4lvbD8koAjeYTvXcIWRvfGqm0MpSvI9lqm0KBojxw8ageE7JS65po/Rs920tPmSNThcIw+ZgqQqDJzdp47qyqcxerMI1KsuICPCiM26r9zKENteGBXZUCYBBcMdvIyr+0x5o01sCJwO4NT8CXACLxqdBIfD8NHEWog/xfFjJPJdSQ++1SVTa/PAP+ETW0GUDwzuWhQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r2lDQYSJz6YhqvAlEaZwC2CNiY7ZexF1JaixrWWW8ao=;
 b=CbfnrYgASGhB2PNFLvITbwbJT4NWXvpL0tR/cp37EvGy1y6D0MEjUyRfEL5B/x0/PZH4rImlx0AqFlJBRS97IM8VkMY4UBz47KlMka2yQd+db7fWjArFkDF/73+RBI1tmAb0IO0C2e29OCxfeyuMuikc/ILJiiGtYffOVc2ZA2NAxbKAkD6/98yL6d7lNKHnhDXUJ/RK1zTfg7DEhwZx/zeaRV1TwZ5t1w/fs65gMDUUZ06/hmalaCCOvFq+d1ZOpFatVJuZLkYkcUCxJirnVMCDyrtqyfBLLKA68IEbz7TMbpfCIoIzl5N7zosW7rTuNmNVDX7f71gxU7J/1z8BKw==
Received: from BN9PR03CA0094.namprd03.prod.outlook.com (2603:10b6:408:fd::9)
 by CH3PR12MB9025.namprd12.prod.outlook.com (2603:10b6:610:129::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 18:27:44 +0000
Received: from BN2PEPF000044A9.namprd04.prod.outlook.com
 (2603:10b6:408:fd:cafe::93) by BN9PR03CA0094.outlook.office365.com
 (2603:10b6:408:fd::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9520.7 via Frontend Transport; Fri,
 16 Jan 2026 18:27:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000044A9.mail.protection.outlook.com (10.167.243.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Fri, 16 Jan 2026 18:27:44 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 10:27:27 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Fri, 16 Jan
 2026 10:27:27 -0800
Received: from Asurada-Nvidia (10.127.8.14) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20 via Frontend
 Transport; Fri, 16 Jan 2026 10:27:26 -0800
Date: Fri, 16 Jan 2026 10:27:25 -0800
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <will@kernel.org>, <robin.murphy@arm.com>, <joro@8bytes.org>,
	<jpb@kernel.org>, <praan@google.com>, <miko.lenczewski@arm.com>,
	<linux-arm-kernel@lists.infradead.org>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH v1 2/9] iommu/arm-smmu-v3: Add alloc_id/free_id functions
 to arm_smmu_invs
Message-ID: <aWqDDRTz5mB1Iumf@Asurada-Nvidia>
References: <cover.1766088962.git.nicolinc@nvidia.com>
 <1541ea4a9e9c935c2f907c0c5f13a4af2bdc2114.1766088962.git.nicolinc@nvidia.com>
 <20251219170551.GF254720@nvidia.com>
 <aVQfhaqfvfLFNZqe@Asurada-Nvidia>
 <20260102155715.GC125162@nvidia.com>
 <aWnI3Ii3KCFmJV3/@Asurada-Nvidia>
 <20260116144120.GM961588@nvidia.com>
 <aWpuGsnyZJWTmgrf@Asurada-Nvidia>
 <20260116171158.GQ961588@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260116171158.GQ961588@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A9:EE_|CH3PR12MB9025:EE_
X-MS-Office365-Filtering-Correlation-Id: 94b9755a-832c-4310-e498-08de552cf100
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cW4+qv+RwhJfMCNI6ccsCgN3cMC7dO/K+WRznUSNM5rdBLkJzA/ncc96BIuB?=
 =?us-ascii?Q?BMBj8wBCWHsWx3CTVV7wWTEPvsVbKK+5Xf/hzqWKxNMJf5EhnP77pLVzbo7N?=
 =?us-ascii?Q?xSwVGJ7OhR/Yio+YFqwBUcZj+vzj5lftDnW3qCIeK6dIz1pW9cI8oxVjzeSn?=
 =?us-ascii?Q?hPyNcvY/XOq8FZOmlG32drRGfjo9qZSapAemiAElBXoiGvx1m0oKjPHbtIV0?=
 =?us-ascii?Q?AGTB4vovfCo3oURZhrm6lJrCEB+5aGjE90KXvn8bZzBEcllQFnwXeMApffUG?=
 =?us-ascii?Q?FnEjSeI21jyx2Lxy65oCM7gu3zpcPNll3t7tcYbOGRSWKIm5/futAIjzBCOL?=
 =?us-ascii?Q?yXHyIaQCxOtTfMyADaZGw5vHLOoyzN+Etl6Mr7PJTru31mH1qN8/R7Vg5m29?=
 =?us-ascii?Q?HUA+g1LtjxwJRnz66ckPeN2RKp5d7oI0IkSTdZpyIucTGt8PeowxdZYyqUpj?=
 =?us-ascii?Q?uc7CHRU3ZYIcCRWQMnZpl8fmE5Jo/btmda1TW2gRGjD2HnUjpP3aJGgZB5To?=
 =?us-ascii?Q?KaZ3R/l611Je+W/4c3O4uzxi8ictiOjRoeGQaA22XD4C4aP5rCT/t/0AG7j5?=
 =?us-ascii?Q?H0LtQeZUCNa3AYOkub9sj1O30gWeJNqKEc8Vh/2nqky++PyERCbPjZHIdfpq?=
 =?us-ascii?Q?FdKLXQpeNZtIFIm1uhC7OXniVmyQoCZNsrYGZsQBpIwGfen7q3qT5TW8snwY?=
 =?us-ascii?Q?NNAAUs2fa5yMjY2xCHYcHJyd/5fdNShHLOO03LYAv5b3rRWEArzrYX33P6hy?=
 =?us-ascii?Q?L7oPY4VHHbeGF7K0D9onDJhonrhxjWZpHfHpT2eTJidaGuSQjBojih6iI1+T?=
 =?us-ascii?Q?6fyBk5j+Mx4y5Uz36A+A2EkiXv+Y3PQ5G9Ro78TapqX1kej1vPESUZkKf/3r?=
 =?us-ascii?Q?hnNy+Bk3D5ZN+tZYIsgatRSxL8VBFoaSR4AWrzsPgpQWmiC8/j6lJN7HXddH?=
 =?us-ascii?Q?qgaCULf01E7XRPkKS/V/A2DaRXUgPndONpi/0DpZpIyvGwm0l5dxM4f8LEna?=
 =?us-ascii?Q?MQNbemBPlBdDdZgZQNX284p6MYCGzeYi2rxqzOlKRSsm/WqO3LQtvqIP+GFb?=
 =?us-ascii?Q?3ESUHC6lgLJ/IEEYCQCA/bYl+fBPzeSWGdnaDrK7cWe6sHctjLb+nGWwKTba?=
 =?us-ascii?Q?OaZOfgSCnTVf/d/RFPcz1NCipDOjq+omQw9aRTXtW1ZC4BBVKJxwnv4UPcJr?=
 =?us-ascii?Q?YWRToIshKx9JHHUyIfB9/e+uwgdSwo08asWo12qMDJXNOcWSDiNqBjhGTrqa?=
 =?us-ascii?Q?b9VyFEdqe8eNf/SykhxCtO/1e+ldCommnvS5nsqKjJ65ERtOqqNKFB6jhdBK?=
 =?us-ascii?Q?xeLsCCTG141QpUnBKjanaH6NjjxTqhDSazYKaHrli4ykjT5S5ZHu6CInVTJ2?=
 =?us-ascii?Q?KiVWAlhPyBYhRx1YklvBm/gaECwbs0eUSQSZ1S1eFcmF0d2/RevX0cOkUPeK?=
 =?us-ascii?Q?Hg/6WbaV3IviowVp5KqcLLVrmny/kQ12d7ZzndJvRCqh4KPWo5MtF2Qd0IHb?=
 =?us-ascii?Q?7ogx96Si0GRClZw+t5CPeBoDAZAwxvYp/3dcFkFlD4oJVs/WjR93S5mToV1y?=
 =?us-ascii?Q?L2SZUuRILaeYlCJRRnE8JT251UxnAAxeJDJkg6GcFGi4kWeTQXaEpNJwi4Wf?=
 =?us-ascii?Q?3hIGnOB0zThjRIcEmvK6wrGysNG+mqsRB2lKytiz5khdm159bssdNRNOqSJz?=
 =?us-ascii?Q?n5HEFw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 18:27:44.1649
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 94b9755a-832c-4310-e498-08de552cf100
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9025

On Fri, Jan 16, 2026 at 01:11:58PM -0400, Jason Gunthorpe wrote:
> On Fri, Jan 16, 2026 at 08:58:02AM -0800, Nicolin Chen wrote:
> > On Fri, Jan 16, 2026 at 10:41:20AM -0400, Jason Gunthorpe wrote:
> > > On Thu, Jan 15, 2026 at 09:13:00PM -0800, Nicolin Chen wrote:
> > > > On Fri, Jan 02, 2026 at 11:57:15AM -0400, Jason Gunthorpe wrote:
> > > > > On Tue, Dec 30, 2025 at 10:52:53AM -0800, Nicolin Chen wrote:
> > > > > > Hi Jason,
> > > > > > 
> > > > > > On Fri, Dec 19, 2025 at 01:05:51PM -0400, Jason Gunthorpe wrote:
> > > > > > > +static int arm_smmu_get_tag(struct arm_smmu_domain *smmu_domain,
> > > > > > > +			    struct arm_smmu_master *master,
> > > > > > > +			    struct arm_vsmmu *vsmmu,
> > > > > > > +			    struct arm_smmu_iotlb_tag *tag, bool no_alloc)
> > > > > > [...]
> > > > > > > +	case ARM_SMMU_DOMAIN_S2:
> > > > > > > +		if (smmu_domain->nest_parent) {
> > > > > > > +			/* FIXME we can support attaching a nest_parent without
> > > > > > > +			 * a vsmmu, but to do that we need to fix
> > > > > > > +			 * arm_smmu_get_id_from_invs() to never return the vmid
> > > > > > > +			 * of a vsmmu. Probably by making a
> > > > > > > +			 * INV_TYPE_S2_VMID_VSMMU */
> > > > > > > +			id = vsmmu->vmid;
> > > > > > > +			return 0;
> > > > > > > +		}
> > > > > > 
> > > > > > Would you mind elaborating why arm_smmu_get_id_from_invs() can't
> > > > > > return vsmmu->vmid to share with a naked S2 STE?
> > > > > 
> > > > > A "naked" S2 domain doesn't have a pointer to the vsmmu, so it is
> > > > > impossible to get vsmmu->vmid.
> > > > 
> > > > An S2 parent domain should be per VM. And a vSMMU on top of an S2
> > > > should be per SMMU. So, it could have stored a list of vSMMUs and
> > > > device attaching to a naked S2 could match its master->smmu with
> > > > vSMMU->smmu in the list?
> > > 
> > > That would cause lifecycle problems if the vSMMU is destroyed
> > > while the nake S2 is still attached and trying to use the vSMMU's
> > > VMID.
> > 
> > Well, if vSMMU code does the same get-build-merge in vsmmu_init()
> > and build-unref in vsmmu_destroy(), VMID is basically managed by
> > the invalidation array. Yes, a naked S2 attachment would still use
> > the shared VMID, but I think that's fine for a nesting parent?
> 
> The VMID has to be managed by the vsmmu itself, it would be a big
> confusing mess any other way. There are multiple invalidation lists,
> so you can't rely on that to refcount things.

Hmm, in which case will we have multiple invalidation lists? And,
why can't we rely on the refcount? (for learning purpose here)

My view is that VM has one big beautiful invalidation list on the
S2 parent domain, which manages all the VMIDs. So, basically VMIDs
could be still tied to the S2 parent domain on attachments. And a
VMID must be one per SMMU instance, whether initially allocated by
a naked or a nested attachment. A second user would just increase
the refcount.

This could work for standard vSMMU case, as its VMID would be only
used by the invalidation function that must be after an attachment
to a nested domain.

Yet, the CMDQ-V case made it complicated, because HW spec suggests
to program the VMID when enabling a VTINF..

Thanks
Nicolin
