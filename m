Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E5E12DDAE;
	Tue,  9 Jul 2024 19:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720554738; cv=fail; b=uBszgYPvE3Kt3mvYIisNRNCupZ0+mwnLxA0RHJj4QQvhwwNZo5IH2bsFI208F8DamBBUwTqNC1xx1LbPY/Q42aYTvYcIPTenL9iCDrAZJ+pdhQ2if9hw2XRHORuzn4J4tw877+2rwzLrH3ofxDLyoeTpjOPpnbQn2r5vNluNOAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720554738; c=relaxed/simple;
	bh=BTrg41FSn3N9XRyekj/idO6VAUmtYVmmRc/KMz9qWWs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=inMwHZ6VvEYH4BV88MyN9sUeWdFgkTfE/KqzvS3QVc7Tji6e8ma+J09X/UjYZazGBX1fWLMpgEMUV+8Cga3q/k0riBHV1FgSUbTmW7JezBCRukIOnwNHDORx8V/XVEc9/u3IIzCGyX8QFMedcKBvQIMsh97ojlK0iHriv2BIG+k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=dPAxSNT6; arc=fail smtp.client-ip=40.107.93.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="dPAxSNT6"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrNKKBozfOAYUyJfJFzTgzJDTFbs/6oW50dGfYqQuIwMu7JzBwOztiel8GCmquVI2hQzDJcqeEfZYHerEdGGdCUU2pneSbPAOK2pAhGoOLn2LpRriz71r9Xn3egzkHJ6fQd2lidTs1dx28XSOGY9RF2ZYMA2+FjQqidct0qxqvEd2u5659deNftHIRIbYIL7A1I/xJe3VyfRdBUBvdCYrIFBKb8P6tSttoG2EqX+IBd4o6obwSl00r+IghAORi2X66glzDRycJlirsayTFKSWrH0T0zvPKGte3EAtetzP9+OCavXdGKjkcmTl/hLqhd+lKUSg/g5o4ByqKIQnYN+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GmJ1apFRFEbFZCgGzkAQDN43XRIz4JvVhmC0OWfle9g=;
 b=moJhsUmf9DliOKe/vGIlZJpFog4Dyx1kXw+dTfdCv/LAgA0ZvK1PrYI7AhdQpKELZjmoXbcdS2vFiXdhAevSkzk/7tMIxnttM2rDl/R4pG2NjuIlRhU2VC1lSYjbU1nBLzuTjVGvmPTQ8g8ZJh3Tqtd0ZhluDAjfdpkEOg7KZMt1oTKFnEKa267cvOzwP5kYy1oLODDYKpM9MdSCFz12VMnbpADRXlVszwf26F3gUsB7y2jue9ykgtxohbDFfshxoVOKoWSjo2v7Uqh0enTdh/IsXufZxGMBw9LonLv74LT+ExElqeb1uwDv94JwVqaR5GfwF3dCKA2oaw6xB50R7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GmJ1apFRFEbFZCgGzkAQDN43XRIz4JvVhmC0OWfle9g=;
 b=dPAxSNT64Kqdnb9VY+YNbqRUH7S7fE6oLq3WtWq9KW1U5oWw/wtcfuBz7k9dMEozVmOy6SlhGnd5Ibzl5sh/nnyHnesmDile1rkZ6lTdt/8SiTJ58DA9yyXsz+0hUCodEJNbr9gS5waMbEBRpMylDG10gnCd88vevqgZ3PZgyKW9XvYCbVTRxRA7MU6l0FsgPmrijkQThHkXCGlkADWOcaPyRqO8gzufmSMxTFKTWwlib9wOYph9CtWssqF5L9iwbfHXKfzj20R+q77+FgqLLAAaFukvWZUVSiOoVE1RjvSxxZC+TixUaU1pjdVLQ2cOZ3euJRohCoipxn111Bgf5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM6PR12MB4419.namprd12.prod.outlook.com (2603:10b6:5:2aa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.36; Tue, 9 Jul
 2024 19:52:13 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 19:52:13 +0000
Date: Tue, 9 Jul 2024 16:52:10 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 08/10] iommu/arm-smmu-v3: Shrink the cdtab l1_desc
 array
