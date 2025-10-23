Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9EF30B519
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241836; cv=fail; b=HoSco/Ww+1mvaR5dCHE5E+assZKtqs1XD/sBPj6e4moWoBu6i+nk44Tv2z5TKzlwXLCgfINK/RBPILzm0cNcOBQH/gI08l55RHmT/jnkhbc1WDNLgP6IuSBB/3MV+2643AopMENaBgW87ZwQ+JVv8/e5nkBPt0GPspGzK1PMb+c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241836; c=relaxed/simple;
	bh=Ehd2ZHoeFAdhJ17RvbRNWJJ/CceC9B/VQeZsitfv7MU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j3aumzvo+qVUdyvWuEE7RodgMOORzCRgN5hd4oLhiZX2r28BoY4UFCOXrFH8ZGsmf71HXCJnNOgYvBzrfgkDP3X+IIc/aDfYzyn4hT8p//LVjnm6ValMWLWL3GTaWpyeJ1bsmGtnxfpr67/m/EjFG8UEO6QSYJ8pT217zwdBqeM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KMst2SHC; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KMst2SHC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241835; x=1792777835;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ehd2ZHoeFAdhJ17RvbRNWJJ/CceC9B/VQeZsitfv7MU=;
  b=KMst2SHCHA8aI4typZICyjqYP2AOVhfaw3TIDGtnKbhvMwvxExJ4oHYf
   Ay3AN9mCKGUlSdku4r99D4Yyd5snoEF+eThU7zDWQiRWwVhE2ltRK6MwZ
   ejYEMm15BrSrIcYx7v3P5ZIu5bwUsN5geleKHrJXef1FCWhV6dbZlet2I
   2Ae8S6Slsu+qGbqcx+2mT4SORp5PRkPG50uMD2h/ILhkZ0lO2Ws+SHIHD
   1Y3WOBZvwo9A7stw7f/83niqVbXRGH9OpVPEiaMBRV69FhFNWGr6CF9bG
   1hlIlT/2mqqc+d83aVINMRdXXswgcRt2aW1zfp7gDEM5sDVDuObqFfDMu
   w==;
X-CSE-ConnectionGUID: KMjGT35PSdurr2wZVI3bLg==
X-CSE-MsgGUID: /r1MG07GTgurpditgjTiSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63460422"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="63460422"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:35 -0700
X-CSE-ConnectionGUID: GySkQtOpTvG0VRdf5PHNKg==
X-CSE-MsgGUID: 9o4bTG8xQm2e1DfXBtCq0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="188513576"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:35 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:50:34 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:50:34 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.39) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:50:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHUr3RiGG8zxCZevmjZR4vP0wuLnHJPsC9+6Dy50JCfo76HudlHXb+onessDTrA1NupuT7324WM8wuvkvD93gNwyuj+rwSWiE5Nw6ucmSLu56cMULqu0hKypnmlkwTi+7vVnfRSiaA4Ysl+GGGVycAkxFpLWDQwl3li7DPBpRX2hlBibyc5+4PkKml0solU4yGCECw530+w5pcZQlOAcqWzPKHUaDaHZW0KxQmX2d+al6Pxl2ElmRuh81e8fVTMQWJUZN2qrXIiQZn0sXW8GP2/h86q1b4SUrUvFXCdvXS3W4CyiW/8MnaIl7D6PhwBI8JxEh3PMoYFGJyTjP8K2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TU1QXS/hsDRrENAfl2qFuJitdZdctxn7giFguSV/EOA=;
 b=lCNsKqE3xF7+aC0f5IvntW+QifZY9xC+AXRUpeXJYY2jRbPoBQIS9J6lC6n60EGbUIvwAXT//aTW7dVCS1P95RxU3CSqSZZMTI9YmVDLHTqa+lzWKlntS9zB9douc15JEzIeyEgMNPfh4P6/6g53dwDxR4VWE4t23Wyw+njqI1E1l1P6GN0zEeqyVYXXmwnCQGqGchx/p1gFfABwLDZNADK9bsCrqHtc8Wz7EsLaNtjjq/8SS1fSM5w+0RT/HbG0rkuG1UxdAbe4lTTynUHJYCfXwov91/gGfUVLKlq2Tb319uvBQ6RYNbaXC8rGcY8Wu+2ujtl+Ls/5t82PWR7PAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8469.namprd11.prod.outlook.com (2603:10b6:a03:57b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:50:28 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:50:28 +0000
