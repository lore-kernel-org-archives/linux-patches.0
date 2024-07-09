Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2068.outbound.protection.outlook.com [40.107.102.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68E31B86ED;
	Tue,  9 Jul 2024 19:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720554138; cv=fail; b=TXhh7rpr7oOqEOETskw3U3Pm/bpD05uIa/AT3zKlllKynKlzpdX7B/wa8DjRp2yEOt2af+eC0JIGuTJbb1XS61UcQfOwgo1ocMYYENGXSt7HwQrBvm8I9ARuDLYXik7j3IJhHVqu4WUUf22btIc+FrygOc2jmqR3p/BGXNLioUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720554138; c=relaxed/simple;
	bh=wMN4Rp2cHUb5Pp7ElDUtW5BMfZJJ2K9+x4s0L1tb0MY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jRdnL4MHynnIqEcIOGcXF30qGnUoWV8PTuNxqRsYe0dwW5IQI1c5IdxKs0iWiQR32RW69ufcaOYb1tCg+Th3PBfb7UB/Wq5cwWwaOW1a45CtoPQbGnX513wbGinm75j0XkDexhK3SWFrT1iqiCyNKPSZaSo1jmcDchsZcU0wuvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=UBdM2z3a; arc=fail smtp.client-ip=40.107.102.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="UBdM2z3a"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Th2O7l4HDzbFn8Nf0P9SEdWecMwWysVn6Hetpiy/LiWqS5Vl0bTY2doVN5XAEPvZduYrnIP0RB9Vyl1u0YiPkeXt1dSGTO1qofoUrL1eW4A7/5eAm4L70KVjz9zIxB9hnKUJE49RmfGVwdlFznqR8E2PM4Gy1wXXZGU9JpzFZyJ9K9CPt0FsIajNKaAOBHoUKDH+wT+PbcqksBSUMAelt5wItNM0RWIFDLqToBXwli6Ec0XWyhoBRI+cW1NZx595jtH97N0INy5grr2PQwIYvOoMr3UL+5IKdqjUBjsLHhj2czSprvZ52wHxk7HTlihpem00gPuFjMZlzQoiKxqdmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s/pytN89AWWhXNCE0U5mWTXfA9gVrY9aDKHOAoKa/rA=;
 b=iipRJ7z02dHtpcKmOrX3FxKiq2fVtwidY1GBsPfVbQl4nORpZw5sRQcl0L2Qf9+y+BjB6AteToyyWb3ctazD7Y1vE5t5BpEMPEPqn8Kh4KMPSBHe79yaXMYePtv8H++VgI7EjBWbc4ehE/CBctK2f8k/FRzxnaZ+5ixF1lnaz2g5BGT6jkBCHB/a8V/Pupzj3RXN0eQ3bQv3/8WzezTqt+sAtt5+b9+2mTrZDEOsJ5aKJUD8OfW74WOEp5WuFZ/KU55sFHjtVmnUmojXYvFBv4st9bB0RYZ1uWsZLHhkD/1dRov02q6FtL85lzZDI7z0qzkPfnWjbkU/wRo6Ktd8LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s/pytN89AWWhXNCE0U5mWTXfA9gVrY9aDKHOAoKa/rA=;
 b=UBdM2z3ag1LtX+cSkbNfLAGbxjdZn6CdXrJMifbFicAYjWzRCYs7ITLCB3jHL0H0s3lscco8PPZi2w/oRh0BreAZkBL3hk9oCl76GKlCfbB0EfLgEub3KjNhVOQwj5MWNLZu84VJ1+3G/f0ceE6vPDIrW4OVO9zOWQauVOJoaN9rtUNsD3tKX1dLQuQVE1/wShdH9STEvdi1Zsgkt2J2UB74KL4FLRIDEpLw2w0ELANRZFrMwgT5bjfizUaf/hnWpMLBulA2Afi/OlLZ0e55ufF8CGNiWYyPd9LTYo17bEZQumh7Ccy32JUzfC/lofUQCgANczrzTWdEilEsAzjHsw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB6280.namprd12.prod.outlook.com (2603:10b6:8:a2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 19:42:12 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 19:42:12 +0000
Date: Tue, 9 Jul 2024 16:42:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 05/10] iommu/arm-smmu-v3: Reorganize struct
 arm_smmu_strtab_cfg
Message-ID: <20240709194210.GM107163@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <5-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <20240702184616.GC5167@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702184616.GC5167@willie-the-truck>
X-ClientProxiedBy: BLAPR03CA0108.namprd03.prod.outlook.com
 (2603:10b6:208:32a::23) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB6280:EE_
X-MS-Office365-Filtering-Correlation-Id: c2151e65-2638-4b7b-4b03-08dca04f3a43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tVZuKoa21VNwWJNwgy2TPgXUi68dfr0cTIAWxXN04OBGhXAmKxQzfqCGodzq?=
 =?us-ascii?Q?bHkfh60SFM4AediOvySV/NvFvfPBMA+h67pkgxtZ+qWNrdrPTI7Tc7mS8ojq?=
 =?us-ascii?Q?CtrjuuPNFb6kn10QF+q2t+27MEZB06Gu8MN6OAi7zqowq/cdE7Ege/iZrmtp?=
 =?us-ascii?Q?0lUQ9dws00VBP/8B+d5crBRmP2gCLb52abV6W2B0LIvO3KkmtiC24x6VIBPC?=
 =?us-ascii?Q?fz4Y9RPVAtio6RpCYoRqCcVoMViijUVKo4TqqXemyWWMA2l7HqEr0ZZX/RV1?=
 =?us-ascii?Q?BiYNEGqIOUGuBKqdKWN7pqxh1+Lb34PTxB0wQSC7Uu7ULJO2ohD3CmAqyplj?=
 =?us-ascii?Q?rJtfbuNQtGwlY9gW1NZGwPPXjEWDt3Z1Jq2YA+Je3O+kjFgGEqCK6dD30cbP?=
 =?us-ascii?Q?TKEI/9IvCVvsJqjfpMA43vGNfhC3NrfHi3XE+RYE8qoJEnAc7AC/61hz6Vlp?=
 =?us-ascii?Q?FLzQR/B9ritY/0dv9EvkkaKCbCOlTKjLLceg5likWZ/wWjO7ngF9PKGx8YS6?=
 =?us-ascii?Q?Ztoy7A2jtwYWu8tghI8O22KNgdts76V9WKB9fJH3363MHGOwF+2sDgPHrIwD?=
 =?us-ascii?Q?XS2LQqd8GFg8ERHW+U85ApCeXcftXSjyJFl5RuBeck5DEI3/hnlWdGgmHuB6?=
 =?us-ascii?Q?NK9awvnaQ8N7xZD2uv7cODDMF47sijnKoTvUJQdxXG+tRCWN1RmwjRVBMdmA?=
 =?us-ascii?Q?a1SEYxgcQTaoZNqWeq1i914zcf3WqeclBFQRIuGde2CuboMpNJVtWcf/z0wb?=
 =?us-ascii?Q?AiepyNa4+q9iZjyM//j9Ov7z8AclvuQByzf8U/UHnUrmoJbCETB56eVZ2By1?=
 =?us-ascii?Q?nGk1IehfCytMTxEVJc6kl+v//bVjtZam/OCPk+1udMeFTJIRmvcw8paSYTTw?=
 =?us-ascii?Q?elUDMqevyC3NyuPe9sMdrspZ1c6A2iy1xcT/sbNPG06Rq5LrgYY3gf5c5KkF?=
 =?us-ascii?Q?kr0jaTu6L4BQTS1ruAnz/OyELeUDGy7qs/FCnB5FPo5cxGVqX63ukx6+pxXG?=
 =?us-ascii?Q?qIGhf5Ev4/drzfZtnJKSytn1QE7Udvt2ikkc9uALRwZwsjkuSyk06JZLYl3O?=
 =?us-ascii?Q?ZbGaVrOX4z2gcHAr4FUOT1mA20VDbQa8Vg4P4Dmh99CGVcZBP1ldZzjq3SL1?=
 =?us-ascii?Q?GPatk29Bzz8SSdLx8d+QTD6mO4+gAyiYPTiHwQ2PaATuYSABMhsDGdk++LA9?=
 =?us-ascii?Q?kGQyf3uvT1zkYyNqvONKp9myKuz9ke6cZz+YfG2fzH+mi/Bc8Fjt9ZGZPprQ?=
 =?us-ascii?Q?UfbfT7uGwHOwktZUud6JSbNyOj7rBgySNIK2rQ8bSOS0L+hnD+jaw5VdSyCe?=
 =?us-ascii?Q?vcOrs6YBYOmboDVvoaHWeiBNyPsakTiUDME+T+/VauXvbg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z1/0iiib+NCoWsHgnz1OBb8T3C2W/+0eNCBK3pPwye9YYqFgLpKzHA4yxJcK?=
 =?us-ascii?Q?n8U7r3wXv7jtO49CI1B+0Gc+eAoYkR1rK2qbVC/fcllNDQUiQ9E9sgDXvQRT?=
 =?us-ascii?Q?BNHzUX10Nj4k+IUDA2YlLDO4/Z3hk3IinhwTnA+mbitQaY578ZOw11MYLwBT?=
 =?us-ascii?Q?/Gwu0wYOrmpECb4J/wNa6JVIHHLSofUcMJB2D8qVprEz99el2cQYHuVLVIeC?=
 =?us-ascii?Q?NpmrguP2I5pg/MQv6YURPB2GNxcMoCnuNsS/hu5G3+qH+kG1wNwoTn2+1MMG?=
 =?us-ascii?Q?WqOFes37eB9Y4bmEupKVcQiDS2VGPGkL35+RsgQ+PiWg4Mf0TOl9z9bAnmX/?=
 =?us-ascii?Q?DqiebKzZFU1yi+3zrRGxiaApHCR+9S1JrfZ8nFOqkVA/Yy9UMZgUk8Dj07dn?=
 =?us-ascii?Q?h39wGEPQ7V5o81FooixIsm/2zlOy/x3iUCn9oR9VDn60VYCTQ4FDsuUKriVO?=
 =?us-ascii?Q?YHe4vCBO0PLqvHkVNP1NkT+G1HtRNTH51VaTuxMcT+VRC1vYMzImIywQln61?=
 =?us-ascii?Q?jUB1zV3Ap+PfTpAIpF86+eJfcMskO3yyl+AzAp6trSQlCffocK72hB4n6Ogu?=
 =?us-ascii?Q?xGy8hKp0gqJgOKBAYICcVZMs/A4ed4V69aCBCSbc7oRQ2cYiCJnFTpRVxpAc?=
 =?us-ascii?Q?SbBgM1RAJPm9VwgsDU1EsWR9j4WMkqaMW3cesEJTB3ztxPakxiwYl8pN/PNN?=
 =?us-ascii?Q?yVOF63NFH5GMQPy5BBY3t8t7331892uyGGVlsfsbDl3d8PcXYrsM9ypR1x27?=
 =?us-ascii?Q?+xhEUjgdfRI1HeDYNAqdcvxugidmy9+aUHkdjCiJeG8e+/yk7JJvLmoKWJqM?=
 =?us-ascii?Q?sDX1UoJNfq0lHsbbjL9dBB6V1lZOQGPf5a1Ja6DQlq8gtb/2TgPO5G81nDgf?=
 =?us-ascii?Q?x79LfZSEPK0CiaaInjmVPr5YmIKsrZp5LIT7e5CKgADnl/ShDIzflZXOOKNg?=
 =?us-ascii?Q?zQlzho6+2UfVZExtI1gNM9lRlWrzzqy4UonqC8nwPGldmiS4Jm69QLOhiu3z?=
 =?us-ascii?Q?IsVyt3zfOKMTLq67WeCVk3POQ8K/LJEDxSaMPZdInmHPCgvAFsXSNc4zl6mz?=
 =?us-ascii?Q?0E9AIDJga1EjDEX7DHDmQaI/Tm6hD4MeQAZm/V1nwtiHBApuiyP04kuxMnYs?=
 =?us-ascii?Q?gu/9fcz2VuWR9YJP2hUQ/NfiMT7Zdco5NWv7RCLHWUQDqUB8l9oDyMs/O45Z?=
 =?us-ascii?Q?HS34FPGtFTZKgdKlirOlCBs/Rk1y6sMHriexgcLLmJ20PweMorYC7lmiiEX0?=
 =?us-ascii?Q?fIPkdyOv7rbYvSlYOw3RPzYpQ0BHDeh+Mydth+jeZLERnt/w5F/EYFbD1ORL?=
 =?us-ascii?Q?REGi6ZWXgs8FOzjUV0pmyKSqArSU6UE4avOUU/qNpFlMqaBS+0MiS7ZFVssz?=
 =?us-ascii?Q?ujr4acoFyg7Q2MnzV/rS9824r+i4LGdPs+pX3EtGaRcVl44CJU45NovpaUPK?=
 =?us-ascii?Q?Pp8yKjEHv45cZRx760wqOoWg2soglcHASmZbuT5njoefMQdBjRZBkYmQs+SC?=
 =?us-ascii?Q?Gxq85NCEL7RAZtaVL6ub+0oB/R6IWvz7wPXr9eFdBR5SfDgf41QQzSZwtEJr?=
 =?us-ascii?Q?iDN9VJ+ehB7XZNRBKaaFpy2fAJj5/4jawr4omkR0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2151e65-2638-4b7b-4b03-08dca04f3a43
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 19:42:12.1355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fwRcTjR2FrBP8sw+KAEH4bCgHZ/l0lJdy2EI42e4x0NuqBTNTjt8NswbRzKDSGoa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6280

On Tue, Jul 02, 2024 at 07:46:16PM +0100, Will Deacon wrote:
> On Mon, Jun 10, 2024 at 09:31:14PM -0300, Jason Gunthorpe wrote:
> > The members here are being used for both the linear and the 2 level case,
> > with the meaning of each item slightly different in the two cases.
> > 
> > Split it into a clean union where both cases have their own struct with
> > their own logical names and correct types.
> > 
> > Adjust all the users to detect linear/2lvl and use the right sub structure
> > and types consistently.
> > 
> > Remove STRTAB_STE_DWORDS by changing the last places to use
> > sizeof(struct arm_smmu_ste).
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 79 ++++++++++-----------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 26 +++----
> >  2 files changed, 51 insertions(+), 54 deletions(-)
> 
> [...]
> 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > index 1418f21f5db6a0..8b58a30ebeb06b 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -204,10 +204,8 @@
> >  #define STRTAB_L1_DESC_SPAN		GENMASK_ULL(4, 0)
> >  #define STRTAB_L1_DESC_L2PTR_MASK	GENMASK_ULL(51, 6)
> >  
> > -#define STRTAB_STE_DWORDS		8
> > -
> >  struct arm_smmu_ste {
> > -	__le64 data[STRTAB_STE_DWORDS];
> > +	__le64 data[8];
> >  };
> 
> I'm not seeing the improvement here.

Are you just asking to keep STRTAB_STE_DWORDS to use only for data[]?

I seem to recall a reviewer asked for this - but it can stay with no
issue. Let me know.

Jason
