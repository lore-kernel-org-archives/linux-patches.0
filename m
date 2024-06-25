Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C24417D36F
	for <patches@lists.linux.dev>; Tue, 25 Jun 2024 23:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719358428; cv=fail; b=S2XY0qwOLJdpFBOyJFPswNiUqk4HbWeESSw+CBQYUSWydAjau4pQeznq9IAm96anC4GM1PHIAt1ldoS9DBMaU6lCM2t6RXNriaGGCUkrUT3sZ530Z+kN5zOjvSpyOjFKx3AU3a5dJkfe7udmKdjaTx2FjPerhiBmrODKop0MxRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719358428; c=relaxed/simple;
	bh=nu3PMzs1+6iC7QopFOTwv7rJRbfzUVPwSghtqthzNKo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=utlOzqM2b6AZJSjuVfJn3OKl/NvKQ16TwEc528L48Ldb7Rc5cs0rJ76pl/PlRArIsgLQIBUA0KU3GssV2OgTqUNlY836IShMhHa71DKTQuy8EcjdonB9EPBhfhs8MuYKTLgS2w5XUJtEaj3geYemOUZUWTABNSUpGlYQeu23QDw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BKlKu4v+; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BKlKu4v+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1719358425; x=1750894425;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nu3PMzs1+6iC7QopFOTwv7rJRbfzUVPwSghtqthzNKo=;
  b=BKlKu4v+xXfCz97SGytJpfgMalZkIU9oPVMDSoTjnqJ94JQ14nC4t/+h
   0pMnWPikpO8MoLIJDs4ZCR9c1pA0SFqdtHcOT2SdUZkMaroUIKaESgLl6
   0Nv7xgsZFPxkPulmkzdn/ZB2sfeoEnwJwZbywTBp7NnCT1GzUbeB3DT3g
   jfvhLsAwqI+scrShWUtXD2LPobbXNUx62TRm5fA6PR2TX98gtZSJXKeEK
   oP3t0VVxjPnU21C1lG1kPiLn7yuTu1S7PCueFAGpYDXhP3OpBsI/13xwv
   3gJTBKQL2J1faUZCBmnpuuoc+VdVhlprl5+8E0MP8Ftu0rm++ebsYfpS8
   Q==;
