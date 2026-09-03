Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAEBD4A0F0D
	for <patches@lists.linux.dev>; Thu,  3 Sep 2026 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788454941; cv=fail; b=be/8EI8+DNoZgic8LfRZJGsat7dRVIW029DXYCr5dViX/XzkjVTOYlCF9xhFJOiDu2xL6nxJvnVI0doRRSsRZKZBwqoVhj1jLIBY3RVFyesNH014v52j8Fz3/VQgUlGi63BQgVoIvJWe06MX6i8vM5/2y+9/Y6H1Kwrfj/9FAGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788454941; c=relaxed/simple;
	bh=pHg5fl6zNmQqSnyAS3XbwiZ/A/kVjdDxf6SSrxSvdnI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EPeD7+ojUa3RorCvNpkkNckbgmmeHNuX9cVRNFDzPiRcsG8pDlAsTvdkPf8VvWfaXnPQD/PFmEG8G/Tw3nOHtaN6ZJX/ttyE/C/sGwy8LJ9X3bzIdnT4BpGcxkUvaxZr85hWN+ayrUJz5cHEuVryJ6PhonzQe6PLZK61haHlvyU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mijftTs0; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mijftTs0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788454940; x=1819990940;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pHg5fl6zNmQqSnyAS3XbwiZ/A/kVjdDxf6SSrxSvdnI=;
  b=mijftTs02YHM4sY0FaVxdwtzaKL6qBjxuv9tSY2eQwIOve5HfkLRiVTC
   rVDdM7p/XT4MCXjL0yaI37nAzfb3zn9jNADghv/ka6YqtkBnjcL3QljvS
   zep+3UvGE01dlqPwipHJE0x7cjvi4clDNGt8TA2uj6MBOGpAp7a4yXKYM
   /c+W50CbNCG8Ww1WBhekLQ469S/LJr/iRkT6ROCtJuHQv8IdQjKy58HjV
   n5VsxD4IgVmLzcgfKepZ9woMJ3kS7WPJe1GgxylBDbPE7kJkCgLvsnmX+
   zBN257Rw2qxuYe1W4E+UrBztnAzcHx4PoPlZazRULmR1AgSsniOGMBOZx
   A==;
X-CSE-ConnectionGUID: /dsJT09RQd+EqunmwPrAAg==
X-CSE-MsgGUID: E/8cKvhJRzutwxIs+CdwAw==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="88999886"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="88999886"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 10:02:19 -0700
X-CSE-ConnectionGUID: w9q3UKyyRaqWELrNoY+ebA==
X-CSE-MsgGUID: XVxbKoRzRzyKUx6El5S1nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="268472346"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 10:02:18 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 10:02:18 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 3 Sep 2026 10:02:18 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.11) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 3 Sep 2026 10:02:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J3PZ3A/yykKefeHpXynisC+QrtomF3TwTFd7Lj/yKoLF2wBCgXn5ACAIo0XvhE+ozksZXsWCtud+yDzoNatBFAY+QGVP3P/2YWRSXKj6jMScrG0aD5cN5ZcLarNFnJz8Gm/bXz1FBXVlN84DDeHp95lzfAxJ2rVF8nFaa9fQxc1Jfmp8ZWjNc+B6SUOTD0QwKVH6Vh8xulTHT1oFu0hWt3bfcZ6180lXmxQNVopQ2ecfJ56wn4Q477Mk0A8PseM8q/C45aNRwJvZ9ddUkRxMwoB1lyiM4I+NFBMNtelZ4MkdZvErfO45gYkgWDhJUM9ZWpOMl4nvWz+459cWXtMdZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+vAvhtKaBcLx+Cp8YXqGHptlroq9deAlvv2XlD75sY=;
 b=xQ5WM8sX0ufO1Dy122dCUk1NXkt8OD0uiSF3RxmgswsVOQwrwYldEwhT7d1sqUHlwVeESsQGobMqEbDaVy7ZO21PiXUVIg1w/wP8ICLnrTMwKLVUKbD2FF79SPkIMxfq80rOAArOb/kPSC5XAPbFdkglPvXF515I2wRRzfeuoM3NMSF2ROQRhrwBcJQEbPjhsTbe/7UB+xnX1poWUxha6avMxpilHiQ8cTfA7HjTUCrvMVRkKp1wH7EY0dQV4ano0kWNkHTFLDA2rKFSUnQw9ollmBtKSFP/+Rw4qZGy3hosRixLOJJ5x925yVA72uymT81+QoVQHoUYKoTj4t5e1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com (2603:10b6:a03:540::20)
 by PH7PR11MB6449.namprd11.prod.outlook.com (2603:10b6:510:1f7::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Thu, 3 Sep
 2026 17:02:13 +0000
Received: from SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc]) by SJ2PR11MB8370.namprd11.prod.outlook.com
 ([fe80::b6cf:ce77:3cdf:7cc%5]) with mapi id 15.21.0360.008; Thu, 3 Sep 2026
 17:02:11 +0000
