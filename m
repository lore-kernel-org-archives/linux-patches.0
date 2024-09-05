Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3349610A1F;
	Thu,  5 Sep 2024 15:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725548479; cv=fail; b=i4vY/hauNJ/yqDkOD94ldSpp3wy7FzxR2G3aQBrd9I5zZc30WkaZ8Jq1N6y4OrTpvjuo/Q/82v2yUEfTsFjTjlOOSz0Itq4iDf5QKljRrVp9ektLfapjyUj1C4FAvbuOadT3V2Q7/dYgV/W0PauA6euXEGlGnOPYW77c3NN3kq8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725548479; c=relaxed/simple;
	bh=K+6nD/IMLRj5UfaNO3BHeCw72ncGm+Ld54uSadnIpGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pZzFLF+wmeR/pJEXgLqLJhA08hvDZJ/ljkTuaNorP5GyKY3iRUfPORjlb4PXQGa4rRyWHTW3X8gYj74ye0nAgwZFQqiZ9vcFh3M+3Qq/r8Qt3Owc6IoeQRbLeXPxG3vsqxMNtvRqJ2APGGw/C3/1TOWRIVycwRkGEadQ8DCaXmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=So4miPGy; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="So4miPGy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ch3ihgZr5KetNPiC+Q+2/82Ke0pYtC5x92fcc1LLtwlUyRcBEHrVdwWigBXDghzDrG8XzIrj7uxVO+SgQPk67eHnbNd3tiYvZPRP0/6WWJBIgTeZTRlfUB3nIr/cRAWQ+5bfwvW8kb0lx9CtfjdPM/4iDP5CneqNI7WNnO0BOcbJgHiWAEcCToD3QRSDVMOkzGGYq0joLsQbVpMMaBURKqx4o6ArTAAjGl958y0cg+ikEmckIzXOuTZISwr6TW8wP9KedjckyIsWGXgGnfb0mvcrdqn6wBHSydfe4BhO32ObLJ4snuExKtuaqynxrj8ykrLVtmq24KoEHra6Aa2PaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aArNo1U603xPivFZoN82G3tKRVCq/pbmaYjPOZdCkUQ=;
 b=iZCD4ZWkJGvgVT8Ca6GZ3UnDktwin2OJAO3Gl60Osi9m6kZrn0jWuja70wjy1oIKU2QMDdPoyOgShu0vnqJceAi0ZGlJEV169gVHRd5NJc0EYauRcCC8+5k/6+DEnyATRKM/3S8c/DFKhSC/YTq65OrkAPeyHt8PrzVYWcU/OA5qPIRhdrY+EOuix+Udhu2xB2Qds69GUS11I9JNZxVReegaN0mhWJHk/wyx77J1xUNbGcTa9cZaJjFL+SaaQ+pVsGxsiMfMXFYZD8YkV/UnreFZyBNpYfDUsOICk7gU3noOPFmylKM72DacqUmXt3U+f/7nh/bSgjDoLX2/TVx9MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aArNo1U603xPivFZoN82G3tKRVCq/pbmaYjPOZdCkUQ=;
 b=So4miPGyz2irnD74eOsJfHg80czG8wyFkXEeFKdArR5bYTMTqYIPShR+sn3kN8zBw33/DOrFhYVf2NaD9qoKH+Dpmp1dAGYNXvGFV7tPEtALRyhCG3CF1IcvMyiqIAg3slpepMhlNznCJ/I2ZiBKgNlHh5/5SgKhMKYk9MtOebDNQg12PIAr3EhacSj505Ux1e0GilcYjFIx9i0EZeCbXHuh0pPFKQTnoOT7DDZ68zU6W6P/XefunK3n0QLGJai2OyIhos8zELwDoy1cjDYr5clA3iD2jM/YBxCoUfkMQcCNxor3ITFe16tUIcnkeL50L/0yXeXHM++Fzjc9+r5tEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by LV3PR12MB9120.namprd12.prod.outlook.com (2603:10b6:408:1a3::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 15:01:14 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 15:01:14 +0000
Date: Thu, 5 Sep 2024 12:01:13 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev
Cc: Kevin Tian <kevin.tian@intel.com>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] iommufd: Check the domain owner of the parent before
 creating a nesting domain
Message-ID: <20240905150113.GA3117425@nvidia.com>
References: <0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com>
X-ClientProxiedBy: BN1PR10CA0005.namprd10.prod.outlook.com
 (2603:10b6:408:e0::10) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|LV3PR12MB9120:EE_
