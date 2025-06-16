Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2079.outbound.protection.outlook.com [40.107.96.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B0413D51E;
	Mon, 16 Jun 2025 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750077963; cv=fail; b=aLwo8MOD0S0nCjZFlH+QYIW3ro/i1SNSwplq/FRfq1Rz7DNYqwppKTc26boqMQiUzAzvFZQgW+wg1hPZaC13rcAsPTYhCZsZPXNTRKOMSR19WvdWtjsF1I7QUi1lDwX5uXo0OiOM8z5Nw+ha6L3KPTJsBTB8j+9EFNkqIpsZrD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750077963; c=relaxed/simple;
	bh=ctArdJNbWx6InMPFNS/IgQlttRp2rMEf4StJQ9p1DYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=t3ahm6z40xzKzq1NHh/DJ3ClogyXpQidSP0Rs6366MCi3KEWwcMVdCu+gm3udprTwTMTKG1Gbb1dglySxK+nzVk82JoOE21xEXwigfLYXT605ex1h0ULCA4B5GAqeaRXUo1mNpVYEQm1rxMpjNh3YnUgOoBAo/RMn0UHEofAd7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gyXRUzU6; arc=fail smtp.client-ip=40.107.96.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gyXRUzU6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dcqlDgZBs9DCEAChT86V568HzvE4ojD5zfDV5VkvVJaatHIMEQ4IeEvltf+7BHWY3BkPsxtmtyOXXGFp+TceNStLmGDCceTvbM1hHv0SRwgnNznF8UbA8wPfpMMjoyuPjII9bzVY2cmUGqttmRwcWxJpFpMXm3WmMQOmZ2KVK5Cm6+hYKqGqiQq84r/LNqxxnQhp9pNtCCd9noi56vn1dH6e14XxuN4d060t4riAQNaZ5u3fnd7pFbgPjCWTbJE3bxsNRmzY3rdlOXWuo5h0Z1r74fYZ58sppzZoLxapuJi56GiIj7DblUQCiXvGsRfjfdg4UKt3icvIPaIsGr2+KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=58/4g8ttijhXTK5s+fsZ2zDm319W9dsjcx5lY1IM0cI=;
 b=kLJq0hjHL6fp+6jUXYKQiywAFLQxiBQs1yT+NYNYzyjW5oSWTt2yKQ0qQv8q8TZDzp/QpAj6jibp8PuGRR2LpwTj1ph8X/44vF+ufcXw3uB863xN/vK31Ds7Zau+u5lwfUY4oJy2yJG8jcHzXa33CGHGrPYmtn9RFdwrSScTZaNoaoTa6MZIPWoDQZUQFlhlx5nZhAHl/OowYqPrzkXqUg04Kd02I9Bot3bn/EbNTLI18nW6CLqaXGSfnL7Ktbrb1gArdC7WfZu5o+ICld6A+4bgMZTRuU8iwVZFGLuNpiXGds6KVou6cEYZ7g4Ktn6wkQJBe+d+wk08HtxEmCsYNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=58/4g8ttijhXTK5s+fsZ2zDm319W9dsjcx5lY1IM0cI=;
 b=gyXRUzU6k8gi0pDovRDG6V/47Hytyt4Pk6B4vsfBi2ie6+XzeJaDtjwhukdpkcaPIN/Ov7gk+jThbC28vHA4gj/StRzfd4D8bh3I1MDhwW32tVyRm34wRY+RTnsSOyczHp+taGy8A8qqEmB3JWNFe1Ww7uslV8E1vcdc/512PW1whI49CyKSN6x+j5JcjlQA8AbddzSlK5IpRDDqg/A9U6WpOVs0h7MsPFPN4z2j+Xas4uvjGvlVTUWgzH5So2q/aezN0x/RScqHDzjMh7InRohqSsSaPf/M9VqbZ+slAfbs8fenMkvxosZKZRwWCsJmX8EzeOcpD5g2nFbw7vr1aQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH1PR12MB9670.namprd12.prod.outlook.com (2603:10b6:610:2af::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Mon, 16 Jun
 2025 12:45:57 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Mon, 16 Jun 2025
 12:45:57 +0000
Date: Mon, 16 Jun 2025 09:45:56 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: kevin.tian@intel.com, will@kernel.org, robin.murphy@arm.com,
	joro@8bytes.org, praan@google.com, yi.l.liu@intel.com,
	peterz@infradead.org, jsnitsel@redhat.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	baolu.lu@linux.intel.com
Subject: Re: [PATCH v2 07/14] iommufd/viommu: Support get_viommu_size and
 viommu_init ops
Message-ID: <20250616124556.GW1174925@nvidia.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <35c5fa5926be45bda82f5fc87545cd3180ad4c9c.1749882255.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35c5fa5926be45bda82f5fc87545cd3180ad4c9c.1749882255.git.nicolinc@nvidia.com>
X-ClientProxiedBy: MN0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:52f::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH1PR12MB9670:EE_
X-MS-Office365-Filtering-Correlation-Id: 5df19e52-cb86-4b62-e084-08ddacd3bd6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JRha9tOl4KjHALxXaMmJV0KHmQKkOW2L2evNYC6w5iQgUqlB//gD7zjtXji0?=
 =?us-ascii?Q?AVWMJFCFQtItwYSQyRjkq/QT6ymzfJ+HUysnAnSgTBC9HlQMASB+/HxzXz8P?=
 =?us-ascii?Q?Qw82yPI1NU+cdBubw5WsmYJESfcn418eurbKNTxCg1GrFQWQQYmRx/CScr4X?=
 =?us-ascii?Q?zMdbLwBMMXw8M5BjJdc0LBBhH14ah+3dpnoKlQw6HTAaRLiK2p5w37bcKfRi?=
 =?us-ascii?Q?ps86I7AO6rkZOKw9GrNqCOZAYGr3eaTsvM4VUj7BvvJmg7IXHTcgqCsrVRbW?=
 =?us-ascii?Q?gfiybVhNHTSXlPbb47GZY2okUOBjR/YD8YIcXsntL9x+AX3ISszHzlaIUUle?=
 =?us-ascii?Q?JHp6s6PMWmtvg4C2Lbs6XHRujDcGiGEg0jV8iIzn9RwoGu7rGarxk/9mkBE4?=
 =?us-ascii?Q?UX0TQkb3J25/UxyflkKIfb2LLextfWUaAP/yEOWfqBAtObs6WKm2zCL7hJbi?=
 =?us-ascii?Q?D01kZnevzSnHtmc9JSViBU3dCV2gIJ9B75ueTeczQAraHNI3GectTLeu/zGy?=
 =?us-ascii?Q?8cb+2+abXeFs7GIvYGFK30Ui18OLJ2WZe8eQv7vKnOqVbstHwwgFd/VYAACn?=
 =?us-ascii?Q?Pq7LhC+8LasiVz1Y3Yjc8fACtBUP4WeTgUUy9U8EbxtWZD+gIgBo3y2KFInL?=
 =?us-ascii?Q?1UR5Qp/E723DgrKPoTsS61sGvtUkilbhUGDoHytadiXTG0T91oIFx4wCAHQi?=
 =?us-ascii?Q?sR8/BEhJzOJ0ZtXrV+nwicl67H3AzbdtGexoimh7Fa5yh/As64jJ/bUAbL1S?=
 =?us-ascii?Q?PhdHexHpOtL8yHyVDgCrcgEoYPC0KVhDfKYzmwWPe6TCuZmUHDyZGQf9Svep?=
 =?us-ascii?Q?cYvHLAfShPlFHsbV1PF9p2yerwbq5jNJ9zhlc5dA+zyC1DZpwYDWDy9dAGci?=
 =?us-ascii?Q?Xer+D0MAfe7azE9nkcME0wYfTPBBoOoVzX6tWvnkVmWn8djghAwdkzicBI3Y?=
 =?us-ascii?Q?kKfzZcTrlHaJzvjm4boib0sfSGSOLyCubcj/4ZRLSfODZFJ04nKybltNH/CC?=
 =?us-ascii?Q?6eLRSaCIbiFUwUY1CtgO9ppKQOZ8BU6tDG3X78R55VUINVekpknfBTRkr9B5?=
 =?us-ascii?Q?MwzsMtN5OS8yUmWkQTD4yijBy4DVmF6maLOP+5am5RXkSanQMiqpUZ3SmSem?=
 =?us-ascii?Q?s2u5VGOi6VS0MfUVj8kqZPT+WXXFiCnvCe5pOrCB9fCnyNk3yIvT/eEI+0qs?=
 =?us-ascii?Q?5PgnOMt31iUww+NSGbwgZrNRoCL0sRB/I0c86ThWDZTbNx78a2f4OPZ1zL9e?=
 =?us-ascii?Q?r1h3N/oWI1fOKWY3Dmp2IWY7qACnO+vGOpCBs5iFssl3pfLbFWALbuH3ULWV?=
 =?us-ascii?Q?cgRuPLvLRjFOBVh85XAHWrQDuS9sTSFasxLxGhmCFLapHfVlXOPqQ1JbDRiT?=
 =?us-ascii?Q?TE8GNF/TMpLevaLl19e6NzIFGk8Ssn3ZOHSYpEt0NrX5IuTksR4EeqFgHwgO?=
 =?us-ascii?Q?BDxgkdJ7RHY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wGNEwkY+HGLaR2rxlCUNUlmeoEKQArfr0bULRcO+Ma7qXzsQ0B+imzg3Ukt8?=
 =?us-ascii?Q?EZ3fTjMlt0eD/V9wY9fpTVqNCy+Ib0Rvx6jbpvkEd9BvP97S4RpxHEuSWMqY?=
 =?us-ascii?Q?k4rlXLW/2pdHwRyiZjA+BYdlxtB56KvVMfn4SukfwjEkQ8sCNEdfOuipKo0Y?=
 =?us-ascii?Q?NKBTzpR54oA8I190D0GnEtCeXhV/jUkmIitsWBaEzHWmM27ncRQpnZpst+VW?=
 =?us-ascii?Q?Sse8NYCWSrwvuivF6YoMjSA7UfSqRnLaLucdy1zJ9smqFJ9zjb6GdTs6nWOG?=
 =?us-ascii?Q?M2+i4vnjhttpzuIOgQc/fOgWHBaFRiCvi9XnCiufdFAv+hAu8yqEfW2ykrA2?=
 =?us-ascii?Q?qkKO7ZUbTwZn6RjItCVoUyF4+hh0eSwFVLNzMw8JtJ1lpjoJ9YGx6oiXCNrf?=
 =?us-ascii?Q?qdLMm37zpFwCh/rpwk8eSPK+O85K7zW+ZRwV+QSgdJJhpn2msvLnLSrjMAY3?=
 =?us-ascii?Q?7DP7j95NnApJ/+Yd5N+Zc/jZ8smgRG2wg1/pbhsEfA85ZridrjHW7s4vNurT?=
 =?us-ascii?Q?4VXXL6eSUeWvbP5Z7uis94yPiuYQdponWooSEpXnjwtxf6yvyIfaqBcVjOIP?=
 =?us-ascii?Q?sCK6LM06617fYGSOepOMOwA7WzWARWNfRFfmVx1e6C+mHntd5Vb4odbwBEjW?=
 =?us-ascii?Q?sRvTi+bx3R/TLFKxcbsAbTRfFlAnKmYG7/06knP7QPF17Z3cgzyXxIo36j8P?=
 =?us-ascii?Q?DVfgXabCZzraBH3ytl5Dfn3m8VWnrz289zUTnsRh0M2/xeiKxH5xMMscWtjt?=
 =?us-ascii?Q?29uPzeXOv8sDRHmMLDp5l9DGA0i2WjS/+BT1aDglAJC701Wscsiv1bhyb21S?=
 =?us-ascii?Q?MBYJf6YBB7LPMpyi6seAPLGpUxOYCClV8EqTvTt3yRDZcnitd/SkDobAHetJ?=
 =?us-ascii?Q?YpCqZ3yYHS8iy8p2mG+orknquiFp/tpQQb7l1KOElCIwDjxFmLDG+Py7q884?=
 =?us-ascii?Q?y7FnCJLbdqeJcCO1EU/XeySIa9gj8iQ+F+ICG0gYogCe21V7ahny2xBnmSzw?=
 =?us-ascii?Q?30eY2gL8ygd8ht+UnNP1kXhaXPkFGqa3WEOSvSu3vEivEST61p1pnn0ovCda?=
 =?us-ascii?Q?An12TBchDpcWo9MsyTJXvVpp8pGJzoHOp9tuFJRGU3v4t6YhBC5vwe7Xl3zx?=
 =?us-ascii?Q?19jyU4LC+A2FX1/Hcu4nVSifrRotqmLzZXNhddBolpHAquJ83i+OWF7HbhsW?=
 =?us-ascii?Q?Yem2O6C1fpoM+JGGIqdFiRpsAy9/9fJp1SnnGwPL8YEPpwoRgEgBIuri265V?=
 =?us-ascii?Q?GKoYEooH5HPJXS1sLT7YCzwfWvU9YlOyDs3FoPvh1sricDwgGH/UM1i62jas?=
 =?us-ascii?Q?MU/fqHgEsYTnODg8kYoIoQY6eX0tm2jLtSzxbVuv+RcDP1+9Ek7mHGnir8FQ?=
 =?us-ascii?Q?tYIxI9FGS8lFZf9EnFikmyWaacPLTyjMBsCKEGjW/HxiK8FQBZK1sZEqPObU?=
 =?us-ascii?Q?dkT7ojs3ObqQYI8RcK9gaPMuDgQLHaWSYximNOFefaYYZvoySss5N8p2z5+g?=
 =?us-ascii?Q?i/QapEHmS9L9XIBg+Tw6rQu0xji0bd2r9oAMI2HkrlFfFPfrwcxBCIQyCLcC?=
 =?us-ascii?Q?Zo/Sumtuhu6e+ANY0n4WpwUwVZnakR45jHfNrlSH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5df19e52-cb86-4b62-e084-08ddacd3bd6d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2025 12:45:57.6267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfQtG4VtVP6W7xUGzDp67XDaoLfjDWOF3lzMETbP8JxfRAI1J3AWZDLFwPDsUMbJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9670

On Fri, Jun 13, 2025 at 11:35:19PM -0700, Nicolin Chen wrote:
> To ease the for-driver iommufd APIs, get_viommu_size and viommu_init ops
> are introduced to replace the viommu_init op.
> 
> Let the new viommu_init pathway coexist with the old viommu_alloc one.
> 
> Since the viommu_alloc op and its pathway will be soon deprecated, try to
> minimize the code difference between them by adding a tentative jump tag.
> 
> Note that this fails a !viommu->ops case from now on with a WARN_ON_ONCE
> since a vIOMMU is expected to support an alloc_domain_nested op for now,
> or some sort of a viommu op in the foreseeable future. This WARN_ON_ONCE
> can be lifted, if some day there is a use case wanting !viommu->ops.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> ---
>  drivers/iommu/iommufd/viommu.c | 42 +++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
