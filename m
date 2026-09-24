Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D88D4D2EC8
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790283598; cv=fail; b=VqYDtYwdCNyNilsYd9IAmHvPz5bX+gWH3cOabJzyJA0oTE0/3fMjg5bs8MDc3TM5MBBk+kXbw4qcdTsWacqyVs3HT7hrWYy1JC1I7hr/kAJKDX+hzKUCLq5XZRdB2Et3kyyLjue2qwVWCfzYXJeAFTH8cK6b3emkU9JQUX52fpE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790283598; c=relaxed/simple;
	bh=wjn05JX08FkkAAAUOiN8DeC5VeBWnYoIndYGD38CkJg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=T4zF5QsXIj1rlTltOuIDSdFfZ+EFKYmtyVVgqC1IoaDl4pTeBMVnDQyvS8I0tbInco+FmTEfIswDcxayl/j4mHV+sTQpefJnFW1C2bSEtCXMXWlECakVR9JyLQliIPWweiOLxK4pK1WNVmEu1MjiCsXfu20AFoAI9ejMqOKRDH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLsMILh7; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLsMILh7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790283596; x=1821819596;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wjn05JX08FkkAAAUOiN8DeC5VeBWnYoIndYGD38CkJg=;
  b=CLsMILh7+uZiZKVoeV1uXVwpDDUOLD0wckpQoLgjuV63/JsKeZS8qfrr
   abHb1pjgN9+JrPf+JXP/+cN4AYC6pO1r2pFSaKut0Vog9AGM9mNkWmalU
   GCinLtKoh3e61/JWZjoBS1TfLowS79NIAnr9RJM97VMB5NZRg0w1cSkMC
   033HxKPCKPwZo3QrLJQFLITW3GZ5zShR7kxglQDbCc1xYSW0I0hOOJHaZ
   FymTkeZIRBUwtlb/uQO4Xj0I+z4ZhemZfJaOz9hETMnnvvh24Vd9Y+CxW
   EDqnLTbv7xCzU6dkNDuH2MsS4UP91DO6YOKAbEYGTIyPoMa4c7v5YCbp3
   g==;
X-CSE-ConnectionGUID: SBBLcdBNQ12nX/0FTi6DOw==
X-CSE-MsgGUID: RIWpI9KYQXGXi/rRIK1nUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="78625533"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="78625533"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:59:56 -0700
X-CSE-ConnectionGUID: cHHDdO9LQDeog/AfsVWS1A==
X-CSE-MsgGUID: fJjGNnaDQAKFsrVxcVvLtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="277529582"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:59:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:59:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:59:55 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.51) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:59:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xRxRnKfRGzXiaI6cbEMxL8aA2Ixb69/88hUFr/y5VomafAQyflR7t4AZPvotTEpBSeaTbpDNLOvmXtVDQ6BXILVOb/num3Pv6KqPQtN0XayrTL8yv6D3IDQOgnJmCmCJEjOhFKgqDBH5ecH5DOcyjWr/pLmJyOzr2HhKHlKhmRsAImtYLgA7SSnVOG+A9f1ep/Vf3ucVGxZjtCTzphq6EFYfAwVoFY0DwGQHdN0L+uxqrAFwjHViPCer7TuaDOgLDS+Qh2UftrKoeCjbaxyMz+wQfn80C7hOhwy4YXogWuVDVL1iSdKVWS7yqPwrpoT1DCW3At3bwf2nYhOCnMRmsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D1USaX8u+F+912766RpHX9bsRGB1iQ/+etecuSl21ZI=;
 b=fFOC+GvJiiFsqKkVW311DuE0OOa2nXAGpmjZADGV4ysKc/vgHd+szFYT7OORQU2RZt/2o78u2hFL4tLc/AYvqCzUebxWC8BLYoEsu0eVWRajEeQ0KbMzk7P/HwheQxrbJgYUKjPzJLJResEO288+Ba+4yEA8a4slYAIV+sSBHpSt6wgSu8MXn7YnoojT4F4bjJ8cENU0tblSwXa+JSApxJkM2pgvV3O08PMxuxdGVNZqJVfAPFcG38oYZxLOm/KU9PNB+meMBA+v4Rhk5dyIP8INc7ocmktR6rT6ljIdexi8AWUTcSqiNllIoJNaps/mMOysgmQyIWPF9XwveI0Fyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 20:59:51 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:59:51 +0000
