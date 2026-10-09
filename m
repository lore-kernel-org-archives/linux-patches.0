Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7FC3B9922
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 17:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791566123; cv=fail; b=DkgchUu7YEMKjdcju1T/uFpi8AYdXY3k8iD0mnaDhChlplBaW2k8gadba2yuVvicO+KUizqA1pstGUF1/sRjsKHm0mqZrF6oWKlIv75FDAR37xhqoevnEHW4PAgy63sZtPRl3VZ3aJ5VvtxWxSNsC6bItBqYW9JU5gMZIcwjeNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791566123; c=relaxed/simple;
	bh=MZWyHW+PlGdR2K4xg71TK0v7WG0P/6la98h+suXnnOA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=M4K9kyq6MWVhfDt0vumN4KMV4trzuoHXSqjGlxP+wtkBJLtrA7e7x7soAAhliAH/nakA0pnMsVrBZBDrp/sM7pcgrZ7aP5PUOcx8J0vvulZ8tlNMr+bBbmC3zB0huunSaDVeQe03KvKz3xdNDiguxTdxKeFY97EijL+NTCgcWxA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a9oeckTl; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a9oeckTl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791566122; x=1823102122;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MZWyHW+PlGdR2K4xg71TK0v7WG0P/6la98h+suXnnOA=;
  b=a9oeckTlj8i7+rteCXkjtlSNl+bkstLL41eB7PoejpRNsgYXFvPtxnL3
   Ai966yrQX7Q2wriQ80wNc9+UgFuuJXNn3VV1pvuAhCKVWB7O9JJHI0rn8
   N1HcTiteXFCboo5vWfFRjwT5DTvZDSn1JH62TtqRc6L3iU3qtQltJzdKD
   GAcgSKny6E+ezSisBlqJnsf1TfCbEikL417t5V+iEFhFtg8WphL5p4tda
   FNRQOozYYd4AT/84UahYsqV6b4qG1CKBiDvq6ar2zGwFzAFHq43Sr/9d+
   TWt3OFlYWOcek2ui+TX4idF64rVf/MP12yNrMXxDG+nvdXgsiMhxDb9/i
   w==;
X-CSE-ConnectionGUID: 5lAk37lER1O02Zyor7RPOQ==
X-CSE-MsgGUID: wstnxcavRlG+eT8xoLxvHg==
X-IronPort-AV: E=McAfee;i="6800,10657,11930"; a="466187"
X-IronPort-AV: E=Sophos;i="6.27,148,1787036400"; 
   d="scan'208";a="466187"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 10:15:22 -0700
X-CSE-ConnectionGUID: KJVm/LmTSMCTZ/P/DfY2VQ==
X-CSE-MsgGUID: ii755noETx2cajl3Kc+dlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,148,1787036400"; 
   d="scan'208";a="549142"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2026 10:15:21 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 10:15:20 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Fri, 9 Oct 2026 10:15:20 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.62) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Fri, 9 Oct 2026 10:15:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q/peLSoX3b3+E66guO2a+uf6QRMf1XugYZ5amdZh/O3XxI9RMY973ilTjDQcwapV8SEIbOH1yvEJ/fkG0FbItBAJXdmiZGybDsBzj589IapFW2L1IeuvTl81kkw+n6gP0QwsZBomfbxYwF928xa5luduNoOu6qseb2jNph+gyGFJ8SAqJ66dsaQ29tx0XfCDShbCwNXg5Q1ftcJlpAsMRNK0TRd/h6GT/XvE6XaGRLW5plnLhxEXQdu0I3aVUDrID0KhTQ4Y8j7rtQu3HP/yqTufWzplVs4F8UMMGXhvS/OLQsDIDmou3TNjJzzkf+aR/yj+Fj3CoBIpE3w8Kvyylw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x9CCNlwZzLQZgxQ7G5Fy4OBFAxLcqCo6QC1z43G0uZ0=;
 b=yKBiuvTiSlDLTb1V5YDO6o4ymsbLVsicrdaAov/7RLgiRpe1N6atcWsqi3ZYVrpDJW53giinmpX3808Gr74sTPNSOoGXuCqFww75/VUiJdxpTcK+cDuSg4p+mR2fMLb8OAvRqAZuOGc6sMchsVwrazf04IzkqlIjLYz1I68y8OOiQXX3c8G7IF26fndV8+gpafiEnnmZfUgC8mhByX3LrUQLS1ZlYK1kBONB+qwhmfhMpR940mcPOD5uHr4rE6uWpjBPRtKjpp4GK7k5Of6CjaxQ7rfmL/7GKMVCkJOEcLnET3uPrN62OF0kElr3cD2Cy4QFdsWZN09oo2fydMhB5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by IA3PR11MB9397.namprd11.prod.outlook.com (2603:10b6:208:573::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Fri, 9 Oct
 2026 17:15:18 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0496.010; Fri, 9 Oct 2026
 17:15:18 +0000
Message-ID: <b3ce4f0f-1c94-4c87-8afc-ee53826f2117@intel.com>
Date: Fri, 9 Oct 2026 10:15:14 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/25] x86/resctrl: Apply Intel MBM quirk from
 rdt_get_l3_mon_config()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260928221509.68002-1-tony.luck@intel.com>
 <20260928221509.68002-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260928221509.68002-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0059.namprd03.prod.outlook.com
 (2603:10b6:303:8e::34) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|IA3PR11MB9397:EE_
