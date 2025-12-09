Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D7E30649D
	for <patches@lists.linux.dev>; Tue,  9 Dec 2025 19:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765309206; cv=fail; b=ijrPaP87ZzJi0cFYDvDI883plvMQFYxFtvACZcIrvH7Y6POT16SUbkZx9wzeQcZ9/ogaHOUWSk1bJcRqu77zHirH6Vb3izdQwd5yPISYuZnEGKRqQXJqCcZgQdea9v6SoUxtzNhW2e+vHujOuy7fLgfWMSoSdoWBpATpEkucOzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765309206; c=relaxed/simple;
	bh=k9l29h/BkZlIsnwadcx2lXPDjB1dUjzzEcVSxyfp1dw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=XSUtyWSzAICKOEYtZ5v2dJS/kXcAPiwZUWgASgABay5Ndq+AwL1DsaDoKKOxTmvjp1hHOyek4UGyZ/qABBo8/jtr06QwClN/Hfe8K0dPj5PmYfYcO6FZeqyfHj//TReMW7H3S023m/Ur8PTCFifncVkftpKlAr8qIBhPpMWvsoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OXiW0vZb; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OXiW0vZb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765309204; x=1796845204;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=k9l29h/BkZlIsnwadcx2lXPDjB1dUjzzEcVSxyfp1dw=;
  b=OXiW0vZbRIvmU+Y+m3tgQEFXvTscpL4vDwDqsvpc7UVtV1qlvsFTQTzr
   QhTG1YvJ0+mF5Gv50CiIP6O4nZg6vRlR83VLryJ6PIuS2RH6xD+hOLce/
   tYiLRo3s0bgUQyuxfrm8/SVIehTGX7lbk08Z6K1xE0J+0OFLXwBBtECDY
   N4nIH0BGzz4VtWfF9Vvjx2SFTe35NdGubCBo8+zjN7lFfn//lfbMQABUO
   jzsnY4uJa646r1qSdSKOPiUU9akqiQuUCYG/J6aX16nqgYa68RXo1mB8x
   R/tR1+crybh/QXOhOEU1XYSJIxSa6tPSv9Zu26Q+0o8bnDWd/I4QBVsx0
   g==;
