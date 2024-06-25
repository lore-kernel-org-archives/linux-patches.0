Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4361117F38E
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358518; cv=fail; b=H3nddubq5W25SBMXKQh1PgcQv5oW68WM9UiA9NQH4/8y+EUe1kw5Y+0ZmO+WEIVYToa6DUjAN0vZxCdVL1VqlUjUzmyMg8vZ1nDpmzLqMx1wYAsxB6z9i2w0fcolsO9hssTLfVC3cKo+P7w3Q227y+3VR6SoIJ4S25ajtvrUX1Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358518; c=relaxed/simple;
	bh=ZAMpSWexPM4n7z26OP/BKMtxC+D29/71XohmIYOIEpE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=izuisW876xsFKAZvYIhIuade093eSEWRZO0p07SlwYa7punZ+BiBt/Hu/5hXH5zlQBlH3hKKzK/WJEVmxZYpPVLlIAEkJuEsss1Tzt7nKSsHcYhQI9OQUpeJbRh36+SPevU4ds/V3Pt9i38mw8/36n9LENQtiNxew07ybFeCzB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ShW1Z3Ib; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ShW1Z3Ib"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358516; x=1750894516;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZAMpSWexPM4n7z26OP/BKMtxC+D29/71XohmIYOIEpE=;
  b=ShW1Z3IbxRDWZXeRT6UQhOY5rIyAk/E0tP49RocbJLhg2lPkO6IxzFAf
   WBdyvfwcYE5cE3l9kqhvbppNfkBoj4th/OiDhhh7GyytRFAA90DKzwrw/
   P7v8pUeqvNb422e4npC45z+8qDc/Mk07X4pQy7FnH/wJL8I4q/hc6b4Vw
   i84MAZYolRO+5dbpH4+OQsMa83LoCRr2qokQolZrUnW5dBDjlcxDeom5F
   F93alCvmSpzegDivC4Mcc37ydgWtGpKmO2QR1pWXkIzURbvmMFDr/j7Ox
   vQFf9frOCMNmZjI/qMQQFYBvbHMr4hKwzZV2lCtiqoSS0KtQ8Is8jZ9RI
   g==;