Message-ID: <20240709195210.GN107163@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <20240702184607.GB5167@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702184607.GB5167@willie-the-truck>
X-ClientProxiedBy: BLAPR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:208:32a::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM6PR12MB4419:EE_
X-MS-Office365-Filtering-Correlation-Id: 2bec9b24-97c6-4695-afe7-08dca050a079
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?69tAIu9AC3O6tOM4wbOql0ICUL4aTX2qV8mNWe+W0znl8d1o+biO8VmcJ5cU?=
 =?us-ascii?Q?0+zgYq0XmSPXG+T1jN1fh7NYL0e/G6mWXiZTXHPrLpMzw5FO1IJlLix8ReuQ?=
 =?us-ascii?Q?1416IsLvjdi0/SYA2ynzYE6Sq5g4Lv/1dEgSpGr/+cuP8N766JWN7vd/w/RS?=
 =?us-ascii?Q?iTMBJ02XwzOrUbon3ptq5Wb7aoleOBUDq2CFPA2Px0dPUlikaxc5DU59P4b+?=
 =?us-ascii?Q?jYCSfkVqs5Kx1xn86a4a35TebUIlUJGlGnio848Pn0c6Y3wItE13rm66LxS0?=
 =?us-ascii?Q?3xMOv7tP9WwaxZQSYWvP5CRHLTlwRt2sr6rboIyoHQguKXOeXlxVfPBS3v6V?=
 =?us-ascii?Q?7cDcbidQuRklChQ31jFoF5i9FSoSq2jmggXApQ7cnq3ke0MgN6y89d3IiEAb?=
 =?us-ascii?Q?d0okUbJI+AlJJEVmqnnaZZnFYmJZI2rl1Q4Q9XTTdKJ+LxCjTegGeBdKTo9g?=
 =?us-ascii?Q?6WYe1N7pMPG8BDOCDWFpNmir97Snk1lNN7Kzu27aXviwtc44GLFapMoHTK4o?=
 =?us-ascii?Q?IYuV7iYtw7yuaKeFqRfx8jJWfn0a4oV2u0g4kwTwJbOduOVJGGmwUbrwI85s?=
 =?us-ascii?Q?C8zdOaPnyepkkMQnq4tIZpgdrz0hRjZ04yTjmE3x7UGQpJxOdaAwGGj629BM?=
 =?us-ascii?Q?ekkhtNVk9nuNDYdD7vMLUSveQu8KYWsOs1IWmcuZqydO3suamuZLNEjMWzDA?=
 =?us-ascii?Q?duCpiMaTEl7dYSJrSsr9nhMcBLnbE50HEWrwaDLnl+Km08vz8Ufnyps35uRP?=
 =?us-ascii?Q?GOwj2Ylk1+JTgpfC82aM2/3HurTxv0uP6pNEk5lLs6yuTZwl5ZI74KktjXct?=
 =?us-ascii?Q?AuYOb2Y1ASC2D0MOnRGN9UJpAVIgAtMo4YOONklZAWv0JNhXPBB2JLqhvbWM?=
 =?us-ascii?Q?Q3R76UFdvuVNAqkHp4E2l0jyA8TMfhF8BJEcVYTi1F/jKHLbRXz3NiRZpu4U?=
 =?us-ascii?Q?sXRh4F66VGGwLFR+G++Sc345iEMClN746AjYPGFBbjBuRyCq/xvdtteSz5hv?=
 =?us-ascii?Q?ND9AeWDDubGWtyrLr4gCKtb7y2dbBDqqZCo8krwunUXZREuhiQlN5IzWG2Mm?=
 =?us-ascii?Q?UBx/UzhDz6tb3AKg3lKFhakWO+Cm0eoBKMi2wwnh0i+jKD6+P40nBSngRY6g?=
 =?us-ascii?Q?CDdez95FwvvycN9ua/2/VUwfQ1YRWkCehxduzY5aUCQdBhxV5kOqd6l8AaRI?=
 =?us-ascii?Q?SFs1+2hWITbMRJPxP0wv+3/n4byKx2mgCxBMj4j9y4sKtDjNsj3SD2D44mg6?=
 =?us-ascii?Q?vln3r/tK82k6Tr3UDvzl8FFenLLi4v0kiG1Ft/yNNVMxTfRWhRLwcbRx4tiP?=
 =?us-ascii?Q?OUsRh9YG3TvZVlu75XPY8kw8gt51zHXSriQNp76TU9B42w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HAQqX4fjP9zu8eFxUSopZvcHLkNeN9AGrf6y+QAjvKMLtG19P2e0eK9wZuJ2?=
 =?us-ascii?Q?yS8RhYihUh//ynmTFi5N4UN3PVG9CLAsYs6er4FXsvoZ/4Te8+cHh1lbNaXv?=
 =?us-ascii?Q?XjeOcYXrJSkV3s0dDg6TQqJYrevJHq8j00l0Cp72LDPAkMuS+AlhmmpS/Kti?=
 =?us-ascii?Q?fJQ1xZJeLYohijqdh6DUIkwcn9oBiQCrf2H+obqmBKCVtRlAL/Mdqh+IYpsh?=
 =?us-ascii?Q?s8sdqF2LOhoClvlf/+mtNv8QRuzz5vB650gESpLRxIwxD//rPruHd63l15N3?=
 =?us-ascii?Q?SvqI3STXy66IWSDyi7wtsiAFam7qGbAhJkCxixD/l2jzMnEcpmXiVdr5q7lP?=
 =?us-ascii?Q?eV95MwCE95lpB24qblwSe8x1UkcRdtGnAeEDXtYUf6kHzxge9bC8sVb86Pl+?=
 =?us-ascii?Q?/N5KYR+7jYOAjV8L74p6T8LIzxdwfOlDVqVjZJveo1sAfXug79gMfljyiv6X?=
 =?us-ascii?Q?vklEQ70+5SQrCEe0XKu2aMr/zyjKL/TajnpVXYrc70ulqGXyosTX1Nq8hW6E?=
 =?us-ascii?Q?PWrN/gYlWfx/1kEDNUAJURadRQPvYxTrKdvdEUxwT4KG933RvtcKSL6Wxtr4?=
 =?us-ascii?Q?e479qwHXfIwOftG9ptEXj+6SfFDUQltQfnogS3NUVHEYaDzx2EXfT2DBmL4X?=
 =?us-ascii?Q?++qzavu7P4Md3a8ZFgw2Cab4/e6YxWNXXpwrP3QyVLMCWMJ5ewvAmj0JaJhq?=
 =?us-ascii?Q?lq5v32foLdGuBJL2Ln0TIpDkYz5IpmZZEeWzosfVNBNu0QI79KZqGlizPw6w?=
 =?us-ascii?Q?vd77/l/PRcZkSLuZrD5yogyM/GLEwQ42JYrm3J5l4gF0ltk8KqfBwFT3/Hih?=
 =?us-ascii?Q?ZyIuXpPIh+g0RvykXQOfd9nPsxC6Tz+G9Z+nZ1oQoFLug2/xBQ3sOfRqdK44?=
 =?us-ascii?Q?IKLxXxRZXiUQZtlFdC6LLjqU44MeR7/f641VAvPXpDQKAX/bbAm+YmxjoUbN?=
 =?us-ascii?Q?KEkT1klgHEI8209SeCzKuxuLPqdwGt015NhORLJtz/kAv2I/mhHzmBMiER4R?=
 =?us-ascii?Q?csF6xnMLR4+yelozrzDjiXB9aBydnb9MLy0ruxl9puWXAH2pyZrkbLfFd2iE?=
 =?us-ascii?Q?MUtrcPUMMMrf7JXBsu/KKiJIReUilkvj1Ekpx9d1jZ9k3KZKRL0P2zOVK8ZV?=
 =?us-ascii?Q?xBnbCRnG3zbJJY0IdxZR8vC8h4MhIr1InA7Hi0JAXs8el57IPCCNLWeVD1xG?=
 =?us-ascii?Q?v4qSAe2aKbEvD+xDlHLP2O6+62TYy49mvSNfERrKOT2rQblZaWTDT3YUr07M?=
 =?us-ascii?Q?DQCdaiDqwV4dfWjhrbndDwmVuc5qYFTo6v9eN8Sb8NWnReSUASaYmNpaNALK?=
 =?us-ascii?Q?Msp8506kDbbkpC8Y2kRoBvI+McluA7htMYCrECYSS4F5IOp8qdow6X9FgcUP?=
 =?us-ascii?Q?Mh72XMPmusj7jjwVi2vJaJHopJ903b6jOe2ryDXarIk2CT3oECym88hH8w+i?=
 =?us-ascii?Q?ddmhiaHUCGSsG9THpQbZ0X0ext8IdH58YLRSgIgXK8BTdv1WsJS9l1J9D5by?=
 =?us-ascii?Q?htxbWDObPqEdNZ/cn42/5bQv4CljcvID02rbjSUMqf1XnSML9CmbPot4Gs05?=
 =?us-ascii?Q?FS/TEMG6fvQQy3jDYeEwjzlmegSk90Xu8UyVbe5i?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bec9b24-97c6-4695-afe7-08dca050a079
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 19:52:13.0946
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NXY1nBHI9B4V17UNxWvwiCrljTRhTmMo/un+4oJrsWvxqfHLgwYpLzuy/NEtFmui
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4419

