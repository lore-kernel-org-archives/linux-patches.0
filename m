Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52012D9EE8
	for <patches@lists.linux.dev>; Thu, 23 Oct 2025 17:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761241819; cv=fail; b=kynxwhhnXjvkNChGXDxjGvB3u5KWxdCfPPNlUuUIaLM1rnWsXdDyjrNZ03iRXuFydgShHvWtc43VxqJ1H7awZZtwbRndLG8qKLz4TfX66ZYTbXRVvFVy/dN+8jIB/5Uv8ovnC9zZGlaqDxF6vTd/XVLVfErdvPOgchVlc4mnGKw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761241819; c=relaxed/simple;
	bh=+W5S7YX1Fz1jcDqhwJtoUHH70Vt+xB4/5SqIg0QBoBc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FK8eENZUlQcljPAT5ynQPibdBmM1H2ZNLwGlAeXgPkaVIssnMijCGuVIMa0648SdTfk+GEFz46iwEL2/E9QEmsvGrr5xkrQkB2Y4m/JWCNQNqqqMeeFjlYBBTXy1ux9hx/Dz5nkGeXYzCq9F5yPTUnAb+SvpVvMcjZiR0wDValo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=K8YWvU2E; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="K8YWvU2E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761241818; x=1792777818;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+W5S7YX1Fz1jcDqhwJtoUHH70Vt+xB4/5SqIg0QBoBc=;
  b=K8YWvU2Ej05+1dTGosRQ1nKNux4AuUqYlwckICgV+1HiIF+dL6x1dJUt
   RTG+kUXaGaqYoFecRFbHpWqe/AqpXRbqQSulSgPgLp40cLFOLg6Ifp0C4
   aYECxCfYCbRKk/hAMgxMRwdXCCyv7f7girF4079LRI/Wp321f4J/hSJh0
   DWkW7kev0KXR3OZs/v2ebAkxJ4Rg1B4amOGnNbXW4+jvWJEpkD3OViwDq
   aNonnpOtIK0+shuyMR1qook6ok4ql7JBUKZGBHwBrfu3quvzWliYmmZQG
   AutoQGCrFb/I6KYhajLYBaCYG1SFyUe4a1ldCkQOA/5v0HuMae2MlceFY
   Q==;
X-CSE-ConnectionGUID: v47DSKkgSGeVZ4x7jbsc8g==
X-CSE-MsgGUID: 77zOjA9oTc6PJDKU5kvydw==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74091789"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="74091789"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:17 -0700
X-CSE-ConnectionGUID: IHxtwqVRTpuaqdFugRIs3w==
X-CSE-MsgGUID: dpHPFXF8QnmWh7tlWyIigw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="207871635"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 10:50:16 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:50:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 10:50:15 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.67) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 10:50:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iLXB7b2Uq16oKuhHaCT7xMHft1APJ1jMyX3PY2VvaVCopaE8/kkTJzqLLA2uTk+8EE/zvr+ds0zijrvJHYfKvWYbWtLTqJwH9jlX84uCu/gQRI5XN0vdtH45x5m7jmkJeB45FR0ncuvanY7nDGExxL91L5UPLtoxAQanpsq7WTgRu1AaMAMF6vWwOI+ORPgc+4KKK8bBCwov0dPjmeso2RXbHwsbg1yhVjfecx5gD2XogoOZkuTa6dK7mgJHhmHC2YEbLQ36axiWc7o+meXAQvuT1O/gbCNvaoZnrXDQ+nHqelBqg8pdfftQ9G1KixS54nzMoGtG40IEv5u3c8umQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dtJekvn699yz+ScsfoDOanDJVSzKnXdL0SthjFm08HQ=;
 b=bB459QD4+oxSFGxse9rOV4RywrjEvxYAiZcI0UezDsEeWzIgTZsAAtVKkDVWBTO6CWx90AQoHufmvX5LBvxxIEKT8bUs4oVanaPP8qMHy8a5WzdUOR1amI3fysUfrtdc/I2CT729NF+PmBmDm/wSCb6KvAa3F1skCXeBQytxz5QDc3Bx9D/OdIfqIQqjtKMINeBSEW61MyupxlCz+sa35xQBmZg3RtMhN2Pg2s5EyqLHLFeazpq/Y+31y2+/HDUGdWJ/fhd/Vd1vWsAJNugUSuQa+QDncArbCceVkLvx8vRgcPDVXnrl8Pw33I/On31pcZQwVq2Ij8gtP//XBfvMXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8469.namprd11.prod.outlook.com (2603:10b6:a03:57b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Thu, 23 Oct
 2025 17:50:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9228.015; Thu, 23 Oct 2025
 17:50:13 +0000
