Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C06E346A0D
	for <patches@lists.linux.dev>; Fri, 29 May 2026 14:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780063713; cv=fail; b=d80k1Mhvw75GSeB7aG8rdD2BoKjLxPxjDbJIzU9EaL7OjK2F9/H6oNcVEfO+u6wxSKqHi8DOoDeXtl6d3BDaBrBK3YlPN14qAMvtmdbFh/wiyT4gQN/2okF41KKTiXdAnoTkkyEXMnVTyNLmD/tZvLEdH/FflGJoHAsNu7g/TOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780063713; c=relaxed/simple;
	bh=HgAH1R7InGlv17m7PSKrhRfB128iig3octsN7DW785c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BmrLtBtbTzLP8EBWA2DuYtdDXg9Fqly3QU3ytcMj5x354l/tqEd795iOomLXQrgtKXipzOzLpT1pCm+tEsc9prmvcF4cB06ZXgcnU3oA41sEVotznvuC3NMQvc/NkQsditC7WFHRkrCuwYBb8lGHTq5Ls+fpKwh0DCIlRpow1lo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dWdsUbV5; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dWdsUbV5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780063713; x=1811599713;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HgAH1R7InGlv17m7PSKrhRfB128iig3octsN7DW785c=;
  b=dWdsUbV5d/NLvsgaCgJiHvAQTxVxsKX3kW8OluKqNg2XAnDx9uT2cM/c
   L3tTrD6GMglmaQPETAARYM9UpKpCyTyOshyKWZjp11LZLPWBGW0jJ2BsX
   ZKf3xFt++XIym+Gneg3NjcYt8JExLLDqmtzjRD5J7vlUa7ipNhRDNW9tS
   oRvo7H8AcRjf9xAxfsDEUeH4gvUBCyaISC4islO4iWAeP3GwC93n3xEDL
   NnkKnXO0XAa+4SaDb0qWXfTHgMH0MvjkeU/d2U38gsREmsaDTcgOQorhE
   4S7y0fK37RgMxJa1lpthpx5nAjT/YxS61GHqo0KgU4xWj0Eor1ohHPpEy
   g==;
X-CSE-ConnectionGUID: mjVPuWUqTraqlIy6o10GeQ==
X-CSE-MsgGUID: pmnKGXeMTEuR62Ienpq9AA==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="92028625"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="92028625"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 07:06:32 -0700
X-CSE-ConnectionGUID: 0d5m86XMQni3X17g+XBkNA==
X-CSE-MsgGUID: yCopBKoFQBSEzLruS/vXmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="241821377"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 07:06:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 07:06:31 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 29 May 2026 07:06:31 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.33) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 07:06:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UXCyv44Nys3mCePhF7ouypR8dT5tPNYXx0Vimz+F0j+YsoVLgDJHL324b8/ZEcBpfbJoMQ/h9gZwbstXaYbUPaqaGWGQ+yhxgULelfWP1U++tarGXaDNF56I+OseQuLq14XyKe+Yh2baeoa5QRh/g6I3u/QzR8W0ZTE3uCaUQZpBZb7NmSNcSmdc2hBBclX+jQAKkYquz01QjP0CUcORZFHx5n6QQ2KNG/oI02DddB1VrYtx9spDUIFxc/RUsKbOLemEJkagB5F8xj8QNq0mOqEYDG2arala4n5RloC1spxM9G9v3IfF3ossLmaMiBIqngW08PUvobJN9N4pD0fVOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zghZZ+nnzW7sDZ3dMLgeswyNN/TOOA3bXQxdpyEoy8E=;
 b=t5VK5yR1ai2qkDESrP6wtekFMoPvqG9aEqRSLMu+hPNh7pEdWPfp7NKhTTZwvhM9h6PljzUnxuzX6jKkFWGR30xD2Lws7NHGp/PEz0C/CFKmZc7EudAFO3kKbwsvP3sT4JjYJBjOijRPg10rJUBvOwY7aVynY+FcmpFiZTc3qRT7HiopgtOyFL3N+Y0I0vM8OT+WGOUJTn2Us3T6GEgOOncZTddzTauCEZtUSVizSoXwPWpSfe36V+nV4gpZRMA8nIT7wXOojbHjI12wH10g0hFj87FE5k62QMP+ROGAYWLPXjFG067zbVJorNqw39UVtEPSq7OmQD9C1ijD70C6Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 PH8PR11MB8105.namprd11.prod.outlook.com (2603:10b6:510:254::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.19; Fri, 29 May
 2026 14:06:21 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%4]) with mapi id 15.21.0071.014; Fri, 29 May 2026
 14:06:19 +0000
