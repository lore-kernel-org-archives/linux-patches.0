Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1CD32D0E3
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 23:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781133570; cv=fail; b=JKAb8MjPtBbCWSz7qoP6o1kyRFAmT7OWEQJ4xUks8qtYsCDYmIopwS+f5sA+UX7Fxrn0AWi2YiBY0xQeBxDWgIBFzDkkqajODQpa7P5QsYRuyN8K5xHKSLkmeJH1nzAIqRGeOOfWvWQkyNQZ9Nijv0534geWWV3x8XfkoT/0OIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781133570; c=relaxed/simple;
	bh=t60D0VUt569nkSudz7dVmMGwcZqsarH/FwDcMIKvkQY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=XrhIJdn2Pi+4Fcah1SL9SVAC7ZXk56GspHqY9u4nY4+TBr8YRum8qDn9ukAhn9C68R5n9Bt8EwXdO4e1Xg02ypm7EY69BGAlvk3HXFjmRZ/yRLjPXTMrHA+54uKL+gqFU3hTaV68dckrpxl4ewMi8DKfDGHk3Cnl1qAvqN8FD+s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khxq4q/u; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khxq4q/u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781133569; x=1812669569;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t60D0VUt569nkSudz7dVmMGwcZqsarH/FwDcMIKvkQY=;
  b=khxq4q/ufsF0K2mBEwZ4CmDO5KbDss8CV8+6Hxgvw5UxJEJUE/25ISZe
   YSjJriuDSt/wMyM8BYTPEDbzRAQzU5jtoNaq2QcPVpFEU22iQLgbtn1UD
   w9rue+OKhuXr/Yag0Fv6M/r17Sjz2uqN+3H7s9xxVAs1QPsw2WkNrPgIS
   k16t7rAeIQbgXAiihkJrvwLCT5b2F2mX7jQryB/UmeJvQd4OK9Z+iEY3w
   CDaLn0/aMduARM8vZk+Ud4fTYMY1QCcwdigD608TAo50diB0Y7Fu1qWKo
   JSvTy1iCJb02lBec1Zv4zMPW1SILPd9SngqnSaQmHqDrSLasxFiNnMeHG
   w==;
