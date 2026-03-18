Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0C63EB7FF
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 16:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773851803; cv=fail; b=tM7uJhIY2HM+BQZne/rbCmndvVQVtxKOyq4l++WGSl4Y4UenDtxlBbq32MLTwLn3GV5me9OcFRvV+SdjzQpe8rsrcagISQUGf4XIVy5HARTgZwU/AW5YVonRFXUtGVY085AA/oR8z0gAw4j9AjLb8zH7gkdJk5OajxKswdTAF1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773851803; c=relaxed/simple;
	bh=9PXXWI4pTqm2WXqB3jkhHDrd9gRjliDEY8/sYbTEnYU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ih3lgezFzfczAqdVtHKOx1sWJXWGixmYWI4/DkHgL3Q+zxIk8din27XtEZKEOs71a5tYkvxcWTlLte5ekMj7Nlzii6k4+gCayKmR8KVOFEz83R9NpLJxdpaDPp5xM2k/PZbkFbRjrSd/FTsQJaeLpF1kd3GtN3ARam5fcYC0MLw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fdgL+1N4; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fdgL+1N4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773851799; x=1805387799;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9PXXWI4pTqm2WXqB3jkhHDrd9gRjliDEY8/sYbTEnYU=;
  b=fdgL+1N4edtw0tHdZPfkeVs40bk30XsUISVf9247A3OitpCmaPVgrSmj
   36BGqoRgiLi7UHHiDbKNgu+oEZK7KaYBXTbd1kHtruKmHadHwLBbeF7PJ
   pN0H+99tF/qxVxvb7G8emeXyD1CBMJi1La9qwItrT0Av6ClVZIx2HAqhN
   8We3tE9LaM+iGMSeKr+ZXsOs4/T0ELD5fFxMPG1h9JUaTP3ZVxqAe5/gU
   Y4EPYq9rMqeVi3yJ2/kDojZyJHHmOBi9L5CLy8byC3ontobKrxPrPmmFV
   DheEvqf2FdeK8JdZugq4BVjcGYI4udVG1m3qPjkHlPber4QzsXIPyHLiv
   w==;
