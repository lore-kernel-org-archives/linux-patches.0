Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266F216E881;
	Wed, 12 Jun 2024 11:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718192825; cv=fail; b=kNF2TcA/tY7XcqZSjEqOJ4olDpINq84gOSKr2F7mbFywnlRa5CNx756/gw3JPS8oLlbRCEOzuUDqVwS56cuxLn8p4n1aXSJQFT7BTowR1OTZIYTmNk5VajB8300m2mwUZeKtZoyRXk673617ZRLCjSEqZsuey367KdGcdp2ddOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718192825; c=relaxed/simple;
	bh=JJ0n0jOm1x9d0vj5+fcAJ63ayzP3uqAr3Xlmh0JrGJE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Oko02CVzQQelKFqXiqzUiw1goRKGv9y0L7U/+1hXaBgtP/OEJdmeqT0+jCkfJaroRed2R/qiChE6lsNSy2B+jF9Q7Et66ExV8F7rAtuq0Gt9u2k1GtKuUcnyrH8AwBsefh6lK9F2v8DMryHrEqNRDTerh3EBtT/EvUYvTHhry+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=olP6sECU; arc=fail smtp.client-ip=40.107.244.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="olP6sECU"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EkOCMLprzgGpgvIcPX2t01pGzvFAOWlqYFQNFVrmz85ZFMRTjdgSczeG/8WzzsBvYvP6F9pwnDtPREntcNoqARghQ4TIb1+XQsLR2KpKf0RsjBwIM88Jx6oz5pGf0qfQJcU0Y9bORc3p3XDJ9BAdeEoS/dDdmNc9rev7T7DGSbI2PIKvJD1iFUVmFbLlC3ijxdW3mDX3ztSzp+H3WArPP9O/gY0w9Kp0hRxnDwyRVSPTYgdqLtUvWT3GE0kQDvDlhxP3gpLa2HWEzOH2LrmvB21ZM0XkZv2CDrXw5K9Qb89BEBpZdcZ5wi88rHMxshCrd0dHMvMnM/hp48Kb+wEHZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1qHTWgKwYxaCH61EE1Y5fZ1ZBfk1FEqV6YhsBPsBWGI=;
 b=bJOWxSo6x/89h6dQIHtKnuI34WsmT8x/HOkuSgZc6GABkghUxj1EGaXZrNDyOmM3vzXFN95FQjtUz2v3IBaojLTVfPUDT40ij6B+Ong2yhov8rxmQSKbQKTQqBuypUKKp5kf5uCCj+0+XssgtWAifh7okIv44V0TGvhYQa/v3drn/HMm6JbRwxk01tW/TSX5lLFY1Lsk4+otWq2kgq1sbHTJhHSeNL8kjxEuaPG9a/0iwsGFClt04iO8Typ17g+ktsJbY6e8xQoe11B9c8gQvolE+DDVVSAbBmQ1JvaYjQs0j0DVyoT0e6bnh+zsQ+AP6ortOSrViaQXXdsZrvOH7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1qHTWgKwYxaCH61EE1Y5fZ1ZBfk1FEqV6YhsBPsBWGI=;
 b=olP6sECUoidxw9uTA4A6Ev7YL+Fu37perlVyZEXLuJSNHXor4N5Anmti/Ta72DvnO8F6oanvPV3MaipZ3+6If7bIb7s5maVSc6/3GudasWHh0l2e30ttM5ltvZZI3aN7ZrrCK0agBybyiBQoVIIB5RRCS9tshCwk1Mbza67iWgWfhclldN08NnxK5KTx0BB9DqTu9usYQlgTX5NgSomiqttE+2AHmrD4Fv0qOf/xANKkM3JEgm1GWfv2jo1tr+ed/lY3UEXvDa1hVHl6ls1o3jeriGdiqCF8T9NZDbVKxGXp6WxwfotwPSAy3p3Cp7JuAAsTEXBMlej8e8d/3L46og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH7PR12MB7455.namprd12.prod.outlook.com (2603:10b6:510:20e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Wed, 12 Jun
 2024 11:47:00 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%4]) with mapi id 15.20.7633.036; Wed, 12 Jun 2024
 11:47:00 +0000
Date: Wed, 12 Jun 2024 08:46:58 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Daniel Mentz <danielmentz@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Do not zero the strtab twice
Message-ID: <20240612114658.GV19897@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <1-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <CAE2F3rBeE8gpjF-oU=g9i81bhrpeBiSNmVQ0tk+5BFk-LDMFow@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE2F3rBeE8gpjF-oU=g9i81bhrpeBiSNmVQ0tk+5BFk-LDMFow@mail.gmail.com>
X-ClientProxiedBy: MN2PR17CA0024.namprd17.prod.outlook.com
 (2603:10b6:208:15e::37) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH7PR12MB7455:EE_
