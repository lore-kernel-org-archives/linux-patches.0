Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7009E38D011
	for <patches@lists.linux.dev>; Mon,  4 May 2026 22:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777935451; cv=fail; b=EUlpE1sbend49oCW+OfXXQVWr8/Kw/6EiGZ2J6PcE51T1zUEIZOl6yU+hqaYHljrOeukZD2XZ4uFq5fA3P/JSYFmkM2v0a5QZHi37ivZF4k/v8ne7M+NrN3+A6YP5xNukROhVGBRLzdMy7b65e6xy9g5ayEm+0+ek+wgOjH5xSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777935451; c=relaxed/simple;
	bh=Pq+50C11YxXdxNZRE+BfEBc64jmKSfU2s8yZznhYR2Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tIn1iLaJg/R+hRWsTAglcFuIofAQwVT54XqFDTIhWmrgv1NL591feML/0OYV24lI24GBtaFDxqvD7QIPhCRAlEiwMnfB3B/QWUBL6qHrktWNUIwMxSqSMVI3rmlon2UfrCReHbhl4ER7q/4G5zv7cY/uzTFRNWmpJZ/mBg1qfhg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EuqTGJKP; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EuqTGJKP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777935450; x=1809471450;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pq+50C11YxXdxNZRE+BfEBc64jmKSfU2s8yZznhYR2Q=;
  b=EuqTGJKP1ihRwmCRh4AjsH3HSalcZhxbeF4SLVnCh3z/2WZW8j6uwtNT
   WfcISLLViWuOu6AJVYSf908/V3N7PBw/dDg3qu5WdO8rLD5ciz2GEZUHZ
   9rf7OIeqQk9Fc6yknktr8mwKZ6t8507cWIzXs/fq/2Qjq4A/DS86XR2Vl
   /zk2CbApixp3hFeoOz4vh8PDG1zhPtuy/e4SF1qdNMItwXMPSKSD/6oLN
   bIqxPbcHbBzjY/y1n0yy9Y9wR1fivE/2COtdSGS5X0U6uT86tlmUw2Gqc
   ciHKLa+tqLsmVQYYGtMFQHo3Jn5k9JS1Gmfp1uWpKktQRhWPACerNGSd9
   A==;
X-CSE-ConnectionGUID: 8nVPtIA8TMi2VrqbAanzlA==
X-CSE-MsgGUID: X+alwZiLTYyYeAErL5I7dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="82668753"
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="82668753"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:57:29 -0700
X-CSE-ConnectionGUID: vIJ/x7SRTdW1Uo4sEP0jjw==
X-CSE-MsgGUID: c99PxLDzRCmxROK3IcqH5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,216,1770624000"; 
   d="scan'208";a="234771942"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 15:57:29 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 15:57:28 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 15:57:28 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.0) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 15:57:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z9Aw1bIerlkdTkj937qqwGbjv8q0zjIvNVZRwn4FKXffpW7tVV/W9SmBExLWpziFDHY4RlvVW/b3OnNUQkEIIuz8Ot0DpOdJGPbEe9ERfh2kFWQLaC9BIj3i6r2+mo/I1VhGlpvfEqdwWy15suJh4dBW8t1Egb7VGHLm8Y5OpSKcVaHQ4hERCb/nUKkusLKH5IvDpOFqj+XiX0os7pNaNOpeAGXp6I1l7rfiChpXm//nsl73V4/AyfbP6KKZleQt5mmnp911ruCrE2W/HJzhsmmITyIuOks0FjngBbinRVFaJ8tLzBVGxIEBidqGo3mwNmdWiSVCdGb8/8LV3EbCVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=69XMgtu7yUmsQWxRhEg882URhn/8aHJHwJYOLejpbl0=;
 b=oW2BvTaJSFSaxGPp/INqXsyJu4SOY1v41nFsLLNgnmDf0Ewzdb/W/M2rx38y+NMyVEidVMDtKO6fGSD6gbUNPLzjeMplywn91O+MT//18VvPJMuq6SHR7K0XW2BnrJ7SHmm6OIKDmQbpeBzu4Do+6UBacjcEYlt/yF9o3UNXIcTZKiY96V/JaB3cj3AMteZjcp6aNFCi/EnaVPnB2+AQnE0dzFE8WmteKKIC5ghZqr+9P+xqN2RnQf3q0QiO8L6hYrjpf+AjlOS9pIhg6ep0lfUOqiNlCpKVX6WjJFfoMsZJm4WDOanZ8/QCj2OunIf/5IyYFYlj/d68tmqUTlYi+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 22:57:24 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 22:57:24 +0000
