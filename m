Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816FA1D04A4;
	Fri,  6 Sep 2024 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725633628; cv=fail; b=IGkpREtwBUMqKP+gs22FiHLqDNe0pwAKiGqeKlN8jg+QSD+hvXl3gV2TeAg1PzDk9ruCJJ/v5KZtHkGbpUvdCiR0BnWKfDKgbXLJtORPG8OntjKKHlwNjU1b5FEGqZ5Lay7lQXJ/LprBEpvU35kv4iZqD1jSGOWXtyNjfbi1NMc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725633628; c=relaxed/simple;
	bh=3BKXpVlBy2wEDvq4ueJVpOZMlBotKuVa6TjS9rtKaIQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cGaiLwe1h0U5bldmoKVeL5L/0YT6plu4sLmNPbL17znH2XSMgcqSZDKaZ5INHinHW//dhqt58aExUrMauK0ZMqGELHxnJEET6K6Is0yR59vDBhvm7d45W+o7aVXdx8vEa2nkGH7tL5VobjatYDzPaRwPVcjO+x12/0F+wRo1lYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hsGPfQkD; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hsGPfQkD"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tlp5lK4nxFDiIjaXnST7YrV81h+xcZqKTLF6QKsfnvTHLCaBRMmfVV9EIvvn7hx7rcemz9qVNSinx4fbQmHNLhniVVXPr5zgoRmbhHjpvtMrHNotq1UEMjs/QJoGY3fBo0egAK5rbVC0jM5wcMKKZYsok1QSEVAotsWeSVmqwVhGHY2SmJZaZ8ZrCrRa0vpYKTW1kEUEqG9tcNzod11BlIFj1bHbf2EIaCgYj0b6b/9nIK2FKQln79jYbjcc01m+XxX6uEEj7Q1bQJLIB4zYwOH8ZM32+Al0tzGNgN+ucRGqqIedKzNXNXv9Q1m0RqOici5PtfXV2YZc9nzjLRjD1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTnHjf0eu+420y5ALFehvk3+p0Y83kCi7OAzUGXIkOc=;
 b=ZPeLNW4JpwwP6Xw+Y85eEZkGTf3SfCI8NeY4lX3A9lJH2hERgvXrl6PHE2pAEweD5QCe2VgWphJRqvjBlObXW1echaDUC3ZPHO3oBTI/McxBklUsdSKcqexYecDWQL4S05BpRb61JPbHY8eyCIhayaTk3y+H7EHUhvIoV1n0BLZiy0svUGnuS1WglP/elGIEqu3mXPiaT3p+ZgMVcLdo1oO2Ylice/ypsue/VZieZ6T1o549QzLtR9vfUwwqNfu+645w15qLlL7Wq4ot0xu2IHSuO3eGhiNVHpuHwNwwSED9id+KNnRi0H96l5zU+cQQw2bXvLjffPbKRfIBAf0few==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTnHjf0eu+420y5ALFehvk3+p0Y83kCi7OAzUGXIkOc=;
 b=hsGPfQkD8+22csfLDwZEa5WxpELKE93aVZPKbTwspwy3j9hfNZtlVQdokYsyVl6wTJx1vJOh0naNYYkxWt4sxXNDxWJ+1vszQHgEP7UYKnLiTHnY/TQ+VUl6c2ZKDtfIeYwlfqDRVjoI5f4qGeE4jsfsnIOqVq+9hGCxdmC09bKudrL/dyrq23IbIfYS06pXYl5ZNbBz92YoYxu/xtnCB7vcdBxsMnGYPzQk9sph/AEXQ6aBY6nC/VMj1gJL5YAnL3uh/tdJsGICmT2rsSauTXoVGYBujvD/FkQT4oKUREW15DgLCfpYXaXw8PiOdX6hh5uuvTH5rdijLuTKqlxi9A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by IA1PR12MB6306.namprd12.prod.outlook.com (2603:10b6:208:3e6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Fri, 6 Sep
 2024 14:40:22 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 14:40:22 +0000
Date: Fri, 6 Sep 2024 11:40:20 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v3 2/9] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
Message-ID: <20240906144020.GI1358970@nvidia.com>
References: <0-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <2-v3-9fef8cdc2ff6+150d1-smmuv3_tidy_jgg@nvidia.com>
 <20240906131818.GA16959@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906131818.GA16959@willie-the-truck>
