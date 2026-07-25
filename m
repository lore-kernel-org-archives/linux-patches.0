Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012053.outbound.protection.outlook.com [40.93.195.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEB1331A65;
	Sat, 25 Jul 2026 01:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784941947; cv=fail; b=JvzslnfnXX8ahYicc37VXnsPBEOPr6pBEnsXFI0SyeIqxJNDWri2K+8rTUtp6Kr9z43TtM81pOKLF9MebWw1J51G8IGbDW2tZX/NHqd40W+63aS0FZEoZmdcmiNdI2luf0mk67Bamnm6c1ixDPXbZChGqedzlYuLZjGY5iXFZsc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784941947; c=relaxed/simple;
	bh=8BwDaviklwGx81v4mYCnHTKvkFrpdcNHDUjsHqeEWcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UnnsNg1U8lALMJEIq5+vA/2FAZLIzLvGs4f8kDaPGXXTvFyFukImJ2XYHZyXtl8DtLcOyIqnBYEfnjZoni6Dg87fhG/fjWm87syBnrc1cCwWERaLUPn/Wj6cDUgBbUH+QuqhroqcklKTM2BDoI0tispa5aTXAL81owsxu3JI5xc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Iei7pGtA; arc=fail smtp.client-ip=40.93.195.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Iei7pGtA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gDjQ0WOlGWUodOgPKibV1vT0bKnBcvCC1JrInNrUXAkT9UrNmFk5OMmZ5tTpHyr/fjSKyYt7NRc+kk4CfGp57vDCoXyAjin5Gg1Lni/49fo50uBDS/T8JQUHBxDhZbbPn+EyxJ3HAOCxCLoub38pSiHxFY4E2npFWIHBVNRF0jKJIXz3ahvk9muAW9Cx4lpHbrPrzknlUKlfEbGt1fxB+GaUXRntuEScqCcKWtiGyKp9CMb8BUA1LimoLQw9y+V3RCUujNtDInv1gNvrCXxvkmNQaaMXrWCscdFPySGqtHiTQBSaCWhC8dJBDha/061BhG1CJt9XgBjY48LsRab2Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SONvdh7bwZoKhMpQvFTjZkFERf/2ha33oBwBKd2or5Q=;
 b=UQP9wSn3B4fSGIcWJxk7QT4TQT8IMl3wS7SD3zm9+fi56jgHHBAGWPGGlpyGEJipANfzAXYIeaDSkSzJCwBE265WSZzPP5+mjlnsxnpyqDV3Z9PZmoOyi4Q2S36FLcWANM7goqztcb73u53loJrHSwn9BQcXoj9bEzDQUKT0l60SFPtbuFG6IhBt8tFku62wg6g/mbdXhR1Qga09tQpCFjlFHepuJoSHkFbDrFiR9tDLE9NsF7ipPKFLS/UYybw8fZ84f39I61c6l//lwFZaR3z8vHsZSL5zvWuoCRgydXCRzH5b9jAB8GBWiCyZ/HUP9u7eok3Mn3+39qPSDOFh/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SONvdh7bwZoKhMpQvFTjZkFERf/2ha33oBwBKd2or5Q=;
 b=Iei7pGtAEEE0UR2cd6mi0Y2+b9+V1+SBEM5zbjiCr/9094AiAw3BlGjH9eVIysoPHzR9b9pyt8lfPgZvo1ADqxlJwvpGRXi3Sa4AbaJYNiykod6s6jtXa4JHNK0JvpEgvAcUcM34aNc9OcL4o8WrlB+EYvMGqpX12SLhVIOwHH7kfNqcptYb3TFLmrv25m/S6rjkfnl8U9bkZ7dPfNc6mmcXUmWQaQEpKwVcfS21noGEIzAVRKT9rrej5qvSpcJKf3jBP5oDdfhT2ouDOQptb2dUT4PjsJdgeTYpX76vttfHy9Hs1cZfABf/Gq0hgfhORFuexmPYLmsHg+//Ru+tqA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by BN7PPF7F4CD71A4.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.18; Sat, 25 Jul
 2026 01:12:20 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0245.010; Sat, 25 Jul 2026
 01:12:20 +0000
Date: Fri, 24 Jul 2026 22:12:18 -0300
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
Subject: Re: [PATCH 3/7] iommupt: Add the 64 bit ARMv8 page table format
Message-ID: <amQNcq5RfAY9b+Hy@nvidia.com>
References: <0-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <3-v1-807e2d1a5efb+e1-iommupt_armv8_jgg@nvidia.com>
 <amO70_Bx0hM10xUn@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amO70_Bx0hM10xUn@google.com>
X-ClientProxiedBy: SJ0PR13CA0236.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::31) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|BN7PPF7F4CD71A4:EE_
X-MS-Office365-Filtering-Correlation-Id: 01699f06-2697-4232-3ba4-08dee9e9c691
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|23010399003|22082099003|18002099003|4143699003|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info:
	Cr0wJEEhfvoMXRLtSC1hYPR/nERQ4CxdimywyoLBKpOes6EWUGvZ2adMRAHLRO/HyzyvbDpK6M6Q3vKBzvi6rVA8uf6OfFT/dP44A+ovxpWw2i5JDKVB6gRhv+HcbsnpwTUROoHoGuC1bFMhBkV/snG8tXAJquZ44gtylQq4T/0Ohxya0wgxPybfceA0hMUs4BOpjrVzAI7JoE+496ocGkabeP9bgSDwQFliIDcyQJAzyM7S0Tknj8X+IMIXWAiHZEvKGpZmxWj+0YhPTfJ9aeLqD0rCZptJt/7X7REeNcp+u805UiG4kAwJuPmh+dRbhzdoe0fDThsmxvVhyLipZNXo/EJnzfis7k4NIsXTsWbilA+MtV/hD6Fr1bz8Q/SHVHCXd4tc+0QOXotJ01zdl4qqNKbTH8BN5UwKPFBRBKpA0Da3kJWTFIGbapfbZo9czN1NJywPUJBctzxLj1JSdOZxCwZBQpes6e5Xa1CRFtkp7jvxtLTW+ERtL0GAJ2JxyRO9EfjK/KpttO63dnc3QrgOB3wfmkQzlUmBEO78e6XUcll36GHz1ukHTEFqEUlORhUt42NwPBQZr7sWa+FX+CxAXNbgR7oBCWlMiZOLYM7/lvK8RjkMzSasS+KrAOUJnZtLtgMTLRp2/t4Qr79rke5+SZGNWSXm0InLJX0QzDg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gliv8Aeu12nSDNe4Axf4lmJxrUxFHaV2IOUymhEeFul86ceaNNIcvmwF+13j?=
 =?us-ascii?Q?lHOf5Z9GlxyMxmv5Oh851RG50RMyF7NjPyAvNOUs2+dV1CwzAOrrUV4lQtlT?=
 =?us-ascii?Q?RsnlXAUGmMDh1hWI+94V5+T7l7c3O1nTRqyLQqn+xTgBpCCi3OFjBNsTQDO3?=
 =?us-ascii?Q?JoBXXbNrS0gSOLxwOOPOKViAwGYRUnMjI+pU9uAQR8rNlOFkhJBSZ0xv7SXi?=
 =?us-ascii?Q?8CjxGwp6paFOfHmyGrRO5xuuzfZA/+j0IEoxMiWGNHnisVfqG5kp4XVfdH2J?=
 =?us-ascii?Q?U8BvoYfs2ZYPqoGY0gM6AQAPbgNYvcGx99C6Dc4bglzf7DYNwAaBg7p5KPxK?=
 =?us-ascii?Q?5rFGyt8iOR74eDZaNnPoQ8jSEB6CR+6IHF84+PN5q72Qp1pJiMEJtDwiVjqy?=
 =?us-ascii?Q?BVXUfuMSZYZBnT/dT3b+lkwjyKxsd0zCat/z+YRRYd4FxLu9BJGJctetxXWP?=
 =?us-ascii?Q?ZGkPXAZEHOLxXrXSP1aZ3tD+rf4spQpbh+/fDsr1+Au1VYxLYavnVMsSuU3g?=
 =?us-ascii?Q?f2fyiS7KzxQwNCHbO+OZ6TzbqqmtJC9OHcFSLGUrCLsf1cl5BePFsOtlxiPR?=
 =?us-ascii?Q?VcFmoaWMCyM+MBufeDO4spV2hit3dbYDt+LB1EEg7UVz9PKXN3uelTOtDrs8?=
 =?us-ascii?Q?Uy/LTSgXBZwGnzMoQtR420PQome7pVMqhvnAR2vG6zrcvRGkO7ki5oByDeNx?=
 =?us-ascii?Q?qqwRVchWaKVNCSDdk3HRu4DwihH4yPExJpPK/fEJqdO8phQa53CSgNXCINz3?=
 =?us-ascii?Q?DmXf1FPzuWVGl8IBjxm4NwZPeDjpwTgLXsd2TTKVH7snbRMSwhGupPr4G0oe?=
 =?us-ascii?Q?YOq8HMXH+wFdHwlWATdRg7+40PGl/kiSa7TiP+BhjL7EJdALfYQQtnQhvaPv?=
 =?us-ascii?Q?OoHaqxFsbZKFqdZqYWmXEXm5KMDo76wIcKM5edIceIqbm3rFo1zbgnzXvjqh?=
 =?us-ascii?Q?yhd/Hxr64gTJVjZv6yeF8KwQo2/3tqpddw5WvBRHhItLViGcQ5RHkqEHeVJs?=
 =?us-ascii?Q?g1Gl5Sa2RWDa3ipy+RTN+6kW+cugTzl4GPWgI+5r/QRpIx0HRb68JYnQdgbU?=
 =?us-ascii?Q?HrPAvtVLAMnSsAoyyOwbIUGpFmIbm10yN4z7vwp+0bUjBbThwRseUTYk08nE?=
 =?us-ascii?Q?AwWyDX7CfmnA+bNWY0UxmlNHldNviFzO2/w+SHcyOibEcn0KdTu8YIqKtHRK?=
 =?us-ascii?Q?NPtQwYWtBItqR4CYj2vJqQJJda8AsfCjzVwWOqzfilZAKMvKU1uXxrqrTiC/?=
 =?us-ascii?Q?efajVIQ8JVuO4tLCPn117Ea3pC45RwEBF83JVTAJwtbqcWtv0opdbM8FwD7+?=
 =?us-ascii?Q?ICVqxEOJb5tx7oS22el9iJpgcHWKYXcmT4HyFdrup6h/xALIg8gcSguLpDwq?=
 =?us-ascii?Q?MHiPfsXWCA02LjnxIM3itEloHUw5iaEGtUS+oZWlHWudv6NZsqUMSD/POILJ?=
 =?us-ascii?Q?EX3oZjNO6wH1Fx204HY5asvDOCHrb41nDr+EmcftQguIMYgggvAj0R1/bNHY?=
 =?us-ascii?Q?FxntNJ3YjkiAxHRUqDoX3YktLSwBswg26CGES+8WJ66jclXMjUMtrS2r2CbF?=
 =?us-ascii?Q?MvUeuX2zClQVFk5u34Opd4grvEp/ZXkJwGmTeYRI+YJEFbWvViQiZPLwtWf0?=
 =?us-ascii?Q?0SO2sIfb8i6B9spgYlr3tQ083+bVrCcbrB47w1XKIGZXzJOR5geZ4QExoWsn?=
 =?us-ascii?Q?/9KCNaA2yqiro0YvZlLsSIIZTWwtnyIUDteZq153oEJ9HWedeaN4Oo3bD6ps?=
 =?us-ascii?Q?waQ/4OZwaA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01699f06-2697-4232-3ba4-08dee9e9c691
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2026 01:12:20.3905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D/PH+7E/7Ge8ZqT2mEh5BssaK2lVRGFGunc6qWU4dDFoCkzuPX6EX/7v0Sz8sWA5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF7F4CD71A4

