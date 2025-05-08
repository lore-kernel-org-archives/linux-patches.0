Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C063C17
	for <patches@lists.linux.dev>; Thu,  8 May 2025 03:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746675047; cv=fail; b=qr5ipp4t+AeZ25q/Zq01NayRh6R5cuTxfXGFEMdVvsfJU1t9qGVON1lLVGjua5uwz+VS5vUfMN95N7NUSXqFbWE9RD18gKm/wPmcAOXMx/EvDteKX2fSKx2dysljMxmuOpiiuTH3YLlChwccbw7yiYQ3FUliLFqFb95/UEnJEJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746675047; c=relaxed/simple;
	bh=JCJWdVfiCv5inIjBqDJJmwnfApijAeU8cRXsa/AroYE=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=anQzdQixDEfVi41lauwwBqfcwgNGX56ETFg4Tmbl35K2pO985on2ui1QgiQmrWI+s/KM4sSCu0stUi5euQULZNuPvMDuUffMMVHIPnrPNTO9cP5twEdl6XedEjuR2yoWzrK/UAU1tBuomMejBaauj90eEMMhds8a9oT88piS9/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QnHgIjbS; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QnHgIjbS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746675045; x=1778211045;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JCJWdVfiCv5inIjBqDJJmwnfApijAeU8cRXsa/AroYE=;
  b=QnHgIjbSOeYPV5QDwLABXIfM+lgMNvSIGulRFugFR3DfocRi7+3KW7L1
   NzfwiXA14QjD9LVXXdAk9tH3myft+EVwwneXvkeY0NfyCHT1P+jI6yfjD
   tpcYW4ABqc2cvahARKthsK2RF2C8ziGIJdnCnbsE6xlvYA3DHFt4FDOPN
   AB2gyo5tBXru0euHOskICjYSOo7zEC4LpSblcjxY4zHDQXK32OJbpjRrm
   Jvtn+SDqm+7mrfmElVHgbhor0vPPXtfBfbCXoSgryVGF1eVoIQCXpeVq/
   kFrFDlS1cVzZTFdj+EmKJvpbrIJdnJ93vcUu9kLqXVHQXKBSKoWVazNGR
   Q==;
X-CSE-ConnectionGUID: XYQq1y2HR8GlBdHhpcMXxA==
X-CSE-MsgGUID: 9nIVjqhiSZ+yuhlhD3E0wA==
X-IronPort-AV: E=McAfee;i="6700,10204,11426"; a="48305205"
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="48305205"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:30:44 -0700
X-CSE-ConnectionGUID: mbJQNrKSTO+/jgZ/u72VKw==
X-CSE-MsgGUID: OGSsn644QhCle8EY6epCzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,271,1739865600"; 
   d="scan'208";a="167214082"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 20:30:43 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 7 May 2025 20:30:42 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 7 May 2025 20:30:42 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 7 May 2025 20:30:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sIPNLvVlWKNHvhe2nUvvO412IM303j9+d4Xqeg5sRs4zIUeXXECVHUwtpJbc4hl7J/32aKeeNSo2rE6mkgQE0/sEwXQzEldrzsUZUbgeR3t7YSLMcBNOiwJI8iCzhYfQs/qZHtKZmr5brM8TBvYLbZtM8OBQiGi08S+iKK6dyFTnHGwiMOSS8ykrH2+M9aEuKzHRxVOib8adGo+ZTnPZEe/dqboSLcJfCXlm8iWdL1uSlDHRuflr05BpuaLpWIG1PGtz+FLL4pv0uCl1+VfRd2pcm8oUhNjh8wd1DUvrUR4iLFQ30gHzzY+4c9AEQLJBc2xKeOFdu7T8q1xEvCKFyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J239KXoyVLE3Y8R1pdM7gv5SByeknyR6jNzmG/3F0RY=;
 b=t8Up0Idunts0P6TnxlG+lg7UCeraI/H85oIgQFNXdBD8YOKpOmMtB0ThRQvzwh1Fqdedo5DytW88JezMoOCfvJauEXgFgXabUUvU3fbbSIA1koTHIjZGQWMgrFSjuLCRH+v88+FcS5DY4qMW39UVy8G0aHa4kzUa2HK16CXBh2MqXiVbNHPeVBskjID31Mq5OdpKvOXqr+0DxNrqvkgG3kbTc2D6NINd1RZyhuuPSXzksJ08TeYzRNPKd4P1ikz5TijBI1NhLWudXPej4Na/De9l9xeT9jVVLVsSmRvf9R/36jp35RWdbL19S8W0HeixrXO7gutT7a8JCAOFRaaWMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB7518.namprd11.prod.outlook.com (2603:10b6:a03:4c5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 8 May
 2025 03:30:30 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8699.022; Thu, 8 May 2025
 03:30:30 +0000
Message-ID: <a470eae9-4368-42df-96d5-0d63c81980af@intel.com>
Date: Wed, 7 May 2025 20:30:28 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/31] x86,fs/resctrl: Prepare for more monitor events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250429003359.375508-1-tony.luck@intel.com>
 <20250429003359.375508-3-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250429003359.375508-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR05CA0003.namprd05.prod.outlook.com
 (2603:10b6:a03:254::8) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB7518:EE_
