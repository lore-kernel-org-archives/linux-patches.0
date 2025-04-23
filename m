Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A901296D05
	for <patches@lists.linux.dev>; Wed, 23 Apr 2025 15:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745423265; cv=fail; b=d+caM64SGezBLJoZ5QdUT2caA+tpgZxWTxa5djtVBo8cw7Qx5MGcXwzjhW1WSXecD3CY+cvJBFPQxEsX2qCPZ1fbTa9FRBVETF7JFFUVCrnCyjCH9KLPYfPrIxVqXFI01zFihmVw3NKC2EHdptqIOt9vA9/A0rE++lohm4/c6oE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745423265; c=relaxed/simple;
	bh=vp5xOaP0pMBGRVN1wyaEHdRoOlkN4vKl1JfRY8EgABQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=AeX6+dJthoJbed2Pwa0A9nQJL3tMQBPK/sHJzxBJGp9UoVfZfPPiBIJbwkz+lYAQulg2KW7Fe7iCQUwZmjxomN8G0JJf/SJvx8oqmFz35pCd6Fr2243OA//qfnyNkz3GZ7P0YDC8mNJNQOQEkJDeHN74KyWePtONe19yzbHXQL0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EI5bmDVY; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EI5bmDVY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745423263; x=1776959263;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vp5xOaP0pMBGRVN1wyaEHdRoOlkN4vKl1JfRY8EgABQ=;
  b=EI5bmDVYyxlg+KxjEnzKAUoqn9Hl7qGs8VXX39kIxSQVYVSC14ZH9156
   eQAIlvXw6Hiw3nEFXCohe923EkTSj91XuQtSBghTdXU8H2yIYsFWAI+vT
   TU8Kbhu0YvFRQ0xYAkxxHSeCHkK0IDDkMUNOKvY4fYouEG+Aigpt5YKLM
   DAiEoqqnFZXUf5CKwZlx8fQm5P4B9ffak6bbzZWNpYsCWxXJ/JALQJ0j1
   j1ua9bvB3TwoSV5j0pEz2U/HvuO369bU1eSzuMKCX/qiYNITDEsOkdhjA
   MfHU6uohfr27DaO5HZWo7Rn8RXn7lhDJsWA0uZSqb07/bc45a+ysv95BP
   w==;
X-CSE-ConnectionGUID: VukKtdcITWyWB3bgwLFDnQ==
X-CSE-MsgGUID: 7HoS3JDtSa+kLKzdTWdMgw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="34640870"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="34640870"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 08:47:42 -0700
X-CSE-ConnectionGUID: zbPTNWiiTyqvTcUEjOQysg==
X-CSE-MsgGUID: 6vzj/NdwRBO7usgKbleCdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="137207517"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 08:47:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 23 Apr 2025 08:47:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 23 Apr 2025 08:47:40 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 23 Apr 2025 08:47:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mgrrPaOllvtmhLWYF8SD8S/5KViORlQiDMXRPnL0nD+meZLmWV1cSDm1CCkIYIB0UYQoHg2B6+h495Rwho+3D2UU8SeipXnjHLFBMyDZs0quAp5yJA5efAOara/KPjtEvoAs69UtfMp6LbfopWxN8cIP1f7m5ufSSKkV2qdLK1yZWNxQUCapaKdg37qJ7Q9YYScE9ubpZloaIlJ5FpIHESNXeR1i0kOPcgSM9Y24U/QiU9h/C7uUbE6wjNw1llBySzo18oGSH020wD7q92REWhUoqYmP0D9dh5TiPi+T4WKx4XJE2SAfizEDF/ShbiE662iU7HPjAWxwsH4kq+MNuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dj8jiaKm2mZBc6Z4gBtgOYFhJ5O4EOxcIGWWXtX6IiM=;
 b=bmy3w38X9hCCbANa1oKI18SMXLTFS4GF22EqvfI4uhS2lOyzLOHY4HcAmsp7GJjB988Via49ikthgbELCVyLYGXaQaZ/hiwA8VXJ+z4dKna7uWK622ozccCTxak2b41zr62eBs+g7VxAmn5jVdjYm/0ZV9LhYDmuss7TG5B2lqu+3vXcTLvSS/Kkt45C0w6sq2BGDdN+mZUO9mcW+wGZ8H9g/mnoj36qEph22308wOFY1XblRacEh+1GJXxx03tQIWIsseXZVhrTjvOw59H2izK3XBWhD3JM0TXFi6tFVK5Th8qXMZydmr0HssNBgnodhgXho2o8g0UlXJUMUhAROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB8083.namprd11.prod.outlook.com (2603:10b6:8:15e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8678.22; Wed, 23 Apr
 2025 15:47:37 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Wed, 23 Apr 2025
 15:47:37 +0000
Message-ID: <6863c369-706a-452d-a413-4d55a1c5861e@intel.com>
Date: Wed, 23 Apr 2025 08:47:34 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/26] fs/resctrl: Improve handling for events that can
 be read from any CPU
