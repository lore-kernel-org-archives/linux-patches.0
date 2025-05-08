Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CC119F424
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675599; cv=fail; b=cSI1CKrjqbkNVmTKNdTLpUe2mlhih8/M/sR6hmOmAYYNTEfDR3S6hSVh/8sX2xPiWj9Ey04Bp2tg9wJ0xPktXROrpKT0wjlfU6iaax68Olfww2FV0TnyUz8d/pn1hZ5zKDivS5YbmW/fGI7ZDq82a7jBzSmwWzbpam9KPA2nF4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675599; c=relaxed/simple;
	bh=JtnBP1XyW7AnMo69xdXv2Yj6zGp1ayw41MeAJh6Rmow=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=g7K/vRXTsl2IqBJkncZ741jFy13guhsH/W1OZKHj5QvyYUKkL8w42VL2Ba66EpMVHXkKI9c9t7N0iQGeRb5ZdqA0EAvL3dfvCkmd6+mtfSMFTFbTwawDNPXPUP+b++IGoXsYOlmOnOuZwuveUqN38ot+xytsCGiikw+qc410x2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TaC4bVjx; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TaC4bVjx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675599; x=1778211599;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JtnBP1XyW7AnMo69xdXv2Yj6zGp1ayw41MeAJh6Rmow=;
  b=TaC4bVjx5aAChgzk7tY/q8nxRoF1p4pvI43+lS9/DxhvKWpAoBXzq4ud
   wBsN9S0bk/uWx2gsRBDuZzbT2CpQHb9aJCKqAMpHU19fE2G2Wf1Q8LQBC
   eW8fz9bTfr+z8ECpxwpnPrya+JqXy7ZqflJF4q+DP0GBKlJJ96UaEJrPN
   +9m6iP25QoDwqX0JA4EemTAkoSDFjwHwyOqlg9t85IjwQE/XjkU/jCWfZ
   VR9wJ0YQsznWW/c41MoBO/qLKZ7W6ZCQJnbcVWDFa+sB48jyZxq+7x0o3
   lCLkkskDqWA/bXO8wOK11h/Hl4XaZekpRlJJJY7H+rvodsXM/seAixumC
   A==;
X-CSE-ConnectionGUID: xKlurDhET0CJz6qoyXUwvg==
X-CSE-MsgGUID: t47O4Wa8Tz2qnC+MSxn+aw==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="58638744"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="58638744"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:39:58 -0700
X-CSE-ConnectionGUID: fYvzJvT+RLqqyR/GNzspmg==
X-CSE-MsgGUID: YL3YWtD0T32GgD7jJnSGjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136117480"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:39:55 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:39:54 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:39:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:39:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h1no6yAQL3FYNB9i/1fHOi5dZ9rmGwSfI1FsGT98YrE/Nr/3k8uv5ALFPI/7pI6tvRSL7y9hqX80p3/o+ddFcdsMyu2zPOvRlHLsz1FNFXXM/RrlpEgsv1IBL6HUaf3MKfB9e/850pQria5ZqIo/Qd1oLMB3f1ZviH6JTus+HdQxMX94tqyc4R4lL2rvVz+96FMa2yV87DFLgYyOWJDnblC2rgtMUQixrL1wxVb5iLT4Ywo7TU8fwrmkeUB/N7aF3XNUY9gXwJ5pcgmK69IecQH6OsYrcF9nxCiMdHEOaMVT4tZl5hK1nJARYs993di6Jm99wzKdvjl5Cw2z9THKjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r6UROGms20npi3vhqqgewPdMtUY2RWjgWIToFAdf5oY=;
 b=VF/2cIzX0b9g71lD+5730kvjywjnfVMl05d8M6laYo7D1pR0E6jfU51JCiJ7GxK87EmylgmuL9jFNE3d39cO8639eRvTrcvPR5J2ihhC7vQaWoI2I1aYr652gKe5cXkGOX1gBMEUvc5LclcZ2HZtPCk2MdPUKZdaWIMrvezlu8L+tbRcnVzFKygZE3KlVW5/Y4Yjn+1KjIbvBsYBLJhLq+t8ItbHX+yxb6PHVxIzc5HQLdXKPPJbtU9lhkM7GBSs1UzINXiuN5iV8wv3X7+15CsjCgyRbuVl3niqNEdUoY3WTsDgsC1tS9bX1JmloinQzHDvbn1gT2Q607aq0zP48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:39:20 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:39:20 +0000
