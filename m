Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97EF376469
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 18:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787336346; cv=fail; b=hIFwJxcrzOY2aydBSBO9iDUYftxnuf+XI2XyRjPVrUoVKh86OdfD6N3uKXr2C6gx8q18nlxeM/noJyOWhemGKqK7AW6OOo3F8qgjkMv0U38/sqU4kXlqPpv76EqMajN8ElYdvoYA1coKyAnrQ6bsX3nvoBfdLUqSh9XgHPQ69qQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787336346; c=relaxed/simple;
	bh=VxQnzJ2KeTljhSsxBO48thdC93TZ5l0p7xaXUAlqsDE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YzkICPcpENt1DJGLdd5F7Ry+Mo41V1e7E3BvsAoPTK95TErcz0ywkFQEUHQ1sx36xFBdW6t/HO1oBv7UazceoFHes09oVkbvl99aXMCbx5uc9mKpvjmC7ns3daQj9abuxlSLrjahxwiv2u44GMYwa544dd+KkrSsSc4wesQuk+o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eAzzVnzR; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eAzzVnzR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787336344; x=1818872344;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VxQnzJ2KeTljhSsxBO48thdC93TZ5l0p7xaXUAlqsDE=;
  b=eAzzVnzR61RZr4E82C/TrLgre57q/RR3dbWWHl/3j727aqlLwf65AJrD
   biF+o1eGvc9zQBj80lD37P1y9TTdIXNs4HJpvkiCZKrcupRc4aqjUudUo
   heI0cE1que0y/QkeHz6YijU8/tqNozuGOkha5H13TVQ8v+Vq67icnr1lk
   aQu67dGM2pj/9xpTtHYOp6pxtMRYNne0IBVhkuVh8H9AXwPJ6RJeYSMr7
   NsauJE7MBfSMypvAdNGiSvC7cn5S7wu+N20+eBJ2WW/gfYCF5oUNOJ7ur
   YD07nTj5bWB+5NaLcemuRREzhdaOjlCg0S+TvFvFQ20SAUzu06C3LlWzL
   Q==;
X-CSE-ConnectionGUID: nTUSTM2SSZ6nLwyYBwJy/g==
X-CSE-MsgGUID: LblSu5lzQ7GtdfxoPze4lA==
X-IronPort-AV: E=McAfee;i="6800,10657,11882"; a="75429661"
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="75429661"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 11:19:04 -0700
X-CSE-ConnectionGUID: Hz4fZIL1T6iWJ/wAiPXyUA==
X-CSE-MsgGUID: CYd/1CyTRH6z6+UcKe3iRQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,235,1779174000"; 
   d="scan'208";a="263132214"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2026 11:19:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 11:19:03 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Fri, 21 Aug 2026 11:19:03 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 21 Aug 2026 11:19:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rw7o/CeESjrnUjQlvku+rUl2f9Cvk87ezhLwztHYGaZL/R1PHQvJRXajyFtxrxDYJ6+x0hCUx4MUmAoWW6mSHjEeCbNLTXu0cqwAzW9t7UiVsb/ZujoEdyyziDQ/7XIqqdXS6qVa7Gn4PIj4DHwiPk0yGKxQeFfet7BMyDid2jRsFKjVfRlnnMiqHo7ZfhLFvtFmumKguprqS5wwNY5LIwQJBuTzfV31IzTan3bwwRQ1XrHuRYZk2bvvQlFGWg3kxF3kP5um4pC8+Cr5BnOHp4MXSr9nPlNkYehu+jkUIwzu2OyJq6sxDNOgVdMtFQxTwiWmiEorjK3Y0m6jE5KtWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yr3Rz2vARKweHqJzE4xuIVxTDd8esON2afW68n3hwxs=;
 b=IvWUOYCMqnoDJCoce0I1IlOyO8SZy6TYUpsI4QMlWd8rOwZG2wC6HnhWbJ4sAXAvzMKLdNXWQqfRmECB5VkiS3EdqWdXjFFY1plZoVeBgdH3u1htk8/18pLTCj6Mj+HWNnTEr1plo+nyIL060kglaQaGrkuTdcOK+YmQqbZdEduExUPXnvOiR66GZowh2EPx5BHVUx5ePm3cvfdAGnLF5ey0xSFYKiEl18qkl10/mh9tTuHXVMLnm72UsaKV27Fv8GMUIdal3d1pvBtkporBZOx5K3sKetGgrI0O3LQTrPsK+mEvbN952B9ZeE7uA5rx66QjNY6tkN3ET60q3N13Hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by LV2PR11MB727748.namprd11.prod.outlook.com (2603:10b6:408:413::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.11; Fri, 21 Aug
 2026 18:19:01 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 18:19:00 +0000
Message-ID: <9787f9de-c72d-4c0d-b9a9-867b0f4377f5@intel.com>
Date: Fri, 21 Aug 2026 11:18:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] x86/resctrl: Check if monitoring features are
 enabled
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260819161323.11587-1-tony.luck@intel.com>
 <20260819161323.11587-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260819161323.11587-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:303:8f::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|LV2PR11MB727748:EE_
