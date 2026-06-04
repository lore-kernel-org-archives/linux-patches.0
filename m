Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE70E33ADA9
	for <patches@lists.linux.dev>; Thu,  4 Jun 2026 15:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780587063; cv=fail; b=TzWVaVpg4jkwuPrjL1I6g5TGkvvv3VsBr1U4u1ePFsXmoBowchmtGT18eRT5eP2dfdds6TQzyjfMQIx9KqdTc6JHWj6YJlJtNWTz0bpadKoOQV429VKdH/6NpFqbRcRtz119Oaq0MFkTQDnJ+PmFCgqwkol2wexJQt22zgEozH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780587063; c=relaxed/simple;
	bh=0T8yO/BcByZnoL4OOzwyHRMdu5h9BMB0mjL0qsnJrnk=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=l06bdXB0lMxd+szUHgP1zUaLxZpXh2aP2bRXlzphh4ehqvPIe7VDnwWNVzEW2xFqtdESUJXN0atim+EpiTiJrUo2Ajb2GeMHlITmORrSfV3/HcXuqZ9kbrUSbPomb67VngeYS9lWO7unmjdmxczg9muBajX/tK8Z1aqAIJGPpDk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SpwJNQUI; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SpwJNQUI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780587059; x=1812123059;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0T8yO/BcByZnoL4OOzwyHRMdu5h9BMB0mjL0qsnJrnk=;
  b=SpwJNQUItAE/I9+h+hmwkl4aJ1S3znolzB/HjmumKnXvyF+sGkAeBxIL
   pq/gfel6j52rISEc+qEaJsRjePjBLqFIuCGiqTuA0VUgm99AvrH8i5N2o
   LEguOBqs25Eg01LdE85n4FkO+/I2DLo/LRMoX+T+m5+XSYvMy48DPLG6t
   akoEzk8gHb+dyXZn9TxB4xiLfbSx9d5AF9uLINmVZXoE4OCRrUrNIhqJn
   o+z+JeWrbaeSYCftER+ZjoZWouAMP7RFPIjyZYwakghspBx02mhe37mMt
   3dnPrBR3htAtN8xdjcaJAAIC71mEZEI98PJZ8O9eCfwHXmD/AVuqEzv+Z
   Q==;
X-CSE-ConnectionGUID: QooUrLjaQ+GwVw8jjEWK4g==
X-CSE-MsgGUID: V9Yp4gazQwuZcAeMEArsYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11807"; a="106862929"
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="106862929"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:30:58 -0700
X-CSE-ConnectionGUID: 8mD5vZl6RoGhV1wAvBBaTQ==
X-CSE-MsgGUID: xQneBGnGT6qHquKQdsxHvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,187,1774335600"; 
   d="scan'208";a="242086858"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2026 08:30:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:30:57 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 4 Jun 2026 08:30:57 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.69)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 4 Jun 2026 08:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mAEV1GEu22E58JfcRndxp+O0YyxzSJ3RYzed4cKm3oAUTvlPPDYmLs4lOWMNLUzX0WDnkfjFWPMLaiqKU4dbQoeKsgQCwn8GMV/khgBj8alkbfXoiuoDE+ku9+2lslWt6FBLHnmyf+BbisyCef3KS6yw0nkJSDtqsBzoJ1uQn0/JJLt+cVd6Gci4au3uQ8ymKNdBKyG6PJUMAYYXrP8fVi4nEhkdLUnfOk4MdI8rDyao0ueh/WvjAZKr8uwZxylPC4ybis8NiA1rxmXhX3LgL/k7MC1WJWVN3tqc6JqygseisumLNq4nRJbOOg9HvXT0o4cBqd6HNc5EVc2hR8/gzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jiwUTTTrPlyrlSLVGUP2VxqGhTJkS5OUr4NHRwVWpXw=;
 b=qd8BuR5V3nsWNiJZ1rmMimYoB1paACF4pjuX0wpp2WCUu/WmbC0YQ3NEIBBkhL7DLVgZ9SFxjBIdDAeqy87ecyaoZJrJ/Op09NFk01S7TiGd4zTZwnvOWV9F8UVQoI7W6dtQAMT1/K+x3LTyzS+rCWv/N94nzLf+/7Io6hmYvNT/1KbJTVstPvWMN/U90B8QfI0hPLfWE33hpLP/aR5Ie126zsDCjs2p3Gf3W7Qgbp0CJOFcM4vPwKLS4ITapzAE91FaQrlT1a8X3JUmmZz5Ak1liV8nXyMUERQQxrBWRry6pitwJ79GfJ2lVEZOancb37Fm7Y3kT4EEq5ZRXsMmAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by MN6PR11MB8169.namprd11.prod.outlook.com (2603:10b6:208:47d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.8; Thu, 4 Jun 2026
 15:30:54 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%4]) with mapi id 15.21.0092.006; Thu, 4 Jun 2026
 15:30:53 +0000
