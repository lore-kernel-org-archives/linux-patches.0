Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012030.outbound.protection.outlook.com [52.101.53.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4527B35C;
	Mon, 22 Sep 2025 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758552295; cv=fail; b=Z6jEysXp6T/vfOhFXhvbzKeDJkO7VqW02BJvTaP5PnuaoKi6qFawm5afNAUnnkTXweHrhFuZpF/+h1jp+UopRkV2xbhUR1ZIycm1Unyfkt72r7wV4v7mvLjAKHVaG20qZ7dXVTzHF45ncvGbtjTxpXoKKtrFnmEZcDOcwJdXakU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758552295; c=relaxed/simple;
	bh=MwFuZsS1rA7QRzVJhLYU049Rap1O7yhNSJKgTCByxxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gMudE3F0BYxEAgc/Cx8O4pxbi3txZNnXrFq0FUCEQYzCb4MSuRt5NI8PLOfxkBPRzwFFWBCqBu1TCwFaGSUbA1xDlvibkidS7qpfcO7UKLKRpUDARwD99QCygWAhYaYr00qwbFh5608+s7Vsc19RxtEUhsNMjk3YTszOP/vGiYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Xd6vEdek; arc=fail smtp.client-ip=52.101.53.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Xd6vEdek"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v6fBmfDRj8yVQFP/suzSu93G2Y/4uzTHuVaDi2YrP7nr9AAFdS7FxcsvEsr53ZfqcBPmWylYVRq4D9JVKymlD/KKCEskzosT6zbYUJYCoyT44IDcT7p25JHlTBRC4j7BvET+LU7RK9WXgxpvtHaSTGZfx3Q1ak0+k90AlRHz0Wmp257H+iRKPlD+zaPDjva4PhV+2WPSfWBWDE3oX175JymZGExycZfk8774iZXUuumTozerZIGZ0AMIVRoQ5Pm290SZ7is9CWDOe5SMqN6ESBOQb+/YpLeNpeiDBqpkYiCWfmVdLsRlqCREPIz2fA7Uf4/++0M27ohPTPYiJ5TP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1uZmXfLJ7u7Xb8hnx8TBVEjB3ZFW1wyFKqzAJ72+2uI=;
 b=WC3v/Sr1CYlHCMfFISnfRnt6c5BoL4XoSfsTH5R/E2TehrTa2qHSKgBeu0d2e8FZAa5NlBPv0+EBd9pGePiIv/agBV20UAgZAc00fkZRq53Mufz3mSWcDBPWmZIkixiGPEqv69g3Xvaju/JbflEboBPuEp0GUVJFCGuT//EFLAWkGqu3IeN2t8/FWpBlsNe9xaEYy6j/iaNYe82F5XUF1jFrmTK/YvlMDf8muJ/NliqL/LyTQimTK16mi/+Dma2LOrTQalhlZMo34w8TwMbMSXdCXsQbXKVWIQOOGsFEYs/J0nW3vm12RbOlnoIaLJDaBVXL1R8x8B82TI7t0cqBIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1uZmXfLJ7u7Xb8hnx8TBVEjB3ZFW1wyFKqzAJ72+2uI=;
 b=Xd6vEdekoKV4QOkY1axxFRQ3SsF7fkV+RRBTN5K70lgOnPjudoaUKpB1G7R3jXDIEgX0n/ECFABOOGjce/ko0XU9RTwEztt/+naRgsU8YZOtNxF+EG4JOzrZ9uzqiUPLYFynSCERRy+UA8MuCIZ7aOwu8b1gP317fwafk0eueyYVIP/X7db8B3feosCpvvqcn7hNJ5VDzUQllG0cSwqmFfoMKslHZizSw8nSe2QqtfPNukpAyBN8P7w4e/ipNFX3rrwwNqYKeaY0avAXDjDgu2EV9Z482sK3dWOOGV9d9g6064eQrmpflRJaUlZ/eiWoo5oBjjE+vVS4ZQUVhAuS6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by PH7PR12MB5829.namprd12.prod.outlook.com (2603:10b6:510:1d4::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 14:44:49 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 14:44:49 +0000
Date: Mon, 22 Sep 2025 11:44:47 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH v2 04/10] iommupt: Flush the CPU cache after any writes
 to the page table
Message-ID: <20250922144447.GB1391379@nvidia.com>
References: <4-v2-44d4d9e727e7+18ad8-iommu_pt_vtd_jgg@nvidia.com>
 <00a3fff5-bf1e-461b-9673-14725e3cd6e4@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00a3fff5-bf1e-461b-9673-14725e3cd6e4@linux.intel.com>
X-ClientProxiedBy: SA1P222CA0051.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::24) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|PH7PR12MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d3be98-9908-4ba0-344f-08ddf9e694c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8kbX64H/bn0dEPbzb1/hyaq7U9InLGShpkoeFmUNch8MI8kQxsR8jzdtWuA7?=
 =?us-ascii?Q?BOg6KltRunmwYRXAhBCHxRRNw7BndhhF3fMuf2j12DU+Co6yVv244UecVoik?=
 =?us-ascii?Q?rGX8JCNRJYHDuMpU9nPsS0IqQGGIJT7IPhuBuAVwgfJKNVpQw9VThPTw9z0e?=
 =?us-ascii?Q?T3n6umnqX8R8sMjmzRvgIpE/cM1XjeNq6wCw3g7hpqdYPLQEK2dhcnVmm0Lb?=
 =?us-ascii?Q?D6rT0w3QehKSm/GWvIWL0bqDfBJS4txtdb9btsSmNz9sl/FsgK6uthkr3+5k?=
 =?us-ascii?Q?mqNMsiYFlqzpKhzinLsAaD4Xwoo9uZntuYfpHEY2LR8ZVCOfUTUjBG8hOsoL?=
 =?us-ascii?Q?W0Dh4JTrvvamgOX9uYrwAv3oeNcc2NnL0Aof/d7f+62XEhHjWA0hpMoHFDKT?=
 =?us-ascii?Q?UfswkfXq/QXlR0R1ucUx29Uoafyge45D0N0e404tseHeGTIzrRU2dUbf698I?=
 =?us-ascii?Q?zY3eqjwp7VbIuGiKnt2KXxWPWnCA4lmOKmfDwsf07FQy0Xm4+eyy7WH6/7bA?=
 =?us-ascii?Q?OoucWly2VyF3nHkNKb0kMJX5auH/0rDJCYxikWoQaFWI1/kQjCUmoWnmvRDs?=
 =?us-ascii?Q?wLe46bel6Iv+Seofx5QbFgrmwcqiRQdH34+fO722G4oLAjUAt0po9emEQe1e?=
 =?us-ascii?Q?xm/lsDQB23o5B42cnJcEwRchg07mErsc3BFKBNlrxdlTa59pT686UCVNR3LD?=
 =?us-ascii?Q?YA7iyd8s2saT6Vqqq22JKelnUgmOg4vzvAcRT+a23sa0vuyR52f2LSH58Lza?=
 =?us-ascii?Q?C9U4Xy7L/ZbenzliWsNB6VTrSIaPIjKpRpBoDfkV2NEOK7uqrA4rJSeOlp5Y?=
 =?us-ascii?Q?X++mP2CJ6aQy1CUkQqmH15NV+GG7kF3GdtaafoMEfEPsxfE4g4qOctVPxfHp?=
 =?us-ascii?Q?iH3bRGXMgJZVj9cI8MplB0kgnr4/J+nml1m42iDh8uCGkKomr4Ay7CdI18nY?=
 =?us-ascii?Q?0kUjMMhGt7VQTnC3FEwScpwGrqJqExqi2Gcc4kqSr0yuhyic2Nx8ssra5sdT?=
 =?us-ascii?Q?XDKxfF/peu+FXO0jS2h8O2SVAv1k1LWV4UkWdP1AkbrWNxjYe0FbDZ5igFgk?=
 =?us-ascii?Q?bhawsztXyy5BH89lyNTAaXDJgwVYRd8R/KR+aMe7IMkKUgVZSw1S3ylyMYXh?=
 =?us-ascii?Q?pH8I+USTrrXOMAkkS82V06hlu9zq+ZqYjnMCN2YgICgEqPdVgiN8MVTyKWKJ?=
 =?us-ascii?Q?aNsp+5g5ms99lBLgAalqx7L8/awL/nrHYnZ++5Wv9FQwmTHNLbpbxdJRiUEZ?=
 =?us-ascii?Q?s+bqiOqWs7Bse9jn4G2p7EM//UY6sAIIOtUPwzp/TpZ/HMwNA79tRnsapoWJ?=
 =?us-ascii?Q?hFpFt95vfqsVYFOV4FF/ZZ0+6CwFH1Hp5QOXBdJmXyH1GAxe7gZq99Z133Fi?=
 =?us-ascii?Q?3+hTexkMdDkVAgdzNRxwuq+FY/FprO/dO3piNg51mglmhhTolKnlCXRP6kDr?=
 =?us-ascii?Q?jdiEUIujbg0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DpjlS8xMx3hW6tCrXY1/j0zxKOPQLgZ0HasWm9jbzwqb1plaSi4L9de90Dhr?=
 =?us-ascii?Q?mSd08CfFpxT2dX14gNM7NkA0gi0o3dvq142P2WO+6MNvfax82LSBRSujh+L2?=
 =?us-ascii?Q?Xmn1s2QWgEcru2uA2nv5uX+dTYxvWyQ8DaMRNPhRqq3GCwlr/0FHA2EmS1zP?=
 =?us-ascii?Q?II6Akw4TwkeSNoYTKRF2uxFz264WSjGOjAADCpmoWwpIERGG/auA3BNh/obQ?=
 =?us-ascii?Q?9hdrjqQ0stuojQzmhCbuQerdzjfaGd9ESv7f71ZGe57UEulO/+7KjPZmao9p?=
 =?us-ascii?Q?4h/0cm60ZaaCnK8smMtWe+Dmtxryu+RfbyUfLVBmQR2EzH3czwWh8KTbbW8U?=
 =?us-ascii?Q?hSYepIl6UI6AcN+UVH2nTJGgs/bbukfPGuiIBCrvPfZxKHiDIWyMfnBG1EG5?=
 =?us-ascii?Q?aUGt5hT5cAl/BoQ8empN8Nd9zkeSuntcczcCnxmXXP7DRy+SDh9QIdhwyLaZ?=
 =?us-ascii?Q?mReWGsuiyxJD0Vbejp7jQrLFQPKGjHJbJEmzZmF3s7am/mcZbsGZPQW+sBWC?=
 =?us-ascii?Q?MjQZ3OW4WKUgE1DVTDHqgL6Vfaz99ZEx+Qz5bXUgFUYEFvclJeeRj8ovterk?=
 =?us-ascii?Q?xc6MSrjdXAqahhCvxnZsDqRQb/DRsY6y+cyb2Eue57sJMvr0OKxIvQOtLuTa?=
 =?us-ascii?Q?Ygnqd+XepUAKrNLZemLFlmClqluW5vXZkeB2r6FlClMWW/NxOCm1UZ+HDV8c?=
 =?us-ascii?Q?wLkKmKo58UUMbsHaCDMAXEieXBAxQC9pYz91TL3OO9G0spO78PALowSGF58k?=
 =?us-ascii?Q?CutMf83kAZakuWiCwP/FjBNiStkc3emzJVF9LrEtxPJ/j/SVSBVpywPl5B+y?=
 =?us-ascii?Q?bwwoWHOrs1JrnvFp88r0ifJKTUE7HUw3HoNO3A2DpmNcj78VuI0XBQf/TSQc?=
 =?us-ascii?Q?elUXF0nHoYWtfYsenNiIH/BSpH1TuLyWaFdGslJCuzS1BNLM2QQ69D7PvJWD?=
 =?us-ascii?Q?c0DNByfwCVv7EILuNZC+mp8nLQANAwxlgujM3LcOKkdPgeBFpN6LpcX6vqXi?=
 =?us-ascii?Q?vnO86U07z5jCzS+1Wv2MzVvZUI3ARHqfThb3706avjCA2ffrsuZpk6Pnzm4e?=
 =?us-ascii?Q?Tw52CNuLeX+t8fIEW8VnMm/uW3b51ubXkWRBNNL/qNlnzJV3GQTblH69qJPb?=
 =?us-ascii?Q?UKNtzqbAStyXMaTLkvEv6QWjsVkeSL+ZrbmpcDIjL+Gicmj+b+Gd9P8KXof/?=
 =?us-ascii?Q?qs116FVgVtf6LoQoZIzcDOJ67D7who2IiL2MtlogQMaGMRQ2g4UWUAoj2p4G?=
 =?us-ascii?Q?eRTXYGxynM5TN98VzMoV/JP1LEYIgVhaJPkbNVR+8PPhSDHe+a1PMeqvP6wt?=
 =?us-ascii?Q?fJL9waIxh7+/ko/X9goLRttBqAvSbRXpSCrolL9tyy3PYRSEeE6a3iJJuT+e?=
 =?us-ascii?Q?8O2Zngod0Vt4kDm92KEy4C5UW6WPMVwUm/AEu/1NenLopZXCglXj4MmGj9A5?=
 =?us-ascii?Q?eRcIsmmCGfYvmCWhDY/C9jm2BcGLIaRaESyN9PlJ1prZo1GUwhC9bVGftu3N?=
 =?us-ascii?Q?UA+mvUKONxZEUlGFG5D4bkH3CdOtx9fE19eQEkLUQ+LoLiUNnQrjJW2g1Ktm?=
 =?us-ascii?Q?QJK166gcMiWY9PdvUnCfKC2IDV1KNh3PBReW2/er?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d3be98-9908-4ba0-344f-08ddf9e694c6
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 14:44:49.1924
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwaQfyGnju/ba2LKJVnwwyrlb+a+Ix0tMQjwvdf5N5j/gOA30QUYRXw0nSCQxgrL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5829

