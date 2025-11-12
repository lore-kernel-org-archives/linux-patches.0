Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBBC33F8B9
	for <patches@lists.linux.dev>; Wed, 12 Nov 2025 16:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963945; cv=fail; b=VDf7gkD/xQzL81avJd8PUbFy5EJ5WSSTbu373gfk/YshWnwq9V6bTwTK9MxY/fPI6MNSmxewIU5HsoKSWrEr94c+RLb+5W+0VpkklFZh/MulY9n9s1G4nv0IzGqcvfY+G1T3s/uCb1IyiWtVM8dv7aNb+kkrQRcEQcUdbINSQbI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963945; c=relaxed/simple;
	bh=fYtHJDyAiuewIgThaUNlca4JuDMfRuYw2jh52/QPBTw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=rGCSpDUhIa4XL0MVPpqptZdxMbYpAiwNSsoQc2ejRhwql1VuqsdACLCdcbUiZ12EMzbGK5Mw+O09yHCcRyB6FhJPeatziwyNCvTBDF1krgzYCLCqfmz4MuPA/JJ7rHOeczzZBnYiVfowLNkRyzebiPVz9QfUySuLWcK5rOlKN5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=andhQ14w; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="andhQ14w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762963942; x=1794499942;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fYtHJDyAiuewIgThaUNlca4JuDMfRuYw2jh52/QPBTw=;
  b=andhQ14wYJxMAVnDJO9k1Gfj0yauwX1KYUsHXy0FJ0LZLk9UU2riwBY6
   z4kivxp83hfHscF9j+WxMeDz2ZEaRB8U5abZd8yeH9XqAmZiRlJ59ILN8
   nFcNSNmRIQJ9NM6QPrwB215D5q4gCEMwwEwA3i9AMuaq1zVh0n656d5HG
   4/N4hjYqgtdvvg/QkujbhRKpf4506dC9PkaU51ndYSDLKi8VFgK/TtFzG
   urrvhzzzwLp7howulJ6ETkB43HtW6Hv2hkJRxDgq9+dG1RfloeCHnLKij
   hVWi7HyCrUPVbB6Wg5wxwp+jcmsmIaybHoK3aLXRCIy0L1Mb3X2VEoqX/
   A==;
X-CSE-ConnectionGUID: ZuFF9ZtAQO+kssbchkkrKA==
X-CSE-MsgGUID: v/Z/CU4sTgW6fFIakm3rKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="64037955"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="64037955"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 08:12:21 -0800
X-CSE-ConnectionGUID: IHok6E/eR2m87wtcia6MCg==
X-CSE-MsgGUID: X47d/JhMS3O0RYTdfmo3iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="188511142"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 08:12:22 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 08:12:21 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 08:12:21 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.69) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 08:12:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rewy1vWyXec7kNq1S6lbxNvkMDHDKyL+brCA+PYUaOix0aGg8tDYVF7OOYHQPbLyzuTxjfwoIQMqLiDJNK2I6X4baYgfk2AtezWh4kkrQQ886AtQZsxGxwEMnDaMD99UFcRQU4kW0wNNwM1IkMRvaOgwwgMuaZyCCeCrGG9pKqO5Gl4enJ+O9CZlfNlbHT2oJVtRXKUHDwvMWE3NFr3ZW18JAZzM9YTQtbww/R/+7PoNO8SDdPxwfx2YW5PuFyeOuO6M4Z39S0STyIK+8RKM7UDAew2hKUFliojW5Uj4ukY5DjrmEypdvf8yQypIUpQcziXOtgGQZv9Qiwl2BOFiYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HGwCTU3iaK1GUEnWYHBjN39Bkfjj6ImZI+VTjjQDVVk=;
 b=xRIDb0spCPv8FfdO194z59RhoWpFucvWVZMpvTJPgMcP0p8nq2aYZv1kPOtc1yG5LuUi0NjiuS3GdvSW0YWFKe85f4ogf4BryCI3YrWxsEspCtoJ2TUzp4raZWSFmndnGuk9Wu3+O/2WqgMGUkcSE6M1THp+DCjpTc/MV7/w+Mga32/MPUw09jJU3nsAMLyPdfy0aqzHwN2LqYLFfm0bWqeNeZ+2Nj/aMAMJY3vJ92vXrxD5/mUazKDvB1cUfxwcJ+thsTmZcLOKWe5DBj6V5mSiD8HGrtyGKCkMGSkGpH4y8a/4ouFurfrtGydGM+hGwG2RQMcM0XqsQddFsHq0Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by LV3PR11MB8529.namprd11.prod.outlook.com (2603:10b6:408:1b3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Wed, 12 Nov
 2025 16:12:14 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 16:12:14 +0000
Message-ID: <bb74abff-5b0a-44fa-b764-5f4ac74bb353@intel.com>
Date: Wed, 12 Nov 2025 08:12:12 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 12/32] x86,fs/resctrl: Support binary fixed point
 event counters
