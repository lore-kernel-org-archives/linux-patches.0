Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5233C19FA99
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 16:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723219807; cv=fail; b=EdIdLp8IWqYqLe+J/xd8ADmgiOnLfaH8fAUpzO8iYVUiO9GBUWHHKkGFAY6V8pg+v+RTSZ+M9/Vn+IAPRl9zncVZiKAg/+5URwq1OqM8wvBOG0VTEQR5ml/9q+OBaGZ4QXQzTT0iSQ4F+W3Cnl4l377249HANnD5CBQ1wbQ+lAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723219807; c=relaxed/simple;
	bh=cqQSZ6/O7yB85djSspPW8sK7fXuV4kPJxBx3cSZ6gjw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jfoAu8qxGoPYZzJvUHO4AR9vupgT0eXNVFlfZ3JRjJseIU1KIfjZs5Yodq1D8HrYLfTbW7miaM2wjAiVL8VEP8qRg/0U/FKH4SrOoEIJSzPAfDmsjGZGamTa9YvYtnZWGJqO/Y+a5EsvyJ4KnLwoDQlrSPofK95he/qWumvQiJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VihUyOHu; arc=fail smtp.client-ip=40.107.244.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VihUyOHu"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TuLSR8Tzdw28Z6siB7DAQQZ6Z4ktmQRbkFVFXmg6MCh2eaB4oJsaXrsSR+6aoJ9RdvmUcUPgFfxkYcQl+b3LUvtcgljsJF4wSIduUfA91eIlkbXL8qEbEVtGc8Nrn98SgtdMtaTn5kqJwRW0HO9pKVYjmoQ7/u+d0pWaNESu1ssrbBiNv8dRVpt+eCJCOHYS4IdYgo11UWtyiUWfkRY+c7Mb54nY6KhcgViPGxsbBioUEn7FNa4v1xwBi4XKdVuzOvysSj73KluA1nWl+eTUxhr1cKfERibXXOsXLF4+B5geiPvm42ezuipDwC6/CINrgFsbD8IFxmS1n+Yzw4375A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DrexOOdlf1UjKTYvIch7TPrjRc6vPMhDWUocBr0Lv2M=;
 b=Si6Jp/H1Tkpi4l5mZTdZ7E2rfEq6GG87rOTMLAIKRFcsMukaMTtPrvVr08//44xtM420w0CyXnoDdyIvVPaOUGq8ooZ2f9acLhFRC0uYkKciVND1l12TTZRkoyoctjdLBNOuiEfvzcXZkvnV1tHtaNjoQ4jskScSfEhei9L91Pu3uZyl/JefO03ccE7mRflpvY0E0LXtD+RKi488puQh8BAhJ/GmCdNQdyWNxp5Rg4ciiXIyQ9rkyGxDgQ1oOAt6A1uB+a1wjEq/CZvficAMhDxmWyCRbWF1gESjK0cs82pvrEaR1cqLo8tg2HRzff0cMEr73GOUg+aLSP9Q1Nlirw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DrexOOdlf1UjKTYvIch7TPrjRc6vPMhDWUocBr0Lv2M=;
 b=VihUyOHuNSqhZXxUthdPEzhpkUwP3tghyc0XBcG9EQs4VjI9cnyyMnnKRiqBat3RmhJrZQ3hoPSx8QmbNCROrBt8ByjvFQek7yRb85RVouR/noZWGs3LDNYTMo3H5AWJDiYsWxu/V0g6+piHh4mtsLo8G49+QvrpyxTE5wAdEBJKg2PPr9lgy1HzOjyCiEgQ8BSIqV/wAMEmgNKXJT+WRpPLjaa1hP1OMtOiuVJ77USv/NgshojVU1CFCPkt4aidv5N39GeiEp+Wia4iQkgTkIhwAHqqraR6+r1naeuL/xhrzAylptTLgCMdVcCLDlkvQaZGrMRdCayQl02f3JmsAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by SN7PR12MB6744.namprd12.prod.outlook.com (2603:10b6:806:26c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.32; Fri, 9 Aug
 2024 16:10:01 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7849.014; Fri, 9 Aug 2024
 16:10:01 +0000
Date: Fri, 9 Aug 2024 13:09:59 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 6/8] iommu/arm-smmu-v3: Implement
 IOMMU_HWPT_ALLOC_NEST_PARENT
