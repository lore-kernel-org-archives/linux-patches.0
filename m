Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9060A19E993;
	Mon,  9 Dec 2024 23:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786524; cv=fail; b=SoLw99kmnkJajeMbnMQMC6lsIC/w445Ke3t7HH/JvMCuu422tq21wiieIQlN7LJo/jULORPhNtl7pzSdQrVUvwCVWYCtcfNcdyH8yT+eBnxOLYWN5ZRKrrmtbDOob/7wyCyoepBW4NifBJky7WZBAJRozExMIjvAibh17BypNOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786524; c=relaxed/simple;
	bh=gq/r0/TUziisuMTjHQV2781+qUfbXJyo8rB3IISnchA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UHknIGg6cvjU1cYKAzZT+GWRK63f+6im4OwE9+BdajCi2iuRuTPzuY93Yg5bUgjYC4t3jFLDPz6PP1NGIpeNqrOzYyV/vBZzK3ujHB9veMdIYR+WARYaLJ8EJL/zi4dixqRX4auRt2+t50dEBRRFFUTTiDdDAsFxorSzkUtNL50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=jevLwMJS; arc=fail smtp.client-ip=40.107.244.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="jevLwMJS"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QoDZ2O/0w4El1Ug1AnnkKd6eP/nBqOmIiSePvukQjbC4v2ogiNUmfcH6C4XfVheLwtcK4D6m3denuwfdHNGwjKKYnL+NMB8W5CyVfDJXkH/nun/gmqIbdg/Ftv4/DVf1vMsF805x9PCdKiK5yiGijPH1a079tbORcqKi65pRq6CbzbjBuU/Begy4MPFkCnIBM9dyBk4jDPqBs2wTm43Bg+qq6GdVNk6BCNn/ZTRCsHuwQ5Y/D0uXWzwQ/hreH6+cuoj63wil4/5BnCtCNxVELeRGPzQSoNJ0pHPGnSpsjSI1NkJ+5uU0cLpJOLu6/a9DJhkF2BZY6SQiPy5vRs0rmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ieIOKlrrMEyf+po3pzikFmyLsR2i2PUjlk0qnPUFPyk=;
 b=ffD44/mnAnwhXAH2s1jYq/qg7gor2pAfKhLae26DtdGk6CslwdjU1rQF1Q4fLT86dVx6XwxOgVbDnTS3XQ8F7AWkxsKZ28eRBO0BDdJk9Mox5yV0FYnFkZY+srYNKVJSEy/EEoiQBwU9/JS+BHsaIIJCifIb0KDfuAlMQ9j13DaCVXWsg7yKpTDYPJzraB2+rWAtAvTh0ge4d1Jx0sKABHSgEyaZv0/+tPCKZdIkM0YfvU8wI4Z/e7bzDInnoXPeFXokFX9DflhRyg+a5ht3Fu+QqHMZ8eWHJ++1ZWObsOf/qgiHQRWYub7/x8cRlE3ayD3/MMw/FfZqTDqO7A5B1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ieIOKlrrMEyf+po3pzikFmyLsR2i2PUjlk0qnPUFPyk=;
 b=jevLwMJSHnicNpY7vQQUI6CRp5Ab1QFEEbQO4pUMeudT7JQyCcumvQa9dsFr8KyTiqGU+3EUzmPCqR7j6pQX5s4muhNunziTu20776pmmm0VJ6eYXGWkEK1if21lFfwzclMFJHQ/7NhDiyu7fI9kyGRueym3B1GtTcile1TwKshx51tCBGn40WUzxnBRLq9C1K4DpU2f10f+n7kMbMtFBomR7FJAksP9/QXrCn8zNvJyt4rQXMCPISK+qGUoW/VgoPckf6VDrxojE2MOZrZmgnLW7GuxNg3K34ocEmMCswN3uldKEtWCJOBYgxWbr7Kkytz0ulKVx6CVUCfuo42b9Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.18; Mon, 9 Dec
 2024 23:21:59 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%5]) with mapi id 15.20.8230.010; Mon, 9 Dec 2024
 23:21:59 +0000
Date: Mon, 9 Dec 2024 19:21:57 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/3] iommu/arm-smmu-v3: Remove domain_alloc_paging()
Message-ID: <20241209232157.GE2347147@nvidia.com>
References: <0-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
 <3-v1-0bb8d5313a27+27b-smmuv3_paging_flags_jgg@nvidia.com>
 <20241209230611.GA13790@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241209230611.GA13790@willie-the-truck>
