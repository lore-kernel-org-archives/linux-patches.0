Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F502797A3
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 22:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208883; cv=fail; b=VjRTvBv/d2uWv5r5zxAKVVZory0uWJ4Et8Tl6WBTZ/cyhYSTnQAg6zIEyxxUJBYYgTFieY4RHCV1RJ7wJIxrFh/gIvoK3TfgNIQTdp0YSdMxn3CWFEeLUwbuXZ4r+mhNYsPYfIAyyse0TKQvwlGXmVMOTXp6m/d9sGQ/V6ErcIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208883; c=relaxed/simple;
	bh=vt+06rR7RW583cp9AyinLQlTMnxjjbLcjh6zmnwQ3Sc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Klda/SUrs1WZc+/KQla1SHkRDhj3ACTZBMKAgLgIv/flULf9e5BHtJpKjqT/IFF7KwjF3QIa7NMVvOQx1xCOFV/9gXM8glasn7rmbpOWq558PEARiRjE7q9UB+K4KRB6c8B+TZjU6QPZMPxgWTPAqdRNWmv2nQlLGBmZ30x8pww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hzXRQAmm; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hzXRQAmm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208882; x=1786744882;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vt+06rR7RW583cp9AyinLQlTMnxjjbLcjh6zmnwQ3Sc=;
  b=hzXRQAmm105trBBuSWKq5+paTPn+6gFTr3k+0iX1I7HNHyQ0kcmY8r9M
   dMTwyLf+5qKbTO8gaIbaleme5VVEiVFJHvgOdxaeN8tDCkANmfZPT1Fma
   LRurPn8eCbtj52wiHgYdNDlw5DGDCDVOIW4EhfNjCHSEPfiAxfQX3U2Pi
   zU5+7i+5kS+VCdFPICMkmegDR6rE3of4pTtg8aK96ZmVn5j5OsteJxkfK
   prgHIyy3fiQrjDZAdFiqQJTpJK5Uwa+Y53HfzMi2keqIvlfmvWwmjqALB
   s9t88fgVk/yxK4zm/RoABpKItSK4j7gL2FabzvDaqk/5rHiUMfk+WWSaP
   w==;
X-CSE-ConnectionGUID: ewNC22fWROyYhuPbRd1xBg==
X-CSE-MsgGUID: uM402MgfRlulyEul8d5Lmg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="61168765"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="61168765"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:01:21 -0700
X-CSE-ConnectionGUID: XeisXzT2S+arbZh6Nci5iw==
X-CSE-MsgGUID: B/VQ0zJBQTCSi2SuWVqcMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="166500039"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 15:01:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:01:20 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 15:01:20 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.51) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 15:01:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ld9gNfwqbemrOsrkxvyixkfrTR5uXvhAk5DvYDYlp93OnUT061i5l8qJbdG1V/ONDYdPEq/KNCtDR6Kw2uf3/ytPwTDX1vsmp71jSF8oyB0iDM9frS4R4aoJIRzmaNOXsRg7snIp6veYy9kJJKq61bwoAg57Oh5e4Qna1M5koXpUErCJ+2GwcKLLZxgF43LarppZ+C3LSvgW2avrWQHRY/Jc4CCnSPTTB5ItklEpy6qoJVFR1nMChIBrEo2h+VLsrhEQ5vf8OnjbEteNtgBdk4IqXXKAshjjxdmPeqmEEKNq3AKIOksO/wQSHwVDxUN0BtsfeP/e6gvJJ2AoucNyaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e8BH+UeNlIQn3Tb22CgdXTeibczzscwYduRmuG+mWuo=;
 b=JCiou2kSaPeROechk38EBR1CL2/f6DXXtvBnSIYrU14vd067ZJmGeOuYM5ZIhIMwMJcKwOdFawkSMK6GVbtgP/ycmid6rUQ0FGCfjfO92IbLfLVkRq1A83Ck7R/6iL0PRtCyTsXol0UM7cDu6iDdOsxog4g25JfeXfZfxuXjHA+Ns1/ycWWzGdZaD5gWEl02zLaw3m1J62sEA1vmhMIOs1i1hDvadc7uH6q2Oz+CICtEe7/8jG61Oyne59814oDVujzCQb6iXPnGuWlFDiVKhXdLNuGI62zclAQA8vgw1gDUqsmtu6J4kZOyeqF9VcPRTfv+iGv/Kt3TJnqkUC5H2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF2F7FC4EE6.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::81d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.13; Thu, 14 Aug
 2025 22:01:18 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 22:01:18 +0000
