Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060.outbound.protection.outlook.com [40.107.244.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79EF17B04B;
	Tue,  9 Jul 2024 19:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720553953; cv=fail; b=tjlwzAaGO8Nl8k6VkF2yOpIdvtcCSu408LrXEKtsNPIzQKmCO8MmyFtPC45zoO7wot3Bf7cxMnBEkzV0bLkBCP1AzKHPqX9i5I3hnT4CoX8rEl2jpYDav3xMlCPIyG8IbwMxuqENi1b4t7GQXvuE0AjOm8QF3oPaSGm9cx5RJIc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720553953; c=relaxed/simple;
	bh=bGVGlTVcfEgVPApVmn5GurrkHtZYtiJaIdkEI3JIUCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=V/UkgcCk4KAQwIdrJ+j8jCWhA6XJo72fnC+W/z5YbjwYEZZ065NGUk6NEpkRlV0Hgu2lXjL8ZVqUA8AiS4di/hp5M/kLYZ2Boy7VgWkCBiBRwvJ8Y3ZoQLSB2+5ds3JbUHFR/DvnYFN2dNo5ExaG81DvyPLed+NloT54ze+b+uQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BP2lJeHA; arc=fail smtp.client-ip=40.107.244.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BP2lJeHA"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WLfVxBUEco0Ofh0U+04Nxm6FzcDEWLjs+0bejyt+2E1u8zhQA8eyLkKlYHSSnz7heO2x/pjpfmpyeIXyUV8g9A5tu4nvO4dbat87UOOvpiyZAs93tl4Tm1Kc/66J0Dl7NkWJRYMAYOzp6FgDxD5LYry2wWBbhUA62pcrBkqSDTZIr3wFMJ/c0wUXayYCEedmSrEqs0JPXk5GA7mEHHVwb7aqUsJc/AhmuxUHs46ITaTPAUFKTHyVVGRSnrFLxLSr1A1yO6pvaDwy5fJnNg4J9vZbX7caUWJyvGTWxyo7kAgxJhODsQ/sJFjTUjbzMId7uxgnQsc5/SUC4wsxGv8Agw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8HDoYnjp2QGU0hElp+er+HW7oGBU2Xaq7fXaKeRON0Y=;
 b=C4MNPMMKAOsJGNgv674KqmS2n3u0Rg3xpRkzuvObjbLnlsPmzw6b6OP7NIt0l5aaNZfUIuvrKzUTFgzSIZCkhfTxb9G0TLddX7PXqAO0uvog9enqkFWssYB3+Wnv506P08qKQ/ZWztQxWDQ0Hjh8O85e2fHc6qJptmTEYROegC5kWnSL1ngMc46sELVLlGpzFDCkaVHA5TmFTKFztO8RvOERVWMxxTsZUz7dqKXOGufcqApNq/ndAz6IcQ4viO5DKMY3xMhS1FD691HwK+wPsvS7t/SOGRZYmMSLDABWbt0spBAsRDs5FUTAo1JvfGjrZhbpbbAw5Jfx8qH7ywJ1DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8HDoYnjp2QGU0hElp+er+HW7oGBU2Xaq7fXaKeRON0Y=;
 b=BP2lJeHA9VsWzM6TNgxOSDHC1gvqk3RGlcn3+eQNbf/19PASLME5XxmXS/Ae6Vt/3OMWh+X0O3LrGso7BFdvu/Jz+ufVA1xJmFxDBqI0poFW1NViwMlGn5EujD7SOa8CzBxBG4xxf5ryCE8KVznBv4EeeGv7fXwmHmkOi4DFcohJQzwuJL14792Vx8bv0BuoDDkQiv/MkR/fY8Zb52Y7sbblh5r4QNHnx2J5v+bUmjzSJHDT+LLDyjy+FiQAUp5YuLfCixumkyK9AoPvXMP5cnMeKCtzFTWad+Hw8gw09P/NXnRARv71wg7ZZb2kfZceAOBBx5keYpfcK5DEPWBIfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN2PR12MB4077.namprd12.prod.outlook.com (2603:10b6:208:1da::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 19:39:08 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 19:39:08 +0000
Date: Tue, 9 Jul 2024 16:39:05 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jerry Snitselaar <jsnitsel@redhat.com>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v9 02/14] iommu/arm-smmu-v3: Start building a generic
 PASID layer
Message-ID: <20240709193905.GL107163@nvidia.com>
References: <0-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <2-v9-5cd718286059+79186-smmuv3_newapi_p2b_jgg@nvidia.com>
 <20240702145705.GA4135@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702145705.GA4135@willie-the-truck>
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN2PR12MB4077:EE_
X-MS-Office365-Filtering-Correlation-Id: 709a00e3-baad-472d-c744-08dca04ecc8c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bOnoop0+R+KzDQ43SOEkEcOkVhrFgxLbzpO6lqf8IcmCrGWWcUnRPDd9tiBe?=
 =?us-ascii?Q?1f1xFHgGp6SbveaIt8xD7V0e2th0E2W3/kF1um+ePV6bnJQcvkqNVbBft45y?=
 =?us-ascii?Q?993/IqnnrtctNe6sT3cOTV4mwzUHhuWJHVx6vT+3l1OGXbssaARths654/yy?=
 =?us-ascii?Q?E08dDRSzgmHrtNB+JORnbKhq0m2tTJSMMDabCSHtZd2sDH26CkqWllvPbd3s?=
 =?us-ascii?Q?455nQUbhsMLXaXuKlA8nodo5xmxUH6WA12lXKyG17lEfpTHGCgRIfI+36mzx?=
 =?us-ascii?Q?1bDBGeU6BhPe7O419XN8VKJuJY4dWeDHWYT3KGMJKPxk09wVBA+orSekXKPC?=
 =?us-ascii?Q?WK2ZWftNl66+KB62JDh5DaKmK3JlABS8jDYapnhLf4xyW1En6mhx2z/I5Trl?=
 =?us-ascii?Q?7HxWTiS6OeEBq1KT8VDSopjucx2p60Lq3ZDxleS12BOBvkM0Gspm50lsqNJ5?=
 =?us-ascii?Q?mviTbl0obo/deJiPYwkTbS8E9BNFBDvL6i5dZLdeJJ9ibhLBxEs1SF0OSRuN?=
 =?us-ascii?Q?t547muYx7of9WcYimqKGgkP1PaiV1basS9VdEZMuuHKJ9snWnDGS20vM8IfR?=
 =?us-ascii?Q?c817+E147yk6swb5kNaKAsyWUGzBkS+nsU7eVAzVzNR200pDO1l1ju34xlht?=
 =?us-ascii?Q?jKqBu0AwcvdzFo531UoIseUmE/TSlb6yHvswRAhPGS4FfBBcnrgG+D01j9iZ?=
 =?us-ascii?Q?wxhY6KsOZcjO5vtKqFZ1DRi3/6nMoOCVFHPg+LPrnlFKQN3MwOm64XPfL1ds?=
 =?us-ascii?Q?rB5oJ/jH9mCi0ApEwBsvAyLuyKM1EumGjpOpbI9x2jcvsWIABbrtEu7uoTQS?=
 =?us-ascii?Q?S6ox2EmcOA6CW6pAy/5gnDW8wojaiicg2b4HAqIFkwlhyLZdXvAJ8S2MnI8o?=
 =?us-ascii?Q?DMZHM+9oo8f3oHsSiid42u9wg/sJQdsUiOBIgrtiCKU1dZ5XGyiD4pPMzKft?=
 =?us-ascii?Q?W3wBd/J/zbHiY1ZkEaO++1sRurExlOYgCVZtGQIDeycrnMSD0mSlWNKJLYeT?=
 =?us-ascii?Q?GEcs3Ivil4MLK0LJk1UL4KmTEY+DpCVLVqeEn7LT6+3zseZvQnjwHL/sjB8c?=
 =?us-ascii?Q?wpvzwWAUiFJsBlVhRBb4gzHbZ+xr7WGOk+k/QAnNF7xKD0kj3+YJ8Pfbenlh?=
 =?us-ascii?Q?En8fdzp0n7N6WJ9aimMthrPTIMh1FHnIi7OK52q3qqfzadDwmxt/HK+4/dav?=
 =?us-ascii?Q?K8hRJRFlozoMBD3oijZkwZWBG49v9UyvnccK55Zi7SatbTK8KuwJk4seP+w+?=
 =?us-ascii?Q?ERqTOzXd9yULK400Oub2bjSu5IkFomyfLgTI1sdlhtWEP1EkCsidqjfpdlUg?=
 =?us-ascii?Q?YPobPLXvHxeEw2sodcXdleRwAjEzvaYtTp5qoLPDTzX3Vg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GeaqJU8JsJ6lFWwmJy6pk2sGSkp9HuqmbmNN1M7dPXWB0e2HwKF2H3+VLNQD?=
 =?us-ascii?Q?SZE0BhNlmXh4d/HgkR6w6/pDF6YYG+CugOyb08uJBjZdhrN9hk8HssehzQeK?=
 =?us-ascii?Q?2mVLWestQienHHQHSWRZT56/Y7jXbWd5rUyFDUu45JYcoKs/gbRUOMhvN2iw?=
 =?us-ascii?Q?9Ua6etI3a7UZzxFdKm0pNmoxWHQ0e/duP5t/XB49Mnn2ywIhsG45KsJwHDOQ?=
 =?us-ascii?Q?cQMrJTAOmrmCRbismbsAZHYokYJb1ERziS1Iop8UenwaLNHVgfx80GPxZG3y?=
 =?us-ascii?Q?RqndUnxngbytU7SL95lDw8opAq8IY8p2n7aUfhqLPQNqUfKdAzt/yoh5009/?=
 =?us-ascii?Q?B+U35E5b1rnBTH05BMx2tUen/NjB0La05FCndqFtTD77k5/I4sacdkkirLjU?=
 =?us-ascii?Q?KE+4F0YbbJuf8SfRNXKcVfsGVb5mgarFU40EZLRNZUiUD3GQ8RNnbu9z+lhD?=
 =?us-ascii?Q?0Sfr+rK5w4/wehdW7Kzszv7lkxckVFOutHPJpkqwUAT6Q5uEUcjstya6+TE4?=
 =?us-ascii?Q?TYoldMmxWNQ14eTcFBDnXMKV2N8MDuo7nKu9+P2vpNQOHVghJGMf8y+/+5Eh?=
 =?us-ascii?Q?xRECNycPoaUTIy2QJZZplN7TjeipOMvX2Xzkt8ngAG9wLaJYICKY87iQ45LD?=
 =?us-ascii?Q?krB/COmikXGg35LFrv4Jgl5T0HrR8y6X0EkB02+5MyztnFLkylkSuAN9GUdc?=
 =?us-ascii?Q?G1DCwcgfqKDWKAxHE5xCjRbfci+3ULU/d69TA1k7FzRPo2GdZ6x9QGOtFGGa?=
 =?us-ascii?Q?k1Vu5GheFq3D8CKl/LIqmPdBPP+ymr7JejS0W2hqVROQi7LEF2ewmaQ2XCt3?=
 =?us-ascii?Q?4xgLz9B9gLaMUfwMsdmIkM4tUc3Xo4wNYLp/yisQkKqRpom2eFERWCi9/bVv?=
 =?us-ascii?Q?jUiDIaPxpeXArrNhSTATMa6Sd7SdcLBb9W+JEu2CBU1PuK2nxlg7ybVVQwUl?=
 =?us-ascii?Q?8586GnF/oE2Ocg45zNwjXmyd/WfwTqhbS16XH2rng8S4TgZfqhIB+jClASO7?=
 =?us-ascii?Q?4iHOGgKoaQqoJP1poqNHraX5MpfWbOEsizdSjKYgnsr+k0n950sHT+TWu/Y0?=
 =?us-ascii?Q?iJPy9Lt2PZpSElXH9q6NJ+KJyzUL4MgSY4c7qvk7nsVaF0JXRGNeeAZJOBNi?=
 =?us-ascii?Q?gelq20yRWj3VVtp6S7pTrs3N0oABXcLYYbqhfPWQ3BwSKn1Z3GCfeadiGj+8?=
 =?us-ascii?Q?jKYi2Zniuym7Qd7YlvegenUNV2AU+xuaiGhB+YC+pw4VqxxMPzTnJf3DpnIw?=
 =?us-ascii?Q?k/h+Tuh5AK6QDD2rwuO03hqQriVXsdWpZWN8XdGQXSzvFhYFsT5giaC5KXdx?=
 =?us-ascii?Q?Juyi2wBfEiojVoRHWZeGz0NJAzJKGlVPz1m0JgnrSHK+fUGfjhUzMH8d8D+q?=
 =?us-ascii?Q?j1f02QOsp3Mjii1+T4bFzfjKNnSjpuU419/k5DA9ooltPNC8s7Mhu7QRkm8s?=
 =?us-ascii?Q?lz5vA8Vm5C7aAzLTpm1can0tYpX3GHLSfIyr9+bkypSZBNWh1cXj9OI9Xfl9?=
 =?us-ascii?Q?/U8633ejAREsJVJZ62VwbwOsKoLDe2mZAYMsdsvj772dKS5EC6+NDsewc14r?=
 =?us-ascii?Q?GxXyLdFTdCr5nhB7S/FVWo1HVQTIy+PUdKU1xCrn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 709a00e3-baad-472d-c744-08dca04ecc8c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 19:39:08.0989
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2WU+kiExUPkjRR8atSAYp/JlcrlcvVUHRB60pUe8crDD0nL7fwoSQNMyUT3kQv/S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4077

On Tue, Jul 02, 2024 at 03:57:05PM +0100, Will Deacon wrote:

> > @@ -611,10 +599,9 @@ void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> >  	struct arm_smmu_bond *bond = NULL, *t;
> >  	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> >  
> > +	arm_smmu_remove_pasid(master, to_smmu_domain(domain), id);
> > +
> >  	mutex_lock(&sva_lock);
> > -
> > -	arm_smmu_clear_cd(master, id);
> 
> This looks a bit alarming, as you're effectively moving the CD
> modification outside of the critical section. I assume we're relying on
> the iommu group mutex to serialise this in the caller? I can't see any
> consistent locking in the driver for arm_smmu_clear_cd().

I see Nicolin got this - but yes, sva_lock has nothing to do with
CD. CD/STE has always been protected by the group_mutex.

> As an additional patch, perhaps we should consider documenting what each
> lock in the driver protects and the lock ordering requirements they
> have?

There is still a bunch of rework to do here, it may be better to
complete the rework than to try to document it, but let me know which
ones you are interested in and I'll write some thing.

sva_lock is almost gone, it just locks the IOPF flow on the master
because we are doing the IOPF flow in the wrong place. The IOPF
enable/disbale should be done in attach under the group mutex.

init_mutex will be deleted once the iommu_domain_alloc_paging()
conversion is done.

asid_lock.. Is a place holder for the nascent BTM support. It locks
domain->asid only. The BTM patches make this per-instance instead of
global. Unfortunately that locking scheme doesn't work 100%, but I
have a notion how to fix it..

asid_lock is also going to need some reconsidering when we make the
domain able to attach to multiple instances which is something iommufd
wants.

devices_lock protects the device list only, excluding the special
nr_ats_masters thing.

Then the hidden group mutex makes all the ops touching master single
threaded, and the driver has always quietly relied on this. It
protects the STE/CD and parts of the master.

So I think we end up with only the group mutex, asid_lock and
devices_lock it is OK.

The order is group -> asid -> devices, which is layed out clearly in
the attach functions.

> We've got a few global locks with generic names and after a few
> rounds of refactoring it's really hard to know who's responsible for
> what, especially now that we have stale comments referring to
> arm_smmu_share_asid().

> We've also grown a number of places where we
> drop a lock in the callee and immediately re-take it in the caller,
> which tends to be a source of bugs.

Do we? Can you point to what you noticed?

Thanks,
Jason
