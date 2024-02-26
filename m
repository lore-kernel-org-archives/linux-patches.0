Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB554F888;
	Mon, 26 Feb 2024 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708952880; cv=fail; b=ADewuN+O8DM9/ZcccFn8AquO/WuC2Ykub/pVhUXihl0Ch2zxOWQoQwNamRg44lLEaezsYUQVw+KN0uRkZ1PHEBGMiC3SnbQH3sRXJJu+utyVWM8pz6cYYzd5bnw0JOu0CKw0Mtav8QZ49dp0jAlrbPOP7YjXKHDhPZ9i26ZNISg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708952880; c=relaxed/simple;
	bh=rJBqDT35moNjsfebbXZ4M8M6F0cd7/REHG4+KfHHsxs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZBgaysLT9Z4qYr+3B/qdG+GIeG8jgZbf7vyi7BxpQRostHxRINfjBcuYMAz9nzRUbUaTvO9VTw7XQM3oyoPNnIEQN/DhM3WoehN88AvA1M3Ig58VfnkGrTz2uS5J7TIqboNdbfKEz5eubWUSpqu2ZeGcLzbzNGpOB8gJGJ5RkGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Znm6diLb; arc=fail smtp.client-ip=40.107.94.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Znm6diLb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bD74Vd5i2ZjZxEYJnnwW98lQpdlpqgrGuw0cbfumhYppDKxEj9DyVVuePGErBMcwjGTE3egRxqL22JTbYGgPcBNC8PNAHOmGpZzZzjLiMRVebVJrvaVgqa+RFk9qCoaSk0e4zkrJt57QPOFgZ8KC7OtajwJVw6eKXK85+po8V1YWhiQ52F6YPnfw4tR8YDhRHuOQ3s3K5qtY+xCkCMIswYduqozSrSwCCmBRTaxBAvqiIFA+Df4ONRnD9/ZKJm2GOxoB28Zhbef/2/D+0FJ5cvLideSN003tPFCYiDZq+ukTPlFhYmwBJoRN5M6Bi8Qwv+8zoEtiidJ4TkhbQsxkQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x0lI/nCUrEDM/dVviu2RRltRxbSJnoZvL3DnbIrtIQ4=;
 b=aPd/8tWtZBhsB/s4zTObfG96eMR2aYuJsQV2zG3SLTa9/sclHIHwiLIRf5iJlGOhP0JnAxBCUKvZg3JCMYcWSYCkB+7LNdVnrqnH/nrjVmc9aTI2mJrrxa2DYShAdwFzrRSg/I08s9JTSVRHVcG1TQoSwBx/LJFivIXWT/StNrt8OsFsfIKjLNS7NZx27ZZiavLR5qfnz/pdKk8In483sNQyK/nRxpjYCpEPb4hlywu6cQ6lRWhr+8MuFOsExe0Y1PESFyPr6vZhezV/5ga+K65/TiEaWgsisreKjbjGTP51RPHVcvje9/rHBiQdH8BKA3NYaENRC3V2ZQTKnmKOXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x0lI/nCUrEDM/dVviu2RRltRxbSJnoZvL3DnbIrtIQ4=;
 b=Znm6diLbsPcN9LOSQfkCcy7xwK8hcZucNFZyG9t1LzexBr6mxHXPiv94+ANexxq4yH94uh+oLCcNOkfp/16XVRSmVu+oyAMjZHsOjQIkLQEiQHa1OdRcuUnT5lA2BJKx4RW1+Rm5SYNREJ2+iiFDtlaPOHaY2lb7lTcGj5lmibxlxTYsp08kIcSW2CW0NxtgLh+MOTm0yLKH+JkBwjJxlQPVpHmOmITIDSayr6n67yiWe87LirUeQiJmbju6Oj52b1WelRkenRLvesdOXhif6uNFg2Fmvc+Vy424S23wXLNs9pdP7HBxvcDYQNJ6KoRU/+65HjgmSMJfKbro4LQ4vA==
