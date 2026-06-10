Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C835299A82
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 23:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781133449; cv=fail; b=u5W/3qUysLa6EibBaYbazm5lE1DPc8E7j3YPPal6oHX69G2b51UDPlCNVmIsd8tkCwMM7rXI1M0LouBPhHMkYzTY5NT95Fudw2weMAVF/bimh1dD1IC8lEvolGJ39QwMQyj1duarAJDlIh7wX0c+9vC+magCOhoechk/3huuZL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781133449; c=relaxed/simple;
	bh=TysNg1fizWz1G4hnKmNT6b5fKZIxvMZqF6uL3FK2XWQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UYCbCQJxcIAzAb2LpJU24C0ZiKuQJoEiaWZGUkbZg2Z0Qd/4DZy7ehFnyJKSS8iHnXhTaSGC6XtOVlizrZxHVS8jyLtg1+nO5veqBmJmGqywJZMx7Qv0ifnQZIsrK+jiokK1l0N5LbMOOfuPUwpnKsx4AkYgGp9xxlDkOsHK3tY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kz4182aY; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kz4182aY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781133448; x=1812669448;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TysNg1fizWz1G4hnKmNT6b5fKZIxvMZqF6uL3FK2XWQ=;
  b=kz4182aYFy5aAZjqGnVlurr4Bchl4w5yzgd7T96/rLjl25d1M7Yo+++b
   fiYEYlPYesPXf+p6KMWVaiDJ6T+KkxZvmRuvv/weyvn4w3fFgjBI4M31n
   HsnX+/VK6AiKer5cME+kw+XmvbBJToxQaAgLcYKYNneUhPe7qCv96NMtX
   wduzXnFOUYpGGwjN+1oec/a3140RvKKVFaRjimeRbwv/AP2fodiTMCzwv
   oc+muI/ei08EifHwgOF17iXH+ETmX/PO/lf2xUI7nn4ffTkOU87ByJVla
   9klZ9fUA3FUuzNF5GALBYR2GzvXhVJ3tXn0eOih/ueWGRdjuNReeo/v9F
   g==;
X-CSE-ConnectionGUID: 81mLhqJKTYesx2vafsdWgQ==
X-CSE-MsgGUID: p42IpSv0SnWtW+AzlBNwEA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81682581"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81682581"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:17:28 -0700
X-CSE-ConnectionGUID: WlvJd3YGS8S8EZjmwQKysQ==
X-CSE-MsgGUID: IgVqLpb1TE+/rW87mIDu/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="270318537"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:17:28 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 16:17:27 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 16:17:27 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.34) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 16:17:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=npFg1gUV8+eiETS6bKHzJnf7hM0ZSXcgcMp7kymEotK/lB0tiMisEy0X2AjDd+2OvR+h/GoAgpX2H8KYU/KyetPUG/MSd5uOSUoTJvGleQmtN3J9Sk4Ii7U5eulVarbRPt586ssGo5CUL8Englof5ozM9FbYtTyKk0/5GfEd5FLGEMcGT3x9a3TVnfKMcmyRrFvOHE4i4dGJNc+2LuxP66pZzSzzYwe/WpLOI1U2ZI3vYcTXWfapcUk93MWmpqGOItJoqB2myaxm0PH5cNLyEgjQjy2jB0FzdfTpbF9Ou/IwtOKIGURKf+0e9Vr3XnmtaWgX7FGJBFZq7DR31ntLUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TysNg1fizWz1G4hnKmNT6b5fKZIxvMZqF6uL3FK2XWQ=;
 b=kW4xWwqg+wNFGPaY5zuc5CdLbhPM9TvegBA9hvOfXmW3yt9M6EyZMockAudMrIpA/1djg1POGRciTJLJe62zwihMX83gNsJSOp1BlBLQBaUdtyMRUSxrMgPjMC0bbZ66LSmAUAKWHYquCec/ozoxAQ4Uz4m7Jek64J5+wF2bR0vwZhrKFD9ueGYMl0/nmEKg9s9C+kSCUy6IeVU2LbR30EANEcSxb/+dLS+Bx8nL462XEhdbNyryRNN/yLm/eqO7b7D/l97YXsGQcJK3BFvkC/+mQxHQAq/wrdcZN6KMi3/aJi0K0yv5TlPvQgxGPt4us3N46M0L4yn4hoB4IYnkbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM3PPFC3F0DB79B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f4a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.113.13; Wed, 10 Jun
 2026 23:17:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 23:17:25 +0000
Message-ID: <946c6a70-0638-41e1-8938-33dcd81c2cbe@intel.com>
Date: Wed, 10 Jun 2026 16:17:22 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <5295a4a6-6652-4f9b-82a9-8310523636b9@intel.com>
 <20260610231028.GFainu5IR4RLvZRg6X@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260610231028.GFainu5IR4RLvZRg6X@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:303:b7::8) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM3PPFC3F0DB79B:EE_