X-MS-Office365-Filtering-Correlation-Id: 080a18a3-9346-4b69-6717-08deffb0abbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|23010399003|366016|921020|18002099003|22082099003|10067099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: z/WCj9hRr/eq1YmamoP2h+Gk48bKU3rOQUWFwEOHXVjCjsHnTJH/FdQrQ3hnnmlumoymE9R6eNSDFk0cOArZkzLPIJ64vVJOnmQpyqHptZ1X5676hmlkH4UfaeZkiqxekEJchF/WIRs9gIbnm6OeHlVY9fPzhY2Xm+yBkox4YMv31NHX51+2Bz+sOkcRpXDFnrdMItBYHF6PzrauuZ0aRtCIXC3ubR51iC2hveBB4oUnQh0AXwTC45HyCKUuFnUsSVmP4Yu4P7RTMGl8RAeMCMqRsKP5AWlrFjEEokpinLItuWFRt42xvzdlQCuYlaJ6oKiM4Sb3VCHe1bPWHtZj4RaVIgHhJ1Rspno1/Y/4/q9Ze6UFuCSEfGViV1Edh/bi/1Y5WnaKhK8UpPPW2mZ8KD9vgr+oQg+G3F6eBz3B1841dzRWl607Qsd4JoHTBY97OGpn1hPYGw9BZyFVQLNH0KFO9bDQlElBpAwUrgLQtd41HXdQc6+HFjOq1GgHq10r7FafVTVlTSot9HLOKJ3xYNGle1/QXyC/mgld3xlGQXpwnPis+dJ1F2bAUeQw4G8ACF55vaTR+Jrm14bjQNaK21GHkVgTDwWLJL1VONKyg2zoSpdyR/TcEaPgOcBWkp2B+ARO+jDbwSHITxV5u1zMeytNuVMQv3bec01Yt1tdDehEjHd8L1qJpFKhhTJ071DDz8NyRhXNtWNwpc/o3pSivA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(23010399003)(366016)(921020)(18002099003)(22082099003)(10067099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFdkdDN3RDRFZWV2QVNRNDRqbG9vSXZZRkxRWlhGNlRlY1pCVCthQjNLZVhW?=
 =?utf-8?B?K0xPMlFSSFhOV1NnZk0xbjFPZTdBUG9kcjVWQzBkN0dCd1JQQ3RYOThyQWJu?=
 =?utf-8?B?T0ZzYU9QVEt1YkVxUmtNbHFtOFFEVkQwdzdUcDg1V3l6UTZpODBxK3lCTjRw?=
 =?utf-8?B?Y08xWWZCZ201R25RRTNGM296cGhheDc0YTFxWGcya3BLRituL3pYcGNmeDVF?=
 =?utf-8?B?Y2JoK05GdFh6Rmd3Y2c3cWE5azBKc01qcGJ0VVpWWkdjVlkwWC8rQTdCdkQ0?=
 =?utf-8?B?dzRNM2dZSkhVUGlRWkl2ZHczUDNxL2V2c0Mwem9NYWlwZlRHdUd4WWRFRXlI?=
 =?utf-8?B?czFRZjU0ZWZJbzFlRzl3OUQ1cHJDYXlGL0xrVUttMThwaWhoQlhrSWdDNTkr?=
 =?utf-8?B?MEMybzV6S0kvUkhncWxYTW9PMVZ5Slp1Zm9TQklnaTlxT0hjeWVRZkd1aWh4?=
 =?utf-8?B?aGVzRmd1bWRmVVBuYVhFMW44dGttT1M4WHdwZXNlRWNZdzZTd3dZdERtRnJ2?=
 =?utf-8?B?SXBhZGM5eU04SUhIMGFKZ0tET29sZ0hXM3ppMDRqNk14QVdkckJtaGFKb0tZ?=
 =?utf-8?B?aXNuVDZCUjN1M2plS2hGVThvYk1PMENKQ3kvalVRcW8xUkNpck1aSHNaQzBG?=
 =?utf-8?B?bDhBS2ZKVlcxMlNpY0UveEJ3TU1sTUVQY1hiVFpPZFFuTXl5L0xOd0hFdzlE?=
 =?utf-8?B?WTdwdEFkTlNUVkozc3RLeVg5ejFtUWhTby83NmtheWU1Qk40bCtCenZJU2Zi?=
 =?utf-8?B?VHhrbmYzOVNBWGphek9xaHc5MjZ6S3l1TGNpOS9Tb05jZEwwT2tSVEpSaStB?=
 =?utf-8?B?aGkrZGJWcmt1MzNYajl3ZWlGK0QrSkM1c1ZxTVdnUVFmOVZ0TDAxWnUxMlRi?=
 =?utf-8?B?SkFtY3EzTVdiQys2WVJQOTR4bHdqbWdrei9CbmxneUpsTTRwT05RbUVabWRY?=
 =?utf-8?B?U0svMjZIRlVtZC9WeUdqQWcxSUFPU0pKbEJuRjArb1M2MFExcEZWZDNOaDk4?=
 =?utf-8?B?M2RPZU1NSTI2ZUJkQ09JS0t1bytXRnliVHZWOEthdGMwTWRZLzB4UEU5S1pY?=
 =?utf-8?B?WExZT0drMlBTVk1yMEwzVC9ZK3haQU83c0F0Z2hta2cxemhSZk1wT05GQW9z?=
 =?utf-8?B?d0p0a0tzMUtqb0haRmdIYW5CbHNCK3ZZbU1USFF6SWpmZGkrL1ZrRkFBWTEv?=
 =?utf-8?B?K29JZUl0U2UvRkFYMEJIcjNOYWVqZStuWXFuL1JnOGZPK3pOY3lzbnRQRWR0?=
 =?utf-8?B?WjV2dU5zTXYvbWN3UFlYUHZVc3JtVytZbTVyRkhSdk1KbTZsQ1pkWXdoelh6?=
 =?utf-8?B?RUVyT2d4TXFxaU91ZFdYUEpvM1ExaFo1R3NvYW1DeEh6RE41MDE3TW83UWpQ?=
 =?utf-8?B?NFpkV0RhUkR0ZW5rMVN2SGluYVI0b25CWkFockE2UXlqajVPWTUxM1BMOVRr?=
 =?utf-8?B?OTcvWEVFNG9ENjVLM3hYT2hqUVZDamxZOGx4SWhidjhzU3A5cTBvSjVkTXdp?=
 =?utf-8?B?aks2ZGNLakQwWkIwRjVEK25ObGNPaEczSjNuckdGcGZJKzYvOGdUOWFBbU1D?=
 =?utf-8?B?c1h3bmh6ZUhHc1JOakowWmtzdm8xVG5EamdEeXN4bXVYcFNDNVpOWmdJbnFF?=
 =?utf-8?B?RU4zSjEzdjNpT2NRL0xRd01kcVladHZwRjQ1TGM3VUxvbVQrcEtEaXpMWEkz?=
 =?utf-8?B?dXJrYzR4U3ByaXRhMXAxS0lQLzNzNUV2YTFUbGpJMEo2Ri9JUUZkTFFYUE5J?=
 =?utf-8?B?NjVDRW1OeEU5NXhZUE1DRHFhZVRSdE9tRCtkY1NobjdCOVloZHQ4RUd6R3BP?=
 =?utf-8?B?d1hiVklxdm9vQVVncG82NlBwNVVXQzRDQTN4M1pkTkpGeVBwOGVQNFcydkFu?=
 =?utf-8?B?S0pmY1JYSWNoNFBnVnlnWUlSUHBURzFQSUl2a0NOeEhtNTFwTlBEZ0xNRVdh?=
 =?utf-8?B?RUlxOFI5Wi9lNExBTnFLVlZlYW5xWVRtUm1NWGVGVjJIOTVoOHBSSTFKcE1H?=
 =?utf-8?B?eW9qTHFaOW9tOFdZOERIMngvT0NTdURZYmljaFdQclI0STJwUi9tWjYxbzBk?=
 =?utf-8?B?YnpFTWladisvK0MrWHVncWNDRGd2UDdmWjU1YjU4bzVmTmpiS0ZzQkNYOUFJ?=
 =?utf-8?B?YXhhSHhNYnFSWVB3UjVWR1BrSUliNDNCcERadDYrelhWcEtYUXJNNzNOd1g0?=
 =?utf-8?B?RWwrRDg1TzBSYjNXMjlsMFhYWVFWUXRFNXYwcUxUc1Q3ZmdWL2NDb3hpTU55?=
 =?utf-8?B?SDdiSVNmRGVwYThENm0waWtCUzE2Q0V3dE1tS2I2bm4xZDVGSDBhVm0rRGFF?=
 =?utf-8?B?UWNZeDFFSHdZSjFhbWpIUXBlVzBOZWVEUFRVK043N0pXK0RRejRYVXZGSVNG?=
 =?utf-8?Q?LqBGtwIJ8pA560M4=3D?=
X-Exchange-RoutingPolicyChecked: mP4oJiioBebrSYVQkMqMbppRTuan+5p+gsxLG3Qbx1afI5LwaAK+9todC8CYHndrCmqPcmn2/C3DufFK3/HqVkl5ivQxaZ2m+Z/WAKcDKGnKj2qhea0eG4jhJpOEP9q3pzOOOwPIogpet7mx9W+ZZjFPBvc9egPaO7CMST1yuK6xMOi7kjrQ7nYZxVpajj63Etl3lklA/RqMbR5rJYCroCsmkLc9C4gplqY3WTUHP10n9U35NXCSzKmW3orbOOnuannMqGjD30abJ/VyRd5TZUIDhGYxvIkUhbntYvVJRjRLgDm49F4gqt4Xbc8r7QBu8auS23PIl8/KKAuYKs7Tmw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 080a18a3-9346-4b69-6717-08deffb0abbd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2026 18:19:00.8246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCtNVDbyeGcToKyQ4LgI3S8gh6eTwugh5jOpjpkWq9DtI9RxpRDwUzQCIpB2PQ7frcxmH2pJHj5uvwLv1OLO27ugg7IkG5nAQQ+QVkRGpsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB727748
X-OriginatorOrg: intel.com

Hi Tony,

Thank you for doing this.

On 8/19/26 9:13 AM, Tony Luck wrote:
> Both Intel and AMD manuals say that software must first check
> CPUID(0x7,0x0).EBX[12] to see if any monitoring features are enabled
> before checking for specific features enabled in subleaves.
> 
> Add the check for X86_FEATURE_CQM.
> 
> Fixes: cbc82b172638 ("x86: Add support for Intel Cache QoS Monitoring (CQM) detection")
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 55214d6fdc49..2677b8a6c15b 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -968,6 +968,9 @@ static __init bool get_rdt_mon_resources(void)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>  	bool ret = false;
>  
> +	if (!cpu_feature_enabled(X86_FEATURE_CQM))
> +		return false;

Is this missing a check of X86_FEATURE_CQM_LLC also?

As I understand resctrl learns from X86_FEATURE_CQM whether the system supports
resource monitoring in general. Contrary to what the feature name suggests, there is
another step needed to determine which resource(s) support monitoring via
CPUID(0xF,0x0).EDX where bit 1 indicates LLC monitoring that needs to be set before
the LLC resource-specific monitoring properties can/should be determined.

Apart from the checks here I see that cpuid_deps[] accurately reflects the relationship
between X86_FEATURE_CQM_LLC and the different LLC monitoring features checked for below.
I do not see cpuid_deps[] capturing the relationship between X86_FEATURE_CQM and
X86_FEATURE_CQM_LLC though. Could adding it complete the handling of relationships between
these leaves?

Similarly I think cpuid_deps[] may be missing X86_FEATURE_ABMC's dependency on 
X86_FEATURE_CQM_LLC. 

> +
>  	if (rdt_cpu_has(X86_FEATURE_CQM_OCCUP_LLC)) {
>  		resctrl_enable_mon_event(QOS_L3_OCCUP_EVENT_ID, false, 0, NULL);
>  		ret = true;

Reinette
