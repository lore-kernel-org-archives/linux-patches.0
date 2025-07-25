Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00FA28682
	for <patches@lists.linux.dev>; Fri, 25 Jul 2025 23:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487762; cv=fail; b=cQ6Pt8AxQyA0KQ7mSypXKJcIPlKNc+gcnkl2J/IgnSOzMHNLKyoQbHM9EhZTxT0hUZgyKP2LkuiHwPRRvR5Z5s9vqHoMOx1SEwUVsOYvoPzdZPonvk2UhQkoBwAhLPgMziqETvlwqsVwFLI2ZDAa8MyPCltxdRUKwAvVGcg2B7Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487762; c=relaxed/simple;
	bh=HrXO6wdqaObJEyUB3S0KRxO92TDaqUJDOJJEsuIM5R0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l8h2MZhCHFJnzqxrJ9fsrJF2ZnxZTRLUTnDl7hjDQYCxYmPx36XV5h2WJSHaREedBFCTe/0Zt7CartXK8FuEyQSKeN/J++C1498KOC2ZytfU3G7t7H5IdtWZsdHZHHvAE+xIhnbAdgaetjqe0bcpI6NGvlovymKo9AzxI7nysTY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C8WULpTz; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C8WULpTz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753487761; x=1785023761;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HrXO6wdqaObJEyUB3S0KRxO92TDaqUJDOJJEsuIM5R0=;
  b=C8WULpTzwi1khYs/AvFZ8zmUuEdxCnH//Dbs99TtQRIyKjV0wA7Q/IG3
   CSCAvohtgwl2CFdldlPJQ2DuACOehk/VnukN6eTPPqapH8NvIL2jHNHti
   FJqFXE9s5XEtM6pO3mToJU+dzIgwK/QDg1PlQuLT85GKLaU4+SLvx9kYd
   xBx3Atd/EepGHdJr3na4PUceCks2TpmlK/G1HbCssyJevIRCvizmawuJ1
   p1/EeTX1F82gbdovT4bMaeToUPo+HNxFjwhxjdjBtIsTWcfksgTFlUt3U
   psGP3eeM/bVwCNMzwRINlSOoKISvSObCJfUBc7+J1FTXmN/qot6W8INGO
   Q==;
