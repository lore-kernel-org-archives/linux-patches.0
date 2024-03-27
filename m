Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B334852F96;
	Wed, 27 Mar 2024 14:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711550339; cv=fail; b=WPqoeKqvHCaRXMEaZSTw2FXXll6f/8mu9HlNeZ8WN62mVWpfn235h3X+Mdf4kk6A9HKzfTy0KUuFdalgi2KZKcYmoNlACMGzIuXQIRf2Qu14qJjyucMXRH7L3AFSKA7p30yeZwkF7xN60X0EMC5m9bH95dmqNBnmS4untViLleU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711550339; c=relaxed/simple;
	bh=yr1OspF8V3XjeVLQ1p7ToFYQSl66yir+j0ruLNJObJk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=aqw6yPNbCwIJAhkkaBBeHQK7NL59AfCGXbnrUNdqP6DRkowBvcIVSIUCV4wl8K4uqb+RKzEtdm2p6K9GQINN0DCTz3mzzTX1n3JKkOlcxUKnzqqr7z6XjOUZYuZ5Mb/pnpZhxCBLnSeIv/XIr02GrsLbeZKxk5DykPSa54wgY50=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gVtOFYF5; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gVtOFYF5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711550336; x=1743086336;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yr1OspF8V3XjeVLQ1p7ToFYQSl66yir+j0ruLNJObJk=;
  b=gVtOFYF5NJ88YgbVD4n1oWAVe8fGGg4ewJsSU0imr/zf4U3Hef+JWRfY
   tbOV1m2wxmCEFE/K0qI2oJo6+v3Lpzzhux/JHhv1yfTKQ9VVTxkLrc9HE
   vtgEsipMTSQSWKyV56GbkvJLhp1K1WvhZ7QJ1H8HEEAFCmJAg++X4AZLQ
   C4UFOOQawaSUhvWYrbrIhWaylsz+hQ8CmcAugtDRI7P+7gn3MJQNnvs4q
   buO6z26e8frVkRL1zB/JjV1y/PJc5YT56CBpvmEdePnkMn+2V2q8QFXju
   +qmSBzI2VrDGhtwzNSqXixkAYXF9hY8N2Sg8LrLSZIxV1qi5lkxsZ8G6e
   g==;
X-CSE-ConnectionGUID: op+nbS3pSuyQ0646EYo7Jw==
X-CSE-MsgGUID: x5yP6DdDTkmc4zonUnPSxg==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="24146175"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="24146175"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 07:38:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="20976125"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 07:38:56 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 07:38:55 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 07:38:55 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 07:38:55 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 07:38:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3Kv4T6EvBO3JVzT86/YpCWCOnjxSJpUTPj7j8MbG9Zp+lKhbepaS3WpitEcG9Km8MeuXiSHS77P63DFRkbODqknr/bPEQT4H2PasL4HLm8TgPuIsjgMqxOJCdJ4iHi1W6ZFniEvQGUQrTZH1aHgcDXa59tBcA6aJCpfB+I0BAIpFz71ZdLK8zVF/Q6lD1oqG+sm8HKCHgI1KQ7zLsmGAQBhWzyfPQPpfJg84h4aFD7ebNShUxacq0vqy66HJOWraZL0PbOjiuh8Lo0En0isQqFOrvt3qS8RXF+hCS4ptjHkF+FYgztpS9Zdlj1IBTqDCbPq5u4z2eyRdmmlfmsk7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lwk3sa0TF7+HLfW5sziaWHO8ZdULkRJyXA4LCHa9WWk=;
 b=mvN/iQUdVBOqVx8ZeimuYNRHH3pUQ7xSUwIyhoTy0nbOhgb4HlTOTyQ/w0crQqfTfU8lR+gxOJjOKcUfzrdWe1h64Jx7rCRlhohFjxSBhxctdT1kBev6fNsmTHbyfjCSsgwlrKOZdzpasDhT9d2HtJ6gwm85WbHcu+fL5ZwVNMefIt8LCX9oJrJyH1I+JdyE1CBTMzOh84QGf63GkfRMzg16S4TCnIbfRfTrcIGDqvCKsgkZWS7RKVCKcG0+H5bTcKZmz1UGSO1uD02Rrz9UT9U0mlQyiJ4j9adA58Pd4hRjFNHhBVJjaueab4Bj4UcHytfIkDB/kXNSo6i3hbXlKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM6PR11MB4516.namprd11.prod.outlook.com (2603:10b6:5:2a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 14:38:46 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 14:38:46 +0000
Message-ID: <23c76cd9-2927-41e7-ad30-57a4220dd776@intel.com>
Date: Wed, 27 Mar 2024 22:42:16 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>, Lu Baolu
	<baolu.lu@linux.intel.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	<patches@lists.linux.dev>, Tony Zhu <tony.zhu@intel.com>, Zhangfei Gao
	<zhangfei.gao@linaro.org>
References: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
 <e8e0f7cb-b4a7-433f-a204-73dc0a976246@intel.com>
 <20240327142759.GH946323@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20240327142759.GH946323@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::13)
 To DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DM6PR11MB4516:EE_
