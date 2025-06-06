Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965BF78F2F
	for <patches@lists.linux.dev>; Fri,  6 Jun 2025 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749227187; cv=fail; b=Kttf5KTJ8QQy9icAdRDzZy/Y5bCOIaDoPcndfiv/q2z3dd62/t8hrwywzwmeoUB6mns69GMvUCRPItslugzs73drRVL7o1WU8h+fy1376TFU6lvS2se/cmkyMmpc5c/RWoeg20/X2OSh/0qUhudEnswgfv1f4KR4Wx5ISUiVenw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749227187; c=relaxed/simple;
	bh=1fJkgnN7UtVLkbwJ9qwzpbjDGJrz7fen/1AbX/2eU1Y=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EfzlA4yTvRH1lc3ZGwFaV67MqJdffYgwrSoqwjFoWUkBC6VNedjPL2p/6V6qg17Rtw3XeMoHKCSC75ceWK7l03/DPU5mia3fRgdNc3MAGM0401XSbRF8HsRQORLHvKaHhopoU81C7i/0zTa/KZriOueQnvOt03atoy4Ke4EGH3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y+A9uz3a; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y+A9uz3a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749227186; x=1780763186;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1fJkgnN7UtVLkbwJ9qwzpbjDGJrz7fen/1AbX/2eU1Y=;
  b=Y+A9uz3aPSUrISQPbJyWtkZCv3I9FpdsGjS1iTxEjIUPnMa5uVqneqWP
   JOBfhtFMbc1q/iZ3aEfRIKgbF1HV5K0zlBQolqzctPyY6rIrlnDPw23cn
   UecehUc2ZdHNZhV8EzST3Cx+aTDCNFsiC1A/qViAiiOWJxPMHaWKUgRM8
   qxhiZ+DkjuV0HD4IukkiWb9iuDHxo0yW0FKxrJYy2F4F5oxjSulAgU5ZQ
   uiSAjM/R0vOKVri+SWIWY+yXICuY9GT5M4kG03UqTsncHJ/gpIhPVklB4
   TpImhY+AJkDhb7sTy6J2yuMdUL+IKvvi5hhRkxUXLBstkTIAOQ1PqsNMq
   A==;
X-CSE-ConnectionGUID: CwMwPNZ3QoCytpy8BvIGfw==
X-CSE-MsgGUID: CGpa3fSCTMKFa/uH1rW2rQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11456"; a="51290008"
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="51290008"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 09:26:25 -0700
X-CSE-ConnectionGUID: CtZJsOP5SOGgG7XO5JXc1g==
X-CSE-MsgGUID: nBIjTqHFSl2FxQycd16WYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,215,1744095600"; 
   d="scan'208";a="169056465"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2025 09:26:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 6 Jun 2025 09:26:23 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 6 Jun 2025 09:26:23 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.50)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Fri, 6 Jun 2025 09:26:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wcppfG/2On0l1JmPX4vneNQCKL/w03W5GCQ4MqaN8BJ7DxvOInqg/TkM5wuz3UEpjMYNo6hg06kVOEb1BIFmTttRCQpOR0HAjait7PPDBxUPRNYZ7EFqyIqsgNQoaeMsVUriXv8rGjrHqBRVRFruBv9bsvYfg70O1/mOz6D+NQr2okLjluPjTnbYdnxy7UxUg+vb70LpV08yVk7aOV1k7Y3KRdElUe05yWSQWrZHRFLhjZ77KZSxaHpgpA83zDhFnaEvAUYXsV0x/6/qJ7ei7/wQh1qW5kSFfNX2+2d4suJBJFWVXMDFVsDV0NoyP9+UQYNerC63aFBDURGKZdi3Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bwlk0pE6Nx6EcHg8WqVACgjHkxxGrUF+bLCf8DRcPfU=;
 b=PPtrgeAAnIfZ4skH3//vUYfdwLLGMcImVs6xSqOJvU4JhfeF4lOGJCvDR//POXzjFG3mVXg0F1u7Wp/cK22jizVQJ7kAdJTZB+RRx7HwM3fzD/RzHVT4ol6FxneLR7TdNyQ+CTBxUUTtkqJE0z1ewj8pBPAJUw4K+eZe+kZVdeTaQP8iEFufxXfkqaRjZbAuBcHojqh0qgFCqhKEGekKHCKwdFCokNN4/Psb1U3tD2Qcg0Yj2F9bpD930Q0npRkt7x/ggDtP6zp8AZomc19QjBXvEHGN6I3nlbOU0UAvzNPmSGGlo4tx6mxQ5mK//non5Nr2ovr9jUhxluktbL2TdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPFEC89C124F.namprd11.prod.outlook.com (2603:10b6:518:1::d5d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.25; Fri, 6 Jun
 2025 16:26:08 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Fri, 6 Jun 2025
 16:26:07 +0000
