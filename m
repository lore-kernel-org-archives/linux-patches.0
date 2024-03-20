Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA29175A4;
	Wed, 20 Mar 2024 23:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710976850; cv=fail; b=DFwPE0c2foR/ALlY55yHdSgknT+lEkl36yEHUaN9NfgYuqUrHj7i/3NOB/bwcOWyEGX3ClqJ4LhoVW+RwHbQtli+pPfGiP0tZP5vTtwPPRIcu7ZlP9U4qWZvZuCiLqmtMGcaVKA6K1yhPhzNgBZ+YV+qggM8IE69d9f1Ql2dVYI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710976850; c=relaxed/simple;
	bh=Pon8L2oIvLfwRXwC+SOG6UmuATpqJ63c5qatTXXrkdY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W3R2aU/pWR1z+0Kwx8+ffXw0SyKXf4G7R2nFf6Kaa4GzlNZQmOx9sq2rq7SqXEeU6hJRg31C14Yk/PifjsLP9FiS7Fq4phFY6WEry3f4RPPww0lOAe09ml3w/uaBh3R6sx1AP6pimOXFcclxfg5tEKDg+8mLdUS+RW9Ke4YKKfs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=eOXdm1ty; arc=fail smtp.client-ip=40.107.237.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="eOXdm1ty"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfXI2ZP7IrAvtMkgmngLgdfTvpCOEJ/TVwKyqJNRpb1ens0h7BqNIhNdjx8GV+JERAFLZ0LeIvhRXpuD7j9J/zY060R5RlSivxqkwIaQ+eLfs4m2eImP0HkHQGB0XAHo/16HQ4rqM9QcI0WXstwRpaPN/phVVjmegkLLS9C3jnM8KwuPbPgftIHP7hWBtYPjbKqNPW4XGiLYAe51GvgYCf5v+VnP4X711IQvJZ9pXjBvaYVAxq4fvvkBWRzQwnzS0Mlwhp2CdyXAfqKTnzOsWfFsqakuDA32cNa9lCs6U3awiaLK+SDsRcQXuzvCPPE98vegDNiwNdHTu6i67yF/gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YGMWQsbTNBIKbIjn2+zYDUuaFr8zH5LcqYmOq6VHTGc=;
 b=ZsAPHueUM20m4eS13WyrN6y+oxU4HJkqQVC1Esk1JY06yO0USlmFjiTexWw8DzNDKsbAI/BIH3vVuxjdNLpQeopMaQ+Nhn7SGQNs40+6So/wIY/++y8gGTbj6c7Gq2i6ComJ3DXMUFSdMeUimYnGl5ChXV5hOWih4DTRlKonNwFD5u3N824lRbXUPLAFemaF+syGrWCnEUaoIfxEDjk1FR7t/ltbv6KN04uPFd5AotzPGnw/xPh6EmmR3DmGW91wnoChhei4DVKScHooyTzUcndeaiQ/DbKne5wzcrinYLRyflqtwNY5kxVbjF5+USaXyz7zc9z9xqc6AJuwGY/jpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YGMWQsbTNBIKbIjn2+zYDUuaFr8zH5LcqYmOq6VHTGc=;
 b=eOXdm1ty0mvS8VAKwtjlZxKkkNo1j1dvScf9XVuoUBamu46FoSTVtAR83o4mbNf0GK7jxebh1ENtUNGKhmSJHFnqc/w4ekGAs4eDfsikvQamLcLo/ir9+hyKMgWicM7i5Qb8cUFujaIYhE2fJXT09u1NsD+PRzQWGryB5WeyRNn0nxq0JvjREB72kV7bFxMOHSfLSkfJN7uB1X1uGfzjaRBn8TtxI53yFZwutLODagGjs6RxHHrCQ6Vwhrlo2ZS5K6iUQxkUYQsVbqyVVCnVmLoe8jtsOfN7oJWk4D0WvU3oNMK3M56WrqjYLat5zCOKDxIeHxqSikcHWO6SYY1LDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 23:20:45 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 23:20:45 +0000
Date: Wed, 20 Mar 2024 20:20:43 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 18/27] iommu/arm-smmu-v3: Make SVA allocate a normal
 arm_smmu_domain
