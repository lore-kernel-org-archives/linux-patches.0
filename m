Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.10
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793724188;
	b=QlhBzW3XVh39GngVu1b7kax6Ig4SEizsCyz4mFruOU1CeAGEkyE9JzZ8DtMieHTDrgBG
	 J1eo8dp4F8LD5qD1Az5HMnLf/ydohenfwTSAr3r2VEubn9NURTQyBHu/UpxVQo+SWI2Zb
	 R8XF5jJbmR9Niqkj6DNaUo86HWkyHUpez1PaJ2Jz8lU/ebM3qVLlan3EsEa71oVc2gYJu
	 g7TR4sZaui6xQRf8bMptDfSM07obntIWy069LJscFlnS5idsYMU0UxVkxKMWX5gFvOEZ8
	 gITU4WUt+NY1S+9oiD1+QmLZETBpRn69iDUnwtesk5fYkd6UQdtS7r7glWcm8oSK0vA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724188;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=MrAiYTf/ga6IbyZjTBaJZ83ZRb/lee3MQCYHF3giFg8=;
	b=CpQp1VnkT2vzDKSY/7eptVat6fXbwyhYPEJ+Fgt5dUx6wA0nlDOHIOpllSOfmD1i6gJ/
	 gp6NtSiBa7lX+CcwK5jS8TqgBZK0dfLf5pu5MvnjY55X5ABWzWrNlXnM41RvjNpxZ5SSs
	 z248hpJoCW757QqNOO4h5Mz5EirCHCUxzPhrlSIpyneQGp9uQAbiHg8HV2P6VNiqpaA/Q
	 KBBM40wzu2dSqct+Ue6N46+DJu8XH7hSqa8bEXal+SpZvbx/hlZM0Em62DgSov5FE+hGC
	 jooSzV3uHx2PWgsWC0/UyB65KWzBw4RcTYlglwJcSO8J5onDyTjcyFDWhsbz5yhzvow==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="bsXBl/Cx";
	arc=fail smtp.remote-ip=198.175.65.10
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A97606D834
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 16:43:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6A97606D834
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=bsXBl/Cx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793724188; x=1825260188;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=IwezmQdOLDA5eTZx1OUjOV7vvGYl10O4hknK4wz52+Y=;
  b=bsXBl/Cx99FfkCEsaxTiic86ljTS+G+TBm2pgaoYNesQ53ecWBct0QAK
   AqXt7XCR+VGIBJ7pcLWr1kxlnximXyay0u1L9QgSgkFDtlI9zDSTzplo9
   KzDRa2iiGlf03JvENE5fGHKXzmYfyhi4nKNisIX1HaGPktWl822AUcpeQ
   T8qhknEVWgvXKQx6AcqwSHr6vyc9N1ZVAtq/WG0Rwd6yPdlwUd++BwOYT
   zweyqlvrktK7L8/LQ+FhHGMHsrQ8noSIEuKrxaxrV3Jvu5SbcYVKg+CSH
   ifS9kstEZcC4b0RZVz20iwAr8bc/2BORlTzl/Da3QoSx/hjt1bo+lQced
   A==;
X-CSE-ConnectionGUID: ceKo0NrcS06jS5HaWrzR+g==
X-CSE-MsgGUID: 2wz9/9B5Qo+lCf1Ul7D3ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2357176"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2357176"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 08:43:07 -0800
X-CSE-ConnectionGUID: V/riO3r4Qq2WY1OBRw4A2A==
X-CSE-MsgGUID: NO3oZqu+T4Sq2c5Hm9sTKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6485114"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 08:43:07 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 08:43:06 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 08:43:06 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.54) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 08:43:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EtRSxZdkTkTFUrKRZ0c4kxNUgAqGmGvjbuDg5EjK5/MrEeauMF7IjmIgulM/7+meZ7lCEN3/iFRya/pwWkTmOdHarFcFvnFjiCYF+SNoGqfYMIX65k9nYBxuC7PnP8d79yblQAP6OhCUEpiz1zVoyN5I1i5v/ZPYGZJs+zB0U2a4m++CeulHPZQbq2YEFn0JPRK90gIg1HK2s5HsKeejYVQPF+NOc6/Bi90Q4EA8IhZuJnZnjFLCCBmYKf50+4TOyVy2tb7p/qmcg/x4d0LCJftDP7aSEbXFFwvTH/roy7w8Xovb7VeipGhfumYrQg6GGBKsv8AK9ExjhgJ+BODaZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrAiYTf/ga6IbyZjTBaJZ83ZRb/lee3MQCYHF3giFg8=;
 b=lFtJTGWi+LywHjybYgSn4JGtayC+fA21e+6JLFkWsh87rzMUqZo1g6jHWVBJzJNzxWPFxLi/13o0yb9APmkde9OtI3KSkjwBZdayrN2suZxunsp1MqYkGr2997LHqiGaUnO7LjEGYAXyUfXVZinT1z5OXmiaO6auY1py7ET4sgJ6+RGtZmeBbb2zqZsnvGL0BhGtO5Bzcgn0x8BD1v1TcLoucP3ISAG0VaQbRkWCjkslek+K56zCkKzs0Y+O4qSSrcJL1EIyHiU70e4fIp0nrQeQYowO8eW+FW4tpFW0QoEv0HgdT1917plMD73xoZ8i9ja1msuYxzItN6P7cXiScw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6020.namprd11.prod.outlook.com (2603:10b6:8:61::19) by
 MN6PR11MB8102.namprd11.prod.outlook.com (2603:10b6:208:46d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.569.12; Tue, 3 Nov 2026 16:42:56 +0000
Received: from DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765]) by DM4PR11MB6020.namprd11.prod.outlook.com
 ([fe80::3058:1480:e4ac:5765%3]) with mapi id 15.21.0569.011; Tue, 3 Nov 2026
 16:42:55 +0000
