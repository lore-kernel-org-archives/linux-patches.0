Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BAF02DFA46
	for <patches@lists.linux.dev>; Thu, 13 Nov 2025 22:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763074091; cv=fail; b=et/yX+A7Ti21HUpQiepACKa/BPy71z8WWiQ8kZYCWxXyhrdacCCc/MUixM4OYNUEkCld5kPDFY4U+0zAGHFPoSoTW2DDxSfEsPYC7uIyTKUE68ByC/jy+gTW9YOyaYwzImIQ7eWUPkksoR1R58BePOdU6+sqUjFPGGGZZ0LzAZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763074091; c=relaxed/simple;
	bh=6UT7cjeQkQUwv4MTSxMW/7gD0+z9SdVE3BesLkF4eu8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CTUtNCvNZVcumNTG2wGqEkNqaPcSqUUDcQA994sOkG/9hbobHZ8VzB5urY1YbV+oRUiTeF4eeDhTh9Wf2PXEyxMSKTB7CzQ4Fgd+9qCvOjuqNpjby4iHyTrY8UPl8SmH8TVhUdvBoFb7hsznULVYPHMiyxCpvL/nKZ7LLy/EjiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GqYDRoHh; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GqYDRoHh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763074090; x=1794610090;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6UT7cjeQkQUwv4MTSxMW/7gD0+z9SdVE3BesLkF4eu8=;
  b=GqYDRoHhvfOxlcqxH/JtD0UNKp7AT6aNs5v6otDFAYrJPy3tJ4JDdS3W
   OtzgMzKeHb+1nFsDspzGd2jPDGrjT1olRe7sUuKL7zUubjj8ajwWK0qRR
   /1/uMzJfUr75RYmlBNw8d2L2gj+2w2f9ZhqdjvqG7Ul40/c7zWd32QCG5
   4es6zxyGaFHY+SSVFq0FXzTi9qvl8rPJXn29eiPfDTB34INlfFwvbrmHY
   fUb8i5Wjwb2T4KZ3wBo0ljgbt/Dnqlj7d84zaXQobiYILJk8f9kXKyDH1
   fyYpn2gjgxROplbHF6hg1grkZGAlNuPuNrcjaZh+4KQhCkUhTAGgsIH72
   w==;
X-CSE-ConnectionGUID: wlOBQWIWSZKLJ3fqRcO94g==
X-CSE-MsgGUID: mw/foThoRBS3jR7/PdGfOA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="65103593"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="65103593"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:48:10 -0800
X-CSE-ConnectionGUID: z6N9AmV8T9qMC5QziquM1g==
X-CSE-MsgGUID: Tdw4LESjQuSR0cXpveE/3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="189815106"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 14:48:09 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:48:09 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 14:48:09 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.36) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 14:48:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HUfUC7ZGAvyhNEaN1mFf0Ly5iT1EZqpj4GUnD3dG4qBGCdAL8w48uVFMOlhNBbR5LyWM6sMIggnfZ4O2bGDPbdzPymuqkkrzsK9GN2I5XhRcIw/xnHDF+uSwuqL4EiKe9vrU4QuPJwuTAPX+BvhH8bQqeo2d8oPKYVkWRSd/xgnOpkJHiLHjfvY+PMp4uxP+n7KOlAAlmXkIFjacvHRePGYuVAxzlmiyQz68+T3RFXz+HpyK8gtSwgX46iI2+YmwOpw6He2YiCTJrJWBmqtbsHOO08h3w55KEcSfJD0DeU/ODFfD+LF86MYiPX/jx9/NWitR79H3luBxfnpylQWZxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E00z+teO/Xh7c/gd95CKwsXBZeRdJ2HTRC6epQ30NUg=;
 b=cIAnXlrufk+piOT8IRN+MBpsB4+VypbBrlaSaAWYGvHGlWSSz/ZYcpYLJ9L8Hji+L8x0o4c+Q8N9QAM2lsOsYaM2wiyBdyT16JG2NBj5eOBouqPasCAMeXs11sHViIPovjSaAhB+gMBth8Z3gjWuxVGSaUM+E4ynbEO3s8yGWEOQdfeFQ3/xqIPzv/88glfP/ffUsIVAxZOeGGZXNxyeqPWWE1oFOoA4noW6f1FQRBLbjCKxzJ3RNGv+QaOxJAlHQRCqoGoD2ZmQYu3XGfzHm0S34oUis55pVeCpFwzgKqqgkz6U35zrcQO4lNbIW6g5twQKEUGe5PDk7579TXaAsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF91320C45A.namprd11.prod.outlook.com (2603:10b6:518:1::d38) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Thu, 13 Nov
 2025 22:48:07 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 22:48:06 +0000
