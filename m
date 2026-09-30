Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510C74DDB23
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 16:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787291; cv=fail; b=ahQ1kQAbRSJ+fBBt3OSVlj/RFp5yO+b12dkLgalBBaVvadP7fblptewnVwJhWhy7Q3tkvG8Ix2Sj4Ta87J5nVXAMq4xY0ZcOW+fbvwbGLX2UWhwxhui1b9TGg/54sD7vIOocDIcvFOOgOQp09hXj7jEKdJqXZ7tkuBN2q+vg0/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787291; c=relaxed/simple;
	bh=q2BUE/Al8p+KPNDAGQBwVqb8oWGfOBmoU9Owo+3tSAI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OApyP1eyq20eGLxaQ4uJMasVsepIKO3nwEoCy7eE4PacuYrN+ifc3L4GtvPBgBm0PbRkfO+5/EyTw51n/7ZvTQo/BWZABbGZfsub2Puihe+bca527zp0rUxUrwkzk7tmVprbfpT4Amt9kBRFwrdLCQOmJtEyjXfhGzS9teNwp7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Udv0TKQJ; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Udv0TKQJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790787289; x=1822323289;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q2BUE/Al8p+KPNDAGQBwVqb8oWGfOBmoU9Owo+3tSAI=;
  b=Udv0TKQJJ7JOcJ3R258jZYlt5yfrZEay29XoZQl1PIIOkT9xKvaCXfFx
   LuPxJg0MIwOCZOGtRmN4qpRCYAW73hQP/Ta3TsaH9GPGBG6rsHkanGQSM
   lxE/q8Ju3kprjqzSs1sxNIg8MODcEcubndOz0DdB2bFu/WaeAIDeoDHcE
   IcHaoMEcmLj5/Vmr193wPhWh6+oXwnLL2gSLLmXBoC1Sa4QVa7LS6BlXN
   glOB7L3QPRZ/1/ObvtKDMpPIoEY6pPEiXgFzgLJsBK4NySz11Us1AVjph
   K6cdb/hcs8ZFYZrt5EUwzJ8he0ZEqHdw8qRLjVAoVxhXCcUKZBT7Fai2/
   g==;
X-CSE-ConnectionGUID: jZ5Q2Q5QQ/e1PmwUm1n9rg==
X-CSE-MsgGUID: 850VZWAeTdGTZgw1o0cyZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="94242430"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="94242430"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 09:54:49 -0700
X-CSE-ConnectionGUID: 1tzTqrsZTQ6A2b6QV2F9lg==
X-CSE-MsgGUID: PC/Y1jfqTIOsH1jWVmi5xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="283814840"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 09:54:49 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 09:54:48 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 30 Sep 2026 09:54:48 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.20) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 30 Sep 2026 09:54:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1WMjDLMAEsGJof8eUte2S13Zmnc9eBGN+nPz5jea1SJ+lOhsnVeMTydcnNf3m1G7cjSpFgrh6C9tcJ6UxsBqS3TqHof3e9YYWwRsf0mMQTdnj0FKmF8TesxtGx8HsmN9C/KQeYTc3MkjSgQjgWd/48OruP9TBEoQV19NQ+aSBO5EKZQN3Ijx9lElL0+1KmZezdww/fldrf7vk8ciewH90WWsL8PKU8QxeR5otmhwesKSbCc2mIICTujn0onDbd3diT/Nua5J5Qxq0JT/OXQ6dXESAItsZBn7yR5X52PDMza2+/rNDBCvMX1ODMS9T6a2qlkWZxWlTqrWDnTSn7OrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqaHSiKEpLwM4SjPwVvrFLqH1jcxjgzZwqn2JGVnH9U=;
 b=U6t4B2WyAxdtPHxzTyOEGr8vg0pFhpkBrhP6klItfUCVIJHQsNjtNifCjRTAvn4bM+2ZStIx5u/fFP75W+5QMN5oBccUl+OStcjplcgJ7qYCKt3BIAijBsikCySMynGrSIdyO3MD+6zyhpzm/REHEILoaKj9eZI0qyJsAkDOkjeBO0ChJnA+RoJx9crWHFQD8m3TYbjZCrhOBT7Or/VNPDZfud4DivvaXBpN+PRXp7UOn0dl2EKMLxhtuKCuBxkW3GD/eeTiyktb67Yl/mUeJJ5P56DgtTwxgbL8xdUd2O6EAUvM8O7zeDVemzWcnhGLvxO910MiUXxiZyJ4wWN1LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by IA1PR11MB7365.namprd11.prod.outlook.com (2603:10b6:208:423::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Wed, 30 Sep
 2026 16:54:46 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.026; Wed, 30 Sep 2026
 16:54:46 +0000
Message-ID: <c6bcb782-7239-42a4-9689-81d063de40e9@intel.com>
Date: Wed, 30 Sep 2026 09:54:44 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] x86,fs/resctrl: Add event group descriptions for Intel
 Diamond Rapids
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260929171833.15883-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260929171833.15883-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0115.namprd04.prod.outlook.com
 (2603:10b6:303:83::30) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|IA1PR11MB7365:EE_