X-MS-Office365-Filtering-Correlation-Id: 24df3d24-3fc6-40c6-ab57-08df2628e45b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|1800799024|366016|22082099003|18002099003|10067099003|921020|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: wtnxUHNDXxnwbyZg7Nl6oXzpcCrS/rfrQBf3P0mFHZsYNayZFMhGBbpISfj6O/AlqoZyVUGk5rX25UXP7hWefrq6CPJNWce8WoUi5vwsym0PPhW1lcpPvb4kLSZrjmXNXu82a6q99oQknpJ8GwqN7BP04AxHsp1gxPQ6mdPjWEJGpbueb86MZO1gJbc49yD3KZUW0c+rCo5s6idJ4jx4oQBcDoUlOmyFCRpUf7e1gw2UUvOjINAucwVJaHOI9lUZqljgkJpwlfa3C0dbBwGHq0To95KLNXy+6FQh2Uw6ZygZKuuuG3/g6Yb64P8krbPc055/r19l3Pl8pf9YZseZJK0mRLkOj85qWpkL3rEAVqGDpWPTc2+48kuRdYuOtegNdFxsK5iTAXWg8+4vndLMygTyN07TXf61c6zxI9LZ8t/iZ5tzxOMVu6KbbgAGUyJ3ZMbgC8ZxBAfcyQCENLQurkrbGxf7b/gaDhLi90ZhoK/Tg9FZ9E44Ft/EPfcrTaQx2KvzaMUVVVnlOTtNeHYAKv6AFWsI6am7wkKhqDlKaWUyQRK7RXu6FSg/TQEw/JBCANUwHjjQG94Mov1y+ZF/QV8ADA+RR4tl+Y1nV9e1ctsNDesxhEjocLLQjfGq4wn7bPTdiN2jKRC8LjIydbCq7v6L8w7DAewASvLuhYsvJfo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(1800799024)(366016)(22082099003)(18002099003)(10067099003)(921020)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGk1T1VMeUVHelBmUFJLeGhFUFJtRlIxSld5SHE3ZHZNVjBENmFQZFAwbzVl?=
 =?utf-8?B?RDVzUGo0VXhnZFFIdVhYaStGUHZXVlNCVjBiT09XNkRXaFBGRjQzMEtnajNM?=
 =?utf-8?B?UVNPbHk5UmpwM05rRkVNZm13OGQ0b1hSaXJJbm1TUlMyU0pnMSszN2hFRlhZ?=
 =?utf-8?B?cmZRNThTSzkyS1VWdGlybzJVZ1JSMFkxR29jaXNTNGw3ekNOT2RFTTN1a0dr?=
 =?utf-8?B?d0hCbDJHSHcrNiszVi95emFheW45Ni9YbkxyREZoODhpemw3L2RyNitYcTVK?=
 =?utf-8?B?cURSa0ZuL1UxMjgrN3B2aFR3OVlJVVpnTE9DMjkvckpuOWNtc1RWeWVHSE54?=
 =?utf-8?B?cXN2TzZEakovK0JZU2NyeXIvNW5XNWduS3dwSG1uZ3QxTEFPRHFqOGNGbm9Z?=
 =?utf-8?B?Ry9nZ0p6ZU82U1JDY0cramNLazVoNDBab1k4SytZam5SdngzaUM3Ym1IMXBp?=
 =?utf-8?B?VHFWL2pmVXc3bGNjYmg2ZkRaMnpYaXRQNy9hRWUwOW4welU5eVFSZnNiN0JW?=
 =?utf-8?B?OTdXU2tvc1dvckVuRmhXMVR3M0xMb3J6U1RSUnF5Q3oxdU1JTlJWNVlhendY?=
 =?utf-8?B?ZFpSNGF5Z3l0SC9yTlB4MXZiRXN6ZXBndk4zUms3Sm5tV1plYmRMcjVTeXUv?=
 =?utf-8?B?dXJ5anRKYXZCWWE3YisrRnNWa3RoYzJacFVpTkloRm13eXkwZmF3L3V0TTVT?=
 =?utf-8?B?cVdlclZKZzArMU9OWmhUdktBSmtxeVB4R1FWVFhMZ2RyZWVtM29MMzcydWN5?=
 =?utf-8?B?UXlkNW9UNGhETEZyOXVqaEE5NWVqdGtNZTBqZEZzNTJJRFZpd24vcGRRbERH?=
 =?utf-8?B?cnczUjFXUlFySTJBWjI4RmcvTHB2eGEvM1U5UUZ2ZmYyTWEwU1FCSmxZalN1?=
 =?utf-8?B?ZEhKWDd3Zm90aUYyQktwTXNhTHFKUVNlRDZQMFVTemJiWTliQ0U3YXRjZDl2?=
 =?utf-8?B?b2t2ajJhQ3JyQzZnbjk2Znd5TklTS25GT0VLUUNwVXJWVFQyWnViVXZXTU8v?=
 =?utf-8?B?elMyTVlKN0x6RDloVjc3K1VCSHZLWFZxVmNHZ2tqRlhRUjk1Rk9iL3JqU3Jx?=
 =?utf-8?B?SWZSSnFXUnQ0NDhKYkE1NjlDMkcvN1VSdGp2WHJyTDVlSlhFKzBBM1drbVF6?=
 =?utf-8?B?WDV6Q0gxZVcrank2ZTQ0eFJ5SnJIdmxSaUZ3blREYW5vUlJPYkhHdkxmSTRs?=
 =?utf-8?B?a0Vzbm1HQ3BsSWdXc0RyMVJEekkvVWJXelNEam13ektscXo5TDI0M3E0SGo3?=
 =?utf-8?B?cGM4dVpKWmFqZTRHSkdUTlV0K0pKOVEyaG8veW1CSGVQTGh1eW5nLzM0dk4w?=
 =?utf-8?B?R0pCK1RkcW1Eb3ljTHV6SnFMaXAvTTA2TFk2eE9pc0RCWFNES0IwWWJhTFA4?=
 =?utf-8?B?ZzJBSzgveHlSWVVyQjRhc0J4TGpGQzUrKzJXUE8ydDJTZXlHWW5ZMFI1Vzlj?=
 =?utf-8?B?MThEdk5qajkwc0xUcWpaUnpVc25WVkRLcmw5cGNFNlF5MXgwaFRtZEZ1SSs3?=
 =?utf-8?B?TXRDTzVXUU9NeWF2RDRTM3VvQkw4SnA2b1dPTC81WTQ0b21FcnBCOVFpOGdH?=
 =?utf-8?B?M282UlMwNk1Ga2QxUFRBenA4b2lvcFFiOFVYTzRNb3ppcmtoZjVUUE1LVHpl?=
 =?utf-8?B?MDMveFdkMXEvSCtuN05uUjIrbnM1SUNSNHNHWWZ6dHl4TkNseThjRXZwQmR1?=
 =?utf-8?B?VzBRRDBWbG5pS2ZUb0NLWnorOVFHbmNmdWROKzdXYVFRM21WOUMrK2ltVFBM?=
 =?utf-8?B?NFV6VXJha2kwdHR6SXFlQ0Q0Y0I4S2tDK1ltdVNBWDVIOEgvbXVJYXplWXlH?=
 =?utf-8?B?RlhtZCtkN3VrV28ra2JJSHRJd0xIcTFEYTYwaTdwZk90Y3p1WXJmUUd4OGgx?=
 =?utf-8?B?cFVaRE1kK09GWTF0Sysxa3FKYmNTNUU4TXpHemFlZXAxazJrL2F1TkdjOUlo?=
 =?utf-8?B?Zmt3ZW5KTnB2UDRVRGNLRU1zMnlHdXFieEo5ZnlwUk5lamtYci9QVEZzT1lq?=
 =?utf-8?B?NWtTeGROaERjSHlybzFTakUzS1h4WFpzTWlpOXpveGtub3F6SThuVUFJYSs3?=
 =?utf-8?B?SlNiUmU2RVhMUUFHbU55bHRXWERiZjVEa3o1QkExaTVMZHVrS0lkSVZTeWIz?=
 =?utf-8?B?TExneUMrRGdhRmt2a2xyNHJpZmdUb1kxa3l6TU84enZub1R6eit6YjNlbW9k?=
 =?utf-8?B?d3ZNMzNWMlBQSStpN0pta2VYbnNQbDhwdVBFUVVnY2l6eC9tNFdDcmErcHZO?=
 =?utf-8?B?VGV4VE81L3FoUVl1MmtVRFNQcmE2TERaczlHOVRLQ1ZOUEVsNWFyQkZIbmxW?=
 =?utf-8?B?RWtpZmFnTUFhNTdxeUEzU0tXeGd2My8zUkxHRjAxb3JmMERDNk4zd29VVkJB?=
 =?utf-8?Q?bvRTcX/XnTCcjYII=3D?=
