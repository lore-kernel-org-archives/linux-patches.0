Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7C87DA66
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 00:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775261048; cv=fail; b=eyIZd0PvzJ4x4niJxshHFMNdDC/5Dfoi6Rqo1f/toNyhfPxk3gSd5AxwTFC08zdFxBOvpVT6RL/BfOkXps92/ilKVKHPnpRGAXd4Eqi0IANwEBfRwrJ+DHxRf6Wgsuxt9fDQF6E/HvSAgqNhwU+gqiqzmvuJmeZyWmak/SXc3l0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775261048; c=relaxed/simple;
	bh=UHZbI1CPW2RQTQS4Z9FGOZLBP/X2f7tjaDFrfwkMY50=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mpvla87y5pbe9BqLzbEakZhQMh2XPyaAQWPX++iDHSb5+Us3f9aqkVBPBNe1354ebKFFYDUgwUlWkE6w2XF7WkvsYYPJj4FSc7c40GZwTas1WzDCYgKkJuAjsGJhDv742a3O/jnus0sk5eXwqG0nFbW0wmwjsimKVZmoGHbfcxc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnCVB/k6; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnCVB/k6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775261046; x=1806797046;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UHZbI1CPW2RQTQS4Z9FGOZLBP/X2f7tjaDFrfwkMY50=;
  b=HnCVB/k6tKA3jwrWmw5EjQt2YglH3n1nSIPXtd7meMRMGYBN+DGISQWd
   elER67nHadd//ms3G+KnXNhVWqR55HmtbjY8UXCubxl/soUqBzv64U8WH
   moKVM7nrHMasfdrEHwTMRIowDdUS5Ot2OiYm+r10WGcnb01iC292Sl6I2
   b6J/dWM+KtTqMMhIaH/d3Vo44/gBR3w7Qe+qUj1axJRMi6RiDe+iWjLud
   wUskgSXZqnehpD5O943U5rbkACHQBv7+IRXcPkxxTeP88BnOg8IyHxrur
   Me/GHAee1emxPOwpjiWaGKW6LW/7abYVfxFpFXI+O2g26lnNaiCwgjEYF
   A==;
X-CSE-ConnectionGUID: R+FqxbGhQI2AzL0EesG0zw==
X-CSE-MsgGUID: rHvbDTIZRVqD0EQJHmxi8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="87774752"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="87774752"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:03:42 -0700
X-CSE-ConnectionGUID: 5VRuoB1jQGCC1nFeEBGoLw==
X-CSE-MsgGUID: vLbekgFMSK2rXTH9W0DHug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="257844175"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 17:03:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:03:41 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 17:03:41 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.33) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 17:03:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F+9ksThrXuva+GVHAvmUI7vkrjRs/m531VcAuPVr61pBwmW+RmxQc7U3wEGXlj0PcJ43fi8EAUI786ENTjMgCD8mcO5Tjij5V3NhQEgVD0YXW/Dqpr/g7WVEDTmurv9SYVO8ZxAdr5Sym0mZZ4rDwIHojuQ/7nTI3VPtbn5kcgUW+iN4ZvcEMbXEFtbeAbb05TIo+SbejBc0EL1Sscpd7JXE5qx1paWgG2A/+8xy5xaLZKGGLE6O1eiE2rdvmeiA+492yN1duUz1/tgwjWoBwn3htB55GLu0siPLIlRnfgBFB3aD+iRHwhLRTgQufl7K+sDQsd2/G9Wq0VfV/bR4Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sMWKRORLtjA7dSLPTRR0Jtz0pRwEHq7SeXhLadQvfSA=;
 b=JfE6U5+kySviQ1L5texZJJ7jAFEjYmvwmPhEzc+FjJzbqPmVJ0hv8cIdSLVg94UVAAB5iEtj3LPXvjqjxGM6xoIwnT4gtYYKdU4j3cHuOMUQGC2lCV0Q//Be3vHasINGEweIATv3Z81pbziydTjJP6XewdhuE8uyjuQqoA77N/69iM85fYblsIJyg+5C3597Yey3uCYvbfCPrM+h/CQwO5qKdLvjWEM0FCcmmE6IYvOpGvXvNT7U5Int59cmVBroB82zqF7NqA2cFuPQ5Q3wpmACY/GtXq18xAy2mk4Q7dts1HeZ/YSys+kKNXdW1OXmSRiBPZ8vlAjrp6dXQk5S3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.19; Sat, 4 Apr
 2026 00:03:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Sat, 4 Apr 2026
 00:03:30 +0000
