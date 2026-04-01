Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013073.outbound.protection.outlook.com [52.103.74.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF7B339856;
	Wed,  1 Apr 2026 06:43:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775025804; cv=fail; b=ZP51rl9uuFvuJ75/FMR8L2kJd1DjA8JHJndP9Fslz+am/5BiW0rIMDrEPtRK8y4JNBJARHoI00vud7R+wOa9xJNfm2mtsRENdJBu7ZdyllrkR2L8sJUt5DB4h0fd2h5K35rK03+Q5tHCkPsuoPPlPFW1a1gifNF8kUEPkykqsLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775025804; c=relaxed/simple;
	bh=QNDFOWSPYOkzf0IvuUTZn0OisdzWTQfVO2MEYKg9eHY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UMms2AaSsIGuvQ8+WZEDEcA+JV/4Va063DREh3AK8dkgCEPFyWI1ejS3oYS4OgihjsxsLoHeE0QC669iHTiWOng93MCuipl3dg/ZoGxxWo9vJ3Glc0co1kbMeyrNnjveoo53hlIDjIlyv7LK8UkBj6yaXcJayfkcfK1Fr5Hv0bQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=i6vGWZMx; arc=fail smtp.client-ip=52.103.74.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="i6vGWZMx"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sgr5sPykHuquHiwAV6n9llkeoS8TKfqpS2QnIlrfhs5+50cFAqTlYsNzUzjukcrG6Z9+JtFXuXsMstrmqfCkMgLPBk1KfWppSoQlUB1TQ7ibk3pLaA4pgMubEWyIypG4AIyO1bgG6rocdUDwkfERUZVhXn/FPbIuiLIVOKXeKlOLQb13hgmA0+vga4mHikFSJ4TFhLWRrlPHbk2XhUzFeflUpUVsVE5EcTBcmQgrzJrsHNeMTr3N19LUUf1m9H/U8P3oqQTWo01ueIc5CYEPMwTvw5va6VKPn8bdwyIXbwvVWo6kr2XCSFZShxTLvcue1jWDvNtevYzT+hej3bVEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lBRjgUXAvPIeqIwV0rWxlzZ2CiGaqRLcMPYY8vPQ6Q=;
 b=ThkDmz9vXjllq/L9Hm81s2Tayjvx7jd4LGAylBmcYjLLttDxJisjqSMYdhJObV3++hvAsvlC0/Yw3o0zmJiSN5rbSk+4OMnymUitu2pk0VZ3TsF6AtmKsGAYjbOyVsKHPL1WG/X9az9CXPzDgiVGn5uEDKlohzT6I+T1RgFFk1K5T/Q2Wx288qWXT4vb6jJOM+aE4F0XfpoZzTg4LC9gFUjwxViZvU28aBIMT9Z1b1S/DylwhVzSS+uRLDT9/UjoSKt9SjvDojwonRai6ppSOrwybATA2xthvUz902i63lu93n8SH9V3FhDMPI9PR2O50lNZTkgwW5mQ3RiqRmUaKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lBRjgUXAvPIeqIwV0rWxlzZ2CiGaqRLcMPYY8vPQ6Q=;
 b=i6vGWZMx3cyNQBJF/Va18M+WGS/qbcUPbr5cFPZ0booODGdHJv6WKvAR45XE8vS9spaG3eafjFatAnEos+s1xdsC47S4+78EnAO5J5p4IHQpl5EWQFHGl3o+zVbrd0O8P3nV8PhPnZnYPhNzQvxL/TZl7yET6T23w4FKFp88TdgTsRsSQH7+A/CftZ69mhAxKND3tt02VqSYQbOcoqqewOElgFtdeQ1wRdqwJ3QFuxpWiv0kBaQSnNTFvDEBBPdYr4ctEWDlKjDQd58LBfvl9qQnmYzSdrEHl0yMpcE58VidpdG7w9BfMELPZGaHOoqa8T0a9MIvGfZ/klHcUpjtSw==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by SEZPR01MB6108.apcprd01.prod.exchangelabs.com
 (2603:1096:101:220::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 1 Apr
 2026 06:43:18 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9745.027; Wed, 1 Apr 2026
 06:43:18 +0000
Message-ID:
 <SI2PR01MB43937CDC4673E9C79398A094DC50A@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Wed, 1 Apr 2026 14:42:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] iommu/amd: Make CMD_INV_IOMMU_ALL_PAGES_ADDRESS match
 the spec
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <4-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <4-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0048.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::19) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <96d93044-b735-4d7f-ac63-393e136bc15e@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|SEZPR01MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: 7888a4d9-1639-450f-3f90-08de8fb9f501
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|5072599009|6090799003|461199028|8060799015|7042599007|19110799012|15080799012|41001999006|23021999003|37011999003|13041999003|40105399003|440099028|3412199025|26121999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TEtqL0lzNitVdFNKS2pqZVh1bE9wTW9ISWk1WDlLRFp2c05rVUJxcHArdTFI?=
 =?utf-8?B?Q3kzQ2JESnliMVlYQWIreXVMcWxhTHVBRU1xR3dkaFFFWCtXOWlTMTcxOFJa?=
 =?utf-8?B?Vk5FYlhhcVRWYmJ6SEFHdEQ4S2NBc2NhRVFUYjZnL2lDY3YwMXpoODNJT1hL?=
 =?utf-8?B?U29IQW5tS2QxT0VLY2ZaSnBLUTFDaXJibzRJWUFhV0lONGlxK1R6eUFESDBJ?=
 =?utf-8?B?bDBuUCsvV2tyNVFYZkNmREtESHFyQWhtS1NLcGJnWUxnc2h2NitZenpQZFo4?=
 =?utf-8?B?MjN1WEsrUnFVcmhWS29CZUluSkdmWU5qYmxiT3BTaHF0VmU4MUZyUlB5dlhM?=
 =?utf-8?B?ZzBQY3hlWXhZUjhtZHJXOHFqa1AwbUZUZ0RaYWRHSlJtUzRJRDJFWWZHcmM0?=
 =?utf-8?B?STJaM1dhZDNITlVrS0hQZDdDV3V5UWtzaHlXUnBHSWR0aGIzVWJ5VWFkWGEz?=
 =?utf-8?B?UEVaS3Y5L3lsSXY4WDdMblQxNjEzVUdjdERBdC9oRStRZU1wbVhJZkFoSkdO?=
 =?utf-8?B?K2xwMXBLM2ZwSzZnbDBtenBoaEtvS1RPQ2hRR2h6MzZZb2hzcXYyb1B5ampm?=
 =?utf-8?B?SUU3amV3c01ZeG1DT3c3WkVZWmdyTk1nUmVTK291VDRxV1pUWGsxUjdZQlIz?=
 =?utf-8?B?eEpVcDRJTUp0YlhSNm9TYy82MW5rM3JSdEFTN01Lc1I2MG1nTGNjQThaN3hk?=
 =?utf-8?B?ck1LbnZGQytubmJZUFBVMmM2eGlPdUk3ZURTUUxrbFFETmZtdXNQdDVDV3dV?=
 =?utf-8?B?b25xamNrTWhxeG11ejFGcFNqZUhNRTgzcVU5OW1CZGp1dkpzZmEyb2dUbHJE?=
 =?utf-8?B?ellNZ3VrVXZsdTNZQUhiMUgwRmdoQkZzNHBwUFNNa1ZpZFJWTENPSmtWWDY5?=
 =?utf-8?B?Qll4NlRpdVBrdERHbUdmc3g2a0UzWXR2VTFRTVBQZkE2Zk41eVl6bDB5ZVZM?=
 =?utf-8?B?R2VEM3hZanBKYVFpS2V1cVFhYzFQeFJMMTVsYzZwYXJrcFMwaFgvKzY2dEdt?=
 =?utf-8?B?UWNQQVM2OFhJQ3VNaC81N2ZqWHhreGdPZG5QNnFLVDNiRjRtY012cWdKb21U?=
 =?utf-8?B?MGxSTkNyOW0yMXdTK1VYeVZlZU10b0JWK1ZPVXV4c2JveU5sZ1hTckEyaHFC?=
 =?utf-8?B?UjhiR2FjQ25yT2xVQzJIZi95cTJFTmhuZkd5M1FVVmh5YXlpbklKZWc1OFhm?=
 =?utf-8?B?cnJyYVlFS3U2cEtjQjFSUElUU0FtWDBHb21xR1NpbmVOSnZabGt0U3AvNFV6?=
 =?utf-8?B?a2VUTGtEK1VGUFRaT2RvZnc1TFlkbmkzVldRSElxMnRBcytWTnc0YStWV256?=
 =?utf-8?B?dkFHdSt5amN3YlNyZS9vaHNmU3RyNitwVzJCOHJzbEZNSStCZERib3dvcTgz?=
 =?utf-8?B?K3Fmd3IvV1UvVXd4aDNtdUZ4cXhaTlUwRG43enhwcHhpdm9nSDgrRXB6SHBs?=
 =?utf-8?B?NU5CNkF6cUlyWGViZERwRHRGbU0wMnRTY2NpR253PT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?d2dFNy9FK0haSkNzaXp4TUJDMElTWFdsc1RScDVrUW41VFdsS2xHcWhQblk2?=
 =?utf-8?B?a2duMWRndmc0d25pTUNwa1RIY1pGQ2w4TU5hZERWT2dVSmFDak9sUlpuNytY?=
 =?utf-8?B?ZGpxWFFtdHE4c0ROZGp0UVpYbjg1MUV0MllwUXdtNU1wSU1EMGdrVUNXRnU4?=
 =?utf-8?B?Vy9WUDkya2lzNnFmWVVzS2tNT05vbGhUU1hzYlVuOG53RUhreVlkcG1MWkht?=
 =?utf-8?B?WVVTOTdRWlNWemdlY0F4bDh3U0s2QWx6S0NrQnFHNmU4V1ozUzl6R1pnMWdq?=
 =?utf-8?B?UmpMdFdTYzZLek93MlVmWkc4MlJEWEYyZnd6SVN2V0haQno2S3RiYlRHZUxj?=
 =?utf-8?B?ZnJYUVFjVjBMVXpldmc5M2l5WkVHZ05GZVRsajhTMFMwSmJDVDYrZHFtSDFw?=
 =?utf-8?B?S2lONzNuVWFvck9WZTFNZFJxV2dndzVKcXRLTmR6LzVzSHRaUTZzL1hiUHZW?=
 =?utf-8?B?SmRKYStRakpsVWJWKyt0eUlDSGQvVjlkSFcrYTcvOGk3VzhQL3FYWWNVY0Vw?=
 =?utf-8?B?ZTBtdGprYUk4aE9FSG8rem1ydkhObU0yaVloVndnOHh0TmdOa3VVSXJUSkMv?=
 =?utf-8?B?dTFYYVFjME5mVWorS2JwaGxIeVMyZHJZTWRRb3BOUmlIVFdPcVBQT2xSOGhu?=
 =?utf-8?B?emt5N0dvbG55bE9LbjRTRW5GOW1LRWFWZlJxdW80Q2JKUUxlNjFNcEFYWkE2?=
 =?utf-8?B?QisxRmJkRnFhN2pqZG9UenlUM1JQNUk2RVlzckNkVXlBVFNIb1ZCZUFiTU1O?=
 =?utf-8?B?WVpWVDdWVUY5VEFJMk5ZNGU3ejg0ZDZvQk01NVQxYmgzVWE1SkpzQ3JLM2ZU?=
 =?utf-8?B?RlIwVmUvNEE2UkFhaUpDdUh6VVhHa3Z3d1c1SzJRS2RvaXJ1TTQ4Y1lZMTdV?=
 =?utf-8?B?VE5QcFNYbS8zTGZXMTVBeUljNTJJbmJPMWFNZ0FkM2FZQjNZZ3JtVjdKOURV?=
 =?utf-8?B?UDJRSERFcGc2dzRTemUrZk5JeXcxTWh2WTlmaGQ0dnV5NG9PcFpQRFJBa0FC?=
 =?utf-8?B?MStEa2s5NHY3UEp6K0lqUHpJdUdIUmZvaEswLzN3aDNoS0lZS3hhanpMVnVq?=
 =?utf-8?B?SGUvaFdISjdEYUZDbWtFeDJ6cm9ld2grRGRqVVpQMHZkQVp0WnhyUmVER1NT?=
 =?utf-8?B?dGU3bWVUWG9NRVc3b0J1WWo4QjFnSEJRb2RvVVIvcDZBV2RtTDlxNm1Sa0lm?=
 =?utf-8?B?VVVUY0VsRHgrQTFrUk5XSUN6dmpDRHZjRUdmN3VrelJ0eW03Zjl0OGVLWHVq?=
 =?utf-8?B?alJFVDU4Uk5MNDZ3dmptelY4SS9WWk94RjdkNDNXYjhJM1VQdi9qZURyV3BC?=
 =?utf-8?B?allWc0w0OGI1R0duQjA2Q1VkYWdvcEhLaWpTaEEvYVdPQnkySVpzdjN3SjBX?=
 =?utf-8?B?YWpDNVZqMm1CYWZzV25wRXBsK0pNUVJYMDUrOWFHMDJyV3NrWTJ6MnNOajV6?=
 =?utf-8?B?VXpHeFdGMVZRSVdDNjJkenJ6MmNTdGhMcFAxVVA0YWE5V3NHem4rSEViNUpS?=
 =?utf-8?B?TlhMeHloV2ZZT3RUZDRieFBFK0kraGdvdGZzNE9CU0VRYUNSckV0ZzcxWkcz?=
 =?utf-8?B?d0JqYXpJZlFyQUl3anJlTU55M0oxNHU2NXZFTHpmeVh6bnBIWnZBWkRkQ1FV?=
 =?utf-8?B?SDExY2JMQ3hsSnlJdHIxdDNBeVhrZGNoUXdHQy9KcHVYVUpDZFdhR2IwRzF6?=
 =?utf-8?B?Vk9SelJqRWFIUlFrTkNRVFNPazgvMUJaQWszZVRGbWxJMVJWaUF2Ui9jU3lB?=
 =?utf-8?B?RFpFemJxR3dCVEptMkROZGYxTFJsTERkRURiWHdvVUNQa2tpTG1la2Y1NFhC?=
 =?utf-8?B?bDdJWnJyTHVPZHpnT1BuQ3R0OVV1Q0d4aDdJQWtoYWpBUjlTUDhSMWZjNVhY?=
 =?utf-8?Q?ugqGhS/z9GKi5?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 7888a4d9-1639-450f-3f90-08de8fb9f501
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 06:43:18.4145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB6108