X-MS-Office365-Filtering-Correlation-Id: d534276c-d677-4bb0-b52e-08dc4e6b9bb8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eYWRWAilaLFsRrXasL7ti3H7iOKPpbweUAW3lvZWqSHf/Z4knBw/KHUkb3f4FZP68GSnox4gdedCLhhAZvKo1jtKA1qyYZEZVbrs0V/w8drPLTaV8W/67jMXhxZ8O/HjH8anDYdTf1Go9YJRESRL8dNMiukfVxGyFEHbXB6U9oaLf1I2GXTsKh76iu3pDkvuMSlsIZC6bM8izzqysGKB1pVihvSqVQOrJvYyTQnsQDazxta/BY6Uc93beuokmFrEpQyCunxIYvmKs44uTH2kY0QCUFIeAVwGXoge6YsAB+Nso0+yvEHTvHZ5RhjvwV69DtPT/MavjfwJggqJDhxFkoE52eA+JKvAVas6+vZrnq0w0mLXNyD9yuvYLciSKPcETtjKTXZihXZ+qc1UHxcgMLdwkG/N/b8LQcGcILjzaSB8o1y+imVay7DLJdcFYnsIy+4dTXeBdFHp42Zde7wEiRK9eWBuVh8XzOBzlJZLmJJ66QUOF+xlsDxLlbdUrZdl8GQM9yyrmjnPrT2RhkOF3n2ArYpMbqccqYPW45rAGKXe3iFtK56IMqlbSsGfn2GzkdFog4Q+zTtaSGhzk6NV6OwnpZBr0joz1rbvOuAda9A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3NsQVZtUlpsb3psWFRTejB0QlhrY1V2K2kwYkxMeTN3OFdCZ2dhYWVYc2JQ?=
 =?utf-8?B?N2RubTY5UDJMQjJlcU9oTTgxcTd0QjRjbC9MWEVyQUtuZ0thZnUzd29KVzRp?=
 =?utf-8?B?WjBhMEFsQkE1Q3ZDeTVGczJSTHYrdnZTWFRmSHJEQjFsajhBbkFleHAzdDQ5?=
 =?utf-8?B?d2V5U3FTNGZsdHg4bGRJL2ZqMHRhWjByVzFZbVB2WnZIYnVBTks1Q1ZzUWI1?=
 =?utf-8?B?MTJzOWdCaDFEK3dDSlp6TGlJTzVsQXZ0ajVwZG5weDNZdHY1aCt1dHg2QWVT?=
 =?utf-8?B?a1hNUUN6cEFqSVdHalYvaGtiRzE4WmFpZlI3dThUUHpjOElkUjlVM2lKS0pM?=
 =?utf-8?B?N1NtTzNWcis2eG9KV05IdXJHNGRNK0hoRCszYjBGTkttRi9EWHVLM2RLOG9r?=
 =?utf-8?B?NXNGSEg4RGU3Tm43WndTRHB6Tlcxb1RqdWhsUkFWMDkwYWtuSTl0T20wLzhp?=
 =?utf-8?B?MHNIQ2xhSHJFTW8ybCtZZEQwSVlYZ3J0TktwTG12SDNLY3Uyb0FGWkNvOXEy?=
 =?utf-8?B?K0kyUmg3V084dGF3bk1tSGZncCtBYlVXanozdkJCb1JRMVREVEJmYXRJZkRi?=
 =?utf-8?B?OHQ3Q0drZkt6TjdoOEZ5Yk5nK1lQejZwRllrOUFMbUhoUThTdU94MHdURTA0?=
 =?utf-8?B?SGN4WnltWlFoNGt6S2grcUsrNWxjVmpnUzJPZ3ZOblZqdVhucTNqZllCU0tE?=
 =?utf-8?B?TnBRQnhWWDl0SEoyL08zbU83YWNRSWJhWWZncCtSamNOQ2QzbzhPQWNsTUsr?=
 =?utf-8?B?bEVURVZUV21WaFJaR0s3WFdjQUdpYVJSMFR6bit3MUpXVS9Cb2ZaOG9sdVF2?=
 =?utf-8?B?S0N0YTM0UW0zWWwzWjRIeEJFMTlZMXpIYmpsSHlLdkxQczhON1FGM3VjZ0wz?=
 =?utf-8?B?Z0pRRlVPZXU4U0x2NDBFa1NTeXU2MExlZllUdm5zcW40Z1JJNzdpbzB0ME9D?=
 =?utf-8?B?K2FmazYwL0dWRWJ0KzVSTVRodXBkZWZPU3JJRHlNMGNxUDB3L0ZIY0lUZFNC?=
 =?utf-8?B?MUxjYnIzdEFzMjFsZnVud1hjY29LV2VoUXJDRUJ1UlRKU09BTGdtTm5qWkhM?=
 =?utf-8?B?SndGSDBIZWZIMFN3ZjJTREFIZDBEVHNLVG10cDhJWjR3ZnZzbm9NZUx5VjRT?=
 =?utf-8?B?cTJDSlozSk1KMmI2S1RYbnNlK0VRVGsybFNCVWkrbkRBd05BQkJPV0xDL0M2?=
 =?utf-8?B?N0NYVU1MNTVtTm9nYkt2Mmg1blV3UTlOV2RWZ1UvUExTM3BCdDcwTXFhczY2?=
 =?utf-8?B?WUNGNkFWVHZWbXJUSStmaE00elB2VEJVR2NnMzlUN2srQjVhZzZMVTRxVStm?=
 =?utf-8?B?OHljd3RNcXB3UURSL1JDSGRmNThTY2plRkQ0ZjFMbXE0V2IyczRsVTgzTkd0?=
 =?utf-8?B?UFVONFIreWNRdlVBb2JVa2FyVHpaa2RXK3FZS25hRzZMcDlSdVVvZTZvcXhZ?=
 =?utf-8?B?cksvczFnSkY1cnhORXBjRDh3MHpwUThWQzlJMVhwSUJxa0VCTXIyNUJDTEl3?=
 =?utf-8?B?NWFOYVRzQXNMSnZLRVFRTVg4SStINGJsYVNLL0FmUTZjSEIray9JTE9vR2x0?=
 =?utf-8?B?d0FOTnBaZU5YbFZNcDVaSmxyNDZ3QVdwazMyUjJOcWdrRkt4cUc2K1ViV2pa?=
 =?utf-8?B?cHZMekhNMjdEYWh5Vmc5TUpXUTFVQUxabkV5cTM3NXRUeGVsU2VURm1kVHBm?=
 =?utf-8?B?YnNmZGNsMWx2N3B1RWo5SWFMbUd0cEF3VnlOTDFaZFZRRVZpVGgwd0tTUGIr?=
 =?utf-8?B?a3h6SVFIVEx2dHJxdDVaeDhHOXpwelR6WGtQaTF2SmJldnUrbHVVSG9oNGdP?=
 =?utf-8?B?NGVQOUQ4M0JxM2pzc1ZrS0J0RVhVZ3RQTmJibXpieGFmQnBwZnhHVTA5RTRu?=
 =?utf-8?B?MUQzd1FERzdxcWNzWisrUmoyekFZZkE2ZmdobDJieVVDcDRaRldYZzFnWHlL?=
 =?utf-8?B?WDIrNFhPVjh1TFNjQjBQWmQzTFUzNHhSdmtNTXlXOEx1Q1UxSFRQOWN5TU1P?=
 =?utf-8?B?YWpGSXdVRHJyeE8wWk1aemxnUTlrbjhkZWlZR2Y2c1hycDRCRmFHM2d1SURh?=
 =?utf-8?B?OWJoVzg5N2drdURPQkE1b2hERTVqbkNZVjV4NjlYQkNZOTBHNDNDYStBTVJX?=
 =?utf-8?Q?VoIbaLetpJ8rOKLhDlbSIGu/R?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d534276c-d677-4bb0-b52e-08dc4e6b9bb8
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:38:46.4630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FYI7v1otR4MuXg23mtZNujXMF1xXy7uaEinPMPmBt6oXLj/yCkoHbQCBFCX3xhW4ra870KZT0tqFsv0hKsKqNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4516
X-OriginatorOrg: intel.com