To: Dave Martin <Dave.Martin@arm.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-13-tony.luck@intel.com>
 <aQtiSmZ14b+U/J4U@e133380.arm.com> <aQveOz66Pd3R0FfI@agluck-desk3>
 <3bf7f52c-80e2-470a-9225-36077a37d7d0@intel.com>
 <aRNw0cugfo/UGsJ4@e133380.arm.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aRNw0cugfo/UGsJ4@e133380.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0004.namprd06.prod.outlook.com
 (2603:10b6:303:2a::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|LV3PR11MB8529:EE_
X-MS-Office365-Filtering-Correlation-Id: b0be8c7b-549b-4751-dde9-08de22063df9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aXd2c0doY1k0WlBCWGVQQ3RtNlRIUS9KRlg4U3FjcEswR1J4U0lEcDJpeXY0?=
 =?utf-8?B?T05BclBYYm9YZHpJeGlwdDUvQ0pFSGZreG4zMzVPdWowOWRmZlVINmorQjJ3?=
 =?utf-8?B?RkdjUGd0amtHTnF5cTk3bThaK2k4NVRudFY1NjR3aDVsYVloenpOQ1BkSWpp?=
 =?utf-8?B?L1dFZFlncTFpQnNkUzRJTG1NT3FMUnFlck1MQVZ1ZVdKTUVraDE1akZxWGM5?=
 =?utf-8?B?OWZVS0RCOEJyS2tnZ2dHTk9Hc2RMaTQvdi9aL0JQK0t3TGFUWjlYZUYvaWhF?=
 =?utf-8?B?Y1pOVG9CU2g5QzI3d1k0bk8vU2c2OXBpSjVGQ2pCUFRUb242UU1xVHNTdXRn?=
 =?utf-8?B?ZUwrNFZvazJVSGtZVThwQ0pyV2tPTTJ6bUlOeisyUnpNM09nalRIRmxKOWxr?=
 =?utf-8?B?NUpMOW1GRkRobHRXeXFBTzNYQkVid2JLci9Pbit4K082NUlKTGsvQTRvNEJB?=
 =?utf-8?B?eHNUSWh0akZwUG82ZlBCYkVsYnhkK0orV0NVQmh1WUFyMTIzbjNGK3ZIZHZW?=
 =?utf-8?B?OWRyYlgrcnlUOHRCT0t5ZVB3TXEvTG11WXFDY1FDbHI0ZWNsTklZUFVwdTky?=
 =?utf-8?B?Vm1VcVJlQXBMZGVDdlVkeE9peFFDb3RKQSsrbEZwbFBvUG92cXl4SFBDTkFJ?=
 =?utf-8?B?TllsRC9BRGhQK2NpcE9zT0JJZ2JhZmt2U1RsQWpUSWZJNnl0d1JkaCt1eWIy?=
 =?utf-8?B?UDBmRWFnSk5URjB6bUwxMEVaUEJSc09kNGZhS1dpNmpXWW9US1EvWkJzelZX?=
 =?utf-8?B?cjFMMTJIUHB1Y1VseityT0RQRldqUjQ4dDB1VHU3WWFrNkNEdGRsS2hrZ1Qz?=
 =?utf-8?B?NEVPV2d1Y2cyZ3dERmF4Vm5wcHI3WVFqM2hzd1dFZ2ZzRitsN21pSlgxcEZ2?=
 =?utf-8?B?Wmp5OVdVanlEci9YYmZTU3YvQmllamphYmNhMUZEK21VYmpMcGE4MzlVeXRi?=
 =?utf-8?B?SmNEYzgzRG9mRnRaYWt4ZXBFNldPSXdlSEpqbEVSMnZ4bE11cHpqT21WWjFH?=
 =?utf-8?B?TEJWL2plZnZ2ekQ1dE8rMUE3RWZ2SXVJQjRpR05jaVBubjV5c0J6emovOWVi?=
 =?utf-8?B?OU1wekxwNkRnSDE3SXliWUpMWktFYlhMVnB4MkVFZWxCTkg2azBoeWFzSmNl?=
 =?utf-8?B?dFZvSkRPR2ZhMzJkVXp0RDBLNGs0ZFBKOGRiclRaK3oyOU83MVpUT1NwSE81?=
 =?utf-8?B?bHIxbjVMTGtULzlPK0l5L2ZDWlJuK0x2ejBnampyZlFaaEhjMkxnTUVZckRx?=
 =?utf-8?B?VVBOZFl6aGU1WHhqZGdua25QbU1WWXM1ZFFjc2lMdmpWcWx5dzhRWUdkeXgy?=
 =?utf-8?B?aUMvQVB2ZFBkM1V4MUYvK2ZmUXJVNWlpV0ZnOG5LWHIrNzgwUDFQallUUEJq?=
 =?utf-8?B?NHJtV1RQQjNCVWExa0NpL3EzYk5rMW9iT0IrajdsWkJLSVFUZUZadXd2eldB?=
 =?utf-8?B?YmVOeXNhZnF1cC9RMVVVZVJGODFLVjJHc3NhREg5NXh3UHFYbWdzNGtwcitC?=
 =?utf-8?B?d3RJNFp1ZFVodzN5cWdxa3RsdjZMZTRYUGVMRDFHcUZxLzcrdW9EMHFZdEE2?=
 =?utf-8?B?d05uZkhPNW1WbVEvZEpISlNUek85Q3l5cFV2ZDRGdzZrMlJVTndUVFNiTGRD?=
 =?utf-8?B?QktsTTR4Z3JHeWJkUFFoKzkwTi9qUWRINXhZQ1A2Vy9FOHMxcDFRYUMvcmhY?=
 =?utf-8?B?dk9ZUEtUditPQytUR28zMUhjcExsNHZLdzNWejN0OWtlbzIzOFlWY2g5eFcy?=
 =?utf-8?B?b2I2OTdvOExZa2QrakZycDJOVHl2R0twME43ZithdXg4M2pKcUJnVkQ4RTZq?=
 =?utf-8?B?YTNOSXBxSXpTTEk1QUZtZThaWWZSdUVKNXZucEZ0UEVzdGU0aGZ5bWZRdzJF?=
 =?utf-8?B?ZFJLcFVFZjZhblBTczFQTDBxS3VIcjVlL2FNYloxcVdNNytzRWh2aC9NNzdn?=
 =?utf-8?Q?NKNaQbv+BrkjgHU7faS0RQRIeG5QbgDj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFdlemY4RjBtbFBMQk1CL3lURDRPUkhlWHltOURZSStFT3YrYVdjMlpzYXFH?=
 =?utf-8?B?a1l2MG9iOUs3N2NJRjU3Q2lXV3V1OXloYi9UMWNFMk9mVlpkamxoNDNpUDJJ?=
 =?utf-8?B?SCtqNjdoY2J6akViYzZ1dmFnQzJzZjVycUZpYWlRTzlNRmlPYUFTSy9WdCtT?=
 =?utf-8?B?Yng5ZnVEWXJ2QWFxOWVVZmNzVVlvNlVER2hPRU1tZFFzSzRQVGh3RWYvZHY0?=
 =?utf-8?B?Q2xlRlA0QzNlcG1IR0UyZFJxRDEwTkF3dzQ4M0Jyc1BFa2JMb2E5U2dsbU9R?=
 =?utf-8?B?VUZBUk0xeTdrWkxtNDJ2cktmV3V1UDBVaWh6aUJqbmZ3Y3l5TVIwMUw5RWRX?=
 =?utf-8?B?K1VUMDF6VkdBZHNwNkdhazNWanpYb3owakU4enYzTDBDdStxU3c5MXh4YTFS?=
 =?utf-8?B?enBvU2ZCendkTmRIVmZYVTFZQUwrR3ExeEx0bERTYy9vRjZidnYvRzNhWmpz?=
 =?utf-8?B?cEROaU8yS3dzeVZVSTBacDA3UGRhdERxYUtSYXdSRU9PZk9FY2ZxVUR0dE5y?=
 =?utf-8?B?eFRVWVYyOEtYbkFHMkZkeFExdE92ejJsTFBXSUY0K1djdWhSMFVFS3JPMmhv?=
 =?utf-8?B?SlNYbkZuQ3JOTUhQVEk0bjhVdlJON2s2STViYWJQZlpnaVpmaUM1d250dUF0?=
 =?utf-8?B?RDBmU3hkYi9maVZXMnIreWN0ell2eWh3MHBwWE9jc0IrVkhqaklPUy9IYmdE?=
 =?utf-8?B?a21SUnNYOUQvSlVsUUpSZ0dvLzBZOWJSZGVmK0pMRUFtMHhqTE1aOVpiYm5N?=
 =?utf-8?B?dVhQdlJNMEQrMER4KzBzUVZMamNjZmpYZXordWNGVXNUcFlvN2tSblN4cXNw?=
 =?utf-8?B?YVh1U2MvOUZMdFZBMW9jOXNFS0QyZUxLS2tJQzBNNEFsMklrYzd0VkhuS2FM?=
 =?utf-8?B?WVJWZ1kxRUlhVkV1UXlNSnBHT0s0MVhJa1RxUVMrNXV3YjhJcUxzVTV4MTRD?=
 =?utf-8?B?NEVQNkwrb0VvWXJwdURNZ2pHZG1ncDJUWHREeGlOZmN2RE1rU2NYL2hlbzBC?=
 =?utf-8?B?TGcwZDVzRVhWclpwTUtwY3drMklSYytITUdTVjJUK3cwcDdQV3MxRXZ6VTFH?=
 =?utf-8?B?YUF3TXdrWjYwMW9JdTV4dDFrbFdsOXFlMlhoc3dUYjdLcHlvMTJraHJnK1BF?=
 =?utf-8?B?cmhwNDFiTmtLbFRsWUFNR3JybmFLMWVidHpVY1k1Vm0ycEhtYVl4RE9JNFdu?=
 =?utf-8?B?enlYdHRtUndGeGhsTFl2aFB1OHlyalBKQ0dtYUVMTHlwTzRNNGVzNndIcmxD?=
 =?utf-8?B?cElyOTZBemhUTzFIMW16YVBRYm1kbHd3NUFBSHlhSzNWMGRvT2lvZkpvc3hG?=
 =?utf-8?B?REpuVmQ5WEhKb054M0tqdGh1Qm9iM2xxb0VqWVRUNmVmYmxKb0l5NEl4bkUw?=
 =?utf-8?B?eWNmby9RM2lNZmw3NFpiYThVYnMwY0FuM3FHR0FiS0VWRFYrbytaQUlLSHF0?=
 =?utf-8?B?M3F4MmNBQkQ2RVFkQjdNejFBdWlZZmhYYml6c1ZXcFpidkUvN0h0Z2h3RjJs?=
 =?utf-8?B?VHd4dnJlNnoyTXVWdDNLQ202ZmIzVTNaUmVNSXFzaHRwaFdYTjNvc2hUMURl?=
 =?utf-8?B?d2llOVdna2YwaDRTODB1YVROaU1WT2QwQTdlL0ZqNFg4VFByaHBYTWRQbnJJ?=
 =?utf-8?B?Mkk3RmkwbWlzeFNXdFV5enZUUEh2UWg5T296T1dvUjZKK0hjMzN0SVo5OVdj?=
 =?utf-8?B?TitUcjVMTHpKMmtjY1NwNVhVZ2VZRU9KbGN3QlU2TVBoSlo5UW01UWlWNGRH?=
 =?utf-8?B?MWIzblRoRmhUZUpXV0paZkRucXg0THYyK0VTQVZDY29uVDBmUDUzdDNKUWdm?=
 =?utf-8?B?VTdMOXRhVEpkZ3ErcTYzUDBJZmlCUWFWZmdCR0RLbEhFU2VZS3pycmxFS2g4?=
 =?utf-8?B?cVUwVDZpRFNVcUpXdzB1NiszWHlaRzVnSmJVTnVhSkpDa3VzK1RvWUg0VDF1?=
 =?utf-8?B?YndNVjl2dVNiR2xhejhoZEpsNVBGbklNUHl2c2dHUmxQbDJjUTE5bVFKU0xj?=
 =?utf-8?B?QlF4OGNKTVZxaktpRi8wNmVQVkF0MlZhZXRSRng2TUhKWE8wTTBrbVNvWmgr?=
 =?utf-8?B?bTNPTW1tRkg5aWF3MzltNlFPSXQrRk4rTmhIMDlLT3Q2SnJiVW10QkZPaGR2?=
 =?utf-8?B?Y3hjWUM2QVNvenhRNkdiY01JYUdUcGlLUWJMUXA4VjgxL0p2UzlsNHVLM1ZK?=
 =?utf-8?B?MGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b0be8c7b-549b-4751-dde9-08de22063df9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 16:12:14.0184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3TYDe0y5bknPJqXdWwn/SGXrDSTphxdk/eJmu2GqKbfmmrBemcorAayw60fTnfQ8ig1XuAhgUTEmMtPXCTgyny+4wBWUfAXYa7TXo2jCQo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8529
X-OriginatorOrg: intel.com

Hi Dave,

On 11/11/25 9:22 AM, Dave Martin wrote:
> Hi,
> 
> On Wed, Nov 05, 2025 at 04:09:28PM -0800, Reinette Chatre wrote:
>> Hi Dave and Tony,
>>
>> On 11/5/25 3:31 PM, Luck, Tony wrote:
>>> On Wed, Nov 05, 2025 at 02:42:18PM +0000, Dave Martin wrote:
>>>> On Wed, Oct 29, 2025 at 09:20:55AM -0700, Tony Luck wrote:
>>
>> ...
>>
>>>>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>>>>> index 40b76eaa33d0..f5189b6771a0 100644
>>>>> --- a/fs/resctrl/internal.h
>>>>> +++ b/fs/resctrl/internal.h
>>>>> @@ -62,6 +62,9 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>>>>>   *			Only valid if @evtid is an MBM event.
>>>>>   * @configurable:	true if the event is configurable
>>>>>   * @any_cpu:		true if the event can be read from any CPU
>>>>> + * @is_floating_point:	event values are displayed in floating point format
>>>>
>>>> Nit: Maybe rebrand this as is_fixed_point, or is_fractional, or similar?
>>>>
>>>> The print syntax is just a decimal fraction, and the hardware
>>>> representation is fixed-point.  Nothing floats.
>>>
>>> You are right. I can change from is_floating_point to is_fixed_point.
>>>
>>
>> This is a fs property though, not hardware, and highlights that the value is displayed in
>> floating point format which is the closest resctrl has to establish a "contract" with user
>> space on what format user space can expect when reading the data as backed with a
>> matching update to resctrl.rst for the events that have this hardcoded by the fs.
>> Whether an architecture uses fixed point format or some other mechanism to determine the
>> value eventually exposed to user space is unique to the architecture. 
> 
> Sure, getting the docmuentation right is the most important thing,
> while the internal name for this property is not ABI.
> 
> (I don't strongly object to "is_floating_point", even if we expose this
> in the filesystem, so long as we document carefully what it means.)

Highlighting the member name and description in fs/resctrl/internal.h: 
	@is_floating_point:	event values are displayed in floating point format

I consider it important that the description highlights that the event will be displayed to
user space as floating point. struct mon_evt that contains this member is internal to resctrl fs
and there is no helper available to arch with which @is_floating_point can be changed since
this is a contract with user space. I find that having the member name match that description
and contract easier to read.

The documentation (resctrl.rst) is updated in patch #32 with below to make this clear:

	"core energy" reports a floating point number for the energy (in Joules) ...
	...
	"activity" also reports a floating point value (in Farads).

I agree that internal names are not ABI and this is evident with the only internal
connection to a value displayed as floating point being an internal fixed point fraction
number. This can change any time. We have to draw the line somewhere to make it clear
how resctrl interacts with user space and I find the event's display property to be
appropriate for this.

Reinette

