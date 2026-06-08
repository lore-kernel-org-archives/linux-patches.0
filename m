Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E383330B01
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960955; cv=fail; b=GfC2YAHw3uNNaYClFQPStkW9bUq2qwW8roOm59e6SHhkIai6mnZKBwQf871dPcgzAFYhokl4K57EUgSzP0kdjkDCgN5VbBZzxpfQJeX0ca701za7Fb0DXAg2CrGKm28bjHvfD8yB7WPfEkkjhfzRZoufDqzKJtXiNPnDL9zUxXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960955; c=relaxed/simple;
	bh=/SriVKy1wyhOww3CLs1TQQFHXNCBLzULvt+ncyHRXOc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=iumgjtTLvjSwYI2xbOcrfX7MjimzJz0WAteGQ4n28S6BDr0649NhUjOV1c/Gx0tOBYDSFDk8Qg4ilsIisXU45IxVbqh4+OlGA5H9ZK/5oC618NDMu6f04Rui8BOJ8vdWWYz3oU7ER4D7MNwGO5EtNfLn4pB6bgCxPvJSS4gSnZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NH31KRhP; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NH31KRhP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960954; x=1812496954;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/SriVKy1wyhOww3CLs1TQQFHXNCBLzULvt+ncyHRXOc=;
  b=NH31KRhPY8NI+8NJUTfo+1zneg7cs+o0/2paMD0gfStXLrW865jQ2imD
   KYAMV4CM67QyEiLhtK9C2+EeVyzHElRRyOeUKUzP12OJvEwexTysU6G9j
   orjYTHE98irYyXnwNflH6MZ+il8+p/T5Mb2C8jDNXnBauVQuv3fU16zAu
   lHR2H09/B4yc9vKZbKcTwdTYFKUpJ+buqGpjHwVg+W13m4xBvlULMzHy3
   sVmxug45ZO5ZR0yd4SPTRTBK0wFltfaMtOpszVTn+EkVr1gLyOqdqC7lF
   ex4gMwPuFVnUGOnyoZrlIcp8/OQl01dcnqaCnBICceLdVCzCcpcwb0Es7
   A==;
X-CSE-ConnectionGUID: 2izgUHs0Tu62b8zLZpUyeg==
X-CSE-MsgGUID: fmWBUNhGTaiJS3QGeSXODg==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="80845465"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="80845465"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:22:34 -0700
X-CSE-ConnectionGUID: VTw0Mh9JReCop8YGkPlwvg==
X-CSE-MsgGUID: +Ao5riwOSH2zGErR9FRRdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="249607310"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:22:34 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:22:33 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:22:33 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.32) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:22:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LbjbFryYPrfYS0Gu7SOK64BH+AXcpcbtrA1hCIVc96yNxk7Xen6lYshc0PMRuxzbtPZZHPzEO/f6RHXlmT/5MvKVgK+VJ+zhBLCGMQPO3wVNOn/5NRPPYnXhAUmlvva+ERdH9fjOikzgjGW1dTlZsqgSMhDuHpPTQfZDwIeB8xxkNcN8DWFP1TBufofuGswesrLtRdGkD2te03TVm5XIa6iTwP4dziUyL+9jcKHWhCkU+i8IAkbwXUqtOwIVSrEGxfCqv2JvJJiYpEUamn6LlrokxVph9Jh+Oh3fFgkXqExb3taR/vZQbBftZgrQajacKuhADs2U3LNB82QcngocrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B3UN7fDtlmgltOIOo1TlE1DGkDEVdsgdMlXSw4Qb/SI=;
 b=qKMZbVkApiRQ9iotGCMbo17u5DEn+ZtBeNLU2eHpg4llj80htHoffUz6IzgT2Ei0NHrjpCZJgE+1RHKNVq1oHjJ0c9/1qdyovrR18TVNZynROvs7F/osSHv51O7lL8aD95Bg8/rNACckbgICikTDlVoFNrFRnjugyslD82H2wDWWbrhJJid1mUgjafBtHYaadufY/CKdZodsKiF5O7imH7sialScz9GlYxU2L9dx3rdPg8uz4UALKUYhTCAobeh9PLbBaKqxR3wt5R3vJe/q2Zr8nJn7/cql+xt3XqNVBSVjYpPt/m6kQXNgcVWAFt/5iC7ax3SEm1UxIW76v8RYTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 8 Jun 2026
 23:22:29 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:22:29 +0000
