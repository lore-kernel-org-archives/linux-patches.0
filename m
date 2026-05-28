Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81C1D3F39F1
	for <patches@lists.linux.dev>; Thu, 28 May 2026 16:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984564; cv=fail; b=IXiYyEgYdf0wl4eJhG6M3imPN43rX0zKyd7wmOGf9Wanl6Yr8eBUOvNYM0oDVOgdKX0XMeX+7Pw6M8ZTQSEGYBDN2NC16QKvUEuYTrBqy+8B16uU+945Oh0Bof8J2kzcNOwGT/REFtFzTrapAP8kBfTBKvFhfEjblbwgUYro8VY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984564; c=relaxed/simple;
	bh=utTKZI9jOqMU7nJnzexN+eA+tVLkVuP84wk0nuc+vnI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tGu2txoN+mJj40YEAi7fiz/52G6jgxUCei0PlNEdoAh+U00Kaq5GGRpze8/Uyd+TosF21RK8cqD9SsQ1KlEao2wjumfnAioFyUfyt9os2JOUcRQ7Wc8D6Jc3FTvzVKeJfmGf4yl+/Ny1sIZhzTWR9votwK97wnd9WN1lih7jboo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GkVWSHW1; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GkVWSHW1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779984563; x=1811520563;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=utTKZI9jOqMU7nJnzexN+eA+tVLkVuP84wk0nuc+vnI=;
  b=GkVWSHW1Q9QtAcMz4N3sgYS7CbfTDjNDuFl9Px8BSMBr1673NqT/JYrc
   aKbcB77ekElDnw4sbmE85pEc+9I6tO2RDAXF1J6rbVjmpC+AZXvG/jbgp
   pnQXn+7CmJ8Qr/kKOlA9cand/lpA/lOUbRrHAXY8KUA0yK3vHLg81aasm
   /DIWnybwZr82akU17TnpTyuJscoxofmxRi10rt7rjJY48Ib2TNzFhDG93
   IsKbA9I3rMXY66QnM6NKsWbmr66sCTmTkdqqFl+ArI73b89AXLjJuFtMw
   VZ0f9yHY5V6sMMYJLdx+j344a3UcUUGsOcpfXFGvolb2OHpsL3Aixljsu
   A==;
X-CSE-ConnectionGUID: kZ+vKOynQtSmxC7r316iHA==
X-CSE-MsgGUID: FIQHs3O9QkK/u5jOfdjOEQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="103505544"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="103505544"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:09:23 -0700
X-CSE-ConnectionGUID: RP2IbgWoSyy1ZMUW2s7rHw==
X-CSE-MsgGUID: WqIQbs6xQMqc4S/Gu6ba7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="236236665"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:09:23 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:09:22 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 09:09:22 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.52) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:09:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eAFlO7Fuvn4GK/2G7Wf342su4izspECU4sNF6p3ITkFgMWPr6cLYqiubB5dHsDeEqJpwN0AEfBwl4TCfoN072QLsEkR0QBlfGGTbCqwH/jCDpJ7BtuilT/htDGo5RTayGu30dN4SwqAzDtNaMENvNq60M0zJu+Geh5HAAAklzDP20gGBFGK9LIVuC/IV9/s0Y2m+Izl3ucDeQzsXLyd6IzqfGhgt2FmQ4oAfGxPtEqnAsdT++h8XeoDPHrsAFNNgquIT1D0QJobIiiXSAKrgqL+UK16s/32Q7pzkY4hFy7x9eQyi3uHm3nW78jiA7DJm4OpAHs6iJa+q7RB1eioRng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z5BID+bYU5y4W5p0IybfzlX8hEqn5MyGyo0rcL/MkBE=;
 b=Aiik0r9gRmc+JMyUcwMe6fsPZJYQjPfZsxpObBkSMGwr51apf4pxjELE8oBuy+lvLTVpDaOdhZbJUMstC1hENwoGcrCYK3vtzSOwFQ1Z6wj2nD2Qm/4wsJdBSjrfyGYUfKtuWTv15GZlXfWsZyB8cTKcXtBoTXCe4xlH2GJ83bPT1Apuc6udL6OkXbOw1qrH1oBDiXgrngkqgVEa1EIjggOnE/ccXBO99rshTZcUW3bmbBPRsTz38tMLS/i48WF1KaOWdo04UXsJgwJYNyHI2VdC1sV0pugo8WYvBjLExP4W4m4kwwlf3J0EetO3cI4geiVMOJMYZOEIDVNq3CDjtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB5969.namprd11.prod.outlook.com (2603:10b6:8:5c::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.71.13; Thu, 28 May 2026 16:09:17 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 16:09:13 +0000
Message-ID: <e1904d28-1996-48f8-a838-471ce499c580@intel.com>
Date: Thu, 28 May 2026 09:09:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/9] fs/resctrl: Fix use-after-free during unmount
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <0a48bc36304da0fce4525672cca5f41c3d8ae678.1779476724.git.reinette.chatre@intel.com>
 <9db153ad-972c-4e48-95a2-50e3fccf453e@arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <9db153ad-972c-4e48-95a2-50e3fccf453e@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0385.namprd04.prod.outlook.com
 (2603:10b6:303:81::30) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB5969:EE_
