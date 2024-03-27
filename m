Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5620312E1ED;
	Wed, 27 Mar 2024 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711548733; cv=fail; b=TNLuAOwi20ujBFOIR+nnr/F5j7V7AsvU0wMRJ76t8ZFp4zjHwtfFmqSAxDjyCu3q2er57zq4/QQcHpQt7gHWlgu8tKuwf0MtUkibHvu54gxDFEd+OsHWAuFtAGNM9JAXwecpC6V4YA07yKU0ylQuAvo6IzzljLeR/bcF6CDwxIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711548733; c=relaxed/simple;
	bh=N3FYoHxFpojuMyEh58wNNuDJqwvatMNgQIqhnomNHRY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UwpHXRwEEJ/VjyMS07xxbwCzJf4z7odWkM+4olyL4a3wj0vmJNEwsGGM7lKl68YijSjqMeyj5FN+NkXq4Stgl9njGUC0qXq5t2zm41RM417+0iKIP46gBsiWni5jbp5N393xNxscsx/jzo13I9ubcly+CcZWc5xMzYjG0FyiIoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j16JmNEu; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j16JmNEu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711548731; x=1743084731;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N3FYoHxFpojuMyEh58wNNuDJqwvatMNgQIqhnomNHRY=;
  b=j16JmNEue87+r1JXZFMWavTrIu8hUlICXcT/Fzyv+fDjpq3jiWkDIqOQ
   HBVGazqpnUTbiv8UnGMzwh9h8YHg10xe2V9rSmBr2kYPnF6ip9Qc0lJ/A
   7nozekOZiw/f+iOYpOBm8WrxCpEKsY+bw+c/yq7/EP8L+2IrgSf/UXodu
   fHmvFZUN2lQARjtKnBNqdc4huaWgxiRXLuiFDzLBe/Z4aRCKgIqMaH9hv
   SuHI7qIpPW/c6A+qsP3SEgLUTsxwpYOxPWWS97e29KH8iDBCwpA2r2YG4
   DhrSnjA+BIfzrRc1i5JbMyG00Fg0f+AMVF+Z24rufO0b3jd/vcdvbTWnp
   w==;
