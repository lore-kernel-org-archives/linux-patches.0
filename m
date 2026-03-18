Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3183F074A
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 20:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773864782; cv=fail; b=hZMJSCUAwY10FPMnPGAZVruZKvU3Bdf8KNA27mW6fPocafIIILRRFRP6fxn/EU6vTzYWotYfYoFhpRL3YfPo2ziqoR1p4XtuShAKcFI9hi1TlEROv+xsYzQdhpg9JHk2RVGNDvf4wBcZIB4SVT2Z3RFELG6SmNRaxMIo/qVhUEc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773864782; c=relaxed/simple;
	bh=q1cVJ9/x9kiikih9sxK0qffbIJXk6a0q/d+yWiJday8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Hhn5QC/SUwMsd9s+S76nlcaBGE7WI+9zWnIdt4QO+E1fzSnrWGAkkqyHW4r4/3RwD4AM68QSkDZOzUihn/O/fHcWJotvI8HsOdMRYLejOwd6KAyMiMkpLIjF5I5e6J2dDlHotga1iLMzuLqEvfEEWDwAPHdFF+oTOzLEgL6XgaU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P5R/e9a9; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P5R/e9a9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773864780; x=1805400780;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q1cVJ9/x9kiikih9sxK0qffbIJXk6a0q/d+yWiJday8=;
  b=P5R/e9a9PT9MWzcowYtHKlObD5at6GKlMbNIJgyESgrdbzvcklZuPw2S
   OZnU4MSgCMjgFsW9SO2oP68sS+NrjPOUNqD/+qam+RmYmVocK5P/J0rIw
   WU2cweRZGn/GlvfbCxS14bPNRlXt0Et2WJixriSVrA5mh24USGgYTU9J9
   81tlNLMXhKaBh0ePaVSHvOFQLhS0xOcW27JSNvx8WCQ8+HFoUFOheca8M
   1QLdgFSPEog2PEJPYmNkGewMfxbl679etWnym0GyATwXXAt6ktyaGmrEt
   zmCysJZU+bFoVoz1EpOiLQ5p8MVR8x1NK+jJn4gyRFN4crrk9CrB5kn4A
   g==;
