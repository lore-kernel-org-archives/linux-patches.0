Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010014.outbound.protection.outlook.com [40.93.198.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCFD3E315F;
	Wed,  6 May 2026 09:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778058799; cv=fail; b=WfiPitZ8b7wQ8KSfdQisgHAkEvt6Zqn2ForF7RDMpfitlUvC4AhMj9+6T2CxEZdpkqQDJaucDAQRlKiJu0m3bBgUCucANbN8n3m6S2Xk+17+a0Y4bfQT0AT0KD3jwRLL5Wlq7J/uqV6l25HTMOCLvYXr2R+4kv/NihwTGya+FAk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778058799; c=relaxed/simple;
	bh=k6Kqep8/8OIqqbs9xasCWsnPjua+0zkYasu3FIvIG+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NgHtP1FKkMvLL6XCqs7Heh96d70r7/MuRMTSe/TsAvuascy9uQx+Bx55cSI2KbTTuMZMem+L8eet1J9+so0vqVA1cnnRh/Q2jjqkVSi59T5nD4ztHUgimvCB8KPX5OOQMoYoRl2JZRSEUCxIdD92d0/5FQk1bE6mAPxpSNvjmnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=BhuPzNlQ; arc=fail smtp.client-ip=40.93.198.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="BhuPzNlQ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i4eTt0Osfb+HDbc/hZ/8jPX3aHiaDJGbziioqhUH1PTv26d4nHzltRrsIL4EZGDW7mHhHrh0Y8sPmi3Wk+Tagtyhhk9X+bbFX3cxYcJHP0MK9iUh0F/LxyuHBD2iTqGMwE/5b86e+aLFtw9+1OcuSk5D5rngMyD3ZrdYJPPDv3+2SikD496PvAJtRFMZO9YOv+OCeqWM/ayLO67iCy29THDTVlOwVr59m1gWPa4NgpXQgKZYXu1fL0gSHE2RsotEeE3UVBn4Ow5ABtn5IuN84clsSUS2/1PvDeUT4Ee/1ZS/3f4jhzF5HZE/IIc+xZ3bsJZxN/YGc+Nq8i6YPFxV1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iGrYu4B/sa4l/Atbq1ML/D2tEBQ2bfXmPau6/r4eYI4=;
 b=OkhTKC1+0q0qSMLUhVHYeDT81Ij2eOVsUFkB3YabtMxhAILrL0o/Ocn/3+DDunpqh2PzmHtYSrgUHpUznDYFQBy4db/qt1IIbXA84WzdVdhyVVKIt5xpc0aDcK9R9JGiXNHbHXAh0zhXIVbOTX6se1R4FLIshg/qukJwPVaVIMVNd4rZD5k4nfzkeCykJ5nCvyTA0OG++ATFO+s7NukurPJM+ZRdA4oIfR68mo7NgtQIQ6hDRqLJr5+79GoDdVxfVO3XzanIK8P0RFLcSxfrYlH+DdsFIIyAQAnsovEFOFWqsnVd7G8N7Kv88RfLNZ2rZX8j8WzSCcH4aI4D3eKH2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iGrYu4B/sa4l/Atbq1ML/D2tEBQ2bfXmPau6/r4eYI4=;
 b=BhuPzNlQzp9LQbx/TVVN+WLpoo4H3oKgVQXVm0wAkrCXsbssoQurGRyd8WjnQ1leNqk7i+GkURZMGER8nZ6gdllA1bLeAqBHZW90dTN+yn03AWGrlFhz68HZHlBiPNkiAKVqS5r5ad8PU3DSuywXKZJfBSEEM41amTbUzqrpHxsDm9YNlp68tNRMhgHDLmQg1c/SlMUkaefj/P5Gvdhebf+v1SBDnqyw6ox24pcmZoD5Nnby+3DLJHfxXS7OapDqS5GcoTAly50kYiMkyP2vYcl3nZMkV0tR64y3p8uMgzOh4kyUEt/AxgUX5jkNx/cTQ3Ql3wUSkJqq5LsHZJC40g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DM6PR12MB4075.namprd12.prod.outlook.com (2603:10b6:5:21d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 09:13:09 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%5]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 09:13:09 +0000
Date: Wed, 6 May 2026 06:13:06 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Andrew Jones <andrew.jones@oss.qualcomm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Albert Ou <aou@eecs.berkeley.edu>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-riscv@lists.infradead.org,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Tomasz Jeznach <tjeznach@rivosinc.com>,
	Will Deacon <will@kernel.org>,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>, patches@lists.linux.dev
Subject: Re: [PATCH 7/7] iommu/riscv: Add NAPOT range invalidation support
Message-ID: <afsGItRkLibstQpa@nvidia.com>
References: <0-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
 <7-v1-54e7264d71b4+17cc3-iommu_riscv_inv_jgg@nvidia.com>
 <oe75yk2fx2c7wg73xrikppw2gxxe2e6bsvkktowbo64ftldy7p@53gjjzhu6cy5>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <oe75yk2fx2c7wg73xrikppw2gxxe2e6bsvkktowbo64ftldy7p@53gjjzhu6cy5>
X-ClientProxiedBy: ZR0P278CA0091.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:23::6) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DM6PR12MB4075:EE_
X-MS-Office365-Filtering-Correlation-Id: 520a4334-c55f-4089-e4e2-08deab4fb0f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	p14PSjAZHzeaHfPMU5vI3H3h+i1aK996F3UA3t+sWxxVlvhG5Si4x1FmFdhDCRI3aYmLXY03RZdvoRrud5qUOD5B76lD0G+/beYk8XJ2HqCLV3BPUFtd5vIF6WbsHUSEnqsKahZWtdfRcuvbZPheCJNi80LwUiSJg94M7QMMEwLb8TKb5/qUZY+8MoppuzQKJ5xjFJuRJ3QX4DSsJSc9aQSMxhfON8XGljuGdSXUuXxWCM2csmwjfz6WCQp6eCHIbHm7qQvhbGDEoGHasOcCILhX9rejo0mF99xIIrRTkucCO5ypqpt/RnGNzUrgCGb3GfzjRFwAWa/vE86AegMb09/dENey5RRFxzEKEXU9yfUMGQNTv1ZGarZmpiYGGjUlZA+/aAFUEAabBmqPL9kcrsjj1ebKn0XftcwuYq8aeaJGS4rR09DeM9Lr2wg/XYhgzq5/ggf2+rXIu6fcaXqzWfDn9HKxLXsYDsMg8CNPMnFRaZNPU+8lwiWlNq9tKUWiuwip/o4YPV71Not/oF8jle2ZX7mvC33vjvr8GXvNaGBMdRzMKSpDxRveiXyqy4LFIBZMtzj5SriRUyhtvttW+BVoFIKFZ4Vd//i/hHbQ90nRgM/nDSBVBMpwjLsmKhuAMHL5P98MUruwuDckYege/bNNGGQVwHxMSMJNuE5sW/2kIfcxvJS90uLSJTHKf5Oq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?evbnhrAi4gh5CRKXZxg3UsJoBq+ruH+/QGVsOdMF6hdQmE9QCw/ZhHQ3P7VR?=
 =?us-ascii?Q?PCKRgkbQk9gQhUUY+D6slS1XCvS7JF0P5XFNL02vTsm3pRXGSUxqHKRVaxwd?=
 =?us-ascii?Q?+6OocDGXclXptXZSqGKzmKEqvaL7bfnKehT6dH4IfOw6t64A3kZ/23AqeS5d?=
 =?us-ascii?Q?X7dGiUdUZ4dThSEBDjqBGEUeR2KjoMBfM9/pGntTVXUtYuqiVcHXUqx9pFMA?=
 =?us-ascii?Q?pYPcZf+Zf+Tg6guCuZV8XCnjh4NnyeUoMDYGwNRahl8hxEEYQXgPnoWDAO5+?=
 =?us-ascii?Q?yw15GsQUpt7pf5Ncha2XekgiT2hz4izbMoMLvY+IFPLnNh7UHxqf7aIZCfR4?=
 =?us-ascii?Q?TqcjU2thrLqkZXq+I/KJ3eMtW7JNunTFM6AXn33I5caDWeaSi0l+cR0aiceR?=
 =?us-ascii?Q?JuhoT6qMt7NYdLnpWJUbmHd0lZhnYYp5YEjM0EtMczGGzBcUBfpDLz6O6YDb?=
 =?us-ascii?Q?jcF6PgYC/gqn1lBGLSGLM0RB1Kfq1i3s1dAvKyI+a2/PTsWffgvlOGJ1rLgc?=
 =?us-ascii?Q?m7hKdexTCXd0ZRwRzg/4j+JD9wqm9KzuAiqYcV+9R3qQ3rqZ0Yd3klzloOu9?=
 =?us-ascii?Q?1tubxuKQ7YtAyRrmXjUPGI8jBOa4FYMacJkPsVrZ56YdElegfV8T/PRmYoyM?=
 =?us-ascii?Q?VMt+N2Q/dz45hCtwpX8BqlixvBPShrz9fTJMcSmVsPUHAzqWTmQsYHFb6rGA?=
 =?us-ascii?Q?PisreEgK9sVr5jIM2fInwKlXLOtETZyn9W6Z9u9EUwpEqcyYkQTsuypqA2Tl?=
 =?us-ascii?Q?QihkGxMG30cuxt4cqfy805z6O90jlXcamgK6DDZ/Zkq6LjhAO9n1m/9Ym00d?=
 =?us-ascii?Q?6aUFBp05j5xYh+FzvYoyGKW4y/iaX/QlGQaqdGDcc45zPZ5yQoU0uClzDbxP?=
 =?us-ascii?Q?TkJZdcL1OZII+3qEirhVWvMSAix5k614nJ/dAb3dtrqOFVJQ/3c7o1oGSR/v?=
 =?us-ascii?Q?iZMDsMaugcuUq8mOWTSk+W1sY/Aj920Iltg12ri8+pWrUD4g2aL1K8i6QZ//?=
 =?us-ascii?Q?d833EgAtV9HRpk1R/UYLgwPCbuXXM3W3JPnrKSVlRpo/64SBTPEfbzvbYg4r?=
 =?us-ascii?Q?m9hMwDOCjFaeV0qs/KeswyjUXUyKnNKyzzy79TIR8vV17XAEYW9Ddx9/CiY0?=
 =?us-ascii?Q?28HEADR5gGkRiBiSiCMLqoaIKMpepYd8pmeEh4aR9/5WIRxcgb0oogFcZVM+?=
 =?us-ascii?Q?vBjmi4PpJrXvxf1aWSMDJMVlNx6lr69GM+rNMH4Rjw1/KEPYVys4FB6xEso1?=
 =?us-ascii?Q?JilWtdaxDt7FdTohGiJS/GU7wiGyARwyACC9EWIgNLXhs2dZ/owTAqVJbBV1?=
 =?us-ascii?Q?tM940EhNnIJ23oTtT+ggDEtNV94eOxO6wuSnr/zcMIC86+4zisJ+p5EI3HUa?=
 =?us-ascii?Q?FVwYO2RaYoYqUzi+HnfIlNddRSJeDFwSNXPeVyTOd5qPX7Z5NttSdyQaHPvy?=
 =?us-ascii?Q?UmYc+qiCiEoFbtye22ulqqIuYyPBdIIw1TsUVVW2M0cPc6bDK/ilGHOOIq0f?=
 =?us-ascii?Q?b+UuYi63M2QxfmoSkQIPS1RXaIMeSM9zXxDTXs4/jLTJDK/qsmnMHEOqYzRl?=
 =?us-ascii?Q?2iX0eYQXK7VaSOnaUI68jB8bTzyc/4i3QUDNtcmZhCZLmj4K24WJv2K7GmK6?=
 =?us-ascii?Q?dydgBtDmPEMaN58iA9VDCnd49lT3j4+JEtq4gGXSBGFFtJwBqaS9XxzwiXeq?=
 =?us-ascii?Q?2WizrRA84icdBevsC/q4OQgYBuBLq0zqmVSB2rc/vJpx1t6p?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 520a4334-c55f-4089-e4e2-08deab4fb0f0
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 09:13:09.4657
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sUZM/guim4oSDPOHTF2fLHgpGEobWhFpNhlhC+yduz87FPtjTkrmN7XSN1Wy9Bb/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4075

