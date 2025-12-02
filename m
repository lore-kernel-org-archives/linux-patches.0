Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583D128727F
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691703; cv=fail; b=upd+H39D9j/MjyExhnY3R/JS7GAGQlS/sBaVud8VlLKn5MjjJNG5k+j2IafFlIIaKFqyS613ZpIGcE2pZSdkVTpe69tX4k59eYMfEITCT0uucA4smH0BJBkYZ/mGCtwWmyWmEAll5Z3TCe5vccm1kBL11SSpJj5s6f0zIqkpiwU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691703; c=relaxed/simple;
	bh=xuWG8xmGI0wqJoARlRIZZpdnifRlCKvhdtmP43FrOJM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C/WaHPLP7U36dwzbzRarI9HIO61BfS/vWh7zIwm6kSRNto8X5DTyUPS6PRbgsUd2mngtFcmHxz9z4kc1gJMEleoPXo/eUfUh9g5P1wYMxGHfkWIS9FLOJqd6Bk4JhOJsPLE5fXwcCIWRGIbcwT2Qa8VIYpNk0lbgD/Ug6hVC/BU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kM64Wvon; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kM64Wvon"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691703; x=1796227703;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xuWG8xmGI0wqJoARlRIZZpdnifRlCKvhdtmP43FrOJM=;
  b=kM64WvonLCvdyvyZVTQyB8ltX81CWlm6My5UCv0pn8DrTcnd8sAyqixq
   +/eg72KPLkPyIRRvy45eQg2z/yW3gsORl5JnAuYzjrxyxFgSIwpOG5G5l
   RbziLmx4GMT2Krpu5PmZFtLMIX4IfPBeeRpwmUxz1Dqse9cPIUwPSNV+u
   aN0rbgj0KeqbZot+5hVZRNaIdTsywgVO/SIUq3qWr9hByfdrdf+I/yxul
   g5p7HE64Yqcy8DiPWM1XAkiQfiZBx6T2YCcklveYirdD+tVqL339k5b31
   EinWRrVGOLPc76K4kVKZ/rb9W3D49p3uPmCzSHaJ7vgfRQSjUE/MP36XT
   w==;
