Received: from TYDPR03CU002.outbound.protection.outlook.com (mail-japaneastazolkn19013073.outbound.protection.outlook.com [52.103.43.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99E530C63A;
	Mon,  6 Apr 2026 12:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.103.43.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775476938; cv=fail; b=BSzaAYbnZjh5Z72XkcSvx5DeQV30GS0nGZ4SsWdH4YU1WU7ScuvKWj9ekcH6H9Ft1IJpwzHPjoKChxDg1CDG5kayUU8XPjrdEod5vo7ohO7iocRQvSPsVazx0E6kKtlpNkJ+UAxuuH+xYK+9czegFyyQGb95o1oHoZw0zyM4iQE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775476938; c=relaxed/simple;
	bh=SnH59y4HFAhmPR/dCvNKca6GD+Tdm7CUE+yE0j1dgYM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DO2krCwSfPp25tPTFNA1bRGvDmbvnm+FXsRLf6+TLN8UcmWNGtWvgVadr5QumFZccBylpPD0qMOc7a25qvnlw8GOL6/Z1L8DqZabWKwChzweJWWt8l6Yq3z5/b1LCh8aL/FYhqd4YTmvuJF4HrbYNoH4lF5tXgx/LZ0cVsWaDaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=kjdmpvPf; arc=fail smtp.client-ip=52.103.43.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="kjdmpvPf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iK/djvoVQ/CwepwOfvVSdffAdTdQqYGuWOxfi/C3CAPeVntkC6mlAdO+jdFqscR/vIC/xdf/4g8ws1Gq/WwKjYXME3q6Xaapw8rH0M4WQ7bF0OWc+hyrGNFDAvGOgp33UMP69ablHq36E2CymXLos5k1iL4Oj7OjRjGFGjBynRK9O9EteXT08ckrz8pGHoCCgTXg9ozCZ4oLyDfhRUY5V2bGl/we0TfaY4CnU8uW475WlXoXsBdXyUFLNdcdlgV+EyQdTr8KcG9kCtDSQszqFgywioZE3OcH0gUkNvWjl2gAK/yszJPmWvvUWojmoo7Ql1aYJI5aJ0V9hDMPZzhVWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pZHTY9OiS1366I45HkKBTF7TJV7v/PK/2sYIniAfTpI=;
 b=gWKlW3K5ZdFoDCnQ5bYRjfQ0n5U5o4J93RggL4gCis5W2AnJ/9eyKFzCsOGIYmkwS4RWPiCP4cORP8sPI/Dc297/bGW4EpnOVhwFHm8zrh6lVv6zqZN5rvFQPGkXbNrZR1kueoaOQP2RBKrlfySA+j/vO6IiPR8CaDovU/V0IVdRzqP53v5wwOcYoVmVDnkAwJzWHDxlNXW4TVkirZBFFYBwYU+ARAklGpo+43bGYMdCErsL8GYw7EJA8Lnq7tGJhgiaQOgAbik1PcwqlNGmuzGZ65BpiyEPGyNyIrFcDqeMhwH5h+XdHpx+doMJD00PimkXhRd0ZfjE9M0eI5bWIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pZHTY9OiS1366I45HkKBTF7TJV7v/PK/2sYIniAfTpI=;
 b=kjdmpvPf7DGm/SbHCMZkevXMXhzF7+b7Hsby7TdIQ0NTwk2trfCEQr7o+9NM16OSpdk1LWNj1MRqssXflwBARDysQY85VZIbn707U9gfUVZhsBIOMc3tyeHRv/HmGj6qtbvTulunaFsiOiCFWtPiqty01skbV0V3vEf3Um110xFXIn7aO5u7fYNamXqodhc6bk5BnApIgAX0WP4EGic0GQg7ZJIPTF1dz9xI38QFX38xluh9+bWQjPznaQGGrN14kKv8tXt3CNriOsjXCrzM8pzlp5c1CdYAoPupOdBQ8EyYwfdSPUv0maPIBmaHLMijOniCdseLkFMaikTB/jBn0g==
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7) by SEZPR01MB5342.apcprd01.prod.exchangelabs.com
 (2603:1096:101:e5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 6 Apr
 2026 12:02:12 +0000
Received: from SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c]) by SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 ([fe80::c735:fab8:6e3d:6d1c%4]) with mapi id 15.20.9769.015; Mon, 6 Apr 2026
 12:02:12 +0000
