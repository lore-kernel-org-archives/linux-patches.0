Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A638A1BC2A
	for <patches@lists.linux.dev>; Thu, 28 May 2026 16:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779984701; cv=fail; b=Odth3SB5ny9mkJIAQ2X7Ao6u4Mpk5LCWItl3It/eA3DupR5pJtZhvwNWzAXBIOoEM2C3TTU4KF4+hjvt/5MWjZ75WJM3Tth+dO0N/zVLFoms+gaNBzbnUh3YHH4Qss1q0v73bObfo/m64q77cCGeigen2HXm5TGTXGM3TNvARZA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779984701; c=relaxed/simple;
	bh=qqFiLeHuostrzr2r8taXnKkOGnAsrBLnuPm/VnFAS94=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eEkQ5CLdpQejUalVKviKC9yjOJMMXLScd+re1WyeSz3iGl9AGg4FIR/Ayz0l/OSJF+3OKB6FabRJrQ+eYHEXJmRyW9Y8ak50dpPNrAwgI4cCG/NyQALBBzeKU8lb/A/tnRe035kSpCMkrhAk9r1n+SrEU7dtSgtMuF4TLleFVfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MjO2nTYJ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MjO2nTYJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779984700; x=1811520700;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qqFiLeHuostrzr2r8taXnKkOGnAsrBLnuPm/VnFAS94=;
  b=MjO2nTYJgYhk/VCepqIJ+fDrqGwWy7A5vY2M9h66YZKEHQI17lWs1WvJ
   ffB1qMbXc+qrNOllmazfjkJisHh4B+lBb3ZGJ3tA5uW3UKv6ClZEfIqWu
   jFzf+MGsW147AV8DmxFnOaBT8DcHFQD6v9Pk/vSFkoUuNgnsBxx6aaDUr
   dV8lzqSvXZIlZ16XikevdWFwv6WJ9gZkxEy76Mlc8miE4JCluUFr9Zz1w
   S6BF+mkL2dq9MBLXC7UuNNDfG2jhfd1GCdvQuw3wJo80IOHOpXMzhgS/G
   E8siFU3uVc5DnqSkin4yNRz+W2uVnAQw8Ek26eTbfHJdAULmVUDhA2mGS
   w==;
X-CSE-ConnectionGUID: Q0KInLclTmWQNEsa5MM/JA==
X-CSE-MsgGUID: zt/CvTjDQeWG+Llua/10jQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11800"; a="79980489"
X-IronPort-AV: E=Sophos;i="6.24,173,1774335600"; 
   d="scan'208";a="79980489"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:11:40 -0700
X-CSE-ConnectionGUID: 4HqUZvcXRAmqJuxOtL4m2A==
X-CSE-MsgGUID: rHInx/Q1S4afG11/Gwskpg==
X-ExtLoop1: 1
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2026 09:11:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:11:39 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 28 May 2026 09:11:39 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.46) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 28 May 2026 09:11:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j3o2AVGKRsYgXp1/FzwUzHwEpckatap8LgsCvErrAKC3MXLEmTxWgUVg5gd70gg03UQMTamWNrjC9bWGR86QIc6ARsn7Sr1jap4CgXauZ/3l+N2r/iwfNelqNCJ/FlVLWFqzBvlEoX+e4QoNSLngUbgX363vrR9od7EsTjpSWJKzheBLsOGE6usG7uBwxU5Lqs2mie5dkoyPjr5dLjvLyc9aZWKLZoIxuEKysPtMN+1SvFuGlB4yWdPf27VWnbGxvRtTJ6mjJuuNgx1grZ5gMkiv52vy/ka/mtaOY9mVp+FQZ2DCnQ7DSeKPJ2EZrGGE1PqNvcYoIy1SKIz5lNjATg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8dzSgA9md4ZtJHzDS25ArqGOKrv8HnW7Si6hAu/QkV8=;
 b=s/zci2EvVOHPlRECYx3+HtY3ZPcw2Bb7e4p40LX8PzCmVbtbZznsAi7dNCOl+svDcCK4yUvHm0MyEsKlXAqxsUIASQZFD3T06CALbdxmI3adb8WfAiIcNG/0Ai+ZwP5WNsB3K1C70FrMgiv36rbScrfcuS+Lk9xXk7Paq+BDtWnUGv7gz2LvtVHVsrOhXrcDB8m5hUn6AlYH9htLBIzm9Tr+hLkkbLnULndyf8Rj+4IkDSnjmGhg5Ed5loySlc6OYnXQZtPdVWJaJDlLaaaRImZj/OcDsjP6OLLfDC00SGD8WhXQwcSECsyVue3HNe8nye3aWGctVk8tMpvEwimkSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SJ1PR11MB6298.namprd11.prod.outlook.com (2603:10b6:a03:457::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.16; Thu, 28 May
 2026 16:11:36 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Thu, 28 May 2026
 16:11:36 +0000
Message-ID: <4053bd27-bca3-4745-9f34-65843e250f12@intel.com>
Date: Thu, 28 May 2026 09:11:33 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] x86/resctrl: Ensure domain fully initialized
 before placed on RCU list
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <3ba2959b1cd3596e1e340eaee6b43487edaec0a4.1779476724.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0370.namprd04.prod.outlook.com
 (2603:10b6:303:81::15) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SJ1PR11MB6298:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d10a4d-58f9-4ebb-8565-08debcd3cb07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|22082099003|56012099006|18002099003|4143699003|11063799006|6133799003;
