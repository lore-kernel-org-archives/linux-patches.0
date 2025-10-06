Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575D426056A
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 21:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759786440; cv=fail; b=mVR0PpFXN5VFm1LnRHoVMGkjUI+JpGmFllC2zu9+H6yw7wD75cgtzu9FBEOHXkgwmqsgvpifIwHUTvY2KlG4Md4sEIs4IhwAc5jWNEufzL6p+5FRZVocSdjzU8dn6B8CNizxgbZDoEyuTLMXmC2zx1G6R+ABugdbBpE9Kz14BJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759786440; c=relaxed/simple;
	bh=TiPwJ3N4VrHzGaZdfEJO7JxxrY/MiWcLFAmUd9Fdzsk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=slkpm0BSAwpE7/Vmx+k6QF3bkC4YqUd5f+hor9bR2Km50/wCGerLaNt0YPKeckIY49gxpQxDdACOWRmzOKJRP6WZ9IpGvoUe05rcUR1xhYGuGHG5dr23QZ74pvk4t8HlgfQUiP7KmPEtT3e8QBxTIwY9FYTV7VRaHo92Sn1x4lc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mMeSoos2; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mMeSoos2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759786439; x=1791322439;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TiPwJ3N4VrHzGaZdfEJO7JxxrY/MiWcLFAmUd9Fdzsk=;
  b=mMeSoos2fho0MIxBBjbY5mialV7ZxUA9sY66Lsl3Rv3G5NS2IxiW1d9R
   pO2lnb7zgiFTIzKGJJ4EeXX82GA9D0NwP2whrfqQgcwCdaCRxNQUT4l2F
   EQiFLOUOEZi1CHSsbXpV5Xoo5w2v1JY3PfJheUUP1xjp/epdGXxsjIAEu
   ZHk/GU2WeRWYOr1Q+YiuhZrId9DrRIZvauENAPmH1hwzWQKvaFgVYkf6y
   gseVPBWqnNA4mnpL+/7R6LV7YMCAotQOG9EHI+0/YqDJRlSIhyHcRhH0N
   MfF5fkawilBQ46rAePcooQv/fFC5X1nhFD1uXL/OQFtWNqsk88OSwLhH/
   w==;
X-CSE-ConnectionGUID: xz3Tx/AyTjyZ7BL2ewr2MQ==
X-CSE-MsgGUID: Uh+3ErsxSC+P1lnFrS2bpw==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="72582048"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="72582048"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:33:59 -0700
X-CSE-ConnectionGUID: Zk2240WBR+uyVD4EDU4HtA==
X-CSE-MsgGUID: 0YwlgwhtSr2YDBEenEnrFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="185267216"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:33:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:33:58 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 14:33:58 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.9) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:33:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IZp4gnnm2Qita9fEqdWzQEfeVFOSBhqsScxGmoXZDg9Fk9pQnQLBSjMtoZ+Lpv3oz3ED1N5wx5QIKweQ6BrDw9xolHxFZXXhMPPHX9wP8penu1JB9F2VOBhZYf1pfhmnU5VtbLpURzYmYXuEWB2+aiWaUQ0dkfc3R0hNva80xk+xtjMrAzl2w6L9Srh2F5ESYbCMhbyULBqSOdw7089LWL+WSFBJoFT9ldb79/SyBZegTi8NM2M924u7t2HA3Yyyh7uKWQN0YIrgAkaHEladiSVol7dBEi4HMrpt4AjS/GK/1SG5Co4AZl92mFwpPJNYXeMEOsxt+9OZQ7eW+SUEoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pj4DX1M9w0zV2hR8UvGHqBw0tJk+X9YhODHj/B10RPg=;
 b=FznpA7u0CRzvBCNGz3oQ/H0MRxXI6Ma1dA7tjeYmittSb0sg4rv4CakcShA7AHew5HQ2YYseZqhvf99Saa30vhAGtodQp8AEQJ3lN2Hx9950Thar8H7Ex0jPu1QZendWzEfTKZfCGBV7/JpOotfIQiDT7ZK3LxxDGgEV6AMGbC9Wo8/mCiwAxI8DRLZuPmur/cGJtI+Nurd3GX/7sqHUlJ8nPjv7c/vt0YW4ZyM03JvL4+ND/GdPGJoevoNGWsNBgI6ouxk3OaJs0v479DyYa/oQvgb1/m81NtQCA+IdDn08uDAlbjTwKQnG+GRcq7VVvPJknVyfz8X1JN5gwVdH3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 21:33:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 21:33:51 +0000
