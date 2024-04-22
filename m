Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2057.outbound.protection.outlook.com [40.107.243.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7530B14658F;
	Mon, 22 Apr 2024 13:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713791380; cv=fail; b=tH8e67u24MX4Rgy9M0MW3nBZRw1TLv9Cl4hQRAiZk1bA0nPppeBfQxw7TOjxYiVKxHyXsxgYnJnFw49/ydmboOEAz/uIMMGhjTHmUAJfJjHUgQj83W6ui0uODc6pPF20l/47vWrBeqPYXWuTPbN4dPP8xzwlWlmvAtGCnPiwjIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713791380; c=relaxed/simple;
	bh=DbblHIFqBWfiItsJtiH8eU0NMWoXlQnwyH5VPRnY7b0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S/jq2hjedCibWlE1gEENAaM3cFrjzoEzBFwDAXHtcVXRoyAQXyWSsb7LGlUKmJfMakvKNwjwjZ0vUpIzgCOVDg5veu8zxDgxIv7MowHNvk6GrclLeYriSBoYaqXAJf6UGthTysCxOvNca4rIkZST6rXSkTseI+ntoScVFnT7ZqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rf4bBuYw; arc=fail smtp.client-ip=40.107.243.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rf4bBuYw"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBun6Od22XPgioqLIgQIqntnCHW63SPA4TWp6G3cbjuwqq5M4znEcqRwoqA7gAnWiqmfbul8wEaiaTbdnQW0lQh1ZEYadSvs4JP2vHYZgwHEBIyQXQFU3L7PQT8LqHCvE9aqfIYUS26yj5CYqKe5RnP9OCAA0q5bD87x9TprE0vAxQYdRGLwqFx3duEzT/5gdtzrvqeKq9f/DcJO+C1Q4saL8BysYyF1LAC3GMT2NWSWUX5ihjezAJt/9wOqhZo3Xva7/06ZyBNeon98ThvxhCqUu/iumj2BQibltf/qE42XgqamceRp8waxz01w5ZjCA+Wi7/6r05RCaR27SHmlVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F7f4pufTrMqv1qc8MuPsyH6aYamL36jYLP5Ecaio3fw=;
 b=BoJgfhdEZ6YRgrsAfyJv5DiX/SffuuHXsfr8s/OGzyZY9eujZXnAaJ7Z4jsUUZUCZ2ckEVOdYgCP/LbIpOMaftEU8d0agZuQuJNC+cjLi44NHT6uAVPqOQm8webHxtRfPLCPQ7sqi7/W882uyc3+y81oSfrFSWy0fjQ7EFiZs4quqoQNd1BFq84TLd2SGlg4O6UGMJzxsjmg5gZeVPlILF1etpjuMGZWoEZMAzwS5nuK2JqMUl3Ee3IHxyZ1dVMWRaCMBHH2RIG4VFqRNI3cq58jBRS75WLOsGqqfizN+zsDCol0e55bcQrFhVbH0OQeUGQCer2COds6F8scN53W8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F7f4pufTrMqv1qc8MuPsyH6aYamL36jYLP5Ecaio3fw=;
 b=rf4bBuYwdlYKMkZGpve/LzWKr2Dw+ttpWIcbahm6wih/ivENPgb1IqH9gr2cLmQktrefK2gICgFMR4FubFoD/HZRljU69v8iQzjRsxxSe+Y2nXppx6ImTZWMENGwJ/s7QxPMWs1aGeDTgPqgfU5M56uYEebsyaFTLOJ0kswq5yIaEcWxwndLnQeuO0A9ZxtyvfycqTFBNlBuKqDhCa56WNKXSfFE3/Ai87BiMk8GExgF7qV3r1m1R7Nf2PR3R4/8P/eNB6DRFZdmdJWl0eJtS0I52RTIYHur25RfFea+AGbS8BEf/4dXddiMNvXp7O3B47V8zPO/ud7lpKm4MwlOJQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Mon, 22 Apr
 2024 13:09:35 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Mon, 22 Apr 2024
 13:09:35 +0000
Date: Mon, 22 Apr 2024 10:09:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 1/9] iommu/arm-smmu-v3: Add an ops indirection to the
 STE code
