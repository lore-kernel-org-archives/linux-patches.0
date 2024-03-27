Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808E112D753;
	Wed, 27 Mar 2024 14:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711550628; cv=fail; b=l820nOuv4glNdgfJz10GKbwQrIbuAtcaQ8fWe9w5HHZMIMfYmCgHBtKi/TIzhKam5ozhVu2t8pr+01FLyb0jRq0rjnqKWwm+pTZxWhhSmlkCQ829XchRyXNXrV0T7o7YV+8pUpv7a5zUW8x7CofXD8YhfaZWgzSD3G3689zDt0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711550628; c=relaxed/simple;
	bh=ueKfFNg8OucoCw0L18m4CegTGVImtpL18zuLF8d/ujs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l6F/+yq2qGgzoOBxUo0ArtSQjNFmEa9GEIBDreXj54NugBtJV2DWgnl4dQP8WgfRiydfeTfriPvRsOQVzUpHppRoP3e8phlK7qu2rDJoUvxSsYBJxP0l8nS+gOoqfLgBh7mO1vSE/wbEowhF47PlkmhnyM88zLJP2fY05lsckBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ABhisd4F; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ABhisd4F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711550627; x=1743086627;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ueKfFNg8OucoCw0L18m4CegTGVImtpL18zuLF8d/ujs=;
  b=ABhisd4FXCrBscnyX69Eq1399WHLdpnW9DGehXykWsPxLsF5i/AZgOCL
   M9FSWyR17zystVFAs46r3b7KSzAxd+IEizn9rb6K/V1EzQijD7YKFxeZg
   IInDPXvggiffAEqSRgfRnEXg1QwoGBjni1F2s6sVjYHWtlwkMEsf9xL5S
   IFe0q0APa3HkSgY7qyvzzVtwV61mHTKZDXpgVdmXXhH088bokYkioO0BY
   Aafua9UUhAbAqwRHfOqAF7p1tK1lxVJ7rXxlTA/atXm3g1FsknstiXxFR
   rWYvu4YRy7FiVqJrX1GUlkUlclHByXBaPWU8GWwBJmti1MBuX0MdjlKBM
   g==;
X-CSE-ConnectionGUID: BP+GohPoSja2QiakgA0VvA==
X-CSE-MsgGUID: TDbvWbUzS2i316fIKPWEUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="7259049"
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="7259049"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 07:43:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,159,1708416000"; 
   d="scan'208";a="16768659"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 07:43:45 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 07:43:45 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 07:43:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 07:43:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 07:43:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oQ4vIxv+Jfpoyu0gZZz5hgxzXyQ9u06j5mafOyhDAmIeo1s4CdNlMzPaF0P/x9vKeD6NgA5gzSsyDJLIMKMCdcqKnKRYHXBkLwHISlrLo3p4Yht9snSn4pWTbrK4dyDitkB/qEZ2sToFAvdoqCFrGZ+2B29JjRU3j7GXMfqkie3mI5Uk+eYV8H2d12pj1J+rWWG5UWyOBN5eNKlm2m+3KictQk9yGpyevWE1fQa6dyQEybQvbQD9Io5V7CCxLbOoeQdZAizU9etJuQRlp9+aijoPJMCg1jzERBVum8qFSqXTBveiKne63HXwafbd/0Ul3sQHut6O7+POWDJlh1cPkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GWjkVHaQhoi/T49sKYkKTUquO/W0Mzxk3lXLOR1Bd5w=;
 b=i401LHmFuh96IeOJk5gj0fFDKIGQuGkJGZNOfwpl3vFCfwn2BU9owtv5j4+oZ6mA96fLAt9NRDWgx3KyUJAjSIVMYN+PyPmX6INNz211UroulGSSa0KUJv68x4C6oES+T44F/9zBCm04ZRoLtX5DN5kQEl9fSnWceCQmtD22p284+140ZItnNphm+91vC2MR0QsPTwrVnBsUnhj5c7pvmhvD/XNxP+KAClzzL2F5Fvh9JkelqiN90gbp8aw+Rg+dMhMvIC6sDrTGz4Oh0cSU1HYq3sPAra/IpNNgvu87CORj/C+LCiouz8x46OhiTcnXgNhkLsnDSI+0BR/un81Lyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB5967.namprd11.prod.outlook.com (2603:10b6:8:72::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 14:43:05 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::b1f5:9d1f:f510:d54c%3]) with mapi id 15.20.7409.028; Wed, 27 Mar 2024
 14:43:05 +0000
