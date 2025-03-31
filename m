Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D25F42147E8
	for <patches@lists.linux.dev>; Mon, 31 Mar 2025 16:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743437713; cv=fail; b=hEmj1kTHGX36FWSuZYoxRpEk06lKYDsil3axjhCIY8ANYWcbLapSNsNUkd3rAFVEoua4UtfHpiYcGmQNJkptoG4RT7XGi1dDAtVo+5G5yCLkcPB1YmMdm8Z5Ffv37XTHzbB+mKrPwZBZZpEAumbsrhd1SN+3MiKoHi06n1jfwsU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743437713; c=relaxed/simple;
	bh=Gyuqmtv8VT7JC1j5BAsmG6ZWRfWfx7KGoNyqz4/HkhM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Mtc+VTjCSOmjjVu3ZYoqR9gAS7YCjMIA6Egss2Yp2oq1tk+9UAB2YnLAnHApO+xxUoyiC23Opj4Fv7YB8f9PpwXxf7HpLvyMnp5Dk8oaJrU0+olnGwAMWgFJ7NDamvdz8tDVl5hNnKz5tzl4jTvw/9ozioJNFB5uD8Vdh6iQjb4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CT2pfla/; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CT2pfla/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743437711; x=1774973711;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Gyuqmtv8VT7JC1j5BAsmG6ZWRfWfx7KGoNyqz4/HkhM=;
  b=CT2pfla/bye1YlI6p44mqu6mofXe/Nhel/t+5Y6itZtfL8SoZLpSUZNc
   VuEfVqiYpBK/Tsu7O0CkZ0U9TbEs7YRqMc8iOlJIBYBVCdLYW5iFWuFhe
   4aZtdP/vNQaaloA03CVK10bgRTJA9jMnvP1t1OfyxOntQSTke5/v+OuDR
   CRle31xBcQRypFOpVXj9KM/djo0j4T8LdDhDtcN4xorGGWVc2fx0vCOvC
   lwnHdUiq221cUMDjemRWXmzQVR9n2i1lON/bZihyX1F3RwS5DSLv2Q1+7
   D85NDxi/moU0QzcitcWqaIwzybdL7PsdJXIrGG1xIlcV7fB6kwhwaHoa2
   Q==;
X-CSE-ConnectionGUID: LKATCaMvSEevK+oAxvKg9g==
X-CSE-MsgGUID: iNDOKaHLSqm1KrHbDfsueg==
X-IronPort-AV: E=McAfee;i="6700,10204,11390"; a="55378000"
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="55378000"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:15:10 -0700
X-CSE-ConnectionGUID: OcxGMFePR5CHFZgOIBH9oA==
X-CSE-MsgGUID: oJy1gXIDQlKzPGreOqrLEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,291,1736841600"; 
   d="scan'208";a="125883910"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2025 09:15:10 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 31 Mar 2025 09:15:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 31 Mar 2025 09:15:09 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 31 Mar 2025 09:15:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVIbxjP21upsitnOUsRP6TtkqcGOY9o/mMUDYv+hG1Y1i1yHE3Y2A7T/7PPMoAwMsce+pn2KikZOpkpxhlkA3W/KzMZFdN356yw6u708B3x1wLCcESeRtAnFUxrAPQoq/RshHOQn7BODbbeoRCJqh7JDxu32IbCzSR4GAhajaxcOs12xmhG+JT3T0Z/geW6UCq13bH5Pa4HU1vtdQtoV5dloYmNo7PyFjtgrTvW48wFTMtd9aa3XUrrj58viX+D16QbiCx6lKlBFdpK6IFQDyi5pEO8cDUsgzbZIPAtsqtzuQpdGLmnDCHF2SyAXe+Aml/mdud9EziwctDQdMRQOPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gIwW7m7wrdfyrs6KG/YYpFVVpzcCIRoPCcXIZBCX47g=;
 b=MLNUFvNE7ZKjJhmOo3Sz7EgfNLPhYgA8LXuTjmd7SsBbdKTAV7N8wHLtMo3YHZEK461mkFe0OLw0Er6ykiWVBDCA5XrVV9jv4o3vmcm5I82nLpK92ASCS3StnFQxXZGn0mbhMs/hpybylhPm+nMIMuaDNr7Pn3XYB6hIvfeIbZPWiTnKIH22HOFqu7YOEq+GNY/4dZY3qrm9JNrdr/lX1lufDg0N3cu2XPw7x63H/ReX+EiEAmix0MqzDBXAsz1F2xaBRcwnhFP7tI/++cgvaK9MiMA/enVpovKaHZ3YvEhc+Y333Ve7KOkSDobNKaM6aNIuejqnBhkwAV/bAiQSzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH7PR11MB5768.namprd11.prod.outlook.com (2603:10b6:510:131::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Mon, 31 Mar
 2025 16:14:57 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8534.043; Mon, 31 Mar 2025
 16:14:57 +0000
Message-ID: <b69bee17-6a84-4cb2-ab8a-2793c2fe7c49@intel.com>
Date: Mon, 31 Mar 2025 09:14:55 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/16] x86/rectrl: Fake OOBMSM interface
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250321231609.57418-1-tony.luck@intel.com>
 <20250321231609.57418-2-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250321231609.57418-2-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:303:8f::24) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH7PR11MB5768:EE_
