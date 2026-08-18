Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF18647A0BE
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 15:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787067500; cv=fail; b=OHpvZL0VSVaoVXkO90qS4CUNzLPj8voKGcq+hA4/A1E33ScmQeC1VVRnDn7lDF2UiaLnK/nVbSEziiGnW2JWYmK49F0edfFRAp5wugEPQwwuem6ZLAJ4DXX49nEIi70epCVTlf4ItM0keJOQHhqnsHTJlPvw/Z7EvVPu/r6/rJc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787067500; c=relaxed/simple;
	bh=yfmg65vBrG9E3r/WsafIj1o6PDqGb1Dg05iQRpWX0ko=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=lU9EgcyEbX1wImzm69i3qJKTSdWGsPeAb6LnOGVTMcTVjb6esGeq74L7L+E3QZExEX3wPbr2z8pHzbK/BTsUbJ8Wo9Z3gl36eFjluuLHHm/qeI+r4s2q2PcT7/fcr5YSg8c5B/8c2gdw5v5SAgoM94O4Ejq+arKvk7O2tgfoyiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JjGT78HP; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JjGT78HP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787067499; x=1818603499;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yfmg65vBrG9E3r/WsafIj1o6PDqGb1Dg05iQRpWX0ko=;
  b=JjGT78HPUHG63zkaMaAbwTEOI8no1lsL6mnkl69QAie6g0qgGxlqhZ5P
   mHrcjxySs3dYIQ6AuEP9UBSIg10yv6NoNk7kkpLEXwlgQeLExPEyLpY2i
   1tOj4sJx8MN9g5JAn0Iw4FkPqlttfCVmkmkqox/A+o/ZOLKq+itdJVi0i
   uBdlWD6sxPOhWYXHTboClxpbLd3Rzrubsu+OaLs35GxnAO/oDuWFfrmX3
   y7iorzP/8NlDV70caV1spLVqEs9UD3qLx0hGsM1BX0/Z/T30EvmWbo2k1
   0upH84XuJhnTgV2tkZaNg+aTY3KUI8LxGMaYCwU21rsD3ek9D7s+61NRW
   A==;
X-CSE-ConnectionGUID: DqErXePYSOCDPjMwxOCFBw==
X-CSE-MsgGUID: xeR/J/2+Q8eLg6AORBRlxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11879"; a="98719594"
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="98719594"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 08:38:18 -0700
X-CSE-ConnectionGUID: PtFIfq/PRg+WM6AhFAhoQw==
X-CSE-MsgGUID: kw/0QLZmTg2hrLof211Ccg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,230,1779174000"; 
   d="scan'208";a="261508675"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2026 08:38:18 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 08:38:17 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 18 Aug 2026 08:38:17 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.65) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 18 Aug 2026 08:38:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xi4kdADSVvIqIKkoD+9Mo/oZm21YIqGqT7mBCiuf2+pVjmIV8+gJc8Jexq48NGHWk4UnbFagaQM4EcBeaxh9hd1uE1hUq4CFrt1Qc187EyoImsiq3TuQiZNJLlprDKm6eK6pRyUtxadbHtfwhBJttcoIA6wxYCBX42/7vkCyUuHfdUeGXonulxrsZ7N/Jy1zqsKF4svjd+QC1kOPXZauU1Fd/Ww3tFTHEowMUUnEmsMwA3+S2MvI5AUCRVQektxr2yzWe/2myNw0iQZRqJ6PpbK17in063PvciIq5yYKOkUrmLcmnZtP36zj+oe20ZMwp0J1JwpGa65bAqAxajSbRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUIYvNSbe3RCGG8mRAPiF0No/1WK6MTBPVw+fG9NR+o=;
 b=R3OfjCZ8ixGfjoEFab6L3ELlwdTtPsYZhbW0rvB89ZY2LwEKknkDJopHbGyZemCSy0Mvi2E7PXyCm/gsnCUiwnG7Ws0aWw2MkjIcYTnb475bgRZINtr758X5nfS5AorVuPgAHgzEuKP6F4s99YE4smtnsu8yW5TucavCW53IV2HTuM7C5AZqV1R5FQ4krmpZGrsi714Flegjl1nJJQAL1FhnGp/7Q2dJOnxcQXZKiBQzbfDvgCJoGkXP2L2WI0dtrpzPDkgnSVjSu32P3ASYuPylnAzCLzBt0Lk+mHFBH8Jy6ECbAMR8GYpS8CdJcumzU8rrFLDYejOQxmcDGBTv/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by IA1PR11MB7824.namprd11.prod.outlook.com (2603:10b6:208:3f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Tue, 18 Aug
 2026 15:38:09 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0315.016; Tue, 18 Aug 2026
 15:38:09 +0000
Message-ID: <6b6ba68b-ece9-49dc-b1d6-55715a913fcc@intel.com>
Date: Tue, 18 Aug 2026 08:38:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 14/17] x86/resctrl: Export interface to report
 telemetry unbind/remove
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260729172752.11561-1-tony.luck@intel.com>
 <20260729172752.11561-15-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260729172752.11561-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::26) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|IA1PR11MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 425288c8-b7c7-4256-f2f4-08defd3eb4a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014|23010399003|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003|921020;