X-CSE-ConnectionGUID: nSGJZT+OReWtYLxP3qrORQ==
X-CSE-MsgGUID: dzdBQwjYRdGvuEP0+MmooQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66621581"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66621581"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:08:22 -0800
X-CSE-ConnectionGUID: qd5NoMtjR6mQGEjZLbjEDg==
X-CSE-MsgGUID: oXnyom6eTvCT8Rksf1N1VA==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:08:21 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:08:21 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:08:21 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:08:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eIgxPeg2JgUEHue7kRFV6InEAq6JI36o/R+kylM2ez3nAxO28NSzDF8g4e4JZyOdyKF4c9JP04Fv5QVIDf02+GKBoapunFycmPFwxBMoLpwWxeI8/g+VlYqbdFYdolVO6Sa65ybI39A782R6+Uoxh8Jm/Z9qL77r0WLQV+HijaFMi1oCp1acK3QTcIKc2B8U9Wp4/RUB9rzeiY5IwgD/4mJaKB773Tfj8Oh2jeB/IQsUuJaJcFgVFFC6w5ESdv0IetY4D4cgYcGvk041j8r+0DX1AZlTliFK3sEmSiqEKKR5E3odbLMKAqb44fnBU/vRY6Oc9ZUwkOdpGJLOCzS8Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=97A7nGbuxiDt5LyVA0AOrpp2Tu9pQTiDPDKa0O6pZ2M=;
 b=csB9Ig5HW+H+DMwBtpGWUpN5VQEdJuzDAyHsaWL3y3KgnYqfR5bc/tEWPv9bGCi0MKbKYD1HvicfnzEKGPJ8MzXc7sLI/ZC8fIrxp+e8hoyRnkmWlXPXb+vAHt9mJVJsombWqbmcH4fn25NWCMPyqqa9j+Jo4MWFjbR6YoETmmq8tUDNLDzR7NuJVxsjM26TbTupKJYD1igNjzpRy7qKNDYKRQYEOJAqQ/lrz8uSih/GxeUGgoDW+y270QP/CxB3/UxyAqRqJdHU7BW95lJlrvg8QI7p9qaWE3fnMybq+n3JetAoftvG8l2MzkNaZpVjiHT5pjdr4fbP+EmrNDX7SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5251.namprd11.prod.outlook.com (2603:10b6:610:e2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:08:19 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:08:18 +0000
Message-ID: <58de0828-05f0-468d-840c-af2c0be04d2f@intel.com>
Date: Tue, 2 Dec 2025 08:08:16 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-12-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251124185412.24155-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:303:83::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: 55d7cd53-3ba9-4efc-28ea-08de31bd01d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Zmp0V3l0NGNJampZdjYvUlJPRWloY0xGUEFTSm1TVlFja0lNVG5iQWY5ZzBD?=
 =?utf-8?B?UWRqcHQ0dXQxZ0NPZ0tYalZjQmJXdHRISEtLMHpJa3NOWU5aK0w0YWRGVDZq?=
 =?utf-8?B?aXplenhDYWJFMzJFQ1BoQ3IyeEhzUHRWYll5UFVsTkNOQ2hib09NU1N0a3Fl?=
 =?utf-8?B?NXY4ZFBObm5GU1dyNFk1dnJ6ZFlEZWR0cFM0S2xwOEJtWFhxWlVmT2pnSSto?=
 =?utf-8?B?TXd3NjhQVDRDK3daaHQyRm1VUVJMZWhTTnpxT2I4OXU0UStZN2VJelpUb0lS?=
 =?utf-8?B?SHUvck50TXZLdlFjQm80S29tbjhMTjc3cTNDaDJYdkV4Z1IvbFFGdm9pTmZ2?=
 =?utf-8?B?SFZpWFhUZzZmUGJpd1VwK25NbnI2R3d0L1FBZktEU2JnaC91WXVUbDhnTEFP?=
 =?utf-8?B?LysyVTBzVTlxNkdXaGR6RE91bERYaGNhVGxvOVFXRzhnczVVMU1mR1pyK0hi?=
 =?utf-8?B?T0VLSm9ERjV1TWpoYSs5YmdiUG0xVkl3MXRsSjgxT3RyNzdQRUdBbWJ0VzZT?=
 =?utf-8?B?TlhzZEFrYnFFUXNKeWlwRkFEOVNtZzFocDhleGVzRG14UGJtZWVaTDJTN2NB?=
 =?utf-8?B?TDU2bEZpMHhaQlNBVVdkNDhPeEp3V2VBNEFoQkU2UnUrbnJVd2lhZVVRUDlB?=
 =?utf-8?B?bEhIZkw4R2NQRzlkVms1aU14cVpSQVlUaWpGbjI2aXRabUEyME5OR3lDWHNn?=
 =?utf-8?B?T1hpSzFBRmlrSTFmOW4vVVVrNjFadmdwMC9GYUFYTndNaWcvaml6V2hVSWFC?=
 =?utf-8?B?TURvMUdzbDJEbHUyRkI5N1NYdGx2azczUi9pZDRjdXBPUkdmWnYzdCtSZVJn?=
 =?utf-8?B?SWQxeDYzR3FMVUdVT1c5OHkzVFY5cjdPTWxFRE03Z3pZbHc1bHBSeG5EczVM?=
 =?utf-8?B?bk1WTzAvRFNnYnFjcTd1Rldta1gzbHFvcmlia0E5SEtCR0lhdzQ4ai9VSmtN?=
 =?utf-8?B?cW41eVJ2S2daaUhJWGxhWjJuZG5JTTRKQzdSNFh4VDRkbW1FMnRIS2RGY2xL?=
 =?utf-8?B?aTIyYzZPWithKy92STFGbG1BUVMrclR2c1llZzlmaWVTZHZxYk1mNGdtRzBX?=
 =?utf-8?B?UWxLcFUwN21OVFNyWlJabWk5aVpMSlVYYmZSWlh3MmdyeUROSzEwMmozc0dq?=
 =?utf-8?B?Sm12N1FJK2ZQV3h5NWFXUERRYWVBUThSakdPTCtobXVoaXJTVVo0MUk5WEF3?=
 =?utf-8?B?cDUwOTJoVmZHZ0tqbDdtODdKcmdSd2ZMajVtUmFDQjh0TWZDR21CT2FaalJn?=
 =?utf-8?B?UG9PS0RCQ2hHaVorV1NwZTkwa0doYUx5YXRXbUxZd0tIamMyRjVIU1FaVEgr?=
 =?utf-8?B?MEUvZWg4SnBONjR0Ky9LaGFZTWl1bVlyR1N3cDl0bWNBdkx5UHRGTmhvMm42?=
 =?utf-8?B?U3ZwUmlLeTBjN0llci9kcEM2WmxheE0zNWpFc05acXZpa1Yxck93UFVrem5i?=
 =?utf-8?B?S1lkNzR3ajNhQUNjNkV3amc2bi80aWRRR0szNzM1MzVIV05EZCtFK0NIaG55?=
 =?utf-8?B?L1Z0dEUyQnM3S1ZxZW1XZ0ExUGtSUi94UXpPOFk1VndZZno3N2dUVE5CSVpB?=
 =?utf-8?B?YUExaFJBZzNDZ3g5TFo4TnR2cHpWUTVscnlnVXIzVDZ3SGgybkZoQkYrcGRX?=
 =?utf-8?B?eDVPcFBtTHhnaXlvTWJBSUowUC91OTNEcndjYzhMV2wwUTMzREU0MndhcFZU?=
 =?utf-8?B?OG9IQ1RCeitSbnVLZEFCa2EzT3U2N0NZVjBjQlNvclcyNG5qQkhqM0x6TFF6?=
 =?utf-8?B?bjI0K0x0UFR6N0FCUENkeEdHZXEvSElob0pSOHpPRG13MkJsVHNVaWtVTHMw?=
 =?utf-8?B?N1VwWEtYajhPS3dyOFpHb20ycW9rM2xEMXhqSEdKQkRnQ0Nod2k1SFUxVnVQ?=
 =?utf-8?B?eHEzV2pPSnQ1ZHIyQlYzR0w4MGI5bmkyOEswUk51NDJ2WFhLMGxsTFoxMEZ0?=
 =?utf-8?B?c3Fxc1Q3d0ZjZTlSRTY2UU9nNXZyQUpxT1NhOHJjdGtnUDgxVXVOVk16RHBx?=
 =?utf-8?B?UVZtRzlMdUF3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZC85YkpQUlhGcEY0MlRhd202di9TQUZtVUxMM0s2SS95S3Y3YzNJTEtVV1lu?=
 =?utf-8?B?VW54YldPR3RWdGxaTi81VTEzdSs5eVdtZTNDQzAwZkNlZDRBWWVoZUdFNytB?=
 =?utf-8?B?S0RsSE55dnMrdUNBaTRJUkp4TTlhNjdQaTAvMlRYOS8rNENjdWlmdXk0R3JB?=
 =?utf-8?B?dTVmYklYNzRQWE03NmE3dVA1QjdEcURBUllMTnJ5ZEM0amgwblpTUi9UdkRj?=
 =?utf-8?B?VndoNTBBRk4xOU01MzIzT2F4OS80UXRtMFFnYXEvYkQzRGtSeUk5YW9Gckd6?=
 =?utf-8?B?RFBYbktuWmxmV0dQRTBKa3o1eVJ5RTNScllNWm5VK3FIWXA3MENnN01hM0Fj?=
 =?utf-8?B?K0lpK0ZuODl0QXlVWHBvZmxKdkFxNERVRGYrOElrNWd1U1FTcy9mM3BBS2dt?=
 =?utf-8?B?MDdYcGJDMEd0SUxmMHh2YWxwZ2wwNm1XNmhaL2JUWEtadk9Ca2tVRmpMUGlw?=
 =?utf-8?B?WkM0NDRoblo5S3Znak01OE5nOEh1Mi9YSlpzc3EydFkwMXhuQ0w5cjN2Y1ZZ?=
 =?utf-8?B?STFITjFvTXJzL2REZ3RQckJ3dFNObnE2eUhBUHFjaXBVdFpvN1RFcHFvK3Y2?=
 =?utf-8?B?Z0w3VE05UDNMMENadVFhenc2S3g0NnhaS0dpUmNuRGduMDFGQ1dva2Z2c3pK?=
 =?utf-8?B?bjRyd0dseDlOdm84YWRZc0lWVFhLbHRtQXFuZWdMMUNlOWtjQ1R2aGVrVUp5?=
 =?utf-8?B?RGZ0WitXOWF4NjkrSzhLV2dXUWM4eG9FWVE1eGI0UnBQV2hmdzlzeVBRMlFG?=
 =?utf-8?B?S1B0RGxteE43eEp1SEd4cXQwTWRjeVJrRjBkOFlvb2Z4QnFvRG5aNDNlL1Vm?=
 =?utf-8?B?UUc4bHZ4TkIvdVBidVJVOFJzemdTeUlpay9ndkUvbGVMRmZPdldCRzRSUG53?=
 =?utf-8?B?NVFvdDVKVk0yT3dzNFhnNFJRSGE1TjF6U25oMVp3aFBrUGYrZ050M3pJcG95?=
 =?utf-8?B?YlBWVDR2M25rdzRkeU9rMkVhdzIyR0pJZFFVb1NISTAySXRzeWRwLzhlOG9V?=
 =?utf-8?B?WExNVWh0OE01WS9abkFSUTZxaS9OS0xWVi9HdWl2bXNtSDk3VDk5ZG11VS9T?=
 =?utf-8?B?T01YaTFOWW1tMGhSV0o4d3BEZU9kTCtEdm5Nc1hPRnU4b0xteUZpTGJOWXRm?=
 =?utf-8?B?b3ZaWFZoZURyQ2VySUV5RldrM1BhdHNiY3c4cEhOSjhYajJQL0ZGNkJFcStM?=
 =?utf-8?B?dFJCWEVKb0tMWGNFa0VDWWYyRWZpUXhRdi9HSjRXVEZOMlBZVFFCZ0R5ekhW?=
 =?utf-8?B?VDEzSitpNHczMndIcktzVDZ5eE1LbldOeWsvZENUQVhlaGUxcVRtVHAvQ2k1?=
 =?utf-8?B?WHV4MnpxWkZtT1FhQTl1dUQ2aVlXNXZzdkRFVjljem5NdE4yeGQxdkszSnlK?=
 =?utf-8?B?YWgzVDRCZS8rYnNDa3U2TStwcDZEaVd5MzdDaHJ0ZS9XbGFXdVgzRFF5UmdG?=
 =?utf-8?B?TUtCZWx3VkVPWVRaQW5YL1lEMHZYZFYxSGZUR2VwVG9YMFBLZVNXTStxbmIz?=
 =?utf-8?B?MDg1K0JIbCt4cnhYbVFYU2UvakNmMDZzR3FnaVlyZDV3dWdHbktmYzRsbVpV?=
 =?utf-8?B?QURiZ3Bvc0dyMk9qYlRrdGtVOGJNdWRQTHhHcHozSmFmYXdYb1FzcjdvK3ZZ?=
 =?utf-8?B?NTgrMHovdmdGWFFreTBnMEYvZm9VTEFZSEplYmgreXhQWDJYZ01VTVlkbURk?=
 =?utf-8?B?cUFzMHFnQ0FTS3U5TFJqNXZteFpBcDBZcXZSK3RTTVpRSURjTEZTWUlKK2x0?=
 =?utf-8?B?ZG16eXFZSHhBd0tLdnR5aEtEU2NPME53MGJwdzJCMi9PK1ptdE4zYnY4L3Bw?=
 =?utf-8?B?dEdQODIvN2F1UXgxa1dvRzZxaGNtWUxoZkhKYkgvK2dmNDZIVWttNVZwdlNn?=
 =?utf-8?B?R0kyQ0pvNmFzTTJERHZSNmUwTjVaNm5hb0t3ZDZyYnVOaG5SbHpRZURjUHR0?=
 =?utf-8?B?UnFZaWp2clpjSlNsVmkzK0JMN1YzL2NBdTc2RUdCOFJTWkpjc2pqZU8xNFlC?=
 =?utf-8?B?cXUvMmlwZWY0azBxMVhIbXpqenFtZzdwN2Fsdk0vbzhKajNRdnFyVlJDMG5G?=
 =?utf-8?B?Kzd4Ujh3dXo0NStVTWd3MUJDcjZ2anpXYXJtTTY4NFRTdEFiRWNKSk55dTNk?=
 =?utf-8?B?alNNSkp2dnZjSHptaG9VVDJiNWF2NEF2Mlh4bDZORTBBVUJJdnZWOU54SUFn?=
 =?utf-8?B?Q0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 55d7cd53-3ba9-4efc-28ea-08de31bd01d0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:08:18.4252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NrKGfge9BtW1Bv4UWyZT1DDNaHwUOQYDO5R8LGOfEagCQsmw+SOMzqxcewEVwfQooSnyCA9rjH4+8X9yLyDOAlGoewj0TxX6SAA6RvvL+H0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5251
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> resctrl assumes that monitor events can only be read from a CPU in the
> cpumask_t set of each domain.  This is true for x86 events accessed with an
> MSR interface, but may not be true for other access methods such as MMIO.
> 
> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> indicates there are no restrictions on which CPU can read that event.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Same comment as v13:
https://lore.kernel.org/lkml/49aaa6fc-b75e-4394-9abd-07a6b4a0822c@intel.com/

Reinette