Message-ID: <6140c3f9-b172-4552-b96f-1b8514b0e75b@intel.com>
Date: Fri, 29 May 2026 22:06:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] fs/resctrl: Fix deadlock for errors during mount
To: Reinette Chatre <reinette.chatre@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<tony.luck@intel.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0005.apcprd02.prod.outlook.com
 (2603:1096:4:194::6) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|PH8PR11MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: 17c41c52-5cc1-4ee9-4736-08debd8b7507
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|18002099003|22082099003|56012099006|11063799006|4143699003;
X-Microsoft-Antispam-Message-Info: HrNAlvXMXSt6VzolYQmFmj1WDmUcLe4ryn2Ch6DxMp7KyUspmIBA48qieLXPjtZ1Q6+dFXQ3yyrNpqyQvOriEfKPnp+tBkDuzpCcLuyODPMNSJ1uGfDlba/ZmITy6goQgvkdxnz1zi0yzWd0jMg2WgA3JY3J4F093PikCmMb8xA3R8mFpSVZBNN6UVrnC2FNhMSUqbYwfrtwMH5xIUW5NmNT9utMGe++TvOcJDJehcXsLATTqdTwehyzmdsoARHhGk4GtmbC74jS2hYPfWchXFSmEiYEx+IYqtZcpZwzpPeMGp7MPcr5r8h+TyS4MYk5dxZBSXpBHfu19hiIAKuFR+3nCDaDYE5nRa4jxxQADup3XtsGTseWy4ckt3ykMN6FtaRZZUxLWEriombRhfDDUWwvmVyeOXRW48nArUIMTFfZ7JJY4z2SXdfZlahAjABj5XOwDWZm2AWU04i+QSNxJRZtWI/jIt74SvQ9RGIcaAxl57jtTyIKUWrRcTHEwMjQM82Ri/SrAZXPQUlyfMZ0HTuExdBEsLpeZ4JXM9v90+wKDXsXVewVG/Dwkz88RLfiZBXbH7JE4alP/taXdh83q11lhNQKHnFDy5xXqy4mv1ZrTuhbNMoSpjFCr419eyIAhCOp141sTrP9tmVW46eN/Y45fkl8e5iWLxy4qWNU96N47ERPZtswIJw7A7sa3xVNLGryglkw3yHzWyCA2r+RKg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(18002099003)(22082099003)(56012099006)(11063799006)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0UxYTRPenlhMXkrZkxiZVRvV1JKemRkZE5yTldUL3YySXRaSDFLTVBwNXZK?=
 =?utf-8?B?QTZ4K1Z4MGFmSHBMTCtoSXNMYndXQ2hmSVJ4RldCNkFFSzcwckRGc0VoM1d5?=
 =?utf-8?B?TUVjV2Y2V3hhZ0p4Zmt3VHZuM0QzWnZGcVphNUF1S25XSTZaUWZNRU9jNVQ3?=
 =?utf-8?B?M0l3b2YveE5VQkJTUWFpR3lPemJ2MVV0bmpUN0pJaFhzMUZCQ3hSN1dtYUhh?=
 =?utf-8?B?TXhkZGlwQ2QreXE3LzI1UjZVVjZFZjF6c2lwL3BDMGQ1VXpiMGZvL0xxK2I0?=
 =?utf-8?B?NTl0V3JhcFRCQmx3TjRLV0QzMjJzeFRtNmZNRlRUdFM5U3oxMzRIc3J5TUFv?=
 =?utf-8?B?RkdNU0lEbDZoaS9BajJTVUNmR2pjcU50Y3BURi9GWjUrMUl5QlFRekpId3Qr?=
 =?utf-8?B?SFRhejhWSGVBemlyY05GZWtrN0VOVkJyUkF3Z2dkai9BSmVzcXBKQVFtZE10?=
 =?utf-8?B?QkZXbkNWdGY1c2JWb1llS2dJbmxLVnVBOGRNTllTcGhienBpYzdJZk9EOGxy?=
 =?utf-8?B?VTZ5NDFZS0ZIaG4xajl0dXlFLzFtYnBzOTBQeWZYZGt0aFFRRi95Z3RJU3hk?=
 =?utf-8?B?L2hzdXRTUENXOFc2N0t5aTZrcDhuNWJhYWVMTjlmemIzWmprb3N4L25IQjk1?=
 =?utf-8?B?Y2ZSdVYzN0pnZFRpWWp0bUZPbjlrK3NxZE5oc0RrczVvMHdRRnQ3Zld5TDdU?=
 =?utf-8?B?SHpLWjc0cW5udS9ucy82L05jZkJIUjdJWHJkcnZteVZKdENlaFd1MjdXTVdj?=
 =?utf-8?B?TTB0bVAwVzJWOUI5TGlRU3R4VTZvT2ZFQ1pIaSs4b0EzOXdaTk9GbCt5SGp5?=
 =?utf-8?B?Y2hFdFBCTzdESDZWNEhjTHFMSGhSbmVJUzFyOUVFYk1kSnNLdEhGOXVQZk15?=
 =?utf-8?B?Z21NQXIzWWE5V1dCVm93N3M0RlNlRWJmYzIyd1NseERMYzlvUWJwZXRrcE9B?=
 =?utf-8?B?bDlXWUdTK25xK0ZJREhvUEw1ektML0hlUnBvdTlhenlEU0VQdjlQQXVVYmtE?=
 =?utf-8?B?UTRwVnFQNnZoa2NnQzdnVngxTUtzRlIxdzk4T21xZGM5dEJsVEFVdVJPK2hL?=
 =?utf-8?B?alRSUUxqWFpRYjRrRmVaMkZLVXBPaVBnYURJM0tvdmI1WmNnblBndFEzajFh?=
 =?utf-8?B?RXgwbDRGNW5WUis4czJITjlhNVVPYXNzSnZQUitWVnZmTGg1Ky9mVXd2L1RI?=
 =?utf-8?B?dzhsdGdoMDI3K0hVdytzQ1Ftbm9UeTBNa1FmNVhEZlFZTmQ5UzZRT3NLbGVy?=
 =?utf-8?B?aXVxV1lCcFNPbFM0Ri9xcVdHTzllazJnUTdBOUx3NUF6ZS9KUVloOGtMbzYw?=
 =?utf-8?B?R1htSUJnTkJzR09YSlBvK1JrbFZkWmVEOEJySm4rRjdCSnNDSmZQRzllVHlp?=
 =?utf-8?B?bFcxc2M3NzVUZFNHclNrUnNWeGtZQWpUMVZtckpydkVaeWFmRVRWdlNHUzBP?=
 =?utf-8?B?c3AzSmdaMVc3R1RrUmp4QkdBc0xvcVhpVkZzNEpVeG5rMzFWY090OUhDN084?=
 =?utf-8?B?VURKbk55cjAyWnk0QkZXV3VKVWFRb3daQTdaN3NEMVFwWEJXQXgwamYxeWt5?=
 =?utf-8?B?UU1OVVZMZC9EcjFuYmtqY1FuUUJWK3Q0a0Fkd3JBOHluL0pLUFJpR1ZXUkxP?=
 =?utf-8?B?MjRablNEbmV0dVkzZEJNUWJtQnhLQUxrQ3FTYmdPOTJ5RGcrU002Qk50SDJ5?=
 =?utf-8?B?WDAyQmJKc3JRekxsczVpc01kVHZqdTl2UGZNT2JNUkRNMDZmYncxNGpGMDNo?=
 =?utf-8?B?eG9LaVdKZHRaQmcxdVpBRTZvcjcrZFdvTk1IK041bm1NWmN2VUhNSGRXbnBJ?=
 =?utf-8?B?OC9JQjZpSUgwN0NSb0FtRGxnNHorS0JpVFRySVNtK3YvUVdpU3owMUd6d0tP?=
 =?utf-8?B?SlBiWW9HTlJKeFl3UHBTTUsxaVQxS3lvalRMTGNuZ2ZaS2g1bHZSOVV5Tjgx?=
 =?utf-8?B?YVVsaWVDTTZpZ1JmUEs1eWhvVVA0ZzErR0kwYnRHS3VYcXNZWG04QXNhWGpl?=
 =?utf-8?B?N2N2NnNBOGlRZkxtTmNUbU05YVRiclRJSjIyenRKaTdjNGk5cDg1aDF5RnFV?=
 =?utf-8?B?dmFBUjR1QndlL1JCQThyQkl6bGM5NmhmVjcwT0hFVkV5TXZtT0xSZWdoeHlY?=
 =?utf-8?B?aGFZSzZnbTlHM1VDejU0S3dMMUp4Y2NMV3d6dzR5OHVxWlZReStRb3hnN3Bj?=
 =?utf-8?B?eFYvTDdkSklCdU1PWXJ6K2ozZUtZMEZzdll2alVtRE5aRk9kY0prQ3J1Um1R?=
 =?utf-8?B?Vm1rb2RoaDhGR3E5Mlh6dnNUcjdQT3NuZzZQcmc1SUlPVTZ5bmFBNk4yb3M4?=
 =?utf-8?B?UnFhQ0g1cFVhV3Q3d0p6WHhIdU4walZNWW5ZaDlQbXdsSUFZOTRpQT09?=
