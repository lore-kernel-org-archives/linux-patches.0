Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4554D25949A
	for <patches@lists.linux.dev>; Mon,  6 Oct 2025 21:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759786392; cv=fail; b=mQZGVv/7Uz6XX+sZAD0BJehKu5Z69ZnFoIRyH+cCd827gubtrJfE2fxatBXgrEV/ee9IckUcijH5qRRq6DOAuUiW3ZhGYV/YnbRdAG/Jdcb6YdQlJOJBp3kX3qRD+tMclEgZUcZgq9+yZVZs/E6kcTxF66l7pRXcaRXQNgICu14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759786392; c=relaxed/simple;
	bh=ylgjKae7GNsiCUArJl6xGbtq1AI+K3X6NiQm6Oh0FzE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eo5JHsQcKHIQjyEtHIKt0XrsxKZ7/8Z5j0y1eIfe1U0Y0eRu2EM1On3O5i0aldpJsJ+zITOKZfL+8xZeBcPA3APa9b6DTl+GMvtalMQQa6I4SicnhS/mN6zK0hXYouIydGwBWgXtfquzVcaDzBqP1rc9PP+Dr7Dtv8/ak/wwjQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AgloY62l; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AgloY62l"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759786391; x=1791322391;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ylgjKae7GNsiCUArJl6xGbtq1AI+K3X6NiQm6Oh0FzE=;
  b=AgloY62lPISr+Qzppmwn0NSUil9Ltka6Fgox2ZuImBTg9oJsxadqRpg4
   qHTWsghoxVz1q79EzinlOlpdsyVFXdzPOJQVgPqO/ep7XGg0Vle0yzVD2
   l9znwCc2vfv4FQE7qjBnepFiuXwDqvUL9uydXDlLUJUfNk+vNFMaIc3q+
   NvClgyxZPw0T9X71FZBic8QnYwrsnwau5GZykJoGpnpzZZT6UtwiIFZI9
   elmJiFzx88arDRDJGGugiUYurHN5iz4EDAgB3IgMiui6gt+7Wru6ySfLZ
   FDqFF1cyf88bQjMF6g9a6jtAFEwNfaVieSFYfSeEIic7sI4Y582kYdhw0
   w==;
X-CSE-ConnectionGUID: 4Kl6IcB4ROGkA+sjmrGKmg==
X-CSE-MsgGUID: 4l7NDNjiQj6wYcVSlXPw5Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11574"; a="72581956"
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="72581956"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:33:09 -0700
X-CSE-ConnectionGUID: v+AA8GhSRC+qcnxWCgP2ng==
X-CSE-MsgGUID: PhgYFWDgQJidzR3Jp3nUog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,320,1751266800"; 
   d="scan'208";a="185267015"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Oct 2025 14:33:09 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:33:08 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 6 Oct 2025 14:33:08 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.43)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 6 Oct 2025 14:33:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Dqlfq6f+51sFRxOPRH47Rf+L1D11aiMcGxDnlNMk8R0x7H33K4E1HBNgqbBusKKI3v330Rkd3rsoHYug1vtzBskWHKgY/e6b2WhL7UNl68fH16OdByeZJKsOCYBRBhnhPACZko7eKaWjB2pA6PVPf9Ja0vjorx2P6EWiuqmKAYmt1klndCmJFhM77HMHzJ604qoJ9I+dh9QbDhX+Bw1yaxodUCrQjZqKFSkepuf1dkFVBmIlSlAo4LJtGDf08lhgiakrWdtg+M6DMjM3v8O8TLcaXCb5PwBugtTLWOzKhk1ASsZSMZo/y6X9wmneDMYcJLQDJyVMZ4MFDxl4dlv87Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NShmnqtpouhN0u9XOA08y+vJkDSeAP1qL1M/E4pX+Ds=;
 b=TTqQoCSBdGCpxnkrDqcMqRK7wcPV44Ao+0uOcPYEqzP9l3n2WliABiYDXXkNNF64/MH9JRcszhlLMHdX+pubTji9BYqp4WIGhAk1TENLdKRh54c8/gW6fQWADo/zMt6I3fUJLMFiV4QmvemohnLG6xsN8fczRelqTqxV21qr53G4p6L2ZQ3Ds4yc+LlmgAncDfpigiIrcAru0rUftf7846l4S7GEsFmjza7v30O+aE5UUqkSIIxtEE9CK38uVCRRcsPeqg1QA6JQfztn13sYmY9ysFlW5TXVnM+8EkZJFlrAUFs5gmEoNLrZvmiZzPRy/58XYjZw3/7eeacoSELVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Mon, 6 Oct
 2025 21:33:03 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9182.017; Mon, 6 Oct 2025
 21:33:02 +0000
