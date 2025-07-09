Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02CAE55B
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 21:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095834; cv=fail; b=JFMzBb6D/faFoWmIFcU89Onwp92COkJ55Lr95ew4TgnAbPclf4j7d2mmRCRZI0aoRKlJoevWIpfCbte2goB5ihZs1rFlv+VD0fsM1aCgCNihxCk3MkESWY1zekDEPBTrakIpyk/aNDbZLzHk9eCGOnV9WidNAUOpRAs1QNP3Xn4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095834; c=relaxed/simple;
	bh=hUVZTMXGQQd+t32FJ5EOZpkFJIOCADcFFmhSY9os/ac=;
	h=Message-ID:Date:Subject:From:To:CC:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RTa3yNNdq6QQEyN+TPE22dQhKSWO/gWmmu5SquqVoytc4/pvgxQ8pV7HXaj5dlb2yyakiZsUiL0M9QzPP0zMRU2DKGKdiI4TxB3BBtycZPHSdPYPsnGp3DR02B5ynnZCMdcx+n5AW0YtDIZSSVD3IC8kW4+eqcNK41E1bKjZuLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cj05u/Y+; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cj05u/Y+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752095832; x=1783631832;
  h=message-id:date:subject:from:to:cc:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hUVZTMXGQQd+t32FJ5EOZpkFJIOCADcFFmhSY9os/ac=;
  b=Cj05u/Y+vTJP+uQa+AYBJDuPZLb9XkonV4lvcWb0Bbas/J5SF4MBIvYd
   oYOvxb3OOXVp28VFErnsSrLmfiuktaTcmzzFxqsj2np9ePQfxa2ev2DbJ
   P9MRoBXBDmxs8lOf5jfGrhBbrS/cvEGe6GawbmcwdnictWOISdjzflq+j
   0emTFaATjljUbFRRlBOjs513JvH9y5hipAEOOJJf2slvZZJavchdEsE9T
   cNJL+2jBkRoN2BICejcOHmPc48a0dX+bqKbmg3l0LpF64zON06t937P/8
   4BBgDiEDxUao16KVqUMLxkMU4W/I58k5b5V778eZGvlOPCFqXra1b6Gim
   A==;
X-CSE-ConnectionGUID: 4o9QGvVFThuMD6uKDFeiOw==
X-CSE-MsgGUID: TFfacYfST0KfkNfg/mGsFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="64626426"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="64626426"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 14:17:09 -0700
X-CSE-ConnectionGUID: SUCCKu0fTcyOhqbIe//xyQ==
X-CSE-MsgGUID: TPzTFoLURa2gw0mdl3oDGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="156613975"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 14:17:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 14:17:08 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 14:17:08 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.48)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 14:17:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jbqChOnMW47i+mTy1vKadDo6mnsQCEbFYujsUyulOdkMpP0eSzvEyz4aqMqKmtrRrQK1jiPnyw8AfyoMPWi2fzrkxn/OI5WhKPZf5D423AsKUA+7+L0PUci1GwQj8G/dB0qcyQuE9HkQAtCIK8SWcEP6bRufoPW7HUhiNLNRE4GhrA/M/UwPgQNnzSSSOg4qbxultksdJs8K6CMtnbH1JPlUnfd+fFCZtxOL66BhI3gCm27T+aA8IGaCyO7CutcfvuDJRlGd6mAsMxt9N/V//Q1j8sRZI37BLf+qDW0MWitBeczmH0tS+PkYedCxKnH/m2zB52gfGErFqqhQRao9Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3TwaPBlxUVzlyESfeQWQeCXo1Vx+UNQvI2fsQGWtAM=;
 b=uubemHnsRLc50y+dzZS2XzW77x2emhboRFsim0aZhKheZliO9gh3pyXxPd7KtdvToX8+slkYag8qQ4Rfh3bQajNjO2UaWS7w2ZhaMIgyBlXJW7T/w8O/zev6aEaR61I4XHMUA9b78YDVr/6Ya3VXyHgiQru85E3NX4w0XD9fjSIld6gBKq2PhSyVj26/Mu6wjkhoP2wkj+tx3JC1/ZMc/FN/JvAgDsKFjYwuma2KdrmuO3qtIO/X/07wASI8tJqPPAULF8BYd5VE1vWL29UuiXWV3nSFy9PTFqJyA2Zh0AENTAW/tVCUGySIRlno+eTfzAiyOmE74PCjRbToyXVNWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA0PR11MB7884.namprd11.prod.outlook.com (2603:10b6:208:3dc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.28; Wed, 9 Jul
 2025 21:16:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Wed, 9 Jul 2025
 21:16:51 +0000
Message-ID: <eeaa8d57-93e9-455d-bf5b-e184e0fdbad8@intel.com>
Date: Wed, 9 Jul 2025 14:16:48 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 21/30] x86,fs/resctrl: Add architectural event pointer
From: Reinette Chatre <reinette.chatre@intel.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-22-tony.luck@intel.com>
 <7dbe58c4-7006-4cce-8f5f-16f3a6f6eaad@intel.com>
