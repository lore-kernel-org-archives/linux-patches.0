Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5758820C329
	for <patches@lists.linux.dev>; Fri, 25 Oct 2024 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729877805; cv=fail; b=jH2OGtNbYPRkt6+3Pokb0z7tPtHUFtnJXf4U8s+S2diMsElZoxaECxAdH6VT+m6Ltv12RYyTMgsBhvBZlgTWPv7WM44qKe8o0Lumw8pxqxdJPJIWoIj5k0T1uJgKMRVgnEF2sdD3eJMDxg+Xu3ksjT7lGJYuAV9KFAe6zziEy6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729877805; c=relaxed/simple;
	bh=U39CPaN6/eZNVZT6/IrebVXModyV8B6vkaKCvMEkuIA=;
	h=Message-ID:Date:From:Subject:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YK0aWBIUv/8miXSm0C90QnsYztxtuogVtoYxXJJAqGQAySPBIlRr6VO2vVD/EAEMJ+9qA9Rt21xUW/6YEkHlnaHsLx8vu963GAR2Pfpg42KStiUs/P0UMugM3VGj6s1w16drKmOJzTRF9ynggcD89pFbJqz5I35AYQVoHmy0zUo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P4rt1ME/; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P4rt1ME/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729877803; x=1761413803;
  h=message-id:date:from:subject:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U39CPaN6/eZNVZT6/IrebVXModyV8B6vkaKCvMEkuIA=;
  b=P4rt1ME/R5z6VxV2V0V43yyvL8j4ztVXPq4rsbgyKz9jJAjyrjEIndDs
   kXAnUqTfqIrWKKGA2KOKKUDahDF4myGP4og98S8jq1j6A0zA4TA6oz/gU
   nMLJb5tFrH4+LI9DcOpuZx/82epbkYbi7B4FpPaE/Xtc8S9jXm9K44Hxf
   5M7IctADGMagXPJTqAkTq/F4DKVbEzItmDZUXnvgUE21WADUdfCyXEB/J
   akSojMg8uk9+1lW+n97GkoIpTipW0FCFEavyDewlOo6SN5ILx4TbdZO/j
   YR2yK6n+HH3lVBYSUzJPX/gy24ON0i6/LQiWhue5cdwxyjUVRUHXphE69
   A==;
X-CSE-ConnectionGUID: BkzCJP5RQ9q56pvSfhEaNQ==
X-CSE-MsgGUID: ng6s6WumSsCx3AKR835SlA==
X-IronPort-AV: E=McAfee;i="6700,10204,11236"; a="29664357"
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="29664357"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2024 10:36:43 -0700
X-CSE-ConnectionGUID: 3eW375wGSdu9kJjhRB0i9g==
X-CSE-MsgGUID: Vy2HnW8dQAGM4iYh5QbqNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,232,1725346800"; 
   d="scan'208";a="86082804"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Oct 2024 10:36:42 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 25 Oct 2024 10:36:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 25 Oct 2024 10:36:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 25 Oct 2024 10:36:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lc6NldCGCHKQ4OkPlAvWmknJNsoM7aFVCrveenNtBxnPd8dcdFl5T1y9s7YBmLXIDsWQg9NL9nMBlaRPOT95KbqQi2Bd2qPQXPTGj+juhJ5HIRHStAgO+n0PGpkbTAjLKzJujpuswGZssjgS2BJPPeEGCoi8YxY0rBH5JwlHX98O83OnmiYyFYPkrLhTBcucIDMXm96cPaoGJB2ivHA/HbsH3D7GH0qOKutpsM+mbxiVQM5P2GedMxnhe87/QGGyUEIZktYVt91d6mOy2+uIkFxNIWeTBDFCjHBgaqdjsV3Q47InC55l06VYrVRtvr/rBVW6yRlrsDJ5WUHBSGf/eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FzY5cT0SRVEQENVHeHY7dLvpr0z1ePi4LRBITC0jnI=;
 b=HW9oOA4VPw5rBCjhHFsWTCiVZCdii0CMxj9KamZaWDGSQ6MKb/I571RF0Bfoq31VFq+NAEx7wHFYi2v4ILGL3EMrvgfywGPHasMDvZTrqsz1JJYjET4M0guxW1BOyepP/aD2s3QfmQjonC2pGBvPfnWg5isoawFYvnW7SeTV2qA14gu7t81Uye+y4B3bHuylXhR//e7DqIk96SBvJQLc8yAhezwYfLUoGVK4mOSZRZbDUyrtj8J4BstOluYv7RY9AN6yl8UEUYwZI8YpLRH74uZpqdBHgEybiuBAL453IjqUIQZQRPDnq3Q5L3rsysMJ8f0z3yEaVt6GddVUwjMC4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.17; Fri, 25 Oct
 2024 17:36:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8093.021; Fri, 25 Oct 2024
 17:36:37 +0000
