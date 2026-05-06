Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B8B3B52E9
	for <patches@lists.linux.dev>; Wed,  6 May 2026 22:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778105496; cv=fail; b=LSBESbQgNiztjkNnkjvfpiII3vEqMA7/71lxL7Uv9BlQTw0WaJiiHFlTcCuMreOf+WU2Yi6QdK2zgkxMry/tDDiyUYg49+leBPMRx6sW8fa1wsigohLGUv7MWV6DB16sXDcjrFoiNjdrm1YQmAAfWrWoa+Kvt/KbBrdttxnLKoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778105496; c=relaxed/simple;
	bh=1lj//Q04uwUJfIL8/WuW/SzUZBLOXzogz+wbEWD1rr4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r/ynE6UFBnlkjoHl7aXNbJKNHqzJVZ1hZFK/ngVQIcrHyWx8DYY9awRYQmzYoadhFigyns0kocCVgC5BVkuW6SFnGPfyRpnrFeTcOi9mhTrzbDce5hwafCUzq5srpQ6vYuaegBW1quflx8f0+YE/a/mqIiTZIlwGg7cHAwC+CjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MRzYC7D4; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MRzYC7D4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778105493; x=1809641493;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1lj//Q04uwUJfIL8/WuW/SzUZBLOXzogz+wbEWD1rr4=;
  b=MRzYC7D4zz/31vAunDM36eQgXpoZG/jUjNMWy8UOQL18Z/UW3hW8P21H
   Oj/K5vkw/pEF3fc6/UeIBbSsEtSVH8OSFLWKaigiPf2DignOGdMyUmls8
   SeSJlvjW0vax4HmTsBBxrX+Sd1zyEjlz5Glxce+rkh2lWUSnn7eh0Wiqh
   03R4tdJpO47pXJhfp/w+LINT+4oJ2mWgadnrx3dZ8ZF0JAXNFz1QlVcbU
   yNiqsqZ9RKzpseVBlKq9Bv81OhuG09OBlTXdbEk5edBOu/pcBfR6TBNV2
   +fEsHByYSJZNin+l76rYYy1mS4zj2ZvfBYXaVtLpeQaRn9o/dh38GWJmU
   w==;