Message-ID: <9eb9a466-2895-405a-91f7-cda75e75f7ae@intel.com>
Date: Fri, 6 Jun 2025 09:26:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 27/29] fs/resctrl: Add file system mechanism for
 architecture info file
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-28-tony.luck@intel.com>
 <f25d136c-b1d3-483a-ac77-92464d7fe25c@intel.com>
 <aEIxzbuFybLBE3xt@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aEIxzbuFybLBE3xt@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::17) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPFEC89C124F:EE_
X-MS-Office365-Filtering-Correlation-Id: ba3de644-5c01-4c3a-fbe4-08dda516d754
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cWZWUklqU21JUWFSTCszditKYnZEeVc2NnFIM3RCVmt6eXpHL2RMREo5Mm12?=
 =?utf-8?B?TlJBYVlNMlYyV0pYcDJQWCszL2hQMmNTYS9DbnNnU2c2clczQ1NmeVQ3SGla?=
 =?utf-8?B?VUVXREZWb3B1Zkl1cmlCOExOUzRWUXFrKzlXR1lqWUNKOHovUlZ2eCtmbWZp?=
 =?utf-8?B?cDRYTFhmWW9rUnphbzdMeFNIcEpma00vcnYra3NvdGlLM2V0ZGRQanNCVHVL?=
 =?utf-8?B?R1UzM2NGYURkK3lqT1ZZa2V2aUNGRk03VllVb1dYVzgzbDFrY0hpeG5FY3Vp?=
 =?utf-8?B?RTdmaUlLREpNaVVqckRQWkJSWVI4VDVrU1hYTXdUczE0YzVxQXgvY1N3S2tQ?=
 =?utf-8?B?d3VXbnQvMXlPY25RL0xvUHlhZTlKUzRXQlN6MnhNcXUxSGVqL0NaaU01YTl6?=
 =?utf-8?B?WElGeUhUdHpHY2RvSWF6WHV1SklDVGlKdGdmam9qTk05Y20rZWdtNzhaWlJM?=
 =?utf-8?B?bVIweTNtNjJBeGxERjdwOGNvakVrS2JUdVBwRmFEemoyMDZQZ2dMN0I2WnBB?=
 =?utf-8?B?L1Z5MUJNWWpXVmU2aEJLMGxDci9MUTVGVlBhN2RvYjBoNzBXTmg4VS9JVnQ2?=
 =?utf-8?B?amw4Q0FTTnNveGFBOXFxUlVvR0lPQ0NTYm9SK0VMdjFmcVVYKzJFYTJUOGFQ?=
 =?utf-8?B?T2czTm1TVDc4NmNoV1FucUE4SUt3c0JUem04NFBhMFVaWGdNUkRJdkJXMVkr?=
 =?utf-8?B?MTBXeE5GREVHWTM2alB2K3kwZGxYSzVYSi9EZkdkNnR3YTlBR1owUGdKU1lS?=
 =?utf-8?B?OXU3N2ZsYnE0L04rUTRqd1JlTDF5MzFuMHR6YlhQTHZwU0tVU054Q2NUVllS?=
 =?utf-8?B?TVZ2NVJNOENqcG1Fa1M5WnlYUWk1aDVYbTdGZ0JtTHRSWVZ3VXN1VkowM01w?=
 =?utf-8?B?SjEzL1ZDQ0RWYiszb1hnek5CUFRjUVM3NURFR3dpY0ltNlpWQ2xEUjVhQ0xx?=
 =?utf-8?B?cFl0RW5BeGphNUNnSEhYVWZvaHIwQzgvT2lnM3JjbDh5RmlPM0RtTU4zdkRj?=
 =?utf-8?B?SWphWHJsbkFDdUhrS1U2cW5jeXNZRkFIc0FmMWNyYlZoaXhvK2lBSU9SR2J5?=
 =?utf-8?B?K3AzRENvbXFNNytySCtFc3VJOFMrdEVCdFdkT1hPRGFxVjRvRzVsVFVjdG5q?=
 =?utf-8?B?UjNVclRpZ0hYWENrdDFZZWhQKzFaNGFGTkFzWTNYRDR5Y0ExT2toejFLd1JU?=
 =?utf-8?B?WE94YmM2MnBrMHJoVTBMeEJFSVpxK0NCMFBKNFFqR0JWTlVHTDIvd3pydEpX?=
 =?utf-8?B?TGNmZFMreHloTFl3SG5PVUpDeGNKNjRCU1BPTkNpOTZkYzBUaHVEY1FVQnN2?=
 =?utf-8?B?UUxBUnZmWUFUTFFrSllnVEtkVmZoL0dCT3hIKzJuNUV6TmRtQXJvOHRZdkFO?=
 =?utf-8?B?RXpPcnJ5SC9Xak0vWjF5VnU2bzEwMmxjQlByZ0pRak90b3RQc0R4QTN0d2U1?=
 =?utf-8?B?Q2l0YU1pYXBXUnBrK2tuaGN2KzFBRG1MejhIWmovcmFjWVpYdWdReW5HYW9M?=
 =?utf-8?B?V3BGb2JJOVhLTXFzNW5iQ1AzenNjYzhDYUJBTXN6UlRlZmJ0eWUwRVg1aHZC?=
 =?utf-8?B?cThSdkFsZnZvUVRpTnFadWsxeTh3N3V5RnNhL1hWVDhleVpRcVl0S0RMYlRC?=
 =?utf-8?B?dDYwNmVHODNnZHBXdEk1Z3FuZUFESXJKSW1CbEg1ZGZtZGljZjRtOG1tRmo1?=
 =?utf-8?B?MWpkMExZMjBXUm9yQS8rWVBsYnJYaE00Z0RJM2syL0l2ZW8zTFZKV0V4SGRQ?=
 =?utf-8?B?TVJiMXdkdDVEd2JUbHBhSkNPUTg1eEdBMUlYM3VMSktla0NrNW41ZDI1YkUz?=
 =?utf-8?B?bGRVZTFQSFdwNnZ4WjVBWDFocEcySVc0bEdaQ1dPVzNsSG5HcHQyL2ErWk9L?=
 =?utf-8?B?d0RPOW82cmRHQ2xMamRKN2VJd1pSMS9BdThEcGp0bHF5UDhxUTRaQTBJdmw0?=
 =?utf-8?Q?nY5LNDY66T4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ei9aMVhmd3RRRUZVTVlrY3pxRUtJZ0paL0lwUlFqM3Jrd2t4Um5xcEd1cjZq?=
 =?utf-8?B?WXhxYXBKWTNDU2szNDJ6dlUybWNuM1hjRFFsWHBwek1ZbmY1Q08zMThVd2VU?=
 =?utf-8?B?U1d3clFDeUduYndVS0xNRXdMditDYlM4YkczUTN4SC9URVJIU2NZczZIeGxn?=
 =?utf-8?B?TjBCMTdGai9xSXpiM0R3cXZTWXZrVXZLNjBqTHc0VHcrcngyOEdKL3dhMkJj?=
 =?utf-8?B?bTNSa0c1VmR2enBlMEczaEpuKzdsemVpR0p5andoMVdNcUtIN3YwK3pwWHM2?=
 =?utf-8?B?WkpvU2JacUZxKzZ5VFNxanNhRC9lMExxTWNHdlZFR0lmWWQxQmdaMStTc2kx?=
 =?utf-8?B?S3RDL3RPaHl3di8zc2djMU1KUEZCc0hPNHlBbjRSU01sK1BNT2RobDlTUXZI?=
 =?utf-8?B?Mmg5VWpmaXA0MU9JNUVUR0hSOFZsUVNhZDZrWWI1MWhYR3J0TG1zcjlERnNQ?=
 =?utf-8?B?L2JPa3ZHVnQ2cTQrYlJPZWpsQlY0TmZoVWpsdUp1MnZET0xGaFFNY0FRMGRh?=
 =?utf-8?B?UjhzNlJ3K1loRXFaRGFQZzZCekNiaVBMdHZSQXFwYlp0eEZkLzV6cTQ3VlR6?=
 =?utf-8?B?dEV1c2JNZG9MNnM0L3Zva1hJdnd5aWJNbjB6bXlwWUxRQWIybDhwUHpQcVVB?=
 =?utf-8?B?M0F0VEFtRG9iaWU5bDVJa2k4dW5BZkNnM2lOd2Y0S3Jaekx3S251ckRSem01?=
 =?utf-8?B?eHJlVzhzeEJwc2htSVIzcktwMkZNVGYwQmxFTmVyNmdERjUvTTNJSWtLNWlS?=
 =?utf-8?B?Z0s5dmNFT05rLzBheFJORjcvZTU1TUNiMXNaYnhDbXdMZldKQWovQ0FpcWls?=
 =?utf-8?B?enRZU3o1WFlPbUR0bmZTY2RRNDQwZUhOUFhZdnRZNk1LWFBGTnJ2U0hTYVRl?=
 =?utf-8?B?STVVNWVBcmlpZUh0RE4wbW9DcmgxNW5GaG1sM21OSE8xdnMxTHJBS1ViZzBO?=
 =?utf-8?B?ZGVzM3FLb0Y0aVJOcVR1Q1FPNitEVUM2bXFDWU9mQTRkQWV0YWFxdlBhQkhk?=
 =?utf-8?B?cjF2MzUxcXEwcXJOUGxhM3JyeFBVRUFQem9ya3Bmcmt4VHg5WmFGMEtSRDZs?=
 =?utf-8?B?cG81bmNmUjZvRmNXb0krS2QyNWZkWEJIbldxOEVzR2FSTnQxY25CLythSGZ5?=
 =?utf-8?B?SWNBamJyY1ZmaTFlRFlBS29FWnpVd0lkS2ZBS3l4eGFxNzFDeFlwK3h0RzVz?=
 =?utf-8?B?RHh0RDlzeGhmb0g3dUVOcTh2clR4eE9jZzQxZE5mSFlnYUtWU2ZCNDRValY4?=
 =?utf-8?B?K2UzZnNla0haMzRVTnh4WXZERHIvVXlVRENEYXVOb01ENjlyRXZsODd0MEY5?=
 =?utf-8?B?cUp4Rml4QkFJRGlWckQxWjJQN1ZpdlBYNkt5VmVPc0MvMVZRdVZLUmtiSk1P?=
 =?utf-8?B?NGxKcjY4S2hLbWRZM2JTUUZhZGcrOTl0YnRvYzRqN0E2M0s0dE5zWjVjS0Q1?=
 =?utf-8?B?ZWpxbEpjVTk3SXltWFUrdDBSWHZjMFRoUWFQTm5XL2JPVzBiMUZRTW03R2Jl?=
 =?utf-8?B?bmJkK3hnN2hZMFJjWFZRL2tUaUpPWkhsdUlSZ1A5WHZYaFBlVkJ2SkdWMzF1?=
 =?utf-8?B?R3VKc0xTUndGUXhwY0EwbkRsYnR3WTdOZUVLcGlKV2Fzc3RXUm9hTEsxYW1k?=
 =?utf-8?B?UWZUemlJbGltaGVWQ25Ja0tiSXRXTDZ5UTVMcDQ3RXB1aXcrV2FjeEZwSjlH?=
 =?utf-8?B?N3NSRDdPbmppZTNzRkFuRWlkWG1PTjZueEwxSzRaZnBOWUUvN3p5N0h2MWtu?=
 =?utf-8?B?SHpNUDhGM1R5ZmFWMi9yT1FObUJ4N1FCcjZoMElJV0dkaU5VVHZYQ2lKTkdl?=
 =?utf-8?B?VWZ5elExZ0xiTktNNjVmU21TaFVhcjcvM3RFdndkMFRHaHRYeGRweEFwdXB3?=
 =?utf-8?B?ejh2VnYrZldLcXJUb25XZ0ZqL1VlaTV4UFJpanZ2Vy9rUEFtSEpzOHAwSEpx?=
 =?utf-8?B?VUx4VDNqYkhQVVZlRTNGWDZjVkkvY1J5YlJ6TVBlN0ZDUm9mdmdONDh6QUsw?=
 =?utf-8?B?L1VSb3Z5ZFJPZzN2YXA4a0UzYUsxUjZzcitvZ0JLUDNKZTBRdGx3OXRraTNQ?=
 =?utf-8?B?bFlFRHBCdGEzVCtjeTNpTS9GTy9QNHFGelV6SnphT0NuVjgrWFVBVUZpeDFH?=
 =?utf-8?B?VTU4ZmlsV2s0OVZKNGhzZDZIankvYnl2elVNOWdlUVJVNGJucE5DaDA1RWJv?=
 =?utf-8?B?c0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba3de644-5c01-4c3a-fbe4-08dda516d754
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2025 16:26:07.8725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zWVZn+w4xeugiMT+hEVkgSQVxzKpjpubYCilTUJLtW0U3PQhbQduyskLpHB0GV6Q2HLm9vhsmVqYdTgz2+gE3pDatdMusnpe0KDbD6qNH0o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFEC89C124F
X-OriginatorOrg: intel.com

