Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFB23EFFA1
	for <patches@lists.linux.dev>; Fri, 29 May 2026 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780070051; cv=fail; b=dzwszSkV6AFceedj95qkxrVeWI19qE4L6GYOruuuEig0fWs+cmW61s/CqGri0CypoGWvcY1z2Z4JTPDWpNrBt3DmjwI6lZaXoDGkbHQHeTIwBNPONYqUglhiiuUC/zxioptOmA87DKnQNoWV8yQyQ2vwhMI2c3HJeTyeJ462OJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780070051; c=relaxed/simple;
	bh=Mk002McqHnatYW9ZtxbUY9mwzz1mDLGWcXft+iSzH+c=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mSmbO21Q+wnCGlAlR3QuJnP3SMXehNFoJ4WkUJaPUsiuO2Rumgd8ex1mmfnPVYYMz0SdFou+V9DwNbSts7aTTkI7rigoqHdRpLyrygV64I9SUHAKkiKDegrh+XJLJWOcY0dmv5H83V4DUvJo9SM6KrfJkCG+7v7iWMdJ/0I6BPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=du6bYOey; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="du6bYOey"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780070049; x=1811606049;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mk002McqHnatYW9ZtxbUY9mwzz1mDLGWcXft+iSzH+c=;
  b=du6bYOeyrBA5SkPRPX04nEoOAyA0ZYLeoLfTY9zosKXYGiypvkOEKhEv
   7kGNN6kwVJh2RwkdEu6xqwgBPdQKD5aVOKYyd3opWvX+Eds3ckbxw3lXz
   rQKzfiox/bBLTN9tdz1BoR+FEPviW98VTUS4wvDS03ucvrw8s+Pi66aA4
   Ugq2MfIqStmNYV/n/IdGcWSi0jTtEnBPN3sgzeIZCCvbHL6/QJLb8RKDY
   MlUcLdVSKRBpieCpzgqdUxo8KhqS+mVpBb4jFsmZHvi+CJtdbTbtgH1B7
   dPlbwYW9x6VsL57hntUhfIUihNr8/G4ezcIoxhx19H865s+pQd79NJ4X7
   w==;
