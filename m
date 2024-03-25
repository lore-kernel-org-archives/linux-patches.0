Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2082.outbound.protection.outlook.com [40.107.101.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2D1607A9;
	Mon, 25 Mar 2024 14:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711377022; cv=fail; b=h+vlTq26/Z1i3Cx9tocUt7a1x6lKnNTiHqgbL9iPtB7kamuS9IWOEo1BF9+aSv0naeg9I3sEecwUbf5FwSZTM2C7LjRBgM+eMQ73+9Y/dYBl7509o+Ja/peVfJtq1+Iz6gYznWLv5beRuSodNcFpfgJD9hLz8yj1YsJtNgkvbtQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711377022; c=relaxed/simple;
	bh=8GTbUUYMmP5EfB6Z+YlJfHAjAZhs04GwAoJZJnpjvKs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GTLA9Rvnuuaxbvt8wCNBVp6vvj6pNUFSDIUBbUtBKaJGdugacJ3JTrY+qOE5daw+vTPMcp3G/nF6S7u571eayMtoPDhzYwm4w0EvK5NKEI0PQWKeqgjqpRcp20S7QPLCjQ+tXoHI5ZT2Svlcms6y5goGHt2aHHs+uxu+HMgoGwQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZO3fM2Ks; arc=fail smtp.client-ip=40.107.101.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZO3fM2Ks"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PU4zUW3gAKFdjCiy/xKS15oUd3IFtOWLjxywRQfz9o8SqedI2ckSxIh9eYteL3sfGJR/Mj9kzNuAUxnP7skerr+I6lMwkC5JKmIN91m7770Eo7ES9O/u/YXA3iI2zIiK7DuwdfFQZ56coDBP9dA9vieTz4cH6B2huq+cCU20PtCfwBftkOo7GeYxnbS7vMd4Lk0ZyVLJcSoN4hoRd2FUHw69S796/tiuNV59fM2b9Fygj1XWQo/rYvBAjzsSiT5p+bgaKIpKEHZ2Pm/8j9BYGoeK6jsHI7WY4nft0a+4fFpPPIMOUIfm3SKP3gbSe5qmAFbTUD0keLV2ivhspBpnvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tApFTOXoOgq2rlGjqOdWvKMj5YsENXgSDrFwA9/yzZQ=;
 b=TSb+7W1Kp+cqGkx3LqZhtQ/FgbkjNSaz2YXQMWIH+uHe3uuwkbowa1gkUn95trO0NkaCxBig2gFyyY5JCc/NeBKQ5mZGrbY21YbsLY+b355mjKBAcXwpwG0qJCfEQbtRyEZACJ+KPOvhmcHEpPXrBRxlmkOHnA2Dz6f4bcUP3oyPYuRoYslzR+YMGG6QEdVymhXOceaxIM+o9dN/RfgzoNINZnSkewQwC9WcespDwxhNCBktQOZqf9sfP7hF21F+XvpI6zzFf4WgQFB5cuBfmK84Nt7zSzWS70Itt+hKFX8cqfJeG7EnjobalV4aOfpYYH6jS2lFNa0ZT6ZjFL/wdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tApFTOXoOgq2rlGjqOdWvKMj5YsENXgSDrFwA9/yzZQ=;
 b=ZO3fM2KsWfJlagx+nZcbwSpKtvCRVFt5486i22qEVYj6W1kQE4lJukla0Y9ob40kV92IxSu+guvs1pVUZ5M02eK2J30peajhaONKOuBrDEXnK3751tfnQCycdnRvQy7epgf4sUBxdCXlfmC689nij9fhpks1n1l+4XlZ6biCZZxtT8ks2bw9iP9sfJtWBpLlTAJ3ixNq1q/GU634vfrtsNHJ9YSW4lIfy0wNfzbCOmXwsv6Z/L4UQY/mVM5IcKS+2LDlcKcJu2aYgKo/lL3SXvK357MGDsfzloGaWXZg4B9mNx2aHIR66xg6gA6iP4fjhPKaYa1wVqVHK2wclsXtLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB8452.namprd12.prod.outlook.com (2603:10b6:8:184::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 14:30:15 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 14:30:15 +0000
Date: Mon, 25 Mar 2024 11:30:13 -0300
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
Subject: Re: [PATCH v5 07/27] iommu/arm-smmu-v3: Move the CD generation for
 S1 domains into a function
Message-ID: <20240325143013.GE110546@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf7VFce6E_8NM2r8@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zf7VFce6E_8NM2r8@google.com>
X-ClientProxiedBy: MN2PR05CA0066.namprd05.prod.outlook.com
 (2603:10b6:208:236::35) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB8452:EE_
X-MS-Office365-Filtering-Correlation-Id: cb1f0478-db50-497f-5944-08dc4cd81655
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YJIDG8GGYXhyODE1I/uEjTVu9ipuOUIQZfY43EH4ZfsvwmcnYWgnOCnpAYWZbWcQvUcKHE5gQwZnkPLwTaWGli4zdWcpDVByChQ7Hraw9RymqPiIsaoU3C4bM5fAjQ2IcSXYiG+W1R4TpjPlJDS3CWSkHzdn0C4Dc5pIvWRUCYR0aivzRQdVPwBCl4gi+ttDJhUXBYr3tr4lNhs/0EBQRMA1fRxFbkJfuP6IZMvLcIhH65uZtmTz9R9GkpNz7n5Wt72GJwbxQVftn1P39ILzxhmmaQiG6UtHo3BYrADoWOFn+U3RXqbHY1cXWphG7fUX6Cr8KQCLXAGGX0mZ7PMvX50b0MGXiqtW2eYI9DRwL4sDZ7709kGaj6hUR/sPUd0+9nPtRIli+fGCr2BtBlB2T5XksSLu6tQCQXIzk783OBWK54996yYXGDGYySpVj5cpkWiMhGU2lV+lsaz3jLr9b41DEgVUKryZn6787n+tuNMg240jO4tv1B8qFPzWcxTBaVLTUY35Gn3B27hWaKeedzyGOZzLxVEptfyYHJ4uO2YWM7ljdUGwNqot6OmSOLvR4Nz8Du6cOCgIpSYYESSbQeOqBpTADZwBf/FMu6I6tMsbkrJ6mw7eqwqETy2ur43PivjgxODm8LoPMfn3eR1ZFA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HKCLiLlmHsi0XopZ459lo8TWCzpldJkuEC4Ezy4+X9F7Zy2lCpIAKpJNjBwk?=
 =?us-ascii?Q?jQSKdDafuPFmQNCVicvIjwC+unbHvyYkP01M1j0M8n4VeLfzQ7RmxlARz7N+?=
 =?us-ascii?Q?BkLtliFULgYxFbrWNOJRsYcgijyEGc3NxJkDAI0CW8jmwg4whykGsHDJEtfb?=
 =?us-ascii?Q?pdCEHM8uVThGLl7GTf5P3n5l3ymjb045d4rZx5knViCLfPlLlfCihWvVDTLf?=
 =?us-ascii?Q?5NiJtkOYWsuGcQsMxSUQaJmc6q4jdbmA2t2EgL09qHAjGy1sFuN3FS+CsuSg?=
 =?us-ascii?Q?JwHtFluohAaxNBWMSq4pwYL7wLKO5T6Ar7qYMnbK+Et/Ty+CAuyAKPgz1cPJ?=
 =?us-ascii?Q?KU+Pr+lI3Yv8xsv9K6EBn1n0ya/CF23XZS0ok5Dh2c7q3O+u+xgucNGP9UCN?=
 =?us-ascii?Q?IoBVnGNZZ8CjVCNoOn7rYyHef2Cx0DfOD3imAebSvq4imZaFl4FfPxQqI3Lc?=
 =?us-ascii?Q?vlbJTFZj60O3vYiV38tnqBpi3/mnUXv37cwCBCcFP0GsBpi8aORAYLOXP+vS?=
 =?us-ascii?Q?sDeoAte9/EXJ5TQhuBpPv+3KNIg0RrANLaeK2qMIqheY1gY3uhqMZn51aalB?=
 =?us-ascii?Q?fq/RBkjX5cpsmGuDe9DvIJIh2fjKjvSZR0CB8yVAO/5O8nXJIIj40eSC1SKp?=
 =?us-ascii?Q?3Yr+j7MmZ9qCU5U7Vpvwn8Ec3Grzz4Ah2rlpT6eEg75FPxy7AEmAgGzh1lms?=
 =?us-ascii?Q?/V5kEngnyw4TCW6uEQySECB+/XpobhuF/pKf7+IEnWy7GARYSMoPS/pSF5Lf?=
 =?us-ascii?Q?yOJG6HzkyqArZbs6ZUFjN43wKhhj89KZ+YarAkwfq/6OjTapvLFZyQ7ciX8m?=
 =?us-ascii?Q?0G+BSX9FliWknWxz1yXzx5oRSnZloL5ZkznYBLzT2he1htsWmrmU7p0IFuuW?=
 =?us-ascii?Q?aVfubyTD3yifANwPsqJVnhtHtnipBqDPZfAirL++OJsHGBH5w7iBd50R8/zd?=
 =?us-ascii?Q?sNDU6No6K0dOcyiOwl7UI6ZLPVotAD3Ww6uz5HN+ZubV6wjp89SvfpwpdGtC?=
 =?us-ascii?Q?RjbmUviNNAprIaYKLcpNSfLzACGcguPL+L9jdofreSgIm5Mk2AKQBDtfObaC?=
 =?us-ascii?Q?V8OSSMrD7BLx/H0a9XjN5WKYqrdo5qUnYhTcXRY3Vuwuo2K/gmalQF6Hm1Tl?=
 =?us-ascii?Q?J7HQUCPlY1DPIYXSx/2WA60S4bdHwzvmgoAo0DQIWTb4p4I2RM+ve+62fD39?=
 =?us-ascii?Q?Z6mG2JX10UoTkvS/S8XWkqknQQxSgizbN2niTPaLRQNpu3kEifFp9s0CCkQh?=
 =?us-ascii?Q?bOSNQkvq/lFGpVssOrlATc5hR3RSO3r3Tv8X2DiFY5y/1H94/vmQUQ0tm3+h?=
 =?us-ascii?Q?C3Uu2CdBfqjzP8iGe2OC5gpxILtelnJlPind8fiw9Z7yZumKLEkyasIy6wr7?=
 =?us-ascii?Q?9cGmqBvNQzrDmDw/UKTxZzcKGqGSxDsD0RukWSHbbuhCi/SvLS4evKqi9UC0?=
 =?us-ascii?Q?p2GBk+wTdvqwYvc1AHSYjbz4tSPLJmcrthbdV8tGLu5E1modZGxp9OmIh/8x?=
 =?us-ascii?Q?qRGM9RBa6ofjlvAf5IMTE4jQ4+cso9z2WD9CF1ZQ1TanLwL1AfP2QX6JDg7P?=
 =?us-ascii?Q?cpHsOpFldjIEEqR4mNACC4XUZl8HkLf4N+u/FV1Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb1f0478-db50-497f-5944-08dc4cd81655
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2024 14:30:15.2205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1n+xXXC87FCTYy96gjs9PEGEzEvO5KutxOoM/hjfdrs317YazDJHX6WkkXZ6MJR1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8452

On Sat, Mar 23, 2024 at 01:11:49PM +0000, Mostafa Saleh wrote:
> On Mon, Mar 04, 2024 at 07:43:55PM -0400, Jason Gunthorpe wrote:
> > Introduce arm_smmu_make_s1_cd() to build the CD from the paging S1 domain,
> > and reorganize all the places programming S1 domain CD table entries to
> > call it.
> > 
> > Split arm_smmu_update_s1_domain_cd_entry() from
> > arm_smmu_update_ctx_desc_devices() so that the S1 path has its own call
> > chain separate from the unrelated SVA path.
> > 
> > arm_smmu_update_s1_domain_cd_entry() only works on S1 domains
> > attached to RIDs and refreshes all their CDs.
> > 
> > Remove the forced clear of the CD during S1 domain attach,
> > arm_smmu_write_cd_entry() will do this automatically if necessary.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   | 25 +++++++-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 60 +++++++++++++------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  8 +++
> >  3 files changed, 75 insertions(+), 18 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index bb9bb6fd7914ce..6acc65f6d00a71 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
> >  	spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> >  }
> >  
> > +static void
> > +arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
> > +{
> > +	struct arm_smmu_master *master;
> > +	struct arm_smmu_cd target_cd;
> > +	unsigned long flags;
> > +
> > +	spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> > +	list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> > +		struct arm_smmu_cd *cdptr;
> > +
> > +		/* S1 domains only support RID attachment right now */
> > +		cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> > +		if (WARN_ON(!cdptr))
> 
> This should never hit, no? Otherwise that means this path can allocate memory
> with a spinlock.

Right, WARN_ON's should never be hit.

> > +void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> > +			 struct arm_smmu_master *master,
> > +			 struct arm_smmu_domain *smmu_domain)
> > +{
> > +	struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
> > +
> > +	memset(target, 0, sizeof(*target));
> > +
> > +	target->data[0] = cpu_to_le64(
> > +		cd->tcr |
> > +#ifdef __BIG_ENDIAN
> > +		CTXDESC_CD_0_ENDI |
> > +#endif
> > +		CTXDESC_CD_0_V |
> > +		CTXDESC_CD_0_AA64 |
> > +		(master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> > +		CTXDESC_CD_0_R |
> > +		CTXDESC_CD_0_A |
> > +		CTXDESC_CD_0_ASET |
> > +		FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid)
> > +		);
> > +
> > +	target->data[1] = cpu_to_le64(cd->ttbr & CTXDESC_CD_1_TTB0_MASK);
> > +	target->data[3] = cpu_to_le64(cd->mair);
> > +}
> > +
> 
> That seems to duplicate some logic from arm_smmu_write_ctx_desc(),
> can that be consolidated?

Yes, it is consolidated by deleting arm_smmu_write_ctx_desc() in a few
more patches.

Jason