X-CSE-ConnectionGUID: jOfwwKr0TFyiMQV6cYJkWg==
X-CSE-MsgGUID: i9WoSXJjRrSeTanLVBykvw==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6766052"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="6766052"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 07:11:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="20841769"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 07:11:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 07:11:20 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 07:11:20 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 07:11:20 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 07:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pam5y+44neeWz7ELmjRsI4otffrAjmN24n7ioHs8ucg9/jwhCJyC4nhTTVflSQnXCP9WHS+1fEstqJANLHhbk4uiq69AxhqN4Pym025rrowu3rXd6P0e50dsqtIf4Q1rmrkOThRzW2AdPx/R/gSdAzKvqsG3UxNOW6wZFhXZCblkm9Gd/x1m5KzFPDEmg20hMf/TPUWPK/nbYotj4RqBYJ3NeaBgKHlYftvfXcoTQVEMNugzUMjMAEdqBaZKi1qgIcR8tD10wAOmBPocbDAmWhj68dk2Qpv3Nfx+KFgwJ0TUQHJ/7FVWE+ifS8nQ4s2bwanKAzHLI8S4ycY8eSnXtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDv4PxRxm2NcMEXjCsa7Jz8kQrD9BRMyE/+urEd39rU=;
 b=fCaNrzGSLbNp42fo6vH94moRNB716pkXh63WIu46yPDfPYjeRT1L94CyeFNKryOTE26lBdxtYBn5X5GImMf+7lPisE/Kj4X2TJUPNCLsIQTaASjFFCX1hHbB4xFQIf/XCVohQzehxf5hEmtEV/23uqbZvyoeiVBroDeNBGnALygmaKL3hp0KUbF65BzFaRUCayjA9NZT512J0UPJZgICjHJnIaurWhyngB+yy3PM+5KIodRcjeX3DH0Hb7Wa9B7E297MMfMWz9fIfF4+HMpCLAtioJegixBDcMJZaXBrYCJpjpeB1OiF0K9Sm1ar/fQNXaRxejZiPplnwfA1gt6J7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SA1PR11MB6736.namprd11.prod.outlook.com (2603:10b6:806:25f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 14:11:17 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 14:11:17 +0000
Message-ID: <e8e0f7cb-b4a7-433f-a204-73dc0a976246@intel.com>
Date: Wed, 27 Mar 2024 22:14:45 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>, Will Deacon
	<will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, Joerg Roedel <jroedel@suse.de>, Kevin Tian
	<kevin.tian@intel.com>, <patches@lists.linux.dev>, Tony Zhu
	<tony.zhu@intel.com>, Zhangfei Gao <zhangfei.gao@linaro.org>
References: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0027.apcprd02.prod.outlook.com
 (2603:1096:4:195::14) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|SA1PR11MB6736:EE_
X-MS-Office365-Filtering-Correlation-Id: 0680e23d-9a18-4aa6-fb81-08dc4e67c488
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MRHTzoftoP38Mq16YgrAtLtNYwTmRk8NmpLmb5UAorNsz/CqzhEzlVXIsjXuvLEV4n6JoCzxUSoyj94XoBSZcxd8wp820Y3Kfk2CBwaGHsGxRKPLqUYnpu+HqSNjaTM2s1Cc5kLpdibktDIj7CakBgln4bsE0smPPtYl71qzBnjfPpBN6lXtcYdXT/DadvzTgKE2rbnP5g6HH7KZZuXAvMioDZL/64kiEzAkpqq1xDEeg+rgD9Z/GIEjpyXLnv8SfmLTC3BQ2N+oUuoCJbD6k7tSikCSbEAGiPCEqw1z1PkxI/RwTOafABbrbxHO61Ri5qmWeYOBaqWZHfIDEvXAyQkX6j6o8dQduRT5fDz9pNT0/AA9qB4RkxdrJBfZ+b+6zL+bDlg0XuqbNosVSxOTO8zbpoyqTSoH73Z1kCQKwFOFaz6ER0aPXTLAc3p3IP7TulXxmeIboh0x9jkNDBBCoYmrgZAI6jt2rUvxZLZmuHAjzE8KI/MM+4uFkxpBmadpKPvk3zNR0HXLoeyNxfmfiNrdC9StNU6KzI6NWHkFddZkXxSZ/+60K9sDzymiHpuwGtKcy/CXcu48x8NscwBtJWB6nJ8UZ2W7mTbtTZYrohKaaDHhSpH3X77v0N0P4PFXFX0npkEcKgD8TVSgqOto/rAF9NGmxI+922pGiMPZu6o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(7416005)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OCtEMENSck5rdmdVSWRZUXlrRmF5N2l3ZFpld3hoNjdYTzlKRGpJYXIzWTZH?=
 =?utf-8?B?czF4eG9scmNDZVBoQXRmTklIWlVOSGg4SHlnZFYyWkxoQVRMYW5lMzJ6QmtW?=
 =?utf-8?B?aSs5NzRjaGg5aDgyV0hvbitqeFlFN29UVmZCZTFTMG5sNXZ0VW8vdnp0Kzkv?=
 =?utf-8?B?TFJta2FlYk9ZQXYrS1Exa1JYY1FvWkd2M2lOb1Q3bVMzbGJWNTdFVmM0MTJQ?=
 =?utf-8?B?UnlPWVRjOGQ2c2pqQ3YyQ2YzZVNKajRpU09BUGZ1c2QrR2p4ZlRMaFRHQ3pF?=
 =?utf-8?B?Q1orK0RSTlovb1hLZWR2UVcvYUFpZFovcE9qcFBINTdEdXlDU0lTdERDVHFt?=
 =?utf-8?B?SEN2WGVqK3VjNXBBcU81dFBia3FoVVRtTTNRbGFodzRrRUpsZEFsbGozM2lq?=
 =?utf-8?B?Zzc4b1pEcTN3TjV3cmtjV3FrdHNEY1JaWXh2Ym0yYmp2dUNIS0xuTzlpU05Y?=
 =?utf-8?B?U202V2R0aWlGZ1NNczN1L2U1WFZZdnJqM0VtV000MjV0Z1oybFBmd3FsR2Q1?=
 =?utf-8?B?WkljSzBMYk9rWUJrVHFQZnZXVjEva01CZ1lRdHpMTkFJU0JSWnFvTStucDRD?=
 =?utf-8?B?QWlOZXBCdnhwbjlwenM3L1l6WEJsZExiOHZHOE1EL0xQZHlKbkM0cDh2WlRn?=
 =?utf-8?B?MU55UWhENytvRnAxdm9HbkZLeitkOVFXT0tRME92Q2VWNW1XWG94ZTBBRGZn?=
 =?utf-8?B?VDFrRU5iNzFIZVdnT3BSMVpnd0dDSnRvZno4cW1qRWJ4anY2UkQvSmQ3dWdQ?=
 =?utf-8?B?ZlV6YTlvNWltdklNVHlQd2FicTRUb3dkbWY3NzBFYTBiTzdvMHlDTFJjYTdI?=
 =?utf-8?B?aVZwUU1sRmt3Nm1SdWowNnBXakJ4V004alNRZncxS0p0QVFKb05PTS9uOEwy?=
 =?utf-8?B?S2RHdkQ4aXJFM3hwMjZZU04rTnNSZEdtYUJXUDVmN1JjYTFPYk9vdDBoek5E?=
 =?utf-8?B?SFFoYm56NldCUkJXcFNUdThUYTBYZzFmeDRGa3ZRdzZ6VE9MNE5Welo3dXhs?=
 =?utf-8?B?a28xTXBwaEJqemh3UUkzbGhWYWo1TDVEc29XdWRPazhncUFRaFRNeFYrOFN3?=
 =?utf-8?B?K2FPTVBSaWVmcEtpb3h6NjJ2OTFXdGdEdkl2Q0pKZ2orM3huRit2NmcrbitX?=
 =?utf-8?B?ZFNxTFFWT0tWOE1lZ2lWRFhtekFWS0prSlJhd2tSQTRqTW8yZjR5Vyswc3hR?=
 =?utf-8?B?ZUpINCtKak4xNWFyZjlJQTNBSG9RT3Y2SXkzcXBSaXJrZVcvQ1dmaGlvODU4?=
 =?utf-8?B?MnpvTk0xdHVad1RuVXhZR2FveUdiS1o3MU9qdE1NMkRjcXZmbUtqZUMzOHNC?=
 =?utf-8?B?YS9nRkhhOHdCZXdhUTdqUjZRelhqSzlwcDlON1BTeVF6RVQ2VXNaVDdTZEhD?=
 =?utf-8?B?QTdpMmc2ODdwZm9FcXRnaXp6NUI5ZFIvZFMwZmltZ3Z1TUpJUVBnSXpxb1E1?=
 =?utf-8?B?b2htcHZMbm5xaDRkU0Y5eDhuNmx3TzQwYWg5UU9Jcy80TjYyRENqYWd3OTlC?=
 =?utf-8?B?eU9hYnJGaGtDV2NVTGxkQWhRZjh3RzQ1cmV4RS93WitoekthaXNiV0V5WDdO?=
 =?utf-8?B?cVAyNmNkeTE0WXBKR1ExNlhwRnkrOWE5SHl4K2Z1emtVUlJlWW5EMkZKNFlS?=
 =?utf-8?B?V0pqUk5JcjZ0aWRTVGt2bXl1emI3czJ1bHd1OVRleWxCVnN3ckN0YU8rWmYx?=
 =?utf-8?B?M0h2MXZ1anppdGsweWI1THE0NnJBWitQdkhHSEtCMmg1UWNDY1ErQjZBQzVK?=
 =?utf-8?B?VG4weHpSbVNKbGtmemt1V1VWNnBlc3JObUFEVDRiUmUvOVpUZGNWdVpWOWJi?=
 =?utf-8?B?V09uekxLa24rK3RLbXl3eGxXbG9OMEFkc3FUZTBtRjVxSVpXM2Q2aWNVNGI0?=
 =?utf-8?B?M3MvdmtwcXgzVDY0TFpWejFEWmN4N0RmMEpmVXlDLzNETzZvV0JweWFNc1ha?=
 =?utf-8?B?VGNTZ2J1dkprR3A3QWw1QVlWV1BkR3F6b3V0L2huYWtuZ1lwUDRWQS8ySlR6?=
 =?utf-8?B?WFFMcTVZK0ZNWk8yWlVCemhBYllGWWZucldwajd0MzNTczI4Sjg0eW9udXRJ?=
 =?utf-8?B?ZVhLOW5wVnZ1ZlRpeCtLbytLenF0YXdEUldoQU9JczF3djh5SzNCaVRzcVpL?=
 =?utf-8?Q?Tud4/5OHeT5endq+poVTbnCgV?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0680e23d-9a18-4aa6-fb81-08dc4e67c488
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:11:16.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1YOSEgfFD5zmb1+Qe7m78OIhX8zOELFAQoFd47O75OmrqSaTDa8OJXkmwScBd8wkI4uGekO0TtPs0cnBlJSimQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6736
X-OriginatorOrg: intel.com

On 2024/3/27 21:41, Jason Gunthorpe wrote:
> The SVA code checks that the PASID is valid for the device when assigning
> the PASID to the MM, but the normal PAGING related path does not check it.
> > Devices that don't support PASID or PASID values too large for the device
> should not invoke the driver callback. The drivers should rely on the
> core code for this enforcement.

I agree it is reasonable to enforce it in the core. But I'm not sure if a
fix tag is needed or not. As far as I know, intel iommu driver supports 
attaching both the SVA and DMA type (PAGING) domain to pasid. Intel iommu
driver checks the max pasid in intel_pasid_get_entry() of 
drivers/iommu/intel/pasid.c.
I'm not sure about ARM and AMD side, if the two drivers only support SVA
domain, and have the max pasid check. Then fix tag may be not necessary as
all the related paths are in good shape on the max pasid check before this
fix. :)

> Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu interfaces")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/iommu/iommu.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> index 098869007c69e5..a95a483def2d2a 100644
> --- a/drivers/iommu/iommu.c
> +++ b/drivers/iommu/iommu.c
> @@ -3354,6 +3354,7 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
>   {
>   	/* Caller must be a probed driver on dev */
>   	struct iommu_group *group = dev->iommu_group;
> +	struct group_device *device;
>   	void *curr;
>   	int ret;
>   
> @@ -3363,10 +3364,18 @@ int iommu_attach_device_pasid(struct iommu_domain *domain,
>   	if (!group)
>   		return -ENODEV;
>   
> -	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner)
> +	if (!dev_has_iommu(dev) || dev_iommu_ops(dev) != domain->owner ||
> +	    pasid == IOMMU_NO_PASID)

perhaps this can be a separate patch as it means this API does not support
NO_PASID attachment.

>   		return -EINVAL;
>   
>   	mutex_lock(&group->mutex);
> +	for_each_group_device(group, device) {
> +		if (pasid >= device->dev->iommu->max_pasids) {
> +			ret = -EINVAL;
> +			goto out_unlock;
> +		}
> +	}
> +
>   	curr = xa_cmpxchg(&group->pasid_array, pasid, NULL, domain, GFP_KERNEL);
>   	if (curr) {
>   		ret = xa_err(curr) ? : -EBUSY;
> 
> base-commit: 4cece764965020c22cff7665b18a012006359095

Overall looks good to me although one nit.

-- 
Regards,
Yi Liu
