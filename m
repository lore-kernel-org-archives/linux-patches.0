Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F5A8634F
	for <patches@lists.linux.dev>; Fri,  3 Oct 2025 15:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759505650; cv=fail; b=HK31n8DP4Ap0zZFRkEeiDyRrPuvwUz9i+/00RujoxVeXelLUBCppVX5/bsDY/cOrlN/8Lz3rJC61UR/zN8GwF0VWu1OiddQVr91HngBJ90pXo6nN6Rn1uaGQWRS4KT8zm+CqHKi4fVgtdO6+i9idUE5WUDTI1eqMY1n18I7DGIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759505650; c=relaxed/simple;
	bh=wFcUGOt2nM5igIZ419aGu7QYwpDqEUYTnQ/q87m8xOQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KVH46+ebmAg5sAHU8YsYAcoFSDtMArT4JjOFfkj4VwWY0Tua5kH/RpSQV5rviGTpRn2Li1Ux1Aud2hxC3EcralVyRgKHgNHOAZiqIe+t5wqbFqGtgKFQiQk85mw68hRAtctkSMdxNGrXxFkWcI43fBER3OJTc7vvvfA8x7XsyUE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z1MCdK6u; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z1MCdK6u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759505650; x=1791041650;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wFcUGOt2nM5igIZ419aGu7QYwpDqEUYTnQ/q87m8xOQ=;
  b=Z1MCdK6uSDuJnXMqBDdf3RGfXW+CxZZcvR2jZenKokNMz7UBueCCmCHI
   7aD7GgWaCcnzGd1CIRAZyQkx1OxdY6Kio7RU6dZn/d7XwvaD723PeZHdc
   bZsWXF51FLWWHl3abj09dSG8NKNy7d6ENi8Pte+O8zfqD1uX6dA+7T/vJ
   c0qlsSMy4L9Gry54OkxHJ8fcZLX5enrVV9KUg0x8nJfJxIdENYSFtrTBC
   ahPv4LCXwu7NuaTKxwv7wklasohWkChPOYx6Xif4Df1mlojHKg9nj6DLG
   D3DxlnoeXzdaBql4+Jt6gdaKLq748zi/90AA2a4MnJEvBrG+BudReLXxr
   Q==;
X-CSE-ConnectionGUID: ln8uwClcQci6WTon/LKiuw==
X-CSE-MsgGUID: ey0xDBGKRe2lAu2nRec2hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11571"; a="73217835"
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="73217835"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:34:09 -0700
X-CSE-ConnectionGUID: 0p+Ww4xHQTyQbaMbDJUspQ==
X-CSE-MsgGUID: rbzmy+NsSOa+duTesgVH8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,312,1751266800"; 
   d="scan'208";a="179332816"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2025 08:34:08 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:34:07 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 3 Oct 2025 08:34:07 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.63) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 3 Oct 2025 08:34:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rTEUVWCvD5vauEJU3q5Ir+cf1q1/wErOQHadLZRnKsyaMawgaJqxsyGqg1OcW1rsZURBdTPy4iT/PKFGNcOBuhfy8jYK3IelNhuMewnYeyF3wORBWLLFvdb04tPDFCsPNAJPtmZmVXNxSiX7dctNVQiU7nk4DgNP+3Lu8P2Rn0bHFIXp7JivMwsphkp3Jto98J97FCQr4LCWPMg+2aXufqAnbMlT1ef64+CQuFwpwiOoGmlLOsdGbXbW55YAjH+5CrB7XeH5vIvJJKO7NR+1wbAhUSEFl832/o/jTf645U7QKRG/llzyE1TiTUcfULtXG+cYWvNs90JT5eGkxWefeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0x2xM1bZTDoaHVGUmBsAWuDV3dfl15aTLuUk1Mt1Rfk=;
 b=sq0UXzgS6lRAJz3jUKbK4R1Vt0M/zO1qxtQa5PLQ9J9sDzp3QD/EDjbYUgFg8/3/JLMi36Om+CUcrkbrJ1WyopmPe9Pr1ybgGDiHXl9NF8uVdepYo/MEv9YZRkkAvqgQCEYBuXcTprdIB1qdHIiLfC6qOPcTJrreTxQRDPdh9UttpXBEqI3d5+6G5/OBZpMUUtqXygymSi3tyBdCannw1EfxTJeo4Qc77NE//T0rreIqkwlt0r6dbIrKwRIKHmqKB7mW7OPGmVwJLuMs71+9zMQUchS0ua8L8xx/yv+j3iPCt3o0AcErRNVStbeFI9B/IvFyhpKjRnlIuPTDAbjksQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.17; Fri, 3 Oct
 2025 15:34:04 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::2b7:f80e:ff6b:9a15%5]) with mapi id 15.20.9182.015; Fri, 3 Oct 2025
 15:34:04 +0000