On 2024/3/27 22:27, Jason Gunthorpe wrote:
> On Wed, Mar 27, 2024 at 10:14:45PM +0800, Yi Liu wrote:
>> On 2024/3/27 21:41, Jason Gunthorpe wrote:
>>> The SVA code checks that the PASID is valid for the device when assigning
>>> the PASID to the MM, but the normal PAGING related path does not check it.
>>>> Devices that don't support PASID or PASID values too large for the device
>>> should not invoke the driver callback. The drivers should rely on the
>>> core code for this enforcement.
>>
>> I agree it is reasonable to enforce it in the core. But I'm not sure if a
>> fix tag is needed or not. As far as I know, intel iommu driver supports
>> attaching both the SVA and DMA type (PAGING) domain to pasid. Intel iommu
>> driver checks the max pasid in intel_pasid_get_entry() of
>> drivers/iommu/intel/pasid.c.
>> I'm not sure about ARM and AMD side, if the two drivers only support SVA
>> domain, and have the max pasid check. Then fix tag may be not necessary as
>> all the related paths are in good shape on the max pasid check before this
>> fix. :)
> 
> Ah, I could not find the max pasid check in the Intel driver.

I see. May have a look at the below code. When get pasid entry, it would
check the pasid against the return value of intel_pasid_get_dev_max_id(dev)