To: Peter Newman <peternewman@google.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, James Morse
	<james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, Drew Fustini
	<dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <20250407234032.241215-11-tony.luck@intel.com>
 <da51ba61-4ff0-4db4-a55f-743f6a3ea7da@intel.com>
 <aAaqbUk3gZbCan13@agluck-desk3>
 <bda6d0a8-f621-4745-a578-a7f2c9784925@intel.com>
 <CALPaoCimCmSyeejR9FCLcitquwenmOo0-0PVngUMtmSr_syy-A@mail.gmail.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <CALPaoCimCmSyeejR9FCLcitquwenmOo0-0PVngUMtmSr_syy-A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0389.namprd04.prod.outlook.com
 (2603:10b6:303:81::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 0eca5b0d-9a18-4489-38ac-08dd827e2b95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?U3YyRlhtUUxONkoyNDhHaThDQTdld2hFZGVMc3RNOHhETnpBNWVMelFzbTJQ?=
 =?utf-8?B?YTZ0QmZkZTA5TUlsdWdxeUxyUkRoMi9qaTh2cnZCOVNpd3dCYU5vR1lZb2Uv?=
 =?utf-8?B?VWwreXhkZXN5Q0VITUdHbzZwczJvWHowTFQ1R2JjRitIQzNsMnVxbXJIR2x4?=
 =?utf-8?B?MFZKdjhmcVE2ZDUzaGM1aCtmbVVnT3RWWVRQeFZ5NGJRdjJFL2FLNXRib3JS?=
 =?utf-8?B?RHQ5Y0lmRjdnVkpEdmUyaWd3RHkwVjc5UTJsK2VURUM0QkdJL2tTNkduWUJ1?=
 =?utf-8?B?NE0wRHdCWXhmVUlIL2ZIbFk0MEd6VFlubEJWTUg2eS84aEZQcTFsbTA4UENY?=
 =?utf-8?B?L0ZWb0hoMEI2cDVybWM2ekdHWXZpM3hCWklBNERSeSt6TUJEaGhQQTlhR09a?=
 =?utf-8?B?MFpYL2l6UzBLbTE0SXVBYjlaZ0Nmc3MzNlUwUUVXem9CcjJyYWQ3M3hpMXRq?=
 =?utf-8?B?RHB2WWlkYTdoVGJORUYyOEtnRXRGbHNtRGJKN1kxK2dSR2JFdFhacW94alh1?=
 =?utf-8?B?eG1ieDJnM1lKL3d2eEEwSm5XUmpaeWFJMGZLZXZBSDVycUZiOHczUXQwTW16?=
 =?utf-8?B?T3dzSUdmd1FEUE8zQ0RWMkhrYVhkcVR1VU1kUjM2N1hndHpYWHhLZ1VVYm1s?=
 =?utf-8?B?dGRrbGtJQ0RwUmdicytsMjRTR29zMFN2bU9ZTFZWdzEyUDhXaGlMMlpUQUE3?=
 =?utf-8?B?ajJJSCt6YzNPTXZVRWU5enE4UUlIWlFjSHhjbmFIMGd3a0o5YkNlVEoxTGN3?=
 =?utf-8?B?RldETWdNZ1FSRjNwSXZLZzd4ZUJPR1pTandlcmthbDFTMjUwQmI5bnpJYTZ1?=
 =?utf-8?B?aU9xc09rUXliZ25XWllzTzdkZm9ERWNSUnliMlFzWTlSTTd0bEdGR09oK0VP?=
 =?utf-8?B?ZjY3K3ZWcFc3d1FkaWE2MTdHU1VVamdVekpuNml2c1BqcW5sSmdGc2lZaFNo?=
 =?utf-8?B?U0gzVFZJdlBQbXgxdnNseG5pTmVFVUhtZkliZWd6elhQUnJvMWFPQmhiUEhz?=
 =?utf-8?B?TVZyai9RdHpVaC9vc0dZc0x1dUg1R25KcmV3RkpjMHlGQk9ORVpDbkZ5WWZx?=
 =?utf-8?B?aGpoQldFTU01ZUlrb2pQemtPUFlWdmtGak8wMlRYSW5PR0N1QlBEd1hObGxr?=
 =?utf-8?B?WXVJZTZSM2tocUZhcEFZbG1OTmJhVzhwblpYM2Q1YmlOeENERWJwWm5kYlc4?=
 =?utf-8?B?dUorVDV5VUxWVE94NGxmclpMNU5YOWhRSm93WWdZbUp3dld1d1RBOUFKYmVG?=
 =?utf-8?B?c2lhRytWQnZPQ1kreGRmLzR3aHJLT2d1RU8wVkdtVE5XM25hSnpocVFPM3dX?=
 =?utf-8?B?ZWVVdUJvQUlrNjFhT05Hb2NocVBrRHFRSThGU2UxejQyejZEc2pPTXlaSm9a?=
 =?utf-8?B?bkN1c0tHcXZvanZQRi9yVkpiYktOd3BDdENvRHNFK1FqY2gyKzVJVVhiVmtN?=
 =?utf-8?B?cG9mcjEwNytRTlcvZk9vSFQ1MVFvZTZZcURJaXdoeE0wMEFnb0QxUnE1NDcy?=
 =?utf-8?B?YWVBSy9uYldzaFgwMVRQeGlybXNOMnh4enhoM2RibzUwWC96dG9RNFlpaUNS?=
 =?utf-8?B?WG1FM0lYQlZBNWpka3k0U1UzZjN1NU5sb3JQUVNlNTJUWEpLVGQ2YWdxR0Z3?=
 =?utf-8?B?R0FQanpQWUpLNTQzaGNxRnZkem1KWld6YUJVWWU5OGpsODQ5RktrdjdhU2wx?=
 =?utf-8?B?bmZENmltTE5mUHNsTG1QM0lYUTA2OUw3YUF3MFI0c2FwblZtL2RMRlhpaUly?=
 =?utf-8?B?dkF2MjZLTEEyN0VuYmtsRGYrVDhqQzBFQk9RWVBuU1prSFZOYllQRzlSSTNz?=
 =?utf-8?B?NzYxTmxqeGdFaUJCNDd5RXp4ZzlNMXJMcXNwemF6NjM2cG10S0VsZThEVnZ1?=
 =?utf-8?B?Tjl0MHYzM0JwL3pqbG43eVJOS294VkhQL2FVazJSd3JtaXdDTm9BclNVRzRR?=
 =?utf-8?Q?GsvEGgBIwn//aW2A5P6VDXJbkTJSrqaM?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?blZPZDdLWEoxQ3RwMEpLV0xLa1ZpNitGZ1BjdlE4bmcrekRTdVNoSjIveGN0?=
 =?utf-8?B?QWI3UU16QmJScWlHb3dqNzRyZEJtQnhCZzlwVEhDajIwc3BCV1hZcDNJbU1T?=
 =?utf-8?B?bWZ6Ky9RaDFWVm5WMm0waGI3MU1PRi8wNWNrbVBPRFRPdzBmNSs2Nk05L0hl?=
 =?utf-8?B?eGUrTW10SXZHUFBSZ0RhbU1LcndpRXdhV1p0dnAxdlFSRHJ0YWNQNDJMeTZP?=
 =?utf-8?B?N244UWRtYmpYTFhLRkhCV09XZ0UzL0lIOWp3NE1CdlloMzRXV2hyKzAwQ1pR?=
 =?utf-8?B?NzVneU1XeGR6N2F1Umxydk5kVHA3Y01LN2dVTm4wa1dGNWNseUVmQ1lDTDFM?=
 =?utf-8?B?c0R1L0VGVHZCVEQwMTNUeVpNYWMzNVVYbTMxQ1UzZFFvRkczV2tMSGJrdHA3?=
 =?utf-8?B?SE1XQnB0K0ZVWFNnRjVIdGNIWHgxUWMybWx4TUVTQXM3elJxM2JWdkVoVjV5?=
 =?utf-8?B?ZFJNNTE5UUI5TTcvbWcyemZ5OFptTHc4aU9oUHlPZ3pLVm0vZmt6ekpHNEhv?=
 =?utf-8?B?UmV6aUtDVDhuSXJsUGQrQmYzK0x5Y09ReTdETmNCUUlhMTVtZy9jd2J1d3lm?=
 =?utf-8?B?RzZNSnRxZEpud2k2TGI0TXFwWW5TV2xvSjBPbktzUGFYOFN3dFFsTzlEbW5u?=
 =?utf-8?B?cjdibW4yd1ZtUkRtNjh5ZzBrWkZ3OTlSNmFYdVZISlNpQmJuZFRUaWxvQmpV?=
 =?utf-8?B?bnI4VlRqcVNsTktPS05IZ2oreVlXNTJieWpJU1FXbTBkdFJSekIvWlRzRHR0?=
 =?utf-8?B?M1JxZW5vbXBlZVhidVZFdnNVaC9QeFpCRnAxazVUS3EzbHBlWGxQcktqeHRF?=
 =?utf-8?B?ZUNRQ21ENWsrYlJlZ0h6eHNweWhyZmVJaE5pVnlicTh4bzJGVnJBUzFBSzA1?=
 =?utf-8?B?aTZTTXZWZ2QzYmNlYkcveG1LZFRQMHJhaDZnUHRiT3NBQU95MUpSUUVWU0lY?=
 =?utf-8?B?K0dra01zRFJKSDRLcDRvS0o0Y242RHRzL2FSV1h6N3Q5ODM5ODFPZFIzWkpn?=
 =?utf-8?B?MG5tZ0J0cXlXdEpCVkVQRExUU2hrcUYvK1BZdTNEVWJkeER1emxqV0lRV0ZK?=
 =?utf-8?B?Y2ZNM1VCQ1NWUWpUZ2V4UWdLbnYyRlRkRkRQUXE2aWgxSWZ0K0VST3dFRzBJ?=
 =?utf-8?B?M2tWT2xDZkJKYjVyUDV3WWN6c2Y3cXpWYTVtbnAwT0JKME1qWEdIZ3pqRnJQ?=
 =?utf-8?B?MXB5M1ZjdUlSbVZTYlZJNHdOYlVqZ0Vjck9hZTRpbXFOcEtGcnBnYm4zZW1X?=
 =?utf-8?B?SUJrN1AvcU1yalNCQlRGYzVSWk9hRElTYzlCSEp5NVQ1M044c0hWcHdQeXYv?=
 =?utf-8?B?dkFEdm9XZG5jYVJsWWI3YjZpVy9FeEdUNHcrMklPYUR0N1JReEZVNThxZ3Ba?=
 =?utf-8?B?aDErR0VRRFBtSGkvdU5HeWxmUnZoUmFKMit6WTZjMnQzWHkvUVhVZThwbEZ4?=
 =?utf-8?B?QjZCREF6Wjlwc3JidkwzTmNueFZsY3ZCcVNjSG5FOFYyaUdjQkxNclovNlZB?=
 =?utf-8?B?V28va1Nic0s1Z0dkZGw4K1hmUHp4S09iYXFVNmRsM1BWTEFpaEd3dnNQUjhx?=
 =?utf-8?B?Qk5OVWQ3VWZoRWZLWVRPYTRTaFl4QVVILzQ4ZnJRYUZML3d6cURVOTN2OWFZ?=
 =?utf-8?B?QTFsOFNibGsxVkxJN3ZqUlZHbVZLUnFmMUE0NUQ5cUxOMDYvMXk0VnZWMHpl?=
 =?utf-8?B?Z1dxUnZIWWdka1FQeUY1cGF1TmJGY2EwbE9QWkhyU2xHVUUvZm5XeHA5YWNj?=
 =?utf-8?B?Y0JVVEZoaU84RitjVDVKaVFNUjNjMUJNTFBjNVhFVU1zajBBZGQrVDJZbEd0?=
 =?utf-8?B?Mjk0QVhreVpGL3ZpM0Q2ZmVsZnYrR0drK0pFTWpzcElrWFJNZTlkaG1zUG1Z?=
 =?utf-8?B?UDVDQ0pmUDhjNFFxaUx0R0pvZWU0R0x5M04rZTAyVUZDc2NXRnVKSUQyOWda?=
 =?utf-8?B?enkvTXFTeVoyL2R5Y1JkK004QnVYU3JqNU5QZHpaWGhxak5CVmE1ZzdreFYz?=
 =?utf-8?B?TzZHZWFMRVVrdTRwRE14cUdoMFQyWVBBY1JEejRLRkFMRm9mQTJVOHJscUFp?=
 =?utf-8?B?bm9WU2VHcUE5TmNRa3NzOVlLMUx0NUJtVmZFMDV0b25kSFZGaGdYRTQ2ZmNv?=
 =?utf-8?B?L2N6dnhGTmgycTU3OWVwUlVtQ0Uvd2NrUHJZcUs3YlZZS1h6TVdsZG5ML3Nz?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eca5b0d-9a18-4489-38ac-08dd827e2b95
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2025 15:47:36.6638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 52VQAigaNiGvrijnCMFfmpN6sw9OnjpK/IedjlANNZ5Zt5RGP/3uRkzD/PH6epceUh+2/gmHhZFXSSQIOsnJ6uOo2csSU2UGJ8CQBbuHlT4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8083
X-OriginatorOrg: intel.com

Hi Peter,

On 4/23/25 6:27 AM, Peter Newman wrote:
> Hi Reinette,
> 
> On Tue, Apr 22, 2025 at 8:20 PM Reinette Chatre
> <reinette.chatre@intel.com> wrote:
>>
>> Hi Tony,
>>
>> On 4/21/25 1:28 PM, Luck, Tony wrote:
>>> On Fri, Apr 18, 2025 at 03:54:02PM -0700, Reinette Chatre wrote:
>>>>> @@ -619,7 +622,8 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>>>>>                     goto out;
>>>>>             }
>>>>>             d = container_of(hdr, struct rdt_mon_domain, hdr);
>>>>> -           mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
>>>>> +           mask = md->any_cpu ? cpu_online_mask : &d->hdr.cpu_mask;
>>>>> +           mon_event_read(&rr, r, d, rdtgrp, mask, evtid, false);
>>>>
>>>> I do not think this accomplishes the goal of this patch. Looking at mon_event_read() it calls
>>>> cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU) before any of the smp_*() calls.
>>>>
>>>>      cpumask_any_housekeeping()
>>>>      {
>>>>              ...
>>>>              if (exclude_cpu == RESCTRL_PICK_ANY_CPU)
>>>>                      cpu = cpumask_any(mask);
>>>>              ...
>>>>      }
>>>>
>>>> cpumask_any() is just cpumask_first() so it will pick the first CPU in the
>>>> online mask that may not be the current CPU.
>>>>
>>>> fwiw ... there are some optimizations planned in this area that I have not yet studied:
>>>> https://lore.kernel.org/lkml/20250407153856.133093-1-yury.norov@gmail.com/
>>>
>>> I remember Peter complaining[1] about extra context switches when
>>> cpumask_any_housekeeping() was introduced, but it seems that the
>>> discussion died with no fix applied.
>>
>> The initial complaint was indeed that reading individual events is slower.
>>
>> The issue is that the intended use case read from many files at frequent
>> intervals and thus becomes vulnerable to any changes in this area that
>> really is already a slow path (reading from a file ... taking a mutex ...).
>>
>> Instead of working on shaving cycles off this path the discussion transitioned
>> to resctrl providing better support for the underlying use case. I
>> understood that this is being experimented with [2] and last I heard it
>> looks promising.
>>
>>>
>>> The blocking problem is that ARM may not be able to read a counter
>>> on a tick_nohz CPU because it may need to sleep.
> 
> If I hadn't already turned my attention to optimizing bulk counter
> reads, I might have mentioned that the change Tony referred to is
> broken on MPAM implementations because the MPAM
> resctrl_arch_rmid_read() cannot wait for its internal mutex with
> preemption disabled.
> 
>>>
>>> Do we need more options for events:
>>>
>>> 1) Must be read on a CPU in the right domain  // Legacy
>>> 2) Can be read from any CPU                   // My addtion
>>> 3) Must be read on a "housekeeping" CPU               // James' code in upstream
>>> 4) Cannot be read on a tick_nohz CPU          // Could be combined with 1 or 2?
>>
>> I do not see needing additional complexity here. I think it will be simpler
>> to just replace use of cpumask_any_housekeeping() in mon_event_read() with
>> open code that supports the particular usage. As I understand it is prohibited
>> for all CPUs to be in tick_nohz_full_mask so it looks to me as though the
>> existing "if (tick_nohz_full_cpu(cpu))" should never be true (since no CPU is being excluded).
>> Also, since mon_event_read() has no need to exclude CPUs, just a cpumask_andnot()
>> should suffice to determine what remains of given mask after accounting for all the
>> NO_HZ CPUs if tick_nohz_full_enabled().
> 
> Can you clarify what you mean by "all CPUs"? It's not difficult for

