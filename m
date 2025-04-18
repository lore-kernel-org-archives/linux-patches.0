Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006DC25334F
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 22:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745016850; cv=fail; b=Vx96286nVmj2C31NPNtYHfxhLKQ0ixdu51hxXGvsj1y3CIvTM9wTleu7X5SEwKJHbZJkhWl0Ou2/aAgUwzpdQNb6RZU2f0geRCffhGDdYvYhEz5s/9ptTwYKY4WWjtFSxWQLa/JBcdEcGk1Ibx3Q65iVnC4QaNcdX3TcUCmYdH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745016850; c=relaxed/simple;
	bh=7cWe7XvYjQ9j/cDKlGwsrepgHrIp2QgcqxEtATTR6+o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C/4hhUAlJc5q9SonkBcKS8EBupkHsRzFNDe2K4Eyoj3ZoSN/D+GDAGiqOUpwTMrEDZ5+8rHqyHEfTpwq6OFS2KWPpYPOTi/GaG7P6go13wtUjNm6drhubA/0D6h1Ql2vfB68TDaWMa5sEERCml6vHZt04mWKGl7YurNXltXyp9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nsGx5XIL; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nsGx5XIL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745016848; x=1776552848;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=7cWe7XvYjQ9j/cDKlGwsrepgHrIp2QgcqxEtATTR6+o=;
  b=nsGx5XILqRofvr/LoOntYTjzctfbP8fJy9jFcSrSERD7KhH8aL080ogm
   b6drIkHvWsg209HSOCbaYhumcStsoDrU35vtyDsUoDpGyJDf2mFfw/8pU
   6wKtAWq0nXQUXpw4CkYQldMjz6PiwaO9hFhPFBdjhUtdON4LWeOIOdjg6
   pbESRSMM2IOtjXaJm+NhUqO2ymbpnMzAHNnBJA9hjmeRf0Fjkr2SOr2zC
   LbL0NPOKjVifa3VZmQqThXnZMM0qdmzNDrV+cJx/71EuHJjPQDtWgeiDO
   EgA1F5BpAapOBS29fDZUv6kDK948syov4zaDpCBsIrwytyHQXGZUpUl5D
   g==;
X-CSE-ConnectionGUID: BofOJpxtQSGzRNM8AuwSnA==
X-CSE-MsgGUID: /pNPinCsQkmTwT8w6BrLlw==
X-IronPort-AV: E=McAfee;i="6700,10204,11407"; a="46570417"
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="46570417"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 15:54:07 -0700
X-CSE-ConnectionGUID: KkX8MAcOTQ6/1gstUzwc0Q==
X-CSE-MsgGUID: I75e0xZxTjW93R/FrgTN0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,222,1739865600"; 
   d="scan'208";a="132114873"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Apr 2025 15:54:07 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 18 Apr 2025 15:54:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 18 Apr 2025 15:54:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 18 Apr 2025 15:54:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rg2vz+oEZ2aP5oUyzGsFQWTJPEy7f9Q4T4g2gKbYEKTKPvRPnZdtSNwqcWhUu6GBXMJVPe3+LwzyA3NWbXQAKex5HYMw4dUuE/MM7k8N0ic8fHfA46K2Un0QGZi6loqpEq3bOEVE5E5w0gZb6J518I02RPcp3eykVaYrvQd4wRFkzEwmIhiPhNlhbdIbjAYiSe++huGya8XxvtkoFHoCn4It3WJScBzL5hSB8tKaMWt5E62kNEr9H53VjHA5ljCqgLOJuM0OqHv68XrNyBLOhk4CRerLuSyRrTIQPT0zhHuYTOeJQV8N8Fx9Ph22Ye3v1ZvrRZyTJA8R2u3WQsysPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jauHQNmUQeP2hY+pdFI14DlNtQv8aIEd4OmMzS4L01I=;
 b=FZBk1o23emuYicZVA3FeEmxHsQHZ1jGiWVMpBvxPZJ/LH0URMznq74dq1FLBqtbXHG5yBmnMw7NdRhCNcUe8GObd4IzC0G08Yq2nXlDadZk6xBxtmlcEJhv/6YWVFCLMd1klb0D0l1XvCDp5uYiZF0458UzPbjlLZAWZbsAwCjyBHp7DlOjU4P8AhxEiqTRs1CWNrrf9cx35JcPtqGUOJKfW1D4keNYz1/arAYrn/NRHYaxqYCAbpHz2xxNhk4WkhOIJm/0JPb2/oZ1K8fK5VAkiU9vGZrlEZDcAkEuyQKY4dkfJrlDH3uNmZgclA7SRwUr+GzvdmCoHYjCMMoJfZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ5PPF16CC3A048.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::814) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.31; Fri, 18 Apr
 2025 22:54:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8632.030; Fri, 18 Apr 2025
 22:54:04 +0000
