Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010050.outbound.protection.outlook.com [52.101.56.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A336EAA4;
	Wed,  8 Apr 2026 08:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775637794; cv=fail; b=mmnPVz69HV59L8arEqVHucL/bh5exN4NqSJfY0zIUpJ31JRa60Ir0Go7UoQymdi9YBbyi+RDilC2Pyc4AFhJlgQn8Fm072fxiEUnMg2afd3TfJpqiCq97LkXD7HBLX9sEztiXF/2Q3GxWJYJi5yYXXsmVeQpc+lGGD8Ns+aXskc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775637794; c=relaxed/simple;
	bh=4eO59B8ebg2ld4EcSFMIc6tc4jKTtVi6WxxlRk04Jws=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qYX98PA8uvc2QTnPaT/kyUNOKHEnv4i9s0p+dhyd409/6asCx2f8mw+ezToTkSR4KYCHXKZH/tB144wVqDfYU6khen+OzWyJTVSwGZR1Fco2tDqHFQxt3Z/lwIpUAnHcmwsqZolfiHG9CC/hWfh9pks0nQ6VlUIigZcMYZF6ihc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=OnTOzqHs; arc=fail smtp.client-ip=52.101.56.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="OnTOzqHs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W3zVg1NDYapL7Ctf5LnzzSuw0Z3GO5k3zkX84R5FSGLSsIysLuLHWGn/3X07o0D4s4WOQXWAWv1zMODGKji5ACC1Bs2M0d07RugbX1td5JuVrE6pMAuHncnK/Wn++XE4jActjSDT1eS2U8OqQ3fdudUuj2sw1Cozcw4LVcAM0Tr3vI04vJNwJdTOTYEybzZqV5IrYFLnBuqfvGaaiYsHuVqKuBx/gXsiTKUi2Zc1yJ5GyCEDDyl6Azk7PTQzFsi6jImZdtDVvzfu/JxZdIixwr6kvijCUk4FdzpWSiNT+6bUW7kxSv08Bn/Psb96ZdbIer0VPg4Qj5K+fEB1ZRyGVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VbcQxoDZhnjIgU3TmyOsDbuwnwPpBv/1SzTcDEi1Rms=;
 b=aRLYM38MH6taI8gvPM9RTzr0baqlY9/RDGXesxQcmRe2ao1X5bMiIXthKy1GqnJ4HYTG8QqZwrxyeCCiL3gylfIVDdpCl5XE/YS8cYDvYFPOWi31pdXodWzvJ87/ClsvrKiAX2eJQZK9+STerIvPAlQfKg+FO4l9FbUb5vYpAGUH3s0nlSQ2vpYEtp7VfZCcDVQn5RBfmHD7LrCQJ9CPrXrb66RHoX2k9xhsRXhUbFurUOZooaITNhrolb3iBXkVJOxyq7IMp65KYEzMJIT2kNuD//kGFq2TgIXpLYaVLL71UI09/CUm7ONc7XqnJaQEyOrf/7NlSEceXJ1Nu2uNZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VbcQxoDZhnjIgU3TmyOsDbuwnwPpBv/1SzTcDEi1Rms=;
 b=OnTOzqHsYmSd0FupfQgy39sW3Y88Ta82drOqmgV7Te6mmKESBMSiP0/Y7Xuu9HGvUjzN+hxw6hDGYoNSCQVXpn1Q+RNJj697ZJyaid8QOSWNA9EFtNEATcvANi8eI3WWgrrZym51XkVAzM+yKi/WRggm3Vk+0t7gAmpWj/gUY+/YhUF6Hyw3SGHqFnbCq8lng+c2rhYEaDDLO+hjoiWlrJOayEmvESs6p+jRCYnwSoZuzLJ8Itg4ouQ06RW7tyknmqrhTb8jv/0xHfOc5twuSFjnx7paWwSuXdQZNi1/fMCyEGFKahcq51nJPiswoORnVqigr29Bp575iMuVnynudw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS2PR12MB9750.namprd12.prod.outlook.com (2603:10b6:8:2b0::12)
 by PH8PR12MB6892.namprd12.prod.outlook.com (2603:10b6:510:1bc::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 08:43:09 +0000
Received: from DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391]) by DS2PR12MB9750.namprd12.prod.outlook.com
 ([fe80::56a8:d6bf:e24c:b391%6]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 08:43:08 +0000
Message-ID: <94576121-d4ff-47fd-9ff8-2a00ff4c5c2a@nvidia.com>
Date: Wed, 8 Apr 2026 09:42:54 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu: Always fill in gather when unmapping
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
From: Jon Hunter <jonathanh@nvidia.com>
Content-Language: en-US
In-Reply-To: <20260402225121.GI310919@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0002.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::7) To DS2PR12MB9750.namprd12.prod.outlook.com
 (2603:10b6:8:2b0::12)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PR12MB9750:EE_|PH8PR12MB6892:EE_
