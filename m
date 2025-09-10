Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118AD1A840A
	for <patches@lists.linux.dev>; Wed, 10 Sep 2025 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757519921; cv=fail; b=bK30L1kWU3sgYANj9WwcxxFMpChw3tmLP3XBT8J1DNvjauxI1j6M4V6+jWU1DoWysoV2PGhwjiOfSqGbNuFYYexdXsSJ3wVdJd6ublGoVU5m1/50IFeud+BCgz5qDs1dIh0DJjQtKUNkXVDN4Mr/AaMojjqBue2wjIWeI6nzK4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757519921; c=relaxed/simple;
	bh=OLihxjqfAi8w3+HXw6sWaEiPN2QO5MTBtpfBBGIujtQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VLNA/jbqna8I4F4Sg6ITnOplnzDSWQhc9ks/oa0FxYZT/nZVK0XPEMNeKIWBIy5WKoXKJ4Oap1U1eVQMFugneNNJwZ0y+6EBlSuF/4ENUr4gNmoDe1jjhgXyAgbo1EYNwPH1AQ8HiE0+aDViFeXGLKEEltQzcjvrC/h8HJwBG78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FNKrkQUF; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FNKrkQUF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757519919; x=1789055919;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OLihxjqfAi8w3+HXw6sWaEiPN2QO5MTBtpfBBGIujtQ=;
  b=FNKrkQUFINM31WLCz6VZL28+uVQcrZQ3kj2OUr4F1CR7i0TwbmwoF9fa
   4DYqsf78LgnABg0332vTBhYNLOcx8lJ5ninkVpg6BWDrI9wDCnLbjtuIv
   ZfUHIjDYmhTGgWijfAVwrS9LIJ4ZB0ihEjazdlPKz95b0xLFq4s6vnpZa
   one7nmtRXC8K0tfIzdQSIzf3VjIec1cy1gGaBhYQ3MwOsjiMWMmqYeU4O
   bK4YmDM9mvsm+2uzfLQegmKBPILuQYpJ/duSqBj9Ooj/QzzutELAGWOAK
   wWPRHhc6Yr1YO/axvpStReTFJKx06bjU8oyiEjGRT8VkRfkuDATdT7hx7
   A==;
X-CSE-ConnectionGUID: zzWmszCaQQu8bxf0EPiIGA==
X-CSE-MsgGUID: Gli1HfWbRYe1XDM6AUBZPw==
X-IronPort-AV: E=McAfee;i="6800,10657,11549"; a="59693575"
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="59693575"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:57:46 -0700
X-CSE-ConnectionGUID: D63kdAj5QWGcS0WhNT1LqQ==
X-CSE-MsgGUID: fjfnanJ5QVyRSSI5nOf5pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,254,1751266800"; 
   d="scan'208";a="173023488"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2025 08:57:45 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:57:44 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 10 Sep 2025 08:57:44 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.42)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 10 Sep 2025 08:57:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KuUo2SlutWr3qv9Pbg3ysDM1CynaHIafioGT76TxmeIsnN0TdZT2417o1W0UBv0vPU5kIef168pa8108GVLlRgy49GQYbBz0GcLUSCX2KCdzlTzd/4ZjNGl1QXzMCg4MmMKceFmZu6SLsOESroL1mQA8ADJOEanU9EOLdPuMnwUqkGOX5VTx7ggSuwJ+2tcK79ttsDk2gXTt62gMM/QWVXkGtsra1PH8Px/a9O7+XdgKfS5cca+dXyS9zg6hY32p2Ck7NSZkneXKsT7On14gpO1wAkGI5s8l9rr1mQtKO7+LBKsbjBPKApZR96QxZ1XlQb8n+L2ePj9wtFSqtTHCwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7Hli0SDSnevsdmT+Yh9MWD7O717X7JQj9fgnvUxZTDo=;
 b=jnVZD5r/ETV2DHYBDeOTwoDJYtqRrCu2xlcg+ZHxMlZtxiFtiY7AXhBYNl6VKAaEbTim74WR4qL0uIZv+xyIGCX7Nigp5XUppXyPH8hEttJi8/x33lNgQWnpGFOWnwPYV6o20zFrrcC2WWYye4boNYkj+ny9QTDe4Kh40ArOFUNoUYg58mjaDYHQLpFVbLOf8IUvjCLLd0RUDbMlXthF/6TQ0V4VwZeZwn0Vxc8L2xhl2YLhLv5l7pyzjsdJIAY+lxUxC8rwXlp1tEunctCG05QVUS5NO9PH3R+aS/38pyPrSFo3yBRjaUi/jJWFzF4l2ScLoN/GFRpK9UvPq5XV/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA2PR11MB4938.namprd11.prod.outlook.com (2603:10b6:806:fb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 15:57:42 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 15:57:42 +0000
Message-ID: <91f25013-e025-47ef-9d5b-9746678b6856@intel.com>
Date: Wed, 10 Sep 2025 08:57:40 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 24/31] x86/resctrl: Handle number of RMIDs supported by
 telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250829193346.31565-1-tony.luck@intel.com>
 <20250829193346.31565-25-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250829193346.31565-25-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:907:1::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA2PR11MB4938:EE_
