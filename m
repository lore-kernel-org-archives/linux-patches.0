Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.27
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795550878;
	b=KNhavkD1gK1+Q0TgoZEpyaKkD6F7fIUCpQwnkXgSjD8nNUMW9v+ioNLsKwxhEd2PxijD
	 bhrwmjc97jq1m9DZF9g8rSDrt4r4R9N/yciA3nxicfltIhj7gl3gqM/lpTm+BV6SOLfHB
	 3Hf9TvxC/qFZQ5srx+P54cFEbwwXApBj4SYhgSZOQ/m8BMdOJxgBwWyzQRHRVjXOC8jGL
	 6da6wPuDHn41VS/pMhiLNH3Bn0SGydJJOFj2X5tq4QFF9jgeWuFf/6Ytp75UoJDMbOO3o
	 K8utIBbzyaaf3eosFJpao+hLuwiqmDozYbNNtyOekoPoMZJy98QbM+mYtWEsFICW/Ig==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795550878;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=nhCO1/q8aEeOVA1K6H3p6XuP40/IcHnZDLkuQWhusRY=;
	b=dkLDqa8bwnQk343069xqMQlxGcwCf/QpiM0DgBUp2JVmZ/TBP45OGcZCQB8vDlX3zTCH
	 upsv9MryJDTHTED0I6V7cZwLUXHYVbBh7PZDFOA3jnV7Nj9FXRzYIf+zkavgPW8CXdf65
	 ivnUohK/Wm1KgkZY+nSnX8CkBbvNXHJnhDyNJ2gDkldW4mI9cBsttMT7VCuBNCaEMKBlS
	 7Ax+WHv+sAzC2gFszsc8tWgt1rGSMBacV7VrhELL4UKumV6DTK38aANaAZk4AoZjNvhKq
	 f3WvKHncy+jLj8zjHRuWJ2CEw1wvqUGknH2Eby+GI6DpY7ZOuzTs6I/eXIn4zbtikKg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=smcqH84U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.198.27
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010027.outbound.protection.outlook.com [40.93.198.27])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838FE606A31E;
	Tue, 24 Nov 2026 20:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 838FE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=smcqH84U
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E5ZwNKR/adCNhT7ue0zhSQo1vo/2AFn85kjzULTZN8cxH5eAOBhKBr1yQKUXcd2oQsjcae5JZg70w2e9wQ9ylatX9U2Dd0eCN2ZaClrF8HNE/CO1weQzey0D2CixgKzwzbeviRc7OeONyQx4MSX1iS/ZXONH6aH30Hvxi5zJU2wtyJo7KtBNCPSbOY63IQ2DpJGNb7tjN9lSL61aLMPJKtC192PMXhTtvRj+iHF20O/iSDidM0nUlpSu8pQN+lIuHx+xZYinU+Azq7qAXa79AhuTlIXZDTIit3PXH5kvBZwcBvPcCP7zq+/PiLJ7gtYmpdH3vr1lQNCfZHMjuCXWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhCO1/q8aEeOVA1K6H3p6XuP40/IcHnZDLkuQWhusRY=;
 b=wlVQUja+NgHh+mSiOl/FVFX2MweW/ADSF7+CiJbiqZMVOIfqQfZefYQXVdkgpTY1JD39Cs/RPrzDXcMAkdsYUjqeKaxPrt0y+M3EnAEJ8YnKHhtw9ywaiO00d2N4H9d67I57rDv7hwVaVtty6MpPn6SmsRskdsigofIUyHEdm7hOiuq44jAoZNLGG+WqjGhSMsEGuoxGoD97ciyIxO7QuDmA0bOsgl/Nn+kPkybfzKa7QqKakwWqr1e+2gicaYsSfs3fl33DU1Ma6ESMHxOh+VFOZXHifM582Z+SA+089het5/WRDvx0NL+4747ABUuVtfvpJZoIj15Nj/SzA8Yq6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhCO1/q8aEeOVA1K6H3p6XuP40/IcHnZDLkuQWhusRY=;
 b=smcqH84UjmqUYKmsvKBv1gHj4o369sgNySeiyTuhh7Urn+YAxV5r0gkpvdqukqMTtnU4tBsszijkFBlXfZXekBXk2CrZ3fvpYwt4R/oaQ2YDq57xzA49H5zzDJiDEx1LVD+rPTCen7Gbg9q2PkqmYHp6sk3c1Tv7lKEzGbzbmbf+lU54sbKoYxF+6pFaxTJJUlrj6lc7fEisdT5SkxWFxYkD6JxLcLwBcAhsq6wZYHfS3LCArzVUR+YBqtGXK84Oy6HOu5bhgeDVLLjuoD17zdGbMdztSTkAb/Jaq4lhELB6RUrVciPK/7QDDokil2lm5sFiyHYNZyrhRDGTSSluhw==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12) by CYYPR12MB8704.namprd12.prod.outlook.com
 (2603:10b6:930:c2::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 20:07:51 +0000
Received: from CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d]) by CHBPR12MB731189.namprd12.prod.outlook.com
 ([fe80::b0e5:123d:fe06:e10d%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 20:07:51 +0000
Date: Tue, 24 Nov 2026 16:07:49 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	John Garry <john.garry@arm.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 05/13] iommupt/kunit: Skip test configs without
 supported features
Message-ID: <20261124200749.GB114472@nvidia.com>
References: <0-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <5-v3-97feb2edfbab+748d0a-iommupt_armv8_jgg@nvidia.com>
 <awUg0O0WQUBcuUvC@nvidia.com>
 <20261124150843.GC8680@nvidia.com>
 <awXgxBCNDzh/32cm@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awXgxBCNDzh/32cm@nvidia.com>
X-ClientProxiedBy: YT4PR01CA0466.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::8) To CHBPR12MB731189.namprd12.prod.outlook.com
 (2603:10b6:610:33d::12)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHBPR12MB731189:EE_|CYYPR12MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 92bc3b0e-fc1a-4956-ea20-08df4a669e0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|7416014|261021135927099003|261021121427099003|261028144727099003|261026121527099003|261026140227099003|261022105027099003|261021123027099003|261102123227099003|4143699003|11063799006|5023799004|10067099003|56012099006|260925022911599003|260925021311599003|260925021911599003|261009223027099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	hxLbPd/DbXerdK7ySW7HM4ZgA2TNMwnN9rACiwQR2MbcyzBE034Ebu613lnwyO5B6eXwx9QkT6zvfb0PYVmLR40gp8fHx3zwUbJRV41D8AOP+3SQXtldn/tIayPtSZh5Yr4qA2hcwqx0WxHhEiZS97Wp8RH4EuMFfoDIamt+YrTxT7qIcyOk+Gw+qM6ygUXrrC1aqAl3ypq6YhYnoxl+EmuJS1keAn3aW0kcFiOteYDzOU2llpEvBtfsWCFaYqhSz5Uu7RuYOYe0UOYHf17XUBJHZAMQhwZZjcgSrbpZQD30P0AmR3dnJ5f8UYdtBoV+X1SrlZWaaryO+waGugIGROfamP6ojuR7gxVAu+oEpvNFpzT+strVWQh7LtIhzxue39k/HQarIQ2QfaA/RJDeTDPd/SHm4G4O4UW0zpyVPl1QD3LZYTGwPzkqJYZiTE5Fqfu5A8ZkCkU+q7GlE/b7k5ajrEzyvtdSzbzCQcDdmyf7Mm7md/i3P2FPNSCV24Kz2KAPJywKaNWV5eTnoGSVrKENQJudh7xc6CGRu+duGCSGVTj9y0BHZvwaJ5DtLp9+E/lzkSaYHNYtTw42vJNkv5+nsmngmLkGx4UIt1dCC82QKyZWI+/mBcz5UFis4RPhPwgvQOD5e3kvfWxaeHrrC6ZvkeTadwXcnDQIwgHuSy4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHBPR12MB731189.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(7416014)(261021135927099003)(261021121427099003)(261028144727099003)(261026121527099003)(261026140227099003)(261022105027099003)(261021123027099003)(261102123227099003)(4143699003)(11063799006)(5023799004)(10067099003)(56012099006)(260925022911599003)(260925021311599003)(260925021911599003)(261009223027099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZytcU+s2of53VKmA9/Dw5ImxpGsQOHlLUerMrkG/B4y9ZtvEjFh40+lqOdxe?=
 =?us-ascii?Q?CFplBt6bHgl6rcjuvAr6VwdHkGJr4Iyny7868dalppH9SyH0XPmtR4hBb1qC?=
 =?us-ascii?Q?P4o9CB12W0UKVr5PkyQCIz7EbgOKcWfeAAD5VzYRoOsogH44s2BMwHcZ7NSR?=
 =?us-ascii?Q?n7KZAyF2IKvIp2v7jZc2/wN5yDABmg4qQrbpJhfgCHGU5e66xlQWIxIxaYVY?=
 =?us-ascii?Q?T4u4UoUz0JFO7fX8Ex1tfFfEsMBdAlXzlWM9am90cQ8vdSH9tD3Tc2quTrTl?=
 =?us-ascii?Q?E9qcrgwyZ8PKhk5Wx2xpMugC+RdNSjHXuCwFtntBkRUqj6hRxJ0Y/gnjgomM?=
 =?us-ascii?Q?50tlnTo+jk5EL9Qqnb8+TDcAtXuTUftBpTMO3syz//YpxkLTPvTJGNdAL9G/?=
 =?us-ascii?Q?P2hgZNXdtqKqdi/zr8WVW+Qw+SHGPi+GFF2XjhRgxmysc+hD43DSXXpjbN7F?=
 =?us-ascii?Q?/RLayFXffM2wKTpAtrFQKtDw1jMr7c18v/G27I2jTReHxYfKBF9vlYarSogo?=
 =?us-ascii?Q?RVQaZ886DN624buU2takFBWWICzWMVuFhoTHqD/SkbJN+R4JmobWsfVyc27J?=
 =?us-ascii?Q?x0Rxgr3nftrsyKzYjnuJIji/3TTFKdgsedy0rukRJWRyr3hViS4lwGAfK5RX?=
 =?us-ascii?Q?CEuF6DPGM1pYhlEc9AqbZhg6QkI80Ly8l8wYjMLSvxhIvez7xRoTm7KMHFks?=
 =?us-ascii?Q?/gVNqCC+N3n/naFU4FJFbDAn5vUQgS4jgMT8GEhRJMzEckaBpwTtRaMpbkat?=
 =?us-ascii?Q?pA/s0l4tIYsIwW9dqp1lCzfHUBrkUpDFB2bHsWJdCFKxKpJqjGvr8OHq6vEk?=
 =?us-ascii?Q?XL+q7LyUNZRNCEgweMAI1LFW/48ncO4LrAqwubUiQg06OYfIZcfAyRn2NIPk?=
 =?us-ascii?Q?ztQmPAKpIx88UPRnCWNomsisKeuzMVwUgrcYHioZMT0sOAgHinOytA6WbUZ4?=
 =?us-ascii?Q?OfieBc85L05FC3DP3V1FLp4pCK7n393BY8bVK6073N4sz8K4aj9lvsr8K7+A?=
 =?us-ascii?Q?yKOIVSPDjmv1RiLlgGFImWHLYG7Ty6KKoOsvOp0gKX8X7xW4FcY2rvnCJQY1?=
 =?us-ascii?Q?0TaNjKx+jbK9FUKBSQ5+W11tDf2j8Hlu6gn9l5ZhBjVwFVLjFls1a/wiV+02?=
 =?us-ascii?Q?kj6PilAvGY4C1/4tZS2JmnOW4X59wTxHDttudeNQP0L+kEVzXLgfUfwlS2bZ?=
 =?us-ascii?Q?UFKBYg2kJOE9n0zz3DkUK0UUmTq6BsLtqEdDfau/pnBWmHKun74FmapPL0OS?=
 =?us-ascii?Q?4Oao0Gr6ygXkeEWmg/k9C/6pvCe6bUU/CKQyePXGHO7GWdY/seKPMiYsDzQf?=
 =?us-ascii?Q?S/6I0aPxhXiY54sq7Vu32b6oaNNVVbIEfsOPWxRCxEvj7onT9wTHnZAOzs6J?=
 =?us-ascii?Q?625CnchCabuNANqC3VhcQ1+lixxfLHe3hOtuQ4j6ONfkDEwSbwRZV3Naae19?=
 =?us-ascii?Q?1dEc2oBflJD524V9vKalK0UCp5ZqfMAuncLy9CMYmIc8U7tvPWuTJKWfSVUT?=
 =?us-ascii?Q?7Yn7CDre8oeTYIeKt+279w+PZ8gdMf7AWf0Z+glJLVeyfngh2bsn3IuH3hzb?=
 =?us-ascii?Q?4rsV2b4nsCIxNd5QNb1TH2F7yF6jRJo5Lqa3tg5xkxRTP/z4kckx1d0DMWa1?=
 =?us-ascii?Q?cI2Wsdd5dhfkwvWfm1rO7f04PVAcq2xOejJu7J3B0mu7/ucYTRm4FrHhMfs1?=
 =?us-ascii?Q?xLzSF/Hm9HgBuyUObTdI/kfXMN4hHqgrYoFO/OeFaxY9juQP?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92bc3b0e-fc1a-4956-ea20-08df4a669e0a
X-MS-Exchange-CrossTenant-AuthSource: CHBPR12MB731189.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 20:07:50.9326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRkcTQuZUrIdDvS2IuXSPlPPuxGcfKMDum6HA2Ys6AShd89l+0SX8pSk8IAH3jm7
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8704

On Tue, Nov 24, 2026 at 11:08:52AM -0800, Nicolin Chen wrote:
> On Tue, Nov 24, 2026 at 11:08:43AM -0400, Jason Gunthorpe wrote:
> > On Mon, Nov 23, 2026 at 09:29:52PM -0800, Nicolin Chen wrote:
> > 
> > > The leak check reads NR_SECONDARY_PAGETABLE with global_node_page_state().
> > > That only returns the global counter. Each CPU also keeps a small delta of
> > > page updates that is folded into the global counter only after it exceeds
> > > a threshold. So the value can be off by a few pages without any leak.
> > 
> > There is a patch already in my tree to deal with this, this test only
> > works when you use the kunit runner
> 
> 6e8127719449e kunit: tool: catch warnings generated by the kernel
> 
> You mean this one? It doesn't fix the leak-check failure though.

Sorry, not my tree, Joerg picked it up:

https://git.kernel.org/pub/scm/linux/kernel/git/iommu/linux.git/commit/?id=d2eba9f4fa6319eac08608958d4f3a11d5240002

Jason
