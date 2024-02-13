Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355F81E53A;
	Tue, 13 Feb 2024 16:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707842267; cv=fail; b=RGg2IWuYQsp2Hpv+e2nw6o6PsT0r1QFty3oudOOLFAxVwsTbLpjTueL7M4T8YQ8OBqh9vqwT21k2mXWn35EfbjfW5KpxXMsccxQ1cxUPDvL7c92vZdA1eW7axzLXJEPeNlDwF1mVGFqM0xovSmNHt7Ly1v216MfeOg0lqgGRqZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707842267; c=relaxed/simple;
	bh=VhfFNgX2TSdHLpoMMe0vYNrNtUxbIuQA5lj58LAAnMs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XImSWbiL54B0zmLK8UX9wrlZFykx2eq/yu+QbcsnAdL3hYu56r6ulGFrS/dpn29HffQRKuevvoM2vb9QWg9VF5PejqYDpigxfKuyDz0Lwms71rCmgc8cM1SMbeyglmwZr0vsY0+YXXNokW2MZqeUjVohACio4TiFZJvmFYztkdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NVt2OPyi; arc=fail smtp.client-ip=40.107.100.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NVt2OPyi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XNkOD1vsppa+sfAm52xWgVFTIZLKFN+iA8c5IXlAHMrDrPe4KoRUkxGOgHgQul7el/8t3thyFR08Xr3QmYDur/YKkor6Xl8HsxYuyjpAgX32Id8huh3pIZxexmBQtS4N1a68StzK1dJPYllSBA8Hgzy6R2AadZwOwK93TgDK5Y+nt7cFmJuQhXohewzzcaJ7K0q7Vl14c9s2bcH7y7EjonCmA0wTJjAPc2tedh2vkBt35PUeGzWyMPU46YIfA2FJaPluE/518kOl62T7nSexJpl1Pnn4xQie2qAJ4DF83AR8unyajwKCeo6Vk0CAIxwJk1nuiPZkpmJ+WQw0F8K4bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T8/xfbINJQxdcWAXWhtLrEHnXtWT+KwS2JlJrxlGwp8=;
 b=UBtDBEYHiycVVAHv29uMXX9Ba7TGv0A/izF5kb5UAxK2YQ8jzQIymFd87/RSMMvp/CouDRzu9EEiz6ott6K3bVCcrS8RSlnLF0V4r4ma9l0V+oi4mJu7aNQhDBKT/XfdRw5taTSp4HRtjHpIZB6gzuVmrhfzvWGBXMUaiw5uMGHpONR3jUDIyM/Jzo4sP0Ujtqbkbt3tRD7yJiDMm3Brf3ONU76z4YWFDGF7nIe1GtWaA+V31+EVUPClfHrhgDcx86jZOdWuvLj+SYqdiXd/b3SPj2IwAbS59DjxAJ3rs5gssXkGAcxZf/bfrHMxdf0E6sKsVyj+LXJPHKLmarPFyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T8/xfbINJQxdcWAXWhtLrEHnXtWT+KwS2JlJrxlGwp8=;
 b=NVt2OPyiYssEaiociiki3FefbAM/xYPFjR7QHPdsCNEqdFtn3h7tbDSb6sysT8B6IFm/FfSVhqEJ7FeaIwkBtdvEuit3P1nKBPPNQVk5xyVlhj1JZuHFdsM3TLuoX7qePAW+kai/4WkacuYduRX97cu8Z4F1KFzmF2RrbIKHzOTU9bGgRf0faAxXFYg48OtZ6cLSSSPILuBmtF45aoBJevcd466avHaAFvQNO+mJwrxQa/9YPMj3VO1eShwxGknpsmY88tq5BOr18C3OJCP0kO9Hq0rUrXfURee+ZbkocHqhUMumpM0aXcVBSrvWCAfia7/XH90D6Kb+BaIypxC65Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB8841.namprd12.prod.outlook.com (2603:10b6:806:376::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Tue, 13 Feb
 2024 16:37:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Tue, 13 Feb 2024
 16:37:40 +0000
Date: Tue, 13 Feb 2024 12:37:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 11/17] iommu/arm-smmu-v3: Remove
 arm_smmu_master->domain
