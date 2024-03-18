Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2050.outbound.protection.outlook.com [40.107.101.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EAE56442;
	Mon, 18 Mar 2024 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710785806; cv=fail; b=PK3bshTh3x84TQV3iTkrw1+v/wZAxy2ly3P74mKex5Mg/VKBLkUs9RTJ2DZ+FXRqhiBYQcUd9lIm3iopJA2SoEtnNAjrpIcCCpmId7/mbG39Lmh7pI2sGTb733HkUfgZwNETi2fLeB2cU4q5vktYb4fCuOfz7GihOjAQRh3ivPU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710785806; c=relaxed/simple;
	bh=f/PfidsJ7SfNGaAj3Xvom3gr5d3bssDKM80lV0TuRnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pFJ2NxBOcBl9MqgrfPUwi/MnmysYumKt4jG0o52KdenQoWFRRhsYvqbS5SSiOFWuJu/WD2TTJuyoCSnD0Oy3F65YusZLKPGPlTvJzsLawYKIXJ46X/JIxoNYm0lVq4J68MfzODBj/UvztnwTE3GADrkfy8y0xtTpQVcef8a3viE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VMMfPvZo; arc=fail smtp.client-ip=40.107.101.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VMMfPvZo"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TyewjhsE1IgKucCywowvZ2H8kujnbnFGAOHkhgUOJIx0P0rBLpTRFOH2nensQAagwZ4BrZLWj1rwwYUM0lwh2KMzE+L/VU78eC4yaLJfM02fje/J04N371tQVzJYLf6FfspVKHuU8EoW2HIuJCZ5VJ5WfLLp9YWeLAz7/CxwyrqsVoyifNw4vwnIFn6PkYFSl1x8Vm3MdSkaHGO0PC+865X7pmQGnrm/OUpYc55DM+SSslu84jnAR/F+GEot2yw32k0Ybh5AQJdSLVrfm8322S46xqiYHbaAVKoywjWjNQ3q6ioA0Wo/htcb1zzBz+evLIGhf3xPm9n3FvV9JAwo6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aT17nVV1upqJl+XQ0uylgh1kjjn4kiK/uncZ9UHXbBI=;
 b=izHon76/9GVHseZgavUg5k72GqiVV8+ykZPCP6ueUhGTqYE2jk15F2z6S4IGqwr32DOc+kSxKVQp3peVNJKFY99P716/FkoUeINqRJDfD2zGLvK0Ck8WWFbgO7JQwRxNyK6+i3iyipWqW7sTZpBTBZYYmHlA33VTRZ2SMe+KFLaWVcn43Nxaq/7SWxU0Fbiu52+zJnUqI2G/rDUYpexMrziITKTENdGJnX8ZaTXuHQDrFM49CfWSPsceXCNNYw+C6JDg/+XmP+tbHH4buTRH82eYed1aTQo3vdwFVpzZhCNWOroHE4nUQF3VOWyzq58w9d8zEgg7jEYzVX0LVID1dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aT17nVV1upqJl+XQ0uylgh1kjjn4kiK/uncZ9UHXbBI=;
 b=VMMfPvZoQaDkxr1/beuMvP+U7fyZLyYDILx2A5168+TeTy5n4ILHT2VGzmv0c1XnMR04dnfsUeQQwJHxA5rQv94Nhm+hJtBbDFZEqdqpwWa5IAFFIf4a0RIcjA2IWMJGg42uDY9J2+yVZ8xklOQrdBU/3qqmCQfkdYR/i+wdJmLKAMTt/IQNw85lDuZz/IubMWKPi/AOzp7EXU3sGm7wSsBKHaYW5dSTmzHKDdutzrP8EY74XluwkjOWpdxrsHWC/tdP3TWfv+k1IzXczsOjoQg/Q3pwfYQ7naoGArUXzf6ktB2kSVbCiwwKk6Ak+1Wzkbiui+HaBXw+xl3DuRjmoQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB8608.namprd12.prod.outlook.com (2603:10b6:510:1bc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26; Mon, 18 Mar
 2024 18:16:39 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.025; Mon, 18 Mar 2024
 18:16:36 +0000
Date: Mon, 18 Mar 2024 15:16:35 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 01/27] iommu/arm-smmu-v3: Do not allow a SVA domain to
 be set on the wrong PASID
Message-ID: <20240318181635.GI5825@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZfPCtmyN1v68UOha@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZfPCtmyN1v68UOha@nvidia.com>
X-ClientProxiedBy: SA9P223CA0008.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:806:26::13) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB8608:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df93278-9ad3-4c69-4e36-08dc47778cc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	y+RTeUnnjRsiqw0oa/AK9po6sczDoEGg8ocZVUb5xkvBRgRguIGJJeZqzKd03PIh+Ky2jpdlVR8iZMqGjI1oCD2Akrqq88MfJRVQbrLjwBibSd5rKc5F7iBiuaG2PpxrV0C1nb/Li3bu8ciMaMSkBs8UxRVF9dZQdiu9E91xmKqaVngTlYjSWcMXaEPS0Mg7h4pKW/4cGJFV+IOVeEuoZ93plWwfiIgW5kG+4ZCOb2sSdeB1hDKB6Kcxd9fo7ngGI+VJwYa60aJu1D/MSYyRAjeVrgAAYTsWI99J/Cxcs/D2qH/g5gbQmUzUraNPpD3QdelKCldF9Zuk8/+aQiQ75tRzgE/OzFdXh5Nem1u1ew+2KCb6BR6T/QY1DKTDuWOJnSGR3gi5KwIaCDQs95W6KbQFo+lYp/S5TnfhrAyJVzKZ5BpoKtdzt+nPWzR3jjIg6xv9AJ97FAIr5RlcnYC9wcSp3Fyq7iXIOL3MO47VbjxGLM8sMzPViolLwrJV9kgs+LUp0f6vTEb1CyNc/psWHr9palWm1KPxffm8i40qlbgZmLyptDydvpRQ0EipZ/Lxeee8dfwjwcBYp2x0PvDc3oVmmCTbY1+qICiyVuA6RatFzQfEeeZ+U7l/QeUmUaFu1ZDwkUXOAZxmuKTeiEZcWrNtZruEn0ubFT+fGspSgSM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IPUgDrsyJvfv9g631SyI1bsOxnnlNxJscKX00DGP7UzryKfUTc8spLZFBm0Q?=
 =?us-ascii?Q?U3zqme8988T9CEIMCcBH0VCN60BM9QNJriL726/JclcZkzSGysLl0kHF3/OJ?=
 =?us-ascii?Q?+bQq23Z92bRFj9wBEsPbJ8rpxARfyfMD5AX+jkQsFZifuP5iI6p2boAbwodP?=
 =?us-ascii?Q?kzCq2DVNOSM/kuxRoM7DPTYtG19Mbt7RB7Q6F0qlDWjNuh7VtfCjsf+CHVkL?=
 =?us-ascii?Q?JyVbafNMf/DWsYbKwWUYdbYAKsgSK7i4rgb7ak18tIyNzVqurKXl9rc5ThWL?=
 =?us-ascii?Q?eoqA+GQuXO9JDaWi19P2cWx0MiNKkrYmz3tDFNXEnQrIuemuar0q/HdzvZoW?=
 =?us-ascii?Q?tHLWw3uZtTGCrblqH4W1dgzkHrFl0qX0d723DZEUKLyj8ojImdWtkzRMn+u2?=
 =?us-ascii?Q?tcdRq4UEgoRUJyBh2VjHB8SRc/u8Hncis866te0BotOSLvDtAMni3qu0mDh4?=
 =?us-ascii?Q?12d9hi0u5gaxyrN2VXEpi5fc/RGLNF3lYHNr6QzLVO9u6kXDhV2Qq9mxuN+e?=
 =?us-ascii?Q?w1G2ZQJJs0zLfllwdNR4nGZjBcRR/JIu3wrFfJxJEdAKQIXR7PFrk5njsREn?=
 =?us-ascii?Q?nc3pN4UOgnEQ3FYnC+znTXCHUyHlxQCYIvdZZsZeP0n0v3kISkJW7Q+YQ07p?=
 =?us-ascii?Q?ASQ0IKetQaE+ifiK8m6KGhLrXx6WU2qS/QtL2gxyNhfoQfT61yQDyDOTmsaf?=
 =?us-ascii?Q?sKaqOl0j4cXyrlz/Boxri6hLFAVvaiPAjAaeWSadWELaPZeng5i95cKsCtBx?=
 =?us-ascii?Q?tH1pw4ATWZk7Cn2BIklm4JvJxXQC/gANB1U6cigNotmgJLftd/Fk8pDrueDU?=
 =?us-ascii?Q?CB95N9ncilk65lgE1DOcC53lSKhd7U2quFs49T6sYF/VMrgLVR749ssiVKme?=
 =?us-ascii?Q?g3S94D24/KOexOCfFJo9VUEFH9dYfXDQ0EjwV5UD7/R4bW4QJKgL3pim2RNx?=
 =?us-ascii?Q?Jr9f+s/935iKgRtrOsq9x8zquMEEsfgp//tL1ARsydqInYnnYBxePReujPny?=
 =?us-ascii?Q?s6YnZbDNXGvh5ozYUICH4EZf3qzElXzkQNrRvxVsec5g0ZFYPs8ir6ko9218?=
 =?us-ascii?Q?2JDmUmi6hXW6OUvlQIGGhBbQtbBLOwDb1qzBS9OwOewrpoFvV2G5Boz5P6p0?=
 =?us-ascii?Q?JY0r51waqxauefUBGyBkGiGQaYBafIzbiz2EY4e6kqdwKlLtQDlZ75mijK2u?=
 =?us-ascii?Q?JYemh0ML9syg3kOZJ9Isio4hl7g16+5feICE2nkpGloKGLp3djNH99WujwnR?=
 =?us-ascii?Q?HYWWRh5IeDLveex2ZewYKBs8wcl9E3an9FKh1nsoo9mHW2Q6I2HzPfeothCB?=
 =?us-ascii?Q?3uFYMj0mm0GO7rFxjME+yBTtpMbGYXuX81VrY08kSg+tIoAH5CR8B/M3zF51?=
 =?us-ascii?Q?VpIt6UgkNC49YHAU85RwsVex0X/vcum3DsAnjLm0yu5P7HgA2pyhf3tOQx6P?=
 =?us-ascii?Q?rdA0+Yp+RcyqfE88PdtFensrCabpRBAJLl8jDOif5GQqiUllBklY4ij+EEhC?=
 =?us-ascii?Q?Ht8GUk/VAu+vERKHVBaPaDCgBNu8hJkO7USs8+VT6T56RHHN5m6SH6XleWrf?=
 =?us-ascii?Q?6JLruJUm2GfCWaLLQLQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df93278-9ad3-4c69-4e36-08dc47778cc8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2024 18:16:36.9306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OkwKHG0AO//4zbIw9M8CeLbkLiJmEYux+6jZ2ccZAv6jr5YVdwFDBWCX46bPh0Wo
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB8608

On Thu, Mar 14, 2024 at 08:38:30PM -0700, Nicolin Chen wrote:
> Hi Jason,
> 
> On Mon, Mar 04, 2024 at 07:43:49PM -0400, Jason Gunthorpe wrote:
> > The SVA code is wired to assume that the SVA is programmed onto the
> > mm->pasid. The current core code always does this, so it is fine.
> > 
> > Add a check for clarity.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index 2610e82c0ecd0d..347c2fdd865c1a 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -581,6 +581,9 @@ static int arm_smmu_sva_set_dev_pasid(struct iommu_domain *domain,
> >  	int ret = 0;
> >  	struct mm_struct *mm = domain->mm;
> >  
> > +	if (mm_get_enqcmd_pasid(mm) != id)
> > +		return -EINVAL;
> > +
> 
> This seems to get deleted entirely by a followup change. Is it
> added here to ensure a 1:1 mapping for git-bisect?

Right, it is here in the series primarily for clarity, but arguably it
should be backported too. I'll add a fixes line

Jason