Message-ID: <f5a80f3a-1aaa-4831-a9f1-7f3eca748dfe@intel.com>
Date: Fri, 3 Oct 2025 08:34:01 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 06/31] x86,fs/resctrl: Use struct rdt_domain_hdr when
 reading counters
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-7-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250925200328.64155-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW3PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:303:2b::23) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|CO1PR11MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: 7f2378d5-add2-4c83-f0a0-08de029248a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cXNmUzhtTWtFWVFFS1FhNkV2K3RWS3VSNDRIZ0E5M1BKODZxTk54OE9YTlZr?=
 =?utf-8?B?ZWxtRUpuS3hRb0hENExqWWIxMG5pOUgwSktHNTZaODBmUmRPVFIvd1NiVENk?=
 =?utf-8?B?RWVjYkxqanRLUHp0Y3p1QWExRnRxY2YxK0JSa2QzUnlNUGplejBlcXJ6YW15?=
 =?utf-8?B?b1dIVVlxUzcxS0k0MlRDYzdnK3FidkFPQ05zZzdha25YcWNVekFyTDB4SUFK?=
 =?utf-8?B?MURJcWhTaGE5TDBWcFAvczRXaXJmditTR1kvNVlvVWMwcTRmSFQ1dTRFcm1Q?=
 =?utf-8?B?NDI0VU9KZDUrWnZSNEtXU1RnMkpnSlhhNXdiMEVKTG9ZRnhpa3hoWDB5Y1Nh?=
 =?utf-8?B?OHduSEcwQzRpWVUvZXZ0Q3dBYmkxOVFJUCtnUXlrL0ZaSE1KUXZ6T2pWTkJH?=
 =?utf-8?B?Y2tvS0d4bzBNTU5GT0xoWWdyeU1Cbms4MHFCcTV1djRucFFvNmNFR0ZWOHVW?=
 =?utf-8?B?SUdRZXNuNFh1T3V6UHZzbjdGN0VReXFDYWFxRlNJRGpwWkRHMEU4MGVLM3Bl?=
 =?utf-8?B?UldwU2huOVVXK3hONUp6bStoVkVjN3VrVU9jTTBjSEJZeHdtNzlRQ0pCc3pG?=
 =?utf-8?B?REZNR3owS2M5L00zWXRkazZ5RG9CTmp6Wk1CSjk0RGs4RmIrbk1jR2VSaFl0?=
 =?utf-8?B?Ty9PNWVTYWdVakRyNlBCcmR0ZFNWK25yLzBXVDdWYkdZcStoWUNCZm1MV1Yy?=
 =?utf-8?B?VGdTdVo4WGlhbENocVc5Y2Z0TE13SmhUWWtSTHZDZEZlcCtOZ2YyM0VGc3Er?=
 =?utf-8?B?SE1JUHJjWFJyQTRZb05aQzNrYThTNGZlb3JKTDZRSVU1dWptNTgxSVJ3ZzV2?=
 =?utf-8?B?andiUUgwSVk3RndOSzdxNk1mdkF3SStvN2x4eDNSUEZLZWtVQWNlZzVRMzgz?=
 =?utf-8?B?VGdUZlc4djVFdlNFNHN2L3dRQnhhbGdJNE1HNmlnSXAyTHphRHV4LzZTYkhZ?=
 =?utf-8?B?UzlSQkFsckRQRTlRQUs4Z1dUUDFDVi8zYXl0T0FCNW4yRVB3anJUV3VtUzNQ?=
 =?utf-8?B?dVB3V3hyYnZOTklQbEFlejVVYWdQUTNYMDNoNE1xNC9Lcm5nRStNWUhkZzFI?=
 =?utf-8?B?SUdvOXl2TW1MdElDM2VqcW53Q3FQVUdUSFo4SFY1QlVEY0NRd0lSWU96TUZx?=
 =?utf-8?B?dE82cDR6bFE0c2tYSnNGanltdGQ1M3FPbU9WYWh2NkROWTJFTldtMFFZZEto?=
 =?utf-8?B?bkE4TDN0RzMyMnlrMnFGbnhNUjdpRFh3Wjc0NTBsUEROMm5NU3NRQW4xMGZO?=
 =?utf-8?B?N0RpdmM2QklPL0xqbFpXTnhkY0dFYk1RdTNpVUdNVHNjTTIwTnNZWi9xeHBR?=
 =?utf-8?B?K3hvM1BTTDFnYzBjZnBvWE9kZ054b0puaVEvZE91L20rSUNPREpBSTk5dFd1?=
 =?utf-8?B?ZDZWMGVTUmdrRHcxMEQwR0xieWI1SHJkM25pM0pLZVQ1NlB6VXJITjh0VVhy?=
 =?utf-8?B?b0Iva2pTSDBlelFtU2IyQ2dIMWNEVDZVNFZSZnJKUStMUHZpcm5vL2o5S25G?=
 =?utf-8?B?S0Z0VEFLUjFpS2FSaTNCb3NXWGFaZ0sxOU1YbFFUQ3BSdGhlVm9FdVJCMWg4?=
 =?utf-8?B?ZXJEZElGMzBCVktrWGs5TFJwNU40UE9rMjJNV1VmRmcvaU9PMDUvbXJ0bTBM?=
 =?utf-8?B?Z2JnMWlaQzEyY0hBZFZDd1dSaUw1bXRLNFQ1Ynpoa0tieWVCU1lwMXdHQ2VN?=
 =?utf-8?B?NGZwb2ZLTE5GeWY4MEs2aEgvWjFuanRhNUVoL0M1emJiaFRjLzZnYjd1ZU5H?=
 =?utf-8?B?VzJ5ZDBuUzgyRXZkN1UreE5BYlAxNE5sZ1VnQUZOVy8rQlVzTlkwYWRqdmdt?=
 =?utf-8?B?RHkvL2lPYytQZCt6OVJYeFMxRld2YkRKZlY3MXkyWE5qdk4zVXV3N1phdjNl?=
 =?utf-8?B?d0NUdDZtTFQ2bVJycnd3RjZFcHNzTHFZVXVxTmxlTkFuTU9XTkluVzh2QW1h?=
 =?utf-8?Q?GIxf+yBNUgs0Hf7gI5lEYyH9GOqb+DxL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V3RvemNraXNVQWQrWGFUTTFPYWprV2N3VjliSWRJOG1ZWllOSGJvaFFXdnFX?=
 =?utf-8?B?Ynh4SXBoN0FicERvaWV2eHJyZVlWMDdpcFlqS1VSdE5hMENBdG85cVJuczVi?=
 =?utf-8?B?eUhHVmVNcThzRDZLWjk2UHRwVVZQT0dZd1VZNGRPUVNNenZEOVJ6dVFuMTlL?=
 =?utf-8?B?Yk90ME5LVXA0OXdlZGtJRFVDbGU2Q1BhSzZNaVJ6SzFTcmVLUlQxYlFMOWh0?=
 =?utf-8?B?VC8xc1JSODFrcGJITW1NSVpOMmlEZm5PbHVlU1E2N3FDU3dJNFBEa0VEZlht?=
 =?utf-8?B?MUIwN0xMeE4yUlRucEl2ZG0wRVQxSFRGTTdWdmNrUHBTckVrSTVUMC9mTzhn?=
 =?utf-8?B?MEpPYXpJMzJLVDA2ZUhIdTRyNlA5Q2NPZzRoNFFGSTlMSGRKN3o1L2FybmVU?=
 =?utf-8?B?TGFNOGVzb1ZBd0ZBZHFkM1Q2bStKM2phazh2UzhpRVh4VUF3Z1ZaZ1JYenFu?=
 =?utf-8?B?TGhIcHQ5U2hpWExDRVRaOXJvMXI0dys1bUd4UjAxV1B0d2ZaZ2F4N2dFSEJw?=
 =?utf-8?B?alM4SjdRRENWL2pybldnbzJDTDQvYnZ6Y05YUFZSV01mTXRVM2k3RmJHTVRm?=
 =?utf-8?B?TjdrVjNGYWZMUmxOY2ZidG9YTWZvOUt1SGxWVGV3UC92MmgrWk83MUYwRWd4?=
 =?utf-8?B?VnNXTnhYdi9jZURXMXRWMi9tZFBDL0k5NlJDT2JMUWo2QTZnb2xNYi84WlNL?=
 =?utf-8?B?Tm82ZlVyWW0rMGs0Qk9ObDJCcVlJQ25WeEZwMm4xdVArNTE2a3pyWTgrRUJ5?=
 =?utf-8?B?ejNrT0lCMktwREMvOUdxRGRLdndzYkx3b3RzMlZBZXgxdm9XQ0FJc2xMVHJP?=
 =?utf-8?B?QTMxYVQwdTJVaWNaa1I3RVl3eEt0eXlRbkFpNm52eWhpU01Pd3Z1RHpZVC9K?=
 =?utf-8?B?Y2d4SHJqS3k2T1JLelhqSmxZdE0vQWZPYkEzdk9jV0tvMlU4a1VIbitXVGxi?=
 =?utf-8?B?WEZBWFQzQmZvMlhwWndtWHIyT1N2clA3Q0JPaWJyaVhTTFhxUWJ4aHpQeXlk?=
 =?utf-8?B?SmFEaWpxTlpiVlFLdFAxOENJZ1VtU09Yd3IzYnVvN2RtMXE2dWw3dE81cWtx?=
 =?utf-8?B?dHRRdjVsWHp5MHBEZkMxaHIzRGdkV2VudEptKzhJM1pNRmlaaTVZTncxU28v?=
 =?utf-8?B?eDNKL1dKTnJBeHJTVnNCOWVBZ1RGWnRjRzRmRm1VazY2MlJDWWU1QlpzS1p2?=
 =?utf-8?B?Y21jZEZNL09VRnBRU2J3QjR1Q01wR1g5MjFMYkpjRmtBVzhxbzY4N1BQMFZR?=
 =?utf-8?B?OVN5OTVhOUYvMjlSc2lod2RSOCt5cTRtdDNsbkJoZ3pWZlRKWHFTZitNaGlP?=
 =?utf-8?B?aE9rK085YjVXQU0raTlNcTZ3S3ZrR3pZSWFmSjRXWWxoc3ZzMkp1K1NtUmxH?=
 =?utf-8?B?SEtueXJVWmlsVUFsTXFvZXRsL0NKOEcxRUYxVzFMaWY3Qngxbjc0TDA1cXVw?=
 =?utf-8?B?N2xESUVyNjU4ZjcvL1JXc3A3K2NpaldyMHdiTlNXQlIvbElwQkRsWm1qaFlz?=
 =?utf-8?B?N0JqeUszYTk0OTVUbkQ4V0ZHK3FPMEwycnBGMUZTV2ljZjdCdkRFNG1RdWNO?=
 =?utf-8?B?UmNKU3YrbHBRc3ZGVmJGdXJxUHo3YjBzeGNMcmRCVmZZbjVYTEw1M0pQZUQ4?=
 =?utf-8?B?SmcwNC9HZTNJRkxkZG8xYlVFN2pjNlgvblJleGdIemk4R0ZxMEI5RnpXd0NO?=
 =?utf-8?B?M1luM0paSFdlK3VTWEhaZWJFdkVhSVFRSzVUcmVIUm5QZGx2eUxtdVRnMktO?=
 =?utf-8?B?Ky9CSVoxcEtWM0ljSVp6ZjFVN2NLYVBrVnl3TXkrWHlNbDVOTG5yUDRrS05h?=
 =?utf-8?B?aVU0eWhhZm4wdDgvSFdHQ1MyRm1BTE1iOGRya0JxTm5nZ0o5ZTlCZFdDODZO?=
 =?utf-8?B?VzZnd2h6QktOTHZNQWcxQThqYUJvYnVKYWIrZFljNnZQak9EN3dDYk0wYkE1?=
 =?utf-8?B?a1YzQUdzd2xVcUVQTG1veXNZcEg3VWZBOTVHbk85bTFMMEFHdEdFcHpXQ2xX?=
 =?utf-8?B?Qzc2dmhMZW5OK0F1b0NCM1JrZGFSdVl3UGtsM0E3b1NmWTBjRHlESWFYQy9O?=
 =?utf-8?B?K2YxNEF2eXRBTXhmdVVOUWUxRUp5cG9yOFBtSmg1OGRldDRBRG00RlB0cGFt?=
 =?utf-8?B?VktHUTRvNnU1YjZYSmQrRVExUGxxOFNETlhtTXRZZThBODBNQWRCcmI0clpq?=
 =?utf-8?B?Unc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f2378d5-add2-4c83-f0a0-08de029248a2
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2025 15:34:04.2189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3sIaxMR59AMXX33Y2fXKmA4bSTnDYeqkeWCaWiI+aMxyoJcZFlUgVrB5vBmc45RRlqIVUu0I4Lhuybvx+cq7Ojg8Ur2mn4wcJ2Dhd+Es0Hk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com