Message-ID: <f942bae3-4909-434a-88e2-57b77c3ce6da@intel.com>
Date: Thu, 4 Jun 2026 08:30:51 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/10] x86,fs/resctrl: Document safe RCU list traversal
To: <tony.luck@intel.com>, <james.morse@arm.com>, <Dave.Martin@arm.com>,
	<babu.moger@amd.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <ben.horgan@arm.com>,
	<fustini@kernel.org>, <fenghuay@nvidia.com>, <peternewman@google.com>,
	<yu.c.chen@intel.com>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <cover.1780456704.git.reinette.chatre@intel.com>
 <776eb116e624f312239fa71cb20d9005e0f709fb.1780456704.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <776eb116e624f312239fa71cb20d9005e0f709fb.1780456704.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:303:b6::9) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|MN6PR11MB8169:EE_
X-MS-Office365-Filtering-Correlation-Id: 32d7a6cb-bd79-494a-792d-08dec24e43fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|22082099003|18002099003|11063799006|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: Y4HbxlBnYFJGeqjEoUisUAW/fFRCC/binkXYCqWI+izeECK21n60gtnRoMVOwHKEfm8lXoOY+BsN37cO/OLXsAm91KI9eiDKTtbZa7Z1OUl2Zo0D3n4YrMi8JU3aD0lclEtSqPutN8KvTHcU4sS3D4Vi/tLb0E73PdzDKaEzm0ntVt7+RghvNmXQNIRSAgy8hpnaYMd+q4CbaUD8w9tOj1moSNZLLgkEDSlrXsMt7+VWpocOemt02nrzPR8cLTu5iiVg0RYphEPof4H9/OryWvms0CXATtXSwoM3zZ1PEQYS4DjGh8LvrK5rnrz3cbNRUxfzaThYjd5KSZ0CTCLnG3K+HBL7czkhy5vDXp7u8vNbVirLLJhSQOcTeI7WR1xNQOAsDN5HZr+zsni+DWR3rY1JF1W/LpAEPquPLIx+GfjnkxCsbsd9phaz5wuad8KLC+jum02BN1+yxxoZCIijKKc0yUGaF4Y0RtJlNVQ9hSiwRTGFXZnE3NCCwhzkxss9Xek55caflsamC2Xeq/Spa+ohxLpJdqcWEyxroVnMtsgcQQj6TOFSYAatR4Bu7EjQemGYIF/FwKcMdt6KVIybD7BytufmU7haOOOfwxMWJZhl0cq7GyUQM44SCN1G6Dv+/U0wTwzSjhCPzhqArDruKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZmRESGFGTWt1K3lkK0QxZ2V1YTQzcG5MK3lIQzRmUGZ5czJjK0hHam4vR0ly?=
 =?utf-8?B?T2FORkZQdjNMUXVISUQ1amM0SFpZdXdlTDlkRnVDWDA4a25NNWZrVTA0S0Mv?=
 =?utf-8?B?RTF2L3NQaFpiTXg0YlJMc0I2U1crSUJWbkdzU2RSaHhjZHpldXFWZll0c2hJ?=
 =?utf-8?B?Q01JcTduZHlxVkREdE1hUXFxQmRuLzZHODl5S2I1eFRzTXFLNzBhZGNlZWpn?=
 =?utf-8?B?L29zdDdJREJlMDlmRzdHYzF5amFXUFVUck0xT2tVcEczNStWNXI5ZWlBRGE5?=
 =?utf-8?B?N0FERGpDR0IzK3JmRVBHWHBHclFoWGdySE1WNW5Vc0M2L1JFc2ZpYTJwRkpZ?=
 =?utf-8?B?aGtIMGFlWUZISUdYU0NQaXFSUkdlamUvQmVRZzMwRTBpNGhOdlB5UWFLek05?=
 =?utf-8?B?RG5TOWZqYUgwd0IyaDJ0WHV3dEYyd2pGNEV0QUhZS0hCdHU1Z0ZjaC9BUFlI?=
 =?utf-8?B?SzVHVFp4Q0NYRzBhQ2hoRjk3UW90MHB1cE8rUXdHakJCNzhJTmJJNi95Qm9q?=
 =?utf-8?B?L1lYQVRnYVlxYllxQkZNcktaaDNuMndIYVUvOGt6cjhNbXBDU2U0UXEwUGhw?=
 =?utf-8?B?RkdPZk9Oamd4dlltTXZpSmtBSGlxcG9oakQ2RzgzK0RoY3ZEMFJrN0VyMzdm?=
 =?utf-8?B?ZSttdkJSc0NLZDRRTDFxRE5QRGIvTUlFcUY5cmhKL0RjelZDQkQvekJJMXpH?=
 =?utf-8?B?dlg2Y0lmKzhaRjFHSUZ1dEpkVEl0TEZEWEduM1VNcGtTRDBkWExLTFcwOWow?=
 =?utf-8?B?dFE3Y2F3alZGczQrTEFncUV6czhUUStUTExGN2VUc3hJcHJUckNsYTZNRkxW?=
 =?utf-8?B?MHJJSlVSbW4wSkFTcVBkY2JFTXFzZUVPb2hWTTBsRTdxalFMd2xNWlM1QWhD?=
 =?utf-8?B?a252c1Roejh4R3poZkVUTnhZTElLK2hPQ25UZno3dHJsRVJiYndPdUdjS3I5?=
 =?utf-8?B?N0hOSUUyYTFTSk5ZcGczTXJOK0JPN3E0TEMxb3VFeG1jYmNoRFhoS3VXQ1hG?=
 =?utf-8?B?UkozNXZZY1hNM2R6QTZOSkxwSEwyOU5HZ0Q5SGJDTjloQ1JiWjhqSVEvZGZK?=
 =?utf-8?B?R0E4Rkg3Y01saTBzalFHTk9ZNkh6aE9KR2ZQUXZUaENvMWRoWGRGYkI3ZmVo?=
 =?utf-8?B?SkxLb1FYV0RKMGpIdUFGMVJmYVBIZGxaRDFrTzdEd1ozTVgrQUNrL1B0dCtS?=
 =?utf-8?B?TWwwOGV5VjlTM0wydm55b2tzYnFCcmZXS3dNa3QzN05Fa1JFQUlya1RWc2Za?=
 =?utf-8?B?LytVNThJOFh4TWZ3YjROVHNiVURWandHckgzbWRLYjdDam5NeFZoc1JmbWdL?=
 =?utf-8?B?emJwdzJRdi9mQXdzRU9QeWJrVnRFM2xpMk1TQThOR0xuekExSDV6K1ZiaDZP?=
 =?utf-8?B?VTRCUUU5cnNuUUNMcUs5V3lUK0xCNzJvb00xcVpYZEs5dWNCU3A3UXhzUXBk?=
 =?utf-8?B?ZGN5N2pRSWplUWhzNFNKWThPanFGeFAxaWpXZFV3eFFFZVJVanUybXdZelQv?=
 =?utf-8?B?RWcwdHRCY0dVRFBKekdlZFRzdmpuNGJWQ2hqcVdPMkhiYnQ1VC9Xbk1OY3JB?=
 =?utf-8?B?a3E1OUpXUnFlSzdRZjJzSDNzcUdicXpURmJma3Qxb0hYQ0YyNUhlSmNmbnk4?=
 =?utf-8?B?WFFyRTJ1ajlLWlM1WDVtWlR5UldORm5YajFVbGJ1UmRBU3RpWkhqNzJVS3Ft?=
 =?utf-8?B?VjhXeCtqSzRIUHdjOUhZR0l0SHVJMFlKNEVXV1lQc29GL1B6U1V3a0NuZFND?=
 =?utf-8?B?L0hzaldVYW5zQWcreFBhaGZRM1lRcWFMVHNIK3N2MDFQbDFBRUJFOVBrL2tt?=
 =?utf-8?B?Qno2eFdSVnBkQVQ0ZzUrZXlYVC95bFN5UkxnMThJbzZNN3R2U01HL3BZLzBs?=
 =?utf-8?B?S3BySnREZktvSHlBM1c1VnVnQlhnakcrS3lIMXNjelBoVVJSZGtDaEM3KzFy?=
 =?utf-8?B?U2pFcVNwWHFyYkI4c2xPSzZDd0V3R2FUT1JHZWFBL3FrY2FzTnFhOERHcmR1?=
 =?utf-8?B?VWQybEtGQ3NKL0xlcHlTOEtqS2x3THVJN3Fia1p1eFZNekdpa0dsZkUxY3Fp?=
 =?utf-8?B?clFZMFN5VDNpZ1R6MkxodlFtTjdSTUFrT1JKVEc3UUR4RTZTZnRvNWhGeGZ1?=
 =?utf-8?B?UlpPeUJwZVphdVlwS3lmUGl4RWRjdjNGRTF2azNsSjdzbk54dmg5ajQvN2ZN?=
 =?utf-8?B?L3dWZXpOS2tpZGdlRk9xWk9uOGRkVGFkaXNOOXlOd2Y3bUNabFNJNllYNjBs?=
 =?utf-8?B?WGI5QndIUUJXTHhDZmtrR28xZG5RVGZhSmJRNlRRY1dSZzBLOTB4SG5jTEtJ?=
 =?utf-8?B?VVhxMlJ0Rlh1cWhHSktjeG8zWlNYZjVkTlZGWlFTVStuSUdEemU3b1N3ZHR0?=
 =?utf-8?Q?5RQCIwfNSyLjjArw=3D?=
