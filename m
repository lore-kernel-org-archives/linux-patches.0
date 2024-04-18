Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2052.outbound.protection.outlook.com [40.107.96.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42501165FA9;
	Thu, 18 Apr 2024 14:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713450514; cv=fail; b=fhdDZH8+yDtkVbNWLEDJbsz9/rG4gn91fUshAerTeJgw/dfMhMddHfrWubwPWi1IixfgX7Z4D+yHWofOrpHYdPegkIA9tAfrTpx7N+0Mij3YurcgGdMZSiPBnlaf4Q1YB6P47QmAK07UoH9SEdJWYpDYoX3TUS6abHM/1zZRM7E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713450514; c=relaxed/simple;
	bh=QDmhH+oSyDvTGTJCQRWfDJWqFK1iBFw7Gmz2TaKKLbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=XKFygq6huIQ4X4CiXpRyowMgKcpR6uFIFZYOq5oylUGoVQ5GvSRK2q8bZCIrEARBaSFQxfMV2mRzraEn+yrSFuQn6oY6UXlvLkoOQ0Zn2ADIRpb3MKc/Mu0i41kBQ2l2354pyeAno4YMRkrLRQ9GWZj6vTgBx9TJz5YcxLQ4xf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ahTEtrC8; arc=fail smtp.client-ip=40.107.96.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ahTEtrC8"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D40KSNC+ZZqRsZIpX+vd+x0z/gveKMXmGKCa7EK4D3Je0vYSbbzTKuGp08aK9CQWtOQPXydzO/I/ZPKJDhDS7gF98tmzbwMSG3fGZ4vspvIIffzqJFpNLIaAjHMZo/FsyAIx1KAxTinKJ9hV4aKT7Q4mTLvwpEueAxz4+gUaWYVIC/ptYxkJ/tx6g5TehlZ3LdXftpuYlUtTKVag3M7HTdsY9tIaghXyBs64tE+0x0g2ecaatV/5mEfeNrnuhvYDplEYTYtCXwLxwQOjTmx4g3gQauLSppgQbtBIqgc50YNTtC/1x50aR6WuB6tclrTg7JJ3+dm2kkzAddtVsE+1DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTOesFcMPCp+Yt803ABSueWVCCc/mk1duZ4b3bvYSiQ=;
 b=E0D4YOtKBZ6RmabV2B20PuyMu/FSYUyy2LFeNRfFyXbjJlQgV3JtAzHWkaKVtoyv7nDw13BvJTkcZrLH6Q2jXvvJSk1shRNI8pF+bKln+X/res4pdlvvVcY6jhqimpoBD/rCiP2IuDgQmHh/5mSCSHELZcsWsGrPBJeyozuIiXe7WtDQkKDr3n0jY+xrM8ZFkHTfk7SJWESS3tzKWMu5wvUdLDNJxgw76tyx1PKzFtTmPkgj/hR7URiD9vqAT3r+Dyib+4tpluv5uBykQbKHVZ5dM9OtP4e8Is3a2BowW7SNwOBZ4qE+h2V36ja0iWwPRxzpFKmrcI8DRLlnSFnd8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTOesFcMPCp+Yt803ABSueWVCCc/mk1duZ4b3bvYSiQ=;
 b=ahTEtrC8af/FMWZ3Z+IFDc/nygw+PLlQiXJ//RMKcwaFqpxGMbGnGOYYQNVDP01frci7EAN5/iYshJ75D0Nfq/t7VPE5k1EOYOTzLpSgGKk0ym9IXU9Zfz68uOGfTlPqmSOP19Id7i9inwEYqMMSg6fjAfhtulig+V6+dapTXwgVKxC2Aw5oip7QfxegcAHhXfpelcJp61h6t9sgFkiaTEYqJR92jtAk7pqrpSVY0T8MF3Kv2IjyN0roTpAHy7j4dP/HkQ8k8dkK+X9huaxA8ooLX6NvQnVfczJ7FgMh3HVsEQKQzyG4FMJBKk2SdBXhT2fDisa1gU6fXhMbLIexBg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY8PR12MB8242.namprd12.prod.outlook.com (2603:10b6:930:77::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.37; Thu, 18 Apr
 2024 14:28:28 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Thu, 18 Apr 2024
 14:28:28 +0000
Date: Thu, 18 Apr 2024 11:28:27 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Michael Shavit <mshavit@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v7 7/9] iommu/arm-smmu-v3: Move the CD generation for SVA
 into a function
