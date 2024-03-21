Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2064.outbound.protection.outlook.com [40.107.237.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE06382D86;
	Thu, 21 Mar 2024 13:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711029360; cv=fail; b=qPzBzAWZIteHcwM6Ubb9+9OVuwcpw61fHyAlLDPXGXdZBWR3Lumb5CLsY38wniA0wMXzQIWaP4K6qWA0cnzV/5/NzgHXWV/1lCYYN/WVKlbxF2Pw/72l6UKx6nqbo7F/5FyPrIOL5VY8cHaXiiGSw0HJxBJglcdtMFiSaFAnVAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711029360; c=relaxed/simple;
	bh=KXkVaXI2RSI6jt9E/sMHdGgjgCHVd+kyZXsI15dn2jY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jCLeVwtBtUgM0SGIJM697K2icBIqkt1k5qzwSssi/UCIkD+/nHQ8DiNcD1k2Iq4oEGYTIfvr+MlXMOJwcHXwcq4bYF7D8Ssz7eBpJY9oBdmNwUh0gwDMjDZnHb+rCWaURqGJbLyewokCgUCrxhIOzlAS4t9sqll3V97LtxjamUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OSe77MZI; arc=fail smtp.client-ip=40.107.237.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OSe77MZI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Iyhg4zB7QztsNcCpYJLLDvfLXuTPhF/e/KfHaZCBzI2b92dSBdmOIsQmjSzoqEQ7QepytfHVOa3FU5j5aypekxWYpJH9/Z+zX9vsxhDqcJ0JyxEHy4VfYhNg4/14a8mUP0NkGqYmAXO8MFWMb5RS8jw6JEPAww5gDNkwtXxfp1hlD1mMGWEPmMClJW9IUCI8YzMKMD9wdN1wk6dFYofG+uJUa1mPjEJYUqXPjMV3aDK/h5yEUGuJ1BfsZBkD9pycytocVvHgBk3kQ1d4Gxjy/+Y8tdchayOuIs8S1jr4ZA0varw/i44j7y10iaIfYvoOcmKmKz68/vGGSDWfodM0eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LfhW4a9TrYUpzfFcD+xYJO41v7HrAOcKk4dVnPYWsXQ=;
 b=BI0DyU4UqAVS7IpodFO3+w+1C62VFsEJL35AMa6sO6XI6C1h8My2u7oP0aN0We+jLZ/H+Ct/cMxNIj1WNyGGpTcmFIuLXFGClhcY2JcgeZem+UQjbKXZaBOgM8BYFt0LEe7x3Cs8qr4gIrhk3uyOWZ86w68y2usm6zNFt+gL0VnHb114G4/HwTiS1tvzYHh4G/O/6ukZZFBcPP6O9Kk1oi9gbZpNVDKqq/Vzy8ocizb2Ms/ynvml//r4VG0Ucxnp7/Jz8B0ZKctAZ9w4J2R2m7QSjTjjZf88SphBzKTDQNSnahLUyK1oRqUAVWeSvluSw/2dfctkQWHgfMinhi5mGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfhW4a9TrYUpzfFcD+xYJO41v7HrAOcKk4dVnPYWsXQ=;
 b=OSe77MZIMiI04pqy+dbLlb9pNf5qX41fg8u33XyMxt6bWUYaqV5rFVLKS7u3LKX8VX1k/G7hiaLhE1Sxyi/uR/AnMiMmAsG9+SjHP1HQdqwPuAiyonTU5rtHUuuisvhl86flFKVW/KhE7Slh8epl4wgyVCdpCnKlHNTby9WwPh9AD4Zm+YUcGNNizQgsHtOT8EqeEz/A2fz+jBoISykNk2DZb5E4fJipBEK/ah6SwpHxgDmkuMtwssoDWDdDl7ZOMspKra4u5jpDytU244CFFAU7K2IiMJ5pMvvQXiFQv7gE++KIQUBbDA/Y0xriwedq8SXJm/Tistkxd1KM5XsIHg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DS0PR12MB9399.namprd12.prod.outlook.com (2603:10b6:8:1b8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.15; Thu, 21 Mar
 2024 13:55:52 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Thu, 21 Mar 2024
 13:55:52 +0000
Date: Thu, 21 Mar 2024 10:55:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Nicolin Chen <nicolinc@nvidia.com>,
	patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Daniel Mentz <danielmentz@google.com>
Subject: Re: [PATCH v5 19/27] iommu/arm-smmu-v3: Keep track of
 arm_smmu_master_domain for SVA
Message-ID: <20240321135551.GL1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <19-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV26pRuG02Leawej00mm8LZceO27yWUqn9rOwYBTKmtA8UA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV26pRuG02Leawej00mm8LZceO27yWUqn9rOwYBTKmtA8UA@mail.gmail.com>
X-ClientProxiedBy: MN2PR08CA0008.namprd08.prod.outlook.com
 (2603:10b6:208:239::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DS0PR12MB9399:EE_
X-MS-Office365-Filtering-Correlation-Id: da8a6786-ad81-4bde-ee4a-08dc49ae9f21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dsBEjCnZqatSTqMPgfq5BN9W/svcdORYr0PCVMq35mRGwRjtiTbfW4R0k5cxLA/NlhXU/mVOODt50AX1+NZpclRP5A+K7rdQd0gT78OaZjtSOHze2Kk57pURPzHxkl/L4shkbSm94U+eBNAAMbd9mSNBamg4jZA6gL07oW+sIqh1GrPG7rjIkdLKtTpZgmcw4AZcteoegkm3f3/dnRuufyJ3gJ9kKlgX2MFs5dxfl3022Y8hTPYMOXMJMtmtO4ueTVJK+69WTOVhOURHNFESjy4z88iFCCnwmDGVkdkh2lOSucJqz39eZQk8PFLgvaf/XLMsb6rXEKRsc7UgjXBjdxvJxX1f3aS9UU/qrN0Ps8FVyIxGhji/vslvVBbd4pELK509Z5t0Rc28iac5FKurFOKzEWBJAuRDwAdtwAUFFUSy2C2ixf1OZma7FTSH8EIXNK1r0owZn9IqUgTh7Xu0t7yoWwd+zIGaD76WZ9B2T45zUfKmWN3ZlkkIYZV0T06urvucAsUWbz1+zaD2D3c7iBvcPEBSRrGo/7nJM1FSzOw/OBE/fgkZ9yyyPHg50m4nWhcbxC+xe4AmiV5o5o6cb7uzh/NLJY+mVi9bI6iHBr6ia1g7RAhS0y+PqiWCxDoqz/YuqbSp4wZoUv4a2Ihyx255tth7yOx0vSXL13f7Gy4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cHhtSVN3NmQ3QmltVUQ0eU1RWEFVK2I0VGNqR2x6Zk81S1ZlUDNjcGl0L3RF?=
 =?utf-8?B?MXU5OUdQVHcxTUx2R3FoVDVRcXIvOWk0ODJvSkd1alU4ckNmOFJvMjBrNGR0?=
 =?utf-8?B?SWJHT3lCQ3N0WTJSQTR2MTIycTRmWDkzbkt4RzlqQlRJZ2Q5blVkRGhsZDJs?=
 =?utf-8?B?VnlEeVlQOE1UdnUwMGtUVExHOUhqdHlGajNkNXU3c09kMk9EN0drRE51K08v?=
 =?utf-8?B?amtmK1llUnVoaytTb25aV2d2UzVaWGczdkxxSmxGd3AwYzE0Z1o0TXRTdmNE?=
 =?utf-8?B?WGZPajNQc2R0MEF4Y0FJRS9JdEhHWC94ZTIvbVFTM2s4eEJCc2x4b2Z6OUZK?=
 =?utf-8?B?YXpCNytPbUhIQy9mWHhwY1Z2WlUraTZGaUtVWmtmTHlIeTR4SXZxWWw0aGo3?=
 =?utf-8?B?NVpLRS9rdUc1bDArWkdnTkcvQjQyNnN2Q04yYWVJNjJlM1Y0UkZnaFhNbTIr?=
 =?utf-8?B?Mld3bTh0UjhNN0ZGUzRjK2VSUTNPNzhCaXdXVEwxdWFhUDNZZTFLdmNnUGg5?=
 =?utf-8?B?aExDRTc2Y0kvMEwzMGZabVFTbDB2ZmZiV05jOFJKRVRMSUw4eVBpY0VLL2hZ?=
 =?utf-8?B?TXlxTUdCdnJpQThpYjUwZEVTVms4VzA1OUIrc3AvaFVyayt4Rk9EWVZDM3Nu?=
 =?utf-8?B?aTdwb2NpcHdmdXlaamF3RVhOTm9LbGJCb3ZjNTZ4WnZrY1JuZFh2Y1k3QWNk?=
 =?utf-8?B?Znl3QndiRmR1SHhnWmxMTkc2UXJ2Y0trZ3oyOGhGOVhudHZaOUxaUHZ3eHFR?=
 =?utf-8?B?YnJJUUplYVlHTEtJQmtsbjM3eXhTTTEzaXNPUWtEOHVPRVFHTmNMc0h2VU9y?=
 =?utf-8?B?ekczTk9vTEYwWkxEYUFEZFl2d0dYTnpqRGdwNVhkYVZTSFA4bXZxcElyUXZQ?=
 =?utf-8?B?Uk1GOHlpaU9GdzlOTzR1dEd2a3BHaU9CckZHaWlQRE04MEIzbkFoY1pCOE1i?=
 =?utf-8?B?b1VDcnRlb2FUTEpJTVVuVVp0TUxza2hVejFHV2xSM3FsUmVQdmwyVjFuQ2s4?=
 =?utf-8?B?aDdnTWJmcDdCNzBHeVFGU216dndlOXN3SGwrSzVpSWVWKzI5RGRKbTR0ZEZ5?=
 =?utf-8?B?K0p3dTJPa29SMlIxMnljbktIVTAzVUp6eWtjZXBxRHFsS2RXYlFBVmdhUEpI?=
 =?utf-8?B?K2orUnl2STNGbVJPMEVJbEk1b1VwTHdGRjlja28wUGRYL1pEa1ExZEZ1NGlU?=
 =?utf-8?B?MmpmeFVWN1NmYnE5UWRITW9HcGhLdEdTWlZvN1lmTWd2eHAyTlZFWURDdkNQ?=
 =?utf-8?B?UUlyUFcwQ2F1NnpIbW5UYVJqcWN4REhLY1NMZ1pDbWxvaWg3U2R4aU9oaU9T?=
 =?utf-8?B?U1N4eWFLWndZZGI0RllUMTFEM0xranpZM2dKMW5CSGxVUUZGZEVybHZnL2w4?=
 =?utf-8?B?T211ajhDVlBnaWN2TU5pWFIyL2loci95aTl2aWVhN0NNUDE0ZGNERDRzUWpR?=
 =?utf-8?B?Uy9qa2lvUm5SVG45ZXg4S2FUMzFvenBiMks3YnROL00xL29qcDJnTjErRnpU?=
 =?utf-8?B?WVhYcGxoekk5T3JkQWhuY0M5bXBUZVJRNXYwWWNOd3FiMXVhNXh3UXpINHlj?=
 =?utf-8?B?b2YxWlc2VFdHTG0rR3lidG9pQ1hrNk5HaG5zNHVDSjN4TGFYaHhOQXMwbDN3?=
 =?utf-8?B?UjN4Tm1uUHRjSFh6N0JRUDFBK2tCOGxNQm1Nd3dOdTJOaHdjeVIzQnh0K3Ns?=
 =?utf-8?B?Zi9Icm83WWJ3UWdBbi8xSWVHNUp3NTgyeTE1SnR2dFM3bmNzNXdIejFrR3NJ?=
 =?utf-8?B?YW41SWt1Y3ZxQXVKK2tzR2MrdytuNHloL25TWW1sZVV3aXNqR3ZQRVAxZU9F?=
 =?utf-8?B?a2pRNjc1NHZjdkZ0V0NCeTBML0JnSUFhZnluRVI1ZEp3aTR4dDkwckZ3RjdO?=
 =?utf-8?B?b3dGTG5RTlZ6YTQyWk1FcGxVeHN3bWVKNGhES2tIYkpwcURqWlU1b0hKYWJw?=
 =?utf-8?B?a2dDKzVDN2NQa0poVysvNGI4VUdhVjNja0VwK3Yrd2xhNUhFQkVIRzRiUTZT?=
 =?utf-8?B?SDBLaVNyc2lHWFBiQllzQ3dheW1ka2hUK2hsenM0NGF2VzBGQ2dwTEdCck1G?=
 =?utf-8?B?KzM5SHdYZ0kwVVlrVEtzSm5JVTluVVJrdWpid0hQMnBrVXZPTjhVbmpMN3Jo?=
 =?utf-8?Q?jY8N/WaWRhI6d9PZ4oPD4ONHw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da8a6786-ad81-4bde-ee4a-08dc49ae9f21
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 13:55:52.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFWK/LCWZoUm4zTfpiCRrHLKWFmg0xwqL9XBq1W0uou9Im45LU0OdZJl7/EqmUhZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9399

On Thu, Mar 21, 2024 at 06:47:41PM +0800, Michael Shavit wrote:
> On Tue, Mar 5, 2024 at 7:44 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > Currently the smmu_domain->devices list is unused for SVA domains.
> > Fill it in with the SSID and master of every arm_smmu_set_pasid()
> > using the same logic as the RID attach.
> >
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 23 +++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 2db2b822292a87..6d15fe3a160acf 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -2603,7 +2603,8 @@ to_smmu_domain_devices(struct iommu_domain *domain)
> >         /* The domain can be NULL only when processing the first attach */
> >         if (!domain)
> >                 return NULL;
> > -       if (domain->type & __IOMMU_DOMAIN_PAGING)
> > +       if ((domain->type & __IOMMU_DOMAIN_PAGING) ||
> > +           domain->type == IOMMU_DOMAIN_SVA)
> >                 return to_smmu_domain(domain);
> >         return NULL;
> >  }
> > @@ -2813,7 +2814,9 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
> >                        struct arm_smmu_domain *smmu_domain, ioasid_t pasid,
> >                        const struct arm_smmu_cd *cd)
> >  {
> > +       struct attach_state state = {.ssid = pasid};
> >         struct arm_smmu_cd *cdptr;
> > +       int ret;
> >
> >         if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)))
> >                 return -ENODEV;
> > @@ -2821,14 +2824,30 @@ int arm_smmu_set_pasid(struct arm_smmu_master *master,
> >         cdptr = arm_smmu_get_cd_ptr(master, pasid);
> >         if (!cdptr)
> >                 return -ENOMEM;
> > +
> > +       mutex_lock(&arm_smmu_asid_lock);
> > +       ret = arm_smmu_attach_prepare(master, &smmu_domain->domain, &state);
> > +       if (ret)
> > +               goto out_unlock;
> > +
> >         arm_smmu_write_cd_entry(master, pasid, cdptr, cd);
> > -       return 0;
> > +
> > +       arm_smmu_attach_commit(master, &state);
> > +
> > +out_unlock:
> > +       mutex_unlock(&arm_smmu_asid_lock);
> > +       return ret;
> >  }
> 
> arm_smmu_attach_commit tries to remove the master_domain entry from
> the previous domain that this master was attached to. It gets a
> pointer to the previous domain from the iommu framework with
> iommu_get_domain_for_dev().
> But in this path, arm_smmu_attach_prepare is creating a master_domain
> entry for the pasid domain, which may be different from the one
> returned by iommu_get_domain_for_dev() on the next attach.
> 
> I think this ended up being safe in the end because afaict the iommu
> framework requires detaching the previous pasid domain before
> attaching a new one. But nonetheless this is pretty fragile and
> doesn't look intentional.

Oh yeah, this is a mistake!

Commit needs to take in the old domain from the caller which knows
what it actually is.

Thanks,
Jason
