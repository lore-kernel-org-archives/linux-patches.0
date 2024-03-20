Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2934224F2;
	Wed, 20 Mar 2024 12:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710939023; cv=fail; b=hiwWen5E/UnRXO4CQ6MmjB0e5GgsE2b5pj+v45+sZa1RX9kIIT+4W4GmFOAXin1bcnqltW2VHw27B/IP/4R/o65lGwUR3JuKdJAmetGomi/b0PLZ3+e7YevnImfcqqJhWorjVC7WODIfj2zJ5VOf/9I+1leWKw+md23nHZzMW2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710939023; c=relaxed/simple;
	bh=106dHL8NJWGaAzmgo/iJSDUSRtZVxyvI8CLgCgIygNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=flK3jBVFK74TtxPqbOXYDcAqxAX0e17HWkbif4RLmyr+btqDF0bUF+7DWkN235/2GR1esOLCmuzHGhzpBB9cambtdX5S/+IcJjjhFEDsNcJcmVA8EYuMX52Jffy4OsMe3SjVDTSPhlYrH5MEprld03CKXJqS4+ihWFaZuTsHTEM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J3zX7DRB; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J3zX7DRB"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G2l3pQXA6/zrAJKU5CvwxluNq2+V+Zhznbo70suc7vrnuJVZoOY9odZ4cZDYnpLG+J15Pzailv+drRVzmA9r26z2McMDf/IigNiiAfRLEGLVlNutwRL1DoPpB5g+3VfztaN5r3cPm4CIseGFWK6lLv47R8NSPpVgUj9J2ey8uIaN1GlnqaiuhsGo1ABIWNyTEvVLXE73rnmW9wATVce0t3YTT6qjcMDnjN5qQmhJlfyb+Sxi32E2XdRmyvI2xeYmvFuOLc2JgzFg2CXC2wWi/qTMMqVuTRZedjTQEgYObcfUf3Orkjm1FGv0Pt1AEAXuI6TE/p8I+fduyowoWpyeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tR6JiHZP/iD8j3A5PIpiA58dlWlyV9/eXfhu1pEtvPs=;
 b=OZRZb6BRrpl86oa6hJy4KEm5ylE92GAp3Y1mN0Zht7KNncCdlAyK91VMiAFP0W7wxGB1qmYFrhMx4YlrRFFysgsfM+2hScC/96MbKzdhTHrPmvo4dcuJ8O+tktAeXQFgFqstz9RA+dcyNQW5EbHwQfFTmB6i/CobNlg+sYVxHmXjm1XdqbWh9xTmCI23Qqbg4oYbIKRBxWbSALVlP/mGQoeNklSQDYJolj0zA/LoxLnKUjLOa2ambN6WuGdr5KHlhkQQCTSNXvZiJtGV0y0e8EpllF7+HRvSPfotDKHgycx7U0oricnh6s5lkHaLPnGU2sGzr+gaqHGrrMDhxE2wKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tR6JiHZP/iD8j3A5PIpiA58dlWlyV9/eXfhu1pEtvPs=;
 b=J3zX7DRBEiRACGOcX+a6zqOcq79+mTArakRD59hU7sRrmoIDwCEytVQdVMBNDC9kTL3SGrC9g3MjRwKz9UbOS9SXAQUtyLKoRp7vuMhqdjkZTxz9o76j/CU/JGPpZiQAv9ROEXkZKx2k9z8SeJErJuGehqVPf+rPVV+rdIm77SK7Ps+QXXUP2ecNscoSZVsMEJVMGxGGnTlvJfB5yK6cclYMdAHNzNOfsDIckI+Y6ud9H90lZqGl0Tdx7rkOVFaYGdws1ybQXYW4HHLSKRbKf3gK2NQykmMeLaKNR3Z8jT8gTzSQCNP/gNqiOUH027oLidhhborOuTeDSzT2WglPcA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by BY5PR12MB4083.namprd12.prod.outlook.com (2603:10b6:a03:20d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.31; Wed, 20 Mar
 2024 12:50:18 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7386.030; Wed, 20 Mar 2024
 12:50:18 +0000
Date: Wed, 20 Mar 2024 09:50:16 -0300
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
Subject: Re: [PATCH v5 11/27] iommu/arm-smmu-v3: Build the whole CD in
 arm_smmu_make_s1_cd()
Message-ID: <20240320125016.GB1044235@nvidia.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <11-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <CAKHBV26Rr5T-6swERRUyugXqy-=PUEgo9nEga=L4ZYT9hPc32A@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKHBV26Rr5T-6swERRUyugXqy-=PUEgo9nEga=L4ZYT9hPc32A@mail.gmail.com>
X-ClientProxiedBy: SN6PR01CA0002.prod.exchangelabs.com (2603:10b6:805:b6::15)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|BY5PR12MB4083:EE_
X-MS-Office365-Filtering-Correlation-Id: 577b8c43-e63f-4aa5-be88-08dc48dc4bce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wbhPeyMEhKj9ftJMc66qsQMxyndpKDbMpXsN6WPeBhlZCTXN7x2hSnkkc7GSkwjMwIkBb4l0/BFS1UqZyehavrZI+cRXAig5IhlSKSP325d70zXbBfR1kK3N32MCLJ6shxUYB1KyB36o6LgUOZvOCSglleTGs7HcOWqbAoKb6072CJY01i+W3sOChAIlYVeJz/xMiCl4qdgxxNPp/ZXiIYj0iJUbK/R+SxLqd+/5U4mZBOQZjfNU9oYmY1Yg8yOrc0GgOTrGmZ0VNxeQZoU52V4NHeIN6LpJX+eW9U6ozNlhKrBqbB74IV0/eFiELI5YRFEWzjdpWXq8WIBcpFFpwn9OKQCZ/ukoSbvPTbYe4ar9oawGITpAUO6e6sNjDfDPD685sVcXqqHIW+N/GDyV8SNGd5KxNvda+zx5A3b/C+vyYyLViNkJzDdZtyraGpfzjEzbs1ydUCFGRcqJd/6jcsf+1StXTOPDZqI2A4wFgN3FOX9tdeoKhmpZcNLCbgfHf9i9bzZJjvOblbdbzD+dU/5M/a+zX62c4n/+9SMEHWgZ7MizR5qTobvMdpWjjYHDzrrEuVJkWKJ2TkGf85n+7ipHRR0En9FbPo4zRu8Js5CAf2FbcOqRLPlM1+JqW3vxBVnjSC1A85AJfflA916JHHTo/COd+cy5pl+TLkyWExg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T2FrS1mkvqv+69BDdEJksf9aY5N/+R+F+2KW7AG0IhFsm6Lpc2NyPr4bUG4e?=
 =?us-ascii?Q?znAiSGMjevKfe4sboVPrCnwpGUWDoJtZrHEZRMGpCu3Hl0/F2X8n/FBsXSWo?=
 =?us-ascii?Q?VTKwHX8823zAgob1rs+hFZ2Tqgwu4xFXJOG1AflaZUy/oNi1BATxnxLSjdu1?=
 =?us-ascii?Q?TztE1n7mwadD71Fgs9YZJPfERiS9JqR+Xgc2Q1cIt637hGwrXWHFHr6xCxay?=
 =?us-ascii?Q?jsFx13TMiivNkIiBLFxX+IYgw+1ZkMpxrCSasqu9wKyQHVSQm9IRF3GpFS4b?=
 =?us-ascii?Q?5s3NSMeirrHLlwhsS8M07amkBjwRgGU16zgIC0e325BIU57exvi7zX8iKr8u?=
 =?us-ascii?Q?+ys0HwiEkUB+CHi6m0Yt2XF+Dt5/pyILgV3QWnZlbEjApGdxvU5FbRsVLGOO?=
 =?us-ascii?Q?U13oZpThNuAFY9yvcaOgZzxKZvZeKJmp718TTgMuMC/H+iDb9QINcMLEQb91?=
 =?us-ascii?Q?DR70bpW8SNOP8zmSLB4gOY3PyHHFHf6+0B8BXNUP3oOJncDxUk7clBfolKK3?=
 =?us-ascii?Q?TVYPgIDWVYE29C+f4ing7PdNsncXB+UhruaoFXNS+vUod/NCAVtbqV1CRQxq?=
 =?us-ascii?Q?CsgV0E0EYildyBpsCrzfOiASaR6+jvolLG5y7UknKmKqN52zQx2Ewbj5zfv4?=
 =?us-ascii?Q?xnoOMj0YcHK9zN2+RnDR8HeoBhQXYv2Bz7T6MBri9l8BOLpKhLyNcafO7oRO?=
 =?us-ascii?Q?gWF55N0pymXlyf/Rlipd3jKN/t3buNWpKh1l+uLlOV4hxf/2EyL2/zu+2Qu1?=
 =?us-ascii?Q?S+7TcxFOWvNzPTKULjQiFTb62B7tHTcQgpMwKWRHkH0m5OrR+bE3Ov6JBHqC?=
 =?us-ascii?Q?Ct0/etDbHykP61iC6zfwZVXj7srGiNmBtCnApAZFyJAJuvkoWduZkmxJjcpY?=
 =?us-ascii?Q?Q3xWeQj3Aer+Te8Q4/2FpRYC8xKYtkfuBNDot7X5YUtnT43PTaOxzsC+Yc76?=
 =?us-ascii?Q?mfOHhTXUuKLUen5E8f4QW+3DP+xFkFoRUOvVuIqN4KcZlpGkjhdDnE7rcTTB?=
 =?us-ascii?Q?UZQVdTO88LC4fx1G3GyScvYL0IzretiMIZdmrNzkRVBTJaz0op9rkGam8N+3?=
 =?us-ascii?Q?7IQrIMay0MWkmtazNwnN6Iv5jt7gOi9vGetVTW3FY9ycnEF4kbof53luidmR?=
 =?us-ascii?Q?HUpPwf8OFJDaJMO0qveqqgNWTqSFk8A8kkDVvBnCP9EGBvMChYiVaYXsybMN?=
 =?us-ascii?Q?gSRxJFQcPJ54IbEcqR1TtqPGzmS9RggDLD7cMXIesrhtHmEENUG8owTyY9zF?=
 =?us-ascii?Q?p7L+6XiSGgUEmEoawjcJCJ/pBMiUnDHz/klWcbQovmlh7e6KT9YRTJnGjYAE?=
 =?us-ascii?Q?UmG1kpZhj5LPmhWYkWTDGbxY+zSU2x9xkDH4qN/IPShFPxkRVptyQmQMhMGj?=
 =?us-ascii?Q?aHgsMqcsjyj8T+elgO2ygNAtvYBteOeHolJKWXoR2FTQ0JZUXmi5lOHWczyY?=
 =?us-ascii?Q?Z8SlqiVn6OZHbkB+AK3yGeDJfnvd9QgGcnZ7v/w4dLZDZQQi628d24XB4GKb?=
 =?us-ascii?Q?HJU+imRjVq9Q/WCczdK+gIvYhtylAZZ8PTaEVJ+aHct3Tsmen/5gjQyBvXvg?=
 =?us-ascii?Q?5c9Hj2pwFpop3OumK/1M2UtbkOClhY+2fDgqmSlX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 577b8c43-e63f-4aa5-be88-08dc48dc4bce
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 12:50:18.3001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tj7Cm7OgOay9mvrZ6DVoAnFRhUPzcCS9GE4xlQXwN+NScY/WlRn2lTsGlQSOuW5N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4083

On Fri, Mar 15, 2024 at 06:04:19PM +0800, Michael Shavit wrote:
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index 50d17e3ce0a956..dfdd48cf217c4e 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1301,15 +1301,25 @@ void arm_smmu_make_s1_cd(struct arm_smmu_cd *target,
> >                          struct arm_smmu_domain *smmu_domain)
> >  {
> >         struct arm_smmu_ctx_desc *cd = &smmu_domain->cd;
> > +       const struct io_pgtable_cfg *pgtbl_cfg =
> > +               &io_pgtable_ops_to_pgtable(smmu_domain->pgtbl_ops)->cfg;
> > +       typeof(&pgtbl_cfg->arm_lpae_s1_cfg.tcr) tcr =
> > +               &pgtbl_cfg->arm_lpae_s1_cfg.tcr;
> >
> >         memset(target, 0, sizeof(*target));
> >
> >         target->data[0] = cpu_to_le64(
> > -               cd->tcr |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, tcr->tsz) |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_TG0, tcr->tg) |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, tcr->irgn) |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, tcr->orgn) |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_SH0, tcr->sh) |
> > +               CTXDESC_CD_0_TCR_EPD1 |
> >  #ifdef __BIG_ENDIAN
> >                 CTXDESC_CD_0_ENDI |
> >  #endif
> >                 CTXDESC_CD_0_V |
> > +               FIELD_PREP(CTXDESC_CD_0_TCR_IPS, tcr->ips) |
> 
> I guess you're trying to keep these ordered by bit position, in which
> case EPD1 should go after ENDI.

Right, I missed the #defines are not in bit order :\

Thanks,
Jason