Message-ID: <2598acd3-542f-4c90-b46d-dc64c6cdc700@intel.com>
Date: Mon, 4 May 2026 15:57:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/10] selftests/resctrl: Fixes and improvements
 focused on Intel platforms
To: <shuah@kernel.org>, <Dave.Martin@arm.com>, <james.morse@arm.com>,
	<tony.luck@intel.com>, <babu.moger@amd.com>, <ilpo.jarvinen@linux.intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
CC: <fenghuay@nvidia.com>, <peternewman@google.com>, <zide.chen@intel.com>,
	<dapeng1.mi@linux.intel.com>, <ben.horgan@arm.com>, <yu.c.chen@intel.com>,
	<jason.zeng@intel.com>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1775266384.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <cover.1775266384.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:303:2b::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN0PR11MB6088:EE_
X-MS-Office365-Filtering-Correlation-Id: 72df4500-2a31-4564-2f47-08deaa30819e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|18002099003|56012099003|13003099007;
X-Microsoft-Antispam-Message-Info: hSu4ugLHzQo3XhMtn4MAhIG14YMvm5ncVjv+M6JfVQdgnvIeEiemM9hYtBaQTeTpXMXu54DoikKvWOZmTBccpAsybuTM4E2iynAbqMfr8DtH/ppV3ZLAHbh0cIwUSr4ZEaREPigPmUqP6SHhwx0QM6DRCqcpJiHIFUr8rTsHi3j/r5Gvq3jvE1nrh8ft5DHWHvNBC3ArYN/Ox+pPqodx+hlzD5eocz7+nVLAXA9DgzZl7bINSiRoms1CsFOoW64sNASkM+CwqQIZ1pHv8nEuF9bJzRYeS0qX8amwNShjMAMxWqiqilbWkctR+5LesWFjpsdGpvFNntm6al3g5PbmJkEJQMIgYhF7DpsRt842GPQ9J2MLPQ2QgJ3w7I/OI4xggTyBgn7vCaY4aptxwRD8w4N1KFR82vT0qRWD47Y+nDjo9kvIpvvyqNMjt5vgrKKX7Ik2h7li/0GgkDTru7w1VQZUsAAqyYgW9jr23Zga2/mEcXln5G50J8M6+MAb3cfxpvX3qijNzrdbBLW1SkS8FXSzNVVIV9l1PbLSIp2xiXEVegNcJ8afksRXg2d1vVJwl+EfBtGRZIVrxlOdQ1EDlPBCnrB1XcpUDsTT7hjB95yYigQ0ce4rr+tvVuYmeb6EMHTfHC9bToc4c6niq04P8tGBjIKTRO2VlNPyxiy+ibW2ejRze8Uvcq3CzqUQxF9IaoyShf1at70fwcZvaEjazA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(18002099003)(56012099003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkdkempWSWo2dFJIVUZxNGxBY1hPcWFNVGFBY1JlbzU2NzJIMDVPVHZlUG1R?=
 =?utf-8?B?SExJR2dSUHFzZ1k5Z2paL0x2U2k2U3Nkc1lubTlZbmtSNXVDRnFROHRnVmFr?=
 =?utf-8?B?MnREYkhLMFlCdzY1eERXNVF2M29ySTNvYjVjdGk4NVBGRnIxTmEzSk1TeE9v?=
 =?utf-8?B?anFJQ2psTDliNFoyU1dtVjZiWVU1ZmNxTkRRZFhyU0ZUTC9UVnJWZEVsNXhV?=
 =?utf-8?B?NVRYRHQ3RURJM1BTVkd3SzVBY1ZiT3JYbUgrZ1h5dkxKVnFNM29zc1VraEww?=
 =?utf-8?B?VndGcDl6RUxzTWdSanhpenc0eFNZQjJLTHFtVExxd0E3eUlHUForOVV4dWJ6?=
 =?utf-8?B?T25JanFSbXdmRUlYbXdFODNGVkVXOXJ3MVo0Qk00NmRXckdrdGF2cjlaSHlp?=
 =?utf-8?B?S010WXRXOGpPV2Zxdzl4TGxUN09PZTY4UElDY2k3Wk5OdHBYdGRUbjNwc2Rn?=
 =?utf-8?B?ZUJGc0VqdHFQaSt3NXhnZlIwdjVlaGxDU0pGZDkzSU5JS1dqTHBPRDk1Q3pL?=
 =?utf-8?B?c1pLTUtBM1NLMU1ld2pkbC9VcGl0dUkxWThXNi80dndmUVJld3VIdzRxUlpq?=
 =?utf-8?B?UXJCazBydHFudGVTTE1sV1FScVVCWC9mOHR2ZWQ0WXhNY2xkOTBLZDg4T1pU?=
 =?utf-8?B?ODJwTGlpS2tzSDZqQXFadVpSZDVQTkRRbW9DdFRIdnJhVmo4aHpyTWxRRTNT?=
 =?utf-8?B?bXE5dlZRcDVYN3NWek5mOU1YRHJxOURlQjltQ0hmR1hhbnUrTXArbFVDaEpD?=
 =?utf-8?B?VngzTVhLWk5LNGp4SXpVK2YzNEtKdW9IZ0hLWlBveFBHYS9haVp3U3lmOTdn?=
 =?utf-8?B?eDF5Tm9xalE3V2R0Mlo1UDlxdTh6elkzb3orazNaVU5nZHliTHpqZlBPNnlo?=
 =?utf-8?B?Y2xZcStQR1piUy8rdGhCcSt5NmtZRXM5cVY0eW9aUWRhRGZoVU9RQjJocm5U?=
 =?utf-8?B?d3o0WndyR29xTU5SbkxYdXhIWndzeDdsMXRJckkxejlvc2YxSzgyOUQ4elR4?=
 =?utf-8?B?ckg1T1hhcHBldzRoVC9ScS9qRFVHa3pjbzhROERkbXkyK1JMWlE0N1Y4K0g0?=
 =?utf-8?B?ZkJyQU83d3hlcncrWlRobytxQXU1clc3YjhxWjNQMUIwWG9HbWN0SlhSRnNu?=
 =?utf-8?B?VzkxWENIdXdvYjVaTHRCNktkSjQvdFpINGluZWZKM3hUS0NZNVIxbGo4YkxM?=
 =?utf-8?B?MEZ5bGM0REdhOWZ1NWF4RjhURkE0WllkWmtZbk1zUzlJcU92ZnloTkozby9t?=
 =?utf-8?B?NS84Rk01K01ZK2NtVWlsdGdVelIyV1h3UWtSZFJ1ZFBaT05uZ2NWM2M5VExa?=
 =?utf-8?B?cjVPS1JybmFzVUNnVFZhblliQkJPTmMwcmVjQkZPNkZMQUl4UnpIVllhVVhu?=
 =?utf-8?B?L3gzOUgyRVYwVElmWUdoT0plRldkVnJlaWRJOFYvZ2dGV1FPRlRKSU9WSDlo?=
 =?utf-8?B?S01HWWszNTBFZU4yT253TTVUSXUrc3RkRW1vSytrWmpaWXRXMzBzek1kQ2FO?=
 =?utf-8?B?aHJiRmRQbEQ2WURrakJ2ck16cGpJVDVlczRULzM2dTMyNGx4WmlXWWNUK1FT?=
 =?utf-8?B?dkM2QnhIbmhVUkd1R0lsZjJLY3pra0FxU3hvRXdKcWNVNXFKNmlWN1czcCtm?=
 =?utf-8?B?amtTZWc1djZiTTBad2VHRUlqdjZHRW9nTFRZSTYyWjA1ekVpZlQ4WHlOajFZ?=
 =?utf-8?B?YjVWWXZVMXNQUFpvL04zQ0FyVzd1RDdtWmplQ0JPRUdVL2lQODdJT2xrVkZu?=
 =?utf-8?B?czF0T1dHcW5OcFRGOWFDbWVEampuc0NtRlk4Vm5kNngzVTBLbG5CYlFqa1gw?=
 =?utf-8?B?QlVYTjJmSnB5RVpRU2dLN1g2Yzkzem84UUhGOTNuQzI3TlZheUIrdVhUUVpT?=
 =?utf-8?B?MlV4ZVlKVVUvWDRxSk5OQmFWTldYUDBCekprQ1A3UU5DS1ZUR2l0OHc3Ykh4?=
 =?utf-8?B?NjVlS25yNU8vSThKNFFWK3lOcGlMRXAzUVpBRktFd2s4Y3BsdkxMVGVKTWhF?=
 =?utf-8?B?NWthNWZEeEU5L2pyOVAvQ2dqN2NiRVhSNlpYZG1RM2p2OGI1dGFNVmc0U2FT?=
 =?utf-8?B?LzMyNENEbDZHNHVhYWJaNkgrb1VvZi80UG9rdHhZV08xWlB0ZUljLzNqNCs5?=
 =?utf-8?B?RDh6czQ1bnRYNEVZM3hlczJ5cVhQT3RhbGt2YTBMbHFOOWw5U3JQc0JJMnBv?=
 =?utf-8?B?MjE5Y01FTENzRDZqdEtRT0JCZzdkWXdoQWNZZ0lmeTFVNVJzVVA2amFHc2sx?=
 =?utf-8?B?blVJalF3alBXOVZQbCt2YUZhMXRvNzNHcHRhN0g5UGtHOWNBS2NJQ1dESW9R?=
 =?utf-8?B?aWh5UEIyNUZRa2QzekNwWkZXdC9sSFdmeG53b2hCUndjR2lESXZOTHkyNTVD?=
 =?utf-8?Q?VsGDd1DY/v5MuKSg=3D?=
X-Exchange-RoutingPolicyChecked: qTuFVeWTezvZqNWDGKkL6j3KVKsNfWJedyoLEbfmzYQxY05GtC4+j79n4O64FRc+/5JTs5m93BOxh8Lm/nKVQ7s6Bfdqm4/b+lkFrc1v5riTFriRMfE1hFHKdnfoyU+aGpb4sW4wAFRpFhjkuVannZO7/MBhTx8Bwq9ZrtThhc3n3HKQa+Mdx3t/QZqlBK/ayYNXModal0ctQdVe5EryUoGqNdPNkNiNF4WOyhVIZEDDBAGvPr6vNSXjz+7hxcfCfk/JGwpxODVkhHes7XgQGzlC4tv+2l8SxnVy1KifX7E2ischiXxZnOarnmmmDKjwFnmjdJN76xkGxt2eaEaAVQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 72df4500-2a31-4564-2f47-08deaa30819e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 22:57:24.4560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yR+PWMfbbm/bS0XVBohhMh3AsXXUosozhPq+iimvAJMzGik1DDeeVOGB2/UzZXunOrLnNabm+aD56DvE8ptifmeS6Wg4fJMMCpvlLhEtfH0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

Hi Shuah,

I confirmed that this series continues to apply cleanly to current HEAD [1] of the
kselftest repo's "next" branch.
Could you please consider this series for inclusion?

Thank you very much

Reinette

[1] commit bb86954a672e ("docs: kselftest: Document the FORCE_TARGETS build variable")

On 4/3/26 6:55 PM, Reinette Chatre wrote:
> Hi Shuah,
> 
> Could you please consider this series for inclusion?
> 
> No problem if you already took v3. There have been no functional changes since v3.
> 
> Thank you very much,
> 
> Reinette
> 
> Changes since v3:
> - v3: https://lore.kernel.org/lkml/cover.1773432891.git.reinette.chatre@intel.com/
> - No functional changes.
> - Start sentence in changelog using upper case. (Ilpo)
> - Add Reviewed-by tags.
> 
> Changes since v2:
> - v2: https://lore.kernel.org/linux-patches/cover.1772582958.git.reinette.chatre@intel.com/
> - Rebased on top of v7.0-rc3.
> - Split "selftests/resctrl: Improve accuracy of cache occupancy test" into
>   changes impacting L3 and L2 respectively. (Ilpo)
> - "long_mask" -> "full_mask", "return_value" -> "measurement", "org_count"
>   -> "orig_count". (Ilpo)
> - Use PATH_MAX where appropriate. (Ilpo)
> - Handle errors first to reduce indentation. (Ilpo)
> - Detailed changes in changelogs.
> - No functional changes since v2. Series tested by running 20 iterations of all
>   tests on Emerald Rapids, Granite Rapids, Sapphire Rapids, Ice Lake, Sierra
>   Forest, and Broadwell.
> 
> Changes since v1:
> - v1: https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
> - The new perf interface that resctrl selftests can utilize has been accepted and
>   merged into v7.0-rc2. This series can thus now be considered for inclusion.
>   For reference,
>   commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
>   The resctrl selftest changes making use of the new perf interface are backward
>   compatible. The selftests do not require a v7.0-rc2 kernel to run but the
>   tests can only pass on recent Intel platforms running v7.0-rc2 or later.
> - Combine the two outstanding resctrl selftest submissions into one series
>   for easier tracking:
>   https://lore.kernel.org/lkml/084e82b5c29d75f16f24af8768d50d39ba0118a5.1769101788.git.reinette.chatre@intel.com/
>   https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
> - Fix typo in changelog of "selftests/resctrl: Improve accuracy of cache
>   occupancy test": "the data my be in L2" -> "the data may be in L2"
> - Add Zide Chen's RB tags.
> 
> Cover letter updated to be accurate wrt perf changes:
> 
> The resctrl selftests fail on recent Intel platforms. Intermittent failures
> in the CAT test and permanent failures of MBM and MBA tests on new platforms
> like Sierra Forest and Granite Rapids.
> 
> The MBM and MBA resctrl selftests both generate memory traffic and compare the
> memory bandwidth measurements between the iMC PMUs and MBM to determine pass or
> fail. Both these tests are failing on recent platforms like Sierra Forest and
> Granite Rapids that have two events that need to be read and combined
> for a total memory bandwidth count instead of the single event available on
> earlier platforms.
> 
> resctrl selftests prefer to obtain event details via sysfs instead of adding
> model specific details on which events to read. Enhancements to perf to expose
> the new event details are available since:
>  commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
> This series demonstrates use of the new sysfs interface to perf
> to obtain accurate iMC read memory bandwidth measurements.
> 
> An additional issue with all the tests is that these selftests are part
> performance tests and determine pass/fail on performance heuristics selected
> after running the tests on a variety of platforms. When new platforms
> arrive the previous heuristics may cause the tests to fail. These failures are
> not because of an issue with the resctrl subsystem the tests intend to test
> but because of the architectural changes in the new platforms.
> 
> Adapt the resctrl tests to not be as sensitive to architectural changes
> while adjusting the remaining heuristics to ensure tests pass on a variety
> of platforms. More details in individual patches.
> 
> Tested by running 100 iterations of all tests on Emerald Rapids, Granite
> Rapids, Sapphire Rapids, Ice Lake, Sierra Forest, and Broadwell.
> 
> Reinette Chatre (10):
>   selftests/resctrl: Improve accuracy of cache occupancy test
>   selftests/resctrl: Reduce interference from L2 occupancy during cache
>     occupancy test
>   selftests/resctrl: Do not store iMC counter value in counter config
>     structure
>   selftests/resctrl: Prepare for parsing multiple events per iMC
>   selftests/resctrl: Support multiple events associated with iMC
>   selftests/resctrl: Increase size of buffer used in MBM and MBA tests
>   selftests/resctrl: Raise threshold at which MBM and PMU values are
>     compared
>   selftests/resctrl: Remove requirement on cache miss rate
>   selftests/resctrl: Simplify perf usage in CAT test
>   selftests/resctrl: Reduce L2 impact on CAT test
> 
>  tools/testing/selftests/resctrl/cache.c       |  30 ++--
>  tools/testing/selftests/resctrl/cat_test.c    |  41 ++----
>  tools/testing/selftests/resctrl/cmt_test.c    |  36 ++++-
>  tools/testing/selftests/resctrl/fill_buf.c    |   4 +-
>  tools/testing/selftests/resctrl/mba_test.c    |   6 +-
>  tools/testing/selftests/resctrl/mbm_test.c    |   6 +-
>  tools/testing/selftests/resctrl/resctrl.h     |  20 ++-
>  tools/testing/selftests/resctrl/resctrl_val.c | 135 +++++++++++++-----
>  8 files changed, 179 insertions(+), 99 deletions(-)
> 