Content-Language: en-US
In-Reply-To: <7dbe58c4-7006-4cce-8f5f-16f3a6f6eaad@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:303:dc::13) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA0PR11MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: cc211bd3-cf2c-48be-61fd-08ddbf2dec2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?RnFGd0NocG5UcnA2alVQUFNaS29HalMvUTlia3l3ZFh2T0krc0RvR2F0aVVs?=
 =?utf-8?B?bUVuUUk0WnpWbVlvdGJNNTV0Y3lDekxiakRBLzVzdFU3S2xWS2hWOWVQZm1n?=
 =?utf-8?B?ZUg4dDFCOSsza014Qlk4SWFITDNiVkViVHM4cTl3bmlhZVdsVTJrcXdTbnZV?=
 =?utf-8?B?SDkwTFFIQWMydm1UUks3WFVkSTVwODlBRmpNN0UzSmFCVXBTTVE1SFBnS0dI?=
 =?utf-8?B?TkhsWUlqS0hGK1BZUE9uR1VTL2x1MTVTcmp5aVBHOGFVL216bGRaRDNXQlh4?=
 =?utf-8?B?UXZmWlMzWVNTNGs5UlZVcjI2TzVoUkRhb0xwdkdBUHJRQUVTLzJ4NEpvODV3?=
 =?utf-8?B?UXNsNFUrV2ZOdy9zMVE0US92VnhUNVdRdk1TWWpkSmpOTEV0WGhVRUl0cnI4?=
 =?utf-8?B?WXJtRlJRekprd1ZpWDgwQ09CR2Y2WFlVVGFpc2NwNXhCeGQxOXVSMVJDSGZO?=
 =?utf-8?B?Rmd4cmZYSHpnandaam05dGgvTjgvUFFFVlk1U1RubUYzR3R2RVhGaGt6TG0y?=
 =?utf-8?B?N3hNZDF6Vm9xRFprYjcwOVViRWlVcVNUcTBTV0FDWDVEd3ZvcDh6djVQaDRa?=
 =?utf-8?B?WXg3bkJhL2tNcDViWW1tYmFzc3lvVnRiNytGMFhrYU9PSUhiMHNvN0tSZDFP?=
 =?utf-8?B?Z2pseWVuQ291ajNuVEoydEFneXpKRk84dDVJR2RBMnppTDNpdXZPcVFjNUZO?=
 =?utf-8?B?aTNhR1d6elVpcGNhN3Y5UDdDa1hKeCtLVVEwT09GajZXdm93b1A5eEdQUEtp?=
 =?utf-8?B?NHEzaGp4ck9GcEhkamFoenJwUWFTdnpKa3lCb2NyRVlTOW9WWHJ2SUFrR1JS?=
 =?utf-8?B?cjYxc2pXOXZSQnpmL0E4dXlEYXRpV0pZWGdPc2lkNDVrcjByNllzWEQrQy9I?=
 =?utf-8?B?Sy9SRWhiQVFmc2xneURMbnVzK21ZUXdXNzVxR3JCaHJ3WE5sTURleTFIYjRU?=
 =?utf-8?B?T3hmdmNvU3pwME83YksxRkdCV09GT2RKYm5wQUk4YTBiWkw0NWpPZklKamow?=
 =?utf-8?B?bkg5MFFMQlFranByTCtwZFFSWkpBN1V3MXdPb0JpZmVkaUFRSlljQjBUenpx?=
 =?utf-8?B?ZDErZXp4akMwSFk5UVZLaVNHVnBzSGJqdnluTmxFZlVDdjlUMmdoY2h2ZElu?=
 =?utf-8?B?eTBqQ1VQMHMwN1dFR0FIL3Jjd3phRHMxcUtJMXRRemtZTE9DOWFhRnFPUHho?=
 =?utf-8?B?cFZwZjlqQ05OTUMveEJlbTRxa2lTMG1KV29NeFBvSTNGV29TZWZkWHp2K0U0?=
 =?utf-8?B?bVB1ZnNiazJBTjhiRm9hdFBPaFcwUXNLTDhHQmxuYmdjYmtselA4TjBDQVFC?=
 =?utf-8?B?NFQwMmVuQi83K3RKN1MrUmxpRmZId3J2QVBSdGpqSVVIRGZCQmx5alBSOFRS?=
 =?utf-8?B?aFNhY2VtZ3QzamJ4WnFNNHNMcjMrRHg0bzF3Z2svNWxHcEhuazNkb1RuZ2cv?=
 =?utf-8?B?ak11bHdJOGFqVkJjRTk0WGREZEg4WW1BaVpudXM3UjQ5Y0Y0UFNLMjZsOWd2?=
 =?utf-8?B?OTdFRXZ4eUpTQjBJclVGOVZvL2lERFdKbkFtRUQrbUF5b3BsK3pJcWd1cWFE?=
 =?utf-8?B?R0EzRllzcG9qamZURFd5aGRVVE9hVWVJNnAxY2FDUXNRcW0va3RlM0tGQzFP?=
 =?utf-8?B?QVh1M0FVUEJkVStWeUU0Uk9OZFVHZit6dTJ1WURSS2szRkxoU1c4eUphTU9T?=
 =?utf-8?B?L01xSFRQYUdzUUNJMXZKSkpxdmpNVEs2eE0rRWJNeDRaWmxsdDBtYlhKSGxo?=
 =?utf-8?B?WERtbzRMSDVnQm5iUVVVQ1ZRV3JtMG02Q3k1VEs0ekZTUmp4Q2docnhWTUFR?=
 =?utf-8?B?T0F6UFB4WUh6YjdocGc0eW90N0F0S3VVZ1E4cVZKbkJyOG5FVGZqSUNyYmNr?=
 =?utf-8?B?encrNU5wc3dKdUhobW5pZEpJL21VRnFvbHY1RWZCSC8xK0NYMytTdnlkRXNG?=
 =?utf-8?B?YXJrR0lMYkpjZzJkR2NGcnZPV2ZPemg0cnNvRFRraUZPdzlaV0xXSkxJQzBm?=
 =?utf-8?B?SnFyTFBtSUZ3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0NKckpZZTNPbDFaZlE1V0JLZFBqK0xOM2syM2FJN2JDRUY3NUdPZVJnL3lk?=
 =?utf-8?B?bkczb3JRWmtINDNXSTR0MEpRTUJqdWgzRFViM24wcWF6clQxaFFFZmUxSVJi?=
 =?utf-8?B?Skoxek1ZNkdod2ZFRTl1R1R3Qnh4VmIxUU5EVzY5VUFsL1FlNzZXaWlyd1Fs?=
 =?utf-8?B?SldhVkl2UWpKT2c3d0RUODJXZHM4YW9HODR4MEV0RVVuOWo2dXA1UWFDcjFw?=
 =?utf-8?B?NW1GcWtGUExWdEdXVGJ0dTN3eittRnNBSUc2ZWE0VlBwY1kwdERHM0VodzFO?=
 =?utf-8?B?SXBtTm4yUnFtaytXak1FV2F6WjFkbVh2dEhGOE1NM0JRZ1pCdVM3Wit1amZU?=
 =?utf-8?B?R1JoR01vT2tzNFFEQUZkaVFPRm9PV3lubXZQTU9QTGZvdXdDdzlXSHV2RUYx?=
 =?utf-8?B?YXR0RXBrWE9wdE5ZWHRqRnFGb1JIUHdZWThSQWlmK0sxemN6ZHN1T2R3OUJD?=
 =?utf-8?B?T3ZxM0xlcU5IV0tnM0FBVnQ3cFJENFA2ZUVqcnMvaVprK0JydUZMTEFwYUZN?=
 =?utf-8?B?dTVNV29iOEJoMVQ0eGw2ay82QUVmTUJKRnp3NDIxM2U2a2kzYytKaVlqbDMx?=
 =?utf-8?B?QzVPYU5CbkxpaEg2OW9XRTRxcU14eHdxcUlyQ3NkNERyN0pENjM2bFcwTEM2?=
 =?utf-8?B?UlFlRG84QzF6czBvaDlDR3pnWWNVOG9CRWRVL1ZwSFJ4OE9sQ3NzT3FtTHdY?=
 =?utf-8?B?UnpkeXdKOURjd0hLRUxvcXEyVEtOREtacUNGYWJGVy9IMHR4aHBhWmx6cHNQ?=
 =?utf-8?B?djdNVHVPcWwrQXErcTQ3MVZ0TDBrQmVWTjJZYmtRYnNtczJjaGFRZjhPOHRR?=
 =?utf-8?B?NlErWVcxbnNnTGZveXBkRlB2dVFQeGlUKzI3c0M5bXZRa3JuMzdUdkVJNTly?=
 =?utf-8?B?RUEzK3A5V2hRNlFvSVRaK3JYSmI1T1lqeVV0bUZ4ZG1SNU1rVmlLa3pjdU5k?=
 =?utf-8?B?KzZWOXgrdWRUaGJIK0FwRmVKTGhIQTlwYU9wOWNCMDFUQW5QcThhRkdvNStK?=
 =?utf-8?B?RW9xOWRnNU4vQnI2KzVkUThJZUtOQ2tEWVA3dk1XZUZ6YWV0bXhrTzJuRGN1?=
 =?utf-8?B?dVBaM09TNmZXcTN2TEl5dGJMbWZqUWljRmg2aFdwSzVhQVBpMVN3VThtNlI5?=
 =?utf-8?B?ZWYvWjRuSjdKMkE2RUdXNk9yTy9OUENIbGNrVGE5YnYxdkhxbWczMFlRVVRm?=
 =?utf-8?B?RjdIYXFVS1dBeVRrVmR1WU5iSHdibEV2dS8wWkh3aVhpNERTMjliRlZZalcr?=
 =?utf-8?B?cmdFNUdmdGJreVFTZTJ1WERzZkRkaFJDQ0ZHQjBqK2tNb0hmRy82NmxKMUVp?=
 =?utf-8?B?dGRSOWQ5NnFKTlNvNVVVVkM2UUx4aTYxODFhdWlKby9QbDZmNWRqN1ErVis5?=
 =?utf-8?B?dDZNSnhrYk9salREcmJyU3ZtQzhtV2UwTDVDazJiczZONGc1WnBvVWdHb3Na?=
 =?utf-8?B?SmhoUndYbDFhNkM2Y0JiZXhmM1dvaittT3dkZW8vNFExUFkwNVEwRzZZUlJj?=
 =?utf-8?B?RXp0bUo3bkJ4MXFscGpqamJ1YU52d09obXBMRTRycklTZlFVMy9QTCtweGZq?=
 =?utf-8?B?TmFpU0IzMkxyZkdLNnpwYkxMbmFRUHZ0MkczQTZzM29UWG4vYmlYdFc5NU5Q?=
 =?utf-8?B?VWxQbktkZThWbU5XTkNpcjNPQXRXZ0lFWS9SMkJ6ZjZMZ05FcG10QkpOemht?=
 =?utf-8?B?dmIyZXJVeEgvZzlDR095VFo4UzRFcWZrbCtPbFNaNFhqbHAydEZRVytJam5L?=
 =?utf-8?B?U3dxcHJHMGJQcExmb0V1TldldnZjNyswN0I3SjcrVVcwS3pNd0FZc3ZVUi9E?=
 =?utf-8?B?UGYxbXg4cFhjN0VSN3ZYK1hQcmg0emt5Y2o3cUFoUUNUWEc4RnpMYWdnVkxm?=
 =?utf-8?B?RVZINXVGYzJYY0NnMS9rN3E3VU5NR3V2MFpXdVhlak5haGJSUmEzUExPRFBV?=
 =?utf-8?B?NTZ4dXcybSt6WGhrcGM4a3oxMks0WXhRZ2l1WE8xd05jdXlNVnZiTU8raEc0?=
 =?utf-8?B?V1BJSDBZbTBTYzdValprOU16dWVTVzlWaGxwSTM4S0VEL3J0MjJGOWsyUDA5?=
 =?utf-8?B?aExmci9ibHhISURyQi95KzRsK3JWR1FEVlhKeEJ6ci9PYXAzM1oxb3hHSmpz?=
 =?utf-8?B?RlZDdlByaUpCbWRKK243SHIxRTRPYTZ1cmVscVg4a0NXVlppQ2tqL2pSMHhw?=
 =?utf-8?B?cUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cc211bd3-cf2c-48be-61fd-08ddbf2dec2a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 21:16:51.6430
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7Fu6VgUrbsGMsjOShsuNl1nM5jaYD9RxIWFJS4R2EviEWk9iBBGqqsPzyNbfPnyaGB51MDCZrgtSE3+UJ+guLgcLKa1RqbDpqQ6MlSpZVVU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7884
X-OriginatorOrg: intel.com

Hi Tony,

On 7/8/25 8:21 PM, Reinette Chatre wrote:
> On 6/26/25 9:49 AM, Tony Luck wrote:
>> diff --git a/fs/resctrl/internal.h b/fs/resctrl/internal.h
>> index 53ced959a27d..2126006075f3 100644
>> --- a/fs/resctrl/internal.h
>> +++ b/fs/resctrl/internal.h
>> @@ -71,6 +71,7 @@ struct mon_evt {
>>  	bool			is_floating_point;
>>  	int			binary_bits;
>>  	bool			enabled;
>> +	void			*arch_priv;
>>  };

Missed this earlier, please make associated change 
to kernel-doc. Please include kernel-doc check in your
patch preparation:
 ./scripts/kernel-doc -v -none <files>

Reinette
