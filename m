Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A59C2DEA6B
	for <patches@lists.linux.dev>; Thu, 14 May 2026 21:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778795125; cv=fail; b=K+Q2ApPj8TtXYn5Vk+x9mTmLJ9NiGKXs5GG2d0X10iHrHZz0dHvz3cIqKvAdZI280vL195zuV370q/+28CQ9+5L9+6CeE0CTU+j/XpD/bkVmae58SfQYa2v93NuuxpeJ7A/uitmWeWiR9k+pYP1cUS2i3QaVogRg0hlyAX0pHoo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778795125; c=relaxed/simple;
	bh=llr/SOuXimd1/7jSc/XaHhEo0ILBrphuXOhtHuAwJgI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e0imbrACUtXe8k6wiAdRGSCinXqOIiq0TxB2rVkx2esFJXAiXnGZOuC76MnMJMZh5I4MCS8kG9J1f5cIcc5VXT7Cc20p5qsnqo7T578gOT+td7w2ijr/t4AxN62igzqfyXuskphtRRdTLrCMkLi048K2dpTPjTlnMmo7EK65EuA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IvTxoW9I; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IvTxoW9I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778795124; x=1810331124;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=llr/SOuXimd1/7jSc/XaHhEo0ILBrphuXOhtHuAwJgI=;
  b=IvTxoW9IYANkwNcMnHMspLemw0HwFqvOc03abceFND1gcDO2Ebl/p38T
   ba30IScFCcjBibFmnaGTt6hTjUeHbnZ/T/umdEbe1/VKjZeMncgGULUBO
   SBhtrjx0wt35CkDzo6sH8sLnbSPflloA543G61Ws2aVXdnaL3Px98pm/d
   QxA5jkT/PZ+lJUpcRxH4etdrgjbEWamfNZlIpGdtOL4utweT98g0aHIqX
   iJVcrc8faZbvAK0J+bII6Sm4so2ZgT8fhhRMw0pfvfi1drkoLw/pr1hz9
   VIHV12ovxhDWykuKOAObRy9HaslCET1rvlgFLGvcsSVxholRsQXEj0dIH
   A==;
X-CSE-ConnectionGUID: 2X31Lz8gT7CD460GvaoGDg==
X-CSE-MsgGUID: OdmHYgs9R1mFFTpk3yGBag==
X-IronPort-AV: E=McAfee;i="6800,10657,11786"; a="97176871"
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="97176871"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 14:45:18 -0700
X-CSE-ConnectionGUID: /3k7M6PdRWqJ3EYVILFINw==
X-CSE-MsgGUID: gg+udLNmScidvM7j/S+vvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,235,1770624000"; 
   d="scan'208";a="243487253"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 14:45:17 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 14:45:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 14:45:16 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.31) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 14:45:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L917lct8cGrDo3HwsYjv+bd+FRyQuMcFKh0CIOoCrHZPGbSlR9YYEAsNoDzIyqKpO+2bc3v5+ETHwTYmnwzsjK01kUkvAScZ/xgvnciWMpYHLmgoJAh8hJiw5N+gfYtDR08t9khFnGcoFN7S13bEo/9yqH29+ggizVFy04JHd7CoGchZ5or0XsMqXa+bhxJv7bJKF1/J6io/sLHqOnNFelpyOKfvrm6/ZE7rJJK4teZ9xpsgaO5DJ8J7ec0meuJyYOcgQxTgJMxS0tE9fOFyhrn5O6GfRElYM7V4Hx711FK6RR3nVHFrU62lmCZLbAXqsxe2Q/8wCjFNbWDvCXkINw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nerp4fINUYgi0FFaN7JDHaG3+nC8GHQF6pIIBIjY2sI=;
 b=BFKbJE8Wu2Q2SR4NHT3nA3T38YECTt9FAXy/oTatZQztG0GCOUd6V9AOBS1RM8ELMq1Rd95Jbz75n14kZ8Z0sAeqdSSU6DNbKBGYFjY7/2VtnTGe2Yarn8h8+bScMeapul4eZvQoI34uR5EUfwb+qBdSYYXyJsSfE6NjwIIh5ryIRNmzRc2fNNmGdm6b9uoG2aZI0kH1IuHlLogi57FNsXzklLuyHZbVnZU0bTWe2y0orX5lQ7Pt8noo4xgbmxeAuYiyaEsQdlkNjNFtFiE5/UYSzKYb3JNCBGV5JNhZm5GmMHtn8sKoINzOGo0Ipc4IF1AZiu40vGEacjggNSfBOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by CO1PR11MB5027.namprd11.prod.outlook.com (2603:10b6:303:9d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9913.11; Thu, 14 May
 2026 21:45:13 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.20.9891.021; Thu, 14 May 2026
 21:45:13 +0000
Message-ID: <28f663b7-de8c-4d10-b750-edd8ab9bceb7@intel.com>
Date: Thu, 14 May 2026 14:45:10 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] fs/resctrl: Fix use-after-free during unmount
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260513224044.17167-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260513224044.17167-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0156.namprd04.prod.outlook.com
 (2603:10b6:303:85::11) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|CO1PR11MB5027:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b4e238a-a38b-47f3-0539-08deb202143f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|56012099003|22082099003|18002099003|11063799003|3023799003;
