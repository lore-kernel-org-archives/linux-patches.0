Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2129.outbound.protection.outlook.com [40.107.94.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0386CDD6;
	Mon, 25 Mar 2024 22:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.129
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711406692; cv=fail; b=XW0d2JQ6ER2v9lHsD87OzzvVNzZRwc9S5OQ3ztx4CZ+ShTiYS8c71bd2jTLQKcx5kyBDuNHVyzjmfXPcu1WY8hleaBkundQg1Yh7z3BI0XuyKcW81n587n7Si3V/GUKws67b/0UjNrUbJOu744VYxIs4IMnSQ0iyFfr1kUVaX8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711406692; c=relaxed/simple;
	bh=oCBbtCEKYjFBd962fH1S3sWPc0qG1C8y2DCUv3kZ7nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=acS0MfWLayelpCyBHdTf45BDIMKyDdXXeIltzc6x8OvKU4Hu2Y/sKBtO0xb4YaTQoiY3ddtr4cbFuOWNPe09ZJMcaROC3NtwZ71Q9tSAUBIftWY6joCYWSjTnX6C5YQNA4XGnduDfMbDAx9pcE1Kg5WQwa5yx6Ebg4k91AfcUzM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZCybK3hC; arc=fail smtp.client-ip=40.107.94.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZCybK3hC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pz1McUXFw97LFvbR7zPUeMZ4hTa0gsu5tHsCfp2qAuT1LBeYd+gaoNKcdtD6efsUAaQ1fj+lc+DnygF+qoi/fiHlTxzVJIGGWXgv7hhez6bq53mmyAnxgddcR8PoPwZGWF0Wf744Pj54CqlQeT7qSCZec+FEGSEaOx8a2W8j28DJIU/LyVAOeXCmAX7MeDtvrwJYWl/nb8BE/WS5tSd4skJZpv0KNvUd+DkfBL+HGXbHKD08xzhWFASg2UCovx9eKprXJAgM4Sv1ufNu2LcR8Wuhhr+7VA0ejwWUtDcC84DCwUVWlRrLtKY9yji+vxCdULwujWnRtdiSdhZ6aj/oyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tC7HwxVm8ooVbKLnniBCD+nEx7vItBqyt9DbA6/O4FQ=;
 b=Wg+s0JAd7Ld5C6xMl+ARtTlixYJ4mgv5k8vPYpB/7IrKNhYar4blJDIFcXTJ5X8OXZdrbiv0pRQUZp5y+DH53okz4vOLWAhMWIgETd3JTnCo/2epXHbK34pfEpXxV1xp8Le/uJOEgtFpFjMje/rLGlDwIP5pcV1uO99bNlzGgcAcm7OAb1tXtLDua62LBryPG3LEQF5iH/0yyxOIUSQX6gfUSI9/6Pp/O4uHb/kMsBsRu6WfW7D0PrtSU9szVBw+MhEYb1lrGm/FG2aK+xIx0KRoeoAkNUOLg/89h0h9CbcFWnuGQrWU038Vn36PoWm0LMPGcvjzqBQmoTeyFTdacQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tC7HwxVm8ooVbKLnniBCD+nEx7vItBqyt9DbA6/O4FQ=;
 b=ZCybK3hC4WIDADdqV8A52+76rNNxx8TVHv3YefdAaLbC8FBm98Sc/9CkI3N1FRZjsQxFMGA8S2pU4JPFjReaXqhJqO4TMsRCkTz6l5G+eYy2wzrEYn2VQJvd5zJOFa/pdMVcox3VXViTEdfw2wXICnHu6Rix4lF8m8aB1hKz1yNGRpX6lu478suipoS571/BtGJdPnYI4lii4bydTTw9LTL8ytoGVOd6Or8Dhd98qpBSSAXnK3mtuZ2WrS4/fFktgzObNC30hDK8M0XOdrEdnkBsfE0d564G5RzavWRkJ7+PpmQihbwvl8TzoBgsRG5UYTrUKaoVKUUnMtLtJPOgjg==
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:44:46 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 22:44:46 +0000
Date: Mon, 25 Mar 2024 19:44:44 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 00/27] Update SMMUv3 to the modern iommu API (part 2/3)
Message-ID: <20240325224444.GG6245@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7bPOtRg9tLSOKT@google.com>
 <20240325143503.GF110546@nvidia.com>
 <ZgHnT8ZoOtzUwYwb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZgHnT8ZoOtzUwYwb@google.com>
