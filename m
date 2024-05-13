Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B391DA24;
	Mon, 13 May 2024 20:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715633911; cv=fail; b=qN4Ap+kDT+LCuQGei19dJqzvePjoOECE8sLCDpLDODtX87K10JcPc1W7j2y9LSzkAMqx1zbuvupbF2pH6L91Ylp5b3L5fSFUyy+1AmRYcVCgMbeiBF3wOANpjJHIKwBRob/11aL5H47+90zH+HRsWoTbI13l8IVKsoIfDX/z+ZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715633911; c=relaxed/simple;
	bh=OoHyHqBZu3nPwzYDoy71ODHXaVjWpBvKXXbzx4BrxVY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ty3xcafugDtzRjpfv0hljTH7DLVbiW8WBJsOixKAkdk3QFb5vkNTJt08SI9xbpGb8auY6BQ9s+XHrkf2KISydEIV3sEIApXQ7uHnBEjHMSt8A1e04YrK5QjYM8KsCH92GS/5mM/k3MLRKygz8t3VG1vFabP0OM6Zz7NG/YNtzwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kjxxnOfI; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kjxxnOfI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZLeBSTD61DjZcjOqPzgbaQFE/Tu+yfW9HFQ+IxvZCm7TzDa29aYYCrwVlUjDMfihDn9V1QBeLL2DnURcnEtpchuUR6M0u5ws/OEKG5TvBg5xn4c7ij2v34Y5DvSk+xQQBy5+NZjraIkgRnm3L8MdO7KXhKrM4xvOIbxA7fLzM2RpVluuC4TTsBs10yZMuHsodnxTSD50Fzhwv3yAqeQ5Ejh3bSh207ulLvR5DcejgaQzZ6Ey2wQzJrD56IgAzOWeo8L/9P03GklDy8Ji+qF4cMOejxqJ+ugDUaMGHemhVNPrzEBiLLU8rlQEVgpvNZDg5gR3Ctw1SRHauJ3+vWsYUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Z9n0NujgPG1xScpmEeh1IlWyopUhF+6S7WFmgUkDCM=;
 b=gMvxdy8XsFRnfIDrjO4dLZuJPHV9l+2aGFmHiekHX5/kqLaLJk2fHIn1/g0qHO02ZbJcJ20e1XpTcrDJjCp7A86IbEaJgNkAWynA+RMmzvGhckA7gWlc0X70Tfb7JllebNCkqzVTdwL6sWYhxnbTuTGfVS9Q9BzhnsxtBtnKjKkQ/70JM368+rcOOzTwhRJUQtzjOLPz7UCYF7vEwo5A73aLkv1PBHsGDQEQw4TJg91GSjGdrR3yjq+YrS7248mm8iBIJ6Y59dlhHgVUvqc89KqShHe6s3Eryezv3PqB4jaZ5rZO3NibRRImNyEQ7442zxgnjrN22lQJdSXOJJvx0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Z9n0NujgPG1xScpmEeh1IlWyopUhF+6S7WFmgUkDCM=;
 b=kjxxnOfIZ8X6ZHGjXppnb3PTIhvRyx4zQ8Ou6AEKRwk/QXNTh3r3PD2NsL/C7UBblQk3yKE+td+SFExUrTct+7+0ERS7Fc6sGAfJntoTLH6YhbwDEQOdbkFucB9EnuVDesXSLWZlkNk0AfpIC32phPchY1b7YudjEuqM307l2BObUg/h71z00taCRxaYx8wQWrxYzb/u6k5lDXFHwAYk+pnmwegSWE3hR3eHztZp4KXnQw7NRyQb4ZM4hFaVDFJzhss+5lSHSPpBakRYtiLSauGJzLcSNZ57nhNEbtvM22P0i2wHpuPSFI5tBOYyeX2vYN30uugItqhs2Cou9rMwAw==
