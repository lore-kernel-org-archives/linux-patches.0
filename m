Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=198.175.65.11
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793122874;
	b=GQbDY5zdzy5BcBld/QCPDKSnM96xrgoEbFIvFApYP83LeKowiNtgXwwSezdwZjSNXu+i
	 VGoVLVu+fEKthWqF1mAUPwKm2qImLpqxhXT53GmExsDdewvz7PUvf7RvYzUIzyU+iq3oX
	 ImxHyn16e4o77PW7PcRZhAmUWh+SWoYK8VLSXhHlyQB03/e0X4D7Wg5MxMkts7fNtAkcv
	 IpJrpTQeIXJNI29jp/eGfmILAYkvJnrtcJIaDIJp9CL4bQQFS/c26W97RG6VBFlpP7b6L
	 UJfv3zL5ENRZ8QzvLfMUmH4LsnpwbVM3VVf9T8nGSPQ2+XWfZroc4/QmlKsusRSzBhw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793122874;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:Date:From:To:CC:Subject:Message-ID:
	 References:Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-Exchange-RoutingPolicyChecked:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=RuoJr7qaic22WZIL3N+VXvMtuHV6DZ2BiHT5BVm9kiM=;
	b=Dsq/WLP5Ud6y+SghHQEIncPxgRLUtdSSzPej4SQ/HfyRpGCcKeMlPdA4Qe3Y5GArzrr4
	 t0a0i/sf4g807uFp9mgIgBz7rjBXwdJNWEXXQvA0OIc1ZyB/H1iy0T9V1SJEkWhwEiVpV
	 tnfdcgJ1kJFekyfYZDooiPS0AkUKCfQJ2uf4eU+Q4Qqc4i3xUETZYgWGf+NdXU2f+YRQV
	 TBabUqqddLVtP+fnblLR2HQAhAiAMdPxyZBwOiMpbq13/qu9Z6MMU5/UEWsE2I/BemSZo
	 oiGHPIKCYwy+BrQ57+Lf1FCdtOXWZ0StccjFQM2RmPph8n6Fh1ZfHA3H3+IrCfngulw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SNpNaEuS;
	arc=fail smtp.remote-ip=198.175.65.11
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EB2606A31A
	for <patches@lists.linux.dev>; Tue, 27 Oct 2026 17:41:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C8EB2606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=SNpNaEuS
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793122873; x=1824658873;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=HBo0pcTx3LWcBhn/6dTt6j0eN744zle2OXNHqc8sTME=;
  b=SNpNaEuS1yeH7+6nMXZV94KQgVHdeAcjv5U6n1gj32bEchPPQiLVEU+B
   0P++rQBYI4IDPvvHSuS8MVEABaruGeHOqKTamgUaOZbwqdRPOlUlPnvBZ
   9anfmWD17PAUd6SQJggWJDMU3D3lU80GfIonDQT82/yaPpjw+Ic8qGjR0
   FLBiCRd01c6ZOYB5KNvXJ2wZcF6VApG7MMBEaXsw7+gliju9oO9SswBZZ
   CT5Y4R6Pp7MeKDpBkmgVv6t6hqc+VJupbybh0Cj1bWa5/yX0ugF9rtCvf
   wmK2oc1kyjReQiqGypbPx0JP452HuBZ3PyyzypYABNNOKhH/A6cPOZxeg
   Q==;
