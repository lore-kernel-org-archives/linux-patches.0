Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6819E74079
	for <patches@lists.linux.dev>; Thu, 30 May 2024 20:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717100958; cv=fail; b=l7N3D2OiNfeNAhLqehmhFgMYlQpWME/0lqUXIwU+axqxYW1Q3sDihlRSV2IzUW4eEehOsjYgDdU9m9mz7P03TMb9vY4bnCLzDS7L2foiGDB94mUEGo7cJKBGJV8+YtUJXUxge4LLfNwq+sJ9G2Si0vEojLy74KIl/u+YDdycz48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717100958; c=relaxed/simple;
	bh=XRCBl2Z3nG7D6ZbGrupJ6sLU1y0+FDtqwCrvRNwhZ9Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sF2Yrfxx5MW0E7LIcbwwOTaI1UPh+AW3H8pt7T0QuNqHi8/E4dIvvAQK7NYp++7nRj1hjjGT7Fy27fGd2DPNTlC9z6Sw/es/ykySpFDjALmr1TfV7SZDOPMAZHKH8sCeAPsnkERHyw8t+fLDRCMA+rcYFrZDqLIc60kR+mzj4+0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UGSBPQ+0; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UGSBPQ+0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717100954; x=1748636954;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XRCBl2Z3nG7D6ZbGrupJ6sLU1y0+FDtqwCrvRNwhZ9Y=;
  b=UGSBPQ+0q/PW6fgqv4nC4F4x4gyMbWOlfKIvdYh8EPCGN8DW1Fz+Gv53
   IkXAThaDInNKIziZLoGdV7zn7Mselqk77I7231d7SOtFSrwapQrxb3P8l
   qSMWBHO9k+JQNIdI8PRGyYZ44uLA2J9pINRhkZ0AburaHiQ2plBHfK2Mp
   gYB2B3FFwV6Q1v4AFLwyScfcpj3ZSBKhUXie1BiUX5V/q49zy6Qs9bBtn
   AOkyLDMN3m2ILkn9o+4YfuMDPpVrQ+bq9re32x0TrnOC7tM8+vodWI2Go
   p7A5rDSbM/B0Uciqc2QPb+lkNK5x4agjT0Jc/8ZlyQERfbJM6dbdnvBVL
   w==;
X-CSE-ConnectionGUID: qBRH4+hCR9mmmgOLIgJNRg==
X-CSE-MsgGUID: UUJbyUl8QjG+qi5tiFWexQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11088"; a="13815991"
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="13815991"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2024 13:29:14 -0700
X-CSE-ConnectionGUID: S5h7XSx6RBCjDnkck9ZRWg==
X-CSE-MsgGUID: roPMEKMKS1mOs0eqivz7HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,202,1712646000"; 
   d="scan'208";a="40852843"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 May 2024 13:29:14 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:29:13 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 30 May 2024 13:29:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 30 May 2024 13:29:12 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 30 May 2024 13:29:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W193pDdkGPoJdyB2afmuLexybrl92b/KtK/SSap+braOnnwFpTcu8coA/nkEmOOeB9Bg28nlT7yau8jf5x3qrR84is4DSKi01q7OxNq/en+igxXFsOWQayen6QrioLTBRLrJl3sjWRi+B6RlI3n4K7y2Yy02TeFrPQlqt0Zc+UClMQ9H8+sHmOmjpezDR/rkxL/vpXoIR8e1lwuJ0otZWBCuM9syY8Qb0nsDgfChg37dHCTaAoEiPB5KRhFXPG6vtvljeypUh95O4mqXrLDvO8AaLbRh60b5NS0NjQUv5gRDEXIr3HfGb9QBTTOwKh9DCYZfcUAM3/bwVBtXOL3Ckg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0y2OaSPYds3Phz75rcr3H/voP2pNCWp4ITXpPyh9Oao=;
 b=cqOokcGDK92X5lTK3ZtSGU9ZAfPL2G0Ynimv1wR4tz4LOLAMSg/eEf3BSgqcgb+q6OhhIdwbZ5OnsfZ70UNzLni3HSgSuZRqycYR8e/x+6EmTNv7EiLY8ibP26GN/hNb69dexWyw1F04TVRg1zY9V2xqpRBtIHdu7GzimICFhDuGNDI01lsm+wzMe5tN8/JhxOQTJT43hQysUXUO27BLacFmIiN7wjYWLSIJDjV5Ho5YpfzGP5kEzsdIffN17bAk9ZpDeAbjDMfEOdApO5uICr+42okIj0ReQbaOMLjnz04V8+YIFv2J7snF3FeCmdvnRYvcq98bocNcWWf5Eou9BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7317.namprd11.prod.outlook.com (2603:10b6:208:427::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 20:29:04 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7633.017; Thu, 30 May 2024
 20:29:04 +0000
Message-ID: <2b1b030a-1d47-4653-90ed-1caa68ad346a@intel.com>
Date: Thu, 30 May 2024 13:29:02 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 20/20] x86/resctrl: Update documentation with Sub-NUMA
 cluster changes
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240528222006.58283-1-tony.luck@intel.com>
 <20240528222006.58283-21-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240528222006.58283-21-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:303:b9::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7317:EE_
