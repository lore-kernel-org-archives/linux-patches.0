Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8575838F258
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 20:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782939375; cv=fail; b=Ceqcg+TCsYJh0/lcd12NBYebhJsU5wHYcOGb1foCBuziyDvZAUFmx/LkxOkDZkFJO54kquTlN9BNwaRwEAXFPv0aJFyPjO/P9kre4wx4ryGHPO67UBDmyESlJeobP/lMVK6oPU49gCcFUGk1iKr0J4bOo9DqNMnY1YqXWIdkKqA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782939375; c=relaxed/simple;
	bh=G9RS9oNHxfYn1RAxggjp/7S/KkShMqssamKOloscV0c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Yj51xtaUmtXnTTjyoEvEMFw1mHzhJ1PW6mcnzc3+TNfvLX/OrHp8cyYb/19MFLqEJiSAbwf3RDcNV8zdILizLG00/wMWgX8fzSHUshONRI5IH4N005//8JjOsazKhxx9QPINv/D4x1RMM/cRpBcK+puiXRr5CyBo+2ZGIav5QC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dlsr7cVt; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dlsr7cVt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782939374; x=1814475374;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=G9RS9oNHxfYn1RAxggjp/7S/KkShMqssamKOloscV0c=;
  b=Dlsr7cVt9bWjRjKfG3exQoAV0tihyhFs8V5p+0pzHRAiu/CJHsllkRih
   +1LgSx+EfieK09MGrVtwE+T82tPXQhNI7IAdi75tE4dxeQqYZdX91zLLY
   EAAxbBXYkuFhAXXox4Q0N9H9aYE1Pp4jEs+x3ZLSMjHs0ycjgdu7sl/Er
   bMNp0rv9LoP1B9VePX1iM1UZXJNuaiDQrw0VRYTeZpUtj+sD5lDMmX2ne
   gTtwzbUzPyAYFptiUWxYhKfkYo1VL2wLb48DzW7GXy3ablNMouCH791xy
   97LmAVS8B0FPX1HplKnUrjpnLzEV51aJGl/DT99chQ/Ait8W6iPSbblfB
   g==;
X-CSE-ConnectionGUID: WhrZc7MnRV67DvYWMvVSYQ==
X-CSE-MsgGUID: hUk67dAzTCqADwJGne0hPQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11834"; a="101227252"
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="101227252"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 13:56:13 -0700
X-CSE-ConnectionGUID: Xn+4YkGrTFapr9BrIf/UNw==
X-CSE-MsgGUID: ycEy3OOgTIe+rRArvrAmBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,142,1779174000"; 
   d="scan'208";a="252234260"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2026 13:56:13 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 1 Jul 2026 13:56:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 1 Jul 2026 13:56:12 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 1 Jul 2026 13:56:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjuBdUejv3z/j3edgmOYi4DZherDzACFOcD5fveglGld/SZMgS1/YVkseSPjvo6TJZAwtcV2Hneztl5zZilzAcdzlXVCq5CrPBzwUB5WZfWzi5hRvjLyAP7+R0l3JpBrBOO9qQc0qVn/FX5yEYEjQ/Jub0NcYmd68XC5nVwnQ1rRVOZiWDudY3J37H7FJocQ5QPKe61SFYHG6YOMNg1IBRfaK6JoLF64DqcxDFKG55FYCuONgqq5mqQ6/WfOU0RTjK9O4U5bwrIDZwdfRhY/v75w2efrIUZX6Ha8Id0meJNVJ6roI5RhFwzbshdwdw/0RFS2oRTG+SZprwu4WYTXvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gr9x6oTy1k7ZasC8/CaSFZG8zdo9shSd80xNJoTLjYA=;
 b=hq/N/LhsTjdsyscOuYye1Xvv8LAUwfv/vIyFOFSbNzB6ssx0X7MVU6ZnTT0R1prPMrqQJLCNM5S7gLAueMFYXO7AITQU4lPLith3nHhFuzEmv9ZjCwhCJNu7aTZimTp1hi3wggRMmsiPPxlgNpLEhAUFhF6gGsQ44A6+Xc7CA9HJdKB+A797Hhb4eo7pOAN8L5CEYG2n7x+UpraCKPxl4bFEY5ZYc4oXgSJaKFuj8dw6CyufN9VdVvjtTCmR7HTKfBs+t361dGjQ2sgLp/3FI9+/Z9j34X81L/WRUxQYYgPLbQauNsC/7ac3XpWeq7vV2bbBgAvP1OH2e6sgha1M2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ5PPF7371775FE.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::834) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Wed, 1 Jul 2026
 20:56:08 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Wed, 1 Jul 2026
 20:56:08 +0000
