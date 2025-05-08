Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FEB3C17
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675447; cv=fail; b=d3hlJ1RZCRziWajIbcBb9RydWiAeUd31nqr2hMefgxS1y05/lSE1sIyCd0rAA+l/K37L7sNBDEQq/ZfVw56WFp2f3uJZL+DCU+MS7xrU8m5RwIqSbvdpXonAdsMJTmuzxarYieWxpRuf3i2tS5aircee/BXCAVZYWwrz7/q6FdQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675447; c=relaxed/simple;
	bh=pWl7WAWI+z1S7h4MECYBD3/idoIGAfc/doBlWSHnWYw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kumhQ2P6y7ZJFVcmHOd3/DPP5okgbLXgz+iWSziJJUGYpsj9FBZQhTgnodZzr0sXfxpDrg3WXtFuNfDRcV5+pUwL9+MzudueafEp6qvEQfv0INXeBkFENRok9hEjEt1NVnp6MN7YR2Hd4WVhR11luVrDojpFKD22BRKFJ0HbJuk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Awj+X/2v; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Awj+X/2v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675447; x=1778211447;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pWl7WAWI+z1S7h4MECYBD3/idoIGAfc/doBlWSHnWYw=;
  b=Awj+X/2vs2q83m9uQSlNLfGr3CJ75ctz5GWRmptlqdUIEE02R0h0Egi3
   Mxmn3sRieaKPmk+erMqGLgX8i6S81ipfFNC1t9nAAIxGeh8oq3rC6FDBP
   9zYdJu6+bs4mTDA9vfssObNs9UCXFFyozsqf8jIlSr6xBXIT5e2rI/caI
   QxVbYDN1FVcfYw9eyQ6EzEl3O07L0SEmTAwl96FBm33kUG4oCwYGOKoQG
   PC+cjx2O2h2nq9AD5g0YlZ8YqfYLIBbgRXkSQQkdEtDN6fHuii/W1+yTT
   WJUEhCH1xQ21klUE0g7j00hhxZnJyZl0VNh535u1KQH93Tw2QgTK43Nuj
   A==;
X-CSE-ConnectionGUID: BbRMrPm6TJ2juUJumoaI1A==
X-CSE-MsgGUID: /QuAmUjnRsuNo140T+mRqA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="58638261"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="58638261"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:37:25 -0700
X-CSE-ConnectionGUID: neUY98gyQGGbTB1L87a/XQ==
X-CSE-MsgGUID: B74cdB12Q8q5yU7jcs7vwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="136116894"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:37:24 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:37:23 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:37:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:37:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JmzY4ISJwQmoKKWwFwlqEilz2f9xkC9cPBdigpyn+pA8i7Cx/YXUKrxgJ5WNWu7RkX6FVC5o63suefIUYP3w0yr77AnpC1kqfNn+mt5qBpqgg4Du2zpc8fwOb57J0Xc3YQYpm8LTnlfzXGOx9mgJaH1PAcCxrMkCi0xD5jmrUh29MZ/lyyXwu4aYXEoeK+6RvK5OjCCy+eRBc6t32vGKjNX4gcN/V00OnGOvVO6pIys96+dUZOmgi3Zdnos5NC26Hux1LHb7UDw9YLmK8fAOaXhdK9b/gAyyMt11wPPfnxxGMyLqUElHgNVHUQq8hOFT9HFSi+4x582//B4uMjwrtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DLuVCQWsg07lRkbqRMkoOpS5fAFz8HRvzNRFl1WcwJs=;
 b=SJ40pj3DEhr0/ZIjDYgy+XJ0AiRluRP/Uj00HY8HmSKyLrG7l1m9j10krLOEahYVuqu7IUjxGhAf9sX7n6Rv6EwgA7o49rfgPJoT5QZwDPJ5Drj8loM2O4gCt+z9/sLUa9KsTWJDgApVpmy4khqxODXdBzUzuLbU4/DTAW1HhaM1QrIVk/HNphjVmCAEPnnlq9TEMH9LBkCOYI1EyEKkK8d9SxKo6WMIVbQlnBNYDmYFerLIPFieXQ+JDxtoPAwyE3IerdjgzHtCT0Gu1qtY0u8oeCm99YAY6+gIJn40F83MpItBfmAGkCO//lKYlMYr+vRHraQ8ghNDvAeEDe8sGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB7151.namprd11.prod.outlook.com (2603:10b6:303:220::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Thu, 8 May
 2025 03:37:12 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:37:11 +0000
