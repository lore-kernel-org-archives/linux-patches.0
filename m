Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2048.outbound.protection.outlook.com [40.107.236.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4D2339AB;
	Tue,  4 Jun 2024 18:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717525719; cv=fail; b=RyXcufToLDF9yTOk3CMDJnfBvAhUnsRYicvhI/CSYaBdWJ8fnT7RC94vJRNzFVIHZwnwMn4c4Np05CUK4EvFbu55Xb9dxdzIqGRo7WRUNKT3aXuy7AHoKd2MofMHcFE1DMD36ErrU4JvtPfAbNWqlNTdC4/5GyjfAtofmmqoi54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717525719; c=relaxed/simple;
	bh=nmDp1GpF34e/OQnLF8pi6+vPFPnOGHzn141TyDPQMNY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ND3N7/FLBIytkMeyfTQgWubf4nUpOoYrKDoEFoICrz9R3xfSuUNnhQa+OsaU3W0X8q0twPoekBOIoqNNn6vPSvfiiyT/QDFkIhqwIEOC3pzJvnuWIW85RbGphxUIg0wLEuruqQ2P/gcUOBMfEUpbTKTvPefINwF+tgfCDVhxK40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NaBdEg41; arc=fail smtp.client-ip=40.107.236.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NaBdEg41"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVIpaGGOCiCW9MsZHQTyJy0da2VQR2UJm82vItmEmfUMX5GIrp3RiIUruYuELCr9xaBndIUvZa7Iy/8A3p7oCHOM218FxXSUPDdJc6inf0al/7bGct1caw1Skox6WH2wXlnYKp0anD2Q72MaEj5PxjrnzWxdj5b3OhHGyps6wR/uFrsp/vkOIk9ZUlFHxBw5hNWjEAJhjREd+fYdw6JT8AnO9XAgo0/y/i/ze2hWf6TNPTKg4aUQkfRpYET5Guk/hxFarXxUD/fyk3MVEsTZss6wFwyMQaQDwNt6zqOgOIzYfsfTpEff660rcjifcGm8ZRX9OmDSUtcD/B5DwuOK+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3vyJ/VDs7m31D7YhudAq497uqi+AfVO/BvbbnuJUPw4=;
 b=cPjJmrF0in8BdoDxyg0gIK/d1/6KG7MkLvOCp5Qk6GSnujEk6V02H7yproFvDm6skl7WOfnf9SB/iSR4GiMCgTq6aR+g2dwgThxY3aHDQwiXjOv6MlmEoXBikCdvRqd6U+bMF8iMiODlS4Khukk0d5pE9mLoWrz7ZQSmZ8Sl72BNTWu8KSRqB2asHBmu+WimKQCdeC9NfLldbMnJ1dd0xWnCwD6VVL9xxz2AL0w63AvL+Qf7kaba1yRZ9zC+ywczfKuPBdFF4sIkRca3/40qWUwzd7XRe2jKQWqdxygSjpsQcQL0FygQtiIB5XZyR4Qz5oKLY+7HjgPhGXMcgJIZOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3vyJ/VDs7m31D7YhudAq497uqi+AfVO/BvbbnuJUPw4=;
 b=NaBdEg41raMZ1goj7NHZ3dr9gY3v6l3elknlyqDm8UxHujr/mB/UKEQqLs9izz5fdVHDsMhGywEz8ItZljrZxPh72C4arckSoFN5R1QDPeUmNspvRTUBZ3PzSPLEfzUAD8iDUa0TviW2tIDX+qBS1w9dgMh6eydvSokY9FwnJ61J7WvHrN/gyEB1iO+vzUIUtGsxIvqpfAA4FBdBBUQFAUwwvG7E7iSwxcfdvvXIXTUAb+6jcgz645o+3RVWX+4PlPGs3p60aTuBgPs/Z9jCcH5S9b0YC25PLHHNZdsFpR+O15Cp/uW2xtfQYRyR0DuYQnt1FcV69RpahqGMsfvJFQ==
Received: from BN8PR15CA0012.namprd15.prod.outlook.com (2603:10b6:408:c0::25)
 by PH7PR12MB5654.namprd12.prod.outlook.com (2603:10b6:510:137::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Tue, 4 Jun
 2024 18:28:34 +0000
Received: from BN3PEPF0000B069.namprd21.prod.outlook.com
 (2603:10b6:408:c0:cafe::b1) by BN8PR15CA0012.outlook.office365.com
 (2603:10b6:408:c0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31 via Frontend
 Transport; Tue, 4 Jun 2024 18:28:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN3PEPF0000B069.mail.protection.outlook.com (10.167.243.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7677.0 via Frontend Transport; Tue, 4 Jun 2024 18:28:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 11:28:08 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 4 Jun 2024
 11:28:07 -0700
Received: from Asurada-Nvidia (10.127.8.11) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 4 Jun 2024 11:28:07 -0700
Date: Tue, 4 Jun 2024 11:28:05 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>,
	<linux-arm-kernel@lists.infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Mostafa Saleh
	<smostafa@google.com>
Subject: Re: [PATCH 1/7] iommu/arm-smmu-v3: Split struct
 arm_smmu_strtab_cfg.strtab
Message-ID: <Zl9ctWSM6m3gkH5T@Asurada-Nvidia>
References: <0-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <1-v1-1b720dce51d1+4f44-smmuv3_tidy_jgg@nvidia.com>
 <Zl7RFCZhAbI/DzwC@Asurada-Nvidia>
 <20240604125955.GH19897@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240604125955.GH19897@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B069:EE_|PH7PR12MB5654:EE_
X-MS-Office365-Filtering-Correlation-Id: 3835a1bf-d283-4a2b-ffae-08dc84c42485
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+4PWRLtRoiupg/nbM8o4LGsSsGkCI/r4E4Q/Z1VqPSKRRd//cBCa/kOAkx8X?=
 =?us-ascii?Q?00hsJRywZAOtENrf5R1nf1HBSSvec7GEKqynZg5b/gZlY99jS/RcFHWEUHKE?=
 =?us-ascii?Q?KVqvZe3M3Vop8kouyT/jN2PV3VRDixof0+YFGkfIBVMyj63TXJeRE0df+M1P?=
 =?us-ascii?Q?BVhWIGKy56AvJH+CUWVBWlAI6p5c5/pFWv8nM/t1jQ457K6NqPJP0/QpNrZw?=
 =?us-ascii?Q?DQ0ws5/cs1Xcj5BrMxK1MeJy/a8dwNJVm/i4kBQ/Q2OLmcnwwHSGmEGrUBDt?=
 =?us-ascii?Q?PoMDWY/Cqrcbcu8QoKaZi0Mt1XcSZ5CM2jZs8Y7cElmXcwzu+k4JhmD0+yLs?=
 =?us-ascii?Q?J4J85cGnhAc7oBql7qDNtzaTWC5ohBkSrnUakkyhAT54Jy2A/vOmNIVts9Yh?=
 =?us-ascii?Q?2aD8sIz01CM3ymNHMI8XzdRLdqYnSxauk9zHXutzurUwOYUfozoXt3CjQtaF?=
 =?us-ascii?Q?U32c54ZmsrfxtKwxZn0l7H3mEF4EJtkrHAoZKWt5NRrmEoTYcmd1F43xE11G?=
 =?us-ascii?Q?f4oLYhq/lwLJ5t7MUZtsKvA1HuiTDMGpugt0g5s0nNZBDeAFLupBph+R3gH4?=
 =?us-ascii?Q?9D5Lt2F3POjiEu8dHZ7g1AzMWwIkh7bbJWl/BNP3H8vBnFy7Izk4+Hl3Ju7Y?=
 =?us-ascii?Q?dqGfHjcVXwTiQJAgQjBzsqNc9lRrBpht29e1AxuRYFiz5uf4Z/1AOdWC6RmB?=
 =?us-ascii?Q?fwDg2USlyWXj+t0sWso4I0Fn6OyF5gl79e8lM6snIzs4U/z6rhBIY6yEngVH?=
 =?us-ascii?Q?UGUYprFRfWnJ9gbHtevRnSjbdL/SKDz1qG5pm5k1GZZvdUQX9QB16YEsf9zO?=
 =?us-ascii?Q?67gFC1lU4p1iu3kLoLuJTieFBjsvmW/xMO6cK7xZtPeUGSWSwpC9yuVIavuB?=
 =?us-ascii?Q?QKlOzV3xpzFxU80sHEUqBlMCqaXg6JX36TNtAS2Gg8E0/1dxrmiYj2rZ+2Q1?=
 =?us-ascii?Q?zoDVZANSdy1QwzJJceVhPxy40v1A1J0990BZeQ7m2XKj/pj2dAHugxoMiUZd?=
 =?us-ascii?Q?HAargIjSBUJbEJcMj5b5rRI1yrq1ftWXh+1YERXVFDQqEwj33WBiWyghtGy+?=
 =?us-ascii?Q?u46eLReW6Nuii3YLoYBwPU2Q/HJMfFLRCD0qXegpZ9eYxIKXSzhHRvDBbbLq?=
 =?us-ascii?Q?75fFjoZiL3cXWxy5PaajNkEUibaQuKxLrCpxUTAMT37Io0eUOnuYmf6CcSRC?=
 =?us-ascii?Q?kCuHFpjA915GZXYx4cih7T1Y81r0NFnTM7bYUN4ahHgu7MiP1L0jadGDkB4y?=
 =?us-ascii?Q?uOVUhmWeGTbHl3hQqOPZJNBBaTV7xPmC5pNAJAAMPV6zEOat3Cm6mtWSOxbm?=
 =?us-ascii?Q?cviPPIXXT6gG1oV71sE66TfxC9pKRH9TjwcghERNK+ZZOvyeCq8i/5IbsZzV?=
 =?us-ascii?Q?l0DpUKVJN9B5x7Uipsz30sS2famx?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 18:28:33.8954
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3835a1bf-d283-4a2b-ffae-08dc84c42485
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B069.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5654

On Tue, Jun 04, 2024 at 09:59:55AM -0300, Jason Gunthorpe wrote:
> On Tue, Jun 04, 2024 at 01:32:20AM -0700, Nicolin Chen wrote:
> > On Mon, Jun 03, 2024 at 07:31:27PM -0300, Jason Gunthorpe wrote:
> > 
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > > index 1242a086c9f948..4769780259affc 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
> > > @@ -612,7 +610,10 @@ struct arm_smmu_s2_cfg {
> > >  };
> > >  
> > >  struct arm_smmu_strtab_cfg {
> > > -	__le64				*strtab;
> > > +	union {
> > > +		struct arm_smmu_ste *linear;
> > > +		__le64 *l1_desc;
> > > +	} strtab;
> > >  	dma_addr_t			strtab_dma;
> > >  	struct arm_smmu_strtab_l1_desc	*l1_desc;
> > >  	unsigned int			num_l1_ents;
> > 
> > It looks like we have two "l1_desc" ptrs now in the same struct:
> > 	strtab.l1_desc	// raw level-1 descriptor memory
> > 	l1_desc		// SW array to store level-2 descriptor memory
> > 
> > And it gets a bit more confusing that they even use the same error
> > prints in arm_smmu_init_strtab_2lvl()...
> 
> Yeah, I noticed that too, but failed to come with better names.. The
> CD has the same issue
> 
> strtab.l1_desc is a pointer to the data structure that the HW fetches
> that is the first level of a 2 level strtab, it stores an encoded
> dma_addr_t.
> 
> cfg.l1_desc is an array of CPU information for each HW L1 entry,
> eventually just being the CPU pointer to the L2 STE table.
> 
> So they are both the l1 array, just one is a CPU pointer and one is a
> HW/DMA pointer.
> 
> Let's call strtab.l1_desc --> strtab.l1_table ?

Yea. This seems to be good.

> > The "struct arm_smmu_strtab_l1_desc" seems to be only used at one
> > place in arm_smmu_init_l2_strtab(). So, how about:
> 
> I didn't do it but, it would make some of the maths more obvious 
> if we encoded the table structure in the types:
> 
> struct arm_smmu_strtab_l2_stes {
> 	struct arm_smmu_ste l2[256];
> };

I personally prefer this one, though why 256?

I was also thinking of an alternative by separating linear/2lvl:

struct arm_smmu_ste {
	__le64 data[8];
};

struct arm_smmu_strtab_linear {
	struct arm_smmu_ste *ste;
	dma_addr_t ste_dma;
};

struct arm_smmu_strtab_l1_desc { // so as to drop TRTAB_L1_DESC_DWORDS
	__le64 data;
};

struct arm_smmu_strtab_l2_stes {
	struct arm_smmu_ste *ste;
};

struct arm_smmu_strtab_l1 {
	struct arm_smmu_strtab_l1_desc *l1;
	dma_addr_t l1_dma;
	struct arm_smmu_strtab_l2_stes *l2;
};

struct arm_smmu_device {
	...
	union {
		struct arm_smmu_strtab_linear linear;
		struct arm_smmu_strtab_l1 l1;
	} strtab;
	...
};

Only arm_smmu_device_reset() really needs strtab_base/_cfg values
that we could compute them over there, given that there are quite
amount of smmu->features checking already?

Thanks
Nicolin
