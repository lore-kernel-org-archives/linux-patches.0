Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2044.outbound.protection.outlook.com [40.107.92.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9546155C0E;
	Mon, 18 Mar 2024 18:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710785483; cv=fail; b=Zr3K8vZ5RUbsKP60ShC1YS+sODOUpWNmh4LvD7fYuVK3skoycj/hK5g4T4gYHvUi+Cq/fVoaW0ZAU9yLkeIh97G2JSzhRPvPBt28D0P3CqUevlbnv9Zy3eyiLqj/aMR3YJO3Gz1GPflSCssIjXzQEfXwB8CpejOi0bELWmTu3M4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710785483; c=relaxed/simple;
	bh=z0gfHKT31Rp8oqoD5wZnMjb8dh97ybOuB5F6Ibs2UL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fhlXPCGMR/hB/JtByJ6uUvHERhiLE8GmXqmiPRCB0zxcrQPAaLEjPt2Xh9h8Y3BnE3GWsibEWACd2W9hbWp04sZXmDLdguIxZGmIQQsB988DCr7etFwLNEXFdNFNC0x4wuNuvdRslx0M6ZHHhV73v77tSJwSXviMSHa5QlDnA/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Ok0HV1Ol; arc=fail smtp.client-ip=40.107.92.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Ok0HV1Ol"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S73LrlftwEM4Z2hUgHOlaXLTxb//sli8TVBxyP/dVbrHKZiweefH7GVSCEgIcOfkSgcG6MlT1v6VFp5+CyK+exk1GhyJrN7f5bPNMKDVBgLn8zXcHEq9GghyaOgmUqyjRtaU0OCFYC1s5OHxRykUsRi9DprXNOl+D9Q9O+xh36n9hAq0YmvCW/CHSMv4gqU8YPt9GxWQACYsW7ZnoOj1tW4TAIVByF7+vfS7onx7O9P7oKoo5RYOtxBkg5Q9vv+wBA7uJfiWJWyg/lZ8Tkr+soKYXOmXcvLZD2TGjUFNND8dI3C8YXQp7jI0FwCVuOeOnoDbBxT0UZTydt9QLi6CBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lx9wFPYvQ+PFYrMSvJJ4soP8LCZeP1vf8GhwRgY8Tqs=;
 b=eZIqAVPDFrVeUjQM1x9Nf1p69TYWnXKof4n8dSnaYTUg39MnzuijPmk0Twp97FLFVypPOUnCroivVAVseumVITbKhnv/isJrcIV9R0N9WF0GS8SJL1qEcFkFaAeiYE6uvYBFSSRd8EvWRQcNgeUiMpqlZ8qQ+BcbuzQcwpBhRMa7aQsccxNQjdm2N4TXpB2dnN5p1NozFESYqWlaloAAPyHm9kj0XQr8iFCDZuVP6SfdfMUc5ZpTn7XGxnzDKe6ejIVOzTF+SeBv015+mZxuHC+pY42kGtW+QA2DV9qQQd7c4MCP0adyLOSAIjkzyhqQ/adZO9qGfrquYhOrweNWKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lx9wFPYvQ+PFYrMSvJJ4soP8LCZeP1vf8GhwRgY8Tqs=;
 b=Ok0HV1OlL8wNDuAM9dG/CMjL5lKdBoxprMIEL+gpLpzrqE0Rl4urnD7kh2E4tedjxgDo5trXaDE4+dTrlxtQtn25uKZuBS/iDH+A3QyB/N1svXCFb8snBD3znSab7hBhyq+MXLfEhqhbv1vVk5FuQyZex2r8q26a6y0ZpgDucUAlKDbqdUnBTkQRoNfFqPhUgicDzbdcrKobdrLciIwqJ+HQyWxMzo1KHKNVhiMd7qRWVmj6a/bPDREGZOK97+IvPHdLDRb+9rhh7tPVo+1oIGppId9R+PK5Vi8UEkbBOlL9NRMpY0iAPmmibb7A24/Q4hMBoEyA/0Ik6aoZ2wz4Sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB8608.namprd12.prod.outlook.com (2603:10b6:510:1bc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Mon, 18 Mar
 2024 18:11:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 18:11:17 +0000
Date: Mon, 18 Mar 2024 15:11:15 -0300
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
Subject: Re: [PATCH v5 07/27] iommu/arm-smmu-v3: Move the CD generation for
 S1 domains into a function
Message-ID: <20240318181115.GG5825@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV25_FzGHY8zEsXtR=vsTi3k2F8Pm4nY9wYRKudJmnk2LWw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV25_FzGHY8zEsXtR=vsTi3k2F8Pm4nY9wYRKudJmnk2LWw@mail.gmail.com>
X-ClientProxiedBy: SA1P222CA0043.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:2d0::17) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: 62693ccd-4daf-49ff-3ffb-08dc4776ce86
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uCOUx5JmUo+alPXaAn6mmNMaBZlzb06WcUt4BfDbgEjMNbbqcDHKfqVltVVHHkm1FhTbG0GXY3d9HYSmH3j4lfJBG3Koo/a5gGseV0mwg/Sh+9+to6GJ11zRjP7pb7fEiBShYkP0wZBa8Aksyv7cxmZQBPgsGl/5CgXzDbj/HwVQnUvRuHaaUmEsSpwMWh3BNaTdvPRA8GsT+EmxQ7Hl7lDcYZkiFWUJ21wMDx99QUY8XiVXUNbnZoT+Hx+AOPLS61WjBTBmlKWwitEfcShyzL8c9irvBO6OAxCLOjDEjWY6/uA7zlavmgHe8W0sH4Hg42MEKgyh2g3e+hB2QV9KakQp6JDKhsdjnjsLM/QGlAScyUoKgwH3fMwcnVLV42q3aeTHcmpr0Z9X2FtHPsCVoWSpUjoZUQQsYIlca+9YzKbfBvymh6xYEqIdn6MxnPDJdH+jA/sWVdXhIVezWnhdE1pro4mL5DKGpqfkc4wbYfzgUdaukXZgm9+BqnTY10+xUHEKyI1MRniOJZ2tqHiUJnTmC1l/zySaPc8YexGOFgcq/MxSyaWLK5zY0XZDxlYvgDs0elirrhGzvkp3yIPwN6Aq9RpmsDTxt9K7u/60C80dk88gQin3jmlGR+tTLURFGdtXhfC9JxmK03DpKKPH2g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CcUW9lV5iG+loPSYBFZwcfvjxPmEl5XOf8Zt3FZcOMKae8J/7ztes0BXL0iy?=
 =?us-ascii?Q?UM5GhW6t5fjdhuSny0Fu7rWcN3HIz45/wenLT/G+AqKAYra9QaMFxamA/D25?=
 =?us-ascii?Q?/g/m4zGIOOyijn93TqQXqcU+nPfPGpBjMDF6DfF2CF3EAa/HWa9f9/BQ2Igz?=
 =?us-ascii?Q?QCSHV19vYJkFSvtGQbDfVPOztaf3mTxjzZzA/1ugKleJqBHyYprS9NTN/8Xj?=
 =?us-ascii?Q?H+BBZxxego0qNOziuXgS8unYl6th8AdhEox6FrPuzSxQRxpqv/Xh4NJUgNms?=
 =?us-ascii?Q?LAnVuNfg4jYFGT8SouMCYAXyvXt5L3hPLWc+5L2HXKoa/ZQvgeYx5y7pBzy5?=
 =?us-ascii?Q?9xRlCDb0LZ7Wc/FUeUUkOl23Q8AMANuOxA9W4YcL5BE1v8rTNjQrE94p23AH?=
 =?us-ascii?Q?6jAM1xP8M81vH3pMb5xCghAjcoSn6GCHP2/UM4LzF9QPeiyBINNsUeJWQzio?=
 =?us-ascii?Q?LeAYZ/BYcbJgjdAhvHmX8vL9QqSRiVf5WSQ4MfUkhIA+tFTLJ8HUYeRQgUUS?=
 =?us-ascii?Q?ugZNfynmb5cLXwGp2Q1vnAfNGcv6mjYNpJyeXhGVcPTqOlG+Rf3lIdO1VpAV?=
 =?us-ascii?Q?x24L450vM0M8IBqQNi7ejY2C9cOTqG0/OaBVU60MyR403b4Ke2AwjXsnZl6W?=
 =?us-ascii?Q?Bz++POpMM2A+eIRaaPwXWlpmuPD9H+8HbXcgx9joFLBK6VJ/Or4g/nZBtrNs?=
 =?us-ascii?Q?5s8KlIPCTWN47o4yx5kRAYkc/4hbgl5KdX7N7kM+7FCgBNRPiH7uQXo5i+MF?=
 =?us-ascii?Q?v5UdcniRWlZS9sn6egXAaQaWOKgKGkKF4Ds716kPjDJF4uKCSAriPRhAmJbt?=
 =?us-ascii?Q?zrvkHh2JAfFJpqOo7o922S1+OL6MXrjwU9yA/wwnHnC0cO7eld9QTVbdMIMr?=
 =?us-ascii?Q?wvS0Fvdg0KlUjo/3s1J/vZ6raoBfJZBNVIyeqiuSb/S8OXf0p3b8C3VI0izu?=
 =?us-ascii?Q?bEdbp+Y0zPZnpJ1zH91gBxNuK02jMo4Nkb9PjTLwDkOI8nlHAqApXZIR2fL1?=
 =?us-ascii?Q?OeCJUnrCwgcy1X/nL5u4OAe2/7/Sq5ICu+A1/I50bSVyWsVtwa2t5RIx0eIT?=
 =?us-ascii?Q?QqQBOekc8eBaT9H1CVuRin3LrxnrFQFLTYXC7wz6sjPhZFoKbOcH16KW6cOz?=
 =?us-ascii?Q?OQS9XhEe4Emp6s+UCA+6R+fUrkj3dNqZn3TuwK5o9X2dZooo5WGJEXCeYTxT?=
 =?us-ascii?Q?LY9JliFsThOEeAJmqK63bPfj6eZ0jYXqOg9SOpDPvXIKhUW9uHMuq2voLgqV?=
 =?us-ascii?Q?2k8Y2+5YFV3Pn/p6NQEbffEfbNq2xv4WhKgsN3Hp67Ro7qe5xSF3JqwJ583i?=
 =?us-ascii?Q?ntOAHYjYJK0+53DCzZFHBQ9WD/jtkDg7KIXi79aHPZwrPYDY0lSiOUOUzIIj?=
 =?us-ascii?Q?aCMI0PLtrP2hQREHf1FgeTfAN5u2A8/mzGiFUbc60jag4q4VVnmjf1EhFvXa?=
 =?us-ascii?Q?0GvV6bnQ+52ujkNNwzgQn3d0eytF56LHmftz8BN5SKyHocmavP4Kv2Ebs6QG?=
 =?us-ascii?Q?hyd4Jc6Yszfr/j766fVNTOF4ffYuQy5qePMJOetZe2E9XjuIJMvQMFFxJ3Lk?=
 =?us-ascii?Q?ze1i1GQdkqK8kHoS9qA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62693ccd-4daf-49ff-3ffb-08dc4776ce86
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 18:11:17.7868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZtlSjMOcza4NnhLf9R+3tVQI/JVH3KAGoP7bvpevTmQmUnKxF4eZ9o8O5258COLh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608

On Wed, Mar 13, 2024 at 08:13:12PM +0800, Michael Shavit wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index bb9bb6fd7914ce..6acc65f6d00a71 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -54,6 +54,29 @@ static void arm_smmu_update_ctx_desc_devices(struct arm_smmu_domain *smmu_domain
> >         spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> >  }
> >
> > +static void
> > +arm_smmu_update_s1_domain_cd_entry(struct arm_smmu_domain *smmu_domain)
> > +{
> > +       struct arm_smmu_master *master;
> > +       struct arm_smmu_cd target_cd;
> > +       unsigned long flags;
> > +
> > +       spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> > +       list_for_each_entry(master, &smmu_domain->devices, domain_head) {
> > +               struct arm_smmu_cd *cdptr;
> > +
> > +               /* S1 domains only support RID attachment right now */
> > +               cdptr = arm_smmu_get_cd_ptr(master, IOMMU_NO_PASID);
> > +               if (WARN_ON(!cdptr))
> > +                       continue;
> > +
> > +               arm_smmu_make_s1_cd(&target_cd, master, smmu_domain);
> > +               arm_smmu_write_cd_entry(master, IOMMU_NO_PASID, cdptr,
> > +                                       &target_cd);
> > +       }
> > +       spin_unlock_irqrestore(&smmu_domain->devices_lock, flags);
> > +}
> > +
> >  /*
> >   * Check if the CPU ASID is available on the SMMU side. If a private context
> >   * descriptor is using it, try to replace it.
> > @@ -97,7 +120,7 @@ arm_smmu_share_asid(struct mm_struct *mm, u16 asid)
> >          * be some overlap between use of both ASIDs, until we invalidate the
> >          * TLB.
> >          */
> > -       arm_smmu_update_ctx_desc_devices(smmu_domain, IOMMU_NO_PASID, cd);
> > +       arm_smmu_update_s1_domain_cd_entry(smmu_domain);
> 
> Not to be too nitpicky, but is calling this
> arm_smmu_update_s1_domain_cd_entry the right choice here?  Yes the RID
> domain has type "ARM_SMMU_DOMAIN_S1", but CDs are also stage 1
> translations.

A later patch will inline this function into
arm_smmu_realloc_s1_domain_asid(), so I wouldn't fuss too much over
the name..

But the name is trying to convey the two important details:
 1) The domain is an ARM_SMMU_DOMAIN_S1
 2) We are changing the CD Table Entry *not* the STE

One of the things that was really confusing about this code was
exactly what the smm_domain *was*, it is actually always a
ARM_SMMU_DOMAIN_S1.

Thanks,
Jason
