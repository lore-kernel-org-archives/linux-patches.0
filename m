Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B2A1DDEE;
	Tue, 14 May 2024 22:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715727093; cv=fail; b=S4amw/zBsvhVol0GDgrCrzwx04XCMe9iXFVhsPwVHQT/zp6DP3R3GkwZPDoNPiGh4xUPXUe/j99FC7jXiDsbVWZbFmv8nVnvreEugsb4gov3CVb2P+Dn1ZMdOfR/OvDF/K5aUvRkxWnmxVGzKGtP+N/482yonthORj4vDf8pFRU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715727093; c=relaxed/simple;
	bh=03UXtGfs9ljMaavRtfb8RgLYh0K+KGwuOA7Ag3E5JVw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kF04XYCxVUD1OivE1biOOFO+KkZRReDW2lznu8tD4kvQnHFFHVeQ05R6PGzNBOfTdmak0flbi4C4C8NtNG4yePE3SX+Bz9nk40bsHZV7K+hGd+Z5ljc/1in17vlQbDOKe9iegInw3czXKAybVdQGjLLkUqyIJZ8Q5tVflY1721Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=EYQpdcV0; arc=fail smtp.client-ip=40.107.100.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="EYQpdcV0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BEmwS34ppjIfypvWVLOYL3YSfQ9y7DLbJ+8xGf+s61AD5eWktV2ZsTSKUkK0ekfzLgr/6BmUm0OEZmJ2Sxu+8ZFrQ3R/Dxr1XhG+LeBlOvCsgocejGq+lUMG0CmHP5ZOuxdQa3VXl0U1oaRgpSZQIEd2980XBwhgHck9zx6kWrTpV/44YHAf4pSBJ3Ss6Xz1BiqzjCkjVECwGHbRipY9H6mMhtFWvURdF4VGLkEXdgxCDgr5ioTo+z5W1wBxPdWyy/6wZWeEFxYeZTMS9PsdDitU3FvnwOyZ7O8Gvfjp2/Lw8pq2rB1rtfpatLcTUT77ZaLWyG3ao/qad8OdslmEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+2RdftzRy7y5qsgh7TJGIgnPL9CMnr9Ynz63O75CLk=;
 b=Pv13fvmdQUor0P81bWNZNOLj55fyLHbbgdtoTS7bMQazjBYzdwzkzLVti7Of9e7IVG+2eAlJ8dt7W5uE27+KbnvCUnXrjxsJ8XBUsHXUUKo6eJw7PwpJyuZISuZHh7JuxaYpYziQftxZkQ9EwLBHOP+uvmvVT9WHDmCRcMzJZ6I6tt/iLEXfLoYgSOBqJaVRmzKCW3VtOJgJnMWHM0rEm2s9l+MUJ3whDS3ZimmXTwWLqWo36Akc4hq+NGP8BIfn+xz/qMuqbu54/Eljno+Q+4w0DrJPaYR/xRFXi6y7M0ehXHOw5QHkEVOiYC6LYjoGZIc/TefHbiM0dCW7MtC/Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+2RdftzRy7y5qsgh7TJGIgnPL9CMnr9Ynz63O75CLk=;
 b=EYQpdcV0DRhOZwJAnfworxMnI3kpPIttw1Il/TlYV4lEgwlXb0n1HTgpgyIHi/LiCLoOiV5dKz8TZRoA3bO2P66O+w4BnCEvd+ubhD04yviASspFhHBkxIXQmktA0ZFFNkpZ4wFjcM+HdbqzKT/iaZrsTXo+nie8Zrl3n0mNPFgvK7uFMRouB76UqKnfJDCsPKcxROHJElru4GN2s7hgc7HUdpi8kT3LxzfW6wUVm4ltXNjwmJz1X7a3k3nwiKfSmdGNtDkkEkF838MmKpG75lKpW5W5aS92wDxMhS9sNmJd0Jc+LeU+e/OMczit4B+TmGl9lvhPvN/kFu0Ryrei0Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB6943.namprd12.prod.outlook.com (2603:10b6:a03:44b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 22:51:27 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 22:51:26 +0000
Date: Tue, 14 May 2024 19:51:25 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 06/14] iommu/arm-smmu-v3: Do not use
 master->sva_enable to restrict attaches
