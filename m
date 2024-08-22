Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596F31CDFDD;
	Thu, 22 Aug 2024 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724345978; cv=fail; b=O9ab+iN98cAqRBkMfHW1PW3AEdp6jETf+SCJb6AuhJNzBC0iI/h+jve7eIj2F11bvOG6zNMPUdjNNw2xovaRkhV3Uw7wmFK2NBa604lZOld2QEnbeUTDhTAJw9KIX5n2diuXMAwjqZ82Z+bXbDtJNSmuzUM0FYjpmy7YRSFE4Z4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724345978; c=relaxed/simple;
	bh=gZfENkuLPvUHsT3xinSU/0/HOcagatREohaKZc4YV6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BmwWhCUIKi7E740abVLdqNYSrSyqHwkLsmpPn2+3HNkul8ciSyiouAu0wB/ITtegGOVFz5kFRSAuvWDJAKavVScq1nSsJU+hleerB+OPaYxulYGszR54RmjIi1cbIqVwa3Vc0YyNxAAZT11SKFJdq862nmjte3Shs0y78L0FVGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=HYMTOfnR; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="HYMTOfnR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HcVuTI7VlFiI2wTdsAI8f46kj08/wh7mR7sMUQ+n9ClSUhOzubz+xTRIaybETC5D3mFdMSuuw+l3EJQq0HFz9MMXIEoTyfo/37JDEv9nKA39bhjxCsujuJLG3wApQVKxgfrKLJk4+T0VCrVw/e4guJHv+GyYKZqNTFEKAHkWrOhe9RAoBAxVkBrF3fZhoFnDsnuvbhEJKPLjo7lMgrcV2+SAqVv/qU2EVpolv1srMy78Ia8GpXhQf3Um4lua7Zz9dQev5IUoAAT+PjkFy9re3fuL8sQf72Oc5VDrAe8mb2pqbwHkTLTn8aJuFwChWXAMiB1A7GDrF2fnH6hdK7RUyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEgiEvXLYfmjXV4w4iIHHFIwJbH97ckl05qcOjrtaA8=;
 b=Mq60LwQhbV6rItHNR/gUcYkht6hR0NAEnIDaSczwWNwfe1KfpMVszw3/3XS3Nsf1+0QY6VjSk5EUnkH234lO1jEnBfABB7iaufS7a0EJ+hBYWsTTumt1idhkH0c82nWSwmqSk0pLIgwuaDs4AFa3DXg2bYItLsdeGweYRCDHnFZTm3vb+yluy/8G2r7rPCWUqdNR3ETbBzHRzDW0twyLBmSUxnjPIVL/k6AIdbYAr1lq3M/qfRtwViSSmgMKPSzUIkkAQku61uZ7JfWKl2UZF3o83z/AZ/mSEAfaqguXlSp5VZKsLo1sNZsZZ/7PvGQ6UDIlZDRIqE5UTo53LvFQdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEgiEvXLYfmjXV4w4iIHHFIwJbH97ckl05qcOjrtaA8=;
 b=HYMTOfnR1fMn66L9iRAdBYiJYCQbh7zResFW0u2eOmsC+68c9oFz3yBCEFdrniiZRJOkjpv5Wk15lwceRyYO2qGUbeOHPRTE3w4Gk3/P3D0QYir5cqR/ghy4b0ZvMHRoYXpJTdEbADX/7ePbsoVGWnrUs3amhIjEntwHKqOttkZH46sMAqxF1iTx6K62MGf6UgTkvWCsomamHPQPz+PcW1xv438ihnQMe09CLrAmmk+AVzJXsgXFogbN6Xf1GhlsDzGboIu7eEUmTPsCKs9sqki+/rcXrL1O8D5WIIo1ft44XcUSpqONjxweon80K5aUImVUujxbem7Ya+7t7OdS6w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SA1PR12MB9246.namprd12.prod.outlook.com (2603:10b6:806:3ac::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Thu, 22 Aug
 2024 16:59:33 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Thu, 22 Aug 2024
 16:59:33 +0000
Date: Thu, 22 Aug 2024 13:59:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Matt Ochs <mochs@nvidia.com>, patches@lists.linux.dev,
	Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
Message-ID: <20240822165931.GS3773488@nvidia.com>
References: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
 <e978b42b-3077-403f-a5b0-7da6b52f29d8@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e978b42b-3077-403f-a5b0-7da6b52f29d8@oracle.com>
X-ClientProxiedBy: BN9PR03CA0864.namprd03.prod.outlook.com
 (2603:10b6:408:13d::29) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SA1PR12MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: 834ac5f0-6027-4e23-6383-08dcc2cbcb99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?npZdK0pFhc+1lnHi4CEMg0fqVN3QMtwv5LIOjG6soJGb6BAayeO6WxLx/s2s?=
 =?us-ascii?Q?63/cBVSVWLUup85iFaj2sbhJ6rwFAlbTyDLV9pdr93IIPQGzy66Lrkzn0r9V?=
 =?us-ascii?Q?S00LWSSLRGyuo6Ljh2sel82VpvQdCsI99A/X38tIav1WciD6R5c/Vlx5dvYD?=
 =?us-ascii?Q?QxIBmoQk3BVk8+RMkjD8vaBAvKTQnySX3COg9R/4YlCE9KIFqUEvQ6WOoH8h?=
 =?us-ascii?Q?jXCRyLeU8c4YBW794vGpbYZ6xtWL9ysftHnPYw51dxz01FwoB+47LwZRzUj1?=
 =?us-ascii?Q?a1uevxs1OsCUHM6sXxLl+W9lMtzq9jMuIZHlcjtBE96VKtr0hXd+tD63A4qh?=
 =?us-ascii?Q?s3i+53EaZBOMSL79KNi8JxrrRa+sBwIFK7AesKQgnr+tXMqJ9JDZjv482RNh?=
 =?us-ascii?Q?cmhGNUGspPYzWI3fZsyqEoiULnKv7GM7kAliJkR0POKLR3BYhSf7Hp3Izq4p?=
 =?us-ascii?Q?32rdd3z+DICKAOx9LdHOjoDgTTprIG18LZBSKdX9Pgd7j/xG7U0O+yH0wff7?=
 =?us-ascii?Q?2qPfvq2DcWkEoqCqETtABdoCdvFZwAw6pHPmoPjMZg6E/Bw22XYCJ1sdTNZo?=
 =?us-ascii?Q?aovQV4Q0vNpPBhBSp7zdUeljpkRAJyWbea7CvS1pk4V3iGgTNYGP/QJtN7YK?=
 =?us-ascii?Q?OQXJohOlVZRsFPVGGL0C5ObnDOlJs7K6I2DiMxpjTEuDUDWxdmTm6Ww2N3LB?=
 =?us-ascii?Q?asSVBnkB0dM1AQByzPBc5uyGcVS736+gTUZuhNsIvVGir6WGd0j0L/zIuGnA?=
 =?us-ascii?Q?304khnkTkrwDFlVAMQB4XwbT70FjTR3kbiiHoMc6UYlORknsESp8QqApWHBU?=
 =?us-ascii?Q?t8TnBUIo1SvDjLG5vdo5D02+F6jq2SvwoOORFgiesWeZwXwVxrXZgehIVKri?=
 =?us-ascii?Q?NMePrS1ig3Rvyo9FADi7JCtjSGoAkc8WhMqq992IroCSNt+g7BfiDGRrmg8L?=
 =?us-ascii?Q?BxghDyjFx3m915qKZ4eP4RHjJg0Z1aFob/bgawXGuIKOw5VTvwqJcEk1xMgb?=
 =?us-ascii?Q?qG7Ik5T/5cl892NpmAJlY2uFoegLyc+NyK/toFqoRpvTvIx6h9b62XUS3Z9S?=
 =?us-ascii?Q?wa+MZvCGCHmsXkjwmJ2FQL88IYPFvuDKUfP/vjoMU1mcIHHxQjbG4P0UvIwo?=
 =?us-ascii?Q?lf5mgjnF+VkaZfI38rLL9wGwTk4ND5KCL15Kd5vVnfMds22yyi/94nbnc4fH?=
 =?us-ascii?Q?4K6hQYcLoLzJkXrymfvQ2c8x9XUlYOEvdy5C85gYkJI50RKxmHjLok5Qn/1e?=
 =?us-ascii?Q?oO50G7HCPrfWeh5/Ry4WBJr6iVMHoCg+8QKfJHbkB2rr25i5yTrcEfwoowki?=
 =?us-ascii?Q?RMKiFWpEvpUZkP5Du/gB114EJI7XmOjGxXr/py8XWu9qbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gtiZ6+A7bWyzWexgo8v3568UUXV+60k3zxZVCFeTUIZwMKFTLz54CkTeXFJg?=
 =?us-ascii?Q?00Ws9BAPieQ+sn3WucEglSC6/jrVsiZcIze2KQJN7cCV15xVpbexifa50omH?=
 =?us-ascii?Q?ZMYUlm3/pIDXjg4vzHCM55yQ5iUxt8x4tGMlrRt6xq+x3qQazBkW6lkfb+6a?=
 =?us-ascii?Q?o7tyd10DYmkpu1/f31pmnMcBf7Qw28NTq0zXULlZBrTsvgKqWJPp1A3mmrhV?=
 =?us-ascii?Q?2G070yULDX7kO/tkRD0Cg3OwfjLtqHno/kW9JbYozd4mrbrlFA3cGNrmSF5P?=
 =?us-ascii?Q?dpXvmRoGmpu9Yz1mOIrSGcvINx5JOKNfwjBPfiC9RKl2j17njgfsy6JxYa4u?=
 =?us-ascii?Q?IA92yW2GCdJ42GIPv+qLh+dP2aJjXhk7NQhKo0B+fCFHU6f+lHrTksAwNvY8?=
 =?us-ascii?Q?nqA41WuFjuO5janYJG5BIgyhXeOQpfVNpCgkFfmnt9KJbP/pXHUbLeCjF11O?=
 =?us-ascii?Q?E952nvMiob3cpAmGiiOhaYF9SOLocp8lTeurQLHXm4xcPV8mFTiv+Vy0JFvD?=
 =?us-ascii?Q?mnttOu0/DImCqKkn+7RX3Brklo3tj5Ug5CSzOqqDasW2iR25o34pju2Hy0r5?=
 =?us-ascii?Q?y4ESfVcs8K+S5FdocsOaBj3Xrt5898a9fokqr2Tff74Avt5Ujw5Nh5QNs2ic?=
 =?us-ascii?Q?3go+2NMuDeuPJBIJSsIwnx5oG9QjpHGJ1HPURoK4aUCWeUc+5HC994XBEfe8?=
 =?us-ascii?Q?ZUIwcBrwl3XPAbrLusX32vq/xZrBgf0xyZNZ4GyWtdirOFle6kJqkF/TZolJ?=
 =?us-ascii?Q?fUaRMn2LV0LahAB5jjM+BLHIG7vsqH6i7tn6+qDDsoXMr/3VSvbpDoebCIU3?=
 =?us-ascii?Q?92Y5lcfRnaSJWm20nVLTvEmH4o66HCezZAxKLl3EKr+E7RucNywN4iECrwyl?=
 =?us-ascii?Q?ScHb6LrRcDDE5NIt4jRc7trB3FVKPoQOAsCBqXx8WSeWlAFuUe7Kl343PPfK?=
 =?us-ascii?Q?Lkz/5t+oVu6gyQAypQuWFvljTU/cbwZaAO505dVI3ewuAQAyr4cCnCrCGY6X?=
 =?us-ascii?Q?1jytR5XxefidEVflQFA/ncPpxFumcg7ik9Yyr5ipNv24BP1ZwAfw9piRzEyh?=
 =?us-ascii?Q?dfKwJ+juUX5USomroUTAlw2OJ6VeKfsG4tvDUNvj3RNsAO6G1d/EDTGdu4yB?=
 =?us-ascii?Q?x3mpCypdIukwZ2n54nOUeaZm455riQSA77N6spxc+uhXzqcWk8Ki8U4T/TUj?=
 =?us-ascii?Q?j3ProNlmH0AgiJKBMQTozVIL6NUQTHzUVw5ITtk3/Z4hMBJaR3psLRgibjik?=
 =?us-ascii?Q?hkyBhonkAhQREQFYr+Ux6Km8GoJatTTRpBpaFkIKi7KxXQvEtElm3cIoG4BP?=
 =?us-ascii?Q?4JNWDjsuA7gCgX9UW6LYwVz0nH6E93+3BsmWYEgs58WKECBl9/rtyyC0lflJ?=
 =?us-ascii?Q?DsU+vPmDyZh8iCzyVQPDbaXGGzyA4NyUdtFTZlJPG4hAHltXFawTN63cMtjC?=
 =?us-ascii?Q?JxD+n1Wn3vLww3Hu5UWt4TgUSkCpGaNMPIGi8Y9X4pK+dOcx6AaURkdSdGxJ?=
 =?us-ascii?Q?LUYujKI+yd6yylpHJjF+l5lbZ4P99jET7m+mma46u1zZEqmfQ7bYya8k0KkK?=
 =?us-ascii?Q?PLPoHsJLaQP7yQX0PY+My5miRoLXbqw7F25mKbLk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 834ac5f0-6027-4e23-6383-08dcc2cbcb99
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 16:59:33.1120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1jiYlWnJhaLPdykKK55VW8O1oWy2T2QCgu99t7Hl2D15aBh2s0rmCvwF8SZbCaX3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9246

On Thu, Aug 22, 2024 at 05:52:26PM +0100, Joao Martins wrote:
> On 22/08/2024 15:47, Jason Gunthorpe wrote:
> > diff --git a/drivers/iommu/iommufd/selftest.c b/drivers/iommu/iommufd/selftest.c
> > index b60687f57bef3b..c360d5a7675921 100644
> > --- a/drivers/iommu/iommufd/selftest.c
> > +++ b/drivers/iommu/iommufd/selftest.c
> > @@ -1342,7 +1342,7 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
> >  			      unsigned long page_size, void __user *uptr,
> >  			      u32 flags)
> >  {
> > -	unsigned long bitmap_size, i, max;
> > +	unsigned long i, max;
> >  	struct iommu_test_cmd *cmd = ucmd->cmd;
> >  	struct iommufd_hw_pagetable *hwpt;
> >  	struct mock_iommu_domain *mock;
> > @@ -1363,15 +1363,14 @@ static int iommufd_test_dirty(struct iommufd_ucmd *ucmd, unsigned int mockpt_id,
> >  	}
> >  
> >  	max = length / page_size;
> > -	bitmap_size = DIV_ROUND_UP(max, BITS_PER_BYTE);
> > -
> > -	tmp = kvzalloc(bitmap_size, GFP_KERNEL_ACCOUNT);
> > +	tmp = kvzalloc(DIV_ROUND_UP(max, BITS_PER_LONG) * sizeof(unsigned long),
> 
> If you keep bitmap_size then this gets to be a one-liner patch, but I assume you
> want to remove bitmap_size anyways.

Then we would technically read past the end of the user buffer..

Thanks,
Jason
