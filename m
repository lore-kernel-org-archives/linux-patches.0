Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2087.outbound.protection.outlook.com [40.107.220.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21332D7DCA;
	Fri, 22 Aug 2025 20:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755895394; cv=fail; b=edATSf1IaoY+tE3HEBj9SUvrIo/qEr8XGdCYK9jb4djDXmFhg/QiKHr/c1kX6LWi4jd+VROwwTxn4Bhp50Arj6m80+Jt8h7qoX63vR6/4qrpHTg/bJk/gLdehlh6H1euzSYxNmk6lbKV9kOosJcclLiqjP4Y/xcVKcCnXBpUzyk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755895394; c=relaxed/simple;
	bh=vRnDWU19cd2agqjR2dwIcaNbyqwxsO3KRVuyUHzcTgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P6cIv2f6T9zhwojpYF/+NN5tgHwOaZ7OUzFNePhSP9lZ6RiaA3DVcJKebCHO00XYmcjQh3wvz7gOgL9EbXlF7kNcxyHQsXk0kk4MbGngxehW1QqS22b9f0OH0VCOHz188LG8NCE1IiprKRwznU7MmVcZDDTvWnLsVrKlQbwfkWc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=I/kDOv2/; arc=fail smtp.client-ip=40.107.220.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="I/kDOv2/"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nCwuI+JjOxLZfusCSgK25NsOuqkkRwV1pG7rW6Ou9vNVpk9UmuCYFPXLiBq8+TkuRwJTyp03CNq4hx9v0P3JfNWG37cs3r8IneB8DtR15YuR7LgG42FWUFwWq23tEE4xqMPA1VXo4Fk9ifzxJtRHiwpxS0IBABgJ6mYcun7stmzDpqiPB61U2oawij7JpMeB1jUKN3CRCbXUWxcob4G1cmGk0pAZ1rpwbQ40OGwWZM4n9ynprknnAhaLJ06Uk6k018DGxyMr0BoBXXdUVhqjl/1WFA4qx1QxdCeG21aJ+MYYqAcBLcSKRzvmI00VTOXQvB7NUc4Jy18+HRltO3IPTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qvt8EoXV0EVdCm2Lkv6/NkafeC9mflrovxtFBx/LUtI=;
 b=gP4qIn9bSzhabNg4LWGKTVuWE4oW50bX5kaYGZh7PzI1EQLHSs7272C3gKX8VUTvif8mHutHlH5qrP1j6X0fHFIXBHIlQgtLkFInjsixojTNNEMiqNCuvqiDxbeQgT9ccAJbCusFdyX+4Y/KS3VajgDgp8sd3gRY/777pZdCRMGnT5FeRmRqiu72aOEPZX0msuQKfcsNBt2kvWpotKoB+JfXBCshFpvR8MOfSZSLaPCZEMN8QuV6kKGqdh1HWLACen/WncCK06iydTCjy3MtISi2U/Z7QjM0Q3NsBoQp5NyfYie8+iBwmwb88UUvouDLPfWCmRBE58Aj8NkDbf1rvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qvt8EoXV0EVdCm2Lkv6/NkafeC9mflrovxtFBx/LUtI=;
 b=I/kDOv2/J2yWQCF1KmUkPa3cmmclCE1aQ8pdXmH+4QNOZISHAyyme66zSh0UVYA1a17QgsO3V43MoKqXVHWJXPrWBERzE58qW5vC5Tzvgm0y5dyXlDizes8G9aY2PJrFusJY5qEpa8D4UYGu4356FTmysBP6NbVgh1YmfJCA3w73LeLOuP4PVmMFlGPOblQWFiixWBT4IKGkI7+TvNgUsQsfdNu2PL5Q1sNdHD8cFuWYwMDu49ZDyQd4acV7hRKhtHdw8iZswkZhJWdAmJvTHdHD/NKIFY7UOBv6eErRIHFXVF62krRCy27GfLdxo6/0HKyHbpIj3fLiiNRfqtJD1A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by IA0PPF80FB91A80.namprd12.prod.outlook.com (2603:10b6:20f:fc04::bd5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.19; Fri, 22 Aug
 2025 20:43:09 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.9052.014; Fri, 22 Aug 2025
 20:43:09 +0000
Date: Fri, 22 Aug 2025 17:43:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Tina Zhang <tina.zhang@intel.com>,
	"Wang, Wei W" <wei.w.wang@intel.com>
Subject: Re: [PATCH 8/9] iommu/vt-d: Use the generic iommu page table
Message-ID: <20250822204306.GC1405994@nvidia.com>
References: <0-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <8-v1-bdb01ffac49c+be-iommu_pt_vtd_jgg@nvidia.com>
 <BN9PR11MB527649224AE0E30ECD18DF318C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB527649224AE0E30ECD18DF318C3DA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR02CA0047.namprd02.prod.outlook.com
 (2603:10b6:a03:54::24) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|IA0PPF80FB91A80:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d2e6d54-9f5c-424b-41d1-08dde1bc80e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WBDjnTmW+oR2Mzdpdo5g9j047yFk2vHykC9pND9xu1cdrgNhGJ4oz5GqaSMl?=
 =?us-ascii?Q?zhmBF3ljXrpQc8Zb4s7VFV/lswWfYcbrMepxXdOTddNBUPO90Nqv1QEBXqQo?=
 =?us-ascii?Q?m18S+f7INnqUci/C5WqfeRm5jXcHhK9h5iDDNTa4zTgqvI/FKoNBu21TwDBk?=
 =?us-ascii?Q?ECazar7N35S8NgQOh4OKN3I/Dg9dbpge3GwAypczIssiuvWy9UhyL9IW05f1?=
 =?us-ascii?Q?/ql0/i6Npy3AzZSoQbOyN4RPcH6PZFzar2PApKGYplBwvFyqFI8p0olrQH22?=
 =?us-ascii?Q?KmaFHciIMrMiIj1HFgs16HQXnlEsVWCUCqRARfODQavn3ncnsuOc8ELGYkNn?=
 =?us-ascii?Q?sNdOfYFzlYt8I6169k4lChAQGEsKAstw/+ipLub8BJps5khG+U6T4tNhYR0t?=
 =?us-ascii?Q?cqX2V1fqyZC3oyNB+3a/VA5B92Jbi7afWQ8aHdC8cGIMxRNoGDnsCCTx/gvT?=
 =?us-ascii?Q?BxOfNg55akfJvrDlSo0HMcsD91CfcYhNtv/rCAHUNdc1QZZluqJ7P9bl3QDA?=
 =?us-ascii?Q?F2JBxCfFsB+1IBAAtV5iPGiBGIYZ9t0HjIGjX3wTRn3WLNC8vaWugFPMFAQF?=
 =?us-ascii?Q?af6RPgIJieMAAra8GvxrszPJedBrBO5YhMHfmBUTR9hG2qqQ8sBed6NQfZmP?=
 =?us-ascii?Q?D+MG7HHOwCZfiqiitYCeqIFJanNpubuSIuKG/i4atkqhlWIxvVfWqZdNQCDU?=
 =?us-ascii?Q?6c/9CsiEHBEJL1+S6NijH/n6xq+7YYmkoafNsQ2AnIBLvxa+2xUMk1yvK5nA?=
 =?us-ascii?Q?3EFCj8vMWSSWBDmXV8BUrbtetQfil0A4ZG4Xu6EebC1tdkUjb0g+oOIl3ER+?=
 =?us-ascii?Q?kB6wP9X8HksRfcs1H1sz8qcHoYgh2wpEj4sOw1IyVWDUxMQgMX+maGqDoixB?=
 =?us-ascii?Q?vvAnrTdj11P4IJmLoUIITioudcX3TI4OvLJtSsqY2BRF3YR0k+i0gXJdy7B4?=
 =?us-ascii?Q?YVAilFbLjzcsItz9WYPDLLbpjR5sjdgN/1bBAeWT/7KTEZJmS8s8LIa4FTKW?=
 =?us-ascii?Q?A3p/ZMm6mWqz5rcBVgnsB5/l3PuQHzMw6QZ7tVSUinDAmSMh8CSTT3YX3Z2E?=
 =?us-ascii?Q?gn4j+NbtswZSnZ4wZfKMN7Uhe5oY6S7KvYHhTiy6IUXfdcsEjAuOVu9rsE9G?=
 =?us-ascii?Q?/8uafEi0mqtEkAg4uA7ACWq/kuMYuQTq6K9Rx781rLbgr42k8CeUmdRopxyI?=
 =?us-ascii?Q?t5FSc00Pu/txpMsr8u5I8+gOxjf0nuQoRHyVXK89dzwjVpi2mMsZLAumR+Pc?=
 =?us-ascii?Q?N02Sl+5HgBSj6AMK1tcaJ46gZPtk7qzuiXCSKnEqccaI+mHj7uaaurlhDQtW?=
 =?us-ascii?Q?HcwbeHXi2l1CJ9gTRe9Y3Jvo/ukVleZ6KI0jU/vU6A5iXPUYCMr6ynmRaJWh?=
 =?us-ascii?Q?ju+O4OBevOD0d1zCy/lpOvVDnk5tKNVyMiLZSBooowlqCm9Y+ZIr6RrrdFrp?=
 =?us-ascii?Q?zfGA5EWdm44=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UfiJzUj0SGgOw2Md4wpAMasY9G4ZkNXcx0xfFDOPnW18reIUncVJ4CsY3n/t?=
 =?us-ascii?Q?ugBcl/anG98FAsmANB7zuu8bqzBcW8NA62RONx6/s5FmzsWgY8t869DgyECa?=
 =?us-ascii?Q?ysVoEzPTXIE0r53jUkqsvICV8QkVX3Tog9z3+R2Y3eeNjedPAFkb2BX15gp/?=
 =?us-ascii?Q?/scvSTBjUz1VPV3f+jbJzDjSIEznyH1Z3rhbEHM3Hq2MC5MOMTCyAH3pgQKe?=
 =?us-ascii?Q?BiHYV+Ss/GgMFXDjDvXTHGr5NaIX67l6dNXdjK6nOTuUDAvXaEV5C5wOZ98O?=
 =?us-ascii?Q?+jmZsFg+OsMtBxJnzeuuBrSZYZYFs6cEkgysm3vlqfPV+7xzVn8WMt1wCbXN?=
 =?us-ascii?Q?Dw/E9MUNAhBwiJFmTyeyJytTM5MNtDKLvZWSvlQbTMgF0I/TJQlYf3fLf93L?=
 =?us-ascii?Q?RXyyPj9AZgEVbybXAHMav25H3M4qXE6S48gTndViBIAthcahssy8KM5saQlz?=
 =?us-ascii?Q?iB8ZshXd/pm5zgN+X+p4OVDlBCRlcwC4lXpNJblnOKLHdA6JeNVTG6nSGkpT?=
 =?us-ascii?Q?eSyvP3ak65f6R08MH9tT3hojOdP7wG6mphnN3SrAuerlUewnE4PFr9Xh+FTH?=
 =?us-ascii?Q?MYS4FiPGr2iRuCBPzwmGDN3ApKAFpFcZAv4Bp3NApbV6k5yCrxj1UivphBLL?=
 =?us-ascii?Q?2mA/t3lhDexT7Ew+JRyVoZwJkUx2+/nfd0UiwoTamjrsAHoOjnqYc9jBpjcP?=
 =?us-ascii?Q?O6tFz9/q7DlP3QbiZfN5b8UxzIu8I+AKi3WYqc7marBp1NHBamFTo2PHB21s?=
 =?us-ascii?Q?DtFxUfgvqWoKtlE21ZoVqx6GFYsINPqupG1cd6r3ZTfQV4APjtEoiYBlGi90?=
 =?us-ascii?Q?K6YKtsHkFDcxkVozNpTU9Ux/+d6P48xK0KR4jC76XIaQHGZNlJQLXf7LIv0z?=
 =?us-ascii?Q?08WO8xa5KwnEP6mBIL80rasEQc9EACr7uEyeAzMB7bect1jcK/TF1kvMA7ZO?=
 =?us-ascii?Q?IK9kdKjZjuOxZx1uldislKTsCqUPez9hruHGp1UtG8Qodx/8piWHEvjb95rF?=
 =?us-ascii?Q?ZPYx8sMgAIpbUnYIcYfyWzwf7Fo8w+LG1hDdvrkZZsYzRMx8ihirL6Qyn23s?=
 =?us-ascii?Q?u04TsimZVC0bjnWhvj4H3pGxQpKYHtrqvMdyqui0k5xtcdsvP7RFFCH4Jf8b?=
 =?us-ascii?Q?0mkt630/hHoaAnjPnWPxFYfmoKpV/jeYbZz8A+eC3BjvhA3BL3vVK4/6TpfZ?=
 =?us-ascii?Q?5mMxUbO6fpuMSgkiQceDcU7896cBm57inyAYH6jQzj7ZL75nZNdNoGkDPm3P?=
 =?us-ascii?Q?UDXHMVpVONeYpNU0r3pkNkG57Sn4JCPVTulWY54ijpWNCy+6wlzwP+bH511h?=
 =?us-ascii?Q?sEjaaoGNIlI+ab0Jp692pmh53l6b5KlqN+4Geh0CG6PDOszPiK37riY//shz?=
 =?us-ascii?Q?R9AH7FSvpPj8ofh4CK73Luy5aYY7X68ctLlZsTrhFwKzw3om6ON4keFE630K?=
 =?us-ascii?Q?H8I4zok1A9J/iJ2DKHl4eImHZdNmU1QoEgMjXZKiGMAODLci8CtYTOWtboPu?=
 =?us-ascii?Q?DBRG2o2DZgfrdeC4Yii2CxsbGCpUtyvjHmbPhvH9hKNOftpztX61A8PaV2J0?=
 =?us-ascii?Q?pGI2yueM5JQAm/J9AuXt+pZru5WJZsaqFRVu0nXF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d2e6d54-9f5c-424b-41d1-08dde1bc80e1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 20:43:09.1406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RO5QrCGzYa+lIQRZs614BoG3xO8e2Ig4J9IG6yOwJSlI8eGkWsSYdsnEXLQcofwD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PPF80FB91A80

On Fri, Aug 22, 2025 at 09:35:27AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, July 17, 2025 3:58 AM
> > 
> > Replace the VT-D iommu_domain implementation of the VTD second stage
> > and
> > first stage page tables with the iommupt VTDSS and x86_64
> > pagetables. x86_64 is shared with the AMD driver.
> > 
> > There are a couple notable things in VT-D:
> > - Like AMD the second stage format is not sign extended, unlike AMD it
> >   cannot decode a full 64 bits. The first stage format is a normal sign
> >   extended x86 page table
> > - The HW caps can indicate how many levels, how many address bits and
> > what
> >   leaf page sizes are supported in HW. As before the highest number of
> >   levels that can translate the entire supported address width is used.
> >   The supported page sizes are adjusted directly from the dedicated
> >   first/second stage cap bits.
> > - VTD requires flushing 'write buffers'. This logic is left unchanged,
> >   the write buffer flushes on any gather flush or through iotlb_sync_map.
> > - Like ARM, VTD has an optional non-coherent page table walker that
> 
> 'optional' sounds like a software choice. but here is actually a hardware
> limitation on certain platforms.

I wrote it like this because from a spec perspective there is a PWSNP
field in the PASID table entry that SW can choose to use.

Yes, some HW requires it to be set to 0..

> >   requires cache flushing. This is supported through
> > PT_FEAT_DMA_INCOHERENT
> >   the same as ARM, however x86 can't use the DMA API for flush, it must
> >   call the arch function clflush_cache_range()
> > - The PT_FEAT_DYNAMIC_TOP can probably be supported on VTD someday
> > for the
> >   second stage when it uses 128 bit atomic stores for the HW context
> >   structures.
> > - PT_FEAT_VTDSS_FORCE_WRITEABLE is used to work around
> > ERRATA_772415_SPR17
> > - A kernel command line parameter "sp_off" disables all page sizes except 4k
> 
> No related code in this patch. Is it from the common logic in the AMD
> series?

It is this:

static struct iommu_domain *
intel_iommu_domain_alloc_first_stage(struct device *dev,
                                     struct intel_iommu *iommu, u32 flags)
{
        if (!intel_iommu_superpage)
                dmar_domain->domain.pgsize_bitmap = SZ_4K;


intel_iommu_superpage is driven by sp_off:

                } else if (!strncmp(str, "sp_off", 6)) {
                        pr_info("Disable supported super page\n");
                        intel_iommu_superpage = 0;

> > @@ -3442,6 +2990,16 @@ static int
> > paging_domain_compatible_first_stage(struct dmar_domain *dmar_domain,
> >  	if (!sm_supported(iommu) || !ecap_flts(iommu->ecap))
> >  		return -EINVAL;
> > 
> > +	if (!ecap_smpwc(iommu->ecap) &&
> > +	    !(dmar_domain->fspt.x86_64_pt.common.features &
> > +	      BIT(PT_FEAT_DMA_INCOHERENT)))
> > +		return -EINVAL;
> 
> this change leads to a slightly different behavior from the old one.
> 
> the old logic is that iommu/domain must have the same attribute:
> 
> -	if (dmar_domain->iommu_coherency !=
> -			iommu_paging_structure_coherency(iommu))
> -		return -EINVAL;
> 
> but with this change a coherent walker can be attached to a
> incoherent domain.

Yes, and it should set PWSNP in the PASID entry too, not wire it like
this:

        pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));

So like:

       pasid_set_page_snoop(pte, !(s2_domain->sspt.vtdss_pt.common.features &
                                   BIT(PT_FEAT_DMA_INCOHERENT)));

And so on..

> Conceptually it's correct, as the only side effect
> is unnecessary cost of cache flush. But it does lead to user-visible
> impact i.e. a previously failed attach may succeed now.

Yes and yes
 
> In reality it might be fine as I'm not aware of a platform with IOMMUs
> having mixed coherent/incoherent walkers. But since this series is 
> more for refactoring, better leave the uAPI semantics change to future.

But sure it can be split..

So like this:

	if (!!ecap_smpwc(iommu->ecap) !=
	    !(dmar_domain->fspt.x86_64_pt.common.features &
	      BIT(PT_FEAT_DMA_INCOHERENT)))
		return -EINVAL;

	if (iommu_paging_structure_coherency(iommu) !=
	    !(dmar_domain->sspt.vtdss_pt.common.features &
	      BIT(PT_FEAT_DMA_INCOHERENT)))
		return -EINVAL;

And I added a patch to put it back with the above set_page_snoop
related changes.

Thanks,
Jason
