Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0105B224B13
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014270; cv=fail; b=XxIHK8VC0hfO6NWot+9bxY7tIxM7qsFnjf+2eEfo2kXin8mqKgT4YdNKxOEAfKBzk58yx6Kh+maM3TX3XB9m1DHI+kXDhtp8Cm0wx4HB98qlbIQc4vnF1dSHy7xt2jQjPp4FVg5LSg6KUThoVFMfP5/Zx1MUYuT+WtWStHiLF64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014270; c=relaxed/simple;
	bh=QqAQrAfQJfHVJqXGQ9jeRR7BBBPrDhweJk9EotZ4BkE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=reEAZkXtwQfg2h+0y0kM+fc9XM6AY1I7ZxUvd+zU6zaxDVjcRlLjd2ToLX4YXwEqk8kEOI4G5+CdBXpcusbepqPl7/BQKzalmFrFGpqX9kwGfkSEsS/7hTwUPKIwy7Rz/cc8GMTXvNvxEsen6UMnVH8QdC52bALNW2tCyFfhZ1g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HlEpC0nT; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HlEpC0nT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014269; x=1818550269;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QqAQrAfQJfHVJqXGQ9jeRR7BBBPrDhweJk9EotZ4BkE=;
  b=HlEpC0nTE0ii9N3tVR6yviXDjxuAkrDhO5Fyem7yq/qE+hoLN0zvRUPZ
   pRrbaDuJmCj4rxTG/0BQK924AI3ivy5eMV8mN9bHEH2vUzW3QTeXHCE74
   oQjK+VlW+MWIhR0/vW1TsGsnUqOpGDJR/sVBge9zbrGEJiX3bWODCSuTL
   fxJ0q+cIH00PeO2MW9ORDa5iro9HUxglyxuMitpJbLM6dIiTfnbtiF3Z1
   IcSs55BN4M/3TojkXJqGnDI+eshnB6cOWTI22fktI5dYauzRkrUuq19R5
   N2TjOmJHU7dR3o69GnpfJ0a0x5E63YJU7jiEoekhCd/gAPCI2R+fQf6PX
   g==;
X-CSE-ConnectionGUID: y/NR/yD4Q5m04hdq6wENYQ==
X-CSE-MsgGUID: MJdP8IQzQ8G+MVaTwdNw3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98162544"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98162544"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:51:08 -0700
X-CSE-ConnectionGUID: Tt54yUZAT/uw0E2pRw4C/w==
X-CSE-MsgGUID: 58vACCSmSUKQs4jVfGoJAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="264623516"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:51:08 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:51:07 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:51:07 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.18) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:51:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5Ntyi8uKFpb+Yz0gEShD1d7YkpUJIl105EJbnM1CQBsPJ7UEuHwgdXEhdCbyO2yJ+Bj9/F9rQfMYAb/91yH8wTf0xvh7oUpL7HvdJ6wl/JBH265p3/XMGwpErE5lGOjaH8D7nqM+xH9Q2/dwlROdDflfcuBnxRHtBoQvsYXRYWsLXajbTk9tdF86X8vU1PRi8iqjquX3NiWw/EmsBYEmOh8Pl/g1M4NTQZkODl0K/b5Ydt1P7ndFACB3YJ6fQzEdXW32ZInxZyNuA8hZ2uLlHJ6q/DolT0lKQvdjbbdMukeNP8+TPMKTXlo1ElIj1uLwJ4vTiN9kDJGi/Z4KvYFZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RssTePaFilhqbiHCyPKmVCRhTTHsicO2fmRAPJ3GN6Q=;
 b=pZlEv6EJyZXG7Bbu3ScqwAnkC//7ey+XL23Fx6ISDCQWFr8vNb3FPsd3VL06BUoGM9L6+kmPLbTt1P1MRQTRjiEW5o0F50O4GtME64Fxv9yeQBqMq7DhjGET+NYVFHQlJlNj8dtEvzqB6S3kTpj4xSOS2rWdyfps/1M+3AJMid+VmbALBHzjayEsjkYdmXVKBaN/NT4SclJknej7ESJ87t4QoVG5RsJXV24GcuZV1kh2NpMOeSc/vIxq6hgAD5e0pFy2oAhZaL4OY82WhMSO42OJnVpkfQhyRgrWaXpSYqEfdMqgjqHZbkMZhBBswL0HP6SSdcVMsZfk1jk3IuY19g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:51:00 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:51:00 +0000
