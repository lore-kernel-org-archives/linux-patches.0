Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FC452F5313
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 23:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960711; cv=fail; b=ePkzjiSjO12MovNegkTBlVwsR7fzfSUv6BlwV7uc5adYlEw0P0eDQBX7ofV//RyA8iVrRG/K2k0d7bZxq7I1/WwwNJ3Xhji6mjPsigo8mNsTPFJZFBmYY8XQnGR+9LBUceNkwpAQm2no/+FjQKa0OXMlKi6XJOtIVqp+FwvI6A4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960711; c=relaxed/simple;
	bh=S8rjLr6ccHkiyTyM3q/9yb22fCi3zioA4sPGArIGwr0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QxZvXonspZbHLtMNTthYqa8yrecXqpTEYVIP/DHvHSZUIlXyRrYE5J47nzBH1zKFvIJnyKWUyX8TpbgtaHQGM89OYIRpfDmNzocyyWENGHQ6qBMJdzXlwYX4E2kPQvuhi+iZLzRfCBo1nNcUM3Mi6Hh+OArZVvw7120SmNYxreA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K+Ti62wm; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K+Ti62wm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960710; x=1812496710;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S8rjLr6ccHkiyTyM3q/9yb22fCi3zioA4sPGArIGwr0=;
  b=K+Ti62wmAk2W26NHxLFfGrBmwEA0B+VeXVLJAQiaIbkB92BHml/hFwJB
   uCOBQ1n4q5stfkDH8wZgUfzdPZkyy5Or60Jdw/AW0uCBIO7exPF0hFHBo
   LeWR0fR474baJ+/40ytBkvoO1rT1Jy3jvLmpmmF/HBpCORfRBY5iyd45j
   Egzv+5XEagI0A/5g+HfFL2NaAa2FqVj3IKWKl0anscUJ3FxrAAayHvnTv
   E5wjwcPNHew+r4+xK23hC+r85e0gQDUYUHIJC+31vYzDnhB6jQjFlzJM5
   tgS9k0xqfwUHRewbzBH4PKHswfQpCOEbbfOqWQBNlEup+rOGQ+AIReaZD
   Q==;
X-CSE-ConnectionGUID: GF/dCVqzSe6DOXVGwLqM9A==
X-CSE-MsgGUID: vb2eNaSXTO+/qb2Qpgm+jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="92817659"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="92817659"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:29 -0700
X-CSE-ConnectionGUID: FJBRJnh2TyutOEsyW1lzpQ==
X-CSE-MsgGUID: JxOYbu/5SqOuwXtDd1588w==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:18:29 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:18:29 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 8 Jun 2026 16:18:29 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.44) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 8 Jun 2026 16:18:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UxpeqGgxmZZPFHklodiY+rKcwgce17a0XwWNdp2h+qcm/YI6snN5Fkf/RuueThozYr2gpQtX/b/bH0hoyAWvGqFfhCLMXl/ewCSumwwGX20Nh7E1S1gtnYz8JHDUH12GtNH9x/qA10mfAyPmGgN85xsAsbtUqB34hl2Z/O1L9Bl2FWjDzccRei7PkG2ybzEcK3XNfZwEDvaIWDVyHEurdV/f1Dy1XQQ6MrJkZEeeQTd/h1JjgtS4w3ChrwR0oUCP1HRsjUHg/A7UstMJMPnEi4dbEnN1P+nMoxhdhEfLx7GkQGJLIDdTHgBnlRsEyc58MJkh4kOpgl0Tyc4dQmWFJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4yOZkq+PBgxt44OiKyZzJOZCh8EvdFRxVLdJkr57V0=;
 b=rCMNx6uJCTnl9j2DYVZmMPiuzOaPmQ325jknDq4gq6Vo9mux+eMRdoEPPk3qeHd/2Pkd8GqbhOD1PtMqZO/85PcWwgtV9AfE2x5RmsUI7qsVRBNVhyh2ghgzPfGCY1wbgqLLhAejgskaDtYI9IZ5DHQxa65r4+eauibmocV+rkZefUruNXFbyaqJH2hT15cFtnu4JwqPVDRO0FheLiqph8K1AzU9LO8CjMl7Ow1m/sGDR567r9Nt65tFv5ygH/y21KmsCphrdi32X22dx87mHHIwOlndASjKNKpB1LFAdr1J3mQ5WW7NqikipDyKb8g2naGNJsI8kZVu6mrfUt078w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA1PR11MB6734.namprd11.prod.outlook.com (2603:10b6:806:25d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.7; Mon, 8 Jun 2026
 23:18:25 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.011; Mon, 8 Jun 2026
 23:18:25 +0000
Message-ID: <ad6da54f-5808-475c-b46f-858f7f31cc18@intel.com>
Date: Mon, 8 Jun 2026 16:18:23 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/14] fs/resctrl: Add interface to disable a monitor
 event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-7-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260601195632.15876-7-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0127.namprd03.prod.outlook.com
 (2603:10b6:303:8c::12) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA1PR11MB6734:EE_
