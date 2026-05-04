Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89F953B28D
	for <patches@lists.linux.dev>; Mon,  4 May 2026 15:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777907521; cv=fail; b=ghCc0nflZbt3snPwzOnWxTgV6xERK+kAOwKYMXYnLbWM62ksz1f7V4eohfpufXBUy3F5hogSWfq5NsdceiMV75Rbt3rm3IcpUQFgYHaa+A+IRw9NzIl0Hzjh04m7jAO7CWzlIGN2QPM7dOpAgmIz1Xmc+JNoVC9rW5jMUUAzF7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777907521; c=relaxed/simple;
	bh=hl8Uw9rP5xine7H+hFcq82veYxbexcZUQ7A46ffThLw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=goESpzWFc7XtWe8Bdo6B0blLxcoVv3Zaibyv+aliASp7ykEXh1gSDL8vtC2SD2NDhwLlVBkNZMGwfFYK8r5HLJj68VaAV9DNuOSdDh+CzYCRZGTsBPY2V+stBl1ANwElWGL+A8svFBmGI0vFtYpW/8yhhyvcMpLqIZSN3WEWYmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRHQi8xN; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRHQi8xN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777907520; x=1809443520;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hl8Uw9rP5xine7H+hFcq82veYxbexcZUQ7A46ffThLw=;
  b=GRHQi8xNgPhEQ3/feSNTxcFf0gj0S88dYJ4fU6VYBanU/FwO9hkJ8L8l
   JLaYOe834Z+AkJKt7K4GP2U3gHMCoNz/j6Svxg6yzESG4InSg8+dvsBAS
   nzgUj01O5oAAsp1xHeMcGrMpnz/fHV0+EowapqXTcpQOiQhVqwpzt+V+t
   9NhTtOLPnLHv839msuWxFRO7Mc9CcelVwykYSBLMK0NiEFqKOMR1cXOe3
   lJtk9sCZWKSkE1QGEMONcRqDjtJn0Q/6/oWai7YOMEYXo4kNjB2YdTlhT
   57x58yhqZ33jkVUo2LSAqt1+o5o9JGXejxFN5Lt0eqR/+qTrCwv6Qj9GM
   g==;