On Fri, Jul 24, 2026 at 07:24:03PM +0000, Mostafa Saleh wrote:
> On Mon, Jul 06, 2026 at 01:29:09PM -0300, Jason Gunthorpe wrote:
> > The features, format and naming is taking from the ARMv8 VMSAv8-64
> > chapter. By far ARMv8 is the most complex format supported by generic page
> > table, with the largest number of options and configurations.
> > 
> > ARMv8 uses almost all the features of the common implementation:
> > 
> >  - Contiguous pages
> >  - Leaf pages at many levels
> >  - Variable starting top level
> >  - Variable size top level supporting concatenated tables with a high
> >  - order top table allocation
> >  - Dirty tracking
> >  - Low (TTB0) or high (TTB1) starting VA
> >  - Software bits
> > 
> > Compared to the io-pgtable version this also implements the contiguous
> > page hint, and supports dirty readback from the S2. It implements the
> > original io-pgtable intention of always using S2 concatenated tables
> > instead of only when mandatory.
> 
> I believe the intention of the original code was to use concatenation
> at level 0 to reduce the table walk. Always using concatenation will
> have a trade-off between high order allocations at runtime which can
> happen late with VFIO vs walk length .

Maybe, but I kind of prefer this version :) I'm pretty sure 2x 4x are
fairly reasonable things for VFIO to be asking to allocate these days
in a hypervisor context..

