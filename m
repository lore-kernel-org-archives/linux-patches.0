Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955791C3F0C
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014960; cv=fail; b=H/l9G7abp72lz8NWuP6BP6jEjbNOeelmDFzRP/UgczXqN7OfADQvG3vXp7Jtz39TNgtfVZGr9FgJSigYWBfmo9zilW3NNd9iAE1t38izzd0WE6K25dipzp6TmibxLF2ot4Qra/1Ocgk4Oyw36Sclzh3iLbhIBqZGCXilu/Ryghw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014960; c=relaxed/simple;
	bh=e8XUUlYOEk4I9S+3YdVG/KzquNbEg8xsHsygZGR2vtk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=C445a6MR7/mdJpIZryFR+ecaMlvTYE0jT5oke4oNzPT89g7KQUp3gRdSeUTvchoyfPOKFP1RvbC02Kg9c8U2snluYczlQoD/iR560lwFrZ/NAmvqKSVAK9U73+yzZNgsGJ/m+VoyPwH+PX7qvBH2L80ay9Xdx0kdLc5C4ZNuJ5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m2zxTBKX; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m2zxTBKX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014960; x=1818550960;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e8XUUlYOEk4I9S+3YdVG/KzquNbEg8xsHsygZGR2vtk=;
  b=m2zxTBKXL3KcvMzjRGyYvCy6/TDT43jPHuQKVe740L1kOxN81GAxruPj
   nkAeWhB48iKTWM2HLlxtOrt71eBfdXHc2b8FoshVNS1EzVbOPYFLufp1P
   WhyRFIvInonJRjC5ZLcLRlZj8PMJ2qdQHpRtZVcVwZt1USMaJHND8BZ/v
   pMQGSbDNaCpdSyRKg2tk7+uBcq4tdWRCNQixNrPxeHvTEpPEbUnespzQO
   eBRD/mU109qonUho+Apk0UJDEhwKOYBM+tk+3tknzR4ik6XEyNJtJ01aZ
   yP0IJtfxWZ2QV1Hsns1q1t6JJ9Qj/QIA6zG2GH/66y9I47VY2Oaieyvax
   g==;
X-CSE-ConnectionGUID: oZ3sfZvqSBmLbV+ugzj1rw==
X-CSE-MsgGUID: DDhfp37ETbWHrjFMGlIfwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="87564101"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="87564101"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 18:02:39 -0700
X-CSE-ConnectionGUID: eyRJ5B1qTvmTzsXHzxQGMQ==
X-CSE-MsgGUID: 8LUmCiQcQxWje8t/plGKOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="263744378"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 18:02:39 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 18:02:38 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 18:02:38 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.14) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 18:02:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XniRoSYPSkZcCMF5uj9I4ceRfTISLpqa5xsub4PIJsJQMptBYdm0m8nYMcuobAehQnvh8V3Srd784hfb5dS6m8kK96HQMU16TD0hF1YVk1TpwNf5aKCr3HRA4bBhq5BkF37UAaw4HFH5AC/DKoPcL60CFReOUnvzYl3uRFts8e3vUlcv0Xy+9TYvqUolTK6f2zvf6Fy/vQmE5DnpK5KN01TK0cuqbxVTwMokXnYRtLQLdNkh5sW3j5PNPvYaalYsOwbjXJKXXoA/lQQXDuo73ZUgD8AaagGFGuNjJf0jYHLQgdVI5V9MkcKkqwb8aI02S6/71ifed1G7P5F4D6JiKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXoWkHf0dZGruCQ7FzP2qmsT2tdwbgl3XnT+jsveGHo=;
 b=qhfDZ2wTvs9GA09shOqvSkplJZXk1OrTy2JVp5Nd/05xsUd60Mfsgy/yg6GuXjR076dyYNanSo680443K8TL/bES1AFb2fgBAWXvY6wwkRi0aBUoyI3uEoYSLH5q7sRm6DlPtIruEs6es5dUUUs8uF98nTjBGnz2ITYskjwnnHVu9dYmpmQe7jyYDRQKzZtCQkcQZ2pKjTQvhM0Qve0D1ojTsec7pcOYsT1Y9U4a6b7N9ceMTZbKT490yuUaVnpL1c6pFHPFI8pPgercG8sgC3KHiuNqpswLuIb+E24QHUenl1jbP0zezFufpk8Xm7kOyVYmAKEMyZ73//VzgP5oGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ2PR11MB8345.namprd11.prod.outlook.com (2603:10b6:a03:53c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Tue, 18 Aug
 2026 01:02:33 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 01:02:33 +0000
