Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD5031F9B5
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 16:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781108472; cv=fail; b=SzNtE/thRouk0mas9Oo4MJbDc2SIL7dFoahTuHLNaVRKVNT0t+8gOoJ3i0sz7ReZB/xGebvPvV2m6he9uqv6/sbqJ6wo0gjLnq46AHnvyAvGvp0IF7G5rYxJ7H6zwhoH5J3xn2kho+r4Nhw7sGiUt2u+ZKxYxHaYlVw1KTp0Gxw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781108472; c=relaxed/simple;
	bh=HgdR75VMFXXGDlUDIzYDGvUhF5fKG40Kgd4bl5orQkQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t6w7HkAxqDI63wR5TL9tbhx60TBFfR+oiVbIxZwAH9+9+dq7NDrlZ3IPrw8OCW3v0VuBgXsGqn8EcxyrbLJhiY92oRT06JjGS2hvcEo2PSNr62yQAK3ldFvWMpFLhWmWeoyrwmSZQAWsPage/MKhFjJhFWVI6td3gv434fhHJrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=He1PKG5N; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="He1PKG5N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781108471; x=1812644471;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HgdR75VMFXXGDlUDIzYDGvUhF5fKG40Kgd4bl5orQkQ=;
  b=He1PKG5NQLdw62be3IjdzyEH/lxxc2HlDT/xIT89wRnTi8c17XeCsPz3
   K3klLaefLRsnX6pY+BcC8Zq+W+6ooRJNOAXg6pYCYcan8w7qSDpR1u8gz
   /wFcq93ylpDzx7/5L9cu4PDVy9wLDIqZp5bFxlhYyNpYsSY0NylPg+YnZ
   tP/8VFZw6c80w7g+RalHIsVzko+Feu9qufkgiWkhfLHBtCHuz+A1+3SGR
   2nXh3czhY72oFBPJxZA30uZgKlVQ+g6b/phO+bnSERHDBeP0u27qHysmg
   DYJ9dmzsHw0AYkxgKAvZwRXS+hnAZBA71wLIo5wLZQ8BQgljn0pc9b0pv
   A==;
X-CSE-ConnectionGUID: vcUPpK/PRui63E+yWE/BlQ==
X-CSE-MsgGUID: 0UN/bNfPTwmZ10iZjAE/Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81908811"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81908811"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:21:10 -0700
X-CSE-ConnectionGUID: r4XTHHb4SnOfqKGBf7Cogw==
X-CSE-MsgGUID: gAWWGozOQ2Sn5ABB20GXGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="245353311"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 09:21:10 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:21:09 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 09:21:09 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.4) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 09:21:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=U+xKgbJjIp3tTtmY+6q0SADSSs9ylWf18Q7PwGuvfRBmJPTDd/r9b/1OJmrgkstloNlJoMMGzqMqqG7Z19aybuIq/KguMZgtfsL8IbhE+eZLj8DCHmYvKIsYuDHs5KO2kNCG7+E/zETJLuLyhPxBd1iUk5ZLpQQWB5zyIR/O1bOnC1Xx3JWPCWOe+lu462CBg2r6KQMJ4kJK2wm2VUCkRMYMplbYIH4fgRhVL8ZDm+KJXAjVhzS/nMoIaT+h9wNMmkXq/ri8S7EiJEVgMpUY6Vm0a9hx40IYEuTxjPekNWC+9Fc8DtcGQFTakKqlfvd+CFhTNcQ80wtDvZFlL/1PQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F5Fl9o5qg0kCiPH3C26L2eGYgJ5/IMqGGmRfF950grA=;
 b=y9glmk1UOEIgJ3D3FaSw8lv6Wf3zIaXxSwQGPUEXDv6Z7OwP4c8R+MYgu/mwcLqbFUBUE5uUubwmsS/g/K/T6jJCrkCglPBEXdqwv+JYTGJHm1qZhCShncwTlJPTDlbS7sF+lgUn/CR7LQRtPiK9bIzoeoFqcsnW4bJlZNN/+BdiGKJOv22av9MoiyODfzaPawMDa+VXCJF4tlPEjMXuWmxJHY0JZBRWGefMGxwpUvJ1jigKHO1etm2H5AF3HW6WtNDwMcqF+tusUXRzYu09aupUU98dmSw5niFlpQjX5h//l1B0Sa7Ll1MqGBklcIu9ZfT4gQYgSa5IR2Lab3KJoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by IA1PR11MB6074.namprd11.prod.outlook.com (2603:10b6:208:3d6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Wed, 10 Jun 2026
 16:21:06 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 16:21:06 +0000
