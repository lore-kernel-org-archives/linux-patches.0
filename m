Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A4443ABC
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919041; cv=fail; b=bvzfIqTvotqgbc9hY8yZXlt5wL36FcBhdMf8abdAcwaGLhN0r4hoskPJV/A9q58jmyLrEv8MsSnBcTEk2jIx6MivybAua+UUZoSjKb0Mx/y8ED6T7UvOTLY87+9p7wgm1D9PasTO5W+2yZdFIdB08xNvgNw1pxcMhXDMhpEBymc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919041; c=relaxed/simple;
	bh=50/x2NkilVKQKz0ohoM3EYzXr/AsYuTwZjZo9GaqE/k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Xg8Aqe8C5PmJFbVZmLrL0rv/mxtcO+Wrt3H7e97r5u8M1+skpOEeQTQcfSNoSAMrN+lpSS+JBPPbZpuXUjtsnIYSqmoglTH+8GKLOg4De7mbvOQ/aejpXqjxZTCL0UsM+1roBQ/NGRNqOwMPzxQ9JZfpbzTftxT14zn8vwDIL6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZyxOKcR9; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZyxOKcR9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718919039; x=1750455039;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=50/x2NkilVKQKz0ohoM3EYzXr/AsYuTwZjZo9GaqE/k=;
  b=ZyxOKcR94ntlKUtjSSZhLxGYljzOrvS38GOhU30rTS6NSteICs/xgVyX
   ZilSgs4gY4s5yR/T5wKQaGhXHs/5zvqa/+zdCbWDrEKZJzM0Ld1L7VN2/
   5s5Dq0jDFx6ic0o9hzAWUD4TSAfiGC+Pk2QmEeG92PaSx9bfSAC/z7g9N
   77oaiWbd7pjxbNoYZj7j4AwLD1OZhpoy08aqWCRtsvfYibirEkQcW9IbI
   VuTnpHANv9GbVM9c4O5sWy71+ltPirvP0sDuWcGBlBJVlsNesV8q9jcUp
   pC67cyicYqMMmpfpwjEZ2/SqJtXav+ppA6zAeLwY8y9kOq+4XuUomOJ+S
   A==;
