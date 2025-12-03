Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4362BEC5E
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 21:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764796925; cv=fail; b=RdGXpCS27Omy92CuBdNOkiFfLKSezDKwyBZoD29sXTis9SCOb4eso83e04UeaHvt9kXwIKrEWO7B8REFm08xtIpEDdNU42C9kO6s41nsFnN70Y/ziB8ri8lXdR1PIG8JO+gG8kxHF33cEj3JxFshr3GRHqNPWnVayiVWxPv2FVk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764796925; c=relaxed/simple;
	bh=OFBjWmdqZmmHLapKt4XyuILOXyerrPU8tpKoIgkqSBU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kyapvKG4MVjyVbDkHG5V1etp+IBqD3qGvFcqLP08uhsW7XxLzYghUBx18VByqdZazF9hggrpGIjOVlr55EvYgf8xJYeqet9l2ClrDRwMrkjZTNwrxUafOVYCiuGVLu/A3KZ36EBkiJmuyDBvovhgQKyGFFAuxPZ+VfkKXQUFxbk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bxMaeu9h; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bxMaeu9h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764796924; x=1796332924;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OFBjWmdqZmmHLapKt4XyuILOXyerrPU8tpKoIgkqSBU=;
  b=bxMaeu9hQpXYZ5UtUKvmrUE1fWz5JwKNeNMT4gC3uUlBNPuZ76ONIswI
   BfsWZz0u7psIc9r2faoxqX71c8y5bSlC6JEoUHeMAU/lE0fSsayBXXIpd
   ItU+jrIpmy90NJUi0ixgE2zTom6s5cI8cZYPAblRGM2FyrunxPC7YMVSN
   FTSdxBTlQYJM4ReHZlCYFFyamiGr7mr9TemWEeYbRIJcjrBCOcSWN5z2l
   1W5NoIoTZcFsYKXw85Pm9jXiEn7Qvffkqfy2hr2mTNE8b11yKGu5KAdn2
   P4XwdKlGre6aXYucl3bkTN20X//d0fM1/Sx74Eluh8A5QBuDZpMjlj8c3
   A==;
X-CSE-ConnectionGUID: GJKD/TAIQzOHEKoxgbmqfg==
X-CSE-MsgGUID: WBKSdlOcSveumXYuWQ2TGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11631"; a="66768593"
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="66768593"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 13:22:04 -0800
X-CSE-ConnectionGUID: 17LjtCEHRKuUx1/Sw8oz1w==
X-CSE-MsgGUID: xm4nMe4DQcCmE069gqhAjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,247,1758610800"; 
   d="scan'208";a="194838901"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2025 13:22:03 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 13:22:02 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 3 Dec 2025 13:22:02 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.22) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 3 Dec 2025 13:22:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tMwAIQ/op1aWtFQdY7JqAINv+H2vFDHCUJDbzJCLhCMeUj0uBUe3o521RkKk5kTdqZTS50RwCy+kwSV41xQVVA1Zp6292Jan0FNi2y4+Qcg53DqSIHfwai44KfSYdL3iVlP6ttZuo6h0P9+zxFRdpSTOpXVXw1d1prcNcVK9aKnBk/nCZsgRAE7ym2/Q0i3mwVRd7onXa4WBTDrpt8hVl7FVQ8RWN6B8e6PvVqEVXXCpLQcWbSRPUB/DMYImtpCr3ZZ9viz8VGTkqEbKQGg0BjDDdhJtwGlArLSEa+kTin6Axt70sMFbe2ceFapJe/9psoudVAwUiLNGP5RWNW6Dww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGGBTOqcjfQz2c7rzEoW9glAFqiGZoCu0fiwH/oKXmg=;
 b=n2kHUHaKmV6uuU9nz3p+/rsDjaZZJhjdqp59djuwrgDrbjRW0Rtsm8ZKncMrJKqRJF++mpnFlTi/qw1JSssQbpGHbfrS7ZwimineI7VnJdAV2FMp8Q9PvbThbcnidQLfs693DMkqwYs/Bzb85Zqi0q6JxkbC4DA2JIXdkOykVFeLRAS6L3ZsXJ/a7r0t2xDSr4PpCdBAneTlSUCFRzr7ilD5U+KPyQVefXM2pJbPwbOIDywlRgDkQS/x0lYqpy27vHHevI5B3XxMckxHtB0D7GpVOpDxvChKM3sj2P2XE5+2TCyv7WU1M/CexwGgvj13kSOBcZVcrtunxqYR4tbFOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA3PR11MB9206.namprd11.prod.outlook.com (2603:10b6:208:574::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Wed, 3 Dec
 2025 21:21:58 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Wed, 3 Dec 2025
 21:21:58 +0000
Message-ID: <6fb0d504-b8f2-4b16-9d49-b97e41d8a697@intel.com>
Date: Wed, 3 Dec 2025 13:21:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-25-tony.luck@intel.com>
 <ce70e96d-7960-4e00-bf26-8f61424e3171@intel.com>
 <aTB7rsMggy9nRgbR@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aTB7rsMggy9nRgbR@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:303:8e::9) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA3PR11MB9206:EE_