Message-ID: <f613ef00-fa57-4122-9bdc-f4b32a14d480@intel.com>
Date: Wed, 27 Mar 2024 22:46:35 +0800
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
X-ClientProxiedBy: SI2PR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:4:197::21) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB5967:EE_
X-MS-Office365-Filtering-Correlation-Id: e8bcc48b-ee94-464d-14b1-08dc4e6c360e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LILFicf1eXHwf3uOx1IU4pu4sQAqwSfK6AUqakOiPwBfQW7nOeHdmcLVUc/i2flKmloz+ycWwwzqObg8U82G4U84/fdXvvBCjE0UWTHwsBZdNdMJUrP90PejJnAJ0qEpyOgW8XxOGKvfQeQ7KWcUAOB8qflta/Zd6Krv6asF0snq9OrshaxuKw1D4Mp1uwbTUbOErxgScA8tP4/o07RM9GU/gt0zJYw6qLqwVnIFSn15mNJARJuaVsJTwiAm39dqSpyd7FLWxlIWTMGswAVJaGEp/XIoo/5AANhcgjRT7v8RHWV2pb0EglrP1l8y2S5lOH/QnuZQ2q7BCFnbFN+RAoGos/oM91oQj1HaeGNyJkjCzScH/fP2zRIKa9UfBgZCfpnB38u3u444i2WhFIEnWULW5LiMAWjjs/dkD7CkumsQLnN5YvFyeRG0+YlHYy6t3OZMfl7N174u8jb1cCtRgV9qdgFai7pzuD2phDlu/0yUSekc/Xvw6N0DYDZ9rgyd237wnyqpDTkOEVY3VsknwCddtCC+EfZFSRYVOcPMRDSQQRyosGO3bXDmOD3YyMh0fM0Q+7nlA+jutNtSGtuHxzxzoABSixnyXtzv2jjes+FKviB6NigzXXXipwSYQA8pz7uKpDOBXwRwfHJ6nPClYg3oapWwNZKy7M2Jt2SUh1U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVRldy80S2tIWjZtV3czb2NMeHM4N1NmVFhtVnduQWRpVGY4UEo3Ui9HWkVE?=
 =?utf-8?B?T3NJZ2RJdU54WHFFSEI3c1p4RDIxV0c1MGh4M0x1NjlGSlNpYzN6SEQwcVRK?=
 =?utf-8?B?WnlZd2JGbnhNZHcyREJrRWFJTmxzVlZIOVlIYitaK2J1MGlYU2hRQ2RNU3lK?=
 =?utf-8?B?aVl1ZzdWTEpwTUZ2TXFJNlZLQ2MzTFZIbnhuVitjandJM1gwY0RsWVdiWjFx?=
 =?utf-8?B?bTY3bUpkMGYzTGxSNE9DNEoza29ybmRSRjVGNllXb2FBUHV6aG1BWTl6bGJw?=
 =?utf-8?B?SmN0U2Q3UFp4bGRWVTloVWlKS2Q3dXEwcXZLYVhQZ1FmVkRqOG90Sk1yNlpV?=
 =?utf-8?B?ZC9ISm9ZOGxITXExb1NMR3Z4bER6U0FJbk0yZUZPNXhXMWhPWmlJR3h0REU2?=
 =?utf-8?B?THdiNHNHbVFXcVBHbTdxOEpvQitnb3dvdVdVSml0NnRnZlJObUx2VFFRV1lh?=
 =?utf-8?B?M1VpVzQ5bzRSK2lFUkVSWjFsK3NRb1hPVFhsVnkrNnpFaFNqa0xpNTZ0ZmFG?=
 =?utf-8?B?eU8zMTFRZEhMZjU0eFlXa0VQZUFxQjhHTjlMM2RWT0JBaWQwcGpkd2Nvb3FS?=
 =?utf-8?B?M3I1SWdiQXlJTGErYy8zVW4way9sakNoK2VhTktXY2pHeklhaW5QY053ZWpQ?=
 =?utf-8?B?YnFPRTg5TjV3VFFuajdZdVREMmpNZ0FuY3V0dGw5ZlRMTGhicHlxT3VFbSsw?=
 =?utf-8?B?dXdBRTdEZWV2NmI3TnZRNzc0OXlGanNHbjdoUzNTZTd6b09iWkMwbjQ1eTEx?=
 =?utf-8?B?V1l0Y3o1MWRNOUlLeFlaQnZncU56VEI1M2NqL3owa3E0MG9iY1pJdHhId3VB?=
 =?utf-8?B?RlVBazdNVVBGNUxFUTlMNDlPbnN4V3Mwd082eUlQR3Y2c2ROcXkyOHNPNCtt?=
 =?utf-8?B?dkZyNG5hekRGRnZRME1lYkwyclFpbm1jVnJicUVuS0RtVjBIWENPQ29lYW40?=
 =?utf-8?B?aFBFYmFlS0p3enJGT3RXeFl2TWhpK0xjWFV0RFE5V0JZWWNLamJKOW8wYXRH?=
 =?utf-8?B?dExDMFhBR3AxckdnbkM0cjdLd25hc3BGQzI5L1EwbmRrZjMzYWdjUEY5YXpQ?=
 =?utf-8?B?ek5jT1o3REtlWmU4L1o5anpTd0FybHhPUStBTVFLL2JiRmFqdzE1U3JBM2V0?=
 =?utf-8?B?emRmYkVYTlBYV1ByNzRFeE9qQVd2Ynd1YTFObTRLM3QxUWtFWVZoQWVpMmo0?=
 =?utf-8?B?QXdnc2ZaT2l1NHl0TlkrVVZUZkZSeG9uVnVzK2FseFVWZCtiMFFIM0NQOHhC?=
 =?utf-8?B?b1pBQWs2RWFhdWhPWW1JYnRjYjRZTGQycXBqeTJEVHd3bXpqTi9XU2dacU1C?=
 =?utf-8?B?TTZ2WTlwbmcyS0EwVnd1ZlZiTGtOeWZxMDF2a3hxc2JEdVp3aU1QTXU2eGF1?=
 =?utf-8?B?MTNVTVE5QVBnSWRvYWw1eGw1K0V0VWlIVkV2NGhMcURDM2JIa3F0MnRMR0xQ?=
 =?utf-8?B?b3JrTTZKbTRIdEV6ZXFyaUhRU0JiTHluUWR3bEk4cHQycmJlTUkxWnhQVlZO?=
 =?utf-8?B?OHlKWWIyZ3RrMElTTnlZaUFIQVFzNC9wWGxjdWRsZGdjaGpnemthU214NUtT?=
 =?utf-8?B?aTdYTnNBbHVDakZUc0lOR3VFbklSOU5veFRKSmhaOWY5SlVEcDB1bmZjcll6?=
 =?utf-8?B?NVc2STdTUThYYm9rYStOVHJubjE3ZWZHUVBHUkJUZGltNUxMZE5lMXcvVEpu?=
 =?utf-8?B?cm5TNjY4bnV3ZkRUWGtKVTA1VUpLNEozT2F0di90STVVMnZ2TVByNDF6L0JG?=
 =?utf-8?B?bEo0MHhvUUdZbWNYQ2xJQmxBOG9rZHd1TUE4MXA1VTRWV2x0elhwUnZCRE9m?=
 =?utf-8?B?QXFSbjBXcGFyV1dvY2tGQldlM0xFSi9RMmt0aTRxTFVHWjBMRUVHRURncEEr?=
 =?utf-8?B?VUVDclR3YmE2YmlVNlhSRndZTUE0MGRXRnVFU3M5dzZSeGg4MjRmSytKb2pN?=
 =?utf-8?B?RXI3Z1dPaUdOdjRZSEY1TTRLcmtkSVViSkVpYktyMUsvZDdkUks4Y0xGcDRt?=
 =?utf-8?B?QTdGU1JsQmh4U1M4YWpxaGdtakxtT0F6em01SlYvYVA1NTNMZVNDajJqNkww?=
 =?utf-8?B?MC9oRFFkaGExbkROZURrb00vQUpCQWV2cHFNOGcwNzEybnpoZjJDWHhxWFox?=
 =?utf-8?Q?ZnV2451xZm7Ej8lyMLqY/BhB6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e8bcc48b-ee94-464d-14b1-08dc4e6c360e
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2024 14:43:05.1445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iA3fZVP68EVdOfsF4GXXdVTCHvzRN+Cw43wLTMLkKjKn4qURjOlgFU5T5cX6/KkvyUeqxhxLd8t2HaI9waGCCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5967
X-OriginatorOrg: intel.com

On 2024/3/27 21:41, Jason Gunthorpe wrote:
> The SVA code checks that the PASID is valid for the device when assigning
> the PASID to the MM, but the normal PAGING related path does not check it.
> 
> Devices that don't support PASID or PASID values too large for the device
> should not invoke the driver callback. The drivers should rely on the
> core code for this enforcement.

BTW. how about the iommu_detach_device_pasid(), should it also validate
pasid?

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

-- 
Regards,
Yi Liu
