Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210033BF68F
	for <patches@lists.linux.dev>; Fri,  4 Sep 2026 15:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788537074; cv=fail; b=pB1aPfhyBSgCCYxO9ZhocJo/dm6t7ciuWoUE/E8cQzn8QgKfhAg6flHmHiSRdizo6TVP8l1eBLCYIbdf5NHREwYUpPDPRO+XF7y0PJw8YT2/xJBxsQOuMM//awmye2l+l5sV9f8T0kSIlDUb4zpafoB1kK1Q+aVA4SAPaGdDvV0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788537074; c=relaxed/simple;
	bh=xesNzRtwT3duJ1l5RdN6RS0EuPfQ8Ht7Rz0nGvuQGd4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O8H4T9q/SZUBWLvtTAypPI2d23+zbi2gJisN9j0LPcxL++qiOAOpLFbvSHyAk1bdnxj23GzvV71Vh0NfhqPqw3NBvb/8u7Hf5u/x6fSdCanh0O3Y1TrGIMR/Ii+IsUNsGXIhoxXZHcNcZegOOa1lddIwOc7cNHHECK55s7T+zh4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hpTXTSXe; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hpTXTSXe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788537070; x=1820073070;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xesNzRtwT3duJ1l5RdN6RS0EuPfQ8Ht7Rz0nGvuQGd4=;
  b=hpTXTSXeFNqA7sGJFnuyaxs5AtPo/wRdPRFZrIKw4PZpBPF2msdKV/D4
   r2pFxd4HgvyhM32U/GVpK7ButZLGwiOhR8P6bMCgpHjw61OGeI78mc89O
   bX/gHRR37H6oHUUzWxYwSjgSuuM8SZR7oZwz/gpFAJIUTZRV3mD4j2ObY
   Ora9V7dWhjmTtiBszEbB1xpJ0iWepcOpO0Juns3Na/rxomqV9ad06TcxI
   Z+1CXD/2NpypuCFfdK5GsuNjdMRKfbhNMuLlK+ZKLTevJZBAfW5gjC/Qf
   k/oIdq0YIDWJIwSZRMwOhyKOCOxaqb9MRfijb6iNuEX8QUpAFB1kJSWfV
   A==;
X-CSE-ConnectionGUID: 7uZvviZHQ8yGl1bx0E6+1Q==
X-CSE-MsgGUID: liFRjO01S1uZsXqCxGCm/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88806585"
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="88806585"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 08:51:08 -0700
X-CSE-ConnectionGUID: K6FpTHH2RluA87o/a031OQ==
X-CSE-MsgGUID: U2KEo3yqToytC2x6/EToTg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,262,1779174000"; 
   d="scan'208";a="308280659"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2026 08:51:08 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 4 Sep 2026 08:51:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Fri, 4 Sep 2026 08:51:07 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.59) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Fri, 4 Sep 2026 08:51:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uJWN0m73Ojs4Y8NskzLXl28UjLMBDWZGHYr08jZUNOe0D/cB3ssMiylZ/S4kOMC5NEfgtVJN9dGgDwm+7BMOtl1LxqALFqtL65Ka6GUXu4mWHPLWElLYUAOH9fo2QOWVCgCkg/Gf4PdfFYwiVqPM9RYTHobVWJNBd5JLgajb6Q08mYn8p1tYG3c1Emtcj1ieFmSiv3brg5IBwUfVkondDCx+GqW1S5CX0yGyP9sxm2D728nsV+ywW1GjaLsw021+gc1BwiMkp2J/hwMRY6G1ihXwOfefvKnFSA1GhamNFKjE7EBDcBicyV9VuNJocUluz0WoIdLj5VjOyvLTlfYvag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l4VYaEWx1y2eR79pUjjljZkaOMJTMhMOwi1Zun2JQkw=;
 b=jDRS7z0/aR3E1nw4PMi1Ws2YWhObtUoCcdBKgH1w1gVhc1Q+xtKXlz8V4lpumNOfMJ9Pbd5k47xlWq/NBcfikghGiFMetAqTNcKlCSeB5nQIO2wlJIAK8ClwNF81iZfLOUvby7gR2xhZb+8InWXyU99JpMDyyrQifRLVpNF8IltkN07iuuvANcjFM4kfRMLlHQ2D2wwYn6jnO3V5xEdG5nWnkFGJwqkeKl2lIEDROQWHpyuD7K0i/l7sP4HE9Vw8NHE1dAJHNq5NpOB9mgW4BKuNcEvQFQt1L4Ji/5VmAiTpuhCoflTs8JR3DiNs+anWDtbx523okXSDaOS7+zC95Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH8PR11MB9855.namprd11.prod.outlook.com (2603:10b6:510:3c4::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Fri, 4 Sep
 2026 15:51:06 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0360.008; Fri, 4 Sep 2026
 15:51:06 +0000
Message-ID: <ca4646c4-6ef9-4ef6-96fa-372ec0875506@intel.com>
Date: Fri, 4 Sep 2026 08:51:03 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] fs/resctrl: Drop unnecessary is_mba_linear() helper
To: Chen Yu <yu.c.chen@intel.com>
CC: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
 <b615f948cab09677813ae54e316e10ca96acccf3.1788452481.git.reinette.chatre@intel.com>
 <appLOliNv9E6-Ou6@fengwei-dev>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <appLOliNv9E6-Ou6@fengwei-dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0016.namprd02.prod.outlook.com
 (2603:10b6:303:16d::22) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH8PR11MB9855:EE_
