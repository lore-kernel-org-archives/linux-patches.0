Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0A218EB3
	for <patches@lists.linux.dev>; Mon, 21 Apr 2025 22:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745276363; cv=fail; b=siJfRuf64xqqoeB06aiU02R8qesLaq8ym/okWhIDF88tT/jTsMQz35NEyCQIb4QJ9p3o5JEEj3k7lraKf+BkwVIuTJkg/RZ79PxFezM5wVSg4CLU9+Zz2j4Bpge69Ebt/Ud8/JVwEagRuDidCq5VfY3GsQH+GKNovmIP6ohjDnw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745276363; c=relaxed/simple;
	bh=wK/M+R56ARR2Dh9IYK/YRwMG5hfAIz5E96xT12+qNsw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kWqER2Lcv0IRQPzOluYvpeTXx2uKNdg1Lr8gysma9azj4iVKULKFwpBfl379ZQYuJY4omH8gMSxjY5Tn7mhV42yqal51XF81KR4pzveEYOH7KsnT8uehtnXJ3OlXxvbR9z+mbIKgca2uijzvtuiz+kxmo0ASld7SYiyLQ+GgXOk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bBH7kdNM; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bBH7kdNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745276362; x=1776812362;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wK/M+R56ARR2Dh9IYK/YRwMG5hfAIz5E96xT12+qNsw=;
  b=bBH7kdNMO0FJWBHrfoPncB30+2Jc0PiIB4PH2SjcAbCCJDB4HUZnSfLV
   5/AyjAX5eiN/4W8SEqygbB0dWKq6pg/UhQ5XBW4p6rirGh0Ip82dczaqg
   O+ShrGqh7IvSxG/hgYuJYocjIEeIY0PDVXTxdo7a7TF6sD/nQsXWYbZp9
   OYQMgmzesWmzhZ7obyQopoxs3sgwz4+K5bHmduwsHcgrXHjImSEV5wXmO
   2/UK9BfQ6RONF/PvX1TxPWpEZflLMuNxXGYNoOWRNJTU2hRpKErhtjWgN
   PAg3HvmuLx+lnAsjUBBeZmYfmqKfGOy+5lxbBiZd/uv6sEMkxB7m+1Rhw
   g==;
X-CSE-ConnectionGUID: 3uJQGLLRTMic+Vh+9/3p0w==
X-CSE-MsgGUID: 6RLtBKM1TL+BqYmBawq4ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11410"; a="49481913"
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="49481913"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 15:59:21 -0700
X-CSE-ConnectionGUID: AHY1XgwFTsOmyhvZolVR9g==
X-CSE-MsgGUID: wXJFhntURt2rr/+kxqW5iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,229,1739865600"; 
   d="scan'208";a="131587249"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 15:59:20 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 21 Apr 2025 15:59:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 21 Apr 2025 15:59:20 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 21 Apr 2025 15:59:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j0Yh+dZsCrKJAVYuxdC5OnMWMStOozzJ4jMsgEuvGWbptiADUxOCb7SE/1CoI8TyAV+2mwg8bP0fDvhXqSKwMD99G9sXiuDS9fPS7uQ4VmcvPp1U/JTJ/xs+HVIa01NRWneY5Da4wNOed6BweezXG9k3ZP1gmJgZjHCo07wbjnSdFZsE8TfwoMwwLPo1qlnd1vB5rAZcrwCKewiRgR/1Vaa8qh/571mTYSk/xZksAqXsWzjDhj/xYQwLNGHaV65HXHHCNaF974Kq6LyP+f2um2ME51uwEqYXLZe/MQELdGtlewO+YChjMKZPSM5nUbAwX82OXUP+WE2EVX0QZ8XIMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mYE/3uurQH7XJ4kcoAO0rs8iZxGWLh8sdg9VFTIbbv0=;
 b=h2PzE49jelmiSVbXLfftCL7fha48EpuHj2lnVdbl5nZJprKzVbHGkVu4f3NU4Q0OTHaEL+iAku9D3Epxo1mjtmZoSuZCYl2fayjMWKb+e9B0HfPs8ZP0K/CLdQ0J6HfWMzPo5JI1XYn3Ev9W+8Yvh/31Z7wLtawsI3cAqYsvwIfAzlK/nIYgqY1o7NLELXDuWiV018qGxxqXqdpLIqf1dgMOn7Fouq0WZZ23rK7WKrlqm9RcNGYOZrMr5AG6vD2SdXQj6VQw0YdH1NHrev4aY0oDbIOqmcLI3161Fwgo9F7Sj3OmKSfn4uj6XhMICCx5ZIGop2MrsNFHYQEdvfrKaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH8PR11MB6756.namprd11.prod.outlook.com (2603:10b6:510:1cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.33; Mon, 21 Apr
 2025 22:59:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Mon, 21 Apr 2025
 22:59:17 +0000
Message-ID: <ccb33985-e1d8-449e-b39e-3fccb5fc0783@intel.com>
Date: Mon, 21 Apr 2025 15:59:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/26] x86/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <53dcb55c-f5b6-4cb8-96b6-07aa1ba1d4d4@intel.com>
 <aAaVH4W72fOzQhnh@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aAaVH4W72fOzQhnh@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:303:16d::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH8PR11MB6756:EE_
