Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B0F23BCEE
	for <patches@lists.linux.dev>; Tue, 12 May 2026 01:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778550719; cv=fail; b=Iyq/rpZS54NU+jdKJrrBCBwKTDlHqd0lMxUnZXcqtmRfE9rUP9ZZL3QG/iVFQS/HFSZdHpR8UIy5/yPRqjB5LHyueqwN0KmH93+VjyJ7vVOQKaO/bSuGrCjJuRrtn4ZvtbKsbqcS/TZD+GHtEWm60NLup5vvw2F9jU+HTLG33IY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778550719; c=relaxed/simple;
	bh=neQ4Bi77w+X8iPr1kV5wGG06YhUhTkp4w57CTuPSaTg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y6NMuF2T/R+4EL+X4kMZhNBlYqtyKLeZFsYrxOZYIgO7xVcB/5MFr5wgKAgTEoyuEA04o7XPUjSBOpjOCCcgRu3R1dq7diZr42E3Fy1CfCsfT6SZbTlygKjVKxFXP8zfqYjhVCeyKtEi2LHnueOc0fqCoNXnAUpaRR3ah470OEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PJunSB3I; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PJunSB3I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778550718; x=1810086718;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=neQ4Bi77w+X8iPr1kV5wGG06YhUhTkp4w57CTuPSaTg=;
  b=PJunSB3IluzBxMp+/evMGlG2RqR4hR3DRH0FvASXi2qV9iCRRO/I5bsC
   ehnIkJafhpAEzx+KgrLEVVkGqu1H2ys7/l00Wt1rhe9MqX2pev9c6Aadh
   MwRl9VblcK9KPZLNJGRQs0v4dancXK0X3q1zP9idrXMthpeEA5sk7+4vW
   T5aX0T/m3zsZwBfkI7YG+gHjOkYxKNOVZumBGlIN8KZKlrjbZH82ZUQTa
   j5t0WiRb+GlcZMmNFyW0me7lZnRhhuaxNfcvaUCY1ZgO0i/aeBO0YG80w
   SAaGvxeZW2qrm6slGbtBTbSMjqEVB4HHI4P9aaEiAMxAThsCsoouReJ80
   w==;
X-CSE-ConnectionGUID: r9LuHz0xSTmjozaBpcduNA==
X-CSE-MsgGUID: +xujsgZZSJmad4tRfP67nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11783"; a="104905255"
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="104905255"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 18:51:57 -0700
X-CSE-ConnectionGUID: XDsmX2eRSs2N/lcc0V4Xvw==
X-CSE-MsgGUID: 0mI9PJhbR9aNKJLCz2YiIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,230,1770624000"; 
   d="scan'208";a="242617151"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2026 18:51:57 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 18:51:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 11 May 2026 18:51:56 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.21) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 11 May 2026 18:51:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FFUkQ1El/uZIiY9h/jYNLznM1ttmu981lyeINPjNQBmDY4aRbxyd14mHXs/Sn8Mm6eTKNDS+iLeXJ3d8PTYpMlN29o9M1IMo8UyincbngmHejn0tMZR7gKrJbEz+6ul2D3wrURwnULD7H5gYixkgssNFuIt41mj0tlrrz0hevPXeBvG0N22srQKr81NDWsG9VsxYyWJsKrpx3miERqlVCRSsx0GY3F2AEW18r1tpE2npuXjneSZpMN6Mn6N4jd6PSCHd6qA7TuH/+ErkfNRoSC1o5EFo/EkV1r5CZfhKLsNPAXgWFSDjVviIhoBwk8r/HheJVV6Jriz6+dsjGfb5vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7invBAZXS0ZcpE0MTqCOTQ3/SUOmrLfPZjEoaLbOF8=;
 b=SDl/dHsvqTUVHXprpWgBn4C1Ir8ThXHWUxlKkbMC7cLOJMQ1u+kly/1Owr+/6iJBArWyc7NKe1YDNmUKa5Aik4uX4IzhMQqV6ZF1JM69N/RkVyf2l5+gVt9PVYxZDBv1J3fv7oD3zPLOqDk86Jqdgb8bMiLWMJRpfJccGWiB8+NCUEw3G8++nyTk4Z+513O412qv5lHVwOyWcNzHa4DOt+loAyIirh94wfM0gANI6oZsvAfCXzIDV8+xxy1amtirvhKaS4K6OpOcWpK9guhAUcDVU+D6or5UjPP2zG33LKfGEQd8OMKteAonKe62w98hoSap9HZ0oHMZAm3WmXFCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9891.22; Tue, 12 May 2026 01:51:43 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%6]) with mapi id 15.20.9891.021; Tue, 12 May 2026
 01:51:43 +0000
