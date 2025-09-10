Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C49231D749
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 17:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757526932; cv=fail; b=As1NK1c8EO8Kc25K9i/bX9V++oWM7KJmZubGyS0VKOouoydR6YkbKv5cNQiRkTg1nGS04w5vz6nVFFWCVSC/ZaR/rFnG2UGzp18jeMkSn23on5HrPnHDIDPKkAbLu+ygiW1Cz7lI4GSircygysXQvbRhzPTtMnWjd160V2wpz/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757526932; c=relaxed/simple;
	bh=yc6gLGMSZ5EqJim0PZgIsBZDstVwbsZaFPwFR7Z6LaE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kknyVK61EfcFRtDiGjHI3rzyB54tvnmYJLUpsP51dh37pBpur8KMIyAtK/NLDTL02zreX57yikZWezPzwFPHn6GS04Q7S6+nojBTUJMMewKFA4+jzSfQDK5dz5PB3UIHqNJ4F+ulFNqIchkF4nyomCgA/EmdpqlttRs+X12MNsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KSK1qFvG; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KSK1qFvG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757526931; x=1789062931;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yc6gLGMSZ5EqJim0PZgIsBZDstVwbsZaFPwFR7Z6LaE=;
  b=KSK1qFvGrtgFQPkQNw4vSQ5KcNCuHaQ+DUxGta5wvPWb766o7ngqVven
   k4xcZrDRJ/37fGZtrwHYYPTstc2ZUbBOJ/JRg636W+IyeqngsI80mRo+J
   UJ2AI8Kdl1Cx8tJFYt+EG0WH9c97vklOLfbgSbE5pU/AeBF29bFK2q/aJ
   CbWjmkT6FqFoHSN6mu5sCjpktvC8R/Dd1s3IIQuHxqZ0SZQmd1AoArdFz
   sG45bLGSRmF7Rxdh/8qDys30n0PGN9RAJ41eSBDs22n9BqkNxBDquBC2g
   moz99VJARzpteQ13Pn7rts024JThDS/IptvSbV8vTQs+08vtzDw7472CW
   Q==;
