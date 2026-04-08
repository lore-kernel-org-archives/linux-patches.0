Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD9338CFF4
	for <patches@lists.linux.dev>; Wed,  8 Apr 2026 16:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775666263; cv=fail; b=OxZL75p+08oD3lK5U8xMCArpVEZN/mdUi/KcFMQLdBlHSGBdDJkY2meUDejun2csZfo45v7HkVFtPu+pWMqrSA0oUTihs2GjX0Mgi6Lz3I50HMHafK3utG6Ugb0Tb3wskTpJq+L9aO8NpLLhT9ubPhd6HTx8cxwrUsgdjm/UlTA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775666263; c=relaxed/simple;
	bh=q52XEDJsor+lIk2izYu3wBBmqFnaWuzYjFR8fJgv5vM=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Z1iFCGSxn7Akn1QkMY3zLKBuRSBoXsul/PSwKttO9q+uR+rTCK42pEXt4VjzHjxCPlHbFd0XuUz9dDYvb4nkjCzbyqlryEj0rKouYBE6+kTFM3azZrA1u18pJMTcAXBNE0VmORgiLmpP/gvIaohxBlG6v3R3IJBMNgl2g7XZYVw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NuLDDCF/; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NuLDDCF/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775666261; x=1807202261;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=q52XEDJsor+lIk2izYu3wBBmqFnaWuzYjFR8fJgv5vM=;
  b=NuLDDCF/bvInEkZbP9KCijxmGXtCAS6xzdxbCmfhXcb/M640abAlVlcn
   S4p41G+gu2tM0t9xpHQnfRSSZktVFWfKgi7Lnyk9YlygwTl3HMWoU+Kbg
   FyoE4HHUmD1ftXOQ0tqiaZjqApG/IbEe8+z0ExZAy8bDdyEaRpNCIzh4u
   8j0u+7MuKS7dXq0X28VhR8hqSytQJCVCH5MvSmYUSs+E4zgnFUGV4ueeB
   cEG7n3htxGPZL+IEo3sKgysajxfbTXQMTFr9qhGy6G4gbzEphYEsXQZYh
   ZTOXlAdtfpRFa3QpGtmMOA8CRt4epO5a52/bZCnXOavfYVqRzxE00JCCt
   A==;
