Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAB433F37D
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765991345; cv=fail; b=S3c1rtowWM6fjuNWRia7XPLBbjbO9yJvUr5+b3oCHnmUOSzrSHKdCMyx5wW6Mt0szAFD1e+g/gYow9YVnAIAKBdfD+Tu2Z2SerHcEyFpnkSzDZvt7iP1/QHwiiRnS+ReEwW4vqJ6hYwAYG/fuH1w7kn9fFgZQrh+5ZnibNgCAqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765991345; c=relaxed/simple;
	bh=HIStPOaNOXGDJZ3X3/nlu0QqPfypeb+M8N70eBTijHk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EGi9oDLgvGL93vr4aCQbKlHaWDl4FUfGWKreQb+ehTaFE9I3cXjruvoaN3HbSqZFwzVzXOd1fB0XHwFoptsDG7ZyuxHGQG1ttRRBPdJAsNnkTH9C2sbSEdMk7SczW34AYWyC+X4yMJCmzK7eDMEWTE4LV7Zrv2lQ0r6cQVNGqLM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fo/0gGAv; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fo/0gGAv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765991344; x=1797527344;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HIStPOaNOXGDJZ3X3/nlu0QqPfypeb+M8N70eBTijHk=;
  b=fo/0gGAvj7LTntDId1WuOJTN10aTZ6zfyrN0480BYoQwIgoO5fSuvLLC
   /7nkUxJwwEr4uomagWO1m/XTvnvX6cpte5acVZEJtwwVB2ruMbZOnHNF2
   zujWPJzNH0oGB4xF+Juh76qcm0NtojGWcWcFlFVPqC2TlMY2tOKHLbSDQ
   jZRN6UFNJ+KtA9rQcZTyBFhAFf632oEMumKHoOQ77WfwIn5p5LEzkErKx
   06TNbX0mBIi9U1p3F6fFIPlmIK2wY1eDmOe+47IWsQtvXrPxtAZGpG06g
   3/tFjxRSvsYB5fFjDE0tyZGmG7m+vwOASZd1dim9Ncfp0oQ0HD0vYwgdP
   Q==;
