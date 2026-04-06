Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E56306B31
	for <patches@lists.linux.dev>; Mon,  6 Apr 2026 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775510223; cv=fail; b=tyyICuONtUokBN3Fi2IrtKFNNLW1UH6cTd7o4v5+8gokLqsP7QVZeZAUsKrW2FA55EjXoMD3sHUaVSEm43xHiWy92AuJVnpcGIJy4n13hqPiT2uVG/zyRMhTyO8PyWyzMx8KN8gHphP+TL14IcTyqmqsLWrfKXQorocKgvarv2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775510223; c=relaxed/simple;
	bh=kmJZrsIfN188PwcX+/YzjrhleKTuYsQAAecdK7l1KMg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d+zukAQsNxPhCdq7ng3CQK57OzJt75aO0lCJ8o+yoHoi3tb+sO72rjuxzbZNPjnv0zZdQJWs6PZvafTJ4QkpTxlKPkWURVys1DrVMdxtBtEA6z8tdxPD4B4kBhZ+uzvwsYi7ZRqPrzsGui4m+QbsrD/ab1lfP5rV3JzD0amHQos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AO6jj5y1; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AO6jj5y1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775510222; x=1807046222;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kmJZrsIfN188PwcX+/YzjrhleKTuYsQAAecdK7l1KMg=;
  b=AO6jj5y1Lfd9vWvGAmLaxv05hqRAytbeeM5B/scdtzWQPCQFL8ib70r2
   8oZTNXIX6+oSjAKYrUhfelkzKUf3PRIyyX1w0rQpQERN0MKVCrA8BU3Oj
   in8Ue8AChwS1QuMRBb4gzRFvlket0yehfFpeKvMV30xLZ5qJnCNeG5/ZM
   ddcSEj+3YxqFTu10MmAwKtKcF55C+LLkxAze6mzBfxUD1gy7qIjo9oMsr
   JByAnrUvbVxVVstq+x/dNIHu0PKzjkkrHPRKEzU98GcFUF9OTR2sVmblX
   I5CPoCmfnO/mdyny0mW9/FNWa2s74tbbfHslw7JD5HJFM3nZFmDw+az1c
   Q==;
X-CSE-ConnectionGUID: EF4TVg0UR0+z8jDNW/TFZA==
X-CSE-MsgGUID: hKpMf5q6QvGwPhmKEP/N1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11751"; a="76474954"
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="76474954"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 14:17:02 -0700
X-CSE-ConnectionGUID: aLlNkNhDRWWJYQHFOmGsTw==
X-CSE-MsgGUID: 04nIBnS7SdOJ8/cfTwBXHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,164,1770624000"; 
   d="scan'208";a="227144885"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2026 14:17:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 14:17:00 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 6 Apr 2026 14:17:00 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.19) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 6 Apr 2026 14:16:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A0qQ2SLo7ujILOXD3xNDNw9pJXIwzQQWHAZ4kC7hbiieOZ9bfZwVEpwcMj4fS4i2DJF/TcEJ4CXyIhveXj9jhPeO/k/a/4GX6wW+2Tgo+r+d7tRaWkEWoyBuMwNW7aINFikEkx9luesr7kKxA6qVe8ajgF7k/GmjCwWPY3ILG8b7zAGHkNVGwjvrQOb8uyW9mTzLn1gggTJXbOOU4jCzBtcismtzijd8l7OzwzsBcEbETp7gboX2qDjRGyrymxMk72NS/qI1RbVJOcdQ2SkbcflEiM1OO3EEy+Pk9oVU/eVg3+eX3MwNZuC2hd3bvoGKML5BwiviJ8mexxX03HGGTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpgJ74Ysd75BWizqz1sbeV80P75hW3f30Id8wNTKBb8=;
 b=WoPxw05PGEfNm5Uyl540l+hlEdhE68i5CyE87SrshbyBb40YT5U3KiS+Yj5PoSZ41jCThyGKVnXmfRbm7bodr8LVOkqt/xGwmkLK98X/745KYuKNQooetqgxEJW4EtCRpbAcqbt3bzhqw9syy7UmOFv01UWdV20e5D39H+5czgy8UU3Kh3KOG1q2FJyimxtsyGB85V+5I9MTxv1JTbJrmsclOGq35GrMzMB+5vzWkAmKLNL3xCU7QOX9urxPWH1Q7Swu8gxijqbd6HauHVUeigo4EWgvCM+UjQmDqS62Gmz7cIj/koXQMud3q0fAgiN55gHYRrcpnQL4MGEtZIloaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH0PR11MB4918.namprd11.prod.outlook.com (2603:10b6:510:31::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Mon, 6 Apr
 2026 21:16:50 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::bfe:4ce1:556:4a9d%5]) with mapi id 15.20.9769.017; Mon, 6 Apr 2026
 21:16:48 +0000
