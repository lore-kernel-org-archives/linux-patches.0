Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519AED53C
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 22:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731448857; cv=fail; b=CiYkzONPx9K4BiQ2DHEHcxXRWBidMUm4L5WgjbPgtIno9bsjvdkFLSHY0Uu4KxTSQ2q1TjcjnSh+cPzvCf161i7H3qihRDOTFKglZGzLPC5uNz4treh0NhOHQI+vjfel8EvQHMmUDr/9WduM76Ejix7WI5wuM9emB7B5ZmB6RcA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731448857; c=relaxed/simple;
	bh=DZ4juMh9rA7Vbhq3kr9z5L424B7UbfSLyd2rG15Sa8U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QklgCfj48VhxRDnkTGwSUfxHO8tOHDJpxKQYbguV1G+RapcTzHMzJpSoMjY6p47nK3SuQH/gMvxRWuHGQmbweWl6xdNOkgh7B6bZFwvsHxCBff6ISv/vj4FG9343XtpVYHk8UfpsfHzB+f2nJFXXfm6PGIjA3Hu5MINeRED8FeI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gDJd8pKv; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gDJd8pKv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731448854; x=1762984854;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DZ4juMh9rA7Vbhq3kr9z5L424B7UbfSLyd2rG15Sa8U=;
  b=gDJd8pKv0fAh0xajX4CenUkiIOwjO8ZrNykz+Ns5ilKcs0riqR+BPm0u
   QyAhzw9fw1M6yr7kOXUayraMwgDO298GC1gyBtQ63A62SHHZ9PWDZwN4R
   7757nxX+m+VVrzC0GYaeqbdHJ4uCFlganHTQL9mCP59UqkOhAdUajrpiJ
   +7DIGdWVYyq2rE4wEiWrZCWoPQJttPHRNdpwF2xxh9rE4xjey2LVBt5vx
   3CtIdrNvnrwyO2XAbyPSzYxLXBA4mBYZhM4QEn3pdqOCLzq0CZurNwOU9
   QL3QrgS8gBvXGvYr4aYwhqsIW3FbzDmjPIeV4v7SSou6NJg0u5z8adGug
   g==;
X-CSE-ConnectionGUID: LH6jOHOQQQaRtdS2F92dFA==
X-CSE-MsgGUID: j7tgECwdSDW71sPIovQtDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11254"; a="31411976"
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="31411976"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 14:00:49 -0800
X-CSE-ConnectionGUID: QK9QJB/sTjWaUnkEl6EWig==
X-CSE-MsgGUID: 78J8tDamQGGcaDeB7VamvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="88081888"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 14:00:48 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 14:00:48 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 14:00:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 14:00:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=myJqYdG3QpqVzWfSSvMz5BKNd+Twu+FIfvB3//Rmzr/rHJnmVb20REKpB/WvVdOHOL2PSNN0DiRfquw9zMPJ1nJaZUcuStEl595Pkuz/AFUPfJdaSHMBROL++YbeDcf/YmNoEfW78UcEMKfA1XFNc0UQhftTlIBb8guhBr4bUeJ2J3pkEs3UgTSAi9442+n7Ir0kY+oG67WVuU/JUTB+Bgg80OeTjR9GX2qj0LbvmEhn2MY17HtNTgBJOW9acG3rrDjktJt0Ew2dTQYCdcHAMPkafwPFyDUX63LK1vwrAMV1tDzOqFpbEkabT3xebZ1SI2mLaWFViJTkwctgwWcylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+jQ6RGm4QvohDJFI0Gp4+wDmed9vumIwpXs6qN5tEU=;
 b=gGM0GpF1UgDywh4isMBX1ZtkvmVON9XzO3wB+R3EZoAd2VTfCkiLIp4E06jK+PyVGXRjPNwTMm49cRiVVH9GrxWWNGNzgtJzS778TmMe5K/r73ngZnoWhwT6jtS7QWfDVJkgkBdaW+2ZqKXjO+0sa3tvk2pLx0M+TjOxLHmQFRyalhz6seMBf9sVdGNFSbuZ8CqjWphGwHyY8ogJaT1D+OCgk7xqDoyZxx9ZIbs5aeTULOgtoT1XHJgqd9a/AltkDysfKNh69G8HY1B++r7x6nUT6Eal1Opt1rt8auTBfiDJ//WN4KNxYfC1I5lq/5MH+k5l7Y0R0tzDA8AIn+mB2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB7097.namprd11.prod.outlook.com (2603:10b6:510:20c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16; Tue, 12 Nov
 2024 22:00:43 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%7]) with mapi id 15.20.8137.027; Tue, 12 Nov 2024
 22:00:38 +0000