X-MS-Office365-Filtering-Correlation-Id: 799c8d7c-a68b-4dc3-3f68-08dccdbb961b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WvHSsPf3zOi/fDVFcMgXG04A282L+WgWpDzzJT0PNsNkzHG6Rzxn+H4ReYdS?=
 =?us-ascii?Q?7ZAvBxhEz0+GQDefS5dli1zpcysxFXjgtvmk5ewIxwxX8LIf70OzXHQ23dPV?=
 =?us-ascii?Q?aAGxUIi9VnXS8YFVsqAQ1Hvq0ovSZ/EPRBRC1YcMMHqsP/5twSz5FA3142YY?=
 =?us-ascii?Q?ktP5kOLeUAZrzH+R8QMYmu6/erdYoXR7VN2ouGo+BsbumE8kaxVUusAobLvX?=
 =?us-ascii?Q?/8sbdhoiBJDgft/F9h+qoHsFNZUlodisOSTHjXrChdrXmtKCtdqL58X66epo?=
 =?us-ascii?Q?mABvAWbGCyE4kWiqt/tV3jiPTzDxQcGVxQ9KP5DBe8xWJbmG+L5eI3XW5xbN?=
 =?us-ascii?Q?rE9EHc5yPNCzUZUR53Z73JEnu+f5sl9lYFHZKJ9E5KiPqzZJwsPREA4cBHBN?=
 =?us-ascii?Q?OkyoFQfPU4JwCeB2Hq66XRFZ0cLXjrZKV/+lgZ3DM+7akDGY2Xeio9KbhuQh?=
 =?us-ascii?Q?gAn+cZ6WW8O6JLAOjoTxtmr36IPgrpBM/zPW+0/4fwnuU4YQSYmZYxySl5HX?=
 =?us-ascii?Q?RnoGFBiqu+/mVGNft++XNcub2g+i3/UlCR5cQdJvlD8qGmHKHTt/5DwzWsa5?=
 =?us-ascii?Q?6OqJHK5w312TNvF0RMZXqRE8wF8fghsoZ2vBVEpUyiUXNNQhBNsRtB7Zgczj?=
 =?us-ascii?Q?/AoV5vs+cygPSJPb5BtvxD/FhUQWrZ+hHaI3dM53lvjtnjbZTOo9p86Hfqj+?=
 =?us-ascii?Q?kLK6ks09GAXV+IsxnX2fjDR9ah4yyW6PiElG/uMq+llkFojoeRrnyRva4J2p?=
 =?us-ascii?Q?xcOW9vC+YEmnUhIAs/Lcp077+MVb90MIDJPBzMNh+pw5qgJw6HoJxugo5V47?=
 =?us-ascii?Q?7joTvAuGpgDrJziCA1Y5qgUTsSm0r/R7QDTQorlX29zGw5aA4x8BcBsfVr03?=
 =?us-ascii?Q?qyCfVE1kTDlPuqo3OPVIbpUbzwD4nIQoAS4lVVt6Hr3Q0W98sLpw+lFYIXkV?=
 =?us-ascii?Q?npa9tjYGgipdOD2zulBNiZyvxt4xpOjJhJ0NpVUWzPlCQGgJFaLGe6XZTvUr?=
 =?us-ascii?Q?/gqwCHfEHFYH32WEcB3Ai413tREgKAl/p9KUNt6c1uR+lD4eysIN0PwdwRpE?=
 =?us-ascii?Q?7fiDn230qr9FoHmJfj1+EimZTwNFJuP5Xod2305EeoEKcWdxLK+Ht2IUkvhz?=
 =?us-ascii?Q?ZQCjV70dMQ8e8Ge39V3dnI0xdF1rSE0V89f41ABeNT3avwHV6fSXLk9/82U4?=
 =?us-ascii?Q?mawMLT7Pf18RZ/efa9/T9+DFR+b22zKrUAe1p/cjqwUVDYR5Y7hxZtxS6LwK?=
 =?us-ascii?Q?HbvD2dMjx9cPIDDFaYZ7wD+LoonpmKJIkL3GuD2cfiUcZB5PDwJHkmncMMbj?=
 =?us-ascii?Q?yoC6RJL4Y10zktg8OrO301PXB7SzuvoxKreJyk2RZr+WHg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BMFVDiYuuHyeSs7D6lhLmcov6R2qv31VA9fTMG1ffSt+uQwfOgXais9uHbVR?=
 =?us-ascii?Q?eiB8r3fFIvmbstR0+I6OVOrBTitbegvqz4iEwbFKLhYLM6pAW9fr1I4yTX0T?=
 =?us-ascii?Q?sewqRvDwzR5XTKbm1bhwqGm9JpBpCyuP2rIHevGeuKnHUnuKv/py4/cOipSP?=
 =?us-ascii?Q?uovZPoAkMM8PgxX79XYyNKps79t4QgGP9Hn+tSywDuq47MUIAUUvzlHwRzDH?=
 =?us-ascii?Q?rvHWdExm5X7j5vnLR5CtKfFAa1Ajlj8/orqghxGT+GEMjvksvRnu+0G/fPqN?=
 =?us-ascii?Q?5kTJoGT3yGG8G1GESnX4pFMfD3KnarZKzpw96Mswm3CX9xDAaFS3tQDAn4ol?=
 =?us-ascii?Q?50KI+9PGNy/dUzQ9kL1lzEz3uFrhl7ykK5R2A4d/KJhX7uwK1xrZu8WhUF0C?=
 =?us-ascii?Q?iiGo1M5nboYHEwtoOYUSsO1e4jhWCQQNvKu0BknJxONP6sCZrJWdy6LJ0y20?=
 =?us-ascii?Q?//+So2iW1/nhozzFxVMJcZO2i9FzziZME8toihlaztSavJrmFAXk/SsgS8k2?=
 =?us-ascii?Q?6PoIbMDZ4uUGrncmxRJM/l4lz53OYGxFXJ/8HPHesMkUfTdh7cInF2lc4CXA?=
 =?us-ascii?Q?zMwe903NZpcosRRWp9wKqkej2yRJmeZwLSBXpsDFGRq9ftz2rb6NAnWzWv2X?=
 =?us-ascii?Q?cWn/4SNdaYqVSBvmOHPal07FaErnho0x84EEaLYVwtlADpXx15zcfh3Fyb8N?=
 =?us-ascii?Q?65XFDPjJB46aC4kLIKKQOxUGj75QLkwBE4NvUVvfgn3O4uCIko5kEGC6OS+c?=
 =?us-ascii?Q?l91o3X4KmCRB1eTjJR6drobtW+tgfGvf1tDTsFHwOjmIXCy/cgdp/Kfx0gUy?=
 =?us-ascii?Q?KWyp0qvVAs3Z0IvZHAhdwOMcBWELQ5T2wsEhjHepvhiM29mJyQ/V5YK2L13G?=
 =?us-ascii?Q?hMFUMIXj7KYHUxGStzfwl+AQ2QoK+eK6QD7uqCG2XUcfy2+ZAjxnvTCSLsoe?=
 =?us-ascii?Q?7h9nIKobazV/rOZQ1ar846UOORcrXR9BZHMDBVPqJ/b8Tv9I5wWiDiT/ePwy?=
 =?us-ascii?Q?e1qxHZH2sAL74ecAoYpdDmdbYzcWJKheZ1JX8FyoPBirpYyocSgfOknajBBy?=
 =?us-ascii?Q?SZDFDa0Iffz/EwVgrd8It2omI9P/txiyHbU7imQwUc2s7w/bL7mn8mUtYHbc?=
 =?us-ascii?Q?oNcp+4W7Pt+r/AyuJGsOjZUGzTsJvepp4bnvj2tnPOpNCVjcJPxmkG3XLEvu?=
 =?us-ascii?Q?bEiPjm/TaH92pnZlwXtVFdkCHTbhrgkF5Bz+lPtE7IJctBVRz5hJxjfJZhGM?=
 =?us-ascii?Q?bNwBgzWiWJVvSkemVjJARq2Wnl2MiyOdPa8nJP2SEuVEAMmgxmlbD/FGqIs9?=
 =?us-ascii?Q?fMpnf1owGlVyMkIfdZa/x+YxQAdM8hUunkBKyX+xCi27ZHbqSwT5rhXiocLv?=
 =?us-ascii?Q?NlyZi8eYZy+fvqcAAdfmv63MvImoaVUin19Lq5i0bF3rJrluTMVn036hcmEW?=
 =?us-ascii?Q?NvRxAIz2ph5elPfCEXrUeBI8H2diHY2QuxM7mENDvZ/kujFc+eNTaskWUP3x?=
 =?us-ascii?Q?1hGvYWxnhKysSmDgoR5lhzyJFCHYtu9knWF8w2HZhDP9B0Yq9jLYSzK3v7sV?=
 =?us-ascii?Q?m3lnkneaI9TmNdioD+xHxlh1pR/6/0iYKpDtDYEZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799c8d7c-a68b-4dc3-3f68-08dccdbb961b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 15:01:14.2001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKbxZJb2AtqjqpB73sJmRumffDieyTYzAyJDlPJtQlK4r7rcc6y8i2ftDTBt/vLL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9120

On Thu, Aug 29, 2024 at 10:19:59AM -0300, Jason Gunthorpe wrote:
> This check was missed, before we can pass a struct iommu_domain to a
> driver callback we need to validate that the domain was created by that
> driver.
> 
> Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied to for-next, thanks

Jason
