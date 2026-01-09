Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841D614F112
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 00:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767918842; cv=fail; b=GOmvtyoL1nFNMfBDDlqJ4LYdguveGYMLowzJxQK4B7rExhE+BfJ+0nlBcdRh8EASgp79xAXDaOJxcFk1Dp29mkQM07URxmmIeDLvDCe4PX8+3f2aY3MAwFkylzHSYNTUSzfDbyZFQ/md+rNl7H7OWNeP5BzB2d9/0/oHI6h7RMQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767918842; c=relaxed/simple;
	bh=Y3lmv/XBn6pvLHSa3RvP+XnXifzXz+dieocqaKdDyus=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XQmPQdr7xeYj2DsCWCUCBW7fw1PCqrO9fE9AYLGgpUhxbz6UeMFF+Y76nmf6RQHsEMb4pPIvFm1E71RENXtGSVCJRcEQB1WZXP3QAGD4ewrG8wUMP1p9XJpwVJhdlKCPoN7QzZpt1u2zczUXzPyFDo1SjPrdUd1TVCba99Dd2vM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=heivh2q7; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="heivh2q7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767918841; x=1799454841;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Y3lmv/XBn6pvLHSa3RvP+XnXifzXz+dieocqaKdDyus=;
  b=heivh2q7J5/LI2W1asFV6ER9CThlFYN42JwPaLnpwJr2CbaiH+BZuyso
   GQTyEejhZdVrXxPi/3l978jyPtqJCl18TuWAIudIswVjEkp7xtf93+gTm
   tF12IYH0bk+Oz6a+QIBF6FWPx/6aVPwlRSZID+NxSI64TN69jl8dtaNpi
   VcuSdk9CGT3AfqsFcLzMtZAjv6ndsLZNd0BVc414t+v4jI5VvNdoC5MZf
   qTrbffpvtqBnYDcJ9LLNqK1PVPeCL8LTjoF8KUeo0RWOdZxl5XUlVUGcA
   cgZpmSmDCWygQynmOqhc2uloXWES+S+s3q5qbl7V4rO/vpel1kBEo7GH+
   A==;
X-CSE-ConnectionGUID: F+fJjsLtRfqU4dpAyOMBfQ==
X-CSE-MsgGUID: EnRpPBr1SqSJDdqlmrH/0w==
X-IronPort-AV: E=McAfee;i="6800,10657,11665"; a="80413186"
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="80413186"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 16:34:00 -0800
X-CSE-ConnectionGUID: 5+f5SugoRBaLPHxNKcMHDA==
X-CSE-MsgGUID: 74n6MrtXRl28/FQ1swervg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,211,1763452800"; 
   d="scan'208";a="207479651"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jan 2026 16:33:59 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 16:33:59 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 8 Jan 2026 16:33:59 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.25) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 8 Jan 2026 16:33:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XNEYqYezLtvhIEYYaY8ZUQ7GXKGFSi/f02YS7WD7BsT0PNzv9IQWcvacYBaEdesqLJhPwKjE1AStvpjiM67nzCMItfNx2vJmMjrwq826zTfFy92ujJX90qDor/yZb93XUK9eUMPVxj1PL6cryiAcizGViF4N8A/JrEXEROlsh5bvIaCyLua1LMWxM4nYMzkMMpugO0Yb1WGQaJFPjGkdIVqjwsw3Vbam/rm4W1M+X0XmrLmO3KRzcB8fSIE1DSFq2c+WZcDYfPEktkVDcZ8bKoN4XJaGdNIobiclAbEoAB1TpglH5lkNHpJvzj/PCYuU27e+wIGyWDZJkK0ggjv+dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=61VhQMcs3n7oHq5UJjhIjHNqfLfBqhxj2JzLRzaM7wk=;
 b=YTtoPGXaooLSiQe54+Fb1M7PodXo8p9BwkzEFevIfUGXCM5GGkBFZuP7/TdKtxP1TmeUMi3kO6lnRynZFAvBEch/XYmoXF9N5Um1qIlTABuEZlSvNKhhQbtzKcOYS4gF2c3pTNoh7gW7wPWw779sPrRVHWJZTQS4ORxx/bCx37ayqI8ucMqlFot40k7HdUeCvbvcBZZlckI2cL6vPYb7q2Ot5vxX9PSTjEsM49+qZR8R0zDoCGJ9u7MrFQ3RN73b3lVH8jG2epXOO5brqWNZIRPAZ9jtVKjfdkqJOcx66mfa+iLDwQLuvFsgBvA5cc6mbi1gKMmd6ACZ9C7FsCndew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5134.namprd11.prod.outlook.com (2603:10b6:a03:2de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 00:33:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9499.002; Fri, 9 Jan 2026
 00:33:51 +0000
Message-ID: <c27ff6a4-505c-4873-9e41-d52a21a1eba8@intel.com>
Date: Thu, 8 Jan 2026 16:33:18 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] once: Don't use a work queue to reset sleepable static
 key