X-Microsoft-Antispam-Message-Info: JhJIdAy9LLW0vcGkX6N0WDjIX5o4jMMLzwXb1LMxv9k+FUAthBtSNVI/NAaQ77q2H8vnnrZGpAWTmyKTOiVf8UQ4b3UzNpeF0m6MdJH1SzuzXHfOtqHp1+8sDmgtJiLbHIQ6UjYMp/13WrKtq+2wgQxel23pwGHQjI9EDd3BjgbHbHOOYVJM6PC+KqRVH5Yp+3cEovHy4/Ez2s9GkgFuGLaMX2yeXu/QbNqZbso0ewagLglmczPrQKRcdDd/Wgw1ICVpmuXB5VuOMOm0M+a2JSI21g+6S1qGmUkevNDPoYczNqnox39eHYETAXbiVdUc01ExrYvekWYHqMJXykaq+BMpHeAbVB0o2bz0EGoohwwfV7RjKDiyvAPGVuR08dK/E0rz8eQ5iLumgPRadhilcqUS2rQK7pFNOB/teepDIJugs3MbqKJjgnHxrKdqCRzUtHMQx6g/dRu053WOkBm3Ptrx9yRXKAyOnO1WPfui7RLhLioBg9rqCCKxAXM3djvtLT+loOYcvm/aoOuzuAx8EG/F7vSyS4gkDpjfcuyfeFPE4TOGnwczGTsQYt8VD3b7qsEq8X48z4Om5qpPpWAikLEshmTqFWPi/LEIjYodZioWGPs/qCh8x3kWIKYu4JdMM2RvktZlOrSEbRygKzRD22yvdK9ITiU+YZbCvL0H9jtUaWGSMTam6AUXK5IDoca5h66ABXzcmqHSmwdAZS+/iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ck5OQ1QwT0ZEb2hKemUxUStvVk81VDhTY1FDSU5TZkFvZmpMZHhTU1Fjdnoy?=
 =?utf-8?B?R1kzRnFLcldLT3VGK1BBK3l2dFdEbHBYMXdDWUdVbE95Zlh0Q1BPOUtvbW1v?=
 =?utf-8?B?RGVMaHdweWY3MG9qdlZnWmN1aGV5cmg2QWJYNzluNk1ad3BvUU9ldjEycEZp?=
 =?utf-8?B?NlNjRHFnb2E1anRWRlQwZmIxdDdoQ0RFMENIODFRaEswcDl4eXJIUWU4bHlQ?=
 =?utf-8?B?Y3huNk5lVE1tVGJBZ2ZNek1oQnMwV0ZMR2phWTI5WlYzSVNvVVpVSVVwNWJ0?=
 =?utf-8?B?T3cxZGFEc0h2WE1ncWgrUUc1dk5JSVp2SFc4UUtBU01TYzUzOEcvTE1nKzMr?=
 =?utf-8?B?VDJIN00xR3dxOExkK250YndaREZmZUNhQkpTVXZwWE5VRk9wU3h1MzZzYlhs?=
 =?utf-8?B?NEV0cVdOSG82VlR6eFhjK01VQTdqWUJxb2o2REVvTzcwcWx6L2h6dENldnVB?=
 =?utf-8?B?WUc3c3JXYVpnaDBwZ3g0akFvWmlkeEYybFpGQ1RqTVkxUkoxTllwbjhDL3Q4?=
 =?utf-8?B?dUt0N2F0dm55TVpmcEVUVHppT2VKTG9yMTFTOWY1TDhVWkt5T25ZZ3VxdXg0?=
 =?utf-8?B?b2kySlNpS0libU9GcGM0TGpYaUxZck5MdXM2dUpRSUxBajJxRDVoand2WWgy?=
 =?utf-8?B?NkFqbFRIdldBWnFHNGdVVUoxVncyWG53ZUNudEZ5TGx3UTBLM01yUG9tWFpM?=
 =?utf-8?B?Z0doclN2RDRrL1N6Q29BREtXYkR1SDlpa1hMT2JFZ2xNcExPVUt2MlZ5YU5s?=
 =?utf-8?B?a01vWkJZckVFQjVuQlduMDM3SkZiOUxCdy8wSVZmM2l4OHNLUm1WZnZyeUZD?=
 =?utf-8?B?dDV1L3RsUGp1cG5LcE1za0YwaG54U1BiTE9BSyt5Mm5iRDJyaFZNc1JTNGpa?=
 =?utf-8?B?WDB2R1ZXUGtXQTNTZE9iNFFmV3VDQ0Z6MXhhVmEyVEhDVmVsUnhVWXpDT0ha?=
 =?utf-8?B?QWNtV2JrMFFzSGpvZEg5cjAvcTVETDVMb3JEdWNCT3ZvWnJ3WUVGOTV3bHY1?=
 =?utf-8?B?NGdTVXVRMm1ZSnVVbXpvUXNScHF1cXVlZ1RpRFlMTzI0SkRtMFY3MWxPOG0y?=
 =?utf-8?B?VHNEZnBTRkZtbjB1UngrNHoxSklrM0I5R1RWMFFNaW1ubE00dkN4elZPWTZB?=
 =?utf-8?B?NDU4TnBCNG1jYjFvaE1EWkRZbmxwNVlOZVU5VWVFVGg0cEZBa0xFS2ExLzJt?=
 =?utf-8?B?MDN0dVhIcU9yT2tyV1lzM0NpL3hoZEpTSG5EY21tL1piSm13Y1NYdGwyalVT?=
 =?utf-8?B?NXUwekYzZjJVUU9hdXNrWUhicUVTemV6UmlXTEc3QkdQUElBS2Y5Nk1NNEwz?=
 =?utf-8?B?NnJrR29RczNrOUVjN2ZDaDk4UExzSTNveGdkTVpEOVpLZ2U4aUYxUGxqZHhI?=
 =?utf-8?B?SWpndlNaZkw4OEU5TitMdHU1b0g2a2ZWSzgrMlE4dHNXeGwzb285Y05LTmVS?=
 =?utf-8?B?c3NTc2k4dWdibjBBMUo3RHovdVR0OFQ1KzJwNzh0b0pvZXR3VXk4NjBXVXBD?=
 =?utf-8?B?bmxsRDhoT2VrTkxsbm1KcFQrcitYTmtka3p2eUZOZkJFVFZlVUpTTmhxNnE5?=
 =?utf-8?B?ajlhTDhIMDU2UXR0MDVrcllkcmVTdXpySFZJbWpMNGkvSEplaDRqT2JKRnVQ?=
 =?utf-8?B?S0g3K2twMFZIZHdHLzVJRkxDWmZYNHMxOHVMbVlaMUx5K0Q5SW5jZzBMbWM4?=
 =?utf-8?B?dmw5U3hnNFpnWG0xeTJacENSMjRvSERCSXhjLzlTcStpdVpuKzFSbndJb2Yw?=
 =?utf-8?B?MjcyelZWYUFCMndHU2dWc0doQ05RSk45dFFNd0ZpSDJ0VExHQjh1VzB6eGdR?=
 =?utf-8?B?L3lQNnlUbVZUQ25UdTBuODdvdm85RkUyTjI0K2NhbE41VU5WSC9KMEEzR1Fk?=
 =?utf-8?B?dUhoc3ZvMTRIWXp2MHVVQlM3K0FFY2RtdWk0T0xPdXNzSDQ4d21mRmRQRHBJ?=
 =?utf-8?B?aUl3VVBJOHFJeHpsaFUyS2R2S2sydVNVeURuTG5TVFZoZ1BQZmZkNGxNNml0?=
 =?utf-8?B?QVhadVl3ZEhVQWRLRUFWUU0yZERFUG9Fd0VlaGtmR2NYWjRHK01wWVp1blZv?=
 =?utf-8?B?TnRVdGFNL2kxTmwwemhlZXgyeE5KTzVrTnkzUSt0TFJ6Snp0cWliNzdOZ0w4?=
 =?utf-8?B?L3BaR0EwUkE5Qzdqa0hGSENYbnhKUU5GWFNBVVlDT1M0WGx1WTZPNGJSeUtz?=
 =?utf-8?B?K1NKQnVjb3hpa0JZbVlIWCt1dmkyNUplOS9TZ2RlUDNkTXlDZ0kyVStrUTFY?=
 =?utf-8?B?dUVaZW1XZGhNRlF2ZTBwbU0xeTVRSTc0QzFQNit2U1ZnYlQ0WlljSnoxeHAw?=
 =?utf-8?B?bDNrOU9QZE9HTlBjZVRDT0xsalRkYngvRCtCVDdReVdUeUdJMVVuYU5abkla?=
 =?utf-8?Q?z4R+vHRdeWs8uZ90=3D?=