X-Exchange-RoutingPolicyChecked: YpC1VM6Qyhidg5hhXXMMXvjnM2uajduRDw1RV9cb5VQrRkLh3mMH7/x6chi9br6y1AQLtRCtoy9rnW6lNPaIYUqBKLw6+AN1iKJdayz0vP47tnrOB5YNDhq4QfgNA99onquKNrl1jIYQNkyC6WqZjGHEcqocBoivINE/5foGYjLHjZtcylkl1KKFdgyZGfrYUZ7qABfInAiQ67vqZ3tp3Cxi9D7GEopziSztk5DrX/as+dA8C8Q44jB4P5gWPJfONvqRU6bDeD/rnQzvtwspm0adZDc/TAmF1Umk4np8xxiE/gWjTxHc1dM7NrKhgco5ifXnr1DZwhHzpvUCYzV82g==
X-MS-Exchange-CrossTenant-Network-Message-Id: 17c41c52-5cc1-4ee9-4736-08debd8b7507
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 14:06:19.7859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RU2kDPh8M3wYxqDmnsxpqh8ake/THGFlH95YbPnP5k+XFEHWQFZaaSh5yX1uuuvoG9GwVnxm2Zt7XU8/KwqwfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8105
X-OriginatorOrg: intel.com

On 5/23/2026 3:15 AM, Reinette Chatre wrote:
> @@ -3085,10 +3105,37 @@ static int rdt_get_tree(struct fs_context *fc)
>   						   RESCTRL_PICK_ANY_CPU);
>   	}
>   
> -	goto out;
> +	/*
> +	 * Ensure root kn remains accessible after mutex is unlocked so that

Maybe a little more accurate to say "Ensure rdt_root remains accessible"?
Here we increase reference for rdtgroup_default.kn, and protect
against UAF of
kernfs_kill_sb(sb) ->
   info = kernfs_info(sb) ->
     kernfs_put(info->root->kn)

where the info->root is UAF rather than the kn.

Other looks good to me.

Reviewed-by: Chen Yu <yu.c.chen@intel.com>


thanks,
Chenyu

> +	 * kernfs_kill_sb() can run safely if called by kernfs_get_tree()'s
> +	 * failure path after creating a superblock but before taking reference
> +	 * on root kn.
> +	 */
> +	kernfs_get(rdtgroup_default.kn);

