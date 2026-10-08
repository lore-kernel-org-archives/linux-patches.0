Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FBD425879
	for <patches@lists.linux.dev>; Thu,  8 Oct 2026 22:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791499714; cv=fail; b=IQB+q+AhLT1EbcwKWIsJjfHq7F/x7kWSd54Y9RZNVGHwVDcJgpENJAQ+IWU0i9/viGvt7dnx9nciw+vDasxEwmg3ms7x4fQKtdBhTMz4/3TaoeYwE4r7PzEruYVmXes1aSu3mhgqpGQpR5TYE6yc85eirOiQNF9xWDteKCfhyQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791499714; c=relaxed/simple;
	bh=J86uSP1YOhcBvRMUM63f/btfwC7r0bkaKMfcs9OZKA0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h5TRwlZ68jqnWfNbGj6+HzcJLfYE6ZmzugJPlsw/SqgAqUMau3N2VnL0Cb3Jzk9K82fPUljmJ5JSnY6LXU5MUUmlrnxDgp5YCB/jCwZ37KTf22RbtbiakDenXjZTptR7/dxnBR/m92dG81PhYJxRjXGlEh0gaHuJmtvFtyFBP9s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mz38OuO0; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mz38OuO0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791499712; x=1823035712;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=J86uSP1YOhcBvRMUM63f/btfwC7r0bkaKMfcs9OZKA0=;
  b=Mz38OuO0SGtZklCB3QQekj0k5UE5gdaqA/U3og8B9UY45AMURf2qZ0hs
   6tvZg99l837TcAl6XDOgiKddKcMqxhgCsmp8YAMeZsvefBP0+lZuxfuIT
   KtjMOG10cD+kLDtmU9KLTXT1lsfEiHiqPwkjxOq6mGyqlcbxOwUwW/qZQ
   w3bA7/zmwnRPm01WlxvhHFhIpF1ELKLDQc9SMt9gIwzFjHgKLTA2DiHZ4
   aGGHgOo4V3V4waJtVftOVsuMugpr5/lwpBCRqLgFQyIAF+pkp4R9HIuxi
   MGaLfY+uWTqq9Zp+g8y9YVBQ4R9gZuw5gf0Mo0cbgrXwY52q8g4uI1kyu
   g==;
X-CSE-ConnectionGUID: dq7mH6KPQOKuXqljxvAeug==
X-CSE-MsgGUID: Zo9IETAESRmDju92wZrX6A==
X-IronPort-AV: E=McAfee;i="6800,10657,11929"; a="287446"
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="287446"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 15:48:31 -0700
X-CSE-ConnectionGUID: vyVx7RN2S6qR2a4XQ6BI3w==
X-CSE-MsgGUID: s8a3JLcGQEOjadBlj0Jv6A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,147,1787036400"; 
   d="scan'208";a="164156"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2026 15:48:31 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 15:48:30 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Thu, 8 Oct 2026 15:48:30 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.33) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 15:48:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tbe9reI8p/Zr2HqfW+zl+it7wI/1Sqtq5OiWOzX0tDXnYKBfyqnsRp3P/YmRn3lEXR0lwdO9e27jKMYiKvBmKyFODq+C3FiENg6lNLlRmLX7hRkgezVpur9GT7aiwxIAfVVsBRmcC45Oi+9yqNu4RWAvDHO59Cyix+fShanhZ8l7fMkTJW+8hFxuZ9odJIp+S81+DApfOeb03RzmkwHVp4gjVi/jzn7xcgMPysBIYSmT4evggZYbsipWL6K9fa99vz1GQP0M2mltYJns7wA8OGzFLNnp+JKlwUW9OlN7Wv/Y+SyAWmJlTbfnjgYGmKPpmZ/XG0ip8Z0wtpDdS2rlTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rM+6Xj+ZudF0UP4GI7MJ+FYm01cSO0k8UDntnIPlNjw=;
 b=sCiBHZWZe5U1bi7Vi5/ac6lFQn+cht32cVgRMvsChLE3upj3s637Zjq/KNOxfL8atQjCjkk2LZGl3a1N57EmNRlyaCFQbz0R6V+r7Xfhv7d/qNwqK9NXRCXOUK2llclwduxAryazus/b4xCasEgeg4jguDyXRKPxg8uTblr30mNqVej4kB4MguN0paiVRK6JKjegCl69nRQcmwniCK1h2MJxRqaoP3Aw9Ux4nsPGCPClE4Tf2Yg02yK1v5mx9PSFAgJR5PDrYl6NfLmttX/K988a0AC/S8vCI85JlZmdLtDwaZpwkFGVO4eG5E9+Q3CNMuzIZGUIRyyBUCJKVureLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by LV0PR11MB9862.namprd11.prod.outlook.com (2603:10b6:408:382::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.17; Thu, 8 Oct
 2026 22:48:29 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0496.010; Thu, 8 Oct 2026
 22:48:29 +0000
Message-ID: <6e6194c1-099b-4c12-a597-0b9a457ac837@intel.com>
Date: Thu, 8 Oct 2026 15:48:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] x86,fs/resctrl: Cleanups in preparation for
 multiple controls support
