Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147A62288D5
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 00:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787014293; cv=fail; b=iTwID78Acr3uAmKIEY+GCL1NxVObDsoVTYikdC2V1VX08R9z3YYa9chY6Y2KB1FosMoC2pHs2U4S4tgoAsghynKW0Qd6lOsFFFZkQ6NnJCpz0B4NaPQIwxZSRn9U8fkwB2y/vEUbJTaCA3+S/ZZk/lZABOZxTlrGhEBlTTsFTAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787014293; c=relaxed/simple;
	bh=mCAKMiUiHPuu2FWWIVn/ygMAkFfc/5uVuG12dwGR9S4=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R3XKcni68T+nZP6c2BLktv9OXr1ZB1k1L4mSfecMyKztImP9gzYAcxlHd3gxYlhW58wlu/+MdA8U+iNUXFttANy0nBuUG+a3ENooIKNeE8RONVgXqaomRB5GZ9YSaRlL/Ufx5S2JVh/Uueop4hw9yjCZRs3cRPrJzvAJCexRsIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kwcNKXfj; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kwcNKXfj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787014292; x=1818550292;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mCAKMiUiHPuu2FWWIVn/ygMAkFfc/5uVuG12dwGR9S4=;
  b=kwcNKXfjGSNgsz3RvEqKiLmoOkYat1Izf8xyORUCa8rYZe+r8P9EcJFe
   NTRVpBc08MFIxs6JyatnFmOg3m1nsOjdZf5IZIohHrg2oCA3tirQmqDKQ
   GHSQleIMKAem3AB5Rc64jTqgh7Z45+i8/ot5gUtiq8U8MFco6mUJBIzFI
   Y0ZE6zydLzf3S5y7n2TJm/HdqRIpMwVjeyBFoS4Im7WVGHXDDfH+CL9hE
   sZGQKsAERkJwOwo9bVrIJpDVNU/+uS1rU8F0O8VkB3Su8Y3yUUwJnBbf3
   xhlWjMuP4YnS1AGvb/6ZZgZ+Dqx0L687VunvxBnIVOT0FAiCeZvdVfNzo
   Q==;
