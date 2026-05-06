Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216613AE189
	for <patches@lists.linux.dev>; Wed,  6 May 2026 20:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778099628; cv=fail; b=J0SYtHEsl0xVGDxhRlUFz38M/PaY9zS8UBczICFf/iHIEzxy6EhiBT/1pefBPPP0kmnNwzEsFMlLtRHYWil4klZmCWCID6GtOp71/D5WDvKniHCWmE7Mzz/JOpNbyw/z3Kxx8OrQTuOl38wc0Ybjdsp85q7i5WC+CUgplENWbN8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778099628; c=relaxed/simple;
	bh=vt3wVUhcWH/m/KGaHTZ81YHngkFbYyo1uNHj1y+AYXQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q92KB4RsXGSndjKOUae0SU2X72U0xnQ/4AswxBB7aafCyy2f8TEpaQwhdsOQMK2SVWo34ATqguT8RzUeiMIga4l5cIgjQq6xI99AmEwHsrpB+VD4GaiNU3baULMQ9P+HAqDN4uIm5X8rNpBFR9PElVkJeZWpFK/T/+4XeHlroAo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Iqr2W05o; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Iqr2W05o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778099627; x=1809635627;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vt3wVUhcWH/m/KGaHTZ81YHngkFbYyo1uNHj1y+AYXQ=;
  b=Iqr2W05ou/ZNyI0sA5/HkhWj0mLo2m4YgQKIZEhY9YWXpFdzAx6kLtKX
   poRdc2B+x6UHcCv/jysex8cC5/YUBgK34jZ5l8fnLC7ToEEk9hmnIYSP8
   MeuOugft9hYTmQKDFPbQ2ZcqvXgCgskUZg2fmStfBWGs9sgQsDE6Os/cZ
   6GU6f9B87YLFmAEeJcKI1RLS7Qf2brwIalj8SPNlBx2bha6E9Xijrf/l/
   jD6qD2JURf0LrpwA1gF0N8pg4iZ0btVtB0nVtHsrEA58ph5Hi4H0V0rDf
   tL8vXlDrNpv971XLtnrjfYnf/uZRpv6NXby/udh8+1Jn0SFU6O18mQBa/
   A==;