To: Tony Luck <tony.luck@intel.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Eric Dumazet <edumazet@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260108232717.14411-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260108232717.14411-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0185.namprd03.prod.outlook.com
 (2603:10b6:303:b8::10) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5134:EE_
X-MS-Office365-Filtering-Correlation-Id: 297e708b-ae9f-4fbd-1738-08de4f16c2e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bzJsVlRLZXVNeEU2Zm53TmdkM3V4d1drb01OY3VXTEdPWmw5b3B0Vlh3TkFH?=
 =?utf-8?B?Z0htb0J5aHNEQk1jK0V1RmJRQXd5OE95K3ZVS0ZJZHNxLzdsWWFpR3ZaZDVB?=
 =?utf-8?B?bXdJZ2VxSVFjRVpJK014L0ppWDZuMXBpZ292bUhOZzRVUS94RkRydHJtR1lC?=
 =?utf-8?B?QmVnb05mcWRYd3RhT0VnYkhuM1lNVVZUajdNeXFxczhFeWdXeFh2alJOazR2?=
 =?utf-8?B?cWZPZzUrTHBEZWlyQ1MzK2kxOGsxRDZIbDBkMXVwT3Q0dFVDUVJHN3BHRHMx?=
 =?utf-8?B?YmtGVHhZRmROQ0VuSWFEOHJJOC8wcDJ5SHBDUFlOWlA1RytTenk4Ky81dWFX?=
 =?utf-8?B?d1QrZzdsc1QreVJxWkhsZzhWNkR0R0hJRDFaTWlIRWF5a2JIS0hrTUVWeVdz?=
 =?utf-8?B?ak9POTlZbzBGV1BRRkJFSGJzVTlacHBvOHhiMnFsRU94Y253MDFiTThCK3l0?=
 =?utf-8?B?T21aZGxXWVV6WnRYeWYxeklhK29PQ3FxQzlrdmcxNmVIM3BLUmZQdm85TzVl?=
 =?utf-8?B?QU82aE9kaldSbWxRVTVGMmRCQzlPSXAyYW12UGZyL2NvTWhzeUcwQVpwWW5N?=
 =?utf-8?B?RW4wYmI1d3k5ZjZVdlpib085R1psVHVOd0RrMHNPSW1qMXZsckxKcVJKRWJh?=
 =?utf-8?B?ZU0xaGlZSlg2TXMwTERSTnA5MHR2eDc3b2N6d3h1VkV0SDJST2JKSW9PbURF?=
 =?utf-8?B?cGlyNXMrNlMzdWgzYnBPV04rUGxEV2NrVW5zQ0FpT1pmTk5nVWdrS1dscjRD?=
 =?utf-8?B?NkFaTndhU0xkSkVRQzhIdi95RElocG4yTmphc0luUTZaMU9FL3Uzd0ZBcllW?=
 =?utf-8?B?WndnQ1hsN29USXF6TEJ2RCtKcDlZa2ZBam03V1pyemd5cGdMZ3ZxaldRbVBz?=
 =?utf-8?B?NmtxTVdrZ3p0eXg5QnNqcEdVMk1hU3ZYNEFWWDJCcG5vM1l2ZGZLa1ZuVlcr?=
 =?utf-8?B?MVVyTW0zUkgrbWczQ1R6RVF1V0VMN2FpSDFIaHByMHlWcjFUWTFybXpuNGhH?=
 =?utf-8?B?Nm9ncWd6a3ZZbU5zRmFTdndLckwxVzJoM1RnMTI0b05lNmk2Y2hYSjNoRnRP?=
 =?utf-8?B?YlJEUkVaK3pUSHlaNmx1em5TK2s5dHB4RjlnQXRQYm5idnBaYlQ1ODFabFIw?=
 =?utf-8?B?OG53N1Fic01vVnphODdMWXd6WU5HY2tRcXdENzhTbkMyQWh6bmZKMGNyWEJM?=
 =?utf-8?B?ZWQ3SjdLZmxPSkh5N3B2UHM0SDMreTJjdHE0cGEzNnUzMUk2MG1CcUVKR0VQ?=
 =?utf-8?B?NkpxeDhoNVJNdldsNjc0VmVvNmM1YlhEUDdlRDZpaU5nZTBRZkw0ZWtjNTRm?=
 =?utf-8?B?amQwdWI2SHAwVDJMazR6MDdIR21NOEdxMTFEU1hzVUlyQzhNUGpNcUpUYjh0?=
 =?utf-8?B?V082S20xTmUzQU92WktDTVB2dTQzME94a2tOTXAvMkxZRnlwcDJ0QkZxeW5R?=
 =?utf-8?B?TVNxL2lvTmR3QTRTNUxFUHkzUWZsMmFDTkVxVlk4ZlZNaCtiT2UwTmIxUzFB?=
 =?utf-8?B?T2RTdFI3bHJ0dEVhVnBwM1B4dHR1T2ZCRHI1VWMvTENYOTNwY0lqdU9maWpK?=
 =?utf-8?B?b2kxY2pwWDVFelYrbGpiaXNjYlZLQXJteDFMbXRYcEdTc0szd2h1dXJqc3hU?=
 =?utf-8?B?N0tNWWR3dTVqUjhRZlBiRzFxMHREYlFoYzhXSnpXeVQydlNabXl3dWJvRTVn?=
 =?utf-8?B?UXRPNDN0b0U5M3lRNFVac2xTUmE4bitWb3ZQZWgxaEJMamtLMGpSMVdVNi8x?=
 =?utf-8?B?MEVwUGNsajVuTjBHNkhvNXllYUVNRGVBT2NLRkNGZlI2aUQvdVBoZEdGekZt?=
 =?utf-8?B?Ly9EQk13TnFBZzBRWnpGeWpNbi9QdTFscUJ3NFptdzlJdE1LbzRkd3BGbjU0?=
 =?utf-8?B?dzJuOEtBS01GakRmNUVvVzRYWFJ2U3c1bmc4a2NsaG54dHlDa0R5eVpBckxi?=
 =?utf-8?Q?B78IHRqPPqR1K5tUFixKHKcavTTTQXz2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?akIwQWR2b3d0S3NmWi9lSCsvbGpLb1lkdWtnUlcxK0RNRTNRQWU1VlFyQlpV?=
 =?utf-8?B?OWNRUFdNaUt5V3JyUmgydlQ2QitFNE5UZHpTblM1djNPaHdhOGh2WmoyeFJm?=
 =?utf-8?B?NlJtSUhoVGtRREdaOEZIQVA0UXJ5Ky94V3U5V2cxeTA5S2llU0h0emVIUGRz?=
 =?utf-8?B?RzkwZTIrZmtZUldXNzdhWmpYVmoxWUpRdmVGU2hJR1VFWGhicER2TGFhN2F5?=
 =?utf-8?B?dEg3Sm9JZGh6WW8rQStod2ozVE5lY2xGUG5WMFFRelBXbXV2QzlVVzlVYzlG?=
 =?utf-8?B?d0YxdXlobmlUa2s0REJsYmM3amhtMWpqZC9kLzROdWJPcGJQYXlueFEzVXda?=
 =?utf-8?B?cnc4WExmV293TjdIL3k5d3hSUnF3UHB6djQzWjVtbCtVc1FTbGJlQjNHVjA2?=
 =?utf-8?B?TU5xUzRXNVlwd2dSVk9sRWRPbU1taEg4ZVMrS3RaZGZBc2hrQkZLU2pkVWpl?=
 =?utf-8?B?emJ4VlByK3BienA5T09xZ1l1ZjEzaXl1eWhGZkdFd3NjSVZVS1RHWmYxdG13?=
 =?utf-8?B?amZIbHpFaGQ2MWlubjJZalNsQ3g2cThOeWxIbmQyUjFUS01JM296UHd5YS8r?=
 =?utf-8?B?bTBqUEt3Y0tqZVRPcmtHQnEzaGgxSnMwNGpIRWNTVmIyeVdJWDJwWkR3WVNI?=
 =?utf-8?B?QkJBM0tENm5ubmpQbW45S2JuYWdwRTJqWi9mbVk4cldLbzRKMEY4K2k4VE9H?=
 =?utf-8?B?Z0gxbk5mNmhldE9ITXh0VkhFSDRyWm1UYi9OSmhLS1dsaVF0Y3Fjak9IM1pk?=
 =?utf-8?B?ZWFIcXE5eDFkT0dCcVovWTBhZng4Z3cwWlRSTDZJVnFoUXJ4dlg4Z3FPOHZ4?=
 =?utf-8?B?UFFScmZFQ3oyNVJQTVVvbVhKVmQxM0VodmkrUHJIMUVkNUk2bHowVHJlQU5i?=
 =?utf-8?B?eHcwcXg0U0ZXZzdSdEVKK1ZkeGw5blFNUGlZdTRhOGpVYi9kWmdEZ1JRUjZC?=
 =?utf-8?B?MXVYMDF5V1ByS0NTYW41ZHovWUFGOFBsVklzTEpVVlY5dXhqZHNuc1VoOVBq?=
 =?utf-8?B?bUxQUmszdE1sajNkOWd4REI4ZWEwdHBZejBna1lzc1J6RWlVK3lPV0dORkJJ?=
 =?utf-8?B?SUptcEtPZmZRQi9RMENDWFZkcXZXdlRjM2FKRVpRYTQ1M2R2Q2QvK054a21B?=
 =?utf-8?B?SHNpVzhMVWw0dlNSQzB2Smt1VmQxQ2RwMEZVSVJrVzlwdEtWaTNRcURwRXRi?=
 =?utf-8?B?K2lJV1BtTWY1MzBCV2laNWJ4eHNGU1RsbWRISEFKamdHY1o0WEFrczdlRENa?=
 =?utf-8?B?TkR5Y2NMQnV6QzRtaTFrTGR0ZWY4NjRUYzEwMFQzR1JUUWtXQVhYcEtBTENB?=
 =?utf-8?B?MGRFUWpDN05rc0lISGdKelJOTVJxclA5MEJMNEg4bjQrMjdXRFF2R2RFLzRT?=
 =?utf-8?B?clovb29zUUk1ODRvL3J4bzE1TmREbllRVGFmSHBXM0dXSFVsekVBVFNHRmNZ?=
 =?utf-8?B?dlZhdDhxMmFSa21mNGs3akZETlBFdHVhUEQyZjJTTytvU2RUai9RcGkvbkdK?=
 =?utf-8?B?cTlmSUY3WVgxcTdvQ0hPeXVwcWNCZDdHeG1zclhWcU1sdWtpR3AwYXBZY2cx?=
 =?utf-8?B?TkZ1ZW9hYjJwWXpMUTFpci9OWS9PTWl6Rm05TFBOUGYrelhabVZiNWxtMjYr?=
 =?utf-8?B?M3JQYlJ1OGZFYk5oanlaeFE4cGJRT21BK1JIOFZJQkhWWmNpeXYzK1ZYTFdU?=
 =?utf-8?B?bmk0V2YrQmk3dDVUSE9Ec0xyOW81OE5GckFRd0w0Q3FqMWx6VkZZNDJQRlM0?=
 =?utf-8?B?NVZMRjhzb1diL2tkczNWLy9HQVZKbFNKNkcrcmRVZkNncHNHc253Nm5STGd2?=
 =?utf-8?B?YWVkNU1hZ1loUzZoWVpKamRIZitqR3cxbFZnb0FMdjV0U0dKR3AzZEtMZFpW?=
 =?utf-8?B?N29OdzhrZHNFWHQ0V1dRVnB0N3dtYjN2R1kyMFlSSFJYZlB5T0djM1VQVUx1?=
 =?utf-8?B?KzEzcFcyaWtDRzduaHhEQUlndXVoczRNU3lQeU03SjZVUlpaM1VXYkxvLzdM?=
 =?utf-8?B?c2dMY21xL3BmR2VUd29uYXRJdFl0aHUxYmJIQjUvS2RhZkV0eDJqdngzMHEr?=
 =?utf-8?B?aUhnVkJnL2hsa1l4TFBDZnpMR0grTkhTbkdmeWUwLzNLakduSDVEUkpRRmhO?=
 =?utf-8?B?c0xXT09LQXc4bGJOYWg5ekpFT0gzZ2NCVkMvOHN3UlVsQW91ZDcvY3pud0xz?=
 =?utf-8?B?Mm9TUnNqUVZScUNBaU4wYnVRUUk3bW8rZ3RhbXAvaTQ5OW5wNzNTM1RNQitW?=
 =?utf-8?B?R0NsRGdNc3hxWFArWllHWWFkaXp2TXZvajRHV0dWNUV1SGhUZTBpZmxSUXFO?=
 =?utf-8?B?RU9QRGJSNFp5NHNiTVpCVXIyVElFbW1DU1dlVzZUQ2dPTXNRckt6QWdwbEZw?=
 =?utf-8?Q?o8Hxap7qHV1QSw9I=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 297e708b-ae9f-4fbd-1738-08de4f16c2e0
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 00:33:51.2988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4TtzkBB4etJ0Zs0i31CEi5fX61dGbcI/dSlhbPJ6dSW5Pg6y6qoFGxLLQsW8vA+nf7sdl5ElU05H0WhgnqrNoaf0lp4ZQuPcSjeCPCAr0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5134
X-OriginatorOrg: intel.com

Hi Tony,

On 1/8/26 3:27 PM, Tony Luck wrote:
> Pointless overhead to use a work queue to reset the static key
> for a DO_ONCE_SLEEPABLE() invocation.
> 
> Reported-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  lib/once.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/once.c b/lib/once.c
> index 2c306f0e891e..d83bdde78ced 100644
> --- a/lib/once.c
> +++ b/lib/once.c
> @@ -93,6 +93,7 @@ void __do_once_sleepable_done(bool *done, struct static_key_true *once_key,
>  {
>  	*done = true;
>  	mutex_unlock(&once_mutex);
> -	once_disable_jump(once_key, mod);
> +	BUG_ON(!static_key_enabled(once_key));
> +	static_branch_disable(once_key);

Can this be simplified more by disabling once_key with once_mutex held to eliminate the need for the
done boolean? Unless static_branch_disable() is considered to be so slow that it should also be
avoided in sleepable context, deferring to a mutex protected boolean until it completes ...
If "done" boolean is removed this may need an additional check of once_key within
__do_once_sleepable_start() just in case a second caller was blocked on once_mutex.

Reinette