Message-ID: <f11e8821-3d7c-4a05-baf0-14f87f9fe541@intel.com>
Date: Thu, 14 Aug 2025 15:01:16 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 32/32] x86,fs/resctrl: Update Documentation for package
 events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-33-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-33-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0080.namprd04.prod.outlook.com
 (2603:10b6:303:6b::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF2F7FC4EE6:EE_
X-MS-Office365-Filtering-Correlation-Id: 7dc84837-bbb6-4a30-c76f-08dddb7e189b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZnEwYTU2QVBySjlKUFdvb0xPWEpKTmR1RWVWOExSdThoR2NCaVJ3V0dGNjZM?=
 =?utf-8?B?ays0NDYxRHg2bkRGK1pFTDZjOXRTWXJGSXErWkhqQ3pNOGxYWk0wRjVpSGov?=
 =?utf-8?B?RjdsbWlnWVMrazIvME9jMlpVRE1ZdVI3TGoxbEpsQ2hwVmh3NjhTalhJYjkr?=
 =?utf-8?B?RlNOQjk2Y2crWjVZdVB6WjdBUWZXWWZsai9JMkRmN3RrQ0pKUGc5UmFGWEl4?=
 =?utf-8?B?aUM2bko0ZkQ4dWZmTWFBVkRUay9QeDdLcytQMzkxTW4xcXZiVWg4clJTRHZv?=
 =?utf-8?B?RDNEREU3cXplNVNHL2JDaTVEUXY1SXZpeHJ0NHpZYjNJU2E5VVJkd3pKNVpj?=
 =?utf-8?B?SE41MW0yeXNSYm1SeGo1eDhjRk9kMDRBRms4c2Q5OUpRZyswZjBGSXBXT1JZ?=
 =?utf-8?B?WFBXcUlUZ09wVnZHa3UwTi9DVDNGcEZhYVRuODVkZStFU1FPS0dCSWtNOEsy?=
 =?utf-8?B?VXJsWVNMeFdQbjZTbFpkdG1zRS9pREJrRVljaWNodGRMdW9ibHZsUkdZWnc3?=
 =?utf-8?B?RWpsbnhwWnNnUGc1QWVKS1liczErMis3RHJTZXF3T2ZTWEhYWDF2anIxVU5m?=
 =?utf-8?B?ZmZyeWdiOS9ZVDQrR1kxMTR3ajhTS3ZPVkFxaFh6c2pJeGJoTm9PZ2FxRFg4?=
 =?utf-8?B?c2hIS3R6RVpNZ2xkc3NkSG8vdUlrMm9LaGJLSjN4eVovbld0S0NkcVFza1kw?=
 =?utf-8?B?cmlUekRXUyszVmw3dEM3d2NwTHovejkyaUVnU0Y1ZFhyQlREaXZaN0xCOHdh?=
 =?utf-8?B?RE1CS3dYQmQxWFJ0aEtGYmNUUzRCZlZMK1hGeENxZlFkZjNXRkphclpQVlhw?=
 =?utf-8?B?V0hDamlLZEtaWGFqbHlPd0YzVCs0eG9scHJoT3dXdkQ1a0dGZnluYTZMbWFZ?=
 =?utf-8?B?ZElCcjZVb3pydVpleHBQelNpRXpvWkVnWERraTZINHBMQnRkZEYxd0V6L3NX?=
 =?utf-8?B?dmt1enNFbEplMXloeXFsdVBjd1JiQW1oNmkxUEJLeFVSdjhrZ0djL1g3VFlK?=
 =?utf-8?B?Ky9JcVEvMEs5OXJjejlIUzVrU29NQ0RCTGs3QUNiWDJ5YkZsckw5Um8vbmpR?=
 =?utf-8?B?T0Rkckc4RW5DY3Q3Qkp5Q0RsbTBRTzJWeTV1OWF5S1R0QUxUVWZYQ2V2V3o2?=
 =?utf-8?B?UGFWRzBUUXM4aHRhd0g5QzVZdTBlbHlBR2FhYm8wYzR3R0lWQUlPci8zcjVp?=
 =?utf-8?B?VjdpZzhlcEZWZ2ozTHpnWW5GY29VYU9RbWc4eUhRSTNHdk5JRkZjUkdBbUxU?=
 =?utf-8?B?V0NCNi9kUmFhMTdoMFNuVWl0SzFSM1pJRXNqelcrVjJFSUxrOXpYckJIcmNs?=
 =?utf-8?B?QWM4dmxObWxJUDRnd0FibTNsb0w5dytSNnBLUnArMDNCRW9OZDRJd1MyamIw?=
 =?utf-8?B?Q1pia0NMd0s4T09SMHEwVmM1UkxPSks5clFaeFBBQ21qYTlDQzBYVDl5anZT?=
 =?utf-8?B?bUtRV3BWeVV0K3hiWXVXRTJnLzhFbHpkTVR1R0JPZ3Y3V2E5UVowZGd6bnRk?=
 =?utf-8?B?WTdJRzJiOUZwY0RXbnM3Y0svQmt2eit4ejgyUjVmVVZUeFNSK01DbFRCaGwx?=
 =?utf-8?B?MktZZlhHTjVzUjVwUUhveGFmUDRqSjR0UjNKRE1kNzhpeGRCaXpnR1dKZEdF?=
 =?utf-8?B?cm5Gc3MyN3BGeTB4RVoxTE5DMWN3YnVZdVFVTE5nTlVGcnplTmZKU2NycGVO?=
 =?utf-8?B?MHI5UnNMb0lUWjBhQndlRDk0Mm9tc3JNclhtWUpWT2U1czVpeWp4TG9CMk02?=
 =?utf-8?B?cmsvU2F2VXI2L0k1cWVyYVVLRzBJNWt1N0l0Y2JRN05WTFdkeG44ald1R28x?=
 =?utf-8?B?aW0xVi9TbHhnTkd3SGVXWXl0aGx1RWxVeGY2bEZRVXVTa0k4OHUrYjhmWWJ4?=
 =?utf-8?B?cXg3TC9pYWtNSEdmbFp3czVCS1RpeEc0VXEwbzdNWUphSVNzVGxPQytUV0kr?=
 =?utf-8?Q?nIuqnsgXghU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MGxoYVhtQjd0ZEp4d1hEMEpUNFR4MEpaT3cyOEJpbnVQcU15RGFnZm85L2Rs?=
 =?utf-8?B?SW1uTkUzWmkzcTV0dkpraDBQVkJwVU5PcERCU3NwaWx3RmlXS3psSVZkcHl0?=
 =?utf-8?B?L0UrNE1OYTZLNUljd2cwaVJYLzN0T2M0N3NBN2VuZHNVeEdwNE4wQ0dkZmlY?=
 =?utf-8?B?ZHJQa3Fsbkdvb05xY2k1ZW5ZUHArTE92VGhNd0Jhb29uUmJUdVhlY09ESDdp?=
 =?utf-8?B?cmlBWFZORWsxbGRYaXZQaW81TENwQS9CVTJuTUdMSEJtN2lOSllkTzVORWdZ?=
 =?utf-8?B?a1JnQVpvUmcvR09pdThEcmhyMFlMZG9RbU42NEZkTXBUU1BMb2IvcWNSVHJL?=
 =?utf-8?B?eU1zSzU2T2tDb0xySjErYTFtdG95ZXBvaUdGNUZtUGJVN2lhbVNQSXBkLzUr?=
 =?utf-8?B?MmhsUWswZWVIUHNJQTBUL3JxMnB5eUdUWUJwQTNnaDA0VWJBOHpTR1VQa3Fn?=
 =?utf-8?B?MEtoZ1pTcnZqalR1UHRxazB2RzVONVREZkJrYUZZamJWa2ZCUWt1UlB3ZDg0?=
 =?utf-8?B?RU95ZGJzUzNlV0RRR1BJa1hTeGx1STczT3c0a3h3ZlEyUkRRQW1Eekl4UlJ2?=
 =?utf-8?B?eFBid3NqUGVURCtnY1RTK25HV1V6d25rREVDTE1ycldWdTF2c05XdUtMcW1y?=
 =?utf-8?B?d0tidFU1eUo3UXVaVzNucm4wYmNLMEp2SEs2Nm5xK0U4SUhwdC9ScWFFeGpp?=
 =?utf-8?B?amVUZk44OHBSR2xZaHdoaVEvMG95TExDN2pVcFNQR1dZVGNNTVl3UUpteGo4?=
 =?utf-8?B?c25EaHNGWjZjRzlZRWEwMlJVeUdlcEkvaFViYlBJRGQxeHNCVEJOajlmMXFD?=
 =?utf-8?B?Zk1POEZ6TW1GZktWT2VEV0JQeDJ6Y2NYTDl3QkZwaDVRQ1NDLytCSHJnN0hG?=
 =?utf-8?B?enllS2doMTdZbW9jaDlNM1ZTTlZLZ09UVmYxUXJaanpWdWJXK3k0dGdTQTN1?=
 =?utf-8?B?OVRVNWZPUFJvR1RtOTh2UHZaZ1hNU09TYnhOTnJNMURnd2lYOTRkL2h0Tm5R?=
 =?utf-8?B?RkpJeTgwU3I4Y1NDNHN1OTB0alE5ZkN6Y2ZTK2pQMGhZTXBQT2dnQ25YVlEw?=
 =?utf-8?B?dVRDTmpzWEh3ekRFZGpqMWQrTitOQ1Brb2Z6UzJEc0wrVDNFOTlaR2xPbjJT?=
 =?utf-8?B?SVdTMUovNUEzWHRYZFFqd0NSVnlEMlhyb3JWTWxjUWloUklYTC83TEg0ZTRN?=
 =?utf-8?B?Wkx1NWZ3YjlGUHhXSm5NK05IdE5LSlhncHBab0VBeGJWZHpKRzBNaFJ1UHZD?=
 =?utf-8?B?Z1dldnE2U0VGdWtGR2tDTDAwTjlvWlZPM3ZtNWNrSlptNVpMMElOMFBpdGhN?=
 =?utf-8?B?TUlhZmFsZk1kZEd3blUyV3RCYVBBN1B2a2UwMjVZOHE4Z3hucTlZV2ZSUlA4?=
 =?utf-8?B?TnROa0xWVStRdThNVktqMkNGQjNXMDFkUHhTenJZczdvbzlUcWVubktRbm9Y?=
 =?utf-8?B?NWEwOWlycVZ3aGJPQlB5MnRWWDY2R3hYM1k0Q1BXWHRSd3lqbGV3QXcrd1VW?=
 =?utf-8?B?cEx6V3MwVnFuZmF5RWE1R1IydUo5NXlMdDNCMDEvZ2g4R2lINENXRmVEWldJ?=
 =?utf-8?B?clBTeXZqSlFTalNvL0d3ZjIwYktZYmFvaDE0M2Y5V3NpaGJNRDFzb0M2Nk5Q?=
 =?utf-8?B?ZjRXWTBZR1pmam83WWFrelJ5UEFVTWcxck1aK1VyenZnaklBRHhDWmxmcGkr?=
 =?utf-8?B?UkFtM0tuWXVIS1dHbzRJeEZNUlh4MHRNYmE4dlU4eGl4Uk0yaW1hUURCOGI5?=
 =?utf-8?B?aXBsdy80ZHFVUVpXZDI3OHcvN0pETytKdjhaL0VOckFuMjJvOXY2NC9hR0Nh?=
 =?utf-8?B?RU0wemxvaUlJOTBRVGxzR0E0WXgrNnZyRnVBbzZHZlFQYkZ5aHpkUFRKbitv?=
 =?utf-8?B?aUprd2hRRW1iMmxtbVdhV3oyY1I3bTZNbzJJMkozOGFEdFc2L1NIRkZxbnlJ?=
 =?utf-8?B?d1htV2Rxb0NLcU00TERJNk5iNktPRGZQRFVSMXhnRFUvaWlHb1Q2ckZrZlZa?=
 =?utf-8?B?dlk3S2d4VVZmWFFlcllFdFdzako2MGRRNThjdXlNbVlpUnNwaXg1QXpCNERV?=
 =?utf-8?B?dEZpQk5wZm5XSFpuaDZPb0xNOGlNZ1JaQStnNGpTK3NyeHV2RSszRVpFVUpq?=
 =?utf-8?B?dTAyckI4V1dLUW1KRUZDSVB6OFVEeUoyMjBsM2hycjgvZ3BVUTVleFphaTBR?=
 =?utf-8?B?amc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc84837-bbb6-4a30-c76f-08dddb7e189b
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 22:01:18.2792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIFPQhYXu6Px8awDr1jXHuwZKNxj02fwkzzJXQq28WQP5wbxhL9zG9gxZbi5/SB9/78FCrSAV9wwH5PhlukxDF6nH71CCyFiKV64Wz0KYFw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF2F7FC4EE6
X-OriginatorOrg: intel.com

Hi Tony,

subject: "Documentation" -> "documentation"

On 8/11/25 11:17 AM, Tony Luck wrote:
> Each "mon_data" directory is now divided between L3 events and package
> events.
> 
> The "info/PERF_PKG_MON" directory contains parameters for perf events.

This changelog seems to be an incomplete and cryptic summary of the resctrl
interface changes made in this series. If the goal is to document the
new interfaces then please add a summary of these interfaces. Alternatively this
changelog may also be ok to be succinct like:
	"Update resctrl filesystem documentation with the details about the
	 resctrl files that support telemetry events."

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  Documentation/filesystems/resctrl.rst | 85 +++++++++++++++++++++++----
>  1 file changed, 75 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
> index c7949dd44f2f..065f9fdd8f95 100644
> --- a/Documentation/filesystems/resctrl.rst
> +++ b/Documentation/filesystems/resctrl.rst
> @@ -167,7 +167,7 @@ with respect to allocation:
>  			bandwidth percentages are directly applied to
>  			the threads running on the core
>  
> -If RDT monitoring is available there will be an "L3_MON" directory
> +If L3 monitoring is available there will be an "L3_MON" directory
>  with the following files:
>  
>  "num_rmids":

I expect that L3_MON's num_rmids also needs an update since it no longer
dictates the upper bound on for how many "CTRL_MON" + "MON" groups can be created.

> @@ -261,6 +261,18 @@ with the following files:
>  		bytes) at which a previously used LLC_occupancy
>  		counter can be considered for re-use.
>  
> +If telemetry monitoring is available there will be an "PERF_PKG_MON" directory
> +with the following files:
> +
> +"num_rmids":
> +		The number of telemetry RMIDs supported. If this is different
> +		from the number reported in the L3_MON directory the limit
> +		on the number of "CTRL_MON" + "MON" directories is the
> +		minimum of the values.
> +
> +"mon_features":
> +		Lists the telemetry monitoring events that are enabled on this system.
> +
>  Finally, in the top level of the "info" directory there is a file
>  named "last_cmd_status". This is reset with every "command" issued
>  via the file system (making new directories or writing to any of the
> @@ -366,15 +378,36 @@ When control is enabled all CTRL_MON groups will also contain:
>  When monitoring is enabled all MON groups will also contain:
>  
>  "mon_data":
> -	This contains a set of files organized by L3 domain and by
> -	RDT event. E.g. on a system with two L3 domains there will
> -	be subdirectories "mon_L3_00" and "mon_L3_01".	Each of these
> -	directories have one file per event (e.g. "llc_occupancy",
> -	"mbm_total_bytes", and "mbm_local_bytes"). In a MON group these
> -	files provide a read out of the current value of the event for
> -	all tasks in the group. In CTRL_MON groups these files provide
> -	the sum for all tasks in the CTRL_MON group and all tasks in
> -	MON groups. Please see example section for more details on usage.
> +	This contains a set of directories, one for each instance
> +	of an L3 cache, or of a processor package. The L3 cache

A monitor group may have directories for L3 cache *and* processor packages, right?

> +	directories are named "mon_L3_00", "mon_L3_01" etc. The
> +	package directories "mon_PERF_PKG_00", "mon_PERF_PKG_01" etc.
> +
> +	Within each directory there is one file per event. In
> +	the L3 directories: "llc_occupancy", "mbm_total_bytes",
> +	and "mbm_local_bytes". In the PERF_PKG directories: "core_energy",
> +	"activity", etc.

I do not think this should be hardcoded as expected events. The original text
was careful to use "e.g" when mentioning the L3 events while new text seems to
make all three events as fact. I wonder if it may not be easier to read if
this refers to the resource's mon_features file to know which events can be
expected to be present and then the mon_features section is where all the intricate
details of events are documented. Compare with the L3 mon_features section.

> +
> +	"core_energy" reports a floating point number for the energy
> +	(in Joules) used by CPUs for each RMID.
> +
> +	"activity" also reports a floating point value (in Farads).
> +	This provides an estimate of work done independent of the
> +	frequency that the CPUs used for execution.
> +
> +	Note that these two counters only measure energy/activity
> +	in the "core" of the CPU (arithmetic units, TLB, L1 and L2
> +	caches, etc.). They do not include L3 cache, memory, I/O
> +	devices etc.
> +
> +	All other events report decimal integer values.
> +
> +	In a MON group these files provide a read out of the current
> +	value of the event for all tasks in the group. In CTRL_MON groups
> +	these files provide the sum for all tasks in the CTRL_MON group
> +	and all tasks in MON groups. Please see example section for more
> +	details on usage.
> +
>  	On systems with Sub-NUMA Cluster (SNC) enabled there are extra
>  	directories for each node (located within the "mon_L3_XX" directory
>  	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> @@ -1300,6 +1333,38 @@ Example with C::
>      resctrl_release_lock(fd);
>    }
>  
> +Debugfs
> +=======
> +In addition to the use of debugfs for tracing of pseudo-locking
> +performance, architecture code may create debugfs directories
> +associated with monitoring features for a specific resource.
> +
> +The full pathname for these is in the form:
> +
> +    /sys/kernel/debug/resctrl/info/{resource_name}_MON/{arch}/
> +
> +The prescence, names, and format of these files will vary

prescence -> presence 

Just to keep options open I would rather have this say "may vary"

> +between architectures even if the same resource is present.
> +
> +PERF_PKG_MON/x86_64
> +-------------------
> +Three files are present per telemetry aggregator instance
> +that show when and how often the hardware has failed to
> +collect and accumulate data from the CPUs.
> +
> +agg_data_loss_count:
> +	This counts the number of times that this aggregator
> +	failed to accumulate a counter value supplied by a CPU.
> +
> +agg_data_loss_timestamp:
> +	This is a "timestamp" from a free running 25MHz uncore
> +	timer indicating when the most recent data loss occurred.
> +
> +last_update_timestamp:
> +	Another 25MHz timestamp indicating when the
> +	most recent counter update was successfully applied.

Same comment wrt missing "agg" prefix.

> +
> +
>  Examples for RDT Monitoring along with allocation usage
>  =======================================================
>  Reading monitored data

Reinette