X-CSE-ConnectionGUID: p/UA8tIVQmacxwldOt5vyA==
X-CSE-MsgGUID: g/9Di19JQXOniN+V2QAAZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11948"; a="1718324"
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="1718324"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 10:41:12 -0700
X-CSE-ConnectionGUID: fgAZsmjMSGepiQAGYbPLxg==
X-CSE-MsgGUID: B5w3010hSsyl7dSe/rSNNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,181,1787036400"; 
   d="scan'208";a="4553002"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2026 10:41:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 10:41:12 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Tue, 27 Oct 2026 10:41:12 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.27) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 27 Oct 2026 10:41:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g6lo2fz3YgvT/8HO4luNS79Q6A/XSvQXTBDvbC/qQ/YIMHf3uE7jVTwFhLkkvZ2SlGKSkdb9TUhlBg+7s6uay00RVuudctYQLa1Ndh8NAZMiQTQbimWN3gSAZ1k9wHHO2ltnkkIPubIYZLoHIQPEQRQMPJGp55GzGsYj+lCjIcpXf3D/4rnGr0Z3LemLl7bIwVheKxsL6pt0oZkoS7WptjASHcHqg9uq6vOpqYmwOtRHriaIu2TvEcX0OhD6TeeuYVMoaTOEFQs16b50cjL2sP3M5UIiChSgzVDOnZgxcnEhUYCQij5ZBQcAATA4H0YA3wDrPYwCI8UzPfCIsR0P4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RuoJr7qaic22WZIL3N+VXvMtuHV6DZ2BiHT5BVm9kiM=;
 b=Fjracs3RS0UFGbASL/fxamZK1YWVmiEumJWZr5FQM21Evr8PNyRvQENw25q9Xs72/i6mbmIn83Af0qJ7yvhyKX5BWGeJ/VWWimwj4Jm/PeVpJ0Z24puQbkGVkkPBXlQsxfaJSeVFWasyy+UyzGJ0TKt1lUyRgUdQeu+J9/cPI8pTRP90rFGi9JofzPPYng4iIs5H4Hg9v7RHXljfqXyikuLGtjqUQ9aIeki3HR+lcBadxZ+4qFDTVS/mV2o219QGjm9CDgIAYBsASMiya7SEL7oVsPd2QxkbyyCaXNudHmL5MuZfyejoIaNkb62ADMK+cKuPsD74kJpBx6x+yME6uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH8PR11MB403433.namprd11.prod.outlook.com
 (2603:10b6:610:32f::10) by PH0PR11MB4933.namprd11.prod.outlook.com
 (2603:10b6:510:33::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.22; Tue, 27 Oct
 2026 17:41:02 +0000
Received: from CH8PR11MB403433.namprd11.prod.outlook.com
 ([fe80::b087:96e4:50ea:b5de]) by CH8PR11MB403433.namprd11.prod.outlook.com
 ([fe80::b087:96e4:50ea:b5de%4]) with mapi id 15.21.0546.021; Tue, 27 Oct 2026
 17:41:02 +0000
Date: Tue, 27 Oct 2026 10:41:00 -0700
From: "Luck, Tony" <tony.luck@intel.com>
To: Reinette Chatre <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
Subject: Re: [RFC PATCH 0/8] arm,x86,fs/resctrl: Support asymmetric L2 cache
 allocation
Message-ID: <auDiLEujZ5BGCACj@agluck-desk3>
References: <20261026215718.16810-1-tony.luck@intel.com>
 <106caf0a-8644-4801-9591-80be38b39418@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <106caf0a-8644-4801-9591-80be38b39418@intel.com>
X-ClientProxiedBy: SJ0PR03CA0228.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::23) To CH8PR11MB403433.namprd11.prod.outlook.com
 (2603:10b6:610:32f::10)
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
X-MS-TrafficTypeDiagnostic: CH8PR11MB403433:EE_|PH0PR11MB4933:EE_
X-MS-Office365-Filtering-Correlation-Id: 81ed2572-5713-4127-5505-08df3451785b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|376014|1800799024|366016|261026121527099003|56012099006|4143699003|261021121427099003|261009223027099003|261022075727099003|261022105027099003|10067099003|11063799006|18002099003|22082099003|6133799003|3023799007|261026140227099003;
X-Microsoft-Antispam-Message-Info: s+pkjQpjwZ4nziejL7ZkDfG2hB2bUrgqm1tHGMJ1McgoA4nz2fpHwIe/b0cclsFudNsNkCGJ/b8LiSImU0zU1Y/eTHHSJz8CHnyo5XUsRZzsw2BehCfrebijtvxvJHWNKg9X29CjNTJL48iUdZq4A+DR7exxfEAi5YFrKPlJVkTGSCoBYziuE5xq7Mde/mw7fX2ab4/1jeQ4EZn6lk4wo/zdIJK6wbh2bFVEOIg1Bz4QyClQzubOkE9+gqP809hi7l1XQFVKBEQ/ucq5pey8/+oF/muFL7S2W01uIE+fGfb+P7TMw09AwhIUqnE+UR15HB6cadNGagNVdGufYP5/tfRGjbtbXX4OPP16pqJM+fCnEL5Ofa6VZq4z2qn70qkWvZeWg34WaMXBaVGkyOK5N1YdidLDqLKGm1QQBrZxJTS+8IOlzSdG/l4sft8kPJbzqkW+ZKDMsFB3hyceL7arxDPmR+QJOPWhu4OOmFxq4NsL3/JhaO8F+ib6kjpuqKmeOfT32RJT7Q3Ux3HVl1rGFPTpMpIERu6ZiUUZdbYl8cgBKeinmtsNFzZis+kqxeOcFwwrHaT0+OQuJsPU2+ji8Z1eT+hdhvmatrY++4IVenAPuxTW67Sat4IWMbk+dBNG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR11MB403433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(366016)(261026121527099003)(56012099006)(4143699003)(261021121427099003)(261009223027099003)(261022075727099003)(261022105027099003)(10067099003)(11063799006)(18002099003)(22082099003)(6133799003)(3023799007)(261026140227099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHlMckFjOEhsbFlSNjNBZWxMbUdDbUhjMFM0d2R0TDM4dUxvbUZkb3VzRFpS?=
 =?utf-8?B?dFlUL0RlQzNqUGl6NS9UeGZWNFU2NlRNTGNVOURVUjlwZU01ekI1bVU0cFQy?=
 =?utf-8?B?QkZtRkEwWW90SFVHY3kzV0svYWtaVXRQaVNSNU9LMmYyTnUzR3dENWJ0c25R?=
 =?utf-8?B?OTMrbThjbm5aejhmcWJzUmZJSkNqSlpYaEFTczU3cFN4SkZKOUxZbnNHRGla?=
 =?utf-8?B?RkY1TFJVRWx2ZGNvcm5USCtGSkV1ZTNTa1B5YzUxQWd1UEZEMkRHOVRQc3Fz?=
 =?utf-8?B?Z0p0aEU1U3JGcldKNjU5Wmk4VS8wK0R0c1NVeXpldkdmQklmak1rczZxNWY1?=
 =?utf-8?B?S2xpSCswQTc0aCszZWFEdGM4UnpRajBxU2xsMGVTdTBJeTczVjh4dEcwbFZs?=
 =?utf-8?B?RklEU3M0czZZeVB5bDNWbm5pTUsvVkQrSVVLTkkwRVdoWmovWU9GTmVPV0xq?=
 =?utf-8?B?QnVkYlhsS21iT2ZybkVBMm1heEFnVCtwaTNmeTU3Tk91dTRtN1Bwa3RWeUFH?=
 =?utf-8?B?UVBYV1F1STYxanR0b2trdk5TNDI0eDRhSHgwRDVTNzhuVDdCbXYya01xYkxx?=
 =?utf-8?B?NkQxdUZnS01vY3VheG5nZy9va3NWdW1xYlV1WEc3STVqaW5tTFFkMkJWUkFk?=
 =?utf-8?B?dTkrUFdrRU9Ec2phQzRLQ2N0YnpRSlR3ZnZ4K1NLQlp6dTQ5dW1lZkh4YStp?=
 =?utf-8?B?ODZKeVQ3ZktrT2dCNU9IUlVXWnAyUVF4R3FrajY0QllSd2hCVDlrY0M2bTJO?=
 =?utf-8?B?L3VmQS8yNWRWdmREMFlZTjNiTXVtcXE0RnBsQ3kxdC8yM0l4UnF0QUpCMGVa?=
 =?utf-8?B?dEZEQStkWGlZeHFrVGV2clhadTRLN2o0dlI0Lzhpb0hFaG1NeDJ1bnh6R2RM?=
 =?utf-8?B?ZkxCcjI3ejUvZzdRM1pFNE5iY2I2a2t6RGVBUENBc2VGUVp6aW1HUlc5NVF3?=
 =?utf-8?B?aTU5V3plWkc5MWhsL2hLcUJ0eWl2Y1kwZmg5SlpZcVl5cHF1eUNyUkpyN3Ey?=
 =?utf-8?B?Q3BodlYwS0N0QnZOakIrVWNtak9JT0NaRlN5SG04VmYxbW5nWGx5YzVSREIy?=
 =?utf-8?B?ekxQZndNN2E5b3F6Vi9sSit3amRia1VUZzJ6bU4ySHNoYXJYc25qYXdoNEpX?=
 =?utf-8?B?TzY0elpkUFNoOGRkQTFoUFZkMTk5Sm11aEVBazFERi9zc3lSRXd6OWtDa2xK?=
 =?utf-8?B?OXNobFRxZ2ZxKzRMZ045Q09ndWFmcW0ydnM1d3llRkhOeXBaekdyY2gwc0hm?=
 =?utf-8?B?cTMybkMyR3RLQ3ZnazZVM3pxM2Zwc1MrNmR3c0ZLMVVvclJuU01rN3ZscWlC?=
 =?utf-8?B?bnU0MlgvTmhlZWhwS094SE9MMnpvZldtOWl0SHprM2lRKzRyMkdEZUtHMUQx?=
 =?utf-8?B?T0xjakpSd2J5S1FoRWluOEpUanpZQi8vbklEUG1WL0xhUFE2SURyTy8zQmNU?=
 =?utf-8?B?ZFVQNUR3NWlycnBnbytzTGhybENlbCs3aUJ6T2RxbEVVMFdTQ1dJMnF6dC9u?=
 =?utf-8?B?QXAva1VsRFg4TDNLK3hJdG45VXZ4aHlmM3h5VXhKYVZ6K3owR05SRVMxMjlt?=
 =?utf-8?B?dVJzZmVFNG5kbDBKODJqM1l0cnEyclZ6b0hSNTM0UWN6TVl6K0txMzhkZzJ0?=
 =?utf-8?B?MmJOWXZLSXJYV0RncXI5YktadmQ1MGJlL2U0R3ZnWiswUElCS3NvQ0ZQVnl4?=
 =?utf-8?B?bHNKcUwwNGNCMUQvOEZVWUpDanB3NkRuNEFsTzlSZCt2dmhtdVpubCtMUVFq?=
 =?utf-8?B?MEVRZlZEeDRncFBiYml5ZnF2S2FzcnZveERadXdXem1lWDVYcGMvQys0Qmow?=
 =?utf-8?B?YUhGRjQyd0V3K0FESkp2OEtOaHhsKzhTb3NPaFdMMTRRUEJvRjFpZ21tdEZT?=
 =?utf-8?B?WmtvS0xMZ0JPc1NxWm5vVU5FMHp5L3ZMTmxYRDgrbE9BRkFEQUMxbEt5TCtD?=
 =?utf-8?B?aStsRmlHdVgrWEc2RUNhL0hNakoybUlCSzNLamFyMmZvQ2hZcXdYU3gwV0lO?=
 =?utf-8?B?OFl5V2ROQ3VUOHVZYzNOVjg3Z0RVWm1NTlhOcTV6S0NyN0ZRaU4yOGw2eFJp?=
 =?utf-8?B?a3hSeGpyMWsreHltVXVGNUJ0ejFRdXhXclNlQTBTSWJNcjBTdmtkNlQ2aCta?=
 =?utf-8?B?OVV5M1MxYjF0YW85YzkxRjRWWHErQ3g1N29IUEczZloxTWptbkF4U0M5YXVw?=
 =?utf-8?B?Q1lkbnB6Vng4NUdtb0VudmtNZG1DVjF4dmlnNkhCc2h0ZC9RNTZCOUFaYVp1?=
 =?utf-8?B?VTRqcjFDNS9oNVhpU1ZMRVBHNFN0d09Ia3FLa0gwdXpTb2M2NFdmVTNhZWJB?=
 =?utf-8?B?a1QwNkp2Q1dXVm5IK2phNnplSHJnNCtYRmMyUFdqQjR5VlMrQXdxdz09?=
X-Exchange-RoutingPolicyChecked: bHeYM5S6VnM7Hjx5kWmrSg1/kDErnM0i+fwGhQQT8fgN5dOsw11su8Awff7SsYaVr5899mRL206XBkFsv7zHBoEn97XRDbWsZPJDcDNt99PwNqWCUTrE1xcWQuU8nPFeHI6lPnyEBLgx6HrWQchwmPpwPdZUsL5gNl8oTD3fGgyEswU1MZAJs+jHu4dpW8uI3hM9jvTJwOzfLsesW5UbQ5T/oORy5ND8q5YCy/8kjfsi/MVnZ6/1/7yMxkoUq400d9N5E0VTfpGQo/0Nbjox7wiaXEFyy5fP2vVvpQ+fMoGZPLCLS4jpnO4LC37VPAVo4E06YY8+4N44IK3MVk65yA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ed2572-5713-4127-5505-08df3451785b
X-MS-Exchange-CrossTenant-AuthSource: CH8PR11MB403433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2026 17:41:02.7387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cE9brb71CtX2CxlUFR18WN7tSg8HpVd9GYwJDGx+KRZvrHSiBAJAD3uShhPrynQQmwvLanp4DYPuHvrevkKAMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4933
X-OriginatorOrg: intel.com

On Mon, Oct 26, 2026 at 03:30:57PM -0700, Reinette Chatre wrote:
> Hi Tony,
> 
> On 10/26/26 2:57 PM, Tony Luck wrote:
> > RFC patch series built on top of Reinette's multiple control series[1]
> > 
> > The goal is to support L2 cache allocation on hybrid Intel CPUs such as
> > Panther Lake[2] where the P-core and E-core CPUs have different number
> > of supported bits for L2 cache bit mask controls. N.B. it is assumned
> > that the only point of asymmetry is the cache bit mask length. Other
> > parameters must be the same (but code doesn't check).
> > 
> > Overall approach is to add the per-L2 cache bitmask length to the domain
> > and use that everywhere instead of using a single value from the control.
> > 
> > Patch 1 changes the format of the per-control "max" file and should be
> > merged back into Reinette's multi-control series so this file can have
> > a consistent format from first upstream introduction.
> > 
> > Patches 2-5 are enumeration and preperation.
> > 
> > Patch 6 introduces, initializes, and uses the per-domain cache bit mask
> > length field (arm/MPAM change needs careful scrutiny).
> > 
> > Patch 7 enables asymmetric L2 for x86 CPUs that enumerate it. N.B. it
> > renammes the resource from "L2" to "L2A" to avoid user interface issues
> > with tools that expect L2 cache allocation to be symmetric.
> 
> I did a quick scan and it seems to ignore the the distinction between a resource
> and control as highlighted the previous time you brought up this work. Specifically,
> please see:
> 
> 	https://lore.kernel.org/lkml/eaeb4259-46d6-4656-8354-669ad32654b5@intel.com/

I think I see now. You want the "asymmetry" to be a property of the
control, not of the resource.

So the resource name stays as "L2" but the control gets a suffix (e.g.  "_ASYM")

File system looks like this:

# tree
.
├── cpus
├── cpus_list
├── info
│   ├── L2
│   │   ├── bit_usage
│   │   ├── control_mode
│   │   ├── min_cbm_bits
│   │   ├── num_closids
│   │   ├── schemata
│   │   │   └── L2_ASYM
│   │   │       ├── max
│   │   │       ├── min_bits
│   │   │       └── type
│   │   ├── shareable_bits
│   │   └── sparse_masks
│   └── last_cmd_status
├── mode
├── schemata
├── size
└── tasks

and the schemata file:

# cat schemata
    L2_ASYM:0=fff;1=fff;2=fff;3=fff;4=ffff;5=ffff;8=ffff

> 
> Also, why does patch #1 drop the 0x prefix from new control interface when displaying hex
> values to user space? This is a significant change for which patch #1 does not provide
> a motivation.

Sorry for missing out the justification. I thought that matching the
format of the schemata file would be more useful. Then someone could
reset a group to maximum values with:

# echo L2_ASYM:$(cat /sys/fs/resctrl/info/L2/schemata/L2_ASYM/max) >  schemata

But if you like the "0x" prefixes I'm OK with that too. Just need to
replace "cat" with "sed -e s/0x//g" to reset to maximum values.
> 
> Reinette

-Tony