X-MS-Office365-Filtering-Correlation-Id: ad9415cf-a5e9-475e-a832-08df0a9c5464
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|4143699003|11063799006|10067099003|22082099003|18002099003|56012099006;
X-Microsoft-Antispam-Message-Info: Nj3TY+vYTc/HdIw0QVWC6HwsrppnFQ0QiLyPDQvZK9lMpj5e41kQqZMazEM2pibeYWtqOflPlKFMRNYWyHht3RGq4CHTpnF98zC2O2kYM5Ehja6gUsSlX4znHI9goyzp3aDxt+r1SkNNRqys18v5o+Bugzj4AYVPYL5AewIMkGtcRgcB7rdKzG3CTDPgnlFAEvKskhPUufmoMWaFaQvMcM333qqpmrwYOKqd1rkm5EweAM6Ycb++6TY+9NNjy6r/HI7jKuBeLLhna4hQSMSG7osEcANU8qjFjtY/+hDmIeWB1/dWgJuhr7P68sFxyz7nyOUDcH4i9WNVqKBkPgP3bofOTyupr9hGBAinb1edShrbgHz9qULm8HVWlGgk58Zcv5478pMHySbWShc2SLcGq1RJAka0i4p1Zcy9uTHbjh8iUtCq3BdjZO/o+4X6nCU91zV9oX4N30Dw0iIaunt5oAMznfA08E3Wx8S62vbnEqlCeckLqcnh+vwcT8y0RKDT38Ws3JuNTHmXpDq8s9MdarLymqwIkWMKihckB7va6Rzkr4t4iuUJd3LFCxNK9dy1OY/H5KfUXcjVq+k5yN3FLJcUQOypuqiEEuq9B9uaah9bAQTODcZKiM4QSabNE8+Zpw7xPmr0z3jz5OH6NpksMdXm2gkFre6pBiKv9V0d2lA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZXpPcnllTkR3d1p4STEwUzVZbGVZcXFrVzBBc3dTTUJKS1JzQXNwNnlwc1FP?=
 =?utf-8?B?WmI1V3JIeEx1clo2bHBPVTRocHVkWmx6d2p6bUlKS0NDcFdCSEVJRVAraDBi?=
 =?utf-8?B?WUkrSGM4QnZNR0c0NzBrQ1pwQTQwaU9WaGZ3T0xDdGJJQzIvVVJZRVl5MzJ2?=
 =?utf-8?B?MnJUdzBmcVZ6eFpQYks2TVV2RzNmbERONmJwOHFyVkFhNTUxSnc5dXhhNFBj?=
 =?utf-8?B?OHBOU0tFTm12cnJmQ1E1aXZFYnBZRUIxYU1QK1JNemoxZTVyaGNJN0pPWnhs?=
 =?utf-8?B?R25kdmNpQllFbG9aM3NUYWNLcXRjbXR4TGtvbUowSlJ4MEgyWGpXQUxJbmM1?=
 =?utf-8?B?YVduaTlDblJQQjQ1R1BRVWVzNlRZOThONW0vVTArUzVuZ3dXRmJ2NEpEblYr?=
 =?utf-8?B?WTdSSzlNMFYrd1A0bjBhY0psRXlVdlVmckVsNGpDQ2VIcm8wUGttb1UvaUVq?=
 =?utf-8?B?UURMaC8wMmd4ZlBOb2QvMDF4Ry92eU4yTmV6WmFxU3JKZEpKRDJ6YzFaWDhS?=
 =?utf-8?B?aFVmcENLSy9tMjB6dGtKMk9EQTJzQlNjOW4vUnNENE5TckRxRy9WcmJRQnNN?=
 =?utf-8?B?UkNyc0p1NThVWnY1SkFja0tZbGJQY1I1bkMzR3VHSHg3eUFKQ1NEVTRaY1hX?=
 =?utf-8?B?SjBibm1oNlozZkMrNk8rU0JEd3ZQeTRpUDl2TU5sbFRRMjFyZmJwR1gxZkta?=
 =?utf-8?B?c0NvYkdPYmo4U3c0VHFodkpEVm4yQkI1OCttVVZzdjdKbm9Od09NWS9yQjM2?=
 =?utf-8?B?U29Gb1RPTEpQOFdtR0w5Qklna1BzZjA2Mm9vZ3ovWFVxb3VyM3FqRUNpSFVP?=
 =?utf-8?B?cUVnYWszN01YRzhMQkhWOUhPY3ZmL2tDV2paYkg1SldFTlZkTFNjMGlxYmRh?=
 =?utf-8?B?ZVdjdWFmZnNlb1JnZ25BaDlTVXBxT2hDYXhFanJ5azYweXd1bnFSZUJraGxi?=
 =?utf-8?B?RGlveEtmVnd6ZWdTRDQxdUhoMHhpOHhRSFlYU05wUDhSS1JwMUprZjF6OWlT?=
 =?utf-8?B?WFM2dnV6MElnUkVCWGZlQ0Q4RkF1bHRxcHE3SVg1Wm1lSjBCWTdJeGllK2RW?=
 =?utf-8?B?T2w4dnVqeXVJR1J0Q1RieEdVWGtubGxVRzlBY0lUTXA0N1JpdWEwb25VU3h5?=
 =?utf-8?B?YVZIY2UxMXc0enRyZVQySGwwVjNVL2VTaGZTQnBPZFNnTVpoL29YdEE1ajZS?=
 =?utf-8?B?azJUcTNzYW11SnRnMS8zZXAvK1BjME4rbjJ3dWgzRk1NNnpDQ242c1FseWh5?=
 =?utf-8?B?VDBzYU9nUzc2UkFpY1pCUWt5UWxrYm1BZ0wyRDZLMW5zNTB5OVMrTnhRTTVC?=
 =?utf-8?B?cVpNb2JkdVBzd2dXckE0T1B5ajlSSEl1MncyaXZHZFpRbS9HaDlRU0dlaEdP?=
 =?utf-8?B?MUM5T0tscHZCTFpEVzRrczkzODgvUm9lc2dCeTh6RFVOSmxmMGhCT3REdTQ5?=
 =?utf-8?B?cFk2N0JDekk3c255Z0hOSnhUeHd1Rmoyc0Z2Q3IyNnBLcStIY1VaQ0FtWTh3?=
 =?utf-8?B?QmlkUDZzUGk1NG9XSVhiZ0lRWHo4dFkrZWNaamN2ZlBGM3NrZ2ROTjJWemtr?=
 =?utf-8?B?TlBDY2MvMHBGRkxIRE1zdGtvSjkxRDU4TFgzVEhHU1BkSGRTYkpIdGpaY3ZQ?=
 =?utf-8?B?OFFYbVpRYWN3NWNPUjJNdCt3ZmNTR2d0UFhHajAxbGxLSGVPT245aDRMSWs4?=
 =?utf-8?B?QzB6MDJqVWloQ1h5YXJkVVZhOWVrcWdVKzNOTkx5YTVYOFYzcllKOXRVb0VS?=
 =?utf-8?B?Q1NIZ1lzYS9JVjVxd0ZZQTN6TlBqSjZ5MXNUTWp2TmdJU1ZUc09sK3czZDR0?=
 =?utf-8?B?SHhoanVMaHhwbVM0eEtOQVNjSkFRajYvNlRWU2RJek9HWkJFVkgyWlBzZVR0?=
 =?utf-8?B?b2k0SDJlemVaZ3RBNXc0c2ZESFUrTTNEQjI4WlNDOHJCNDI4cHNCSUE4MzlZ?=
 =?utf-8?B?QW1UeVZoK1lERlRHOWQ1ZGk0cFd0N0hXc09hbjVnNE12dG5SVXdUVmFJVmo4?=
 =?utf-8?B?TDdqeElGbGlJaHRuank0NjM1dmhCT0xpRjV0RTl4dlFtaDJRSXVCYjh3cHQ3?=
 =?utf-8?B?a2IxSjJ0MzdwVTM5K1BnUDZsTlJNbXVjZDllRjRIdm1ZakJrRkd5ZlhxTkZ6?=
 =?utf-8?B?eDZWT0JoWTJwRGZ0amh5OERjY0t6aFJMS003RmdnOEg0bFhobHl4bTNwK3pX?=
 =?utf-8?B?YlVGdktNeEVKb25OWmtrV1JlYXVLZkEzRlFqcUtNclhxUkVYek1ac1ZsMEtW?=
 =?utf-8?B?MkJzUU9iZ3dlUlpmZ3RQYXdSZER5cjFFR3pNeS9LSjAxbi9lN0lobTRTdExD?=
 =?utf-8?B?eWZXZHgrUCt2WkRkQ3dQZTUvclNsdCs2WHdYL3NCYThmd1pqQmtpeXppeTZp?=
 =?utf-8?Q?7hOxwfgDXUjQrDWw=3D?=