X-Exchange-RoutingPolicyChecked: jPf80MGdHXXeTe97MHlMdgh4WYehJkn9wZEq1w8RjpAUAtRPIECio5lz4BdCVCOlfeSnsfWtLgIHKJPrAZ4wxeiuaKrogscPIideLBcl+hc5mxEal2yWQ5SzkTobPePFXi9ILCgkpbm3NexbMWmmQlqOCzwMOn7l1MzODZBXhLhXcpNpzArFLBO4tlQ2UcBiDMc5EXRmPVdE8oPmX/YuSEePhk0GymYNMTqIjcH3FOjxCGkchVl68NS35fReAmeiXtmMdRH1Pu4fGKoSCen5jOox1dNEjkbypC2Oha6UdsplAMcDu2N/05aQo3PZfapa8VvBdw9m07KtS+fqZSXcPQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 24df3d24-3fc6-40c6-ab57-08df2628e45b
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2026 17:15:18.3829
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kQCvNTITdZMWqGsdo4hMFsxaWoc3J8tXVTnCmniHkduufScWF36UlvhffVQAJGOT2bPpGBJ5cTXdQndHtO5HASd7RpX72d1Se9y3PjHPIx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9397
X-OriginatorOrg: intel.com

Hi Tony,

On 9/28/26 3:14 PM, Tony Luck wrote:
> The Intel quirk to adjust Memory Bandwidth Monitoring (MBM) values on
> certain CPUs is applied early, before discovering if MBM is supported.
> 
> Move the call into rdt_get_l3_mon_config(), but keep the decision on
> whether it is needed in __check_quirks_intel() with all the other
> model specific tests.

https://lore.kernel.org/lkml/7aaf83b3-03ea-47bf-809b-561beb6b3843@intel.com/

Stopping review here, since feedback has been ignored. There is no reason to
proceed.

Reinette
