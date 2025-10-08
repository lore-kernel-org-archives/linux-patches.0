Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30D71ADC7E
	for <patches@lists.linux.dev>; Wed,  8 Oct 2025 17:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759943564; cv=fail; b=HzVpZiE2rUdX//BlWK/N9P6b1mBGygDOVaPenBJzBGjRS741Sn9BvqBfPtvLbp9PjjfYbe6/5wFXDSeTP9oWo/1q0zwwb5VF6DpkYXCge/LytDJjYBntf7IFnKsihr2kzZPzcfP5Htk1LfZYhXjOJsAdKZ7aqEPDf60QwNoHOUo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759943564; c=relaxed/simple;
	bh=Usuja4oxlvI9RDAkaeT9MUfPOSOUTcUElOxFQDFqjfY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VYUu+bebxyphzZkUAPYkaqraKKvk4HLfqGCb3cFedX36/DEJwuLu5voLaL8PcY3e2+bYsTIwBh90Ep1bDtrMZN2mmuRzNJPvxwJ3YiF+3pGeNOQzj+IHvBTx+QUXdcwj1WRlBV77ks4H88bviNV4gPOleaFdVWGMZO9NliMEuX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DEhrWuJT; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DEhrWuJT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759943562; x=1791479562;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Usuja4oxlvI9RDAkaeT9MUfPOSOUTcUElOxFQDFqjfY=;
  b=DEhrWuJT0QWjBXBIj/vOlJlixKYxsnWbNLlpGZ6k3Xlf+KymI5y8U4f0
   GQIYvCeQZGpN0rsRwTrsPmCXB04am1jbrqKA2Je1DMkSnDWv9dTAVMlun
   VrP0uEw79lBfRPgOaDJzE+MG6SLypHfF8C98g9MEyPKqdCSU33fysuHjL
   7WmRjsTSbQWpzBuPo0sQt8DgN8iEOrsg0sIPzSWO9yr70KxNrm2sCrDWE
   mI7TX5yzLLNW7hXYxAoK41TEASsBAsWJzt34W6tTlgaRTHHXfCdR4L4Yv
   /YLmn/rw38oZDaQFTSQIXX7lZGOcLRuUNpmTxd57YOhp3F2GI1TwQhrbl
   Q==;
