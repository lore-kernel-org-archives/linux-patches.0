Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5181021420B
	for <patches@lists.linux.dev>; Mon, 12 May 2025 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747059627; cv=fail; b=N8KloNpzlV8dc1oFxyghIXqeU5T0nTfVsYsp1+SjwrOPxB5Zy+SjJNFW2FSr/d5xlfE+7IwouWJl0W2edJ588SUTU7g5WRg5qPTBQ7yEU0mBG0NMhKcHQjNQNNbtJ1mAZZKxt83KpWQf4iaHBQyH8pEKCfujoQVSAuRaOeEVjI4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747059627; c=relaxed/simple;
	bh=6EX/hHew2CSLikGYleqcG4M6lXyFZ+LBCS4gaXvRwiE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=VkC3G0EA+9KMb7nCwZdI5YWXiqcCBOJOmoG+8EdBG5bPC4jWV1eXCVFLa+Ud9EMQjuSEqUoAbfM46GMTKo4w1mgw9upfual6XY+z1i4ltbaC4G19bEez+ozUwpKsw1Y64wY3qgd88PCqIfLJ8tPHAS+To+6qdAqdM7fJXXVOObU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jUiyFkgO; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jUiyFkgO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747059625; x=1778595625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6EX/hHew2CSLikGYleqcG4M6lXyFZ+LBCS4gaXvRwiE=;
  b=jUiyFkgOe5a7pkBrEB4PSnSPaex7H8V/fMsJHARSK3ZV2LlEQIXO6/rg
   ZxwUSQeNm95m5n873FjHsJLEGBczqIjxGkT7jeCfEs8RaQsns3aw8WGIX
   aR55eKV4ueb6H7TaNiIyc5lB0Z1pKzzDPieUEZfq6j+Fasc7Zmx4GnctT
   WXQc27nkIzBGFnaJPvB04LUWbNg+u4jzE3fUqj93dX9HgjDwgIj+NJd0d
   +kIqZDh196EquhqUbItXFhpXExCr70kKOMXoO/CM8fHuSBq639gVh+lTl
   W+4WCGKUfgrRNulopgoiXh7UzqH+YsMHDBhvB3Sw6kOWy733hW+aW8NXA
   g==;
X-CSE-ConnectionGUID: Ldd6II8vRWG8vhGG1nYhTw==
X-CSE-MsgGUID: mkbDpAurSFK9495ZbZFQ/w==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="47966603"
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="47966603"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 07:20:24 -0700
X-CSE-ConnectionGUID: HnRz84YdS4yGpsWDIdKZjg==
X-CSE-MsgGUID: 828WF6ffRWmzQA6+vWhmBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,282,1739865600"; 
   d="scan'208";a="137851159"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2025 07:20:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 12 May 2025 07:20:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 12 May 2025 07:20:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 12 May 2025 07:20:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WLMoh68YuA0oKtJrt8/nQKqpI4FtuQKwphtkzh7LQcQMZ25p4hEU+vp1voncMoxTk6uyH5Gt4eU4qwMOGvEjlUUkZFwEnA4FYbKih8D1IcnHcDhgyrOgCqbHUDpeFKS+T5w8avaiVJ9QAjVKcDx9PWYJVrVPlWY1YgeMdp7n4MFQZR83XLdYtzMLJL1jcPZyaV8+mQhpOwoWr+NLJE42Ttuyr4si8DvpW7X+2319IRAfTbOGYW2z47tbFu1xDdo0z9VLVFnUsdXurn2JQ+b0M63B4qu6gW2cbH3tfwTMYwhL363FRvmIt0GTz/BVQn8zoHuEKNTphM5Cjd4NfDjwPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6EX/hHew2CSLikGYleqcG4M6lXyFZ+LBCS4gaXvRwiE=;
 b=yutKElYD+LLqp3FbgO161VSMUFWEYQz14XPt+5uxMc9d25g9uL5ii5fB6xHYUvYpMwgWyBgC+3sn8zRUYzwC7eu4ZWFyxl3PvMtjAv4cAE3mrExHd8eKKO+zDKNdIHHm0hQvfqxkLjypWEERTGuIzZXdUKSz8sVYOIBZr8rzYR64aRi2NNsxmapRIVxGcLxGZksG7fZyPwtgPfsrNr7J1Xa1WhVtiHqHHTI8sz44k2un5zrs1wDwPq7HNjj0NCX2rgXjZmmklsBIbKKgkA4bxDgQoedhWOj0J2OXfVHujBU7UR5yDwHLeNB8l2iuF4EFKuiZN7D7qZ//jF24CDdW7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5149.namprd11.prod.outlook.com (2603:10b6:a03:2d1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Mon, 12 May
 2025 14:19:54 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8722.027; Mon, 12 May 2025
 14:19:53 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, Peter Newman <peternewman@google.com>, James Morse
	<james.morse@arm.com>, Dave Martin <Dave.Martin@arm.com>, Babu Moger
	<babu.moger@amd.com>, "Keshavamurthy, Anil S"
	<anil.s.keshavamurthy@intel.com>, Drew Fustini <dfustini@baylibre.com>,
	Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>
