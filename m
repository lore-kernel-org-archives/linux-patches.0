Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEF237998B
	for <patches@lists.linux.dev>; Mon, 16 Mar 2026 22:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773700192; cv=fail; b=bZrCLrsDdV9TumWJyUv+l6y+1PuX5i8KYblz4k6bQGN8hap6GZfI+h9cIeV8xuRVHKCqepmOcY+8a3cPm5a3ZKh+5x/kGSKyEOUddtnzT6qYR0QWNSgDfRmYXc0IlVfPBFbBzhPbU4EAtJ2m76MZh2sygSjlQ0dcQzwl636oVdU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773700192; c=relaxed/simple;
	bh=CsfeX+4kOFFBqONALVPs0RTQaV08IERD0Ff1LuEh3OY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MNFzFzRdAUD7u8zG4lSmkpleS+TZUn0oTgQMpAKdCdWQkKt5cqMBSOjpNGpNFMwDXF7M2VD2jFvYHqYWq+AZWkZpsfiQq6IDsJRcIa54BAP1d2MHj5gzoqZadIy7+yfUvq70uLB1hPhT4SRILAna/K/YVIu1LQ9XHZXT7V78mY0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P59Eo4MD; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P59Eo4MD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773700189; x=1805236189;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CsfeX+4kOFFBqONALVPs0RTQaV08IERD0Ff1LuEh3OY=;
  b=P59Eo4MD2qmj63V/tkbM4lxpxacWJvLgqTW0z8sckKD6QJ9ibhtDchWF
   r2yz0QtSo0mPnqWCG1Hj9ArHOH66Leb/gYdVxHGb60UGEaDGcw6jbMzVc
   OaimZGu3oPI8Wc8UWU2QxuwcjUz+2WmK8JK8HPGiN4qFWbHwmCSFKYhWe
   q7zcl1fbatlDFWMwWLeD6gqlz6RHk/jHCeOzz2CuvZzX71ERqEa98WYfG
   lKa4vqkNfvTwbobOND1o171wzPsQS8Xrd5S80AXwV5e+P6ue7DVXp1OI0
   IcqT68QEYF9c37mJJ7Q5pvcvbzjBJhQtuk0hA0HOD2ORxw2oz/JlcGCRD
   A==;
X-CSE-ConnectionGUID: Z5L/GvVVS3aQcG4m73fSzg==
X-CSE-MsgGUID: JX4MCTqkT2yKnYvSPKtCdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11731"; a="78581351"
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="78581351"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 15:29:48 -0700
X-CSE-ConnectionGUID: SaHG0CXMRTy4RZ2TNHZ7og==
X-CSE-MsgGUID: M8CWjWoCRSCXioWCHy2OfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,124,1770624000"; 
   d="scan'208";a="252568189"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2026 15:29:49 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 15:29:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 16 Mar 2026 15:29:48 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.20)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 16 Mar 2026 15:29:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nkZ3nEbKiMOqovnRA4aE+hpMUq5M3qd01Ozboq8j05IaIZ72IjgZ5Hb83fCfQ6zfWgfAPeqfmww/MnkseSdwVEuXjxplt1xGT1SLGl1G7yAsO8+lTc+hgKAr17lGbt04k4nPK2hBFsZzqBvOL9cf6A/h5wBMnWNjG0El+yO1QMG4hTX9gM5m03WBIccODPmYMSCLNYIlcysgwPwSUODEf8DxFFVjI73wa+W+ha6BqvGchyrD603Kwt0m67l02OFm4BplL8/L+8WKxdwHMTNRUWg1e6gsxk2TP/nDMSkJ9IkEz8N3vLo+jMt3t9HG/yLaedqcVx6DbsNp1EUPc30DOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f124AGFGa7uJRCF6hAJHktz7pzvL+uTENHCNbHHbGQA=;
 b=PhAE6r9O1vPGFWJyKYWQoi5GGF49e0XlFutrSvyf0NTxW7txu7cB3eCCPMgGGAOLJYCMzMd9s964ZiklKuo7RIMTGu4m/TVz0dIjsEdFq/qR9w32DNVmUCIV1SIJDzwusd43VM3IHh0DqCP/bKpLu6SVyBB8+ZJi3cd3TdiwxfavWryuxQl89ptd/McItxys8nI+cPWeQIeziQR1xMBcr7VMWeCeTHFx0LPJANb+mTp1nh6J2DnjrQpMT0LLIzNmcgcwoVJ9ZgGCCxvz+9ZH6A1Iphg0eZoiZvGMJU7PZteittyd/xDqyZqGynOBhc+LM0YIn07iWglUxHvcGfpMXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN7PR11MB7566.namprd11.prod.outlook.com (2603:10b6:806:34d::7)
 by MN2PR11MB4565.namprd11.prod.outlook.com (2603:10b6:208:26a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.16; Mon, 16 Mar
 2026 22:29:35 +0000
Received: from SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989]) by SN7PR11MB7566.namprd11.prod.outlook.com
 ([fe80::eccb:f6e0:36cd:a989%5]) with mapi id 15.20.9723.014; Mon, 16 Mar 2026
 22:29:35 +0000
