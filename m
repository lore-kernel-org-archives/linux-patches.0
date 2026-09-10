Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70C139AD51
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 04:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789013143; cv=fail; b=EoaMIASenp4IiMHyyePYPp9h7AngxKuQ+TkertD5T8azNoe2e3I7qHH51JI1bNXlq+7E21juXjsvOJ+9SSGXeoYd5NrVXYkgjQCcWWFgf5r/QcfmgSMjGJNwkbEDraVB6+HGrOqoKmmsoBEnKqxI6dLdmm5zuVsF+EbHi2DTliU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789013143; c=relaxed/simple;
	bh=p2v6/KIufcOOJscRsIB8piA/3C9lCQiEhlM7QYRMntU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YahLIYeAsYw72ZfA2yZT1evEWbx0++hJijU8vGLSw6y3BEmDRQ0rm7/8OVUq/TrtbmGMoge3JRzunVIElW7Ue8BQ92bbAIoATy2bGWTos8SAbQVmAffSNRSuVDT3J456MCaqhwZozuXUfn9Oa+zDbWdATwnZTybo/CVHiYAf5JE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gReHowNb; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gReHowNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789013142; x=1820549142;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p2v6/KIufcOOJscRsIB8piA/3C9lCQiEhlM7QYRMntU=;
  b=gReHowNb9FiUzyN7OyZsRyuwzQKdCtNUgbBuk6zm/ORQ5kmIjuSXPLK1
   a5DBBUzkRL7/EJhgZgjJuLitIVk9de2oss7GA29QDh7Temkqwoe0IzURb
   icBADi8CFBzh12h/xBtRSHhnT1mQ0qnmOfM87okG0iuusM0qODsqKDgQI
   OXw3aNkt3bIAHaHtC3KG+ZfljDZbBLGBZBmbXQR2nczWaSYXQU75cULLr
   lByQf9r9fJAWPIeuGtum9OKTUTjIwkJtcnDT2XaI/Cb6mY7HxgZoigZuQ
   OlF/sNr2um3R8warAtZMViLzYv4UViz/Xb3DTkDVOoFUiQQ0Zz4ZGT4Z5
   Q==;
X-CSE-ConnectionGUID: OOg1WGt2QJq/FiLDe823OA==
X-CSE-MsgGUID: dBsVFCJ4SVCPUQVoiYOUmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11900"; a="89297742"
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="89297742"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:05:41 -0700
X-CSE-ConnectionGUID: RR1/VeOaQq6pq7G1P8etUw==
X-CSE-MsgGUID: 69bkeygKRMOsliVBX6OCbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,271,1779174000"; 
   d="scan'208";a="295009200"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2026 21:05:41 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:05:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 9 Sep 2026 21:05:40 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 21:05:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+X0SVpPunBm7O/255wV1FyFEspLspaA4x7qmlMJ5dVqDX3ZeeBmA+liCQuyW3ExD/kl/LlI13WvKnZ64L/zaw2IqCu6Y+LazboEQpxRfi5UF7lJ+KzaHuzDvc16ebSnYx+6AZBqucLPuqj5+E/r8K0H9LmabdLaGouP3tXpayrUy4xKO3+x5MHAIVNs6KTcSFWm07N/pnhBWlcXWYXbnvjmf8q8M7uCOBfEajw8eWxrFwotYms+FkgeVXHELwtP6+1drYORTeRoPDb9R8r6ZSYyulhBkt8Nl9PM93eLIID6Ovng8JoMcNno+bS1OxhAwyAqjV1andGMw/Rnco0teA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWNsLZUoCdpgAOWiwiOcMY6YHs4DOIoZG4DCDug/hWM=;
 b=btCxwkbwKVD50edmp0Bm0g8coR80/7YJyIx4L+LcFNlJJ04/aLqxql2d1DHOOdC/pLxB3fHJFupUQK6b8AAOuzlZeAwRJJUYQywDMaDAvRoV8fGF/BP/vL+n7aUBo+i1H7p8OR4o/uoI3xhx/V7m0bKj2l9gBMGQEforFJNl2EMbdmajyZBJ9q+4zQdnbK3bD5zjvJzQ01rXlor0cvj8ozOoel8jFvXS1MHzRWrgR7xjLlE5Fu/3NbtEYmG2622VzsvafgZEdWfr1kv/6orI8nM65W77Y50JxrxLXazjGl+fSBxUxiq537Myhv5mVkG7ZeBH7kzERy5xoXsANHUJLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by BL1PR11MB5979.namprd11.prod.outlook.com (2603:10b6:208:386::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.8; Thu, 10 Sep
 2026 04:05:30 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 04:05:30 +0000
Message-ID: <4cfe5c3e-c061-474b-9c47-483b87eecbcc@intel.com>
Date: Wed, 9 Sep 2026 21:05:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/23] x86/resctrl: Enforce system RMID limit on AET
 event groups
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260831174421.13921-1-tony.luck@intel.com>
 <20260831174421.13921-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260831174421.13921-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0328.namprd03.prod.outlook.com
 (2603:10b6:303:dd::33) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|BL1PR11MB5979:EE_