X-Microsoft-Antispam-Message-Info: C0xHRzD2iEusC3lwL4Nq+QKnAZrap7mUZ81q3KohRR2i8Xtw7H0OiSt58oHdbt5fGPYsVPUD3DAjRAZK8wSnsSGUXSZx4BhUA54c3D3L+Zqwsl5ONI+82SK32dvF6Mh+EEwgRf4nk8HsMVhd/Ya0FVROvvpHgIVLS4CXlf9FvE9hQyDm07XiJKmxAaA+LZmDNIxDIYhp7+sVcQ54HUPcbODBkOE3jcoHrExVU6UqgGV1CayGArxKATvZTIsZpfu8D8Kex7zeE9XSV34D2Ix0WbucOm/phv5OUJY0UuPKMkI4etTPY/hvrK11WrYSVPe1fehIBUOtZ6FlPwldlsb5HxfzkC0aVZsUsEZE2QYAKOghAr3e6gr5GV8TqOni8s1ysSIZujxvbKtQYfSOq3K/rWEkb52bjfe9sJxh56LvWX2L/F6H7khSQPuEr+4woj1uT3x7ysjIabAY8HCX1DXHMPkyvJ17eATi4R0DHFICo4znOqRyRyIdrZPPAfiCsOKpGi/EvYkL2SegQ2iHNwOnwP3dJu9D8S74DBV0IFKTlO3KVqx+g6nY1mAXKwTQbuR67TfPOFYRCx/yrMzB6iNKhPoNwzDy73piUO+VEwu+SHy2pxYgxtZqdkHrMh3YwRjaJzRUnLIKOuUfcCnpf0Vjhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(56012099003)(22082099003)(18002099003)(11063799003)(3023799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TUdvL0FrVUhSRkhWV0VDdlg1VEJuRDB6TkduQ2RMVWpKYXlXK2UvOXdHVkQ1?=
 =?utf-8?B?QUJ1U3BmcUdsTG5SR2ZxZm5qbjVTTFBlYVlMTE9rNElJTS9wTXN4aTRMSzdV?=
 =?utf-8?B?aW4rd2plRXpxZUV3Z0ZXdUl6a1k1cmZFcm1XeVcvQkVEaWZ1eFh2WXpsdzEz?=
 =?utf-8?B?TE01WXBDc3l6ckd3UEsxZ2RYQ2ZoT3B3dEFMb2NJV25WV0RUeVdiSnl4aHpj?=
 =?utf-8?B?V1hMYlBrMlJqMS9pbGZRSHVMVUE3bXlJVzJYNmNHVmppZm1XTmJibkpzdTVy?=
 =?utf-8?B?TStMTlN4S0UwRCsxY015M2s4N1BoYUdVUFdqT2NoelV0Z2lKdmlLUFZMR3ZO?=
 =?utf-8?B?dmlVZC9KT0RnRVFYSVpEOVZsaWRON0R6UmJUYi9oUmxjSUhMRG5QR3pVL0lK?=
 =?utf-8?B?dk9mWXpRU25CcldIS3o3d0tzU096eDhUR2VBWVNITUJDRzJkTWFzb2x1bnB2?=
 =?utf-8?B?S0Q3OEZEcVpRS0E3LzlrcWlhZWc5aDFBaVBWREVUYnpYa2x6N1JLMVV6VDRF?=
 =?utf-8?B?ZDVlZVpvdS9qbFZUbFA2djRVREhIT2JIT1RwLy9EQ1V0N01YQVRibEhGaVBB?=
 =?utf-8?B?V1cyL1JJWnVsYUN0NnB6VExEb2lQb29TbkNrR0JJYkl1VUFObkw4MXRUdU95?=
 =?utf-8?B?RXNDZXpMUmlsb3g3YmQ0TkppU2xMbzRmT2xtRnRPV3czaVRPZFhCaUFaOXlq?=
 =?utf-8?B?aWpITjRXYTdWcks1ZTJZOXQvMTI3QllVQzNkKzlwL29SeENwYzgwSSttR1JZ?=
 =?utf-8?B?QkpJNDlTNWNpVHpBKzhkR242Y2pWUkJhRTRETnNvbFpFQzRxOFBpTlEyNTlD?=
 =?utf-8?B?Nng5a1BMTE8vUmFJSnJkaHRrYkRIUUJ6VEVwdmR1UVRpUWt3Q3g3YXN6Z2hT?=
 =?utf-8?B?OUxadmhnVU5aL3Q2RmMvNUt4eTUzOXExTkt2WlRuVlJ3OWFsQjVMcTVLS2Nn?=
 =?utf-8?B?QWVXSjAxMVBkY2txT2ZRdTJ4UVgyY01Rd04wNDJvUW9TN0JHcFFRRzZLK1Nr?=
 =?utf-8?B?cTB4bmc2M0h1WWdUWGpMTE5BaUtyUkxob3ZWdFk5bGFuQ3VYQ3EyZUNjQWtW?=
 =?utf-8?B?SGY0ci9mcDdCa1loUHVYSXg0dkg0T21XM3psOGhlRnVGbnRNTEdBRUd0akUw?=
 =?utf-8?B?YXRBSjk1Wm9vTmY1RXEwelVRS2JBQ240Q3RZM0VidTVaNFZGUjdYcW1EUjQw?=
 =?utf-8?B?dHFzODhyVHN5MHBENFZqTDliNURqWXRXK3hURjJaOWxCb09JT1pvV3E2Y1Zo?=
 =?utf-8?B?cU5PRk9qSVZveWxYdCtaS2hibnp5RGJORkJ5Q0Rnc0dhSFYzSXVHWGdXc095?=
 =?utf-8?B?YmFGRGtzeFNEcWdnbjB2aWZIbkJaOGZNVHh6VnJER2Y0YVVtZFZnVlNicXl1?=
 =?utf-8?B?ckFHUzNDU1oyZDQrVmFwZzhQeFJQeHhRazFjZXI3dGg3VkRBczhBdVFUTTRS?=
 =?utf-8?B?NW1NVkFGOG9SUVZISllTQ3E5TlZ4cmwyalJsVFNBQlpJZEpBaTBIYWIwa29B?=
 =?utf-8?B?YnBxQUtjTlgwa3NSVkNTalZ4WGVYWUkzd2JFcTBSU1ZIZmYwYUVLbiszQnhy?=
 =?utf-8?B?QWlIZlZacU96VWtvTkZpTGc2b29DcjNBQWhmZE0xUWswV3YycEwva0RTTG5C?=
 =?utf-8?B?NUZTYlpqK2FLaG9EOFJhSExIQnRsVWZvMEVwdERFNFZjOFNSZlo2U0dpZHM4?=
 =?utf-8?B?RDFIWWxjeVUxY2E1aW1RZHNmNk9mUTJ5K000RVJVWk9aRFpBTVQwb0txV2Za?=
 =?utf-8?B?MnpqcjltYWY2aEMyNldKb21YTW9ucVgwc0MzNVg3bEtIcjEzUVlYN3haUHds?=
 =?utf-8?B?TG5KdGhEcTMvWGdTR2hXdzZ3Wm5yQ1Y4MnFQZU5MdXhEQkk5bWVBME9SL2Rm?=
 =?utf-8?B?LzI2TnlxcFBzUXZweTZReTN0VDI1UUNpWE9WRjNGYnI4ZTdZdTRsdnFuTUtw?=
 =?utf-8?B?UzFCdzIrZkNCNEE2eDRFNkl2SjVlMzBhRTZpMjJyUm5aY2dUOGtnbTcySWVB?=
 =?utf-8?B?cHIreWdENjQyYTFLZEJ0L2k5T01MeWZ1M0ZRak1oWWx5bllXTS9JZkcyL0xL?=
 =?utf-8?B?T0hFeGRlR0NiTW50UHNMcW5qdjR3ZWp0QURFNlJPMlVRdXRTdDJsQk1sTmtL?=
 =?utf-8?B?TXFDQWZqNlhJbXVPZmo3TzJISlB1QStpOXJVcTIycTFMSGMydWxGSHJjYitz?=
 =?utf-8?B?ZnNObTltRkR4aVVBeUFYTjRNYUNkRXBDT0ViNjJveFd1K1ZRMjZsMTd2VGoy?=
 =?utf-8?B?SklxNGRPd0hMcG4vSklodjl5NjhEVWV3b2d5T0x1VFVyZHBRWTVMMmw1QnZW?=
 =?utf-8?B?UFZyb255VGJtc1NyaWxtS0NPUW9VUSs1WWNxWjFSTDB2N1MzalA5U2I1Smx6?=
 =?utf-8?Q?eCm8XpCL3xciL4rE=3D?=
X-Exchange-RoutingPolicyChecked: dTFZmhfJEdFId8x6cbfyRqw8BBABtwASdMHj5fhf0e6JdQddeDypSQI4x5mdgFHSOinB14vQisbq/GTi46Z6JCWT7PzzHjObICm2bfbqZmn4sQLkpFlbBcKpdZBUt83a9o4Z/5gmEtAGpmwBw6+/AEINt7EH/9RNQ0+o5CYlPsxAKe7rjMcaPa+cLxoDN+EqRpO/IWupM+BlenBm82RrjW4bgzwxmR2qToZMtqU7vT/0NTwWG5Gqf4XiZvkGdMV1dkIdtH5+4LjIpFtF0Rr3Cci3d5AYOpRtKEFQU0Os6i4DF3HDZNasW4yLFZfLAjE+Wg7a4ANBYmVe6QhXefvF3A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4e238a-a38b-47f3-0539-08deb202143f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 21:45:13.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WHwnqMqp7ypsQ6LzS0pxRyve9AyKr2zYB0rx9tIffk2uqIOZfKVyWW86oilWFw593LGN9mHtb+nHiF/T6hnU7vd14bGz7MPhpIyzMcJoi+k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5027
X-OriginatorOrg: intel.com

Hi Tony,

On 5/13/26 3:40 PM, Tony Luck wrote:
> Sashiko reported[1] this issue:
> 
>   During unmount or failure teardown, resctrl_fs_teardown() calls
>   mon_put_kn_priv() (which frees all mon_data structures) followed
>   by rdtgroup_destroy_root() (which destroys kernfs nodes). However, the
>   RDT_DELETED flag is never set for rdtgroup_default.
> 
>   If a concurrent reader (e.g., rdtgroup_mondata_show()) invokes
>   rdtgroup_kn_lock_live(), it drops kernfs active protection and blocks on
>   rdtgroup_mutex. resctrl_fs_teardown() (holding the mutex) proceeds to free
>   the private data and destroy the nodes without waiting for the reader.
> 
>   When the mutex is released, the reader wakes up, observes that RDT_DELETED is
>   not set for the default group, and dereferences the already-freed of->kn->priv
>   pointer.
> 
> Set RDT_DELETED for the default group (if there are any tasks waiting).
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> Link: https://sashiko.dev/#/patchset/20260508182143.14592-1-tony.luck%40intel.com?part=2 [1]
> ---
> 
> Yet another side-quest from Sashiko. RFC for some human eyes before I
> add to my series and post a new version;

sashiko also reviewed it and found a few issues that seem legitimate:
https://sashiko.dev/#/patchset/20260513224044.17167-1-tony.luck%40intel.com

> 
> 1) Is this real? It looks like it is to me.

