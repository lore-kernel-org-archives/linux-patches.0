Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CC43FD14F
	for <patches@lists.linux.dev>; Tue, 17 Mar 2026 18:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773771002; cv=fail; b=Jc9vEV+LyN0GPhbZmyvr8EqPkvLzniKqc9YVQFkNIMBvNfe9VAXvJ+ef1QSW1fEdxnwWhXDnenuKoW2aywUQI2iYblOu0/iHyjPq25vUoC8mRgC3ZMn1619gCacjE457N6V9JnJm8TRc4D8aG0tLH9vwXzo1ZKuVdDA+N7eJFOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773771002; c=relaxed/simple;
	bh=AUnmjljDWDQSpH1v4wEojiTZ1+lIe7Pf40VzIY3lbaM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kgf24bXrKo/XZNZtk/AMtAj0GAig5mo4i+CfSk3TsBthbrB4EFPmmP/Bdhsk0LJZqAj2ymoRB61ONeJuNWtLa7zyWV2VnId3Rsn3ffQRrE2SVrCfnLXAqQ9uDM6VeoX/bkUIPa+B+Dzenti39bfjsumclI5ErS2qTrZskQFjuRI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mXm3Xiku; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mXm3Xiku"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773771000; x=1805307000;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AUnmjljDWDQSpH1v4wEojiTZ1+lIe7Pf40VzIY3lbaM=;
  b=mXm3XikuGClDsio6yLr+yGlGXDJ9YEAwn0Mz48HomvUyFFK0ZEV0NCyR
   QzQHy9L5c/7D+U+cknHRom2snaqQq8vOi3qXO/EQ3/ornQhG1Fux2POkH
   yBBCCMMIIdqvZFUDkA29ncU7f8taArWe4edVTq9rAfsQ3YczuPV99PKMU
   iHyWgb031JPpWghw+847aamMLMZNJlgJz8zUvfFtSXAA4Si8rV0sK+k/t
   eZBgyqGxK/NgHd6qQY75sHi2vujwgj8o3kBFpAz5s0jdsnhlplEYFSFpR
   /au+RrXVN1k162hURlrBLnpFM/ncl4scvGNHzM63OhHBh2dtpVoc2hwRy
   w==;
X-CSE-ConnectionGUID: S4XfvtiLRAC3VhvCIqLIzw==
X-CSE-MsgGUID: d2eOk9fMQbal7vBmqBkbkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11732"; a="62377603"
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="62377603"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 11:09:54 -0700
X-CSE-ConnectionGUID: eSbShMBGQGqXbBMLfF2ixQ==
X-CSE-MsgGUID: A2D9so7PRT2uJT46Ocp6aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,126,1770624000"; 
   d="scan'208";a="218457459"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 11:09:54 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 17 Mar 2026 11:09:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 17 Mar 2026 11:09:53 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.69) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 17 Mar 2026 11:09:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=epb/i7EdVKmTl5XSN/XhNhYEne6od/PCNoLVX3cN79MJsmB6TCDB2ycsuz/47lAdcyf5s1rC/zNbFUa6Hbw7HCVz9OI9WpVm1ez71hiqqkkaHDArhe61PH/b8PlVI3wCeo9fkt2F2Tls7+lZFBHMhx/xeVsCBs2PZ6vGGLfZtpcm60L5PMfzjbDsYH0+tCjGRJrEU5LQ4HRwy+jyS77/H9Z56ACY5uV2PQQyBTVjdRltR2QjOxD0+e8b0nbZni+EaKzWvgvajmofCbdiw3fDRlqFLX9MCkngL5xx4zcg1P6zJGlbxn/VzgWidetQq+ntOxg4eWLqJYLHf2irXEkvpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=njZ/k+WP8FcGMV3eprycgmyw2f26rgoK3lTE+H2YhJE=;
 b=FvQJkcXxKTcN+il1Fcs9gqqjfK7bFVM/UKCanX6N4/NKcO/mVlmN1rr8k0INtm4ZERoyahsGfnyc07FdeVvbPxZV4hecBTEWpsMIVdEQKLx0b9MzSxD4gPytabr99zBffiCf0gphuNd75uCMAvkK4qrsuEplK4SSXL5q1b7/5P/Orevej3BpP5DXQQgqtYmN+0Z+rPjxoK2qOs1ken1WVwcu30u+vY4R9/UZH47g7/j7SoQ66v+TNuOr+UKPvifIckGdssbrTatmovcq7SJ64+vnn9xabdB8PWlLLzY5s1QeZhEl5iiGc3Ti3OiIzVkKss+T69hh4oWe81VukzkZyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPFE241D7F14.namprd11.prod.outlook.com (2603:10b6:518:1::d57) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Tue, 17 Mar
 2026 18:09:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9723.018; Tue, 17 Mar 2026
 18:09:50 +0000