Message-ID: <91b08efb-919f-48cb-92d3-44b869c0e6e8@intel.com>
Date: Thu, 23 Oct 2025 10:50:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 28/31] x86/resctrl: Enable RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251013223348.103390-1-tony.luck@intel.com>
 <20251013223348.103390-29-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20251013223348.103390-29-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0121.namprd04.prod.outlook.com
 (2603:10b6:303:84::6) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8469:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e503155-63ce-4dcf-8308-08de125c9e0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGlTYTR4aVp6WXlUM3JWaEJXQmZwM08rZ05kSGlmOEFEc3dqQVhaR2dFSk9G?=
 =?utf-8?B?d0s2TDA2dFozc1ZERElRbnc1V3R6U1RxVE5NSmRsR0Z2RzhmVnlPbm1RSm4w?=
 =?utf-8?B?d1RRUU0zci9SZ1VwNmtsMnFxRzVUMkR2dXBGcHdaeDZ5Zlp1bkFrT1hZSWM0?=
 =?utf-8?B?YVZ4alRRemcxM0ZyL28vVjRrci9ueHNYckYxZ013V0I0YkgwZmtKcm5vLzFO?=
 =?utf-8?B?QnJCSWRLaGNybUVxV2RkelI5TjFad2JGS0NZN3dNNTE3Qk82ODh6VDRIOWF1?=
 =?utf-8?B?aVFya1dDSVpUdTJxWUU3cHNXYU1PSHVQQVFHb0pBWHdZdEJIMU56TndwVDd4?=
 =?utf-8?B?N0hpTWcyUExEWUNCQ1grVTgvYjFoeXRuai8zSWcraFJMUm90ZURWYnBmMUVJ?=
 =?utf-8?B?dHRIcHorTXhFczZJdms3SVBJK054dnBrcWFBTGxSZ0FHbkRFbzF2UERzcEZY?=
 =?utf-8?B?M0IrYXVCZWZSdEFDeUlsdFl1eGFRc0J3QlhYcWhZZDlnL1ZvdThhNFdJeStC?=
 =?utf-8?B?VFRiREpWVGVRRjQ1dGY5aFZzSGI1UW9VQkhrMEMyN2QxWk5jME12bXRLemNY?=
 =?utf-8?B?QUZ5bVA1enI5OFU4ZWdNK2ViVkVIdytqZ1pNRVdHTGVVMVQrWDBlMnNsWU5D?=
 =?utf-8?B?QmZQeXVpMk5xNDBDRFhLVGUzVnFYZEo3ZkZUUVNReHpmQmRYdXBaQkFGRitJ?=
 =?utf-8?B?Z2hjMUlHcmc5MVlsNFdkZGU2MDdsdkgxQ1ZvelhtUXJ2RHpYREZkcitJMVMz?=
 =?utf-8?B?aXFWT3F1VzI0bGV3a0kxdnFqb0wwNm0xd2hVeE8vN1ZEL0VPNlhDRkFHNWZW?=
 =?utf-8?B?QmdLYVBHVlRoY2xBN29TR0xUQjEyWUlCdDFyVUJac2s3Q0tHK2NGVHViVHky?=
 =?utf-8?B?WnJkU3Vkak5nYlQ2cXVQZlFLWTJaTkhFZzduUEl1SlluZkVMKzV2dkhxNEo4?=
 =?utf-8?B?d1Q5Vk9QaUpKbFFpMVpscHJLYkFQZ3NUVEJDOU1tVG04QzZQTzFwZkM2R2NQ?=
 =?utf-8?B?Sk9oenErVExtNzZJUEVEdmh0bDRKeHJTNDZDdE1WWDlLMzZkRFZMUFllNFhP?=
 =?utf-8?B?S2Fva0hmNTV0WUtuOVV6aXJNUWh2NVhURlo1YjdPeXdZakxlZmVtUHpjUm9n?=
 =?utf-8?B?aWkvYVRyYThTNXB2TTNiZ0d2NHB0YlBIRVk1K013SjBNNE5JNDlkdTYwL0Z5?=
 =?utf-8?B?NE9tallHeEQwYXhTOFFKQ1dwZlZ0V0hnMFl6U1BabktGN3h4RGJJRHVPcTZr?=
 =?utf-8?B?dTVJS1dxYnF4Q3VhVWdRcDFSZ3lGWW03MnVyVFJsZEZKTUlxU05JbmowQ2xh?=
 =?utf-8?B?UlZ0T3RyTEhpM0tkdlMwMmZFb0ZlcDlCWVpxbUx1UlNOekZTbG90SGxGVm0x?=
 =?utf-8?B?aThBTWdveVJLQWQ2V2p2NUFQYmZOR2F5WUFFNmxuSU5zZGZQUmtqOUtMYUdn?=
 =?utf-8?B?b253Y2g0WnMzZzZnM1ExZDRDT2ZvMWV4UEw0YSsxZ3Y1dGNia3NtM2x5cUQ1?=
 =?utf-8?B?aHRERHA5TWtZc0UwbEVudDlkQTVXbmxMWURNRWZBNGhjOWsyK1NOdnJHV1VI?=
 =?utf-8?B?dW5YU0pOdWZ6ZDk2eUE2NW4yVkNMZjdvS1RSb0U4aXpmcHNlK21GZ1lDNnRQ?=
 =?utf-8?B?L2UzcnhZMkhmWVFtcFdQTHZ4MG9DZVhzdnpDeDlnNWJNL2hNdnlnUjRnbzZh?=
 =?utf-8?B?eXVRTExKaEw1b2FjYUNNSjFBdk95aHNFb0ovajJjd1RmVXJwakJKOHA4NjBt?=
 =?utf-8?B?dEZEUStNMU1CNzkrRkFVU1pvTnU5L0JDYjJvcDAzaUFqZW04R0ZpQ3dodXZQ?=
 =?utf-8?B?TitVcGt3Slh2TVdRa1hRUWtoN3JKRS9aODd0OXIvRjIydGw2OG4rWjFFYjRF?=
 =?utf-8?B?Tm1tYnd4cXp4bWxqRXhicjlSUkJNREgyY2phWlFHV0grdFBvMGlib2RXazNR?=
 =?utf-8?Q?YETThgHyosDHHagrRo3EXiSj+GlofUxd?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VnlVMnIzZDh0Ujk1Rkd5WFpvaGE0cGVrV3AzT05JaHVTN092eE5iaUFzbUk3?=
 =?utf-8?B?VzhpL0xoWE92U3gwUllLTWsvaXpEcmJianJPQ1c5MGVEbE5NeFlHU1d0bjUv?=
 =?utf-8?B?eFB0aG1kVXN3VHorQ1RRejZ3REtLN2dGN2Zaa0NLWlpyQm1KMnR2WWhXNjRR?=
 =?utf-8?B?dnJlM1NOUTJhblE2eUxUZnNCS0xwOEEzZjkvQVk1VlQ1YUx2VUpFR3g4WUxY?=
 =?utf-8?B?dDB3OUlHQnFLQzZxVFpxQnUra25HSGZacmllcjcycit3aGwvSG9UeE14d0xJ?=
 =?utf-8?B?YkVVWHNEaUdnTVdoc0RYNkVBaWJXS3hpNnY2d3VuaUppZUJiMTdUWTVYUjJN?=
 =?utf-8?B?S2NNOVc4UHova0pxUHU4cUZZOHhSdE1BaThZNG5Ja25BVHJjWVR4Z1FRcWc1?=
 =?utf-8?B?VEx4NzRJNWpGWm9TUXFYeE85T3A0Z2JTT1J6ZSs1K21tUGo5dmJYQVhYZ0lK?=
 =?utf-8?B?ZVRhK2FGb2RneDlpZlRXTFdvR1poWks0VEcyZWtua2JpYSt1Yzdpckh1eVNl?=
 =?utf-8?B?M3Z5Mk44YlVQSXJadlQ4cFJEOFIySm1kc2JWVWV2Ti8weUdaZXh1Sm5rRFhn?=
 =?utf-8?B?RVdabDFHY2txVHNMODMvN0ZVbGtGMVFHYnJ4ZDhPTzBNOTBTNGxtbk5IU2Nv?=
 =?utf-8?B?bSswbnZuNEJjYkYxMzJ5eklWM3RGcmNkOXBUcURHR0N0UVUzbDlzN1hKSzFo?=
 =?utf-8?B?ZXFKc3ZUNEdLZzQ4SVRISWpqMjh4NXZhVklJU2RjbEIxcVlzancrdGZPSlZn?=
 =?utf-8?B?MW5yRk55VDRCaCtVNmN0a3ZIUTV6UjdUdFN5Y3E2TitBMGpyTkJGTUR4MXlV?=
 =?utf-8?B?dmRuZ3hZQWFVM0tYRFY5amE1TkhJYUJEV1hBRTNzT3Q5R3R0dWRKSWNXY29Y?=
 =?utf-8?B?aEl0UlFDZDhicFAvcDhlWW5pWmRYbzE2WG93TmRzNjdOaUw3RjVDT0RuK1lw?=
 =?utf-8?B?N1R3ZktKQ05UakZkMTJKYStTRlBFWUlRVzZrOXVZU1dJVUtjZ1o0ZStLOVRN?=
 =?utf-8?B?MCtGYndnclJBQWw0WHUyMFhJVmdFd2NyYUdwOUx3aEszbXJjQkp1Qk5WZ2Vs?=
 =?utf-8?B?TmFQOWkxR213a0EyN0FhVStsRXY1N1lxemJFTWpmMnVlN3NramYzZmFWa3Uy?=
 =?utf-8?B?dmVxUmdWaDdLek8vUFVlUS9jTHFaMS9tQUdaVnMxNExLcnFjZENLMzZ6VHpT?=
 =?utf-8?B?dzI0dXlmQVJrRnJYaDFYL0NVanFiMHJRckhiVU5FUDVqTnB3ekExTUJ2QTVp?=
 =?utf-8?B?TzVWc2daeTIwc1pqQjlPZXNEWXJFcU5pcEpaWFhFVE1IKzlhejE1YW9pWmhp?=
 =?utf-8?B?NjRKVmE0eDNaTk1XNE5DdnRaeDEzZkNSZ0hLMW1ub2x2YmNsak1oT3B6MHNv?=
 =?utf-8?B?UDRvSnhpN3FSdUZLV2taQUZoSzI4bEtXS2hIUTlSbSsrbDg1dU9WTm9CV2Ez?=
 =?utf-8?B?K1Q5N21DTWRWWE50cmFURmNuaXJ1eVh4M3ZFY29VZVJSRnRtNU94S2hMVEtR?=
 =?utf-8?B?SldoMmVwWk5uYW50ck9ydmNKeTFmdnZiQzNZMTdjYmlxMkR1bXRlYld6WUt3?=
 =?utf-8?B?MEE4WVhVUjcxb0NFODZRZ0ZMRHNiUDR2OUlPaURQWk0yRFVrbzN5T1o4WVJ5?=
 =?utf-8?B?OE04REZGY0piSGd5aDdFaEViYlVyL2lZS1hjVkhoU3luNjh1REEybzQwc1RT?=
 =?utf-8?B?aEE0cExkdU1OM3BGaSsrNSs2a0dHWVhXeXNBWi9aVGN4OHZ4OWoxTWtzazZJ?=
 =?utf-8?B?ZEtYNTY0YmJJM3d6YU9Ra3ZEbVl4Mm5LKzBONWtraGlNd1VaQjd3OEZVa2g5?=
 =?utf-8?B?RXNrY09sd05BNGFNNU1mK253alM3ajAxWEpEYWdrcUJvYkdZYlFUSVByOU45?=
 =?utf-8?B?WS95MjBiRDYybjZ3UnFRdVVhQ1VWV3hqVmphQkpZTmIxaXlwOS94aG5uNjN0?=
 =?utf-8?B?Rmhza1hYaE5WRW9iSlBja3NYV3A2WFd4SjhJNDhNbG0zRHNZeDZoSWo4R0k0?=
 =?utf-8?B?alFxZy9UejR5eWJpTXVmSzdma1ZjSWV0dkVZUHNiRWM2WUxaYThuZkwxSzNl?=
 =?utf-8?B?U2FRLzZsZlg0NWdrNW9nQ2lKNnJrRzdsWnRqYWZYR040cDlERHVUZTdoRDNx?=
 =?utf-8?B?OHBZRDhqOC9MN0VaVC9VQmFjVDF6NnAzbTJFblhIQkRpSVp2dkloSjVpUTk4?=
 =?utf-8?B?YVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e503155-63ce-4dcf-8308-08de125c9e0c
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 17:50:13.2948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gcBeIrcsxJzm1oEyB9GGMbacOZoFnyV4XZhLsOAynZHhxhCOjb1l5wnWDHIl2UMTEpD/4JFrrjkMpYbOaGD5VjXc9s85BlZ23QmZodE6OZw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8469
X-OriginatorOrg: intel.com

Hi Tony,

On 10/13/25 3:33 PM, Tony Luck wrote:

> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 03d159afcfe1..bc0a4d84a4e0 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -225,6 +225,8 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  		resctrl_enable_mon_event(e->evts[j].id, true,
>  					 e->evts[j].bin_bits, &e->evts[j]);
>  
> +	pr_info("%s %s monitoring detected\n", r->name, e->name);
> +
>  	return true;
>  }
>  

Is this a stray hunk? It seems unrelated to what the changelog describes.

reinette
