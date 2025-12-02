Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E272737E0
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692406; cv=fail; b=PTNv2iZnP8UfC71sLQP1cZxzDm6odXcbKLYimN9Tj0KTt7wvyXFXQiBRTfJp/ELrJ9iKN6zzqZwVxhuz7DET9ohoYv/Xx9wXX84Bmt5PXVFp8sHyCHSW2C7S+56Bc2F4ErukipwyOd4Z9n2JpIOdJu8m37wqY3cv7TgVjnTcq1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692406; c=relaxed/simple;
	bh=z0BJ3nHG6qASuOKXNvh5Oaf2p7ICfPWOsKqyxzBb+XU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jCXImXK8LCdRrD9vLn14L5eWGp7OCAFTn4KbmEKSY+OdL62FQzrYFpCeeP5RkmgL2AGeQEGMfSppBpnW8OFbhcBodVpw6VQWGBGO5Y1//SlIC7A1qVjdUXaNkb2viPTEp4XTd/vjucjdciNADGZhBxDxYc9TSycUFVoKljU5YaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oJ016Nps; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oJ016Nps"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764692404; x=1796228404;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z0BJ3nHG6qASuOKXNvh5Oaf2p7ICfPWOsKqyxzBb+XU=;
  b=oJ016Nps0+CU0Vim3NrHgaiL5QumlkACSIxDMNVsoARoUuF1/gPs6t4B
   FplQ71pfE3KhLzeIyPUaAxCtyrQXAUFdBR8sHHzpMPLpNfARujoGloQ8t
   kviIBKEov7GOrNKtd3x/2aetmjIuxlDj39LQItkjC95MBpUmMQNxa1N3E
   ElQBFAuJ0Kt0XiUihxGGLkCiiPgttv8ISLsiHCw/g2Ew4gph4XNBixlqy
   cZWgSMXtN9VXizcQWi/sT3gCLUo3aaat154z5jeBLCZraevr6hV18yFyd
   jHLNlD15JcF09NnL68JSlOO5erfTDbOzejjsnWhkIEekQeHgA5ARTX3eA
   A==;
X-CSE-ConnectionGUID: eWwFW5d6T2u6nO054YA5Gw==
X-CSE-MsgGUID: z1QkmkEwROK74/XP+3zxLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66706570"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66706570"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:20:03 -0800
X-CSE-ConnectionGUID: mTZn5X+yTJmGGbKnHzDw6w==
X-CSE-MsgGUID: PgnVDbZ6RJqOONxzIZjRcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="199541237"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:20:03 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:20:01 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:20:01 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.66) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:20:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cqNXN5Dmf14H5zV0tmMpwl0m5bEyP4DVfCGmZwVyKvI+T5IL9BbrmYSX6aJAKD4rD8nC9FkhSdpA/0PZjtlSUKo/Po1+k0G5fg1NdhtYSFV2AgA/uCedWQewFzLLgzUyj7CgmeX5n7FL0V2m/gMkL4SspuO5tI3i30c6iU3wjqGTUNTKZsqtpTen77p8ScOwiUmTGHlx3yow3zvPOYEtw+OkTT4zSUrFGQSzoc2IHkCiO0V7rXyhCevJqF5seyrHJwzZq9uK/m4qItxllNy0gBYlVnKaqQIfS52Hyg9GXfDa8kwaxvTPvKgZ8c//vRmhITyUXYfwD8lJM0p7tESaDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JpjLj+FWqGcUubp91BydgJecDKXd3e+cLA8RF8oXQH8=;
 b=v5iSgLtdL/DZYF++T6mK0g4YwDpk+rzWSyxbVAQLpYC3dCbiQhVSmNkw57sPkEXc7RMxN+EgOu0mjx4CtNJa4f9BITCTQ9l154NJjOv+DzZ4uJCOXAVrhGgUd/jfYznic6hjttDFrm9fzlZPc3VzVY//6vTvAUu1pdlgHSbDkpa+17bh6JSnPAhIEA5YYIAR6tLnIgY8PP/I1/UrQRs/ghXApqw7mp1RVDBDLl7jsRqeA0ro8xPDO1890hndX04Na4XEftbS+rGkO+IfyPZEIHgfJLYnul0X6FCnkO8zcQjyW3rXhLI2tTmoHOndJeFN7ngPP5xL3HmaUUewM7LZQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6827.namprd11.prod.outlook.com (2603:10b6:806:2a2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.14; Tue, 2 Dec
 2025 16:19:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:19:59 +0000