X-MS-Office365-Filtering-Correlation-Id: 4ea9f086-c0fa-449b-c171-08dd706f2dda
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RjBjanBzZTVVT2tlTFVReGJwNDJZbDRNNTF0WXdydzB0aFo2eEFYdmtGTnZM?=
 =?utf-8?B?T1BCaGZncmZBRGxyY1Z6cTY1ZVFMY2Y0Q2xnL3k1dWx4ZDhMeEMxbE9EOUY1?=
 =?utf-8?B?S1lMWUJUM2RBUHFHNElvU1gydi9XQ2lkbGhVQ0poR0FRKzZ0RzNIa3EyMmJo?=
 =?utf-8?B?cDhwaU8yTG1leXZhUjJ2UGNtOGQzNXJ1UEUyTHkrMEhGNDI3TG9vRnJteS9j?=
 =?utf-8?B?RUVXZ0hxQUlqL0xYa1hMaytIakVFZW1XblpiUnNvZTBVZnNQTmxQaVVJTXFR?=
 =?utf-8?B?dit1NDJjYmUycXZWbCtXTTI5R1JlSFNBNzNXQW1UV3JFbnRXdGtTV0JDbVVL?=
 =?utf-8?B?NGJUdDJhVkJFV2xod2tlNjdRRi91R2hJd3pSbTJpYldNZ2JyakVpRkZjRDkx?=
 =?utf-8?B?eC91dSt4ZEZwOFl2Si9TZ1hZenpNUFlJNmpHVCtlU09QVndaaHEvWXIvZVk5?=
 =?utf-8?B?cDFxRUh0SCtKTEN0TU9XeXBYQXJnSlkzNHl5QkY5NkRhb0VRRWNQeTU4dnh3?=
 =?utf-8?B?eUllK3hvNnhBMG1rbkNuTHhma1hLellvenZ5cmZxL0hDVFdXKzdCY2xwNmsy?=
 =?utf-8?B?c3hielF5czFKNk5sWXVjTHBVNHdSTldiSnNQc3hrcDlkVlRmOW5nRnVwZERO?=
 =?utf-8?B?dkF1L2FDZ2dPUG1IenJKZVdlYTJ3eUxMdHhzZnJxR3ZVZHhZbEVaazN3TTU4?=
 =?utf-8?B?bUpuaTVSUXhGZ2VMV0RBNXdhNmN2OHR6TGpFRDJOSDJKVW82dGtoT0d4Wlhj?=
 =?utf-8?B?amp0VEVtUFN5TVBSbkhMaytZSXNBa3JvMkFrcnhqR1RLMUN4Y0Y4andZTGVu?=
 =?utf-8?B?ZlBQaFAvSFhGeEtIcmxxeS9RQTY2ME0xNE1OcXg0RjdnbFVaSlBvbUhkZFpH?=
 =?utf-8?B?MlFDQUlRZktrOWVGeVlIUFhwVUpTeTZjZjBPSWEzeG5CL0s2VVlqOFppMENR?=
 =?utf-8?B?SHBRYnNSTWVYNExFaUtpdzM0MzR4V1pLbDlLOFFqQTBrNmdHUnN0bDhzbFVl?=
 =?utf-8?B?M3FmallUbTFMenhwOVBNUzNMMEtObWJueTFodHNQM0pid0FoZzVhazl1eStE?=
 =?utf-8?B?OVFBZ2VWUEY4d2dPcVVDbGxub3dsdDY3WGNoV054TmZvaWc4ZW1jdHJubm9J?=
 =?utf-8?B?dVR5Wm5KU0owK2JxeGpmMjZhWFBTaVZlTnVkeko3aERDbnJka0JwSGp0UWU3?=
 =?utf-8?B?N2x5WTQyU1ZsUkI3bnlxTk5ndzNMQ01Wdy8vMStVSENyWGpSNy9wN0xMRllL?=
 =?utf-8?B?ODVqMk1abk9KSEs4N244WVpXRkUzb3YrR1JheEYrSE1wRWpBNGtFcWhXWVIr?=
 =?utf-8?B?b2lXRS9tOUFuTjRTSVhsN2RjajFCWFNxQzR1aHR0VjFWL0JmUU1iaWtqdUJQ?=
 =?utf-8?B?c1FYNjVSMzZQYWpOYzl6dm9DTXhyNzVxb251QzVoOENzellYMFFLeC9maElG?=
 =?utf-8?B?bFk4MjdndVhLYnlwTjdOTCtySGlPR2RJaTdvdTI4U2tHeEh6b0V2M0xtektX?=
 =?utf-8?B?aGx5TlFRcHV2ZDNma1BCN0ZSbERhemxjKzUrZWFyMSt1Y0lnd3JxVzFUc3J0?=
 =?utf-8?B?M1o0VHd1UkdBRW1UQklzYlhONDg5UHdnU3luZU5tb2VWMy9sYWR6c0tiSFJO?=
 =?utf-8?B?OHJNOVN3S3gxVGpmQVkxdlp2SFNUWXY5a1d2SHZnVExnbmppa21IUmc4UldF?=
 =?utf-8?B?RUdkclp3RlY5MStiSnhRYVdMUzVCdEJCc2orUUpqK29nbVRmSXJBQ2RyOXRD?=
 =?utf-8?B?OWJlc3BuU21pT2F3YU1iMFFZNHJ6eUZoZlNvUWtobVhFeXJiZmphalNWMXF1?=
 =?utf-8?B?amtUbERYdEJEZkFXOEkxZmxJd1BudUlmQzg1K256dzlpREFGY0xyUlFkd2V1?=
 =?utf-8?Q?RYdb0l500wQ6N?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TzlWRElTNjZxN1dHZzZ0V0ZkbGVDRklsRUt0RzZhVHNkeHo3ZDVJN2ZCTGFr?=
 =?utf-8?B?V0dVNUE2MlFnWHFyQWlsdmlIbjR4K3BBb21USlhaeGFEUkU0cExPdWZkVERM?=
 =?utf-8?B?azlEbm1MTzkzY1g0QkZRcHRsS1FENkxHVzNTRlFOaXoxTmdBTmFyODdOMEk4?=
 =?utf-8?B?MU9yY0ZSSWdSUFkxcU9sVlV5Rkp2L1p4aWFKdmc0REJyK2xUNElaUzFNbEcz?=
 =?utf-8?B?bjhNeS9hQWdTbERMNUIwODdDZXFDbGFkNFF2YnpMWTRjRU1jOStvbVhXWDRY?=
 =?utf-8?B?M3pZdndIb21hT2RsS3RDSkZrNzZkcmVSYVV5TjR2akNzL25Cbkt3cEFMMFMv?=
 =?utf-8?B?QkJWejN4WjhBb0ZuOExUM1Q1N0dISDZ2SkZkZnJRVEdxOTlDUTNnVDJIdGRz?=
 =?utf-8?B?QmZ5YWxXSWlGMHdPUGNvYnFJT3V1YWNESUJUUE81ZGxXRGdSRjNSdlgvWTJP?=
 =?utf-8?B?OWlSdit3dnZHQ2NkTFAwZTFML25BVEMrNVIrMmxvUmNtclNRbUoralBFZUo2?=
 =?utf-8?B?YllHM3QrSlZSMjNyNU9XUWlQYmQ4S1JMajJSMTdQZWtMUFptY0MyVWRaaUJR?=
 =?utf-8?B?WXZyVHpqOEZwZTN6OUE0RTdBeTB0a2grYUw0ekJTNFBwSlhNVDJ6SVZoZXly?=
 =?utf-8?B?RzJPMmhCdHRCTGhPTGFGdlFpellNNGpoYVQvQVB0aEdPY3pCdkFlSjVpS2NR?=
 =?utf-8?B?UDRSWjRyVFRadjhVaUZCMkJWQXNiNURjT1FrRFd0a05wb1RueVMxeW92RnBu?=
 =?utf-8?B?VDRJcHBKLzBtVHM3bEdJSUlmNDNXZy90NjFNa0hZdkU4enl0N1NyODVJNWVV?=
 =?utf-8?B?OXNZK2N6VDdZd2d5SG5YZTk2M01wZHdjTnI3bVRlY2pzUWpBSWZaZUUybG9t?=
 =?utf-8?B?QnpZQ01MTDlJMWNCMU54eWdLamU0Mlp1dGk5NWpJYUxCQXVza2x2ZUJESExV?=
 =?utf-8?B?dHhqNzlUVy82Z21aOTlkcnJWaGpKMkJFcWZmajdYN29YNVpTenFTakpOOWd5?=
 =?utf-8?B?azNtOWplRFZSVlIxZ09lNjNRVzFaWmFRcEp2S0hlbnBtUDhsZndoQThTa0pU?=
 =?utf-8?B?ZmphRHpsR09QbFlWY3krOWNmZDNLelVCTFFubTBUUGZiME10dkxzNU56ZzNn?=
 =?utf-8?B?REtsdS81VDZQTVFBNzFwZlNFQU1ZK2owMGhmeWZuREplbzAvYkcwT1RyVStR?=
 =?utf-8?B?c2JDMC9SVjNVRHI3SlRHRzJ0cWs0Q1MrQXdleFpLN3Z6ZGZYUnUyeWQ5VTlS?=
 =?utf-8?B?S0pDOFE4V0hGejdlelh3dXZjN08zSkoycWFSZTV3SEFOQVlTeUwwNGthV3Nh?=
 =?utf-8?B?d0hPeGFISjJmWm55RlNFbEdsY2luSlNFdVNaVEx6S2xZd1FGeWw3TjUrRkVQ?=
 =?utf-8?B?VTVvVXFWaDlPUEdzVXBTVmlUYkxrZWs4Rzc5VGs1NUkyVG1JczRnWld4QTBZ?=
 =?utf-8?B?NFY3RmNkVEVXSzc4aXcrYVFBb292WjVERyszSm1rZEdBWGZYUC90dWZBOXEr?=
 =?utf-8?B?dE1kWHNtZjZzVjZEVHhuVHUxVXY0OFhpQkQzSkRBYk5hV3pNbmEvaU5oSGxa?=
 =?utf-8?B?cEVZWlIwc3NoT1JGcWEvN2JISXNOcEdlSmtTY3RCQ052VmxJMHB6WUIzWWx3?=
 =?utf-8?B?YWNNKzFrbzRMTExBOXNla3pGMi9UMzVwU1hUcURhZlF4a0ZUUGhvSHUxRDZp?=
 =?utf-8?B?aVc1OWk2RXBpUTkya05YZ1ppLzdUdmdRNm1JaUNhMnc5Y2tyY01OZ0ljQkRm?=
 =?utf-8?B?WDcycy9pdE95SXRDWENpWjRDOE1GNzFaZWd2T3pGK2J5OVpIeHBlMTAvVDlY?=
 =?utf-8?B?TUFWeGpsTjhIb1FhQStlRGkwM1JyU3pVZVk4NjBHUVQ3RjdHR1dGdXRQSXU4?=
 =?utf-8?B?cmplTlFqemVVTEgvK2FJU1BERU5nOGJGdm4yanBMTTltYkJUYTl5N1VVNUJH?=
 =?utf-8?B?Y2Zjc0x0R3crTkpzNVk3RXFOVGlRWExLcUYwT0t5VFVFSFQ1NUdRalFwYmN6?=
 =?utf-8?B?RkJQeDIvb3REdmtMKytxYS96a2tOWFZBZzVNSkJSMHFCNDdSU3lkK2U1QmxI?=
 =?utf-8?B?SlNzcFhUMjViN2Ixc3cwdjgyYUF4OFlCYTIySlRXU1dDSGRabUU1WHFIVG5Y?=
 =?utf-8?B?UDRNYUdaTFVvOEdpM1AydE5rODZMeHdyaTRzVW5aeGpiL1JkRlNXY0packpJ?=
 =?utf-8?B?d2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea9f086-c0fa-449b-c171-08dd706f2dda
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 16:14:57.1805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vlqhQYOHz6GT+4eWhBNrrAeHKM9vxURFqMyGDX77a6sm3MfPYJLwprziJp5Y0GmdxUaniUWBGSgG6vpS4bPwnsgtE92l8vmTJvgjLTLR9u4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5768
X-OriginatorOrg: intel.com

