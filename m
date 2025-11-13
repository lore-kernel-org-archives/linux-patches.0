Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E552E4274
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074325; cv=fail; b=bpjY0bC4p4JNUhY/ZNTJ5lltyadaHEP+13XaJwKwJmRTB7nuGnLoLo3lEHt+cgASNLgwBHU4EemI932BgQ4Nl/stZWN8E6cCPFYIyprMzFoCyedyYSqEjLR5X4GHMyeAYGrPvxjbb/+T+MobwWyhW6Ip6HQTkuXt5FTivgzkt2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074325; c=relaxed/simple;
	bh=KcLqVEmXMfyw5n+ceurkwDFoLZHxv6/ciSBBwUbEJ+g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O2Vx7M471BQfSUEspl6B1yePPDTpLQ6Y7De66eecJX1wmnzPINfP6CjopUtbHPfMXBZg5RXg0sQkm+ahFxHkf5qbCoaAqKW/miMKBX2Xd6LnMOE8f/P17kdBWTTKDYxsj8qMVz9ZD0ykTIPVq46SRxllRiZDCO2E0xQ/HwkL2/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZLDs+IH3; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZLDs+IH3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074324; x=1794610324;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KcLqVEmXMfyw5n+ceurkwDFoLZHxv6/ciSBBwUbEJ+g=;
  b=ZLDs+IH3VWlE7LTktV3ebgaCAGlhAaIr19D5tl9gUxLarEHyX0bT8R2Z
   LG28HdH1Ea8B8m33iVp0RChSOh5cHjHw1a1fLsZzEX3T0htlYmM3WvFL+
   Pm2xHucG+KaBrDaCaFhblHNDp4g/HQ7mqSXZedO3CWhhHPcSZgNYp3wa+
   Yg6VZSsNkzAzvc7WcYsjDeBQQaSECA39WxgNn26MNw7B0ZUBa3NvQKUkt
   Rroz+gBgolRcILMeRozy2NifVXPXPQk0A9Cp74Y9vbSfStArnyJ5jb5ZK
   tUBfKXAhp/W9lTIk/8MhyMkYKbjU7QZ/eEo1GfIbJcV3FuPCycg88y2QL
   A==;
X-CSE-ConnectionGUID: i+oWMd3MSvWJmV++sl+tEA==
X-CSE-MsgGUID: NbTrOIgWT3qv7Seohp16uA==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="76627320"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="76627320"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:52:04 -0800
X-CSE-ConnectionGUID: pxtjcmukR/q8zVEvFIvAxA==
X-CSE-MsgGUID: sCNQ3IDlQVCfbIQZb2vygg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="213027748"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:52:03 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:52:02 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:52:02 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.38) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:52:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D2zQIeXHO9NRyrIrtnbVyIvCRkOvoZ7nIx8zsWrH56eXnyOoVddQ5uvvsGJ0wSNaSBxzvoJrSAKE2vNMjCyLKU2mArSkLsTePgLo6ONmP4+dnbDafbTHQmBXrjMQCpf0H09Mkosvar5/RyOIpat+iWGGt0VqoqUtFNwh0HC0lEpun56q18qMpWt/D7j9Sh8PA8hFl/a2KxDB1XmkX0mBjyXK6OJ2kH5ezAV+xw0fer/RA0iWBSkFQVMMhFuIC9e24KzvOlbgwl7gxihF+w15lppNJS7YMSzQfFxxZ3tQXoRw3TdyMwqDsaLYjWFNE9HuuKQsOTylXgq7/6Dn/Qbv4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cwGCS+e4FlXxidxEe5nVOwOW2B5Qc63GzpzeOj8vaYg=;
 b=LypJR33Ad/+JDsAFM9Q0QdpZk3byLLd4qF921jOd3qUaBRcqsZyt5udVcTDzNte9LdUXsjBbxcJpg+/D0ylxQ7w/foM9S2pSYOvq3FMfUr4kzGm/PPNfGpfftSGOrapQ+QRsdwXwKQBt+nqrySOBW5wxyQuXvReujBE8iYHcVxfRrJHp9DgTI1xzoWLeMDyEEsJyRVQWHgJWsIkYuduKjwBQUomRsHHv181PJdO4XOZFQ2O7h0GAwpr4X+3mOte8a7B+EADHjbMwM26JKBoYtBQPK/HhEMWMedP4nGQDLE1dO3n+Rd9mnSqa6mgz7fwemLrlTDs73YyG5bfvQ3voww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:52:00 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:52:00 +0000