Message-ID: <9a6f5016-0997-47ef-b7d9-2dc4c578e345@intel.com>
Date: Mon, 6 Oct 2025 14:33:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 17/31] x86/resctrl: Find and enable usable telemetry
 events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-18-tony.luck@intel.com>
 <aecb9aaa-5b94-4787-a976-a633831596bf@intel.com>
 <aOQfevoOYWsftGG-@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aOQfevoOYWsftGG-@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0311.namprd04.prod.outlook.com
 (2603:10b6:303:82::16) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: b7b6d6cb-8788-458f-87c4-08de05200aef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UmsreWFZT1EvWGxhbnpnZFZ6akFDaTZnTUxKTWdiUmpoVGxkMU9CbTNjK0hm?=
 =?utf-8?B?WXBGdWZwNXZUdmVxZ0x3bmdNOW9HanNPR3JhSS9sNDhLQjBvblYrS1RCYVJV?=
 =?utf-8?B?enZmb1dqYVVqVkFXSTFTMkFKK0EyTzYzVTZwait1M2RZRDNNUm9GQ3E5Qzcr?=
 =?utf-8?B?WVdQVldGM3ZJUDJ5LzM2MHF3aUdxVUFOZWphOXJlZk14WjFxNHJlaHpHbDcr?=
 =?utf-8?B?UU15NXA4SkxtMmtMQk9OT2JKRElUaTdTRUZvVjQzVkVQalBNQXdMakJrNzJ2?=
 =?utf-8?B?ck1pVmExWGNJM1l1WFlxc2ttbWk0M3RPeFU4emZvejFVYWZ2cUs2WkdjblBi?=
 =?utf-8?B?Z01KbHYrYi8yMjhwVkQwZVVUT0JVZjBLSVYvQWtNN2liTC8rcHFvdC9MUjkr?=
 =?utf-8?B?SGRWbU9rMWllTXJBNVRONFBOM04vT1JoUFJHeGlTNHQ3S2JvNFljQ0lEck9V?=
 =?utf-8?B?M2dHTzdyYnJvTHQ3ejFvVTZGZWp4eE9QTUFkd0lPbjVFWVdER0t4eS9NRW9O?=
 =?utf-8?B?Yml4SmFleEJwMERHbFNablNDOWg4alZqY3QzZmlFSG5TeGJGVVZrK2Uzc056?=
 =?utf-8?B?K21pNGJOQzg1anUrMDJUZXIvQkwwcXRRRit1KzhEWGR1V2tyNFc5MVBYY0Z5?=
 =?utf-8?B?bTJYR1lUUEdrN3BzQ0tHTFQ3ZUFIZFVLcW1kbVhiQitLZFlDQ0psT051bHEy?=
 =?utf-8?B?UDcvV1R5WWdUN1BvazQ0Si9ZdFc1YTNJNHIzb252Zks3TVFKZ0dtcGFFNWVv?=
 =?utf-8?B?a1FQOUZRUkFvQVZRbzB3UlJ5cmxQcmwzb3pDOWhTSWt5ZHNqc1k3WDlBZjJT?=
 =?utf-8?B?V0xLSmdCemhtdlhXa0E4eVNDaU45anVKNW9BWkNaWmt0MmRSYVhLWHdmOHlL?=
 =?utf-8?B?RExDNVlHVXk2MGpQdk83SmZUQ3lleTZMU2l1S2dMQ24zVTZPZW12eHFyYnZn?=
 =?utf-8?B?TU0vaXZoeXR0dzRTOCttWndjVEwwbGlhcms0eXZoNHc0d0xOalBBWUJobE1V?=
 =?utf-8?B?ME45R3E5NWNRejdobmpuOEJBdlY2QmRXWmx5RFNxdG1idnV4RVBmdWkvSWc0?=
 =?utf-8?B?M0owUXhCMGd3d1UrOUJIWW02T1o2TW0wY2RQOHZicHJhTVZpVzNMejRtekxi?=
 =?utf-8?B?VWo5RWFxRkI0eXMyUUNCKzNkbDlYRXp6Q2RJckwwWUIvbFVHR2k4QVIyV053?=
 =?utf-8?B?UmdjQ1pZUEtLQW9WQytKcyt4TkdGWjhOazlrdTFrc2psZFNUVndZS0hlbmFj?=
 =?utf-8?B?T3JRQ1N6N2tMMmVSUmt3YnQ3TlgrWmdNU2dLV0lVZm40NG5QZFk0UG9QS0Fl?=
 =?utf-8?B?N25ZOFkrUGo2aGVWZnZudFE3OTJ0MzFLOFl6RWV5aTZMc2ZXeXppcjk0UkFl?=
 =?utf-8?B?cHRndWNBYno4UEVIaUdEQURyMzd2TkkvbzB5K3NLNHh0eUZqaHQxREwrVVBm?=
 =?utf-8?B?RnNhYWJZU0RjUTFjNzQ0WEQ3TmhnbVJMSWRiMHViQklDd1F0OGZpdXk3Yjc3?=
 =?utf-8?B?SkN5aHM5UFY3Z0pSNGRWOS9BSThhOU5kSkg3K3VWdFo4YUdXUmhNS05QZ29N?=
 =?utf-8?B?YnNLYm9mbzdrZkpHMjVyeHpyK21GQmNyK29IV3dUajNETy9FZmxhNnllSmlx?=
 =?utf-8?B?MWpBaUxQQm1Gdk9LeW5IcXRMREFDVXNvbnJYTGd5MmNwRllETTQ4TzU4THNk?=
 =?utf-8?B?dkdGUW5CZmFZaWU2b2V0a2dOaEMwNHkwQW9TTmFpMTVOVm1McEEyQVJYKzNP?=
 =?utf-8?B?ZzMwRHBBVjVhVE9KTzRKaDQxSEs0ODVwY2Q2ajRuMmp2Z3lRWnMweWVjUC9q?=
 =?utf-8?B?NDBLbHNHL0xrYTNXYnZXS0VaR1ZiamtTRkZVK3FUcmw1b3JhczcvR041eXNk?=
 =?utf-8?B?MDZHTGFxMzk4T0xDejV4dHJmNVpORHZRaForNVBjbytNcVFWMFNJekdhTE5K?=
 =?utf-8?Q?70FsPBIpLLPY8SUdu8DuFLFOGqHKpxrJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y1JNU1RvamRjanV3bzAzRDBpSW9sRk53TDcxV256aVhOZVA4MUExRVo4TjdU?=
 =?utf-8?B?cDJ4cFVCcVA4OS9KdmRCVUFZZFlSb215d2QzbG1OSmordXUybDN2d2c3NXp4?=
 =?utf-8?B?ZHBiOXJUb3hnZUNyS0VmZGlBcFhQOUNiSC9hcHNTbDNWemI0THRYNUQwbDZY?=
 =?utf-8?B?elJueUErWjBiMUkyN25mczNxRzIzY01OL2diR0JLZlRBMU1RamhPM1VFNmVF?=
 =?utf-8?B?RUNmdjU2RTlRVjlyN2pXR2EzZ3pWSDVER2RoaFkvUmorSkQ1ZmdKS012R0VJ?=
 =?utf-8?B?ZkhBRmluaDVteUp4VXVZSzNqVDgwOTFORnFEV1I2SEtWU1ZwdzAyVHFhbUpF?=
 =?utf-8?B?bDdhQy9SN1pCZktMOVhhelpHdGJuMEw5aDVtZ014SEdWeGhHdG1hSjVzeVdS?=
 =?utf-8?B?VWVkbmFHZm5IcVo2dXBLZDBtYmZ3a3hEdUdpbjQ0dWlCN3JRTy9wSEpGdFhy?=
 =?utf-8?B?QkQzaWV0d1BxVlpiVDNpRzdBampudnJTWFhxRFlKaHRxL0x4cUI1cGg0OVI4?=
 =?utf-8?B?VHAxMnR5bCtLOG0zemZIbmlTQzhaeFR6MDFmNXF6M0owOVhVdkcxL2JCRHh1?=
 =?utf-8?B?L0lraFVSYUM1TFUxV25zUkVTOERMYURYeUlHQ1N1am9FRm5COUZpOEZ4NHJ3?=
 =?utf-8?B?enZGQWFpckJnY3c4bjhJMFNQU2txVXVPQkNEZU9MZG9jVU5qdWEwODZUbDEz?=
 =?utf-8?B?Snc4bUhJWXc0NGdOTDY3VzBCK2w2amlzQU1uUTZnWHdSQU92WFUza0VhWXl0?=
 =?utf-8?B?ZEprUkZreG1PUHlzRVNVcUVjMFVRTm1hRHdUZTYwUFQyaGEvTkRUMk05QWdV?=
 =?utf-8?B?Wkx0b1ZwVzZIQlhzV1dxbVovcWF0ZW9mMkxtR0tnV21mU0hsMDRlSHdrM01x?=
 =?utf-8?B?T1g0WjFmWklKYlNrZkQzV1JGV3dCVG9lWm95SWlCN05KRmMxOW1QMHdtZVZE?=
 =?utf-8?B?Q21IVjNWVEN4VzRSTHNEQ1g0ei9MTHV3Z1MxeXR4bm42bVBYSjFVbkNKWFBG?=
 =?utf-8?B?a3h1Z2ErdEw2ZG51OGNWYTM2OTRXandKN21taTZuM1h1c1gyMGVEcmlKTitj?=
 =?utf-8?B?TFNtVWtYVHhOcjE4cGVJcCtlanRxMHd2ZUdkNjZVMkN4SURNZGp0bWxFbGEx?=
 =?utf-8?B?MzVsUVZ6ZGJJcnFMYUkwNUY3MEtZUjhCODBkYStNTTA2Ny83QkZKSzM4YnRW?=
 =?utf-8?B?d0xMUmdBWVYxbGlyRENzQnVWMUdGTGxLZ0c0bTZxVitkZURaT3JWODFVRGR5?=
 =?utf-8?B?MlR3U2tmcWYrMTdDc0xKODBkVGl1LzJqc0pJdS8ramFqYTNRYlBMNFlDYWg3?=
 =?utf-8?B?d1l3YlFpbG4xbnE2Qzh3RDZTYjQ5dXNKOVcxcE5CYzJoNFhLUFRvYXNIL3FT?=
 =?utf-8?B?NEs2VHRXYlcyY3RncVNaZTBhZHVObFdxalMwQ2V0czc0cENlQmhqTHVtVDVN?=
 =?utf-8?B?Y0lsc3hwVkN0ZFVkaEZqakhCcHdONGhTTDM3TFpOeGM3K0I5aG5GRGhHYm91?=
 =?utf-8?B?VlJLU29SUXhQK2xoRFNxencxZUNaaWc4UkhvaFdYQU9PWmp1R29mV2kxNU9D?=
 =?utf-8?B?dFQyYUVoZ0EyUkxSZ2p1blVmTjlrNG5kSkhhQ2taMHA2dFdjc3FvNDNBZTQ5?=
 =?utf-8?B?VklDZk1kRGVObm9CdVZqQmMxRlEzTmpwZ0krSnZHUjJ0ejUvcC96NjEreklD?=
 =?utf-8?B?bEdMakF0ZVIwK2dOS1NQMmRYOXY0QW1SWkNLTkVHeFJhMFdYUXVWejZ4SW1v?=
 =?utf-8?B?NlBqeHdabHRFS3VUTUZaTU51L09jc2J5eFZxcEVSQUZYRVQ5UEk4VjNueEht?=
 =?utf-8?B?VThtQ29WMnRrNExBalFJSzhwdmdEUXBZVmVRa05yQlVNVVZGbDBsZUZPRktH?=
 =?utf-8?B?NmhYa0tQR05PbmhnVjdzSndBY3B5QklTR2VUcDJJU0JLeU92dEM1aHA4V3lm?=
 =?utf-8?B?MUJlM2xPalFUZW1JQ21TWlBDREljZEZtU2JjbXowT21lb25ITkxaWmRsZzZO?=
 =?utf-8?B?MDEwOFlUWFJFOG5BSXVXUTB0UG1pbXcrb1VSNXFsejBTRW16cGZKVFZCVWJn?=
 =?utf-8?B?Z3NGZ25oMjBiOTV2VFN2a2RnZUxJMllES1V0WTMxRG5IbFZnYzFiMERtdUg5?=
 =?utf-8?B?Y1VWMGwzaTc3NjRkMTdXdlduWkVNMFVFaFc2d3U4SmtTbXJRbGlpLy9NRlBZ?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b7b6d6cb-8788-458f-87c4-08de05200aef
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 21:33:51.4957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/qSPrHH1ePEOE13JgB/Wpqsa4Gxpkh88e9FDDeXGcRUPYuJ7O2uF3qcjHjViLaxqxoyqQLDeiy2bkipSmCdZ0aY34HpJwO5a6qqMigQ3m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

