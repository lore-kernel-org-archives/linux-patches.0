Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96422D12ED
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014570; cv=fail; b=LELE/G56YgcxPQ2VQGEs9NBF5jOTJhlTwA/a9IlE99TuE5bUX+8QAsW9GrsN4S2ilOhxnj3ZfR2JREtUDJD/X/8L/HIQxbHE0VBgNNkj/2XHRVY/ahGkQYF6xgyKfI6LM0fudS11oSWuSSJiZmXc8/npH5SIPIHA9Z12xpDF0ps=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014570; c=relaxed/simple;
	bh=4SylCmQFcTcyAELGOvwKUHDOsLBLgz+bH/xK7PsSy9A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ub914Q6OIGZzSnwt9SkDG9J7fRKrjPIyrVe2GUbYYG/ByPXNObJrFoZ7T17zpQ9LAT2VoHwS1rMwz+5elVGyvSXlsUepeol84N+3R81G3IY/I+AKuaP7nV12AEDhfPH96Qr8FI0ZGYr97NN5y/uRdEA84NuyUX4j7pjbpx70Z6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j/y0NaYF; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j/y0NaYF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014567; x=1818550567;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4SylCmQFcTcyAELGOvwKUHDOsLBLgz+bH/xK7PsSy9A=;
  b=j/y0NaYFy9BtMViFJiqiGpNru7vJR7cc02jCBFtHyVcm4wxXnklMmqAa
   r3anjHPKo4tGM6lI54yN1IQ8uySEPRHcqgH4N+yA7IUger11wiOzS2vFL
   fIk4R+46y+znz8DgxlCB/AoCRhldkkdFciMsWsO3BoR/Vza7VCmZfo/b5
   M7RO4O5L1cP8UdNWeosRtMDDbU0ShxipTouourWWjhXbB+3mMoMxzMWZB
   FA6mY5E8E5zEN/tZVGDU7WkoSQQNWUxNqfD7hrRldUVRCOXcFPQWdk7Yk
   T5FkIqKC4RGqNaElt5qa6+Gy+ep+UxbiOilFmtHGUONJcFXSPzLqQ942k
   w==;
X-CSE-ConnectionGUID: Gr/ilashS0udDBXrkac1xw==
X-CSE-MsgGUID: De6//SAYStq/5Vwu/RKtPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87705593"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87705593"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:56:06 -0700
X-CSE-ConnectionGUID: jvsHGFtPTXOzeH62k42NmQ==
X-CSE-MsgGUID: k21fdAi8R9K6/644UBy3pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="265104129"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:56:06 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:56:05 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:56:05 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:56:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QDhqB0bc1uWAY8QlmVYWKRWnurl+Igl+2ju/otfe5EMHcktxe9COG7uryQRFFNQ65VJ6sv29ZSDNH6EfkVi7kq4Gjd905x+nbpIBwij4+O+TFBv0l2uxf3pBizm0I3jz8DgJaK1DKYLU83WfzmBCJuYd/ta5oTeVd+5uXUQFocJFUikTMZBk3NuYqFD80xVCQtjmlFPKNK7RUven4HYTSAbC8b9VeiFcX8tLfgefRA9RF59cR6KwNIWo4Ls9gxaLyEBaWxaeQ1ZqzOvuR6vMntfqXcP6NMIQSzAdeavXe5vsBnbR4WrlMctqnbTtB8ZRGkeVp9lUzWoSNgpZG1YTlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZEDe6L+ovr/GppmfFmO/Tz67bq+43vRVTdAy2uLEcV4=;
 b=RCOpm6WlaFecGkS+NqVPAfEKYXcw7demOALIW32nV+hEmhzKUMOkTZchvN+RK8aqXejuXA8Xr8nZ3wWmUQSaWs7I8BWPH1/WB4HMU5QO1C5hsxiGuw2BUtsFO3tbE56PjHitPyXx8lP3DQR+5KDmnaZ8cGskdbNmdf0V2ilZkfHs4JcwbxQkLrR4W/bPH3AIFCoCC+g9z7VploHBQF9SaJsxu17Ffx0oPYdlM3hVrzOkkmED8V3lU/H+hMrLFtErDaKBtiRGRdxaMyJMZtY2fvG+mNV80SCcBZQL3uqn5u5jHYWwvcncnjvTW7lrraqWkFPCWl+w1c87JTsCO2zwJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:56:03 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:56:03 +0000