X-ClientProxiedBy: MN2PR20CA0033.namprd20.prod.outlook.com
 (2603:10b6:208:e8::46) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c004743-ceea-4aed-37b5-08dd18a84761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?l8dbBFmsxBL/zM7MxNHx39k9q1drjYlnw8MsM0H/Aklq+c3uhzodqHkkydZW?=
 =?us-ascii?Q?z+lIVU75fTcygyAVt1p7z15jm3Y7unznrekA7UkH3OGJfX9UESp6A9ENsG3P?=
 =?us-ascii?Q?CbB/P8YUytFk1j/MdITH3jPKU3DwigonwRbqaNXQA1Wu28fQNaFg61mohfSO?=
 =?us-ascii?Q?BIe5t6VuhWm/LlGL68vHTXsOGlX8t5Afta9pvFZkskh6DKiz7noPEo1gOwe6?=
 =?us-ascii?Q?kheLDjYqMAAdtTSidO1DzINDy9IaKDnhvpv49808GlrbWex0B38NCgkMdwZB?=
 =?us-ascii?Q?nc1qWd4vWllYhx5THEpVJRth+iALQdgdwFniAviZ6qIj1HPUK7Tu2kB94BSW?=
 =?us-ascii?Q?38yU7zcNdYdxl1PTzpV4wTFw5Tq29NiYmVJLvy2KapgWWKf+urgdt7H1G/AP?=
 =?us-ascii?Q?8kCRDwE9CMnoQItabDK2+VgrmawcnY2nZTKRGCLpTFtCsxHICTWR4TS/Uotc?=
 =?us-ascii?Q?guvB5Sp8RwJFHkiYMAfKIz/UTRWV+a9SsLJuBPFm9NfES9t8wRYyvng+F1Ut?=
 =?us-ascii?Q?w7sEvfdg0pAHBS4y20UNH35udrgoakhV4eLuiX4+E8z+U03GDD/HivFMCDqT?=
 =?us-ascii?Q?OIfknbllRCF0OSa6XD40mBEn30qvDpayc3GknCSOSSab0fWSoKAa60Lrq9ga?=
 =?us-ascii?Q?XQFWBIN0BCoC+5DZxZGLh+a/IWF1sntSNUYcTCbDKTbzu9fior5Vm7y31XUu?=
 =?us-ascii?Q?z/LrDllEzqihZ96lpO0TWfXveNQhGKTzGgKKsJtf1jAejNnIL+RN2TEtyaOs?=
 =?us-ascii?Q?pw7SbToiMQ/47Yz205xvIK2fFJhPRptBqGJuiqFLH7DnxLj2IlTqxqqEPWx/?=
 =?us-ascii?Q?Ze/ZxUACXOGNgVNjGOaSwL3OZPBXjapCEZe54H8ghdodUlO0Udo6Zut7E+3O?=
 =?us-ascii?Q?u89WwPNWih2wiGDfl0XiWEn1TseJkGrcxJNAmGivCzGid3spA6smCz9RguUF?=
 =?us-ascii?Q?mvFZ/3AESlo8NLSZltSVbktIKTFaXtuTvWdM2FkT30cbP6bdGS34tZQ76ahD?=
 =?us-ascii?Q?V8w6gIf1z/S5z34gtarM+WH/OIIn37pV7+dcpfvN4zLpZCUgGZhIWxi3XAAB?=
 =?us-ascii?Q?9DZGsGrt98PY1L27GhYLlDfXkP61PsXGgpUntPGVVYrHWjosBUbAf6jOT1yG?=
 =?us-ascii?Q?X/VsYrUPpHUZ6HSycoxctfOHiyT1hkk3Jh8GrrM3ACcxqICMQtdQ4iSVIxpD?=
 =?us-ascii?Q?QCeoUlwhibBawroznPLGUpFRVe83kq4tYz9ZX2sPlwSNPJJFvtx/b5hvFa2V?=
 =?us-ascii?Q?WD7H6UEkyXbOCsuie8qqBrNA+LeXL/Yy5dS5MfSu5w1WpceS6kjd6l4LLM37?=
 =?us-ascii?Q?CePUhyURSeO+BM7Phc6lDT1I4Cpf6aZml84OmNf2tXVb3g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9GVaf2tzXqjBBqDNJT6fgSwnYcVMXvNOf6l1xmrI5GDQt2eravnGoV7ETeph?=
 =?us-ascii?Q?s29ta7+tP6gDshEBF6ti7gEt2spnM8R9Yduu3j0rB9Du4WeijuEpMXnWyiXd?=
 =?us-ascii?Q?AD21Dy555lcx1j7OdOkHQDTVice1g6E1zZkMNN3C3Pnb07qRJ52OWPjVk4XO?=
 =?us-ascii?Q?A8fZr/DDO24MTgyz1E73/XuxIygx75Mtd5hGHhnC6bSscY7GPmbCQrurxJqH?=
 =?us-ascii?Q?0Dd01LimRODY0Bl5NYMK97nWr6Lv1xxJ6JgBruTjKu4dDtA9PHlVh/vavqmz?=
 =?us-ascii?Q?HyZq3UDRZQbZgxxExSkbZH605HEXxwdQ7hSAuCVeItZ8cp10K8TRNlYs8XKP?=
 =?us-ascii?Q?F5oysIar9au3w7x8EijOd1DmJ8Lg/ARJfbRnVToBgkjZYal/RTW3E5tpXZHP?=
 =?us-ascii?Q?DWR2moEo+vAdUF1B4IA4fVgNXtt1TU8Ud8Ih7yxbABBCeR3tFVS9D19xJYXo?=
 =?us-ascii?Q?rr9xGlmTIs23/8e1QTERhnYzJXso+/ZP/fwHEJZVtF+adJCKLHrrRJdqjHQ4?=
 =?us-ascii?Q?JGE+NGn9zGIcvK+UEDjgNUw56WT6nqPySd2De/T7e5ren0+CBO9jghCTiY9P?=
 =?us-ascii?Q?K/V3Ge0NTRpTCO63plbvfOPwY7N/KXug2C3NcbvLyM4GnGBBNLi6rOseDU2r?=
 =?us-ascii?Q?36zCyjJ9bV+vDHbpyzJHS9KCB9YXSDEcnoFLqElsi1OEnwYjzaCWhwh46tI6?=
 =?us-ascii?Q?XFt+y8BfoiVHgywzPAanNkATtV9H3C3bFvdsq2crvjKOXrk0Jez8tTmlezu6?=
 =?us-ascii?Q?cE5LGHWwrbR7cqO0ppgmFffbeRreV9nJ73bcFk7mhPhRvs57qCIUb3BRRTnm?=
 =?us-ascii?Q?zf5UeWP0XOlJqvwwhpFxHZstJep5H+1Gj47jRGZnD+2qqOGrK3NS11Omfj+S?=
 =?us-ascii?Q?kqRSI+3SFSn+ly0s9EyQ4PHMgWL7rl4tEVNODfpRx1vomFrqwUF0x0i2sX8q?=
 =?us-ascii?Q?Hv88pOCX0caHXTfS+YN3F81wwWn6xqFUIqxEB568wCMdY0/9VTpLCdfqL6uL?=
 =?us-ascii?Q?KWXM6jJ8ue+lU+hmroIFgrlk/iC0IpyjOViveCFHXxdEXxSdQ7ut5FJPlp2w?=
 =?us-ascii?Q?N6v/wwXwHxTSRyYq+LR+t4Cbk8dqjP/RkghlMNUnryVnkDoRiYCW4u9hecNj?=
 =?us-ascii?Q?7HpHDRhBNkZQBk9kmV6xjpr7DgxF2Iy/qkfV4H9ZYAbIEXzjKeiYqc1k4BWW?=
 =?us-ascii?Q?ImAv9zRu2jZNyEOOs67QAdDDWVhAfdEyQABToiKnZjovlg3JBOFjRkmcAxXW?=
 =?us-ascii?Q?IoUq21Ur1JIUiu/ARIsmcKtkNTZR4uoAiQ24TEd3xq7+dp5Ce2gUARsAuznq?=
 =?us-ascii?Q?1GePDfxhJvBUnVXdDjvrnEORrvp8gzVXUisg5tCaMuAVj3VFmQabeDIwrBzE?=
 =?us-ascii?Q?IJrJUfWt268Yo5LarzGqp+k9DfPEbLVHKDSqPI+4Y+UxYPZuLC2ljGGgWaBC?=
 =?us-ascii?Q?gqreh0suwZBskCe6uQgl63Fs+ujtkSnQa4LwhVzalfUdacGthU32RjD2UUw4?=
 =?us-ascii?Q?BnSDdegJqoebvb2QZK1F85ouYVOLIxko/tUGLn87jSJB0QxuzS+dQ+rsfuns?=
 =?us-ascii?Q?MIOSx/RCqpbOPpXB6XU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c004743-ceea-4aed-37b5-08dd18a84761
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:21:58.9222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GwX7X2uGKhTDQ0EoGkmId5H5dLCb8XVYkQmTgyAzSWKDgd6nv8iFp8khuO35L94d
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622

On Mon, Dec 09, 2024 at 11:06:12PM +0000, Will Deacon wrote:
> On Thu, Dec 05, 2024 at 11:43:29AM -0400, Jason Gunthorpe wrote:
> > arm_smmu_domain_alloc_paging_flags() with a flags = 0 now does the same
> > thing as arm_smmu_domain_alloc_paging(), remove
> > arm_smmu_domain_alloc_paging().
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 31 ---------------------
> >  1 file changed, 31 deletions(-)
> 
> Ha! I was reviewing the previous patch and about to reply asking why we
> couldn't just implement arm_smmu_domain_alloc_paging() as a wrapper
> around arm_smmu_domain_alloc_paging() with flags of 0.
> 
> Good thing I read ahead :)

Yes, the main point of the prior patch was to make this patch
possible :)

Jason
