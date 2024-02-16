Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8EBD78685;
	Fri, 16 Feb 2024 12:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708086974; cv=fail; b=pxaXM0H7JaFW+MDTW5E5/cQBWKkpJrxfed6jr28UwM9InbwCuiwQgh8avHUvql2y8WNVw7aFVFnkE1ngmXZTdS0xfUef5ncaIDPMLOWHrpU+UUWAJA8EZqvjE3An2a/Ag8LfFD8x74ayNhSqWpEsLZxWZ0IFcI3Xflq0+8uYbks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708086974; c=relaxed/simple;
	bh=6gSf5PBOy0873gLq/L9klTrxL1gWGBZfM4agpuPjovM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sw9ap6Sy/1MXNx0JURXIpRc24IcM+0kaI9PyPIJOwmEAlhgqegLh3sQJpLcVHnHHndncwlhtLLyGMpGX3P98tEuJfuVBic1L3P5OxWJzu2o2VoKmb77wt8tWG0lhfGloypus4G0r6WBIAXSnedYj0EWMypdKvzoPM4YgenDzLjg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YNmKny/p; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YNmKny/p"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gjN6ELCHZgt4tGuwp5MLqDUypc9yg8W35oIn3wjoVi/oLZXrKwTK1g4TPQMZCCSCbCyV2iHtKswm4BJ9TCeSZscl/JQMNEEZU9sohvTtI/zVPg9T3kbzyCOLH/6LNbB77cKk61cdlXH2LMvGMc2JLbIfvMOMdjJlC/4Jc0bdlTvdlZ/88peJkOKDok9QYB1LDueOzMUI6Pdqf9o4whVLZMyab6axuWgwjHfK8YxUfGnCynP4Qnttw3JhkRJI4JfNDAAi8YKcLHpZPWTYsWPqQ9jCPHy/4cJ89+RgE7PsHaflEzX2+ZuKk+XtP3QH+rOg+ky8RwvJbs9UFFHA6VkayQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bdBowmX972LvucrDuKl3XgLp6uLd3FbSXcYoi5Gg2gY=;
 b=CfT+osdpOXfbH/UMolt/dhcVrizxZrqnP8OYH1ydhWDMUBHpkBWvCavUqYwZdB6NVlfvSdIWjX/hvfK6yfBXX/UJJQ+C1AszVRgOgpWdiHh0Ma2OYrKaUNbCVN+QMGVa9bECdv2Mu9znRxLlZEGRBAFqQVc9ipWlpRKwEAXtoypNdgLfwr7MAuJYxKM5wdx4XSVannFQVYbAlCbB48eyeoA+Bn7/oqOQwO1N4n2T/R6++09lqnX9dNAqA5zLoyp2nZF6lBYfYb2Iq2a9MM1adarTypFqJtI5KC2qC3ykK1P5GjsglU2Wn82+N9Px4kjkteKxRrvciWRxRMyur/lB/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bdBowmX972LvucrDuKl3XgLp6uLd3FbSXcYoi5Gg2gY=;
 b=YNmKny/pw+Uk+fKkohsoIJjxv65uMwgHjL0ukBKe2rT+R7GbNqoczLq2fqF/xSayMIUvN3v9bpIgv9snFYQe0yeC41E81l1Ou3o2ocUKlSBLHQKmLOxAou6bAFw+63SD6eycpDP5u2OpQyko5rlxI6rkzxfqe09/1fl6E7dTjZSPP0NUDwUOY2Lo2fpMOa7bXoZHOCve/jjy0V1jH9KTVwqBcO1YsCpeGh2N1M0/k8GNNoGTS+B37aePdfH+ugdSC6lCl2kP+MSLNkzRNXOHQ3Mkj+tI088aGvHyJjPzewE5SDHvazLJpUo2Ga8VmdsbivTXrd4+SwF6go3wJXkJRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4266.namprd12.prod.outlook.com (2603:10b6:5:21a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Fri, 16 Feb
 2024 12:36:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.012; Fri, 16 Feb 2024
 12:36:07 +0000
Date: Fri, 16 Feb 2024 08:36:06 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc v2] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240216123606.GA13330@nvidia.com>
References: <0-v2-7988c2682634+261-smmu_cd_atomic_jgg@nvidia.com>
 <20240216120512.GA1841@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216120512.GA1841@willie-the-truck>
