Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C1333FE1F
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 15:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781105244; cv=fail; b=l4ZtFz7FH2cjnxyqHh6ZEztl6l5B9P6Rs/XUNxjyVzhoTAryZ4aBgWFKFWqIRUV8WpKdeQo7HrVEVDJLVhFcRa1HLfcm+AMo8UsrNI2+9ctQZwPA6FVZqlqXK3nZpzPZwUauSqvFFlIMtsoeniIrcfFIbJdmQsSLIf0bLPXGLTU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781105244; c=relaxed/simple;
	bh=JP6yyi5WpTDP/wNB8FgQq1zOkOyWVWG0T9lRtVOJmKU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=sYXsh46j3mqrnN0Wh2Jij895SN6CgL1fVovWM5UmJCvIuaqlyL32sGyL2TyiBEDU8dmdrWbYuVAY30uJDuRteX5f0EphVUUGuUtKZOMFAu2xDl7hO2VgtalB1WZWGNW+GTqeFPJJ/oUB26M6wyrFdcV5htJjYN4bJT6lSrJc9FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IzYapde4; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IzYapde4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781105243; x=1812641243;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JP6yyi5WpTDP/wNB8FgQq1zOkOyWVWG0T9lRtVOJmKU=;
  b=IzYapde4ggHPwVQ3VxO1njghKe/EYej31Mt5PRArA19BNUiPqexK+01T
   EnAGARHSebhIbgLOr68qwfW1FKV83LBjkNS98Xv4foTVM/lcxGAYgHtMc
   9c2YWmaI7w+TrEOjdI2SYCmJr3dq2tBRqMIg/cI096RKnDsL4oVaXfGJC
   Af7EHSpk4vQQPBjHJL6Y7E9QxFaK6HjebTZREy2/tYNtWwou6YLcf/VdX
   1t2IyL6+oMndloBRrLBAHmk6Y4rM7P/y7rAA/yL2ypx+nnh9BR9g8oyx6
   HAqW0XG74sPQfVlvaya4eP0rACgpEZGdj9y8CL7vCdkI1ouhVfoa5l6b2
   g==;
X-CSE-ConnectionGUID: kafYXYYBR0qKfpG2R+pXJg==
X-CSE-MsgGUID: 8oL9JdkfRbaL+imhuDcXNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81877378"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81877378"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 08:27:22 -0700
X-CSE-ConnectionGUID: vXM/SQgHQzKFLJTSTPuloA==
X-CSE-MsgGUID: REIPIouSTaebpZRqoiklLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="276398028"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 08:27:22 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 08:27:21 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 08:27:21 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.57) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 08:27:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BFvSZTF2WE6T0JYVA1fOCoUGXf7JKUgk94GFdOJcS3tuhNdky0m0nxIUbm9qVHdg0I6C2czaWVZC7Uvv97QT+wxWpAHlhylPlWC68gCOH07p+0nFIZiJ9MXMl1WTMwrAJUlESZyiP2EYdrAixQmy/U43b5/iI3lmm/bGYSifPMsV1XDHa/b4SeYqLy+7PlucsdMuhgVO+BOLIlEkV9ZVOZJLT/D/41YXttCroDE1Vp100dC8NgtnbXmdfdFOYtS+VdV09ByyuLqyPfeviCSrC99I97sI3nojnwuBII5JfUHArqGvxvNld2cb8xRb75oiUekCZZaVGQaYdQftau1KKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YPujtgrlc20q2VYLL1xZRAoit443Sw4cedl15S4DUo=;
 b=DittQA7jbnFEiAkOfMXmsQN0XoJ1d8dwd1sQmLHRt8xGT6GqFPaDiuJWbchzLn1m//C7i3zRxTTIEeCD+AzF8MKPP00yNMG0rErEyT3QiyQbCaGHpNQF+A9qdUnm3aHqkiPpMm9+nwvrL/yGzD+hbAv8cJ8LqnOcLsxKR8pZAt+UPkeHff7GWvmQZ9XY8gi8VX6hhg8GXrxr5FXTh9o9QB+5HgiSzTdWcBfopX7P7jlZkyGAh0nB9MZCE0PjXwnm26gYX7GUyUzlAjU+kuFdRkdW3+ImedouPVASRO2vauICyqj1dIEC1s+xaUwqE8TTVrQ2nAiWT8d2r+uvBXjT3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH0PR11MB4870.namprd11.prod.outlook.com (2603:10b6:510:34::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.14; Wed, 10 Jun
 2026 15:27:18 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 15:27:18 +0000
