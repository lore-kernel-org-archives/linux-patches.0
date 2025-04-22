Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C3CD262FC7
	for <patches@lists.linux.dev>; Tue, 22 Apr 2025 21:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745357441; cv=fail; b=A0eXYihXxIu7i9Scsb80iylF26YRepNpOst15ZUPU2rIZ49vsZ6eLpDTYzn2Slsqm7EX04iOEWc54DoHYM8bsYcZNTVLm634LgOpE+i/ES4sj+LZmX3o3+wHVifKib4Ctc7IdaWKaIOByhGHVZKkU6IkFey4rQWXqH3AZaxe1cQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745357441; c=relaxed/simple;
	bh=ea9PXMLr2IUn07272H10+NOO7UnLz82YNdEwkJxhj4o=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=E27w0IVHOUNzCoXAsLlbsRna52DVvMdGRKtNp0jpgPWDchnvpblNZe+EB5tZ2BSaAhTUzXo6CcGVksOlr7EXCDsEdQokREgeY0wWRW8ty+nquK3RkILq2a7Z045tfqBvj+b90zHePO8ckSexA+Q6gXZKUWDCuXhlZoqWJrqPuxo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m069AN4A; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m069AN4A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745357439; x=1776893439;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ea9PXMLr2IUn07272H10+NOO7UnLz82YNdEwkJxhj4o=;
  b=m069AN4At1nk3pc02tUbJDdotPURAQWJjBpHYjExpfk+aVm7C5R03Jce
   oCJC0rXcokuCtG4WqfEl8axICXeFPOfDc5QArzTSBi7JjXevq0ITHsS8D
   5i/ZSk3Jvnd41O2z8XqNc2/Q98P4PS5cBdynzGuUbFQxgT/36pIOKJwPg
   b+fB1SBZyB5hzThVdFexX/lezbsN7yemykUbx0bMsvrA4mev0Xe1gvVGQ
   iefP9f3xkA0GdHw2aPCPZEQX1oynITjxrduYhRxvlI/S74Luw7lUR3Btz
   i8MD/UmFDkqA1vnWudSVBl4pxixM4wlqTjxaWE8AUyc8N0FFWbPwhGbwQ
   w==;
X-CSE-ConnectionGUID: weVmyCY1Tpu40+GGUdMubg==
X-CSE-MsgGUID: W+vytxPrQC6SKDoLj4NxMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11411"; a="46813111"
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="46813111"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 14:30:38 -0700
X-CSE-ConnectionGUID: BbPSHsnURD+aFu0po4xJJg==
X-CSE-MsgGUID: 1LgbVRcARjCGIh5AhfUw1g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,232,1739865600"; 
   d="scan'208";a="137113640"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2025 14:30:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 22 Apr 2025 14:30:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 22 Apr 2025 14:30:37 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 22 Apr 2025 14:30:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X3QuxxMSuquUUDY5+lRkHPDBhyt1HBqJXtQl+4yFvZRdJ9Omio24N43YHfQigGaJSmGWv9FmKmlZzbTA9T0d4DWbUHT1FunfPQi8E35NvSLwoFjyFsjpEgl72JPTR1/6T1G8VpV+dlSlMR7iGSEd60QVgeWiolVWwCjsuIfsxR+27Z3Kt1P2WbncEgFt0Sk5RiKMyIanF1YMAzMa+j1UC3k8ooi+lE5qZFZLV+P0pZiev+GjA6MiwtL/nREiaIF8jSX4YegNdroHMisDpTzJebgce3vSeHE2UnVmtvW4LvsPjVh6qvrj/r1axY1jz6CAzEiGeiaC/k88YgpEumUq/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdXaMwVmqWCDM1aV+oa8BLnYHR5XAHsv2fCDNfo2py8=;
 b=bVOe0qh+koPvjnsVxkj9QPIwgSy/drz3zJALxEN4YFu3pbJU3IkxU3KsdioBYqepaAKyilocgryfTJuIZ+/D3tk9SBSs12kg7o/26fspRf13uJ2+2ItbyIInYBDZsKLP4QaxD8pb8/k8nC59T9ZAnuAIoVaka4hVwcflrcE01LpxAlq31/+o1rLvwUCJaJgaOjlJqAa0JPfEfSneEp5xh5z/0xkZ2uxhgBoIrOHiKLWeV0yjGOYcwgYESJPSpCLlqGKaSwU/EtZe92jckjxY6muoKZwhBMTs01Hy9xblWgps9PbrsqjFHIdv2ezlpbVXs+oEWrScWEVX2PsJoL5vJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7410.namprd11.prod.outlook.com (2603:10b6:8:151::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Tue, 22 Apr
 2025 21:30:34 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8655.024; Tue, 22 Apr 2025
 21:30:34 +0000
Message-ID: <8e9e7e36-1c01-433f-a0ed-7bcb856affdd@intel.com>
Date: Tue, 22 Apr 2025 14:30:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/26] x86/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <20250407234032.241215-1-tony.luck@intel.com>
 <53dcb55c-f5b6-4cb8-96b6-07aa1ba1d4d4@intel.com>
 <aAaVH4W72fOzQhnh@agluck-desk3>
 <ccb33985-e1d8-449e-b39e-3fccb5fc0783@intel.com>
 <aAfB29E8Shqp8JY3@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aAfB29E8Shqp8JY3@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0224.namprd04.prod.outlook.com
 (2603:10b6:303:87::19) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7410:EE_