Message-ID: <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
Date: Wed, 10 Jun 2026 09:21:04 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aimHif2ZC3PIjHw1@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0244.namprd04.prod.outlook.com
 (2603:10b6:303:88::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|IA1PR11MB6074:EE_
X-MS-Office365-Filtering-Correlation-Id: 60568544-07a2-4237-7198-08dec70c4612
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|5023799004|22082099003|11063799006|4143699003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info: c074cBTfhKh6dAyFT7LJPnDrdulkETBwW2ZJ5eOiOsxsrwYyuvva9dIyZaiUzrLv0yBLccfGR9DP0lc3io7Mgo559yUJE7xGS8rJq5A7mL4gmiNRdlfxCCtPTG7SWbaqheLK9t+nXUKscLC91LwIVdZEfravKwFhlpedLqbjfXVxWd1Gqe3y6el77zainUOXRNtLvQMkivc9c4rNkUriG61s3UPP0b07fCFutHElmRXex6Ig9CEIrYszuqUzkoyWCwNkzkjkzXTTHnzNYa/064y1CJr7xUzKqYE0NECj43HHatuab8+sETfxvO8bv+dmtVAR0TMfDYoQgdW/mcrakDYRlsTONErOQw+LmE98yjeY0lIA4MYegt92NFRUBv+0SBrxuMuGIvCk0FZaXvKMj+BDAaP1G7QZDM27E4XaEH8WR/rSQI2j4aA9stJ2EJUrA968TBciyjeqLFw81AACYnlOfQy05uBmZWQ5Q6fAjDJ5qEUE6OP9qkeMNIZeqTCYzeZgvvzdVermQv5lGSDpiWskUSp1k5C9Ny93POTKp4Hkxc4ZRS32F6dl+Vz4LLqWh8Fr7nPbiGbM2Q7/utDbZqFQa6g9Gj/nH7iwyEAos7LxfBXm5wqnL1qB7cEXuN7lUF99hNVRF0qv7Jxb6uT/81y761nuVDwuMn/0Y4vzK/O2UgCq0MP+4Bd5WLDn1qN1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(5023799004)(22082099003)(11063799006)(4143699003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0JDTW5Ja2F6c1VIOGVqMGdNK2srSXBCZjZiNDJBUXRrL05tVW9kc0daeEx4?=
 =?utf-8?B?WGt0NmgxN1dwajFITjhLb2hrbVZMTjh6STh6SnFvelhxMnNqVG83bmNPRWNX?=
 =?utf-8?B?QkFBZjdMUnFkU3EzQXlBYU85QlBkNnlPSXR1N1puTnFQWXNTUDQwRW5tU01E?=
 =?utf-8?B?QUJTQnR3eVRlb1dYdXFNS05RejdMclN1OFlVVmJ4bS9vSU5rc2FmNnEvb0l2?=
 =?utf-8?B?MXQzd1luOUdrNmwrZ0xtb25kL0t4ejYwRGlVMUlCQ3ViQmpuc2RYRnlSaDB5?=
 =?utf-8?B?bVZWTTRySE04bkxYYWI3Z1FBUERmd3NGVXFQNnErbjRwVUZQS3U3eis4NW1T?=
 =?utf-8?B?UUVGanZzNGdDbG50WFM4eUszeHc3RFFWcUt2a3FaQ0orN2xMeEgzRWJZWTha?=
 =?utf-8?B?emNLMzBkTHYrbUc5N1NPSjU1OHdtUUhsTHFKQVZhM1FoTVMxYlRaVDd5UzFW?=
 =?utf-8?B?R1M0RFpZSjdvd2czaGgrd29WWERaQUhwMmMzUFF3Ymg3RUdqczdKOVZ0b01i?=
 =?utf-8?B?RUVpT09TMndiY0NjUEdHUkVvRklXNmR6Q3VHUytVYmk5YVBDa0tsZkdKKzVO?=
 =?utf-8?B?THNkNzFJVDVYVk8vT09BSXFVOVNGT0l1WmNNTkswWWUxd2JabjdWVUo2MnJR?=
 =?utf-8?B?NkNRK2V6ZXRGZDY2c290aGlyYTdJL2o2L1NtUERzWWp2K1JVVDk3RWNzL3cx?=
 =?utf-8?B?NFRoOHRkNGRnR0dqRW1CNmJrWXJuaGZKTmI0QUMvMHVmc2lRSXlHZFJOVFdt?=
 =?utf-8?B?RUxJemZ1K1B0ZzloMzJwZk1iNjdsbmExUkZXM1NGSngwVXIrQjRERHFiWS9o?=
 =?utf-8?B?WWN4VnBEcGtPdTU4RUVMZFZBN3FWOWpxNm5IT0tnMmxvZ3IrK0RoRFRXazRu?=
 =?utf-8?B?cW13ZGl2VjZ4dnVjcDVpRUVHWmhsTXNMVUgxRlBRYU1HaysxcWczQklGYnlY?=
 =?utf-8?B?cWpJTzVSOHlsTUJrblcrSzlPTDNIRndGUW94QWpmN3N0R1dvNUdMc0p2bzIz?=
 =?utf-8?B?dXlmZzREb3BpMkl3OFUrRnl4MjBHRW5CK3NuNDlBaTJiWXZhaTh3bmRWTzd3?=
 =?utf-8?B?K0QxVVRhS0dUWFNiSnNiWUUvNlhJb0J5LzdFNGp2akVJTjU1ZjhyMDhUWncw?=
 =?utf-8?B?Vlc2WnEyNmVubnozNXM2VTBEck80WW5LUXdiUUU2OElRYnJveGt4VXdRRW9O?=
 =?utf-8?B?ekZ1ZDZUQkQyb3NWY3QxOHdEUG5vTmJlWEJFOHU1bEFaNGszTS9JaFVTTXZy?=
 =?utf-8?B?NElzZEwrTmRDYkJwT1FHWmlkbHlCdk4yZjZBMkhhWDcza2FtOUtGU1JEdkFU?=
 =?utf-8?B?OWdiaGhBc0FVVnVxUnZGbC9TVmlHVkdKemc0ODZrVkRlcTYzNU5hdE43VHlG?=
 =?utf-8?B?cm5IZkVLbTQrTTFTcWJTQWpvMExHN202cGlFNDNTZHNIdWVTZSt0QUxLL2pP?=
 =?utf-8?B?ZWhTdC9DRzNDamZRQlQvVmJxc2poeWxKeVg4eDNHMEhmSDNCdWdJeXhzRDBm?=
 =?utf-8?B?YzVNa2U1SjdEc1EvaEQ4eTRuZzI2R01HemtLRFFMRFpaS1lkZEdwTVlqTjVx?=
 =?utf-8?B?dGZIbWQvVnNLNkZMUEZMSHd6Um1lcVZrUmMxZ25yNks2S1puRlBzVEZCZ2E3?=
 =?utf-8?B?UmlwRGdMZjJVd3dZdlI2S2tneEwyM0tWOUxBUUpOUE9IdVJPdyt2d0Z3dTh1?=
 =?utf-8?B?RlhWbklsdURkaTVnSW5hREtyV0VwODhvT1Bnd1E3bWxmM2I5YWtEcXZsWGRD?=
 =?utf-8?B?aHRtRGMzb0V2SVV2RFBRbWcrbkVoNVpKWkpNL0xPWmUrMVFuQ08xekg2UnRP?=
 =?utf-8?B?dE5FTTZUOG1nV1g0RVNmTTVpYVhyNU9COUVRd2lpZlBuczhFUzM3ZVhZWHc3?=
 =?utf-8?B?WkwrSURHandWNXZsUXRob1Jlayt0UXJzc3JiWWZtWWJqcFh6aCtxVHFDTkJu?=
 =?utf-8?B?ZCtPcStwT3Y1SVluWXpqbGt4WUpRV2ZDajBtZU1ZUXJnOC81VXc0cnZwNGtz?=
 =?utf-8?B?VWhXKy8rWk5zM1F1dzNpemhDVVFlUTVvekJydFk1NzY1cDU4NUhjejlCb2Mz?=
 =?utf-8?B?czFVYnhiMkM5RWdMdWRTQ091eHUreG53LzRtL2JHRk0wVXhTa3Q2VU9HNHBZ?=
 =?utf-8?B?bVQveVNGQWxFOCtuSzZGQVBBRS83V1k4YkFiMXAxeTQvMTZuSG40aHdpTGQ2?=
 =?utf-8?B?MUUwdkJBZWV5K3BndkJBSUxiZ3pYK1FzMXZEZmhFUjFBWUp5eEZzcWRHVC9k?=
 =?utf-8?B?Q0twY1Y5MWVhNVNqNmk2ZmpqNWtJbGVJYVhzYjdOSWVFN2krcmFPNjlTcmZB?=
 =?utf-8?B?ZkYyYlYveXVnNmdJS2dyY3pLK0Rab1U4ZTRkaldLdjNFL3NsY0dWRnlEQ2xr?=
 =?utf-8?Q?8WwQ5xc6wz30bkUk=3D?=
X-Exchange-RoutingPolicyChecked: Ucowqb7oS6UvaC/87PCBD1IY084nSuLCJNGqnQANWX0B7Yyr8b/x3OO1gS1hWwOFn+KatNzOFscK5FcqQk/cEVYkmQKeqo+G+1WNwQvxQqbOWdtrsjr6b8zDG7588bG1Ogo8cpLxoG7Qh9u6Ke34R2uB7pKQzYr7TYw66zaCnHOn0QYO5w6Uby4ORBRz9Unb0aPdgMMjI+03agFDMUFvdi6EMIkgpFQu7CfrvXbqVWwg7f6n00zv4mp+qu+OQY++NMQRW51pV+g7j0UXGuJ/yTlxL46Pjnb2ZPU+wteOAiu+5j08rBzsJE1XxyQkevFEd0xpSUkvrOUCOUFGC03Wbg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 60568544-07a2-4237-7198-08dec70c4612
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 16:21:06.4188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /GjLTUQxmukrGpZv8BUe3GHNUd9wp47vsrKZ2D96PF5FsqEVf8SVyN2q6POMXhNUbr0z83r+tw211MoU/cnb6rZ1QjbX/7XImb4wC+1JqPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6074
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/26 8:49 AM, Luck, Tony wrote:
> On Wed, Jun 10, 2026 at 08:27:15AM -0700, Reinette Chatre wrote:
>> On 6/9/26 5:08 PM, Luck, Tony wrote:
>>> On Mon, Jun 08, 2026 at 04:25:51PM -0700, Reinette Chatre wrote:

>>>>> +void intel_aet_unmount(void)
>>>>>  {
>>>>>  	struct event_group **peg;
>>>>>  
>>>>> +	guard(mutex)(&aet_register_lock);
>>>>
>>>> Could this get a short-circuit to make behavior on AMD obvious?
>>>
>>> Like this?
>>>
>>> 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>>> 		return;
>>>
>>> Same in intel_aet_pre_mount() for symmetry??
>>
>> I do not see that this requires to be architecture specific. This capability
>> introduces AET register()/unregister() and pre_mount()/unmount().
>> pre_mount() already does no-op if (essentially) nothing is registered. Could
>> unmount() similarly be a no-op if (essentially) nothing is registered?
> 
> Ah, I see. Maybe I just need a better name for my "have_pmt_hold" flag
> so it can be used as the fast exit indicator in intel_aet_unmount().
> 
> Perhaps "pmt_in_use"?
> 
> Then:
> 
> 	if (!pmt_in_use)
> 		return;

Something like this. It is not obvious to me how the rest of unmount will look
with this.
Ideally it will be something symmetrical to pre_mount() to make the
flow and short-circuit of the flow obvious.

Reinette