X-CSE-ConnectionGUID: EG/RqBfgT9uCWep8/hOfPQ==
X-CSE-MsgGUID: 8TY75Nd6QJul01fxY82aVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="91608379"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="91608379"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 08:54:08 -0700
X-CSE-ConnectionGUID: xo7RW5xFTUqLZU80MIrJXQ==
X-CSE-MsgGUID: NUPXaeMPSCGefqeujQDZ8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="281005165"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 08:54:07 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 08:54:06 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 29 May 2026 08:54:06 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.11) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 08:54:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R7uCgvth4jzc/XyetN2nZc7ip26MbYut5nsUn7UpuMj3Vdpod5qGBCu53HjpUdQH0k0yJnfrQXR5nODCRO6+PkGrjORttKUkVzxhxRpefA4NFDyavy6SE4SaBJtiEpXzOrslb0hpCRZ0utdXddeQtz74DHULYexuCgmuoPYdx1cKQfU2Q2fOXvyQmxxHm7q8dmcomi2AlXn2KBzBaA25CG4jmfaYfwxbMTqq0jUL2neTBj8TzB1EoJng1wmq3j9tUQvmfZlw88nHDDiO8Oj5fbRzt8Tmw5Up6KdjtElF1X68CC0pBHiFK71ySH0BeCDspVl96EKpgddUKQgYi3L6gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yswZH5wJV4r++JI/BpwwT+zHV84ZyKqrhkoX9tRIbBQ=;
 b=R32VNRGHBDCVwUd2MBQ3o0c5OUXF2S8mj2z9kEHw4Plq9AoUvH/kcQ2sSlnHUYlPho5D5gK4hYBx2OIwhSNMOTsRXFPkJZj1MubMrgT4qsKgWIOi/jySJ2w7yzEDag8rgn3Nfd6IODJ5E3aiN7ihVjEwrPTmBwN9CIqYGOjWOwM2vDwWKD3swkmZSnLJ1y0lm4ESeIUiDTMbHjDcKCI+pHN1pu6gPFuxeSKQkJ2WrNEzcI2lBNpVha0ORXe4EujuABnUrkyLVFhjkKWrySBXYTW4VHfATj1Hy7VtHEqihhQNDpNH0zlNS62evSNJqxjdGCS5l/mN4eqEy/0eIADnhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS0PR11MB6494.namprd11.prod.outlook.com (2603:10b6:8:c2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.15; Fri, 29 May
 2026 15:54:02 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 15:54:02 +0000
Message-ID: <a9b51eee-fb53-4a41-a4f3-2c50b49d93d3@intel.com>
Date: Fri, 29 May 2026 08:53:59 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] fs/resctrl: Fix deadlock for errors during mount
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<tony.luck@intel.com>, <fustini@kernel.org>, <fenghuay@nvidia.com>,
	<peternewman@google.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <2e44b91263f1ccc4403a969524594800bead95c4.1779476724.git.reinette.chatre@intel.com>
 <6140c3f9-b172-4552-b96f-1b8514b0e75b@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <6140c3f9-b172-4552-b96f-1b8514b0e75b@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:303:83::27) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS0PR11MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 137b8062-d553-42c0-10d9-08debd9a810a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|4143699003|11063799006|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info: C0t3+cA/Oq9r/A0NsDVPXsgTB2hG0+iaqWQFT5kp2uTMP3JuF8J/KJtPODYeMHd6P2+LgsAK76uq40mmBoKhPOxOhE8ywjeNFvdMyp9mHrRvsJkvmCYJhgBGSofZlNjXvcMwHo2j8NcWN/lK9btrDLixFCvkeZoSUmOTgZ587dDfoXqSakrzYTJnDgBxyyls8DLD9a+umd8WxDQwWQPqSRXJkuIX/hV6oincro0fjxAyNRgWoHi7pzMcrRzABms7aEjS7tf+r21xaatQKEKYbtq/6D5Q8qM28ewJmiIWoT8VeCRa96dlzjrLmVdvaI6SqgGRROe+6kzGpDT8itcahh9nWnHgvncEuM0O07dleC6gughhJqBg5YYkGPGodvoggDdpQGzkZs79cGG+GxL1KSSUCaODee+Ml/DgmDOt+PCfsMzzyI07Y2bxvHiSEimSC7E9ksz0XhbCqsspiMJdIY200ZbY14Dh0SIFXYF7HXSCUc5fu0UdmagT8ApQ2KGjHzV0Uf+V0YOl0n4yyAr0RAuHr8IlpB7JWIlu1he2WNEfTIaNKY4Q0Cvf/W7E5TJwS9nLBm9DgZZ27/dlknRnz7P6cU12lRJcBpajt68sKIlrPJJfm8DCRxi9jdpZpNaXsgd7kkRhmtNLHIp8QalyNFl6Gbz26wrVtp2/TqaFg+FTlwefJw/S5I0qi4pZWXrn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(4143699003)(11063799006)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cGt3cmFLVmdORW8wbkdMenQ4bHA1RlM1cHYvbXRxZjVvc20vdUJIdjJVanp6?=
 =?utf-8?B?L0E1WnBhcFdVeXlUT2xIbVVvMXgyK2pVZFROY2QrYUpKR2M5S2oxQjRTRGFE?=
 =?utf-8?B?dzJUYWwydUZjOGRuMmNVU01ZM0ZZWU9ZaG9sa2xXK1d0UFJSb2VnYmNSYkZH?=
 =?utf-8?B?TnlEUENXRXpId1k2M2M2NmxxdHlKTEJWWGZ0YmJ2YXRkL2hiVXlYemJFcTNY?=
 =?utf-8?B?WnVJM0RYTlZnV2FsbDdHbDNMdmpSdG1SUmhiRFdtUStia2dyQkEveEhkRGtk?=
 =?utf-8?B?UVpRUzhhNmp4V05yb3Mva0xPL1p5K1dMZGtFb29mdzF4S1NzczZaSnMxZXho?=
 =?utf-8?B?OGdUdEJWUDcxbUJrbHFoRks0MXFUcFpCT0g1a3g1bVppSlRDN2pOVWU3ZTU1?=
 =?utf-8?B?WlcyOHF5c1pnLzFuQyttMWRtT1pYSDNQeHFvSXh3RUNya2ZGVjFUVDJTMC9i?=
 =?utf-8?B?cWhrRGVOMk9KL1FUMWhiN1h2YnZCRmtOV3RRVmdIMkQyKzdNd1orZVMxdWVq?=
 =?utf-8?B?aTkzSTVXelNhVU10UXh0WE9ndkNEdzQ1R3AzMExGbEFmRERGUlVKMUVpUWJF?=
 =?utf-8?B?N0h1czNaMGZJNVBkbW54YVlaa3JtdnpXeFZvR1hOcEZxZUVVT3FaMjNVUlQ5?=
 =?utf-8?B?WHh4OGFzMTRVN3M1cWRiYU5mM3JvcGxCZjl2MXlLazAwTUFrMHlkeFpWUXpl?=
 =?utf-8?B?RmFNWCt3R3kwWEVDTDlEYUFhNWpVVklodVplWWZTV3JwZU4zZURGQVBRMjFr?=
 =?utf-8?B?S2xUbTFOOHl2RHJhTFk0bG1GaEh5M05vUEI5ajlycXFkZllXUHBnRW90dWJZ?=
 =?utf-8?B?QTMxZHphRm0wV3ZiYkRwSk4vaWMxRnFiZ0FJZmFzZG1iWXh4c01odjFLY3Vh?=
 =?utf-8?B?aU15MmxnOEZ4NUJIVkQ1ZDFHeE4zQnlUd1hNa1RIamo0cDFTNlVzRzYvMnNu?=
 =?utf-8?B?ZGNLbmZNcXNnTzAzaHVlQlp5b2ZVdGRFVi9xbk5YK2dYRTFPMUJLV0UvQjBw?=
 =?utf-8?B?ck15eVZMaWEwYU5xaHhtaXRPTzNEanVMS1pWbGZtOS9pVU5VRmExSjZRM2U5?=
 =?utf-8?B?ZU5zOG1jVlBneEhLVUZiNTJVNFUvL09iYjhraVI1eGFWd1FBcXl2TkFjTWEy?=
 =?utf-8?B?Z0JJRFJPWlkyRGNkcUUzeUMyajlQRmxPRlVvbE5rZ2VXMkVxMHI1bGZ5aUNN?=
 =?utf-8?B?V1pXZitFdEl1SU00MWVVUld5dll3QWpEOWhpaThxMjNEVzhMMkJMT2tra0w1?=
 =?utf-8?B?elFEdnQySkZSRWJCYzJZeS8vTTNLZXA5dThYaXVyVE1JNSt6dDdlUDVRQnRI?=
 =?utf-8?B?eExGaUZKdWl6VkRyZU9iWlhVZWN6VlhsNjlaU2RVaGpVUGtQQ3VLUTBXVldo?=
 =?utf-8?B?WmFseFM5eml6QXl3RGw5elJxSVd5RStlMWZtbWd6L3NGYUhORU9xemlMUklW?=
 =?utf-8?B?a0dEVzBRcnpzMWx0dmNVeEdpNVhGTkJZNmpwVEkva2JaSlJZeTdMQU52dllp?=
 =?utf-8?B?Z2FINUNUbkVOZWRjVFRDNysxTnpjZVBJZGJRZUFpbXhhZG5XUEoySUtTTDdY?=
 =?utf-8?B?NUxNOUM2dGtvbnZ2N3FyT2tTUkZ3U2xwNCtXcThxc2FBRmx6dFBGZnN0MFh2?=
 =?utf-8?B?M1FJM0F6dzFhaGJqYTF1ckRZaFVVUDZPV29mT1lrRUlZVEQ4eXZTUDdzN3BK?=
 =?utf-8?B?cm56ZTJvZEdOUGdxQy9XS1BLUEdFYjlpRmUwNzR1eGVQazZ0SDlFclFSSjE4?=
 =?utf-8?B?VXZKNnM5dUpjQmg0WDNWN2hFMndaZlkwWWx5d2pVUTAxYjlNNUhmVGwzMktE?=
 =?utf-8?B?a0xrbEd0RjFWWFl0Yyt1WjI1cXplekMyRCtBeHpIVDJHZnIxaGFaelU3VTVD?=
 =?utf-8?B?aW94cDVxaVhnUzB4QVhtSVh6TDYvQllNRFJ0MmdoOGlRZU5qQ1RYSGNjalF1?=
 =?utf-8?B?Q3FuS2R5RjZnMXowc2JqRkhTbkJMMzFBZ0pLcFZqcDZWL3ZRRUZvWnQ4SmV1?=
 =?utf-8?B?aWJTcUYxSFNiRVFNLzdySXl1aGdvYXpROElBOW1WdzdyUEFrWFNBNk95Y1dQ?=
 =?utf-8?B?ZjVLUElpVFNqL3lBN3JDNVdTTkxPQUNyVWQrMmlsdGw4ZkJXK1h2WEJqeUR0?=
 =?utf-8?B?R1BwNkU5WHJURExIeklOYVczeEdaWGZ0amFzbkpMRkpNVit5ZXdCbVVnVGx1?=
 =?utf-8?B?MTlmSll6ai85UDRabDNBQ0FDWlZ2LzZiQlg4eVI0bGI0RWRtTFhlUS9ZWkN1?=
 =?utf-8?B?R0hlZ09hZUo1dHVzWVBCOVlpNmRiaDcza3IyeTlCcm9lS3l0OE8zdkhBMjNk?=
 =?utf-8?B?UkxqVEE0dnRxbDFUN1dwWWxqVVFXRGdrNG42S3ZRTWx0Z0o3OE83MkszYUIr?=
 =?utf-8?Q?Juiv0HAMukCVWP30=3D?=
