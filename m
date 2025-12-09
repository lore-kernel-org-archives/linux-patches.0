Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF92307494
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309123; cv=fail; b=gHmyn7vLbDONE0Cs0HdeYAvO2ebQRM/wZ4QMDnf4Bqc6ola25nfeARZrSP1Q/CPnQu8V8rQ5Dzt8m4gBnWKmfblOFyTnU7E4g+Bdpl8HDe+DnJwW4P+z2i2S2blzrE6GHWWSpdFI2sK3DclpBVxF4lXhSFXDN+yBhMQZKPJO69g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309123; c=relaxed/simple;
	bh=sS8eqBztzXFtkv3Nkls7f7LQD68HQFDOfmMyzdmxFTQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l91v4Il+xtPHmB0+5z6DOI8AMGf53S2iCEstlw3/Rjp2BUfpzg+h1KCayQwLlO7AWKCpTlOoS1x3WGYW8zPtb/UEr+NzGevnkaDLq9NqvWmgya4EAGGlQ3RWkjJ1zceLvn3fp5HibkrDqdVe+XiYAa8uXkFDY+srgwsWsLdkPlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MW1sbL2w; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MW1sbL2w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309123; x=1796845123;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sS8eqBztzXFtkv3Nkls7f7LQD68HQFDOfmMyzdmxFTQ=;
  b=MW1sbL2wIOYDXlajQUyrFvkI/hMJN3Xro7feuMjn8ws/E7YNX4zvDCr8
   8eyb6UYYtifC33nWDeqPT7GQyrWuNbNf/s3/QO+7YinA/iUNN7UnFEC2t
   0yd69gbc6KpMhsi+zNEreQmbQTBrROoBLSb5ImWwLMJcEJ77hi6APbtcR
   VC6AQlLHWwE6XFhjwDJk0S+VO66QbCWwPKFOCjOV6lzF9W1v0w0ElWa7v
   9cFefOqyDKnL+FUerg8S+gFmejsf4RSEbGBFzTpb5zPjgO7iCcAv6JEP0
   VCJGn/BEJvMwcAlwa4gF2BvhR6GG8Nf+Kwm6Tf0j0KpgB+mcgejF9Ro1u
   Q==;