Message-ID: <cdb00b39-383f-4751-8e5a-3986fc92a889@intel.com>
Date: Mon, 8 Jun 2026 16:22:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 10/14] platform/x86/intel/pmt: Register enumeration
 functions with resctrl
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-11-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:303:6b::32) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: f426c0d6-d07a-4ef5-b497-08dec5b4cf1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|6133799003|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: PvNmTAnhgou+OPUT0QA3IvLFo2J64fYh73N3i/3fLuzgk3NU1zHUABcyXSIzVIvb++g4gl/Lkj77/O101GnXOrM91atwFIqTsftlbQlIKvxY8CSrocBOgYl/0jQ2k9ZpMCx0LU8epJcYAfncTImHIVPxGGMvbucOO0pj6cCg1xjh8hXeVjBGSKP4fLv+ZGK5Sja7a93zDa1UGUFcBbi83c0PQt9aOF1lUZ9JNOBAifsVpnLIIXyM5H342jna4G+uyPbiUkfn5HoD9kRlcM/gFoW9aCQvoo3blCO+Dl2UksWpaQmBh598mW9rSNs5oQlrH73grLzoIwvO3GgcaepMm7zWAvCC0AqVQDOapoOXW/h4pYikJXEAmzzo9HtsOj9Q0XuiDIyA6jOgTt5er2RZuYG2YGs8CQCaLFXQYx67OuVWpb8KjxWnqRa3EgzPwQZ+VTocYYyRyFFlTmhqx7g1mGDVPQiK4pPzEfyTzxQd39kx7AVW4YnXctkz+FLF8CHvYr6GyXg8G33Uit5iWALYSZRpidrswFzmHMYU7F3zXPh+4lrxJ8u3a2i3LRjaB4bletLwH5PIH8e8Tt5Dz0oNh64NfkppEKoh9AFu6JLJmTQXhVdY33+0sAnnbaSgX3Zs240cTdKLpaxMH6BmW8qe5Vri/GKQUylxiiZyYosrCYeqR7PxHcZXGWjfnP1zjCfjGqCJbdonDbpTVWBFLKJAgj/9+H1aNdD3V6J70P5KS50=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(6133799003)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NUxZQ3UrM2dHbDVNL1o0bEVqTmpHcWxreE1WSzQ5NzBOUTlveGI2bEpNa3l2?=
 =?utf-8?B?eEM0Q2xoU3d6TldLYnM2RnZRK1N1bzdxcUg1NkM3bjhYTTIvKzBRdldscnhm?=
 =?utf-8?B?MzFJaFpVQmhtckdiZGFZbjNaQnIxVmxXSkxWamlpNFRrVklzMlhxS3dOVTVB?=
 =?utf-8?B?VnZydVNNMjVKcVJlQks1NmF5b085OUlYbzhuYytiWFQrT2QreGRKLzN2SGcz?=
 =?utf-8?B?TUIwQ21XdkROUGZqSlh0Qmw1a1V3eHJ0WW5SUGkxZXM4TnpIZU5wdE1BS0Zz?=
 =?utf-8?B?QmhOSUZwMEpuUGU0Ry9VbUlBc3NkWVNLNHVCcW1wMXJSaWJqaitVMGNzZWY2?=
 =?utf-8?B?ZS91U201V3dNVEFZaWh2Ukk0c2FXb25HcGIyMlN5eEFFbk9nbi9jSGhaaytm?=
 =?utf-8?B?TDF2ajA5WVpLd0dJVXVoeHNnSWhadWtUMGUvdUx3ODZnTFRXc05vSnp6b0gv?=
 =?utf-8?B?VmxrRHhON0ZseC9qSkhsSWZUa0loRW1mS0hudFRXbnQzKy9KcDZGQWdQRUk5?=
 =?utf-8?B?cXlHaXFNN1NNd1dHaGs5dE9UOThkN3QxekgyVUdsUmIxd1RPWG9IMVZQb2ZP?=
 =?utf-8?B?SUFpRmw1K2lMc1p1SzY3RzA5M3lkNU5YZlg5cllvTFdSUHlicEp1WnU3NTV6?=
 =?utf-8?B?RGV5cm04ZTdjS3psQUkyd0hEVVBWb3Q3WUdma3c3SU90c2grWVhiNXE3eVBQ?=
 =?utf-8?B?UXdZdVA4djdadnZWS01YMGhZVjVaSnFCeC9URzJtZlRUcW0rN1diT3dwcmhK?=
 =?utf-8?B?TXdXbVVKcTdwdk5ZRTczL1VwRk00cE1ncVkvYWRuYkVIbVJONEE4ZDIrb2Y5?=
 =?utf-8?B?TCtTR1ludW1tdTZxc3h6N0hSeTZodUcxQVpRQWNSSlBMMXd0N3BLampua01I?=
 =?utf-8?B?T0gxc3pyWmM5Mk1vVlZzM0NzQ1FvcDBNWDlpOER1RVBUUG1QdGJzYXcvVDkr?=
 =?utf-8?B?UjQ0bVhYMGtRaVpjeURxZkZybWptL3ZHNWVqZEdNUHZZZklJdytCVDJIZFlu?=
 =?utf-8?B?RHVvNU5ONFpmclRJOFVsSHRnQ0daSkpsMG56dUxTSWdMRk11cU5IQVk3aTF1?=
 =?utf-8?B?bXdvTjFLS29HSXBrdWxSSy9neDFIQUNHTTFuQVJCTFcxNkk1MjJTU2tlek1r?=
 =?utf-8?B?L0pmZzRxRjZEQVQzMGZDYk0yTWhEVFJGMTg0bmpPcEdidmlZQlAzSE90MU9B?=
 =?utf-8?B?cVNpMWhWWVZHYU15eU9xQjBZMTRVT2IvRGpheC9vaE85ZHZod0NRWTJXek1Y?=
 =?utf-8?B?WEkzVTBmZVNTRnduRVZqOU9jOW9tM0lVdWtOL1hvd1lDNmFqdmRwcnhGVlk3?=
 =?utf-8?B?ZHMvaVR2M0ZWMFlHRjBKVGlJS2hyVHZmeGc2RnJYd3A0ak5Oc1ZIVjJPSmFH?=
 =?utf-8?B?UUJYNXRBUXFiM21kRTVzYk9GZGg4OUl6Q2xXVTQ2WlBGVHZnUmFVSkxNT2xq?=
 =?utf-8?B?MSs1ZytJRWJSODRLaEtYTkNyWlk0cC9kZGppRWNkSGZoNGFpR0piRldEL2Rn?=
 =?utf-8?B?dnVsVGZIeGdiY3FKRGpWM2dVeEJWK1N3Q2ZpYXJ5dmgvbXVIK1NxUERMQlRm?=
 =?utf-8?B?cHlwdmVwQ1V4RFhIdjJKK2JmZ3c4emdDalk1aXpBN1dPVzVtQ2VyNVZlYlh2?=
 =?utf-8?B?bE9tNkV1aGVMOFRpRnpPM0I1TDdBVm8wUVowdlVPZ0xtZFdUVk53MUhYLzFv?=
 =?utf-8?B?OFBLcTFWVS95Mkx1SEZWQUVZQU1pdDNEWnRoYW5CNDhVRnNmbEFhSzFZbEVO?=
 =?utf-8?B?QlhNSmxYMXdzdFIwRDYwbkVKVk5Gc09jV1lrWlZhb1hhVW1zVnFsQ0dDUWJ3?=
 =?utf-8?B?VnJoK2ROUWVKWkcxZzdFRTdWTU5WTUExbjJPSWEzNHNQVno4M1NQWldEcXAx?=
 =?utf-8?B?MTRhQWVRbHh2NXlqdGdqZm1FcC9aTUYwbTRXODJYc1Z6Z3N6TkpFbVpSL2NL?=
 =?utf-8?B?b09uemVoTWZCdHpCYk4xN0dJWFFyRk4yQ214UWJ0YWEyNkNTL1ExMjBlS2Nk?=
 =?utf-8?B?YytFVStnNFI5NUQ4SGcyaE5DUHhGeWFpTVduaHFCMmZGMTZMNjhuY3hMWks1?=
 =?utf-8?B?d3dTSHJGRitrazRSSGw1V3B5WDkzTEF4djg0NHV2TUlDRWVQb3lxOUJVVm5Q?=
 =?utf-8?B?UUxhNEpZUTNVQVZzVDdRc0FCbks5d2FQWktWZnBmR2xyalRMa01hOW5RUWZI?=
 =?utf-8?B?TFhOVFJLaDlnbFBXQTVSbG03K3VxVjhQeWgyMlBWQkJCQlE3bVByQ0IyckFO?=
 =?utf-8?B?djE4NGkrNnAyekZ0TW9hcHRHNGNoSHA0VDIvWmpCYjNScVlUUmMyaDBGb2Q2?=
 =?utf-8?B?WmlCYnBsSDVUaXdqblJQUmhrMHZKTlNOL2ZnVkJXUjhINGcxZVIyUG1hNlJk?=
 =?utf-8?Q?+HixKOw0p3Hc/pzk=3D?=
