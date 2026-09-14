Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F78377567
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 22:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789423441; cv=fail; b=RqM8nf8Op087wwQOEP0LdgxouWEKJ7mYizIhXy3GrAM30ve/rQ2kFT3ZIr8nNl4BK83kWInX2h9CeZK4ZLepQjj7QNYiE0Gd6XK4ZgwnAGYcTeCpCL0xtyLK668hL4aXWXG8HNlB8+l25s5WrbFxlWeKEEzT7AzAC3sQeLue7qE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789423441; c=relaxed/simple;
	bh=TgHIAyDUJz2bTHqfveMrMQiRGF6TAoNnKd+PZadwKuI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ALIRQSKCV3fD5RPgawQGUGyDvWDbT2wcDbyyVsiQjgmJl887J3tGjGrlnOEmdTi1IHFNUpohlIpJ9JOVBnE50eLhLdXLfGIaa/02xqtXvdMGsCpIlKZjLlXG5+7jic7IeMQ7X/yzs8QXzG31vf3S+JNGZg1npmV0ICBQBf4MF2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F/yCn1NM; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F/yCn1NM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789423440; x=1820959440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TgHIAyDUJz2bTHqfveMrMQiRGF6TAoNnKd+PZadwKuI=;
  b=F/yCn1NMAQAzqT5ulBFT/WnZmDW4qyFUvpyIb3wYOEoXC+AeE2t0eNl0
   pAU/r+X2u5DYJ4E02MFq0ekv0tVnt4GoD4rqGfQ94c+jwKj+yn1m6vF/c
   s+XbWxXkiCMIuuga0J624BMetDEg0eQfer/9UqiryqDGyLsyCrp9IMi1c
   VsKDrrmTzhM2GrIPpN+B/Fy2Gokhoob6a77jKzP+YnUyB9cBTF68g0+Ow
   KTYqAL34M8pIHP7Td9zLQvEUeG5vP18DruDkC4hKdlTkiGDbJGF5DJ68S
   UWDA65DofYUBIgska8CDQhtIvFJ/h/xPedm7KSGNh2iM4z3U4YdQvy8Vr
   Q==;
