Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E6E279DCC
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208464; cv=fail; b=HX+mXAHMe5R8s3bI+zIX02fOuBPHH4mw605RdVBQHzRDswBpOGDns6BbVgydMjVXSj7WABDK79qu+KIw5ilp0530iCVBjI/BhsFVeFuRehcmUz3W22X6pCLYeTT8iV8eLMAA8z0zrazKjQRKRtGi22CVxYpl+CFvRHGGohkVE+Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208464; c=relaxed/simple;
	bh=MY+BvN2LLssUZ2vGGepNAJjax/IJu9b3Ll6imFT/Yi0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Erz2dO/cir+Nik86yu/eVVrKIcjTuXibya8Jx8g48v/Gr/Jo+YOKkiSo3ID/Xq9+4IdRkZ5PeGGGgdyfOwb3VmB+yQ5dN66V9B5f/064SKYW2+hmmDxlUsoXGbdoG6ibcGnarD1qWjwrOQok6/ZqN9CgYNjsh9kgwiLGtZXrrFk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HrI7sgIs; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HrI7sgIs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208461; x=1786744461;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MY+BvN2LLssUZ2vGGepNAJjax/IJu9b3Ll6imFT/Yi0=;
  b=HrI7sgIs9fy58qTzABNUDV8aK9AfnkJ+XcGgUTHmQ3maS5+GXk89jZmt
   004nRSgaRUR8ujyYLRSjguHlAyxjLCGTwuNHsC2GHM4cf1p4GqxO+VqtX
   /wTC40fAJtkpleexJ1luq16PzyQSHgkwXt6LdElH64u9D6S4ghmfSRhvu
   /UK0vh8R4GM0XT3UwNptZVQWKNhSM57Y3yEtdGcwLtIiduXAHUwjYUcyf
   aBsCC8L+tDUmKfNQLZKxCT672IGK8xkZIK0vTXYeSVkNLFWZk3bA+IP7D
   qulvR4+V2DhvXMe9AxRHKwJHbwD0lMc8Wcp9n35cswSDjDKrBBPcbFTGg
   g==;
