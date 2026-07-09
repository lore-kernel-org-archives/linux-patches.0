Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448A5449980
	for <patches@lists.linux.dev>; Thu,  9 Jul 2026 20:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783630104; cv=fail; b=pwEC0uwuSYl9OSMeoqSCizF0h6PTtLg8g+m33xlC8E7JY5lwJbp6514KDGH8qL4KOEPptWyUN8Fn6Ko5nUPfCKH9omJo4C4NN72dVwZU7vS6MnEpZMvro7xjHOOXAAp/0McMRN/X0U8RL3SFcCYUwnW3g3MZutc7MZb2h1A844M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783630104; c=relaxed/simple;
	bh=TN0W+A2/mtPDYshzsPE5JdeSAa+ZwbTMr3RVOog2kI0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JLthrH/GX08t9S91ZxZxCnkzIILozyqeA9jtyIsmd3nLgrSu3xb9d454vnHBqgnbjoPJ7y34TAjuRLyz+/2I/NHGfzdBsCikqgLoCQLxW552CxFqtGLXOvigEahjGWv+sDeaQgOlNh69kahP7ASM5/APHQ6cGc/kO5t2GgJEW6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CA/Ermmd; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CA/Ermmd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783630103; x=1815166103;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TN0W+A2/mtPDYshzsPE5JdeSAa+ZwbTMr3RVOog2kI0=;
  b=CA/ErmmdMe05p4QxBgbsbRw6szN1mwBKZdOJLLAd6KYCb4CnPi1LKRNK
   xX8jbG3rtV7r6X7LB59NJj8FTltowDS8jeqrEJAA3U/n1ycdNTx1YjGA1
   bXflbi0gnvghayfXErrOt0mWYKJnfUk+2zD9BC+JEXdzT6L5U7EDiTJ4Y
   jcpmcFKW47XyBo9dVogxRu1etg7G26gPxwRz679fyl1OT8r4KPZvqcCDB
   IEqJifnnNbGyjqtECrOgiqyfwnJd5kuLg56DCjRQkgsIqh+njsI5CCL7C
   caNKW6LYavFMgFCCMn5tvEAO8aDZu2Wh947M/qelqzC7Ci43wDlOCVYkr
   A==;
X-CSE-ConnectionGUID: k2AnLyRmR4iIlIO93tSW5g==
X-CSE-MsgGUID: fbedhfmBQHKMNiNOB/APFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="109874600"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="109874600"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 13:48:22 -0700
X-CSE-ConnectionGUID: d9FNPqydSyuweS4k+xX/wA==
X-CSE-MsgGUID: oInZfteGSauOL9kQEt7SRQ==
X-ExtLoop1: 1
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 13:48:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 13:48:20 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 9 Jul 2026 13:48:20 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.30) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 13:48:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gtuDlNcA7/RZtQ4PPY608goCU4eQmO6BJKz+UYoz9IrpeJrsN7BZoS7oEHm6OGpgBdlUKtpH3Q6MnC25ndvsXgSLKaTHFOHShrfibX6KSQ7MZZ5DCvG/JSiiiECsIc688YrE0OngKCEbLSROOTk0aYqaT7zt/wvL7EdciZev99MRkQ1ykg9Ak778C9cLneGDm/HKvMcwJbDaw3safUn+OswSt0zVQqqQGHtGy5l2S3AqrqGgQ90LF8RNRvZK13fGFa54hgAroPXbeht+NcK9YyrLjPZ4oI9FjA9yXaMwQAuVSYdXZcbA0ENDkmBQR55x2cOiUoBDAkvnmYro4N9oxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=icWbNh2vQ22m6MCIRI9S0o/iQdL7VB+WQn2sRZ0YZYc=;
 b=jl2BuHAy+7KJstIQ5+2WYfSqQGNhOkgFR94BdRx1S2zikCIF0w2fWjS+gwXFyWXJOaEoHHZaE/8AAhVHMdXfAVKypEiteuUeRmQezzo5G9qp/8ivjYZJFEBiGX406aE4jGMykuMHk4OzyU25rauRAwhzfWwr8Q9+e2Z9+1Hkmw8dJEwknLvBUgctaoA0mKrzBebsGCJ1/cUmioPM71wS1jOYOvO0OJrGC7uOLZC9z3OfMWK5WgN5Psqwh2QTO5sz/pt0KkIqQsEsicEqJXm0jZ8vA5uCE3uouMuHLlo9zgws01avXn2LzQ4lT91lTvCtwa9BaqJvInLwmV33sfxXtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DM4PR11MB7349.namprd11.prod.outlook.com (2603:10b6:8:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Thu, 9 Jul
 2026 20:48:16 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 20:48:16 +0000
Message-ID: <8c627385-b6d4-469d-bf99-b1cdf606bccc@intel.com>
Date: Thu, 9 Jul 2026 13:48:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/12] platform/x86/intel/{pmt,vsec}: Prevent unbind
 via sysfs
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260701213553.15222-1-tony.luck@intel.com>
 <20260701213553.15222-2-tony.luck@intel.com>
 <e2a74402-791f-493e-9824-a5e4aec61b87@intel.com>
 <ak_dQX9j-hmtm7W6@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ak_dQX9j-hmtm7W6@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P223CA0022.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DM4PR11MB7349:EE_
