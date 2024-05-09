Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CA383CB2;
	Thu,  9 May 2024 18:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715280028; cv=fail; b=tbONJRxfxZIeFzXQ/2Iv3Qw6EGhDvABKQ1JezErL7q5DEhpzuFP2ZKahmp+kPsTQLigpHd+2Cn4CZ2UBsCHWrl1TSGi95QqMjBa3Ze3hOX6GMB05zygvCdDIsEJi5hqum3JdEc/ry0l1zJs6VlcKdXGhBMRNkWMFh4YC+X18TaU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715280028; c=relaxed/simple;
	bh=1Kli4ZqebTjCdXGfkoz+vrWD1JzDPXXZvgSpKfjJ8dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oSZN00Ppbc77nds9AhSycbWdFkmOF0TzLqr28urbMwc6BYUnjcau3hW2VAvKRiku9gF90MjwG3bG8IqtxbH43txZzy1N7f3u6KpEpIgp9hwuOx6WYhAUzbgsCUsfXOWj+9U5BcTPMSVVPoBvw2nuK6WI3QtOYdFoCr6Y+f3UJ0s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=nii1tQPI; arc=fail smtp.client-ip=40.107.244.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="nii1tQPI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DogbUAU75evZ7gTcQGcphi3famnnNVklxhiU/LwgeOGaBOQpoHg3weAVMGpmhH5XsCItP23quqlpEJubLM2Bwu0ZiHU5iN/viqFTIBc9AoKyGboD9Wz4n26pZvSgsgOWRammJ+p+5LrRL4dXFQV+fN4W8GRqdUoJiUll5wlxdshGlGgdC1yxm+rGBEMUoQ9v1RnomLICFykE3mrSkn+//Ro/1nLD78zgovKDF/5A8sLieYJEOMvXEJXmwPhxokpV1tDy1enm4HbI5zWTSMMMIOz4dGdr6MdTNIc6NBI0AqFwPRgehaKmewgu+lfpdt4AiEXkyVptsWjrkBkbwCHAow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/86Ej0O+6d546KNoTfwJmv8vlSmkzZLLS2BP/DaXSLc=;
 b=ThsKMTBwiNUfKuvphlKRhAryL7FlmmlDiWeM8XsiesXE7qv9vrJibvFbAz3jSDuRbhNiOEpj8yPgc/U9DsVJlRrAlDsyxoEbFmjpnbWbeKKfRLF9IB2XYhnAOQ1rnjXzZYTMO4S8ARY8AyO1HNqtbtWRursvRSGdWmMwc+m7MZTe7ERPNdzMLVcr8i18PfpwYqrIaEUKsi/UntFGoiJz3LyrVr02FBkLLP3yLu1c77p420B0b67GuilY7m8t593CqbHLuJ+8tHObJzSGanOdxJqp/2WkZ5/Eo61c2YHFLwsjiD040cIor6cG9a7UOVpkww5znrvzM8z3pdT/Q1aZ2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/86Ej0O+6d546KNoTfwJmv8vlSmkzZLLS2BP/DaXSLc=;
 b=nii1tQPIh1xlP+D6e4+WV9zz1eYHQeW6tyeQbT80fsAJS1GBUU7a2Sje+UgmORlrLkjqBybbXhKD6cFWoOM2TPxfN/7jDzamZ/BX0YHTySOYwCvkNskPmjFF9ypfgvjXzovpMbgiAx3fXuTBa4VSUG00RyAD3F67a+1sEsSgQU446fAO24tQF+ZCukG5tDQSiCYvES0cPUMZSIPSMhtEpf47lYNnUyo1CsNRQL2qSPsBWUVJ1tlGMZyiwuKiUxg8d/HOjHyQ8R6cD+p7Fbn8AJc4O+yNOQnIXeBURQp6Y0zk6gjQ46Uf4D/VwspTXNBRZ9FMP5J44yAV9eMUkCyasw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB7741.namprd12.prod.outlook.com (2603:10b6:8:103::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Thu, 9 May
 2024 18:40:23 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 18:40:23 +0000
Date: Thu, 9 May 2024 15:40:22 -0300
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
Subject: Re: [PATCH v7 01/14] iommu/arm-smmu-v3: Convert to domain_alloc_sva()
Message-ID: <20240509184022.GR4650@nvidia.com>
References: <0-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <1-v7-9597c885796c+d2-smmuv3_newapi_p2b_jgg@nvidia.com>
 <Zj0UR0fFH0ruioWW@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj0UR0fFH0ruioWW@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0118.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::33) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB7741:EE_