Message-ID: <4b0206a4-3438-4b78-9530-412c18bd830c@intel.com>
Date: Tue, 2 Dec 2025 08:19:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 17/32] x86,fs/resctrl: Fill in details of events for
 guid 0x26696143 and 0x26557651
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-18-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0345.namprd03.prod.outlook.com
 (2603:10b6:303:dc::20) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6827:EE_
X-MS-Office365-Filtering-Correlation-Id: bb054bb1-b346-499c-c53c-08de31bea37e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Snh3Q1pGWit4enFiZzJCVkFFQVNzbmV4WUIzYzF6K2UrdXl5ZWg0Tk5rSzZK?=
 =?utf-8?B?OW5sTGVNUmxRNm5JU3AwM2lsTnVBK3BvQTdKZXJ5bUJueWtsNVh5UWtINzcx?=
 =?utf-8?B?RktpU2RraUZ5dURrMUJwSXFkWXVyT1U3TnZMUDlLT05obXZ3RjBzMFh4cWtV?=
 =?utf-8?B?ZmJyK3VUaUtoUmtyWWxRa0lvblJ4dGJSU05VQVRwcUNxb01zeEQrU0NNcDFr?=
 =?utf-8?B?bXhrSXVqWFFRVE9JcW5yQjFNTVNieWthTVJreXBiM2lsWHYwQ1N3SThaTjdy?=
 =?utf-8?B?cnpxVDJqVU5WeDFlNWVrYW8zT2hXYUt0cHNIejdWd3lNT0tUclE3cklhSVNt?=
 =?utf-8?B?VHdqT1lRWlVKdWZZcnRKMWFMQ2lmUSsxdWt1ZmJSMUZHMWUyOGtEVkpSVUlC?=
 =?utf-8?B?em5SWTFHdVFyZDVFZEQzaTEva0s5WW53eXRDMkRYMTRaZ2NEVVFMSmJ2MW53?=
 =?utf-8?B?dFpSTFl1N3pHcmxDaEw1RENSa3lnVVY3QW1FZWlrY3RJUEloVmNKdUJGd1Bz?=
 =?utf-8?B?VWRBc2t4a1JLVndJem5kL3V5Mmt4dElrZ2NNNHhaY21WSE8wN3dlOWhyZFhq?=
 =?utf-8?B?L3NBVm5YUGtNWmlDbE9UTWx3KzJ2dDJhQVFwQm8ramd6ZFNvZFcrU2J3L2FL?=
 =?utf-8?B?K2FuRVluV1Z6VHYxcWozUWZEVzJTYWd6ZGR2NVczMlYrcFVoN2V6OHkrWWhJ?=
 =?utf-8?B?WUx5dGRoNHZuTHZPWUpvdVdTa3VMaXh5YTRjSy9JSXVsRm90NmRyTk1McWJi?=
 =?utf-8?B?dnlpWmIwcTh0ZjdaUEF6eDVTVG5EYWtQRlpFcElEcW9VN1VGMnhXMWtUc04r?=
 =?utf-8?B?dTRxRzZydUVPVjRsYzhIQmw0TFJ0cGRlTGNQa0EvUGt0Z1YxL1gzNi9LekdM?=
 =?utf-8?B?di85UmFZYVhpMkpZTjZoYVBwaTFXQlJtM0hnblMvc3pXdVg2RnZlWWN6aklq?=
 =?utf-8?B?TVJjNkhxQUFaTDUraFNrTGNqeHBjRWZxUHlhQ0duaGwzbDZ3RnRhMjlDeTRm?=
 =?utf-8?B?bVFQM1ZnbWRNTW5rcnRQODZOaWF3eWc2QnFnY3NDTGxOblRqSWd4UWd5S1Vi?=
 =?utf-8?B?bnhwMi9RNFFsandnNVhwem5IWXA0VXl1ZTJBbU5uOTgzQlJabFlLYUNIcXpr?=
 =?utf-8?B?MmR3cFR3Y3BHTVVxNFVxS3FOeW01SERlQjVvM1ZlNm1kdWJSaVFIUHRIamFy?=
 =?utf-8?B?cU1KSWI0V2RnMjI3ejhrT1BwNFc4OGxRbldyb08vcWRiQ2NMOVBQcW1IMVVz?=
 =?utf-8?B?dm5aVXNUNWdtM1VYNWdDZnlQU3NrZ3Y2MUY1OER0RXIwR0pjaGFVOFdTeVRQ?=
 =?utf-8?B?dCtaUTlqckZqZlNVT2I4clkvWFhqK1J2K3RkTjFKVDJVNDN0THh5VUgwNTZp?=
 =?utf-8?B?Z1FkZUk4U0ZGWU9kSVZXZzE1RUlTWTVNQ3RWT1M1dHlITGowQlVmbmN3RDVy?=
 =?utf-8?B?b3diV2lHQkFEWjVBSWIwbGFlaGZmYlpCQ2xNdUdkV2JkRCs2UHpTMldtTWo2?=
 =?utf-8?B?UHZmMEhUL0k4djlTL0h3MlpTMzllSWRSZzIrTFFRMDJWRm1iWGdKK1JXYnVZ?=
 =?utf-8?B?ZENCMjVlbTFDZWZkbWJVbWhBZzlGT3lrRjB5VzF5ZHVmNmZ5QjZJYTAwLzQ1?=
 =?utf-8?B?UHVyc3N2WE5QbGtzaGRQdjNXaWs1dUJFbHFuOFJISXVpOVFxdjJxYlBYUkNL?=
 =?utf-8?B?cGdmaW5xenBUVU9KZ3ZmTS9JNjJTd3FvVTVSWXJnZjY3RnRvdStNek9sTGk4?=
 =?utf-8?B?TU9KdmNKMU9kaDdDQnRvN0ZGQ2pWOUVWYytXUER3MUJYRWhDUStKcGI3bkM3?=
 =?utf-8?B?N1R4Y3lDVndtb2U3QlAyN3VhYVJjTFNUOG04LzZQK3JUcjlSRUFFV1VpUjJl?=
 =?utf-8?B?R2c4NVVUTFE5aWIwcldQbjAxSGdWdS85V1dNRWRSZDFFNHI1dFpzSFZwUDVt?=
 =?utf-8?B?ekV6eXVTYmZPN05ZSTFmRFVBaFM0dGtuTi8zZjVNQjJaQVd2TXg1RkFIczhO?=
 =?utf-8?B?S1lrNnRwbmJRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVk4eFpmdXpiWjZBcFZoM2tBdkpocVlFRnBHdEV5ZGZRWUR0cFBLZjlTRGRI?=
 =?utf-8?B?TnM3UE12Yjl1YTRFN2NQNkhHT3RvU3RGQzVQZE9KZGhqTjErMlROaC9iVG1t?=
 =?utf-8?B?QzFCOTE2TTYxbDBTYUVvZWJsM1RaYXE4UmlJbDJqNE56YW5RSjh6MmZxWFFE?=
 =?utf-8?B?cDRNcFNjMEttMHpwUlIvelRWdzZuU1o5Uy8vRE9pa00yT2xVNjYvTnh5OCty?=
 =?utf-8?B?bElGanZXRUVFaGNEZ1NheDE0SHdQcDlubC85Zzh4NVBnaGo0MmhTVWd6Y2s4?=
 =?utf-8?B?d3pkbUxROEgyM2RsTm9YckFXZ2JCK0lTeWg1elNlV0lvOHBHZk50cmZEUk1y?=
 =?utf-8?B?ZWJ1UVh0bkxFQUhQT2VOdWpDbUlmZFRnNmRLQUdWaU56RFc3MHZMYmYyUlAr?=
 =?utf-8?B?YURPampLQzBtY1RvZ01ORDcxTU9TWXM2ZnBDZVgzeVJ4b3Vvb3o5VGpJRTYw?=
 =?utf-8?B?TFVyMzRzVUdlT0xYc3hCTTJ0Y29YdkZPNjROR0dmK1NqTjIwOU56b2hFYjc4?=
 =?utf-8?B?SElLcDdITWlFbzVCYStSVVRRQytUNDZlWWJkak82Q2MvMDNZRUdKYkdtd3J0?=
 =?utf-8?B?UnBhTnAzMDN5OVFyU2hhd1ZHeXNtbWlVNi9kamcxaC9HSEZxZGl4WDY5N2pQ?=
 =?utf-8?B?eE9WSXFRZ3VsTEVmVjdJZWRnbVNDc3h1Vmh6c3REbDVWU0s0dm4zZ04vd2dP?=
 =?utf-8?B?bjhiUHdIb0ZRa0I0L2xnMDQ4c3VZMlEwbWQ1MW03T2ZRRDc4WHR1SlNvNDM5?=
 =?utf-8?B?ZlN3bU5TODg2T2srdDlmZHhzT09UU0FzWnRNUDNEWGhkNG9tYkZQUHlYVXg5?=
 =?utf-8?B?anBFSTVnVXpJMURNdHZTUDZIL1VFTGtIMnNzb2YrQXhEMmlYbG5nK0FlbHRr?=
 =?utf-8?B?ZHhMRWxic09iS2JxSW1teWxyaXZIUmVNekxKSkRqQXhIQll4K3gybC9SSDhs?=
 =?utf-8?B?UjJaeGVOOGhRcUlSL3VOcGFKSVZtaW01eEdTaDF6Z1lXVlZYNm5FUC9HZXJM?=
 =?utf-8?B?NEM5TGExcXRhZlA0UWdIcmRmUkJVUjR6SXdmRW51aFBLZ0RLamlkK3JnSkJy?=
 =?utf-8?B?L2lKRXVhbU42QlFiRWwwdHpSR2M1VlJSRXZVWHJMMldQZWFsdVpBUkNYTjYy?=
 =?utf-8?B?dEFJVjJ5YXI3ZnZtK0NyYTEvMGI2SnN0dkZnNEpoTFlPalNCOTBtcUlzL2Rs?=
 =?utf-8?B?WEdDSzNyWTFSbHJ4c09TME1TZXkwYkViRXh3OVpQWWd1Z3NJRkhabVJNR0RU?=
 =?utf-8?B?MU45c2QzNEV4YklQZzlhcWVTREloZ1VuUUROVnc0V0c1SDB0VytxZnRzMU9S?=
 =?utf-8?B?QXl0RUhSZnJLNnkxektpWXZ5N09EMUE0N3ZZUTY0em5FcHgzWk1TMWF0eFJC?=
 =?utf-8?B?TmQ1MURnMmtIUStZTDV5ZEJmK2ZmeWU2STFEaVhhQlJJNjVLM1diVkVrQks1?=
 =?utf-8?B?dDAzT0E2WFI0T0gvU2ZXWC90TTFBVkVET3ZSYTBGSjU4SHRyUmFGMFFCNWJp?=
 =?utf-8?B?aWVkRW1DWWExc2xxZ3FOVzVtbVFDWXpPWjBTWnFkajZ4MnU0eDdDK2o5Uy8r?=
 =?utf-8?B?S0RiajlHVmJYQ2pscDBEdXRRMWM5VEp1SWt0c3NvMnMvK2pCSHdCbEx6SVlI?=
 =?utf-8?B?N01KT3NWYXlyQjgyUTZmM3hnM0dBcDFtRk95bFpQTTdZakcxN3Z6Z1BhU3VC?=
 =?utf-8?B?Z2VlWCtFeVlYZGgzYThrQU5yR2ZoRTJuTERDQkk5Nmx4NmdSRm56d3dCMWVk?=
 =?utf-8?B?Z1h6L2wxVzFIRGZnYWhEWGJHNUxnQklZaU1aeWpBYWM0RC9UcmsybThNbVBj?=
 =?utf-8?B?dWdZTE4xWWZxTzZkNExGYjdKdnBtTkxQTFhlTndOemJ5S3dabHFCUEIzOEdZ?=
 =?utf-8?B?eHQwVUZpSjJlRFhzcHY2Q0ZpNVNQMXd6Vlk0V3BBbUsrRm0zdnM0U0htcTEv?=
 =?utf-8?B?ZndIZTJCa203b0RTTVhZUythd1lzZEtKUklqWGJsWHEvbFB1cTJWY0ZiSEJS?=
 =?utf-8?B?NEtoNUJ0ZDFmRG1RamY3QnZiNG5xRWZYckl3NUh6N2liOC9kcGh3TUhIQ2J2?=
 =?utf-8?B?akxmMVltOXp6NklBOSt3MVhGNkc2UEphdVU1Y2ozbTBVRWt4NzhXbXpFcHRh?=
 =?utf-8?B?ZlVmdGlnVGhoUHI0VHp1STNzOEtxbHRPT0wrVHMwTmZDOGNaQm9MMklpZGk2?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bb054bb1-b346-499c-c53c-08de31bea37e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:19:59.1798
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XAxEUbJcMBbhv3szSyQlznwfgj/iPnQrpi+rLEMueV7g/qWELPXM/sBifgbqVkoOgk3b6GK4mQoVvRO5oX++TUoGrLCLioGIjuMmE7H1U0E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6827
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> The telemetry event aggregators of the Intel Clearwater Forest CPU support
> two RMID-based feature types: "energy" with guid 0x26696143 [1], and "perf"
> with guid 0x26557651 [2].
> 
> The event counter offsets in an aggregator's MMIO space are arranged in
> groups for each RMID.
> 
> E.g the "energy" counters for guid 0x26696143 are arranged like this:
> 
>         MMIO offset:0x0000 Counter for RMID 0 PMT_EVENT_ENERGY
>         MMIO offset:0x0008 Counter for RMID 0 PMT_EVENT_ACTIVITY
>         MMIO offset:0x0010 Counter for RMID 1 PMT_EVENT_ENERGY
>         MMIO offset:0x0018 Counter for RMID 1 PMT_EVENT_ACTIVITY
>         ...
>         MMIO offset:0x23F0 Counter for RMID 575 PMT_EVENT_ENERGY
>         MMIO offset:0x23F8 Counter for RMID 575 PMT_EVENT_ACTIVITY
> 
> After all counters there are three status registers that provide
> indications of how many times an aggregator was unable to process
> event counts, the time stamp for the most recent loss of data, and
> the time stamp of the most recent successful update.