On 3/27/26 11:23 PM, Jason Gunthorpe wrote:
> The spec in Table 14 defines the "Entire Cache" case as having the low
> 12 bits as zero. Indeed the command format doesn't even have the low
> 12 bits. Since there is only one user now, fix the constant to have 0
> in the low 12 bits instead of 1 and remove the masking.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/amd_iommu_types.h | 2 +-
>   drivers/iommu/amd/iommu.c           | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
> index c685d3771436a2..c239c5fbe47461 100644
> --- a/drivers/iommu/amd/amd_iommu_types.h
> +++ b/drivers/iommu/amd/amd_iommu_types.h
> @@ -221,7 +221,7 @@
>   #define PPR_STATUS_MASK			0xf
>   #define PPR_STATUS_SHIFT		12
>   
> -#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7fffffffffffffffULL
> +#define CMD_INV_IOMMU_ALL_PAGES_ADDRESS	0x7ffffffffffff000ULL


Nit: Using GENMASK_ULL(62, 12) here might be easier to read

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>


>   
>   /* macros and definitions for device table entries */
>   #define DEV_ENTRY_VALID         0x00
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index a3773a145af811..4e057fbc20021e 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1287,7 +1287,7 @@ static inline u64 build_inv_address(u64 address, u64 last)
>   	 *
>   	 */
>   	if (unlikely(sz_lg2 > 52))
> -		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
> +		return CMD_INV_IOMMU_ALL_PAGES_ADDRESS |
>   		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
>   
>   	/*