X-CSE-ConnectionGUID: jZk9PphKSjCwEK7lA+dwug==
X-CSE-MsgGUID: LYnlkjxZTP2KvZ0jKgZH1A==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="16552085"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="16552085"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:35:16 -0700
X-CSE-ConnectionGUID: tSsFPlrhS86n+FZM2JUQdg==
X-CSE-MsgGUID: hmswqD79ToOjte1qvp/EnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="43919418"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:35:16 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:35:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:35:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:35:15 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:35:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmUxCUxIwtp9wwi2L6il70y5XAPD46JsRolFrLbPVFrgLl3dkho1ntL+CfByXHohX3Zsxnwah8y0Cbk6BaxVQ6X9ZhMWZt38i+UTUpxliEKDcwm5/CRSnvH8ARPCNPibfQHd/IRW4xzO5QIOl07HLvRqcr1Fk7gkc+FDkhFGcEyEOV5jIiJfjnNS04PnwUqIrXY3iwtb17wz4B98CSZSmfnccHAU0yNtF/cDFgTiMyWHVZtUCx6hnV8KHG+Eo1Kz5cOeZr6/d+RAxxAiMukWv0oiVSxNYsGGiavxVC76SN6njSkDPj318lfem8G+Ll1yOAgcg7ibQuSnqfh6aVubpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcFYIvngN+9RLlpXoN5ibkceFKBnek3SD0o8SG59GQA=;
 b=HAVwyJSj6J8v5e740MCQTF0aM/M4JBXkvgZ4USI0aaHm+kOl/ur1ZeC7JV0tKZOnfvAtfuOcsqiSmZHmV/idnputhaBnmluJMjnIgPea9EApM1RW51Z9hEaoVJYVFH9Ikub4ysujH6NpNxzRR30W/3qt2nKI0ZKiOg7AV29VTnDzxMCS7C0f2HqcatRiVLA2fmvSqXiges8j4xO4UQWOENzT0b1oDkVF7Tucis72R3zwDHH6sGGki0wrx6KNzeygxPuB8zxFaQguVFmEMGpCpdsdenzm69mmnOCi6aSyI2xxOGyjq7tBFU21vZ6ofpmqvN809bS3i6vsS/O/uCok0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CO1PR11MB4929.namprd11.prod.outlook.com (2603:10b6:303:6d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Tue, 25 Jun
 2024 23:35:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:35:07 +0000
Message-ID: <d7d10322-644c-465a-b0f3-7d3afcb78217@intel.com>
Date: Tue, 25 Jun 2024 16:35:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 15/18] x86/resctrl: Make __mon_event_count() handle
 sum domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240621223859.43471-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0060.namprd04.prod.outlook.com
 (2603:10b6:303:6a::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CO1PR11MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: 06315354-8796-485c-08fa-08dc956f72aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WTZtdUd6eXUrTlR3YW40QVdzTERKTTRJVmxUMmZOWnJSQUpvSWRDWndZOHZ5?=
 =?utf-8?B?eDB5TlA1NGkxZC8yQ0tUQVRDY1RUaVN0WjJoNkJlZzNGVVpUTWJlRUJjTTdu?=
 =?utf-8?B?dDdZT1d6b1lqY0loUG0rcGgveitZZkJiOThpZDVBTCtacUpxNndxQ2dKdEdt?=
 =?utf-8?B?c3ZXTTh6dVA1TlU3dEd0NktEeEQwK2J4V1lEa0tneDViZG5KZzVhSW9XL0x4?=
 =?utf-8?B?cnlWbzk3TS9xTE5oU016VWF5aEZ3aDl3RlBsZVh6dUc0MkFGd1JoWm5CcFJO?=
 =?utf-8?B?UEIxeE4vZXpPeXBoZkI5dk5CYk9nbHhlbWhtMXg0RWV0djFOZmxHYlZoN0c0?=
 =?utf-8?B?RlF1ZmhuUHdHcmRsbVVKUnBWczNiUkhiWFRHOVVMWkJnbnVOTktSNUEzbTZG?=
 =?utf-8?B?N05COE0vWHR4cW11SXJtS2pjL25jUm01RktnRWRyR0RtbEN2V2p3aEFqZjhJ?=
 =?utf-8?B?WkVsbjVkWjBJamllMjVMc3F6OTRjS1FOam9PU0VKSmd5aTBJQVFCUlREL0pz?=
 =?utf-8?B?ZEVMZ1hRYmRWRTF6dEl1cjJQSTdqaTlTVTFSU3B4WnNlU0JOaUpVekNRYWx4?=
 =?utf-8?B?WEtuRnJ3Mzc4RWRpS2dLSkRpbWFFK0UzdEU2T1QwYXFrR2hEemN2N3dtOS82?=
 =?utf-8?B?S1oxUXB1OGFYb1NQb3JJbWU0eGx2VXVrb1lJb0VKRmI0WXd1Nm1hTjBBS0d6?=
 =?utf-8?B?VmxncHVEbHZjYUMzOXV0SlpVM0VYQWJTS0g4cmZOWGk1U2FNSW9adHlkK01h?=
 =?utf-8?B?RVVhMXVVMFFUNERsOWtTQkpPZkZtQjRrMDZ1Zk8vNTd0MlJrOHNBWEhGQktP?=
 =?utf-8?B?QVpjd1M2dXNGZ0poaWcxRGQwUFVtcWpZakpDaytIZUVyWGllUWt3alNzOC9V?=
 =?utf-8?B?WVBuTHExbUYvK01FZFh2dlRtWXVFbmh5WWYycXY4RUNLcndBM0laZjFDbFNJ?=
 =?utf-8?B?OFhObVJUQ1NwRHZEeG9ycGFmbUFkaW5rSEE2TXlBZGxJRllZZUxJS2JBMk1U?=
 =?utf-8?B?UVI3WU15enFVTEp5eU1jYkR1dG1LREJpNDZDRW9SOXBIcFJKSmVGcTJLSzBV?=
 =?utf-8?B?Z0VMQkZsenNJOFVZL1V2R291NWN2MjhsaUd1NFJFYU9OWEpzYXkySjYzREZS?=
 =?utf-8?B?VmJSZXBqbXZpK2x4RHNhU3o0aFJjOHhILzlLRkpWKzZINkkyV2l6M2RzSkFR?=
 =?utf-8?B?UXA0c25TQWU4Nm9kUmVTVlFaZkU5YURaSFdLNHJNaWhxdWd1ZW4xSjIrOXcr?=
 =?utf-8?B?SEI1Q0Z6dTFybmExYWhobUZRSzJoQlJ4YVFZVjhBTjRtR1hwZ0huRnYxc0sv?=
 =?utf-8?B?Sk9XS0lHRDNZdGZETGdRUlgrZGRyOTdRK1ZZK0RNcFBRMWJxTUdEbWVYc0RS?=
 =?utf-8?B?V25qcmZEc0FUS0I2eC9yY2gzT2srbW0yUnIvR2lsME5uWEJBTGdDdGdOTERQ?=
 =?utf-8?B?aFJldnR0OE5SK0JtdVgxRU8vakp5NEFhaExGU3h2S09lU09PTW41WXVPS2o4?=
 =?utf-8?B?YXRpRkxEcURIMFg0WkJNM2swcXBWdjdtVm8yODVLZEFzNmVnN2pLakViNGxp?=
 =?utf-8?B?cEQ0aTI3cFRMb0RBb0d4c1JlNkplZy9vNjQ3eG1VVTM2L1J4WTZJc0NjWEdr?=
 =?utf-8?B?Y2F4UnQzZU1QOW1aNnVoWDNsTVY0NUdxa3Q0dURxS25YZWVFUFR6NVE3UTIx?=
 =?utf-8?B?M1dhL2pFQmF4NWwxUzlPNkxBMUkwOGNoRjdYaFVMR0dvditDY1AyUXlSMUtB?=
 =?utf-8?B?SldHU2NCaVM4TEJHRzlSMFVrN0FFOUxNalU0OFUxMDJkRGszdDcrU2Y4Q042?=
 =?utf-8?B?T25zZ3ppRVBLTWxnb1B6QT09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NGk0cUQvMDdsaERiRzQzU0VoMFFLRmNITW02eGJUZnpURVl5eHJhdmlIdDk5?=
 =?utf-8?B?L1BBV085NHNkaENpL01WakJHeE41Y3hjdkxWbE9pRzlkSU8vTnZSTjFzc2ph?=
 =?utf-8?B?dFZRRlR0cTZpTVIzeUU2TTAyeFRuMEMzVU9PNjcza0ViTndLZk5JRWRWb2oz?=
 =?utf-8?B?MHhHVkNyL2YyWURBa0RwSklvOVpneFdRU09TSmRqbW9FdExDd2FIbXlZZk51?=
 =?utf-8?B?dEJMc0EzV2Vyc3NSN05GNmI5aUxYdmJ3WENvRVdOcWRKZ1BqNWhHVVFiY0M2?=
 =?utf-8?B?L3kwc0pGM2VNY25mNU5haWUxOXI3L09ucW9pbCtIaEpBczEzdTZwb0s0Z0Vt?=
 =?utf-8?B?UjdJRmFxNHEvMzNseDNraGlrWWliZy81OUlaZnVNUGtqYWRadUpKSThHUXZ0?=
 =?utf-8?B?emQ5bzlxdEJuL2JaSWpVdEQyM1VTZ3FXeENXVHlreDJNQmN1d3lDczN1bjlT?=
 =?utf-8?B?TUdqVFNqYitLbGwzZUdwckI1bGcyTFg5eWUvMGNxUzVqUkkyUVhLNy9UaVF2?=
 =?utf-8?B?cVh6TU93WVd3MjhMeDIyQVNheXFncXhJcDM3eE8xT0prWVdVMzhTUjVPMUtY?=
 =?utf-8?B?S1F3VENZK0sydzB1RmFJSGhMbGFSc2pwSzIvUTBwaU5LeUxtSk9zcTZCMDRh?=
 =?utf-8?B?TlZoamtJcnQwTXdjT3JJczF0dWlNWldxby8vZk4vSWRWYm1rUkU5RndDRjBl?=
 =?utf-8?B?WEdCMlFZYkxnY2h4aktpeWVnUitBQS9yaU5VNlFqNUhzTG1ZSUtyNTJDSEVW?=
 =?utf-8?B?eVVVa3RISkRRQU9nZ0lzS0lTT0lFSzVacjdvUzFuYXpYM0hDNEtsbk9Tc1Zv?=
 =?utf-8?B?Rlo2a0gyWGtPbWFrb1BEelBmTzdVQitlZFlJZTFidlp5L1VlWXBBQ0kwNm8r?=
 =?utf-8?B?ajNUL2pvMlNpcHVpdDM5clBYL3FEcGpTdll0ZWNaUktiTGxjSzh5ZWtrRHJJ?=
 =?utf-8?B?WmN4dnZOeW11eDg3b2ZiMGptS1ZPclJKamZBem9UczdJSldzb2l6SHV6dEVO?=
 =?utf-8?B?YnB6bkFjb3ZRUzNEYUp2cHE2c2pwN0V2VHU1M21aVTJXeXBYS1NHc21peXoy?=
 =?utf-8?B?elRXbHNVTC9jY1R2dnRaUXRqYk01Rm1MWW1rMzFLbllackdoTTN6V2puKzZF?=
 =?utf-8?B?NDFZWHFwL1VxaXdYNk83T3RERVZVUG9IU2FBNjNNVTdWVjNPQVNqbUkyY2tN?=
 =?utf-8?B?dXh2TGZVUTlSNDlZVGhRNDlxYndjM2hEQU5ycXp2eS83WDJDRUZYZENWM01U?=
 =?utf-8?B?bFZNRkExMURsTXFnaGhNSjhEUnhZVGNuTHZZN0dSUlpEOG9ZcldHTHhxZ3pm?=
 =?utf-8?B?aEs3Q1NaRUc1NGdzRndabXJ1aWVBbm9qYWQzVjJpbXhlN0NmTTEycUlZNWkr?=
 =?utf-8?B?dEd6aE9VV2F5WFFxZTcyYkVTaFBMenRFMzRUcGZDMzE2SFBrZWgyWTlFMEUy?=
 =?utf-8?B?VWNuRW9oZDl1OHNobThaM0NzcGZPdVFGbHBkZ1lUR3ZIT041M2VlMlg2d2FW?=
 =?utf-8?B?YUpEQk9qZFRkQ0tPcjJFVXZWcGRDVzc2R0NhbHlsZ3phbGQ5aGJJWWNHMGtP?=
 =?utf-8?B?WFFYLzcweFRNLzQyR3RFa3FWRmFMK0dud2N4YldiTkQyQzZHZ0tsQysxeCs2?=
 =?utf-8?B?eDl6NWs4UVZsUEptcWJXRFNlTGNnbStkWk1YOUhjUEJuRXVIVHlBTEcrV3cv?=
 =?utf-8?B?YnBwdmRaSmR2L280bGFXUzBRVGJOenc2c2cwV3Byc3B3RXVjbE1wUTgrUVpW?=
 =?utf-8?B?RjFxTEIvL25QRk1sNGdJZ3A5RTNHUDlPM3p5RGFqeWREVVFqMi93RjNlVzFD?=
 =?utf-8?B?NXo5VEx1eVF1YmwrdWNpaG43ZWEwaTZEWGQ0RTNwTGxmS3lXNmQrdy9Ma3VV?=
 =?utf-8?B?V3U2WGRQZVR2NnhyQTFlVHRiWlhzZzQ4WFlCUHBXUk1SdCtLWW9Ma2FJZWxz?=
 =?utf-8?B?eGwzZVUvUUhDalQ0dS9wRU5VTmt6MlJNbVB5REhaMlphb0dRMnVGdlZIMVhX?=
 =?utf-8?B?RkYrdUVvWmJGOWttTWh5azRVMkh6R2I5SW13SEo0eEtsRkZKWjJKejdJanVh?=
 =?utf-8?B?dnNLVnFubWlPeXhBV1RiTm9vQ09RZXJFWW9xaWV1TFd0TVROSXYrelBON0Zh?=
 =?utf-8?B?NjZGY2RCdDRQQmwzcmJMVEkrcmhoYjJDL3poT3NqSzl3ejdiZFVIOUpnOGt5?=
 =?utf-8?B?SVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06315354-8796-485c-08fa-08dc956f72aa
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:35:07.8430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QuSU4yDJ3OTuxKPb+iwMWP+LL8qG39hLfl3k+chLSrq6NB2ZqlddYUbvyKXHbyWcDdqNdKTUt3IKV+NoEXhA4EwV10Lwa/93YNNrKoAI/9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4929
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> Legacy resctrl monitor files must provide the sum of event values across
> all Sub-NUMA Cluster (SNC) domains that share an L3 cache instance.
> 
> There are now two cases:
> 1) A specific domain is provided in struct rmid_read
>     This is either a non-SNC system, or the request is to read data
>     from just one SNC node.
> 2) Domain pointer is NULL. In this case the cacheinfo field in struct
>     rmid_read indicates that all SNC nodes that share that L3 cache
>     instance should have the event read and return the sum of all
>     values.
> 
> Update the CPU sanity check. The existing check that an event is read
> from a CPU in the requested domain still applies when reading a single
> domain. But when summing across domains a more relaxed check that the
> current CPU is in the scope of the L3 cache instance is appropriate
> since the MSRs to read events are scoped at L3 cache level.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/monitor.c | 50 ++++++++++++++++++++++-----
>   1 file changed, 41 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index 877d898e8fd0..6812560bee3c 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -324,9 +324,6 @@ int resctrl_arch_rmid_read(struct rdt_resource *r, struct rdt_mon_domain *d,
>   
>   	resctrl_arch_rmid_read_context_check();
>   
> -	if (!cpumask_test_cpu(smp_processor_id(), &d->hdr.cpu_mask))
> -		return -EINVAL;
> -
>   	prmid = logical_rmid_to_physical_rmid(cpu, rmid);
>   	ret = __rmid_read_phys(prmid, eventid, &msr_val);
>   	if (ret)
> @@ -592,7 +589,10 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>   
>   static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   {
> +	int cpu = smp_processor_id();
> +	struct rdt_mon_domain *d;
>   	struct mbm_state *m;
> +	int err, ret;
>   	u64 tval = 0;
>   
>   	if (rr->first) {
> @@ -603,14 +603,46 @@ static int __mon_event_count(u32 closid, u32 rmid, struct rmid_read *rr)
>   		return 0;
>   	}
>   
> -	rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid, rr->evtid,
> -					 &tval, rr->arch_mon_ctx);
> -	if (rr->err)
> -		return rr->err;
> +	if (rr->d) {
> +		/* Reading a single domain, must be on a CPU in that domain. */
> +		if (!cpumask_test_cpu(cpu, &rr->d->hdr.cpu_mask))
> +			return -EINVAL;
> +		rr->err = resctrl_arch_rmid_read(rr->r, rr->d, closid, rmid,
> +						 rr->evtid, &tval, rr->arch_mon_ctx);
> +		if (rr->err)
> +			return rr->err;
>   
> -	rr->val += tval;
> +		rr->val += tval;
>   
> -	return 0;
> +		return 0;
> +	}
> +
> +	/* Summing domains that share a cache, must be on a CPU for that cache. */
> +	if (!cpumask_test_cpu(cpu, &rr->ci->shared_cpu_map))
> +		return -EINVAL;
> +
> +	/*
> +	 * Legacy files must report the sum of an event across all
> +	 * domains that share the same L3 cache instance. But newly
> +	 * created domains with no traffic may report -EINVAL/Unavailable.
> +	 * Report success if a read from any domain succeeds.
> +	 */

The snippet of code you copied the comment from actually kept the
original error instead of overriding it to be -EINVAL as is done here.

The code may be ok, since a sum domain may be specified to report
"Unavailable" in scenario where the domain it is trying to include in
sum returns "Error". It may be simplest to just drop the
"But newly created ... " sentence and have last sentence be:
	Report success if a read from any domain succeeds, -EINVAL
	(translated to "Unavailable" for user space) if reading from
	all domains fail for any reason.


> +	ret = -EINVAL;
> +	list_for_each_entry(d, &rr->r->mon_domains, hdr.list) {
> +		if (d->ci->id != rr->ci->id)
> +			continue;
> +		err = resctrl_arch_rmid_read(rr->r, d, closid, rmid,
> +					     rr->evtid, &tval, rr->arch_mon_ctx);
> +		if (!err) {
> +			rr->val += tval;
> +			ret = 0;
> +		}
> +	}
> +
> +	if (ret)
> +		rr->err = ret;
> +
> +	return ret;
>   }
>   
>   /*

Reinette