Received: from MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7)
 by IA1PR12MB6066.namprd12.prod.outlook.com (2603:10b6:208:3ee::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Mon, 26 Feb
 2024 13:07:56 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4269.namprd12.prod.outlook.com (2603:10b6:208:1d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Mon, 26 Feb
 2024 13:07:54 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 13:07:54 +0000
Date: Mon, 26 Feb 2024 09:07:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Zhangfei Gao <zhangfei.gao@linaro.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <jroedel@suse.de>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Tina Zhang <tina.zhang@intel.com>,
	Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH rc] iommu/sva: Restore SVA handle sharing
Message-ID: <20240226130753.GK13330@nvidia.com>
References: <0-v1-9455fc497a6f+3b4-iommu_sva_sharing_jgg@nvidia.com>
 <CABQgh9GTnT+ieqQiNFjc=CLeG0J01Rf3RdLxZatdkKJgNLqXsA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABQgh9GTnT+ieqQiNFjc=CLeG0J01Rf3RdLxZatdkKJgNLqXsA@mail.gmail.com>
X-ClientProxiedBy: MN2PR12CA0025.namprd12.prod.outlook.com
 (2603:10b6:208:a8::38) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic:
	DM6PR12MB3849:EE_|MN2PR12MB4269:EE_|IA1PR12MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: 157e9b63-38f9-4eb2-77c1-08dc36cbf1e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uplZtwGL8BvK6LBbbPE+MTiRJLW/PoeO49yucGIdx0GmHFpyWX5zsor4WxwMnNZYJpV+SuUbCm1wpI7mK2RHWn9Gfk7b3QPi0wzIEJ9ekeFFGxHO6YCuwtFNWbs40jzT0CvwhtD239ScPDpgN2WyxYqShx/MK5h3GVFIDcTyLqe5NPdBwudHYGtyTr+Ttss9TtsCPmaIOwXWCbP+kOaUANyb925yktf7hcyvGAJQYon+CVBKvBNUsYG+/XbDaSEL3l/MOg/iD2wMCb1B3lhvNmrKuXbX/F8TTLGif0ZbO7Yt952QhrSGrlDa9l8Nf5wfEXxMwUZ8e47fWqHYt77iWG+ZA2fD9Dxb4/XAdZBPyzF/lvxEqTOj4X8hCo1bH97MHIz7M53uOZMXv4a5zEiJyxUUCSuzFUefWXtgL8Ta7aJvFArp+do6FcBdrvEXoOgsV2jM9Hwp4wlU7P37N32TEyzh6CVmClUGnxaEERdVW0cil1c0NjpUcaFXhs+4gtQPN/TgE5GkYy/Y8qtc+kMNoW7dwcDLyo5bXMPEjWiuTsptM+tpyP2dQFDlGfvqBm53s4DBtqRRU/VwItUKpJnkk1LW6L95UTsCdp/Ykek3R4JO1eN/LK2DLDoBcoZKmtP+wFLyATemck3sERxwcsJ8tg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4269.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+4tLXbH8fs4T3MEMjxbsDJ8OGxn3StiyeFxbFQJhYF3Opq533HxJkhvRTWfE?=
 =?us-ascii?Q?8HFaeJya54/x799vjuU7iMRDgBwn7vsFYE3k9RMG9+rFP+hvRSF8qQJgBxmh?=
 =?us-ascii?Q?e/+B9FTv2Zy5omO88M95teldMN5zza0L97HzbukQRcx9xQVLXXAmwTRrl81e?=
 =?us-ascii?Q?N7Bjag7rrDVSxr07aDzeWJsgESxFZ6RRBUe4OtiJMFWdI4YpGIwItFFv3756?=
 =?us-ascii?Q?XhMG/LCI14ayIrAtpNV3RA0mZqC4u7XsI0AInUu0XFccgjmW/2YYxabvTMsY?=
 =?us-ascii?Q?vux5l4ejUXabBCtivtcjBPTJuPUWFrPI+4KaGc4RneESlBgA6pvoT6+9YlGG?=
 =?us-ascii?Q?7SsfAY1wP936y3rjFaqnAjdvBbuRmMMA3mNGrnBaY5Geko1Uoh8284fw0qK2?=
 =?us-ascii?Q?fDoITqQj+Pq3d2aJnjlJIFuvX0FPwYDelwQxt83/Cg2IVSlAYJE3UpQ2zYWF?=
 =?us-ascii?Q?LbGLXyPwWulW+5sTvSfTTo/fDhH1xduYOxWwAVhhI80On+CJTxczei92xPcP?=
 =?us-ascii?Q?tjstLpxkM9F2xlUPGLH8jhAUsgJDDvzeSYvCR0bf++NStTCDaTooWRIPTDsY?=
 =?us-ascii?Q?uXYxpiNL8Yf0bLtHdPyI927jT2v54IpsNY3BCgotuKEB/FbE4lZWe2cKyfQF?=
 =?us-ascii?Q?I5Ita+nOQZI8UwR592KXah1xBgEjLV8qlPihPOGKippPTgNdrgmTRbt7Z34Y?=
 =?us-ascii?Q?fOLx1AH6rmoLOObdJudHuKzqC+JYsvm0VVTiAAnEKnvUD/e63Z+jUl8poD7c?=
 =?us-ascii?Q?FySatmgVsUyW6e0uR9qwIjktLQlE267zYv9kr4QKf5WxMidvgYTjkS8ZOoOz?=
 =?us-ascii?Q?JsXxS9BTS94L1Khp1PylQ75JsOCPEY7nH9gWxOWZjaoIpjwZB31xinpVEmr4?=
 =?us-ascii?Q?iUOsjDB985Kd8aZDeeEQ46NOiJekeP+jX9UevoqZLqlnwb0UVNuXweKtZH6C?=
 =?us-ascii?Q?NN1xhq93ipptWgij6yXk6yBG3mJGwQDCQtobBtHSmkg3SlWSsJr6vEVsT1QH?=
 =?us-ascii?Q?fVe02QWT7h45Qff3Dl0J0u9NeyydszOfwTNXyfy3FnLbi+xEj3tRKwLshe4O?=
 =?us-ascii?Q?56PRwLvO2+MEUByZ29Eky7j42kAOhXvaqyDPcAX3bjUw9PRs+okvYTl5D+OW?=
 =?us-ascii?Q?HpS5pdkdN/Pf6AnAV225AAZk8mSwBNRZ9OLYMbEb0zsaxjK1YUnoIa4mYsiB?=
 =?us-ascii?Q?TgCQShe6NjAgvV5KWAJKFgAEXS/u9yEiE3uZ0UzaJyvNz/qpelx/LleRWGDx?=
 =?us-ascii?Q?LTnKnoempQLOCNPfEMYHymB1Ho21a6YIV4gRyBOi3kfw+ZfjzJ6kZ9nH2dbv?=
 =?us-ascii?Q?5kcWAunli2Spd+fhA0/Snyd/xkVxmAunpyoaR8CG5RSq8M+bCXikVemsUUce?=
 =?us-ascii?Q?VoHMO+sMbmNQlzxi8z11avzmp1gd0InWTpEv0dChQajiv9odRA6nQasxDyCh?=
 =?us-ascii?Q?YaBqGCJacr24aOhfdD/kPd9JzlOsL+s/tTMAvq5GOTUTTlAuOJgEcfGTDUBj?=
 =?us-ascii?Q?ARmWo5SHEiOR3fuOYYHCx16NjRbmnW6QHrCU77GcvEgeJl+EE/w7Mphn39Rr?=
 =?us-ascii?Q?Ki2IVYdMjcgLcsYbU/Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 157e9b63-38f9-4eb2-77c1-08dc36cbf1e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 13:07:54.5483
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDd4nl1mVTm0r9qA9yKFiH/W9StXDMd/Hs4qTTy4vUzC1IDYMExNdq/hESVf1Hvy
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6066

On Mon, Feb 26, 2024 at 04:38:52PM +0800, Zhangfei Gao wrote:
> Hi, Jason
> 
> I am testing on 6.8-rc6 with more test and found one issue, sorry about this.
> When test openssl rsa, it will use two devices, one is sec, the other is hpre.
> I found the second handle can not be shared since bind_dev directly
> goto out but not add_list.
> 
> So still need a minor fix like this
> 
>     iommu/sva: Fix SVA handle sharing in multi device case
> 
> 
>     iommu_sva_bind_device will directly goto out in multi-device
>     case when found existing domain, ignoring list_add handle,
>     which causes the handle to fail to be shared.
> 
>     Fixs: 65d4418c5002 (iommu/sva: Restore SVA handle sharing)
>     Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
> 
> diff --git a/drivers/iommu/iommu-sva.c b/drivers/iommu/iommu-sva.c
> index 7f91c8d0064b..b1f3a864e124 100644
> --- a/drivers/iommu/iommu-sva.c
> +++ b/drivers/iommu/iommu-sva.c
> @@ -117,11 +117,10 @@ struct iommu_sva *iommu_sva_bind_device(struct
> device *dev, struct mm_struct *mm
>         if (ret)
>                 goto out_free_domain;
>         domain->users = 1;
> -       refcount_set(&handle->users, 1);
>         list_add(&domain->next, &mm->iommu_mm->sva_domains);
> -       list_add(&handle->handle_item, &mm->iommu_mm->sva_handles);
> 
>  out:
> +       refcount_set(&handle->users, 1);
> +       list_add(&handle->handle_item, &mm->iommu_mm->sva_handles);
>         mutex_unlock(&iommu_sva_lock);
>         handle->dev = dev;
>         handle->domain = domain;
> 
> What do you think.

Yes, please send a patch

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