Message-ID: <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
Date: Wed, 10 Jun 2026 08:27:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <aiiq55x6fs2ddS91@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0236.namprd03.prod.outlook.com
 (2603:10b6:303:b9::31) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH0PR11MB4870:EE_
X-MS-Office365-Filtering-Correlation-Id: 23202872-09d1-4ad0-cf6c-08dec704c1d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|7416014|376014|6133799003|22082099003|18002099003|11063799006|5023799004|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: ZdjsgA3DQ45wDMPLdICdx5DLpkfxzrQO1Om0M81U2aN1iRhckD6akRn/BqaWfbcXgdMG5ioll9Po7ItqtTYDJZiXxVjJHBIiGJ4G5NJoHVQnFZouv3R9RDnXy7YK2QgEcaOZ8ebNmUwsNm0u7Fj2o4CHX3ExRvRjzP2hsnTCCPQYZWpv1Z/kvEvQ4vv2nFzlpMyaJrei2b0ID3rAtFIz+cl4m1EJtc4Nubo8X+u5x1xen+z6zESZbT4Eu8X7RddvoRYsSmsN0tmDB+3sKOAIqFQzzyeLxJDoDaquKhxx6FthR0QxCr4JeqI/bQrRUqrJe2DWRfYQ5Qo9jmGLMH3LSJ9z4sDUX1v9fOo/9XJHDOEqqln9kKGGN+bQX1QVCVZ52HDy0WhlyG4qluIKcSNIjPlsMbIhPbNpy+iRHPRBTKyEs5W4W6yk3POIAsWufLfseF5fAuKwd9Jy/5ph5fKA7HTFX/0zdtBiAmixDKvy+OInPWJYV1hYUcH7pKG3/0oUNC+fE+E7jLb/1IwjpX90+GsgJW+qYX6wiXLVjNAZBIUMVuT0dOeSXte0s3EA/9whJYu8RXwWkx6YOjF1sUefv5k4RVS1NEaVlwzgyjZ8h7CdbZkwe3bsD7b04oTI70hCetZKSYTSwyQyOmEU8LW0947EYAgW9n5BSzy8pjkT9jJzDiOSxVjLYxS+QgD+wZHi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(7416014)(376014)(6133799003)(22082099003)(18002099003)(11063799006)(5023799004)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UUtxb1RIQXhqK0pGWXM3ZjJsVzNxNlJtZlNPc1N1MmhLTHNqQkZOYVYrWHhO?=
 =?utf-8?B?bHlCRGk1cGVyZk1ZYXBKeHBOSGNhQm5XcUFkNmVOaWI3M2xiN05VeHNtSGVR?=
 =?utf-8?B?WTRkbjI1aWRBQlljZ0pZNkpnWmw5aVJHQlpBQ3BVUWppaFhkMHVCSStzNUha?=
 =?utf-8?B?cjl5ekZDTkRGaXZCVnB3TnMxd2JydlFyWUNhRlZ4endjcklVUUNaWlpMMHVu?=
 =?utf-8?B?Ujd1MXpNTmkvUVFsVlpvOTJVTVpZUk9lZGI5SHBrWjFoekY1RW9FWlY3YmFk?=
 =?utf-8?B?a2t1MEpBNUhHYlJrOTF2N2R3dnc4dEtwa1JCcmxqNnRZbFQ1QisyVjlRbDU2?=
 =?utf-8?B?clFKajQ2R2FQMVF2elQ4V2t1MDFtQXNaZTgwM09pcGFKanp3WE94UjhQanZM?=
 =?utf-8?B?ZVkxOWdRc2kvbUdWME15dC8vY3U4a0diRVJ4dWt3MVYzZTRxdlFBNHNNb0RB?=
 =?utf-8?B?UGlCc0RMVGpyOE8ydTNCYzhJNUdYd3ZMMDZXN2lYdHNmNVFYTFd3R2tUbk9j?=
 =?utf-8?B?dTBxTHRDRDd5Q3FDZTNlTS9NVFA3cngrNnFuZ3BhUFQ2enE2bTZNWjM4NTda?=
 =?utf-8?B?d1hrMXVtRHNkaUpUVjhibVVxWGtUMG1wRzVSUElkMGpnanRFZWYvSU5XWFhI?=
 =?utf-8?B?d3gyZmNFSnlYbkhNUWMybUp0ZmcrWm1YeUZFVnJwd2lDZjBsM2N6cHlEWEVB?=
 =?utf-8?B?Rm41c2UxNDZ5Wkw1U1FoUkFtRWdkSFZ6c2Y1Tkt6NnVhQS9uRm9FSExFR0pn?=
 =?utf-8?B?RHgveUJUVm41cnVXR05ZYk0ycmZ6VTdFbFpNNVF2ZFZuMGdVQW9vbzVVRyt5?=
 =?utf-8?B?M1NPaU51YmFvenJtVDVOQWNaOHJ1ZWh4VVdzZGtrNWNMUlBpbFdnRTlPTGQz?=
 =?utf-8?B?WDFGOHZ3ME1WM0Q3ckU0T0hBaVBrU3dpeEpaR0htdDludE9lcGFOcDVqcGlE?=
 =?utf-8?B?eUNnZXRmK1dvMnNIRUMzL2t0MjZZL29xYUhGKzhHV2xyMWlTc3FNTXdIZEli?=
 =?utf-8?B?QnhQME9tQ1dhQVpWUFBiakFkN1hWcnhVR1VtTGdtVllIcXc4OEQ1d1QxMDBN?=
 =?utf-8?B?c3owc2g2YVVNRHhIU3hVU2RLUjdHalVYazJaWU5RR1pETjhsQmIzUWpHaGEz?=
 =?utf-8?B?L01FOU51YS96ZnVlV0VYaE1MVlNVa3pDdGpORjFPT0xkS0V1aEt0QjZDVUo1?=
 =?utf-8?B?Sk4rVlZyYnRYL0JydVFWdEF5VUxKZlhpOUFOTUlONjBJMWZIZnJIa2kzZzJz?=
 =?utf-8?B?a09iY3Z4M3h5UWV5SEluVGRldWFPQk9WdWttbWpwZlU4R3ZHUG5iekVPdzJl?=
 =?utf-8?B?ZkNnUzVwSTdzS1hqeGcxc2JucWRRTUNWUHFIK2NwNW9reXU1OU5SdDdVZVZB?=
 =?utf-8?B?ODVsd2Q0UHJ4dE5HRjFmNXEweHdla3hLYVN2NHVHdmUvZCtXdTg1UWYzOWZO?=
 =?utf-8?B?cDN0dk1rbDVJMUFJWEpUc2s3RklHK294b3hOSkVzVUdxSnlEMUMvRU5hZ0J2?=
 =?utf-8?B?anJmTzBUakU3TjFIdGNCa2xxVStoUjBJc1p6N1BhWEc1WEhHaW5CNmw1MXRQ?=
 =?utf-8?B?L2NMMm9tM0lzOSs4RlkyaHJUOEZGSXlxTHpVWC81dXZxSTg3MFJpZHBVS3Ar?=
 =?utf-8?B?MFdzb2NKcmdlYTcrR0FUWmYzbVhKay9EeXBwOWdDUTRXZERNRUdYc1ZTRkhi?=
 =?utf-8?B?TFV6UlpzQ1NBSVJFOUFkVVJEUWM0ZnY0OXdEVy9IY1ZsNnpSTkR0dWN5SXdM?=
 =?utf-8?B?eUJET3dyak1tbDA5VlJuUUkzUEJKc2tCNzI0RmpvaU1rWHlBbUpRK0NYRDhL?=
 =?utf-8?B?L2piZzUyclRzSUNCWTdsL3Z2UCtJVEQrdnF0by9HS1pYN1A5ZVR5akx1SXkw?=
 =?utf-8?B?Yk5yRm9nRnVKcXdySjd2aEpTcXlCOVQybkg5VVJvaUR1SDFHVml4RlZxalBv?=
 =?utf-8?B?UFdrRjhlTVJ0WDFtOGVlR0YrN0J3SWFYRnNUeU1MZXRxNUxBQy9GSDFXM2Q0?=
 =?utf-8?B?QVFwUGE1akpiYzM3akhsN3labnRvd1RxMklka1k2UWFZdjloaXkydkNEQzk5?=
 =?utf-8?B?Y2ltV3VlQWRPd2ZTZmozSEtCeUVKUEdwOE44dGh4OC9EZ3VMbWJ4QnkwRngr?=
 =?utf-8?B?a09SRFc5M2ZEU09MRmlRdFE1WHNWWHc2MEhKWDhybkdDZ0dmczh2dkVYLzQ3?=
 =?utf-8?B?RXlzai9ualVOWTl1aW04cTdZcmhVTnplaDYxSXNRWm53WnRKWnpRelVnOVpR?=
 =?utf-8?B?S1dMTEVHZHZtcVBPYlhXM2lWcG1CenpYUHRYSW40eXp3bzVjMWtRNzAvY0FB?=
 =?utf-8?B?ejdEQXJwWmM1UHJOZ29EUEFWSnhUUVJhQ1ZmcG94bzN1YlNZd1JFbjdUSFd4?=
 =?utf-8?Q?Z0K/kPSF+SPF9X+A=3D?=