X-CSE-ConnectionGUID: ANhZ3I47Sg6ySGW0a/4xNA==
X-CSE-MsgGUID: XH9DJuP6T2+GT/EyL53Awg==
X-IronPort-AV: E=McAfee;i="6800,10657,11878"; a="98162595"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98162595"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:51:31 -0700
X-CSE-ConnectionGUID: /VEoNoEfQzSLUB5QGiMYJg==
X-CSE-MsgGUID: AaQDzlV+Sa6kj5KIvmDFCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="268904755"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2026 17:51:30 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:51:30 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Mon, 17 Aug 2026 17:51:30 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.43) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 17 Aug 2026 17:51:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bM3UJ+QOEpsVZR3CQVuV/DLcoTY4DWxS3BEmHWKBzdXmR++ZfnBi8xNdaWvhT0OSFLu47SW+gIrPXkXeTk7luVTXoSEBKNfSJR+lFyTXRRE3WcCFd0dSaU6GItH0i4zgyEaX56XX/KdjxP+mFWWa2Ga4lvbYE4KmP2aqIYA1lFT4tu8cwBEhKbVd3x+KTl7gFNa/WmXnXpOoUbpi+g6be/1ql/hNr2CoReGEBCQkDaH5n8+qOEBY2R5ZiTNrIvKaMeDlVHZw/kbOdLwzA2UjoRD1SHkr3lTz+InS+axag2j8kCc8B3QJRV9wpIlcZAiZ5j/KoFjPgpH9wP15tXCcpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cymQ5ugWM3X2IqORWxElK7DtrL9inMpWL8GNbs5Kxik=;
 b=GUAeUfefMuu3eJF8Nzn9Q7X4AMO58lfiYf1qRQiI/9YOnxwYxXh2T0/t8sFBzzV1p5zd3fwsI2dBMhZroc6KDneCFh4JwMG6YIbY1T4myxoxFM9iqHRXMIGJW6QhXVdcyoPbnNJGXmSl/T3lLxew0sAEPPW5z1NfVQNK7qAJAiuRL37485/jheSesyn8WXZnwn9p194/fijLKj2CAXvSJIHWtERAMvNRnV9hI0wMWMySgAsQMiZSUnJUviIQGtcYEC/Jb4OP53qjDNv1G1JXLDUIKoxeX64vR8+8pr+TPrltuNEItCRIx6987mwUFBaoOcMtlHxFM+tN3FNM0OQkHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA7PR11MB9544.namprd11.prod.outlook.com (2603:10b6:806:4cf::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Tue, 18 Aug
 2026 00:51:28 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 00:51:28 +0000
Message-ID: <c96fccab-6c99-49b2-ad1c-d975bcdd6a96@intel.com>
Date: Mon, 17 Aug 2026 17:51:27 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/17] x86/resctrl: Honor rdt=perf option to force
 enable AET perf events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-5-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260729172752.11561-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0008.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::13) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA7PR11MB9544:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dcab3f3-3b8f-487a-ea0a-08defcc2d686
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|23010399003|921020|6133799003|18002099003|22082099003|4143699003|11063799006|56012099006|10067099003|3023799007;
X-Microsoft-Antispam-Message-Info: YO9UO/xdonT2ZkZzf3xNsKUun2mQVxCiHxifm/ND8O2umIeqAMM/OsdBTalSTMDOrO4MgMjLQprXLozH7SDWl+h3MIo4QE8SbLPDFfxdMYEapgop3pwOucDgtpzHtlNZlSLiTj9uAEM1eNxu5Wloaqe0zwk/2jRfXWgbTpQFfhRf8r5QBvdoxC4KR4soaVj3GvUBFClZKiIIHfBYYDlc9B4z3U9jcGb4P7g0egKotdszw3DuM6qMAqKD6zKRxTXxtu03aZLvdXLK+nsfNKVCI7UO5Y5hQCq5e87Egc/X3cdEUAVhc5EGhhzk1OjWs9NcCXDy/Iz8Ku8Cm4Wh54wSD80SrqfroW0zviLWgTv0x16bpU7uE2tK+YCBSo14N2nZICCG9kIg0aEVfFZnpvwEqZ2VIAMQXev+n7OavY0j9vHf8z88/Khh7XvKgZ3ZPUy2Vusxzij/Uk1ZsgLT14q/CQoWSeqIPfLAAvHxj8i4pRvLrW5cW1yKwczzo5/ZRJYPpL5E6TObUDUvrx23lKUwbxsr6qP8zLved3wOO1HKlPD60pkwt4N97M+3fXPq3yH4tKkFx6A0oDaTbfhzQ9nBzfZoMtr4ydE5nPRtVf6Egh1R4XwNUo3j0CPtTlJWNpfdX0iwaqxJNJZt90Pz7fKEJ0y2SWXUGsZPxNcwrNLCtSCV0LuTWLOoPwAah6KAt+M7U4EdEiFuN8xv/WM2V7J40w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(23010399003)(921020)(6133799003)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(10067099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDFoYlVnL003S09ZTlYwV0NpQ3NxWVBNclZDVFYzS1Q3TGhNR1ZMd0sva1Y2?=
 =?utf-8?B?WGlWbGlaUHczZzdQRndDYnkzcG5XWEpUK25DQ1AxVlVDdm9lb2J3Nnl1UmhZ?=
 =?utf-8?B?RDhlTTF2RnB6TjVqRmZPWkpaTHJDZVBaZGZDdlBnbzU0WTNZTVdzVW96MlFU?=
 =?utf-8?B?MXVLKzhML1dvYjhjMmJRZVRVT0F1U1duTWkyYzQvcERLMk9ibTAydTU3NENm?=
 =?utf-8?B?VVgxeCtkYU1FcW1ET2dZY2xycXlVSnZGbW11MXdYTFlYbmU4UzRneFFDTlZs?=
 =?utf-8?B?cEU2NHE2WTlHZmIxclFCMVdKTEkweHU5VXV1M05aY01pMU9wbUx2bnFabTRy?=
 =?utf-8?B?ckl1czR3cGV5ZGsxTHJWbThYK21COURPOGluQ0NHVjRXRG8rbXUxZG4xbnMv?=
 =?utf-8?B?bWJ2b2F1OW1oWkZ1YkVvN1RGRVV0SjVoaWhtVGtVVkwyczVWUEhFdnAzSG1E?=
 =?utf-8?B?dmpQTGZGZDkvL2dpR0dRbFVVdDY4UGZxYUVIRWZDYUdmRW5OdERlTWJHUXVl?=
 =?utf-8?B?VjQxajRCMGtZUmplMU1qcnFXS0t2cUxjc003SjJqV0ZRcFQrTmRDczF2cjZX?=
 =?utf-8?B?czA4N2RhRy8xbVJtYTlXRWU0cGdQc1krVU5jQ2NWQjZZUURyUHA5U09lSFJM?=
 =?utf-8?B?amk4NlVJVGNJTzkwNG1vZDBqMElTY2ZmN1lQTzNkRHhlOEhkUmI5aU1vTGY1?=
 =?utf-8?B?YlN4NnNYMm10a1VsWlpRVkYvZXc1WnRzOVZvZjZNYXR5S3B0TWlHL0VJN3Rt?=
 =?utf-8?B?MFMydVdydmlwTUVQeVMxb2R0M2ttcG1IdzJxSXdvcHVxaWVRL1JXK1V2akJx?=
 =?utf-8?B?TmhIa1FrK2xxaFdHUjFUWDg1OWNLdFk2UGdXWmJuUEVoc3AvWUxVelNhVlE4?=
 =?utf-8?B?cWhYTkN2dWY4LzdOV2RQRkdNdkU0MHhybTRvQ1R6WElDcWpLczNkMVJjZWFM?=
 =?utf-8?B?OHlFUm5FUUdLK0NPelVYdkFDODA2ZVc1QkE5TDFhUU9iT2c3SUhheVZjcFcv?=
 =?utf-8?B?cnFzMjBaYjJhdjh5WWMxNTdrNUxmNTczTmlYQTMzSTN4T3c0Wkx1Q2JySFp3?=
 =?utf-8?B?anlsM3pvbEZQRTgvQlhmMW4wZlRzeWV0VHRiSjFRY0hCTlFaaFBOajFHNFBl?=
 =?utf-8?B?TjU0Qkk2NHI5eW5DdVAyVGkyQ0U1amdLeWZlaXR0M0lpNUdDaVFUWTFlak02?=
 =?utf-8?B?UG9nWlJXWW9pOGtOS2JNQ0VTUkRDa3hhMlNTbStURS8xNm44elRRdlZiYi80?=
 =?utf-8?B?cnBscElzZG5QcTRMOGFLelg0OG5PR3lkUUkvS293UlZBLzVBSi9mWFVkYzFO?=
 =?utf-8?B?T0dGeHE1d2J5RkpVK2ptZnlWRms5NWE5cGV4eElwMThMYUtWTmVoMiszNFRJ?=
 =?utf-8?B?M2Z4Sk4xQ1VicUszZnFDS0FMN2VhTUh0V0VsWmYxYnJjamlXT3NFcHZyZzVr?=
 =?utf-8?B?R1NlVjVibXF1bHVNUHJRRU5VdXQ1WEpLbTJMVEtOYU9wZ29wSmpEb2xlWlh4?=
 =?utf-8?B?aDYrUzZOS1NBTEZQMit3VkVkN2d3SDU1bXppSmROUGk3QURIbzBsRHNoTHVh?=
 =?utf-8?B?UXRsbGdTWVE4TjdNQkQvRVduQUdGbHorRDZHZy9sR0hnUWhEWmJoL2FHZXBC?=
 =?utf-8?B?MlA0MENCZTVCNjZBWEE3NU5KTHhBOUJ4eklMcGh0NGdmcGc2V1lnaWMyVk5L?=
 =?utf-8?B?ZEkwYmtUTHIxSG5uZmF2bEZjdHJHSWViMGhnWGlRU01aODBuU2VlS0FxeUdo?=
 =?utf-8?B?VTF3ZVlNNkkyMUl3UTBjYkoxNE1TV3pYZk5ETnJWdC9PQ01ZMjBidTlTV2dD?=
 =?utf-8?B?aHY1YWtPSUtPaW1zNWdjMG1CS3FzUjBWZjVMcDlnaFJtT1J6VURVK0xUOHQx?=
 =?utf-8?B?b0p4SmhzbzQ4aUFqeVNzNUpwSVRvWHF5TmF3OHlyKzdQcCs3KzEyNXZ1MGlM?=
 =?utf-8?B?YmJubU93TXFoSVBpQU41QkFxTWdWMjdNK2Z5a3FvTW9kaFIxcFl2VHNOUzNF?=
 =?utf-8?B?WHNUTmZZSzkxb25janJlSDJoQ1RkM3J5OStYTGxyeW1iNklGem10WHBnU2xO?=
 =?utf-8?B?OVgvVjgzT0JiRjVDNFFscjRBZGhiaGdHRDl1QkRHSXE1Z0dWYTFSc2QrK1Zv?=
 =?utf-8?B?QUZxNWJXcFBlR1Rhdm5MZ3I0V0JYMktYSE03QlN4UXRCblVZMnVTNWFla3Fm?=
 =?utf-8?B?Mk9HOUUvOWUydWRMVXJVWUVRYWRMNUNDRFJPRWFNTk1JRGZMRktLQjI4dThr?=
 =?utf-8?B?TCtVUnhhMzdycDZET0VBQThvektkdVAwWTJsamNIaWlUZVNTSGdwNHkzNE4x?=
 =?utf-8?B?Um81WEZGNnFmaVJkZlhlNHlvUGRMcGFNSEduOGI2ZHV4TFhZOFFZZkFWK3Jw?=
 =?utf-8?Q?C8uBPFdWV1VH5Hxw=3D?=
X-Exchange-RoutingPolicyChecked: Fzl6g34QDLuobveJnVtlvfY5q1lH3FnwprpCUSq9F0PImxPYXJUCd/Nz7dmBH/YSLoEbDR+KcMFjBP8s0ma3vqH53kWyomnh80rs3KmUSzQuZDxtQKSonIgl3RR1rqzrHsOy/4zPbkDQzbm5zF+FRoLFw2VnDRESCuRObJUNtzq/px++aS2CrpqQ5dXn3S2BjXffZFgd1eSuwordnY4FVnS4zBdI8iahIgK+lWVCTlxXSXL4e08QDtTH6K580kDteG2pNz73lec0ZU9SGWaG1eIMJ4VBLDB9MIRgYTz90x6fom7UHnOEnRrbwXh5l85dKN7uYBI5Ov2afHNbzq+kQg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dcab3f3-3b8f-487a-ea0a-08defcc2d686
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 00:51:28.7724
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n3FYfa98HZnab7qTFCjnKRuf8PjXpoiEphpOTjmF92HlSS1ySFo16/r0k1WjOumgUiykclu9AFvxJZsKSEYuci3X1d2j662TWGIsWI7xc3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA7PR11MB9544
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> resctrl can disable ("force_off") a feature supported by the platform if,
> for example, there is an erratum related to the feature or, in the case of AET
> (Application Energy Telemetry), when the event group has insufficient RMIDs. The
> "rdt=" kernel command line option lets the user override ("force_on") when
> a feature is disabled in such case. Users may also disable ("force_off")
> individual supported resctrl features they do not need.
> 
> Linux enumerates AET once on first mount and skips this enumeration if
> the associated event group is supported but disabled. Since AET is only
> enumerated once, this check is guaranteed to only consider disabling via
> the rdt= kernel parameter.
> 
> However, when transitioning to enumerate AET on every mount, it is no longer
> correct to skip enumeration simply because an event group is marked as
> disabled. It is then possible for resctrl to have force-disabled the event
> group during an earlier enumeration due to insufficient RMIDs, which would
> improperly cause the kernel to ignore a user's explicit rdt= override on
> subsequent mounts.
> 
> Ensure the user's command line choices take precedence over system-level limits.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