Message-ID: <c75f9da9-e013-4303-9c2f-31bd093e3302@intel.com>
Date: Tue, 12 May 2026 09:51:33 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] fs/resctrl: Free mon_data structures on
 rdt_get_tree() failure
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Reinette Chatre
	<reinette.chatre@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, Babu Moger
	<babu.moger@amd.com>, James Morse <james.morse@arm.com>, Peter Newman
	<peternewman@google.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
References: <20260508182143.14592-1-tony.luck@intel.com>
 <20260508182143.14592-3-tony.luck@intel.com> <af5XYNAklCdaAfsy@agluck-desk3>
 <3c1a99f4-de10-4953-92bd-4a93a5000a93@intel.com>
 <agFJ6xNx3zjtEaOS@agluck-desk3>
Content-Language: en-US
From: "Chen, Yu C" <yu.c.chen@intel.com>
In-Reply-To: <agFJ6xNx3zjtEaOS@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR02CA0010.apcprd02.prod.outlook.com
 (2603:1096:4:194::15) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|DS7PR11MB5966:EE_
X-MS-Office365-Filtering-Correlation-Id: 08870444-8aa3-421b-5645-08deafc90475
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|11063799003|3023799003|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: w8PKgp03JIZJIJfkSk4wmBvN3hL+As/jRwL0o2bojorcZLzAbjP2AUqiEMG03ugf7xeC9NPByo0BvIscLUONMxBaAnAVL3pLYNZfqPswNm9BnWfFOYXsSKSZgZbyCPg5qnelMmq7FIohMEmjF/5tXJmq16xqEZ5fXlcyqR40aNxg8q4glHJJ2VOIESS+B4ztkntUqkXjj9+o62n4/CAjCWJEc1oYeIemlJxMi8mxPBHOn8Ao17CKiIxtwP4BSdxZ3TOM76Y1wR7A9ZIFfywOZ0TGwWsGcatWhi1INrgcCLiPM1564qY0PbLKbvfHol9lw2IkThSVBNmIgp/q3hrSLiPshEzJeKvIajoru8HIWX5XGFXFaRdSFha6/SB4ZKOB/C5fztudJ5EHHrBcZJpbZ4loGBNOAJkmeZuSoPPnPYIDpuzUkJe3TQyEs7VZ6m4Q7amv1/AXSHfpWDmsWQms1YgYEoyHi27vQaKWD9lnyzWCfbGzjMjt5MnfB/ph79BQXARIndqU8VGcrqE8dHNt05TXT2OJ9KFRBGGPz57Q7QpFzoeCfczSykTED8iqRqpWv8QKxAaSaVkiusNN7RomtOg04hzkagrE4Fam0qJD01xMqZ70ftAOumn+/ocqw2YL73rfMNjQlAzA5WGSFxIHL08gHQ3+X0XWWtrP9DOnh5z4y3B2TLUzr9Rmc8ZbHwmjiou/rh73HHap0NljSmKaRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(11063799003)(3023799003)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGNsLzhBZ3FmN05tQmVjcjVWK25xdDZSa01ERmt0QnpESHVZQW1WZ2NBb29t?=
 =?utf-8?B?UHBIaXpFaXpEZUdCcWxkaFcxMHRzS04xVjl0cFNMS2V3cUJGWStGQ004Y0p6?=
 =?utf-8?B?aklDZ0h6K3kzUmU5aGc1WEdJZGRLSEhYTTVQYnY2UkJiWmFFMWhwZ0QxTEFU?=
 =?utf-8?B?WlJUY0JKSHg4Y2VDVXd5RmF3VnE1cENYSFBETE1DUkhwaGtjOG1aOElCZzZB?=
 =?utf-8?B?Rmo1MkFzVE1oMUt3amg4eGJVUWFKTzRTdVR3Q3hGNlhNRnpRVnNuRjdReFIv?=
 =?utf-8?B?Tm9yVHZ3bWFBQjBWQ0ttU2orQnRPVkh2WXloNXpNZFlEUWJFY0w3MFlmcGtY?=
 =?utf-8?B?YmRpeFdxcWxGakptclRLd2k1andidElrU3o2RUhaUmFwYXZScnVMYTF3cDcx?=
 =?utf-8?B?NlBqKzBWU0dyQVBZdEV3K2pvN0lNUms3WkVDSHd5WHc2dHNseS96UjVNUW5n?=
 =?utf-8?B?bGVOdGJERUMxYUMraHFnWk4xRTJVM0lJSFkxK2JqOElHZmhKYi93QVdGV3FU?=
 =?utf-8?B?bXA3L1JVaWdJWE13cmFPV3Nqa3RzSElHZVJKR1YvNVYreUpLcGp5RU1GbHJ3?=
 =?utf-8?B?TnVkU2d3U0RYR3lBSzFSN3FibmF2S3BTS1R0aHRtbjdOVjZVSjFaWjZLbmxs?=
 =?utf-8?B?VENjZ2VsRkJaV3Fvdm1VZzE2ZnYwUVZtUVhpTHF3dVRKSGNHYmYwVUJ3WWxl?=
 =?utf-8?B?Qk1xbHJZVGw3MCt1MU43dXF6dW4rZFVHVnFheUk2UnVsdHhoWDM1WHRaRTRF?=
 =?utf-8?B?c200RlgrMzJvNXFOcUhWN0NqQ0JuR2JjaUtabW4yNFVoNDZ2citxTGtwU0tC?=
 =?utf-8?B?RjJ2bUdEU25STG03L3luS0VYMUEwejZBRTlGZU9uNXNaajhmckY4aU1WeEE0?=
 =?utf-8?B?SzNXT2dROWlIWUx6MGM1UWR0U0V1RkN1UU41WnpWVXFoZGsrNmFvcWRnT01E?=
 =?utf-8?B?Z0xGTFRrMHBmODg4WCtnd0pyMTlEYndRcHN2dW5MRTAvVk5oVzdoMlZJYzll?=
 =?utf-8?B?Z1VCYkN2RUhHZmZrbVFBcldpc013S0xaTkZEUm1zZHRIdGtuZGtiLzNDeDN1?=
 =?utf-8?B?VW1Xc2QvUlJROENnaTRlM3FieHQyYkMxcHhrK1pENXBrbDg3Q2xPTUZ5U0Fj?=
 =?utf-8?B?UWJOVmJFRXRlaVh0M0RucGJXYlFVM21zUnA1M0Y2bUIzNTJmVHlURDZ4YnJu?=
 =?utf-8?B?MkxTN2ZUa0JHQ1lwRGx6M3hnOTZxSzVZK2pkRmV2UlNNZzNzSVZjUkRzOGI2?=
 =?utf-8?B?Y0ZZbHBEWnhKTTdtdkl4WXBWanRYZ1ZKSHZLM1dtTEJ3Tk9pT1ZQSVVIc3Iv?=
 =?utf-8?B?a0xUeE9qOVVRcUd1bHJQYnUwdlc2aTA3WTQyWkhidzRSTmUyM1FXTVlpVGVR?=
 =?utf-8?B?Nld1U1d4L2NCQ2JkWElVMHh5SkJHM3ZFYVYwMDM2WVE2SVlrbldjZElYVXBF?=
 =?utf-8?B?c1VHSng2Wm9UcllVaGRBcGRnN3BQblBzM2EvNEwwSWxPYzI4ZE1DMi9uVklI?=
 =?utf-8?B?dFdtOHQzd2xHZE15ejVWUm1wSVJuc2ZIT2dBbEdSUDZYdHNiWjBaOXd3NFpP?=
 =?utf-8?B?ckU5ZXdoN1ZXT3ZDQy9QcGFnR20vMkVMTndLTmdlb3JwV0VnM255eEcrUHZt?=
 =?utf-8?B?UXlhUmNORmRkNGtacGNDOFRlUnN2Q0JMUXFsYmI3Snh2N2pYeU9kMjRJbkpu?=
 =?utf-8?B?RGlBQWNTMTdVaVk3MkprdU9kR1N5ZEsxTG14MUNHRHlDazBxdHpkdXpOeHpt?=
 =?utf-8?B?YjBIekFLdU1za3RhTS8rVzVjdTY0TlYxNnVLRHhDOVRWL3llZlVvcFZkdFdm?=
 =?utf-8?B?c0JxNG95TW5oUlU0WUxubkVHUVFJVG54OHFmUnlIQ2ZhRko3RGF2dVY4aVk5?=
 =?utf-8?B?ejUvTlo4eHQxQ2JjSHJ4OEM0R01Mb0dhWTB5Y2RVR3g5NlNnazVLWGJzOWlp?=
 =?utf-8?B?bFFWOFE3VG1iR0F3RWpDN1FvZWw0cTl4T21lOTNKMUFTTFluaFd6NlZZSC95?=
 =?utf-8?B?dWx6aWFxZ0k3TnU5SmFibklIVTJYanBYcmNHSFNjdWNHSXJvcjVOdVdWUmJQ?=
 =?utf-8?B?em52YzdoVXFSWVJMUGlocGFISFpwM2ZnVStiWmNZQkNPTnFmWnVkS09aWjJS?=
 =?utf-8?B?alMvK2E4Tjc4TFZOZ2M1Vm1LRVNhTEJVREpYbS85MGtYak9nRW5SQnF6M0NY?=
 =?utf-8?B?R09iN3NMcDVSd1hwbE03M2wyU2NOUU5wK1dlZGhyME50eGVNcmp6VU9UTnov?=
 =?utf-8?B?czlOZytTRVhobTh5MXhKR1FzZXVwNkV4SzhhcTkwSVFrUlVaZ3VQeEYvY3hj?=
 =?utf-8?B?eEd1cEE2RGhURVdIYlM2OWJ4OVFQbHZHUGVnN09nV1cvVHI0ODRRUT09?=