https://github.com/torvalds/linux/blob/7033999ecd7b8cf9ea59265035a0150961e023ee/drivers/iommu/intel/pasid.c#L137

> 
>>> Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
>>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>>> ---
>>>    drivers/iommu/iommu.c | 11 ++++++++++-
>>>    1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>>> index 098869007c69e5..a95a483def2d2a 100644
>>> --- a/drivers/iommu/iommu.c
>>> +++ b/drivers/iommu/iommu.c
>>> @@ -3354,6 +3354,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
>>>    {
>>>    	/* Caller must be a probed driver on dev */
>>>    	struct iommu_group *group = dev->iommu_group;
>>> +	struct group_device *device;
>>>    	void *curr;
>>>    	int ret;
>>> @@ -3363,10 +3364,18 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
>>>    	if (!group)
>>>    		return -ENODEV;
>>> -	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
>>> +	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
>>> +	    pasid == IOMMU_NO_PASID)
>>
>> perhaps this can be a separate patch as it means this API does not support
>> NO_PASID attachment.
> 
> It never did? For something like Intel you can't use this API to
> change the RID's domain, it would break things. It is all the same
> topic - missing PASID validation.

aha, yes. one patch is ok to me as well. :)

Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> That alone is worth the fixes :)

-- 
Regards,
Yi Liu