X-CSE-ConnectionGUID: MBJ7wFNjSbyHRiusD1pf4w==
X-CSE-MsgGUID: OOejYXagS8G8HUj2g3pBZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="93046564"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="93046564"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:19:29 -0700
X-CSE-ConnectionGUID: u6ayya1pSn+qf3iwrNw6kA==
X-CSE-MsgGUID: Lr2t5ZsWTuyBBPvzMlHJAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="242171023"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:19:29 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 16:19:28 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 16:19:28 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.48) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 16:19:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cIAnyHlf0vfG3lZ3W5WoJ659/FvSDoIGO7R3cKaTLM/XVKmD/5wH3gN6xo1zHMDxWR1sGKeWcmBsP+m8lXErU/d9A3YStO6+WihfyNv8ODJH6BuRFytmrtLCEdECF9KOtipm7u6KDFAGsFvuz0hB6+KjcDVhWpOVQf6+ANkdEjjJXnHcxNsIrcsV0YoiYCgw92xl/ZS2jfj8aVM75a7tY1TwJJjQbcJwg2kmGbsrzlQl5QqHP0TgRGhpzuSUAHQve2iaaGXCTOBaxlcl6eH20ekFzMGRZWGrMF+5S+4Ik9MBDSH1+EXycRV7yyY9tLBnoEtfw9Svsq/xD0kGOSqP9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t60D0VUt569nkSudz7dVmMGwcZqsarH/FwDcMIKvkQY=;
 b=scw7qzPYHSKWcEQdWsadwekaTmOlpojLitCWnqgFZeqBuX7u8ml+5J5ROqTUpSgTD6itBPpD9Pmi1E/iGWkmBiVyZ1W9VP9dFgzKxz1f6P+Z6UdklfsBWNjW0Xms31vHzzl346FF5KtpqnkD5/EJQjvgWap0Z9ADu/+Ap+3grXv686osLpdg39aEGsddvfKtclCqXzgXkqJvANSVzERxg76NdZvFAMpSx63nMm35iaf9asSDnWW/Gv0F73k0ZU2dWBdeU77K32dX0U6NNqLaL2Ohp51vWk4as5ggt9kGmrkqOdfpXx1bDqwLlSC7+uPsrQF9mDLIqzTjfwsQ4rX6Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6550.namprd11.prod.outlook.com (2603:10b6:8:b4::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 23:19:24 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 23:19:24 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
Thread-Topic: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
Thread-Index: AQHc8gDLNynkRvWgK0CwEO8r2J0qFLY1VjKAgAEusQCAAF9RgIABbyAAgAAZEYCAAA2pAA==
Date: Wed, 10 Jun 2026 23:19:23 +0000
Message-ID: <SJ1PR11MB6083DF803C214160BA106555FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-7-tony.luck@intel.com>
 <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
 <aihLqhlxS7l1y3jO@agluck-desk3>
 <7bbc2796-0f33-433d-a949-d95fa1db6401@intel.com>
 <ainPljLE0yc0o1mv@agluck-desk3>
 <f9b0c233-04a7-4ddc-b792-f2def000febd@intel.com>
In-Reply-To: <f9b0c233-04a7-4ddc-b792-f2def000febd@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6550:EE_
x-ms-office365-filtering-correlation-id: 52045037-ddaa-42c7-a715-08dec746b581
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|23010399003|366016|38070700021|3023799007|4143699003|56012099006|11063799006|18002099003|22082099003;
x-microsoft-antispam-message-info: +v1fd1O6fv36jsRx+KKfN0sOfY7my+y3PbFsOIgqwIoih4L99UXXj1X1g/tFSiMQ48XyrFM9bbJT04X+Aw24p6sBn8UAjg7kRS//XygcOtJrUdXQBDGWErtND7CShvdKsSI0v+wZ5k0sKWLeNBjdXSm4Jbsl0hDQ/3/fp8L++Pfxfg/Ju8WxHwY9Bw3Mosd3ZoMKNkDqiyA+4QbOAYnjuwCp6OSVIGFB+ltn66UzPibReCjgEwTdRrA9Lkvq5Lts7Em6UQ/F2jBsj+gSKtfjSMV+Rf6F00XesNBl28NJIqDMXJFd0iiTV2cE514gbiTYlCQIKrL8jKf3vAzag9FOeFeRcKvXvuLGOtgaT9qJ7xwmQrG9XBpNkcUy1FK5rsFL/oXYn7MImQxRrnvVIqq+ezUHbjUjPi29/hM04+Zx9hrMTbrcDazLKI8iyG9wDLw3rzsQakF9fVYNawpNYQHTfjHEWzetey362k5ZZh2GHiJh7IsXf5AhsH+8JCDZpdY5kCVJBR1tHv0saPpSiCK8VY7k7f3j2BoXbLmV/UNfyd7m/f3mK9HWbIuBzX+A6TSgF6NA+NEdXpiOn/0AEfmbrUSgfObM/yZNA98tee73aDoTD0CwugPSON07e/OAMg5IfGMYbygqi4nHqG+fSCaXzzlY2IQFqtx8f3ugoZN0pogaTF4gkzCOvwKKhG+WKgrHNUK1bYf2uboMBYBOiR8mB4AkFmjb90yvBpaFEBT6eFysF/Aha/r1AMSISEACLe+f
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(23010399003)(366016)(38070700021)(3023799007)(4143699003)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWQvSFpvNzhHcU8wRmZVU3pMa2hqK3N3OUw3U2NPUWVmbmRtL2dzQXdsZlZl?=
 =?utf-8?B?dnMwRzFYVGVHQmVWSGxBN2g3WU50TmFwVi9HVktzRWxJcVhOdDRadzJvVUFM?=
 =?utf-8?B?MzMrbDJWVy9yd2dXSCtUbCtpcW9wM1VNT2FRSXdpV0lGTmNzZFFnN0tmNHp6?=
 =?utf-8?B?SlVkak5BUGNmTE1qQWJHRDBXY2hKZEV4YVc1VHRZckhiQjFSd0VNdHdZejlX?=
 =?utf-8?B?cVZ2WmtRSlVGTmpnK3FSQkUxbWNOMlUyWmdBZzZpdlk3VWpZQ0l4UGE3ZlZD?=
 =?utf-8?B?L1dlZzNIMU5OeXdkRnFlVmkvekdGSGI1MGsrYlZ4RjRKSzR5a2lxK3UwK0cz?=
 =?utf-8?B?eVNHakxBMzR2d282MmxrbllqaDBzYUpjN3VILytBTEhTWGY0Z0I4dldNMFZi?=
 =?utf-8?B?K2thSzZOM0c0UnIxZ0c2d2lGMEhyTVlRZ0xDYnJheWRZa1hUWWdzekMwOWxp?=
 =?utf-8?B?SjNDTU1SZy84OWNtQnZGeVY0cmEvZ1M3WHcyZkpVdDlibDlESmc0K3QrclQ0?=
 =?utf-8?B?VGlxUG1CTTV5aDVxdlgvVk1iczdmTVVtVHFBaVQ3ZUpUNHNmSmV6aXJ2OVl4?=
 =?utf-8?B?eC9QTm1DRjc2aWd1MFcvSGtJb3VaL05sNFFGbGM4d0cydXc5c3VkNTZUUkUv?=
 =?utf-8?B?WGswVENpV3MweE8xY1FXV1E5UHA4OHkrSDh5ZlpYU01KTmFESjN4MHMvRGNQ?=
 =?utf-8?B?NjIwcG1jd0VKaTh2aDM5SmxXM3ozOFprVFJEajc4dHZRdVpYR2hqV0tacHNR?=
 =?utf-8?B?ZVBURmJ0TEpheTJ4aGExN3hrZFlsRTJkbVhxNk1GZFJRaWlkczg3VThMc3B1?=
 =?utf-8?B?VjlyMDRuVTg0Y1BXSXdicGdsN0NWTGF5WUIyR2x3MldYMzZBaGpxRDFVT3dP?=
 =?utf-8?B?Y0szLytrLzVidnJCTU50dWk2bktCQXFaMlZQYm5BaG52WWN1UlJIUEluanZh?=
 =?utf-8?B?Nmt6WjFGSUEvMXRFaXBpdG1vUE1wTHB3aTdjNmp6cjNtbC8rakhpS09YSW82?=
 =?utf-8?B?aStUYStORitXTHRCWG56UE9DM2xUcnlIU3hERHk3NXRIT0dhT0xPdm9PSkQ3?=
 =?utf-8?B?aHpwazJLdnRpc1NsZlE3dFpWZDlBQUhBNVNoR01rZlp1OWh3S0t1eWtQUVZ3?=
 =?utf-8?B?QjlEUjlCd1R2SU1NcHI4WUxXd1p4ZVJMTlhURG1MV0FTTFVneXozWnROdkk1?=
 =?utf-8?B?Z3JOMlYxS2xhYkg0cmMxOHcvYlhCNHlqcm9NV1JHVUkzb2dBUEtMMVRRWkQy?=
 =?utf-8?B?WjVxZVM0eVJZRjJEbzhxM1ZNeHJvcU1rUWY2bUhmOExpWEJlbTRabm9hVlhL?=
 =?utf-8?B?TVFNM0NieWM1OEFTemNSS3ZWZk9HWUxxZ254clExdUlmQXZ6MXgzSVhiZlhJ?=
 =?utf-8?B?K2tvRk5QcUZ0RDBmT0x3K1pwNUNHRkUvcFZWb0pWS2FiZnUwRTUvY0lUUUV2?=
 =?utf-8?B?RkRFZFcwZUprRDMyOEFtVTdjNzhtZEcyQ3RzMjVBL0NSc2lKdjNPUy9GYXlI?=
 =?utf-8?B?UFBtUmlDYnJaYTNacDB2OUZ0WnFrdTg0OXdZRFFvNjBBM21xMDAzQWJZSzZi?=
 =?utf-8?B?ejZxMkVCc3lXc25Ld1dUVHh1UWlEYVBaMzVTcDN3L1p4WTlOYk9wQkJJQkdl?=
 =?utf-8?B?ODkwRmM1cTdDN2hPYXlSRk5zT1JWT3c5ZElzZHppRkpyRHkvSnVvSXpDWmYy?=
 =?utf-8?B?dUVsZVFkMHRQUWVnYTB2bWZiMVl5dDlLcXRRQWlrVjlrbFY3RTZ2MWFyOEh5?=
 =?utf-8?B?MzJjUXFSUjdGVlNRc0szUlQ3MWlwTVpmTU51RWE4dWcyZnBjdTMrZXRvdS9z?=
 =?utf-8?B?VjN2Nnhoa1NwSzBuNHFkcEU5bGg2SnFFUForbTJFY2VBa2F1bU04dHVlYll1?=
 =?utf-8?B?aHhpdUZ4ZmVFdG0wQktEWEI2aDhxQ3dFZjc4TSthdFcwa3BPaVN6UXZWWDZy?=
 =?utf-8?B?SURuVmUyMVZ3djFHZTVBemQ4NXdWZFZkSXd6MXBoZ1ZIYWRleEcrOUJ4Vkx1?=
 =?utf-8?B?ZHU5KzhYTThwMFl4QXdGZzUzRjBxQWRKd2puQTBVSkduOXZuRE9KVHJ6c2Nx?=
 =?utf-8?B?UXpCZFdPQ3UwbWkyQ3hhOHdnNlBBVUo4VWVYSFR4Z256VGlock1YYXBhU0xG?=
 =?utf-8?B?SUVGSkxFWWV2aXdZME1uQkVlV24zNUQreHo5VHQyNWFZQnViTTBqKzlXWG42?=
 =?utf-8?B?TStMZGtScGgyVVVLT2h4TWV5ZHpmMzVTN0hDaUxGeHVoRC8yLzJBSXFXRGx0?=
 =?utf-8?B?VGhiOUtZaTZnNWtUbzB0Z2dQYWN5ajAzVTB1MU03YmNkL05ZYTlwSjNyWnpU?=
 =?utf-8?Q?Q6iUsk9sHBUtkAIgBZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: cZTBMjGPgoURrFHL50J3hQ6sU5UmSLxPwMTlS2jhT3JMaM7cZ/4LfgGungp/K72jQXvIKqIHO5mhzuFUFdqNvcGOn2qXytpU+XidggB2JLMMFzRlpzgoW72MKDQO0bmT2DHr+is7CWpOfaasXcZWeKmSY2UfKRa429t5LTW+BUnVynbPQIw6yVjUniOES7qUs0D1p3Gx9vVUSXKuilbvr/L652mMb9YQ7gbmLwGRwRK19ttduQdtulyXcNLmIYC9iZ0DXaQgWKXBrtOWSWi7o4zOSUPCTz3eKo1F6psizOo3ZJjHYIOGf9UJw5Y0CdywKX1fS5MyVFwJa/UMyLFgfA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52045037-ddaa-42c7-a715-08dec746b581
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2026 23:19:23.9582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7yH1beCuiGfVkYxsNg2A0iUMWoj03WUah6XE70WpzXdqHTklRrrflS27QTex/pnAXUSz59s40egA0LC9Igwtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6550
X-OriginatorOrg: intel.com

SSB0b29rIHlvdXIgc3VnZ2VzdGVkIGNvbW1pdCBjb21tZW50LiBEaWQgc29tZSBlZGl0cyBvZiBt
eSBvd24gYW5kIHRoZW4gYXNrZWQgQUkgdG8gb2ZmZXIgaW1wcm92ZW1lbnRzLg0KDQpJdCBjYW1l
IHVwIHdpdGggdGhpcw0KDQotLS0NCg0KcmVzY3RybCBjdXJyZW50bHkgYXNzdW1lcyBhbGwgbW9u
aXRvciBldmVudHMgYXJlIGVuYWJsZWQgYmVmb3JlIGFueSBkb21haW4NCmlzIGNyZWF0ZWQsIGJl
Y2F1c2UgcGVyLWRvbWFpbiBzdGF0ZSBpcyBhbGxvY2F0ZWQgYnkgdGhlIGFyY2hpdGVjdHVyZSdz
IENQVQ0KaG90cGx1ZyBjYWxsYmFja3MuIFRoZXJlIGlzIG5vIHdheSB0byBkaXNhYmxlIGFuIGV2
ZW50IG9uY2UgcmVnaXN0ZXJlZC4NCg0KQUVUIGV2ZW50cyBhcmUgZW51bWVyYXRlZCBieSB0aGUg
SU5URUxfUE1UX1RFTEVNRVRSWSBkcml2ZXIuIFRvIGFsbG93IHRoYXQNCmRyaXZlciB0byBiZSBh
IGxvYWRhYmxlIG1vZHVsZSwgcmVzY3RybCBtdXN0IHRvbGVyYXRlIEFFVCBldmVudHMgYXBwZWFy
aW5nDQphbmQgZGlzYXBwZWFyaW5nLCB3aGljaCByZXF1aXJlcyB0aGUgYWJpbGl0eSB0byBkaXNh
YmxlIGFuIGV2ZW50IHdoZW4gdGhlDQpkcml2ZXIgaXMgdW5sb2FkZWQuDQoNCkFkZCByZXNjdHJs
X2Rpc2FibGVfbW9uX2V2ZW50KCkuIFRoZSBhcmNoaXRlY3R1cmUgb3ducyBkb21haW4gbGlmZXRp
bWUgYW5kIG1vdW50DQpzdGF0ZSwgc28gaXQgaXMgcmVzcG9uc2libGUgZm9yIGNhbGxpbmcgdGhp
cyBvbmx5IHdoaWxlIHJlc2N0cmwgaXMgdW5tb3VudGVkDQphbmQgZm9yIGNsZWFuaW5nIHVwIGFu
eSBwZXItZG9tYWluIHN0YXRlLiBEb2N1bWVudCB0aG9zZSByZXF1aXJlbWVudHMgaW4NCnRoZSBr
ZXJuZWxkb2Mgc2luY2UgdGhleSBhcmUgbm90IGVuZm9yY2VkIGluIGNvZGUuDQoNCi0tLQ0KDQot
VG9ueQ0K