On Tue, May 05, 2026 at 05:47:10PM -0500, Andrew Jones wrote:
> On Fri, Apr 10, 2026 at 12:57:08PM -0300, Jason Gunthorpe wrote:
> > Use the RISC-V IOMMU Address Range Invalidation extension
> > (capabilities.S, spec section 9.3) to invalidate an IOVA range with
> > a single IOTINVAL.VMA command using NAPOT-encoded addressing.
> > 
> > One iommu_iotlb_gather maps to one NAPOT invalidation command. The
> > smallest power-of-two aligned range covering the gather is used since
> > over-invalidation is always safe.
> > 
> > S and NL seem to be orthogonal in the spec, so if NL is not
> > supported then global invalidation is probably always going to happen
> > as wiping a large range without a table change is not common.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/riscv/iommu-bits.h | 17 +++++++++++++
> >  drivers/iommu/riscv/iommu.c      | 43 +++++++++++++++++++++++++++-----
> >  2 files changed, 54 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/iommu/riscv/iommu-bits.h b/drivers/iommu/riscv/iommu-bits.h
> > index f01b49ac815586..32b3ad3ac9ae59 100644
> > --- a/drivers/iommu/riscv/iommu-bits.h
> > +++ b/drivers/iommu/riscv/iommu-bits.h
> > @@ -64,6 +64,7 @@
> >  #define RISCV_IOMMU_CAPABILITIES_PD17		BIT_ULL(39)
> >  #define RISCV_IOMMU_CAPABILITIES_PD20		BIT_ULL(40)
> >  #define RISCV_IOMMU_CAPABILITIES_NL		BIT_ULL(42)
> > +#define RISCV_IOMMU_CAPABILITIES_S		BIT_ULL(43)
> >  
> >  /**
> >   * enum riscv_iommu_igs_settings - Interrupt Generation Support Settings
> > @@ -475,6 +476,7 @@ struct riscv_iommu_command {
> >  #define RISCV_IOMMU_CMD_IOTINVAL_GV		BIT_ULL(33)
> >  #define RISCV_IOMMU_CMD_IOTINVAL_GSCID		GENMASK_ULL(59, 44)
> >  #define RISCV_IOMMU_CMD_IOTINVAL_NL		BIT_ULL(34)
> > +#define RISCV_IOMMU_CMD_IOTINVAL_S		BIT_ULL(9)
> 
> We should add a comment here that this is actually bit 73, i.e.
> 
> #define RISCV_IOMMU_CMD_IOTINVAL_S           BIT_ULL(9)	/* bit 73 (dword1 bit 9) */
> 
> because...

!! That's a big mistake, the common thing in other drivers is
something like CMD0 CMD1 to designate the word.

> > +static inline void riscv_iommu_cmd_inval_set_napot(
> > +	struct riscv_iommu_command *cmd, u64 addr, unsigned int sz_lg2)
> > +{
> > +	u64 pfn = addr >> 12;
> > +
> > +	pfn |= BIT_U64(sz_lg2 - 13) - 1;
> > +	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn);
> > +	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV | RISCV_IOMMU_CMD_IOTINVAL_S;
> 
> ...here we're setting the wrong dword. This should be
> 
> 	cmd->dword1 = FIELD_PREP(RISCV_IOMMU_CMD_IOTINVAL_ADDR, pfn) |
> 		      RISCV_IOMMU_CMD_IOTINVAL_S;
> 	cmd->dword0 |= RISCV_IOMMU_CMD_IOTINVAL_AV;

Right, I will fix it up

Thanks,
Jason