X-CSE-ConnectionGUID: R/rvSi6USgKAe7naGcbf7A==
X-CSE-MsgGUID: a4A3DyzsRnmNOl4j01OHew==
X-IronPort-AV: E=McAfee;i="6800,10657,11753"; a="79245928"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="79245928"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 09:37:41 -0700
X-CSE-ConnectionGUID: kLPyqZbURYqChUOqnhHjGw==
X-CSE-MsgGUID: I4tYYfH9RCSHpPsbYzQChg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="225740506"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 09:37:40 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 09:37:40 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 8 Apr 2026 09:37:40 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.23) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 09:37:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N6rouQROUPiV8hxuAHPI0VlJcJ8MKezOnXBgIgA8hf8yVtwDk9h0n8qyXyOEXfMLreBYp6iqch09pYHJzg34quZ3DwoI5uZz+j9qmGCeIOF+xCCc8pWIvq+2TF1+k/hXHTkGNuuHe3BDfffDlKJztPtm45czM4EglZ8iemOeptNUF1ElhivyFusLnX8r4x2caeKMP4H5KSZLbGYhSSvQAlEHClfmzsbIa1QCOmYoO6fcfGYQLZ/GUIaocxwKRi7+4wvMK8TsiUuSKpKfpl5EQzdnpFjNH+2xfmJHVm0twwL1CqXIGjjJX+qyB8mJWUJbl2Mb4PqDLnMLRWcJNdjtKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/lySbsUFtXoiUwaWkey21K8/0SiMu6jmQoLoAKCt/AI=;
 b=Shra2sIHIcr25ffZqj++S7SfST5n4wiWVn/mKN9wb8ODO2IscXI7EQqPtXWLEKE6p+JkKPsmdTMJQJqbUK2Y+drsBstGDFWrMuzQGpXUR4epllmJ8hThx0ffeghMcp25aIhTv0ydgMLtVLOPXcL67NcPYoJr9YQad1hUvgg+wdlmWDDBByo3jZNEzfDkW1gT+z6+oQzt2fwBV9g907NXFUVKcfh1IiFrey52Owr0xki1eIOr/kdXlEt/KC41m6Bre/Pi1VqdemmiXUUr1Zzz2gi8ppWVBHYt4tknFjZlFSLhQAZsiWSIYLHpsykVqe/NTmsguvryrbLVOXcOKibpQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA1PR11MB6757.namprd11.prod.outlook.com (2603:10b6:806:25c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.16; Wed, 8 Apr
 2026 16:37:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Wed, 8 Apr 2026
 16:37:33 +0000
Message-ID: <70687d1d-a373-4196-b59b-ef7baf337942@intel.com>
Date: Wed, 8 Apr 2026 09:37:31 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/13] x86/resctrl: Protect against bad shift
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1775576382.git.reinette.chatre@intel.com>
 <280c162f8b935d6c755027aa382d55e84ba31116.1775576382.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <280c162f8b935d6c755027aa382d55e84ba31116.1775576382.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0144.namprd04.prod.outlook.com
 (2603:10b6:303:84::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA1PR11MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: b190a378-3114-4bb6-f8af-08de958d2245
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|56012099003|18002099003;
X-Microsoft-Antispam-Message-Info: HDiJBY7kf0bJpgqR90XaDmvqZA9qu625HHVDZfrDBzJeCQGfw3yVoO8Z7r8xq/vOhLnNcEopRqu1KyrVG4t2yWf11NaDuyV630jyfEspaWdiT2WaEFutBQJP9VXf9P29w/2lw8J+5QJQPrtFw0hcM94NQKBM3rzq7Uvj6BaQQ5P7x6bZLUzqlFZKcVWCDZ//xLDBpYQAqrmRJmuq/y7B6T9CBlJAzQTjP2+GQmTFX7aBoud4HLpatV7PQeZvFbdO+TFQ8qyXp0IBPoI1pVB7xvLDBfbwAhY8qFKAlcP1bPB5nl1BHk5cVf6E16R2PoVAHHW0ifx2Xd2pU/ry4tU3BRiTRknGzEcx5ne6TYziNOqbP6nZPpcKToOSBNGHuZeJHHSN+dMri/fRMol/ODnvz8kTAAfDrq/SKLYS88uuMqvQy+cIjur08QRwnuo45edjwKAfd8kp3dkzxMhawyIM8Thqvs8SOLqMEF3Uj0qtcmzDn9mMCM+YKH8Jop3wokbEDGoK1meRHKSv/Hdk6e3JvA1hXMIZXxLVixFhG2kRctf8BYqGq6u/6ewXafIw1tBZr6+eglqnisGcphp41J74Afe8Jtypl3USCQ5fgbIx3bU98HIL15D2SOBzJdqNppWB1BDcvvL+SQBZ6km0UvGdycLhiF67Dik8Hf9hNPlSFRYPoItC1myatFBLIERYQZUF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(56012099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEdJbUx4WmxmbURSTG05ajlTMHBRY3FnMjk4RW9YSzlBanFVeVRPMy9OOE5P?=
 =?utf-8?B?YXpxSkovVUx2L1NzMmluVlMrL2M4VmNIZmN0SHZIcENPZVpWSFI5SXBKZk9p?=
 =?utf-8?B?dWpsWGVVUlNQYUxjaGk4YzNLdmxCVGs4b0VQMFBya0xCQVNCTlZ2TE1jaDcw?=
 =?utf-8?B?QXNDbC90endrdWNaMkF0dmN1WXRvNTFVNzlOY0dXYzdkVW53V3hyY3ZRU0dz?=
 =?utf-8?B?d3hSc1FleGhXNFRsck1xamVLTXA5U1o1ZlAxS0tPUEpqNE5TN1Z0QW9CSkxy?=
 =?utf-8?B?NyttUmg3MmpGR2VsdEd5VGhyem5QK2ZmcFdGUVJRbXM0K1l2dy9EcE5XNWJt?=
 =?utf-8?B?SG4xMmdST01HRy9aV2diRkdOdXVKZ1RBNC9YSFdESnZsOTNrYWphODlBSnRv?=
 =?utf-8?B?ZkFrS0ZlMVYzUGx6SFJ1OEgzZjUrZ2FhQzlVWDl2VnpFczhzdUNxS0xWV1dS?=
 =?utf-8?B?TFZQYlI2TEgxME5TdjN0MFFuTTRkTzFJcG1LV1lieFRmSU1kdUptUzhkMzlX?=
 =?utf-8?B?SEFJcjZ4aS83TWR0QkVXU2hjWmVRVmNObXZrcDdONEIvZzdESDAyajkrR3dH?=
 =?utf-8?B?SEZtSFRxVVF1QzBvMVEvVTB0SkhTQjlDRjJlanQrODl5Yi9pSHF1MllpY01G?=
 =?utf-8?B?NDlmRERNbkpTYWt3a3pGblBFUUcwMm5MUVE1b1lQSHIwRE9WUGVNbkhXQWNp?=
 =?utf-8?B?c3h0dmpRTExBbXltNGRQZFlUY2RRZU5Jc3FqeUMyVzN2eUwrNGZndWpxVERp?=
 =?utf-8?B?SzZ1Y3NqNWN4bDZKZEpRR0lIZlF2dWRBTENOOFdEZ3NoS0lmZkhPNWNYQldK?=
 =?utf-8?B?MndQenpxQ1lhbm9ld2RTWDBVa3F2VHRiZ1orOEJmTnkrU3NkT1lJNnRxN1ow?=
 =?utf-8?B?UDlaSThHRmFWNDBrTFhjRURac0xDaFhGMTJYbzlGNzU0Y3BMWXRXKzJ0Wmpt?=
 =?utf-8?B?NVM5SHZVQXNFbWYrTWNoQkMxT1pFZkVBL29saW9WcjJPYlNib09iam9Wc3Za?=
 =?utf-8?B?U0xSTXNtTmhuSjV6QUZORGNmb0g3aTQ3azZNeUNoSVNUeklHNkU4akszbmFV?=
 =?utf-8?B?QVRQM3Y5bmFiQWlyMm5nUkVjRFBNTlJUSVo1QmtEb092MGM1a0Q0T3FKdEpI?=
 =?utf-8?B?WXdqeW1DK0xmdHBPT0FZOWdDcGRQQzN0ZkRnR1dUTW4vZG10dUNzYS9WN1R2?=
 =?utf-8?B?Y0lwWFJPbUtwcTdRQzJEQk5VVEpVaWNGSTYxL2ZzVHh6ZVNmbkRpbENSdU9O?=
 =?utf-8?B?azhjcytBdW1zcUZhY3orV01ENW5FaU10TXQ0MlpTd2JuQ0tUSGxISGVGbTEw?=
 =?utf-8?B?UkZjbk15SzFKOVAyUmlXaEJUcFVTVElIWEdDOUpKdVpnOHhLUThMSFJkdjlh?=
 =?utf-8?B?WnovWHVXcWNoc0hkOXdJbEVYU21BckVEdHQwa0g3ZU93UUYrVGtGNXl1Z0lG?=
 =?utf-8?B?eXJKTVU1endwVHhnZ2p0TTRNdlZ3T2crLzBvUHZpWHl1RTRoU3ZxM2dmT0Vp?=
 =?utf-8?B?cm1QVGkvemVYdXFxVWR3bXVIWGtMcnJ4S1BHMGFVbkFxSmVONWNWbzdKcUlQ?=
 =?utf-8?B?WDVIcW1BT3c2ZkRQK0NyaHR4d2pXUE82bHpwZ0EveklLZFRjZ05YWFE0bHZs?=
 =?utf-8?B?aTl5T0gva3JVS3JtUlVkTUM2amVLYWtoSnY1MVpZVUFkVGFoZnVuaWdaM3dT?=
 =?utf-8?B?WUVJZmtGREN1cEsxdDNraFFWNisrNlRQNGRiMjF0bzYrL2JsbHY3K050UEFv?=
 =?utf-8?B?SURqRHNKaFdNaEp3V2xFd3g4LzAxazZSakRiTGdhQm5pQXpOKy9Gam9EM3pS?=
 =?utf-8?B?YUx5T1AwOVRoS25wUDdqb0EzdDd4QmxFZmJLOUZtcmo5QjFKQ1lOc1MxMlZX?=
 =?utf-8?B?RDVhOVNVNTN4eWk0dkNweU9jQ05BOFZuMmVQTFpmU0x5MStPSndEUExVT1NU?=
 =?utf-8?B?RzhZUlZoSzl5UEZ1c3VPY1Jlems1bWI5b0kvaWwwdlRqeEo5YmJWWnVoUVNx?=
 =?utf-8?B?ZUR4KzRsV2JEem9tOWZGQk1MTjhRMUJjd0xrNC9LOGlacGRFdzMxMWlBN0VP?=
 =?utf-8?B?M2Fnc2RtR0I4OVBYdkN1ZjRLVEZsNE1FRU5sM3FmT3JaQmRaSzd4bkJBTFBB?=
 =?utf-8?B?T0dTSy8yWVdPVDhaL2tLaWJlNldrV1dBYmtMTkF2WE5ENWwwcHMveWVnUU5r?=
 =?utf-8?B?ZDR0KzRKWnFsdFJMaE5uV1o2NkxaT29pOEpBSitnMDZ4UnppOHlPNGU2NVVk?=
 =?utf-8?B?bzNQQmhEZk9oNWZacDFJVGFpQ09sNlhHRlBNK3hqK21NWDdZWCs4WFBJb296?=
 =?utf-8?B?TkZYcGYzMUQ3bkkrYTkvamF4VlFNcU96WWh2djAwWis1d3RpYzFDZWpqTTQx?=
 =?utf-8?Q?7pNcM/5o8TPYIRig=3D?=
X-Exchange-RoutingPolicyChecked: JEqI4+YbIQndcn4jTzFn7vjD4/u5bdBkQSV9ruOAAzOojoFEnFQ7s8sK7l5wfWOuBljQTvKkij5u1JBkfXREApO3lvTE9QSwEmjGfqjoY+4PdXs7SZdgCqBuEPkYynz7MU1K+1hoB7i2wBfgZ3YWxedLvOwLGGEMYv5TRFfxQKwf4yK9x/XF/nDotR5PA2+sPQHVLlFhd0uiPGnsmXE7Z1As9a6hdh7xs9lwAf1lmckyUahYQupnUit4sHTlKOWAxK5LdAwvt3/c3uvmTZpZyYlqbZCxFMLiR0JhlItmWwhmM1kb4jq8agOcCmLjHN4YWBwdGW17VER75FRwQlICmw==
X-MS-Exchange-CrossTenant-Network-Message-Id: b190a378-3114-4bb6-f8af-08de958d2245
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2026 16:37:33.3188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SUh4f26N6SNlwYeQ9fUO9DiHYmQpywy80YAtxB2Wd7WaFTsudRurCGm8whrdDvF0bMK1r1fcWjC4OkYyceI1BHPR3RQ+4GZmCAhJc1wKI6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6757
X-OriginatorOrg: intel.com



On 4/7/26 9:02 AM, Reinette Chatre wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index 7667cf7c4e94..db787c4dee61 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -246,7 +246,9 @@ static __init bool __rdt_get_mem_config_amd(struct rdt_resource *r)
>  
>  	cpuid_count(0x80000020, subleaf, &eax, &ebx, &ecx, &edx);
>  	hw_res->num_closid = edx + 1;
> -	r->membw.max_bw = 1 << eax;
> +	if (WARN_ON(BITS_PER_TYPE(r->membw.max_bw) <= eax))

sashiko [1] reminded me about not using WARN_ON().
I'll switch this to pr_warn(). 

> +		return false;
> +	r->membw.max_bw = BIT(eax);
>  

Reinette

[1] https://sashiko.dev/#/patchset/cover.1775576382.git.reinette.chatre%40intel.com




