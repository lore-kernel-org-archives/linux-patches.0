Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2068.outbound.protection.outlook.com [40.107.244.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554813FE4F;
	Wed, 20 Mar 2024 13:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710939939; cv=fail; b=OmnJ3XrN2LNYjtAhnj1L+3r2C/mdQ4ghSHXyQE2rwGffeItao3SPw2Brs+OoZR4BNRcsacX+rGITcJkzSEZqMCoG37o/kiZatM4aJpTO71nTiAoT+AxIRoUew9TyF6EH2SlePiJkIGaG4uXIwP0TTxoKOZEdTXQk6mIN08ezGBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710939939; c=relaxed/simple;
	bh=DeDszcZrDzv2jU7mSdjGumxJHNJSw1209A8lbYz40IE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AON6AiuEOE6ocEXFZfV5PaYNCcPA1E+H9aoTliIQVnmDzByKqiEOhZQ0qef9QC12TlMUGpFaSEZfuBfkeW//3HqmM3Qx2JlAi+voUXyk5osqfjl/WXqiAYU1BZoAjc8UGJDzXm8iJUjdskCgQmSizrtc+jpzwziPvEMFl2ka9Hs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nrvh2Yrv; arc=fail smtp.client-ip=40.107.244.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nrvh2Yrv"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cchIWv2K2a9fo3BsHr/GW18bKi/ox+kQPnpX530/BahL8n2OptdcNzsit0kZtJ7Lth0rRcD2W/PlY2ooDrpwGErivekCTrMzVwWCJzcxbG6o6RpN76whLRw5U3FGd4F7LkggAgoyUXU5WD0lH4wGbCAe+Cg+TUN1ifc4kJ6HCkhZR3tOyW/Xlt+LQq5eT99b1i01tpEhj5omRdJUVX3oT+Mra1uwLrVy0lowV0K92X1GLGX1RvApDE10p+CeTx0MTQ6FvxzV6Y6BjwdLh30twTXzcUXJJ5tfaUJ0D2joKCImaV5Ii+qq/38qf2z6zC+j0Lo5EyonL49+NGKqhM2F5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Kyj2Fn8d6zaca2NHQqGTuk+CTFF51txeugMOlqbf3TU=;
 b=JD+6qPbJbgH0NdT7jopvF5rPZbNuEm+SE7ZPqDvXcQPWz1heUVhOlsTynOtf+PglMstN2g/3xKjPeHA+AVBxN9BONMIomVYZhFGy1cGnlIS0aCeYwtOMzinQmGLGY3GqlOD+HgPDFUEyFIiI29204I2FmcjULqJgzgpT+l+5VJnPZGBo/qq9xMeyW02FA697hNSigJtCd/M2w9RhgZUuwPeMGkImaDLM1v2BvrGmlLbjFn0Tc4dfGjA+e7RBOyhUsh4hkYUHI+ov+nG3jcKpn0DiPiXvTYeO+rJjgw11lPqKkwim2bNG0sOg6VpluTgADAC5NMur2L0g9iBM18kwDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Kyj2Fn8d6zaca2NHQqGTuk+CTFF51txeugMOlqbf3TU=;
 b=nrvh2Yrvm/fAfTXTLg6XMeaeSYVqUQwKqu9YDyPV/zd63O/JYAsFKApq2QzaKIuXG3apE834UX0SfMzYvtZsecDCtPlyWb8t/pNJnKVi1PDp8u5fkfC7Sq/3EINAJi/esgd/tT4JlysAU2QHYpMMv6I8E+2GmsBweptn+CW6k8B7jpZs/gURuS2pVEEBo6+eLxecsI4QuPEgvW3fPY8rq3UsACADMp+1R3SYD1EOyK22sqVRUXWsEKOZHrgau96YpPh/XFWkkvk59CUD9nY0w5z5HRqlUzW7we8Xk18Csb2OElUs51L+8fmnQKVgQfZvQjxgvj8DOclhGUkGWykq4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by LV3PR12MB9119.namprd12.prod.outlook.com (2603:10b6:408:1a2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 13:05:32 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 13:05:31 +0000
Date: Wed, 20 Mar 2024 10:05:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>, Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 24/27] iommu/arm-smmu-v3: Bring back SVA BTM support
Message-ID: <20240320130529.GD1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <24-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV2493ppkJUHOn1jqVG4BzWaz0i2sXRBHD9XYAe9VHFSygQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV2493ppkJUHOn1jqVG4BzWaz0i2sXRBHD9XYAe9VHFSygQ@mail.gmail.com>
X-ClientProxiedBy: SN4PR0501CA0114.namprd05.prod.outlook.com
 (2603:10b6:803:42::31) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|LV3PR12MB9119:EE_
X-MS-Office365-Filtering-Correlation-Id: e537d9c4-3b77-4b31-716e-08dc48de6bd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	s/fwOgEU+Hs+Aqa5zFtMr/ru44PFwA5zR5QdqbaBKlAZFSs94MAbDYNAMLtv5ICe//gHOuiz+tGBJ8qvnuv3UH7K0EqcIgrOr3ycRFwaKVUXuqixDGeT08UsibyAsPF1eWwuPmRCSvm4JOmn0wqB68nq3PZoyltXp05QBpOGyFXzLVWqUaJwCaqZP1Wl3tlmMHwMIRHU+cV/gaxrgHKmph2F7HqHXq41geWR+acYaSG0BOMEb6hTpm95FJs9VU2JRYDVdkzYLF0ji7o+8dQ2vdA5IsK1jwjdMzLHkDfxxsjhzA4oRmwQ6MZbC7yhjNc6GZ+Maw3ODrXSTTJ2lUSQpeMCYgrVRqM50HHvuQOweQV7OKRsDf34cwLjzoVd5hpdogTl+dfHrGo7MY2w5xT4KLXgO26jUNXj4wXPr8kpaT0lMbIaOI3/xtQWtxjEBHn+rA/pUb/1EEB718kwxbCK0UwMV89jC+E1jJXNOiCy6ca2g8ApwdHVFYFWb3oPQDiNyAUNIofAY0nWU95JYCtKGufeQKuDx3Z2esxisw3NlLaNbZTIipcuP6eqRFFVdjB59UqGTue9gQXbzYlrnY99/QSZ8Ij3L1YPsBjLIVFJhYmdJmy/wWoELlUmzWafT04RlnZ/RuCeHnv/T2pLVfVbDdt9TJQxnLF4wqM2m/dDOQc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MExHVHNuelJBUFVIUFZTV2Raci9NVkF2ektmL3R5UGRjRkxLSGtXREJpa0g3?=
 =?utf-8?B?MGUvTjdSOU02WWtmWkdGMUdGSGlNYzltelpnK0JEWENOY2FwbUJlb0pnYi9i?=
 =?utf-8?B?K3RMcm5tQTJKZWNxRFlyWkFWWGJCWDVtRDViYXVhMmFZRXVPRHVsOU9WQ21D?=
 =?utf-8?B?NGUxNllSL2didFZGV216NEk2dGtHekM4cGFsb0FyWThJMUtsYnc0dE1Va1R1?=
 =?utf-8?B?dTBWSlorQXRHQTEvV1JGMmRNeTZQTzAyYXp4VXJ2d2JRRmw4MUNiM2tCSGth?=
 =?utf-8?B?UHo1WTBQRzVaK0JQZU8vZ3FXbFlPc3pNWHMwdW9Wa2huZkNxanBlYjdEakQ1?=
 =?utf-8?B?TlhrY2VldE8yaHFiMGtvSmRhQUx2dGUwcG0zbGd4SHdjTnVVWXU0R1M5d3Er?=
 =?utf-8?B?V0dVajVxTXRYcUc4cUJYaXZCeGc5S0V1MUtydkI2amxNZUFJVDJ2dmRObHls?=
 =?utf-8?B?enZudk80NjR3aEMzT3ZUVGNGN0ZmbThYYUpaVTcySHlXY3R1eFVTNUV4cVQr?=
 =?utf-8?B?UjBGMG50ZmYxSU1CbTFXK0lKTjFDc2JXM0hiM0tjUnd0NGFGeWtLbVY4Mm04?=
 =?utf-8?B?aGVKUHNMNHArR3Rib292RjAyaGYvRUxhamVlS3ZsWW9Va3VzR3pDbGpqaWR3?=
 =?utf-8?B?aldZcTAzbkNuWm1WNzlqY3kwNFpxTDIyVUoyNVhReEtLYmlnU3FZeU9Mdjd2?=
 =?utf-8?B?c2JEandWSXFlQ2hyNGI5b2QrU0VOVEF3L1JOTkJsTlpTODVuTXN0cU1FWWlm?=
 =?utf-8?B?VHJNalo2UzNhd3FOVEVHaFlEclkvY1A2cFovbS9GbTBpQTBjeXA4M3NvdHZE?=
 =?utf-8?B?QitXY1JiSHRTSWx0cUcyQUtBOEFZOFcxTGpCWEJKc2lNSzljTGdXOHZ5NXNW?=
 =?utf-8?B?UjdrbVI5ZVY3d1hNYmFCbHNFamxwYTlsam5hTmt4YU1NV0ZvWTNDN3Roc0VE?=
 =?utf-8?B?czlKN0luUTFCYXhteDFNQzdmNGJtOUdiVTZ6QytIMEJPVml3SzBueHVuUk0r?=
 =?utf-8?B?UmRULzBvbVhJZzZuT290WmhVZEVXeUtnTWpyK2dHaU10WlFZMUNkOFJPc1JD?=
 =?utf-8?B?Q0x0UDFIdlpoaEdqcWoyU0hOdzN6djU4Z3I2Z2ZRODQrdlBuTW96cUlla2Ez?=
 =?utf-8?B?MjlrdFd4djJJaW9tUGxxSnl3ZGdJcTlMRG4yd0RTanNvZGZHSVpMRkViM1Y0?=
 =?utf-8?B?bTlJcWZEOXpIM2dZQzU1eWl2eStsRGxoNHVpaDJYS0hoTVlCTndFTlVyUGFr?=
 =?utf-8?B?VmRQaThrc2V3NVYrcTdGQjE5aW5lYzJUYzJURGM5WWVIZktGaTBkdDkrbEg4?=
 =?utf-8?B?Wnlrd2dkK0pkK3J1ckFhemJsUCtpdEJVWUVXUENuNEhIUHBUdmpaNU02TzFI?=
 =?utf-8?B?SWNlOGhzQmhRVVhqWjNZWFVjbHBsTGJBWkFmK3FRTExZd3ArRHppQXJRYlFh?=
 =?utf-8?B?c3k3UUpoQXdsMStYMHQzQ1h3djhKMDJRRjI1ckl3U3hpR3RyYTRYVTJlZHEx?=
 =?utf-8?B?TXh5TDh4ZTZXcWJJK2tuMDllSm1MYXI0NEVjUlp3QnpuTG9OU2h5NHRRZUNK?=
 =?utf-8?B?ZGJtSkFmUlpHcUhqL3JYZ2g0NjVBcHU5YnpSSDVLOTlqUnVRQ0pmU3VwTDJ5?=
 =?utf-8?B?b0pUajcweXF2R2RyLzJKR3NFdXlQa3N2eXM3aGpsZFVyQUlqV1JtVVFnMnVB?=
 =?utf-8?B?ZWFkK1V2c1dYQ2hGT29iNCs1a2xocGQ5Z3E1ZXEwQWhxOEtucFV2dWt2QmFS?=
 =?utf-8?B?SlNKRUJISXJYMHFiMEdQVWtnUEFRQVhQOEMyd1hYWVViM1JPZmxkMnpqSDc4?=
 =?utf-8?B?OVp4VXpmbzVSVU52Q25iSFJRUDVadnYzS0JmaFZGK3JyUmMwVENKc0xGYXRQ?=
 =?utf-8?B?YlVDdEhIZXc0R1orY0dkK1d0d1ZZNXV5T2pIUytRUHlFcGUvYkhqWnl0TUQv?=
 =?utf-8?B?ZDY2U2VQb0M1Rk9xWk1UeGh3WnUxbnlkbDYrYXJydjM0YmVwK3BIZE1uZFBi?=
 =?utf-8?B?QWFHUERlSy9vSGcyTmhudXVXRjVQb3VNTGhPU1pIR09YdVorc3BsQ0tGcUh6?=
 =?utf-8?B?Y25GNFEwMW5ZVllzdDdKeDZDNzBkb1BJa2dnRzZYQkhmY0lPVkhhTzU3N2VM?=
 =?utf-8?Q?bir5pcECFygkzzDyBzuF64mHS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e537d9c4-3b77-4b31-716e-08dc48de6bd3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 13:05:30.9832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rkxUbTvGJIMpmOIR++0o3Y99IsPpM5WTGfwCouvmHtNPJjmtdXU4//uE6KJeRdbx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9119

On Wed, Mar 20, 2024 at 01:07:01AM +0800, Michael Shavit wrote:
> On Tue, Mar 5, 2024 at 7:44 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > BTM support is a feature where the CPU TLB invalidation can be forwarded
> > to the IOMMU and also invalidate the IOTLB. For this to work the CPU and
> > IOMMU ASID must be the same.
> >
> > Retain the prior SVA design here of keeping the ASID allocator for the
> > IOMMU private to SMMU and force SVA domains to set an ASID that matches
> > the CPU ASID.
> >
> > This requires changing the ASID assigned to a S1 domain if it happens to
> > be overlapping with the required CPU ASID. We hold on to the CPU ASID so
> > long as the SVA iommu_domain exists, so SVA domain conflict is not
> > possible.
> >
> > With the asid per-smmu we no longer have a problem that two per-smmu
> > iommu_domain's would need to share a CPU ASID entry in the IOMMU's xarray.
> >
> > Use the same ASID move algorithm for the S1 domains as before with some
> > streamlining around how the xarray is being used. Do not synchronize the
> > ASID's if BTM mode is not supported. Just leave BTM features off
> > everywhere.
> >
> > Audit all the places that touch cd->asid and think carefully about how the
> > locking works with the change to the cd->asid by the move algorithm. Use
> > xarray internal locking during xa_alloc() instead of double locking. Add a
> > note that concurrent S1 invalidation doesn't fully work.
> >
> > Note that this is all still dead code, ARM_SMMU_FEAT_BTM is never set.
> 
> Clearly a lot of work/thought has gone into this patch, but I have to
> wonder if this complexity is worth carrying forward for a feature that
> was never enabled... Is moving this to part 3 or dropping it all
> together an option?

Yes, we can do any of those. If we drop it here then it will be moved
to this series:

https://lore.kernel.org/linux-iommu/20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com/

Which is the final bit of work to actually enable the feature. We are
getting quite close, it needs some of Nicolin's iommufd enablement
work to cross the finish line, I think.

I agree dead code like this should not be in the kernel..

Will? Please advise

Jason