X-ClientProxiedBy: MN2PR19CA0005.namprd19.prod.outlook.com
 (2603:10b6:208:178::18) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|IA1PR12MB6306:EE_
X-MS-Office365-Filtering-Correlation-Id: c088926c-c93e-41b4-27ab-08dcce81d635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fUbTGT2EVb4VX4im9XROtm79A/AUSaHujs3qhuqYqw738Q07XFogk6hzqJzs?=
 =?us-ascii?Q?jMObyxP6o/CvfZShtPBDgOOTxIG8/J0bPKjWc4hjstpNyC30ZSX0KdpOJ1kE?=
 =?us-ascii?Q?/E0r22/DD8fyzXyof1KWvFnKxbweUt7EB/G6HakpEQTDTwe4tXPqxPccBJZv?=
 =?us-ascii?Q?UBYhEoMpC4yuXZ7aCnV782ZGVg/w0eKY0hqy/JG13wkeNkwcAAd/dDheBUjW?=
 =?us-ascii?Q?lY1S51Gl6fRayuPpfTiy7ri0kpndxKPYwkLYFU7JkK4mCNkIOoLsWyMHdaaa?=
 =?us-ascii?Q?NTqp+mbRasHb717iZPVB0VXw1X1olxvIE0XzKvDmDtOdUq2IxpsRCBsvxH2c?=
 =?us-ascii?Q?sdAdBh23YsBXapgFIaRROabdzDqZ20PIJziuck3vQX1NnWqCzI3FlmaOE75R?=
 =?us-ascii?Q?s3H/8pTz/kmah+JaLaOwLYucj/or+0ZcfPXZTL/UP8IoTC7qGlEtjD9ghhir?=
 =?us-ascii?Q?plPBt8573BkLdAMZ/XdyvqAE2VdBrZmFodg2CPVwcf6XDtQAKdUCtCNDiNcZ?=
 =?us-ascii?Q?cxMmYpdrZ5CxlA+fb91OjHmkhN0ZmWtfA6H80pN29RQdfFqe1WUo+vTFche1?=
 =?us-ascii?Q?dwDjyp7QQPTU3f3aw0GXhZLGWJ+LO3W6pmADj4ZM1tz02YIPC90lSb+UJvy/?=
 =?us-ascii?Q?2mJVDqOGefZVGxks+1ggHTzqLJXL5a7p6TR+ayqxEnsuXbxMuVu1IE6bEZ3t?=
 =?us-ascii?Q?Yk/BXQf6lEFynDdu6Oj6nVe9mgQY2M6J0KDbdstVCaTOfzfaQHUUjKaOgIH4?=
 =?us-ascii?Q?WWUXg4UTqEDG2wg/KX+4kT2pJOIjcgHnflb7M0dKBs9QcLS2AYGqBBt5irBL?=
 =?us-ascii?Q?qcngiXYzc4WDesjVZMkJBCPEahaVjaH/3Msjn41UbJJgz/hPEDz2U6XPrLEc?=
 =?us-ascii?Q?FeFacjIluMI2oAGaBAPvPqmkStfoAZz1KeHC+SVumEhrTtpih3Nmw120LqNJ?=
 =?us-ascii?Q?4R16tRmag9t91PWt92P4yBAkikn4cA1LRZafOdpEVssc6n5vYj64bj0zow0B?=
 =?us-ascii?Q?hY1h5lFL7VjOpPLlCNOCinRHfCY9LOpfwe2FVedOd53w5PO4/Ex6ylyA6Xtk?=
 =?us-ascii?Q?FztM38jafq+wOwkHTt2bCklvGHvn39ux24w6gHVriZ7esO8jeb9Yo6F1E9F5?=
 =?us-ascii?Q?KRC8hWpM/FPF2dMNj/6LVJnoksV7/edsiK+i7i/oWm9Tab5aFdl1BlF8haOA?=
 =?us-ascii?Q?/Pcg+ohHmxmn+GP1qI1i5bDykw+xA9h10L+CB2jjCoJJ3F002T6bkOXc013r?=
 =?us-ascii?Q?Jc2hytzlz+lsiiiT8gK8RQxsc0GJ30WBon01fPGEvhB2isoe2w+vRtIdK80L?=
 =?us-ascii?Q?ElkEj64Zjpd/4qN0SorzAxk/pwZ7peWBdOSsCbqLECxZlQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZklrMdk3tZIX0Ipv1Ah+6LU/oh5hnAqB+a3wAI8iJYmN6+WjTlN+yemz+Y97?=
 =?us-ascii?Q?/hZT2zacWvp4vstl5JIuGpdWVveKKw6gnQWhAuw+DLH+jN19agz49P0iL1W+?=
 =?us-ascii?Q?ayG88ee6d6veItCkJijxW0Epvj2HyAKbJ9shOebk4VSebFoUNVzkn2kJbKEK?=
 =?us-ascii?Q?cZQ0zIt1vVP3VP0mrQsIrFbfobqrxokuewdoUf3Yxv+xCbsWZhCdfgZXHcvO?=
 =?us-ascii?Q?wkut9uriZFC18q2gsn1UbAzp1mQvToxDPUDPNxColo/g4c41Bgo2rPSe+y/U?=
 =?us-ascii?Q?9Z3VpsYvoD2XioVORzozNNHYyDI3npWQgAmBAGIC2b6DqoLsSemeHIsrh0Bk?=
 =?us-ascii?Q?B9OdmNz0jZyXxUaU9mTQfwIReiBDcuS7Zcthc1GORVPl1ByTByy5NjaYCPr1?=
 =?us-ascii?Q?AqPf+72jShE4raz9mI5t/QYgEbJ4c1WxyBd59bi9py4af75vMPMsj0uoszCb?=
 =?us-ascii?Q?eGBdm5t3xKxfLO3C45NxlQIiswSNvAxejcMZgQRfmJsmNWP9Suj2wuq/jSTZ?=
 =?us-ascii?Q?oH1MQZ8mBo02dzHsXJe5mIucIBU0MW0OKKMVEPCvTjDsAd6m1ve4brLiOfFA?=
 =?us-ascii?Q?w3xCVnj/ZE5bIW2kH5qaqVr02HjVSIhJAHJsz84zZJhbIiWotwxwEjqWcS0j?=
 =?us-ascii?Q?dpxOISjHfxHuKrHFPPAUWCckQ55ejA3DSLRynfSzPhtMr7BtOzJW9jgDnTEX?=
 =?us-ascii?Q?tAlab5lSCGOaIww5snyBLg1qwmj7uB7JUSBRl8A0YJLwgMkimlTJczsZ4kpI?=
 =?us-ascii?Q?MpDCaUA/sYjKdDD4UhNhe6H4Lj64c9kQzv5xzRYjM1dPA3adhE+KrdtGRIK2?=
 =?us-ascii?Q?1gMwG+OU5Fu5tp3ox0V+wcYIlURKXcdm1livCInAI+Y8GJFfYDtA5v09mhAY?=
 =?us-ascii?Q?PXHf2ew8z15hTPGhBUDBe2OqMET7oy0F0IZO7FcwSZczqc0cz5w/kXfLpelR?=
 =?us-ascii?Q?mY/07CYBPS+5S0mA27vmj4Jlfte7jjzRKnMp6rW4ETYfOwPhdJlZrAwmO2u/?=
 =?us-ascii?Q?XbEIJSZW32F/uyX+BKJz0LJrAoW7R9DZY5QBGv7sZ1imzX5ndBVNfwJWyJcU?=
 =?us-ascii?Q?0ud2YVJ9YeOmd7DmFIxGscSMpgJYtGE/Ao09ESkd8cHmSPuqffi+r2e5egq7?=
 =?us-ascii?Q?S0Mijl8gh2q0ud9DUD9i7TtcRLs7Pi9jjx3BinwhOsAHB+I9rGb6arhxXy+R?=
 =?us-ascii?Q?oIj9Z4vee1zx2mQddbQMrJOfhT/St6NUif1D0FUoYR/5r3SZgBxcyaXVFLAE?=
 =?us-ascii?Q?yUDNTRUH0x353+46nNo2InQBEmbTvERFyQ/msZhoqdvVO6jkmICRPBqibYVY?=
 =?us-ascii?Q?D49J47J+8glbeOm+UBCBT/y7JWsb4G3TIMbLmcJZIdzkk4lPwN8tKxm8pS8i?=
 =?us-ascii?Q?FWq8ESCPYZ3j0D7ZCPOfKeSbAjZqJLyJyHOOwh2j9MgX0eOMnn6VhKNx4M+u?=
 =?us-ascii?Q?rWd0W95Nj8qWuhhV9ElPZo11Dsu/CRde7HFdKA6Pok88sCJemgULyP/IdqfD?=
 =?us-ascii?Q?2or3ifX0afv92spYIjvXRzuaPIyQ0DB16TbAbjZbsMeW0WfUKs8mnQ0iD0+1?=
 =?us-ascii?Q?APWiAeT2ay2gghnKmfaHZ32ySgQ1w/dbExghh8/A?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c088926c-c93e-41b4-27ab-08dcce81d635
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 14:40:22.1154
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4nmaG+os46FUUdAlIFdB99P7s27eIQ8VZT6JGhh8pAV+BfrFGqUm4PQhe23eI9hg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6306

