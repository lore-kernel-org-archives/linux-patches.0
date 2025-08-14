Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0374A274FC1
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 21:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755208627; cv=fail; b=XGBSm6jTe+vxEdc9hWKfjr4J1xwwryuLqrS8CFNLDG74wiMkPHu+6J7OOxVd5N8Wghh3wA8q8RvoqlR2S+n68wRED5wNuCSTs9K8Lu12w4kWRF5Sf3+qfo1zqgvxJgcCUnA4//OMJ+/z6mG+3i/xkuxdT6Nkilr+YWfXSNGsyxA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755208627; c=relaxed/simple;
	bh=NnJEAJrUMvxiWd4pD0Zd/5YEaHqUSt1qht4sMbngWJg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BszQI/t8AOx9D8anZO19/iPPsaEwjXeUM3hUZIYP5EqT+XDhIVivM/WpYMWotc5/Cnyc83ZS9QUMIHCU6OuO2J8ZS2RZRjofQmgDbYuOAbJHBKjcy5WPNenXFJIhOfP7tdB/NS/7rySmqQVFLEA/hi/iHM6Ld9MWWceWczQTMpk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lb+1awWj; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lb+1awWj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755208626; x=1786744626;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NnJEAJrUMvxiWd4pD0Zd/5YEaHqUSt1qht4sMbngWJg=;
  b=lb+1awWjkwooxfBZAiPLEYkS2o2YiUEn4/WXUntr7SFQmeZfvIgiZkRo
   Nuci7Bw8sikOyg/iT2JP7bF9SK10IkPhjuR1jFTUWHOHPOE/hvJepucJO
   wDrBehA+yv7SjpuKhTIwuT0iUGMjbWxQAj9dCYkCosHQpm72GFovEn/sX
   RUS4Qq7LlsiZAFfgYCK3HDQ9WvBF19xgUXTKboT5l1qEu2iJaO3FJpXCz
   rviecxlVeXer6JAuS9LJA7TWjoyP2WJoiBfzcRu0lre7Njg+36Vp7lzcy
   ZJ8WH5L05RU6I3pkrKUd1BsCaIYlL+EpDZWXI9hkiMDDSf9Iwy0tSNGKb
   A==;
X-CSE-ConnectionGUID: oJPe7dYRTsODMNNr6AUYng==
X-CSE-MsgGUID: wbJzJwLUQFS25yS8X+tMLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11522"; a="61379604"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="61379604"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:57:05 -0700
X-CSE-ConnectionGUID: Fu/s3caKQKGobhahSEOeDw==
X-CSE-MsgGUID: Uy6yQmONRGG38ejuX70FRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="197859114"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 14:57:05 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:57:04 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 14 Aug 2025 14:57:04 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (40.107.100.64)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 14 Aug 2025 14:57:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dMnkrAQdlzMxn6bjjLxS2vNWSipFNOP1d3i9nmj75LAHeA9e4yPRstNQHtoFUCgfhEdwImpgmANwNmHgOs9geAPe11jceCYIJ1Gzfh1RcyWIWUb2zV4cJyyRrdH6IP42Eeo+dbPzViGVMJi9jWJrcbuVDB0DaKc+xcUNnP8ytuLce/t6RpFw/cD11Rj/56eR7/80TYvi9dqh/5Nt2fQ+GJY29gDXTDLde3RJhGXCUuBkGK667fTm4a0TVvSPRyGcDwgAE3lvwsihgVokGrre8CJhlFuco4xbYcr5eVSKBEFGlO8s2nJReoLVvY8+brLB6CanWWaNbWkpjhLiXhFENQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnJEAJrUMvxiWd4pD0Zd/5YEaHqUSt1qht4sMbngWJg=;
 b=gieSDfd7svaH6rWzMXJX+S6LuPEasQkZQUVB+U0XRH1HZCObHZz9My3+/CwOWa3MXtKqlAKaM6A88D4i+BoJt+rLuNfgDtw09k23EltNcMm0008PS17ZrJofOcFOFc+FgZ8Nv0OHVn46x4WIkNaTf1bHslz/W9Nc6W6fTRkNAQ7XwdaS1IMxA71RqaGg4Eewb7xKFFz0mvVPeryeYzQpcUvVYKqSD/hux7Mz6ZsH8uveHOL0Y8V0jKAe5FickVi9eFBGfiKrjzJuVq8x0NMMSRtM312+/xbFnvJsUQGJ/cS0GkC2Pm+ChaAV7WXPs/JgPzcPASaP7KUPOSCGIBRiXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CH3PR11MB8467.namprd11.prod.outlook.com (2603:10b6:610:1bd::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.18; Thu, 14 Aug
 2025 21:57:02 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.014; Thu, 14 Aug 2025
 21:57:02 +0000
Message-ID: <ce8d5e09-9411-44f0-a486-d4420c14cc51@intel.com>
Date: Thu, 14 Aug 2025 14:57:00 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 29/32] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-30-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-30-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0322.namprd04.prod.outlook.com
 (2603:10b6:303:82::27) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CH3PR11MB8467:EE_
