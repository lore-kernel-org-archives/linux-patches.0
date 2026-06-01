Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BDB3DBD5E
	for <patches@lists.linux.dev>; Mon,  1 Jun 2026 15:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780328458; cv=fail; b=AS4mXUwqW3LBduachVw0zOyFV6N4OBccxhpm5SCyeHwDWp28WFWj+BGb563ytbKW1X7LbQk+NXTB+9o9m3iIsJm0lR4pEreVqJ2zhsjRnsvk2ZjY0sv+wDO57F85ZcFhaqaBtO6PW4d/Y3ktkLjLGQqsHmF50kkKSqIq5/GBs6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780328458; c=relaxed/simple;
	bh=lf8gUdw2MZmX9Ojo9Ht2LjceM8JXAyZYAGFIn9npBxU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=n/98IVE2T84EZfC6XWtDMDOu4zAaM2EnDKYlSbrQBJSoqSSTcEwlfRJgqIdRlm6h2ckL/yhgfsbpKf7SyOkImuqTzo9TiW+uzMAh01lJjT6KKKIZEFRIcTNXqBufvhREtiIAdGQVKN2V51GrjOklW7K42WlEMb97in52lTgqOgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g0bgtia5; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0bgtia5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780328457; x=1811864457;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lf8gUdw2MZmX9Ojo9Ht2LjceM8JXAyZYAGFIn9npBxU=;
  b=g0bgtia5oA7lrFhN1GsZlquAo4SzyC4sINEYrGqgeHnuDGOA7YwhJ6wt
   lLuhVOSOkCBC2GEUBAjX48nlO4KoAQVHzk0+IAB/rkIeUAWs8s/Eqswdz
   5FbGb6Z8CNb7BDoS6p+BgwzKwwD3LoJLm6JMtdlFkPNWy0+mfQr/NGMHb
   /T1cdZxc6c35FiHBRyGu6GvT/jqQc0E3L7Mjiqz5UItq567tfLxU16eXU
   CkBdmwJL0LpRML3i1aC6tnCGB09ZJD1VnxHzOqX91gz8PzxIdOxM96bmk
   32wNf/u7jt9qntX5JjCDD/NWkpNby7a93fAucp7PwCOUKEf2L7YF/A1x4
   g==;
X-CSE-ConnectionGUID: TnEke1yOQw2DUpygFhCJ6A==
X-CSE-MsgGUID: kRusMMWFQ/C+7o2Jp0Oogw==
X-IronPort-AV: E=McAfee;i="6800,10657,11804"; a="91401472"
X-IronPort-AV: E=Sophos;i="6.24,181,1774335600"; 
   d="scan'208";a="91401472"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 08:40:56 -0700
X-CSE-ConnectionGUID: QkwHTBTMTXus4uUT7ewVQg==
X-CSE-MsgGUID: FClLE3qiSTiafUxaa8OPjA==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2026 08:40:56 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 08:40:55 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 1 Jun 2026 08:40:55 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.50) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 1 Jun 2026 08:40:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eXdbMocdrtMUJSYrj5KSIkzQKk5V2N+6TPE8a0j6Y5J7/fPhCkh2o4CNk78+xGRp4M/vld/vRLdsB+choXMLPSZmwya7B6z3R/mdKvQDw24Uon1lfOASemCA3nSIZls9z0cv1ndv06z4VSWVPLrIdb3lpmgR6xDzZEpUY9V4uYyLs2TSbTQ/QZN1+Mf1wBQgA2OGPGQPQy0UdJCIbYkvAktKlrYTbm0XOHPNUPPcLUNjdG3SexiEto6K7Qb+GN2u0pGCFIhdsPO9jS7vKII3/+oWS1xQrnRzxYy2sLSV2K7rCeewUbRquCnU+pBJA28lLKmBWvqcQ2jZdEPHnwTGCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/dKajuaJWIOj3JD6Vqqzhkth9NFG3IkAuvCz8CB9ec=;
 b=uZbawb3H+mh25LoHXZnppVgi4ul3pSB3rEnETyFTjEE/kPOFVut92n+oDVOpKfMUSi19Ar+6VivUK2CxQWQCUCkVgtWKp70ro5nYTZbAoktIU6Du6lx4Vspz6mHDv51fyF+efDE1MNltpJAVuytmKrvPYZDqY1WoLu4srmh0q/U1eymFVQeI/Y5QVXSQiJURfsE5xuFUnUL468VoSLARoc13yoCgR2LtiM5QXlIlo7MxdfvhRFTAHLLKou+bkn9wAgpsT+9d43cwywypTb9XcnclZDd+cEnhXzbLs8qX+IkOAbjcsDkfQ4CIhsoy2wTMvwOaXX33odRLz/+eR8bBxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MW4PR11MB7030.namprd11.prod.outlook.com (2603:10b6:303:22f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Mon, 1 Jun 2026
 15:40:52 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Mon, 1 Jun 2026
 15:40:52 +0000
Message-ID: <25890d7f-238c-4027-8ade-f30adb8f437e@intel.com>
Date: Mon, 1 Jun 2026 08:40:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] x86/resctrl: Ensure domain fully initialized
 before placed on RCU list
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<tony.luck@intel.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <dave.hansen@linux.intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
 <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
 <8d76c93f-7780-4fdd-a3b2-9faa8eeddf57@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <8d76c93f-7780-4fdd-a3b2-9faa8eeddf57@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4P221CA0009.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::14) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MW4PR11MB7030:EE_