Message-ID: <f37db924-dc65-432b-ae48-ddd986b3efd9@intel.com>
Date: Tue, 17 Mar 2026 11:09:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
 <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
 <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR01CA0037.prod.exchangelabs.com (2603:10b6:a03:94::14)
 To SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPFE241D7F14:EE_
X-MS-Office365-Filtering-Correlation-Id: f810e73c-1f6d-4e07-6a6a-08de8450613a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: awOFA8Vql9xlke1y0kg/oQzzRsMXSjDnG2irUhtbvjZEiR4JRWP6BwwSErGnlVEBso9lOMAbjq1uBCKbrRD0s/zZKghunxNwMuczshOM4Ml2YuYwfo8eG5nYm43gkk0vwcJJ9Bt/nkHPRXpboXg5vxJvim3UPKLwCbXYcbk7mLUFTDTBSldazRCn2Xz5rq/pDh3NSX+MctJrm3ES5uBpGbcZIiYtyfqeoWR8BGw5HgLrYlk8cMU88wEADqRp/uELEXNAVAqIQh25aUY6/SheoYB7z5z6VZ5kZ7LXxnsYhGBP/4LI6wah10lgoB8/YkBjCaK6fP5OaWepLxgobx/P06scGepRQHW/BNEgwllHdIjeItR1b32cZP8zBW96p1n5vue2jiFmWKr7N1M4tU9XS6tisWJL4eIt31VYk9aOm8+aZs9TSDBQUkw5naTVcwXnbqhJ2ZReMKqCQLdgJ0BQr/xZe7W14g6u3C11fikMwX4jNsyltVZBGPC+LVp4r28s4pcY7dPEcg8imicUzK82X5R+IHBtodgoi/Y3ONOU5XNvIo510+PvZDeNZGToBlFO676WyBfju3I1TBEsjTSpqjNo0POwEeEwoZW/2QH5HQcrxrToncS/+SzlghFwUzNI450CXl2HZ28EMFIE4vHguFQ0Sm9f4Ijd9IxSPGAkmF6Td1zYHMSwWTtAA4QBZtf3t3seGqRXOxYyb3F3jeYW4CqqmllVe5z1rpc77Vv1Xw0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVlEUGRHS3JZUE40S3JpYkIzUkRITFVXTzh3TEhKWHp4TzgwcG1XTUx6N2ta?=
 =?utf-8?B?d1NrVVBXdTVMby9MeFJNRFg1cjVvc0g3N09QOFpLak5jNEJ4eWtnMVdPNWpS?=
 =?utf-8?B?THBqNnB4dzUvaCtiTnBvSkEyT3Y1NERtYkdlL1FLZVZ2ZXZhdVJMZlI1VjJr?=
 =?utf-8?B?TDh3cUNuYnJNdzVybDkvL0tMZytQT1hQMmxLemdZMkNPZlpsTng4WGJBZTlB?=
 =?utf-8?B?a3B2cGVJb2NxL0JlWlR5dEFkZ2JjaFRMaDUzNy84YXREdlpza3NXaXA0RWcz?=
 =?utf-8?B?NDZsT3RadklEWU9vZFZUOFVVS2ZGM3MzTTRoUHE5NE1KTGMrdDFpbm04Z3BD?=
 =?utf-8?B?UUdPTDl1Y3lBSmNsVnFwaHQ1aVJ6aXFpRFRkUDB6UlVPa2R1ZStycStmZ2VT?=
 =?utf-8?B?bFh6Q00vNUM1bnA1R1JTZVFhMFdSY1BUalZ4SUVTV2dIclhBTFRjY1kzUlFO?=
 =?utf-8?B?QjFGVVZBbGFoNTRYQVVsN2ZBWDJWdWNoUW5NREoxOEZwM1pxWlhmSTFRbndl?=
 =?utf-8?B?Q081d1A5bmpCSmZCZC8yWEwwWWRqK1pLMjRyQWdzT2RseHlNNTMwQTFtK1ND?=
 =?utf-8?B?MlNURW9TaU42RVRPakVHcW8wcEIzSVhtWGxnMk5IY1VUQnNqNm5rUENrNE03?=
 =?utf-8?B?ZGQ5cmdDY2RvcWp0UjN3RWtSeUNMNDhDK3dTTGtJajF4d1pQUVpGK1YzcGh0?=
 =?utf-8?B?TUw2ZnJYRVJYSGplTjZEMlc1Nkg1eFFVdkZLdUtWdk9TaXJHK0t5NFNPSmla?=
 =?utf-8?B?MlV6Sm80V1RoSXFDTW1uRnJLZlZsbVNVS1lQbWtLait4cjd5L1Fxd1RrSXFk?=
 =?utf-8?B?MTUyQ05yWWxmQ2tHbzRPb2hmYi83QUtWWVcvdUx1V1VIS3M1UkNIdUtaNzNH?=
 =?utf-8?B?THpjOC83U0I0cE4wanNIajNERllXV0JpQ0xIL1p2VUNPMlZUcnFENEJQb1Fi?=
 =?utf-8?B?M0xFemJYQnFTZDd5M3R5UThwVDBtWHMxY3hxbUtLR2s4NS82WDZjK0xnbldW?=
 =?utf-8?B?TmYyUDZGVktYcFRoTjExQzRPbDllbk1XRElJb1ZmOC9jQzFCR2w4NGM1dnRW?=
 =?utf-8?B?L2JWOFNIajN3T3pXbS9pZTBtb3oxcXFUVjhDTzFoRHg1dlZ5TlhsWUpwWlRX?=
 =?utf-8?B?aE5obHlLNnYzcHZvenJNcUMyaHhzUmllcGJpMDluWFRzY2pmVHF2ZjdQcENz?=
 =?utf-8?B?RStrVytkSFkxSXRsRmdsWStpY1R1cTlickJRWmwrakR4K3pKQXRsYUgxTjJP?=
 =?utf-8?B?d24xcy9zWi9BMS9VL1Z1cmxTS08xZ1ljUGRSVUpDMTBzMVZhY2tacCt2SFdZ?=
 =?utf-8?B?N2htelF0Y3lDbWIwK2NIbTlaOVZrYTFLa0Y5eitLZEdOMnV2bFFsSVFOdWx1?=
 =?utf-8?B?R0xYZXZxbjBJbWYralZHM3V0UmN6ek9QNklCTkw5YXpGY3V4K3ZpOU4wYkFY?=
 =?utf-8?B?L0RseXB4OGNYVzRNeGtjR21IWWtDQlpCTDYwRXVmM2dEUjI4NUIrSlBVRjJT?=
 =?utf-8?B?T002ZGkrc2FXNVZWaHhTM0tNSjJXenhqSFpWTEhqd01KS2dMRjcxdzFvNmcy?=
 =?utf-8?B?eElKRzY4ZW5BRVRkdmhtVFZJT1cxZXFjanpyVDZJZXVTQkhTa1JXc2Mva0FE?=
 =?utf-8?B?dWxrM09GZmlwVm9HM01PeGtGNnVIb3o4cnExOXpkbW5wUkhpNWlKSjYwRXF2?=
 =?utf-8?B?dEJSY1NiVWFiM1BjcTlwaUc1L1dVUWF1blFmbGdMZnlhakRxSG5iaU9rdjRX?=
 =?utf-8?B?VGE1Z3NCQVh5d1czc0szTzJyeHlnSFVhZEpnc3QrUXIyUDRveWFiZDVUMUcw?=
 =?utf-8?B?RHdWZlQ3YzNjclFwKzhVeFFaQm1XNVFNSGh6bFdYQW5wYUZVelpibnJBaW9a?=
 =?utf-8?B?NWh5RTZGb1QrTlpJNDJvblAzYXU3b1JwcGpJOS9yL0NBeEt0VHlwN1JsRVc0?=
 =?utf-8?B?UGlFT2pyUFVwZTdKa2loaWhCY2drUVNySzRVL0JLYld3RG1yMUVndUdQOUNr?=
 =?utf-8?B?TGlNcXZaWFNKTTN5cEd4a2xmVWUyUng5VWp0T0xNcGw1c2QyeEF4eFlnTEdh?=
 =?utf-8?B?ZkZvZEExUlZNSmlhako0eXVqYkg0VS83dHZTcTRhSUtWdGVQWEx4QVlDNTRO?=
 =?utf-8?B?L0JQZ0FDQzJIZmhSRjRabHN5NExrRHJWaHNjS0RqeSt3MU1GL24zV2lwdWZ4?=
 =?utf-8?B?UVh4eXlyQWFJWDJXb0hOTkhpdjlQMlBiV2t5TmV4OVR5UkN1QmU1eWhDVldE?=
 =?utf-8?B?MTBvdWNFUEFubDVTTUhNc04rOCtvVkExUGw2eURyd1pvdmttUDE1NkRNNlZt?=
 =?utf-8?B?QjlsS2QyQjQrUW9weldZN245cHB0MWkxeElJWXJxOFl4ckI4U3FYNVhvRVY2?=
 =?utf-8?Q?GJ3HuT4HzB3CggII=3D?=
