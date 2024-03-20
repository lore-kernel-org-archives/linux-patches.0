Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2079.outbound.protection.outlook.com [40.107.237.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C846A8DB;
	Wed, 20 Mar 2024 18:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710959763; cv=fail; b=sHoN8qVDEfAQPZ+IPMAL2EP9G69chrrWUCTXukESklz/VlXBuCzlIqFNYZB4U8cmPPCd39E1bf3lS+lhT/l4rs3Ai2l2BWdHR85XDZ+gcbIMW4WiCC4DsLFEYlPrw7nFtJkbd/5ctp4YpBJWMD1T70FZ3BWSTaef4BwnfkaIKvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710959763; c=relaxed/simple;
	bh=XxTK9zgaU6GDeUkToZOOjBCUA8T6rH5trfPSK5UF91o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=k+J4xj0vNztOu6s+zQI4DpUSQ+2h6/G4LPINq3b1OVeYUP8tx0+zZOnyQfRVsVLou/NPHgOEI+ewtbBuv80dNyOiQ2aPZI3MGHL1y2KcPfKVCCTRQ1E1k77jzViCvRh6a1nQavo5e9CcwtDjnhq1FPaHcvU6RdRFlhIMNg7eLfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=X0FzOKpI; arc=fail smtp.client-ip=40.107.237.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="X0FzOKpI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5XF7hisb16vgRFHK1l5qoMhIoBs9Ial5tt5z2E6c5cnUNZkOFmZuX3Lrms/XnIpYFhYrUm2k9n4pC6zHAyiIrIUajxqCSnDwOmUko/ige7srF5MJtZc9z5qrK2sK/gNp1+8SMn90lS45xYKZOzaz62wC64QXOEW67IbxyNiZ0wapVmMl8lB/dK+L4whYBLZKTQM/Kc2kkTbEtZxp6GDP36SU0eIYgyeMQgaxza+ZfK4e4D3q72MSMeKPngxIGNWVZzfKsxF22/c7TJYaVCxbhVCdcvHOkcYrBrdUb3YQwEdZsgvBaPoC1hjKuN1UeHgIBKivH2IEoHHsFli2mLMZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mK/VOdK6yBiOnkEA/y+YgZNeilmKXKn0rW6isxsRY2M=;
 b=BEZChIUha+nlv7DSy96niUwm5n+XU2nvfNEgYOY3LuyzO9aUvEHjl/g9RAd9sBIVg0Ff1vM3ukZa4yBAhPxqZ3NBv0GFxJigE/eIXyQpDmnhgLMIy2hy1thT/icDFx46ooCalO/CfH9KtjOGJawUNnLZJKcgNG2PHO1Pu73czERW8P9FpRyDCqwDQLOzyoSH3rNErsfYyNt4id5/dGgzjMxcAryWa5b00DOYVA//w9P6/kSWxGaOSiWarbpgzEl4hGrxyHw1c/YalfZnlHygv88anQqVAyXACD9e9LKP1mYWqb6xVQmI6yq4F08buVTXQR29DmbcyPjlJ7YMiTr1WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mK/VOdK6yBiOnkEA/y+YgZNeilmKXKn0rW6isxsRY2M=;
 b=X0FzOKpI1QuIoWRHr/+fF0fPlMRmFrASNuOPqwLYWACn3sMaHANa9Id0WELieanwtA1dVCVm0AYwflbdgN1BrekH9AuyJyjxcnVZQYdpPkMrbGzY8WERx3khirYtUXIBYM1V7Q2UuWxQkpsmeA5lXeVuN7ZYNFXGCwcDdDAQtCeUxfUUh7Md/JDHIJ8jHCj6CZEbnPdQyqdbXSuLHSpVRu5gBEhacohU6VfSzJGlirk1IgObd+heX2tahclJ/Fypn7LNe7yx5c+yheoCr6Mq5e4xnaeiT2kRNOg6s1yLFhFlLMxh0/qgyRy4Uuo+8Y5ihEg+1u8MAQaF/PVCKhheHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4388.namprd12.prod.outlook.com (2603:10b6:5:2a9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 18:35:58 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 18:35:56 +0000
Date: Wed, 20 Mar 2024 15:35:55 -0300
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
Subject: Re: [PATCH v5 21/27] iommu/arm-smmu-v3: Put the SVA mmu notifier in
 the smmu_domain
Message-ID: <20240320183555.GH1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <21-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV24+c4ZB2ehRgp+hRX4LcQtTr8ZeU==+==gwbT+-J28Zmw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV24+c4ZB2ehRgp+hRX4LcQtTr8ZeU==+==gwbT+-J28Zmw@mail.gmail.com>
X-ClientProxiedBy: MN2PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:208:234::16) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4388:EE_
X-MS-Office365-Filtering-Correlation-Id: f8474b78-c378-4fff-5b27-08dc490c94c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	CaT/AAftGKuJgIWcqYm7RZkUdN1d8/J98pn79z6GOrdkZfLW+UvfkeWrvOI68GnNacdf5f4c6L7NMVT2Em5WwVVtyuF3QwmYVLBEfKdrL8RII/+YGLmKGyuATy/2CXxQUVgRjRuAg8qidRo+gma9hOdI9uCRs6kb0LFzOiJTYNFEHRFmvKLJxcedj238yD99UJrrf1r4iU5JcgjzIlCtiUzqz9lSgxamcnYeiX2/ToVF4IZoBcHhULuOK3VmrfEHJYP7GGVVDAkkmcMmHhkn1KThxzxWTC3CqQaL/UleqCNGGHa/yxOjWhIHZeS61d4hCS3bZgvRAp2ueG6t4KStg+HPoyur/9nn/Lq/2VbW1zDVq5P1kfSqv44250ZSMZVgIxvBQLiLFIS8/WNr+cwcw8/HnGAVAWClPw0RQQaQbh0CbwGSgTOcoq2copqkmKm6zGgqlOCJjkOxs246XSEaMP6aJ6mzTyH5kruDyNw7bfVxSDYg/LCn53phSwHXymnK1hnhCPZLQ+H58tBmD7ik2j4rOws6OYIC1eNoji+bLCA2i72PQjFocd7DjT1sBD4gd7FsjkKH9Qoy/wYh4tI7h0Fn5nPz897fkdNc8TdEaClRatH73c70RiY3oJPoXHtY4KOQGss2rQwj4Ix3UrV+b3GS6DZyQsq3DV9VtI6Mdys=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RCmK4Dp1VgdJDTkPeq3DaFoqnbGe1dTAbfqAlInjmeFgf3C1hWtaRuGfPhFT?=
 =?us-ascii?Q?xnQH88FEf9V6NXkrcKyreimz4S9MbKRBDCkfqDwpjptMdLKMX5zixEViYxoM?=
 =?us-ascii?Q?a0C6eyEppQbA2RgZaB6sJ2/r418TLV2wICgQFpFvwog8kimpgcq+aF0aEM1O?=
 =?us-ascii?Q?O5Kl62+QLQ7f79cFkmI7PY/vCFpKVD11ja/qyhR/Pf2+YWTY80er7I4RxyJK?=
 =?us-ascii?Q?6Y9loDZFXL7jWGgTQEDoWLgworsGj1TI1+OATWHvrbRIr9hwXdQXPCnkgIRa?=
 =?us-ascii?Q?761qPL/ZlaPVZsyaP2WAJXqOT0fpdsN34gy/rz4znXjMv6zXFlOauhc5+twl?=
 =?us-ascii?Q?PcyC5rAiShl+MoK/cbIpxPT07lJImiuUo1LzPe72/Foh9UHm8Cm2lqpQzXIa?=
 =?us-ascii?Q?SXOdR79KMVEAjOlfrStiKqtgYf6RiGMzJiWZn6RR+nfGTmLLscIdmV9iDy4B?=
 =?us-ascii?Q?gYGBMnFM8UPbKV64cs14A13vQ/9k248vQc8dbnHP6ixSC9JMMUwYRcO1hY7D?=
 =?us-ascii?Q?fsLhsTbUTucbOY1mF5LKbzwnUZrphArSDZi/LIinNRrSAtIVaBHgIucz4pDu?=
 =?us-ascii?Q?Xu34u5eA4gp4DpAs6eoygTPF16UiaduhHNmmc+hXhiszfqncqJ3+APfZU0vd?=
 =?us-ascii?Q?CG8ddQZBaH7WZD34uiGJaRYgXdUMOCRAAtZDa3Upf/sXzN21oOC5CTpxFV9R?=
 =?us-ascii?Q?ma563JDWyg3gNm7LhNYmDBbjc80jaMaKcI2+CFce94WL83FAmPz8Kdy4stBe?=
 =?us-ascii?Q?XtLKoTh5LJayvomvcThQhwGFvDiH3oE2YlSA8XRlWnpIiz9bHBaogYAgauWQ?=
 =?us-ascii?Q?ievatK8Ox82giqcgaQGFY2I2ij6PWqDDsDsI6eWC/FsAlI4LAy8obOHX7W0e?=
 =?us-ascii?Q?UYIJPNVZy1q5u1sTpBS4dP3xY/35EX+2yaxL4BlmkYLyZKFnkag5P2VCZMrX?=
 =?us-ascii?Q?FznE7r6OjDYLQN74FYKinmipIb5IQdbWWQZFXs+Z3TOtxVlf2xSE/WXmC/S9?=
 =?us-ascii?Q?ZwY4tQy7zdl5XsgON3/bvjDkezDFO4uk+ja2YUYurydOJ0aFhIwk2QmPUYjR?=
 =?us-ascii?Q?iKJfTSNVH7wxO9pLPLTq954/ukEI2JD9/JhuNZardFd+ehJkoaAGrQPOMtEe?=
 =?us-ascii?Q?n0HpMqzPAKrFeWyIxqSZJHDyDvuil7h1ZJLNYTMlXHT26EQYKSAKsSOt+4Nd?=
 =?us-ascii?Q?WIhlPhIrHwzT+nRCWl62DZlcBnr8m/v2IG6HTs+osU9LI6XK4TGqlOl3Rdz1?=
 =?us-ascii?Q?Jr8XSyIJysc/6Gqvu+aMN8WqxasECOL4joUqctHdqy2rGheN+hINI7ILfMb4?=
 =?us-ascii?Q?oJyf9AkDk8C4xpl8ayPFN+NokpH4cUiAsDVJizrwe6r+Bvvp4rbBjwlUPbWW?=
 =?us-ascii?Q?rh8s0FJ4CIZLmr25m/00XNba97T8IyDZdPcybw9pMZ2tPM3wYrGEOo9ESZRZ?=
 =?us-ascii?Q?PXGbQwV2G/hOa7v7iCVT5s5UMFwsq6UBZsBrkHZvYz2JrtG0Rdi+JtW2MJvw?=
 =?us-ascii?Q?2lfeOwpnnfF8lEDBWbZLcAVjBNzUhcW8NM4vBFmV6Qgk3TUZVWEuFuPb1DPa?=
 =?us-ascii?Q?eGALCcKLfL9pyVrqskd7/L01gBrQ1xD26dWcgxsk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8474b78-c378-4fff-5b27-08dc490c94c4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 18:35:56.5882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ayvCvYwNlrWjSq97096z+lfjBp0ghBu6f+eBdnHwIMKnDYlq4dJMn0OC9KwQwhU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4388

On Wed, Mar 20, 2024 at 12:23:02AM +0800, Michael Shavit wrote:
> >  static void arm_smmu_sva_domain_free(struct iommu_domain *domain)
> >  {
> > -       kfree(to_smmu_domain(domain));
> > +       struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
> > +
> > +       /*
> > +        * Ensure the ASID is empty in the iommu cache before allowing reuse.
> > +        */
> > +       arm_smmu_tlb_inv_asid(smmu_domain->smmu, smmu_domain->cd.asid);
> > +
> > +       /*
> > +        * Notice that the arm_smmu_mm_arch_invalidate_secondary_tlbs op can
> > +        * still be called/running at this point. We allow the ASID to be
> > +        * reused, and if there is a race then it just suffers harmless
> > +        * unnecessary invalidation.
> > +        */
> > +       xa_erase(&arm_smmu_asid_xa, smmu_domain->cd.asid);
> > +
> > +       /*
> > +        * Actual free is defered to the SRCU callback
> > +        * arm_smmu_mmu_notifier_free()
> > +        */
> > +       mmu_notifier_put(&smmu_domain->mmu_notifier);
> >  }
> 
> I'm far from familiar with mmu_notifier and how the sva layers manage
> its reference count....but is calling mmu_notifier_unregister instead
> of mmu_notifier_put possible here? 

Possible yes, but it is not good for performance..

The reason I created the mmnut_notifier_put() scheme is to avoid the
synchronize_srcu() penalty in places like this. We don't want to wait
around for a grace period just to destroy an iommu_domain.

So the put scheme piggybacks on the call_srcu that the does the rest
of the cleanup and we get the last bits of freeing done asynchronously.

All of this is because the notifier ops callers are protected by srcu
locks for performance and we can't guarentee no ops are running
without a grace period.

Jason