X-MS-Office365-Filtering-Correlation-Id: 4efb71ed-46b4-48ae-e300-08dec5b43d77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|3023799007|22082099003|18002099003|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info: sHHoXKBm4J7f4w1rdzUAR5OpA6xr9OSU/V5lkF+WEtvGElb2fi4sNFSzktasZTG39efFz8y3NL2kn+yRaJlDaKM3uO8I36NTfyp0mlRMhvPCrIKkIYA6j3fg0f7HXAoszoJwDUSKeAQW6KvyaRLBvTcDynQ6SI3pw4qQYWJ7yLjJvciBSLcVkfrqVXjJNkF/CfI5bZ2Sd6REbilYU0/uLZCILmdSuJXY0o4y6FPeC31T9Ur6InfcnBa0uZSqudm+Zv6KZuj49fxhEe/ZzgT73F6CjtXgou7qBOYfU3RjOkO/CwBLzd8nv/rWFYUTmBgWtpuKfh1QF6pBBO/wiFKUrzgyvbIGGAACH5jHk1cuOt8N6r7ddz6bAmijFIbpPPG1wQa2W/mWC1lOtG9Rg6U/JRIUgXPRhmlCeWiXh18IJN4avL85eeG6kaUAEtkS7VBITp71ecMSIu95ynqkpcDNwe5JsR715IXXIG3Z+xHkPmbLz7MYY5EdVwOwG3V42YRSgX6Bb/OuRXEd3gTTP7X8YeHV1iBk82QnQMuHMGXjh8FSoj+YQvCfB20WY7zq12jEBBzCvpdBCI1AjCcn8uiH3MTn1EtxNAbi1ujVoIzeAPp7onE+2Gnw2B/16ZedukPG/8BdOE1YVbIId3wy6wDemAl9HhG8zp4lHNFpUM7sIg/ov3ht+v1O07LfnREpVvBppYi4KwuZ91y+y95QJoMP67c8Oxx0212XreznsvgBM1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(3023799007)(22082099003)(18002099003)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2l3UEJCZXJsK1FPa3hYKy96RE8yWm56RkRROURIdTR6MDdvSi9ma0plMFMv?=
 =?utf-8?B?MVRvU0RnemZFZGJmVmk1a2N2dm1INXpKL3ljRC9xSytOQklwVUhNb3RsMnY2?=
 =?utf-8?B?NU1veGRLbzJ0Ly9jVG5kMWtIS1dDSGpFbG9TbTdNMU9UZ3hKSnB4UnZzWVh6?=
 =?utf-8?B?UTRhdGU1MFl5REIvaFkxNEI3UzVydTRPUHdGQTJMMDl5SXVGZm51Mkpid2U0?=
 =?utf-8?B?ZllnWENZM2lkSUp2TWIzQ3RiNytkRStONUt1QWVqeDVhSnpHRkFoMDgwb0FL?=
 =?utf-8?B?QjlqRU9aZTBKY3Vwc3haYUtTQWFpdFRoUEc0OWUwdkJ5dnpNV1prdTNzSkFq?=
 =?utf-8?B?d0g4Z1ZiTFkyRUF4RjRadUt2Sjlyb3J5OEs3R2dxaGVITStiZzY3V0t2RW5v?=
 =?utf-8?B?K29nRkFoeTRpT0J3UHk5VzFKWGFwMW1IckZQSllZelkxNTFWdUt2S0pTK0Zq?=
 =?utf-8?B?MVdTTFZTL0xCZytrSkp2ZUw2eDlsYWxVVzFrSDFBWUo4bkg5MmFqanhxNDgy?=
 =?utf-8?B?TnJyWTg3cUxqVUNFTE5PRjZ0YytrYWxiR1NlZCtHSVU3a3BZbVJMekFZTXZD?=
 =?utf-8?B?eUdoaFBpVXZuU2NKNHNNZFRrcTlVRUZQeVFTWjJuSnQrK3g4ajVycVByUlZF?=
 =?utf-8?B?K1doUzc3WGs2dkVRNXRQZnhQWEZCU0VyVmwwRysrZVlhNDJGMGRBRHdiR3hh?=
 =?utf-8?B?QmZGZXNlUzRjcDBkS25aSFdqQ2hZbEZON2IyMk9iUXFhcWdJSXRraTlSWHRD?=
 =?utf-8?B?emhvNmVieUhGcVZrdVdUQ1RQZ3pYeGFWYXBKL0w2R0prYUpKQks0bVh4dml6?=
 =?utf-8?B?V25oZEJuSG9SUUJtSGlKOS9qUEE3NWh5R1V0T05SdXpIL3czZlIxcVlHcTB0?=
 =?utf-8?B?SnZBRUs4RzVYRGZrblE3U3M0MGFHb0J0ZEJJZzZDenpLamIzZ09IUmJXQWdC?=
 =?utf-8?B?N25jMXJRd1lnei8rbm1jdFlyOG4vLytoa0FlRXpkQlB3VzJYVkxTbDRJdmJw?=
 =?utf-8?B?ZHo1UzEydHNxK3hHaGFPTnNCYjZNdnZvc24wQjkzK2hoWXBPb3JZeStGU1ZQ?=
 =?utf-8?B?OUpTSDdBVW13a040Qi9MU3JrY3NjRjNqc0c0U1ZnYjR0a21Ib0M2V2dwRnE3?=
 =?utf-8?B?akpxMHJ1bDcxQVZlL21aTTFJY25ONkJ4T2VxMWxHQ0hrRC9LM3Q4em1Ob0do?=
 =?utf-8?B?bXlSbW54aVY3MnpnVjl6UFR1UUtJQUkyMDVPT1gvaVlvbWhORjZDemxYellS?=
 =?utf-8?B?UjVZNlo3T1JzTmhESm5RUjV1ZVJ5RXlwbm5pdHFaMVZtRHpON1JjdWFzZEox?=
 =?utf-8?B?bDhhRzJuTTNOMlYwY2w2cHlGcGJoTTNIWmFrTW5qUXJCV2w1M3JNVHd4YWc4?=
 =?utf-8?B?OGtIanFqUVdxb0FWUFNtY3dlUitoV0VLczZBdVJvemdGd3NaYnFSRnZtSzM0?=
 =?utf-8?B?Y0FRSk15V0Mvc1V5QzZETTFBWXpjSDY3aW1ZUEwzWDlLWUY5NkwxNjNVRW0x?=
 =?utf-8?B?UEN6UVhQVTNlamxpWWorNm1ON3lkWTl2UFF5UU1TSTNNVkExWkJma0lYQnFU?=
 =?utf-8?B?c2NUdzhucklEQklaaGlIeTBHQ09lK1lJSUFKWm1SdnorbWxaK1RtbHNka3Fx?=
 =?utf-8?B?eXBOdG9SbHZ5MmNwaXRwSVlWMnJUWXhCWnFxUDRnYUR3OVZmcE5RaXRPZStk?=
 =?utf-8?B?TCsrRGM5NnRtcHozdU5QVmxLdktFUWFIdnRtcko3N1U0L2dDVVpsZUt6K3hZ?=
 =?utf-8?B?VTk0VUJmd21xTWJ4OU5rcHYxZENvcmgxWGNMRGF4bjRXNGw0eWpGMnVyRVpG?=
 =?utf-8?B?RnZhVVZxVmNvQW1ldmFBWUFGZE4xNFAxaWpkM2xKa0JJZ2NTenJMdVpHSFdh?=
 =?utf-8?B?aE95ZVRVbDJINExKQTh2QVRya3VDVHdMMHdkOXFoampENTBxRTM0dXhiWlJi?=
 =?utf-8?B?M2ZHVnFOc1JEdWdCbnRBU3hEQkkzUCtCK25LTE4wekd1d1pJNTdWM1c2anQ0?=
 =?utf-8?B?YjlXSlhDRjA2WFhuODk1anJoWmx0MSsrcUNUSml1Y1lyZXpYb1N6dlBxc3hM?=
 =?utf-8?B?TzdmZ0RkMjl4ZG44VVp5cWNvbis2M01mUFM5N2RVRFN1NCtjdWZmUGNQYTVT?=
 =?utf-8?B?V3IvOFpSRHNKK05COThNSHdxU1puTnBKMzI3c2x6VG1hUDZQVVdUQm1CMm1C?=
 =?utf-8?B?N0E3dXVmemczOWV3TWl6Q2lFbEhibEVWWngrOGg3K0dYeC83ZmZwZkNsL2RU?=
 =?utf-8?B?TEt2cHZYUG5XTkpVY25zS0lFS3RoWnVqcHlUVElkR1Y2elFSUXNzQ203OFJO?=
 =?utf-8?B?TWUxQndweWFjdXlRbnBRaFJIMWx1RlMxVEhBQU9RM0VXNER3bXVoaGlGL1lW?=
 =?utf-8?Q?p5dB/NXvTppJtWOA=3D?=
