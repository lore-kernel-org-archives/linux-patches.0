Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2F67345B
	for <patches@lists.linux.dev>; Fri, 28 Jun 2024 21:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719610568; cv=fail; b=fE47S1K9UnRRqv02my32dPWyB3iJQtZLoaBSeOuI57guuS73JdcKZBML4yppzKYv9dx7pZgEuMQsf1itTT9LWN2tbafUsE3Dmxga29EbMSeZqc9i3Dgf9JKc3NimEFHfxJ9Q+VITU/tfEln/1u9BMkse02/mzD/pQi5Nt2zQtXk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719610568; c=relaxed/simple;
	bh=stS38gGb3XJ2e1H+pI0uzBDUA0F8pfu2kpU3koEGN7o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=uVv+Fz5oANeffH/MqOgXxF26b2n/eM3J4YgeuRCRBWm9+3RJpyoorR5vuoaSWqBavyjrb6zmmQ5YiOtDk6FOraFO11vN9IBV0KUXl8kYFHiTQUV7chncT6WnjBhsCkErUi/sXRg916SX2OpHLFJZFME2skEvE41Bsnzg7Y0abQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CBHfNfK6; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CBHfNfK6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719610566; x=1751146566;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=stS38gGb3XJ2e1H+pI0uzBDUA0F8pfu2kpU3koEGN7o=;
  b=CBHfNfK6BiU7kpq2VTXyjnNV9BMAW8yWus7NEM9v5TyM+nEm8PpHs+Dv
   RdrSCamqcWsyUJ0u3RwahkMhLbEQuey7pDqFNsyU/K53EpbpdGFpwpfoQ
   EaYO70hs40yoSVLwihjTetj0dDdQFsV3hkw1MGbO3x6KoFOzTP+QfBtha
   9iWzCyJRaHTgwCQFsPtBhzR00GozFI8t5kKN50qWFNu+JMgxJ7YoJENvm
   hmELHc8/TzI3tARUvVD7bUbiQJaK+A15onGNBpguAj0FlwlEtVlKesQhD
   XT9/OA+qATW4HBGdSABv/BjGqR7srN/SASA/42CxEKU36kg49gkyKS+lV
   Q==;
