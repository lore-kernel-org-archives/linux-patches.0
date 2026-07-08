Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCB3282F29
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 22:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783551172; cv=fail; b=r1zNqLIjQcRfaNYaxtn8DTP/8utnGtuBkPJmKVEPY4/3TVANWULiGNekLXx41Gk/2LtDpl5QiOAtEQ06H+cpCbz5PBli12ghbBudUWjWTFeW/Kn7arGxKtg9YVE+0IjlteKw6ioree6e1t/pRmeHlWArlc663sDaQD7/ScSM/fo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783551172; c=relaxed/simple;
	bh=9Gy0WEyGy/kb9/P1tWw/6vevE7PnHdHVPK459X29E9s=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JjiaWH6eB6vg4MsNn2OZfB6LxcyB8ycEIWccT6JdaYH3wwztFxqgPRbfFyzPeHLFyWL/LeAtkaW5ZbFKJvEB+8bPHMwYzYadHjBN4qEJ7Mcp27s88Gz6u5fg5kddCzl+TiFi0WBP6vIW443eWEpbft31u0yPSkZuSo+bHmobY0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l4sXJhtd; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l4sXJhtd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783551170; x=1815087170;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9Gy0WEyGy/kb9/P1tWw/6vevE7PnHdHVPK459X29E9s=;
  b=l4sXJhtd7IexMP+kyagyeUqLDOI68/bi0E905wHdE9Saj9qqhgMVwWH0
   ExvpCOBZgG1oO2AkBxX1jS3MLI3gOMXj2/0TyI5Sf3KWA/RMi9jj4ntTD
   ST0sxk09vgjNvNdmxF2XaHrSE1Rc8ZgTBbDQ27kf2e+K7DcKLaeZ4hhFo
   8YUW0VG+pCZJj6jKZTJXCw/FczkgqILz8/lQAyVeZFDtgKNTquay0rQuh
   rTfk4hi3Tu2HSnSevlNKmXh/O3LSu7UNonyAI5BpHIDgbnxl62j3lnPyi
   Sxmzj4uZF1PoJ/+v+9Cxj5mAJ0I+Ugj5sQMa1qBO5KedFcjlLXFJi5514
   g==;
X-CSE-ConnectionGUID: ga0chNAmRkqATMHKmoGjNQ==
X-CSE-MsgGUID: pBbaREF8Sx+H6pK9iTiVrw==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="84007887"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="84007887"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:52:50 -0700
X-CSE-ConnectionGUID: VMcRHwrXQ/2mpWxHVca9TA==
X-CSE-MsgGUID: SG/PuUhPT4qm8CZwncqvzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="255064242"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2026 15:52:49 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:52:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 8 Jul 2026 15:52:48 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.25) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 8 Jul 2026 15:52:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K9boPHTHbfdQYboKVFoS1yzyU5RxVxEorcAA9pOX+yUdJzS067ixnvRAZEZHiBIQxkuOOQWzCst8owGi4j80ayAqz8S65SoJE13S4IR0dtTCs1eeda8fTGw+SlRBlGQkrJySn4OvVcYDqremPvMJqt/Yf8acq0jXafcZZ0OlR5phFvFi1edkXBAFeLigtbZ8jJyJCIOgsJArezUxHZocNkEiQyDcSP9kcDyxWazCGOxd/I/G4u9Sqn+dX4S3TPOzN6rc8+eaRCpyRnCGqhoC9z+qQMOgFJuXQHujZLqYUVFO2wQL4h6YHtZC+Bh7EPpioF/M/EcMlR8YsS1cBdJVFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jx9hyPYz/afHhPJvqqz5FcgXLjOjMnyK1fMCqYk6xIY=;
 b=aUSgQuZTv1UsX40R1NVlC6xJ8XWH0g4QvhBt3cQkKGelwGvm77fsgU2i3zk7g2iHB8QGQooRb4B2V/wMpqHxr33Jqwka7hT4WO3EW0QsNBV/BJeqOt30U1Lz64fMWUL7Ra4jansv4qVwcrGsMcKkpw6fEabxFSM9AO3sRQAwlpGePwNGV1YkUO901fPf4oj47FCoqnb/Tn5+1EsocXHkLz+21GxllpgoI2KTp0y3wqrcoRlkLR9eqkRV4e9iKEAmZrOVhFvLYrFlUSmZmQyC3wc4dVJY31VIVy1arW2UoMtpY1KfwyIF7YD+qLjBNvi58G/xRCJkSYjlGxtsYoJEEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM3PPF99D0888FA.namprd11.prod.outlook.com (2603:10b6:f:fc00::f3d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.14; Wed, 8 Jul
 2026 22:52:38 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 8 Jul 2026
 22:52:38 +0000
Message-ID: <9b83fb5c-302e-4306-946b-cd65351f794e@intel.com>
Date: Wed, 8 Jul 2026 15:52:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/12] arm,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-10-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260701213553.15222-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0235.namprd04.prod.outlook.com
 (2603:10b6:303:87::30) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM3PPF99D0888FA:EE_