Hi Tony,

(nit in shortlog: rectrl -> resctrl)

On 3/21/25 4:15 PM, Tony Luck wrote:
> Real version is coming soon ... this is here so the remaining parts
> will build (and run ... assuming a 2 socket system that supports RDT
> monitoring ... only missing part is that the event counters just
> report fixed values).
> 
> Real version of this would just add the INTEL_AET_RESCTRL Kconfig
> option with dependency checks on
>   INTEL_VSEC=y && INTEL_AET_TELEMETRY=y && INTEL_AET_DISCOVERY=y
> 
> Just for RFC discussion.

Would appreciate a bit more detail about what OOBMSM provides
to be able to understand this series.

Even though changelog mentions "event counters" I am not able to
recognize any unique events provided by this interface. Instead it
just seems to provide a memory region that is entirely up to resctrl
to interpret based on the "unique identifier" hinted to in cover letter.
I could not find any description that connects the "unique identifier"
to the "guid" used in following patches. I think it will be helpful to
upfront connect the high level "unique identifier" with the "guid" that
the patches use to make this obvious.

Closest information to something that can be used by resctrl is
"num_rmids". Could you please add information on how "num_rmids" relates
to the memory region that is only specified via an addr and size?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../cpu/resctrl/fake_intel_aet_features.h     | 73 +++++++++++++++++++
>  .../cpu/resctrl/fake_intel_aet_features.c     | 65 +++++++++++++++++
>  arch/x86/Kconfig                              |  1 +
>  arch/x86/kernel/cpu/resctrl/Makefile          |  1 +
>  drivers/platform/x86/intel/pmt/Kconfig        |  3 +
>  5 files changed, 143 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
>  create mode 100644 arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
> new file mode 100644
> index 000000000000..c835c4108abc
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +/* Bits stolen from OOBMSM VSEC discovery code */
> +
> +enum pmt_feature_id {
> +	FEATURE_INVALID			= 0x0,
> +	FEATURE_PER_CORE_PERF_TELEM	= 0x1,
> +	FEATURE_PER_CORE_ENV_TELEM	= 0x2,
> +	FEATURE_PER_RMID_PERF_TELEM	= 0x3,
> +	FEATURE_ACCEL_TELEM		= 0x4,
> +	FEATURE_UNCORE_TELEM		= 0x5,
> +	FEATURE_CRASH_LOG		= 0x6,
> +	FEATURE_PETE_LOG		= 0x7,
> +	FEATURE_TPMI_CTRL		= 0x8,
> +	FEATURE_RESERVED		= 0x9,
> +	FEATURE_TRACING			= 0xA,
> +	FEATURE_PER_RMID_ENERGY_TELEM	= 0xB,
> +	FEATURE_MAX			= 0xB,
> +};
> +
> +/**
> + * struct oobmsm_plat_info - Platform information for a device instance
> + * @cdie_mask:       Mask of all compute dies in the partition
> + * @package_id:      CPU Package id
> + * @partition:       Package partition id when multiple VSEC PCI devices per package
> + * @segment:         PCI segment ID
> + * @bus_number:      PCI bus number
> + * @device_number:   PCI device number
> + * @function_number: PCI function number
> + *
> + * Structure to store platform data for a OOBMSM device instance.
> + */
> +struct oobmsm_plat_info {
> +	u16 cdie_mask;
> +	u8 package_id;
> +	u8 partition;
> +	u8 segment;
> +	u8 bus_number;
> +	u8 device_number;
> +	u8 function_number;
> +};
> +
> +enum oobmsm_supplier_type {
> +	OOBMSM_SUP_PLAT_INFO,
> +	OOBMSM_SUP_DISC_INFO,
> +	OOBMSM_SUP_S3M_SIMICS,
> +	OOBMSM_SUP_TYPE_MAX
> +};
> +
> +struct oobmsm_mapping_supplier {
> +	struct device *supplier_dev[OOBMSM_SUP_TYPE_MAX];
> +	struct oobmsm_plat_info plat_info;
> +	unsigned long features;
> +};
> +
> +struct telemetry_region {
> +	struct oobmsm_plat_info	plat_info;
> +	void __iomem		*addr;
> +	size_t			size;
> +	u32			guid;
> +	u32			num_rmids;
> +};

