Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33CBF227BB9
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 23:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783468503; cv=fail; b=jqrSKFAi22v8DCDUAMGLvKIK8rQMbVR2sg+jjC74uIEuBMDPqhXaj7Mor2CKvmy8H2c4+ttRk87vRfKX/uUoxP9gLiTA/rGx64rNvnZ3gbN2Vyp8gDP/XNnMfpNukjav1Byp6Bz+vFbCCKC9iSCaaUCe190rRwBlFsIT5w4Cgfc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783468503; c=relaxed/simple;
	bh=X1jzSpWyBTW4SZYC8mOmdFXMvKJY01FT1bAxc8IWl18=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Kz9IyY0gkXCZO1UaYRW5X2Xi2y0NuuHuoU5MlglyYqdlI90BDmD7d3rGFGTQt8UStWDwQHEeBtxODGwEqmxa7WEsZ7PJlFTztFOxqh/6TwX0xVtass1rGPLA6tbF+8Dgpg49IKv05o+ruOTHzETglDwbODbAsCP7CI2IVa+KDBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2XMhghr; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2XMhghr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783468501; x=1815004501;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X1jzSpWyBTW4SZYC8mOmdFXMvKJY01FT1bAxc8IWl18=;
  b=O2XMhghrlMBlIKcDdJxXYP+Qito0rzVjwjCP94uS7PJaQHiYa1k7b7h7
   drnPACtjExtr9xmLoWJrshkBPCOkW5+SwJlecMEA0J6chDOONSbtYbXHC
   qC0Tw6+dc81i42Wh+Iq2K5VtIb5zH5ZMhs8sDNYnY+ioKnBz8yTF+FJvi
   c385BYaVs+mS2BoUn2V7My2smt6egQTE/BsyJjmiupI/ZTJC790Wu5uY4
   lif2SpQpCnAnvYDVh78L5k8mkI9edhLIDlOoYCEanYl462k96F0Sm9qXY
   cuuCTfCnCS8T8XrqYmwHDYA39M34KoV66M2nlES+VJGNj+I1qnU8w0kgV
   g==;
X-CSE-ConnectionGUID: WvqN9zOYTOq8MeLLRKoAkQ==
X-CSE-MsgGUID: XBNH/HcpR8qELCptr25+Tw==
X-IronPort-AV: E=McAfee;i="6800,10657,11840"; a="94769513"
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="94769513"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 16:55:00 -0700
X-CSE-ConnectionGUID: 7/ujxcv9TDKBmBwAaixGUg==
X-CSE-MsgGUID: H6/Mc76nT9ikEviGI8TEiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,153,1779174000"; 
   d="scan'208";a="247748904"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2026 16:55:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 7 Jul 2026 16:55:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 7 Jul 2026 16:55:00 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.46) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 7 Jul 2026 16:54:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g6a+lvNmfihoDILO+s2KLkmm1t4vC1mW9w4CCpRXqjKtj9k6ppG8kuTheev/QFPKFG2oVYAhcPaJ/QOCjD2pC4LBYrc6lX5XTEI6PZmRVD73lD1ESUycl58lKaH3vXyGi4I4EfZWgJ0bmaTI0jxQwjeTkEAi3Rn1Z09aAWj/xjnyILrBPt2WDkjJtIFUzFOeUcA32CbTGncyYVfTV0N7oPCDFhYTXZ1B2XivT07X7gOzeOyyB1e4e4CmgtGa3ZAw3X90MvE0nEs/kI4vO2Kyk+fX43I/dEWqnZrJcxCkWqngVV3NmNtwMHP4nkBEgEesem2x+DrjyqthB9gCEfCpVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UyhnAYATksnGnRmnFo0zf5mSccmPmGGIMMPkFjOT5z0=;
 b=HGa8nrFRksQWnSD9YEK7dSojpb57JGFROilxTDxUIuyTITiNpcbGdGLEYqrNas1Tk5kbDlSvhbyFRwmfZFgLZWPDbFNMr3DHxbpw0Kz7iexRljvtSBNzgxpzQg/2cN1TEUHApM/gyqeMvV4ATXD1gsKZjMrIH440xbEoWwF0nHC1b3CQsrLsEMMjCfYII6DLokYFxFA3y/kaM6Ua4L5JHvb4rCSc4a0lB+XkU+/M3ojsp0x8h/2RvRYX4bB91oQo5ig0tD/DBNeIN5ygTjLxSZxvyM8zO1GP9unw23CPCmt6I1dcCFY7bSwXs9NnFmxZ+CBIq2R1WpFe2sP6gEaS9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by DS3PR11MB9819.namprd11.prod.outlook.com (2603:10b6:8:364::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.11; Tue, 7 Jul
 2026 23:54:57 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0159.018; Tue, 7 Jul 2026
 23:54:56 +0000
Message-ID: <de91c9e5-4329-402c-8803-d875dc510f2f@intel.com>
Date: Tue, 7 Jul 2026 16:54:54 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/10] fs/resctrl: Prevent deadlock and use-after-free
 in info file handlers
