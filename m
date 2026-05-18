Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7731925BC
	for <patches@lists.linux.dev>; Mon, 18 May 2026 01:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779067057; cv=fail; b=J3ZODRbv3JURF79RQLuBwLeP4AiWORiX5NzFZjPuuDyxKeGHVmwOimIb2khjEPAjfnES6HrWYA+IFNYVBy0BxDy1heYwJAcArpLXq4UQKJfmRywdZFiy46M4AS9LQGKcrBMY7K+jSyltX4ChlCov8Zb6D1clod9piMOC4o7xyU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779067057; c=relaxed/simple;
	bh=jMniFL2BSr8VC2RBXXVAB+2G0nlXL61UQxDG/zVyX4U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=glG6yaYSGrXU/GksspwIIMy4/SrE9g6XFfRXpYI9fh5XwYC3/Xm/f3xZqOHqKwakB3jV05qV0oDJl0wNd50B2ml/dNzToPMgcgzcYVJXYVaX+fbRvZD0LuORRRe3BcAXoNclW+xMYh55oQoJG5r3XnN4k2J8/SFOLdYjmA7ESuo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MW2OIq/Y; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MW2OIq/Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779067056; x=1810603056;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jMniFL2BSr8VC2RBXXVAB+2G0nlXL61UQxDG/zVyX4U=;
  b=MW2OIq/YfhPbLto2wW78Fouep36Fzst4+OaG+lc5WNEJAoATl67xFG1E
   HFYH4+QPRjWNszMJ3nGJRNiNRsOStBHUSpoSqMA0G8baoxsECQ5m4fz7P
   LLjYeVWw0rjdCxcsmy1QON8eLjKEukh+mRTOtvn5BqSEQw1ZO+Sh9jRij
   tUfMMZsHtlo5CS4CTMb/jdOO6IdclsWkqym41bV7ESjMZ+2rhyugc9SHg
   8SmKCIl1AEUyjt5Dgpltwsu8BIVM9Kl/FGaRKmUKzxNapmiQVspg9Vuj5
   V9rILbGNENL4YDU1tLocBo9n7UXIM908wxYqtYpuIrKh2PRCTbL6gRawZ
   A==;
X-CSE-ConnectionGUID: 1tMXAUqjRk+8hCcqlyi6Gw==
X-CSE-MsgGUID: 3r9HCsc0RKCXrW9dkuSBdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11789"; a="105376859"
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="105376859"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 18:17:35 -0700
X-CSE-ConnectionGUID: m3L4GfqgQZaay8cdQk+dwg==
X-CSE-MsgGUID: lMlCA3AvRFqo7MYW1dYbYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,241,1770624000"; 
   d="scan'208";a="244232407"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2026 18:17:35 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 17 May 2026 18:17:34 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Sun, 17 May 2026 18:17:34 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.29) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Sun, 17 May 2026 18:17:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NrsMiPYQ9545TwGPl2IpPk2lsgjm1SOkXsjwFW2zZ8eT2G6HdjeP0Oh3J1pHGywyua3Xo0jbniQA5oRy+Og2gyNdtF+FVcm/r+ZLL/rvsWgWZjHAZ7T2YbjnMII/jvynY0kWYi6aALnkSbA5vCm7BqMxAKM7WYoNMocRw7toz1yHU8LTHYVQfIfo+OUa4xnMPhvCXUTMfTUcQZLP9L32PhzxoXie1soyh87vQNxcKIHnOVbcQ8LnWTScuCRIHACsZ9foyy+PLPvKwivEKuhDxhijjwPOrdPhHt9+dk3ibpre21qJN7BQNyMcAFnrueemplqWyRoaKZg8rA+Lw09u+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rS5l6hqj7ivk6+dPXkJ3div/tuTgqnuocZiTVQk3LG0=;
 b=gFRk+6+erfNiE9Aj6YJPbFan4qcKmzPSxUiCVVkEqbE8HyUeFVPb2+LsW3gj1yCI/+ftoSI2TBsuyYUTOe/3F0e9YD5h1MHdn0DV6hQw19s6c40Qld/qYgGdPNzfVjX/71gS80O3264OrGTSOxOK8ZGOJkOAaRH+tTUEL38WbxNp/4HDc6b/4ggzOsBG1UvkJ7NluWlLcDD+wU5ie5ouw5RIUDE+mk9dORvNWxRzGIIsDdW9x3qjTkIA0djExMtaXyLFF/q125iFxQx0e9dauOw2zr7a74uodZolBxRH93hXrimoOP/qIR0FTkWmhvhCcfebDMk7lVap5qhvl08ZuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 CH3PR11MB7940.namprd11.prod.outlook.com (2603:10b6:610:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.23; Mon, 18 May
 2026 01:17:31 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.21.0025.020; Mon, 18 May 2026
 01:17:31 +0000
Message-ID: <7f7712d9-2b23-412a-a3a8-e36c22b4ba32@intel.com>
Date: Mon, 18 May 2026 09:17:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/5] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
To: Tony Luck <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, Peter Newman
	<peternewman@google.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Dave Martin <Dave.Martin@arm.com>, "Babu
 Moger" <babu.moger@amd.com>, Fenghua Yu <fenghuay@nvidia.com>, Reinette
 Chatre <reinette.chatre@intel.com>, Drew Fustini <dfustini@baylibre.com>,
	"James Morse" <james.morse@arm.com>