Hi Tony,

On 10/6/25 12:58 PM, Luck, Tony wrote:
> On Fri, Oct 03, 2025 at 04:52:01PM -0700, Reinette Chatre wrote:
>> On 9/25/25 1:03 PM, Tony Luck wrote:
>>> @@ -114,12 +116,44 @@ static struct event_group *known_perf_event_groups[] = {
>>>  	for (_peg = (_grp); _peg < &_grp[ARRAY_SIZE(_grp)]; _peg++)	\
>>>  		if ((*_peg)->pfg)
>>>  
>>> -/* Stub for now */
>>> -static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>>> +static bool skip_telem_region(struct telemetry_region *tr, struct event_group *e)
>>>  {
>>> +	if (tr->guid != e->guid)
>>> +		return true;
>>> +	if (tr->plat_info.package_id >= topology_max_packages()) {
>>> +		pr_warn("Bad package %u in guid 0x%x\n", tr->plat_info.package_id,
>>> +			tr->guid);
>>> +		return true;
>>> +	}
>>
>> I have not encountered any mention of the possibility that packages may differ
>> in which telemetry region types they support. For example, could it be possible for package
>> A to have usable regions of the PERF type but package B doesn't? From what I can tell
>> INTEL_PMT_TELEMETRY supports layouts where this can be possible. If I understand correctly
>> this implementation will create event files for these domains but when the user attempts to
>> read the data it will fail. Can this work add some snippet about possibility of this
>> scenario and if/how it is supported?
> 
> Yes, this is architecturally possible. But I do not expect that systems will
> be built that do this. You are right that such a system will create files that
> always return "Unavailable" when read.
> 
> Is it sufficient to document this in the commit message?
> 
> I don't feel that it would be worthwhile to suppress creation of these files for
> a "can't happen" situation. I'm not sure that doing so would be significantly
> better from a user interface perspective. Users would get slightly more notice
> (-ENOENT when trying to open the file). But the code would require
> architecture calls from file system code to check which files need to be created
> separately for each domain.

I think it is sufficient to document this in the commit message to help create
confidence in robustness in support of different scenarios. I have not encountered such
a system but could this scenario be similar to one where a two socket system supports MBM
but only one socket has memory populated? I do not know what reading the counter MSR will
return in this case though.

> 
>>
>>> +	if (tr->size != e->mmio_size) {
>>> +		pr_warn("MMIO space wrong size (%zu bytes) for guid 0x%x. Expected %zu bytes.\n",
>>> +			tr->size, e->guid, e->mmio_size);
>>> +		return true;
>>> +	}
>>> +
>>>  	return false;
>>>  }
>>>  
>>> +static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>>> +{
>>> +	bool usable_events = false;
>>> +
>>> +	for (int i = 0; i < p->count; i++) {
>>> +		if (skip_telem_region(&p->regions[i], e))
>>> +			continue;
>>> +		usable_events = true;
>>
>> A previous concern [1] was why this loop does not break out at this point. I think it will 
>> help to make this clear if marking a telemetry region as unusable (mark_telem_region_unusable())
>> is done in this patch. Doing so makes the "usable" and "unusable" distinction in one
>> patch while making clear that the loop needs to complete.
> 
> Ok. I'll pull mark_telem_region_unusable() into this patch.

Thank you.


Reinette