X-CSE-ConnectionGUID: b1rjTFiqSI6Bl/YLokNYPg==
X-CSE-MsgGUID: AEaA7u6ET8+xfG0YQY8hsA==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="84880344"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="84880344"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:38:42 -0800
X-CSE-ConnectionGUID: GGQs4ZjmQ5W2tv7CvYKiag==
X-CSE-MsgGUID: AI/J5ET9QIiX0xdmG2qLHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="195386500"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:38:42 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:38:41 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:38:41 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.12) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:38:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYd1OxLOFNB1fHawPdVWmwfmGfAQAUbypm/z2wM16dAaByPXtjgk5bRYUAJ2M0/6/E2iaBfhl9AUNWeLrAeVJiaBaNIToojW4VWHRZ0EX7VSA7yjSSFR1C51g4dvpHOPjiREk25g9HVDCr+UEeQfmnULVAbrbG/HU779a6VQNI1NjuZlp0TkaWYsXJ36N1d2trjDAjBtZIEhAD1w15WrJJopKxCCEAIngqp8AyFy6cuyGQYbHEeLdHnoKH25f24PNCnoNe/0LNjJkEZmCx28tl/rOaBHS/5NbH6OTCYd/qaguOy8AxBIEIiySL/+oHjRzjxB11bjEf1y3eCdqv12uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dbrc3rbs86sIcutmpFb0QaIAk29SyhewSeAwti3MRus=;
 b=Ai1/3gjPUDBqU/n8sbv0Ju3tuOUlX/ZVU+aYaJHYsM35zCLfJ0+wrdORY+JQtn+WSu7IJ4b2yuSFtdwshRjpUHK0Y4TxAHX0plbMLJb2UgTR7oAkUv5roJGMhkNWL4HPtomwEv9D/7B6BoCwHJX4yL4pe4bCxxHMqeEm0HTe4ul4dFG4gXxKF6Tkq/g2ZS9D1+8rXPcdM2VkXj9BSiYiju358WAynATU+WnBuq+HdA1i1y2+gy8KTwdXteE7W0AmanFGO2700snnxIItEKTXZkbv0HkTb9lvdJhhCH4K77IlpgL96VckGCGxfde4rsnL46msDhFBNfpEqJMp9nkUKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW6PR11MB8409.namprd11.prod.outlook.com (2603:10b6:303:24c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 19:38:38 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:38:38 +0000
Message-ID: <25daf5f9-a646-4d06-a62e-a88995b90035@intel.com>
Date: Tue, 9 Dec 2025 11:38:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 08/32] x86,fs/resctrl: Rename struct rdt_mon_domain
 and rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0240.namprd03.prod.outlook.com
 (2603:10b6:303:b9::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW6PR11MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: a3959f4c-155d-4f84-6130-08de375a8c92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eG14WWlkaGZsaytrYk15U0h5V2E3Mm1mWjIyeS9MdmVEQVJwOWR3cyswMXFE?=
 =?utf-8?B?Y3lFcFhBbE0yYXJRQXVHRTNHZ1NqZElTdmFuRkljVjRvRmxBWmViSUU2S3U3?=
 =?utf-8?B?Uml0ZG1pajZyMDBxTGQ2R01TdU9vMDFGS0tYTVNEZGFuZWxtREZ5U0RNd2hq?=
 =?utf-8?B?ZjFsL25kcDgrSTB4a05LZk1RQklURmZPVHgwUWt4THVDRm5yQUlna0dRRzlj?=
 =?utf-8?B?UDM1cko3V0NQbmdPYkkzVU5vdFNQRlJ3cWtDa0pnMjY4Q0Z2NWxVWDUvSDJl?=
 =?utf-8?B?WGZiUmxNMzM3ZXRPa1VBN28zQmthRE9WSXlMdkNhc0R3QnB0VGhsRng3bjhq?=
 =?utf-8?B?WTdPelJJeEFiZDhGUEtGVjJoRysxZGJPalZrcTMxWVlMYUlSc2xwa0JaQkFy?=
 =?utf-8?B?c2k3NjhtblRMaFIraUpFSVZkakYycHF0bS9SWit3aVMxUWtoMHR6WTlkWUxu?=
 =?utf-8?B?enAzU3hZbTdmTER6UDhxK0FHaHB4bVljYkF1VVZWSDZxcHErS2p3b042THJ4?=
 =?utf-8?B?QWhGQUxFQW13d2lSdkhTVndoamM3VmlqNWMwcUJ0bmUyUUdnR3lhbWFneDUw?=
 =?utf-8?B?dG5JU2Q0WXlMOUQ2c1d5THEvTEdrcGM5RVFsbmMvZ2xia1FFekloQzFCL2Ex?=
 =?utf-8?B?TzNzRUxIOVJ6RWU4cDVVSjBKdXhES3ZLU25HWjBqVy9GS0lHd0J1dFNoYUVa?=
 =?utf-8?B?MkpsMjYwNnZCYWpxRS9pUXhackR2VCsrWWdRVmlqNThSaTJMQy95Wkhla1lL?=
 =?utf-8?B?Ym5qK1dPZjltSEVUUmY1K2NVSHg3VG1ybTQzeXlUaDJwTUZkcU8vQ09hUmFN?=
 =?utf-8?B?clFDTUhpazNNWUxtRzVvVzBWUU0vTG5Td0hZTi85bkZyZjc3cDNES1plNE9j?=
 =?utf-8?B?VmxRZDh4UFI5YUpoOEYwWm9RTGJ3VU5BVkp6dFM0WWsrVm9ja01rWGM2cERD?=
 =?utf-8?B?Ym5VcnZJbHQwcEJYYVlUUEQxRmRPR2Q2cFpuYnFUSXYva0h3cWYzeCszem9O?=
 =?utf-8?B?bng5d05nWEhiT3lSckFYY3R3Q3VCVHU2STBUSnBPRjgwclczelQrc0dkalUz?=
 =?utf-8?B?b05Ldm1JNExCTmdrSFp1ZkhXd0JaK3ovQloyRmo0amcxU3ZuaEtCdFJ2akpQ?=
 =?utf-8?B?ZStvWEZZbjhwWG1mZUhsMkZkQWJVM3FxYU5kVlVBQWMvQk5kWmRRdFFtY1BM?=
 =?utf-8?B?RWVFd2c4WnFnUDZlbnljcEtkWVVHOCtNamQyRFhJeEpDNVpHTEZ4L0tTM0Z5?=
 =?utf-8?B?UmpQR1IxVGhzUjR6ZERqOHNMNlhqeW55N01DdXJPZlY4cG9DU1U4dUxYUU4r?=
 =?utf-8?B?ZXZqZlNyd2VER1FYVG1GbEhmR1Z4QUJoQmpVUEt2V2RSNkpjeGRLSnVSdXd6?=
 =?utf-8?B?RnZ4OWxIOE9TV1ZKSGp4eDBQTm1yVWNod0N4bEtKSHdhOHhEclliaGc1eUI4?=
 =?utf-8?B?TzkzV3B6dkxoVHFibXZocFNGU0FQL29pZmUwNDRhL3NIMzhpNkNCRWc3dEJv?=
 =?utf-8?B?NlhVZ2hhMDJ1ZFRCK1hSeE5Nem05SzFNald6YkZ1WVhtZWx6bmc5clNRSkNZ?=
 =?utf-8?B?dzNvQ0hEcTJrWTFJNnMyY1NlbnFWTGZOOEN2S29Jd0pWNExiK0R6SlFEUCtj?=
 =?utf-8?B?NUV4VXk2emg5WS85Z3NXYTMyM0FoZk4yd2RjTVhQUitCbnA0QzlSK1VhSEpQ?=
 =?utf-8?B?SXM2QmljRytxSDU2cWZRR1Z4SEtmUXB4cE1IMEtRTm0wdGhzSnppNXVSdFRE?=
 =?utf-8?B?elRuVGN3bmVtSk9HVU9IVGpHajdDSG1xOG9QLzdVems2OW90bjlSL2wyaCs3?=
 =?utf-8?B?d2Y5ZHNnK0J6STRFWi9tVG9vSCtBK1QvSkJrcVU5dmlreVNyOTNpNE1GQ0Nw?=
 =?utf-8?B?ekMrTGNvOW95MXRud05kYWdPM2tIZlBpM3hvZDZCK1BoNnlDeDFHOE5YdFRI?=
 =?utf-8?Q?ton33tUUbgTXYRXkvqlVsibuVY1BiJi2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?em0yUnJwM2ZCdDlLRHFIYUFSTElJZ3FSTHozTjBnTitTNlZIVHZ6LzFPWHpJ?=
 =?utf-8?B?NTVhTDg1Q3RVRlpBTllEMmkyWUpxNFZKNGVGY0J6dTFuRlViL2ZON3pQUnBJ?=
 =?utf-8?B?M3pxdy9KN3lscmNZTXJIZHNHOWlFT3lEOW5OT2xMSnRlNHFwbW5CQ1dKQ2w0?=
 =?utf-8?B?bkZjSlZPRFpyU2RPQnphQ3FmZzd5UDI0NFlBRWdBMllwSmZlMk5FYnhRWmY4?=
 =?utf-8?B?ekw5UVFlM2JnS2NPNzNOK25kbjJQbmRFYURyYmFkOFYwVkpvVkZJSUd4YU5H?=
 =?utf-8?B?TU0xd0hYNEpRZVpxdHZpcE1pSHhpYXJYd2FxcTAxUmJkZVhVTWMwY3NqLy9w?=
 =?utf-8?B?UGg3TGJEeFpzYi9mTVpnQk11NFhONTFCeE1SNTZDZkNlbWV0TWhMZktvOVpN?=
 =?utf-8?B?OGplajFSVUJqS0N0SFFaQ0trTkg5UDVkWSsyVkxybVlqOGJrWTA5WjdGZENK?=
 =?utf-8?B?cjZuNVJxMGVxa3NyVnNuNXN5VTBkdkovUDY0MEk3QWlQWUNrNUtVc2NSMEkv?=
 =?utf-8?B?MXdBNW8yVTloakI1YnduR3lNeGovVzV3UXdnbmkzQnpSQ2VKVHM1NFRVU0F4?=
 =?utf-8?B?WksyZE5wOWljVXlEdE5hVzRodlNjTFA5bGdIL1I3aGRFenNRbDNZQ2RobU1G?=
 =?utf-8?B?VUV3eG13cGFYb0ZqZHhlL1UvVVNTN0c4Y0prU2VkSnh3aFlwbkFhRWpwQnlh?=
 =?utf-8?B?UTFBTGxQZ0ltQllxeWRvWkZHMlJ0ZG5zbVphMVdOOHhnMFFNRVhEMEFITEpM?=
 =?utf-8?B?K2hUSlZKT3hJRzhhS01RcnZzUHpVazVkWFBGRDZNZkJBcHBTdWZYTXJ4R0RO?=
 =?utf-8?B?UlNVSGx6UHlRcmY5dnZkRFRiU1NqaHdxTTZoRExCLzBZQjlabmtCTVJManA3?=
 =?utf-8?B?M0xqVkU4aWFLejQ5d2Z0SnVraWIwVDkxR1pWanY5WDBnbHlVeXZyd0lYYUFP?=
 =?utf-8?B?MUlESFI2eU45Yk1VSG1DOURudVA4MktEbWNIRzBWdFI1a2g3clg2ZHY5aUNB?=
 =?utf-8?B?L3R0M25DeVpsampZaE5IdGpobXNXSDgyQ09pQ3A5Qjh0QUJDUnQ3UGVxVjI2?=
 =?utf-8?B?dk9qalMvMnJGQ2laZkdoc2p6K1ZqRHJZMHl3bHkwWHhSYVpsSW1SNVNkdlRJ?=
 =?utf-8?B?eDkwTVJ3aVFEd24xQzRZWjNvT29DL3dlcnZwQmFhWDd2MFBUbkdIZTdWeXN5?=
 =?utf-8?B?cHVaTVhDaVZtdXE0b3FhWlVFSWFUY2dUd25scWdSYlJhYzJnUnNXYzFhenQr?=
 =?utf-8?B?dCswRkxLMm1JaWNjc1pQbkNha2tJR0NuNGJEbUR4TSthc3FqNkVGeFkyV0tu?=
 =?utf-8?B?MHN5NDNvUENSa0RLUkhmTk0vNFFOUGVyckRNM1VBY3hQNGpnVHUzU09xSzc3?=
 =?utf-8?B?NGxGZGMvUWFkOURQYm9vRXVDZUZSaEl2UUFoNDJBS2FEaUhlcW8waitmNGU3?=
 =?utf-8?B?QUt4OXZ5aDEvc3VzbWdxdGsxN3lBaEZnOUxBeXZLNytIZ0prSzhvVWlrR0JQ?=
 =?utf-8?B?MkdBa0pLamdCU25OTDFvM2xleU14bnozQWV2TDBHT0paKzFGVS9idEFsMVlJ?=
 =?utf-8?B?Y1dEVC8zcTVXdlFsZ0dQYkF5SUFIZTBCdkVyS1RRa3J5ZnRGaVRacThTT0gr?=
 =?utf-8?B?cUs0NU5XUXZZUFFnbWkvSnJWT3lJRUxzOUhFdXpnQzFSNUtxejFUK2NTWEtw?=
 =?utf-8?B?ZkRlU01nc2FHVnBBYVAyM1dld2Zob24xUWpLNXNQVjdSQTRLUWpvRHlDTFFj?=
 =?utf-8?B?dm16Sk5LZ2ZUeEd6QXNxVkZDNDVpTlUyVnBFZ0JOdlZtVlRLNW5GM3ZhWTZ0?=
 =?utf-8?B?dzJVZzZkMVZwL1hrQ1RSRmJmbnptRVZNSE44NzVrMTlDbzBrdWhZelloS0NV?=
 =?utf-8?B?cnA1M3p2VHQ0eTJPTE0xVnhpNzcva2dIRURxeHFOSlJueEUvQjlNNnlOa1Yr?=
 =?utf-8?B?N2ZPZ3p6MlBibGhkR3FqRitpRlpJcVAvZWxJWTcxT3c2V2d0MTBPZkxNMk1I?=
 =?utf-8?B?YTRZdnNJeDN1bEdPaVV6RWVsd29peFpOVjZEdEdpRk9yWjB4K1VpZGZXWVZr?=
 =?utf-8?B?SDFxQVdzdmhPNSt4NGgwdWZWd2lCcnJkb3RrWkQ2cXBrcytTM1hIaythR1pJ?=
 =?utf-8?B?b3p1NW0yRzFUbGl2Z1p5QndwSXFoQjV1bHM3SDl4anVwT0lydFVHUGFjK3VF?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a3959f4c-155d-4f84-6130-08de375a8c92
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:38:37.9976
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N8+YhxsIIbjeko9rPhKG5ufjp+5ANvUNFMkMBpmLpVlAibo/4VLPOByIrpsh0VW+unaCdYNoKrYQ97p2UVOKUkXPXvnA8YphNBrAv7zkyd0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8409
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> The upcoming telemetry event monitoring is not tied to the L3 resource and
> will have a new domain structure.
> 
> Rename the L3 resource specific domain data structures to include "l3_"
> in their names to avoid confusion between the different resource specific
> domain structures:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
