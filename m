Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8494307486
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309363; cv=fail; b=jQR2xR/TzF9VGIT3QrDnFoX+DVZnEvsq5RoppIkkoxyYOhQzyMK0jtCdIP+Fk958RwRG4WrrVuScx/v964dVI4ihP7C1f4X50GDMpHYIthoKg7tLdyBfP+FnqJjvgNxO/gsB2dzFGt0OeUsSYARFMqtF/vu/FRr1sPrfUKCg1Kg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309363; c=relaxed/simple;
	bh=XLiRCbC8M34U0QezoyHF2baZKvrALFtRhSLaiFxRvqU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UVoSvznoe33bpcXFasKKXaTwQNuAdSfj8YZKW0CSjyUs3cfNBZAQGvs1ze1FsGgsw2Cz2paUaiEN8Mu65Lkpe5Abw9QNP9m6mdRN58J/HQ0FBwHsiJAzCXrkB7oWagt1V2PdPX5dr1gGEioaYRrcUUptRmWIQd3exATAy6il6Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IhyQGU9f; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IhyQGU9f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309362; x=1796845362;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XLiRCbC8M34U0QezoyHF2baZKvrALFtRhSLaiFxRvqU=;
  b=IhyQGU9fHmlL6rIQ1dxVz2JTmx/ww2En+8xp5hjVSki7e6xMOvwIHIzi
   oU0qa3NKZjqc9PgGWYsMuMi2DMuYDS6Z8Lryr/m8dIyopdgSogHfz81Zb
   2zO2Ap9EmJw6HL9jf/aZOKogEUZudprSKefbV9XvhnEBNilogVg3140S/
   cOrbRtYToOGtNYCqClVlE0aka+C6LJKDaXAJzR5/EoqQDRPYgzPqOWjRf
   1AkfK4weIhKdSEFk8rDHPFwF8gVDzBwoaW5pU9HpqMjnA9KtlMrlSmkL4
   XD3C8WHYJT8R29e8z/TDUk0L1NnUFtX3aHorbtgRkUiryT5/94k0r49lm
   g==;
