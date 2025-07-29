Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD45280CCE;
	Tue, 29 Jul 2025 23:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753830800; cv=fail; b=cTW5DKQ51HKuOiWGcb/bo+cZRnw+B7psZduHLMj3zYvUtafl3u5aX3/SSLPNLv2pjyl/T1D7BEC9Qfnf8lBvzk6PUOdDVhjIEqfJgwJu8qzThVn9Bspdw8/EEjVsGp3wYj7KTlkbb0X1DyhP4x/pGxrruUdf+ITvgsuJiEm08cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753830800; c=relaxed/simple;
	bh=AeEEgZgzCBeQaG34EryOl/nwJyxH24rdMZ4M/poDi5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CWk7edRXk6QLPjcaThAxwKNunIshHXP/HgpyefIvS7aBFsvM0f6niO+iKd3x5/gUP0QsjtkueUgtiOJt3etmrRIZjb46t9nTQsbw0m/3mpqA/42tZr7h6JCkxpvPyn8MwTw7pA5fSmREWl+DE51LkyN6vr5gjGIeZ+VFjf+7U5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=MRJNkkVX; arc=fail smtp.client-ip=40.107.220.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="MRJNkkVX"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EjNER8jmLa8ElIkRcbtRwPdfOqVDJOg8eiLO/CHYfTyP3gmTOHWSxcAdgnrx0LG+byxlhA2LYX7OqHXCPXBHWRh1b3NBdhPKHIq4x2lF403x/1Z7uEUT4WvURjSUhbRSGVuvx2Lpxao00c6+mK7F4G2vEmRQ64TcGPViNpeeq2f7rd8bEWShgy2ktpS+OCTGhEFGpkSP35LReukTkP9KYIJ82Fz/qgKd2bPH7O9v/gy9jwlluNoNlvoSNRFeeV4UwMozFiStBSsS/YG5nwJXUyde9fgrHzn4qtJduUWQjAFN1RSF1XDZ7xhAYpy+UAGWOBx57O035hWdaiIaWf7lcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vbPgc72E0e0WKDYGJA1+X4/YARUd5oOXBt0DoHnhNHA=;
 b=mBPx8JKXFXoHHdORNr+69nfWt65wX3aNMh4FUo/4QaXVeqsQv5dzzR3qqRb1QsF23SM1HnjDjvBKWq9ZoIa6llcuGMKed/YNXiAUMf7JhfHkMuFjHhf1HiwjFSPHnv1ycdhd7E4b6WSRXGgapaFNwAgWpYd1moFQGDVqZOA3zFPcGVUwrIlTmB3SH+TYUJ8/qkFx4bsH+ZGbMcTQo4c8CQYhBStQ5ThS2sej1HgMcPmErqRd60Co0qUuZ5cvoSSc+DJ8nL7+5wt1BdJOKgUDgeKY8QL+4OGf4AGQZAOSXU+/sv0FSER0skksM1YPH4yZ+uglHNwyXFbGdyFzqie/Dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vbPgc72E0e0WKDYGJA1+X4/YARUd5oOXBt0DoHnhNHA=;
 b=MRJNkkVXHIlrIvpCHq2y/uAqx0I4h31PKtSoPFOvIa7OZ/+lHr2S3FSwr2x/P8EXNLgPWCJXWiNEeScTf1CVY8nKaCIUvR6YM0d9q10o+vgv8rpSlWHyvSE9yiRuoycQ5VnRzgLu7LO5/4oJZEoIk/2k5pWOSbuuFDEICma4pXf3N3doVAcF1T0tYezNay54ZmbEfz7wfXFnVsFJrX3nHOQF4zqK8sZKkBpYh5hzICGS4duGLKmj5byjGZrmPigrDxEmhBQ3GBM8JOeJx2Indn5lbIs0cG+eJX3jslKLepGpKgupkawDTP7oJDXXVsYQ0plvF6SJf8XVQcgHWubeJw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by MN0PR12MB5978.namprd12.prod.outlook.com (2603:10b6:208:37d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Tue, 29 Jul
 2025 23:13:16 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%7]) with mapi id 15.20.8964.026; Tue, 29 Jul 2025
 23:13:16 +0000
Date: Tue, 29 Jul 2025 20:13:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Kevin Tian <kevin.tian@intel.com>,
	patches@lists.linux.dev, Tina Zhang <tina.zhang@intel.com>,
	Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 7/9] iommupt/x86: Support SW bits and permit
 PT_FEAT_DMA_INCOHERENT
