Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4189830EF9A
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 15:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735994; cv=fail; b=A1odoaNX9CKS5NKqlxXOUaatoiU8EEYgKn6lYpnTypQO1S7ycPtxfzzOVPeL05UIfpk0DW+Ac7C+8Js0mK9EXyT/V6lsB3iwSQ6vkZMe+3TNrC8rO67Fj9slqx7BYu7N+m2bf8frjHXFRcMxhPK5fH5bzDykTIIGk+askkhcGmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735994; c=relaxed/simple;
	bh=ToXqQXXUbE6lgratUy5hdXSROFnvslWpe52vIJTuHyI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FI+NJafMl5HRvKbqJH+/WVIGkXODTdHMaXXFBog9sKGrMvsPN0RJ9XdQtfcP+h74DxG42dxc/+XLnRf/vyJd495g4cIEkeW6LkdpGKgWcJ/746iwfT5JfDZEE8JFYpcSfQpOuatdFYtgBCYtT9HZRAW+XSC3jZZsckqpykd3hQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=L7ruey7y; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="L7ruey7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784735990; x=1816271990;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ToXqQXXUbE6lgratUy5hdXSROFnvslWpe52vIJTuHyI=;
  b=L7ruey7yNriRV4dz188HS9qmUxcmlCR8lORh0C0J0QNDqZYfKjB1EjlL
   ssmAKRO2x1qVpm7wxKP+X0y0rLIdN6Vy3uPbcus7nMh1MgxMm7RUIV9Iv
   HJtNSuv3qV06xqi0UhXG2TSrYQnFhqar+xABZ0eGdeDayN/0G2dNuP6Y0
   4v2SgomZZnedB5IFQF7i/6v5QuglVWEr+3nZ7GHx+iTfR1qApPJs4kSz5
   0MaQzja6nPimOH+l1NYSkULh6iD3op+ZIFAyWYU50FDZLK8eJRp0gjs6z
   b5FgFdXyBo2QZ+c49oY0ZTXI7K1YAoh79uv1urG3KfRIiJoY/LnKCt4wG
   Q==;
X-CSE-ConnectionGUID: UfZaJFx9SI2H3EautS9S/A==
X-CSE-MsgGUID: IzieTYttQ3CnquCSucr2ZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85247820"
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="85247820"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:59:48 -0700
X-CSE-ConnectionGUID: 2CQ/FnH1RqyI3iFBI8zjQw==
X-CSE-MsgGUID: MidJnKSuTACeFtDLIVASAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,178,1779174000"; 
   d="scan'208";a="258809282"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 08:59:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 08:59:48 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Wed, 22 Jul 2026 08:59:48 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.64) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 22 Jul 2026 08:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fw931nHNiQjgm0Ze+SDqGWIct8seXfO1W3O+7mnYOnfvKf8To1iG1WxS2uzFLHidDdClUky6uSuCfhcxD2YEKepBDG0T8JgyfgBZFVHxs0aHCwITQ71kpTKW1LnEpHLvbgEX43CPcdbqW9lnPaSjzNBP6c1q1hhQ8AWoArULgsSDC1Z5p60cOG/66NQGQQ73nC4rkyrBEPeRDCVqn8Z6NzCrZhQxEBdyk4GplutLdLGs3TsGPc/rHhdG6SHGxztDR3OxhWkCE0nrGld6CXexo9kTjjNaTirSednE6DiII/Maj/onzZFAMyb5sL0fgbPF+4+eP446wlrfeWLr/n8yaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wnb4JWiE5F047sKXAiEK1k8zFJ8XSlmufPxaae9t7EE=;
 b=qo6RJMYfmSeC9dIN3B2jLxoJMfRfKidCBFtSmepmMEFS2tmvLUuvFuTxsS6MCVoxIQldWk2TU9CUp8YIqStNCI6NJcYi+rXFtZR1wc13IbmSd/fV7lCtvpv4A7JW4xJXBd2qcNC0FeQJ9P8lpOWRJrMBv+yDUgDYGXydaXtZJKeFFEj7UcmwZ2Ns9r5DdcwoZkBUsonB6dYva0wxy4St4Gqyvb/i1GkQ2KFoWQ5ML6XotSayyeu0pTe/fEB3dmynQNIAQ7NCuOeadGrF9cGo61aCLPxrfSxRZyXGksBxbvy/I7RD0TcVTngtIkYCTmyFRJNcyJ3clGzLZ4YQZnrJCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SA3PR11MB9512.namprd11.prod.outlook.com (2603:10b6:806:47e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Wed, 22 Jul
 2026 15:59:42 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0245.009; Wed, 22 Jul 2026
 15:59:42 +0000
Message-ID: <ae04714b-566e-4b21-ba6c-2f42c6400e87@intel.com>
Date: Wed, 22 Jul 2026 08:59:39 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/10] x86/resctrl: Protect against bad shift
To: Borislav Petkov <bp@alien8.de>
CC: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1782857711.git.reinette.chatre@intel.com>
 <bc6ec5102227b4617265e015ce84335a8e902bc6.1782857711.git.reinette.chatre@intel.com>
 <20260721015959.GEal7SnxxR8D3801cr@fat_crate.local>
 <2184678d-1b67-4d2f-94a3-c4bb22823cd6@intel.com>
 <20260721231502.GGal_9dvrdG9NdUkA4@fat_crate.local>
 <86f26d3c-92a7-4365-b6b9-2b31da15ce1b@intel.com>
 <20260722005015.GKamATx-zEYGcRs2X4@fat_crate.local>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20260722005015.GKamATx-zEYGcRs2X4@fat_crate.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0087.namprd04.prod.outlook.com
 (2603:10b6:303:6b::32) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SA3PR11MB9512:EE_