X-CSE-ConnectionGUID: lw5FxEW1RLCaWI/fcF9WQw==
X-CSE-MsgGUID: 6bVkxvDHQby627q4ddNF0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="82435053"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="82435053"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:55:30 -0700
X-CSE-ConnectionGUID: 50pIUvXcQwmS1eq/ocHCtw==
X-CSE-MsgGUID: xLDPj6AeR0+cdoLU6GAO0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,255,1751266800"; 
   d="scan'208";a="173034392"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 10:55:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:55:28 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 10:55:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.47)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 10:55:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZW8WwBiI4UGNEdtsWPpkZBVB2bhBjJMMH4R1XmnhfKZozxPGNWT1/YD8o+ZM6NIh/6BGMxutjVnqR5Ugjw8386uLVLUdko9IcyxIAXPpSg6k7ohZI4ETvi/G2J8NHwJ7Oz6TQcdv7nogOFP7MEtVs57NnO0dcnG4MpFxHfzCsquNlGEmv3JW3SZ8tgKh70jeIfpVHInoIJdmRCChXhGc/eqlFaLiyMs64PXXkg512aLYod+DWd6ptKc8yYPtT5LBNs8TpiZ0JFMaODaw16fB7NxmxkfHOK/IPsJ7KswD8dwBnYKgq3Fwv2AsrbeGilTG6SSrH6rJu2rqLClAWy7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mrr8/t7FIzkelWqIaZAzUPEhNVE1RJYcCBvNhYkT1WY=;
 b=YdDo6xD0k/UN1ZqK17L2jmpnaXc1FbLsizQua/KEKk/PC0eMaQH77gxljYCkvHmknrk7OYGWJ0ekP4UpQgjYUnkylENcHFgtm7jFw3RExCtTDvCRGcxz9lhCbOdEphltht1i6zLHczeDicJRESoxZAtgi8EXMQXQ+Rfx7hIIBfvLuKvT2m/rqVnDFoXlc3Tr9anZCxjhNZ4ldgoBs4xUnc6sIn3jA6vJd9NnNjCD6qpPy0Hzn44ylV0AvDLlp3nC8OYZlOL7Vu2cvDx5EqYo1LRPGxmzXuq2AWw8ncymE+QyuOako0ybatV86pBKJliYBO4xMJuG+O/mFkPR4yirFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MN2PR11MB4694.namprd11.prod.outlook.com (2603:10b6:208:266::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 17:55:25 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 17:55:25 +0000
Message-ID: <3ecedad8-6283-4141-9f44-2ac126796ceb@intel.com>
Date: Wed, 10 Sep 2025 10:55:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 25/31] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250829193346.31565-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0260.namprd03.prod.outlook.com
 (2603:10b6:303:b4::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MN2PR11MB4694:EE_
X-MS-Office365-Filtering-Correlation-Id: ac21a32c-eb75-4d74-e1e4-08ddf093387c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VnJnMkMrK2ZCS3BjdExvSzgraSt2SGNSaEo5bkFiQWJ6Wk1nZ3FxcU5iM3Z5?=
 =?utf-8?B?bnhHcXhPNTNqaWQvQUNkaC9haVZ3bGNGWmZqOVdYUUx0ZVJEWnNpWmpSekN1?=
 =?utf-8?B?NGQxL2NSV2tiMDlhTk9MSFcveUg0THZBTzVFY2FzM3RyWkpvajhEVlJ3SnFz?=
 =?utf-8?B?bjIzOFE4RWt0bDlpRmtRTzZwd1J5aEVCaHNScXM3Rmx5Ri90U3dkU25MeUFT?=
 =?utf-8?B?RWtCQVczNjhMckFZYWxmZjFCaTZYd3ZJNldJSFFKa1JYSU5zYU1IRloyZ05Z?=
 =?utf-8?B?ZEZTMzdLZThuY2hkeGhkaWtOa1NVdmoySTRiU1VwdVhsTHdqOHdiUEdwQzhC?=
 =?utf-8?B?ZThtOGhucXk1VmJVbkYrUXpDMm9DMWQxYTV5UHkrRStiamlDajEwaDRIUjFO?=
 =?utf-8?B?U2QxMmswZXZ2M1F6bGNTK25DMWVleEprVEZONnVMbzN1aDNLVDdYM0FBVm5S?=
 =?utf-8?B?RW1HVXJ4R3hqV1liWEg2aWtpRDRDaTNtb2ZFa0hmdkVQQW0veE1pK2REV0dl?=
 =?utf-8?B?Y3l0SE1TS1NJVTBwbW1EYU9XeS9CazNETGkxVnVkU1VtaUhqYmxEMU1RZWxT?=
 =?utf-8?B?Yy9ZUEFJUmhlbzdYR0ViQ0RhUFNWYk5MUHJyRjNtTk1WeWhkTVIrTXRCaTE1?=
 =?utf-8?B?NFJGdnk2VVY2QkhQZnFIV2JNQUQzL1Z0VmxWMGNZd0szdUtnQW9yK2F6aDdu?=
 =?utf-8?B?NkRTd3NRUnB0eGFqUFNDNkFRSkR2M1ZIMnhMYXN0SzhoODJvZlJzSjRDZDdC?=
 =?utf-8?B?Z0FPcFRVOHoxTEIzQmtyV3ZaTHVFWnJ3VkViWFlYSXFtTDFza016RExpYUJi?=
 =?utf-8?B?L28vWGk3N0FiYTlyZDcvZU5STkdYQlRrSkw2T01pZ2tOY3JPeXhVWjBpYjk1?=
 =?utf-8?B?a1VCNWp4OXo0TVNtbjAvQlo2ZFRQMlN5bkRKck51bVRmL1MrWkVLOFgyY3Vu?=
 =?utf-8?B?SHIwamZIVG52T09pWTZaK2NERTlsamdLc201R2crL1psSUJMWFoyK3lqSHVC?=
 =?utf-8?B?TmF4eUJ4YUlzekR0YVhUcHNlSmNGKyttK2FIKzVmZk03Skt0V3pFaXA4VCtJ?=
 =?utf-8?B?NlIwb1ZqeEJGOXlnUnVsckMyWEM3Wk1vcG13L0xWNmUyRDBlQy82cU5acnBF?=
 =?utf-8?B?TmlxNFRBY2hybGdZTU5WMXZ6YXNUK2NlNjNNOGVDWTZaZnY5OXhYcG5LUHdz?=
 =?utf-8?B?cXV0VHdldGFPS0tmd3NxNmFTQ3RKd0hHa1lnSm0xbldhVnN6ZFFVTXlkQlRs?=
 =?utf-8?B?elpDQy8xVWVwK3RxU3FTM2Z2dWVCQURxNnJob2pxZW1KSTZKT3MwTmRiYkRp?=
 =?utf-8?B?Q0g2MEJUSjBxcXY2d3AzWVlHemhJa3NwSGl3U3JwSTU5RHpxSTJnZElKK0t5?=
 =?utf-8?B?RUJLL2NTd0NYOXlWZjNuNHFBbWI4TEFTZUt1ZGdRMElVaVhRc2pPT3VHMUg5?=
 =?utf-8?B?RVZFSC9NQWJubnllZWYyUGJhRVh5bFg4L0VTY2JRb3VYMm9GTDZYU1B4VnhF?=
 =?utf-8?B?cCtYa2l5dm1yam9sVG9CamNmTkd3dWg3YmxOdWdha1l5TFUvUHlXKzNGbkZm?=
 =?utf-8?B?RVBDZXJodkIxK2R5YysyZXJ1TlpqNW9VU1VvUnV6STJuUjJndmlrT3cyL2Nt?=
 =?utf-8?B?Mk1mZlZXWEJWbmNKQ09zMWR1aHVjS1Myb3FCK3F3OExkK1RzNExEcTJKRElx?=
 =?utf-8?B?TGNYMURlT0NqVDRGREN3Z3N1TWV6RHprN085TGhONjNkRUs0TXVUSy9zc3l2?=
 =?utf-8?B?TkJOYjMzeTg2L0c2VzNrcGJuOEhqNXNVZ0J6QnRXbCtTUzNxUkp5dVVJUHQ1?=
 =?utf-8?B?L2wwbk0xZjgzekF1YmtYNVBXNzkvV1dSRUNsai9oZWwyV3ZKZnNEaWdCaVlw?=
 =?utf-8?B?YWw3eXNSY2FNTHJCT21UcDlNanExYzg0VUNpcFpoVENnb2tyN3J1dlZsNDlX?=
 =?utf-8?Q?huldegPJj28=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0U5RzkrSHNrS3pZVVM0R3FoeElTOEVyOXNMem5XYituSHRBWitPU2JrVVlQ?=
 =?utf-8?B?NjMzSjY1WCs3dVRGVDlsWU1JRHRIYVRXUWwxdlQrekZJN2JIdzhza2ZsTG8r?=
 =?utf-8?B?ZjJYZVpEV3ZYRmNaOW1uUFNHWG15d3VnZDZmemlNa1V2U3RhTTBPMVkwN21B?=
 =?utf-8?B?bWp1R3FrdUdldnVUcmI1RDM2OXY3Q3RhaGZJUVN0aGN5TlpjK1FkWXUwaFhH?=
 =?utf-8?B?N2x5NWtZR0l3YzlCMGQ5OGRCL3poZWdhNjl1VytiRmNaVnJYT0RsTHovblRw?=
 =?utf-8?B?d0NlSnRpVmZYYVlJUTR6RkVvVmNLQnh5V09Ld2VKQ2Uya1c4VHJCT2F2ZW5T?=
 =?utf-8?B?WGFNcjRxdmprZ1BrdXFrUFc5VitLMlgzOGd6U1FLNEN3anQ0TldjMDlQeFVU?=
 =?utf-8?B?MktpOXF3YkcvSHlIQWVhNlgyNldCUlpoZHFUMXpZcjRYenJEVGlWT2ZVTDN1?=
 =?utf-8?B?ditjc1ZVQ2JOUm93eE5hc3JuaVhiSXpEOXRtditTRDRiL0tUU2RpRnBnN05I?=
 =?utf-8?B?Wjc4OU83OXpKbUJnaE53RnErVkFyKzNGVGNLUUZuazN1MVpsK0tLZnJaUzBy?=
 =?utf-8?B?N0VsZzNNcjVhWFkzN1gvN2cyaFNaYjlGb0RRcGw4TXJNVXNxVzBZVVJ2V3NK?=
 =?utf-8?B?cUlsandmajdHT2J2UEN6QXBjWHk4aEViMzdWWUl1MVAxcTVla0hlMDJsb3BD?=
 =?utf-8?B?T3lTZW4xSWxzZ2NKNytPTEJwaDlieEpFOUIvcEtUK1d6YmN5T3pvK3FYY1Ex?=
 =?utf-8?B?L09aaVIxS29sbjJmUTE4N0JBb3dodDJxZzFWVVIvL2tRUXV3RXVqOXJ5T0RC?=
 =?utf-8?B?eWlZNHUrc3kzY0gwN3RDSWJ0dUNVZXhtK2tqSUFsaDkvazJlcmppV0ZEYzlT?=
 =?utf-8?B?a0ZvUlMwUVZxKzY4WEw5VDhyNXc1Q3hYQUE0d2V1bkVLb2sveW1jRkJEa0lk?=
 =?utf-8?B?ME44K2w2RDJkdWtSSHAvcW8zRmNKdVlHTlpINUc1ekJVZmRCZ3U1YUdYaU9C?=
 =?utf-8?B?MjdCUDZ6bnRaQlNhblpvK3g2UDRWeS8zdHRDNVFQNnVQaTNxeXJkUHAvNDhp?=
 =?utf-8?B?dnlmamJhMHZXR0NWbVRHdEhSQ1J3a2F2R09XN2piUnE2L0pQMXR2QThQZW4v?=
 =?utf-8?B?R28vczBrUzVXWXRvSVc5Yy9Zc1MzMkJFTFg0TjVlUFdkVUtLMy9RaDRJK2Ja?=
 =?utf-8?B?SnpIaTQ1a0NybEExa2VQTEFmTXRQcXhFcmR3Rk9ubXl5a2ttZ3U5ZytjdkhW?=
 =?utf-8?B?ckR4aVFGcEUrckZRYitYdVpjTmw1TkJicXh4ZDMzNDBYQ1dTZ3Q3YUlZajRB?=
 =?utf-8?B?Wmx5UEFUSnkrTTF2dnRudUt0eHJ5Z0pESDFwcE5Vclg0cXBvRXhRRURXdjk4?=
 =?utf-8?B?bXcvaGp4TWVTaDZTL0RMckpUK3lRRWI4cXhQQ3VQa1VnbjlrZ1JPanZLc2Yz?=
 =?utf-8?B?dDk0VHM4dTBtdXNJeThoRUJ6T0VrQS91ZUwxUmpraDBBREswN04zRmpyc0Ey?=
 =?utf-8?B?M1k2d3hHSUYrTmZTN3VVTEZRdHRLZE0yNjM0cmNnZ1FUdEI0V1B3enRUOXYw?=
 =?utf-8?B?dXRlRUhPeEtQWU9Qa3B6bWVmOUpSS3VzbVRaWnJzMW1hMDJ2LytDNG81NmF1?=
 =?utf-8?B?bjRxOTYrS1p4UjQ2UHMza1M3L3FwZjhURmhYenJ5OGd2WHZmVlRqZnN6WC93?=
 =?utf-8?B?V1lScHlreWdxdVhrS09GOHBmSHJzaUZlczY0WjBRZVE2UnlQWW56eVlJNWov?=
 =?utf-8?B?TzhQaW43RVBmeFdrR1BGYzdONEE0ZWM0ZWorTTJtTzFwYVJZd25jd2FpQWN6?=
 =?utf-8?B?MnF4RldqVDNsQk1obTBzeUlOL2ROWktuSGlvNDlFOVFLWWp6VlRFOWVoRFEr?=
 =?utf-8?B?WlpqdHNkYjZpcGkxN1g2N3d2WVBYNCtyVUZUV0JDWjhUbWROYlZVRGUwK0F3?=
 =?utf-8?B?YmRtNWhhc1V6VkRSNTEyelRMdG1yaldVS1RoSGxjMXlRa29FMWl1UjBabitl?=
 =?utf-8?B?T1YwbUMwYm9Ka1l2cnAzQnRVYm03anBOU2o3ckpQVnpyNW9YNUpiKzlGQmxs?=
 =?utf-8?B?M1RuaFFmSEdTTjF6MUdBTUNvOG1vd1dPY1JUNWI2a3hNTit0aEpSUUQ2akVY?=
 =?utf-8?B?S0tGOTZabUVNL0g2RnZoSm10RFJCY1FFRklUblZibkJOTm4rVjkrcHFSVnZt?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac21a32c-eb75-4d74-e1e4-08ddf093387c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 17:55:25.7297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CC55SlejRFHzG7VAg13oggi5Ct1T9RKqNfezbUbtMxULa2SPZybd4dKebfJpZq95Tz5etyDsJuABNsicRC2pmi0RwT43BTKllI5xMRtLxZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4694
X-OriginatorOrg: intel.com

Hi Tony,

In subject:
closid_num_dirty_rmid -> closid_num_dirty_rmid[]

On 8/29/25 12:33 PM, Tony Luck wrote:
> closid_num_dirty_rmid[] is allocated in dom_data_init() during resctrl
> initialization and freed by dom_data_exit() during resctrl exit giving
> it the same life cycle as rmid_ptrs[].
> 
> Move closid_num_dirty_rmid[] allocaction/free out to
> resctrl_l3_mon_resource_init() and resctrl_l3_mon_resource_exit() in
> preparation for rmid_ptrs[] to be allocated on resctrl mount in support
> of the new telemetry events.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/monitor.c | 56 ++++++++++++++++++++++----------------------
>  1 file changed, 28 insertions(+), 28 deletions(-)
> 
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 33432a7f56da..d5b96aca5d03 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -805,36 +805,14 @@ void mbm_setup_overflow_handler(struct rdt_l3_mon_domain *dom, unsigned long del
>  static int dom_data_init(struct rdt_resource *r)
>  {
>  	u32 idx_limit = resctrl_arch_system_num_rmid_idx();
> -	u32 num_closid = resctrl_arch_get_num_closid(r);
>  	struct rmid_entry *entry = NULL;
>  	int err = 0, i;
>  	u32 idx;
>  
>  	mutex_lock(&rdtgroup_mutex);

mutex is held during original allocation code below ...

> -	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> -		u32 *tmp;
> -
> -		/*
> -		 * If the architecture hasn't provided a sanitised value here,
> -		 * this may result in larger arrays than necessary. Resctrl will
> -		 * use a smaller system wide value based on the resources in
> -		 * use.
> -		 */
> -		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
> -		if (!tmp) {
> -			err = -ENOMEM;
> -			goto out_unlock;
> -		}
> -
> -		closid_num_dirty_rmid = tmp;
> -	}
>  
>  	rmid_ptrs = kcalloc(idx_limit, sizeof(struct rmid_entry), GFP_KERNEL);
>  	if (!rmid_ptrs) {
> -		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> -			kfree(closid_num_dirty_rmid);
> -			closid_num_dirty_rmid = NULL;
> -		}
>  		err = -ENOMEM;
>  		goto out_unlock;
>  	}
> @@ -870,11 +848,6 @@ static void dom_data_exit(struct rdt_resource *r)
>  	if (!r->mon_capable)
>  		goto out_unlock;
>  
> -	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> -		kfree(closid_num_dirty_rmid);
> -		closid_num_dirty_rmid = NULL;
> -	}
> -

