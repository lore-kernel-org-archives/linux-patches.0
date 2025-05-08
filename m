Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ACAB4B1E7A
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675490; cv=fail; b=c2duUJZZaxdOYrvS8klaotNy0/SAXw/i4nbFbfswbHllbkSyHOaBEQtycGLonIwgMqc/Sn4JqRwnkFWO1JE2TwX+KBPJzYhWsQT64qBJiauGIhfWNgT4IhLyDxYgDoOebWTsORX0cGthHht0aJpJvmrxfkDxCMSIbrwdgYoTAOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675490; c=relaxed/simple;
	bh=HrBm3VZi861lbtTU+qctK7VDu2cZdeUGTQFkLYMjYnE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rTE6J89/eVky3QPw3dMQdgpnlJYu05n7sO6Jna64zu9m+xFeFmQ7f/zksdTHHLiJzt9DzirfUBqDzNDQdAdWiaN0sod4648ypD4H3MvJRAnGWIRtjxslPvt2mYVb7ssAuoh+YItBLf6+SNfcMxuGGRGeA48U15F/V78Fosi5MIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ldSpGOrU; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ldSpGOrU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675490; x=1778211490;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HrBm3VZi861lbtTU+qctK7VDu2cZdeUGTQFkLYMjYnE=;
  b=ldSpGOrUZAio0P0SLY+oqIdUILTxRRRUy7xoBVTdwj7adbEp8LV7Xo4L
   +tJLVfkuzkHWtPkq+d2mG7vvFZ7ZCLxdYboV7aO/M3Yv2wmP61HgV3WWn
   l6l9I4w2aPTMYcvT532cq3fbE4Fp6QF4WJa0RBhXaeu+V7LsQMSNio9OO
   9SECVGgYuy2+kC+rLl8FX7UMROhUmPV2eHj/JECEa+2u0qfzXWoeYhNYG
   U4kL1TzgsyQwYU2j/pyop82G2864cuquygBw/Gt89kFLzRTGnfIJXvTAD
   xusPaPcIyv1eNIFK+E7Q4X42j+B8HZR6M61XXBtLMR+ccowv9WBrlYXy5
   A==;
X-CSE-ConnectionGUID: D1d9CiApQ7+5/7s4sc19gQ==
X-CSE-MsgGUID: /xWLEgAcT3yvTNegZ59fww==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="58638407"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="58638407"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:38:09 -0700
X-CSE-ConnectionGUID: 57J/fXzIQbOAsOa0+Y06pw==
X-CSE-MsgGUID: wmpalQDvQAm9aPoNAo9ozg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136117028"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:38:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:38:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:38:08 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:38:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wb+UAUjhGOlynZK6Dm1qM+Vx7hRs4ptbyXYzs3MCrsfft4X6Sd1gD90u966vhd0VRdepsxFH2ZKUoamG/dd/dklgW9FtsSHuUXvYRdulc/cv628yh3oZH7YZ6hccyicV6sey6v/hX3oTP4bZaJ6c2R99/xAyBmdMKu+GZPjRJ//jsOYShIk0DvxeWJQ+4YHEBHnzrNLmMHfNRyiymF+yLUv0Dfx5s75JrlXzRr8GivgeVyhEDi2aLK2yX+1IwhXG5dtZa2lY8QfePdoLQlwWJG0GT6fMmasskMOckLDQzwzvQIqjzZBooCta6H/VvvB34oRSkoLm7XJIHPGw0oFpDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gd2n1BFTOqiZbjzoamiPbZoOEM0J3tn2y61oYqlRmlk=;
 b=q+Q9YPTmtNUYeOsctFwU4HGGp6UsYjtMYDe3kR33nq36ykXpU+eSCNr0RoDN2QrRpEgcEYmo1Rbs8BDkO9I6FaNz+qUNRoH34mvizALzFA6/NF2F3RgnME7fzkDM4fJdCTSFYQSHsn11HxBE74KT7KW63SwWUd1ctT664swZ93gw2HZvJ+bW9qc0qc40Vm3JM6KuE4n2qIVFlzQQmzxqmV7izUMt6hT7QWp1QMYKSi/SNsRuSK2z4jTAfuC9MXX1RVE2+s7Zba0/IqhE3g4zPrLKb/jI0HZ0iV/ymEavHgRYQ3XluS1dMVXIGQw/p5SyT9XkYd1ub7vZd0cap/mcjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:37:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:37:46 +0000