X-MS-Office365-Filtering-Correlation-Id: bab7476c-2c3e-499e-194a-08de32b1fdbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TUp1TURuL0krUWZCTUpMUFhRTzZGblBCWnhLMEo0djd4Z2NNRXNJRTBUdldJ?=
 =?utf-8?B?czhFV09FSjZvUU9CalVkY2tlTjU2eTBUMWdIZEsydGtPSkkrbDlzZEJOSW5L?=
 =?utf-8?B?cnpKM2xwalJZR05DNDZpMERSTnJHaVJxYUFzZmFzbk16S1pweW1oMUJvdi9l?=
 =?utf-8?B?M1FKV3BnYWV1bVcwUm9pQ0hzc0NVYmdQK2JHdjA0L2FSWU9WbW5rcEpFS2FS?=
 =?utf-8?B?RnNQaExZV1lsR2xNaWdCVkh5QkV2OXdWMjVScEpRa2RVQWxtdzBJOVJOblpF?=
 =?utf-8?B?WlJ6UUkwVjBRaWQvYnByc2RUd0VwOEFvQ2hZdzIyYmRhYnk3RUZhMlFKa1g3?=
 =?utf-8?B?cHJ6Tzl4SFh0M0ZXeU90aCtVeC94RG1OUXhCci8xWHp5SWZQOUV4MXJLWThv?=
 =?utf-8?B?UGRzVnhtZlpOQ25hVTJzMjlOdEZ4WmgwVlViRTRQTTE1ck5TUVdoSUNyaU55?=
 =?utf-8?B?dm5BSlhnaklhQUx6anIrYnRWZ1lTS0h0NDI5RkdPZDBjdm0xK3p1WnlRUGRi?=
 =?utf-8?B?QWlobzBSeGs3cHNSLzJzcktLRUJ6L1hQcDQ5UzE5Q1d1NlBYcGVyU1JnVzY3?=
 =?utf-8?B?ZWUvNmZsRTlPVUJVdWRGaTJTUGpnNXVmSTdvZUNOb2l0WE53a3FnWEtqeStC?=
 =?utf-8?B?VjlDYzJTVGxxYzlKWGtUelo0L2dsbVVSM1hHRldIU0M4d202S0NUWkhXd2lM?=
 =?utf-8?B?UzZZaVRLWU9KQVNodGsydUpLYlNlUmVRWi9wdkZuNVorbzRKaUU4bGU0Mjlq?=
 =?utf-8?B?aHl5c2liUjVpYXNJUnJ1ZFFkdEttRmRCbXF6SW9TY05IVmFHQVQvUC9xQjJ0?=
 =?utf-8?B?ZzBQdWEvdkRFbXcySjlMdm1pSUdhMWprMXI5T21BTC9mbkU1aE9oZVpFMWlQ?=
 =?utf-8?B?VTNXb1ZDWVNBb2lIQnpyNG5YMzlCdWlGMEZNYUgrUThWWldzZWVBS0sxQ0g2?=
 =?utf-8?B?MGlWQ2dkN3dNVXczUVdvb1FDMDdyVnAwdUt3MHE3eGgvMWtMTE5WVVY4azk5?=
 =?utf-8?B?VGF4YXN1UVArZXQ5Nm5QaUpxWkZlZmNuY3RycUxKeGI2ek5RZjRHbDVLNFcr?=
 =?utf-8?B?MDUwbVN6eEVwUEZ2dTNyN3lXMTZvMmk2TXpuMzdsNWtlRHpRbU1NQko4WXBY?=
 =?utf-8?B?ZjFETis0OG0zUkNwZWV2a2tJcXN5Z2FIdFdxUXRqR2RDSWtLRkJVZUcwQity?=
 =?utf-8?B?UXQxMTI5SktLa0pkMmFLWEJRZTdMSGdvNFVGdEtWM0Y4YUliU1ZpZW9JMTlL?=
 =?utf-8?B?SlZVNkFxcWpTeWxPdnBPY3pFeGRESllndjYrMEk3VFRhYVgzQkh0ZldtNjZC?=
 =?utf-8?B?dUtYdTZuRlEwSTE3MklrVXhKMlFxVjdQdmFPbCt1Y084elhObytjOTZkejlU?=
 =?utf-8?B?cVg5UzRVUVlwdTBsc3htek1sUENiVXhFY0FxTkxJVzVDUkVDYTZWV3VnVnh3?=
 =?utf-8?B?c256eVJoNStKSXZnSS8xZ2Q3S24wVmVSNzBnRnFjWFRoUlN6Skp5N2VKdWJY?=
 =?utf-8?B?dEhnbVZ0dk5hS21GQkVmMTJjazZneWVRK2o2WWtkZFZOeE5TbDJUSkkybHBI?=
 =?utf-8?B?Q2h2SjJWQWxkTEpGWVNrRTNxVnJHN1U5OWdHbFNwblNWOTlYVVdXc3VHQk1V?=
 =?utf-8?B?MnJtTnFxNDJYOHB5V2FFcU9acDBtdXYwZkxFSkg5aWF2NkpGVjVvQjJWMExY?=
 =?utf-8?B?MGpHa21qUzVTcU9SMEhqWjJWb0RRRUZ4VmUwNGJ0Um9uWFBrc2pJdUNOTmRV?=
 =?utf-8?B?SU5IM1FWZTZTUm1CZ2ZhajBYVVFYVGZ5YURKcmJTWllwd2pFUnJRZjRVTlg2?=
 =?utf-8?B?WXhrbG5WR2Y1U3VQdGtOR1lyc0kwNitpNHBHYjBKSWNoZFFSMzhld2VJRXlO?=
 =?utf-8?B?Mk9WRzJkcUNvd2NCMnBObnZBTEg1K1ZybFEzZWMzcWlQb1h4SEVCeHZOdlpr?=
 =?utf-8?Q?Y6obGCPdbNK0w8cqeXe6ziRdar+sl4YW?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eUNwNmIxR1pkcGxON1JNK3dsU0N6WE9JY2RNWVJmUHF6Si9QOHR1RkpEc1Bl?=
 =?utf-8?B?UEtFWG1QWlJnOW1GdFltMDhzdjMwU2VSQXhRamVPT01oS3loWnZYM2JjL0M3?=
 =?utf-8?B?bFJBZW41OUY2anNJdnRDQW03ZXVKYmI1eGdYa1d0aW50U1M5SGtJSkQzK1RS?=
 =?utf-8?B?YlVyYUwwNXdSWWNmVnVxRndUREdHV0ZLWjVRajlGbHVkYnNjTTRrcmJvcDNi?=
 =?utf-8?B?RjdGVXVUL3NJamxWZVBadkFtM2xNSHpWSHdFaTl5Um9tSDE0L0dDNXdKSHpB?=
 =?utf-8?B?cVFhUFN3MVlobFZSN09rUGV6ZnVWd0pQZGFxdXd2MC9Cek5ZdTdJbWFFVG1Z?=
 =?utf-8?B?dmMzK2RUMHpFWkprMnVxNzFCZHQycVRvd2dVck5ub1A2b0xYRXQzWUZVWmFJ?=
 =?utf-8?B?bndLTlByNzd4RURKak1QNWtGbUM2enlxbjY4eDJmMEMrMk4rN3lkZndtVTcr?=
 =?utf-8?B?NzFBMDEvQW9UNktxVGtHTWl4Uy92enFFQjFzd1hudGdhZ0RGblpiZlRLR1hv?=
 =?utf-8?B?RnlWZjZQL210SnFNWUpiYkx1M1ZXV3I4OTYwMkFYRm5QNlVxVTVuaVNZYmJn?=
 =?utf-8?B?WTdNMGJpZTVPVmQ4cGpiNjRXcndUcUFFV0VWcHgySVMzcGJqNnljdENLUFd6?=
 =?utf-8?B?enNocnF2QmpRVDRFWGpmc3J3bDNSOVloRW1CZ1p6blZVbjVWb2NxUUx2clJj?=
 =?utf-8?B?alViMVVVeXFhNU0vbmRTZ2JWbXlCNExHdnlJNDdxWHYyQlJyS2U5UWNESGRF?=
 =?utf-8?B?RTdWakFDemZjQTk2TU1LS3dWR1A5QXd4K25GUjdoeVorMVFvWWNNRjdiOUkv?=
 =?utf-8?B?VU1sMlMwWjlVekpGb3poa2YwNTdiNmM3K2xRcXhsNDZDUjJTQ1BnSlRrVDlG?=
 =?utf-8?B?VTEzbG1hcHdVR2ptclZiblN5MFE3SkhXWVM3bHFlQ1pqa3J1eUs4SWpDb0N2?=
 =?utf-8?B?S0xrQWUyZStTUnYzSHZtVVFSdU1jbGNONEQ3dkI2RmFUNFNjR2F0QWJ0c0N5?=
 =?utf-8?B?R20zMEdtMFVXWVdTSHFNZ0l2MldZbXFoTzU4Q3NpYms1cmhMcGV2VWpCdkN2?=
 =?utf-8?B?dWhDaXhFRVV5KzNYWit0aGl3YjNtZU1qWnJFNEd0U3JaZzBTb2xLQjVVNGhn?=
 =?utf-8?B?c3RSNE1nN2NMTE0xRnVLRjhtY2JoMHVoc0doVG5JWUtISmhCK2xUcnFrdTZs?=
 =?utf-8?B?OFZGTVZ2aDRna0x5TW1adE9WNlhMODlFaWJkNEEwcUNmSituaFFZSWNMNXcy?=
 =?utf-8?B?eDZ4bmdTMjJ5S0Z4dm1lMkY2Nk1mSTFtbGhzeUtCTXVaZHc4TFliV3BNZFVD?=
 =?utf-8?B?MGV6c2YzOW9IY1RzeWxibFlSRlFONXRobk9DVDRYRGZxREhRS1NKRWlFY0JW?=
 =?utf-8?B?bVEyNktKZHRac2dEL0lTd3VtVFBFc294NXZHaDJxaUdMMzNaWTk5cElsQ2Fi?=
 =?utf-8?B?QUFEV0RuQVNaWE8xcGRpcHFFR2s1OUJPQVVHblVhak00R0o0WHl3c3c5bFAw?=
 =?utf-8?B?ZkQyTGdDWmREb1Vta2NQS1FPSythOWhnNjdxL3VsZDgyK00vTTl6ZjhQVFly?=
 =?utf-8?B?Y2RlNi9iR2xHYmtVMHFJbzZIRFFyN290a1FlanJLUFVtRzZjbVpkNFJ1RC9n?=
 =?utf-8?B?aVdMVDlzbHJBcTk1dnJ0SXU2Z1hBSDNSTGoyK1Q3bk9JYVBvVzRUeXViNGhK?=
 =?utf-8?B?UG5GbFgrcXB0bi9JQWFidGlVYUJlY3ZSZUFaREwwUXNEVVk0N0VNc00xaWhT?=
 =?utf-8?B?ZklEZ0t3SHZPT0dBZ1dGQzRCcGd0ZWZMOWR1MC90OFBwMjlkUmZFeXJvVmRB?=
 =?utf-8?B?amkzQmNqT2RRRkJqYjl0em1uSzhuMEFPZCt2L1YwTGpuc2pla3RObUd5UDVH?=
 =?utf-8?B?YXgrOHRJQ0t2eWdzRjJaaFFwc1VOYVl3VWJLN20rNUFnaGRqa2VlbE9wRVo0?=
 =?utf-8?B?d2c4bkUzTHV1bUtKWXV6UVNZUnMxbWdhdU10ZkNiQkUydURJTnBEaVRid2Nn?=
 =?utf-8?B?a1JYY1RDanpseGVSZStqdEdpQitIYW5IVUluOFlMZy9nb2pkdzJPaGVRM2VR?=
 =?utf-8?B?ZkRtYWdST29rSEtDL1hFYUFJYms3WWxWR0tNRTg3Y0V1YWJ3eXJoamdTVjVT?=
 =?utf-8?B?R3ZPOE5paGRoaldnRkYrWkQzaGhsMzBNdU5zbE5Ud0tqVkRSeHBQQ2E3eDlj?=
 =?utf-8?B?M0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bab7476c-2c3e-499e-194a-08de32b1fdbe
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2025 21:21:58.5470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PaHxS9ejYC9H05ptMV4SXXnyy2cKueDRiY3JNVr3wGAvcyOyh4WVvmMKVdg0cSGXScHWZAwmjV9rH6j4xF3QA9uc04iZ9zzw4ajKh/gIT74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9206
X-OriginatorOrg: intel.com