Could there be some description of what a "telemetry_region" is and
how the members should be interpreted by resctrl?

> +
> +struct pmt_feature_group {
> +	enum pmt_feature_id	id;
> +	int			count;
> +	struct kref		kref;
> +	struct telemetry_region	regions[];
> +};
> +
> +struct pmt_feature_group *intel_pmt_get_regions_by_feature(enum pmt_feature_id id);
> +
> +void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group);
> diff --git a/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> new file mode 100644
> index 000000000000..b537068d99fb
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/fake_intel_aet_features.c
> @@ -0,0 +1,65 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#include <linux/cleanup.h>
> +#include <linux/minmax.h>
> +#include <linux/slab.h>
> +#include "fake_intel_aet_features.h"
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +#define ENERGY_QWORDS	((576 * 2) + 3)
> +#define PERF_QWORDS	((576 * 7) + 3)
> +
> +static long pg[4 * ENERGY_QWORDS + 2 * PERF_QWORDS];
> +
> +static int __init fill(void)
> +{
> +	u64 val = 0;
> +
> +	for (int i = 0; i < sizeof(pg); i += sizeof(val)) {
> +		pg[i / sizeof(val)] = BIT_ULL(63) + val;
> +		val++;
> +	}
> +	return 0;
> +}
> +device_initcall(fill);
> +
> +#define PKG_REGION(_entry, _guid, _addr, _pkg)	\
> +	[_entry] = { .guid = _guid, .addr = (void __iomem *)_addr, .plat_info = { .package_id = _pkg }}
> +
> +static struct pmt_feature_group fake_energy = {
> +	.count = 4,
> +	.regions = {
> +		PKG_REGION(0, 0x26696143, &pg[0 * ENERGY_QWORDS], 0),
> +		PKG_REGION(1, 0x26696143, &pg[1 * ENERGY_QWORDS], 0),
> +		PKG_REGION(2, 0x26696143, &pg[2 * ENERGY_QWORDS], 1),
> +		PKG_REGION(3, 0x26696143, &pg[3 * ENERGY_QWORDS], 1)
> +	}
> +};
> +
> +static struct pmt_feature_group fake_perf = {
> +	.count = 2,
> +	.regions = {
> +		PKG_REGION(0, 0x26557651, &pg[4 * ENERGY_QWORDS + 0 * PERF_QWORDS], 0),
> +		PKG_REGION(1, 0x26557651, &pg[4 * ENERGY_QWORDS + 1 * PERF_QWORDS], 1)
> +	}
> +};