Message-ID: <99ea4543-c573-4258-af88-c4d1cbe2d1fc@intel.com>
Date: Mon, 17 Aug 2026 17:50:58 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 03/17] fs/resctrl: Remove redundant calls to
 resctrl_arch_mon_capable()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0020.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::25) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: 2df4423f-af7b-458d-b6d5-08defcc2c5a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|6133799003|18002099003|22082099003|4143699003|11063799006|5023799004|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info: 5N6fThBR+6c+8dz8HGm41W0u+O0yc9UJzUXACK2E/NyIkJMC3kBM4FbA/8Dk9GmhPCKx739K+83NyLJ5Z3hz+7uc0Ra0sx0MwkOPQHduWyktrWKlcGtNyHJu3jmesDSkIhT5t9gcqZkJNs9Q9j7L4mnGc0HB44vceRbwSyohrFQbILUptmMg6akYGt1hXVziRxYutkIUexu9hUxJFJcUdx3ICm8QtI5LcJ6dTdRXYfEJLWHElLimRQAumPhU7esv9r/gzGgAtjYLXtMMzEffaT7un25uwh73Er1Atx4qkw6ufJOkeLgK2/xk87qH0wkei5LiI7WOiKuFTbE63x072exRGL40/YMk/EZUUD0thpNOgprg/E1UGMBPZ16JpY54EBoxXV4vbIkbHJLUdWA/S1w2HjGnrTsdmSSh+q8EBMqB9OroFZSJlMXuNdg1AjsCbZKy9lpn3hGdZNPt2HplqtgbXNPQQ5moBk0/UFnXbPCKxa8bNBD6mKKqY2IYvOW5HpCxAQuE51qfOmPqjLTJo2bjGOoRfu6rm/NtRgzvNAe+iTnNkAtJW6Ns9x+YnM68Y3RX9ydoeAatalx371PjWaOPgDv9rBcgLC5yzlPClAOW84xRegQ/20XlxC/VzLQqGQ8kuXUsSmLOqnq039E8b6kcnCWfKom6Vb2TIJahckPMhJ6GuBjznWL+Nb/hLD7daoA48RSD+ZoNgHwr/YocXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(5023799004)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGJIRlJOMjFFcHEraG1ZUGdEenJsVTNIQlVvVnlLeWc0dXhGa04zYktrZnhE?=
 =?utf-8?B?S01VMTE0eXM0a2tPMVhnRmRIdTJ5WjJ4MGRRbUlKdE42YXJGRGZHTFM1YTZV?=
 =?utf-8?B?VDVOdjdMMlM2UHA2eXBINmNpbEJteEdlaGhPOEdTZzQ2cENkQy8zdkQ3UTE3?=
 =?utf-8?B?U21CM3BTWVZucU55U2M3bVBiOWNkdyt1bmRVQ3RBY05LTG9UdjV3WldGQjNR?=
 =?utf-8?B?OEkzWUpXekkyVzRoOUYyWHFoM0l6RHl4RDAvcnMycEhiKzdWUUd3RUp1Vzcy?=
 =?utf-8?B?RTVDM0YrUmROdGVqNncrUi9NM0xYQWgrUGdtQ3pDWVRLcEpZWktpNXFOdHQy?=
 =?utf-8?B?RWRsaFZWaXk2NW5SNjFaVWdJbUd1QlV0ZGhaeG5qV1p5UUp1YWV1bWFhZ2Ry?=
 =?utf-8?B?bkJtSVFibFIzZGhRWE5QcXR4dDJBeWRXNUxha1R0aFdSWGhJeUFmV3hNVjNp?=
 =?utf-8?B?VlNqbTNmL21xL3c2YXlmVDhBVXh5aldqSEpRZU9ZWmEydGo0ck4rZzhFUFRP?=
 =?utf-8?B?TnJqK0lvUWtwTXB0L0tYVWdpVDdja09JN082Z0lsaWo0bDIvY2RuUFdjT2tT?=
 =?utf-8?B?ZUZ0andWUUdGdU9NdnpDdGxlNHNjMWpYQUxRQnR0N0tNRnhRUCtlTzBHRE1z?=
 =?utf-8?B?Ym1tTFhTQVBaUE5SVHltQ056WmxWVlREbEhYT2xTSmZ5cm5zd3RGS0Z1bEE2?=
 =?utf-8?B?bjBNMXpHZlplbzN4ZkxCTG9rSHNPb24xZWFxOFZuMVBnTzFFTldFQm1HS2NR?=
 =?utf-8?B?VmxxVTBjdG9RTEJFajkvV2xRUGNiVG5vUmRDU0N1VG1lZzk5SFZoV0NJTm50?=
 =?utf-8?B?RzlYUTY3Ym1ZZ0hiTUNiZVVIaE5NZm5sZlFCcDhVZ0NOSFV3b0FoOHo4eWZQ?=
 =?utf-8?B?V1lhRStMK2dGQnBEa3I0SzQ0TXo1blV5YUV6U1poblBNZUJOVE8zQ1FhOEEv?=
 =?utf-8?B?dUY4akM3SG1GTXlaY0EwaWFqM2FwanJJTkttMFg2K3RWNDE2NElLbmdack8v?=
 =?utf-8?B?NlN0REtyTlBNSmYwSW55NXZxdllISlluMjZmekJmRnhTTHBjbCtSZWRRUlRM?=
 =?utf-8?B?ZU1Lc0ZpclJ1NGRRbUdMZVpFMmdCU3JZVDBlc2FsdTg1WE1HVzRLNkNDc0U2?=
 =?utf-8?B?VE44SEo5cVpkanVOQ1JSWjNuSVl5UEMwZ2RNcU1Ka0o0allpYkVUaGdjUG4x?=
 =?utf-8?B?ckJ3OTBXWjhxSnQrZ2IvR3Z4U01Bbmp1SXpEN2tjbXRrK2RwWlIzQlZsNXc3?=
 =?utf-8?B?MnlicXlmQkNDWEFpOXZuT0ZvWis4UGdSazJ3Rm5QNXhYTmMzb2NUajM4cTZH?=
 =?utf-8?B?eWYrOHJYbGpFVkJZZ0xFaDduR05LWnNSam00d2w4U3hDTEsyKzVvRzRMMW5l?=
 =?utf-8?B?MUo2N1hocTdUK1loNS80VlJJYWN2ZTFuMkRRVW9KSWxFejR1aE5PSVZYRGhV?=
 =?utf-8?B?bmJ3OHZhaS9VeTNIUENZRGJWK2hJT0FhMVh2ZXZNbGpsdTVBTVNwRE9RSUFq?=
 =?utf-8?B?Y2Q5eXh3bFEyRGcwUldnVGJaZGU3VVZyN1hLOGpiTk8wckxITUtaZlBxMUNF?=
 =?utf-8?B?S1V1VkJUaVZHbkY3ZkNJdU1XdHA5bUFLMVZjdC81Z2VEVzB1QmlvVHU4Q2Jv?=
 =?utf-8?B?RXpYcW1zWkE2cWE3YlorSGdKRk8va2JISjBWNzZ6dzBVOXJiaEFkK1pYRGRX?=
 =?utf-8?B?NHRoNWdEczZaL1ZDWXcrK2U2VE4wRUhxRVBSekxXSU04YkF3UnI2cVkvckwy?=
 =?utf-8?B?N2VIdlVEeW56MnRSaFpPSG4zbmpMb0tPRVZjM3IzNm5sRldySmhERDBheWpk?=
 =?utf-8?B?WUlqQ2tsUlZJTEJHL2pabGZmTXBhNGpQZjNrdHAvMUIvNG1rT29VdFhZQUNL?=
 =?utf-8?B?eWhsOUZqUi9WaHNDaVJCNW5vaHora1kxNzNNdWJzck1FOHI2cEN3N1FXZFgz?=
 =?utf-8?B?K21CT00zWVJKV0VNZHdqeGpUTnhJdkFscklYcVJla0pEVHdIbFBnUTdoYldU?=
 =?utf-8?B?TGNzOUNNMEorMmxoRFNrZm5iczR2eGVmS0ZmK25FaG9sbW5jcnAwL2EySjg4?=
 =?utf-8?B?RW9vd0psTUhhclIweUNLS3lKUlhEWmVEMjQwbG1wTkNZM21nQUJVQTR3L2pX?=
 =?utf-8?B?VzlmNUR2WlRzbk5XVlF2cUhiREt4YXZqN2VmSFU4SFQyMjRmb0h2cGhrWUY3?=
 =?utf-8?B?OGY4ZjQ5dE9HbmZmN0xnTzExMXdGKzJ5aVRwV29lWk5lU1d4aEVOQUFQSDJ3?=
 =?utf-8?B?TzlTV1VvamJmMHVPYVoydEhXRDV5cDIrbi9PSDc5QXo0VWozU1JvWXRwd2ZZ?=
 =?utf-8?B?RWd5V2dCUTZuemRCM2VFZG1mQTFnRjBZcVduWU9BTGYvcWhEU2FRSGFWK3U0?=
 =?utf-8?Q?a5wAwkYdsF3b2bs4=3D?=
