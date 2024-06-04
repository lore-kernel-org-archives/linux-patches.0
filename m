Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165481422B4;
	Tue,  4 Jun 2024 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717506005; cv=fail; b=WUh2sNKn3jBjzXystyTm1pzN0DPOafUxAdJ2NlXxnU3unuyVLLJ+jOLqkdaZjHmUIGgUAQNEkuoSG+Otwq7rg4plff0FYrtm23dJraXaygSrmJT6td8DeXJJf8bWO1Wg0hKq6c+AqKYv+J8uVk86Gkkc6U09Gmq6mequ0Vh7Kik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717506005; c=relaxed/simple;
	bh=yu4otTvMw2YyZPTcXCfVPltOUNSj29p38iC6dVOGBxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qh14WKBA7rjOILiM+Zvbl5wQs7g4mCmeTrAfq411xl9szavxpzKilfnPv90VV/UebiWUSrttmzTU8V0GgxvdThJ2GVXsCLiRtilFAwqy4MS4fMRmjbjF+xEs0GnYJGd+yi4EBQmnnQye0Zc0rgKBbzMV8y7DlAsOiF9iUG5i7f8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QT24bveV; arc=fail smtp.client-ip=40.107.92.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QT24bveV"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVgItrlFogrgzuKzNYkjrF8mfMe4MJ8DaCLZv+TEsBJBFFul1FAX8eqKiQlYzT5a9gW8owYdxSnkcskZ0l3JSTAOXzXZwLBtR/y/zNHBeaEqMgRZucONnEUIv6ImzwPLPndzndAcxr8ytTAZ06jxVzYnrRM4Z37PhYSjpqvtvsQ8orvswDevUZWHhzAfMGkLoqYkk2zDYpGorJ7mtLItEGFF7IHBxSTXuckdXGBzirbNFpUWOYTRIuaJZrUFeeV5SaXYhJ5gvXP02fjq8hj6qsD54POW5Qzso60YWA3Dff8q2g41r6CdulBfOKdBHj+dfK4HVt0IPW+zcZ0YXt32iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pxmhhyXQU46MZkDZo5vUDyDm4JmP28qiIdHycZF2DjQ=;
 b=m3sLubr709e2XyjhPqhYAPaZO8HDtUeKMH0cC/jp+ZTsHkej+b62Glk5haIqoOzEUgZ0wTeAV5V1DTdEugBCPlU4I795NtE0va+9NcWnce+2DP4swf1fPB+gxM5Lu7Tax3B6rF/KeeYBInx03zhpHj2DHtOcB1ryMoOsBwZy8xSzdkRKZgs1AIujX82WQheDaX5ZQqidZotIkNUMd9A84EzGROy9jobSDaQZcVuG5eUWgSuEq75f24SGIVi/v3Fd4iDUUdXg7ELzl+slwIjgFdNYx/LKzTxnids4iY7d/ecfKB0OnYSmROCFCPkYmaURNagRFzECeR2TIOuI4PUpcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pxmhhyXQU46MZkDZo5vUDyDm4JmP28qiIdHycZF2DjQ=;
 b=QT24bveVtUar1cc8oVL2ubn1i5jctkscLtJKEdVAsJCPu6t0uddkFkfic2FE3f7E51wf39m2DF5AlZgxrlUD2Dm/JFTzc+MzaO3G8n/4Ngaub7nw85Isskt7TU6KAz2pe9WVg4Fx6hgZYvM5uw9p+Bfbou5H2KLLkMjhxRmCbtXzVzKV/DhIN39YyF1NdwyG1D75matk5UK3t0tM4b+pYbIBHBsmlxiX9AViQEjkIzCPemAvk5NCp8YRcOZ1TZA7GAilLpttqLe50twS21FknF2WbljQLCJf76TOlB71E4LYVkViXW4RgR6LB1VXDUB88qqNuTjZU/Kk7jD4ujgcog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB8026.namprd12.prod.outlook.com (2603:10b6:806:34b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.23; Tue, 4 Jun
 2024 12:59:57 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 12:59:57 +0000
Date: Tue, 4 Jun 2024 09:59:55 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <20240604125955.GH19897@nvidia.com>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl7RFCZhAbI/DzwC@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl7RFCZhAbI/DzwC@Asurada-Nvidia>
X-ClientProxiedBy: MN2PR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:208:160::48) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB8026:EE_
X-MS-Office365-Filtering-Correlation-Id: 54f9d7be-1f42-4775-6e8e-08dc84963c63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?beUZ9gm5JzIHha2RbalS3+5HiB1SQR87K2e2cFe4/19duIUnNDMlMyHC9hMl?=
 =?us-ascii?Q?j9zDAwvADXqyRTJyUPhHjIJjT14XcfLUlritokVbN/A2l09rRA1seGXYoZ/M?=
 =?us-ascii?Q?ogSDXjk7+YUrOUpWlnN48k4hsQ8C41vFOA8f8Qrs8V/51XcFhnb6J9UFpaHL?=
 =?us-ascii?Q?SsnWYYWvG1gsJ/6lH0M2TOaC15GJjX3aaJ5xhgRJlqLm/iLp0GhKeW0YiaD9?=
 =?us-ascii?Q?SaZPsOV40qE3z9bksKvN8rsMFECeWAs0MoRvRFyVu2KLy0+f1HzX8CGmP80p?=
 =?us-ascii?Q?FuaiHmqprUWwfhUm02Qt0olPHnIWgWyNUY49j8HKc1uZwdZJjinPTfG5NFVm?=
 =?us-ascii?Q?iegekKf/pni5Ml1uyyk/2fbiRCNzcAsy5mzJHwUE5UJeE72dmZVMM/wdj7XZ?=
 =?us-ascii?Q?XsIdI24MorA3mMXEmu6Umc/4homZtGLHGPqa+VCfgsCsiVHRGO3ssHjUd4Mt?=
 =?us-ascii?Q?qLS+f2Mvrj5Kagywgevz0Tba5jUZTHqvPRGw6urEMdgYWY+OGki3Yv95orFW?=
 =?us-ascii?Q?aTO+t5tSZECyooJb2n3VzpYpts4edVCszhQketSQ8HE2SHCyNAtsoVzvz2Tb?=
 =?us-ascii?Q?4O7D4fahZBw0N+0SFwwzMEj8cxxng1WdoP7vcjawhtppQfji5LyI5yh3dRMm?=
 =?us-ascii?Q?ixoIytajbNKKezTtfa2WlHjG6ANG8ZCO4/mGQme1RRoKBLVCeQaveG1e+zJT?=
 =?us-ascii?Q?wA773Uyk7akPotCyrbcEgnXMS0OOn3TKo9X/fcFsgDF3PLbtKVBH6jdjGUU3?=
 =?us-ascii?Q?Syb9VvfFdFJAqG0yZAucNuirnYaic9veHGIaIUNJKKwFZmtuGR/wxSbJiTup?=
 =?us-ascii?Q?Jg8ofL/Nnsyj50a2qZ+3TKxWrF/Oc8AzKMHpKWJSD4HH0XETZpeZfWKprELH?=
 =?us-ascii?Q?QHIgiEj1mqllwmrYnhPTXV3S5APfIwgClvznU0WiAe51xhVw5KAr8rc2OiuV?=
 =?us-ascii?Q?PgIIEwHDOQJSzSIFscn08g4UVU8Xd08wAFHattLa3yuHoNMOXZA5rFRhnPPg?=
 =?us-ascii?Q?X5RO1IZyGTE7bCWMG2tycype9EPA1etJNMwZN8pDXQJouYWW3bJTp1mRvbcd?=
 =?us-ascii?Q?RC3aS57ZHsxCz81AT/2desDnlvgYMTbkgOgtsm4oAlGn4RU8BQGofWiUgMsj?=
 =?us-ascii?Q?IwCXwfLtHZhHmiA0t+0yYri+XmEBO23ZeUeJiRJ3W4f4PpR+BZXigcp/s5MO?=
 =?us-ascii?Q?l90YpZNLN3kYLaVq8pJ0JDQbG7HP6FPIihC1v7zRlTwchqfODQYaNGGYqb4H?=
 =?us-ascii?Q?JO0cYWZhkRAQ8LTmsN8DVK3kQIYgSDm9toVBm+7dMg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bx1dODzCeKmErPbE7nBESWi4kSw5CZ9gaCnI9a3o30kW5r7tX05hKgL7Cy7G?=
 =?us-ascii?Q?BWiJy2ZE/d9fi3Z75S+gM8iE0OjV+sX7huKqkV3mDKNdjme+TdhfuZ3cc+BX?=
 =?us-ascii?Q?Irupl7q8Y4DGQlyjw0/eF//vuloThfKPlXInZEyS6v1/zfolcS8c3W1moHvA?=
 =?us-ascii?Q?te7qcWLwt01mAiqm6z3+pdbrpyz9jkfCZhzWPzC2HiZhDyTRv0Wg/ibKcVLN?=
 =?us-ascii?Q?r129X/Z7OVVVmxd+UZ/No8cNzY44aNeCXcb7ch8P30HnrqX0uQuao9lM19U3?=
 =?us-ascii?Q?a+JcmXls1z13RW5UmlA8VVFmM9JMb6m02g5UT6gph9Tn0iP6eBsuOVGQ66cd?=
 =?us-ascii?Q?IZ2HIFhqNMK3LUdOHLL5qNukcupyWceKjYRX1w5Fnc8EbmyP0fkg0pKCBeNO?=
 =?us-ascii?Q?COUwtH9NDyHNZnhUveAL7b0t4gnerfjcVglYytmQayfvlbw52onZo0JVgsEx?=
 =?us-ascii?Q?k8PvDzNuXKhsCBwugQpA2VWtbWhZKOxlrdpZ78tINAGQryGZM7z+aUwsXfx8?=
 =?us-ascii?Q?fF+Akj3/OoW2+Hl2YKqblQrMO6/UGJZplhAbFlqu3om8+g+SUujVp1WnJOGL?=
 =?us-ascii?Q?Fj51EW1ldMPuLWc1i3JO/kjWj8qNrb4dalP6RD+kwSDWpNEKhUhiJlfQNyXk?=
 =?us-ascii?Q?du+KWT/lnRMBOaJ7Hp64L2y7zedV9LJcDFytIfvrEuLd056ZydS0q3vuw8Gl?=
 =?us-ascii?Q?Nvbbq7FwUoQFanbGkrEz/KPxH6sBxoDwdzFHwq7qeE1l6BFW4w8bqnPjAtL5?=
 =?us-ascii?Q?aLk2QlUTo6QkvU7djCGxiyaT5CrojENtFGw4i6peqj3s9UodWIlpZVrV/bCz?=
 =?us-ascii?Q?t6M0EnNgIeslO8bMY1d0mt1cEZMkIkRqZ/mNzXpFnh/cd+PKxDhjZ1s2bVbD?=
 =?us-ascii?Q?PpfP9E5KfVwitQb4ny1P5T7MaSP77J04xUc4JZFow+CgWCS3SCJPK8B97Spx?=
 =?us-ascii?Q?YU8qh/H2QV4JlPQ6uPU14Y0M3CFjyK4NrhEavsRIQwtKJxqQx/Y9nEzSJE+f?=
 =?us-ascii?Q?t6pQFcrsJZQ56h959LfCPrRgc7QgwvIiMHo7IvVqPK43cVNMEA3d7gtbcJyx?=
 =?us-ascii?Q?gnO6jyoyPnAo22gQWZAcQHiNLBdLS7XYKwf6HVzPc6kcBDLn6r73ZlqMP9TA?=
 =?us-ascii?Q?gRyydJ7qGMUPmPKBYpIDcgZO2WNTGAvAShUzaDANhHI1mLj9gGFPLrmkBI6p?=
 =?us-ascii?Q?aHWpn8/bWm4tFC6A5U43Jb5MlJuJUiQjB0oC+5ByrbjkrnFTTdOLo9qAdOYP?=
 =?us-ascii?Q?pswDsDZq8KP6NI1MUDbbIID8xBFGQa72eXmqF9HFDW4UjzTndZidGjfxAj7k?=
 =?us-ascii?Q?nN0qARPPJI9Ra8mTIVb8EGGfCY+DCrVlf07LeqKGXBgDxGKKX95kccOS5liO?=
 =?us-ascii?Q?iIquZ7crFFEBD7Vuwwmv4tfXEyzF8y4UHTCnSL3IQaDKyLZ5/nIIRDjvwYlC?=
 =?us-ascii?Q?S2N1veZE+i+LG+/3mtlzXxI+c+O93UTah0njq+ZTE1fnyO4/9tkGKku4Qd/2?=
 =?us-ascii?Q?8qv9MLGp9jbPbsYgs6HpLOKdWDiWZ4p8QdHKII/qND6iidCB6qkKNx+oGhGU?=
 =?us-ascii?Q?c35a6v3EHrZWbIJway0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54f9d7be-1f42-4775-6e8e-08dc84963c63
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 12:59:57.4270
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yjRyJSanrGkV+8CmVEKi+QdAYK5MJDZrHw60YIKUKCCx+FaFKA3UKoSTzMXWALaG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8026