Message-ID: <7fe71e6c-e447-4aac-aac8-30941e755209@intel.com>
Date: Fri, 3 Apr 2026 17:03:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/7] fs/resctrl: Add interface to disable a monitor
 event
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-4-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260330214322.96686-4-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0137.namprd04.prod.outlook.com
 (2603:10b6:303:84::22) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4952:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aec3367-7629-4c4c-c6ad-08de91dd9ab8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|921020|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: 0ZacJPYaS91SEABjrl503m3sJa6R3Cw9NHjYOuKdYoDXivFONQJzYWeV2yFKOkeEFz9/v8dYMJIIBuqIjRWMy/FHjgi+NrWT15jZQlLX7ngIBGbZJFiM4Ncw1fFpl/15aZrhg8YnS4tgtG5N0ze2z4moKsU8vMAq7Jl2D+tue1YKiARq1PUBVGPsuQO3YgNtAfVahEJb3Bm9Bn2cPVmc62IwQ/umJdKTDWyTnTIGWrFMnKC7GxktjLJ9dgavV/A2n3ZjYENQNu0Q+P2cTjH6M0gcKOumJkMOrk1Nup/ChsjJenRZz4Swhscvtxy5opyFPPJIPZigbDZAPHHKVlr0Uk/b8B0kbryjPFGTFflkTNsohdrMtgsFd+jLXAEB6I0PS2fv5LzxnVWLEiRpnN2EixIGe8bJOQQiJAkVCDaSOtBhrUtYuCaUK5XOKWU2uHrUZZmKPWz3LKmxP9j7qLGUkTWg32RIA6t4Vk9/17KjYRkGKrz9OKFAkJvZZez3cEXcoPnbhTS0fdpEfdbpCQ6nzm+ClEGdIMwY/7rb2IT77ppzKZTIVAM/J0X2w2RVWHPn6bSia+u/Rzxe+pMKqI8JcipsdgZQyDr/tHXMC2jK8VWj0wh1PG2hQpqn53rc+eh3jwh6ds9wAP7uBY1TH3tbmdcgZcVGy8MlZM7fQn7ZiWKBFmtb8bG28BhaFesDd8ZL+0Y1fWcxUyZvD3U5mgat7ENT8xs0K3P5/BO1MbO1h8LCU1aHhO+RTH6WUU5ig148l4/Rrzn0uWrmPvcDRBgL8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(921020)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1pIaHVBUWhJT21vcksxMy9SbVFPYzkweXF4L0xoalFBa3ZRWEU0OW81Y3hB?=
 =?utf-8?B?cmU0c09kWkw3a0xnYVV2cmFTaGJPSUxJRTJ2TzF2RmVMbytjNG9WVWw3Mkwz?=
 =?utf-8?B?b3p4cGFMaEhRQmdlMUd0aCtlN3hxZnJBcmhwdzY4U1QyMGRFZCttN3g5QjVY?=
 =?utf-8?B?SXhuSWhlT1VUc0tVSTF1Z2NtYTRmUXViOE1Vb2R6Tjh0WWhrQkJYZnVESHky?=
 =?utf-8?B?cEx1eFlEK3BSUjFDMzJDVmhlei9WNFdJcDhudWZpdzlJaUFPZFQwS0lmMDNV?=
 =?utf-8?B?aVFlSXQzSWFHam5LZ0lTODU5aytDanp0YjhPbzVFOElsNkxab3A2UjU3WXhJ?=
 =?utf-8?B?cVZWeHAvUXBQR3pRYXkvYTBsL2ZXc3U2M2JhL1dqZy9JYjdKcFdwRGd2UVZU?=
 =?utf-8?B?Vm9VT09ZcTRiVVhNVEkveG5Vc3RxRWxRaUExUHJWclFFQlRGcU9FQmFEQVlU?=
 =?utf-8?B?RHE5dFJzY2tBcWNSNml2djdDOURSUExEbytDSmR0ZkJCUkdiMVBjRWNQajlN?=
 =?utf-8?B?dE9WZkJBU1Ixei9LdUtkSEtqMVpUUFdsMmgxbW1HU2lIdkZWVDFJNEdHbWtD?=
 =?utf-8?B?SUpjQ3pTcEJCS2tNeHFaVFE4eU5FZHhUajF2eEhWL0d5UGxGL2JGM1ZjaGJr?=
 =?utf-8?B?SDdsN0N0VVRKNHVzWGR1L1NJNzdSNFJPbjQ5S0I4TDQvNVd3RGV0aVZ0Sy9L?=
 =?utf-8?B?bk5nRmkzWkV0NU1wOUd3b0xvaVpvZW8zZEh0YjhGU21WVnZZZm1sM0NhR3l3?=
 =?utf-8?B?KzI1QkwvajlFcmNwazVHUWVkc3JSV1IvdmV3eVlwa2NYUE5hU3RqZHZrd0k5?=
 =?utf-8?B?aktlaUVmK09VbXZKcDhSOSt5UGtVNysyd2RYRVBpRzREeDRhR01LL2g5dncr?=
 =?utf-8?B?akk1VVp4S2dhU002eWpQdXp1K2dGS05QNjYxMTBLc1ZQdU1vNEQ2ejlDeVZm?=
 =?utf-8?B?NFA1NStNb2s0Nnk2MlVPN3dJdnltT3JYZXB1QnNSUTlpaDBGTm42U1I5OEls?=
 =?utf-8?B?TEFCcm9GVis2N1BpUy9zcDFCeldKeUFjeThpQTYwcUluZXJMU09pcXlPbXBs?=
 =?utf-8?B?QlhlbE92anhIeFZTU0ZBcUFER25PK3YwVDBUU011YXRNcjBVNGNDTXJHSVZi?=
 =?utf-8?B?VXp4V0RVRU11YzRvZzNkYVhVajl6bkdoRThQcmlJUEQ3eHU1Zk8razdRRmlw?=
 =?utf-8?B?UzNDQ3dVWnl5d3pkNFVBeE91ZjBHczgxUnhwQU5KM21aY3hMYWZ6MFFSSHox?=
 =?utf-8?B?STBmYUZmNzJ3UVVrNFY5L0VLLzdoM01PSmZLQVpZRTAxYm1CSTYxVjRleG5n?=
 =?utf-8?B?TlZQTHpjLzlHaFB4OGlFdlNuMjZ2WUNWbTFsUUVEdHRacjEvT2NmWjY3MXho?=
 =?utf-8?B?cXNsdUtnd3JFOURtNEJpVVJXdnc5dnRick5TZ3VaMGQ3Tmc1STBWUGVjeFpZ?=
 =?utf-8?B?ZFZSMzdlZWJNalpKYzIzakFjN1RTUlFzVFNjbEV6ZmpPcUg4UWYwZXFYZGs0?=
 =?utf-8?B?cGdCVWZlOEVLL0k1SStvUSswcm1zKzNWS0RTc2RZT2FQVjRkbjgrS0tDSVJ4?=
 =?utf-8?B?TGo0a0dvbWVwQ3p6S1pHbGg1bmhublNRdFQraThmcFJqK05kc0tWeFJaeXgy?=
 =?utf-8?B?SnhaRUFwcVdRU1F2SDIxTURiSHVBdzIyc2VVcWdGcWJPQUFmazhtWTl2RHNW?=
 =?utf-8?B?SldwbFhZQ2RaU0VpeDd4ZWlKV2pTWSs2bVRvZmtEZjk3Yjcrd09pczhSNmZs?=
 =?utf-8?B?aXloaExLN2dmRG9SU3pWYlBOb0YxRWpxT1hsM3NLWmY0ZFBXYmxPS2toalFp?=
 =?utf-8?B?NnY1czlsT29Ici9jM1ZDc3hXTVJYYXY0ckdVeHRNYmRxbEUvdUExOExBWU54?=
 =?utf-8?B?OXFtdlFWTU1sTjh5Ly9kNlF3RGlYbnduclRSRlF3bnJYSkVXa2poLzVTWTFp?=
 =?utf-8?B?K2pveWE0Vk9TMnp1SUtKMFE1a0h3anpqTno0VlFoMHcyOHJKK1hNSVdPNmQy?=
 =?utf-8?B?NDR4ZTNteXZBZWV2bE5qM2w0TDJNaFBVdjRBZW1rcWs4UDYxZ1E2QWVCbjJh?=
 =?utf-8?B?R0g4M2FQcnQzYmhyeU42eXFCTjlkWndUSHBRSUJEMnlvKzN0WEZITy8waDhy?=
 =?utf-8?B?NWhmMnZGSk8yUkt4bC9aTCtxdGpVVmp4dk52R0RmdmdUSkg2eCtyMVdFTzND?=
 =?utf-8?B?WElzOUdmaUJtWW8weWtzOGtjVUR3Rm9oSURhN1REVmtFR0lvWldpcys1cE9y?=
 =?utf-8?B?bmpuTjNOSGdTMVpCVUh1QmphbzZhbTEwMWVVVlJEdjZJQzNScVhCTy92RjQx?=
 =?utf-8?B?WDZqcTlYTW12ZDhKL3ZkUi80T0VnS0NPbmg4Ny83UWxxVTAxVW00QlZ0MDBk?=
 =?utf-8?Q?Kk0bFIyVVV8hFQ0Y=3D?=
