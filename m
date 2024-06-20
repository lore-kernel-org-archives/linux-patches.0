Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760CF3307B
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918572; cv=fail; b=gnFTtFc1JmCWdxXuP85CRTzYU9Zr1ke77guWHO4DaDuGxurd4ajZJDlkdgDTcoykOO+Xami0VKt5whDXovf8gBW+wsUjVvEKe9lvR8u0C/+uEr/5J7Z4hNxteGCxaCJE8T13ysAR7xFAPeBwupwz65vr8HcLsbEAyYN0c+fDdbQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918572; c=relaxed/simple;
	bh=0YfGl2Y5IQOl5Jjzi42X/G4b5SqbJr3S9zSk51xZolg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CTue3JqgigMAhi5yZ9ayZ4eCONxsbpTNAcrw/TIJkkHZtkex8JW0I4IxaYFt1nJpM/8GNS8MXij2s2ks74QqFzlvobiRYyVSqYAxLuV2VulDpPnrgG7vrHzONZAQRkur5fIUr9OvLxgC337MlcnMQBsrC5DcBPIVxocn/gDfEsU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cxdkbs72; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cxdkbs72"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918570; x=1750454570;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0YfGl2Y5IQOl5Jjzi42X/G4b5SqbJr3S9zSk51xZolg=;
  b=cxdkbs726hX3HMYwVFXs92+uIjta/qP9y0f4oXLo3Z8YEGpTJLQnBkNM
   tKtJGVj/M2x6de7q7dvFmMcUYBZHCTh4X6ulsVA/FMfFzOOHeYc6EAPMt
   ApdEVS8HYPGVGEKF4FwPYfTBdJcP/goEIM+y8gsFqMPl/65YI2sqXRS1K
   u2axFGaY9O0EMXk252HgETd7BFXhGCN06VfdBPqmL5ULTk4XoJnGVHMY0
   t+1i76wNOlWgvBhjHFGhrkYCrL1llTusCCPJ7JBYyCY1GPrtMN7yUbxfl
   dIdyrVU0a22IVbouQZXBssc8BdSTGHyM+0fnMLdwrw1ybUpBgibCskKK5
   A==;