On Tue, Jul 02, 2024 at 07:46:07PM +0100, Will Deacon wrote:
> On Mon, Jun 10, 2024 at 09:31:17PM -0300, Jason Gunthorpe wrote:
> > The top of the 2 level CD table is (at most) 1024 entries big, and two
> > high order allocations are required. One of __le64 which is programmed
> > into the HW (8k) and one of struct arm_smmu_l1_ctx_desc which holds the
> > CPU pointer (16k).
> > 
> > There are two copies of the l2ptr_dma, one is stored in the struct
> > arm_smmu_l1_ctx_desc, and another is encoded in the __le64 for the HW to
> > use. Instead of storing two copies just decode the value from the __le64.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 41 +++++++++------------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  1 -
> >  2 files changed, 17 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 6245e2558e6a6a..dd65e27aebafd4 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1167,31 +1167,19 @@ static void arm_smmu_sync_cd(struct arm_smmu_master *master,
> >  	arm_smmu_cmdq_batch_submit(smmu, &cmds);
> >  }
> >  
> > -static int arm_smmu_alloc_cd_leaf_table(struct arm_smmu_device *smmu,
> > -					struct arm_smmu_l1_ctx_desc *l1_desc)
> > +static void arm_smmu_write_cd_l1_desc(__le64 *dst, dma_addr_t l2ptr_dma)
> >  {
> > -	size_t size = CTXDESC_L2_ENTRIES * (CTXDESC_CD_DWORDS << 3);
> > -
> > -	l1_desc->l2ptr = dma_alloc_coherent(smmu->dev, size,
> > -					    &l1_desc->l2ptr_dma, GFP_KERNEL);
> > -	if (!l1_desc->l2ptr) {
> > -		dev_warn(smmu->dev,
> > -			 "failed to allocate context descriptor table\n");
> > -		return -ENOMEM;
> > -	}
> > -	return 0;
> > -}
> > -
> > -static void arm_smmu_write_cd_l1_desc(__le64 *dst,
> > -				      struct arm_smmu_l1_ctx_desc *l1_desc)
> > -{
> > -	u64 val = (l1_desc->l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) |
> > -		  CTXDESC_L1_DESC_V;
> > +	u64 val = (l2ptr_dma & CTXDESC_L1_DESC_L2PTR_MASK) | CTXDESC_L1_DESC_V;
> >  
> >  	/* The HW has 64 bit atomicity with stores to the L2 CD table */
> >  	WRITE_ONCE(*dst, cpu_to_le64(val));
> >  }
> >  
> > +static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
> > +{
> > +	return le64_to_cpu(src) & CTXDESC_L1_DESC_L2PTR_MASK;
> > +}
> 
> I'm assuming this is supposed to be *src,

Uh, wow, surprised that compiles, yes.

> in which case this could be
> accessing non-cacheable memory if the SMMU isn't coherent. That's why we
> shadow everything.

That is a confusing statement. I know it is a DMA coherent allocation,
but the driver does not avoid reading for DMA coherent memory in all
cases, and DMA coherent allocations are well defined to be readable
anyhow.

For instance the driver has always read back from coherent allocations
when working with the STE or CD:

	strtab = dmam_alloc_coherent(smmu->dev, size, &cfg->strtab_dma,
				     GFP_KERNEL);
	cfg->strtab.linear = strtab;

static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
                                      __le64 *dst)
{
        u64 val = le64_to_cpu(dst[0]);
                              ^^^^ dst points into strtab above

That's the same thing being done here, with no shadowing, no issue.

I know no reason why the first level cd table would be special that it
needs shadowing? It is just wasting memory. Let's fix it.

Jason
