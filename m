Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E946B346FAA
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774978789; cv=fail; b=dOK4UaCpuqksoSw59I6P4KRIlUJNea0RddYuWrBEWb0MWbdT02sUZfCP77S2wIh5MTx0mOw9QVdFmwOOJNNlvqtB+p4P/4xgps0HEVSbGLX8dWo97SjDmYgHicik+wMCpvTPnXIB2jzzQCdzr6QjhxcLdYk2KhlEH8byoUXMUPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774978789; c=relaxed/simple;
	bh=wo3FdPTGuGBuScEDe6CyvUCo6kYH9sfPpEsZEkHwFLQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iBLLHvJcOyIWGAXNvNskdMJsJSaDH31PxwGLrdEoq9LVQ7VYDm7SLdB9SNEKljgLuv5VVZ2/dwuUekYqA7dNfsOonofc1NAX9gjv7qHhI5veibsscwEXPjBIaHj8LKs0tX9ACV99MviMv7ny9gIAvprfyDK849PO9Nl8fe8/MPg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BmxMsYkX; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BmxMsYkX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774978788; x=1806514788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wo3FdPTGuGBuScEDe6CyvUCo6kYH9sfPpEsZEkHwFLQ=;
  b=BmxMsYkXkZeSjmrYvOiKnYEWIC/TJDB4BPeuf+gUF8hUSRNTXYdBOODo
   2/4vkCS7Vug2LnImbwEb4uCqJAXUpZU0za1fX+DIjdjpixVj2dQwnjbad
   LdVUlkQ4hyjMgw6WxUtCF74Fkejua0OSkwzz2GimoVdFs6wzmR4D1fX/K
   nnsEA9rAIEOmoigSKtbCoPc54hKpZkTYjN8efYGbBYQJdovLXyuHEY0Cf
   uBHcA57Cuv+kjafL99J1k9gYafSPenbkEohimhTMw7t+AYjjdJAsXlvkE
   JG27OJwjZK2Q9jN6TzmIk54h+LFoaa0SKnNzlYoo3qnrLQtKEI1WGvhSe
   w==;
X-CSE-ConnectionGUID: 1L3viFIATg+jggRjvIXYLg==
X-CSE-MsgGUID: wYWCDCZ+Q+6+1D/Rh6PKLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11745"; a="76116436"
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="76116436"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:39:47 -0700
X-CSE-ConnectionGUID: k+xEUv2rRViB3K6BXhzXow==
X-CSE-MsgGUID: bb+sv9CFTSyDGCM4JY6D8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,152,1770624000"; 
   d="scan'208";a="264365224"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2026 10:39:46 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:39:45 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 31 Mar 2026 10:39:45 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.36)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 31 Mar 2026 10:39:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZM5w/zcHBi+fRUkE7WbRSF6DnpcJnU+nPTpNX6MTAvbPL6htWNgnW71TLuOSt2R07thM+CoGI38VBmlz9eIumY5cL+2GpKWP04aEAyOq4ml00O+fAR5YjmJ8cRL9uUBPRBnPEjseVgEnYFumPYNNQsMj9oKVL8KOHjeh5UqEH7bL133t8tu1n2pio1llyKd+9CW3To4BAfgo7YEkQkbMDwQUy3cXESrdHJdbj1+eQbuV/DPkClM9tmru4Utr8dHf3Yzx9EoFTrTmk3nIinzajYM0gniUIDDLLI+vs8lvWyZCuAx1zzODFe9SNgDoPCPiJS8Lgr0kYfYBjdOx4B271Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTu1b20JwnS12NUhf2W9DU7JYk6JC9PATuoP8neq0pU=;
 b=hAR25Q0lkar5FLYiI3kQAfzC2HfBKGtMMGT/Dqadv4kuC2iBDhxx5FtxedBhQMwMfX6/wIKIzBZjYBH8FU39Xxm8DQ169sWvPSW84EGxJZFmvm+w9cJ/TmY93MDbCsjFpWbX4ZnwNdXt8DEj/mSir/acMToAZ6cwss01htkDUz25mGd9NHMnBJx2Ue5ZTN0+NzrwrknqCwgqr/DsrzFb+7s9yKoV1UkGjYPW5tz2gPrwVkD9/872cPUXZmKdShqnupJ16tMUSirzPJ6Dzk9z9QHsFzgw0pPGYImebKRhnYcgnRQdOjUf49MP0zEfQMf6Ln6s7jBxk8hzIg90PLeYEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB9494.namprd11.prod.outlook.com (2603:10b6:208:59c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Tue, 31 Mar
 2026 17:39:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.014; Tue, 31 Mar 2026
 17:39:43 +0000
Message-ID: <8012ca3b-e2e5-4bdb-93f6-e8a70c775df2@intel.com>
Date: Tue, 31 Mar 2026 10:39:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/10] selftests/resctrl: Remove requirement on cache
 miss rate