Message-ID: <bb2ab829-6a5e-48f6-a20b-cc7f9c913634@intel.com>
Date: Mon, 16 Mar 2026 15:28:13 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] x86,fs/resctrl: Improve resctrl quality and
 consistency
To: Ben Horgan <ben.horgan@arm.com>, "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <aaYfSTppsqwgMz1d@agluck-desk3>
 <9f8aab1f-6e2e-4dad-9d6d-e70f5f909f04@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <9f8aab1f-6e2e-4dad-9d6d-e70f5f909f04@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0247.namprd04.prod.outlook.com
 (2603:10b6:303:88::12) To SN7PR11MB7566.namprd11.prod.outlook.com
 (2603:10b6:806:34d::7)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN7PR11MB7566:EE_|MN2PR11MB4565:EE_
X-MS-Office365-Filtering-Correlation-Id: 0699fa35-cbc7-40d0-c69b-08de83ab804c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: tifkkOVnEK5vtDnrkt/zthDqSqgeP6uq7mFdr95IeT4Y/1Tw9KAyi5fruaLXsIuY9E9UEDR0NHApvyPtbt9b36m6T8iYZV+rBR1td5mnllHrrVGOPJAjClz4JPMDpHX6gSxnkdvqD/MXlojCe/1RDv+AV5KlhPaOxRAmpop+cNNIoTeXAhftjVebDm4ZLAAyooMu6AvvnHcaN3N6AECN/8WKwpB7+nYRNYb43b32hwE+VJVZdOpGnSOqkSQ3Vk69w9RvtYop4/R1cCuxHfG+vgVlF/AvXfBrmeWuELlRkOVvwYams3ltzg8ESA+bZNAj1P1hy0kxQr51i06FoPQ5Qg5T7aK1uYs9MmIeiHpLLkTzkVv0vHLi/k1cvHiZ04ms6dYX8O96YI4jIRDRWxXEw9sRHv+B0UGwl6f0miCS7lVJgheWfUltxvEWrzdeskgm1XkRZ34eb4UpIB+SHklHCAASAhBSSBzuvNfbW2LZe2eLLNQwwZgub5mcNIoJT55UsBsd8sjmF/nmWwPe8wJu142CwpCwwbTNsLvisjgohRnJBHCGaOqe1yVjDYuS7O8HD+87wC9Yy4B7oR538Yj+rMkbX702I30S+ye9B8infbXqxw5X2iyYJqrfRHsSxnC+ll0zzJWT3Cc0scuILTQNIypmCCk7rSxCA7dBt6hvg8LLO71ur++Uej+noBEZ6wCfXf5WBeIi+nlCit6LfNGghJRPte9fEL89oKidotC3PB0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN7PR11MB7566.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RWl4aDhBaGJWbU8vRlFycFJReW9LTzQ4WU5nemJ6cU5icmwzT3pBSGFKa1dN?=
 =?utf-8?B?VXdDTG5uWnpBaU4wd3ArdExtRFlUbzN4RStOZkdGaVk0Y1ZEdlZTdDB3NG9N?=
 =?utf-8?B?SHBCcGJFakZka1dZN3VWMmNKcXlLQWhLYVZ3aDB1clo0MDFPaVJlRVVtbU5o?=
 =?utf-8?B?SHY5MndkaHpBbWR5aWxoTWJ6TEtmalp2ZHpxODRad3ZZSnlzRE9GZldWRndp?=
 =?utf-8?B?a3VqTXlyRnBTREJUWStEaFFPcG1nbzVmd0xJU3lpNndZRk9iVDRITVhuRy9X?=
 =?utf-8?B?bFJvSW96aytabGRBV0xFQ2ExQitXOTFrYkZSR2dydnArUVBvSmJDajFWSzRw?=
 =?utf-8?B?enVJUjF3Z2s1YmVBaVpPdStuckxBUTJIcVlKOE0yb0kxY1FLSm0wVU1oR2tL?=
 =?utf-8?B?bjYyRzAram5sNG5PTmV0b0hsZzd6MWFGRTYzQ1ZFZkp4Q0FaY3FKaGtPOWNw?=
 =?utf-8?B?RWVYTG91UXVmRjRLMDdiL041ak9ncXdoOGF0b1czVTBKR1duakdsSTk0NHV4?=
 =?utf-8?B?RHptRWtJcVdOUFFmT2VWNmxXVzlzcXRMbWF6V0VxNHQvQVZWaDBMVVNRaU9i?=
 =?utf-8?B?ZlV6aG4veG9mek5sR1NhdDNmNkYvZ3NvM0hpeXVyampuaFVNWFFBQVVYRnho?=
 =?utf-8?B?VE5Dclh0LzA5UG8xalYzZE0wUm0vWXowTG45OTFoMXhXeHhTei9ZcXdIV0cw?=
 =?utf-8?B?YUhYRDRwOHljTU9ZNFlmTGMrOXhlTjlOVStEaFBRZmludXJYajZIb01wUklB?=
 =?utf-8?B?ZXRHR1JpR0lPdGhkVE1pNnFuMzBjZXNma2QwRE1RRUFoNmVBVUpWOFozSXA5?=
 =?utf-8?B?clNZWWlMcjkyYVdKc1FKUzNmU254NFRtRVVVMHBVQkIwSXdDcGgzMG9nZUx4?=
 =?utf-8?B?TUZ2L24ydE5zUmd0RTNicnlEMkRERG9hOGNzbnVWcUdFTC9mb2lncXhaRkY1?=
 =?utf-8?B?Wk5RU3lRV1BQWGVXS01lVXB1aXNEUDhXaE00UUhQVDFFR1BwM1Z1cDNnNTVS?=
 =?utf-8?B?eXpPWmsrY2ZrdldFVzR0VUFHRVNvdEZnZyt3UC8yUlc3eVExT2dDd1NyekJ3?=
 =?utf-8?B?d1V4ZTA1NWtIYnZwallVNlhBMkJUWE43TW5CSU4xNHg3aGdrUDNucmMwdVpV?=
 =?utf-8?B?VkxabkpCbnViT0w2NGliU0pJMVduZGZqa3Y4N2UvS3pwQWdETUtPZzU0QTV1?=
 =?utf-8?B?eTFlTDBsQ3F1RWVkb2RkalV2ai8rM04vRGRTaFdyU3pwdlVBaTV6Qi8wcElL?=
 =?utf-8?B?UXFmcjBIWitMemhFYVllTnNveFllM0l2bml3MzNZVWNkTzlkODdWM0lRZEc3?=
 =?utf-8?B?SGgrZ3YyVkZSSlJXcjVmYmwvaC9INnBDZit1QTk2TWNheFJwbmgzTW81ZTBV?=
 =?utf-8?B?VTVvNGVQRGxGYmpxclRmM1Y5dHFoRURmNHlqRFJNY1h0L3dERzhITXExZ1RC?=
 =?utf-8?B?UHp4bkYyT3ppR1EyS0JBRE00Tm5vZlZvZ1lxVDZ1V2NpUEUxME43NVNySEtj?=
 =?utf-8?B?OXBHQXVyaHZ5N3l1V0xkVDRIMHRzbURseGd0RmRwVDZsT0c1NXhPU3pKbkJt?=
 =?utf-8?B?RmhsbW42Yk9UZ2YyaHQzN2RIRmdycnBNaHB6Vy80UldZQittKzNYUVhDd2Q4?=
 =?utf-8?B?aEEzcHU2SXNyZ0VyRnRuc29wcmVQM04ydkFtaDliMDhHOGpyWDRJd0plTEt5?=
 =?utf-8?B?dHZhL3ZMMEw3NGVsbmRIazlQSTBTSEZCU2tTbWprYm0yN2I0OFc3TklCdzBE?=
 =?utf-8?B?TWhQckM0VGNyNGRWRE5hUkNEU2hWRUZTa3YycDNyYzRESlFkc3cveGZpWTR2?=
 =?utf-8?B?TldNVkVDNFNwUm80Wk5YMW9GYitiMzd0UXR3d1Vha1RrdE16SmJTcDR0Y1Rp?=
 =?utf-8?B?dW00T2w0OVJhaDlQZUtIMVM5cDE0OFNtVDhWMk11U3NjNjBkZVYvclVlNVBu?=
 =?utf-8?B?WGVoTDN6K291UkN4Y1pZc3RWdnc2SWtPOHpDTEJHeVhTdG9sUUR0RWZndHlC?=
 =?utf-8?B?b0kxa01KTGl1N3FkamNiUXpoOGpRM05qZndUUEFCbUhzNXhHY0JZV01kZmZv?=
 =?utf-8?B?Q1FqaWtZTmNmci9OWXFkRWpWRDBTQ1hoL2ovUlRwS2V2SGdNcjQ4bDhjbEVn?=
 =?utf-8?B?TzNtRmpPQ2RXSjc4Q1Mwb2tqQUhaRGRDQkpUSmYvS1FweGo3cU1SbzRPYzJX?=
 =?utf-8?B?VUlYQm96NGVQWWZLdUZydWhweEdCSzNwSWxsVms0TGFXUWlCa2w4eWIrV0VE?=
 =?utf-8?B?djAvZ0FDWHNoS0s0Wk1wQllQY0pISWtneUFlcEIvTk1kYm54Z3lVblBPSTQw?=
 =?utf-8?B?YzYwa3ZCQ0lOWldUdmdoT0JZL2lVLzRudG5FWk1EaEttNG1JaTN1NnZsSlVG?=
 =?utf-8?Q?+71itV4BhWo00ysk=3D?=