X-MS-Office365-Filtering-Correlation-Id: 3946ce9f-c487-4d8e-b15b-08dd81e4ea58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cHlFcWxqa1FZUkJOU0prTmZvNWRnWHgzVThvaDlLVkpNd0Y3bEVPNEdBaGZt?=
 =?utf-8?B?cFRsdkdNQ0pGYkZadVMzRXVRaEZscThwZVpQTU5Dd1B1bEtZWkY5Sk9rVkZp?=
 =?utf-8?B?TjR5TjkyU3pJVk1oZ1dMbDkraHYwMUdDdFlITURPdGtIZ2RvQWdWWTQzVW04?=
 =?utf-8?B?Mzd1UE0wOFI4bjM3V1hOZ0s3VEtmWTZBM3VYMXZQcytWWW1BdlREekZvZXVm?=
 =?utf-8?B?ZTVpK0NNaFk3NW42MGc1aFRTRm12TVhYdnlhdTczcmFkQ0xmRG9NRnJmNjFo?=
 =?utf-8?B?dEwzRzVldm8vV0s3Z0F4b0tRSUhJR0tueWVOa1YwRUl2cjZPdzczdDd1WEFy?=
 =?utf-8?B?dFVRRzdKazFNM1N4T3pFNmxoU3kvM0hXU3FVbzE1TDlKVllKRE85SnFUdGJE?=
 =?utf-8?B?dFAzc2hQU2ZtcG5DWllNU2lxVFY4bXI2SmlPQ1RrL2F3a2dIbmNJTDE0ZkZk?=
 =?utf-8?B?d0tWNWRKRlBpZisxOFdoRmE5SU9YSEhpV0laTURBYk1abHp2Mi91b2tDZCt3?=
 =?utf-8?B?Vm9nWkhwdXQwZ3BzK05LZmVQM0lVWWRsdUV1aXI0eDVnaWlxK3JNd3lUYktE?=
 =?utf-8?B?UXd0dXhXWExtK1pkZnZiSjJGQXhPK2RDU1czTzBTUVZFd2xPTlFaY1cvOW5l?=
 =?utf-8?B?TDNxRmFrMGluMHBGZmQ3cmZPWlpPTmE5N0sxU3pKOVhMVVUvSU1EUmpZcGoz?=
 =?utf-8?B?VzluOEVOZjJ4a2NCYmI0bEI5YkJHR3A0SUdyYm5JaDE2WEpuUHhVUE16Skp6?=
 =?utf-8?B?blhaNjhXT3ZhemVVOWFidHVLUWhwaGE1ZUhVNDV5ZXBTQU42ZXhuNFpVN2pC?=
 =?utf-8?B?ODRJeGRoT21DT3ZZTnp2TW1zbzBFR0gvdkZFUFNSMm9vdk1rbDExZkVnK2tL?=
 =?utf-8?B?eHRuRnloYTJYeGdnZWF4RE9EZ055ZXhTQUtobUNZZTUrUnp2OW5aTURQOXQ4?=
 =?utf-8?B?NXl0REM2Vlk4aXVNRGdObHZienNZakU3WHRYY3k4cFk3VDBLOGVJV253ZUVC?=
 =?utf-8?B?S1FWRXNQVlhOQWdOSm5PRHNoZXNaZmxXTngxNDlWQ3RoSmlLd2ZEZ2xsYm8r?=
 =?utf-8?B?eUlYcitaWmNHanJTYWw4NGVVYXBXZXVzcldOU0FSaVpaNENhQzJha1dmUEJV?=
 =?utf-8?B?cklRNW9VZkwrM1pMT1ZJR3BlQVlGZ20yc2Z2UkVmVUx1bTAweHdvSVpra3Z5?=
 =?utf-8?B?NHgyQ3diT1pmdjF2d3dTWkRQRjl4b2N2U05JOFdPREZUY3BUamZnd0ZIcW1a?=
 =?utf-8?B?UUZtemdYdnp2Q1dGNXM2YTBTWWtFcmpBVEFhOHNNbTJsaTlQTmNWeHhPTVlz?=
 =?utf-8?B?amFrdy9VeWRXU1RCc0dseUt6R3ovb0VZdTF4Tkxkc2oza1dGeG9nUWZHbkFn?=
 =?utf-8?B?NHJJNzAyZWhmR3NMUXo5cU50Uk9xTzlETkZtNkJLTkVubHdsOWsxVDdGcUpl?=
 =?utf-8?B?aGZ4KzJPK2FNanF2dVdpbk80VWlSWGlMblVEVC91S05SdTA0WjZ3NmltcjFN?=
 =?utf-8?B?U2FWaEVqTWNtTGlQRjdpWW9TR2lvRVNSUU53M256eU1WUFZkbERzWlgzbDFI?=
 =?utf-8?B?dmZQcUJjKy8yeU41blNqcU9odVg4UG5jU0ZsNUFyQjJhc2FCZ3hDSHRiU1Uz?=
 =?utf-8?B?VXBaYzdlNzNTSFVpTHJZTFJGZFNDVHdlSnFhN0JDSktBTVpsY0s5M3lsWUpa?=
 =?utf-8?B?eGxwSXpjSHdWUElPcFNKWTNDamhES1FXVFo1RktQczhkMXFSR015SGJGenZz?=
 =?utf-8?B?cXpWeDBpRlpXR2NXVmlPZlpNVnMvOHVNZktCVnhHbVNUSndnWDQ5SC82K2lj?=
 =?utf-8?B?OTUrNC9uWGRtdzFJQWtpUzc3S2luMVk2ZWNCTU9tcE91S0J3T2dEM1ZSdkVE?=
 =?utf-8?B?SUpjZ3N3YkJsZVVaTWp3Zyt6T0s1c0FqeitNR0tLT0NmRlRIek9aWHhZMW5N?=
 =?utf-8?Q?SqtTORVRjcA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V0pYb1cxWFVlMFE2STBnUnVleGp0TTJyY3dsRHdCaENEN0hFaVhEdE1wTENE?=
 =?utf-8?B?elljTmVpUldnRHhqVXppbjl3ZWZIWnc3Yjg4OEprOEZ0ZlJ0UjhRMkQwLzBv?=
 =?utf-8?B?RFdMYTVtbHlZVzBjbEwwZnFZc0xVbzNSbkVOV0pTU0ZLQ20wbWwxM3FNUExW?=
 =?utf-8?B?K0pnTTBIL2cza2oxTlpxUVVSS01Iak5CTXc1cGliandqWWdQR2J3K2dZVzI0?=
 =?utf-8?B?ZUttUFAzbUd4QTNQMlRibDBDRnBXWktPdTZnY0w0VEx5bHVIMjVUYnd5Ykts?=
 =?utf-8?B?SE1KaU5SL1lYbGpXSEw3Y3R2b3RqazlrSzhVQ0NGdElFcUNpY0dkR0dXdlA4?=
 =?utf-8?B?Q050Q3YrOVZwcDhNSno1Snc5UlJYWWhpdHlFVTZjU2l5T1hUakg1bEFrcFdQ?=
 =?utf-8?B?YnUwL0tlTVhPbTg3ZFpORnFDeUhFSlJzY0NpZTJ2Ri8xTVBHQzc2Qld3RkdV?=
 =?utf-8?B?OXVWczg4eWxha3dzZUovRDlScTJ5MVdhTUpITWgxOWlZb2QxLzNYRjYwWlBz?=
 =?utf-8?B?c1I0akpibkZPNzFPanlxYkY5SUZCL3hzWkZvREk5YS92OEYxcmtRYkhYdWxV?=
 =?utf-8?B?M1VlN1c0amNPT2dCWlBXZUdrRXFsNU0vaUFpdnFibktSY3dwRDN0NXBnOHlt?=
 =?utf-8?B?VFlLWjVFKzlWSWJhb2N4eHlLR3QwbXBVVHl2S1htMmFneENTUjJrdStVRzVJ?=
 =?utf-8?B?UTJtMmkwaGlrMDk3SjYvaTVVWTdmNElzM3JJTkF6SmlIR2ZGOHBNeTlWLytV?=
 =?utf-8?B?QWZUODhHSms4clpoUU9vKzdkcmR5M29ueENLT29QZWNwU0t5emZsa3N6aWpL?=
 =?utf-8?B?eGlVaUlLSU5rVGZWdkVpUE16dmp2QnRDOFpQMCtCUVVQRHo4eVNEbHVHS09o?=
 =?utf-8?B?OXFLbkhudGlJWU5iTE1GdFpRNlREbE5KQnBWdjdHZE83N0duZWJqYUxMaG82?=
 =?utf-8?B?OFVjN2JUYVUyYUhWVFBYUVY5Tk1VRGVieEJXYlJ3aDRoSkgwMGwvRFgyOFdl?=
 =?utf-8?B?NXp6dlVMNHRzZ3B0dGdRS2NZaDdNT1YyblRnRnlSVlRpMjM0NDNjTGxFZGIr?=
 =?utf-8?B?T2RSMDVVNHR4T0l0RVdTdVZLTEM2S2t4bWFZdWdIWlV0eXg1bzFhSTJjYkhO?=
 =?utf-8?B?eU5lOHB3RzBWRGlQdmllUTRhQWh2ZkR4S2N5Umt5WDRVc0k3aFdtWGRTR0NQ?=
 =?utf-8?B?c1pMNVc4OVFwcldVRVpwZDJMc3ozYmRJeWRpcUc4Ukk0SE1paHNCNTRLeW4r?=
 =?utf-8?B?MDFqMEtObEVVc3BzNmpvaDlydGRpUUh5dUh5d2xVRW10RHlHTnVVQTN0ZlZ2?=
 =?utf-8?B?ekhWUW93eDVTQ09Zdlp3OUJOMFo5cXhUbmgvWTNZa1Y4d0EyUUNMT2Q4Q0w2?=
 =?utf-8?B?L2FKVEhKMHM4QzZrdEhsOVVFVFpUL2ZacFl3SjBQbS95ajZkZlhjNm5EVjhK?=
 =?utf-8?B?QVRBNy9ISHdMdk1qYnU3WEZ6ZnJvamM1M09uUTNraTZkM2NRenBiVzZENm4x?=
 =?utf-8?B?MnhEMXpOd0hTVzUxSWcydWg4LzJCOXdWMmhhSDNNRnk4a1YxMDVlb3NvR2Vk?=
 =?utf-8?B?S0JZQmQzdnAzeGszY1AxYmVPTkM0T3RjcHIxdjlCN29GNUhiS3FHZVdoNVNX?=
 =?utf-8?B?WUY0ejRidW5rcDRrVU1jQWY1UXIxY3YyS1IyUnRqOWJpRXh3TE8yKzRpNm9n?=
 =?utf-8?B?MEkxZnNkMHluaUZLUTRXVjZPZjhXanJ4bTlXUHF3STZscnU3bWgzckQxanJT?=
 =?utf-8?B?NUc5bmVWc2lKZlVzTkJ5T3VScUN1bnZHN29ib0JHMm1OYXFBbmtHV1pUY28r?=
 =?utf-8?B?QWl3R1RUTHI5Q2FFWXNBNzVwdlY3emtqNVFRQ0tld1JVRXVrVzlUek5sMjY4?=
 =?utf-8?B?YkVucDU2cnJoeDhkYXVtNVpWaFRvMk5xcnNhQ085c1hNVVdQYlZNaUo1VG5Y?=
 =?utf-8?B?NGE3RENwQnJ0SzBSZ2pHbTJiVVRBOGZVMmVwTHVMdG9xUjk5LzkyTE1UL293?=
 =?utf-8?B?Y0tLeUpna3lEMjRSRDhFajArRVNmWm9zVDlJNTMvT3cxQlBEeGg0RGs5MHVM?=
 =?utf-8?B?UEdvT2pLaDlEVUJvczNTRDFqaDZxV1ZUMHEwVlRFMExmU1FRUTRNTHRtbkJI?=
 =?utf-8?B?SllTcGQwMVF1WkY3RFlPT1JiL3cwT1VjdzdGaUF6OUVta0JhYXFyVEF1Zlhh?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3946ce9f-c487-4d8e-b15b-08dd81e4ea58
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2025 21:30:34.4909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ZrA041TGSoKgaX2iS28G9ybwzufEK3+14EuEieTaPtoe5mXrhyXyeJL9yLopifGjLhU8+Al4L+dveEMIHWr3ZMlPEeOTzzq+2CurAh7zsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7410
X-OriginatorOrg: intel.com