Message-ID: <bb30835f-5be9-44b4-8544-2f528e7fc573@intel.com>
Date: Fri, 25 Oct 2024 10:36:35 -0700
User-Agent: Mozilla Thunderbird
From: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH v7 1/4] x86/resctrl: Make input event for MBA Software
 Controller configurable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "Peter
 Newman" <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah
 Khan <skhan@linuxfoundation.org>, <x86@kernel.org>
CC: Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Babu Moger
	<babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20241003191228.67541-1-tony.luck@intel.com>
 <20241003191228.67541-2-tony.luck@intel.com>
Content-Language: en-US
In-Reply-To: <20241003191228.67541-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0230.namprd03.prod.outlook.com
 (2603:10b6:303:b9::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 61bda0a3-01b9-4c09-1c6d-08dcf51b93e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZmhVdUdDUVoyRGY0STQ5STNVTitLUUdGWUtoV2NZNnZnbCtacHFSK253bXFT?=
 =?utf-8?B?cjNaRFdNb2J4VkczZGF0aDNVbmpxVFd2cHNFaDJIRmVHb3pnVUk0dEx6M0Ru?=
 =?utf-8?B?NCtCVk1yNWFkMXU2T09Pc2kwcWJQUzJaRTNYTUdoQWQvUXIyQWtacU9qRnMz?=
 =?utf-8?B?M3hxeUJ2bG5nVEdFQktMYlhnczIwTnFYbHNqOVh4YUNXZ2dVeW1oY1FwVGpu?=
 =?utf-8?B?Z0dHY2FjWHZIWnA1RlMybmF0aktsN29rZUcxVEJYcjVPL1RvVjNQdUw1S1ZW?=
 =?utf-8?B?NzRVaE4xQ09pYjdTWW0vMVQ4QytYd05RZHlsUWp4SnQrUXJMZlc2RXlNRnRI?=
 =?utf-8?B?OUVMOU1QeU44SWdlMUFVWmh5MVVSQ0ZoamdxMS9ZWUxmaG0yN2UyZStXNHU4?=
 =?utf-8?B?Q2RodlNkdTMzQTNEQW1UR294Tk9KN05JMERRNkc0UUNubkVldmFtUWFyb0ln?=
 =?utf-8?B?MEtHWStJWUlJVnBaRERTbkJaMmtUY2d3NmJRcmRlZE05YTFPNHdyV1p1YWo1?=
 =?utf-8?B?RTdVWHFUQ3RwSUl2T0Q5alM5UkQxOUNsbVM1Q2RPamxQQ3VCbnhRSncvTGE0?=
 =?utf-8?B?NHFRd1dtb3lQU0xibUdoVndncXZPeXVjQlhickZPT29tTEVFbjh5UGNXcjd6?=
 =?utf-8?B?ZFVRVEVERnVyWndpa0NabzdPem1MZnRNUWozMTczbDcwSlYxVkQ3SXk5Z1BK?=
 =?utf-8?B?d1J0UkRRMXlNclBxOVpyRGErenp5QmRkajA0WnZYVFJXeXQ2S2cvaXQ1VE54?=
 =?utf-8?B?TFgrYzFJZTdTVnlNS0Z3NkU0VFBEQ3lNbDFEamtWbDJEY1JnM0RuR21kUnhB?=
 =?utf-8?B?R1NZdXNQZjVlbWFSc29jQ29SMnVMQUFwTjUva1J6RlVGWFBvMCtwTUw4WnRv?=
 =?utf-8?B?RDFOY3NNUDFFN2g2bENSQVlNOFVJQk40bUtQZWhnTkg5a2FFQ25yQU1XNGZ1?=
 =?utf-8?B?anZjK1NoTlpmSlNLQ0Rpb1BwR05neTd3c3cyRkJYNXJwNVMvcm5xeEZqZVlN?=
 =?utf-8?B?RURha00vVEluL29HOTQ5anM2SldXL21BVTA0TTNTTGRic09SSndHYkthMDBE?=
 =?utf-8?B?NWtQcmxpVDhmMmhTa1VzUGp6eXZ1VVdPRDk0SnRlaHdsc3hRbWVTT3FlZEoz?=
 =?utf-8?B?NW8rSSszQm1pKzZ1SEdCTUFzaE5RRnp6V1U2dU9ld3FPSzZyZ0JYQVhvYjJw?=
 =?utf-8?B?Q1N6SEo0WDdJaFVZWDZBTUhvVkhvQ3JBUzRNckhVU0hQbkVoZkZ2akZqdmxY?=
 =?utf-8?B?TE9DVUNYL3FYMlVnNzdhQ1o4VzZHSG0vTTZCdE9WY1lSWENOZ0xVMWJ5SDdZ?=
 =?utf-8?B?cGZrL1RHaUExcVpxclhvUTZaWUN4NmFiSEd2ZG5IK0hEN2pVUmJ2bmJxZzJF?=
 =?utf-8?B?YnJTdTgxUTFIZWtKTXdUWkN5b0VYMlBmc1ZzTmkrUE90SnB3V1Vib3V6NEY3?=
 =?utf-8?B?ZVRyNWFsOHQ3UENXRGJ3Mm5lUStUMTZFMThhQWo0RnZ5bVBlTlovSGJ0K29Z?=
 =?utf-8?B?QmNQdjliVzdPRHNOdVhReXlVZmM2bXVTcHBkSzhXNUMzR3dGUVZxRVNEQ21p?=
 =?utf-8?B?WWlRUjhPbjdoYWVnZml1MXAwN0R5WW5NTThld0prVHREeGIrcHlTRVlaa1Jy?=
 =?utf-8?B?YUN1d3NDbHBOMlRUcnoxNjNWY2gxcm4xeGJvc2YvYnpkTm5STGdYcDdzcDA3?=
 =?utf-8?B?Q0grZFY4Z3d5bWRrK281U0hUZDZVSVFHOHdodTFpdlk2ek45akZTc0YxdGRR?=
 =?utf-8?Q?Zvwq7LLzKHbULJlWW2D9kiLMF3GDh6CVgpyUk6M?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1RxYnpnUmdCVTRHL3pVNEhwRVlpTHhJTE1meWJJcTJxK2hiTU1TcWMxZk0w?=
 =?utf-8?B?SGlkd1VvTUU4VmYyYnVPSFYrSGg4clUxYkcvVFQ2S1VCWjN6Y3pMRlB2dTRE?=
 =?utf-8?B?c2xqcEtPNWNhRHpOcWNGNDdTdEUzbG1GOXhPZWRuTG9vSVBya1JWZlowYTNN?=
 =?utf-8?B?YkpzVmNITVliRWlrMGFjQk9vZUpweXRnWnJIbWJwVG9HNCsyQk1GVEk0ODdh?=
 =?utf-8?B?cENJWVcxM3V1elhrZHBjUUxYUHJ1UmxWUGxSbVBlUTRTcTRtVTQ4VEZNVk9M?=
 =?utf-8?B?WUVBd1BDVmVCNHBrS3JGNnBKQVVFQnNnc2FzTG5OWHQwVWxrZUdOQldxOGZI?=
 =?utf-8?B?eFVNSDFXV2RrbWpId0NQMEdPTURoUno2YTFZNVlGaUNySG1RWXBZQkVHenJ6?=
 =?utf-8?B?bWFub09aTUw3WWNtdGJwaWpUQStWUEg1amVyNnJ1djRWZjRoS1V2NWpUanJm?=
 =?utf-8?B?WGwreVB5VlFDVnFZS2hCK29sckVqZU1zdXlDWGlnN21DSVA1YWxxRnFqclNt?=
 =?utf-8?B?bkxaSjgzOWhkc01oODdnWW9QdnhoYktJeTZXNi8zUFV5Z1podmMxVldSZmto?=
 =?utf-8?B?WUExOWw3OStDWEw0UGljd2FlQUVpLzBrNVJ0VEFMN0t6WDVOaG4xTHdHbVJ5?=
 =?utf-8?B?aUhwenBGQ0FHS3lZMHJVVkpaTzlsL2pkZUlPdG9QUEJ5eExKWWZLUzBuanZD?=
 =?utf-8?B?TVpkT3A1VkZZSXpPVnowSmg0cnNrZGswaVhKN0tkSXlBU3VNK3BrN2Z0RzZG?=
 =?utf-8?B?WDhZSmtJdFFuMkZQdVJ0NHlYWDVUbElLa0ttNDFpbHVvSThaOXZEVlZwVkJx?=
 =?utf-8?B?Yy82VCtDOUtqRTZhOC83cDVZV2J0ZEVPYkFvVktPek96amNJai93S1IvVXIw?=
 =?utf-8?B?bTJPVldVQUl4QnZzOE1sSmh3dWFVQXhVNTZiNnRkeXNTd1ppaTB3ajVQbVdj?=
 =?utf-8?B?ZlZmdG90VjlCeTNWZFdhRW92WW9QZUZnaVJWemllMTJlTy82V2tUdU5UVlEy?=
 =?utf-8?B?MXUrcDhTbURQdzNRZnR5UVdnak1mSXZiemFRYmp3anROTkQxQ1hkMXJTY1d1?=
 =?utf-8?B?b0p2NjBsWFg3cktIOXVyTGU5R09PeFA5U3RlbVdoSlFtaVhEUWJ2VjRaek9Q?=
 =?utf-8?B?NVhiaWw5V1VFUUFnY2dqWHd3eEk5TG5adHc4V0VVNjFVays1MHVZWWoyL2Jz?=
 =?utf-8?B?UjA2cmFEMGFyT2JRN0RMUmxJdWVyaDR3Z2U4NU83QzB4SXZIWEN2NHZreVF0?=
 =?utf-8?B?N0tkaVlqMllVUEVPMWRqc1RxQ1k5eUtreXEzcFl0SDY0ODZsK09iUXJFeEpB?=
 =?utf-8?B?blExVGplZ1Vyc3A3ekI4a0FYSTJYTTR4K1Z3cWl4T1hRTlJFdndJWDZ6QzlI?=
 =?utf-8?B?Y2g1MHZ4YVB3eHBIWE0rWTlCSzFvZ2paclRFSUdqbmRWNEpBVFVUUElETXZw?=
 =?utf-8?B?anNHdVpacUxYRDBseEc5R2hwTnl2eVdxMWU1SENsUUJjeVBnWDI0eU41Wm1X?=
 =?utf-8?B?Q3pPMXdsaEx2VnhuUWNpYXdQdUJRVURla3c2RkpVZkE4bzVmZEZZeGNCL1VQ?=
 =?utf-8?B?cTRjVHNFdG4zYkxzZzV0ajFXQ2V2M3hobWh1WFBuYWJCRVhkNFhmS28zY3E1?=
 =?utf-8?B?L3B0V05OZ3dFcHZPVDE1aUd2Tk9HWU5ZVGVpVlRyQzkvK0lLcW9VWFE2Q2lG?=
 =?utf-8?B?RHVxOGtaa0pjSmRnKzlJWHBZandIRTRkTVU0S0hnZnRLcnI3eWx1QkhkM001?=
 =?utf-8?B?TWs5SUZBdFpmM2k4eWdxalltTlZnc282amZ2UmJlSXVHQis3WWFXK1BTNHhF?=
 =?utf-8?B?YVlSNlg1Ui9PSEI2cVJOeTlUeGhxd0FrM1Q4eVdNcThNY1Z6SjgrRGI5WGFY?=
 =?utf-8?B?bzRrckt6d2d6MG5kazZZZ241QnNtOVIvWmxmcHQ1ZjZoUG11V0dZNWpZY0Vo?=
 =?utf-8?B?c1k5YmlqNkwrQTJ3TzRpb2ZSSFhXa2RFR0pWL1A0dmRESTk2VXJCODhaR3pV?=
 =?utf-8?B?MTFDZFNlNjhaNW42R2hmY1dVcUxDTDljVnVmak9TdlNMSENqLyt2RHk0SGtU?=
 =?utf-8?B?Q2Vhamk1bTcrdUV2S0pSNCs5YllpQ3NKK3J4Z1dFNGMvbFVCYXlPdlV4dm5N?=
 =?utf-8?B?b3I4Z0FESDhKSytWcGZIYXlUYVRHV2ZjQ2tSbVZ4bHRwa1ViNjdmYWxyd2dR?=
 =?utf-8?B?Z1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61bda0a3-01b9-4c09-1c6d-08dcf51b93e0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 17:36:37.4927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MElaywfoXdYOLOoqLSEMiTKDrerczhkAvyDPUlkQsuWM/2ppI45E2IEFWNL0hv67wYp0GvAsHyoXlPuKIseZCQJ2cKG8VX1r8OSIviBI4Ac=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com

Hi Tony,

On 10/3/24 12:12 PM, Tony Luck wrote:
> The MBA Software Controller(mba_sc) is a feedback loop that uses
> measurements of local memory bandwidth to adjust MBA throttling levels
> to keep workloads in a resctrl group within a target bandwidth set in
> the schemata file.
> 
> Users may want to use total memory bandwidth instead of local to handle
> workloads that have poor NUMA localization.
> 
> Update the once-per-second polling code to pick a chosen event (local
> or total memory bandwidth).
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                |  2 +
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 80 ++++++++++++--------------
>  arch/x86/kernel/cpu/resctrl/rdtgroup.c |  2 +
>  3 files changed, 40 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d94abba1c716..ccb0f50dc18c 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -161,6 +161,7 @@ enum membw_throttle_mode {
>   * @throttle_mode:	Bandwidth throttling mode when threads request
>   *			different memory bandwidths
>   * @mba_sc:		True if MBA software controller(mba_sc) is enabled
> + * @mba_mbps_event:	Monitoring event guiding feedback loop when @mba_sc is true
>   * @mb_map:		Mapping of memory B/W percentage to memory B/W delay
>   */
>  struct resctrl_membw {
> @@ -170,6 +171,7 @@ struct resctrl_membw {
>  	bool				arch_needs_linear;
>  	enum membw_throttle_mode	throttle_mode;
>  	bool				mba_sc;
> +	enum resctrl_event_id		mba_mbps_event;
>  	u32				*mb_map;
>  };

I do still [1] think that mba_sc_event will be easier to understand to be a companion
of mba_sc .

>  
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 851b561850e0..2692ce7f708e 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -663,10 +663,11 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   */
>  static void mbm_bw_count(u32 closid, u32 rmid, struct rmid_read *rr)
>  {
> -	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> -	struct mbm_state *m = &rr->d->mbm_local[idx];
>  	u64 cur_bw, bytes, cur_bytes;
> +	struct mbm_state *m;
>  
> +	m = get_mbm_state(rr->d, closid, rmid, rr->evtid);
> +	WARN_ON(!m);

In the unlikely case this WARN() is hit then this function should exit before attempting
to dereference this NULL pointer a few lines down.

>  	cur_bytes = rr->val;
>  	bytes = cur_bytes - m->prev_bw_bytes;
>  	m->prev_bw_bytes = cur_bytes;

I needed to refresh my understanding of this work by re-reading the previous discussions.
You mentioned in [2]:
	I tried out some code to make the event runtime selectable via a r/w file in the
	resctrl/info directories. But that got complicated because of the amount of state
	that needs to be updated when switching events.

Could you please clarify which state you referred to? I wonder if it may be the 
struct mbm_state state maintained by mbm_bw_count()? mbm_bw_count() is lightweight
and I see no problem with it being called for all supported MBM events when
the software controller is enabled. With state for all supported events always available
it seems simpler to runtime switch between which events guide the software controller?

Thinking about it more, it seems possible for the user to use different
MBM events to guide the software controller for different resource groups.

If it is possible to do runtime switching in this way I do think it will simplify this
implementation while not requiring the user to remount resctrl to make changes. You
mentioned [3] that "a separate patch series" may be coming to address this but doing this
now seems simpler while avoiding any future work as well as confusing duplicate ABI
... unless you were referring to other issues that needs to be addressed separately?

> @@ -752,20 +753,22 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	u32 closid, rmid, cur_msr_val, new_msr_val;
>  	struct mbm_state *pmbm_data, *cmbm_data;
>  	struct rdt_ctrl_domain *dom_mba;
> +	enum resctrl_event_id evt_id;
>  	struct rdt_resource *r_mba;
> -	u32 cur_bw, user_bw, idx;
>  	struct list_head *head;
>  	struct rdtgroup *entry;
> +	u32 cur_bw, user_bw;
>  
> -	if (!is_mbm_local_enabled())
> +	if (!is_mbm_enabled())
>  		return;
>  
>  	r_mba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
> +	evt_id = r_mba->membw.mba_mbps_event;

I see no check that evt_id is actually supported by the system. The new "is_mbm_enabled()"
check a few lines up tests if _any_ MBM event is supported, which may
differ from the event hardcoded without checking in rdt_enable_ctx() below.


>  	closid = rgrp->closid;
>  	rmid = rgrp->mon.rmid;
> -	idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> -	pmbm_data = &dom_mbm->mbm_local[idx];
> +	pmbm_data = get_mbm_state(dom_mbm, closid, rmid, evt_id);
> +	WARN_ON(!pmbm_data);

same comment about WARN ... also, since these calls are made frequently it may be
better to use WARN_ON_ONCE()

>  
>  	dom_mba = get_ctrl_domain_from_cpu(smp_processor_id(), r_mba);
>  	if (!dom_mba) {
> @@ -784,7 +787,8 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	 */
>  	head = &rgrp->mon.crdtgrp_list;
>  	list_for_each_entry(entry, head, mon.crdtgrp_list) {
> -		cmbm_data = &dom_mbm->mbm_local[entry->mon.rmid];
> +		cmbm_data = get_mbm_state(dom_mbm, entry->closid, entry->mon.rmid, evt_id);
> +		WARN_ON(!cmbm_data);

Same here.

>  		cur_bw += cmbm_data->prev_bw;
>  	}
>  
> @@ -813,54 +817,42 @@ static void update_mba_bw(struct rdtgroup *rgrp, struct rdt_mon_domain *dom_mbm)
>  	resctrl_arch_update_one(r_mba, dom_mba, closid, CDP_NONE, new_msr_val);
>  }
>  
> -static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
> -		       u32 closid, u32 rmid)
> +static void mbm_update_one_event(struct rdt_resource *r, struct rdt_mon_domain *d,
> +				 u32 closid, u32 rmid, enum resctrl_event_id evtid)
>  {
> +	struct rdt_resource *rmba = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>  	struct rmid_read rr = {0};
>  
>  	rr.r = r;
>  	rr.d = d;
> +	rr.evtid = evtid;
> +	rr.arch_mon_ctx = resctrl_arch_mon_ctx_alloc(rr.r, rr.evtid);
> +	if (IS_ERR(rr.arch_mon_ctx)) {
> +		pr_warn_ratelimited("Failed to allocate monitor context: %ld",
> +				    PTR_ERR(rr.arch_mon_ctx));
> +		return;
> +	}
>  
> +	__mon_event_count(closid, rmid, &rr);
> +
> +	if (is_mba_sc(NULL) && rr.evtid == rmba->membw.mba_mbps_event)
> +		mbm_bw_count(closid, rmid, &rr);

This is where I was thinking it could be simplified to instead always update all state:
	if (is_mba_sc(NULL))
		mbm_bw_count(closid, rmid, &rr);


> +
> +	resctrl_arch_mon_ctx_free(rr.r, rr.evtid, rr.arch_mon_ctx);
> +}
> +

...

> @@ -2520,6 +2521,7 @@ static int rdt_enable_ctx(struct rdt_fs_context *ctx)
>  	}
>  
>  	if (ctx->enable_mba_mbps) {
> +		r->membw.mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;

By dropping the earlier "if (!is_mbm_local_enabled())" check there remains no
check that local MBM is supported while hardcoding its use here.

>  		ret = set_mba_sc(true);
>  		if (ret)
>  			goto out_cdpl3;

Reinette

[1] https://lore.kernel.org/all/5215fe1e-52e1-4ca4-8bd2-a42152f3e0e3@intel.com/
[2] https://lore.kernel.org/all/20231128231439.81691-1-tony.luck@intel.com/
[3] https://lore.kernel.org/all/ZWpF5m4mIeZdK8kv@agluck-desk3/