Message-ID: <01d907ef-430e-4b11-b00f-342c21572ba7@intel.com>
Date: Thu, 3 Sep 2026 10:02:09 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/5] x86,fs/resctrl: Cleanups in preparation for multiple
To: <tony.luck@intel.com>, <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <babu.moger@amd.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <fustini@kernel.org>,
	<fenghuay@nvidia.com>, <peternewman@google.com>, <yu.c.chen@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1788452481.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <cover.1788452481.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0098.namprd04.prod.outlook.com
 (2603:10b6:303:83::13) To SJ2PR11MB8370.namprd11.prod.outlook.com
 (2603:10b6:a03:540::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB8370:EE_|PH7PR11MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: 944e5a3c-df6b-4d19-2588-08df09dd1888
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|10067099003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: f/e+GCwpDNcMLR50/fUhvtG+dS7EvepwrIPPatMylKyY+uycMTgK0FNK0DhEkTPJE+Tyfeh9aVnxjMnNZwTZsIWfUpz63GfqAzht00xDCkvZTlCGZo0YJO9nv1MEDRZ350r3QH1Vvlofx1OVPxWsN56OUYrsohQVJNKuU6HE4SdOod4C52RKgO9NUHjmvvnarv9cmR9FVaSRnMo8Z+pulRBqFIHa4hJTq8d6nHjYY7i1dH25IhcVXlFfR8iyvdyrclMfnPDDX2fp0qojUjh39nbHTZJfCrTPhOAGxDr5j9Lz6x0GkWxg7vzbcd9Z35Vu9uzUl7YSoiRd9fAzGmfL3mazyFUO0xLSs0hOVpytw4toR7dce+zvzUjo7zz5kyQPjg+OU4OHodQg9RDOCJdeAUVkT+SGFszdVY6czQW3sHy/lQkGhg/4BDPtOv704kldHh8x17mr1VF0HJzqKAs+nDgpOwCEG4WSbXqrN/XEKjWt/Ca5N9MfV6hDaXMboTs2xdrPBkEP1qjg4zM8XwDPDQRtdCZ575c3WdQqqQOsJ35PR4eAIA0OH0q3i1lpxHK/HJzF5bGr4Ia4AtjCe8U5ieTz4i/5sCdQfwusxBu7AmwkFtz+v0UIPS8vwsRO9ZOfLqpuEw4JOAw2vEMIyxOm0sLEO48S/V+wsYq5zaoEdd8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB8370.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(10067099003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGplaFdab1dJRkt3dHFoTURRcTBrS2RxN1h0RXFEbFFrUlFDYVJRQ21nRTRq?=
 =?utf-8?B?RlhlUnE4RGlYYW41bURiekV3TndPa0ZjZ0hncDFNNCthUVM1R2d3bWRZem5y?=
 =?utf-8?B?RUlJTzFMK0d0VjJGRjBYdzE3NGVLTVpRcEZaM0hRMlF4LzFRQ1dLT2h4bHdx?=
 =?utf-8?B?NThiNURLYmdxbGQ1VmdjMzNGd1FkVWtSa2FJZW91VGh4blgrSGIzU0JWcDNm?=
 =?utf-8?B?TTM0d2JjSS9URkh1dW1jdnB4YWxMa3ZXS3J6aUI3b3E2Y3p1WW13QVdGVTB2?=
 =?utf-8?B?M0hIa0o5L25DSkQyV21ST1Noalp6NEJTTFdhOGtPaTcxT0tQWFFrRUlaajlo?=
 =?utf-8?B?ZEhpM2JIVHlKdVdjc3ZFYUJnQlFWalVpeE9tSThyb2RjNmY1eWNoT1pqeWFB?=
 =?utf-8?B?Zk1JS0hTUHh1K2xLLzJVQVZCQkpDK1UzZGpmTVFTOGx2eTJacnk5ajhjeGlO?=
 =?utf-8?B?MGhhY3FHRlFuL2xEdFBnQ2wwV0I0VXZFNkdEbUVmazZwMFRWNnpNclFxOU5i?=
 =?utf-8?B?czNTWGU2N2FnQXd1UlYwR3JqclhvaVhEbXpZOWRhcE55b1JwaFZvOVJ3ZFk1?=
 =?utf-8?B?bzRtcmJGRnBhdXRQZE5Zc0wwMXBhNDNCOHdhb3ZqOG9ROFNUTVJkdnFidlhy?=
 =?utf-8?B?eEd6SWx1dlJjaG16d1A2QXNSN0JpeUFPRUcrV0JDUjRvN2dKWkJBcytGeVIr?=
 =?utf-8?B?UXp2U3hPTEpFdlhyTXNndVFwWnMycGo0dnVvQ25nMzJOQTZUWjFiWmNGQWlq?=
 =?utf-8?B?a0xmTlZCb0dKcXQyMDZjaWhzZ01RMGV3aGJQODI4dmxWVVcybmZhNVdpNDhG?=
 =?utf-8?B?YXNTMzJMV0RFaG43M09Ia1RiSHJkVWEzbkRtVDFwdHh2eUkxdHJFei90U3ZL?=
 =?utf-8?B?S2ttb0RkajBYR29aZTJvTWgxVmtXNXl5VEoxOERqNy95RW1WdXNqdENETFIr?=
 =?utf-8?B?NTYwQURYaWV2N1FSMTZOZ2hLNXhhMnJxN1VJbmRCS1VYVCsvTUF4VlBOK3NB?=
 =?utf-8?B?NU1OWmVQWSt4akVXMjNRd1NBK3c3aHl5RUlsVm9XMERMekduVkFiSkRiSys1?=
 =?utf-8?B?WXRydjNFWm93bVRhaERSWFZoRFJLakE0bDFzd05aaVpiY09walIzUXNuZERu?=
 =?utf-8?B?K0haSWJlWmtoYTRoK2NCM0lBWjA5YkcwTll4R21LK3hieDE4aC96RWJrL05O?=
 =?utf-8?B?VlVRbWsvTG1abVdJcXVVUG5jY1BqS3VITnJiNFhLK0tLWnRFNWxJZGM5YWdJ?=
 =?utf-8?B?WmZQY1A3d0M5V2tsbVpBYU5ac0ZSTWs0NmRoZldsYVV1dHJCMlRORFRSVHBR?=
 =?utf-8?B?SnVWVTc2RzA5NTUwaGh3SDRMbkJQU0pUQTNrTDFaV21EdkJpL2t4Tmg3UzR6?=
 =?utf-8?B?WTU3TFc0OVl6MlRFQ1ZXNEw0WlJteXkrQ2hTUStQSWUrL2p2bDdYRjU3MTht?=
 =?utf-8?B?VW03eWIzcHRSM2t2eDFiUmpXWVNVRWFxSHI5YXcvNmRWNGtVRGVGcmxPSG1G?=
 =?utf-8?B?Wlk0bVM1blpGbFl0N3V5b1BtY0F3N2xaZUZiZGY0Wi94RG1zM3BjWkNLV0x0?=
 =?utf-8?B?TUVpNk02UnA1T2pSZHdVUG5XdDN2UXB1bXFuR2hBUm9MTnNPaGc1VENXTkt4?=
 =?utf-8?B?bWRjM0ZSdU5jZ0dqSGFUSy9BckI4a0xONWVUSllwYUF3MTRpYlFxV1V5YVdX?=
 =?utf-8?B?YnlnME9valF5MWJBeWJiYkd1VXVoQ0JMbGwyVTNrZktCeE9jVWN1UFZiaThM?=
 =?utf-8?B?aEQ1Q0VaMlUwdElkbjhpdlhVY1Nvc0lmRk9EZGR4ZEJiVHVMUEVqWTRRTWdu?=
 =?utf-8?B?QTJ3TXlBMEgvZUhxQ3JlT0FBUkdyMnN2NjJZQWZ2R013K01vWmZwNC9qek8r?=
 =?utf-8?B?eU4wUWZHbTRFK3pkckRYT1RVcG9Pdk4vcWZRNUpIUCtSOFNYK1VXQUtYclQ3?=
 =?utf-8?B?MTFNYmV2aTM4cVEwMkhVZ0JtZUVISHFDYnNQZjZiQjJCeHBDRWFCOTc5OFZJ?=
 =?utf-8?B?V2N4QlJEZFRBQUt2d3k0ZDJLbUhtbVQ1MWFKdVdRSTd2aktpbTh2eXVnYjUr?=
 =?utf-8?B?RGxtQmVZN3d1enNRd0svTXBtN21YQ3ZjWG15R05WaUNndUo4WjVTdzdMNjY5?=
 =?utf-8?B?c2ZMdVVyMmpJYzc5ZGVuTW1ISHhaM3FNNC9iMVRNa01FRmJCR2cwUTVKUTRx?=
 =?utf-8?B?d080elcyc1pNUWhRYnA5YkxaUnJTRm0wOGdudHBrYjBaS1QrbElFNkJhNXZv?=
 =?utf-8?B?YndrOEVRdE54NmJZR1l5b0xOSjVvN0plcVJMNUdvb2t0RW1qcUtEanl3Qkps?=
 =?utf-8?B?WnZPN1luaDZnMDV4bUhUOERuajNsbVU4cDIyNGtrVnU5b204cndkdDNvOGRj?=
 =?utf-8?Q?1MM0C4cAZMrQkL7c=3D?=
X-Exchange-RoutingPolicyChecked: uHgZzZySvB0i+gccXTozDj/hemsfnIz+tFHehKiea0H7tGf0m3nLRJMBe8EPIxZ0KziUWLYNXOyiV9qZcmlD7RM6u+yIaU5Is09d/NbJLiI+hzEYQsA9wHGqUAWElFrha7jw48H8Ho0FtjJj/0CgbgaLi0WD4PvEGChrTqMgrQTe9WyCVcRKTAyVvQBEvA8ZEO0fhBe+6uv7x/KM+BLIa3dvZ9b/To39GeCegaP2l8jDIrSNXe0KU8l7wmPpRfbueGhbJGNmu8Vxxy3Z8D5KmiTQLxVyHQ8BDtabZwBUbBo4L5iPRla36yrhhhvduAKmc3/zjF4y45f5BK+dsuDqGw==
X-MS-Exchange-CrossTenant-Network-Message-Id: 944e5a3c-df6b-4d19-2588-08df09dd1888
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB8370.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2026 17:02:11.6344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RPtGcyvGj8ZDL8t4AVhLfO/8H9iyraM/YPfGaUx6OTg9PvxU+vcGfRF2RZ8rc+l9PHxqm6scSsGVlESLF4muYBh2QH/4Deai+GEXOKOm25E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6449
X-OriginatorOrg: intel.com

I don't know what caused subject to be trimmed. It is intended to be:

	x86,fs/resctrl: Cleanups in preparation for multiple controller support