Message-ID: <20240809160959.GJ8378@nvidia.com>
References: <6-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd79f790-1281-4280-bc02-6ca9a9d0d26b@arm.com>
X-ClientProxiedBy: BLAPR03CA0173.namprd03.prod.outlook.com
 (2603:10b6:208:32f::35) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|SN7PR12MB6744:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e6006c2-a4c8-41b9-93c9-08dcb88db902
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nAe6xUhEQgIMsWCKrczfANOhyCFF/NJXKY+PXENH7IRmXQyuCdsfUDHg0QQQ?=
 =?us-ascii?Q?lqlwVMdDIPalplcNm8p83rF0306L5rZRrgfg9kePHGv5rAmA+YbHxV0PSe8b?=
 =?us-ascii?Q?fVdboUuLYljxaS5CBNPLU6nfszsvOdbxP8q+HtX83ZSgqOOAQXH4WI4gETfO?=
 =?us-ascii?Q?Ke52dokAox2hmWqmFp/LWpwbdwkvOBfvDuF8QbJ13Jyh+uwIFyXfbnZNzyQZ?=
 =?us-ascii?Q?aIn4NayHFh3xCQSSd2oHgp93r/6RFI0U4Oz3e0a4rLbcRDhKE0u7n7wsjVNA?=
 =?us-ascii?Q?lHej865d2Ncq4yCuIFSnKblvP8C+VV0l72V8yzjB0HWt58UKBVU/f3l7mIum?=
 =?us-ascii?Q?pKhpAA0vqwDw4E+Rco3osh0wC521Z1kcgu4vYx8lDbq7DaiCFa23sclvfwtW?=
 =?us-ascii?Q?BjPbdXicYcjP8wRrn+9qEA47AA7ly6F2e6FQ3aqcEfxfskspI3nPA58lF3d/?=
 =?us-ascii?Q?c17Wsl/6XTSAweA2RclVIKGGV3U+0t7fOoqoB4XhlyXXz1svmZuRNdd9VDU7?=
 =?us-ascii?Q?1MpT762rh7QNDSBd0hafNtPNl7UXMSAttVik/n7rmIDOgPiqyl8L/8jZEX30?=
 =?us-ascii?Q?RJaTcmKESKn7Q3uEH88hJ1L5evUL3R8JSanSTicvI/opy1hhU9FNeS4klN5j?=
 =?us-ascii?Q?vFlf8ZXbYQwJyym+uexLpqFfsGMmCsWuvbM5jthMpgNDjtFtAdh8tz4PFdM/?=
 =?us-ascii?Q?k4TcP3EIQkt5INLoRgoyKfd5P/Zy88seRHs8hxaY/c5B4/fEDNvz7/dQpoZU?=
 =?us-ascii?Q?ClPNDTwX5cQmEKXdKBDUNiyt1gi5EOg2qu0OaYkD2er/f1fsLC9NSzSU5zQG?=
 =?us-ascii?Q?EdrZK906Z/am88BdKhzgBNAb4x+05wcqjOCMu9viIGS3y+bQJ4B+QQ6tRKyJ?=
 =?us-ascii?Q?f4UxSXhUWGPyesK1OnWyEO+r69sWpowHK4aS2CluIqnjAbUDqzD+kKjGdZi5?=
 =?us-ascii?Q?QwhXR+ZbWIKoFTEMvOIaakZeuCKRQjoLGjygCX4KGtNwd7JPczOVzion0osr?=
 =?us-ascii?Q?UZkgEMnJFvtSPmF/mKmrh4r5OSidYiPBRe1O75ARTVQmfLGL4FvyB5p9F/Cy?=
 =?us-ascii?Q?tb9V9f5v9OCJFyWvJ6U4vvTulUkbw4Hi30wh2NJKyk4ULqR6Ri/uLeP/IVvF?=
 =?us-ascii?Q?Nu/u8I4hm1jOnfzcCVxI6hG5Q/UvV7BORFrBc0+Cak++G5Pw+YwunqLqfk8y?=
 =?us-ascii?Q?f7CQ4NIiKtHAvj3bv4hEGwhlQ87HDieO7LPPiG4KLItzUY1jptbT9dkRChc0?=
 =?us-ascii?Q?feTYpAGembnVM/U7CrEtydEY8Tdw/Nk5MvSWqwwlOIgmbJV26unzndeWkc9M?=
 =?us-ascii?Q?fHdurqm828mLPWmAJWQzWhOJe/a5FKhUYLThkOW4zYz/aA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vmmZou1V3EAeVDeGutj/64PiPbsRi3AoFEMWKKyWB4qmjzjmdUUNgnIob4F4?=
 =?us-ascii?Q?zaJr2s/EQK+++uxA59pfzGZQwAfynbbKgxM96xScc4QGUpNkV7Ia0nk3Q0Ld?=
 =?us-ascii?Q?zCiPtV1u70z5KtJSFVQ4amHzyIjAOF/c/Mn8xHcCrWafcS55ARzzpcOgAc1x?=
 =?us-ascii?Q?/oPxgVJPn3Ode4WqsPvmiDcLQ95I2aFkyJvlC/QJZBUdjVTSl7n05N+Rc6Yc?=
 =?us-ascii?Q?dvsGT4IhFED56p2n9AQ7PJy6CdsCTLcjaqEHQptAzdqPBH352ZWLufZSlqun?=
 =?us-ascii?Q?3YQjb+h6I3TgHxe+HWaQhCVzkHcS1X0zAnbA/487BRiMY+oIe0xwBLB06wn9?=
 =?us-ascii?Q?Cf2Obhb1rFkZ7y+lfuWQ6HXZxXXyMXtmK5zO6GDHzK39D/+mQLx/RC0HqXtl?=
 =?us-ascii?Q?K0OMh2JMvgWYRzSNwKN2M8/UAy1Ef/WWUv/pZPStEH6uoC0mgDLL/aTTH87V?=
 =?us-ascii?Q?7tAC9Sfla7OFhHnb3IyZDeZ9la/dBOfNbk5dCpiVnYVj+l6zVifO83kNJIj5?=
 =?us-ascii?Q?yaYWE7GqkGPgdA8YVrol5r3Uh6Mhm253vuKP8MPhW30SzRUJTSL/tX/F0N/R?=
 =?us-ascii?Q?1BGKQziWhK+p7VV6VZMsatXo24D68x/9UO3HjnRqq+J5iE6ZFimBEOFrD3D3?=
 =?us-ascii?Q?yBJFEqF1Jy2A8PwoZIwdpRBTvnsKm7YUhm/2FhFcEQRzECkNSP9izDDKW5f7?=
 =?us-ascii?Q?LoeQczhOmXbEjqTS6ajved7DYE4THfEX4LvzO87memZt2TI1qNeW1ekeOZsH?=
 =?us-ascii?Q?rRO86OFE5ngGFHOSo5YN5wlFlHV50Zk0wJwXuIIeXFQ9K6a0StbBgkdPa7C8?=
 =?us-ascii?Q?5iyjf7Y6pwH3QVLRbp4Ozhed4PNWYOiY/f/w6Koy8FB1mX0grLVscqg825Wv?=
 =?us-ascii?Q?E8uFzuLJgeqmhG1JTL98adNMoyJSb0LiXISEE0fhd/eM/lI3vD2bJ/vi3ly2?=
 =?us-ascii?Q?lKsQdGqASa2j00zNYS7+Z+wu81uMd5Qaczw+avQNgvZAr9HbXUrT43Jfe8Pl?=
 =?us-ascii?Q?eqFhmiNyvyoo7pl1B1108of2cOZGKsDFQvbuOsHD8GixL714PtirHCFgf/SX?=
 =?us-ascii?Q?tvjLZXEbUG/3Z4ZA6tFRn4Y5Xljs3WIPXrvCArftY3RWQ4kMsAjOTWS8e1v6?=
 =?us-ascii?Q?LouIFpJzZxIYCbD3Q2leYwEnGJyr16hrQSPqVpsRwcif4HTMUUZPAT4lVjCx?=
 =?us-ascii?Q?itGkant0sLd9a7hsgGxpjh6O8VUwzdyFy3IT4zWMXlv7GAouFAxJuM58vCnk?=
 =?us-ascii?Q?jKklZfCLq9/V3U3TDoc+qKddB7HBouhIBr1mh2nrg/ywaFwljBdb4wsmx94r?=
 =?us-ascii?Q?QipJRh648+0XgiVDNv88LAlrZMTdD9670zfK//JCCE7H5BxSLLPvx+/GtfXP?=
 =?us-ascii?Q?X9m9EMXi2kw8PywlxGEhKENgz0AwLVJM52bq7wTAELdmm/RDg6M5nbJ53jhv?=
 =?us-ascii?Q?rwc+3ZRDewCMIq89vD6oLJ5Ek+sJ/HC6lwX0LzZeQ0jNSOali8oUciPpU0Ax?=
 =?us-ascii?Q?+uobwtgKu5hpTqkhsZjPVVCvl7bWzXh6lNWcRZ9e/bLIVabP3CGN/MJOJjrP?=
 =?us-ascii?Q?Z1G8/Y/pqJEGRSVVYuI=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e6006c2-a4c8-41b9-93c9-08dcb88db902
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2024 16:10:01.4934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DQMnaF1yMaKzvQAVUNn+NkPOXEnoA7voggsbFZEVVbDsDlp5HBjeqGoy5L5nQEuf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6744

