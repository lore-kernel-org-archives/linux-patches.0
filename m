Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B50C28FFCF
	for <patches@lists.linux.dev>; Mon, 30 Jun 2025 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751305957; cv=fail; b=bgSY7WxeApy/44KWWkgOY1+39ob0VkmvcTGkcZCrHUtH9IDDvd6Mug8333aDDM2LDfoG0iiNY39mgboUhICI+pSSsjc+wC27NI33ExxngBCU8HP/Z0BVhFSmUuDOWIlqayRjywIhCzGTo3jEzC/YJ0NaPmXGyo6+TloctKkVWqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751305957; c=relaxed/simple;
	bh=/VOfCiD/1HdiTleaYDo4ocfkrQlgbVDPzjoD2KUQUdQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MAYvUQ1wNJqUBfYZq3lcNdf6uo3kBSfal+kIjtw0hMB9pGDS+P5+O5LFsI9gydW0SNVJCM9a66Ksy4QEO0CMm3JouGnKkz8UahtxzTfxA7oa2Xo+6d4j/Au096T/+JHP/3LyfT39EHHoeqsocUpBGHZV48F0WHsB6dl+/zdpil0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mx4pI3f5; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mx4pI3f5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751305956; x=1782841956;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/VOfCiD/1HdiTleaYDo4ocfkrQlgbVDPzjoD2KUQUdQ=;
  b=mx4pI3f5yG43L7+DvJqtg9szA95v+SbK0D0ZKq3sCQntWRBhM6BeYcKv
   CqDIVY7yRBWvsQ/yqPwgqwHTp5eN4T8NsHwND1qQ58cyqBKf/Pza+hBeI
   QhpGiHUXZCdbmnbY3jpAAfeNL2ppcNSemyeMETf8C5J0tMvXC3OquSS5S
   BjaWqSzscTAGZetv98vk17ZaO5syoD4XxQkljodVrE1m5kK+2ZeoOO4HX
   TW8Iz6NvJO9lGisF3vI/e7TgkaNfoNQRhBTj8ZTYACdyOOsNqkt2V5WyX
   KrbonjKqqSag2vDmkKLRAxdPvrh0sOYJjbg2Uk1k8wzrsx4bDgrZgN6gR
   Q==;