X-CSE-ConnectionGUID: NLE0SoscTjmQtr1LNLfQ5A==
X-CSE-MsgGUID: qcAzDMvAQNOcN5lZA1SZcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16163689"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16163689"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:30:38 -0700
X-CSE-ConnectionGUID: K1htfI6xQhW059GjaWocGg==
X-CSE-MsgGUID: PIedVy4QQnGrcp0aStWSnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="65624490"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:30:38 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:30:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:30:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:30:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EiCgnqNeH9KABfMYfwm35BsNP1PqpD2/svprM1Zxy5xfhpAdHvhuWsBipjs1dZEDu+b9OuCnTZ8dwyLMLW3Arw/1CBmGugMx9W7m4EU38oNX2Ykvlw/sq1UnEgODTdLwhyXQCEX2YoXEtNq9yLZiToFFTtuMiWUeJtnutlJaUvmECP9rolEpRhFIaLgV8FbiaPCYKjL/EySqroQf75UoFAFk1AtQP/y+/qHBkI8EZ6DjsjEuiV4rTMAzmL1k6tH+jzttCyRknOEug6rn5NYe1rNQo1AT8G/Pde7mTc8IvnYt5ZoMwCVJL8BNvXa9HMUwPyJeVJ49lVglf5dfkVrlfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ngbq/0U2ratn7D+VTobag8xMdsmFDlI1De20JT9GQew=;
 b=PVcqWPojfHdaALKKeTm1qMo4ze48sgFFfIloLiidbh/RYXJzSGUGsrGpmP/gCqFlalL2omddcO2hT5PSk/LmOZ02KR5AKH9DfWUIziVd3sIG23EsATSg7GHkvN88dpHBsA6XqNpoy8YzwhLgyQodca4NZynr5XD01Ruxo2UDPMmNmq7Jd4k0x0ZShe54+u02hFkpKbZiue29xd3CU54rrEwG5b1q7OkitSZs9APq+qNR0lvS5qLrPneFV/8+RScN0iwLkEZn6Q7x271n+hmsSDjXluRr8lAsZpVVg2g20PU8kooWe187NKyt+xsOoHSlZqwjhq/t+ULZ2KSvkb0ovQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5200.namprd11.prod.outlook.com (2603:10b6:a03:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:30:36 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:30:36 +0000
Message-ID: <b00fb8d5-d440-4020-8f26-a4c25e00a379@intel.com>
Date: Thu, 20 Jun 2024 14:30:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 13/18] x86/resctrl: Handle removing directories in
 Sub-NUMA Cluster (SNC) mode
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-14-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-14-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0027.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e98ad5a-870c-4aab-0eba-08dc91703910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|376011|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eWtBZW5ueU9YQTBQWmpHVnZMQ3lxVW5UVWpNOThxNThublJrL1F3TnQ4dVYy?=
 =?utf-8?B?TmRXYzRxSEF0WTBsT1JoeDl6V3loM2lLWkFlNTdQYWVWN2oxVWFGb21mVlJy?=
 =?utf-8?B?RTNPc2ZNU2lVaWRxS1hpQzdsQWUyUUJBTmNNdTQ1N0ErOHBWZ2QzNDhlVldJ?=
 =?utf-8?B?OGpLWEwxZlE3ZlZ5WDR5OEFZM1RZcWRka1E5RWd4UkpBSUszRGREUnBiSExN?=
 =?utf-8?B?SElVTmFWSDJXMEF1VGt4VUJZNVQ5dGNiZ0lQczdJWmVUdDFIZHMycjVWcGpx?=
 =?utf-8?B?cnQvQlR2NmtTS2ZjVjdvbXBOZFl3TklTQTJYdTBnNlJlbEh0T1ZzQU56a010?=
 =?utf-8?B?WW1vUmYxOURvem5BQWpFcDRta3pPTFF0ZytWZWUwZnVQOTRDTWFVb0cvczZL?=
 =?utf-8?B?S2cyM3hLNStRb0dhSjJHcFMyM2dsK3Fma2xrYTNvMFFESmFSVWdaVmx4MWVz?=
 =?utf-8?B?amFLMDNobnRuZVhhNTI3Z25ZaENUMlZuYUJMN3lyYUJkNmJNQnZVUnRQcE9T?=
 =?utf-8?B?eWJZdkRMcHA3cEdPR3VUM2hXWmVXOFNkRUxhbnl4N2FMMDIxcEY0dTZ4Q3hR?=
 =?utf-8?B?K0hsNTdzdDNDcVNQVW8xM3dzWWYvKzltYm0zb1hoWnNHUjZMajNsUEVXeEdw?=
 =?utf-8?B?aHp3NHJIdWJsRzZLUStRUFpsWUZJanN5c3ZRNlRGd2JtOUsrMU80K0UzRnN4?=
 =?utf-8?B?OXl6UUE0L29oR3F0N2huQjZMMkE1OGxjeEIxeUt6bXpCQjhYclpQdURmNXpO?=
 =?utf-8?B?czJJTFNxMDkxSHRwMlFIT2hYbUIrSi9VQkZDWU1PeEtpOW95QlROQnUrRDJM?=
 =?utf-8?B?NnlXbXpZakNhU3FmeDZmYitKZUtZU1RMczladWJJNmpqMlFldGJqWmZMZ2V2?=
 =?utf-8?B?MzBCcTh5aTluME1KY1l6MUZGTHNqa1l2WUVlZVNzUFRoUGZaVUdQQ1owZExv?=
 =?utf-8?B?R2ZHNFdsMjlaaXJ3dldFakFtNWFwb2tXdnBoOE9qNk5SdGovOGZKQ01WNmEz?=
 =?utf-8?B?Mm45cEh3UmtrcE4yTDZEYm5xTHpPMjByOWM1aGJtOWE0SFNSaCtCcWJyQzNF?=
 =?utf-8?B?bjVEYnVUblNseDc0UFFzckhKcE0vcVN6ZUdSdE8wcGdaYjQ5VGtyaGVybGVh?=
 =?utf-8?B?WEZFZk9lUW9HUUxQNUFSTG5NV3ZZQWRBQ1dSNFpVRVluNUt1VEVtZms1Q0NW?=
 =?utf-8?B?RTZWbjlpcEpabnE5N2liemkwUmFuVXV4amFSQnl3ajBCZk0vdEVwcVVXZG92?=
 =?utf-8?B?dGt0MnkwcTJSSy80c0JyMkNBNEVZS21NRUlMbmFkTDFaS1dmNi85ZjNpbWtM?=
 =?utf-8?B?dnY3OTFzU0dreFRyWFB6aXJtY29EdVZrZHM2NkJDODB0c2x6Z3ZCL1hPMjRR?=
 =?utf-8?B?Q2phWWwveGVmeUhtL0NGZjRCMmg4ZXBLd3NiSytsUHBrQWNkWnJWOUJQS2V3?=
 =?utf-8?B?ZWRqTHB0TG5UYzhRR0d0eGd6VlhYZ2p3eUt5cVR6blJsS2w3RU1kZDh4RnpV?=
 =?utf-8?B?NWx6azd4RlRMZ2MrM25sYXNsWi8vUUpqUFFPaVhqMGNOTFM1VHNTUFBNQVNF?=
 =?utf-8?B?UDd5NnV5NG9rOHFYaWFJcGt6dTZXKzBBWjh3UEdGMVo3elRCV2tPRm03Zm9C?=
 =?utf-8?B?UFUrZzlJVmlveHBvUm0rS2lNSUM3VENReEhTenMrcTJZays1U3Vabko0Q2tq?=
 =?utf-8?B?cFZPbGlVUTVJZmk3UTdBS3o2MUdib0Q5aEtXY0NwUDdudzJlc3g4MjRCV0tU?=
 =?utf-8?Q?aClJ7st+3RrkL4sb5nfp7iGDUDeUmDo2mLECJqD?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(376011)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S3ZEQWZVdG5TUHBXKzRsbW9ha1VGS1dVWWZ6REt4QUYrelh0a21nTHlRaU1M?=
 =?utf-8?B?dnVzY1hOdXlIQnowd1MrS3RObS9aenB5NHMybU4zdUEvOVZwSUJOak5nTDVp?=
 =?utf-8?B?dzBQUGN4UGx5cHNhdFB2SlhlKzJ4ZFdRTzJNdmlCenVFSlhFaGMwWmhWeHVG?=
 =?utf-8?B?MFBOZElFN01xMXArcTV2WVpoUnNuSVJGSUhnMVM3Y3ozU1BDN0N2ZWtPc0tD?=
 =?utf-8?B?dWxJQzQyYjRJVzVQOHY3R1B0MnlwNnRYYmxFVWt1ZVowQzRvQ1NqMHpTZ0xH?=
 =?utf-8?B?OThQRXNoKzBBaGlzaGlvcHNOQit4WTlnbGF2ekJOeWRkS3dNMmRKWUJxK0xo?=
 =?utf-8?B?WE80M1BOR2wvTEpwVVdWcnFUSlRtL3hiWEpSWnRTdC9ubnUrbW4xZlFNRGlL?=
 =?utf-8?B?S0hBMnY0akh3cUZmVjVxeGdRVlVRMWd4M3REYXZrUEszbTBneEhWRU4zSGc5?=
 =?utf-8?B?dzV6Uis5UG9kWDFzOUhqZTJJNm9zVEVaU1h1ekk4S1lNQ2RKbTFBWkE5elR4?=
 =?utf-8?B?byt1b3BWYjErNFROSnFGY3pkMjhKam1iT1VjcjZzdy9kYzM5NXlYdVpmYWlr?=
 =?utf-8?B?b3MvYlZtaTBYcHp2NnVGNEJkVWF2SktWTTRSdExPZkJCaFdwOGM2alRBTHVL?=
 =?utf-8?B?T05MTU1IVzhYdy9ubmpBYmRwVk1DMnRjeDNIckZBZVluNktBRlBSeWg2WWpx?=
 =?utf-8?B?N0hpZTlNY08ra3NXeDdOOW11Tm9md1Eva0dScDE0K3lEZCt2MndQTHpPeVhZ?=
 =?utf-8?B?LzVDcWltS3lNNE0vM3RyZVhHSXpUZFROMDA4VGRyajJZOTBSREJqd1ZsblUx?=
 =?utf-8?B?dDFhMkU0T3lJcm9OOVdyVTNId0VhZkkwc216Nit6cTM5Z3p6NlZrK0YxM3d5?=
 =?utf-8?B?V1NmWUQydi9KaG1IOXE2WUI3OHFUa3VidmNob3lzOER6SHlUVHlCRVJqMTVJ?=
 =?utf-8?B?ajROemtLNCtUTFNLY0d3QWlINk1VdnVRQTh5RDNBTU0zcWRHamFNZnNUbVUz?=
 =?utf-8?B?Wnh5Rkh0THBEeTZ2aExuNUlqVUtUWG5VMGVrRXJPWGVSQWJPYzlaYlRmV05V?=
 =?utf-8?B?Ym11dFRtR0R4QU9CTzdScVRWU05CRXRWYm05K3VzT09QdzFrY2kwZmxwbVVB?=
 =?utf-8?B?djRkYnhNZGVEL2VhbWgyYjRIUlJlWWswZlo0WjF4Ly9ZSXJscW9pSWxtdFdI?=
 =?utf-8?B?VmxzZ2RpYlNpOWQ2M2tTOExaOHlMSHcwTUpReXBPZCt4T3czNFpyWUdzQWkv?=
 =?utf-8?B?Q3pRQTNDbTNaYjczY0ZMR3E4WW0rRzJaZHcyUUN1Q05XTCttOFNrR1pKYkhN?=
 =?utf-8?B?WVVEWS9kVVU4eWllTC9lSThidFNnMWtwL0ZST2s5MTJsd3ZmRlE2QVQ4b2ll?=
 =?utf-8?B?ckp3VDhzb0JWRHNhTEcwd3lQZGlNcGdhNWtTaTdDcisyb3R3WTZWVUxOcW45?=
 =?utf-8?B?RTB6cTUrMmMrZUhTR1kxczZNQmI3b3JZVm5OZTV4dTRaUjFwTEpWZmsweFVN?=
 =?utf-8?B?QW4wVzVrcEljSjJNQnJTdC81bW1reFVHOG1wQzJuNmZHdXhLMlI2RzBGMWlR?=
 =?utf-8?B?UzJPZE5hOHBMd21kWjBZWUFURHZ5azRlMEpzbjVURHU5SWE3RVZ0UXpKdjFn?=
 =?utf-8?B?YnFCWmRPWGxVZWJOWFpvYVRUOU9LVmswV0pNdFZwVHZLUzV2N0ZlVXoxcTNR?=
 =?utf-8?B?V3F5S0VKUlBwVzQzWnA3WDVNRlpvdkxZVUVmR3ZwRW9GbkdMeUNSdEsza28z?=
 =?utf-8?B?T0UyWHdNclVzdHErRTlSbURqaUxBSW1UNHNhbEhLVG9neVFVNkZUaXM0TU9y?=
 =?utf-8?B?MlJ5aUhLRHdmbjJLTXV6eTNBLzgxZGpzL0JKajErc0VsQ2t6dWVaS28zcmhK?=
 =?utf-8?B?bS9hRE9PU2plSW5IMU01VnpYdzN1MXdFQlFuR0xybUtZaGI1cTJiV2ZmdE9s?=
 =?utf-8?B?bG9GdXREUEZNdjZabjBhYTlDNlI1dlF3bTF6Y2JrNUZCalpQbUVTdUFvTENn?=
 =?utf-8?B?ckNMenJReXlPZlNrU1pkWU1FQVMxWWRSbGNlRzdldW54QTk5cDM4QUs1NUNR?=
 =?utf-8?B?aFFSeWJYeC9qL0lDdUczT3lHL21SbEExL2xPcWliczNoMkVtZ0VRLzNoajF6?=
 =?utf-8?B?Ui9yYm5SWnFnTHBWUFlQNk9yK2NYWkduMkhlOEE5NmtVOFF1dFZPV2w0Umt0?=
 =?utf-8?B?ZXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e98ad5a-870c-4aab-0eba-08dc91703910
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:30:36.0822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j3zjoJQkS4oP8A87W8hsml4cABmtdPaZWFCjbm4LUR4aBQiPaMbspYykMziLS5L/dR0zhCxQk210WTxIrJU8AFR5978JVKs+9Nd4Vwa4tWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5200
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> In SNC mode there are multiple subdirectories in each L3 level monitor
> directory (one for each SNC node). If all the CPUs in an SNC node are
> taken offline, just remove the SNC  directory for that node. In