X-Exchange-RoutingPolicyChecked: eFTGeDP0cSw3fcyZZtRa1vghBNDIysTG+HNohXX4uIKDqrFthf2us2l6zL8Y1ez58+uMgRF6ViT82Rdva9cdxcYcAXJRz0KOikGgyjy1/Lx/nnOetKWxfhQQEIyMJJ9Dyfbd4ioiwPd9T4stYKbF25M8o9iJ7+eyUAHgwuINUXUd0Ng8G8i5+ouKmlztu+7NuoTzg+fIRwqAFjjJs2XBVDqSI6DNIgcV36/SP1LBouyPLMyF9D7atNRfWArN4hz3YFX7BOlNEpGO+IAPARXVz2cbfYwqLM28L46UDr23QRn+TAwiXwUive54dNuXmQY5w+KKoQ2cpu4XBgD7d7sRBQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4efb71ed-46b4-48ae-e300-08dec5b43d77
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2026 23:18:25.1697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HN/z+9Yi8q0a3p4H7Crf5AvFWLkJ4CzGKhPhxn2u4Vmj+BpFe7Z41/SOWF/toRCiMJKbE49kQESa3eTyoFy9Huk/9Pfr/t8SLbJ8WNNz7uQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6734
X-OriginatorOrg: intel.com

