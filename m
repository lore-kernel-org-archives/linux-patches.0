Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA17B2E8E12;
	Mon,  8 Sep 2025 15:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757346717; cv=fail; b=BI2LIcwrFj9Riy4zWQUqarlmO8/hneoqD+Z1AwI35TMTzLBPxtSqVaJzyiaN0TSbvJq55Ng4/xFY9gVbpVtm8Vo0eo6Xz3Dag3/kY642ldqCgShAny16cCLxEt5W6WzwND3P9XSnJv8kaYOXW95AFKaqkgrvrfvBPHVyV4SPbQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757346717; c=relaxed/simple;
	bh=/wf0KwNSJSrQmkLT5blwzYeztUIYARlLsWfse2XaamA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=IDUwrDAhZVpILK0XJwWakCUtlqwl5HrYx8u5UG4EwlkrIr9PfcuyRIXyKyotKtGoLEbUqxc2Tsh53Tt9fytfdJutjEf0BMKKtqiVHXoDFfmaTOk+XcXcy4L4cACPqrhwgZMgultloS0E26ocIWIe1Pbfzya9Ld/0TR0cZw1CG5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KPen6epC; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KPen6epC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AH/jKU+DrJ+q/TpRYi9ck+O3KlzQnMdjBlzcx08uILMbyDp06o8As5taTZJU2djQuZjC1yqoAQhdgq20gzMqNjRVOg/4XlC07JnFmbmC+lHiQ7YgSm/GBqhI5Yr08+cCI78yM0PZrWpvmAmSHpHrOAzWdLjaInJXAvHVMqePdmz/s4u364+I1NkTVvifGtE1VLTsBGJUkLA3OV20vL/tHSMh3ueuDHwLCQ8WDnuAGiHVtcZ5vsvtFfNB1f713tE61LFY0hfbIW2oBRNT+6m/REbrM6ocesc/g9UMvJLN+nMH4G78ailbYQJ4xQ/X502A5alwfGSwggqOzlc00+D38Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGjuJh7KOFlb85Z45UYRRJK6PJA76RecQwTd8qX5Jp4=;
 b=L31OYFcfvXiQy2chTHgKTvVaEMMmDB3j+aKNGkn4rCF8J4YtFygPzk8Tz2qCiALao8EYGNWGFo3sfQ+9ui19b5t3tzDoYpq0VTcFmG4JDd6B34zVJgLIMvoLNkMG0e5cZ4hPWNavOebzPgEkaGNCblQWooOuyuSMqrLlhLX2yDXMCih0LDENKP/WZUcYWRZvqb1sqzbFOP6/0tQSftsZU8tX4XzPPRyhyhPfwkc7N85c7JVIdjyCySOvnUW0VecyWFn9psZ0TFm1wGjmhvnJm96C4gkVoCtCKNXOmokA2DKZxQh8JoM4g2N6YmZlUMo0ufjAci/pBuQZj3AQsMEkFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGjuJh7KOFlb85Z45UYRRJK6PJA76RecQwTd8qX5Jp4=;
 b=KPen6epCU0a5+XfKw6yfAO6E5OuQxjYYALnQX+TGkW0as3Ay2jMLbTCNE1ZzTJiVjBR7ltaMcVz3la4LTQVpFFC6eXja+mIHouCE4blITw1YgT5555V8ln5owiq4DzLfVJIU4oSto3GeKdEKeqX/Y6N3PQD5iPdMJgWsdxhaddYhFbod4gY2i7UB6TvwZjbAH0toV72DHrPVOwj+drgl6RtsZY5YNtREZpTP/TETmY3NYgD/4M27rGl+obXPSI15U/0HRDXiBsoVjexkKxlxztW5BLHjtGFWVgTh0tQaGvi0sg4N0PGYV6MOhdgBCIQxiidUatoLArQze2w8PhNFww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL1PR12MB5753.namprd12.prod.outlook.com (2603:10b6:208:390::15)
 by DM4PR12MB7597.namprd12.prod.outlook.com (2603:10b6:8:10b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 15:51:50 +0000
Received: from BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2]) by BL1PR12MB5753.namprd12.prod.outlook.com
 ([fe80::81e6:908a:a59b:87e2%6]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 15:51:50 +0000
Date: Mon, 8 Sep 2025 12:51:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com, zhangzekun11@huawei.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv1 4/8] iommu/arm-smmu-v3: Introduce a per-domain
 arm_smmu_invs array
Message-ID: <20250908155149.GD789684@nvidia.com>
References: <cover.1755131672.git.nicolinc@nvidia.com>
 <fbec39124b18c231d19a9b2b05551b131ac14237.1755131672.git.nicolinc@nvidia.com>
 <20250827200002.GD2206304@nvidia.com>
 <aLvt7WBgvVsAD7wC@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLvt7WBgvVsAD7wC@nvidia.com>
X-ClientProxiedBy: YT4P288CA0061.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::15) To BL1PR12MB5753.namprd12.prod.outlook.com
 (2603:10b6:208:390::15)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5753:EE_|DM4PR12MB7597:EE_