X-ClientProxiedBy: MN2PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:208:120::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4266:EE_
X-MS-Office365-Filtering-Correlation-Id: e05aceb0-11ae-40d9-0ae7-08dc2eebd919
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QAoQf2SejwdKGyRCNnxjD4B9pHho4lPVRpZ5P3Ats6JFD1bJoEctmUwf7byRw7ZxdS22u9kw8UWdAidKA5SpGQQ9Is1RiubFMO7GwjZlDAZPcIuPcAzKQicLDwk8hix26uVfsQ2I1YipN0mT8DV7Hw0BrfkSNvDyFBBv7wdqSpNeQsAyCoTouBY+jxQ+oy86MjsDlnb0+RMEdPMMOr2yEtCg3Qjnmj5apgjDO2Cepyu0A7eKlOb0J8tEsuAT0sxIP15h3K+4Jzc9nAqIERPFRga2LhPovrwiXzzpXlZ+RLpK/ldEP1zChumXGU97la3NxjlyBGCoEc47zSk0Dx6Ydlte/1rhQR+7e/2izhafZJZO7g6ngBIyaaWsjYp7DIBW8N5Hmo6Nx4rOcPHe/Ltz0emNiLE0z4ohyfPn/hjqZgnrabFc3Nn5ctEhp0S1lnrHhGJNobiDP2jmbPqgScDGEhrDQnWi5J5OQrzfNMgFamrnICFtQsTJJp4g6ZxSvUHHpArpIv/ytShJ7U81s0m31r+ZJDpIvh157etuigm48q6iwKquxZXcZVKwQw5HOgd1
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(230273577357003)(451199024)(186009)(64100799003)(1800799012)(6486002)(6512007)(41300700001)(478600001)(4326008)(5660300002)(2906002)(8676002)(8936002)(316002)(66476007)(6506007)(66946007)(54906003)(6916009)(2616005)(66556008)(83380400001)(1076003)(86362001)(36756003)(38100700002)(26005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/X2xjI/STArNOjJ8eheX0wVMttLCreFqEAOMxvDgqYzfJjKhy3i7owZh+DU5?=
 =?us-ascii?Q?5oNDeI57SWrqi029wm/NIIb0pDGvqyLA/9NWor1rvX2xoOD+MxvSmQ2G90pe?=
 =?us-ascii?Q?8m/182FT7+W3pwy9gr8WZlS2eMKGJGQvV2X5AVtIFc0nZwFPTVXyLCUB3rXx?=
 =?us-ascii?Q?9o7uQFzH1AvnsFo3PcqfUEduBeGhguCwc9NiU0eFn/dW2D8J5WS/cE0B2pnY?=
 =?us-ascii?Q?9xmZtfFCJNyxWdtlUaU2zxZ2+BxFlXSy/Pmsq53Mz9nOO2bejZX9MpPvvEkO?=
 =?us-ascii?Q?TyduXRZgvi3OvahMpkGT4YIy7TDMgA0U9S8XamULHUBVtO/YdO0h3/Ss6mHs?=
 =?us-ascii?Q?4QXOIOPb/BUNhDRardGPAihzOLzT8DuvTnHhB3vnc0BPkkj8dagx5VGPToCb?=
 =?us-ascii?Q?JoaoVuI6e+Ms5VB1nzsRbZREyAAEDL3c7mhIEuVfbrPuPqWkiNPmzX2K11kk?=
 =?us-ascii?Q?E/oR2VymWAkkAapYQKmJHHNNRHjvSHlLODQIbvqfUh5UXBBwzR28emhpLaIj?=
 =?us-ascii?Q?CBawKks2/eYrKyIYnwEcRPiuVyK3xzoH8p2tpktXMgs22KApk2iXeYiTETdR?=
 =?us-ascii?Q?mBWPllhZ9iu9AWsPT8eD4GrCdZCA4PUTz69Yonx22508Ogyu5DiqnuxMd6KS?=
 =?us-ascii?Q?QPP2mSmn2p8AdVUaU0+0l5/BUYva5e9z4YC9EnPvCsb4IrbP/4ls2MZpDim8?=
 =?us-ascii?Q?ohG75PTjmxKY8JQqetdzaPfOp9sN7ImaUDCnTpNUWFA4MHtv2b6iC3F/xZTt?=
 =?us-ascii?Q?JtGORTLwcYzwYeRAdJ3iTkPY7c6e9m5skW/5yPlNieNL/s2pIwGjfDtX7BFf?=
 =?us-ascii?Q?WYw1OIwjJwiIWV4a4VJRKZJxWNi0/KgpBsLcD9WdEIAWN7dvBGqE+YEy5tng?=
 =?us-ascii?Q?DdQUkrQArod0Lo7Id0ywOH2fJSh2MTXzFu/F/BjoHXDxTml0VsziSKpZOkoJ?=
 =?us-ascii?Q?Ve09YdjfIhz0bjMZs/9NxODkkWZHXa4tnQMrYnPVuma0ES0+eugZ3cWXBl3k?=
 =?us-ascii?Q?JQFJhEwZn0ApIBWbYfCqC/HSOdJN0cw/XpFeo1gGZsoAN81631e8OAjHQ+mV?=
 =?us-ascii?Q?UlPGYpeC4voqdAYEq5Ng4ReNFUQSmarUlqZbRUO8vIqRo66vilSDWcnCI1VH?=
 =?us-ascii?Q?ckcfATlbwDT2C2k4amfWUU5HBFUMLwNO6S80RLGPisfD4MApmHUEGGkFKtfn?=
 =?us-ascii?Q?wRhAx7kNv4qT1E6czR/w34oT1P8erLyZVsOwR6IlaSW47E++XM6VNg6T+t5c?=
 =?us-ascii?Q?VOd9tm7R5lR2YMB1vZvkXItovgnodi0vsCzUJlgWh2hVER6XdAY6KZ5VV3OY?=
 =?us-ascii?Q?lsR20CwALU+vG8GAIcGQ6NjIx98H/+i7mqHy68alfKD9rkwIFil0ai2bxhXP?=
 =?us-ascii?Q?QZ88GBnhTONrruWATgvtwIKsKV+5E2EARrbp+g3b4YVfN2KFVokQ3hB4k2o7?=
 =?us-ascii?Q?FkQn/eCOYWn9Az9RQkaOk1fEcmbr2HsqDtR3F6wEpp/xGj5q9BLtIzU/k5jO?=
 =?us-ascii?Q?17bgUVBsqxDrnNXQHtO8vwuPNtICb1TNNY/aWvhsrlJIWMMf3EKvyFaCnC9D?=
 =?us-ascii?Q?NXj2QZaWUl365Xr9Zpw5Wz4cGauSe7HCvZcNza6W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e05aceb0-11ae-40d9-0ae7-08dc2eebd919
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2024 12:36:07.5785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7cc+hnxH5NU3adcltC6KPDpGWXbGY8bEyc7EzFHmvVo+epk2veRJzMMsQkMcMqsP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4266

On Fri, Feb 16, 2024 at 12:05:12PM +0000, Will Deacon wrote:
> On Thu, Feb 15, 2024 at 10:56:57AM -0400, Jason Gunthorpe wrote:
> > If the SMMU is configured to use a two level CD table then
> > arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> > GFP_KERNEL. Due to recent changes this is being done under a spinlock to
> > iterate over the device list - thus it will trigger a sleeping while
> > atomic warning:
> > 
> >   arm_smmu_sva_set_dev_pasid()
> >     mutex_lock(&sva_lock);
> >     __arm_smmu_sva_bind()
> >      arm_smmu_mmu_notifier_get()
> >       spin_lock_irqsave()
> >       arm_smmu_write_ctx_desc()
> > 	arm_smmu_get_cd_ptr()
> >          arm_smmu_alloc_cd_leaf_table()
> > 	  dmam_alloc_coherent(GFP_KERNEL)
> > 
> > This is a 64K high order allocation and really should not be done
> > atomically.
> > 
> > At the moment the rework of the SVA to follow the new API is half
> > finished. Recently the CD table memory was moved from the domain to the
> > master, however we have the confusing situation where the SVA code is
> > wrongly using the RID domains device's list to track which CD tables the
> > SVA is installed in.
> > 
> > Remove the logic to replicate the CD across all the domain's masters
> > during attach. We know which master and which CD table the PASID should be
> > installed in.
> > 
> > At the moment SVA is only invoked when dma-iommu.c is in control of the
> > RID translation, which means we have a single iommu_domain shared across
> > the entire group and that iommu_domain is not shared outside the group.
> > 
> > For PCI cases the core code also insists on singleton groups so there is
> > only ever one entry in the smmu_domain->domains list that is equal to the
> > master being passed in to arm_smmu_sva_set_dev_pasid().
> > 
> > Only non-PCI cases may have multi-device groups. However, the core code it
> > self will replicate the calls to arm_smmu_sva_set_dev_pasid() across the
> > entire group so we will still correctly install the CD into each group
> > members master.
> 
> Are you sure about this paragraph? arm_smmu_mmu_notifier_get() will return
> early if it finds an existing notifier in the 'mmu_notifiers' list for the
> domain, so I don't think we'll actually get as far as installing the CD,
> will we?

I think the paragraph is the right analysis, the code just isn't
listening very well..

Lifting up the arm_smmu_write_ctx_desc() into the caller will fix it.

Also Michael should look at it (I recall we talked about this once)
and Nicolin should test it.

BTW, I have no idea if non-PCI cases exists, everyone I know is doing
PCI SVA.

Jason