Message-ID: <20250729231314.GE82395@nvidia.com>
References: <7-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <158774a0-824f-42a7-93c9-fb1e0d258cc7@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158774a0-824f-42a7-93c9-fb1e0d258cc7@linux.intel.com>
X-ClientProxiedBy: YT2PR01CA0009.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::14) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|MN0PR12MB5978:EE_
X-MS-Office365-Filtering-Correlation-Id: b2b26ab5-98dc-4a3f-2090-08ddcef57fd2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0/hLqfs2dAk2U2B9y0hU2L3D8eYyc7bXQ4wigjlfJ/sDoVcxiHoWHCvBVG2H?=
 =?us-ascii?Q?iH3GtAMLLRYZJg+V440tuW/+aOUJ57KImZEtGiUzYps/iebRh1U5lXVDDejW?=
 =?us-ascii?Q?ITWwu6ob8DtgM9JG2IWj222tOY748+sa0Ufm3jNuiFRGoGscXDg+IqYdbeQo?=
 =?us-ascii?Q?xAk6GRyX1ys50cEV5HNlbkcUjCeZicaoewoqd3ZxSFijyrqVcm5hjW7goZXb?=
 =?us-ascii?Q?FEOi7xnhmzQHpoxdKD0+R0mKNyHekCqoaSdLV5dbl0qTvmwrA3RKrAiG9/aR?=
 =?us-ascii?Q?RyLKk1lN2/Ro/3j4Fw85p/nIr50o1RbyGQfuJ7AhmWMIPBcYrI/l1MLEZkyV?=
 =?us-ascii?Q?SIeivIeam9GqpzQUwZlD2DvVT3T8+MI9sdZ17OUgSgsuifRdZ9FF+tYhGCVA?=
 =?us-ascii?Q?uIDcDorsJwW42uDV9YW2uthxnxAaBfwAcRuW/og6OHkWITtK7DoD85Nv3orI?=
 =?us-ascii?Q?VenDW0YBa1Y07rw/GIhurWVMR0crS+s4yV4R4MmY5eK7PDqxY179lTorgMuK?=
 =?us-ascii?Q?96prjtimclsX9gVERRu/BbQj/ga9RU4O3hnfu6pr49ZH6yrpdAYf32HmG5Ju?=
 =?us-ascii?Q?QR2DMSu9pIteGJFYYIhNw3Nc09hQ3fILA9r3Pj7rJBLpLx5tU2bpJ84/X5x/?=
 =?us-ascii?Q?uC8LmFpO4Eyir+5EgQS8OnqQO2wnJLSaZ558TahK3DUsgS4AXIUBd0iu/kfb?=
 =?us-ascii?Q?X6rUNgzo2i9sllEjLYwSt16TezApeR5HMmBv0Tryn9HTLlULeheCRPL7Wbry?=
 =?us-ascii?Q?OUh1OZLnwDnxMESYzuyx2KRZsshqK+Dz4Kn8OJcyfC4KeEoiPuhUbQFZshN2?=
 =?us-ascii?Q?szO+0aH4hBfTZGFlpZFgn39S22cxRtMkrMrJ8CT/PIZnOKlnpLNLKTo0dDug?=
 =?us-ascii?Q?JiSY+D5ako44gK6BSpB09heb8sqcG5RHGycAJYk3sVihswk/LRunmfeMwvil?=
 =?us-ascii?Q?RXTrDyFNDZ8CYpl+LAXWFzMpiMvQUyZoT8rZKqVRBgQYEphXrusrKTtY6J1h?=
 =?us-ascii?Q?C/PwxwUry7yrzOw/6c+uxz5GHsswniTHO3JpUcxp9AlRnh/ALJ4Qq/JBezkI?=
 =?us-ascii?Q?0+L7F1lMBuNKYP/JAbLNufyQ/SrWxMJMhSW8QArQXTsDLkNKThUE250tll9f?=
 =?us-ascii?Q?edaWOGiQHUTsGyev8sIx8pZY4TQrHON+kB0hDWWJKuIqaTP0j6k1p0HlWNJ2?=
 =?us-ascii?Q?Qkd+ED6GmuCqy01wWZwD5xBg8jeBJElCVl4kh/gdX3xB3LdHm/PsgYxwl1l3?=
 =?us-ascii?Q?7lcpI1QQMDheDgV979yyqxmPnVNNq0nhJwLZ0OB3bxVwvHJ508mg5fxYrAoT?=
 =?us-ascii?Q?8NGAZbwu5R/vODosamliFz7/Ivp+F5JFun9JThNnHdVtzJEPSn6I0vgc0VB1?=
 =?us-ascii?Q?oOkJMDyxckFWUOuzemouFZwtQR18zIpTslElDt6ZIrD1PXCTxjkSjlt+MpbZ?=
 =?us-ascii?Q?sj8Uv14c1yc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4zl0fkHljM9fQtCK/HX4qUQR2ToFChkH+RrlWjnqkP6D9Mk9GAHFjl5hocng?=
 =?us-ascii?Q?yb4cdXjPx1Vb/MxDMygi1G+pyXtZaBbUFWqwo5vopPG4olbzY2BcLkBT/BlA?=
 =?us-ascii?Q?AV4aqhXye85/8RQf5uE8TRaDYsqI6P0RKwfOAFamF2YobmSVs16/eAnzd+SM?=
 =?us-ascii?Q?gDVLo5S4zy40JwF4tUmFvP8x3WmZHz6me+04dtcVqrmtf+BQP6AKfz00LmTW?=
 =?us-ascii?Q?9jyczm5UZbVgAEVTsdqX2ci9cNLClv6VeM6LNWIOC9k34V/dGnsAlf+2ubRt?=
 =?us-ascii?Q?lbVXoJ7v/d3F8G1WTBdVcou4BDjw3oRK5s2hsiISgIuYw39LxdRHZY/d81wH?=
 =?us-ascii?Q?lJWILltM3bt9TsCjdNxhnEnkQCR2mJrDttlkJYuQDURrbkjC8gOBsGYGoJ/0?=
 =?us-ascii?Q?QjPJ55qo6FkvQuf/TuSCd7kp1MSi8jsWscfu0bqcAwo4loMGifayRg7neIWf?=
 =?us-ascii?Q?rBUujLg99teH3p/9PMKIV9iH4kYe7YyusECa+FTdwg+Yh4ciIg8fAVxhUcSF?=
 =?us-ascii?Q?Y8iWmjG00l1vRTUbzUPaKIsp631L/tQmdPw22UHgp+mYATgL0ulRiMUMgzPJ?=
 =?us-ascii?Q?3g3OfQw0ubTiwnbk2/+F/C2w4dn1oAUQmj4BfU9wA3B51TE+CXeHqheD5b0J?=
 =?us-ascii?Q?aRBcqXW8NYZOhl2R28lSrXh7gD0ajBSDkVhASkvyjdxlqNKYphPBq2D1UCPi?=
 =?us-ascii?Q?sAXJp8mJpLRy/iPxP+KOEs1ngzV0punxbmbWt0NmB3qxR7GJryvjCmnmGUO9?=
 =?us-ascii?Q?EvhlW8Ab1keuZ2CiYFM3osSa41Qe7bb3ImJn9HebkSATcxpP/s69k4qGy6uU?=
 =?us-ascii?Q?tCKSBaY1v7+26mPrUBR8s5Y+Ho0YkwNOKnlO8TFf8w70PBMft1rqHy3WNql3?=
 =?us-ascii?Q?nOU6aXQyAix6P4n5k3jg3hkOqhlj7idY4dYQN2dyhl2lY8LKtWEI1b6zaWX6?=
 =?us-ascii?Q?xFvDaBr1+POIIXSL3nXmcBz0v5WMyJZq2jQ5m4CFFNnvnR6Kb8zUWbjNJSfB?=
 =?us-ascii?Q?j6NGP/4di7E0kLzzqviEV9wEvM9ltAbu0UmtMmF5EUM81pEoM3WDt+DpeTT9?=
 =?us-ascii?Q?/KS2Lys37i8/Y4W4Y8xUR6wHSEsB+axH/Np5kdIJv+njBcj1tYBCqqlsd4oG?=
 =?us-ascii?Q?3iLO6mUGK/MhE5HJvTebTKhUS1MznIlbcoH7SVlz2eENKvT73vLVTEBdTpbv?=
 =?us-ascii?Q?AUNmstt1YcmfxE5QmRJRx9b602Ri5d+822rUiXz/PfiGLjrQqEgdwrfDoftt?=
 =?us-ascii?Q?JxZ/Ex2RiRQ7k3vyvP2/mvWAbuFuhMQOSihxjA93Kw16xFLgkF9/qNjdnFMa?=
 =?us-ascii?Q?5fBoQpkKNvQzhhgD9qksNT/j/3/9py91XTApporXBVXh5a1Ke1HwYLvm3XvX?=
 =?us-ascii?Q?qBcqs0XzGeY0Rg9qGc4RFRKdWlmrAu0a89cAx/QJQeKuYWjbnBLzgm+N/7cZ?=
 =?us-ascii?Q?X68iq66vXFq5H9g1dRiPzJFTspTgDSl69lU8IwIbsowFp4dw706XCT7oedtf?=
 =?us-ascii?Q?PiSEcodCWZsbfGxwqkBPwlKMqSII6vftOfUQpLKOCH1GrsPVDiQAA/Mv/szs?=
 =?us-ascii?Q?Ogo/fB+pAgxrcZs4Lfk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2b26ab5-98dc-4a3f-2090-08ddcef57fd2
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2025 23:13:16.6111
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mQfBn+6X0DFg39W/HvhygpzMTnDJoar7Gh/urg6x1V60OU4+/cWn/D/Ja7wToEBj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5978

On Tue, Jul 22, 2025 at 01:17:59PM +0800, Baolu Lu wrote:
> > +static inline u64 x86_64_pt_sw_bit(unsigned int bitnr)
> > +{
> > +	/* Bits marked Ignored/AVL in the specification */
> > +	switch (bitnr) {
> > +	case 0:
> > +		return BIT(9);
> > +	case 1:
> > +		return BIT(11);
> > +	case 2 ... 12:
> > +		return BIT_ULL((bitnr - 2) + 52);
> 
> Just out of curiosity, why bit 63 can't be used as the sw bit?

It is not ignored, but used for XD/NX:

	X86_64_FMT_XD = BIT_ULL(63),

Which should comes out for ATS replies.

The existing drivers didn't wire it up, so I left it alone as well,
but the XD should be linked to IOMMU_NOEXEC. There are some little
things like this we can evaluate after. The idea here is to try hard
to make no change to the drivers existing behavior.

Thanks,
Jason
