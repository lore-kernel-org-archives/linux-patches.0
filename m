Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323862DEA68
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783550878; cv=fail; b=clZsC7x62HIpF0CoyF04DmWBqOXdNnaPTS0HDfGJijj8oXjF3YggGpFLh58P1ajjZ1Bek62696+1brxIlZvxo3dQlPT44LWNr8Yuo7ojCULpZ4oACJbAf49V1L0efJjAqDSo8rBR1DLgqDThxWqZU2Xdv5otvQX5GHmmymsUGrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783550878; c=relaxed/simple;
	bh=ei/eWmSHJozXcDa7BAR0A5jJ9UYKUR3+qEIYfxlh4To=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lmnTll+1kItqVS47mEBOP1NGdvDpXv7dITBX9WgYoP0/TeCPfrVYe3fWN1Z7NSF5YX7dr6X5LgmVdTSQTTp6f1zCR3uMyCykm7Mx/CTyVzCRrcxcBhBiR5WQZkmGqCon2wtjJCEJbIDKVamK+ktSQDCZ/SUy7bZmPevnEgCn1xY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KAV2lMWp; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KAV2lMWp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783550876; x=1815086876;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ei/eWmSHJozXcDa7BAR0A5jJ9UYKUR3+qEIYfxlh4To=;
  b=KAV2lMWplWLJl99pFWDPhdRCuI323Mw9oU5iAerwZo/1aQepOjP6xRBG
   R659znk/FCLyjmFdMmE44mhgilGGjs+2br6YYnwwpGqTBl/BEy9X4YTA6
   O/1knW1X5nCDIsGSdCDvKdev1l+kUk1MixsPggnj0ELp0Mq/BUo31+tfn
   27cEI3REChmrTFadXE6RNtMItygpoiQZnkMEXq3mNzGC36BI5H+0KGlIR
   HA2+rbideOnknjH46zau+8P2G690XVYaVEIOMIixbrKfkWdJTl4HPYf5K
   QXOBNtulZkZTeNnbrJRWxxyRXinvXhwKsRIpnul+Zu3gIHRcaRiL4VoH0
   w==;
X-CSE-ConnectionGUID: YRj+Z1h1RiyTezMqFiMTsg==
X-CSE-MsgGUID: iWkemTJpTq2KwcPiaNc+yQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="95383798"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="95383798"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:47:56 -0700
X-CSE-ConnectionGUID: 0CXu8dzhTn2zkvUx7wD5UA==
X-CSE-MsgGUID: mbsMdLsyQqy044H2zrnBAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="256323888"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:47:56 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:47:55 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:47:55 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.14) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:47:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KYoOeEi2+8hnq9tEKZCmGh/7vw8RJW30sSMhgwTfCGPO2y2+uw8KvODXWyiaHA0qYrQEiY7m+hkVXYCD/yxJ3mg019nWZwGT1gscM7Qqf+hzDRGDKKyR2GHVTd+n9ZvtC+/kImnv0zAE/0Mx1O3QT0b3wsR51MSe8uhWJW56FwnADuAbgYSHCPAUs9Wpl/HZANnOnc6cNQGc9FBR0edrQ6Fv9SP14/goIfrBU2rFibAiDJ6p+cve5iQC1E2mPPbCvARlcxfIPUHoCyZ1IYNofHYMSvnwbVNAd2LoWqjihe44SBHtT3uIQYFoGdzOR19f8v9PsVxGvpki/N6pSiI63Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7bfDULxpOSf4iA/5nzJusvspOt/OEBGwbqClpsMb+pM=;
 b=UseixMwyw1vpxRgFnhvygrEPNVMBAAMjcvCJ1nxw7x1hZeWZUS9Z6DbJVAmXazWDZ0vQ7KxF/QblkwGD57ApDTGBzb7ABKXHIbSUXE0QpIUcE74+zR32BE8rG5yOR9No/FMFyKV5TVj6rHq4B/i0GNLqxKBkKmYRJOd4Bfp0pIpRK8hrS36Xl1kmH02dPIRaadXe6bh4vZ5IitxFz2VhPghSGQoQs4CFs9oX6KAakrp/mB7Op3f14Rn4H3XMef8fDabkGVbFfodmwcgmV/EhG+9RaRR5XowSND/O+gV9GBc4OyabAa1gZPmZzfXMutI9bBQ5HOP3ua9pWjNj3o8VXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV0PR11MB9864.namprd11.prod.outlook.com (2603:10b6:408:384::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 8 Jul
 2026 22:47:53 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:47:53 +0000
Message-ID: <52d50893-cd45-4460-9cfa-81e7a7b75231@intel.com>
Date: Wed, 8 Jul 2026 15:47:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/12] x86/resctrl: Drop global 'rdt_mon_capable' flag
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-6-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260701213553.15222-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0345.namprd04.prod.outlook.com
 (2603:10b6:303:8a::20) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV0PR11MB9864:EE_