X-MS-Office365-Filtering-Correlation-Id: 87e70ac0-8f72-48c8-c255-08debcd3756b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|56012099006|4143699003|11063799006|22082099003|18002099003|6133799003;
X-Microsoft-Antispam-Message-Info: 1Q8x6gQ8A/LhNb0hHKDnMQrHd8Vx8mN3avA9ogvh/NwR/9vqM5BgsMIk322AWyYDRBkWg4npKGvOjNDSydG5TnRC6ZIeV/AsoY372Pei+byIRDXkrl6ed7ohPk3VoVDAPk5udN1EByk/1G0y1Mfcqpy/6VDTrFjDYYDqU/ogz3I4zXlEbWppfNnhwCs7dXYW0NOnYIH4rA/JdrvrF/rx9MRJcOMm5fL7MFATevvucJzbI+2t7WddDvh1Kwt6ftgehAlmzSCJ5BtN4x6nwxf0cVYY6y5kQg74ODLil8j/2dS5Nt9+pKrQfR21EOD8FDDx/PwYnQiBXfAXjESAbq4xRm2AHG5VL0a+YHLrh4Nbo9UoiV2zXtwQAmcijw2fr7QNkpYwFB3arooDr2xB6SautCUeaLkuY4zj8wMa4CRri7ZhqNCadwVSbyAMf9tF7J4EHP/h1Sjgtyz/naqMKozpKwRqm3pIfdrp0qNtWaCT0uwSbJ3LMztVX4SYB9eI5ZVF4ihG9hqEeyPoOd/K5uQZN0GxJrLYBDX2puFZgyRaB36u1vgPAF2mMKkHw3jMcC0xQ3zGX94ezcuOoETTcAVYDXWBC9uLtMWzG1nd/xzr1ghhDD5Yau5aljWMJg8sY15V6JRaI2ncwY74AxTfhMrUCsqofCfAHcGjBV+zLoniO/xIyeH0+++Ro3meaHpB0RU2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmwyZTZ0YVRpV3dDZmg0d1JsTFIxWm1RTUhOM0FSbk5BZkJlb2tzYkJ2ZjNH?=
 =?utf-8?B?N0s2MlpuWFF0amQwNGdpTkFsWUhYendxWmgrdzNEOTBxWjZtczRaTUtSN1RB?=
 =?utf-8?B?OFpVVWFOdDBYSDBlcjJTODVIOUMvK3lyMlhnY1BRb21WT0pVTnlXMW5WQzE2?=
 =?utf-8?B?RE5YV0dRRnF6RzU1YmxLaFZBak8ydUFDS0dmempYRlNRaEpQSWlSYjYzV3FT?=
 =?utf-8?B?MGlIL1RLdXdDUkxjd0RDMWdEZG5NK2JOUnFtSVYwU1pYRWN3cmFYVFFGZGFJ?=
 =?utf-8?B?bXJUeGhyQTZBUktTYTgvaHltMHZUSlFFMGpJMDdYeEJndnVxT01lWmJrZWxC?=
 =?utf-8?B?WTlkUXJ0RFlzbHdOYkNEN3dZZzU2UlE3TVZHcFpuVUszb0pMYzVnbEFHcTA1?=
 =?utf-8?B?ekVSS21XUEFPeFUxUk4yZjVBdGlqYk85WkFOdC9QczdsN2RMWnhRWFJqY1hC?=
 =?utf-8?B?akxPNHI0MXV6M0RwNVVWWFl5cTBGNWsvbkZHdjFkeW1uUnBBbDBYQkJMSllX?=
 =?utf-8?B?K3A3WGFjODRIRXdhZ2EybHMxem0rQXIzMys5L0Vwd2N6c0lWNmRiQjB1VnFl?=
 =?utf-8?B?bGdUanJsWmxaSlZJQ1BIY0NRNjZyMGt3S0h4TzZKK2RnaXdzeTZPeHFxU2w1?=
 =?utf-8?B?R242ajJaRms5cFZFUUgwWmV2VGgySGRJN0FZUkdhakRkSkdwQ1ZndTJTeGNR?=
 =?utf-8?B?M1pHSW4vRmVSeU56VURqOUc2blJwNEZ5Rk9EdkVDcFZIZ3Z0SVNYaEVreTEx?=
 =?utf-8?B?c0RHSmM4cTB6cUpFTk1TZ2ZrQjNKd2F6MjBPV204SStiRW5TdTNNK1JUOHQw?=
 =?utf-8?B?ZVBjOVhtZTBUMEVzMFp2T21NdmVOSVlybXdGQ0l6VlhqQldQazdMUjh2U3p2?=
 =?utf-8?B?d25GL3dUejF0dnZlYUZORVV5eTJaa3N4MTZHcjc3V3BTdzM3d2MrVzhiYm9a?=
 =?utf-8?B?Ymk2eWl4Y25yWk93OCtocUpYd2NHTkVBMVUwYXFHQmtEYkNOV2N4V0ludktR?=
 =?utf-8?B?NzhXR0Ixem43cGZWVVpoOXRqeXNNamR3V1FERWhnVmlwL1o1eksxcjZkcTZ2?=
 =?utf-8?B?clUyMUU0RmZNaFVFem02bXhNNkpEWDNqY2tDbXBDRUprYy91SldYY3BYeVRv?=
 =?utf-8?B?czZ3eks3QWVKU1Y5cWNuekl5MjdiakFabUkzUkloMGZ2RWZONXJuTUQvdUhV?=
 =?utf-8?B?bFJudE9CMTRUTm1vY2RrQVRBY2lmbHlSTnJuWG5EYzVxNDlFcWZCejk4cVdi?=
 =?utf-8?B?TEg4Q3lOQnpyMm1UWHd6VE5SQmNaNUgyNExXSlJHTE1IS2RTbHpWaE9yYWdx?=
 =?utf-8?B?QTZrdGR0RkRYRkFPT3RrUHVxMCsySTB4TnU1UTVQMVg1MnZIU0J0ZVFrR1Vi?=
 =?utf-8?B?QXRuSDhHVnh5dkpoTXc1dlZoVWlia0dvdjlIZHVnL0JXOHhiMWc5aWFBUjlZ?=
 =?utf-8?B?czhGZWtQQkRWelgvVU9RcnpZaU41c0NEblVpN0V5RnlPVnB0ejg5R3pGcEJQ?=
 =?utf-8?B?Smx3WDd6amRqVHIycFptQzd1cTdLVEsxUFkwWXF0SCtMQmgwcmhSRDE5U3JZ?=
 =?utf-8?B?N2l0NUlXVm01Q3ZoU3BqNXpiK1E3cndXd204TXF1NlhBcXJQSy9BUEFBWC82?=
 =?utf-8?B?RUZHMDBrYkVZaU1nQzM3cG1oOC9BZTJOVnY4bXZ3eVBOaU45RmJ1OXBtUjc3?=
 =?utf-8?B?WXVWTjRvKzRRekJ1ZXFFR0lDY003dlV3TGFMSUZPMm9BSVp3OXc3QjcxalZK?=
 =?utf-8?B?RU9aZVZ6d2hoSzJlRGN6OWpRLzQ1Snc5Y2wyc2tsWS9QU0IvZlY2b05abkp0?=
 =?utf-8?B?UjUzVk4yQisrSDlUTFFZSmZXTGtlZVFXcEZvTlFraE1GNUZGdjdtbXpmYjBz?=
 =?utf-8?B?VDgyQ3lBai9zMC96ZVpaai9KemRHSFdwaHFMWWw3ZGN2UjJ3K2w5Z3NFaTho?=
 =?utf-8?B?NXlmdHc2a2ZlVVBkc0JwZXNkTHdqYnM0RGlrVEtydFJZcklpTEdmanNlaTE5?=
 =?utf-8?B?UDI2N1dSc3ZUY0kxT3grVnk2Y0owVkpXQ0dCeStjWWpHV1BLdWtaWHNhaU5u?=
 =?utf-8?B?NW9tMTAyYytLZjcrRXpFRG1yQ0E2Wk9JREJLc2xYRXk5SmVEQXpCNzRCMkFr?=
 =?utf-8?B?bDJqZlZrVTFQRmhjZ3h2ZzA2cXU3VjFtTXBIWWtFbnRUSk9oUnFMMUg1cmVJ?=
 =?utf-8?B?ZWh3TDRkdGNlL3BBZmZzU3JscTdtQUl5c0N6Y3VqSVBnMDFZRkpibWRnYWxv?=
 =?utf-8?B?OHlyc2pIaTBvcmdEbHovRG5TUC96Wno3dTVSTU8rNThyaTA4clA3UzVhYVdT?=
 =?utf-8?B?NkdSWXN2YmNiTGIyQldrTEdjbTdpK096d2VKSU15MjdhQTJyZWJ1L2ppbFBQ?=
 =?utf-8?Q?qd5rucdyYfQbM6s4=3D?=