X-Exchange-RoutingPolicyChecked: qgCABmF/iHtmGnM2JB16sdiBIqSlWlqw58dcOnm3SnYdCGFIOeuZmA73W+BV6ILPqO7bpjA3Nyx7zdE6E5gKkAE3kgggpiQZg4UOpM1nCxpG8dc96f7DBVZOZvtg5BOdUwEZkmB8P96vYmXCiICHC0LVv7nmNjgx9ikRTINZ2WvldhtMC8g8VHsN7/csKjNS6V4cTKbp+yAvR39nGS/Rd0zx2MgNp9t8qJqRN+zBuGZpdMP+gzNag/eioDycdQr+JrbnIdkqOGMzNNrvA8oxxvo7pvQCV/tV26H8IoF0GC0KIVlMHay5FlwHarBL0dZ7NhiQuTBTMK4ovGj6OjaSFA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f426c0d6-d07a-4ef5-b497-08dec5b4cf1c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:22:29.4513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCTphqWm2u1AxM1GDEs4FRW2ZzQ0cqm9iFTkqh/2SDW45PVjWnflGNgcuG91vBd128bs/R5kG2qO4VeJ1TSt0EgaVq3MdywBZHvY9wxnHUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6734
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> INTEL_PMT_TELEMETRY is a loadable module, but resctrl is built-in and cannot
> call PMT functions directly.  Register the telemetry enumeration function
> pointers at pmt_telemetry module init, and unregister them at module exit.

To ensure intel_pmt_get_regions_by_feature() has access to complete data, could
it be more accurate to register at the end of PMT's .probe() and similarly
unregister during .remove()?

Reinette
