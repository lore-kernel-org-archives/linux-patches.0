Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8590518786A
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 03:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755143773; cv=fail; b=miA+lnYZqxY/6CifWm8Lquwg7c71RwYdVOwHzQdWz1Q+pLpunWUKunVReKuyx9o7rdUapiERmOp2tsthAqag8WjOtgFg8UuuNTaz52AcyQTLyS1AcQp7onqHkbwNc3XRk3D/e8vPOFxGevRVPY5n6mapJK5Pm2M1YpwirolOK6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755143773; c=relaxed/simple;
	bh=wJbX9oNXVVSkI++OrQ6VUBD6z5flTT/TGC7dvzRFt3w=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SHI+CWjNZyez5GlHP4eh4E2z3NfIho6TmlbhH+f7h/3x+hfZVLcmn89M/3an8Ppmf8tcfm2r3e0b+vtArTDKs7miX5ifhC6awktrJMVrWgJteXcLkvykb56SlP4Ez2TkGGvpTP3WTHeyLr0FKrRYQ57Lin2xy6Yl3PquhQVhGEg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cp2ShkkA; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cp2ShkkA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755143772; x=1786679772;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wJbX9oNXVVSkI++OrQ6VUBD6z5flTT/TGC7dvzRFt3w=;
  b=Cp2ShkkACbSOLzMp+Kz0OaPcNDMTA9j7bOuHZi4tt0VOM3UwD7GQtqif
   y4scXfS731RiAQiONY5o0AExNfvCoPBpGyqfPSsFHVB0zO6vkuD1sWS3T
   WqqFz/R8ekVv4wLfJY7cMlFFE1ZlstcoyvaR1RP5EDgcfyMrYUXUNv+EE
   huFKRxfau7AZs/I2Ps5DNH8sjSyvksezPCL07PqbTYcuBYAmA6Gde0CYq
   3uexAvYkJkkmBw/R4dSngrttZR/zDqw197O/wneGQ3ZBMZxgFf2Ewk1Aq
   6ndQwWJpXFS7BaOHp6DaAopVbZOAdJTrlZ8ciQdXkAtRk+er8u2JnCXny
   A==;
