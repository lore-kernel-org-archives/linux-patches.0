Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012051.outbound.protection.outlook.com [52.101.43.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D721DE2A7;
	Wed, 24 Sep 2025 21:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.43.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758749556; cv=fail; b=GXQsXXKM4vy+2hFZhNcH51gHi9mY8i9X+35xZQ3cyNTLU6FhDdDpunR+MpH1em5n7kRO1pY/zSwqaAjSZ4iEfupoNOZu3Zdn2TquF+/PmXLlSyqRadLTBqZWR28DpEINHEBQ9n4eG+slfEdHt3V4CKZN2KAoDxZ/rbVpJqNAPoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758749556; c=relaxed/simple;
	bh=JCxAUKgmIvrd0FOmblFNIbU5mhju3nh8PihBQLFQYxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=kzwTlmJLk19/5lgp/PwQCrgiAF351Bq1u3jXCZty0g4f/CMc7L0qMzmfOVigkCRLZiL+Qgj/r+fYC5uOsyW9tnfY0epTSj1IbOz/W6lEdrlgPfPNhF9RsTwmaK7g3Zx6GS7bsHaIb9fe5E/ntrsj6kyKj9GEIwYkbiJ2IyH3Gqw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rniMsDfy; arc=fail smtp.client-ip=52.101.43.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rniMsDfy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mUrGH6ltgGtw1jm3w+ZpVo11fSpkw8hf613FaxACSxDhPDsI6k2mo6ySR47qn5EZqr3B5gphslHyNexgALQtRxvAZvAA5xJfGSbCbkjiOQAySHoOI6Hj4D6p3GvYt/V7Yz5gp9LosQk3SuQWlSGphsZ2MBw/eaBMdt9+U1nR1QbJbO2ASZaCOeOqtAulM4f5x4ShryRKXYljfEEH/8wTj66EA9NSGR2gxjFooDMR2hWJIBZRewuBtYZfQFiL/XXZ6bgnwQAiR3k2rKtMq10KHNjhudmqAza+RQofeNhwtE8JNx4MMP794NhZ1yQBub4obgpdW0uOwYbs6XCRF9OYhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x3xdNfmyYMblKWfSFcR90w0Ssbj9yi0IFD9M7BzeEls=;
 b=GmRmE+EqCG6W/fcyzMRofh3Qa40fL8WxfDxRg06RvVR8ncQD9Kww0vnzZh9mShHboQSmtIxMF/VufVQYiE+L2AodkL0g/HvAW+ZnSQyCkewmE6rPI2DYQ71ChS4QTEMJ0vT8S0ON0RsFHHeSJQMZrldkSCXzjyqOe1eD2SCg996KYwCPK2BOwYsaR5wqGK/Ss4y7087BesMaJ4oPH1awGTl9CpYPUsK6noTzLNIVRzbQtrtDJdSVnBOOqjvDoJMMk4FSWAMyiot0ZTbPqSmjKAK7Ddnp4Lw+81aogeldiXHkTC1JXIzPgAhtc/CAblAXVkIKl6zoDLha+UJ5Uj/m1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x3xdNfmyYMblKWfSFcR90w0Ssbj9yi0IFD9M7BzeEls=;
 b=rniMsDfyW886RB+1eNrTXaywEWcuRecUc+hPX4skr3Nfg8k04K+uPeIfLWidsq9iHLpslq433Xd+2Vu8zZ1dD36puQUhqO/P7hArQi4XIb55iCCuCmd6+bMMoCZqOyQydIvYffj3mL4t7bJ5YB487XCuz5BoGI9lM4x0xGqM773lVz1LDsIfVt9hSY0scWhsxNjsJMG/NB8VAbb8VIkLTRd60Gzcjg3FxaexUh3dDHXmTPSB6pVmuE1MGWBuq6bdWyzwR3fJxPbv3UOM/b3MZSFleBb1rIsWrTI8wUtmICosIugRl7JsDh5DdierWRRy3lLiBGVH44lytb6ILJYRwQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by SA1PR12MB9513.namprd12.prod.outlook.com (2603:10b6:806:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.9; Wed, 24 Sep
 2025 21:32:32 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9137.021; Wed, 24 Sep 2025
 21:32:32 +0000
Date: Wed, 24 Sep 2025 18:32:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: will@kernel.org, robin.murphy@arm.com, joro@8bytes.org,
	jean-philippe@linaro.org, miko.lenczewski@arm.com,
	balbirs@nvidia.com, peterz@infradead.org, smostafa@google.com,
	kevin.tian@intel.com, praan@google.com,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH rfcv2 5/8] iommu/arm-smmu-v3: Pre-allocate a per-master
 invalidation array
Message-ID: <20250924213230.GQ2617119@nvidia.com>
References: <cover.1757373449.git.nicolinc@nvidia.com>
 <f5f635077b791b27b46ea41b5c86a52fd4549a44.1757373449.git.nicolinc@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5f635077b791b27b46ea41b5c86a52fd4549a44.1757373449.git.nicolinc@nvidia.com>
X-ClientProxiedBy: SJ0PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::35) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|SA1PR12MB9513:EE_
X-MS-Office365-Filtering-Correlation-Id: 681fdc4b-4e51-4ab7-01d4-08ddfbb1de8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aqo4huDi9x/B5jXMSVjLXiqk/iKvfiwOwGgu7fEFGaooVxMsR2ce71x5lGyp?=
 =?us-ascii?Q?DWZyhvi9V68roRChER8AYUeRlQFtcld/rbemUU0JrQc7dNeAAjnjQDN8FLgj?=
 =?us-ascii?Q?B1WTd8K8CyQ7yF1gdRw9J0Q1tgxXgZMTNziAUOLR58wMZWtsH3Wu7OEetUTl?=
 =?us-ascii?Q?IVTJdJpX4XA8EKyPKvIdIxGIQUHH9DPQ74jj9VCQ7dZG9H++jHsXRFPwrmmQ?=
 =?us-ascii?Q?kaJxI6LAPdeOnPTe3ZAIcPzXl57ynNb55vlx21/lY778U+TnoR0/bJPb7sy7?=
 =?us-ascii?Q?h4Ur9wxf2ZL/bRL7lJy9Sf8qOmElHOzWPODKWAD5n+hbp5JHUHBuZ2zd6oP/?=
 =?us-ascii?Q?DLpTeluMlUm5L6qcpTo+gEHwkx+kXu8JIB47E/bxRPTr83hH1FI1SPxh75kf?=
 =?us-ascii?Q?hWJVEj/RCwfXbpfzv9yn4D7WWftnlL1f6oMAkYmRlcQNkPDwsZNdDTD11cFh?=
 =?us-ascii?Q?GmFIlifHT2HkoTtppkP/NFaJv2rgOdN30OwZRlYTPJwJ2taQGfQeKnEf8fe8?=
 =?us-ascii?Q?CrJSAmLy5OFqBFdE476Dr7X0A38jPY/qIbnyNKGcJLJBv1dyGMwzZMDIL/W+?=
 =?us-ascii?Q?+iXjst0dG9qDMgTcJ8k4hhD2fjtqF7HlrkoCydlGxEoolUUamYM7WpoMCWZh?=
 =?us-ascii?Q?PmBdDeWCuhvCEXWSLpdCM3lgBWOXVVl3SPzamPaoMTOmmnzJN4UodS/eF1os?=
 =?us-ascii?Q?xILzN+VGDme4TAGAwYHJ7bQm1hP2mDMqakPYB5hvsZa1Ha1XNZRB6xJkvekJ?=
 =?us-ascii?Q?06TOsFLfTyHz4X9cH7gnkusC2RW6w9V9rfPWOQkFNoieBkHkNLXWF533wrje?=
 =?us-ascii?Q?8PJaL96Nzf+KjawQiLh88ED1p+Y0aXnJZJeg7iMTw4kxXD4u1wbhJv+l1Qi2?=
 =?us-ascii?Q?P7RBa9xWRLEaNNDadc/JEn8pCucrBy6YIJ3BiOMdVJWNVAK0vd84HVHNOgIO?=
 =?us-ascii?Q?9x70gCBpmf45xU7M6T676g3cuLgQ2FObbqKdAUNRfQLe5KnXQqaIgrilbryV?=
 =?us-ascii?Q?89UnO6eOt/HlNWndzOQtnc/b6XMUmTtT94pw43tWV/gwTsALh7ErCx41RW8H?=
 =?us-ascii?Q?5JvJuR66TNfODvtREve97uJbrZ00f1qxTjTUATaB7yaIq0bAIvDg1hrNbcU2?=
 =?us-ascii?Q?hq0eT+8JQIBpKqWDZkkoJRJ/PofuPsKQxeFXJ0tuqWnzjHHdTG8HXkr/fW+U?=
 =?us-ascii?Q?WmqjvoqeGcIQ5uStOtAhUSmgSGE6CI6VzbwyA9U665hTCEH089/lz6vqhh+o?=
 =?us-ascii?Q?CYS0ZqEIZPCrXHJgOMj9QNVGIQ7UdeRqQB20utYKBgQhoC+pywk+9HN22oks?=
 =?us-ascii?Q?TFfXuN0SbPAMWLfK+IcLeE7Sq1PDKzV1b5rqiVsBhSQMVFA2fQS2nUJ28i5X?=
 =?us-ascii?Q?p9HjaO1IlkMk+corpGITIei9MH6ZpQVqaxJGcmEfor0YU9CNWba3ErIEhDry?=
 =?us-ascii?Q?42yvHgZrPUk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DFhDvVTSr7UaZ/IWQZ+V3AUO5RdQmmGz0om9WwweLWGWIc6WaUuqq97y/Hn6?=
 =?us-ascii?Q?qBaPTCRMn0LtrddRpwVzoE+zqI3RpN0l3zPEaBt/XbGhy43F4KmzXofY2a1M?=
 =?us-ascii?Q?+m6VomrpEC1712GxDpXmGvceGlV6IgeY/MdsKfWMgkgy7FpVzGc0L/NFj4Xx?=
 =?us-ascii?Q?AG/LHBiYVwgtNeHRbYdA6zS2WCVtHZR72OgAqVbKOyCtF5k62Wf10xm4FRo8?=
 =?us-ascii?Q?wxRFGTP4GHgrGMemizAmqKegEacjH8uokWanac4ZX2ISRwyNriL7RcobxK/w?=
 =?us-ascii?Q?XxFhLkG51MaJJsyB8MMKD/X9W04x4GtCjdomvziYrv/aZp+9K2zmeFIpreM0?=
 =?us-ascii?Q?16ZALVLG9wtM3cncM6HmJjx3pLsCxcw3QYWq1FJ6W7teDexfUM4TQltFDvgk?=
 =?us-ascii?Q?KiBZfxqLcaYMnblqWBw2Y1BJxFurKQnMSaT5Tx0JutOeklwWu5JyHPOWgnQm?=
 =?us-ascii?Q?aahycLLIyHSG9myWDgniwNyVkn3gqBpaIowRXIsd4yZHwcOnZR5hm81RkId3?=
 =?us-ascii?Q?YXYTtgb5z0YwjnSQJydIDPGvaphRJCmC5CKKWmvG0Qsheztlrhsyotsl691Z?=
 =?us-ascii?Q?hSOfur1sFiLEavivoERjwuh6wNRgFgzS6NjjLuOvh64feJDYyZzmAXU6u7NH?=
 =?us-ascii?Q?jjfoEjP081jVR1KaLZ5YuVJbc1iavmE8kmfOD7xO4hI/UTuDN1naIUr5ZoM9?=
 =?us-ascii?Q?Xh3GnzaRLejyZdjKXbNxwohTUpdLeskzZJcra9ZvcE//BwjCf3hBYDVehMzl?=
 =?us-ascii?Q?qf0HzsexeXqi/FAyngIUalUjMQZNBG2zxet7tUe1kvdTCZt30PSAKtnSwRgP?=
 =?us-ascii?Q?//ZFec5Q0IdqJPtxvHE+T9fvlYZDSpG6ZaDNwuKOInMT95OFvVJdTyokq9nt?=
 =?us-ascii?Q?L9jWgiLXJ3YCElAFf6ItWhvWwTSazzhUAEodQz3T6ZTdwtGMtdv57oGmGIti?=
 =?us-ascii?Q?0Yrhp3tpI8EbGCzzilT+6qgn+8s7QV9kYn9VCPP1WDS0ImK0mRuQFdrdiPTz?=
 =?us-ascii?Q?y7YB4sm9Ar7ay2+SrKaz20B9LsdqUvm8VbV5ooS8jl6kmnsxeYZ38GDPOJyR?=
 =?us-ascii?Q?PDOB7n2EbBDouZKBCp6725IUh5zx+bzPx6zD6Ar4/Znu0uwCD8DdQmabRNjM?=
 =?us-ascii?Q?lQFC4xn/0w5B7Gx0yZcYJJVTq5KDh92D1ItzG9dcHS2hyR4udQ1DTna+LdRW?=
 =?us-ascii?Q?9+UqaVQX2BTPMmhdykTWi1DnCti40CiQYoQe8wfFvX6r13+DK+f4DDTi44Vz?=
 =?us-ascii?Q?E9+lb/58MpBoomUaOJkB2nfr8Gr0uGMl3MnDd2Z53aFSYfYx3RlfJTc2V/rc?=
 =?us-ascii?Q?ERiTeETXKq21aPd5OSG9XJbcM/eaXVKFqgk126ZjXysK0f6JMY7ySRjxuG3x?=
 =?us-ascii?Q?QyfCvkm8Ys3v1tR/YYUH8lshJM+BVu96s+LFP36Jcf54Ngn58lOnc79QO2dQ?=
 =?us-ascii?Q?Rhtwr2wKQIMUux4wWaqFsySXZCQrjMeT4PoHiJfpwSw8vluXRScGs7d3IEqR?=
 =?us-ascii?Q?pGsspeTgLlO5AcoWmU0OtvF9+oTSdC5LA0xDhchCgVjBn3feRENg5JIBwNMY?=
 =?us-ascii?Q?3QqntkneFNAO1OfXdkcpbP8op7KcfgW3YafwWDaJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 681fdc4b-4e51-4ab7-01d4-08ddfbb1de8a
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2025 21:32:31.9504
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhguPU2JLt6tQbtXLyVhT2mZ3EKfv8w+PvvrYIiMqnGk2rw/eDc2LfuRpU690cOv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9513

