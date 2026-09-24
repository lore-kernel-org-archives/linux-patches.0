Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 158044A0EEC
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263729; cv=fail; b=DYb+A6ujc8Jx+2b61v4rYNu5uK+HdtmrzYZqY9+KfqiigxJYUy5x7dCqjvVoORqVKIID7toXAbIdJmqT9J9KDCV4X+V/E/Jp/LKfd6IPk+kaq79XXl3SI3ImwJGgK2CrHKljSvvr3Rczf7nUqR0O2bt0iZZIITteSetXD3eoAao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263729; c=relaxed/simple;
	bh=d3YuUROPQ9Bz3mm0FRS8vu6ytCqXDuFFsdtTyaxVjlg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=oCBxw35/cJFp5antC4c8L5kZ2PWOIfifm/jwo1mCwSeHtQKV27g4wt2VCLHHFbogo4TbOG61JmfzsQgONV4aUpB/bfn3QzS508tAbzVGb4GoGGFp95FsE6CDgOOqnmBU5fP8eo90C5d2V9KqZa4ejJ/MIp7Pgby+Dej91LJC5LI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P60JhbQj; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P60JhbQj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263726; x=1821799726;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d3YuUROPQ9Bz3mm0FRS8vu6ytCqXDuFFsdtTyaxVjlg=;
  b=P60JhbQjChWTRmg2Y6WahxJAPI1GN/BcfvnxapSI69KZlh5HVa+Yp4mV
   PbKw4k/iS728efTs+axRLIFbE5qYTvVS/P95J95YQxT7iL+KUmP81NK36
   q/1eW3Mqw1VxElwdDPz6CCyTiD1RgLEX4h4/0q88/HGkEcnGsHOchF8SD
   5EayhUNIuT7mfZxwhPsetYE8LJA8Nk/S+HZwo8COBxJI69zTh+njzWcMB
   Z5jr+TvXzvyyTtArfgU3qUCxL/cyCYOL0Ecc9htNyWj6y7zfYeVhQ8XCL
   MPzvXlHoN6JxhQFERmnVTlGHFfu5kmiubcx+0I+lQP6HnbsfCqFbNu/aK
   g==;
X-CSE-ConnectionGUID: 5nzBPhFpTcajnNJt4FuL4A==
X-CSE-MsgGUID: LyfAZiUsROywViZ7t6vhNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="91144782"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="91144782"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:28:45 -0700
X-CSE-ConnectionGUID: 6XNRf7ADRwSXfbYPssE91A==
X-CSE-MsgGUID: CEaZOLEOSimVleGAZjDkOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="273173671"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:28:46 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:28:44 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:28:44 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.3) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:28:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HMtnheJrS5YsOjOcqpZmWjyStyU9GA1ImmabPcjPvyfHr18Yv+JH2bstbyphJmL7kWvaKgb0Ektyo+9EWcPF6XQnrbmkNszbJ2bkPdcj7s9LAdAnzfzpTEZNt2aWt71avrCgLwOEy0wGkIJSKocS0U60G/ebFtuJuCPesAab7ApXRhwprXpozGcaR0BI04NSBago3zzTtZdx/pL1nFVnP8qivaQHXsUD7HOl5z8SPGBB7HPgvh4d+OUIiDdIcRmMRaSqIOKNXWmOLx9bMBvMq9o0wC7cXxLHZHuYwD/fHNOiYLSo+ww4mWZNe5jQI2MRoZNOxS8T8O+02g0F11Lhfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8ZgFJvs0+M+2ldmMEyhUOV+oRwXvtcUA0FvXIUu6fA=;
 b=xsGmPsYtMhLO4oFGZj/+nuDsnyxNHcgXKqV+5vzIMNX+WX5Z4zuJMzPBrBm1d3J7g//lELlL4A7kAAUenSXbIdwOFiP/njTVGGkRqsIa3TiShx/Y3WR7a5Gvzb/GUfgdZ4FkitS3CXb3HR3b/dr7PriL9i29zv7boj5n78VjeduFCvOGGTLUR4/GQLP1IJUJSQrVV/5XLRyWr5rVgsYYMyrcX4ogoxedtBdNb+5LlEa/efv2ltVsA7kh224uUsqVe9UgSHecmqF1rbnHi5GtbAoJuhSvPkZsCpvOTEfuzfCo5WGnMBUb2fx2eofDmmxYm9nPVM7hvxNkEv8++YJ5yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN7PR11MB628000.namprd11.prod.outlook.com (2603:10b6:208:5f2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:28:42 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:28:42 +0000
