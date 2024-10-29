Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2084.outbound.protection.outlook.com [40.107.244.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAFA199951
	for <patches@lists.linux.dev>; Tue, 29 Oct 2024 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730228046; cv=fail; b=Pyjs/kJs9BPlcHqEOlPzTiAKtqhehmvPZJjpiQfbmcC2L/nyuzCjYQUT1C1qUVuwnV989+TEwc+JG4dcEImuMfV5YdXaihTX94gVJQiz6HkOoTuvDw39MS/MyCe344ck2QQ0B538WtzuGRo0IljCf4SkY6sBHNy7dTIIfG2RNuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730228046; c=relaxed/simple;
	bh=izw6IR3AaMoyTaWKuAZlXwQMrUzdP00vH1b7PCwmkUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=E3FWOhk79LUSCNd4mKX6ETxXe9E+for4bYQ88Rgl+DDNaFsyxHHfvQCIVu90apuW48GFgyOBbEFVWUcsbVjyJ7JH1ap0o7vlvLDpyzC08cDnZ4Q7IfFBvkBf66IxC4+8XLWR1A19ljq6AQwJYsOnN3wlTcCUuK16Yy8MIWCEw2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=C4COp2Ys; arc=fail smtp.client-ip=40.107.244.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="C4COp2Ys"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xahi4l5+GupoCgr8zdVljqTwMZtZ+hR3A08ZwZPFHM7i4wba8bKnfPES2cgr0RCQ+leHp+GSfIUS15vpUhh3VsxgHt/knenBex1Pthhcp2RhQoTJoEC261uERsOrHW225DZ2j0yns7fU96E/XoesQMX94gMiwzyQtYqSlUheTcWYuovcaDYzxrWx1QwCI2zdw/lYKv8fhl+RwwLKykVmUpx96hdFx8ot6/upMhU9wdHsdj7x89nUf2lW+elJNE7eaLKiFhIT4TmWeDZtavB4bKSSEUSUVaNderCmrZseuOY8P0e97JiKqf4dCpLKdyGntlIfzXHe+b50p8RkRR+GWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fGErvVXbv+tt7Ozg6GWttoXgN2d0PrA9kMAYIPdAZNg=;
 b=wTghGOZU3fMspROAStA7RceO97YF5zZj0ouFh/e0ZZdPWB9nH0WXuBhxL5YPcirAuiwSUitND07Wz6Detw1CGGSYbNn+IM0IRycrKMc0+rPqw0hU5AOe/TmK664y5xr4w7m+EbPwFaKNjM6CpRDcbmzJ07xN4L/8O1Xhuf8YT5ew7QNDOruAs0Gz+gDBPn/uQ/wSEt/k1SCVncVoAXNMYgWchc6THDFZlUYdWK8jAYr+5Kxe9fDIZG+HsqZK8fXuvwqLcSZfXFh0IGTfV+UhIa40LnFaSUKA81EiLZqldQm0CYIKsh3FuxMMzSXd+YDY0dCTSMw4vbaZjupg8dr/NA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGErvVXbv+tt7Ozg6GWttoXgN2d0PrA9kMAYIPdAZNg=;
 b=C4COp2Ysipc2HN8RXTmZeYwl47cSGzX3/GVlre+uTElJu+5CXkzKS9Jea2EQ+tr3XSnzFasYdBwzGyc4/z3HDyJxUPqd7ZeDURA7rCqjVoxudn19p20caS58XOHU67SdIOXInfONLA0jsSuCusqdaKFpuIpoXpNjeZ8CF3uJc9M7d/iWIlqBuWQ9cs5vHN7vrDV749eKTxMcEn/7WALdTPNEwl4GqOLeLrqwYAyLfBXbPWJH8gYnE14BvBKHpv3FrwBhpC4RLN9IokMIqobZbIWFtzQekguVyd45QteSk4UvWUXkrFi2K/zgqeoZW1m7N+BKC3VyoG1GfxMaejzfhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB4311.namprd12.prod.outlook.com (2603:10b6:610:a8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Tue, 29 Oct
 2024 18:54:00 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8093.018; Tue, 29 Oct 2024
 18:53:58 +0000
Date: Tue, 29 Oct 2024 15:53:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Zhangfei Gao <zhangfei.gao@linaro.org>, kevin.tian@intel.com,
	will@kernel.org, joro@8bytes.org, suravee.suthikulpanit@amd.com,
	robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	shuah@kernel.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, eric.auger@redhat.com,
	jean-philippe@linaro.org, mdf@kernel.org, mshavit@google.com,
	shameerali.kolothum.thodi@huawei.com, smostafa@google.com,
	yi.l.liu@intel.com, aik@amd.com, patches@lists.linux.dev
Subject: Re: [PATCH v5 06/13] iommufd: Allow pt_id to carry viommu_id for
 IOMMU_HWPT_ALLOC
Message-ID: <20241029185357.GY6956@nvidia.com>
References: <cover.1729897352.git.nicolinc@nvidia.com>
 <4f5ed9d75c23a503ffe672a85cf9010569652794.1729897352.git.nicolinc@nvidia.com>
 <CABQgh9Gkt5tsw+wr_=WeA+m=Kz2xY5Z7aSBNhHCvBG2r=7O3TQ@mail.gmail.com>
 <20241028130309.GP6956@nvidia.com>
 <Zx+lGr9iD4DSkc8I@Asurada-Nvidia>
 <20241029152746.GE209124@nvidia.com>
 <ZyEISs6uLbH+nCsi@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZyEISs6uLbH+nCsi@Asurada-Nvidia>
X-ClientProxiedBy: BN9PR03CA0039.namprd03.prod.outlook.com
 (2603:10b6:408:fb::14) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB4311:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a38d87a-6e28-43fe-8865-08dcf84b0b8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IdTZFbnwyA92Cx5+wT1KoAr3HSlFZB6SYhvsDiL9wBaRq6I9vygdnnQMXMfJ?=
 =?us-ascii?Q?FX+fPUdCkiRrXA035+DRDZ6e2n1a7dnHHgVT2aZ/4IT+cwEXEe2gMFKVK+49?=
 =?us-ascii?Q?5ts6oCQqn0Cu8Adqkp3sweX9Zd/g0vMYHCgVoEZYwaLUuSSHjMugzGLeLRyR?=
 =?us-ascii?Q?HKL+BWdHgtHUu0hNtrsrdm0dHk3ZKwWWEw669DK2+VeTX5Ucq45XKs2IbV5F?=
 =?us-ascii?Q?1CdjRj5qsY1Vb49dZTMFTLsR0ktQZayM7kVaSifhVfOhPymmjeNRwPE+wvNd?=
 =?us-ascii?Q?12lo9aJJOWgbSjhYADu0YNQPE2+UzBXTnHJpspxrdkKDvZ6AwBXvWFT4gDn8?=
 =?us-ascii?Q?YgY3ZX0HfkF9/fnn7IE6sutRQEMoHaYqVDoKYM5oGq7vpiN8H0cnzS8joPTe?=
 =?us-ascii?Q?aHG90CKTn8NyMbpIxDw3BuQC0lMw/KnMj3E4BDYuyW1OlXKa7qWiBAXtMgzs?=
 =?us-ascii?Q?XtwMK8n5qJuzNJ20l+tNPubmq1ImnNCHFcFP4HTkjFgnmBiWJ63MmB6YcDv0?=
 =?us-ascii?Q?LjchfZTCzmnekWbElHB+4mfkHighvTwftHpTtdrPLo2I7u6/nhCgY6vbQ1jl?=
 =?us-ascii?Q?edGKzZjK0fnjKcZQoITy3faMeulreZxJT3DixsXw6pd5taGQzCRl7e4s91hA?=
 =?us-ascii?Q?nCCnmA9Ag9Ms+//9vzoWLYoZdtvYOu4IxekYP/e65HEqziGVlIM5Ham/4ylw?=
 =?us-ascii?Q?DTb/QihSxm/TzeWXHKhOJxfI+MGjTAU4vvT+qS9dvUu34hAzVoeDUf+4Gmtu?=
 =?us-ascii?Q?D8zlJNU4jAnASUNaCcNZmdh0C+bvAiOi9vVlSoAheNUe0jEQCC9EVNp0j9pG?=
 =?us-ascii?Q?9t6iR582IcpvEpUIcCaaOlNeFuxJmjNeXuWsWYkpB2QfpjJ0XRynkFz/cPsk?=
 =?us-ascii?Q?B5Ge9c2T5acWPuhNNpOu/+QQvALVvnlWVsOEoo+iZTVo1IMcFtHbTlMxZVsW?=
 =?us-ascii?Q?jqXN3tndEKTLjQ4sNxdr4JoEFlhjKG5byv8EPtds3i8kSI7w43jgK4eUnztO?=
 =?us-ascii?Q?bhXcLIh4RsVzh38Hn8gaPjAr7o0aLmsVhTuFggH26cUgZgeBdPD56DFToIsI?=
 =?us-ascii?Q?rQx7jKfY6AG0DKbNOBxkfXk+fO59vM7+nlE8U7kjyOtwIgHLUeX2hqQv2zxf?=
 =?us-ascii?Q?7K7dOPu4OpaNiCGCpL+LEjeWBksu0x1U1ZGi/1nGfSdxoHDg1PQQztypYX8N?=
 =?us-ascii?Q?uwFrfNGGrbXT33a2hCBcSt9pU9vkA/I9v/3zpVhTTpeOqeQruwQ+qVgHLZjp?=
 =?us-ascii?Q?5NyDa1cIxFaE3fqe8bRj17c86NLKG9xRZ4NrATc+mygRa5jVOoIdrxmlUPzK?=
 =?us-ascii?Q?1xNz7eEPJ0WTw2Bqxx5xEWia?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lDrAI3CGBL4yRDlOYDi6Ls2Y8k2nxmIK1p1HKtlaMkYZYDcZJyrXF3vPtovf?=
 =?us-ascii?Q?dWEj73MGQ2eyjmz3Av4Po4Wfn1lMULGbLaC7GTYCccTFVP8N4kkZYHSp0GBi?=
 =?us-ascii?Q?ZwPbl6U534jb45eenRCt9cQTFxNOH0wMq/4VQ9CY2Bwm/ewgoU3V2YdCDd6v?=
 =?us-ascii?Q?sFtPIg3b5Ct6IX80hEuYMML3Sf7dkXe4YhiLTRkiVDQXvFfw3Y1Z4cFKmcJ9?=
 =?us-ascii?Q?w4AgunyuypHpJdHb32M7OyBEjFdc2ijSAjsGrcIW4+1Js2P6ChhTUi+HifNH?=
 =?us-ascii?Q?zPYGqLtpQvs0VHADUtQV38pbGgp/HAjOJIn7hgLGkGKG+22wqW/uzGNga5FT?=
 =?us-ascii?Q?HOe8j1IzDubamcsuiKsCbf0BB1n1MDC1m+sQymMVEKaZwh3UastZVYEHF3wD?=
 =?us-ascii?Q?QEfC4IrAvxLMVc9M4W2u5DcxF+4+TKVn605C0YfpIXa5+MGkk4ldbOSOQgiJ?=
 =?us-ascii?Q?5mDmxop9rQ/qISSYAh+hPcaXs1lK7orbr31gPtDwvquhdBr2DvaauTFC58/b?=
 =?us-ascii?Q?JI6j36PuMTzHFk5TSieRm4lVpg/a2L2/DJ3L/AgnVGIIpYZkW3WybD4Ttifz?=
 =?us-ascii?Q?YJXAyF9R+gqtHkDtRaj2bsY75HLugw7RJdkW8qAS2zL5vxF/zzc5B07hkxwv?=
 =?us-ascii?Q?zohFfyn/fbitAi/kFQGBThzWu3L1YPkWOhTgHdR9spdBRAONYRcfDXSDtzHC?=
 =?us-ascii?Q?dyAevbiyMmZ9JyUmhoBduiaL6jSP3rFZJ+kQu9wpttMg1z7iZVTijjcpqpJV?=
 =?us-ascii?Q?S331eDY/RdvCrLQCBwdW5R0KW/uHH1r3GHLq0ktaSnL8Q3uNVZvMaxu+Pqxg?=
 =?us-ascii?Q?biqCYwM+fkwiKOOmOo2Slpfo/B9ktwgw42yvGaM945PWinNlylw7H6YTChNT?=
 =?us-ascii?Q?JZgrp26c7c44QoMUEyrio0EHvh4GqhuvAjoCAO6ZGEgh5Eixg5UBo5wBtVby?=
 =?us-ascii?Q?/lDadUxtxaaQDSTg3P70H0M4+GeY0tePv9Rr+xKqvR3t5Y0VSsqj1fk/W98t?=
 =?us-ascii?Q?03i1uVP+FpmB9P7vSIlpBvgDUQ9R+k5zbs9qMteVIrA0UjGc1JI1lmyqVXEy?=
 =?us-ascii?Q?EFS8zVf88fPeh/v9mR4OVAWMVmY+0lgEbKqSMrxaXrEsiU4SzSk7G+JLI/VE?=
 =?us-ascii?Q?sF7FAfAizkxGD+XZHZag5mDo30CMaYRphW3uzPpfyNajw1uqQBzXWx926+Pd?=
 =?us-ascii?Q?CvCDxps/BFmizyYLcH/z6wr0NIUiQdxrS6Nvx/opmWxEkyCt3zk9wYAPPP6y?=
 =?us-ascii?Q?T7c01Lb2wAhvulta9haCsgjTRWCX2vDiZxEBs5MvU7MAYI7zZFY18rQGFWbO?=
 =?us-ascii?Q?XQdl93uXVvd2lvtU/K9mHdWQu6iulkXx4uwXP/v0WpBwcEWi4xATn57gn6+x?=
 =?us-ascii?Q?5XfGx8XFrR3QQgyf3aT+OM3kAV1dPqDlmgNL/d5h/76lRjtcr9VoMHEZsV6/?=
 =?us-ascii?Q?qXAdVd+3Y7oU55UWji5XqrRGnaEHcqAqI49de1Zf3iIyhIke9oKU0Z3Iw8bX?=
 =?us-ascii?Q?5YWzw2GtbQ4zXfhIguphdsCTwKqX6T7wsiJjTIwPOCTGvTuQ4u+oh1Pm/7bQ?=
 =?us-ascii?Q?44QfMD1o86e8kAoepgM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a38d87a-6e28-43fe-8865-08dcf84b0b8c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2024 18:53:58.1486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yQFPNVG3pCasy1UyRyH/RbT+j0quaxZXbCTi+UphpbGDw3o1zmAi7T7CkgRsOPfM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4311

On Tue, Oct 29, 2024 at 09:07:38AM -0700, Nicolin Chen wrote:
> On Tue, Oct 29, 2024 at 12:27:46PM -0300, Jason Gunthorpe wrote:
> > On Mon, Oct 28, 2024 at 07:52:10AM -0700, Nicolin Chen wrote:
> > > On Mon, Oct 28, 2024 at 10:03:09AM -0300, Jason Gunthorpe wrote:
> > > In iommufd_hwpt_paging_alloc(), we reject IOMMU_HWPT_FAULT_ID_VALID:
> > > 	const u32 valid_flags = IOMMU_HWPT_ALLOC_NEST_PARENT |
> > > 				IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> > > 	...
> > > 	if (flags & ~valid_flags)
> > > 		return ERR_PTR(-EOPNOTSUPP);
> > > 
> > > In iommufd_hwpt_nested_alloc(), we mask the flag away:
> > > 	if ((flags & ~IOMMU_HWPT_FAULT_ID_VALID) ||
> > > 	    !user_data->len || !ops->domain_alloc_user)
> > > 		return ERR_PTR(-EOPNOTSUPP);
> > > 	...
> > > 	hwpt->domain = ops->domain_alloc_user(idev->dev,
> > > 					      flags & ~IOMMU_HWPT_FAULT_ID_VALID,
> > > 					      parent->common.domain, user_data);
> > > 
> > > Then, in the common function it has a section of
> > > 	if (cmd->flags & IOMMU_HWPT_FAULT_ID_VALID) {
> > > 	...
> > > 
> > > It seems that this IOMMU_HWPT_FAULT_ID_VALID is for nested domains?
> > 
> > OK, but ARM should be blocking it since it doesn't work there.
> > 
> > I think we made some error here, it should have been passed in flags
> > to the drivers and only intel should have accepted it.
> 
> Trying to limit changes here since two parts are already quite
> large, I think a separate series fixing that would be nicer? 

Yes, let's just make a note

> > This suggests we should send flags down the viommu alloc domain path too.
> 
> Ack. Will pass it in.

But this would be nice to get to

Jason