(nit: watch for random extra spaces)

> non-SNC mode, or when the last SNC node directory is removed, also
> remove the L3 monitor directory.

Perhaps drop the "also" since it is not relevant to non-SNC mode?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 41 +++++++++++++++++++++-----
>   1 file changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index fc7f3f139800..5142ce43ac13 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3004,20 +3004,47 @@ static int mon_addfile(struct kernfs_node *parent_kn, const char *name,
>   
>   /*
>    * Remove all subdirectories of mon_data of ctrl_mon groups
> - * and monitor groups with given domain id.
> + * and monitor groups for the given domain.
>    */
>   static void rmdir_mondata_subdir_allrdtgrp(struct rdt_resource *r,
> -					   unsigned int dom_id)
> +					   struct rdt_mon_domain *d)
>   {
>   	struct rdtgroup *prgrp, *crgrp;
> +	struct kernfs_node *kn;
> +	char subname[32];
>   	char name[32];
>   
> +	sprintf(name, "mon_%s_%02d", r->name, d->ci->id);
> +	if (r->mon_scope != RESCTRL_L3_CACHE) {

Same comments about positive check and subtle assignment as in previous
patch.

> +		/*
> +		 * SNC mode: Unless the last domain is being removed must
> +		 * just remove the SNC subdomain.
> +		 */

Can this comment be moved to be part of the top function comments? It is
not relevant to code being commented here and only seems to be here to
avoid duplicating it in the spots where it is relevant.

> +		sprintf(subname, "mon_sub_%s_%02d", r->name, d->hdr.id);
> +	}
> +

Reinette