Message-ID: <20240213163739.GE1088888@nvidia.com>
References: <0-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <11-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <ZcuOnnrWN3ZxJY8x@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcuOnnrWN3ZxJY8x@google.com>
X-ClientProxiedBy: BL1P222CA0023.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::28) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB8841:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a1edcce-c0ff-4662-2d4e-08dc2cb2187a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YnEO6xwoCkWP0n+HpqKkrw9iJKgbqcYIvaMd7TwqCuAedNuub/Wa9SHQ7HSfShsjGke7CsCAlpVz0EZuW/+C4m2DB2wCRrhZH/JSHppmDNrTLQ5BiFtsNM14imIuNseV9uyHnEIBDxSwjGGdDxY23nhXFzXGq6XcAH1mkpPKYmkuHI2W2HtvC1vx9iEYX9uAZEDmJAPdbH4he3mNNHSO+J4MFQsN6OCd/78cCMT/G3ELKk30xTqsiZYGxWFkAw8/WVgz/+vRzDC9Fg84CsrFmaaoegx6I6oPxfNV5kjEeUVU0Xg/wsUC91ZmQ1YtvmuTwLRD/rzWqiF6L1a1ktz7u1aDvceefGFNe5dueFI2hSOLCQKZmUUK4kxg5I7tZsZGIlwFgB1OURmTfp/9QSvyS67d3hXOPbxEd2+TTnpfymzW3Tx3mKa/wDHDKO4geO/6L0Jt9fg/OJKWE84v0KvI5HlVwUk/vcMjnyvOAU8Ki94fBjYgmQ7hpUYUVvzeq2bh68o7OfoefoEaKvq62jd+JHXzXnf7qiJ7LOmUqoNlqnWH1Qaoe7A1+nsMOmwK3td3HdXCBvolyG10a1MXq6vNkLDsZB/ebtNBH14mubnMLFU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(396003)(39860400002)(136003)(376002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(7416002)(2906002)(6486002)(26005)(36756003)(6512007)(6506007)(33656002)(966005)(478600001)(66946007)(8676002)(8936002)(38100700002)(1076003)(2616005)(66556008)(66476007)(4326008)(86362001)(5660300002)(83380400001)(54906003)(316002)(6916009)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RUZSRAM+0tvTKSd6j8GXnI3d0OiaknMBhp8/UD/Fcr96oLUTgw68/TJS579A?=
 =?us-ascii?Q?brmmTsmBqh5ngh3ng1IGva9TtupysNIQH5T+sXPEvd9DvgNgg4dOiUVnU5e/?=
 =?us-ascii?Q?UnEArzoqsu85rXYVik+5VFo91ck5/gpnqe43xz/s0bovymuq+nCGdAoaPikj?=
 =?us-ascii?Q?VQzhRWpUMVp4DIqcELK/aBNZiHElwQaVSZl4iZWrVBczpPsHKBKLFeOF/Dya?=
 =?us-ascii?Q?HjUEuBD1EYTS6V0Antc/iErITodDLpRKjdvEizvVSaAS7p1WAdk0wN60WBnj?=
 =?us-ascii?Q?V36vmkI2UUuyqHW2eozVy4WaOUCik/xrJp6GygV7Rp0ClTG3dukt1+tNcxuE?=
 =?us-ascii?Q?sWQ1ZDN708EYegMJzhG/sRuMTLch398qOhVHSDFMOP2Q4hMihWGfptXIyilU?=
 =?us-ascii?Q?Tfy9FT2y3jK0L6p8zSrH4UvLIz1dpOXsxBfbMz9nvFbx9x/ObTV/7kh/95Dt?=
 =?us-ascii?Q?/Moc3R8MJAOo46iUHs1Ve9MEMKToIM/KIwPqFiSe5P3f7LPrpyuJPdqDRyKo?=
 =?us-ascii?Q?isEbACowe6TjaExhXWKHiNRO91tW1XW0pLY2R81v0+1Tlt5ps/eQ9uaeImS3?=
 =?us-ascii?Q?hD/eYHYrGBAnN8Cm8WX4BjzKlnCbbIdaX1+EjRc6GoH7qTIpP66Ey/U0CcVw?=
 =?us-ascii?Q?3HzvbaSUHq33QkCZHcJRagUuEbdb6MFq9WkH8WHXwkHcIsqXm0XKRFAeVtcj?=
 =?us-ascii?Q?LHwuLmk5tTPJDAwsiw1fAPZoYucHavNZNAqH10xsazM7PWZeFcRuBa9cVJl1?=
 =?us-ascii?Q?lUiFevpINX/ES/7R+cKyVRx7MzCfKDysTCi2kvQVDJn5PVWFbD9ctDRFlF94?=
 =?us-ascii?Q?snnkr9o8UXspZ8uGf2Rj8Ozodk1XXohWQleAbV9rNveXQuPGcQ0W0fdK9lT+?=
 =?us-ascii?Q?iuRn9CKI/9Opd73G4EUhz1upakEJec0++bN4rzFBJzQrfnLiDw3Dmqmv6ILl?=
 =?us-ascii?Q?6KKXop+if+6yu729PjY6VKjeJ+o7q6t5ZE56q7jLzyIzg91v49ybgeniuCCv?=
 =?us-ascii?Q?4puHMJjwlxyyYHyTcFpxPI98l/S4LP/qo/zdVmSRLG8FjkKotEqAAkUmS4Iq?=
 =?us-ascii?Q?DPY454BOPBsRZTVCH6oyAnUnZ6N3eBW1TnaKmh0I9dXiTSTHaZNp6yZ0jcV+?=
 =?us-ascii?Q?oMioe2S+O80KjQsV+M9ZQOQN0ABcSHBjr/FtY3+Ty4+2NyXbCk1SEp6x2ng6?=
 =?us-ascii?Q?VaDaWOKTeen5vJC9DXTz4piYWxeXOdaFCqJaQLDEsqV0AV3v+2SlsxzmAqmb?=
 =?us-ascii?Q?w95GbpQUziBg+ODtkZ6G8XR6SbdVm1NVelQYUlbN7AH1DyJ4n70YnmF9B1H9?=
 =?us-ascii?Q?kDCoPKc+G7TiahU/cz+DzMDsalXvpYsjUDTbQVa4elJnPjsANruus21inUz4?=
 =?us-ascii?Q?nkRVsX4mm2oS878qzuAy9pi4JGfnZ88BqOfJB2h6J6MTBaCdtVHgkSVL7LQ+?=
 =?us-ascii?Q?YPOvUnuqT05KmQnWabuQTujmqNU0H/ukS1/Az4mG/n1003hewu8g2TeJHoNN?=
 =?us-ascii?Q?tgHRXU815kqV/o3UheboOSWD2V/8cW4pHwmaI+/9M1M7KhYknChKjnt8dm2v?=
 =?us-ascii?Q?hZt/uXN7NOK81G7FAMaanrWneVu0RAVU0VRkOSRZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1edcce-c0ff-4662-2d4e-08dc2cb2187a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2024 16:37:40.7239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6rtb8ZnSY94CI3Lm37afckh1HIx0WK+03j0ZPTbRk0Lce5cQ8WLCXVplYBpy0F1d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8841

On Tue, Feb 13, 2024 at 03:45:34PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Feb 06, 2024 at 11:12:48AM -0400, Jason Gunthorpe wrote:
> > Introducing global statics which are of type struct iommu_domain, not
> > struct arm_smmu_domain makes it difficult to retain
> > arm_smmu_master->domain, as it can no longer point to an IDENTITY or
> > BLOCKED domain.
> > 
> > The only place that uses the value is arm_smmu_detach_dev(). Change things
> > to work like other drivers and call iommu_get_domain_for_dev() to obtain
> > the current domain.
> > 
> > The master->domain is subtly protecting the domain_head against being
> > unused, change the domain_head to be INIT'd when the master is not
> > attached to a domain instead of garbage/zero.
> 
> I don't this the problem here, neither the reason for initialising the
> domain_head, can you please clarify the issue?

I didn't notice it either. Eric found it:

https://lore.kernel.org/linux-iommu/6fff20dd-46d5-4974-a4a5-fb4e7a59ce44@redhat.com/

> > @@ -2560,19 +2560,20 @@ static void arm_smmu_disable_pasid(struct arm_smmu_master *master)
> >  
> >  static void arm_smmu_detach_dev(struct arm_smmu_master *master)
> >  {
> > +	struct iommu_domain *domain = iommu_get_domain_for_dev(master->dev);
> > +	struct arm_smmu_domain *smmu_domain;
> >  	unsigned long flags;
> > -	struct arm_smmu_domain *smmu_domain = master->domain;

master->domain is NULL here which happens in cases where the current
RID domain is not a PAGING domain.

> > -	if (!smmu_domain)
> > +	if (!domain)
> >  		return;

Which used to early exit

> >  
> > +	smmu_domain = to_smmu_domain(domain);
> >  	arm_smmu_disable_ats(master, smmu_domain);
> >  
> >  	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> > -	list_del(&master->domain_head);
> > +	list_del_init(&master->domain_head);
> >  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);

But now would cause the list_del() to hit a non-inited list_head and
explode.

Instead we keep the list head init'd and the list_del is a NOP.

Tricky right??

I changed the comment like this:

The master->domain is subtly protecting the master->domain_head against
being unused as only PAGING domains will set master->domain and only
paging domains use the master->domain_head. To make it simple keep the
master->domain_head initialized so that the list_del() logic just does
nothing for non-PAGING domains.

OK?

Jason