X-ClientProxiedBy: MN2PR08CA0014.namprd08.prod.outlook.com
 (2603:10b6:208:239::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SN7PR12MB6813:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lT5mM7f4972W78pP0ijZRkQns0ryeIWJr5VlbsteiPOfZ0JlY+tmm7j4hDltpvyNEfJObDO+A6LQiqTRlYPX/2IpJblit01Z+48KXp1dCGsYDbjzz0IS/KgE8kjx+3bq7VVGIqd1pv0pVZJhtrrLMPNRh8ZdBVKYQ4Xezvt5A7x+4mognGM4/oaYjMiMd96mALmcnrpI6qgKXAg6D9HrltS5TrVWyFqGTynUgrtKd4rTB2QMBUZgQFrsBH8rsFT7bdvDrK5k5ZpbeP2+nCbDChU3zH1SBeLrrmh0b2Y7YlvVNZxPZv7mVSPEvxgQS2mJKZbukYgV3Xgy8r+tB2KIJp2ZuNVzhHl3wLRstbuXXTFUsDPipnJXAfG3Hec2upKmaJNwZ8gpk0TVZpM4P95mLLoSiJdYMHPud9g6p/gZi7bNMIZV55pCqy/epJPomYaH6c31OuDNYj7R0RAn0ADxAyxeMtWt557RnPk3GhBKVyOMvlG7ee2oxt43UyZfQLjU9DW1RbDaEGmWCfJAQE0m2h7JhYE5456mIb5rPDnDkTQDAgGtLPcl09LJbohHnna68pyJDjjII9lu4r2vHPvOHY3iZJoOUFP0RNlTHvH0hRpVTz30IpQSJKpEH2YOKE/TAmKglinn6pn4eDSWl7zr4DbJAysto7E3itl+9MD8uLo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4oUP41dbV6ubBMmdAvb8ceejuMTPK2xbYDhp8Xl7YYnq1HT7AKC2SRGBLWUX?=
 =?us-ascii?Q?Pj1huhTFxn2zgd1kxMFrNOuSyW7w05IjDWfi6AxaTZ+FMnJkeYCKesmkl4im?=
 =?us-ascii?Q?OZMwPs9qYnWoVbJ96GS//WFgQ1kpZ25c+ysqkbE0BlVvyY3U0xncA6LuLsCO?=
 =?us-ascii?Q?Ttzu4sP3ZOy7zOan+LCOOoXSJOyUVRkmN/whQ3MWwwh2qbeB9DRFcytOcUhs?=
 =?us-ascii?Q?DaYVqUKqlOO9zUVuITHCuMHvpTzvkILtowElvexWHBC0suwyi4uRbAkLBHkX?=
 =?us-ascii?Q?kQj+w/zF3+eZWDUJMQ4di5QY4g/gRMiEG0TQJyaScrZJ1ggmQAJ4g7pAxM2f?=
 =?us-ascii?Q?AET2Yd01BXz/ObqJCh4/0IJF1eOUlxv55CIFT9HSEmUTMR98c/HfTbUDpAYr?=
 =?us-ascii?Q?5Ae9WpyLiAubI/jrBdflFlcrKu3ixym7ymtLNd37ij6k6ljcoemywwcV/bzb?=
 =?us-ascii?Q?CQpQIHj0pOv9jOE5nOAUbtmFoL0GLuqo0hylp3fxeKHE3w2mfKeRLvrMuiTB?=
 =?us-ascii?Q?jnt9G1AxkQCvsQqT+/YkeG5zcFfmihGyn7HcWP9KRPKcnM3WZSmlcdOIIeSL?=
 =?us-ascii?Q?tOXlKrEZWMxUonIz/+dp2WH7EQxIA4ySbcg9yUPGY6QvYuLvvlrpaKEzs63k?=
 =?us-ascii?Q?iFIBEnLr9RnTXL3o9EksYNIJB/h6Fn93fGL6+nVLbJuZ4vHB7HYchrMRixFK?=
 =?us-ascii?Q?h21VQ8N8He1V1Y9CXsh+uXDgZVqojkqt2nG+CBxardf8ArOuzO7bBMLQz3Jb?=
 =?us-ascii?Q?/C/mvrjTF+0y0vtcA0J8tzBC+a1ej8z3+uTihDwTb7wN3/2HHh4WnvKX0gdc?=
 =?us-ascii?Q?BlnoFDP2P0ju47tg6ATqLtC04Y8FVCg1yxuEFMcU2vtB4BWI1BiPcs8ldmKx?=
 =?us-ascii?Q?8a4HbRTse4MCdik5lVl2aK1whbJRrzogoO5QU6MMpQgXwzE1n0f5aUgr0Jq8?=
 =?us-ascii?Q?foiDbIXKgkNW1L+e9syC5pTZrZRM5y9y2EMVruE4UuI+e8Ozo1cZee4L141H?=
 =?us-ascii?Q?/PVnN851WDzxfr7gqBUqkkWaIXMCzLOPL4s/ZMOtEIF/6Jfv/jLIk6aySjDp?=
 =?us-ascii?Q?VkVkpepRV3ClDmXHmrcJCwn/Xyx0kt34kOTOr1+kgNkreh6u9Tmwr59Tbbr5?=
 =?us-ascii?Q?nwJcYOfKOlGnbW6THHVDlxALQMBJa5s8tYlMH7AsIz54+rgmVK1FLVwebqeg?=
 =?us-ascii?Q?dt3EYdf8y0TJTpL3o+p9nHBAFAz5POeVdjNn0yEPNKz0reOyARNnvbNkTYaG?=
 =?us-ascii?Q?VSBm7gpBviVCKCG+6KiNOJrzvLy3VqpA4EfhSTfAilXEiM15xA21PoRGk0q2?=
 =?us-ascii?Q?Q1Pl/SXMyTn2ZeD4LmmLHc7mXYSp7b6kDAevDHxHi4yPSUw6CaeiQCPdenmP?=
 =?us-ascii?Q?ZFDbwSJHikYt0IAwbc8k295Ez6VwNskruPQz7ToqrEV/oXlskin+MMKcCw4U?=
 =?us-ascii?Q?x7045BMiFgIzEOjb00guUNeM7Uyz6Lt04+A1XsguKkZ9Q9ItoAW6QlvGx+ZZ?=
 =?us-ascii?Q?oNlQqQ3HPxITQPidDUgOqSoFYok3s/Rci9qFdnz72NrhxuHMj3GCU307X6iX?=
 =?us-ascii?Q?sBVEp+zR8ek9RPWGyTyKTbO+CzpZzmobCsx2l0kC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cf15433-8a05-4af1-f6e4-08dc4d1d2b92
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 22:44:46.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /aat2uJAo/A3kE0iJHZ9ZyH72bEBYo7XXE8EzytKRS/m79zm11KSZGVM8HYYwGwz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813

On Mon, Mar 25, 2024 at 09:06:23PM +0000, Mostafa Saleh wrote:
> On Mon, Mar 25, 2024 at 11:35:03AM -0300, Jason Gunthorpe wrote:
> > On Sat, Mar 23, 2024 at 01:38:04PM +0000, Mostafa Saleh wrote:
> > > Hi Jason,
> > > 
> > > On Mon, Mar 04, 2024 at 07:43:48PM -0400, Jason Gunthorpe wrote:
> > > > Continuing the work of part 1 this focuses on the CD, PASID and SVA
> > > > components:
> > > > 
> > > >  - attach_dev failure does not change the HW configuration.
> > > > 
> > > >  - Full PASID API support including:
> > > >     - S1/SVA domains attached to PASIDs
> > > 
> > > I am still going through the series, but I see at the end the main SMMUv3
> > > driver has set_dev_pasid operation, are there any in-tree drivers that
> > > use that? (and how can I test it).
> > 
> > Not yet, but some will be coming. Currently only Intel driver supports
> > it, but Intel HW has other problems making it unusable..
> > 
> > A big part of the effort here is to enable the platform ecosystem so
> > devices and drivers can use it.  Moritz has access to a device that
> > can exercise this, though we are still working on it.
> 
> Just out of curiosity, are there plans to upstream that driver?

I expect so, but until it passes out of the evaluation stage and into
a production stage it isn't something guaranteed. The team working on
it needs a HW/SW ecosystem to test the device on which is only now
just barely starting to exist.

> I see, thanks for confirming, I am still going through the series, but
> I now wonder if this case is worth the extra complexity, unlike the STE
> where the hitless transition was usefull in many cases.

Well, it is worth it to convert everything into 'make' functions for
sure.

At that point it is just re-using the complexity that already
exists. Implementing a special programming logic just for CD that did
the V/0=1 and EPD0 special case as open coded would be more code than
adding ops.

Jason
