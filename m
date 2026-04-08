Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010062.outbound.protection.outlook.com [52.101.193.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5BB3B8D78;
	Wed,  8 Apr 2026 13:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775655317; cv=fail; b=NnHNyMGjptgvTxIS4w/HjDUo1Ocv58dQoBjqgqPJA5K3jBytjZ2Bb/S4pcYPQS0r6s1Am2l4jMzhjElfV3iTg8kHxZ+csWI6ghGc8IyFiQ9aLiZMnDVzaaqVrc0pLIz3gZIC2qQxNDX7kmd/FsinYldajz4o3EL6r5fC5r74yk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775655317; c=relaxed/simple;
	bh=ZdL6zC5U+KwV0WvsjYnbuA55N4AEd1314qKQ9stdRvA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jXUSGkfJjdVUEUjByLeiLA8kuqUJsTVsW5Q95H21+2a6HW31J0gidVXWFT730F/+Z48lT3Ks+XgeV2o3bUODrliUfHJnbfZcDrrs/Wbjpme6KrUztUmIbmll0gWBYLHhEoietQUBhpUOQmhH9PgoQhXi3OcabwUy6/IsLDLDgbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JhRMrSjb; arc=fail smtp.client-ip=52.101.193.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JhRMrSjb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=quJgtmrjcBeWP1QQsEygpk8GTy3xVRajeTDh/YJMG78JGnSdutB23CLAPO/M4qIxvY0hIiVCawzM6Ae1/nxljyh2uMTnXCIxFPRYBKku9Y60yD/a/QKqhY7bnIMOaw8vuahdIbSQCtGgus6v2l5z0tQYjITvvLFZVUU0kjyaSBJcRXRpm3YxnNqoZZJYaDgnrzlhplcg5ZNNUvNicybz0yE7PJ5GJcXqbBBipTU2gHWFmj4bCtYmbQb+jLYnOrRgE5J4y7FSGc8XG8hXAjiKsolom51KRBemODwbbRObupFkrmN5U+pCIjqdbTdbuREStcT/NGPioXejX1aL8wuSBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRf8y/Xbm93UF9VirZ7Uem2Y/sAkeJtabHXYdoa+wis=;
 b=QRnA1YvfY15LmzZNvI3N0KZ6SM2olBz9YoOx9NwmNDbuItQuApD/iuIYrEYLnfFV7IedRZr6nkGxGRN+1zabLJ5/kU9RP6HZYmtbCvugOGF7K5HbyzUkK0vtwpFEnXw6cZC8i+8hgehbSmPUgpAEpgZNI73hZ7HZhYvlyDH0J1YmgKsk1nwFhD/Msd77sf33u+7bU9T6iXftEjevqqam8Id6J/qSGIM/+OPwwCu60O5PtQVMOcEaeP11T2GUU3+N4kcXlMxtKYf381yNphJw5ZD5P22A+U5spUylatD20Qqe/QBn3PMG8FzJWjoTQdEa8/B5THd0HfK9nVkoRKgbpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRf8y/Xbm93UF9VirZ7Uem2Y/sAkeJtabHXYdoa+wis=;
 b=JhRMrSjbashxHJZS2P96XecdZlyzQZVbi3uER+E5tWHeYkPNkBrrSNiOzxY0qBY2GBq+06tsDszAvYKQYWla8UHFVaTtmDqVXpOsT+YVoX1UahZdGSh8bvRYk00qfaSRMSecwHYMqtVVujrtCyz1UoPHrM732pgaiwNLYTtNfFjq7Xkuc3x5Rtepha3907irTX4N6gSe9/X41qnth5tdod/1tGCTwJQOlNwavVaxL2acO0cTQ6lDd/htIff+IslS/j65xxB2OddcwLPQuIhR39ppPvWv/n01y8vV3gpEFvhgDsvoQkEIF4BVb9oZBgeEcL5RGy3toTdGEUwTSpJL5w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by MW4PR12MB7167.namprd12.prod.outlook.com (2603:10b6:303:225::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Wed, 8 Apr
 2026 13:35:09 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 13:35:09 +0000
Message-ID: <56559431-b73b-4e3b-8554-7a72d78e2b67@nvidia.com>
Date: Wed, 8 Apr 2026 14:34:59 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
From: Jon Hunter <jonathanh@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Robin Murphy <robin.murphy@arm.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Albert Ou <aou@eecs.berkeley.edu>, asahi@lists.linux.dev,
 Baolin Wang <baolin.wang@linux.alibaba.com>, iommu@lists.linux.dev,
 Janne Grunau <j@jannau.net>, Jernej Skrabec <jernej.skrabec@gmail.com>,
 Joerg Roedel <joro@8bytes.org>, Jean-Philippe Brucker <jpb@kernel.org>,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-sunxi@lists.linux.dev,
 Matthias Brugger <matthias.bgg@gmail.com>, Neal Gompa <neal@gompa.dev>,
 Orson Zhai <orsonzhai@gmail.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>, Samuel Holland <samuel@sholland.org>,
 Sven Peter <sven@kernel.org>, virtualization@lists.linux.dev,
 Chen-Yu Tsai <wens@kernel.org>, Will Deacon <will@kernel.org>,
 Yong Wu <yong.wu@mediatek.com>, Chunyan Zhang <zhang.lyra@gmail.com>,
 Lu Baolu <baolu.lu@linux.intel.com>,
 Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
 Joerg Roedel <joerg.roedel@amd.com>, patches@lists.linux.dev,
 Samiullah Khawaja <skhawaja@google.com>, stable@vger.kernel.org,
 Vasant Hegde <vasant.hegde@amd.com>,
 "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <0-v1-664d3acaabb9+78b-iommu_gather_always_jgg@nvidia.com>
 <ee2c2044-e329-4cdd-ac35-9365824d3677@arm.com>
 <20260401173650.GD310919@nvidia.com>
 <ec51ef14-e360-43a6-ae62-44a939ec8027@arm.com>
 <20260402225121.GI310919@nvidia.com>
 <94576121-d4ff-47fd-9ff8-2a00ff4c5c2a@nvidia.com>
Content-Language: en-US
In-Reply-To: <94576121-d4ff-47fd-9ff8-2a00ff4c5c2a@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR1P264CA0171.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:347::17) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|MW4PR12MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: c543b95d-558b-42da-372f-08de9573a709
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|10070799003|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	Tm7EMfjbnelwIwQTP7uon7RLSSgXMZFyNxaAeMsjfJhrxdlTSRAEaeNNN7LNCNpHAoQT5YqWft8wUnflYuXdfDvQ3vGt+UlvtHN6EFJCngRQbvV5QprHGwCEp6ay4vW43bvO//jzqdjzEOR9+nQIXaCouTQiVMR36UerTIgf516caLOrKrqeNCJ3l3V+vDJXvM/8J8FHzatx8fLRgY1ZlI/0Z9OgcJCo7hgPjYlZ3CjdsZmR0Boq3ZQLinIPLE6qpyxPkgSCo8dk9OZFhCP3Q12gi3lWR83aIKlPY2L6YLcZJjrGtt2RbJDZDfCYgkGbnsHZRaRwpcGqfsdTACRHGivRYHKhstyRgdP8s6VSqvDM76MyMwyeOJBZaWwTwANOEUw3NRc/vB+awR1+ojP2osH3jVRAkRfpG6L0cLyfLodOjR7s/jM9RY0FS7rLwhW0cnrSdRy4q3JxxRNHXPZJFX0TsHzuRpwRfzOho9rmrDVPq5a5sA+l9MD6IECUXHyYG63U1WGzuqmfeHdgWUS4332dlCXCv5k1K0wVZyCnbHhcFOuZs99tGwlHPz7iv8rx9gkpLTN0eYPMhPJIdDz3Ovyh1Cu32fNiPZCoBxU2aHhRxKaZd2pszdumCBzUzlmro7L7bonS7UUeT5BdTFASiaOYom3xMLyS0q2krinNDNjb+uVAgPp3AoO3UbizIR9tEF59XIBO4h/EWQGSN66sht9yngCj1vtDPM3wxEvJ5pc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZXZHcHRDeWUrcXdrK1kzRlpYNENPNUR3bzlFSlRZZk1uZE9MMWFxcjJleDRQ?=
 =?utf-8?B?UXR2NGxDRDBZdFJLNWY0YktraFNKR0QzR0lZM04zdkFGY1U1V1QyU2NBOVVJ?=
 =?utf-8?B?Q3dTRXh4NWlod1EvL045ZjJiVENxRWxzRjdaQVUzTzlGMUtDZU00L3dvOFk5?=
 =?utf-8?B?WmpxQ1hYak85ZzczMy95enRNSHIyUUxiZmZJUUU1cWlrZ0tMR282aUFWTXBR?=
 =?utf-8?B?eDJJejNYb04vNUpVVUptVjRjbE5SUHVTbGRPRCtNRHF4dmoyczJCNDI1WDdU?=
 =?utf-8?B?b0ttM21Db0E1Z3VEYXNKV3dWbHIrQ1hpNUtvaW5PMk1OMzIzZ2IxMU9NZWFs?=
 =?utf-8?B?YTFYZFZLcUJEaWQzbVhzUmlaOVFrdmRJeXZFUzZYMFZLQ0xicnpvaFJZeXRI?=
 =?utf-8?B?OVZndzBTeWJUODk4cjBjMWMyVXQrb3dJT0tkK1FkWlhrTFFSVHZndk40WFp0?=
 =?utf-8?B?dFgrd3JvS2hoemZsL2o5TlBXeTJiWnAxV3JYa2xZM0ZxVHBkbGFsa2VZK0R2?=
 =?utf-8?B?OGlLSFg3cFZKZnlMMzJZNlJ2eUVFRVVtUVVSRnBsVVg3b1NRRGMwMDgxS3Y0?=
 =?utf-8?B?UGh5K0pENFp2N1MyMlNWWDFoMXhvUjhXQS9PM1hhbitNd1BWVXVHUERpcUJp?=
 =?utf-8?B?Um9CNXFlR2ticTJFNXc5MjJ1R2oxSjdGSDhBVTFkQjJwV0thTmpoR2ZzdnM1?=
 =?utf-8?B?VmFDaTlsY2QvWUhnV3BsSHJJRDRPS2dZOTJCeUJEd2RsaS9TQTArbFBUdkg1?=
 =?utf-8?B?VDQwN1FheDhrZ3lYbEVQU29JQ3VudjlxSC9rK0N0YXYxSXZhWFEwUi9KUEFK?=
 =?utf-8?B?RGNwV1huSmFTQTNtQlJEZU9BWFlvajFTYVJmaVA0dDdONXk3L0ZzU0txcmR1?=
 =?utf-8?B?WjluWXZ0UHJmZURVR0pNcUVibkhzcGc1ZEpucGtzbUJMeDlYZUQ5K1kzRG0z?=
 =?utf-8?B?VmtaNGt1cFBFYWR4SEM1a3ZBdmQ2aHVPUy9Da3dZZE1PWkx5TmcxbUZwZ0NU?=
 =?utf-8?B?NmZxUHZ5L3FrZUVCNEFPeFYwR2lHRnlUcFpudWhrUkNNeXRmUW5leHhKNEJO?=
 =?utf-8?B?SWJaOEdOZUg0Z3RvYjRjVmtUdnYwaiswNkwvVFM3eHJBbnIrbk5DSkhtcFZX?=
 =?utf-8?B?YVNEM0l3eGYwSmlwQ1ViVFFqcWdTNGIzdUkvVlRKd1V5elM5eHlyZ0sxNXFJ?=
 =?utf-8?B?dGJyaHhrYVZ3RWhSSUQ0UUFrVGdvTHZKTnhOWVF0Nk1zenYwYkZvSHdoZGlG?=
 =?utf-8?B?NThMdFdjZFBGcnR2R3Fzdk5za2ZkemJzWXQ0eVRjamJ2SHVVNFZPVXhjWTVG?=
 =?utf-8?B?U3NrcGYyY2NRMEJzcDNSQVVDRkdkVmpwZnBKZktnM2EzVDc5dHFBcmJ0QVF5?=
 =?utf-8?B?SzJTRlZ6QnBmbEx1YWxBOUhBdjJhSHExK0dLVzVLblAxRE9KcE1Bb0VPdEQr?=
 =?utf-8?B?VEVjOUxtczNxN0xNU0hsTEhSYk5seEIxZzhFMGhWdTlweUdNdmRJQVJ2THAw?=
 =?utf-8?B?K2dkVkYwdzYxaSt5a1BXS3FwbUJGSjVaeXl0US94SGFDZDVOaXVZdVN6K3d4?=
 =?utf-8?B?VDNNc3ExSmh0TFdrRXRyeThPK0dNUDRDUzUvUWtXMVFFQ0NHNVhmQXhDdkVj?=
 =?utf-8?B?SkxkMVBiSGhmZElLbDFiY2ZnVUpCcXEzaHhvSDIxR0hpWjRsL211bDFCZE1O?=
 =?utf-8?B?bXlOZjQxTkJuVWw3Und2QlA4RVRWVmhVUzJNbXVjb3lDbUJVMjU5UzVmMWxY?=
 =?utf-8?B?SDNaMEt5emMxVzgyTHRNM05KNXZHRytNOEgzNFZ3VGZiQ09VMEk4cmlhcnkx?=
 =?utf-8?B?Vm9paWlIZDZPOWxVeFNqS284K2d3ZlZOUVJZK2tmRUFXWVZIYXBGTzA1RVVL?=
 =?utf-8?B?WnRJYlVwTGJ3b0xBUWRjbWRhYzloTkhHM0VMVUc4UmdzaWRWV2hmSk9OelYv?=
 =?utf-8?B?U1Bzd000QUJBa0pzZ0w2VzVhR3dxZjZLRHZ2T0ttSTQvZTlsODVOMFI2cmJL?=
 =?utf-8?B?dkZiOWk1UXpka2NEenZoZ0VUOEJ4dUNiSFk0TU9aZXE2czlhZWhvemZsTCt5?=
 =?utf-8?B?aHlMM1Rhb2V3aXRuK25qNnlETUIzMUYvVGNQUldqRXZFdGdDcUlYUGJDQlRO?=
 =?utf-8?B?bWQyV01DTnVIemN6VFRXUUhrZjM2L29zZE1zMzBETkFuV0IvWmsrSUZDN2Rr?=
 =?utf-8?B?SEZVVVNqdStya1RtSjRrWCtNSWUzZkNOampSRC9OMnhGNmxQRkN6aWtaMG5T?=
 =?utf-8?B?VTBPMVloVzhQcmhQMzZ3ZWY5UFZVQVFPTkxLaHpmQ3h5NDJBVWxWVnZ3NFhH?=
 =?utf-8?B?VG9FOHloUktIN3VvaHYrMjVDNkJER2N6VEthcG1KTUgvNmtDQVg0eXBRVHdk?=
 =?utf-8?Q?iV3QGXTYjM05+xpap8g3ywG5ALzpriTRMu+hjWiH6wArC?=
X-MS-Exchange-AntiSpam-MessageData-1: o/lzCtSQbflfQQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c543b95d-558b-42da-372f-08de9573a709
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 13:35:09.0642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9b47sY4jdmCqlJU4n7Y9abunpuQpWxLeCyU8+5R2q+Uxe0G40ZjegUeezD2iUQQYjVIV8lBd6jBpXNEGxJolvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7167


On 08/04/2026 09:42, Jon Hunter wrote:
> Hi Robin, Jason,
> 
> On 02/04/2026 23:51, Jason Gunthorpe wrote:
>> On Thu, Apr 02, 2026 at 07:11:13PM +0100, Robin Murphy wrote:
>>>>> @@ -2714,6 +2714,10 @@ static size_t __iommu_unmap(struct 
>>>>> iommu_domain *domain,
>>>>>            pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
>>>>>                 iova, unmapped_page);
>>>>> +        /* If the driver itself isn't using the gather, mark it 
>>>>> used */
>>>>> +        if (iotlb_gather->end <= iotlb_gather->start)
>>>>> +            iommu_iotlb_gather_add_range(&iotlb_gather, iova, 
>>>>> unmapped_page);
>>>>
>>>> The gathers can be joined across unmaps and now we are inviting subtly
>>>> ill-formed gathers as only the first unmap will get included.
>>
>>>> We do have error cases where the gather is legitimately empty, and
>>>> this would squash that, it probably needs to check unmapped_page for 0
>>>> too, at least.
>>>
>>> Maybe try looking at the rest of the code around these lines...
>>
>> Okay, well lets do this one, do you want to send it since it is your
>> idea?
> 
> 
> Any update on this? Boot is still broken on a couple of our boards.


I just noticed that this is now broken on mainline as well as -next. Can 
we get a fix in place before v7.0 is released?

Thanks
Jon

-- 
nvpublic