X-CSE-ConnectionGUID: bwGwL3DwQICpHBIjoeXp7Q==
X-CSE-MsgGUID: rqdPDAuLQWyXBCtI1lmf6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="68056706"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="68056706"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:56:05 -0700
X-CSE-ConnectionGUID: MR39KHzkR9CzgcvpXiPvkg==
X-CSE-MsgGUID: hzerghawQLe0SeLBeTmFzw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="165871969"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 20:56:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 20:56:01 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 20:56:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 13 Aug 2025 20:56:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u3lZT4SoYrgM9jEKulgaw5QIcYKyPgUOXRrO9s3Rqqw4PTIKtvcWWxMszyhKAIRcTkrXiiDS2SbTecwqv+wauRTWgSwXDiHr3PBhk4KoSK3zSdjFaw4CiPFCl9naTwRNvefio9KLom4DfkrG2PkvA6JgLy528F3MODYLugtXU17VWjqKdWQRL2FXwkePTvxsUyRL3dtgzLqHHQax/q3GlGc1RkOByiwRGLPsgfyKj488qQb67q2Th0vZj9YtTYL7mrAXsLHvmOn/TdPhxLzKPjgT9bmlChsyOGgEXwUbgANynUDesbe+BFnts5gTSCrsJjxzPXTtfV398LZAEFElzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0I0TSe/cAO+HOnTq8bYl+VSWlDE8Ztwj21XY7lw3Ce8=;
 b=pw3CTc5AdcczCtGKSclG1KBzJX2z8kYicjCKz2dmAWOg2viKi3yGiRAefCUqbj11JDN3M6mnjU+JR2MY3vEyR+RPuQTygld9iAMM806asfmzddRg+z6F4ds9KSxgX90Fp/iXK3SLveeS5B1KLI0hUVkJulK+K2hAHVE+Qy+wDzM6xrm5l9gRTAs3/99Av1KcE7BQEinxzK9A1NXd67NuHvFiA+so5TgibGAPVOQgNJC1pKzvp2e3/AuSvds1UBdiqEX1JGy21f2OfKRqYuGof1UZBizQhBnlctUPlfgjPXsA5MisgyzCItkRBVd0eeAfBzo30JbH4v4/1iacys7dmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ0PR11MB5198.namprd11.prod.outlook.com (2603:10b6:a03:2ad::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.17; Thu, 14 Aug
 2025 03:55:59 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 03:55:59 +0000
Message-ID: <7c2a1c79-7ebe-48da-ad39-11bd3cc7e6ac@intel.com>
Date: Wed, 13 Aug 2025 20:55:57 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250811181709.6241-1-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0295.namprd04.prod.outlook.com
 (2603:10b6:303:89::30) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ0PR11MB5198:EE_
X-MS-Office365-Filtering-Correlation-Id: f8f08f67-bd4f-48e9-5f06-08dddae67a81
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UVJHZjR3ekRtNmxxTkZOYVowQmMxdm40S2lLdi9zeEFsdTNXdDArNkQxOVlZ?=
 =?utf-8?B?K0NrT3JpdzcyQzRFKzFDY3hXY1hpUzl3YjFnaU1CeUR3MjVESS9UcElWdjVS?=
 =?utf-8?B?NlVCUUdzYkxCVGdOeWhOYUVhKzlwLzhyQk1LVmEwbUhzYWZwSWtHaGVGazBT?=
 =?utf-8?B?citLRnhUOGpLa0ZJcUoyZS9tcW5KbWZsNks3dnpZeHVwOGRoelBlTm9DZnZT?=
 =?utf-8?B?MURLazF6WVBFYVE0bk9OK1M5dmZjYjBReE5iYmVDdzRrcGxQWGJGNmhQRmVo?=
 =?utf-8?B?c0NPMk9OZ3FMTGpKNmlmT2tIVGJudUFIV2s1N0tjYklXYy9veXk5Vjl4dW9K?=
 =?utf-8?B?UG1KRitzZ2lwSEk2bGFTNDFDUGpSUHhpTGJML3pmMUY1MkZ5endWR2FsNTZN?=
 =?utf-8?B?bVpUOHE2RzcrQ3ZwTTBwMC9IeHUxbFBlakp3MVhsZi9JM1pFQTkzaHJuaGVV?=
 =?utf-8?B?aFJ1SCtkWkNKMHVxc2Jpa2NKN2F6VzU3V2Ric3BZTEZTWWNVTUVEZHRpSTVT?=
 =?utf-8?B?d2U3N05pUnd4OWorb0pDKy9tdFBIRElzZnpFVzRLdUc5eDJzYjE1djJyNmtQ?=
 =?utf-8?B?M3ZXQ3lSeGMzM2JGU1EwZ2UvTjM0b3U3YXdWN1RwM05NZ21OYi8zL0RvNU83?=
 =?utf-8?B?dmxrSFVtM2ptdEZlWEdjTXVrYmkzWjNXS3F4eDlUdVpKSFZDQVI4ZnZ0dE1z?=
 =?utf-8?B?NnN3TVFqTkNtOUJhaWs0dHRpM0tmT1BjTzNidXo5NitPWXVwM2E4dnI3UUtv?=
 =?utf-8?B?SmExdzNMVDJYU2FaQnl6U3hseTA1OGgzajlMbTNVTllXMzBWSzM1TzF5elFP?=
 =?utf-8?B?bDJaNkxZMXVCQnNjZXlmWm1lWDJiMkdycW51U0xOZ1l6bjBnVlFpZm1zYTVI?=
 =?utf-8?B?cVgrWHBCVzgyRGxqdHE2eVhuK084SmFaUWVVTytSQmlrRldYYnNzU2puRUdi?=
 =?utf-8?B?RzdWQUExdmhDemRxNTh2Nmx1VGlodC9WTkw3dUdmZDA4VlFRY1h0a3lHL1hv?=
 =?utf-8?B?Y1lYM1pqN1YycGoyWFF3KzhTT05sbUhDTnl6aXJ5QzFQT1plTWVmeEw1NVZr?=
 =?utf-8?B?dkRpSDZrSWRkYmlLYW82NlB2NGhUbUhBVUVaNnZ6czVpQ2EySnZydkdqVWdk?=
 =?utf-8?B?MXRNRnk1cjlOMTdlV2Z1QkZTNExMRXNPcFh5MzNTVVlyelV6UnM5WENsN0d1?=
 =?utf-8?B?anZWd1prR2g1SjBnWmNvU1l0M1E2ZEdqTGpZUy9JSFVaWjk4aSsyU1NpMUtR?=
 =?utf-8?B?WDJrajRvcGNiT3VROVgyWnpNZFNWK2pBak5DTnRqY2I4azhhcUFVTkU1bzlG?=
 =?utf-8?B?U3ZsQ3VRb2IzL2pSVDlhQkNEdG9Pa0ZoN2ZwSWV5RVloL2ttcC9yWUdydEs3?=
 =?utf-8?B?SkVjeTBqam5FNnJTcWxCVkZSRFg2aHlUS2t4bmFkSXhpTjJNOHU4aVBSKzhQ?=
 =?utf-8?B?OHVKTDZaYysrVnRkS3Byc3J1M1E4aVlJaGQzbXFoMk5na0NmbmFaZlVSRGh3?=
 =?utf-8?B?N2VaYjdhR1paaHplWk8rcUdaQllXTGFxM0xhUTJXOHE1NzlWQ1M1WEVNQmVC?=
 =?utf-8?B?dTJyT1dhamhyZTBxakRESlJzNU5hVlM0TVJHc3dpeVBWQ2xuSGV3c2Y2VTUz?=
 =?utf-8?B?cE5vb0hDcWRtaHlXT0dhbmNuekUxSjh6NzU5RFJxRERlQ3RscmJWVWVIK3NB?=
 =?utf-8?B?VnFQaUxWbURNcmZSK3NVaUsxa2ZIZUlXcCs5ejllV2VDQU1GNEhKV2dUM0RV?=
 =?utf-8?B?WkZLNktxWWVnVWxIRzB0YmJDbGJxT1RwbnpkdEcyU1FkSlRLQUdDenFRS2hy?=
 =?utf-8?B?NW1obzdRQ2k0Qm94T3RLdXJHRVZDeVh2T2tQbEZNODE2M1c1VmZVaDdoZ3Vh?=
 =?utf-8?B?MXZTc1UxWG9DS0ovbVNCL0NxZ1lLZitWMHFjN2pCT2VPTXdyZkJ1RGNKK1Zz?=
 =?utf-8?B?dms0RUo4bnAzSTBpeUhTTi9ZeTBtdEd5WUJnNDhqQllpRXpCVDlIYWZFRkF1?=
 =?utf-8?B?cG1IU3M3ZjZnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TEdGU3gvc1ZkUzZlVTU5NXROd0oxTDhTNHF2TngxN25UUnp2RzhvakRMVnBq?=
 =?utf-8?B?WDYzRlJNa0M1MCtQUGpvMXhlalZ5ejZOTDlPOWN6bTBlVUpvV1o4dWpWWkls?=
 =?utf-8?B?VENsMWVJdzUrZzhDcHJQcVJEdjNQWkdwVVpnN0x0b0VhS1YzWVNOYkd0bjVo?=
 =?utf-8?B?cVVEOUtXZGdmSlZQcXRRcEdjODNYNlNnUk42Qlc4UmwyaE5DTDhLT2FYcjlw?=
 =?utf-8?B?TGljbkZiVlNraEM4dHNKVnFQdkdkekRLVUF0SFRCbTVRUU5ETDRWb1RDOUJu?=
 =?utf-8?B?cFJCVTR4SW5sRy9ZVzVhZ3hZQzlRc3VUOUFDY2dMVGxhRjgyaGc0Umw1NEdQ?=
 =?utf-8?B?RFBobURvM3Q5Rk1neCtUVGJ4TGtpalVVU2NwblNJbHVpV2VjWmlKRGdEc05z?=
 =?utf-8?B?dWg0RTdacjJ1WXZtTHcyNkdOMHhSTGZ2a0FMMFRSWm1ER1pRSVNOckpLMTAz?=
 =?utf-8?B?K1RleWx1UXdpTzY3VjRBdDR6QmhCV0JsOWFBbUFEMG5rVE9Cc05wT0dKV3lt?=
 =?utf-8?B?QXVacjd1RytsdzlCOW9OVTA4MlZHak9USGJTUTRaU3RiaUQ3K0k5bW5Fdkpa?=
 =?utf-8?B?bmd1WmtjZTRkOG9vNldlK2greE52WDlPdGZPMitXc0FKdzBaUUIwWGgza1h0?=
 =?utf-8?B?MnFjVmVkVXo0TlpTY216UzkxUjZ2emJnU2V5VXQ2SS94ZlpFV1FWLy9TOUht?=
 =?utf-8?B?MnpzU0piRzB5bSs5V09MQ2pZM0NzOUtXUVZLV3BQbkE0WEtyREtxWXFXRWZy?=
 =?utf-8?B?ZjJNeTZEOXhhajVWZnFpMHNCTHYvVGNNZVUra1I0T2xMN3NvbXpqWmNQUEZp?=
 =?utf-8?B?b1FpVkxGU2gyZk5tNGNXSXBKdi81QVppaWZONzJqYnU5WE0xc3o5VmQ3UFlp?=
 =?utf-8?B?RG9YVm5TZjJXenVsMGN1M29LUDZvci8vYVV5Z1RJbUJ5LzZ5amRvQks2ZHM5?=
 =?utf-8?B?MEhHRUhWSnhUUytXd1NrdEQxbDAwbVlQOVF2LytoUXB5N2NYR2Y3WmhVMVFk?=
 =?utf-8?B?UW5SUGpEVk95eUMwaUJBYmRqZWcyQnR1YTVqZDVtaWN5Qis2emtpcURJRkFY?=
 =?utf-8?B?SFNEbVpLVTF4MmlKUXJxb2tJN1dZM21BbHdXNU4xTTBnaU5CemFNM0hWMkg4?=
 =?utf-8?B?amlIZzVtNEZ1eXpiNnljbXJqVThwMWtYRGVROXp2eGUySk9KUFZ5RXREWFZG?=
 =?utf-8?B?cW8wdFpjbC9WTytuWmdVSDBWMGVwMzdnbUtHY2Nub2dmVzJKTTZBMXh6d1lq?=
 =?utf-8?B?R2EvczV5Z1FBbjBXcjlhQXRvVVc5THdhS2FRQUEyOS9XUVlkTG9oZmdqWk50?=
 =?utf-8?B?V243aW5RVkVJRnVqOUFWbjdEdmVTd2tFWDJhenMyRnpkblVjSGdTMHQ2SGpX?=
 =?utf-8?B?dkZ5N3dYbXkxUHRRTW1mVFljM2F0bExqWlBXMU1YRThJUjFHZ0RPcEZncnZH?=
 =?utf-8?B?UGJwTHU3Vm1aa3UxQitYbjFkN2NRdVphNkpTRitNb015YldOc0t6d0t5MWdE?=
 =?utf-8?B?c0hLakVPRDE0dVhBRW51Smd3eWt1YUVBUDM4dFY1bklCemZ1dng3dC90K2RS?=
 =?utf-8?B?LytMcHFzbGpSeTY5RmNPQkVEVmY5RGxSbkg0YkZUQ3Y5Yzg1c205blFuQStp?=
 =?utf-8?B?TXQybmc2VXNZK0IyZE9sQ05tVHR4ZnNvM1A1alhuaGRJQ1Y3b1FZNE9RNnlW?=
 =?utf-8?B?VlYvckUwMTBHa2lFTEdZZHVHd1JpUklWVnRRQXA0aVlaWkhYU1BPbVpQNzFr?=
 =?utf-8?B?RWFaYlpQbzFuWnNrcnBWZzR5c1JLUUFudTkwVHdNaVFEUktWSGVwME1rdzVE?=
 =?utf-8?B?eTR6YWd1ZlpIaTdTS1F6bEVlaFFZeDlnZHBkSG9UczlCVEE5R3lOMExYNFl2?=
 =?utf-8?B?L2E0M0h5Q0syZ3FSa3loMzIxdkVkUUJPd1ZXUWJCb3NWdVpta2FxQXhWUkh3?=
 =?utf-8?B?UnpxU2FhaDJUQkdiYiswSGpuY1o0V3dsa1EvQTEzV0FNYVpsS3YzZ3pZUXZx?=
 =?utf-8?B?VXg0N0F6RVR2eHUwUjQvK3UxMnNQNnh2OVprU3B2MFF1cWwyYmYyQy9BZFNz?=
 =?utf-8?B?ZmtZSWRVTHlMMnRRRmRmOW5sclh3eW0yZ05kU2pwdDZSZ1dsQnV1TmtYeitC?=
 =?utf-8?B?L1BGK0t1N3I0RjhhdmQrN09ETkhLMmxXUytKYnNnai9SOU5tbDd5Q3NqL25a?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f08f67-bd4f-48e9-5f06-08dddae67a81
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 03:55:59.1207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jE2ZOA3ECWOa3u3/p4hOqwgk9Zh8mnuO+GMp6os/7pxvfWCZMwEsH/z3+/wgn6hJQWvS7Bx7s3G0fGhsXSqBDjDXv0bqb4JF/WdTzKrox60=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5198
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:

...

> 
> The INTEL_PMT_DISCOVERY driver provides intel_pmt_get_regions_by_feature()

INTEL_PMT_DISCOVERY -> INTEL_PMT_TELEMETRY ?

Reinette
