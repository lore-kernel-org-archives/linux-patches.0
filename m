Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01A56BFAF;
	Wed, 20 Mar 2024 18:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710958874; cv=fail; b=gA/tSVIiLpMHuL28G5P32oFO/Bq3w8RKotj0BRQC0Q7NUyJQ5Pipcen3glX7J+hXOBYRy0xJ68Cujq+RyTsuHY8OpSoySf1VHZMjjkEwA5hp2Ug9RllqDwKd3OCwnxYFH8fqfNojuZ9Zup8rF/B3Sl5aMt10u4V+wzs6mFDPBxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710958874; c=relaxed/simple;
	bh=0bYrqROff3jbOWjbx5HxGcjg1onKwJbCU82W6sUV6nM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ow4reWo/sYWuXRELXLwNa39iQKGbFSS4/vrb48iIlseYsCj0Nwx68fBlxATTs7x1qpOxXtNco62FaESSX0nao/0nUsxBGfJMi270t7ThDUlxm22V/y5lCklmZaHlsZVlDOy2e3Fo1V+oxU4qz3j5r5f8XbBHi/6+jI3Yx/btum0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=U6KjjWJ+; arc=fail smtp.client-ip=40.107.237.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="U6KjjWJ+"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcpqgg0t9r+Yaio0rqNZFxQHzxObLi5SzzJw9h1abcdfTmBzlKIiWtzFEP3NqN4pL7w3WcHsTl4Au8CStHCwll4NcYORHuOXavT2AwayHKaAYRNPZORVD/iS6yrNuQCgpjw9qcGY4MekJhXLn2yMBNCWJc/RgV8j4HM4mbt62VllNewuFVWgxlOS0PAwrHmU8dWDmpnY9m9buh6xvsPHiHRVzG9ZtMaq/fMBGdQLuFBzv+kDMN/v+N+F0tGJSp9BeqVdnbFaSTrPBxFeehX8RPrejER+YGrFGEsYoZDfZp9OBd/jX+qsHCEdMJhOWhIaH0FKuK3iDrO55FU/daUKDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gBshZOvkc68yUGGOdN7x1ntGoMRKoySeZSuADn1JOc0=;
 b=lW4fwe2T+22/lBmkcAM2765v2nMJ0AWo1LwkbReDSIpCVe1ldehBqutb972k5LmVpT5Ptxo4eB5HtQGuvfus8G8PP/F+G0yxI4eYbzVp/e29aBbWmVsFMuk54FssafWSeLIB6g+FweEJVB/56cF4StobpeM/ND/8SO/Ri09uMmxqMDi/2oChj+ihBGDugn33gOr+1dsJV+btmS1SqMy6teZZPZCaXKNMoYsT+qJXKfSrWSvxYEBwOyOTvaxAio/czXvNwc0izCz37b6KU5N19dNSKV0SAXfxKKxn2jzpWhVr9sXGU17hQzkuIjXXw9sjYQ/nEpgGQ3agFuLbn//ziw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gBshZOvkc68yUGGOdN7x1ntGoMRKoySeZSuADn1JOc0=;
 b=U6KjjWJ+uUlUthZdRFc6xJ+iiYumiJj72hrY3NW/pNj2sr0OVEbYM9zP1Od5O/lBh/xbBIzxWH3CuiU1B12haEzo2PPYL9DzouwzV42NIEKyuyMyNWCmRl0UOFDORKm8Q0nPyLS0ZRg6n3eYAdv7w1rkiKgTTNgaBDHsiENTLvm5DscScNjFTypeX294cMaHlrnnRpu+Gp/d8Clk+1SOKPMpo2q0ozPUwBTnQomR4xWITste2UyTACBytZT6sV+P8d49GEbhMPUCwbJsbYXf6LipAEq0lWOEtZeyjpgLAK7iy10pQhWY571rskk4Px+NZXRFeR4NWd3xt9SIYWdywQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB6806.namprd12.prod.outlook.com (2603:10b6:a03:478::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 18:21:07 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 18:21:07 +0000
Date: Wed, 20 Mar 2024 15:21:06 -0300
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
Subject: Re: [PATCH v5 16/27] iommu/arm-smmu-v3: Keep track of valid CD
 entries in the cd_table
Message-ID: <20240320182106.GF1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <16-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV26uFZW_=fEyLTZpx_aVVBS-t8mRn30hx+JvyLRtpw0g4g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKHBV26uFZW_=fEyLTZpx_aVVBS-t8mRn30hx+JvyLRtpw0g4g@mail.gmail.com>
X-ClientProxiedBy: BLAPR05CA0045.namprd05.prod.outlook.com
 (2603:10b6:208:335::25) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB6806:EE_
X-MS-Office365-Filtering-Correlation-Id: b52550c0-894a-46ed-8524-08dc490a8316
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Elzn8erd9KFI0xWEYLZblyH78LHWc3Nvy2NpK71/WZT4O5+R64ZYyDIHaW3mpiLMADFgJmZKtId9UgRKK6fdw914i0bA39+c9e0u0l7zcguIBgqwoedktZ6I7YChXbSeg8lSjtwflcM+TBJvyS41iUMJDF66lLvFlEShf9EiMZuSShdX2VcwCja7q5Rayn6w9EzY2fFwifdvMeVkGb92JV8HpZ9lWHcKfPUyywPUu5QmUx3GB7dHUjFMuFQXgewuLWJFV6x4ybm4aOW2gutIo6ndSOWmZgrwFxo0fvPtkgzY5Ba/s8CfJ19p8j8NsOxeV5bc33AxKg1YuTitDSP2ZB9h/ZsjqBITLgVlF4y/SQUSKVgagOH1T11LpNmwG8X3yyhdJrhKv1PfzFvDm29QV9PyTQq7BKJKgrnnyd2mnR9vPKPUYKY14z6dIcQbPojgvvAqtzPuti2EA9lcS6K+UAH9YO5atSjMA1L6uodIHQCTp4iPoMBzz8PXOooi6TN/PNWY7263ySCXO5oW3hMIO9z7ybQJz29M2CGsQExr57xmdpkfm7Qnh4WqrJf+jjP2lDy9z5rsYq7rWA71Wgy43gjrv1CShqe8w6ydJlvWSbNkmTZFzo03TRFMxw6RvkaGGe05KWjgEkE0jnnMYB96iXX43f6cnkqRC0l6FPWbXDk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UzVIWEJqWG9RTVNGdnhqM1VqTkoveWY5M05tTFVmL1hrbzQrZWFOQmJ2K21k?=
 =?utf-8?B?ZnRJTEpjWjBockpVTmtQUGJiSzRERW5xWFpsNkpyczJCRmphaHhyNDE2WDZ4?=
 =?utf-8?B?TlpXdityM21FZ2QxUGxNcnlMMzlicGM4WStmNjZLa2c4T3BJOTRiQUpQamlu?=
 =?utf-8?B?bmV1UG5OY0s5OWJxSWpZY0xIVWxKeEl5dVNIc0JHTjRqNGkyZEJUNTcrbnV4?=
 =?utf-8?B?T2xUajBObXRoMjRGLzhoZWs0cWtydjVUM08wbG5pT0RzYTNuNVY5UURmc3pD?=
 =?utf-8?B?dFVaa1I5OGpweE9JM0RPemw0TnQra1RKQVE4UndrWFJMREc5K3d2T1Y3QVl5?=
 =?utf-8?B?YVhtazNvamloWmdCQ2tyZlJkWThRK0k0KzBPYkNELzA0L1VhWWx6d0Vxd2hr?=
 =?utf-8?B?M1RRVnhtTmRoU0JmZm9XL0VLTWZmbXBDSUxJb3F5ZnA3MlExRGgxZ016M1I0?=
 =?utf-8?B?TDBiLzN1N1hka3FGNnBXSTgreXdZcDV3QmV3YXF4UVhDWkZINnlpSGVIMkl5?=
 =?utf-8?B?WU5xcE9jK05lbGRrbXBYTVM3S2doYUdLMmd6dzBEZUdjQ3Z2aVhOSloxTkg4?=
 =?utf-8?B?eDlVM2UyQjVzYXVaazErek5PYVQ2RGtDQW5Sbml1aHZyeG9mbnVrRE02bTBh?=
 =?utf-8?B?bEVjYTE5Sm55QVQ5WmpQbDQ1WkkwMEMydis1aEIvbnJHVnVwaHhxc29qRXo3?=
 =?utf-8?B?NDN5Q2J4dm1NSEZRUThEUFdCcVNqdEthS2h6cWpsdkh6czBadkNVbjhKczlq?=
 =?utf-8?B?UHBMaU96bnFBeDYrR05oZko4cHh0NUN0azFWVGpSQWFlcERMUSs0RVFnWTF3?=
 =?utf-8?B?NCtmREdmWE5ua3BSWHdISWZQNVZpV3paVHBMSVMxRm1BV0NMeldsbTc0cXls?=
 =?utf-8?B?L2Z6TEYwQU1qRTF4dGs2NGEyd2p3eXJjTGl5eDlSaEtXRlk3S05ocy9SR1ND?=
 =?utf-8?B?SHVJTTdMU2duQ3lsR2V4Z3ArMldML1hsQmxNbkl4Q2Z3TFFIL3hIT2FVQUps?=
 =?utf-8?B?eTVkRDM5TTg3NTdYQkl6K1VmQ2JtNWg1RXBLQUNncktlMEcyZFYyQ1VPcXJG?=
 =?utf-8?B?SWtMeG9hNklrcjl3bWR5bGIxWmVDOStEeTJibHcraU9jU1JVUzV5SUtUNUNw?=
 =?utf-8?B?YmVPNktrRmsrb1Y5OTJFYXV0STdYalNqZm1TcHcxL2I1dmtQTkhlaHp3UXNQ?=
 =?utf-8?B?YjBNRzBVa1grYmx1Q1ROampTMHRGSDZ2Q1kvV2FWeVFPZEVvb0hCLyswd3RH?=
 =?utf-8?B?UWlWYnYyZ2s4UzBjT3g4L3RiTXUwcEI2OVl0MlpkRXJIczlqTWgyckxWRndL?=
 =?utf-8?B?aXBNOE5Ob1pIME5FSS9nZFh2TlEvN3JoTEEvVVR2NmdnQm9sQ01Pdm1aSzVV?=
 =?utf-8?B?bm5BdXcrZ2c4b0JoQlNneDlWbThRTXBaMGdsK2VxMlN0M3orUGhoZVZRajRu?=
 =?utf-8?B?UEhRKzVFcUNqU2ptd1NIWUxqOEcyaGY4ZEV2S3dkVlpDdk5PTnQ1eXBzMW0x?=
 =?utf-8?B?MUNOU1VmUmVjVmRsbjhJSGhzSXcyVVExdDBxN1UyVHUvNHdEWWEwbXdSVW8z?=
 =?utf-8?B?YkpDdVFweVM3dFJCWEZLYUdYZ3VhY01ETDlIVGYrVmJaSFY5Rkw1T1AwWlhv?=
 =?utf-8?B?QzczV1dycWM3WjhIbUlwa00yaGZXWVEwZTBJMHorZXJlcmU3Znhod2JHS2Nn?=
 =?utf-8?B?UklXOEZCSWFnVC8rQStwbVJleWh4NWNpRExGaTdBRGlQMnBobHJncnpsQ2RY?=
 =?utf-8?B?YUhWdE8yang2d1F4TytOaXE2dHFKeDVWRFJEeldqNTRITDVhcys2blRXT2Zm?=
 =?utf-8?B?bjNyM1VIdHdES3ZYbm1ROExNQVZhZ3kzV2hRVkFqaHZjNEpKYkJNV2NlVUlz?=
 =?utf-8?B?WUJnUmxONi93SGc2ZHF2eVk3L2ZCSGdTWk0vT0dBTTc2QmE3OWRrZjlXb2ZR?=
 =?utf-8?B?WkhIdzA2QU01SVBkWkRodjJvZHlzWjdPMkRwblp3VnkxKzU2bUdRQnJtZWlk?=
 =?utf-8?B?NStISFJIQno3TnJWU0tsc0QxSUFBUkptclR4aXVvMlZzUFM3ejdlWXE2R1lW?=
 =?utf-8?B?a3hnTjZhRllOQVRJSWhWWStMTjdYNGhMc3JXOWVaZjY0VWpEeUFFTlBBd2Vv?=
 =?utf-8?Q?SxFOPoq8S5mXgyGWMThUo+mHb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b52550c0-894a-46ed-8524-08dc490a8316
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 18:21:07.9037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bcREpg8xgF9ZzPC2BdG+vngjH6g3j4lYIgmGbDLcsz80ZTEyjHw0zBbWLCdbU/G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6806

On Tue, Mar 19, 2024 at 09:55:17PM +0800, Michael Shavit wrote:
> On Tue, Mar 5, 2024 at 7:44 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > We no longer need a master->sva_enable to control what attaches are
> > allowed.
> >
> > Instead keep track inside the cd_table how many valid CD entries exist,
> > and if the RID has a valid entry.
> >
> > Replace all the attach focused master->sva_enabled tests with a check if
> > the CD has valid entries (or not). If there are any valid entries then the
> > CD table must be currently programmed to the STE.
> >
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c   |  5 +---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 26 ++++++++++---------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   | 10 +++++++
> >  3 files changed, 25 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > index ab9de8e36c45f5..82b9c4d4061c3d 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c
> > @@ -433,9 +433,6 @@ static int __arm_smmu_sva_bind(struct device *dev, struct mm_struct *mm,
> >         if (smmu_domain->stage != ARM_SMMU_DOMAIN_S1)
> >                 return -ENODEV;
> >
> I assume this doesn't matter because of subsequent patches, but the
> check above could also be removed since used_sid precisely means that
> the attached domain is an ARM_SMMU_DOMAIN_S1 domain.

Right, but lets move the delete here for clarity.

The same comment applies to some later patches too that do:

	if (!arm_smmu_is_s1_domain(iommu_get_domain_for_dev(master->dev)) ||
	    !master->cd_table.used_sid)
		return -ENODEV;

> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > index 98dc5885c48655..7e1f6af4ce4e79 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > @@ -602,11 +602,21 @@ struct arm_smmu_ctx_desc_cfg {
> >         dma_addr_t                      cdtab_dma;
> >         struct arm_smmu_l1_ctx_desc     *l1_desc;
> >         unsigned int                    num_l1_ents;
> > +       unsigned int                    used_ssids;
> > +       bool                            used_sid;
> 
> This probably deserves a comment. There's plenty of places where the
> "rid" domain is handled as the CD with ssid 0; but we don't count it
> as a used_ssid here.

As a page table? I didn't think so, the only way to get a CD page table
installed is through arm_smmu_write_cd_entry() which will capture
this..

Non paging domains don't get captured here, they are translating the
RID but they are not using the CD table.

> I also don't find the meaning of used_sid obvious, especially if I
> didn't have the context from the commit description.

Hum, okay, so looking over all of this again I think we can
simplify. At the end there was only one place using used_sid and it
can instead be calling arm_smmu_ssids_in_use() directly:

@@ -2987,11 +2986,13 @@ static void arm_smmu_remove_dev_pasid(struct device *dev, ioasid_t pasid)
         * When the last user of the CD table goes away downgrade the STE back
         * to a non-cd_table one.
         */
-       if (last_ssid && !master->cd_table.used_sid) {
+       if (!arm_smmu_ssids_in_use(&master->cd_table)) {
                struct iommu_domain *sid_domain =
                        iommu_get_domain_for_dev(master->dev);
 
-               sid_domain->ops->attach_dev(sid_domain, master->dev);
+               if (domain->type == IOMMU_DOMAIN_IDENTITY ||
+                   domain->type == IOMMU_DOMAIN_BLOCKED)
+                       sid_domain->ops->attach_dev(sid_domain, dev);
        }

Then we can get rid of used_sid and just have used_ssids count the
!0 ssids directly.

I reorganized a bunch of things in the in between patches so we go
more directly to this final outcome.

Thanks,
Jason