X-CSE-ConnectionGUID: wFhC9j10RVSLjmEj7vhq8Q==
X-CSE-MsgGUID: dkVWumWcQTujOCaY65GSVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11776"; a="77923611"
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="77923611"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 08:11:59 -0700
X-CSE-ConnectionGUID: l38pkz1kQ4yNjOYfpxVR/g==
X-CSE-MsgGUID: qgmTPf2ARG268XXKWPyjUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,215,1770624000"; 
   d="scan'208";a="234676071"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 May 2026 08:11:59 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 08:11:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 4 May 2026 08:11:58 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.53) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 4 May 2026 08:11:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YCGKV8BBc+OWaHnTqvaBV/w0IacorDq4O8s6K3+2DNRkpm5fBx1XLmkuRZ9JELJYIqS9c/pReNxbSa9LY7R92/QOkhwXOgeiL3r8sgq/O/RFeEL8DcrP0fzcKE/y0lI9WHOxNoc+CC53/yMpFj6KIzL2AOajnMZfxVJSHQfjLVMMeUsxf5rxpVzgfXvNYRIys+/8WixeaT/ioQPlbJNUcZD37CNDpfkF1wPFWN0ZHRsmn7gv06Z1NF0Ws/BA+V87rFrnGe7OgZbc25/T7Jf7B79ozQ19v6qhmmiq1zh97UOV9+V9/7PZ9kMMJKcxGT9b72HVHCDTwYgu7/4+TOkfdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76HV5F2LlDgYtejgY6iHtkTwrFPtlTglMnHbBF0M8fs=;
 b=GlkRct2bYeYLIIFqClYRZGOBKXX48sdPdaKXtu96fIf4C2euv+fyjBeQ62/lv6Hu4R4uWI755vWoHjuwbH+u5RfRxowzQFktqQPWQOpfrJEFcAJdBzWIZmgaWsZg0oLh2lpxXzryN9t9hu3Khn1GFSPLUJkRVmjfnV0Nc1tQ2+eT0cDoA2K+seLcKwp6s79ZRbW/pv5dYZIRpMmVEPtMAPHuhr3GupqfAVG9kfECEIxwR6Ze2fN42Ybp1/YTb4+mC7GhrejURbn7x5RBhZ7qrrFstBC9AtLf5RxkTH4wyMl/xULF+/Vv/hr+UUvRk2CpvQ7KCiC+EX8133RI0uG0bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SAWPR11MB9733.namprd11.prod.outlook.com (2603:10b6:806:4ca::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.25; Mon, 4 May
 2026 15:11:51 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9870.023; Mon, 4 May 2026
 15:11:51 +0000
Message-ID: <2236fae5-7e66-43fb-ba05-76fd4434e2c9@intel.com>
Date: Mon, 4 May 2026 08:11:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/resctrl: Fix use-after-free in
 resctrl_offline_mon_domain()
To: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
	<x86@kernel.org>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260501213611.25600-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260501213611.25600-1-tony.luck@intel.com>
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
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SAWPR11MB9733:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bf221a6-018a-478b-4c73-08dea9ef77ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: 2Krzsvp12d5NnfGQB+rXiHaNvlDoD3/LUyURCm5PjvYVpLvwA94F8nY4ih2nFtU85IqOuDRolmfRt8PuMnXAd/Jw9/8221nlFcFWaMW+3CPJUXomlio9FARrA5aKs1MguqHX5P+GGHZU4+WIWEnhPBeNzPqkecqOH8uYjAl38VQe/6mRzB8yCA4IbqeAJirTH+t2PLRfbjgsVHceJ3chd8+bKZq6vqTMcX4X4e+3QwzjBsgBqAnTp9TMkKJjtW9fYuFosLxW2nJ6NoIpXkPQ70WJtCyhdykdzvqKoKNwSUi8MFDs5CtXyzA37JulmX1T/2HmiABxZKVTOTWAVmQ3rggyaE+wQ+dqkwQy7qvby2145DU9k6V7+ELxfpzVk57akkjfMfmvtCK1QgpJPvs8sOFSWdh2cQyLhO5ALjxikONCdBgc5H8NF7U5VVhzko9rqKjQ9CtiIpGwv3LF8f+3Zlq9+mIn2QGTN5V4QTbMFZ6etO+pgPcCwStD4CNmPkspD0wOR7Ltf9qjasNaJN99lzqDZE80NZvz5Y50YBDV67a55oH10QSH5uHxSXfvS/Iibrw1ynyPmUXrDo+GaXIPsfxWRUZbP56flKxa+YyY4DACKL0BagC4X6zIWblbvtNIWx3gCMquujWtzOwRIBJXiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NHNEWWFvdlRNU2JyQ0Q3VE00ejhIQlVtR3p4VXFTUURwc0wyQ01vUFVNWmhR?=
 =?utf-8?B?bjFIalBsdVFDWjk5djFQc0ROOVlHa0EvUXpVWi9YTVUwbVBXN0Z3enlra3Vu?=
 =?utf-8?B?Zm0xRGhzc3RwMEswejBUVmZNSit3NHdOOC84OVFxZlNRUGoyUDRCcWtsWWlO?=
 =?utf-8?B?VFdpZWIrZzJqeGFpUzZkY0dPL2UzQUFRYTl1WFZCTDkzcUVnWUp1NGtueTJy?=
 =?utf-8?B?VUVDNWxxSWFlb0hSY2poSldHQXZCMmF1TTJlS0s1TmxEMTBNNXVVaGZ4VnVy?=
 =?utf-8?B?V2tXSGRCeFczcmlLWGhrVURWR2dXV0dTRml6UXc0d2RpOE1IL0RhZmM4VGZK?=
 =?utf-8?B?ZUxweVZ1YllldDRkbjhYMHM1QTZ4T2c0NHBqR2k4NzlHbEk3dTltcTlQOXh3?=
 =?utf-8?B?Y0VpdFY0b1hOS2M4VFAyd0hMYU0yUENtczh0bVJ5NXRWWDFNNm0wZXM2V3Yy?=
 =?utf-8?B?dHd2ZkJla2J4WVpWLzlTdVhUd21GblVsM2RNb1dEN2lUV0xNM0hVZ21LeEJy?=
 =?utf-8?B?SVdNdnM4dS9FVWNjR21UQkpBR2NoTEcrazZSRDFNeW0rSHhJYUhNYnpTMjhh?=
 =?utf-8?B?V3JOUXJhODdLVENXL1BwQVFKaHpEVTMzelZZaTFBeEhZa2JOTmFvYTg1bi91?=
 =?utf-8?B?Q0N4dERHd1g4MzF3eG9nZUloTU1ISEJyTUt1dWFrRTBRcVV1UGRCWXREQVNw?=
 =?utf-8?B?NDVUakZ5UFFMclpyMjBJQkdnQmhoU3BRZ2E5enZIWVhYVjZtUEJJc3pTcVlZ?=
 =?utf-8?B?K3Y5bnhhUHRlcTNtdkFLRHVYM3o0Y1ZMVVBlZ25OSEh2SWJHYzN0ZGRKQjJQ?=
 =?utf-8?B?dnZFaGZLamZBdVJlZEs0NmdIM2ViVE5TUWpYZ2c0aHVwRWNtVUdGa28wcERu?=
 =?utf-8?B?VmM3N2VTTXBnTksvdlpHOWM0RXFHUTFpZDZhcWh0NHB0Z1gxblJnUnovbS9z?=
 =?utf-8?B?RnpsZnRmTGJ4bXNtcERWckY4eVA1am5meDNQRWg4UmZmb2tMNEJBY3djcjBl?=
 =?utf-8?B?MExvblhZdnRoZnNqNy9uelRGeHowbHhYMEh2cXo5L3JuV1B4bzRCbmJRVThR?=
 =?utf-8?B?RlN1alJQTUtEL1ZROHBZUTJHVEhBWWU0Z2R4SU50NHRxQjhlK3p0cXR2dEdn?=
 =?utf-8?B?RG1RTVFkT3RCY0c3VjJXRUh4MUQwaDd0MUJDOTE3eFJIMUxiVEZZbW1OK2Fl?=
 =?utf-8?B?SHRkaUprK202S1dWQkhZWGt1SXFoV1ZHR1Zzb3RSZTlCQUJrMWlDMG45aEJx?=
 =?utf-8?B?dm02ZjhVVnh2TGdUczlXUU90ZkxZYnZGNE80Mk9TZ1NZWkR5MWNDTWxNRUlx?=
 =?utf-8?B?em83VGdTaVNsTzAvREt0N0NqOTFQOGs4anVPZzNxNStYNlZ0QVEyT2lyYmhu?=
 =?utf-8?B?MlpRUitXTFNTQlBYSjdqRUVLT2poM3hSQ2tOdVg3OTkrdUlCMmlOM1JGZlcz?=
 =?utf-8?B?TjBqdVJSdDVMdEZUSmt2dDBiUTVxc2MvZTNLbGx3cnlrZVJ1RW9mTEFnVitZ?=
 =?utf-8?B?dWVkcTZ2RldtYkNYbDdCbG01eWlaejhJaFdWTzQvRGlncFk5RzdVbzFyajVn?=
 =?utf-8?B?b0JKWERQYVJTRFUrSUlBVEtwT3J6aEVQVlIvVDdEWUc1VkpGNEpNYm5uNG1i?=
 =?utf-8?B?QTVudWR5Sm91WmlmRWpSNWFwbWZLM09ZcXRTWFdGZkYyQUdSTXN0TlV6Tyto?=
 =?utf-8?B?S0pabFBFYVJ3SE9SRWtBWmV2Q0cvUUo5ZWZBL2JhUkQ5NkpTUFNQVkxNb0g5?=
 =?utf-8?B?aVZPZGJHQ1VJeVRwVWJCRGQ1dDA1M0habVVNY2kva0RjWnF3SDB1NXNqdTRR?=
 =?utf-8?B?VmVOSExnVE53MDBMMTh4WHBXS3BHb3N1QlN4L21Kdm1VSVVpVWcxVGRRd0Zr?=
 =?utf-8?B?VHJQZkIrWmc2ZlZnUEFkWTlyU0hETUJibFYybEVjNS9Rb3A4K2RIRm5yVHpq?=
 =?utf-8?B?Wit1M3RjdGpRZHFHb0JucXdUU3d1R0FNOHg4TTBFRGhqZVpwVDlMYUVnTWVq?=
 =?utf-8?B?ZWRBa1l0OEpqeldXTnE4WVAzRXpWYVhoL3RSTXNoRHhncjdLK0RtMUZGZGgx?=
 =?utf-8?B?U25XUm53R1NVY0VKNGFLOExhaXpVOWtpRUZhN2Q3cXhqNWEvVlYzRnVDM1VJ?=
 =?utf-8?B?YUgrUW41RUV3eUpsUHd4MzJ3SC85QW5WWEtVRWI4WCtxOUlaQ0MrVm5mNkFC?=
 =?utf-8?B?MEhLWE4wMXJJZTh2em9BaWhQQmF3MFI3OEdHN1JvVjhNelorQ1IzQzh4L3Bu?=
 =?utf-8?B?MWhuZVg0NHRVZ3ZodjI5U0VodVlMT3hYKy9iNWpQNzB1RTB2KzR1RVBoZGd5?=
 =?utf-8?B?dnFjUTRVNk5odlBEZ0dYc2RyY0NzR0ZjNG8zTFJMeUVGY1g0dlpkNENYdkhh?=
 =?utf-8?Q?gjOaRh/Atr5fwUY4=3D?=
X-Exchange-RoutingPolicyChecked: PypUz+jbQ+i7s+OVHX9PD3jOe646SSSkeiTx79gSXxurVSezRCIjxDXi1WekA5Fs0RYTY0UKt/QoIy1ZXAu+ztRoJUGYwz0XM0WIOivyWrZeU2Ibp/1Sc3nmokTGu1RLOFgcefTgDkZxP0X+/tBtUShCTA1+bdftlqUrc5QIFF1QJ0RPXugk5fIgqyyUc4jFxpqKdd+blxej9fI2m/PY5NXKnY+JsWMVfIcTMlGhg0BXqSvcD1mo7dFzKX4YIs7Eo/uGgvzC2dX65fzJ/TqBjdUCChwiXIOMVJgCOKdhvLO1PED4P2e3zZwpVce9jMg8QPVFDSVQPZUfCe3DLfBxJg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bf221a6-018a-478b-4c73-08dea9ef77ff
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2026 15:11:51.4818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xETtmffl/HChCzLzCUqwsTte9ZUwWvmDeJ7ofd0dcS9xoodeDYgbR/qhBnrPfmGFexeao/sM/ctJaY13xvGHLERpiLN4eH2bSgwfa2+cBCQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SAWPR11MB9733
X-OriginatorOrg: intel.com

Hi Tony,

On 5/1/26 2:36 PM, Tony Luck wrote:
> Sashiko noticed[1] a user-after-free in the resctrl worker thread code.
> 
> resctrl_offline_mon_domain() acquires rdtgroup_mutex and calls
> cancel_delayed_work() (non-synchronous) on the per-domain mbm_over and
> cqm_limbo delayed_work items, then calls domain_destroy_l3_mon_state()
> which frees d->rmid_busy_llc and d->mbm_states[]. After it returns, the
> caller (e.g. domain_remove_cpu_mon() in arch/x86 or the mpam equivalent)
> deletes the domain from its list and frees the domain itself.
> 
> cancel_delayed_work() does not wait for a handler that is already
> running. mbm_handle_overflow() and cqm_handle_limbo() each acquire
> rdtgroup_mutex before touching the domain, so a handler that started
> just before resctrl_offline_mon_domain() runs will block on the mutex.
> When resctrl_offline_mon_domain() drops the mutex, the handler wakes
> up with a stale 'd' obtained via container_of() and dereferences memory
> that has just been freed.
> 
> Drain the handlers with cancel_delayed_work_sync() so no handler can be
> running or pending against the domain when its state is freed:
> 
>   - Add an 'offlining' flag to struct rdt_l3_mon_domain. Under
>     rdtgroup_mutex, resctrl_offline_mon_domain() sets it before
>     dropping the mutex; the handlers test it after acquiring the
>     mutex and exit without rescheduling. This guarantees that
>     cancel_delayed_work_sync() does not race with the handler
>     re-arming itself.
> 
>   - Drop cpus_read_lock() from mbm_handle_overflow() and
>     cqm_handle_limbo(). resctrl_offline_mon_domain() can be invoked
>     from a CPU hotplug callback that holds the hotplug write lock;
>     a handler blocked on cpus_read_lock() in that window would
>     deadlock cancel_delayed_work_sync(). The data the handlers
>     examine is protected by rdtgroup_mutex, and
>     schedule_delayed_work_on() copes with a target CPU that is going
>     offline by migrating the work, so the cpus_read_lock() was not
>     required for correctness.
> 
>   - Restructure resctrl_offline_mon_domain() to: set ->offlining and
>     remove the mondata directories under rdtgroup_mutex; drop the
>     mutex; cancel_delayed_work_sync() both handlers; reacquire the
>     mutex to do the final force __check_limbo() and free the
>     per-domain monitor state. The cancel must run with the mutex
>     released because the handlers acquire it. Cancel both handlers
>     unconditionally on the L3 path (subject to the feature being
>     enabled) rather than gating cqm_limbo on has_busy_rmid(): a
>     handler may already be executing __check_limbo() with no busy
>     RMIDs left, and that invocation must be drained before its 'd'
>     is freed.
> 
> Fixes: 24247aeeabe9 ("x86/intel_rdt/cqm: Improve limbo list processing")
> Assisted-by: Copilot:claude-opus-4.7
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://sashiko.dev/#/patchset/20260429184858.36423-1-tony.luck%40intel.com [1]
> ---
>  include/linux/resctrl.h |  1 +
>  fs/resctrl/monitor.c    | 18 ++++++++++--------
>  fs/resctrl/rdtgroup.c   | 38 ++++++++++++++++++++++++++++++++++----
>  3 files changed, 45 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 006e57fd7ca5..73f2638b96ad 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -203,6 +203,7 @@ struct rdt_l3_mon_domain {
>  	int				mbm_work_cpu;
>  	int				cqm_work_cpu;
>  	struct mbm_cntr_cfg		*cntr_cfg;
> +	bool				offlining;
>  };
>  
>  /**
> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 9fd901c78dc6..e68eec83306e 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -794,11 +794,14 @@ void cqm_handle_limbo(struct work_struct *work)
>  	unsigned long delay = msecs_to_jiffies(CQM_LIMBOCHECK_INTERVAL);
>  	struct rdt_l3_mon_domain *d;
>  
> -	cpus_read_lock();
>  	mutex_lock(&rdtgroup_mutex);
>  
>  	d = container_of(work, struct rdt_l3_mon_domain, cqm_limbo.work);

Since work always runs on a CPU belonging to the domain, could it be simpler to use
get_mon_domain_from_cpu() using the CPU running the work to obtain the domain here
instead of the work contained in the domain struct? 

This seems to more closely match the pattern used in rdtgroup_mondata_show() that
stores the domain ID in its state instead of a pointer to the domain and then uses
resctrl_find_domain() to find domain.

>  
> +	/*  If this domain is being deleted this work no longer needs to run. */
> +	if (d->offlining)
> +		goto out_unlock;
> +


Reinette
