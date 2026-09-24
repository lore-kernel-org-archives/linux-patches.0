Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51D7313E21
	for <patches@lists.linux.dev>; Thu, 24 Sep 2026 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790263082; cv=fail; b=YDmJAPACjPOiSrVU5VHmU/yWoIlNZt50eu9VAJqYV3VNQtVvBjzsYS2vAOExi+l9Im8AwTCrL+KMJbwSsRklEc/JLHnrLf6cOb1NkmZN/RMQUV1QqIimUKUPRdqdDXj4I01QANHJrRj8BNLC862NtXltgLbmskqItWkks+l2LA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790263082; c=relaxed/simple;
	bh=SRDwRuYpRNJVl1traid4j7gTFvN3drT4tHOyAb3Y5iI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cBOsmr8oD/+kq5JBlfk1Tg84KKXTJ15bG7801gfJhp+Uknp0dP58roIo+Ng3hzpOg5MGQdORhXKJkVAuf+d2YST8sKxbAfJp/+wD6WnQftjXMWA4+xPCu1aTnyuL5upJUPpvaOqb0t3sSsdChRAZ4ejwmrwd4+GEVOCxwgXcQrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gjyr8ZHZ; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gjyr8ZHZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790263082; x=1821799082;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SRDwRuYpRNJVl1traid4j7gTFvN3drT4tHOyAb3Y5iI=;
  b=gjyr8ZHZG3AcLdKtRPq7TpNVnHfKqHctdp6UxfJjJBO21gXHB5XJKLdR
   eHrDbY1fUOqUuL2TdatJ1epBz0sJAbs2+wjzmW3xPv3bYpstKt71mPCtB
   /4LLIw0nlpb1DP8bZtmfyjALu6gTjOSFEUHpwICpjB2hs9Eewwn5zQDqU
   ATgiRXcn+LEH3xTuX8wLX4JuIqocp14XPBcLwkFGPNjj+PtACD/GJtGVJ
   qjPNWXSdrpz331pk6MzLVzjKmWrvJow0ArmB2hH7nxFFMxuXikXggr59u
   b/ywxTZ7iv83h+lLHrya7Cgcalgo2Jf/VLgU/W5VAlQNBd6JBs4j/uqgF
   g==;
X-CSE-ConnectionGUID: zvXgySC4SRuXwPdQQexs+g==
X-CSE-MsgGUID: IjX8f7xNS8Wrvy49Ne4N/w==
X-IronPort-AV: E=McAfee;i="6800,10657,11915"; a="89807503"
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="89807503"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:18:02 -0700
X-CSE-ConnectionGUID: JcBruVzfQq+XrRs/AS/GEA==
X-CSE-MsgGUID: cfRs0m2SQNqrYg/hZahnBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,120,1787036400"; 
   d="scan'208";a="277226343"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2026 08:18:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:18:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 24 Sep 2026 08:18:00 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 24 Sep 2026 08:18:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GBJyQgY+s8o1Gf2Qjq539ODc/fQvH6PUccMmGx2lnd9lscbuDcpl4K49XWre3oMtUNUPDd2eCx6HOzLio4XmsIA++4XUmzAGJa0hK5ImjRMC061xS+qxKPA7v7EBqjE/ec1H6VHfdQXtSEWwTirMrkgBIbk5Qh9P/LdOgO4gQh053kfBEw/fUE/zpGhsRNSkn95w3Dw6siqpOEcsLJHk0fScIPJx2ZwlJV7U+t2jcwBKqH0FGPIpz3Z6vGecC1EiYGniBHMcCB1Pe8FLqJXF6cX/m6bqVMqNyWIpxjj3CoSufiVNbIY7jKNRCJMg+/P4k4p4jRoj4dN2YRCdAsV+uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/T2nvm6j9xXnIDsldcwnG4WKZwRMI3zRNjD0WOidsI=;
 b=mtmOfi4O73t5qoitfCKTCIS18mF3gJ54bnC0ZDFhUHwl4B4+egfuAcYGMBLfuvueT6TFTW6UiSd8f7pHSDZ6RhvfsFvsbyeQPXx3IJCfgT921+miq2aICeHwBIRBlbI5j6uM6GfoL+rQPmHdQuhiquDEXWHg8zWqmhCA7G+Lzg4f5ohDtMDH0X4OK51aqTwJ5IT5p0EoOrjDEEbRfl9sGtpvyJIEJLrogjgQrwM+w0cbauSvAGSmkaIQy8wlG36cp7QRL6For5rtiB8tDAXUL67P4re3eWDYM+S9vMH6DDo23obq6a1Ztfldt5QcfLWp0M4yualO4GGhqjUvrOF6xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by SN7PR11MB7437.namprd11.prod.outlook.com (2603:10b6:806:348::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.14; Thu, 24 Sep
 2026 15:17:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:17:57 +0000
Message-ID: <7aaf83b3-03ea-47bf-809b-561beb6b3843@intel.com>
Date: Thu, 24 Sep 2026 08:17:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 04/25] x86/resctrl: Apply Intel MBM quirk from
 rdt_get_l3_mon_config()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>, David E Box
	<david.e.box@intel.com>, <x86@kernel.org>
