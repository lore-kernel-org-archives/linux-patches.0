Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB1512A17B;
	Wed,  8 May 2024 18:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715191470; cv=fail; b=UcLPEbYmMc/XsWHPSDpeGeM62s4w4BzcMS+PRGNBwzo35iGOFc2Q3Qt1K7EYiOIZQYnsiVfiI+S+mQU8BpvzxEL0L9rT4+A2O7Uw0nM7rNrBrr1HFu6Mhtht469Gsv+MnaxZctcuSMv+QQTYI1FA1F8DVeu+pDqFwDT/Q02W1P8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715191470; c=relaxed/simple;
	bh=zKfp8BcuwAdLTtoDvfY1BykrHrViMTX7EphNMdlWjG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EgUcfiqSYrYwPNmqVcvP+8uIzd/nCM3tORWTydYdsk2hmyqIkwU1XFtBfnM1nLp7FR+whFG0faDkbuNEcRgY3Gvbm7Ybwvy4/yWhdAu+uFhBqqcI6ARfrYfagrNYHJ6J4XAQUTwSYW9EiX6oMeDiGrEbTQQCZ4/M/xRTkvRlERY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IXjUMEtt; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IXjUMEtt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OYHRmjCwrbUXGp+DX+QOFnNZxhVMuPbWeoJqmYVfj/6dHTaAXYf6ksCjdCEjGGzaiBIhwTMlfTN7p4+UlnPoP7js6dCgET4NkhSjVxwaSDLneqA2LzIlS1p4ME82aALLj9Fx4xeHyiKfOOAv35MTa3shIYqLZ8r31oGfuy2Fffkod+2uCAxg9Ra6PGW377FqpHB9YcwKeEz6DEVuNIW5lauT7aC2rybCNSA9dR4lbWRRUGtvCF5scebYzjlwdBOtWf9lPCu5jbBnWRxIu1WtnVgnhnDV807wGRwEtqXN66RZ5R4l1ZjhCjjfMkMI3ban218KDwPtv8G1xc50xircRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9O5daSiP959eCATboPaPxRmV/35Jz0tBLpQAtde91io=;
 b=S9Q7rEbg7nEVxXRaR1J//eeLVmIj68QOZJiPIW+rlmz7OZDKNhlGyhStYyeZwjdCMMoaIX3wxOWxvQ35isgVlf9nVF/2LmYziQOVn38uN3/SP0AB8z8+Nbd8ROFNWfJHDuasBsMG+lfQJ+9JCPaq1o+J6hwGbfUGBjkrFnmHguIwaf/2zUvUsXMCVtuwnxOq0u/K8EF5yGxgYcCL5660f+DDWM73CqRlXdXSUKNcvYkBvnAgBv5519COdDqtfcbhBrsWv57fY4VgZGYutxhIiW98KGUpURqwFJVOzhlQAVn8ifAGtJkPF1ziZSZCWen1G+PeXVbr+x3CEpSBWXhu2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9O5daSiP959eCATboPaPxRmV/35Jz0tBLpQAtde91io=;
 b=IXjUMEttLVsJa7zD4kijWkpA+DLR6P1Lt9n0i6KoesCcFawPiBygraRmkhr04iXafkjkKGKPUpkEPvhokJC9/W5a5ibl4Bw6+FGYGkYoh98NI9/gSNECZI8a9yalSxRip5Q6W8YiWXwCoZneHTvyDO0DxpPACD6w3xu9o6tZ20mXkk/3/fiBim131/A/Z7mPz8AK0v9ZznXl8/eW3eY3TmGqz5ocQ/WfOzc7j0rhsgeUTk0rVoAoXcpTK3OefBajp3bJQDrAPyGbS3EMg7x8POIckpaj08L/0a3zhVMDHVQlB9BPM1krimna3DOcTrrVoX9wG1/Q6WgyH3610se9kg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB6944.namprd12.prod.outlook.com (2603:10b6:a03:47b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.45; Wed, 8 May
 2024 18:04:25 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Wed, 8 May 2024
 18:04:24 +0000
Date: Wed, 8 May 2024 15:04:23 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240508180423.GN4650@nvidia.com>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
 <20240507140946.GO3341011@nvidia.com>
 <20240507142248.GA22453@willie-the-truck>
 <20240507143321.GP3341011@nvidia.com>
 <20240508165333.GA23294@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508165333.GA23294@willie-the-truck>
X-ClientProxiedBy: BL1PR13CA0121.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB6944:EE_
X-MS-Office365-Filtering-Correlation-Id: 819645e6-66bb-44c2-d69e-08dc6f894b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?usWjmGq1ptF54Dk1E4ZxdTAkkqouRNkk8XWr2MVaOSdIi8TtF3f1yzH1l0IB?=
 =?us-ascii?Q?8dUPBBF1K27C/bJQT+yV50V9fuWUUEXLOhsidHfT8HPTXfB2/Z78I9gvrYYW?=
 =?us-ascii?Q?xSWhXrGgF/xQ8ndOyYsf6orcMoKekFuFVD1qVdOoWn0sT0r7trXtRvA3ld1q?=
 =?us-ascii?Q?KlNUdDxY51ivRz2vufgl2V2LHMQ5Hsd7BysKkSZyNL66V7SXc4FGOlIIRuZr?=
 =?us-ascii?Q?2MoDbvdlc590Oa2Ey867OAFCii6wNCllEn4f7Q3KnyUb7xZ57pt3fOrIdupG?=
 =?us-ascii?Q?qX02xtN07AZZ+msaIrGZuuxaZAZCnuL5K92M4EuZNw0mRePLU0MCvkx5YlZX?=
 =?us-ascii?Q?+SJdQYbm+RKw3M7EOitdJRjS5XuVPM9flXVMdS9FshCuGrH6povY10TSI/vY?=
 =?us-ascii?Q?7+sITDh3DMoZABB/3wiKiHZDOsxf9iz8A1G1f/d7zTg9E9zo80ZEqe203iMa?=
 =?us-ascii?Q?OaOPMhmTAnKHkV/63lXnWin1uRTyObOXduvbrgSEiz/PL5PsficI9fuIjiI1?=
 =?us-ascii?Q?pTsguNxwgRep999Rjlkw7/6MD1t8SiOh41/dpo4xY+dIfu1ULKKSCmWDE/k6?=
 =?us-ascii?Q?6LH9uhQoSv3KshPXZVKcdkP/0WzH2N/Ol4lDyx+JMVl+UK8gwNZa05sVc8ap?=
 =?us-ascii?Q?ydLwc1r2CdrE0f60vxg0+wnPktkL5zO6kGeMipFf0uLvEtnTpQIifR/wj/Iy?=
 =?us-ascii?Q?aPHfVufNZiyCYZWqDdflTLUGKwA05op1RakA8QUWPV9Cd7vKABwaMnlp7fGW?=
 =?us-ascii?Q?202oj9taYS/y8C9zZD9+F7pP19NGs/bQlcdly3g4qCEBq0ectrqsB+29DEwz?=
 =?us-ascii?Q?zyK04Ae/u1z5Zca0wCMBObM3wabo/ytk/VWkDnWm7qgcFyDI/FXZGovCcwbY?=
 =?us-ascii?Q?k8DQWSWPnBMOCbrFs4FSEEnIfsmCsg0+ctohrDvvPd1AfQ613lchDBPCmVlf?=
 =?us-ascii?Q?Q/vbywO1Sv9LpLkTiyQJw3w3neUpWF+pPC1WPJg87gCElkTUZVK5aoKZgVuO?=
 =?us-ascii?Q?3sWeWw6QTH0SxIx8eScUe8C9RhyjNPMVd9Y6448XKm1EAYUTYrEHPOCtJEdv?=
 =?us-ascii?Q?wqEEHrDvd9uFN9PJ+eIdUE6jS0x+mjrRnFmKcog4m05E7tOpF+Sg5cyMylIU?=
 =?us-ascii?Q?MrY5wEo+1XepZWlef/O/TEFRdJfvcZqQjlcO/frQV+LAi0+3kTh6LXd9q/Fb?=
 =?us-ascii?Q?kpZklCDDnkHIkLRssIJ6cK6asY0mY5C8MEtBg+mU8+lvlrln8TSmzXVMfy+e?=
 =?us-ascii?Q?Wk8pOd6666lGey8Z8snNjdAXmlC+Zu7q+GO5ACXzsQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?flhiRqxFAJty0m/Ed0/GQBfQqesGOJEq9ouAY6HMK/d0Wxy+FxyB7p8F0OMe?=
 =?us-ascii?Q?B3J6YOXiMhQxIxpuFH2PsvfJu6jPIIf4OP2Jt6QihcxeAs+MvsgLgw7aASqK?=
 =?us-ascii?Q?loQA/LFYPRi5P/dMLif3c4vy9jVyb5Dsz1otyXd3Sdxqk6d1RUdtwcvd6Rw4?=
 =?us-ascii?Q?/mNIdkJj3QcKPHFfRVmXllz7+Y/DGXaoQAjv835Sqg+ZBdK8GNOt5ROkdLLs?=
 =?us-ascii?Q?2csmNhb+orGPyP6Wx4oVpI9zfHLwdk/suJcjB92kHkxVpYu5ud+3fxD/0LYB?=
 =?us-ascii?Q?Q76hZuzKwFTuREL5E+lXOUX+iTb0sR5gdBNNnwqZ0MF7cP1XG/2k52CRuNcY?=
 =?us-ascii?Q?MhRUZUfbha9dIfwty8GzA1VZHg7QU4nnW0w6EcZFUlblQiaQlH7nAPEtogkr?=
 =?us-ascii?Q?Bf3aBuOHL21/LT087aww/9PuCq8GDfz2lymlLH8Cb/3ahi+bh5800MaLsYtk?=
 =?us-ascii?Q?/WiUqGq8HNiTEn4gtxsFzYCIyvAzJiAP8skXq0B0dBe9iXi9/CWtXaJH2eI2?=
 =?us-ascii?Q?VtvP7GesB4zs4FGvRhELgKz5VxfoUuieap0YP1GWnedEf60xgldrZ4UHWwk+?=
 =?us-ascii?Q?GE3a3eyE6Yq/Hp8I9i6WK8sJjg/+DL3GE5zTYWjuCigKwfYeRj+DFMXUVFe1?=
 =?us-ascii?Q?gyX4pJTxvOUAN2wUPXG7uVRPkHvTQckTDfTLSm8xq5PRIc4bxrs6uez5+Qll?=
 =?us-ascii?Q?6r0aeA2MK+bNPRDGHo0MB1lhC2UqGtCcQXlvfM6guJ/WrsjbZ8CohwBEJ5CZ?=
 =?us-ascii?Q?Wk8L3l++vCLv3PNNNsRJMLxDSx+rTt3P63dN8Y2pqT7gq5bj+MZkkwD6ksZB?=
 =?us-ascii?Q?VfsQU9xDKb3cRHz+P67FC3s0IFpZKpvJV4ZJO5J6lnRC4h/tKShC2+9uT56i?=
 =?us-ascii?Q?wF3mNQfM2taP+VPb6/uWCasOf05RecKt7ei02UTbtRW2mcLYaLWCS/Qykrv0?=
 =?us-ascii?Q?2OZooXJeA1LJGygxXX980wTvT0x14+BmfMgt+1bx/hot0vNWnsJfiy7Di9u4?=
 =?us-ascii?Q?JN7603QajAlDMfn4pgXn52uKOImXTdMix363tzCfu1IC9IgJba9RiiwiI6gS?=
 =?us-ascii?Q?YDCaTulQlF5+SUlwSmNAfMlxjAsGnxPt8ozOVTHzEb1Ad/YSBxYfDDaSdwRn?=
 =?us-ascii?Q?a8b07FtTTrDE+LRehIRamXDgggc2nUfTLPHvDOcyfFZ0RiMRc8BSAp8aQeM9?=
 =?us-ascii?Q?W7iqB9uI3vetBli0RDuAugDj9juIR50ROZKRaiD9NWmLR7/f3kjDTxI45v/g?=
 =?us-ascii?Q?dgtsf7/7F4nf8/n7urRfuV1mzvZgUOqUi2eTrHIK4eDHaIMzZCglHa7JqObo?=
 =?us-ascii?Q?xPyVkkXe6mdf78JgzL1YiHNeBzzZNqJfDPIEns4OjNVtwl9C3wXYoy4+2kma?=
 =?us-ascii?Q?eiuoZT6W2A1Da8sTaEZcZVE0T8uxPyFC/GMu7deNdrVqiOWlLxIlCiSdTRr6?=
 =?us-ascii?Q?rQ05XzmlrFoabj9R+tNuDCw1qQFC4eb1orqw2IYK9PMqu12pxbZMJgn32s2Y?=
 =?us-ascii?Q?g+lGoIuavO4mEBTEHiZ0C240KhfR4CQ9z1AG0/qoI9xu4I8vBC6Jpy4/2/j9?=
 =?us-ascii?Q?WBVSmFfLw0NKC/ECIJ9XM7TLTU/OVIxBEibK6yba?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 819645e6-66bb-44c2-d69e-08dc6f894b61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 18:04:24.7665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lPALHh2m5yGr5e5LH8PLcDNO/6TNDGo00KuAf7z2FOHtZHuP9owN/Xgd4hpFHBpu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6944

On Wed, May 08, 2024 at 05:53:33PM +0100, Will Deacon wrote:
> On Tue, May 07, 2024 at 11:33:21AM -0300, Jason Gunthorpe wrote:
> > On Tue, May 07, 2024 at 03:22:48PM +0100, Will Deacon wrote:
> > > On Tue, May 07, 2024 at 11:09:46AM -0300, Jason Gunthorpe wrote:
> > > > On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> > > > > On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
> > > > > > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > > > > > index 66325210c8c986..c04584be30893f 100644
> > > > > > --- a/drivers/iommu/Kconfig
> > > > > > +++ b/drivers/iommu/Kconfig
> > > > > > @@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
> > > > > >  	  and PRI.
> > > > > >  
> > > > > >  config ARM_SMMU_V3_KUNIT_TEST
> > > > > > -	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > > > > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > > > >  	depends on KUNIT
> > > > > >  	depends on ARM_SMMU_V3_SVA
> > > > > >  	default KUNIT_ALL_TESTS
> > > > > 
> > > > > Would it work to leave this as 'bool' and have something like:
> > > > > 
> > > > > 	depends on KUNIT=y
> > > > 
> > > > Yes, there is a version like this (depends on KUNIT = ARM_SMMU_V3),
> > > > but it made kconfig act a little weird and hide the symbols.
> > > 
> > > Which symbols were hidden in which cases? Having ARM_SMMU_V3_KUNIT_TEST
> > > disappear from menuconfig when the dependency isn't satisifed sounds
> > > fine to me, but you make it sound like it was something else.
> > 
> > That isn't normal, it should show up as [ ] and be limited to M, not
> > be hidden completely.
> 
> Sorry, but please can you explain a little more? I'm having to guess at
> a lot of the details here. Are you saying that the option disappears
> even when ARM_SMMU_V3=m?

If you set ARM_SMMU_V3=y then you don't even get the chance to select
ARM_SMMU_V3_KUNIT_TEST, even though KUNIT_TEST=m is set.

This is not normal or desired, it makes it invisible. The menus look
like this:

All built in:
   [*]   ARM Ltd. System MMU Version 3 (SMMUv3) Support
   [*]     Shared Virtual Addressing support for the ARM SMMUv3
   [ ]       KUnit tests for arm-smmu-v3 driver      

Kunit modular (this patch):
   [*]   ARM Ltd. System MMU Version 3 (SMMUv3) Support
   [*]     Shared Virtual Addressing support for the ARM SMMUv3
   [ ]       KUnit tests for arm-smmu-v3 driver      

Kunit modular (alternative):
   [*]   ARM Ltd. System MMU Version 3 (SMMUv3) Support
   [*]     Shared Virtual Addressing support for the ARM SMMUv3

It just goes away.

> > Thorsten said they are selecting that..
> 
> I find that hard to believe given that the option didn't exist until
> about week ago and isn't in any released kernels :/

It happens automatically because this:

config ARM_SMMU_V3_KUNIT_TEST
	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
	depends on KUNIT
	depends on ARM_SMMU_V3_SVA
	default KUNIT_ALL_TESTS
               ^^^^^^^^^^^^^^^^

They don't need to change their .config. olddefconfig will turn it on
automatically. This is why Thorsten hit it without doing anything
special. Kunit seems to be designed in this automatic way.

> > These cases don't seem to involve a module, eg BINFMT_ELF can't be a
> > module.
> 
> The DRM_XE one is tristate and has this interesting variant:
> 
> 	depends on ... && (m || (y && KUNIT=y))

Yeah, that is one of the novel ways to write the 'compatible
modularity but not force enabled' check

I suspect alot of these just predate the EXPORT_SYMBOL_IF_KUNIT
infrastructure and should probably just be moved into
modules.. modules clearly work better with kunit's ecosystem.

> > I see the majority of kunit setups have it put the test into its own
> > module.
> > 
> > What's the issue here? This is the majority way to do kunit, I just
> > made a mistake not doing it fully when Mostafa brought it up.
> 
> I just think that EXPORT_SYMBOL_IF_KUNIT looks like a pretty
> horrible hack

Let's not second guess the kunit maintainers, we are just users here..

With this patch the SMMU kunit will be run by Fedora as part of their
testing system since it will be built. I suspect similar is true for
other distros. I think that alone is worth accepting this "hack".

Jason