(line length)

> 
> 	MMIO offset:0x2400 AGG_DATA_LOSS_COUNT
> 	MMIO offset:0x2408 AGG_DATA_LOSS_TIMESTAMP
> 	MMIO offset:0x2410 LAST_UPDATE_TIMESTAMP
> 
> Define event_group structures for both of these events and define the events

" these events " -> "these aggregator types"?

> tracked by the aggregators in the file system code.
> 
> PMT_EVENT_ENERGY and PMT_EVENT_ACTIVITY are produced in fixed point
> format. File system code must output as floating point values.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml # [1]
> Link: https://github.com/intel/Intel-PMT/blob/main/xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml # [2]
> ---
>  include/linux/resctrl_types.h           | 11 ++++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 67 +++++++++++++++++++++++++
>  fs/resctrl/monitor.c                    | 35 +++++++------
>  3 files changed, 98 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index acfe07860b34..a5f56faa18d2 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -50,6 +50,17 @@ enum resctrl_event_id {
>  	QOS_L3_MBM_TOTAL_EVENT_ID	= 0x02,
>  	QOS_L3_MBM_LOCAL_EVENT_ID	= 0x03,
>  
> +	/* Intel Telemetry Events */
> +	PMT_EVENT_ENERGY,
> +	PMT_EVENT_ACTIVITY,
> +	PMT_EVENT_STALLS_LLC_HIT,
> +	PMT_EVENT_C1_RES,
> +	PMT_EVENT_UNHALTED_CORE_CYCLES,
> +	PMT_EVENT_STALLS_LLC_MISS,
> +	PMT_EVENT_AUTO_C6_RES,
> +	PMT_EVENT_UNHALTED_REF_CYCLES,
> +	PMT_EVENT_UOPS_RETIRED,
> +
>  	/* Must be the last */
>  	QOS_NUM_EVENTS,
>  };
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 5d34c7349b02..bb080bdde190 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/array_size.h>
>  #include <linux/cleanup.h>
> +#include <linux/compiler_types.h>
>  #include <linux/cpu.h>
>  #include <linux/err.h>
>  #include <linux/init.h>
> @@ -20,11 +21,27 @@
>  #include <linux/intel_vsec.h>
>  #include <linux/overflow.h>
>  #include <linux/resctrl.h>
> +#include <linux/resctrl_types.h>
>  #include <linux/stddef.h>
>  #include <linux/types.h>
>  
>  #include "internal.h"
>  
> +/**
> + * struct pmt_event - Telemetry event.
> + * @id:		Resctrl event id.
> + * @idx:	Counter index within each per-RMID block of counters.
> + * @bin_bits:	Zero for integer valued events, else number bits in fraction
> + *		part of fixed-point.
> + */
> +struct pmt_event {
> +	enum resctrl_event_id	id;
> +	unsigned int		idx;
> +	unsigned int		bin_bits;
> +};
> +
> +#define EVT(_id, _idx, _bits) { .id = _id, .idx = _idx, .bin_bits = _bits }
> +
>  /**
>   * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
>   * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
> @@ -35,14 +52,64 @@
>   *			data for all telemetry regions type @feature.
>   *			Valid if the system supports the event group.
>   *			NULL otherwise.
> + * @guid:		Unique number per XML description file.
> + * @mmio_size:		Number of bytes of MMIO registers for this group.
> + * @num_events:		Number of events in this group.
> + * @evts:		Array of event descriptors.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
>  	enum pmt_feature_id		feature;
>  	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +	size_t				mmio_size;
> +	unsigned int			num_events;
> +	struct pmt_event		evts[] __counted_by(num_events);
> +};
> +
> +#define XML_MMIO_SIZE(num_rmids, num_events, num_extra_status) \
> +		      (((num_rmids) * (num_events) + (num_extra_status)) * sizeof(u64))
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml

Can these links be fixed also? Appending the "File" to "Link" results in invalid url.

> + */
> +static struct event_group energy_0x26696143 = {
> +	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
> +	.guid		= 0x26696143,
> +	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
> +	.num_events	= 2,
> +	.evts		= {
> +		EVT(PMT_EVENT_ENERGY, 0, 18),
> +		EVT(PMT_EVENT_ACTIVITY, 1, 18),
> +	}
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml

same here.

> + */
> +static struct event_group perf_0x26557651 = {
> +	.feature	= FEATURE_PER_RMID_PERF_TELEM,
> +	.guid		= 0x26557651,
> +	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
> +	.num_events	= 7,
> +	.evts		= {
> +		EVT(PMT_EVENT_STALLS_LLC_HIT, 0, 0),
> +		EVT(PMT_EVENT_C1_RES, 1, 0),
> +		EVT(PMT_EVENT_UNHALTED_CORE_CYCLES, 2, 0),
> +		EVT(PMT_EVENT_STALLS_LLC_MISS, 3, 0),
> +		EVT(PMT_EVENT_AUTO_C6_RES, 4, 0),
> +		EVT(PMT_EVENT_UNHALTED_REF_CYCLES, 5, 0),
> +		EVT(PMT_EVENT_UOPS_RETIRED, 6, 0),
> +	}
>  };
>  
>  static struct event_group *known_event_groups[] = {
> +	&energy_0x26696143,
> +	&perf_0x26557651,
>  };
>  
>  #define for_each_event_group(_peg)						\

Reinette