Hi Tony,

On 6/5/25 5:09 PM, Luck, Tony wrote:
> On Tue, Jun 03, 2025 at 09:15:02PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 5/21/25 3:50 PM, Tony Luck wrote:
>>> Creation of all files in the resctrl file system is under control of
>>> the file system layer.
>>>
>>> But some resources may need to add a file to the info/{resource}
>>> directory for debug purposes.
>>>
>>> Add a new rdt_resource::info_file field for the resource to specify
>>> show() and/or write() operations. These will be called with the
>>> rdtgroup_mutex held.
>>>
>>> Architecture can note the file is only for debug using by setting
>>> the rftype::flags RFTYPE_DEBUG bit.
>>
>> This needs to change. This punches a crater through the separation
>> between fs and arch that we worked hard to achieve. Please make an attempt
>> to do so as I am sure you can.
> 
> The file I want to create here amy only be of interest in debugging
> the telemetry h/w interface. So my next choice is debugfs.

I believe we can make either work but debugfs does indeed sound most
appropriate. I am not familiar with customs surrounding kernel support for
hardware debug interfaces though, so setting that aside for now.

> 
> But creation of the debugfs "resctrl" directory is done by file
> system code and the debugfs_resctrl variable is only marked "extern" by
> fs/resctrl/internal.h, so currently not accessible to architecture code.