X-CSE-ConnectionGUID: bdqylEFXQ9S8ZZOnOHgQdA==
X-CSE-MsgGUID: VnoPkmPiTaeWu+yuyiHPbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11503"; a="55793843"
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="55793843"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:56:00 -0700
X-CSE-ConnectionGUID: Krt+NeeiSxWreqKXcTBLnA==
X-CSE-MsgGUID: cP7Xs3h3SDeEbDAfhs4UfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,339,1744095600"; 
   d="scan'208";a="166578838"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2025 16:56:00 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:55:59 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Fri, 25 Jul 2025 16:55:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.41)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Fri, 25 Jul 2025 16:55:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b7ACEn1ZpgxZOURdN94gTdJufvR4XU/X+9QZUT3sOSeL9ju95hJvVAek/xPkLCIHgtbp5fiuHqBDzr6rMowy7Hq3n/RQRgxf9sItp4MjLIpSYfZXxCVT61gzvsXLfCXo1JJJwAQiACZCNaauPVUucmPRvKLi9jgmgR9LImeg3ejSmc0FA0oS595E1NPS223hHZO2QR2Uq8Q9kqKS4QOUeHWNC4h/mG3vymExJD7sMrPHxRrS3W68h/HW6xydGMr72wQHxL/b9ntVo0m8saHxIS5VPs3g7toHGY13pEprlL4hcbAS+i2jQ7FmMOoe5vwsUX4YK82JQ0RVtAYoN8pxag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BfsQ2m2fZuDA41dqinbTWBm7lh7iAXpcG3VeyuaBCYs=;
 b=BPnxbH0tOWvNIWRRSpunBAft2XNzoS6BHlnQvm97W8dL3G35QoJ8wrobOrxBhCaq6sMfI9cUoLiZPFCgC9+SAAyCHb25Y4mvvE/3kGM22BpxqHOaSKE9KDLUWM4rJxh96QMyglg5qe/0dZXQ3vgpjFf22rIvFGDDfUqWzgPU35q9vcDSKnyH9F09WFPmnxgDyxGQXNJvyYoT/IYSyTp7WhWfqXbk+YayT2wyPA7mEkvPwbdwQ6l9fdVu7eOQ4ClmBivlx5Kdh68FX8TypnWSnrTAL0saHOyGkhPQj5B/dBnggLlmnj43qi4gtMD93qo+8yv79R6cWrCSd8LmePqLRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS7PR11MB8826.namprd11.prod.outlook.com (2603:10b6:8:256::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.22; Fri, 25 Jul
 2025 23:55:29 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.8943.028; Fri, 25 Jul 2025
 23:55:28 +0000
Message-ID: <d286d455-dbd7-49f0-acc2-7d5eb3b5c4e1@intel.com>
Date: Fri, 25 Jul 2025 16:55:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 29/31] fs/resctrl: Provide interface to create
 architecture specific debugfs area
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250711235341.113933-1-tony.luck@intel.com>
 <20250711235341.113933-30-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250711235341.113933-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0093.namprd04.prod.outlook.com
 (2603:10b6:303:83::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS7PR11MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: 4f57d714-d36b-4f80-9a70-08ddcbd6bb62
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWcra01LR1FhQkxsakhzWjNvcmZsTmdpNzZCQlc1OWlGeW5sRDNqbmhZQWcz?=
 =?utf-8?B?WUpmRC8ycXhtd0dJdXRxb3oyWjljREg5Z3FOem5oRlEvbklyekUyNVRMNW55?=
 =?utf-8?B?WDNlWTR1d2RseEE2NVNCd2ptWFd0bnlJbXFPQjZrWXZ4dXQ2WWdJVkxCSGor?=
 =?utf-8?B?ZEdCSE11cFczQUh2NzVmQ0N6Y2c4bW9zdFk2dTJSM2loVmozYjUyUUEvaU9p?=
 =?utf-8?B?ZGtKMzVJQWQ4Vi9IL2JKbXdRWVE2akhGWm9GdDdUU3hwekJqeVNVVThhNEZD?=
 =?utf-8?B?NkNtdEcxN2JDeW51d1dsTlZudDF2N1JEWWF0VjUveVlXeGhxWU5DN0NrVkU2?=
 =?utf-8?B?WmhrdlVqYzdPRTFCbGk5aWxBaGlLU0pmaUlreHlqWjdLYVVpbnBnaERweFBL?=
 =?utf-8?B?R1dNYSsxQ0JxMWZUU084OHE1OUpTOWtkanhCckY4Z2x2K0V3bmlReFlxSEtk?=
 =?utf-8?B?QzAxSFVnUVBISTdnbFFHNEprQnFyc2J0aFlQYWlNN0FPR0lOcnNkYVVrRDFk?=
 =?utf-8?B?OHFPL0NaYUJlN1ZXeWgzWlg5WHpiVE12N01zQ3JIajVWUmJYL3IxeEkybWZ3?=
 =?utf-8?B?d3FFZU9vbk5PbHNtKzNaUnNVWTF3aGNWUGY4cU9XZktkVjBRTXlWT3lGMS9u?=
 =?utf-8?B?OW5reWZMWHVkK2llL3FhN0RDMVJteEtKMDJDMXVIelZzYlBWMmJLTUpuUVpS?=
 =?utf-8?B?TnpVMFZzQ1VlWGFpeUhGM1pBdzYxYjlwU1B4S2ZOQm1mQlNmMzBGNTVTS0FX?=
 =?utf-8?B?UTFIb2ZWYm5UWHVMVzBhay9hOXRDbk5Qa2t0VTE3VVNkOXlla1pBZ0trQjYz?=
 =?utf-8?B?aHgwN1pmWHljbXQ3K1RyRlJ4elhVaXROUks5YVNCWTRjeGdLRzJObFB0NGxq?=
 =?utf-8?B?SndGaE1wL3ZNcWpmWlRvR3M3Y0crWkFSWXFya0phRWkyOEFiT0ptOCtSYUJV?=
 =?utf-8?B?THhYUDZpenhOQmJmYndpQ2gzMVovVkVjbTZBTlBkbk02TjJScjJ3MDY1YkMx?=
 =?utf-8?B?UjlKeUxhNWFCeng4blh0cjNIa1l5OWJpS1pNUWJTaWMxblJVU1l0djRISlpB?=
 =?utf-8?B?b25wd2h0M0VYYWRFdk5tTDVMNk8xNkdUOUpyMEdKN0U4MGRsMEtBckxDZHpD?=
 =?utf-8?B?ak9ObjlhOGVJSjlJQUxOZEpWVHY1aHFHbGNUQ0NESmdLeHlHcGF6dENwZnRY?=
 =?utf-8?B?cVJUajJoaUFxbzV5QUwwRWJBZ0FPb293MlpINzBJWGdYQnJ1ZnNZdzZGYjA5?=
 =?utf-8?B?bGxMOFE0ZnZHcFZ3QTRzeGs0a0dmU0JmcFVFRWRRZExYb3poemdHU2E2RFMy?=
 =?utf-8?B?cm5WUzNkZ3Zva1lKWEVxN3VLcVVxcG56ZStMNHpuOU1UUisxZGNYdWwzM05L?=
 =?utf-8?B?STkxczhwV0hOalIwN2E2S2RTZGhEUzJKYVU4R0xubWdxa2w3Q1ZRVXB0Nlhr?=
 =?utf-8?B?U2hyWmtiUytvaGJXRFFZWGQxcWtMYjZpbWlpaFM3WEJTTndxdUs2d0FQTGFD?=
 =?utf-8?B?MmxnamdjOW85bmo2R2JkYVdtRlRkcFpuTjd6cE1FcUZxZE9lRFh1RDA3VE1j?=
 =?utf-8?B?KzAxclZOY1o1b2FHR1JnOU56WWtPUVNkYi96bWNXMU9uTGc1Wk1Ic05vZVVs?=
 =?utf-8?B?VmQydDk5MkZaOEF2R3NIR0dvV0RlVDQ4YkN4eGUrdElvbytWWWx1T09NZ3pM?=
 =?utf-8?B?Mk1EbnVwSTdoL3p2QVVKMEY5dnlzQ1Fzb1FHQTY2bHhMY1g4cCtLSUxEVUhT?=
 =?utf-8?B?OHhtcGF5UmVIclZ4RlNweGltd011a3VUdE53a1laTDBwVmpxRUQzL201ZkNt?=
 =?utf-8?B?VjNCNk4zSEF5c21wcFpiNmYreHBZNnEvaWpFbkdPdkZxa2tYTVpWQ25KMmtn?=
 =?utf-8?B?L2czNW9jTnAxdG40Vm5QdURZdmo5OCtRcWxQeGlpK2V5cS9zcVdUTHBmczg3?=
 =?utf-8?Q?BblDqKK3xU4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlNJL2ZUb0swYzI5bUdrU3FuTW5ZVU5PVXgxZW9lMStMNVh3MXJSVTRROVdU?=
 =?utf-8?B?alVHUWQydUs1WEs4bDdjdERrRm41MlAvQjUxTzhlRFNHSjBDZTlwREVjWjdJ?=
 =?utf-8?B?M2ZwdWM1RDAzVWFqcGNhdW10VWhLZG1kZFRBK2RlOGRuNU81TFVRZFVPcy9u?=
 =?utf-8?B?NTVDYmdSUkx2aFpGL25tbHBPMVlEK2NhRHdnWVR0aHZNLzJhQjFWaDU5QjMy?=
 =?utf-8?B?TzRFdHZjYlo1SkxNYlc5MFF0RkZ0UlhrVE9zR2FHOVREK0luUDYzVmxhU1Qz?=
 =?utf-8?B?N1RhT3hwdHVUZUpBOFlXNTRqbmc2dTU4UXFwelVZN0xwWXJvek9MTldOemZ1?=
 =?utf-8?B?LzhPdU5QdDNHZTBIRytmTDZhTGcxWWdGM0ZGVUdMT3VCU0JkOXhSL2xxb3Vu?=
 =?utf-8?B?VStINERFcXNxQnI0M1NCR3VrV1VnTXdFdXFvVExEM3BJTjZ1a2EvMXoxdlho?=
 =?utf-8?B?YlBBcEtwVVNGMEU2SU9qWGNHQkhmc1EzNTdrK1JoME0rQVRiMnlXTkNvM2FW?=
 =?utf-8?B?VkZhVWxtMzRETVN0U2dScE51TkZBZHIyQW8waWxBek4vTGtidTNyWG9hbXNB?=
 =?utf-8?B?dHhxTGZ4bTZxMjM3cXhJejRFSSsrQnVSZ2ZNSG5xYXNLR0h5RnV3Tk9tSUhN?=
 =?utf-8?B?WjN2RWdDR2VLdlYzNCtGUmlmSDYrdW1Ndk5VWXM4QzdhY3dnZktId0JoV3Zq?=
 =?utf-8?B?MWlNMVV5dDVjOG1DdXJLZVlIaCtUcUc1ZzRmV0pXZUNCWjA4aWZYdDh6VkY0?=
 =?utf-8?B?MXZta1Y5bTZ1VGhZWnVSOVBWZjlLZ0F4NktUZnY2NDNUM1hUa3hGT2lvcVpt?=
 =?utf-8?B?NGM3Vy9Dc1pIdHlzUnl5SmhDR2R4WmF5TUI3ekQ2TkFtTkpIc3BCVHBWUjMz?=
 =?utf-8?B?MWkrbHdubENqRWZsYm80NjNFWE5henk3TklvUVVzVVF5Vk8zdDduVFE1TkVI?=
 =?utf-8?B?L3A0OVVaeDNxS3RLNkNIamdxS3lLOTZGbEdyZVFBa0V6czdNZXNWY0lzQUpK?=
 =?utf-8?B?dzJyQmlHa1dBV240ZmcxZk41RnlvaTl0N3dMOUd4ODlrSW5kVVQ5TDMxckZS?=
 =?utf-8?B?aFJER1NyTGt6YUI4RWFyclBySkJVc3VJVnNPL2thZXpkZ1NsN2c4bGVkUlkz?=
 =?utf-8?B?Mm9xWXVnSmxScXlLVTU0cUhRK2EvaWZibjNlNU9hM2phbjNQTTRmMkdBaVI1?=
 =?utf-8?B?UTZJR2c3ZWxZRytRcnF6QkZRdmxXenlteTFoRHZVenprdnd5YUIyRmJGazNN?=
 =?utf-8?B?QXpLd2srQVd3VGNla1hucXc3L0h6OUx4MGJXQ2xzcldZQ1FMNTA1Q0kyNW4y?=
 =?utf-8?B?dEVzenczZFlQekREOXUrZWRaUU9haXJQdmgwbTBnZk9QaElPSGZEQjIrRlZi?=
 =?utf-8?B?c2g4YncveUxXV1Y0aDdhQ1FVemgvYk9kMk1sSS9YRkU1WGJvcll4WGI5Ull1?=
 =?utf-8?B?N0ZZVlcrV09SMTRTV2cybU50QVpIckRPTFRHWU5QUXdvS1d3aHgyN3Mvcncy?=
 =?utf-8?B?MTh3M09BMUIxL0haYWpqY0lDdUpsOVg3WFRFRXZXZ0ZuUmZUQzZ5WDluMFRB?=
 =?utf-8?B?bEhvTnB3RXFSTGMwdHVJNmNNOUZVcFlUZlVueXA0ZHNBckZGYmV2U1FhRUxx?=
 =?utf-8?B?OUpQQUphS0NMZlF4S1ZKNGFKZHhVL3ZTUjZPaHo4VEJkS0RGaC9KbW1uQlJT?=
 =?utf-8?B?OExlUnNrNlhHUWtGSW94TmxYNXdVVTJYNXlSb1lkaDdlcFlKeUhIT2tGVVYy?=
 =?utf-8?B?ODJxUXZiQm9LTzFkUUtqM2xqemdRcnczdkFQRURzUE5SRExxQ0JNVFZ3MVg5?=
 =?utf-8?B?azh1NkNJY0RWOGw0bWRKNm5tY0JCelFVdWZMOHNZUFZXUkFLbFZweUdpeWZr?=
 =?utf-8?B?VWl4aDBzZ3ByZ0tXK0dlbHFvQ08yS1Y2dWdoSmJObGpXRWNrZEk1ZHZZR0pC?=
 =?utf-8?B?ZForeVdWN21hMGlVVkRBUC9Jam5BUlVIUTQrTWNGVjJBdDA3VlMxMkdBWkEz?=
 =?utf-8?B?ZTdEWmNrQWU1Q1hoa0V4K2Z6SnJZeHVjb21oWHF5aTluMmxOZ1pncmxGR0s3?=
 =?utf-8?B?enpqV2JmV2VCRTRjZXVNYWI5NnV3TnFVQllUM1B3bzBTbzdsa09pNWdvNjFS?=
 =?utf-8?B?c2VDOUliUGN3QytWU2ZXRWZNQmg3N3NWSHBtZnp5TUxuU3RiSXFYVy8waElq?=
 =?utf-8?B?SXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f57d714-d36b-4f80-9a70-08ddcbd6bb62
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2025 23:55:28.4675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NZktBQ60ZJCYBCAYX+Ty9kC90SavidPjUXePe/5l/neLeMX4tFxBU/FlMqvxNeHwhlJbB6b2ESAV1Cqn5h8XqmAbTBWYuoM/tyM4DgCzR9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8826
X-OriginatorOrg: intel.com

Hi Tony,

On 7/11/25 4:53 PM, Tony Luck wrote:
> Architectures are constrained to just the file interfaces provided by
> the file system for each resource. This does not allow for architecture
> specific debug interfaces.

(squashed context and problem description)

> 
> Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in the
> debugfs file system for a resource. Naming follows the layout of the
> main resctrl hierarchy:
> 
> 	/sys/kernel/debug/resctrl/info/{resource}_MON/{arch}
> 
> The {arch} last level directory name matches the output of
> the user level "uname -m" command.
> 
> Architecture code may use this directory for debug information,
> or for minor tuning of features. It must not be used for basic
> feature enabling as debugfs may not be configured/mounted on
> production systems.
> 
> Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h |  9 +++++++++
>  fs/resctrl/rdtgroup.c   | 29 +++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 74cd2979549b..ed5085eeee1b 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -571,6 +571,15 @@ void resctrl_arch_reset_all_ctrls(struct rdt_resource *r);
>  extern unsigned int resctrl_rmid_realloc_threshold;
>  extern unsigned int resctrl_rmid_realloc_limit;
>  
> +/**
> + * resctrl_debugfs_mon_info_arch_mkdir() - Create a debugfs info directory.
> + *					   Removed by resctrl_exit().
> + * @r:	Resource (must be mon_capable).
> + *
> + * Return: dentry pointer on success, or NULL on error.
> + */
> +struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r);
> +
>  int resctrl_init(void);
>  void resctrl_exit(void);
>  
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index 9e667d3a93ae..fdd6cf372d6c 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -24,6 +24,7 @@
>  #include <linux/sched/task.h>
>  #include <linux/slab.h>
>  #include <linux/user_namespace.h>
> +#include <linux/utsname.h>
>  
>  #include <uapi/linux/magic.h>
>  
> @@ -4350,6 +4351,33 @@ int resctrl_init(void)
>  	return ret;
>  }
>  
> +static struct dentry *debugfs_resctrl_info;