Looks like it to me also.

> 2) Is my fix reasonable?
> 3) Better way to fix it?
> 
>  fs/resctrl/rdtgroup.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index eac7e4f8574d..668ebe0b0ec6 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -594,7 +594,8 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
>  static void rdtgroup_remove(struct rdtgroup *rdtgrp)
>  {
>  	kernfs_put(rdtgrp->kn);
> -	kfree(rdtgrp);
> +	if (rdtgrp != &rdtgroup_default)
> +		kfree(rdtgrp);

Issue described by sashiko with new kernfs_put() is real here. rdtgroup_remove()
was not called on default group before this change and it assumes that there is
an additional reference that it can release here. See comment above the
kernfs_get() found in mkdir_rdt_prepare, copied here for convenience:

	/*                                                                      
	 * kernfs_remove() will drop the reference count on "kn" which          
	 * will free it. But we still need it to stick around for the           
	 * rdtgroup_kn_unlock(kn) call. Take one extra reference here,          
	 * which will be dropped by kernfs_put() in rdtgroup_remove().          
	 */                                               

We could aim to balance the references with a kernfs_get() during rdtgroup_setup_root()
but then we need to take care to ensure rdtgroup_remove() is called on exit for
the default group which may be confusing since it is not actually removed. How about
instead just don't drop the reference that we do not have? What do you think of below?

	/* If doing below the function comments need to be updated */
	static void rdtgroup_remove(struct rdtgroup *rdtgrp)                            
	{                                                                               
		if (rdtgrp == &rdtgroup_default)                                        
			return;                                                         
		kernfs_put(rdtgrp->kn);                                                 
		kfree(rdtgrp);                                                          
	}                            

When considering the races with a concurrent mount mentioned by sashiko I wonder
if resctrl should not also use waiters on default group to gate any new mounts.
I was tempted to place such check in rdtgroup_setup_root() but it seems to bury
something gating the mount so perhaps better at beginning of rdt_get_tree()?

What do you think of something like below?

	rdt_get_tree()
	{
		...
		if (resctrl_mounted) {
			ret = -EBUSY;
			goto out;
		}
	
		if (atomic_read(&rdtgroup_default.waitcount) != 0) {
			ret = -EBUSY;
			goto out;
		}
		...
	}

Another alternative to consider is to not call mon_put_kn_priv() on unmount but
instead on resctrl_exit()? Thus treating it similar to the RMID LRU list.
This may be more complicated in the long term since it needs more care to ensure
needed state is still available a resctrl file reader that was blocked because of
unmount or failure (via resctrl_exit()).

>  }
>  
>  static void _update_task_closid_rmid(void *task)
> @@ -2965,6 +2966,8 @@ static void resctrl_fs_teardown(void)
>  	mon_put_kn_priv();
>  	rdt_pseudo_lock_release();
>  	rdtgroup_default.mode = RDT_MODE_SHAREABLE;
> +	if (atomic_read(&rdtgroup_default.waitcount) != 0)
> +		rdtgroup_default.flags = RDT_DELETED;

sashiko found a race here ... looks like setting RDT_DELETED unconditionally would
help.

>  	closid_exit();
>  	schemata_list_destroy();
>  	rdtgroup_destroy_root();
> @@ -4291,6 +4294,7 @@ static int rdtgroup_setup_root(struct rdt_fs_context *ctx)
>  
>  	ctx->kfc.root = rdt_root;
>  	rdtgroup_default.kn = kernfs_root_to_node(rdt_root);
> +	rdtgroup_default.flags = 0;
>  
>  	return 0;
>  }

The "permanent lock leak" issue reported by sashiko is not clear to me. It claims:
	
---8<---
	In rdtgroup_mondata_show(), if rdtgroup_kn_lock_live() returns NULL, the
	error path jumps to the out label:
	    out:
	        if (rdtgrp)
	            rdtgroup_kn_unlock(of->kn);
	Because rdtgrp is NULL, the unlock is skipped, leaving the locks permanently
	held.
---8<---

Comparing the claim to actual code the snippet looks like a mismatch since
rdtgroup_mondata_show() actually looks like:
	out:
		rdtgroup_kn_unlock(of->kn);

Reinette
