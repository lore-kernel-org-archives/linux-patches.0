Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E055678EB
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 18:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789063841; cv=fail; b=jEY4A9YxuAokQH5OxSeMmCXclcrTaTLebqiLAorB8LwZT8gLUKmAt+6KvmZuo90Dem0AKBtzInvJ0GmZTkFk7OgwE9FL8VRyQcR6HSvZTDqJBjmvmi9wEsS4LHzsGNNqWIbFXYhxls7PVvES6PYALT9BFihpKUHYAVtq4k66V80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789063841; c=relaxed/simple;
	bh=OlL3xTieIQzXL/96vKyoY+tGMm7IW1dNEYeBudMffkY=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fZgupkVS4T9jcRp750DWO95HA1syXziTIW4ml4G2Yk9r38t0thX02no0PesOe6GufGKPnozyo2E3WONloqnl0Yu0fpzKR4Sr/UfrvrRxSgAfFoeLjR2erVru/Ln5j+k28xYI35IozKOn67uGDM+Qht42+N7/snEF0eRcAHUO0WI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=haMRcCBX; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="haMRcCBX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789063839; x=1820599839;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OlL3xTieIQzXL/96vKyoY+tGMm7IW1dNEYeBudMffkY=;
  b=haMRcCBXuzQ7GelWsWQRDWWBvRF8d3kgOlf8KQ06fz+bPj62I/5WUA8T
   vWknx2e3EPEu+Wc50eNI6HZS0Nuy6FkyNwtj5+egyY5IY6+BAwsnvMCVM
   IHpilgAeiM+TTHXeQ5vLWwACDdzzHojrtwKxnqwFgaoeQ7Lymp22qOlcd
   BuKC0RV8fq7c2mFqQnVmEWjxKMcWe7ezGAgvyamwNaR6CQ888ZSs5OMGj
   7ErM+IZe3x2162cjJf+BeyWA5IEHHe0RQM673/RREAJvMwAjGND00XY5T
   hu9QoBE5H37uJZUFTlkiTONuIJUkm0GQPUiGKyJl9wcWpgjx91cr3M6y8
   g==;
X-CSE-ConnectionGUID: SUoZTimsQCmKI0RCjNc81g==
X-CSE-MsgGUID: l+w6hQNyTaeKOQY95iREmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11901"; a="77082982"
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="77082982"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 11:10:38 -0700
X-CSE-ConnectionGUID: t4qBXELgTRKCi1paiGhSPw==
X-CSE-MsgGUID: JxLP9imKTFCYLh97vDjQ0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,95,1787036400"; 
   d="scan'208";a="275479372"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2026 11:10:38 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 11:10:37 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 10 Sep 2026 11:10:37 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.9) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 10 Sep 2026 11:10:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V27Wr3BDG2bPe6nM/L+88i9knGPY5tmpwEQNjxewvCE70dLPJPAEuhBWt9ZYTsrhMGjaP6RBoDSXv06Q95MP+99AKtlVAjlfLZaucz57Apu5zgqPYSyXCOjbQrjWB5DeINGp+0JeCDmTFx1YG3j4/5GD/BW2OoaB9Zzn7LQ3rmKrKmtEOags7WE0Ahz7MFfmXM2BO0hb2mjkadsJ9MSusl8yqXRMbThHaEd4kfyRK1lntHR9Qe9UYMg/qHX3GhLgjnSgfDyq7yU7e4UyRg3BvcOCFkFPKgZDfsKHiPck5uBuMmCUuJyxTjfoaWF7wm1kr7JDA76hU81JfZHDHbTXsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTBkQ3Rsf6oXu02YkyDcKAdBpzteQ7LpCbWPhMpnnq4=;
 b=FJxE5j0sLJfQVbh19zdG0Ye+rXdnqUOlpxxyh1F8CMFhul7xCye57S85CW1B1CUGfboFxh9g3dTwWIuyeg72owHTQkCwgRZps/pxjDJlSEZZy31RQHymSRvF2S+3UeinX4rDjTGFpMUPnquLLack/zWthkVTx2+Fz8PCbK0ONT+9THzwWzkc0kma7z7kwNge0rjEVjv1GsI2iNb68069lfsgV8sCuLDRD9G4FDMUOoDKUA2zNbN7EoUMYq2krENUZJWW8F0FMR6MvcgxjN7ezza9gW2IjB0CHr4PIWV+yUNhI2o8eTI3sgT+YpAS2UHh5uZJXcUUFsbleS8O4Y/kQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20)
 by SA2PR11MB4939.namprd11.prod.outlook.com (2603:10b6:806:115::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.7; Thu, 10 Sep
 2026 18:10:35 +0000
Received: from IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6]) by IA0PR11MB8379.namprd11.prod.outlook.com
 ([fe80::549f:e4b3:e10d:aaa6%6]) with mapi id 15.21.0406.005; Thu, 10 Sep 2026
 18:10:35 +0000
