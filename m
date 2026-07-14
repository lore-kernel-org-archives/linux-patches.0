Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AD4238D54
	for <patches@lists.linux.dev>; Tue, 14 Jul 2026 16:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784047514; cv=fail; b=kXBk3+fCqzq2qCY8N4PimGa/qE2c+W9SaSGhszG3qJW7FwsUa94hehEPzwG6RX8lMI35ehbFwJc6DbGltLoQlSzlVy0jJWnI0XjlabgyTUB9o0zQUDRkiIYY9pexbKIMcV8V+Vl9RJWK/46+e13Or0nFZapOkBF+3V3tT1bGDJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784047514; c=relaxed/simple;
	bh=5CnhihQuGrmQzKMISAt8kbJPlDGeEsM9FPKkOUZSUwc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sq65jiPk30zv4AJjn1jz8TNjDtczsd2RNsUcXgqOgWhBbGzdo3fvPv9NlTY3AWfo3G9qBdPl4AkEA57z+8b7hw+KxIJkbHSYT6iy0Q0EYEjFDf+zB9W7MNXFZ6gQFHl4LFAyYVEaxh3haYdifLHjmaZqVEm8VfzDQBAFN52pWv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OG2p9v1s; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OG2p9v1s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784047512; x=1815583512;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5CnhihQuGrmQzKMISAt8kbJPlDGeEsM9FPKkOUZSUwc=;
  b=OG2p9v1s6RIZDSXnDeFoHJ/3aF1lpHFoxlkV4ezjZoUJyEHtnGGiPl6P
   HeiOBjZb5CkOXU3h3M33VlpTy2Mg92WSKEIutonlW0ghRmG2CM1E2YMEN
   x6FiLQhPXncoWcPU8PXpsAbT6t20JcsUbhjYbxr1YX220Dxm8iIzxfYMj
   x9voUQdGJ26v9PrzqnzYd6F1kfekt+CQMhh9HfydvtiJuNDkYi76kCv1x
   OvQZQZLBlKPwfTgmfwCuHi2QRQJ6oIRe5gcFPKJHYHSTjLe30B3Hc/lrv
   0v/1/Aj8pNdu/HWv96gAdenCveCH9ptlOslXhu3HcCwejBXHgdDX1dflF
   w==;
X-CSE-ConnectionGUID: FkfAMy7yROSCqau/LVDRng==
X-CSE-MsgGUID: eNoMTmpuTbylC9n0OiDT6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="95029930"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="95029930"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 09:45:11 -0700
X-CSE-ConnectionGUID: f5erSOxmSNqNMhS6h33h8g==
X-CSE-MsgGUID: CvWg15iTSqSf+FMrP+/IKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="294121714"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 09:45:11 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 09:45:10 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 09:45:10 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.10) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 09:45:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EP+omkE2y3Fkyl3UU2F3qT+r7MbSXu78pRa4C+iuGm+Uue7Hz3GJuTH6Br4PoCxQiK5Wi5AvdipvKl4AZny2P8iWhYQ+QhsRxRqByLTsscz3CK9QbBejokAK7FBYUK5gE/BsAL9hcVNRlMYcIJrcvjFOpKiPOR/1oLV80x5vnk212Z81y8xzLu6+LLDLJSHy4ZG+Mw9MijFD+Q0yi/8TcbKLwjo+BoVjJaZF/HgOQa/d4T/C1DjwJ2Jg2bQjRfDWQ9SRYjrZFxZP6qXmFNsWyMyFPHlnVcOZJpDxD6UapcaMp9tZsDhrFWdRCY+YFFY0Y//203rex7ZXhWXvtPDW9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTx9dhJ4jj03azkfc+aDoJLDOFVMx3cu6yrCSRNW/h8=;
 b=Nst1le5HhBmD5m0i2COlBiEZq+7ySLofH8Kb+I0gXedqtYZ4Pcgmveb+dnIK3zEExd3UfCfAgfpn8yilh6UQ4r2B5CVl5dinLsmHf0OMV7q7nhKU1M7uS+VNCPBc5m6dWq4CKOHwncUqvInBULDmu7gePvUGnD3W66+3zMrRYrcDPWjijgTE0f2CKghdNt2aWjnqWoZVf6QL3sHfcmTBG/FI+r1+DEVPYrryjfQQmalCVZOOUUJBvQyRjlQeWmLOUk0jqYcYKVDbYVZc5sVxxX9KYBoJ4ERo/7OwBgmzOcsfVtA4KICv/OZGkn7zpIKpvz/NJj7c+gObe0miGyAOfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ0PR11MB6672.namprd11.prod.outlook.com (2603:10b6:a03:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.18; Tue, 14 Jul
 2026 16:45:06 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0202.014; Tue, 14 Jul 2026
 16:45:06 +0000
Message-ID: <cbbf71f2-06a0-4833-a7b3-b8c6df440e93@intel.com>
Date: Tue, 14 Jul 2026 09:45:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/12] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-7-tony.luck@intel.com>
 <06cdd789-bf1b-415d-a588-b72938d3b0dc@intel.com>
 <alFbX0tItMg9CbB5@agluck-desk3>
 <e937d05b-8381-4d4e-bc36-7165a7214694@intel.com>
 <alZdWe-DACOtDwm0@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <alZdWe-DACOtDwm0@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0241.namprd04.prod.outlook.com
 (2603:10b6:303:88::6) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ0PR11MB6672:EE_