X-Exchange-RoutingPolicyChecked: BEJh86ZnUME5O3XpqYhMeA35srs3ewICurPdzWQuooWXSmifLeYziXh1XmiHAHpOmJ3H6N4bDsitP6sIs8ylSQkrjRaystnDBTgFRVelW3z3yrp6CbmpsHyoo1TN5F2LnM+Vrc46ervIkomg5OfrPwmcCQtNPSNP62dWryuYPqVAG7gNQw+aDwhfxz9nnxZZDAxe/xNfuyTgm/ulQNR9J+2u3sAl2O7SchOjlnlreC+5yx80eDL/3UlobfjHdpERuZ3oVFtQ+QG11u2OA8InzCLpT9B0tIlu0Ae+LhumuzXd/fgmr4lhpGkEWwi7VoJrNzTo9RSn6cKzau7wNe/EIw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 32d7a6cb-bd79-494a-792d-08dec24e43fc
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2026 15:30:53.8717
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ViVK6yS5hibV4xT8ptoj/2K5pZbZFPCkc65tDmJOZiAmqfVyKE6oFOJGkwpXN2fLhhoB0mwx2oJQLMGbZoR9kzKMXtMu2UBAZh0AAV3T+RU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8169
X-OriginatorOrg: intel.com



On 6/2/26 8:27 PM, Reinette Chatre wrote:
> diff --git a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> index b20e705606b8..e74f1ed54b86 100644
> --- a/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> +++ b/arch/x86/kernel/cpu/resctrl/ctrlmondata.c
> @@ -53,7 +53,7 @@ int resctrl_arch_update_domains(struct rdt_resource *r, u32 closid)
>  	/* Walking r->domains, ensure it can't race with cpuhp */
>  	lockdep_assert_cpus_held();
>  
> -	list_for_each_entry(d, &r->ctrl_domains, hdr.list) {
> +	list_for_each_entry_rcu(d, &r->ctrl_domains, hdr.list, lockdep_is_cpus_held()) {
>  		hw_dom = resctrl_to_arch_ctrl_dom(d);
>  		msr_param.res = NULL;
>  		for (t = 0; t < CDP_NUM_TYPES; t++) {

Sashiko [1] pointed out that no stub exists for lockdep_is_cpus_held() when CONFIG_HOTPLUG_CPU
is disabled.

Before this series lockdep_is_cpus_held() only has one caller and it protects the call with an
IS_ENABLED(CONFIG_HOTPLUG_CPU) check. This caught me as I am more familiar with the style of
lockdep_is_held(). I find it safer to not need to prefix all lockdep_is_cpus_held() calls with
an IS_ENABLED(CONFIG_HOTPLUG_CPU) check so I submitted an independent change to CPU hotplug
to add the stubs [2]. Thanks to Thomas this was just merged to smp/core branch of tip.

In the mean time, I believe it to be unlikely that anybody would disable CONFIG_SMP when using
resctrl and CONFIG_HOTPLUG_CPU cannot be disabled by user and depends on CONFIG_SMP per:
arch/x86/Kconfig:
    config HOTPLUG_CPU
	def_bool y
	depends on SMP

Reinette

[1] https://sashiko.dev/#/patchset/cover.1780456704.git.reinette.chatre%40intel.com?part=1
[2] https://lore.kernel.org/lkml/cover.1780543665.git.reinette.chatre@intel.com/
