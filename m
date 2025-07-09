Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB6F23B63F
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 22:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752099652; cv=fail; b=sxW8BH1pQgBS5g3NpcSFeYfQqTgnRPdOlA3z3dDMGBu4SQP89RqTKZ8+zXCLJO/gmtbbLV0CZeesLMNBssE6Rn/8VaPqCsX9jhv30crTs4i/Uz6A1CmH+6bV5JpoLqO1B4pPFGduatjuUleNqcg9c4E11pex0Dc0bp+sDwODxs8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752099652; c=relaxed/simple;
	bh=t1+JSeIDlLEy1HIxXqc/oVy4y+bnAu53FoIJz9/leuY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ouZ11xutTD0/QAl0AH05JwYN/FM1shCvfW5NAvxM5C/6BpsMfBOQDtJ/ubRnNAtOFPmspFeFzY8cLT1s+K8ktSfl3WvqwEgV4OELd0ZGM2znnwYZmm7Bp+HZxKJpxcVO5T/lm+AwAwYxXuf2zQd8OfHFLmYHlRjh+OsDkEwjLMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dBRFEc8m; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dBRFEc8m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752099651; x=1783635651;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=t1+JSeIDlLEy1HIxXqc/oVy4y+bnAu53FoIJz9/leuY=;
  b=dBRFEc8mrgPl2cKCWGDeWHz3ofb1/XfmBNaRodobI0qjxh7t1Wfwj/8U
   zOKFiEo5ZwrHe77A1W0y4x8BlK5Y/vyVLEdUFD6I2UgMtgNoXbFBSdTEz
   UIOVMjBHJS/M1ZaBJDaufzMtRhrzE9wouFW8N+xa/d/01XXrqRrT5GOrj
   OIPvisao/txXVYosT6NO04bRkcH/91ZAFRiqS9xSOSKAljchAODtTsloK
   4qtiNbxtqoPOWH1TbPIvq7LLI8be7R6M8u6mNMg9GLD9ZEulv7yyd7Cyq
   CkqzhLtoOK0p4wArEnRcPoo7/KQhZqOTVTdXmfCeDtBnE4Z1J8XLlUbWC
   g==;