X-CSE-ConnectionGUID: TDPuO+L7T8KW/v9qUviCew==
X-CSE-MsgGUID: gjFp7LmJRTK/EsZU8Z1xig==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="57686123"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57686123"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:54:21 -0700
X-CSE-ConnectionGUID: rxaAybEcS2Si2vF9oO4SbA==
X-CSE-MsgGUID: 0T9i/wQTT/y6wvi3rF4pnQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="172197615"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:54:21 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:54:20 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:54:20 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.75)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:54:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fRResxHYi6DJ0If0BlB6JoqUu56fDX9j5HL66ey2sCLlr48s2vVX7VP95TfgVvyiFYBOOZNwPFB8yvLt0kRY9GLxtiVzUYbi3uZTbRwwSpCTCwlfWOI2jfGzdQTrl3CZtOeA6ZJ3HsVg7kBh4iPQ9fGk2pV7E2y1xqu9+oy7ez8twu/cJxMoZ89JlOdsazPqSlD+6nn/25ePDgrYwLA4yQ9cW97RJHvW4O+ecDQLmQCJngZwG/Adc6ZrZy+b5gWKt5s4q1nFhdFLzhNtk9psY2qcpJ9T07Gn/HbrfwvmkLGXIAnC2js669rkd2hv3I/l8gJeCiV4SAHCRBaSG45+MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFutATwFi16dW7Nlcn5N+IJyKxWnwNN7frP8wYUteO4=;
 b=BXuwRh8+1Ilten7DDZZFdOC+9jYDVYZ3Eho83NabfsgyUf9Naj1n4r6K15gFxwFysp4HaewypnkHwY1eru6oYlvf+nUFuV3ZdvyXN3wAsvw5ClDSins4mZB6VJ7BQnYDTRXjSVkYzoI9U3hclNqzX43yRncfjREkoXM1ITOASubKgXRCzo6igtW/QvyAxEfiCjEe6G6OSGCUATDNC3iM/y2jcBa+L7ypsQ2cI9pdrTti6EYgzF1Sgc+42R3mRtsgXq7O0XwEoShZNZXrYUtMXSj0GR1A4lt3bs7CdXuf1+XLEvDFWVQJsSpUZfSB6xCi9OvgpuzlXVO3nQGT7ScyEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF5A636EDE4.namprd11.prod.outlook.com (2603:10b6:518:1::d21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Thu, 14 Aug
 2025 21:54:17 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:54:17 +0000
Message-ID: <da1c4e17-aba0-4769-9f64-e3caca7e0be7@intel.com>
Date: Thu, 14 Aug 2025 14:54:15 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 25/32] x86/resctrl: Handle number of RMIDs supported by
 telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-26-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0006.namprd02.prod.outlook.com
 (2603:10b6:303:16d::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF5A636EDE4:EE_
X-MS-Office365-Filtering-Correlation-Id: 71028975-eb2c-4506-c45f-08dddb7d1ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QjZLRkxmVlNpcEZoNGQvUkxrbTYzaE91K0ZiTGc4R09CZnl1Znh6V2drSzlX?=
 =?utf-8?B?bGp5TytoVW5heDJBdnkrNTJqd2RxbVVlb1NmYldJNlMxYWxRY1BJRkphSWhM?=
 =?utf-8?B?di9oU0g0Z0RPNWpYVytreHZUdDdKSHpkUVZ3eVdUZ3VWZ0ZaOTJTMU0wbTFz?=
 =?utf-8?B?ZEJJWithbFV3alI1MlpRbGZGclJuRy9ZVkoyaWs5dkQ0bTFwQkt3U2VSdml4?=
 =?utf-8?B?OU9NSHlKVDR5bWxFZTdjRlRKWVJTcUxNQ0VVVEgrb3dIdE01QjloS3VXQU5h?=
 =?utf-8?B?dWRWZ25VeTdZa0k1N1MyM3U3L0psKzhtWVMzWXJrckgwcmliaUFBVlh5UTBF?=
 =?utf-8?B?Y3pubVd0OTVaTDlPZ1ZpbGN3eXk1aDBoYnVsNldwUjcwTTNIZkdGZjJVb0pu?=
 =?utf-8?B?bWFxTy9IWHpTOTk1UXR1Z2hBMVh0WFRvK3BiZy9wS3ArZ25HOXcwS2EvU3Y1?=
 =?utf-8?B?WjB2L1NBL29iUnV4L0NxUEwvUktwWnkrNXdQMmJVc3V1Y2pJQ2J1dmdxZHRU?=
 =?utf-8?B?WC85MVE3WlZDcWo5MXcvbWgyVVBwSWc5bVZEQmdHNE42cUdsSEs2L014UnRo?=
 =?utf-8?B?bEtKVnB2dzJVNTJzVEhiVXlZQjFzeHdBTUhoZ1hIUlN4cU5Ydm9uSHlPWlVT?=
 =?utf-8?B?Z0Y2bVUwVXRWT3orUzVHSHNFWVlOU0hQUWpscHQwWktEdWJ5V0J5SGZvUmNL?=
 =?utf-8?B?MGdEeVpLbWFvSDN4U1FwdWtYWEtxSHBvOE5zWXltK0ZxZ0xZTTJJaEVhc3la?=
 =?utf-8?B?bE9UZmFLN0piMU1hZjFRMHp1ZUxwR3A5elBTZXA0cVF3blpLL1dRZ0p3RkJQ?=
 =?utf-8?B?Ym5EblFRdm82Mk1MSWJwTW5ObkxENEN0eGE2Mm5samxDUkJ4b0hPWHRpV20r?=
 =?utf-8?B?VmlDWTROUk11L2RvNnNLb2lleWRRbDVQcGZCbHZzaUkrc2FvNXRqY0o3WUt3?=
 =?utf-8?B?NGxNaGJkVVRnWllaNlhlMFk5clZwU3kwMy9aR0MyTkNxeEV4dTVsMStRNHBl?=
 =?utf-8?B?dm80UFM5VElpUFkycG5mbVM5dklVNFN5dk5UYW54UTNFSFJSY0habTdqWVpl?=
 =?utf-8?B?L2RCRXBneDRoL0R2NThmYll1QmpWMkx0cVFFaXI4a1crRnBWTGp3UTZ3U2dG?=
 =?utf-8?B?c2drOHhHeEd3WmprVk5hRjlsUk5Ua0EwMy9mSlFWeUxxTkppdTYvVHFmaVV2?=
 =?utf-8?B?dStONjNZaUVJc1owdy9CU2ZpL0R1OERuM1NJU2IxVjU4ZGFpczFqRXlsaFVw?=
 =?utf-8?B?SnhhNlJGY3ltVzVNSFVWWnNPMWMwWmFhM045SitGUDNRUS9PeExhcldlY3V5?=
 =?utf-8?B?OXVMR3NnQy92SEdlRExHSVg1TVBGMlp2Y1NEWlBYVUhYR3l2ZnFVc1IxUm1m?=
 =?utf-8?B?MURMOFZRbU5vclp1VEV3OTkwR1doTnRqcXRyNE9MNzJCMkNIdUt3dElyRTNk?=
 =?utf-8?B?M0IwTXpoZXhKV242eGFQc1BadllVckF1WDI1ZEx2R0dNaEJBZi80QU1PeTEz?=
 =?utf-8?B?VytsTFM4eHZuenlueVk1MksxbkQ0L3pQYWlDZytmOWFkUGlvWDZ0STc2L2No?=
 =?utf-8?B?bWdnK3RsSmRUTFd4Tlp6MkQzSjJ6c25WMk5oV1gwY2Q5ZVd0TmxWQi8rQVNK?=
 =?utf-8?B?NWtORDFYVVhCZVRZVTI4eUx1V1dNYTZkWE1xVmlRdGk4SmdaMThndTZOSWxy?=
 =?utf-8?B?VTlxdFVOcFlsdFF1TzVzSXE5RU5tcjZZY0grK2NwbVpvRWFXL25ISEhydWVz?=
 =?utf-8?B?V3BHdXdnczI2dHpsNzgxZE80R3JtL3BnYzhPVFlDc1Jvck5nZXZuRm5Udi9p?=
 =?utf-8?B?MlFwNGlYR0FZOW5jeEdhbmpJYk05UnBCRXRLN3hrYk9YNitDaE1RbENwMHJU?=
 =?utf-8?B?Smo1dnJGcDJjRkMvREFINmFJY01CNmxiNzNGVWlXOWZJM1NKZS9Nems4MjV0?=
 =?utf-8?Q?Gg+7eXhjX38=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SVdJcmlsQnNsQ2paZVNGNVBiR2VSL1dwcGZPallaa0ZVNDVKVnJNMEdiWkkr?=
 =?utf-8?B?Nkg5VVpTUHJRSXRvYnZPMWxyUEVQUjBIU3prZEpDQU9Xdktkdi9MalJwT25L?=
 =?utf-8?B?dWVwN0sxc3pNU0E0NlVVSkJXNnhSUHlxc2lnQ1dkTXZqeXFwR1N6YVJCUHIy?=
 =?utf-8?B?TTIvdWN6aVdHVWhZekNMNmYybVNuU055ZFpLa1ZWV0t5WksrUUZvek8ycmRB?=
 =?utf-8?B?K1pMdDdRRlNvNEhHUEtpQVFNVXlFVHNqZG10cS9POEZsVFMwdE9DQ1BsbmR6?=
 =?utf-8?B?ZmtPTUxRa2pRRFhHdUFsY3N2SmEvM21IY0ZKUFdHbWVjQk9leE15QTU4ampp?=
 =?utf-8?B?WXR4ditzNDFMeDNuZUxlTm13MDVLNVdlOTBUQ1RKWmxESG9acmxtSVVhY0ZB?=
 =?utf-8?B?MmZZWVBCamd3VndQTVcvMmw4WmthNWs5OWZHMHhXSHkxeGtlcm9SWTRkUk5m?=
 =?utf-8?B?eFp4LzhGUk9yaGw5U0dzWDNQOXZVNjdpdHFTUXZsWFdGaXRHZVVWZzNIbDcz?=
 =?utf-8?B?bTNuOWpwKzVpcUlGSHZuY1JqajdZeHp0eFI3UmppdTl4dWhleVV3RWM4S25M?=
 =?utf-8?B?UTVTa0JXcmN1MHJ4YVpVV1Fmay9sd0VLQUhKQnAwZllOV1hvNFVGTnJwMm5q?=
 =?utf-8?B?RGdoRVhWc1ljSkpQd291QlRGcUoyaWZNRmgzMFVRTjNhQjBrTTk2bVV5QlY0?=
 =?utf-8?B?TS9HN29SbnNWeVhtS3pFUmF0YUd4NVN4aWErS3h5UmJSd2ZBbFpKT0lCVkJ2?=
 =?utf-8?B?N1FFYnM1UjFRUStES3hKRzUwNDVYdjllV0hOOGZ4MHVsVmQ3SVBCZzNSUys3?=
 =?utf-8?B?OGt1bUI5bEdjR3p5cGNuT3BVb3c3d29zZ21UYjhLYk45Y2tyZkthOUVOcFF5?=
 =?utf-8?B?dWFPMlFIYVU2ZkR0dnlUak8vdlRjOG92RU1ma0ljYXdrVFBxWjRKbDNXYUdD?=
 =?utf-8?B?T2FJdkhTS0dLMkVpNGhyWFMxaDFmZEQ0dkxuYTk2UkwzTUp5eG44UWtKYmh6?=
 =?utf-8?B?UFJSOHlML2tYYWpGTnhaNlRwWG5ZV1pNOUNHWGZTM2Iwc1ExRGpHZFRuVXAy?=
 =?utf-8?B?RkJoUWN2MUdtK2FHNGRheVNRV01STjBjRk9sRDZhZWtQbUFnV2VlMGRzRm9E?=
 =?utf-8?B?czFoWFREZGl0Q1h6VDJyaE9EbVVOY0hMcDFVTWQvcFJaRGdkTlBrUnhYaGR4?=
 =?utf-8?B?SnI3MEQ2QzN2dnNaS2w0bWp4bzQvdFlGZG9HVmk2UzVmdXF5SlI1S2JockR1?=
 =?utf-8?B?VTBXSGNyOGZLSSszSEZUdkJ4NllyWDIwblRaeFhlTUd3b1cxM1NhbDlNNzBa?=
 =?utf-8?B?bjBmRjhoMnAzb1ZJT0VibkgycEVTTmd2aVJrckxGaTlVRFpiR3FBcXQzUXNj?=
 =?utf-8?B?WEhERXNTMExjWXdZelRMYlJWd1VyYnRvQWhaRis1Tm9VRHVIVjdlWmJOMHNB?=
 =?utf-8?B?TzlOM3RHUi9rbVZTcUEwRXdNUGlYYUN4cXVIM0FGYVZzVHpQSFNseGlTLzFy?=
 =?utf-8?B?bWM0UTZNdm1jd2Nndnl5b0t5bEVBbjFlYm94ejFQZTU0N2JzaW9BZSt1Q2hz?=
 =?utf-8?B?MXFhWWJobGkyQThUM3JMTytSd2tyUlh5Ui9xeWxOWnR5Ym16Rnl0clhUY3FK?=
 =?utf-8?B?QkIrdy9OblBtc25GcW1RZjFFTXFMRFEveFJkOHFEMTFxcFdWT0U3dEdTTUhj?=
 =?utf-8?B?dDlKOTdtbkszMlh5L0Z5aXhheTdmYW9GLzlqMjBhdEN4VGNhZitvRTA1Kytk?=
 =?utf-8?B?Q0ZxbmpjWVFzUVVHN3VBRno1NGltYkg4ME0vZWRhOVpWb3RVc3FrcG9nQ2Z4?=
 =?utf-8?B?bEppMjVqZy8xbGFWOHdEQkluaG42bUZNNzZadC84Zi8yYm1KbFFta0VkWGxq?=
 =?utf-8?B?Q1drcCt1QmZyWXNCaGlJRkhGT3RyTlE3OXFVUThEVkVXa2lmcFIzUVFEMUtu?=
 =?utf-8?B?S0ZXc1VpdldKWE93QnNJUzgydHNNWGtKYXU5b3h6SHo4WlY4Q2crR0IzdE43?=
 =?utf-8?B?N0RSbkFLN3ZwRDBVNC9OeVE1RU9WdFQ0c3R2dXJST044S0g1aEZRazlzU3lW?=
 =?utf-8?B?NTRkRy9zYUN0am1ycHZ5ZHN1aUZoZEZVeVRudnh4dWtqcmY2b0N4ZmMrTnlF?=
 =?utf-8?B?UElHdEprWWtiLzFxclhWV2F0RGkvL3lNdGFpTGM3aEZuNW5wS0FHaXJYZTJr?=
 =?utf-8?B?TGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 71028975-eb2c-4506-c45f-08dddb7d1ddf
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:54:17.6118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCsKiWFwH0V5bfTFrpUK1+4nnqW9n7eSW+VH++U9rlvTiDqi6bqEF2CgFA6KYHiTzwY/NM1a9UiUd+vdb6aVHOkdWnzVWKyo5pmHi30VMLo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF5A636EDE4
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
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

I think the "This will be overwritten ..." should be dropped. It is
not always overwritten and the later part of changelog describes these
details. This part is just to introduce the different meanings of
RMIDs.

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
> (those with telemetry_region::num_rmids < event_group::num_rmids) as
> unusable.  Note that the rdt_options[] structure must now be writable
> at run-time.  The request to disable will be overridden if the user

"The request to disable will be overridden ..." -> "User can force an
under-resourced event group to be usable using the "rdt=" Linux boot
parameter. In this case, reduce the number of RMIDs supported by the
event group to be the number of RMIDs of the telemetry region."?

> explicitly requests to enable using the "rdt=" Linux boot argument.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values as this value
> will be used later to compare against the number of RMIDs supported by
> other resources.
> 
> N.B. Changed type of rdt_resource::num_rmid to u32 to match type of

Changed -> Change

> event_group::num_rmids so that min(r->num_rmid, e->num_rmids) won't
> complain about mixing signed and unsigned types.  Print r->num_rmid as
> unsigned value in rdt_num_rmids_show().
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
>  arch/x86/kernel/cpu/resctrl/core.c      | 18 ++++++++++-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 43 +++++++++++++++++++++++++
>  fs/resctrl/rdtgroup.c                   |  2 +-
>  5 files changed, 64 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index d729e988a475..c1cfba3c8422 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -288,7 +288,7 @@ struct rdt_resource {
>  	int			rid;
>  	bool			alloc_capable;
>  	bool			mon_capable;
> -	int			num_rmid;
> +	u32			num_rmid;
>  	enum resctrl_scope	ctrl_scope;
>  	enum resctrl_scope	mon_scope;
>  	struct resctrl_cache	cache;
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index e76b5e35351b..0e292c2d78a1 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -179,6 +179,8 @@ void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
>  bool rdt_is_feature_enabled(char *name);
>  
> +void rdt_set_feature_disabled(char *name);
> +
>  #ifdef CONFIG_X86_CPU_RESCTRL_INTEL_AET
>  bool intel_aet_get_events(void);
>  void __exit intel_aet_exit(void);
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index d151aabe2b93..2b011f9efc73 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -776,7 +776,7 @@ struct rdt_options {
>  	bool	force_off, force_on;
>  };
>  
> -static struct rdt_options rdt_options[]  __ro_after_init = {
> +static struct rdt_options rdt_options[] = {
>  	RDT_OPT(RDT_FLAG_CMT,	    "cmt",	X86_FEATURE_CQM_OCCUP_LLC),
>  	RDT_OPT(RDT_FLAG_MBM_TOTAL, "mbmtotal", X86_FEATURE_CQM_MBM_TOTAL),
>  	RDT_OPT(RDT_FLAG_MBM_LOCAL, "mbmlocal", X86_FEATURE_CQM_MBM_LOCAL),
> @@ -838,6 +838,22 @@ bool rdt_cpu_has(int flag)
>  	return ret;
>  }
>  
> +/*
> + * Can be called during feature enumeration if sanity check of
> + * a feature's parameters indicates problems with the feature.
> + */
> +void rdt_set_feature_disabled(char *name)
> +{
> +	struct rdt_options *o;
> +
> +	for (o = rdt_options; o < &rdt_options[NUM_RDT_OPTIONS]; o++) {
> +		if (!strcmp(name, o->name)) {
> +			o->force_off = true;
> +			return;
> +		}
> +	}
> +}
> +
>  /*
>   * Hardware features that do not have X86_FEATURE_* bits.
>   * There is no "hardware does not support this at all" case.
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 7db03e24d4b2..96c454748320 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -15,6 +15,7 @@
>  #include <linux/cpu.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -50,24 +51,30 @@ struct pmt_event {
>  
>  /**
>   * struct event_group - All information about a group of telemetry events.
> + * @name:		Name for this group (used by boot rdt= option)
>   * @pfg:		Points to the aggregated telemetry space information
>   *			within the OOBMSM driver that contains data for all
>   *			telemetry regions.
>   * @list:		Member of active_event_groups.
>   * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group.
>   * @guid:		Unique number per XML description file.
> + * @num_rmids:		Number of RMIDS supported by this group. Adjusted downwards

RMIDS -> RMIDs

"Adjusted downwards ..." -> "May be adjusted downwards ..."
(it is not always adjusted, only when user insists, no?)

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
>  	struct list_head		list;
>  	struct pkg_mmio_info		**pkginfo;
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmids;
>  	size_t				mmio_size;
>  	unsigned int			num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -84,7 +91,9 @@ static LIST_HEAD(active_event_groups);
>   * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
>   */
>  static struct event_group energy_0x26696143 = {
> +	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
>  	.evts				= {
> @@ -98,7 +107,9 @@ static struct event_group energy_0x26696143 = {
>   * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
>   */
>  static struct event_group perf_0x26557651 = {
> +	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmids	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
>  	.evts				= {
> @@ -137,6 +148,22 @@ static bool skip_this_region(struct telemetry_region *tr, struct event_group *e)
>  	return false;
>  }
>  
> +static bool check_rmid_count(struct event_group *e, struct pmt_feature_group *p)

I think the function name can be made more helpful, how about:
all_regions_have_sufficient_rmid()? 

> +{
> +	struct telemetry_region *tr;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		tr = &p->regions[i];
> +		if (skip_this_region(tr, e))
> +			continue;
> +
> +		if (tr->num_rmids < e->num_rmids)
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  static void free_pkg_mmio_info(struct pkg_mmio_info **mmi)
>  {
>  	int num_pkgs = topology_max_packages();
> @@ -159,12 +186,21 @@ DEFINE_FREE(pkg_mmio_info, struct pkg_mmio_info **, free_pkg_mmio_info(_T))
>   */
>  static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	struct pkg_mmio_info **pkginfo __free(pkg_mmio_info) = NULL;
>  	int *pkgcounts __free(kfree) = NULL;
>  	struct telemetry_region *tr;
>  	struct pkg_mmio_info *mmi;
>  	int num_pkgs;
>  
> +	/* Potentially disable feature if insufficient RMIDs */

"Potentially disable" -> "Disable"

> +	if (!check_rmid_count(e, p))
> +		rdt_set_feature_disabled(e->name);
> +
> +	/* User can override above disable from kernel command line */
> +	if (!rdt_is_feature_enabled(e->name))
> +		return -EINVAL;
> +
>  	num_pkgs = topology_max_packages();
>  
>  	/* Get per-package counts of telemetry regions for this event group */
> @@ -173,6 +209,8 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  		if (skip_this_region(tr, e))
>  			continue;
>  

Would a comment like below be valid? If so, I think it will be useful.
		/* e->num_rmids only adjusted lower if user forces an unusable region to be usable */

> +		e->num_rmids = min(e->num_rmids, tr->num_rmids);
> +
>  		if (!pkgcounts) {
>  			pkgcounts = kcalloc(num_pkgs, sizeof(*pkgcounts), GFP_KERNEL);
>  			if (!pkgcounts)
> @@ -215,6 +253,11 @@ static int discover_events(struct event_group *e, struct pmt_feature_group *p)
>  	for (int i = 0; i < e->num_events; i++)
>  		resctrl_enable_mon_event(e->evts[i].id, true, e->evts[i].bin_bits, &e->evts[i]);
>  
> +	if (r->num_rmid)
> +		r->num_rmid = min(r->num_rmid, e->num_rmids);
> +	else
> +		r->num_rmid = e->num_rmids;
> +

Another step in the discover_events() function comments? 

>  	return 0;
>  }

Reinette