> > +static inline unsigned int armv8pt_num_items_lg2(const struct pt_state *pts)
> > +{
> > +	/* It is not allowed to call pt_num_items_lg2() at the top level */
> > +	PT_WARN_ON(pts->level == pts->range->top_level);
> 
> This is a bit confusing, there is not a similar check at
> armv8pt_table_item_lg2sz(), that's because the core code assumes this
> does not deal with concatenation and uses max_vasz_lg2 to figure it
> out. I think we should have consistent semantics for this.

There is some micro optimization going on here, if this function has
to deal with the concatination it becomes alot slower and it is kind
of a critical function. Hence the special restriction

> > +static inline enum pt_entry_type armv8pt_load_entry_raw(struct pt_state *pts)
> > +{
> > +	const u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> > +	u64 entry;
> > +
> > +	pts->entry = entry = READ_ONCE(*tablep);
> > +	if (!(entry & ARMV8PT_FMT_VALID))
> > +		return PT_ENTRY_EMPTY;
> > +	/* R_RWMFF/Table D8-48: ARM level 3 has only Page descriptors */
> > +	if (pts->level != ARML3 && (entry & ARMV8PT_FMT_TABLE))
> > +		return PT_ENTRY_TABLE;
> > +
> > +	/*
> > +	 * Suppress returning OA for levels that cannot have a page to remove
> > +	 * code.
> > +	 */
> > +	if (!armv8pt_can_have_leaf(pts))
> > +		return PT_ENTRY_EMPTY;
> 
> If this is not a valid PTE and not a table as checked above, what
> does this check catch?

This is another micro optimzation as the commment is alluding too, if
can_have_leaf is statically false then the compiler can see the
function NEVER returns PT_ENTRY_OA and it will remove branches from
the caller too.

> > +static inline void armv8pt_clear_entries(struct pt_state *pts,
> > +					 unsigned int num_contig_lg2)
> > +{
> > +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> > +
> > +	if (num_contig_lg2 == 0)
> > +		WRITE_ONCE(*tablep, 0);
> > +	else
> > +		memset64(tablep, 0, log2_to_int(num_contig_lg2));
> 
> I am not sure about that, memset64 just uses raw pointers,
> I believe we need WRITE_ONCE for PTEs.

It is an intersting point, I think that might be pedantically correct,
but practically unnecessary, at least for ARM it doesn't look like it
has an optimized assembly version so this can probably be safely
fixed. On AMD this is actually a pretty big performance win as it
emits a rep stor thing that is much much faster.

> > +static inline bool armv8pt_entry_make_write_dirty(struct pt_state *pts)
> > +{
> > +	u64 *tablep = pt_cur_table(pts, u64) + pts->index;
> > +	u64 new = pts->entry;
> > +
> > +	if (!(pts->entry & ARMV8PT_FMT_DBM))
> > +		return false;
> > +
> > +	if (!pts_feature(pts, PT_FEAT_ARMV8_S2)) {
> > +		new &= ~(u64)ARMV8PT_FMT_AP;
> 
> Wouldn't that clear the ARMV8PT_AP_UNPRIV?
> 
> > +		new |= FIELD_PREP(ARMV8PT_FMT_AP, 0);
> > +	} else {
> > +		new &= ~(u64)ARMV8PT_FMT_S2AP;
> > +		new |= FIELD_PREP(ARMV8PT_FMT_S2AP, ARMV8PT_S2AP_WRITE);
> 
> Same, wouldn't that make the page write-only?

Maybe, I'm travelling I will double check this logic when I get
back. We didn't test the dirty tracking yet, but I think we can do
that now, so I would not be surprised to see a typo here.

> > +static inline void armv8pt_s2_validate_level(unsigned int top_level,
> > +					     unsigned int granule_lg2sz,
> > +					     unsigned int vasz_lg2, bool lpa2)
> 
> I do not understand this, the iommupt is the one choosing the level,
> and it calculates the table topology, so it should not have bugs in
> the configuration and should clearly reject certain bad inputs.
> Running this at then is more of a debug check that I do not think it
> should exist in the default config (maybe with kunit)

Yes, it is a debug check, all the function does it call WARN_ON and
I'd rather have it unconditional for now. There are so many
combinations the kunit does not cover every one, so it is not
sufficient alone.

> > +static inline int armv8pt_iommu_fmt_init(struct pt_iommu_armv8 *iommu_table,
> > +					 const struct pt_iommu_armv8_cfg *cfg)
> > +{
> > +	struct pt_armv8 *armv8pt = &iommu_table->armpt;
> > +	unsigned int vasz_lg2 = cfg->common.hw_max_vasz_lg2;
> > +	unsigned int oasz_lg2 = cfg->common.hw_max_oasz_lg2;
> > +	unsigned int granule_lg2sz = cfg->granule_lg2sz;
> > +	unsigned int max_top_level;
> > +	unsigned int levels;
> > +
> > +	if (granule_lg2sz != SZLG2_4K && granule_lg2sz != SZLG2_16K &&
> > +	    granule_lg2sz != SZLG2_64K)
> > +		return -EOPNOTSUPP;
> > +
> > +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_AARCH32)) {
> 
> Was that added for smmu-v2? as the smmu-v3 driver does not use it.

Yeah, it is here and tested against the existing iopgtable, I think
you are right we should drop it off since it isn't used. It was such a
small amount of code I didn't mind leaving it.

> > +	/* The NS quirk doesn't apply at stage 2 */
> > +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_NS) &&
> > +	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2))
> > +		return -EOPNOTSUPP;
> > +
> 
> This seems a bit random, there are others incompatible features as
> PT_FEAT_ARMV8_TTBR1 && PT_FEAT_ARMV8_S2 and PT_FEAT_ARMV8_S2FWB &&
> !PT_FEAT_ARMV8_S2. Maybe there should be a validate() function to
> make sure all features work together.

Hmm, that's a good point. We should also drop the _NS thing too if the
dropping AARCH32
 
> > +	/* LPA2 (DS=1) is only valid for 4K and 16K granules */
> > +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA2) &&
> > +	    granule_lg2sz == SZLG2_64K)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* LPA is only valid for the 64K granule */
> > +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LPA) &&
> > +	    granule_lg2sz != SZLG2_64K)
> > +		return -EOPNOTSUPP;
> > +
> > +	/* LVA is only valid for 64K granule Stage 1 */
> > +	if (pt_feature(&armv8pt->common, PT_FEAT_ARMV8_LVA) &&
> > +	    (granule_lg2sz != SZLG2_64K ||
> > +	     pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2)))
> > +		return -EOPNOTSUPP;
> > +
> > +	if (vasz_lg2 <= granule_lg2sz)
> > +		return -EINVAL;
> 
> When can this happen?

