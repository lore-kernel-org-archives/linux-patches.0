Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27E114DA528
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 20:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790282810; cv=fail; b=W3ouVnJziplpomC/xaUEX7hzxz9bmqxagwc6Se8fz72RRACvhiY5DWfkkUHybuHrxXwjMSrDYO4Dds52E2U9004HEEWkwRma9HuyzzMpsX9ECgCGNw4NvMIaFszeSDIhv+FGDV7rfBIMxWH+3riaW6fPz9kIUYDJwX5tnfCR6J0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790282810; c=relaxed/simple;
	bh=0Bx8ZVgg85r+4DoGCiHUl3Jit/QIcy3r0P0v1jy9xhc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l5S3a5x3d7KpY4hLApspj38k+6gtf5v8kSElHzPIuHw2eRDtWntPq6LP8UdO1jeONr6yyfI+nNe3QhCMkm3lLdDbhu3jOcpsKplkNfqaTEvYy0wZ3FPj9s3RNTTMbyqPgpYeJLPPDu66Jj9ch9V+hgS56SghpsvmHkv25proJJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C2bjP5Ld; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C2bjP5Ld"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790282808; x=1821818808;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0Bx8ZVgg85r+4DoGCiHUl3Jit/QIcy3r0P0v1jy9xhc=;
  b=C2bjP5LdAcMsEg5j41zpNKkjpWedJNYHw5sf2rO1giccp/tQJ/Ke/Y3e
   D2oztjZpY2x0LVAyYTDCy8S0AimP80kIhUEl+I59XP+ISOXgbzlfutBqG
   YrRT6rM5rs+NmKbZbQX1xEiklINy9WpufYZyQPgU3JEHyK7XlE5Fj1h+H
   WHTwCg4Op43dTOypaG3iqjQTCr3+x7p7r4P7DPd35CX3xBlRyrPAGkoHT
   ap4R7lRHrR6dn+KPaJG06ynjNvuBpRSb02jpqRY9AaA4+WjrYySnArscw
   ORIyiuLt9b2kHR+fUZV9NJZBU9VJ3JJERRcuONiOF/I+yC0rqOCm7jUNP
   Q==;
X-CSE-ConnectionGUID: CpavWlklRCSm70x5BI3roA==
X-CSE-MsgGUID: Guhcs+04Tteg7TQGlFOA/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="101245474"
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="101245474"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:46:47 -0700
X-CSE-ConnectionGUID: ukle9bkFQva5gIHTQQM25w==
X-CSE-MsgGUID: ZW99a6s0S1CZ6y9xrFSJ9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,121,1787036400"; 
   d="scan'208";a="300422308"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 13:46:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:46:47 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 13:46:47 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.31) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 13:46:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UewuSoH2WK0gdp4nYmWlM4MI5cen2yb3uqA/q5kl0LGI0TKkEZXUJMdhTVF3A7GUq5a5624ytYX+Xtaiy7h6zrzG7b55KTyCTG5/dGuQ0G0bKcVJC78ASWLUt0M3776wMTnjdqziA7PLJTGh1jMlhMNDdY4GKNFFaFJcN1G3nD/hDXPo75JqrfYbE2fpTR9c/Y+vXNOhMuvHuF8VCjNMh7w+EygDsaYbNGCzC8lLPqa0WubOvxzBeeHJIwYioe9DId8KrD/flH70BD5uV5lVt9pUQfgLUkhCimYpwATwuIP7I1dGSjAJ7UvwOnCR0XMHbBhnhr0j+gKIC9s6UYLo1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cC9jxL0xNMI9XnJDtszavMldOjzQjVRElEw5W9qBQU8=;
 b=t1+eI7a0FaYT3XGpi3rSHBF85LjRMUvpEOMTlSMh/r4hce5vdXZkOHZJXWwuvOn8HpGy1TChRg8p8el5LWT0flQcz9dOObyjGjTyEHRXOX1zSvUHWzTfDGkwKTaRNtv43VP6s0pzIfh01r/2pJwLl8mVcfHbxpV2mSBvY1XheZ09KH5aHBw60ZExUeDBUk8IaDC5ECkv11vLik0d6OmRIdg6/5rnDwTTF/WI8/jiYp+kpELDdTxCM4Pnblabbgi70+LwQ4+XbOuCC/qL8oxc7dQBZPfH3f32Oi9v0RSUWWaNfwvWGPMriVu0HBCRekK038IPJGuAENNWIxSuFOUc7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CY8PR11MB6820.namprd11.prod.outlook.com (2603:10b6:930:60::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Thu, 24 Sep
 2026 20:46:43 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 20:46:42 +0000
Message-ID: <78e29683-fac3-4ac2-bf9a-7dac9eaf9fd5@intel.com>
Date: Thu, 24 Sep 2026 13:46:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 17/25] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260916231320.14502-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0221.namprd03.prod.outlook.com
 (2603:10b6:303:b9::16) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CY8PR11MB6820:EE_
