Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B5034778C
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918113; cv=fail; b=lIx8zo6XvTtrY72aupO+yMdt/rKCqdlzb23Teqe39775dEU/Ao8ZCQInRD8Av5UZwf9duDTXZdmnfgl0BVktSDHgUPTnKgKHbyX2TWrQUZQEqgTlE446/0ikwbmcwZ0Xi266aSYSRh21siG3RdqM8WuJy0645OwuQ1nSz1RiURM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918113; c=relaxed/simple;
	bh=xrtdl7m8H/EKPgGKKceJ/WMh98hfV3j861VLGFTR0vA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bl3niCPzwvslkg0aBZ3z11SG70hCYbvsunqcd/symk3Hv7uCq7r4qinIP/7Q7Plo13uRF87lpAuGSAlnCOlMc4ISjzGerPppnAl4YInfD02L7oZYZUYtbP7cSwt/12fxEbia9qDZI6DeW6EWJtb04b9ent7ai3u6lUNiSvVssWk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l9jmg6oz; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l9jmg6oz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918112; x=1750454112;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xrtdl7m8H/EKPgGKKceJ/WMh98hfV3j861VLGFTR0vA=;
  b=l9jmg6ozJ8mTR4teOtGP8jfDhi+nb70CzHD7hn6Rd+y1+cYhTpkcvIaU
   xkPDujKzbiQMXzFgvJ8F9ZYjvneRD8Y1jiTApQTsAgnmCqs+5K0v5LMKK
   DgtYTVKl7Qq+qgNvBN4KiSLmFyU4Y0frEoxUvr1I2rZWFbW9ht0HD7pQD
   oXPifbFYqJLXXqPgOYhXtApdkLeoe+GgjGOE7SjQ8Fr472Bo3RpZ3DMfm
   OratlzNWduEF2eXGWN1dtOWV7KjirrddZOYehjdnEpDT1htzFtmH8qco8
   4FyUAmxBg30wB/KfB+VDsrcTcufbSOyv7Hd1MlROSeBXDU/NrsE1twpwS
   Q==;