X-Exchange-RoutingPolicyChecked: QZb+UxCW5Vef//qtDIAU6tTp+AZ+5xGVC1kskzjwFvrOSGXFwRyzYt+/C5m40vaBDgO3vHW55UzCCSPx06mqABOetRH0eEyln1gl6eRCaYqqCB9+xtpNIXFpczdkM2U5uD0s1EpRYAWatrbNTjyU+louAKZJNjdGt6L/9pwTt0lECmm2oGNTkAcoj6bDj+83QJhuMWFdmOMJPZb0XNX8NyQF4vA0A9pchspkSCvOVYcFanWKvbpFNY9QezGsV/MgzJpKnZvngDsh0UdvIcC6gQDVBb9N6ozc3vY4XuBFTQuLEg5sUFeDe0w+2U5ERv7NWxA9mOIJgdKTS5kxJCwTJQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 425288c8-b7c7-4256-f2f4-08defd3eb4a5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2026 15:38:09.6901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FSNwTpqg6SbqS+xx0Bocha3CNy1bQ3ET2CQIMKMdX51d+wBI2RsCTbZjEflwpphVMEu5FhM+AVCCSGIIRtwuN+hiCzU+cidL00HW9G5Nl1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7824
X-OriginatorOrg: intel.com

Hi Tony,