X-MS-Office365-Filtering-Correlation-Id: 188f252d-0806-4dbc-f9c9-08df1f138819
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|10067099003|56012099006|11063799006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: pilaUW/QWiMPq4rZDfhzGGvjsHg4eHS3LLz9ewZWdHrfm9J/4nBH/oa4F1oSgL5+ndRqWshVPN0hTPpsMw7DOrfbgjjMyx0ck2xHjdCMxBi9f3IW/RSUP+VvAi7Fa7cH+8cMAEJslySfp6VfUoWIaOzhIlsHlVotwXRNhRJct+FMY6aG/PEiTBiVSU8B4z+IBbjycohI28mkUYstD0kZoMJjpv7x2KBzVyghmjFxeI5qvdgEoqGbNuugfJhYzyCPFSu0XCQFofmLdvOJ+Nz890teJwxkbA6nq0H6SK2B/B+MIB5KyLHXT34exDiO1UzdKaw3W8e4X0YgfmmUI7mx9Vtfa/OcdsFDZbV+DBsAiJwa9zfezUF01EMiih3W4ExnB7n+lfFBanNrFYhcL8+EPbcXMhOLXIe1yJ1N7vrEx9mrN4hjzyw7YWo8iyIbbZvkNJ4W35MEnnavEPV1Zn/CdCF6EB1W8L69RwTjYmWv5yPvN/M8SmCIzGVuZINBAKpb56+hFAMcfzlQzX2AP6D/jqRgVMhK3FLxbIG4wABeDfozrbA5UYUb3RssJP62Jnfr2f1iXaVF4RrpAgIHD8UO0PwaoMiVzIo0IJv/MBNuW8uWqNXdBmP5qxoHFBWHMp8N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(10067099003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2JDN2owTDlSNlBYcnV4Ni95ekt0VUgzbDIwallrTkZ3anBIeWRzR1crcE1D?=
 =?utf-8?B?aHRqY1N4R2pyU0RoSFRoaTR2ZHBoWFB6TDhTUUVJclFQUTVjb1E5UHIxdG81?=
 =?utf-8?B?Y3hCclZmRm5FVGpWcUpzek5vNXIwV1lLdGRUdS92RUJrRi9LUmdyYXllSUxL?=
 =?utf-8?B?blAwcFJYMW9uREpFMFcxSkV1UzN0ZG9TRndzaTUwQVRwNWJML0VjREZFV1NX?=
 =?utf-8?B?SW01ck45OFZYckU5STE2QXlJckZiV25BMlllYnVDM0diUllKcHB4OE1nTW9Z?=
 =?utf-8?B?TUhienNqYWZxMzMxNEEvRTQ2VS9tdTNKaCswSXVwU05CcmprQnY3dzMwT0c1?=
 =?utf-8?B?Y01rRTlCQk5Pb0hydm0yVVZLdE1QM2JTemdSdnVocDNHbmhSeVJPTUhtUWV0?=
 =?utf-8?B?QUpUUUt3emUwOUszbDdGbis1cXlNRENabnh6L0FkTTR2aGZrRGRwdlpUSlBx?=
 =?utf-8?B?ZGxTaVRvTWhlYXdIdmt2MDJqUDZ4OWpVdFBVazd6bGs1V3oyeENPU21pbDRE?=
 =?utf-8?B?dTNSVnRYOG0xUlZjOG44aFlhT1FrRDRWaTF3bTBnZTBsTVYzMmRmOVBSQnpL?=
 =?utf-8?B?M0VkdXNZYjc1MWwyVy9kNDIwekIvTUNOM09ZTlpTdTVqZGN1RWhHdzBPT2V0?=
 =?utf-8?B?Z3J4dTJCZjFsWGNUNXVXSlY0cmNhN1dPZGtMNFJTcHRmU00zUitzdVF1TFhB?=
 =?utf-8?B?T0FRMkVPZXdObk8rVkJuUzh2QjZBdjZmTTljZFRRSDF5NWU1MDROUVUrMkdR?=
 =?utf-8?B?Qk03YjIxRVJqUW1sNW5qMUhWODJVUW5WaWZVNDJuRkxwWVBRbkJoMGx5NXNB?=
 =?utf-8?B?M3lQSVpEOUxhRzFVK3JSRjhqampNdFhmRzIzSDdVWXpuWjJ2T0tjbk41Y1Jh?=
 =?utf-8?B?ZjdNWWJtS2RabFVjRFZsKzFPYml6aURBZHptbkVaTWZXL3lPVlJaWXIvRFhk?=
 =?utf-8?B?UmNiOEZmVXpueHBrMnNMWTA1eTI5aGFNWk5oWkhSVDRraDRqY25FMzZZQmFy?=
 =?utf-8?B?Z2VPZlBmWTBWbWVDUDBnOHZqM3JWTUNrcDYweDJKcUd1Qk5QR1ZHeThFVHRu?=
 =?utf-8?B?RDNCTFIvVVZSSnNyVzYrNUI5YzlQYzR1QjExWXprY0pCQjdodzh2TFlBZU1j?=
 =?utf-8?B?NVhHeUhDTkVGWEtVQUpZTVNONHZCNUduSlFHa3F4M0tFYzNjU2U3YXg4YlAv?=
 =?utf-8?B?SUs4dFpzRmZNUFAxQU1TeFNWeVlkNWtKWEtHY3FDMXR6R1V2L1cwdThNbWtm?=
 =?utf-8?B?L3NoSlE5a2pYeE5xS2l4a2NEcEszWkxHMkY2VitPRmNEald6cURQZVJBTk82?=
 =?utf-8?B?akRsVDZSSVRFeXdlajhSOTBJaElGVFpFMXcxczBzNmx6UnV1QlJmUWF1NEU1?=
 =?utf-8?B?MXE2U1U5aUs0QlJDOG11U05qaHZ0bDVMb21DaWxlcUFPUUROUW9NK2N0T0o1?=
 =?utf-8?B?c2cwMXNBMy91K2JEcDZwWWlYN0RJMnhBTUsyUFBLM1hGQkVPN1plWEhJSzY5?=
 =?utf-8?B?bzlRcEx4dE9VUlEwaXFwNmFlTXQ2SG5pdkNMdi9aaWF4RkRPQlk1Rkg1U3Fo?=
 =?utf-8?B?cGMvM3JVbmJlMXhVYUtOSVcyTUlBRUZGdUpJODRXSlovQ1pOK25RaTFlNnhj?=
 =?utf-8?B?emlWNmgzYzJ4emtTOUpMTm1mQ0VQb2JxSER5SlIxNUhhZGpxMERmL2VuNlhN?=
 =?utf-8?B?bmlaQnBVemNIRW9qU1F1bmlHU3Q5Z0JxRTI2VjZpTUV5R244alRMcHdpNTQ1?=
 =?utf-8?B?NDZWNDdYQVRITXJwTE56QXluWlhVbzJCdEVwS3BUa1ViVytBTnA2a2thMTZX?=
 =?utf-8?B?WnNvcklxSHRLdUhpTWVwcU5oUzZjS0ZjMnJoOVQ0MU5OZkhVWlF1eHBQNTlr?=
 =?utf-8?B?Y1dkcU5BUGZvZVMzNzRpZTBJM3ZFZ0RVZ3BoOGNnYU1zWHpQVVpSanVFd3Q1?=
 =?utf-8?B?TEI0TEh6Vmx4Z2lRei8wVGFGa0hIaE84S2FSWUxiWFI3R0RYM1R1YU5WenlB?=
 =?utf-8?B?a1dmNUtXUUxQU2VtalJlRUNsOGl4NXZFZXlwYjBwK29LT0ZVcEJDd3Q3WkZG?=
 =?utf-8?B?VzM2WWxVbWwweVFMOHN5TzZnN1AwamQxa244N1RpOTk4ejI2WmhaU2tnRlU5?=
 =?utf-8?B?VFVDaWpqVzZtclA3Qkl6QWVBbFc4MFJLZUdrb0ZYeWlNNXN5TXlVdnlUc0pv?=
 =?utf-8?B?Sk0wejduekxZelBuR2lsSkczS3ZwOUorbFRPdFFST3FhR1FvMTZNTTZwMGd6?=
 =?utf-8?B?YytkcDN0a3V3SWFSZURLaXk4M3hnUGduVVRLWEsyOUZqenlmSERjc1hOVy9j?=
 =?utf-8?B?OGJWblI2eFhiL29udk5rbTYyUXhETjRwK2FxenVSMHUvR3k1SCtDelJJTkg2?=
 =?utf-8?Q?d+kTGiBjCgO7NtSE=3D?=
X-Exchange-RoutingPolicyChecked: hCWP0affKdQB1tJsGRMcVxjAGau4ysIe/3MIEQ6Xc0ybPCgmmK5EJkvBRHRoM1XlwK3dga49wylCH6TgE4BA4UR6WzJvt/XGMHBM5QMTLTsbIycdnv5W5MYZFqmUdMNkiLHFsieISXFceqjbMFSFmcngHYRrwakMz4WYq3Fhqy6cocdr5skRT204HS7mikgQfGwLkCKsZi5CNhyAymoMg3jYE9siPv93Lp1OyL4B+0YmZGm6gvMmWugEqwjldLWsf+jnjN2ZlOlIOKcyHWtWBOVDmKuDbYIPTnjxx6dIH/oaWKN0p5/uh0qHQot7q0mKY1zqhhYCBJ20Zfvycdpdjw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 188f252d-0806-4dbc-f9c9-08df1f138819
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2026 16:54:45.9455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Do60NDzgAZ2xXnaaACuUmlM0CU0VzuIfgl8i5E5FdBfm4N4NAYHjrAbQ7lyaKoKmt9DyANgq6bCTELWeGLdtI+4mr4kdQyEJdF+mYvZpVk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7365
X-OriginatorOrg: intel.com

Hi Tony,

On 9/29/26 10:18 AM, Tony Luck wrote:

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c22c3cf5167d..3555b0aa33ce 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c

...

> +/*
> + * Link: https://github.com/intel/Intel-PMT/blob/main/xml/DMR/OOBMSM/RMID-PERF/dmr_aggregator.xml
> + */
> +static struct event_group perf_0x1415910A = {
> +	.pfname		= "perf",
> +	.guid		= 0x1415910A,
> +	.num_rmid	= 256,
> +	.mmio_size	= XML_MMIO_SIZE(256, 4, 3),
> +	.num_events	= 4,
> +	.evts		= {
> +		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 0, 0),
> +		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 1, 0),
> +		EVT(PMT_EVENT_INST_RETIRED, 2, 0),
> +		EVT(PMT_EVENT_PCNT, 3, 0),
> +	}
> +};
> +
>  static struct event_group *known_event_groups[] = {
>  	&energy_0x26696143,
> +	&energy_0x47903099,
>  	&perf_0x26557651,
> +	&perf_0x1415910A,
>  };
>  

I asked our internal AI to take a look and it pointed out that this is
the first GUID with a character hex digit. Having the GUID be uppercase
makes diagnostics a bit harder because all messages print GUIDs with
lowercase:

	pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
		tr->guid);
	pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
		tr->size, e->guid, e->mmio_size);
	pr_info("No events enabled in %s %s:0x%x\n", r->name, e->pfname, e->guid);
	pr_info("%s %s:0x%x monitoring detected\n", r->name, e->pfname, e->guid);

Going from log message to source code is thus not "grep friendly". This is
a valid point.

With event_group name and its guid value switched to lower case
| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
