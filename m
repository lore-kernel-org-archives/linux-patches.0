Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091FF191F92
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099182; cv=fail; b=JJ60BnRno+L904tsHAs0pUXwSiPndsnKcKbx/WL2ZJJWU3HYg4HMzf0WMWKb6Q5QEubyIyIicShHHDK0cen17RNL43qEQTDWX6EvPqm8P1X/9fmIZKsNn1ckxJ0OXuUT4IkO7lWF2KrKardwfhWZXmk+jbU/PEZuFv4kcT0fgYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099182; c=relaxed/simple;
	bh=7abAoLA3/TVYD9tpek/u4NqE49AeVOd1hP6zNndMtXk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jMRl/eIuuIYwZr3M8vegDKGyjqHBQtKxpWP4Jnie2DWBD6RsqbizaNmk76ylGLpC8NyaRZwi33g/doGJqQ2oGRIRvuGsBoWMcm4baPKw1GI8BEZQ4Kl7bHYkHux6PxDjftRNw7dPZVIFuZy0vG3tXh//Jujv0uwPLhCTQ2D/XvE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XHMu3k3B; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XHMu3k3B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099181; x=1783635181;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7abAoLA3/TVYD9tpek/u4NqE49AeVOd1hP6zNndMtXk=;
  b=XHMu3k3BfKW2tftnHvWHCcUixvWJLqTf0F35kR+8zWGkmuYAjOeSA606
   Luzt24Qt3u+VE9mfwhoYICA1lZIS16PiV1NzleXZav8xKgxbRr4aM0kYO
   mrRHFKOnCelywnwMwjkQhsLv1VTUr8XiDLXjPz+7bAFVp1manbxwdh5CZ
   8jWqAXJSzBaplwxj+/ssUMJb/Cfda1VoEXC2sf7IIGDbw4jk1bd/T0NBD
   PGWVwl9gEyXZILxh2/6JpxLpPBfaoL88nnPS5Hfx7kljbMzEHIrL+hCjU
   u0KP/HFGAMJHcTlScHHlGRNDHAMXYUy5mb0KQ6zEuC0wG6yWvu5YeHDge
   g==;
X-CSE-ConnectionGUID: sQW+PJtXSZSpFITRQu00gA==
X-CSE-MsgGUID: aE6V35tDSoqkY7etsdSP/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="54464785"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="54464785"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:13:00 -0700
X-CSE-ConnectionGUID: ZZMvOHz8T8yQrQTchMSIBg==
X-CSE-MsgGUID: VaGF5lqVTOivxXfJ8uXECA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156031874"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:13:01 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:12:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:12:59 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.61) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:12:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NlISwN4lusBXQ9qok2s06iv5ml4npLn0p1z0cergRVc83FWmb/omoiKixkW+1iTskBqUOxsUWTUR+tDMV6ERhY0Ju1ssF0B2vxbWPi5A0qBi/uPCbh7N+XNDkMXexQMijaKcPRWO220w7OHQWvpLXDCE4te/dBN3cxoEmEPkFK64YesN56wppLQMDBKLq8c+KmOTHwz5dvvOq5zsfixzxrAOR+MmTi9WxOze6Ds+2uQkOgahm3jf6COiqTHBTRecWl/LLB4pXvD0gVeZEKVHbf3Nxv54Tm3ymtAG+YsC9TeGIY7Wv/mhdMbWmI1X9ARl4siL/BFs9zxpNytX+oBK1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fabBWBJHVprq5oZlzAnBmpSNgF17QB/eddVSxav9Byo=;
 b=s9bWILOsWk5S1egZ36JDGVEUAG0l6PU+/A+pXe27PS3O5R4wxEI3bTLjwQNwr1LBTgg1vx5w87EdGeW/r4A/SBFKOX9IK8Lnr1ivXed/CRoObgOQsNpKkPIIz8DQ7iJaoafPOz8FWq1H+GK7ccuv01RloVXlv8+1Ag9YTBr7NZ7tvc18H0ZsDv3ipTTdbP7kJHEte5Y2RufXW4uFafnnJedatW96kH4pUCGjbKXAJ/R9tUURaLdTiBOiJaSqdHzzuwW2275lG5WwYoFTJ6RWFWz/G7SMqRmGxdbPDOA+qIJ5EFOlAN2yd6kch2EiBi8XF3G3oRgtshC8R0qVbLOjZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS4PPF1DFB73954.namprd11.prod.outlook.com (2603:10b6:f:fc02::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Wed, 9 Jul
 2025 22:12:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:12:44 +0000
Message-ID: <0d505759-26cd-4101-86dc-4d3cbc120481@intel.com>
Date: Wed, 9 Jul 2025 15:12:41 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/30] fs/resctrl: Make event details accessible to
 functions when reading events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-13-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-13-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0001.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS4PPF1DFB73954:EE_