Message-ID: <532e2da3-5532-4892-b3bd-61304373903b@intel.com>
Date: Thu, 13 Nov 2025 14:48:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 21/32] fs/resctrl: Refactor mkdir_mondata_subdir()
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251029162118.40604-1-tony.luck@intel.com>
 <20251029162118.40604-22-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251029162118.40604-22-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0237.namprd03.prod.outlook.com
 (2603:10b6:303:b9::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF91320C45A:EE_
X-MS-Office365-Filtering-Correlation-Id: aaae060d-e946-4279-d77e-08de2306b636
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OHlnUzE5WUFBOVlqOGhEcGtjNzVxN1NqNGNmbEZrQkF3bEV2ZnBXcXVNa0FO?=
 =?utf-8?B?QS9aZXpiaWxiQ1Z0QVZoQTl6bnJOcWVNNklid1BMM0tGOXRWdm5SRWZpeWM5?=
 =?utf-8?B?NjUzTU14cHAwZDVYaVEzRTNUKzVwd1hlNEp4bWUzdjZhVHlZRTlDdDdPaHFk?=
 =?utf-8?B?MlZlcGU1UWFqa3A0THN2azFFWkl2MUNLb3JZcGNaTWFZTkdYaVpad08xRXhq?=
 =?utf-8?B?Z0o0NUxVL09MQnExemJ3Nk91UmJVNXFBOU1WN0g0L2dEam1rNm1lU0FXeVJY?=
 =?utf-8?B?QmsvMDZUdnRBU0FOdVhvTTl4ZjhlR3lpZHVQWnp5VzZnM1VTRDJyMkJwc0FZ?=
 =?utf-8?B?MUd5U1h3Rk5oZEtCWXBBTzRPRmtXT29QUVJyU1hPVExxNTFWVjFNeG4yR0xs?=
 =?utf-8?B?RFp3VzI2bTZsdWh0cTBoVjFqdDdGUVRybXlId2sxU1Z2bWxWMXRzNm96VUFZ?=
 =?utf-8?B?OVhzVHNWVEtJTTRXRHhzWjNieFFPcVh2a1YyM3grNDgyTENvY3NlVVM4T3VP?=
 =?utf-8?B?TkNUeFBLWjF3b3RNTktZU0kyWldWMExTc3QwZjhod09uVEZmN1hoM0pLZ2FF?=
 =?utf-8?B?YVlSN0daN3E0ZGwvc1o5SGlMdjdwVExvRnNreGZHZXVkczJkZy9ta2VXMDlr?=
 =?utf-8?B?WU9pVHpqbUlPUHhHU3E1Y29Bay9hbEhTR3dPTzdUYzJqb3VFTytDZjgrb3Z3?=
 =?utf-8?B?VHN3MU1TTlh2ODczb0t5a25sVUFtb3VTcHBTVlV6Ris2YlFhMUd2d21SYkZz?=
 =?utf-8?B?djlpT2piRFh5MEUzVW9vRzZ1KzVDOS9DTmdsMmQwSHMwVjFSWFJiMFFSWUt3?=
 =?utf-8?B?Y2hndHNHTHcrYTJWV0lXSExjUEtwQ3htMzFOL255b2pUTytvTDNaUzZVWlpm?=
 =?utf-8?B?V3B0MEgxWTloL3RpcVN4bWV0bXdPalZ3VW5mWXVCRVhpcWkydlZhNFZydDN1?=
 =?utf-8?B?dlFON3M5RkNma213L29XckFPWEkvMXNwdnA1cURkVkJQcS8wY0xDaGhlbmZX?=
 =?utf-8?B?Q0RYK3dveDF1L2RFVTJ3UDl0QzByN0phK24zQlR0b3FsdGRMcGJ0eFgvdlEw?=
 =?utf-8?B?ME9EeG8rblYwRjk5TzBMZnZjdFlDZExDRmprdmV3U3htOFpObjNtaENEVDhh?=
 =?utf-8?B?amllZS96SDhsajloRnZxdjErR1hDUzl3NGIxbXJMVGVEYThEQzhtY3d3UjhL?=
 =?utf-8?B?WjA4Z1dBRURYMmh3eUxaYWxTcHBOYi8xaXlLb2NoSlJ6KzRib0V4SThEZlc5?=
 =?utf-8?B?WnhqcTN2S2Y2WmQxRDdlajJRaWMwSGM1YWQycktKTDhYK2VDeTVrM0VkejBW?=
 =?utf-8?B?QzJvMVhYcldFZXd4SWVtdmcrNytXalJTYS84TXdQakFBWWJtejYzM0srYkpP?=
 =?utf-8?B?LzRGeWNJSFlYTkhqSXprQmpSdXg0cGlIVE9iSU4rU1ZWMUVlYlZUSENlZHA1?=
 =?utf-8?B?T3NCOW44UWdPNjMxOEJleHkyOU5vN0I3aEJmWUcvQkNUZElLSCt1bzAwTW9V?=
 =?utf-8?B?QmJiOFJ5aEZNU0VnQ0ovVGJtOWZYN3Foc2Y3YktqYWlzTTd1TFNwaFdyVldO?=
 =?utf-8?B?dkV1VDdzVHExNGFJY2s2SE83eXI3Q293NFlqMk1XVWpORXFSTmdsQnhTZTlU?=
 =?utf-8?B?bUlibUpiZDJWeEt1dlh3K3FkQkFzVDhlRnVwN3BrUExYeDlSMmNHbHRpQVdI?=
 =?utf-8?B?RWRyWC8zbVpDeTQ4OUJQdHB3Z3FPTGtqa1lMSHh5ODRkSHU3KzFlVHNzKzdn?=
 =?utf-8?B?dzZmK2dTQWVWblorSWg5YUI2bmdXZ3o2OUFEcTRaKzNJODN4TUFLdm5NMDg3?=
 =?utf-8?B?Q3Awd3ZCTzRMeGZOV1FkUC9DaE9hNmZ6YnNtMUNybk1TcFI5Z3lSOUp6UVFT?=
 =?utf-8?B?TjM4VThlcXdmdDdIYkpma0Q0UTdQbk8vNThBSGsvc3dnQ1orazJrVmJJcmxk?=
 =?utf-8?Q?dYRkn9/ZG3ISa32cS7ZSOZFC98Z0oiYJ?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkFpOG5nQTIwM054NG1tM3RURDV1MHQwdHlLOHNyNStPU1FucFZ1S0VvREw1?=
 =?utf-8?B?MTl1VmtidDl6Y2xCL1krZW9wNThxMGJXcGFna0tKUCtKcXJ2N1ByM08yWGdH?=
 =?utf-8?B?eS9mL1lWd045aDk4Q2J5NmRxOXFMb055WHl5M2tJSUJYUE9wZ2RKMExDYWlx?=
 =?utf-8?B?aFNrdTloWU5mcGJrQi8zWi9FQWNYeUNCTUUybm1DM0svZjhyanRQMEd3MmFH?=
 =?utf-8?B?aTBDR040R1JoNEJ1RXNmUlBhVGFTNDliV2lXdXRyWFpQYzd4azNaZ1ZOamJ0?=
 =?utf-8?B?UlZxUk4raU5DNmM4bnd6RUJYaThjQ2I2cHVZbVdob0d6Z1FSaGJ5NnZjdTh6?=
 =?utf-8?B?SFhRV1dNdVl4dXA1WWptcUp4M0NQQmdDNGxxNjN6ODF0ZFIrR3E0M3JZN3Jw?=
 =?utf-8?B?Q3Q4Rk1pOFMzUDN1RGQwTjFHeGRkcE0wQmRKdDl0dkIzbFZOK2VsOUUzV3lH?=
 =?utf-8?B?djJZTFBMTkV1VmFheXdQd0NBdnVna0FDeWdPQnc4Vkg2eVpUbnNGRWQ1aFdk?=
 =?utf-8?B?Q3dnS1JDNVJvU2NqQ3dsVXkvRi9iTjQzUVo1ZHJxdERUR0V3SXFCSHd4N2dS?=
 =?utf-8?B?dDlzMlJSaXZKTGFsUk5Ya0pJS1BkVFM3Y1RKMGE4bFRhVlJITzRndFdTTnY5?=
 =?utf-8?B?SnJ3dVV2b0l3RU1Fdms5eGhUSE8vYVNmNUdzbVVWNnRFbHNRTE1tN3k1bTh6?=
 =?utf-8?B?L0NadS9TeVcweW1Yb3g4Vm42TEtYNVlrbmIvdmlZQzJ4U0tMV2RLYUQwU1p4?=
 =?utf-8?B?dWVaTTFCNXJYSHA4eldkRjljQUlnWmxZaVVWbUpaWlBWU0MwSkxwdlA2dnhk?=
 =?utf-8?B?VEhjWVR6U1UyQUpJTVBpSUFEaS9tczl3ZEpjQ1F3QU5oeWxYK1dnTGdwT1ov?=
 =?utf-8?B?ajNyMnhBNjl0dGtiNzFEQ2ExMlRaUzBpeDd5aTNXNkM4YlNLaEVMRWcrcFZE?=
 =?utf-8?B?UGVjdHNVWitrMm15QStNeU1md3JOb1FXSUM0VFd4emVwQU50UVlVLzIwY2pU?=
 =?utf-8?B?cVYrcm1ydWhzbWxSUHcvbVBnOHgwT01ybnhlc3NCTU9yaVFCV21LWHZsVGhC?=
 =?utf-8?B?R2czRzVCVnMvZ2NnUHBFV0xlUHJkL2IzbHZySTk4cDVTTHl1dU1NQ1k5YWdJ?=
 =?utf-8?B?RjVlbEt4WFVMbUM1ZkhVU0pSbzJvVHlxTGhBRDVCOU9hWVR1YjNNcUJvUnRW?=
 =?utf-8?B?RzJjcDNuWi85KzNCTlMrSGNHaXV6SktmZEEyMG9OVDFHKzNvSENnd21zRTZv?=
 =?utf-8?B?TW00azBsNW4xeFVhbmNyTEw1UHNoR3B4WnpJZWk5UTZ1ZGpsVG0ySHlhdzBt?=
 =?utf-8?B?TmJRZ2lmYjl5aEZad2s4WUVtQllxS0o1QWxna00zNUtIYTBXdkY3aStnNURv?=
 =?utf-8?B?TzFuRmJDWVM5R3o1c2hhVXdFaWUrc0ppN0Zla212RlczRWs2Qmx1aDcrOFRH?=
 =?utf-8?B?UERTVVRkM2QzY3hQRTV3TVZ3MEsxTDNFUnlKQkRQeTloRXNaek5hYzI2RTZ3?=
 =?utf-8?B?dEVkY2Z5NEcvSVE0S2d4eHJ2dldGQjZCTmk0OUN3RTdLY2M5UmdPUUNrbThG?=
 =?utf-8?B?MncvbUZaTE9MMTI5dXZReG5ib0lJQno2VkJmMHA1VSt6T3YybjlWdWs0d2g3?=
 =?utf-8?B?a0xnbGU0RlR2b2Y2bi9kRld5bCt3cjFsK1ZwREpKVWh6NFp3NmpsV0xia29a?=
 =?utf-8?B?Q2lDMCtBeFBORXN5Rm1ZeVhGbzBScGtnYXpGa3E4aytNQ1BBVEpZK2V5U1l1?=
 =?utf-8?B?WWZsRktvajR1TnRnYW8vNUNqbmIyWkxBQmNLbHBjZWQwVXZrMElrWlc5dkVX?=
 =?utf-8?B?MEtQWjJGY2ovTFk4TjgvdE15aXQ4VGpnRFVNY0RCYzdxb0grcWVjQW03cCtn?=
 =?utf-8?B?aU15VmNVUFAyRTBiSGF1WkZsaWp1anpRVCt3eWYwb0hsTHN2MWRVMmx2QXdo?=
 =?utf-8?B?N1JFMDVYcUtKblFmVjVkNCtqZGxzQ0Q0TVE2WHJZNG1sUlU5L2dTQ3ppRHNE?=
 =?utf-8?B?NlZmMCtrR3ZlaklRU3dwOHZ3Y251eWNSeFZaSnVMdlppSFJzTXExbGRPSGtu?=
 =?utf-8?B?cDJyRHRpZEIzdXIrMDdjcG1jUlF2MWZydXJtM2lKay81SEJhenVsU2xqTkdR?=
 =?utf-8?B?UHIrSDd4YWowa0pmRlM2SjZpUHVjMkthNU52akMvZy9BcWMyT2NpZGxVZWJk?=
 =?utf-8?B?cXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: aaae060d-e946-4279-d77e-08de2306b636
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 22:48:06.8920
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rpLeqNdkorzZGu0yKsiEk7DOTodeB4COSjxTAveGbhcItJQAfPig1gzymAvLTqUOvVbqM3scl85bXHhW7siPYrHwhK1rsFKjAapUmL+K0nc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF91320C45A
X-OriginatorOrg: intel.com

Hi Tony,

On 10/29/25 9:21 AM, Tony Luck wrote:
> Population of a monitor group's mon_data directory is unreasonably complicated
> because of the support for Sub-NUMA Cluster (SNC) mode.
> 
> Split out the SNC code into a helper function to make it easier to add support
> for a new telemetry resource.
> 
> Move all the duplicated code to make and set owner of domain directories
> into the mon_add_all_files() helper and rename to _mkdir_mondata_subdir().
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
