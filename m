Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46F1CF2A1;
	Thu, 22 Aug 2024 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346395; cv=fail; b=WD+NgV2ryWaui06MMadQnRaDLhR5UMWmRSHLQ22bVhXQE+7WCebqy6lYjORNcqswal2+Qbr53Cn2k91MA0jzRPz6Ie9DIzLZ+N8TtdQCz4wrWeaDJwvD3qSmlm4utGJXO7+J7H/Z3sOM/pEv20AA8lu6jeVp3m1BlCuIskZmst0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346395; c=relaxed/simple;
	bh=CKZpkvSPLU5XZeqkxkZHqIU/EQ1uK0DsxWffuDejKjA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ThcnF4s9nw2jm/R4TacGy5f3fpb+PR6ELfbRov3lH/cwl1U6fxSRPaytrnKU5Y5fxHFVdcF0qOF8r0jnmM4qJSPosXTdk53Vt+WZPazIoe6aYqkQUD76pWJagm4SNq2qG4w98dmAaUoD1aRPpaCo5kGOdVSl/nSDALPHtDgv5PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=p8tFf/YT; arc=fail smtp.client-ip=40.107.92.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="p8tFf/YT"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HqOxbHTVKnlsaWzAJW4ofsRmQpJmdwPXfwh1/Vlfa5lHvHRFbDaPrFBKcqdXRPJPcONxxVm/hAjd+zZedILga31HxLbGKkJBdg5eajPcnz4FhMr7g1DDZHrH5RtrY2QNAaNNJ0w1/M5IaNok/EgfrU+Lvf4quTmPjXx3YvvqZx1GGJEHFqfp99zD/aPrW2sNJBKKS3lT3fuNR5tO4r4BGa/qFbpPLSv7A8wCzSwsI6Do/4qHDIlA1ElQmWk17DWa2dzO8cQBgXQ98Y+egiEOo0ksGfC/zOVQ8LcLCXCzPu1+C3HGPDtXBCaj0dhXNzQV1NXwnRAherc7TuzLJMiBMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vi5LxEpXnLbLR9U2j/UtfgS/9utzP3znvFO+Nwkzbe8=;
 b=fkXDwUhE8Np/fAlXfVXNqvvRflUPdPZo5MM6xbS0e5HAO+YxVkUuq1lpXfhwbOWGB7yEc1fARe9PaM6QC37TcNcHm999pqsagcbJU5k9JNFvsduZjUf8oW79kQpdRPuC4f7czaxYNk8ISXtDAnDeBaAtl8AZaJoBxDtuycKsGXH7I6ScqCHzV/NH/q/8Tp7z3QQC1AFWfUD/52GBziK+CMphscg2eLu5zLAlKwz4RaNnTv94jiyERqb7m0+O5it4PMw6iK5ou2T95rSzmovpKmNiUlRAdkal7ZGcAdqx6EyeEnmL1A/E16LvBiXnohR0bHlPxSvylqFtoSPuM4UmeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vi5LxEpXnLbLR9U2j/UtfgS/9utzP3znvFO+Nwkzbe8=;
 b=p8tFf/YTtbOemFnfFn9nik1oTIuG4f6bxQGib9Sj2lSwNsxmi4n8AUr1WM32+uGL9cJFH2G/WuEPpq9zYLC8Tk+VEWMVAHPwMTWVPZhaH3xBOFUt2vcQZ8qMWvaHe3z47Uqh+6CeXa+8KZJdEr2wCiCmX/YYLXWGrUUsCY+/vYHScpIkcPraJGJtadaoXolYEzD1OIjR+rIQcCDM90xXfdftf3YPxKKAG3HjWHZJF0JT8c6PkwLt//biBbbTXDO9a+Tub64uX6eVFYljBJfyIvn5Gd03pYDRZ0I5Jt/aRp+T/xZ9Ylu+de4ErDhdSzqTd2t199+tEYIhy+in6yp63A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by PH8PR12MB6843.namprd12.prod.outlook.com (2603:10b6:510:1ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.19; Thu, 22 Aug
 2024 17:06:26 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7875.023; Thu, 22 Aug 2024
 17:06:26 +0000
Date: Thu, 22 Aug 2024 14:06:24 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
	Matt Ochs <mochs@nvidia.com>, patches@lists.linux.dev,
	Will Deacon <will@kernel.org>, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
Message-ID: <20240822170624.GT3773488@nvidia.com>
References: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
 <e978b42b-3077-403f-a5b0-7da6b52f29d8@oracle.com>
 <20240822165931.GS3773488@nvidia.com>
 <29558b8a-93a5-4368-8954-7c7de0d9a0b7@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29558b8a-93a5-4368-8954-7c7de0d9a0b7@oracle.com>