X-Exchange-RoutingPolicyChecked: dEABZZ2u6DEAk9A9HBQnZA8Rxe66IcF1nhYPeDewgispa/STux/ikanqhY37TydDV6mVVqq09KuUeH/8rLwXQG1uySf/G0SiO+tdHNAJ4Cwe0KV9PGdpLMeJUjrqLoqi3IFee0V7jmo/IMPqwLvCA1cgeLdjMJR884ao6YGjTrDkvqZ1R5RBAAdGC2Hmrf9K5Ok+cZKVY0vkYR82uW8YfoK+EtT492DUU+sR6EysY2sH6GyJYdNlSgVeCNAO8C/G9WAEAZjUp1vERUbrUVv3+sY2fVIbH+M17WCw5KQ54sKp/JJeJian7EF71yqRUihokxaqEXVje6oCmyDBhGKbLA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ad9415cf-a5e9-475e-a832-08df0a9c5464
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2026 15:51:05.9127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3tPBciXneZpENJU306HpVXfFmP5iks1BZIbit5cqU7pWIF2FO6z+If/gHNPDed4oJw6BD4gSo3YforgsZPPxdYxRmLvDvnAJmlwURx0A0TE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB9855
X-OriginatorOrg: intel.com

Hi Chenyu,

On 9/3/26 9:38 PM, Chen Yu wrote:
> On Thu, Sep 03, 2026 at 09:57:06AM -0700, Reinette Chatre wrote:
>> is_mba_linear() assumes it operates on the MBA resource and returns whether
>> the resource is linear. There is only one caller that separately makes the
>> same assumption.
>>
>> Avoid duplicating the resource assumptions and let the only caller access
>> the needed property directly.
>>
>> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
>> ---
> 
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>
> 

Thank you very much.

Reinette