X-CSE-ConnectionGUID: aa3pZTQASjaq02KHpOLNHA==
X-CSE-MsgGUID: gPbc7nc8SmGtikgRH2bDsA==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="16044414"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="16044414"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:22:50 -0700
X-CSE-ConnectionGUID: s/KuHA09TriOgLDloQuxHQ==
X-CSE-MsgGUID: 5hKsDufoQxi95fqWSyI80w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="43058432"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:22:50 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:22:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:22:49 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:22:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gilcDc740tMac8kJdEnl4Lopn+yWGMCnEqGjobCW/4583QHp+LZTRrMtno5OfS6r8Tr7QaLazJ7S8xM6zIOv2CWcT7EQIt+9lMBlvBNVWe5LfID20kTbbRD746bhfBsS0N49mEE2YSJBHb/R8K0pFQ8x9Dctw6aoGzzVmHOkK2JiuVIgIlym7gptOljzw78NwzKRXb1VJRCLOErhihEs6lgTrImPHNF3BtiSzWikZxPb4O+Ond06Kp+FdZi4pqZLaT6qRv2m0ZZlpcEoznRXQLo3kg19G1Ea/ypqoxEj0cj9LuGsq4wZDl1MyqEumoXT1DazzIZ2FaVBdZ+Nmfuxdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oQc/RLsFOqO4lnoVj5HQTOXRaf0ZLLifDq2uEZnasJ4=;
 b=aC0YNYULiELDOYy5SP2c/eFTihmrOHE4jZ/EfAUIvOpoZRay4qLPBU3Ufh4KdcSdKxLD6tmRa9sAiVa+Gs2X9nV96eJtcpHkN2a8G94dKmnmW9hvVdJpMtZcYcp2tkT9n6E+lLNVRtX0VSEHYnPD/Hz+avd5xxBPkISTkdhsfBnGmELfWBoryARz+52+VKd8FLkunPzNBQQmRhVRCPoj+8UFKw1GH6MnWb3bBdEzFqJ5pQqu1+ZtWMChNXvt5ZBobXvI3CSONoujLyOc3S6nm95+YmuCic4lXCVEMvgqROX4rDSTm0fy9sNJOai+2dOejirf3FpVz3RddJzW3QwslA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW4PR11MB5911.namprd11.prod.outlook.com (2603:10b6:303:16b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.21; Thu, 20 Jun
 2024 21:22:46 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:22:46 +0000
Message-ID: <1bba8391-6ee3-48aa-935f-b9c08bee049b@intel.com>
Date: Thu, 20 Jun 2024 14:22:43 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 09/18] x86/resctrl: Add a new field to struct
 rmid_read for summation of domains
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-10-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-10-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR2101CA0030.namprd21.prod.outlook.com
 (2603:10b6:302:1::43) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW4PR11MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: aee8c881-42a4-474f-6cb0-08dc916f215f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|376011|1800799021|366013;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MjFZQWJwZ2QrZ2JWQW5iQzU3R0Qra01oVzJiUzl1OGJvQ0pXLzZaWmkrZmRF?=
 =?utf-8?B?U2E0ODdEUVZ5eURkR0Y5UU5EVWovM2VVbloyajJZSFBjS1loMThndTVEUHNx?=
 =?utf-8?B?OUF6eC9idzNmRHY1cDRaVmdhUEh4YUpndmM4Z1BoWXRNOER0Ky8yOWRjMUo1?=
 =?utf-8?B?d0xOZHAyQ0xTaGg0dHJ5bmFJYy9PVXZZanZGSmEybHFsbVhQMnlycGp2QWtw?=
 =?utf-8?B?WHpHVTVSbERKTW5Dbi9vS3k2U3BocEhTOUJoeXJsWjMwNXhxRVMvNm9NVS9t?=
 =?utf-8?B?V0RhNE1TSkZSZUpCVW5kc3F3YjZ4TTA5dEZGRGNSQWJ5YW5TTXBPaGUwVG9y?=
 =?utf-8?B?QVd2VDQzalpwUUwwNTdwb0h5eGliVmV3WUpoVWlkcFRtS3A3b3hKbzFJTDha?=
 =?utf-8?B?SXRJYnJxcGhuRFR4KzN5WGRrcmZnVzB6MDFELzlBYWF2WUoxWi9mOUNwS0M2?=
 =?utf-8?B?TEpKUVFTZ08ySktZR3Z4M0FBNTI3cmo2NUpuOGVoNWZJcENVTEp5N09oSU9k?=
 =?utf-8?B?MjF5SW51NEo4ZkhRVS80MU1GV3VRUFNmblR0ZlJveExUNkM1aE9wVkFKaVVO?=
 =?utf-8?B?R3VFVVpIOGRlZFVTY0pNV1JTaEhYT3hUbTI2Yzdlb1RyT3V1MXpEcXhOUWpK?=
 =?utf-8?B?bzB1Sk5uVUpkRG1seGlLVWQ1bUdycnRlRWZEUGZxWDZPQWZKL2NYc1dFLzhp?=
 =?utf-8?B?dnZOZHd0ODJ1S1djNkxQMEN4T3JNK1hYVXBocEJtU01PNmVWUVI1NFlrdUF0?=
 =?utf-8?B?c2xJSkQ0S2d1S2UwNysrVGdWUDVqTGI1Q3BaM3dYQ2NOU295N2pWMmFHUEt3?=
 =?utf-8?B?RFRacks3Wkd4TjgxejVFN2xNUlgwczk1NWJORXZxWklaSzlBSWp2T3o2ZVd0?=
 =?utf-8?B?NkpialRwZmdDN1dNOXZiWS9UYWkyZm1QcGJmU0ZuTUxjcEJjcjFyejcrbElG?=
 =?utf-8?B?azlrQk1oVGk1WmJnN2xaVzJXQlp0UzczWnlCbzVSYjQwelZ5eEFYcS9BS2hn?=
 =?utf-8?B?dDNKKzQ5dGFVcG9Bb1RlK1V3RVdEcVlBQkc5d09Jc2x1eVFaSUVqTUNiQUN5?=
 =?utf-8?B?WE4ydXhackZmZ1YrVDBRSXJQZGJqNkRYWmlwR0I1UnduNUhwb2ZVaVVrc01i?=
 =?utf-8?B?T2d0T2s1MkVUVlNVMTFOdEZXTGxmYmdhNTZIajZKRDB5dFNjNDBoVmtZN2ho?=
 =?utf-8?B?Yk8vN0J2YmFZalo2aytqbjBxM1VjdVBuemtyUHlLS3M1ZElLL0EzS09pOHlx?=
 =?utf-8?B?bXpiTHVyYVdTQklaMnR4Mk94bmwxaUdxRFF0cGNESGIvWC95M05vNzFPNFF6?=
 =?utf-8?B?U0RTTDRhYnRYRjBNYXVQSUExeGpUOG1sL2NhdnhjOWJxWEZEbFhKTEpBNlBX?=
 =?utf-8?B?TUF3L0hNSzRKeUtZWXd6OHA5YVpQZmFxOUFXLzFJWnlkcTVnV0ZLaGlWTHd1?=
 =?utf-8?B?VVZpeENkWHp1WWxKQURGY3drOWF4b3pSNllsYkdPVTdrRU1Ndmo5RHdrN2FU?=
 =?utf-8?B?N243WTZDc3RWMnlUanREcU9mL2RRc3d3a1NLZXFPSjB2QzZKeVlLVG9CSnJG?=
 =?utf-8?B?eVdiN1FHWlI4S0RzbG9CNTE5aVFqenF5aHEvdjhwUE1yY0R5OFFaOU9Ecldw?=
 =?utf-8?B?QWFvL3M1U01saWRjeFM5LzZhSCt1L1VEaVFvM29nUTJETk45bnFzcVlBVVRK?=
 =?utf-8?B?U1JTT2k1YXJyNHorREx0SXNNaXJteGNNUTE3blc1NnMxRFNhaEVXekVmOWJ4?=
 =?utf-8?Q?f+hG+OwXtfP1IDBa1NZ7AL0ss60CJiS1epys/0T?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(376011)(1800799021)(366013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b3VZYnRDamRjYjFxcVVLcmJUUFJ3WjJCdk15azJQbW12VmN4b0ZmYXBXWFds?=
 =?utf-8?B?d3ROWmlxVDZOQ1NMcERqVDRLTHg4OGNLUVc3MWxwUmlHa1ViYU9yS2ZrM0U1?=
 =?utf-8?B?VXMveW5NTkRTNGxDQUI2cmRJRTQyUmgzcHpDWWxjMDUvZzF3Tzk4Z0dWWFNs?=
 =?utf-8?B?bWZzeFhBcW5ET2ZKclhaT0ZWVUFRaUdFRlcvRnErWWp1N09PVWF0U2tKRGlB?=
 =?utf-8?B?R3hwSGVVaE16V0ZnbG9Pb0pXdHFpY3RsK2h5QXpsemNUMFlsM2xORnVhTXNw?=
 =?utf-8?B?R0ZqbnVUTkZvajQ4WjgxeFNod09tUTNoYTBSSmtjZFB4ZmluNXN6K2J4TVFH?=
 =?utf-8?B?QUxCS21obkFmdUNubWpHVzkxcXkrQThpTHpPeWRkczYvMEJiZllmb0xJQ2JK?=
 =?utf-8?B?YWlsaldSK0VseldFTithOU9OQ3BLTU0wMlIzWlhqendUbFNNc0RhblNEdE5N?=
 =?utf-8?B?Z2QrajRnaEFReWgxZDFJSEUvTlJqS1J6VGxEN3VuOW5YMHlHQTZKOXdtL3Y0?=
 =?utf-8?B?UUxleHJQL2diMnVtYS8wSkFiMUltT2xNUEhKVVc2Yzh5TFFKelN5NHBLOVVE?=
 =?utf-8?B?N282WkZwVkUvR2NxWHZvYUJzMTdyUG9jbkZrWnlzMDdkK2IwWWtQQ2ZQeFJz?=
 =?utf-8?B?Vi84dEs1RU5zV0tPWkxCZFNTMTlRQ29qVnBDRytZS255SjdqN3VDSHBONWdx?=
 =?utf-8?B?WkxhS3M5M2hVZVJ0bXZVRTRUNE5VVWRCL1ZMQ1FmdWhEcWlqa3pUc2IyN0p1?=
 =?utf-8?B?dUdrOWducWM3VGJvdS9Pc2pQR05ENEZicWNzQm1hbmxIL2ZrclNjc3hYTHFF?=
 =?utf-8?B?NDArS0JCczl6WHJxOWRnK1Azc1ZCTmJXNVAwMXRhajdBU1FiL3ZBWTg5M0xE?=
 =?utf-8?B?MW5IQXpuclE0dmJJMFlYQk1lY3VLRWRZbzZ2cjZwY3VZeVJHaEdObnkwdGdh?=
 =?utf-8?B?cVorQXEzc1k3MXlBRHBnL2lmcWNsOGszd0w0bU40RkpyM0w3SjJQYXZVdnZa?=
 =?utf-8?B?Q3phS2h5WGpQYTR5MCtMMC9FaU1yVkpxNWh4U25ubE9sN0hodkNZSjBXQnR5?=
 =?utf-8?B?VWIwa0FzckFXYmkyMjcwRk9uWktMNHIzYkxFUTVHcGNURSsxSWJPQzBHd0Uy?=
 =?utf-8?B?SGliVExhRUJLL1QzVXFvNEFMTmZib3o3WlZvejJUenVmMWk5UmMyVDNDYjJD?=
 =?utf-8?B?MUhhRFkvWUJHOFVxVGRiUFVzdm9QZWdNdlNXVkxQT3lqRnQ0ZzA3ZWd6RnFw?=
 =?utf-8?B?Zm1aQnlPLzRHblM3MHdDaDU0alN5VW5LRzc2bjl5bmhXWDlUUWZtSFBUMUcx?=
 =?utf-8?B?cTR6RDAycUdwRDNXVmpxWVpDdDdFZmU1dG9nUDU5V0Mva3pUZGVRc3h1ZXdT?=
 =?utf-8?B?cld4L2hhdDd6bWhHMEtuL2I5L2xJenM3Mlp0MndJc3BMcmVhRE9yVGkybTh1?=
 =?utf-8?B?dWNaY3ZnV2F5M3NaSWZjQjNWTEtzbFpaQVdHalRXTS8xRnIrWmJLWm9oQ2Yx?=
 =?utf-8?B?MkpMcEdjTExrNDU2Q2VBdUxOZUZSZlE2V0s3RjF4c2psWEZKVmRmZ1c2UFov?=
 =?utf-8?B?WWEyT2x3R2xrSVlma2d1RWFSL2g0bTBDbWwyaHVJblBYOFdVT0hVT1g4dVZJ?=
 =?utf-8?B?V3Ywcm5ZdmsreVRNOXVzeFo5SjNNdEw3bTJud0lubzRWVmM3MG1BbUxuMEx4?=
 =?utf-8?B?ckw4bGgzc2d0bXBHdGNDcTVZWWd0MUg2OThUTXhoSFJUcDAxU3hHRlZJWUhm?=
 =?utf-8?B?NjFHUUFNbnE1a3FXTE0yazU4dWxBRDY4YmxoWTRzL2tncnhUckRlQ3Jacit0?=
 =?utf-8?B?bzlrR24xS3NyS2FENFFCODIyaFRaWjNQY0NCbXdQalNvengxU05HVEpPYVpu?=
 =?utf-8?B?VXFERGF0WGM4ckRxakdsTGNLUzh2eVR5WFg3ZFZ3MEdKS2ZsT3Y0S3JSVjRB?=
 =?utf-8?B?d0d5ZDUrcSs2UEUrZmVzaXQyU3FBRVBQSlF5dkU1N2JhY0pNRGNqbU5SZndJ?=
 =?utf-8?B?VFFiOE5yZ0R5azlJN2kxYWkzR3E3NmZFUTRlZFBjSDZSR20zR09GOGdXUk53?=
 =?utf-8?B?ZnBiTmp0RWhrOFBpT1R5YVFCWFJtVHFjSEE3MmdPVCtPZzZia0EyNzBDTWZV?=
 =?utf-8?B?UEhZRlFRMVBscURrSWV2eFppK09ac0JUeVp6Q0JEZzlBYmtyQ29HNGlGMUlT?=
 =?utf-8?B?aFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aee8c881-42a4-474f-6cb0-08dc916f215f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:22:46.8406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3rDYt2LyGfHn86p5Dfy37NGm/WuKSSqPDxnjYgvLN4XEnwX7urQMSGmr1hy2CbHUMBim1tSsJJVHtcHCdaXayS0frEeZcpgsSjMEzAu2TO8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5911
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> When a user reads a monitor file rdtgroup_mondata_show() calls
> mon_event_read() to package up all the required details into an rmid_read
> structure which is passed across the smp_call*() infrastructure to code
> that will read data from hardware and return the value (or error status)
> in the rmid_read structure.
> 
> Sub-NUMA Cluster (SNC) mode adds files with new semantics. These require
> the smp_call-ed code to sum event data from all domains that share an
> L3 cache.
> 
> Add a pointer to the L3 "cacheinfo" structure to struct rmid_read
> for the data collection routines to use to pick the domains to be
> summed.
> 
> Reinette suggested that the rmid_read structure has become complex
> enough to warrant documentation of each of its fields. Add the kerneldoc
> documentation for struct rmid_read.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 99f601d05f3b..d29c7b58c151 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -145,12 +145,25 @@ union mon_data_bits {
>   	} u;
>   };
>   
> +/**
> + * struct rmid_read - Data passed across smp_call*() to read event count
> + * @rgrp:	Resctrl group
> + * @r:		Resource
> + * @d:		Domain. If NULL then sum all domains in @r sharing L3 @ci.id
> + * @evtid:	Which monitor event to read
> + * @first:	Initializes MBM counter when true
> + * @ci:		Cacheinfo for L3. Used when summing domains
> + * @err:	Return error indication
> + * @val:	Return value of event counter
> + * @arch_mon_ctx: Hardware monitor allocated for this read request (MPAM only)
> + */

Thank you for adding the kerneldoc. I understand that this file is not
consistent on how these kerneldoc are formatted, but could you please
pick whether you think sentences need to end with a period and then stick
to it in this portion?

>   struct rmid_read {
>   	struct rdtgroup		*rgrp;
>   	struct rdt_resource	*r;
>   	struct rdt_mon_domain	*d;
>   	enum resctrl_event_id	evtid;
>   	bool			first;
> +	struct cacheinfo	*ci;
>   	int			err;
>   	u64			val;
>   	void			*arch_mon_ctx;

Reinette