X-CSE-ConnectionGUID: iiAOZKb5RyurHDUNBT+wbw==
X-CSE-MsgGUID: DFcSFCumREios/UCTuQHTg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="79810258"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="79810258"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:20:50 -0700
X-CSE-ConnectionGUID: +R56hicXRESya9a4vzGK8Q==
X-CSE-MsgGUID: WRWGEclkSX+W7GMuK9oW2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="160168060"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 15:20:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:20:46 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 15:20:46 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.62)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 15:20:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NQxJgzDZs4/M95bpk9NeZCpLlvJXsQolmQgppxvt2ECrkN8a0rz6WXwz8gPFygtw90+aN/zyQ2TSRj94Bf1+SyPiHaAMLA0p8HrhtgsHNyq45sg6Q8bra2uCYLAbApndo2gsR/0try1Pcs9xaraJXDikPu2ZDKo1FMVwEyLFJ8TAseztYqY5TSTNAW+z+FbIntd9WAq7XEqmI3ksqTtHVuV7RMGRCrhh2kOfeVbntRzSMLfZ942NWRaoTgafCi/YQV4iiXO+jxukSxv3vSCgvOamkvaEMFgxmPZzCUrZWcDnhGNGbrNPxyjIEz0N2z4OUZLzTXCqLLs1IssDbq6j+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LhsgcZUVdiNRby7IzuTftg6KgTsMbaVChswpZReiUTY=;
 b=FQOxcfzo5gpbkDDniHrw361lQ6NM8aN2LFCN1O4H2345gi67DZ8Rg5ifHiMvil7uCW0boJBR3bAr4JaHnQJWFwTtFkYJrLL7AWUFnOLCTvL9AHw0vEKsPT0H1qugob4DoVvaZO7OhuBLsUzfOjMaB8JGJztxQ3j/zt9QWyvB/GGKsowFOv0ysJE+JHZUP+L5TzFu8Icy2m0J+Xr1KrMaVB3vH/OMR8XuPLB3eyyO5BBYdEQHOwzGIt8IV75MYPPtQGgOJkrmGHvzGD6KqqgkukjYswGkBhA3lb2SXz6pbBYTLnDinHg5XGrGSLGw4wUVziRlHtkHPr18QyiQKB8LKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by BL3PR11MB6313.namprd11.prod.outlook.com (2603:10b6:208:3b0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Wed, 9 Jul
 2025 22:19:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 22:19:58 +0000
Message-ID: <ee0bde56-bf70-4232-a688-3e87b7f970de@intel.com>
Date: Wed, 9 Jul 2025 15:19:56 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 28/30] fs/resctrl: Provide interface to create a
 debugfs info directory
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-29-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250626164941.106341-29-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0357.namprd04.prod.outlook.com
 (2603:10b6:303:8a::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|BL3PR11MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f46c50b-1d73-4405-e48c-08ddbf36bd63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TXhHTTF0ZFQ4bmh4eVQ4OVpVOHVCSkpGRDVEYVJSNllKZTJpZ2VEekNYUURN?=
 =?utf-8?B?U1pmUGpoV1JHZlNqLzZYUmZaRWNXcWo2elh1Z3kxUVVzYktIb0Y2QnVlUGor?=
 =?utf-8?B?Umk0dFNoeGVUK2FSZENqb3NXcGh3VTlFWFdzVk9IVU12NmhNUHNOenlmcnlV?=
 =?utf-8?B?SmVZTjIzR3FLR2dVY2VObTZDYUJBamZ5SFdTSHE5Y1Z6bjFqZmZSSWdCSzFr?=
 =?utf-8?B?QUxPc1lENDRzOTFJQkdoVnltL0I2U0l3YVlsNlhHQnRUeXlWZTUycTRMWktm?=
 =?utf-8?B?NU5JcjgyVEFRRXkvcnhXYkdNRFNmZDJHRTdYNlBuYnhVclFUT2plZnJCUmFD?=
 =?utf-8?B?YXZqbTAzKzl0elkzUVFkbTNFZk1IU241TS9Yc2VZVnNqU3JhMGQ2b2tZZ2Fx?=
 =?utf-8?B?T0xkRVd0UVlRcmhBdHhjMW5oSmY3M3o3bi9KclM5WlQwYWZuZ21CZUR2aFhX?=
 =?utf-8?B?NU8xYkhSTWhzVmd5Q0Q3bGRqaUFVRlNMTHFvRkkwbzFMY1RYNS8zOTBoR21S?=
 =?utf-8?B?dXRLYWZ4dklETllMS3p1cUZaT3BIYkxOYU1JUTNEOExYRUQ2OHZZUkFyZGgz?=
 =?utf-8?B?SFEyVWUyUERJNjlWM1Zpdmp6N00xcXl0WnAyeWlmQ0V4QnBqTU11RDIxTUo0?=
 =?utf-8?B?aDJYQ2J5WG53WDRVYjcrRmxqRU5VVzU4dElLMnVKbUt2VVU5RkFnSGcvZi81?=
 =?utf-8?B?ZnQzcnhkVm45VVVoMWNnU08rUGU4bW95Rm0vRTRUc29ycmQ1M3lWSHVqWUdI?=
 =?utf-8?B?cVhLZHl3TnVCR3ZMVCs1TGtZSXo4UkRkTC9FZTkvNUdPcVVMMWdnVFZKakQy?=
 =?utf-8?B?Wmp5TkxFN21MRW1reFFUc0V2M0U2MTRrdnFUUDh5UEkxazVDY3NFUllRK1dH?=
 =?utf-8?B?cXZjdXN0dUIwLy9PM3psdTJuNWIyZE53TVVlbkg3WE8wN0dIVUg4bmczNGRs?=
 =?utf-8?B?NTBvYUd0Q1ZHQ29HUlRWRms0UEtqUFc5Z01scndXU1NVeUpkRlZPckwycUhN?=
 =?utf-8?B?M0pTTGFSeDVOdEI3elJJaE5QZ0x4NFlvc29QVStOSnVqMy9XdmVzRTBuQk5i?=
 =?utf-8?B?OWJqZ1p3TUVtS05pZWFMVmNaVDZMK0kvRkRHd3Q0UTVLSE0vU2VqdjFPOExZ?=
 =?utf-8?B?eGYxNmVyWGNBNXBBREVOdTE1SGlBY00zVDZzSEpxVTlzdTFlaDdFemw1QWdu?=
 =?utf-8?B?Q0kveFRQRUVzODdXVzhsSm1Xa1RBVFFUdm03bXR0OTE5cDJMRVhBbDBNbjBv?=
 =?utf-8?B?S2hTNmlPaHpTSGZKMjBrUEFUV2pZMkNzcVRTK09rYnZCMDdjTjVlY1NqTDM5?=
 =?utf-8?B?MCthWXdOaGxQOWNyQ3VaTlFjZUtNY2ZqeTA4MTFzbDYvVkhQUC9zb2x1a3FU?=
 =?utf-8?B?SE1oNW1RYllJMGl1a3ZacnNPZjdpcGV6UlFwa0lRZmxNaUhVWUtJdEU4NnVq?=
 =?utf-8?B?TkIzK3lzRnRNV3hmRUNsUllXRTlFamJ0UFF2M3BsVDJ3WlMrSmVJMmY5Z0FT?=
 =?utf-8?B?S0ZzbktxcUwxaGNLVjRkTlBwbXN2T1d1Qzg2Ym9abW9lRlpwWG9xMkd2NnNp?=
 =?utf-8?B?L0Z4ZDgrdmlHOTdtTWNDS1laSGtzVWJiQmI4eDlpdWxONGxFeFljdFNjS3RF?=
 =?utf-8?B?OWlQVEYyNVBMRngrQzNtRVcvLy9sVlp4SlBkT3EyTTdHVVp0WVlKc21uUzh0?=
 =?utf-8?B?OWtwd0JxQjNkZTlBY0hlU2h6ZUoyL0R2WlBkQkJyUndYQ0cyZkxNdFlaaXpk?=
 =?utf-8?B?eU9mTVFCaHhwU0tQMXJyRnRrcTgzWDlQSjM3ZTRJMnNxQW0wVVU5NDVzMnJO?=
 =?utf-8?B?MzVISHZBQVhsdGZGYTYyekJla0hXREdGaXR1VWpiS1JBVEQ3VmN4QzNNUDRv?=
 =?utf-8?B?UXdERHlwcHQ0c2R2RW9GM3VEdU9qV0VERXVJS2JqejJFbFBTdzdWeXk1TU1M?=
 =?utf-8?B?dnE4ekh5RTVlQUZvVGhTR21vbUR6R3FHd0JveExwcFZRY0xvaEZWcHNYQkZU?=
 =?utf-8?B?SkN0eFFlb3FBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUxuOWNUaE85ZDQwR3JVaEJUUGFZcml6cGI1THBtYTdaOFNUbmRTcldNRDlY?=
 =?utf-8?B?Tng1Z2R3UEdQcUNXMkJ2c2xaUXo5b3V2SXhaM3MrSkR3SFllZ0ZBME94ZnQr?=
 =?utf-8?B?VUQvSHFFNUJLMlNXbzhxR1lyaXdCNmlZUWNsekNVT1JjamlvdHZmMC83dzVq?=
 =?utf-8?B?UlFUZUVMYStobzNNL0N0YkplTWJoL2swcHN6SlBvTSt0eVVqMkVYTU95OHV4?=
 =?utf-8?B?WWVzYU5YaGFLR2FzZG5URmF0RUdvMkZNV2JpZVF4ait5T2kvaDdRbXY1WGEr?=
 =?utf-8?B?cFBYam8yTGVycVlWTUFZQkRjR1E3Sm53MExidE1SM2RhcXAzVHgzN25KWmVu?=
 =?utf-8?B?V3lGcFQxYWZYMXR2V0pxTEJINXQvZGFleEliaHlGTjRiMFB5L0FHOXVNZ2R5?=
 =?utf-8?B?bUhpdk9jMDhKWHF5MXJweFZ3UnZkcnBmUW5GMm5hMEJIYWRBTG9ybmgwV3lD?=
 =?utf-8?B?SWRPZWZvYlIxOHBrV3pQVEN1OE9xQnpxQUg5eUxRdDNSUG1MS1dUeHE5UHFl?=
 =?utf-8?B?bTM1bVp6WnAxU1VWZ3YvbjJ4VVp2a1cySDFaL29QcFRBR0tuWHRoTndPQ2di?=
 =?utf-8?B?Unp4NUhuTUFVOS81YkNXQklod1JhblJGSDJGbW5Tbjk5c3JrM09QbWNneVVs?=
 =?utf-8?B?M0NTTnoyMVcxZ2ZFbEEwTmg3WktJZE9qMnRmMENXbnNBRzFpK3h3NkJmTG1D?=
 =?utf-8?B?U21tZE5IZmJXTzNkQk1aMTVhaDFRVm5ndC9WZCtrWE80aUpMaWI2MnZDcGNR?=
 =?utf-8?B?N01FcW5JUVhuT3lvQWs3eEgzMXFabnA5MU8zWk1sbzNVRUZDdGJQUTJONmtN?=
 =?utf-8?B?OXNiaGQrNDRSdUY2S2xrdXhDSnVzQnlaN1BXZXFlV0ZDRWdxNkdHNTVxUEhk?=
 =?utf-8?B?R2pUUTJiWnJmZFk4THdNdTloOXV1QkYrVEtCb0FYMUs4RWY0M1NPck9tOWow?=
 =?utf-8?B?OEY1NHUvRkd5VnlFdlNLckxsRm03NGgvRDduUm14alpSTERwRStnb1BvYUVN?=
 =?utf-8?B?Qy9neGdjUkQwR0lJQnRDRTdXeENCYWlPUktmWFhoV3JLTjUzVGlib2lzWTNT?=
 =?utf-8?B?bEJoZTcxUkNzK0xKcEMzMTU0RE9BTzlPbXorQVdYekdpUVpQcE0zdVZrN1Zi?=
 =?utf-8?B?THVRZHlneXJMZDZKTkgvQWxoTDRubmhsazNnekRQelFHeEc5MnFTaXZaSnpJ?=
 =?utf-8?B?YjNmbERlTE1WaXZ3aWpPWVcrQzdHUlBZaCtVTERxOHlUbWt0NkErSnREbGRS?=
 =?utf-8?B?VnJlQkNKL0laa1lXVHcrbXU5L0szM0lzb0JiMm1BeXZxb3VObUlRbGx4WmV4?=
 =?utf-8?B?MU9uWmxpK3FJVDN1K0ttUml1d3RMSFpRV2xIdHJEOXlXUzNXQU9YK1daVDRK?=
 =?utf-8?B?UGxLWC93RWx5M0ZJZkpXSklLbFQ5ZmhwUWxKQ2t1Z1hSWmxJRUhhWFR6b05h?=
 =?utf-8?B?Rk50V0xJck1wOTUrNThBWHNpVysxZml6MkxkN2c0MlM0S0NiV0JrRm9xY2V2?=
 =?utf-8?B?RHB2bWlWQ3h0ejdKcE1PWE5lbUpoeTltc1Z6UDc1aXhoak5uYXU2VldiT2k3?=
 =?utf-8?B?ekFKMmFJWUF1NG8wVkp6MHdNalhRZ3BlSnR1a1pVQnZzbEk1U2IxUEpYanZO?=
 =?utf-8?B?Q0dSWkJvMFhtNmtDNkV6V1hsaFhDTXFCRmpvbjM1NTl4OWR4N1hKcjNyelJM?=
 =?utf-8?B?MmVxbDhkbDFLV2NqWFdhNmsxL0NhL2JVS2dBT2w2amRSSmFVOFY4Z1I4Wkg2?=
 =?utf-8?B?Qk54R09rUlRNcjV6SEdTUWYrVGhoZmhuQ09tVlNEemlxQWg0NlBQQzdUdkFN?=
 =?utf-8?B?SDJFWEs2alB0SEI1K09TTlorK3dnQUlEZGNCQ3M2Vjk3YytLVlRlYnJkQ1No?=
 =?utf-8?B?WlBiTklFUFRBUDZRUjFDNGh0UDhWcDJCQ1J1ZHlrWkF2bi92ZWJVU1RtSEl5?=
 =?utf-8?B?VkxKY3dxUUlKUGVZUFlNdDJaWE5yM1FLWG9ZS1VuZFY4U2lCNXFvWUdkdS9q?=
 =?utf-8?B?NFd3RjFhZE9vMHZjakRRMEJpZzJyeEl2dE13TWtTVGVFaU54SU0zU3B2SDZF?=
 =?utf-8?B?M0ZLZ1Y4TVg4L2xkVXdJd2NveUFMVmdaVFBGWE9CS09ZKzF1blJZUXZKSnRo?=
 =?utf-8?B?WWI3WVVVV0s4SklBYTY2TGFoSUFQSEloOC8xbDNnYUMrNy90WU5vNlZ1M2VO?=
 =?utf-8?B?OEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f46c50b-1d73-4405-e48c-08ddbf36bd63
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 22:19:58.4774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fi6zIkyPKfuqqU2p9JZCXecz8sJiCBUcwnrkzj9LrRXd4imqD/Z5GkL1lrW4MprjS3DX4kq3Su58pA5rB7TS7js04N847RcjEOizYD7GetA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6313
X-OriginatorOrg: intel.com

Hi Tony,

How about:
 fs/resctrl: Provide interface to create architecture specific debugfs area

On 6/26/25 9:49 AM, Tony Luck wrote:
> Architectures are constrained to just the file interfaces provided by
> the file system for each resource. This does not allow for architecture
> specific debug interfaces.
> 
> Add resctrl_debugfs_mon_info_mkdir() which creates a directory in the

Patch calls it resctrl_debugfs_mon_info_arch_mkdir().

> debugfs file system for a resource. Naming follows the layout of the
> main resctrl hierarchy:
> 
> 	/sys/kernel/debug/resctrl/info/{resource}_MON

Patch creates 
	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}