X-MS-Office365-Filtering-Correlation-Id: 399663cc-b8aa-4c0f-7c70-08de954adc10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|10070799003|7416014|376014|18002099003|56012099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	XtjnVNFzGNanKim7FzjMoGni+Y92NGaJMH3qZq9c7kABIBP029YoBgI8TA4jU4u8qWEYRsD67cTWFjeNnusFgAxZF0uWe1clqQPH1G96B4M02Bblqrcs5cEjCgMwnRzitEGvLij0NdEGeHoFxCRxOAJfMbUiXydxcRX5lKO7+P6JmgUMYN46jOZ+jWU7SXtoXmZi+YDzHXFYwF8R0BnGQbT5qzk7j79AqryTxz9QGrfkl3AZEGo4pQZ2tAgfNd0AwCVgXEiuj0hg3kGbvm/RF+AxVV6yRGOL9qbb5cm30E3bqQkcY/T2UaktE9aZ88pnFPTGCe1PaDo08CwuQBX5JBakUmG8wE8Q5HtZZumY8TkcdrKP6BuwveTeYJ9LkOGqkEHpggL98L6lmoRkpLqtCn9QsKA3/wydx979GBK+WShwpnlunR/oqjlT1AoIFOSqysWyR2KHAmF2n2TR32YOXLPN1rqZLOsyJcPbylCRSLvXJO7AOymB1pqcwxF/DgKGB7WNqjlI8qMG2Fz81nKRkTomjeKCfRqA0OJSiVHZHIyKItJnuQXlKa09/H3FZ6PjsDri9Y/bmF5g7a1pSEO87D5+WTmpxJzBqqvxJswZDPKX3ims/eTJwv0kVqhejeKOiylZt8ii+yHTbGi1zHcMpLvNI7DUysSyBERUdWFlycKN5EVbFEmkZ1VNCSpTavhFy2xRAC5OK0CiaOtmOjfp6ZcKs7jx2fYZTHUxKNm11JI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS2PR12MB9750.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(10070799003)(7416014)(376014)(18002099003)(56012099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eU13MTZXbzdidVgrTzJGNDV0WHJNZFZqQzMwM2FMSUltMGNmWWFsSElyNU81?=
 =?utf-8?B?Mml6NzVaY1FXQmdpb0JaeFRHTE9SUmMzcGpFVi9tYmxaMUVScDVsWXovaW5x?=
 =?utf-8?B?OHIxbGVYdHFyU2oxbmI2WGRGQmdKenJKbExzMUNqMlBjZDZBZVkyTWc3aUI1?=
 =?utf-8?B?dEJHcGhCRTZ1eCswRFE5Uk1XL2hNK0Y1MXNJanNLY3ZiOHppUnY2Zkw1SGE1?=
 =?utf-8?B?MEswaTBTWDdEMGFiVXhVY1ZNQkNCWExjQUNpejQvZEYvNGk4OE5jd0xqMGFO?=
 =?utf-8?B?NlBWa2dJNUp5dC9oZVRsazQwcjVlL1Ryb2hHMDhRMXYzS2taL25LbUhSNjU4?=
 =?utf-8?B?elNSNVVLMXlGd05ybm1wSThCNlJFdFp6cVZjMzFIWDVxMStFMkhNU1phZ3JS?=
 =?utf-8?B?Z3poVG9pSmhwL3JZeCtDUWcyTEhmSlVUdWRaUWxIQlQ3MmViWGFOK1JmeWFO?=
 =?utf-8?B?akR0a1R5c3VyTzVOc1IwL2RLV1FyU3plMHpHM3l2cnRPQmdyMFpZMDczNzZN?=
 =?utf-8?B?R3ZlRVhuU1JkL3RyRGlMUkdmbWx2ZDFjK2dSVmUxVlQ1bnZISDRibloydmgw?=
 =?utf-8?B?WTBTQTVSVWUyYmJDck8xM0xsSzhqalM3Y29qdXF5ZVZwWko4N3pkTTh5aGhq?=
 =?utf-8?B?dE9HTUY2VXFVVmV6YjZ4STg5Z1psQW1SbG1XNkJ3UURjc2VGRjF0QjlsSEgr?=
 =?utf-8?B?Z1VpM1FBcGQ0K002Zk1VS0JSMk84QlFlVjJhMW13OXdGYXZYaGw4NEJQMnRF?=
 =?utf-8?B?L2xhcUlUcXBZN3FyMEV4YnFuZWdoY2xkUEZrUTV2Mmszek8xS0J3QlZNNlRx?=
 =?utf-8?B?YzBLdWZZeTVKSnJyTzFlZkJjcmo4L1dDWkNhL0dnbDU1UXZyeENhZ3hmc2RB?=
 =?utf-8?B?ZUFqNVNMQ2JtalMxZEtTTnNpUWlIOXJ2N1FEZXRCUEg3cXAvWWlsVWx0VGxt?=
 =?utf-8?B?Z3FlT3dvMzU2T0V6WWtZbHN0Z1lqMjJKYUNtZDFXVzF2TFFWa2hZNjlibHpR?=
 =?utf-8?B?N0prV1llTzBqczJBeDFSdkM0b1ZNUEw2NzF0YkozVHNOUitsZm5lVEJTTTdZ?=
 =?utf-8?B?M041eXFQUE9raFF6U2U4dDdBb1NuK1AwWFBBOENXQXp5MklCaERzME50TVBo?=
 =?utf-8?B?THRSbEFCdWRtbmFkQWN6ZFJoOGxDaHVRcHg3WGNKOGVUWG5xblR5VTdHRnZG?=
 =?utf-8?B?ZUg2a2Fqb0Vzb0tVNDZkc2ZXbk9zWmdDMXk3S215UGYzaTVyamdNNkJHTHVv?=
 =?utf-8?B?MU1wRFhKdVNGZmQwLzZ2Yzc1OTRibVhCaE54UFVwWTVCejAzbE5HR2ZoQXYv?=
 =?utf-8?B?RjFQVGp4MFc3QnRvN2w3RENXSEgvZ1Izc3h3OEltRWJPV3hER0ZuZmVOekt6?=
 =?utf-8?B?bVF2L01pdUhhL0g5S3NKV3RMQm1CdWxYMGJBbE4vSUZWTm1odXk1YnBVRUJo?=
 =?utf-8?B?L3cwWEd1OFBUSFN2Yi94U2lDbUhyUmpQQ1hDWWJXWC9xOVY4VHdMQ3NPa3Vy?=
 =?utf-8?B?Q1JKdkxJTWtYbHAvdTF3SVd6U2lZWVExaWhhOE1vY1hsVXdhU28waHROT0l4?=
 =?utf-8?B?WFcyK0JPbHZwZUxJYytrQ1FjMnZJOVViMmNDR1hndnR2V1EzSUQ1UVA0K3dB?=
 =?utf-8?B?S2gzbkVmQ3JscjZGNktaUlFaM1FLM1dVbnptVEhHcTlmQ1dGZlBqQm9jWWRO?=
 =?utf-8?B?bjQxOHJmTmdnY2ZPNXN5SkNUWk40Z2YwMDlaZkJXL01EbFlxSTV5R0pJQkJ1?=
 =?utf-8?B?NmJYNGxTVWMvZFhXQ2xxL1hNWVZJQ1dEeHpvQTZsK2FUMDNnLzgzN2ZGbkIx?=
 =?utf-8?B?T3RxWStHYmcvdnlscndyamxhY0M1aHdoaDZwTXBpMDRFUDNtMmR5L2RDWG1a?=
 =?utf-8?B?a0x6c2tFamZkb0oyUkJRS0lpSTl1dzlYSmhsV0JvRDJyZDduaEcrL0ZkS2ta?=
 =?utf-8?B?Q1pDdG5WMFFRdXY3VEZkNlY1UWJuRHBQWGk0bVJVV2hiU0owTFJDN0o3VU5I?=
 =?utf-8?B?b01rNEc1Y3JyZERheGRVTXg2WkF6Z09wVk83OWRjS01HYlBSWmVZM2RQM2Uy?=
 =?utf-8?B?TDdqWjU2U2E3TGRycU8xbzNXY1AxT0w4c0tCbkMya3k4SkljanQxbkNFK3lL?=
 =?utf-8?B?TEtuN0IwdUd5ZTlvZCt4aEhGU05tYUJuM2I4cTRRUWpmUTBSZTZESmlzWVNL?=
 =?utf-8?B?Qm1ocllMMS9ZMi90QU9oTlhUZGsxQlV0M3VIMW1VaFE5ZHFDcDNQNUdtbERE?=
 =?utf-8?B?WjN3L0RMSDdib1Z2Tk92QlRtRXQ4UUt1NjdzbEhiNlduRHBRa0dYM1p5M09G?=
 =?utf-8?B?YjlBMGdLWW9xb01KMXloL1RxcVRRcGRnTnQ0bTk4dzZwWTIvaEcySEQxTVBa?=
 =?utf-8?Q?f7krKgkMUO6iXYFeRGoT9rNsEJ69AijxF9KOdY6yYmlzr?=
X-MS-Exchange-AntiSpam-MessageData-1: tC0ARSF1jJSRFQ==
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 399663cc-b8aa-4c0f-7c70-08de954adc10
X-MS-Exchange-CrossTenant-AuthSource: DS2PR12MB9750.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 08:43:08.7582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjR21b8s/0/+/kWHSj4IhuigronLbOtE4l4KXEHpGwTRKKkXCEYzkZ3vRMwAUx1XWDLNeqXWdmbKUESyVkbewg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6892

Hi Robin, Jason,

On 02/04/2026 23:51, Jason Gunthorpe wrote:
> On Thu, Apr 02, 2026 at 07:11:13PM +0100, Robin Murphy wrote:
>>>> @@ -2714,6 +2714,10 @@ static size_t __iommu_unmap(struct iommu_domain *domain,
>>>>    		pr_debug("unmapped: iova 0x%lx size 0x%zx\n",
>>>>    			 iova, unmapped_page);
>>>> +		/* If the driver itself isn't using the gather, mark it used */
>>>> +		if (iotlb_gather->end <= iotlb_gather->start)
>>>> +			iommu_iotlb_gather_add_range(&iotlb_gather, iova, unmapped_page);
>>>
>>> The gathers can be joined across unmaps and now we are inviting subtly
>>> ill-formed gathers as only the first unmap will get included.
> 
>>> We do have error cases where the gather is legitimately empty, and
>>> this would squash that, it probably needs to check unmapped_page for 0
>>> too, at least.
>>
>> Maybe try looking at the rest of the code around these lines...
> 
> Okay, well lets do this one, do you want to send it since it is your
> idea?


Any update on this? Boot is still broken on a couple of our boards.

Thanks
Jon

-- 
nvpublic