X-MS-Office365-Filtering-Correlation-Id: ea8537b6-2bdb-4063-8b83-08df0ef0c132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|921020|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: IyeWxYGJ172UL2mdaVOXaSdGySGlRQGUlVshFEfKMA+8vOltpnkNedIenUnsAVpUc7AYOP3WBlsQIUmUUB7FWTiuMC8lFXPlAH3UWVWIWAZnI+XLeMaglGdaE1J9tNjKWyJf4OM8tp4a+DqG/C2ns9RWC/Vwfpm1CsBMZjRGaOEoan93GY47ZzWnN0WJMdc0Ls8yn94Bakq3Xz+wqWGuEbktViiONHnlC5CI4mt4UQvsmfstmafroZNTKWDXlcdrJivO3ViUkyToslYAa9vOvymAblRwX2XyOacMQ76fJRo704LaaVruTEgg7lqeCY90oci3x9mTosOPtaW7UYgGFxojV0Y5oqy1ZHd3RlkAp5ccdeQdxSGSg9uL9KhMPMBF51qB8jK3jFhNgiKCSDy3x47qgxCpQjTrf016NEo5UXk5N727P0W+npLsbO3T71pD145NfGdM6693jH2oNRiSDqo6bWEG2kbni7BDtrA1Nl7vy/2BfnitVKkIrbEgzjwIwb//yUm8Xwas0CExMHAv4SrC4MexkYv8xsVpCU2ATSdxu0qrVLnW/0KCVZswglmcKp1FvwIfIgWFpU7tDxvZn+KKV1RCAQZ9HDwPHKn2X1+Tm1DCQ8vkleR+cxCvAYBQrXoBH/dLmPnjwHCF21EcI6mmVIdr1Eq1rP3pmjX3Vwfytrfqg6XP4JCp4CUtHGNUtGStZs+WNKeOCpKNSozOaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(921020)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cENWbUovYktBNnBzbS9ZRUp1dXU4RWRMZEZCSkIwV2pCWXpDY2RCV3crVDRU?=
 =?utf-8?B?UDRaYTRJN3M1NW44NVFDcXc3L2svWXpISVVsaGl6WGZqcTJsTmlXVUFCcHBv?=
 =?utf-8?B?OUNHdTRBZVZSZXE3UlZVYkJvOEJyTC9wZGFhTmNTcUhzUzZMYURzRWpQbSsz?=
 =?utf-8?B?eU1uSUoyaWZxRXBjNlFJc1lHNUhNaTdQNTJ0QzNXWEpBbHR0di9Ka0QrQ2Nk?=
 =?utf-8?B?QjVTWVE4WkZTVlpTYWdDVTdnaU03WjJiUkVEM1RQVE1mOGd6aFYwRy9uRU8r?=
 =?utf-8?B?NWhCa1VYcEhTOTM4SG03YXBwNnBKcEFLdnNySWtFTURQWHJ5RkNRV0hBSXRa?=
 =?utf-8?B?VzFlTzh4V3FZT1NCRHpIV1ZBM0hqU3pCdnpxbkIwTDVHU2tqZERxTWJybDR3?=
 =?utf-8?B?VmFjcEpEZkFPd3F0UCtDVGJjSWlsRFJyTDFaWHdieVhrK1NXc2k5RVZsNko3?=
 =?utf-8?B?OFVFdkpER3dVbzJKZU9jU1A1NW4ycmhraTRaZ2pMSFVrQmtva1Vya09EdDMw?=
 =?utf-8?B?cytkNzRTQ0EzemxDU1orSHVTYllJK1YySzhKQWdPWUw3dHl2bEZBSm41Mkt2?=
 =?utf-8?B?ZHZlL0MwQ3BMVE9IdkpBbzZRQTB0NHdHQ2t5OCtTeUh0eGdZUndEYjlReW1Y?=
 =?utf-8?B?MVRlMUY1NDVKNGhmYWRZS1h4OFRGSWZBeWxTSis4Y2UrckRVTkZzaTBwOWhC?=
 =?utf-8?B?NlV4REhvV01Kd25UQThBYzNucVR5QUNZem1SYmduUjdEbVZCaXhrdUd2dENJ?=
 =?utf-8?B?MUlTN3dPNTY5amFPWEdLd1ovZC9XOFNTWE1uOHBvV2syUHFUVnZITkpTU3U2?=
 =?utf-8?B?bUtpR0hQUng0TEtqalBJZkg3anovQjR1Q3daU2ZrUGR2SDh0VURSQ0VmRWNF?=
 =?utf-8?B?eFpZTFcwQnY2TlQ2UlVNYzZhZ2kzaTc2Q3hySitvc2hUMXVJRzVvSGFtTDBR?=
 =?utf-8?B?RHBwd2J3a3FlZGdhL1hzdkNRUnhwYW03QXZ2dTBOTzE0NXZCVG9ad1lPYkJS?=
 =?utf-8?B?TmFGNnFGeTZjWXVZS0JVQ2J6cjF3ZDhmR3lvaWNCWERkemlTcjljQ2tLamUr?=
 =?utf-8?B?RVpaWENXeWdaT3Z6M0ZuRVpqM1ZUUklSTEtOcU9tS3laMWhxanpjNDJDNElV?=
 =?utf-8?B?ZklMMDhIVkZmNUd0eUpWQ041dTBLU3dNS2NnakpNaElXR1o1RWFiVEo4U0RP?=
 =?utf-8?B?VjNybkFYSm1LWXVMbFBrV013SVJsNjRaeEpZNEtKTy9TVk9ESDhQV2hyZk5a?=
 =?utf-8?B?a3czNWlmcSt1WHgvaHp1cUdPYk1weHdCNHcxWDh4dW9aNi9YR2V3VnF5UEEx?=
 =?utf-8?B?ZHAyK0E4NXoyQ0VseXlJbHcyOFYvZzVjQlpXbkd3VnYrSHZURUlFYXNEeG9s?=
 =?utf-8?B?MUMrQnl0T0hwLytwV2hYd0dXalhybWt1Mmd5Q0luTjh2aGUvKysvTjQ4Qng1?=
 =?utf-8?B?VHJVL01pOUE0SW9IbEdVUzdLamUwQXdkSUFTTitoRnQzMzlUUDczeE5Sb2pM?=
 =?utf-8?B?cnZtaXlsY0NiN21MWjNuZlExWVR3dVdFc1VGRzd5WmMxZE9oKzltdlVmQTk5?=
 =?utf-8?B?MkU2UXIyRWZoVEY3L01BVGNqcDdoSXNiMmhMd213R3pQdjFydmhYMWgrc0Nz?=
 =?utf-8?B?MmJOcHE5THZGdlVvWlE4QkpyVjNWSytrSjFFMUlUaHpMUHJ4VWFUTk9EWTRQ?=
 =?utf-8?B?MTVEbTA3eFhQdGlSMDFUUUYza3BDTmNnZnllSi9iOXh0SDNqYWVOMFR6Y2VN?=
 =?utf-8?B?cDNtTEZhWVF4K3JkNjJBTElyQTlVU2Y4QXo4NHpqVUljZzJrR0l3WnkyUWxp?=
 =?utf-8?B?c1dKVGJnSlNKWDRoRDlZR3Y5U1JkWFFYemV2YzNwOFZTNHNpRWdkNVpEcjF0?=
 =?utf-8?B?THcxKzZYRXhhd2pMa1F0bGMzRWlvL1BSNGdkUW5xR1RHb0JmbnBHNStlcE9W?=
 =?utf-8?B?dXY1NDMwSlUwZG4wKzN6Tkk4aDZyWUNCMUttWWdKZ2RtL3lWdXdxb0x1TkEw?=
 =?utf-8?B?UzMvMytnNVlYQzEwd1NkUDl3MFhPUFEwMHRKejkwOVhkQy9wYmdDNE1mRlNn?=
 =?utf-8?B?T2dLcVNtS09kbHlsSTM0cmJ2ODZZeDZySTB4eGt3VHI3bC9xd0dSdk9TcndX?=
 =?utf-8?B?QlFwRDAyMmpVdEZXNUVtbTFWREpsa1V4NEZFK1hHTythQW1ZS2dhVFRkeEY4?=
 =?utf-8?B?VXBmY3ROWEhYZk40cDFreGVGMXdadG5odERHS3YxWGo4ZlVlWWpUNVpKNXBB?=
 =?utf-8?B?QjVIelRRSGtreVQrRC8xQ2M3akhXMGQ1TGY0S2ljYjVjbTdXV1Vjd1NGb3F0?=
 =?utf-8?B?a25xZTQyd09qbzhENEFJK2tsYSthbXBFUk9naktxOWtVRk82bTQ4Zk84a3p6?=
 =?utf-8?Q?T4JKcwaeAZubkDMA=3D?=