CC: Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-5-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20260916231320.14502-5-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0144.namprd03.prod.outlook.com
 (2603:10b6:303:8c::29) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|SN7PR11MB7437:EE_
X-MS-Office365-Filtering-Correlation-Id: 0febb309-8f70-4430-1d7b-08df1a4f0317
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|1800799024|366016|10067099003|56012099006|5023799004|11063799006|4143699003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info: WcSXpvpJ3lFwD4ZBaJLk6Uc+OK8yXRsaQZJK5XJFhLIwNofGTkOhSzwcBrDHGuy0FCyvHzPff4vMOinCQaZKEo3Z3KbCtsQ1Bi6JJKww6F0PqzQji4fUOKRGROCafTvodRFBMQcvPTcMl8rRFX8gtmiXh6XxBd+BjPpCfGyC0K6A9Cn83pDPclZoquTu3QUrtduNSkBLlpHFWBdYLs0N3pV1a39W2fxJrPyivLUOba5GC2d7ZKuo7+t1aMHumgH7tHzUXTsy0T2ngRNIJv2tt5AAFLPDsJxdPD/JHm+/Osri6tmvM2wLjzSYwwgJ2ffNsmkQSaylLEbLD0p3TutqI1TJadUtSIlBwrhbXs41/w1tiJTNVN0qn/0wZOEvQeY/z4UF1m523e/c/xQ7v1rsyBf2Iz32mHQmuC3thxxorvImV9RnFnVej833xJq5M5LGnt1jAz87Q74NrVbHWS+Yjp4rdjzV45mGe1RnVf45BDkbcDhtrxHQqFpAx5VqI2cDpUGsA7XQCzk2MBmqBWcTJz859eDglRh3yGFkOd3cdzfHjGy11serqdrofUZcyupw+f3fK44weJ+o/XnHSyzxeL82alHmtJzQusihrW+ud8hMt1YOGLN+K9/Q0lHcc3KrGdn/uk7lBbx4XiCZO2iA9e8BHSkjAC42nWZDOfQeAWuVDNgY4N2Bcm6fuepDILWi6eYRRap/YLpmH12XJTgc1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(1800799024)(366016)(10067099003)(56012099006)(5023799004)(11063799006)(4143699003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VEwvL0Q4aEx0a0hXWVdxWnRtSGtrTVQ5Z2hnbzM4cUZjTTRBRm5TT05wVng3?=
 =?utf-8?B?Zi91bGJTZUZVV2VKY0hEYXF2amIwNEN3enYxNGJxaEpuMDNwMjI1MnZ1cHFv?=
 =?utf-8?B?RHc1VXR0MDE3UnVJWWtSb2FBczMwZGdjQVhhV0t4OEtLTlZQTHo2NE1IQUVR?=
 =?utf-8?B?TC9tVUd0OHY3dVI2dWVrZ0tyNnZoSjNsZFVjYXJVRHU4Q2tzY290emhKaW1P?=
 =?utf-8?B?TjUxWVJHRVBvQ0pTek5VWVU4SXRMUkpNT1o3R25XdEZxMzQ3NU1yNjZXTThL?=
 =?utf-8?B?YjJ6b29TWTQzdEhTdFp6Z1I0K3o0Ui9uampUaUxqWXZUZFhwSWdXUVUrWDNP?=
 =?utf-8?B?anNoWU5rMWtBZ2VIdm9yNXQrbnZoaG5YZUpoSGFTUmFtVDVUY1g1L1FPczh2?=
 =?utf-8?B?NnhxMmVZYkxCQjJmZEE0dmY0dXJpME1wajhRSlIrQXlCdWNJL1Y0UlU5L002?=
 =?utf-8?B?MkxsSmJqN1U3cnlENnpodDRKQUU3dGlXbS85MlVObmgydWg3cVFUNHpXUi8z?=
 =?utf-8?B?dTRHUEcvWU03alc2ejlJNFVLdDNqY2hCRTFZTVpmT0JBOTF2MGhiejZndnBX?=
 =?utf-8?B?NW9QMUp4V3pTbms1ejVGVDNUSS9nMVFNcUxhb2xjK2szbWM5MkhqWlkxSi9Z?=
 =?utf-8?B?OGtvY1p1ekl4czgrcjVhR1NFdmZYQXN1dGRveTIzQUphMGtJeGVRY21qWkhY?=
 =?utf-8?B?VnFNcVdFUnV3Tk5lT05qdWxuc3g4YktzZ2pyZVpHSHBvazhCeVkxVitLeTVG?=
 =?utf-8?B?eURQU1A5SjVWbDAyMnZDK0RkaW1WWHVMQitSWDdVMjNZUkdaTHB0ejNwYTZX?=
 =?utf-8?B?b3g2WXMybDlwNTFXK09mSk05VU9kNE9BS1k1Mk5sVmw4NHBvb0tPS3NoQ2dJ?=
 =?utf-8?B?YlVHNjR5ZFhFNm85QlducUk5VVBtU2pSUTNLanRLc0ltY2xFdXQxZWg3MC9E?=
 =?utf-8?B?Y3pqVkpvVTZlUXQxa3pxT3hXbVBSREVTQXpHMTdqNVBhSitpRy96VmlOQlk1?=
 =?utf-8?B?SWpkYVc4TEcyK1ZRRHpIY3RBVldGWnV6SlorL25zK2dHOWcvL0tYUlZjS095?=
 =?utf-8?B?dnRHWTk1b0czZzdCMjVsNDVDNVZhWFZVU2syTDZqNDVqbVk4YXdSb0gzNEtw?=
 =?utf-8?B?OGc2cWR3OHpwQS9uSTVXc1VJN0U0Z1RheEdmeExtTWFrWkdEWGtyZUJjOUxW?=
 =?utf-8?B?MUNlbzU5UHdsYzdnbENWcFJ4Z3QzZ2ZGYWt3Mmxod3NJcm9uZWc3WHdBeTJP?=
 =?utf-8?B?RFloWXQ0bWcvTEhiMHJnemZkdGtnaWVsNy9FdFUzeVdvM09sQUdHZWIvVDNa?=
 =?utf-8?B?NjF5RmlVMVVsNUFjMGVZRmdMeUVMaWRWRTVudVJHUDdlWGpiejI2MkFYdW8x?=
 =?utf-8?B?dzFOSFdiOW02WkdFSXhOTzg1MUd2U0tpeWhQUU90SmFNZmNjVUpaR0tQZFg4?=
 =?utf-8?B?R0FBcTE1bmhpTzFpcmx4VDhUdXBTcWpCSXpNazkrQXNNYm01NDBFanVnY1di?=
 =?utf-8?B?ZkZ6UW9YK0IxbEJycjMzWFBndXpuOER2MW5UdkE0V2o3MGxHVkJxT29ueXRs?=
 =?utf-8?B?bXpXQVlVVXJBVnZzVG5HYTNsSjUrQUx1MjRnWWh6TXZ6V0pRNmZoTjNpSEhn?=
 =?utf-8?B?UUpOTXIyc09oNHdYYnZOcHJiUmxqeVJ2SWJxbUZPa1ZIeTE3Q3p6bmlDTzRC?=
 =?utf-8?B?ZjJGL3lQNVI5S3hzcys0VFl5NnI5Q0VjWE9IWEJLQm5aUkZZSnhicGNYdlF1?=
 =?utf-8?B?S3ZtdlpuVXM1NFUxY0I3UXoxV0w5NEk5ZVFrRFdxcDdNVEo4S3ZoSmVoL3Rl?=
 =?utf-8?B?ZjIwZHlzZExMdGdqc0l1MTQ5TGEzWktKKzFtVUpKc2xvNitsdlkwNnkzNmJt?=
 =?utf-8?B?bTVxNHFWdzEra09ON0dVMFRvRVRRUHIyK1lrYTBlZnFnYTZjK29kYjZPZmJn?=
 =?utf-8?B?YS9iak00YUdhcmYvRU9NcVFrUmQvWUd6dGprVkxnajJUWXIxVnNaU3lFSThE?=
 =?utf-8?B?cUQvVThqOThvMWIwSTF1STNyOXpVY3pZdXNNWjNGYnh1QmV4Y1FNRFdha0JX?=
 =?utf-8?B?bkk3MDVWZkNWeVhsTkNOZ041WVlqdTlrbmhheis3ajkrUHp5OUltUWRHWHYv?=
 =?utf-8?B?SzNSRklpbHNVZ0FCanRLNzBvdGhhVWRHUktWSFhicG5jMC9xeCt6UlpoaGo5?=
 =?utf-8?B?RC8vYWUzaXNaTURvUkxoOVcrcHlIbXJyczBzcG9CaURTcTQzajZFSEg1RE15?=
 =?utf-8?B?OE1yUEFvdmpOcC9SV3ZrR3dLYW9pYkZCQll1dm9nQW1CUkJHbittS0VHME1h?=
 =?utf-8?B?WFZFTFhBditOWXlhS1FqN0tkWGtPdTgzTmFUZU4xWGhnQ3o3eCtiQlhxVDRE?=
 =?utf-8?Q?0QTQHsEkQfQP52eI=3D?=
X-Exchange-RoutingPolicyChecked: Ic0t/QFDYiO+LJPX6JzSzZ/rchM/3fXZfwQCM/zQCC+GiHjYiRfgGC4i8CRk9ynPZtJROy17oQauSGj8CgmgcLLYT64DkVXDQHVtTwjxsC8918fwS8qejyMo9pbbXYePFWLW/krFF2Iyq6GEh3cuzGAVAhOm3DvzOnen1F57u19DN15bJ9olH4niC2jn6TQ4t9fv6Pi5Jdvk33gu5CW8Wd158Y6c0GTzqTq+Sr0aw4QurZLNEyJwiZgoc34H8uDlLY+r+IggGEXboXgjrHK8HCdq9jCQQr1tEdzWPd7KPtTrTO6ltC1YCwohlurbBE8fhH9Jc2Y4irtLJjfsyly4SQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 0febb309-8f70-4430-1d7b-08df1a4f0317
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:17:56.9052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dWRZZDiz7/n9KWjv9PsemuNw9F5LFE9V+nnHP4tN6H5jKfuRI+WnKqKSGJUAzq8Pif+uK7poL+x6V+r+ujSsxHJUkcF+hYx3c2/MHxM2QQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7437
X-OriginatorOrg: intel.com

Hi Tony,

To not document code the subject could be something like:
	x86/resctrl: Apply MBM quirk during feature enumeration

On 9/16/26 4:12 PM, Tony Luck wrote:
> The Intel quirk to adjust Memory Bandwidth Monitoring (MBM) values on
> certain CPUs is applied early, before discovering if MBM is supported.
> 
> Move the call into rdt_get_l3_mon_config(), but keep the decision on
> whether it is needed in __check_quirks_intel() with all the other
> model specific tests.

Last paragraph just documents the code change without any explanation
*why* this change is needed. Consider something like below (just a draft,
and suggestion, please improve from here).

	The Intel MBM correction factor quirk is applied during early CPU model
	checks using the RMID count from cpuinfo_x86::x86_cache_max_rmid. It is
	the last consumer of the resctrl fields in struct cpuinfo_x86 now that
	monitoring feature enumeration is contained within resctrl.

	This lone consumer prevents those fields from being removed, and applies
	MBM specific setup before resctrl has established that MBM is supported.

	Apply the quirk during monitoring feature enumeration in preparation
	for removing the resctrl fields from struct cpuinfo_x86.
	Keep the decision on whether the quirk is needed with the other model
	specific tests to avoid scattering quirk handling.

	No functional change intended.
	
Reinette