X-MS-Office365-Filtering-Correlation-Id: 74194892-163a-4747-2e15-08dc8ad55ef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|1800799016|366008|376006|7416006;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LLg+e7yyAmsTBbqb4wbTCNHFA3rftS1UOI5OmRIoymbusutkFE36zcsWU6SS?=
 =?us-ascii?Q?DzQl12QUjYGINwD0atJ1z0jWbRTfz/y9DABlclO73iIj4iAPilXIQgjncLvu?=
 =?us-ascii?Q?CpU1BjgiVvEDabkxH7f3GxN36CPqOXx1bcvEegFIry95QBbxCvw16IPwNvKb?=
 =?us-ascii?Q?sLR1KXrgfUAWpJf7TS7Uh7KbU5R6BVYYGDvcN1YZ3VbLoq0FcXZLee5KQSpm?=
 =?us-ascii?Q?yyVHggrguAOAELiqPja+v8m94t+7jueDH/ZrXtiFCEcET0ZBDilF/quit01d?=
 =?us-ascii?Q?OOeKaemQydhw15AeP6W+RUTeHh1zmZNwT28Ixw5HS7gDvYvUFNEUq/XKslCC?=
 =?us-ascii?Q?ouhTQdCObWdBa+BCJ4ykSRXeiX5jR1CWQQQ0v/OT+yv+ceRMicVLIdJMD+Bp?=
 =?us-ascii?Q?/3bnftevELS2Jo/itbPVPmyrED2Q4tDkcYHZs4Rp25wVHXiA0Rm3eIslRbds?=
 =?us-ascii?Q?uepvTns2S08Zu9suA4MFRRdCElrSYtyUjayDyAA6lMERURk3Uczc46KeBobh?=
 =?us-ascii?Q?tezkrpTm6U51zCdgXrfiLZ6w4N0fxscN1KeWSIkxVTLUI+OtV71d5B9iT0sg?=
 =?us-ascii?Q?sa0hlfDxBPuWKXi4N519+OUuG6S3Sa42pTFO8payiNuMQWh+DlbhgeN67XL+?=
 =?us-ascii?Q?ytUktmqlYNtI5pn1ByG0IKJ4Abv688aeA4hog9tB/Ru0S70TxgYOI7fFE9z9?=
 =?us-ascii?Q?SfRlbQVZ49hg18cXgjAdiz1ufCJwJQ/cMXSk/J7g+7/cSPT0Pj1moC+nXzmP?=
 =?us-ascii?Q?7Yg7d+SUoz+fiiT9MrQsn4uvV0Xuyyu2uALH2manlffITP6T6SAqvzO5mg9v?=
 =?us-ascii?Q?gYHKnK8PxNp9rdXe7hm5bjyt/EHIyO22/Ck7u2U/imOjUSC1OzRWQ/vA6b/4?=
 =?us-ascii?Q?UUup7+vpouyKXDJrhC86CZn9bjVT9YLPYNubMHAi6TrmTtz5PnVjxW5QsG66?=
 =?us-ascii?Q?H0VSgQHocz0x6KgGy8BJNX9gV+Pd8ysqfhc5Q9iDN1pHUGAy2cs++vP2KMRn?=
 =?us-ascii?Q?wfQ+vPUCVi/3B3aw985x11cJCOPvo36aFz3sM7JDg4+BUIggyqIepTnMibG0?=
 =?us-ascii?Q?BNa4ed5V/Px2Ro+qsQK23/99wH2eroyKnI9uwSsR03cO8+CE2SyxuVhY+e0c?=
 =?us-ascii?Q?pMMQJ2vT3YTmGGVcAI4bXDtGDyAkdydtys2CaStGStScZnOWOIQTjlkzxFpQ?=
 =?us-ascii?Q?zd0fywE5nKHQ4Myg5U6dNsRfbC+Hu5NIWpeDmJCYiHzxVBMK7vxTM1nU2GK5?=
 =?us-ascii?Q?DtN4Jou2+dVi8Rb4jvizBtVfp65wfzEO9bjeP8HS7X+UM+6m0iqlqbc8ESBY?=
 =?us-ascii?Q?8piaOBkvtbZ+saTJBGGYwgUh?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(1800799016)(366008)(376006)(7416006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?90fKpW5SYclq93IZ7WNH5VuN6L8z0yw2Rvs1+wMgdtTvUaosR/ChDZhhQwbD?=
 =?us-ascii?Q?hIK2K/TOmUnyEBb8PCNZShiXwOdYge9C73tMFy7EypfYfUV+v628gvFYounX?=
 =?us-ascii?Q?8BEXjCY+kODSCPTrCa3tOh8G78lUG1NrX6g2ChCmcbxOkdLKRfw3XEshnYp9?=
 =?us-ascii?Q?amAuQNbH50YSWurwHZxOhHuJdxHyLXE637c69aXJi+Nl0o3LvsXrGjuVCe5f?=
 =?us-ascii?Q?0EQjYrWcA8vR3UwuhJPMnR26X2GkYWONdsxyN71FGxt3uif6Xj1mM52nF9T/?=
 =?us-ascii?Q?n9HFRMN+x8IaxSyvuciGm7LNJPLxwXnToQjfv+6aPTee/QoqRRRxV6ydkJFl?=
 =?us-ascii?Q?JGA2j8E/dZ+iy28Sagk14wblkLbK7ivof0DX1/29s162fkPod43OwfKghBiA?=
 =?us-ascii?Q?6IyCsinRiJZmeV2OdS7vpXrPqKcnYHwZrwvxNuLnSrq1KkxFYY6p3zgoftAL?=
 =?us-ascii?Q?i7QrgAfIdHs6Ma5QvebfyqXQ1AvAE+TryCx7LvNcCjXRRRfyQ6vEV2Ealx7M?=
 =?us-ascii?Q?MIqH5pP/OItyz8cZVYDjD9Mwo9OrsGXxPevo7fZ+3Me4w5SxuyCVwSuciPeO?=
 =?us-ascii?Q?7Ft56K4hnG2yp7R3ubYDFLPZ8ITDkqJCnZHb0IeFx9R8MC7Li9vBNvVuMCy3?=
 =?us-ascii?Q?HBtzfqRZuk9q8N/OoKZ7yZYz9gNyDHckitnrOczcrxwriaZeBJROIM+XvpW0?=
 =?us-ascii?Q?BjswmYH6F/HtpJPL8tkWwLyTx13uhkdvEq1Uy0rDRLXNSLfEmNgPRNeXf5W9?=
 =?us-ascii?Q?XCqv8PM0oS5gTIvqiUEqghq+qEoPPv9HUfU/eF1oWnRNDntVgfyxRgYWpNVG?=
 =?us-ascii?Q?RVHt65M79UlKYBJe421knPiR24v7PcD8hQldZfMafmP75aogys2M1G2xnw4S?=
 =?us-ascii?Q?7JI1zO4EhkwKvjjuFJFuQ0dxDzGo6ifWgJWJi4OAToZeRO/k/ztWcFwT0/M1?=
 =?us-ascii?Q?NBf1WNtUa+YG9pqZp7Si5FC3g4HdUL4GVaHxhnruV5VsYLFixUIWOIHjMXrN?=
 =?us-ascii?Q?1gPpF2MwQy9eYkGrK9bir1+J0POE7hQsxh4O8vcrygmIuaciRqlHS8fuioRb?=
 =?us-ascii?Q?/cd9FPAaITbzxm3bMmL4PXfs5UVgc9UdfPAXzhMmhKd59kiAx30xdvSZxpJ1?=
 =?us-ascii?Q?aM/I8999LL1MU+VcVgQIfz7yfEoCEn8m1vVJ1oUkgy4/mBOzbdG9f3VXkJIW?=
 =?us-ascii?Q?f9rpHNpJUz0xWhrJS2fSz9MrE0s9pIzEpw4UlfnBIjtflV17GBwXx4Oao2CV?=
 =?us-ascii?Q?RXubS+nRjUgxSj8gJzB+fckxnDzkSeIZqvnOezbS+mq+1DtGmaB6s/n4fAuN?=
 =?us-ascii?Q?RLzdGRrpUCex/rNNdMMIiFhIvm5L84o4IHVSxmyySn3EfGcwU6fjeQNTqaYb?=
 =?us-ascii?Q?YVfulOW57uUJ2Ld+f7zs5zu6oJBNWZPsxRqLes4OtQv4MqqD+SDnAEwRA8XH?=
 =?us-ascii?Q?xXDFdOtuQaRy7HBBcK/JgI2M130ebvd4jixpwdFvh6isIVoBdUvyJ+9Zb+7M?=
 =?us-ascii?Q?lSwDV/7Ieq7Qr6UaXBPGWpFGHnEBVLHjJ8715X2T0yd0MGyjhG7T2XgUU1o1?=
 =?us-ascii?Q?P2S5fp0pVUOirNuy/4pnyJkzNFZEN3guytGTxRRr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74194892-163a-4747-2e15-08dc8ad55ef9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2024 11:47:00.7141
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ysRFR2McilgcSDDxil4nuNWfn8ApdD5fd6bIrqwqZ9c+OGnIKixz9fOTbhMaRIGr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7455

On Tue, Jun 11, 2024 at 04:52:57PM -0700, Daniel Mentz wrote:

> I thought there was a guideline around not printing error messages on
> certain allocation failures because there'll be a generic OOM message
> that'll get printed. 

Oops, right, C&P mistake. I removed it.

> Also, this driver never prints an error message
> when devm_kcalloc or devm_kzalloc fails, only on dmam_alloc_coherent
> failures.

dma_alloc_coherent generates the same dump as kzalloc on ENOMEM, I
guessed the intention was to add extra logging on the high order
allocations, but this allocation is larger than the dma one and
doesn't get a print so <shrug>

I was tempted to remove those prints too..

Thanks,
Jason