X-CSE-ConnectionGUID: X1XNPErMT3q5g2eQ83SRDA==
X-CSE-MsgGUID: v3qjyrG2SPC4vaVQEzD/EA==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="78538062"
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="78538062"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:13:00 -0700
X-CSE-ConnectionGUID: aUQ1YnKZR3W4In9wgt/Aog==
X-CSE-MsgGUID: fBaa4GuwTrqWR3VMlFwh0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,128,1770624000"; 
   d="scan'208";a="222787117"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 13:13:00 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 13:12:59 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 13:12:59 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.0) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 13:12:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R5RCMuyvSYqahfOpSdg94y3zBHtIDmqeTfA4kV7xoCjLjeybso9d8SMdIAWqTFB3F9E7bdBzpIrLV63jeQESNECO97NnfDIvP54GT9xbQK8wzftCTuCrN8coA2m2VKUkpBFvgbIYeeJRLh/qY2RiiVMkPHSqd3xnztNHedOuFsMDmHCAqtWD8cQo7Ya+0EhHZLttWdcMwcBkcR1ECazRQ3uN5CABSo11Q5oiYR0LBOL+Xm4+A2n2G3sd5+zj+bS/L8axA1m5OhsmTP4p9WTiCgTkd2ihGbdoghv7t5H4K3A3D1TCPlRJrMSAL4hg2+PZ00aHH0hb19uFNYyrEy4/aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xAkk+oEqEJlAVesXvgMSRcJVjPqX4BHGMnU6qzKWiJk=;
 b=m3tWQd5g1foa8SnmHS6/cDkef69j8i32QpYUgQGmuW24ycJQ35KaZKot39ZeOE5E5r8ckKFXKd+J3NInsJ3cM3kDmZEa/JhFgYrfJXTAxfa6XSeDIXUpL0yYakkzwR7gYW8t4BMMKD35Ly8o471TFg9muFXi+PpSfBLXDA0H2LeHIPWzhTAxjti/qvlvMP2W7sdpI7kjnplOpDGOaFVthT8BBkmXLnv6HEDQgynz0ki+o013AvMjo4WJf+AChrZLORFrsdC/RugfSfnWMM0stHZkqjhCanw5oJwPjliMAFUz4k0cwDCkLvkZt0u07GW/PDoiDGvdlNvu84K513UFbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH0PR11MB5217.namprd11.prod.outlook.com (2603:10b6:610:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Wed, 18 Mar
 2026 20:12:56 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 20:12:56 +0000
Message-ID: <06df6bde-6790-4320-bcf1-cad2ab3d473e@intel.com>
Date: Wed, 18 Mar 2026 13:12:20 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Ben Horgan <ben.horgan@arm.com>, <tony.luck@intel.com>,
	<james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <8be6feef-b7a5-4fd7-9bc0-9aeed7ef0fda@arm.com>
 <e334f16f-2576-43af-b64d-013d7a14f291@intel.com>
 <38e5c384-4d08-425e-a4fb-a63913be35ac@arm.com>
 <f37db924-dc65-432b-ae48-ddd986b3efd9@intel.com>
 <d4460f04-813f-4a6f-ad1f-6f2e5bb1c9fa@arm.com>
 <55a9461e-32f8-4665-905e-bc18b7201c7e@intel.com>
 <e7e480ed-4dee-4898-a47e-8730eea2dcde@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <e7e480ed-4dee-4898-a47e-8730eea2dcde@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR06CA0018.namprd06.prod.outlook.com
 (2603:10b6:303:2a::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH0PR11MB5217:EE_
X-MS-Office365-Filtering-Correlation-Id: e574463c-0cef-4398-ef89-08de852abe21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: /QOAQdwTy2EndFvx6G8AZDGYaf0NmEwwcm5BICbBfY6CF7cluKEwmnVFDfado51QdqBFKemPMhr2jIbnKY5X0sJu6WFHiXNd2fEKhWmOWr2xQ7TYwN5O2YIepleaXwmNBWiLPxDrHaRe48vQtcI0gLfHSZGikOxAaaOlvlZb43BhF3iTKVxNNkNwTefZGCdIqaYrEur9lw0S1P7eFUlTLQvZUFTAPC9waITMiipk67FhuJPOE3H2L+8RlZtJ19uZTTV/lrjCUa9wITuI2qvdBjO4vfXFhWBuIYQB4qyh80TSSQMXHnw4XiJ6A90D8aLTvXyybGVCHsfIz1kcfAiJADZIg9tjZDtywPE13LSqTxbFD1zGUW0VahMw/e+jlahwPaYU8P1PFBA3EFMnkrijz0pjxuW4EhLhzqduHrRCv9V4TWCLEuW02+osj2m0aF846RgyJ8U2U74cXl6BHjXKwShdjMwzulV+qr0CqseRpiRfSxiby1fvyiPs/XyARQjSGa7TY/2OHYQhY9m264Forh0Nz2pbna8zJzNU0jib2Vx5TPGxE5KIOPxnuw2bNZMjIWS7pJvDIsYDo4VF/SHCA5rCqnecquowFKW6/pxVXksaTpFudNQi1a//1evwesqeavEJt+qJJI08UNM5flMalek/NCTcPN+AobRCT/vhj1K0EO7V0CmrAOkYv7DtwwtgMMJSANqRDYz8xa7nrFPWANMaituUe/WNCPxmw5L+fLo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnRkZjlzazRpL0dONUwvQUhhMnk1SGtGRm50RXVGSlArVjkvUnFzT2RpVEVq?=
 =?utf-8?B?QnFvUksvY0NBcG1OaFZ6VkI4TUNMWmhWMG01WmVTQitDZHpqZnIvQzJkVHZp?=
 =?utf-8?B?YkVrd1ozNWYrMkx3NFRYQ084cGk4TjZLbFRKMFczMDZTdVhRSXhKVHYrZTk3?=
 =?utf-8?B?c1FxNEVqT1FXaWsxbFBDSnhSM1JNUEljb1QyekVTNTczNlRZbytXWXhyRTBM?=
 =?utf-8?B?QVNlQUs2Q2ZhYWRTWTF5Mng1TXNHWDhOVEd5Nk5UTnNGYnZpeVdqem5uT2NK?=
 =?utf-8?B?TGc1ZzdCeDNrOTNiNzVPaElnaHZ6S1FobWgxUWMzUkhqL3FHOGpUamRWNFF5?=
 =?utf-8?B?QjArMWhDUjQ4RjVMcVd3clBTZnVEMkdET0RyeEdVUlloK2QxWEs1TDF3Rlhy?=
 =?utf-8?B?dWdXN2c1SzlLbUFvbitMUTBRUVdGV1VwbVFrWmx0dW1xbkZSWFlGSld0MklC?=
 =?utf-8?B?Mkh3YkhidmROQ1pFVndaRWE5dGpLWjlBK1lrckV5TUgya0dXSnptUEhvSjgw?=
 =?utf-8?B?dzhZd3pOa3BnOE0zeStlUWFieHVZNDZyNTdJbUwydFZ6blpnTkdxQ0FkaW9O?=
 =?utf-8?B?Si9Ta0E1bTYyUHFVTUtlMElOekxBSzVtbUdYRjg1NlhrK2tRVjZWUEhPSnNK?=
 =?utf-8?B?NUl5K2JxNFFJTjZ3b1RneHYvcXY3UXVMVVQvZW1qdEwxcTNXVGVpTFRJTHRp?=
 =?utf-8?B?NUJpRkkrWTJCRmVyUlhEd2VMRFF4QTVIMHZOOGZEUDRMU0lRVy9DZWJpLzhO?=
 =?utf-8?B?VUNEcEl0Z1E5eDhhc1hJTjhGS1VGd0ZuZDNUaVZVVklwNzQwTHhGaHFkVUVY?=
 =?utf-8?B?RTJOOGQzd20yTHY1QTNkQ3ZBeVI2T1gzdk0vRVVKTEFzSjMzN2FFajNIVjc3?=
 =?utf-8?B?RWx6YkR3ZzN0MEVrMWpqYzJhZWpobzFWMXlNUjBHNWNiRzFQREJiclFYVjRK?=
 =?utf-8?B?SVA0cjFvVUlZTjcvUWM2blZUTnJHc0FncFo0VzBnVDVCTGozWEowQWhnRnlm?=
 =?utf-8?B?SERlcUFjZ3haazM2LzJpNVZTQS9SVjFrZ212NXBETGxURVpsY3k5aWxsNUZ3?=
 =?utf-8?B?SW5YK3k5a0JsQnNseEx1c0NMMGp6NUNSUS80aHplZWY5V0RYenBjZ1lNNVRj?=
 =?utf-8?B?dytTanByeVlFVG1vVTJid3RFdGg1TTFtRG1uUzd6L2Ftb1JPR01hRmVVOHBT?=
 =?utf-8?B?bWJWWHkvZTI2K004V3pRS0xTWXFtRDZ6OG1FZlFwa0hTYk0rb0pZclZDcDh4?=
 =?utf-8?B?M3djOEpaTE9EMFdBbDBMTDRtVWVUVmxQVDBUUnFCSm91UndLcys3RjEzbXNw?=
 =?utf-8?B?WCsyZ3lad1laZkJHV2I0QTgyb1Fobjg1YWx2YW01UDVDVUdUaVRCd0R3eXoz?=
 =?utf-8?B?K0FrN3BidEtqeFU3Z2dPcWc2bE1oQ1pFRmpCL1k5SUVpMmpjQ2lHZHZneUt6?=
 =?utf-8?B?MnU0dGV1dXhXY2tFTi9NSDNKaDJiK2Z3cGV0ai80OXBxK2NWckJHd2tlS1Zs?=
 =?utf-8?B?aVMyMWxsUXRwYWdMeFRQc3hSNFBFeUZGWXo3MHFsRHlhNVQ5ZTBHQnlFcmor?=
 =?utf-8?B?OW1odTRmRTZOa0RpU3I2dUg0NTROZjhrYm1rQjhtNFRRM01ySnUyNG1wc1A2?=
 =?utf-8?B?RlBVZllGR0pRQkczRTJIcDFDM1FvdGtaVWxrQ0Nrd3ByWW5HaGM4dUpqcUpy?=
 =?utf-8?B?MkE4L0V2bDJFRWI5Wk14RExRaDNMbUg0NjVUZ28zaTFiUk5hR1F1cG9yT2R2?=
 =?utf-8?B?alVYcDZ2V21JK2Zld0tVNkErbkVVTVcyem11WjVlYTNxUjBRMnUrWld6cEZR?=
 =?utf-8?B?SFZGMnpidWViSzN5SVJDaVNIM2lHbDhXbnZCMlA5K1ZQV3JWQlpYK241dHU4?=
 =?utf-8?B?WkRZVkNXSEd1R3RSYkF1MDMvQU9tdWFDSG1qMEhyNW1MNHBrdXBadzJENjJS?=
 =?utf-8?B?ZmxjWlZWdEVyNnNSdkV4T1N5a0NwZXd6eS9kTEc5T0h2K3JoaHdaOFk2ZjBv?=
 =?utf-8?B?cXF0RXQ0RXgrRlpRc29MMHZGTUNhVzZvSVAwMll2QjBiQmdWSnJ5bTQ3M2U3?=
 =?utf-8?B?bmZNNkFuRTljZlZuWWVOdW5XZjF4RUFMVTIvYTYyNFRaMkl1eUl3ajlPRXJO?=
 =?utf-8?B?bUN4dVJBQVRieVdyczdLUmdqRTFNRFR3d2pyNFRDbHF3OG1KOU9mL3V0dnV5?=
 =?utf-8?B?dTBjZEFPYTJhdGd5Q0RHdHQ0Q1lmWHZNb3Nqa2NqdEF2d2ZPcGhYZkE3QlFU?=
 =?utf-8?B?OWRTYWNIU0wwVk5OTis1Um9SY0swcnZyS3YyNXByMEJrY24yQldQZW9oRWkv?=
 =?utf-8?B?SFB5R3V1bUJJTnduQnphelArcG9wTkRBVE5tU2lFK1greUh5YzBMY1BOK1pE?=
 =?utf-8?Q?63gyhIXVh/haQsXA=3D?=
X-Exchange-RoutingPolicyChecked: mVN4RgHH3eb5lIvoOwXhy/4AhDyxjlaOx1SXZqozAQkT6kkNXnvatrWmF5EH7+gJSbPm+ln0a2CfxE0gIoeFqL9xRsWtfA3dvMJuDa5PpZ7FeHx0tlmIEP46muk2qBjomU63O3JLHr4AMvHEp7lLjPIEhwele99pEWpCNVPVjVdvPhcWwAGOAqcpcVsFHNQa0y1NcZP8Ph/tTqAgQi5NCcn8t0XqdamPEmj56e66NOFYPv2d+1jJ2SWNgD+8bDIGASYvW4C7afcagKX2R5HC5Ns4QAzzRx2TECwENh71170JqudsijQtxM9k5oeBiUUXMVypx8XIcxl80Zrc6/WIxQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: e574463c-0cef-4398-ef89-08de852abe21
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 20:12:56.0399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wf3VjTuO+7D3KwhARIqrMfeFKQyAX+eW7pCrs3EWKXA+FpZ3Zb8vwwCWcJs6PtjkJWRgCGb0UfR1DKeimB1Y4OuCLiM3Hm2QTxoeEYJnyw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5217
X-OriginatorOrg: intel.com

Hi Ben,

On 3/18/26 10:10 AM, Ben Horgan wrote:
> On 3/18/26 16:35, Reinette Chatre wrote:


>> What resctrl could do in such scenario is to at least convey that some messages were
>> dropped. Consider, for example:
>>
>> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
>> index 5da305bd36c9..ea77fa6a38f7 100644
>> --- a/fs/resctrl/rdtgroup.c
>> +++ b/fs/resctrl/rdtgroup.c
>> @@ -973,10 +973,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
>>  
>>  	mutex_lock(&rdtgroup_mutex);
>>  	len = seq_buf_used(&last_cmd_status);
>> -	if (len)
>> +	if (len) {
>>  		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
>> -	else
>> +		if (seq_buf_has_overflowed(&last_cmd_status))
>> +			seq_puts(seq, "[truncated]\n");
>> +	} else {
>>  		seq_puts(seq, "ok\n");
>> +	}
>>  	mutex_unlock(&rdtgroup_mutex);
>>  	return 0;
>>  }
> 
> Adding a truncation indication makes sense to me. Would it be good to reserve space in the
> last_cmd_status_buf[] to ensure this can always be displayed? It looks like space could be
> made by interacting with seq->size directly but I'm not sure if there is a cleaner way
> to do it.
> 

Please note the distinction between the struct seq_file instance pointed to by seq and the 
struct seq_buf instance last_cmd_status. The last_cmd_status seq_buf instance is backed by
last_cmd_status_buf of 512 bytes which is printed to the seq_file instance seq that is
backed by another buffer that starts out with size PAGE_SIZE. So, it looks to me
like printing last_cmd_status_buf to the seq seq_file instance followed by "[truncated]\n"
should fit by default? This should keep working even if last_cmd_status_buf size is
increased since seq_read_iter() that calls this show() would just keep increasing the
buffer backing the seq_file (up to a very large limit of MAX_RW_COUNT which is INT_MAX & PAGE_MASK)
until it does fit.

Reinette
