Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011036.outbound.protection.outlook.com [52.101.57.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7979730CD85;
	Tue, 31 Mar 2026 17:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.36
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977148; cv=fail; b=SqaxwvTRGKBG9mq+p1eby8cuQmXXH3VkpyRZfy1IImyRleUFFht5F4ctLwy87ZJMR/HSuC5lqdPi2lIM2/nWILX2bFt0PZUOufCdqNSU6sILtYvt+MWgdzQuDmkNZRkR4ktro2INS119dJTAeFeePBYJRCaVEh4X17WQ5OzVCXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977148; c=relaxed/simple;
	bh=c8ntyPUKo0N4iRkwPY2u4ySpnPA6dQnzv/kZ5xPb84U=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M8jR1S1u8JL0R/uwtix5m6zfKcLIDh+Sb3oi5NbZ35ZYV8yu3+RjGZSqB9vKm7MjZLsgLKYkTNvijkinDOLy9MvLM0verwgIQUBNJmkOe/169AhZmvuPjxNbwGlu3Gtcz5+nViAwFxApN62c1/e/Xqnhu9R4dcXZ1TswVqlaWBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Py+00rBf; arc=fail smtp.client-ip=52.101.57.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Py+00rBf"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=on+9zpxKtFVTRQmVJRWa+bcVqj2qeNib3/V0RGIee7pQwmCjpZYjB7mq/rNCxol/l7yfoVd2Oagjw8oNJjkg0Qv+QsHf9zTq3opUR7eJW2yz1c227WmacuU+bR9fQP/QxLnt5ZPEzjSHkuUu+wLZC58OtGZfJzbdv7foNVckrN/CeXG9/fLCnZmyPlSuY9fVaUgbb0Ayc5hrLJZxx+C1O5HRUQzElAx55WbikDHWtrtKs/7tzoFajDm7xHhSX78wt0q8tm56T+iBO3Nx1HJVXlv298eeEY0mUi9ap63aK4dNR11tkVa/S6wnWRxWfMh72anumVv/xOWjpnYO8jFrTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6J7td/wVl8pnOECxXd8WOevp70dEcqjo0vAOglwoZUI=;
 b=ESUiycbdQ9elTl/u9SqtICpJJ3vUHHi+u0kqR632DNhyPRS5kvGnZ3ygUDbMwdCoulfEmKIFrgVrQSYXOh9ZnFTu1YZuS7IrKyL1Xn+T+L/QTS6teBUKhTNIAFv6Pi4nOuG+H3uzgsCQ9Se1bwRdBg+wE6GmjBptsd5OE26GxFA+8ZRYrO7eOsYAAgQ/i2WXkCj2pLl618yb0np8xsYw4khPca/Q4hsRcrJiRKMnlOFY708Ci1UFuKa4pp8PnBQ2KvwKfj07r7qxtTK9EScwbebVByae9rtnxCDA12LQDQyADat1w4/KOE49905ktA8Npyx37tsrhBaL708GqMpEOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6J7td/wVl8pnOECxXd8WOevp70dEcqjo0vAOglwoZUI=;
 b=Py+00rBfETlM4ISQW0UTsCkBonKkINuktDenVCSvZ3yByjyPFV4lcvLtjXC01ih4R+WtJ2zLWj00YXewTnEgZNyS1tTMslBlbrCIC6Mjw3ul3ggQnnSvwx0dZ/hZ1NRN0ehxmSNdjDqQZtmP0FssrH39E26xiShKQKP0R+KJalop2kYURd4+u4HPHr04xH0edIGw1J3sp2uCKiS1j81Y/cgLOth6Txtcv7ctXrP8sjH5i3au+LJndQfxGiBzfvMlgRc1cvYauyf7xr0OAvhkPyogSshm5VE/wNBU/5aT5ank/8sTRrmkNAkRm/1Ht6LszWb77TVYrCgSGpfSbB301g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by PH7PR12MB7795.namprd12.prod.outlook.com (2603:10b6:510:278::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Tue, 31 Mar
 2026 17:12:23 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 17:12:23 +0000
Message-ID: <8800a38b-8515-4bbe-af15-0dae81274bf7@nvidia.com>
Date: Tue, 31 Mar 2026 18:12:18 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc 1/2] iommu: Do not call drivers for empty gathers
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
 Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
 Will Deacon <will@kernel.org>
Cc: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <1-v1-13a02eb0e031+a5-iommu_gather_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0198.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::18) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|PH7PR12MB7795:EE_
X-MS-Office365-Filtering-Correlation-Id: c897ca87-ee68-46e9-dc38-08de8f48acec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	GBOVKHd50kuu8ls+/EOZFdM+Ex8KBy0TRk0bH0uXUEfC38cZuKbQMAorCv4mQfiwhSquYKbZrZJJdEZjUnh3Jycnj+7879TFf8XsGL8Szsg2ZN7aHgaippbCYbZ2aa92M0qzN/7b33jcQlmAQQZWLor57M0S/RbeG958R/DDoGAp1J+2DC7NFV3WICYW50s9vr2h1HWEnITXgXvljVT/UirRucQ+TD/n4j3BBwuM1um5nViZ5dDvzbpuMyBoOHbeb8qeEivY1YCvBdFD56XDmleQ+69DO0u4TI9ivhngYf9macYbrYKQ4lxoqZdHE8SuQKTjOcmoT7XHhk0m0nQwFulo6MTEqrj+3kI3ynIIyWDefmFZ/I/5b0rb120Goiif4FfSzlpT8rg/RHbxutAoOMaUAwHBV2uzaEqYp8PTR1drQrgXEzjvdWA66QAGvBZ2PUk0nMlp9SJ5e/tvfvJDsljKJoKmhCXVACWBzjLeT2dRIRmnuNK4j5JUWBq6SzHbmeGytIegYgQ8haWa4UTFXufuI8miY/g8D6P3VV6HR+0W83IvkPiakH+QPJav5mw0EyiKKVHYJ13GdIkkYdjh6bFB5baC2u0p/MYNrOTMj3RajIqOo+c3Ciev8CgPk1ba3CPpIOY0hdj9jvMmRYVRcWzPQhwn/3Ku410LooeeuGvuTi3QiyTeioZuDKwUO+ILITsIqV5AvxIKR9Ajjm3NGwAPZth1gwtJs2gQseXVz5c=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDRzVDRadjVWM2d2anJCdlIxRjNHSlFJNHB3RWhHLzZsaEVROVlGbWtPY3Zp?=
 =?utf-8?B?RVRDdUZyVEJCOGNEYVlQZ290bmdJUjRTL1hvS1RMQmZCL2FXeEwyY005Z2lL?=
 =?utf-8?B?MGFHQ3lRMklVckFKcC8wUTZxWGliVndIV0tLaFFFdGRMY25PTEpQcGFlclJS?=
 =?utf-8?B?c2lCK0RjRnhBZkFTSEdQR1ZzekFVRjk3eGFzeVJsVjlueGs0MnZwcXVOaDBK?=
 =?utf-8?B?dDRNM1RHRHpMYXdxT2phWEkySExHSkl1L2pMdkxtSTE3RzdsUUxFUGlnYUhR?=
 =?utf-8?B?bklmVWk2Z21tRWNFNzdtcHZOaUdOdTEyYkpCbWtrMXErTEw5RndKaUU1TlVv?=
 =?utf-8?B?dXhTaGwyb2FCaHFEMS9rRm1uaGhSK2JMK2NZd2hTZytSSjRnK25kblp1SEFR?=
 =?utf-8?B?SkozN1ZSV1hsa0JNYlhjV2xOWGxOOGszMjN2dlAwa0kva3hhd1B0ZmNkVjlm?=
 =?utf-8?B?cXUzcHVZejlVcUlSakJvWTZnczNEWTlISytxQ3IvQkVMbUsyYkM3MVNvelhT?=
 =?utf-8?B?VjBhYkFwak93akJqc1gxWWZYUlBrMXk2b0k1bnpqaDRHQnNicEtyeGNnU0xY?=
 =?utf-8?B?Z3J6c3pVUDJOR0VOalRLN05JbXI3a1IySXY2SlhiaDVmWklMSzRHQUpZc1Zz?=
 =?utf-8?B?c0hCeTBhTFBvSHFEQ29xN3NrcDl0bFM5c1hjeFNwSmdNM3pkVi9LKzNZeHB4?=
 =?utf-8?B?TUFobHpGOFJoaXlhUHFSdXRzVHA0S015bFJKVTFqNmJSUWtmdVIzRlZVaEJm?=
 =?utf-8?B?WEkxTDRQbWo0cVdJeGlRM0JuK21ZdHhkVFJpU3FrMk9pWEhib3hwdkcxZFJj?=
 =?utf-8?B?WlcrTkI0dzg5R3Y2VVBLZGZsL3Y3dXh2b1RoSlhwSk9DRURhanhmZGtKaXJP?=
 =?utf-8?B?TGJma09wRmNDeDQ2bTlGRVBWTmNiM3BRbWpRTDRTbitZQzRBUGZRby9OdWZQ?=
 =?utf-8?B?WEdRRnFLN3lPRXJURkYzek9aQzgwblRPWUpSeFp0QlhyelBleDlsNUhTSmxH?=
 =?utf-8?B?Qmt2RFAvOU1qNk5KNXNjbko0UDJwaTRKZzdVUEpFTFh3RWpPc3lpYjl4em53?=
 =?utf-8?B?U1dNaTVsVjZPNWQxKy9JWlMweW9tV25Zb3hFYjg1dDE4UVJIcERqM01LRlBW?=
 =?utf-8?B?Wmw3akFGTHhHWklMbjcvcGFRWEdxZkwwVnQ0ODdmdDhEeURFSnpIUDV6RkVa?=
 =?utf-8?B?NnBrOXI2TkptUGZQQmRkdzZKTVlzVVJLYjkrbVVNbTFJdWhwdy9sOWdlVVBs?=
 =?utf-8?B?R0xEY0dWR1JodFMydHROWHVjZEFDOTN6OHlyNWIzMVJlbW9nQkU0bjl6d0Iy?=
 =?utf-8?B?RFBTaUltK3VsV3BhOTg4UUNCSGZvYzN3NkgvZXNhQ0NsYUVaQ2dYdGVoNUI3?=
 =?utf-8?B?TUFRVkUyRUVvUnlSdk1tdTVsRVY0SUNBNHZvaTZzeFlHSS8zVU1nNzFDL1VK?=
 =?utf-8?B?QnAxamFBZVFjQjRwNTdROGkxNElhRXpOdnA3a0huay9SZnBQRXRrdWc4TjZ0?=
 =?utf-8?B?MmxIL3lNTVFHRjZoaERrdGdiZ0haazB2L1I2eTlsdmJZUVVxKytkbDN0NTBw?=
 =?utf-8?B?eFpKNmtqLzNIVDJvS1B1UkFMQVlrcDFZQ0VYNnA0S2QzQmFsSi9hb21VQ1E1?=
 =?utf-8?B?SkwvU25BZEZXNnJFYmtuMzhCYW5HRFA1UmN4WWg3SmhTVm8zbWlyS3RBQnRI?=
 =?utf-8?B?am5Kak9uSzFYZmJ4N1o0QVFKTWJ5SWRJeXQzVEsva0NwUHA2WDNjUWJQSGN4?=
 =?utf-8?B?dUkvZDRQZWN1bWZDUDV2WHZEZmxVVlhOT1d4c3Rqc3ZaL1Y3OGI1NkE4bGxk?=
 =?utf-8?B?aWhra3hwUldZRFJIZnNsazRqN01Pc3JRRWo2R2svYmdRN0xSUWtmVE52TVo0?=
 =?utf-8?B?azVpSWdweERRQ2FqakYrajFBOS9BQ3VwaVhFRmRYVXI3L29MZExnWE05WWhK?=
 =?utf-8?B?K0lvTExEWU1raGVZVWNjcStCNkcyUmphNTlLNGVxQkNUcDJJZ1M2MkEvdlYy?=
 =?utf-8?B?TU1FeWc3eGFHYUY2OGtiNWYxamxyQXJTWFo1L3g3a2RYbmgxOEhjTDdzK2FS?=
 =?utf-8?B?ay9zQUhwTmNHNmFoV0Rud2pLaW1wOHlpNitnZTZoTHIvZmRoVEJoQWJNang1?=
 =?utf-8?B?ak5DSWliSHQxajAzekpJZDFEblJpcEtVQ1lLMDNhMXRyc0JBV3BoMldwMWhO?=
 =?utf-8?B?Q2NTK2dhT2tWM2QzeHpSeDc1VzhJdHYvNUFYZUp5d01GbkpLWFo4ZlZzL05a?=
 =?utf-8?B?UnNSUTBHbGxDS2xQcjlCMEtES3ZOTi9UaWhZWmNReGJqN1p2RjZvMVRWYVIr?=
 =?utf-8?B?dDliY3ZGWlllSnJoUlIvZklXUDB4S0IvbnBpWTlXUE5LazlLZDBGQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c897ca87-ee68-46e9-dc38-08de8f48acec
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 17:12:23.5894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5g2B1OIjb37/tc8SFeFyXJQqKfWSTyc1mP2yQVWQRwV18fueggy7KOeeWHAc0n51UrfBWFaaTaN7zwjGXmJ80A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7795