Accompanying this change it will be useful to describe how {arch} is
initialized. As a user interface I think it is helpful to connect
that the directory name will match what user can query via "uname -m".

Could you please add a snippet here on how architecture is
expected to use this? There may be some discussion about how archs
could differ in usage of this and mentioning it explicitly in changelog
will help folks see what this enables instead of appearing to sneak
this new feature in.

> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h |  6 ++++++
>  fs/resctrl/rdtgroup.c   | 24 ++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 35ae24822493..a8ffd9f61c46 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -569,6 +569,12 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
>  extern unsigned int resctrl_rmid_realloc_threshold;
>  extern unsigned int resctrl_rmid_realloc_limit;
>  
> +/**
> + * resctrl_debugfs_mon_info_arch_mkdir() - Create a debugfs info directory.
> + * @r:	Resource (must be mon_capable).

Could you please add a snippet here or in function comments of
resctrl_debugfs_mon_info_arch_mkdir() on how architecture is expected to use this?
That is, make it "official" that arch is free to create debugfs files
(and directories) to support its architecture specific debugging 
associated with resource @r.

With this being arch API in include/linux/resctrl.h I think a note on
lifecycle would be useful considering there is no partner
"resctrl_debugfs_mon_info_arch_rmdir()".

As an API to arch it will also be useful to describe what this function returns.
For example, it will be helpful to know that this passes through the
return value of debugfs_create_dir() that arch can use to determine, for example,
whether debugfs is enabled in kernel.

> + */
> +struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r);
> +
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 3d87e6c4c600..511362a67532 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -24,6 +24,7 @@
>  #include <linux/sched/task.h>
>  #include <linux/slab.h>
>  #include <linux/user_namespace.h>
> +#include <linux/utsname.h>
>  
>  #include <uapi/linux/magic.h>
>  
> @@ -4350,6 +4351,29 @@ int resctrl_init(void)
>  	return ret;
>  }
>  
> +/*
> + * Create /sys/kernel/debug/resctrl/info/{r->name}_MON/arch directory

To help make clear that this is not the actual "arch" string: 
arch -> {arch}

> + * by request for architecture to use.
> + */
> +struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r)
> +{
> +	static struct dentry *debugfs_resctrl_info;
> +	struct dentry *moninfodir;
> +	char name[32];
> +
> +	if (!r->mon_capable)
> +		return NULL;
> +
> +	if (!debugfs_resctrl_info)
> +		debugfs_resctrl_info = debugfs_create_dir("info", debugfs_resctrl);
> +
> +	sprintf(name, "%s_MON", r->name);
> +
> +	moninfodir =  debugfs_create_dir(name, debugfs_resctrl_info);

(extra spaces)

> +
> +	return debugfs_create_dir(utsname()->machine, moninfodir);
> +}
> +
>  static bool resctrl_online_domains_exist(void)
>  {
>  	struct rdt_resource *r;

Reinette