X-CSE-ConnectionGUID: l4t+7uaaShGulWbBzYhirw==
X-CSE-MsgGUID: r0MbgO/jSXGHxtOmCu0WuA==
X-IronPort-AV: E=McAfee;i="6800,10657,11645"; a="78574270"
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="78574270"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:09:03 -0800
X-CSE-ConnectionGUID: Z8/1KJfvSbasPmSkfc90NA==
X-CSE-MsgGUID: GaFSCQnRTTaJm9jkHpRA9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,156,1763452800"; 
   d="scan'208";a="198116675"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2025 09:09:03 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 09:09:02 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 17 Dec 2025 09:09:02 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.51) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 17 Dec 2025 09:09:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYuLjzi33X39iKKQDyi/21ZXQm1puGaRYqp3DTpujDX6fBE7S+xyKVyGeO6cBeSCMQtJwDKot5I+o9e93+M+Pfwbikn7/TjUnKtuvi8fkvKTFS8QX0dHc7v+sIrI4NyQ4b1o0izG8sCDX5f40VstlcZY4RXTgtIP42gpKjaEDmXO6qlxMv0RrTs9kgakau1yfY4Hi84eLmyhFVeIkg0ZRMhlWgHaen7ODzlPbDcDyTNDoTaxheydZn8u7xzxPFih9ZVx/xFFs6uefkwr01QiSGJ4sRd0TQUh6y4gJV1xJqoWKEPMF9WYxd/8wkA8PwuD1uxdqJc6cMzRAkWM8V2x/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HIStPOaNOXGDJZ3X3/nlu0QqPfypeb+M8N70eBTijHk=;
 b=D7uVNN+o1KLVHfh9LoV0T5gX0dvoQ47rus0uU4OLmTjdN8gs/EDLvowToZQBma083Qnl0DY8D6dxcds54UmfI/ZvXViad0dM+eExK+q5JPEJiF7Q1q6Gmaz6uq8LJtWaLUQL+QUbNFNHgLOHnwgKDT5y46bUJsI3+eqDKdMR9IOfJ3YUrgpSrsiy2rGB9uH9d/Sj+qe9Y8XcUrVpj/Dj4x/P/mSi8A/tYDZ5D8potwe+0SSoloH3/alrR9LASihj0ubS1bYzfZ1ScQguKrGQ2bD1XunzxkyOvKAiIZFALIPydfXu6Cri7Ri2StisG8xNWlskkvz9l2qIF3UVG0zlmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5104.namprd11.prod.outlook.com (2603:10b6:a03:2db::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Wed, 17 Dec
 2025 17:08:58 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9412.011; Wed, 17 Dec 2025
 17:08:58 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcSPAYySEZmJcLb0uXaCTwnPhdjbTZeoIAgArGzwCAQQUIgIABEJmAgAAGHJA=
Date: Wed, 17 Dec 2025 17:08:58 +0000
Message-ID: <SJ1PR11MB6083A236FB0D5697D38A0D5FFCABA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <aQJkIqj--nHzUzUb@agluck-desk3>
 <9b0d336b-dd12-4e4a-b324-75734dbe6002@amd.com>
 <aUH5QZ7_7WCRWY3Y@agluck-desk3>
 <0d137f81-b3c0-4468-9a33-e521c6790bff@amd.com>
In-Reply-To: <0d137f81-b3c0-4468-9a33-e521c6790bff@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5104:EE_
x-ms-office365-filtering-correlation-id: 83adbb56-105e-40c1-3802-08de3d8ef78d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bE13R0F6SkJYaXcwSjdESWJoNTQ5WGd5aE9ibzltZ1FBNnVJQkpKZW92Vnls?=
 =?utf-8?B?c3VrcGNzR1BrODBTcTVkQ09mV2tVM1UwaHFjQ2R0eDltajh4Ync3Vk9UamRy?=
 =?utf-8?B?ejhLazR6Ky9QVXo5cUVabVova1MrRG1vbG5uRHJFZndkQ0FLeVNkMjQwaGVL?=
 =?utf-8?B?UVdaOTlvYjY4NjluWUgrZjltNHNHVXZnKzJpTmNnaE43VE42RllvZ3pKSGRC?=
 =?utf-8?B?YzVCelZlajFrV0ExdW40MWQyUmRWcVN4bWVNZVZEcXQrbnZQUVhrTUVFekll?=
 =?utf-8?B?ZHRxUUJHS1U2UVF6dERPZmkzMGhNMmZhN0dtSTFsTDA3S0pLWXJNQmlQQW9a?=
 =?utf-8?B?SlRETGVsNEVkNnZzVk9IRkpGd1A3NjVNRjk4aHpieGFHcmluQklCcEE3WFgz?=
 =?utf-8?B?ZEtXY1h4d1FQWG5aMzlGb1piTzJjNjZZd3BYMjgzVWZMMW5qbDJNQTUyUThs?=
 =?utf-8?B?aTZ1WFNjYnVTMndydnkyYTExQ3hjeElJMDRqbXNQYUsxYlZsS0grVWxtQzhx?=
 =?utf-8?B?blB6Ulh2SEkwTU9xMXFHenhUUzNBTHVCeUpTVnZHeEdIdHJ4OGJCZlM4ZU1F?=
 =?utf-8?B?b0hza2ozYXJ2RU9Wb0RkQlZ5SFM1alI0U0dlS1M1UHpkWHQyazFiR3FqUWpx?=
 =?utf-8?B?WHZVRll3bmN1V2VvUDhGcGxNUGxkMHhKaTB3cmtNM3RoZllHeFl1WFZJYkpE?=
 =?utf-8?B?cUxCOHFNT2FZekIvYlQwaG54M1Z3U242OTFqa1UrTzNmdy9HTGc0ZmtRQkh3?=
 =?utf-8?B?K05sbE1tU2ZPbnN6MUl0L2VkS3JHZzk1SG9pNFViY2ZvbWRIUTA2OU9oSWpo?=
 =?utf-8?B?eE5XUDFMUDNUN045cWlQclprWkdjQnJnUTZvVEFldmU4Y1M2bUhxL0tXOGtZ?=
 =?utf-8?B?T25WVk9EK2JQUjhBVXZrdU9RdERidkxRTGtNQzJBV2hnTXd5Skxaa3RJYzVz?=
 =?utf-8?B?SkFibWFIenBQVWx4MmRVeWFFWFBpaHE4VVlZTzlJR0cySGVJdFhnUmgzbW4r?=
 =?utf-8?B?Wkc1Ukl6Q2lnRDJObWRRb0w0SHg2cWcyRE0wODFFK1M5QzBsOXlZY1lkTGNZ?=
 =?utf-8?B?WlVOWFlFdGNWNmJVUWZ5cnlBdzRmR0lMVmx2WFBGcTdiV2NHSzJVaGdSR3NX?=
 =?utf-8?B?YUV2NXFpVHM0WlFKZDRyOUtNdU5CSTN1TlVVekovTXRwenpwMWNVMTBMY2hO?=
 =?utf-8?B?bGdyZGRwZi9IbnB1Z1BsMG9tVWhpZ01vZzdmY2c5V0dmeFVrbGZzWlFGZ2Nr?=
 =?utf-8?B?QzlWSEw3V1BqNzc4dm9wMlRhU0dRWlFSZlZwWFZZaHM4U1Z4TWJ4ZlA2KzA0?=
 =?utf-8?B?OVpXbm9rTGhiK3d3RUY4VXBUVXhZNEpSQ0hFaDdnRzNwcituMmJ1Z2RJLzZP?=
 =?utf-8?B?V3pkWW5leG5iNWErRnFyY1pGYkY2Q25ORk1vN1pxalRnVUE0OUdMTWxCdWho?=
 =?utf-8?B?bWlSQnlqQ1RCbWRTaHlsNFpjeUlibHc1NjJ0SUtPZW96QUdwUWRnTWNyQmJw?=
 =?utf-8?B?MnlUSjBlK3JYSlF1QmR1bWw4UzZESTdXcUk1ZFg1S2RzbWU1UXV3T2xmd3gy?=
 =?utf-8?B?cEdEWUNpaVlVV2hDalE0RzNxSHlUb1dKQ203Y3BzWHlQYXFiaEdQM1AwQU9R?=
 =?utf-8?B?eVlJY0tSb3VXdmdseEJrdmJWTW9WNGx4Y0UwM2k3M0JtVFNTYkdTdFFNV0Fx?=
 =?utf-8?B?UERvK1lGVEtFV0pmdGVWM3ZDanZkWEdrM0IvUWFIVE1GdWNUVEg5bjZqSTNI?=
 =?utf-8?B?c1BzZlh3QVF4L1Q3dlN2eWgrSFp4a0tEbE9TMDNaQzNrS0lncnIvZXB1S3dG?=
 =?utf-8?B?T2h6VzRXNENDUU5PNlNJbW1CQTBqTjJrK3RQRFhEc0RLcEozNFhCSXBDVUJF?=
 =?utf-8?B?OEZaVDE4MVNGYlBvdnlEdXhWaEdPRDVHZ25zR01mTnUzeitxYzk5Z3JxcW1Q?=
 =?utf-8?B?ZEdmV3BaS3BRbnBWZVVua0d3VG42UjJCenRieFRTWEpmR3dRb2t2SFVqQzhs?=
 =?utf-8?B?ZXNyWS95VUN3cmRQNmF0akJzazNIdVZyVWl4Q0J3RW9SdCtyRk5SK2QxR085?=
 =?utf-8?Q?EkHzPO?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RVRvQ3U3dzhKbHpjaTh1NWFWbTFlcTdFVEJiWGZycjhHZDlPOHdmZzhJM0Qy?=
 =?utf-8?B?K0NwWngvektQTEhEaHkrL3huSnhtYUJ5NFMyQkR0OU5JR3BUalRnZTJHaG9p?=
 =?utf-8?B?QXUxcExjZkM4eXE5REhReEhidVI3VWZEeU9LUnFJUnAwUmxpR21DS0VvYk5I?=
 =?utf-8?B?MEwyVkhDQUtuSjk4ckVVYzI5TU1RRUJnWnppa2U0UU1uazRxUmM5UkZ2MnBF?=
 =?utf-8?B?VnlnY2dZY1d5ckZodWN4VVNydVBObU4vT2JUckd5czJKRFpGWkZrcDkxL2N0?=
 =?utf-8?B?Q013bVdWZWp5TkpnUTJTdkFwZDU3RjhLRTlzVHFjYTBxckNwemVObVNRaWlq?=
 =?utf-8?B?dUpMelBnRjgzZWlXMmowam8rQUt3ajgwWTM5c2JJZkhxRGQ1UGJpcnR5Z0F2?=
 =?utf-8?B?UFlWRlVXQXlQR2V0YVQzbndSeExmUFk2TnIyd2dxSG04T0ZrZFpzM1doYnIr?=
 =?utf-8?B?UE5DRm1JZGdlM2JGVWVCcXkyMjBLSXlkSGRuOHorcEhac0JhNEZvaFNvM1NU?=
 =?utf-8?B?dHUwS0Y2dzd4QVBDQk5rRUNqalRRSzRYVkZWVmFUbWpzS05KTzZXZWw2RWhB?=
 =?utf-8?B?WXUxT2paVVYzSXdXV3BCbEsxTXpFcWZQTy83RGpnRno5cU45NkRwdTJPMnA3?=
 =?utf-8?B?Q2JBNW15WWFtTVEzV2NpS0hjZUR4UEppMTl0NkNMZ2x1RFJpRHM0UW9KNXZn?=
 =?utf-8?B?TUF5Y0ZKOUgwV0VsZDJyWWl1ellvdS9MRE1NNUUvRVVYZThFWm5WUE8wMnZ5?=
 =?utf-8?B?VTA1M3RLb1JOaWYwWFo4eHhjMTc1SENpZ2hxYU9xUTl6dHJmczlmVUNSbUU0?=
 =?utf-8?B?WUxWN1AvbE9UT0hPcTIvM1NtK05KL1dML0FhdHZ4RmpiSXdsOWNUNXM3Wm93?=
 =?utf-8?B?Zk1KNi9CTW9IbGcxcXJmOGpHYWxzN0JUK2pja3AyWFl0Tzd1Q1Z4QnFPWnM1?=
 =?utf-8?B?WHQ1eUs1SlQ2YTlGblRLU1QwQ05JNEh6WUlrcW5LbjdTbmp0Y0NaYzVxN2NI?=
 =?utf-8?B?cVdXWXBGTmh5elVlcElTMWlHOUVFVE1nOTVQT0l0V0NOMmI5ZVdST2tlMWtz?=
 =?utf-8?B?V1F6WFpDcFdPc05Ec0x5NUltTFZ1NG5aalhveTZ2QWZlR21PNkNSUjB3UlBp?=
 =?utf-8?B?MllJcnhuQ3pZVDdyS0MwQ29VUFJUR1F5TmdEZEVBbTRlQ05NSFNHaGp2SDA4?=
 =?utf-8?B?VHVrRFRwb3FvSnV4S0N0bDRTRTFoT0s1cGdqL0FJQUdBdjBURjFMelZDY29p?=
 =?utf-8?B?elVXTHhUUmo5MGR4TSs5RnpvRVNrUS9oMmVNWlREangzVEwvL1VxRkhYUkZz?=
 =?utf-8?B?cytXbFA1NWRPSTh6alN1VnBRbjdSYlZJd051OG1SMG42REpaajhvRW40M3Zq?=
 =?utf-8?B?UTlFcDZONmtJeTd4VkNPSTg5Yk1NWkRiS2RZNmtOZEdaR2dJcVhzczVGSjU1?=
 =?utf-8?B?eHc0YWZDQUxHc2FDbkkxTWV5UGdoQXh0Rmszclp2VzIxOUVCYllmN2dzc3VK?=
 =?utf-8?B?QmxtQ3FUZlB4V2ZPL1hTeXNTaWtZb2gvN1R3Z2tEUVh5NitrWFg0NnF1Z0VF?=
 =?utf-8?B?N09kMXNjYjJsVFY0Q01ZaWNVUDNMN21GMVczMFBPdHN3UkRIcEFVSnNjNSth?=
 =?utf-8?B?cHBsQVowNTBLbFJ2ODNIZGNGdE9QcktzbVZ2aDVycXpyYmZZYS9GK1RYYk5D?=
 =?utf-8?B?N3MrZjYvdmdmMzM2UVA3VVNyRmFjZldQMzVmMG1qY0FwSGU3OU1vREFpZHhV?=
 =?utf-8?B?eldjc2lCbHBKbmx2SEhmWEpxVXRsSDZLMXpPc0hXNFFYSWZEQXFaRU9IcDVr?=
 =?utf-8?B?dVZxTXFYRjlrZU9SR1RmQzd1YVRZcXdaMm1mU1J3ZU1rcUJXcDJ3Z0FadUli?=
 =?utf-8?B?UDBrc0NmcGJhUENoNTdvRXJIdVZwaVlGV3lUYjZsamV0M2t0ZTltOXBhZFEw?=
 =?utf-8?B?TmpneFBMN0IxemdvbFNpYjlaYktzT0lQV0ZXenlQVmRDa0JTR2FmdGhLYldJ?=
 =?utf-8?B?Sk9GZzdNZ1U1S3UwZkhhaSt3VjltM1FkYkhpMjlyd0haNW9yK0xFKy9wc1NL?=
 =?utf-8?B?eGk0UytJTlRGTW92bXQ4b0JRYndMTXF6azc1Nll4SzJWdlRJRXVoK09KUmJm?=
 =?utf-8?Q?WrHFlaj4fzADzMRu11ob5p1Vm?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 83adbb56-105e-40c1-3802-08de3d8ef78d
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2025 17:08:58.0982
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RF4K7jcqRSjXc6KWaIAMHylR2RuPp3JWda7IgD3Tu8Y7v9GMwieCH3ESPRnQip/JzPiBP6Be9KrvOb894Utqnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5104
X-OriginatorOrg: intel.com

Pj4gJCBjYXQgY29yZV9lbmVyZ3k7IHNsZWVwIDEwOyBjYXQgY29yZV9lbmVyZ3kNCj4NCj4gUGxl
YXNlIHVzZSB0aGUgZnVsbCBwYXRoICgvc3lzL2ZzL3Jlc2N0cmwvdGVzdC9tb25fZGF0YS94eC88
ZmlsZV9uYW1lPikuDQoNCkknbGwgYWRkIHRvIHRoZSBpbnRybyBwYXJhZ3JhcGggdG8gc2V0IGEg
c2hlbGwgdmFyaWFibGUgYW5kIHVzZSB0aGF0IGluIHRoZSBleGFtcGxlDQp0byBrZWVwIHRoZSBs
aW5lIGxlbmd0aHMgcmVhc29uYWJsZSBsaWtlIHRoaXM6DQoNCiQgY2F0ICRkaXIvY29yZV9lbmVy
Z3k7IHNsZWVwIDEwOyBjYXQgJGRpci9jb3JlX2VuZXJneQ0KDQo+IE90aGVyd2lzZSBsb29rcyBn
b29kIHRvIG1lLg0KDQpUaGFua3MNCg0KLVRvbnkNCg==