X-MS-Office365-Filtering-Correlation-Id: d7c33e86-2426-4941-c0ce-08dd8128248b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TEJZZjYvdGd3US9ReUxzdDdURWpoODlsTmZRb1UwcGlGaWtoLzRURlgrTkpY?=
 =?utf-8?B?ZXdDRVZWSXFmd1RFWjJIcVR2MVk5c2pOaDNOOXN2MHJaNm9NbjFKS3NONlo5?=
 =?utf-8?B?OHZBVnZ6UXZFdnA3YnEzWFRiR2tRTW9UNjZCS0xQengxTmJDNGIraWZQYitG?=
 =?utf-8?B?L0hZdEw2TC9SOGhFeXZXQmVWOTRPZ0dtZVUxNzU2L2NqWXRBSXFET3dmUmdy?=
 =?utf-8?B?Y1ltbWd5a1RQL3dJR3Fjc2J0VFdPOXZ3UHlnWlNvekM0L2NnS1A1VTJ0eVVs?=
 =?utf-8?B?Ukh0enM5aUpza29VT3FCdm5RaEx3cWZ3eU9ENVd3dUkwWnZVaTRpdWp1dTQy?=
 =?utf-8?B?aGVpUXoxMVR4TC80Um1NZjkzbU5CeHNMeGo5TUJqVW92Qk1KeFJaNkROKzNn?=
 =?utf-8?B?ZjFWd1BIVmdtWXNNOHJ0ZXpjei9POUpna2R6MElROUlmSHJJUjVNNHMveisx?=
 =?utf-8?B?QldiQ3B2WDNCSFNYU3ZDK05uSzB4Ulhkd25oVExvaVlKWHpScTNkdnNlY2o4?=
 =?utf-8?B?L3kzelJBVFczUldFbWR1ZnNmRDBqRnZnWVZKajRwRTV0aldOc3BXOVY3dFFX?=
 =?utf-8?B?YXZRY0JuSDBQMzhsdFR4RkhDRTlodUhMZkRaZ0lGVFc2VndQQkpXTGEzamMx?=
 =?utf-8?B?cVhiRWNmUkpMV0FWVTMvbU9hclZTeDZRWmt5dGpVOUJEMXdpYmx4Q2k3dVdr?=
 =?utf-8?B?SFB3RUpjcHhSYVRHaEdXMXZ4SXpJY1FXUXdOLzQvUzUwQW1TWGVwMGd2aXBl?=
 =?utf-8?B?dEsvTTQwbVdkL0o1SDF4WGM0Y1FlbWlBY3lDS2tuT01zdTZjSHFvaU41R2tk?=
 =?utf-8?B?Ym9SalVaY1dleEgyV3ladUVSYTJGbWNPTUpuVjRyVmlTNkprUmFIR2V1VEpT?=
 =?utf-8?B?M3JrMFBYenNJNjJhZUJUSERUZ1ppZXVaMlVLUUg1c1BtZTNkNmxQbUg3Vytq?=
 =?utf-8?B?b3MybnRjaEl3QjdDUEkzN0xWZ093cm1JbmNjSE9hRjhiN2xRaDVBZ1dDNDhE?=
 =?utf-8?B?MFZrZUFsMEF1UFlIaGY4QzErYzZrZ3FyTTRzMFJCNlBkYXpHYUJURnZRbGlt?=
 =?utf-8?B?UzJ5YWVzT0tyWEh0YVF1WitrbDhTSS8vdUNQZm5CazRaY1VHU1oxZ3lTdldT?=
 =?utf-8?B?YzZnemo0NmNRWHhFMCtRT1dxWlBtTWtYdFZNY3JoelB3RENkTTZlUkRHdU9Y?=
 =?utf-8?B?ZDNtUVAvbHNGb0I2MjRZYVRYZXNjTHRBQWgvVCs5SjRQaGdPQnNIcTlYNXZs?=
 =?utf-8?B?WnJ6ZUtoOEgrV093MlY2L1ZHdmpEaGpiTHhQU2piNHl6TmtiZUVyS0JmaEU1?=
 =?utf-8?B?QWxGRWwxdHVRalhpVmhRWXBHbzNhbFpZaTRaaEorLzhseGpaYzYwbEVYNVlm?=
 =?utf-8?B?RVVWKzNxMGJPbzd4NVBNRzJhTXN3QVhlRDFubnFWd0kyeFc0NkdHazFSeVMv?=
 =?utf-8?B?cnh1MGRKekR2NVh0dUtzWDJtV0VEUFBlQ1kyeFczQjFRN3VkVk5WY2RMWU1z?=
 =?utf-8?B?VVZIQUpxMk9YcFVFUkZTS2R0LzBEcVNTd0tESXBEbGJKSFNvZERDbGRZVE9W?=
 =?utf-8?B?Ykd3UjJlTzZONGxpWFl3SDBVMGFMaEtRa2NvNHVSOXVab29WRFg2SWVtQTFl?=
 =?utf-8?B?b2FkaE5penh6MEg4NUkwY2M2WjFxYUlVZzFjUWhTcVVmVzNVMGo2OHVXYWRi?=
 =?utf-8?B?ZGlCNHBtZnNoZ0Z4RkZQWUlPTFhSZFcxKytRRlNWSHNpN2lUaUo4SGtidnRs?=
 =?utf-8?B?SU1SR1BBMGdGQTB5OW1mUzN6dGplQU5aZzZVZ3hXOGpTZ2pxUFYvTm5XV1Zn?=
 =?utf-8?B?cEVSWEt0Y0dNTHU2bm41MjV6Nkh5Nk9sK0dGcTA1cm9mREk1VEhtOWVRSndJ?=
 =?utf-8?B?Y3NmVGpwejBkb3F5Vm5ySU5OREdhcjhqWEJlamRPL1VWZUJCM3ZsOWNnQk9X?=
 =?utf-8?Q?74DIJgFa5x3gxcQwa5Fd69v37H3C4lwp?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WTNrcG1nSHJJVkVRWFlOWVJRbnFIVDh0QjRuaGRYcGZGTGszVGlvWUdJKzdC?=
 =?utf-8?B?TGhOQklNSng4TW5XWHlidndzK1J3OTNFVzhabnlRZkhLcW5uSjlGY0h2bDRH?=
 =?utf-8?B?SWc3YnpqRVAxa1dXTXJwTEFtQThpZXFTTzV1NXU3S0dEYTRpK0tDRCtoZmV0?=
 =?utf-8?B?M05GVkFwaEZ3RXNlWlQyaGovdFNWMWVCSU5sTWtmR0R2aERtY2NFZkl5Si8r?=
 =?utf-8?B?STdhUWF1UmpIS2EzdXRqeCtvQnhlVVhuZEM2MTRnNDNBMFl0TGVqMk5Bc2VF?=
 =?utf-8?B?cmVSSEZMRll0T2wrTXBQbHduMjVBeUF6YjZVNXlwUGpCOTVucGs2dEhoeGll?=
 =?utf-8?B?VW1FMDN1SUlENzVxVmFVQlBrQWhaRkpnNVlaMHRSZFQzU0J3UHZGM2dySk5h?=
 =?utf-8?B?bzBJSXVxQ1JNeWU1dzRkZ1lRVGVaT1pTT0R3bkpuMWF2WE5rbUYxYTZuMFdo?=
 =?utf-8?B?TWJ2b3k1NUtOVTFWdW9mTHdYdlMycU1rV042cWdCVEVRci8ydFVpTFExd0pH?=
 =?utf-8?B?bm1uUUlwVHhlMklGVWtnVTdPaU85aFlFMHhpNG9FWUpZSXg0Q1g0dHBFNFFz?=
 =?utf-8?B?Nm1LMUJENVB5dWt1QUxDSnBVLzZGUVMrV1VBandob2gyZ0RFSENMVTFjTmhl?=
 =?utf-8?B?NEJYNmJZUEFzd0c4TWlnTnhkZG5XY1BuV0o1NlB4Uk1ldVRQdGF5b0VBK003?=
 =?utf-8?B?enZTajR4T0o2dXpzUDRqS0R5SFJQdCtUYVduRWxPZ0ZsUzNScnl1SndVUEFl?=
 =?utf-8?B?T0YvRmZ0S3FKcWNVdTZVTWtBczNvNjY0Y0ovbHNQb295UEFtUytQYzg5dWV6?=
 =?utf-8?B?Tnhxb3k2SWhnTk1ySzgvY3J5L011RWFjd3Q0STh4WmtmWmpNUW1iSHJZT01I?=
 =?utf-8?B?N1g4dWRLaUNWVHFkOWhjS1lpRGUxQ0ZQTXJQMVRBYU5zejU1YU1SbHdBUjEv?=
 =?utf-8?B?MGZaNFJoWFhBVW5YWWg1TEErVFNyMWozMkRqWERoMXpneFlEVHF2SGQ5bnhJ?=
 =?utf-8?B?Q0R6a0NPY0tUSVFVVklZQ0YwYlJ5VFFqVW5aMEdOajRnTmJ5R3pSZ2N1cWJX?=
 =?utf-8?B?M2hEckE3U2NydmlzWmNDNmhqcllEL2RaZFoyZUpsZGRqbU9oZEZ1T1pvQ2RI?=
 =?utf-8?B?UVRSRzdDWjlodlVqWER4bGx4L1B2aCtocHhhd2gxbmlQUjV4S05hNllsM1Ew?=
 =?utf-8?B?MHhSczJhMkdWKzJ0TTNwL3FqOVBoOVhGTEhlZHlxb3FBKzRoRmE4dnZXUnRk?=
 =?utf-8?B?WFkzaERFN2hFMXErTkJYcm1iYWZ5V2p6ekZuZVJFTGUrZzJKMHMwdGtkdlha?=
 =?utf-8?B?SFp4Zk1uR1JLekVBaTF2N1A5dnA2TDQwNm5oczJNQ0lSbjhEOHp4WlJ2RFdo?=
 =?utf-8?B?RWIwOTE0TXB0eURHMVMwcXB3a0ZmTkdZUStYMkhJbnowa1orT0JBUlBSakRU?=
 =?utf-8?B?dWM3TVA3U3NVQW1ZVlkvRVdJa1ZiQnFPcnN6ZEZLREEwMTkzbnR4WEMzZ20r?=
 =?utf-8?B?T3dKcU5DdHRuZEtXSG9wdVZtK1VaMEhIb2toaDNvMWp4NW1udEZMNGcxZ3Zn?=
 =?utf-8?B?bHUzMXJLaVR4c1p2UWdybTJwdjRWS3dSYVRhRThQdUg3M3BKY3g0ZEF1L3Ur?=
 =?utf-8?B?WVBGYkpSczFpdDAwR3hicElOME9EZU53UFdaaXNiQk9MRnlHcytEaDc2T1RN?=
 =?utf-8?B?UWxJK1NNVXRmK3dzNUNXdnBQWi9hK0VlRTJLalNDQUlvbzFtNEdvbHFDRktF?=
 =?utf-8?B?QmdBdmgzTFEwK254RnY1Ti90OG9oTkYxMWFhMjZBL1JnU2NmblhlTFhyTTVS?=
 =?utf-8?B?aW5rTDhjY1ZFSUhldzJiR0V4VFBJbmRjVmxvVUszV1g0RzJaUVo4MGJvWG13?=
 =?utf-8?B?ZG9PZEJCVXQ1UmgxbFZXUDdQbmc0WmNSWEF2QzN1WUx2dlhmS1k2eVhQV1Fu?=
 =?utf-8?B?azlraG1pM3ZPT1IvNHYxNGx1ZWQyQjdaYitMaitjM0NVc0ZyZ0FzTjRFRWlr?=
 =?utf-8?B?WlVmUEpreGN3M080NVV5SklrZEVtVmEwYzNYTnRnL3JoelNhTEpKU0ZIbFhZ?=
 =?utf-8?B?ZlJXaXB2MVk2cVVmckFXYUtqRTV3NkdBMFp5Qy96ZWVJUi9MbXBOUFZrKzdH?=
 =?utf-8?B?R3JxZDFESmJLclRnbFU4eXUyOHA4N2R0SlVEdmU4RE1KL2wzVE1YQ2xBcWor?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c33e86-2426-4941-c0ce-08dd8128248b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 22:59:16.9900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0PQo+Bjtm7iHzcJgGLPnQeSu+ODxk/n3kCGG0lV5rIhzT0kBSyNURFE+Ig7TkfbFX07bHVfD/HwO9MjdmLCPUUA98US51/htQe6gHq8obeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6756