Another sanity check, lets do WARN_ON

> > +	/*
> > +	 * D8.2.2: Always use the S2 concatenated tables feature (I_TDMHR)
> > +	 * to fold a top level of up to 16 tables into the next lower
> > +	 * level. Since FEAT_TTST is not supported single level cannot be
> > +	 * selected here either. Notice that there are a number of cases
> > +	 * in the spec that require concatenated tables (eg R_DXBSH),
> > +	 * since this always uses them it is OK. See commit 4dcac8407fe1
> > +	 * ("iommu/io-pgtable-arm: Fix stage-2 concatenation with 16K")
> > +	 */
> > +	if (!pt_feature(&armv8pt->common, PT_FEAT_DYNAMIC_TOP) &&
> 
> Should not PT_FEAT_DYNAMIC_TOP be always false for armv8?

The format supports it, and the kunit checks it, but smmuv3 does not
use it because of how the STE was layed out and the atomic update
granule. I prefer to leave it because of the kunit, it is a bit of
hassle to make the kunit not test it sometimes.

> > +	    pt_feature(&armv8pt->common, PT_FEAT_ARMV8_S2) && levels > 1) {
> > +		unsigned int topsz_lg2 =
> > +			vasz_lg2 -
> > +			(granule_lg2sz +
> > +			 (granule_lg2sz - ilog2(sizeof(u64))) * (levels - 1));
> > +		if (topsz_lg2 <= ilog2(16))
> > +			levels--;
> > +	}
> 
> I am not sure that applies for AARCH32, spec says:
> 	This use of concatenated translation tables is:
> 	[...]
> 	Supported for a stage 2 translation with an input address range of
> 	31-34 bits

Okay, I will capture that and stick it in some discarded patch :)

Thanks,
Jason