On Fri, Sep 06, 2024 at 02:18:18PM +0100, Will Deacon wrote:
> On Tue, Aug 06, 2024 at 08:31:16PM -0300, Jason Gunthorpe wrote:
> > Don't open code the calculations of the indexes for each level, provide
> > two functions to do that math and call them in all the places. Update all
> > the places computing indexes.
> > 
> > Calculate the L1 table size directly based on the max required index from
> > the cap. Remove STRTAB_L1_SZ_SHIFT in favour of STRTAB_NUM_L2_STES.
> > 
> > Use STRTAB_NUM_L2_STES to replace remaining open coded 1 << STRTAB_SPLIT.
> > 
> > Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> > Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 51 +++++++++------------
> >  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 14 +++++-
> >  2 files changed, 35 insertions(+), 30 deletions(-)
> > 
> > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > index b80f3359a8d12b..a695e5f8fc2880 100644
> > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > @@ -1670,20 +1670,17 @@ static void arm_smmu_init_initial_stes(struct arm_smmu_ste *strtab,
> >  
> >  static int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid)
> >  {
> > -	size_t size;
> > -	void *strtab;
> >  	dma_addr_t l2ptr_dma;
> >  	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
> > -	struct arm_smmu_strtab_l1_desc *desc = &cfg->l1_desc[sid >> STRTAB_SPLIT];
> > +	struct arm_smmu_strtab_l1_desc *desc =
> > +		&cfg->l1_desc[arm_smmu_strtab_l1_idx(sid)];
> >  
> >  	if (desc->l2ptr)
> >  		return 0;
> >  
> > -	size = 1 << (STRTAB_SPLIT + ilog2(STRTAB_STE_DWORDS) + 3);
> > -	strtab = &cfg->strtab[(sid >> STRTAB_SPLIT) * STRTAB_L1_DESC_DWORDS];
> > -
> > -	desc->l2ptr = dmam_alloc_coherent(smmu->dev, size, &l2ptr_dma,
> > -					  GFP_KERNEL);
> > +	desc->l2ptr = dmam_alloc_coherent(
> > +		smmu->dev, STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste),
> > +		&l2ptr_dma, GFP_KERNEL);
> 
> Since this series is mainly about clean-up, please can you be consistent
> with the indentation style that the driver currently uses for multi-line
> function invocations? 