Hi Tony,

On 6/1/26 12:56 PM, Tony Luck wrote:
> In preparation for re-running AET enumeration on every mount, AET code must be
> able to disable events on unmount so the next mount starts from a clean slate.
> 
> Add a file system interface for architecture to clear the enabled flag for
> a given event.

This just verbatim describes what the patch does. It would be helpful to describe
how the flag is used by resctrl to support the first paragraph's implicit claim
that the enabled flag's value is not relevant when resctrl is unmounted.

> diff --git a/fs/resctrl/monitor.c b/fs/resctrl/monitor.c
> index 9fd901c78dc6..327e7a863614 100644
> --- a/fs/resctrl/monitor.c
> +++ b/fs/resctrl/monitor.c
> @@ -1012,6 +1012,18 @@ bool resctrl_enable_mon_event(enum resctrl_event_id eventid, bool any_cpu,
>  	return true;
>  }
>  
> +void resctrl_disable_mon_event(enum resctrl_event_id eventid)
> +{
> +	if (WARN_ON_ONCE(eventid < QOS_FIRST_EVENT || eventid >= QOS_NUM_EVENTS))
> +		return;
> +	if (!mon_event_all[eventid].enabled) {
> +		pr_warn("Repeat disable for event %d\n", eventid);
> +		return;
> +	}
> +
> +	mon_event_all[eventid].enabled = false;
> +}

It seems reasonable for architecture to expect that "disable" of event undoes all
settings from the earlier "enable" of event. The new function only sets the "enabled"
flag to false though. This is potentially confusing since it leaves the event with
some lingering state, some of which is a pointer to state that an architecture may
be reasonable to remove after disabling this event leaving a dangling pointer. 

Reinette

