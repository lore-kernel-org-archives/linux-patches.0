Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFD01FD4
	for <patches@lists.linux.dev>; Thu, 20 Nov 2025 22:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763677072; cv=fail; b=NMF3qlz3mkhdBVY6hEMctEbG/KyKI9wvP/xh+vL0lUpfYaDUBQtT3/ZPSa3NHmHXnU2Hfdt2Ubi/I6FIMfpx1GRj5ThVbAvL80MwLZcPuXsaCe3d0ZXBzMd06+Ozx3TZv078QS8Zx7e4jFUOUc4Et5W+xNs9tJ5tdvH0FscfZZM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763677072; c=relaxed/simple;
	bh=4RqonVk9KWRmPEH0LjyRc6BUfJRXlmMcmSW91ue8TXU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KyjjiMG/BcfPwKWYIP3NQhu0+tmdy6/Wfyu5DH2JXQFOvtV//ba9OJ31UVtVX4UimgHxJj2V+1QB0ZS5RsVoQGHDaVg15dZTuBC7ND46AjJhBn4+IvGjVD3vJuxkF+12wHCF9xjuVPMH3Lgh0G1owiY1RnTNKDsOmfW80cIWQ/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ngwOpdO+; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ngwOpdO+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763677070; x=1795213070;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4RqonVk9KWRmPEH0LjyRc6BUfJRXlmMcmSW91ue8TXU=;
  b=ngwOpdO+zjCwKWCfMhuO4jat75PEvBVks94mVHx1gAiS3x1TQpRyBfXd
   Q0EYJMFrWYFhhCMC5uswxve4AV3UQZfV/U2zPFWf31AsMeux0Uc+geG7m
   GXa/0lHAYYlHNq8Q2gxcf1tbcB2jWdE256UIMhTohH20U58civeU5HtDz
   Xh+6fJVMEK7EieO45+KPtsKP/lCVnzfrJxSOzpACDPztcmK2rDgzTN1Dd
   c/eSH2FwEqEBp/tz623T3GzN3jNrNMCyHrzF1i0EVQAc7idOkyAGdOLUI
   4AwHIc0NUQc2tUzlrNswaxrb0hw/5VpxDZ+84GNSXre9wqr74vucm21qA
   g==;