X-MS-Office365-Filtering-Correlation-Id: 48f48860-06b3-4c61-5a52-08dc80e7261f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?R2V0UVhOeEo2TzVXeUhLRVhLcHRPenB5QkF3T3hvZHlpaVcvWnI0VnU3N2tP?=
 =?utf-8?B?cVIxWlNBQWZJaGFMVFlKaVJlT2RWS20rME8vTzY5Ykh1ekVqT1VkdkRNQWc4?=
 =?utf-8?B?Rk11UGk2K3ppeGsrWm9EYzU2NTgvcnlHckNRakJueWtoS3RGUTd2aVBwa3lv?=
 =?utf-8?B?eERIbW8zQWdZUlgrNmNScFJndXM3SVJHWUp5WVVNYXFFcHJIcjlUQnduendY?=
 =?utf-8?B?QXZTZmdIekZiRUpacWZUNHJwL1Z3WmpFZ0U4V0pGallBRzBpWHFRUVNXQXBC?=
 =?utf-8?B?YjNJVy9tSG83ZHdkcTFNRUJBeHpmNDVJOEIzR0U0UW10eGRLeFYzZEg0dTlJ?=
 =?utf-8?B?WE56VklPQ3hlYzBJOERrTGI4Z2poZUR4YkhnbkJNelNsL0NoOE9rMFNEcjZF?=
 =?utf-8?B?Qjc2Unp2RitTT2xyM0d2MXdxL0VxcHRUdHBHSmo1VGtaaTFnTzA1YklHczBq?=
 =?utf-8?B?bEliYkRsMkZlbnhwQWQ2TG5hT2JpTFlPSVZHWHFNTUtCaUVYQ0wrL3I1Qk9B?=
 =?utf-8?B?YlhDSUhqOUp6U3NCMk81S2lKdUxPZmxBbmJpbEJuUnUxS083cmIvZXUyWkRC?=
 =?utf-8?B?Y0Q4SzU0MFlNT0tJaXVLelNneDJtMDIwUTdRMFdrRW1oQ3pGL0w5V3VqcWNC?=
 =?utf-8?B?NFdScno4RGdaa2dnckJ4YVFvTUIvV25RSUs3K3ljbllJT203L29Ua0Y3QTlF?=
 =?utf-8?B?MEJNdnFkZ1lCeDhmV2NoRmJOWnEzdVRaRFZBa1duSmZyYXFGcWVPVFpxOXo0?=
 =?utf-8?B?Vk1EV1h5bUs2VU1wdGlxbC9UQTdSeVdvVmR1cm50eXF1bGZJSExncDFOcjFP?=
 =?utf-8?B?alBpVWNtN3E2czlHdTZrWE1KdlAvdDRYeCs4akFFUGhVLzFlelVES1FYRFFJ?=
 =?utf-8?B?NG92cEFpdmIyNXQ0TzE5NkdSZ3R6dVJVbFIyL2lpQUJqcUYwTDRKdkVtV3BL?=
 =?utf-8?B?ZmJaNUhWNnY4RUVXNkxBbjU4clpIVjJFTER3YWJzY2lZVVB3UlFwRVVUUWFJ?=
 =?utf-8?B?SnhkU05IL2FyUWJBV0tGNmJ0MXN6OUJabFFlOC91RmhRVDY3bThQWnhrTWNM?=
 =?utf-8?B?NFdrYnVJY0tPbFpNa3hYK2k0L2swVC9sVDkzUXMyMTZEdGJIL0JCU0x6anRF?=
 =?utf-8?B?ZytyRGhROFRmbUpPZjRHV3M0QXJ3dFJmbXgxRE9RUjUzaUtjMkpOV24yUk45?=
 =?utf-8?B?Zk83czhqOFNqdUV3VmZ5SGtZZzk0OWdWZHBzNEttSEF5V1ROVlJWSGphMjRi?=
 =?utf-8?B?TUg5aFU1Z2FwU0dIaXdLaXhMQ0QvMUhOOGVOOXgzSkJEbVRJYkF1cVAzeVEw?=
 =?utf-8?B?SWI5SXR4VThjcjJoUDdjUFhUeWd4Q0UyMnpqVWFUVGlwbmtZN0RzL21JWTMx?=
 =?utf-8?B?TEIvRnVubHIycCtZTkQyYlI0OTNDVjhIYjVnZWpLUnRpdlk2ejhPWC81dU9q?=
 =?utf-8?B?WXpVNk1sNlh2Q08rcVh4dzlzWUd3RGpZdzJTZjRkQXlPK2c1a3RyR1F1V3FT?=
 =?utf-8?B?UTVMbG9xNVRpcmxWK0kxK3dNb2RLUTZsYzF1NzE5Z3REQzZ3eG9jdHJuNHRB?=
 =?utf-8?B?UWRQZHVIOUxVTnlISjdNNnJpcHYwWjV3Y0RnUkJGcTROZDJVMFFwa0J1Q09B?=
 =?utf-8?B?YnVJdWd3M1l6dVozZWFnMzF0Sm9aZWpVSXpzd1hPQjZUVE5lT2ZnekNtMVRJ?=
 =?utf-8?B?NjViVGdXWGRqOVFZb3dhdllyd2FhQnNiQjRvd0o1RWdtYXF0NHFuc0RBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXUzSW8vaTErQmJycjZjcGtUc09LVFoxSy9yVlVmNlkxZUh6SW9UOFJHWmNH?=
 =?utf-8?B?dTcwaU5vajJJUDJwU1J3eWROOFJSWGtzeE54NUtaT1RxTVdCUWlLaDJCUWJ1?=
 =?utf-8?B?MXhxZjdJTmVKVHJNeTVPU0MzZWt4K1dGRGpYZUhDc09uKzlyamwwZC9iME1C?=
 =?utf-8?B?R21kNWwzc3NtWkhyTGRCajBkT2VwTGhmc2c4dFBhVnJpYmxZN01OU1VKUEp2?=
 =?utf-8?B?VzMwL1RmbUNYSTZ5RWpsdVQxU2JWdFVmRkZ0VGlhRW9SRnVaTnRnaXhvdXFv?=
 =?utf-8?B?NEoxL1Z6VHpEYWFqL2FxaWFZZWJtU3hKZVlSblM1YW50Nk5MRHdxRzM0TFlq?=
 =?utf-8?B?WXkzcGpZRkEya2tLVXl4bUZEWTJpRkJuWXhnQVU3bG00UmhKTWZMZEEwbm5k?=
 =?utf-8?B?SzNFTUZYc21sSkI1LzN2UFhzbHRPeTVBVWhJSDliOVVSRUVPVkk4dHdWVHVp?=
 =?utf-8?B?WGpFektESkRCNVFWaVUya1VURkQ5RVNFb0RpbzcxK25ER2dZOWZIcU9WMnRz?=
 =?utf-8?B?Tm1GbzNiM0s4T1M1K1Z3djlBYzFFVTlTb0ZxdHByeVJnU2wvQ0JWd1JsWTZM?=
 =?utf-8?B?WFVLTFk4N015elZzb1VrVXo4VlJ3WlNManZpWFFRemRQZ0tBZ2JuWWpGVjNO?=
 =?utf-8?B?TVhJb2JkaFB2Y1ZsaHlCeXdjQ0N3dWFEdy9hc25nN3VMMjlTUDloVmlJL0pE?=
 =?utf-8?B?R3dhMFBSanBQRERsYVBlbk1hSk93TjhmMGwvQjBlSG1OK1hPOFNIMGpzYnh4?=
 =?utf-8?B?Y2M1dDVKSkV1Njh5K0pjSlB0Ynk2YS9yMlpOM2F6L2J3SHFOT2pETEsyNVZI?=
 =?utf-8?B?M2YxQ1JTczc4eE1oMzVvdkhkOEprYjJUV0hJM1p4ZWN1a25tM2N3UDlqWjk5?=
 =?utf-8?B?eHFsT3JMRU1nd0hEWXp1ZTJ1bUEreHBNZmNxSUZDNmhIdnYxbytyNWtYYnQz?=
 =?utf-8?B?OU4vVUJFYjJFL1lvcXpFU1lMc1BvcDYwaFpyR1hRWm9PNzVGTlV5ZWJGQTUz?=
 =?utf-8?B?eUJHaElUTTducXFHS3BEaXVibW8vYk9iQVlBVEF3eVNmOGRINUI3Z0tubHRD?=
 =?utf-8?B?ZXBTRkIwNVorWVIya2ZnT1NKc1FhV3AvTC9GNVZabWMyYW1YdkpyRDgyTjVR?=
 =?utf-8?B?WXA4SWt4MW5pNVI2b1FhcnBmUlBCeVpnWXlDb25iTEZXRmljZjhnK2Y5a1hx?=
 =?utf-8?B?K1c4N1Y0czVEUVVzQ0ZnajM5cGtGMnhiV0xEeDc1YmFaYzJhOUY4OUlHUmNC?=
 =?utf-8?B?ODJ0clJVZXMvWlRMMHRXVGVtQnhWL2lVVTdOUXZ2OHVLcERHMTk1Z1lYN3Fq?=
 =?utf-8?B?Szd1YjJsOWtzbitURlo0aDVCOG5GUGNhdldTUno4a2VhVFpSN1M3UnkxT3dU?=
 =?utf-8?B?Y0wxdisvTWxIS1oxY08vNThpYUVZYXFYQUJ0QWtWNkNON1VieEpvRkZBT3Az?=
 =?utf-8?B?UHk0VGZhbjlUNUZSaWhHZDd5UWV2WmFWTnRpL3J1d1dQamRXQVhUbkM4YlFr?=
 =?utf-8?B?ZEpLeERzcDRHcytYM0d4OWVVQU84c1ZjMEFwbkprN0c0VDNFRENQdW0yUksx?=
 =?utf-8?B?UlZxb0hZTzJYb0xMeHNHb1JtQUVyMllxVXg1WjZ0OXJZWUJxOURIVnBoK1Ir?=
 =?utf-8?B?dm00K0E1ajZSaDN2d29LcS9tMkhydHBtRlYyRUFlTzFRMXgzL3hZb1l5YWVL?=
 =?utf-8?B?MGhjakJTL2M5QVVzaldvbWlPQXoyUnJqcXBtOEYyNkJQS0xFZnlqKzZKMGta?=
 =?utf-8?B?RnFlY0dRbExzZXUyOTRMaWlNS2MxVkhaako2Tmd1cHVQTW5La3FacDgrQXZj?=
 =?utf-8?B?Y3JabzlEZWw3bnFJbFVqTXIxdEsxUE56NFJGRjlVNFBrUHlUVC8zSEY3S3Rt?=
 =?utf-8?B?WGRiZ2QzSjk1VS9uV2VUNlhNcER2dllBVUMwczhIckhiK2xqOTdWTGhKVXNM?=
 =?utf-8?B?MXMxNlJzcGtsTk9XOEZXRERPM2g5amhvSkROaW0zWVliZWJDZmJvYXZyd2Vj?=
 =?utf-8?B?aWFQU0dzVWpHZVkvUnliQ2FxY2U5V1pHS0lvNzZnQ3N3cEM5aG5lUVRRUk9y?=
 =?utf-8?B?ODI4ejhyMXBnNVpKNGxNVFJTY1dSWXRGc2EvbksxOFVkYTg4bWdxeDJOTGFZ?=
 =?utf-8?B?d2dLc3F5SEpKZlJub25zTWNKRlZRZ1h2Y2pxY3hZSHNyTmo3M05wdE9BT3N1?=
 =?utf-8?B?NWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 48f48860-06b3-4c61-5a52-08dc80e7261f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 20:29:04.6214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cW0PpQ0B4FUI5KEol7uX660RbGyktzJ8S52OtVfCWlfX/wyxJBK/UFV2TrYfSCuwPV4Nh35pQF6HSvS6S67KPZ9mC5V5Hyfrvc1Qd4HzSiU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7317