X-MS-Office365-Filtering-Correlation-Id: 67954251-18d7-44fa-1ece-08dee1c74287
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|11063799006|4143699003|5023799004|56012099006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: EePJYu5IGOQ2yWVHOY2Uvjgn/M1cHfPr2VDw4Y7Odtf7OCR6GrH7UWrKHRaACyLWR0nluwDvZYx8vOwiLibcDC6hxggXOG9ncNS/DDEQS79BnnfxjE75ygwj0lq+NedG2uP3cfIxZnfnQbEfYuvORtnuiyuMe5dVoTISkXia1sQtGZWzl297vBBlb2q0roJibQwzugKn8I0bu9SmjyJo/+Zb+300cc0qTVyNdnULVTDk8O2eiUqFpVBWzZbkANN9XG5BIgPQYz3FwCrwbRskoQJHi1XIBjipqwqE08DVARjynw6mUZJo+w66K6QZFgcRGFp1ss4TKMePP5MKShjp/RJUPTgvvS200HF+17RmuP/ihPYzhRiKw2EgoK6rJOpm85nAXB5BojkknDjIkEomPV1xHnKyLaMovXrOSejYDpbhVNmv54gsEO+L/zT2PG4dysr/elV+m4YMBhYQRqbh++7EwvwoHWgi8Z63+vEU61V+0tgBXhdQiNoUdSeEydKWQO5KPv30frzIiDbGVMedHXHWm8509UQcwqCJRHhs/8UGZtCDsVjBZwKV+vLKF3BOYW0H9QfJevZmt7KiG/ntcM/2EUJWGl/K4SrF1XTdICUVrZBZptUhgk4N44vbP70Y0Ef3P0AUm4jzVk9j5MV8nhMzsYR7BxWQpZSjXu6Ga7Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(11063799006)(4143699003)(5023799004)(56012099006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ckxoRThHbVBxVEh1WW1vZUY5S0JlSDdUT0Z4SU92MVNkZnB6elp2eUYzQ29T?=
 =?utf-8?B?RElpb3dnVG5NamZSMnlRS1FkWU10OU9YUVpNdTlwNG1OWjlQejdaUUNjeE1W?=
 =?utf-8?B?dXlZTXhKYWxzTThPZGVYYkpZbGJSVllTNXBGeFRNemZaTnFja0NVS3U5SGdn?=
 =?utf-8?B?bkUvd1R3VHhwVXpJaWh1Nk9MTWpoY09aOWZsbW84Qm9DSExUOHpHR2dXbmkz?=
 =?utf-8?B?S2I2U2pha1NyZUlEbkRGY1owc1RkekxKTlArWVR0dE1KVGJ4ekZYZkMvM2Ux?=
 =?utf-8?B?NVdDeVd2b3NLcWo4MmZrNGp4Wmp1azQrMUN0c0U5NnFxclV4UzM3RG9QS1lT?=
 =?utf-8?B?eis4aHdTMU9xWXY3NWwxdE1QSGVwenpCdEhUQmtOdWxGWDd2RHhTZlA2QXJk?=
 =?utf-8?B?L0xNc1I4cGlkOFFGZEN2dzdEazZUZVRKOE5vR0l6U1hNdC9PZmtlMlAraW5L?=
 =?utf-8?B?UnpmQ3Jwbm9aUm5qSnNxbWg5OTd3RjZRZElKV0pDckI0d3dYU3p1NU9nK2lM?=
 =?utf-8?B?V1I5QWhmTlVnRGRDLzBObkgxak91WDBuOGo3ZURoQVNjZFFJdWpmdWZJaDZw?=
 =?utf-8?B?OFlMWE4wLzFidnBKa0V2cUpYcU9xZ2FCT3FQWjQ3eG5FR0JvTEwyKzdzRmtr?=
 =?utf-8?B?WGtuSVVhOFozemdOMjdrbWsyQlVYNXpRTVY1czZJN0ZTMkhhcDRqN2xmSzdN?=
 =?utf-8?B?YUxtaFFidU1lVEF1T25jSEdyRFBjbmUzMVJMczlDWTZJRXZNb0RCYzBGMk54?=
 =?utf-8?B?NnQreGg3QWhQN1NScTlkQlVXMUxndmNveDdYY2xDMHhiUHRtMVVMQURLNWlW?=
 =?utf-8?B?Ryswck9iSzRXNTdvK1VpUHMyaktJd1lwV0MrdHdnZDhlQ0xXY2w2QWFWVDlp?=
 =?utf-8?B?ZVNJNDczQko0clA0bVJLTGoreWdUdHRNNHVhUkxVeWtQeE9oeFFCcGNnZnhk?=
 =?utf-8?B?N1U5T2hVWmg5UGozZ1U0TWRvSVlpNmRsVFVTditXd3EzamlmcjZxMDJneEYr?=
 =?utf-8?B?OExoTzVSOFV1NWZwUkVhUnd5b0JkQkVueE45VS9BSnE0KzVlYUU5QSs2S0x3?=
 =?utf-8?B?cjJ3NVFJT2gyODRPUGl1QWtOQ2hNNkhJbEN1VG1Gd2lRVmRVV1NZSTNPVnI5?=
 =?utf-8?B?Z2hFNEJCMktvRUltTHVpYkljbjNMa1Q4Vi83eEhOLzVQMlJmOUpvL3FuRjNj?=
 =?utf-8?B?VTFvNlNxNGI5NzNuaWRtSDBtYW8rNHgvNytwT3grV3BGdTFiU09qUGJ0R2Zm?=
 =?utf-8?B?K0N3YmMraWtjWmhuSWFmWC9wUHVkd0x6K2QvUnpHNXA0c2trcWZLSC9yRXVH?=
 =?utf-8?B?aHVMVWRuaW02SWp6LzY3aFJmdnJaRWVlNERxUk1rZ09aUEVkWTBsQTlGMSs5?=
 =?utf-8?B?N3ZUOTVHT1dNcmtMcFZYeUE3Zi9Tc2hKc0hMblFNU2NZS0JSZnRjZDVWUWo1?=
 =?utf-8?B?WHFlODRNYkUxeUJNZVEzR2tJdmpOOU9pVFVFdEU4bmh6RzRHSENVdVVyTGFB?=
 =?utf-8?B?ZG9zZTlvd3pwZUdCbjlxV0FVSWFMUlJLWnZBZFo5V0xYWlpGTjN4cHNFdGNL?=
 =?utf-8?B?M0hxRE1RQWdPb0Y4a0ZvcDdub3J6VVNmSmFUc2V3ZTE5YUFxZHR4UW1NdC9E?=
 =?utf-8?B?V25oNHFpeFlYT0pMZ0VjQ2ZiNlpqbFNaL1NZcjc0VHFiZGtmR0JFV1hMODk3?=
 =?utf-8?B?ZkV2bm5KZVIrZjA5d2M5K0c5emF5Q2JtdTdRQlQ2YXUyVktwYmR3K3ROcHNs?=
 =?utf-8?B?ZjRWcW14QkQrU2hXVERZTHlabGxlWVY4NmN3c3FYeFFLYmZhZXh5LzQvZG05?=
 =?utf-8?B?TmpObm8vcWhnVEJpa3kza3lOTG1uTHJNaVlrSWVBY000OUNOMmJkdTVZMjdz?=
 =?utf-8?B?RGcxRlVLYWJQajRwSEs1MS9nVTJrUVNqUzkwY1ZwUEw3OU1FVG5sRW1EK1Ew?=
 =?utf-8?B?Q2QzT1RQb0ZTRGh4eUFoMG44cUlXcmd1bGZ0RTBwOW9aL0ZIYS9YNUoyVXpr?=
 =?utf-8?B?d0JQdXo4ZHRqMVRlL3hxQ09peHE0eGxxb0hDbXV0QjBObWNLQlNjQTNOSEE0?=
 =?utf-8?B?SFd5eW5aNkxQb0JDNDFTZU55eW1YeTkxRkFqMDNuWU1sQVBjNVZOUlk1aXpT?=
 =?utf-8?B?NlNUM0l5OCsxUjVidWQ2Z0g2U0dlc1Y4MC9zMDhpWnFrN3JzdmNXb29VWTN5?=
 =?utf-8?B?SjdEOHpMMVdrL09ucW1kbk1IWmZ1YklGMFdpbzdwZGR3eE9ROS9sUHhXSTJi?=
 =?utf-8?B?REJsZFhHNTA1MU1lMTZPTUZHdUpSUnV3dXIwMmt6eEs5aDUvMGIxMmxUYXJ6?=
 =?utf-8?B?WnRXaWlyeWp0TnFpQzAzNzVXV211TkdObE9SUnRGSVJ1VjQxdXhoOTV2eEFq?=
 =?utf-8?Q?mCMVx8of+SKhUGjg=3D?=
X-Exchange-RoutingPolicyChecked: Ed/jp2C7ZBexki9mG+1kVie2m9ljaOEUT6+jZXnDrqhytdhQoW43R1Ojappl671HVUT2OlI50TRmorL+hoRPM6mgBahpWkrsmExd76po4HT+WqaIH52lpj12dT7eP2DjXtA8ns5XUV/OuoqZD5dILzkmj1A96615WDe0dhnuMNUaZr8FYeSHOoaXvFKhKs19tuEoKKpQToKChL30U0rRTWqoU2vk3t5H/VyzagEOKwtnxzIUGiQqEJnpHWUbEn/OJaSxRR8dqxc7f7Hi1mMFEY04whblNwvT+HMQ5P12Sx2zorExZQpT8uvpU5nXe1HKnMCboiiMhSAmpy5G/k3+Rw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 67954251-18d7-44fa-1ece-08dee1c74287
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 16:45:06.6977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TqxBVvuZQOOmZvDN7MLMpDRdwZdeUysi4hMmEKwEP4QV/kktXBihFKu/KKfUNt+MKSfifE4b/x8t0z+WivZlrcKS/jr5GRYsbAi5INAWF0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6672
X-OriginatorOrg: intel.com

Hi Tony,

On 7/14/26 9:01 AM, Luck, Tony wrote:
> On Tue, Jul 14, 2026 at 08:18:30AM -0700, Reinette Chatre wrote:
>> On 7/10/26 1:51 PM, Luck, Tony wrote:
>>> On Wed, Jul 08, 2026 at 03:50:45PM -0700, Reinette Chatre wrote:
>>>> Hi Tony,
>>>>
>>>> On 7/1/26 2:35 PM, Tony Luck wrote:
>>>>> Application Energy Telemetry (AET) event enumeration takes place
>>>>> asynchronously. Linux builds the pmt_telemetry module into the kernel to
>>>>> kick off enumeration early enough that it completes before first mount of
>>>>> the resctrl file system.
>>>>>
>>>>> Allowing pmt_telemetry to be a loadable module means that it is possible
>>>>> for different numbers of RMIDs to be supported on each mount, depending
>>>>> on whether pmt_telemetry module is loaded.
>>>>>
>>>>> For simplicity, calculate the maximum possible number of RMIDs and use
>>>>> that value to allocate the rmid_ptrs[] array just once. Also use this
>>>>> maximum RMID value when allocating rdt_l3_mon_domain::rmid_busy_llc
>>>>> bitmap and rdt_l3_mon_domain::mbm_states.
>>>>
>>>> This does not sound right. Why use the maximum RMID for L3 monitoring state?
>>>> It can be guaranteed that L3 monitoring state is only accessed when that
>>>> monitoring is enabled and when it is enabled it can be guaranteed to never
>>>> use more RMID than what L3 itself supports. Why would it ever be required
>>>> to allocate more than that? Could this not instead be limited to
>>>> rdt_resource::resctrl_mon::num_rmid? From what I can tell such transition
>>>> will make it explicit and consistent (since arch code already allocates
>>>> this state based on this) how the L3 monitoring state is sized.
>>>
>>> L3 monitoring on X86 happens to provide the overall maximum possible RMID
>>> value (any larger value with #GP fault when written to IA32_PQR_ASSOC MSR).
>>>
>>> AET could potentially claim to support a larger number (and this could
>>> happen on low core count SKUs where the number of RMIDs supported scales
>>> down with the number of cores).
>>>
>>> resctrl_arch_system_max_rmid_idx() needs better comments, and
>>> implementation. On x86 even if the L3 monitor functions have been
>>> disabled, the limit is still bounded by CPUID. Not by what might
>>> be found in the AET->mon.num_rmid.
>>
>> I see. I assume the implementation change you refer to involves dropping
>> usage of r->mon_capable that depends on rdt_cpu_has().
>>
>> How much to rely on CPUID is not clear to me. The direction seems to
>> be to move away from CPUID, which makes adding new CPUID dependencies
>> less ideal? 
> 
> Here's my current work-in-progress version:
> 
> u32 resctrl_arch_system_max_rmid_idx(void)
> {
> 	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
> 	u32 ret;
> 
> 	/* CPUID provides maximum possible RMID value */
> 	ret = cpuid_ebx(0xf) + 1;

There is also boot_cpu_data.x86_cache_max_rmid initialized in resctrl_cpu_detect() that
could be used directly? Looks like resctrl_cpu_detect() already scales the number of
RMID down if needed when L3 monitoring is supported, but it does not take SNC into account.


> 
> 	/*
> 	 * if system is capable of L3 monitoring the maximum RMID value may
> 	 * be lower that system maximum. Either because the L3 monitoring
> 	 * feature supports fewer RMIDs (CPUID(0xF, 0x1).ECX), or because SNC
> 	 * (Sub-NUMA Cluster) is enabled and divides RMIDs per cluster.
> 	 */
> 	if (r->mon_capable)
> 		ret = r->mon.num_rmid;
> 
> 	return ret;
> }
> 
> CPUID seems unavoidable in the case that the platform doesn't support
> (or has disabled the various L3 monitoring events). In that case using

Since L3 monitoring is the only CPUID supported monitoring resource I do not
think cpuid_ebx(0xf) can be used if the platform does not support L3 monitoring.
I expect that would mean that leaf 0x7 would indicate that monitoring is
not supported which would make leaf 0xf invalid? Interestingly resctrl does
not seem to consider X86_FEATURE_CQM from leaf 0x7 at all and just goes straight
to leaf 0xf.

> cpuid_ebx(0xf) gets the max value that can be written to the RMID field
> of IA32_PQR_ASSOC. This is common to Intel and AMD.
> 
> If RDT_RESOURCE_L3 monitoring is enabled, then it could impose a smaller
> value from CPUID(0xF, 0x1).ECX. SNC might also divide down the RMID
> space per node. That calculation has already been done, so just re-using
> the result from r->mon.num_rmid avoids mistakes.
> 
> Even if AET supports a larger value of num_rmid, the system is limited
> to what can be written to IA32_PQR_ASSOC, so no need to scan all
> resources.
> 
> 
>>> Though perhaps intel_aet.c should look at CPUID to avoid believing any
>>> larger numbers seen in AET enumeration.
>>>

...

 
>>>>> @@ -970,27 +984,29 @@ int setup_rmid_lru_list(void)
>>>>>  		return 0;
>>>>>  
>>>>>  	/*
>>>>> -	 * Called on every mount, but the number of RMIDs cannot change
>>>>> -	 * after the first mount, so keep using the same set of rmid_ptrs[]
>>>>> -	 * until resctrl_exit(). Note that the limbo handler continues to
>>>>> -	 * access rmid_ptrs[] after resctrl is unmounted.
>>>>> +	 * Allocate the largest number of RMIDs that this system will ever
>>>>> +	 * need. These cannot be freed until resctrl_exit() because the limbo
>>>>> +	 * handler continues to access rmid_ptrs[] after resctrl is unmounted.
>>>>>  	 */
>>>>> -	if (rmid_ptrs)
>>>>> -		return 0;
>>>>> -
>>>>> -	idx_limit = resctrl_arch_system_num_rmid_idx();
>>>>> -	rmid_ptrs = kzalloc_objs(struct rmid_entry, idx_limit);
>>>>> -	if (!rmid_ptrs)
>>>>> -		return -ENOMEM;
>>>>> +	if (!rmid_ptrs) {
>>>>> +		max_idx_limit = resctrl_arch_system_max_rmid_idx();
>>>>> +		rmid_ptrs = kzalloc_objs(struct rmid_entry, max_idx_limit);
>>>>> +		if (!rmid_ptrs)
>>>>> +			return -ENOMEM;
>>>>>  
>>>>> -	for (i = 0; i < idx_limit; i++) {
>>>>> -		entry = &rmid_ptrs[i];
>>>>> -		INIT_LIST_HEAD(&entry->list);
>>>>> +		for (i = 0; i < max_idx_limit; i++) {
>>>>> +			entry = &rmid_ptrs[i];
>>>>> +			INIT_LIST_HEAD(&entry->list);
>>>>>  
>>>>> -		resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
>>>>> -		list_add_tail(&entry->list, &rmid_free_lru);
>>>>> +			resctrl_arch_rmid_idx_decode(i, &entry->closid, &entry->rmid);
>>>>> +		}
>>>>>  	}
>>>>>  
>>>>> +	/* Find how many RMIDs are needed for this mount */
>>>>> +	min_idx_limit = resctrl_arch_system_num_rmid_idx();
>>>>
>>>> Since mon_capable resources can now come and go from mount to mount there are scenarios where
>>>> rmid_ptrs[] may be smaller than min_idx_limit so above needs extra checks to protect against
>>>> overrun below.
>>>
>>> I don't intend for that to happen. The initial allocation of rmid_ptrs[]
>>> is supposed to be large enough that no subsequent mount would need more.
>>>
>>> I.e. resctrl_arch_system_max_rmid_idx() must return a value >= than
>>> any subsequent resctrl_arch_system_num_rmid_idx() call.
>>>
>>> Perhaps I should add this to resctrl_arch_system_num_rmid_idx()?
>>>
>>> 	num_rmids = min(num_rmids, resctrl_arch_system_max_rmid_idx());
>>
>> While trusting the arch helpers to "do the right thing" occurs frequently in resctrl
>> as a result of its evolution I do not think this is something that it should keep doing.
>> I think it will be more robust for resctrl fs to protect itself here. For example, could
>> resctrl fs obtain a new partner variable to rmid_ptrs[] that reflects how many elements it has?
>> This could be done in addition to changes to arch helpers that will then be required to
>> meet resctrl fs expectations.
> 
> This is a good idea.  I can switch "max_idx_limit" from being a local
> variable in setup_rmid_lru_list() to being global (static). Initialize
> it exactly once from resctrl_arch_system_max_rmid_idx() here, and remove
> all the other local copies and initializations.
> 
> setup_rmid_lru_list() can then defend against bad resctrl_arch_system_num_rmid_idx()
> return values with:
> 
> 	/* Find how many RMIDs are needed for this mount */
> 	min_idx_limit = resctrl_arch_system_num_rmid_idx();
> 	if (min_idx_limit > max_idx_limit) {
> 		pr_warn_once("Attempt to use too many RMIDs\n");
> 		min_idx_limit = max_idx_limit;
> 	}
> 
> Does that seem reasonable?
It does, yes, thank you.

Reinette