X-Exchange-RoutingPolicyChecked: Mi72i8h5wBQGqSaV6OkSSJx4VeHhekn4eP6DIne53eWcHnei5nyDusjDnXa30XLuu6nddRcTi9jgKj41wH6oJd4jOZYNaIcj1mcrYgsPVfOwl8fVIk+slcs1t7NspWnan/vswDqAd7Mf9IiMKtzwI2FTK70et6EIG6qRLVzuOLvfjCNY0pGtQ28HsZJPLSt9GQm59H0Z1bBDa5nDB1nSSI2Dq6yNQRlHChHy6F+Nz9nPjhWbFaN/kaL9BzzW4tNSSiFjaJxdizAlq7Db+W54Nl2FMLBvZFd8L1k2MptGM5naFF+XpnBe7XzIxjrV1kdsNBsZHr/CrJdU9298A4zSfw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aec3367-7629-4c4c-c6ad-08de91dd9ab8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2026 00:03:30.4060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CBOkFPGPhSWNnOpzMAD5swlnZoTnp3MRHzRcXpTOw1xYDjfpwqc7tDUe1vIlNbohpzjgJjD5aPo6ZBNjR9/p2TYm+7dQ7zg6cXwJJwdWGNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4952
X-OriginatorOrg: intel.com

Hi Tony,

On 3/30/26 2:43 PM, Tony Luck wrote:
> Architecture code can ask file system code to enable events. But there
> is no way to clean up and disable events.

Missing why it is required to disable events.

> 
> Add resctrl_disable_mon_event().

(can be seen from patch)

> Adding/removing events is only
> possible when the file system is not mounted. Add a WARN_ON() to

While this is accurate that it should not be possible to enable/disable
events while resctrl is mounted, this is *not* the *only* time when it
should not be possible. Here it is unfortunately not straight forward
since only some events require per-domain state which requires the event
to be enabled before any domain comes online, potentially very early in
initialization.

To me the addition of this warning adds false security.

Also, consider that resctrl_mounted is protected by rdtgroup_mutex and
this addition gives architecture code free access without any protection.

To do this right resctrl may need to add more state to an event but how
that may look is unclear since an architecture may require per-domain
architectural state for an event while resctrl fs needs none. At this
time these scenarios may just fall into the "architecture must do the
right thing" category since it has best information on how state is
managed for the events as they are enabled/disabled.

Reinette