Hi Tony,

On 4/22/25 9:20 AM, Luck, Tony wrote:
> On Mon, Apr 21, 2025 at 03:59:15PM -0700, Reinette Chatre wrote:
>> Hi Tony,
>>
>> On 4/21/25 11:57 AM, Luck, Tony wrote:
>>> On Fri, Apr 18, 2025 at 02:13:39PM -0700, Reinette Chatre wrote:
>>>> One aspect that is only hinted to in the final documentation patch is
>>>> how users are expected to use this feature. As I understand the number of
>>>> monitor groups supported by resctrl is still guided by the number of RMIDs
>>>> supported by L3 monitoring. This work hints that the telemetry feature may
>>>> not match that number of RMIDs and a monitor group may thus exist but
>>>> when a user attempts to ready any of these perf files it will return
>>>> "unavailable".
>>>>
>>>> The series attempts to address it by placing the number of RMIDs available
>>>> for this feature in a "num_rmids" file, but since the RMID assigned to a monitor
>>>> group is not exposed to user space (unless debugging enabled) the user does
>>>> not know if a monitor group will support this feature or not. This seems awkward
>>>> to me. Why not limit the number of monitor groups that can be created to the
>>>> minimum number of RMIDs across these resources like what is done for CLOSid?
>>>
>>> Reinette,
>>>
>>> The mismatch between number of RMIDs supported by different components
>>> is a thorny one, and may keep repeating since it feels like systems are
>>> composed of a bunch of lego-like bricks snapped together from a box of
>>> parts available to the h/w architect.
>>
>> With resctrl needing to support multiple architectures' way of doing things,
>> needing to support variety within an architecture just seems like another step.
>>
>>>
>>> In this case we have three meanings for "number of RMIDs":
>>>
>>> 1) The number for legacy features enumerated by CPUID leaf 0xF.
>>>
>>> 2) The number of registers in MMIO space for each event. This is
>>> enumerated in the XML files and is the value I placed into telem_entry::num_rmids.
>>>
>>> 3) The number of "h/w counters" (this isn't a strictly accurate
>>> description of how things work, but serves as a useful analogy that
>>> does describe the limitations) feeding to those MMIO registers. This is
>>> enumerated in telemetry_region::num_rmids returned from the call to
>>> intel_pmt_get_regions_by_feature()
>>
>> Thank you for explaining this. This was not clear to me.
>>
>>>
>>> If "1" is the smallest of these values, the OS will be limited in
>>> which values can be written to the IA32_PQR_ASSOC MSR. Existing
>>> code will do the right thing by limiting RMID allocation to this
>>> value.
>>>
>>> If "2" is greater than "1", then the extra MMIO registers will
>>> sit unused.
>>
>> This is also an issue with this implementation, no? resctrl will not
>> allow creating more monitor groups than "1".
> 
> On Intel there is no point in creating more groups than "1" allows.
> You can't make use of any RMID above that limit because you will get
> a #GP fault trying to write to the IA32_PQR_ASSOC MSR.
> 
> You could read the extra MMIO registers provided by "2", but they
> will always be zero since no execution occurred with an RMID in the
> range "1" ... "2".
> 
> The "2" is greater than "1" may be relatively common since the h/w
> for the telemetry counters is common for SKUs with different numbers
> of cores, and thus different values of "1". So low core count
> systems will see more telemetry counters than they can actually
> make use of. I will make sure not to print a message for this case.