X-MS-Office365-Filtering-Correlation-Id: 99140a3d-a2da-451c-11c3-08deddfb66cb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|23010399003|7416014|366016|376014|56012099006|4143699003|6133799003|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: YB+CJDe/UiT+8MosQOfEkVuvkGtldXPPjo7K9aN195RKloJYavGUaoTk+WL7ILVeyEBw3SVfb+P5ADLsaYoji5mZHnXSLdtddmzbNc6/7i5Dhyu1JbI4RbZQpOZVZ91Uc8C/KLB1V66b4A650719XrCOy5rgxrQLqv2YCTh1GLnilvS24hYhgvlaaVzhkeCT0krU1KKWfs7jT2QntSyjp/S+utt7MjxMPhaMIN2eJdeF6RvHo1Jq2ZcxLrwhzBdxZdIYDVp2zfxdjQWv+GdtaA9SLM+gCr/c5jBkObRKS2GqeRe4bNSWtMTpRuTfQuCboTwyLxDEsth9LTTvbXrhFCWnOYbPYdYJ67YwJ/gVg4CzCflWlW7AK18KU490AFImaGACnAwUqju1vQlwb4nJ6IgYaVRV+HEXwipxYnoCWbOTIQUMhIijR/uyrRprIrBQE3D79TmIiBoATkmZqob/JqceNvEU/YWMnfb0ihzyHe8jszxFJ8xunXosCPA2WmpSZ0K6Kg+lWLSM5m80eIjrGE/lzZ0E5NbH7mcY3Iojj6C2DnGWbSIzvB8/EfeX3ft0g4Miap7UEiawOBC+2ETuws6ET9LW4MAYLSD7w/RBUZueZaJqovekQZidJO++LQvvkuZOnwsvrAxj99M6acxnAN4ZYB8Chpi1uTNEV3XXOM4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(7416014)(366016)(376014)(56012099006)(4143699003)(6133799003)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NnhlamhQU3dEZVNtWit6WDc4Y3Jlb2k2STAzeE9UL0JkbzRUYXVaQ3d0TWQ5?=
 =?utf-8?B?Nm5tY3lEQXVGaWdyb3U5aXJLaWY2aTBOdkxFb3BLeVdTWTRLeUNqN0pkdG5n?=
 =?utf-8?B?N3BRR3AzeHdEallCQnhsSUFMZVZCOHBBTmd6Q0s1VmV6eEd4ZHcwWmJwa2JQ?=
 =?utf-8?B?SXBNd2RnbWpGd28xQkV6eXlWdGVRTE5sV2kxamg2TzRjSTlVa2JIZncvM1RY?=
 =?utf-8?B?ZjdpczRPSW9KeFh2RWV2RVpBNWZLYjBaUmxhL0psZHF0UlBPREJSVmNlMGJR?=
 =?utf-8?B?dkcwSGpvR083OThXdUh1NU9UVlFvMnoxc01nV3lkTWd1cHlTWXZSZXgrV3lB?=
 =?utf-8?B?UFh6OWtza1ZDSlJPM2lqeWk1eHVLVXNjaUZTcVg2V2xmSTc5V1I0aGNrVlp3?=
 =?utf-8?B?V3ZZZVhMN2pjQWd1U3B2S0tZeUk5NENGdURjRGcxSDh5cDFqb2htQUIxbXF3?=
 =?utf-8?B?QWs4a0VvRm1xTkZmRUhyU25lV1lFbVEzUDVTcjNjZ081Q2JDQ1lXb0hSMVF2?=
 =?utf-8?B?SEF6alVRQUFCUkZWdS9qS0NjQzBFclcxMzV3RGFJdTFnZSswNDAyMjVFb0Ri?=
 =?utf-8?B?R0o1UG50cDMrUDRCWHd4YkpsUWdMMDBSVDVHNHEyemVFZVhGMXFLVG5MdFYv?=
 =?utf-8?B?aEEzY3ZyWGloK0IwbnViM0ZTM2RacU9KeEFtaXFmQ2tqQldwWlptNCs1Yk1L?=
 =?utf-8?B?ZWlMTEQ5WGwxdlFPZHFnNTBHQnM1WDQ1Y3JCRzYvODlTeUJtOVI2NmF6Uysx?=
 =?utf-8?B?Y2pVVEhJQUJNVjhiWVQ4bFhCbDZvcTJlTnlNMlVrMHlrV1VxajBnNDF2R3VQ?=
 =?utf-8?B?QkRYeU0wV29HcWh0cW1rNWVGTnB3dzJrZ2lpems5SjBzTzhtbzVzeVlpNUw4?=
 =?utf-8?B?QkZOb3krZndyd2xtY0UyWXRLK2pCSU90cFZpWWU1SHRwTDU0dTJSV2o3bGtj?=
 =?utf-8?B?ckFDbklCNG5ESE5mRFRLQjRPSzFHam9kMlNxODEwcDBDckRRSzMvM2tqWWJO?=
 =?utf-8?B?SHRVa0ovdDkwZ1hRa0lZQlNTcTlJc1RKRmE2WjlaczloOHVKMC9KbXJjK2dV?=
 =?utf-8?B?Vkg1a0RkMjBJUjlGWk5ld2VxNSsxZEZKSFRwM2MzZDVMOUlRZDJBMEo2ZSth?=
 =?utf-8?B?a1Q5ejM0QUZQTklJaFA1L0RDSmh4VUtMbnB6UCtCUWlHZG1sSDl5MndFM3RH?=
 =?utf-8?B?R0NXR0h5bjQwVGxCV3lpZzlsWDRZdWZoU1V3Y1RuTHA1VHMwd2NEQ2VFQnRu?=
 =?utf-8?B?aXpvRWpSTDFjcGI2NEpBZ3V1ei9idlBiemFMQ2FVQk0yZGx2azlvWkZ4NTR3?=
 =?utf-8?B?S3ZXak5KWTEzTzlsUjFVSFQ2UXdqYWY2RXJoMVcrbUlFTXBpaHVIMlI2V29X?=
 =?utf-8?B?RVdSWUF5ei9RQkcvNFBHRDNSNG1sL3p1ZENnYm9lNHdNcmVmc1hlTTBUT2wy?=
 =?utf-8?B?K3BRajN4LzlwaTlFL3F6TkFyQ0x2eENjWXdrRDc0cG9VTjJIRXdWM1BCNVh1?=
 =?utf-8?B?MUNMNjlQVHFuT1IyUW1URlJIVUdzWjVJaXFNblJYblZzdWNRdVUwMFY1RXV2?=
 =?utf-8?B?YUlrZ2ZwWmFZa3RodWlpdEtRSnV2QTBpUDc0OXI4VFFBTm5IT25kazM3aU02?=
 =?utf-8?B?OFlTVW5ldFRxbVE1ZjlYdkMvejc0Ryt3MDNRMWQ0TmFFM1hURGRsUXZjaUdy?=
 =?utf-8?B?UitSdFJrQkR3Q21EaWp0bExUMWtqcWJPSCt6cFBTUE5DV0VsVndjT2w1aERo?=
 =?utf-8?B?Z0k3bVR3c2ljblNwV295RW5aTG9XcXg1YlZWRnUzQSs5dXVUekp6Q0hseGFw?=
 =?utf-8?B?a2V5dFRmbisyS0JtRHY5d0hUY3hCblpmdzEvbmsvZVRpc1FyRDlCNXZCQ09u?=
 =?utf-8?B?eFhZcmNXeEt3YWk3eC9LNVVZTnlWMVQxY01nVnAvQmpQdVlMYzlMT0VkUHhQ?=
 =?utf-8?B?VEJvaXBIWVAyYzkya1R1bFJ0UjN1L0ZiSzZJVlF5YjJQMkNYNXFCUkFQbDJG?=
 =?utf-8?B?cXdLNE5hSlFnaGxNckJaWHNwN09wWlh2a0lDa0xEQU0vS05GTHJRU2Y3QVQw?=
 =?utf-8?B?SDNqeDYxbWFXY3pobW5IeE5nTkdqZWdpQ05IMm96VmlIdXFNOU81dldBN0xw?=
 =?utf-8?B?dWpySTlGSDJwKzJEWWNKeC9VWkhpYTFQYmx3LzVhRlQ0d0pyTjk2TmpaQzVY?=
 =?utf-8?B?eUV5dmQySkR3L2diWmo4eGRUV0ZFYjdnZHBSbUI3aUZURjhISENncm1JR1FS?=
 =?utf-8?B?SXFzVTl3bTZhRTJiOFFIUUgranVVL1BHZUozMSt6TUhVMjJSbG1mM25vb29w?=
 =?utf-8?B?UW9yUnRTUkdmN3BaV2J1Smd6V2Q1VGpMVUhzL0MrSlMxckJNbG9WSjBTbmkr?=
 =?utf-8?Q?uH7Isccb4UUjgRRk=3D?=