Message-ID: <13d1f51e-69aa-4e7f-8e8c-e83f086ac867@intel.com>
Date: Thu, 23 Oct 2025 10:50:26 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 29/31] fs/resctrl: Provide interface to create
 architecture specific debugfs area
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-30-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0250.namprd03.prod.outlook.com
 (2603:10b6:303:b4::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: 1de11847-9d56-4782-67f0-08de125ca746
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?a2h1Y2tYZHR1OVFQd0t6aE1VaHM3Z2dnN0RiMUozLzRjWEswRkVkaHZpQTR1?=
 =?utf-8?B?MzYvN0sxQlYzd05BYnhaeGs3bDR4TUdabUJtQ2ozOVlVTVRjTDEvMld3YmVJ?=
 =?utf-8?B?emNucGlwWjlLeDhpSi90cGNBeDZNcjNxRmM5Zi9jV21QOTU4WVNpbjFnYnJx?=
 =?utf-8?B?ZjBFY0prUUxKcVQxSFJnL1VpUjltVFB3WWR0MkFlQ0FsbzFKNGViTE56Ui9O?=
 =?utf-8?B?aGhxblhQc3dVVW0rSXhKSFhCWkJVQXF1MWxPa0E1OCt0bGdvczFXUHJnS090?=
 =?utf-8?B?R3NWT3RvYWt4Q2RQRDZqS1RLdUErOXFHSEtGTms0R0thMVdVVWFmUktwMTdx?=
 =?utf-8?B?TERrWUl0RGl3VUR3dDEyMVZScnkreTRYWUMwRk5vSTZ2UXdBTGRxZG90dGxC?=
 =?utf-8?B?ZlRsNU5iK2ZOUW5na0FVYmxUODJoT05jeStPUHFBaElkMkFyc3RlMjdNRHpz?=
 =?utf-8?B?MmJLd29DQ3FGL0NFN3FsbjlwWEdVZWt5Wks2dTFLdi8vUEhFS1h3aVNYM2Ur?=
 =?utf-8?B?NTFpY081b28wQnJQQ29tZERocVlEOW5ldUlEOWJEREVoNTNGZDlzdTZXZEgw?=
 =?utf-8?B?d3oyREFGS3lBSnJpU3kwVnJnWkdPU0RnM1o3QkhySVNtd0lRVHZ5OWJrWm5F?=
 =?utf-8?B?ZEpEMjE1ekthSlJ0RFJubnowNE5qNHp0SndRaWlXWmF4cmdYUGxXNzZNWXpV?=
 =?utf-8?B?dktVdXhCOWVzUVBPcCtoRlZQOEhSWHFheno3SHRDQnV4TzdSMU5FK2tKVDJS?=
 =?utf-8?B?SjNRWXlaVy91NHJWRkJsUVNwQnFHdWc1Sys3ejhoUzNpUG9rdmZJcHkwTXdY?=
 =?utf-8?B?RXcrbXlSSi9DVXJhSjc1eUVkSkdwNmd4aS8zcGNkL1lFODcvUXhlNWk1Q3VT?=
 =?utf-8?B?dkpSN09JSHBxUGZaUHB1cTlkS3JjaTFrU0dIQno0WVV5eCsrbUxINXVBdlNn?=
 =?utf-8?B?aW5OYVk4bWhEWXNPOEtpcTRXWERpaXRZODBodnlMTVRqeUw4UEdZMDZ0b05j?=
 =?utf-8?B?YTVwcElreVh6RmZKSTB5ZHR0d3JHYXV1OHdSV3lqNGROVnBSK0JEY1I4eFNJ?=
 =?utf-8?B?YUcwamhGOGpPK1VwQldqQUpLN0JSOGFuOVUwaW9UWE5PMjlhS21HUWcwb3RY?=
 =?utf-8?B?cnlLcFdRNkNZSkxwREpPTlhnVDVnMktGSjA1L1ZwOWJMQnZIaXM5VUw3ZHFG?=
 =?utf-8?B?anpwRUN1T2dCSzVZRkpwbWQ1VHZFenB3NmZJVjlCL1p5TTNPMk1lY3pGWnlR?=
 =?utf-8?B?VzlQaTN6RUVQVnY2UjNwcjhxYm5sVmpwR0F3ekx2bnBnRzdKeUR1QlRic283?=
 =?utf-8?B?RzNBZDJjOTBLMFoyU0MrZE03NFJkRmF3em5LcjA5RmYxWUpBcmhseEFOaS81?=
 =?utf-8?B?UkpKWG9zZ1V2UXQrSmRnQllrZk5NOVJsd055QU1oc25CUkl2b2hucFhJdG1B?=
 =?utf-8?B?ZmZndWhyaEVhd0JzSFJQc1JZemNWaEVMdWZpQmlTc2pRb3I0UWUvb1g5aTVV?=
 =?utf-8?B?Q1JJN1d3U3VtWXBNTUVMbzFoSW5GU0MwWkhob0VUTzNObmdDVnN2cEh4enA2?=
 =?utf-8?B?MzRoamhaT2lKWkZtM0Q5UnA4bzlFRFdaMWFYUnhEdmNkUTE5Z3ZZdEtyeVd2?=
 =?utf-8?B?TTBSRUR1dEI3S3EzdWViWmNpZW45YkdMM1MxSkdRdkQ1VkRsV2V0UnhEdHNw?=
 =?utf-8?B?eFBpUDdRbTNjaXhWNmVvTzNzbU4vS25QVDlSOUJNRU5BeG9QajRCQkpETS9S?=
 =?utf-8?B?bTFrcEs2ZnRDSUxkdmpaQmVocFl5cnBLdGhJWDZ4bFJQYkhOaXNPUU5laEd3?=
 =?utf-8?B?cVVBNzRQMDl3Nk8yVEE3bzA2ellmRGdOcStoTFdNblR1d1YzZzZzb1ViRUtE?=
 =?utf-8?B?TmlUQXg5MkZLNVZJdlUvQVc4ZHNrNGFzSzJ3NnVvbzZEWnI4VFJIQTI2MGRp?=
 =?utf-8?Q?bd/6tshqhwndGnjpufMU4FE8dBCM7oi+?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmYvMDFwUWN0SlJuclUxS3RtckhVTmM0TXpyNm5xQlJDU0JGZGx4SFZWMlRN?=
 =?utf-8?B?Tkt1Tm1NSWlETGplU3gzcWh5amh5c3RhcXdGQmEybHd1QlFLVjFyVzBwVGJv?=
 =?utf-8?B?aUxxcFFwRGhRaDVmZklIbmoyOENQNy84S0FzY2tUdjJvVmlPUVhYS0ZEV2x3?=
 =?utf-8?B?NjQ3VXZNRmZNVVFTckVsbVQvOEpVSEd3TXF6OG9RMlA3NTFEWmJPRzJZbUxI?=
 =?utf-8?B?eklVWUZiVDVPQjBOM0hqVXJoT010VmRYZ2hoN004TVlCUFVjMXBGYmM2alhm?=
 =?utf-8?B?VzJISmJZbkNQTC84TGRHeHFkdXNkS2pzSDFKM09oUWVxTEY3ZXloVVJjSUpC?=
 =?utf-8?B?TDFmMEtLUVJSbDl6cXNzaEVNS1RjQVR5ZG1LUFFVUXdoRFhDSVIzdVhaMTEx?=
 =?utf-8?B?V00rN1N0c1l0Z2hUSk9NWDlpdlJqSnhydHYvRTRzWFJOTmhodExhQ2hmb09z?=
 =?utf-8?B?L0FjS09oMHBhNmlSMHMzMExYNmlXRnFpNGx4RndMT0xEMXpoRUh1SXB5eDIr?=
 =?utf-8?B?VTZzaWEzUDBlazk0Q2dNclhISnVsRU9kOTkrU2dMcFVHTC9tSmZkV0NJcWZV?=
 =?utf-8?B?aHlKdjBhd3ZYaDQraHlVRFpWZkxMRGtGa1p4K1NjSHN1QUhLNllRV0pHVVE3?=
 =?utf-8?B?T0xYNGZEdlZRUm5USTVoTzlibDlSN29QZlFkeC91UERrVXFzSDRqd2lrdUpL?=
 =?utf-8?B?d2Z5LzVtQ3ZYd3JrWlF0aStReHhEWjFLS1FyeE1JVmxzalo1aUR5QmV5OEk2?=
 =?utf-8?B?eGRGZW1aSmxlQ0JxMnVzWWx6aXZIMkZkdi90bFplWjJVRW85RENpNmUxTzNz?=
 =?utf-8?B?Q3lxK09PeW9wL1oyOURoNkRqd3dCTDJOUCtESGp6ZVZMbTMzcTZadzVzN1ZW?=
 =?utf-8?B?N2cralBUZ3VqSDU4cXdiMWFQQm96THczV2ludUR1WDR5RVB3QnhRYWRJM0ln?=
 =?utf-8?B?Vk1pNm00TFdGWUwvU3BmODgweE5vcGROSUVOMmpvN0MxRmpIRkNLWWs0VW5H?=
 =?utf-8?B?NU0xdTRTL2pyNkE0ODg5WFQ0YXluQ25DenU4UTFsVlgxZkpUaWZsZlFpQXZh?=
 =?utf-8?B?NjJITTM2d3UzUlZZTlVrMFdLT0trVmZoa0lQUEpEcmVvQi8ycGIzWVBKa015?=
 =?utf-8?B?RHRWT2h4M09MM1RrK0NOSDhkK09KQzdIQVNmaDVPWHhSMHBUVlZTUW5RTDJX?=
 =?utf-8?B?c3F2bjNzem0wWGRPS1lJNGovdEcrWEc0TTlzclZVOEFoa0hmR1FwK0dLb0RZ?=
 =?utf-8?B?anJ5UEJmYlJ4TGwxTWVwN2x1WGNicGR4a1VIbUNkeFByRU5TVFpnZ25LN3E5?=
 =?utf-8?B?dDdSNUdMendPMjJOdThzYmhiaWhncW5FSmlsbjk3c2tyMkpHd1d0L1E1a0R4?=
 =?utf-8?B?ZjVVRUxrSi9FSVlrZzZjeUFSK0hrY2lzWStIclRGVzlyNndJR0xhbVJtUGpo?=
 =?utf-8?B?QVhVaUV6aDVBc3o2K3g1eEVSVkFFNGVkclY0aUhEYzduQUo2cUJER0FJNElM?=
 =?utf-8?B?djlaZEdaSm9ERXAxQlhXOVRkVk1zRys2Z3dvWjVxemtqNHBhc21CZW5ML09K?=
 =?utf-8?B?Ync4ZzhvcUM2NjlvRHRFeGhFRDI5UEVKY2ozNGxsZVhrd2pEcmtoSFlQTUJy?=
 =?utf-8?B?a0wwOEZFbVVDUlBIZklJQmhRbmQrR1dYZGdlUTNEUi9WZTVyeUhMWlJ6YzlZ?=
 =?utf-8?B?Y09tRitZbm5pdTI3RFoyQk5WNWZiSWxHQms2UUFBR3BTQVk2RmloU1J4S3Jv?=
 =?utf-8?B?VVlzTDFkVVhUZVNnd1lEeEVqQjQxTFdsMGdsN1NpY243NEdiMkgxWkZIMkZr?=
 =?utf-8?B?dlFReGM1NzVYdjdqQU9ZRmEvbFE2MFVQdXlPZWJsWkRGR3ZxL2NuMkQ1cWlo?=
 =?utf-8?B?VUYzdHBCcEVQRk4yM3c5Mm4xUFo0Ylk4dW52d05Tb3VoemJ3N1RXdjNveEc3?=
 =?utf-8?B?SHd0alJ2cFV5SHMvZjhRUXcwNXJEdnRaaWtMcjRPb0Z2cHNsbk5KTVlaODE3?=
 =?utf-8?B?LzJaS0hDdi9aQXNDZ1hZdjdKem00WTJoZUFSVUVXQ1VXT1FYMUM2ZXpPWkNk?=
 =?utf-8?B?U08xVWhjRURYMlRMM1pDYVJWeWhMR1ZRZC96YXoyUlA5UjR1blhBUlJreHky?=
 =?utf-8?B?U0dZd2dxNkVud01DWG9IVWsrWGQycHhBN2EzUzRaUS8wd08vQWJIeDNPcGg0?=
 =?utf-8?B?NHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1de11847-9d56-4782-67f0-08de125ca746
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:50:28.7219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q3YHehGPQsijIMZSakKuguSU2fZ75zo8zMaIwP68env9fr2cmbJMqNaX7/i9WAG1WC2bFOKeJ2VpjjhO8b6p4S9BU+iEoyDZPNbTxqLUjig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8469
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:
> All files below /sys/fs/resctrl are considered user ABI.
> 
> This leaves no place for architectures to provide additional
> interfaces.
> 
> Add resctrl_debugfs_mon_info_arch_mkdir() which creates a directory in
> the debugfs file system for a monitoring resource. Naming follows the
> layout of the main resctrl hierarchy:
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

Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette
