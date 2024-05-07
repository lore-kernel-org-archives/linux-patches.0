Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2063.outbound.protection.outlook.com [40.107.93.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7306315E7F8;
	Tue,  7 May 2024 14:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715092420; cv=fail; b=X4P7CT/gE5M1yyXpYTKULUSj8vwAdpFihKfA5LugdTFEp+cdYsAcMinxENX22dq8v6K18/SktvcfjtfRdW9WosVvnLzOAdCiHatkVWQ4DkCxvt8dIxJq//yVaeQsdBMswKgqjNlvstT409ecp19AlimQfd69mbCY3TAUQyYpj0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715092420; c=relaxed/simple;
	bh=0v3eNYqO+1RK1t6rjRRu0Wqzod9JDV2LrrbK30GcT78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pMOg6tT9ANeb7Ne9UHR2/lAf7EEmPYV7QndTBpoc18Qnm8caBhslTZJRlJdNJ+3qlxmr5S38PmzHzkkFhYhkgrZkmleaq0m1DMq+9TsPD0NtaJcLODJuzn4a0FAi9JHp0VpZZDXjyuUgIOV8qOo1/KKydZKfqM+LaCBKzGfsyEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C9Q3XACz; arc=fail smtp.client-ip=40.107.93.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C9Q3XACz"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bcBZeouy+wMgF09R4/WCIHDltuXG3uuTCOnKdK34akejGlAAzdfI0esOuFd8VMj3v5mA46otDB2akkpfxXnlQn7nkHikLn7hW/9huz71xjsnrSnhQCRseTGv3dlvxNndjieLDc/cWTE7HXPA+STOaLh1BbHZWks0cYEDkoxJLX4+tRpB6PUgmDCMiwbSId0UDn2bojC3iXuSpJVsMDf5HT/LLyulGt3cjyJLFzNHiMPOxoI/oU+ydi5+vejrIXV/dqNZSPapak2DdQ/+RnFIepFzWe7WQhZTsR+2AHVfa3hk6KUEXA+gBH0jNCPYC5xleVTvONdKru8L3f2bKdtHhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=inIENLW21NbcggoRLuP8Wiz71Qp3HkbF/KKyxBBy15Y=;
 b=BekV/Lcrg/E5j6W9J28TC4NM5ynbdzaius0unZr5LoKjxGpd7L0ctOEm0qFPPu1oepDab5IfhXN3Co5TQhriRYi2PewvvOnKYO1Of7nYnPeMGdVq5PrpdaabWDYQdVcHMR141VBtlWIFA+hNJxHEMd0qgLa05XFtrK36xbuI9IjAwjkNshUBpvPLp3QNFlVYbK/LdSl4uMZFbTE+LFP1zDkidZoJYEKP2IaIgmIDl+ind7+P9bzbH/cLJ4nc40Gb1xhW/PO3O0UYNxk4ssD789IF+JtsnL8d7DtGKexLjJGvSNFg9B3v9ZKD1t3VhWeaNnhFmBJn6xXu+2OAUD84ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=inIENLW21NbcggoRLuP8Wiz71Qp3HkbF/KKyxBBy15Y=;
 b=C9Q3XACzlwkswAOecKSFINtp9knomhlUGMPWoQ4F/lD0qMB0JRFycSBgu8O2Eawg/nltcPSlPsqKKJM9Bgf5GcBQVaS6/yFZnAFtI0HffbPi4bcf2ekw7QoxTObVhdaVVkK07a1oHVO1JEZf/f8G0zidgpH0SmUF2tEUGLkBbKtRF8v5JfSOADkB+L43tdA3T+mfjgT/CfrLKZCyPecq4Gq8DiorW+zjRKKpB8kPmvaOxD/QokzoqWWAKcTiizXJ6UeBfNa4CntE/hYhVMrjea6VEEGCdwT5Ro/dgf54Jw3G/4/hDMPTKhmRGcEljq3yvQ2hg6NuKKrT1EMTS7B70A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MW4PR12MB6706.namprd12.prod.outlook.com (2603:10b6:303:1e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 14:33:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 14:33:23 +0000
Date: Tue, 7 May 2024 11:33:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240507143321.GP3341011@nvidia.com>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
 <20240507140946.GO3341011@nvidia.com>
 <20240507142248.GA22453@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507142248.GA22453@willie-the-truck>
X-ClientProxiedBy: SA1P222CA0151.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MW4PR12MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: 13bc1f57-6544-466b-0416-08dc6ea2a60a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RFhA8UCYcc5zlUangE0FzBu6IItWCbTLsn5ZBB2vbrmDVSpn43VSNdhxmPKx?=
 =?us-ascii?Q?VSTitzjVAe8FnFS21GGBdZ0lgC5uR1iUEeHlpAgViF0PGUqFVnFucqVYY8Fc?=
 =?us-ascii?Q?Kb5gQg2e3knE7gCZhaC5lNlLz4KFrQzu/z4UYL4kvwcRV9A9FfCoBDJwQkPb?=
 =?us-ascii?Q?MEUTHJkytLervtxGp5JXU/TphNHPxZ5snQ0eH2c2oS9GL/+BK6N7btnuXSCO?=
 =?us-ascii?Q?nFmVRibZv9TCQpC8gxaeZ2WjrWwIihIL50PjbbfjW8o3SLT+24cGZh1hmzRB?=
 =?us-ascii?Q?8TJV7xRMiTZK2P0W6a/i1PqenkYcodUEf5wkdN1GOfEwBOwI6dnCXV/f7kD0?=
 =?us-ascii?Q?wkh/NzCBpQPUWNpVLyl5JlCI1n2fDPEn3sYDB2g7fZCJrt5KXE9BlO91VXRQ?=
 =?us-ascii?Q?8lletTLd1gxkZnfw1b+1ZrGo9PS4Xyl6I/H04YsOP3GNN5AAayBNm2UPNG/y?=
 =?us-ascii?Q?eVWtTLIoNxKAe+F99FJW3WR+4cFieOFW/F284rwPwABda/pr1Ks82c8yq/hX?=
 =?us-ascii?Q?qu8fPwzxMW2IF/XHUaCnq4DuDWr4/tChFNEUZrcYKXX3w8V19xHiJQaTpoGT?=
 =?us-ascii?Q?+MrgVz1sF0Vy2H1alF70VPhiFbweWB7OUlITSoLN61csYr383g680CSR/hyy?=
 =?us-ascii?Q?A3v0P5KO/DlXaviV455IAXN64KvpynTnhtpSBLqTI2Sk8OalCeXVSFZlzTRo?=
 =?us-ascii?Q?GBr9hdgtyEYQ7+GHZRJTfnoaYSGirSdn3UZmfHLsgHAXbd/QfdwxqZUSe6ON?=
 =?us-ascii?Q?CFvcfCq5udCvvVOnbwUX3cEJA0qOSuPLfh2R85YPEBCfDACVquaf/rJnusFv?=
 =?us-ascii?Q?LmoWKFeAlDZz5yVC9ZAC0RICmx20R6zQsAhqdjZwK7tqfvHZQaWjREYXZVi5?=
 =?us-ascii?Q?a1jhr/i4s/QZEIdN1uO9NfxiZvuW/3fOF0cdvAdlamKLuxESXoow7JhX7UYt?=
 =?us-ascii?Q?EjG31czk2WKOdU+vXizaT7EORIwW53jkhCSpNcO4NXWhPGtLmFrjgHxY+XeL?=
 =?us-ascii?Q?cTPOCBl68UiFRPD1cKx3dfjwLWBnIfYxltSzTEOXN740ui+0cu2I353vRbR6?=
 =?us-ascii?Q?VM4bxhBPzBtAdxA5+XMP14owyUpo+3SukXk8oaRlSc4m/G1pfF0WqB2c1HPF?=
 =?us-ascii?Q?I4Oieb6DaqSK5Rq0OVfu+gV36uhotM2jJi8H9P6oKsoZxfkUwOGXSugmXRgl?=
 =?us-ascii?Q?9PkI0G7EZ0cQoe5P9XjEf8kRUFZZK/jVFJ+vxTT+KvHLRbAfQSFkjPGkEfiM?=
 =?us-ascii?Q?rA6Mp/uGsUw73uEnoVF1XD1/yJFV3WOxeVA5EvMNwg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UXNff6/YrLg7Yy1Qo702dgoxKVTHBupm80vy7JK6WbuMM4qXtrmOmtSF3I+g?=
 =?us-ascii?Q?AqVqp3h14WN1ubksEs8IHauXXnDj4b3/iUtNtW6HSxSc+pn5dQtA9WeXZenV?=
 =?us-ascii?Q?N8BMijDKQeT7cP3tBa6V3Jm8OJw0hReiyAeEM4HxSfZMwr2FuCmppAn5JjQB?=
 =?us-ascii?Q?9pZqkCE/1OGVnmCimLnmVXEASGZeKBCodjfU+jyWbTKmRIC1aq10RtIMw7xx?=
 =?us-ascii?Q?gD3DdeNXTE2lOiICc4fsy6bF0CIy0qGMdtIwJFruLcAFEzZkk92v0Wam4RLL?=
 =?us-ascii?Q?dt00V9nch1C1mltVUQN+ZlpcrcuSbYa3B5CFVlFdxFPcqx7+1wAXabfCHX4j?=
 =?us-ascii?Q?GHZsJ0nhv9c+JpIhjsuQfKnyufwB7Puvpb7nkGJ3RSrdmNbB9prza5+oyZc/?=
 =?us-ascii?Q?ub3dRuOHp/CIzXVUvRZ/NDMSS8pSA8PPHB+3qXrKMF7yd6RWdDTg0JYxXiT5?=
 =?us-ascii?Q?oWR1l8TmcPaH6WV1vTIeR5JIrXokmN/ElhdeZ59qb18B+2vuSZJwPNnhU3Ba?=
 =?us-ascii?Q?B46TCx1uByn7wvQa295t3jWgCaz/ykIJ7LGJZkL7Uq3adAlscz0bTE3NEo37?=
 =?us-ascii?Q?GoQnavTvQFKpiTwGtuUMgo8K4N36Vsts0l1Fu84ghq1WyNr62d1B4lkAF2s6?=
 =?us-ascii?Q?jRKmxr+KAEtJun4ozYCMuB5SykILqZlk9278SYbXQv8xKT2AlEZanlNwihUV?=
 =?us-ascii?Q?LECvuEGhWzPmtMXR2BYkM3mG03eCnja59ucgEri40JmAepe888+tpwWhhE2n?=
 =?us-ascii?Q?BbjxxrRtJLsWAIEoOHvYqEG8duz1vqanTCsV/fytqYraCkO1xoPfrjhxq5OA?=
 =?us-ascii?Q?pfHYyypwCKMGpEhi761Kjg/LcgkQ7w69Aoa61u+VhYcrSo1a8LHx0+ix3jX9?=
 =?us-ascii?Q?U/oJjjeK7L1QNxqfKeeurJSHWprlDMxKMziU60TCPgGJmpv1JbyRT1mOd7Hr?=
 =?us-ascii?Q?Rj8UCQqAXNXEInBvdgzcjnYRlHVPcG1TEg89hSh05kjCxUybI+hgU0dhyy4o?=
 =?us-ascii?Q?yvqvcvL2vqVtZ843g0Sjb/Em7WTH718hD3epW129HaQBxFHK1EABIATpb+zB?=
 =?us-ascii?Q?2ICG+r88jQg7dAfAux3qf/Nu2qVsH5tWnJkMrHcS+WArZxf0M0BeGjVuhihg?=
 =?us-ascii?Q?uqAzeJqPsWaiLx5ifJG3RB8SgkS4/tzeojhO5pHtTjYcu0Z4MIliz/Q1e5Vg?=
 =?us-ascii?Q?sho5q4AIZLdp+v9Qto/xrfmGMwMzrhwhkWETVG0K9sIo6nreq80CawCJwgZo?=
 =?us-ascii?Q?Pm27OAwf5WeK2TrHM0OY94LXUomAhjDvqGzETtKJ66wAJmw66FXulURp4bMk?=
 =?us-ascii?Q?J19mSt2HdiWrudBpmnXuP2xNY16hMEXb+NKp4d85vYGTaNgLqA8CjXWSSpaU?=
 =?us-ascii?Q?8JhEiWfNA+0cvmmZURc5jivjMWqKFF60L5UFgN2I8NaBczdVPuS3T843VJMq?=
 =?us-ascii?Q?jQnWEWQv7oM8CZINyBb9K9eqXB4nWs70c/O2u0r7jNW2X7hdXd38bVDiJsCo?=
 =?us-ascii?Q?YZtKSkJFTQAmf9cEFl2AEbvXA6tL+pTcmOidWY9ljgzW6R9aqZGs3AXz2wbE?=
 =?us-ascii?Q?U4V87hzuSbsjQIE4uj6ZrY7IIUMOwFsDBzci0tw/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13bc1f57-6544-466b-0416-08dc6ea2a60a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 14:33:23.0124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yUXyM8EPZtFGgA3nNJK1by1g/8oEGxzxIg4DAVboxl+b0cZ9HCXtXVmd0a/lfl1y
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6706

On Tue, May 07, 2024 at 03:22:48PM +0100, Will Deacon wrote:
> On Tue, May 07, 2024 at 11:09:46AM -0300, Jason Gunthorpe wrote:
> > On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> > > On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
> > > > It turns out kconfig has problems ensuring the SMMU module and the KUNIT
> > > > module are consistently y/m to allow linking. It will permit KUNIT to be a
> > > > module while SMMU is built in.
> > > > 
> > > > Also, Fedora apparently enables kunit on production kernels.
> > > > 
> > > > So, put the entire kunit in its own module using the
> > > > VISIBLE_IF_KUNIT/EXPORT_SYMBOL_IF_KUNIT machinery. This keeps it out of
> > > > vmlinus on Fedora and makes the kconfig work in the normal way. There is
> > > > no cost if kunit is disabled.
> > > > 
> > > > Fixes: 56e1a4cc2588 ("iommu/arm-smmu-v3: Add unit tests for arm_smmu_write_entry")
> > > > Reported-by: Thorsten Leemhuis <linux@leemhuis.info>
> > > > Link: https://lore.kernel.org/all/aeea8546-5bce-4c51-b506-5d2008e52fef@leemhuis.info
> > > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > > ---
> > > >  drivers/iommu/Kconfig                            | 2 +-
> > > >  drivers/iommu/arm/arm-smmu-v3/Makefile           | 3 ++-
> > > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 1 +
> > > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 3 +++
> > > >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 8 ++++++++
> > > >  5 files changed, 15 insertions(+), 2 deletions(-)
> > > > 
> > > > Joerg, can you pick this to solve the linux-next issue for Thorsten?
> > > > 
> > > > Thanks,
> > > > Jason
> > > > 
> > > > diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> > > > index 66325210c8c986..c04584be30893f 100644
> > > > --- a/drivers/iommu/Kconfig
> > > > +++ b/drivers/iommu/Kconfig
> > > > @@ -415,7 +415,7 @@ config ARM_SMMU_V3_SVA
> > > >  	  and PRI.
> > > >  
> > > >  config ARM_SMMU_V3_KUNIT_TEST
> > > > -	bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > > +	tristate "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
> > > >  	depends on KUNIT
> > > >  	depends on ARM_SMMU_V3_SVA
> > > >  	default KUNIT_ALL_TESTS
> > > 
> > > Would it work to leave this as 'bool' and have something like:
> > > 
> > > 	depends on KUNIT=y
> > 
> > Yes, there is a version like this (depends on KUNIT = ARM_SMMU_V3),
> > but it made kconfig act a little weird and hide the symbols.
> 
> Which symbols were hidden in which cases? Having ARM_SMMU_V3_KUNIT_TEST
> disappear from menuconfig when the dependency isn't satisifed sounds
> fine to me, but you make it sound like it was something else.

That isn't normal, it should show up as [ ] and be limited to M, not
be hidden completely.

> > > instead? That would be a lot simpler and avoids all the conditional
> > > symbol exports.
> > 
> > But then Fedora is linking this code into their production kernel
> > which doesn't seem right.
> 
> Well, only if they select CONFIG_ARM_SMMU_V3_KUNIT_TEST, right? There
> also seems to be precedence for that if I grep around:

Thorsten said they are selecting that..

> drivers/base/Kconfig:	depends on KUNIT=y
> drivers/fpga/tests/Kconfig:	depends on FPGA=y && FPGA_REGION=y && FPGA_BRIDGE=y && KUNIT=y && MODULES=n
> drivers/gpu/drm/xe/Kconfig:	depends on DRM && PCI && MMU && (m || (y && KUNIT=y))
> drivers/mmc/host/Kconfig:	depends on (MMC_SDHCI_OF_ASPEED=m || KUNIT=y)
> drivers/net/ethernet/microchip/vcap/Kconfig:	depends on KUNIT=y && VCAP=y && y
> drivers/thunderbolt/Kconfig:	depends on USB4 && KUNIT=y
> drivers/virt/nitro_enclaves/Kconfig:	depends on NITRO_ENCLAVES && KUNIT=y
> fs/Kconfig.binfmt:	depends on KUNIT=y && BINFMT_ELF=y
> lib/Kconfig.debug:	depends on KUNIT=y
> lib/Kconfig.debug:	depends on KUNIT=y
> lib/Kconfig.debug:	depends on RUST && KUNIT=y
> mm/damon/Kconfig:	depends on DAMON && KUNIT=y
> mm/damon/Kconfig:	depends on DAMON_VADDR && KUNIT=y
> mm/damon/Kconfig:	depends on DAMON_SYSFS && KUNIT=y
> mm/damon/Kconfig:	depends on DAMON_DBGFS && KUNIT=y
> net/mctp/Kconfig:        depends on MCTP=y && KUNIT=y
> security/landlock/Kconfig:	depends on KUNIT=y

These cases don't seem to involve a module, eg BINFMT_ELF can't be a
module.

I see the majority of kunit setups have it put the test into its own
module.

What's the issue here? This is the majority way to do kunit, I just
made a mistake not doing it fully when Mostafa brought it up.

Jason