X-Exchange-RoutingPolicyChecked: WhbcIIw0IJk1s4bZAhNP7WONE12DsEQ/D4c0sWsmlqCVyvrxKIfUgKmovCx9U2YY0V2wvr5hLQvgeYVUEroJ+4DAAkC+Ce8wcB0nVW5tTZpU0cS7SY78W1CxQL5NIfzaIYaR1yCAvo5aIxsfh3ZBkZP38ZHWxka5cYunh7mgNHgTvGfBmEWzeRmkeNm7yO2gykYpMAou+I/keSG/PZ3YXZSXzRi+SA4H7C1Q3Ik+pyEUhRTqkQOnwLAGpFyesz7HKmE8ZUs72SBSjQICNY+18KA7+CJelEQB1qq2/sBs10CMJ1QiiheHSRtgMnHiJT9O9VYEg/oa+tP9BwMMhzA+IA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e70ac0-8f72-48c8-c255-08debcd3756b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 16:09:13.3107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ff4vizQc26qVRJS9KELh4DqfLU+CuI25fS7yJynWudfLyVLCqzUDAGX6TgrGgeqxa8N43l0XPUGwYY6LM2wAWjBk7tFUGsqXS7o6xHK2A+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5969
X-OriginatorOrg: intel.com

Hi Ben,