X-Exchange-RoutingPolicyChecked: StLK91yopUHJzoaZuaR8rBYwymenei56+rm9IZ6ETPGdBHgBazMCE7rya7uUqGb2hgR8razZoinjxHAEzmoeHyfpcXuiJWXeWEZxh4lhj0Paoo5RE5t36AhSeql8E5x+I8XstHiC70HGqizHQxl7wc3cGTfEHAYA/zpoxwjx58OKXAnIs58K8lwB28SWDtiTCEKXnHYQRo7Pc8iHyLy8t1l9CjCVRYj93tmiRx/NRTEu2viogSI0dtmDE210WkDkAw0d/BRZQTOyHNRPYbk8AvFDZSifaOya04oTPYJVCbYE4y3j7NHhPN6QerG/bR5vbQXvQy0vDQ8uPU19LGzUAQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 99140a3d-a2da-451c-11c3-08deddfb66cb
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 20:48:16.5831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VdnyS4YUs31V1YYybzq81UP1uG9YDrLHsTvc7eXBAcuIy1ULEXJvf0McgjsqUYVh764EtaBoILq4DV74yIojwWDibYLt7qonSA2A9KM0RdM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7349
X-OriginatorOrg: intel.com

Hi Tony,

On 7/9/26 10:41 AM, Luck, Tony wrote:
> On Wed, Jul 08, 2026 at 03:45:03PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 7/1/26 2:35 PM, Tony Luck wrote:
>>> The resctrl AET code uses intel_pmt_get_regions_by_feature() (exported by the
>>> pmt_telemetry module) to obtain pmt_feature_group instances that are populated
>>> using data from the pmt_discovery module. The returned telemetry_region::addr
>>> values are MMIO mappings created in the telemetry driver's probe path,
>>> and resctrl reads from them while a mount is active.
>>>
>>> However, a user can unbind the intel_pmt driver or its parent intel_vsec
>>> from their devices via sysfs "unbind" attributes. Unbinding either of these
>>> drivers would tear down the MMIO mappings, leaving resctrl with stale pointers
>>> and causing a fault on the next access.
>>>
>>> It is safe for the discovery driver to be unbound. It does all its work at
>>> initial probe time and saves a copy of the features and RMID count.
>>>
>>> Set device_driver::suppress_bind_attrs in each driver so that the "bind"
>>> and "unbind" sysfs attributes are not exposed and the user cannot detach
>>> the driver from its devices while resctrl (or any other in-kernel consumer)
>>> may be using the resources.
>>
>> Unbinding via sysfs does not seem to be the only way in which resources that
>> resctrl depend on could disappear.  The "/sys/bus/pci/devices/.../remove"
>> interface looks to be another way? I am not aware of a way to prevent this since
>> this represents how devices could just be yanked from a system. I wonder if
>> resctrl should instead protect itself against telemetry resources disappearing
>> after mount with another helper that telemetry driver can call when the device
>> is being removed or the module is being unloaded. When telemetry driver informs AET
>> that resources are going away after resctrl is mounted then resctrl/AET can return
>> EIO on event read attempts? resctrl could possibly recover when the device/module
>> re-appears but if that is complicated then user space could just be forced to remount
>> resctrl.
>>
>> With this there is no need to prevent unbind here since it creates a false
>> guarantee to resctrl.
> 
> This sounds like a complexity road that I'd prefer not to travel. The AET
> enumeration is handled with a contract between resctrl and the pmt_telemetry
> module. But the mapping of MMIO space is handled by the parent intel_vsec
> driver. So to get notifications of impending unmap of MMIO space the intel_vsec
> would somehow need to be aware that pmt_telemetry had handed out some pointers.
> 
> The "remove" interface might push this trail up additional levels (to the
> PCIe bus driver level?).
> 
> All this complexity to avoid crashing when system operators poke at sysfs
> files without understanding dependencies.
> 
> I propose a simpler solution. Just have the AET code defensively read from
> the MMIO registers with a new function that turns any page fault due to the
> MMIO space being unmapped into an error return.

A simpler solution would be ideal. It is not clear to me that there would be
a page fault though. I looked around at what other drivers do and it seems that
readq() may return all 1s in this scenario? Consider for example, how
IXGBE_FAILED_READ_REG, PCI_ERROR_RESPONSE (note the comments above its definition),
and PCI_POSSIBLE_ERROR are used. Some drivers just straight compare against -1 like
the "if (readl(dev->bar + NVME_REG_CSTS) == -1)" in nvme_pci_enable().
There is also this related snippet in Documentation/PCI/pci.rst: "Most x86 platforms
will allow MMIO reads to master abort (a.k.a. "Soft Fail") and return garbage
(e.g. ~0)." Handling ~0 may be even simpler?

Reinette

