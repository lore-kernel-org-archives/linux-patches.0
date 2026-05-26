Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49CFF3C2B84
	for <patches@lists.linux.dev>; Tue, 26 May 2026 21:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779830797; cv=fail; b=s54HjkXY2k9GRz/b1VlUfsKZgiBPdiORIZDRTqnNsPgi9t1IMy+sw4KfM3B7FWoAuHFAG66C6+4NCdEyxc7HOYf3fCkkQoov/drEzjghwINvEkZhrNZBi+Cv196aqo43FKT1ewom7VK5kqikXWLur4uorYDBT04VZOGvwp6I35U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779830797; c=relaxed/simple;
	bh=B77QSfoLl4kTjXLDH3ssk+g6Cj0XaNV0A1NrgXsYpD0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jzPxLQoq8efWgHStyXbbNtmOMeBaMOoUBvPm3HAMRzFI+pR8yxj9wtQOwnoU4lYvMbXf3WknUrwDQf+HVUaFOB+Sy3JYoh2wjgzW5pZDl17hqoyEMzlytLlTf5vuKGWFMkG1xqgD8xpVw9MyYaARJvIq1wJ2eBWoqlQ8qpBvek8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mp+dMV0T; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mp+dMV0T"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779830792; x=1811366792;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=B77QSfoLl4kTjXLDH3ssk+g6Cj0XaNV0A1NrgXsYpD0=;
  b=Mp+dMV0T0ITSuw5E1QSEgqyRsidNgqyT56WJZxwd4O27+Eilsne2JKEd
   35NdUOtuIcOBNt34wfw6T+xw8AfJ8D7FV37HzFfe25FaP7Fmla4HYQpww
   EpzcTBeEMS5VYFuXWmIO4yyiB2lXJ2bZxN9avmk+BCbedYmwAie4qTLql
   leYu0BxN23KIZd39bLpcsrMOBSLtEq1+puJIRQcbUyVUJ6IhcKV+1l0Wb
   gF4qDqq/BA9woYMK7ofPOLi00rNotxZpbmPvksUAT2gbFzwQPeC8lZAFS
   8vBj5nO9hqk1WBqfUTqfW5Vlwam6klLeTWquNlavgnpZziHfcEJJJBmYW
   w==;