Message-ID: <20240418142827.GB3050601@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <7-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV24s1j_AeAEHxYnGdMAERs21Z7iBMwG=ihaZmgNKsrA4SQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV24s1j_AeAEHxYnGdMAERs21Z7iBMwG=ihaZmgNKsrA4SQ@mail.gmail.com>
X-ClientProxiedBy: SA1PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::6) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY8PR12MB8242:EE_
X-MS-Office365-Filtering-Correlation-Id: 3147d3d1-63f2-49a5-332c-08dc5fb3d08f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lxiiHd2A4opopSqXdi0d1cOikZBRDqPrRtdLOJNzIbsZSm4WBxVl4FVhmw/TiiYEZK5I0CX5N1yD1TLVdW8GoORUwl3D/fjLVL7EPXXmn0yOFFgZ2TbQc2nnXw1GsG7AWzJxZ8ftThs/W4/9agg1+dlXtkz34qdsKWebxTCLolVwTtP3pvCWpLI92+9nA+8nEjdg3nbluheh+au20OpDkMdoM0NP++oxoAWfeL9G494dQW2g4kqPn1RnMuyWGnn7b7xReFH2S7Yl7gnuMoav1xlEr/8WhANrCUSdEF2AWPWx0nZAgxogYoHyGa9QzoeKivm6Jzn7pAFJBOHg63iFxABrVCRIBbSAhRwn8y10wpPoknRuSVRJLPUfJIkmBFcuTL+URnExrdXte9VZ8YNCfEFhPGFKA8G5mdUs5Pc40+rixj+MkHmVotDra8K6c1b/v4u9IwaA6cnfbgEDa9aOTupUmyjUe4AJ/eUkj/vrPcSDx9mFD57vpbVODZyqzo4FMPFFupVSZHEiGhIsZONlZbbnuqG/ggi6tKLzBqXV8WlF2eirfZKgZuWdJmGB/Bbul8BKYFvjvViAwPgCBZjrggLAmme44act3pvtdFRJ9e9esCPSYhSEE3WZrFL3FV/r9ouzsT2EEgcKRk5CEybquyvojzm2mx5AOmZkXmQHt/4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nFXYuAX2YYULN9aXp40ssBPOC/bo6F9fouS/j0hQC5edtBJmZP//N5LPs5jV?=
 =?us-ascii?Q?gsDsDOvSOI2wyLStz1JoxK81VU8hOTRbgVB5GHhqOIBmbF1VPU4AcTy04S1i?=
 =?us-ascii?Q?GsxKrN50U6G/9PnVzKTP/Bm3o0dp7UzQ7DCbPwv8sjgCQW2g7sH6YEfqrCGE?=
 =?us-ascii?Q?KYlMuDtd+6FxYIDtjHV9yaxs4CeiQxlEgHzvpY+FIN/RxIdQhETg/PTXwLUQ?=
 =?us-ascii?Q?bFTVZS3T8JiYQNrBZQ+1YMnqaElUbzBWGk+xY4dKmfUTJkzdDbQuY6McTvty?=
 =?us-ascii?Q?IpeYKPJuYlHeCPhslJK3H2+3vGpLxGu8wNojUyL9JSOke0OcUSo2GvPIlLkc?=
 =?us-ascii?Q?RunnobhpzOXfM+yU+v3t5ecS59CiIMBC/DY0gzIjluWVy/QWwi+FdFa5Owqo?=
 =?us-ascii?Q?Cg7+3LwC1+quqZkat+NiGLbdF9z9by12AMp4jy0XRNPiW3iNGHFHa8FKWC+I?=
 =?us-ascii?Q?1nK1ahVT2actIvY5vqAIofc5jk36Y44ErNP/kYVMvE2iZ8U53L6KjKEGPlio?=
 =?us-ascii?Q?VYjobyDgB3I9JsJ3rQNiNsAgiBrFTsFRwTKYzJWOvFmDcKAbdi+/nuTCwh3g?=
 =?us-ascii?Q?xdqaRc8Vfsody//OfJyu4hQ2PLK/e+63FdeFCmMT8gfOtFqmGLZQfATTMpYa?=
 =?us-ascii?Q?B2LAD6EaIcXSozaTqKIk0IZlT3SiCr9UBxmbaQKH9lN0V4z0aDeZLAzio9V6?=
 =?us-ascii?Q?ZpkVd3nNlAj0zK7sWFVXrTmWV+Y6Zo/TZmVUJEXWSOv9ADR8YTkWPlrg09ig?=
 =?us-ascii?Q?j2B8WYhxnrjtN/Zxjnmnw0euPhLY8qnaOy7A6PpqvcsuYC80UxOZT35qFoWc?=
 =?us-ascii?Q?rCkjEv64+vvgUuIPaM6+ZKNbeq0HTSyS+HprZa0N2pDcPLumu3HGhOtx0Tvy?=
 =?us-ascii?Q?xJcoSKj8raq51qQkY4OmjgyaGMtDiCs21l4Apdoa9TkEUT3eP76CMfMIAMdu?=
 =?us-ascii?Q?UN7UGnYFXWy1LWf8S75XspBpjbe8fuQt8UvcG8Oo5SX+MsVs0XH/EbQPxsS9?=
 =?us-ascii?Q?yn08eSDHjpHiSKirJv7keJDSturheSmjT9ccMzmIYr08Ebkgfdj6DRj1eTca?=
 =?us-ascii?Q?N7j42FLl6sQLevroFRLWcQY9TtFMxWEvFVd+2VIHSGMe8OzMd9/j8SQVljJ1?=
 =?us-ascii?Q?VicaBQPngLyVi7+WiaUEhSpIh+hKFrs3UYUZ1xtNAdYgcK31WkNxncmxjN9M?=
 =?us-ascii?Q?F6kjsaRZGYlvh8/6gsvL4SUtO8WQUEdrhJQpwv50gX+pQfbZPkLufqsV1NJR?=
 =?us-ascii?Q?TRdm1g45SXaRZ1NjzjOmYLlvRr6IONZU8LsQoDM4GjY7uYDzWcjYPBCpBHqg?=
 =?us-ascii?Q?IeQhxPzwV7WMLcERmeQmeGVOd7oIKSHpAZVUs9JDqwEckR88eMofeJS8W889?=
 =?us-ascii?Q?NvAJURwkIQHKS2Wx2ZoEo0p9XnXnXTZhOLnjVumaf3CJ7WPS43F6aE988Zby?=
 =?us-ascii?Q?3YhC9KPl9YcLs1M6IGTA8xHk6Gpai/fPKHF6zXghvWV4L/ckxTCPu41ru+9C?=
 =?us-ascii?Q?PNt2knggviJfWXSHkQVTxLZNM2fUshMEddpEFj5dJQkU9yG8U1Iw6n+GM1rD?=
 =?us-ascii?Q?LQvR88Belnq3rlD26UY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3147d3d1-63f2-49a5-332c-08dc5fb3d08f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2024 14:28:28.4305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NnxRFtVoWaHA4YyXqugP3B7OYnw6zejkDtHcaxXCI8PBnmgE3deCfSyFmpWIMOD3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8242

