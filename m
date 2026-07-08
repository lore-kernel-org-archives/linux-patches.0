Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010023.outbound.protection.outlook.com [52.101.61.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F12883F;
	Wed,  8 Jul 2026 00:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.61.23
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783469465; cv=fail; b=mjYwO2s+ZPyt1dtYAhtVMVz0ZPDkGDhtMgGPS2ORMUwShHEILsfbuQtoyoKEgzdASo4uI1Q2zlKmHSILV7WO3xKvMq/b6itJ0gEM62k0jAK61CxNpO7uXTEFluajtpNuuiVMIYluoRIAY8CbhmkS9QYgy+kNbMDclCRR5Av7zRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783469465; c=relaxed/simple;
	bh=ftrBZDfTeL94Ptl3zm8XBTFUSiDwWpvxQPOEGcdY9XM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uXpRuobqun1tBNTfWqw/Y9xqDX4HKn/o0VlmSQZNDnuXZEzbxW+nvUtKle0rTaSYuC9Vbz3OaGYPUmEZLTV7Cyr+RIKTxfkNR4OGdoDMU24MPYE8Fo7MjOdgWK2Vnp4Pp0EtBv6cDJv53t8WjfvpBnhPdd+1FrkvgvY3ztzhXxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=i+CH/I+y; arc=fail smtp.client-ip=52.101.61.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="i+CH/I+y"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ra0k+n5DBnv/RnejGgOof3gbh0vkCLCaBlkxi1yX0GvBez/9NWnkL2FjKkDUYb9gH/syaV8tfGecsJjIzEP8B7KXvyvLpdO4UhSbJnxKcfrU+gLVpOlz+9oiXROLiLIi/7JtLCtnZCmHWsA8DvRAqrVyD7jFxaCPUf61ANDtTYB1+AmVW3kQzBOtOhZjQ04/XXTSitoIuzsVRFZ4F8aknlt5yoh4EpCMdGQohlAYE2fnIcf6vOEWQXKBwt2i+hq8vaET2AQcRM0s70GPCXnZ+xOboRhjXbPBTlgoAqL+/7lasNc9hHfc/yBpbEvNuJq3i9EHvygEqStSwZCCbXr0YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=39wZINKkvz38H105BpzDsO+7/K/Zfc9lAAAVvoUa4aM=;
 b=cmzEjexRXuB514SJ3r5Zog9fh2nRdmhzB7dNQQuU6v3yPZWvzWTI3doDBAyD0YDxz4DQjmmSF5sHKKBaKyoeFw9EbzuRDeH5OXOIW4FFtnHILrxR3d3YroDiHY1pSvMAwujRtnPlwD2wFqawzun5QhrLxkQyZOE0NCok89Fn4cOqYna7BhvwVY8phBj242VHkaNJs0LxjJrc3JkYTPlkhmoWIB04x8Y66muh3seUna1kehskKUU2a5FFw92CY/FouTbqbBqEI8sZMZEo7rCAmxY1GWR3/oQP7TaKrFgkO/t+be9Ge+f6vb1BOxipIimGRVeSJqNKBGFG64EDDdCC1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=39wZINKkvz38H105BpzDsO+7/K/Zfc9lAAAVvoUa4aM=;
 b=i+CH/I+yRzwfdNo7Hy7AG/MNTYuocTxB1YJtyzzyd5ECqqLegvm4H03f097kEME1apRz9DV3oUdyTWE0gXiknLER7WSh/vdnBTMm6fbPknFpNQhlwZ8+f8jFmj9DUWpB5qMukKtKZfuieCgzXngYNUUjMm0sQYk8hFzIh+cdHJHjwXAZ7iEZCm1olIMgtZR91oNxADLvMLmOhjf+7JVCKMRJwEQjb5z3/w4NF/rOUH/eiRll++zmB1OOHzZLU6U2CYXr5Qt971iUGKumfCD1JTsBjsHAiPSv14yhnWr/EmYr79LGNjEbGlyxyhsd0OUb785hRYA1u0DonhGI1OdeCw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by LV8PR12MB9229.namprd12.prod.outlook.com (2603:10b6:408:191::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.19; Wed, 8 Jul
 2026 00:11:00 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0181.008; Wed, 8 Jul 2026
 00:10:59 +0000
Date: Tue, 7 Jul 2026 21:10:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 3/8] iommu/arm-smmu-v3: Optimize range invalidation
 for latency
Message-ID: <20260708001058.GA422027@nvidia.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <3-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzm5BoV0rToJ7ij@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akzm5BoV0rToJ7ij@google.com>
X-ClientProxiedBy: IA1P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::15) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|LV8PR12MB9229:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b9f4775-03ef-4185-fb2f-08dedc8563bf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|376014|366016|1800799024|22082099003|4143699003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	H3xOzAmIs4GMbLF8SkYAn3szBO/XqoDkHpdopMr3zE6sRuO6gjB8XarWFdCbRdw5NBbEGWkzzLhh7SZwm6btfHX7GIWx5YywdC9LR3qjMtaBomoqX8j/O2kVq0nj6FGlR+mY8bT9Nao/pC0UnGXCFeNVn/yLwnk13WIhWrHiLzB0gOU2belttUcK7R6lDkMKJcS+NFCCsFG66nJiRurbWq8f7w6087+St0lrpXwUs+rhmfSPUEzFp373JelpAo5LgirYD3xZxnnDQVtcwqHXMGGBHLLwKzUcCTEP9CAxiaaOFVwMrcJAQ+Wbb0BYUf6+HkLnI8kpJmW2w9lcrvxdxrFXMYfHhBnzX8frQrwXC+OHbcFTCAJVUPROPC6c4XPmjmRatEgfFAfHdot5UTw+nrdBW3CimFr3jl0Raz0ySEkglvhVLxDalgHjfTlQRxcvEdH+2jsLGeIVSf2xhE4KQL+AhU82Oq3JVFXZIgTNZEsJ09dfzpGfwvVhodB8WgquDT3p1RZo893fZ+kBUb+d8sELqSWNKaxT53W518gXX/U98oheeyNsOxLltrEpY87sythWc3q0IAGM5hHEPBjHb+ZRc6Gp1dAU6hi1u6N0NhLia/4ceznC1wKXluoxhAfZag5ip7480cR+R6k7n6hRZ66/q26BvqOim91VLG0KMdM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(1800799024)(22082099003)(4143699003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?eJecNb/Na8+NuryCc03WzkowDe9+RP5rgH2nJLLuzr2rOfLiiFpgC9FQTApL?=
 =?us-ascii?Q?tjjGMss1wrG+797Tv+Na6ss5o3HwY2Q4jwdcAOXpEMtDs70TUnZYP4pQ6oa7?=
 =?us-ascii?Q?mxr+F0tx5g9Nr7nd5liKoccfHERAp7Mh5n8LapW8DF1r4eX0UMiAXR9kH4DU?=
 =?us-ascii?Q?EuCWN+h8gybTwrmrLx4BwjsaQkBdEx0T8qOK/xDthwRVcZkH9InGUD5onq8Z?=
 =?us-ascii?Q?NB198WorH5b0b2JKVcADpADpXwOsKvn23G/dEboqmdFGd8wuchMIvQ5+B7VV?=
 =?us-ascii?Q?Rn105XI/9xsEAyOdd5bXNu+WjrC/RF6hI3AtFumcAO75MU0RzG6vbLqmI85L?=
 =?us-ascii?Q?HTm89GlZDSauaEET3sc3aoR8pcJWdLxMk5tvuIC2qsXJVk5qy/BkD93uiiQW?=
 =?us-ascii?Q?6IZVfpwMxqnIfF7LmyCiCdNvbT7olgNfb8HDF7IzoXCjBij+ZEeu5xHXZglk?=
 =?us-ascii?Q?LYk8oy6FlJ/KDEsw3O/juy24T6nAOEZWO9xT5LQdrG7S8LJ2za5xQl/z2zcg?=
 =?us-ascii?Q?MfWbq1A2QLaFHsvpu+7bXe/mx7t/xQw6wvTnZ1U55HAHa4FGujtx9EmhQDP7?=
 =?us-ascii?Q?ENK+l9KzkcaC0dQStuS2TFrAlc5WJE1gnvM1JV2gZT7FDH/MDJXGrej1roNr?=
 =?us-ascii?Q?TEfylP+UGkyedmv2zKZT0ddxb9bvNuG+8Uyvw1ypslgLGU5vawoMiFBPRGnY?=
 =?us-ascii?Q?1FMfz3VJVcO75v5c7uhJVo18Tgb2hwsrqRtFXK9kXfeWpKEc0U9v0oV0DIRI?=
 =?us-ascii?Q?uR4IR+ApFPfubpr2xfnk6r8TZE8G4r49xs4WAJN7uJpsRcNbOBexHlRhoEIv?=
 =?us-ascii?Q?8O4hduK6wteGU7Wqx10t+a74ZhALGdRSGv/vfMi2C/Osg8OV7Qly33RtEhYK?=
 =?us-ascii?Q?nW0ARYHRxswaetUr1ja9owW+udmc9/UGHu60rmb9rQV1zjWEV+IUU2EzRO31?=
 =?us-ascii?Q?+ibU4Bh8a/YxcSBHlookqfzV+cPbULHsEXCaY/zVdwt+MRbdMNoOgn06q2vz?=
 =?us-ascii?Q?+RwrS/j8S1O0W4dUli5FwNumtBwpKNRZdZ6AWxjiavKRVbtZWPzKJIb8rM3y?=
 =?us-ascii?Q?7CFBS2cOhrvoJvfJrFfhOAY6P7zOxJoS4vA0tpGat1Dk/2CQzFpmdJ2GAtQN?=
 =?us-ascii?Q?91NlQYr6cN+25fsZyeezl+n7XSkWTvQK95zZkXp2d1Ti6hc1Q2sr7hLLCkPz?=
 =?us-ascii?Q?TKZfvG3oXHM3QX5Op8qKfEt2fAblgsdPkmMkVeZwyQTaewOrHiJ7V2Q+03xh?=
 =?us-ascii?Q?0zESYYeDnAkLLcwm0OjGYEC4WF/tr/NyDnsF+ZSmR2JnZ+ROfkE9BYIHhyuP?=
 =?us-ascii?Q?MKlUHks/Mf1Rgd68BkOZ54y3lxUFmC4jlARPD7iaEoEIV2eGR6cauIwy4x2G?=
 =?us-ascii?Q?pFOZgtjNHszrzwyGlplHN+hiPHvYWLT2qwAqIDyySkDPExL4w/UIDgcXRdP5?=
 =?us-ascii?Q?B+MhQ++CK5fQNZTBf/AQ/wVyysawb6086v1kaLWOC6mUsSdUujMOES7eSNHo?=
 =?us-ascii?Q?O2enGWi4w8/E+nc11AnhhxKTzKkTv1ptV+ST0cyHoP7djbIy5tOwUQGjX4V5?=
 =?us-ascii?Q?atCRtriyyUo2Sep8k8+2A/EvjufQruxTFVzpI+MXcNF+pHKZeaxJlNAq8570?=
 =?us-ascii?Q?emtzox1AQILjTyykrXpfXRXY3bb7oT1N6RdSwX/BJU9eOrtFIF1gGuGtLHCe?=
 =?us-ascii?Q?Ua62jLpY5vpV2EjrHUx+BZf/eqV5SAXnQZS5z/A508+tGVNb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b9f4775-03ef-4185-fb2f-08dedc8563bf
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 00:10:59.8075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Azb/jVWs6q3QqNEkNIiM7cW6k/RbWeuO8bMiG+X5b5Nb0sGFnw+xms3pyRaqwEhQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9229

On Tue, Jul 07, 2026 at 11:45:40AM +0000, Mostafa Saleh wrote:
> > Calculate the smallest SCALE such that NUM can cover the range to minimize
> > over-invalidation. Always use a RIL command if RIL is possible working
> > around the spec limitations to form a valid one. If RIL is not possible
> > then do full invalidation.
> > 
> 
> That may be beneficial for servers, but I am not sure about other use
> cases, we already know that the invalidated entries are unmapped
> and not used. However, over invalidating might impact live DMA which
> would be bad for workloads sensitive to translation latency (as
> embedded cameras, displays for example). 

The isochronos stuff I've seen has a latency budget for translation
lookups and has to be tolerant of an occasional full walk.

Prior to RIL you had a much bigger issue, the cap on the range ment
you'd face a full invalidation from time to time if the domain is
being used for DMA while something ischronous is ongoing. Compared to
that a RIL over invalidation is not significant.

I have been talking to people about some formal isochronos support
that could do several things to try to manage the latency of DMA, it
would be reasonable to include some alternative RIL algorithm here if
that happens someday, and it is an issue.

But otherwise, I think we should leave it. Over invalidation is
consistent with how single works, and single has a long history in the
field so I don't think RIL is any worse.

> > At least one invalidation errata is avoided by 'always use RIL'.
> 
> Can you please clarify what that means?

Errata 3673557 requires using RIL if CONT is used otherwise there can
be stale entries

> > +static bool arm_smmu_cmdq_batch_add_single(struct arm_smmu_device *smmu,
> > +					   struct arm_smmu_cmdq_batch *cmds,
> > +					   struct arm_smmu_cmd *cmd,
> > +					   struct arm_smmu_tlbi *tlbi)
> > +{
> > +	unsigned long num_ops = tlbi->size / tlbi->iopte_granule;
> > +	unsigned long iova = tlbi->iova;
> > +	unsigned long i;
> > +
> > +	if (!num_ops || num_ops > 512)
> 
> Is there a reason that was added instead of keeping the old formula?

The original was based on address range as an imperfect proxy for
number of operations, here we can compute exactly the number of
operations given the required tg and level being targetted.

Under the PAGE_SIZE condition this is equivalent. Under
something like 2M huge pages this avoids falling back to full
invalidation in more cases.

Jason