Hi Jason,

On 02/03/2026 22:22, Jason Gunthorpe wrote:
> An empty gather is coded with start=U64_MAX, end=0 and several drivers go
> on to convert that to a size with:
> 
>   end - start + 1
> 
> Which gives 2 for an empty gather. This then causes Weird Stuff to
> happen (for example an UBSAN splat in VT-d) that is hopefully harmless,
> but maybe not.
> 
> Prevent drivers from being called right in iommu_iotlb_sync().
> 
> Auditing shows that AMD, Intel, Mediatek and RSIC-V drivers all do things
> on these empty gathers.
> 
> Further, there are several callers that can trigger empty gathers,
> especially in unusual conditions. For example iommu_map_nosync() will call
> a 0 size unmap on some error paths. Also in VFIO, iommupt and other
> places.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
> Closes: https://lore.kernel.org/r/11145826.aFP6jjVeTY@jkrzyszt-mobl2.ger.corp.intel.com
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   include/linux/iommu.h | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> index 54b8b48c762e88..555597b54083cd 100644
> --- a/include/linux/iommu.h
> +++ b/include/linux/iommu.h
> @@ -980,7 +980,8 @@ static inline void iommu_flush_iotlb_all(struct iommu_domain *domain)
>   static inline void iommu_iotlb_sync(struct iommu_domain *domain,
>   				  struct iommu_iotlb_gather *iotlb_gather)
>   {
> -	if (domain->ops->iotlb_sync)
> +	if (domain->ops->iotlb_sync &&
> +	    likely(iotlb_gather->start < iotlb_gather->end))
>   		domain->ops->iotlb_sync(domain, iotlb_gather);
>   
>   	iommu_iotlb_gather_init(iotlb_gather);


I noticed that a couple of our Tegra boards are no longer booting -next 
and bisect pointed to this commit. Reverting this does fix it.

This is impacting our Tegra186 (using nvidia,tegra186-smmu compatible 
string) and Tegra194 (using nvidia,tegra194-smmu compatible string) 
boards. There is no specific crash I see, but the boards just appear to 
hang on boot. If you have any thoughts or things to try let me know.

Thanks!
Jon

-- 
nvpublic