I see, thank you.

> 
>>> If "2" is less than "1" my v3 returns the (problematic) -ENOENT
>>> This can't happen in the CPU that debuts this feature, but the check
>>> is there to prevent running past the end of the MMIO space in case
>>> this does occur some day. I'll fix error path in next version to
>>> make sure this end up with "Unavailable".
>>
>> This is a concern since this means the interface becomes a "try and see"
>> for user space. As I understand a later statement the idea is that
>> "2" should be used by user space to know how many "mon_groups" directories
>> should be created to get telemetry support. To me this looks to be
>> a space that will create a lot of confusion. The moment user space
>> creates "2" + 1 "mon_groups" directories it becomes a guessing game
>> of what any new monitor group actually supports. After crossing that
>> threshold I do not see a good way for going back since if user space
>> removes one "mon_data" directory it does get back to "2" but then needs to
>> rely on resctrl internals or debugging to know for sure what the new
>> monitor group supports.
> 
> But I assert that it is a "can't happen" concern. "2" will be >= "1".
> See below. I will look at addressing this, unless it gets crazy complex
> because of the different enumeration timeline. Delaying calculation of
> number of RMIDs until rdt_get_tree() as you have suggested may be the
> right thing to do.

As you explain it, it does not sound as though calculating how many
RMIDs can be supported is required to be done in rdt_get_tree(), but doing
so would make the implementation more robust since doing so does not rely
on assumptions about what hardware can and will support. 

