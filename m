Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A7E1CD210;
	Fri, 15 Nov 2024 14:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731682124; cv=fail; b=qak/DuQlJY6006Yoq53sAMcbc8O9Ro+yQN3jS+XVoYwhugLpyGFYV99AKXlPB4J/5abojkbnAjRXzbNdgqQQcRWr9e000YJWaqnb9umU0DDWJhe7820m2WeUZwjr0Q6Eoj00y/Xp/YpoWjC+CMBf5RVkU9CrVt8u0Kb75m+qSCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731682124; c=relaxed/simple;
	bh=uehhb9I7G6AiLUFe9Y2bjjtsbmU+v7mKPqcMWJ1g+EU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SFBCmy0wv+ryr0cR7UjCrkhMXzVFziga+FYbynGK42BEX6nAfm0ujOyFD3lDY36yak+JnuSj3UKHvje+wIkW9bT1I9oBDJyTiaA2++45IgOxlqZarjR3IDphPfLyLomDWi3iBued/MIB5wqX1C1XCn+TO5bC1VPMJd9gDDfO74U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=gM/vRnOJ; arc=fail smtp.client-ip=40.107.96.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="gM/vRnOJ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P/F/Fp/BXsHBKnxhMS5u32k5FVirYP1nFttMJ5nogiWm4xeTZZdyL6/5P1H3I4rsbQhI0lAuVpmaOj5rF30yQnIk3fbVXiJdBvBurKlFzwQycs4RKSkvn31AiaPo0kXJNg+t89WQ0lx0O3SczC8gkyFkLQ4Am/bNXfBm3TaqdAU0qm8Ne64C9/PQf4rL2jG1wPWmG9CJ55LjFzoggCP+QQ0uMM5CkLYPBQ6BhLNcLe5t+RcZpbgdU/hkXO6SgFxyd1qJWIGngVT/ybxlFZFdzuBUb8ssrclYeZeBErq8bzK8ybt4hT0+ML26e5JFoE/2PlEqmPdQTYhsVuC4gOUFtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aTUNOjgG0Zp4JeKQGmJp1O0R3MYD+qqsIvkL7cSPS7E=;
 b=UIsw53SQNPLJ2qDYjG+NbNR6L/arpBWs7yJ8vi1U9c/ZRaIWLuNnJG7jButAeyx8/OIjlby57j4UV8ZZQX5I3Ov4367RRk7kpdi6qGVQVHzUOCOBWI5uqzSY/MkMFXAd6vgoW6EVvbe4yMTtJybrwpDPUjAIq1s16TVPeVQx/Qeih/T07fyWQD447T/6gQhTIT+MOV8GLyaXc1YDZcbw+hzslNTE7wnhg4Qs5Yf5+Sy7mcLScrWOUfMc+xOL7g5DN60tTOGv7/vP4B/sHivLNts5LeT9JZlXAhSIufjPEoIzyFAzVPqzDsi7Q+RlmiGTFLM2fJUpX4rF6YQtCcimqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTUNOjgG0Zp4JeKQGmJp1O0R3MYD+qqsIvkL7cSPS7E=;
 b=gM/vRnOJqX0lgfSQ60KXqkwy4Wea4CuAocSKGbZn0XEHoWrmBQXKl0NzEzWUAxGnPOXzv4FMHtchuBtezri4haf5mndlZJgVF7acrJtZ0CwfMTqxqB0zrJL6fUG5aBQzNtaoVv7lhCIiCL6NRZ02YaV8GAeI0wF0yUD/UuPWGIk9DTAlqL6PghEZy92k1bEAyMcmRYoynqWOfevxkkaib9gMQzEwE8QyVRbpyaU22ivsPMhB+fMGiNBah2PlOlGwNxAkdGHebopzS82pkybx6awlOfvotUx0ddW7XgS7LoanOersVy8U4u6XvnA4UdYqD+bY7XEwX13YaDWXmfEY8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MW6PR12MB8663.namprd12.prod.outlook.com (2603:10b6:303:240::9)
 by IA1PR12MB6212.namprd12.prod.outlook.com (2603:10b6:208:3e4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 14:48:36 +0000
Received: from MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f]) by MW6PR12MB8663.namprd12.prod.outlook.com
 ([fe80::594:5be3:34d:77f%6]) with mapi id 15.20.8158.019; Fri, 15 Nov 2024
 14:48:35 +0000