X-CSE-ConnectionGUID: FwtLmejsRL21y3OJTy+Suw==
X-CSE-MsgGUID: fXlVW6CvQQybXvkX3c6hVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11480"; a="57224718"
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="57224718"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 10:52:35 -0700
X-CSE-ConnectionGUID: IJJBkJNMTOWhKAdPhipsWQ==
X-CSE-MsgGUID: XdNDQnyKSGOjFoijXDDaqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,278,1744095600"; 
   d="scan'208";a="184548513"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2025 10:52:35 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 10:52:35 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 30 Jun 2025 10:52:34 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 30 Jun 2025 10:52:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AreZAAYREAS0DjsviNTn43S6zuuvJs1TPKJKwr1xlGKLvzwK41Y5k+ifUF0qQiDxcXkK9P5ZPzPgT+LeclyVUWt2Mqv6V36Jbecg/Ms9K/mIDix6r/WgbeJDegreP/CjwzPZzmXVTaX6NCAHy5GPDt9UrbXJIjtEiF8Omso5OZmvp1ZqFy36Udm9urMUVKziLSWuww70OL9JQCGI8ypnrg0h4+oKx56ib81pfn89XUpP5Ws58UXsd4wAG6dTyttDGwh9St1o5N2XXaxLDHBHO45UYfAy6tA2dojMHbTSGESL8S9Q8zHO/t8UzbJpwdPoO+2uCgJhJy5hbr9YcAIbJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=auIEW5igyLSj8rsfdp+Wdvrb8MlVtm17Vkmy9MUYtDU=;
 b=Kw4D76BY7fxUl2Tr4jm4pPDAtQYMos7QzKeWcauZtV8+UaWKM35szcovzhr7AnzbyBc2iKkitt8yL0TyPHGCQSeZxIFPy79vUHsHM36w5huwIMjHSaqI0EY8CfJY5Z0vJ2qt+JwE5FeqtbtyUJ7mg3Udh1iuyymIcpbDvbKd2v1e7cIDd4Qh7uiH7rqfBkKMcAB6nPHubrUoSEtxWs2vT84HmhMIPWEI2egZj/uG6K7Oo4o/oMSJjGyEaGyXyM8R0jgOKmbdOYEEiof5XR+kC+893u5hn2rj9l1INU0A6kBskAkKVaINON2I6rwYAltmJONT39ExdS7d7A05yBziLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6988.namprd11.prod.outlook.com (2603:10b6:930:54::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Mon, 30 Jun
 2025 17:51:53 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Mon, 30 Jun 2025
 17:51:52 +0000
Message-ID: <6485574e-1405-49c1-90f9-1955ac2777ce@intel.com>
Date: Mon, 30 Jun 2025 10:51:50 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/30] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250626164941.106341-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0061.namprd04.prod.outlook.com
 (2603:10b6:303:6b::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6988:EE_
X-MS-Office365-Filtering-Correlation-Id: 431273dc-fafe-4e3d-6f52-08ddb7fecbc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2NGT2JRRjRRc1ZPNDlJTy83S1V5Q2xXV3hwUjBFVENLNFN5ZkRvWDNhQ1U5?=
 =?utf-8?B?YnhqZTJjN09qclh0UFpwOTBpZ25meUFucTY4c01uYnd6SlpWb3VUZzA2QTEx?=
 =?utf-8?B?QytHYng5cEJTRkRHOFlFZXhIaGlpeXFiSGZQc3FGbDRkb25vUXVSdGJMM0o0?=
 =?utf-8?B?TXdpem5wMGJudEZIOThidlUwbk15Y0xSMkJXQ09yZURrRzlxbStVK3FaTnZq?=
 =?utf-8?B?RlRYeUJta1hBeFc3RTNTNEhDVlBpS1k5TmpSUkFJTHZFYk42SmpJaG5BVDBN?=
 =?utf-8?B?aEFtSjErMklKWmlwYVQyR0FXUExxQ05BeWF0K2lBYXdsV0pkVHpyenhZRmJx?=
 =?utf-8?B?UWF4WEVxV3NYZzBQTjM3c25RMmZYTXBMSjhEVVhFSDhmeG1yNGdBck9NUDZu?=
 =?utf-8?B?Z1gzMThUM1ord0s4RjIrR29raFpDeUxUekQyc0lHc3ZWcm40L3lxdEVJdlFG?=
 =?utf-8?B?dTEvT1hWZUZ3b3RzMmh0eEFqMnpRalhyem9Sa3ZSdHQxSDBMYllNMmFmMmFR?=
 =?utf-8?B?MzlFdTNoOWlpaHA2NGY4eTR2dFYvZGFBMkJDcjF2QVRVbzY0T1k0VitzZXBC?=
 =?utf-8?B?NmNBc2R6cWVvLzU5cFFZK3dxMnZhWURad21hV21XN2t6ajJGMlFKN0VPaDl4?=
 =?utf-8?B?S3RXQkQrWkVGakY3MkoyU0l4bVAvWUZpaW5mY044aEFPQzhhWlNQeVUxZXpu?=
 =?utf-8?B?VUFocEVCTFhFTVQ5OEI2QllMMmZuQk5EU0pvVVdJVkUzdlo0dmZhOExycjVv?=
 =?utf-8?B?UU1OSWJnd3ZXS0pMaUVlZUkySUNXN090UVRBMTBxSmtTR2FtWmJ5QkhtU21V?=
 =?utf-8?B?NkE4QjVNaGppcGFXWFBhZkNXR1E5Tzcra0FTQzBQelpsUjJmK01PWmd3MHlj?=
 =?utf-8?B?K3M1dCtzNnMrSTBxQ25tZWV5SU80QWhvdWltUHgvRjlwVjhLS1UrSlp0eElT?=
 =?utf-8?B?L3VGVUJtdUQrRUs4b01TWHlhY3RxcmpNOUJSc1N1OHhkVXU4MDVEYkhRUEhl?=
 =?utf-8?B?SU9Jajg5V0xJS1llcTNhQ0J2c0VQWUJKNS9vVVJ3QzZDcExzZm5TZWN3a3Av?=
 =?utf-8?B?VkhOQUlHSlNiNnQ3cnF0cVB3VUc4NFZUK1ZLbWRRZVljaUZWdEllSjNxOTVo?=
 =?utf-8?B?YVMwTkVJYkVBei91T2RsODEzem1KdnVtd0tUak5vSE51cGhKdEVlYTQrNnFq?=
 =?utf-8?B?eS9vTXlGMm1TV211WHgyUUFjR0dzd0l2ajVLcUwxeG5LUUplWFNUWFNIQnpU?=
 =?utf-8?B?aHhhMDd6UEpyZE1EdFkxYmdsbEN1WkJKa3VUbXV2dURMdzFFRnFJL1duZ0Fp?=
 =?utf-8?B?RUFXZU0xY0dIQ0tsdGp4eU1TVEowUXhodDdaRzhhdEo4OW5renNuNm9FOXps?=
 =?utf-8?B?dlExSldweVVFZTFVZnBKMnJCN1c2amZXODFmT1FnbFg5ZTVOR3orR0xjaTRi?=
 =?utf-8?B?VVRrNkt6N3h6VGNMUDdJVVNHWXNzK1ZGaXVQWGdhNUx3RmZkVzUyWmFjeXdh?=
 =?utf-8?B?YXo0Nk4wUXQ1WXR1TWRvNCtydm5Mejh5TjZKSTFPT1BGM2Y2dWFhUTFybi9r?=
 =?utf-8?B?d1F3dHE0WkdZZUFLdi9mQURGNjBtYVd2eTFqUkpmbXB5b2VueHpyZ2JwakdT?=
 =?utf-8?B?RHNMQUxQL0h4ekpGdW8xdjY5RWEyajJMZjBrV0Q1SldFbnhJT3ppcmdkSU5O?=
 =?utf-8?B?R1YzTGhKMEoyVHBRU0Y5eEgyVW9WZEQ1MGhCdmlmbVVoZHVyamUwVjRXZ3pk?=
 =?utf-8?B?Vk1VT2JuYlRWOW9UcjJtRHBoUm01bGdHUmdLelN1QmhRWTJVY0thVG9KcXBR?=
 =?utf-8?B?QjM4MWlVbVR0ZGovOEFOd3hRUXdCWTVzY05NRFVDZ3VQQjlsdUtlOG9IVkpy?=
 =?utf-8?B?YXp4NlNoL3cyV2ZiSWNKbC9IVEFhRjVET1RwM21qNklVcnVwR044MWJyYUdH?=
 =?utf-8?B?UDdqZU54OWZTYjQ2OGRoN3cwNVh4KzJqbFY2Mm9xcE5PbGNCNC81RnpZUTl4?=
 =?utf-8?B?cFYvUWt0NDRRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emtCeWF3bU1CMGhaYncvV1FoNjhKNDJkdytlNHNjU2llVWY1QVZET0NLMERq?=
 =?utf-8?B?ekpJUTBLWDhCTi9nQUJFV1BNUDdzb3hjTkZTN20ydFo2ckVzbjE1S0tGSjBS?=
 =?utf-8?B?bXFrQXhpTXQyVEtma2hBM0ptdWJYc3A4cUZJZm84cXhsZFR2TFNvUm1NV0lR?=
 =?utf-8?B?dE03NW9XMXd5R3RmN1hOVFQ4RFpkN1hDNXpEOEs0ZlQ3OFQ5OFNrM0dYSHBl?=
 =?utf-8?B?SUp4OG5iL09wL1ZUc1RKQURTM0kzZjdIRkJSRG14ektpTzVHby9yTmZLWFdr?=
 =?utf-8?B?ZnQvVzYxcVE5ZG13NE83ZmVEM0dVVXhsb2xkc3NHRndQU2UxbDZiM1ZSNDFj?=
 =?utf-8?B?cDJTK3c3WWtBczNicWlIM2IvY2RVanAzVmFhRm9MbndUdXU1NW5mWnBtQ2NV?=
 =?utf-8?B?NUZ2eFh4dzdGa01DSGlpdWU2Q1BzSnJHZ0xOQTFzWGRyZTFXWjZpSnU4bDZD?=
 =?utf-8?B?MkljcjZwZGEwdmZJbXR3dUdOa0tEU2NxbjdUWGVkYzVnNkpSUmhxUFNITkM4?=
 =?utf-8?B?bzM0SzlrTDBadWlpblBmcDhYQzNVVEJwZDZoWmxJMU1BRnFXbWRyb1o2V0Rt?=
 =?utf-8?B?RjdpeUQyLy96Rk5ERWFtQTBJT1hlaWRNbjVMaHIySGppbkJkS1VsTFRSVnR0?=
 =?utf-8?B?bVg2SXdrcEQ3UDlZUG9hcVg1WGNuUmNJSFlyT0JxbTlraG4xMlFpME1ac0dh?=
 =?utf-8?B?Ylh0RlVHRDdncmZpRHM2OUxZVThpeDNUV2ErZ2FpWC84Q2tYR1JNbnFwcnJ6?=
 =?utf-8?B?WlJ3QmxkS1A5WUxsWlh4L1VBTG5WdklmdVJvL01RU0h0V2Y4UlZoNXFBOEZl?=
 =?utf-8?B?elMzaDB2V00wUHBNZ2p5QWpYb0ZKbFBNanVjRVE0a0xpcDJNaFZLRkorQ2Iy?=
 =?utf-8?B?K0ZvNWp1K1BLUTN3b3dRUndQSVlJaGh2QVRONFA0dlVqRU1ITnV1SnIrMzh6?=
 =?utf-8?B?dllFUmRsYndobXpHZWRBQ3hTVVJFTmtpSjViamdXSHdKR3V2UmM2NGdFQlhY?=
 =?utf-8?B?b3ltYllSc0tVRVNadGdmK0MrbXFJVzdreUs1ME55d1hYL2tUS2owS3kycklY?=
 =?utf-8?B?c2dlMStEV29WMHNvY005T2w3K0NLdWVTcHBNZFBDTm56Y1lUTlZ0VHYyS1pR?=
 =?utf-8?B?eWlDRHpVOTFwbjJkQnYvYnlQMG05V3RYcVVVR2JMT3NHRHFPVnltN0hjU1I2?=
 =?utf-8?B?ZTZpcnVGRVNtakpMblhmdGRYWkVReUEvdGJvdkV2bm9UbHBTeDRwZGVMUHFY?=
 =?utf-8?B?Yy9kaFJtbmhGSTRVTGNQK2I5TjFzVDc3cVcwRWk4VVFaODdxSDBzTFpEa0t3?=
 =?utf-8?B?Z2k3dVg4NlNPRmw3L1NSTkd5NmFvSzVnaXlaQkw3ZVBtRno3UFJBbVFMVDhq?=
 =?utf-8?B?bUdvaW9paW0yVVR6cFJPakw1Nmt1MlZwNjU1UDdZdVBVdXc2ODVpMStyZHM5?=
 =?utf-8?B?b1U3cE5QSkVjdmRaTjFJR0hoQjA2L1ZmNXhRVnpHcUtMQ05tR3psbHltT0N1?=
 =?utf-8?B?d2VwazVrY1lnQUVyT2pZRFRETXdRZDRTVUhzMUxsbUtpS21pNmptMFhmZzlx?=
 =?utf-8?B?U202OW1zWDlnd2EzZnQ2ZXg0SkZJTFMzdlpFWElsdWpNbUliMHhnK1JGMFl4?=
 =?utf-8?B?cEpDS2gwV0hYeEtDZTNYNWpWVmtkNE40c1FLYjJseFdYM0J0S05YZjgwM2ZI?=
 =?utf-8?B?TlUyUC91Qi9JQmNuQmtqUy94amJza1FHbXpxV1pEWDNyMEFSSkdSeXVkU005?=
 =?utf-8?B?N0tCQlFFSWFKdHhCMkdGZ0pKNGRJUEJPL04zRjh4VUxlRFdYdjQyOU5hWnQ3?=
 =?utf-8?B?dzdibit1L1hxai9OeUpWZGJKMmN5dkg5RUhmTHdncUszcUEvQ05UTG9FRHBD?=
 =?utf-8?B?SUwzei96MGFIMFZLZnI1VE9SUU5zNTBBR0tITnNVVGE1cmZkbmttZE1JeU9M?=
 =?utf-8?B?WnVjalljTjhDQzBmcWkyamRjOGdzSmh5dkphTllPSEtuYUo5c3pXejF4MCsw?=
 =?utf-8?B?dTd6SER0REVnbXM4WUs1Q1ZtU1ZDMWU5aExNMGdiTDdzK3dBY2FBWUFSTlky?=
 =?utf-8?B?c3JPbFA4cGpGVzZxVThiNnZ4UUVGQU8vUXRoQlErS3hMVVNsZ0tvbkdvcjcy?=
 =?utf-8?B?N21FUFdWZDZpeWxDSWlLbXVjMUs1U3ViWUpYUlpKQVJKSk5aWmhaVzZxaTdw?=
 =?utf-8?B?ZEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 431273dc-fafe-4e3d-6f52-08ddb7fecbc9
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2025 17:51:52.7626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oCOxiq3oEuAwRUxl0xSMAgE+okGuopzABSU0DCh7p1QqSqPiKKdo8timsv6c2P2ovY2yDA+B4grNucPpEZHC6+u6oXgC57uZCNCa74v87TA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6988
X-OriginatorOrg: intel.com


Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Background
> ----------
> 
> Telemetry features are being implemented in conjunction with the
> IA32_PQR_ASSOC.RMID value on each logical CPU. This is used to send
> counts for various events to a collector in a nearby OOBMSM device to be
> accumulated with counts for each <RMID, event> pair received from other
> CPUs. Cores send event counts when the RMID value changes, or after each
> 2ms elapsed time.

To start a review of this jumbo series and find that the *first* [1]
(straight forward) request from previous review has not been addressed is
demoralizing. I was hoping that the previous version's discussions would result
in review feedback either addressed or discussed (never ignored). I
cannot imagine how requesting OOBMSM to be expanded can be invalid though.

Reinette

[1] https://lore.kernel.org/lkml/b8ddce03-65c0-4420-b30d-e43c54943667@intel.com/