X-OriginatorOrg: intel.com

Hi Tony,

On 4/21/25 11:57 AM, Luck, Tony wrote:
> On Fri, Apr 18, 2025 at 02:13:39PM -0700, Reinette Chatre wrote:
>> One aspect that is only hinted to in the final documentation patch is
>> how users are expected to use this feature. As I understand the number of
>> monitor groups supported by resctrl is still guided by the number of RMIDs
>> supported by L3 monitoring. This work hints that the telemetry feature may
>> not match that number of RMIDs and a monitor group may thus exist but
>> when a user attempts to ready any of these perf files it will return
>> "unavailable".
>>
>> The series attempts to address it by placing the number of RMIDs available
>> for this feature in a "num_rmids" file, but since the RMID assigned to a monitor
>> group is not exposed to user space (unless debugging enabled) the user does
>> not know if a monitor group will support this feature or not. This seems awkward
>> to me. Why not limit the number of monitor groups that can be created to the
>> minimum number of RMIDs across these resources like what is done for CLOSid?
> 
> Reinette,
> 
> The mismatch between number of RMIDs supported by different components
> is a thorny one, and may keep repeating since it feels like systems are
> composed of a bunch of lego-like bricks snapped together from a box of
> parts available to the h/w architect.

With resctrl needing to support multiple architectures' way of doing things,
needing to support variety within an architecture just seems like another step.