X-CSE-ConnectionGUID: Ok9ci1XZSuG6JNcRDgG7ww==
X-CSE-MsgGUID: ohLdA5pHT5GSSSMDnoncMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16056839"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16056839"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:15:12 -0700
X-CSE-ConnectionGUID: kJNE/7D1RS+7zy8nZZB3Qw==
X-CSE-MsgGUID: /Necy+MQTeWL7GHkHnvJqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="47319351"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:15:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:15:11 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:15:11 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:15:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:15:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cnCqgO5m7/5y+ylXpXk78DWUkNTaTXewGm/Y+T057Zb+9BDrZZuGaJGMCSSwdzgNWWDg6FbDCNNZZPoLox/gRWq3O2U0koPun6fAok6Ua09ldxtzVgaDWpwkJ8Vqh0e/TpKfM7g2kG9Lllt8yo8erE+tGdRa0AkAcx6sRwSGx/5QxF/ut8YSwbGHGkW4si4EOiYjj9x39A0jsiYZ5nZP5F4/YkoTaH4Z4ZM3HzAxY8EnXtniUVDDtzPPDwrT+obF7O3GnCSd/ETQC3hvmeAPa6oFuBNz/S2u0eco5HKyEiVXiSmASZLS16p3bnn7s6vSrCab695rpPSPgDm6i7z+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQqfMK1vKD8Gn0ovOyDqHDRN+mPa1oARDiNf/zAerNA=;
 b=d+Ce9wZe7Ng3mLCOl2OQ/uY6VEw6Ge+UMOAF1oU9m4Jxh7LRwrAXJzHt2y2ZlXBAtKBlKC8VyXYBBvO8v0QRpiVHUC3INTCkab0ITamvlKG0aX4kd9lYL/v+JHH7KDQ36yG+IoTBtt2hX8no0pOh8mVMnR5ftsEFJB/aLRySz35aeUzKYr2ZFeDvak7YPYxq+LBR2kDiZ09rMNWw42SG+tTgKIwxyHVhXrgdQDlClyPxFWFqjYliULlqYsGePF1sOmkE+YAQIpZ95BGR7RzzJZTzuplR18q7y322cYBabnASQ/MppvKILVM2M8IxOgSMLbe1rht6Lu0LpnWFqBh3Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6878.namprd11.prod.outlook.com (2603:10b6:510:22a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:15:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:15:03 +0000
Message-ID: <9620f9ac-c4a4-4f66-8ea0-3ea419294aa2@intel.com>
Date: Thu, 20 Jun 2024 14:15:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 05/18] x86/resctrl: Add node-scope to the options for
 feature scope
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240610183528.349198-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:303:16d::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6878:EE_
X-MS-Office365-Filtering-Correlation-Id: dbcec30d-2ecd-4fc4-961f-08dc916e0d50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aERoVGw5K3JHYWQ3cDBPZ2FzMVhrZ1hXSWJwelBnVHB0SDFyWFJRYklrMlhw?=
 =?utf-8?B?am5QRVJ4S1M3cHJ3NExsVjVwV1hUc3dMRm1IYzl5Q2RteHBBejQ2YjlaQTVN?=
 =?utf-8?B?Tm1Mc2xFak8zQTllQkkyMWtTeldZL0NHakpGNno2R0VXZERGSzVHVGtlTHVl?=
 =?utf-8?B?OHpQVnI3eTRicTI0VGgvZVRVN21SbFhiV3FsSmx0MUJhc3pGc2gyWjR5dW1u?=
 =?utf-8?B?N21iekRwbzFTZFBIUlY1cmFsVEc2T1pENkFWYmlKejYzM3JiaXdudFMwV3Bq?=
 =?utf-8?B?dWg2a1hkQjJ1OC9FOFZEVGhJWDZTNzlDaXdiSURwUmdEY3A5dnZGVHhsbTJK?=
 =?utf-8?B?RS9KOFZqSW9ZQjUwd0NGaDZCWHJNa2xBVVd2UFFYcWRxMVFLOXpUeXBSMDFz?=
 =?utf-8?B?TWVWSm4rUlppb0JsUGF5eExsVGFwdGF4WGxRR1NNN21vdFpkeFo3NWNHQVYx?=
 =?utf-8?B?WEhrUlllSE44NCtQNkFjUXNzT2JwYjlQQStIQ1JjTExrREdpK0wrOTVjVWlF?=
 =?utf-8?B?WXJNQWVNUTgyNGFBL0NqSUp1cGNmeG45NUUyOWJ5OTdFNzBndnE1MG94UTcy?=
 =?utf-8?B?U0xWZitSVng5NWZKajNHRHE3ZVJTOU5tZTRidW1WdnBuR3JYY1NVT0pXanRN?=
 =?utf-8?B?NjBiRi92VEFmd3cyZ05OODJwV29IVzJDdkNCTCt3MlBQdHJmV21YN0hoaGl0?=
 =?utf-8?B?cStMSUZXR0RzdE44ZDBhaEI0RzVZaTZZT3Y0ZnV2L1BBelhVOFhpdEI1WkFz?=
 =?utf-8?B?SVdhNXdxam5MN0tNM2Y1Zy9CdnVQRFJEOXV6clRMY3MzeEsvbXhTWDlpZzF3?=
 =?utf-8?B?d1NKSG9sTEZ1eWxpVzM4VjFleTRRTHd1c2lUNWYxOUVZY3M1a3IvUGhLT0Fi?=
 =?utf-8?B?TzNkdDV4bExzU1N4bHFkZmtuQTk2TlVPV2d6dDV5N2tYbzlKaWJ6b0lHZTVm?=
 =?utf-8?B?SlVBTEVLNnR3U3ZPMjUzamh5TUx6Ukx1UTN3T1kxY2twZ1NMWm9PdWg3MnNn?=
 =?utf-8?B?SldDZnBTbVBBdEUyNjNhMis1N1pCT29mMjNLU2tBYkdxdW91MlRFSjdHdjFW?=
 =?utf-8?B?dFR6TUpXSHRKdXRmcUF0TUZJVmFITDI5UzVKZUl4RFpEMnJvMlJpMHVsdkFU?=
 =?utf-8?B?dnBxa0pFL0Fnc1AzZjBuOHpTRE5qSjdyb25HNFJhRC85MjBrclRaakJJeDJq?=
 =?utf-8?B?ZkowdWU2SG1zdnEzVUhrUmFyaHBSVzM4UzhSNW1rckxHYjlrQVROdCtHNTlS?=
 =?utf-8?B?LzQrK1F6bCtvYTlySHczQnhYb2tETDY1ZDNCcVN5YVdGN3NpTGFlUVRoZm5X?=
 =?utf-8?B?dkdQVVhkOFRXa0MxUDdxbC9NMjhweFo2c1M4cVgzZUYyb0JMS2wvVUk0bWJL?=
 =?utf-8?B?UDVBRGxSV0FtOXZiMmdjU2s0ejkybmdjU0dNb2s4Rm1RMFZUbnhKbnkwWDFF?=
 =?utf-8?B?WEJRZU1MUFBEamk2d253dS9qT2tja0dEUHJiNUw0eFRKY3pzM0ZFSmExVXVN?=
 =?utf-8?B?UzBQdGYzdWFVY25XNjZHVEI3ZnBOeE45cGs0SmVHK1BYdXJXMGdnanVGcDV0?=
 =?utf-8?B?cmU0MTcvb0xPaHlSOTkvVlk1UWZkRUlNUlVsMTZjRXZrOVNEQzlLeUIraU1t?=
 =?utf-8?B?dWVwb0VrNkM4eHk3cUdiVGVSQVcwbll6V1pkUnRTb0w5ejFnRzIrNk0vOXVG?=
 =?utf-8?B?VzdyanBaekE1NHNsS0o3VGxFZ3BYOVZMdVBxSHd6S2hxZS9zL0ExbEZrRDZ1?=
 =?utf-8?Q?/LokbQVMzhf6iXWv9U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0hCaE5mUmJBcm1kSjlNcElxQk9UTWNMZnF4TVM5ckZUZStsbGZPZTAzL1Zx?=
 =?utf-8?B?bFdDU3dnOXB3c0NBVjRDMnNVb2t2dDUwMGcxbjZnVm5NZHNDTVdHRnJxNk5F?=
 =?utf-8?B?Q0R2VENDbVFlWDIrcXN2b2lqZXl4dFJLQUJJSE9RTGtpWWh3eVB4YWR4MFdK?=
 =?utf-8?B?ME9MUEloZEFMSEpJVi8vMVk3QXRUZEo2RFVRQldTTmJlazZ6Q3hId1RQaURh?=
 =?utf-8?B?OWFaMi9Cd0xRN05IMGdpdllGZWdGWUoyVFFOQjlVbC9oMkY0Zzltc2lHL0xT?=
 =?utf-8?B?SXJnMDdULzA0dSt1OEhnTG0rUjhoQk8rNkcyNDdzYVBxSXNIT2lQN0Y1ZWZr?=
 =?utf-8?B?KzYrOEJ3b2VhNGM5Vkd1c25yNG1VbzE2Y2prR0hEMys5b25zQW1kc3RiRlZh?=
 =?utf-8?B?WEFIeG1xd2xid2x3K3c3SUtmc3UwVVV3cGdLMzNzVXQ0ejRPTjFmdjAxQmtT?=
 =?utf-8?B?NEpMRHg5N1FRYnNEM2JIQmN2TjJmUWVzYWpiZFgyeTlVSTJZSCtybmZnM3Yz?=
 =?utf-8?B?ZzJpOTAzMlZiYnNPMmJHVzcrM3kyc0x0bnZQVko1aFp1SXROYVFCK0VsZUtj?=
 =?utf-8?B?MmFMcmNVYTJHWi9OZ2NlbHB4RE83cnorRno1dnlMR01Rck9INXUyemFWUFZX?=
 =?utf-8?B?OWl2ME5wUUJONGdzSmdpQUFQMUpWR016NlN6c2x2ZFdTSHRiUjJDd1BFRlRv?=
 =?utf-8?B?dlNjQmNwOEMxTXJjVVNySUxNWGE2NDlwbnQvamt0b0FxUUU2S3JwQ0ZtQVFL?=
 =?utf-8?B?NHNHMVh4YzBpbE9QQW9nZ2l3TnN3cXU2K3ExbFIvVlJ4RFlLeFBsb0V2RStX?=
 =?utf-8?B?V2VQZzNqUnlaTUdTRGxLT25HbEM0anRCSnVCc1lTdXlJZDZHM2tGZmovR3ll?=
 =?utf-8?B?YWdUMjlaaDJodXpzQTdYS1IvM25tN3U4dThlNHdWRExuWmE2eDFleGZxS2lB?=
 =?utf-8?B?TjhuellBL2llWXBCcmk5MjVWTjBpVmoxU3I3WVY4ZzNvNGU5KzhhUklEYjVh?=
 =?utf-8?B?cXVidHBOQWtFT21EMG1EZWs3c0lQOFpuUnpmd2FIZFNLNDJuWUlveDBNQlkr?=
 =?utf-8?B?dmxrVCtQcGp1dFJ4M3I1aTJCZVdqbExaNjFIUUwyWXI4dWZ2WDFRKzVvSTFH?=
 =?utf-8?B?aDJhNEhrOEQwMHpOOEhnMEpMNWZXcUFzQ2tOVlBRQUhmczh5ZStNNERtaXFo?=
 =?utf-8?B?MnBSTWtKRlpTUlZrcTNhWWFJTnVsNHM3UDFmbW1EcEFnRG1FQXpPZ1pLZW1T?=
 =?utf-8?B?OVRvVUZUV0w0YTlwWGpZQ0FoaWRIVE5aM2xVVklyREtLSi9kYllRcEs5TTBk?=
 =?utf-8?B?V01xNW5VN1YyaUp5c1hqVWR6YjlwcEw4ODR0dTNUZU5SSndMbDBTTFBQS0pq?=
 =?utf-8?B?SFFZZFdDYjVJRUFGU21HaktReVp1NEJlSnQwZk5jNkJtbEJEeHFjZW1YcDE3?=
 =?utf-8?B?UUZqV2taMko5NmxNM082MUg4b3V5UHRqdVpOR0YwblRDT1ZuNEpJVVlSQlc3?=
 =?utf-8?B?dkY4VkpVaUI3RUtMbXpmVnBub1hUUTlqN1BjSWhnSEhUWG5hRHdDNDI4SE9T?=
 =?utf-8?B?elQ3MlZMWmp0MUpmK3YvSStlN21GK0hpSUZENTZpVE9ROGxNS2E1aWdDRzY2?=
 =?utf-8?B?eFlPVlpBbWFCaldYdWZYLzVQekNpVTY3bGpBczU4WENrL3VhOGdSWHBEVldl?=
 =?utf-8?B?V1ZITVl6MGdaSXNBanVhN1Y2Ni90dTA4SjNJRTFMMkEvL1VTdGlXcEZWcG1X?=
 =?utf-8?B?N3l1MW44OXRKbjkrMmlwVlNmaHhybGpIZXp5TlQzamVWL3Q3MitWTkI4anMx?=
 =?utf-8?B?UEdkNEpUMTlKS3NTbmxpZ014aFAyN0dGWXVwcUVwdzY5Z3NaaHJsN3ROeG5G?=
 =?utf-8?B?ajZlaWpNUWFwV3pDYzRybTlMQ3RseS9aWXBUbkNRM0F2eWVGcUlUbEpvbE5w?=
 =?utf-8?B?ZURldmFOajZ4dFc0K3gycEtXdjdaRVU0MFZTbUxDOE5mdjNRWHZqT2ludFhv?=
 =?utf-8?B?VnlpQ2FrMERsSkdaRmRtaXA4NHB5ODBUQ2lzZmUrNFlFOTNUUm96MWRGdFZZ?=
 =?utf-8?B?bTBKakg1dklUOTYvMzNFSGN6elFHMTdWcGsvY3ptNjF4SU9BYmYyMFVkenIr?=
 =?utf-8?B?dFVyTlc0S1hsM2t3OCsvUFFZTW5aMFdIdm42QnJ4OHdRY2c1QkRadXNNM0JZ?=
 =?utf-8?B?UEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcec30d-2ecd-4fc4-961f-08dc916e0d50
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:15:03.7008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k7Twz0f/B831NDPY3vJ+pZyjoZODJPh3yJ//FU+bDudG17TfeWAx8F+IORS24kz22R/baRkj5OyywldkVFcRnEZ/1iK1nk0gQCRcLv13y7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6878
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> Currently supported resctrl features are all domain scoped the same as the
> scope of the L2 or L3 caches.
> 
> Add RESCTRL_L3_NODE as a new option for features that are scoped at the
> same granularity as NUMA nodes. This is needed for Intel's Sub-NUMA
> Cluster (SNC) feature where monitoring features are divided between
> nodes that share an L3 cache.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