On 5/28/26 2:45 AM, Ben Horgan wrote:
> On 5/22/26 20:15, Reinette Chatre wrote:
..

>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>> index f573db9e6e84..8a1457825919 100644
>> --- a/fs/resctrl/rdtgroup.c
>> +++ b/fs/resctrl/rdtgroup.c
>> @@ -585,14 +585,20 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
>>   *
>>   * On resource group creation via a mkdir, an extra kernfs_node reference is
>>   * taken to ensure that the rdtgroup structure remains accessible for the
>> - * rdtgroup_kn_unlock() calls where it is removed.
>> + * rdtgroup_kn_unlock() calls where it is removed. The default group is
>> + * statically allocated: it does not have an extra reference but will have
>> + * RDT_DELETED set on unmount to support safe access to its associated files
>> + * via rdtgroup_kn_lock_live/rdtgroup_kn_unlock().
>>   *
>> - * Drop the extra reference here, then free the rdtgroup structure.
>> + * For all but the default group: drop the extra reference, then free the
>> + * rdtgroup structure.
>>   *
>>   * Return: void
>>   */
>>  static void rdtgroup_remove(struct rdtgroup *rdtgrp)
>>  {
>> +	if (rdtgrp == &rdtgroup_default)
>> +		return;
>>  	kernfs_put(rdtgrp->kn);
>>  	kfree(rdtgrp);
>>  }
>> @@ -2975,6 +2981,7 @@ static void resctrl_fs_teardown(void)
>>  	mon_put_kn_priv();
>>  	rdt_pseudo_lock_release();
>>  	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
>> +	rdtgroup_default.flags = RDT_DELETED;
> 
> Would it be better to use |= here?
> I expect it's not functionally different but I'm unsure of the interaction with
> RDT_DELETED_PLR and it seems best in general unless clearing other possible
> flags is intended.

Thank you very much for taking a look and for the other tags.

I see this initialization as assigning a "reset" value that reflects the
cleanup done by resctrl_fs_teardown() as opposed to recording/adding another state
during runtime.
If resctrl does add RDT_DELETED_PLR then there is no interaction to be
concerned about here since pseudo-locking is not supported on the default
group. You can confirm this by considering the first "if (rdtgrp == &rdtgroup_default)"
check within fs/resctrl/pseudo_lock.c:rdtgroup_locksetup_enter().

Since there is only one flag, RDT_DELETED, possible for the default group
you are correct that using |= is not functionally different but my preference
would be to use assignment in this spot just to make it clear that this is
a reset value.

Reinette