Message-ID: <89e640fc-6bd7-40b1-8968-ca1a85005f4c@intel.com>
Date: Mon, 6 Oct 2025 14:33:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 14/31] x86/resctrl: Discover hardware telemetry events
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250925200328.64155-1-tony.luck@intel.com>
 <20250925200328.64155-15-tony.luck@intel.com>
 <08a35a50-480d-48ee-bc07-b7405274a487@intel.com>
 <aOQIMQsgBOta0PRP@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aOQIMQsgBOta0PRP@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0325.namprd04.prod.outlook.com
 (2603:10b6:303:82::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB4958:EE_
X-MS-Office365-Filtering-Correlation-Id: 26d8da8a-e4d4-4f07-0e97-08de051fedf1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXZUTnpVSWNXWkJreXNZbFBzcUQ1TkJ1cm5ad24vZ2dQdEpuK21RdUJNRG1U?=
 =?utf-8?B?UXFickJiRkJybzM4Z1RMUjdlTmpQSkpuczVoRWR1RWxDMTdzV0xwS1JWeWYr?=
 =?utf-8?B?cko5c3Bpc3VaLzcrWENPSWtsTkJLVW5GOThtQm0rdUlTbVgwVGp0OWdTeENy?=
 =?utf-8?B?N3MzYTNhaGZtdzZjUzJnTWxkNXhZRmxuaFJYSGw5SGpIU1lYMnUzeEJxTjVM?=
 =?utf-8?B?UWZXZUNnMUxjR284MTFJUXBFaWwwNEI2b1E4d3dIV2ZKcklTVjhGbTlJZTYv?=
 =?utf-8?B?N2tZTlFVYnQwaSsvSHJld2cyTFpsWkIwdHQ5TTJqbzdnTDJGOFg3RVpaMDB4?=
 =?utf-8?B?ZmlXaGxENnIyOFNVK2QraFhPcmQ4R0I4bGEvbG9hWFM3b3ZFRTJNS1VDQSsr?=
 =?utf-8?B?SkU2YTFDTmoxUFpRN0pPVXhxUURESENBY1pzKzBEMWFJVHNyWWlaVHUxVXB2?=
 =?utf-8?B?NFdsWmRiN0RGOE1YSEtpc2VNdGJsb09QQUdRNS96RE41c2NCN3lGQ1d2NzZR?=
 =?utf-8?B?VDBIQmJVSUJ5SkxTNExUUFdjRXVDSHFKZnMrbWFWQitsZXQwRDFGS1pURGk4?=
 =?utf-8?B?cFJleFcrRHJHMmxQSXNXMVpNOUp5M3lFeWJzbG42QWJKRFg0YjVVTXRadDI0?=
 =?utf-8?B?MU5UWEd1VHpZejBTakoyWmZRUnkzNkY5YlFhdk1xWk1ieVBvRzBnbVp2TTFR?=
 =?utf-8?B?WWVrTE1ScWVHVWc2dmdySEFxOWtNeGN2RUQ1Q2o0VGhFYkoybm5UaVk0bHdN?=
 =?utf-8?B?aDRzdS9seFVxZkxkOHlhYmxhc3NvclBMSmN0MnphcXQrRGpUaTNsV1F4bTFO?=
 =?utf-8?B?aU1FN3Bxazg4czI5RHVMeDgrREQ5VDhwV3g0TDREUlVNUU1kQUw3cGFaUC85?=
 =?utf-8?B?TzZwamJoaGlMSDZRYllYbSs5emZBNWVheWk4blpGWkxWRlBIWWFQQ3BVakM2?=
 =?utf-8?B?clRNN0VGcGNHcG5rUHAxYmFBV2Q4c2o4ay90NTJpODVNQnNlU0ZYMjU3TjRR?=
 =?utf-8?B?ZE1Fb0tEd2FXYzg1RGVnMklzc2Y0bXc0a2pQbEtpRHlDQVlYQ2l3cnM0dnBZ?=
 =?utf-8?B?TzZmQnQ1THArWk1oenEwZUR6TjdJZy93WUNPK2w4Z01sKzYvTDcvMHBVVzBo?=
 =?utf-8?B?REZoOHluR1E5UC9vMmFNVVptMDk4SUxQTDlxT1prRERDZ2RjdGdBMW1weWVQ?=
 =?utf-8?B?ZnFHbXJtaXZubzh5TkFxaHNFaVdSRnV0cDM3NEVwVXdwQk1BWUpnVWxqVVFI?=
 =?utf-8?B?Q3AvUjBROWJtZ25NcDRmdGJpc1hIeXMwb251eTlkWHJoNGQ5SC8wRzFzU3BM?=
 =?utf-8?B?dXUyOFRhd1B0OFRrWWJLS2M4dC9KS0dFSEplR2Z0YkJrb0RaT2prZ1JSYWVu?=
 =?utf-8?B?NG1EOU1LYVk2WnMwTFVHT1J0aHVCWUtUSElUZzhQL0VERUhYc05OcS9PaXZ3?=
 =?utf-8?B?aFZXUC84alJxQWF2OHNxa2t6UGxPbVcyRTNwK0pWUjdaU0dIWlh3Q0NmWFNa?=
 =?utf-8?B?V2NqbDM3OW85RlJCK25FcVB4NzNJL1Q3VnFMMGc5bTBxL3lIL3BGQVFGVmkv?=
 =?utf-8?B?TEEwYUJwRnF4N1V3Z2JpdkNEQzExOXZnaXlIdU1kSEtjSTVrdHpBR1liOHRJ?=
 =?utf-8?B?T0tDdDdCcjUzQVdzQXY4WXIvZ055OGswTVBuQkNoTXEwT01kYTlISlVmL29a?=
 =?utf-8?B?WURub0tmWW9lQjdsR0dCR0JIcldGbHVTcWNMeHNibkR5WjIrMU0vVWMxK080?=
 =?utf-8?B?c0czVnNwRm1waFVSQVd1OHRNSmRkeTBtWFMzS0g2TnNXODg5VGJUM2wxdEhT?=
 =?utf-8?B?UWw0eWpDczFxdUJBMVZhckVmZDFMM1RUMkxjWFFMM3NmbFM4SnR2UmF6VFBz?=
 =?utf-8?B?RmYzUGtscVlDa1RGZ3hTS0Jla1RrQk1hZFNMQnI3RjhFN3diR2JuRUhnQlIw?=
 =?utf-8?Q?xbMXZqbaK5gl8FvumqwHcThhkGaUcL1+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RTlZNTB0eUhnWGhpaENVcmcyeU4xejE1cGRsckJFRnBRbkpRVnlRbGpKaFdK?=
 =?utf-8?B?MkgrVWh5bXY3bkxISGR6R2VTZVFQbmpVSFNYUElIRnI1WGNoYnloSlpzb3Ix?=
 =?utf-8?B?blZsNEhFVFBXb21xaFFvZjJHcTBMZ2RaMWc2RHlza3lUMnZOUVZmM2w3Y1lS?=
 =?utf-8?B?cEt5NlFNTnQvUENaU1V4UjhodnJSU3RlVUhZazJNTDdXQm1rcEp1bjVrK3or?=
 =?utf-8?B?UjJCUnVLamI1dkU0ZTZtOEw2L2JHbmdOcXZCMjJ6L0hVQzREb1dUMFF0d3h6?=
 =?utf-8?B?Tm9mTHFWMG95K295ak9DTjYzYXdLbTgxWkdHdzlKUWtRNVlpL0V1UVJwaWt2?=
 =?utf-8?B?MEVYeWg3YzRDSVVnd1J1aUdsbHpHb1hmeUdSWlFpc3UvbyswdHFGSjhJUWwy?=
 =?utf-8?B?S1JkN3RXVXRHbjNDMy9pTXdZenZiR2RoU0JwVFJTZ2JFdVZnQ2gxR3c3QTRs?=
 =?utf-8?B?cUtUNEE1eHcrWnk2QVpZV25VWDJjaWpINGdyZzJSWUQyYVJ0ZVVpVFEwWTV5?=
 =?utf-8?B?d3ZMdUp0QzZDZmU4SENQVEZ3QmlwNVJpV0ZUbStEWkoxbG9TdTZQMTE3K1hr?=
 =?utf-8?B?VlFvcmFxQWRzNGJQS3FiVmlUOVVVZng3Y0RZWWFIOW9xRXZ4UkxKVDVndXpG?=
 =?utf-8?B?U3lzMzlKQkFvOThXQ211bWhZc1VTSTBhcERkaFZIcFVZekQ4aHRwM2xQMmE4?=
 =?utf-8?B?QWRYc2Fna2JYdXpsdDB6T25kdGpHRG82NlMwN0tXclVqSGJGTk1hTHdnN090?=
 =?utf-8?B?Rnc5MEIwZzN5VHRQMStVSEZIRmlISStzc1dIYStGTEhUNXV1SW96M2poWnMv?=
 =?utf-8?B?SFk0Y0ZXZkdWZDF5RDArQXB1VWRsY1JjWFY5eVdJYkI5WTBTem5DcGs3eFk5?=
 =?utf-8?B?S0tMT3RjRHZqS0dZZTczRS9zZ3ljVWJUN1ZlT2UzYitWU25FdmM0NkgwUDhF?=
 =?utf-8?B?MnVvUllVanRkRXVERWlhbUlqUTRJSDFhZjdObytsTWFDcU1mM2tCbWFoZ1Vt?=
 =?utf-8?B?ekI2YmNyMUIzRCtVYzVaV1FxWUc3TmZqMW5wUzVDekVBZzZZaTE0UXhUeExj?=
 =?utf-8?B?NUptaXhvRTJldTFqZFl4QWNYU085cU0vak9BMWdBMGlyaG9lbmdON1cybzIw?=
 =?utf-8?B?ZVRKMTBqQXhvQ3JGTHBnYmJwUUo2U0s0ekhPVlZzdjVHd2w5TDVqRmgrREth?=
 =?utf-8?B?RlllYUsxaFlvbDYrNFJsT1oxdGtYTzhBZlZoK0RNS2RCOEM5OEFYZzB0TG5a?=
 =?utf-8?B?WEluelhScHpHdUdMNjNhNFpHY2hPcHJlaFlGbUNOUGNkTEZKYWlNTXQ4YVNy?=
 =?utf-8?B?YlJKZXJ4Q2JOWEYyeUltei9FdFVKUDVNcnFkaU1WVUxBWEpadlByOUpOZ2hq?=
 =?utf-8?B?N0tIUnFMYWp0eUpmSlEzMi80REk0WUkrbW5xTHZvWTRZcjhPVUcxQVo0UFNK?=
 =?utf-8?B?eXlMQ0paZVdBb3VvRG1iUUFJR1FFV0U3UDR2cmprR1pqd2dTV1FaTXh6NHk4?=
 =?utf-8?B?WVdpZ25wWVhkWEVocXdTU0laZXlSY1BaeGMrVUh3ejBzZGFqdVFvUUFzVjN0?=
 =?utf-8?B?WHljYjgySDFsNjN3TFBxSDNJUWpWWGtENEt2aHNYV0FXS2dhQlJoc0g4Qk9i?=
 =?utf-8?B?OHMvRXdBVFp4ZVZZUG5HSDNCYitlVWxJSzU1Tm9LcnowRVJlYlF1VHpRRlZT?=
 =?utf-8?B?ZXdFNmdUalRQcGc5QWQyQzFlVDlHZmFjU00yMnlERHlIZWFvdDZEOUhzeWVo?=
 =?utf-8?B?U3BuT2hnOWI0cFp5TlZMSTZ1ZDN5Y2wyZkZmQ1RaY2VLT2p2VVVjTzMxNk83?=
 =?utf-8?B?R1pKazdFZWE0NjVIWmlhWWhPeXJHWVB3Q202YTEyN21HSlVrWGkvVkpLcC8w?=
 =?utf-8?B?SkJ1cXdMdTRFTHQ0WGd3VlZkaHhCODZud0dtUFF4MVAyRHBZa0xUZUxUVkJs?=
 =?utf-8?B?VE8rd3JYNjZnWE1CSnZzL2Y0cjByUmVDUVFTZjFmNTVqTkdwTkRySnM5N04v?=
 =?utf-8?B?Ti9kN3lYSDllbmF0N0ZpbFpDdElnQ0RWL253QUpCQWlSS0k2d3hSVjI5d3BT?=
 =?utf-8?B?NEQ0QmhEdEcxK2NqUGxjY1NJeGk4SlpEQVI0cXdobkFHNlZ1VUg3S0QrSVlT?=
 =?utf-8?B?ZThEaW5tL0F0TEJPenY0cnJxc0JKVGlZU1dRYUpVZERhWFBiUlpQeGRqbW9O?=
 =?utf-8?B?SWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 26d8da8a-e4d4-4f07-0e97-08de051fedf1
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2025 21:33:02.8615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCZuiewcgPdgYyjM7rERWsTC6JPcXMxYBi5MK+GrnieivIYVgIEDAaStNKQkItZ2wXf6Ci0/9/f8ghDTxg9vrqmMlIC7xg3BL4ebNT6wGCA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4958
X-OriginatorOrg: intel.com

Hi Tony,

On 10/6/25 11:19 AM, Luck, Tony wrote:
> On Fri, Oct 03, 2025 at 04:35:11PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 9/25/25 1:03 PM, Tony Luck wrote:
>>> +
>>> +/*
>>> + * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
>>> + * pmt_feature_group for a specific feature. If there is one, the returned
>>> + * structure has an array of telemetry_region structures. Each describes
>>> + * one telemetry aggregator.
>>> + * Try to use every telemetry aggregator with a known guid.
>>
>> The guid is associated with struct event_group and every telemetry region has
>> its own guid. It is not clear to me why the guid is not associated with pmt_feature_group.
>> To me this implies that a pmt_feature_group my contain telemetry regions that have
>> different guid.
>>
>> This is not fully apparent in this patch but as this code evolves I do not think
>> the scenario where telemetry regions have different supported (by resctrl) guid is handled
>> by this enumeration.
>> If I understand correctly, all telemetry regions of a given pmt_feature_group will be
>> matched against a single supported guid at a time and all telemetry regions with that
>> guid will be considered usable and any other considered unusable without further processing
>> of that pmt_feature_group. If there are more than one matching guid supported by resctrl
>> then only events of the first one will be enumerated?
>>
>>> + */
>>> +static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
>>> +			    unsigned int num_evg)
>>> +{
>>> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
>>> +	struct event_group **peg;
>>> +	bool ret;
>>> +
>>> +	p = intel_pmt_get_regions_by_feature(feature);
>>> +
>>> +	if (IS_ERR_OR_NULL(p))
>>> +		return false;
>>> +
>>> +	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
>>> +		ret = enable_events(*peg, p);
>>> +		if (ret) {
>>> +			(*peg)->pfg = no_free_ptr(p);
>>> +			return true;
>>> +		}
>>> +	}
>>> +
>>> +	return false;
>>> +}
> 
> Perhaps David wants to cope with a future system that supports multiple
> guids?
> 
> You are right that my code will not handle this. It will just enable
> the first recognised guid and ignore any others.
> 
> How about this. Take an extra reference on any pmt_feature_group
> structures that include a known guid (to keep the accounting right
> when intel_aet_exit() is called). This simplifies the function so
> I don't need the __free() handler that confuses checkpatch.pl :-)
> 
> 
> /*
>  * Make a request to the INTEL_PMT_TELEMETRY driver for a copy of the
>  * pmt_feature_group for a specific feature. If there is one, the returned
>  * structure has an array of telemetry_region structures, each element of
>  * the array describes one telemetry aggregator.
>  * A single pmt_feature_group may include multiple different guids.
>  * Try to use every telemetry aggregator with a known guid.
>  */
> static bool get_pmt_feature(enum pmt_feature_id feature, struct event_group **evgs,
> 			    unsigned int num_evg)
> {
> 	struct pmt_feature_group *p = intel_pmt_get_regions_by_feature(feature);
> 	struct event_group **peg;
> 	bool ret = false;
> 
> 	if (IS_ERR_OR_NULL(p))
> 		return false;
> 
> 	for (peg = evgs; peg < &evgs[num_evg]; peg++) {
> 		if (enable_events(*peg, p)) {
> 			kref_get(&p->kref);

This is not clear to me ... would enable_events() still mark all telemetry_regions
that do not match the event_group's guid as unusable? It seems to me that if more
than one even_group refers to the same pmt_feature_group then the first one to match
will "win" and make the other event_group's telemetry regions unusable.

> 			(*peg)->pfg = no_free_ptr(p);
> 			ret = true;
> 		}
> 	}
> 	intel_pmt_put_feature_group(p);
> 
> 	return ret;
> }
> 

Reinette