Message-ID: <71eb17c7-acca-412c-bd59-17ee5aa0aa07@intel.com>
Date: Tue, 12 Nov 2024 14:00:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 6/7] x86/resctrl: Add write option to "mba_MBps_event"
 file
To: Fenghua Yu <fenghua.yu@intel.com>, "Luck, Tony" <tony.luck@intel.com>,
	Peter Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-7-tony.luck@intel.com>
 <6a677a4b-7163-cc2d-a615-6b8c499eb281@intel.com>
 <SJ1PR11MB60833197C3FCC0B3CF9AA290FC562@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <7f5f1f66-df3e-bebd-4786-7fe8a8115f05@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <7f5f1f66-df3e-bebd-4786-7fe8a8115f05@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0005.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB7097:EE_
X-MS-Office365-Filtering-Correlation-Id: f9159d32-7750-4af0-0795-08dd0365715d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MUpJUXlPL2JZdzBGVGNXYVlWOXZBd2pudEhLVkZuTlVJR2pGOENwQ3NCbjh1?=
 =?utf-8?B?bW9yZ2tSbFJTamQwdkxYcHFLcWMyUklQejg1UlNwZUIzc2VRVTNIeVhiUDhH?=
 =?utf-8?B?SytvWUZHZEV5MjR1VTdnUkFBYi93cno4ZkR4QWRiVko0eVJmWU50clU4U2F3?=
 =?utf-8?B?ZEJ4NlZiY3Vyb1pxM0NFWTNnMUFiUlkwR3p0WkZ0SnFnZ1ZFSmxPNjFXVGt4?=
 =?utf-8?B?R2owaU1XeEhRY0FtcjNWWkpyS1U3Y0Rvd2QxRmZ0Yi96Z01ZZGRNNmVhc3Vw?=
 =?utf-8?B?TUdEUkZUbC9xUkc1dHJCQkw5aEtLN2JyOUdzWG5wTjBJYzM4b0RRRDF3Nzk0?=
 =?utf-8?B?RUg5ZE5aOHl0OXc4amM1NWpkUk9zcERLbUNveVo0aWxKYlZHekdoVm4vdnRi?=
 =?utf-8?B?U2pmOFVsVjJoQUVYRG95M1lYalFSaldQQ3pQaGVCblNMMGQwazVZa1ZlQVZR?=
 =?utf-8?B?RGsvTlBCZ2NVRTNvS2d4QU8yVkRkNlIxaG9YVDA1K21uWTR5bzBGL3FiaXEx?=
 =?utf-8?B?NDJTTm5OYmRKTmRRc0VHOXVyeE1pTjdpb2svTVRTcnZNdGQyNWx3QmRjampJ?=
 =?utf-8?B?dG95aFI4S0tEeHc5VTR1bjIvS0pPL2xKa2RjbjFuT25xNEdTZHkvbHE0aUw1?=
 =?utf-8?B?WkZCZ3BuYmo4WjhqRmVFMi9YQm5SSUpFTU00SVJreEc2UmlQcS92V0EvV2NV?=
 =?utf-8?B?TEtpZzVsUjNPTVRERnBONVV0K3EvSXZHSkNmM1VrVy9uSlRUWG5ybG1PUDFB?=
 =?utf-8?B?YmVpMHZJUGp5K3l4dXY3Mnd0M3hkV2dwWnpmYWpDaU5iMmFoOTliRHZmV2E3?=
 =?utf-8?B?WHlWb3d0blNHbFhkQmpINGdtS0NUM21TclN0azdad2FxaDduSEU4UnNJWEdB?=
 =?utf-8?B?LzNtKzlkQjRjaXVOdjVyL213YnV6ZU5yQ2gzWmpQaXBFcDBtQ3VuWE41UVpO?=
 =?utf-8?B?RlZYMkpCNWIyc0JVTTZLK2d3TjIySWx4WmJZR3pBZnpqa2cyaUlyZnlmcWRx?=
 =?utf-8?B?NFhoV0d1S3dwZjByd25WK3JTM1NjNzh2bjdCMWx3ZSs1YllaWWNXenl1dEwy?=
 =?utf-8?B?VlNHZGhVcW80aURzTmFsTThKMVlodkNJTDdkTlBmV2lFRU94aUxuSnZoRndy?=
 =?utf-8?B?dVI1OXlMeisyaHk3dDZJS0diSDIvNWp6elg5RjFBaHkrc21xTlBmQjNPWmtv?=
 =?utf-8?B?c0g4NS9qcGhwOGp4akREWjhYYWwvcHVhM1ZoSEh2bEVKSjBOYTVRRHFsWmtS?=
 =?utf-8?B?eWZYNVJ5NSs0MDZEQnp4VHUwTTFiYzJLMmtkelE5Y3FYbTdHZnI4T0dKOGN2?=
 =?utf-8?B?RjRlcmxUM1FDQVpGdnBSSFZ5ODl6cVB1bzFpbnE1aFNUaURDRkdLV1dBMTVs?=
 =?utf-8?B?MnJWZUJlU1BOaHluSWd1Z1JNT0JSUlZuSUl3QU9XNS9zanllRXRJVXV4VWtX?=
 =?utf-8?B?UzdYVVpZdlZNeUtycEFvS29mVzl2WVErOUhIS3NKOFpCOWFKSnIxYWw5WEhM?=
 =?utf-8?B?WUlrSEJ5Szh6N00ydkRzTWt1eExHWGF6QlZnT0w4ckd1bStIQjJmNXBkMjFD?=
 =?utf-8?B?d0VPbkQ1SmwwcXdvejd5SWFpZ2RLNkxGRXpYS05pcUZVQndKWnk5eDhIUmlB?=
 =?utf-8?B?MFFqdmVzd2w0Lzgvb09yQVZ0bmFXc3NiVFNiQXkyRXZ0SUw4N0RkT1dwSVBu?=
 =?utf-8?B?QVh1VFExRExjbUR4T3ZjQzlmV2ZmK005L2QyTGxzeFYyYUttbTlvWmRpdmk2?=
 =?utf-8?Q?MiCcbArhoQgee/gCyq3MmPqVYddF8Q9I+9GZ/VT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RGZaRnlnUFZQWk52Z1hwaVJlTUpvanByTzF4d2tsNkxwWHdIRnNSRG9qcUtE?=
 =?utf-8?B?VXVTYkVQT25hY0lnOVFiSUM1UVVTMnFMT1E1SXk5NTV5ZWk4Mmg0c3h1WXQ5?=
 =?utf-8?B?MjVmZFZzM2ZlN1V1VWVPeThGbitKbm1hWnBGUlNkeHdpeWVJcW14enhVc1Ex?=
 =?utf-8?B?Ti93aUNNZlNsK2pRUEwxdGFzTzhaZmlyY2JCQUJ1WDZtODljazhGZHk5OFJZ?=
 =?utf-8?B?OVMvUUNBYW9nZDdiaXZlemVqWW1tMGVnSWlwUzNqKyt0RXhaR3ArNEQvSlJq?=
 =?utf-8?B?NjlaUUxjRk5tYXRORVpQell4bHRIRHpiRENuSWlYZndQKzVpZ2ZGaGo4cTAx?=
 =?utf-8?B?TVpIb0Z2MFAweEo2SDZKN1duNm9VNjlwS1dqT1Rpc3JrZ3A2ajZJcUU1UVBp?=
 =?utf-8?B?MkZkRjhGZFl4SWdtWStFWmVVT0FaTlB5STlJTWd1SUI0R2F0TzNlY0txNUh0?=
 =?utf-8?B?MXZOMlhxb0JtYlg5UTZqZVk4YWtIeG1KNWRBbWJpUnNxWE9NL2pxM0Ixbnlj?=
 =?utf-8?B?ekZ4UGlKRncvbEtZcExSNlQzY2dSeWx6aXRmYm5jam53RXRoNlMwREcvaHZ2?=
 =?utf-8?B?bUNLUjVCS2VFT1Z6SlZwSnZpL1l6RmVtcEo5RDRBVVdGL2xhNWcxVXBlbEI3?=
 =?utf-8?B?alowY0hRRzVma24xZjRwODEyYmMwQXFaajU4aVZ1YnpzeUhJbE9NQ0Y1VENz?=
 =?utf-8?B?VzNzbnBNUzA3L2lCK0plK0g5dnFsZ3dENFJnbWlZQUNLV0tMdlVqbGh6MGp4?=
 =?utf-8?B?RzNON2sramtSOU00YWdRb1JoOEpSMG9JajIrNFM0bFByTEJwQkJRSjF3Q3hk?=
 =?utf-8?B?K2ZRZ1FhalN3N3lYQWFnRjErdzNRd3BHcVVPY3lhVGNISURqZDhLcVFicjIz?=
 =?utf-8?B?REp5N1U3MXZMQVJabE5XaEs0d1NqTmRyZ1pveGRyWG9UNkNhbGlkZGZOVXlj?=
 =?utf-8?B?ZkVVN29CVGZQVWt5a2dzYXNQalBhOEVjc1RmeG13N1FJSXE3VjRMbnkwdW5p?=
 =?utf-8?B?ZXdxazBhY01mOW9DS3Z6eHFOMzNvU1g5am0rcUpVQ0lHZ0ZhSWRGOFB0N0R6?=
 =?utf-8?B?T05TVXBzV1BlRkJrYUtjUTJ5dE8waFU0YjgrRXNBQVpKMUNGTUVOY1ZORUVw?=
 =?utf-8?B?THc4T2t0RUt5L0hrUmdlc1gvOGVPTUllUWxIM0lkMSszeHllRVJSd1ZYZ2JB?=
 =?utf-8?B?L0tHQU41T2M3cUVzRTExTEUyaGdaZGxneWd2NGQwb25BQ1g0cTRrcFpJUk9O?=
 =?utf-8?B?cW80ZEFWdXhOajVzbG5ZR01CQmN0Q3liRHJvV2EwQ0d4eUFicmhCb3A0SjAv?=
 =?utf-8?B?eWkrcFZRdXZRWnk5VDM1UFhmcFdXZ1ZaM0JPenptU3FhN2dXL2prY2FYaHBQ?=
 =?utf-8?B?d1NhUDZYZmxHUmY1dSt2S1JQT0ZXUHJ2R01EVFBqY2Z2a2lUV2ZFK2o2bWhM?=
 =?utf-8?B?NGgrUW9NTTUxdTN3QldZbDBMMDl6QmMrSlZGUXNqdlYydEVoZ2NuR2sxTmJj?=
 =?utf-8?B?YTZpb2s0bC8za0sxNVlaai91ZXhkV0xzQThuYVVUS3JWbDNEeXJuWWVLMzNW?=
 =?utf-8?B?bGhPeTdta0w2U1lIM0JVMDBsbFI1bkc1UDU4VnB6OHNVbnpZUHFGbHFJZXFW?=
 =?utf-8?B?ZUtCRDJNTnVkOGNtbkZCVi91VXhBc3JiL0tnOHBLVXBtQUtVcGdDUm9JaEdv?=
 =?utf-8?B?UGJqU2FyamRwTWlmUnhnYkpXdlVGd1NXM1NVNCtEQlhiUENoMktqci81VVVE?=
 =?utf-8?B?MFc4MEJxOTVTUEsyK2Q4blZpVEdhMmRudDBWamNOU05CNlkzVHFKOW1oSUVt?=
 =?utf-8?B?M284RnFVWW1SWWY5aUs5T3JNa0s0M2kvR3pxa0hldWYwbGRGc0lYcW8rOVR1?=
 =?utf-8?B?SGJ6NzVqMHVXNzlLaDZzbUZKeS92ejNrOG9jbVNEYWIwZWZ3ZjVtdEZxSmxQ?=
 =?utf-8?B?ZjM3bGxwNEIzQ3VXZHFHUG5WcXZ0bC9td2JqM3R1bkIxMlFVbDRrOXJFK1Q5?=
 =?utf-8?B?SjVyUk01L3FxMGpuYzRnaFZtc2dpbTF0WCtKV1lhNXZ3WFppTzdJcCtjV3lZ?=
 =?utf-8?B?TXlSN3Y2bytXTTNCUzVJd2tpNE9jWnNzQmdTN2xDK0FEWWI1MGgrZlgrNEpy?=
 =?utf-8?B?M2g4K1UwZzl2ZXM2bFFHMUpweDNYQ2lkMkwyN1pmKzBKNEF0S2x4WUpiVllh?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f9159d32-7750-4af0-0795-08dd0365715d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 22:00:38.6613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p0BFjF4oDH2QQNvzm2+NxYrSW4Eu0qCSUqqI6XNcgOIg66oN0k8kKuwUS5oyvLH7F//YpVJXlnwTagTvO7H24gVHO6gvinvRyKmldgu0j9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7097