To: "Luck, Tony" <tony.luck@intel.com>
CC: <james.morse@arm.com>, <Dave.Martin@arm.com>, <babu.moger@amd.com>,
	<bp@alien8.de>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1783377598.git.reinette.chatre@intel.com>
 <e5468d05f984f4db2c0fc378562b2c4a9cca301b.1783377598.git.reinette.chatre@intel.com>
 <ak2M1RZ0EaMzPi7H@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <ak2M1RZ0EaMzPi7H@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0136.namprd04.prod.outlook.com
 (2603:10b6:303:84::21) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|DS3PR11MB9819:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f102fb7-d582-41f2-f7b5-08dedc8325d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|23010399003|1800799024|56012099006|4143699003|11063799006|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info: 99jf7g4X3oiG5knDIucuint/p8rsvHwTlVdj2+F15kG6SpGe0NZCqfuu1nf0eGwYf8kTtV0+FTmzfRY4lbnJVS1fth4VC1MkZYK47IeApdEaPMEoLQqedfCVZi7Z66br+caUhKNuAKsgSURRkI0rPlJkXvC1j3UdgKu04tHDCtVQeSvU3v2E88Lim9ZxkQGmyZlUwQD0LzZK7XJU2J/2Jp7s3HHlvb46XYROl4Q5/ksi1qSm489/V/DNjfAzr+A9RpxERmAb5YEZgsjpJwnnE98irx2wvvEkIb1jzHRjR72vQKh6KCze6Si4ox8MAnnsDEAl76WbSFRfVTBwsFpnyrRA40ee/lU58jzim+380hOzsj+z67WoY0cSSEscJ6mQkWPohursPVsFg+DLd3NwR7FKxJmaJuBw2gkCKNMHCw2OLOycIAXBRISdS1FpdwAq7HvigMOecOE8rTjgVZ4qXhMTNJV8fQuoU2v2XA3FuhEEGUnPAdLVH+HBfFH+qMdMJJmOvwBUWOguvlNOXDkPzCj03nXKmPpDDkUv9OLz7KNYx/1GBunUZWnSdjMOecg1EU+Un5A6Lt4X/NGDqzCXX8Txfb1rk+fR4cKa1DxE8i7KjDQzT3glRSgNBgOzfE9WMLggDkca8isxi8W5woizTnO01WB1no0CdaNS8dn7egg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(23010399003)(1800799024)(56012099006)(4143699003)(11063799006)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0p5SDY5bjZheVllNDN1UjQvdVA5RDA5V0U5WDF0WDBleUVmRDIzamovdnk2?=
 =?utf-8?B?TDFEemh6elVaRStGMkhhQVdYbThDNXVFTnQ0V1VDZ0czb0oxK2JHVFU1T1p3?=
 =?utf-8?B?em0vQ09hbi9KRGZ0dHd0aGJ4eURmWXIvUElLTndOVkhhUFBpZzVuZEo0RUY4?=
 =?utf-8?B?Zkx5bWJXT1hyTnFFTlE5K3hxZ2RxSnh3S28xd2ltQ3pBWVpBTTVIaXExMCs4?=
 =?utf-8?B?UVBZNjRwaitpdTF3M2RlQk1PRDd6alVqeXAvT3FScjlGY2tqT1k1NGUxdDV1?=
 =?utf-8?B?ME05MllFcnFMaHo5QkJDam9kOWpCYVFTVW5wd0FjcklHcEJRWUVEY2loL2RE?=
 =?utf-8?B?cTR0UnhmSEVtemRkVkRUMGZYa2FJNCsyenl0NEJIdElNaGVhV2pUcTdpUHE3?=
 =?utf-8?B?SEZRVDhSeUlWcHNCWGRiVGtNOFQ3b3ZhQU5zRkRxcXhjTGtPdXpYS3Z2NVNW?=
 =?utf-8?B?UHRvMy91cXdHbXMxc25TS1hHVTV0eUd1YTJDQjBYRzdPL2ZjcWhOdE53YnhL?=
 =?utf-8?B?ekhTUGNoUHZ3YkF4S3NGTWYxVXJra3FlWVRvSHhrV0dFamlEeEtEZVNGL3c2?=
 =?utf-8?B?SVBkdGRraER2N3JVOGt5dHpRTDk2cW5IQys0WUtFRGNQbTFnMGZzbXkwSEVP?=
 =?utf-8?B?RlBYN1ZHZU9rZmUvaHhIQlA1VDNaaGxmK1ZJUHdQaXpTTEhXQStMSWdGZzBB?=
 =?utf-8?B?Umt4bHdJSmowc25BZEpZdzd0WEhrL3B2K2Ywc2lLY1RRRmR2NjIyTWpIc3E2?=
 =?utf-8?B?YnJhSnl4dDJWem1RT3diRS9seDI0MmZNVEE0MTkrZGRWRFhpclB0RVp2QnFp?=
 =?utf-8?B?dUVpdXRDcEsxQnh1akdmUk9rd05XYVlySWFFcWwrTFNoY2pDYVcraHhvNjk5?=
 =?utf-8?B?NEZmU2ZXNjhMZi9mOXZUTlZKZ0ZPMDlyTlhWZU5wSnpZMXh4emh2ZTdQWmx0?=
 =?utf-8?B?cmEvRy9SemsrZzgxRWJJbGhuM1lvd2NmRGVsb0dPMTFuckY5OUJ0bWFyK0Vv?=
 =?utf-8?B?aHlKTHh1M1ZhLyt5L0M2T2VpY0FvV3FiOTBERkZpQlNmOEpwbkwvSGw5dTQz?=
 =?utf-8?B?NXh1ZnBHS3pvc05QTnlaMEY4YWhwL2h1Y0tWMTFGNytTanNGYXJRTVh6ZFZs?=
 =?utf-8?B?Q1kwZ3IrNGZmY3hOdCtFcUVpK284U3lyM0NTcEpocjlJVkdqcDk1OHhqV1Zt?=
 =?utf-8?B?UXNaa2UzUExmUlNxTXlZaEQ0TjM0d29JRUpJa3J6VXJ2M1FDK1hrVFFQUVlq?=
 =?utf-8?B?OUh4T0dhdUYwK2xUVXV2RlgxVUkyd1lGL1hnVEdPeEdpWVdWdFg0dkF6MWdm?=
 =?utf-8?B?UWtUdzFKT0xWT3gxckoxcmh5enFrc0g5YVh2VXZoZWZpUjM0Rm95ZU9IeFht?=
 =?utf-8?B?TGJEaUFRdDh2UGFrMDJpV25GMDFiSVR1eU9IQnJaN0NaeXNtYzh5N1FBME9S?=
 =?utf-8?B?Mk9OcFZmRjVkQlhsVERJL1g1dCs3YTVLMkVtUHliYjRKL0V5b05WRFZoaUJp?=
 =?utf-8?B?eXNyNjN3ZjljSGt2K0xTQ1d3bUkraE1kUUtNT1d3T3h6dFNFSEtYQnN6aWZ4?=
 =?utf-8?B?TjU2Tm4rek1yamRnZ2lYTGs2K2pZR24zUWZ6bXp4N1QzK1NNNGJSTlJ4TlZj?=
 =?utf-8?B?QzBadzlqRnpUNTU2VEp5MVJGN3Z4SkJtQWFidVpGK1FneVpWUXZ1TzNHbHpr?=
 =?utf-8?B?Y25KUk05d2xPWnFFVjZ1ZkFDQWhuanFKYjYwdFkxZnBsKzJ6UTh0dTA4TCtk?=
 =?utf-8?B?dE5hYnpZR1FCSllDVTBPREVRcnZjSnZLNXlob2pFb25Zazg2b2w0azRvOWkx?=
 =?utf-8?B?Mk1uTG9xbXR0NHdyV3lQUy8rNFRVcERpeFdDL0ExZGdYSmRIMSt4TkdjUk9R?=
 =?utf-8?B?ak5hUnVFNmhPL25MYTV0d1lRL0ZIZ2h4bktpUTVWSkNoNFNXbFNTOU5nSWRn?=
 =?utf-8?B?T0hMSEVhQ0g5RGdJR1FpTmNrQjNwOXlmMldQUFJtZFhKNGM4SXlPdk5wTjBm?=
 =?utf-8?B?dHd1azVZWjM1dGtoRkwvVUlFam5pSnZabWE4dVZBbi81Nk5rUFdEbE9sWnVB?=
 =?utf-8?B?Nzd2Zmp1a0RxS2VyNXAzaXNrV29wa3BiRnFEQlphK3UrR05RUVpyVjE4UXhy?=
 =?utf-8?B?OXJOdWRPMXJPUjVSb0tQYzdHWXBZVDlxaTcvSVZtZkl5b2hYemxWTHhzZnZQ?=
 =?utf-8?B?bjE0and1SG0rVVN5TXFvOTVVZk1jUWRXU3ZVaTM1d1dTQm1pbHZCdmo2Q2R2?=
 =?utf-8?B?ZER1cE9jUGZ6WDc1VXg0TUNEYzQ2R0RvZUNxOHFoZFp3dnd6enhGdTVkdkVx?=
 =?utf-8?B?Y1VSZ1JZR2o4akNnSDl6aDJQSW5BaXAxS2lEVllLdzFGeVVDODYwL213dVVR?=
 =?utf-8?Q?0uzEukXU12yYe8l8=3D?=