Please move this declaration to be with its partner, debugfs_resctrl.

> +
> +/*
> + * Create /sys/kernel/debug/resctrl/info/{r->name}_MON/{arch} directory
> + * by request for architecture to use for debugging or minor tuning.
> + * Basic functionality of features must not be controlled by files
> + * added to this directory as debugs may not be configured/mounted

debugs -> debugfs

> + * on production systems.
> + */
> +struct dentry *resctrl_debugfs_mon_info_arch_mkdir(struct rdt_resource *r)
> +{
> +	struct dentry *moninfodir;
> +	char name[32];
> +
> +	if (!r->mon_capable)
> +		return NULL;
> +
> +	if (!debugfs_resctrl_info)
> +		debugfs_resctrl_info = debugfs_create_dir("info", debugfs_resctrl);
> +
> +	sprintf(name, "%s_MON", r->name);
> +
> +	moninfodir = debugfs_create_dir(name, debugfs_resctrl_info);
> +
> +	return debugfs_create_dir(utsname()->machine, moninfodir);
> +}
> +
>  static bool resctrl_online_domains_exist(void)
>  {
>  	struct rdt_resource *r;
> @@ -4401,6 +4429,7 @@ void resctrl_exit(void)
>  
>  	debugfs_remove_recursive(debugfs_resctrl);
>  	debugfs_resctrl = NULL;
> +	debugfs_resctrl_info = NULL;
>  	unregister_filesystem(&rdt_fs_type);
>  
>  	/*

Reinette