X-MS-Office365-Filtering-Correlation-Id: 4637c61f-1b2b-4e21-2b09-08dc70577c7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v1/sn40KTXRoYTukQ8gCKDkQFstVt4EuIEII+Pj5BRuQ2Gd891X410vEXIY1?=
 =?us-ascii?Q?zIIE28D6MWlNg7hTR3eF9EET8qb6q/Gus813pfWaQbuMqbHKEfME+6jOuhmx?=
 =?us-ascii?Q?2xVOLkfeL/1jjTrAZ+Kcl98XU53KcZLyJH+0K+supfljbMExlYrLlaS5zlG9?=
 =?us-ascii?Q?sAFlqc+9EpXJrTA2twPux80/lZ9n9Ao2Z3ZWVcMPcJDR5MQt4CGuxoY1JViO?=
 =?us-ascii?Q?LzUcDqK5nC7EvpSUGTvyLBrAUkTErNe/k8RERR9h4MPAn/8ScXyxV6HeQGTq?=
 =?us-ascii?Q?cHnpkiUTCdZwI1JpTmB6YDgSyc2AOMOfLGmeZnq3zw6umhGDSL6sPsuEc4Kt?=
 =?us-ascii?Q?HvB3Iwqd/Kuoy9CAPP1SN9KJlJ3iS7CiR0oSGkgPgdL+3U9E1gU9xrfYGzBV?=
 =?us-ascii?Q?h9OaEvpo4i8ACJz1P9jPPMyjRkD33ShsxGsBnPGKCA73NL05bZvVa0QvXyGF?=
 =?us-ascii?Q?Tx/KlMHm+AXrW3M+tV0v3Ui5kPc0d+4wUp78aSeyPXFM3N/ZeNoDVQkn6wQk?=
 =?us-ascii?Q?1wzS4MWwPEgzgvWuWZOQPzb78yQox7KCMAqZIqvllHIwz71P3N3VNAFbjadz?=
 =?us-ascii?Q?MtGToXPQVhuA4zkf2YGRLCfrk/7/cab7Fz7AFVdJdSyUwPSBdV5c2xpeGSty?=
 =?us-ascii?Q?T0B7isbyM8eyqexinIImXrdqXAU5wQlkxEdAixbwGqoFI6+uXdqa6NAphnXT?=
 =?us-ascii?Q?SGSafEFovMCQ303jx0RXqe/K3Ufq+l/yMZBnw6nl2iB37ynwMS/aJhevsaI5?=
 =?us-ascii?Q?rs1XdNbnp/IU8z8oGQ/oRPptSA6k4OV8kRxJQcHIkb6IPrUxhBWylLV70PYr?=
 =?us-ascii?Q?/BZshGPel8/3T20zPkz2wAt5QT9c0jOoqYT7TELVph9uQyGgplJlbkId4fou?=
 =?us-ascii?Q?BZVhMpqfZ7vdqwF5znjTxBwn6vWUQxNJEqGHalI2hHrvqRvuPm46wlYb3beO?=
 =?us-ascii?Q?cx5JK+nrN8qvIlSmqL+5VzAIO5EybsxZ0bTGNQ041L6P8GmaDpIbHT/KOwPX?=
 =?us-ascii?Q?l016FAGnCD9OzFczbcKtplzRFZxLsGWsbXXt/jy4o0nADTDCbRiN4rXulsAd?=
 =?us-ascii?Q?FA0ROukHY0Z2BYHdDXWkIcoqT48HvSV7pw7us248w65bzddWjQ+ss3EaYYgq?=
 =?us-ascii?Q?KCLzbBf2bM+az3G6nnU1vjEJ/P0YWwMwMFQiBfdqNn9NNR6SxXc1yy/OVBsS?=
 =?us-ascii?Q?xDqwplUzySNA8g1UebPV8pDdfkjhqNGcegupyuFaCOb5Rbp3cWXQR0PUIOa1?=
 =?us-ascii?Q?krqMk6JLltcvp3cixWIVMWZmhQTQ3WrrijsJyiF0Dg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6j+F4TmyLXeeI/MIk7H72DDRamaA6mw+SNjUqflzkZZEjiEx+uCKDZvouQpv?=
 =?us-ascii?Q?8MQVPo8o6p69l+d2duF3wNU9/PfcAZFyt3lCfBFWrQTjNVkmCmFZIrqFFeE/?=
 =?us-ascii?Q?2U8ESoP8sl8QLN+hinPUsAlOOZGzXVNHZbXxDNXcOF0lSxPHCIw7T4B9d84S?=
 =?us-ascii?Q?h0KJTBwb5tmtEcTOeh+KqXIL/Q1YnDdMwfH6PxXy2Gs5a5KkBKORt6Cn5ezu?=
 =?us-ascii?Q?k8JhFX4pCtR/AM8OhjLk+SzEhqWIYg7Pd/OOsAHMJuPcVVz0JhycYPlF/ae/?=
 =?us-ascii?Q?aOfgLnHp8GGbIOvenhBd67dXgrJI9xXESIb4Wnfjck2Usl2FKpEn0+rpsheZ?=
 =?us-ascii?Q?CMKkp1VNrLS/zI2QC/0oiNiX5V61Cl3FUqHS7taYu0pJriu4ysAqGwj/e4BR?=
 =?us-ascii?Q?Tq2r1J4F23bi3F00cszNy/bjAHgNVK7Vkf7pCRnHdJ9E+Xk1vh+OAZGujNZo?=
 =?us-ascii?Q?ZMa1+s7MDdBWLetR5sHyJleKAfEUTw0O22fhODtTH/PuCS1vJE3d0lV5kOZx?=
 =?us-ascii?Q?p/7Grd0WReGuQ0PSQ2YOAfjX0MYd4SxM8I/3od6GpJrI6EPaeIFlvR76X5IX?=
 =?us-ascii?Q?8t/HesCtl/kblsDsWPeJ8VAjHnR0akuMibxTMFH+cW4KAZCk3R2NjHfloq9b?=
 =?us-ascii?Q?VQWtcnwX8angtrZKXKsI25HgWQ2viqdy47kkP/7fZrR4iNZIurhE+B1wcHtm?=
 =?us-ascii?Q?bjEWaStpWGlZQ8tAz9Xt3GVfanSZG8ls35ylUQSpqHPWH6xvmkzgiIYIJLol?=
 =?us-ascii?Q?m9P3TdwAOID4nmPIwopM5UIf7Immxv26MpuHeqGEWpOodbvJua9ihJbB2QSa?=
 =?us-ascii?Q?9PBnifV6EkRBXgyWPbCrkFg5Y/vC0b0oSntKYfHGrfS38O9Wgx9yYBR+Efjq?=
 =?us-ascii?Q?splQzxp4ozpFDQM0MvUIjWIZm+74sifTZmMzu497GLuxCzKzwyYYhskcNp5C?=
 =?us-ascii?Q?KSRbMughet/6kZjnGP/Y/lB2DavUsjgNSmGkfei5pVF1Tp36cZ/bgNhEhFb5?=
 =?us-ascii?Q?Lo2pDF8A7FRzca6ob3SHoahQzNgJGy4UzrlN1Kc2BFrUjF5TTovx/iJCt0n7?=
 =?us-ascii?Q?VfMyxCtqaRNjOhHD0q3VUftfGx541WFgYVp8ajQ6efvcFIqZxsMxDPhU1wCy?=
 =?us-ascii?Q?RrEPty8ZpzR38MIOZ/KfXFoBUzEJC0eEjSqh+klWn0dq8FmyakX2H3OoFi5P?=
 =?us-ascii?Q?pDTLymMSIOaR4QqaY/F04Jzp0lCqR7SB5KjSB/c/8t36CACkKvbCp1vY+H6E?=
 =?us-ascii?Q?Ht3f48KcFEJ+XMJZyNdajNnVhe5pGjr11wPwXKieCrhWUil3kCrbHYxoZKO5?=
 =?us-ascii?Q?tCjsdwONQhD2xzYaR0nCnQ9mSg7Df++EmAvlb6pD7UyXomNKdMCKJT1WK1Ox?=
 =?us-ascii?Q?5gvek9tjpaAnu7M8Vm1J5RN7g3FKbMNtiRAH/uY7MQNSqw5xjuxvWgi9spCM?=
 =?us-ascii?Q?+32IiSBEwOWnOYoAGYHFm+AYcfrhvdYTMlPq664AsVMk2LmIs15MoRzrwGKw?=
 =?us-ascii?Q?CR/X12giRdHrYDhOw6KSsWXm6R+qirUeJ9SjhowgSUcEeRXe9D8Mg9Jc+Jmf?=
 =?us-ascii?Q?AFBjsFMcYxbroIIGhB/faHfFqlDmwAfhWoyoQ34F?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4637c61f-1b2b-4e21-2b09-08dc70577c7e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 18:40:23.4359
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPKwOxzbqym3BljAidV/erxW9BQ+3NAelH727iN9FgZZUNR/KScoKv7iPSL5o6RA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7741

On Thu, May 09, 2024 at 11:21:59AM -0700, Nicolin Chen wrote:
> On Wed, May 08, 2024 at 03:57:09PM -0300, Jason Gunthorpe wrote:
> 
> > @@ -848,5 +849,8 @@ static inline void arm_smmu_sva_remove_dev_pasid(struct iommu_domain *domain,
> >  						 ioasid_t id)
> >  {
> >  }
> > +
> > +#define arm_smmu_sva_domain_alloc NULL
> > +
> 
> Just a few lines above, there is still an inline define:
> static inline struct iommu_domain *arm_smmu_sva_domain_alloc(void)
> {
> 	return NULL;
> }
> 
> Should we delete this too?

Yes, thanks, this is a rebasing mistake :|

Jason