X-Exchange-RoutingPolicyChecked: YiUjEGt3NfgIn0aSu2l6UGjsChGk/9rv0JEYJwEfqz0CxzBkgQ9PSA4PoC4nQZ5jGZMzpQVd72kUIEd9+6W8OizrUnO/fgq2eBxFC770xXn3BSlskabf4vQ6r0GSalnz2rzhfTH2cYVHT6QKsBbpuGK/xKmlrCpKAdYReOoxVHU7UaKyUIlmM7jykwSmC9XvVJhXxqrMVrTO7rt0ogDi0HPPLcorsyOwgYoobUD70X/p2kD6J4bDUQgU6WnjFr+typ5pZcx/X6RpvYxYgctjQCdRHdCnJnJQO1AbTt0KkHfJ0Fmg94mAtAIK//a1vqeW6xQHhjkSIUkuAsx9ArqHQA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 23202872-09d1-4ad0-cf6c-08dec704c1d1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 15:27:18.1842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WzAq1ld7C/sPcjl0BH4S8FZGZcoo4AxD429GGrPQCauOzxRdy6rUaFWS0x9Zc1m5jKar8moq51wdO20NGkImaIu4NKXdBm5GrE9RuXJ0wAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4870
X-OriginatorOrg: intel.com

Hi Tony,