Message-ID: <35bd96ef-db73-4ab5-a904-e91777c2a5f2@intel.com>
Date: Wed, 7 May 2025 20:37:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/31] x86/resctrl: Move L3 initialization out of
 domain_add_cpu_mon()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-9-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0038.namprd07.prod.outlook.com
 (2603:10b6:a03:60::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 0005717b-93bb-4a05-475a-08dd8de19e2d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MUFjUS8yWStXUjZJMUJaKytvL2ZseWoySENDTyt2NDNmN3g5RzlMZi9mNWNP?=
 =?utf-8?B?S3M3UitOc05tdHNIN0l2dC8vbC8weHZYSFdwTjlPS29YeVZnZDJNYjlqRzV5?=
 =?utf-8?B?RFo0V1ltcHd2WTlOUnpkTGl0MXBMOWZqV3BMR0oyek0ram15a0V3NHR3ZTJ3?=
 =?utf-8?B?aXd3emJPdTR5N3ltcmg2RGpwUk51b0pteHArVlFWMjIvaEEySlRHNk5ubzFs?=
 =?utf-8?B?blNFVkp2bEM2WDZ1YXNLMTFtQ09JcWY4MXlGenlnQmdhL3RYZGFvV0thSmZu?=
 =?utf-8?B?R3NxREd3QVBEU2hDc3lLVWhTVTY3aldnYTkrUWs0aXJJTVdlaXdzZ3lzUmxv?=
 =?utf-8?B?QmRSQU1nTDdETk9jMFdMYWJId1ZyTlR6bG1FVFlLZ2hDc1JKeEZUVUFidFVt?=
 =?utf-8?B?M0R6RlpDbEtHc0hDSmdGSUd1aEczbnAxRjMvSEdueVdDdXVCdjZra1JkN1Yv?=
 =?utf-8?B?N0FkQ3dRZmVKRlJ4eWdLcDlKVDRxcHluSVJqUWtiN0t4QW1YWW5PR3N1dUVp?=
 =?utf-8?B?R3dOT0wzRVRBNXV3QlVqbHk2aS81UnNWN2tHbmF3bVcwY1JlNDlScTV6bDl4?=
 =?utf-8?B?ZndzVHZTRUZ0K3JDUXp3bHY5bW9Fd2NqVkVFamMwQlVndmNtUHlkVVlZSGZl?=
 =?utf-8?B?N05KcXZGclJqcVEvS1RwRVE2Y2tXbUNWdXV2cXNGaFZqWlowcnNRK3pzc2w5?=
 =?utf-8?B?RjBpc29waTI0dHFXdG5iaHJpK2hNTnVjdXRiRVVHcXkxNytKTGFOT1hSRk1n?=
 =?utf-8?B?RU02YTdLVWh0bFJqd3lKWUFwZFY1OVd3SzJzajBtQUd2NEQ1NmFIN0JOcEg4?=
 =?utf-8?B?L2xOMzZTUURsRlFkQjlEVTRlMXcvWFN4ellrN2FNYXJDWmd1QkdBOWRPNTFo?=
 =?utf-8?B?djNGR1BwYTVCeTFMTDQ0bWxJeWwwblRQMFh5c2JjeE1rbS80ODRCb2VFMENQ?=
 =?utf-8?B?VXU4TUVkbDV1ZHh5WnRSMytLMXQxMlNqaEF0cmErajNjN0FXdENFY01CT2Yr?=
 =?utf-8?B?OW9wb2VtbTFhUll2ZUxpbGxibEVib2ptZTNycHlXbTZCbXNmZk01QjZiRzl3?=
 =?utf-8?B?RThDTHBvSTk5ei9aWUVkRy93OS9HdzdVNUR1Tlk4c2lqMXE4NXQxWmpaeHV2?=
 =?utf-8?B?aS9OZGQ4RkkwS1V2TWdNeXRycjJhMGNhNnRWTnNHTWpXZUdDNXQvdk1BTmdR?=
 =?utf-8?B?SDZHM1k0czY5RVh5cmRYV3cveDNFeURuUjdDOFROOXRGcWJyeGo1UERXV1VC?=
 =?utf-8?B?UVkzZmZEcVZGdS9QajByQUZ0MzVRNG1NR3VoelhzWGlmRU1WNU5sRTQvd2VD?=
 =?utf-8?B?a1J3VW55TllJakNFL3JiOXkrWHhDUlJGdjVJRnRqQkZrMnRxdm5ocHNxY1RY?=
 =?utf-8?B?Ymc2U3lVcXgxOVVhRmw4VUFFT2ZGRHNJS2FhVVkyaFdabmhkR2hvTWJqSWJo?=
 =?utf-8?B?MmZiREpUU21nM0RFSDF0SlJncTFkRWdmUDdla2lRL2k3aDdNVFUvcHd0YXZF?=
 =?utf-8?B?VHZHaDBidU9lSFMvdFdDenVNa01IYnluQlB3RWtRdmN2YTdJL2Z1UUk3MWxB?=
 =?utf-8?B?aEQxU1FtT24vMTkvU3FUeXhaK1NqRGhmeDRseTVxd05YVm9XeS92dWVoZWtB?=
 =?utf-8?B?RkNMR1k5cWVPZ0dMbGthU0J1eENXZ3daU09UZVhONU8zdmN3ZHQ0YVRMLzZE?=
 =?utf-8?B?M1VwaWtxMXR0SG83Lzl1YmdjcVJWbUMyaVN3eVgzOWhndTZUdkxtTTQvOUF4?=
 =?utf-8?B?ZS93VGNHc1R0WGE1Z3orZktHekRYWHJqWkY1dXBJb3d3R3B0KzRiYW4wSmVa?=
 =?utf-8?B?MmEwQUZReEEvcU9zbTRWeVp1UnA2aXI1c2l4TnZYenFIK1JGKzU4bVBSQjhH?=
 =?utf-8?B?SWdxM3NheUdrMFNvYzhRMitKODFoNGljcFNZSFFma0JSdk1idUZjNE1IQ0lC?=
 =?utf-8?B?dzZ4MTlzN21mcDF4ZEN4ejFHSzFydVJCaVhQa1kzYjExT3o5K3pibmtBVkQ2?=
 =?utf-8?B?ZHNieC9Yai9BPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YVduQjJtanR2OTNXMGpKZFdtWG9BUmMwLzV3MlUxSm42OFdWS0d1c28xbHJI?=
 =?utf-8?B?QWFRY0JoMTZGeDRwS2Zkc1NwbTFydlB6YThGcmdneUthTkJsZU53OSt0WW83?=
 =?utf-8?B?bmdkNGV3T0JwbEI4Z0xSenVnbXBmU1RQNG8yTFVhYW5PaWJNR0YzUHBiQzh3?=
 =?utf-8?B?QVlVZGNKa1p3VmExM09Ram4zeHczV1hMby9mb050Q05HTHZTWVRQbk1NKzZY?=
 =?utf-8?B?UE1kTFpqeVRnckRSRE5uTUVNSXRmM0w5dEhTbHhvbjRDOEpFSmlqa2JnMXd4?=
 =?utf-8?B?WHhyTHB3b2ZSdVBzSjdtbG92ZUs3aDAzREdDbS9naHVlQlpFVkFpN2xRS2xK?=
 =?utf-8?B?WFdhQ2xBTi9NZ09IYnVIMFllcDlzVkYyd2tWOTVrRjJYTUl5ZmNCNjE2dmtu?=
 =?utf-8?B?T2dRMmxJazhXRnJmN3NlQmlUeVFIYTF0dGhkT3dkd1NxSDhYbytMQzk0QVR2?=
 =?utf-8?B?U0ZVYVdIWVM0clExYUhnZHFvVkg3enVhcE45bjdQUUVpOUxDUUNDOHZRbytw?=
 =?utf-8?B?WC9jOEpkZ2tLNWRneFdQOUE4T0dUanpyQ2F3NXZidzBwa3lOcDkzY2FSMVAv?=
 =?utf-8?B?WTdRcW90VmZ0Vng4VjlDT1EzVkpjSnpIZHphNzMrakhTVlMyNnJSTDkxS1hz?=
 =?utf-8?B?Yzd5dnkyREtqRWFENVh5WUJzNmZzaWtVREZreVNiZUZhN0V0bURxS01iY3dz?=
 =?utf-8?B?bXIwbHpqQjhGK0hGRHZqOGp2M2xmRHRkdUE1MnFhMiszMUhRd2RySm9rZS9m?=
 =?utf-8?B?OVZ2WXZOUWNRTGZwWU1pcFA0SXI4TjNVT1ZCM3RrOFU4bWxmOVlsNXgvMmt3?=
 =?utf-8?B?U3FENnBpRmZsNForTDRuVWpFRGdZdVNaQndmaDdrVnFQcm11enJpa0p5Slk1?=
 =?utf-8?B?cDFqbTJKV1ovdU5VZDNvWWsySnFSZ3NqM2VsWFprdHJtUUdYb04xaDFNUTBp?=
 =?utf-8?B?TmYrd2xvN2orKzRNaDVEVnVTUVJQMVpvUHhYUU1WdVpmeW9WVjlReW5vbmpJ?=
 =?utf-8?B?OFV1MTZuQmM2V0Fsb0tLcE1XU0JsdW5HSmQ5UTVHandNMTlTMkxHbFM1QzBh?=
 =?utf-8?B?ZEhHQzJ1Q2thenczTFlCZ0hYM3lsT2NkV2ZZWVc2QmFnVU5kdVJCWUQ0RlE2?=
 =?utf-8?B?Wnp2ZkNWNGRVN01IVWphNnVsODBWV08zRnJFOHlPTDdUUlZFaWpNM1ZTdVlh?=
 =?utf-8?B?VjlKdjE5ZUZ1eFE2YzdydXVMdXJMVmhXbWNDUjZJQ1JtZUVNb1lGc1JGVG1v?=
 =?utf-8?B?OTdHVFgxaW1Edzhjc0Y5VmdHTG9HUklCSkpMOFFsd3BzY0tzd3kvazNMNHVa?=
 =?utf-8?B?UHBHUUJ5T3c2K0daeDBVQ3B4NktwMGpxbjg1Z3RUMThpY1VwMkU3NGVtSDUr?=
 =?utf-8?B?MlhObmIxWU5VamV1MFJEc0lwMWJhWk1lK0lYWjJLc256QXJMUndBWGpmeVhk?=
 =?utf-8?B?eDlIaWcxL29WaHFhTVVJTFAyUGd6Vmp2VFJQdWJmcU9lV1NPUDkwYXJBNDBj?=
 =?utf-8?B?WkpSbHg2UysxMUNlY3UvcDlzaEFRQndzVlN6amZyMjJRWjhtYkxxZU56M1Fh?=
 =?utf-8?B?ejMweldqc3FSMWhaUHdhYy9rd2tXREpzTmhXdUtxN2g4NUF0ODJSQ1daanZo?=
 =?utf-8?B?Q1A1QnhMRzN1L0E5dHZqc1IzWWU5WVVNbHdyK2d4a3pyTjEzUG5BaWliNVdV?=
 =?utf-8?B?ckdEZVpaanJMemRUOXNFSGQ2Wk5xVWxFby9HWnUyOUtKeCsydkhVQnMyZkVK?=
 =?utf-8?B?OFlXQXh3UlhqWStpT2p2MXNiSWFQOGY1d0VPalFpMEZ1RWpkRUVNZVFuRTc1?=
 =?utf-8?B?Q3FtaGlpUHB5ejc0aHJhenFYM0dBSk5IdDBMWWRGMjhZYjZQL2dFUHBBZHg1?=
 =?utf-8?B?Y1c3dDlZS3hMZ05VRmhsSDUvTjhVUktMMEJndnhJcCtOeWR4MlZYQ21MQUg3?=
 =?utf-8?B?NlZWSXRTSWFyS1pGS2E0VjArNVVpekRHSGFsN2hCcjlCOEgwMEpPWXllNGtE?=
 =?utf-8?B?KzNPNzgvY2ZUdTJzcWdNY0F3NTFGcXRvYTV5SlEwU0wrc0lENDh1MWZHQ05O?=
 =?utf-8?B?OEp3MHJjUzV0V0FPREZXUHNRZytsMnMzeTVCa0VLUnZpcmc5SW02ZVF1amE4?=
 =?utf-8?B?TCtCcDZrNk1qNjlHMzhxeWxNcFdjSVRQZWZNNHBFS2gvdVRHRDJVSXVkcDla?=
 =?utf-8?B?eEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0005717b-93bb-4a05-475a-08dd8de19e2d
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:37:11.8597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VS9XoVVIlZn2qsE+H05xrrBM/CuhNaSvSZl+t3J8E2TCCelLvwe8hLsR6BDYod1+yPJwduLyjCG2orP61k8aHP8KZ2rICyg1n1Q3fmS4pDo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7151
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> To prepare for additional types of monitoring domains, move all the
> L3 specific initialization into a helper function.

Please make this specific. "L3 specific initialization" covers quite a
bit ... from the L3 resource control and monitoring enumeration done in
arch code to the per domain initialization done during CPU online for
control and monitoring. Small change like "L3 resource monitoring domain
initialization" would already be more descriptive, but please feel free
to improve.

> 
> Rename several functions to mark that they are specific to the L3 path.
> 
> arch_mon_domain_online	-> arch_l3_mon_domain_online
> mon_domain_free		-> free_l3_mon_domain

Wouldn't "l3_mon_domain_free()" be better match for the "online" variant?

I think it will be helpful to reviewer to mention that the new
"helper function" is named setup_l3_mon_domain() (l3_mon_domain_setup()?)
and is the partner of the renamed "free" function.

> arch_mon_domain_online	-> arch_l3_mon_domain_online
duplicate

> domain_setup_mon_state	-> domain_setup_l3_mon_state

See "Function references in changelogs" in 
Documentation/process/maintainer-tip.rst

> 
> resctrl_online_mon_domain() is going to share some code with new
> reources, so keeps the same name, but include a check for

reources -> resources
keeps -> keep


> RDT_RESOURCE_L3.

Reinette

