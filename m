Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2073.outbound.protection.outlook.com [40.107.220.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12E6C1EABDA;
	Mon, 21 Oct 2024 12:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729513051; cv=fail; b=aZaNnCfcGRnPooP8bQgexvST839vNMumY1yj0e9SKDOLRFi+4BfjEgVqg5Dhi727IZ7wF4+V8gDO+i56/mxwoegygJJplm1GdDOgcGUplOx/zryPoyiNLnZRCdD9YCd5n0Nt3tigj/BtUNIRqROo5/6UedKgovxYlL46kBv+MY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729513051; c=relaxed/simple;
	bh=zbhpEECt5EsZ5oFA1iSj4CK+ubURrXP548wXZyIQ1s4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oQ/W9SoC1OnLAzHYSEqR6XIHPSW3KzhaP7Ui/pOpAbTVjBO8MAGbldhlj8IYmoXMKMhNNq8OJZoRt+r0rRHmLdyCRJr+oz85qqwNO5UDMfLOlKOmWCBwFo2JwDEgIpG/Yrw9pJqbNudj1xOVBu4fnOxkNfwjmds3xczLwRanokA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NDfLUEJo; arc=fail smtp.client-ip=40.107.220.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NDfLUEJo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a9t3CUFx+JLktCu8H5g3UGmR9rKhe04XO60ZWnhyl/Ba9v+cMLhWJ9aZy8Fbq0ilil3c4N7BxiWAEkdmBrjvzuz2btHsCfxOM3DRrncRGACrS2nJ8gbOMhkL0okuiiuBUe/oeDY25PkUW2VvapxOb68Do3x7Hft3DR0zFixxAK6+x7dUShyhk3dRX4UT9re7SlTZvud0tiGNPJIVil8O4p3KnOBqH7onhCTVnZ8bUupgaubeVdewin6OdckXCW1rCtADpXF4vi6buetX6LxqeuMtxF7KmIl/uxfGUdRYLsAu07Mry6STMvp9qZy3h2rFaC9X6bp6EHzTEmU9Fj5VeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgDjrZM/0jKFdYV2GLg4A488VS0A5Qs5jfxjMko7z9Q=;
 b=P7RlsNX4nsq4/mhyI8+oMMJrdeDM3Um73v0ccFyGjXcO49bZw6UmI1oTPBn1RZEC4BehVCuMp/f7SoRAeC6OOwM76NMLun3l6EO1dSpsKAMprlQDfguXL2e1DcOfc4MUA37PsoAPkcRDyrP6SZzAHae5GMVLUnuFOEyBzDw9jb+7K7u5L8jghblKOQC44fILaq12g7JrwZc9p9pIGBqGP4ti1bZtk+992B3cZl+R2DQn2N1xXW7FAXccxTADYHvlg8uN6zDfRMVX0sgPNN/UVsrLVvWxxgpkiBZujoE/ZteibnDL8OYfA9YltOT9FPGK+TTfrw90dmN7pO+M0MgNIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgDjrZM/0jKFdYV2GLg4A488VS0A5Qs5jfxjMko7z9Q=;
 b=NDfLUEJoc9uBDNrKD+Yy2866w7GDDIfk5o/VxARVU6XapwGQ/l1njyhwussOZOfHoyrnMPeYcuQfC5eAZaIuXY8St8bbnM45yU15mD5dgm5ZP3QfxTh7iQePypzITzVuCnNWe1S8QYGolRFRi3mj3tM7yOdZ9+tYT32Hh++2rkc11wdkYmuzXaO3GFIu+rhoDhv539e/kiqrpiKgKl2CphpoIlRZaCpQvZjxir6QScZisf0jsS1pBzP/bfmzbllvtVyUwtJvrQfPidbL/YkURs9OYVqD2gjW571l+lSmfONPr3lucsO02E+9TeTO8WHjrXU67Ds+ove/aT4Hdrsn3g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by BL3PR12MB6451.namprd12.prod.outlook.com (2603:10b6:208:3ba::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 12:17:26 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.027; Mon, 21 Oct 2024
 12:17:26 +0000
Date: Mon, 21 Oct 2024 09:17:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Steven Price <steven.price@arm.com>
Cc: Boris Brezillon <boris.brezillon@collabora.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommu/io-pgtable-arm: Remove split on unmap behavior
Message-ID: <20241021121724.GN3559746@nvidia.com>
References: <0-v1-8c5f369ec2e5+75-arm_no_split_jgg@nvidia.com>
 <20241021111758.561c81ca@collabora.com>
 <850c70ff-a7f0-4a0b-83a4-0b03a039831d@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <850c70ff-a7f0-4a0b-83a4-0b03a039831d@arm.com>
X-ClientProxiedBy: BL1PR13CA0304.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::9) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|BL3PR12MB6451:EE_
X-MS-Office365-Filtering-Correlation-Id: 40b1e5ad-75ac-4c2b-4ad8-08dcf1ca52f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mZpcVmcBpJq7T4Oy/4GGOx7pEhI61JrFrA9m6TkHvFFzVXdBTd76L3d9KCRY?=
 =?us-ascii?Q?pJKDBSbVnudME7xe76awq6WcUq7nt7MhHvkvWfjI3jPKYN/c0q64+DYT8LNj?=
 =?us-ascii?Q?TswIqDJABPvtqFCDm21s/5Lgge2wur9EfMRB1hncgftd7xtSXCJvQrsr0X+s?=
 =?us-ascii?Q?J1FGuRosL1diOalMhGtWPNAv2sM8gtJENK5PAMvUdgHB5AcoY/aEZL2I/hvp?=
 =?us-ascii?Q?nya2BsWDQMLjeZ+xsn7hBytA0iEPUSMeANhe0EEcwa8+I+T0kBM9JHX4VtVh?=
 =?us-ascii?Q?htMGvo8Oq5dRVv+42cbBQrbPaVOZXnHpReQPS2xq+amK8AlAhrmotuDKc90Z?=
 =?us-ascii?Q?S4Xb+1oH9dVEppowsslzwIMFOObeAkMS+TcgBRYT3XCgiBSWMyO+TSwKLzBK?=
 =?us-ascii?Q?PEVuQjpLLeMDtYxNguyJEf6GB5VLJXKmL+3T1uI1QjwSLCoLoREsxnZLI241?=
 =?us-ascii?Q?Zjd0T51GrmRKnYtOWwrNjspX2EgNAynKPrbe80BvVAV/YnhB2yJ0LSg72tBL?=
 =?us-ascii?Q?pzV3tahS5q85NE6LwGoBcfNNcaMcaSsfj0zhbG5X7AbN5iBvo6b18i5j5fTY?=
 =?us-ascii?Q?m2wb4Q7qtEatvQHvZmhzyQW5o9VySqEueks+tn6JHlQehi7fkMupTX+vs1Jo?=
 =?us-ascii?Q?ghyBa4feJndypYKjf8pqxT6giVDPkgAADo34L/a8Jhl6tOJlMR2hLUyuOGbk?=
 =?us-ascii?Q?sna6NwaxafRTzKnheGozQh8T12+dkC58PUYkuV2R1Do8IydyPfgUEHJMpC1b?=
 =?us-ascii?Q?x9hJrDLaHqZq7C6XeDw2pKtp9ElpaBlE10m5ThJjz70h/ohquhtJO56V8SnB?=
 =?us-ascii?Q?457NJ9gq1Jvaxu9UTK/SwdV0phyemwL7R1lY1OWQbumjahJdO3puA0LaatZf?=
 =?us-ascii?Q?jh5tfLA6Onraez+Y0lCcE5/E0LAC5kZcHVgvWEqOb4+EYwKidOnYxfINz5Fp?=
 =?us-ascii?Q?IYzL+ksYY6jGkhFEONGSPhN1D530QkqA+Em3j/G/8c7GrFCNX7ISDQ4NZ2SJ?=
 =?us-ascii?Q?oDk7geOdH/KZvBdKTGiZMX3WUIsN7Nx9tKapfmqKKUm6Wp4J3JSFoEKz1iEm?=
 =?us-ascii?Q?EddM6HDz1A0rHzNScaqvGdmPs0I82G4+swACZwFlHSrHH+hdKaebIQJnbPZK?=
 =?us-ascii?Q?E1ICUUjhHQrLPhu4KU2QPanZYYi5NvmR0prUOAdaX3Y0j7Um6IOS87uJm4Ny?=
 =?us-ascii?Q?u2xgG/j2CQSJ1xzfKNJzEaw9CGDAZTKLBKYgDj0246GwAb0hcXbf54/XUVtY?=
 =?us-ascii?Q?jg2l919QxEOPWyWrWS8vTbaHTUlEe6JJ/vzT2FvWwgWQii+C+KagU+am2QsY?=
 =?us-ascii?Q?j2fL/kRDMFxFvnWsJt8aTryM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Wn9GsOikOs+lFdAmO2or85phdducU/EZj3m91keuq/pJ6hK2hxBvJaghk/3?=
 =?us-ascii?Q?WNfu/gMezJjCAewtQulaK59Lj6sZDKZB89suiaFvryACRbXBIm/CjzdUupxI?=
 =?us-ascii?Q?3Ln9bxTQRQcW9SqjNSZl76jWDCuIt1cNWjuPSS3wySvik7Acw8acnZDs2nkk?=
 =?us-ascii?Q?l2HIE47xtF/2X5QguysxSWGG3HHTU8FWmX8mTI57J4dV0Mik7/u65Jq06qMg?=
 =?us-ascii?Q?2eblX4bioUPuLkIkHrKE3QJz/vZWl3dRkiCItVO11oxpZcbvfyMawYL9dDzj?=
 =?us-ascii?Q?Ek1+/INnRlUqSFc6GsbSefzqC1GCDSP7/qlg7b0TlXc1zkBYMFndibmzAeRt?=
 =?us-ascii?Q?NyjqZ/dPvzWMhlbG8cVvYnsisQmPm2Au++3HQilGATkVM1LFvUaDss3xw4d/?=
 =?us-ascii?Q?baH83XMzRBmmfVdT1WpV1QZ8Zu1M0veJ3vxcSyqPpNC2LHWBF5iC1xHv+iuR?=
 =?us-ascii?Q?QS8VDA5KGSHwdERN8QUBS6MZgmTn7vyiU471Cc9AS9v7txQl6KtEVlV93gZZ?=
 =?us-ascii?Q?CURb5JgZlgrhP2uDWHCY+r7xzKk04vKILclnEerwPkK2ziQ0DeeNr+oy8aIU?=
 =?us-ascii?Q?qlX4wRDnlf2vxpU/NKD0BI7Nwmh1+P4/sDuNDSnJjRjCxjz5N4FP2rhlRVSg?=
 =?us-ascii?Q?Zo2L4hAw0HO1jwi1ASPklvWurtgQi5uNpYFw4mutTs+qqb4qjLvebYGGAENr?=
 =?us-ascii?Q?Brfgqu43ZHx0yWKURoD2OCQcx5hOrx0X81J6+MhuMqvs1UswsuCQRPhHmetm?=
 =?us-ascii?Q?N+cLof1onsnIXXWMC4gWfseWYhyqP5HDE/qNafTPfN3xkXp4tfv3mvblNfX/?=
 =?us-ascii?Q?4GN6oYxQqiMMfX1c37+LMMdTTaW07RUk6pqy80ZHtq1dfRjYx0lZHRMrkRvj?=
 =?us-ascii?Q?NqdnO0cJ7Jujx/MM5ynvLr17G4d7JHBE6iqxaokIn2nOXEmnGQXvJMyattPZ?=
 =?us-ascii?Q?AZPIdsJnou8vB4hxrTIHuafkQKjKtR4/qQXv5c/Elb2FXfIa12KLzHTK4eQ9?=
 =?us-ascii?Q?HoFNpL/i4hqexxr/K6oU5UZ9vw5vCxwrYlowcLu25wJ/TxWD9uJjhVwJACLc?=
 =?us-ascii?Q?YoRt3kaSpnqy9qgoLZbgnpwCughB2jcUdC7ez4uGnRyerll38VlFZSv3XOpR?=
 =?us-ascii?Q?D+yfYfgMZhfj98a9pg+fMW9S0r6mIf9QTxzKpf9/Ypsv6V/Db3EgBQ2RruXi?=
 =?us-ascii?Q?NkL/ueD57LSOvJl0wj7n88Z6dcR/Ht5TYd4ckuLHvnNfWCvLezaOAtDLhQ0c?=
 =?us-ascii?Q?UQXC+0KqChBHJsHZ/3u996QMSpWySqm/emapcLnmwa3RJbbmBmA+nDzFUkVn?=
 =?us-ascii?Q?4GWLxso1YEDSt+bLyQCZf0vPk8blObqG9/d8BJymRi/tpfSjDrh5EX5VCZXc?=
 =?us-ascii?Q?Sy7pmFyOJQRsY1mKr9/+Z6ogoUzIE7F9txY9PInfXg8U7Vj2GWclpLxH6OnI?=
 =?us-ascii?Q?Rp+lO5xf+c7bj23MfsaZUzcqv/6k9jUF+abPEpkWWCEK5PylIw2OhVT2l7Cd?=
 =?us-ascii?Q?Dl5kbG/eGyDCKeprL2zBHEqe/psTeLwB0TWmyFAkLjnsT9XfHXKZ8VSxK82s?=
 =?us-ascii?Q?YfXjfpRHub4hNpN/sXs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40b1e5ad-75ac-4c2b-4ad8-08dcf1ca52f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 12:17:25.8885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ukUpGtayseDhD53ujJEvaCzM23DzV7RtMGMHWteakYD732YQ9DvBBywRKAqVnUD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6451

On Mon, Oct 21, 2024 at 12:32:21PM +0100, Steven Price wrote:

> > that, we can always do it in two steps (unmap the 2M region and remap
> > the borders). At some point it'd be good to have some kind of atomic
> > page table updates, so we don't have this short period of time during
> > which nothing is mapped (between the unmap and the remap), but that's a
> > different story.
> 
> The GPU hardware provides that. The only possible missing piece is that
> the driver needs to know ahead of time that the unmap would unmap the 2M
> region so it can do the correct lock before the entries are removed.

It looks like we need atomic update for some confidential compute
scenarios, so I am working toward that with the coming generic pt
stuff.

> >> If DRM does use this, I'd respin this to make it into a quirk and iommu won't
> >> set it.
> 
> You should be safe as far as Panfrost and Panthor are concerned.

Great, thanks!

Jason