References: <20260515193944.15114-1-tony.luck@intel.com>
 <20260515193944.15114-3-tony.luck@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <20260515193944.15114-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TP0P295CA0022.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::18) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|CH3PR11MB7940:EE_
X-MS-Office365-Filtering-Correlation-Id: 2fa97730-32e5-40fd-cbd3-08deb47b3bb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|4143699003|11063799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 2PIS3cCCCPBX81lrp+AF3QUCNJk/1+ojyJ5yNQP4q8CkZojhR807n42kY3OZjNlfnXJd4P9+4pkXck/uQinylKMKGLy4+M1jdWkLx7bIJHLjd4GAYuTB7QTInRD9E4VwxE2ZgXkTdrm64hCrBidWOdzPrS/qsFz7QkwR6ifEdb7SG3tg8crg+25euEY8G0sqZTCAUGx1CygF074wJftOGeR/aHizRSojnavRWAy6z+vpmknVc58eH4DPI/buLs5OsRgO+XwCBMV5XvOohX+cYMeX4x1A8ah8p12+e2tIWT6JwuHTO3YJa7VfYpXnan1IXgM4ykbps3ASeGeYKWDVXlJijaXsFrpCZbjecVo7mikY4TRiO65gxgClbTu/zKpD/MgEipxd+7eLrDoqwpd5/4bKWbBXvNZrdoZDDz8+/PR7i/+gocCeSWSNMjf2b1u7pclVGipqYseDeYImgWJw3AOpJKMz8lbDupD2Tf3xJPlXJol5d+qfWIGRGF5fZiOJeJGnr5N400ShmoiG1GKoT5uStyQ1tNRopHONmBWtkYx+i2IRFHgLno3dikawaWM4avrW43qNDwZRv9VQdYKZ2J2ObH+BwdIvuK+JYRyBmFT0BZ7jgd4kOkdo/Y3J+f1Lby7ADaWPBQk2JQH64uDJ/KAs8XUkrg9YX3QR00BXJR4KpuS1S09pXNqpx3fsjpFx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(4143699003)(11063799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VUx1UGFMckxBalNIOCtjZmtvUXdtWDh5V0NaVVdaR3RPeWdBZ2pmVERtQ3Zj?=
 =?utf-8?B?VWRodlBZSCs4bmptdTErZVFYTTNuLzE3Y1NDQjJSVUErWHd5eStPT09FVllp?=
 =?utf-8?B?WVVuQnZaYzNXTTdYN1lvWFEvdTd1MTFPT0NzWU5Dc28yZ0V1N0VJcmVzeml4?=
 =?utf-8?B?Y0VWVGJhV1dXMEFVK3N3a24wUjczN29wc3NmWUl2RldxbUE2eEtyWlJMcE1p?=
 =?utf-8?B?eitKcDZjUWp5aFZISDZ2VHY0NytILzZyOTNmQWN2NXRLTU5mNVJBSE0wem0r?=
 =?utf-8?B?QlFjd3ZPNXA4OEdEYUxHbHNVVXFQRW5XMGtCaVZscFVDRExJbmJXb2FMOUpE?=
 =?utf-8?B?Y2VzVm1tOVQrKzZPbDVtQ0dPN3dSR1BuWHJmZTN3eGNQNno1bGdhRktGZllr?=
 =?utf-8?B?SndqeEpJb2dJdTY0NjBjd0xlRGoxNGhFTjRnbFRseHBSZEVRS2g2ZVpDU01k?=
 =?utf-8?B?THdCaHRvcXh1WnJ1dWRqeUo2NURaSnFsN0pUaWdJN1dsVVhZV0pZaFUzQ0JY?=
 =?utf-8?B?K0phZEI0TE1RK2RNNDhaS25hOWRNR3JWeWJUNUVCVlVvbHN0bXh0cXdpWm9D?=
 =?utf-8?B?YXZnVXo4UzhCK01UK2dVVDlncTMwMVo1Q3pyV0J0QytBVmFwa05NT3F2VWV0?=
 =?utf-8?B?V3BHNkp1SVBnVk1mT2FJUU1MTi82ZDdKaGovTkt1eFVzeDZvbjRjWWp1KzMv?=
 =?utf-8?B?MUMrRDRNVDVrN3NJcUhvUDRRZnZyak5zelZwU21aV0MvRjJQQTVCRVM1cWJQ?=
 =?utf-8?B?REZpeDNTNTRmYzRrTDF4cWRVdEJVZlZHQXNjQldPNDFtRGNHaFpGMFE4KzFZ?=
 =?utf-8?B?cGRyT0NJVU1sR1FXeVlTajFJK0ozMm56Zy9WcGpBR1FpQlRTODFWQm1GM29Y?=
 =?utf-8?B?RTZ1VmFIbG5mZGpwMndKUWk2aG1Wdi91U1VvTVZHQmpTN1c5N1U1cUFnOEI3?=
 =?utf-8?B?UmNtMlZVaGtNNDBobkphM01uZnF1RlFiN1QrdWs1M0JYK2F3ckdJZWowM1pO?=
 =?utf-8?B?R0xyRUxTbG1uZTlsallXcWRjMklwbG9UWDdDOTB0NFplY1BreW1pWm9VM0tW?=
 =?utf-8?B?bFNWWmhlMStWL1BVN1dMT1QyUWY3NmRCUzR5SFRvdXo3YlZqdnRIdmZ4Mk9t?=
 =?utf-8?B?ei9oUFVrT0d4NHNsS0o5bHd4L0U3MWVSQUszRzFyUEJlUXBxck1aalJreGlV?=
 =?utf-8?B?S2NKSlRxNXF1V1FLMTdsd3MzZG00T1FRSmhqaG5aUUpkenlUZHBwY3JmNTcr?=
 =?utf-8?B?Z3BoZ3pldU0yZGVJWUlzRTRWZE82WGlHQ01TVzJ2ZEsvOUlaRk1PM3VzWmJN?=
 =?utf-8?B?SWlINk1oVkxzZnJZcWtqQU40NjhwUEtMaUpwcFE4eVRBYWNPVmUwZWs1UStC?=
 =?utf-8?B?WU9od1VJSTVXWndQa0xxMXc2Z01XOHhTMnBoT2draEMzZTRSTVR5bzhBaWxw?=
 =?utf-8?B?S3BKbjcwVmJQbElBbjV0OWNZZktqZStIc2xXOVZIaTVrZmJxckNmRWZiMytm?=
 =?utf-8?B?a2hOM3NFMXN4UWtlbkFpZE1rMjRaSjlMU2tsYzhwSmlpUzRzcE12ZW5GTG1Y?=
 =?utf-8?B?NHBZUG4vSHhXV295aVNTSTZReEU0dzhHUGFjM1A2MjlXVjEyVG5xK3owaXNN?=
 =?utf-8?B?MFgxZCt5bHhLVkdWZjBGUEUyd2pQbFptVjE5cHRBYzBSaHN1S0dOODE0M3lL?=
 =?utf-8?B?ZFhhL2dxMHc4R1VZV0kwTDMvVVNqMzAxeVY0WlJidnJCdzZzME5UeXdJRmRz?=
 =?utf-8?B?Q3ZsM2FWUXdDV1hYcEZPREY2Q1RuMjVZM1p3T0hyQ1J0Tmo3cmVIL1hxNllT?=
 =?utf-8?B?cVdHZnJLVGtiVVU4ZktsTlZVZVZoS0p5N1hVZ0lDWXp5YWozdlFmbUwvTURw?=
 =?utf-8?B?akVUb1hrMnFNUlhvWWkxemp3YzJLUlVBK1FXV1RRRTRsSlFRbm1PSS9jWDVz?=
 =?utf-8?B?K1F0bEZadXdjZkhaOTNQdG43d1FkNTlGWWhsYSsyeUZ1djVtako0NVhkNUV6?=
 =?utf-8?B?UnlxVGQrb2YxaXpwQTMzSWJyNHArWHNiK3lWZDJ4bmFrUXYzUWJGcGJENDFx?=
 =?utf-8?B?endGZnVvVFpJdmhEL2JmN1h1VUNad3hFbmwzTEdXcjFkdkYxblFJWEJ3ei9y?=
 =?utf-8?B?TG05T3ozSmt4WDF2ZDlUZUFRaEhuZTBEODNnVkxNSGFwZUd1TE5oZUxNVnow?=
 =?utf-8?B?MmhBeHJCa2xwZUV0TnNmVi90MnpieExXcFU3TWRYMGV5Q1VqTTlaWHp0VnVu?=
 =?utf-8?B?S1U2OE9ZM3lIT0dFMHZPNm1VRTdBMkNSTUdaeTJiek9WSzZhQXJFSGY4TnB4?=
 =?utf-8?B?N0lkSGpUNlVoMkFVaCthSUltQ1J3U0ZVMU11bnVFYWxXbTl5NTN3dz09?=
X-Exchange-RoutingPolicyChecked: YNFggAA9M3Ll6P8PG5hRluj9wMDsJ+2A9AL1kkmcnw4SECH34emP1RXAU3yYMbBJSCYQmCFfB9cGlUT6zD1RPBSyMABpD/88zCdoMqgDGyGk+ym3ZZiqoRp1qnJb9CSMB/GShsUz5wKvfl5FPG/4kQ95WF/aevVO+4omTnjU1ISos/J4t00WAPBO18cjw/vYbTDJoMODYWh2DXj9WfLNGck2lzKqH/DKxvIYZr19FSoANb+Oatp7UgInJ1lH947Q3jGwUiNI0/IGMBthJGQvcJhn0+FwRkkILgpCFPl9kDDZxiAbpJwmrzrGzkXmIRibPzkOAbHenojX5egnb4ruWw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fa97730-32e5-40fd-cbd3-08deb47b3bb1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2026 01:17:31.2057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcLT10R4nH2WwmmgjtwBUKA7NHyzV/TZHOO5trKB3cGyEz3e5gWrAVAV2Q3gxSDc00pao6n3Xe26Bc3S3xTY6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7940
X-OriginatorOrg: intel.com

On 5/16/2026 3:39 AM, Tony Luck wrote:
> If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
> fails, the mon_data structures allocated by mon_get_kn_priv() are
> leaked. Add mon_put_kn_priv() to the out_mondata error path to free
> them.
> 
> Fixes: 2a6566038544 ("x86/resctrl: Expand the width of domid by replacing mon_data_bits")
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Reviewed-by: Chen Yu <yu.c.chen@intel.com>

thanks,
Chenyu
