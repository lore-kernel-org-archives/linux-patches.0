Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97183B5E08
	for <patches@lists.linux.dev>; Tue, 12 May 2026 14:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778596478; cv=fail; b=ilbiPHHh1F9uH2/ggVIhFM+eMihOLX83YcIFRJkCHEojrpHwegu9ft/PQjJ7mcS6OyD+5XidPQ4yYFFMcNY/SwqTFBvwGeCIQoPBxvwIIbUXKoWuc0g0W7sTF7Bu7e/eGzRwTCVzQIiG4K0BnCs/JNYqDhVuSK1yArTyonzA5H8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778596478; c=relaxed/simple;
	bh=PeCJZjKCOA11Hq/IWBHz9NE+quC0IvRHpdurzv9UGFg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LSWsSwzZjpHINnXvDRHM7vWTgZcsYuokDwMXdTSZ+X5Ikt5G2cvMP528V5+6W+mYsN/imZHniG45qat/r//XurTAULhHMBbPyo53x9+YKAVP7og6oHCwGp7VrIrrFTU6Xoy86mCNqaxDOHpj7DQVbG2YUxa6/uWbbYiV4qJh8gE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jtzaw4SW; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jtzaw4SW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778596477; x=1810132477;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PeCJZjKCOA11Hq/IWBHz9NE+quC0IvRHpdurzv9UGFg=;
  b=jtzaw4SWaEEBlXethlizIZJb9yH+OnjCpirMzYd2UhKNIKb5Nyay9ZC7
   ZTZGNW6WEzVVNCeQvaOfgH4TAlcB5+RJ5tG6d3seyvt7x4UXyR1TBUuRp
   elsqh/LWzB/a1eeNeEI8ocXJijezxhqpd3KWTmkz84EIahIEz4P57saWt
   3H5JJEoAIFN62FtAfxEvXTJllxgEzce/j4D9KNL9GdSm5SyyOYLScvIku
   mAz6sOAmvq1ENZLm7YV8K7C+oJP7xrR98GIS9QOKvVMsesSKsFwTjNK5X
   KptR6XD0+tx+7jIR8wXPgjRETtkI9bZW2TKSH5wR+ZrvwqRdA6WHtLd90
   w==;
X-CSE-ConnectionGUID: 5rJSJBarT569cToKlKUxPw==
X-CSE-MsgGUID: ULKTXmy+QEGXAxlyY5Ve7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11784"; a="90969518"
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="90969518"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 07:34:36 -0700
X-CSE-ConnectionGUID: 2dtfr5s/TXWFCB5/qVzgUA==
X-CSE-MsgGUID: MQkx6bHcRKK+pJrHwxkDVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,231,1770624000"; 
   d="scan'208";a="241783678"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2026 07:34:36 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 07:34:35 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 12 May 2026 07:34:35 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 12 May 2026 07:34:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jHJGwswhT4ADWzvPYBvicnFnuCPdH+0WM+jOGdXtdSvwWV7gtK9epho0E/3MfRHwREhUsF2I/Snbyhd5ApDC6HVfj8Zv2eqejCQ/1/M0koyccGgH7j8eyI4FImMbyJr1IU73dwVyxnP9zD0O4Zn/W9dG2+WIcqjhR96VJ29+ERCWtAvFPW0gk8oR3vk8n6TsH3eFqsKI36ZntH2+led7MHqL13qfL+89wkt6b78jNcPmLDg+WhOtPa4QiglbjJe/4krpqkrf3bB9wOvJfYkJlgtBF3g0ou2RZ6HNUW9Tn23xWUK80NT1luyj1oe6IBiRDe+f1ogcOoljAQnu4QlSaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQNwmWq1Mffyx3GDLyfeSeaZa/howVl5XAoUjD1wupY=;
 b=KCTJzgLIN2JnsMTmKeDomRQn1CSWb3B19u6Zcv5hv3831p8O3JBuK38Wh1DbIo79sgarr5bXYoGEXJL+eQGZfUlZVKL+wMOq1v3pPoNG4pnxzazGbQipDbU9y0eZpfnAIftmVe+qItJK9Fa32OdaSKmypGGFnT9aHZvPZWKqqoCMRRpfB5mtCaDJkIPP0A6EN5tmTW5MO7v9DZjGxqq1pqRCZ5nedWgXHYZTsWDj3tNnWColMnZNkpfKYX6pUkTbnr4jmYEBaLs8OW8+42IQ0HkmS0sr1UzDG6wfya6MfS8cBR7uhkb9twgRwYAwMzTyx0AVKvHrL4MUzFsmRwfVUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB7886.namprd11.prod.outlook.com (2603:10b6:8:d8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.23; Tue, 12 May
 2026 14:34:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9913.009; Tue, 12 May 2026
 14:34:31 +0000
Message-ID: <547e32fd-1d60-4c12-8ba5-5f8cebe5ab87@intel.com>
Date: Tue, 12 May 2026 07:34:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] fs/resctrl: Fix deadlock for errors during mount
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, Tony Luck <tony.luck@intel.com>, James Morse
	<james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Babu Moger
	<babu.moger@amd.com>, Peter Newman <peternewman@google.com>, Dave Martin
	<Dave.Martin@arm.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-4-tony.luck@intel.com>
 <e0f70732-3ceb-4d4d-8ffd-4f2761922e3d@intel.com>
 <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <69874f4d-e64c-4d74-8ba9-eec30760751f@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0030.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB7886:EE_