Message-ID: <9ca2b66c-b156-4255-bc79-c1b1a5a0338e@intel.com>
Date: Wed, 7 May 2025 20:37:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/31] x86,fs/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0043.namprd07.prod.outlook.com
 (2603:10b6:a03:60::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ff717e8-05b0-454a-a1ac-08dd8de1b2fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WmxpZEpDMjcrS0hMNE1nOFlyNmhyRjVKWUZWNVdJdkM1L20ybFI3OCtVbUNs?=
 =?utf-8?B?UE90U2RhSGludWswVjhQRk9TYmZXVUdnejNoNUdCRXNWSzEvclYwMzFVNEs5?=
 =?utf-8?B?emtXTTQ2QmxKWEFpOVZ4UHpvYlF1UW1xR1pSVWhBVDFvQjhCb2k1RzZDRU1J?=
 =?utf-8?B?Z0czZ1lSRCsxQnFTakN5NVQ3S1RnQVBiSWxzdEFUT2dIZElKdFdlamJZSnQr?=
 =?utf-8?B?d2E2ZE5QaDVtS3FhYi9qK0ZBNGpFOUFHam9DaDZtU2FZalFtQlQ3NGwxMHp6?=
 =?utf-8?B?V3JnMkZwR3VLT2EzeVR2U2tyeE11SnhKVjhRV05GZVNnY0RvN00rWDhadmFH?=
 =?utf-8?B?WERJbWs4TW1ENWFtYmtUODF2MU1URkMvaEl4T0JMcm10TlVpNGFWYnd0cVJG?=
 =?utf-8?B?MFhPREJaKzdnTzBycFlNb1dEOVJBKzhaYTdVL1FFV1F2SlovQ2RYMkNsSi9M?=
 =?utf-8?B?ejUzMkFsUDROWmhxbEM4RkM4amJVekprSmxTSkN4UXNiZzhPR1NaT2NvQStx?=
 =?utf-8?B?QVdoWjRoWDJlc1NqU1FYVmZQMWsyZjRHWEplUXd1SzV4MmpQRXNxZ2djbXVM?=
 =?utf-8?B?eURiUW8wYzZPUjB3RVJPcWdOTG44QUxYM1pTeFcxdXJPUUR1Sll0Q3lCYXd6?=
 =?utf-8?B?MGZrbCtqSW8rRjE0T2dWM0hlaERMOUJzRXhjSXJGdUZjaW1JOGZvZEMrczJy?=
 =?utf-8?B?YWxaRm5oMEY1VEtvRzhuUzFFS1ppeU41TW5ETXlkVUFQZDQ2dXh3N3V4NVBw?=
 =?utf-8?B?SGswR2JxaHM2Z1hzbUVXbjEydFdHYncyUVZDNEhnUUhCVTVWaHlKQW4rL0RF?=
 =?utf-8?B?RmJvbGVtQ1VWQ0JzSG1IN2xLeE91LzgvVU1oNWphbTVqejhTdWhrNmxRaFdr?=
 =?utf-8?B?dlhtdmtsaUhqb0RvRXA0Y1F3WUhEYmtqWXFHWU14MVVWM1p4STVZdmt2Ni9L?=
 =?utf-8?B?OTlwaVZWVTRUWkh5QlFoelRLdGpVRUxqVVQxUitIbVBXdFptaFZ4NWhaaHY0?=
 =?utf-8?B?V3pCQ01vRitJVW1TSTRrQzNJZXVDQ0xUVnhnL2xDQXIxSUdFa1NxOU1XYWRt?=
 =?utf-8?B?MCtLeWxjN0VXRnpuS1pYcTNubWtzRVpDblRHR3EvZmVvbUdjUlgxa2R2TnZC?=
 =?utf-8?B?OUFUYktabUJRVm5DL1BTZmRTZDBWVXZ6N09qNkxYZXliNHdVeFZ3U2V3R0hV?=
 =?utf-8?B?UmtkWFFUcmVrZzRraytNeTBLTUhPMHlBRGJaL3dKOFliYXZwb0ZxQjltZHBY?=
 =?utf-8?B?R213NU5adlU3bTdpUmNqU0o0M0ZEK3ltR1VPeGpwWmxHbjNic1YwOWNVZllm?=
 =?utf-8?B?b2Zub1pNUlF3UmMwdkZHdGJHZURzMXViejZROEc2ZzlYcTBKQXZVbXNmV2ZR?=
 =?utf-8?B?T0lUQWxtOVR4MmdFK1EyRlpoR2pFMnVGUkxBS3JmNUVXMG10Q2RwdjVmcU5t?=
 =?utf-8?B?dHVzR1hNL0NWemNvSGFvdC9xVnA3MzZOeGtmRTJVODNqSjV5MGF4OTZ6c2l1?=
 =?utf-8?B?R3lTUDI2YUFLUlhpWUZWRUpNTkhHZk05alpkVlFWRG41aW1qSzdNYlE5aVpQ?=
 =?utf-8?B?b2o2K0RQOW9SaUp2eUI4eDBXVEN2bG95V3BKQWZNSU5mczhKczBFSWpKY3F6?=
 =?utf-8?B?VHNtWUNvaCtsaldmMDlESzNJdERXU2pQUThUcnpXRnZsbGJNT08zTVhOQlk5?=
 =?utf-8?B?RmcwUjhySkU4MnhIUklDT0pucU9hai9LQXFUVkZwVDc0aWY3VHpmMWFud1Vt?=
 =?utf-8?B?Uk5QUU1sT2loRDVhZlFXd1RlL2xGYVRZeHY5YXBuZXNGNmpoeVFESVdYRis4?=
 =?utf-8?B?anY2Ti9LdFpTRDhsMmVPRVg1NXM3N3ZXS2dhamcxMk9vanpTc2duc1BXNHRm?=
 =?utf-8?B?Y1FzM1VONnZ3eXJ3Y1ptUCtBZyt2YU9jQXBmeVV2T1IxSUMvVDd5YU5xaXlC?=
 =?utf-8?B?aGVmZnZCMHpxNlFwa0NlSlZrTE54THZjaExxbjFJV2JoNjg3eFJDcWUrZkZF?=
 =?utf-8?B?SFJydG5laVRBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUhUTU56NllWRzNWWEVROTVUVUJ6TmtuUHhHbmVEWDRlOER1ZmxZTG5abFFI?=
 =?utf-8?B?RXhzenA2MVhENnB6eEh5dGplS0k4QU5vUWNkWG8rMGhncEczQW5Lck82ejBr?=
 =?utf-8?B?QytxbXBpTzFmbG9lVmFFNFVVVHl5VElJNlhlUzNHUXBkOHIwbTJCeGxQSGpJ?=
 =?utf-8?B?MGxDaUZBU0ZBS0JHaG9lN0txUkJIM3VsQzRtN3BINDdEaTR0bkg1ZFhyc0tQ?=
 =?utf-8?B?dmErL0RMQ21kcUdRZ281aEtRdW9IRGdEMndoc3pBLy9TNFd3ejh5ekNPSTNw?=
 =?utf-8?B?R0o3U21pMWpxa3U2dFBPb3FiU0VUSkM0dmw3b09WNlVDZ2JEMnVZTk55NzZz?=
 =?utf-8?B?V3FvWlR4TFduQUZaV3BCUXhVY0hzTEdHZysrYUxwZ2dSa1B1Z3FwZmVVL0gr?=
 =?utf-8?B?QjBDQ3VmM2NVVkhFNWh3U284cjFsM0I4YWsvVkx2SzRtVVNGRkFkeVFEaHNC?=
 =?utf-8?B?aGFGb3V2UmFGNW0vSkNhd1RwWEhYMTExeHdFK2pJelVrWVZ1cWtjaExtNUVR?=
 =?utf-8?B?NWhlK3o3KzN6MkRxS09renN3S21Va3R2MmlZSlR3ZDdFL1pYejRYTmh6NlFv?=
 =?utf-8?B?QnZFNHdqY3FYZ0o5dnhrR2ozdG9uYi9mUlRzNzZHLzRVeHMyb05UYW5MdElv?=
 =?utf-8?B?T2p3aitpR09ZUC9lMHZNSlQxbEtCaEMvSjV5a1NvdUZka050RnU3RWU1ZnU0?=
 =?utf-8?B?ek5yQmZ1bFAvb3dkNm1GTHZ2SkF5bENjM0x0bmlpVWFmWGVZY2xZamtkd0E1?=
 =?utf-8?B?SW1pQkJoQU1PdzB5ZkF6M0pMNmxRWDF4Sk1QMk0xanVxcUluWm9tV3BRUkd2?=
 =?utf-8?B?Nkh4VVRra2QyRkJCQzJvMnR6UzhnQUYzTU1lNGYzU2Z0Z21kMkxvZUFxazls?=
 =?utf-8?B?eS9tWUJVMUlHRU5HbTZnbnQzZWxyNGV6R0k3bUdMY3U2WnpjeHRaT2dRNkFV?=
 =?utf-8?B?TjVGRXZPNDEwMmJ4a0p3ZVhQSWxvZ1ZpYnlBdWhlWHVCVzRoV3MycmxWWFJP?=
 =?utf-8?B?NzRnYmp0cEFrdHphb1o0K2lyQVdBTy9WMHYyWk56b2dHV3hhNXUvRXFpSzV6?=
 =?utf-8?B?NzYwTzFUMElGQlRvckhlVGlVN1l2UXZrN3ZpMGFGQXJWOW85aHZMMmh2eWhJ?=
 =?utf-8?B?b0ZRcGEwREFqUEFoL2ozbFVsN0VvUC9LMi9INmhrZmJKc3FrUkxrNURuNGpO?=
 =?utf-8?B?TkVLbUxZOWx0NzMxbkIvT29PNCtvRzVnc2VPTFJ1SmVDTy9Ld3NzWHdPaXpy?=
 =?utf-8?B?ZWhqRnVpYWoxWlZHUFpyZXZMQmRZQjRLZ1pXV0c3cFVkWExVOGViY01ZZ2Ro?=
 =?utf-8?B?WXQ1YnV0K3JXL0QvZ2E3cWlGcXNPakxsRlhIemtSSUlPWVVEUEtJUU1hTElW?=
 =?utf-8?B?Wk42Q3BKN1FHSjdWQ1Q1bUhwZzExWEdBMERKTDBCb3VoZkhzSC9qTS9ia1Rp?=
 =?utf-8?B?bUZKcjYzdWFIT1BJOUh0ZzJ3K1Z4dUZEcDNEaEhWVklQenA4ejJycW5jK3pS?=
 =?utf-8?B?ZDNiZWdXR09EeGhGeU41R1lwVlE3YVlhamF4NDQyT3cyVCtqQ1V0U1dtQmxY?=
 =?utf-8?B?dEJjbDhINExNSS9vNng1Y2NseCtFUGJ0K2pMNzdpM0U0aEZJMlAxMnhJdTZG?=
 =?utf-8?B?VTlHeVVacHFpV2g3ak1KaE9lTEZoRDc2SGdNYkwrdkJRZTV1b1ZrcHFEaHhK?=
 =?utf-8?B?ZjFMTjk3MGxoNktGdGE4UEp4dnlMNUpLaTZ5cC8xRmFKMDFROVkwcmNJaGV6?=
 =?utf-8?B?czdBS0JhUHlIMXBVVlptMTdtSGExbGpOSTM0SkxzMUpJL3VNMDZkMXFSUXl5?=
 =?utf-8?B?M05TRHgyaXE0Tmc2elQwYjZtL3VYank5YTErQWRMZllVWWVHOUp2c2RuUzFN?=
 =?utf-8?B?WmZFRWRQVVNLMkRHVmxBZmtvOHgvbzV4Q3U1d3NZeU9uNlpQMkFoejBJZ2RZ?=
 =?utf-8?B?allJSVU4eXE1Q0xFRklaOFBQd1JTQk9iMnZzUTRSUVhuZEhqai8xTmgxa1o0?=
 =?utf-8?B?SkpsRU01NkRsUGRFWXJYbWFjWnl1REVMd1FmMFFGSlA2dnFxVk1BZkl5SjUv?=
 =?utf-8?B?eThHQUxKQmJDS3lJMXJPR2FYdDdqbDEvL3pwcmNmMitnNWd6Q0J6cmRiZWdM?=
 =?utf-8?B?akVYUnpCQk91a05HdnlzQzBXYlNlVEJuOFZJMmFVR1k4dWgvZ3pZRjBXZkV1?=
 =?utf-8?B?VGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ff717e8-05b0-454a-a1ac-08dd8de1b2fd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:37:46.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l+gwO0wHOBbx8b2F2oLm4bB9+YJszm9Jcw1TTx2Rvj853j0MYLVM7m3HR1iKI0yr1ZKnp/VT7A0DG/FYzMOqs74HPo6CUgp5z0lPO3B/Sdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> The RDT_RESOURCE_L3 resource carries a lot of state in the domain
> structures which needs to be dealt with when a domain is taken offline
> by removing the last CPU in the domain.
> 
> Refactor so all the L3 processing is separated from general actions of
> clearing the CPU bit in the mask and removing directories from mon_data.

Why? Always please follow the tip guidance wrt changelogs: Context, Problem, Solution.

Reinette