X-CSE-ConnectionGUID: js0mpfAvQHO8tg7qEwxBHA==
X-CSE-MsgGUID: Ca7XpXgpRLqK3xOhZX0ECA==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="104503347"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="104503347"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:33:47 -0700
X-CSE-ConnectionGUID: 7+HhNOYcT1eUUVTImDBjXg==
X-CSE-MsgGUID: bmwpwxSmSEqv+y4VYK6Zmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="235394671"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 13:33:47 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 13:33:46 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 13:33:46 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.44) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 13:33:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T3pDdm+jk0JI5Q7ygvaNA3jiC0x6dMvxcDwFx9kyXu7duyDN0sXGl3sJDfkS28Aqi5wbpomWcQ2waIjs0W3Dak5+BSTdMaaClte1NYNUicmyVJ4NiZm1hfS9Muj+7myz88kwo394xWJuK5t8HuJgpXQqghlMIEHKSahIPf8fmOWhoAt11d8yWMoffsS+66Nkh/NqP738Ns0PhTl5Y0wwUszRnAPbGPXdqlvoDZldOiW3QHW91PhWQSt+Oxgv+tBOm0HzUT2ykaGBz5pI9Dw95dobeiv941yksiLwE2FGIKjB0oI9n3A8pMWBEo1QvWsWVlgIdOdAHwBViska8TK/3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1s+i9VNiP1QRRI6rmFEXioQBAJ9mUK9MJHOmD75lFE0=;
 b=MwpYk3PSbpKoUD5qIm2hqo15V4XC6W0tksZ89A4VzNzHgTfyLQVCOBssHVycU11obqaVF/8m0HO2JzJ29iY9jqxU8RRF2GfRG+w6EDOQCxi+j1ZCP5NdZ+y2E8RUA4WqXuj5h5ZMcgysU9MuoYEqocp0ZfGtbYqARvuyhnnoV1gmkM5AD1BDmfFklpnVDC1fboLSNux/cOlPOkW8pq7dCawaUxwtveT7a18doGif71yMzyzf4t3UkWDiX3RbypRo83Y+icaeIbIZIf52BYYy9PHjehb0lwOtBDq4XZw/bncalSefnEfiEt8YsC9TbA/RbV0gu1X6q9ko7sXI/jtaIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7261.namprd11.prod.outlook.com (2603:10b6:8:13d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Wed, 6 May
 2026 20:33:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Wed, 6 May 2026
 20:33:42 +0000
Message-ID: <389bd92c-47ba-46af-81cb-9b669533b1fe@intel.com>
Date: Wed, 6 May 2026 13:33:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>, Fenghua Yu
	<fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afuecal0x8_2jcUq@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <afuecal0x8_2jcUq@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b5a5120-2574-49e0-d485-08deabaec309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: VpcB0kCoYBFtzOxRIMILhtguRSd03AgiW2yKUpONdjygup7+NENoMmQ8RIyG8BSxQbfFGDbTlyubvroO7e6FT5OWeFLmfQ3mLHJoMCXeKNmJ/HROGZfLNBEK2Okj4yCxsVqxZtAsBOQMKlgAqkuHlVLSNsAOg9L0+gt9FNGx5DWUXrZX8eQ5TXLSHbaDpEbUejCDcCG/GcjY+A3VUWE8XkRKCJJk1gVMwzadd3Uh5GlF/c1MHVEagpnujS5VJ5My+3dmw0acmh4w6Iwp0rd/2g7dcDr8FXLjOdDQf9GF0aT5/tOIU/qcYO/zzwCC1+1Rl6CnXPN5CfTJqjpyrSZkgz8+PKU718UJq59wMwJ1yC0IbGDL5PeVH8l2relb2DSbsY0kfC4W9o8GtgKpeNIsQjQ7VbgM7uWcwjqfJPB+jftJ69egLea9U/RNC6UNeAZsRB4nRcPP3vvxJ6YshLBZD8RtODYtrVprFHYlkOALNknIbOGMfMHuR+0+btDL88e7q0SMtRdHJWxp9ODmLxZm5p+ITThvvCj6UT9TW7YvlPtxJppVjhsu381C7rgFl2ZfzTFCAJvugs32ezJdJARoatwvGwl9lm3NgFcLqF5VPlFAG0xfHKnM2FmNIfI3NIxetZLdBR9QoldxBGjJiP2K2JvDaT4ywT+ZUn+ALSeO+E10UsBqqwuQy9bI+L+mP8FC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bTZhbkYrZTNGcEpFZVpKckFzRG04bWpJdXZHTmIrQmxMR01MZ1lxY0IyNWZJ?=
 =?utf-8?B?N0pQV2hxOEwzTVpKamErQ0dqMmpHdnc0MHFCU3R1MTlUTVNwbVZwUmZZcWh1?=
 =?utf-8?B?d2JaNTlJbHo4TW5zWXdRdzY3OTJ5N3ZiUGhJQmxCSTN0SGVIMEVUbUFWQ3Vs?=
 =?utf-8?B?SDZTUEwrWU9SbmJ5YThTSjJlS1ppTkxsYlMvRWx0TWNPc282MnYzSnpqM0RI?=
 =?utf-8?B?ME0wUi8zclMxV1NRbVJiUmtSNEl6L2pSZ3ByZ3lsKzQ4bXJXL2JuRkJ6L2RQ?=
 =?utf-8?B?a2g0RXlzeCtGZkRpMEh3NE5wbmtqR0QxS1dFU3pWWkVBaXpNTFJCQWN2SGlz?=
 =?utf-8?B?aW5mNGtNZlBFMG4rUEVQOTROSWFQYllEQTZJNlJvY25xK3VHWW5EYnlPZ3Jn?=
 =?utf-8?B?U2lFZjBqa0ljNVFQb2s4MmoxZjJnNWQ3ZUtMMEJ6RXUyamMvY1dKQUhJSmlT?=
 =?utf-8?B?b1lObkRUd2x1ZzVMeWQwSXB0MURTZWJ3NEhUbVJacW8ybUp1eDRta0QyelZE?=
 =?utf-8?B?bEt5dmhnVjIyL294aHl4ZHJJU3hWb3JZV0krREhWbnBXNWVNNHFQdExiY3RJ?=
 =?utf-8?B?YlAyYTVsZUY3bUY0a00xZDIrNU5IeElxRzJadjJLdFBCV0h1TlpsWURWamh3?=
 =?utf-8?B?RHpNaUozMlJlV0ExeUI0cThSbGhHY3ZqWVJkSzJCR3FKOUhNU0xVdXEvYnJi?=
 =?utf-8?B?aVJweWpnSTRBMWtOYkZPejFoeUl5SnhKSXgvcTRZRUs5VENkQXNYSDBqNkZz?=
 =?utf-8?B?eVhyeFI2ODBTbmh3TUxvRmhtTkdaWGtJekxXTkZnL1p2MkxUMmsrYnVsZkw1?=
 =?utf-8?B?bE5yd0JsYTltYXZMNFBQakZpWUwrc0hmZzVtK2VBOENWenJmTlhTbzdyYlZE?=
 =?utf-8?B?TjR0SWd1aVk3RkRlUFlLUXRiMVVZVmE4U2NCUHNjZS9ienIzaklGZmdaNHJY?=
 =?utf-8?B?Yk5rdW5aL083cTJCVlJOcUJZQTA0WjY5ekk4U0dESnIxNFpRL05NbjlkdmVY?=
 =?utf-8?B?dE9BM01yU0FGSWU3ck9jN3AvWlB0ekxnOUlGQnVQUXlpSk1adWR2ZVBTNFV5?=
 =?utf-8?B?a0dlQWdWcVlaVDAvSVhOOGhNRjZTam9xNlAvQlovQnNCWXFnSVoyQ2lWMHJt?=
 =?utf-8?B?THB6UXFyTk1pTVNRQkRPNzdRSzR5ZXpxM05KR1lHMkY0dTVXc0pKN1VlWWJ6?=
 =?utf-8?B?SEw0MERiYU9IUVNvR0IvOVozRmFKVDZHclNINmsyTFhudnlVVEtpY2RjVW4w?=
 =?utf-8?B?S0ZYTHVvekxaWVFTZjVCWG01Rzd6aDJqWm1GNlVRWXYyOTJ5U0RaUnNMT1ZV?=
 =?utf-8?B?cnM3a1EyaDdySzJNZ2J0bGJ0OXBhWVlpZ2ZxUUhOdzhGVTdqQVYyWWZSeG1r?=
 =?utf-8?B?Q1NwTFNHbHEwK3lkZ1BtSm5NVGVDSUsyZ0NLZXlIN20yOFloV0lldHlYdE1s?=
 =?utf-8?B?SnNuMEdWcWg4S0RJVHBuazlSQlM4UUhaSjRiaTRJRXlhV0RVU3BqK3Bpakdk?=
 =?utf-8?B?UmpSd01ZRzY2RzgyT3d1UHJvdGFTT083T3NiaGFDZjhER214aEhxc2paSEdE?=
 =?utf-8?B?d2VUY3p0eTdvK2Q4cVp6MlArRXZ0aTQ5bWpDclZJNDlDL3ptczI5NHdoK2I1?=
 =?utf-8?B?bTJma2pEdVlwSk4vWERjN25UQldYdEtQY0JCM1JkNnI3SFh5Z24rUnBzdm45?=
 =?utf-8?B?VWM2ZmtIZzRJdExLRURtV1lLb0tEVDlhd1c1ZzVzUm5EVDdPN3c2b2JuS0tS?=
 =?utf-8?B?eDUvMEMvUW5QdG9OZ2JHaTYyZk1Zd1V6Tk9qQm9sUFM3RUc5UWJkNERsaFNw?=
 =?utf-8?B?amI0Q05DWE1oNEJmSCtmVHFOUUVTNSt3TFMyZVVFT21NRkJaM2lOVXZQei9P?=
 =?utf-8?B?ZzZ4YlBmL2NnZVZIRW5xTTBTV0ZuY0hhTGh0MVlQOXl5NlVucVhmTW9SWUpD?=
 =?utf-8?B?Nm5rSFdPZXI4YUZ4U092cFFmYTRYa3Q4dVQxU2RJVnlBUGpQUUc1ZXlIeDNX?=
 =?utf-8?B?aGhZek9lVlF3bzlRSXN1UDcvUDN3S2ptMnFrdGpZcyttMUw0L3ZRczdsNjBo?=
 =?utf-8?B?WUdRNDBTMXNHNitMekFaNUlrMkR6SzBhVFNVdDBuMWFYdUZCOW43NmZhSzU0?=
 =?utf-8?B?MGZHZVNnbHN3RGtHUDJpRGJvb2RQTEQ0OXF1bkFQUjY0SEt4U3ZINTdsT09z?=
 =?utf-8?B?QTJyMGhUcTFSbkFabUo0SFMxaWlyZVA1U0NKaU1kR21SZENvc0J5ekZlSlR5?=
 =?utf-8?B?Sjk2dWFQVTIyQlRSL09naGFxNUFmbnhyWFV1WDdpUkY3ME43RHkyTEprazJO?=
 =?utf-8?B?ZVRzdGRDN0RIMEVzMWJETFNVZDMrMExCRzdRRCtMSUxrQzhaZ0pZTXd4RHlH?=
 =?utf-8?Q?IO0JHUm49wl7SuBo=3D?=
X-Exchange-RoutingPolicyChecked: ItXSTFOgyJ/YEsSJ2WTBI5gw3faDiR2KbvapCHA+0/guIY3nNDgD6I2/8Sx6e1730+xn1vR7ir1kzfGjXxI8yUN6T8E90duXfOjaUwxsRkEOtXx3thNY8Ju306QHfTTFbRlcEKJ7bYXEedc7ncXVhYgsMWH/RVGI2251DRVCNRiSWqjwOnfhWBsLKwkgs81bbDcpFSZmebcin2XF/gOYLmzt7LmAcYPKupVtXEG71GQqD6Z6BkPUYCuGW/R3AgwmlMPe4Mlgm+NawTETuMzESg1h6GfnuPn+y/T1B+XiLWFlWiO8jpWHe2CUDYyylLYhz2unaEDxckmjPHSgo35I2w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b5a5120-2574-49e0-d485-08deabaec309
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2026 20:33:42.2596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: whHS6VOQpgC2n2l0o9YZ3Dhg2Vx8nXpYLgywCrgTwDFe/L6FGA5XQlPs7SBGCkRT+l9EiAx1Lst2u/SvlnKJAGPFx5vPQJMkF9e8ymktQyk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7261
X-OriginatorOrg: intel.com

Hi Tony,

On 5/6/26 1:02 PM, Luck, Tony wrote:
> Question?
> 
>> +	if (!is_percpu_thread()) {
>> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
>> +			if (d->mbm_work_cpu == nr_cpu_ids)
>> +				mbm_setup_overflow_handler(d, MBM_OVERFLOW_INTERVAL, RESCTRL_PICK_ANY_CPU);
> 
> Should that "MBM_OVERFLOW_INTERVAL" be "0"? This worker is presumably
> already slightly late because of the offline CPU overhead and time to
> be picked up by another CPU. Maybe it should run right away on whatever
> new CPU in the domain is picked?

The delay is intentionally _not_ zero and there should probably be a comment
to make that clear. My module experiment demonstrated that when the work associated
with the work_struct is already running then no matter which CPU is provided as parameter
to schedule_delayed_work_on() the workqueue handling will schedule the work on the same
CPU as the currently executing work. Second time around is_percpu_thread() will still be
false but this time mbm_work_cpu will be set to CPU it should have been scheduled to and
work will exit without re-arming the worker and the associated domain loses its worker.

By setting the delay to MBM_OVERFLOW_INTERVAL it guarantees that the current executing
worker will be done by the time the newly scheduled worker should run and thus
be scheduled on correct CPU. I assume you are hinting that if the memory bandwidth is
under pressure there may thus be a risk that an overflow occurred? Perhaps
MBM_OVERFLOW_INTERVAL is too big - the delay only needs to be big enough to ensure that
current worker is done before new worker is scheduled. Do you have suggestions?

Reinette


