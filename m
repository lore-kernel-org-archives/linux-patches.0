Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDD813BAE8
	for <patches@lists.linux.dev>; Fri, 10 May 2024 21:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376298; cv=fail; b=s3BnbUToebgTVGXIB+yrBv9Ee7r/yEMYVqQneQc7DHcc2IEe9eTsYTzyJP61GisoxGp7DOSeXl5VdRNegWbur9Ee3sAthyutlJQTCM3qoy7YpsMm039xmslutWpQ54HYLcEDlTHRQ5zzj9ziaBXbrZv0IZ3U1P1w5A8GBibWKmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376298; c=relaxed/simple;
	bh=er8E020ZWjUbGqnSvoeGSvi89Gfbv9oa0bU7GkgfCF0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f8/oO1MGOwDHPBko4wPxk5PjLvedXnrgUmq9PVJAYqtCvq8ovG+iCeFIa9ZospYjFDfPa+alJw7oiBVaSCm6u5ynfQcMqTY889FqiRWcAmZ0BrPPMBsPwIAEKGdYppvgK1z3FSG/Q67MwcwShctWL9OUX5b19M23b7uEjeIEOIg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GmxyAzOi; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GmxyAzOi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715376296; x=1746912296;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=er8E020ZWjUbGqnSvoeGSvi89Gfbv9oa0bU7GkgfCF0=;
  b=GmxyAzOiPO/NRkVR9aLkjkc3XMDBC0ZgKkOAJnDtReiRBFNtvrLnVS2v
   vigdnNeJLimF/5EpZUJq5NJFkN0E/k676FP60l+bO71mgzSlPh/7qtMpK
   3nnEQyfu+IdKBO51Y9UtKE5EHs0UTZbSRUGoeZcL8IWCihBgEk21y3b+D
   xxsh3mpeuTJoncvQgzQAusCJ+DlVbmfaONElFN/Jyt2u6W4/rsDfTDiuB
   iQsxX1StlaWJgcUPmugHMAXXoRo6WLMlpo6SN73wKUOFIO66tAT3227Tw
   uniEK5EluFDE1ekZEX399iF7dxBwlkJ8a5nMQEE8fkAKgRTA7cD6GxrZh
   w==;
X-CSE-ConnectionGUID: RXAEk++5TSONeucByNkXnQ==
X-CSE-MsgGUID: FZTDzMRkRnS9wpjXTs6EXQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11069"; a="11593823"
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="11593823"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2024 14:24:55 -0700
X-CSE-ConnectionGUID: FEqWTjJJQgOPfIsA7P+68Q==
X-CSE-MsgGUID: tkXZI78xT4ykHyQFKwC50w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,152,1712646000"; 
   d="scan'208";a="34499179"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 May 2024 14:24:55 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 10 May 2024 14:24:54 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 10 May 2024 14:24:54 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 10 May 2024 14:24:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EO7mp/0zliFUh/mWTMW9Fk/5sA+jPBvxjNPww1bDmUaWBkCEELpbEXOCP3Zrf9eddfgndC7G2Aw06cQkBsvu7cGO5r+VCbLFXte7LCXSAcuRp9dHOgZbnfnZ87bOMYrH6C3fFxUAKhOart/g5O3CwfKKRJxq+FUYOkiIJ/arlSrm18wOxnqYYn+4/xyn1sLAHrerPM6H7iNdb3BWhZvsUPu71uBOc30RvYUQUCoZEPH7hppCMMvAuAhs+hjFM7eYqLr0F/hutQMhTp8fcsk3AqxBwV1KZJsImaTdBMCtmxawekdcFUV8tTE26ivE87KEJBc1ZrnGixhylOWzU9nVcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3a8mizuZrSyFyLzisXO57svEt5m6IMsDx6iCTiIjPwk=;
 b=GHLVqKiTvxWNi9gzlfg6mW/XmhlAk8NqU/xb2eQ3Gsi8VCtb311x9SKFVSwEH2xMy4HyjP+4y+OTX7ZFQSWMOY+Z5avVNOcEIPCMf9CWVKah8Wn7Icvvk1jjL1mOMsR12dTPslV9rtz87B7ncKipgtLTHkn183D/yTOycfT7eyFnZ3N3DZxSm+dfd7vfZr0VTwoldqesztd/wAs5dUcQDwIJLBRHL7LNyOWSXQPBs0jw7V6ZYzHapqaBMnTMH71PWvXtVq3xTdKkcnwWcT96VixmtnF2R3wyIAspbpJfIz/HgUPgNp+30Ldr9XK4+DzonUsp0+5j4tVS1U0gv8JWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB6914.namprd11.prod.outlook.com (2603:10b6:930:5a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.30; Fri, 10 May
 2024 21:24:52 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::b394:287f:b57e:2519%4]) with mapi id 15.20.7544.046; Fri, 10 May 2024
 21:24:52 +0000