Message-ID: <9f34519b-6c1b-4c38-b3f7-789b744166bb@intel.com>
Date: Thu, 24 Sep 2026 08:28:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 08/25] x86/resctrl: Delete rdt_alloc_capable and
 rdt_mon_capable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0043.namprd03.prod.outlook.com
 (2603:10b6:303:8e::18) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN7PR11MB628000:EE_
X-MS-Office365-Filtering-Correlation-Id: ef47c0e7-1a2f-437c-0ed7-08df1a5083ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|23010399003|10067099003|5023799004|11063799006|56012099006|4143699003|18002099003|22082099003|921020;
X-Microsoft-Antispam-Message-Info: whxympvm41EDMUZCRBduKKwa3NMHPjl/GV+5C3RvE/7lLq6EMRTiMEIf3X7Sp4rkJUB5E/YPcigPR4Tz/WyBsJayROHlapDBR2ZgDb123klql7iG4D0l/Mm+RULWELcKi17SgTbGhy2ShnMG1POdXevmpGxl/At8fQEfzkzSMGmEm2VBHxOj5y1sHGKIn6oPKY1AQL5/bmFBqEdlPHzY0kSZ/514v94CRXd4F8tZ02jH70u5RshO70nRX4rNM0VdC9H4mwx9+18qF7obEGlKf9Csvm88le2BiM1fK0pQtphyaNuoXEJpl7WgDcceQjHoZd7Xnj2EebVPm2uN11KC8UZGiONZJlX1qwpPMHQ30XyfdlqbmNCwNie0IvGmGvCMvisPlOF0zMdqxiMhGlP6pi1r9zzpAcHjLAFDQTx7iPae9+TAyL/P1M49A7ZS39DouuwNR8zuiwwhVR7f6WYPFYrtL7eOpvJF+oJ6yJwpvrCd4ks7dlfth9JRO6Nrq2k3cfNhLpOisLh26Z0dyjmSL1FobY2h9W/SmrWhTWQK5NAPbDqr2wiP5Z5uSB1pyImfaG+3p236xarl/v4TkihZGnQb1B77q2680UVg1H/d1EEVl3ylxx9sqvPQDNNorW6ccPsEqkDCeqhBv7RnQ5uX6FWsHgNRb85oabE8ENBSQkW0ry4KonWkI9ts15O1MZXtbd1Eits5A9g0w+4seIo8LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(23010399003)(10067099003)(5023799004)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V01LSkVxRkhDYTN0aTRvZXN5Tk9sNUdPUWRiU0tNSnZyN0hxS0NHV2Ivb3VN?=
 =?utf-8?B?Nnd4YVpoK3ZXR3VpcDAzNzJoR2FMelo1aTZpV1YrS0d0Y1R4amVnWi9nUmlx?=
 =?utf-8?B?VE5sS1pyMEF1RlZ5V1NwWmllNUVUV1NXTE5PUm43b1V6a0RLVmRDdC9Nck4x?=
 =?utf-8?B?WUNsNmVBbGRabzlhMUd6RFNWREtVazk1cnlsUUw1NFRqMlpyN1ZZdjJrZzcy?=
 =?utf-8?B?NHptSHlZa3pZd1dYODlWdlJBaFFETjJlM2tqY1h6ZFFRREtLSWQ1K1ZZZ2U4?=
 =?utf-8?B?WFB4dmJWYTdhUXN2emJEUlpxVmdCWkJVWE45QUtpdEFKN1FoQU1VSEs4ZkNo?=
 =?utf-8?B?ZmYrZzRzaUNjTjRzK0hxRUpYU3RKWmNFb2Ntd3dDaXA4VXhteW4vLzJncDVS?=
 =?utf-8?B?NmdERGVlOWQ2SDZ6WG9ITGVCR2RXdVNrbERmc1lWL0xNcEV6U3ZYcm9FSmVr?=
 =?utf-8?B?Yk9iTlk1OUNNTW5RSTU4cERXbzZ3QWJ2R2diMjRYN2JmMTZFUlU5YzIzZ0dk?=
 =?utf-8?B?RTl0SG5XUGdpajJsNG9ETy9sOGFLa1MrOFRiUFYvQ1V3WXN6YmlWc08wLzdJ?=
 =?utf-8?B?UEpId0dHc2dyWi9ObU1wMnNycWliQVF4eW5lb0h5SkVSK3hPajVIYjVhalhw?=
 =?utf-8?B?dTArakE2dUJsV1Z5Vk5yS0tLdmlaR0pSVS9zSXpoN0UvQm05bXZ6eHpaYnJV?=
 =?utf-8?B?OU5jK3I1b1VmaHRwbzdndHIwY1hyeDhtMlFuMXdrVWZSNzE1eWxzem1HRmgy?=
 =?utf-8?B?aTF3MDVyQXdzeHN0YjRZdnlnWkpLSnVyNkdzZzk2UkhPRHFaQjJTVUhVVmNz?=
 =?utf-8?B?eW9IM3FWaU5BQ0ptWjNUb2dQK0U2VjRNY25CclpkUU9aU2l5Z05LWHhPWFpG?=
 =?utf-8?B?cEZIUStIZjMwUHVpbGdCZW1MSE9Nd0hJUHNaUFNESFJyOUQvL2JjUmRHMG85?=
 =?utf-8?B?SmUzclVabUYzK2Zxa1RFVTduTy8rdmFiU2tVNG9hUzVoOGhxRWhqc2Fzc0ZT?=
 =?utf-8?B?WFlOQS9oSDVDNVh2UjJ2VDZ5Rlp1dmM3eWlQUDM0K3hvL3doSi85OVY0d1Vn?=
 =?utf-8?B?SlhLenp3Y3RyVm51Q0h0dDh6WTVBcmo0eDdQa04xUmRGZ24xamRJY25kbTYr?=
 =?utf-8?B?eUJOZThOUjM0S3hvSGRCZjZsS3FOcmFiWGY0ZUNsRElNai9DWm5aOTAzbnA4?=
 =?utf-8?B?N3dwUHJ6TUx5WVJkOE1oZWwxVnhtaWk3bHJrTlJiTWRlRWplZjlVbTFPalBk?=
 =?utf-8?B?OFVjaHd1d0FxUkJVOTlJeUVScGZIMW9RR2xaUG4rZUtuSkJQTFlvam43eStF?=
 =?utf-8?B?aGIvcGNwejhSMkx1QnRHRWtLU1JJeU5Zd0d5WEFUVEgzRmM4KytMNlZTbGQv?=
 =?utf-8?B?WGJ0dGhMLzhsWkZIaTQzZG5aWUo4TjJKQitPUVFENk1LZ3RPdG9oOXRaS1lQ?=
 =?utf-8?B?d09ldzR5NWw2NzhNUnh0UWNYTXFINzlnOUdrbXV5VThUTFBIL1hIcHMyVitp?=
 =?utf-8?B?ZmRONzZtejBDZ0o0YnVyM1dDWnkwcjZvcDhwa0w4NWZBQWRld3kyMjBRY0N0?=
 =?utf-8?B?dmw3UXdLZ0tTbFE3NGF5UERVaDBTYXVpRmNyaW5xWUZVRTBjRkNnWmdKeWlC?=
 =?utf-8?B?U1AyTjJFTEs3NFZYTnhXV3ErR29mcFZCUkpmREdHbitHLzJtYSs2NWpMTmpM?=
 =?utf-8?B?Y3QzYkRFMVVkMWtuOUREN1RWbi9pNFpWbFQxQ3Ric3RBUXRVVkZGLzdTRWNl?=
 =?utf-8?B?L0xYS1ErZEg5SERWSmdBc2V6LzdhZ0hTVWNQODJqNGVVSGxJMUtUejk2YW5v?=
 =?utf-8?B?dC9ROXQ4RFE4MTYzbmg1QXVpOGV5dEYxd2lSQ3VmcUVZVk55REZVZUZwZXhY?=
 =?utf-8?B?eGcyK0pBMUtvY05mMlc3a0MvdzIyWDZxZmJZYWlxRnZmVzNiT0lzckFrRFhS?=
 =?utf-8?B?OTBPM2phNUNqOWpwV3M0c2ZYbGFnamxSZ3FONGtrYisxYVNKRzc1dG1BelpB?=
 =?utf-8?B?MzdHTjBqU3E1TUJ5Q3YyMmM0SkEvU2tNQ201ZmJhMUsraWFoYnF6QnFzL1Zp?=
 =?utf-8?B?SUYvSGYydG4yaEowcllUMHh6VlpaTWYvZmJvR2xJaGVKbURKcFRwMEpzd1VQ?=
 =?utf-8?B?QmxUSmMwcVMxR3NCdkJFMkxqN1dWKzVBWnE3RkhzU05SckxnU3Y3MTlDUE9X?=
 =?utf-8?B?ODRhaVdteHNZdkRiODFCTHBJRE5DK04vOXgzeDFmWEpaVXdTbUR0MExUclRu?=
 =?utf-8?B?d1JxUDJ4disrR2UwU0YvbUE3aXpwdFEvYmV4WkZick05VWFaVDdUZENzVUV6?=
 =?utf-8?B?bG11c2xBNHZ5czRMV0ltTFFGaDI5VjBoeXBXcWR2aVRqbVpqa2xYWWVacGJI?=
 =?utf-8?Q?r6HkNoBXi82eL41k=3D?=
