Received: from SEYPR02CU001.outbound.protection.outlook.com (mail-koreacentralazolkn19013077.outbound.protection.outlook.com [52.103.74.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6B5332913;
	Mon,  6 Apr 2026 13:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.74.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775481510; cv=fail; b=d96Lr6yVTrAMfhX11Pkff7tnGP/pY1Xqi0GU7YZxBtSmvxYI0pz/PB1uzCqTplNpAOjIXPEmSPLLrsgy/y7aD4L5DLnugmpLjVyhEH5VP+TRC3NxWna25Sd02D7B+Oi6AzzVCstbAwBqLQ6qknDIjxLBKvjVr8OlQeIDCYlDR5A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775481510; c=relaxed/simple;
	bh=x8BXY3ED7GvgQhCnQzYmm6nWOXQqvqE2PF11EyD4BO0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nJAfCvEdrW+cM06dAVp4v64pvm4UFqMp1FhXOHom11YOKES+IgJ1pAWH1ATQXTbWw90bjejbnazuBOl+FYdMcMbtGhdJ/SULmXCAazM+l1UYFa33Xy3lGnnye4DfFLY4YNHs3oU7OiweDQFjYGF3EbZpV1K+nWFSgpeUPuxXl38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=AW3NABxZ; arc=fail smtp.client-ip=52.103.74.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="AW3NABxZ"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CQU4H77Ak/fQrPJk3zjz+qUbMGnoGIXgmDWW+iDocQPrAab1025yOJl/KJ8CycGrIxHaKT9HdxDsTJIJBRafnXNTaYy4lsodBU/27VSR2ZCATWZngyjwi8XVtKNQSkVh1ReiAR2iMNnj135M2fI33RXTbSj0L7yQZ5a9hlMrPijjhuOD4CirziwF7UKhSWdRmIWzBudGuY3cz+fOrQbePSlVpjv8pPig4r0N4WznyQvhVEXJb3hE8IVR73FOJArMSPdky/6TO7/3NKMk+1I0r8d5aZke5e2k/JsDnSS1xlTpx3GrqczBw5o1baF/mr7AG+bMBrW+krwkwImiU2NgCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBT2M9YMCZEYOEQYP1ohpF4/P0ULhhXPDRBJMumqKT8=;
 b=x+MgnRmgK9ZcaFF5bQyYRmNC+5NwY1tGKPNe3zPciZSak7lc9wzizC+2BgecRHjFOwLjTnU1NntSIUuioB7T+fZGLf5OTqEktDD1jnBryxJlH6XIuA+KtAULNFxCoCWYC1MlX/1kVfSDd4q8wkroEkMsjeNzOMwbuaqfybQzIsMmUH0E9ni5UMoz2Unl5XuWD3HFDoKocd98leoeS68atlhR3P64LX0tC8KTGuHNMSKZF1UZsrQNAtiM3Vf1zCZx+gkYVPle1u30KMBNLzNg9cyweG6QNffM5igpd7ZzGBdx+dsvk+tvsoxu7isMYVtM9vwOJm0DlJ5DMNOsFIiLTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBT2M9YMCZEYOEQYP1ohpF4/P0ULhhXPDRBJMumqKT8=;
 b=AW3NABxZakEkVAOQxiQqxsUtcKlhKXtmtR3XfcUO0rfPmNBMhl35XnFXC7p6aptcjOYJszS5ZoQsxMqPfIxoETf5freP1qrA1l28eDzjEjbhVLAkSG4SrHUlYbqVP7wuesGuczJ98jddEbp0CIkjnOjUjtuKRPvOxHRfBCFHc/GFUZOOdksRI37CO9PDdi43JrGJzlbNo52ciXpfrRUYomhd5tXZb6NkrVGBPa+MPHiXmxjbaXmCeT4NoQYD/sMTLXCIvpCRc6VfHDgtRO92ZxuzZ+NE3twdtHThbzVMXdvMVAeckT0iNs6P/I1PZd4mUvPaNc/4C/oc7m/G58HDjA==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by TYZPR01MB5573.apcprd01.prod.exchangelabs.com
 (2603:1096:400:425::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Mon, 6 Apr
 2026 13:18:24 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9769.015; Mon, 6 Apr 2026
 13:18:24 +0000
Message-ID:
 <SI2PR01MB4393C1FF5BDB413E68BD018EDC5DA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Mon, 6 Apr 2026 21:18:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] iommu/amd: Simplify build_inv_address()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <1-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <1-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TY4P286CA0060.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:405:371::8) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <68903cb1-6e16-4623-976c-f9ec56b2fa57@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|TYZPR01MB5573:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fbb30d4-93e6-4ba7-6a43-08de93defaef
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199028|8060799015|23021999003|15080799012|5072599009|19110799012|6090799003|41001999006|37011999003|7042599007|51005399006|440099028|3412199025|26121999003|40105399003|13041999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VTcrWVdYb1N6dFd4UFd1bStHSkxSWkMvbUtPa3I0bkcrMS9MTk94RUFObE84?=
 =?utf-8?B?M1hWT1lSVGk4T2xlTllGYjU3amZEUk0rY3QyZEJhQk8rS3FuTzI5SEU0QzIx?=
 =?utf-8?B?M0dSQ2tkWEtsREtOTmVKTE1NRDEwckprcVFweGk2NVQ4Vi9JdHY0bmREMURS?=
 =?utf-8?B?Q0VUNzA5bWhtQ0FjR2F3cTlDd3VkRWlNeDl0emVEY0xmVkxrVTFtakhFTGYz?=
 =?utf-8?B?S1RLQzFKWjNwb0JwMFJrL0ZGTUF4TUJMQjVyTUFBTTFWQ1NOZTJobG1uMjQx?=
 =?utf-8?B?UDl1NHMxK2V3QlZLZEtxTHFBYm9ybDFYMXVZU2ZSa2FCWmtMNjV5MXRXMUVa?=
 =?utf-8?B?QjVwZGlwb05EakdPVFZ5NXRJUXlrRGIrbVdGZUx4bUE2bFBCbVhzYW43VWJE?=
 =?utf-8?B?SmNXMDlDQUVSYUN3QWpQaXVCaDZxK1h2dFF3aiswaStDUEdKWHpPY29YcFRj?=
 =?utf-8?B?NE1TY2tMYXJrbncrR0Q0VVlRaGp6Y0xvVk5JZ1EvYkd3OFNRWm1xK1htY3lR?=
 =?utf-8?B?WGFNVGcvUmlaVEJEemN3WVJNK1JlWStQOERra2ovL3U0WnlaUXYxVzBVMDhP?=
 =?utf-8?B?TEJ3Sk43YjhEM0puYmI5RUk1M2NSMnduaUlaRm5kLzZxd2lHSmFDR25PT1Fp?=
 =?utf-8?B?QkhlVHhaTWNTQkJlM0d3M2N1Q1FxU05qYldBWmh4QVZaZ0xPVE9uVGhmclBB?=
 =?utf-8?B?UmNNY0lSd0R4NHZCbm5LSTk3Rmtha0pzREw1SmlXZFNZVSszdS93TmRqM21B?=
 =?utf-8?B?Q2JCbE1rRDJobitjSm0zaXFicGtPOWFuUjdGWnkwL040ZVNGd0hhUnRWQStK?=
 =?utf-8?B?S2d3anB6SzQvOCtEZTlZNkFrcExzY1dsYXU3RVI5a2p1dlhjOXZpcHlGdEN4?=
 =?utf-8?B?d2h5YWVZVDZyVXVyMndkVUNFUkFDMEN2OEZzL0lINmRDNE5MK0hvemxkczdm?=
 =?utf-8?B?dzIrTFgwOXM0TkVPU2FqOURVUGZOQ1pZVXQ3YkhtdlVQVEh2UC9xcUVseEds?=
 =?utf-8?B?U3NmQXNTdnc2WGtTdVNOVllsSmRYVWNlNlgzYWsyMUxHc0t4M3owUUJHUld3?=
 =?utf-8?B?NFBYVTRpQ0RQYWRlK0FyNVE0KzRrT0tBd1o0dXVnbXZ2by9TSGsrK3RJcW5k?=
 =?utf-8?B?SDAzWFdTc2s0TVBlcis1WGVyYjZxb0hRZ3htS1lMODR3WTgzMnJpa1F4TmVP?=
 =?utf-8?B?M0NjVjRNTC9aMUw1YWtlNE5lRHVleWpCNUV3N2Qydkg2NTR5UkRKTllYMlBE?=
 =?utf-8?B?VTdnNjJXT2duSWR5Y2pzVmNpb2JFOGRwSkxCd3prUkdXbW5HT2ZTMStPTzBw?=
 =?utf-8?B?aTVmZlF4MEowNVlOc2FQNVcvdGpkWURrRFhmenlEN1RjMGppNlVzV01iOUcz?=
 =?utf-8?B?bWxpWW9yMDRDM0tlODE1MkVMMGxJRmJSSDJpaEYxK1ZQbTUveVh2elJWSGFp?=
 =?utf-8?B?c1k5MDdOdzU5Ym93cFBybTlqYXFvcDFlbml6Z01nPT0=?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aXE1aU5LTUYrS3lCRmpxZ3JLVWRlZi9HNWdWQ3ZXK3ZjQnY1dys1WFpENzdt?=
 =?utf-8?B?MDdjMTEzVlBybEpLTXM5UkxOcUF0cGhqcW4wRGdWSWRpbU9iVzI5b1hrRWM0?=
 =?utf-8?B?akRwTTEyRyszcjNtcDB3SFlydlpOUFpWaWthM2VaeE5MKzd1c0NzRnljSVRP?=
 =?utf-8?B?T05wcmxvbHREZ1NlTjVlakZNSW9mNFVUZkNDQjBKeDJFZ1dDWkxKcXBqUVpN?=
 =?utf-8?B?eTFBUmpQYVN2VUpQL2Frb2FTWUNxSFdKVWlFaEI1YzM2V0FzNnByWmZlY1JL?=
 =?utf-8?B?eU1hZkJpRThmTjUwWVdtODg1anpzYks0ZGd4ODMvc1gxUVMvRG5ndlJ6b2c0?=
 =?utf-8?B?QUNabXo1MWNlWUtsQjR6aWRtV3dGc2xFd0VBcFRGUDl5M1dHUk1vaDQwS0V4?=
 =?utf-8?B?QTJsQlBlMDJUUHZrOUtmVTl6OHlUWUprTlZCOHpRYldSbStXTmEvODd1czJr?=
 =?utf-8?B?OTI1clpTeVoyUk9ZSTBqMlpUQnM3Mnl2R0luTnZkdmRyYUhJUXdlSVhERE9a?=
 =?utf-8?B?dmx1RW9EcUtMUTFxMEVmd25CY3AyWFRYbnBvemliaE5NY01zOTBvY002VWFF?=
 =?utf-8?B?SkRYM2RGTm1zNkhsNkgydUM4MHpHUmYyRjZVVDJNdTluR1Mya2d5VzM2RlNo?=
 =?utf-8?B?bnNmb3hWSHVNckk0T2lPWklKNjdMR0JwM252OTA0bXoxdndYRnQ3THVnTFJv?=
 =?utf-8?B?UlpxVE1tMXBzR1N3MFhaeGxiWGpoelE1MEk4WWdEWGZYZndSZnRWbXR0a1o2?=
 =?utf-8?B?UHZzTlhXQ0d6THdQT0RyNFdFVVk5RHVES3NDU0kzNlVsNGVyRzJjSSthWm13?=
 =?utf-8?B?bm9UeHFaZ1RPWG1DUXp6d0l2ZnBONSt0cTBNN1g4djdEOTE2a1YydUpvSWRH?=
 =?utf-8?B?SUxsdk44cW1MajFOZTNubEJpVHRvVFZHREZTWkRYSlI3SkRWSUtaVHpSMXdp?=
 =?utf-8?B?aHQ1NzFHUjhGMzdhZ3ZYNHhyZUNhay9xWWNtbVBIaGM5Q3NkRmF6Yzh0Q2xY?=
 =?utf-8?B?bUlDTHl3NHYvdkUzZGUydUo3WU9NaVBMdmRNbk9YNWJveS9FU3pocXJUeitW?=
 =?utf-8?B?eWR0WGVYRmJ5V3V3aytxYnF2NWV2L3RVeHFOdFBJNXRpWENrQUxMQTlTcGly?=
 =?utf-8?B?LytUVE5WVnFkd1BFNjh2MUxSSkx4VDcyWHlPOTUvNWFSbG1GdHFldW9oalNk?=
 =?utf-8?B?YW94S1N6d0JhQzc0c3F5USsvTnU0MnlGTS9pZmpUVVlCSUJjc0hPSW1FU3NE?=
 =?utf-8?B?aEZLR1NTVFhuMGtoRWs1cENMTjBkY1ptUi9kd0ZiRmtDaDI3Q013T0tzdnJH?=
 =?utf-8?B?angvUDFENEZGWlJhQVFNQnI0SkxwbTMzSXJBakJrRXZINFNBUDdtZlJ2cXIz?=
 =?utf-8?B?RUJ5bE83cHNXMC9Xemo2SVJIT21SWG1qcm9oN1g1cGd5dU1WeU9sQVhldk9E?=
 =?utf-8?B?Q2JZcDkvaGh3NW8zZ1NPVkRvZDBrTzM4Vm9RWURSYXFmY2hIWG8ySTUyQVd1?=
 =?utf-8?B?d3QrU3dxSnkwdGNkVklidE9Va2RFcHh3VzVQTlI5aE1OVFE1UFRtZE9qZzhM?=
 =?utf-8?B?U1U2RjErUUNqbnhySmFMRGc3UUpsaUh6UkVqakdQL3RHY3NKaUxIR044QVNs?=
 =?utf-8?B?ZGJkYXF4RFVpZzhnckFtMCtka3AvVzM5NUovQ1BDMng4amxKQnlQcjZLUUU2?=
 =?utf-8?B?L3BHNE13V2NFd3pqU2lXdDk3OEhWSDhiZXJnemdrSWUxTGxtUCtBL2I2N2xH?=
 =?utf-8?B?NE1XSUNwd3V2cFdpbC9OU3pheWRZeGxCRXB2VUZiZnVYMDZMV3lqYTFkUGt1?=
 =?utf-8?B?b1FwN1RVZnd0SEppL3pZYmhZSWNwenhVYkpOYmxqUVFGTVBGdmhYY3FpRnY3?=
 =?utf-8?Q?GinICjyPSYeJ1?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fbb30d4-93e6-4ba7-6a43-08de93defaef
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 13:18:24.4407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR01MB5573

On 4/3/26 8:26 PM, Jason Gunthorpe wrote:
> This function is doing more work than it needs to:
> 
>   - iommu_num_pages() is pointless, the fls() is going to compute the
>     required page size already.
> 
>   - It is easier to understand as sz_lg2, which is 12 if size is 4K,
>     than msb_diff which is 11 if size is 4K.
> 
>   - Simplify the control flow to early exit on the out of range cases.
> 
>   - Use the usual last instead of end to signify an inclusive last
>     address.
> 
>   - Use GENMASK to compute the 1's mask.
> 
>   - Use GENMASK to compute the address mask for the command layout,
>     not PAGE_MASK.
> 
>   - Directly reference the spec language that defines the 52 bit
>     limit.
> 
> No functional change intended.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/iommu.c | 50 +++++++++++++++++++--------------------
>   1 file changed, 24 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 01171361f9bc22..e4a88879ca35d2 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1268,39 +1268,37 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
>    */
>   static inline u64 build_inv_address(u64 address, size_t size)
>   {
> -	u64 pages, end, msb_diff;
> +	u64 last = address + size - 1;
> +	unsigned int sz_lg2;
>   
> -	pages = iommu_num_pages(address, size, PAGE_SIZE);
> -
> -	if (pages == 1)
> -		return address & PAGE_MASK;
> -
> -	end = address + size - 1;
> +	address &= GENMASK_U64(63, 12);
> +	sz_lg2 = fls64(address ^ last);
> +	if (sz_lg2 <= 12)
> +		return address;
>   
>   	/*
> -	 * msb_diff would hold the index of the most significant bit that
> -	 * flipped between the start and end.
> +	 * Encode sz_lg2 according to Table 14: Example Page Size Encodings
> +	 *
> +	 * See "Note *":
> +	 *   Address bits 51:32 can be used to encode page sizes greater
> +	 *   that 4 Gbytes.
> +	 * Which we take to mean that the highest page size has bit
> +	 *  [51]=0, [50:12]=1
> +	 * and that coding happens when sz_lg2 is 52. Fall back to full
> +	 * invalidation if the size is too big.
> +	 *
>   	 */
> -	msb_diff = fls64(end ^ address) - 1;
> +	if (unlikely(sz_lg2 > 52))
> +		return (CMD_INV_IOMMU_ALL_PAGES_ADDRESS & PAGE_MASK) |
> +		       CMD_INV_IOMMU_PAGES_SIZE_MASK;
>   
>   	/*
> -	 * Bits 63:52 are sign extended. If for some reason bit 51 is different
> -	 * between the start and the end, invalidate everything.
> +	 * The sz_lg2 calculation with fls() ensures that:
> +	 *   address & BIT(sz_lg2 - 1) == 0
> +	 * Therefore only the 1's need to be added. 8KB requires no 1's
>   	 */
> -	if (unlikely(msb_diff > 51)) {
> -		address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
> -	} else {
> -		/*
> -		 * The msb-bit must be clear on the address. Just set all the
> -		 * lower bits.
> -		 */
> -		address |= (1ull << msb_diff) - 1;
> -	}
> -
> -	/* Clear bits 11:0 */
> -	address &= PAGE_MASK;
> -
> -	/* Set the size bit - we flush more than one 4kb page */
> +	if (sz_lg2 > 13)
> +		address |= GENMASK_U64(sz_lg2 - 2, 12);
>   	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
>   }
>   

Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>