Date: Fri, 15 Nov 2024 10:48:34 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 1/2] iommu: Add ops->domain_alloc_nested()
Message-ID: <20241115144834.GX35230@nvidia.com>
References: <1-v1-c252ebdeb57b+329-iommu_paging_flags_jgg@nvidia.com>
 <9c065d9d-ec97-4d3c-a2af-0dd4fe40ad5a@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c065d9d-ec97-4d3c-a2af-0dd4fe40ad5a@linux.intel.com>
X-ClientProxiedBy: BLAPR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:208:32f::35) To MW6PR12MB8663.namprd12.prod.outlook.com
 (2603:10b6:303:240::9)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW6PR12MB8663:EE_|IA1PR12MB6212:EE_
X-MS-Office365-Filtering-Correlation-Id: 065150fa-8060-4c69-6641-08dd0584952e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A8HNwFmsvBiFE3EN+mivQho2xG3VsfpjVS5JTQ//AWSu+6IrdPhamQmTmbkY?=
 =?us-ascii?Q?aVFg+PHkv0d7LCRL3CNPq8yqii7CvxPRj51xZxajC/8vFeExWDSKQJJP+P7b?=
 =?us-ascii?Q?2FfSXPSsx1AIX1ndceyIvbzdpABMe8rTp7OyFjQWVfj5x4TNDeK1ns9raQ/i?=
 =?us-ascii?Q?5fyTVDKfB7jP8sQgfn8TfBrvjxf9nnBe8S7tjjFi9qjEpiy2A9QyR1w4v1/X?=
 =?us-ascii?Q?B92c9HRnaqS0TQOyiNL+DCFARsKdWS7L+TmstSEa79uAR/hZFX+gwzbCVD26?=
 =?us-ascii?Q?wS0Bs1W0VcZRBDEKpvNNIzUKrD0MJNC5ZuDKUBMmyJ+gTblnHiq4HDnCC/J1?=
 =?us-ascii?Q?PjEzKLCHdhVF5uE69z5May5l0AC22oAN2eMC0LdNHPAKCuqMLv17ID3WQpFW?=
 =?us-ascii?Q?4dNoUuZkMLD9GNLOEWcNqPaIFQScSIiderEWNwhDKQStfxI43tHvOR4KdcyB?=
 =?us-ascii?Q?KMCukfxbtMxW7cdyZRSrhxRUzxDd6jX9mG7YIeYrRR25t2/UCBR8fsBnX3OX?=
 =?us-ascii?Q?N8LuxNvsAQTcIOszyHM81kndrvbOBLJaxgU/UZK7h1Y1UjpIb2Tkx4JgbJ62?=
 =?us-ascii?Q?ukcfXCgql/LerBgWPYjIcvtG6SS2nbep+cXK69I4IeqTKBc7m6E0kt8qM48y?=
 =?us-ascii?Q?OhEL2dJbELyGf1Su1Ccpge7slKnHACm0/RNYHIfRqQrS/qKqzvut0yxJwd/n?=
 =?us-ascii?Q?ZU+y7+paXT8iZ7R3w2y57cUTTMcd/vOGfFRshRfneOdVozT60SsWyIemgGLn?=
 =?us-ascii?Q?Xxo6BUszxydO/d+kyedKsLmsjl9fIXFczFpcpuQwYw2fDCs3BY5u8eNFXZLm?=
 =?us-ascii?Q?wagws+y4hNKn3/RqCIOIr5nCBnIOin+0HA93DkifB2o9FfQ0bf7F+mgOmudu?=
 =?us-ascii?Q?07qxdCqKlVND74XG+Glfb6z7h4RFH3bSQmEfuPe5/MNFGu5NwPppwruDv7+a?=
 =?us-ascii?Q?1ZsnB3+ELf7BhYTXp3/vOjim5FeV607JYA64KIboqsCn7niUJygmKPZkPcOU?=
 =?us-ascii?Q?G64lESDI8Fwtc0rPoHfrZJLO08SOOkKuR1xD371ALa0CvUtbOqsv7mxizDT6?=
 =?us-ascii?Q?gDZZfJA1zEsV2x71w0KgqjupWmT5Y0+mdFcK4Rzl90UJvP0DB8Evt6eE+tLk?=
 =?us-ascii?Q?DqyyXVVE8SnP2y7TDYjI9pyNYHzr7FZ8KsprzjUBIhuxRrwT++JUaHIXIVhF?=
 =?us-ascii?Q?4xsTFSMNjnhnq7MoOW62kaJi3JJwB+eIPUg+XfdQd3pnkD0JoN+gD57amxNR?=
 =?us-ascii?Q?E2r/zn5+4dRxYLLtmzMQORvONc1yMl2X6R4v/M4K1QCAfU5QzlU/mNVTyIxp?=
 =?us-ascii?Q?8Ng=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW6PR12MB8663.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sm6DBXXQiu7mOLi6vXc6N8yTHWVHSw+MKRuuIgcoaECMxz8c9OpxBgTg7LPR?=
 =?us-ascii?Q?Od0voGwowVMXDCrij3tgQyeGo280iFQcPcCa6SSE7mAnKr/OvxQ49oBXI0QN?=
 =?us-ascii?Q?0FC38ZHGq7BLfKHQEOhNIz1pGdBJFtxn1TgWS5pPhLqHyJeFpcU3Ec2LoGnD?=
 =?us-ascii?Q?wnwoqUHG0bD6YFcf3ch1HdVeVx5I6kqvpfSZTmY29upXO+BpGqvJeHYARC05?=
 =?us-ascii?Q?HGzZByG0TAssuUQ98Je1gXApugHAICSI+HSLbYGO4HULf3ug//KQoSakrK/E?=
 =?us-ascii?Q?lBrg87+GFI/O2WhmrXApKaty9CZ+wiNAzgGu1oFANDhGMErYPRg+N60hkppK?=
 =?us-ascii?Q?WQSdWmIWLePA/Yxcehg4Du3HOpUZIJC8AGLGwfKCpe3uj0BB5mbMDLPdDYUz?=
 =?us-ascii?Q?VaIcHb8JfMWxiOvMdsFvkabF692Y61YgKeXFREMRBYZbHFJAUYBAsvDIW6gv?=
 =?us-ascii?Q?CiS0u0AQnq/HRSVSQ6M4Ayc2gdIE4OQ41EvzxaqYJH6jzGAY6LKSF/Bu9ozu?=
 =?us-ascii?Q?gx4z2+ntCEV1vDEPse+jJsb+fBLB2TPc4f6JCRPyW+q+uAIvEGaRkZkCW+Z8?=
 =?us-ascii?Q?8egR/EcHrtYi00d7BST8xqeL+vPGs0W+RevY6ovzUWvXoSftX9WzrqYuN5gs?=
 =?us-ascii?Q?0DDwn+IL50UaXxQ57i2bqnnjBdL4zI+9//Jz02DcWbMu4Vp1UoUz6TA93FkK?=
 =?us-ascii?Q?+iv/ebuD5/eBDU7m1tf1ydEvwu40L8fYNpHY53Xdc1C07OPpZAZ1ivfnlKM/?=
 =?us-ascii?Q?K1usvl3usznbjvpIaoaxgiyp/FlwP3ioAnxedCOgCUB98BOSMUH6LnpE4jc1?=
 =?us-ascii?Q?LbuO5m4pFciKwJiZAXxHT72bs4XdHZ3IkW4iR2C8NMU36+h+wCO33tOVGz6M?=
 =?us-ascii?Q?V+i7NKEddqJVYuImy2gWvvYQLbu+gB4d92YnvA/NWSnbbU6mECYEXwVOHrVO?=
 =?us-ascii?Q?u+Ay+fJNjAVKmEEUJ//Iq7HyDLdCKUF8t0qKWFGlKHQkZOsGctZL2rc7v90G?=
 =?us-ascii?Q?g1vvAWTz9FMY5nYrnONvJMq+kxxtJIlSdm4i+znXEJKI9daFEEADy3K3JYXL?=
 =?us-ascii?Q?piZljzNAw+YoACKlwTgn83KZ7BWTFAMcF/lKadXcTiUUbKOE5z/R2NzAb3yq?=
 =?us-ascii?Q?xZpATYMvThB8OIUW6ogvYIFkUMxDA29nYrwA189ZL7K5/qIsfq45bNdORBLE?=
 =?us-ascii?Q?VRyJcjKi5v7AmdSg5C3G+Oxp1KP06fu3Js9E2Co4tonvoZ91wrfF1rSkL5j1?=
 =?us-ascii?Q?SFjzR2RxfWvTHqWF5IsLG7+xB6RZxHYruuN7SpX1qcN8XcfGtfrnddNOvWwL?=
 =?us-ascii?Q?RUzPKofPOlV6tXkWlqJaJ4kSMFh+xFHHDuz4rcUqrxgF4mM+1y8e6mKh4u8u?=
 =?us-ascii?Q?Up+qMzp0VxCHAjFhTWsGEii099jlQ6wA8gzCZcD2ve6oKomKgzG7GQaWsDwb?=
 =?us-ascii?Q?4Vp3UYjiWcJzMlNRvA9/Eq6619HH3tg51n9M4iftaeVXJIAygr5+fDMpgQJP?=
 =?us-ascii?Q?LBw5GgDc5+x/YiVRBwAAJj4m4uhaVJT2IzcAfkiU0Wj08H4RxNGg6ZIzfqoZ?=
 =?us-ascii?Q?UKflt7zKpE2XFKcOToI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065150fa-8060-4c69-6641-08dd0584952e