Date: Wed, 4 Nov 2026 00:31:46 +0800
From: Chen Yu <yu.c.chen@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>, <tony.luck@intel.com>
CC: "Luck, Tony" <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [RFC PATCH 0/8] arm,x86,fs/resctrl: Support asymmetric L2 cache
 allocation
Message-ID: <auoMcjGLGnwiynCX@chenyu-dev>
References: <20261026215718.16810-1-tony.luck@intel.com>
 <106caf0a-8644-4801-9591-80be38b39418@intel.com>
 <auDiLEujZ5BGCACj@agluck-desk3>
 <dbc8fc24-2ca3-4152-9bfa-81b6e5d502a9@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dbc8fc24-2ca3-4152-9bfa-81b6e5d502a9@intel.com>
X-ClientProxiedBy: SI1PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::12) To DM4PR11MB6020.namprd11.prod.outlook.com
 (2603:10b6:8:61::19)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6020:EE_|MN6PR11MB8102:EE_
X-MS-Office365-Filtering-Correlation-Id: 64852b2b-b302-4703-2e5a-08df39c982aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|366016|261009223027099003|11063799006|4143699003|261028144727099003|56012099006|261026140227099003|261022105027099003|261022075727099003|261026121527099003|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info: HnpUWFxYkrIEJ1F+Y3a/gpyOW87G+4vwzMBpuZqV7oWwg45bP92xjpc1T4RXMrntA+W9Voy2dvQEvGBS4YHl0uxyaZgdHsir70ec2Bs3vRvBsppB5icC3McCsUbzLgYs5L7lWMRAhYS8h8WKOKaWI1o15TpNxAAAZh7AKbNgnX2H9VklUmbnDvOMyH2/aWq6H9PPduJ8CA+BDeaKPqPk/7pYjoD+c+SjQ8jcoRoJmOvP3mFDbNC45MVT+9X1rRlK+KG0/5VeEV5rTsvLqmXitKRK71Wa7HrtSLy6C0NsHLPOr4mBSIagQQ32VP8RiGnBBS4DpllrCz/J+OKxQ/G7o7zJ1pk/9gpcEviI2RRWUwwzcl1ZM7a6XVJHDyC2VBj03blYEucTfULEaEEcMaqh6vpAsTDjyA7cUiCg2Qn77oXbH99HaANJ3lQugE28bzdaF3cVrYUU63lkeq9tFeuGxrrHcELlR5n2nma8MbgZKi5uoxpVw4gQ6LwZReV3DYalRd0Ao9z24Y3rvDTJab2iEOgkd1ksfghk7UvTQZxWQkP4/UBKclaeQAr4DaysK6K9TjkxWhbGq1czY3JBtWLS+SCdWjZ12BdS8hwU+a7lIb93k1qmN00X50gL5KbHf29T
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6020.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(366016)(261009223027099003)(11063799006)(4143699003)(261028144727099003)(56012099006)(261026140227099003)(261022105027099003)(261022075727099003)(261026121527099003)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZVl3NlF3Wk0zS3Z1b1NLb0ZmWHg4cVVVOGRjSzZsRWpnWUFmYmEyUWJzRzN1?=
 =?utf-8?B?cXN6WEVvbzJkc3VDd0hVdHJOY05IVXJXNVBwMnFxL1FFbDNsSk0rYkl5Qmh0?=
 =?utf-8?B?WkZEUDBKaXhkVGYxSEJUZWpZMW43OElJOVpZYnUzNFdKZUdWRjNldVVEbTFZ?=
 =?utf-8?B?QWRTa3pWbXNaL2RoY2ZlM0pWMGRHMDI1b3o5S3hna1dIS2tuRjVibVI3Ky9K?=
 =?utf-8?B?UXE4U1IwSXphSkZZeEtnSWhFMW8vTHgzNUEySGlEN3QyWEZ4V2pZMmhXcE5P?=
 =?utf-8?B?UGNGUWZGZC9Qam9DYUxnelBQUUtXOEJHRUhHbTB1SWp4NnA5R2JrdjcraGt4?=
 =?utf-8?B?TmZvdDllNUxsa0M0UEZscGdnYUx1MmNkSFA0SVRvamJuTkFFS00ycERrSWdR?=
 =?utf-8?B?WnRhN29OTndtRlZacVovczJITEhvTTV4ckxpT1FEd0FVYm13Qk1DT2hTQ21J?=
 =?utf-8?B?ejZqUGF2bFVac1ppZ09sb0Izd2tPaVFsazBQeEtGemdIci9HV1A1Vm5jWTVC?=
 =?utf-8?B?ejgvK3d5YjNGRExRRUtmTHZKL3c3ZlczWGViVjFIYzJqZm12VFUvbit6cDJF?=
 =?utf-8?B?N3lVYWtiTHZhaC9KR1FCT0F6Tzh3ekVXdHpIQ0FicXRXZGo1b2hHSE4ycmdP?=
 =?utf-8?B?RDBiRysrV0MrNmpJem1tOExJeVV1M1FFVkRLYzR2RmFOR3RYTVJDdXZWbkRv?=
 =?utf-8?B?b1dFTzJ6UmFzQ1dUZkcvcTlpTUdkZk8rb0FydjIxakpwcG5CTEVST2ttZUR3?=
 =?utf-8?B?UWxGQ2V2SlFtdUNqSEM4Zm8zMVZGNDVPK1VQSDZtcmlRTnNGUWROTTBBYnJi?=
 =?utf-8?B?T0o3b01FTFUrY09tbGRTcCt3K0hJVTdWckxVQlViUG91bTVsU3QrMDB2TFBC?=
 =?utf-8?B?OTEvTFpZM29POUwzazNZVGtVdHhMbkZvMTkvS29GMkJ6UkxjcWZDZGNMQkxC?=
 =?utf-8?B?ZTZINDJrN1BoQ0N0TDczMkx2L1FYTG4zQzdwUzNWZ29NVUo1VzBzekdESjNV?=
 =?utf-8?B?Sm1sK2dIbGx1TVdjN0F5RnRvVDhjaS90TzhJSFhZNFRkeE1XemN2MkZsazZt?=
 =?utf-8?B?b0lTU1lkZURveVlzbWFkQ2J3OERXWDJ5MHFWZ0xTV09Eb25yMkIza1ZZS3JI?=
 =?utf-8?B?S05xbng1dkdCcmtucy9CN2lOdUptQXo1ZERQdjZDN1ZJZ0YvUk1SbE4wRWg5?=
 =?utf-8?B?cHUrb0QwL09nOEFOTHZHQ2FQSzdhcEZTUzJ1RDE0TkduY05NaUx2SHhEeHlG?=
 =?utf-8?B?MDg1Wm4weSt3WGtyVUJYeGxsSzl5SU1uenkzZUxoT2hYYkt1b21jTDlNUnRz?=
 =?utf-8?B?VUR6SmRsdnUrc1RqMEpudkVBMTJVbVZtc3NKdHVWalAxWnprWGtocFZNdTQ3?=
 =?utf-8?B?c3JhMUhMd3UvUDdTdTRzZTRRaTVnNHA5UFJJcTVDVjhzRGVTWDRidXlhY2pM?=
 =?utf-8?B?SWorWjhram9KT3E4bUkrc0lBc0tLVHROQlplRFArT2pabEhKWU9RVWRmNmZZ?=
 =?utf-8?B?OCtlbEJlMTN5QzIxRWVTTlNQNHJZd1dhYW5iM3h5bmhYZEV3bE5KWE9OZHhn?=
 =?utf-8?B?czhHWGNnaDhsRDJmemp5dlI1V0Rzclg5bHJURC9EalJ5RmJIemNZUmovK1or?=
 =?utf-8?B?aDZxQ0dwcXZiajRuR1BodStpRXpmTFdFWnFrRnE0eEtRaldSNEpTWHJRbkNB?=
 =?utf-8?B?Zm9YV1RubmlsWGtnMEc4THpzN1k2RjFOYU1QNFR0WXBEYkJ5TTRnYUNteG5Y?=
 =?utf-8?B?SXJ3b01pcnhNVE9kNkhGS2Y0Z0tOQ29Id3ZvSktxNWFxVjd0RDV5NFRKdG5v?=
 =?utf-8?B?QnhmTFp4czNGYnM4L0lPMHFvanlvMWJ2b1JYOWRZQ0pCN1Rwb2ZJZVcwSVNw?=
 =?utf-8?B?Q2hma0owczlLdlZGSG41dFp2Z3J6THI5clFyenAvaUxvTUVZNEtsVnZ4K1di?=
 =?utf-8?B?d0RQZlExT0F2WGwvQnRpWDNlK0QrdElzVXVxNUlxNytJQXZwaSt5TXlzRlBF?=
 =?utf-8?B?TlVLRDdmd2ZJWllmbWorUmNRTUhROTAxL29SNEVrazBKYnl4b09OT09hS2Zj?=
 =?utf-8?B?S3BOSWZvb0E0Zk1pak5rdG5rZSt5TEpLenkxTmtCVnlYVlRBMkxvYnRNbklt?=
 =?utf-8?B?U2EvK25UaDNUYzZKTDNneU5aV0M3ZTZmTDdpU2l2RjBQUkVYZklYS3NuZVJz?=
 =?utf-8?B?SExnRjF4ME5CbXRkUnVaK1QxdEg3WGhGRzlZeExtWG43NnFDc3VWRTREemlx?=
 =?utf-8?B?Ky9hRXU0QnNSMGFMMzFKUkQrLy9EUkFwQnVNVjVQend5QW5KbDNLYVJaWGh1?=
 =?utf-8?B?YXJNSUMrb3RIdlZqL3hsNWVFalRQbmNHL0lpSjdCS3pQYWxlS2RDZz09?=