Hi Tony,

On 9/25/25 1:03 PM, Tony Luck wrote:
> Use a generic struct rdt_domain_hdr representing a generic domain
> header in struct rmid_read in order to support other telemetry events'
> domains besides an L3 one. Adjust the code interacting with it to the
> new struct layout.

I'd propose a small amend to be more specific and not assume reader knows
what rmid_read is used for:

	struct rmid_read contains data passed around to read event counts. Use the
	generic domain header struct rdt_domain_hdr in struct rmid_read in order to
	support other telemetry events' domains besides an L3 one. Adjust the code
	interacting with it to the new struct layout.


> diff --git a/fs/resctrl/ctrlmondata.c b/fs/resctrl/ctrlmondata.c
> index 3ceef35208be..7b9fc5d3bdc8 100644
> --- a/fs/resctrl/ctrlmondata.c
> +++ b/fs/resctrl/ctrlmondata.c
> @@ -550,13 +550,8 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  		    struct rdt_domain_hdr *hdr, struct rdtgroup *rdtgrp,
>  		    cpumask_t *cpumask, int evtid, int first)
>  {
> -	struct rdt_mon_domain *d;
>  	int cpu;
>  
> -	if (!domain_header_is_valid(hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> -		return;
> -	d = container_of(hdr, struct rdt_mon_domain, hdr);
> -

Problematic snippet removed here ...

>  	/* When picking a CPU from cpu_mask, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> @@ -566,7 +561,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>  	rr->rgrp = rdtgrp;
>  	rr->evtid = evtid;
>  	rr->r = r;
> -	rr->d = d;
> +	rr->hdr = hdr;
>  	rr->first = first;
>  	if (resctrl_arch_mbm_cntr_assign_enabled(r) &&
>  	    resctrl_is_mbm_event(evtid)) {
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 4076336fbba6..32116361a5f6 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -159,7 +159,7 @@ void __check_limbo(struct rdt_mon_domain *d, bool force_free)
>  			break;
>  
>  		entry = __rmid_entry(idx);
> -		if (resctrl_arch_rmid_read(r, d, entry->closid, entry->rmid,
> +		if (resctrl_arch_rmid_read(r, &d->hdr, entry->closid, entry->rmid,
>  					   QOS_L3_OCCUP_EVENT_ID, &val,
>  					   arch_mon_ctx)) {
>  			rmid_dirty = true;
> @@ -424,8 +424,12 @@ static int __mon_event_count(struct rdtgroup *rdtgrp, struct rmid_read *rr)
>  	int err, ret;
>  	u64 tval = 0;
>  
> +	if (!domain_header_is_valid(rr->hdr, RESCTRL_MON_DOMAIN, RDT_RESOURCE_L3))
> +		return -EINVAL;
> +	d = container_of(rr->hdr, struct rdt_mon_domain, hdr);
> +

... but now the problem is moved to __mon_event_count() where rr->hdr can be NULL and the
domain_header_is_valid() check is referencing NULL pointer when SNC is enabled?
Am I missing something here? Does this work on SNC?

Reinette


