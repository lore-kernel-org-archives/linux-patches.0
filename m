Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1794422146;
	b=b6O3VBD2XLjz8aPcNEsXCJlNtcAPtvDsYnAWOzjh191+PiuvX90SxblxUtT9QAGluPT1
	 tS5BcGYXyEbhszR6TrWjWC9bgmqFy0LcIzsVve+kzm9qyzGZ0F0Vt/pnxKU/Q3o/s16Ky
	 LG9LHgOvrHjQrmFyULtsgzk+5d/bTjTHO4GjH81j1N1RGhNBDjhDyvFrjfnq8O0/Vxdjg
	 SSa2MpTFk7DCh/atwQRZzC5bJs0kqYUNappK30ZekuPFzA9BJrrLsx60pB84FadvmrSAE
	 5/U7n8sMvNdsdh7dxOQtZoh6d3LT3XCLTlBSs00KoqKfjWDwBvuqXHXQEFRqLeSi3tw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794422146;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Message-ID:Date:User-Agent:Subject:To:CC:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-ClientProxiedBy:MIME-Version:
	 X-MS-PublicTrafficType:X-MS-TrafficTypeDiagnostic:
	 X-MS-Office365-Filtering-Correlation-Id:X-MS-Exchange-SenderADCheck:
	 X-MS-Exchange-AntiSpam-Relay:X-Microsoft-Antispam:
	 X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=2JNkCLbRJx+73+IfItwA9JKKr6iKnlECCXVWNVZ/2XI=;
	b=2jLS/pGyjpZUmT3eMoS+F0Z1xrxTLIb77+/G8pvy9mewgdf9agjpm37U3wOjBKUwz1za
	 qac2qFJ/F7lRr0HKU4xlKhgZS3w1VdLddihdXHywmW45E34tzSWkdV4gEUEk2A2ckX9Mc
	 m6umBYhk+GcV0lQ3ampeDQla0X11oJ489+Aj28oP1UPnYT+v1jsOjtgaTxSs3lLESF04j
	 yqH8EN74XDIc1Fh294ga6blC5pq4ctHnWV+T7aox+KsXLdv2mr3CuBItqE3fkCdwDM6ja
	 NBiTdRiz55BwMPSNdC4XAea++DJGZf7XinW+zx9yhI+VQmQTg149JHnaNNfv2R7wXUQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=inSUN3JC;
	arc=fail smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DC0606A321
	for <patches@lists.linux.dev>; Wed, 11 Nov 2026 18:35:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 37DC0606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=inSUN3JC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794422145; x=1825958145;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jxeywpg4AG3A/MfTVVbrb+gSCNcpxE+WZpoRStAuI4M=;
  b=inSUN3JCXyl+bM3+iAVsmcJq1f0IsRZ0VuFkIrU74MxW4gL2cxzBhj7g
   gKkWZ9K9C99CO8cjbZB3gl6VMK1ATCK+1ow2eKCCz0t0Jv63M+bQcB5oZ
   hOKLjpbOTMkR+psUfgs0TfDZQF/ODUDYuqRNt0tv6e0Z77iAe3Pve97ni
   y88+A3POYvv72Bch876ix/Shgd3dAvFwsbTR2vhQZoEIH0GsymOyp9mpy
   dj/QzwkRxs/Tq11moxj3F344p4Y99tNKllf8ZkQqCdb9f1//PCWqynB2+
   TjV5/I6GNbp9HRXul2cx0MAhW8aO1CeuYmQ6YgYRevfSBq6fAP3iFsZng
   A==;