X-MS-Office365-Filtering-Correlation-Id: 14161fca-c58d-407f-616c-08dedd42f207
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|921020|22082099003|18002099003|3023799007|5023799004|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: NTAFCWrahcd1ITnGe5KX/eLyQpaOLXzmjfY0uaTFtL7REET5yw+2xGG0973LtedTR+takXfQLeRUjMFVyRfxolPRnWDfyDWE/a4IITGfU4/yelReu2mpHvgGmhO3epOiaKe97kiRPkM5lkGlSaCXmshF1Bu9/73+LgrlyxPqVBD6sZVUmQGjWLHQEKewy+BxLM7NCn/pSWbxg2qo0m9fokKqD3FnlYlV4ig07vk8AZmIqOf+w45v8GLXHAK2VNpsSeHVHtIEQsTICA4Qhx1DFt4NZOazQxNkGRLO74OC3IYN1xlFjammcop6nHmU7oXJwf6ftMhh0niREn67uw9jVzx3Qo8LxgLdc6UgIwTWBfL5nYQSMySedNu0yGckLKmq/X7onVYApz1+ItaI49KNK1xAiLghrz0kqIzBB6FvjnmmlJ7xnWEk5q8shzifUE5wFXl95cUoWaz1oWBPCTKplOzvs9axrvg8jJnjc6gryOIrM9kA1ZcTAoVi+JZUvrbz4Wf0txxq3yymtcbpMmLFmZXMuqMFZOH8FCSZVEzlJnbUI91+bVmqZ8guNCMgKG+ir+w8Vgb4D5E5yfr4XgdxwkVhMAbxjahL6W4/Rub4JPHB0V/kDGb5HBZzTdJ7NcC1Y1A/VjKQQHFrrdhTFVz5460JVWtUcSnBeNAjrXzwoQ++YTwmehwoyu3Zag5NhKlqVm7I0yWzDwnbLTK7cv/sBQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(921020)(22082099003)(18002099003)(3023799007)(5023799004)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1piTDRkYitWNHhxRnI3cUhlOXVXMHNoamdBMUxCZnpSM2I1eTVxbUx5VkhL?=
 =?utf-8?B?RjRLUXZtd1hQK0pOdHhDL2VKR2ZKVnB6RFpKSFEzWFBGbHhKbjNVOEhlWEpx?=
 =?utf-8?B?enVXL2RFdmhUVVhvazR3aUlpZ2F3SGM2QnMxZ1JLaUtCV0d4cDlkQUg3aFpM?=
 =?utf-8?B?WElnRHArOWR4OXN3SGVDNlFCNVRucVBhL1ZNYUN0N1drUjVFM05HRmFVMTVG?=
 =?utf-8?B?MzlJbVhSRDF2dVNYK1RVWGhVUVNvMzA3akFRUkxXdE9MMm43Nkk0a2xlTVNU?=
 =?utf-8?B?TXZUQTc2ckU3a1FTbXhKZWJ4a0ZkT1pGRnFseXArQlBPMUdnNnBBNUg3Ny9L?=
 =?utf-8?B?VjcwcGI3bmlFeTZCWTcrYWJuS2wwTDhrZW9iWlpHdlVrcElDTnZXTEtuQUFP?=
 =?utf-8?B?cmVvT1Q0cEZVTmdXcFBHcU5mdldGbTJiRTk3NEV0Ti9JeHdlMnpRQ1paRUJ2?=
 =?utf-8?B?VDRpNjRiekJ3L2xtMlVpbnpkQXNaaHdlV3VlV0ZPcUdCSXJMRzZyRXVEdkZJ?=
 =?utf-8?B?Q2QvQjk4Y2t0SjBYTGxmMlJnaU5VS0dyLzhkOVVSOGdIWU5yTkN0d2VZSlNz?=
 =?utf-8?B?U05hcm9kaDEvT0t4Ri9zMDdLaktvRXJVVlN1S2F6TzVnTE1nN3BCNmhrditx?=
 =?utf-8?B?SVkwZ3NEUHdZUnFZNEJHWmhQTGdteS80bjZzbFh2S1dxUmN2NVRTRytkQzVF?=
 =?utf-8?B?czBxVnRjVUpScXdYNHQ0VHJZSDBvV3RZdUI0VjNRK0crbmlpRmo2NXpEMVRt?=
 =?utf-8?B?WWtaZng4OE44K25adVJyTGJ6L1NxbkVPSUVKTUlwZ3czTHNENFVxYmFyL0Zx?=
 =?utf-8?B?UkNJY25yKzBCT2kyMS9nUUIzeEVWNHNiNDBmK2FZNUgvbVFNaE84M1VFT2Qz?=
 =?utf-8?B?djlFM1g5bGdZWnF2VldwNzV0bHl1bWxJV0E0dkczbTR2alVjdjJRbXdzS3Nr?=
 =?utf-8?B?T0s4cC8wanh5QzFXUm1Ldy9IRFBnUG02YUR6L1dsSFZCUlVuRGlSOEJENTIw?=
 =?utf-8?B?VTdtYzNoVTczelhkZlhiekZzMVVBUC84b1pvQkxuc25hNUF0a1hlcVlGRWUw?=
 =?utf-8?B?MFJYTXo4THZJZHhDOVN2SXhtb3ZzL1RHM3pFeDFFQ3pGUHBVZVNFZ0ozNnpn?=
 =?utf-8?B?U2J2bWxnbWRyeDNTUXJtMHl2aHFmTjdSNXlnWk5WMjlvQkl0cVk1eXhDUmdW?=
 =?utf-8?B?Wk1vaytiUzlNaDBLcFJ5OFdhMmJFcHdISTh4SWdFS0Q5b2RnU2d0QmE5YXNk?=
 =?utf-8?B?Yi9PdS9UcmZiWm9lcytQcGltZXNIZzh3UDcrczNaekNLT3U0VTQyRElYK3Z1?=
 =?utf-8?B?RmtjQW5YMldQNkJuNXNsWGNIaWRUUmVaZTlaVk84aEtsNUxrQ2lSenVLZ3pQ?=
 =?utf-8?B?TWxSVmZGUWJGNjE0M0QxQWd3UEVqdExLVXQvaHIrY2plbWVkbG1EbmNodG5W?=
 =?utf-8?B?cXAzTTlOT2NkQmdxR2JhYWRaVm9FTjlkaHo3Nmc2RHdFRDJXSk4rUS9iYkEx?=
 =?utf-8?B?N1RhUi80aXRqd3QxRklFZjN5UjgwVlFQV1N2U21pNUpYQ2x2RGVhU1U5dXdJ?=
 =?utf-8?B?WnhYTlNVUjdFdVA2enhOckVRVTd5VitvT2pWNjdkVkpLUzl6dGtwK252SjZr?=
 =?utf-8?B?SWE5RFBmUUdva1BFSUFYajVpZTArUGtDaGszZ1FKOWJJdXNSYXpRZWRRSFdk?=
 =?utf-8?B?MytYaS9JZFpoek5pdDA3a2VLTk1kNEFsTzNwSk9ybExVN3k1Q3ExNDc5OTNZ?=
 =?utf-8?B?aHlXUEM4NmxLNWxlNXZoZW5GR2lWSGFXWXd5SlJiOFhXbzgxbkZUZGxhdE1y?=
 =?utf-8?B?eUt0T3FueW4vb1VuTjF1czZlZ3ZiOE9sWXJERnkyOVNnSWkwZG9kekRvNkV5?=
 =?utf-8?B?ZjBxVWd0QTZkKzlzblhEMmhUV3kwQW83cm1GWFVPa0x6SkEyZkN4UVFlbjJ4?=
 =?utf-8?B?am5Sa2FmRktYRWtZTlBZanhIU2E2bDdIK3NNU0hpZ3lyQnI4WG1oV0NRRUlw?=
 =?utf-8?B?MFBEUEpnZUs2c3Bjak5qaVJta0dZWjd6dmgvcDZFL3kzMldYd0hrU2k2Zm5I?=
 =?utf-8?B?cmtRaWlHbmV2dC9mREVqU0p5Qy81V0p2TG9iVHZIcEVWOCtGRC9wSEhJeGdv?=
 =?utf-8?B?cGdsOXBiUWRVTlhrVGdLc2o0TzhKUG04aDhZNlJZaUFONGlGYVY0YnhHZFdD?=
 =?utf-8?B?cm1IUW5yNTlhV1FhNlMwUGs3TnQ3Z2orUUdzT3pTSVI5WjI2cUljeU5UT0xz?=
 =?utf-8?B?NEdUUnFuUnoxZ1c2QjNueXd1VHdLcFNIa045U2VVc0pLWDRtR0llbWZDRks5?=
 =?utf-8?B?QVhGdWRpSUdlbEVyWHZJNFNBL01iZWV3bjU1dHdBU0NpR2NQdnJjWG1vbTE5?=
 =?utf-8?Q?suUf7GzDBpnU6TUo=3D?=