On Tue, Jun 04, 2024 at 01:32:20AM -0700, Nicolin Chen wrote:
> On Mon, Jun 03, 2024 at 07:31:27PM -0300, Jason Gunthorpe wrote:
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > index 1242a086c9f948..4769780259affc 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -612,7 +610,10 @@ struct arm_smmu_s2_cfg {
> >  };
> >  
> >  struct arm_smmu_strtab_cfg {
> > -	__le64				*strtab;
> > +	union {
> > +		struct arm_smmu_ste *linear;
> > +		__le64 *l1_desc;
> > +	} strtab;
> >  	dma_addr_t			strtab_dma;
> >  	struct arm_smmu_strtab_l1_desc	*l1_desc;
> >  	unsigned int			num_l1_ents;
> 
> It looks like we have two "l1_desc" ptrs now in the same struct:
> 	strtab.l1_desc	// raw level-1 descriptor memory
> 	l1_desc		// SW array to store level-2 descriptor memory
> 
> And it gets a bit more confusing that they even use the same error
> prints in arm_smmu_init_strtab_2lvl()...

Yeah, I noticed that too, but failed to come with better names.. The
CD has the same issue

strtab.l1_desc is a pointer to the data structure that the HW fetches
that is the first level of a 2 level strtab, it stores an encoded
dma_addr_t.

cfg.l1_desc is an array of CPU information for each HW L1 entry,
eventually just being the CPU pointer to the L2 STE table.

So they are both the l1 array, just one is a CPU pointer and one is a
HW/DMA pointer.

Let's call strtab.l1_desc --> strtab.l1_table ?

> The "struct arm_smmu_strtab_l1_desc" seems to be only used at one
> place in arm_smmu_init_l2_strtab(). So, how about:

I didn't do it but, it would make some of the maths more obvious 
if we encoded the table structure in the types:

struct arm_smmu_strtab_l2_stes {
	struct arm_smmu_ste l2[256];
};

Jason
