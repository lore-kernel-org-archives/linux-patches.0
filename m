Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0539B18D62D;
	Thu,  5 Sep 2024 19:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725564318; cv=fail; b=HvL/hVpQKArbt1osEXzxkIJlrnAJvLjGZ7+CNR02fgqc+XF8L8ng4IS2DiRoD+qWGIw82b2PRBuic4c1LmWjG248YZ8byNJkdVyMbF2es/Uu51ijfaocXJVobhWFT0IzrSn+bvTIR1ShUs3EWHT4KPBLRrsl8HUphhQ0iAX7+Jc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725564318; c=relaxed/simple;
	bh=DPPpgB2I9l0Z++6y0IiGo7jBU/0eP/IifeN6md8JMj4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lHgYR/o4vbDYjTfSD9aJc/Y80SS/xkl10tWPDUS622JPJRfBHkDdcekK8qkjKfTCefgUCp5pWNExjZxCB7DbRRsrYIU93l6q7tC2MoSjHZSy0XRQt5h9cC0gc1IZyIAKN4bjaKi46Va/GkdCsGGu7wYWGF48sX4gIvF3d4rKRQg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p7pgc4Dv; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p7pgc4Dv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vzqmgZMZR9fEdZj1FGeoGKZmlk0jdhqvE61sZDYW/mi97oSsktgGTWq3ZVc3XZOKJPjZAl7J1z5xoUC2JbOWppuM0kgao1PFE7LJ2M0T2z7/2gmLtfywJQ7h3v1VAC4/4E9M2b+wp2AMK4M9yN6C3tDs6X1g/l4LSG4GSL5jpx55Jz51vllwZIEr/bOfODCZvnxtbHZhPJsq87ocvT1rogSQ7pBwHm4UpvY5FweuQS2YiUoGfnQU6YUANLVtm9NoKbmsYXgousiwNv0AFyAe2UanKUd/SNJhNoJNkmC45W8+zhIUmfisdE/FWTnCJkias0uzpw9D9JApgK86Xx5vhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+JtCnkt+wYYRsZQCEqL4fhihCHgV2T5TFsNEn/jgre4=;
 b=RbxfgS9XntQ+hfnaYp7jM5W+/A1vKdAWh/GBt2OU+TUyVfRNlfS4asF3hONPuz6uX1uk4W80IGvyeXpTIQvx7GPWyS3NB//BeE+bzvBMpnPRxfJcMffOK1+htQ9txZupjOBA8Jd9TTD1UHBWxRcRosLpbPEi2XWSPZBZoLAd370pv/9W9kLMQwlWDl4H5h3cOMFtNF5X7zScTg5mKaLPYXpWGhkIqws4YqlDYUjvsvX3owcsbkGYzcPvqoKJL6IxmjHB/4r5rMFGqNV6lO5o2qR66KNorF4GGIBeAjVM0y3503Ziic50CYseyIkNaNH4lShkdGW8NHptWGzN7qEvBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JtCnkt+wYYRsZQCEqL4fhihCHgV2T5TFsNEn/jgre4=;
 b=p7pgc4Dvukm9fJtbDbJfyCcnSGgDbD5isPeC33IOSodONGk8Bk2eaW7OE/nDsPwGlJGcAUJ65OIUn+636u9e9Kt4fEnO8UiYYQdQ2X0jFlqQBFHnttVU3ahXA2EuHn1JUCPcBvkr268ua8tOceMc/Qn1tR3OYuJwYMh/DQUJXAe9ZsYyjdSGRqJebl0+eRyrRLnPDSo2zwOPk8oSovykSyDKeEumu+3aV48fs4jbhnoxneN+QuXDVqttIptUGuXnUVijro2bmmVf5UnEx86mKzJWYokRRpz+d9ZzYp2JPXq33OsCBLCpS/7A500ePz9XceHauJKzafRlvHLhTCR4Rw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB8537.namprd12.prod.outlook.com (2603:10b6:208:453::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Thu, 5 Sep
 2024 19:25:13 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 19:25:13 +0000
Date: Thu, 5 Sep 2024 16:25:12 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev, Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 0/9] Tidy some minor things in the stream table/cd
 table area
