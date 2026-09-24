Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DDA240611
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 22:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790287246; cv=fail; b=NItLYpQ1UeufmhwTPm1u3vBiX1yWwg5BVpB1jhnDtF64TJs/tC5ln9LrUUW6HfG8xOzThVNxyTYA43N+q3/swwxmjFAmRwbm5DsfmkF7/e0fI+iZjiokDOwAI6ulakyyBloOEaY/S7Gu1ZyGjkY/ym28aeeRTdcXSyi+sqYU1pc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790287246; c=relaxed/simple;
	bh=kZqap5Xt7URQLjHON3ebZ2omRaPW/CIrN45pJHXWFac=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Tt1LFkrN6/GVQ9d/Y1kbns9aCn2G1QEsJClbKz2FARJvOFhr9XtIIPduAjJQkUtoX9y1CQEaxANpHCi+b+69OkFla9M53XYi2b3L/6ITAIdXObneJsogTFdP7wJ2Hot+BwBMKq8ERtE+iZ9nxvWlwe7JdvqFn1cs6anQSbr3JRc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jmjDxWns; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jmjDxWns"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790287243; x=1821823243;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kZqap5Xt7URQLjHON3ebZ2omRaPW/CIrN45pJHXWFac=;
  b=jmjDxWnsDxaU6D2yMiNKq2ZXuTrQiVoEtptHEN7Nqa75gu8urrkaGtvT
   Odg4zDXqWONH5LR7lM/tgQcxY6oAoGlt/0f93ooGeKSmJ5/ptOQejuPbJ
   vT61W2w+CSgI8siTrJDIloiPULLIJFl7mQYXACuJ8OoJnIIgId+0+fekG
   /w1k50QSBdEhaaKlPPZQA7BZEEre/qjp2xcLfpRQl4C77dpqS1sv1Czfc
   ANnHywc8BlIAArLwIqC1wS3enhRjbylQlkOlUoYkdYKwts9SyHF1edj6Y
   EBDLKXh2kgvTtIMbHLW2rcukKp2tKQ4vcQDENnug7heqV4RuO9qqIKIfA
   A==;