Message-ID: <20240320232043.GI1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <18-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV24C7Vesum8NzkOvTHiQy9F6K4fFFDWfWFHTjbfgiL5EaQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV24C7Vesum8NzkOvTHiQy9F6K4fFFDWfWFHTjbfgiL5EaQ@mail.gmail.com>
X-ClientProxiedBy: MN2PR11CA0002.namprd11.prod.outlook.com
 (2603:10b6:208:23b::7) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d069b0e-f0fb-433a-f39f-08dc49345e37
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VDd9GXEgX5ChBhOzWwib/pmVxH9ywxJGOpb7BXA5w6OFVmC2Tpcvu1gWQf0/FJLnU1x682OK6m/tkHPEQyzJYKYEGTjy8njnXDoGFAJ1rdN6JbnGzOpD7XCINbvqxETiqJxpqMyZrYupxQl9gefYxoDFTS2+kvFZsPGxvRZPC9NL/K8i+Z2U7a8/ofA3jnnzo2pQs/DfHj+ceYlrxNZPFNAbdJR750BQ/n+gRiX+uUar9VdE0FTqaxA9oO5oaXbIaYsWJ+tjthan/UilFPlw1Ci9kHA9Lk4+7yOy/TCCJL866Hk0NzhQKh3am410x9UZo7/TlIz14fHedr9xH1/UK1A9+UPLxZE0ESuDnUubX1kl7Ag9vtFVgmhKjSZelc28CXeBqY2JWVE+xHAlXEH429EIs41ijtS0dz5BlZ7mn3Yp+1llq16kOM12RS/UogavAjMRBbSta8iCBrfbhyaxCvHdWeAb/Y8OMw0CZyKuhYKKbgV8EGrfqhcnLmuzJoGuRH0gvEHt+tYbegRmO1Hr9T+poVn8ydK8WFW+kymMvc09a52V7eHAr9qbSgnx64Rx/G9UAQlc8wLp5mdfIhtMEzxsqGvhb1ZQDXn9ITjDbIFmvZ5ly4WTGHAhaPxElCFgeDeTV/0wuwhGe/287RN/PyJ4SkNad2NOTLCeAPCBW+Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?foK0AROCs9MkFIQ+ejVuPXMPcwkTQfBDW34CScbDpSSQ2WndJ5okIgTVFx94?=
 =?us-ascii?Q?mBO12IbKpCaHGip0Aw28pICIipnYHAOGjwVy5NcmoeLqmkeLeKVc1iQnSytO?=
 =?us-ascii?Q?xjensyvh1jyepagk1HNvt2YtNkMDCGXKa6zTxkIHSIypiC73324eP1xVhZXZ?=
 =?us-ascii?Q?waHyN+z+fcXkEXafW8nhn2GWWwPIYw2t9KZeKgdZWrPLe2RHVhp0T6pcsHMR?=
 =?us-ascii?Q?ge6oecoOt2Tv38cUZS7psWKEU2BiWR3fw2qt6upszpfRcQoMSSdTe/SDTRN/?=
 =?us-ascii?Q?5jye3o3N0zfxKlV7Onq/5vimnh4PgGUEN90TdeLOmQR7+rL/c/TT62dFImEI?=
 =?us-ascii?Q?b1vZ6Ft/GQFIZSfUDM0JyQjb06MZmwOVLNtIsJTs4VEGnsJJG8m4B2RRLKf6?=
 =?us-ascii?Q?II51PBaVdqgInel3CeLWwpp3u2ULDZaxU14JJh2XaPLJQBcrDEC09v3vm6Yi?=
 =?us-ascii?Q?06uwEpkiPfmbcx9qkGd4rNyEMY1XBBtAMLfvvSilyo8Dka8ZuiqYkhUdv+hX?=
 =?us-ascii?Q?QzxVI3JX6asjs5cg1nJu2Zu9kcCf6v3PJETxhv+Us5D749r1QW85E2YpI/yP?=
 =?us-ascii?Q?r2D2KS7eUNwFVKc6GAg/9yX7bLVK50CJTtwZaIUJsaGeNTx81mnVMYw4Yj7n?=
 =?us-ascii?Q?/giaHXzDD/1jcZgH/abQbMAF9KVj0KY/hZx2ErIzUpqpvAyUVHaQyFvDR+EI?=
 =?us-ascii?Q?4sFmcw5qVOm7dhzZn66Isi93LQAyfZHw7BootGfRUaRVa0jGvZ5urKZsopwp?=
 =?us-ascii?Q?UC1nZtSxHbIjNjUHMfzXTCuPUl8wLcsd1PstlYKcmdyh6F8wS3/7KELH4pCs?=
 =?us-ascii?Q?4qAs+NL07yO7aZssmTDO6rHcSE9bUdLONjEOIBILUpg2yN0wLGS/YTgN9OK8?=
 =?us-ascii?Q?3jCwrZGcxx93BhNjCsZVrCh5RDmm4+ezDH9pmjfWiSBX7Fwtu8sPVSHRIQZ7?=
 =?us-ascii?Q?HkVeUGXJ1icGKMHrHRCNjvV4MJvB7vM7PBqe90724ziPj9sU/lVEA6zlnh6r?=
 =?us-ascii?Q?ncsJRewWjPTmqLKhJqb4jRc9ET/QVckTxzXVB5KMRnSdSE0kSW75zGyTIuto?=
 =?us-ascii?Q?yf41LA5WQhYJkNdZ1saXovAEX/wToY0SMRckKMMpNMONO4O6Mz1kDUf2Ky/n?=
 =?us-ascii?Q?oB5gkcp6c0kMFb1BbdfTZfc8EffukO+J/A+crvhz9pWN/b1Oh3XxVLd3qf7R?=
 =?us-ascii?Q?DaEpqWJ9ibGFXOsk18OC7tyuawSdLpVYuZerE+KrbVVHAZEoowHqD+E87z5d?=
 =?us-ascii?Q?l+7Fwz4UoXyoaNQHVqtj/Q0iEugJoWOA3BCSy/lOn5/ZZtvx3if44tFf+72c?=
 =?us-ascii?Q?kUQnRFvIiyOMb9LWg1IuHcCFjwU5C6iaIjnO/7qlKt1ySguNyyRSG4b1SQlV?=
 =?us-ascii?Q?ZmErkeComam77eaUatct4Xb0bBghAJIr2MKF2I+YKpPNTr2N0t/+N7gftJV6?=
 =?us-ascii?Q?zwCqj8MkRaLxIeE7V2x2qosmFRMCiVDKJhBh5LUPqfGT+Vvws1UX2ZAe+oL9?=
 =?us-ascii?Q?2irbh3mebpdMqp61ikc7kXbN4giA637bVFhRaOdjtRUBXLi9mAbnwx0Xg7ZZ?=
 =?us-ascii?Q?8mvVQCJvS71y9UtR+uIG389x8Vhkondx59qtt6nl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d069b0e-f0fb-433a-f39f-08dc49345e37
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 23:20:44.9397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3GyURPgZQZEeNi9qBdxT2Ch6IrBnjiWdPHY+LXz6Wb4Y2wGMh78h3AGjC56lteM1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263