Received: from MW2PR16CA0063.namprd16.prod.outlook.com (2603:10b6:907:1::40)
 by DM4PR12MB7550.namprd12.prod.outlook.com (2603:10b6:8:10e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 20:58:24 +0000
Received: from MWH0EPF000989E8.namprd02.prod.outlook.com
 (2603:10b6:907:1:cafe::19) by MW2PR16CA0063.outlook.office365.com
 (2603:10b6:907:1::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 20:58:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 MWH0EPF000989E8.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 20:58:23 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 13 May
 2024 13:58:09 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 13 May 2024 13:58:09 -0700
Received: from nvidia.com (10.127.8.13) by mail.nvidia.com (10.126.190.181)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Mon, 13 May 2024 13:58:06 -0700
Date: Mon, 13 May 2024 13:58:04 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Moritz Fischer
	<mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 06/14] iommu/arm-smmu-v3: Do not use
 master->sva_enable to restrict attaches
Message-ID: <ZkJ+3MtI5u0XkbfN@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkGsr80xDAyVvFMk@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZkGsr80xDAyVvFMk@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E8:EE_|DM4PR12MB7550:EE_
X-MS-Office365-Filtering-Correlation-Id: 58bf37ad-7b00-4e80-668a-08dc738f6db0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|82310400017|36860700004|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zpBrs59HE/+iB7IY9X3iZg0Xht7NIRc5nAq8b19W2fU3P0Km6MlO3wSOail8?=
 =?us-ascii?Q?mZquIFllgPdHa0N4Vve5hQ+uwDp9v8QaWF8T4K73700IyLUoWfdMxNgeQTLq?=
 =?us-ascii?Q?cKNMK+82mkBYeNg+cNwBw+XjnTUXmNXSAfCNNT8sIWSkNCqEknYj0oQ9z48M?=
 =?us-ascii?Q?LgMSJVDQkssX7L3+Gi/rqSfjLDGsgtiI19THxUgE0qIdymLkvkFbry/NBgs0?=
 =?us-ascii?Q?KTCTWSYnb5W2tYaS0hqcbd1ce5GZJJ9CzgrMPYD33PLAKROXwVER9NUFEhES?=
 =?us-ascii?Q?xyxhgyzvwK5f+KZO3WcYeNBKxlmDZGdj+si8ohydMVZIgOuo5NV+YWI2ZthV?=
 =?us-ascii?Q?Cpjhs8IV7FUhgHrYGxW+yyhADEVk6b2Z3QXiJ3dwucoDv5JDKRedMFipS9a6?=
 =?us-ascii?Q?KFaVh1DJh6muu3JCi4L7CnuehYX1VAyYrVtIZv89dqm/bqJXdi9hEJKEQqdk?=
 =?us-ascii?Q?tPQDk78uRpqaZnyNF/omEbJ0EAIBmnLA81FG/tw2vlrn825KvGy3wMw0b3Xf?=
 =?us-ascii?Q?RIVc73Rwd4/BpyO22VDVOI6gEqcr7ycgDgQ5+heINQ6fd7lLTRXZKY3t+IQC?=
 =?us-ascii?Q?6XtrfBAvJ7g+DdSAWtmCLcqYBBK/MwS8ncbLWCkYyrat3l4DNvo0Sjzg0i9N?=
 =?us-ascii?Q?beJFGAcNL5mT2pKgXPuoQ9qMcPCHckFzyXP1YCZSWmCVX1vD7BagR4Nqjzfz?=
 =?us-ascii?Q?VCCvfIbTahvT3NBJBXIbKFf7r01tOoUx8jzxGEGToxwq0Z/paCoh14JJuimj?=
 =?us-ascii?Q?Xz4sBo0r2gV2n5opC0w6bql33nbNCVtNschLoq8y+LrESQNWqXymQ8Fs8DZ+?=
 =?us-ascii?Q?SL9KgT1kZ0xzVnn42q6PEkPAzcsodpft62/RgJAZjxnaz8XTTnYtuboUK+l7?=
 =?us-ascii?Q?TRBOp4q+ZCbS/QUAmqGsQ8gzQa9TxjwNUAE0fxdUOT4krcXy1vP1uoZX/7dj?=
 =?us-ascii?Q?IWJGGdnP3fFiT0H2WECQ71nWAXXpnbKd8XSVBP9vwL+8Wv1sA9hsTC5b9Mn/?=
 =?us-ascii?Q?kBQAOss9U6ScxL66erI8gpn259MEeBqt5ukPUOfD5kiAn2Hagh9Y2CDPJwKK?=
 =?us-ascii?Q?EFM9KRDNJKNV3HUk6Z54Founr2u1VAHPrsGMtK9SEGBRWk+NGEHtJLscL9sq?=
 =?us-ascii?Q?p3ucyi3OvP/VU6YVQJRmbfxh1TboF3jre9F029W8L0bkhqUe6/8aBsqgLgKq?=
 =?us-ascii?Q?4KeQ5w+FbLPY4Gxfsc1PjcdJhRLG6hjwUgMT192EHfFFTc4Tov5TWjGoSlQS?=
 =?us-ascii?Q?By/u4syBF30VnVfr26z4IUeV2SvZ6S5Z4CSV/oPUPLf+mZePYJopTFqMkfak?=
 =?us-ascii?Q?3plEUvo9NYqtP4dhvd8Ob7YgRp+5vPOir6MSlU7nHeodw4fM20F4cyQ8PzAm?=
 =?us-ascii?Q?V+nGY8SqYRgIYf/5lGPY9I70urWz?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(376005)(82310400017)(36860700004)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 20:58:23.6625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58bf37ad-7b00-4e80-668a-08dc738f6db0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7550

On Sun, May 12, 2024 at 11:01:32PM -0700, Nicolin Chen wrote:
> On Wed, May 08, 2024 at 03:57:14PM -0300, Jason Gunthorpe wrote:
> > We no longer need a master->sva_enable to control what attaches are
> > allowed. Instead we can tell if the attach is legal based on the current
> > configuration of the master.
> > 
> > Keep track of the number of valid CD entries for SSID's in the cd_table
> > and if the cd_table has been installed in the STE directly so we know what
> > the configuration is.
> > 
> > The attach logic is then made into:
> >  - SVA bind, check if the CD is installed
> >  - RID attach of S2, block if SSIDs are used
> >  - RID attach of IDENTITY/BLOCKING, block if SSIDs are used
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  2 +-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 24 +++++++++----------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  7 ++++++
> >  3 files changed, 20 insertions(+), 13 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index d31caceb584984..7627cb53da55b9 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -628,7 +628,7 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> >  	struct arm_smmu_cd target;
> >  	int ret;
> >  
> > -	if (mm_get_enqcmd_pasid(mm) != id)
> > +	if (mm_get_enqcmd_pasid(mm) != id || !master->cd_table.in_ste)
> >  		return -EINVAL;
> 
> The in_ste is added in PATCH-2 and the new arm_smmu_set_pasid()
> in the same patch is also guarded by the in_ste. So, it feels a
> little more related by moving this check here into PATCH-2 too?

Actually, I found this in_ste sanity gets removed in PATCH-10.
I assume we rely on the same sanity in the arm_smmu_set_pasid()
instead?

If so, this sanity exists already in the arm_smmu_set_pasid()
in the code that this patch applies to. So, could we just start
to rely on that here, instead of adding this additional in_ste
sanity in this patch?

Thanks
Nicolin
