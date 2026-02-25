Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010035.outbound.protection.outlook.com [40.93.198.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C0A17A2EA;
	Wed, 25 Feb 2026 23:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061154; cv=fail; b=aHajWtuxCTDxV8YHUgVAT12rIw2MoJ+WPljpuSQG/JHStF3BFR5x30YpetW7rmvYIiwkZWoJKLy1hs9RUk8tAnzOg1AVy47okjRjytUJOMle3YNfCbILsmBlybRx638f05JDih1uR4Fx8+6e5Y1dKz/Ax6+UD5HDwNXF7QBxoc8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061154; c=relaxed/simple;
	bh=SfT0n56mgysygEiqA+zeOD7SrQ0fEWGQPJfOwoC7eps=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KwkOR5f2wbrk3qIG6g9p/2c12taXpMumJiU09OHApl4cTPcHMnUlxD0mU3LqPy6t2XvuThP3/kaAusPlvff5v2XlyeJFEE5GtdJsjgYkGsE3NdmHfbunejqsuH8QXQdAPeCcD11UfgWn28m+Vw4Iy/2S04y2nyOl/d7/klqaiYw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ijhWvnV0; arc=fail smtp.client-ip=40.93.198.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ijhWvnV0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdEFM0PdcFvKnk+7wcHsDhvYp1z7iv+DAsviLHd5pClkmk381dkDmaiX2yuC7xbDcmlLOnX1MBM7sv6HYEH/Cp8UdL8kMFutOFaUL6CsCaaq/kijyTcppxhZehP+f6UqCulmBWOApIiF+6AqJBL3c7OGk0B0i62/J6rc6jDIaedef+UhTXggXy8vdg34ENf7NcnA0frFInwSXooYbQ8ikd8/qCi4oubnKOpI2HCfyRGKkYAnfw2veWZy+4eXXWV8Td7ncNGBZuTgutk3ByKffTHslGoTrFC2Ebk96I/U389tgmDSCrrxIYW4l+/kH+PKyX+R0kjHR3fa2p+AmEDHpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aRLbep1mAoy/9FlVi1wIcO/l+Ji5XgfNPxwedWZCHs=;
 b=fmKyXgdWaBUENeBggy1yxAtAXq4jeXBKsFApKwz5DUZmmpqJCvNs6cMesygR73k7/PBSjx9KYyDtl2iYjInyCrzcdyg+hLYnk3nPgL78rP5S9ATPUNjPXnVPynqT/ZAlNYZUMJbzcNkgBAtGXvg7sryf/uYLLOcF6Rmyf9cJYgM2TkKEerqXlXQSgYKVy7UY2pDTiT/CLUy0OCMp9gNT8u+qgiMyVkOKWA67s+wKULg3dKpjzjvd/cei88cjg54kS41OOd3sRe146Ce3Dg9INEWOYCjw4Uwz7IT5mOPVchGYSK+MyqH+i9ORnRJnPyKyGjVHK3LOSLLVn1DuHJJr4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aRLbep1mAoy/9FlVi1wIcO/l+Ji5XgfNPxwedWZCHs=;
 b=ijhWvnV0eYPBRqrqmflkuNhu9Lev5ahJHSlor78tIbS6uVa2dJHqQ03it2zZHJzAQNmHdvl4Mds4dNozTzgRaqaiq3YMOzzPCOP662fwmpzMYliQj82IDhG7QEbCa65q4+kC7ghDhZCcQ0ST0tqdKTGZv87Z7kcPX8L9jgkDjG0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CH3PR12MB9194.namprd12.prod.outlook.com (2603:10b6:610:19f::7)
 by SJ2PR12MB7868.namprd12.prod.outlook.com (2603:10b6:a03:4cd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Wed, 25 Feb
 2026 23:12:28 +0000
Received: from CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee]) by CH3PR12MB9194.namprd12.prod.outlook.com
 ([fe80::1e6b:ca8b:7715:6fee%4]) with mapi id 15.20.9654.007; Wed, 25 Feb 2026
 23:12:27 +0000