Message-ID: <dab1290e-24f8-443f-9ca3-9116792f320f@intel.com>
Date: Wed, 1 Jul 2026 13:56:06 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
 <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
 <b58d51c1-67f1-4640-b00a-1a99dc93ccef@intel.com>
 <20260630225759.GDakRJ93cg21As0xnf@fat_crate.local>
 <20260701170917.GCakVJvegWA9R9liDV@fat_crate.local>
 <4ba1c1b2-325f-477c-b7de-c12bf72990e8@intel.com>
 <20260701194027.GBakVtK7d4XKEeCZ2g@fat_crate.local>
 <20260701203725.GCakV6hQ9-x2BTBEnx@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260701203725.GCakV6hQ9-x2BTBEnx@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0264.namprd03.prod.outlook.com
 (2603:10b6:303:b4::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ5PPF7371775FE:EE_
X-MS-Office365-Filtering-Correlation-Id: bbaa8c4b-8a9a-422b-4dfd-08ded7b32ca7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|7416014|6133799003|11063799006|4143699003|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: cRKzSUYAGbxUHsMT8GIx5UUj+A/nlfEB6FkeME+CF7Lv6+8qdvHmLDJln+mIRQktiNM6Gyvc92KjoCt+eGFJooGCRM+smztA9j8jqGCN9ZwuNwEuzGm8H0qh9x/gnrRuPUJC3JTxedW9l35xC9HqH6mTn73jvtkia4WotA6xPDzMzTbzVfGspTCWMzjGa5fSb1UYG3eDUmGbPiH3jc4uLAJ79j7EzTe4X+zkQQHkac+c600QOtxQWQ+wCYNHrDyYpiAqpheM3SrArw72kvQZVAhRXifqEuvQ4I5vkIORzgeO0bsAFIkMTMn2VT9WsRiaUZN1Gkjea8pRECvTebIdn6o3XEvn93/tbmjfisgpmOwlGlUelXCHUpheJ2lkgdC4FvcMQ5iPnEh95+nAZ932qTDWTBiICkeRL0LKe18KfA6F73aE4KJOrnRfUNECfV1OKJb3Kpims8sjxG9hCNpzWAHTbIP1zaogU3mdeaNYsdhXDyePYUFUhCP+1/ng6rhs2tC3bg+pEiwz3bbq3A6r4a6ITOhCZITgpGU4jNCYtVQKKiagGInM82fk+wwjxLA5C23jl15XLqcPAk9iwkdxCFRh+cfrvfKXNdKlfRpXcAVo2t9amzBZFEKMumGCr7IvznW/iT51RJ4JOoZDQfQWWkiv3NNadfGRm3JnxRzJ4Bg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(7416014)(6133799003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDlUOStVZU92M0drTmluNjF6Q2xxd2c5eG1SbmNuTnRPYWtYNVIvSVVYNmxL?=
 =?utf-8?B?REtGVEl6NFQrSXNWZXRUYjBSTGtSRUJTQ2oxWnpEUEI1THZ0OHl1d3RWQ21F?=
 =?utf-8?B?bDVCUmlMMkd6RWI4K2oxZWxTNnphRXIrd1RUcTlnOThvdS82UzZFUUVDUGRr?=
 =?utf-8?B?bXNKbEhSR0trZmxnVTQ2RGh2WTAyTjc0Q0UrVEhCNmt1OTJjS3JmREVDVWhF?=
 =?utf-8?B?dVNIU0tqVFBCMnNwbW85YjFjVnpYck9uR2hYWFFuV0VBdzltdHFjNnZaMUNn?=
 =?utf-8?B?bFUrSzhqZDZKSUpmZkVTbTZNRDF4d3JQQXFrcHQ2aUE3SXBSQjJpYzNoYVJF?=
 =?utf-8?B?bVJRVHFsWDRhZzdPanBTbEVvclZjbjJraFgwVFdsTWNnU3lzZXZITU9sYmpR?=
 =?utf-8?B?RVI2TVJWUzUyVGJlOGFLOXlGUlREeXVUb1BCVTkxaFVuQ0N1VXloanBHY09r?=
 =?utf-8?B?SzZRWkxMU2lmSXRLQjZERmRBbDQwczhVNk5iWC8ybnlwUFBPaE9VQWloVm1C?=
 =?utf-8?B?RGluZCtIN3FDNHMvNzBXQ1Q0bytJWGlCd0t4V256aTBmdWFIQnlvRVM0bUdy?=
 =?utf-8?B?ZEluZmZhNWdTUURlOXFlYjV0MHNqZ1RjRTJhODh3aDFxY2o0YWdFditZMGU4?=
 =?utf-8?B?RHVmUnQxdUFENTU4ZHhQNHhyYTJhMlNKQWN0LzNXUmwzYnZueFZDWnZORlJ4?=
 =?utf-8?B?VW1VcFMxVTZyaFM5dG1PNExsL1U0VjU2OTlSNVVVN251bTc4cWZMMjdxWHFy?=
 =?utf-8?B?akNjVUtnM2JQeUZ4eTROM3hMY29USjBGTXJlMnorcHYzQUU0M0lNWVVVL1Uw?=
 =?utf-8?B?aGNIYnlweDVNMmg1ZlNBMmxnU080T2lzMEM2RUlmUFZXZzlYYXM1bkZ4cjJS?=
 =?utf-8?B?aDNmbllvMXZ6aXF1MVNmamVQZnVBSG9mcEtNcWR6cWtFR2UrSXQzMERZN2pT?=
 =?utf-8?B?SWxHQTBGRVNoUDNWOVRNd2xvRGVsU0tMVzBMRnk2RnhxL0VnN1JFZHdDOUJK?=
 =?utf-8?B?QnpVNDJubk1ncHEwZTkwM3RveVVsclpMeGZMVVBTOS9mLy80eUlRMi83cmMx?=
 =?utf-8?B?Lzk1eXJCa09SRFQvbXIwUExvTnRtL2g5MmJrd1BBTTNQWkJsbXpuUU9POHZr?=
 =?utf-8?B?SDBRRzQ1QnNZcXhKVnVsK1A2UFFUL1JtNTZ3bDlCNmxsNWNBaEdKZTYvVEdu?=
 =?utf-8?B?REpFRzh5RVB3YlZ4VmtjNkoySkR1N3hzazdZN25FODQ5MkU0TUdoSkhFRXFE?=
 =?utf-8?B?SUVLNFdzcGYyaGc5eGo1d2tZWmR0b2c4MGZJMTBWOXNPcURVdU10TFdjQm13?=
 =?utf-8?B?NklaLzRqSlltd3MvU2NBY3J5YkYzTkNLVGtUMjZ5TSttU1lEaUxxdExGT2Q1?=
 =?utf-8?B?Qkx0MkVDWDJFazZaY3l5OHNMejlSZ0FEU1FyUEJwQU1WS3FhSjExVVFlbXhy?=
 =?utf-8?B?SVBvRWprdWtXWlQ5a3JFL0pHUTFzNWxNdDBQV1VMNlZkQ0N1bW4zRTlrYmdo?=
 =?utf-8?B?ci9TWVNES0w3SWpuc09zV0ttTGRjN2hhMFd5MEozSVd4Q2doNGV0bzZjbVlS?=
 =?utf-8?B?WUlUN2cxNWlKVHhtZkFYakt6cDc4MEF2cGR5bFM0K3AyeHJSVUMwS3RPQUhR?=
 =?utf-8?B?blMxRGtzNDc3VnRhODBFZFV0WWhob1RnODNoNG02NE96bVlDWjcrNU1qaG9B?=
 =?utf-8?B?KzZqdnNaZmh1TG9GMDlZWTdFRmJQNkdRU1JXNjFnMjFvT0krcGM1WHFCQTFS?=
 =?utf-8?B?R2pNSzFwTUljMkwxVDhXanVFRUFyZWdVT0xKek1mUXFFZnc5Q1NVdEZoZW1V?=
 =?utf-8?B?aFY2S1Aza2hucG1LTk1MV3ArczQwMzJqcnVCcmo3NmdVemJxemtwQTNwUG95?=
 =?utf-8?B?WS8yZHZaQU5Td0k2aUk4dXViMVpXT21XVUs2dVBZTWxFQ0tJOWoyRW9SL2NK?=
 =?utf-8?B?c2hLS25ka3FrUDhXWk84bnMvaGczQWwxU09QOWh2cTJCRVdiLzhYU3ZoVkNt?=
 =?utf-8?B?UER6b0RlS0VQSXlub2o5Sk9PdEVmd0N5amhnYXlmRjhMZStSbGpZQ0JXamlN?=
 =?utf-8?B?SURUcVBLUTlpcVVYaTQ1TmErKytIaHJVa0g4MVM0SUhXR1NaT2toSnp5K3hD?=
 =?utf-8?B?U0YzaWJMWUNTQkhGd1M0QzNlVGpOWkxzMFdPcWdnZEttR2Zid1ZWaU5NUzVa?=
 =?utf-8?B?ZDlFYS92ZHhtNHE1V2Q0VUlXKzg0ZGoxakQ3Zzhpbmh2RlhSSklCejhMM3hl?=
 =?utf-8?B?QW84Nml0d2tOL2FMOTNlNll5cXNPR052dzRxUzZuY291Zk5uWVgxaXpEYVgy?=
 =?utf-8?B?Sm11Wi9ZQ2kzYTVtcktyVXdhdjFHbXp5NkFGbXlxa2hibDMzTXJJYmFPSnph?=
 =?utf-8?Q?bjBcirzplv2ju8p0=3D?=
X-Exchange-RoutingPolicyChecked: IowsdctM0sj1UEMY5ipFu1XdyQ6dc9ILkTFeEOueQjsH+YcngAnV5xbmXc3ZAJRlAjXTeqbb+8tTfpHWuG/Q9uqe9KCut9QPM3OzDXsnWk2wsIyaMkdkx4OSjqhHFKH2kwG2/NvZmmmVcSmnxMwyLOpgv5fr+lCaSFDL0BB0HNTvnDY3gebuSdSedwkEDgToxD2/0xg+HaqpEqnfwEWnOdnQpBM08xgKhVkn2WiD1kRT8w0xAuSp3SLEKY3Wpnix1SnXmdTrztip2VH0UMAmKhJ14en5N4Ubxpz/VLLvu+f/bdCiM/WcIxqJIryv2HBTBPiFLnW454ZmFgDJDuu/TA==
X-MS-Exchange-CrossTenant-Network-Message-Id: bbaa8c4b-8a9a-422b-4dfd-08ded7b32ca7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2026 20:56:08.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /2jMB8m9DVVjeIMip9lJbFBpgHDMsmk1WAZUgsniEKI2jE2K3TM5BVyIMJlLyynpXLyABW44Z2bMxhCHgUyoxRpNzV9N3IzoVy6NMGi0hwo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF7371775FE
X-OriginatorOrg: intel.com

Hi Boris,

On 7/1/26 1:37 PM, Borislav Petkov wrote:
> On Wed, Jul 01, 2026 at 12:40:27PM -0700, Borislav Petkov wrote:
>> On Wed, Jul 01, 2026 at 10:55:38AM -0700, Reinette Chatre wrote:
>>> I agree there are serious issues here. What prevents me from advocating for them
>>> all to go to stable is that the fixes to the intricate races required changes to
>>> resctrl's core locking flows. I absolutely tested and scrutinized these changes but
>>> having them go straight to all the stable kernels feels like a big jump to me.
>>
>> Makes sense to me.
>>
>>> The fixes that do not involve locking changes are below. They could be considered
>>> for stable.
>>> 1/11: x86,fs/resctrl: Prevent out-of-bounds access while offlining CPU when SNC enabled
>>> 4/11: fs/resctrl: Free mon_data structures on rdt_get_tree() failure
>>> 5/11: fs/resctrl: Fix use-after-free during unmount
>>> 8/11: fs/resctrl: Fix double-add of pseudo-locked region's RMID to free list
>>
>> Ok, lemme hoist those up into urgent first.
> 
> Yeah, not easy, see below.
> 
> This is because 3/11 which is moving the functions, is missing now.
> 
> We can do a forward declaration but I'd let you reshuffle things the way you
> want them and send me the urgent fixes by placing them at the beginning of the
> set so that I can stick them into urgent.

Will do. Since these patches are now targeting urgent and stable, a forward declaration
would make the backporting easier. I do prefer to keep 3/11 on top of that though. I will
prepare the next version of this series to do this. 

> 
> I'll queue 1/11 only now.

Thank you very much.

Reinette