X-MS-Office365-Filtering-Correlation-Id: 49986c30-7abe-478e-48e9-08dd8de0ae5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TFNUSU5XcnFUL1hhVE8vSmtrcmdNbVJKRWpudnhBQzZ4YXN1YUNtVTUzVzY1?=
 =?utf-8?B?YTRFZ0NpWTJ0dk1Ec0pUam9ZSUNOZUsyRHJsckpZcHVsL1IxbnFrZVBqYWY4?=
 =?utf-8?B?UWRPdFQ3Ukp3aDk5OVRnb1R1dHNCMjVYSTRjNVlVcG1BMUQ4WXRuYUgwQW1a?=
 =?utf-8?B?VUtEcVVXbVJRQTdscjFzUWswNFZUbERlT1VpanVvaEl4a3Q5dkpYSzlVdkNj?=
 =?utf-8?B?ODNoT0dSa0trMW9yT056ZjdKNzFsN01SY3VpWThQRWhnKzZ2RG91SS9oSXFK?=
 =?utf-8?B?MnlZaUFOOE9CbERuVFBFQ3h6aEIzRGZ1SUw4ZkF5VURPTEt4VGYzQkQ2NVFE?=
 =?utf-8?B?bjd1VlZpMEEzZWtvSkVmUGZzeTVjTG95K0FkZDBrTUROZFRxQkg3azI4Y3Jm?=
 =?utf-8?B?UTV4a3ROVS9qTEpEQ1RidVhPZGs1N3pyK3ViWlZkY1RtT2RoMzBLNGdpa0hO?=
 =?utf-8?B?RlVOQ2p4WFB2OXMxMjJyNzdUZzlGKzVpMW80dXc1WWNPUFRWSkR1YVY5bFpi?=
 =?utf-8?B?NThYSDBORGRNWlpabHNKWVp3bmZsQ0tqRlJUU1BDdTRkL2FnTDVxVWFZZjdT?=
 =?utf-8?B?TWpqY2tpN3dTbXdpYldCd1BKNGlIWmpLc0dYU0hwajIvTS9Ca0QzOGxYS2J4?=
 =?utf-8?B?NzBhN3U4M3RlQXZ3eC96L0crN09jUGk3RGJpa2dHRXg2VDBRdkEvd1h1WE1y?=
 =?utf-8?B?OVpNa1lOdzdMcWRDdERJZ0JLYVdLSVpCOEN3ZjRXL3RNZDZ1QWVXYkIwMTAx?=
 =?utf-8?B?ZWFLVHVuMDZTUG9Ha3hGUTlKbEJXNzk4eUs5akFsM2R0cTExc0RYS3BUZ3RY?=
 =?utf-8?B?ZjMwdGNNWVZtNXBZMUlzOUg4SFVVRkJqcUNkOTFVQXMrSEZBV2tjUlpoWlFw?=
 =?utf-8?B?Y1IzQ3NDL2RaV3ZGRkFjcldCVFZpdmlEdEk0N09DanRmWTNvS0VSRUIwakJR?=
 =?utf-8?B?OW5wQWViTnU4azNYeThldy9iWlZIeHd3NGdNbVh2L1BCTy80VmdWRVkrQzVr?=
 =?utf-8?B?a1BxZFQ0dDkzSFFqYVVwUE90WXpWMmVXM1h0UU1XUzV3UjFnRXYzMDR3dERL?=
 =?utf-8?B?QkhZRFJsY2pvcVYvN04vbnFpdXZVem9iMTBXcjVoazBGVHhDWGVBWHEvbkdy?=
 =?utf-8?B?TnpoVCtVWGNqbHVjR0FOdVROYmc4eDBLT1FqT1NpanF3cGJ0cDkreExMWnlj?=
 =?utf-8?B?TVN1VjVmWGJWVEgySnlmRWNIcTI3ZFowODZGNXRiWGF3OSsyRk1NckFvaWox?=
 =?utf-8?B?ZGJ1dHQvSmYxQUVZcGdNelFobVZrY1FCRVFKQm5ldG94WkJWTDkydXVpZ3Ju?=
 =?utf-8?B?dVQ4WVZKUHhGeE50YjExT0N3WDViZGdVbjNwVzhoUldvREZPVEZTTXg1aVRi?=
 =?utf-8?B?dFQ1YVNoT05MWFFac2JhdjlwUUlSMFo1QlJiS3ZmRE5US0pXTmY4cUdPcFlO?=
 =?utf-8?B?NVllRHRxZEhlMnZkUS9HbUd5UXk4aGhpVEtMR244Mm9ST1B4WVdXYjlaOUJS?=
 =?utf-8?B?eCt4M1h0ZUpNenVwTlpTZVJoVGZDb2E1aU9hSlJzOFdOYTRwc21xVkdFVXFj?=
 =?utf-8?B?YVFVZ3NSeU1lSU9NZlg3SlBOcVRXQW1za0tmSHRpN0FQdXdUU3FtL1JMK2Zl?=
 =?utf-8?B?TjQ4N2FJRXdXdFJvamNmak1EaWZSeFphakVzU0xoU2xLLzhTZ0tnQXVTK21G?=
 =?utf-8?B?R1FJd1ByMk1ZR0dYZmNWbE56S0VRcVZncXVNTWQ1dklHamM0aGhRQU5kUEoz?=
 =?utf-8?B?WVpzdUoraDEvZTgrR2dEczBnQ2lsSExHbWhoS0lia2pYNk9lYm1yd0NIZXJN?=
 =?utf-8?B?em1MR0REV1orK1d1dGFJV3g0eGFLeVBKNGFrWnYvNmZDQ0YrdmRnMklwb1hr?=
 =?utf-8?B?NHBtKzBCRC91blVxdDkwaUtnUTUvdUlLQzBGYm8wdVRrUjd6MmNUTnM2Q0h1?=
 =?utf-8?B?VlNTZjdwUDk4UDNqZnNtNnZWd2txaUpuWmVwY0IxMnorVi9VWG4yM2F5S1hh?=
 =?utf-8?B?aW9QcHkvUXpnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2NFRjBydmhsa3J4VGlGaUsrN0d6ZHRaU3o4ekQ2NisvUjd6bTViTndvSVhj?=
 =?utf-8?B?Z2JQSHY3YzdHSU5GRklVTGZGYm56WWlHQ2Q4aXhEZFFWazFNQ2pDZ0lJMkZ3?=
 =?utf-8?B?d2dOWjhVNGM3NVJIdHhnRnhka2dhMWtYK3RudUxPckU4WGtQZ0ZIeGh6NXE3?=
 =?utf-8?B?cGExZmNNU3JDREpJQ1ZPVVBKRkt3VVcyMGp6bDlNejZERUg5MGJhZ0NzSW1Q?=
 =?utf-8?B?eHE2OHVhYUlhWnJnaUcyZE80d0wrb3RLUjZBR2R1bkdITURpQW9zb3JVRzJx?=
 =?utf-8?B?eGVFRW1KK0hydnpuTFMyanY2bnA5Q05QNlliYUU1R1hBSk9QMUtXaVZ5MlJG?=
 =?utf-8?B?QklmRUlRck1JekVrcks0NG94QkpKekZlaHJHOHEySExDcnNOZFRZWEFGZGgw?=
 =?utf-8?B?MzhJUXhZTTZFNkI0SXdiVXZNcngweVJuUDdOTXFpbGdSWmROUzlCNHZOQ2pr?=
 =?utf-8?B?MEVsUE1nRjJ4cHpwckNjNHMwTGpQQ05EZ2N2L2pCcHB1bEwwWEp1dFU1OWZj?=
 =?utf-8?B?L3BxdWdoSGkraEZmdlgzWkpJSG9KUW41dnFRb0kyOExIMUcrZ0JmOHFoWU53?=
 =?utf-8?B?Uzk2S3lSbCtVNk5md29nRjhhQXM5Nm5yU1U2cGIrbW9OU3JROXd2bmRNMkY5?=
 =?utf-8?B?a1ltdDM4Q2U2a2FRaU9UMFBkaEV1eWkwQzZjTjZaVGlsSE9EdWhyaC9IeFBY?=
 =?utf-8?B?aWE0OGlzOWQ4OTZtVGpuRGxlbEgrZEdydzJ0YmhEVDR6QkIxVk8rZHAvOG16?=
 =?utf-8?B?d21HVllwcS9XMDhVNEF5VE1DR3hNbGswak1mZjlTMi9BZ1o2ZWVNa3luSktG?=
 =?utf-8?B?aTFRWFVTbnhkQkgxZGx3OFhkQ0lJcWdOWDFIV01CemQ5L2dqdXhzSEJaS3V1?=
 =?utf-8?B?Z2VaYit0SjAzT3B2QUlqMWlObkhQOWovN0RSeFE3R2U1TURMRnFaLzNsVUdV?=
 =?utf-8?B?SGNKaFFWRXNRV1RWVEVFbnB3N3J1UlMzU21aTmdlU2ZveC9qUVg1VEFUSElT?=
 =?utf-8?B?clJUNmtIdnpOWEllUkhveHNIcEdjcGc5dTVjd0ljMlJYUUw2MnJKd0RsOVdI?=
 =?utf-8?B?UVJrOHZxZm5Eci94TTFxRDl6S1Q4eTErY2p0aTlSOEtrUTV1SXlIVDIybWdC?=
 =?utf-8?B?dGRTTzRJcExNOXF1MURHZkpwTlBlUmV1ZTVqUzRuWTVqOWNuTFFpT3FvTDhN?=
 =?utf-8?B?NUxCcDRYM3NKMXhLQ3RiUG5yaUw1WlBPeTgwTk5OTUg0dEJiOU5JOWN5Y3dC?=
 =?utf-8?B?R2oyUzMrdlQvUjBHcnZqS0F0Q1c0OEZxQzFYV1FtQ1pwa3dSVlp3N05UbzFu?=
 =?utf-8?B?MVVkbXZ5L3JjRFBMSnRlN2puMjlMTUZEODFHWlN3cVJHS1U1L1RTVmpuenQ2?=
 =?utf-8?B?T2pRck9obTY1UUY3VDFuVnRKZ2lNVlFTUEx5aTNhLzArYnl2RHpvMWtQaUlj?=
 =?utf-8?B?VjRXTWxjSld6NUpBVWV0NVNUTlk0aldOeDNmUXdScDlmSVp6aWorOFdUM3dz?=
 =?utf-8?B?ZWlnNm9Ld1JqdE5NcEFwS3M4WElHc1RKTUFvVm4wZWlDQjVUSmFBRC9zWnhI?=
 =?utf-8?B?S2QyQmF5QzZPLzZNMzYzMjRiTG1SaS9La09FaytLT3d3RFNkMjNGK2VFZUhQ?=
 =?utf-8?B?c2FwTE5uQzNHeWxVWWZucUgxcG1XT29IeGpnazBRWnhsSXRzWmlzSEFNcW9t?=
 =?utf-8?B?WUtVOGp1Mm1JVTYxR2ZLSUloY29yUEZ6VTVhc2JRTmNwQzd4UldWWExEQzJu?=
 =?utf-8?B?RHVyeUxSYlE2QzZyVnpEaW54MHZQOFoxS1BNVmYydGZCWVppaElabVR3QzNZ?=
 =?utf-8?B?ZnRLQjh5SHJEeW9OVUF0UXR0VUFnWENYVEE3dGV6b1o5TnFhWXd0OWdHU3pj?=
 =?utf-8?B?VWQ3MGVOeUtYamtBL0tZWGducXlDeVFkUzh5UUhiRjQvODdZNHllaytyQTNR?=
 =?utf-8?B?N29ndVpZbGkxZHhtSzUwSDJzL3lMbmZWYUlkSXk5Z1BQNmNPRkNrRUZtbzV4?=
 =?utf-8?B?OEpHWVI5cDg3VHQ5RDl4d1YrT3dpeFFjQWFmUVRpRHAxcjJDRmJNaGhDRi9W?=
 =?utf-8?B?RTRYNUszTm1JbW5Vc3JNdnpOTVY0ejBjWjlYN0JrNks0dUtGTzRaTGkydUd4?=
 =?utf-8?B?elh4bkJqeG11RVdkVlpCSXpwQzFzOW85K3lnTExjTmxYcTF0NUZCNlJVSkYx?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49986c30-7abe-478e-48e9-08dd8de0ae5f
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 03:30:29.9931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPHRx+UdDDe8A6NYrkkHkEXyNDLifM3p+5yOEUQ6bxGwYdltQBs/RhCWTJ6W6uzFRGF/yezGxkbv2HEKzn8R20grY4apbi8QZ6MxTNUidW0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7518
X-OriginatorOrg: intel.com