On 6/9/26 5:08 PM, Luck, Tony wrote:
> On Mon, Jun 08, 2026 at 04:25:51PM -0700, Reinette Chatre wrote:


>>> instead of direct link-time references to PMT symbols.
>>>
>>> Prepare for the file system to call resctrl_arch_pre_mount() on every mount
>>> by moving AET enumeration into resctrl_arch_pre_mount() and cleanup into
>>> resctrl_arch_unmount(). This allows the PMT module to be unloaded whenever
>>> the filesystem is not mounted.
>>>
>>> Remove intel_aet_exit because all cleanup now happens in the unmount path.
>>>
>>> Note that the Linux file system code does not serialize calls to
>>> fs_context_operations::get_tree(), so there may be arbitrarily many
>>> parallel calls if users invoke mount(2) multiple times.
>>>
>>> Add locking and state (resctrl_arch_mount_entries) to avoid repeated
>>> enumeration on nested mount requests from file system code (which will be
>>> failed with -EBUSY status).
>>>
>>> event_group::num_rmid may be reset (reduced) during enumeration. This is
>>> not worth resetting on unmount because the same reduction would occur on
>>> each subsequent mount.
>>
>> Even more important to ensure that PMT is done with its enumeration when
>> AET enumeration starts?
> 
> Would be nice, but I still don't know a way to make that happen.

Could it help to have AET depends on PMT probe being complete?

...

>>> +void intel_aet_unmount(void)
>>>  {
>>>  	struct event_group **peg;
>>>  
>>> +	guard(mutex)(&aet_register_lock);
>>
>> Could this get a short-circuit to make behavior on AMD obvious?
> 
> Like this?
> 
> 	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
> 		return;
> 
> Same in intel_aet_pre_mount() for symmetry??

I do not see that this requires to be architecture specific. This capability
introduces AET register()/unregister() and pre_mount()/unmount().
pre_mount() already does no-op if (essentially) nothing is registered. Could
unmount() similarly be a no-op if (essentially) nothing is registered?

Reinette
