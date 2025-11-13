Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA491CAA92
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 04:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763006736; cv=fail; b=R1b9M+DXYYzFFORkzPfsamJvVn8LD9oK933/8qSXZ5XtHJ/4F7g4tsLsdTQClY3vfrNWWvfWKlzvb4YGfoZR2o3eaNB8ZxssxywnU9CgdlJUb//HRU2uQ+kzvSesJEqSBvHs0hAJWPs/+wLtyT7PqjQxKKXqc3lf9BioR++13wk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763006736; c=relaxed/simple;
	bh=H6LEnPgQwGFHT/aJNE4tqNwOBCwXRHcIBTt7V+7loc0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=byIciq0x+xU9ZdrtXKx3hP/p6t4xmjHEwQGClDNlfy1b+FVR2FvK0ou1sakhGcy7L6tiTneA18m/echzBpSZZMRMUK9rwDnT3IBDhwt2DLrYk/RyRWLhvovqEm6eSPvPzkMf/7AwT7lPPsgDoI4Oq2vAXodSSsKWDhxT6OFCelY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ahkDhzxU; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ahkDhzxU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763006733; x=1794542733;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=H6LEnPgQwGFHT/aJNE4tqNwOBCwXRHcIBTt7V+7loc0=;
  b=ahkDhzxU3GU/YQMRDmhfAZoXFlghJXEL9uPa3uFP7BE3PfLsdTY1A1ZF
   pePdSygbarDDSP6npH39WCPRgcgA21jl6Yg4ODy5a8F89fKk1EW8O8yRc
   q7mT40vwvahIx8VbfRsCF7YML02iwsqLtZF6r3jRkGffWRwP5CqLME6cX
   D8E2FECJlmdEvEuAN2J4ptWCPq7E4soK7G0HBNw5F1d37oI+ugqrsW6VO
   y6lZvwiyDkutEXOJXwDuBoqP7uJfxnBdTZh4p6N7hjl3GVven4WZN15h7
   5l1d6RBcbqXZk9PtFx0k5gYFWCTwHoSZ2x8sxp44rpC+OfYuXfhptGfvB
   Q==;
X-CSE-ConnectionGUID: 6GnatensSyGVDxLBNAdDSw==
X-CSE-MsgGUID: 5+612N/FSYqtWew7C6j7ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="68931599"
X-IronPort-AV: E=Sophos;i="6.19,300,1754982000"; 
   d="scan'208";a="68931599"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:05:33 -0800
