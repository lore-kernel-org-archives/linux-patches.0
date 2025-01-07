Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2071.outbound.protection.outlook.com [40.107.236.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EECE1DF75E;
	Tue,  7 Jan 2025 10:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736246895; cv=fail; b=O4kDcJimXc3B9DX64CqHRQugOUJ4gxnogw5LTqxoZNwFpisPhcGhEftmOzd8tLQT8dwxj2gNvdHs6LeCoadJRsj9NUk0mR4cskiqJwXj8+/20I3a/IDjnnkNgE6rhJG9m/+ol2vjSccSxTzanmIOXQayeK2ArWxCvP045frx2I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736246895; c=relaxed/simple;
	bh=eZBEPt2+XMTmAXr5bLNPfGv69GssE5q0N4Hn6CN6PW8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cifljIP4ndQ5BuzPbKCwqJeJcoICt9u6UprzFB1K41NCZzPCpnnbWDbprlL/JAX1zCx1X2KWF0kpfiRAxSTV4VhNuZG7Hu8bf0vnfYYlHOPBklDOjBkIJA1CAXatwWNgs1J6wLOAXAJRN/U4Jc+rsFwAu0Axd7bPR6BfPXOFcck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=eKupvBGs; arc=fail smtp.client-ip=40.107.236.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eKupvBGs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+PDoOEk+jWnEOnWSf9y+GvLZmdrqNRwyOcTr/rlMv2pzbN1KI9xPp0nFeD3dEZO8iUUY0ixV0A+oWvjsNNHltgUdHOOa5xpi+L6ONZ/6GXLN75bYehtrwQytHGmq5hgI5pzPDT6rQEdlQF92FwZGoSHKv6s4N2KUGylBBeZTPfXPYQ9AYBG9yO75SbRQr90taDyVJ25eidxBqkk62eOSx9dGJeKoiBTPbLkPRr2PCogKOuZk5+/B9KfjRisHagnYsU+GH14S5QdRTA6doku9rSzJLSFaiElDr9168vnpwctXcUW/t3a9qNJdOEAUdZRQa+rYljuKFUXcmqEPZ2Vcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ft3eVQ8wwpthKDG7v0vftXWJfAiUFUUcwzdJ5wBExpA=;
 b=Ph1C7YP5cSSjtWnEA2eeIbQ7iEkPrl7xoK7xy/3pgqQ5oMB6iqy39rxAUuF9HHAxfiOZIiiE+1w+EjSs/nty0NRuxy5z+EkVE3Grqwb9ZSbI4kcvZFquKugU+i0xb8TM2qAKYW0fkNDBrDMQhJN6bUNwrrX1qFg3aC8J4q7Zf6JQQW0TSZmHwGroLYir22bDlNY/lLdz0Y9y13AGv1dsJdADUOwesZk9y3TqYXcRYE1IlLMZmwO5lZp6YfirBOB5GJEklA4xs1FWR4WPmGfTOE0aaTNECfs9nMy0Jg9a+4d1KacT4zkwpsLs/8ngTM4iLRTmfJkVtGKqcr+YHrXnWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ft3eVQ8wwpthKDG7v0vftXWJfAiUFUUcwzdJ5wBExpA=;
 b=eKupvBGsVernhu+Eu3uxGczGZKsC9Rc2JvT9SDKpQ3WO/FQoDodCo6g8avaC5uivRkF1Z2LD31BrPFT+U7Rh9QU/A1BJJvwjgXw9oVGuX26WzS7TEPFoEPJ/0U0rh95/8kcxVe4nRLiGQw2PQTN5D16nxmeVa5o3OrXqTzVlFxI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6048.namprd12.prod.outlook.com (2603:10b6:8:9f::5) by
 IA1PR12MB7615.namprd12.prod.outlook.com (2603:10b6:208:428::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Tue, 7 Jan
 2025 10:48:09 +0000
Received: from DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5]) by DS7PR12MB6048.namprd12.prod.outlook.com
 ([fe80::6318:26e5:357a:74a5%6]) with mapi id 15.20.8335.011; Tue, 7 Jan 2025
 10:48:09 +0000
Message-ID: <f8b228c7-ca79-469e-9266-985255a227b4@amd.com>
Date: Tue, 7 Jan 2025 16:17:59 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] iommu/amd: Fully decode all combinations of
 alloc_paging_flags
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
 patches@lists.linux.dev
References: <7-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Language: en-US
From: Vasant Hegde <vasant.hegde@amd.com>
In-Reply-To: <7-v1-cf88773f22d1+39bd-amd_paging_flags_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0228.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:eb::16) To DS7PR12MB6048.namprd12.prod.outlook.com
 (2603:10b6:8:9f::5)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6048:EE_|IA1PR12MB7615:EE_