> 
> In this case we have three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF.
> 
> 2) The number of registers in MMIO space for each event. This is
> enumerated in the XML files and is the value I placed into telem_entry::num_rmids.
> 
> 3) The number of "h/w counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This is
> enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()

Thank you for explaining this. This was not clear to me.

> 
> If "1" is the smallest of these values, the OS will be limited in
> which values can be written to the IA32_PQR_ASSOC MSR. Existing
> code will do the right thing by limiting RMID allocation to this
> value.
> 
> If "2" is greater than "1", then the extra MMIO registers will
> sit unused.

This is also an issue with this implementation, no? resctrl will not
allow creating more monitor groups than "1".

> If "2" is less than "1" my v3 returns the (problematic) -ENOENT
> This can't happen in the CPU that debuts this feature, but the check
> is there to prevent running past the end of the MMIO space in case
> this does occur some day. I'll fix error path in next version to
> make sure this end up with "Unavailable".

This is a concern since this means the interface becomes a "try and see"
for user space. As I understand a later statement the idea is that
"2" should be used by user space to know how many "mon_groups" directories
should be created to get telemetry support. To me this looks to be
a space that will create a lot of confusion. The moment user space
creates "2" + 1 "mon_groups" directories it becomes a guessing game
of what any new monitor group actually supports. After crossing that
threshold I do not see a good way for going back since if user space
removes one "mon_data" directory it does get back to "2" but then needs to
rely on resctrl internals or debugging to know for sure what the new
monitor group supports.

