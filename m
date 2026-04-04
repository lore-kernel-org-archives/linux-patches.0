Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22443145355
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 00:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775264203; cv=fail; b=mLKSEILSs8CLdW5gP3YiMrNibPwGCc64ZgFQLWxOd7rrHe4M3dWLCCaNi3EPd+8QGeO6FuQvkY+7rH1vRh6aYJTKmb4lUhMLENSBUFJdcNsjEOm4IWZoJr0HQsmWNDTBv1tuom+enFgpzN+r4NdWji8qvuPkaV8oIlpVMavNbhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775264203; c=relaxed/simple;
	bh=aHL1va89fuqAvmtG287l4r46L6dBAwth29S5H2XDXSs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C15Wx3jRsC/enDUvrECImvscd3SONyhb+5/yc9eqdhAm/4z6VaKOQHt06c+oHaQu3uLlEvsy64cQBS3CrFqNquLjIzTRrB35xTbbZOfsV3l3PeJxihxzfZCjjrmWbxezVhxNF936GQr4jB9k7yQYIQ2JBaNg+vBsITxWfBc7jM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TuPZuFUP; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TuPZuFUP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775264201; x=1806800201;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aHL1va89fuqAvmtG287l4r46L6dBAwth29S5H2XDXSs=;
  b=TuPZuFUP3J2MXsYHhSzavrkvYxUsMkhww9GSD1dau6vdI/AyzHgqbM3S
   u8LWPacs6P1Ukmc0zVn5x5ZVmXKMrctdXGMrPy298rc/r3RmJGfeZuvjE
   niMVE+p/rINgL0vt2IHIkUhuOnxriFdDrp/nCiqRdnyoN94CMK5nxkT7T
   FiBW/VCe9EmEVLjv51Ys8cCy0rk5n/XGZVYj93b2CfRnv07vXOwyHMwTx
   QOUuZ0Zp3eUs6gStpN4ufJIbjLJQUqQOpKIKdhRYDY+HRwj8Les3hUH6t
   OHglLCLVCypSQG04Wg+13mO3udUklqawOcnn5pjnkwdrkH/cXpKkBcx86
   w==;