> 
> "3" is the real problem
> 
>>>
>>> If "3" is less than "2" then the system will attach "h/w counters" to
>>> MMIO registers in a "most recently used" algorithm. So if the number
>>> of active RMIDs in some time interval is less than "3" the user will
>>> get good values. But if the number of active RMIDs rises above "3"
>>> then the user will see "Unavailable" returns as "h/w counters" are
>>> reassigned to different RMIDs (making the feature really hard to use).
>>
>> Could the next step be for the architecture to allow user space to
>> specify which hardware counters need to be assigned? With a new user
>> interface being created for such capability it may be worthwhile to
>> consider how it could be used/adapted for this feature. [1]
>>
>>>
>>> In the debut CPU the "energy" feature has sufficient "energy" counters
>>> to avoid this. But not enough "perf" counters. I've pushed and the
>>> next CPU with the feature will have enough "h/w counters".
>>>
>>> My proposal for v4:
>>>
>>> Add new options to the "rdt=" kernel boot parameter for "energy"
>>> and "perf".
>>>
>>> Treat the case where there are not enough "h/w counters" as an erratum
>>> and do not enable the feature. User can override with "rdt=perf"
>>> if they want the counters for some special case where they limit
>>> the number of simultaneous active RMIDs.

I get this now. This will require rework of the kernel command line parsing
support since current implementation is so closely integrated with the
X86_FEATURE_* flags (and is perhaps an unexpected architecture specific
portion of resctrl). 
What if "rdt=perf" means that "3" is also included in the computation
of how many monitor groups are supported? That would help users to not
need to limit the number of simultaneous active RMIDs.