On Tue, Mar 19, 2024 at 10:52:11PM +0800, Michael Shavit wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index dd7f841cd19b3c..2db2b822292a87 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -2291,23 +2291,10 @@ static bool arm_smmu_capable(struct device *dev, enum iommu_cap cap)
> >         }
> >  }
> >
> > -static struct iommu_domain *arm_smmu_domain_alloc(unsigned type)
> > -{
> > -
> > -       if (type == IOMMU_DOMAIN_SVA)
> > -               return arm_smmu_sva_domain_alloc();
> > -       return ERR_PTR(-EOPNOTSUPP);
> > -}
> > -
> > -static struct iommu_domain *arm_smmu_domain_alloc_paging(struct device *dev)
> > +struct arm_smmu_domain *arm_smmu_domain_alloc(void)
> 
> Consider renaming arm_smmu_domain_free as well since there's asymmetry
> between arm_smmu_domain_alloc and arm_smmu_domain_free that could be a
> little confusing:
> 1. arm_smmu_domain_alloc is shared between arm_smmu_sva_domain_alloc
> and arm_smmu_domain_alloc_paging
> 2. arm_smmu_domain_free is only used by paging domains, with SVA
> domains freed through arm_smmu_sva_domain_free.

Yeah, that is a good idea, done

Thanks,
Jason
