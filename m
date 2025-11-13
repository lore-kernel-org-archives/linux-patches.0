Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC27923BD02
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 04:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763006551; cv=fail; b=FSuW9ijBJTG8e4lmd3fOKMZVwaq3oBEyOj3QD6fciifPTBlncROqTzAG+Hq11m5FlGRg48EX8zCDW8m9Wvsh4pwByYD7H238pj7sxoY53Y/7luNu3j/lphHsMVfMvVhmgdU0nr1pvB6rQpFxJDjX5FpMEgOljJoRtPa9hmJKaKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763006551; c=relaxed/simple;
	bh=0x+2BDre/iBHELTZgEl5IlPkIhv8GBWAr0AoSrnPJHo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PeICeLmDY5Ef13RXm8f4IGv5PrcMhjO1tyahRahW6eUBM8P5PCg268wKcXJ3hpYhPyI8YRHtk42LbEla7oW9RxBloQnnbi6RFPxuPSUYMnYc3J1ENivD5aMxRSM5XJnxvEmFn7w3SHY7oOD8dXUJBy3LLtSsgVJOMc0w0g6iED4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AC5CZS+o; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AC5CZS+o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763006549; x=1794542549;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0x+2BDre/iBHELTZgEl5IlPkIhv8GBWAr0AoSrnPJHo=;
  b=AC5CZS+ohbJ3Jhf0GUq2U2LY8qr2U9nyg+uhMu2CldbFMGBXcNi/vM4M
   JzP1C/sT2p8iYk/yamxFNnKit4oWT22O2jRoaUzB+87XcBzwePxbWs9rF
   wQdEkPNQ7fn+yplX5I9BHw2hnnABw1+dzTYSUP/p36YZKQMGpedKf4Twk
   D4A0BUK4hkiD1OoXkqSRn3w2M4G23AdP0tLHVzKMZ3h8epYlLdxrUtex3
   pPu6ug0Ig83FVwh5WSKq+/7MGtd4szeglGFK6hTduGYRhSdN2nMxir1SQ
   b0q63ipBUCG3kvK7XoQR4hB81JSFJ79/BCZT8bA9iWqlaYHOfAQIZZ55t
   A==;