>>
>> This only seems to address the "3" is less than "2" issue. It is not
>> so obvious to me that it should be treated as an erratum. Although,
>> I could not tell from your description how obvious this issue will be
>> to user space. For example, is it clear that if user space
>> gets *any* value then it is "good" and "Unavailable" means ... "Unavailable", or
>> could a returned value mean "this is partial data that was collected
>> during timeframe with hardware counter re-assigned at some point"?
> 
> When running jobs with more distinct RMIDs than "3" users are at the
> mercy of the h/w replacement algorithm. Resctrl use cases for monitoring
> are all "read an event counter; wait for some time; re-read the event
> counter; compute the rate". With "h/w counter" reassignment the second
> read may get "Unavailable", or worse the "h/w counter" may have been
> taken, and the returned so a value will be provided to the user, but
> it won't provide the count of events since the first read.
> 
> That's why I consider this an erratum. There's just false hope that
> you can get a pair of meaningful event counts and no sure indication
> that you didn't get garbage.
> 
>>>
>>> User can use "rdt=!energy,!perf" if they don't want to see the
>>> clutter of all the new files in each mon_data directory.
>>>
>>> I'll maybe look at moving resctrl_mon_resource_init() to rdt_get_tree()
>>> and add a "take min of all RMID limits". But since this is a "can't
>>> happen" scenario I may skip this if it starts to get complicated.
>>
>> I do not think that the "2" is less than "1" scenario should be 
>> ignored for reasons stated above and in review of this version.
>>
>> What if we enhance resctrl's RMID assignment (setting aside for
>> a moment PMG assignment) to be directed by user space?
> 
> I'll take a look at reducing user reported num_rmids to the minimum
> of the "1" and "2" values.