mutex is held in original free code  ...

>  	kfree(rmid_ptrs);
>  	rmid_ptrs = NULL;
>  
> @@ -957,9 +930,31 @@ int resctrl_l3_mon_resource_init(void)
>  	if (!r->mon_capable)
>  		return 0;
>  
> +	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> +		u32 num_closid = resctrl_arch_get_num_closid(r);
> +		u32 *tmp;
> +
> +		/*
> +		 * If the architecture hasn't provided a sanitised value here,
> +		 * this may result in larger arrays than necessary. Resctrl will
> +		 * use a smaller system wide value based on the resources in
> +		 * use.
> +		 */
> +		tmp = kcalloc(num_closid, sizeof(*tmp), GFP_KERNEL);
> +		if (!tmp)
> +			return -ENOMEM;
> +
> +		closid_num_dirty_rmid = tmp;
> +	}

mutex no longer held during allocation ... no mention in changelog why this is ok?

> +
>  	ret = dom_data_init(r);
> -	if (ret)
> +	if (ret) {
> +		if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> +			kfree(closid_num_dirty_rmid);
> +			closid_num_dirty_rmid = NULL;
> +		}
>  		return ret;
> +	}
>  
>  	if (resctrl_arch_is_evt_configurable(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>  		mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID].configurable = true;
> @@ -984,5 +979,10 @@ void resctrl_l3_mon_resource_exit(void)
>  {
>  	struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>  

If you also use the "if (!r->mon_capable)" check as is done in original code
then resctrl_l3_mon_resource_exit() will be symmetrical with
resctrl_l3_mon_resource_init(). Since resctrl_l3_mon_resource_exit() is
_always_ called, whether monitoring is enabled or not, adding this check
will also make the code easier to follow and not require that reader knows
how closid_num_dirty_rmid[] is connected.
Another benefit of keeping this check is that it forces the function to
remain L3 resource specific (not just by name) and not seemingly become generic
later in series ("fs/resctrl: Move RMID initialization to first mount")

> +	if (IS_ENABLED(CONFIG_RESCTRL_RMID_DEPENDS_ON_CLOSID)) {
> +		kfree(closid_num_dirty_rmid);
> +		closid_num_dirty_rmid = NULL;
> +	}

... now freed without mutex without mention in changelog?

> +
>  	dom_data_exit(r);
>  }

Reinette