X-MS-Office365-Filtering-Correlation-Id: ef0f504a-1623-40b4-250a-08dee80a3ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|10067099003|11063799006|56012099006|4143699003|6133799003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 2KVhYpFjuY5lRdDRS4YKEvivIP9WKvxY2/A1CIF7k05roG2lGTOpQJfUDiRgNmMuyD0v3GhmcbLyfSgLZ0LUm4YH388k25Anjr/k7LVDRjuClKdG8OzD2cFF6iP6c0PZhhnY3z12qfJQKLUdqkj0mR8+b2QOOkBp3bNH8/0DlH8PrZRKqs7JKzvUpGA0qSqIhyJbFPOK2SL50OxNi1N2yUkuih6TK2pKjHQb+5Gus94fPbCTTZBeOfxrcioyUPuX7hgwl7qZjtj4cleAFGsKalpJbI/vmWhjo0nDLotOSDAFOOoYshBfnEQ8srOLbrxkTPDpvCBf2ZIGgRR3B0V5DFoUiVMGD2mVD5n7iILJNNfdpBjsy0l2F01SbhdcZ2WsgubzcNejyWphucxZHkWGnUpgZlopb2oxqkH++ItOLqjPm26A2erV7KLs7SpZEueplkgp8EjyoXjnLL12CD2s9dysaCSshziKkEXvZcUEZailUj294kIk9vrN8NsxqhHkzFsQZC9Wlio2fmiAiguaeoGOcubPX4PqEsWKylExM9PeIAdy69VxEJALtWDc6d0XlQzXYnxy0QyO/MAWLHY+1va/x/pC+OpH0pwD/jU3r+346YpHikRaFfJeJA6PQ3Xe85F5V4Eb+043WGi2RwjrDR/70F/+FQsbyLtIH82MP1Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(10067099003)(11063799006)(56012099006)(4143699003)(6133799003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UHZMc3RsRHlTbUo2cmJQTWJFOHUzOUdsSDNVaWs5Y0J0aVB0dlI3N0hCMUkr?=
 =?utf-8?B?cm5ha1pEZ3dwell0eHljRDZFV0lnOHJEb0NXZHdzek41dk5xMkxBL1hSUURi?=
 =?utf-8?B?YUJvQURzanNiOXFtYXN5MVgvLzN4TXZlQTEwdW8xdFpCU3Z4SWwzZFJpWWpI?=
 =?utf-8?B?dk4wbTM4Tnpkb1NjeVJ5UFphVFZLWlpTa1JyRTlvV1JGVmJZbkhkdXd6bmpy?=
 =?utf-8?B?WEhPd0RDUTZvL0VSeGJEQ0xpRkZZaDJkZUJkZ3htMDVCNS9YbExXaXFBR1BS?=
 =?utf-8?B?aE8ybDU1VmR5b1VRcFFUUmc1SlJPYWFQV3kwcXRmYzdwcjZ3V21VQWY5azJi?=
 =?utf-8?B?U0U2ZldRSXU2Y3kwSGNEQTJmZHFWeEoxZnJkanVWN2JHWEpxZEpBVDZhM2Uz?=
 =?utf-8?B?MnduSkhLblhpK1JZdUREQnU1a0lyRmZVcXFQdUZkeUNQSmwyN2JuV1p2Y2d6?=
 =?utf-8?B?M3VTMG9IZU1vTlIvdGJqdFFld0grajE3dVBZL3NXM3pBa2s2S0FYS0gxOTRK?=
 =?utf-8?B?dzRyVFI0dzQwSVU5MnBILzRNNHhkNmUwNjhOeGliNVlQaG5OQytLWDJnTkhZ?=
 =?utf-8?B?RU4zTmlUcmtwamxoNkFOd0NmLzBTaVN2RmdSR0tPSU9OVlJ4NlIxNUxnaXJt?=
 =?utf-8?B?cVFLWWM0ZVA4eUVicnhtWm1kUGdXaDUzZnFTbWZsRW9hQ0NRNGl5YlhZcThs?=
 =?utf-8?B?VzRRT0Njekd2cEh0Wi8wa2RrTitWWjdpTEZHeTNneXlKN0JQUEUxNGhoUG12?=
 =?utf-8?B?OUxnYXpIQS9oYUg1bXhjTUhSN2xTRytiVTdlWlNGTVRJMjMyZ09sYWdFRVIz?=
 =?utf-8?B?ZWNMcHNYRXJVc3FDeThVQk9qUVBHOXYvZXN4YW1HMG5ZenBUTXJISDVuNWJF?=
 =?utf-8?B?SUVWbkcyaXVSNGlHbGdGS2d1dTBTYW9xdlpZRzNIaVhXRW5KOUR0aWVNTjBE?=
 =?utf-8?B?OEZkdERsYlBnZUt0aDQxQ0FNMkpISm4yR0xTMnp6N3pRMkN4TDJZdkpYTzBp?=
 =?utf-8?B?eEZFZkRIQnVhYXR6Y21neUFjcmNDc3prY21pa1Y4dkFHc0RGQjVPNW1nR0Rv?=
 =?utf-8?B?SEJiY0E1UnZYSlo0TlVYSkRQVHVVa3AwWTZZSFdCWkoxWW9lU3VCOGZRMStF?=
 =?utf-8?B?cDMvSjgxQkl5ajFma2pCekpVcWFiNFB1L3VJTkJGUGlKRnFBVHNIRkwrcDhz?=
 =?utf-8?B?ZUlrUW5FUFpDTjZHc3ZUOTBqTGhVTnN3Nk9KcTVXZmFSYllwcHpLZXBGUTRz?=
 =?utf-8?B?SURDSFBxWWtvWkVrYkUrM0h6OVNIdC9pd3NwVTJoRjVwVk5DbktaSmU1K3JE?=
 =?utf-8?B?dEJKRjFCOHhkemE2WCsvQmsza1krcmIwT2szR2k4N2syakt4TEQ5MXl1RzF2?=
 =?utf-8?B?WEFGaVBqNzk1c0pqbVFvMzREMjNXM2FTcUU3ZVJlenJ6THRXZkdqdGlBOHdM?=
 =?utf-8?B?YUgwcXc2T3RUc3FoREV1a3BkN1hHQTU3TTFyVjZQU0ZPTVRTVkRUTTJwcFRZ?=
 =?utf-8?B?RkdRNmVWcWJMSWVpbzhMQUFNbVRCSFp5UXJZY3ZPZHlqUk1xbXpQd0VvL25N?=
 =?utf-8?B?ZGtjQlNtWW8rM3FtQ0dNUDFwMjlLK01SUmNHM3oyR1RYY1VaaXpOT3RWbTNs?=
 =?utf-8?B?Y0tjRERDK2NHc1dyc0tjaWFtZVZQM1o3c1kycE1vNkpoVkNKcUlGTDhTeTA0?=
 =?utf-8?B?V2F5b01GUVVOeCszZ2l2alVwU0RNSEFoSGlkNnp6endnQXpMbWpEZzBuZWVu?=
 =?utf-8?B?bGh1ckplVWNOeC9zZ3FXNUdjQlBzV3lKUnRQbkdzZngrVGNnY1VudW1la1FR?=
 =?utf-8?B?YTRDQktUYVhiTXN5cG5rc3YyaWlJZWtZYkVTaGF5Z1QrZmFrZW1IeEZ0Tjhu?=
 =?utf-8?B?UXFOdGhpL0xETGdjaFF0dzlZeDB0bjFjOHRDV0JtZzM1b0IwNXVibXBIZ1Ny?=
 =?utf-8?B?b0llM3pPaGk5c1l1bWk0RWJRUkpxV2tUZ1R4clRHVFNXSkU5azlMVWxoNm9k?=
 =?utf-8?B?SFo3bTdWRVcvblQ5M1BmNjc0Y3RtSnJVQVBkakZOMFdsTFdjTWEvWXRHZ2Q4?=
 =?utf-8?B?b2FqN0NkU2l3QWc0SjRza3Y5amR4UVkyRGdBZUI2N1F0eklCNlJWdU5vcWVn?=
 =?utf-8?B?Ykg0WVArWHBPbmpOY1dxSFZONWx3cFBwU2pmK3dyRzluem93c3R0blFpc3hP?=
 =?utf-8?B?cXFDS3F1ZGlETHRienFvKzV2SFJRaTlSbHBiZ0pjWUFlMDJOa3FzaW9RcXNK?=
 =?utf-8?B?dkFKMVA0Z3BxZEpJQmZvbWV3Q3V1QTZmQXhDSXJZVXNUK0txOUtKME1ZVXVO?=
 =?utf-8?B?a1FqNWR6dUZPRldjM1VpZ25CQjF1R09NeFZBaGZ5OHoyWFdPbXpVbzlUVEc0?=
 =?utf-8?Q?ABGgsbalXkrradTs=3D?=
X-Exchange-RoutingPolicyChecked: tO68YMXe7mlvnltMB34uqVKK6s9/NX17D81js+0QliFzpyIeO+AL13rvsg+id7SywUTNHLj1hRXGANMFSmhqGVG+EqYiHY/3cUnCaZFKg+gViXMKEuQTtcqoX5O873Kr4vjSthO/MZHpxommSaINdmD0H56/kfIBA+l0or/1tEPH9xYR2/HMAHig+cmkKP35IeNtF7bkTqJd01y3+JlZ7ZLw/UML4vv90SZjANe+ek9Kja0IbQSj/R5hu48MYy+iZ1GYDyHkRlI6d6Mi6Mi8QDyBZ9gjsXA8Ipi3fDV59uFfnRsk2P2aoTqM8tLRgrtAb1uxDXwlFevj6PYJV7O3fg==
X-MS-Exchange-CrossTenant-Network-Message-Id: ef0f504a-1623-40b4-250a-08dee80a3ddf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2026 15:59:42.1893
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e0VBq9/4L5iP8920jY4UKCJyetq0ux/l9mtw2YFO/YoP3935zMch3NwuL5KZg77euE1AlhKJpioXg9EgbRMh1yGCbI/mafD8L+2njffrR6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB9512
X-OriginatorOrg: intel.com

Hi Boris,

On 7/21/26 5:50 PM, Borislav Petkov wrote:
> On Tue, Jul 21, 2026 at 04:50:32PM -0700, Reinette Chatre wrote:
>> I see how such change could be considered absurd. I am ok to drop it from
>> the series and just keep treating it's report locally as a false positive.
> 
> Nah, but I'd like you, pls, to rewrite the commit message and explain more
> prominently
> 
> 1. resctrl does not support values than u32 max_bw
> 
> 2. what this is really fixing and where the potential issue can come from and
>    what the situation is today.
> 
> I'd like to have more background in the commit message why we even arrived at
> this patch.
> 
> I wouldnt've even done it - we have bigger fish to fry - but if you think it
> is important for resctrl, sure.
I am trying to help with bigger things in resctrl and find it easier to do so when
working on a baseline that is without implicit assumptions.

I plan to use changelog below that aims to address the items you highlighted and also
changed the math to make the bandwidth boundary where resctrl stop working clear:
	
	x86/resctrl: Protect against bad shift

	The size of the bandwidth field is enumerated from AMD hardware. resctrl uses   
	this field width to determine the maximum bandwidth supported that is stored in 
	resctrl_membw::max_bw. User space allocation requests ("control values") are    
	compared against this maximum for validity before being programmed to hardware. 
                                                                                
	resctrl filesystem and resctrl x86 architecture code only support u32 control   
	values: resctrl_membw::max_bw is a u32, the control value provided by user space
	is parsed into u32 local variables, and after validity checks, the control value
	is staged into the u32 resctrl_staged_config::new_ctrl for architecture         
	consumption. The resctrl x86 architecture code in turn caches the new control   
	value into the u32 array rdt_hw_ctrl_domain::ctrl_val[].                        
                                                                                
	The AMD bandwidth field to which control values are written can be up to 64 bits
	wide. While not an issue with current hardware (bandwidths that require more than
	a u32, more than 536870911.875 GB/s, seem unreasonable today), it is theoretically
	possible that enumeration of maximum bandwidth field width will return values   
	that are according to specification but cannot be supported by resctrl.         
                                                                                
	Static checkers complain about this size mismatch.                              
                                                                                
	Fix the static checker complaint by explicitly encoding the fact that resctrl is
	unable to support all values that the hardware specification allows. Switch to  
	BIT() instead of open-coding the bitshift to avoid signed integer overflow if   
	the number of bits is a valid 31.                        

Reinette