On 7/29/26 10:27 AM, Tony Luck wrote:
> Linux allows devices to be unbound from drivers, even if the modules
> cannot be unloaded because of reference counts.
> 
> For telemetry this results in teardown of the virtual address mappings
> of the MMIO regions which hold the event counters. Subsequent access
> to these counters will page fault.
> 
> Export intel_aet_invalidate() for the pmt_telemetry module to inform
> resctrl when invalidation is about to happen.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---


...

> @@ -373,6 +385,18 @@ void intel_aet_unregister_enumeration(void)
>  }
>  EXPORT_SYMBOL_NS_GPL(intel_aet_unregister_enumeration, "INTEL_PMT");
>  
> +/*
> + * pmt_telemetry driver calls this for unbind/remove operations that
> + * will invalidate the virtual addresses of MMIO registers provided
> + * by intel_pmt_get_regions_by_feature().
> + */
> +void intel_aet_invalidate(u64 pkgmask)
> +{
> +	guard(mutex)(&aet_register_lock);
> +	invalid_pkg_mask |= pkgmask;
> +}
> +EXPORT_SYMBOL_NS_GPL(intel_aet_invalidate, "INTEL_PMT");
> +
>  bool intel_aet_pre_mount(void)
>  {
>  	guard(mutex)(&aet_register_lock);

I noted your request for discussion in response to sashiko feedback on how this
disabling is done. 

The internals of PMT are not familiar to me. The goal per changelog is to
handle the scenario when a device is unbound from the driver. Could you please
help me understand what a "device" refers to in this context? The new API appears
to accommodate packages/domains coming and going and I am trying to match that
with the pmt_event_group/event_group. If I understand this correctly this API
a "device" going offline means the same package(s) of all pmt_event_group/event_group
go offline concurrently? I think I am missing a lot here.

Reinette