X-MS-Office365-Filtering-Correlation-Id: 15555707-ee04-4e01-0c17-08dedd439be4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|7416014|6133799003|18002099003|22082099003|56012099006|5023799004|11063799006|4143699003|921020;
X-Microsoft-Antispam-Message-Info: gYY4UVYec/9zxXOSnsbi0vzTfT0TC+jlQO1BZ/fPJ7QtBCA04wAOH4n44Jn/WVKcsS9CcX32yBo1c+3uKTXaHOakEc6jEJVIYlDLW9SXZCZaQ+LVGjuiWoP/3Msf5riayeJEvtsiti70ZdefFHZtgnUd9bT2XXpyakT+S/5KQEdAVjtZGdpEVvUjGBX/q48GLY1rCPKNY8/usU9yffO6R9K7bxKy0s/n0HeK0JZMDrkgpFnY24M6ED6pwmC/fxEpDUH60Ci7zaDrs6E2h/Hv6CrI0HaLqq7qjoEeLsLphLEcB9qNTHCojYcPM6/2d9JVzzaB47l7SfQ78mIyviq8iEpYI67908FlmGYm0EjRQgaSATOtZnpaWiDXc3sjyxnle0yKi6+J2mvOXD4vVuJytB7Qv1WBXFhQwuVcJai+gD6rTYdlP/wo1Qz3mQBSn0d1ChiI2rLO4nPnAp4avOipabwULnQnrnmDVPBTTadpuqBZmpfD/gj+Rd1MieTLQk/fIhQQPvQeacQahFW31vGSpJNsN+CngUiVaY9QIvbhI/ROmLwFPfndxg4uZCdy4sTkRywqVcTs46F2Ksy87lgYkmzTka36NVIcgflZZQwONavUE0/R1tdUVIXAJAAepGMHnju3fgLahMI5LVkLX7XvzcW2dMpLVoFWBqk+VzEy6M8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(7416014)(6133799003)(18002099003)(22082099003)(56012099006)(5023799004)(11063799006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlNXZDBkSGVLUkN4UVZ2K1VtRjl6eUVpczZZVkZkSzRxUUk4ckVEZmlmVm9Z?=
 =?utf-8?B?bzFXVkV5RThYc2FxRU8xRW50cmJBdk9oYkQzaU1CMHBqSlNRNnJUbU1FUVQ5?=
 =?utf-8?B?L2hpN09pR1lSME82WTk4T0tOdUt5VFhyWVhIUWFCNjVPQjdvbHNmdTZqcW5j?=
 =?utf-8?B?ZXNHUHpHSllVMmNGSjdwNEpZVTJ6SmRJYkFnWkFXM00yNnVkYUxUVWVBOHBs?=
 =?utf-8?B?eExGZDU4dkZHbkkrQlRreS9NSGVQeFg2Y0VGM296UmFmQmcvbE4xZUxNWk0v?=
 =?utf-8?B?SG41R2FTUnNoOUxRY1Z1MkdCLzRjQytJdmhwWkQyUy9wdHk4NHBVZGMzL0ox?=
 =?utf-8?B?YnptR1J6QVY5V2VGQ2hSQmlFTUZXaVZFT1pLY2RTWVk0MFk3UVRWTGt0Vkla?=
 =?utf-8?B?SHRUK3dTbWM4Vm1hdVhaQkY4TExVQTN4enFsN25YRnVnSTdndDFnWEpZNjZM?=
 =?utf-8?B?Q2pOMGdncmw2THJyM2hUaTBYcEVnSi95THpOTkx6NUtRVVNRcERZSlVqeDg4?=
 =?utf-8?B?R0NuU2xObi8xTXlGWC9pR1VIQ2VrYm10TWh0TmdIcnRzdUFkNEdRS1ZmSHNW?=
 =?utf-8?B?cFMxbjQxMzBPZyt0U3pscEptRzJtMlRuVnRsOWZhZENlcDJkZC90OW92UWE4?=
 =?utf-8?B?M3UwMkN3RVZkN2JCUXpKYTVML0lONDNBQWlFeVk5cUpCOEhCT29GWGJFQWxu?=
 =?utf-8?B?SUE2SHA5VzVXblNpRk9nR1ZVMnUyMFU1WlNOSXVpY0hlaGViWm9PTEFUbDBs?=
 =?utf-8?B?VDUrcnFXcjBRNlJVK2w1aUpKdVQyWWlWWXVFeHlTRk5QV1JOL3RDU1hPd29J?=
 =?utf-8?B?aXBlM1E4Vy8rZXdVOHMvSk83S1hCdUM4VWR4UjYzNkQ0UFIzOHZxQmdkNjl6?=
 =?utf-8?B?OUZUV3M1VVdPV1VIMnU1cUhqWmk5Yit6OUhSL1VIbjJxeG9CZGF4VmlOQ3p0?=
 =?utf-8?B?Q0JYTjVScEhITHNtcE93YUVWMkFUbitTWUg0NXl6UHFwajhBNjVOVjllcWh2?=
 =?utf-8?B?R0YzL1ZTclVaVWFYS3NnakxCdDh4RmNycVdOVFB6dlZNWkhiTEVNUk54dWV6?=
 =?utf-8?B?Q3NoM290aldhWlhmVUFVaWFzUkZITE9QeHg1cEd2UHlzTnNqTi94OG5RRXpw?=
 =?utf-8?B?eTB2SHJldkJ4NkRybGlrc1JpWTFCNy9ZZ2hoSmpoVHFpeGp4MUJhT2ExMHlH?=
 =?utf-8?B?Zk8yZUlkUW1Yd2FJRlA2cG1nZDEyYW1iWUpuWUdWMlhhZ3R3WG10K0UyVkox?=
 =?utf-8?B?NTh5ZHNJQVIxbGNxeHhSREtMcVlmOVhncnM3NDVjSmJMT0FsanhkYUdDbVcw?=
 =?utf-8?B?OFI4a2U0eWROaE1XOWhkNjNNVEhGZnQybVZxZklBVFNuME9CZDIrUEQ2UElq?=
 =?utf-8?B?blZncFppSmU2ckxvaFA4VVpnM3B5UGxaY0lZczZpSlVaODducHJYR1hrcDJM?=
 =?utf-8?B?MUFMMm9RRkViSWZ3TUg2UEtiUnIyRm9OMXBTa3ZDRE9SV0pldnE1S1dqYVJ4?=
 =?utf-8?B?NVRFeHVENGg1ZXN3TG4zWXExQ2tpRzJxNktCMGdwalE3L00xc3FVWEdZV1Mz?=
 =?utf-8?B?OXd1eTBMa3NFNkNqYWs3cmRvSmpvaGJucldLSnBpbUdJRVdxOUJOZjVYenRw?=
 =?utf-8?B?Q2NkcEI1eTVkbnN4VUY4alRFSVJsYmwzMUFZejhNYkZWREVxNkpFRmhLcWlw?=
 =?utf-8?B?VTMwZzU4V0FmR25RVGRkWWtZK2x1L1YzRmhEOWhWV09sRlJ1SmVmbVdSUUlO?=
 =?utf-8?B?T1FOaFhSdmlyOTNKdllVakIySThheXBJZURtRVoyeENoUExBY1JuVzhjMk9S?=
 =?utf-8?B?aXUyVXJlbmEreEU3ZDhVdGpSQWp1Q2RRVTBFbForK0ZUcFpjUGZkMmtpY3pv?=
 =?utf-8?B?bGhYOGFnd0JGVXEvakptSFJyTGtPN2xjSVREcUJpNXpQWFpwY1ZIMkt6UjZE?=
 =?utf-8?B?WGR0YUFlMWRJeDFZVFJpQ1JVT1ZQdm11K0pKMVRaRWU2dy9peVJVNFo1V3Vu?=
 =?utf-8?B?ZEFxRk1nbklyWHJDaXQ2b1Rnd1JFRzZPRVltQW1WNUlscTBYRWZQUjVrc1o3?=
 =?utf-8?B?c0Q5YWljRDFIYjFjcWRadUZiN3ZtYWpxUm5XeUQzRWt5VjJVbnN6bVJHNGp1?=
 =?utf-8?B?Nkk2YzNnSm1BM3RzNG5ZOU1ZZ1ozdCtLY3o1TG5VOWN2bHBVaGYwYjV3VFpW?=
 =?utf-8?B?V2FBd0NVakdQbThCWUpUaEh3SlpNSjliMFczOUZWWXgyRXl2OVJGSm1rSVhD?=
 =?utf-8?B?UXZ5UlkxN3hjS2hrTlEyaWx6U0hGL001Zjl2TjJzeGZsYkJKa3ozREo0S1Y4?=
 =?utf-8?B?ZG5sVFhCd1BmcU1Jb2d3VENhekErb2lDUmNzOTZabzdZWnBPME1ya0dhZjJv?=
 =?utf-8?Q?N08OK8Eccj2KZj7Q=3D?=
X-Exchange-RoutingPolicyChecked: P4ODjj1ixkU0mp864xipjeHT8/qAtmjAZtVopO2E9sc6v4eF0A74xlHKiowAun4rmGXcG+JxX5nJUn5NWrwcgNM8ofV/HqCaTA4f0cRTR2L0Y3Tp3FWByQ4cO55XBwypwpYCn0n1KKqpPfWjEBm7EBWn7d7mPNf6jvP3cnL9UacujGN6DxsnE7enOMn3kiGDcHFP2BBYI4NSq+GrD9OSTAN/p5OQRxD5fyg2JLu9cPUwhPNNwr9/w0LIGgDUq2zV6VvISBIBW8f0kQFtuFfrifhuHVE88LoLFn7mb52sBvrtKTBxqXUkb5CU78EjKbIhRCI+A0rOpkSIJN2gLrhlFQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 15555707-ee04-4e01-0c17-08dedd439be4
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2026 22:52:38.2508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8/7tJShq1IG/dKFb3qPM84ILy4aGHjXv6FBzPQj9dZ0XVJ3VcF4t+hI4CrPKg5fuILEZcLcRJ5TVKk6QdgDbBkNCTCZq24VgX8K9K1XaoNk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF99D0888FA
X-OriginatorOrg: intel.com

Hi Tony,

On 7/1/26 2:35 PM, Tony Luck wrote:
> resctrl is always built-in, but INTEL_PMT_TELEMETRY and INTEL_TPMI are
> logically independent and should be loadable modules.  Switch AET to use the
> function-pointer registration API instead of direct link-time references to
> PMT symbols.
> 
> Prepare for the file system to call resctrl_arch_pre_mount() on every mount
> by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
> resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
> the filesystem is not mounted.
> 
> Remove intel_aet_exit because all cleanup now happens in the unmount path.

intel_aet_exit -> intel_aet_exit()

At first glance this change does not seem symmetrical since it introduces
the new enumeration and cleanup calls but does not call the cleanup call that
appears as though it keeps a reference to the module. I think it will help to
highlight that the previous exit code was not called anyway and at this point
the module is still required to be built in so there is no actual reference taken.

> 
> Note that the Linux file system code does not serialize calls to
> fs_context_operations::get_tree(), so there may be arbitrarily many parallel
> calls if users invoke mount(2) multiple times.
> 
> Use "pmt_in_use" to detect nested mount attempts.
> 
> event_group::num_rmid may be reset (reduced) during enumeration. This is
> not worth resetting on unmount because the same reduction would occur on
> each subsequent mount.

If event_group::num_rmid gets a mention, should rdt_resource::resctrl_mon::num_rmid also?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> --
> v9:
> 	Drop broken atomic ops introduced in v8
> 	Check pmt_in_use in intel_aet_pre_mount() to detect nested
> 	mount flow.
> ---
>  include/linux/resctrl.h                 |  6 +++
>  arch/x86/kernel/cpu/resctrl/internal.h  | 23 ++++++++--
>  arch/x86/kernel/cpu/resctrl/core.c      | 25 +++++++++--
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 +++++++++++++++++++++----
>  drivers/resctrl/mpam_resctrl.c          |  4 ++
>  5 files changed, 101 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index e1501ee72d28..4dc41dc99dc2 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -564,6 +564,12 @@ void resctrl_offline_cpu(unsigned int cpu);
>   */
>  void resctrl_arch_pre_mount(void);
>  
> +/*
> + * Architecture hook called when mount fails, or on unmount.
> + * No locks are held.
> + */
> +void resctrl_arch_unmount(void);
> +
>  /**
>   * resctrl_arch_rmid_read() - Read the eventid counter corresponding to rmid
>   *			      for this resource and domain.
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e3cfa0c10e92..a891017f69ec 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -234,15 +234,15 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
> -bool intel_aet_get_events(void);
> -void __exit intel_aet_exit(void);
> +bool intel_aet_pre_mount(void);
> +void intel_aet_unmount(void);
>  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
>  bool intel_handle_aet_option(bool force_off, char *tok);
>  #else
> -static inline bool intel_aet_get_events(void) { return false; }
> -static inline void __exit intel_aet_exit(void) { }
> +static inline bool intel_aet_pre_mount(void) { return false; }
> +static inline void intel_aet_unmount(void) { }
>  static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val)
>  {
>  	return -EINVAL;
> @@ -253,4 +253,19 @@ static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resour
>  static inline bool intel_handle_aet_option(bool force_off, char *tok) { return false; }
>  #endif
>  
> +#ifdef CONFIG_INTEL_PMT_TELEMETRY_MODULE
> +static inline bool intel_aet_try_module_get(struct module *mod)
> +{
> +	return try_module_get(mod);
> +}
> +
> +static inline void intel_aet_module_put(struct module *mod)
> +{
> +	module_put(mod);
> +}
> +#else
> +static inline bool intel_aet_try_module_get(struct module *mod) { return true; }
> +static inline void intel_aet_module_put(struct module *mod) { }
> +#endif


Trying to look back to how the above ended up like this I find:
https://lore.kernel.org/lkml/SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com/
that states:
	pmt_module is NULL if CONFIG_INTEL_PMT_TELEMETRY=y ... i.e. built-in to the kernel.

	In that case it obviously can't go away, and doesn't need module_get()/module_put().
	There's no special case for this. try_module_get() takes a fault on NULL dereference.
	...

Taking a closer look at try_module_get() I do not see it attempting to dereference
a NULL parameter but instead it returns true in this case which makes the above unnecessary?
What am I missing?

> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 3169441a2d40..3ef620d8e0c8 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -16,10 +16,12 @@
>  
>  #define pr_fmt(fmt)	"resctrl: " fmt
>  
> +#include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/mutex.h>
>  
>  #include <asm/cpu_device_id.h>
>  #include <asm/cpuid/api.h>
> @@ -798,7 +800,7 @@ void resctrl_arch_pre_mount(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int cpu;
>  
> -	if (!intel_aet_get_events())
> +	if (!intel_aet_pre_mount())
>  		return;
>  
>  	/*
> @@ -814,6 +816,25 @@ void resctrl_arch_pre_mount(void)
>  	cpus_read_unlock();
>  }
>  
> +void resctrl_arch_unmount(void)
> +{
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	int cpu;
> +
> +	intel_aet_unmount();
> +
> +	if (!r->mon_capable)
> +		return;

Could the mon_capable check be moved before intel_aet_unmount()?

> +
> +	cpus_read_lock();
> +	mutex_lock(&domain_list_lock);
> +	for_each_online_cpu(cpu)
> +		domain_remove_cpu_mon(cpu, r);
> +	r->mon_capable = false;
> +	mutex_unlock(&domain_list_lock);
> +	cpus_read_unlock();
> +}
> +
>  enum {
>  	RDT_FLAG_CMT,
>  	RDT_FLAG_MBM_TOTAL,
> @@ -1187,8 +1208,6 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> -	intel_aet_exit();
> -
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c26bd813e057..c2e27ce52248 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -25,8 +25,8 @@
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/minmax.h>
> -#include <linux/mutex.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>

This can be squashed with earlier patch.

> @@ -310,7 +310,7 @@ static void (*put_feature)(struct pmt_feature_group *p);
>   * struct pmt_feature_group to indicate that its events are successfully
>   * enabled.
>   */
> -bool intel_aet_get_events(void)
> +static bool aet_get_events(void)
>  {
>  	struct pmt_feature_group *p;
>  	enum pmt_feature_id pfid;
> @@ -319,14 +319,14 @@ bool intel_aet_get_events(void)
>  
>  	for_each_event_group(peg) {
>  		pfid = lookup_pfid((*peg)->pfname);
> -		p = intel_pmt_get_regions_by_feature(pfid);
> +		p = get_feature(pfid);
>  		if (IS_ERR_OR_NULL(p))
>  			continue;
>  		if (enable_events(*peg, p)) {
>  			(*peg)->pfg = p;
>  			ret = true;
>  		} else {
> -			intel_pmt_put_feature_group(p);
> +			put_feature(p);
>  		}
>  	}
>  
> @@ -359,16 +359,58 @@ void intel_aet_unregister_enumeration(void)
>  }
>  EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
>  
> -void __exit intel_aet_exit(void)
> +/*
> + * Track whether pmt_telemetry enumeration succeeded during mount to
> + * detect nested mount attempts and for use during unmount.
> + */
> +static bool pmt_in_use;
> +
> +bool intel_aet_pre_mount(void)
> +{
> +	bool ret;
> +
> +	guard(mutex)(&aet_register_lock);
> +
> +	/* Nested mount attempt. File system code will return -EBUSY */
> +	if (pmt_in_use)
> +		return false;
> +
> +	if (!get_feature || !put_feature)
> +		return false;
> +
> +	if (!intel_aet_try_module_get(pmt_module))
> +		return false;
> +
> +	ret = aet_get_events();
> +
> +	if (!ret)
> +		intel_aet_module_put(pmt_module);
> +	else
> +		pmt_in_use = true;
> +
> +	return ret;
> +}
> +
> +void intel_aet_unmount(void)
>  {
>  	struct event_group **peg;
>  
> +	guard(mutex)(&aet_register_lock);
> +	if (!pmt_in_use)
> +		return;
> +
>  	for_each_event_group(peg) {
> -		if ((*peg)->pfg) {
> -			intel_pmt_put_feature_group((*peg)->pfg);
> -			(*peg)->pfg = NULL;
> +		struct event_group *e = *peg;
> +
> +		if (e->pfg) {
> +			for (int j = 0; j < e->num_events; j++)
> +				resctrl_disable_mon_event(e->evts[j].id);
> +			put_feature(e->pfg);
> +			e->pfg = NULL;
>  		}
>  	}
> +	intel_aet_module_put(pmt_module);
> +	pmt_in_use = false;
>  }
>  
>  #define DATA_VALID	BIT_ULL(63)
> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 7079870ca894..5859cc0f5e37 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -162,6 +162,10 @@ void resctrl_arch_pre_mount(void)
>  {
>  }
>  
> +void resctrl_arch_unmount(void)
> +{
> +}
> +
>  bool resctrl_arch_get_cdp_enabled(enum resctrl_res_level rid)
>  {
>  	return mpam_resctrl_controls[rid].cdp_enabled;

Reinette