X-Exchange-RoutingPolicyChecked: JPybOnuSdaSCIJll38kASUWGaUrwivdsu/ig506F+UVpnZKV/VmF4HFBRduVnSg/9zhLo1IHaIlhf/yesDmoye7KhUORxqlL+eWWito/6hotMbstR0VasO8io0Ao8Khg6biEzT1Sc4MtujFQcRe/NBSNe4A3S8NjyT94+nkz0UgtVFrjE7EkT6FdaiHxFQZ1Jtf2cML7nTxM7gku/LXeEGEA401yFW8j1gHvo7MmJ/m5DCWN1Pljck2KAgLboLJkCU4a1XhBy2PiXhANKC6eDVu5W9WcCXLABDMjJIKtc0MaKfk4diIpvquaQl495cZq/plojdQxuUoLkaYqObOtCQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 08870444-8aa3-421b-5645-08deafc90475
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 May 2026 01:51:43.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cJUrgeBzcfK36sg1zogH8v2OmZ07XY6einUEO7tEV+RhQIL39WScs1uBMlOm5fjqPQbfR0gGu3hpllBVsXLKpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5966
X-OriginatorOrg: intel.com

On 5/11/2026 11:15 AM, Luck, Tony wrote:
> On Sat, May 09, 2026 at 08:43:36PM +0800, Chen, Yu C wrote:
>> On 5/9/2026 5:36 AM, Luck, Tony wrote:
>>> On Fri, May 08, 2026 at 11:21:41AM -0700, Tony Luck wrote:
>>>
>>>   From 0263035539f805f5d4bddcef8968b551354cb86d Mon Sep 17 00:00:00 2001
>>> From: Tony Luck <tony.luck@intel.com>
>>> Date: Thu, 7 May 2026 13:48:51 -0700
>>> Subject: [PATCH] fs/resctrl: Free mon_data structures on rdt_get_tree()
>>>    failure
>>>
>>> If mkdir_mondata_all() succeeds but a subsequent call in rdt_get_tree()
>>> fails, the mon_data structures allocated by mon_get_kn_priv() are
>>> leaked. Add mon_put_kn_priv() to the out_mongrp error path to free
>>> them.
>>>
>>> Fixes: ee4f0ec938ad ("fs/resctrl: Simplify allocation of mon_data structures")
>>
>> I did not find above commit in vanilla kernel, should it be 2a6566038544
>> ("x86/resctrl:
>> Expand the width of domid by replacing mon_data_bits") where
>> mon_put_kn_priv() was introduced?
> 
> Thanks for the catch. Another strike against Claude. It didn't hallucinate
> this commit for the fixes tag, that commit does appear in my local repo.
> But in a dead-end branch I created to write the patch. I posted it here
> in v3 of my telemetry series:
> 
> https://lore.kernel.org/all/20250407234032.241215-2-tony.luck@intel.com/
> 
> But James Morse picked it up in v11 of his "Move resctrl filessytem code
> to fs/resctrl" series:
> 
> https://lore.kernel.org/all/20250513171547.15194-13-james.morse@arm.com/
> 
> where it was applied upstream in the 2a6566038544 commit you found.
> 
> I'm somewhat confused that Claude dug through my other branches instead
> of just looking for ancestors of the current branch. Maybe I need an
> explicit instruction to AI agents on how to find commits to use for
> Fixes: tags?

I guess so, Opus 4.6 suggested the following prompt:
"When generating Fixes: tags, only consider commits reachable from the
current branch (git log). Do not search other local branches."

thanks,
Chenyu

> 
> Claude is now double-fired.
> 
> -Tony