Message-ID: <aa16a09a-d12d-44b1-b00e-16bf4c5d1ae1@intel.com>
Date: Mon, 17 Aug 2026 17:56:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 07/17] arm,x86,fs/resctrl: Handle change in number of
 RMIDs on each mount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-8-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0257.namprd03.prod.outlook.com
 (2603:10b6:303:b4::22) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: 98b27a41-158b-46e3-79e4-08defcc379e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info: WqEG6uOaxEWFfA0B91fElJanhp3WTr8VNOfi6JGR15PI2xkmhEgRebTpczj841m9zPG9hO3hfxdMujCzOHVGM7gr6UhseHHEPMHd4FsW+6Cc6IstJLYydvgF8GAN08udh0OL0NNANeeq9CWYp0f91psWYJC49ZY75culNXxOA5Cd4lXL/aA31e1VdZHqtpWvUWzaqbL2LaxQZIANE1lKrd8C+FiqgVSe9JWCJHjwjLFAe/fCvtn2p6aKusjvQDNliPgJ+EsEntsyVhi9CF2d2g55Zdet6+4FVJpTck64P75MAUnlaWttM0qb2KmngmMFai909kJqh3cx3ijuqD4Xl9TyqgNzLQIKH8EFUFckdmN1WyNpjVoEtZY0Wtolz+K7wDrqkAsSKnwIvgPjC9cctYqCAW1Uj1d9+LeAWWKkRXTgVUhVpD5MDsZanLQObA1PIzx++4lA79nhwrMEQK5FTZIH4n+iuy8CoscwGQz4Fuyo09xxiLofesqFOeSZEFIjLdPnzvK1JP1u72017Hxfjt9HzvDtmrR6+WmWyoDWEtb4mG+SoRuNuh68x4J3/LkJxFqIXed+Crg7GpZWPqsovbBm7Ni9pzH6c/ixendOY41Q2BD1gaq8c4fYJRS5UQAAwMEx6WAX8Ut9wpKqpASqLkE99tzJDaNpXuREGR7+oWjK5XBF/3+gbLLh80Ky85xl7NIVtKZ6vhRVsb6brUrHLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnFIcCtCKzhEaWVzbEJKR0h2TU9pOVJSeFBlQU9WbmFBK0JnTFVyL1RXMTdL?=
 =?utf-8?B?OXVpUDdGamN6eVo5bW9lYVd0NThHcjdkV0NJVXhpVlN2S1NCTXdEc2o2ZWIz?=
 =?utf-8?B?Zy9mQWYvcFBSaE5MUW1GM2hSa29zeTlmL1FPd0h1WVhYTkhmWnQ3TUtmNUh3?=
 =?utf-8?B?R1dxN0o2Y0EzVGVDa0piNUdFaDRlNE80bjZsNWFsK0hCdjFESTNDRjJCNkJZ?=
 =?utf-8?B?bzR1RU1rU2tmZFRKVjFzWi80dXNhakY1QXlkT0xqSjlGd3RTdTFYcDhFSnox?=
 =?utf-8?B?Y0dUOU10clJjalN2bXFpcUM0VjY2VE91NTdxaTd4WlNnVHNaNVoxcmYwejQ1?=
 =?utf-8?B?NE9FRnFSdHFKL1NyTXlCQnRGbXN1SklPSUovQkR1QURWM1ppRCswVHhWVUc4?=
 =?utf-8?B?clhQcUlqYW9uS1lRWHFRakhJMWZMQTc1SitrbWJiRWtWbWtFOUUzZ1djQlFS?=
 =?utf-8?B?WnovVVFQbmtMT2Nsc0ZXeEFOcGV1REhJL0F5bk1MdGxhcnBlQkN2SlFCbW96?=
 =?utf-8?B?N3JsWkc2RGZ6NWpvQ3U0M3ZOQ1dlemhnTVhzRUhYT1FPVHlFM3lvdFNGUUZO?=
 =?utf-8?B?Zmp3VFdLZFVCbmsxbDQxOWxodlN0UHZ0K3ZGVU5sRlFUVnluemxzV3RNMUkz?=
 =?utf-8?B?YVRDUEg0VTRKOHVTNGlubndHZzVHQ1dVbWtjdEYxVEwrMisyU0R1UFdqTy9U?=
 =?utf-8?B?ckVMd3BZUEFSNGZua2c0Ty9DeGVLUWNNRXd1T0VvRi9aRUc0MDhNdG9XNHVT?=
 =?utf-8?B?bmNMT1huV01UUTlxSkxFUFNWK1BSWDM0TlFEYzEwelU5NWpLSmpKS09KNVpm?=
 =?utf-8?B?QS8rT05WT2JBNEJUTVZWYUhzelFGdmVEME5GSnFUbGdLSGpwRXIvUVplSDdw?=
 =?utf-8?B?enV1aGMxUWl3ZXZNRmVXTVVYV2V3Nm1uakJ6YUNjNzBhbFFDWEVYMGN6WXh0?=
 =?utf-8?B?MDVjL2pZMHh4TXBCU2ZJZUtzUFNoSUE0RWFoeXRCQU5GSFJueEZaeVR6aWs2?=
 =?utf-8?B?dE4va2s4UTczMmdiWDdXVHVlRmM0RFhWcmFPQXpaLzhmL2Vqa3JPbzd5QVZx?=
 =?utf-8?B?LzZ6ZTdUNW5yZmhjTkYzUmtvdUgxY3dYSjdRcm9SK0RTVlpndTczR1BrUVhF?=
 =?utf-8?B?MjBKQmRBaXNkQnZFQ2pNOGlIWWExR2hEU1NHWC9sTjNZQkNGY2xocXhJY2Zy?=
 =?utf-8?B?QnRVb01QN0gwUDRUbEJVajdxcm5OWENWdUk4bnFxQitubjlBbjNmZGZzN21F?=
 =?utf-8?B?MmRlYkw0NUZYRVZhazVnYm9NZXJHM2dqYUpZOWhydDZTbjljS081cnlkWHZS?=
 =?utf-8?B?c09pczZhMVc0YmtablloMUpwUk9DTVlTdm5VKzZ1Y1Y0R0NVTC8xQkc5WHlC?=
 =?utf-8?B?QUkrQWZ2NlBud1lVTFd3WDcxYmtLdWZGZS8zWWJOUE9OdnpNTHovY3grbWt6?=
 =?utf-8?B?ekJucU04SDQwSXVQY1lJUnVEUVNWajE0YkxYUW5JaS81U0cveVp2bEcxN3Ft?=
 =?utf-8?B?V1Z2UnI2K3o1bDErMzRsdnN4ck5DS1M3QVZXOTN0S1N0clR0WFJHcFJpVWkx?=
 =?utf-8?B?bUthc3FwQlhBY000dVRPNnp0TGx6OGVhVU5vT3IrRUxDM1ZjaisvdjZXMkFm?=
 =?utf-8?B?dTR0QTJST3pzRkg5eUdUTHJBN0JhdDFYN3luOVBjbmVNOEhOazFkTEgweTN5?=
 =?utf-8?B?TmhSaXNnS0lEaXpRMGpiNG5xT1Q3K2U1UHhrUU1wQkFpZ3lZd0RnQmYrMjRT?=
 =?utf-8?B?N0t1QlhRZW8wSGI3V0NtNDdNV00xdVIzV3VFZ2lMUVRnYWtoUWJNQ1VNY2po?=
 =?utf-8?B?Y1I3UnIyOGo1enlPNTZUSEQ1UVRIR1I3QXhlSmI5NUtQV1o2WDVncW82K3Ns?=
 =?utf-8?B?TzduSzdUbUNPV216THdabGwvY1RmSnFyelFWdWkyTSsyd2N6VzRTZGlOVkZp?=
 =?utf-8?B?UkRQSjQ5TnRpeFdEdk5TTmI1Sk1seXNNUjRMMmxqSmk0OFZyYndkRUxnb0M2?=
 =?utf-8?B?YU1LY2hCclkrbVhMdXhENzJ5WmhSRWhpN2U4WlR2U1hMSk5wdXoyMGpjOGRa?=
 =?utf-8?B?L0EwaHlUcVMxYkt2eGFmK0Y4UTNxMnFJdW1sNDVYQ3ZpQllaRS82cGxHQ0tq?=
 =?utf-8?B?L1FkeU1WZi9VWTVJdXIyaU5GSGNydllRZm5pcHBPYzRhd0Y0TENpWlhGWkpH?=
 =?utf-8?B?TjlKWmd3MDNIbkFQUzdFSE5NY3VYMlllNFRDZU9qVFRzbjJOTTZ1T2VseUZT?=
 =?utf-8?B?NUQzb2JKU1E3SDVuNlJURWg5VjNreGNvMlhQalgxdXRoTTRRbFY0TDZvRDRm?=
 =?utf-8?B?Ni9Wa25PQjcvVGtWcHh6OWF4dFRTRVJIL1lad1R0TUlFMDVCenlOT3N5N0ZU?=
 =?utf-8?Q?V/IUjim7b7ElCJaE=3D?=