Message-ID: <570e0c1d-8df8-45c6-a9a8-972e1ff2cf66@intel.com>
Date: Fri, 10 May 2024 14:24:49 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 8/9] x86/resctrl: Sub NUMA Cluster detection and
 enable
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
	"Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-9-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240503203325.21512-9-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0337.namprd04.prod.outlook.com
 (2603:10b6:303:8a::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB6914:EE_
X-MS-Office365-Filtering-Correlation-Id: 320f6a83-4925-4486-f688-08dc7137a118
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QkRtZFdXMHVKSHh4QzF6R2k3Y21tdjI3SldQc3RmT3ZOY0YyV1NlVklpMzJV?=
 =?utf-8?B?Z1N6VE5rTmtpcGs3Z1Jiam1qVG9qeC9FU21hd2hjTVpNRW82cStuMW5xcTRh?=
 =?utf-8?B?ZVJLTkhaNFpQYkJyRU1jcFJ2SitZb29LQWxwZGZKZjF3ZW9uMEZzUDBldlIv?=
 =?utf-8?B?YWh2dmM0eEM4UjA3L3JvaWNMbnhnSDJRd09kVllxcVVVa1JVUE5tOG5SN2tz?=
 =?utf-8?B?VkVqOUErbjAvSTFrS3FZbURNK0NmNEVZeWNaa1VRUkNXNXRWZXAyOFNGeVNL?=
 =?utf-8?B?U3BRR1lnTUxVUGtRay8rbGdOZE95bnMycTZ3eTZ5cDNHV2lBZXBLRXUvdzd0?=
 =?utf-8?B?cmJTV2Q5K21IbGtmSEN1U09oWlpmSHorWVg0ZTY1clNTbVRIRm1oUWh0RFE3?=
 =?utf-8?B?Z00rVDNKYTRZRW5NclgxSklIcTBBTm5idXlLZHVPb05wQ2F1aU5IYUZoYjA4?=
 =?utf-8?B?NWZSSTdKSEFCbnBaaVVkT2dTM3pYY21BdmhuNFZJcVQ3UFN1d0NUa0ovT05x?=
 =?utf-8?B?ZTA1b25GZ2ZTT291Rm16eHE5dHdLcmxKZ1BYVWFKTWZZMUVTd3gyc3NPYmVs?=
 =?utf-8?B?eXZ0ZkRtZVBBSTRMd1hLZkUyalA0bUhEcjZWYzJLUngya0tlbjR6RHYwcHJJ?=
 =?utf-8?B?Uk5rRHRQZDdFLzIrNVRKQXlJazR4enJtWDhXTVYzNmhOZFU2NXVOOVY0VXlJ?=
 =?utf-8?B?Yi8yUVlNY0EvUVVzaCt4djhKNmFFYTNKa1ljK0d2SWdYUmNqSThpTVBMWkZU?=
 =?utf-8?B?Y2tIcWI0TDhjaDV1Qm00WmdhTXVxcnUxdTNUciszRDhmZUdBb2s5SWFNdHlh?=
 =?utf-8?B?T0ZMN3U5M0Q3MzdtWDN6NkpJTzRKV3JsS3cxSmdEbEM0L2dUSU9xOW91bGxX?=
 =?utf-8?B?b3NidG84QnE4QTNtaStnNFJ5Y2ZranhUUlhZOTJTclJRV2x4cVlFbFYrVmVC?=
 =?utf-8?B?OFpCL3B5WWplZlZieFNSMWJjN0N4UTQyU2M5SWlrRXU2NTRQanZUUFllMXE4?=
 =?utf-8?B?RmVmazh5bGxkTG9zc1gyOEZDR2RDS0pjNVFra0EyV1MzS0ZGQzlvc1FjQUE0?=
 =?utf-8?B?eHZHRVV5MUtiZmhPYlk1QkcwZ0tDa1pXV0xIM0xQdkt1WU1IaS9INnNRc1E3?=
 =?utf-8?B?QWNFOEsrUTFOS1dkN3V3NDQ3SmFiZHc0L3c1b2JTQkNBNTJyYWRxNGszcGdI?=
 =?utf-8?B?ek5IQ1Y5OFNZeXF4Z2dkVE0ycFQ5Vmk0N01IYkp5a3F1TW5LNlF1bjluZXlD?=
 =?utf-8?B?NjRXbm5WU3hRekI2VUNhY01VMTl6NkZ3Q1l1U3NGSjNZYUROc0c4eWxUUG5K?=
 =?utf-8?B?Y0l6bmlzZzhMc0g4d1FGTllMaW50RmhrZ1ZTZ0t5NDZKNlh4VkhiaGxTVnZo?=
 =?utf-8?B?T2lIbWtISkZ1M1dWUEQ4NW0weDNvR0YvNUZqS1A0L0M1TVZDVWRHeGJNU3NN?=
 =?utf-8?B?SzgweTBHNUo2anpPNW9iTW5IYkExS1cxY0pKeVhSWnppM1V5VVBnUU91NHYy?=
 =?utf-8?B?R3RQZWI4UlR4SlVXVlJrR2VzTTlpdDRMOGwyTnFMVGdqWmxVbDFUdFdYcXlz?=
 =?utf-8?B?L1dZbnBFL3JDNi8rbTBmRy9tMVpCUnhaWTFBVkd1SHk2Z1Qvc3NMaXhiUG1w?=
 =?utf-8?Q?74fy7oDWOBZkHDyy19dcDUBAnQInmbrFlpWPAQJVt9ws=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SzNBZDc2UnNKMFMrN3orUHhzSCtZemhDenExWVoySkYydnBuZ3ZGVHhSa1NG?=
 =?utf-8?B?WFE3UlBRMXlJdFpjMUV0a2xwaFVIMG4veGZSOGYvcE1kWVpaRTZ3U1EyVi9W?=
 =?utf-8?B?ajJ3MVlEc0lTdk15RW52dlBFKzMxWXJXTEx3OTBRci8xZDhVRmhwdXpRRHZB?=
 =?utf-8?B?SDF4OElkeTFHQ25RWklYSU14ZXVtUFRHREIyZVIrV0dteVFEUGgrZjlBSW9m?=
 =?utf-8?B?aE9lWnA0bTYxdHBMZ1djSldoZks2WTd4RDQ0MURnb1ZzM3QyQi9ESFRMbzZp?=
 =?utf-8?B?a09hYk92OUcrSVdnK3BheGVaMkNyVVZOL2Nva1lVWWZWeVZLeDBBMXpzS2xs?=
 =?utf-8?B?TWtKWjR0d1p5VUZVdjdkcTJBb3lwZVNGZFBNRVhKRjVBTE4rZStjUjFjMjZ3?=
 =?utf-8?B?L3FYVUY0T29VVkVoWXFrRFkxM0R2Q3lvNGExZnNTY3dEd3l3WjB5cFFLVFZy?=
 =?utf-8?B?VkZlNXJyTVN3QnlWdG9aMVFoUkZNYUdQR3RuRmVBVExhVGhRMHAwOGRWU0Zo?=
 =?utf-8?B?Nk5PT0tCUUFhK2FNUHcyUzJKTUJ1V2tackRtOUo1ZEZlSU4wL3pvNVZKc215?=
 =?utf-8?B?YkJWRE4xNFN6alAzeUFscUN1TFlVaGM1cDZDbUlOUUpQLzRrbHluV0RJRFNo?=
 =?utf-8?B?MDdwbXZqdDZHcUd1UUZDRGJLWGVINWxWQktsQS9FUUxtTmRmMXVNUFdRL1JQ?=
 =?utf-8?B?VmU0dndtWlY2T0pOZVArKzBUSWlnWjBrTEN2Z2RRNW85bHpDRTZZeER2eEcy?=
 =?utf-8?B?MXcyTlpTZXFoam90a05hc0p1VnQvOWVFaGxGWmF3MUlZNkZoL1QxQVZFRlhi?=
 =?utf-8?B?eUo3V1dTbTRiZ3hCWUZmckF1cU1qRDZxaW1Icm9ZS0ZhbXY0YTlYWkQ5V3Bz?=
 =?utf-8?B?MGFCZHJSOTJFNERRaWJZWTgwVHdQYkVwcDNvcVJ3b0F6V2l0UEZUU3BKYzh1?=
 =?utf-8?B?ZGFNTmJjNVBMdC80dHFnZGxwbnNLR0d3czZoUkxnZ3lOUWlNYWEvYVNFNEs3?=
 =?utf-8?B?elVvUjJMRWxnclNOUDRqc2RBRFZocjBTZ0RiTHdRQmlkaTdpMjFVVWMrdnZU?=
 =?utf-8?B?dERNTWFYZFdaSGdPdm85MHVVQjhYM2JRMlY2Z0FUVEt6Yi9pcENIa0NhaDRY?=
 =?utf-8?B?TEhtZVJTMjYrWjIrYnlmUG5HL2FmbTU4Tno0NnhNNFJoaUlsZVYyNFZ5LzRG?=
 =?utf-8?B?SWZMQkxPVkdWRFlKUGlXdTIwNUJLUnBwQVZMTjFRdmNJdFl3NEt1dndnN2hm?=
 =?utf-8?B?VThRNnZyUVU5cXR4YkppRDNyVmlxam9hMGl0c05nR04vcUtReGpLK2FTN2x2?=
 =?utf-8?B?KzJ3d0RDdUJzWWlpZDJiRnl0dEFHZTNPQlpvUWRFeStEOU5mRWdCbk1WL3Uy?=
 =?utf-8?B?NVNhNVU5Zml6MXJZUFVjaEhEWmRjL0dQc0pLYXFrRkZGMFBTWS9ibjNxMGF1?=
 =?utf-8?B?dDZjM0xyVlR6eFhYd256VHJ0QitMMHQ2cDY1VVJ6U0VudzFoNENGUmJTMWp4?=
 =?utf-8?B?QlJJQnplSmFOUjZEMDZzTVNiV05KNzlZRnp6OHJrVUhtdDVJaldUVXA1SHFl?=
 =?utf-8?B?VTlvVVhpMExLMnNVSUdhdDJCSFJkNGRZMmM2QW5JZ29sYlFlZ0liSHpoNG0w?=
 =?utf-8?B?V3lGYmlmV0kxR2JEdTB4QjhYbFIwMC9RbmowT3V2UlFsdEtGV3RYM2c1bU9r?=
 =?utf-8?B?Z1prTEU5ZUY1SFFzVFFKckpzcGxhSHAwOFFSSytDbEc4VDdOT1hvNkhDR2ly?=
 =?utf-8?B?cGJEYUJlOFgwSzJJNkFWUHZONVVGUDlxVG5MaE5UVEJBem5lcmhCZ1ZkbUow?=
 =?utf-8?B?bi84bmx6WHdNUzNDaG9PNUVJVFM3ZkhVQjdYNFQ1WDNpT2JKUkx4TVN3Tjhh?=
 =?utf-8?B?WkpUVlV1SG1MOXEvUFdKNTh3OVVDQUIzRVF2V3lYRWVERFpjVllRU01WVGN5?=
 =?utf-8?B?Q2kvK0I5dXlwaVF1ZjN5YUpZT05ZeDZRTFR3SUhxZzE3QSttZTA5YVg4aXRC?=
 =?utf-8?B?YlNZQ1d3cWpLYk51M01NV2lvRlNHanVnMkJZNGIvNjlKMElVQzJQL2R2U1dT?=
 =?utf-8?B?RkdldS92Z0pTRDdkSzcwbm1tZzlKcG12QjNaU0Q1QWt6T2F3TDVjYnZFSjU3?=
 =?utf-8?B?YzV1MWNQajI4Wm5WWHludXpaNFpWY05WMERPbWFkajhQNjcrYzgxWFdFWGx1?=
 =?utf-8?B?a2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 320f6a83-4925-4486-f688-08dc7137a118
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:24:52.0702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8R2o1JmGkm8Mn9Qnux3q5nuopVy6GnIZ+kUgy5JJ3HSAjXFvCFsuQBpfuv8lZmOU7HnNx0qMd9UyykxwCmqD1AS4HmMIIK3aYps3qc2KyVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6914
X-OriginatorOrg: intel.com

Hi Tony,

On 5/3/2024 1:33 PM, Tony Luck wrote:
> There isn't a simple hardware bit that indicates whether a CPU is
> running in Sub NUMA Cluster (SNC) mode. Infer the state by comparing
> the ratio of NUMA nodes to L3 cache instances.
> 
> When SNC mode is detected, reconfigure the RMID counters by updating
> the MSR_RMID_SNC_CONFIG MSR on each socket as CPUs are seen.
> 
> Clearing bit zero of the MSR divides the RMIDs and renumbers the ones
> on the second SNC node to start from zero.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h   |   1 +
>  arch/x86/kernel/cpu/resctrl/core.c | 119 +++++++++++++++++++++++++++++
>  2 files changed, 120 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index e72c2b872957..ce54a1ffe1e5 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -1165,6 +1165,7 @@
>  #define MSR_IA32_QM_CTR			0xc8e
>  #define MSR_IA32_PQR_ASSOC		0xc8f
>  #define MSR_IA32_L3_CBM_BASE		0xc90
> +#define MSR_RMID_SNC_CONFIG		0xca0
>  #define MSR_IA32_L2_CBM_BASE		0xd10
>  #define MSR_IA32_MBA_THRTL_BASE		0xd50
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index a949e69308cd..6a1727ea1dfe 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -21,7 +21,9 @@
>  #include <linux/err.h>
>  #include <linux/cacheinfo.h>
>  #include <linux/cpuhotplug.h>
> +#include <linux/mod_devicetable.h>
>  
> +#include <asm/cpu_device_id.h>
>  #include <asm/intel-family.h>
>  #include <asm/resctrl.h>
>  #include "internal.h"
> @@ -746,11 +748,42 @@ static void clear_closid_rmid(int cpu)
>  	      RESCTRL_RESERVED_CLOSID);
>  }
>  
> +/*
> + * The power-on reset value of MSR_RMID_SNC_CONFIG is 0x1
> + * which indicates that RMIDs are configured in legacy mode.
> + * This mode is incompatible with Linux resctrl semantics
> + * as RMIDs are partitioned between SNC nodes, which requires
> + * a user to know which RMID is allocated to a task.
> + * Clearing bit 0 reconfigures the RMID counters for use
> + * in Sub NUMA Cluster mode. This mode is better for Linux.
> + * The RMID space is divided between all SNC nodes with the
> + * RMIDs renumbered to start from zero in each node when
> + * couning operations from tasks. Code to read the counters
> + * must adjust RMID counter numbers based on SNC node. See
> + * __rmid_read() for code that does this.
> + */
> +static void snc_remap_rmids(int cpu)
> +{
> +	u64 val;
> +
> +	/* Only need to enable once per package. */
> +	if (cpumask_first(topology_core_cpumask(cpu)) != cpu)
> +		return;
> +
> +	rdmsrl(MSR_RMID_SNC_CONFIG, val);
> +	val &= ~BIT_ULL(0);
> +	wrmsrl(MSR_RMID_SNC_CONFIG, val);
> +}
> +
>  static int resctrl_arch_online_cpu(unsigned int cpu)
>  {
>  	struct rdt_resource *r;
>  
>  	mutex_lock(&domain_list_lock);
> +
> +	if (snc_nodes_per_l3_cache > 1)
> +		snc_remap_rmids(cpu);
> +
>  	for_each_capable_rdt_resource(r)
>  		domain_add_cpu(cpu, r);
>  	mutex_unlock(&domain_list_lock);
> @@ -990,11 +1023,97 @@ static __init bool get_rdt_resources(void)
>  	return (rdt_mon_capable || rdt_alloc_capable);
>  }
>  
> +/* CPU models that support MSR_RMID_SNC_CONFIG */
> +static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
> +	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X, 0),
> +	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, 0),
> +	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, 0),
> +	X86_MATCH_INTEL_FAM6_MODEL(GRANITERAPIDS_X, 0),
> +	X86_MATCH_INTEL_FAM6_MODEL(ATOM_CRESTMONT_X, 0),
> +	{}
> +};
> +
> +/*
> + * There isn't a simple hardware bit that indicates whether a CPU is running
> + * in Sub NUMA Cluster (SNC) mode. Infer the state by comparing the
> + * ratio of NUMA nodes to L3 cache instances.
> + * It is not possible to accurately determine SNC state if the system is
> + * booted with a maxcpus=N parameter. That distorts the ratio of SNC nodes
> + * to L3 caches. It will be OK if system is booted with hyperthreading
> + * disabled (since this doesn't affect the ratio).
> + */
> +static __init int snc_get_config(void)
> +{
> +	unsigned long *node_caches;
> +	int mem_only_nodes = 0;
> +	int cpu, node, ret;
> +	int num_l3_caches;
> +	int cache_id;
> +
> +	if (!x86_match_cpu(snc_cpu_ids))
> +		return 1;
> +
> +	node_caches = bitmap_zalloc(num_possible_cpus(), GFP_KERNEL);
> +	if (!node_caches)
> +		return 1;
> +
> +	cpus_read_lock();
> +
> +	if (num_online_cpus() != num_present_cpus())
> +		pr_warn("Some CPUs offline, SNC detection may be incorrect\n");
> +
> +	for_each_node(node) {
> +		cpu = cpumask_first(cpumask_of_node(node));
> +		if (cpu < nr_cpu_ids) {
> +			cache_id = get_cpu_cacheinfo_id(cpu, 3);
> +			if (cache_id != -1)
> +				set_bit(cache_id, node_caches);
> +		} else {
> +			mem_only_nodes++;
> +		}
> +	}
> +	cpus_read_unlock();
> +
> +	num_l3_caches = bitmap_weight(node_caches, num_possible_cpus());
> +	kfree(node_caches);
> +
> +	if (!num_l3_caches)
> +		goto insane;
> +
> +	/* sanity check #1: Number of CPU nodes must be multiple of num_l3_caches */
> +	if ((nr_node_ids - mem_only_nodes) % num_l3_caches)
> +		goto insane;
> +
> +	ret = (nr_node_ids - mem_only_nodes) / num_l3_caches;
> +
> +	/* sanity check #2: Only valid results are 1, 2, 3, 4 */
> +	switch (ret) {
> +	case 1:
> +		break;
> +	case 2:
> +	case 3:
> +	case 4:
> +		pr_info("Sub-NUMA cluster detected with %d nodes per L3 cache\n", ret);
> +		rdt_resources_all[RDT_RESOURCE_L3].r_resctrl.mon_scope = RESCTRL_NODE;
> +		break;
> +	default:
> +		goto insane;
> +	}
> +
> +	return ret;
> +insane:
> +	pr_warn("SNC insanity: CPU nodes = %d num_l3_caches = %d\n",
> +		(nr_node_ids - mem_only_nodes), num_l3_caches);
> +	return 1;
> +}

I find it confusing how dramatically this SNC detection code changed without
any explanations. This detection seems to match the SNC detection code from v16 but
after v16 you posted a new SNC detection implementation that did SNC detection totally
differently [1] from v16. Instead of keeping with the "new" detection this implements
what was in v16. Could you please help me understand what motivated the different
implementations and why the big differences?

Reinette


[1] https://lore.kernel.org/lkml/20240327200352.236835-11-tony.luck@intel.com/