Message-ID: <20240422130934.GA49823@nvidia.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <1-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLb6K6mlNa4wwMG@google.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiLb6K6mlNa4wwMG@google.com>
X-ClientProxiedBy: BL1PR13CA0443.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: d9cee3b8-e684-45a9-c0a6-08dc62cd751e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NE52dXVha3VTbWhjYkh3WkFNaHoyRUVIMnF5YWFFQUxMaFJTS0hsamZ2SGRj?=
 =?utf-8?B?MTJnOHBQVnhPdG03SUZNTjhBV1FkSFR3YWhmSHowZGJLdkplYlNBZ2FTN2t0?=
 =?utf-8?B?UWJ2RUgyb0hCdVdxY3JxeVZFMVNKZWQrL1d2VVdpblBDUS9Fc3l5V2xGNERw?=
 =?utf-8?B?V0MxcklTNGMxWkZJL2ZrUFNSM0t0cmhVb0d0ZXpQWjdvckh0aE9BZkZDUmxi?=
 =?utf-8?B?NG9lOVZKTUpKOEQ1Mk1WOWtIZ2I3Szc2VmZucVZYNEc4bHo0d1lpM2ZpbEY4?=
 =?utf-8?B?K2h2S1dnMUNRbHlGMGVOczJaWmFYc0hsY2tjOTVUbFo4OEFTZEJYYU82eWh2?=
 =?utf-8?B?U0QwSzMzaFBQZG5PMk1kcU1zRmI4aUJyWjZwY2p2aHNIUUFDdS96Y1p3WERi?=
 =?utf-8?B?TTFmTi95Yzc5VkpIL0Mrb2ZFY2RBTDg3ZEFxTFJKVmJFVlNUWEV3S1d0U2I1?=
 =?utf-8?B?alY0SVNULy95ajQvMXpXTUpXVjdEcGtuQnFRL09MM0Uyak9ISERzbUdrRUlk?=
 =?utf-8?B?blczbGdzamNJOHJCZCsrOEw1NHpQNlgxaGRUakxtOU5oNHNPbGRObTJmT2x0?=
 =?utf-8?B?c08yRGk3VW1vU1FuZkZNbnNJMDM2MGlQS0xlT3VCUWxiWkhONGxwUGVSSUQ2?=
 =?utf-8?B?dVI3NGVhR3ZzZGxDMTA0alhSQlhwQ21IZzBEZTFEeW9yK3UrQmJzWERsbHI5?=
 =?utf-8?B?SXpOZzAyVmgrT3RqVm5ZZG85LytBcDAzNXllU3hhSUYxMjJKWldPeFBFUFdG?=
 =?utf-8?B?OHc2TS9QUzBmaEJMeXhtOEhsUkIvQmE0QzN3cnBMRnZlSndCQ3ZNYWJpZU9X?=
 =?utf-8?B?VTdoMmlwUnpDZVcxWHcyVVhMb2IvMUVBa2NadnVvNDZQZlJZMmRiZFlWU29X?=
 =?utf-8?B?R1FCRWl4eno1djFWd0VEUHN0TzlFcVkxQ05kQTd6Z0pKa1V3VENjTEdZVmZ2?=
 =?utf-8?B?VFVLeDl0Nnc4NlgyTHVRQzNlMlZDT1lwV0cvcC9sNnVLRkxPNnRoeENPNVZJ?=
 =?utf-8?B?bWloTU5VRUxLWXVtMUVncm5uOVY3RzN4QVQ4dHJ3dEdVeXczWFlEeVVyR1Ft?=
 =?utf-8?B?eVpSS0t2ZUhXaEtueEdBRld4eUFWUkJ5dFhjY3NXaGk2T01EbWRteFFmcHJu?=
 =?utf-8?B?M0xJalh5RGJMMGdBV2xZWU9wMW8rSEE1Rlhqa2hDcGFzRVp5cDdmMERWVHFz?=
 =?utf-8?B?eXBHRlZkMVB4RnQwUlFEdS95dWNjaDhiWHpQUmplT3VSZ2pndHZ1L3lRUVBB?=
 =?utf-8?B?bWM5bnJhNllkaUlwYkN6VHBPUTMwQ21PVGpLSDQxOE9hZ0kycFhNQTNLZWV3?=
 =?utf-8?B?Yll2K05xc2QxbHhWM2VYWHZDbEFEUEFBNDZsUFVySE5ST2VRaWYxWVBRRXE1?=
 =?utf-8?B?T3FGVmNRYUFVTjZZQ0dyMkp1cW9GWXZydGR3ckJYOGVtOVhUcWhKdkJ5UFRW?=
 =?utf-8?B?NDdBeGh6UVJ1MzRJUlNvQmJBV0R5UEkxOVNCYWVrd242VzdYMEd5ajdLbkwz?=
 =?utf-8?B?VC9Lc1d3Q3YxZUVkYmdFN09xSXh1dkZ3eGtpUXhXV2E0a1haM01raGtYZnE1?=
 =?utf-8?B?ZmpzeGNWSWFVMG5UZi84OGVGMEdFVFdWYUU2QVROaHpaelVTT3dlbjVhY2dL?=
 =?utf-8?B?VExWVm1MbE5BWVg1OHlNQndmamk5eFU0dGVxeUo4MjJmdFBITHFRYzYxUEVy?=
 =?utf-8?B?L2dxZUtoVk5hZFVWb1VhNUJvVXROQnpzM09mQXlsSzBtRTFiYWRjQjZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Z3BWdVlUeXZ3dHd2Z1VzR1BUTFJaMUJnWjVqR1VTejBPU0U3d0VYcUJKb01H?=
 =?utf-8?B?dktqTVlyOVJROHgwN0FQNTBUV3JyYW1HWXBDTEtuZklEUE9lcm8rUEpWdi9X?=
 =?utf-8?B?R3ZWdnFQdUNRb2NXL0lqd3BqbGgwbjRIdC91WFgwWlVUMTl3SGtqYkJqMmR3?=
 =?utf-8?B?eGVlRHJPSlk2RzNuN0x1VGszOWRESXVEU3ZUQzY0WjNlMGZkU1ZXZ1VPZzJK?=
 =?utf-8?B?TURON0tsMWdmN090WFFnY0xzbCtTbFhCMWNIVE8zTVMwRGFEQXZYZW1uL0hw?=
 =?utf-8?B?QkhJM0RLNmJLcE9LQUQ0SEk1VjJ2REV5cUM5emRodGtRelljV3NGOFhEcVZa?=
 =?utf-8?B?RnZ0Sm5BR2h5MG1FWm9hNmpYMk5VaXZSOTM3MWdTYTQrNXk0cWlZeGxaa1o3?=
 =?utf-8?B?QVVXVkljUGJiY3ZiUFN4eFFnUkovMlp4NFdVNW5FOW5TWWh5QWtJaUpLWXZP?=
 =?utf-8?B?RE9WWjBvTUVSMll1b0dVRnZjaGhnOTg1c1VySERwQ1NCekxEcW1iK1ZIRnlU?=
 =?utf-8?B?RWdBbUVyNDJOcm1MZUpFM1NYY1hCUHpMNHdzeGVUOWRFL2FsM0JoN3NOajVN?=
 =?utf-8?B?RnF2S2FWcWhWcng4TEh5Rm9VeGVmekFCRkpPVVIvYWllT1RQakU4R3hjYVd0?=
 =?utf-8?B?UlJnMjYyWFN6MkhYSk94dGMxVU91c2hyWUdQb0xxMWFUWVBINThHQW1PRXNl?=
 =?utf-8?B?dEorMFNRWWF5dzVKK0FHWExRSFR1UmtxblNhOE1sK0ZZT1JBQUg0TklaOE5t?=
 =?utf-8?B?dHd0SDVRdlNDMS82ZzNkUkx5K2lFTE1vQlVZRngxbGdPR2czaGtNVFk5UTRK?=
 =?utf-8?B?cHNacUVzcDlaUVY3cVd1NVdQUnJoNElHSmtiWnlVZ3RoYXFxQXpUSzVWclph?=
 =?utf-8?B?UU0yZU5xQ3VrWWMxY1BTVXVzdzlmLzZuR1haZ1FhT3dtR09qYmQ5OURUMDNi?=
 =?utf-8?B?UEtkU1lzVStyZThlTytWRkl6MS9lSTVHdzY1cUZQMGxEQk9xZERBWW9mbVR4?=
 =?utf-8?B?VGpCdHdPN21kNDBwaUF2bHlCbklrUEJhVCtUUTBVN0ZmQTZHcnBkVXpMTVg1?=
 =?utf-8?B?MEp3cFU3bjB2a2puWDgyVlVWNVlZQ3MvRWpOVWdhWGJhSjl4dUlOTW9IaDJJ?=
 =?utf-8?B?eVBaNnFDMElsR0dmTWMxTXYva0xTeWVReElETWx4a241a1NiVzJkZ2txTm01?=
 =?utf-8?B?Yng5MjgzdjRCSWFVcTJTT2I2WndjNGFmdGZlNFNrQ0NMOHNCSjNZa1BONjQ4?=
 =?utf-8?B?M0drRExwZDZrVjFKV0FXdXJJUzV1YkY3eEtnV28yTXVqTllHMEVxNHBCZm9q?=
 =?utf-8?B?KzRjaGZPck81aVoxYm0rY0xEOXpzcHJ5SGYwbC9HeUpQdU4vK3g1V2RhWGFn?=
 =?utf-8?B?WG5qQWpFUkNMU1plUVQ5Zm9UNEVYcHBhN2VXRW9CLzkyM2V0QXE0aEVTcEx1?=
 =?utf-8?B?cEozSHVvcCtVN2xZZGMwMGE4cTZacUo0cmI0RWZtY1NHWWRwNkc0QWlCdjFU?=
 =?utf-8?B?SFZsVVFYcUFIMjRpaDNuS0VPQm9ScmVOa1kxRjNXR3ZYMVNUYmlDSmRnY1Jo?=
 =?utf-8?B?M2o3WHJBNWRScmh6ZHNvbzRPSVlpRGFvVnNKMnJmcjhRa3JkWUNBWVROaklr?=
 =?utf-8?B?dFd4TUdaUnFmS3RERFV3M3E3Qk00VG5UY0lzV1pZWitydzdrVEpyMHYya2Rm?=
 =?utf-8?B?R3JtN2Y0ZGMrTXpBWncvRlVmREQ1eUw0VnJhdU01dU9DVThMYk1OZ3JEQTdM?=
 =?utf-8?B?Yno4Q1pSMDdNdzVTRmgxTnNmdmM2YlhrS1VSY1dDbERTK3IvWWNwZi9vRGZi?=
 =?utf-8?B?SmFwYThtbWI3Z0xCZ29iWHJpanAyNmJpQVJzZ3NMVkFwUEFpSjhnZ3JKWHR5?=
 =?utf-8?B?WUVFK25aZS8xR25sNXNOKzB1NjFaOXNlVHE5TFgyVFdtOWFmcHVMNzZLcUxE?=
 =?utf-8?B?R0Znem5Va2lZZWVCa2Zid21iTVNBcGs2T3NWa2V0MDVhMUxoRXRKQnRsOGM0?=
 =?utf-8?B?VkdCbWJTU0ZsNUU4ZjRZdG50Q3YyajdPUkRhMHd1cGF2S1pjY1ZpUlRPWkNi?=
 =?utf-8?B?V0tVQUZiTmcrL0pTQ2VnNUxaOHBYdDVXTUNiaDY0MDIxeUp1UnprMk5JUll6?=
 =?utf-8?Q?6VIA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9cee3b8-e684-45a9-c0a6-08dc62cd751e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2024 13:09:35.4446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c+dlwq26oQXaOfkzIYYzF/RDA7IM2t/0C4clf2HzmJg3PMHN3XVbfuHb4XsNrveh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470