X-Exchange-RoutingPolicyChecked: O8cVHDC7A5qZl1YHJ1OUyiA+RBv5mg+UMgYyW6OgkmWjoGMEe333PQA7a2uovJdOABX/6EbpCxy7f5B58xWWMS82XY0VCS6Kw1faoao4IniRLZnL3WKvDIizVmeGJ1BERyHFgdIzERnF89cmDNrnsr/COEWz+eYgVNIJ0iyoBe/UJ+dK9Q0Gxa0H5Vnoz6yuQtaHjvfdTCQPoW+wPeVCisQQtr5ot/+PCvNU0KneejpS9/QcjL9rlhRdkcQBn+4MdIZnjOfiw4lB3QLvOjLCb0/eLxyep8eaj2gZBM4DAeYZswkunuy/su1kKAQdzkAU3RvujhDq4+7P51B21sOYlw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b27a41-158b-46e3-79e4-08defcc379e9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:56:02.8696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HHCe5IA22aDM8sHvmo+qvS8y8TX+KhEknhdC9uCi7P8kkooSsMWvq/P4dGMh9HvPGQBXX3fR65b+q3WJWT1v/FGqsQ/bxZmzdSFMKjg+TOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> Application Energy Telemetry (AET) event enumeration takes place
> asynchronously. Linux builds the pmt_telemetry module into the kernel to
> kick off enumeration early enough that it completes before first mount of
> the resctrl file system.
> 
> Allowing pmt_telemetry to be a loadable module means that it is possible
> for different numbers of RMIDs to be supported on each mount, depending
> on whether pmt_telemetry module is loaded.
> 
> For simplicity, calculate the maximum possible number of RMIDs and use
> that value to allocate the rmid_ptrs[] array just once. Use this same
> calculated value for all references to rmid_ptrs[] instead of calling
> resctrl_arch_system_max_rmid_idx() in multiple places.
> 
> Also use this maximum RMID value when allocating
> rdt_l3_mon_domain::rmid_busy_llc bitmap and rdt_l3_mon_domain::mbm_states.

