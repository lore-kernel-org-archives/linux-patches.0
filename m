Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010028.outbound.protection.outlook.com [52.101.193.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E08536212D;
	Mon, 18 May 2026 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.28
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779115240; cv=fail; b=eZ3N5fKnYem+KsooBZhtNHvF9Ug/iGB3mlVo3tMVOtxfW7aNVrmjpwPWrlqDYEunmIt+yAxJlxjDjBaUrglPFb5zb0fKpp19aFUqbU4fjIy6M2Cqg1ui65a0FoansEwX4/1tjMe/lYQDJm/XybWYdFGMnGecdLChHLq5XJPaOM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779115240; c=relaxed/simple;
	bh=U4ShrQKry4IWqwNB2pxYejt+0hnjNCSyTOwu5niHIJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=U2uKPF2rsw+5XW9X0Vn9EuhVyAw0FnXJ852jd6be+doB4oipeqUZ+zSZ2U2R0zKv/JTqhGrIhhSiUOBk9GITZXEGAOP/ONNBubHFXui4QVS878HzisF0ez3/GTE2eLJoC811CGj4/LQWwR38sjhk/DwavG4DnKxHZK5C56q3Rc0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=okRBQ9HS; arc=fail smtp.client-ip=52.101.193.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="okRBQ9HS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jw8yKooUhaUhtxaoIjUCAEd8NKpwcv1Ln7o3VqaaJgJb/D/n5Ku+mg1UDRcN7Lquan/ry2WZWmgxHqoeYUdbD/ziuGuMQsAUxfYTnj4cpvn8XBh7cM/JDLKUkkrG4p2LSQJCz1NKCl30WwS5HRcuD0maVZaHMa7ucGdomAAE+Y31wgUE0iyMRmgIj1GXIYMN4e5MBnSO+s0/0ZtlI9Muydoy3GC0WYSRWbZG/Mvb6n3hbNc2UPfE+IZ3G218EzR+RRdg+/drykeGldJCn83h0Klw4EFV1CznFajdW5PLA/wYxiFEE2WRpfejVb42LRDHeNnimeFvA6+QyYGhPrHSmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EbZC8JzwIDcz4gBodRgQZqGtswqhri4rwzABGODtQM4=;
 b=iay+PVblQUc8/IK45+fR40Ufagiq9a7qNNSqa2xu/l5VbB72GPfUD6eIso2jMVMs0wMDpSeoRNiPSaoxFzQw/862uyXmv8r2xpuGIeg4sg7wIY6mLhWvs2S8bHRfqnIZeTnmr+y6UI7V7Bssg1Q2/2v1P/31sTyaLh+rUop03qwmp6tbyrmDfBcfE2A2kDLS1oDFMFGazWOkPcAejqXEEZ8hu8BZgH1uK0L1x8AUuzQIYEBgljuv9Cod/WaLtKSiWDIIzrSbwiuEKlYWALJJNgQOi9dfnE3zTTsmYB0PoOgTvIouwakxSQPjenm1qLcYdrjCOavCmY/5ZUzlu2DCdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EbZC8JzwIDcz4gBodRgQZqGtswqhri4rwzABGODtQM4=;
 b=okRBQ9HSFHEO2jf+xHP6DhsRhiSOEHezBhqPgGNpOjephXQ00cQy6xa0LUFpVf1NYSkQ1YcH2juIuQQvkiiHDptH+bbl+NEZ7qQxP1Gzg+i2/vU9juBkxgM9BFLotV2MMV28H86M67wvOMo7QPULi2mvOgRWkqbBhu0LEcSoIH1LjFrVZy/ykCsl8bIu+lZY+3haHusaRJR+AY8JDPktJsZJoIzqRp3+YusjtGcIPGS8h91QO2avPEQhhkzHCieLFvj5bc97dSh9njFJSZQRHpn5RMuKIzpQ7b2zArAf8JK0fK1SvJDFFjZjEOU3ssjOSHot/3AOM6mhnvMiidmdxg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by SA1PR12MB7101.namprd12.prod.outlook.com (2603:10b6:806:29d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 14:40:32 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.21.0025.022; Mon, 18 May 2026
 14:40:32 +0000
Date: Mon, 18 May 2026 11:40:31 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Message-ID: <20260518144031.GM787748@nvidia.com>
References: <0-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <7-v2-47b2bf710ad5+716ac-smmu_no_cmdq_ent_jgg@nvidia.com>
 <agqHLMyWkWRlx0pU@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agqHLMyWkWRlx0pU@Asurada-Nvidia>
X-ClientProxiedBy: BN9PR03CA0683.namprd03.prod.outlook.com
 (2603:10b6:408:10e::28) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|SA1PR12MB7101:EE_
X-MS-Office365-Filtering-Correlation-Id: 8bce0057-7ab4-41d7-d73b-08deb4eb69e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|11063799003|4143699003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	x8K/ZHQMzc+razI1vsliWiYARUopHJ4yfl5mDVvPs5ZBq9UQSRv+vdKhCEGA0JR+Yu8S+/dNZRVKbh7I9itPi21x6p7RYg0/kb2KZM5HPyXfLa10TKZZSYIUGLQx0g8bCC5ex3X+htcr+rKp/3rsX+HHmFt3JeWXiw01e7q3wPgtiLJE5SS4hlQLQJQ8KpZbzCajcUIMaj6dGKANjnKSDsQt5Cb2HyldNGFc5GYH1GV5WGJ5zlerWdBa7X9d9WSDqZcQTVYcUGQK1oKPPo35zb/6enwIrC/wtFLewxBNRZQOTMyRUmBMhctQIRZRa2MOth/ccLoj8b8Mxv+YKF5rjXhHj596ZAmXZdzVsDU23OqQ6XmRaVXapsJIvYgPH5ZIxXGPkapgngEDyBRPWEhTp76p8vz+IoQrozQtUECiYpAdgzyJ8uwqAlAnjJ5qOs6SxTY42aVEGJStozqTY8czhPQ28Qz2WerceEGAwWHVmv5a7NGwq+xgMJp86VzXgwBh81dsBlMbFpUfJ2Hw7RM2+8C1Nn7F0bYO9JfBldrzAUfy5AxdDBisNv2FLlwMV/MLLQDCbFfm7dQ/7/YuBJPtCe7TjeHqI6OUTlo9xwLisg1WNJ3/DhdbuRVWWMrr+EHZX+x8VDdeaEmHoaEKZTDGd0Qj2SyAbCL+WHqOasa2n1E/bvcbZM4dn/GlDA4bIlNW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(11063799003)(4143699003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?NKr92nb+gn4U+UtJ06Mx1UvXBc2NlHNfNDMJQnzuiSEq9DiNcQc/C/9A5sjS?=
 =?us-ascii?Q?dC+9nWEkvXdmqejDLpi/cBscs4nJ5c2YJhVPeVxf2CBmNjCP1VnkrA3HWfgh?=
 =?us-ascii?Q?09SF52/WNVujtBUsY4KJOOAva/e3kL1eOAWLhqDA7coIfCSTW+QE0DbjS3+w?=
 =?us-ascii?Q?Q6Ok4fPPSuIGiQQgz1uoh5eh2GluvZBqgkNdu6F7EhATorU8LOwiXTTRdKK8?=
 =?us-ascii?Q?WDCcKNfFE50nV+0kHxe5h24GoUM/ShkEsu6vyNzixgUsqxOYAx3seNgvcNPq?=
 =?us-ascii?Q?1FF+RjZGTVMsQjPus+SEgrt8+73oEBS3YSydIm+GoryYKVL2qpMMFUwlZGOP?=
 =?us-ascii?Q?IGCOvhJXUPcqYHLTBZJRrjIvYoaAlt3tkn1PwtTXkggkTAkaKOFBg+aDFtiI?=
 =?us-ascii?Q?+BCcdi1f4nH4cbQ2G+sM5NU5FEkeEIDYwrY/4siNbXbNZ6WLfR8l+jwvGsJh?=
 =?us-ascii?Q?a2GDihnnjo4IHLObncBPg3QTzkYTZd2/q2Mv1xxAAlnQ9hCXKxFo8N8ghsAz?=
 =?us-ascii?Q?thwfkbk0ad1WxEb6X6Wuw/HhaEvz5xDTFIxWGQL2Lv6rk9UdjSFMRlk5Qm6Z?=
 =?us-ascii?Q?Oxzo2ZLFu+BhPN6bOKtZ1GWu1eGD+iDIKjXz7xBneyd6WQG2eWc4y27XnOJ5?=
 =?us-ascii?Q?gnQ7/B4xmszJ/rHk+9gRYXrF9C92OJwJhBtYtryYPkla7SymmMezXdN153eD?=
 =?us-ascii?Q?NLQfYW9JUD178ooRuP1ho+ry6sBUQ4G/dcUNr0qBnDKs6QH/4DVMbnZGU7Lp?=
 =?us-ascii?Q?TnoXjwAdQqs6fnFtUB0KQ4+x45PlqpPx63pRqYaUe3iKws7eYuIWsBZaIyXp?=
 =?us-ascii?Q?s+eu+DJMMsxny/Sp2FLTHLlo2y48l5e+gh4+U/i/3oIYmh6r/MkgEust+X3D?=
 =?us-ascii?Q?nqrcxhNykIyRUAIUGh8tXpzcdzdEi4Lgkk1GN/AgtHoZcAIAiQSogtEymwmi?=
 =?us-ascii?Q?fYOi8PFRueDi05AX6DXMLFT9DckVkBr2tnXD1xen5U2QWrJvCQwWVJoFSKBV?=
 =?us-ascii?Q?c6P+gu7r/PSIJIRbM7kv5KFc+kFbJYZtob/72f/peoLXFzbVWvMYmhUyuZRN?=
 =?us-ascii?Q?hpAwq4XBwM8XH1Tl2eKIpVIcrT+XPAzbfG7/KGj07MWhCXbbJXY23EbuuMnK?=
 =?us-ascii?Q?ktsZzTV3aQAmqxmDHb88FVVDOUYLp2Dz/GvtCflyVgTVHfafmAB5wbtc7+EW?=
 =?us-ascii?Q?W6DBMcWTMpqtfZ2rB/fkY3gmt+9Wt8/inYKxV6I7syZyFwixxVOfHsan41g5?=
 =?us-ascii?Q?0FjysosG6DBrUFvEgZ3SFy9dQh3tEemyPh7cWBYZvJhjARDnntkf00Z5azcL?=
 =?us-ascii?Q?GHmSQ2J2xrIQVP8s8H5zMdXvexfQmNv7liWRpWv5SeyuDBNjagCOR9PIQK1V?=
 =?us-ascii?Q?K3sfQxA+BJMUKaCK0Xx2yVi4qtqjjT478fuXNUN0h0mYEnOjqS9TikPqutTC?=
 =?us-ascii?Q?BecGlISew9sy2yVT7vT0hVCisMKrCGWhIjY8AuNkqAOkoakDMaJOnsPLfOCV?=
 =?us-ascii?Q?sNK7l7FkiCzE05frGwLFMBuoOBBZLhQYsLNcfdGEatXYaxkchzwnExaOXtz9?=
 =?us-ascii?Q?ul/UY1FHNd/ULRFd2FNKNsUFtAOh0rxghr6SinDppJGeTr492SQvig/akxly?=
 =?us-ascii?Q?p1o8sFTOyLMgFlHePm9EPIy439c1LoVDNYrbyG4oT8LmAO8FIauwSJXwwF9p?=
 =?us-ascii?Q?Q8qi//y6XCs34eAooe8Alv+jld28PKcv224AkIWaNvC9rhXK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bce0057-7ab4-41d7-d73b-08deb4eb69e2
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 14:40:32.2003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YxdBQfvkhU2Oy73FNHfrGyey2l+z+8iyPLxIOrSl7pEco9dTq3Sa2j0OcHjAmiu/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7101

On Sun, May 17, 2026 at 08:27:40PM -0700, Nicolin Chen wrote:
> > -	*cmd = (struct arm_smmu_cmdq_ent) {
> > -		.opcode			= CMDQ_OP_ATC_INV,
> > -		.substream_valid	= (ssid != IOMMU_NO_PASID),
> > -		.atc.ssid		= ssid,
> > -	};
> > -
> > -	if (!size) {
> > -		cmd->atc.size = ATC_INV_SIZE_ALL;
> > -		return;
> > -	}
> 
> .. should !size jump to arm_smmu_make_cmd_atc_inv_all()?

I audited it, there are no !sizes anymore and there is only one caller
that never does full invalidation

Jason