Hi Tony,

On 12/3/25 10:04 AM, Luck, Tony wrote:
> On Tue, Dec 02, 2025 at 08:28:56AM -0800, Reinette Chatre wrote:
>>> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> index 46c64419ec10..50c8b4c50790 100644
>>> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
>>> @@ -57,12 +57,16 @@ struct pmt_event {
>>>   * struct event_group - Events with the same feature type ("energy" or "perf") and guid.
>>>   * @feature:		Type of events, for example FEATURE_PER_RMID_PERF_TELEM or
>>>   *			FEATURE_PER_RMID_ENERGY_TELEM, in this group.
>>> + * @name:		Name for this group (used by boot rdt= option)
>>
>> This needs a new definition since multiple groups can have the same name now.
> 
> How about this:
> 
>  * @type:               Type (energy or perf) of this group.

I find this to be confusing when considering it together with existing @feature and its
definition that also refers to itself as a "type" using perf and energy terms.

> 
> That covers how different instances have the same string where "name"
> was confusing.
> 
Essentially this is the name used for @feature and for this there is already
pmt_feature_names[]. Is it needed to create a new name? This would mean that the
kernel parameters become "per_rmid_energy_telemetry" and "per_rmid_perf_telemetry" which
is much longer though. The only limiting factor I am aware of is the command line size which
is defined in arch/x86/include/asm/setup.h as 2048. Here I do not know if there are customs on
whether kernel parameters need to be brief or not ... some kernel parameters seem to be quite
verbose while others are cryptic.

The safest may be to stick with the separate names but I am curious about your opinion.

Even so, it seems unnecessary to force each new instance of struct event_group to
set a parameter that is required to be of particular value based on value of event_group::feature.
If not using pmt_feature_names[] then intel_aet.c could have its own private array
that maps pmt_feature_id to "energy" or "perf". I find that doing so would make it obvious
what this property is/should be.

What do you think?

Reinette
	



