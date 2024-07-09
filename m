Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C81474BE;
	Tue,  9 Jul 2024 23:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720569210; cv=fail; b=hEr3bEfjBmdlUR0S3YPLUQ3xGGGxAMrHoN29PPCzVl3dTx/Rx/S24L4s5vWQ/T2O5mvwHdFQl1oCW0i51jmKBb4ZpztKacrBptnXiN8PFohmcgwslYACTnTNrSDx1by27WazK85rpTkOwqcSPRIHHvBsRs7wZNBb4ea63u3ZPKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720569210; c=relaxed/simple;
	bh=0oTV9RMSnIkOuQxGFH3oc5neZgq78ixrDKNHIIPu+mo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GRZzeSVfhmQn0c4fQXt7ysUxbihHHH1ZbW9J/Atx9uY3sIEcaLD4bsoSnAJsvWW3Ci80RSnoxqnh/YEG8ICrLBgs+AsRU5u30xIPJm1QA7JHrRboF+x8iS10XcusIkEIymlTtcnvHo31uQ4OK8MxiLCdjvDA7s+/LpAeWOu0nh8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pzGB9DBK; arc=fail smtp.client-ip=40.107.100.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pzGB9DBK"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dh5zNVu/X5qaGmYk7c9OVHAh0xwXdjha+AHvjxTaFsjbtujWAsIKmVJQ3ga10ForMajjdMF6Ab/ywuVt05JGFR8UPwxC6wrHFHgq/xtDsmP2dZBFS+ptOnTHQUGBwRIkn2vcLQ2cNYJQIKussV0pwxGb9UAHXYZPZl1d3AQbFchWMUtiTah4UyEWisyYKJ8sXNoypm7syxDbsj5sKGxIWPMaQ4REP5rfElXr2ekUsMKRqVh3TLp5qP7o0Ph7+eewZtHF3ZGUnIkoamslMhrsvmO+PHd11TrHgHTkkk5LSPwPt6ah0yu67YXEz9iA98VQyBAEUQVBoJhiz+dhFgky/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HEnnwNpVqgkJlz2A0DQvt7lJADHiuOjlSmilIaq0Nb8=;
 b=LEOt34T5yCdNdu62Bje6ZBBsDvG30qKrGj+lzzRhYd/UiuKamXTqAwAoaK0cApX1b06xL0/vRZwvndqLNCUvtRIyYm5ciUsnvjJqcLCFLp4HkLW/SwnZgKYbkektWvxfUkJaeR6HY7nlCktm5sUK6w41FhRpzWG4yhZ9FW7AvWw+hwzq8/8+hHizUNsnZr9zYL0EkpxkfYjAVt79T03R7LPBS268j8LHuyWzmmnxsjA2w6pteQrmxHrRnlTzVSZsdQNitDRbXvb0moM9Xwp9fFluF0cOSrtFQG+QeZKam00JsJdncw+zAnogYsGUNj7FDJCuwVq9RAsvLM7xbPvYBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEnnwNpVqgkJlz2A0DQvt7lJADHiuOjlSmilIaq0Nb8=;
 b=pzGB9DBKfimFKKlmexIzs5gEzoIPst4awEW8nlYpovt5mNiA6Q9cgfE6myfdZOvRLyGI/aqU9x7sBR7h+6qf5CXh7vMNRZTZyRmC1RiNG2aNPwY037L/5br0mIjmanSV4F/QzF+LCADHv0bSgpZNDCOc/le7r4wdq+/ocU9jOijMVj9Ul0F35Ajh53hX3oj/9QhhrngPwhAbrs3njRc0XOv+qF1W2Evwm8aq+fOj3ONU7mBKM0V+X8r4xQa7y5yHDlDhslXKWk1tBAohKrr81PUMtyrqaHjhtBet3SlIHF8ejlPi2dhHvhZd6N6F/b2emtQa+fZZYuVi83BR6DZAPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ0PR12MB7065.namprd12.prod.outlook.com (2603:10b6:a03:4ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.35; Tue, 9 Jul
 2024 23:53:17 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%5]) with mapi id 15.20.7741.033; Tue, 9 Jul 2024
 23:53:17 +0000
Date: Tue, 9 Jul 2024 20:53:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Will Deacon <will@kernel.org>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 08/10] iommu/arm-smmu-v3: Shrink the cdtab l1_desc
 array
Message-ID: <20240709235315.GO107163@nvidia.com>
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <8-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
 <20240702184607.GB5167@willie-the-truck>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702184607.GB5167@willie-the-truck>