X-Exchange-RoutingPolicyChecked: S7gWrxqUnalNc4sP0CLyTTVwLQo0wPGAqUMmSlSeWGNGgmO788ua41OLhfw7uNUYuhAXL/0+/EP9lBNmI64Xri5WRjvp16lZxEUs7FAir2Usepl3HahfnoXunlgWWerMMzpzmHr9NoOv7QYiyq0AvYE3oOCd3JjUYI/hPHPKLE2z0mQKr/Xt1J+CGAEzD7CBeNGJoNcG0CMtoRgP6l6afltmWXWIYlDod+5AfEBM7ggHTkRNZFaPFQ9Lg3PkLKgeCDkTAs8pvUJUbtWD8Zl8trOg5GwzhUALx+VD7KXG/cwMirlptxgyA0NsG7W3GmqIGZ7X1g3ualGtf1+74cWvMg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f102fb7-d582-41f2-f7b5-08dedc8325d8
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2026 23:54:56.8600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: beHpgUXC30rypoAG8wNmrINMiLZiA49iPxQKmwRAy7YAzBo/LWHElgM/7eYwQtNN0DZiZq0yQnBPnda5ZKhaodyBSGlU1R5Ac1DEEBvNWMg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR11MB9819
X-OriginatorOrg: intel.com