X-Exchange-RoutingPolicyChecked: WiVjhqU6v3l7qizzR8NYdWXbnMMCrgzsnznTe8S1EJr9s9A4UPs+0f+f3y0BsmWB/adM5jROBT9hniAstX2cdsi8liYEniQnmPq5Fpf++cne0zkXUWi+FqfKTna+9wpkTJD3OA0TQcxqVCqyiF1fWHVwHyTqKCWvgshqc863Gwi51XpqHyIsyeM37mDlnQAjC/7FAJnZRzdMJKCRF6BHfbnVbqbplF1DHGRrmslAy/RezCDD/EVamGgJ0DVLSWLQPHAJZ5tux/hPwc0PTZt2aV0+N7gfkq7zzT/WeaOoILV4+VqjXjNKcXQc7U0H9g7gtcOErW8KnUDc9X5QDZaEdw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 2df4423f-af7b-458d-b6d5-08defcc2c5a0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:51:00.3793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+nj9XRBwzlh1G9ZRUPqRCw/S/mRVa4eObdmd4FH25HKvKaHV9DoUcKN/hRbNnSfTSX7N90rxp8kTaXjDPhmWBiSrej6b48x+nvJglaYHPw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> Architecture code provides resctrl_arch_mon_capable() so that file
> system code knows whether any monitor features are supported. This
> is used to decide whether to create "mon_data" directories etc.
> 
> Initially resctrl_arch_mon_capable() was an inline function providing
> the value of the x86 architecture variable "rdt_mon_capable". I.e.
> extremely low overhead and so it was used liberally as a sanity check.
> 
> The ARM implementation of resctrl_arch_mon_capable() is not inline and
> chases a couple of pointers. Future changes to x86 implementation will
> also make resctrl_arch_mon_capable() more expensive.
> 
> Redundant calls to resctrl_arch_mon_capable() in hot code paths should
> be eliminated.
> 
> 1) mbm_handle_overflow()
> This function is called once per second from worker threads running on
> each L3 domain. The call is clearly redundant because worker threads are
> only created if the MBM monitoring feature is enabled.
> 
> 2) is_rmid_match()
> This function is called when a user reads a "tasks" file of a MON_GROUP.

Above sentence can just be dropped since it is incomplete wrt where is_rmid_match()
is used. If you want to add a motivation it may be supportive to mention
that all callers of is_rmid_match() call it for every task on the system so
making it less expensive is appealing.

> The call is redundant because the function also checks "r->type ==
> RDTMON_GROUP" and this type of group can only be created on systems that
> support monitoring.
> 
> Remove the call to resctrl_arch_mon_capable() from both of these
> functions.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