X-Exchange-RoutingPolicyChecked: kUTacfKSlWsOPdUI/L7ix1J9E8gdhGe7qQbyDV8aSXNxzuNYltWdEbqbkXi53ukP/ExPXp+qU9OPxdNJc0ZwUM3dLvu1uC+xxnbPqtT9pp79RvdNt8/zdpafuiJZ9fZR2EwdS7LJr6h41qdI2oZT/yfsQLwxgLeihlfpb9D4i9AU4O2jxlnI7t3r9ymkGAGeqFVVqx6MUWrXahYdSZJsadpTUsWZLbEZWaPwdV+jnrs8ApAMh5Cs0sQCZ00QyHyWjP6pWnW7MUWrw38UiCBCwV+6LYzZ3sjCVGAjQpCABCpAXMcVaSelUXfCA/5ABX0qOj/5Df8/uwW1661hhX0HTw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0699fa35-cbc7-40d0-c69b-08de83ab804c
X-MS-Exchange-CrossTenant-AuthSource: SN7PR11MB7566.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2026 22:29:35.2844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Co1hiJipPy3ylp44wcUC2ssn+f7dmsbbsEwh21iVyBPzHhdeSlmx/v2qYCU/r0BebeqfVv2GkOWRtWcTgu/gkIN1687fh3Zup3z8T0zj5cQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4565
X-OriginatorOrg: intel.com