On Fri, Apr 19, 2024 at 09:02:32PM +0000, Mostafa Saleh wrote:
> >  	} else if (used_qword_diff) {
> >  		/*
> >  		 * At least two qwords need their inuse bits to be changed. This
> >  		 * requires a breaking update, zero the V bit, write all qwords
> >  		 * but 0, then set qword 0
> >  		 */
> > -		unused_update.data[0] = entry->data[0] &
> > -					cpu_to_le64(~STRTAB_STE_0_V);
> > -		entry_set(smmu, sid, entry, &unused_update, 0, 1);
> > -		entry_set(smmu, sid, entry, target, 1, num_entry_qwords - 1);
> > -		entry_set(smmu, sid, entry, target, 0, 1);
> > +		unused_update[0] = entry[0] & (~writer->ops->v_bit);
> 
> arm_smmu_write_entry() assumes that v_bit is in entry[0] and that “1” means valid
> (which is true for both STE and CD) so why do we care about it, if we break the
> STE/CD anyway, why not just do:
> 
> 	unused_update[0] = 0;
> 	entry_set(writer, entry, unused_update, 0, 1);
> 	entry_set(writer, entry, target, 1, NUM_ENTRY_QWORDS - 1)
> 	entry_set(writer, entry, target, 0, 1);
> 
> That makes the code simpler by avoiding having the v_bit in
> arm_smmu_entry_writer_ops.

Sure, done

Jason