Message-ID:
 <SI2PR01MB4393B58045D81CD8E5F1F5AFDC5DA@SI2PR01MB4393.apcprd01.prod.exchangelabs.com>
Date: Mon, 6 Apr 2026 20:02:08 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] iommu/amd: Pass last in through to
 build_inv_address()
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
 Will Deacon <will@kernel.org>
Cc: patches@lists.linux.dev
References: <2-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
Content-Language: en-US
From: Wei Wang <wei.w.wang@hotmail.com>
In-Reply-To: <2-v2-90ddd19c0894+13561-iommupt_inv_amd_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYCP286CA0252.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:456::10) To SI2PR01MB4393.apcprd01.prod.exchangelabs.com
 (2603:1096:4:1b0::7)
X-Microsoft-Original-Message-ID:
 <2007b614-79c8-446d-9d88-963fc602571f@hotmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SI2PR01MB4393:EE_|SEZPR01MB5342:EE_
X-MS-Office365-Filtering-Correlation-Id: 04d56271-b98a-43a2-9de0-08de93d455da
X-MS-Exchange-SLBlob-MailProps:
	7qh87CJt6y2KqegnoS4V+KljWAyhwvUzcqHcQkVXanmJU+DH3/znqAPjxzHS5P8TXOenvwPhu7ZLmwRQdw/RFZL2EV+eLi1ZpYcfCrSXUmRA9JPI2496O6Q9xwBaXUva1g+BwuaPn8lsHFhorkcAeNSDXmmDFog9vwrw24CsGg/6wjcfF+4Yq0fv13PXNmbSNF7i+orpkNM4Jb+9mi00MiTl7KLepUZaxGIXCDmxXm2wbP9wooRmgehb/V4PpSVxdUmZSn6M+0Gyp9qc2cDvV7zHorGSVnSSwutDBCH3AuO2qFSA8bme6jQk7OKf2HtMVMxXGHFmcPAIVio3K5/LgiLlitWpSoNGc7oPSsle2LfNJ1kv9TKiw59RkoC3awXCAhKPf22LWBu8+ZA6hFO2C3HBvoMFgoT14OIWTgwL1ULgZeEShJxQH0jIyhL2DNBXQivXFwQomip1MiWkNLZgQGtxGvUkiHd5b2UPAZIi5xWFJypODTvKqudP+k4nis0c6PKgr1pwe3ixJ6QvLKcol+gWgQTyFaROhw2y5Qtk0MSM9uTzxzewPzwBWQkqhsZYUI6L6U3ASvpdEa+1BtEKBSOP+2JdnoOnM5kSdRr1uEHqat7hVzsG524QT2ZSDlIzXAVC5ZlZGGvCIZZo0rS63XyL/+W1+kmKkmiKbj+Jp8WVA7Ale3izzEqubLgKPunG8jZtRmNDbkIb3mLoLl9VCaf7CKZbv1lxVCy/S3wff63xXOQzNDqgZ1B60bPNKFJt
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|41001999006|8060799015|19110799012|23021999003|37011999003|461199028|51005399006|6090799003|5072599009|7042599007|15080799012|13041999003|40105399003|19061999003|3412199025|440099028|26121999003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVZ2Nlh0ZjArVEpXSEZhcVk0VzIzWXFJeFNvNHVWWlZDbGJPcjdsWDQwd1F6?=
 =?utf-8?B?NURzZ29WTGcrdG1LNDF5YkJiWEVnVmg1eUEvSlIvM0ZuLzQ2YjBYRFEzRHdV?=
 =?utf-8?B?YzJ4aEJGVWwrV3FwblZpVjAzMkFFNjRCWDIrRUV4MnhwUDRvUUx4cmhOcjJO?=
 =?utf-8?B?czdZNno2VUdhUzZwbUZWamJNVFE2Z2JlcjlKbSswZFhpRVV5U0g2M2NabVFu?=
 =?utf-8?B?dVFRc0VocGk3SjdydmMrMGNKMWVvcEYrUEhUTVQweXJrZGVQekFaNnlPbWl5?=
 =?utf-8?B?a09JVzlibE02cnZGK0ZrNUFKdWtrd0NkQUYxOUdyUFd6bEpWM1hkdTB0WlE5?=
 =?utf-8?B?V3VZdVFpWWd5Nm5jZUVsQ0dnS28yczNpcWJWbDdyVEg2bGV6SFVOcithREJP?=
 =?utf-8?B?VVE5UGwwc0MwbjcrL295aTFDUXM0RTBnNWFvbFZDcFdvNG1nMkVKVS9TcHpR?=
 =?utf-8?B?bitwZWVFaGZpODRtb05tVzdvaFZVWjY0NkYzbHA2ck9QYmoyQ1Jia0dkeDIy?=
 =?utf-8?B?ZlNDVzdpcisxTHNjNjArc2NscXZHaithcmVvNEhzOWJBSjZvQ2tHOTh1cUJZ?=
 =?utf-8?B?Y2VUUXErM00wcXh4TlZBSG8zam1PRkZRdVl0S1BSRUdLSTk4UFMrWitaU09w?=
 =?utf-8?B?MDhUTGtIWlhPd3NCLy84UmxSZnpiaVRVWjFPUjF4NGtocFd1TFBzbTAyUlJY?=
 =?utf-8?B?Sm5welJIeW85cUo4bU9Oemp5TkVrbnBJN2hJaDVhempESTR3S1BFSVF1OEpL?=
 =?utf-8?B?THE0bDN4aG4yVWg3eXRQcGFDaXhGMTFSYXJ6dmJGb3BFbG9JZGY0ZXg5aXBS?=
 =?utf-8?B?NzhaSnk3U2U5ckNCNnc4Y083eXN6SXBIdVpvY3did0l0SGczc3dFRHJkSlcw?=
 =?utf-8?B?KzZUVk5sZ0tKTFBibXExYVZ2VncwN2N1YjNZb1lZbTFRTG5yOXIvOFRkUXBR?=
 =?utf-8?B?U0l5dFJoNFNLOWNORHgzT2FaeExxOG1OTUIydmhvQXVndDU1dFFoemxrTWNj?=
 =?utf-8?B?b241M3ZJQ3J1WC83cVZGVUZMWWl2ZG0xeVhDcC9JZndMcXI1OXFoTWdkUEx0?=
 =?utf-8?B?eExIdUM1bk0xM21SeUpHTXJkT29UWkdmMHAzbWxBQ0ZnQkJESFVndkZCNmxO?=
 =?utf-8?B?WGRhVHc1dmVYZ1RhcU5oSm1jcUM2TnVCNVZyNXRyMFdxSEM2TmZibG9XVFlt?=
 =?utf-8?B?QW1IYzFzaDRjZ3ViNE41UHdtS1RRMHo1dXpzSWNFM2QrQXhxcElhOVc5TFdj?=
 =?utf-8?B?R1JIWWw4Ukg0T081cFFWeXhVbUQ1S2Q4VFVhNmc3OFZsU2trTDZiZjQzR2VI?=
 =?utf-8?B?NC9jb3RLbFo0TUNSWnJsZGpqTVg4WEJ6M0daOW9PTm91S0ZydDYxYkI0SytJ?=
 =?utf-8?B?SjhRbkZ1cTUzMktjYWVOS1R3c25lbGl6WFhYbCs4N3oybFFSOE92TWU4MDY5?=
 =?utf-8?B?NktCS2w2OHNkdHNOSkZHQVR6cWt3OHVqZkh4UHlON0dyOWF5b2FXaFo0VWRu?=
 =?utf-8?Q?Sien2mGLmGeMpaxEr8hD8s9vHak?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OStBaWZuWkFBMU9mYjljSC9lZUY3SzdKalVHWTUvUlNaQzBkSG5NNXQxTUZ1?=
 =?utf-8?B?YWZMTWtCNmFla0xHSGhVZnlSbzZFcUdqSkRsVWVrcDZlQkt0dW5uZGxBZWdT?=
 =?utf-8?B?NHVXTzQwRjd2VGY2TUxTK2ZjdkVaN3BHZ3JlcEMwMjJHVTVtYStPMVdZRTNV?=
 =?utf-8?B?UXFCd3pZWFdpa1RLY2JHWHM5RXMrY0ZCM25WZUQzMHFQK3JFNUt0dEw2SXcr?=
 =?utf-8?B?bkRpa0wyOVlDWDZXcldjWklZRnNZMmVNa1VYazR0eFJhNmVjaENLTXlNa1hm?=
 =?utf-8?B?OVdZUE85TDdMSVgyTmg3V3RBNVU0K21EVFZtNFh5TmZCbURuSzd5NjBqcmdk?=
 =?utf-8?B?eFNuYUNVb3h0ZUpQMGxLV1dnamdmMjk4UCtsamdkSCtmekZsL0w4WmR5aW5h?=
 =?utf-8?B?NE5ENEx0UmdRVkZDb2pOTU1QWHB5Q1FXeDY5K0grbHdUa2tsM0xtclBCcjgy?=
 =?utf-8?B?MTZmbHFCLzQxR25UVjZKNGRaemNqNXc0a0dDK1I4d2dWOURFZ1VNcTA2RGxs?=
 =?utf-8?B?dE9RVmtVOG5Danl2aklTdUFQQTBpS2FHU3RETkJhM3FPMU05NFh2cURtWDdN?=
 =?utf-8?B?S2R3TEJ4QVM0dUZnMngraUpqL216aHMrTEZHdWNHUlZwZWw3aW96ZEtQUkht?=
 =?utf-8?B?TzdQUEZ0WGFBdlBiemxOUWFpTW5QcTlnR3RSOVVTVzMvVDlWbmZwYjhEeEYv?=
 =?utf-8?B?cTRrbHlkdkhFT1pjSkJGcG9PV2Iza0RZcmVuTmlqRGJkWVp4RktJeE9naG1x?=
 =?utf-8?B?d0YyQThOT1RVMjlZK2ZGa1k1NTZxUGdFeC95alo1VnBKZWx6NWtBZmwydSt2?=
 =?utf-8?B?aHJnTTF5NWlQYTFrU2VTdDU5blpvRHpibGRpZFVaYWtMMnlseE80SFRVZGtn?=
 =?utf-8?B?Zlp3YWlYZ3A0WEZiTzBKT25FWncvbUt0MVZ5ZDA1cXl0bnY1K2hiK055UktW?=
 =?utf-8?B?S2hvOW9oRHpDbk8zTStrbmxzdVJYVWhGOHJLQVlWMUdCV0c1aEYveUcwcExW?=
 =?utf-8?B?b2FqeEpHUTRnSERNemVBcWdFaUtoUFRNTzU1bEczZm1uRmNOMnBmVGJrRDg3?=
 =?utf-8?B?Z01iR2JnMVVxdXdROGxIb0R5QTlqaGtHeGVqNGpuek15N1lBa0ZJQ1dJWWUy?=
 =?utf-8?B?eWQxemIzSWhnSTFLTm9vaEJTbzBJVUhubFY5UWhEaDBhOW5tdyttR2dDYkIw?=
 =?utf-8?B?VTZBd1JRdlhaT3psN0U1ZkhPSUdqTy9sczlXemExY3dXbEVzWEJkczVIcXZL?=
 =?utf-8?B?emdvazZGWHN4Si9vR3R3b3VrN0EycVdMMmtiTmh4OGlGUjc1ZVJBZ0tUKzVp?=
 =?utf-8?B?bmZ4L0E3SEgrZ3ZrM3dZc0N6WXMzYTEvZ1JiSU5OUjBwbHFtMnVBcW5uQmFP?=
 =?utf-8?B?Q045OUpXQ1V1Nkh5RzFrMWUrYzhNdUdpb01mam5CN2drVXBkUTNPYzB3NnhB?=
 =?utf-8?B?a05JSzBoRUFIOVVtcjJsa1BSck1nemhBc2VEa2VGK2hxbE9IcFlDZEhaZnVu?=
 =?utf-8?B?S1dWeUREdXFGZm43cmQ2YjZKSTFGNmJMbm5wSEZGYzF4aUJSRTQ5Mm9aNUUz?=
 =?utf-8?B?dStsdC9obVlHMmNFcHZ1VUtyVDJHem9IWXpyMzZLQ1pCZHozSTB2TmVSSTJu?=
 =?utf-8?B?RzdtNmMzVkFmS3UzZERxZ0lmNWx5Zy9ZL1oxTEVyZHczRHFjb3R0MWZlbjN5?=
 =?utf-8?B?c25EV05vemU4cUFkZVhLRVg4RlppZDhlL2x2OTVtZnZBd1pJS0MvdmV2SGFu?=
 =?utf-8?B?VUtzMnBkNURMRGhSck9hcVFaMks2NVNQQWFOVUl4STBPRXkvZFlabUF6a0NH?=
 =?utf-8?B?S2RTcFFwbm93TXYzS3d4bGFGRFQvSTNMYWFGMW9kWVBNZ21lMDRhZnp6NHBE?=
 =?utf-8?Q?XCEABNpuZkar+?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-3e488.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 04d56271-b98a-43a2-9de0-08de93d455da