X-Exchange-RoutingPolicyChecked: VinE7Cv38cL7CM4bXtagJwQOgkCk7QTIC9V8JikfeZ/xtVC5OvV5FPGYSmiMpXM80XqwjAg7AGKbE03CgT4DY25djYgxA5i0iTiTr88YJp8ObSEZCjcVvdoXfbjdUS0iiRWZsdYPkUagqAtrknjtt7nT9N7imlYCWAGIAk8cIrwh3IeMG2+0MfzeVsBkgps0PQbaoMrVUCm8pb524yoWzx1OIX3kHfuftP6ZjDc+njWgCHrN6NEE7saRj1nsEVCVY/0OsgIztDNK32NzwOP9LwwtK9AirIriLM4JaWafI79PmWAYh02sGxJmdc0SuXhFSeUVjT7FYQACvtwxCQVrKg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 14161fca-c58d-407f-616c-08dedd42f207
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:47:53.2648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /th7CwT5cgvSIewkaG5hR/RO6Ki4XbrJbiT07M5G7lmuwRZQah89nQ3t8s8JUthCoyVwmxzc0KTTDfs1IsaMBDNKRLotkcy409kA8VNM/Pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB9864
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> File system code calls resctrl_arch_mon_capable() to determine if the
> system supports any monitoring features.
> 
> x86 architecture code sets a global flag to support implementation of
> resctrl_arch_mon_capable() but the upcoming change to enumerate AET
> (Application Energy Telemetry) features on each mount introduces a new
> corner case.
> 
> Specifically when AET is the only monitoring feature, loading and
> unloading the pmt_telemetry module between resctrl mounts may result
> in monitoring support enabled on some mounts, but not on others.
> 
> Replace the global flag with a scan of resources to check if any are
> marked mon_capable.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
> index 575f8408a9e7..a9f481b7a8ed 100644
> --- a/arch/x86/include/asm/resctrl.h
> +++ b/arch/x86/include/asm/resctrl.h

