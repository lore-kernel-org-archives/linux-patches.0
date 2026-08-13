Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013049.outbound.protection.outlook.com [40.93.196.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA5836EA80;
	Thu, 13 Aug 2026 18:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786644073; cv=fail; b=VkVeZQGruonwPSswkyDLk/+SpYuVk78jAT1T1pq1f8WPZa2P4h6eSVSpl6kUvd/v48pVOlNilbDdV0bNG/EJFGQaBr7nD/v2EprcR1bG9Tk95LYuCe/XNMZmoDjHbJ65Ff6Lc70jUM+T2Lkv3+mS4kc4xVpWIA7LkRVR5+vxnY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786644073; c=relaxed/simple;
	bh=HqIDfCWf7slyDNWcU8hN56AosDq5qurOw2W05VuFqHI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=sTaAKalE13DpFBCj/COnRhDX8KLBnASf1texYPCnXC1kfY8Wd2VoTrYfiwhki7vmqrZbtx2jggLB1f3qhmOA4uwleQhbgcNB6dovMamH9EXzCkARFubvwMDMb7c1+eD57WKuHlDt3m5MfD6M11OMdajgbvs0Wd6qJt1MzwkuCDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qXB/2HZG; arc=fail smtp.client-ip=40.93.196.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qXB/2HZG"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WeTDRdoWLztqDKA9Aaro56VTYkJZl6Ee3HN3LouRwc7vVXN731hJP3bay17KrnqFPPBkE8WJ4z0tD17cqHbMVOOgX/siNQGRY012kGlyPyXQBkMzjT3xxy0MKxOmou7C01akKiI49mehizdusoiQE0yaxFvmnOl6khZQOavjm8Ty7ZEQA8WYxTXfshZNqeQDKsBalT+hGX3PgMWnWR61UY8StE86FYLLkhB+7In4lf39hHsCp107uASeRxYfPT1cZD7qonZ0wsAwv5z0re3fgBZxf1dKGzHBdoW0Hmlqq//f8pVgv4o2Hll9JoYmMGR2sHaA0oDVRR7NQ5TowWaY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4NHk5YlAmFT35MU5zx5bO5nv8YHpI89eMcfOEslHoGk=;
 b=leBwkV+1Y4xsttNv7P74BdDp7Wrbj7phek+tIIju6p99HpvgEqTIY1L5GX+6AqQqvJkzV9VctsDJHzuC3V2SDrIl4Axy4t+J+3rzTfV6teLKi80KkLdUVzUI1prI1E8ZERhH/UDOuutBWPsjXpvZBby5ehLPutV3HtZkhqoyW2Mzjo3sFHWEyzFj/b4TECXCqnJd0zWbHqax0tGd8T0E6e4493VQOB7le4dofJ/7xtCjknsx0d9t+wm4DQP8vU4qaPnjoeOVE7n31GldrDaZjzUqRi/H+tcJoiLS9JtYMnFa+fb4sfQy2FHuKbXpaQxrHLYjq09yLcS3SQjAAP/rMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4NHk5YlAmFT35MU5zx5bO5nv8YHpI89eMcfOEslHoGk=;
 b=qXB/2HZGQHdYExwfCVxQnwp6Z835/rcCb0IfIwf4Y+ZeNs+KmoN9UORU+s8j0idFZr0iwnnWx+NdmrsG8fQhVkGr1KzsTk5mGjJDwFZ6ajBnhZQWD7uKBT9OBexO8ZmJUr7fgFctgThaBYbn8fJXt8c0++BlaFaCxdyARIOBnp+vMBxhzduvTN0YVityzzxBs/MTVZXyi0uzYumEXZSLU9lZl1fukp0j5VZ3f0ZML+lg5Dm9A3l27QyFIoUWcuwOJzzuBGpGgPR3EUC/rvxHSczkxuAwDp4aRyygo9Lv6A4ZUqZJSmZ4Cuw8Vq9q+jj/2Jbimqhp3mWzTVLj5PNVjQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BY5PR12MB4033.namprd12.prod.outlook.com (2603:10b6:a03:213::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.15; Thu, 13 Aug
 2026 18:01:04 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 18:01:03 +0000
Date: Thu, 13 Aug 2026 15:01:02 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Mostafa Saleh <smostafa@google.com>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260813180102.GH730363@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
 <20260708001058.GA422027@nvidia.com>
 <an3MSKEj7VhT4WkP@google.com>
 <20260813141320.GF730363@nvidia.com>
 <an3ew9xbnLe1dr5g@google.com>
 <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1791d7da-ecd9-4475-8f27-c8857477b442@arm.com>
X-ClientProxiedBy: MN0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:52f::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BY5PR12MB4033:EE_
X-MS-Office365-Filtering-Correlation-Id: ee27babd-247e-4303-500f-08def964d734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|18002099003|22082099003|11063799006|56012099006|3023799007|6133799003|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	eta9WtlV+GH3K30gzbQShObAyLOPnAE3qSVw32xRi0gTVRG4Vdxb+QaYYOqQKZECllzrhm788rKn5MmaS7GR9ytr261+mKBUpOmaxwqv//h5QUdhP1MbQEXpROT9Q4Sh+UOOmyvuIGKDQwtHlGC/eECc0EcOTSg8+nxlbueehlLsKRt1fX/bDK3YE6H50I3COIeQocL1gfEPzidVD0SphrdOX849XHasiQfVgOBJa4ojXtsjKO0q+sinVoFb0RDyrwAAS2LsPf+FNLHY3XnkH9mNHjotwDxay5lvkwM8QgbInuFQRmCDtVyXmPe3ZXUDL939CjYC8fXZEboL2OZa3t2MIpsemtrCij+W7eJ19VFK64zBn6LDqjh7pVyvFurdWHopUhHW4cgBM8tFP0qd6oqhYQ5C5KGHGc5/h3IteQ7bL2oQmeRjfEhrabiO82EdcT6mZ2tahTON39ad82Yu/41UfSNmeKwLbxIdaeMDX+dS/Goz4WjU99lvizWx4NaZDr9fPyvYBL2d+S0iulsx3IZY1HuIl5nPdnRPJQh/8ar6UvGRK+iF3p6soWP13b7KQzzx+7XFnTrgxfArsN8ZfCsf/N+r/lcBBtqAy3M9R7xhVKW0Usc/j2mAm2qjgUjjXSVKDSifqVhOXbuFslAFWsScDBB16E3cmLcadHSa6H0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(18002099003)(22082099003)(11063799006)(56012099006)(3023799007)(6133799003)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?peNtk6Z/tP7v9T7JysaL4lG3j0jAa5y3rN+DLkTUPUVCydcmXsOKzncZLfvz?=
 =?us-ascii?Q?1l1JEQvXVzwhgVp/3swJrx2A6jAr3Ijkdd2H/vhErbGR+ypLuPjbFqvKeFta?=
 =?us-ascii?Q?z9A8E8YHpQnpzEQ/vxTn8tgxX1KsBoWF67+MtPzjNl9Oywgoq/bn1rogDczG?=
 =?us-ascii?Q?qBTMQoaIKSdJ8rdrlceIgq8n4Re8qEeVFsyhrl3WcE4Gf6SmxVOnYRG+1ikq?=
 =?us-ascii?Q?9DV8x8C3nPuCs3x7vOSdP6XS6f9xyzQG2L00yDB7SOBh3e7plf93Pmmbw0Px?=
 =?us-ascii?Q?ky20dF6ry0dfuSyXVmOFt/h3NjJVCVjXN4qjnt7xi/1nIB1cZE3cuCAQVz9a?=
 =?us-ascii?Q?gSUsGEKW75E5eLIvwrrP9VaUc74x/ON4EwNVZU9C9kYFqTdFaAD/Zj70LeOl?=
 =?us-ascii?Q?9XwWgvnRXAPrMagIUAx2FY/zOGW3jjc3pgSiQ4QExaEs/RW/Is3W7ClNJmfQ?=
 =?us-ascii?Q?HOVUKdjh/txow4bQpgat43kbw0lqqDsfndrMM/IWOgJmTQbjEDag1Ak9zu8o?=
 =?us-ascii?Q?wEn1hAsPXWiP0/gZKSwh42j8JpvK6X9+qdQkLMusPv6ns65E/ugIFu3Su5zY?=
 =?us-ascii?Q?bxoXYf3VtGRhDYzs05Ksnm3sUd8jQEYkGsKg2cX+2c5tcSDFd+rrzoZreg6d?=
 =?us-ascii?Q?6aNxWmyGSUOgJZHD4C2ELhOlEDYOuXlLqciikq9zV5HvHYCrkw8H5c/TTVym?=
 =?us-ascii?Q?e1SulXWuQXEpxGQ3zy0vkvmiOwGVaX361gw7Zbhfze7elQ9ebbUG6XAPyIRD?=
 =?us-ascii?Q?WzBLpFsfFcYXWDyH5k5sBLRTQ3WyX7foiFampG9qVEJ/S4Eho5S3W/839pz+?=
 =?us-ascii?Q?NlH6QeOcfz2/0P72lmCmiJC7GR4+fGM7ZV8E4L5IpATZGxUOHzBRDBhO9gIz?=
 =?us-ascii?Q?TNDh3fQLgWMS1KawnVg19eNU3YMgJ5C8cNvJXF3lpdeaIlz8vbSyMFBdsdh9?=
 =?us-ascii?Q?HFrSkagbjoU/2QNFWcLJuEpfKJWlhdpO6RzJYFQtBTpZFOXBzYZWzOW/YyWN?=
 =?us-ascii?Q?zew16s28ga6gbBHKOo4tzx9G/4ZW+K0jJ0woHEPJpBzQ6q32YSkp1Y+C+Ate?=
 =?us-ascii?Q?LZdmaTNMtePuz33ZahMFwiphC2FH2BdFooqYECWzva4AgpFIb/BI37nRdPIM?=
 =?us-ascii?Q?bxpukZ41kh/IN83eME1qPq77HRSdCit5DeMYjqY7higvkFO2s1UdJ4sqXftb?=
 =?us-ascii?Q?hcSbp+Rv3PY9z4z8FIdMxzMMKU0qaBSAzFHnoR8KPVzKT/jU9BbZKI5YlFD1?=
 =?us-ascii?Q?jM4wRhyQStqsqXZ7NGUsxcGDozOVV9aNkRLVOkI+8atV4rwCyf4VJ+ZF4kdf?=
 =?us-ascii?Q?J46YCnMGjWE49os2ZVolRblWkA2D1l2yCnYWdCL5cDrfIfhf+OcSSEF2pfwf?=
 =?us-ascii?Q?GKXcy0JpGDvalQ93Bfnvd/jyHgo0mdHW4LrxwmFsE4abZ2KyW7yPpwBSPhpe?=
 =?us-ascii?Q?+IITiv9hafxnrfS6fNnsTJ+u8zVj+Cmfqmcpxrwv/HLnHxoYGhqa1jTPNGGW?=
 =?us-ascii?Q?WtvkIHRwtyU8B80OpOIP9oSTLsiiX2sTi805FUofLR4Sr290QggTEtAGBvuy?=
 =?us-ascii?Q?p9NKp8NYVpMgyxlwWNpjpqzDv8cF6fGRecdiCGkqql1W0fP+Z78gfWhOWTxc?=
 =?us-ascii?Q?r9ypm07Ydz8VlVx3xrQ+7mc1cKXiMKlkYpqzBjklEvsdrqP++AJICMb9tOHk?=
 =?us-ascii?Q?MbUKszRQ+bLavLyuXlz9nEph9cn1tjnWESau4NuqQ74Kp2R09FpRqmyVZIca?=
 =?us-ascii?Q?JnhE0HraZA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee27babd-247e-4303-500f-08def964d734
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 18:01:03.7286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJ5eUodiwiWhBT67XZBtSqeNyEMjZZcxKfMMk30XMuq/G4JBaw2/sev1471yVwtJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4033

On Thu, Aug 13, 2026 at 06:25:59PM +0100, Robin Murphy wrote:
> > > Yes, those exist, but again, they are already facing these problems if
> > > running without RIL.
> > 
> > Yes, but my point is that those typically support RIL and that change
> > regresses them.
> 
> Not even that - the main concern is over-invalidation of adjacent in-use
> buffers due to rounding up; non-RIL absolutely does not have that issue and
> never has.

It certainly does! SMMUv3 got an invalidate all path a while back
because doing single for >> MB's of IOVA effectively soft lockups the
system - especially with SVA.

We set the cut off at ~2M which matches when the CPU goes to
invalidate all. That's 512 commands max of single TBLIs before we just
dump the entire TLB. That's a huge over invalidation.

> Note that with RIL, even precise invalidation should only actually need at
> most two commands (excepting absurd off-the-scale sizes) - the trick is to
> consider that they can overlap.

Oh that's really interesting, I never thought about doing it like
that. It is way better than the algorithm that is there right now.

Let me try it, it seems like it would make everyone happy.

> Conversely though, if we really did have a demonstrable need to minimise the
> number of commands issued then we should probably also not bother with the
> TTL hint nor splitting leaf ranges from non-leaf, such that we can gather
> pretty much any unmap into a single command.

That is what I am doing. The series converting to iommupt also changes
to use iommupt style gathers which default to combining everything
into one gather.

One gather maps to one tlbi in this series and it turns into one
RIL. The hints/etc are used if the gather happens to be compatible,
otherwise the single RIL is still pushed un-hinted.

> This is probably something we'll end up wanting some kind of tunable
> behaviour for, given that SMMUv3 hardware is going to be spanning an
> increasingly wide range of use-cases with increasingly opposing requirements
> - it's certainly more than just "hypervisor or not". For now, though, I'm
> also not buying a dubious latency argument based on apparently no real-world
> data other than "I think"...

We have data already showing that large numbers of invalidation
commands cause soft lockups, and we had to fix SMMU for this.

This is tied into the SVA path remember, latency directly effects mm
application benchmarks and we have been consistently working toward
bounding and reducing SVA invalidation latency. We actually did some
studies recently and invalidation latency had a major impact on real
application metrics. We did not build HW vCMDQ support to reduce
invalidation latences in VMs for no reason. It is not "I think".

Thanks,
Jason