X-CSE-ConnectionGUID: TQj+4qKrSKKUbmDBfN7Epw==
X-CSE-MsgGUID: rSxITGO8RKS9RfKpfggEjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101653262"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="101653262"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 15:00:41 -0700
X-CSE-ConnectionGUID: aXGF9+uKRLiXZMSpA3G1pQ==
X-CSE-MsgGUID: CRHVRIWxTF2bKvfiSb0Y8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="303681001"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 15:00:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 15:00:40 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 15:00:40 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 15:00:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F9MR1J9WdbvUzW01C1v+hCM2w28fuWqnzcN+Xjtmd203J7Y7rlvEndbzWYUeIgBmTISbBnO41LYAfCovPeR+WZGyj7S2c0HNL8j2C5ehTvAucdUIg3hHe3xnXG05CZrS/G7SXw9B8+R7jPm+bNACD5elkpv7k6QmLNEe0ZtMNrLfGpTf++K1JQRaD41tJdwW65aOmgHtNIw4Di1eJuPXEOojrXyp/p85up5MW8V6Dtt8KCUvq20coEHtmoSXdMfIUAlZD4PZmUHU2Voj35Qs5VKf/C0TbehsTFGT63YPwrgXKxP8VFxA30XzkdFqguSExx7L1lCohxXceR8VQtoFMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PD85/KztBug7LIPrmcUivlNCa0pPN2De18lO3Qxp/qw=;
 b=b8SFmTu/h2VDEBOIVZ8xq5rGiKGrxmkbc07A+xn3TqUb4RWEA8XJb+gRPBj80GvGrVNSn0C3D66IIT7ko3XJa6GHHf6VyHY25hFUY+Wg4s8V0hsH7+n8BpDl8CVcvHHCcj7q233/Y5LBISDtSmOnvoNgd4Q0KN8UHms6KFVjk1R+9FqXoGXbuVtYEu0ZvSmPgHWkvlBSUA+HIkQXMLXassROFf+JdbeaAWEjAl6hPLbetZqAWD9mCfHomSMFRkv+THMQ5KhT41uJSQn3KYqlGOQpuQREzS/3Zti8LTuQ6Juemr6dE7ep+EsPCK0XmlASPAxIh9k5QQtCjQlGr4L7Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV3PR11MB8555.namprd11.prod.outlook.com (2603:10b6:408:1b0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 22:00:32 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 22:00:32 +0000
Message-ID: <616594ee-2763-4910-92a5-beb39e12f24c@intel.com>
Date: Thu, 24 Sep 2026 15:00:30 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/resctrl: Update documented unit for the "activity"
 event
To: <x86@kernel.org>, Borislav Petkov <bp@alien8.de>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, Drew Fustini
	<dfustini@baylibre.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Peter Newman <peternewman@google.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, Tony Luck <tony.luck@intel.com>
References: <20260915190431.18189-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260915190431.18189-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0028.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::33) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV3PR11MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: 54d32199-6072-4329-1005-08df1a8740c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|11063799006|10067099003|56012099006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: l3GkDwCmy6PkujdHyNPckrnbDAJzcORx1lEt3jKQkPHlPF1LndR1EJID8PuqKNEE4LdN2oeAZWSNGkrjqgj2HoBCrJhBYb+A0ogkl3aU886H/p/x2ZuSeFwPB398X5Lkx0mQ3eCml6yH4L+z+SBq+dV6bWIo4dKgbBRCV74Y9TsqhuLjZuBWgQTRQ23KprdPR4CXNfYkMngwNnXcC3pCy+E/i4FDucoed6OUI3Aoo/EeYL/7EkWXbW/FRGRCo7UloJYvtcZ79cn7l4yLAVxFF1t4jiAORq5glBW5NDKlkcaqg4rKiYygNYWI8UPrQhHTC9P9XgD8o37sYuo7Ognfb6gq2h0xZBtjQAIryx2CF7arilEnylTeGt2fJ8QRmbHRg0USPUOmVrwifY1WyrHRtMxD5GWIegA2XnR5heSx7LBa2LnBEaJeNSTu7xQDWsCT8lU8ikRrQ0aRryvc7qS2ygLc3ZLQPn0viNanitiRNWw+WY4m1S2W9iq6oPtUF6Na1dW58lrNGno/TokrAL1R4RuEBOxMCW6KqFmEgzmeJT6KvNpPpd+stP/A6EWI98P/oxKJgkQhTPsTkuyAvRYc7ISJv7amy8L/oYSsZJDpg1n9fPBnxTqxAnIY5QN1wF9N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(11063799006)(10067099003)(56012099006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0RoSU1pMExIRExYRDRpSGlZMXEvbXZUK0F0eVhWaUdkL1VvVmhobjZDRWJL?=
 =?utf-8?B?U2ZBV00rY1JXUHU1Sm84R2xvM3lIYjI5RkJvQXYrYXZ2UENnRlNqeHZ3cHZ3?=
 =?utf-8?B?cGxVKzFxYm9jQ0xTTW1FYWtUWUdjcmpyUTF6NWFTeEZCTDd1NG1vTmsyZWV5?=
 =?utf-8?B?M0tONU9KRkdCN1hhZEEyWCs2T09meW9BWWJBNmRuOHVEMVBIN1ZORlowUTVn?=
 =?utf-8?B?dXE4aHBUbDJSL1JaUnVLNmRKNHJBRFN2ZmtnNXdpVFRZb0J3U1V6Y0dYSFpu?=
 =?utf-8?B?Vjcvc1EwaE4ydnlJUjNnOXdPR1pGbHNzT2pWWjhyVjg4cExUMHFNTXlaNzFa?=
 =?utf-8?B?elpyV0J0OVE0Uyt2N0RINFc5WDZKWUwrMFJKOG5zQ2ZLdk5wSmdMb3RBdTg1?=
 =?utf-8?B?MTFYWk5hcHYxcGxXSkFhYmkwQWVrdytZSkJYaFlCQVhsY1JGdlVnRExhZkJE?=
 =?utf-8?B?b2tpT0srV0dUUlZjVXhNdzlVRFFHNEw5S0hvNUVsaG82VVRsRjB4MXhlYlJ2?=
 =?utf-8?B?cGNSQlVDdENjTExLa3ZhaVlTK0JPb1VvTFN3T1BvQ0ZTd1BuY29RUEM3UXdR?=
 =?utf-8?B?M05DdEFQdDU5T3J6NkExdmV5ZHdheEhPSXVzbG14NUhWdVA0Qi9wU2hTQUgv?=
 =?utf-8?B?Y1ZaRHB3cHgzbm90MStuY3NibXhEY1FTdVY3Z3Rod2pqNktwaktwQ1AxRURt?=
 =?utf-8?B?RitrbHhQUUViMWhYT1ZZY2t1dFNOSUgwMEdsRHREdWdNQ2IyLzhkUEhid3RL?=
 =?utf-8?B?bUVPV1RFWVVnVEV3VUdzOGNlYTJWajIzcDdxZWtHYjRZNWVuRFZhbTlBdXoz?=
 =?utf-8?B?K1QxMGJOZnZpYzd3ZGJjczJiVHhQNk41UUIzUDA5a3BjLzMwcUtGTUJCWjFD?=
 =?utf-8?B?SFdDMXpiVzFOSTd5TkdXamRJOHMwT2FBSC9tMThQaWVRTGJvS3pUMWcxUXBO?=
 =?utf-8?B?WlpwUnZpN1V3bThDWUZyT0tjcG13cmUwTGxMMTJUM2gydTZnU1BCQW12bEtM?=
 =?utf-8?B?akJ5RVp6VlRmZkxCN3J3c0YvdjZ1dHcyMVZSOU9LZkpheDVXM3lZa2NFM0F3?=
 =?utf-8?B?dHZVdU9wVGNQdVY2aEZEcjM0TmNhRyswMnZzTmRQNSsvQjNpc1lXTzd5cXkz?=
 =?utf-8?B?cENMS2NnVGZFVEg2QmVXYitpU2hqQkVMQy9kUzA3K2hDbUg2bFRscXk1M0Y0?=
 =?utf-8?B?dmM5RUU3bDhJNXk1aW9vbFVBQk40S1gwTlZrV2pUYmJ5Q1IzdE4xd2w0S0l6?=
 =?utf-8?B?eEtnRmF0eG9VdXVpa0RzeXF2eFJYZlY1ZElqQUlCNXB5VDE0MVpadWZUZU8x?=
 =?utf-8?B?WDlWUXpUMjljem9ZS09zUFVvbVZCS1lBY1RqNjdKaTJSYmZlQzk0enVReVNF?=
 =?utf-8?B?Ylc1RjVVL0dVQ09manZvNG40R2lWWkszc1BmdmgxaklNaE11N2Z0c1BnamR2?=
 =?utf-8?B?RVBvbU9iSG5BVHlJczdleW92S0Z5d3M4amNvb0c2bFRibmNIWWhCVU5hSktQ?=
 =?utf-8?B?WUUwMmg3SG0yTEV2a3I4cmQ2R1p5eUNlN1N3VTN1SUU3cXV2VDJjTW9aRzU2?=
 =?utf-8?B?d3FBQXVXdTdTL3NKRlkzME95RDhnRVdoeWpZZlljbUlTVmlxTTM5cG1aTFNi?=
 =?utf-8?B?TGtCbWQwSHZSWG14bmZFVXF3c2hiaHBQWHRtbzBVYkRpV1pJekJsYnJOaWRO?=
 =?utf-8?B?UkdwQjRtSnF0OTRadVBDMmRLVGJmbG05T1NZNEQ5N21QMGxtUzRTdzRqay9T?=
 =?utf-8?B?Rmg1bGdEbGRTall4UkQwb3QrNnl0Y1Z4cmM5d3lHY0xyUUdYSDFpZjBqTGNJ?=
 =?utf-8?B?Vjg2OEFGR2Z0VU5mTmRKOXdwcGN5eExFTEFLbWZMbFhWY1dvWUFiZis1YWFY?=
 =?utf-8?B?VG9SZlh6UHhoOVNodWxwN3dnblFvcFZYVHFLY25SYW13WUZEMlg1QzUrWU5v?=
 =?utf-8?B?dDBrM1A2bGNnOUF5TVlMWUFCTWIvZFBCdWVJN2E3NHVKclZhSzdaWHpoWHdh?=
 =?utf-8?B?eEtvMTBKQnNhbDNxdEZXVXZEcVE0MytBd0RmS3FvTm5yZWpYZDYrRUJkNkov?=
 =?utf-8?B?bURaeU96RENOZEl2TnRoUVZhODJBckdoZVF2TktsTDM5WFZKd1l3bVI2RHVh?=
 =?utf-8?B?TjFZcVZEd3ZXdEI3NFhobkJsdWpTZGlZakFETmkrc0V4Q3lRSVNoemlET250?=
 =?utf-8?B?T0ZPbDd1K2JRVHNFSUNqWXFHMGs1cU9sVnltM1dJREtoa3YwUlpPbUMxUmNl?=
 =?utf-8?B?clNSYmxKZEk3ZWtvT3VKakdPVE5vVDIremJZd0hzTG0wOUUya1UxVTROQTRm?=
 =?utf-8?B?TC9NVEZQak9YOVI5R2dRektPYk4zYzBCejhzN2p6V29FSTJ0ejQvSDk4VFNa?=
 =?utf-8?Q?Jcq4k06xhKZN5CeU=3D?=
X-Exchange-RoutingPolicyChecked: n21QmkrJukMsAmbFeIcgDXeenPhKIXpDdR2Nmbj4UE/zxKG3E/BT1cDjv0wwa7ebGFsq5CqBbCX9e09HbYogZHmKXXDh5xCn9sOrifV+spKFAEzhOIzVBLm3u4tjnvJ2tR7Twct6bWeoz3S7dHxG4OHDkC2+y/HVWNjzm2Hax5Kx5y8n1MNF3FJlUHjtEIiDZAhXlr5nlSQ14jJXCSh9MlYY8b5Zd6TmbVbJAwgyoYZ+06hfQJhC8n11vuksAuLsfzPjtAEFMetERXiNOYuWm8QhxwIstwwdKtiobOZfWay9DBiGkaCw2jKsN9TSaApr9c/aSvIR6sz+DEJlshlwEQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 54d32199-6072-4329-1005-08df1a8740c0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 22:00:32.1104
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 11ddA7RLsKP8UL7kmD9hx/YSGjZJabQgvAkDF4r8E8dQvNWcNd3pqKF1R/9dnfmABqiTgLf1CpsmPRgfqnyO8Ngckn89DBcj9bSnNmgpFL4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8555
X-OriginatorOrg: intel.com

Dear x86 maintainers,

Could you please consider this patch for inclusion?

Thank you very much.

Reinette

On 9/15/26 12:04 PM, Tony Luck wrote:
> The unit for the AET (Application Energy Telemetry) activity event[1] is nF, not F.
> 
> Fixes: a8848c4b43ad ("x86,fs/resctrl: Update documentation for telemetry events")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_common.xml#L9 # [1]
> ---
>  Documentation/filesystems/resctrl.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index e4b66af55ffb..a52cd812c261 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -643,7 +643,7 @@ When monitoring is enabled all MON groups will also contain:
>  	during execution of instructions summed across all logical CPUs on a
>  	package for the current monitoring group.
>  
> -	"activity" also reports a floating point value (in Farads).  This provides
> +	"activity" also reports a floating point value (in nanofarads).  This provides
>  	an estimate of work done independent of the frequency that the CPUs used
>  	for execution.
>  