X-CSE-ConnectionGUID: Cs45MCw9R/mqTnxeS6NAHw==
X-CSE-MsgGUID: q42bPqYCRH2v30e/4/21YA==
X-IronPort-AV: E=McAfee;i="6700,10204,11114"; a="12247408"
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="12247408"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2024 16:33:44 -0700
X-CSE-ConnectionGUID: H93ZioUVRMWSUxiRQmLduQ==
X-CSE-MsgGUID: L7LvFFfrQbuBG1zeyecvPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,265,1712646000"; 
   d="scan'208";a="44461673"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Jun 2024 16:33:44 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:33:43 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 25 Jun 2024 16:33:43 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 25 Jun 2024 16:33:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 25 Jun 2024 16:33:42 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oE9VyQ1QE1T3ZwIHVGDFYYwpy74EPpiofyXZfflZQdFc270BffkI09OCkoSv4txKMor5d78cxN8hg1fwAwFEOvBht1YDJlUhB3sjl1VDa0Y+5q/zc1kYvpMqdG0aE4YlZOJFUw088D0/raIIJFRYytmA5Oy1PjlMfnhb36kFojr9IiWk76hSdWQ5YB+BgyPwK+v8jmHHfbxFy76Rq6QYa7bJb02PDaaFKXxjf9TlcmdC0+hUkPGewkpausfMV8MDxSC1Wn9QpY320jlFF4+bw1mEu7Dqz/Hob+zXPk5GwEKvRABaJPVlnIMfgk24E27WyssvreRtMYe7jrUjORmaYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/4rSsba3Stene9g08kqT65cHXfOxtBHhK7O2vvlX9Q=;
 b=Ag642d52P/NoyjksseAz/vvRbLaJg4pRTP6ANPKk+sTurdLc8qzq2aQ6xxcrvvs8Ds1A4ci4HdFWACuo9bGqfVLJ7Ekx9vVhFYq44J1geGS+relLSZCsqs4SPZOzJ9B6ZZs+gwtOjw5R6FrTa/VSBAYEG/6QG1zY0qbPeArUQ0rcIkiSLzHrO2MYiVQn91fg+18CVqLoHM5NrZX/U5P1p2hdrxrEOMoYRAilrk1gtaq4WqXrAuU6vT+hHOAGqoCK3XjmuqC7Doi01XSMgOWNjFU2fMLUzK7egkcgJDF45SNGW7HJ6qtJK8Sa9h9EF8ilKe32QgzIVZoaWLtdZOBLYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7170.namprd11.prod.outlook.com (2603:10b6:930:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.30; Tue, 25 Jun
 2024 23:33:40 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.025; Tue, 25 Jun 2024
 23:33:40 +0000
Message-ID: <8df55906-23b1-4772-ab11-703da64d5ebb@intel.com>
Date: Tue, 25 Jun 2024 16:33:38 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v21 14/18] x86/resctrl: Fill out rmid_read structure for
 smp_call*() to read a counter
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240621223859.43471-1-tony.luck@intel.com>
 <20240621223859.43471-15-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240621223859.43471-15-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0082.namprd04.prod.outlook.com
 (2603:10b6:303:6b::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7170:EE_
X-MS-Office365-Filtering-Correlation-Id: 08d173d7-fd19-4e20-edad-08dc956f3ec1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230038|366014|376012|1800799022;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bGdmc2VhMjZETVprZ2tQRFRscHN4TmpCc29pallTREI5M3lUc1NISzRKTlJ6?=
 =?utf-8?B?MG1iaitVL1c3RUROYi81V2dkTmxmNTdQUFl3anMrcmg2OFpVQ05oNFhhRmRK?=
 =?utf-8?B?WHY1dXM0MWNrV0xJY0lUREtEdG1UNmFXdVR6dHRLWC8zYzhJN2I3Vk41bkJF?=
 =?utf-8?B?N3o3S0VjRDJNQjdURms2MDllSlMvL2Fqb1NSRzQ3dFB0UDhURkJOb3R4NnMx?=
 =?utf-8?B?RllUWFBGY2JtZnNqWDlWZEEvSUJ3TDN4cFJlanNQcCs3cmE3M3NJSVBoQWIv?=
 =?utf-8?B?YnZrckhKV3UyaEthSTIycVllYU4vV3RTODJVc0RSR2FuUy8wRnQ5ZFpyK3Zv?=
 =?utf-8?B?UWt3Y0ZITXJaL0pOYWM4U09qby9pMHRxRzUyMWN1M1FMOHF2TjZtOW5Ca0xu?=
 =?utf-8?B?YTVVLzNlNWlEVUFXcnpTVXQzMGVGT0h1bzN1dTFTZUJ4cTJza2MwZjVQU1Uw?=
 =?utf-8?B?bWtLSHlVQjVwTkJ3R1ZLUHBlQnBQbDc3cFlQV3NOU3VSSDBMZjEwUlVFNEZ5?=
 =?utf-8?B?QUNjQUlLQWI3ZTdkaktpQ3NLSFk3RkZjVjBGNDFMTGM1TFc2ek93TzBDa0s0?=
 =?utf-8?B?UkRYU09VN1VxV3p2VjdBeTlzcjduQS9Va3dVVW5XNVhyZFlpTWVCbGdFOEYw?=
 =?utf-8?B?RndsQTAyUGlBMGJrVlZTNXpLbVpINGdEMHVFRmRGRlNhczNBbEhuQjVuVE5Z?=
 =?utf-8?B?dmwxcjc3OGhETDBzQTI1RktUMkxzZURwZTBIa2htZ2lXN3ZvK2hpS29TNVBT?=
 =?utf-8?B?MzJoOFhFZk5WSFZCaDBUZjU5UHBLTWd0MXdLUGprK2o3T3RISzBzQVlhTEQy?=
 =?utf-8?B?WjdESjYxVkp6d0M5R2o4RjJlN1NoZHRZcVJHUnlydmJWZTJRVTdnZk5wVmpy?=
 =?utf-8?B?eTgrN2VnMjZzYW9OK2N4eldaV1ErWklmMTBOM3RLcXNLMlVHUWVyQ1RkQVhr?=
 =?utf-8?B?NzdPOUtxWW5rdmNCNEdQbTVNbms5cXAxMWZhaHRlRDNidkZpL01OTmxJNW9M?=
 =?utf-8?B?UCtLbjBhOWFkbTlpTEdWRVZmVWJCMmdNUFYreXJqK0lxUFNDQnBqSk43d29q?=
 =?utf-8?B?ZkdRR1lwTGlnT2VSc0xqUmJQQ3JCT3loYzZvY3B4UHFDek9HOVJIWS8ydnE1?=
 =?utf-8?B?K3ZvUjd5dGNpSlArTnhLeGZCbG1oMk5MQ240RTdmaENRL2RZMitrWGNsWmVm?=
 =?utf-8?B?dXBzbUcyRFA3NmxUYmFrakhkeGtNNldCTjRBckxZT0g1TUxoTm9TamZUMFYz?=
 =?utf-8?B?M24vUzZ4U0RJYnc0MGk5RW9HTFhkNERCVlcyQTQ4T3dpcXFCTXhrNzVyQVYw?=
 =?utf-8?B?cjBIWWNldEhDdHVJYVl2SnlTOVgrbHRFb1p6QVNvRnNKMlpZOGVQWTAzY3Fx?=
 =?utf-8?B?NFpUT3grK2dGZlBEL1hreVFXUWdVcUdFRnVpdS9LYTYzRWNzYUtGS3hpL0dP?=
 =?utf-8?B?dGFBSjJBdk1OT0pXL0tUdHUycUZQa2hPTUl3d2hsTGtId1dyekFpWXJDTUFl?=
 =?utf-8?B?anJFKzB4WmNPZmJOOGExd3FLZUMwZklCa0VqbjdySnMxNTAwWTgrZ2l4QTJM?=
 =?utf-8?B?c1d6cTNSd2tIN0Y1VG1ibHFQZSs1ODh5clZ2R25IR2JVTWNhWis0N1VxQmRw?=
 =?utf-8?B?RjdtRHpVNitxQnRvR20xVWk2dGpyalR4NElnWTJybjRBa2REOEtIZHZ6VnJT?=
 =?utf-8?B?N2lXNGd0UDBWQmtETllvc1JXMGRqeG1lbzFlSDkvalViSHAxRk5uRDA1NFFr?=
 =?utf-8?B?NEtEMVZQUDhEd0lWM3NqY1Q0Qk81VmhUWHpJZm5LRkJzaTduNWpkb2U3S3F0?=
 =?utf-8?B?RmxON3RRUm9LMXFqSmJpZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230038)(366014)(376012)(1800799022);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3UwWk50UTZQQ3dNdW1RbkY1ak4rZk1yTDVrTFNnYy9EUkhRWDVXbkxFMEZV?=
 =?utf-8?B?TklybVVJamdvMWllazltZktLQ0pLL0Q2SlFudkxYNUREb2ZIaXI5cFN2R2gx?=
 =?utf-8?B?bEJEOGY2RmtCTFJjVEZQK2hxd0VsSldQYjh3MlJxL0RhdlhnZUxUcGNOTTlj?=
 =?utf-8?B?aWJGZ21KNVJSaVJzcXVLdFNZZ1QzTTFDc3k1OEtPeGZoRE1YeElMV0RuRTJw?=
 =?utf-8?B?N2Jkc0FJeVNSSGwrQVlyR1NpYjFNUndTYzR5WTZBaDdFWGhMZTEvZ3JRdWh0?=
 =?utf-8?B?aEN6MUw4UGl0V2w5ak82Y3NHZFpYQjFTMlZRQVg5MURSMm9QUWd3Q3BJQU42?=
 =?utf-8?B?RVBCaWFUS2JXMFRVNmg3elo0M29uRm0rdi9EbkVFcU5SMDFIVFNnV01UNTky?=
 =?utf-8?B?b1pjcUpNSjNSYTU0cDEvZHdDbHJvcTVSbFY4NFN1d3hzMFJLWWJJdFQyUXZa?=
 =?utf-8?B?RHp2ellWQUhoRERoeC9ZTmZieTJpYy82UmRuUURuc200MXBpZ2JiV0NrbHlj?=
 =?utf-8?B?bHI1d2N2c2VrWFd5TG9CN294bGlJUkVpaVpOMDFUUDRnalRBdi9EaVRDVGJT?=
 =?utf-8?B?c0ZtV2dOUnFBRDY3b0pXM3kyWC90VmhXWUxkbWNZa0tLQURSaUVUQ0g4QnJX?=
 =?utf-8?B?T01xT1o1R2lqSUcydDFyZlc0b2ZxN0hSQS9yNitMMUUwSGZXNjEzVFl2Y2hG?=
 =?utf-8?B?ckIvd2ZxeEhZaElBMDVDemhWMC9xN3dabkdLWXBhNTRuY1p4R0dBZ2dad1JN?=
 =?utf-8?B?VWZOM1hzc1BZd1RqeGxGWi9CWDVxMklYSGxEZy8xdUV4dzBsMDUrYkRENUJC?=
 =?utf-8?B?bE04Z2FZR3hRcGVFVi80c05YRHBmT0NhelJZZnZPT09ZM1V5WDdWYTh2bHc1?=
 =?utf-8?B?cjRTS3BkS1hzZ2JUbDBtdmpTYjNuMURLYXV3L3o5dHpMek1iUlEwSWt5Mm1y?=
 =?utf-8?B?RzJqWXZkNTc2WG5iTnZKWUwydHBrRlE5Q01PRlZZcFlnTncvcFArTVFoampp?=
 =?utf-8?B?Z1o3aHpzeTROZng1c1VPam05U2t3b2s4L3JDcVpPc2l4bTdiNjQrb3ZvQ0wy?=
 =?utf-8?B?VXlYa3ozblBRQjJLc2w0aTNSQ2hJL0poM2xYN1hQazV6dHF3MUNkQ1BuMTBq?=
 =?utf-8?B?UFJtM2N4dzBEWTNPVitjKzh1QWJqQ0pCbC9qS2VJRmFwZC96SkJTdTZOSFhP?=
 =?utf-8?B?WnltcGdNVHF5US95cElhSkw0OHZCMmlrbkUwN0ZVcWxMclVXT0EyRFRkT2hF?=
 =?utf-8?B?WHR6R0VyM1ZHRHpQZkZTaTNVbFNFWkEvd2JmME80cUpYVVdLZ3dKTVN5dTRG?=
 =?utf-8?B?aFNkZTN6K2NrcDJncG91S0lYemN6VGRMeXVJN3ZZYnQzL0JtNUd4T0tTVkpj?=
 =?utf-8?B?OW9CSWluMUFKUm1OZFhTdDFjSGM0dHUzcWl6VlIwK3VGbW05OGkxNmxhaVd3?=
 =?utf-8?B?b3Yxb01FR1Z4azd2ckJaQUhNYlM3UzZIaVJCYWx4R2trNGVmcWdUaTl3M3h1?=
 =?utf-8?B?Y3lpUGx6SkE4ck5KZG9BV1YwK0RwcThPc1g4WHU2Qk5RNmo4UXlSdjlnaTl2?=
 =?utf-8?B?T2hoQVl3MnNSTExRRjJOWUtJbU1QVUJTZ0xPb3gwT0d4bzNWWWFqamZhWGVY?=
 =?utf-8?B?Yi9EM1kxRXVRMWd3NTFYN1hpRTV2N0NFL25jdTFxMW1uUi96TTg5YklTak5l?=
 =?utf-8?B?OXdKa0tib2lYdXdobll0dWVOcjBjWUVhRzRYbmVtTSs4OXhkak1jckFhOEVE?=
 =?utf-8?B?UXQrVnJhS0Q0a0JLSmFQem9FNjBmY2JFVlIxdkNpRDJYWFdoWFZlbEg3RzE4?=
 =?utf-8?B?YTF6TWlHZWViaTRYZ2h5WjlDYTBNT2hhT3B6THllT2c3YVBuRWQ3dWpFWk1u?=
 =?utf-8?B?SmZRUUYvNkprQ1lrNEUxRDBGWTVteCtjS0R0ZGFzdVhxcGhkamk4TXFZYzJU?=
 =?utf-8?B?ZS9HT21JZU9tbkJtTEdnY21IVEtkbksyRXFsSmZiZlZESU9nTGk0Q1RFWXcy?=
 =?utf-8?B?bkVxVWhES2poK1F6YS9mTzVrMnBJKzNqcEsrNW5hQy9ZNGRrQ3RMRjRsK2s3?=
 =?utf-8?B?TGVvYS9qZUhrN2FqVU1sNDBldTlZcHRPUmxjeFJIUTVHSTJtQW5VMWJPL2Iw?=
 =?utf-8?B?bnhPeEc2KzRRcGhlMldpazNGaGhwUlBObjZ2a202K0QwWDVpOWZLUFNnZHg0?=
 =?utf-8?B?Ymc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 08d173d7-fd19-4e20-edad-08dc956f3ec1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2024 23:33:40.7685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O58pyY6k+mOek5xGA4dyz6ot9/hsJWjxX0SN/OEI2ZZb3WltDZ0vMrm9boOuo7dlTtYQfSykHmU1rtZW+1+N/IF8LHLLQoLwYUtgjyAM3wM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7170