X-MS-Office365-Filtering-Correlation-Id: caca3440-2df2-40e9-7d66-08ddf082c638
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YUNmNk9RU2NpWUUzYlZ6Z2kwMHRNUm84NFd6SWh1MmI1T3JBSnIrQjVRWXdj?=
 =?utf-8?B?YWNVWG41N2FiSWJ2bThDeU85c2pmNzJuSnpYdEI1UFdtb1k2WlA3NlNVVXoy?=
 =?utf-8?B?YjZwb3NTcE0xNTBaRjI3Qk1aRXNrRVRJZXNhS1Y1dlg3UWtNNGtsY3JiQ0tO?=
 =?utf-8?B?SGFzNm9rc3phd2lGZk5ZVThjUzZiQ0ttNFJVWndGbEc4VlNtSEhIdXV2QmRr?=
 =?utf-8?B?S1RkbWNMOVBoaGkxS0s0eVBTSzVjUk1PVWVabWtnUi8vN3NZSEtpUytuaHJu?=
 =?utf-8?B?ODZ3MVZzYXhITEk1azdtZUdUcDNENVJXeU1nRzBMYUwvT2VaclpYUGNGaUUv?=
 =?utf-8?B?dUZudDl4R0JVQ1EwL09uZWk2WlJHZkEvNFhLbUN3aFpSVWRCSThsNjBzV2pY?=
 =?utf-8?B?dG10amtRM09YMms3WFZKemZ2UTAyUTdnVG16UG5tYXJtdTY5Rld3WXllUVhO?=
 =?utf-8?B?NWNCRG41NXBldkgvSzF4VVpFdExQVVhodEJROXQ0L1pmTVFZWFp6a28ybEZr?=
 =?utf-8?B?Sm9XS2Y2WlAyZXhkeHNwc0Z4SlIvbTJERm9Ib1A5R25Qdi9EM2V4eEhIS3dq?=
 =?utf-8?B?aFpFREV2bzhGOTY2UGhOZFJDNzI3TnFFZXdpV0w5bTlXc09jamFCaEJROUdk?=
 =?utf-8?B?ejVTN1JtQ3AzcFVvaVBEYWxlUDgraWlrdnpZODJLVmdESm1GV0JLbzBFYTFj?=
 =?utf-8?B?MEkvOTRNNG5JNGljRFFwdWc3a1RDc3IrRS9BbjkwM3JNUHpQQldVSFZlWWdn?=
 =?utf-8?B?VFJRc3ltdmVvREZ0ZTFWaGorZnc3dmZocWZFd21tSDMzbi81M1g2TUxhbG1a?=
 =?utf-8?B?UTl1dEF3dWxMcXBwMWZwRUlxSHlUcE4xWUU0QjJMZDdURGcyTC9yYndnbXNV?=
 =?utf-8?B?N1hRMEFXbS9XVnY0a1Z1RzRJME5GRW1hL0NkdUh3YjVPU0VqU0J6ZlliSFJI?=
 =?utf-8?B?VTlaZGk4a2NWSkVVc3ZSUlg5cnI2RUoxZ1oxYkdSMmN5VXk4OGFLZmFvSXVs?=
 =?utf-8?B?Wm1pTVlnTFpobFgrS0RnbFg2K2xSWWpoajFGN0FheW0zNVMxTlNGRk9TVXBO?=
 =?utf-8?B?Vnh5bWd5SURXV1JQRnNxZDlJUjBCcktrUXZKWDQ4bmwvNGlJbHlZM1ptbnh5?=
 =?utf-8?B?UHZsRVJpbUtFTmpJSStTbXJCMy9ObTB5RE4yb3plR2p0OU4yR2l5SXZwZ1NU?=
 =?utf-8?B?UHZCbjVvaDhSd2o5cXdkTzArMHpmZGNvZzd3OTU3amNMa2lpTk5lRy9RcEFB?=
 =?utf-8?B?dEFTUmxiVjJ4OHI4aXJWZENkRGpXU1RCOXM1YXBxL0J0OFE4NWVPeHRZMlZo?=
 =?utf-8?B?WUFVQXdneUFxdHRUNVJSYzlIZGV4UDJNVlVWcUJ1b2RWcXRPYTBEMEFMTkZi?=
 =?utf-8?B?UDR6aHVNQkYzZWhSZEVUS21Ldlo3S0VQTXdoRDVMUmtUb0QxcHlKR3JqL2tq?=
 =?utf-8?B?ejYrdk92ZHBGNVZadU1oZlZNWEczRnhYVkpFblZHT204MTFuQ052MFY1YTlW?=
 =?utf-8?B?eHczL1hzYUtFMUNOUlVFNHdMMjV6TGVhdlRmbGdQSjR0Z29KaHRaOWtaOWxP?=
 =?utf-8?B?SU1zUGJjcTZ1RkJzOThDaXBBakVmOFB2RG45a2JKaG1iZ0tDU1FUMEc1blBa?=
 =?utf-8?B?ZEIya0pFb1o3VDVEejNiUG9TTlpud245dkhPdDhYYWt5QmxqOU94N1M4RGd6?=
 =?utf-8?B?ekxodnRQNjc5MVVqTUlteC9GYTN2dmcrS09XNExpTzRIdzQ5R3pXLzBTWUdo?=
 =?utf-8?B?OHd3VXlnaVRpVXdhd1gvc1hnU1JUSXRzN0I1elB4ZEpzY2hKWHg5Y2duYVdO?=
 =?utf-8?B?RFY1Vkc2MWtIeXBEaGExTDVIOFl2eWRkNis5ZTRCZkhqdjl3VHh0UlhFbVVn?=
 =?utf-8?B?ZXVPV2IyOUVqazgrZEtWRG43U3dWOVN5RDhEMHViMU5zU1g1OURLLzBtTVlT?=
 =?utf-8?Q?/wsetlOAjO8=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QzRWUllqVUpXd0Q5T3lkVDhaUDAzNG51K2IyZUlYMG1RVTE0M3lVSnBpMzZF?=
 =?utf-8?B?UFVGSTEvVEdxdzlnNFJlSFl1YmJaMTFsWnB3MGR4K1RlUi9QNkIzaENqalFl?=
 =?utf-8?B?bmNEcTZwVWxEbUdlcTVjQVQyZE1QbVYwMnh6S294RTc4N1R1TUxoS0ZRMC9D?=
 =?utf-8?B?UUZ5VCs0bDJXcVY5QytwajZuK3NVT0xHckhpdlJOOHY1d09GR1IycWdvSUtC?=
 =?utf-8?B?UmI2WVRwWDd0NnRqMkFkMjVGWkI4ZDE5RE9mS2JNSVYxK1Qzby9vNy9WZzZh?=
 =?utf-8?B?Y0RGQ2IxeGtyU0kyWGZjSXRqemtSdVZyQWhJVTVvRHJpaEkwN1dFQWZzbjh0?=
 =?utf-8?B?cHhGUjYvWFBpZ25waGllMTEyYkF4UFozRlF3bWlsNVNtNXFEMnhXUmMybzQz?=
 =?utf-8?B?c1lwYlhrK1BXekJBTkpxYzdnaEN4dkN5eW5Yb0FrY25UaUIyS2lOaWthcmF4?=
 =?utf-8?B?UEVBektmcmVpK05rNllkV1lEREhtMzR2NnRnSGJJcmxQeStoUXZWL3psUnV2?=
 =?utf-8?B?Q2p4a1R4d2VVTzlwb2xnVVVJeEl4Z25UYlJDMnE4d1V1NndWU2xWKzBIZW80?=
 =?utf-8?B?bmhYYWdRV2QrRzk1QmhYbStxVXdIcW5NMXA1YU1qM3B2enRRMU9vWjZhSmRX?=
 =?utf-8?B?ckFpb3BoZkRiSlJiY3ZibWkrcWtIS2JIeExqNE93N2pLa2FiaTJqMGxvV2F0?=
 =?utf-8?B?UkNIcTR2YWxmcysyNnZjZ3VqV1RpMEdacC95SnpBVHdWdXpNOC9lNG9BVStm?=
 =?utf-8?B?ak9Tbkh3RUN0TWgzMXp0OHhlSStuNHp1QXB5SUIxcmtsdkdLVkRsR2x1MEFM?=
 =?utf-8?B?cHpGY01xdzAxUzl5NDcycW96aEVyOHo5YU5qb1d5dWxjby9iL25tNEQxdUNz?=
 =?utf-8?B?d0h1M096WCtEWlRibkh0RzhLZ0xybVdhdGwxYzhnWGhuS05FTXpUdXl6UzZq?=
 =?utf-8?B?d3J4Y1YrVk81U2JJNzE1Z1MrQkN2TkFZY01haUh0QWJBL1FUODdYOUxYSTdu?=
 =?utf-8?B?SWpyOEs0VW1oV3JtZWVNcnVzQThTQVRFaWk5VEs4ZmtuTHpJaWdMQldZZnMy?=
 =?utf-8?B?LzZGaHBpZWxwSUxXOGVMV3RJKzRUTFpNV3BPbHFTTXhnUCs0WjF5dGVydWpF?=
 =?utf-8?B?ZFF5TW5HZS94U0dnMmhnZXJmSFF3ZmJNOTU0V1RadGJoQ3VGSVNoY1J0aUtH?=
 =?utf-8?B?RFB3eUhvV0RYaVA3WVJ0V05xMFJjeHVsT1ZodnpoTUwvSmhxUGxqSmdQeTJB?=
 =?utf-8?B?ZE1hbElzK0g0bmt6OFZua1gxTTdYRkZmdlRPOWlMNDJ5Y2FPc25YWUZWSHRs?=
 =?utf-8?B?SHFJRzhFZDZKYTdJMEd5Y3ZKYWw1Y0pCL2I3Z2pqaWR0M0Qvb3RWdGNaUDcv?=
 =?utf-8?B?ZmIvbGJjR01ieTB5NVJ5RnkvMjdKaWtnL1RaTkltbUw5VEI4OXdGVllXZnQr?=
 =?utf-8?B?clhBMEovTnpBdi8zTzV1eWhaUEY0Wnk5WWlLVnNOTGVMNjhUTGhodG5HRTM0?=
 =?utf-8?B?UEp1dWdVN21nQlZBcEs5bE1KRFBFaXhXcXVqczB3Q0l2dTJEY0w0d1pTWmcv?=
 =?utf-8?B?Zlo1N2ZVNDlKS0pYaE1GN1JYdzFJenNIWW52MUJrZzVPbVY4elk0Q3NXZ2lE?=
 =?utf-8?B?ejhPZEorbklEczZYck5RTUU4b1NLRmFZMHYveHdiVXVpN29kOUpvVmVpOVFN?=
 =?utf-8?B?L01mV01VbFVrWjdGK0RlU0x6UWhBSUpoWU9wd0ZIUThVWVdmczZWQzd1RTYv?=
 =?utf-8?B?UmpqMWVsT2puRWhTQW5TM0dyZ0ZJaDJLMkVJQ2RCdHFiVUFwYytWQmhLVXVQ?=
 =?utf-8?B?Zkc1TThKR1JvNFRjTFlQQzNkcXNocmZoOE5sTS9yRm1kOEpYNy8ycGZCV0ZW?=
 =?utf-8?B?OEFva1k1cHpaYW12YzRPTlhLcmg3OWdyQllmYjRieFdLeTRWWEpLNThrT05y?=
 =?utf-8?B?OGJUWGk0QmtNTjVlTVB2Vjd4WjdTL2F2Tm9RQXFncFVvanQxYTBNeWlJcmxn?=
 =?utf-8?B?N0NoRWVNc1ZhdUhHZ3JseU5HMlNHdiszT1NrRXBWN1FZQTMyVWRzVVZPd2lt?=
 =?utf-8?B?UURmazRXL2l1b0Z6bDJoZ3FQaGtJeFVXdmZPbWhsR0xXL3BaTnQxbmlvd0hq?=
 =?utf-8?B?RWVNQjhUUDJ5Zi8vd2k4LzBjQldFZVVMamIwaDROaTN3aXV5dmMrNzdNNVJP?=
 =?utf-8?B?bEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: caca3440-2df2-40e9-7d66-08ddf082c638
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 15:57:41.9850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BeDzVUb8VCwbdB6I9DS6+n/RUsyhTo9xCGIDGf6cAit+/+zaS27fnzfW7FEQPcRh9k3zJZWmkbExkaZgwy2TUevw8vFstkqefVnWI36PgEY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4938
X-OriginatorOrg: intel.com

Hi Tony,

On 8/29/25 12:33 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into the
> IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids. This will be overwritten with a lower
> value if hardware does not support all these registers at the
> same time (see next case).

Same comment as v8. :(

> 
> 3) The number of "hardware counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "hardware counters" to track all RMIDs
> are difficult for users to use, since the system may reassign "hardware
> counters" at any time. This means that users cannot reliably collect
> two consecutive event counts to compute the rate at which events are
> occurring.
> 
> Use rdt_set_feature_disabled() to mark any under-resourced event groups

Use -> Introduce

> (those with telemetry_region::num_rmids < event_group::num_rmids) as
> unusable.  Note that the rdt_options[] structure must now be writable
> at run-time.  The request to disable will be overridden if the user
> explicitly requests to enable using the "rdt=" Linux boot argument.

Can add snippet here about how values are adjusted in this case.

> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values as this value
> will be used later to compare against the number of RMIDs supported by
> other resources.

can append "... to determine how many monitoring resource groups are            
supported."

> 
> N.B. Changed type of rdt_resource::num_rmid to u32 to match type of

Same comment as v8. :(

> event_group::num_rmids so that min(r->num_rmid, e->num_rmids) won't
> complain about mixing signed and unsigned types.  Print r->num_rmid as
> unsigned value in rdt_num_rmids_show().
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

...

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 71aed96f9499..f06f71c06029 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/resctrl.h>
>  
>  #include "internal.h"
> @@ -36,20 +37,26 @@ struct pmt_event {
>  
>  /**
>   * struct event_group - All information about a group of telemetry events.
> + * @name:		Name for this group (used by boot rdt= option)
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the INTEL_PMT_TELEMETRY driver that contains data for all
>   *			telemetry regions.
>   * @guid:		Unique number per XML description file.
> + * @num_rmids:		Number of RMIDs supported by this group. May be djusted downwards

djusted -> adjusted
Also, please stay within 80 columns.

> + *			if enumeration from intel_pmt_get_regions_by_feature() indicates
> + *			fewer RMIDs can be tracked simultaneously.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
>   */
>  struct event_group {
>  	/* Data fields for additional structures to manage this group. */
> +	char				*name;
>  	struct pmt_feature_group	*pfg;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmids;
>  	size_t				mmio_size;
>  	unsigned int			num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);

Reinette