X-Microsoft-Antispam-Message-Info: 3EJyDbQgA0JM3VuGniwstvq85KMgy93MkUKeee2YLCizCLjiVYWL/dkk6b8W480uB1e/b9UP06EaNj8LF/w37/MOiCJnp0hxwJuHxoDKOJVhcoScvffD2umgxFGTaOlSeA3Lom7VSORW/AwnZuJFFvl81bowQe4zWvhPMSOUOEHbxpHVGU9wY4DyITiwZeKE62ag82pYyzhqzbYB7+LmRIj8wmLCPPTOqzKp/MqVflAxML+quW/NwO8VudnjdUHii59k3G1CKfzXrY1QrGHYDIoGzB3k2E+MVcdRPTvHw/scxff0dO6CfnPeZe9pnuSNzetNtuEVMV/YPtA7F8kxYIes8RHShiIIunCmozcIViimNL/cCRmkzYgpkwoc2SsRxEUVEEXBgatxEkbqTgmfZDkzq3C2b7cecVtTof9mjUOGsVRIEmW8AAazUkehlo50VGbsxk4KWsLvjJRgfePONI6f8jDJ94QYNCiFEqr4cr08ZS2y3cybazr6dAYlapYGI6G+WECDz1V82bjmixhICTZWJRjtXDkr1qcywmwhg+mkKa3MnJIbJbqNYqfIfp3sUzOLsPYBKCjbH8RDP25Gf/nf3gXCfRob52Q/ysoBLMymPM4uxanJjda7x1FpGupM/Ms+4bmL7IrAQXSfs9WLMw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(22082099003)(56012099006)(18002099003)(4143699003)(11063799006)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MENnZklsMEw0eUJLWkoxY0pMUjRjK2o0VjFYNnRrN2M4UHJSbVpqNkpwQmp5?=
 =?utf-8?B?a3VVSDd4T2lsb1pyeGxueDJqVWNybENiendZdUc0ZERzSHc2OXc1Zmc1Tzdi?=
 =?utf-8?B?R0tpOHlQUFJIa2MxOGJzMjBOVm16U1lUWVZpc3lOK3pNUHZwRFF5ZGRUeWh5?=
 =?utf-8?B?aTRHSWxQbVlOQk5uaFVweldrQytzMEdsckF2Rkl6ck8xVnBOQzhsVTRSOERK?=
 =?utf-8?B?NVA2VnJib1BWa2J6R1IzMUlCdmllMWVyb2x4VWhPSlowakNuUi85TkJ0Lzkv?=
 =?utf-8?B?SnJFZjV1UkRKVEY3VXlrTmQwQ0NDbjVmeE5iNXZNT0lzMEI2UThFMlEyWk5M?=
 =?utf-8?B?UEZKMUR1Q3hEdFd0ZmluMzVtSUMyeTcxNUg0TjR0UUcrTkpRYlZhcWhUczVP?=
 =?utf-8?B?bjJRUFJHR3dGK1o1TUd2Y2hzR25aNGVUWTYvYTN5UUQ0bG8veWU2eHI1Z3Qr?=
 =?utf-8?B?cXozQWh3L2hYMGZtcUxLMEozcC9FdXBsaTdZVndMb0g3UjVVdk9zNWNIM2JO?=
 =?utf-8?B?bFZweGlxTHA5TmtDZWpWSGxDdG50T1R1V0Vnam1OK0gzVG8xWjVQK1dpUEl5?=
 =?utf-8?B?UThhR2tTTzJveWJMSmlHK2pEN1F4ZXhtMStQNUtIYWtvVk5kY0VJejlJaTBW?=
 =?utf-8?B?ckdSNTlYZ2Z0cXkrVHRxaFdpSHYvV01vVTE0alF5UmNnTXM1aXlSMEd5cm9T?=
 =?utf-8?B?ajlxemNWdmRkcWJyWXB3QU5iOGR5aEdGcy8rRTNmcFBNMnkwRE04bU51WkVt?=
 =?utf-8?B?M21PQUVscnVKZS81eWNXalpySTFLMGY1RlAwMkpVNTNQM3JycG1uc09zM1gx?=
 =?utf-8?B?aEhHdEJUUWdyV2piUERtdW02cDRlRVhUYmM0UmhCZTcwdEp2YUlvL1F4SWly?=
 =?utf-8?B?WDN5OW8wdDdoNHd0YkJnd3VGMXZ1NEN6V2gwMWN6SDZodHZ1MXc2L3VtNWJn?=
 =?utf-8?B?dlVWLzVlcUVjT2RjSlg3aHNQR0gwL2NiUFJMU2pGSkt0WFNXV1RXQ3FvTDkv?=
 =?utf-8?B?NkJuWlkxRHUvT2JoaS9MbkxDY2twZXhIaUxEY1lwdndZdEpQSEszenlJMmto?=
 =?utf-8?B?N2tBZnpGQy9VTnAwUitWcXZ5d3Boa1NkMG8ycVQwcGZzSnlaamtWL3FUQ0lJ?=
 =?utf-8?B?YmFsanRjS0FCQ0MwNnBSTzBMS2M1UFliZG8vQjdtUTluSElhbkVLYmpuNFJD?=
 =?utf-8?B?bWpHUzZRRmtpREUreHlpaXpWeTlnUStBay9DNjZCYlhNdnJ3UTBYbXZyMGFk?=
 =?utf-8?B?TG5XRWRHdlhob1ViYlJyUXRWRHBReHNpZlE0TlYvbVVLYXBHZ2Jua2dsZTMx?=
 =?utf-8?B?ZUkzd3JyQ2lHL3plc2l0WnJxVjRjVWllWnI4V1cramNsZHF4Wk45N0llKzIr?=
 =?utf-8?B?RnZJWlJCMGJpQmM3emhReUl0ZXRnYzIzR3ZFQTlVWlBra0dTNm4rVDkzZGJ3?=
 =?utf-8?B?QThKb2ZlOHJBM05lYXhqMlRkNjJLbVhtUTlyb09zS000dTRaYjNMQUQxL0Yw?=
 =?utf-8?B?RHVVYWRFZWh5ZlhLUTRUc1B3cEM1ajlWRlprRDdlcjFYdlhySXhCdk02L2kr?=
 =?utf-8?B?NEVmZlF0ZjJZR2tndlJUNi9TSlpMeFhhOHcwSjNIQVdkb3Y5S01HbHJ3NjUy?=
 =?utf-8?B?bmRvR3FUbkdCS05XbGFwb2EzMHhVdEQ5RzVLL0owcHoxcFdzWmhWRHVsSWpI?=
 =?utf-8?B?WFBMVVRxbGx0SUJhTmJJMklKdWlJbmwwTGt5U3dlL2JnWk42UVBVZHpSS1hK?=
 =?utf-8?B?VEd2eFNZU3ZKcjRCSitTTkVCZFd5VXN3Tk9DNlYzZS9VcngwZ1BVRGR1ckNr?=
 =?utf-8?B?S2Z6YytnUlNjbVdlWk1FWFRFRkdVdlhzeVJyeWdBZnVRQlRLSU9qaEF1TzV1?=
 =?utf-8?B?TWozd0toWXV6a1FpSWFLVFk2N0NDVjU3bitZNjdiUk41SXhPU1MvaFpNemMr?=
 =?utf-8?B?ZDZBeTNYNmlGcW1FV0xjNEVJOHZXN21DaVBrdFJ1aVdpQUdObHNiQTl1aitJ?=
 =?utf-8?B?TDZaTXluZ0ZOeklZdElTTDBDK0dZWFhYNVM1RGs4Ny83ekJkbm1MNXFwL1li?=
 =?utf-8?B?Q3hQMDFoVzlKQzBLWmpRRzg3VldyS3Z1SW80cXJZWjkxcXBwTVZ3bXE5WEFj?=
 =?utf-8?B?ZmMvbWRPNlpWcVZhVzg0NE9lNjdPMDJaYmE4L2dPTllKTk1hWHVQZE9JdUlI?=
 =?utf-8?B?T0VIbVk0VnJxNmpVVzBUOWcrOTYwYmp0ek5PdDFnRFM0N2orVjFiaGNyWWRM?=
 =?utf-8?B?VVdYT2pYRkVud1V3V2VKbitqSTBYcS9OdEVoczBKOFhJY0tRNE5oZVFxaitt?=
 =?utf-8?B?UThva2ZOMUVPKy9MdjZOOFF4ZVZ1amFiYWRaSHAxaTZaay9uVnVjR2h2Yzlz?=
 =?utf-8?Q?CegYBW5Xchhf6fI8=3D?=