X-CSE-ConnectionGUID: aD3QBYacT+SFqkzpC6BC4w==
X-CSE-MsgGUID: GJgOTCpXTsCvVvmnuHhX/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="100445497"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="100445497"
Received: from fmviesa011.fm.intel.com ([10.60.135.151])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 15:03:59 -0700
X-CSE-ConnectionGUID: bNcub7V3RmqwIAGvTbzgHg==
X-CSE-MsgGUID: +jObM2plR+ekSDJlgS92Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="972378"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa011.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2026 15:03:59 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 15:03:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Mon, 14 Sep 2026 15:03:58 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.57) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 14 Sep 2026 15:03:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EoTdTv74JfFHtZgiffxKxLd+lIaXIUZGMmN228Yo/a0HtfRj0WgrfR0Ipgdi0dlw7xqRAXxsgAVTOUqJhPB9TQ1gDvuOGsaAk9e43XlgO6SJlWaRKV7YtNdwDLXmyM00lOBL6TXQtSJZIWHiBhKwEYdrZoaQ50UiSYeK/m/enMnacz3v+/jK1jZcL52zeHyLhBHWq3bHMDp9EeHwEtMhjBEESDmd9LwX6PpdKxCjU9mTTSNHOW1tYu+tAVGKav+itb/GRZJ2FY4aIkGyYXVs+3v8OL+IDFMXQ6vcS4376iRH/uBjFcjOWmvVo6KUqCsw10m/j5Y4dIxtkIInrFavkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vqsvc/baI3oEdBhP3mogEDN1E7lmoKz4UXKFJidSLJw=;
 b=m9jPVzIO915MZRc/NuSfdBUcICO3pwFAud6kKjglUPyUy2xJeVSNZKtm3qPTUvSBrT/KXQ6XspCY/28Qu4s7MUe4ZnOecUNhM0B5vNCH5Iuuw4/L0GpqFf8LKL4p/4Vm0v9ghcPtzvygB18yAct8wvoI8qD7fYIVchebdr4j8iZEcbtxY8pnPaitKfXxINR/vjYu0G59Zthbz5qW6GMWw8XC+ec4l+zOc6jWSb7dbj6ULnC443VpLfblGIA7dXMxO/fvEJ48FdpNFCAAvbPnJ3FoCSWcyXYkIpx+h7mHXZW2K+WCDyxS+rwTB6J29RHChkygupVghaW6dZx/hb0SMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL3PR11MB6433.namprd11.prod.outlook.com (2603:10b6:208:3b9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Mon, 14 Sep
 2026 22:03:48 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.007; Mon, 14 Sep 2026
 22:03:48 +0000
Message-ID: <99a4db07-d142-483f-9544-969c7ef9f258@intel.com>
Date: Mon, 14 Sep 2026 15:03:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/23] x86/resctrl: Enforce system RMID limit on AET
 event groups
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-15-tony.luck@intel.com>
 <4cfe5c3e-c061-474b-9c47-483b87eecbcc@intel.com>
 <aqhoMhn4rsl-HWmb@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aqhoMhn4rsl-HWmb@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0276.namprd03.prod.outlook.com
 (2603:10b6:303:b5::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL3PR11MB6433:EE_
X-MS-Office365-Filtering-Correlation-Id: d72239f5-b2b4-4ef8-1a42-08df12ac0d4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|10067099003|4143699003|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: Y+IUC/nhdQZHBKJOtKGHqqZNUFvAZzxCmhZCuJH+06mrjzkf/zRVbgs7UtsRCQ+br5hMeuVNNWF9uf12M45/YlZDYQ2LERR+l+sQh6/vrkqKRYsqchYluP4Vpt+L+Dk2FGCh36wkPAepwfo3mceTQF3zlnOLJo5u9QxsZl21T9vePwCTxpS+14h97k/+RcjlzQjRR/+EQRuQxBserBwjukW0yjRZ9t6p/J9BODg7zr22GbXQBdx4lOKyxR/rqpRIocSE4NyNADzOQ4n5IJydgRrjOd8NUzmAdaOD17kUqnTBY0yHHkMYWu9UWWJTLBUlGN2N9a3BCR9CZlQgM/8wYDEEjz3kAWsXraUToo856PK3maeweeUwNOCIRCVrDkClhjjqweHWB3rO5DLeEMt4kAm/gmPjRNXNBKqSI2J+bdplb+kn3ySkYPBJ+elDFFPdWyHCYSK5q+2DwUH2+CAzfpCrXPkRGUN6b5VXrlMSWqp6FU+xGN2ExW9g93zdyj5RdVGj6W7FQ9Vo97lWHXOssYOuCwmZQmfxzNRHEY+tMDVe7oJY6SFh+mcRxFOfVjXIWbiuDbxnBbxZtRk461KznCD69/OghO+Y6eJI85XcMQg01B4x3okAvATAGsieGk+0gOwFrHcUcO9YPgc763m8IDqQl21VDa8DMN1xvW8H+tA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(4143699003)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c2Q3Y0ZUOHhkeFpVUGVaS0Yra1BETHpvRVc3bWhUQVZDekQ3Ri85N3l2dTNu?=
 =?utf-8?B?cWVXL1JRakp3enBKZS85bS9NdlRURkpiNkpmcVhmVWN3cnBqMk5ud1p1MXpI?=
 =?utf-8?B?cTFVU3hNeER5dzRyNTlqTUNGYzVFZ1hlS2dwQ1ovWW5hWkR1SmhTYy9BaGVW?=
 =?utf-8?B?SGRDSkRMRjJGdWVBZUQ5bTVQZER4UmdPS2VuVkJDcUhZdEYrd1k5VzBHeXho?=
 =?utf-8?B?UWI1RlRhendkbVBmRko1K3FzU0FPQW93Ym1nWjFPLzNmejFFSUJQWnZJYkRP?=
 =?utf-8?B?TlBzM3JUenVJWXlqMlpCZ2R2dnFER0ptUExpQkVXeXp6SVR0Y3BIL2U0clNx?=
 =?utf-8?B?S1Y4NHdINW0rdXV2WkdxYTBiYkxBVUtwTXNOMThleWMzUnQ3d2I0L2ZaOHZ0?=
 =?utf-8?B?cmZzSGJSWXAyMUFDdTdZTUFtVm5HU2lyN2Z1TVpBRDB1NjVjdnpTZ1REblc4?=
 =?utf-8?B?Ykc0SlNwbHZzcE40eE13LzlKbkY4cXlyc2szdUVOR3NPVHNWeEZjVkxFNVd0?=
 =?utf-8?B?Ukk2ZXc2OWNZZG5IYkxzVlh6U3A3SE9OMW5naEpkRmxLUXd6TEpGSll3SDBU?=
 =?utf-8?B?N1Z2UlcySGlHMG9vczl0VXlTandyTFo5OUtYZUFzYnFnODBkczgzcmFjR1M5?=
 =?utf-8?B?ZlBBajI4QkZQaDJEYmlMbzhGSllZMmxSUHVDcFVNbGR6M3ZrK284N1E5TnA0?=
 =?utf-8?B?RnJRdHlTeE5YRldLeEZUSVE4OG15dEtVaVFqL2pVSUEwc090UXIwRy9oLzlT?=
 =?utf-8?B?aURnTkRLbG9JY0NaQlB4c0NZVEpvS1NuVkV0NXZ1U0M2NkZJZm5TazVsNnZl?=
 =?utf-8?B?aUhqNDdZRVBqSmI2endHTVZFbVZiZThpdkNsVTlvbEk0SWh1TEw5MjY0NnBZ?=
 =?utf-8?B?cjhwNmgrTU9HaWF4dlg2SG50b3M3UHhONkNwOER1cStWQ1pseWdRNXdjMjh3?=
 =?utf-8?B?blJJZTFvZ3Q4R2QzMzVQY3ExcjVveDJSM2cwWkYwNWM4VFFTdENPQWpKZTVr?=
 =?utf-8?B?MjRqdGQzbC9vV1RsZ3hBZFRXTkNScDd4UmNLdEpaV3N3WTJnZ3ViR0t0aWFl?=
 =?utf-8?B?bjdtUklUNlZydmdzRFY3Yjcwa0VwSUVWazlENW40alBLYTljZ3p1Tk0zQXNo?=
 =?utf-8?B?em9wWk1zTEN0R051L3Zzc2h3Y2VEVXZXdTJtakQ2c3FTTWZienUzVVNXRE5F?=
 =?utf-8?B?dU43bUdhanpmOWxBT0haN1pjTlBUR0JtN21JQWplTzBoMGF0SGF5aFZXOXY2?=
 =?utf-8?B?bjJoUnFYTW9jQm1PeHArbnBySVpEaWxSV21RT3Z3ZGtiKzk4cVNMbVRzTTZK?=
 =?utf-8?B?OEFibEV3NlJkWjR2SGVScDE5amp2S0dkeHplOUh5MGJFeUhtQjg2VzRuYVhF?=
 =?utf-8?B?eDhWc29LZ0FUcWhDdVZ0aGpYN3VTOE8rMDNKak5jOU95YVVKWTZsQW1tcFZ3?=
 =?utf-8?B?c3RSSmh4dnRUcGRrYXVMVTlxOUhKcUI4SVFIbXFva0JZQnFwV3JaRUMwZ2Z6?=
 =?utf-8?B?eHlxaGhyVVZlbjdMeWphNCtaNnVrdkpiNUxpUWt4dXBOaG5hYy9mdnozd2Zm?=
 =?utf-8?B?RmxHZHRxTEhLZWJGUWVtaW9LVlpjekdob3BrVitCNHpPSFFtYUE3Z200bWlG?=
 =?utf-8?B?YlhOd2lLcE9kb0tMb016UVR5anRLNXVHQUlCWVh4ZjRLWk1kNUs2QWQ0eWNJ?=
 =?utf-8?B?U3U4QnJpdHJXTjArV01OT09JS1p6cm9pNnFUWU9wdXgxcUFRdjBrTWNnNTQ2?=
 =?utf-8?B?M2NEVHkrb0ZHRFdyNE1tT2grbklqano0VURPakFNTENUOE5CNlkzdEE3aCtR?=
 =?utf-8?B?dGdJU0xDcWRwR2h0bUVjNU1MNnNrc1hnTEhlVmJORzhENE5LVGhnZ1pXdkdX?=
 =?utf-8?B?VmxOTGNTWHRkNHYrN0RtOS9tenRZcm1EV0oyemhZcThsdmJwclJOYVlrV3NG?=
 =?utf-8?B?UzU5UTliZEtPZzVXZ1lVR1VLb08vbW4vL2RTaXJ0aDFwdU1nb0xodThrUEJ6?=
 =?utf-8?B?ZzZkMFlEVjhNODF3RWIyTDlzTEExTW1oVjJNL3ozeVRvbmYvckx5a0dtNC9Q?=
 =?utf-8?B?VFZEdlNtR0swQk1uUE9abVRWNTVoaG9rdDJtTFpjK2grQmRONWxUVWUwSHBw?=
 =?utf-8?B?eFk5YmFacVNtRFBaRTZOeXE0cUJIT2VreTRmTEg4eHk3aUdOaWR6MXR4Rk12?=
 =?utf-8?B?ZHpLbEM2Ui9RdjRyNDM4Q0ZqVlA0T2Fab09IdXNyeWJIeXJiSFY5eUlWbmww?=
 =?utf-8?B?YzdoUXVTUE1seEE1SldJSVQ4MnFRVVN4eXdQWWIrU1FoWXJvWkEzR2plZTY0?=
 =?utf-8?B?d2p0ZVlFYmFIVkNINmMzKzJmWjlNdERMd1pDVTR0L0JsdUdNdkU1bEJOUnpy?=
 =?utf-8?Q?IVsH7nuAa1UgfURA=3D?=
X-Exchange-RoutingPolicyChecked: NHPzY3qzCGQdEAo/MuxPQGmVlTnmwoWOUiuRESU60yDPM6i1ZOaO55SsH5sgQ3arqqSlIWL/tkswHc+E2bWSqtcYZCW/nWTf3BOCvnx3K4hjg0UsDYCYiLiCJVVpLuLPU73TDZzEftvYR1/nop4GbjXICM2+9dUDt5ORaYkWPPJBfX83RS5gVfC71oo7o0Zer5YgWExoS6dPqT4dtGh2ByxseEuDEKQxBnrtzFLniwFJlc4GUYPXrPxB4ZYQeruAmjLx43w2Zwu4H4zhJW8BdrW2+C7kT96qjx7CyNr6yjZlhaKjLvphoifx48vVFousJ06eYW1CZCaq1tnkEBkVDg==
X-MS-Exchange-CrossTenant-Network-Message-Id: d72239f5-b2b4-4ef8-1a42-08df12ac0d4e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2026 22:03:47.8686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qxFWRzAa4hkPLQJmCOCS6xd0seXe1WDHxDrSu0pX+q6HAYpsd9nSpNUzQcQlLyWebGiTJ7x8OWWhIS3VUOjon91RdhBeN7fllxLWGtVM1OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6433
X-OriginatorOrg: intel.com

Hi Tony,

On 9/14/26 2:33 PM, Luck, Tony wrote:
> On Wed, Sep 09, 2026 at 09:05:28PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 8/31/26 10:44 AM, Tony Luck wrote:
>>> AET (Application Energy Telemetry) event groups each support a specific
>>> number of RMIDs. But that number may be lower than the number supported
>>> by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
>>> enabled as that reduces the number of supported RMIDs.
>>>
>>> Reduce all event_group::num_rmid to system maximum.
>>
>> Why is this needed? Doesn't resctrl_arch_system_num_rmid_idx() ensure the
>> minimum is taken across all resources? I do not see why a resource needs to
>> artificially reduce the number of RMIDs it supports.
> 
> rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl.mon.num_rmid is used
> to display the value in /sys/fs/resctrl/info/PERF_PKG_MON/num_rmids.
> 
> It would cause confusion if a number > (CPUID(0xF,0x0).EBX + 1) appeared
> there.

That is fair, but on top of this this patch additionally reduces the number
of RMIDs of RDT_RESOURCE_PERF_PKG based on the number of RMID that RDT_RESOURCE_L3
supports.

Documentation has already been updated to contain:
	The upper bound for how many "CTRL_MON" + "MON" can be created
	is the smaller of the L3_MON and PERF_PKG_MON "num_rmids" values.

I do not see a reason for PERF_PKG_MON to pretend to support the same
number of RMIDs as L3. This unnecessarily hides information from user space.
A user may only be interested in PERF_PKG_MON and then see that mkdir of
monitoring directories fail before it reaches the supported num_rmids.
User interface will show that this is because of L3 and then user space will
know how many monitoring groups can be supported if/when L3 monitoring is
disabled. By pretending that both resources support the same number of
RMIDs this is not possible.

Reinette