Message-ID: <da51ba61-4ff0-4db4-a55f-743f6a3ea7da@intel.com>
Date: Fri, 18 Apr 2025 15:54:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/26] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250407234032.241215-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0290.namprd03.prod.outlook.com
 (2603:10b6:303:b5::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ5PPF16CC3A048:EE_
X-MS-Office365-Filtering-Correlation-Id: 7df8cf97-1e10-40de-94c5-08dd7ecbeaa9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZGR3My83Q1NIVGdFak1OUytPenNtSzFadHNjWW9qRnpDVGNkTFo4UTVJUmYx?=
 =?utf-8?B?N1daWU9CbXFHL0JXNkNkaVErNVF4NXdpQmd1aytMeTVIWHF2ZE1HeHhyN3U2?=
 =?utf-8?B?WTlTVkgxRTBRZHlmK2ZWVnREdUZXNm50MWM0Z08xV2RYM3A4UHRPcDFkcnVO?=
 =?utf-8?B?TVJJblRZUFpIUDhob3prUmRzZXlTcmpDM3k2ekJEZ1V3bVQrTHpZeStHWGxS?=
 =?utf-8?B?RGE2SUxOeDcyc2lvMVpTSWp5R0FTcklzazN0L043a0RuNCs2NDdUNExkWTNP?=
 =?utf-8?B?NmlxcTh4NlM3STNpQ2ovUm03OUoyNnVrM1l6ZXh6Q1BsR0RxSEZPMW10aUZn?=
 =?utf-8?B?YTdCK1RuTm9MMEdSeGpqak80M05Yc2UreWZ1RW9JdFFSWXA3a1N0Q29JRk10?=
 =?utf-8?B?U2VYQ08xQWpnZXA0eExhVWZjMk1SYjI0UUlNaEhEdGR3OEk3ZzVmWHFhUDBK?=
 =?utf-8?B?VmFYYlBDdVgvL2ZqdFpnQmllaHpGNU5NaHRqL0Uwc3VwNUNEVHRzYVhocWpi?=
 =?utf-8?B?dkt0a0o2bmxOVVZ1U3cyclduRXpOZmlmazlMb3ZtcGdRdmU5OVgzVm5IQk9U?=
 =?utf-8?B?Y09vL0VSTXg2Zy9hMjJVdDVZVmQ2UFhmMjZtUlRuc280eXhqYi80SHVqWSt4?=
 =?utf-8?B?ZDhaWHlnQjhGbjNGVTRGU3dKd0s3Mm00RDBHdjlsbmUzSVNaMmwyWm9KWWJN?=
 =?utf-8?B?TktVSThpdmh5ZWRWM1BHOUpScXFUUlgzRjNCY3l3THV6VXpiUkZVS1ZwWUNK?=
 =?utf-8?B?Z2FDcDNuejk0S0tMRjJaU3lRZE5FUHZLckxRMWdnalZ5dGdES2MrV3NwRFVp?=
 =?utf-8?B?T215dnI1WEhBKzZrZktUcG9sdys3YUlOV3NBckFHeGFQSndCanlSSHk2SXp6?=
 =?utf-8?B?Z1locXhQSUlld244TW9lYnpYdnQwQUdxM0puYUtJSWJPTXgyTEtQNXlNc0Zw?=
 =?utf-8?B?VjVJT1dpSHRGb3ZVSEg2bHRIa1A2bVE2YkNOQ3o0bzhJMUdaUFErcmRWdHpB?=
 =?utf-8?B?TjhwNy9QWktSaEpsdEwwc0dyRXc4L3dHZEw3VlJpU0t5b0dJcUt2NWpjOC9w?=
 =?utf-8?B?bDUyakFjeU9DcFlPRjQ5a20wa3NzZGt0TnNyL256Q2tpTWFDb0t0cTYyMlhi?=
 =?utf-8?B?b2lud0tQQkNxZUljRUJsMEQrYUg1RlpleUNucTliRFZNemNlRXhOdVdNL0ZT?=
 =?utf-8?B?QUVYc0Z3bTNNQVpmQ2NCeXc2QW5tOGZ6b0VSMEsvQW5vMU1DN0VNck9WZnpq?=
 =?utf-8?B?TkRVZDZ1OFh3cGh3dnp3MU9iNlZaNGdLbXVJNUlpcGQxSDUydnpnamhVRzBp?=
 =?utf-8?B?RHNkbGFkSlR3ZHZ0Uy95bGVPc0M0SDUzdXEyMzVrVmw1VFFOT2dzVyt5Z2Vw?=
 =?utf-8?B?eXY3MDA5eDYxcUQvMjZKNnhwa2daUXdXa2FRdkY3dnpBbjk0d1V1NFpZOWtI?=
 =?utf-8?B?Mjcyb0hMRFdRZXp4L3NYcnM3c2JFZXJoQU5BL011M0MvOUNQcldBVDA0VGpK?=
 =?utf-8?B?bTJNU3JCSS9jMzhmU0I0aVlXR2ZzbDhhQmFaYnpXUTQ2K0d4ZXhMZU5uOVdr?=
 =?utf-8?B?K2hpUzQrcGdBRmpyVlY4aFluNXpYNXdvbGg3WStJem9TSjBJK29GM2lUUWVS?=
 =?utf-8?B?ejVVNGV0QlBaN1I2bDVUU3RWajFrVjVWM0F1dnZCbExWVE13R1dTOXYydUo3?=
 =?utf-8?B?eSt0amllMmRXYk5uRTZEU3lFSFZKT3VqZWhkd0IreG43alhFbUVRcFh2aHk3?=
 =?utf-8?B?dmxNODVDQUo0bWp5VWY5MlZZTFcvRUJGbWRBd3dmTjVBUnJYQ2U2YnBkY1dQ?=
 =?utf-8?B?NjlVeHZzbGVKZ0dIdVJwZ3ZscWsvY2ZoaFdGKy9zaWd2S1Q5U3ZPSSsxSG1t?=
 =?utf-8?B?R0RWeDFpem9JZ2xkVTBONlNYNGhEUG51N1B6c0VDVmpCMmxpMzNvZTEzaG44?=
 =?utf-8?Q?w9vWa7vdCJI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2FZSFBac21UOC9GVmZoSkNFLzUxY2NLV1Znamg2MDA4QWxOZENqcHFRZDNQ?=
 =?utf-8?B?K2NYZ0QzdEFjYW1JNXFYOUJYaXZlS0RJYi9yZ3VBSzRrV2pzM1ZBaUV4QVNB?=
 =?utf-8?B?d1hPbVFDUzNaOVV2dFdHWUx4RWFnTXJmM3hpcjFSWGpSRTdLbnY0dVN1N1ps?=
 =?utf-8?B?emxqc3dHNUk5YzJvZlZxc0l4Q3YrSTNKazNaVFhjb2k2MTk1cDdJSEV5L0RL?=
 =?utf-8?B?ellZbFk4eE13dkpQS3BaWDI2UGlsa2V6Nk1IblI0MmFhUzErK0FpazMySmZn?=
 =?utf-8?B?VGNsa0E0K2t2SjgySUlSQmhibHNlMzBmSS9xWFgzNXNDVVhYdDZib1pHY3oy?=
 =?utf-8?B?S0NJa3dDZHVvUDljb250aDNNM1RUNkFPYXhzRVU1UFJxdVFpbnZOSWkzOTha?=
 =?utf-8?B?MUxhWDB5SVVibVdUdUlnZEZSRjc1aGhOelJZRW9uemJyVTViaVUwKzI0QjN3?=
 =?utf-8?B?R25QaGl2NXZJazlFUTNramFsSW1JYjVQSTl5Vk5qenBITTB3MVNMQmFtTi84?=
 =?utf-8?B?NUxUNEFvOTdJT2JnM3hKdlNuN1AvclVrVUNEa3ZXT1JqRE5LMExXc0s3Tkdm?=
 =?utf-8?B?ZmZlTUdKQjFJVDNrZXZYaFRRdjJVOEdTYUhvSEg2a1cyN3hFSzdtQW9KdDRZ?=
 =?utf-8?B?Q3lFWE96VHVzTmc3VWFBV0tneDVXbUhCdENzQjY2SzM1MEFqUWtTRjBCNVMv?=
 =?utf-8?B?bFY0eCtvN2svSnhpRVFBSHhGTmRFeTFEcjdmTUx3SWFaeUJmRFVzSWgra2U0?=
 =?utf-8?B?TmhqVjh1RHdlWDlQbHN3M214WjBGeUNFeERVZC9XU2Y5VFpTYXJKZUFTWm5Y?=
 =?utf-8?B?TkozazdlRGZWUTdTRkFTRzBiNXBpR0xQVnNmdWpYSXFsakdHRjZFeEJxaXVG?=
 =?utf-8?B?WTlDWHg0M244TGx1ODFmSHFEMVRkN3lYTlJuQWZqaW92RlIzYThvM3dSeWNB?=
 =?utf-8?B?YWpmdW15cWpjZHdIdnZ3cHFtODcyaWJLOS9kVzBGNXlWMVJ6RzdtVHRmYTJZ?=
 =?utf-8?B?ZXpLUHNsb1l3aUlpVm1NdVFGY3JDeEFIWnBLc0lQcTZ1Z1ZBQkxpbVAxSGN0?=
 =?utf-8?B?SndhcGo5cDRiaE5FOWdtd2c5QkRueFdZakhEemhLM243cU9WclJINGpId3ZO?=
 =?utf-8?B?ZldXMDRURm5La3V1MEdXcmkxTEpRbnBrRnBGWlU3SUFiMzhVOWN6a3lIYklF?=
 =?utf-8?B?dUJESVp6RXYzTnEvUUl3TFVxMFZYNWdOcHhTMUZvNmtvNUxMcXZJSUhUN0RH?=
 =?utf-8?B?RmdKRmp3SXA4WWMxa280QVh5eVhYNFZxTU9CSDVWVkZjWHNMbDE5V3FaSUhO?=
 =?utf-8?B?R3ZxLzMyMm9QK0lhNVlOYmdrMmJ6eVVrOElFRjQ0dHFzb0ZYZ0ViMm9EaENE?=
 =?utf-8?B?N2YyRGloaVlDQ3ZvbWFFaVZRb1RMRStGM0dJbzA4alNUL2VpS1lMRmN6aC8x?=
 =?utf-8?B?MEhlYW9veGFJeGdiU0FhSlRNUTcxbDAwMXJMK09wMEJSaXRvUmlBR21sRFVl?=
 =?utf-8?B?ZjNySzZ4UzNwU3lRTWJGaEduekVLMmFOendlZEM1OHYyMDRVMjFWMFBETWxP?=
 =?utf-8?B?V25DVExhcGwySjNNSHBDeWdjODQ2YURySVNwc0dMb3B2eCtOWVpQdlNzZUI1?=
 =?utf-8?B?cVk2T3lRZWl2b2JrQWNlSkV5akw0ZStXRUs0L2tSWnVHaFF6Y3Q5RkYxcmRE?=
 =?utf-8?B?ZEFQWWh6b01yMWlTcmRHZUZZLzhBeitDVStQckdEQW8wMGpSYVgzNmFNNzFz?=
 =?utf-8?B?YjBsVWh1TXJwbXd3aTNUZnN1Mm1yQ0Rmd2I3TFBEZERXRUI5VEhYVUEyMmhh?=
 =?utf-8?B?SzF5VnBxUVliZXZPa2ZSZDJpclV1VW5hWG10RVVNemxMV1BTU2lkblEyMnI4?=
 =?utf-8?B?am40VU56UUtMQTNDOXFNeFZTcnZqV216RllLOTVnRTdMSXl1RXRyZ2FYREJ1?=
 =?utf-8?B?YzBkUXFWSDh4NkVFbEJOYm1YdVh5czlGejZmN2xTUDJzOElWeithTTZEaU1U?=
 =?utf-8?B?WGJjUWZZdU9zaWI3Y0plWDlEWU5WUkJ3dnFPTWhNVmgrSkllWCtvNEtqM2hv?=
 =?utf-8?B?RjJhNzNYbkFIL0ZMc21BeDcyYzdEZHZSNFl3ZUtHKzJWYnlqbFRmVFR2UWI5?=
 =?utf-8?B?dWNLZU5jTTJxbXlQV25NYWZSMnJhRW40K0daZHJLZVVaYnVtR05yT1VSVVpK?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df8cf97-1e10-40de-94c5-08dd7ecbeaa9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2025 22:54:03.9180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ua03uiiwxTEL8SshjCeLSqJGx6sjPeHaAyKNJCybZVZcj7ZjGPYFJdAJTgN/m52pZSU2BvICYOQ33WYoFQgWmOsKaSOY00Vfgg1hEbdIFZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF16CC3A048
X-OriginatorOrg: intel.com

Hi Tony,

On 4/7/25 4:40 PM, Tony Luck wrote:
> Add a flag to each instance of struct mon_event to indicate that there
> is no need for cross-processor interrupts to read this event from a CPU
> in a specific rdt_mon_domain.
> 
> The flag is copied to struct mon_data for ease of access when a user
Copy the flag ...

> reads an event file invoking rdtgroup_mondata_show().
> 
> Copied again into struct rmid_read in mon_event_read() for use by
> sanity checks in  __mon_event_count().
> 
> When the flag is set allow choice from cpu_online_mask. This makes the
> smp_call*() functions default to the current CPU.

Please use imperative tone.

> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  fs/resctrl/internal.h    |  8 +++++++-
>  fs/resctrl/ctrlmondata.c | 10 +++++++---
>  fs/resctrl/monitor.c     |  4 ++--
>  fs/resctrl/rdtgroup.c    |  1 +
>  4 files changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
> index 08dbf89939ac..74a77794364d 100644
> --- a/fs/resctrl/internal.h
> +++ b/fs/resctrl/internal.h
> @@ -72,6 +72,7 @@ static inline struct rdt_fs_context *rdt_fc2context(struct fs_context *fc)
>   * @evtid:		event id
>   * @name:		name of the event
>   * @configurable:	true if the event is configurable
> + * @any_cpu:		true if this event can be read from any CPU
>   * @list:		entry in &rdt_resource->evt_list
>   */
>  struct mon_evt {
> @@ -79,6 +80,7 @@ struct mon_evt {
>  	enum resctrl_res_level	rid;
>  	char			*name;
>  	bool			configurable;
> +	bool			any_cpu;
>  	struct list_head	list;
>  };
>  
> @@ -93,6 +95,7 @@ struct mon_evt {
>   *                   the event file belongs. When @sum is one this
>   *                   is the id of the L3 cache that all domains to be
>   *                   summed share.
> + * @any_cpu:         true if this event can be read from any CPU
>   *
>   * Stored in the kernfs kn->priv field, readers and writers must hold
>   * rdtgroup_mutex.
> @@ -103,6 +106,7 @@ struct mon_data {
>  	enum resctrl_event_id evtid;
>  	unsigned int sum;
>  	unsigned int domid;
> +	bool any_cpu;
>  };
>  
>  /**
> @@ -115,6 +119,7 @@ struct mon_data {
>   *	   domains in @r sharing L3 @ci.id
>   * @evtid: Which monitor event to read.
>   * @first: Initialize MBM counter when true.
> + * @any_cpu: When true read can be executed on any CPU.
>   * @ci:    Cacheinfo for L3. Only set when @d is NULL. Used when summing domains.
>   * @err:   Error encountered when reading counter.
>   * @val:   Returned value of event counter. If @rgrp is a parent resource group,
> @@ -129,6 +134,7 @@ struct rmid_read {
>  	struct rdt_mon_domain	*d;
>  	enum resctrl_event_id	evtid;
>  	bool			first;
> +	bool			any_cpu;
>  	struct cacheinfo	*ci;
>  	int			err;
>  	u64			val;

Duplicating the same property across three structures does not look right. It looks to
me that struct mon_evt should be the "source of truth" for any event and that
these other structures can point to it instead of copying the data?

> @@ -358,7 +364,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg);
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> -		    cpumask_t *cpumask, int evtid, int first);
> +		    const cpumask_t *cpumask, int evtid, int first);
>  
>  int resctrl_mon_resource_init(void);
>  
> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 0c245af0ff42..cd77960657f0 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -525,7 +525,7 @@ struct rdt_domain_hdr *resctrl_find_domain(struct list_head *h, int id,
>  
>  void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> -		    cpumask_t *cpumask, int evtid, int first)
> +		    const cpumask_t *cpumask, int evtid, int first)
>  {
>  	int cpu;
>  
> @@ -571,6 +571,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	u32 resid, evtid, domid;
>  	struct rdtgroup *rdtgrp;
>  	struct rdt_resource *r;
> +	const cpumask_t *mask;
>  	struct mon_data *md;
>  	int ret = 0;
>  
> @@ -589,6 +590,7 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  	resid = md->rid;
>  	domid = md->domid;
>  	evtid = md->evtid;
> +	rr.any_cpu = md->any_cpu;
>  	r = resctrl_arch_get_resource(resid);
>  
>  	if (md->sum) {
> @@ -601,8 +603,9 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  		list_for_each_entry(d, &r->mon_domains, hdr.list) {
>  			if (d->ci->id == domid) {
>  				rr.ci = d->ci;
> +				mask = md->any_cpu ? cpu_online_mask : &d->ci->shared_cpu_map;
>  				mon_event_read(&rr, r, NULL, rdtgrp,
> -					       &d->ci->shared_cpu_map, evtid, false);
> +					       mask, evtid, false);
>  				goto checkresult;
>  			}
>  		}
> @@ -619,7 +622,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>  			goto out;
>  		}
>  		d = container_of(hdr, struct rdt_mon_domain, hdr);
> -		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
> +		mask = md->any_cpu ? cpu_online_mask : &d->hdr.cpu_mask;
> +		mon_event_read(&rr, r, d, rdtgrp, mask, evtid, false);

I do not think this accomplishes the goal of this patch. Looking at mon_event_read() it calls
cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU) before any of the smp_*() calls.

	cpumask_any_housekeeping()
	{
		...
		if (exclude_cpu == RESCTRL_PICK_ANY_CPU)
			cpu = cpumask_any(mask);
		...
	}

cpumask_any() is just cpumask_first() so it will pick the first CPU in the
online mask that may not be the current CPU.

fwiw ... there are some optimizations planned in this area that I have not yet studied:
https://lore.kernel.org/lkml/20250407153856.133093-1-yury.norov@gmail.com/

Reinette