X-MS-Office365-Filtering-Correlation-Id: 0274f94d-1aa5-4da2-4b98-08debff42957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099006|4143699003|11063799006|6133799003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: onAVJxg/owZproIkB8kAAsx8UjU/0b20BiFEEetX1dQtB9/4jkyjeIP9Cpn6d1AARWjI4GP/Uvxjoe574GLkoqM71OZ3H3xeuMk/pQZ1SJFip1SFXcgUAJjHAb1G0AlJ1v2GDTMLOJ7ABWKSGtxr/UVslnsQerKgydd7WxEIm5Acp2QjMF/7h5MlYc/XvAGICBUrjj2ODGaNKrDRqffC12lqMrPLe71Mdw2kZak89XGLZY5haTinQcIzNJXJrK3WKi5VuQq96ENCntrIZiKvRXQ4OvVIvNbA1CsKSBIkoDRzdjOK9wANUE2Puk/7RCrVAUUDuq/Rq7kc17dvy3L+UgqwWKCUpebytkcfpn3o+7+82r6ACEKzaBvIHwsAqWNvchudFTUNySWz4xnoeC7h0VAYoNpJlmwI43V7FMPHXCn4D2RO+ipR0je44dQPayvzBhzpFMg9NLRfhh95uibPeZcQIR66+NJeGfDzzT2qBQg9TDW2fUz/aO8VUhlcPW0y6lLP4INjKtb+SOzdzjATNBCv9kYYAqN10mTr0cyM23HskOxFeMK0tBEqTDAIDvMdz3r6nJUH7jrFpQpVIM01kbx6ZkMnxu2fP2mMwvqWLyrkQk3GX7TopK9JHHNrRpkm0AMEIKLdudTJvxT7bWsgXBv5TXOoKqqQf+6jukBSbLh5BY8Dp8WWBpvBqRANGQZr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099006)(4143699003)(11063799006)(6133799003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWFLY1htdjZtSzZBdnpyL0FMUGpMNnJlNUNhVDZTTmNnc3p2eU1EQjM3ODlL?=
 =?utf-8?B?UWQ4bTZmUzR0Sk1rbjNoK29HT2pna1E0OW1vNTN4S2JiR3dpMzRmRE16cFdj?=
 =?utf-8?B?cTJ6V2FlMm1NN2lQQllSUDNScEg1ZzNscVFIRnU5aWR5VFdXYlNLeXp5NEpk?=
 =?utf-8?B?aTdpMkkyU3FhMzFVeENiUkNZcHVKWWJLemoxdWJKZGYzRThtZ29qajdTUTBQ?=
 =?utf-8?B?SDJEUDNZdmpBUkJ3TTVGS0c2MzhxajJSekNBRWVFYlNJSFQ3SFA1ZWpnREhh?=
 =?utf-8?B?OEYrOCtjOHdNb1FOcFNpTW9qVjhzZ0tUTmZ2emtmWXVjNnVFZy90Sm01WEtu?=
 =?utf-8?B?NGFRNW1hdnROS3NtV0l3LzIydGRqNVlvVDNjRC9sRnV0cllkQjZEUmlHRzJ4?=
 =?utf-8?B?d2NVdmU3aUc2WWVMcndGYXozL0pFUE1yTXpnVHZxY2NMRjExM0xycFZ6ckVq?=
 =?utf-8?B?eGJQU0R6eVVNQVI1Wk1hOExyRmNEOXdQRlB0Z3FJeEFOS2F6c1RtYmdMVUpn?=
 =?utf-8?B?T2E1NnkranpGV2F5YUtXNHY0bVZHT3krS1JwQ01VdGZnakZYK3RzY0x4MlQ5?=
 =?utf-8?B?Y3BKb2ZYWmZzVXFqQWcwbEd5SlZwN1VkUm9MZVo4S3Z2WXNENDF6cGJVZmll?=
 =?utf-8?B?bE5wc3k5SzRFN3g2R3g0RW1HL3lPdEVERmlKL1FYL2Q0UkxLU3dXKy8zWEF3?=
 =?utf-8?B?eElBOUhpZWo3bDhjWE5WRDJHZ1d0RzcwaC9mcVRHK3Z6cWFNOFdRa3V3T2pB?=
 =?utf-8?B?Z1lHZjhabElaaGJGVTFKVGtmcW5WczFKNGxVc2NRNDhnNGM1TllGcWZ3S3dF?=
 =?utf-8?B?Z0Q0UWMreHVyVjFmRFZoQm1XVlp6dFQ4bWlJMTk1b29sY0t1ZW54c3pEQmg5?=
 =?utf-8?B?Y0RPZFBzZWxKVnRUd1o5dGFPU3Bqb2NsNHBrZnRyRlNlMmpyZS9aektKVXZH?=
 =?utf-8?B?akszUjFNd0NIQjJrODFTUmJhay80cTJXYXRWQTQ3SzRaTGNySTYzcUltYnVY?=
 =?utf-8?B?cEZwT2s5N1FsaXpVNnh6WVhvaWFZWkdrbDEvUGFKWm1HaldFbUJISDZWZ0RV?=
 =?utf-8?B?K3lBUkV1aXVxTXQ0a1orbk5MQW16dE1IdGFHb1p0NDFEMTZqc0NWOXlEd3RG?=
 =?utf-8?B?eElwUnhGWUZtcFFhcWwwamtKK1M1RFA2c21EQUx6ektKK1Z1MUlEcFc3MWdi?=
 =?utf-8?B?ZEJtN2RGUm5pY1JUOE8wOFhrQ3FEWS9sUWk3dEYyamJ4eExmVm5uWDV5bjlT?=
 =?utf-8?B?bEgwOUszUFZOOGtCZThQcHozdk1vS2RsZGRabkN5ZVpzOE04eEcza0tza1FL?=
 =?utf-8?B?UStjc1o2T0RZdzY4ZnZNekVySFlka2hIS29LdTl2YkxpZUM4Yjl2emFiWUEv?=
 =?utf-8?B?eW9yT211UlNyc1RTc0UycHVBMWdnQ1NuY2lyVHNsU3o5eHRSTTF4dVBsWXZM?=
 =?utf-8?B?N0ttOGIvQldPdkJIN09qSzZlcGJrckl1dE9NbGYwL0xQV2JySTdFWEFGOGFs?=
 =?utf-8?B?bi9mclliT3RPRytwLzI4d05GM081aXRRWHB2S2J6dlF5dzFzcDB3djNBL2lv?=
 =?utf-8?B?VE5ia1ZYMWpEaDUxV2hNejRKcXYzQklJaG1KWXp1MkFQR21oTDZEamlRS3dp?=
 =?utf-8?B?NG4vQ2RSdEpNdStrR0hzNGpab09ka0FuU1lXSVFDL0RscklGMFV5WlVlTVZz?=
 =?utf-8?B?ek5WREtDcHd5emlOcXM2ejlDZUZoT25OVlczOW5RUFMySHJpdDNzT3pkVnEz?=
 =?utf-8?B?KzdUSjVST2I2dzNhOUFaOTcrUm5waUZ4TXdFK2dDUzJTdWxyQ01NcGFiandt?=
 =?utf-8?B?SitKemFtMmI2amZ2UjhmKzNVa29oNkM5VjhDMFk4OWUxTUFpbm5mTjFNajdm?=
 =?utf-8?B?Q3kvbHZWSE52a2VLNFNVdlZZaWpIWWI0cnhFUnYxVm5pczhKMGJiRURKSmdP?=
 =?utf-8?B?QUZIcG9hdkl1WFRxcHdaWk5pU2dnZXAyMjVHZm9mcFl5ZVdjZW1OaTVZbEtr?=
 =?utf-8?B?ZzBXSCthc2NXemNaVHp0ZnNJQlQrb1BUNVBmWXpxUE1xZU85cVBqOFgwRnRK?=
 =?utf-8?B?RXp5emhHOHZWajU1Vmt4d09icDU4bkluZ2o3M01jeUFoSjhxU2s2bC9hNFFk?=
 =?utf-8?B?bEZoTHNPb013aktlNEpkaG9RY2JMc3BOTzh6QU5qb2R0Q1B3enl6VkJxeG9t?=
 =?utf-8?B?UGtndVk3THE4OFV4eG5NU0FxaTIxQ2ZVS3BMa2ZDSXdTdElKcy9FUnk1eDEr?=
 =?utf-8?B?OFc1QVQ3TFZGay80bWZaY2d4ZFdPMndBL29wNzIvVlMydEhHL1YvdjNoVEQx?=
 =?utf-8?B?S1ZDU0FPOTdZM0xmbExWaWNBRkNnZU8reUFsSGM3dEM0bmFsbEdzVTJWV2Vk?=
 =?utf-8?Q?SyILvO7cHdY0MBnQ=3D?=
X-Exchange-RoutingPolicyChecked: seC3bMAsXG566SQEiW6WGf67OLMZehQYZ7/65VdoNWpxG0A5sY48kaYeoOVwF0iBFgIdP8VM+Nx4O/e/HbS0q55+HR+EpH/iAewPAKcg37y+9N1BAir7JN9G3Str0INt9sXitiqf3DqYeKSmVXXpJchHl9LFnkdtKw3QDKHhJdahsWFVWxD3NGQEPa7+dzeqjUKmQ2mUlZNmgb4wVMYklEEaIdLhkAjl0GbeHOhiK/quVBwb24L0myNkhU6zIYWthy5oX5rU8855j2PI8N4RLf4s9PU4uU6kRFs/tOGF5wIPXy5hFxxTnUnlDpHrK8KbcPhsrySHGbRinQ+4QV+i8Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0274f94d-1aa5-4da2-4b98-08debff42957
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 15:40:52.3516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4+eHoe7J0ZvMJwVUHdLZpTBV3Y8QR2VkO5KgSys8N50GZ31PTjWml/T4BARLVdubx9Fd20qjOMhDNDCQAly30KEL/oILPPMRQV4He3zjuU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7030
X-OriginatorOrg: intel.com

Hi Chenyu,

On 5/31/26 1:37 AM, Chen, Yu C wrote:
> On 5/29/2026 12:11 AM, Reinette Chatre wrote:
>>
>>
>> On 5/22/26 12:15 PM, Reinette Chatre wrote:
>>>   static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
>>> @@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>>>           return;
>>>       }
>>>   -    list_add_tail_rcu(&d->hdr.list, add_pos);
>>> -
>>>       err = resctrl_online_mon_domain(r, &d->hdr);
>>>       if (err) {
>>> -        list_del_rcu(&d->hdr.list);
>>> -        synchronize_rcu();
>>>           l3_mon_domain_free(hw_dom);
>>> +        return;
>>>       }
>>> +    list_add_tail_rcu(&d->hdr.list, add_pos);
>>>   }
>>>     static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)
>>
>> I resubmitted the last three patches of series to obtain Sashiko review [1] and
>> respond to that feedback here:
>>
>> a) Sashiko: "Does this reordering expose the monitor directories to userspace before the
>>     domain is actually added to the RCU list?"
>>
>>     Yes. As pointed out by Sashiko there is a short time where the monitoring data files
>>     may be exposed to user space before the monitoring domain is added to the RCU list.
>>     Also pointed out by Sashiko, if user attempts to read from such file it will return
>>     -ENOENT.
>>
>>     This behavior looks correct and acceptable to me.
> 
> It might not return -ENOENT because the read will be blocked by cpus_read_lock()
> and after the reader has grabed the cpus_read_lock(), the reader will see the newly
> added domain on the list:
> 
> CPU 0 (writer)                            CPU 1 (reader)
> ==========================                ==========================
> cpus_write_lock held                      cpus_read_lock() **BLOCKED**
>   mkdir mondata files
>   list_add_tail_rcu()
> cpus_write_unlock                         cpus_read_lock() returns
>                                             lock(rdtgroup_mutex)
>                                             resctrl_find_domain() **see a new complete domain**
>                                             unlock(rdtgroup_mutex)
>                                           cpus_read_unlock()

Indeed. Thank you very much for the correction.

> 
> 
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>

Thank you very much.

Reinette