X-CSE-ConnectionGUID: eI7L6MzZQRWikgZFeYOJPg==
X-CSE-MsgGUID: baRBEn94QNW49L0paW/CnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11733"; a="74989544"
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="74989544"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 09:36:32 -0700
X-CSE-ConnectionGUID: Iyw+TiMeRlOzJ3F30OCT3g==
X-CSE-MsgGUID: EljuuNXZSPKI+6uYQIaL0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,127,1770624000"; 
   d="scan'208";a="247131363"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2026 09:36:32 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 09:36:31 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 18 Mar 2026 09:36:31 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.54) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 18 Mar 2026 09:36:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VYfYW81tNMPsvnSNWyhBL2+3W1iF+Qvi93CZbhd6zOT+jqnRoHNVqeLo5TwW2jYwkCq2ZBGdYsFUfzwBoN7SOuFA4aETz3TWDZdv7yqo/T4/0SywQODHM25WuR8DTlrb9oUUyTMw1S3TFcUjSJZw0ULAXAM14O7DFVNS1nVX4XHwj/koQIkTvA67SqnJuJs1NEVm8P6eGltxDovJnM2HOIeMtqaeEBBACO8IbCtrIC93R4Yq1khkiY6R07TaxWjVubnRVqpLCod7HM4vhId6C6iHHPVl3Iq4lnT4+LER0GSQuQj0Qem3RSuiAopOjdIJrltbSBoAV77HCJ0DHD5OgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LJ9xNrg/oxyI3AmDXgs8lx+p28VoxS9G2D/M9XXojJE=;
 b=bVCwivw5eYgYKqgymN1c5BO27jvApXLKRAS+uhqqxfcw4QqOIJ0SGxWfDP/s+Yhbko1rrECCqLyuZUlw1RDmzkLzUCrDWdav08azNPg2OlEsea7UU8y6sbLIlhwyh0zHsE6y2E7kpiVBsghk+uVTs63oEJgehdIWcBQpKRLStrWMxka3jPcot6Evrhncb3sdn+ENfF4I7iSscUHvznF/yID9m4HwH2t8VM6extjchw6gOe9eW6PS2cT6JVvblsPZOCwaEuhJqc/Hc1vqthPSMW5EqoIEDTkCytX87+rkiedMQAFdxH3IheALB+lfT/dvCFhM8WgYWNZJd0WlnGmbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB7872.namprd11.prod.outlook.com (2603:10b6:208:3fe::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 16:36:27 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9723.018; Wed, 18 Mar 2026
 16:36:27 +0000
Message-ID: <55a9461e-32f8-4665-905e-bc18b7201c7e@intel.com>
Date: Wed, 18 Mar 2026 09:35:51 -0700
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
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <d4460f04-813f-4a6f-ad1f-6f2e5bb1c9fa@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0107.namprd03.prod.outlook.com
 (2603:10b6:303:b7::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB7872:EE_
X-MS-Office365-Filtering-Correlation-Id: f41a6e77-37db-4fb7-a8fe-08de850c800e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: 1/zh7O8W2hHpl72hI96YKZaegdC5Kil3FOGbziFP8b9Frn5ae3QUhn20Ojz0w2dapa/KDRuPSTVNNJNDPSx2VW+HWmcuKlbq4OZDLItzWoosUdqWASvmEGUsKlZc7HeeyMY8y2RblzE0xno5oehu8SLiGWl6+D4qIHOGYBgEi4FgIdMQ6LcB/P3tztsS/3r6pkOOOscU55bXMlP+KDcD2MiwufaT6hOPAKuP5C/a5FvGtkSutSIrhO4BM44Za1XG5h7qOOhEhVO5w+ZkUbkAHLCo6VWigY5UeXUezHWUyqWwq73TkJfhxz45CNlz9hTZpCTgVFufJuZKL7CXiANtgDFRRhIXPeKzdxtvNgG68oCBCpiMS0blY34iiflUSEicp/wFTM8hwh2QWj9wLzxPYYzTAN9mTDBuyKYtKKRydCbrbO2m82fIA3XdGTPj5oqdajI4ENwaye/TheBcCq1yFmCyl6d/ncvE7s2tC+U7/dGl2Gk3mT7wpyIyUnUjFsa95T2wWixfefETW3P3yKM9bolZjBePtZGY3ugTwujbxG1iTdG7RBxxiFMywMPWe9nzkYzfK5X6Fs6Bwue9ZKcqEh6ZSb7qWmYquZ2TxlVHszN3Q1aIVRMND8mkAucxtsbuEM/xaUKodrKV0ZQhrNfRAExCR4+123vKnG4Tljp0VeQikFLv9rXSHplk5lD+2rDAPg0QbPIc0YfeTEEruwIqIijfrFz2EpFfwmsb8whflmY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MnZjaG81cnpGcjlIbHdQUkkrTXl1SkFVdERyb3pzWGNJTkpXaHE4U2JnTzVl?=
 =?utf-8?B?TTJUdWtVVXMvbXFuNGdQaXBrMlhDRzBuNjd1cVJjL2tMM0QrVVpvK0FJcmR4?=
 =?utf-8?B?OTk2WENsUU9EVGVHa29oT1ZtMGFzVzNOblRxTTFqbmJ6czE0MkUwQ21TUlVp?=
 =?utf-8?B?b2tycVR1Z3ZNVGVhajNBeTRoVkpnTDNMc3J1U1dJSEFJaXUzZGlobXNOTUdv?=
 =?utf-8?B?ckxPZ0VSWTczYSszd3BnbTQ2RVU5R1pnTDcxRGY0L1NybzB0c1hMa2pVVHlI?=
 =?utf-8?B?cHRoU0lBYU02Yy8ranBxTmxZemRBS1VoTnpXaU1PeWd3S3Y2eVg3dVh3ZWE2?=
 =?utf-8?B?aStuQXZkMHIvQ2NvZmhiRnI2NWRtYkRjNUpoblVZNTJUdXZZN2dPeEovdnMv?=
 =?utf-8?B?L0xnWEIzenFYVlNBSXFxcjRSVzhPeWNzWUUrYU5xNFVqWStyM2Y1Sy93MnNO?=
 =?utf-8?B?MDdydzZla0RWUTZrTjk4WC9wUjZsRkpmWmJlTXovaTZOQUhrL3MzMzVKb1ZJ?=
 =?utf-8?B?S1l5ZXQzSnlObnJ1TUU0L25yVGp2SUdIN2ZIQnFMcGZ0YUpWWDljSHNWRldn?=
 =?utf-8?B?WVJrWnRTWGtsSHhzaWpxcjdyaGhsMlpLSEdOU3lGOGpOU2I4bXdFUEN3ZlIw?=
 =?utf-8?B?NnNpdFFBWDNXbk0zYkFkbklFc3NQS1JScytsQ3JtVWU1ckZldjdOK29GVmpp?=
 =?utf-8?B?eDV6dWVQT0psR0MzNFFkZXg1ejkxWUF3V0MzTjcxSlVvNGpBZmFRYk9RRDE3?=
 =?utf-8?B?K0RYYjNVWHhZSDFqTFJlQjZHNHZuaFBJd3lBL0tZQnJFZWFmRlo5S2ZRc0RI?=
 =?utf-8?B?R2xxanA3TnRObklidTJzR2dhNG1mVEpvNnVML2ZzYitid0xPUlN3ZERNUEU2?=
 =?utf-8?B?dkllRFhBQ2JwYUVlV0hyVlE4MEdna2I4TUU1ZnNVTDRCTlBFalp3aFNZdVJx?=
 =?utf-8?B?MXM3SlcvbUFudXUvTlAvWnNoWHJvcnViMllTMndDRW9NY2VCb2NhYldPa3Fz?=
 =?utf-8?B?MEJQeUVabkRKaTlVSm5MZHp6OTVidFVIK3h6YUFBaWg5TGYwdlcwZ3R6YXky?=
 =?utf-8?B?MmJYdWxQVkUrSUVGckVXVW5lKy9ndzFnRXNUQUMyUHFVTHFhS3doQ3duQXBo?=
 =?utf-8?B?MkM0eGM2WGlnK2RUOVJYcGNCSkNiMERPMjkreFlJdGZLVGZCb2FpNExjWTI5?=
 =?utf-8?B?L1Q4WGdBWk9kZXNML1pKNktMMDM2dTdkcVFlYXJtTjBjQVZVWTZycW1jaFg5?=
 =?utf-8?B?TWxkZnlOblN4VWkzYTViSUN2QXNML1hoMElQZk1PSGc0U2ErdGtCY2NWcUZl?=
 =?utf-8?B?azlCa1M0UDUvRXZneXRMMFE4dHJpMnBjY1duNDJZUm1ZQkVaM244dGxyQzZY?=
 =?utf-8?B?SW1FOGRycDhJN3pwb3BlMnRIWS91SnBDMDRsRTFvcU94RmpGaXRFVUR2ZU5Z?=
 =?utf-8?B?b1YrM1ZYMHhxa1Z6VWxiY1ltSEZaVHJGTHd0dUpNQlEzdCtTRlNuMm40RFQz?=
 =?utf-8?B?UzF6OWgvdnVOeHdVcmZFcUo5L3ZnWFdzaHpxNlBMT2h2a1ovSldOVU9VK3Uw?=
 =?utf-8?B?N3c5alVnU2wzL29ZUU9rVEM1eDE2eWRqN045RXFUaVdTWCtJRnZVUzlBREx2?=
 =?utf-8?B?c1JTMTJuUUx1b1AyRG11dlJybnNDZnBUQUpmdFNYM0E1UlBtZ0ExT3o1TE1x?=
 =?utf-8?B?ZlQybjdtdDI4clJoL0dOVTA1akFoNVQwUnUwdnNpTmVtaUxXUmc1N3RWZnc5?=
 =?utf-8?B?eGR2b3FaUjk2SkJ6cHlmdnZBQWx6MjhSdDlxaGlnbG9BT1NTMXVNOXZpOHp1?=
 =?utf-8?B?bi9Ja3YvbHE0SFdacUFjRE82WTJPM2RNQTNlWnk4UUVaSHlVb1o3Ri9sREYx?=
 =?utf-8?B?VW0rSUQ4UzdCWi9NekpkRjVhSDlBTEVLRHU3UnROQzdnRGJMaU54ZVRYV0Ja?=
 =?utf-8?B?b0pwR0xvZTFZZnFvVWtzdUdLU29GM1ZTZGJIRzZqb0lPNUU0alF2QXRCNHBM?=
 =?utf-8?B?Ni9pcit2ZG5WWVMvOWhjaWtVMzR5OVJmVnFOOGN2ZGQvdlBMMkxXZnMxM1g5?=
 =?utf-8?B?L00xblRITkFCbFVaenZyMmlwalExdzNWM3FNZldUWUt1NUliOWVaVkwzZVZB?=
 =?utf-8?B?SWFxNWFXOHU5Q2xaN3pycVI4TEhhclhnNDZnbUhHSFdLK0VsT0J5Qk1HSlZv?=
 =?utf-8?B?MzBobW1kZ3duUVlKb0tPUi82Q3ZOcEhKZkNYdkkxOW1FK3ZYOG9GNCsxb3BY?=
 =?utf-8?B?ZXlJNFNINFdtNHlOaFByL1g5SmR3bUhqTmh4VUZXcnUzKzUvakNXOU95cHhk?=
 =?utf-8?B?a256YjJUZ3g1YlBKdzBmTzdOSDY1VW9nTENPV3Z3Tm0yRFlibDZhOVErYU5J?=
 =?utf-8?Q?n+FcTJ/DgtBgu8l4=3D?=
X-Exchange-RoutingPolicyChecked: M3brSIQBsNCG9KFMNdzWDO6eEuUMkn7oZbJX/mfPNs1Q/4OaAN+ALmQ0WC087BVgtw/k0aQukzNvdLMOk/VnKi8DrBKDVMNChma3g7AG59NtboUQew1QuWtZaCHf2ZE0GnTlmlXESw0tM1UNnbYto+5sd8HE+IPa2VH8y2PWEija3rrNbepRTyQabEiYC7CopjsGvIm1GDa3quPAM0H4e9V73e7Pt+mla8cSwjL5O3Ho9hUnTd7hjNlcvTtfGrHXS5WAkei7bDUYDUF+0IC/RXcKMVN71eFhhde0Gp2rc+pUB9jiiFYOx2/eYyutdmkCjcBVgLFPxPYxv2VXE92D+A==
X-MS-Exchange-CrossTenant-Network-Message-Id: f41a6e77-37db-4fb7-a8fe-08de850c800e
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 16:36:26.9546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oXZkm2iPdRSE0pMiPpaLCKOR97gYRnrexu4UFcrDkjDrHDkYHFBGgK4dwWDcgvIMycpz4e3gzkUWv037J37k9/XrIyUWH+TigtUnZrG2jB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7872
X-OriginatorOrg: intel.com

Hi Ben,

On 3/18/26 4:59 AM, Ben Horgan wrote:
> On 3/17/26 18:09, Reinette Chatre wrote:
>> On 3/17/26 3:25 AM, Ben Horgan wrote:
>>> On 3/16/26 18:18, Reinette Chatre wrote:
>>>> On 3/16/26 10:44 AM, Ben Horgan wrote:
>>>>> On 3/2/26 18:46, Reinette Chatre wrote:
>>>> ...
>>>>> One related issue I've just noticed is that when ABMC and mbm_assign_on_mkdir are
>>>>> enabled the creation of MON/CTRL_MON directories may succeed but an error message
>>>>> is written to last_cmd_status. E.g.
>>>>>
>>>>> /sys/fs/resctrl# mkdir mon_groups/new5
>>>>> /sys/fs/resctrl# cat info/last_cmd_status
>>>>> Failed to allocate counter for mbm_total_bytes in domain 2
>>>>>
>>>>> The failure is ignored, as expected, in rdt_assign_cntrs() but the last_cmd_status
>>>>> is never cleared. I think this could be fixed by:
>>>>>
>>>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>>>> index 62edb464410a..396f17ed72c6 100644
>>>>> --- a/fs/resctrl/monitor.c
>>>>> +++ b/fs/resctrl/monitor.c
>>>>> @@ -1260,6 +1260,8 @@ void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>>>>>         if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>>>>                 rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>>>>                                            &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>>>> +
>>>>> +       rdt_last_cmd_clear();
>>>>>  }
>>>>>
>>>>> Is this right thing to do? Let me know if you want a proper patch.
>>>>
>>>> Letting group be created without any counters assigned while writing the error
>>>> to last_cmd_status is the intended behavior. If the last_cmd_status buffer is cleared
>>>> at this point then user space will never have the opportunity to see the message that
>>>> contains the details.
>>>>
>>>> It did not seem appropriate to let resource group creation fail when no counters
>>>> are available. I see that the documentation is not clear on this. What do you think
>>>> of an update to documentation instead? Would something like below help clarify behavior?
>>>>
>>>> diff --git a/Documentation/filesystems/resctrl.rst b/Documentation/filesystems/resctrl.rst
>>>> index ba609f8d4de5..20dc58d281cf 100644
>>>> --- a/Documentation/filesystems/resctrl.rst
>>>> +++ b/Documentation/filesystems/resctrl.rst
>>>> @@ -478,6 +478,12 @@ with the following files:
>>>>  	  # cat /sys/fs/resctrl/info/L3_MON/mbm_assign_on_mkdir
>>>>  	  0
>>>>  
>>>> +	Automatic counter assignment is done with best effort. If auto assignment
>>>> +	is enabled but there are not enough available counters then monitor group
>>>> +	creation could succeed while one or more events belonging to the group may
>>>> +	not have a counter assigned. Consult last_cmd_status for details during
>>>> +	such scenario.
>>>> +
>>>
>>> This does the improve the situation but the multiple domain failure behaviour depends
>>> on the order the domains are iterated through. This is stable as the list is sorted but
>>> does seem a bit complicated.
>>> I.e. if you have two domains, with ids 2 and 3, with no counters remaining on domain 2 but
>>> some on domain 3 then rdtgroup_assign_cntr_event() will fail early and the counter won't
>>> be assigned for domain 3 but the last_cmd_status will only be about domain 2. The user
>>> either needs to know a failure at one domain means all higher domains will not be
>>> considered for that counter or look at the new mbm_L3_assignments to understand what's happened.
>>> In this case we have:
>>>
>>> /sys/fs/resctrl# cat info/L3_MON/mbm_assign_on_mkdir
>>> 1
>>> /sys/fs/resctrl# cat info/L3_MON/available_mbm_cntrs
>>> 2=0;3=1
>>> /sys/fs/resctrl# mkdir mon_groups/new
>>> /sys/fs/resctrl# cat info/last_cmd_status
>>> Failed to allocate counter for mbm_total_bytes in domain 2
>>> /sys/fs/resctrl# cat mon_groups/new/mbm_L3_assignments
>>> mbm_total_bytes:2=_;3=_
>>
>> Good point.
>>
>>>
>>> Would it be better for each domain to be considered even if a previous failure occurred or
>>> is this now a fixed behaviour? For illustration:
>>
>> I do not believe this needs to be fixed.
>>
>>>
>>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>>> index 62edb464410a..8e061bce9742 100644
>>> --- a/fs/resctrl/monitor.c
>>> +++ b/fs/resctrl/monitor.c
>>> @@ -1248,18 +1248,25 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
>>>  void rdtgroup_assign_cntrs(struct rdtgroup *rdtgrp)
>>>  {
>>>         struct rdt_resource *r = resctrl_arch_get_resource(RDT_RESOURCE_L3);
>>> +       struct rdt_l3_mon_domain *d;
>>>
>>>         if (!r->mon_capable || !resctrl_arch_mbm_cntr_assign_enabled(r) ||
>>>             !r->mon.mbm_assign_on_mkdir)
>>>                 return;
>>>
>>> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID))
>>> -               rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>> -                                          &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
>>> +       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_TOTAL_EVENT_ID)) {
>>> +               list_for_each_entry(d, &r->mon_domains, hdr.list) {
>>> +                       rdtgroup_assign_cntr_event(d, rdtgrp,
>>> +                                                  &mon_event_all[QOS_L3_MBM_TOTAL_EVENT_ID]);
>>> +               }
>>> +       }
>>>
>>> -       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID))
>>> -               rdtgroup_assign_cntr_event(NULL, rdtgrp,
>>> -                                          &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>> +       if (resctrl_is_mon_event_enabled(QOS_L3_MBM_LOCAL_EVENT_ID)) {
>>> +               list_for_each_entry(d, &r->mon_domains, hdr.list) {
>>> +                       rdtgroup_assign_cntr_event(d, rdtgrp,
>>> +                                                  &mon_event_all[QOS_L3_MBM_LOCAL_EVENT_ID]);
>>> +               }
>>> +       }
>>>  }
>>
>> With a solution like this last_cmd_status could potentially contain multiple lines, one
>> line per domain that failed. last_cmd_status is 512 bytes so if this is a system with 
>> many domains there is a risk of overflow and user space not seeing all failures.
>> That may be ok?
> 
> Probably but maybe we can do better. I wonder that given that we know we are trying to allocate
> counters in all domains the information in last_cmd_status could summarize which
> domains failed. 512 bytes isn't that large so a hex encoded bit map or something else information
> dense would be needed. This does make last_cmd_status a bit less human readable so may not
> be the way to go.