X-Exchange-RoutingPolicyChecked: HzZWQdQdbmld4vLbvj/aHfRJSlDimkaQDp+ZdjMVe1Cqt8tfrNRHofMI35CeVKL4S00DemF/oteGPD+7RtKy2v6I54gaMEgK3FnM4wr87E0r83/v+hDbJ62eL/zlN3zif+vB+rONaGLpWgnWhXD/ZS2xe96nr3SoGoxQgx2yxjJDKNKFQjV8w6SsRfCMww5+sCTJo08LETKBlZyUoJh5xlR/xlurt0089eat8N2ZDyguKgo8zAoc09Y74bbGCccJuGPx/pFlLUydI0j+ay/vNMgh5+pgjPIj+mTf9gv/egWlRCNxStU81jr9y+KKmoMgyd4quPHUA4lOg240Newxbw==
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8537b6-2bdb-4063-8b83-08df0ef0c132
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 04:05:30.7203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWUWbpoUXDz8cki744y9BwBMC8nc4d6J7+s1O7TPW4/vrkPHzYAhqttM0nFVSXb7xrKaxO+8h05/YJC5RrPLGXZlpoxVu+mPXIcq6Ivwg5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5979
X-OriginatorOrg: intel.com

Hi Tony,

On 8/31/26 10:44 AM, Tony Luck wrote:
> AET (Application Energy Telemetry) event groups each support a specific
> number of RMIDs. But that number may be lower than the number supported
> by the system. This is especially true on systems with SNC (Sub-NUMA Cluster)
> enabled as that reduces the number of supported RMIDs.
> 
> Reduce all event_group::num_rmid to system maximum.

Why is this needed? Doesn't resctrl_arch_system_num_rmid_idx() ensure the
minimum is taken across all resources? I do not see why a resource needs to
artificially reduce the number of RMIDs it supports.

Reinette