X-CSE-ConnectionGUID: oj9ksiwyT7CUpaOgeVf7hw==
X-CSE-MsgGUID: cIA0SkZuQT6i7kFLaSak3Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11778"; a="81615837"
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="81615837"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 15:11:33 -0700
X-CSE-ConnectionGUID: rA4Sun3MSU6wntWjN9WitQ==
X-CSE-MsgGUID: qjnbo2hsT7KUUgTBCJ+Hew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,220,1770624000"; 
   d="scan'208";a="241276513"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2026 15:11:32 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 15:11:32 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 6 May 2026 15:11:32 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 6 May 2026 15:11:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gnb2R7WhUjFloGom+TQrVWCWA4TbdliUA14xtPrDUDdtFyI3ZefM1vIn2arl52iPnKzvEbrGpZp+rP15+VyLcrNC3emd2LasLN+DNF7LHZOkq0y9Zm4Z6tTphcpm2MrWUe0hOrVriohfvd/pgySRTANbhO/3L+sxw2KDdsOfl7w+OpodLrPuNeWcjSbNdtPXbeEjZTpN6+Ju8kczg1X1O7gF7aTltQ5fW5IIGLatL/bEcGJC28L2WW+XAr0zcf8vueX4ie85DsE048zXuZULGEHskZcmLHarh9sIqwr2rf3ioV959n6ed4f+U+d7cTf3FySLeOV04wMInAdsZJ5AnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lj//Q04uwUJfIL8/WuW/SzUZBLOXzogz+wbEWD1rr4=;
 b=ThXWPcqaa5jKtoiLKvyJ8lWsHIxF3TfhJrgyFGDDfKpnbvdhdj17ZXXHkaK5EJGPScXWgAuHHXlLhXp/bllcMtqLNS626a3yEF+tM+RK0SqZC/C/a9vy/2Sk0Jetscyh4pQ6WakVt0lyB1IALOYbXxrlEE0K/SkgeJW4s8YhQOmTew29UYiu/1iO3atpDExfm2zA9XV9E576BslrHuYyb5zoBxh2d3W9xyqi+LDR+ywYEEUwa5CUiyP7ncun0YRbwIpmwg+y6JbaklKO3O8GXM7IvpnPQoHyLzSI1hSvZ3aXp4gVVoNHU+AXm08GU1F9PMViqKOKtk9v+mlPGOdVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6054.namprd11.prod.outlook.com (2603:10b6:510:1d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.16; Wed, 6 May
 2026 22:11:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9891.008; Wed, 6 May 2026
 22:11:27 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, Fenghua
 Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Thread-Topic: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
Thread-Index: AQHc2bKUdc4/WN+WbUyjxuEkqyLnwrX9/UIAgACARQCAAGFyAIAAytUAgABOY4CAABxYAIABQzoAgAAXkYCAACCHAIAABacQ
Date: Wed, 6 May 2026 22:11:27 +0000
Message-ID: <SJ1PR11MB608334A68F7E79E6AF3C324FFC3F2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260501213611.25600-1-tony.luck@intel.com>
 <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
 <afkizhrSwJkiLD3j@agluck-desk3>
 <3f13c7e4-3812-447d-8c42-b28fd6b9d0fa@intel.com>
 <afoesuWB8RezVLrN@agluck-desk3>
 <7fad1d7d-c892-416e-b97a-a230fd43f2a4@intel.com>
 <afp4OkwtPpyIwAC1@agluck-desk3>
 <d065f7b7-daac-4e45-b7c9-69175dfb43a7@intel.com>
 <afubI4kYrdWUXGUR@agluck-desk3>
 <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
In-Reply-To: <217d306e-78dd-4762-8c82-88d6bab9de44@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6054:EE_
x-ms-office365-filtering-correlation-id: ccc3df4c-1050-4cca-2a9e-08deabbc6b46
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021|22082099003|18002099003|56012099003;
x-microsoft-antispam-message-info: 7GgnGYM1gN7y41PgLIj7CK2k6FWtu0Si3siUejabuD7iDTxAvdO4qkWot4Z58P8NkLZxrCBIcbeLGuz6QW2q+SvAkVX3o1xlK19tyPCoSds1AwqsaVAhjRUfxwmIa+3q5TSC2qdPEe5++ltlvmLGaanAoHRT9DYAACeH24wj8C9aNBE0EcCgIKVKP8UMOsBL7EsIdw8uBLO/cdKD5OpmUKhGj/M3q70tPwH7+QoHyRc0HAfVH2lrVu9fuAY9GfWOgWfT1pqQnaO1gdBejHnE6Vs0hAu9R5PPR9bpRUgkNczC9CJLGe/NIfWLn7/BzL/MR+O87CG6oSD16GeXkpJTnUZkQVYerP1O8iFKvCLaS/shkHcfR0GUirMk9SXDAhhO2EiNtTJ1seXE4FhLx9v0oxlDW3F6Vj0LY1+7Z1RtnTI1jBkqPJxbVqjrseDX21Ie8oP7AMfUbfaESy/stmWODqahaKf3lf4vJDDe96qH+vX7gLxlyf8zKUesOxPMV3QyUE3ZdYIvV3YQ75zcMulov7rr5193pXF5kDuZr/MAak7/INaGnlHfBx1LpKFDl5MHbv/IYXyaOfxs1WM8bKniLXVmJ0oLtCdcHiT+vyWAgmTLdBkNLNG5sS2todgfYlM4r1q2bTw77yxlRgwX8h0j2871wGybE14sfWZ/NND3Vu/Ei+pbFzQgiICGZxRpKsdyYpcbOa0Oa4aucEDnaobEobPcK085tbXaNjyzAh5ANGbMPYvTyuRGNDQWiv9wlPOn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmFKUXlBOGFmVDJ0RXZ3NDBlcVJ6bExNTDF3ejMrQ2pRKzhtSW1YZmcvcEtJ?=
 =?utf-8?B?ODhDRUZLZjZtRmtLK0ZueWwyc3d3M1ZROGZmRTM2WEhXL0lOOXBSWWt4V1lj?=
 =?utf-8?B?UUo4TVhsQms0dEFpQ0hQc2p2SG5GRWRZcnhtODlMRWlWajRVbzVocjJoZWta?=
 =?utf-8?B?Snh2SlBJS3kzcFVlRFNmWU5JaGdxbDBOdjlHL1ZLS1hOUVRVS2F3NCt2d2d6?=
 =?utf-8?B?d1ZuWGdhQWlBRE1TMHZxa3RCbjVxWXIveEdERjYyWXNyNU42OU5lY3FlY1h3?=
 =?utf-8?B?TkszT0txeGZTUEJoU0NOUWRrMFJDM2g2NktiYmRKd2xJRlhZY2tvdEFnRG9z?=
 =?utf-8?B?Y3ZTd1pSOEJKNCtzN3FiSi9uZFdCNDdvQzk4RzNlajR3Y1pXZGo2ZWxldHJ6?=
 =?utf-8?B?Y2NmVHZ6OVhoVFdQa2diazRBcUdpZk5kVjh4MkpPc2RPekYzYmNsQ0R5TDk1?=
 =?utf-8?B?TzBUN3lNeWg1ejJndDY3WHBvcGl3U1pPMHMvcGdQVkpua1FWbDZJVGduZlBE?=
 =?utf-8?B?N2crZm1oeDNzWEM5MzhBUjBqZG1vajlqNG1WQ3NxazdtZnZIb0U2OHZZRTBj?=
 =?utf-8?B?bm1rd2x1MHNnSXliTWpsMHBWMGlHSjVCdm91Tjh5T0ZsNXU3dkNhVmx4NWRS?=
 =?utf-8?B?dW9UdnBWU2pKS0dvYjNSWDh4RTVGakNVTXpOc3VhcVJtY2VZMkg2ckpIZnVE?=
 =?utf-8?B?b1psVGFvMTQ5bnYrYzBkbkVEc0RJcXBiZi83NU9JQnVHYm1zSStnVktLMkEv?=
 =?utf-8?B?MHVUYms5U1pLSFlrQjNpVUtKbG1SdDFJTG9ZMjhMdmp1UE1lci8zdXBZTFNF?=
 =?utf-8?B?eGlMbmhCR291MUN3TWlDdWJLTlI4WTZUYkhtb0V3ZUlDbzRPelhqRWR3WUxR?=
 =?utf-8?B?WmZNeVBWOUNwdTFteDZTUjZjajlHRlVQelhPZ1l5NE5PSCtHZTcyWVZXam9N?=
 =?utf-8?B?aXI3VGh3VUswNTFYVHYvOWpuaXd2QzB1TkljNFlUZVdJdWhoK2FLOVJKZ1hz?=
 =?utf-8?B?UEliTXBtRDJOMkpHaDMzc2NLanp3RWIrY3pDZFl2bWk1SElvZFk0Snhtc24w?=
 =?utf-8?B?TUJveFN5eGVPK0k4ZzRSNzAvNFAyUzB2T1JKVXU0dzAyaDluMFVFSTIzYjJy?=
 =?utf-8?B?V1VXdUlVY1lhdjBONXFibFZPWXdyNnVRV1Q0QTB4NS9hVEJ0RWVraHd3MjRx?=
 =?utf-8?B?UzR2Y2ZRVkZTanhXREp1bGtOOGpiQWRQQmRzQjRxOTdPTWxFWVRMSEsvWFZm?=
 =?utf-8?B?a0ltT1lRTUE3VkJRcTdyUlQrOHpuMk5uVDdPUFBMZzFKaUNndFFtSTFqaGFV?=
 =?utf-8?B?Mi8vb28zZjhYaEptSVNqdXk5b21aeGoxeEkrb08rc1BTclozcjNKTFZnNVF5?=
 =?utf-8?B?UUhhTVRpZC9TcDNiWDNmY1NJWDJXd3gxOFZRdEc3N1ZobUh0RkhrN1ZlUmEz?=
 =?utf-8?B?c2JzdVBLQmJVTWZZZWdjcVU0ZHpCN1QxUnpBb0xTcmZKKy9oSHMwaXRJTVE2?=
 =?utf-8?B?cXFwRVlqNmcwUFdSRUdnNWhadUo5Z2dvNERUSWloZnZFVmE1SndrWXB1clhY?=
 =?utf-8?B?NW5MUWtURzVCejhDbHJGdzkzNUxGWjJCZWY4Unp4M3ZleWlGMGU4a0FFd0lK?=
 =?utf-8?B?b1RYRlppUmhBNE5xTkdXUk9lTWhWUFBHdzJJcWQ2ekNMMGhRL2NEOFpvaThO?=
 =?utf-8?B?UWdRK2NpdmJ6alh0dkh6S0YrQlQzOHpjcmxRQXM4dzJSZHc4MUR0c2JtUi9u?=
 =?utf-8?B?MStvUXRMVllmZFhVN09yUHFZd3IwZ3VYYWpmTjZLdWZSeFYyT1BZaWU0L3J3?=
 =?utf-8?B?Qzk2dHljLzNaY3hRdmRzU2RBcFJmcUc3K09qbkIxbmNDbjZ5SkR2TzZxNHdN?=
 =?utf-8?B?c2VCZFJjZ0lHZFFLM2hzNkwyWVhST2FZMTA4YkVOQVlMQVpBc1dneEN5VTY3?=
 =?utf-8?B?SVFQSWkvazdmU3dIbHVrNFJrYVVjNytzbzNQMkRQSDdURVViditPa0kyUmVU?=
 =?utf-8?B?UGZLK3dvQ2M3Q2NlSEM4alFPc1dSd1gzam1qNkZwRWRNNk54UitIK0YzNkFM?=
 =?utf-8?B?UXBvemlGTWEyeHZEL3l5ZWdnTTBuamRLSC9Vb2hXc2VKanBRa2VENVJXb0JZ?=
 =?utf-8?B?V0JYeDBWSmFPNnlqZGZtd0dEbXhYS1J2NnU5enVoU1lCUVNEU0RQbkhFeHJO?=
 =?utf-8?B?b1dqd1lnN3ZLRVJaRkdnTUd5c2ZUNXJ3UVF4ZXU5MXQyVEFnbjB0L1ZnY0hE?=
 =?utf-8?B?YitvV0NKQWl1aUlJNHlqTmhUbis4VnlTQnNTWjZHdFhKZHJsV0QvZVZSaHRn?=
 =?utf-8?Q?NweKi1yDJa9mku8Kb4?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: X8EtHjWDjwODJEGfNe8DpwNUK0aERNgO3YsZLSQdtkeYnaLDOm3S+rfcCXEoePL64nWOUJBoWpJ0T63djTh/lSsUYjy42vM/7mJ+Tf7wJY6HS3IDgoUwyl69OhWgqcfNTglH12Q8YsQfllQZtVn2hSBpwbWJTt7vbP9U9KLU71oHZAuX3F1CYnhvAElIFvFmtN6ySGfmDsL4cWFe0Qf5PoVeOqk6vBj68+eggCwvMI1vHFo5CiLnMgPvBE1a9eTmmJr43gdbBH7lL+gSmEmdbRfAON56nC6eePy+28o8jutViE4/AKAhJmpmoaa1KwIw2OEK9u0eYq19NQoEidAcGQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccc3df4c-1050-4cca-2a9e-08deabbc6b46
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2026 22:11:27.5042
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u1GNvqoeHbyAdCC8EXdyR4AAaoY3CSGpEiyLNNbvXmQQ5s49FCIsTh5O/0kXVl0SVE/d6RbtG2tGqWqOme7vAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6054
X-OriginatorOrg: intel.com

PiA+IC4uLiB0cmltbWVkIGRpc2N1c3Npb24gb24gaG93IHdlIGdvdCBoZXJlIC4uLg0KPiA+DQo+
ID4+IHNjaGVkdWxlX2RlbGF5ZWRfd29ya19vbigpIHdpbGwgc2NoZWR1bGUgdGhlIHdvcmsgYnV0
IHdpbGwgZG8gc28gb24gQ1BVIGdvaW5nDQo+ID4+IG9mZmxpbmUuIERvZXMgbm90IHNlZW0gYXMg
dGhvdWdoIHNjaGVkdWxlX2RlbGF5ZWRfd29ya19vbigpIHNob3VsZCBiZSB1c2VkIGF0IGFsbA0K
PiA+PiBpZiB0aGUgd29ya2VyIGlzIGN1cnJlbnRseSBydW5uaW5nLiBBcyBhbiBhbHRlcm5hdGl2
ZSwgd2hlbiBpdCBmaW5kcyB0aGF0IGl0IGNhbm5vdA0KPiA+PiBjYW5jZWwgdGhlIHdvcmsgcmVz
Y3RybCBjYW4gYXZvaWQgYXR0ZW1wdGluZyB0byByZXNjaGVkdWxlIHRoZSB3b3JrIGFuZCBpbnN0
ZWFkIGp1c3QNCj4gPj4gc2V0IHJkdF9sM19tb25fZG9tYWluOjptYm1fd29ya19jcHUgdG8gbnJf
Y3B1X2lkcyB0byBzaWduYWwgdGhhdCB0aGlzIGRvbWFpbiBuZWVkcyBhDQo+ID4+IHdvcmtlciB0
byBiZSBzY2hlZHVsZWQgYW5kIHRoYXQgdG8gYmUgZG9uZSBieSB0aGUgZXhpdGluZyB3b3JrLg0K
PiA+Pg0KPiA+PiBDb21iaW5pbmcgdGhlIHByZXZpb3VzIGlkZWFzIHdpdGggdGhlIHJlc3VsdHMg
ZnJvbSBleHBlcmltZW50cyBJIHRoaW5rIHRoZSBmb2xsb3dpbmcNCj4gPj4gbWF5IGFkZHJlc3Mg
dGhlIHByb2JsZW0gZm9yIE1CTSBvdmVyZmxvdyBoYW5kbGVyLCBub3QgZXhwYW5kZWQgdG8gaW5j
bHVkZSBsaW1ibyBoYW5kbGVyDQo+ID4+IGFuZCB1bnRlc3RlZDoNCj4gPg0KPiA+IEluaXRpYWwg
dGVzdGluZyBzZWVtcyBnb29kLiBJIGFkZGVkIGEgYmlnIG1kZWxheSgpIGluIG1ibV9oYW5kbGVf
b3ZlcmZsb3coKQ0KPiA+IGJlZm9yZSBjcHVzX3JlYWRfbG9jaygpIHRvIG1ha2UgaXQgZWFzeSB0
byBoaXQgdGhlIGNhc2Ugd2hlcmUgY2FuY2VsX2RlbGF5ZWRfd29yaygpDQo+ID4gZmFpbHMuIFRl
c3RlZCBib3RoIHRoZSAic3RpbGwgaGF2ZSByZW1haW5pbmcgQ1BVcyBpbiB0aGUgZG9tYWluIiBh
bmQgInRoaXMgaXMNCj4gPiBsYXN0IGNwdSIgY2FzZSBmb3IgYm90aCBzdWNjZXNzIGFuZCBmYWls
IG9mIGNhbmNlbF9kZWxheWVkX3dvcmsoKS4NCj4NCj4gVGhhbmsgeW91IHZlcnkgbXVjaCBmb3Ig
dGhlIHRlc3RpbmcuDQo+DQo+ID4NCj4gPiBJdCBsb29rcyB0byBtZSB0aGF0IHJlc2N0cmxfb2Zm
bGluZV9jcHUoKSBoYW5kbGVzIHRoaXMgY29tcGxldGVseSBhbmQNCj4gPiB0aGUgYWRkaXRpb25h
bCBjYW5jZWxfZGVsYXllZF93b3JrKCkgY2FsbHMgZnJvbSByZXNjdHJsX29mZmxpbmVfbW9uX2Rv
bWFpbigpDQo+ID4gYXJlbid0IG5lZWRlZC4NCj4gPg0KPiA+IERvIHlvdSBhZ3JlZSB0aGF0IHRo
b3NlIGNhbiBiZSBkZWxldGVkPw0KPg0KPiBHb29kIGNhdGNoLiBJIGFtIG5vdCBhYmxlIHRvIHRo
aW5rIG9mIGEgc2NlbmFyaW8gd2hlcmUgdGhpcyBpcyBzdGlsbCBuZWVkZWQuIFRoZSBuZXcNCj4g
ZmxvdyBvcGVucyB1cCBzb21lIG5ldyBzY2VuYXJpb3MsIGZvciBleGFtcGxlIHdoZW4gdGhlIGxh
c3QgKnR3byogQ1BVcyBvZiBhIGRvbWFpbiBnbw0KPiBvZmZsaW5lIHdoaWxlIHRoZSB3b3JrZXIg
aXMgYmxvY2tlZCBvbiBjcHVzX3JlYWRfbG9jaygpIGFuZCB3b3JrZXIgbm90IGdldHRpbmcgb3Bw
b3J0dW5pdHkNCj4gdG8gdHJhbnNpdGlvbi4gRXZlbiB0aGVuLCB3aGVuIHRoZSBNQk0gb3ZlcmZs
b3cgaGFuZGxpbmcgY29kZSBpbiByZXNjdHJsX29mZmxpbmVfY3B1KCkNCj4gaXMgdG90YWxseSBz
a2lwcGVkIGZvciBvbmUgQ1BVIHRoZSBjYW5jZWxfZGVsYXllZF93b3JrKCkgaW4gcmVzY3RybF9v
ZmZsaW5lX21vbl9kb21haW4oKQ0KPiBzZWVtcyB1bm5lY2Vzc2FyeSB0byBtZS4NCj4NCj4gQ291
bGQgeW91IHBlcmhhcHMgYXNrIHRoZSBBSSBhZ2VudCB0aGF0IGFzc2lzdGVkIHdpdGggb3JpZ2lu
YWwgcGF0Y2ggaWYgaXQgY2FuIGZpbmQgYW55DQo+IGNvcm5lciBjYXNlcz8NCg0KSSd2ZSBnb3Qg
YSBjb3VwbGUgb2YgQUkncyBzcGlubmluZyBub3cuIEknbGwgcmVzdW1lIGNvbnRleHQgZm9yIHRo
ZSBvbmUgdGhhdCBvZmZlcmVkIHRoZSB2MQ0KcGF0Y2ggYW5kIGFzayBpdCB3aGF0IGl0IHRoaW5r
cyBvZiB0aGlzIG5ldyB2ZXJzaW9uLg0KDQo+DQo+IFVucmVsYXRlZCB0byB0aGlzIHF1ZXN0aW9u
IGJ1dCBtYXkgYmUgd29ydGggYSBtZW50aW9uIGluIHRoZSBmaXggaXMgdGhhdCB0aGlzIHdvcmsg
Zm9jdXNlcw0KPiBhbmQgZml4ZXMgcmVzY3RybCB0byBub3QgYWNjZXNzIGZyZWVkIG1lbW9yeSBm
cm9tIHRoZSB3b3JrZXIgc2VsZi4gVG8gY29tcGxlbWVudCB0aGlzIGl0IG1heQ0KPiBiZSB3b3J0
aHdoaWxlIHRvIGhpZ2hsaWdodCB0aGF0IGl0IGlzIHNhZmUgZm9yIHRoZSB3b3JrX3N0cnVjdCBz
ZWxmIHRvIGJlIGRlbGV0ZWQgd2hpbGUgdGhlDQo+IHdvcmsgaXMgcnVubmluZyAoYnV0IGJsb2Nr
ZWQgb24gY3B1c19yZWFkX2xvY2soKSkgYmFzZWQgb24gdGhlIGZvbGxvd2luZyBjb21tZW50IGZy
b20NCj4ga2VybmVsL3dvcmtxdWV1ZS5jOnByb2Nlc3Nfb25lX3dvcmsoKToNCj4gIkl0IGlzIHBl
cm1pc3NpYmxlIHRvIGZyZWUgdGhlIHN0cnVjdCB3b3JrX3N0cnVjdCBmcm9tIGluc2lkZSB0aGUg
ZnVuY3Rpb24gdGhhdCBpcyBjYWxsZWQNCj4gZnJvbSBpdCAuLi4iDQoNClNjb3BlIGluY3JlYXNl
ZCBmcm9tIGp1c3QgdGhlIHVzZS1hZnRlci1mcmVlIHdoZW4gdGhlIGRvbWFpbiB3YXMgZGVsZXRl
ZC4gVGhlIGNhc2UNCmZvciB0YWtpbmcgdGhlIGN1cnJlbnQgd29ya2VyIENQVSBvZmZsaW5lIGRv
ZXNuJ3QgaW52b2x2ZSBhIHVzZS1hZnRlci1mcmVlLiBJdCBqdXN0IHJlc3VsdHMNCmluIHJ1bm5p
bmcgdGhlIHdvcmtpZXIgb24gdGhlIHdyb25nIENQVSBmb3Igb25lIGl0ZXJhdGlvbi4NCg0KRGVs
ZXRpbmcgdGhlIHdvcmtfc3RydWN0IGluc2lkZSB0aGUgY2FsbGVkIGZ1bmN0aW9uIGlzIGRpZmZl
cmVudCBmcm9tIHNvbWUgYWdlbnQgZGVsZXRpbmcNCnRoZSB3b3JrX3N0cnVjdCB3aGlsZSB0aGUg
d29ya2VyIGlzIHJ1bm5pbmcuDQoNCj4NCj4gPg0KPiA+IEknbGwgbG9vayBhdCBmaXhpbmcgdGhl
IGNxbV9saW1ibyBwYXRoIGluIHRoZSBzYW1lIHN0eWxlLg0KDQotVG9ueQ0K