X-CSE-ConnectionGUID: 1QH21fkMQZaPrYIJehAjcw==
X-CSE-MsgGUID: khndlRiRROaCg7vIBsOlHQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="71138606"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="71138606"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:42:41 -0800
X-CSE-ConnectionGUID: vZFTeXZQT9+9UoDNImmj7A==
X-CSE-MsgGUID: Ah1ta+M8QsaSlzKETrDhTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="197090417"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:42:40 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:42:39 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:42:39 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.70) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:42:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnnmPScMoVE3h7+j4z2eBDAEfVssJ1ExA0kLuUksDykA3eqnHUY3NKkIwTfNbJ647KFSjJLJe4gkWXlWVeJ8skvNod2G0fwi329/HJcZU2eE1fLMgp7DwNsmMPPF4hkq8pRefsJR+ToyHVc2I9mOA0IZv4Ylj76NqTsZsI7o1W0hMgwis7IMLjmrfEdq3FONxBrvQ25ojJz38V80CRrl0SP3ShOjGKItMxHNEc61qD8+qqnmcNvDGPpURtyEu7w9GR7g4KH+Bgz8OQyhclU2wvcLu9JI9+qz9+H3KP/Hu9TBSPx7JFfAlqWP3Yf/v6xZRCq3m67g4IdtXu5ox3yqEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhsVKd3LE2VjrRAwUqQoJHG49xlcggnl8Tk7MSLZm1g=;
 b=tvbTWo0D0uBCjTF2WFQP0UIndnlTc9sHmPK+BFt+QQK9aA7Zlq5HzJQApAK+N51dIWUQOPerELgNLorQRufOvDFSYjAB0Go3zYedyMOc1O8s97eLESJV+VeWP7+Az3a5yrZ7p5HKeg0ytRsjoo9CQXgjnhBlfEKupZxn9y5JIkCdBh23rp3+kRz8WD8AknwBQr3wBpcr1zmpC0joHXB06HKar35q2TynmbGM5OTVAVXasYakGM9Phmc/fnwzAVKRL4cA3HTEAY66pIVVMBjcky9FJm41oLyYtUsmdhxDViFMcJ0ot56zVtMeCyF1ghf15T6N+SURC2DQBYj1++z+9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB8152.namprd11.prod.outlook.com (2603:10b6:208:446::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.6; Tue, 9 Dec
 2025 19:42:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:42:37 +0000
Message-ID: <48d4dcc5-ef3d-4952-b70b-c0868a37f074@intel.com>
Date: Tue, 9 Dec 2025 11:42:34 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-25-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::31) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB8152:EE_
X-MS-Office365-Filtering-Correlation-Id: 76fa2d76-748c-4eb5-36ba-08de375b1aee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VXhYRXh6eHRiS3laKzV3RjJZRjVneStrZmRmYWdLQTZ3VmFSQ1B1M0p5RUZ5?=
 =?utf-8?B?U0EvbEZRbjRnZDdoak0xOVVFdnBjY2xMRmtVQTBML1N5TThndm5vcWlaKzVl?=
 =?utf-8?B?MWMybDRacjlTVksxSjFoUnAyNVZIWWxUN3BkSWtNV0ZIQnFSaDJSL3dDT3M1?=
 =?utf-8?B?aXpFbnZrSEtzclR3OTAxT082ZWJ6cmFPVkYzOFNtdEcvak5mRXhORzV5ZDIz?=
 =?utf-8?B?SVU5d1g2WXRhbVp5a3Z2dENhVUpVd2ZHZmVuK212VDNoZHdkWDNHdUl3M0Ix?=
 =?utf-8?B?eVkzSUZ6bFdQcTFsd1p1c2tFMy9tVnF4Qnk4OTJxYWdTNms5TU1nU1dXTFNr?=
 =?utf-8?B?alBpdDA4eS9DY0htWWloemNpeEJDY0M0aThPcWcva3hVWHhGQ0pNamhVYTZx?=
 =?utf-8?B?V2tSVUk4cURqTjZrMS9GQzIybnVqbXZ3UnZSVklzVGlXaGtGSWlydkxaRTht?=
 =?utf-8?B?TkxuazY4NER1MzlUZTBLeDh2WGNmVzBHZGRDa0k5N2xoTlRjdTlpanZweEVD?=
 =?utf-8?B?NUU1UG1aUzU0TGxKNEcxMHo2dndSdXpqSEJBOEVrWGJnUlB1N3BOQ1hzUENI?=
 =?utf-8?B?Rk0zbVJQYlU3YWZLMHEwRFp2ekFVNUlKOUZNZnlmMEJJZUlPQmp4cmx1bGpD?=
 =?utf-8?B?Y1J1R1pzanRLZ3lkRWdBTGprRWxMb01YY1orU2xwakphTGNGNm85eXE5YVBD?=
 =?utf-8?B?eEpwOUZXVVZyOTRxQllMajdxeUY0dUw3MGx0UzRPcVVOeElDUUFhOWw3NVho?=
 =?utf-8?B?U284QTVRTjhJZnhFUVBiQVRmN2o1bW45aWhkMUJtdXFxNnBVcldmcnRRQUhn?=
 =?utf-8?B?cmNoTzMvRTZPR0tNNnVHTDlzUjJNalF4MUdGWXVDVTNyeXNVY2orRWRKNDd2?=
 =?utf-8?B?RWZZcHhHd2dQUHR1ZnVjUTdUQnJ0K3Q1TWtmTzJRSFFnU2lybkloa21sUDJy?=
 =?utf-8?B?Vk4zU1V4ckVUa21GRU1lUGgwNDJvbzhqQUJkYklyQ0R4THhza3NMZjRuNXl0?=
 =?utf-8?B?c2pjKzFJSWVPcDhMSC8reUJLdGZQODN1Z2t1blNJQ1MyanJIZWNGQnVtZTZo?=
 =?utf-8?B?R2pkeG52NVl2VFp5TkhEek5TY0krZGU3N0hZTDYzS2g0VWtSMVVQc0NEMjV4?=
 =?utf-8?B?QzhuZ1B3QkRtRXE5MjNOdnoxL1hWMVA2Q1hsazZibDRBMWNkY2pJck00dk5S?=
 =?utf-8?B?QTVrUEZlRkhiRmQ5cWRZKzVlaldCazM0UVRVOU4vM05RbERENXhQVHRPM2Yz?=
 =?utf-8?B?Y2pybWNsbGpFZHV3NVVWMTdvVWhRc3dTREIvVURQV1g0T3Q2T2x2c24xSVZy?=
 =?utf-8?B?ak1la2M1ZUxScE5VZko3WE4vWDNkcGY5ZDVxekZGSTZuVENBeGdENlBNZG1i?=
 =?utf-8?B?N0Z5NTlDRFl4WUJ2ajA5bDgyUEUyRURDaHVQd3VWNGc4cHJmK3MzbU8yb1Zp?=
 =?utf-8?B?TkxIaHVoWER2Y1FQalArQUJDdjlnWnRxaWZvV3FvMVZ3ZlVSODBjWGZlUE1u?=
 =?utf-8?B?dnZ5dzBpQ2IzZHVqWlQwV2FmN1I4RDl5RGpUWDIxMEJVY2V5cnFSR2Z2YVBa?=
 =?utf-8?B?MWhscmtPNTlraTBlWFdXK0VuOVZDTUhKUjJVSW4zMzB1SUhVWGZnSUFnNWxQ?=
 =?utf-8?B?M0RuR1JDNzh2Y0dhYitEV0FYUmdpQVZHdXVkRllGeGxzbUcycFllZkQ4bm85?=
 =?utf-8?B?OEEwRTZNU0N2dW1VaWZacFJHOGMyaG1RT1dqT1VBQitDU0cxM05mNVU5L0RC?=
 =?utf-8?B?NXlCSmVYZHptWnBGa0ZvRjJLb0tZZjh3eVR6YmtSODdlQlFqSXEzemdHWmVj?=
 =?utf-8?B?azJmQ1dibnI0VFdNRGpzbVNIR1NRU2RsMHM1WUVOMnJHM2drcFJaWVNlTWd6?=
 =?utf-8?B?OGVwY0p1S05lNmlNTFovVnN3UldOL2VFV0ZEYVNuSWMwT1Rrak95OHdPTXFS?=
 =?utf-8?Q?Bs944eQRtQHoSkVhNhDQca8w59TWkH8Z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YTl0dFROKzNhRVh1c0NQTjVqVDd3S2gvLzZ6dzZZelVLRFdVMjcrV0NKYUY5?=
 =?utf-8?B?cElHTzFsLzVEeGtRdUM4YVVua0xwcmlPTTFzTCszZmFmVVNWNkpHT3IwbUxp?=
 =?utf-8?B?SzI5RzBoS1M5Uk9HVDB5NGNaendhK0xHak5RdVNjbGp6dHZ4QU9hWFFvNnVP?=
 =?utf-8?B?ckUwRXY2V0dDS0pjL012L0toRUk5aE4rYlpndjZSMWFFZHJIUzA5dnBtU2lZ?=
 =?utf-8?B?d0Z2T2lUTkxCL0NnSGZDZTB0ZHVoWXRoQSthUzh6WWR3emhTREkwcGEwNUIz?=
 =?utf-8?B?ZFBuaGhJRXorWnFRcFZMcFhxVWhScGs2UEFWYmN3QUR3VStWcitXRy83ZXdS?=
 =?utf-8?B?UzZtVGhpblJmbTl4QjZ1Q3pEUDB4T3lXVXNPQ3VIdTdxeUlyZWVscjNKVHYw?=
 =?utf-8?B?Qm5TRzVvOThXc1J3azI0dTJxUWUvQWhydlRVeHZ5emdETW03ZkFkcXVrTVBj?=
 =?utf-8?B?RzJ3cC9lWk9OQldzSVg3eVB3SS9vOUhsYWE3b01QQmFQYVNDN1FwcUlwWHJk?=
 =?utf-8?B?bkxiV0RYQ2Qza2xsR05kbTNsYkgzSnQ3ZGlYaXI2bFMvSzlabkpwSmJjZ3Nj?=
 =?utf-8?B?NVVOV1hlN05UZEZxRXVOcEk4YW41Z3p1VGZIMHozRFVWNzgyVXpQdHZ5WjZo?=
 =?utf-8?B?eHRsLzBiUDNvcG44Z2pjVjUxeEh2TCtweFp1OTF2N2hxZk45RnZsT1h0MDM1?=
 =?utf-8?B?dEExMzRBZGZoc0Rwak9yeW0rUEZqMGdBRyt4ZTkyazFvdkVhSDc5WmdRT3N2?=
 =?utf-8?B?STk1MU9FM3J3elJwNC9VZjFFWkd6M0h1cmZLWWJMblU3cWZzWG1QN2F2dW5S?=
 =?utf-8?B?QVNhV2p4ZzQ1ek1CU25BMFZDNExvYjc2WDF4Q3FMNHlGRXJEU054QjNqTmdB?=
 =?utf-8?B?MWU4SnhaRHlzTWFrY1J1d2NYT0JJNnl3aGEzb3prSElnVFp5eVVOamYxS2h5?=
 =?utf-8?B?dGhjZ1dCKzJyVWRsSGZqVUZVL0pZNzRwNkpDQU15dUZIK0RxWDMyV2xvaXV4?=
 =?utf-8?B?cENsS2IwMVNSZXU2VUNrRHNKaVNzOC83ZzF2UnBnUXZUMythVCtCU0NTRGdD?=
 =?utf-8?B?ZmlXSWw0WVJVY3AzanU1L0Vxb2lFZERWZmQrcFJRMW43MjVZeU0vc3oxaEFw?=
 =?utf-8?B?K0MzSVlwYTFOWmUvc3lBa0NUb1g2eERzMm9wM0wzZk5JR3VXdmU0Y29YYVV4?=
 =?utf-8?B?bmlxckFLU3RPUlNCRUZ6Y0dpeE41Yk15bnFvZG4xeGhaUUVMYzRjUU9UZi9t?=
 =?utf-8?B?ZUsvQ2dQc3FhMUpNQ2ZZeXQ1VWRvUFVJUnZTTzkvNnhpUFU0Ky9hYlhDeE12?=
 =?utf-8?B?cHY2cHg3Rk5XbWVub0tHYXhObmdhT25wTjJGK2xESy9VdkVvM1A0WFF4ZExV?=
 =?utf-8?B?bzEwejlnbVp4TytVVGdBVU1oOFUzZy9DanhoQjRSNTVYeDFLV205TzlEcUIy?=
 =?utf-8?B?VFdVcXRIR1Bmd1ZETEpiK3licXA4Y3plOHVuc3U4bHJ3bnhFa2J5UUtjNVU2?=
 =?utf-8?B?SUdKMGFWamVqbEhaUXFYamlISkFxN0xkQXZZcUozTmVNejRqU05PL3Q5WkIv?=
 =?utf-8?B?eEw2cG1hN1JGbnZ4M1RzTUNodUNrOEszL0FmMUU4VDc3cDdmTnRDZkNDRWR3?=
 =?utf-8?B?OU1PMmNwU0J2ZnVyRWQ5N2RiMzJSTm00VUoxOG9MWFFyVk5oby9yUmV6NXhE?=
 =?utf-8?B?d1V0YWpJZVc1czhDZEVQVG9BR01lbmtkNmdBR3FESHBPNEhwZVBKeWdBYnpm?=
 =?utf-8?B?MXpEYkFJbmlBMVIzaGNlR3RNRSs5RzAvVjY2bC9RVFpyM2hIdEo3Ujh0Y2R2?=
 =?utf-8?B?TXNReHM1Z296WTc2bi9aVEVVa0dtcjRxWUtITk9tNzdlcENiYjlKdkQ4djRk?=
 =?utf-8?B?L3paa000c2FSenBtYjBFSmI5ejhiRkVoT3I1T0FYM1gvWmJoOEkveFJGWlQz?=
 =?utf-8?B?N09LazZ3UnhqdTVzVS9MNXBHQm5RMEVJeTBnaXIyNS82NjhRbTFER2ZLL3dj?=
 =?utf-8?B?c3p6QTV5ODRpRkFGWVRFZ0tiNm9RSkpnZFUxU3pab1dMUGs4d2xnZ2s0cE0z?=
 =?utf-8?B?VmN4QnBKblg0a0NVMXdNUk83Y0RHKzZmZVllaVRBb1RDd0RYY0R2Wk53RUNZ?=
 =?utf-8?B?WUJ5OUlJWUlncHNmOExqWW80dUR1U2pFL2FnSkw5T0REQk80c3dLL3drYVdm?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76fa2d76-748c-4eb5-36ba-08de375b1aee
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:42:36.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: er9UIGHT5q8vEHdoGpriJT6so+HuD8H8ttg//wv5vBr+TwB1XzXIYSFQxvVBfoQEDojKIeL38tTZrumWh+LILxdkC+VRi49H1LZf1CIDGvI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8152
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> Legacy resctrl features are enumerated by X86_FEATURE_* flags. These may be
> overridden by quirks to disable features in the case of errata.  Users can
> use kernel command line options to either disable a feature, or to force
> enable a feature that was disabled by a quirk.
> 
> A different approach is needed for hardware features that do not have an
> X86_FEATURE_* flag.
> 
> Update the parse loop of the "rdt=" boot option with a call to intel_aet_option()
> to handles "perf" and "energy" options. Prefixing an option with "!" force