X-Exchange-RoutingPolicyChecked: D3tvOq/DwkPzPZZEL5wNq2kAkhWsapBwnWuixX9zCTsniy+EPLA4NTSUYRLcZmD3Nw7F/WhLEKJY2onTAZt2lW2SxcZnLudf1k4QuvZw5HTpj0Tkv21yZAeGmES66P1p8ph///0Ofk5uz7KhRIzR2aeGPi3siMi+kKqTLjEp7KTYBJVIB6L1vQWgt9BOEQWFNmK3mlJrWmYXI++ZsRXP5SJEM81WvH45tULjdsbG9IqxfgHJXV007ivaiJbOrARiJRf6mL2aqx7GGcspYTMDzpds17+ELhdHN+NHUkODp3Xf8XeCZJu6YrH5jZ4pMYWIt+4J/OIThhjX+4Sjg6MtJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: f810e73c-1f6d-4e07-6a6a-08de8450613a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2026 18:09:50.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3EwihFNvPDKkgGt+11Q8AqYy42E/ebkOvREF4Xbp08nSQi5WLDfhf3iy5Nj7KgKZyawhl2eB7TReGvrQY2P1uytak1XN7/Lqp9+TwWaHrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFE241D7F14
X-OriginatorOrg: intel.com

Hi Ben,