When comparing to "num_closids" the expectation may be that "num_rmids"
would be accurate for particular resource with understanding that the
minimum among all resources guides the number of monitor groups. This
seems close enough to existing interface to not use this as moment
to move to a new "num_mon_hw_id" or such that works for MPAM also.

> 
>> Below is an idea of an interface that can give user space 
>> control over what monitor groups are monitoring. This is very likely not
>> the ideal interface but I would like to present it as a start for
>> better ideas.
>>
>> For example, monitor groups are by default created with most abundant
>> (and thus supporting fewest features on fewest resources) RMID.
>> The user is then presented with a new file (within each monitor group)
>> that lists all available features and which one(s) are active. For example,
>> let's consider hypothetical example where PERF_PKG perf has x RMID, PERF_PKG energy
>> has y RMID, and L3_MON has z RMID, with x < y < z. By default when user space
>> creates a monitor group resctrl will pick "abundant" RMID from range y + 1 to z
>> that only supports L3 monitoring:
> 
> There is no way for s/w to control the reallocation of "h/w counters"
> when "3" is too small. So there is no set of RMIDs that support many
> events vs. fewer events. AMD is solving this similar problem with their
> scheme to pin h/w counters to specific RMIDs. I discussed such an option
> for the "3" case, but it wasn't practical to apply to the upcoming CPU
> that has this problem. The long term solution is to ensure that "3" is
> always large enough that all RMIDs have equal monitoring capabilities.

ack.

Reinette