X-Exchange-RoutingPolicyChecked: ApIqEqMu472QAgh+8DfF5oehAmR6Kv0hWGA2mOhOchgvrxv/u25IRY1UuNJVNw3Cs3gzh6GABFfAL+V+b85UquJvvf9zMgBg7hdttgkM9HqBGVXTBA7bapJrURd2O71LJ+fBO3sxFnsPR6OojFGCICDbTE0yBzYHyWx4NjxCrlhixsSCu08cqTMhr0zk06ZePc13oaI2sDZ6HaRXGy4Ew+WeQWXszt8HkMgCTKCoHgr0N7cFj740HftoEUx9CDd2DFOv2t3C2MaWnpRkApJWnBxlIL6OJ/jzAhyu4BqpExNeMq0fZClvfCDHe87F3GJ3d0+k/S64LPW9hz0jT5jlJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: ef47c0e7-1a2f-437c-0ed7-08df1a5083ec
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:28:42.4262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RVxWZ591pvoXjylnnSa+btsu+OYtUoLlVv/R57y9Cl2GxiEOdTAPbkA76MTf5E9TArlgYOpMLufX/IG8DN6UZqrh9wV0DJ2TS1blZ4fkao0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN7PR11MB628000
X-OriginatorOrg: intel.com

Hi Tony,

On 9/16/26 4:13 PM, Tony Luck wrote:
> These globals are no longer needed, delete them.

Reading this from a git log one day does not have any context. I think it
will be useful to add at least one more sentence that highlights that these
globals have been replaced with resctrl_alloc_capable()/resctrl_mon_capable().

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Patch looks good.

Reinette