X-Exchange-RoutingPolicyChecked: LJPBs8tlmS/M2xVYIu+MNEFZagxvBRgn34y7+UCmsTZ6s+y1eUHKSNBgrHurjmAkzVWRESsi/htlm89ufN5gk/jMGwuHopvaPYrPGtwRn9/wIUwrlNqOTk1qQH2XuOuIL1gVp+rIKCHRi7hDjx9H1zngMeqFWvTuXCnr5VGfei8D/OufwxrMHp6XXsRyIExcwIiFHyoSAXYHcIHZv/Ku5Kai8/6LaCoDzrPZm6hYJPwN7NRbunkBJtCsWC4hzm+6XJI4XdCk7XbIlGkBqJSATT15LL2gtfawUEK5be6F8JF+2Ik8AV4iN2RpINI6NQfdl2fejtDNMR2eEBWWjb+2Mg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 64852b2b-b302-4703-2e5a-08df39c982aa
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6020.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2026 16:42:55.5624
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wU01D5yHrrpFBaZfH6Iga5BpiAF8B7OBgIdcH3GpkjlHsCBkKQaHef+DXud1siyYdCq7akK2fL7H8TTtgfaMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8102
X-OriginatorOrg: intel.com

On Tue, Oct 27, 2026 at 11:30:37AM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> > # tree
> > .
> > ├── cpus
> > ├── cpus_list
> > ├── info
> > │   ├── L2
> > │   │   ├── bit_usage
> > │   │   ├── control_mode
> > │   │   ├── min_cbm_bits
> > │   │   ├── num_closids
> > │   │   ├── schemata
> 
> This needs an L2 control. As I highlighted in 
> 
> 	https://lore.kernel.org/lkml/22ecec13-a703-414e-9f5e-75c89173e845@intel.com/
> 
> when considering pqos utility user space expects an L2 schemata file entry
> when there is an L2 resource.
> 
> Since L2_ASYM is the native interface it could be used to emulate the legacy L2 control
> albeit with poor performance. By default the schemata file only contains the L2 control
> and a user space familiar with new interface can enable L2_ASYM to replace L2 control
> in schemata file.
>

In current patch it seems that we did not create any new controller, and fixes the
per rdt_ctrl_domain's cbm_len, I'm trying to understand why do we need to create a new "native"
controller?

Anyway, if we introduce a new controller, and keep the legacy interfaces, we might want to
encourage the user to switch to the new ones, would the following proposal be doable?

1.When booting up with control_mode = legacy, and the new control mode is supported
(asymmetric, region-aware, etc.), we can print a message saying: new control is available,
please switch the control_mode to "native".

2.Add a mount option to support control_mode.

3.The rdt= option, but only for x86 — not sure why rdt= is not a generic option.

thanks,
Chenyu