Message-ID: <071d3dc6-6c18-4287-af26-719b89304058@intel.com>
Date: Thu, 10 Sep 2026 11:10:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] arm_mpam: resctrl: Separate MPAM domains
To: Ben Horgan <ben.horgan@arm.com>, <james.morse@arm.com>,
	<Dave.Martin@arm.com>, <fenghuay@nvidia.com>
CC: <tony.luck@intel.com>, <babu.moger@amd.com>, <yu.c.chen@intel.com>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <85ca29e89eacf12cfa7071249419e7cadb8f0691.1788220029.git.reinette.chatre@intel.com>
 <0b0eef2d-ce3b-48c8-af08-5889e7396e4f@arm.com>
 <a492ffb3-c12e-4986-8f36-c907382c67e5@intel.com>
 <96eda554-64a1-4f1e-9608-98cd106b00da@arm.com>
 <a3cf9362-007d-4c6c-8f6f-1c9b8b41b1b9@intel.com>
 <ad1f8ed5-266a-4d79-91ef-ad8ab3febfb8@arm.com>
 <26e294a0-76a6-4ec0-9df8-021a76bf8ed9@intel.com>
 <86603611-b20d-4a0a-a247-8cebb11b3432@arm.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <86603611-b20d-4a0a-a247-8cebb11b3432@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0316.namprd03.prod.outlook.com
 (2603:10b6:303:dd::21) To IA0PR11MB8379.namprd11.prod.outlook.com
 (2603:10b6:208:488::20)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR11MB8379:EE_|SA2PR11MB4939:EE_