On Mon, Sep 08, 2025 at 04:26:59PM -0700, Nicolin Chen wrote:
> When a master is attached from an old domain to a new domain, it needs to
> build an invalidation array to delete and add the array entries from/onto
> the invalidation arrays of those two domains, passed via the to_merge and
> to_unref arguments into arm_smmu_invs_merge/unref() respectively.
> 
> Since the master->num_streams might differ across masters, a memory would
> have to be allocated when building an to_merge/to_unref array which might
> fail with -ENOMEM.
> 
> On the other hand, an attachment to arm_smmu_blocked_domain must not fail
> so it's the best to avoid any memory allocation in that path.
> 
> Pre-allocate a fixed size invalidation array for every master. This array
> will be used as a scratch to fill dynamically when building a to_merge or
> to_unref invs array.

Mention the sorting here too, though maybe that hunk should be moved
to the next patch.

> +	/* Base case has 1 ASID or 1~2 VMIDs. ATS case adds num_ids */
> +	if (!ats_supported)
> +		master->build_invs = arm_smmu_invs_alloc(2);
> +	else
> +		master->build_invs = arm_smmu_invs_alloc(2 + fwspec->num_ids);
> +	if (IS_ERR(master->build_invs)) {
> +		kfree(master->streams);
> +		return PTR_ERR(master->build_invs);
> +	}
> +
> +	/* Put the ids into order for a sorted to_merge or to_unref array */
> +	sort_nonatomic(fwspec->ids, fwspec->num_ids, sizeof(fwspec->ids[0]),
> +		       arm_smmu_ids_cmp, NULL);

The sort could be moved under the above !ats_supported, a little more
insurance in case something is inspecting the ids.

I searched around and only found tegra_dev_iommu_get_stream_id() which
is fine with the sort due to num_ids ==1

Otherwise looks OK

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