Could there be some guidance on how to interpret the hardcoded data? For example,
one group contains two regions and the other four. Was this just done for testing
to ensure implementation supports multiple regions per package or ...? 
Is it expected that multiple feature groups could have different number of regions?
I also think initializing the id would be helpful to understand the example better.

> +
> +struct pmt_feature_group *
> +intel_pmt_get_regions_by_feature(enum pmt_feature_id id)
> +{
> +	switch (id) {
> +	case FEATURE_PER_RMID_ENERGY_TELEM:
> +		return &fake_energy;
> +	case FEATURE_PER_RMID_PERF_TELEM:
> +		return &fake_perf;
> +	default:
> +		return ERR_PTR(-ENOENT);
> +	}
> +	return ERR_PTR(-ENOENT);
> +}
> +
> +void intel_pmt_put_feature_group(struct pmt_feature_group *feature_group)
> +{
> +}
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index ea29d22a621f..6112cb6cad05 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -504,6 +504,7 @@ config X86_CPU_RESCTRL
>  	bool "x86 CPU resource control support"
>  	depends on X86 && (CPU_SUP_INTEL || CPU_SUP_AMD)
>  	depends on MISC_FILESYSTEMS
> +	select INTEL_AET_RESCTRL	if X86_64

I expect something like this will stay (i.e. not part of the "Fake" code).
In this case, should this perhaps only be selected on Intel (CPU_SUP_INTEL)?
(nit: the tab is unexpected)