ok, but why? I have the same comment as v9 about this and I still do not see
why resctrl fs need to allocate the L3 monitoring state for "maximum RMID"
when this is unique to L3 monitoring with its own limits. There can never be
more state used than what L3 monitoring support so why not limit the state to
that instead of using the system wide maximum? 
Looking back at v9 the motivation is that "this works for x86" which causes
resctrl fs to obfuscate its implementation on x86 behavior without consideration
how it impacts other architectures.

resctrl fs already supports a per-resource resctrl_arch_get_num_closid(). Could
resctrl add a, for example, per-resource resctrl_arch_get_num_rmid_idx()?
If that was already available, would this patch not have used it instead of
using the system max?

> 
> The limbo code must deal with changes in the number of RMIDs from one
> mount to the next because some RMIDs may still be "busy" when the file
> system is unmounted, but be above resctrl_arch_system_num_rmid_idx()
> for the remount. In this case RMIDs that can be released are not put
> onto the rmid_free_lru list.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
> index 226ff6f532fa..7079870ca894 100644
> --- a/drivers/resctrl/mpam_resctrl.c
> +++ b/drivers/resctrl/mpam_resctrl.c
> @@ -272,6 +272,11 @@ u32 resctrl_arch_system_num_rmid_idx(void)
>  	return (mpam_pmg_max + 1) * (mpam_partid_max + 1);
>  }
>  
> +u32 resctrl_arch_system_max_rmid_idx(void)
> +{
> +	return resctrl_arch_system_num_rmid_idx();
> +}
> +
>  u32 resctrl_arch_rmid_idx_encode(u32 closid, u32 rmid)
>  {
>  	return closid * (mpam_pmg_max + 1) + rmid;
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index d7ad976ed503..2a1d2ee2b91d 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -75,6 +75,11 @@ static unsigned int rmid_limbo_count;
>   */
>  static struct rmid_entry	*rmid_ptrs;
>  
> +/*
> + * @max_idx_limit - The number of elements allocated in *rmid_ptrs.

To be more specific, could this instead be: "The number of elements in rmid_ptrs[]."?

> + */
> +static u32 max_idx_limit;
> +
>  /*
>   * This is the threshold cache occupancy in bytes at which we will consider an
>   * RMID available for re-allocation.
> @@ -115,10 +120,18 @@ static inline struct rmid_entry *__rmid_entry(u32 idx)
>  
>  static void limbo_release_entry(struct rmid_entry *entry)
>  {
> +	u32 cur_idx_limit = resctrl_arch_system_num_rmid_idx();
> +
>  	lockdep_assert_held(&rdtgroup_mutex);
>  
>  	rmid_limbo_count--;
> -	list_add_tail(&entry->list, &rmid_free_lru);
> +
> +	/*
> +	 * Limbo may be freeing an RMID from a previous mount where there
> +	 * were more RMIDs available.
> +	 */
> +	if (resctrl_arch_rmid_idx_encode(entry->closid, entry->rmid) < cur_idx_limit)
> +		list_add_tail(&entry->list, &rmid_free_lru);
>  
>  	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID))
>  		closid_num_dirty_rmid[entry->closid]--;
> @@ -133,7 +146,6 @@ static void limbo_release_entry(struct rmid_entry *entry)
>  void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> -	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
>  	struct rmid_entry *entry;
>  	bool rmid_dirty = true;
>  	u32 idx, cur_idx = 1;
> @@ -156,8 +168,12 @@ void __check_limbo(struct rdt_l3_mon_domain *d, bool force_free)
>  	 * RMID and move it to the free list when the counter reaches 0.
>  	 */
>  	for (;;) {
> -		idx = find_next_bit(d->rmid_busy_llc, idx_limit, cur_idx);
> -		if (idx >= idx_limit)
> +		/*
> +		 * Need to check all possible RMIDs, not just the range
> +		 * available in this mount cycle.
> +		 */

This just documents what can be seen from the code. Would be more helpful to have
comment describe *why* it is possible for an RMID different from the available range
to be busy.

> +		idx = find_next_bit(d->rmid_busy_llc, max_idx_limit, cur_idx);
> +		if (idx >= max_idx_limit)
>  			break;
>  
>  		entry = __rmid_entry(idx);

Reinette