Message-ID: <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
Date: Mon, 6 Apr 2026 14:16:46 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, David E Box <david.e.box@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <adQY_m8I2jUiR88k@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0269.namprd04.prod.outlook.com
 (2603:10b6:303:88::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH0PR11MB4918:EE_
X-MS-Office365-Filtering-Correlation-Id: 460a51a3-0d04-4f9a-ff5b-08de9421d017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: Ourw3zJPcQs0Hg1ShA8WNj9piIMHJ1YrDcAM/j2KD8kKIRuTZabrn4gbDiuyw5U5N/6U6TYxPFqugldLkf6ISvhTBGbUJXO6ZUc+zvwu1P7jaDq7VFTrhdGir//MBSXgLTIKRHMDtxFU79NZrBsEg1hN0svz5PyW8+Br3k6pas5LZco00X+1MJl2NMQJhBX8LxgVqxr7UvOcjG5Zf3uyS+pCFy7Ck24lPp+svy1Q0aJH5kQQcOw6H9aFDfIG0hB/SEjwpWJ3Q/r9KP3Wxr0tcqU4+V/pJmnqXYARKqB43dG7QI20Hi6wXMnO6ntdJHnzjVopdGwOWyXw19gUrsXxuO7Gs0u8FlIqAyYCY8aca6Oxj+P8+TdGsjCSWU/Ewx7iKEeh7dLe0mP29JSuYdXrHeC/3qAxJT8ceiDtTe2Em5bRZpusYjK/soiKU8Qd5emviaG4wHOnhGuSFE+VOnp32g1MQnqOe+zd2tZPHdm3Xg3fp70lnwNiZob/sLhAVz1FYsLzw9tvJLGvqzbkFiPJdpuI5966g3u/Pv0IsDQ0WH8OQVvFoJAgsq4lubQuEDLQ90bnTw4gDWQMTIFsZ9e+BCT/sgWiTYoObyKV5kBGVSfNHtrIWLMDM6O1T7CthoAZQ/UAL1UUbQcLO35YxG4uTy3Q+XEKoAjeY+et6HuWu1AHbIJiYbqrJaeJa1d9XrZuMuh4Y7fHWTghDjDFsMiimatEiXjKDdWAOJRNaEw+6LY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S2lHd3ZhM0U4V0FVMHdBZjliSW5jeDlmc0pEWmxsN3l4SDBTcmFCazJQdEk2?=
 =?utf-8?B?TUd4dkFkTnFWbC9Cb3ZrZTgvbGR5aG5YMG52YzVtV3VSQ3VxUUR4d3BkUzdV?=
 =?utf-8?B?bWZuR0hRdzUyL0hLTzZkU2FBMTN5V1ZZajh2WUNKQS9pV0s5ZmdJTEZlN1lR?=
 =?utf-8?B?bEJHdnhhUkJhYXlKYjlpVXR6UzlxT2tCSy9LclVuNnQ1ZkZ3WkM3ZHRIM29i?=
 =?utf-8?B?MjNtQ0pXWlVYMmUzRVp6aEpGeUFUVkVIWkRIR29nR0cybE91a1BGcjZQM3N3?=
 =?utf-8?B?TFRnWUMwU3VTZGZ6YXdFcGpZRFVPdVp2cHpHdnNwTXE2L0p1NkprREZjSEUy?=
 =?utf-8?B?OVcwRTBIRTNHL1pveHBnVm1TZnNUaXNKamxjRmp0a3ZEemxZazdYNDNRbGJr?=
 =?utf-8?B?Und5dFVZOEtUaW5uWWhTU2JybHdvMWZlV0JVVnFkQWNTdzBsMTQ5MUNkcW1V?=
 =?utf-8?B?bjFweEtZUlNKV0ZjczVMdGxJa1Y4VFVMWlpSaUs2ZzFXVDJLR3dKc1hlWUNm?=
 =?utf-8?B?OEZERHhOU0tLZjdranFrU1pqTDNFWjY4VDFWWHMvSVptM1JNalBxcWo0cGxl?=
 =?utf-8?B?V1BhZjIzOWxicU0xNlZ5SExhQlJ5bDluc3kyK2pWc1RvZ3NsVGV6L2hPYkU2?=
 =?utf-8?B?Vm1OdzcxTlNjaFpPMmpWMkVIandYcE1DeTg1Um9MV0dkTFhDQ0I0SmFydzhX?=
 =?utf-8?B?NFpMbUpCTHdYd0FVMERRcmRMZ0V3OE90WC9zTmlDZ3lxUGtTMTVpdEJwS1dU?=
 =?utf-8?B?blRKVFB2SUVWa21NUC84a2Ivdk9reXRtdHdYTGVrSDNaN3k0TjNMSFBBbGFj?=
 =?utf-8?B?SldqQjQ3ZGR2cDZod0R2RlNmSWtPelVrWlRnZC93aFZOdlhKdm04UEdOazhE?=
 =?utf-8?B?RXltZG1hRC84K21jc0NuZzcvbkxKU0FRVzhId2hTdjBQLytQc04xM2g3WlNI?=
 =?utf-8?B?dWtqZmYzVnNpQXlBMkdwaTVQYnlPRU9NNWJLclVDRXFETDVIM2lQRDErMGh4?=
 =?utf-8?B?QkJqdDBUUHo4ZkNXaXZ4RWRmSm8wdFAyV3ZIUkhFTFhRdkViRSs5S2V2Vk9m?=
 =?utf-8?B?VTF3Y3BxenlFS3k0RHgwZnpMcmV1emF2N3ozUHJKNnVSVnRHV0x3QjgwNmJD?=
 =?utf-8?B?bjNUaEs4MWpPV1FZU050SmlBNUtoRTFCeXF4TXdoRGtlcTJlUzFiY2lrZkwr?=
 =?utf-8?B?eHVKZmRBWUhncGlERCtkdTZCUEo1WlY4ejlkUHVEU2IrU1pxblBGR3VRaFJ1?=
 =?utf-8?B?VFV0MCtZVVdKeTlCcnI2ZlpWdklCZTdzL0h0ODhCV2o1SUhCTFl0eU8zRC9E?=
 =?utf-8?B?WXphRmNSbFVERnliSjc5MGdFejFMWWlqL25CQ0lnVC9OckxzazVKWFJ6QlJ1?=
 =?utf-8?B?R0FlNGJMcTJpNVRMMkxXc25SZCtaR0ROYzFNUzErdzRpNjdEUktlQTVLNzBI?=
 =?utf-8?B?U2EvYzlHc3g3NFhDc0d6VHRzSGV1NTJjN1RTUXI2OERRRThwNmZHRDdEVlZa?=
 =?utf-8?B?M2JwRXR3anVSclB0UU9KRm44L1lZcGdnQkFWQVRIWnlNakJqWE45SlRKWEFG?=
 =?utf-8?B?QW5tbnBxWWVWbUx2V1lJUHRFcDhsNTdwSU1MTWhMeE04M0E0L2VTUDZvNkda?=
 =?utf-8?B?L2ZhS2pjSitlUmpJMWdqTXpTQ29HOXFrRm93YlpSTVQ1eittVlVhbEZmaWxs?=
 =?utf-8?B?SDRCaGxqUTZacnMrQm9hc3Z4RjJlT0tnN3AwT1pCWmIxTUtzMTFQVzg0Skl0?=
 =?utf-8?B?Y0NGTkhVLzE0YXRGcDB0RUV1OHY4RWQxYU9YMjMvOE13cVF1TkNPd3o0TEhJ?=
 =?utf-8?B?VlF6NGRnM2dSSWg0MHU3SmNEeVFGREFWMnpvYWN0WEdPU3VzWTFyTkJ6VmpE?=
 =?utf-8?B?dzVOVE5vTElFT2ZVaHJVTkp6YVNrdktmbituVzg5cEdwaDhrc1lwdUtHb0Zl?=
 =?utf-8?B?bE1mbzIrclpkOCtBWUJITVFPb0ZIbGtsUnR4UmgxbVpCNmlDNktnTW9HZnpG?=
 =?utf-8?B?aUU3NFN3TDkxMm1wbGo0VE8yanRZMCtYb1R6OTQ0MThwUHdCMUpZZ0NENS9B?=
 =?utf-8?B?SmVJUG5uV3htbFloUUZMOTkvSFRWNXdDNEFGaThiVkZvcEEwajJsQ3U5VnhQ?=
 =?utf-8?B?OUtvY3J1dkw3N2lpcloxTG9ZbUp3MnFaZUNVN3VXMzE2MFFOVnZHUElweG9h?=
 =?utf-8?B?ZnlhNFFxemZONk5XYjZXTkZ1Y1J2T2xPSU9tVklwZC9XeE1yT3BGZmFEa09r?=
 =?utf-8?B?eWNaUk9tZHJVQ0Zqenp0LzVMR3M5NGY1OGZLWms5TEZPbEhlREcwNC9jVUR3?=
 =?utf-8?B?TGtkQjBVWVdnRCs4NGtlRWpCM2NFL21Vb0VKcE1qVjJqcHl4dFBjM1htbnB4?=
 =?utf-8?Q?trLz1H3NffwdR0hE=3D?=
X-Exchange-RoutingPolicyChecked: vIDs1P8bi8ClyU5TOtgH5Sfu3wGXrAwcqkyvFZD/ZcdNiuiL2I/eJSuL7GCXecw9+ZNpFiMZtDAvthp3dokPX86c8I9w2sPLrHnRS6f1aaRS+9RPzE+R7Kc16u7lrlCkpekDxqTkQTC7bQbMUwM6FVoo7J9GCtSj0HSjYwe+7HmTZ/jj8dLOk9RF0//aaClQ+pGA+15vHFqeFZj0jyDvhaq9e2A/9NIq8c4UsPZrpBvIGHPOY5Lik5316ltMpKYYqD0Ni+WTH9Nwi/nC92/3YRM+Pba4HH8ud6IylzVxAUiWU5hT9byheQLvMQ1SwHt3Qnfa89nGYeWSWH0OKWlqDQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 460a51a3-0d04-4f9a-ff5b-08de9421d017
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2026 21:16:48.0373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSI5J9w8dZ04pLNmEHFrzkDGhr+vjcafpLk9Fwdg7yutrcSJAzDlCJF+Zl36Mk7n0qm5UMzymUWe0ZKKTvFl+POQi8i91dHMSjecf7OhhVA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4918
X-OriginatorOrg: intel.com

Hi Tony,

On 4/6/26 1:35 PM, Luck, Tony wrote:
> On Fri, Apr 03, 2026 at 05:52:30PM -0700, Reinette Chatre wrote:
>> On 3/30/26 2:43 PM, Tony Luck wrote:
>>> Add hooks for every mount/unmount of the resctrl file system so that
>>> architecture code can allocate on mount and free on unmount.
>>
>> Please use the changelog to describe and motivate all the other things
>> that this patch does.
> 
> OK. I will expand.
> 
>>>
>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>> ---
>>>
>>> Note this patch disables enumeration of AET monitor events because the
>>> new mount/unmount hooks do not call intel_aet_get_events() (which is
>>> not ready for the change from "just on first mount" to "called on
>>> every mount"). That is resolved in the next patch.
>>
>> This could be part of the proper changelog.
>>
>> Could patches be re-ordered to support incremental changes?
> 
> I'll look again because several things have changed since I ordered
> the series this way. But some bits got overly complicated trying to
> make AET ready to be called multiple times. If I can't solve elegantly
> I'll move this into the proper changelog.

Please mark patches as RFC when still working out details. When reviewing it
helps to know whether something is being submitted for inclusion or not.

...

>>> @@ -2900,6 +2893,30 @@ static int rdt_get_tree(struct fs_context *fc)
>>>  	return ret;
>>>  }
>>>  
>>> +static int rdt_get_tree_wrapper(struct fs_context *fc)
>>> +{
>>> +	int ret;
>>> +
>>> +	mutex_lock(&resctrl_mount_lock);
>>> +
>>> +	/*
>>> +	 * resctrl file system can only be mounted once.
>>> +	 */
>>> +	if (resctrl_mounted) {
>>> +		mutex_unlock(&resctrl_mount_lock);
>>> +		return -EBUSY;
>>> +	}
>>> +
>>
>> This does not look right. Here too is resctrl_mounted accessed without rdtgroup_mutex
>> held. This change implies that resctrl_mounted is now protected by resctrl_mount_lock
>> but resctrl is not changed to respect this throughout resulting in unsafe access of
>> resctrl_mounted.
>>
>> Does this new resctrl_mount_lock need to be in resctrl fs? It really seems as though the
>> needed synchronization belongs in the architecture. Could this instead be accomplished
>> with a private mutex within the AET code?
> 
> If you dig in lore for the v3 of this patch, you'll see I had the mutex in the
> AET code. But there were some complications.
> 
> 1) Need to acquire in intel_aet_pre_mount() and release in intel_aet_mount_result()
> which is legal, but makes code more complex when call chains need to be compared to
> check that the mutex is being released correctly.

Why was it needed to hold mutex for so long? I cannot find explanation here or in changelog
of v3. I did not remember correctly and considered the AET code to be doing the domain
addition. Even so, I do think a mutex internal to the arch code can be used to manage
the synchronization. Could you please elaborate why this cannot be done?


> 2) The "only mounted once" case meant extra state (AET_PRESENT, which you note
> in next patch may be redundant) because intel_aet_pre_mount() is called, but
> needs to do nothing.

Right, I do not see need for extra state. In fact, since it is not clear to me that
PMT enumeration will be complete when intel_pmt_get_regions_by_feature() is called it
seemed worthwhile to only rely on event_group::pfg - if PMT enumeration was not complete
during mount N it may be complete on mount N+1? This creates a poor user interface
though since user would need an alternate way to know if AET is supported and then
a "remount until it works" approach.

> 
> Adding resctrl_mount_lock to the file system code made things simpler. The

Adding complications to resctrl fs to make things simpler for x86?

> pre-mount code can't be called with rdtgroup_mutex held because it needs to
> build the domains. That needs cpus_read_lock() + mutex_lock(&domain_list_lock);

ack. Can an arch-specific mutex be used instead?

> I need to add more comments on locking. resctrl_mounted is only modified when both
> resctrl_mount_lock AND rdtgroup_mutex are held. I believe that makes it safe to
> read the value of resctrl_mounted with just rdtgroup_mutex held.

...but not to read it with only resctrl_mount_lock held as in snippet above.

Reinette