On 3/17/26 3:25 AM, Ben Horgan wrote:
> On 3/16/26 18:18, Reinette Chatre wrote:
>> On 3/16/26 10:44 AM, Ben Horgan wrote:
>>> On 3/2/26 18:46, Reinette Chatre wrote:
>> ...
>>> One related issue I've just noticed is that when ABMC and mbm_assign_on_mkdir are
>>> enabled the creation of MON/CTRL_MON directories may succeed but an error message
>>> is written to last_cmd_status. E.g.
>>>
>>> /sys/fs/resctrl# mkdir mon_groups/new5
>>> /sys/fs/resctrl# cat info/last_cmd_status
>>> Failed to allocate counter for mbm_total_bytes in domain 2
>>>
>>> The failure is ignored, as expected, in rdt_assign_cntrs() but the last_cmd_status
>>> is never cleared. I think this could be fixed by:
>>>
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 62edb464410a..396f17ed72c6 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -1260,6 +1260,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>>>         if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>>                 rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>>                                            &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>> +
>>> +       rdt_last_cmd_clear();
>>>  }
>>>
>>> Is this right thing to do? Let me know if you want a proper patch.
>>
>> Letting group be created without any counters assigned while writing the error
>> to last_cmd_status is the intended behavior. If the last_cmd_status buffer is cleared
>> at this point then user space will never have the opportunity to see the message that
>> contains the details.
>>
>> It did not seem appropriate to let resource group creation fail when no counters
>> are available. I see that the documentation is not clear on this. What do you think
>> of an update to documentation instead? Would something like below help clarify behavior?
>>
>> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
>> index ba609f8d4de5..20dc58d281cf 100644
>> --- a/Documentation/filesystems/resctrl.rst
>> +++ b/Documentation/filesystems/resctrl.rst
>> @@ -478,6 +478,12 @@ with the following files:
>>  	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
>>  	  0
>>  
>> +	Automatic counter assignment is done with best effort. If auto assignment
>> +	is enabled but there are not enough available counters then monitor group
>> +	creation could succeed while one or more events belonging to the group may
>> +	not have a counter assigned. Consult last_cmd_status for details during
>> +	such scenario.
>> +
> 
> This does the improve the situation but the multiple domain failure behaviour depends
> on the order the domains are iterated through. This is stable as the list is sorted but
> does seem a bit complicated.
> I.e. if you have two domains, with ids 2 and 3, with no counters remaining on domain 2 but
> some on domain 3 then rdtgroup_assign_cntr_event() will fail early and the counter won't
> be assigned for domain 3 but the last_cmd_status will only be about domain 2. The user
> either needs to know a failure at one domain means all higher domains will not be
> considered for that counter or look at the new mbm_L3_assignments to understand what's happened.
> In this case we have:
> 
> /sys/fs/resctrl# cat info/L3_MON/mbm_assign_on_mkdir
> 1
> /sys/fs/resctrl# cat info/L3_MON/available_mbm_cntrs
> 2=0;3=1
> /sys/fs/resctrl# mkdir mon_groups/new
> /sys/fs/resctrl# cat info/last_cmd_status
> Failed to allocate counter for mbm_total_bytes in domain 2
> /sys/fs/resctrl# cat mon_groups/new/mbm_L3_assignments
> mbm_total_bytes:2=_;3=_