X-CSE-ConnectionGUID: 5+NrsOy0ROyhu6cVoSiiww==
X-CSE-MsgGUID: 47UYJ411Qsu407+Q6PRsmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11576"; a="49705332"
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="49705332"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 10:12:40 -0700
X-CSE-ConnectionGUID: pEwE/wnHThCr+1kaL66xag==
X-CSE-MsgGUID: m7GhOLzrSP2ncPxiCKbmTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,213,1754982000"; 
   d="scan'208";a="185787648"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2025 10:12:40 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 10:12:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 8 Oct 2025 10:12:39 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 8 Oct 2025 10:12:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hPyTYWzF+HFafOnW0tzpWsZ6j3u+HdPIFfAo1nAkszpNicjbyBZOhJDVVT+/u/cWzyLQJK4Ii0ZTseE6jCLJy2ZxOpignZyJrwHd/SidPKp60cwISv87OwhuINZPaqLCpWWnetStA4HCHPWEZqFwZmiXGOhq8XIYTwGrY0s/LCgb2oTt2dr39qcyfbZZQoSMwrWzf5+QlJBg791YBzYwgRl9CHOml/fSLGaW6UIRu333wfq2xwcIKwhMDYWBWcPZCHI5FYBF8EYvP7QTsjCewVJ5XQTPColljxqkJuub+syWPtLuLgXdKsmqqnJIHP1tPk++/5ddtKvLnPJroPbRqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5KJjLD0v50Z1BmAji7M4pmIe5jnsgesy5ixgAuFMCuw=;
 b=vjB3OsNZBE5pouXVgbBbufJCbA9bxw/AACBDihk9mffe83h0gFjgcteiznldSWaFftuMeE4FP01Lx2UoenerJm30mf1HlT9zSxyE3jyguwVVQLOFU5V7xewRTyo3zgoAcUgTjqknPmy/OlHz2LHmcz790AIVr8S9dVXUylNTd24izjpxkNY1Tum+bzVytjafook0UYXpRgP4CoW/cPwvnAXSO/xI/30bMmiuMVKLRFV3RMFTEy2Ocfq1eIXrbOAZZhqjIYWA2HHO+CoqProubXXeZDFx7NezwNplwcrzZE0xzGh2j7oMSQ2oDjKG3WsfQ6sXKEenr57ixJR9xG87wQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8855.namprd11.prod.outlook.com (2603:10b6:8:257::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Wed, 8 Oct
 2025 17:12:31 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Wed, 8 Oct 2025
 17:12:31 +0000
Message-ID: <a011002c-a4af-4ae5-8cd1-a1180a0f62c2@intel.com>
Date: Wed, 8 Oct 2025 10:12:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
 <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
 <aOQIMQsgBOta0PRP@agluck-desk3>
 <89e640fc-6bd7-40b1-8968-ca1a85005f4c@intel.com>
 <aOQ44WJMXweGNlL2@agluck-desk3> <aOV8bFiiQxlPDske@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aOV8bFiiQxlPDske@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0210.namprd03.prod.outlook.com
 (2603:10b6:303:b8::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8855:EE_
X-MS-Office365-Filtering-Correlation-Id: c0f2bcf5-c966-41d6-267a-08de068ddd81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M0Rlc1VaSS9PTTlBWnRBUGlid21HZnFwLzhuZkJvWlpvOVBhQ2d6NHhGU2ZW?=
 =?utf-8?B?TUxpcnJNTjU2VE5IMmVzUVNsT1ViWUNZK0JpYjFuOVlHQ1U0clNIcUd4S3dG?=
 =?utf-8?B?YUttSWIvU0FENlMxWUpJejVtTm0xUGJzUnVtWTVpZWJnV0JVRHJ2UGJvVXBZ?=
 =?utf-8?B?SWFPVUg4S0UxeWNzamM3aWJDWjdjb3VIOWFVcmNhcE5uVStFZCtVakxTVVkx?=
 =?utf-8?B?NlgvYU4wdnVGbTlNMkxlMDBoVUVXVU5xTVV1dnhWV0V0aTltWE80Kzd6ckJx?=
 =?utf-8?B?Y3hMVDI4bzFKaGQvaDNlMTloUkQ4MCtxanlycFZxbUFYcXFkZHVqS1lRcEhE?=
 =?utf-8?B?dnFqRkNGR3RFQTltTjBNY0ovMUU1c1N6bUE3SVcyeE92WVBHRnVaK0loQStF?=
 =?utf-8?B?QUI5KzdyakcweDJDNXdHN2tkNlZ0bGlPMURQQmlmWVFoVTg4SGFSMlliNVN5?=
 =?utf-8?B?eittdlVLVFhKanV4WTJQam9DeTErNFk2QTJpNWJoTlZiL1JEd1A0WlRyVXJZ?=
 =?utf-8?B?a25ZRjkwOGMrN1FxcERwaHhnUDNWK296SW90eHJETmw5MHhlRlhTd0UzTlI0?=
 =?utf-8?B?OFFnb0ZaZVg0bCtWVC9yaisxMWN6ZUg2b1BnUldOUUVVOVhnNklYY21rMEJl?=
 =?utf-8?B?em9QQjNsbms5WDVsNSs5VXFvSGpvQlpKdkRwTXZZRnFjS1FwUUQxa05wTHZk?=
 =?utf-8?B?UWJIcEVYSzlXVnJWOVh6OEllcStCV0Y2cVNQZUVZYUxmbFFUaHNNK1k2MjlB?=
 =?utf-8?B?TGtITEZJU2ZYQUxQTkhTTjllNU4zNGRoNzhRakgxVThodFE4ekZGTVJTaFZn?=
 =?utf-8?B?UzBOZFlyTWI1bEkvUFhiVFlBREZndEI0ei9pc1JySEloNk9mQ2NPR1JTQjZ4?=
 =?utf-8?B?ejVHanQrRVFMMjc0SU5rcTRrQis1ejdHeklLOGNvMUQ5dnM3U2hEcHRxSVBX?=
 =?utf-8?B?cEl4OWJEcEZXK1Z3KzRLNENxOUJyOE53OTFxanloSVIya1FYcTcvbUZUZU9D?=
 =?utf-8?B?Ymc0NnRvcGRqMFU5MXR4QzRQWllPdEw1MWdhbU5zVzhXa2ZqYmZ4cCtPeHhj?=
 =?utf-8?B?Z0dBeER5RklodUpVNjdDYVZRV2ZZSmRLTExnZVJrK2FSbExnQlAvMmRuVlNJ?=
 =?utf-8?B?R2JSMTl0dFlXWXdEVlhndlQ0NVJSVjM0NGRUc2doaXdvQ0xhZE1WaE5FY2lV?=
 =?utf-8?B?b2NheWNkNTEvRkREOG5TZ3l2WEFnU0tNQ3BiMVQwSzFZYXJxWkNmSnhpMW9S?=
 =?utf-8?B?V0ZLa0VlN2hSaENUanNWYVhEaUFkVnlUT2RMTmZmV24xbllqTElEbGJoL3E0?=
 =?utf-8?B?azlXemV0eEI2TTh0V3JOelZvZWxLYVI2Uk5PRklOT2J5TGQwUXdJbm1STjJ5?=
 =?utf-8?B?R3o1UU5RNTVjTWhoQUhXaGNUVXFSUzFjYy9FWlUvV0FFbjJpU3V4dXpna3o3?=
 =?utf-8?B?RlJFOXFjaHNKNmpPRVVkcEd2SWU3MmE5MGhJTmpVOTJlREZ2dEJDLzJyVGZJ?=
 =?utf-8?B?L01EWkJkMW8wSC9JZ2Jzc2h1ZFVjNTNSbkpPWExSM1J1Q0h0ckJLOElKOFl6?=
 =?utf-8?B?Tzc3OFNBZkZvREVRbWh3UTBiQU1TOEIyNlk5WHV1ZnR1ZTFBYTRHTFgwVlVD?=
 =?utf-8?B?ZW5MbkZLdUt1TEhTdDdteWQ1VlI1WHgxVHBuUmpnYkpJVC9qdFJXVnY5b2ho?=
 =?utf-8?B?dHRhM1Zvc1oxOUc0Skh1c2x2dUlnZ01Bc1pTOFVablNzZGZ2aTRDbnc2KzFB?=
 =?utf-8?B?aEYrZDJiYWNBeFVTK1l3MVYybTVpRUFwRmNoKzdhajJWeDFPZENEYjlIYU9n?=
 =?utf-8?B?Q1pjTEkvV3ZHd3RmOXZPTmpDaS9Ob2lHeXVIcFkranlkQnhqTVcxRW9vejlz?=
 =?utf-8?B?VWd3T0xyMnFjU1Z6R0ZpMmNxUlFFSjdrN0d1V0pjVW1ONTA4amVwWFZpRDVR?=
 =?utf-8?Q?tmyE2qwgmaliXWYAqyvVY9gMe1eYirJj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cEM0dHF6dG1XTmRjelJ1QjNTT3FhMmRvYnlJMW9kZDBxQmlsUkdaNnNkUzN0?=
 =?utf-8?B?UFh2OEpkdjAvbkpqWXpHc0UwUTYwS2NnSGhhYWNtQ1FGOGFwOTU1WEdLbjNR?=
 =?utf-8?B?L1lBS3VzTU90aUU3LzNPMjNhd1hRQ1pDdHR3MTF1a1pXWTNMa1ZxSUtNdjRY?=
 =?utf-8?B?NUJtdmRSSkNEWmNKWEtiNEw2eWVHREdYVE1sRFlwOFdTUFpNSHFFdmFiUTNq?=
 =?utf-8?B?TGEvT3NlOVY3Z25nMDdFS1o5dXFhWmtQOURzSUZFRXRiWUZTNzI3WlVZb1Fi?=
 =?utf-8?B?a2hCK04vS0swa0k2Q1Y2RGM2Rk5jeko1Wk9RZnVoWmNXRFBlOGpETEVWcDRo?=
 =?utf-8?B?c2R1UGNIYmJMVU5SOVFOUmxXdk83S2pJbThrVy9LL25tTytMM21CRmp4TU12?=
 =?utf-8?B?OWkydHQ3dDdGR3V4dm9XWlRiWSsxRTZ3dlpIeXBHbGp4VkRGQkFaMVAvRzZr?=
 =?utf-8?B?Z1ZvczVHWFhlc1V2b3Z5STd0UjE3cGhvRHBicnA4WnFHTFBiZWc3T0dZY1FN?=
 =?utf-8?B?NEorOEkybVUxejhnVTQ5d1ZLaGsxckh1V1NGK0lRbGFCUXA2N2l3cHlkMVcw?=
 =?utf-8?B?bHMxdDBTbkhMSGRPcEk3RGswdFVVVW1pT01IeFdkT2tEek9iV1Rxb1dwcFRV?=
 =?utf-8?B?UEVPcWRKSC9NM1dkUUM1VFBNM0NHc2xWT0dtZEVtMW1yV0JmcEw4aGRwd2l1?=
 =?utf-8?B?cCt4ajhzc2lUd2ZwNzFyWWNYV3IvM3lPSnhSTmgwNHMrYVhSR3BBSlp3cjdF?=
 =?utf-8?B?U2J3ZnMwN09WMHFZTXp1S3ROa2NXSGdJTnhmTDQ1UlhONUZJRkNaZEtES3Va?=
 =?utf-8?B?M0NUUnJEQ3M2U3Q1K3pWQUlndWdFVDhjQUtKSEpmTkt6OXcxOXRrTGdwQnd1?=
 =?utf-8?B?R2JZNE5kVk1DRGpJYlE2OW1uRjg1Tm9xNDNhbEIySnlUQ0N6UDlsVytiYlIw?=
 =?utf-8?B?SjA0ZmRyQWJVT1FNT09wUGd0VkJJWnd1elV0QzBwejgyVVpSTmNURnpmeE92?=
 =?utf-8?B?WHhqSWJZNzAybVN1T3hWalB5SW02Ny9UUms2Qm4xcEZHcml2bmVRYnV1MEd4?=
 =?utf-8?B?RVcyRGEraFZHRitTdmlhcGphNHI4MkRQNnlBT0kyZkY2UzZyemRkdHBKQk9a?=
 =?utf-8?B?aHI1c2o1b3dvc2h0YUNwM3RUVnh6ckpMTStNcmcvREVIMDJKejB3NWsyeHFy?=
 =?utf-8?B?bGdwcndXMDQvZmtYZzBQeGlxS3E0ZjIvcm1KaVlFODNNOUpxR3RmL21ManU0?=
 =?utf-8?B?eTE0OFB5dzJNanE5aXZIVTZVSGVKNVNrWXgyK2srSWMxV2t6QXJDM2pTNnhl?=
 =?utf-8?B?aGdLbGFibnBPRzlzRXBDeUdORUo1QkI3MkRMN0J5T3pjbWJkYmZmK3lDV0Ry?=
 =?utf-8?B?VWZubWZMTzE4UGRkaWpmLysrYlJ4YXBsdHVsOHV0c2VIajNJM0FqWTNNTDU3?=
 =?utf-8?B?amRHVWZqSkF5b3NkZjROWXg2SkZBQkpiVHgzVUVjTStYTlFDdFg4ejhsOC9y?=
 =?utf-8?B?TzJkZDRjM3RNMGRRY0pMOTNXM3RPY1ZuaUYxYWo3dnM3WFczeWM3eW9QQURZ?=
 =?utf-8?B?Y296cFcxQk1SVkpVMm5TWGl1THB6U2t4R2pjTHRrTGtiUzhqRlRJeW16aHU4?=
 =?utf-8?B?VDhZb2tlaDJoUWQxcWRkUjlaUFY4a1lEZHFQcGJwODhOcUpJT3hsREFNN3M0?=
 =?utf-8?B?RHN1U2ZPRTJ2S1JMZldTa0t0S3o2RjFwcFdSUzBCVGwwaG9aREYrS1Avd1Uv?=
 =?utf-8?B?Nm4zT3BLU1VobGVIMVpUK3dBKytHMjFSZThCNldiakRlelpJdm9HbzRvZHI2?=
 =?utf-8?B?dkhZMklseVFjbzFjOXlPVnhTTzhPRUEveUcwajNSMzRjcEVEbDREU2QwQlQ5?=
 =?utf-8?B?bEMxd0szRVNzVUxZb21xWXN5NkFvbFZPS1RLcTRsOWNsMzRBZjdiV21TRHNo?=
 =?utf-8?B?bVRqbTBoMXg3NGowYVhOanZtblZLY3VZVllrcDRJendETnpVT1BiQXRraWVM?=
 =?utf-8?B?N3V5eGpkWU5zRVB0V3JGT25pYWV0c1ZOSngvWStXb0J6RUVUZHZLV0lSRy9S?=
 =?utf-8?B?SEFlbDdjdDJmYlhza1Z6SDdDQUlNMkd2Tk4xOFFiRTRjR3FETUJ0T1U1WWZD?=
 =?utf-8?B?LytYeXZ2eDgwbE1XZ3Q4M3c2eGtOZTVZZy9pd24vdmFpeVpERUIxNXJDNjJm?=
 =?utf-8?B?VlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c0f2bcf5-c966-41d6-267a-08de068ddd81
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2025 17:12:31.1097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0E7C46qMlFHuz/JFRNNJNSwh5humJ89Sxr47h189ZMFIHq5nhuKlbq1Wn8ORwtauiPNQrkwKieLIJFXAwVfeUSmyBw14xfOslfJ7TV6vVXc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8855
X-OriginatorOrg: intel.com

Hi Tony,

On 10/7/25 1:47 PM, Luck, Tony wrote:
> On Mon, Oct 06, 2025 at 02:47:15PM -0700, Luck, Tony wrote:
>> On Mon, Oct 06, 2025 at 02:33:00PM -0700, Reinette Chatre wrote:
>>> Hi Tony,
>>>> static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
>>>> 			    unsigned int num_evg)
>>>> {
>>>> 	struct pmt_feature_group *p = intel_pmt_get_regions_by_feature(feature);
>>>> 	struct event_group **peg;
>>>> 	bool ret = false;
>>>>
>>>> 	if (IS_ERR_OR_NULL(p))
>>>> 		return false;
>>>>
>>>> 	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
>>>> 		if (enable_events(*peg, p)) {
>>>> 			kref_get(&p->kref);
>>>
>>> This is not clear to me ... would enable_events() still mark all telemetry_regions
>>> that do not match the event_group's guid as unusable? It seems to me that if more
>>> than one even_group refers to the same pmt_feature_group then the first one to match
>>> will "win" and make the other event_group's telemetry regions unusable.
>>
>> Extra context needed. Sorry.
>>
>> I'm changing enable_events() to only mark telemetry_regions regions as
>> unusable if they have a bad package id, or the MMIO size doesn't match.
>> I.e. they truly are bad.
>>
>> Mis-match on guid will skip then while associating with a specific
>> event_gruoup, but leave them as usable.
>>
>> This means that intel_aet_read_event() now has to check the guid as
>> well as !addr.
>>
>> An alternative approach would be to ask the PMT code for separate
>> copies of the pmt_feature_group to attach to each event_group. I
>> didn't like this, do you think it would be better?
> 
> Working through more patches in the series, I've come to the one
> that adjusts the number of RMIDs.  The alternative approach of

I see, with the number of RMIDs a property of the event group self this
seems reasonable. While there is duplication of pmt_feature_group I am not
able to tell if this is a big issue since I am not clear on how/if systems
will be built this way.

> having a separate copy of the pmt_feature_group is suddently looking
> more attractive.
> 
> So the code would become:
> 
> 
> static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> 			    unsigned int num_evg)
> {
> 	struct pmt_feature_group *p;
> 	struct event_group **peg;
> 	bool ret = false;
> 
> 	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> 		p = intel_pmt_get_regions_by_feature(feature);
> 		if (IS_ERR_OR_NULL(p))
> 			return false;
> 
> 		if (enable_events(*peg, p)) {
> 			(*peg)->pfg = p;
> 			ret = true;
> 		} else {
> 			intel_pmt_put_feature_group(p);
> 		}
> 	}
> 	intel_pmt_put_feature_group(p);

I am not able to tell why this "put" is needed? I assume the "put" of a
pmt_feature_group assigned to an event_group will still be done in
intel_aet_exit()?

Reinette