X-MS-Exchange-CrossTenant-AuthSource: SI2PR01MB4393.apcprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 12:02:12.2981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR01MB5342

On 4/3/26 8:26 PM, Jason Gunthorpe wrote:
> This is the trivial call chain below amd_iommu_domain_flush_pages().
> 
> Cases that are doing a full invalidate will pass a last of U64_MAX.
> 
> This avoids converting between size and last, and type confusion with
> size_t, unsigned long and u64 all being used in different places along
> the driver's invalidation path. Consistently use u64 in the internals.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/amd/amd_iommu.h |  2 +-
>   drivers/iommu/amd/iommu.c     | 71 +++++++++++++++++------------------
>   drivers/iommu/amd/pasid.c     |  2 +-
>   3 files changed, 36 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/iommu/amd/amd_iommu.h b/drivers/iommu/amd/amd_iommu.h
> index 1342e764a5486d..831d457c8dad13 100644
> --- a/drivers/iommu/amd/amd_iommu.h
> +++ b/drivers/iommu/amd/amd_iommu.h
> @@ -90,7 +90,7 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu);
>   void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   				  u64 address, size_t size);
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> -				     ioasid_t pasid, u64 address, size_t size);
> +				     ioasid_t pasid, u64 start, u64 last);
>   
>   #ifdef CONFIG_IRQ_REMAP
>   int amd_iommu_create_irq_domain(struct amd_iommu *iommu);
> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index e4a88879ca35d2..9ea40ab8398048 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> @@ -1266,9 +1266,8 @@ static void build_inv_dte(struct iommu_cmd *cmd, u16 devid)
>    * Builds an invalidation address which is suitable for one page or multiple
>    * pages. Sets the size bit (S) as needed is more than one page is flushed.
>    */
> -static inline u64 build_inv_address(u64 address, size_t size)
> +static inline u64 build_inv_address(u64 address, u64 last)
>   {
> -	u64 last = address + size - 1;
>   	unsigned int sz_lg2;
>   
>   	address &= GENMASK_U64(63, 12);
> @@ -1302,11 +1301,10 @@ static inline u64 build_inv_address(u64 address, size_t size)
>   	return address | CMD_INV_IOMMU_PAGES_SIZE_MASK;
>   }
>   
> -static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
> -				  size_t size, u16 domid,
> -				  ioasid_t pasid, bool gn)
> +static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 start, u64 last,
> +				  u16 domid, ioasid_t pasid, bool gn)
>   {
> -	u64 inv_address = build_inv_address(address, size);
> +	u64 inv_address = build_inv_address(start, last);
>   
>   	memset(cmd, 0, sizeof(*cmd));
>   
> @@ -1323,10 +1321,9 @@ static void build_inv_iommu_pages(struct iommu_cmd *cmd, u64 address,
>   }
>   
>   static void build_inv_iotlb_pages(struct iommu_cmd *cmd, u16 devid, int qdep,
> -				  u64 address, size_t size,
> -				  ioasid_t pasid, bool gn)
> +				  u64 start, u64 last, ioasid_t pasid, bool gn)
>   {
> -	u64 inv_address = build_inv_address(address, size);
> +	u64 inv_address = build_inv_address(start, last);
>   
>   	memset(cmd, 0, sizeof(*cmd));
>   
> @@ -1524,7 +1521,7 @@ static void amd_iommu_flush_tlb_all(struct amd_iommu *iommu)
>   
>   	for (dom_id = 0; dom_id <= last_bdf; ++dom_id) {
>   		struct iommu_cmd cmd;
> -		build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
> +		build_inv_iommu_pages(&cmd, 0, U64_MAX,
>   				      dom_id, IOMMU_NO_PASID, false);
>   		iommu_queue_command(iommu, &cmd);
>   	}
> @@ -1536,14 +1533,15 @@ static void amd_iommu_flush_tlb_domid(struct amd_iommu *iommu, u32 dom_id)
>   {
>   	struct iommu_cmd cmd;
>   
> -	build_inv_iommu_pages(&cmd, 0, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
> +	build_inv_iommu_pages(&cmd, 0, U64_MAX,
>   			      dom_id, IOMMU_NO_PASID, false);
>   	iommu_queue_command(iommu, &cmd);
>   
>   	iommu_completion_wait(iommu);
>   }
>   
> -static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 address, size_t size)
> +static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom,
> +					 u64 start, u64 last)
>   {
>   	int ret = 0;
>   	struct amd_iommu_viommu *aviommu;
> @@ -1560,7 +1558,7 @@ static int iommu_flush_pages_v1_hdom_ids(struct protection_domain *pdom, u64 add
>   
>   			pr_debug("%s: iommu=%#x, hdom_id=%#x\n", __func__,
>   				 iommu->devid, gdom_info->hdom_id);
> -			build_inv_iommu_pages(&cmd, address, size, gdom_info->hdom_id,
> +			build_inv_iommu_pages(&cmd, start, last, gdom_info->hdom_id,
>   					      IOMMU_NO_PASID, false);
>   			ret |= iommu_queue_command(iommu, &cmd);
>   		}
> @@ -1616,15 +1614,15 @@ void amd_iommu_flush_all_caches(struct amd_iommu *iommu)
>   /*
>    * Command send function for flushing on-device TLB
>    */
> -static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 address,
> -			      size_t size, ioasid_t pasid, bool gn)
> +static int device_flush_iotlb(struct iommu_dev_data *dev_data, u64 start,
> +			      u64 last, ioasid_t pasid, bool gn)
>   {
>   	struct amd_iommu *iommu = get_amd_iommu_from_dev_data(dev_data);
>   	struct iommu_cmd cmd;
>   	int qdep = dev_data->ats_qdep;
>   
> -	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, address,
> -			      size, pasid, gn);
> +	build_inv_iotlb_pages(&cmd, dev_data->devid, qdep, start,
> +			      last, pasid, gn);
>   
>   	return iommu_queue_command(iommu, &cmd);
>   }
> @@ -1668,15 +1666,15 @@ static int device_flush_dte(struct iommu_dev_data *dev_data)
>   
>   	if (dev_data->ats_enabled) {
>   		/* Invalidate the entire contents of an IOTLB */
> -		ret = device_flush_iotlb(dev_data, 0, ~0UL,
> +		ret = device_flush_iotlb(dev_data, 0, U64_MAX,
>   					 IOMMU_NO_PASID, false);
>   	}
>   
>   	return ret;
>   }
>   
> -static int domain_flush_pages_v2(struct protection_domain *pdom,
> -				 u64 address, size_t size)
> +static int domain_flush_pages_v2(struct protection_domain *pdom, u64 start,
> +				 u64 last)
>   {
>   	struct iommu_dev_data *dev_data;
>   	struct iommu_cmd cmd;
> @@ -1687,7 +1685,7 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
>   		struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
>   		u16 domid = dev_data->gcr3_info.domid;
>   
> -		build_inv_iommu_pages(&cmd, address, size,
> +		build_inv_iommu_pages(&cmd, start, last,
>   				      domid, IOMMU_NO_PASID, true);
>   
>   		ret |= iommu_queue_command(iommu, &cmd);
> @@ -1696,8 +1694,8 @@ static int domain_flush_pages_v2(struct protection_domain *pdom,
>   	return ret;
>   }
>   
> -static int domain_flush_pages_v1(struct protection_domain *pdom,
> -				 u64 address, size_t size)
> +static int domain_flush_pages_v1(struct protection_domain *pdom, u64 start,
> +				 u64 last)
>   {
>   	struct pdom_iommu_info *pdom_iommu_info;
>   	struct iommu_cmd cmd;
> @@ -1706,7 +1704,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
>   
>   	lockdep_assert_held(&pdom->lock);
>   
> -	build_inv_iommu_pages(&cmd, address, size,
> +	build_inv_iommu_pages(&cmd, start, last,
>   			      pdom->id, IOMMU_NO_PASID, false);
>   
>   	xa_for_each(&pdom->iommu_array, i, pdom_iommu_info) {
> @@ -1726,7 +1724,7 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
>   	 * See drivers/iommu/amd/nested.c: amd_iommu_alloc_domain_nested()
>   	 */
>   	if (!list_empty(&pdom->viommu_list))
> -		ret |= iommu_flush_pages_v1_hdom_ids(pdom, address, size);
> +		ret |= iommu_flush_pages_v1_hdom_ids(pdom, start, last);
>   
>   	return ret;
>   }
> @@ -1735,8 +1733,8 @@ static int domain_flush_pages_v1(struct protection_domain *pdom,
>    * TLB invalidation function which is called from the mapping functions.
>    * It flushes range of PTEs of the domain.
>    */
> -static void __domain_flush_pages(struct protection_domain *domain,
> -				 u64 address, size_t size)
> +static void __domain_flush_pages(struct protection_domain *domain, u64 start,
> +				 u64 last)
>   {
>   	struct iommu_dev_data *dev_data;
>   	int ret = 0;
> @@ -1747,9 +1745,9 @@ static void __domain_flush_pages(struct protection_domain *domain,
>   
>   	if (pdom_is_v2_pgtbl_mode(domain)) {
>   		gn = true;
> -		ret = domain_flush_pages_v2(domain, address, size);
> +		ret = domain_flush_pages_v2(domain, start, last);
>   	} else {
> -		ret = domain_flush_pages_v1(domain, address, size);
> +		ret = domain_flush_pages_v1(domain, start, last);
>   	}
>   
>   	list_for_each_entry(dev_data, &domain->dev_list, list) {
> @@ -1757,7 +1755,7 @@ static void __domain_flush_pages(struct protection_domain *domain,
>   		if (!dev_data->ats_enabled)
>   			continue;
>   
> -		ret |= device_flush_iotlb(dev_data, address, size, pasid, gn);
> +		ret |= device_flush_iotlb(dev_data, start, last, pasid, gn);
>   	}
>   
>   	WARN_ON(ret);
> @@ -1769,7 +1767,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   	lockdep_assert_held(&domain->lock);
>   
>   	if (likely(!amd_iommu_np_cache)) {
> -		__domain_flush_pages(domain, address, size);
> +		__domain_flush_pages(domain, address, address + size - 1);
>   
>   		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
>   		domain_flush_complete(domain);
> @@ -1806,7 +1804,7 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
>   
>   		flush_size = 1ul << min_alignment;
>   
> -		__domain_flush_pages(domain, address, flush_size);
> +		__domain_flush_pages(domain, address, address + flush_size - 1);
>   		address += flush_size;
>   		size -= flush_size;
>   	}
> @@ -1823,17 +1821,17 @@ static void amd_iommu_domain_flush_all(struct protection_domain *domain)
>   }
>   
>   void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
> -				     ioasid_t pasid, u64 address, size_t size)
> +				     ioasid_t pasid, u64 start, u64 last)
>   {
>   	struct iommu_cmd cmd;
>   	struct amd_iommu *iommu = get_amd_iommu_from_dev(dev_data->dev);
>   
> -	build_inv_iommu_pages(&cmd, address, size,
> +	build_inv_iommu_pages(&cmd, start, last,
>   			      dev_data->gcr3_info.domid, pasid, true);
>   	iommu_queue_command(iommu, &cmd);
>   
>   	if (dev_data->ats_enabled)
> -		device_flush_iotlb(dev_data, address, size, pasid, true);
> +		device_flush_iotlb(dev_data, start, last, pasid, true);
>   
>   	iommu_completion_wait(iommu);
>   }
> @@ -1841,8 +1839,7 @@ void amd_iommu_dev_flush_pasid_pages(struct iommu_dev_data *dev_data,
>   static void dev_flush_pasid_all(struct iommu_dev_data *dev_data,
>   				ioasid_t pasid)
>   {
> -	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0,
> -					CMD_INV_IOMMU_ALL_PAGES_ADDRESS);
> +	amd_iommu_dev_flush_pasid_pages(dev_data, pasid, 0, U64_MAX);
>   }
>   
>   int amd_iommu_complete_ppr(struct device *dev, u32 pasid, int status, int tag)
> diff --git a/drivers/iommu/amd/pasid.c b/drivers/iommu/amd/pasid.c
> index 67eace9809f16a..d708c6532480a4 100644
> --- a/drivers/iommu/amd/pasid.c
> +++ b/drivers/iommu/amd/pasid.c
> @@ -71,7 +71,7 @@ static void sva_arch_invalidate_secondary_tlbs(struct mmu_notifier *mn,
>   	for_each_pdom_dev_data(pdom_dev_data, sva_pdom) {
>   		amd_iommu_dev_flush_pasid_pages(pdom_dev_data->dev_data,
>   						pdom_dev_data->pasid,
> -						start, end - start);
> +						start, end - 1);
>   	}
>   
>   	spin_unlock_irqrestore(&sva_pdom->lock, flags);


Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