...

> @@ -66,10 +65,7 @@ static inline void resctrl_arch_disable_alloc(void)
>  	static_branch_dec_cpuslocked(&rdt_enable_key);
>  }
>  
> -static inline bool resctrl_arch_mon_capable(void)
> -{
> -	return rdt_mon_capable;
> -}
> +bool resctrl_arch_mon_capable(void);
>  
>  static inline void resctrl_arch_enable_mon(void)
>  {
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 9b9495174041..60d50ac79e7b 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -51,6 +51,20 @@ DEFINE_PER_CPU(struct resctrl_pqr_state, pqr_state);
>   */
>  bool rdt_alloc_capable;
>  
> +/*
> + * Need to re-evaluate on each mount whether any mon_capable resources
> + * are enabled.
> + */

This series introduces a significant change in behavior of this call and I
find that having the declaration in asm header and this significant comment in
arch code to essentially bury very important information on this
call's usage. Could the declaration be elevated to include/linux/resctrl.h
where its function comments can provide the details on how resctrl fs
uses this call and what its expectations from the architecture are? 
Basically this series causes resctrl_arch_mon_capable() to possibly return
different value depending on when it is called so there needs to be
a contract between resctrl fs and architecture on when resctrl fs can safely
call this and expect consistent results.

> +bool resctrl_arch_mon_capable(void)
> +{
> +	struct rdt_resource *r;
> +
> +	for_each_mon_capable_rdt_resource(r)
> +		return true;
> +
> +	return false;
> +}
> +

Reinette
