Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2043.outbound.protection.outlook.com [40.107.220.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7C97D3F4;
	Fri, 28 Jun 2024 21:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719610032; cv=fail; b=RZB3MCpnUTqgkTGZl919eHMfqwKPeRO1j71TVZkG7Sa4ybJJYhwsI04iA2u8aOQJdxqJ8QE5Qe7DnVekUyTomEoO6eqydJg5GShoj1QJQltM74Vl9Dr82DqCVig7eXq64dage6QjwlOm+0Cp5uMLFtihUMULempHI80fySlp+M0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719610032; c=relaxed/simple;
	bh=1NRPJ+/UXYjw4K3+RbFBskLYdaCGcwHm09AcqgMUgdQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tJGDvoJyx7+q+21UwguB3VA1c2ySg5BDCsz1pV7NnqpIm7lPIvFP7r1yh2dqzbS39VHHkNIn0IapMDMYfEwj5Oyc8pYSkc8H2q4adaVYmWY/g9o1p7+uj14mnJ7IiPp0pES+CGcn/rFtEjZ7dQVW7THz54Iyvf1fy4MaA0xe8ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KhU2/2Yh; arc=fail smtp.client-ip=40.107.220.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KhU2/2Yh"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Visp0D4FRmF/OAeObc/2x9B2iY3pmhG8tEaQD0lNlj0JdxdU9n4dNr+yteBkEDt3X+JltLus+vhEEyVtj5eEGJE6rE0InTLrOJBssxcUhpPphHMp6JRq1ZhkcE7XP8BAm1PVBHd0YMS1Y1oMhd5b45bv3gRMrxTc0MHtkVBCuS5pLvbUjdMtBsa4ivK2MuJoAWgg4/fUFuzpRghgW3Bhqb/hEV3lJs3AXLO44VXYyFW04sCdlTHQ+JSdmmyPnpNEY681CuEgkDwMzfuYaQ1acpFN9uL1HeVQorVojZIJsP9cBIR4vkphAK33duyhQarYtIMlzDDJ+mNWACQmN3fbng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eeGHLThWi+cnas8Lvge2IonC9PccvL79yAsLU1eaN00=;
 b=oAiapcjXbtuJ8jYrAAy580ULnKATldwpbHdWr5z/xHYAqamJ7xh400LaAcI+GnfKG/5vBbCyu04n6WHsVybcoAf6TJ1HcCfmteziIIHLJhkgTLU1BEcaMxj2X1vNd7Uxkf55FOPAMRUqqk70lFtFt7gjFvnrBbLS5nELiYwAqUGyXYAfj/n3gSHLaMDgzKHYo3CTfKZ1qEwSTNNq+FvDPufsnrpS6Xtp6eaEbbis44SzgIxTl6bh3z6cr7c1AmQdVeSRHKf4S6Ayj2CdWWMTpxxXHVAZ4NmB2we7AzM4SZcDd83dJ6be+RfA9JwyobGTCBkBCH5lqDB8TDCIEWzfZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eeGHLThWi+cnas8Lvge2IonC9PccvL79yAsLU1eaN00=;
 b=KhU2/2Yh/KyTIny0HFDmtapc6BESyKqVGhlg4jol6hlFu3eCfX3/ICXc9/Sto2gBqGZ026KQS1YV0GdUpkIS6mIX5CNExzdapGFCuQXHvJvW8mEZZzAZlE62RlaGWxtCf0DgseaFFHWMeDxPTkhabBySYWUtV+f5L6elFBvgBy5cxUOGsBx+39ODA5p9pVoke/KBxYDFmk404eVTOakP4nTs1vVTpvSo+S+6r5CzY+w26ipPqHgia7WaLbW1dFCSZZ8UkxpLftI0kOdiT5dhvrbV5HqwOvo6zaGJJhMgCFCatCGUmbSFDMv6dHUfA5BwGzHG+DfunrQA9VbkEC5nAA==
Received: from SJ0PR13CA0239.namprd13.prod.outlook.com (2603:10b6:a03:2c1::34)
 by MN0PR12MB6055.namprd12.prod.outlook.com (2603:10b6:208:3cd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7719.26; Fri, 28 Jun
 2024 21:27:05 +0000
Received: from CO1PEPF000044EF.namprd05.prod.outlook.com
 (2603:10b6:a03:2c1:cafe::ae) by SJ0PR13CA0239.outlook.office365.com
 (2603:10b6:a03:2c1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.15 via Frontend
 Transport; Fri, 28 Jun 2024 21:27:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1PEPF000044EF.mail.protection.outlook.com (10.167.241.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.15 via Frontend Transport; Fri, 28 Jun 2024 21:27:04 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Fri, 28 Jun
 2024 14:27:02 -0700
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Fri, 28 Jun 2024 14:27:02 -0700
Received: from Asurada-Nvidia (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Fri, 28 Jun 2024 14:27:02 -0700
Date: Fri, 28 Jun 2024 14:27:00 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Kevin Tian <kevin.tian@intel.com>,
	<patches@lists.linux.dev>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Require drivers to supply the
 cache_invalidate_user ops
Message-ID: <Zn8qpB6Xigupm+Ge@Asurada-Nvidia>
References: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0-v1-e153859bd707+61-iommufd_check_ops_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EF:EE_|MN0PR12MB6055:EE_
X-MS-Office365-Filtering-Correlation-Id: a1ab0a26-4e0f-4164-8845-08dc97b90e4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mWw1uGfiFtL5oQr1rMfV6a9Abg9XEn7D72MV4mI/XVPd9RmWyIKW1+ge3kb5?=
 =?us-ascii?Q?72S3+Q/6rM3M1YhCc2RHdqpyUUR6SD6OGKbeh5U0syTXCBOxpfab4+9tGuSq?=
 =?us-ascii?Q?UXvj5z7gJictPEXD24ObsJNNUdn89gZHXMQUKmH8qzwLF3DwypyMoqCmOT24?=
 =?us-ascii?Q?1upiom2NUey1vk8mqmWJxWFOfGza8q4amCvVxEh6EiwgUVkQtPTVTRaFC/Fg?=
 =?us-ascii?Q?BBwBVRtx955AUwjdunAG6CrWcEnhrCF0ouqv2rKOj9iblIlz6e36MJjQvqBc?=
 =?us-ascii?Q?z6HI46vRniEimldkuupVeyp/+Kq2Y5/DWJynAHXC+YkvUQxwN4egOzTZKVWT?=
 =?us-ascii?Q?I8zt8Agth2QwpDMtwNBy0IAAPEQ6bUcpqC5PXzVHOOZK86xuWths4AxogXe+?=
 =?us-ascii?Q?2HXZyVvQURdV25B9LGSU5nMsjVA0hrioS+EkSePzu9GAmvgpC/FeCDXIZjxv?=
 =?us-ascii?Q?p3d09ximrg73rWrDI9xUJLj2+BkKWSuZqDxh6ZLZ38ueP/Pv1nD9xQopoFTL?=
 =?us-ascii?Q?EwOgDFWwAK/c19//KhvL8+pPEbBufJqSqdS+SSb6Haa4K3hZkXVs11pE2WqL?=
 =?us-ascii?Q?XtnM+29/9OQQZK0GrUQgwzXMnhu6A0DEWyx9APeC5gn1rzzUyrYfUmXP9Yy/?=
 =?us-ascii?Q?bpMBmYVL60lydBvxf5jee7v6P//a22QbCLegnjCbaibgRlCs3b2Kh5IvKAC0?=
 =?us-ascii?Q?Po27F56tBBGotnnKwzQx+VdBuBHUSR7FdzAUTZwxYd+j+6m1au+v4FmygkvC?=
 =?us-ascii?Q?/pL4XTxDVa/yHy58p508tJQ9NsV/54Rknxhx0h1jp2ED1QM9toJAKqTBi9RI?=
 =?us-ascii?Q?YCVEEWjkMhdkfYgc679C2irPYEsfGYJxA8hASvZ4cXpnCWJtHNfD/kEsjpIK?=
 =?us-ascii?Q?GF82IvZ3qQH2tCN2kiLgjmVqK8o591SfJWa/g8xthCyQnwZNDtmRnKKTkioh?=
 =?us-ascii?Q?e7JuiOhEyaMeAVue8BR/ZJ77TQOEmx0obcrEGE7xeKfAV7sYnwqveA7aaz4H?=
 =?us-ascii?Q?If3dONQZelZQVp1n7Y4eN+G6uZevxmCeuv7KkYSKo1+GzveJt/l2nr2grVPB?=
 =?us-ascii?Q?r811ue2YryLFpLUKnoRJNKALmEuoscepVzzZ3pZ2Hwqn4QInvLRLJsh6XwhT?=
 =?us-ascii?Q?noJ1cclNKdVNV+TXo48Xh2gbDXbzIVM313VpBDScfUvTmbekdWnqPOkr2spr?=
 =?us-ascii?Q?Y6d/eX3Dv/q17jjB5smTagO9qOfh4Uys8MNQkbTjsovy5aYg+UwQTbFze6CY?=
 =?us-ascii?Q?r6vL3R8+JLyW4j2Y30kiItY6g9sIVx2hX5vYmsh7uzjecSWP6dws7LtH9kU3?=
 =?us-ascii?Q?Vqvh9LXnhUV7biJsr7No36NRXyD17mQbZ/tYo39XuBsCB804rICVSHPyX0y9?=
 =?us-ascii?Q?4RFv/dboCeecsJcinkfzTnX8ZifHEIAQsPjyaWxYagIEceBgC4JE5OaOihW9?=
 =?us-ascii?Q?kwlX1rHXyyZgmhhia/GyTz7mqAIRsY1t?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2024 21:27:04.3939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ab0a26-4e0f-4164-8845-08dc97b90e4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF000044EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6055

On Fri, Jun 28, 2024 at 01:11:11PM -0300, Jason Gunthorpe wrote:

> All existing drivers implement this op for nesting, this is mostly a
> bisection aid.
> 
> Fixes: 8c6eabae3807 ("iommufd: Add IOMMU_HWPT_INVALIDATE")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> index 33d142f8057d70..a9f1fe44c4c0bd 100644
> --- a/drivers/iommu/iommufd/hw_pagetable.c
> +++ b/drivers/iommu/iommufd/hw_pagetable.c
> @@ -236,7 +236,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
>  	}
>  	hwpt->domain->owner = ops;
>  
> -	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED)) {
> +	if (WARN_ON_ONCE(hwpt->domain->type != IOMMU_DOMAIN_NESTED ||
> +			 !hwpt->domain->ops->cache_invalidate_user)) {
>  		rc = -EINVAL;
>  		goto out_abort;

Oh, we had that initially, yet lost it when splitting the series.

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