X-OriginatorOrg: intel.com

Hi Fenghua and Tony,

On 11/1/24 5:57 PM, Fenghua Yu wrote:
> Hi, Tony,
> 
> On 11/1/24 16:55, Luck, Tony wrote:
>>>> +   if (!strcmp(buf, "mbm_local_bytes")) {
>>>> +           if (is_mbm_local_enabled())
>>>> +                   rdtgrp->mba_mbps_event = QOS_L3_MBM_LOCAL_EVENT_ID;
>>>> +           else
>>>> +                   ret = -ENXIO;
>>>> +   } else if (!strcmp(buf, "mbm_total_bytes")) {
>>>> +           if (is_mbm_total_enabled())
>>>> +                   rdtgrp->mba_mbps_event = QOS_L3_MBM_TOTAL_EVENT_ID;
>>>
>>>
>>> User may think each time toggling the local/total event will effect MBA.
>>> And they may create usage case like frequently changing the events to
>>> maintain/adjust both total and local within bw boundary.
>>>
>>> But toggling mba_mbps_event faster than 1sec doesn't have any effect on
>>> MBA SC because MBA SC is called every one second.
>>>
>>> Maybe need to add a ratelimit of 1 second on calling this function? And
>>> adding info in the document that toggling speed should be slower than 1
>>> second?
>>
>> The limit would need to be per ctrl_mon group, not on calls to this function.
>> It's perfectly ok to switch multiple groups in a short interval.
> 
> Agree.
> 
>>
>> I'm not sure how to rate limit here. I could add a delay so that the write()
>> call blocks until enough time passes before making the change. But
>> what should I do if a user submits more writes to the file? Queue them
>> all and apply at one second intervals?
> 
> Maybe define "mba_mbps_last_time" in rdtgroup. Then
> 
> if (time_before(jiffies, rdtgrp->mba_mbps_last_time + HZ) {
>     rdt_last_cmd_printf("Too fast (>1/s) mba_MBps event change)\n");
>         rdtgroup_kn_unlock(of->kn);
>     return -EAGAIN;
> }
> rdtgrp->mba_mbps_last_time = jiffies;

This seems like enforcing an unnecessary limitation. For example, this would mean
that user space needs to wait for a second to undo a change to the monitoring event
in case there was a mistake. This seems like an unnecessary restriction to me.

I am also afraid that there may be some corner cases where a write to the file and
the actual run of the overflow handler  (on every domain) may not be exactly HZ apart.

Bandwidth allocation remains to be adjusted in either direction with at most the bandwidth
granularity. A user attempting to toggle bandwidth event cannot expecting large
changes in allocated bandwidth even if the events differ significantly.

Surely we can explore more if we learn about a specific use case.

>> Maybe it would be better to just to add some additional text to the
>> documentation pointing out that resctrl only checks bandwidth once
>> per second to make throttling adjustments. So changes to the event
>> will only have effect after some seconds have passed?
> 
> 
> Add additional text would be great.


Agreed.

Reinette