Hi Ben and Tony,

On 3/4/26 3:48 AM, Ben Horgan wrote:
> Hi Tony,
> 
> On 3/2/26 23:37, Luck, Tony wrote:
>> On Mon, Mar 02, 2026 at 10:46:06AM -0800, Reinette Chatre wrote:
>>> Hi Everybody,
>>>
>>> This is a collection of resctrl cleanups assembled together for convenience
>>> and simpler tracking. I'd be happy to split them up if it makes review and/or
>>> handling easier.
>>
>> If it is time for spring cleaning in the rescctrl code, maybe fix some
>> bad fir tree declarations too?
>>
>> Note resctrl_arch_pseudo_lock_fn() needs help too, but complicated by
>> having #ifdef CONFIG_KASAN mixed in with declarations. It might need
>> to remain an exception.
>>
>> -Tony
>>
>>
>> From dd9c2ad1a1361b34e25fc10d18d3ceb3ba57fb92 Mon Sep 17 00:00:00 2001
>> From: Tony Luck <tony.luck@intel.com>
>> Date: Mon, 2 Mar 2026 15:28:36 -0800
>> Subject: [PATCH] fs/resctrl: Clean up some bad "fir tree" declarations
>>
>> Sort local variables by length (longest first) per TIP tree.
>>
>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>> ---
>>  fs/resctrl/pseudo_lock.c | 2 +-
>>  fs/resctrl/rdtgroup.c    | 4 ++--
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/resctrl/pseudo_lock.c b/fs/resctrl/pseudo_lock.c
>> index e1e9134474f4..cd57d862e0cf 100644
>> --- a/fs/resctrl/pseudo_lock.c
>> +++ b/fs/resctrl/pseudo_lock.c
>> @@ -797,10 +797,10 @@ static const struct file_operations pseudo_measure_fops = {
>>  int rdtgroup_pseudo_lock_create(struct rdtgroup *rdtgrp)
>>  {
>>  	struct pseudo_lock_region *plr = rdtgrp->plr;
>> +	char *kn_name __free(kfree) = NULL;
>>  	struct task_struct *thread;
>>  	unsigned int new_minor;
>>  	struct device *dev;
>> -	char *kn_name __free(kfree) = NULL;
> 
> If you are changing this, I would expect either the declaration to come
> lower at the allocation or alternatively drop the __free and do an
> explict kfree. This is based on the guidance in include/linux/cleanup.h
> 
> ""
>  * Given that the "__free(...) = NULL" pattern for variables defined at
>  * the top of the function poses this potential interdependency problem
>  * the recommendation is to always define and assign variables in one
>  * statement and not group variable definitions at the top of the
>  * function when __free() is used.
>  *
>  * Lastly, given that the benefit of cleanup helpers is removal of
>  * "goto", and that the "goto" statement can jump between scopes, the
>  * expectation is that usage of "goto" and cleanup helpers is never
>  * mixed in the same function. I.e. for a given routine, convert all
>  * resources that need a "goto" cleanup to scope-based cleanup, or
>  * convert none of them.
> ""

Since this is the only cleanup helper in this function it is not clear to
me what impact moving of the declaration would have. I fully agree with the latter
though, the usage of the single cleanup helper in this function that continues
to heavily use goto makes the flow through this function difficult to follow.

Reinette