X-CSE-ConnectionGUID: YbMkaqKfROqgoynjP9gjMg==
X-CSE-MsgGUID: K/FVGOMTS+ea0Mr4lG4UqQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11963"; a="3283580"
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="3283580"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 10:35:44 -0800
X-CSE-ConnectionGUID: WzQ5RVd0TAS89V2J4H+3pw==
X-CSE-MsgGUID: CzfxJnuBR4y+BbMMVm0FVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,208,1787036400"; 
   d="scan'208";a="8477645"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 10:35:44 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 10:35:44 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 11 Nov 2026 10:35:44 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 10:35:44 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QqkgZ6dpg2/2Vab2Ep2tbH+f5avDUIByh8jV/UVRL2wKU/ku/D/E1PDIyOR3hpSLtEVqrrMG2Cl1cnsmJ3nbHGOgSbSXof2rsOXyyjoNY93CBu4SVsEX2qIDYuGsnbGxwqCexRMhHaZZaVfg/tAgG9iprlvPjXENG4oAPWXCBw4LQAaVsCuFV+TcZc5X0Tyvc9tfLglbShZoFTD0OWbET+SPqP5m8Phftt+w3U+iXOSPlyrOh4E6phqwF30UnwKyKhH703mSNZgCjXduFDGbeD66Nm6TfwGdrjBYnyWU8E5BEcHsoyN3am10rsLRKow6dVF4Lr5mcAxnArWmhllbGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2JNkCLbRJx+73+IfItwA9JKKr6iKnlECCXVWNVZ/2XI=;
 b=N0X52xHtiDq64x7yI8UESSiNKjOVOgBMYFbM0IdxNxovP1qUuNf5cOO0J5LAa+ObrVbo1+jMgs0g4mOAafchMcbwxtJIzsPawMWINGTFpu6Er2w1260FvnAaZF7bPFo8bq6I/sxtwRdHmp9JG4+3irBXrTc8NHY0ykegmHZG8IlJ9hqMIIXK5jmI0u5GC5Dk9+CMXW1kyaIjVoAFKKhl2pY3IR0kotLKVk7yT1eUxQYqcScNCa8NmnOEvHHQw8VUBFLuUnEjJGQa4Y8SicceLsfoZ0AAmILwrrnNrS0vZOlcsHtd075eSQwEkzUqFCB50gfxV23jOME7q4P8Nc0ckg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by EA3PR11MB771531.namprd11.prod.outlook.com (2603:10b6:303:2eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 18:35:42 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 18:35:42 +0000
Message-ID: <59366200-c4fd-439c-8ea7-4a4b19b76081@intel.com>
Date: Wed, 11 Nov 2026 10:35:38 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/8] arm_mpam: resctrl: Separate MPAM domains
To: "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
	"Dave.Martin@arm.com" <Dave.Martin@arm.com>, "fenghuay@nvidia.com"
	<fenghuay@nvidia.com>, "ruanjinjie@huawei.com" <ruanjinjie@huawei.com>
CC: "tony.luck@intel.com" <tony.luck@intel.com>, "yu.c.chen@intel.com"
	<yu.c.chen@intel.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"fustini@kernel.org" <fustini@kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