Good point.

> 
> Would it be better for each domain to be considered even if a previous failure occurred or
> is this now a fixed behaviour? For illustration:

I do not believe this needs to be fixed.

> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 62edb464410a..8e061bce9742 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -1248,18 +1248,25 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
>  void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>  {
>         struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
> +       struct rdt_l3_mon_domain *d;
> 
>         if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
>             !r->mon.mbm_assign_on_mkdir)
>                 return;
> 
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
> -               rdtgroup_assign_cntr_event(NULL, rdtgrp,
> -                                          &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
> +       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
> +               list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +                       rdtgroup_assign_cntr_event(d, rdtgrp,
> +                                                  &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
> +               }
> +       }
> 
> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
> -               rdtgroup_assign_cntr_event(NULL, rdtgrp,
> -                                          &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
> +       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
> +               list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +                       rdtgroup_assign_cntr_event(d, rdtgrp,
> +                                                  &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
> +               }
> +       }
>  }

With a solution like this last_cmd_status could potentially contain multiple lines, one
line per domain that failed. last_cmd_status is 512 bytes so if this is a system with 
many domains there is a risk of overflow and user space not seeing all failures.
That may be ok?

I think this can be simplified within rdt_assign_cntr_event() though. Consider:

diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
index 49f3f6b846b2..a6a791a15e30 100644
--- a/fs/resctrl/monitor.c
+++ b/fs/resctrl/monitor.c
@@ -1209,12 +1209,13 @@ static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_l3_mon_
  * NULL; otherwise, assign the counter to the specified domain @d.
  *
  * If all counters in a domain are already in use, rdtgroup_alloc_assign_cntr()
- * will fail. The assignment process will abort at the first failure encountered
- * during domain traversal, which may result in the event being only partially
- * assigned.
+ * will fail. Ignore errors when attempting to assign a counter to all domains
+ * since only some domains may have counters available and goal is to assign
+ * counters where possible. Only caller providing @d of NULL is
+ * rdtgroup_assign_cntrs() that ignores errors.
  *
  * Return:
- * 0 on success, < 0 on failure.
+ * 0 on success when @d is specified, 0 always when @d is NULL, < 0 on failure.
  */
 static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
 				      struct mon_evt *mevt)
@@ -1223,11 +1224,8 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
 	int ret = 0;
 
 	if (!d) {
-		list_for_each_entry(d, &r->mon_domains, hdr.list) {
-			ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
-			if (ret)
-				return ret;
-		}
+		list_for_each_entry(d, &r->mon_domains, hdr.list)
+			rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
 	} else {
 		ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
 	}


Reinette