It would be best to stay this way.

> 
> Is that a deliberate choice? Would it be OK to make that visible to
> architecture code to create files in /sys/kernel/debug/resctrl?

It should not be necessary to give an arch total control over
resctrl fs's debugfs.

> 
> Or should I add my file in a new /sys/kernel/debug/x86/resctrl
> directory?

Since there is already a resctrl debugfs I think it will be less confusing
to keep all resctrl debug together within /sys/kernel/debug/resctrl.
There should be some bounds on what an arch can do here though.
There is already support for debugfs via the pseudo-locking
work where /sys/kernel/debug/resctrl contains directories with name
of resource group to provide debug for specific resource group. Giving
an arch total freedom on what can be created in /sys/kernel/debug/resctrl
thus runs the risk of exposing to corner cases where name of arch
debug cannot match resource group names and with ordering of these
directory creations it can become tricky.

With /sys/kernel/debug/resctrl potentially mirroring /sys/fs/resctrl to
support various debugging scenarios there may later be resource level
debugging for which a "/sys/kernel/debug/resctrl/info/<resource>/<debugfile>" can
be used. Considering this it looks to me as though one possible boundary could
be to isolate arch specific debug to, for example, a new directory named
"/sys/kernel/debug/resctrl/info/arch_debug_name_tbd/". By placing the
arch debug in a sub-directory named "info" it avoids collision with resource
group names with naming that also avoids collision with resource names since
all these names are controlled by resctrl fs. 