X-MS-Office365-Filtering-Correlation-Id: d89e73bd-f7ad-4d90-5e7d-08dddb7d8003
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V3BBL254Q2ZtcEZVdHlKN09lcmRuRGZFK29WV2J3NGw4TlNQQW44dEYyd25U?=
 =?utf-8?B?a3NpeVVVRkRVSE1SQ1ZveEdnZWJ0N0tmVzVwSWlxNE94TzN5Q1VxZzRKbGdK?=
 =?utf-8?B?ajJ4Qk5MZDFta1lHVUxVT2daZnV1c3dhVnlkd0gwV21ncjlwaEFYakI5L3VL?=
 =?utf-8?B?MlJ1bU85N3B2OUhEYktaV0dtMGFFbGJacS9DSHlMeU4ycDQzc3MxYXh3YTdz?=
 =?utf-8?B?WjR0bkRXWk4yYm9wSUpGSmV6R1NXVlR5NkZEWW1ZS1I4RkcxbTdvOWhNblBu?=
 =?utf-8?B?OVdZRHpMRmM5OTJPZno3STlZU01vS3JpMmwvYktyQWQzYkJkZVhOYk5WY0lS?=
 =?utf-8?B?QllkZWhhVEFLdk85aVpNaFEzTEVjZWJhMDFEaS9HRXN1VndnbTFhM3RrV0F0?=
 =?utf-8?B?VXc5OCtFd0dKUU1mT2ViVDNvcDNyUEZyS2NlUW00N0QwLzRRanFyTkNzS1d2?=
 =?utf-8?B?SHNodWpNelU1QXZCejJJck44S0FYK2dJN2N0Y3JSQ2kzREt2eldHYUV4TUoz?=
 =?utf-8?B?TloyY0RJeVBNLy94bHdsOGtjRFNHLzhlZlhhUzQ0YjFtR0cyZWxrM1BUQ3U1?=
 =?utf-8?B?bU0vS3RnUEVQeUlyaXc2RCtBK3ZTZ2N6Ny96MWthRXo5dmNRaHZJQUIzaHdi?=
 =?utf-8?B?blVrYmtjRm11bDFyZ3VCR21IK0E5WEQxaHRPOUwxZ3BuSm1ZY3FGSGcwb3Fv?=
 =?utf-8?B?bDRzKytReUZIRWNMd0VKajN1V2hILzFQbHZlNlcreGVML1hsbVdvMVhvelky?=
 =?utf-8?B?R1BwSUZjaVFsKzlOdGRINDVmTGdzd0RpcjUyeVNRVVkzdDJVdkVHaEVtUkJD?=
 =?utf-8?B?dTdWcDBXTTY4U0k3OENrb1NXWmNaN3I3VTFxa2xKZE9zZi9LS1ZybnBRTU1K?=
 =?utf-8?B?TWJtbkFCODlFTjJMbGEvVHdaOG1UV2plalk0cDNUREZDVEdBVmJuWWZkU1lD?=
 =?utf-8?B?M2pHNG1KRC9XNnZsTjI2YkFDWmNneTJ3Mmt0WGJ5ZndTaUl6clBSYW5wR0JT?=
 =?utf-8?B?RERJeFhsV1p1eFpxWnhqNzJPaHM4aTRxV3RZNDJiOUlVbVFYWWlkM203SlNa?=
 =?utf-8?B?TWtBa01QOWR4KzF1OFBXWWtITmZTM29OZW5uYzNrTHZrRjlteHg5dFhnci9R?=
 =?utf-8?B?aExrREtnL0hIcHZUZnBTeWc4MklUNjkwNlo5bXpIbnpMTkJVVnhKOFlBYWx1?=
 =?utf-8?B?ckNwVnpVZUZmbDhQMEQ0ZThjOEUrMEhPbXpmTnM5RTNEbkcxWEYyS3pyOHFa?=
 =?utf-8?B?MWFyWndSN01nL3QwVWZrdit0a3dobVkrVzJqb05HaTBCR0RUOUZoc2tPcWY0?=
 =?utf-8?B?bnlOR21CVklzUHFuOTV6RWVtY2FMazdwTjZLeGZUNVhndnd0ejBKV3Examlr?=
 =?utf-8?B?WDE1djV1ejBsSUlIY05oR1VOdEFpSVJQd2xIM3VIdWpBMzlzQkJMZGNMb3Bt?=
 =?utf-8?B?ZXI3Z2x2TWdLMjZwVEFZVE5saE0wSnhzUEVoazdKNkhqMncySVRkaWJFc2gv?=
 =?utf-8?B?bkh1MjlaRk1uWFgxMFRMemJkOEhPQ2RCb2tEYnpETWFmRlRBRm1aR0FDSlZr?=
 =?utf-8?B?dExyYmZMYlR6MEhmSmsvREZxMVBhdXE1WnhQYWw1WUI4S1U4bFErU2dTSUlM?=
 =?utf-8?B?cFhIemdLcUhpejllUFMxc2ZyYlVodDZXZDV2QWgvLzdSTmJZaDk1cmZvZEV5?=
 =?utf-8?B?MFpMMTYwQkhmQ0JKMHRKcmpTUUJtaHRKWDRMRmRPUXBXQ2x0ZFdSc25QZnRJ?=
 =?utf-8?B?N0lVTWNybGUrYXRXa2x6eVcrMzE4dFVmeTFwSlg3VHhDMXJWbUtZbGNCclRU?=
 =?utf-8?B?N21EL05rWFdKdGtLZlhQamZIQ1ZEQU03a0dsY3BXd05YWnNOZkhFNldROS80?=
 =?utf-8?B?djZTQXN0c1ZMM0kzWU9yMGdEb1lCMWhqMUd6YlkrUGsyT05Ob0hpSGFDQTlC?=
 =?utf-8?Q?YGwV6VQOSYI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bURqd2pIQVhXVDU3V3RKN1d0Nzh1Sk5yYTh5aEI3YmFncFR0RGdWVk1QbjUw?=
 =?utf-8?B?WjN4cGIyakVBSjI5MThVOEN5MEc2c2NBT1cwcG5MaHhjYmJ1Q2NkWFQvZE9W?=
 =?utf-8?B?RWlNTWI0OUZwRjgzeUE4aHFZOHFQclc5a0NudTRqeFY0MDFubStrOTIzaFVN?=
 =?utf-8?B?bWliSjk3ZzY5RWpXeG12WXZ1bGtBd3ZCL21SQktpajRiNmVQdGtkR3duODUx?=
 =?utf-8?B?UlRkRWFqcWc5ZzEzZkNxcHQ0cWRwOUdQM2dPN0JFR3FQMndjemJ6UTZXUnkx?=
 =?utf-8?B?RitJV2wyZnVlSWNsRmNHT0lQQ1N4TWZZWDRhbWF6QnRWN0RVU3lDNlRlVWkv?=
 =?utf-8?B?MmZVZ1F3c2lsRHp2TERZd3BFMEVETEhTSGFEZmdYQjQ4RUljM2tpR3B1RnRv?=
 =?utf-8?B?dHlzYzdqR2RaRUM4WlQxRU5FTjdvR3VNRGxRS0h5eE1yNXk5RVVEVWQyZlp4?=
 =?utf-8?B?T2gxZVFYVEdMQ085ZWtERi9SOEVKL3JDb3ErcUpRTTdNOTBzOCt6Mno4V0hR?=
 =?utf-8?B?Zmt0SzN5UnMrZUZwemdqVWU0bXRiVjlWMUgyb0Rsc2Y1dHB4dDFoQWhBcWpm?=
 =?utf-8?B?cXBRNVAvYjJWdWxLQ3JyTFNyRFZHTk1qQnZ1MlVTblJ6dEJHeEE3Z092MmNH?=
 =?utf-8?B?RDgxQnhkdFZDR0Z4eDNaRm1FdkJWcjkwUXJNd0NsY3F0SHlpYlZ4M3YwUnVa?=
 =?utf-8?B?ekZRQ2U0ejlGZkFKLzBDUmNRM2orNnFOWjhiaGlrT1I2VVFza3NMc2UrS1Nk?=
 =?utf-8?B?b0RzZDkxd3VGS3pGVi94aXZwdStpYlNXRFdpN2xZcVl0Q0JmbEVQMzcvNXF1?=
 =?utf-8?B?SStqeVRzVGlyYVlqL05jbHZieDJ2eWc4N1dLRmRlRjN2QnhZYlFFL016ODJm?=
 =?utf-8?B?VkU2UWxEdXNZTGhyU25nbVZiOUQ0NTJxK1Q3S1VUL0VxczNnS1JtV3JkSjF4?=
 =?utf-8?B?UVBNRDRhOENHbGN0VmNERjhzS0ZNVlp0K1lPVy9HZ3o4a1Azcm1qRUpzYUZX?=
 =?utf-8?B?UlhpajhWVit6RlBaRGdWamR6bGdvdFBaa2VObHc1Q2EvU2xyYlBKRzBwTXE0?=
 =?utf-8?B?UGlJTzhUWXNwWENYREwrL0c4OW9PVEpzWXkxd2tzb1A3c0pTQkdGWWsySit6?=
 =?utf-8?B?TXNSNUZEZ1JmZjhZK1FWYnVQS0Zmb2pGZ2xqai9XMTNSdWRvbWRyT0c2VVZq?=
 =?utf-8?B?R2Z3N0hBSExKMFZ5WEd4aXR2UE9LTDB5NW5KODNxNlZnajNrdmc3VUxUTWFj?=
 =?utf-8?B?Rml3djdmelBOd29rMXg1QnBCclk5Wk5MZ1JUckJqTWRpMlBXdDI5cGRMOG5W?=
 =?utf-8?B?Vm04UzJlcXV6ajV6WTJlWGNKU2wwS3NvemJ5M3A0OERKRVRHemNsYm1UWVU0?=
 =?utf-8?B?SDV1UlhYTXBkTThTTzV3Y3VKWFNibUVrcFZVY3pzd2ozVW83Z0ZBaEJZYTJ4?=
 =?utf-8?B?NDZPSVNPRVExaXlvNjV0TU5aNlMxcitDQmd3WHFrSVdZVEFWdGhueG43R21Z?=
 =?utf-8?B?NXNLUHZ3S1UvYmkvMERldXhNZ1k3VmsySDRTeFdyUXVISnlnN25YRUdXVDlO?=
 =?utf-8?B?Nmk2K0kwQVNwTURTTWdnNkorZTZNMEhFMlloVm9oYnZPSW11Y1kvYzdoVG90?=
 =?utf-8?B?TmlyUWFacHpHQ0Y3RzJKRmNpWnJEVGEzRXFUdlF3aXhlNEQ2Z3NoZmY0VGQx?=
 =?utf-8?B?U3BQNnRoQnJJMWFuUExtVkFoMFIyMS9HN2NTV0NVWGV0WDd4eFYyQk41RG1C?=
 =?utf-8?B?OG5CR0J1RGdwc3dKRHptdXMwSHdQdlh0YnYyaVRlYjhyVUFiSk1pelZqWVlv?=
 =?utf-8?B?UUFRMVhheUhTYmlHWnJZM0UvaVdsRVhnOENCcDl3dUJnYTNiUmlkeGdUWGJs?=
 =?utf-8?B?eVJWM1VCMEhpM09nVXA5UVJkYUVHV1B2RmRyUkJhWG0vQXRXc1F3QWZrU05R?=
 =?utf-8?B?YTNRTHZRSnpDNW9lOHdpamJuN1Q5dTN0MlFoVUdneTJkcnIraWxrNzNGdnFY?=
 =?utf-8?B?cU4zYTZYbytNdERJOVZLNXY4S0o3S25HNlYzNWlBUEhzVmdzNnp0TDdKTU9a?=
 =?utf-8?B?V0hoemd4a1RjWUR3OEhsOHJqdUFqZG1CdkdTNHNvRHc0ek92RUQ5WmlTcXlB?=
 =?utf-8?B?OWhuNXR1dUsxckZYTk1RQUdLMlRlMzBiSm16N1oyMDgvZjZCR0JCci9vWVI3?=
 =?utf-8?B?a1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d89e73bd-f7ad-4d90-5e7d-08dddb7d8003
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 21:57:02.3134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NNgz4duBQr659asJbKEPCfCkBN0t+nLwje1X+NEr1maKmtYPcrd1czPZiXiGRxp+uEu0A/HRutlx2PyYjycZJ4xLGyJq7aNO8bh7Qfq/OvY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8467
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:17 AM, Tony Luck wrote:
> The RDT_RESOURCE_PERF_PKG resource is not marked as "mon_capable" during
> early resctrl initialization. This means that the domain lists for the
> resource are not built when the CPU hot plug notifiers are registered.

Please check series for consistent terminology ... I think these
"CPU hot plug notifiers" may have been called "hooks", "callbacks", and
"handlers" through this series.

Reinette