Message-ID: <03257927-1015-4e0b-9d56-3e5d682d98aa@intel.com>
Date: Mon, 17 Aug 2026 18:02:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 13/17] fs/resctrl: Call architecture hooks for every
 mount/unmount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-14-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0384.namprd04.prod.outlook.com
 (2603:10b6:303:81::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ2PR11MB8345:EE_
X-MS-Office365-Filtering-Correlation-Id: 8cc8cf45-0ac7-44e1-bef8-08defcc462b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|1800799024|366016|22082099003|18002099003|56012099006|4143699003|11063799006|10067099003|921020;
X-Microsoft-Antispam-Message-Info: GCjJiYttZ2/edSFr6QZmpypLCdT2st3/p+1rtzBQJrNDpUSYCbUa3EQ8ZmGbDUUa6xL/ez1pkjUT/WSnw1lIs0weVTdL/xyUBynrMjXer0rwxyvn1U4aJvpxOkwlAZUaDnoESaH/kdNOy2Y+p+To486Q0psPZ2QmGxb1ufANPHQj3tqHhXs1VQxSQ6a9Z1jGO2l8q46qshbJ+fk6cI/mCvNpylhhVpH6+zmaulvL145U0kOYtiPew9KV70T4dKXX/R3EJL3/cY3/RT0XRrZSnVkboL1UGZv1JERJ+Hv3Uui75n+lnG0aizT9oQoJ8hc1JlKEddL88qKXjbhbE5MzsvEyvRzkkjTrlh8I7AXpWqSqo3+cT1Ylry3OqvziabFpbpIfz9U82qAK1W9y4DSZn9hm7DSmKSLDFpTC9SiuuuwZQ/6W4W9SMLx7qpaIKnWV0irNl5RBk5XkslZTVaJ0m4VtVxCBJEbaSnXiHoxnrTP5lBqLB53DFXn4DezY6RXCE6Zdda7ABpTAh21zIKRP4QoJIAwvHWAAVU+KqzyFUOJ/cdD0PUNSWQaNPOf9mpNGkHAvcvS/ZiGLQcKhWF8nMPOQz3MOziUhvQ31IEsZ8OAoAWamvDcPHveWmzGMaKGES5hS6TIr6Z/e09sC7KR3bUEMMI6r4FQZWqZw8IUxVx88O/58RDnIOhiPmtpyx5/5V0FLFVaBzeu66IHjLGzEGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(1800799024)(366016)(22082099003)(18002099003)(56012099006)(4143699003)(11063799006)(10067099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TVJiTG1tOHFFdnVRM1dldXlNdjB0alk4emVFK0F0U0dXSDR2bDVhcmFRbUlF?=
 =?utf-8?B?OVBYSkhHQkJMazRXNG9zRlNVbkd5aGVObXhJQnR4Nlg3NXRLdVowRFliTzNk?=
 =?utf-8?B?UTFVdlYrbkUrOHRXeGNqazBKdVlWSnhZb0dsMlhmV1hZM1FCb0tFTytRWXRR?=
 =?utf-8?B?SzNRUEt6Q29xekJlK2JLK2FqSitrdGo1V201dndUN2dPT2k1bm05OTVmUmJy?=
 =?utf-8?B?Z0w3TWdGYnJKZm56OU1RTWVKQUxVWWRxS3plaFp5VythclZrRmpyeGJLUTFN?=
 =?utf-8?B?cjVLeFppWi9XeWFLRVBuVVNwalZBV2JiK2pQRVZOQXcxaDBiTHhDVDFCcldr?=
 =?utf-8?B?QXdDMU43eE44VTBsQS9LYWZSWmMydGkxRGdDcWJYWnpLOWxMMXY4eFlydFl5?=
 =?utf-8?B?UkFvbEVSQmN4L3dyN3Z5bmswMjJqUWtHaDNjeDVHNldZT3p2eERaNWU4VUpN?=
 =?utf-8?B?bzJLWFlZeTdnTVcrT3E1SDk3Qit0bFdYdGI3UEFKdHFURWJpUzl2V0cyUkdl?=
 =?utf-8?B?dGVyNm0zclhPSVhIY013QndQUVRobm45cEl3Vmo5Qm11WG1veVdkUVErSkJn?=
 =?utf-8?B?TkVESmNOWU9EaE9FY3crUnBnSy9iV3ZTNnl3dWVydStWcVZ5RHQwU3IyVXJy?=
 =?utf-8?B?NVAvNVJnT1ZSYlprTUo2ZkJza2dTcVRLTDhxdWluckl0WVBKZ3R3SnpkL1hn?=
 =?utf-8?B?Wi9oaUNWYXZYakZRQis4YUhlL1VjV1N2b0Z6MUh0SWhiUktXU0N4ZDVOaURI?=
 =?utf-8?B?bDBwaHdjT3hLRGt4RCtzMTNHKzZRQ29NeGtvbEY3Skx4ZnVXMjBnYmxJOW9N?=
 =?utf-8?B?TDBDV0RGN3lSZDVjcXBtdFk5YTVnKzU3MEpLMmU3VXpPMDJQdGwzYVE0THF3?=
 =?utf-8?B?RmNrcXpVRkgvMmY5cGJkMytxbW5HVndkUHcxWXpPbzJDdzNuTCs5aHpUbWN2?=
 =?utf-8?B?ZTlqTElnLzJ3cXZUSy9lYkVkQk4vdWFPZWhma1NvcGZIVnZXVWRTZHNPMDZa?=
 =?utf-8?B?MnhRNlZCMVNPamNlaWg1aVNmekFxYmh2QWdoZFA0WkZ2REVvOXZoZjVXWW4x?=
 =?utf-8?B?bUhLVmM1dXVHMGdrL3B0TVRROVNOYkFyOFhzVE1UWDM0dUZEL2I3ck84RE9F?=
 =?utf-8?B?SXkweTliSnY2V2FXbW5RaUhaZWpWdVp3SUt4dGZ1WDZMTllvYkJMaWE5cE5I?=
 =?utf-8?B?ZzQ4cXUybXgzQ1NCVjdramMzOGxNQjFUZENKMHJuUmVKYUlDTHFDYXpjWkRJ?=
 =?utf-8?B?RUNKQzJHR014eGttdmgvY1dZR2ViS2pZcDFnSTNqNWZpNm9VSVZvMEhmS2Zp?=
 =?utf-8?B?YWJ6cVZiZlQveno4bms3T3lvdldIUTZZT00yMnZaaHZaQlBuQnVETXJlM21L?=
 =?utf-8?B?bDdDREFjZFJuSTlneVRxZGNZVEc3REhJU3g4QVlieTdNczl3M3VxN0pKaGhE?=
 =?utf-8?B?WjNQaEFQWFRvVFp2bnhINElkQmk3YVlyWitYNXAzZ3ZBV09hejNneDU2aDVt?=
 =?utf-8?B?aklpWGRtaUJYai9xNVM5aWpPZXVQM1NmZ1AzYytrYTNNdUwvNUFoekQrNVJG?=
 =?utf-8?B?c3M2TFFvMFZCNnQ1MFpWSGtEd0JwZ1lKNXh0cFIybEV6Sk95ZHFsRlpQZjVT?=
 =?utf-8?B?N3pEcEFKUVl4Ym10aTVvUjl6dUhKYTBGWkptSTV5MHgwbFc0VEJ2N2V2WlF3?=
 =?utf-8?B?dkNXKzlFLysvTjYybFBMbzgwNkJWSVpPcTZVZXZiR2tYbWo5enRkRm9Kc1dn?=
 =?utf-8?B?cWxid1c2YmhDKzR1VjlWdDI3RDdVeXJNdE1oYVhGaW8xZkdUT3BpSlJVY1o1?=
 =?utf-8?B?SnpUeFpNRkF0NXpPUjI1dnl5VVBLUVRFQTFLYzBYV0diL1lWK056NGNySHA2?=
 =?utf-8?B?WmMzSGVDVG9PaDJzTUFkaHNTc3F2ZWtyRnQ2VGluYjJ0Nmh6ak8xQkFCS2xr?=
 =?utf-8?B?elRLTFhZekdWMXdLQ2JqY041MlVCYTFIbFl2TWZ4cEVFK2FwcWJJd00ySWxw?=
 =?utf-8?B?V05uWE9Td3ZOSDVYRTNwRkt2bkp2RngwNGFMT3hmMWI5Y3ZVNDVMOHdLU3Ix?=
 =?utf-8?B?NU91UlU4cmZvUEIyYzBsbk5HRU5SbkZxVjVQVUZPWGxMZkgwS0xwdUtJVmZr?=
 =?utf-8?B?UjUvejVuZlM0WUpRTi96UXlNUEhQTE9haXAzdUl1WGZFWi96UDJJMCs1cHZS?=
 =?utf-8?B?R084L1dzS2V5bk5yOU5oak5yTXovZGdkd3k3OVhjS3czM2xHZVdyMWFBMG82?=
 =?utf-8?B?bTRUZU5NZkdDdVRDNVdQTklUT0ZIOGtKZXMwVXI5SWF4NWF2QjkrZVBJSG9I?=
 =?utf-8?B?Ni9wTUdKMXpPTW92ejEzOHo4TGd4ZldtN1dZS2FGcklJZlF6NnZrcXloT2dh?=
 =?utf-8?Q?9pzCY2I9yQ1pWgJc=3D?=
X-Exchange-RoutingPolicyChecked: U5ndJTJs+PcMN0JgGksmTHtChSVYL8eSBw/LqyIUBfXRBnHhH4+txOPwHMenbmpNo5ZeHycn7jGWDrzmK6KetRn6E+hR52RKnMgyxJ5nVKFX0Ae9A4broBMKXbdKjHBnkQfSzVN8tqZQu1YFVfq1xCRiMw+ja/RZ+tY8cVB4aetxBuguTbwlpJVlGml6sBDuyXyvZPuQUXKB0+IQfTVaVyqNkdnXyz7zc88irurY2xaLPYLaeZljNPH0PLoZSOJCKr5AnkPVO0RvdLQKCTTvZModc52WWKcAkhu9NtnxBmjJtVCABwfJy7GbFwchNHSsonJPZKkOsdoBN8nG4E2CPw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc8cf45-0ac7-44e1-bef8-08defcc462b1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 01:02:33.4135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jk8a4nVwtf1JQj+pEPECJ/zrpgb8z4zkVYktw/ewz+iDrdxyVQZtJGD3kveWn2QkcuiRPTKxrHNuL5vcsm0xduU48l+cPTBBIBjDmdtEu8g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8345
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
>  static int rdt_get_tree(struct fs_context *fc)
> @@ -3175,9 +3176,11 @@ static int rdt_get_tree(struct fs_context *fc)
>  	struct kernfs_node *rdt_root_kn;
>  	struct rdt_l3_mon_domain *dom;
>  	struct rdt_resource *r;
> +	bool cleanup = true;
>  	int ret;
>  
> -	DO_ONCE_SLEEPABLE(resctrl_arch_pre_mount);
> +	if (resctrl_arch_pre_mount() == -EBUSY)
> +		return -EBUSY;
>  
This does not look right. Are you intending to add new meanings to EBUSY returned
by resctrl so that user space now need to choose between "resctrl fs is already mounted"
and "the underlying architecture is busy with something else"? Based on the implementation
the architecture could now also return EBUSY when resctrl fs is mounted, but what prevents
an architecture from returning EBUSY in some other scenario? This error code to user space
does not seem like a responsibility that the architecture code needs to have.

Reinette