X-ClientProxiedBy: BL0PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:207:3c::37) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|PH8PR12MB6843:EE_
X-MS-Office365-Filtering-Correlation-Id: afdaffd0-a6b2-4b51-f904-08dcc2ccc1b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GOpHkTXr9jlOOkqWHizoHh2mZPjzRWnpjjzdPKRfmVV4+O3dcTrkob1ZM/i4?=
 =?us-ascii?Q?XVFr2bZ/Cz2jvx+IWzz0isK0lTlsywO6nM8VZDn+P1oQ7j6i1h9je78RYXoU?=
 =?us-ascii?Q?KsmAw4/23l3sXikyenEWrDv7uHl9bYbLdBdf6MAYjA2MNGesq9zYF/UBxI95?=
 =?us-ascii?Q?s+UHcMctC/hMotI/82TtKcqo+SnHNkx5ofbEWmgl/+vD3w8lHFFgOnKTw/cV?=
 =?us-ascii?Q?R7EZXLuXoeTV5gS+IwGUVv/I+ww31v0mioxCihgMjYDMeLQ/GKCSPkebXE8q?=
 =?us-ascii?Q?jGgTPaX21TfCVe6R57BpBmrwmygj3hldDcgVpEdbmfD8X+P6K1Ytpuj2rfpl?=
 =?us-ascii?Q?v3pW6XLHnkwNQZlgzDvSi/NRqdRAGz3bhEPFmOAUqcuE1kksg8EIiZLjCLpY?=
 =?us-ascii?Q?3tXbeflWth/+XWLctQbLCxc6T4fSKvsLpt9L0UyYWUnfhI7QT55HRoqBVXXR?=
 =?us-ascii?Q?0TuIg5e5e6OPkmAF+bTEEjb/UjusNoJ6r8LBFn5n1ryzAGVmS50g6H7ccjzS?=
 =?us-ascii?Q?j0NWktUlMfFkt14HJFxPDkbgE6wWna9jx2PE+SIPpKHE63CU7EatKy3ldKH6?=
 =?us-ascii?Q?BMSvDuMPwTx15ZsX8lQ4gRBOTLYX4meUO+buhgxPDcx+xS9XzRRd7xheOhYv?=
 =?us-ascii?Q?aj5mThpqTNlJvzRsPGHUmYQsuomoHkJ7vmlcwEtZ6Vnsn5HOk9S6adUhCpqq?=
 =?us-ascii?Q?zyriHrWyNcV2HZPNkn/IMHZbD/C8nvIOheMG8Bg2NM18YQq0FOBNKVx86zyO?=
 =?us-ascii?Q?W0cWh2t60IU6G5+i0o+nsCBJs9jG3cDqHuIqE8R5k0yP7PWzyPRMpqe/wCY3?=
 =?us-ascii?Q?v4aVlxmidt/q8yRF/bpCIGR0xF860nyEy2Cg0c1apA1X/mv0RfopZJtENkcL?=
 =?us-ascii?Q?5hEja29yiGChdp/YInYcsI3PrDAIG0l9CdI1B1f4YHNxNJO7Gs1NXnM04AuY?=
 =?us-ascii?Q?f/0HpHlSv2vYApiXpf66fCAmGYCtm5AIbuaNDj8Ll4fzo7nE+Wo0bDr0EMrA?=
 =?us-ascii?Q?by5M/goPtGzfQlc6HQhXFhNyGDOBi0KrbH9ym6cbaUBEXQbEfk4CiXadRavy?=
 =?us-ascii?Q?PQmkoIdlDRPk2BgIeL+zMmHUn8006sof14SCxONqX/uP31cS/m02mlZCczVj?=
 =?us-ascii?Q?clR7CeS7Es2S8RLhtE3ooFXafBvDx3IsGAmUXdxX0hOuBHFs0Od5QOfuLQTS?=
 =?us-ascii?Q?nxR8T0bZD1l/7lVcKxRqW5wo2LUJXqdXiDvNdLxPEVIOtRodDXsqtc2j32np?=
 =?us-ascii?Q?pGqZMNPehdx6wppDqVrtWXHgNDDQdM190E5tvOFehrqZ39gP3zVW63+7QBh4?=
 =?us-ascii?Q?pAqLKW+Rnm2R8vfXNOs0oL7XItEdpNqxPCVEr6AYCo0Z6A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ROXw4DsfqYKZF/jJxe6eqdpP/J5IDHHSi8AXcFWKNhx1IimYyRCaqYbbAwc/?=
 =?us-ascii?Q?in0UK4GfrTgxrRe6kSpyZDiIpFUg/uTfQrmjKTEnKsAEB/lmzLMkwX1mTvcz?=
 =?us-ascii?Q?1Cy9czyL90fHJJU6CLWuvWM1ilI2oj2IjiHSgOGOHHGPADJTFKDnftT9tTRT?=
 =?us-ascii?Q?3DQLz2lYojyldv4YOQ4zxngN7XtV/lrWcRDTh8C3SYoO2w56jUH8WsN/aCD8?=
 =?us-ascii?Q?loj3mxaegmOPFJPYfIBkeJjr0536vZA1FB7bkJzhnu+HAZMsHjP5cArjFduX?=
 =?us-ascii?Q?MVo12d5vD7kPSyDuQUBhKp7xqLtK0KGzQ+3KAv9tk8D/0jlb5jTmzeB+uby/?=
 =?us-ascii?Q?MicYiMfIz7YSiBYciORuYeKTsKORDB3WdDlxkNG8mPuqA982GqAVKA+w54zA?=
 =?us-ascii?Q?LU3MEi3p5NPOC9by7T48g0tlfFHKRGUYo+dU6GYiZIC0J9Lldh154iCxij3b?=
 =?us-ascii?Q?/9CAgOQ3Y+jxQCi0Fvz9p5Q7lrVWzzwcvY0yM2WW5YpJU6p+perL96gDR/m3?=
 =?us-ascii?Q?VkPcsDRj+OVGWh1Kph+E0uQfMlCif+/4vWOLz3CcY6j3J6mvdNH7atgtfo0o?=
 =?us-ascii?Q?cfwAAMn+QPoTmsSk9gmdQW09CG+tpNaee7E5UNwh1bLmi4QASmSkO63yxHi4?=
 =?us-ascii?Q?ye3+2O5fZp+mjsONGQmMbkRoY8l3a1xIUsbUqBjOoZl4ZenhDTwgmVn5xCbL?=
 =?us-ascii?Q?/AyJ6ak8PWP5hivNCBqF0qrVZDPPpBMPc5lBKA4moFZnISTfT7RfrLIpbTxZ?=
 =?us-ascii?Q?xbgN2Uth0TzKu8x6oYmm335V4ysImWNEd/fqPBBKis5jAY/JZTccw7Oc4Q2b?=
 =?us-ascii?Q?5pOwVD9Enu5PcP9wliwu2V8iEgc3dfJMhJlAqGHxoZbXj00JZ5aLqrMMiCHt?=
 =?us-ascii?Q?PJTAT0Kx0N5niBUYEUSl71/NVBGZBtTV7ebtq4vasfca7t7sJ5qLROoac2VO?=
 =?us-ascii?Q?MxSiIQqEweweMNsOL61W1DHI1nmQ5ZpSGVD5QmvjOALEd1uOtWcMP/WCaL3g?=
 =?us-ascii?Q?l/R7ZjvMNP+HzFKIdFNF4kGiQiu8j8vh1Vk/06IVChcS2Bn/RXJ/td6FLal2?=
 =?us-ascii?Q?DdyJhGekxO9X9csYOMgtXJsITb861RLsl9BNPJgbON2LMIBQYbwK8/D15PYM?=
 =?us-ascii?Q?bZgyGwvCUFKYJc6bC7mskwSUVocstxSPWOVLn289zZel1OudRDcwnoBjcmHH?=
 =?us-ascii?Q?kBDaISyi7IoBFVnXqj5dnud+QBiJDTP3PIaMZD/36a3doPpuyjPgqjajPnGy?=
 =?us-ascii?Q?uv7sVhkGTrDqoQsIB/QXyXQ1FKmZ1kY+BzAldXE/eg3qECVCajgqhtUy2Qmo?=
 =?us-ascii?Q?fqlHqF+uabJ7UMPsqh0P6eW8uJ3HvellPkfTvbwUcG8TWGsuoETxoU17LLgp?=
 =?us-ascii?Q?QH3YoFEuM7erZW4kyB9y6NYxwUzTgOrZYfc8jCgT2xUhjqtq/cJDC1YLFOdT?=
 =?us-ascii?Q?6mSuQ4tfpaIQJxxP/DyccpCBYamnBLjKKXBo6qG5vu820FcqNtvmFnZYjzhF?=
 =?us-ascii?Q?dIUP/acYFNjbnqU5N8hjnaa7rpHNGuL1xiVzOBkX6CS0QipR4/+BUyfznsS1?=
 =?us-ascii?Q?AL92zKcBuEI57Sf8xVrqRrzjZHRfYMQLpxRkugK+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afdaffd0-a6b2-4b51-f904-08dcc2ccc1b5
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 17:06:25.9983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tYffXeU9y8BGzmqsI6MsBRd+4vJALsAOxjjLPjLUNR5VWU4oa0Xkd6sUYbliYQ0B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6843

On Thu, Aug 22, 2024 at 06:03:17PM +0100, Joao Martins wrote:

> -	if (copy_from_user(tmp, uptr, bitmap_size)) {
> +	if (copy_from_user(tmp, uptr,DIV_ROUND_UP(max, BITS_PER_BYTE))) {
>  		rc = -EFAULT;
>  		goto out_free;
>  	}
> 
> 
> But considering that's only one call side, then I assumed you just wanted removed.

Oh, I see, yes, with only one user (and there is actually a #define
called bitmap_size in common headers too) it seemed best

Jason