X-CSE-ConnectionGUID: omNdzCYeTMmmu+hqRf7JvA==
X-CSE-MsgGUID: +faRBwW+SkO2tjVsm1Zkmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="194579302"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 20:05:33 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:05:32 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 20:05:32 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.56) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 20:05:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r+smcIjm7xydN4rfebU8YAXzR9ySvst7tGcPtndNX43kgHFBWhWbZW0qdRmqysHjo82yvipRVQNfcV+1nBS1XhDcItHt7lqyFFCv6sA37r328qDjnTwM91fSMDr4DRcoaXF0DzkfU/6QZjYzZTyd27LHz8AOYI/KAq9siLnqlqp2V4gdBtyW1s2C+1fD/cxde1dWbrjfe2ZDQWiU0wnRCyBjffx5/IFsRRZ/Ew5bLJvEDoWbPJx443nJ9+r7fVNDENIEJqF4OGCEMOZGV3Jn3Zp703oiRAXbR6Ny8bdwfIIY2sJRG1JVfOlKt7gtKP4xhj9zyXTk3zTcKwCYseoKWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m2+TWXFcHngBAzJDtPe0rOW2fPfO9Tt45Q+RsASS/Ts=;
 b=jbAvtcQ8dshijH0/qjbuD24DPiy9RijU7NiImb0cBmlrnobjE4RPtJEIxZIKOZjr8nzrdTD5yCW97fAg8tw3vX28fHzi1UWgN6E6yR6Pj5Mxmx8Hpif5cyM0Cq8pwU1KEdATz6p8ciV2mGrKAHB29z2U7wksTIGMgB2ab6CZL4jAkW2Bbe5bwJKszA3GUDoJZYg71SybVJkgGcL6PCmFFXkBNRTBvxw7kZpUw2JU7ZLnGbydhlnzduBbhavVSa5Zmy2P8Hd+7O0XvdAdoRUtrOuRXcRhdu+g21sOeJVZ7LwQqsiarw9+aiK8fXIq6SG/QvJYm6BiEcQ68QfKQsDCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PPF341F90799.namprd11.prod.outlook.com (2603:10b6:f:fc00::f19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 04:05:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 04:05:16 +0000
Message-ID: <cc70a3ed-2b07-492b-b18f-5338524cf522@intel.com>
Date: Wed, 12 Nov 2025 20:05:14 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 15/32] fs/resctrl: Cleanup as L3 is no longer the only
 monitor resource
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-16-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-16-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0028.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::41) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PPF341F90799:EE_
X-MS-Office365-Filtering-Correlation-Id: 785b4265-a0ca-4979-4f5a-08de2269da2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NjQ1TkMwanNnRVpLc1ovL01xQXZjUEhKeUl1VkJrdStJRFRhQzl6Z0piSk92?=
 =?utf-8?B?L1Y1WUlhVzJMVEFkTmxKbTBCTVRodjl4VDRhR2NKTkhzMnNKdTFyY0t4V1NV?=
 =?utf-8?B?a1VoOEdTOUZmdkFXT1gvTkROSE1zT1ZPSUJSWS9YR2MvNk13ZzZURWYvWnNt?=
 =?utf-8?B?VTkvYXlNejFnSEF4VVlMR0dEZ1I3RDdJNlcyLzJXbU5leWhBYkdIeTNJYnNn?=
 =?utf-8?B?Y1V0aldCWGtoWkhDMVRkSHcxczRYbTlubzBYenMxbEozcUhnTVBJR0dCZ1BE?=
 =?utf-8?B?ODdIc2NZS2U5aGJlZkVHNHlwdU5DS3ZHaG9VTXRhU2xXRzE1VXFETTRhVFg0?=
 =?utf-8?B?U051cDAwZTBlZmRpSWFXKzNSU2ZucHlyODFRQ09aN0oxOW1hRW5jb0xRT01V?=
 =?utf-8?B?cEFUVFlNRGllTUxMWUZwK0Y1dmNybDdHQXhLVjdldUdCM2Z5S0xmdDFpNTQz?=
 =?utf-8?B?TGhGcjBOVmFzU3RKTTV2RGxPRDI5eTBUR1RkaDV2VGhlbUZwYjRNb1Q1ZzJk?=
 =?utf-8?B?U2ROL1NFWlRIRXZ6WU9KeGZYSDZEV0tBZk5aRCtsYm5HeWpRYzRTaWFKWUpi?=
 =?utf-8?B?UEpBTVlTQ09DcmRXU2F5UGlSOTFHVFhrTUkrNFhyZEhnR3l6MlIvaTJMMVRt?=
 =?utf-8?B?RFNzSWNreEZBdXYrbk5kYitLUVpES1dTS0lGRmYva29wQlliK2U1dXVBU3BD?=
 =?utf-8?B?eFo5dFZlYm1EYWUwcERSeitpLzFFVGhHUVVhTG1nQXRlTlFjZnJpY29vRDFD?=
 =?utf-8?B?ZDRLTGd2aHo3Z0dkS0hBT2ZYUFlabEpJdTUvYjlubnRiZHgrWk9wRnVkSzFi?=
 =?utf-8?B?UVJRbUtnbnZhenlxa05JR1FHY1ZXUndxQVZ3SVBEZkxJUlhtRFJDeWpoZktM?=
 =?utf-8?B?Vy9yZ01La3BMSjVzekE3RWNHY0ZxazFnR1JvUXhuWDZEM21GbWlCRnh3MlhP?=
 =?utf-8?B?ajhBamZsU1R6NXhBK3IxOWc2WmJzdkppSnY0SkZpK1dpV1FPSkV0UkpMY05k?=
 =?utf-8?B?a2l2cTRCSG5ienNpYVBlQmJXaWNtSjB2MWFiUmxLd1FzY1RIWnBHRzd5MVcz?=
 =?utf-8?B?TXl1c3ZXdWpIemRBNkZDTlhOdkpZRkxzSyt4aTJKcjEyV2tYR1VTWjJPcUlo?=
 =?utf-8?B?MW5qcmQrbWtibXpzd25hdHZGYzEyaEZmZ2x0dHgvSmlaTWU5U1llYU80QU1j?=
 =?utf-8?B?ajVyNjR4L2UwbDh0ZnpOdDZZQzJkRlN0VVpTSkQ5SXZVNnBrV0VVMkMrUTc2?=
 =?utf-8?B?N1lFY1JqSFhncXhMSEhiQnlZSDA0azFjTkVXdUhBYUV6ZWRQcUNDdjdFUGx2?=
 =?utf-8?B?ZDdoOFZmNjJONk9JWXBSbGZoRXArdmM5Wm5Ba3Q1ZjkrQmFkdU0yQlNHQ09X?=
 =?utf-8?B?M2lYNjVRQlNBRDRpTUJnbENZQlpvSTU3cHVlNmNkK1ZOT2FkUU5ud0FSNWVo?=
 =?utf-8?B?YisvaTZHY1k0NVo1aUEzMU9MejcvU28xNnBUT2syNDcycFEweW1JU3JCRlVS?=
 =?utf-8?B?QnJpVmtJbEFWS0Z3cUcwb3JZWFl4Q2lCR2lnUkUyRHFUVzREaHRpaEVRODVP?=
 =?utf-8?B?Y3g2U1BCSXViVURURHhmTlNMcWZtd3kzK2VJdTNET0Z5dlFoMk95T2UyMmw3?=
 =?utf-8?B?bVdZbGV4TWxLNEZZTlkvd0pVN0JmNi9NLzhmU3V3M1gvTE9lMGFLRGxRRWI4?=
 =?utf-8?B?SFhuQ205K3pLRnZIbjUvZU5SK2wzOHdjeEFxejJvNHFGdXAvN3VrU2d1MDQx?=
 =?utf-8?B?aFZnVkJtVnVyOU5ZVlVCZEcvemRMcXNSK0ZjMzlOejl1TmIwUUliZDR6eEE3?=
 =?utf-8?B?VGsvZ01lVXVmeXM4THRnVVRjR3FENlA2WDJodERhWU9YOHZURk9JUVFXRW9p?=
 =?utf-8?B?UHFYTWZXQ0RwM25USHBTQUxNSjBwdDhoMDlCaktFSUJtRGFyVFR6dWZKSmhi?=
 =?utf-8?Q?yq2D1Fum9N5MbZv8R/bpbOuNANgdfLDI?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N3ZBSEh3aUhpMkNuNXA2ZE9VbGdxelhEb3RScHlUTlhZTnh4cUF0bnd2WGhQ?=
 =?utf-8?B?NFdHYS9MRWczc1VjbWFialIvR0lRL215M3dkcmxNb2JOcFFFSG5CdEx1azBp?=
 =?utf-8?B?WUdtQ2tmVHRRUWhmRDcwb1kyaGU1YVM0QXZoZ2oxaldBc045NWVrQXFJK2hk?=
 =?utf-8?B?QW9pRnhxbDd3bUhqYzJ5SUdWVWo0NXFwK1NaRWYycDAzV0Rra1hleVJKdWVk?=
 =?utf-8?B?TzF4WU8wZWVtL1NGMDFvTDJqdjNZcGFGTm4zZEpPSEo1WmdWWTJsUXFGL0l6?=
 =?utf-8?B?QUhqUVlhbzQ3NU5iUkNxMHJkcS9aNjZPOGpCbnRUTXIrakJiL1hpdnV0alBN?=
 =?utf-8?B?U2NiQTROTnpzNkZlTXdrNlRqeWEvbWdPVEt6d0VhNlRuWFR1c2QvZVp3Rzlh?=
 =?utf-8?B?cjZaRmlmVWp4NGZMN21PZDNKeVNGY3BTZW9LS0pxTlp6c2tYWVhMNlhPaERz?=
 =?utf-8?B?eG9QZ0FsaEVLUmx2ZEJBcHB1U21rUEYvZi9JQ3E0UnlMSlYvZ3V4akdYNGxy?=
 =?utf-8?B?YXZsS0VpRnJnMlNqZU9qNnc4WWxaWjkzQ2paUk80ZXdHNWxhQVV4OENiaVY0?=
 =?utf-8?B?RUdqUVlQTEVyekROQWpGWHVFUEJTZC80dXN2YlMvTWdKRGFsakdpQ0hNTW9w?=
 =?utf-8?B?YnBxK09vWWlVaXJpa3VIRTVKQTVmMW5hOUlGMStsNGdUQVhibXV6czZHbVox?=
 =?utf-8?B?RlE0MEt4R1NrK1hSQkdSS0RrYThqS2xnNjA0YTg4MlB2ekVsd1c1cTBxeUhi?=
 =?utf-8?B?c2o1UG1peHNtT09xUVdUZVRUSHB3aTFLd0NwVHh4STl0VTVqS2RuRWpNOGZG?=
 =?utf-8?B?RlVCc1FNTGthUkZ6cVpIdkpmeW1PTU4vUFRMMkJudmR4LzBPa2VjT0RFdVVC?=
 =?utf-8?B?amcrUDgrMVRWZi8zbFBBeHdTVktTWEloQTMrZ29vMVp0L3RTSG0yOWhTVFdN?=
 =?utf-8?B?NTdqVVBjdkdmdTl1ZWl0R2FGSTN3b0VhdFlRdlRZeFRhQW10L1prTTZLSU5Q?=
 =?utf-8?B?OTEwQ01nVUlCM1ErRFY3dmpVR21RSStjZDNNOFJtRlZJY0s5M2JmdVlkRVlD?=
 =?utf-8?B?SjNYaTd6UUtmWk5YVGNXREtwSjRuT1VRTXpXTHE5NG1Qd3l5eVBlbDd5NXpD?=
 =?utf-8?B?a0VxdE1CU2dYMzNRYzVBU2hyVWZJQTNCL2lMMkgxSFZGaDd1Vjd6VEpOY3Jx?=
 =?utf-8?B?UC9nSjd5UXlQTTlqdHFYbkFUUWFoL0pOWDJ2Vy9jU2w1QXN2M3ArTDZhdkR3?=
 =?utf-8?B?eUxQZW43aHhLT0w2dURSbVdwOVNZYlB4ZEhYSDg3Y1E0SVJHcjM1YS9VVU9k?=
 =?utf-8?B?aWdqSzl0YStJalRxZ25KMjByemFSSU0yWWN6NmV3SVpsOGc3aGhyaUtUWXNm?=
 =?utf-8?B?WEtVaFNuLzF2ZzFlTTg5dGZBR1FRS09ObG9HNFdpbkFZbS9HTUkvUDZuUXNk?=
 =?utf-8?B?enl5MDlValZqUlNPOHF6K2hualFybEY4WkpxdUI3OXdhTm5yWXB3aHBnV2hl?=
 =?utf-8?B?UU4ySUwxK2MwLzdSRVpFRVQrdnZVNndPUmE2cTJJTmorQnNvVUJpRmVlT051?=
 =?utf-8?B?cDNEclhDZld6TVFKcnJoUkZ5NkNCa2xLcWdFc0FZZUt2MG8vVU8ydkZNZzJ2?=
 =?utf-8?B?V2RmWVlBVWxablprOGZIZlkxZkFrTS91NlAzOUlpN3lMNFlPQkt3MVdMS0NC?=
 =?utf-8?B?aEFhMGh2bGQzQVBmQ3k4WHJnQjAyOXdKUktucm9FT2QwbkN5bVJtQ1g5UzVO?=
 =?utf-8?B?NmhMOGtoU3VURnc2ZU5uaTU0RnhyYUpVendsbUFGQnhLYXhLQWZqOTFudkxG?=
 =?utf-8?B?V2RoOWNVZHFlamRkei9KL3dUZGoranRhTENlRi9zZmo3b2ZpZm44VHNNTlhH?=
 =?utf-8?B?b29Sb1N1Q0d2YjZOL2V4OGNoem5WZkRnZ0xDZkRzbjB4Mk5Dbm9Ha3NCdWU0?=
 =?utf-8?B?U0d3RXhtVXJUeHBEdVFydE1sRXlsc3dOUjlybE5sTHlLR01HZGh4Q2svc0VI?=
 =?utf-8?B?L2VuTVEzTW9JemdCTDJBUUpESUdBejFtNnZ4M3o0MXFoL1B0VEIvTmIrMzBL?=
 =?utf-8?B?KzZzL1dtZXFkeldaN1I4SGlrVVpvZ1NjMXJ4SXVvRVp6cUFlNzFvNW1pNFVD?=
 =?utf-8?B?NlJRRzdCbjVYeldGamVLQ09ycWlzdGNnalVzSlpQT2w1RmQrbjlxVWNwaEdS?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 785b4265-a0ca-4979-4f5a-08de2269da2a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 04:05:16.1702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yx/pV7xsPRNz3JbdcDjMrGRdswPtNw6v3g5zzDlAVjwXRUEkG0lMZFC82yplsMhHDHOn1rHs5XISScJ0ctOANuABSjMHfpz6WMHtDxBy9AU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF341F90799
X-OriginatorOrg: intel.com

Hi Tony,

I do not see how the subject matches this patch. How about something like:
"fs/resctrl: Emphasize that L3 monitoring resource is required for summing domains"

On 10/29/25 9:20 AM, Tony Luck wrote:
> The feature to sum event data across multiple domains supports systems
> with Sub-NUMA Cluster (SNC) mode enabled. The top-level monitoring files
> in each "mon_L3_XX" directory provide the sum of data across all SNC
> nodes sharing an L3 cache instance while the "mon_sub_L3_YY" sub-directories
> provide the event data of the individual nodes.
> 
> SNC is only associated with the L3 resource and domains and as a result
> the flow handling the sum of event data implicitly assumes it is
> working with the L3 resource and domains.
> 
> Reading of telemetry events do not require to sum event data so this
> feature can remain dedicated to SNC and keep the implicit assumption
> of working with the L3 resource and domains.
> 
> Add a WARN to where the implicit assumption of working with the L3 resource
> is made and add comments on how the structure controlling the event sum
> feature is used.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

| Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