X-OriginatorOrg: intel.com



On 5/28/24 3:20 PM, Tony Luck wrote:
> With Sub-NUMA Cluster mode enabled the scope of monitoring resources is
> per-NODE instead of per-L3 cache. Suffixes of directories with "L3" in
> their name refer to Sub-NUMA nodes instead of L3 cache ids.

(insert feedback from v18)

> 
> Users should be aware that SNC mode also affects the amount of L3 cache
> available for allocation within each SNC node.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   Documentation/arch/x86/resctrl.rst | 17 +++++++++++++++++
>   1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/arch/x86/resctrl.rst b/Documentation/arch/x86/resctrl.rst
> index 627e23869bca..401f6bfb4a3c 100644
> --- a/Documentation/arch/x86/resctrl.rst
> +++ b/Documentation/arch/x86/resctrl.rst
> @@ -375,6 +375,10 @@ When monitoring is enabled all MON groups will also contain:
>   	all tasks in the group. In CTRL_MON groups these files provide
>   	the sum for all tasks in the CTRL_MON group and all tasks in
>   	MON groups. Please see example section for more details on usage.
> +	On systems with Sub-NUMA (SNC) cluster enabled there are extra

(insert feedback from v18)

> +	directories for each node (located within the "mon_L3_XX" directory
> +	for the L3 cache they occupy). These are named "mon_sub_L3_YY"
> +	where "YY" is the node number.
>   
>   "mon_hw_id":
>   	Available only with debug option. The identifier used by hardware
> @@ -484,6 +488,19 @@ if non-contiguous 1s value is supported. On a system with a 20-bit mask
>   each bit represents 5% of the capacity of the cache. You could partition
>   the cache into four equal parts with masks: 0x1f, 0x3e0, 0x7c00, 0xf8000.
>   
> +Notes on Sub-NUMA Cluster mode
> +==============================
> +When SNC mode is enabled, Linux may load balance tasks between Sub-NUMA
> +nodes much more readily than between regular NUMA nodes since the CPUs
> +on Sub-NUMA nodes share the same L3 cache and the system may report
> +the NUMA distance between Sub-NUMA nodes with a lower value than used
> +for regular NUMA nodes.
> +The top-level monitoring files in each "mon_L3_XX" directory provide
> +the sum of data across all SNC nodes sharing an L3 cache instance.
> +Users who bind tasks to the CPUs of a specific Sub-NUMA node can read
> +the "llc_occupancy", "mbm_total_bytes", and "mbm_local_bytes" in the
> +"mon_sub_L3_YY" directories to get node local data.
> +
>   Memory bandwidth Allocation and monitoring
>   ==========================================
>   