X-OriginatorOrg: intel.com

Hi Tony,

On 6/21/24 3:38 PM, Tony Luck wrote:
> mon_event_read() fills out most fields of the struct rmid_read that is
> passed via an smp_call*() function to a CPU that is part of the correct
> domain to read the monitor counters.
> 
> With Sub-NUMA Cluster (SNC) mode there are now two cases to handle:
> 
> 1) Reading a file that returns a value for a single domain.
>     + Choose the CPU to execute from the domain cpu_mask
> 
> 2) Reading a file that must sum across domains sharing an L3 cache
>     instance.
>     + Indicate to called code that a sum is needed by passing a NULL
>       rdt_mon_domain pointer.
>     + Choose the CPU from the L3 shared_cpu_map.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/internal.h    |  2 +-
>   arch/x86/kernel/cpu/resctrl/ctrlmondata.c | 40 ++++++++++++++++++-----
>   arch/x86/kernel/cpu/resctrl/monitor.c     |  1 +
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c    |  2 +-
>   4 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index f66c7f12e91e..e5013c8dac84 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -632,7 +632,7 @@ void mon_event_count(void *info);
>   int rdtgroup_mondata_show(struct seq_file *m, void *arg);
>   void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> -		    int evtid, int first);
> +		    cpumask_t *cpumask, int evtid, int first);
>   void mbm_setup_overflow_handler(struct rdt_mon_domain *dom,
>   				unsigned long delay_ms,
>   				int exclude_cpu);
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index 3b9383612c35..7da2992e2c45 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -515,7 +515,7 @@ static int smp_mon_event_count(void *arg)
>   
>   void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		    struct rdt_mon_domain *d, struct rdtgroup *rdtgrp,
> -		    int evtid, int first)
> +		    cpumask_t *cpumask, int evtid, int first)
>   {
>   	int cpu;
>   
> @@ -537,7 +537,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   		return;
>   	}
>   
> -	cpu = cpumask_any_housekeeping(&d->hdr.cpu_mask, RESCTRL_PICK_ANY_CPU);
> +	cpu = cpumask_any_housekeeping(cpumask, RESCTRL_PICK_ANY_CPU);
>   
>   	/*
>   	 * cpumask_any_housekeeping() prefers housekeeping CPUs, but
> @@ -546,7 +546,7 @@ void mon_event_read(struct rmid_read *rr, struct rdt_resource *r,
>   	 * counters on some platforms if its called in IRQ context.
>   	 */
>   	if (tick_nohz_full_cpu(cpu))
> -		smp_call_function_any(&d->hdr.cpu_mask, mon_event_count, rr, 1);
> +		smp_call_function_any(cpumask, mon_event_count, rr, 1);
>   	else
>   		smp_call_on_cpu(cpu, smp_mon_event_count, rr, false);
>   
> @@ -575,16 +575,40 @@ int rdtgroup_mondata_show(struct seq_file *m, void *arg)
>   	resid = md.u.rid;
>   	domid = md.u.domid;
>   	evtid = md.u.evtid;
> -
>   	r = &rdt_resources_all[resid].r_resctrl;
> -	hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> -	if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +
> +	if (md.u.sum) {
> +		/*
> +		 * This file requires summing across all SNC domains that share

nit: this is resctrl fs code so "all SNC domains" -> "all domains"?

> +		 * the L3 cache id that was provided in the "domid" field of the
> +		 * mon_data_bits union. Search all domains in the resource for
> +		 * one that matches this cache id.
> +		 */
> +		list_for_each_entry(d, &r->mon_domains, hdr.list) {
> +			if (d->ci->id == domid) {
> +				rr.ci = d->ci;
> +				mon_event_read(&rr, r, NULL, rdtgrp,
> +					       &d->ci->shared_cpu_map, evtid, false);
> +				goto checkresult;
> +			}
> +		}
>   		ret = -ENOENT;
>   		goto out;
> +	} else {
> +		/*
> +		 * This file provides data from a single domain. Search
> +		 * the resource to find the domain with "domid".
> +		 */
> +		hdr = rdt_find_domain(&r->mon_domains, domid, NULL);
> +		if (!hdr || WARN_ON_ONCE(hdr->type != RESCTRL_MON_DOMAIN)) {
> +			ret = -ENOENT;
> +			goto out;
> +		}
> +		d = container_of(hdr, struct rdt_mon_domain, hdr);
> +		mon_event_read(&rr, r, d, rdtgrp, &d->hdr.cpu_mask, evtid, false);
>   	}
> -	d = container_of(hdr, struct rdt_mon_domain, hdr);
>   
> -	mon_event_read(&rr, r, d, rdtgrp, evtid, false);
> +checkresult:
>   
>   	if (rr.err == -EIO)
>   		seq_puts(m, "Error\n");
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index ff4e74594a19..877d898e8fd0 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -785,6 +785,7 @@ static void mbm_update(struct rdt_resource *r, struct rdt_mon_domain *d,
>   	rr.first = false;
>   	rr.r = r;
>   	rr.d = d;
> +	rr.ci = NULL;

This keeps using a struct rmid_read with random data from stack and initialize members based on
knowledge about how the called functions use this struct. Could you please add initialization to
all these places that use struct rmid_read with whatever is on the stack? This includes
mon_add_all_files() introduced in this series.
Something like below should do (in mon_add_all_files() - done as part of patch 10, mbm_update(),
and mon_add_all_files():
	struct rmid_read rr = {0};
    
>   	/*
>   	 * This is protected from concurrent reads from user
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index 14482d88b68c..5b980cb05c5f 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -3072,7 +3072,7 @@ static int mon_add_all_files(struct kernfs_node *kn, struct rdt_mon_domain *d,
>   			return ret;
>   
>   		if (!do_sum && is_mbm_event(mevt->evtid))
> -			mon_event_read(&rr, r, d, prgrp, mevt->evtid, true);
> +			mon_event_read(&rr, r, d, prgrp, &d->hdr.cpu_mask, mevt->evtid, true);
>   	}
>   
>   	return 0;

Reinette