Indeed, at this point it becomes difficult to convey all the failures. I expect a bit more
from user space during such scenarios though. Specifically, a user space needing to work in 
constrained environment would be better off disabling mbm_assign_on_mkdir and manage counters
itself or ensure there are enough counters available before creating a new monitor group.

What resctrl could do in such scenario is to at least convey that some messages were
dropped. Consider, for example:

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5da305bd36c9..ea77fa6a38f7 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -973,10 +973,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 
 	mutex_lock(&rdtgroup_mutex);
 	len = seq_buf_used(&last_cmd_status);
-	if (len)
+	if (len) {
 		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
-	else
+		if (seq_buf_has_overflowed(&last_cmd_status))
+			seq_puts(seq, "[truncated]\n");
+	} else {
 		seq_puts(seq, "ok\n");
+	}
 	mutex_unlock(&rdtgroup_mutex);
 	return 0;
 }


> 
>>
>> I think this can be simplified within rdt_assign_cntr_event() though. Consider:
>>
>> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
>> index 49f3f6b846b2..a6a791a15e30 100644
>> --- a/fs/resctrl/monitor.c
>> +++ b/fs/resctrl/monitor.c
>> @@ -1209,12 +1209,13 @@ static int rdtgroup_alloc_assign_cntr(struct rdt_resource *r, struct rdt_l3_mon_
>>   * NULL; otherwise, assign the counter to the specified domain @d.
>>   *
>>   * If all counters in a domain are already in use, rdtgroup_alloc_assign_cntr()
>> - * will fail. The assignment process will abort at the first failure encountered
>> - * during domain traversal, which may result in the event being only partially
>> - * assigned.
>> + * will fail. Ignore errors when attempting to assign a counter to all domains
>> + * since only some domains may have counters available and goal is to assign
>> + * counters where possible. Only caller providing @d of NULL is
>> + * rdtgroup_assign_cntrs() that ignores errors.
>>   *
>>   * Return:
>> - * 0 on success, < 0 on failure.
>> + * 0 on success when @d is specified, 0 always when @d is NULL, < 0 on failure.
>>   */
>>  static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgroup *rdtgrp,
>>  				      struct mon_evt *mevt)
>> @@ -1223,11 +1224,8 @@ static int rdtgroup_assign_cntr_event(struct rdt_l3_mon_domain *d, struct rdtgro
>>  	int ret = 0;
>>  
>>  	if (!d) {
>> -		list_for_each_entry(d, &r->mon_domains, hdr.list) {
>> -			ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
>> -			if (ret)
>> -				return ret;
>> -		}
>> +		list_for_each_entry(d, &r->mon_domains, hdr.list)
>> +			rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
>>  	} else {
>>  		ret = rdtgroup_alloc_assign_cntr(r, d, rdtgrp, mevt);
>>  	}
> 
> That does the job but is it simpler to delete rdtgroup_assign_cntr_event()
> and call rdtgroup_alloc_assign_cntr() directly from rdtgroup_assign_cntrs()
> and rdtgroup_modify_assign_state() rather than special casing it further?

Yes, I agree, that would be much simpler.

Reinette