Message-ID: <25334395-d22e-4ff9-b393-7f776eb15d6a@intel.com>
Date: Thu, 13 Nov 2025 14:51:58 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 26/32] fs/resctrl: Move allocation/free of
 closid_num_dirty_rmid[]
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-27-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-27-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P222CA0029.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: bc40e2c4-f712-4ad2-299a-08de230741b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?blRsKzZ1OE5KZm55UUROTmVYNVp1eGhnUWhjRGt2eVF0d1l3TW9oeFRNREhx?=
 =?utf-8?B?WEs5eEMyMzNVQ01yUVFNb1N0MEhuMWVTSjlKcDllaXNtNmtGaVNlSnVaYnV0?=
 =?utf-8?B?WU5VQ1d6TkFsd0s2UERzYXBpWUZGeUFwNnFPY200U2ZpMXoyK0dSaER3Skp5?=
 =?utf-8?B?MVF2dFp0bmNwNzhRVlk3eVhObEtYbndPTWdPZjFUSlAxclh5bkNDM1ZCNnps?=
 =?utf-8?B?SXBwb3AwMGI2aDAvL1V5U3phVnplTkR5YnlHN2JuazE4REhCMDVIYmxsQ2hP?=
 =?utf-8?B?bGVieVhNODF2bjcyWTk1dXJvYm9BYzd4bC9KeDd3NDF6YTNuQXlPQUNXV0F4?=
 =?utf-8?B?OWhFcERvejdkK2hVN2V6R0w4alMweDBBdklHcHVoMHdGV1RZeHhaWTg1UGd1?=
 =?utf-8?B?eGIrd0Y5WE9yZ1J1WkhtY2lUcCs5NjJselRadVVsZjI2SEZ0SDRJaXNacjZB?=
 =?utf-8?B?S29FaDdmZC9JWHIrMVNCQTdwSXJ3WHIvTTl3dk03ZS8vZVQzRWNCd2VZaVgx?=
 =?utf-8?B?elFDSjNHcTNLaVhHcmxuMkN0ZlFtQWM1eWxGRFZhZlFYUjZkalRoWUZib3Fa?=
 =?utf-8?B?V1VrdzVJdStQa0NBWGJOckhRQ1ZoMGFxRDFtcXdKVWpoUnYzdnppb2p5Wmdp?=
 =?utf-8?B?VnlyRTJNbVFlaStZT1FIOXlQTEhKdm5RRGU1ejdpdXpOalozV3Ziem04VWd6?=
 =?utf-8?B?a1NReXJNc25UMDNldU5BTER6WnpYMXFoWGFGZnZDalh6TnR3MGNMVWlRcFo0?=
 =?utf-8?B?RmdJM01IVHp1cFNoQ2MyT25PemxKc244VDZrWFE0dnN2cjBxNEx1RVR6WUtB?=
 =?utf-8?B?WkY5YVdKNlducmV2amZDYTZjVmQ5M25wR05walhISEJSL1B4eGRwMG1GQ1FS?=
 =?utf-8?B?dmpPZk1Nd2lMOFg4cXRGT0ZOMUxib3RrcUNVbS8wYU9QaUxIM2toMXZzT3ps?=
 =?utf-8?B?VTZlZkxxNWpnVUova3l5bkdiSHJaSGMwa1FJazNtWnd6RGtEOHg1ZEZXN2V1?=
 =?utf-8?B?Z0JHcytsNml2dEdhYVhWajZFZEwxeXhkRTQ2SWY3SEswSWgrWjZyelN3NTVX?=
 =?utf-8?B?THRSV0tuYkh6S1VlUmRJWm5IWHVXY0RCTnhJYjRpcGszUG52ZGZDcy9nbDFW?=
 =?utf-8?B?ZmJ6WFZxM0pZczRCNWxIUkFqemd0azV6Q2NMM1RLQjhUNFhzQjB5dzkvKzdR?=
 =?utf-8?B?bTdkenpLamJ6eXRRcG5DM0pseFA2SmdNNHBHNUJZS2pKMUdhd0NSQVBmeFlm?=
 =?utf-8?B?aUFZVjhNL01WSTV0b21PdXNkU2tJZndiRUd1VGZwcXJwa2N4Zk9CSENmOHBy?=
 =?utf-8?B?TGx3ajk2cmgvR2Y4ZnZ0eUcrSXhTZWxKQ05KdWlENU1KUDJNNEpvRkR2eWxZ?=
 =?utf-8?B?blIyd0E1MmJ6OEpuSlc3K0dxVzhxcmNiQk9uYS9YRHRFMmxXSHlkWk9wUU5u?=
 =?utf-8?B?UmVtQlZsMDRMV1Nkc2pFeU45TVBUbVlFMHlSbmorekkvSk9IWHZidUZoN05n?=
 =?utf-8?B?TVJuaUlWTWJjZHJoSU9MM3J4YldoY3B2cHJreVdDWXNxNnVVZkhGa01HRW1I?=
 =?utf-8?B?R29PVTRqZkpsTTlZYzhrRld1SDhOSVFicVE2cUpmT2xlb3FldnlJM1lkK1c1?=
 =?utf-8?B?VFdGSVZIdzVwdnRrcFA0TFhLSTlsamY0YmhSazhaSGZTNURGRC9jY3VXVjdk?=
 =?utf-8?B?Sk5pakZyaFIrekxrLzh3MjJQcjBnVWY4QmNuMCtIYTY5VXRDZXpQdlkyWnA3?=
 =?utf-8?B?QlNHbkRGTGEyeEw0bGJxVGVZNngwTThYK3N5MlR6Ky96eVJ6QUY4bWFpSWxO?=
 =?utf-8?B?dUd6c0pPZEl0VHpENXAvelBBWFcyMkpvSVBtR3l4dDgzTmp6TWhlK1A0T3Yw?=
 =?utf-8?B?ekVYTzV6SnFvd0lDNUdGN2JiR1Q3K0hCRGQvZDdqTkxEcnFkYWRKdkFtanVM?=
 =?utf-8?Q?hGHgWqyiV+6DVm75zC+5Ki1OTMGaV8xv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1YxZEwrK1g1NUsvU0xVLzFDejRqL1UzUUhiRkVKb1A2UWNUOU9aUkNkK0lP?=
 =?utf-8?B?Tm9CamJvRks0MVdTQ3p6QzV4cURHcmlUWXBDTktTU2ova09JcE5OTlhPQm9w?=
 =?utf-8?B?SnJFd3d4dk0rZitEMUFMM2UwWTlVbVptUmlDU0h2RFdjQm5XbEZIOUFiV3Fy?=
 =?utf-8?B?dkJQUGE5OGdtQ2x2NXA2bXZ3RGtvc2ZpQTUxaEJwZnZBZDlSakd0cmU0UEtD?=
 =?utf-8?B?aTVwb2dvVXpjK2ZGOXR4MnVoem80T1RZcFNLaGpWV3J4eXpwU0FpREhyU0g2?=
 =?utf-8?B?VE8rVTNDZkFpYml0MTJydEJPblFFQ3BLd2hCMm5jT2VrZzBtbCtRMk9RT1l6?=
 =?utf-8?B?OGMwQmQrcUYxTkswclVCcXRENjZTNENHbVFvYWFUZU9TaStNK3d5U1R3UDFI?=
 =?utf-8?B?TS9nQmo3ZnpmNndhMkt5bzcveC9RbXpvelZRbDJSM1JZa2JSQmk2U0dreGNX?=
 =?utf-8?B?bGQxQ0MvSmdqWnNzRER0R0I5Z083cVc1a0JkOWJsSXdZR3BvOC9sRzhzTVdv?=
 =?utf-8?B?WDJ3a0tqNjBPWE9BVU5NQStwUXMvV0l1bTNsVFVEYk5RcmVHQWJOb1VncG5o?=
 =?utf-8?B?bnZldW9pb0tLcGFCNXBBU1Bja3lkelo2VVh3OFVHcTJQblZsTzV3a3hHWTVE?=
 =?utf-8?B?ZlIrWXZkVmRiM1VWSDc4T0VLVFc3Ti8zcmNGbi9mUlFlWFp5eDdINzgxckFW?=
 =?utf-8?B?RU1QbEc0WENLQ2VQVmhqTUp1NHdFb3RpcmpwTm11K256R2RFcmJ3L1c5RVRz?=
 =?utf-8?B?NUVRSzZscFlrVndwekNmZitTVUdtWUUvMTYrSjZnMmtQbVB0M29FaEdsa1dq?=
 =?utf-8?B?K2grYVRiYmt6ck8yZjdtU2hPWlFLZktZNURkTW1HcnBPeHJ6eUJsQWFob0NF?=
 =?utf-8?B?QWw0eEhnejV2NWlsVXN5Y0xubDlqejN1UTBPNXhsUVNqb09KM1pjVmx4OEdn?=
 =?utf-8?B?S1QrVlJmUGFFWVB1TThwZUFMWTZPNjJMN0JPOVJDMlpPUmhVa00rUlVnQnhu?=
 =?utf-8?B?YWJybTRRR05HTElXRnNURDc1SUxHMkFtUHE2OHpkMkJLdzJFQmZuN1JpUHlt?=
 =?utf-8?B?R1JsMGFGaDZXc0huZUp5eW9wc3lyYWZPOERDN0ZXVWdmNDhKRnhKajl0ZVpD?=
 =?utf-8?B?ejZmZGg2YmRVa1pYTHVETUJOZXNaMkdFZXZZUjgvOXVBZnRmZ1ZsQ2FJeGRG?=
 =?utf-8?B?eE9YYytJVmlXdDdZWkwwZGxJUlFTYjg4d3llaEpmbmpsR2VJNTRGWjR6Z2JS?=
 =?utf-8?B?ZFdTRTltZjZJSFdoeGFNZVlzSVdTS2ZJY3Y1NVpzbWR1RDk3U3MwS2JqekUr?=
 =?utf-8?B?RC91VDVIUXI1cjVLbytwUEwzVytjWlFtcDlqcWI4NGEzNFE3TUdFazRPUm9I?=
 =?utf-8?B?ZE9EL25MeHBFSERiS0d3b0ZTTUl1eDk1Zm5OajRPaUxmSjJhZzUyUUxyV3h4?=
 =?utf-8?B?VmtsdXAxTmdNa3lpTHZqdG5KUEtFc0N4MFA1emczYjlrSXBSMEY4YTVLYVJ6?=
 =?utf-8?B?OXR3TWNhbXJOa2F5WjJYL0RWb2VkeXRyckNOdWFtMFBBUWxBeG1CajhiV1Q5?=
 =?utf-8?B?VjVkZUJoUDhGRmVDQ0NscW9BeU4vb0hLVHltcUhybDFCb1pVb0RDTXlMNnpY?=
 =?utf-8?B?SG5TYUIyWjVLb04vVVkwQTVGdThuNHRMbHN2d3d4LzBxMjdjMWRuM2JIaExm?=
 =?utf-8?B?NUNKZDZRRWJSSnl6b1pPNmZTcGVWNGtYMTVsd2hoUGZjd0c2MlFzNTBjMGMv?=
 =?utf-8?B?REtTb2RSV0V3WlAvWEJ1NmhDM3RCcWh5NXI1T3R5Z295dXZyRmlpMXFwdjQx?=
 =?utf-8?B?VFNPRXhmN25GOFA1NTRUSmJTV3kzRzE1WGR2aTRJK0NGczMyekhJRlF4THlu?=
 =?utf-8?B?eVpqbEtMWG9BYTRzOEJuVHI4WWlHWm0xWnFsdW9IT0UzNFd5Sm1HT2NyNk1r?=
 =?utf-8?B?MVFabTNoVndVQm1GdzlVUHVOWUJvaElWRDl4eWlsSjZxcG1oQyt0MEIxQUFt?=
 =?utf-8?B?UCtRcFlGZVdEajJqczdPRDN6SHo1Z3NBSCs0c0VVbVd1ajYyTzViYms2ZkRS?=
 =?utf-8?B?VW40amxLSEhNbWFEb0xnYWRnZTZ1di9ranBZTVBPVXhxOUpLMkVhMzRRSHR0?=
 =?utf-8?B?MStYZzhwRHBsVXZmM3dDZlZQQ1RFdzczMTJEdUU2aUFOeTFhR00vNkRXTkpl?=
 =?utf-8?B?TFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bc40e2c4-f712-4ad2-299a-08de230741b5
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:52:00.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Vlz4iZQ2b+7cQnguY2juKj+KenvGQLm1RALT/FYiS5D1QgH7MjjdU1prd3DmZ3Jgd/zIsq2BkwaH8Mlys5H03GVt2KMuaRpEN6Y/97a8iLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> closid_num_dirty_rmid[] and rmid_ptrs[] are allocated together during resctrl
> initialization and freed together during resctrl exit.
> 
> Telemetry events are enumerated on resctrl mount so only at resctrl mount will
> the number of RMID supported by all monitoring resources and needed as size for
> rmid_ptrs[] be known.
> 
> Separate closid_num_dirty_rmid[] and rmid_ptrs[] allocation and free in
> preparation for rmid_ptrs[] to be allocated on resctrl mount.
> 
> Keep the rdtgroup_mutex protection around the allocation and free of
> closid_num_dirty_rmid[] as ARM needs this to guarantee memory ordering.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