On Mon, Sep 22, 2025 at 10:31:49AM +0800, Baolu Lu wrote:
> On 8/27/25 01:26, Jason Gunthorpe wrote:
> > @@ -585,6 +635,7 @@ static __always_inline int __do_map_single_page(struct pt_range *range,
> >   			return -EADDRINUSE;
> >   		pt_install_leaf_entry(&pts, map->oa, PAGE_SHIFT,
> >   				      &map->attrs);
> > +		/* No flush, not used when incoherent */
> >   		map->oa += PAGE_SIZE;
> >   		return 0;
> >   	}
> > @@ -811,7 +862,8 @@ int DOMAIN_NS(map_pages)(struct iommu_domain *domain, unsigned long iova,
> >   	PT_WARN_ON(map.leaf_level > range.top_level);
> >   	do {
> > -		if (single_page) {
> > +		if (single_page &&
> > +		    !pt_feature(common, PT_FEAT_DMA_INCOHERENT)) {
> >   			ret = pt_walk_range(&range, __map_single_page, &map);
> >   			if (ret != -EAGAIN)
> >   				break;
> 
> I don't follow the single_page logic here. Why is single_page exclusive
> with PT_FEAT_DMA_INCOHERENT? To my understanding, PT_FEAT_DMA_INCOHERENT
> has no relationship with how the page table is organized. Could you
> elaborate a bit?

It is this comment above:

                /* No flush, not used when incoherent */

__do_map_single_page() doesn't implement the coherency logic. As an
agressive inline I didn't want to bloat it.

Jason