X-MS-Office365-Filtering-Correlation-Id: 71d9f789-f7bf-4774-5930-08dd2f08c664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q2tyTzhzdkdoYjdFZy9kcHdIeEJBNElkTWkwd1VJM29kTk9YbmNGcDhMRWpN?=
 =?utf-8?B?M2lYTTgvckJwVzBEUFY2ZjRvS1U3bHRSOEFSUkZGZE96aGdlU0Jwc3hCUjdo?=
 =?utf-8?B?N2RHTGhHTWJBTFIrZExpeXZGUWdIMGtGN0IvdmVDTTBLQzZkVXFIRE5xL1NV?=
 =?utf-8?B?NTkxTzhEbzFPZTR0VitrOVFnUnB4STZMSHhvZi9NaWxNZDJKcEpIWHFvUHBN?=
 =?utf-8?B?eHZHaWMyaWpnVDdlY3BZQm55SFB6RVdpQ281RlRDTDNTaVhBU2tzaHRmQVdB?=
 =?utf-8?B?bkE5bDVBWWJGc3F3M3hub0lPWkdhZFEvY3lUZnZRSkNadW5TZU5jdWp2V2Np?=
 =?utf-8?B?WkVwRldGcUNpc3lpYnBlVUt3TjhMaUR3d1BGUFpKUFh1c1ZJeGlxWVZ6YS9u?=
 =?utf-8?B?U01BaHRHRi96UlBDWUZLZDdMOWNsTXJ5TVhiR094NkxvdDF2TGdyTjYvbE9M?=
 =?utf-8?B?Tng0ZkNuUXI5Y2g2dEppZlRYSUNoQllTWWVYRXZ6WHRpZGJTbjVESmxrRmZm?=
 =?utf-8?B?RTFjNWNEZzlzUXg0U082bFZHanoxQUhRUUJlREJYNTJKZFgrNEJsV0tld1hl?=
 =?utf-8?B?VVVSRFNpV0IydEpuUFBNWTFQNXpzbU5QeDZBVTBQbE1GblVrbkFMODFGY2c0?=
 =?utf-8?B?eE9CaVNnUW94dFMycHZrb3J4M0NoZ0F6V0NZYm1DazRGU0NoNzBFZHlNSEVq?=
 =?utf-8?B?VExiTFNjRzYxcWJXVVNaOW9vWXBwdkRiWFdTNG1MMHJYcEtaMzh2K1owZ2s4?=
 =?utf-8?B?eGJPY1drQklEOE9DYVVxNlltdlROQWozdzREZGxRRlZqbjBhOHMwNG5BQ2lG?=
 =?utf-8?B?V3pGdjRGcDRjV0prdUZFNDQwSVZjY1lzR0hWMDIvODNueXorZTQ4WDd4cU4y?=
 =?utf-8?B?b29FQnVDY0dRaEVnZ2VQOVJCMHpTUWwvemFpTVBBN0srZHNoVlhuRTdEV2c3?=
 =?utf-8?B?OVFwb0lRc3VYYkw4KyttSUI3QUIrYXVOUjhtSWVsN0NGUWsvcmp3WUsxUlNE?=
 =?utf-8?B?YjVjVEtyTmY0Ly9GMWZYUDFUVWNRb3lnaXZQV0VTck5rVzU1bzJCbjdlVjV5?=
 =?utf-8?B?NjBRdjdQK1NwQkYxM3BCQVlCamV4WFQ2VUNDT2s3UjNLM2IvSHNmK0pUY04r?=
 =?utf-8?B?N252RVZ4NUlnM3I1R2lNK1JhTHh6NnJQSFdpdUVvSFl6RjhPNjBqb0NPZWNB?=
 =?utf-8?B?RFVuK25MMkt1UWQ4YnFNWHFDT2JMS2NGeEhFZG9IbzY3aDk2TEJsT1RNZ2Vm?=
 =?utf-8?B?RFlQWThFcFVrTXBsNnA5dkNUdVVESkJsUmR4SE1ESllQMysvZWVPSkpQUjdC?=
 =?utf-8?B?c3lvVmI4UnBLTGFoNGJJYjNxVnlBYjdJcnc1SDNvTjdBVHJ1N3dzYTdXZGtF?=
 =?utf-8?B?MmxqWURNY2V4Y20vbE4yc2M5TmNEemlXOGhpMnZoYkJhSis4elpVSGhjMmJy?=
 =?utf-8?B?czBpWWZhTWc5elc3K3FMQTV1bVlxNzRnWHdMRUltLzNtbkJlODBoRzhObEZN?=
 =?utf-8?B?T0NnbUVQcEVtVGpCY3BDa0ovZ0o2NFFnS3NaaFNsSXgrK2lsdzB5bWk0SFdO?=
 =?utf-8?B?akkxMndEdDNzL01xaUhlc3lLWDd5bEs4S1FhbENJYUZEREVYMC9iWXR3WDRi?=
 =?utf-8?B?YUdjanBXdzV4NjlMUDdWdUgydFI2QkZTSlllVjMxUnhlUkRGZjVNMktRN3hs?=
 =?utf-8?B?WG1YMVdYRGw4eVg2NGVPenZyT05SMG1xT3JkckloVVg1VkgrSWpRK0xBN0dC?=
 =?utf-8?B?d3NRN1QvTEVaVnVocWtTTXhEeEtCcEVzNi9zdFBsMk9GdkJ3dDZ3UXJ0emk0?=
 =?utf-8?B?ekdQeGk3dGg5V00rdmJ2L09OcnZOZ0hiVnZVeWdjVU5Ta2RidHovQVlSb1NV?=
 =?utf-8?Q?89TcrzT1DOcst?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6048.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dWJSeUtIQ0dNSUJ3UER1RFFGZjhnOGtqTWJUdmNIZnNnZm9RM1cvbnlKckpw?=
 =?utf-8?B?OG5ZQ0NOUXNkMlZ5L3JYSG12M2VtTWx0dTJlL05PL0JaOXdmTXFMOHNoM3d4?=
 =?utf-8?B?OXBxSmU1dy9ZbGluY01HcjFhUVQ0OWc5d003S3pYeUFKSlUrdEJ6QUU1TVF3?=
 =?utf-8?B?blFkbzZGNzZjajhqVzd3cG4wUTdVMWVDZE8wbjJtZXgrTFE2aTRDVVNyZ1FD?=
 =?utf-8?B?UWc5MjJCYlJFRUFUeDZxV3BBcDhPbjhYSU9OMmZxSWFuMWNIS2E3bGNkaGdk?=
 =?utf-8?B?ekwrUURUL0lwcnlxb3VCdE5yZFVSbnJzZTFFcWQzQzNzYW5tY054bmF5TmV0?=
 =?utf-8?B?Uy9QclpvWmhSWUN6ck1iN3d1Snp2Z21XTmZKaFE1UUZjVENia0pMUWVQTC9T?=
 =?utf-8?B?ZjFSWTNtQVBpbzI0bCtUVUIxUkVnTHdtOEFUbXRaWEtRdExSY2xiQlMrbGQ3?=
 =?utf-8?B?SEpDeGlGM2VzZkxFV2hBK2RQcUtKVTYzMnVXc3Q3MU5zTUM4c1pRMWxKT0Z3?=
 =?utf-8?B?Z0o5NVFaK2gyVFJ3a3hQNlpMODNKZmZDb2RCWEJpUnN4Rks5d1hJWWZSS05w?=
 =?utf-8?B?aFhtQk9YOU5iVUdKcXlqaHltcUF5ajRENDM0VkFYK1kyeUF6ZHlRNEZaMzhr?=
 =?utf-8?B?eEM2bW5sSHNvVjBOckJ4VEtvMkRmcTRoOFBBZUIzK29udjVXRGJxWjVMMTNw?=
 =?utf-8?B?Ny93S3IyT3l3Vk5ZWHlDSERLNHBDakhVUUgzbVFpcDNzNFVsNFdRMkFucDY5?=
 =?utf-8?B?ekovUk1Zb1Z3ZHN5Rm1iVUFyM2xHYkU3bW1qdDJiRFRML2ZwemthcmV0TXQ1?=
 =?utf-8?B?aUdpS3FqVGFRcHZJQm0vek9YbEYyTmtESlpBSHRCdGliVlF2c2g4d1VwSkxi?=
 =?utf-8?B?S0wzdkdacnF6Sk4rSFBZdElPaXZ2RDM3MnhZMFJObm1IOXJZV1oxQWNwVDVM?=
 =?utf-8?B?ZlRNM0FyZGxBN3Zsa1VLUndEeEJ4UDJnd3NHcC9NU3JqRTY1cEhCSnBWTkVO?=
 =?utf-8?B?OUc3Qyt3dCtDVVFLOWM1Wk1iTDBHMUxCRzdidzJHVjh2ckgxT21MVjVlWkJF?=
 =?utf-8?B?d1pkQVQ5SU5VRkJEOFI2WTZ0cEtnRmhpcy82SzJJZ2VyQTdIejRiaDJmeU5n?=
 =?utf-8?B?am5EVE93c3hyU0ZnQkFSMzd5UitzdGQ0N2dKM09QM1NyTDhyVTNBa3psakhM?=
 =?utf-8?B?SUZLM1FaV1VYNTFzUjEyNVEyYWMzOTF4dEV6MVRSV3BOR2t5d0JzMHdWbEw4?=
 =?utf-8?B?Wm5xTVF0N3VDUGkrOXFURUg2akNJTEs1MGpsNnBUNDkxSkhvVUlielBGa2hx?=
 =?utf-8?B?b0ZYYU9taTYxb3ZVNk5uQk1IZDVzOTJZMGtkREFRSm9ZSlJTRThRSEZtZjZn?=
 =?utf-8?B?SHphb2lHYUdKSXdZbjh1NkxEQXRMZG1tNzlreGtWNGNyZGp5S3VHZXpuQmJh?=
 =?utf-8?B?ais2TnVMZUdzdFBjU3JRREcvbXdMWkpHN1o0N2dDSzVsKzdQWHNEOTFXa0hS?=
 =?utf-8?B?T0x6dDEwNDUxNVNqZFlrVFlmQm4vbjFpQlRQZ2FSQ1poSTZ4c0JIaGwyaW8v?=
 =?utf-8?B?cnNpVWRIS0VtOVJ6c2FJb2pCY3RFYjRrSHlKTFNxajE0NWNheGYrOWRDdk16?=
 =?utf-8?B?d3F6Y2E2R2t0MVM3TW1LcjY5eHRzeXo1c2FvZTEwb2h3bEROdzRvV0FBRFM4?=
 =?utf-8?B?SURoaFA3QUdEWTdvczExQTAzNzQ1ZWw5d01IUWVwQURLQWpzUUlad2twQW5j?=
 =?utf-8?B?R3hWL29iaVc1dzVteU8vUGFaYUcycGFHQWhnUU1hK3FrNzFJejUyTUNqQ2Fv?=
 =?utf-8?B?RWVoRDNWT3VVQlVzb3Rkb1kvRHA4Y1h6Y2pxWGhtWGxxc3FhcEpNVXZQdmtD?=
 =?utf-8?B?K1Z1bFZRWEEzb3NyKzdWZFFGQWhZRFJlcTNHRG42VUJmcEFYa1A1L3Y3UFdy?=
 =?utf-8?B?ZnhaYzVoM1BLZUFpbURqTVNrK1ZIN1hkK3VKaEUxS00rMVZ0c0RkNWY4VGEr?=
 =?utf-8?B?NWtiNU1FSTR0U0xrQmVHRVROeXY4TzlkRkhYUGd2OTF5ZE8wekFJK1RTS1ky?=
 =?utf-8?B?eGd0S01WRjV3c3JNcEkzVEN4N1JlRlZFQmV3M2N0MTFvQTRYYzZ2Z0tVWDJh?=
 =?utf-8?Q?TqAnKkJ/gpejrwObt35wDgjWF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71d9f789-f7bf-4774-5930-08dd2f08c664
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6048.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2025 10:48:09.4961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LEcVKK56quV6D525p4Og1UdqJqG68oOgB968TXPUaAhOqqwl9v3nCB4ZCE+23Fo1uVKPzeoKdcNunU57TkSS9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7615