To: =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
CC: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1773432891.git.reinette.chatre@intel.com>
 <1fc79420f76d585231252e59d4fcf19b3e704ee3.1773432891.git.reinette.chatre@intel.com>
 <4e3b5362-e751-03a4-f98c-a760ad274d02@linux.intel.com>
 <ef8bb064-f562-4237-ac72-fc2c00a5708e@intel.com>
 <42de2e76-5962-caf5-3b8d-453784b43af2@linux.intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <42de2e76-5962-caf5-3b8d-453784b43af2@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0298.namprd03.prod.outlook.com
 (2603:10b6:303:b5::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB9494:EE_
X-MS-Office365-Filtering-Correlation-Id: 8515d4d1-7b66-4616-5f6b-08de8f4c7e9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: DumJPVZc9pHAnsddkxvur/MpWn32KnaOgmxXU5URHiUBEygmJL23b5SxFBlCiTXEKHPilIxbWXKTTnd6hyugQmKLldIbRJJtFZYISzg03vibjDyBtfgUmS5JqvEcpJsOiz71xKsxp3GKSnsVoiwnqLCgvAC9DvJiAh36uHu2uKNWjbydwnfax1nUE6+dD1IzcS5Atv7xmMcBDA+/KlffMEYWpgrcgPCLoeeh+o3QJppoaPdw41er7Ft0cB3RE4kSvRrOszo9Ecw8SDlIuMtrFWnVugfp6zDTJm4nYQ0OBmNzQjPmb3gRl3O9sO6OiB0PXmkagysBMg35KSXfFSdtgtlKUgf7UbwajKi8l81jsDHroanyac7kfsNk9xlUZyywbAkKZKLJkSizH2MYr8S+wM3yo8/pMC8g7Zz6dqVt/AlC2IMNr1sc9l0vEgWZ3u3q8NXgy+kbpx5NtndTkF8J+SKgWAQtgV2KLUSVWUb1XanXPPy1TGkJ3ZCsnMCxcO1S0SJAEfqJdHwVAp9GGtAQgi2DmXYteKlqVyDEuKFq23M5B/TSvKlnP/VIHCLqA0rWFDJ+lf1imvqh7a4UibfCy2ycEL74nP5KggNWLuXG4LTaYyL8T7L7wWa1MDggTXmlcr6TiJ7QbpWdqOB9S17lke+0Pl9I6xgxrWzHtVQl3vvcPdVprP2h0T48oZ09eugGC+KzC6Ob0i0Xb/28i2LLrxbGnHxSwG1L8mdpORYOunc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RlZOa0ppYVkzZmdvUXYrZHYwOFVNMjBERU00bS9Db29TUmdUSlN3aCtGMENp?=
 =?utf-8?B?bkE5aDZ0bmZvU0NGdG9BbzduM25selVXOC9mQUJLU0ZBMG1SMm1GTndCeE1C?=
 =?utf-8?B?N1lBc0lyR2RBQ1dxcXlOSDdUbWJsemtNL3VpVHpWZXBuQlMrU3ZqRlVDZnhY?=
 =?utf-8?B?ZmNVK3p0SFVyTmQ2RndEMWphUlduTlJqdTF6d1ZLb082ZVE2azFoSEdPZVJH?=
 =?utf-8?B?Y2I3MkZBRVdURjBIL0lkQ3BsU05uaFcvWmt1VWhWd0RqWXlpWkl2bWJrMGN5?=
 =?utf-8?B?R2tTRW5GU2NRV2s2c2Voc25DLzhteXIyNzI1a3NvQWlJT2F5eEs4bnVsdm1Z?=
 =?utf-8?B?bElpUUtOYjFkaUUxVUhDbTlwL3JYUmxVUElsMzI1aTVzdGNndU8yb2dnb0tN?=
 =?utf-8?B?QmpGbkVMYUs1N0NXdWNBNlNWVGJJTGRBZ0VMbWJndllIOUc3aVQ3NXNFcVRp?=
 =?utf-8?B?bSsydkYvR3NFQllJYzVOVjlaT2xaY0NvcytWZVdHYW1CazJDclRBZzJ6SW81?=
 =?utf-8?B?NXN4L2NTQzIwZXRmUElqOExnSlErazUvSUFRTlZqN1lTWGFtdmVLODVMOEF4?=
 =?utf-8?B?OSt2ckorYkdPREh1V0REMTB3NnFFclJjWjZwNEptVWZSM21OMGZmaWZIRXpv?=
 =?utf-8?B?Ujl1RzVCcm1qMG1KZEFqbUVPMkZlNmU2ZzRvSDgyUHF4Uk5nYTVvbXAxVWtB?=
 =?utf-8?B?VWZRclZyKzlGSmJYS1lscTBOQzFMZFVtUEViQ1dJYXJOY0VIN1cwZ0t5WG9u?=
 =?utf-8?B?YWpyOVdnbUdlTzc4RkJpNll5MDR1L1hjeER1T2NGakhNeUtqaVJtVHBXSkd0?=
 =?utf-8?B?ZG9FVFpyZnBTVnc1WTFlVnl2ckV6UFo2MnRjbzJnL1lPU2thV3JwemxaWHMx?=
 =?utf-8?B?VGQ1dUtDQmYySUFhTUYvSHNWaDdXbkxvK1Z3UzAxWk1oaW1vTWdKOUp5R1U5?=
 =?utf-8?B?U1ZrZWRlTXFCRWdGRjdKSEMyRlIxUHc5enpKdkt1QVNMdlJ0ekhOOHdZMERV?=
 =?utf-8?B?V2hFMWFyU1Q0M2cyTEVQM3NnRHNwWTZCMWlwQ3pQOEJROElSalRrM080dFVZ?=
 =?utf-8?B?ek1JTGp6WHBCVHRYYkZHNFNCTXcyb01Qa0sweWQ4bTNKZ1JYTlU2dmozTnor?=
 =?utf-8?B?K1RIQjMyVXlOVEVOcGxqVmJWZXlOM2Z0YWNrTm93R2dDcjlUTWpBb3g0eGRv?=
 =?utf-8?B?dng2VE0vdlBibkZiZE1SWlN0SVB3VFpCWUhqRlZQYmc0NEZ2V0h1bVI4dFEy?=
 =?utf-8?B?dzdmK1dUTU5pZmIzbzFZQVZadk5wTUVzY1BkeUl4Y1JSYURDRnhtUTVDQVpT?=
 =?utf-8?B?ZWl4ak5VMEFKeUR5MUR1MFVRbFZuZDRaUHJRY3llWEE0WFZ4YWplSUt5UzZy?=
 =?utf-8?B?WGFYaE11ZHhYc212YlJVdzVOM0ZmczI2MTViYjIrNGZGaEEwemRzeSt4Uktl?=
 =?utf-8?B?U251SWo3STV3TDhtQ285MnUxYjlEN3Q2dUZBOGYvalMxZ0h6MUh5NXdML1Qy?=
 =?utf-8?B?K2ZGUlNlUHRDZm12SUVRb2pId2VJYW5keVdzREZGeXByajE5Rm4rVXQ0OXJ6?=
 =?utf-8?B?MlkyVEJxbzY2Mk55L0YzVGJ2bjhGaWlCK011VGMrQ3VQMWVzNE1PVzhmazFl?=
 =?utf-8?B?SHBLNUkvOW04L2tWcktTOUF5T05tV2orWjBpRzQyeDI1b3hHWkR2c2ZrdHMw?=
 =?utf-8?B?VWlwMFlpUGdOUFhHK0h1T25CVSs5NEZ2RjlMQjdldTgwYTUzUVl3MUQzNlQ2?=
 =?utf-8?B?aFI5V0VrQVZHWGk3SkJzQmpWc1dLYnc5WWhIcjJZS0NjZnRrcVQyOHhWd1pm?=
 =?utf-8?B?eDlENTNaRTBObGxaenB5SitKV2VNYzFZK3ZCOWk5QUxHUFE3aTNTV0FJcGdL?=
 =?utf-8?B?YmxRU2Rjd0NSSDE0Z3o3cFdsLzNBb0Y2QVdGajZvdFlJcWVkYlVLVWNwd0F6?=
 =?utf-8?B?alhUZ3Q3Q25LM2Rha0ZKSXBFVUFvU0ZmOTBmU2drajlrekZFNjBIOUlocHlS?=
 =?utf-8?B?cUErb1RhcE5xR1lmNTB2VzQ4SStNZkhGb2xoaHlVb3ZBcUZZT2RuVXpQRHpB?=
 =?utf-8?B?SEVFQ0hKb1ZEdkdzVUE5ZUhiQWQ2WHZGVW9vV08zT1l2RHloMlZLellQRERa?=
 =?utf-8?B?dVArTEZ3bEtGbGRWZUhxNFFpUk1OR3NEbzV4QTRpUGxocE5JVEJxTDVyZVNG?=
 =?utf-8?B?bmk1Z21PclhWOE8vdGo1NmJLUmZGa2dnRjBBNWFzME55b2Fjak44Wnl3WW9T?=
 =?utf-8?B?RjRMRUd5akFoNnRwSGpqREFtcW03TEVUS0x5eWlYblcvMGhxck12Zm1Sa0l2?=
 =?utf-8?B?VG0zRjNLTkZ1TGhLOC9Mc1J0RU1peWV5KzU1T1lqak9idDYrRC85UGVvVE5t?=
 =?utf-8?Q?aTjOrD2lw4gyjVrE=3D?=
X-Exchange-RoutingPolicyChecked: ACY7dh8n3ecPJNsSJhgBBnrU6Y4BY00IX0iKROWuZYm7vC7eY8IUot/CpobwhCrsv+Hjpn3pEOZruOsq73gVZI3cu5TKHjloU5Er1vn1rrnxRk7WXC6z/ltjuAu2ncvxSzBuO8h6v/tJitFx7/VYqNds7E0e6x4LXzE8sSluIlM7MG8tkVp70C07anfiZFL+cnj11ahpcgTH1fEsbi3WZf2PKBL2eVRrdWy5ziBeF6oKOkC50jl3DP6ZHlU/DLtZPr/WA7bmCqL2wGd/A+LHBnhzSkn9eLiZV4e4Za1Vk+Ti7+09yNe4iohPZIerzc6wgoTxYTk7wSYS6Z3b5s4pVQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8515d4d1-7b66-4616-5f6b-08de8f4c7e9b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2026 17:39:43.9092
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rL2O7J9B8/0mU1pl76glCqH7+qZ0QkOoAk+v34ACAjKs8bd2d8typaJJehHSX3L9ttbBENd70V9PGJgNU29BAxVvhQoOlAS2gj5w9B5u44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB9494
X-OriginatorOrg: intel.com



On 3/31/26 1:07 AM, Ilpo Järvinen wrote:
> On Fri, 27 Mar 2026, Reinette Chatre wrote:

>> Below is an example of what a user running the CAT test will see after these changes.
>> Since show_cache_info() always prints avg_llc_val the user can obtain insight into failure
>> by considering it and its previous measurement.
>>
>> # Starting L3_CAT test ...
>> # Mounting resctrl to "/sys/fs/resctrl"
>> # Cache size :117964800
>> # Writing benchmark parameters to resctrl FS
>> # Write schema "L2:1=0x1" to resctrl FS
>> # Write schema "L3:0=1fc0" to resctrl FS
>> # Write schema "L3:0=3f" to resctrl FS
>> # Write schema "L3:0=1ff0" to resctrl FS
>> # Write schema "L3:0=f" to resctrl FS
>> # Write schema "L3:0=1ffc" to resctrl FS
>> # Write schema "L3:0=3" to resctrl FS
>> # Checking for pass/fail
>> # Number of bits: 6
>> # Average LLC val: 445092
>> # Cache span (lines): 737280
>> # Pass: Check cache miss rate increased
>> # Number of bits: 4
>> # Average LLC val: 724472
>> # Cache span (lines): 491520
>> # Pass: Check cache miss rate increased
>> # Number of bits: 2
>> # Average LLC val: 1085470
>> # Cache span (lines): 245760
>> ok 4 L3_CAT: test
> 
> Okay, I didn't remember there was another place printing the numbers.
> No problem with this then,
> 
> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> 

Thank you very much Ilpo.

Reinette