Subject: RE: [PATCH v4 05/31] fs/resctrl: Set up Kconfig options for telemetry
 events
Thread-Topic: [PATCH v4 05/31] fs/resctrl: Set up Kconfig options for
 telemetry events
Thread-Index: AQHbuJ5zKvpWa1VHYUGsp70WPSaQDLPLsvQAgANrc5A=
Date: Mon, 12 May 2025 14:19:53 +0000
Message-ID: <SJ1PR11MB60839C0C7DEAE64DDAAF0E9EFC97A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-6-tony.luck@intel.com>
 <621ff36f-eaa7-4dba-909a-e50977abf6dc@intel.com>
In-Reply-To: <621ff36f-eaa7-4dba-909a-e50977abf6dc@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5149:EE_
x-ms-office365-filtering-correlation-id: 075f0f56-15b1-4741-0550-08dd9160108e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VkpOcUZGRzBIdG9qOERLZ1JKb1lNS3dmakJMUzIzVzFHc3Zlc09pZEQyNHlM?=
 =?utf-8?B?YkcrSDQ2VDY2NzR1UGVaMlo2bjlRdzFiSHV0WGxRSnNBRGx1MXhpN2JYQVR0?=
 =?utf-8?B?L0ZwdDZJQjg2SVY4eFhzTHZiMGxrYTIrb3Roa0xZbFR4VFF2NjQ1bDBWWThW?=
 =?utf-8?B?cWJKRkIzdjZUcWxYOFNHcmhIam00SkhETi9XYy9CVmx1NUIzejBGTlE1N3ZU?=
 =?utf-8?B?aitwMlBNbnFxZG00cEVleXdSeDhTRDRNRHV1aDZaL09waXN0TDNqM1lyZFhC?=
 =?utf-8?B?aGZ6VHg5L2xBSmMyN2Y4RVZ0SUdiMWIvalF5QVhyV2doREYrUzNvNzcrckIw?=
 =?utf-8?B?Y0ZQakUxOHpaMFlBNWVnR1Z2S0E0OCtoT3d4S21LMDNpQ3VUeGxuSUxBZXVp?=
 =?utf-8?B?NGxFUHRwUnZJYjZyVE1aeUxJZXp4SitwM2RHT2ljQ003cm82TnRNdHJ4aUpT?=
 =?utf-8?B?SUV6RC94aDAxbjJSS2txVldBY1p5bXlmQ0d2QzQzTW1acWFveW9pQzlpMWpF?=
 =?utf-8?B?RWVuSlFFQUFkOE1uSlVIc056eEFxSDh3SHM2Y2pVQkMvQXhIVDNiWHBMSUg4?=
 =?utf-8?B?S1JtZmE2MG9mcFVaUFZiT1NEY1d2YitHNFdtZ2YwNmlvR1FsNVBoKy9SeU1p?=
 =?utf-8?B?UmhZSitQaU0rMDJnMTFJT0RTUVlxTXRsczIyeERRaFAyWjlLK2RFVGlKeU85?=
 =?utf-8?B?cEVTYU9xN1RLYkl6cWpiSlhEVUM5VCtadzFLWGpJOWp6N00xVUJDbDZDcGQ5?=
 =?utf-8?B?Z2J6YkdNY29yeXZzQWQ2RUhnSWJabUhUSi9rMW1seEZHdFFlb3crSlMzZWZ6?=
 =?utf-8?B?dG9TOGgzVUYyMEgzN1VJV3NRNm9LT1pDQ3BIeHhoMHFHMG5kd0ZEbmF1U2lT?=
 =?utf-8?B?SnZJNTZYVXljYlRLaXg0KzV2b0FMaEw2Sk1DZTQ3T2VGTlFOWjR5YlBHMHJk?=
 =?utf-8?B?TDluQ3lGRVRSN1N4dmxzb0JDcTBlMi9KUEVVRGNzNjd0U3ZBQjhWZnpid2NH?=
 =?utf-8?B?dVlzWVI3RUI5Y2YrQ0RjUHlxdHFWenlTY3FVU0Y2dVZVdVlmYmhpbkhKL0dX?=
 =?utf-8?B?cnlaQ0hWY21oTDRZTWFGSjhybmRDTjNpR200VkJSamtKZktTdXRLMDdmUmg3?=
 =?utf-8?B?ZzhSaUw2NUdDcjVvRkFsTlVxYWdXVkVOdldmUzhQQ3BaOGFlcW9RRTN0VHhv?=
 =?utf-8?B?WkFvL0dyRE1zSjBhZzVrRGFoQ0NiMmQyUm01OERXdC8vVXRjV2VWRDdSUVZJ?=
 =?utf-8?B?dkcvSUpyYk93Umk4bEw4T3Bob1M5Skd1bDcxSVJjMGhPWTBBcFlaYldkakkz?=
 =?utf-8?B?aS9GQ1kxRkV6ZFBSajdYQzgzSGpsMm4zSzRPZ3E3cmdWS1d4K3FzMjFwNVdr?=
 =?utf-8?B?WWFUWEF1L3cyQ2F2K0MwcEtXaUhLckt6TklDSW9YVzRSRXlaS2ZTc3Y5d3di?=
 =?utf-8?B?ZTdHUDgvYkYvYmV3QUxtTDZMSXNvR25TVldISldhQXlTZ016TlUweVpFNnk1?=
 =?utf-8?B?dGJHdXNVS3dtTTVkSS9GM0RBNEF2SWlTdmduendXZWV1NW5FTmVJR3FWWlRR?=
 =?utf-8?B?SytycU85NXNGSklLa3YzVk01M2pFNDVrN0Vld29DMTREbUY1dkw2TlNGdDRq?=
 =?utf-8?B?bnVIWktuV1F6dkNzdFh5WGRtdWNGZENYNjI1NlFBRy94VHh5QnduRXVIMGJo?=
 =?utf-8?B?cmZxV1pyNklBTEIxbFhwR1J4SmphMnNZVmhhMTJjMTRZVjR6UzVqUnpRcE9j?=
 =?utf-8?B?cXcrb2ZtN01SS2dURG12TzRxbk85bkVuTGFRUnRuNWNGcVQ0eXN0Q29NSkR1?=
 =?utf-8?B?U1ZuR0NOblVyWHpIek1Ea0VHOGhEL2ZVNUNrN0ZwR01QNGNrc3pGaVgrSVFJ?=
 =?utf-8?B?NWxXYkZWM1JuLy82bFlBRHFPblhXYnVmdXJmQTZSWFp6MmVoTFc2WXJza3pG?=
 =?utf-8?B?VncrTzhjbHZIdzhyNGJhYW5DL2IrUGViNndsV3NUbzlsaFlMaEZrYWlqL1dV?=
 =?utf-8?Q?XSZ1JvVyb+dOd4ug+0vouq+8XNCTos=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VENvRmI5SjZRdk5kMWUySmpvdkN0QU5hMVRJWUtTYk5PYk9WN3JuSzN0TVZh?=
 =?utf-8?B?UzlpcVZIVU5YbEhLdDRrN3RJKzJ4ZVBUQm5vcXJXTkVwRy9sR1VSSmdkM0ZC?=
 =?utf-8?B?R25JQVVGV2V2bkhjNENObXRkTkhEZWdtNTJrOFZmRjNRR0RBUDFXVXlsL2M1?=
 =?utf-8?B?NUd6TTZHMlk4UHRkZC9nU0pOVDVXeTFsY3VNMHlhbmFRcUVHZlF5ZUFYVDhS?=
 =?utf-8?B?L0RuVzRiNko4cW1WQXUxcnF1Z3RSRTJZNzh2MHRSUlo4dEk1ZXl4U1lFdmln?=
 =?utf-8?B?MDhBaXQzZkFMZTBVdjkzSDZuRyt0WUlpT3YzNFcvVTk3ZTZDU2YxN2R0RW14?=
 =?utf-8?B?QlZ1MnNxTGl6LytsSytuMU50N3J2bWNSQmxnVmkyMlJCYkF5Y1pWVjkvclJC?=
 =?utf-8?B?WGVJMC9kT1FYWkFoVDh1bnRjQm9UaFd4eXV3QTBISjNxclcvNU1ORGhlSnEx?=
 =?utf-8?B?VWRxT1FPd1g3ZjU4UERYOTlRbFNWMlI3ZmVFUXl0OE5uU3hObWtpS0hqOUlr?=
 =?utf-8?B?THJOY3UwWHNJWTlxV1Urb3hnc0t6NkNWM1RBbWhDbnpnOEc1OTZuSTZ2ZG92?=
 =?utf-8?B?TTM3MUx0REk0dVZlMUN3TWhpbDhLY0RXNDVXcFdFZTJuUGREMndiU05lbEF0?=
 =?utf-8?B?Q1VLcjlFdDI3OUFTZjEzSlRqamNCdGRIUEIxOC8rNDJKb3JaR25wSXB3ZWhu?=
 =?utf-8?B?SXhaeEtpOHF6UVduSWNjNUd5ZmRna0krQzVkeE83bFFQMWY1MWlRRW44VStE?=
 =?utf-8?B?b2tLRXpDWWpudXlrQVN0Y09BR0hsNW1tM25Uazd0TmpPajVURnhQMXZQeGdy?=
 =?utf-8?B?WGRvRHZEZ3lscG9lSFluN29iaFE5VWxFVEV3ZkVpTHRJemFHZjhIZGh0emo5?=
 =?utf-8?B?YzJhYTljdTlZRVc4UCtNYUticUwxQTBCTDlsTFhjVmFzd01SdzFVQnhGbTEv?=
 =?utf-8?B?QjEvMEhGem82NnR5bDB6VGpKZWsvRzlwZkk3SUo2VFFOUGppelRrWlZvTEY4?=
 =?utf-8?B?S2tMLzJVcDFTMXpFU09INGV2ZTAvNk40QWhBcFhCN0VPM1VORXJVTE9MSnJi?=
 =?utf-8?B?Yk95T2Eyc2NSakdsaTc1b0RhcXY2RkhJNzl2bzM0dmRiQndVaXM2UHJEbVpF?=
 =?utf-8?B?bnJXaUY3d2xUdzYwWWZQajlhd0dEUVliTU85SWtmS2pWSCs3bW5CUERxSmp2?=
 =?utf-8?B?MFlVYjVhSDNPUGVpVENjQUNMTm8wU25UTzRxcitKUnROb2tBSGUzMlZOeER2?=
 =?utf-8?B?THc2Wm9aaVo3MEF3V1VMenltSnA3M3M3by9LdDlNbFVycXJNRlkxSXMvbHdI?=
 =?utf-8?B?TWdQd2R3eWZOaFRRTmFtNkJHTzhrRzVkWUQzeGhBWWJUdEUyMVNGVUlZMmpy?=
 =?utf-8?B?cnlqV2NJQ1ErdkpXZW1BdVZUWnFKbEh2OU92dEtmTmJhSEE1RjR4dUVtc09N?=
 =?utf-8?B?SXI3TXhMaXd4YUJDTm5MQTNnVWZHT21Oem9rODlUdGRaaFQzajcybk94RVVk?=
 =?utf-8?B?V3c2OWlyWGVPM2VNWlpPZkg5UE1laXo3ZWFESEJZVlhyY2s3eTlYcm5hcTRG?=
 =?utf-8?B?V1F1NXV0dTZRbEVYUGhNeVg2RzRleHBFdXNJTlJ5ZmNKZXN4SkJFeW53MVNK?=
 =?utf-8?B?VTc3aXNxYTA4c3loZlRjSzByQTlJUWpHaXA3dnNyZU83Wk1INzgrbHlLOU80?=
 =?utf-8?B?NERkalk5YlUrbERJanYwRWFPeDdSVEJWT0JCc1dzNm5hN0JDYndEaFdUR0hC?=
 =?utf-8?B?NDhjNW5ZSmJmR2o3YlM4TkFTT090dURGMzZPV2t3TUxwdVVoOUFPeGpHek9x?=
 =?utf-8?B?S2Z6TnNKeXBLT3hGN1ZQcWVKMzZSVXhDdjZ0Q00ybXp4TkNETEJQMVE0d2tk?=
 =?utf-8?B?eVpkTDdJVWJ1NTBQWHZJRFpLWkhwR0lCcnZBc25Ra2gvQTVrSTJxenVNTkZ0?=
 =?utf-8?B?LzFIdFVjbjNhRVBtWm5vSUFSYUtVdlk5SjhhYkZjZ0xvTUc4Tnp2djFKVUxn?=
 =?utf-8?B?VXhrQm9zQ014R1BnTWRyTGVYd043RFZHdC9obXlydFdSRVd2QUlidzBEdGkr?=
 =?utf-8?B?c3d1OWk2cko0d0N4U2lReklrN2RDNlV2dFJBbzFybm9Kd0R6d1UvVW9SSmNt?=
 =?utf-8?Q?4n4iob2J1fSs5dySL5rBeRObk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075f0f56-15b1-4741-0550-08dd9160108e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2025 14:19:53.7044
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jrNg3PILnNzkti+dPbh6SxwZ95s4pjABG93MuR5vQWNSlZ4hzuBxZvjMGH5Qm3peWubhFqzACj0LlrZ3vuTNjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5149
X-OriginatorOrg: intel.com

PiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9LY29uZmlnIGIvYXJjaC94ODYvS2NvbmZpZw0KPiA+
IGluZGV4IDVhMDlhY2Y0MWM4ZS4uMTkxMDdmZGI0MjY0IDEwMDY0NA0KPiA+IC0tLSBhL2FyY2gv
eDg2L0tjb25maWcNCj4gPiArKysgYi9hcmNoL3g4Ni9LY29uZmlnDQo+ID4gQEAgLTUwOCw2ICs1
MDgsNyBAQCBjb25maWcgWDg2X0NQVV9SRVNDVFJMDQo+ID4gICAgIGJvb2wgIng4NiBDUFUgcmVz
b3VyY2UgY29udHJvbCBzdXBwb3J0Ig0KPiA+ICAgICBkZXBlbmRzIG9uIFg4NiAmJiAoQ1BVX1NV
UF9JTlRFTCB8fCBDUFVfU1VQX0FNRCkNCj4gPiAgICAgZGVwZW5kcyBvbiBNSVNDX0ZJTEVTWVNU
RU1TDQo+ID4gKyAgIHNlbGVjdCBJTlRFTF9BRVRfUkVTQ1RSTCBpZiAoWDg2XzY0ICYmIENQVV9T
VVBfSU5URUwpDQo+DQo+IE5vdCBzdXJlIGlmIGlmIGl0IGlzIGV4cGVjdGVkLCBJIGdvdCB0aGUg
Zm9sbG93aW5nIHdhcm5pbmcNCj4gZHVyaW5nIGNvbXBpbGluZzoNCj4gV0FSTklORzogdW5tZXQg
ZGlyZWN0IGRlcGVuZGVuY2llcyBkZXRlY3RlZCBmb3IgSU5URUxfQUVUX1JFU0NUUkwNCj4gICAg
RGVwZW5kcyBvbiBbbl06IFg4Nl9QTEFURk9STV9ERVZJQ0VTIFs9eV0gJiYgSU5URUxfUE1UX1RF
TEVNRVRSWSBbPW5dDQo+ICAgIFNlbGVjdGVkIGJ5IFt5XToNCj4gICAgLSBYODZfQ1BVX1JFU0NU
UkwgWz15XSAmJiBYODYgWz15XSAmJiAoQ1BVX1NVUF9JTlRFTCBbPXldIHx8DQo+IENQVV9TVVBf
QU1EIFs9eV0pICYmIE1JU0NfRklMRVNZU1RFTVMgWz15XSAmJiBYODZfNjQgWz15XSAmJg0KPiBD
UFVfU1VQX0lOVEVMIFs9eV0NCj4NCj4gSSB0aGluayB0aGlzIGlzIGJlY2F1c2UgdGhlIElOVEVM
X1BNVF9URUxFTUVUUlkgaXMgZGlzYWJsZWQuDQo+IERvZXMgaXQgbWFrZSBzZW5zZSB0byBhZGQg
dGhlIGRlcGVuZGVuY3kgb2YgSU5URUxfUE1UX1RFTEVNRVRSWQ0KPiB0byBhdXRvLXNlbGVjdCBm
b3IgSU5URUxfQUVUX1JFU0NUUkw/DQo+DQo+IHNlbGVjdCBJTlRFTF9BRVRfUkVTQ1RSTCBpZiAo
WDg2XzY0ICYmIENQVV9TVVBfSU5URUwgJiYgSU5URUxfUE1UX1RFTEVNRVRSWSkNCg0KSSdsbCB0
cnkgdG8gZ2V0IHNvbWUgcHJvcGVyIHNvbHV0aW9uIG9uY2UgdGhlIE9PQk1TTSBkcml2ZXIgdXBk
YXRlcyBhcmUNCnVwc3RyZWFtIGFuZCBJIGRvbid0IG5lZWQgdG8gcHJvdmlkZSBmYWtlIGludGVy
ZmFjZXMuIExhdGVzdCB2ZXJzaW9uIG9mDQp0aG9zZSBwYXRjaGVzIGFyZSBoZXJlWzFdLg0KDQpU
aG9zZSBwYXRjaGVzIGFkZCB0aGUgIlBNVCBkaXNjb3ZlcnkgZHJpdmVyIiB3aGljaCBpcyB0aGUg
cGFydCB0aGF0IHByb3ZpZGVzDQp0aGUgaW50ZWxfcG10X2dldF9yZWdpb25zX2J5X2ZlYXR1cmUo
KSBpbnRlcmZhY2UuIFJlc2N0cmwgd2lsbCBuZWVkIHRvIGRlcGVuZA0Kb24gKG9yIHNlbGVjdCkg
SU5URVBfUE1UX0RJU0NPVkVSWT15DQoNCi1Ub255DQoNClsxXSBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9hbGwvMjAyNTA0MzAyMTIxMDYuMzY5MjA4LTEtZGF2aWQuZS5ib3hAbGludXguaW50ZWwu
Y29tLw0K