Hi Jason,


On 12/6/2024 5:53 AM, Jason Gunthorpe wrote:
> Currently AMD does not support IOMMU_HWPT_ALLOC_PASID |
> IOMMU_HWPT_ALLOC_DIRTY_TRACKING, it should be rejected. Instead it creates
> a V1 domain without dirty tracking support.
> 
> Use a switch to fully decode the flags.
> 
> Fixes: ce2cd175469f ("iommu/amd: Enhance amd_iommu_domain_alloc_user()")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/amd/iommu.c | 31 ++++++++++++++++---------------
>  1 file changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index c84eb3e7bd8bef..a418a1f48e7fa7 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -2375,24 +2375,25 @@ amd_iommu_domain_alloc_paging_flags(struct device *dev, u32 flags,
>  	if ((flags & ~supported_flags) || user_data)
>  		return ERR_PTR(-EOPNOTSUPP);
>  
> -	/* Allocate domain with v2 page table if IOMMU supports PASID. */
> -	if (flags & IOMMU_HWPT_ALLOC_PASID) {
> +	switch (flags &
> +		(IOMMU_HWPT_ALLOC_PASID | IOMMU_HWPT_ALLOC_DIRTY_TRACKING)) {

Better use supported_flags. Otherwise patch looks good to me.
With that

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>

-Vasant