"to handles" -> "to handle"? ... although ... "Update the parse loop ... with a call to
intel_aet_option()" just describes what can be seen from the patch. Could this instead
describe on higher level what this code accomplishes? Consider, for example:

	Update parsing of the "rdt=" boot parameter to call the telemetry driver       
	directly to handle new "perf" and "energy" options that controls activation
	of telemetry monitoring of the named type. By itself a "perf" or "energy" option
	controls the forced enabling or disabling (with ! prefix) of all event groups of
	the named type. A ":guid" suffix allows for fine grain control per event group. 

> disables a feature. A ":guid" suffix allows for fine grain control per-guid.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  7 +++-
>  arch/x86/kernel/cpu/resctrl/internal.h        |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c            |  2 ++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c       | 34 +++++++++++++++++++
>  4 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 2b465eab41a1..cc9d2800abeb 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -6217,9 +6217,14 @@
>  	rdt=		[HW,X86,RDT]
>  			Turn on/off individual RDT features. List is:
>  			cmt, mbmtotal, mbmlocal, l3cat, l3cdp, l2cat, l2cdp,
> -			mba, smba, bmec, abmc, sdciae.
> +			mba, smba, bmec, abmc, sdciae, energy[:guid],
> +			perf[:guid].
>  			E.g. to turn on cmt and turn off mba use:
>  				rdt=cmt,!mba
> +			To turn off all energy telemetry monitoring and ensure that
> +			perf telemetry monitoring associated with guid 0x12345
> +			is enabled use:
> +				rdt=!energy,perf:0x12345
>  
>  	reboot=		[KNL]
>  			Format (x86 or x86_64):
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 3b228b241fb2..df09091f7c6c 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -236,6 +236,7 @@ void __exit intel_aet_exit(void);
>  int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64 *val);
>  void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  				struct list_head *add_pos);
> +bool intel_aet_option(bool force_off, char *tok);
>  #else
>  static inline bool intel_aet_get_events(void) { return false; }
>  static inline void __exit intel_aet_exit(void) { }
> @@ -246,6 +247,7 @@ static inline int intel_aet_read_event(int domid, u32 rmid, void *arch_priv, u64
>  
>  static inline void intel_aet_mon_domain_setup(int cpu, int id, struct rdt_resource *r,
>  					      struct list_head *add_pos) { }
> +static inline bool intel_aet_option(bool force_off, char *tok) { return false; }
>  #endif
>  
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 283d653002a2..960974ffa866 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -820,6 +820,8 @@ static int __init set_rdt_options(char *str)
>  		force_off = *tok == '!';
>  		if (force_off)
>  			tok++;
> +		if (intel_aet_option(force_off, tok))
> +			continue;
>  		for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
>  			if (strcmp(tok, o->name) == 0) {
>  				if (force_off)
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 8fcd72fca81f..fec4bb781f82 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -59,6 +59,10 @@ struct pmt_event {
>   *			data for all telemetry regions of type @pfname.
>   *			Valid if the system supports the event group,
>   *			NULL otherwise.
> + * @force_off:		True when "rdt" command line disables this @guid
> + *			or architecture code disables this @guid.

"disables this @guid" is written twice. Even so, is the scope not event group? That is, would
it not be more accurate to say:
		True when "rdt" command line or architecture disables this event group.

> + * @force_on:		True when "rdt" command line overrides disable of
> + *			this @guid.

		"True when "rdt" command line overrides disable of this event group."?

>   * @guid:		Unique number per XML description file.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
> @@ -68,6 +72,7 @@ struct event_group {
>  	/* Data fields for additional structures to manage this group. */
>  	const char			*pfname;
>  	struct pmt_feature_group	*pfg;
> +	bool				force_off, force_on;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> @@ -122,6 +127,32 @@ static struct event_group *known_event_groups[] = {
>  	     _peg < &known_event_groups[ARRAY_SIZE(known_event_groups)];	\
>  	     _peg++)
>  
> +bool intel_aet_option(bool force_off, char *tok)
> +{
> +	struct event_group **peg;
> +	bool ret = false;
> +	u32 guid = 0;
> +	char *name;
> +

Could you please add a NULL check for tok? 

> +	name = strsep(&tok, ":");
> +	if (tok && kstrtou32(tok, 16, &guid))
> +		return false;
> +
> +	for_each_event_group(peg) {
> +		if (strcmp(name, (*peg)->pfname))
> +			continue;
> +		if (guid && (*peg)->guid != guid)
> +			continue;
> +		if (force_off)
> +			(*peg)->force_off = true;
> +		else
> +			(*peg)->force_on = true;
> +		ret = true;
> +	}
> +
> +	return ret;
> +}
> +
>  /*
>   * Clear the address field of regions that did not pass the checks in
>   * skip_telem_region() so they will not be used by intel_aet_read_event().
> @@ -173,6 +204,9 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int skipped_events = 0;
>  
> +	if (e->force_off)
> +		return false;
> +
>  	if (!group_has_usable_regions(e, p))
>  		return false;
>  

Reinette
