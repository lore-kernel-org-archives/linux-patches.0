Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C60863CF
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764691298; cv=fail; b=nJ+d/C0xoPn72B6eIPJWaqM+bJf2Kn/zk5f0hN+dKNLh/srudAYoOoLP1M31LaG9XMRVy9zH0NuV2oTCsvYbtqCMEq0T25lO58t78qlFNjXc9pFQ6U9AL9YkJkSh+RkcDORvgOnNjNzfzcfW3DPdKDpL0hmD9a/PBiYo+6r/a84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764691298; c=relaxed/simple;
	bh=8NxaYrHZi5emdlIjIPqb4LMOD/okvXDQapuShG2UI8I=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XMW2lWA6OW4N64+bRDulb6pij+OtmxWqfgsZe3HlYdTGjMc6sWZjUXeSm0Jkgo1U2zywJ3jDohOCjwHBTwjR4I6DyRVowTMvJYXd2bB+wJirmPrgDUjHWaHqq5/w5gvV870YRHbDWbzf1z3MpHwLPJssAHXwNa0yIxVb6SlWO9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AJsrRfZP; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AJsrRfZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764691297; x=1796227297;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8NxaYrHZi5emdlIjIPqb4LMOD/okvXDQapuShG2UI8I=;
  b=AJsrRfZPLzGkLzGclv1ioGyEPJ7f6XLEeR0zZezXV2/Sy2vJYaVvLmjO
   TlWU5TO5nc3qwju12oOpKcYi0DD/ylZyaJuoumRvqAeYklyWRfwWXlcI6
   YA9crM2jfwzci1AhmMLuMR++Sli4crmg9oCfb0jHAnH5/7Dsi1hpOmLm1
   WdtNWMGo33DiioZWa96YhwmbLis1pupykcNC/FWR/j6tPi6/c4KIee7Ey
   tHAyU7HsbpaqaYPg8D1aibovDesQffcGN7MkTBUNU95mYETRJt5ar/G2L
   bXO0Az0hIJwEuLMERuObB6KHdIvvLOyly+YoHyyvsmLtp/+5PNY0P5fA4
   Q==;