Hi Tony,

On 4/28/25 5:33 PM, Tony Luck wrote:
> There's a rule in computer programming that objects appear zero,
> once, or many times. So code accordingly.
> 
> There are two MBM events and resctrl is coded with a lot of
> 
>         if (local)
>                 do one thing
>         if (total)
>                 do a different thing
> 
> Change the rdt_ctrl_domain and rdt_hw_mon_domain structures to hold

rdt_ctrl_domain -> rdt_mon_domain

> arrays of pointers to per event data instead of explicit fields for
> total and local bandwidth.
> 
> Simplify the code by coding for many events using loops on

"Simplify the code by coding" seems redundant, maybe just "Simplify"?

> which are enabled.
> 
> Move resctrl_is_mbm_event() to <linux/resctrl.h> so it
> can be used more widely. Also provide a for_each_mbm_event()
> helper macro.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                | 15 +++++---
>  include/linux/resctrl_types.h          |  3 ++
>  arch/x86/kernel/cpu/resctrl/internal.h |  6 ++--
>  arch/x86/kernel/cpu/resctrl/core.c     | 38 ++++++++++----------
>  arch/x86/kernel/cpu/resctrl/monitor.c  | 33 ++++++++++--------
>  fs/resctrl/monitor.c                   | 13 ++++---
>  fs/resctrl/rdtgroup.c                  | 48 ++++++++++++--------------
>  7 files changed, 84 insertions(+), 72 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 3c5d111aae65..cef9b0ed984c 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -161,8 +161,7 @@ struct rdt_ctrl_domain {
>   * @hdr:		common header for different domain types
>   * @ci:			cache info for this domain
>   * @rmid_busy_llc:	bitmap of which limbo RMIDs are above threshold
> - * @mbm_total:		saved state for MBM total bandwidth
> - * @mbm_local:		saved state for MBM local bandwidth
> + * @mbm_states:		saved state for each QOS MBM event
>   * @mbm_over:		worker to periodically read MBM h/w counters
>   * @cqm_limbo:		worker to periodically read CQM h/w counters
>   * @mbm_work_cpu:	worker CPU for MBM h/w counters
> @@ -172,8 +171,7 @@ struct rdt_mon_domain {
>  	struct rdt_domain_hdr		hdr;
>  	struct cacheinfo		*ci;
>  	unsigned long			*rmid_busy_llc;
> -	struct mbm_state		*mbm_total;
> -	struct mbm_state		*mbm_local;
> +	struct mbm_state		*mbm_states[QOS_NUM_MBM_EVENTS];
>  	struct delayed_work		mbm_over;
>  	struct delayed_work		cqm_limbo;
>  	int				mbm_work_cpu;
> @@ -376,6 +374,15 @@ void resctrl_enable_mon_event(enum resctrl_event_id evtid);
>  bool resctrl_is_mon_event_enabled(enum resctrl_event_id evt);
>  bool resctrl_arch_is_evt_configurable(enum resctrl_event_id evt);
>  
> +static inline bool resctrl_is_mbm_event(int e)

This looks like a good time to change the parameter type to enum resctrl_event_id.

> +{
> +	return (e >= QOS_L3_MBM_TOTAL_EVENT_ID &&
> +		e <= QOS_L3_MBM_LOCAL_EVENT_ID);
> +}
> +
> +#define for_each_mbm_event(evt)	\
> +	for (evt = QOS_L3_MBM_TOTAL_EVENT_ID; evt <= QOS_L3_MBM_LOCAL_EVENT_ID; evt++)
> +
>  /**
>   * resctrl_arch_mon_event_config_write() - Write the config for an event.
>   * @config_info: struct resctrl_mon_config_info describing the resource, domain
> diff --git a/include/linux/resctrl_types.h b/include/linux/resctrl_types.h
> index a25fb9c4070d..5ef14a24008c 100644
> --- a/include/linux/resctrl_types.h
> +++ b/include/linux/resctrl_types.h
> @@ -47,4 +47,7 @@ enum resctrl_event_id {
>  	QOS_NUM_EVENTS,
>  };
>  
> +#define QOS_NUM_MBM_EVENTS	(QOS_L3_MBM_LOCAL_EVENT_ID - QOS_L3_MBM_TOTAL_EVENT_ID + 1)

To prevent possible future confusion/churn while making existing code easier to read,
could this be "QOS_NUM_L3_MBM_EVENTS"?

> +#define MBM_EVENT_IDX(evt)	((evt) - QOS_L3_MBM_TOTAL_EVENT_ID)

Naming nit: I think "MBM event idx" is close enough to "MBM event id" to cause confusion.
How about "MBM_STATE_IDX"?

> +
>  #endif /* __LINUX_RESCTRL_TYPES_H */


...

> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index fda579251dba..bf7fde07846b 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -160,18 +160,21 @@ static struct arch_mbm_state *get_arch_mbm_state(struct rdt_hw_mon_domain *hw_do
>  						 u32 rmid,
>  						 enum resctrl_event_id eventid)
>  {
> +	struct arch_mbm_state *state;
> +
>  	switch (eventid) {
> -	case QOS_L3_OCCUP_EVENT_ID:
> -		return NULL;
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_total[rmid];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &hw_dom->arch_mbm_local[rmid];
>  	default:
>  		/* Never expect to get here */
>  		WARN_ON_ONCE(1);
> +		fallthrough;
> +	case QOS_L3_OCCUP_EVENT_ID:
>  		return NULL;
> +	case QOS_L3_MBM_TOTAL_EVENT_ID:
> +	case QOS_L3_MBM_LOCAL_EVENT_ID:
> +		state = hw_dom->arch_mbm_states[MBM_EVENT_IDX(eventid)];

Please add a "break" here. Although, I find the resulting get_mbm_state() to accomplish
the same in a much simpler way. Why did get_arch_mbm_state() and get_mbm_state() end up
looking so different?

>  	}
> +
> +	return state ? &state[rmid] : NULL;
>  }
>  
>  void resctrl_arch_reset_rmid(struct rdt_resource *r, struct rdt_mon_domain *d,

...

> @@ -346,15 +346,14 @@ static struct mbm_state *get_mbm_state(struct rdt_mon_domain *d, u32 closid,
>  				       u32 rmid, enum resctrl_event_id evtid)
>  {
>  	u32 idx = resctrl_arch_rmid_idx_encode(closid, rmid);
> +	struct mbm_state *states;
>  
> -	switch (evtid) {
> -	case QOS_L3_MBM_TOTAL_EVENT_ID:
> -		return &d->mbm_total[idx];
> -	case QOS_L3_MBM_LOCAL_EVENT_ID:
> -		return &d->mbm_local[idx];
> -	default:
> +	if (!resctrl_is_mbm_event(evtid))
>  		return NULL;
> -	}
> +
> +	states = d->mbm_states[MBM_EVENT_IDX(evtid)];
> +
> +	return states ? &states[idx] : NULL;
>  }
>  

get_mbm_state() above for comparison.

Reinette