Message-ID: <ZkPq7RvLKkIQm1LT@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <6-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <ZkGsr80xDAyVvFMk@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZkGsr80xDAyVvFMk@nvidia.com>
X-ClientProxiedBy: BY5PR16CA0006.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB6943:EE_
X-MS-Office365-Filtering-Correlation-Id: a19bfcce-32bc-4a39-c511-08dc74686311
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S1QC8QZ8iwatnEN3MxU81r+DqeeiCFae7dOJ67dqwuYd34S5VJ008zpFyRUg?=
 =?us-ascii?Q?lR65xbYBz0DA2x8u/c8V4IU6r42emFKLirGKryb7QXb1uagn4NnX948XJWom?=
 =?us-ascii?Q?qgXtfS1c95znBDOx5zO/3sdbtb8HJVz3hBxdyTdhPYMgXF07YYBD0wMrG088?=
 =?us-ascii?Q?bPKkVMK/IWPXe4JG49dEmsQuX7MOe37VfeSAHyhEKtLak4nmzlXYtRC3CF5z?=
 =?us-ascii?Q?1gv57omqRtzNG2/MQBHwZvdw6o8KZ5bH4935xvYQRv3VS6K9lBK28fHQZAQz?=
 =?us-ascii?Q?XxQrstkRrw8ucKkf0kr3zJuEnU3EhsRJEs4trVJHaomQcQ5m8+CT8XC7eOPI?=
 =?us-ascii?Q?QU7u/XtbaxnBT3qAL+rVnGQ7yvT4uZfI0ne/U7NUJHkqdRTIBY1zA9B88cXW?=
 =?us-ascii?Q?tSR9kP6i+Bh2pWsf3NEMr5wDfo5RWG1JoQDPa33fJdqH41U5LlDakIhM+Jlm?=
 =?us-ascii?Q?YDMFmWgNh288p4rda241H9Z8e0OSeJXzivPy1fr7D/xmfX+RhnKzpkGiB31W?=
 =?us-ascii?Q?rMA5M/eYO1aridGZXA1a/0B/dL+iasFAkUDvC9w50q3GsPz0qxAGMyQMzIZ4?=
 =?us-ascii?Q?AV+2rjDTUFxG1GF7kVGbuk1mtrdHP4buVZTn4+n2tQflMuzdDBedndqVnDmJ?=
 =?us-ascii?Q?+TOd53mNX5i07tv6qxOE+5UwselCmw6yCoEoQT6ZuUGv1QrrjXRw61FflJPV?=
 =?us-ascii?Q?rmg4r9x4WE+4At7pRG5dfzZ5zaplT6R1YCsKnhs7JXOcYrSCUvZ1u94us6cp?=
 =?us-ascii?Q?Uf4emBkEZLSRNIqES6m7IDsqLQrccji6+6Zl6mzM0siCc8I5F6zaxkBOaq3U?=
 =?us-ascii?Q?xpoGtTjbPWbHViQiwdzZTednwQ5TVRDGYVInIOoaI1i/lvXh3D55odFOKfiB?=
 =?us-ascii?Q?KYNRSNXi800YI2XoCZTfuRv5bNjWH5MEjqiWfjLFZEej2yiuIhU9+urjrTfg?=
 =?us-ascii?Q?7cbJ3OJY9lVOvVAwOvVAKPt3VynBTePQd6aU9xnWMCJUPmmzf5e63Y5btW51?=
 =?us-ascii?Q?N3EVyC/xK+546PKO/mwbjC+Evpg31vNMVIyZWoT2rrjQa9gKKT7k9xqAkPOB?=
 =?us-ascii?Q?B7wO+pJLIYOZfwppCrq6IHXBe2jn9Owf96VMwkNGZWfjhJcorz3Fv7wjJSuv?=
 =?us-ascii?Q?KldZ3ZHq/qHe6jnP/nKaiSyaEa9oSTvLg/Ub5pOp2nVfGkHQoAAsExXuDoxd?=
 =?us-ascii?Q?8T0uMvHubqw3/U12Ur8MiDu0uH9p21xGz+zBSgLGrYqrCmL8t6J7Di6abgfs?=
 =?us-ascii?Q?2B9r60wo2r16JS1fVYmg7BDeThDlpphU8jhCDhkehQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B5F22xahG9JpgPdaA/OzfQL1vJind5ikADV7PwmyQ/QiWbTadbfQOx/gdJkj?=
 =?us-ascii?Q?cgo9cpuXu96ygJW3BeJQDY2xR5EisLxmD0zSBZ3iyh0fTmQYExk8FWmEC6Sj?=
 =?us-ascii?Q?0VvfN9lXe7Zz4kLwLGGQ9K3AV31T5Bgi3NpXSSXNeptfL89VEJfpbMEkomyU?=
 =?us-ascii?Q?e1jI/sGX8jinPBpMN5oBPq0VUCqcqoWHd78RHA2CTXLxc3mNjA5gIPlXHzKy?=
 =?us-ascii?Q?V9KXaZlm9jNe7yZj8T8ogEmBIVVcKf/7c5oltvlS7ngtscFQuazCKDpXkBKe?=
 =?us-ascii?Q?UhYB5iH/BAbfwF9EbVcFbHQh/XKQfrvDp9FwYpCDUs8gfwfud+1QTQhxcNF6?=
 =?us-ascii?Q?EoLN9NLYV96195o9C09iqr4lgnuAHgmdveX28/LYcyHZugqrGYYszWyFiN7i?=
 =?us-ascii?Q?asugS/HDiIhK4OBUalx4QqhrvnYEGrAlp+v4+mL/m4h51rnkgMbe4B95lkZf?=
 =?us-ascii?Q?IhLghYPy10W7PmWiRQL1QbSOkrBJEQ0dLSHcgZfIpBTjeoBmth+YB/+m000F?=
 =?us-ascii?Q?BtMTndkuOW/cB80bujiwSCjtfaC1EL7c4DbPIJ2iatjOUYVleKiiCC8cSOGU?=
 =?us-ascii?Q?flvz4Bw0sr42EW35dYziIp5+2kwLlTBfccEqe1jAGuDyCWu/IOBWq0HMWguG?=
 =?us-ascii?Q?VNpNorBrtqXXWWnIRMtCtbz6CxeBRhsETvzyk/JM2+FMNDCmxTUIj/pPnQqJ?=
 =?us-ascii?Q?07OGOYBdGKeRH+KymIajAv0umAemFHnkoivnH5SEknduWZfjbnvgwwjc2C/V?=
 =?us-ascii?Q?+Ha9au4IicdoJb3+2qed6vvnDww7wufmhA56VylMUmXfTqrCI296E5WtzGDb?=
 =?us-ascii?Q?GB332V1NIrcNlgvC6yjAEgMiO6vewYXBWBoImCp139MpuvMVaXqeMsDhKQFO?=
 =?us-ascii?Q?vhJ9B2KH5bWShGha9z/Z/8zMcYvGIZE3D+KLnmltXw4xK6wgHZx4mb+fGvaW?=
 =?us-ascii?Q?QLYywyOK30/qKyqtZX7JeOFKopidGk0sdXLVpoyQ9TmMdVThr6x4o+Jm00yY?=
 =?us-ascii?Q?UK343tB+3u316plnslbHduuQg8Sdog3wQIqR59yTXrS6C1q+NHFSw+T/QB2V?=
 =?us-ascii?Q?TqETBwogZERDMKYYAaOrj65/9htY2Bgdno1MCUBpa/tkOoeVs1HBen+5JlhO?=
 =?us-ascii?Q?RaAOIUI9tq7Dfrfha16sGQ4ByuxkpXFipBoowR4eYimiVaY+fo6pFpSYblyb?=
 =?us-ascii?Q?/ma9TOPJbZcDqqjryAkJjD/VfRdhZp9ZWDyS8+HgjEfwODENs7VR+SfUPdk3?=
 =?us-ascii?Q?ayGEhFLsHq4vmIN8kQo0S8OlLNt+5dK6hURztRnklgAVh5hbLwAqz+Q1c66v?=
 =?us-ascii?Q?/TaHl7IZfwu3eEDpetiV1fECrC/iz/DV4+Zm8RPBV/pFelz9rzHmz3tuMnkX?=
 =?us-ascii?Q?2xRsfGwXQGMXTcZaxNSNzIsqpexZ9zAuJYwtnxpF9+lZxCLCjf1g8Wze8dtN?=
 =?us-ascii?Q?HueY7z2blcjXjM3LeS1ZXFocnPX1KygFDIYBZTLwdQdAMcYu39deC/zZldUC?=
 =?us-ascii?Q?/rf26e+I9HOXPeqTiQz0wHWJ1waSQxTOP8EmgXo6GT32GPMz3gdU5zASpiLp?=
 =?us-ascii?Q?bTcU1BjG0anu87s8cZ0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a19bfcce-32bc-4a39-c511-08dc74686311
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2024 22:51:26.8738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0zumvk55HJmNtcCpS4rD3tRXmosgq21w+CKyx4khoNnynwMIkSHyFh45mzWgl3h
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6943

On Sun, May 12, 2024 at 11:01:19PM -0700, Nicolin Chen wrote:

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

Hmm, actually I think we can just remove this hunk now. The
arm_smmu_set_pasid() a few lines below will check this already. It was
here because before I didn't have the error unwind for
arm_smmu_set_pasid() failure. Now that we have it we can just delete
this.

Thanks,
Jason