X-Exchange-RoutingPolicyChecked: gOk6MGjg2cNbH9DYpkdvXzDtc5qapnJ9kLfEK0qEXBdBWbmi675kCmut5mpUSD4QKgzLn9SsjPTMQb0c2oyfv9mdjc4cLNxiORLzGw5Zxk2WYpprKOD2M/HRyFrD0BPEQyeu2aQiU1R7XeQw0uE7eOkpz7TgLHMYGvt9S70y3gnxvZwpkbcP36dcPs5vqEkHLDYY44pdpnZcd9gjvf6+BFY1X4QEZp5qNoDRYcBMyMflHjzpGPQMDhe0xamEB4j3ak2wvGEeqny8P5/H4enhpZCU1loxRauPWfald0kB7QLmdDeMJOvE+wkQPC43nqOOgW+w/awWwwNZYUcZixa9tg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d10a4d-58f9-4ebb-8565-08debcd3cb07
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2026 16:11:36.6028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fp/Guf8Ybzka1ajG7TxHojpBoADgZXKuraPONdrKLeiqaBuvniQ/Iqi0vM4QBN1HvNxjp7VSF78pxcHBJRr7unMfmG5zgyfSDsCiZN+oHOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6298
X-OriginatorOrg: intel.com



On 5/22/26 12:15 PM, Reinette Chatre wrote:
>  static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct list_head *add_pos)
> @@ -556,14 +554,12 @@ static void l3_mon_domain_setup(int cpu, int id, struct rdt_resource *r, struct
>  		return;
>  	}
>  
> -	list_add_tail_rcu(&d->hdr.list, add_pos);
> -
>  	err = resctrl_online_mon_domain(r, &d->hdr);
>  	if (err) {
> -		list_del_rcu(&d->hdr.list);
> -		synchronize_rcu();
>  		l3_mon_domain_free(hw_dom);
> +		return;
>  	}
> +	list_add_tail_rcu(&d->hdr.list, add_pos);
>  }
>  
>  static void domain_add_cpu_mon(int cpu, struct rdt_resource *r)

I resubmitted the last three patches of series to obtain Sashiko review [1] and
respond to that feedback here:

a) Sashiko: "Does this reordering expose the monitor directories to userspace before the
   domain is actually added to the RCU list?"

   Yes. As pointed out by Sashiko there is a short time where the monitoring data files
   may be exposed to user space before the monitoring domain is added to the RCU list.
   Also pointed out by Sashiko, if user attempts to read from such file it will return
   -ENOENT.

   This behavior looks correct and acceptable to me.

b) Sashiko: "This is a pre-existing issue, but does resctrl_find_domain() safely traverse
   the RCU list?
   Yes, this is safe because resctrl_find_domain() is run with cpus_read_lock() that ensures
   the list can be traversed safely because the list can only be modified with
   CPU write lock held.
   One improvement to resctrl that would help support this is to replace the "list_for_each()"
   domain list traversals with something like:
   	list_for_each_entry_rcu(pos, head, member, lockdep_is_cpus_held())
   Doing something like above would help document why such list traversal outside of 
   RCU read-side critical section is safe.

Reinette

[1] https://sashiko.dev/#/patchset/cover.1779834897.git.reinette.chatre%40intel.com