Message-ID: <bc6817bd-4aa5-4033-b89d-88fef637de65@amd.com>
Date: Thu, 26 Feb 2026 10:11:56 +1100
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH v8 07/15] iommupt: Add map_pages op
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Anup Patel <anup@brainfault.org>,
 Albert Ou <aou@eecs.berkeley.edu>, Jonathan Corbet <corbet@lwn.net>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 Justin Stitt <justinstitt@google.com>, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-riscv@lists.infradead.org,
 llvm@lists.linux.dev, Bill Wendling <morbo@google.com>,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Miguel Ojeda <ojeda@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Shuah Khan <shuah@kernel.org>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>,
 Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 James Gowans <jgowans@amazon.com>, Kevin Tian <kevin.tian@intel.com>,
 Michael Roth <michael.roth@amd.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, Vasant Hegde <vasant.hegde@amd.com>
References: <7-v8-d50aeee4481d+55efb-iommu_pt_jgg@nvidia.com>
 <fc4f0354-4e6d-452d-abfb-fe24e53253a2@amd.com>
 <20260117154347.GF1134360@nvidia.com>
From: Alexey Kardashevskiy <aik@amd.com>
Content-Language: en-US
In-Reply-To: <20260117154347.GF1134360@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SY5PR01CA0095.ausprd01.prod.outlook.com
 (2603:10c6:10:207::20) To CH3PR12MB9194.namprd12.prod.outlook.com
 (2603:10b6:610:19f::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB9194:EE_|SJ2PR12MB7868:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a3b594b-c6f6-4184-9bbb-08de74c357f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	Gt7jCSRSzNJRrVJS4u+8xYQw9hEXJrFqpdYH+FURSkZonbmXBt29QsUXShVX7a/TyP/iiJzOt0gxrg9N4P4Q6T6NlXmKmAwt63GvKiA5YgSNcqqxPfdMHdCli0oj1esZXqVCgR2mi7Ts4R6isc2wK6duZFzcf8RqnYTE4bcsnT3cRCG0aGkhVGH02t6J8fdRH6bJacB2MEAbbq7KJOpOipMbHb9Jqhj5pO2yYS6capi6f7+GX4dZN2XWQGB2P3uzfKjiiI5BHh7d6LrGWLhudQdohD8NYUEWqSm5ZkP839PLF2M8rQe3nTBEAXgT81iDcTHfhswbqr77Z2YJDoHz88ys9J9nIuaqSrnBr9tIL55SO8v/grKOd+FWV0gutovZ7+7Z9ekqBPrqsZEcdw+CFxMbAtmk3hfOlxKVcOrLE0ZsA6uwpciczCDkk6DT4ofCgYbcXp4sYiYaEP5LUHXHXUcBzl0Xncf8NkevpamUdU53W2jCJpbAnFQbt5jczZvM1Xs2t0zKBHEadgIAEye3/uLHbphtUohvIwVewArhTCkwIJgo/JSMNCraSwWtIwuLDhRxpKwQwgpl03z+3nivTXmcDb8iixcLR13juIpRgM4dl0qr1jR3zEfOh2dY59o/Hv8VNj9Z2GyVcm4hR086Wq+AJKkGPHR7agtotXuNFEugs6YzcREJkF32quY3cW/jmN8nZa/xJUIRwRDzP0LH7aUZqhtis7Id+jGyc7aCXOA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB9194.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmdsV0NIZmFORVBKUjZBVHVoV21oenRxSS9lMEcwbzlyc3NQa1l3bExKdVBa?=
 =?utf-8?B?bWJmMlUzT0M3RTVac2diZkJXZ1VyNTFWSWJIeWVYay9UeW43Uk1nQ29BY2pS?=
 =?utf-8?B?Nk5vYVlJYy9mNmVJRkx2Wmc0ZXl3MENFRlV4UlNLaUlZVzVBWjBjY0x3Ris5?=
 =?utf-8?B?SzFZY1JpRlp4WDNRZHE0eXQ1OXE5eTJvY0FGYW1YeTMxM0JxVG1OL3pWYm9i?=
 =?utf-8?B?MzFmck5zRkZtdklNeHZYK3F0eXlhSjd2S0pZWGx2ZVhPNnBIZHVVcVAwSHRl?=
 =?utf-8?B?azZkcXBvc0lMNzVVMkRBRldYVlJHYTN4S3NKZ1VLSGVJaE1hQm5aRS91WTJV?=
 =?utf-8?B?czBPbFh6Wm5tLytpQlZ6UWJPQ0l4N3JEQTliR0ljRFc3RlE5V3MxNUFvMHFG?=
 =?utf-8?B?U3J5M0RrU2pvb3RBejN3WlJpbEpodXRReTE2RTQwNUF0ZFRFci82WmlGNmdD?=
 =?utf-8?B?VWlQb2JjTzNDL2Y0WVU5QTIxcG9MdkpLaEJ4UFhUK2JKY2lqbHlqd3hvR1Nq?=
 =?utf-8?B?RXZLclJvd0JUNDJFRERSZTZySjhCY1JuNjcrMk9SMncxekJjZjBUU3BHVmRN?=
 =?utf-8?B?V241YWRGaXV0WC92b0cvZ05XNUpOUHRsMmg1c21xNHVuNER0dDVyV1J3aG9R?=
 =?utf-8?B?RXlOM3hsdHgrVTJlL1pUTHBqUlZLY0cwVmF4MS9ra0xabVVSREM1Q0ZsSE5k?=
 =?utf-8?B?TWF2ZWhIUFcxTWU5dWJEemZEYWMzVDVpdktXaFVwWDFpdU1uRnBQRkxTQVRY?=
 =?utf-8?B?NVpyNVpRVFZPYkg1WVh6Mm81UUZvMnZwNTNqdG9jc0YxRTBaSWQ3cmtBOE1z?=
 =?utf-8?B?ZVI0VWg1SFJoMmpLQUw5cXQrTVJGS1VuTXBDeHlpZC9lM3pmeC9aS3JYUVZ1?=
 =?utf-8?B?dHJhZW1kZEYzMmkrelpDeDlocTh3QTNDejdleUVOa0gwdDZvNS8vdWF5VkU3?=
 =?utf-8?B?di9KS3RJMUhZSUdUQzV0dkxjb3N5dkF0czh4bWRodEJTUUovUGNzOVNGYUIz?=
 =?utf-8?B?eVRuS1lnQTBCdWwvcGRUZ2J3N0ZWOUxBSTl1MExGdFBUM3RwWG1UL0NvZnVL?=
 =?utf-8?B?cFJVbVJYczlyYzRaR2FhZGRMWEhBNks1Y1d2eWd1eXNCTHFmSmdDdVA4TDZp?=
 =?utf-8?B?SW5DUGM1cWJmdU9EbGlwVmlDcTVQN0hCV2xNWHlUT29qZXpLZ3paUjIwWDJT?=
 =?utf-8?B?empYUldrYnhURkNmbXBKb0JQVnlNWXlUbFlMdFhzQzBnRXBRTzFxRHo0TE5a?=
 =?utf-8?B?VHBEVnA0NGdCRlFqYSs5dncyYWtBMWE1bXpmVllhamlJMkl1blNjNXhPYVNr?=
 =?utf-8?B?WVVpMFU1TUNjRitDVVY3SDdzR0w4UzNROTVFaTlXTHp3Z2RXVEFsdGpqR1Vz?=
 =?utf-8?B?REhCWjV4cHlleVBxdzc2ZnNQVGx0VnpJVXBFZVdYb3Rrdy9OK1pRK1pSMVFC?=
 =?utf-8?B?b2xscnpWdlVxeG9KdklycXp6bERyVW40MVFDT2wrOHoyMnVJREpaRmpTMTlC?=
 =?utf-8?B?VXJTWFdRa1lyaFllWWxBeXpLS21ERE9zT2VoTTlpQVBTR05pa2xTUzB4V1V3?=
 =?utf-8?B?cmg2aFFKVHM0THVtTy9McGdybERsZTBubmFac1FGTDNkNEFlNXV6V05QSDMw?=
 =?utf-8?B?TzA2bENrQjQ5OXZYemgrQ2NvU2hjMnA2cFZrSDltSy8vdkVRck9PdUFTOGZq?=
 =?utf-8?B?S3dJYTdrWHcxZWZTNnArZUFmaVZYZllIamZKS1lWT3BjTDNiY28zVVpRUlVI?=
 =?utf-8?B?dGxVaXlVcEVWZE9lYkZ6SUc5MzJuVG9NMjE3amVGNzNmYlV1dEtibmNZd21D?=
 =?utf-8?B?TWozY2hVclZvblFZb1ZWTzR5UjZZczQ5eStvakJKQ2s2RmRzLzR2M2NmdFM1?=
 =?utf-8?B?WmV3V3dTRm0wcFptc0YwcmszaGpmSFBLdGUwT1dFd0QrSlBVOVNnM3N3d2Ix?=
 =?utf-8?B?WTgxN3A2UnhVeCtMSlYvdzFKcXFMT28wN3dObjlRdWFkRHNtT0xldld4TGlR?=
 =?utf-8?B?S1VyUFA4Wkh2OE1GVFNXTld2VDZvaENYNmJDZUxqMHJVbUJwbFZ6dGlNdm5J?=
 =?utf-8?B?clVsMURvb2VlbHY1QXpKb3c3blBscEh1OGNwbklud1BySWQ0NkZML0lta1h3?=
 =?utf-8?B?K0lSSmlSalNFOTRjdGdSSTFDaE9kZTgxWm01dW8yZlVickVyUTdoTVVOT2RZ?=
 =?utf-8?B?d3pSeXJjWDhNMTRhWUxmTnNhbkNTb3FxWHhiRnVsRW1HdmpSMXh4SThWbjln?=
 =?utf-8?B?eVRjWHNpbnRFR0p6amI5WUdLUVdoQy81aGlhaS8va3hSdXNJUWNqSUVkcVpR?=
 =?utf-8?B?eHRRRHk0ak1TdHhzT3N4c1pwajV3MnFZY3FYOHZIU3NCQVVJTk5mdz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a3b594b-c6f6-4184-9bbb-08de74c357f6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB9194.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 23:12:27.7939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UhK9gQBr9H0gJWCy0W9DyLayz/cE0two//r4REsLZ54Ak8fqK94csR9eSNuK+hGlI7TBkSQPN16mXmrEKalCug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7868



On 18/1/26 02:43, Jason Gunthorpe wrote:
> On Sat, Jan 17, 2026 at 03:54:52PM +1100, Alexey Kardashevskiy wrote:
> 
>> I am trying this with TEE-IO on AMD SEV and hitting problems.
> 
> My understanding is that if you want to use SEV today you also have to
> use the kernel command line parameter to force 4k IOMMU pages?
> 
> So, I think your questions are about trying to enhance this to get
> larger pages in the IOMMU when possible?
> 
>> Now, from time to time the guest will share 4K pages which makes the
>> host OS smash NPT's 2MB PDEs to 4K PTEs, and 2M RMP entries to 4K
>> RMP entries, and since the IOMMU performs RMP checks - IOMMU PDEs
>> have to use the same granularity as NPT and RMP.
> 
> IMHO this is a bad hardware choice, it is going to make some very
> troublesome software, so sigh.
> 
>> So I end up in a situation when QEMU asks to map, for example, 2GB
>> of guest RAM and I want most of it to be 2MB mappings, and only
>> handful of 2MB pages to be split into 4K pages. But it appears so
>> that the above enforces the same page size for entire range.
> 
>> In the old IOMMU code, I handled it like this:
>>
>> https://github.com/AMDESE/linux-kvm/commit/0a40130987b7b65c367390d23821cc4ecaeb94bd#diff-f22bea128ddb136c3adc56bc09de9822a53ba1ca60c8be662a48c3143c511963L341
>>
>> tl;dr: I constantly re-calculate the page size while mapping.
> 
> Doing it at mapping time doesn't seem right to me, AFAICT the RMP can
> change dynamically whenever the guest decides to change the
> private/shared status of memory?
> 
> My expectation for AMD was that the VMM would be monitoring the RMP
> granularity and use cut or "increase/decrease page size" through
> iommupt to adjust the S2 mapping so it works with these RMP
> limitations.
> 
> Those don't fully exist yet, but they are in the plans.
> 
> It assumes that the VMM is continually aware of what all the RMP PTEs
> look like and when they are changing so it can make the required
> adjustments.
> 
> The flow would be some thing like..
>   1) Create an IOAS
>   2) Create a HWPT. If there is some known upper bound on RMP/etc page
>      size then limit the HWPT page size to the upper bound
>   3) Map stuff into the ioas
>   4) Build the RMP/etc and map ranges of page granularity
>   5) Call iommufd to adjust the page size within ranges


I am about to try this approach now. 5) means splitting bigger pages to smaller and I remember you working on that hitless IO PDEs smashing, do you have something to play with? I could not spot anything on github but do not want to reinvent. Thanks,



>   6) Guest changes encrypted state so RMP changes
>   7) VMM adjusts the ranges of page granularity and calls iommufd with
>      the updates
>   8) iommput code increases/decreases page size as required.
> 
> Does this seem reasonable?
> 
>> I know, ideally we would only share memory in 2MB chunks but we are
>> not there yet as I do not know the early boot stage on x86 enough to
> 
> Even 2M is too small, I'd expect realy scenarios to want to get up to
> 1GB ??
> 
> Jason

-- 
Alexey