X-MS-Office365-Filtering-Correlation-Id: beb58f83-07ee-4601-ef01-08df0f66cf5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|23010399003|3023799007|10067099003|4143699003|6133799003|11063799006|56012099006|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: hnY+6+/FtzQGUZIdZ94d7AskUhqnpKKz+sAfR1FJGiYHFHwmjB0Bn6eo47Rmp/cpOPcbb9R4nb31GikPbW3Y8wXkDu1DwAt4hYjFQVFfinDMt8CwWTh6saAiU+YAZ1Hfz9gjJ34gh0uqV8fR4OcN8swGy57eNaBGkrFKZ3TiEc1Qq0zneby5GGv0BupRO3QRUCy1fXmEvetXfBcOqISUqNdEXfu3jbE/t0j15cxPIcnXXkWG9aR+abawe649uZiWsXlgY9R0vmWb02+Nk9o6/1sO4aUdhc6oboaa/1Q8HGW54SuO7wMr45eUHcZkv+89D5Kc4SGO7QovJVzSjSKsRyKTow/ZIh1jo32bkHTOWH4CS7FRPMNxDAAUbrsJFZJXWjeDARIlzCKw5ZaSrxQzMGyg7w+OqpW5FPtMeE7zEHU99B7Da6QcHZ6r3r6Sh0gdfNyQvfXdkTZJgaqI+vLoAXy1ZJgci2J31MtVc7ksAy1fxf+0zbzzBjsNE1kwNXTA1OT7q/HTMMxq2yT1ZqVK2S7nwXkpqO7vSXFTkBTxoiBhodFkIlrPekf6EEAkw0DlwPFsXWVN3pVTfKhKVUuIfVy5UDJ4e+iiXFENMULRIdHFflDYT7htGHq88pL08InnwQV/nzSrhyij7F8+j9Vg0YP8KDzaRJUaEYJXdAwN0CY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR11MB8379.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(23010399003)(3023799007)(10067099003)(4143699003)(6133799003)(11063799006)(56012099006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aUxaOTNYelNOQXpXTlNGc0dIZzBzZXpGQ0ZsY1FES0Q2M29zVWdUaisvZHoz?=
 =?utf-8?B?MjlVVHFmTWV1T0wzZDhQMU9kcGJoL3NrYzJHa1IwZzVkZzFZWmtmTVpQUE95?=
 =?utf-8?B?RjZCWFY4VWxieHlZZTc5RnNidlNzdXh2WWRFM3UrYS9xTTdUQ3g1YkxOT0tm?=
 =?utf-8?B?b1VFRTR3WCtwMkNVL2k5U3hBaG5GSFJpelRHN25qTHcrK2IxVG8zaXBQZCtF?=
 =?utf-8?B?VncwbSt6YWVuZ1VEQjNGcWxiZ1B4SHVwZ1FIejBjMWdEVExQQjlzK2VWdXhp?=
 =?utf-8?B?VnJSUGwrcnBrTCt5UFIwTmlQVWNaVDlncDg3WE9yejRaaEZNNmI1RUNIWW1y?=
 =?utf-8?B?VTJOQXRZVG1kK2o1SVlnVExkbElnbjVCYnV3TUJscGQzalhEdlRYUnh2alpF?=
 =?utf-8?B?bkJ5bFN5YW9Ha3QxdjF4WjltTDJId1dXRjFZb3VWcmlrQzRYNy9GQ0FwU01S?=
 =?utf-8?B?VXZPUWc2TlF6VSt2akdrRVkrcTBkWlVYZ2EwRGNUTENIekVHREhqLzhDWm5v?=
 =?utf-8?B?N3N5Ni9hdkNiaEN2Y3QrOVBpYVFHZVUxcVJhbzBEV0lzSkpnL052Y3pDTDNo?=
 =?utf-8?B?RytybUI4TXJVeGRZeEQwNXhaZ21GUVdZMldOTkNSZ2NGSW05M1I2V3A2elRW?=
 =?utf-8?B?cURybzNwQkQ2cFBkbXBTalJSNythL1Nxa0hPN0Z1bkVaQ1ltRWZMajRMclJ5?=
 =?utf-8?B?OFl0TXBTb29peExuYmUzQWUrUEsrdHRCWnBXM1duZkRuRWVSVm9LRGRuckRw?=
 =?utf-8?B?Q202ejhRQjIrZitnam9HNGt2TnZEeUh5ZDFjYU5zaTZjenRuK2UxZTVTRHpK?=
 =?utf-8?B?ZGVPa05CQVdVYzZzbW4yaEZQNTNCSmJFcEtBTDZWU0R1aW9xUm1yVld0aXds?=
 =?utf-8?B?SjR2NitzaEZiKzU1ZnpHd0VCWkpSWUQyTTFyTXFsYmQ0NlgvVURyVXlWaVc2?=
 =?utf-8?B?UFBjNG96ZmRPWVpjLzFVd0pJU25ibC9wT01ZOEtXSzU0QUdCWVo2a1MxWlFH?=
 =?utf-8?B?a2ppZ1NIdG9weTJ4WCsrMjUyM2VvYThiNGQ1UTdVNG1vMHIyUUF4M0NXUnN0?=
 =?utf-8?B?d3VnZkdORTd6aGRxZTVXRStPQ0l2akdncWFBZHovOTVobVZ1ZE5KUVJ3aXVI?=
 =?utf-8?B?akhKSWU1bVZFSHBTNFA2YXJSRFdCS05iUmNmY0R1MHpFRXFxUFJKTmNVUUJP?=
 =?utf-8?B?SW1JbUozTnFSYmRPcnRLRUh1R24wc0dNZVAwZ1lGZUxsQUlFWGRaQ2owS2d3?=
 =?utf-8?B?UzFvTEZZd1c5dHUwQ1E1d3hMWmVMcjZOQ0VtaXBMdFMyTEVTeHg3S3hMYlF1?=
 =?utf-8?B?Z2NSbHpFeUNXaVFHeXBoRlNWTk01QkhGZFMwY2xVb0ExV2pmUXpvcktyUklv?=
 =?utf-8?B?cXViQXhkQkJoWFgzUlR6cXBOanIzVjFOaHgrNENiRlJ3VUE2VXlkaDZ3QkNO?=
 =?utf-8?B?Z01Wd2VWdU04Q1Nna2M3eXlHZTd5S2pxKzRNRWJOb3Vsa0FuYWttSDFjbnVn?=
 =?utf-8?B?OElrdE1kT2lKelU0L0NzR0kwQnF1eVRhc3hKMEVjM2g3dzhGNHNPVWFnTFVQ?=
 =?utf-8?B?cDVRV1RRZFpWalVWaUhvaWwwbnJ0UjVvZjExODhBSmp4eGo2QTIwQS9laDRt?=
 =?utf-8?B?Ukp0dGgxdE9KVW83N09NK2c2dFgrMGtXVDAzZFdCcXBPQ2l6cFREbjV5SDRY?=
 =?utf-8?B?QnJvbWdFeTRjanBPSWlaeS9lLzZ1UG5ySXNDbEVqNUdKdW9reTNkVlNxc24z?=
 =?utf-8?B?RHlFaExxdUhpT3BzdmgrNWp0Y1UxQkNRb1NTK2dFbWExbGo0NDhSY21tMlN4?=
 =?utf-8?B?VXBFZktzQ0hSc2NoTGpDRkRTN1FsazYwMHFIblVBL1JaeFFzTXcydUN6NHhN?=
 =?utf-8?B?cVl5NmRPdFZnQVhlcDBwRC8xTENMalNuQTJuRHRVWTVpWk96ejZrWkY2WFV1?=
 =?utf-8?B?dTZ5eU5jWmNYQkJCNWsyYjJRcFNjbGs5VkZDVU9ZTG9LVnc5ZC9FMDFBMFJ6?=
 =?utf-8?B?ODlGTkpNUEZrcWRZZU5UUll0NHRreUlseWhZdG1YN3JtREpXOFJEQUpkVW0v?=
 =?utf-8?B?dXJkS0k4M09NakpleUpkaE8wSnh3SUhtaXZDeTI4Yjh5djBFUk5XeWY1K05s?=
 =?utf-8?B?YlRiYk51QVhXc25TVXNyeEV2VnFxQzI3T2cxbWhORFJpU0RLejJhL1ZMbnBM?=
 =?utf-8?B?clg3WDQzWVdSRjIySGxKN1NydW1TTE5LK0twWTJTbW9Ka0lqOEZhcFRtZ2Ju?=
 =?utf-8?B?eGQrMUNiZnFFT0d4aTVXMGZSSWI2bFBKQ3dZL2hWajB5NmJKRjdRa2pka1p5?=
 =?utf-8?B?UnVscGk0TzBRUXJLdFQ3Y3MvM0NlZ2lnWmYySFFWODA4MmhPcWNnUGR5Z1lo?=
 =?utf-8?Q?FSCZYiu/WCMG7SbU=3D?=
X-Exchange-RoutingPolicyChecked: s0AqEdrMAjoBI969A6iKAJ+Q+wvHnJt1GlwuYJJ3YfsCpi9Og+ykS57Q+YFpWGOrihb+PN0nTyaSY5ulqbGC52zDqbZF1nIyM9oLjAuCMnu7XAeKGkbbPduQzrGVWdjAJqVpLIk24Gs3ls3R6Y2S6yL7Kfy4P3VgTZjg/pE9RH/SfGbN/sDXjseicBM2PT+yhebEX8UVhHqEa8oLUeuiMPerttRo3IYq8humgKF3e57B3bS/bdXM0psAL4Ff00pN0omg63KH2+C4oq72BRevJZWNUCEIxyXlKFRGG4f9c4rEwPUfvU/EEccVdyfWpKLnx7EPjVkg3ML/iWJ90Ffd7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: beb58f83-07ee-4601-ef01-08df0f66cf5c
X-MS-Exchange-CrossTenant-AuthSource: IA0PR11MB8379.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2026 18:10:35.2192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9i9NTmqkxhV8ID+Lusdeq2chXq1fuRwuJCoxgw5kkD+CA1iqGIBkq4Hli2bMvXJ1edYFEZpTpVWWYAIjTfpdpq/laupgkJ/LafMdp4dEg2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4939
X-OriginatorOrg: intel.com

Hi Ben,

On 9/10/26 9:28 AM, Ben Horgan wrote:
> Hi Reinette,
> 
> On 10/09/2026 16:37, Reinette Chatre wrote:
>> Hi Ben,
>>
>> On 9/10/26 4:11 AM, Ben Horgan wrote:
>>> On 08/09/2026 22:12, Reinette Chatre wrote:
>>>> On 9/7/26 10:01 AM, Ben Horgan wrote:
>>>>> On 03/09/2026 16:29, Reinette Chatre wrote:
>>>>>> On 9/2/26 9:10 AM, Ben Horgan wrote:
>>>>>>> On 01/09/2026 00:54, Reinette Chatre wrote:
>>
>> ...
>>
>>>>>> It is not clear to me if a mon_comp of NULL is able to handle all scenarios since it looks
>>>>>> like mpam_resctrl_get_mon_domain_from_cpu() and mpam_resctrl_online_domain_hdr() does not
>>>>>> consider the component at all. Would that not cause monitoring features to depend on which
>>>>>> CPU of a domain comes online first?
>>>>>>
>>>>>> Could mon_comp perhaps be required to be !NULL here as a replacement for the earlier
>>>>>> "ctrl_comp" check to ensure there is a component with the CPU in its affinity mask?
>>>>>
>>>>> Doesn't the !any_mon_comp check provide this?
>>>>
>>>> This is the part that I do not understand since any_mon_comp seems to support the scenario
>>>> where a mon_comp may be NULL which is a scenario that I do not think resctrl can support.
>>>
>>> Ah, I see what you are getting at. As the monitor components are only considered when there topology
>>> matches the l3 cache (same cpu affinity for each instance) then the find_component() call will never
>>> fail and so mon_comp can't be NULL at this point.
>>>
>>>>
>>>> At a high level there seems to be three affinity masks used by the monitoring code:
>>>> the CPU affinity of the component belonging to the control resource class, the CPU affinity
>>>> of each component supporting each monitoring event, while these are three separate masks with
>>>> code sometimes treating them as though they can be different they are actually required to be the same?
>>>
>>> Monitor component CPU affinity is enforced by topology_matches_l3() to be the same as the L3.
>>> Additionally, traffic_matches_l3() adds extra conditions that mean that there can be considered an
>>> uninterrupted link between l3 and memory and so an MSC at either end is effectively the same. Namely
>>> the same restrictions I've mentioned before, only a single l3 cache, a single NUMA node and no
>>> intermediate caches.
>>>
>>> You list two rather than three here? Possibly you are also thinking the MSC cpu affinity which can
>>
>> I did mention three masks. Thank you for clarifying how the one mask (the "ctrl_comp" one) is associated with
>> either that of the control class or the same as the class associated with the first event. 
> 
> Ah yes, I misunderstood.
> 
>>
>> Regarding the other two masks: it seems to me as though the CPU masks associated with the two supported events
>> are managed separately. This means that theoretically the class associated with QOS_L3_OCCUP_EVENT_ID could have
>> components with different affinity from the components of the class associated with QOS_L3_MBM_TOTAL_EVENT_ID. A CPU
>> being onlined could thus be associated with QOS_L3_OCCUP_EVENT_ID (resulting in mon_comp being
>> initialized for this CPU) but not with QOS_L3_MBM_TOTAL_EVENT_ID (mon_comp is NULL for the same CPU). In
>> this scenario, "any_mon_comp" will be true and the domain created and onlined while it does not
>> actually support both events?
> 
> Hmm, it depends what you mean by "theoretically". In mpam_resctrl_pick_counters() the class to back
> each event is chosen. For QOS_L3_OCCUP_EVENT_ID it will always be the class at the L3. For
> QOS_L3_MBM_TOTAL_EVENT_ID the topology_matches_l3() call will check the cpu mask matches the L3.
> Does that answer query or am I missing something else?
I mean "theoretically" because it seems that the CPU online code (specifically domain creation) supports
the scenario where these CPU masks of the two events are different (mon_comp can be set for one event but
not the other) while the rest of the driver seems to make an effort to keep these CPU masks identical (as
you highlight) and there is not actually support for them being different.

The planned changes discussed here are for the domain creation and will touch the code handling this
scenario. I was hoping to just change the data structures while maintaining the current flows as closely
as possible. I currently struggle with maintaining this flow that can never, and more importantly should
never, be encountered.

Do (admittedly crude) guardrails like below capture the existing driver requirements?

diff --git a/drivers/resctrl/mpam_resctrl.c b/drivers/resctrl/mpam_resctrl.c
index 9d223057953a..dbd06371890c 100644
--- a/drivers/resctrl/mpam_resctrl.c
+++ b/drivers/resctrl/mpam_resctrl.c
@@ -1681,11 +1681,18 @@ mpam_resctrl_alloc_domain(unsigned int cpu, struct mpam_resctrl_res *res)
 				continue;       // dummy resource
 
 			mon_comp = find_component(mon->class, cpu);
+			if (!mon_comp) {
+				WARN_ON_ONCE(0);
+				err = -EFAULT;
+				goto offline_ctrl_domain;
+			}
 			dom->mon_comp[eventid] = mon_comp;
-			if (mon_comp)
-				any_mon_comp = mon_comp;
+			any_mon_comp = mon_comp;
 		}
-		if (!any_mon_comp) {
+
+		/* hack */
+		if (!cpumask_equal(&dom->mon_comp[QOS_L3_OCCUP_EVENT_ID]->affinity,
+				   &dom->mon_comp[QOS_L3_MBM_TOTAL_EVENT_ID]->affinity)) {
 			WARN_ON_ONCE(0);
 			err = -EFAULT;
 			goto offline_ctrl_domain;


Reinette