On Thu, Apr 18, 2024 at 12:40:03PM +0800, Michael Shavit wrote:

> > +static void arm_smmu_make_sva_cd(struct arm_smmu_cd *target,
> > +                                struct arm_smmu_master *master,
> > +                                struct mm_struct *mm, u16 asid)
> > +{
> > +       u64 par;
> > +
> > +       memset(target, 0, sizeof(*target));
> > +
> > +       par = cpuid_feature_extract_unsigned_field(
> > +               read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1),
> > +               ID_AA64MMFR0_EL1_PARANGE_SHIFT);
> > +
> > +       target->data[0] = cpu_to_le64(
> > +               CTXDESC_CD_0_TCR_EPD1 |
> > +#ifdef __BIG_ENDIAN
> > +               CTXDESC_CD_0_ENDI |
> > +#endif
> > +               CTXDESC_CD_0_V |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_IPS, par) |
> > +               CTXDESC_CD_0_AA64 |
> > +               (master->stall_enabled ? CTXDESC_CD_0_S : 0) |
> > +               CTXDESC_CD_0_R |
> > +               CTXDESC_CD_0_A |
> > +               CTXDESC_CD_0_ASET |
> > +               FIELD_PREP(CTXDESC_CD_0_ASID, asid));
> > +
> > +       /*
> > +        * If no MM is passed then this creates a SVA entry that faults
> > +        * everything. arm_smmu_write_cd_entry() can hitlessly go between these
> > +        * two entries types since TTB0 is ignored by HW when EPD0 is set.
> > +        */
> > +       if (mm) {
> > +               target->data[0] |= cpu_to_le64(
> > +                       FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ,
> > +                                  64ULL - vabits_actual) |
> > +                       FIELD_PREP(CTXDESC_CD_0_TCR_TG0, page_size_to_cd()) |
> > +                       FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0,
> > +                                  ARM_LPAE_TCR_RGN_WBWA) |
> > +                       FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0,
> > +                                  ARM_LPAE_TCR_RGN_WBWA) |
> > +                       FIELD_PREP(CTXDESC_CD_0_TCR_SH0, ARM_LPAE_TCR_SH_IS));
> > +
> > +               target->data[1] = cpu_to_le64(virt_to_phys(mm->pgd) &
> > +                                             CTXDESC_CD_1_TTB0_MASK);
> > +       } else {
> > +               target->data[0] |= cpu_to_le64(CTXDESC_CD_0_TCR_EPD0);
> > +
> > +               /*
> > +                * Disable stall and immediately generate an abort if stall
> > +                * disable is permitted. This speeds up cleanup for an unclean
> > +                * exit if the device is still doing a lot of DMA.
> > +                */
> > +               if (master->stall_enabled &&
> > +                   !(master->smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
> > +                       target->data[0] &=
> > +                               cpu_to_le64(~(CTXDESC_CD_0_S | CTXDESC_CD_0_R));
> 
> 
> This condition looks slightly different from the original one. Does
> this imply a change in behaviour that should be noted in the commit
> message?

You mean because stall_enable is checked? This means the R bit will
not be cleared for non-stalling devices.

Yeah, that probably shouldn't be changed in this patch, I'll adjust it.

But I think the original commit is slightly off as the PCI modes
shouldn't be changing behavior. Issuing a non-translated MemRd/Wr to
non-present IOVA should always abort and always log an event
regardless of what state the mm is in. Devices need to ensure that
their HW only issues ATS for SVA PASIDs.

Thanks,
Jason