Honestly, I don't know what that style is..

I try to stick with a common style from clang-format using the
checked-in specs. I touch so many drivers and so many subsystems it is
a big ask to memorize everyone's little preferences and adjust
things. I feel there is no way I could do that reliably..

Still, if you have some specific things that really bother you then
please let me know them? I can make an effort, and/or you can adjust
them when applying? For instance I have already been mindful to try to
keep the vertical alignment in some places.

I'm guessing you are looking at aligning the argument wrap to the ( ?

To explain - clang-format has a heuristic for this. If the code
formats nicely it will align to the (. 

For instance this proposed change to fit into 80 cols:

-       cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size, &cd_table->cdtab_dma,
-                                          GFP_KERNEL);
+       cd_table->cdtab = dmam_alloc_coherent(smmu->dev, l1size,
+                                             &cd_table->cdtab_dma, GFP_KERNEL);

However, the hunk you clipped above doesn't fit nicely because the
argument 'STRTAB_NUM_L2_STES * sizeof(struct arm_smmu_ste)' would push
past the 80 col limit if aligned to the (.

Rather than break an argument in the middle of an expression, or go
past 80 cols, it switches to one tab and keeps the argument expression
together on one line.

So, which alternative is your preference?

> I applied the whole series,

It seems not?

Thanks,
Jason
