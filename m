Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013062.outbound.protection.outlook.com [40.93.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00288E571;
	Thu,  6 Nov 2025 00:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762388668; cv=fail; b=ne+knKM19DozUU70VQCDTSFQXreksIhDP3JXrbj7gH/J7EWxMnjV6zBVZCicaPNI15wUHlbSQJmFHA7yGrt9zXgjDvVTNiracSeA2JF1PJh8bdO5+zzKcsrATegrfaJNOzYI7mpISSO2LEqpkOFRqTUI7xeaOujt5kNYswcaOrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762388668; c=relaxed/simple;
	bh=mUcJGWuSpI7L9Vr7z6QLcxHaCMs2D6JNuNOgM9jWRKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Q8Az5Jy6JEALh2b6XFLzqANk//DkMzE++EPMmCZ0KtLTH6iCz6KvHig80O6cPmbK/mpCibD1NOpqcoPUMbOnH8uvTULroYho600zlSoY2TPMD6vi621o079d+7dmOgDbMRlE0qRLMbjOYSvMBOm9JOCdpIMdHo5pMCZRbnwzyyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=FtYYlKcl; arc=fail smtp.client-ip=40.93.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="FtYYlKcl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1YpwURj6xZ2+SN1wyT4g4B+1Ck6dn7EZfDQZnSJtkhnE3a/QhMsoPVR7fXaOZztOB3Sup42VTCcLvPzgNnARoy+C/+R3QTlbKN8+XjU8P1lMuENlJIrny8lJd+AyDZIqGcp8rtKZMgUWhSrAkRWJIzZmfM6qRk6b4hieHlEjAiG2zQSToyS8EJHM8XP8ys4+riEMnfH0JNFC77su/lKGXe/leh7b0UqOT7Jl3Q/v4d3MSDAChP1tJlNN3zFUBfw755qxGc2LFMUK5H47zna1w4rGd2Hym+ZPk0sOb8i6TKQIXCbioFHv3pONJrhtD9SpxSrcopUHDBKySkekWsQFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1IJBO1fVVn1gCPKSLcmGnLQL52Ax8BZTpRhRuLXfNpY=;
 b=A2dnxb7SGMLQ/wTaGtelNlZGGONVj5Ek1oPH4SutoLRCnfCP0++vMxD1E1AbZFSnIAMRpJ8eSV4kVrgt/Sd1XH2dVM/KNmHS4/zUHOCbuk6KL7TQTGcGMsgPB1+uMp0qvYk86uVsBCILHID5p+nFPKL/zuiMg9oivSvrdauS9Nsk8jSNeJpPg3MAkATNg8t7TztIwLkwc/KnRmWWjCtv4y8VsyIarYetZFNVqdOyiGPhsW6644urkg1Afu11sktbWoQBUefGBpinLtGdewb/fbAL4lHFmbqpayIMTZD+qqLFmFpISSyXByWjmohROQUHHc7VW5FuCVshcpucLPyQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IJBO1fVVn1gCPKSLcmGnLQL52Ax8BZTpRhRuLXfNpY=;
 b=FtYYlKcli0F/0t6ZPex8lpqsyew345fIT26EAqfaJtumfxO2H4cNSmIlStqpxJf+UOjHgrj9gpjevHo9jDLYacENy4/yMHdKHQsNEvBIHFlHxPbTL7FO7/CuspF9cHo7iLxz+m79zz1o8sHd9ulUGzsL4hZWTe5YL/qV/QwQbr7IM6kY1Jodow441jVcy9YLydDLYTMeSMO108vN7LZ0OmFtEDTc43XlCyyNk74m/kaCes1YFGPJ5QIxjkHBlmkxDaSOp9XUcwp7N22WJsLsykuH6YoS0fQkxnTtSWck/i5sN3zQeZ3+b709FB3dW5LmZfB8tbNPl7F8l5KuyVwTLA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by PH7PR12MB6491.namprd12.prod.outlook.com (2603:10b6:510:1f4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.7; Thu, 6 Nov
 2025 00:24:22 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9298.006; Thu, 6 Nov 2025
 00:24:22 +0000
Date: Wed, 5 Nov 2025 20:24:21 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Emil Renner Berthing <emil.renner.berthing@canonical.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Joerg Roedel <joro@8bytes.org>, Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>, iommu@lists.linux.dev,
	linux-riscv@lists.infradead.org, lihangjing@bytedance.com,
	Xu Lu <luxu.kernel@bytedance.com>, patches@lists.linux.dev,
	xieyongji@bytedance.com
Subject: Re: [PATCH 1/5] iommupt: Add the RISC-V page table format
Message-ID: <20251106002421.GY1537560@nvidia.com>
References: <1-v1-d3317b0ee398+50-iommu_pt_riscv_jgg@nvidia.com>
 <CAJM55Z8SyipTBG8G2wU2euvJhzcjJDp4B8fjm2Djwoonz8xf-g@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJM55Z8SyipTBG8G2wU2euvJhzcjJDp4B8fjm2Djwoonz8xf-g@mail.gmail.com>
X-ClientProxiedBy: BL1PR13CA0254.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::19) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|PH7PR12MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 170fe924-09f0-4f40-898c-08de1ccad546
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KsyDSr6vMzh4gjfr9TVt3dyIeYAAHLQT8Yk+JJ4Fz/jpSg7xATZmaL84WsDW?=
 =?us-ascii?Q?iAhOuPcLqzUY+KCBddRjqbgoa8SRgMVrtYLNY0EHQj+IMjVf1WKVSfD+aYJ2?=
 =?us-ascii?Q?/NFJsinBrwkKR312sf0sO7IASv4sLwYVFc/aZ3kIfcsWtuoMsdsCh2TeKxfK?=
 =?us-ascii?Q?SVVb0OZ06FnouE6Ei0E+3bvxwXJB1gxjmfasd704igFq3Atz4ooNjwgDQTM/?=
 =?us-ascii?Q?Mt0wTTEGDYv5+mID7dPIM1UeX9yIJneuOL3Gi3YH94FV2OoNFRgGPuNPU9wj?=
 =?us-ascii?Q?N8CGgracxB6ilmih+xryZc3XnczA+q8ur0JLBgqFFmUnCzby+LJTYifQQQW0?=
 =?us-ascii?Q?lGP3ea17kzA1U81lRhwJv+2iZIOX9chexgTl/tr8Urw67S0gqafle5So3jGr?=
 =?us-ascii?Q?wQ9eFdU18a6ERExB7KP+I7mcY+xJ2X4jctfehSisQIDFCc1g8Gc/LRCfG6DN?=
 =?us-ascii?Q?GzHeuOvK7vJcPsumdRWhGoyNAI5xLabgghCqzTgJKetuO7uyOYUhw8EKH1Bs?=
 =?us-ascii?Q?T0rB4Cwwf7/Y3Q0Lxu8CWsZrCZJoruWmqdtls+Yj4yD4+gj1XavgEbm+Wr+d?=
 =?us-ascii?Q?n72UPPDkA7JNupKApisstISJKSqwwOyXS5bAxyxGm0Gim3knNISB6bJ/0AJq?=
 =?us-ascii?Q?5BgzBLCin74fKMI2uQVdhbfeoy6mJjuDrN97BM0E5m5MAAZblpT9BOyknc7S?=
 =?us-ascii?Q?A/voOsYs6lvuPjEFGhOgBWK0QG4JAAIcWCxHM5qe2u13DD9h3u2qObe3ZwWQ?=
 =?us-ascii?Q?00+8vxwiHrAOFkCgj9rB+VouMTq/SZywOtQVZTi8jRiiGdgxOTVdgwobtktH?=
 =?us-ascii?Q?jGnLZf330X7Whs6S/OCTDXROJrayKjJuJXXAJgcoMIjwgpMuANeE9H2KMGPD?=
 =?us-ascii?Q?bfH04PAdpi5cRBhX+bN7G6C/fnde7kpkq47KspEaMd/mLqNYfnLmNEWHoXyJ?=
 =?us-ascii?Q?z3dj16gcxBAeu5IhPZB/SUrH3tF/dP4VdGSw7VBtu3d5YUY6iB+82xvODMfv?=
 =?us-ascii?Q?/6gOZW/pvl3ZQMylj5wywJf+qKhzzie0XfBXcE4u0Xp8v0PPzEGMdoDVWGBE?=
 =?us-ascii?Q?OkXe9S8raFIDvNfU1SA//scj/VuJ5lEPWABp65N41SbMISOrGTWMhUhc65u6?=
 =?us-ascii?Q?h5muyfuPsyLTeBiyk3gq3ZLz4t3sOWj42VoIAPTSlaTc+OzMmrGUFBDQAUz+?=
 =?us-ascii?Q?en6rlLLdjwjEHc7r9ySyooQ48ObkIwdFz4Mkzd71raLvupIlf7Q9bFc8cFWA?=
 =?us-ascii?Q?c7yexAEWj8TcFKUJBDrk8KxdO8/8YLFHSkQ5JPWLCe194+QLynfhW4h8iPr+?=
 =?us-ascii?Q?9U7BUMP/VNPEYcTl6SSDsXbuMS3i7V5Lg90rLqwfccnQmUqowz7qe2Qdo+8F?=
 =?us-ascii?Q?cChH1SvvTSh8rSXCB+gX5a1fYCg5NLxYONXO9c8iZpNwJM1ZG8jCQDuHhRI1?=
 =?us-ascii?Q?8OOi4/OCcaMkNTB8qr4PYo4jKIpFLQUG?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pbWsnVzPzHiOaKK/hAkoyv5c/2NfIAiE3lhg5dugqP8xBNnloNbkjXqXLcqj?=
 =?us-ascii?Q?l2yMfOWcOCgN1WKf12fs9Z2yOMcudp/k4HO4eQo8PTdCa5jbwk2BR5f4ACS9?=
 =?us-ascii?Q?fWpQ0VhJo5zrHXlY/bXzJ8uitEPa0/DeQlEHO4HT/q4R5aXZ9qlVG08xwSlq?=
 =?us-ascii?Q?f7po0QLi4PDpH16k0329SKuh7ygCNV26yrbQIzOw/Vd4ERvQsp9i+SFarGP4?=
 =?us-ascii?Q?n17JGmxdy2B1/CBm8EDT4mRa2UN8BKuURJpnUZ4LMKw0/aRUg7/xV9TD3DJ7?=
 =?us-ascii?Q?dyQ9Nu389XwcFz42an4g7nVlz6JsW+Oz9/L22hcZoWyvVezb52bX4kJ9FspH?=
 =?us-ascii?Q?Y4rBkCepqXVZAcanrFZ4mrQVjEln6VVBLg7y7q5yynCTG2sbH4ywzHQMqQwp?=
 =?us-ascii?Q?x6NRPjPJlPk6195NLKOnJtFZy8VVUm5HfrRCasRHTVJxmZpWnhNMMCLqzUyP?=
 =?us-ascii?Q?tCOs5kU+4VYRh4V5FGpNjpSmEo43XS5uMeuweEBvyvVFCo+fuqLyqUIM77uM?=
 =?us-ascii?Q?BX9A7LPlv/BYPyqWmghMLjBH8NJmjSE6IoOQvKSmm1n0VUBfzLSoWi+puW2K?=
 =?us-ascii?Q?STKbf1pTIh9mUbB30TxHC0lJOaQ8JaVOCgpgyTYtUgeq84jBtDwhoqbU2mBG?=
 =?us-ascii?Q?eD4UknfKrXmeZgaNcgmBGCwRLmOxAfraL5cf4bb5o2U6IGKmr+DOHx+AD029?=
 =?us-ascii?Q?2xAp50T12lmMqld0kf94SRKigSWM8fg7x7zjwZ/m+gie3PjXg9EC+eRR1ESZ?=
 =?us-ascii?Q?jmc+4G1ozaqf7StOmT9PG8sJ0AiXEE/Vb9k3Pv59G/vAN607cBLemewCIqHc?=
 =?us-ascii?Q?rvK7gyJYYH9tjQI7t6cQoTyrL9BGSXZ5k7Q+QOFLhAz9TvUgKnyfTEYnQcGP?=
 =?us-ascii?Q?TjcMwEp6LqVz6kUeur8MWa8dv2AKQLqC44TYUws94a26IAxWPsIngBcY2Ffb?=
 =?us-ascii?Q?F05/CsGT5ZNsrFCv3O9XpGaR7/1Lviqdk9zjgnsTdk6PvunHSCmiVPTGh1kZ?=
 =?us-ascii?Q?1ATA/MT4dATLTifmE6/z2uq/AaczlwY6+voGBQU/mS8dIfv3TzODxMN1iU6r?=
 =?us-ascii?Q?LsvE51sVC9WGMPd/uQHFMgDb2aP/e1Prl4EHgnLG7yS+1j2UDpGwEvrjc2m6?=
 =?us-ascii?Q?7bauneIquUjg4V87Isb8A7Lv7UJJO2akpqkwYarn6WlLmAeiBhdIWWSh/Zsc?=
 =?us-ascii?Q?4QGTtuPmSAr90FKeazoFPuyeltSnXr16tP8YPaRRvhIpJ1kh/RwFV762wsZR?=
 =?us-ascii?Q?7XvIFAatMJB0CbX3/QsuxZJVaUn6Eb3oLeRi4DemECd8iCkn/R6ifLH4hrKr?=
 =?us-ascii?Q?vIR5r6B0mpTP4jXiUAmnh+O6OgFd0TkBmw+5aTxkUDF2fw1WHPyrpps/4Aar?=
 =?us-ascii?Q?Zmw+RJeyJ6aRCni6RvQv+whVU2ZHky2hLOkVGZDxzYl7B6qgiYR6qVVIxque?=
 =?us-ascii?Q?N1fZZHw2YXVcn8hrAzGO7qcFGC7sXLKgKzdgMLTT9pEnqIdLPP0hQMslTnUU?=
 =?us-ascii?Q?MDulJai0n2T9xCZ70zeaK2dNaaWBZ1xT9LMGiNTs1IXXTzfMRQ2pKlRuR+kA?=
 =?us-ascii?Q?jcXtVjd1WrTiLJ4kzjY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 170fe924-09f0-4f40-898c-08de1ccad546
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2025 00:24:22.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DAkVp57ZjrM2s6jBNOM1otPZbm5rtVPSE2yd157I/h6q4vQdMhk0SsQwBr68yk1f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6491

On Wed, Nov 05, 2025 at 08:17:38AM +0900, Emil Renner Berthing wrote:
> Quoting Jason Gunthorpe (2025-11-04 20:00:40)
> > diff --git a/include/linux/generic_pt/common.h b/include/linux/generic_pt/common.h
> > index 96f8a6a7d60e10..10b8250659b98b 100644
> > --- a/include/linux/generic_pt/common.h
> > +++ b/include/linux/generic_pt/common.h
> > @@ -151,6 +151,21 @@ enum {
> >         PT_FEAT_AMDV1_FORCE_COHERENCE,
> >  };
> >
> > +struct pt_riscv_32 {
> > +       struct pt_common common;
> > +};
> > +
> > +struct pt_riscv_64 {
> > +       struct pt_common common;
> > +};
> > +
> > +enum {
> > +       /*
> > +        * Support the 64k contiguous page size following the Svnapot extension.
> > +        */
> > +       PT_FEAT_RSICV_SVNAPOT_64K = PT_FEAT_FMT_START,
> 
> Is RSICV (not RISCV) on purpose?

No it is a typo, I fixed it.

Thanks,
Jason