X-MS-Office365-Filtering-Correlation-Id: 252b4303-5fba-4ffb-969e-08deb0339447
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|56012099003|11063799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: wz7nJ1/91UvWDNci3pHkRv1I82CGwGvUwIbL/zEwQy8BDJEjPyAElKxRqU9gBS3tppqt+8NEU4/MCFucIYSXvaLWKh8EVXn6kfyxbG2XybPdvsVJ/3Coi0Fe0MIVTSJOhlRxQkT8m378si+9raJLlOQEJwWYzfwnoYhkwZrDxBXnwZPZ+Tb9J7Li6ARLRIlt3LCxPp1zoJSUcyRmRRMuiuBb+UQXc74Gh5rLzJDB+HuJTqoR3cJi6n3xpPTO56IsPmvViAOt5Y7x251ZIz9CGhKkbRAvetRpa0z7oSZycb8IyckfE3OqvnPYx0Upqfl9jCoX+2z8jbHCfTPR2rvBs+9mXBbUzJnSX9vaqITqBuHxcF7wRABeB18a+CV8EmuHcunXQ7Ul9wABpPxVbieI2jT8kb4X+HNDZm0gvAeHAifxvuaOf2c6lZlaEcqVSftiUay3QQ32QYFa3B8gPYFR5HNRFLuI9vc3Zk8emmDIvDSPYpNq/7rI6KA1dgguNtFer6oPVHEcevkBKQOY7a3mowGULshl2WUy+vL1Haq1YmsrRcCkwiDFQhPfHMZXc0moLgubMhbw87WedY2bR8Ek7drm2SnfADJ0BPCVfKb28wIzJp4WpL6S+EA6ZR2uPHqZOAHhV94C7mMAwV3uD9DkylRw5WCz36qHqfxQYYTcEMxFzXBov3UqdeIbhJGcX6wu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(56012099003)(11063799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmNIcHJDS0ZOK0dFT1FCY25BMU5YeHlHVjVVNVBGRlZsS3dKZnVIeWpndFpH?=
 =?utf-8?B?Sk82NnFwaHdRRm5XdmdWenJ3OXRZK0haZXAvQzN6cmg5ZjViMkllSFZCVll0?=
 =?utf-8?B?eHVjNHdvRUhBWCtldEtnaWFCOHdoWkg3ZDhRU1RGNXIzK1MxZ2IzU29uOWdv?=
 =?utf-8?B?TlJVRkJWWFd4MUVhbDRhOVVLUmlJa0d6MHRPRnpGd09kRnNLTGZsWXJKbnFm?=
 =?utf-8?B?OTNSa1lFVFlXTTg3eU84eWthOGhzTmRIZmg2eHdMY1RaWnBVRmM4ekxRam5s?=
 =?utf-8?B?Vi9idkpiOUQ3aEJZNUtUV1ZaU0pVNVllUm9nNTFIN1ZLc3ZvV3hoL0NXdFZT?=
 =?utf-8?B?UE41c3ladE0vTG4vQk5RMlNnUTB5cmE3S3R4aGF2MThoT2IxTUNHaHpLUEFH?=
 =?utf-8?B?d2hkNzdLM3FVN3ljNzBsRWFzTzRqUllZcmNoM0ZnQjlESjErdjArV1BmM1pu?=
 =?utf-8?B?NTVDYklpWWo0alUrbFo4L0pnQTNwRlZNTnk2THcwVUpPUEltSDZJQndocnJ4?=
 =?utf-8?B?aWg5R0NTZDJaYzZrZzlxSzU1SnVWYXZpSHQ2dGV0YnNMR09jNkRrWkVkTGQx?=
 =?utf-8?B?dEcrY1kvc2NFTnZsdWxKRWVmSld6c3dLVzVoUEI1RldLSmhBQm1CRjFyYktS?=
 =?utf-8?B?N2VDTGxVVkRJM2hiR1I1ZE52VkJpU3pxZXNhbXRVbzhURnM5MXdPSk45cmJw?=
 =?utf-8?B?ZHNpYkRhZXRRZ0ZidkpKLzF1Y3B3NkVPUjVEREx0RVVCdWU3ZXdabXcrY0JX?=
 =?utf-8?B?WEp4YnhENWd3dTlEekt5eWNTVmZQZDNmaGxUS1Zoa0xpZ0JIVmlQMzhtOTZ6?=
 =?utf-8?B?K2lPZEpSd1BPWTdUQU0zZWM1dzBFRjBYNDJEMmxuRkUxUitYdEVxT1NlMmhG?=
 =?utf-8?B?NHYvamVVS2sxQnYxYXRKcStldUR2bmZHMVlmZ3RIeEJzZ09kbmdMZHdKRnpm?=
 =?utf-8?B?U09QTk1rS3FtdC9xNU1vV0xFSkRDWmZqZENEWitxa0dvV2dyVWNsK3Fzc09a?=
 =?utf-8?B?NThiOEpFb29yZlFuT1NBL1RCaDlFYjV1bERwVU1LQ1JBdTN0eVJSamJQWGJM?=
 =?utf-8?B?eEJNRGQzTWM3cGl0SUp2TXgzemNvRHp6L0R3SlZvcjJ1dktHeWlWM0JxMUZ6?=
 =?utf-8?B?azR1ekJXbmtURG40cFhEZXIvMzFEVEFCMjkvRGxyT2trT2szTlRyMWhDQ2JI?=
 =?utf-8?B?eXNZVk1vWk90Z2ZKOTFtNlQwRHY3a2l4eDh0NzlVNHoxMXVLOFIwVTdudmE4?=
 =?utf-8?B?bzYrQlh6cHc4UHp3T2VZYUJ4TEwzYURUQUMvWGRjV1JJTUhoK2RWczFQUlBv?=
 =?utf-8?B?cDR3Y1NYQlllV216MGpjQlNPRmJYdENDUzNpMDNUNkFXcDIrei9xcWVrZ3gv?=
 =?utf-8?B?VDVLVndxYy9zTEtDMkFXMk1nSGhTYzZ6OGpDbEJ4M1FLblRBK3JqZ1V2V0pq?=
 =?utf-8?B?clJSUmpIWmx4N3BPeDhreEdEbnJVcTBidnNCRlJhcGZVNDF0YWZyeTFFREht?=
 =?utf-8?B?cVh3RElxcCtBeUh6YjY3K041UXczSEtOd1crekt6RlQvSVpPdXVtRURtbkk4?=
 =?utf-8?B?eTRRcEliQVpiT0NwRjBpU1VIblFZaEZobE44V3IxRnFYTkV2WnlUTUNJelBY?=
 =?utf-8?B?VGtRcXc5RGV6WW9wTlFRSjF3dDVSV25KYmpKd0tYbDNSU0F1NktpVFhILzlW?=
 =?utf-8?B?UFNpajhmcjVkVkxQMXJOL1RUSDZiMGRuOE9YSXlGTWdxVGNXeDdKVmd4VG5I?=
 =?utf-8?B?WXNCWVVCS0Ywc0FiWElRalBINjlVaVR4YlNPYnlBTkVjTVZmMGdTblFXallE?=
 =?utf-8?B?R0FsVzNTYi85SlVWUldKbU9NSkVVUjF0eFUvZGNUU1BRdGUyODM3ZmNodlRw?=
 =?utf-8?B?Tk1aVFF2TEtodm9oTktYMFdJQi9pc215RnhQT3VOVHdycGVtYWdoZzRTTDlo?=
 =?utf-8?B?cWVHOUhOL0VaQmZvdmNKL1N2bmI2M3Q3eFJVay9RSjFyTUFzL3pWTmxxV0xx?=
 =?utf-8?B?dUVxSkNvaDJHUjJuWW9QdlYwODFCbm9yeXFlRitnUTdDUUJ3RnB1Y054dDIz?=
 =?utf-8?B?RGc0eDBPLzVFOTlxV1hmR2lvNEVDZU1wVlJEUGRRSHhSMmozUWVCQnNpemNS?=
 =?utf-8?B?SXJjbU0xRFg5YkpWTnRvK3JJYkJnWTlKUGNIN2RqZE54MUdBM3ppQW1hWURI?=
 =?utf-8?B?bG5GaUdhNEkyQUQyUXFLNFJWem5TWWJ4cUhCVGd6Tk5SaU9lMmkwM0lFbFpl?=
 =?utf-8?B?SVJHSVY0aklUSXZOK3hoSDhUK0QvejdUOEhQWGRtK1pLWWFzS0k1NDRVUjh5?=
 =?utf-8?B?YmJOb3g0SThBaXhFeEZRL0Y5R3o0aUJBOHJmOW9LeEFIUDVOOW9uV2NCNW1F?=
 =?utf-8?Q?EtQHkdqbZ1loIFY0=3D?=
X-Exchange-RoutingPolicyChecked: Hjtr2BwiHbixJzlAx4orMlmyhTZKHI7Wd7MqROFsNGbDqdHG98sGpIwS5du+4bd13GluIYu+wCzXegY/TYmfz3jXy5IClLJvYJpHC+Dj1PLYAp514EAKUe0dgP8QJ0Kfwluf2JEK4vz08r6loPqicSm2EEsrHIW6+dQH2ppZBAVzLxGiBFjzZUWNV2/GN1j1vt7pgnydkhCE58ElmjJ3Eujb4GdQwBOf1ZBiO1jGVhkj6kl4ADraNwCR9vvFo3TRiCtETDWB5We6z6O3xeF9QpTuLuTXhUY1/mzxzXDpFHOtY8chZ1dqVaQOMFCqmiKxq1MwDzkMsQOnw7ricZT7HA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 252b4303-5fba-4ffb-969e-08deb0339447
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 14:34:31.2212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ONODJ43Hqn6ficikjqiaUsGjK7iuTat5ENiImY4xGu1KbcTcAuAxmSu+7iyqzQcKTYEX+4k2ZnbAu9K6oE/0egfjVOIjB/1bx6Fi9W7U2eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7886
X-OriginatorOrg: intel.com

Hi Chenyu,

On 5/12/26 12:28 AM, Chen, Yu C wrote:
> On 5/12/2026 6:53 AM, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/8/26 11:21 AM, Tony Luck wrote:
> 
>> +     * Obtain reference with locks held to protect against interference
>> +     * from resctrl_exit().
>> +    */
>> +    kernfs_get(rdt_root_kn);
> 
> [ ... ]
> 
>> @@ -3130,6 +3144,7 @@ static int rdt_get_tree(struct fs_context *fc)
>>        */
>>       if (!ctx->kfc.new_sb_created)
>>           resctrl_unmount();
>> +    kernfs_put(rdt_root_kn);
> 
> I wonder if above should be protected against
>     cpus_read_lock();
>     mutex_lock(&rdtgroup_mutex);
> like kernfs_get()?

It is not obvious to me what this protection would be needed for.
Do you have a troublesome scenario in mind?

rdt_root_kn is a local copy of rdtgroup_default.kn. The latter is indeed 
protected by the mutex. The reason why the kernfs_get() is protected
by the mutex is to ensure what rdt_root_kn points to, rdtgroup_default.kn, remains
accessible after the mutex is dropped. Nothing else modifies rdt_root_kn. I
understand the appeal of symmetry but it is not clear to me what the extra
locking is needed for here?

Could it perhaps make this flow easier to understand if the kernfs_get() is
of the mutex protected rdtgroup_default.kn while the kernfs_put() is
of the local backup copy? For example:

	/* Ensure root kn remains accessible after mutex is unlocked */
	kernfs_get(rdtgroup_default.kn);
	/*
	 * Make backup of rdtgroup_default.kn just in case one of the
	 * following flows (that sets rdtgroup_default.kn to NULL) run after
	 * the mutex is unlocked:
	 * resctrl_exit()->resctrl_fs_teardown()->rdtgroup_destroy_root()
	 * kernfs_get_tree()->deactivate_locked_super()->rdt_kill_sb()->resctrl_unmount()->resctrl_fs_teardown()->rdtgroup_destroy_root()
	 * These flows would not actually result in rdtgroup_default.kn
	 * being removed thanks to the additional reference.
	 /
	rdt_root_kn = rdtgroup_default.kn;
	mutex_unlock(&rdtgroup_mutex);
	cpus_read_unlock();

	ret = kernfs_get_tree(fc);
	if (!ctx->kfc.new_sb_created)
		resctrl_unmount();

	kernfs_put(rdt_root_kn);
	

Reinette