X-ClientProxiedBy: MN2PR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:208:237::11) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ0PR12MB7065:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b1c5a7a-db3d-4a25-165f-08dca0724dc8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i4ZI87JrWascs8iEJx6U6EcT2dwHac3LgtnsJl505tsfYqnc5K66CQrsmy2M?=
 =?us-ascii?Q?E1giHPVEuUqtCckOSL6otv/gksAcvDYXodQMxngievOdRpNBeIAssVInUUDH?=
 =?us-ascii?Q?5LHhYdaidjUd9X12id+0aBF2coNYhCPBRFRJr2vR+wTethEW/55R7VvwAOkq?=
 =?us-ascii?Q?ahUU69tYgPz5kmJYekpKD1gBl9M1saYKswp1JawV6Xs2ePH9FI86/u2NrBgI?=
 =?us-ascii?Q?BKsCkhaUo/Bn1mtmJtoJpxELCEtdZ+JEyMTsPtVi1/S1UkLBd2ZvA9mVx9tQ?=
 =?us-ascii?Q?AZVCG2g9LJZr+ex4BC6X80ZsAjlAOxmbvDTDSsGyk7mO3VPtwK/5BPFcMfT2?=
 =?us-ascii?Q?Bmq+mpYdwfUdnTIno14BnWsd+nyDD1hBcUO9RpsAcSSBG7pmYmhUHAVmHmCr?=
 =?us-ascii?Q?0WAVRWM9SqCCBPY97DTYTxI3QTlo/X/PN+fiNuQKm7eBSNnBn7imsv8IJoaf?=
 =?us-ascii?Q?yzujup1RiQ7s0HF2c0KCmsWbt1Tt29ewb28PQeafejc4vuE7F1FHtMbdeYcn?=
 =?us-ascii?Q?pnBxBPr2EHoZtcZPlzMZd5mK+vVYR2MJXC4ZD7yt5ZiVxNXr7rTZxmN60YRM?=
 =?us-ascii?Q?TsQfXoTcFFz5CAdf2y8bbWH9hR8HHIXxS+PGBIDB9Pvv4BwxQMu/EcXuIEq4?=
 =?us-ascii?Q?0gV4KKzGlLxjbV5C15IMJ7Z8QvuxRtOwAEYwlc2Djoa6eLXwTK7Z/6wsJkxl?=
 =?us-ascii?Q?UVg7DFAAI1u5oUF+2Rt4uG6e+rhiXU9DqtK8xgcVME3GAc6N+xc91Ot30ICa?=
 =?us-ascii?Q?OnfBh4eJ1rPXAsrE5t4ii4qe2o6D3rDrBXXkiUQrDI30ZuvlB4ov0dRh4YKc?=
 =?us-ascii?Q?GBZcL4DelX/xFWq69AA8+yZT+NY92INzRjuEoQpGAF6Bxf82ZClksSerQdfb?=
 =?us-ascii?Q?4gPfVqkA/xJPxWYl+7xZjx88PVocwIQz9IMEC10aKBVJCfsHlaXsBrS7A5ia?=
 =?us-ascii?Q?5cROnB9W05NohAfvXmcnPTImdol5b6Ktgv/fNRQKeZlaAMwOwhhDSYUUBZHU?=
 =?us-ascii?Q?omVi28ovDFjNeHqEVUczcbODwX/HWzWDZzutRsWSKP5Cwa2sKm7+RuuFGgyD?=
 =?us-ascii?Q?G6mXXHro3mf90WfOW1iG8l137DKfIif03ogwHiapiZXcnPwkCaLMJkjKVvHm?=
 =?us-ascii?Q?0hPYzRr0B/n3GX34ts9oPZYWJNPjKzTX57UD61vNmbrjREiUgG3JP9FwbzWx?=
 =?us-ascii?Q?qZUFRiL3OCt5bPX+0iNIfwYbSQQYAGF1SlZg6fiJ/b6WrTe1g8TGROuPwC+s?=
 =?us-ascii?Q?9hPk1bUFTXSSUzzRNzbTHGgnIWdV81Ryzuzo6OMGlKeYg1sZceK2OBPb42UG?=
 =?us-ascii?Q?6k7pNfbXc2C5WE/THxBR7hFO+lsS5U26elbf0GLyfq+KfA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gTN2LUgyAG2Jkrre0xbHX0XV79dN8Xe0pV1jhiMf5hN/a4vFCXDUtOmY3nvi?=
 =?us-ascii?Q?LcGgAZS8LbhsCiPT18gIcdm4MY7pNcRfzLArsVHvIqBjUWMufurIAix2WBVZ?=
 =?us-ascii?Q?LyaOjDvnfH08W0sa/PZoqbdH5Vmq1cvFgQDx3YJN3piliv5YG2OB4o9dOda4?=
 =?us-ascii?Q?vGq42QTgu8cEckfxhx62jXS0xly1n385Oitkiu7pL69PytV37qg2j65V50LH?=
 =?us-ascii?Q?LNKaXG9XE5dxMz3gOLMU7jjvBF3rT6LKWPn0wKg9PIi5KyLR7FRAdxO1Q6RR?=
 =?us-ascii?Q?DCsnwubcuk70uFu1ohKrIi7r8ZAWmEIfIAzrd9XAoMynGrFAyEBbSejRI1HP?=
 =?us-ascii?Q?NgLMb96Ml8DL7/rGc1BS/fr8vcbB2ZEkohusccvO9FfVNGJSvgcSc+kzzq4H?=
 =?us-ascii?Q?1pnpPIjy1evoLneN0KaHlcRgi8vpzOyq9w56WW5n0ec07Xj3zP7JLEyFOhBp?=
 =?us-ascii?Q?H0yfx3InTWeBCoNyWs0yUfY4k90/4s2hOmK3TGl0pSlI2IlNvFJXLNF84La4?=
 =?us-ascii?Q?10IteS124uQ4vWXr+7nsDMdwvvumssJCDwb/ezYxFflrZVlizh1exV8z6bTA?=
 =?us-ascii?Q?6RIdoaGqx+WRNsNfHBf/g3fPKn1HdRs8TX6Y8QOtwZihppU1GBUIOBFlsnZP?=
 =?us-ascii?Q?0laYTV8VgXhCbon05x3xoHHTG7GrZ2wnOtrlHJ8F39K1uDM09X1Il6TppmZD?=
 =?us-ascii?Q?HKURVBMpwQUzhMyAjfSJ6jgGIUpdy7HyoWO21aXc1JyPNhf/L9ruCla3RIKw?=
 =?us-ascii?Q?W5xOgdNUFOeA36lvG9rrHEXrE2EpoBwV9vV4iUxN0v/b6oLrIZxZNHwFBgQk?=
 =?us-ascii?Q?8wDTW5NHCZ10QG3ihSaaQNuV8kTVHis//AymhmjfgxkiFk2HesHjvWcs7nT4?=
 =?us-ascii?Q?XefVaIiZJuuqfGrCk+6ZV+/JunvJUnVQiGwM3rerbRKYPZz3uW/nwWuXOPs9?=
 =?us-ascii?Q?r+siSMbtQ72bhn96gwSEdlcCeDzS3wxmZmBr3mLrEbymNgaiCriYnUaO9O+7?=
 =?us-ascii?Q?aU241Wq3A6NURwEjnNp+l9ghfmRGlvopsKgVst7PLLP6iXz/N0ern2g44BEF?=
 =?us-ascii?Q?ZDg6Axu87XkTWbgQYGMpV3ohk9eMwVbDIfaz8TITt92aAhC0WnEJSC5qBj5h?=
 =?us-ascii?Q?zR7kLr8/QIkipRjm1nj6zYq+Q9xuI5Yxtbc6XTxSkeUGOfmj3X5NPQ5gHe0n?=
 =?us-ascii?Q?oyuFpTgJiwxV7n9MoGgKl6iCc+wYMnUndcWR2ygqldaHdYpwciyAFShGfK38?=
 =?us-ascii?Q?7D9plNbeUtasIvdX6jV3RPApgkp3vAPrqZNyqvA1v2yi8fD+289eXCWSKAhP?=
 =?us-ascii?Q?Y/eOjPb53egG5aJu/2cwDTAEcwtjO5jR+hHmEYuZbZSTj5oeEggwcsDXwOnA?=
 =?us-ascii?Q?SGGOhOr4p700KqSJdnLd8itRYOjb58AS3U2tITGQ6Stu/qi9OABxbJD7dNJn?=
 =?us-ascii?Q?Qh2847ouP3IAbgkAux0TN+R2ogZoEQTwkGuMWDF+p6ts4B16AhizBwaqJfsm?=
 =?us-ascii?Q?oEYZdsekg2PLlXIeY6GrCj1CBQzBKDwbMI/cyGhCahOBXZ7t0qMpb+c+XVkK?=
 =?us-ascii?Q?Rt9lGo1KxSDoLaNpnEY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1c5a7a-db3d-4a25-165f-08dca0724dc8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2024 23:53:17.3012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bV/o/o+KPZaXJfFv46niPT3FN4XCr48c9lcg92ed5h6xiEhMN3rjdyF5P8+5bsOw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7065

On Tue, Jul 02, 2024 at 07:46:07PM +0100, Will Deacon wrote:

> > +static dma_addr_t arm_smmu_cd_l1_get_desc(const __le64 *src)
> > +{
> > +	return le64_to_cpu(src) & CTXDESC_L1_DESC_L2PTR_MASK;
> > +}
> 
> I'm assuming this is supposed to be *src, in which case this could
> be

Oh I see now, a few patches later it becomes:

static dma_addr_t arm_smmu_cd_l1_get_desc(const struct arm_smmu_cdtab_l1 *src)
{
	return le64_to_cpu(src->l2ptr) & CTXDESC_L1_DESC_L2PTR_MASK;
}

Which makes it fine, it is just a bisection thing.

Jason