X-MS-Office365-Filtering-Correlation-Id: 076de786-d87d-49c2-b01f-08ddbf35ba50
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NlZOQUhFaXBYYTJKa0p0cEw1QlZIcjlYYnlja0tCd0NlRjFYOHE4b2hLUUZ3?=
 =?utf-8?B?cmtnS2NEWnF6b1RndkNyQ0tzVlJtSmZpcTQrVzVqOFd0SElSMVpZWDhaNTZn?=
 =?utf-8?B?RW5FTGhCNkRQZ0dlUXIyNUxRdjhKSTlvVE5GSUtEWHZYYUdmRDRtcXZ2T3dS?=
 =?utf-8?B?YVdBbFNIcEs4QW1paE9aVmxzTFN2Yi83VXRzbmQ1aldWcitNNUUzcHpMTFFP?=
 =?utf-8?B?QWlBM3VJZ1pPdDY2a1FBQkdhT2hwNDlOd25aVk1wNnFVOGJPRVF5STlST1lx?=
 =?utf-8?B?ZzVmTmdqbUE2aUtrNVRScUt6eTRxN2xhNkhicHUxK2Q3MHhkeUFwUG1UUDk5?=
 =?utf-8?B?UW91YlE5OHhqRGtqZG12VVBFU3hQMWk2bXJFaVM4RExNc3hoUW1OREpWUm1H?=
 =?utf-8?B?UFhaR2lid042aXRqWVlkREUrbldIWWpRRitlS1VoV3hqS0YyelMyakk0Z2pv?=
 =?utf-8?B?N0ZoRUxjdWNtUTF4ZXppa2VuM05tMVhRaGFSV0k5VHRDNHB3Qi9mRHpjVmVP?=
 =?utf-8?B?aGV5eDM2ZmVjYVA1ZC8weU4xU3FCSlpPMTBqMEVhZldSc3AyQStjaUdKdGg2?=
 =?utf-8?B?U2wyMnZhKzZNWTgwd2ZBRSt4d3k1ZlgrNU5aMC9DSHRDZzNqUThEZGhMUU9Y?=
 =?utf-8?B?d2FCS1hpLytiK2h0Y0hvZGtSL1UwTGlkVlZIWFNmV244ZWxJUm1yaW52RnJP?=
 =?utf-8?B?VWluZmVuMGtEY2ZtZy9yYVRTOGNBbFpNNEFPOHpHcndFemFuaEk2aW5PclV6?=
 =?utf-8?B?VXpiU0VubEtUcTNmMkp0VEViSHJUbW12T3ZxRG84ZXpsT0dQRmpMQjcwV0Ja?=
 =?utf-8?B?dGZVT09ISHVlQi8vUmZDN0RTV0ZHVnlIcnV4NHV1aFR6RFVhWFVxS1NGenVl?=
 =?utf-8?B?Nng0WG83disvS2E4QnVWY0lyd0RkTC9KQ2RuNDA4RkNObUxqOGhMc1ZjN1dS?=
 =?utf-8?B?SzVUQ0JzWXVjZkpqbktGeCtoT3hoUzZMeWFUTjlHRkVNclpvQlBmVGhpZG5q?=
 =?utf-8?B?UWlnYkczcU9EczVxdGx5YmJUWjhVV1B2blY4UlBFNksvdStscjdWcFkwSXh4?=
 =?utf-8?B?bEkzL3VnamxnMGRSQURvY0FvQkVlVldackhqbTQraHg5T2xMVVhGN1VvaUFm?=
 =?utf-8?B?ZGZsUmcvaGw2ZVoyOGJZSlpycThZN3RpTm5PR0VBL0xaVnNSSmJnYy9ZZ1hw?=
 =?utf-8?B?VldZcEFQdzJTVFRTYm5nY3I5eTRndXRnQUdURUZveU9Cd1NzV0NDVFRkeFhp?=
 =?utf-8?B?QUFkTEtLZlhrdkFObkd0Ui9lUGRJRnFHTHFvajR3emRWdnUxM2YwSkJ1Qk01?=
 =?utf-8?B?U2l1V1NSRmFKZ2lWV2JvazBvb0NVNkQ0SmZGaFp6MVlVTDJxWGhhZkF2NFEx?=
 =?utf-8?B?SWw5eWtZSHRablUzaTIxY0YzMG9ZcFRQeVlxeEIycDhJWmc1QU4xSHV0SlFQ?=
 =?utf-8?B?MVZ1NVQ4bnZDQVRZOXE0MFFRR1dGc3Q2WHhmbC9wUEM4VlE5bkp4YkVmd2Zn?=
 =?utf-8?B?bVBwalQzWkhkNEZzRkpyUGF5K3RIdHV0SmM1d3VQWVFXSE5iSGpJVElqSHRt?=
 =?utf-8?B?bjBKbEM5andqa1NCNkxiNU40VlR2SVV2azlDWFNLdmtRL1loL04vcU1rMHd0?=
 =?utf-8?B?dTZSaGVtdGY1bytYcVZxV0cySTY5OGljSDVmL1lROC9TaHNieGw1RkFkV2tn?=
 =?utf-8?B?K0RsWlhEZkVYekY1Q0ExMjJJZXVSZ1JXK1oxMFdQRDlXeTdLdnJWQTRiYlNm?=
 =?utf-8?B?akRCTlFSdXBmcHZiVXRBeHNMVHYxeklNem5OVG45ckZOTGo0ZTZBMEVpQUhw?=
 =?utf-8?B?SzdJeHIzcytHblFtUGloUGxJUkRRbkZLYnk2TXpjcGNQN25TL1NYU095Wlk2?=
 =?utf-8?B?U0NXbFFwbWIwQm1EMWt6M0MzTmt1dGhwSFlBaEtvb0VEQWtjWEo1bjkwakti?=
 =?utf-8?B?ODEzajl2ZVlUZlZWMDFkenNwNU1iQmdnTllhOFVqNkFzWmRiRTdGbUNib2ts?=
 =?utf-8?B?VkF6QjlKUjV3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?clFPQ1gyVDduZVFXVytlb2FUYWlOL1RqeGFvbVdoM09GbWJZVVk3TXp2ZTUz?=
 =?utf-8?B?VGZxZW02dDRqVjlxTDRybFNwMFc3c0tBNUREVWhrNE85SmtBQmtTVEhnTTJm?=
 =?utf-8?B?NmVlRTd5bVgweUl4bkozdU9qR0FiSjdyOWlJQU5LTkx6QUp5U3hpYjZWR0FT?=
 =?utf-8?B?VWpuMy95THNYdWJKOGZYamxocSsweDBRUnpIVjJvZHNyYWpVWXRielE3OFJv?=
 =?utf-8?B?OCtwNmpFNXJUU3Bpa1RMWlhRTmR5eDJkeTZnNTBWV2c5NjR3aFJDQjRNc1ZV?=
 =?utf-8?B?Q1hVVno1YlhSSHk1UlJXbW9NUU9PT3hlODVZMzUvbVY3REk2ckRwdzBBV3c3?=
 =?utf-8?B?NEJjTWxVWEN2REVrbEs0eDRQdHNxcUxrSDdnVnR4bUJUc2hRZHd0MVc1YXNx?=
 =?utf-8?B?WFZNRnBGQUVMUTdIV0owRG80YVg1ZVcvMnlTamNZVURGUWlRNmdvS2VuSVE4?=
 =?utf-8?B?VmV0LytHc1lnalk1eXlpczNQRnZ0d2JkcFZFMWNseGNQbHRwWnBhUExoZlRp?=
 =?utf-8?B?UUFBUVp1OVZkdmZlMUI0c1pYZmxzN3kwZ1RYbGF2RXdnVDY4QWthN2ptU1Fx?=
 =?utf-8?B?Q05HSG9rS1M2Q3dqVEZueHhCK0tJZmdlUXNSZklzTWJkR2U1WFlUYWZtT3B5?=
 =?utf-8?B?M01NR1Z1Z2VxUDhlYXpXRmNjR2VDM0MvZTdhWVlPbnVNajVTeU9SWVlFRkNU?=
 =?utf-8?B?WXozNDUybjBQWXB3djJsc0NxVzFPWmFiOURBVnpmUjBFazRQbFY3eEZ3WnNn?=
 =?utf-8?B?bGd5VzdHUDgxN3lvUS9Ic2o0QnVLWHNRSWhaVXhoZncyY1pzamhQNTg3YTRV?=
 =?utf-8?B?YW5BVVBITGxMcXBVL05wSkN2RlRlRm43K0UyM2o1ejlhN0xqT2w3Q3hxRHhJ?=
 =?utf-8?B?ZWNFYzFJdndhdVd6Y0UvMWttVlBJWXBmZy9LNDBDUWQwVVdlMWliOHIrdkNP?=
 =?utf-8?B?K3EyT1VOeElTYjBrWnE0SFlhUGo1U1d6N2F0LzRoZU5ydTlhWHNnN2dncTJQ?=
 =?utf-8?B?U0Z5WURSZ3dNR01iZWVZOWRiS0xjbzV2Q09qOXRPdFEzSlZpY0wyVFJFbHFn?=
 =?utf-8?B?emZnTFRJcUx3MHV2WjVnK0V5bVpMR3BRRURiZmFDTm9kSCswd3ZrTms4QktK?=
 =?utf-8?B?TytpVTcyQ3FWcmgvdzZ5YUdHMzZDeERrK3pnaVNwQ0d2Ni9nT1M4RFQ4Z1Jx?=
 =?utf-8?B?S2laUzZjWVhQTWk0WTViL1lkc3ZnU3F6K1FUUWlJK05yd3REbGhxUHBPSW1X?=
 =?utf-8?B?ZXJBTktUSFhrc2FnSE5XK2NsWFkwbUhMUHhGdmM0OHVkbXAzUDhBcFBhMjNp?=
 =?utf-8?B?VzgvMUcrZGkyS3hOc3pvWlZ4SjRabEl1czFoMlhjWnNUODJvSGNBclJtUjNX?=
 =?utf-8?B?WVRDbTBoTzE4SGl4aFhiY2VpQW1xa0RSbGJlbkRUYms0TWZ2Z29pY3lXQU5D?=
 =?utf-8?B?YnN6QVpJRVRFaG9wZUl2bTFSTHZpSW5CRnhOUEtXbHRtY05WVnNUR3EzZjRW?=
 =?utf-8?B?MDZMK29MemlOdyt6SnR5ZWc1UHErQkZpcXgwWWhJc2RiRHdmRXFQU1MrWVRR?=
 =?utf-8?B?VG5yR0N5eUMrOEJOMkVCd2ZMYVE3UndlZ292cmRrVUs3MmVHdjhjdFVDK3h3?=
 =?utf-8?B?aTVyaWNzR3NTcWhmSWg5cjVIRzZwVU5KZmQrdE54bUMxbWtRa2dhR2J4L3d3?=
 =?utf-8?B?MW9Fa2dvTTdnZVVJbGtRaHVkeDJXaEJENzhwdTI1Y3RObFlCUFlMWUhoK080?=
 =?utf-8?B?eEpHNjVPUTNKdldxNUNuTytHRDExeXFaWDE4cE1IbTlMQk8xZ1VrRHpxTngz?=
 =?utf-8?B?a3pNRjNNRnZiV21HM0xnN1pzbVBmMkcraEVDdlRrbHI1Vk8yc1dqMWtVbXIr?=
 =?utf-8?B?b01sV0dzTHFvTXNGOW8wOXQyMGc1K28zUGVjdDBPVDhuYThxR24yaGdIWnNs?=
 =?utf-8?B?Y0loaE9uZXdDOXpRSFdRQ0s0ckRRK2pYSWpJci9rb1JUWVZQY2thYTRQVlJl?=
 =?utf-8?B?cjhodUdoQTlEL3o1cjY3STZkdFk0aTV4bXUvRGo5SnhaR01uWit4L2hNUG4z?=
 =?utf-8?B?aWJUcFJ5UFRBWVl2UHVGOGJvUkVDNForSDdpUnV2N0JVR1Rpay91Y2NqM1I5?=
 =?utf-8?B?cHo3Ykh5M2tMTjhKeTF4YklneG1ZUmg0NHdnSis0L2s2WUV0VmFNNXlZeFJN?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 076de786-d87d-49c2-b01f-08ddbf35ba50
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:12:43.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nwnMLT5lFn2AOCxMSSn67m/oUN+BShAI7aHXSuCtpM9twYM3Vt7fDsP3+scN67VXUxbiz4rG9BI6flTeUkACwsut5XbHJPpws5qxpVnFC2w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF1DFB73954
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> All details about a monitor event are kept in the mon_evt structure.
> Upper levels of code only provide the event id to lower levels.
> This will become a problem when new attributes are added to the
> mon_evt structure.
> 
> Change the mon_data and rmid_read structures to hold a pointer
> to the mon_evt structure instead of just taking a copy of the
> event id.
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h    |  8 ++++----
>  fs/resctrl/ctrlmondata.c | 16 ++++++++--------
>  fs/resctrl/monitor.c     | 17 +++++++++--------
>  fs/resctrl/rdtgroup.c    |  6 +++---
>  4 files changed, 24 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index b12242d20e61..1458fda64423 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -90,7 +90,7 @@ extern struct mon_evt mon_event_all[QOS_NUM_EVENTS];
>  struct mon_data {
>  	struct list_head	list;
>  	enum resctrl_res_level	rid;
> -	enum resctrl_event_id	evtid;
> +	struct mon_evt		*evt;

Please also update associated kernel-doc.

Reinette