Hi Tony,

On 7/7/26 4:33 PM, Luck, Tony wrote:
> On Mon, Jul 06, 2026 at 03:46:28PM -0700, Reinette Chatre wrote:
>> @@ -1020,9 +1030,15 @@ static int rdt_min_cbm_bits_show(struct kernfs_open_file *of,
>>  				 struct seq_file *seq, void *v)
>>  {
>>  	struct resctrl_schema *s = rdt_kn_parent_priv(of->kn);
>> -	struct rdt_resource *r = s->res;
>> +	struct rdt_resource *r;
>> +
> 
> Extra blank line added here.
>>  
>> +	if (!info_kn_lock(of->kn))
>> +		return -ENOENT;
>> +	r = s->res;
>>  	seq_printf(seq, "%u\n", r->cache.min_cbm_bits);
>> +	info_kn_unlock(of->kn);
>> +
>>  	return 0;
>>  }
>>  
> 
> ...
> 
>> @@ -1652,8 +1718,8 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
>>  	struct rdt_l3_mon_domain *dom;
>>  	bool sep = false;
>>  
>> -	cpus_read_lock();
>> -	mutex_lock(&rdtgroup_mutex);
>> +	lockdep_assert_cpus_held();
>> +	lockdep_assert_held(&rdtgroup_mutex);
>>  
>>  	list_for_each_entry_rcu(dom, &r->mon_domains, hdr.list, lockdep_is_cpus_held()) {
>>  		if (sep)
>> @@ -1670,8 +1736,6 @@ static int mbm_config_show(struct seq_file *s, struct rdt_resource *r, u32 evtid
>>  	}
>>  	seq_puts(s, "\n");
>>  
>> -	mutex_unlock(&rdtgroup_mutex);
>> -	cpus_read_unlock();
>>  
> 
> Extra blank line here after deleting those two lines.
> 
Thank you very much. I plan to send a new version of this series based on -rc3 next week unless
I learn about a better way to handle this before then.

Reinette