X-CSE-ConnectionGUID: Dxb8HMLIRhOy+nOMXdYrJQ==
X-CSE-MsgGUID: lLU26YmQSbOeA9aRv5J77w==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="83385823"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="83385823"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 14:17:49 -0800
X-CSE-ConnectionGUID: VVGm/P1ZSRKfMifd3ZG94g==
X-CSE-MsgGUID: R0oaUf6dQ8S1FrPQjLmwrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="191185925"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 14:17:49 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 14:17:49 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 14:17:49 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.37) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 14:17:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSB+VkcSWjrHDE1FxYXxYIjA7r2m0ZVefuXn8jbqkM712aQMx/CqCKW7T8GM5GO+ozyF4pPuVFoo8oL0rKRBUX5+qJa4abn6nYAKOmbRA6Ou0AIfuBnQ+J9q8Iw3kUR0hfO+qA2Y3o/KcJTaOVrhnEf5TOPd1N0VT3gd6+Z9EMBKLtO5OADiYtpbhElJv12A10sEpMUw4UJDpyeFwNgsMfaNLql6UCFF+zId3bMMsvFrxd/YL0b5PkzuP1flALAXoSWjXU2J/CMXAsiDqTn2iBcYoKec3yDZ+ojmXgO1qfCzo9rtmQaSH7gwaDujwjmpk5lU8ZR4T2eYbwgdXcfLxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HO3nnNVoRFhSwVQpdNlfhoEoADmiThXligm/0Wrw0eQ=;
 b=JnXq53Se9CA0CrnP+FSiz83sR11qaSVBI2k0u6xDfGk0bz4LtgJOL8hFAemG2BYIPDJxAF7Lv33xJ4cKS5LZ1YAk2GkSwjB0g9Nn6IrsCIiI1TIbXzJniszT50kjjaLxfxNHfwpiL4CBCcgD5J9cj5bDAs0JqKRIrjiztZszgZ8KjidAB6kNRIOrXWDsN+fxSunPHn8HOEqHNHaEBmykNKXzeMqBTgmBjT5pqfKH3fO25sH0OQY37yw8EnJ2vufeVmS2/HjQheqckRpl3XIPPkh2QXdyj1kdo7aCtipmB/CuIKYmc2n2EaRfONz9L8jo43mFdFQ25/pjBwBsxcmAxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by MW3PR11MB4537.namprd11.prod.outlook.com (2603:10b6:303:5d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 22:17:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 22:17:47 +0000
Message-ID: <fc1465ab-3df8-4272-a5a7-101887b9a82c@intel.com>
Date: Thu, 20 Nov 2025 14:17:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Consider sparse masks when initializing new
 group's allocation
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>,
	<christophe.jaillet@wanadoo.fr>
References: <abbbb008bc09d982d715e79d3b885c10f92c64e0.1763426240.git.reinette.chatre@intel.com>
 <aR9tbOMEVSDGvtoA@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aR9tbOMEVSDGvtoA@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0377.namprd04.prod.outlook.com
 (2603:10b6:303:81::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|MW3PR11MB4537:EE_
X-MS-Office365-Filtering-Correlation-Id: ac490675-e1bc-436f-c0b2-08de2882a278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZUxCRTNzNm5IVjlrUDJXTFFsVmxJMHR0ZTE3eVRCeU5FQ2lMbEVXbTB2akFa?=
 =?utf-8?B?Rk9MMzVzQ2E3TWQvNVVvRDRzcDBTRTRKa3N1d1FhaXNPUkY2TVdaTTZYZVFL?=
 =?utf-8?B?emZPRkxyaGNTS1dxWnhqQi9WUC93NzFBZmwrbEJSR1U5SjYveVlUVnp5Vzdz?=
 =?utf-8?B?d2xqYnlXSUc0SGdQenEwSjh5MTZINmZFM3ovY1lQMmhFYlZjMGxTYjdVYUs1?=
 =?utf-8?B?MHlhR2p2dENySUJaM2lHakNOMHZIeDBmcllIUHBkeWVOMDZGaE9CYU1wUGR2?=
 =?utf-8?B?aWxzVTVPM05LM2swRitwazRHZTlMTEwwcm5FS2p6aldSNmZJbHVGUkxKLzB5?=
 =?utf-8?B?Qy9Wc3FGR2llVzlkR2EzVFVocTFUMXZOeWZ6VXM3dWNNOTlFR3BtQk1hUnMy?=
 =?utf-8?B?bUpxUUJJZWtDNzF4QlFvSWRKZDduekEwV3luS0RxTUtXTnphczFLYUVUaFl1?=
 =?utf-8?B?S0tSYnQ5ZG9MK1NKdFRIbDJYTFphUUUwcTk0OEZIcENWeFBaNHpmbkRvWm1o?=
 =?utf-8?B?YTE2aUR4KzlGU0N0SU8xbEJCWURocyszQ1hLQUhyb3RpN2ZrRUoyVTdCWitl?=
 =?utf-8?B?RXVmZkVJM0lXaWo0U0xCV095anNZUVNOelBJdVpKUVI0OFlxeTRBUVNvcWVt?=
 =?utf-8?B?ZDdvaTZCQzl3UTRSUG1TTEM2ZkdwRHJ2L2lMUzhjWVFlM3RsTEdKaVFocU9a?=
 =?utf-8?B?K2N0VzN2UTBDTEt5dTNKUko5Ymw5US9nd2xyVFAxTytQdGtKM1FvWjc3UllB?=
 =?utf-8?B?cHFEVGxWemU5Uk1PU0szSmwva3ZGZTh0SDFPU3MzaTJlL3FnR2RaQWpBVURG?=
 =?utf-8?B?VHNYSmVNRVlObUYrTDh0azZsTFhjVy9CNC9DbG9Rc0hVOUs2RmhJTHl2VzVN?=
 =?utf-8?B?cmovTkM0QUZjRGxBRmxKb2RrM2sydzh4dS85SkovZUJ4OGJoZDFuTTJuS1lQ?=
 =?utf-8?B?eTgyMUhSS3lyMlNLTm5YdnRjQSs3Ym84YjdWTTZpNkx2K1dHT1RCOHVEZnZI?=
 =?utf-8?B?LzBXMU9GdkF1Qkk3cC90RHJiY0YwbnJWMzAzMWNxL3NnMmNRRldwSXNNZlRo?=
 =?utf-8?B?RCtFckFDYTI4bk9qS1BwMm1QWC9ISFozSjBQalJnR0o2OCtZbnZVOVB3TStQ?=
 =?utf-8?B?THNyeFZOUzQzcExpVzYzcml2ak4wZHdqR0Nwa2tYd25ZbkJ6dHplT1lHaGU5?=
 =?utf-8?B?d2MzcHlRUlk3SCttNm1mMWF6bGY0SmYwU1U2ZlN3K0k0QzZBdnlZaUs2QkhQ?=
 =?utf-8?B?c205cHpYR1BFeXpjaFU2T0R5czFNeEZ5ZW5EVi9mR05zRHR3VGwwU1IxMnRV?=
 =?utf-8?B?UEd5c0hTTDNlUVZIMHB6eHRQejJpclFWL0pqNHZndkswdFNDbTcvQStsRjQ2?=
 =?utf-8?B?MWRRNnZZSTJVcGFlT3ZSeXJySE5BaW5kTElrRE9JczhoWEo1NFBkd0tJVWhM?=
 =?utf-8?B?cFJvYmhlbUVRYjBmamFrYzdzdGk3SEgzdVVTcnZtbnlPK2NiNzViem5vWEpK?=
 =?utf-8?B?c3pZcGczcWpwVENXZDNjNWZ4MXhqYUpxNzRFeWtLQnpsTXBXcVlXejJmOGJV?=
 =?utf-8?B?MkFVd29TU1dnZSt3cno2d3h1Z21WcU5JTXhabDJjQlIwcjdIR2JjM1Z3d3k5?=
 =?utf-8?B?RkVEeHUwaDZHbFZHYnFYT3d0dFFTUFFOQTRPTldNL2F3VjdWdDR5cWVnMkJi?=
 =?utf-8?B?M0RFcHBLMmdVdGxiN2hjeFYyaDc0M3lRWUx0bU5tejcrUjlXU1JuZktJZ083?=
 =?utf-8?B?K2VRQmgrN2J0TzU5OTN3Z29UMTJkVGk3SGRFRXJwWWxXVlltaG5xL1FIeXZF?=
 =?utf-8?B?MG15Y28xRFFUU29UdGpKWnc0emVkcDRqTi9qc1V1T20rYzZUWWtKS01sUVlE?=
 =?utf-8?B?dlhXZWtjSFdDN3pUejFKR0ZweVV0OEtxSnVKaDFxbmxIZ0U0cjUzbVplUmdZ?=
 =?utf-8?Q?jc564Ft8MfeMsoc1EFH1xltFcR+9jaQi?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OCtsa29pSDhYU3FHYVJ2M2xXU2dOdVRSU1ZKbTJWTDUrcDlqdWFDUzdpNUQ5?=
 =?utf-8?B?eENvS01Ya01VMmp1Y0M5dWlVTkZSOEtsc2F3aVpPZ0x3MUV3L1FNWi83RkIy?=
 =?utf-8?B?cHAyam9OUHhxOHZ1TG56SVpldGgrZE1tSzBaWVJaTHNrNytQTHdqUllHVVFp?=
 =?utf-8?B?b28wVW04eW4wanBKS1VDUU12UXZjb1grUWxPU2c2UjlGOWJlS0VDUU9JTlNi?=
 =?utf-8?B?dXgvcDd4eXpJaEtETUlaNmhuc3hRbE5PTjhLNVBQQnVEQnBQRE5JSlo1OTdU?=
 =?utf-8?B?TlNjaEg4b2Z4ZTN1TVBDQW51ak9UUGEyY2VlV3JRUmZLU0ptUHMvQ1liTHNJ?=
 =?utf-8?B?R1VqNitLVGRhZ1VGR0xMRFd6R1UyUkU2NG5JYThVS2hRUzZ1QkJFMWRIRHBw?=
 =?utf-8?B?L1hXaGsvdFkxbXBGMTQ0MWRibXVHUU4rd3NBWXRMK1o3TGN6aDVhUWxzZmEy?=
 =?utf-8?B?S05sSDJVZHdpNzZFWGQ4SE5tVUZpTm1jTU56MHBFQnRkdWRQdklqdDJ5Z0VY?=
 =?utf-8?B?cnZZZmgxQnJQMUpzcW9EYUlhKytpY09EMytxREhwWlhlSko5SE93Ym9JblNM?=
 =?utf-8?B?VzJheXJhODlWSGJTemhsWHV2OTNHdXMwRkttd09VMkpwbGxIWnpIMGE5eU0w?=
 =?utf-8?B?YXFOVmF2QmJ2d2Ixb25mdUg2WjM5WDZiSG10UWdBQkVtazBzQmN0M292WmtS?=
 =?utf-8?B?dmh0UVpMYlRtcVBXd3dHRWgrNFFXdTVJSkNRd0RkNURnYTMrYVlzazZLbUtr?=
 =?utf-8?B?bjNJdXgvbWtxYTRjamdsY1FLTmdnQ3ZCaklJK1oralU3cjdIZ1RmbXZxOEVZ?=
 =?utf-8?B?b3B6RkJlNTloMzRkKzJYVk9TRjA1UHZMMk1hemtvcUtTVE5KcjlUYzllVjJQ?=
 =?utf-8?B?UUpvTURsZUROaDlNN05RSVhsRWNDbFhkSU1TaFVQRmFrWFNtMFc2Z2pWQXBu?=
 =?utf-8?B?RVo3RHBxYnJyZTZHSnJjQTdYMm4wc0ZITXNkUzlaTTdKdmpySk5qMS9aUTZV?=
 =?utf-8?B?YXk1ZVVGRFYwLzgzS1J4bnR1cHZvVTlYdEY3TDZIc3NPbHpjZWFuZEIyYVZ2?=
 =?utf-8?B?cVR2SmVEcUxWOXNlSlMvTmRlRHpLNE5aeU5FSC9IVzFMRG1ka2p3R1RXZGt4?=
 =?utf-8?B?bjRocElxL3QyRCt1T2VwSVFMY0FCa3hTbjlCOUVyTE83akt1K0IycUcrOGMy?=
 =?utf-8?B?bVJVajZMdktkWGdkWitkbHR5Z2d3ZzJraG9BVU8xTFZKQXk0MHpXNDM2MnpR?=
 =?utf-8?B?UVhNZjBMeHMrZmNwM00yTWpqRTRNNFE5azB5ZkMybTZvc3p6aGdMaEphVUlu?=
 =?utf-8?B?UTJRMm9abjJxRHRZaFMxQnNTZG1ucmdzNVBidTk3ckxRVHk1Q1NUR3YvUXhi?=
 =?utf-8?B?OWI0OEU3TTBzMnl0ZWZDSE5LakJPU0RhOC9zcUlsenFoNEs5emZHeDVpVXVM?=
 =?utf-8?B?UEdzUjl4UzVhT1RneHh6WHFlNFRIS29udDVqSmQ2QzV5SU9uQ1BJMDhjM01t?=
 =?utf-8?B?SUtIK1d0OGVkb3RROC9oVzhtN2RWVllqSXp4S251eEQ2ZktZbk1yY2lzb0Zj?=
 =?utf-8?B?UzlpaURuYTFKMTJSVWNoVHlINU1jK2NncEwrQVpUTllubWIvT0w0S0JsaXYr?=
 =?utf-8?B?Q0NNRlBjZ3h0T0VxQy9vM3pzaDFDdWZPaVRvUXJZZGV4a0xNZVlBN3hOOCts?=
 =?utf-8?B?bDgrZUF6dk93ZyszdjF3cnNnMmkwYzh0R0czS3NyaXpmNnI4SWtQcnpFZG1I?=
 =?utf-8?B?TDFGQms2VlRqUElIYStVRGZOaEhKaStsdVpwZ0pNeVNuRTh5cUpDMnB4dUox?=
 =?utf-8?B?T2hKeVFiRzNyVGI4TkdORGN3VDNNT3VRM0RPM3o0Q0hmUHIyTDl4UXRUbnFs?=
 =?utf-8?B?Zy9Pd2FkMlByWXRFamRyYWRZNENwU0wyK29HdEdVNnJReEdNclNHeHhmSGRR?=
 =?utf-8?B?VkdHaTN0YTQySnMwS0xKa2JjVURubTU1U0daUktZak1hWVU4ZHc5VzA3ck5P?=
 =?utf-8?B?MEtxSVo1S055M09rbEZ5Q00xbW1pODBySkxuMHhJQTdzL1M1eW11c1BUVHFP?=
 =?utf-8?B?MnlIbUdTRjQzVXVPVE0zWmx3OTF5UElkNEx5aUhaVS9IcjZQWmVsSDYrMm56?=
 =?utf-8?B?dmVKN2NVSzFXZU1jNC9Ec3h1WUR3WnArbHNDN3ZiTm1UUGQ4SlNIdTVsZCtk?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ac490675-e1bc-436f-c0b2-08de2882a278
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 22:17:47.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l42M5jyG/B17q3nqMHWt7f+VsaovfsCtuLvG+Dad1cld81nIB+zXdiHL76BhzK8mzWQ0yzqTHXtOSZo2xjsqIjeNBo4MB21VKdIoyuao+L4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4537
X-OriginatorOrg: intel.com

Hi Tony,

On 11/20/25 11:35 AM, Luck, Tony wrote:
> On Mon, Nov 17, 2025 at 04:42:45PM -0800, Reinette Chatre wrote:
>> A new resource group is intended to be created with sane defaults. For
>> a cache resource this means all cache portions the new group could possibly
>> allocate into. This includes unused cache portions and shareable cache
>> portions used by other groups and hardware.
>>
>> New resource group creation does not take sparse masks into account. After
>> determining the bitmask reflecting the new group's possible allocations the
>> bitmask is forced to be contiguous even if the system supports sparse masks.
>> For example, a new group could by default allocate into a large portion of
>> cache represented by 0xff0f, but it is instead created with a mask of 0xf.
>>
>> Do not force a contiguous allocation range if the system supports sparse
>> masks.
> 
> Note that the allocated mask on systems that require contiguous bit allocation
> is not optimal. In your example where the available bits for the new group
> are 0xff0f, resctrl will focus on the least significant contguous range and
> set 0x000f, rather than the larger group of bits 0xff00.

Right. The priority, as supported by aptly named cbm_ensure_valid(), is to ensure
the mask can be supported by the hardware.

> 
> Fixing this would be more complex, and I don't see a lot of value as the
> user is very likley to rewrite the schemata immediatley after creating
> the new group.

I agree this can be optimized and that it is not a priority (would appreciate
to hear if there are different opinions on this). Users that may encounter
the "less than optimal" initial allocation are the ones using exclusive and/or
pseudo-locking groups where I expect user space controls allocations with care.

> 
> So for this patch as-is:
> 
> Reviewed-by: Tony Luck <tony.luck@intel.com>

Thank you very much.

Reinette