X-MS-Exchange-CrossTenant-AuthSource: MW6PR12MB8663.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2024 14:48:35.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJ4alIjaGH2ZmSWHV4vwsBIeeEMl9mNLYCcJbimvI0c86u63TC/huye9zhe8wcrV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6212

On Fri, Nov 15, 2024 at 11:19:03AM +0800, Baolu Lu wrote:

> > diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
> > index 42c4533a6ea21d..aba92c00b42740 100644
> > --- a/drivers/iommu/intel/nested.c
> > +++ b/drivers/iommu/intel/nested.c
> > @@ -186,14 +186,21 @@ static const struct iommu_domain_ops intel_nested_domain_ops = {
> >   	.cache_invalidate_user	= intel_nested_cache_invalidate_user,
> >   };
> > -struct iommu_domain *intel_nested_domain_alloc(struct iommu_domain *parent,
> > -					       const struct iommu_user_data *user_data)
> > +struct iommu_domain *
> > +intel_iommu_domain_alloc_nested(struct device *dev, struct iommu_domain *parent,
> > +				u32 flags,
> > +				const struct iommu_user_data *user_data)
> >   {
> > +	struct device_domain_info *info = dev_iommu_priv_get(dev);
> >   	struct dmar_domain *s2_domain = to_dmar_domain(parent);
> > +	struct intel_iommu *iommu = info->iommu;
> >   	struct iommu_hwpt_vtd_s1 vtd;
> >   	struct dmar_domain *domain;
> >   	int ret;
> > +	if (!nested_supported(iommu) || flags)
> > +		return ERR_PTR(-EOPNOTSUPP);
> 
> How about making it like
> 
>         if (!nested_supported(iommu) || (flags &
> ~IOMMU_HWPT_FAULT_ID_VALID))
>                 return ERR_PTR(-EOPNOTSUPP);
> 
>         if ((flags & IOMMU_HWPT_FAULT_ID_VALID) && !info->pri_supported)
>                 return ERR_PTR(-EOPNOTSUPP);

I think that is possibly a good idea for a followup, but right now it
was left like this:

+       hwpt->domain = ops->domain_alloc_nested(
+               idev->dev, parent->common.domain,
+               flags & ~IOMMU_HWPT_FAULT_ID_VALID, user_data);

So you'd also want to remove the FAUlT_ID_VALID masking there to move
it to the driver.

I'm also wondering if we should put the pri_supported concept into
core code flags and have less boilerplate in drivers.

Thanks,
Jason