Message-ID: <7b810855-f813-425a-8ccf-0e317ce1acaf@intel.com>
Date: Thu, 24 Sep 2026 13:59:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 24/25] x86/resctrl: Simplify Kconfig options for
 resctrl
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:303:6b::17) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: 74f9c226-991d-4c50-03b6-08df1a7ec6f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|4143699003|921020|56012099006|10067099003|11063799006|22082099003|18002099003|6133799003|4133799003;
X-Microsoft-Antispam-Message-Info: PACzrHRQAIPwofrQ9EvmomJBzWK3QBHalRRmE6Brla0Ho+22qpZ37TuwjXq4nVB7zDO/65aLnFwdi3nc6cQB/Rj3Ncus341G6XVW7bcrmCgXwkpr8bRVNfLpfONkf1VMMgVJCcqN7LlAf7+/b1s01A9xILdybyb5IAlfq/RpyFfAH7tdkLsweZ5pt/INrODuLOmNq6PnC2bkphkSM8osPrXHclfj2eqztqGRGCCd2MCSzNXIXWwvmx+U9YNNBqhmtQOH9vLJE1FuQoqSn89thd372nbI+ecdYWBjq5eV/TXFJwbfg4Nysxf3NQJsbj0oEgEpHGkrO1OfS6k+oWAu7nbZESrH88qqWcFFdowhdEgBYt57o6RmATFg0fFfoUdwi1UKFiXELH0/KPFvT935KclmluXNgkn2/hKzye1cSdO4cr8ZYFMZl8ksxaUcahN/sC10iUw7zgu3o53w9whqNdtMOkrqBOOK7ZPonGsYeHyB1tdnZjOtlNJ/nOk0v+q1QuGT5oA0bVxJtWnHKV8YMLmAcevVI5xU0A7NPHgqnUspuhDn0SzBYsADgn8KGxwPoEgkBIMaHTOdExevLS+0FIAQzwOrZHeSHA73jyeqv1UYspd2MRjVfsJT4nlyFCOerE1gIuokZKvK1sN5Os5ojLnG4JhumkyLJCmmAYdlHm3i9pbV6gGULQkLKHXRINFsJAq5TfEz4jT1l2610WhaKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(4143699003)(921020)(56012099006)(10067099003)(11063799006)(22082099003)(18002099003)(6133799003)(4133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkhnWW5HMGhIVnMrRE5Nb0EvUm1PWDJwYU53dmFlWVBsczNMRDE2Kzd3SWxu?=
 =?utf-8?B?MVpUbm9PdmFielgzSitqVWt5Y2EzdktwUFZ0R1R2YW90eXVLeEJMSkNNT2Mw?=
 =?utf-8?B?NDE2SE12RllFMnJoU0NxdFlMQ0ErZDdWRm83aUJ5d2c3TW02d0psM2VHRTRQ?=
 =?utf-8?B?U1hCc0NqSC94THVzWUF0a1l4dnJoRnI3SGRjSzA3SE40Z3huaUgzMWI4R2Rp?=
 =?utf-8?B?YUdTaStmRDRhb3pMZUtuSDBZS2tLV2RPTVV1eEprQVhjaFFRTUZTU0sxSzhu?=
 =?utf-8?B?S2FLZWhaLzlxbC96dzhwZlRFbzFidUNsNFB2OWNDeHE0SUVUaExUSC9pbmlL?=
 =?utf-8?B?eSt3V2NJQ3VVaEZIRjVNemg2Q3IrelVEbFNac2M5bVV0N0UzVEwwR3RvdXBx?=
 =?utf-8?B?TXErblBXWUl0L0pEbnZ0NnhhVmFZOTU3MXF1L0NqMC9xSVJ2SUp1bVd6TER1?=
 =?utf-8?B?OS93aS9mbml0WFBWakwzVzhOQVE1ZStCeVJEMXNOWDJaUmlLRnQ3a3JNQmVr?=
 =?utf-8?B?cnVacTRGRGkxN3ZQMDAxQVVENzlnOXhoTWlrY0FacGhldk9RY3VycVJZS2NL?=
 =?utf-8?B?MzlMN1JjUS9lVGR4K2crY2w4SVl1emNINHQ1dHM2ZEtzOHFmK0FsSTNORHAw?=
 =?utf-8?B?Z0VPdkM2OUFXR2x6bjRjMXZUY0k4MHFkVUkzT00rUW92a0hOU2k3QTlrRGxC?=
 =?utf-8?B?ZkZIQ2VMbkQyOVRnZDhBNy9SemI1SnhOYW1oeW1wT2g1MGtHRGdjYXNpNHJE?=
 =?utf-8?B?L0NyQUZyb3pFOUd1SFlmb05JT3pLMkNQeWc0MERHQm5ValVDaklhRnpQSE12?=
 =?utf-8?B?Mzh6VVd1NVRoejc2OFJHWHFIenVQSCszb0ZEc0E3cHZGa3R4ZUFyTWhvRFF6?=
 =?utf-8?B?WXU1anVHSmIwMDFUZ1AybW5TREp1Z3I2OEdUK1BhbUJPazdiMGJIbUdiWklF?=
 =?utf-8?B?VldEZ3VMWFplWXRmZ3FOUm5vYVRWWUJWTmx6cllaS092dHhOZnVTL2o2NzJX?=
 =?utf-8?B?RENtWlJGMEZaWXViWU1Ic2VnNmNSeUQrdmJzMi9oRlJ3S1VMYlhPVHJEWlNY?=
 =?utf-8?B?bnlpY2xtWUkwa0dPS1htY0lDaTd3S1pHQU1weEdwMzkzM0VyWDVBdmdRcklQ?=
 =?utf-8?B?UEhKN0xzMU01eXdXdjNyaWk4NWRQbHFhWWJYWWFlNkNXZUdDUHEzTFVjSkVn?=
 =?utf-8?B?K3VRZlM3UTdMQk1HVGRlTldkSFBEclJOazhNejRuL2Y2R0tkZUJTWVM5aEF5?=
 =?utf-8?B?MFpDdkhCZW8yRHZpM2luVXg2Y0d3V3NHYTlEYVg2RXk0QllyQUE0LzJuREN4?=
 =?utf-8?B?QW1hMkkwOE9BMG83aHJJS05LRzg1ZDR3Q3Q2czkwd0FsODE5K1YrcGZuTTkx?=
 =?utf-8?B?NUdpVDBHaVlETjFyUzJMSFNabTZodHJDQWhMOExqSGk5OFIxeDdVV2RZbkQy?=
 =?utf-8?B?LytveC82N05nL3VLSUdsaVFCd1RMNnlTS2IrbFh2UnVyQUJERzljeTV6c3pk?=
 =?utf-8?B?WnJSY0tIK0tEWnZyaGFRTWVzU1hDVVlqL3pQZFZ3OXplRnd0WURCV0dIT2o5?=
 =?utf-8?B?SGNWZ1JIUng0TkVBSkQ2ZkRhclRIMmJOTGpMQ2grNjVzT3RzREVRODlqMFRM?=
 =?utf-8?B?UUgvUi9KWUN5bFY4Wkd5eVdqbHN5emtCbnJQUThaVXFjdFVjMGF6RUNoYjFn?=
 =?utf-8?B?eTc4aU1KSHhwNVhWL1FhNU81V1JtaUhhN1BHVjBYN2xZYmtOSUxDZWVZSXFl?=
 =?utf-8?B?QjlrdWx4RC9iRjNkTU44SlhXaS9HUjVzWU91VVo1SGZrcW44azljaytMSlRJ?=
 =?utf-8?B?OVNwL3orOXZST1FxWVlvS3QwTVR0WkhLTEtBczg5Qk5Na0xlZlZRa0xnZGZK?=
 =?utf-8?B?QUVpZEMwKzBobFpWcUluZWppbkVvek1abVV4OGZBR25ETjNoN3lLKzNJYUwr?=
 =?utf-8?B?NGVyMld3Yml4Y0Izdm80bGdaWWpZRHVJSDIxWjZQbjZpUms3dk9BWkJTcXRm?=
 =?utf-8?B?SHhOcGJmdTZTSlROOTQxN1NJazZwYnZqVk5tZFUwdDJVazBhcTVJMlBwZWNB?=
 =?utf-8?B?Y2MrVS9pdGYrV200VTNlayt2ejVNbytlNGZsRlpPaXhXRjRxaFNpWWQxbVR3?=
 =?utf-8?B?YWhHalpEdUNUZTJnUG9pRUx0MHdrRjFEeUZ2VlJqTkUzdktsSmEwSC9CRXhr?=
 =?utf-8?B?Z1piZFpGUndrdEhNMmZmSk5QNHNUWEVoOHZYN3dsT21Bc1lGRUpsTzdlcFBx?=
 =?utf-8?B?TGNGei9zZlN4UlJsenJoOCtNV05oTDFqZjN1QXpWTGFYcW96MEcyS04vYUlU?=
 =?utf-8?B?NlFmMFBhWGVqSTJHZmFreHMvUnJySUFnSjJnVDRVWWZCZWg5cTcxTnRycE9P?=
 =?utf-8?Q?T3cIvk5tKg5ia0I4=3D?=
X-Exchange-RoutingPolicyChecked: bBjvG+VvK/gqrtputnuHke22pW76mZtmM0po219+9E+QO3+uhNuXS4+CP7HGsFWtXNg3oqABmPQTPoTbfFz8kDEDMkARPgwc6DmKIhkfGIYaf6qiFGDl/Lr5JblFZkQhZh38antgu5mmaYVXSFJ/tu8cRGtqvatbjdPEdoGSwk1nJJrRfvRgLtSlQq52PFvbk7zDH6pm8U4qKAO+IsCTcvTburW65X63t9Sd3T6au059lnOHk+wkTHZpEMpXR4b8iLPOU0g4DsFTdMF5dDU69sIqQfZSZs3wYh/33yLteqs/yWMg9yc+L2F0Lul9HTMbjy7Fm8SkNS6+pUZx7awEdA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 74f9c226-991d-4c50-03b6-08df1a7ec6f1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:59:51.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7iC6Sg2kInVYUYRBFBDkL6GHzygWbd+EeXOnIdaOZThcpqtIQ2DwZZbIcGbCJA+lj/q7cLZVNR4Yk0M5lTU/Ql13HFURB3twO56z5unw4a0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> Linus Torvalds complained[1] about Kconfig complexity making it too
> hard for "random people to build their own kernels".
> 
> CONFIG_X86_CPU_RESCTRL_INTEL_AET has been causing problems since it was first
> added as it required other config options to be set to "built-in".  There is
> no longer a requirement that INTEL_PMT_TELEMETRY or INTEL_TPMI be built-in.
> 
> Drop CONFIG_X86_CPU_RESCTRL_INTEL_AET and unconditionally include
> AET (Application Energy Telemetry) as part of X86_CPU_RESCTRL.
> 
> Link: https://lore.kernel.org/all/CAHk-=whigg3hvOy7c1j1MXFy6o6CHp0g4Tc3Y-MAk+XDssHU0A@mail.gmail.com # [1]
> Signed-off-by: Tony Luck <tony.luck@intel.com>

See "Ordering of commit tags" in Documentation/process/maintainer-tip.rst

> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 5e71dd758624..93d36fa8c638 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -233,24 +233,11 @@ bool rdt_cpu_has(int flag);
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  void resctrl_arch_mbm_cntr_assign_set_one(struct rdt_resource *r);
>  
> -#ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
>  bool intel_aet_pre_mount(void);
>  void intel_aet_unmount(void);

The function names imply they are Intel only while they will now always run
on all x86. Should the "intel_" be dropped to make this clear so that folks will
hopefully always keep in mind how these functions behave when run on non-Intel
systems that do not support AET?

Reinette