Message-ID: <20240905192512.GA3506290@nvidia.com>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:208:32e::19) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB8537:EE_
X-MS-Office365-Filtering-Correlation-Id: e6859728-4a4c-4eff-ba4d-08dccde076e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HLvu6Co/Y1gXJ/+nrUmhJnj9Ey7LmiBtBjjMfZtlqIzp5+Xh2WomOqaEYE5W?=
 =?us-ascii?Q?/sW7nTREVSbV3LB2C90qAdtlUd3JYMCNswMavFSK27V9MAjQh9zwQCjOh8r1?=
 =?us-ascii?Q?7r6bvaiA7gIfoVp3u+JEtHYMEEpNwo7Yv3n/Pl0XUvWxEs28oEKPag8g2L38?=
 =?us-ascii?Q?e87Qj8P6S2THwgv8tppzDDDQx6U0+OxNfZ8mFN5xWjLYQygRd8FKdDuu+G8B?=
 =?us-ascii?Q?ExoozPJ3HB5XDuMpbK4ctunHRNJ3gomsJtaKcpJMnQ1d5kFn/szHb4Qnqfu5?=
 =?us-ascii?Q?v+PSNmj3LHdGPOUKKDuoPPZb8AmMsUD3VOx298PdQjBcAwDrCUOG0bAhl6K9?=
 =?us-ascii?Q?YD/JMnyDLME5GD+W2Puz/+kuUN2iFIOnNoce0SLCwJhx3Kf7J0BeCyi/KAa8?=
 =?us-ascii?Q?ZJ1dJT7uSbX4f3MVHImxKL+gSpuX/3D0T/8HZLm0i28SFDqcfhhdmF36tK0l?=
 =?us-ascii?Q?a4X1hklkYpNynjEX22sgwOKLlvvRiSu6d+4YyNk9ddd9lz9b+8kPrHxndfYN?=
 =?us-ascii?Q?kTjo5SpFYsOlBj++EOlf1a+JTztq0ZLXsuclAEUHA+EPRFe8aYTAjrg+gvGB?=
 =?us-ascii?Q?sdQhBiyiGVqIALPV/G1tXXtHbLrcxVE+492D2KRmcL6l+4zZczDyfZmDDdsQ?=
 =?us-ascii?Q?5BkgVO3k2RmrDFL7tXjYhYtVi0mo3U5grFXhKAwp2bRp+rr8bfvnuXxpNoDZ?=
 =?us-ascii?Q?P+M7d8DGCLTtPPNamcQNIiTlDl68dP4dgAVsA9O3hPkXPGwTt3M7dKt7TZ20?=
 =?us-ascii?Q?zdtzILkSDrf9GRbuYCKn6r0dEDvkWCooJ3Pm5mojJUPwd/nedbTyuHI8R4o+?=
 =?us-ascii?Q?EuoMWxB90NILb4dk5dtM9JlSFtnSOp9wY/Y3M9kkgnvCOvdr0nC6PfGsbDkH?=
 =?us-ascii?Q?ej+eJZYSL0ogwZbm84ubM4OBCEJ4KTJaK8kOBOqixsXTo76pS9wpatFCrVfT?=
 =?us-ascii?Q?FXNHizwm9eRBP9S+51RduyUa/cGKkFlSU93pq2eBcXqSn3UiNQ3XeMky29Zq?=
 =?us-ascii?Q?j5MShYGc7Z93BrR7E650XNQjfDhtQ3iIvCWdOOD6L6pR0L0/sEKHqvOnLb0U?=
 =?us-ascii?Q?QWGXlg7zSLAwNZDVpcbP92wNz9PdsvBafLJgOaoIDWe2vjp7/fX6Eh9RxtBv?=
 =?us-ascii?Q?nsz+W7RaeI0R/pr32UWLs46iLjZbWUTZEp5h0ST40fVbWrmIhN+wsOrC5ScK?=
 =?us-ascii?Q?LatIpgvvYJp4YVKJ/t2Xjgf31I1SxeoLVAqmIC0Jm5i5Ywr5w6Ppo90saiyv?=
 =?us-ascii?Q?dIJo8aHJYh4OkWTWjMM0eXzj7f8Zjl4BroWwjkAoFuMgNYJrslmIYDzi7eGB?=
 =?us-ascii?Q?gG7FgNamA25ohbNtthJbWfHCVDdWetr28K2U9Xg4A1pzLw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cdhyqqU6OBXx2DR/4vzGhZnvJbv2ZX6bTQ2JMfDd1k2OUVujJYUgmBZ/RpLp?=
 =?us-ascii?Q?XORPKpxwuDXIjoIieV4gAAvO7leV4SXtDU6s1HqdOULabHH/VQih/6x88kAl?=
 =?us-ascii?Q?TZ7TSNd9Yc2nMbTaDIfW2PtyvAw7xJrIbByF1WPa+g42NhhbIbube1DWUADY?=
 =?us-ascii?Q?bBxbsxFIv1YSGPx/RXSW4moOb/FvC/PzFucb9cQ4OgZCRn1pTEn0uXeuHpOI?=
 =?us-ascii?Q?rY5oVYEbtX2vcuMXPN92uv7XArDyeSW8qq4vnVnPD3McUdueuKrfhOY23N1H?=
 =?us-ascii?Q?vOVIg9H43PKYbJ6fzJSgsCQU5LQENWjUrJYYmIklSzRx8BNegMGU46DBCQ3W?=
 =?us-ascii?Q?ZwSmUQKESMMDUuMEVdYnxWysMkHxG7SvGgXixqWbK/lpnKXq17Mzz5BGnPks?=
 =?us-ascii?Q?fsLFqKJO2UJkjjGb7FuArZ7Lvia8cYWwmivk0soQsZzCZYr9q9hlS6VjcCVF?=
 =?us-ascii?Q?LGNQejpUu1HgI9pADUTxhyD8uVuTOZO+McYtkDssEFR4ey6pxIU6kD/Hz85z?=
 =?us-ascii?Q?rb+uz/I33XJccSn6vse2erGyQiGBffzcFGVthR+i0SAKOEzZAK3kLnFQQlPx?=
 =?us-ascii?Q?B+0qkombro89UhNLOSyY5xOW25UougaFqNautUMQ+/YeakYwqu62a2XQVJIB?=
 =?us-ascii?Q?LpjOZL5N3FK2HEOdaBZD8AI79lK85qaYMYkOwOApfgMtlBMEsGXuJFPy16xU?=
 =?us-ascii?Q?tv+WyEjFi1p2TDgdP+AWcXEGvclSvj1V4+EKNZYcmCily+Ii+BonwmaPV9lS?=
 =?us-ascii?Q?Ejwyc9+rroPH4oQ0Q3Bj+YWR12qXlhWdFmC3WFCiZvc3s7NWr5OmGv5SRkEr?=
 =?us-ascii?Q?WmtII78JtTlL/k3WMqoLnPiADsrJQ64fNKSbdXzQqd0EE94/qQNYWYJVXB22?=
 =?us-ascii?Q?m86tIC6Cv9mBp/6m5EcC18LHbkza0jb3HjKUeUPl90OYak23jiGFKCUCMcUr?=
 =?us-ascii?Q?Ey13nTQr+lqwSQ1uNRxVYrdCKerwafQC1BQ/UKEUG4o7IQD5IG5Ktk4m3GES?=
 =?us-ascii?Q?EJdeVczbc7WlZ7hs9u47eqQC+92apZq2FWbEuh1LvPXKW6EVGeG6r+wCauUY?=
 =?us-ascii?Q?8A8fgpAbg2lS7qhIB7faSut8uQ1/OQc/xmLU2nWJOAEPBl55SAleLXNNJxo5?=
 =?us-ascii?Q?3CeWV0yKKwkvqhhnQ4WgbrKcJZ4aQYuIeGC251R38PCoQimh5ZC3OI0CLXui?=
 =?us-ascii?Q?U8C8ZMPc/pQPfE81j7diFK9NdSxGwLbYmxRzyqlsrpBUM8wEgUduw6PgTAYY?=
 =?us-ascii?Q?t1Nls6VrKmPCKDgNdM1WIGN/Jcx1X9e2B5jbohb/4VXTSHwS8i4dB+tdrF0s?=
 =?us-ascii?Q?QKrFw2KJL0K/9lHbATgk43ovZct2TYwiQbemCdzW3Q9ALQkzXNR2Vlu14WC+?=
 =?us-ascii?Q?GB/BGtZ4Yt++P62jns78ADEIYURMOXPjYpE5XzCj15gKe6xzeHGPlZlKjmlK?=
 =?us-ascii?Q?2BbFDW+UdaIgo9pRqZJesKBGT64PjCXpR2TTiumdC69aB5mUdQTPR9Xv6IA8?=
 =?us-ascii?Q?Evr0mMSx5gnpwfHcBxh072gTvn3UhoNOIULBlW/R2KKsr963LpZrndL1Z8ON?=
 =?us-ascii?Q?bhGoImRPHz+/Qa7waZ1UkIhd8axxZdN7La89yd4Y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6859728-4a4c-4eff-ba4d-08dccde076e6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 19:25:13.2093
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vbiua2IMLfQAyLSQdcxF8QKZAmvD+x1MyF+Swzet/R38/C0+FFt978XVkDWCuFiW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8537

On Tue, Aug 06, 2024 at 08:31:14PM -0300, Jason Gunthorpe wrote:

> Jason Gunthorpe (9):
>   iommu/arm-smmu-v3: Use the new rb tree helpers
>   iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
>   iommu/arm-smmu-v3: Add types for each level of the 2 level stream
>     table
>   iommu/arm-smmu-v3: Reorganize struct arm_smmu_strtab_cfg
>   iommu/arm-smmu-v3: Remove strtab_base/cfg
>   iommu/arm-smmu-v3: Do not use devm for the cd table allocations
>   iommu/arm-smmu-v3: Shrink the cdtab l1_desc array
>   iommu/arm-smmu-v3: Add types for each level of the CD table
>   iommu/arm-smmu-v3: Reorganize struct arm_smmu_ctx_desc_cfg

Will? Is there something you are waiting on here?

Thanks,
Jason