X-MS-Office365-Filtering-Correlation-Id: 4292d9b5-d3fc-4c7c-e7ef-08dec7466e77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|366016|376014|7416014|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: EF74rUzlRsWPgBNi0fyt5EE9/B3WKit93mZGNr5juo32F8Wg0mPCgwC7uQjhLaUeY6QErZxTJ107Y6kSPakoWu067UsP3uBbhBOt5mchGPHN+yYGQLiQ/4L/mVWAiSZyKHD4el7xOh600lZJ0X00W3G0fbdze3zCq3Rz8h670gEdbSycKnAJzOF1rSds4cyxRbUbD7Gu3lUS7NGZ1kPMNNGj27SY3gtkte6oLqbdCgepUkIDG+94EX4bHJ59SsPxk+EUxFynpSaBEKQf9gn2eEGOI6ODWJyI4jYdiy10Up0nMGln+L3YQlRJme0ErgkCs9LMzBTwUdbpVqd5H6b0NaFJTzOffIo6XQLTKn/A0ybNUT+2J0UNSatrH3TuWYWvB/mY+sdMf+Obmc9j/1uhiUkpsikemXzEumBDnpDR0woUhq8JqVExAqlt769nT0DtiMVN4s0Dwa/n/ZUhgn6GzZf/BFWeQ+RMBsMEOgAnHiKtNnYEwuGlH07eSSdUlWZJYZx0l6mPfGQ4O4vXXhzjyCAwL5sUgaWkv09dzyXPhqL9Uzb1Quz+oMVMYR3tLOltyl8dnBs3NlabLw3bGhY6tL0zhzwIHzIPX32nT6AG0bpq/qOoWCg8HwS6Ta8aWCpgKYc1BI2TIiGIHyVPbQxwRfvO5w6IQ3bdJWILv4NChAkIUAJxNUIuh1Q5c/uTXxtc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(366016)(376014)(7416014)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?M1lPT0pnRDF0QnIzcVFTSHpFZTFvdENYTUNScGtNNnFxbFFzNVczY0ZsOFV2?=
 =?utf-8?B?NnNHbTFBNFdCbTVwMlBzallLR3dnUCttVzlsS2RDRUZUVXFSMUQzK1llVVN0?=
 =?utf-8?B?V2RndHJHdllOMVJtaldRNmcweW94V3hONS9aQ3dPV21JQTFKdnFkcGRyN09C?=
 =?utf-8?B?eHAyL0FPaE1pZERoSUUwSER5cUZLYURCeTVqRUxVY3cyeWwyRG02MGtxaVBs?=
 =?utf-8?B?UVRxZ3dkRDZabFFoWExyTGxGNTRNT0tjR0Vmb0ozK0JDNjBYTkYwOXZkbEVq?=
 =?utf-8?B?Vk5HbnptTmRwRjJ5a3BSV3NZcXkvMjI3OHk1VEdhS1l0OGlRcjR5R2FLRkhN?=
 =?utf-8?B?a2NwMm1HRFJQcXk5VUsyLzAvZ0JreFczNmpsZ2tYd0RsK3NiVktGZzBPdTBG?=
 =?utf-8?B?TjFHY25vREc1emZ0Nmdib0VIazNLR2VwUnVSVmdreEhKZ1lraGdzb243dVZL?=
 =?utf-8?B?M0xpbHU5ejZRdUNHTXVodDl4b3ZlYlFHYm8xVUtLVU1KRmhFMDZjNU02YWlO?=
 =?utf-8?B?eTlyZ2pvZ2NiVEJiL3lybWFZYVAzMFVLOUJvZjhmN2dybUw5c25XcDY1ZVdB?=
 =?utf-8?B?cjRJTEVYcnhPS25vOEVQckVQU08wMmJ1RzEzZmxvWktJdWJYSFRoQjRmSnZO?=
 =?utf-8?B?anByblhlUXJxRk5JOXZJOFVDMUYwN1FtNWV3RjhQbklick5aS1hHY1pFYXI1?=
 =?utf-8?B?aVdLcU5NK0syZ1Z2VVhuaThWVkJwNW9EZ0FJNk91YlI3T0RENGpYSzB3NXE3?=
 =?utf-8?B?am5jUjJHd0xHRGQ1dWtnZzE0VkZlMVZYV1UyRTF1Ujl0dUxXZTZNRTdHTUJ0?=
 =?utf-8?B?NldzbUVJTXFuM0NHMXhuYzJ0VUxJWVVOYmN6OStIQmYxUW44eTNGMTJQZ2hu?=
 =?utf-8?B?SGxNai9aYUt4b2s4MzNVWkt1NXdkZlZXSHM5U0ZHVkNHem1TeVJkU3NpdFNX?=
 =?utf-8?B?M2NpeFh5dXdLVzFHQTh6V05iMUhmRXVSQWpvLzRLdzBqT1p5aHAva3FMZWNk?=
 =?utf-8?B?VlRISnhuTTB3R3prWjJlRDYvVTZXb3FSMVpyYTQzak5tVkc0c3Y3dUdTcDlV?=
 =?utf-8?B?UnpJU0tCZ0hzN1hndGRkOTdEdXI3d3A0bFRXL05RKzNqd0tXZ293cE9BWGJE?=
 =?utf-8?B?NFgzQThmN1lRY0l5SHAvTVBKUlYxT1dwbGxuRnVCMXJmOUFxd0hadVFpc2cv?=
 =?utf-8?B?cDNEVG9QR1gzMXp0cjRmRCtLK0RLdW9jVmlhUTI5Y3JUa2NjaDZSNit5Ui84?=
 =?utf-8?B?ZklTdTRjUFJmTWttQk1DZGh3YWpVcERCcmwySkpIQWZkMEwyUHN2S3I3T0lu?=
 =?utf-8?B?MENTc01YZUpXMTdWM0NFU1RzWHY0YU5oVWJYNnZwYkhjU2tZR2UzdVJjQmcw?=
 =?utf-8?B?aHh6ekxvSFY4Z1Jja0RUaXN3YVNSKy85V3lQOEpmNFNNUFVoajRnQjNDR2Iz?=
 =?utf-8?B?OUhGODN1RmVNZk5TdW1SQXMyVWd1dFFBUi9LbHBLM1RRTnAybGlyWSt4dXE2?=
 =?utf-8?B?ck0vTW9kazdaMVZPU0QyeXlLLzBnYnpaWDBBSGdiTTRmSGp6OHR4UFM2Q2tt?=
 =?utf-8?B?aUc3NkI4cVlWTlhGSjd3bklrY1ZLaUJKN0hXa0FLMmY3N2RRUHc0eVlXazRD?=
 =?utf-8?B?Q2tSNy8xYjdpb3ZhdlBramxkbk5iVkRzSG4rNERLREE5MXExTzYySW5zQmdZ?=
 =?utf-8?B?RytYeGwwYjhvV2ZHcG5RRXphcDRNeEt0R0xZR1Q3clVxM2FZS3ZqQ29VQ0dF?=
 =?utf-8?B?NWpUU25YQlR1cW0rUXNUQjZUMU0vbmRIV1Vta1lLQURMbGRtYlBMNGhyVHdl?=
 =?utf-8?B?enYxQVk2OWtjb0VRUUdaMG03Qmh4T1psSmxJTUNuRVZBak9jbmFRTXZVbFcz?=
 =?utf-8?B?RDFqSzArV0tvZEJtWkpYYnV2SHpnaFNISDJzQ3c1T21LYVJYUHJXYjVNMkRv?=
 =?utf-8?B?S1pIK2VVZU1Na25GL0pTYnBjbjBYWVNNbzRsVDB4N3F4d0ZiMGdQMlNxRzJm?=
 =?utf-8?B?WWkwc3RvV080UDljZm9yQWNoNHdTd2EvZ0wvUXZTWjBUMUlyeGV6cHgyY01R?=
 =?utf-8?B?WHBWNi9iSXhOaFFraDlnWUJSWHloV3Y1ZGZMSEhtcVlyL09qY1NOMi9FWDhB?=
 =?utf-8?B?SkJsS0xQUDhCNTVCQ2p1VWsrT1Y5eldUV0V3eDdhOGJrcTZZdE9qVGlKdU55?=
 =?utf-8?B?Nks3cFVHdmU4Q0o0Nk1PUEJQc2s1QnAwcVJSQnpsZk42cW5qQllYK2Q2eCt4?=
 =?utf-8?B?b3BLTG40WTlpMGU2VVNoRHBLZ29YNFl3SmllbU5ZT1dUTHlvdk40TmNkZThJ?=
 =?utf-8?B?TnRkWkV6YVM2TUh0V0tLRUtRcktmejRHR0FyQjkyZ2dNSitRY0NWUmFsVTEy?=
 =?utf-8?Q?OPEaizd+rAgDlNXg=3D?=