X-CSE-ConnectionGUID: o0XgumpoRQOzqCglvDqwbQ==
X-CSE-MsgGUID: WNiogbKrTwaDOJ5TVJDwgQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76541810"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="76541810"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:02:29 -0800
X-CSE-ConnectionGUID: 8m8INVDaQRG/l8jefp57TQ==
X-CSE-MsgGUID: RK7HbfIBT4qZYn7ZhSkaaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="188645871"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:02:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:02:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 20:02:28 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.66) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:02:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=coyJW1uhnwpj+WaqtX8qBfkVx+c2GxG7thn7QQ7sgWKAATyxC89dEq1qo1KNAXL7URfMnPJJeqY77WtQeD0y/L1wW0CiZetiM9ASJHzaxNZEUA2q8SzLNIXb1+BImqWLtbwTnjFhZCO6uBHTa+x0DaZqEa+jcCoukI+sUVJa29DQPGfGgHoPU+QMN9NVOaJVGMPqCIVybdEmBuUL5iD/Lqhki+yP9YG4XMSgZoH4LwF8LzzWyu+jT5h+jIuxjD7O3yFr1+slZgRuM/RMFs/Zen/uQZJcYgwsBqY5Dg7MiZfSr4TRtHjgCbjUMMGfGJQsA/suxCs1ARAsNwETp3Vbhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VE/Re+p6mjkAqYsdc6O1uZ851kX1h5UtygIk4NJ98i0=;
 b=s+hd1Xp6E5ojel6RsDCSjAdAzZdkb/m2wbrrnzsioYsJWg+02xmNoU3659O/T8PhagMSbmielzlwqeYzj+PLlmEUpiLaRcfj/FhAEVdtTLUPjjR1VJGmhXfSA8RKYJF9Fg2k+Zd/o24CKS3zK34JaBsz0RaEUMomEfiYRu6k+f/XVD28u/1Kr0cjvJKlXL7E1lI8xWjXB6zveKA8emqmadN+0GTN2uOANsaQLdPHb6u8TIgxFSH3TYV7BD0TvUxdDMtFkmxG7uoC/4LBmkjhHcTEQZLQRfIh33r+P1plXPL/xoOymFTwdK+/FuMcxBzNerd7c6XK05UteYDk89aLCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPF341F90799.namprd11.prod.outlook.com (2603:10b6:f:fc00::f19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 04:02:26 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 04:02:26 +0000
Message-ID: <49aaa6fc-b75e-4394-9abd-07a6b4a0822c@intel.com>
Date: Wed, 12 Nov 2025 20:02:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251029162118.40604-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0064.namprd04.prod.outlook.com
 (2603:10b6:303:6b::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPF341F90799:EE_
X-MS-Office365-Filtering-Correlation-Id: 2795929c-19b0-4a16-93e5-08de226974bb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cy95SnQ5UGV3UjFtYlIyU3B3USt6b0VldHA3a1BJSXBKSWd3eUZwSXBmVFJj?=
 =?utf-8?B?WVhnQVo3UG0wYXhnRlpNTzUzZlN5TlZFWlBFdlRoUS9YUlZDUURSRmRIOU4w?=
 =?utf-8?B?MXRwN3p2bTIyU1lDVFZRWk1QLzJEbUhJdDRsbDVyUlJiSnhMaGMvWElDMXd6?=
 =?utf-8?B?cWxNams1dDdEeSs0cnRNa3AvaUp2Q2FwZUZHSFVOT0dDb24zdzhnS2prRE05?=
 =?utf-8?B?L0tNNXBlekpXZE1MY3ltQ05UTzlSM090NzFOU1dycmRyZ3NQSFh3c3ExMmZS?=
 =?utf-8?B?SG94Y203VnovbytjQ1RTTTBTNU9OSmZPbUF3ODFIQTlzcC9jQllVMzFwNVpu?=
 =?utf-8?B?dGlCRmtESjk5amM1Ylg3enZtSlk3NFNGYTF1RDRhMERSYjRQYkZRSWZ2ck5F?=
 =?utf-8?B?dkZ2WG1yTWhYeUhiZ3drU3Urdkd1Tkl6OTg1YlJTQ01sbmRPcFBuK0pNQmd3?=
 =?utf-8?B?OEdyYnVCTHpYRkpPZDJmZGtNUTFCWG9jZmliYy9lb1Z5dmZjdTVSRnpENnFH?=
 =?utf-8?B?cnpUK0IyOWRmMkZ4azJsa2pWT3JVSGIwRndmdG9ySlhRNXBtRjhXUndCSi9a?=
 =?utf-8?B?d2lUOFgyZ0FDeUVpWitBOFA1SWh2d0xYeHBVS2pZWS9QRTRsT1R5UzVYTUM2?=
 =?utf-8?B?VEpOb0FPRE1iNWtzOWhWNHNYeFRvcE5qOHFDZHFFV2E4L1l6NkphL3VaZE8v?=
 =?utf-8?B?WHJNNElrNE5qYnlWblRPcVd1OEZmc1A0SzN2SUJqWGVuejBNLy9IT3IyY2Fn?=
 =?utf-8?B?K2NQTnJId1pqNVZXVW5QVlY4TndvKzZWUXQ4TGtZMUNwYUFvK3k3eFlTRGh4?=
 =?utf-8?B?OFdCeWJyd3pjUVh5L2tTMDdubjhmRXN4aFhzUkx4RDdiQ1Fud3piU1BLUFdY?=
 =?utf-8?B?Z2ZSRjdMRFpaamV1V25zeU5zUGhFQU9GeFRKTWV6VnJJYVNIeVJ4aWR1WlE4?=
 =?utf-8?B?QkVmS24xL2RRdUo2Q01qaEYzYk96NTBWeEhCVUVNY1lQbERLOVhFVnpnTmR5?=
 =?utf-8?B?TWZLQnJyYkg4aXhvR3lsaVhHQ0F4RG9BU0dpbXJVZ3BQTFJzNDd1L2FYWlVn?=
 =?utf-8?B?MjRvaHJZeUxDNHZoaVZmUzFoRVJGNjlOQjBKeU43L05LN2NCVEY2aDVDOVZ0?=
 =?utf-8?B?UjFqdkg0Z1k3RlJLN3BKSU1GWHh4RDlMMUg5Q2ZaOWI1L3dXTDVBaUtuU0dk?=
 =?utf-8?B?SVhqaDFJeWxzTWZvakVtYVVSMjdoL01WaDdDUWtBT2VLa0VIdHZlOFN3eWFL?=
 =?utf-8?B?VjVPWTBhVDNPMFRvWElyaGhjMi9BVVg2SGZrdXNUbG9SZGV5ZysxV2M4OEll?=
 =?utf-8?B?QWtJZmd1VGYzanV1Q2c0MGJKZWJUcC9sSG9DcHJxYkJ4VEszcUlGTVdXTC9k?=
 =?utf-8?B?aElwM2Z1WHY4WUgvM0JjekwxbVNMbHgrL083UEcrUXBLUlZUZW1LODRyczFS?=
 =?utf-8?B?QjlNUFlhTHozSGtpMEEvYnhKZ05MTDNVTCsrTnhMN29jbVc0QjFVRkNpM0Vn?=
 =?utf-8?B?cFRObUxodUdCakhUM3RjNHpGMHN4NGF3dlEzSjIweDcwL1ZzUGM2eFpicjJm?=
 =?utf-8?B?SzBsUFJrNG9zVkN1ZVNhRjkyUVRTQi9BbnNNNHhUNDdyRzl0K2VqSGpnODZV?=
 =?utf-8?B?TzZOZnZLSnpoUS9ZOW1yYkkvZFV4QXVqaUtxMHY3dnFqdTFWVWxSYXNMN1Z4?=
 =?utf-8?B?ZUl5TXRQMm82T3JnYmcxK3RMcTFjbG1HNytVeTkrdEpuM1NwWEFHUWNZNlVH?=
 =?utf-8?B?L05LaisxS2puK00zdzNNdk9WRVZneVM3M3BmRXlkaFRoYVM1emx5OThHN3Z6?=
 =?utf-8?B?WDIzdERrbzFlaFh6d0RubWVsTkR4eDM2c01HQTYzamQvU256RTZoTHNNQnVI?=
 =?utf-8?B?eEFIWHA1Z2g3MnM4S2xXelpaU3hLSVplRi9JbzZPODJDMjgwOXdQK2JNRWdu?=
 =?utf-8?Q?S4qqNyP3ihOFvM5vDesjCaUFmWBwhFbg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFVDZmRWaGw2VkVTeVIwc3hhZzhzNmxrbmFGTlQ1T1FwbkZKL3dSRTAwRlQ2?=
 =?utf-8?B?QVdIT1pWcFJCV1hmRlVLVDhxejU4N3lCSEtHQkk5NzAyRTRUZDZ1YWFUbVZK?=
 =?utf-8?B?QXNlT09mQzR2VEgwWW1QNWlSSS9nUlJVVmdSU3BxbkU2LzBKTWJNNUxhNUVH?=
 =?utf-8?B?YkRVZzhPSHpxVU84cUhvTTcyME82eFJKcS9MTVQ5MSszNlozeDV4VGt5RDRQ?=
 =?utf-8?B?MFNUeHpYdzFvTUdwd3BxaEZCL2g0Rm9iVnVHMUR6alZxWWdubVQyZGlHK3B1?=
 =?utf-8?B?cUY0MWg4Y25pMEwvMkdqV2dVSTJxNEJVU3dwWEtnVXR6UStCdGNUdEdCS2pj?=
 =?utf-8?B?c0dXQzFYUUlXZEZPTWFzOFE3MFpyMUZGT1VIaXpoUjRIWitTWFVONDJEUktE?=
 =?utf-8?B?cWZsYWw2Mi96U0x0WFJSaVVyMVByZEx2UzBjc0lUaUFma0ZhaUdrWERwSG5a?=
 =?utf-8?B?YkZlN0ZPUmNzTEROYjBqaFcyblh3bFpKcGZzVTlpRGo4OEZRSmNabXZ4Tk1v?=
 =?utf-8?B?cmhuMzY2eXRPUVo4cGY3d1ZkQmxtTnA1NHZOR0tRSkUwOWNHUm9uUTM1aTFL?=
 =?utf-8?B?UkM5TVg3cTFubGs1Smlia3pEbmx4RmFSbllUTWxERE9yS3VWakVQTy9FeGdC?=
 =?utf-8?B?QjBIc01vTEV5NWtaL3J5QUZSM2NIaEJqYW1PdnY1aEtPNVNFVm9jenF1Sk84?=
 =?utf-8?B?SmRsNW54eVBFdCtCWmNvR3FoS2hQVFhTVVlvNjVjYWJ1dU5iY0tOVW9jczYy?=
 =?utf-8?B?SVhDdHl2d3dTazdMVVlOK3dFczVsbFRDY2VSYmg1QVlTU1JQTXFqVmpTSllv?=
 =?utf-8?B?blNVdjdwZU5BdnhnMG9XdXpWTUVab2t3MksyV0ZSVnNMRjBhOXhrdHhLRzE5?=
 =?utf-8?B?ZnNuanhVTUZ6bi8yOGNhVlBNNHIrVEhTbm1HeEJoRVlTTmxVaDUvN3dIZGJ6?=
 =?utf-8?B?TmpvdEdKZm5DNGtSbk56d1A3TCtFVk5TOHZMYi8yR0ZxVVd3dzJQbWVCYmFi?=
 =?utf-8?B?M044RjAwdXVoeVI4enBFSk9mTDF3UGpzSHZrNmhNQ3NqM3hON25WMEN0Y2RE?=
 =?utf-8?B?N1NIKzlvb3J6ckRpOXBTazQzYkhpN2FDL084TENjNytIMjY2bW1HaEVGeExU?=
 =?utf-8?B?dGNVR1VLaGxBTWd0aXBnN0IzZzNRbDdlK1lMTGRlYTVhYklLV05KODNlVGM3?=
 =?utf-8?B?dHB4SVFPQTQwM1pDT09veXBSV2k0cTdlTE5KRFlaVjQ3RGg4cUl4VVM4QU5F?=
 =?utf-8?B?ODRtc0xoL3AzcnVlazA0UnRkSUVxMzA2K010bUUvYWNGQjFuZkVRb25NRHRh?=
 =?utf-8?B?cHZydUUwM2piYUJDMkRkYm9STkxiWStIU2hBd2R5akFsSGNJdVppcG9ldUNs?=
 =?utf-8?B?eTVpMVowajRTRis0NUNCVkxEV1JWSUxGeVo5TTBRRHZLVURTQmwyNnRodzJj?=
 =?utf-8?B?VFByekppY2x5bitlL2czeXRpM3lnbjdWYzFRb1Nxa1FQN25rT3ErdHhYNFJ6?=
 =?utf-8?B?UWFLTkViOFFLZmZQMThHS0wwMG5JQ2FWajFkZmluaWRsaVJnNjhRT2VwOS9h?=
 =?utf-8?B?NjNIUlhXQmVLbnFiMEdvM3pMWkxJb3F5MjJkR0hLU1NmbEpMS29qdFhvenBH?=
 =?utf-8?B?S05iL2FhVjRMeWxUOTJPWFNFRHQrVm9aaitYdEpZcXRXWTBhL3c5OUFrWVdH?=
 =?utf-8?B?TGJEclRNbnVDRE1yQkk4QzBZOWVOK0MzcDV5dDAxbVg3NlZMd2sxM3JIM3V6?=
 =?utf-8?B?WWRodEFHOWRPZ28yMWpaSGFXS3J1WHFEdVNpMWRMQVpJbVNaYXJBY3BQTDI4?=
 =?utf-8?B?U2k1VjMvbUNVSTVyN2tpTElDVTNGNXdrdlBON09aRlZXWGNSRkJNbUxEK2pM?=
 =?utf-8?B?NTNJUUIwZTdJZWNTUVBZZUVUdkpGdndGMUhnci9mVGxScVRWaUp3ZWN4TW5J?=
 =?utf-8?B?Z2ZYWlREanp1cFlyQW9FaVczL3dLNHBvbi9zTGR3Yk5DQ2lkdDR5dDh4eUJD?=
 =?utf-8?B?bWQ0ajdVWWQybUtoK1BtVEgzQXpTbUFpOURZZWZScXZDYjZaMDdLekcxV0pH?=
 =?utf-8?B?YjRuMmFVQWRKaUV2ZURKOTh0NHdTUzNPQWp5bXRSS2U4M2c4ZkR4Tm1yR1No?=
 =?utf-8?B?NHBDRmtrcUcwMTU5SDVyTHBhYWZod3ZTZGFXTGJrckRlS2lZVWNTTVpOOUhX?=
 =?utf-8?B?d3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2795929c-19b0-4a16-93e5-08de226974bb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:02:25.9756
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z9p9EKPjk55F2xr3i4LM4pninqwHEIF1pr4mM9jUU853xv8ixOjiKJum7MDOBppSaVutYnPWXKN9lQTcpS/Tt+4RukdOL3A/O2hXi00tUVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF341F90799
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:20 AM, Tony Luck wrote:
> resctrl assumes that monitor events can only be read from a CPU in the
> cpumask_t set of each domain.  This is true for x86 events accessed
> with an MSR interface, but may not be true for other access methods such
> as MMIO.
> 
> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> indicates there are no restrictions on which CPU can read that event.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

This implies a generic change while __l3_mon_event_count() cannot support it.
While I understand why cpu_on_correct_domain() was removed, the existing checking
requires DEBUG_PREEMPT to be set so I think it would be helpful if there is something
like a WARN_ON_ONCE(rr->evt->any_cpu) before calling __l3_mon_event_count() to help
catch issues.

Reinette