On Fri, Aug 09, 2024 at 04:06:22PM +0100, Robin Murphy wrote:
> On 2024-08-07 12:41 am, Jason Gunthorpe wrote:
> > For SMMUv3 the parent must be a S2 domain, which can be composed
> > into a IOMMU_DOMAIN_NESTED.
> > 
> > In future the S2 parent will also need a VMID linked to the VIOMMU and
> > even to KVM.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >   drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 11 ++++++++++-
> >   1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 6bbe4aa7b9511c..5faaccef707ef1 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -3103,7 +3103,8 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> >   			   const struct iommu_user_data *user_data)
> >   {
> >   	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> > -	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING;
> > +	const u32 PAGING_FLAGS = IOMMU_HWPT_ALLOC_DIRTY_TRACKING |
> > +				 IOMMU_HWPT_ALLOC_NEST_PARENT;
> >   	struct arm_smmu_domain *smmu_domain;
> >   	int ret;
> > @@ -3116,6 +3117,14 @@ arm_smmu_domain_alloc_user(struct device *dev, u32 flags,
> >   	if (!smmu_domain)
> >   		return ERR_PTR(-ENOMEM);
> > +	if (flags & IOMMU_HWPT_ALLOC_NEST_PARENT) {
> > +		if (!(master->smmu->features & ARM_SMMU_FEAT_TRANS_S2)) {
> 
> Nope, nesting needs to rely on FEAT_NESTING, that's why it exists. S2 alone
> isn't sufficient - without S1 there's nothing to expose to userspace, so
> zero point in having a "nested" domain with nothing to nest into it - but
> furthermore we need S2 *without* unsafe broken TLBs.

I do tend to agree we should fail earlier if IOMMU_DOMAIN_NESTED is
not possible so let's narrow it.

However, the above was matching how the driver already worked (ie the
old arm_smmu_enable_nesting()) where just asking for a normal S2 was
gated only by FEAT_S2.

This does add a CMDQ_OP_TLBI_NH_ALL, but I didn't think that hit an
errata?

The nesting specific stuff that touches things that FEAT_NESTING
covers in the driver is checked here:

static struct iommu_domain *
arm_smmu_domain_alloc_nesting(struct device *dev, u32 flags,
			      struct iommu_domain *parent,
			      const struct iommu_user_data *user_data)
{
	if (!(master->smmu->features & ARM_SMMU_FEAT_NESTING))
		return ERR_PTR(-EOPNOTSUPP);

Which prevents creating a IOMMU_DOMAIN_NESTED, meaning you can't get a
CD table on top of the S2 or issue any S1 invalidations.

Thanks,
Jason