X-CSE-ConnectionGUID: OH29LRT9Rpiqjlji12dHRg==
X-CSE-MsgGUID: EqTHKqrPRFG+82u0YO6UYQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="89314218"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="89314218"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:01:37 -0800
X-CSE-ConnectionGUID: YlAQbIm1TH6/SRPbfpKI6A==
X-CSE-MsgGUID: keoRKBqWQB6LI5fCvh560g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="217765321"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:01:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:01:35 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:01:35 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.6) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:01:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qc5WYPC5cqLLhfTineVF97fo8O2wH1qFzVH1hKmYeyNy9dWViEf2VjQs7ZL/gbZEjJR2sW08DlGGGYjvDQ6HpfOa5kYrDct5Xq4jQ3EY/pE+9T3tzF+X6LXsEt8ey4za3W8/KwvwiPa2jW8huRd5dAPSbi+r2b8aumLaKJ5fPEkmYq0wW6019enV+srDk8/URyQ1R4cHWyzdGm76MWRstciX4VPIOmP3gkmK9BoXBlQBk3atWVplmrfMjgCv8DGLjS1HsYiQTvhkqdoA0oQar5gzxVkLNsboPhdmohqjlLbujeewlg0vpU6Tug4Mv307KKQ4N/1E6w7DJYkAb+gsrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P3qlrcLphYLKUBM+LXK/k6oSF+RHg8IrRKO5LgPO4XE=;
 b=tOl3GQFbnjSo1gw6wz1Gn97hQ1hEMGCuSiuEkZaQO3DjDSi9cy09bZ5FmnRooFuO2syZ8CPVVDjxEuifuKk8EQr+5ST+Q9qeNTQLj0x5VWUWvGFHLVKNY8QY80RGQCQCQB7ZMAvwgZNelUwdaerzTY+LPdFXLIrJQx3Vm0vNO/boY5Zp3mI9qVN6TA6PjH+Lg0cmp55BX3TD+tiBmYFGbm7M3zTjPb0YNZRNCuPGLB4n37oIbkuaO3nPPtdVzEcFrEmkj6fIFTt7U+t6LVNpEwZtUp02Bbxctwf/Ybuqyy6c02lXJDDirNil1xMzWH2XX2xemLp1kDIiDLcmf0bapw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF4EB9556A6.namprd11.prod.outlook.com (2603:10b6:518:1::d1f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:01:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:01:27 +0000
Message-ID: <ad93f7c7-1ead-4a74-a7e2-4880aacc52a9@intel.com>
Date: Tue, 2 Dec 2025 08:01:24 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 03/32] x86/resctrl: Refactor domain_remove_cpu_mon()
 ready for new domain types
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-4-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251124185412.24155-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0354.namprd04.prod.outlook.com
 (2603:10b6:303:8a::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF4EB9556A6:EE_
X-MS-Office365-Filtering-Correlation-Id: 432d2c4b-e534-45e0-0fc4-08de31bc0c91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?K3J0STNEWWZWVUNrSThaZFJiK1RVWi81WUVNRkRiNlRNSDNraTE0ZzdSS3Rx?=
 =?utf-8?B?WElsaTVZd1lkWlMzTWhWZjhXSXlnMUtBdUEyWjM5cXk5VTNjd0dBWjQ2Umk1?=
 =?utf-8?B?WmRVbUo5NHozSmxOMGlYT1ROYXl4WWhjakIxdFM5d1ppK1I3b1c1Zkw5K0U1?=
 =?utf-8?B?aHprNzAwRXJRcXRPaXI0dE5pSEpOcFVqaFpab2NGWkxPRElyYnYza2FFYzg2?=
 =?utf-8?B?VjBQYlFqUzFhNkVtZkJhSU1xVTJaYXFQdFovdlpUeGN4Z3ZzTG1ta0kyWUp4?=
 =?utf-8?B?eWZsdllPYkg3ZGQ0cDl4ZUgyYVpOMzNNekk0eUhVQnZvMjIzL25GUUNhV2Ro?=
 =?utf-8?B?bE9IckZDY3laWDArK2ZDZXpQU0FXOUFGRkFoaS9DNWtxVklsRmtlMGh3WXU3?=
 =?utf-8?B?azBNc0IxVGsra0lBYzYxWDRYcWdWcjRmUmtLb3NwSjAwUm1HSEQxU2ZDUG1o?=
 =?utf-8?B?d3N5MFFtWERucG1Ua25tMjJOaXJNb3NReWpwNERMMkozSHlZV1NFdkcxUVJK?=
 =?utf-8?B?VG1PWktML1VxNjB0dy9qeDJYMDR1OCthMWhtckZPYXJtYnlvU0t2QW5QcS9w?=
 =?utf-8?B?K0tIQXdGWTZVZW91TEJrYzQzWFdhbG12ajdwQkhNZFMxTmpRdHBHZzJKcDNp?=
 =?utf-8?B?ZG1nTEw4OGo1M01hek5RL1czMnRGazRndGVzNWw1azJQTkt4aTJpUmVsTmhy?=
 =?utf-8?B?dWU2d25VYWZRejhEN2x0bXlkVmdaSCtMYzFvcGEwSGxza2svY3pUNTJYSFQ4?=
 =?utf-8?B?d2cwTUNMQnA0MVVhc0ZEelZYM1c4eEViSkpiUnVULzQ2MzJoT09VZkdFNTh2?=
 =?utf-8?B?dEVmWUR3S1RaTDV0Zjk1S1FOVWE3ZGgvY0kvSGVIL1NJQkhveElweXJzaWZV?=
 =?utf-8?B?STNEZlMxd0NIUFh1cDd2eWNtRTczL1hodmdnTVBWekpLMStIdkFDK1lLNjM1?=
 =?utf-8?B?MnJ6bGV4TG9JQjN5THZGeUFwYVlsb0lDblNCckdidnQ4WTYrNm1qK3Y3dzlt?=
 =?utf-8?B?QTRqVEU1Vlh1V3pvNFJnWGFhUk4xYTFOM0JOdHRiem85NDlFMmJZVi9uTUpm?=
 =?utf-8?B?dm5Gd3grSnBRblRqcEdPeFV5T0k1VEhrMVZpN09XbkRnYVRRd3JldGhKRTVE?=
 =?utf-8?B?QjBtS00wYnZ0USs3Z1p2NjJGVWpoeDB2KzhLK3Nlc1lremkreXNhZCtERmlD?=
 =?utf-8?B?YlhlemVRTlhYOHZEdEVueWpXNTM5UTI4VEp2bFB1Um1pRUsvV1VXMjIvSWVC?=
 =?utf-8?B?ZWhpMmRabllHTkQxRlByZk90YzVpOHUxU250NzY2OFZKKzF5ZU1zRndYNTht?=
 =?utf-8?B?UXNnZXh1M2k2WVhBZitmc04vVTNNc3N2dkZzUGp2cDN4TjBSWjdES0R4dnB3?=
 =?utf-8?B?ZFhuM01zV2dZQWRGdG5Sb1l6RlNKUDR4cXJrbHdRSzUvMkZMRFRVNldNZFZu?=
 =?utf-8?B?ZGlRWG5GS0YvYWsreHZabjRvWm5qeEJCOGovR2EzbUVldG9nN3hRU3FvNDNp?=
 =?utf-8?B?ZTJVWUVESDZtbEh3ZkhXeGZacVRSVGVuNjRHZEVJbVN1Y0pjU2ZOWEZHR0V5?=
 =?utf-8?B?ZGFmditVUXAzUnJNa0xaV0tpQW5KZ0t4eVJyallpR21lZlk5RDhVTlpUbVhX?=
 =?utf-8?B?dnQwS0JHUGV5YmE1TzJqYmQxMUhCVWZUSSs3UFpxVzI5LzI2WkhUbXc5dW9M?=
 =?utf-8?B?aVVWdEwxSTMrT0c3SGk0WncrVVVzNERkK3BQUGZnQUNSWTl3TFdKK1ZuZS8z?=
 =?utf-8?B?WlJQVGJyNDlZd2dtY2tuKzhqdWJUbmtkOUl5UHBlcm5sRVZYblBGcG5SN0U4?=
 =?utf-8?B?THJuUHBmeDhlWUJHU0RCQTdSUGNiUmdmWU1KSXJxdU4veHdXNkxmTi85SWww?=
 =?utf-8?B?Vm9GTDJmSXdsQ2dqb3dTbDJpaFBnSDByTjg4VWNsMVJjTDMzWjZUdng3UzhX?=
 =?utf-8?Q?I4Ktb7iAYkBuwh6pUzLkUwW/Im5Xa5z0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THU3UGNqK29oOTVFQkxCRGxJUmp6NjV0bEh5bzlWNFMzaG5hU3JFWCt1cGtl?=
 =?utf-8?B?ZC9sSkNCMC9xay84M0hpM2ZFUlRrUDc2ZWVWNnhsbkhCejVtR3hDZ2xLOWhS?=
 =?utf-8?B?QlhUbDdZZldLYnBaNTZBWmRyNUdaL0RjalExQzBvSWl1WHQzSi9yczlJaG9Y?=
 =?utf-8?B?dDQ3dldXMXBIbUQvOUZBMlA0dk9aNkptYVBQTVFTRVo0M1RyWVludGxhb2M2?=
 =?utf-8?B?S3oycWF5eUhsc1JCZ2V1d3dDMVc0TnVHNXcyZ0lreXVtNnRRYXkxR25UUnI0?=
 =?utf-8?B?endxSFRlV2ZEZnV6NEtFOGpkY014M0tTOVdkODRBSzJKT2JoWlh4L3FWeGxM?=
 =?utf-8?B?VDdkOEpLWWlvNmFWM1RPY2RRK1hqWENJa0ExK3VBeWl2cTJacXdabGQ0WW9E?=
 =?utf-8?B?QTkwNE1mRm40NlduZkd2VmFYL2hJNXpBRnhXcm1GMWhBcjVhWWF1L0NuZ1JO?=
 =?utf-8?B?Tm0vRldGL3hiNkRjTXkzaWM3MWZ1SFcyT0c3Y3o4MzN3b3VWa1NHVXNRK2ZS?=
 =?utf-8?B?NU81Z1lDeks2TkJhS01Famt6UzdCOUJVcGlja1FseEZtTWZTSVp1eENQQXdD?=
 =?utf-8?B?WUFnUVVUN2paRHZJM1JhK3k4NjlZMTNHTGZ1SStjNXpGZFhPM1ZFZFVJWDBP?=
 =?utf-8?B?Y25lcWZHdDJBMGloS1d3OVhiaGVsbVNCZ1dkZE1qT2xOWUd4T2tmQXdUL2Ux?=
 =?utf-8?B?L1hWUDZ3VTNscUdzdDJqZWRldHVYRFF1OGVwK3IrV0JQYUhwWnllczNqK0Jj?=
 =?utf-8?B?OTBlY1Nnak56UWUrRUlDRmNYVmgwc0p2TTA5dzBCQk8yRlNqbWNKbHFDOVNh?=
 =?utf-8?B?amZ1ZlBwV3pUbktLWUl6SDJUUU1oTGZzM2Nnekladk1zZUVkUGI2ZWdRQzBo?=
 =?utf-8?B?bUNaV05EZWVkTFB4QlVLVlRnSTRqSjMyZ2FMbEJqOTBjUnNoeTFYTlJhcWNy?=
 =?utf-8?B?bGM3RHBsUjFDZWFEamlLN1NWRzlteDFibS9ia3llNG9BbmJXQzk2ejJnT1U3?=
 =?utf-8?B?ZnVnZW9leThyR01FSlhZQzd4ZVZxeFhmcGVROWRObHJFRXhJcjRMWmJkc090?=
 =?utf-8?B?eXBkOWFGaTR4VTdWcVFWWC9NYWw0dFFlMHFGelFxTUhPSllVaWVlZzlCL2Fm?=
 =?utf-8?B?bVhmVjRQSk02bkg2VCtQWlJ6cHZQL2QyaVZqdHRPWU11UlBOMG9NcktNS0My?=
 =?utf-8?B?Rm1uSEdnRGZSamJ2Tk5tejV2Uzk2SU5DMUs3M3hpVFFvdWtsZ3VQam9LMnI4?=
 =?utf-8?B?dUxXM2MyNzk1WFZ5QUJaTGNVSkQ0YUlNaVFmR2JBZFJ5K0RzYUpHdUd5eEoz?=
 =?utf-8?B?Qzh2ekFCcmhNcENQdDlGMXdFZ1ZuMEZLbmhHSjgxOXdDeWxaR0lLUm5OQjdZ?=
 =?utf-8?B?c1ZET3hOenRXaXEvVjEvM1RPb1JSbW9uK0N1Y2JnRnQ4R0ZTbXl4MjVvVkQz?=
 =?utf-8?B?aWZkQ3FTYVdyZnJhLy9ZK0YxY2xhc2ozUEhRakJUTE9tMTg2ekVXSHZLaExE?=
 =?utf-8?B?UVhia01Wb1Y0WkxVYUQ3NEpUTHArcjU3L0hxbCtsVE5JbFZpOU9mb2k1eWdB?=
 =?utf-8?B?Mjg2NHpFSmRUaVNLeXZZNkRPL2tKTThkQXV1UlZzb25NNHBmK1FidkJEMDNk?=
 =?utf-8?B?R3d6M2JJWlMyTEYyOEhEYXZkYWc2aE0xNlJ0QVRySk52WjI5aDR3eEhPb1lk?=
 =?utf-8?B?VmNrRUFJZm9FZWYyUEV3VWhUaEcreDdJVkNuZ3pyMDBtZ0RVUGJYcUlKTksv?=
 =?utf-8?B?WXl1RjVxZ0lDT1hLWTlZbXpJZ3lXVFVpZzkrQzdwVjlIRXpTZVdFMVE5Yks1?=
 =?utf-8?B?MUh2MmdvZXVJY1VORVFPcFhGL1VEcW85S0ZTa0pIN21kVi9qRmdGeDFVNytT?=
 =?utf-8?B?Zkx0RXNOU0lWZ29nYURYS1NmVUREZEJyUmtCQnRtTzFwdG94TDIvMDN6R2tp?=
 =?utf-8?B?NTVPcDEzbmJaaXBJaWI3MHptWDFheUJkYUFURjhKL3FCcmEveWlsaXpPV3Qy?=
 =?utf-8?B?OWtIVWFscVhjNGl2QWNRc1dmeTVqMW91ekpVbmdUUFpoNEZYaU1nMUlFYlpR?=
 =?utf-8?B?cVJQLzNCSks1Mnlya2pJS3poR0crbXFJUXkwYWJ1dk85Njk0ZDNFQlYyZXc4?=
 =?utf-8?B?a2VVWGdzVXYrR25zbFQ3cWowLzU2YVZKTUx6U3J3S1R5czVzMmI3aHhXYXBp?=
 =?utf-8?B?SUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 432d2c4b-e534-45e0-0fc4-08de31bc0c91
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:01:27.0799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sPWsjRtEtfz1gF/pZE8EFcov9T+IIQEiaj2X8hEF8qyxXeByUYmvZh96EDwVjzvEuoP0jwY5d7SqTvMGq4AbROge7RCwrhK6vGSdqvME+II=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF4EB9556A6
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:53 AM, Tony Luck wrote:
> New telemetry events will be associated with a new package scoped resource with
> new domain structures.

nit: "new domain structures" -> "a new domain structure"
(only introducing one new domain structure)

> 
> Refactor domain_remove_cpu_mon() so all the L3 domain processing is separate
> from general domain actions of clearing the CPU bit in the mask.

"general domain actions" -> "the general domain action"

Reinette