To support this an architecture can request resctrl fs to create such directory
after resctrl_init() succeeds. Since it is custom to ignore errors for
debugfs dir creation the call is not expected to interfere with initialization
and existing arch initialization should not be impacted with this call
being after resctrl__init().

For example, for x86 it could be something like:

	struct dentry *arch_priv_debug_fs_dir;

	resctrl_arch_late_init(void) {

		...
		ret = resctrl_init();
		if (ret) {
			cpuhp_remove_state(state);
			return ret;
		}
		rdt_online = state;

		arch_priv_debug_fs_dir = resctrl_create_arch_debugfs(); /* all names up for improvement */
		...

	}

Note that the architecture does not pick the directory name.
On the resctrl fs side, resctrl_create_arch_debugfs() creates
"/sys/kernel/debug/resctrl/info/arch_debug_name_tbd", passing the 
dentry back to the arch and with this gives the arch flexibility to create
new directories and files to match its debug requirements.
The arch has flexibility to manage the lifetimes of files/directories of
its debugfs area while resctrl fs still has the final control 
with the debugfs_remove_recursive() of the top level /sys/kernel/debug/resctrl
on its exit.

What do you think?

It will need more work to support an arch-specific debug that is
connected to a resource or resource group, but this does not seem to be the
goal here. Even so, with a design like this it keeps the door open for
future resctrl fs and/or arch debug associated with resources and
resource groups.

Reinette
