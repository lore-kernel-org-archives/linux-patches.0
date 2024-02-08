Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A69576908;
	Thu,  8 Feb 2024 14:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707402458; cv=fail; b=HVSB3JtJ+UyYz5afKr5VEnUGFO0i4OXXC9C735NTMWgKq7BtHvqVeUeAtzQ4FeL6hp0fcHU4IVdgYtMpCVG/hTNKkbwrAvJ2xyJlL5t+/R/jiA/TdmO8ZvB0soXTCnJqTU2ZAQZeOcp0z+29Kxgcnv4awe7a8QPHVd3RfXavMKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707402458; c=relaxed/simple;
	bh=lk9QfIDPmOG7IeY9rxj4DseJZ+2FQgcp4sfPE+50RJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TzO2vJDp7ynEqdolGw7suzN55fQT5Vs8O/jjA1WDI7Z5OY47/okTQIUD2oPKyEa+hg6l3DooQHMagnEO+d4+HX4LuaZ2tP4abrUdr+HBF/0EeOBuK438t2guxSn9YkxvxBAr8yTpQynNIX/QSfrnxFOJyjgb16tA+eKCXc12n/I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=QiZUgunf; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="QiZUgunf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf3cKFjy2FRo2DJzE7p8MfZWx/heLOI3fonRuPFWstFslkf+jbFFLfIfVtzbU5KLuDs9kXuq9JemhzRh8/W2nbsWM1mJXSD1UxuyhcKoejsgUoErqo4Aety7mZaURm/vv9aF1fElSV5Th3Y2OF7x7e2H56n0DyoWsp6uZenx46iY3tHc1bai1gv5A3Te5+C0OCWMWkEGwp66j/JJJxwWXmBoat8gzYVkR9JiapwXhw6Aq5BRfYEOEiHQ42hz6qvtlREPolxaOzuiKKA7+9/EFTfBx8zTpOkIP8pKLCCJKzjnf27KMQLTikwCjQAeGlxnTFlKqnyaxZYEA/yyfoJnSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVUGuk53KIJr1xqBS0d50pgUoqi5hdrmWeIvyfBPFkM=;
 b=aa2fXpAjRdVXB9Xwzq7ZTJEDZGWdtGl1+8g3ykgNpqFLpxEdELcrZ6ppkB2wRGRycdfPugRIlNGIGDCg7x0LmATE00nOuRfP+6j4anQy9Xl4K/j0VE35OHA2mi6p6uXHl64uaNmnb5KWno1UYnl3YF/2JAJF9CDJ3/Ax+Kr8MBXBHbcIzfPhSKYYd1c5vslrPXHsZmV2olvssWF44bEm/+qU+KJDcL7fvlHzTt5wxsUiD8rv6B4LYHqpB5KUocWMa97r0wxAwKl1JqSD07XNovbVF1xp/CFQT1oyLhXK1/eVVX57+CwEsNDy874sHv4V6y3cd//ifK2knuyfnsMneg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVUGuk53KIJr1xqBS0d50pgUoqi5hdrmWeIvyfBPFkM=;
 b=QiZUgunf++E0qCQYx+kxjbZ3kG2YnNmzGZRwq3eXVepG4Kd7eEsewFTCqb3SZgg/CZwkprHIpFgH6X67osR+HgDKVeQWlUHjeUhHfzAoEZi+gXSWUHdqLMrONqn5knEx2ub0EC09Et47Oc6zwE7QGYbFS+mlZ94KYG8Q8r4McPosnWy8Jwfux32ks5D9qfNyAO6gMAywcT/PeJxM7gtXtSBALqi5TWfTjvcaxL1EXNfgYNXvW3N4WsA0jeattE81sXYiiXn2LV6TmUwdPw2c39Q+UHCG9wUqEidTBKBoy22FGhb79T81gYn+x0Au4xJQ9OMGiqv6HxgaGbHZso/qPg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA1PR12MB6020.namprd12.prod.outlook.com (2603:10b6:208:3d4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.16; Thu, 8 Feb
 2024 14:27:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Thu, 8 Feb 2024
 14:27:30 +0000
Date: Thu, 8 Feb 2024 10:27:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu-v3: Do not use GFP_KERNEL under as
 spinlock
Message-ID: <20240208142729.GH10476@nvidia.com>
References: <0-v1-210234560de7+69a-smmu_cd_atomic_jgg@nvidia.com>
 <20240208125846.GA23290@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208125846.GA23290@willie-the-truck>
X-ClientProxiedBy: DM6PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA1PR12MB6020:EE_
X-MS-Office365-Filtering-Correlation-Id: 2952e36a-1cf0-4d53-c46a-08dc28b2152b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	oz7ZCK3Tw+wqdC+75k7WwUgBPo6AT1NV4hl0fjtqMipDIrDJUOi7sP2Bts3K1Za78JTrQaF/dfHEOf79IDVcc96JxbnWvS5VW8odp6hDAsX2L47BXfCqUsovXsNLRljtltZSWOvejZWKsUgkRQjCKM11/7RAuC3NR7M3nPvST0ZitjlCMPAsAuOGmbXcst2lsPT7S0dzUUD7UXrV3U2N42OfRlimhthd8lRiX19c/bNXIJxujvWP6ZfH8fKM1lEmRN8ZyohC5yWtsTHgYIo/9QSiuA2w+O7XEMK90z34FLRD7K43xfnRCUDR0AlgiQda25O8m5FiM5RO89n3+b+M5EXEpJzbF4GMfoTnRpljRn+oR4BJ2uUy0MFd1fxEQR1jeuwNg6lxOGKrhVf2nQyEUQjcbfW1uOjrp+PwMh6pprlfonThkAUIQ9ytsPP3Lnz78TNBDKEtFopkqKPAoJE49803meAbWQY9m1XJZY80EkdqHs3quUhHaDdfMxsN9rVfURPz2Xmxc2bno29zZFqDVupTIisPR8S2DlXsZbHzKr+9+LPlZ0R12D/TUGiqRmaWy0A3HBvduWkrIUhI02MH0o+/gyLrm48L7hZZFseFn5uVFnhTFu8SxRIOt69kEr8Qd02fJ208SugPIkRbGB87pQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(230273577357003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(38100700002)(83380400001)(54906003)(5660300002)(6916009)(2616005)(478600001)(1076003)(26005)(6486002)(6512007)(966005)(316002)(8676002)(66946007)(66556008)(2906002)(66476007)(8936002)(36756003)(4326008)(86362001)(33656002)(41300700001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HmbudfhRwKz3n9uPUaHHTIEU7l0PYOsbks8iMSPrWKMln5aJzmmzJ83//wRS?=
 =?us-ascii?Q?JFeyVifDkQ3uph1Onj6Q8JkbbORtRcMH7EDBYLGuI/e/iiYgNzuN7wWdzcQG?=
 =?us-ascii?Q?KGd6uQc3j+dvta+SsKMsT/Ma5APO0SLaUtu/GKxTQV6384PH3GAVtg9XJ2Bl?=
 =?us-ascii?Q?cWXA/v+jIuDAnR+Xjroj+vq0jaN/PNxlbApw1cEQ05yO1d78CmdZn4gC2/kI?=
 =?us-ascii?Q?dn5UlXou6YaMu2s+O20cqTYJwvQgba8ufzUSUh1wCf9tD4x7AgfQYRLg8Big?=
 =?us-ascii?Q?psWUFGqcm3rq9uUGFlsVvCTvR9qo+2uBkAeOezkdyLQiPCYmqEJZd8GuKG1X?=
 =?us-ascii?Q?ODLF62cPNraDJSvf03yOJSpm+VijyebLp5IjjcpN7jsTG2nIcUhJQAhWmtxo?=
 =?us-ascii?Q?XnvP7r9lkgD253Oe4aGa1ox2HucAZ4BKJOwZBLB3skLTvSGHZov1Nz3nC3GM?=
 =?us-ascii?Q?Fi729yNpcPT78M40Usj43YpSx9XNw/upjIbq/e9j3/NfRQYFeaVzbQFtgnRe?=
 =?us-ascii?Q?cz+izyK71/CgxjgGu/coqMW/CyrVfNaEdoNfaamf0g90FYTRPZ0O1RWEh/bv?=
 =?us-ascii?Q?DIQk0w0cxPH8zyrkWB9odlVoj2+vj04d3mQhfjyD5ULjro6DNFkZa/n73VFU?=
 =?us-ascii?Q?EewGzlS3OwchrmKOlbSKYvR+WV9za959Sp4Z6h4Fp0YwcT9vb4ibvNLsTyvz?=
 =?us-ascii?Q?TAmpQ6ElQlLTkTJOpXd9gvIimj2Avt2LdCcGL1GOpqFZMlfUxQoYGZ+p/gz8?=
 =?us-ascii?Q?Dj+/bANw27xCaf87Vq8XAeHeZia5vBFD2dYrNaTn4F4yD7QWhvSosolrUkss?=
 =?us-ascii?Q?x+I0nIpGPen4xkAckC7MDuGX7nPCYzyT8GXjWGKowAWzGfmp2qesUbBXCAmY?=
 =?us-ascii?Q?I5oFppa3I6twGftYBVnXYTL+hLZGwR+A6HZS4z/LfUMLiN+7XmvwFXblRZ9m?=
 =?us-ascii?Q?UuZOpNgOw6oYl9C67bDlz+WQAYWUxMcQxYapw/MUh/vaDrrg75a4occ8Ej8s?=
 =?us-ascii?Q?KmbrhupLNxTYYOJv9NGa1wNH9ZuKauLKgPRkqbUeGK+FNU02A/ysTRbBlSmu?=
 =?us-ascii?Q?uOKWqrj24xHjNvz/rAoHsJmfapHk+cN/3oYVnt6ivJRVkQaljxlR/UGJ6vNq?=
 =?us-ascii?Q?/Durv63W7xo2ayRiyrRfZ78epVeBrkbVnacvYpmQ1s48Wy4lIoQmKZw+GgEv?=
 =?us-ascii?Q?G2ZAA85ssV8nzYKyLAud7lUjgVmqJNTgPO1fHSEcaLl7HX/HSQiOXQMhOxwC?=
 =?us-ascii?Q?B4eRM2kX0vQtQYBunt1LFPxvvJ0yDKRotB5GkRGNTkDtbnzaV8KgwoYEof9H?=
 =?us-ascii?Q?CdpDYqsUUPt5V2yr+LdRbnyRDZ14a7BPQHQD/PbhQ0dCVdzWy7VTaAqXTVHV?=
 =?us-ascii?Q?T51rYoMR7dFT0+SF9o8rIQdnOFMmdv+bnoaiUl3PuvBEnWEE56hl6TgbismI?=
 =?us-ascii?Q?MuYsZ8HGYyKPgkjd01TKyVx0mWG7oCnRqsrnYB49cQliBxmqZEdQuU2kcZgX?=
 =?us-ascii?Q?/RlVh7Vc2U0gCGQrQBrlQcihtBDZvvymfYmA+caNovnvdqhkEWzHyyMadBSp?=
 =?us-ascii?Q?45DTItOSfwOQwBEvj9Vr0XwGdEr3JXhG9qWqYMDa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2952e36a-1cf0-4d53-c46a-08dc28b2152b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 14:27:30.5288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L/oo1JWc0Ly/0xlL0n3CK61jNR6uDCoY0ke3/mnwakQcS4o8tIPq3N+lErZkZecO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6020

On Thu, Feb 08, 2024 at 12:58:47PM +0000, Will Deacon wrote:
> On Fri, Feb 02, 2024 at 10:28:05AM -0400, Jason Gunthorpe wrote:
> > If the SMMU is configured to use a two level CD table then
> > arm_smmu_write_ctx_desc() allocates a CD table leaf internally using
> > GFP_KERNEL. Due to recent changes this is being done under a spinlock to
> > iterate over the device list - thus it will trigger a sleeping while
> > atomic warning:
> > 
> >   arm_smmu_sva_set_dev_pasid()
> >     mutex_lock(&sva_lock);
> >     __arm_smmu_sva_bind()
> >      arm_smmu_mmu_notifier_get()
> >       spin_lock_irqsave()
> >       arm_smmu_write_ctx_desc()
> > 	arm_smmu_get_cd_ptr()
> >          arm_smmu_alloc_cd_leaf_table()
> > 	  dmam_alloc_coherent(GFP_KERNEL)
> > 
> > This is a 64K high order allocation and really should not be done
> > atomically.
> > 
> > The proper answer is to sequence CD programming in a way that does not
> > require the device list or a spinlock. Part two of my lager series does
> > this and already solves this bug.
> > 
> > In the mean time we can solve the functional issue by preallocating the CD
> > entry outside any locking. CD leafs are effectively never freed so this
> > guarantees the arm_smmu_write_ctx_desc() inside the lock will not take the
> > allocation path.
> > 
> > Fixes: 24503148c545 ("iommu/arm-smmu-v3: Refactor write_ctx_desc")
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Closes: https://lore.kernel.org/all/4e25d161-0cf8-4050-9aa3-dfa21cd63e56@moroto.mountain/
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 5 +++++
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c     | 2 +-
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h     | 2 ++
> >  3 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index 05722121f00e70..068d60732e6481 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -588,6 +588,11 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> >  {
> >  	int ret = 0;
> >  	struct mm_struct *mm = domain->mm;
> > +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > +
> > +	/* Preallocate the required leafs outside locks */
> > +	if (!arm_smmu_get_cd_ptr(master, id))
> > +		return -ENOMEM;
> 
> What guarantees that all the masters in the domain share the same l2 CD
> table?

Nothing, in fact they don't.

However, a multi-master RID domain is something that doesn't fully
work with SVA today. This code is functionally/security wrong to
install the PASID into all the masters that share the RID domain.

In practice that doesn't happen because the iommu group size when
PASID is enabled is restricted to 1 and the DMA API is the thing that
has created a unique per-group domain to be able to turn SVA on at
all.

So, the RID domain's list has one master entry that is the same as the
set_dev_pasid's master.

Which is why this patch works, it prealloctes the only master that
matters for the only configuration where SVA works and is used today.

iommufd could violate these assumptions which is part of why I'm
fixing all of this in preparation to enable PASID support for all
drivers in iommufd.

> The only reason we need the spinlock is to walk over the device
> list, so if that's not necessary then we could push this down into
> arm_smmu_mmu_notifier_get().

Pushing stuff down into arm_smmu_mmu_notifier_get() is the wrong
direction. CD manipulation needs to be lifted up and out into the
generic PASID level, not pushed down toward more SVA specific code.

This patch is where I got rid of the device list iteration:

https://lore.kernel.org/linux-iommu/11-v4-e7091cdd9e8d+43b1-smmuv3_newapi_p2_jgg@nvidia.com/

By lifting the CD programming up and then into the developing generic
PASID layer.

It is worth to jump ahead to the end, once part 2 is done the
set_dev_pasid SVA op looks like this:

static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
				      struct device *dev, ioasid_t id)
{
	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
	struct arm_smmu_cd target;
	int ret;

	/* Prevent arm_smmu_mm_release from being called while we are attaching */
	if (!mmget_not_zero(domain->mm))
		return -EINVAL;

	/*
	 * This does not need the arm_smmu_asid_lock because SVA domains never
	 * get reassigned
	 */
	arm_smmu_make_sva_cd(&target, master, smmu_domain->domain.mm,
			     smmu_domain->asid,
			     smmu_domain->btm_invalidation);

	ret = arm_smmu_set_pasid(master, smmu_domain, id, &target);

	mmput(domain->mm);
	return ret;
}

Where the cd programming is in arm_smmu_set_pasid() and that code is
fully shared between attaching a normal S1 paging domain and a SVA to
a PASID.

Jason