> 
> If "3" is less than "2" then the system will attach "h/w counters" to
> MMIO registers in a "most recently used" algorithm. So if the number
> of active RMIDs in some time interval is less than "3" the user will
> get good values. But if the number of active RMIDs rises above "3"
> then the user will see "Unavailable" returns as "h/w counters" are
> reassigned to different RMIDs (making the feature really hard to use).

Could the next step be for the architecture to allow user space to
specify which hardware counters need to be assigned? With a new user
interface being created for such capability it may be worthwhile to
consider how it could be used/adapted for this feature. [1]

> 
> In the debut CPU the "energy" feature has sufficient "energy" counters
> to avoid this. But not enough "perf" counters. I've pushed and the
> next CPU with the feature will have enough "h/w counters".
> 
> My proposal for v4:
> 
> Add new options to the "rdt=" kernel boot parameter for "energy"
> and "perf".
> 
> Treat the case where there are not enough "h/w counters" as an erratum
> and do not enable the feature. User can override with "rdt=perf"
> if they want the counters for some special case where they limit
> the number of simultaneous active RMIDs.

This only seems to address the "3" is less than "2" issue. It is not
so obvious to me that it should be treated as an erratum. Although,
I could not tell from your description how obvious this issue will be
to user space. For example, is it clear that if user space
gets *any* value then it is "good" and "Unavailable" means ... "Unavailable", or
could a returned value mean "this is partial data that was collected
during timeframe with hardware counter re-assigned at some point"?