X-MS-Office365-Filtering-Correlation-Id: 65a47d91-15db-461d-744a-08df1a7cf047
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|921020|6133799003|10067099003|22082099003|56012099006|4143699003|11063799006|18002099003;
X-Microsoft-Antispam-Message-Info: RK9PIoarwx03vjnjx9QAEBShvqKSf1fhqsfl5qu1TpYf8Ar8mtryIvrHgx8hrKxMhx813w8tZUV4IajfaF3FH88SQV4iCgr1p2/NjMVO7vK7N24kNziYl9tgXIbRETnR5FGF5146fHdMXB11Nnsm0OkDJaonqmNxxU1tFX5m+ccA4SMqdTA5gAJve2X3JjtkIeq2A0U6uI/jlSqZtdi7ph32Od8ZWfIsC3opTeQ/HxZnGRFiuwlR08xbLDNYSMrAplBaBZXMi+BVEm52ztPc2PGZABhsg4bpYOUH6n3kNmh1FfoTuAKwR5xLXvwaXX1qivoEAab8uXGd8InA4u9NORjllRBy7EivSK08oRBxXvnoWt2Y8AM0ljvX9GQSqFy8HoyNfhfXSb2UKUh4ASaHJAO7jj4HYNxQ2tsxjzbFp28qO3vp5dl6XM1e9j1AoeDUeB/z9CNr12Cx42FLV/ScUqdhDssggP8nTkD2wTQpAB33HpJfc/ovSWNItXurKrhI6BsdGdmQ/iUliwTelQXb7FOUFEBQI/cYjomLayznmsnG3Lzu/q6i88HC4C+9rbBZ7vgAk0MXKmH1N/JRLfe411Zwh6BWpb3blZXjHVmctkxQ3d6cDFJw6VKH24WbHrvD2LPrjt9PK9Rd5XXrtQwO0jmT8LRu1giWc2yg5BK6yZxSkhF69nyPoIddxOXNLN0jhYNODkd2k1Sqa5xMypgRIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(921020)(6133799003)(10067099003)(22082099003)(56012099006)(4143699003)(11063799006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K0JWZmU1cDJ6REJ4WXhFQXJQNUZtRStIZ2hpN1MwVU0wbXBoTm5Fbi95SHZ6?=
 =?utf-8?B?QytydUkwV3AwUXlYOUo4ejRkV1lpYXV0R2xLNVhRRnByemNhN2pyaXZsTURF?=
 =?utf-8?B?Um1KdEJpcEFFMFZ4RWRoSWpwZ0xvcWZ6UTg2WWFlYkc4cVQ2dnlPaHpBNHdT?=
 =?utf-8?B?QXJLNUg4ZHdIUUVjajFDOFBVVlhsS0xnc21CZWthckdxQ3dmK1lGWkp5cUlZ?=
 =?utf-8?B?cTdUalBqcFpoVjRXOURxZlArY3o5b1RMVG9BcWhhbXRNdTRyZW1ZRHFLRDNu?=
 =?utf-8?B?a2gxZHZLd3dBZk5rblIvdkI5Zm1kcXdUYlVQeHR3VS9DUk5hdHQrRGs3RVRD?=
 =?utf-8?B?OCtmZFN2L21PeW85elRtczNxOUdPNk5pRXB0NGc0RWoxOUZNekNoYnQ3dEJF?=
 =?utf-8?B?R04xRlNHSEdaOW15Tm9Rcm8yQTc4UVFtRGdKWWNwM0VRWVJQNCtoMFNCb2Jr?=
 =?utf-8?B?cnp2Q3NLS0h5ZTVRU0x5cFFSM2RxR0x4dDFuMmVYdWUwN1FidGhFOWczOFBX?=
 =?utf-8?B?M3dSeSs4QUl5ZTJvRS9VOStMMkVhM0wrQzFQZVdyczU4RElXTjZhOXZpSXBT?=
 =?utf-8?B?Zk9sZnVJeG9nTkRxS3JOMlVYOEh1aWUxZWRxa0k0eHIvWE9XZHpFQ1NER0R6?=
 =?utf-8?B?SVpNeWZWSmRzSTJXMmpZblZ0c2QyK1M4L2Z4cmxhdGVKWW5GQlJVei9ZcWNj?=
 =?utf-8?B?WGw5N0p6STF5aXNqbHhyUjAwbCs1b2dWWnlzWkFqbktNSUlQb0U1VTJBc2JQ?=
 =?utf-8?B?MkxwcTF6bFNvUGVBcHI2NmhtaXRUZHZIV0w1cjhzTDJ0Mm1zVTZpcVpLVmVI?=
 =?utf-8?B?cWMyL05qMVBRc2tlYlNoNDlWSitLS3pLc2c2UTA1eVlTVUVsTXVCNWNNajB3?=
 =?utf-8?B?bkdta3YyYmNINHAxem1mcGxLUEk2RnBTTVlRMkplSXVzbzA1ZzdyQkFBanM3?=
 =?utf-8?B?TG9wZExOY25zelFzUnhwQ25HdDFHVzRJbWNsOWZ5L3BSaTVjQnIxclMzMlFV?=
 =?utf-8?B?LzVmeGpvR0NGcFA0RzJCRlJybGhDK0ljWFlWSUVqc1hDYnNMSkEzTEcvbG9H?=
 =?utf-8?B?ckZpNy9JbFkzd011QlhDc05McXBLMkFLOXh4VUplWGoxTkt6UDV5c1V5eTVi?=
 =?utf-8?B?T0xjWmdCdHVQRFpUVlBHWG01MGRoODVuYU9IYjJlWjJ3QnladXJGNWlvdkpZ?=
 =?utf-8?B?ZDRkRlhQWHJKa3JMSGJxYTdRMVdwZzY1UEd3R241UlozYjRnSVl5RmhHa3hQ?=
 =?utf-8?B?bWJJMXYrQ0Z3WTl4MHRXak5RVUJENHVtbFYrbEJNd0FPQXhGb0JQZS9iRklX?=
 =?utf-8?B?V2FMbTlqVEVMMXJpKzRzOGZscjMrTVh1UmhuQzI2eFNwWWx2RHFsc3U4b3NS?=
 =?utf-8?B?MGFyeHBzSmxaL3pzbUNneFRBRTAvZnJnUStIQ09HczIwdHdKWUpITjZRZElV?=
 =?utf-8?B?Z1RpN0c5SG1XNUpBM3FySGJULzEyM3o0TmR2SGxBZWJXbGhVYmViRWRycEti?=
 =?utf-8?B?TUhXRUtjNWd2QkRoUGwzYnpUSWF0QUtiZFVsNUUwN1NPSUVMQ1JsYS82TThJ?=
 =?utf-8?B?VW1FWTFMbkRvU0lCb2k3aWVuTEhRbkpCei8zZHZrQkJMRlNIcTdYM0k3ZVRM?=
 =?utf-8?B?VjBmamtqaXljamhGK2c3Mk1wUmI2NG1YQnZkemkvbVF2RXhaaEpDVTNuRVFk?=
 =?utf-8?B?bDBYLzFNVC9ISUdHTk5NOTd3dm1pZ2dRY1llUHk1aDNIdEFacGpsWmJSbDFj?=
 =?utf-8?B?b0dRU2sxM0h4anJQSVZwSWVUbnRTeUZFSkRUQnZHRk9mM2REVWlORU1MckZH?=
 =?utf-8?B?UFZHc3g1YXloSDZURHV5VU81MkhUaUJFcW8wWVZTUjd3S2V1SkxLQW91Uytk?=
 =?utf-8?B?UEdRUUdSK2p0OWlYc292WlpaaGFQTHdPSmJRZnhxNkU1c2ZoNFd3SCtoL3p3?=
 =?utf-8?B?Z1VNMUFWZjZEeVd1QnV4TkU2WHJiWmM2Wm13bEFLMldvWDF0aVhIZW05eUZh?=
 =?utf-8?B?UllCYmNLTm5mUFgzeDRXMm11SXlHUHc5RzJuWm56Q09hQmxUaWptWUZLNStr?=
 =?utf-8?B?VU9TSlJFOVNvbTNPNFA1RVViYWtPR3ZaZ1BhSkVJNGRBbGM2K3NFUE5oTGps?=
 =?utf-8?B?bWtBdkUxMHhJZktmUlRRZngvS0VkcFU3bHZRcm91YW0zdDNNUldBS29hb1Zx?=
 =?utf-8?B?NldqbGNwOW4zZVpITzZkWVBWQmpUalBUdGJmZUZZTlZnQ0FHSlZQZTFXc2RD?=
 =?utf-8?B?YXByZzhURW4zUEhaSHhML2ozNlJqUTNNMlhDT3JoMGs4MkJHWnNsWkd5ZlUv?=
 =?utf-8?B?a1VqbDJ3R3p1MzNsbk1uSlcxR2ZDbE1oUFB5RzdGTFJpYnA0WStsWlN4MFhn?=
 =?utf-8?Q?WcfxFhwYKhrkgmGU=3D?=
X-Exchange-RoutingPolicyChecked: YBE1Quv63mmYWqftQbWVKqCWT25DTbieLDlOwMRodbFvUwX1qaeuDi53D+ZqUSDvIpJs1elK3UUU97DufaRI58YLDjAhNh2gZvNHJaBUbzCGNmiXzfxCRPRUWVUXbksY31UzRzCQCslC5ZInt6pn0K0jrs7s2wV8vLqqaIEo7z9qLHbYvvsNkeQ9iIHcuzfNtCHdvlC3+Jp6287veYwku991BMl/X1s3XHJkCMyi7luSIOd18vXiLJc2n5+PKqU/zdvpDxYGyIrw1phT0lTUsovfUkG0olw9oW+uyLUOx4u/D8UtD6cXbS6g4E3qY+AaWbh092BQB+nH22ciY5GcAA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 65a47d91-15db-461d-744a-08df1a7cf047
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 20:46:42.0558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mPYwV0VT663ex1KU0ybHsiDPt3UY5EW8HZbkLD4Fzfv1xYYNPPt0jFaKyfRoCJM1ZxOcV7bXmHi3vp3upBZIQgD6o3SeKVNxKiLLke84V1g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6820
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> INTEL_PMT_TELEMETRY is a loadable module

This context is not true, at this point it is required to be built in for AET use.

, but resctrl is built-in and cannot
> call PMT functions directly.

This is becoming increasingly confusing since clearly resctrl currently calls
the functions directly because it requires the module to be built in. The changelogs
need to support these changes but just causes confusion. 

This changelog states 
	
	"INTEL_PMT_TELEMETRY is a loadable module"
	
	and
	
	"resctrl is built-in and cannot call PMT functions directly"

Next patch then contradicts this patch right away:

	Use the function pointers instead of direct function calls in
	preparation for the telemetry driver to be a loadable module.

> 
> Use ".probe_type = PROBE_FORCE_SYNCHRONOUS" to ensure sequential, synchronous
> calls to per-device .probe() functions.  Register the telemetry enumeration
> function pointers at the end of pmt_telem_init() when all .probe() functions
> have run and enumeration is complete.

why?

> 
> Unregister at the start of pmt_telem_exit() before teardown of the
> auxiliary drivers.

How is this sentence different from:

  static void __exit pmt_telem_exit(void)
  {
 +	intel_aet_unregister_enumeration();
  	auxiliary_driver_unregister(&pmt_telem_aux_driver);
  	xa_destroy(&telem_array);
  }


> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
> v12:
> 	No change
> ---
>  drivers/platform/x86/intel/pmt/telemetry.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/intel/pmt/telemetry.c b/drivers/platform/x86/intel/pmt/telemetry.c
> index 953f35b6daec..bf0c9295feb3 100644
> --- a/drivers/platform/x86/intel/pmt/telemetry.c
> +++ b/drivers/platform/x86/intel/pmt/telemetry.c
> @@ -427,16 +427,30 @@ static struct auxiliary_driver pmt_telem_aux_driver = {
>  	.id_table	= pmt_telem_id_table,
>  	.remove		= pmt_telem_remove,
>  	.probe		= pmt_telem_probe,
> +	.driver		= {
> +		.probe_type = PROBE_FORCE_SYNCHRONOUS,
> +	},
>  };
>  
>  static int __init pmt_telem_init(void)
>  {
> -	return auxiliary_driver_register(&pmt_telem_aux_driver);
> +	int ret;
> +
> +	ret = auxiliary_driver_register(&pmt_telem_aux_driver);
> +

Style is up to this owner but I'd suggest dropping this empty line.

> +	if (ret)
> +		return ret;
> +
> +	intel_aet_register_enumeration(THIS_MODULE, intel_pmt_get_regions_by_feature,
> +				       intel_pmt_put_feature_group);
> +
> +	return 0;
>  }
>  module_init(pmt_telem_init);
>  
>  static void __exit pmt_telem_exit(void)
>  {
> +	intel_aet_unregister_enumeration();
>  	auxiliary_driver_unregister(&pmt_telem_aux_driver);
>  	xa_destroy(&telem_array);
>  }

Reinette