X-Exchange-RoutingPolicyChecked: CCI9/HolKi5u077XKkfXfOai8ZluBI4RHDNBOkNxxe543atRlJBRXglvkhaJ6XBID1SfsQBW8SHj2TLdtwRgvZWXw0DwkMZbsSr7plRTGqosfvo2XJeLvOz05XxDxOKmc0GnkbpckBLjs8mLX56bBjQDNqFpko5feAfTWrL4xvC0UUWw5TzvomziTjKUIuVd/XsS7cAszn+jqhvOAjQwWKR+z9NpUqJKAyIPGKVFSOGgOctvTy3rNAxe9T5N0Ne0j65mPSUyk7y3q/Wfif9uNMBLxQRNICT+htLAfss6ww9mCJ57qP236Rb2OrS+fXANGkfKodI5o3UQb6ILR9s38Q==
X-MS-Exchange-CrossTenant-Network-Message-Id: 137b8062-d553-42c0-10d9-08debd9a810a
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2026 15:54:02.2535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dcJxnU4mfdyPqoDcTdiL6OYdHj/yj1HM2PsJQKdwtvA4FgPstESaLR71GykGm3s/RGIYmz0AcOdzg7EgZFbfz8DMXh4jPHHKztXwbYIkG+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6494
X-OriginatorOrg: intel.com

Hi Chenyu,

On 5/29/26 7:06 AM, Chen, Yu C wrote:
> On 5/23/2026 3:15 AM, Reinette Chatre wrote:
>> @@ -3085,10 +3105,37 @@ static int rdt_get_tree(struct fs_context *fc)
>>                              RESCTRL_PICK_ANY_CPU);
>>       }
>>   -    goto out;
>> +    /*
>> +     * Ensure root kn remains accessible after mutex is unlocked so that
> 
> Maybe a little more accurate to say "Ensure rdt_root remains accessible"?
> Here we increase reference for rdtgroup_default.kn, and protect
> against UAF of
> kernfs_kill_sb(sb) ->
>   info = kernfs_info(sb) ->
>     kernfs_put(info->root->kn)
> 
> where the info->root is UAF rather than the kn.

Right. The UAF is indeed on the root self while its lifetime is controlled by references
to its kn (root->kn). Dropping the last reference on root->kn causes root to be freed.

rdt_root is the name of a variable though and its value can actually change in the flow
involved here so I'd prefer not to phrase it exactly like that. How about just
"Ensure root remains accessible ..."?

> 
> Other looks good to me.
> 
> Reviewed-by: Chen Yu <yu.c.chen@intel.com>

Thank you very much.

Reinette