X-CSE-ConnectionGUID: BmDhsfXTS4SG7DhimvVazw==
X-CSE-MsgGUID: yXe9MeIZRluDheOsuLBV0g==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76207561"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76207561"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:56:40 -0700
X-CSE-ConnectionGUID: r1UFKXJ+Tlmz48XADD6V7w==
X-CSE-MsgGUID: DjHGam0cTxeuiRAKwu+7CQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="226385663"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:56:41 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:56:40 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 17:56:40 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XBTVbnkCHXJq8ATyvAGK2oGtW5KSZv5plsyy00FDyFmJGG6qzTqiAK7Coin4I7MUSXVsEYQUz9XxKDz9nhgm1LoOnt+VGkuxdikf16kA52Jl2P0qwlzCg0zwRhnAsO3cYnkIk81eLWennsda4Fz7kIAuaracx0++toGInuP9beDyDlxL9A9oHRj3C0XmPoQ7gAy27EaoogwTJFVT7jBZAUFjXZluUHil4qzRChZpEGmxk+0bFN3REUsPuDkDT8WG9zAcWNSq3NUtXbSk9+t76Oo838KDA62lFdqGcm4s1HJY7zcEc/sMFt/kTVk70ukxJQ1zdYkG7i0YrMsm5+VaFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=La8Rg9aNvKlLVVhQgSM5MVjesfINgidnqZqC418QJNc=;
 b=TwUM4F9C8uRZyqXJghJJ79lxkS1YTPFR3YchF7pvo0KZkej8Z1r/TCJhgkTal4lP+eliPdoLusREpV3vyYMn4Mfq2utDkkSmSBb9kR+6vThXst3NyxF0SqkDBFe3TgZVIM+wgdWr9Ww0sBrjSjdYGlbPRGPT/VaX38sa6Cxn90JADv5oUDN5RwWmyEZ7TjiaTDRUy1jeMwwy0IZi3yMqMenuuOZpKAxoWDOPWZ6hOjpXY351c9dsmm/PWku+Oa5VaaiGyV3hEiSK69ARoo1WGElkh7uZxEoq3YkAUvLXLRFqOP/lx0B4bVixl7a9zWOykRd9Vmn2hfTXPavVFqV5sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CYYPR11MB8431.namprd11.prod.outlook.com (2603:10b6:930:c7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Sat, 4 Apr
 2026 00:56:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Sat, 4 Apr 2026
 00:56:37 +0000
Message-ID: <435073c9-02c7-4816-ad07-fdec09610114@intel.com>
Date: Fri, 3 Apr 2026 17:56:35 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/7] x86/resctrl: Resolve PMT and TPMI symbols at
 runtime
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-6-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260330214322.96686-6-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0304.namprd04.prod.outlook.com
 (2603:10b6:303:82::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CYYPR11MB8431:EE_
X-MS-Office365-Filtering-Correlation-Id: 470d5010-cfdb-4cfe-e8fb-08de91e50636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|921020|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: au5umMUcrCU0T2zkMPdNVGq+oxIpvYj1U7QfV6yFpSXZ0YtCWQRXtxjOTi8yk+gqoecu0EmB4iNhLTi4LzqfNtKj339Fy3nFz+hyFbrBSkCyIMufrBlFwTeK1trJK54wvC5xehKrFCBvGKSkREUOC1w6ikSnm9H4vAnyLc2u0ZE6cZi0xHVua05fFNqAZu0CpJh8+SboS3IYvQXZgvGDZa/ihDW2MB9MJLpNJTsDt12C/NcRkCbe2PmwcIkpTHUMVe0Wi84J2+aJywAnyiGY4F9WEHihJpfLLpSneWOIq+4L+mScHQYa/PHTsapZp+BtAQ03bzcehASCsLBYw8dEqz1ry3AwNVNguEkpAY9HCsZIMQFkLPG0iozEg7zvs9JPsaqrvncgbTXV9X7CmL3g74LceOjJ2rCo4Hk0mq2uLOIIq7FgebYCSI6w9OFCqba7K7czHGoltdEJ93yffkc1Gi5qg9lNhsandzeM1SpPazI3iG2cDngzEE/8s6U2f55zM0oMmH1ojB3yEP1yk/aH4KrIWHbdxS+nUasbP4sWSAOxo4SltucSPE5Irc43uQeTnUZKMdi1sC1e/UEiWzgedtk7vNyXUYRnZxTvrqGlddbKrXKbLDCivxq5Um3kF+cLc3EZUnndz8Q7VA9yCShC0IEA3OLBEOqRcGb6i0i2CW8au8uG9oimpLDpCZ1oUFWT7Fnld0s60OSxSJ7hF2owvKX2bkvb3PHmhwzuhyqunYuEL+Fc6dKtd7CL5oNaEaBVKF5SEtzJx4JsEKpwOAgCbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(921020)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YkxqUEhldi8rUG1POTFicmY3L3hYWEVYQ0NIV04vcmg3eE5CWEdyVHVUalQ3?=
 =?utf-8?B?VXI1T01oRjNodS9JZlpuS001aHNhWENxNFRnWUJMRFRGeFdHRU81SlNSTCt4?=
 =?utf-8?B?SmdPYkVRTWE2ZExoeXBlOThRcUU1ZkZmRXB4bU5mUTc3M3E4bjVrNGN3eUxk?=
 =?utf-8?B?ekdkZ3l0eS9qMForYndoNVJlU0w3ZVJ6QWZnSzdkQzU0NmJud0p0aWEwN3dq?=
 =?utf-8?B?T2V5NjZCUTFiUDBPY0hxTVBhbnU2MHNDeGVMNkpYU2JOL0dXa1Mrd21UWDJa?=
 =?utf-8?B?RmE3dDkwNUJpL1VKTFdDRldqZDJWTllibmY3MmI0MkpPY1ZTeFdyeXJaNTJr?=
 =?utf-8?B?ZzJTbzJ0SGsrUTR4QmdUV3J0R25jZGtHTlhoNEdQZ01Ncm1WdWN3bkxEME9v?=
 =?utf-8?B?aUdwZi8vbXJZNHRTQW8rN2JtcEtFdkR0Z3JtWkpEY2RuT3c1RUZYUmttWTVZ?=
 =?utf-8?B?dEFNODhrUnkwcnJCVWVHMTJFczlmZHRLUk5iZC9BUUNhM3dwRGNQRWJkcE55?=
 =?utf-8?B?NGxwQlJodU15d2d4Y0tycVE2SStZbHhUK2FoVE5LeDNlRjlGME5OaVdRSVpZ?=
 =?utf-8?B?a3RXMXo0VGpvUktET0xPMDFEeEZYQ0MzVjlzb0ZmZmF1WXFnK0dwRzdOYTBr?=
 =?utf-8?B?ajl6dHArYkc3eG8xRG5qNlJUbTY4em1ZNVEyVDBoVjd0Nm1mb2N5NGFKUHJL?=
 =?utf-8?B?OHJacDVKeU5rWitFaC9HNUd4V0xOYVA1eXNMUWh5NVZuNWM0eVM1K0FZUytx?=
 =?utf-8?B?TnZFRWYwcDFtK1B1WWdBZmVaVzZFY1F5cDZlT09RcC9kK2dBOUpxSE1oK0Ja?=
 =?utf-8?B?MDR0eWFqWjVuYlB0bTkxT0F3Vy90akhZOGZVMlFxY3dkbVVhUWNRYmR1amlR?=
 =?utf-8?B?bUpQRXVYbVFuRWlrZHNVTzF0dUwxT1N2Y09FK1FQTVl6TURBQVNtNWNvckJ2?=
 =?utf-8?B?bmZwdExzRUwzdnkzOUFJWWM1OU9TK3hkYmxBczFXS0Z5RmpOcEtSc3ZqTTla?=
 =?utf-8?B?UlA0b3NndDFBSVRxanZwNDZreWxxb0xnWnVLZDA0aXh2WGJrSWgxUVFNeE9z?=
 =?utf-8?B?V2t1VitaYjdDQVBtYTlzMEtnaVBFOGlHcHN5dWpYRlpSKzJuK0M5ZFdveVRY?=
 =?utf-8?B?MDhwRmdmWVNCbzYyUFZtb0E1VWlKV2dPRWxQNjBRMEh2UzVoYkQyQTRDMkpt?=
 =?utf-8?B?VW9ZTVpoU2l4SlpYVFdlbFJQNm9uak9XZ3pNd0FVZmVsaUZsdldSai9DcklB?=
 =?utf-8?B?VjA3VjcvNHRTMXZZMzZMdC83b2tSNXJ3bkszRHZXM0JTanpYZU9JVng0czB2?=
 =?utf-8?B?bjV6M2hLNWhKSXVBR1haZ3VhS1c1RytIZ0ptM1VzTlZiZ0NlZUh3TTk1eklr?=
 =?utf-8?B?THBQVEFpekF1UWVvb0JJL2JlbDQ5UUFTOXVzWFlBalFTVUcrTTREd3l3ZVpD?=
 =?utf-8?B?N2F4SnpCNVJoQ29JTkpvbFFMZDBWaU1ocEd3ZmM5amxhNjZqMEZMemJtanNt?=
 =?utf-8?B?RTJkNFBzS3RDMXpVdVoxLzUwbERlWURWazBnT2E2OVFlZDZVNEVFYzA0OVFN?=
 =?utf-8?B?TlpQcWp2MWVXbHJNSDRzdC85b1Q0REorN3AyYk1RZjVGTmJRc1FZL2xWUGwz?=
 =?utf-8?B?aFgzWCtSemVFemtZMm5sOGMwUkFhSmNIaUZnSjMySmFTV2tpRVJrM1YrS1Rr?=
 =?utf-8?B?YWp6ZkxmOUxIaGV4T2xXYjkyTEFSZ1dzVGFFVTRMZjdGZWN6TGU3U3YzTitj?=
 =?utf-8?B?MkJpL2RTWnVNV0NuWHhmU0tCUFoyRmdwNktVM3l0cjlGa3hhZSs0Zkh4TU90?=
 =?utf-8?B?d21oc085QUk4b3FxSUYzbmVyV29GeXlrMTBBaUhxY0xjMGc0ZWtxS1pwU2JV?=
 =?utf-8?B?UUtyTWVGUTVLYWpzQ0hybUFQZkZTazJCM1hHWkxGR0Y5STBCbzIzNzJzd210?=
 =?utf-8?B?UXFISDBlY0NFNlRkL2h2c0N6VytDci8wSWl4eVJUVlIxMnEyOTRFNHQ2THdr?=
 =?utf-8?B?bTNxZmJ1ZWxRb09qaVNKdmZpaEpOcm9kcVJOY0xBT0pyN2FlZXNSaEVDczlQ?=
 =?utf-8?B?OVRyTlErTkh4b3ZCMHpvRkw2ZE9WR21WTXhGRTIwQVVRRE4yVlk1VGdtYzl1?=
 =?utf-8?B?TTNHeFFpOVJZTFRLOEc5dGZuMXFCSklUalp1b3k5WVdpMVVIMWRvTWhNYlBM?=
 =?utf-8?B?OXRMYU9oTVdIektvOFJXSnQ3MzhMRDY1V2NwUThEdnlxVEtRak1ObkpOSjhN?=
 =?utf-8?B?eW1DeHA3UHpwQmR2RURmc0U3M2dJTFEyWTZEdHRha00vaUxHVWNNTEY2V1NZ?=
 =?utf-8?B?NG12Zld3dDRJd2dZUUpSRzVFcXJvNU91WVFTSEtUUU5MaDVqdXdhMWs2bExt?=
 =?utf-8?Q?XaPjcNpQuhKvvpfU=3D?=
X-Exchange-RoutingPolicyChecked: C/kYotwKwBqMg6PulgaX6umPGTugLKmDhoFCegG6q//0KVws5NMiazM0BPXrCoh4bSdYWYqR4GesRn25xeMvG5CEUf6cz88Zazk6bZZ550yiflRUTtWk3eBt+k09z2OA86wT65vLnNE8XkJkJx+liVkQj1LwTZ9XFF3YkT+ojpGw49Cm0OApjCAETZ82E4YBqCWUMD31IH+D+qTlo61xB7OLSFIEhK7XeLOv6SjMI0o+oE/Cmt+rrPewHd/BKc0+WOb7DD3UwrYTOUd5qVuXY1YqFGbGG1/Vyp7wT0NlBmtnEwPwKvsmgDbLKHqfJPVLPVHeI5s09OVjoMnnQ3QmpQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 470d5010-cfdb-4cfe-e8fb-08de91e50636
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 00:56:37.2066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgUvmeGZtbnT5mYgCmCT0B1hPfhd0tWylPhHUGaYjhwBLtW5gmWBZtdPNtz8CPckvfi2XFsdvot0pQuF6Xy5viHISbqxLoYYbWbg92xCumc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8431
X-OriginatorOrg: intel.com

Hi Tony,

On 3/30/26 2:43 PM, Tony Luck wrote:
> The resctrl subsystem is always built-in. Currently, it has a direct
> dependency on INTEL_PMT_TELEMETRY and INTEL_TPMI for Application Event
> Telemetry (AET) features. This forces these drivers to be built-in as well,
> even though they are logically separate.
> 
> Switch to using symbol_request() to resolve AET-related symbols at
> runtime. This allows PMT and TPMI to be built as loadable modules.
> 
> Update the mount/unmount logic to manage these references:
> - Acquire symbol references and pin the modules during resctrl mount.
> - Ensure AET structures are cleaned up and events disabled on unmount.
> - Release symbol references and unpin modules on unmount or if
>   mounting fails.

If I remember correctly resctrl depends on the mount being done much later
than driver initialization to ensure all PMT load and enumeration is
complete by the time resctrl fs is mounted.
Now it looks like these modules can be loaded dynamically on resctrl mount
with the functions learning about PMT feature groups called right after.
Considering the change in timing, is it guaranteed that if
intel_pmt_get_regions_by_feature() is called right after module probe that
the telemetry driver would be done with its enumeration?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 93 ++++++++++++++++++++++---
>  1 file changed, 83 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 743a1894fe9a..14b472106f52 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -23,6 +23,7 @@
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
>  #include <linux/minmax.h>
> +#include <linux/module.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
>  #include <linux/rcupdate.h>
> @@ -289,6 +290,9 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
>  	return FEATURE_INVALID;
>  }
>  
> +static struct pmt_feature_group *(*get_feature)(enum pmt_feature_id id);
> +static void (*put_feature)(struct pmt_feature_group *p);
> +
>  /*
>   * Request a copy of struct pmt_feature_group for each event group. If there is
>   * one, the returned structure has an array of telemetry_region structures,
> @@ -300,7 +304,7 @@ static enum pmt_feature_id lookup_pfid(const char *pfname)
>   * struct pmt_feature_group to indicate that its events are successfully
>   * enabled.
>   */
> -bool intel_aet_get_events(void)
> +static bool aet_get_events(void)
>  {
>  	struct pmt_feature_group *p;
>  	enum pmt_feature_id pfid;
> @@ -309,14 +313,14 @@ bool intel_aet_get_events(void)
>  
>  	for_each_event_group(peg) {
>  		pfid = lookup_pfid((*peg)->pfname);
> -		p = intel_pmt_get_regions_by_feature(pfid);
> +		p = get_feature(pfid);
>  		if (IS_ERR_OR_NULL(p))
>  			continue;
>  		if (enable_events(*peg, p)) {
>  			(*peg)->pfg = p;
>  			ret = true;
>  		} else {
> -			intel_pmt_put_feature_group(p);
> +			put_feature(p);
>  		}
>  	}
>  
> @@ -325,27 +329,96 @@ bool intel_aet_get_events(void)
>  
>  void __exit intel_aet_exit(void)
>  {
> -	struct event_group **peg;
> +}
>  
> -	for_each_event_group(peg) {
> -		if ((*peg)->pfg) {
> -			intel_pmt_put_feature_group((*peg)->pfg);
> -			(*peg)->pfg = NULL;
> -		}
> +static bool get_pmt_references(void)
> +{
> +	get_feature = symbol_request(intel_pmt_get_regions_by_feature);
> +	if (!get_feature)
> +		return false;
> +	put_feature = symbol_request(intel_pmt_put_feature_group);
> +	if (!put_feature) {
> +		symbol_put(intel_pmt_get_regions_by_feature);
> +		get_feature = NULL;
> +		return false;
> +	}
> +
> +	return true;
> +}
> +
> +static void put_pmt_references(void)
> +{
> +	if (get_feature) {
> +		symbol_put(intel_pmt_get_regions_by_feature);
> +		get_feature = NULL;
> +	}
> +	if (put_feature) {
> +		symbol_put(intel_pmt_put_feature_group);
> +		put_feature = NULL;
>  	}
>  }
>  
> +static enum {
> +	AET_UNINITIALIZED,
> +	AET_PRESENT,
> +	AET_NOT_PRESENT
> +} aet_state;
> +
>  bool intel_aet_pre_mount(void)
>  {
> -	return false; // Temporary stub
> +	bool ret;
> +
> +	if (aet_state == AET_PRESENT)
> +		return true;
> +
> +	if (aet_state == AET_NOT_PRESENT || !get_pmt_references())
> +		return false;
> +
> +	ret = aet_get_events();
> +
> +	if (ret) {
> +		aet_state = AET_PRESENT;
> +	} else {
> +		aet_state = AET_NOT_PRESENT;
> +		put_pmt_references();
> +	}
> +
> +	return ret;
> +}

I think I am missing something here. This seems to build a new state
machine on top of existing state tracking. 
What if, instead, just do:
	
	aet_get_events() 
	{

		for_each_event_group(peg) {
			if ((*peg)->pfg) /* This means "AET_PRESENT" ? */
				continue;
			...
		}

	}

Similarly, get_feature and put_feature maintains state about
the symbols.

> +
> +static void aet_cleanup(void)
> +{
> +	struct event_group **peg;
> +
> +	if (aet_state == AET_PRESENT) {

I do not see why this check/state machine is needed, if enumeration was not
done the loop should just do nothing because (*peg)->pfg will always be NULL. 

> +		for_each_event_group(peg) {
> +			if ((*peg)->pfg) {
> +				struct event_group *e = *peg;
> +
> +				for (int j = 0; j < e->num_events; j++)
> +					resctrl_disable_mon_event(e->evts[j].id);

Can this be expected to clean up/reset all changes from enable_events()? For example,
how about event_group::num_rmid and rdt_resource::resctrl_mon::num_rmid?

> +				put_feature((*peg)->pfg);
> +				(*peg)->pfg = NULL;
> +			}
> +		}
> +		put_pmt_references();

Similarly here, put_pmt_references() could just always be called and it will not
do anything if there aren't references?

> +		aet_state = AET_UNINITIALIZED;
> +	}
>  }
>  
>  void intel_aet_mount_result(int ret)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +
> +	if (ret) {
> +		r->mon_capable = false;
> +		aet_cleanup();
> +	}
>  }
>  
>  void intel_aet_unmount(void)
>  {
> +	aet_cleanup();
>  }

I am expecting intel_aet_mount_result() and intel_aet_unmount() to look the same and that
intel_aet_mount_result() thus becomes unnecessary.
Just setting r->mon_capable to false does not seem enough though ... how about all those
monitoring domains that were created? This flow looks unexpected to me, what am I missing?

Reinette