X-CSE-ConnectionGUID: LFC4zSpvQUKqmlydVAs39w==
X-CSE-MsgGUID: Yx2H2KycS8+tdc49AmF8Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11117"; a="27939580"
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="27939580"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2024 14:36:03 -0700
X-CSE-ConnectionGUID: Tvv7JnSITXGpJtWtzU3/XQ==
X-CSE-MsgGUID: 2nMXUW/1S4qHDNa0UPDH7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,170,1716274800"; 
   d="scan'208";a="45526427"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 Jun 2024 14:36:03 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 14:36:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 28 Jun 2024 14:36:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 28 Jun 2024 14:36:02 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 28 Jun 2024 14:36:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MztjhOC0Y5TWeSrrNI3JtQ2KzVDHuEAgnfl3UFvciM3/S0czHbrgokiDRmyoNmGcC5TWhFq1hNhgPgZRIM+pu4YselrDRAB8ICUau9ND3Cj0GJVlQuhzLy+xwC7hYxmgDsTV5HCQtkLh3K4kVKyxloiCWaM8uXPcvVKDXLJloqXOR85uoLCWQJFQfuRe7Uw3F1Xu3UNGawzZGk9zONpRAorRFITihDH0UhQWlyWyv8aIpxEApjW0dBJFHSt2QWu76LpUQB17rglAEaKMGrcYnJ5AKAlBNWzBbLKk4CloaysiE10phBkG4jejJ4n/9y2BJw+/qEkw+3pdjR9wSzhY5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stS38gGb3XJ2e1H+pI0uzBDUA0F8pfu2kpU3koEGN7o=;
 b=RGEYx7qzFAWUr2lEvyWoz/uC7LB/bKAE6KC6PVZ2vxWyaGg03oIPsqZIlomQzOnFOGhVGm10rDCYbnOae8n379p/Tj3G+FJQn64Qd6ppQmIqzcdg/0fu2Xo8hpwX9bTzlEHaCPE2/jSmvW2BBOLuhC+dVhepYf0It74GfU5xAfURVx6ewk314uoOIaDsC99V/rzVsHHWNnyaWoBsvnBmqqNds73HbSrx9UkE7UFQvym9h8vseypwld12of6TXwIIn9EwYlHtqEpBy9dZmtYfQ3Fjf+8z7N1kuWbYHBKPLq4je4rZ0Dju2za/PFDX1XkF0psw3ArrK9JuiNUi/a4mEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB6543.namprd11.prod.outlook.com (2603:10b6:8:d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Fri, 28 Jun
 2024 21:35:59 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.7719.022; Fri, 28 Jun 2024
 21:35:59 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v22 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
Thread-Topic: [PATCH v22 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
Thread-Index: AQHayNIUOuWzEIiuck6G9kjcBMOxI7HdqP8AgAAJS+A=
Date: Fri, 28 Jun 2024 21:35:59 +0000
Message-ID: <SJ1PR11MB608394AA9279A8BC9134E61EFCD02@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240627203856.66628-1-tony.luck@intel.com>
 <20240627203856.66628-10-tony.luck@intel.com>
 <2b155124-1a82-4a23-8de5-0c4f5c89186d@intel.com>
In-Reply-To: <2b155124-1a82-4a23-8de5-0c4f5c89186d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB6543:EE_
x-ms-office365-filtering-correlation-id: 72d35c9e-5870-4869-cab0-08dc97ba4d2c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RmlVbElmeld0bkdIdDNVdi9MODVnM0RKTUNhN2d6TDBJdER4T3FCb1oyMmZJ?=
 =?utf-8?B?b2VPekQrdjRHRnkzeTE5TFZHY2xjd1lkNGk0OW01N042enNjVVV0NVJ3K0tl?=
 =?utf-8?B?MW1yZTAzK2JYQXc5SUFYanFmMWxtYjVRUXhhUlRIUm1reE1VMEo1QWtiRXo0?=
 =?utf-8?B?ZFNBdUdOUzN6MkV5Smg1SERpeWJrTFdFU3NpWnlHY3FYQjJnbTBzY0NhMjZB?=
 =?utf-8?B?QlBmL2Y5aFlEenB6aDk3VGFSbWxTSjcreklidWcySzhCWWZWRk5KWTZKRWk3?=
 =?utf-8?B?eTkzZURjR08xQitpQWVCRzF3NUsvNVJUUlljMXFHSW9hU3hMSjhwbEk3bzl1?=
 =?utf-8?B?YU9CSTNTc1M4VVFPREp5dWZqcWVCTEU5VlRSdFdiMlV0NTBPMkhnMzBZMXpz?=
 =?utf-8?B?NHVjdnZpUEFqbWlGT1gvZkIvNUJZdTV3MnZsa3V2cnhVOG0xRWdWZlpzY29C?=
 =?utf-8?B?ZitMb0VEZVlRRWxxRU9qWkdkbFlFYk56akMzODJGYzFGbDJWWmRPanFLRjN1?=
 =?utf-8?B?MUk1ejU5V0RjK2ZWM0tLZy9Kc2VXVFZmemlhWFlEcExGbWErVVdBbGNSbGNs?=
 =?utf-8?B?RTJZWXh0ME96Skx0dG5BMXNDSXBESTF2SGVlSmQrSUEvUlN0SWxpZnlMUlUy?=
 =?utf-8?B?SXFsOXk0Y3VlL0VRYnFpTUh0RGJkVHZ4OS82ODFUVURzVG9YSmhkUy85OHBu?=
 =?utf-8?B?U01ZNzlkTWQyYjJkYkxMTDJENlJKb2ViQkZQSllQaVpzcU5QOGpBeEx5M3R0?=
 =?utf-8?B?MnNBcUxTZU5ZNVlCZTZKQXA2QU8zTFFTei9nTUZCUzg1bVBCYmx6SEhiN0lm?=
 =?utf-8?B?UHh0cWZnQldFeVZ5bXFhL3VtS0J4dGtidlRzdmFkYkNQekRmQWl1WWt6bkl1?=
 =?utf-8?B?VjJIQndSVlc0QUsycG4xOE1EVUw0TzRHRDY3UlNYalhVVjBqNVNRemJLWXVT?=
 =?utf-8?B?M0QydzVRTUZCTVdrSDR2azlVdCtqYjFuLzVDbHRtSlJlY3VRYlI2aUdhcnBq?=
 =?utf-8?B?V21kS3RPbXZmSW5wa2dPTmpvdThic1BZWTNSU3ZvMEx5MTBUbWtPYVZxMkps?=
 =?utf-8?B?N1BLRDZQV2xocUZkZXNML1pWNjhaQ0ZGeXAxelZPNkw3RDg3R2JPNUZnbW9J?=
 =?utf-8?B?Wi9mSHhwRGJoMmQ0NllkdmIySU1pdkdVNDFlbTIxRXlqbEpVUHpKUUIyN3JK?=
 =?utf-8?B?Mk9RbVdvYitZWG9lSW9aV2tFUWF1SU8xa3BYYU1wYXYyejdDKzlEeGFGYUZr?=
 =?utf-8?B?NmYwcWNjR0NVMkZqbnJPVWQyd1NuM2MzaW8rUHBaQmF1MlE3c045bzE5K0hv?=
 =?utf-8?B?U2p4Q3NyUjErcVRPWWk4TXpLTDk4RDJlcTFvVW1VUlNFSGxxZktsUlVKd09n?=
 =?utf-8?B?eXE3MS9XeC9scENlWjZha2h5cDRLTkFsU0xTTWhJYXh5UzlwVmZvcFV4UW4v?=
 =?utf-8?B?WFdyc0dIL05rM2IvZGVTVmxFRXVweEdEZFRqTWltNXNSV0pVTXREVHBlVEdO?=
 =?utf-8?B?bnZ2Znp3VVRRQVlSY1dXeDhURHdkUWc5WXd1QlV1SVY3K1JaV0duODB0ZnAr?=
 =?utf-8?B?alpDdTBnRXppZ1pwMWZLZ0RWTGtPODBPVmMxRXRoa3pEQkRKaE5wdmNBZTFM?=
 =?utf-8?B?YlppQjI4dU5tcjdVSlJyYXdMNzFVZ0FSU1h5L3BzcnZwUE4zMkVUanl2Rlk0?=
 =?utf-8?B?WGw4eXlLaTlydnhzS3BkY1JJUXhKMWVqZ05JV2hhMWhxcVhOcjYvQjFRZXJx?=
 =?utf-8?B?SXZ5empMa0VScGdiVEtJSlFjT0pUdG02L1ZTZjlEWVNqOSsvd3FxMVRMYzZN?=
 =?utf-8?B?eVFFdWZqNHZyaE5sREw3QW5xUHZMNkg4RCs0VElGaWZjRDFuMC90YmZ2Zmx0?=
 =?utf-8?B?WWhwSGFoOW5KWW1oWTZacWZzWVVDV0RCUkZ2RWE5eGtFS1ZlQzdWTGo4T09x?=
 =?utf-8?Q?cLnTvv9SHBo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aHBNZGVCVFpYck9LMEo4UExqM0hJeENFb2FIZEJZSmZUTmhYM0dyc1dIQzJ0?=
 =?utf-8?B?akRiSVFZVnZDUnJmNGhmN0JwQ1pHZWc5MU9IempLSUhvMHVCbGV4ckZRVmpR?=
 =?utf-8?B?WEdZTnhnaXByUlp2V2pMb3NDRWJDd2RrcUdSODBscjc4M3JSYUFjSWx6eVQz?=
 =?utf-8?B?dUNYcDFBbnptYUhZQ0lYdGc3dTVTdVlWM0NHZnBTVTJxcUl0bHFjcU5jTzZO?=
 =?utf-8?B?M2o2Y1k5RUxpRmRJTVdoYWZpN1NNS1hEZmtnRnNabC9IYkg1RWtuU0laRTVU?=
 =?utf-8?B?Uk1Va2hyeWFiWDVXenRXdnU4VkFKNkZEczMyUnY4NldXK1pZY1czZXdmZ2dI?=
 =?utf-8?B?aHVQQy9xVmNOQlYyc3lmY0MydDRNaVpVVjFPNVlyck5nQlI1UVp1RkZCaU54?=
 =?utf-8?B?MVpsZlg1bXZmWGVJd0gyQ3NuQ2xaVWdjcEt5L3Q3V2MwWDBreWdNUFk5Qkp3?=
 =?utf-8?B?aC9kd3dCTW0ra3NUalZPakJ6OWdaLzlWR09YU1BpY1RNbVkrYk5waHFyVTcw?=
 =?utf-8?B?dDhDT1ovbXdvcHJOTGQ4aFdsbTFhN2VJZDA0ckVrRnYvcXpGeXMrMEdjNVor?=
 =?utf-8?B?SVRXVElvbENnRnRlb2ZaY1dlNVlyNlR3eElJS01wMHFSU1dkZ0NIVVd3em5i?=
 =?utf-8?B?UVJ3am0ybjBzSHBMbEx5bnE1V3IvVXB1bnh4T3cxVEhCTUtIYTUweklKSGd2?=
 =?utf-8?B?VnluQ09Idi9OQ2VBbVg1Y0NMMDFKL2ZYMFRYaFF1c0FHR3VVRjI2cE83SlNJ?=
 =?utf-8?B?NFg3MHk1bnJIQ1FueE1SWS9HZWI2bDdkZ1o1TTRFQjVGVFRDL3NoVVZIMjY4?=
 =?utf-8?B?UGNzcjhaWDRsZi93R2dEck1VOUd3T3NpbGFleGI3RElNcEZrMEt3b2s4UnZM?=
 =?utf-8?B?VXZtUmtDOG5RSmxUVXcyU0thWXNNV2lENEJSN2VreCtmVnBYVW5RZXFvVTYr?=
 =?utf-8?B?ZUY2d2w3MWNWRWgzQTl3cWQ4L3Q0dTZvbUloZ2JxNFkwbnFYWnJRWVRvM2pw?=
 =?utf-8?B?NVJlV1NsZVFyVWlUS2o0Y3d1bDBXSDV1QU9nbnlwN3lpM0Fsbi9WK2FXYmVH?=
 =?utf-8?B?NHJ5eGJtUHhqV1U2TXFybi96RXE0emFOSlR6MzZxN21oS2Y3djNrZlRQSmoz?=
 =?utf-8?B?UjRrWGxjS3hVZ1BPZk80aEpmZGJValBPWjZWOTI3YkJ6SHJxV3pYTWUyY1Z0?=
 =?utf-8?B?Sm1YZndSekpOdmhURTkwVFRMOFlHWTZENVgwS2VMK2N1OXpBcWp4ZzBDQ2Rq?=
 =?utf-8?B?OXBZYzNMNk8yYW9GaFJKWDBxYk1nSE0xdnZIUGdUc0tOTzJiMi9TaXgrWmRE?=
 =?utf-8?B?Sk1yVjFwMGllR2FGNitmdnUzQ1pPM1liZFllSmNFSHRJTHdab1JKRnhyU3Nr?=
 =?utf-8?B?OWIwcEJLc2tWMlNXYk5aZ3l2a1BTbkZ3Mkh2bVVuSzJoRXUwZmlnZk5zRVht?=
 =?utf-8?B?eW42dGJYd1lMV1Q5YXRPbUtHc3lQR2lZU2VPTUd6aEFmNU9FeTNlUlpMczV4?=
 =?utf-8?B?WkpHZSs1dndmVkN1NWJ1RmFsNm1UL3g5alJrMzhIbzhOR0Rmam9aa2NKaUFo?=
 =?utf-8?B?S2NVaTg5ZWlkYTVCT2pQZWljSHNtWFRhK3lxNFRRQytKeU8rQmwwWlZucmR0?=
 =?utf-8?B?OWZnaDY1VUdXeUN1bHcxRWwvaWZlSWVyS09wRVFSdk9zVCtjTk5ScnNueFlp?=
 =?utf-8?B?NTBLMWZsM3dSZXNnNUhtVVZCWkwrNVVBd2h4ZkU2NDUySk93Qk0vOU8zd2cy?=
 =?utf-8?B?Z2I5RkxkMDdpSjdsL2VIT1lJVUFyYjBwb0s0bnUyWU4xc0diVVdOTmxXSS9X?=
 =?utf-8?B?UTNkKzBTQTlkSUZFZzBHMllMc2VvVnRTb2tPMnFFYWNtYzU3WlVSYWNXRVY0?=
 =?utf-8?B?SFJwajFmbUNxQWtSeG43OFZyd1JWbk5nZFY3TFhkek43bGNGR25JU21DeXll?=
 =?utf-8?B?ZlB3T29CV2VxbmtkN3FkT25FNU9UdktxbGRJRi9Ib3R0SkFncTgzcDJ4dHJ3?=
 =?utf-8?B?a2JXd1N0M0tXR0VwV3lVN0RPYXhtamhCWWRvUWFYWnBSYkdWeFo3SnVYVWJT?=
 =?utf-8?B?RklidTZHWFkwcGxJaGQ3cHBkR0hvTmltSkRBWTJkMXZRdEo3Q0xFb2hRUWM1?=
 =?utf-8?Q?HKPiB7/0u9WlIMj7l7ub4bTym?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 72d35c9e-5870-4869-cab0-08dc97ba4d2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2024 21:35:59.3915
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FX8FfYlWd1qJYsC4+ZjxD2CjpvusJZweIRU6Ly76cdHlKJWoPe83d9Mpl3kN5Zg2C7JbRe1hwwBcdFLOogTATQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6543
X-OriginatorOrg: intel.com

PiBGb3IgZXhhbXBsZSwgc29tZXRoaW5nIGxpa2UgYmVsb3cgaW5zZXJ0ZWQgYXQgdGhpcyBwb2lu
dCBpbiBjaGFuZ2Vsb2c6DQo+DQo+CVRoZSBuZXcgc2VtYW50aWNzIHJlbHkgb24gc29tZSBzdHJ1
Y3Qgcm1pZF9yZWFkIG1lbWJlcnMgaGF2aW5nDQo+CU5VTEwgdmFsdWVzIHRvIGRpc3Rpbmd1aXNo
IGJldHdlZW4gdGhlIFNOQyBhbmQgbm9uLVNOQyBzY2VuYXJpb3MuDQo+CXJlc2N0cmwgY2FuIHRo
dXMgbm8gbG9uZ2VyIHJlbHkgb24gdGhpcyBzdHJ1Y3Qgbm90IGJlaW5nIGluaXRpYWxpemVkDQo+
CXByb3Blcmx5Lg0KDQpKdXN0IGNoZWNraW5nIHdoZXRoZXIgInJlc2N0cmwiIHNob3VsZCBiZSBj
YXBpdGFsaXplZCBhdCB0aGUgYmVnaW5uaW5nIG9mDQphIHNlbnRlbmNlLiBEaWdnaW5nIHRocm91
Z2ggbG9ncyB0aGVyZSBhcmUgaGFsZi1hLWRvemVuIHBsYWNlcyB3aGVyZSBpdA0KZ290IGEgIlIi
IGFuZCB0aHJlZSBkb3plbiB3aGVyZSBpdCBkaWRuJ3QuDQoNCi1Ub255DQo=