>  	select ARCH_HAS_CPU_RESCTRL
>  	select RESCTRL_FS
>  	select RESCTRL_FS_PSEUDO_LOCK
> diff --git a/arch/x86/kernel/cpu/resctrl/Makefile b/arch/x86/kernel/cpu/resctrl/Makefile
> index 909be78ec6da..2c3b09f95127 100644
> --- a/arch/x86/kernel/cpu/resctrl/Makefile
> +++ b/arch/x86/kernel/cpu/resctrl/Makefile
> @@ -2,6 +2,7 @@
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= core.o rdtgroup.o monitor.o
>  obj-$(CONFIG_X86_CPU_RESCTRL)		+= ctrlmondata.o
>  obj-$(CONFIG_RESCTRL_FS_PSEUDO_LOCK)	+= pseudo_lock.o
> +obj-$(CONFIG_INTEL_AET_RESCTRL)		+= fake_intel_aet_features.o
>  
>  # To allow define_trace.h's recursive include:
>  CFLAGS_pseudo_lock.o = -I$(src)
> diff --git a/drivers/platform/x86/intel/pmt/Kconfig b/drivers/platform/x86/intel/pmt/Kconfig
> index e916fc966221..6d3b1f64efe9 100644
> --- a/drivers/platform/x86/intel/pmt/Kconfig
> +++ b/drivers/platform/x86/intel/pmt/Kconfig
> @@ -38,3 +38,6 @@ config INTEL_PMT_CRASHLOG
>  
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called intel_pmt_crashlog.
> +
> +config INTEL_AET_RESCTRL
> +	bool

I expect that this will also stay ... if so, could this be expanded to
have needed dependency and also be accompanied by some documentation. Something like
"Architecture selects this when ...." This will make it clear that this is
not something a user will select during kernel build while also explaining
what it is used for.

Reinette