X-MS-Office365-Filtering-Correlation-Id: bf86de2f-cbb8-4c15-8bbe-08ddeeef9fe1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?H9Ce+dSGMK3CB/nVBY8WrjUxGhBttdrI7pDNwC3JCs/eIEDu4eT5s90cmBhA?=
 =?us-ascii?Q?0DRC8tF5ux2hvyeO9wWdwGnuLY6zAfyQJFNrANXnKPsPVLLubPQ5sW99+xmt?=
 =?us-ascii?Q?tExbVdZqyMqvVSXvwfip8xuAMrdygtPEDfnGdzM8USgzS/sFWtMFFMiGDVOQ?=
 =?us-ascii?Q?5uHlIs9wSKCiDEteZudpydzfbq/fXcmhZRsK6K7vjttr5j1Ca/ls3F17XZR4?=
 =?us-ascii?Q?YlgTRiyYFv742GrEXgz/7IO03cyVD6JKJ8akMrU/2XL1LJgimjuWDGIBgyz3?=
 =?us-ascii?Q?nSHdj3Xyx9VY5aU/hNiB124wAG4+g+ybimbv8z/Rg2L7Fn0Tpse6ttxNelLC?=
 =?us-ascii?Q?UDoR36Q79QbmFkzuuXalTvEAlggov85x24tJKOtcS2/VeGyayfYa9POOFzSN?=
 =?us-ascii?Q?gRtpHIjku9wIjoaVKglEgwclB0hyYRf6/SWfSW6YtfBoIE4CMeCzKWttKO8M?=
 =?us-ascii?Q?T9llpLQ1zOVmASJXEFBYRVdiO0pxK3V6/I9WrxnjUvAVevBzqBJck5ToWNGX?=
 =?us-ascii?Q?7Q30umvr9ZfsM1gUkqP6QPagyYrXg4iRXd38qrYFzEHFLP4U00uRGaqcRH0x?=
 =?us-ascii?Q?/IWQW2FJNtV9xuzm0qXMJ/xnJVYcaf6BrIkuRhVYnHi46tVdIqALnRSUpZyg?=
 =?us-ascii?Q?0DgzEld1+3VnaA7TtkPoeb6gfrU2gxQmAs7ZO8nx6kl4qPlzk5M/vS3d1T/U?=
 =?us-ascii?Q?5cC7jStxBToAqg2Pc/w6mUOuZ1b+jTHhbVRyxnC2/uyECiYvE846z7NLwMsN?=
 =?us-ascii?Q?LcZH7wvplaY8+wRgvtofBs/A5+2xddCjFkPC/L7VApLJXcAnwod0zt2EX/rY?=
 =?us-ascii?Q?lWlvc4GmSc9orhHDDidePWBGucdjN1BOKKy3Ij+feTTPEY9MOZluZlEwBeB2?=
 =?us-ascii?Q?bBpZAMdaHwJxdcDkzuDw7qFA14bgQwWDB9fB65kqlVzUbTRw/kKqa5wUM7Bf?=
 =?us-ascii?Q?DzO0UoJArzz2lKIfgWOAkT6VLPlQpLeAKgtJv4vLxNggPgbluSHmTduiot6X?=
 =?us-ascii?Q?ChQJiYb/EyhUVuGo32qq2fqU2ed2KYLhhrXDBi64tLS8itp4UMx2O1WryNVl?=
 =?us-ascii?Q?vi98+TIppuukLw1X645jc1QNLBKQXtCn3b9dNRbZZZpdlXb9Ggmo1IKs1Z3q?=
 =?us-ascii?Q?CzwloxH8CZmtQyP/NCLWqRGBkEGR9ngo2c6DTHuBJWYD+C4OTsZH/YjLeRx8?=
 =?us-ascii?Q?4RTSVp2e14wtNZczLhLkbIyYEDYWrbU/xacvcDUB713HesVf44KQeF2q6xnT?=
 =?us-ascii?Q?F0OlKC7CPKc+O1LRNIJ6Bz2DBFGZOtPMWuWpkC+Xxw0EGLHZBcE00OV2VMyn?=
 =?us-ascii?Q?rqZ4rNhXbTH4C63QGAxRQRzsKZGsmSR7Nt2wwTVAKRIBCAbpmjOXcPnRZiKf?=
 =?us-ascii?Q?luoGgI/VzL0N7dwEfqdXgYq9Q6o7U2WKw01BxyMtBW61ijfpNrCSpRka91dl?=
 =?us-ascii?Q?RrtUDSt0C+U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5753.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?csQRtmRnSBSxZ042f/4xqYVHSr1E4BTjKWuCdqLBEp/iasNTxfzHymY35PMd?=
 =?us-ascii?Q?ztNp++EZVHG5/eKf5iIOUJI5vdc8z6Hk0PK68FnyrQ0bD20zJZYSAwq8jYeW?=
 =?us-ascii?Q?wNp2zLMXi6OfKfUgZGKxQSobCnmWcM5/7PUXZLT4I36cIdwTPJ16iaHkpxWq?=
 =?us-ascii?Q?UndP9U/AanYrsYHW7xGS9r5GGJ752gYb9DMdfwqOEwiJIUZgaPj6etdesRTs?=
 =?us-ascii?Q?sFz0RHM00nOKB2iCaAi6bE1DVmrZDNgEBLLsUIIUtVXcqvfTZhgUmp06V67s?=
 =?us-ascii?Q?VpSfUkBhYX0Tfac111StMiz1t5Ek/B3gprfZqpmQT/MfpHcSe6aXRjXgP0dq?=
 =?us-ascii?Q?N+TaU95QMujSXEa5RV9UH2+J+C0j1quQocUZiYuPMPuB5oiuZfsYVyDmW59I?=
 =?us-ascii?Q?uXKVKU3pPdL/DQIWkNe/AYdTgaNxyZiA3InI/MbOPwjg75Pmb8NPRWGOQveE?=
 =?us-ascii?Q?WplOBwAxvdUciEoMIXqoOZFUCEpgWdVJHG1ZuGRf7E4gvf+kKN2RJl3VTiPL?=
 =?us-ascii?Q?ixFxLQ4HA7jPGu8g04l3U/ejdiQjk5eR+lkGTGVAktb49ASxfK/SC0AK05g/?=
 =?us-ascii?Q?JBu1CatRnz9sDGTViJYs93nJEa8Fro6M2CWo48l2uL1taSgQhegOgme15h2n?=
 =?us-ascii?Q?EvqwUg8bf7YGBbGyMPZqCHJqehSpNgLDT4F1ssx+nq8SbRMdGLZHv0Shsq/y?=
 =?us-ascii?Q?WeWRBTAuP+AWg0r1O083bR8qoxoNe6A/7eOfnITW5SzVUl+gTYnNZyphUPLJ?=
 =?us-ascii?Q?7ON8LNgu/rZ64KZI4FjqrBR24PMWMirUyPoOVkB8nHJ1q24Yr/rkSXTFBBr8?=
 =?us-ascii?Q?0dUTG+tDRfg1+v5+pcCkGb2ubI0ptU3Ed1T7AJEMdGV5usYzYjLVxPTrWZ8J?=
 =?us-ascii?Q?dMoR1eumwgKi5Pr/xqXTupcvytJ7kqukM7AXD85yW9yCm5gEEL29qInrsZs0?=
 =?us-ascii?Q?bwQSuckTaPpJ62F9YDQpIfVt0x+bRAu2zXJDmhQHpfnYmTsNx2c9u4CTz5cQ?=
 =?us-ascii?Q?MIw81eSZ8lAxLDNT3WACrOCEM0oEimyDXjQGkGaCPeqK7kpmDNUAonfr0CwD?=
 =?us-ascii?Q?LKBYn5vXImSxWXgePchdAhL3IJMXOBzdtixFihqB9syyyVibG/XPIedo5fnu?=
 =?us-ascii?Q?cxowWa3CQUGY4BCVzWUrlkyCwLqdwvL14l5v0Nb1DV0nMzu3sSeUAcXdGteQ?=
 =?us-ascii?Q?Ox1IgDpnOOan7to3IMbfbrLYBFwtycAKdr6oakEeb54KbVwcxfdw79OtLoRt?=
 =?us-ascii?Q?v84lEvFROzs5XVKxH6EjkT4+LiVkBBsD2XHJiN/3IPhsDOlJo1iLKS26ekTy?=
 =?us-ascii?Q?928h1/A623VtHSv+lAkKGQw/Oh97N7lEX8IHTWk2LP4M9r2u4+anDXmvSypf?=
 =?us-ascii?Q?TUGg1lW7tSgrpJFNCnKky0yflQLtDH2a7nIr3VPAmd+J5eYe47CPHM2eM5Ru?=
 =?us-ascii?Q?sLM2QyJrpwV8bPnQuyswO/VBGoSyQYogVIeATmw+i4jEWxUbCqe2uUymghe1?=
 =?us-ascii?Q?irpsPXxdJ64J2W+oat31hfmo70A7lwJr3rTFrHGRkYwt3c2kz45ELE94EJFv?=
 =?us-ascii?Q?NcBUBd4dTsYUtmO7YB4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf86de2f-cbb8-4c15-8bbe-08ddeeef9fe1
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5753.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 15:51:50.5227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IAg1X8EJ0yngbQBOuhiVtHRd4K92cpFr7bft7BU1+PxnEHEi37mLpJ+31HQjD71g
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7597

On Sat, Sep 06, 2025 at 01:16:45AM -0700, Nicolin Chen wrote:
> > 	/*
> > 	 * A sorted array allows batching invalidations together for fewer SYNCs.
> > 	 * Also, ATS must follow the ASID/VMID invalidation SYNC.
> > 	 */
> > 	sort_nonatomic(new_invs->inv, new_invs->num_invs,
> > 		       sizeof(add_invs->inv[0]), arm_smmu_invs_cmp, NULL);
> > 	return new_invs;

This should be deleted, merge sort always makes sorted lists.

Jason