X-CSE-ConnectionGUID: qnQr53g9RuO53nQ8N0Xj7g==
X-CSE-MsgGUID: BB18cWLtS2eAYUTYHlXimQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11798"; a="80640316"
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="80640316"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 14:26:31 -0700
X-CSE-ConnectionGUID: oT7kM+zlSiiHe6MiIW8mjQ==
X-CSE-MsgGUID: awJRzWO4TUW7oMOW7Qiuew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,170,1774335600"; 
   d="scan'208";a="243859530"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2026 14:26:31 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 14:26:30 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 26 May 2026 14:26:30 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.40) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 26 May 2026 14:26:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jvSSVqX3fG1Zsi6j3bFjbpAwauiNs+uXW+gviXuyDZx6Q5I0yvR0KvjgF/lMk8mmU8hAiPhd4jpBlVK40R+IOvBi2/433446cbZwQ/kFLniQ4ZKkuAT3dUbBi+XPvHOb7WMYBzlpQEhFWwvDLrKPQbb100N8roMo3MZIOOFWBh2w6YooWsUY7xUYGRL7f45ko3iNKmvv8KrlMVbM7rg6UmCkmp/gh+BtlIOv//YMMxBseEIoM47d8DQ8kb9lcVsxDjRuNdwFmZlDN5F9XfTSvWMKLiYNOTHlZhBpz5E5NLQyizYUj03fRayvqgC1YkTP749LUx81paDjLD+OspOTHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B77QSfoLl4kTjXLDH3ssk+g6Cj0XaNV0A1NrgXsYpD0=;
 b=iZu52exYDsrx53SqyS4QxGRK4AS0OQYvjkI33lDzlyrX88U/HQlaKmDZdRuv9xqZH6GaAVOOQCckgPq6saR+qWy8HwTZNCszCMIBble6IRTYAEYb3BSB1TMeD4XAFGHVe+eR1Mf+CepljjBq+Hvmd73jguDQZflGplJ43CeUTROqhE9rKTLokLUYvBGlpmk6IDXtBBFdc3+lnwz+xPlkldylGVLpyNLwzbOgCsKsSYtiFHqdycR+TLVbQl8JniRhaTpP8yGqigJBMsaec/ainM4yxJC0FNFeU6cbQVbcjXi6bcaPMy6lAJJgi4DfQ0LBZ+BGCR2YC5KtMdXr41yOhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7560.namprd11.prod.outlook.com (2603:10b6:8:14b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.11; Tue, 26 May
 2026 21:26:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0071.011; Tue, 26 May 2026
 21:26:27 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "james.morse@arm.com" <james.morse@arm.com>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "fustini@kernel.org" <fustini@kernel.org>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "peternewman@google.com"
	<peternewman@google.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
Thread-Topic: [PATCH v3 9/9] fs/resctrl: Fix UAF from worker threads when
 domains are removed
Thread-Index: AQHc6h9hj6Ku6vhGmUCkS0ECL1lmsrYgdX4AgAAnhYCAAAlEgIAALEKAgAAEnyA=
Date: Tue, 26 May 2026 21:26:26 +0000
Message-ID: <SJ1PR11MB60835670CAD544BCFF856022FC0B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <accc44062440c9b9ef220fe7570588e00f8a238a.1779476724.git.reinette.chatre@intel.com>
 <ahW9EJORpIqnvthk@agluck-desk3>
 <da9ec0a6-8ea6-4b85-b4b2-6f4fbd32f687@intel.com>
 <ahXl_UF66yiPiEPB@agluck-desk3>
 <d5ead3e9-f878-41ce-98d0-ad7fbcd778c6@intel.com>
In-Reply-To: <d5ead3e9-f878-41ce-98d0-ad7fbcd778c6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7560:EE_
x-ms-office365-filtering-correlation-id: 9bd72a9c-d90b-4cf0-712e-08debb6d71fa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021|56012099006|22082099003|18002099003|11063799006|4143699003;
x-microsoft-antispam-message-info: L7S1fDMgj394CUce1N3DgPg+FuKzAZEsHAoQ7QIvR4D56UrwiFwdAB+JsA6QZjzlJTVCiT9sG2TL5hsvtkk/6OtxeCbO/ZuQrd7Gaw0kgmTShu68U+2qac77A5TwwAh3Q8iGfoiyukSO8yI/voy5baJBB/samQmIMgdqZY7T5T2OgxBw3ObbknQEEL31FCA10ZXyQynayBt9ywvBP5mG+xEseEF3Ta/xvhHXYgCIs72je+Qn0VEg+AAyuKpfXrtl1ynnfndiNAS4wv/Fk7thgJ+Xgr6iOQzAFKca+oU7NboiOI+T/wbbR8mi1PrypDyyhwxqvXzsHD/6hqudW7hBEKh71WdXTTwPVWEtsLJfbx+IDNiBaoTSnNzQI3LgM4I/PpB1QVEWVYsFRi0R7L8/yanwu5PF9UK6iDqQloppGY8ARnCFQhkG2xD46rq52z4PS1RViYKbwoIjdOAzNVHbMX0oMebxb6n8NrkFw7IzCUrS7BAHizdOlhaBN5B0sWFsqQL3FevvB+Fx4aldLngqgSdHbqHDkYq5P3pG5Qn9yw0YnGJaxiqcNK1EnWhoy1MDYrwM3p0mDvHkraB8E3GbiMJfbQMYGsBjlYSYhHXCOf81wpACK6VmYMZ6C7GnJFXo9OcbNSqXhsxTTb4HcUsL8fsXl2XniPa6tl6VoN4QZ+fNDbtTWRm74u35Qm3EH1m5LJtyYkLzVZzOTbrq/se6i9/ENfKm8eN40vLUjGUIqxBh8zLmTi69y7Q0KdVcLOAn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021)(56012099006)(22082099003)(18002099003)(11063799006)(4143699003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2xIN0ZReTlJZnRldEJLMHBXRk93c21XZURXRzVCd0U3Rm4vQUU0WXlkT2p6?=
 =?utf-8?B?bHZzYmhaT2NnWnFHYVQ3eE5KdFIyQ1BuWWVWVnoyY2FLVUltSjdLU0tPTWJE?=
 =?utf-8?B?bXR6bkR2UFJBakZYbm82VTJvS0Q1NFhST0FqajdvcWxxcFpndWNxd3IrZU5h?=
 =?utf-8?B?RmkwNGFKRC9zYTVheGg1dzlzU2cwUGV3THl1enV2WnFlMHIwQVgxV2FjMTRI?=
 =?utf-8?B?aElHQzZEQjVpN05aVkh1UlZZM0hTZ2pGUGMrV2dzRWQrdDNlUlQxUzkxSUQ0?=
 =?utf-8?B?RUdkdDhocm5nUzduRGpGaUNHeEY4VW9zQm9ibklFdUdFbjIzSjBPNWNHcEN0?=
 =?utf-8?B?dmx1aVBNaktSNHk4SEtUeHJCLzVja1hJb2ZBRnUydVFVVWYwdng4MzdPd2lV?=
 =?utf-8?B?SE1uNUw2OStWMUtIT3pvT1lLcjZBNFdWQ0Y0R1NnWDk2dVFyUWlTVHdqenNW?=
 =?utf-8?B?T3o2VWQxNHIyd0txVmNIT1JDRmhNMld2YjZIdHRxanBJcWtIamNTWlBrdUZR?=
 =?utf-8?B?RUVZa1N4UnZWbm5Oc0tRakxCUC9NL0hIWXEyTmN3dGZpbG1JUytIdjU5ZFJI?=
 =?utf-8?B?bWQycFdZSThwTzJMUnVzZGcvVEcyZGpvTXhNZ21OMVZRL3dUVVlsWHA3aTNu?=
 =?utf-8?B?WFJXMU1Nd1BHcXhCVS8wQkhHRzEraEw2b01pK0I4MEJ0UGs0bm4vMzY5eHpn?=
 =?utf-8?B?RHkvWnphZTFRM2Qvd3NPakovRmJNOU5DQm1OWEhrMXhsMUprLzJpaFRPeWJ4?=
 =?utf-8?B?WmkyZ0FzRUNQcVBueEVnN0h2WFAzdWRXc2grT0FHMTVZRHEvUDNCZFc1Z0p6?=
 =?utf-8?B?ZVFhWFJuaEFURm9zcU50Rm5SejJzQ3djMGJvY3F1b0NHUTgvVzErYngreGNS?=
 =?utf-8?B?bWx4c3BUTjJ3Q2V6d3BON0ZlNkQ0Rm9TdUQ2UUVYNXMvdHQ1WEdENFYzQ2FK?=
 =?utf-8?B?T2FEQ2tBdHpEc1lSdmd6VzZMUFB0MjRCclk3cDhSUmxyNGtFd2VickdYWmZV?=
 =?utf-8?B?M3piWGYwa1dVL0VVYzJ4Vmx0NHQwNkE2eFJzREY4Mmh4d2RxT0RONnd6Rmta?=
 =?utf-8?B?THFROFJLK2M3aTBSeFdYUVdLUXBDeDZqOWRDWm1oZWVEWEdTRHcxNFF2N3li?=
 =?utf-8?B?TVJvSzM5QlhRYTlaTXljam56QTY0KytkSi8rOW44NGZrem9BRmdYbzQvYjZM?=
 =?utf-8?B?aUFQWU00MFlwY3FmYnc3MzN2SE5XbEF6YmVPWThibm9aNzhnR2Y2NUY3ZUND?=
 =?utf-8?B?UlpHaU5UMkxpVGZOaHlyZlNWSmdvVlliUlZpd2IyNDZLQ2taencxbzQ4RHNH?=
 =?utf-8?B?Z21NUFlFZk9ubmJvMjRoUlY0UVI5c2c5N1dxUTJWWFA2RHQ3cm15ZmllQVpF?=
 =?utf-8?B?RVRseS84eGdDS2MyZnBiVk9Ceks1bThhNEJOazdFekt3UU5lalVVNkxhaS9a?=
 =?utf-8?B?MlVyNVlxZ2pldkc2bVZKQWFMRit3dkNaWWNqM3g4TzVFSXh0V0FmT1lRdE9D?=
 =?utf-8?B?cXRoMElncUlJQ2tVQWloWHZRUWpuR1RTbVJxbUdLbGR3U0FvbThBalgwM3pV?=
 =?utf-8?B?YmExY0QxK3ExWk5QMW9ydzlvVnJsdUZGVjRBS1I1VUk2RnhHRlI2L3M2RHhI?=
 =?utf-8?B?NjhsYkpFdzY3QlpwRDFFQnFnUFNOS2FSM01GYTdzTVEzUTJGVmU4cDZpV1dU?=
 =?utf-8?B?dDhCNVhuaktrTXRLM0xRY3dBbzZkK09BY3JRLzdZVytzTnlXVW9IdXVvU21X?=
 =?utf-8?B?YmJCZHZRK2tzazJ2T01yVHcvbVNnYWIzUjM3U3ZwRjFlQnZra09wSlpPeTRk?=
 =?utf-8?B?cWZocVdZdDR0OGVUVlpzbE9HeEpSbDdyM0VMNDVJTWR4WnpUZ3JYb280Wnpk?=
 =?utf-8?B?cUN5QVFLcGVhQ0F5cEJSZ2FzT051QkEvOHVpMWoyY0FUbGVMZzNqajE5QnVS?=
 =?utf-8?B?VWpoendsMWwvVG1sZHl4emd4RHUyK0kzamJ3cUtLdVRPRS9xZzByNXRhSWhV?=
 =?utf-8?B?Uk05M2tXaHc1ODBsVlFvM3NnVGJuYmtOcTYwT2tnK1dBaTM2dkczOW1FaWxK?=
 =?utf-8?B?V1NjdXdIby85djl5ei9GaFVvSXpscEs2clM1SXBtQ3pmNXRiT1lObEgvSXJv?=
 =?utf-8?B?QWVmSkJRY2djeGdNV0pzVm1mU3BkRjd3TUdoM3dVRGF5M2VLanpFcER5SXVL?=
 =?utf-8?B?NytZa3lWSStOYk02VWwxeEZUR2p4Tjk3UzIyOWVMbFQrRzdIdGgySzJPRHBY?=
 =?utf-8?B?OHd0aEFGTm1kSkVQL3RuWXFPQnk4MnU2bmpuaEdGY3pYaGVLbDBrTmF6QTJm?=
 =?utf-8?Q?L3WUCtjhTZox8ldffj?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TTRz8U8XsRw1Gu/9dywkxP+yjDLsvSMgO0IOd9hSIocnOA4k9A8m8NjNYYhEkpzy2rLWCr1OjyNxUUJh5d9eqF9rtuSrQLhiO3NzCFDMs1Ew/lSZW5AINJRzzLUSN6Sl6vTRC7OgPRVMTPXAUxJ2V8kLxhtZ56dKqUQdHK3nhdklFC/9OEEbbFveyYuBo8S6iD6lE/HGu+2jthzdmRECCRufhOEvfHvKaWbb1FWBFRaZ7R0loJH4VodHXCOfqRSIv3LduDHUJbBswBmt8Tc8WaLmUli7viu2r9trhRbAYPY1HNbg/9QVIxpegvejgrDQIKXawC9+TEl+Od5OWL+nnw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bd72a9c-d90b-4cf0-712e-08debb6d71fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 May 2026 21:26:26.9921
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 03I9hMkC0iC1vVMFZYRPZFkKA8uv1ejzd0nK/fK3g+9NVk+z1JTp87DpU9rNY6kO5HoB/WI2Awk7roxQ11lo/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7560
X-OriginatorOrg: intel.com

Pj4gQ2FuIHlvdSByZXBvc3QganVzdCBwYXJ0IDkgKG9yIG1heWJlIHBhcnRzIDctOSkgb24gdG9w
IG9mIGxhdGVzdCAtcmMgdG8NCj4+IHNlZSBpZiBzYXNoaWtvIGlzIGhhcHB5IGF0IGxhc3Q/DQo+
DQo+IC4uLiBhbmQgdGhlbiB3aWxsIHlvdSB0YWtlIGEgbG9vaz8NCg0KWWVzLiBZb3VyIGFwcHJv
YWNoIGlzIG11Y2ggY2xlYW5lciAuLi4gSSdtIGp1c3Qgd29ycmllZCB0aGF0IHRoZXJlIHdpbGwg
YmUgeWV0IGFub3RoZXIgbGF5ZXIgb2YgdGhlIG9uaW9uIHRvIHBlZWwgd2hlbiBzYXNoaWtvIGxv
b2tzIGF0IGl0Lg0KDQpUaGVyZSBzaG91bGQgYmUgYSBsaW1pdCB0byBob3cgbXVjaCBlZmZvcnQg
d2Ugc3BlbmQgdHJ5aW5nIHRvIGZpeCBhIGJ1ZyB0aGF0J3MgdGVjaG5pY2FsbHkgcG9zc2libGUs
IGJ1dCBzbyBmYXIgYXdheSBmcm9tIHJlYWwgdXNhZ2UgbW9kZWxzLg0KDQotVG9ueQ0K
