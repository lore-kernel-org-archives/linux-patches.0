Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2050.outbound.protection.outlook.com [40.107.223.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A95101CA;
	Fri, 23 Feb 2024 18:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708714446; cv=fail; b=LjzbE+sgSisCm9Xyxa0rhSOCBSfW5JaO+fynCRMqT5GpfEKMrfVg7Jh73bacl8ct7+JL1QzaC7EcWTyc5pJv6iyY3Xrgz3ovXbpmIu1YJaN2Ww1GXfp3NO/WsYGR2feXJrGkFDZdtziGRfm+WRUXlUP1Q78LFNIjOtlCJUX7tw4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708714446; c=relaxed/simple;
	bh=mD6TpMb7NtPhK2CN6A/OUDWlC3oGb0/vUWqyj1zXqLo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=lijyEXpb71mBgNKoTeFV+rxmm1EAfTm5NZM4LkmIgX01EdD9qkZaEz5QHQayuSEEZ4LjcmpKnDIZQfU27QqbRyxispOJZuA7OcroAFPIwNu7zcYc/Kw5PkPAfbBEVZUSFohIDqQtc1Pa7u/nVP/8KoGf0zHoqoUpuZZspr46iQw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Z43rNrMN; arc=fail smtp.client-ip=40.107.223.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Z43rNrMN"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKpfZks8YZAxPZUCkXmD09l1ilzeP3TfHb/qJw3AyNiXuByHT5Kxl4PaeUVy7PPBvjaZ0UCr2A36J1+Zn6rOwYyyXqJBWZNGelfiZFYwp71jCvdJoNLvWeydCEhubP7+379vNXZ4RbX4wZdfm1QePTwcull+DKVIHExtHyGwzuOGcGJMyeYa2E+5WhfdZ0z6deRiVZSqNHrh5qEuylVeR8+75JN89pI6NnVw66cOnbQ+hA2F0qKDnkpE5rIgBv845XBIVE7Ztpas074BvoZFOe6DgzqDVd5q1vl7AgE6GvOEp+UjtB9h/qZtQ3tJ2AG0dR06mdxUKmCBJzci7F1kKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acIyiznf+Q6a2jwEpjRRzHo74ErdGDslzFBQGYW5Ohg=;
 b=ScnxcfG+GmJsDdemaj0cdOJFbCahANP2/gKsZye3nP4rDc6B/f4gmJtjbAcCQh1DyCSzpYmksg7IO8PYnnHyUocA5919RULo/QO2U2uf8O+dqIcD6sVFf+Jpdhlai1j3PLxs6NZ9PjP3pQkkY/7wnES/Awm8mFKzbJK9O5BmwS/Yu1NcSF7IlobGwX+Jv4bAmtGijuRWQozZIHldgXmu9lSmYTwCrQOaBdEC8NROXhjPAkbCirEuocgJkwSm8uN+RD6hMkwBSANxmBoPIJWOJCI124iqqCUHp+OCogB0dNC0bpUqh1LM8vC4ASncYl0iRSwn2pOPYtoGSIH12dptiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acIyiznf+Q6a2jwEpjRRzHo74ErdGDslzFBQGYW5Ohg=;
 b=Z43rNrMN4F80Ct7eEfy5+o2PtzU8pGn2e2PNMFXNHl2o1b5caFn5BHNOSzFjkL/ceZAhb1BltgXXvbkmvtc1eUGPb5pfhSl22IsgjNoH/wppgYqKSOYkTYHnZH85gCYzCH5kR8Z+UjlJx66JEOZj/Ty0IIbHM37M9WrI8YHdIkdrqIIZ7GFHIwvymwfx3wN+OFjPsxLTgM014Y7vhcG/DeYLGHGobRaFRGPui3rhGris1HWD9fVDwRmGEMhOpLgmpwEIQmNoenw4hh4LRrNtNRq8cemf65QbWbIEE9lx0b8aS9lvWM8fO5FWyRxWFF8ZZ9unqTHzkQI+02NcQBcVBQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4094.namprd12.prod.outlook.com (2603:10b6:208:15f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.24; Fri, 23 Feb
 2024 18:54:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Fri, 23 Feb 2024
 18:54:00 +0000
Date: Fri, 23 Feb 2024 14:53:58 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>,
	Zhangfei Gao <zhangfei.gao@linaro.org>
Subject: Re: [PATCH v5 02/17] iommu/arm-smmu-v3: Consolidate the STE
 generation for abort/bypass
Message-ID: <20240223185358.GA791502@nvidia.com>
References: <2-v5-cd1be8dd9c71+3fa-smmuv3_newapi_p1_jgg@nvidia.com>
 <2ca7f64e-a9e3-4d47-b04f-726c86223fd6@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ca7f64e-a9e3-4d47-b04f-726c86223fd6@arm.com>
X-ClientProxiedBy: BL1PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:256::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4094:EE_
X-MS-Office365-Filtering-Correlation-Id: a0dcc29e-1099-4a11-87a5-08dc34a0cbbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mAhPX8s36hofo2+aCJjO+4rCIrA/8vAP0Xr8er5jJHNgwt4rVnn1CQoTkqRSI3oxwmMhdW+Uu4VlcMy7AN/Xt7mGo3rSC6sEwAxFpbgPp2GpCfBCI6EmzJfFwqkcFsrlsj6ZmXy4Ajdn+sCN5lC9jOhEB+5RPmBWTqAQba5gQ6Ohyj+ngG1M9wM2YZ8GyXfVZ0oUS7xnFT0VVfze8nbbgqYMC1CO7wz49l3WbJxkuPEbemhe0pcAWEVHjsD0P4T4PCk/6vksgoq0t0+kHmGs8KjOSfz4RNuRhsn6yOJwqWeKXVmZ0XFRducQjOuGWVJeptIDzRP6E8Y8j1ifd+GsGmeZ89QL4M38dNLFFZaw0KV2yYKRCI43SB+F/t59xSyi/gjjPPmLnG9G/TnZF1RqPQVYP8JW5S3q8uIzgqRUVJfbLPl7iVxjeLd7jXrgTtg1EL/Itdu9lgQr/A6Cn4L7SmXrThBBQVQFVACtoXW5sadGUaCyQy3cjtRgukNyAh2zy+5MhUIr7cyqODD55zRkgtEAKTCt/qP0P/0/H8R5r8Y=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MvKMMam0ZWA6w3A7dqTGSR5RjQXDZzT3kbW/KldJ3YK7b2hXhf9mi1DPHZgA?=
 =?us-ascii?Q?HZnl7Xi/58HecMshU6V+gNhEOAojdAAr92IrwQN5P3T31tPncKm9ewMcaweV?=
 =?us-ascii?Q?a119cwLgtUAWdGS7bxggB4S+zbmGA3KSao9bemmESoOpL4kdNNA34eI2ll1S?=
 =?us-ascii?Q?D/LAC+JdR9Jsq7nrlGZpv3FP8yO7j58QF7kKSoI/M/tEN1/wOwUy/o6/V9KE?=
 =?us-ascii?Q?5gjTkWUteMbY/pNNhLNE+upVWD+DbP+CgfPNYjJVcgly25AviFXBtAl5djGH?=
 =?us-ascii?Q?fhb5H2XujyDeENH4X6Prlhy8Y5/j7SdYYzfy3Cl+FRlcsPDkyJeSuIMb2Zf7?=
 =?us-ascii?Q?X3+084rxQv16U8XTuXhRbRK9IfzE7zBSNTBKuoC4p3PAtuhgBtmpBuZ3N2I6?=
 =?us-ascii?Q?6a5nEUeB90hwCOgL+qhBnqq3F0hGosGdXhYwKMu1X1de1WBQTOI2PBxiN/nl?=
 =?us-ascii?Q?tcTesjaZ6em+z5mMgFTAZeRBjeGs5RCZW9qzwt8s0B/g1AN3kCyODgP/yQjW?=
 =?us-ascii?Q?j3UF/X+9dkjCw4rrbB0+RpJXxmbIU2tttVubbnhSXPivfU5V7BqCtYq76Oau?=
 =?us-ascii?Q?UTIXCNzZRl4mgTxiDffX9lAmfP3tTF3XVnChvaQwYUp7pYpGiWnb2tTWNikl?=
 =?us-ascii?Q?oBYpPN5cR+4opzpJv1/qaj0b55NslIx+Gnv5SfilDg1QWAc6SENbUnjmiAxC?=
 =?us-ascii?Q?U/S2mbCgJqd5ZlifiYB7T6/uj7IADYl3dA4ZJ+gS5UHola7GGxFsmD1Tni14?=
 =?us-ascii?Q?EKwIBP0w978xlHTd0oT/eNflQ4xxOqr4FEPcqSRS2U+t9eOX6lYc5UKdMg+b?=
 =?us-ascii?Q?4CkZMXxaJc7By8AV4LrjU1DTiiPGJh+Ugp8eClYFDEo1fIbTx2DQ9AyZ2SPx?=
 =?us-ascii?Q?kvNvoBzzofogxSuktx2sEeZOM89O4vuEYS+x/y7KnjSxgy02y1Idgr/S0vxD?=
 =?us-ascii?Q?N0+qgIziw7rS27BefpjgdUibUGJkOCTeCfC2fDwU/4ekOm/2+qkYjaeIGpf8?=
 =?us-ascii?Q?FEPl1Z3gP0R31WRK4zw3oRrRPLudUZyYTpHHgOdcC3C+TW8zaRUkhlhEZYoH?=
 =?us-ascii?Q?j2iEHz1jIOGtA60UH5kil3Rr/OqpkZAGnGN5Pi9iW+XYO23cdTrO3SpNiKbp?=
 =?us-ascii?Q?N518W1MKXY0YnKLqUt6j2gVIMWTNhlpPhBDz2tyeJAci9Lv1j53y0aONowT4?=
 =?us-ascii?Q?7gI50s9klOWprC3Xzac9lluJG8OFtKQxyTZh6xdUHC/MLnCMu1UMFXy8t8Km?=
 =?us-ascii?Q?mkXNIdT36GBwObNNNI6Gzq4LAM0XwFGWB9GlADQL/pH1G3G0PB1ZmKnCbLTB?=
 =?us-ascii?Q?L8y8PEKZxRaWy4/fVH/Parxbv5MNYFOj3k71toMpZOY3hW65f2LrOOBYyepM?=
 =?us-ascii?Q?eUu+K1ITqkqbgqk+LfkkCeEefJEkDaVLt4Zze58zkiJCAlTSM9xMxQ5gjj05?=
 =?us-ascii?Q?H9ry0YqNTKJ35ip/ThUUcE4Np5IptTUHd+ul2DEpUB6iVTQ1RFjUFIRsKZd6?=
 =?us-ascii?Q?pxJSoimhlO65J0bKpoc9EArkqx2Zax6+k35qW6T+h0lyBSChxk/QMdzhBW0v?=
 =?us-ascii?Q?2hVklNlKcXmG1mCtiIqUiaflP3SfrLmpUrVuqHd+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0dcc29e-1099-4a11-87a5-08dc34a0cbbc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2024 18:53:59.8627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1oc3jPODFni2GaRZPdWM7IltBjz8HcsakGBgnOMtpy2WBYKX4+qZhZq6urZaLO+i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4094

On Thu, Feb 15, 2024 at 05:27:09PM +0000, Robin Murphy wrote:
> > @@ -1583,22 +1595,20 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
> >   	arm_smmu_write_ste(master, sid, dst, &target);
> >   }
> > +/*
> > + * This can safely directly manipulate the STE memory without a sync sequence
> > + * because the STE table has not been installed in the SMMU yet.
> > + */
> >   static void arm_smmu_init_bypass_stes(struct arm_smmu_ste *strtab,
> 
> This name is long out-of-date - if we're refreshing this area, please rename
> to something relevant to what it actually does, e.g. s/bypass/initial/.

Done

> Although frankly I also think that at this point we should just get rid of
> the disable_bypass parameter altogether - it's been almost entirely
> meaningless since default domain support was added, and any tenuous cases
> for wanting inital STEs to be bypass should probably be using RMRs now
> anyway.

I can write the patch for this if you and Will agree

Thanks,
Jason