X-Exchange-RoutingPolicyChecked: JvnELXKxAY7svYVvlAUUpX04XCOyLzkLzbnB1caD3rsUjpFJq/cf7+waf5rL6ANkSrYTKqHboFfYFcc4pd0JLz627Th6p6kIsB+Yjgt293J71K/5OSKFLHmWCUHkBQPoAM8PbqBw4vO3OmnYlqEGQ2ZOx01FdqWKpsTeBSP90NxRBJO0TNr52fTXbKIog4gbJlNlhFqqn16QP2VIU4PGPUVS4o6+DVCrU5o4y10iiB3RLZlA1fvnmiVUOzv4xvaP390MRjPvnG1+8N5Qj5/BpcbOWxGSPOP667i3GK9ixqlzQ87zB3pJMekrL1OIiiViFORfw1y1FaJFmhyA6KpbEQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4292d9b5-d3fc-4c7c-e7ef-08dec7466e77
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 23:17:24.9560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o40fUEtyKIfkYldEJd/XMqZudWIPD1sZx5wc04IJdNsOm8hiS8N+j7IbvpZelDbps8oO4L7f2sErPsCusN0rcvDGUAe7+uS6l8wRRidayFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3F0DB79B
X-OriginatorOrg: intel.com



On 6/10/26 4:10 PM, Borislav Petkov wrote:
> All good. I think in a couple of weeks, when we have -rc1, I can queue yours
> and then they'll get the longest exposure in linux-next so that should be
> good testing.

That would be great. Thank you very much Boris.

Reinette