To: "Luck, Tony" <tony.luck@intel.com>
CC: <ben.horgan@arm.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1791406459.git.reinette.chatre@intel.com>
 <asfA1E-lBs5aRItb@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <asfA1E-lBs5aRItb@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:303:b8::33) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|LV0PR11MB9862:EE_
X-MS-Office365-Filtering-Correlation-Id: 56721966-83f2-4483-0cc8-08df258e4564
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|11063799006|56012099006|4143699003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info: AfnZP4AzjKu3jU8iJZGdWVbXOcff2g8zecNF7KgkSxKqMmTJUDWWokR5J30F/Y4O36qVTmkflvYFQTLnja1kdr/Io6nWRX1V7zyCCz5S0oppQtDXQ0zihNp5ZQModi7RBCq9ktQdko4KvJj02VaaIuh9vHUicvKz0UtQiLDAQ3uEmTCYX3NZNzn4TNgMjxbmop2hT/72JthM/Hp996EV9Kc6fspJl79X3+Efs2WS5rA5XqwDaB4pDlWfaCK8g1H+eoKQ1H14PVjf3ett0GVTWyEj/xrZKnsZwdn4Gu4/Qw5vT0jOrfbI6+SHgyZ0+WtsvyzPI9GlGywIqMAJgeCIPzZ8O4E9iaom+qz8iyEGE+bVpZ4XWCgCbANj4hflMbA5gSisLdSCJCRRWhgajg87PLsSpM2ThWT9Zs1eISbRZBwoDiwE1+maxStG61hJTiSZJVWLKXbcU8GMBRuvD4AcbaPfnTdJsRyROcI/4zw9paTbxvMYSxONbHkiRo2taMNP0ikmV9C676/S6JjE51FbZxFkMG5PvvncTBJovaAh5Ytvk/4UwFdK4mr1wucuODY064todoQ32W+Ug2H1NnhARp0gscuENy/A/1UZlZwkzu5d4KnOr2BHrgmhhByIUKs88v6BisN25lKOlA5EHjeL1yYcHv/RtLmEo4L4xZquWa4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(11063799006)(56012099006)(4143699003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cCtJVzJDYmdTakVxQmhONFhGMXZhMUhpWGw2aXM5WWU2bVZQNndvUTJMR2F2?=
 =?utf-8?B?TGg3MjFJbnFmeDdNY2N5LzVZcDNoUlJYNUl4RUxmcHVMOWZYZGsxQ1dpMEs4?=
 =?utf-8?B?UkdKYUxsL3Q5RE5nMVN5MC9pVCt3dklVVHhXUU0vRE90anhETFBMQU8yRTJk?=
 =?utf-8?B?dlJHcXNrMWtFNkZhTmtoRUZ0SE5FWHlhcDVOYlBCL0txdkE4MFFpaDk1ajFs?=
 =?utf-8?B?ZWRWOFhaWm9XOXpUdHJsUlZhRFdzN1RlSFZ2eWhtQ2loNDZhMUk3ZkM3eGZM?=
 =?utf-8?B?TEk4SXdxV1dGMDRDS0NyN2NOOFNjQjJYQ3lsQ0FnWHg5UkQ2TFN0SDN1Q2ph?=
 =?utf-8?B?NGZpK1NMb2FJVFRJUlJiT1lhc2tWNlpTdk54dWNhejU0cGZIUzdiL1JjM25u?=
 =?utf-8?B?aWQwajMxVi95WXJud1o2TDcwZjM0UnpDZ3ZtQUUybE1PaU1ha3pBZjRWcE1x?=
 =?utf-8?B?eVRwRW1sRnozcThGMFBLNlVSUkw0NFE0Myt3SERlNWhIdi9xOHJhQTJnWkpL?=
 =?utf-8?B?azlBaUFhc1hFUnBncjZhL0l3YVJsRDNIMURqK0ZSSU50Q3l6WU1VcXhsamVu?=
 =?utf-8?B?MmtvV0gyaFFDYUJ6NVVlRDRmRmhVY1hrNVZzL01ZbnAzMlRaRUhZWFZVRHd3?=
 =?utf-8?B?b0FGWnNXRDNBWGVLWHJSeUFXZDZVeVNNV1l4bHQrQmZxbDJYaDJJQVVpMXM2?=
 =?utf-8?B?Q1BGeWVtQTFUTzYxZUUyTVV1Z0ltN2g3RzdLZ1prSFlwT2dFRWlBMWlvcmZl?=
 =?utf-8?B?MUdCZk5TS1VpR0VTRnE4dTRhS2xPZzk1djZCaWhPemQ2S29acEc1aDlIRExO?=
 =?utf-8?B?eWJ0WEJiZ3VzNzZSem1keXJDZHQ0YkV3a29qK0REUmlreXFnVktJbllIT2xI?=
 =?utf-8?B?ZU9BSTZETVFtK0creHNSeVl1ajd6Mmhqamc2ZmU3TDNMZnNSVEx2OWpCeWdB?=
 =?utf-8?B?YUZOK2hoQ2pYREpNT3hoTnZDamRnK0x6QU01YkJxNmptUEhGNW1GSENjOERn?=
 =?utf-8?B?Zll6VDJtdnA1SkhmZ1NRRkhnelpzekR4YkZDcjB4YUlaNGJTOWVzb2hiUkQ2?=
 =?utf-8?B?TVJiTXB3ZWlObUx1MXRmUFc2RXVNaG9wdHNaUmIwdnVmWTF0ZlA3bmllVEwz?=
 =?utf-8?B?dFhwVFJkdWUzaU1seUd2SGhlMnV3b0VTdmE4ZjhCN0liZ2cweVZmd0Q5aTV0?=
 =?utf-8?B?dG1lb1RqL3UzWGlzU1BDN2Z6SEFpaER5OXp3bW5QZDdSRlNHOVBaR1BIcS95?=
 =?utf-8?B?andOZE9SQ1RYLzlDWlVjTFF6eGVRYVVuUVQ4ZXFLanZJQ0pMTGNtM01CL0ts?=
 =?utf-8?B?dWpYWm5HdUhXdXNTQkUvTi95TUdFNldzdVRwYy90djVJalZyZmhVai9mMUxC?=
 =?utf-8?B?NW9NM2FQbHFoRS9aUTZJaTY4Z0VZV2xGS2NjKzZ2a2U0ZkVOVFNhVnVSczI4?=
 =?utf-8?B?NkRERmNSNkYyY3pnQU1PcENWMU9LNEl6TlBlVlYreVh4TFdaQVJXMTViVm1Y?=
 =?utf-8?B?aUNPTHozZ3hObWRCSFMvQ0VTeG0yeE5PSGNtdnpXWmIzNlhYS282Vzg0RC9H?=
 =?utf-8?B?QkdmdFUrajd2N0Zmb3NrWjBaNmtzUlVZVUVUY20rT2ZXZXpOMU9Zc0dnRWVn?=
 =?utf-8?B?S2pkNCtDWWxDS3VHRFVpcGpnSFdoenl4NUtScS92TFVmbTltait1L0d0NUJJ?=
 =?utf-8?B?andFWWgxbVNJRGtlNXhRcXJKNUhQeWp4L1Qvb1hIRXpmalZCVjJNQWFEME5j?=
 =?utf-8?B?S24xMFpWOWlkT2ZVbUszSjdoN1pJOTd2MkR5NXpyN2R3QW1Kazg1Mm1BQStE?=
 =?utf-8?B?amtzN1lFdDVkTjVLYkNOUmUrTFhVQTc5THZmczF0RFhOR3IwMXEreStzSTNs?=
 =?utf-8?B?dDhJNzNyL1RYbldKbGVGWkdQbUlMN0hJUXNsdVd3bXQvR25NTlY5bmt5R0pI?=
 =?utf-8?B?WW52MmZ2d0V5enI5a1R4SmJ0bjZkSzU0ZGFMYjRMOWNaTXU3YmVWOXE1a3p5?=
 =?utf-8?B?N3pwdzZ5aU12c1MwQ2F6YWZOL25oQ1JJZWV6TkdTVkpwMVNZWlE4Wi9pdlY3?=
 =?utf-8?B?bzNJRzJqaElJOGhiRld6eWU5ZjNFZUtMK3VzR0VkN1ZacUtDbytNTW5VNU5R?=
 =?utf-8?B?UlRjTEJneDhEMEllR0RkdldRNEh1SHZyZHBSbFNOVGRITlovVCtDaG9iYVFJ?=
 =?utf-8?B?WTZHNFptQkt0WXRQRmRVNENGTzgyTFhTUEZjZTRzV1lUU0JNSWlma3d2VmF5?=
 =?utf-8?B?VHducTJrVURlaEluNEw1cW1UamlrUE1tMVVRblZid2VlZ3lKT3ZXcmYvUEpS?=
 =?utf-8?B?b2lJM08wQUVCU0xKMW9jUkkyc0JmVDJwdzRIRnU4Y0UraTNxWXBJcHgwV3dE?=
 =?utf-8?Q?U2K7gzxvdXLF5Wog=3D?=
X-Exchange-RoutingPolicyChecked: MRRwzz6lAaAyDt53Cm3I4+p+uQdXhr3WZB/y7LoeISM14tFQWf9UGftOPe7drOy8gImukQjwQzv+A5Ow6oAa3NJOG7Bjk7tIaTG49qrW27wGEVHB8EpFw4Aa9kSvlg9cbh/SDRWm3Y3Blwf4jxBcxcrHm3U9E0lAXH1vkbRRGOwTsudJJvIuJCjPwZtpeGzdnSUUFxjrBfRt0cWUW86Kz4EEpws0d+nALTyhjM9eI78cmlHixphK55H1wT6/FyJdF0YxG7BMjIlkY2IB6E9PYoVh/KIPDSWJY1bM/jctwkLd9PqboVWc1+7ES6N0Zt7wn3CcKpZXk2+oBMSOYoum9w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 56721966-83f2-4483-0cc8-08df258e4564
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 22:48:29.1814
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oa0icBdrLiMNgtZprNLGGaTQoutJlMLRizsZlE/X4RH4wyM6Od3IFa94zfJn+ctJEK7ziR0D/YCCXBeyuLlR9JW7fE2+Re12FaJwNE5l5bQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV0PR11MB9862
X-OriginatorOrg: intel.com



On 10/8/26 9:12 AM, Luck, Tony wrote:
>> The only intended functional change is a reworded informational message
>> printed if an Intel system with non-linear MBA delay values is encountered.
> 
> I set r->membw.delay_linear = false; and booted to check. Console
> message during boot now includes:
> 
> [    7.372455] resctrl: Non-linear MBA delay values not supported
> 
> Attempting to mount resctrl with the mba_MBps option fails (as expected)
> with:
> 
> mount: /sys/fs/resctrl: fsconfig system call failed: resctrl: mba_MBps requires MBM (mbm_event mode not supported) and linear scale MBA at L3 scope.
> 
> I've been using the older versions of these patches from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/reinette/linux.git resctrl/controls_rfc_v2.4
> 
> and haven't seen any issues.
> 
> 
> Series:
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>
Thank you very much Tony.

Reinette