> 
> User can use "rdt=!energy,!perf" if they don't want to see the
> clutter of all the new files in each mon_data directory.
> 
> I'll maybe look at moving resctrl_mon_resource_init() to rdt_get_tree()
> and add a "take min of all RMID limits". But since this is a "can't
> happen" scenario I may skip this if it starts to get complicated.

I do not think that the "2" is less than "1" scenario should be 
ignored for reasons stated above and in review of this version.

What if we enhance resctrl's RMID assignment (setting aside for
a moment PMG assignment) to be directed by user space?

Below is an idea of an interface that can give user space 
control over what monitor groups are monitoring. This is very likely not
the ideal interface but I would like to present it as a start for
better ideas.

For example, monitor groups are by default created with most abundant
(and thus supporting fewest features on fewest resources) RMID.
The user is then presented with a new file (within each monitor group)
that lists all available features and which one(s) are active. For example,
let's consider hypothetical example where PERF_PKG perf has x RMID, PERF_PKG energy
has y RMID, and L3_MON has z RMID, with x < y < z. By default when user space
creates a monitor group resctrl will pick "abundant" RMID from range y + 1 to z
that only supports L3 monitoring:

# cat /sys/fs/resctrl/mon_groups/m1/new_file_mon_resource_and_features
[L3]
PERF_PKG:energy
PERF_PKG:perf

In above case there will be *no* mon_PERF_PKG_XX directories in 
/sys/fs/resctrl/mon_groups/m1/mon_data.

*If* user space wants perf/energy telemetry for this monitor
group then they can enable needed feature with clear understanding that
it is disruptive to all ongoing monitoring since a new RMID will be assigned.
For example, if user wants PERF_PKG:energy and PERF_PKG:perf then
user can do so with:

# echo PERF_PKG:perf > /sys/fs/resctrl/mon_groups/m1/new_file_mon_resource_and_features
# cat /sys/fs/resctrl/mon_groups/m1/new_file_mon_resource_and_features
[L3]
[PERF_PKG:energy]
[PERF_PKG:perf]

After the above all energy and perf files will appear in new mon_PERF_PKG_XX
directories.

User space can then have full control of what is monitored by which monitoring
group. If no RMIDs are available in a particular pool then user space can get
an "out of space" error and be the one to decide how it should be managed.

This also could be a way in which the "2" is larger than "1" scenario
can be addressed. 

> Which leaves what should be in info/PERF_PKG_MON/num_rmids? It's
> possible that some CPU implementation will have different MMIO
> register counts for "perf" and "energy". It's more than possible
> that number of "h/w counters" will be different. But they share the
> same info file. My v3 code reports the minimum of the number
> of "h/w counters" which is the most conservative option. It tells
> the user not to make more mon_data directories than this if they
> want usable counters across *both* perf and energy. Though they
> will actually keep getting good "energy" results even if then
> go past this limit.

num_rmids is a source of complications. It does not have a good equivalent
for MPAM and there has been a few attempts at proposing alternatives that may
be worth keeping in mind while making changes here:
https://lore.kernel.org/all/cbe665c2-fe83-e446-1696-7115c0f9fd76@arm.com/
https://lore.kernel.org/lkml/46767ca7-1f1b-48e8-8ce6-be4b00d129f9@intel.com/

> 
> -Tony
> 

Reinette


[1] https://lore.kernel.org/lkml/cover.1743725907.git.babu.moger@amd.com/

ps. I needed to go back an re-read the original cover-letter a couple of
times, while doing so I noticed one typo in the Background section: OOMMSM -> OOBMSM.