References: <cover.1794283825.git.reinette.chatre@intel.com>
 <TY4PR01MB16930662726889E62E09F19D88B712@TY4PR01MB16930.jpnprd01.prod.outlook.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <TY4PR01MB16930662726889E62E09F19D88B712@TY4PR01MB16930.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0073.namprd03.prod.outlook.com
 (2603:10b6:303:b6::18) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|EA3PR11MB771531:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fa55543-7da2-4418-042a-08df40229727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|376014|7416014|366016|261009223027099003|10067099003|261028144727099003|261026121527099003|261026140227099003|261102123227099003|261021121427099003|261022105027099003|56012099006|4143699003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: qZjNP0kvOzKQRNjmwq9QqpFOoWwt1Bgo3inGFUCnNJPCKjeP5UvIsZlaT/0hxrEfl+IR+7uVt4QP9+0AjMoNS19bnzZH6AyME5tFbPN4RhGbONBw7w1C5U/NBx3d9IArmkbeLYRPptU0TWeOYxteHZdroPIBmBEi8HAsTx+QNkJjl/fAFWYlRReuZDvm8Sj2voFbgSyIj2LG94V6mVxxa4MoOhqDhCTvlfggvquryamJkUM7FQl90r8eiHsBDYwRlOr7I1kC2dpzhnHba4Qxba8a2edmIbqxJNRAHF7x9vNLlaM4Q0jPWloSsNCYhoXXLqHH5pk4vDfghXYuqCQ4SRLtZRgQduHA5r/xRj0tGXp+3HA2fH55Cg3wVUmpGSp3sEEF8B3waOjn32nQ7S9m4TrSyg0UXpZbxoPAQyxBf0Lga12tqlViwo6U/LEVsBEdIH018ADxBin+VH0HRkMILJVtKVkQ+M5YwWhCoLxb52tFFVqqwpOTW23vjXNBNsaYrPjjMos2jormMIrWY9yJ0SWygM+Jdsan4M3hcTmBfjWYwRI0WV3SvjdCQ+dP34+gt+GmuL2mV2ZYSQ0Mi1kUwIsagu0JKSrQW39Fe1TTESdZqr9kMdE0H/AgHOHsaB8VVc2pgpBfv2or4YGrfxWTZnknh+E1Nt9hwOm8cJDR19M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(376014)(7416014)(366016)(261009223027099003)(10067099003)(261028144727099003)(261026121527099003)(261026140227099003)(261102123227099003)(261021121427099003)(261022105027099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFcwb0FOcUgvczFHSFBLaXpoTHZzK3FsTGNTU2Nyb3dpbWpGbmJHRVNlNThC?=
 =?utf-8?B?NW4zMUJsNTBEZThua29pR0kvV25WQ0MrdDRQNlRMdmRvbklWZUViSTg0N3Av?=
 =?utf-8?B?eWJheTRreHpDZVBYUk5iOU1KNGdaN1RpM1hHOS81eWZoZ1VDRVZvbjBZSU9S?=
 =?utf-8?B?VEdxNGpmMmNjcjBrTUM5UzRtS01JZ21FVWxDc2I5Z2QyWVJObDZiSzB1bDc0?=
 =?utf-8?B?Vzd6QS9ubTFVMmRmUzBKU3BTWUxZdXZXVFYrWFUyMDZSeEViWEVUMW9ORXRQ?=
 =?utf-8?B?b0hmbzRKcW45VEYvbmppN2xKbXUvWGNCV2xiZHJ0YVo5NlJEbC9vd3RBdDlC?=
 =?utf-8?B?aEdqOGkzc2NzelNBcWFnQVgrZjNWbnhrNklKZERvc095RkFmZUdmUnI0Qi80?=
 =?utf-8?B?dk1OdmJzb2M0djVENlBNMDV2NXdMd3lIbmZJM29NNkJpMWp1N05sWDF1WkJU?=
 =?utf-8?B?WVpXd0JlODJGRUNFakg2RXJmMGRGMlNua1BQeVpOaGxMa1FQOWVkZHNuQ3I5?=
 =?utf-8?B?NEV4RlRKeXhmWm1VY1NIQ2tKdXMrajhsUDlSNXBFTnRzc1hoMElYdU1LcUNa?=
 =?utf-8?B?TTlTZUorRHF0eVpoekd4ZzhOZ1VnVUFMK2J2TTB0WTJzNmdXN2lyUWpKTUN5?=
 =?utf-8?B?b1c0aTkxZjI3ek4wUW9uOG5aU3AzWDYxYWNoWllWUTJIT0cvVWFYZUNSNDZE?=
 =?utf-8?B?Sm91WHhiMWFXZVhoZ3pBSlhrRm9vdnVIQU1FUktaM2svQVMyV0thbHozZnJU?=
 =?utf-8?B?VE03QXlVNXhSVCsrVk9JT0svZnIreWtXS1BJRkhVVndwQnlpckRnWXNhY25O?=
 =?utf-8?B?Y3ZaSElkbHRoNkN1V2xyNnE3VWJZd2RJd3c0citEWW9tTmUrUmhHcEl3MUpB?=
 =?utf-8?B?TVZiWFE0czVNbVNObzRleTJiSmtNMURZYkpRTjlvdHVpV1A4Z1ltZU0wa0dx?=
 =?utf-8?B?Q2syTDRFSW4xRlpwMTYzNE4ySXA2OVVIeEJDYndJUDUzditnWkVROGtmZHUx?=
 =?utf-8?B?UUxnRE1vMk5qR0NBVE43M0x1SUhUc0VOSEFLRS9RVUdHZGFXZldvcS82ckpH?=
 =?utf-8?B?V0hNOXZwL01jRFZueFIrQXVyVnkweFk0QlFZbXFKR21qdEpyWkVPQnFlQThk?=
 =?utf-8?B?QVpXeXpJbXNUbXcxQy9sUzBJQUdsdWp5Y09IRzZwTExnNWxWYm1leVhDek5U?=
 =?utf-8?B?MUtveDlzbHFwa0czVTJxcjdqQXFvektidFprazhMNDJBWXJSbWJlYy9GQjRr?=
 =?utf-8?B?V2dpT2xicjlHUEIrUTJuTSsyOTBtdHpWZ0t1NUN4TXRodE91RnJsWWtUQ2N3?=
 =?utf-8?B?NDBjdk1iYm5XTlYvUlhKTWkyRCtkSmdSaWs4K2ZPdzJzZElxZUoxcWVJLzY5?=
 =?utf-8?B?eXczdXdmNVBqYzVxczg2R28xcVFBb2JodStScWk5L0FrVEhEWVc3WUt6cWhz?=
 =?utf-8?B?aXEvSE9acVFqL3Z0L092ZmxnUG9hbTcwdTY2VkFlc1I1WnlXN1dtUnozVXVX?=
 =?utf-8?B?Y3pGQnpTZWd1RWhtRXpNMjkyd2ZodVZWWVV1Q0FCQWoxSlp6Q3E5Q1lzRDlo?=
 =?utf-8?B?MHZqejMxVVBRTWlQV3d1bDFQRk83TGZadXI1Nnk4U251UmpQaWorMEkyZjdO?=
 =?utf-8?B?UExEbUgvTjBoSlIxc3NsUU91WlU5amlmUHphaWNIUzVxYisvazluVFZpK1Bj?=
 =?utf-8?B?dVpGRUpibzErOFhYS1FzQldveXhIakhMdUZsa2pIR1FaRVZxNmJ5MjZTM3BO?=
 =?utf-8?B?VkhzUTR2TnR6amNwMEhrQjRoYitYM1pRcDl1RVhsSjBYOFA4VXdtTDZaeXdI?=
 =?utf-8?B?c1NPdzgrWU04UkVuaXl4QkcwV3R2RFBoeHVpOHkxbjVySytoRU1zWWVtR0Vh?=
 =?utf-8?B?MWIyUHZnSmk5SU9ONU5jVjVsWWFTcDI2Ty9rS1R2YXZzSEJCUVJ0d1VLTnJY?=
 =?utf-8?B?V2lUZkFNWXEwU3VjWUVZTnJtNitRQ1AxZWtUeFpPWXdwaUV1NmNwTUpJK0c3?=
 =?utf-8?B?S0JYOGVjbXVJMVVJeEY0Z1VDYlZHakhQTDZPc2EzVGw0RWtFTWJ2MWV0L2s5?=
 =?utf-8?B?VUVvSjFacmY1UGlVU1hJbU9uNS90Ti9TelB3ZUw1TjZVZHh5V3E4c2k5NVVy?=
 =?utf-8?B?eWRxM3JJUmNRL1g0RlpQajExaDd3ck13MFRqZXZtS3dBa0pIek41Vk1mQ2J1?=
 =?utf-8?B?aEpDam9MbVFQMlh5V1lZOElyR0p3VmFueWQ4ZFpRcUNSczFYMjA2c1VkR3JK?=
 =?utf-8?B?cE5yZ0RCUFRBWS9wWkZsRDZRM0wzR3RlUDZoQzRKejEvSDArTTJWRFpmSHVT?=
 =?utf-8?B?anhtTCthZ0tEUlM0SVRrSVNrUENaUE40S2IrdURvWXhpb2NUWWtNSm1iVDla?=
 =?utf-8?Q?7vrEZpy5GbZcU2XY=3D?=
X-Exchange-RoutingPolicyChecked: pSNnUyyJcvFm5XXrwQPq8+gIyAZOtRDJwALP/vvrLQPjoIndHBVE8sxYV8KEiF0i5ZqfbS8ip4m/r/ZykUHebe0wacdfY0qw3bm096vUTlZgy/tE6LZsd8kInxZ0qnPgYe/oNNEtZcyoWkOXNZpw1O5PBq8sfzotOCyS2CEVfi1mB2nTx8O+fjf9qkPNXc7aGTgKHMZhNQr8ZObJ+oaNPpoV80ZClff6t93WcTO5N+XoRZQRA3G2jSTtqGZ1zS0wSi0UC0/ZHgG258EeLgtkR+9GeBwuOHrkep1HAPv93iSbKHhbVvpyknUDn2bIczxP5G+bCOagsh36y+cUlBzrtg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa55543-7da2-4418-042a-08df40229727
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2026 18:35:42.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fBmL7wbMsCxnXUAVvVmI+gTMuylnSOAjxe3wBRmGQq1cl08w1v4KsItj1zo8eMJr+ixBr5ZSAR/GcyW2/DAaEky77H8xcYxZ49zDyi8/ihc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: EA3PR11MB771531
X-OriginatorOrg: intel.com



On 11/10/26 10:10 PM, Shaopeng Tan (Fujitsu) wrote:
> Hi Reinette,
> 
> Thank you for the explanation regarding mpam_resctrl_domain_insert(). I understand.
> 
> I have reviewed this patch series, and it looks good to me.
> I also tested it on both Grace and the Fujitsu monaka simulator, 
> and everything is working as expected (no issues found).
> 
> Reviewed-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
> Tested-by: Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>
Thank you very much Shaopeng.

Reinette