X-CSE-ConnectionGUID: mqYf38IcQ9Gmq2noQy/6sg==
X-CSE-MsgGUID: 5w4MucixS9C8ZQ54a6AsNg==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="89926520"
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="89926520"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:40:03 -0800
X-CSE-ConnectionGUID: ZpwoPx1ZRFu4I/8zBvNMrQ==
X-CSE-MsgGUID: FZbYdic4Qh6B/H7nWCaeCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,262,1758610800"; 
   d="scan'208";a="200480341"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 11:40:03 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:40:02 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 11:40:02 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.11) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 11:40:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nFT8ZrlUSOygNHJeUBfpLrJMiK6ICD44VVWuEyYH/ZedUoC+4mhXOLLJ6NpK5XvWueVPAGhMKC6d4hCqEEnxGjHN/VraIR5uK3jY1QkTWLDpLLh4noElqJhi4+QbA9TjyuOQSDhDrjiAAznrDQE6OVFuRBnHLeQKtQh6o0syO31R/iGI0PJCh3otSff1VB5iy7p6NsukQCfQZwcaows2D/U7CL7HnWtc9iMDQq6baqIyPSJsOuZAWeAXuYyj78rcdh9+//ImJMX45Z4IAmVVHRzBp0cD9ed06wr/Hpp6KHNkPvNfmRhjzjnv5EKE6jCPQr5riK7DTKlwc63w0EO4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x5lBnGpz88FItLj5rInhjhvZjoeICU+G1778d/TkyFc=;
 b=GvbLFqNd5HnfrgTMyVUOAw4bjkoqbMKdox5BW1V5WWsvyAftioVENC7eUIe0rjGZ95bDL2qPWx7zGT9Y8yLciHA4UJU3ASzwFXFISD6BCe1Nu0YIyufnqMvbDrbFtmtpIpJZK9XuYZO5Zf40LUNKsR1KVoVdQ/dG5lPZX1dg7qgYWhdd9Iv0wn++VjO/ieUDmkizwzR/Czdf9B7v/eMxBE5VQZRCNv/zA0FU2L2zWat8ya3YqTVLpbz+nKJ4AATFNOUol5bzjLmeLdFbatLRdEwouxwkQ6+rl5fvDnWzCkYZ1X9YKgVECNyqwjr4B5hgWEB7wJp2dXtgBUYc38twdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB8027.namprd11.prod.outlook.com (2603:10b6:806:2de::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Tue, 9 Dec
 2025 19:39:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9412.005; Tue, 9 Dec 2025
 19:39:58 +0000
Message-ID: <34dfe97d-3aa0-4fc5-8f1d-3da5066a0b6c@intel.com>
Date: Tue, 9 Dec 2025 11:39:56 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 11/32] x86,fs/resctrl: Handle events that can be read
 from any CPU
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251204205404.12763-1-tony.luck@intel.com>
 <20251204205404.12763-12-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251204205404.12763-12-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0224.namprd03.prod.outlook.com
 (2603:10b6:303:b9::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB8027:EE_
X-MS-Office365-Filtering-Correlation-Id: 36d0296f-3b6f-428c-f884-08de375abcc7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cjhJVWttZnJUbHRUdjdESGJVdnNKdU51S0Vqcm4vazNMN1Y2Sng1Z2FrVkMx?=
 =?utf-8?B?RDFUcWo5b1ZkazRRYzR3bkkzcHByeTUxb0pwMERuQWllUlBwaG5LTnZEWTNz?=
 =?utf-8?B?OWh5VVRJbzVtMjFkeG5OZlFjZFhabmxwb1dWd3hSbWZ2OFZ2bVR4RGdiWC9k?=
 =?utf-8?B?b3dPcWxwUkRWeldUY1lDU0E0SWNYUytCekxGc1pPU0kvTHlpRmRBaWszTmxq?=
 =?utf-8?B?YzJBOVNFc3BxT2YzVGxQVFRhdXFKdzV4bWtBTmNrRWRyd2VNdHlidy94R2py?=
 =?utf-8?B?MGp2aVdCVEt3aEVlOVhtbFg2K1JtUGZQcW1QNUtNdGc3TFh6TUNPNVplc3FF?=
 =?utf-8?B?Z3FXUmtGTmZiNG82THFVRVNsQVVXeURNZjlDOW1hZ05JcEhkRzJOa3dCVFFk?=
 =?utf-8?B?azNpWVYrT1NPd013WFhQODg3cFdtSXV5dTNaQ3ZmTXNrTXhWeC9sQTQvTFMw?=
 =?utf-8?B?VkZaV0o1dUdMS0drZHhieTFqV2ZNZ0libXpCVEZEcm5jZ3hxOFNqTGpHVFk2?=
 =?utf-8?B?eE9GdTVoOXJRVXNSUnFreWtaZlZLRFEvNTMyUS9VazBpU2MrSjlmYVdCVUNz?=
 =?utf-8?B?TnpORlBhZmJuQzlpcTRVaHF0Z2hSMWxvR0p5ZXZGRGVieUlmUnZyTGI0cy9R?=
 =?utf-8?B?N3VZb2xVNzlsempsQ0xUK1ZCYXZlMmxkM1NtT256dlE2L1ZoVURHcFBQak1X?=
 =?utf-8?B?OW50VExNTm9ZdGJQbFFEVDJ0OFlvMUhDbHJ1cTBaTlhsSnJ3ZWErR3Z3OTZp?=
 =?utf-8?B?c1FGa3RUcTdKMnhrMllrdU56VHRweVh0TE5rRTBJTkVySnU3NWh0d1pFQlhK?=
 =?utf-8?B?SDF6TE4vMENvUjZLcFc0a2hpemhCVTNtVVNIM1YyMmZIZXViN2NLbmdNdVV2?=
 =?utf-8?B?aGVFTklHUUdrZlY1Zk40QVp2RW5iNWJPUzlVaC9TMzY4NnVqSGxkSi9yZnBI?=
 =?utf-8?B?cVU0NmorRCt0ejQ3dnV5N3lxWWROZ2Q2WU5mQ0lQeXkyVGl5S1Y5RVRGaVpQ?=
 =?utf-8?B?azNPdXNUbXFmVno0YkZHVzZyVklsTm9jWFcvV2VqWVlNTDZqWFRWcmJqczQx?=
 =?utf-8?B?Z3R6ODErN1RKaExDd3NSMktoWUQySmRTak45VXJRSWVsS2NnS1lxeEVNZ2ds?=
 =?utf-8?B?S3NNOXhkeTR1dStVR2w5OW9kMW1qMFNucmFkNE5uM2xMUmZybHB2VW55M3Bh?=
 =?utf-8?B?UnovOHlGdVp4a3E4V1ZPa1JGa2hObXRsVmVwTXBMWmI5djVKVmlhQjlBZ2dx?=
 =?utf-8?B?T0ZJQUFpWi9udWdXb0o3c0dQYS9uNEMzcDVEL3pZY1V0ZEZSeFVRUlNNb3FZ?=
 =?utf-8?B?ems4WUZlb0pBTlM4K1pGSThPbmhxSVIyeS9KQ3Yva2pjWEswcy9GSCtaMjJl?=
 =?utf-8?B?WWJoV0piTVpFcndlVUJ0MWZ0ZWVCZkhtTHRhRllaRmI4T2VKV3Y1UkxyZ1FH?=
 =?utf-8?B?VXRHQXNUZDZVb0Q0TkN6NG1paTFaNlRhNDdsVlVSci9mdm4zcjBnNloxS2lO?=
 =?utf-8?B?bnhSMTlXelpxSWdiUWp5eDE2NEhpM3JFMStPeitFSUJJYmg1UVV5bXZVbC9q?=
 =?utf-8?B?QTNoWE9JNFkyL2kzbVZNRVcwL21UU3FlNU1ZenhnNklKYlVLdVVuNGRQSHdt?=
 =?utf-8?B?OFRDTUMxOEdnNzAyMTZJZTNncG8xM25iaElBTk9XUWh5cjFsODJiVGlPNmVJ?=
 =?utf-8?B?L1piSmY4SmZZUFFQWnJ6VHN0VXZMTEdncnEyaStleCtRUnZEdnBDTXFQb29Y?=
 =?utf-8?B?SFVxQUx2T2cxeGtxVXpya1N0ajBZWTRoaHp4ODE5M0dFVjlNR0N6ZHFTbEp5?=
 =?utf-8?B?cHdvU3NtTXFtUzNlWGdBRHNRdVVUZVowVkh5YUxVTTRBRVhaeEhQdjFuVERT?=
 =?utf-8?B?Nlorb1E2aHRyTVZEYW84eGNQVFFMMnVQTCt4NUVpS3pJMWxDVEtsUHpia2kw?=
 =?utf-8?Q?mYKQy1nzIbz+nSz7mUQ146GYl/zJv9Aj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXUxbXlGWVIvTGhmdmJHVTZIYkVTZ3lNRGduNkxjaVE2RVpLZDdWM3haM3gx?=
 =?utf-8?B?WmFpRGo1TThnRzZJUWgrUUkzQmtVcms3MDVQY0pRZW1KQTJoSk1rQUs0YzNh?=
 =?utf-8?B?TnZaWWxtaXRtdi9MQ2tSM04xd3c4a09PVkc0Z3hBLzNnUGg1cEh3SnB1ZEoy?=
 =?utf-8?B?NjdvWGZPekhXWlZLMVQxWUhPb2ZLYnAzaVBIdWJiQ21ublgrMkNjNHVnMk1S?=
 =?utf-8?B?enozWHZlcG5YSnI4TGVWYUUrbit6UStmaXkrQ25tcFVMbjBEbnNSdEZWWlZu?=
 =?utf-8?B?UzdqL2NNYjhKdW0zSEhKWVZIcUR6QjZGL1ZHYkJZK3VGNVowQVJlOFhCZFpP?=
 =?utf-8?B?MlM4S012NTJYTTJ2S2diRXFMd3R4bzNsajdFOGEvZkxJd1hGaU84aTFlN1Zt?=
 =?utf-8?B?L2pjaXB0RWNjdU8zRGJHRzl6MGc1MWczcnlOMEpoVkFOV1hmSUs1RmZkVENQ?=
 =?utf-8?B?UlRJeXBvVS9lQVVnQUZRN1Q2RzkzM2VTQVpPc0cvWkZUQ0lQNElETm8rVTZX?=
 =?utf-8?B?M0Jqb1J1V3hrUkdvZVVYSWExelJkaXdhRTlScHNXUGJ2cTFKRzhlbnVWTjE5?=
 =?utf-8?B?TmRtNzZJMllzN24raHg3dlRROHBtRWVTamtaR21BbGEzN0txRnA5OVF6MnEy?=
 =?utf-8?B?TGtSSVBXT3ZMMGNGcGNsSDRma3IyZzVYMTZ6cmc3dXZJbVVKeFJjSGhpSlgv?=
 =?utf-8?B?VitrUlA0L3FWa2VDUWE3U09zcnkzOS9MNEcxWEpIclFRK2RXbk5oN0N1K1Yv?=
 =?utf-8?B?aE5qSHF4V0JmYjlYb3NyTzR0SGhpMkxHUlA5K3VaQk5oS1hoSE96S3VSUk51?=
 =?utf-8?B?bXhRVUlNemNGVUpySzVJVDNCOE9pT0J3OHBOeCticTBZaVZFRm92L1JHZGNQ?=
 =?utf-8?B?OG05a0ozVndkR0xVMVQrOUp2emQweTI5NmtjcmxtQ215SGt6cTVncjR4T1E4?=
 =?utf-8?B?cUZwcE53Y2pSOTd5S0FmNm9pRFJYSWV2bDFFS3Fnd2FoYTVjMVRUL2FUMDk1?=
 =?utf-8?B?bDhqQVNhSkxXSnhBTGdIcnhYM1RpdE1OS2p6VlMrTEp0a2RMNk9kTDc2bFJp?=
 =?utf-8?B?YlJ2UTlKbS8wdk9paDRvREwvc1NpK3hPeWR3bXJFeHExNTcyc2dORlVHSmZH?=
 =?utf-8?B?RHFMMWk0K25OVEZla3JxRzR3SFQ2MHQzbE8wV0ZyajA4a3pIaUxLd3hoM1lm?=
 =?utf-8?B?SWdvWk9ZRUVJQlNQTFppSStOUWFva2kzd1JKZHE0VitlT1NNREZQTUd2d2Nt?=
 =?utf-8?B?TDF6Z004Y1ZXcmtXWFZZWTlGbjcvVWJzMVpGY3BrT0VrMHM0Vi9ZdktHdkt1?=
 =?utf-8?B?STllakRPaExleExUUGJlbGxoRlNoQ3prYXJZeUFQeWV2UklZd3JhTVQ3MjBa?=
 =?utf-8?B?Y2taY20vVDUzbUk1WXM3VDEzd2h0N0VHcklOT0RtWE9mZ0pZY09HSnk5aFNF?=
 =?utf-8?B?UzE0blBiVnRONlFFN2g4NTZuNkhuZGo3ZWxxR3ZqQkxtRW9FbU1DM1NNTlNj?=
 =?utf-8?B?a1o5eDl0SkdZNmJaQ2VTS0lDNVJFTXo0a1o5VFJiMHpOQTBNUFRreGtiS01m?=
 =?utf-8?B?QnlPVHpiaitEaWY0Sys3YVhWZkw2enZHNjM2RWdwd0cwVTBBNE4wQ1VJc1Ry?=
 =?utf-8?B?VmdIWGJnYWZYcE5pdE5nZE1TK2tva1VucnViUGgycjRmYWoxN1dnWUVtR2tE?=
 =?utf-8?B?RUFIa0w4K0FCTktrSndEbUoxS3VPUzB2K1U1K2UxUVc1Zi9WZ0xhWThtYkx3?=
 =?utf-8?B?MEdBV2dTY1FmaklKWTF0bGhSSUZyM0d1bkYwVCt6WG5LSUExL3pscDFsYXdj?=
 =?utf-8?B?MjMyTWI3UG9hQjI0SEFWKzdMZ3d4djBqZGg2WWVzaE15WDlFTTg4TFVKaE1S?=
 =?utf-8?B?dWN6amFNUkphUGxCc2NYblZWRkV6YXN6ckM3dlRhNGhxVTJHaE5MWVlqcUpN?=
 =?utf-8?B?NVF0SXoxU3lPK1l1ZzRVMzIremRLQkM2SWtIQURjRldpSjI2Wk9JajA1d0h3?=
 =?utf-8?B?V0pOUk5IQVl3TkxkcGNidE1MakV2WmQyLy9tb3YzQ3owWUcrZlpWZU5PYlhH?=
 =?utf-8?B?VDNtL1c3ZmhRWXNMV3VKc2g0dVgxVlFRTDBzS3MrYnlpMlNGNzBDNzdHOUZj?=
 =?utf-8?B?RHcxbWFuck5UTzNjSDkwOFBzTE5BSVdFZ0F0ZnJ0dHE4ZDJBSjd3T2dwYW9Z?=
 =?utf-8?B?V1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36d0296f-3b6f-428c-f884-08de375abcc7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2025 19:39:58.8361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OsVbl8gnqEjJ7i0FPE+xv5pCgaYkGK8ttffi7v3jvXeK5HdsGG/s2IgCx1bBg6RAiHA/JCgTwnq/Avjr4c7F8LdidqSRYOVsrdz5+/2dmnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8027
X-OriginatorOrg: intel.com

Hi Tony,

On 12/4/25 12:53 PM, Tony Luck wrote:
> resctrl assumes that monitor events can only be read from a CPU in the
> cpumask_t set of each domain.  This is true for x86 events accessed with an
> MSR interface, but may not be true for other access methods such as MMIO.
> 
> Introduce and use flag mon_evt::any_cpu, settable by architecture, that
> indicates there are no restrictions on which CPU can read that event.

I propose to append (something like): "This flag is not supported by the L3
event reading that requires to be run on a CPU that belongs to the L3
domain of the event being read."

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 340b847ab397..081ff659b52c 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -518,10 +518,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  {
>  	switch (rr->r->rid) {
>  	case RDT_RESOURCE_L3:
> -		if (rr->hdr)
> +		if (rr->hdr) {
> +			WARN_ON_ONCE(rr->evt->any_cpu);

I appreciate that this addresses the feedback from v13 but it needs to be adjusted for the
code changes made since then. This means that this warning applies to both
__l3_mon_event_count() and __l3_mon_event_count_sum() , no?

>  			return __l3_mon_event_count(rdtgrp, rr);
> -		else
> +		} else {
>  			return __l3_mon_event_count_sum(rdtgrp, rr);
> +		}
>  	default:
>  		rr->err = -EINVAL;
>  		return -EINVAL;

Reinette