Message-ID: <21e16f8d-7796-4345-b5ab-8a92483594ce@intel.com>
Date: Wed, 7 May 2025 20:39:19 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/31] x86,fs/resctrl: Rename struct rdt_mon_domain and
 rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0068.namprd03.prod.outlook.com
 (2603:10b6:a03:331::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 59dfa295-7428-435b-bb35-08dd8de1eafc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TmtTL3ZWYjZ6N0xmM0lweWlsZ3VzNGtkOUNHWWtrTnlpcUQwc1RGcnVXTXow?=
 =?utf-8?B?ZGdONlpsanczREhBMlVYL0JZT20zbFhOYVRSM2NOeHU4N0Nnd0NnclRDS3Nk?=
 =?utf-8?B?R09ZbnFPbmluZUlSeGxLdXU2OUppdDUvUkxTTWxEMlpwQVJFNkNFMkpnUE9O?=
 =?utf-8?B?V0R5bGRWMTE2aFkxOVFrMGtqbU85c2I1R1gwOXEzL0lyTWgzcW5oQ09yT3JR?=
 =?utf-8?B?UFhxL1JvTjlNRUNlL21Ib2c1ZEdQU2xOWCtXZVhGK296blN4VHBmVDloL1JI?=
 =?utf-8?B?ZWhBUm9OS0hvOXdqclRiNEZVcWxhdkxHV25kUzc3eUpUbWtQRytjc2V6REY3?=
 =?utf-8?B?RHdNbWJxQ1NaaFZQdnliTXQvU2VIc0QxWXhteklESDFYcHhCNWJHNUZKTHV0?=
 =?utf-8?B?TU1hYWw5ZXV0dG82ZnNJaDdGNjZETWtGTVhHTk1xTEFYbWd0YXFIUzl2eWFO?=
 =?utf-8?B?TEJKVkxyT1B3TmxRcCtiK3BRc3JjdDhFNmRRU2l5Qys4SHpUMWlUU0Qya0Zr?=
 =?utf-8?B?SVJmNCtsTXFLWmcybmlhdU5WbnZYTysreXU5R2F4bEhzRmc2TTZDdVlVcHJp?=
 =?utf-8?B?ZVJoNkFHNE14RkY3MDl4VlBZa0d2NEZnZ29yUnYwMEt4YmxkeVNXL1FJaDhV?=
 =?utf-8?B?MFpzZVlaMyt6aGoxQnJiaWJJUTI1Mm1NQjUxYnZFVUV4bU5tV2VTcDFwaGQ1?=
 =?utf-8?B?UTJsZjhiOHJtaDJoaVR6dXYvN1hQWWR1ZzZFYjVyWUh6SjY5eUc2MytHbUc2?=
 =?utf-8?B?cE0xMDNTTjAwNGpEUHpIYlJUbGRESTc3L3MvTG41SHc3UkVtMTdNNlFMcHFt?=
 =?utf-8?B?Qno0b2M4dlNMN2FURWZmZnJyWmVscmNqK05oZ2ZlUXh6S0NPYVZuSFErOS9r?=
 =?utf-8?B?QnlvMkpZUG5IOGMzbHk3Sk1IT0FSSU5OeUp1QW9UQ0tNdWRQYW1WM1c1d3pF?=
 =?utf-8?B?WDRHNDNERUpHRWljT3FvYTArcDBNbUZlYTlqRVZaNXg3c25TM1l3UUpBejU2?=
 =?utf-8?B?bGtGdGlKQkl6Z1doUWtwb1F0UTNUa2FzTWQzZ3Z4SVFzMWduRFRSTjNUUUdX?=
 =?utf-8?B?d3hKWVRFS2lTcWRMdHhTZlR5ZUZsSFZYa3BseVd5bGxhN0w1QTY1RW13MkFG?=
 =?utf-8?B?TXdyR0d4VzZWUCtzbzFTazhnVTUwVTA3ZFIxaEJLTnYzdy85eEdPbDNXVmNq?=
 =?utf-8?B?ellsS1BpZXhuZ0RiVmJoeW80SjRsMmxhUXk1UkxseUhOWDdQbjJIWkwzZFBR?=
 =?utf-8?B?VVpPUDV1VDFkSzVyWFdZM2g5SzZsZmovdjIvMXA0aFdXNWZZZG9uQ3l2TjZy?=
 =?utf-8?B?V011S1Z3Z0duV2p0UTJoYWhRSEo0cXJjdW00RzY5SVY3d1VTRXprcmlEd1JI?=
 =?utf-8?B?N3ptaEd4NUQ5SW54T2Z6V2FOc1pidlBxOThlZ2YyTlBOVlViVDVTSWhEYk9V?=
 =?utf-8?B?YUtDTEg1TjNDQWNKaEVBVmFWcUJvdjk5Q3NSa0JLcWhCa1VyMEx3bFJDcHkz?=
 =?utf-8?B?LzlFemM5QVRVOHlsdEdyVitWVXJWd0xzek0vd1RVSnlObjR4VzRNYUVLQjlW?=
 =?utf-8?B?M1JYNUs4Y2ttczBVSEVELzFaVmxIaE02SWw0cnBVQXh5RCs1S293VGRvOHN6?=
 =?utf-8?B?K1VlRExFWFFJK3AvTStyMS82U3JrNDFGQlhjMDZYQi9LWnUzSkprZkt0azQy?=
 =?utf-8?B?Wm1ad0ZjQ2RFWG4vS3FuQXQwQWNUUXE0SCtVSkM1Uyt1RUhGSHJMTW5KczVy?=
 =?utf-8?B?SW9hSkRZUkFHSDdhZHhQMDVURVFKN2tKNWYzWU5rOGRwTmp1TmU1K01lV25K?=
 =?utf-8?B?QTZZNytTZzR3NU44cmVjaXVIeHAxaHI3UVFmVUU0MkZBc1hHTGpxdTdjVFhk?=
 =?utf-8?B?NWN6dXZBUVhHV2xHbGdPb1FzaCthT0F5M2dtN1RaSEg4K0JDaHRyOFU5K3hh?=
 =?utf-8?B?UzZhUlROY0wzR1Vhbkw0L0ordkR6OWJFU01DMXJnaEd5ZHljNkhkYi9KdUJ6?=
 =?utf-8?B?aC9PazF1dS9nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T1RxZ1ArWm40NnNoMHRKMW1FSy9vbXdISFBSY3BEK2YwQ3pKUUloY3FlTmRU?=
 =?utf-8?B?WXJxdFhKWUZGSW1SdWpjL2UybUdxZDAzNFN5aS9jNmZtdnphaGd5TEp2RlpZ?=
 =?utf-8?B?QTErNzFNeGJ0T1IyRnFQbFNXN1VqSWQ4T2pyb1hoWEJxcHd5aTl0ZUM5WW4w?=
 =?utf-8?B?aGpGbW1tcUkyVVFRZ3JJQUYwWkUxRGh0Tk4rTmZNQm9wNnBnbXRuT2k0amhH?=
 =?utf-8?B?a0FBUWhPcHZKa1RwTWZmRzRmL2hpQXFKWncrWkRaVkVxdWdvTHJKSStNVDds?=
 =?utf-8?B?MTdQZ0tQcEVncnp2alptMVlxbUtrdmZibzNMTWtVYlBVK3ZNcStCZzRWV1I2?=
 =?utf-8?B?L1pVNkdyeS9iSFhPbXMyWG9lYXlablU5VFY3MUFqS1FydGN2MTM0VmtpUE00?=
 =?utf-8?B?U2VSbVJIMDEwWllWQWdEb3E2MytOUXl0emgvemVEZTlYS3FMUXdOSW5USld2?=
 =?utf-8?B?RHZvQnplOFgwSVVrSDJQVU9yWVNoTEN5YzBKc3VRVVVYOEFPQXY3YVJBZktr?=
 =?utf-8?B?Z2FYTjZSN1BQUzl6Tll5K3Z5QWFCTStHL3dmYlR0a2ZhY2NZSXRCVldiYVJ0?=
 =?utf-8?B?TGtFZWpTc09xZlZ3dEJheWNXSGJtTk1wZGl4NEJpTjZpSE02VDdzYXdzRXFx?=
 =?utf-8?B?SHQ2K0c5dDcvKytJQ0xsUEFKMFNwRHNTL1JMQjZPYXpDcGZiTTZqK0c3Mmkv?=
 =?utf-8?B?aW0xYnAwY0s5RVNBRE9jRm5hc2NVakp4SXhnYkpsYkcwRVRkeEdlU0J0eHRL?=
 =?utf-8?B?NFJIeFRvWGM2V28xczVwa0ZTUzRFNjBQS1E0Rm92enBvSWw2UVQrSXBsYXhP?=
 =?utf-8?B?YjJybUhnNUJIOHgxSE1LM1BiekdDNk5RYUxTRDljTWhEZVdMbWt4bno4Ulp3?=
 =?utf-8?B?cHlQNnEyTDVaZ0NQVmY1azIzTEJTZGczMFVJMmZzMXR4M0NLWFlyTURFUHV0?=
 =?utf-8?B?Q1JRaHNyaWVjSWFSUldNbTY0TWZvdFBnLytVTkJxTitGZGFpdmN4TTBXR2Ex?=
 =?utf-8?B?Rmdjc0JLT2tjWGN4dFdiMkdtNE5rSkUyck9pM2pjenhyS2xvWWNETkFnOUxz?=
 =?utf-8?B?R0x3NzFCV05aV1M1RVJLaFZWWGNYeUZVL2k3UU5EOUF6dWk5R0JjWTlXMGo4?=
 =?utf-8?B?Zm82aUNML2lOTm9SRFFrRE5OYjl4b0Q1UGo3aENGV3J0UTBZa2RuNVFUb29s?=
 =?utf-8?B?cWkrYkxGeC9rNHM0YnBoYkZ3WXd1elhGdFZaTE9lZXZpZEJoQkZLTGRjZm42?=
 =?utf-8?B?Y1pXb0k1RE9ObERCUE11SWIzRnVhNFpIc3lFRndWY01FTThDMTErTCtjVmky?=
 =?utf-8?B?WnNFRzc5WWluWk5GQUcvaE43TFZKckk2SThvcVhUdjJkcEVQT0VnUUJ4QThy?=
 =?utf-8?B?TGNNR0graGw0cU9UcW5OeFZYOGJRQW96Tnc5dGkrSlZ6dDF0KzY5ZkViRnRi?=
 =?utf-8?B?SDRhczc1dDFXNHllbVVCMGN6cjFuMlNhMzNFWUl0eWVLRnI0ekU5RTN1ZFFn?=
 =?utf-8?B?WGpuMnBlUnZxanROR1pPT3A5Q2N6QU0rZzVHdEI1VjRZYURIZFhkT2ZwZXlw?=
 =?utf-8?B?d2dyTlRjdTN0NlZOclRjV1ZFVS9WQ0l3Mk0vcGNtTmZtTkgySFQwSlJ5bGp1?=
 =?utf-8?B?Rk5HaS9CT2FWTVRHbU8wUjU4R3V1VVFleStHNnRwRXFWcjFYR0NuRFliMWp4?=
 =?utf-8?B?SkhWMWtZTE9HRzIvbWpDbGZZTWI1bWRJeFFweXZzS2JsOWdCL1VSMEZ4QWZy?=
 =?utf-8?B?dXJIUEZFamxQN0FXOTU1MWRmVTFMN1lhNXB6ZnZ1Um9pQWp5b3NERlhhSExt?=
 =?utf-8?B?aHVZQ0F3R0NaRFZNaytmYWlyOWxUK2tOamJvL3lWTTY0MCtrK0pWK2hGMThO?=
 =?utf-8?B?NVo3Rit6TXA5NUNyNEtRU29Uanp6TTVIOUx3WjU0RXFHbXRSNGlUSE1XVjQw?=
 =?utf-8?B?SWhWYldNV0VwVXF2TU96ek1WaEo4Z3VHQmE3R3hqdVJVSVlTdVIyMVp6Q0RG?=
 =?utf-8?B?QWxYS1c0aVVJemlyRmpUckZmSGovUGErdFFZaFVlczRkWjBOc3ZjcjkrOEFD?=
 =?utf-8?B?WmV4YXVJajA2aXgrRzZVWlJINzBNWnp4NFBCWDZnYSt2SHZCWFhVaWxNTWdl?=
 =?utf-8?B?Q04yeEEzZUpoSEo0NGMvMmlzZlNMVEUzdTBjZStYUElGRkRHeCtFcGo4VlBF?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 59dfa295-7428-435b-bb35-08dd8de1eafc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:39:20.7233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VusiKoUr1XlWnKiEnTQRRc6uqTieS+zMUnpxexjJ4SIYAC5rEi7SpDd+69TVJ6kcV7/OZZUKn/JzrjwTSd4Fj5HO4EQfMwkFDY3kJPHUPAI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> These structures have generic names, but are only used for L3 monitor
> events.
> 
> Rename:

Please add information about why the rename is needed.

> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 12 ++++----
>  arch/x86/kernel/cpu/resctrl/internal.h | 12 ++++----
>  fs/resctrl/internal.h                  | 12 ++++----
>  arch/x86/kernel/cpu/resctrl/core.c     | 14 ++++-----
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 18 ++++++------
>  fs/resctrl/ctrlmondata.c               |  6 ++--
>  fs/resctrl/monitor.c                   | 28 +++++++++---------
>  fs/resctrl/rdtgroup.c                  | 40 +++++++++++++-------------
>  8 files changed, 71 insertions(+), 71 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index bb55c449adc4..cd7881313d4e 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -166,7 +166,7 @@ struct rdt_ctrl_domain {
>  };
>  
>  /**
> - * struct rdt_mon_domain - group of CPUs sharing a resctrl monitor resource
> + * struct rdt_l3_mon_domain - group of CPUs sharing a resctrl monitor resource
>   * @hdr:		common header for different domain types
>   * @ci:			cache info for this domain
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> @@ -176,7 +176,7 @@ struct rdt_ctrl_domain {
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
>   * @cqm_work_cpu:	worker CPU for CQM h/w counters
>   */
> -struct rdt_mon_domain {
> +struct rdt_l3_mon_domain {
>  	struct rdt_domain_hdr		hdr;
>  	struct cacheinfo		*ci;
>  	unsigned long			*rmid_busy_llc;
> @@ -335,7 +335,7 @@ struct resctrl_cpu_defaults {
>  
>  struct resctrl_mon_config_info {
>  	struct rdt_resource	*r;
> -	struct rdt_mon_domain	*d;
> +	struct rdt_l3_mon_domain	*d;
>  	u32			evtid;
>  	u32			mon_config;

Please adjust alignment of the other members to match.

>  };
> @@ -475,7 +475,7 @@ void resctrl_offline_cpu(unsigned int cpu);
>   * Return:
>   * 0 on success, or -EIO, -EINVAL etc on error.
>   */
> -int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
> +int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>  			   u32 closid, u32 rmid, enum resctrl_event_id eventid,
>  			   u64 *val, void *arch_mon_ctx);
>  
> @@ -522,7 +522,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>   *
>   * This can be called from any CPU.
>   */
> -void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
> +void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_l3_mon_domain *d,
>  			     u32 closid, u32 rmid,
>  			     enum resctrl_event_id eventid);
>  
> @@ -535,7 +535,7 @@ void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,
>   *
>   * This can be called from any CPU.
>   */
> -void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void resctrl_arch_reset_rmid_all(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
>  
>  /**
>   * resctrl_arch_reset_all_ctrls() - Reset the control for each CLOSID to its
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index b563406b4996..83b20e6b25d7 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -51,15 +51,15 @@ struct rdt_hw_ctrl_domain {
>  };
>  
>  /**
> - * struct rdt_hw_mon_domain - Arch private attributes of a set of CPUs that share
> + * struct rdt_hw_l3_mon_domain - Arch private attributes of a set of CPUs that share
>   *			      a resource for a monitor function
>   * @d_resctrl:	Properties exposed to the resctrl file system
>   * @arch_mbm_states:	arch private state for each MBM event
>   *
>   * Members of this structure are accessed via helpers that provide abstraction.
>   */
> -struct rdt_hw_mon_domain {
> -	struct rdt_mon_domain		d_resctrl;
> +struct rdt_hw_l3_mon_domain {
> +	struct rdt_l3_mon_domain		d_resctrl;
>  	struct arch_mbm_state		*arch_mbm_states[QOS_NUM_MBM_EVENTS];

Please adjust alignment.

>  };
>  
> @@ -68,9 +68,9 @@ static inline struct rdt_hw_ctrl_domain *resctrl_to_arch_ctrl_dom(struct rdt_ctr
>  	return container_of(r, struct rdt_hw_ctrl_domain, d_resctrl);
>  }
>  
> -static inline struct rdt_hw_mon_domain *resctrl_to_arch_mon_dom(struct rdt_mon_domain *r)
> +static inline struct rdt_hw_l3_mon_domain *resctrl_to_arch_mon_dom(struct rdt_l3_mon_domain *r)
>  {
> -	return container_of(r, struct rdt_hw_mon_domain, d_resctrl);
> +	return container_of(r, struct rdt_hw_l3_mon_domain, d_resctrl);
>  }
>  
>  /**
> @@ -122,7 +122,7 @@ static inline struct rdt_hw_resource *resctrl_to_arch_res(struct rdt_resource *r
>  
>  extern struct rdt_hw_resource rdt_resources_all[];
>  
> -void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_mon_domain *d);
> +void arch_l3_mon_domain_online(struct rdt_resource *r, struct rdt_l3_mon_domain *d);
>  
>  /* CPUID.(EAX=10H, ECX=ResID=1).EAX */
>  union cpuid_0x10_1_eax {
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index b69170760316..759768e2a2a8 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -129,7 +129,7 @@ struct mon_data {
>  struct rmid_read {
>  	struct rdtgroup		*rgrp;
>  	struct rdt_resource	*r;
> -	struct rdt_mon_domain	*d;
> +	struct rdt_l3_mon_domain	*d;
>  	enum resctrl_event_id	evtid;
>  	bool			first;
>  	struct cacheinfo	*ci;

Alignment. Please check all changed structures.

...

> @@ -618,9 +618,9 @@ static void domain_remove_cpu_ctrl(int cpu, struct rdt_resource *r)
>  static void domain_remove_cpu_mon(int cpu, struct rdt_resource *r)
>  {
>  	int id = get_domain_id_from_scope(cpu, r->mon_scope);
> -	struct rdt_hw_mon_domain *hw_dom;
> +	struct rdt_hw_l3_mon_domain *hw_dom;
>  	struct rdt_domain_hdr *hdr;
> -	struct rdt_mon_domain *d;
> +	struct rdt_l3_mon_domain *d;
>  

Please fix reverse fir ordering. Looking further there are multiple instances, please check
entire patch.

Reinette