I mentioned this in the context of this patch that adds support for
events that can be ready from *any* CPU. The CPU reading the event data
need not be in the domain for which data is being read so all CPUs
on the system are available to the flow supporting these events. Since
all CPUs on the system cannot be in tick_nohz_full_mask there will always
be a CPU available to read this type of event that can be read from any CPU.

I made it way too complicated with this though. Tony proposed something
much better and simpler [1].

> all CPUs in an L3 domain to be in tick_nohz_full_mask on AMD
> implementations, where there are many small L3 domains (~8 CPUs each)
> in a socket.
> 
> Google makes use of isolation along this domain boundary on AMD
> platforms in some products and these users prefer to read counters
> using IPIs because they are concerned about introducing context
> switches to the isolated part of the system. In these configurations,
> there is typically only one RMID in that domain, so few of these IPIs
> are needed. (Note that these are different users from the ones I had
> described before who spawn large numbers of containers not limited to
> any domains and want to read the MBM counters for all the RMIDs on all
> the domains frequently.)
> 

Thank you for this insight. There is no change planned for reading
event counters for those events that need to be read from their
domain. Tony's recent proposal [1] moves the handling of these new
style of events to a separate branch.

Reinette

[1] https://lore.kernel.org/lkml/DS7PR11MB607763D8B912A60A3574D2BAFCBA2@DS7PR11MB6077.namprd11.prod.outlook.com/
