Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99BDD220F59
	for <patches@lists.linux.dev>; Wed, 28 May 2025 22:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748470926; cv=fail; b=km57vH0/Zs1iR3xZo+q2VqMhXr6tLwLhlBCL7OWultwDnz0eoMLNsSFNbzx4QQp3G0gQ9HyMmSTpJizuGrdTqFJuKapwbsbtwHRdXY1Mayi97uQNplM70YvxI6/rYHLppmM4iqdEW49EgcqQgfds9+HIXWCfxlUsGgMaByvjAbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748470926; c=relaxed/simple;
	bh=ZOde+OwLY1DRyqU8veHdVoLfKUB4bMaykOv4Took2gg=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=LVKdoAt3Jveekkhq/R7nFpilsuOqBqO6guQhOj1qfQIqxIxmundifMj8eVSieHtIZP6K1Ih/ee9zpfKuGZl8kng+x9IgvJRkyj3sw1jQo2jTbqwoZi1EgpeWyLtAUQVF0LcL3AJHzzlL0PhTKYDf9z4+qX2GxFgwpgOtXHJO7SA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i1ZlmLtu; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i1ZlmLtu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748470925; x=1780006925;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZOde+OwLY1DRyqU8veHdVoLfKUB4bMaykOv4Took2gg=;
  b=i1ZlmLtulDp+5do5X3sKO8PbtRHpopPcs8zPZX569lum/84XIcNEH/EK
   DZT44tYuIIS6VG2hj+hb6gd9vjn91CBCjYPGBDs0TdCrnSx/SHHnmYqhi
   4NYkniLRl/x9HvmmT6INuXdHjJNIKbO8lmwvNNYq3agqtRwvyy5PZ5D9g
   42RMLRepgvGwTlDdp3odz58O/SXQ8ZxyJAzWgacA1BQn76Q9IUNCxxMyw
   3GpJjD9ZDY5g7JB1AdpmoAQYsZTt4qxi6G/C+O7btBA65hMmPJVyBBFWx
   pTFEIBLEmj4qpzXEtsVR2QQZUctBxdZAbRc7XJO1J1LvKpWLh0gfCtluF
   Q==;
X-CSE-ConnectionGUID: RGyGIvcsQvmK347gaJdmIw==
X-CSE-MsgGUID: lRvKZU46QRmmLduXOtI1wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="49632160"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="49632160"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 15:21:48 -0700
X-CSE-ConnectionGUID: Xaym5WOoQ9+M7vrUIYnOYQ==
X-CSE-MsgGUID: SDYRHaKqRa+wEoWaNMl5fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="180586784"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 15:21:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 28 May 2025 15:21:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 28 May 2025 15:21:47 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.53)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 28 May 2025 15:21:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MFtFJ+NgelROhYFB5K6/WKGMYJRWBze9QuOeYS3+t6dyWVE9qP9ZapK5EZDMA0iMMailG7FJH13QHYKgK1Vd420fRvzZE5Zj4tYjVSFRWn0bN3pZZ3ZkwSvLwmAqAXlZz6qnjvhSI+Rqx8NeJq5jLYTpegMKsfvr65wf2lVfi7tkqceJ7oFHyv7sASLFIq0BIhqbsXGqIwXTlfyAJSSDYTRjyyBHRkaM6BdAX9z6UVwUrhgypIyefZB/4bIpUa5nkOJuDUWe1QgiOhGbzGAaaakOb4pN8RyIS2gL0OuEZrOo1Ddc2VDzADA5UvbpCmqt3P1QQ7mFvUWXRO4ETUA5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1x1gmIvRAqbDQAB7qsY6ghoZiB6AsDPR/qV3WUEJm20=;
 b=FmodcoHO8gdBERPpXyiNJ5rKcpoIshiiiKddzdiQwJ9GqECbg4JJ7Mys01Wp0l/PBgWCLMnqsteXhgY6g1lgLm5gtHe1t+hlsBKuvW6tVHLM9rTrQQcDvEqP9oUs+IGH7XB1sJCcQJBDX1j6IeFL9MHhoAKhpvFHkNyHo989oDVl5wR0kd2TwCvnGUmo3VmhCLRSaFHJgfpVWfpLpOea1+EkSUkvCx8wZtzMKkhDF1q1eVxikxEh+NQqFYYdWxm81zIwe9vwIke2zEJrDmmpOllHCgJaC8WWb3H4S8WueKfaW3buARZnMwweuculpea32ZTb3Mab+fWaGzlj6/g58Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SJ2PR11MB8471.namprd11.prod.outlook.com (2603:10b6:a03:578::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.29; Wed, 28 May
 2025 22:21:44 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.8769.021; Wed, 28 May 2025
 22:21:43 +0000
Message-ID: <1d6606fd-5047-4286-ac69-0dfe4de1b844@intel.com>
Date: Wed, 28 May 2025 15:21:42 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/29] x86/resctrl telemetry monitoring
To: "Luck, Tony" <tony.luck@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, Maciej Wieczor-Retman
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Anil
 Keshavamurthy" <anil.s.keshavamurthy@intel.com>, Chen Yu
	<yu.c.chen@intel.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <b8ddce03-65c0-4420-b30d-e43c54943667@intel.com>
 <aDeCQ-v9OHzHauPi@agluck-desk3>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <aDeCQ-v9OHzHauPi@agluck-desk3>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:a03:117::32) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SJ2PR11MB8471:EE_
X-MS-Office365-Filtering-Correlation-Id: 56d180ab-fd0f-4555-4791-08dd9e3606cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QzEvSDZqTi9VZk11bSsxeDVDU0RtV1haMG9JYmQxcVY4dHN5L0FESzdyQVRZ?=
 =?utf-8?B?R3AwOTVCVXE5RmNydkU2NENvaVVycUtDaHI3WTY2K09UcXZiZDNjZ2YzMzgv?=
 =?utf-8?B?RHorc0VzZElMblNkMjdVN1oyMERBVWhPelZzZXlyVjYxOW5CbkxRZThvdWI1?=
 =?utf-8?B?WHBiWEQyaXpJOHY4RXE1Q2Zzd1QyMW9jbWN5MklQM1UzTDBwZTM1eFJMdjhT?=
 =?utf-8?B?Y2FnWVRnRmdFZWRCdVRFVmF4NnZPQS94VVR4ZXJHcHFnWS9vN202OGw4YStw?=
 =?utf-8?B?aGJzZ2VMRHQrZ3huUjRxTnh3S1h6Ni9NMWFzR3cyVkZZenpYTWFjS0ZwMDZ1?=
 =?utf-8?B?NU1vWXBwdWM3Nmd4RXFXL0w3ek5vQnhwSitZTnZDQ0xBSnVPMU91MXZlMmRT?=
 =?utf-8?B?eFpISDZqbDJ0SEJURjZrVDJFaTFVdjQwQzJMMStRVFJuQzVlQnhGK0FzM3E0?=
 =?utf-8?B?Q3VFTWFBeTBHOWx5WTBtRzdKcnRXOElsb25LU0dDZWQ0V2s4MkRmaGpTUmRB?=
 =?utf-8?B?cEpPZ3FYOVFlN2dneURUaHZVbG54YTJZWTZzUlAvcSsxMTdlTGhJK0l1Z1VV?=
 =?utf-8?B?aXA3L3A5SXd2MXpLUUdrUzIwNDBpalJ2Ym45WUc1Y25MMC94aXRxMHlPbVZY?=
 =?utf-8?B?OVZnWXNtUUlMa3M1NE45WDZMTmZNMHZtUXNGR29WaUJScUtlaitCMXgyYk9z?=
 =?utf-8?B?bXNiaFMxVUhNcjB5WmQwbldFOVlIeWg2cXFJcGlqRm4vVXNiVW5vV1VhWkNv?=
 =?utf-8?B?WTkvS01NTzUwLzJTME9HUmZFN25jQ1pVWTE4ZGpKNEVZRFZXNWpCWEFkTUxu?=
 =?utf-8?B?WGdWaUdaT3RJWVc3bUJXdzAyY1k2SytUa1J0enp1aFlNMWVKOThMUEFHdGJi?=
 =?utf-8?B?a3QyQ1c1QmJZQXdZMFI4MTNkQUxzcStyakpVLytYZXNjeXpNTi92ZlFraVpE?=
 =?utf-8?B?c0lhRWNCRlBJZXV3WGZmdHdKOUtHeTJIaStPU0ROcGNrczh1TEI5TGxGbVZT?=
 =?utf-8?B?ZmRjMDZZUnBPZ0xsOUo3czk4alhwbHB2MVNmOTN1RTVMRW9RQlZhd2w0U0Rk?=
 =?utf-8?B?Nyt1WWVYcCtETGtkOFBwaGlLVmNhbWs5ZzJNYldTRklzTmdqSStBbzNlSm5P?=
 =?utf-8?B?N3dBK3RWVzJlV3lhU0pIUnAxNS95QW1oS0x3eEpiNjRNT0NTZkxLTUJuTEtW?=
 =?utf-8?B?WktaT1J1dFFrRHNRam5OUlhLN3oxZ1UxOWNwQkQrM2FBM3R3aldRUW5CRVpp?=
 =?utf-8?B?ZU81YXRETjNxK1JkNXlyN0ZNakVJelBLQUV0bmhUc2YxL0pzbmhmNEZ0UWlS?=
 =?utf-8?B?QUVBTEduTThIRjU0enUwOGNENk8wdjBMWjNPQThCVFErS2F6cHpsQi8wVVdz?=
 =?utf-8?B?K0dyWjU1TTJBdEUvSWxwSmJXeWFGWVhrQjh3Tmx4ellBSWQzLy9kL0hINE5M?=
 =?utf-8?B?WVBnWjFMSWxJU1pxSVpKTlJpOHk3dzJJWTRuQ3JySEllQmVDSlhKYVBEMVow?=
 =?utf-8?B?VUJOcmdyVmZZMTU0TE9hRFJMNllzTU51QW53a1VDdHNrZkdhcXBPbG15WVE2?=
 =?utf-8?B?eTIwK2hEV3J1MXhwTUJ4Qm5UNFpRNEN5SmFVdGExd2wrNE56UzN4M3lTWnRs?=
 =?utf-8?B?NEdSWDNudXllNi90ajBEd0ZScHIxdlV2eXlyRVBSME55dmw4cWlCa2U3SkNk?=
 =?utf-8?B?N1FRYWJ6c3ZsQmZWRkJPQW1jMjRoa0hNUHVnZ1FPd3pWMGpXYzdQQmlLaW55?=
 =?utf-8?B?cHFaYWJxaWM3N2tHbktOVFlBa0hJU3NwWjgvWk1QNVdmWWlWN3lXbHgvNDd6?=
 =?utf-8?B?eHJLdXdMM1MzejhWOHlIZXBFVnY3akU0MjBqV2VQYm1sYXVod2NYcDYrZVNK?=
 =?utf-8?B?VHlQbWhpYlE1LzhmUGxLYmRDcnJvSFozM0RVRVY0TXVVQXEyZ09lQjRqTjhp?=
 =?utf-8?Q?Why5g92sECw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVlNeGpDLzRWa2VFdGZQS1F3VDcxUUZMNTFoa1VWSVRLK2IvUFJ5RzZxbTVj?=
 =?utf-8?B?STRtNSs3U2Jja3VJelRRZnp4K0xZWjJVN0E5ZGREN3Y3Ti9VTXZZK2JyNGFZ?=
 =?utf-8?B?NVlTWW9TdmFGMkwyZ21YRU1lenA0c2I3aFNhRXVyTkYwbVZlaFFyWGVkT1Av?=
 =?utf-8?B?M3FVMHI5UUNUczhCRlUvbXJaN0R1aWRMczhhdjBVWWhpSXIwWUJ3U1lNdTBC?=
 =?utf-8?B?dVV0MUFJYkdHN3ZjMy9wRUJZVnNycFB4VUEyb0V3UkcxcXdERm93VktUTlJK?=
 =?utf-8?B?K3Bjb0Mrd3FQTWNNOGNSQXV0VFVRelFRVUg3a1NsKzhxa3NnR3pIV2NaYWs5?=
 =?utf-8?B?ZlNqdC80QUtENzdKWkVFYmpENGg0QnNESlMxd2NwaEQrVHJ1T3Z1WWMrMXMr?=
 =?utf-8?B?NWVwNFhsbGJEVVBlSnROb0ZpcDB3Z3l2U290NUZGcnlGRHZTTW9idklZdjN0?=
 =?utf-8?B?S011NkJSem14aXdnK0N1Q1dkbzVNSzZ3R0d3U0l3b1RUbHBNdE5VdDRiRDF4?=
 =?utf-8?B?UVB4d3FrdzdoV3MxVXpzODh2eEROc1VXNUVMcmVENExVd0dVNkNKY2toT1li?=
 =?utf-8?B?V0s1bzN4Uk1kaDA1QTBUVU84aksyUFVMU3h6S25SdW5LMkp6dEZ5SEFUaUNa?=
 =?utf-8?B?M2p3UEh0QitOVC9JNmF1Zk55ekpESStuM2tuSWhjL3FESERnY0NlWFE4ZjVv?=
 =?utf-8?B?RjZwZTRTTTdCOUlQQjF6cWROa3QvNEF6Q0ZESjdpeFZ5MXREMnhQUUtIOGZR?=
 =?utf-8?B?bjFYNDRQdHFucGJ5OFlPdlRuU3BNcXRGZ053cCtpTnQ5K0Q3Q1dNcjViTUMv?=
 =?utf-8?B?M3UzMlVvOXNKNzF4V3ZUeHlTTHRGSkZvWCtsL0RNbmlWaERmTTZlcGZUbHJz?=
 =?utf-8?B?N2Z6RGphOURQeUpxSmh6ZnNEdmlYNzNsMFFzOUhUQ2lUbjZibXR0U3pWaEkv?=
 =?utf-8?B?S3E2c3hydmZHL0RSY0lmVXlEMnI3K2VBc2JPNDhTQ3IzOWdkTnBJZzB5bzFX?=
 =?utf-8?B?SUR5NTAvRlhQd3lPUGNSSThiQkQ0emtDeS82dFh5b1lKN1FJN2lBZmJmSjVv?=
 =?utf-8?B?NFFQOGRMbUlnSkNDc0poTzNnRENJRmc0YTA0MGFKaXppRWg3MUFnalhKV1ZL?=
 =?utf-8?B?aU9HbFpxenJLVzVwc0FvRXZTRnh2cHk3cUE0YVVaRjR0SUViUjVlZnl4M21R?=
 =?utf-8?B?Q21IT1FsRGxZdVNpS0NKc013eHRQYWFWTG83eXlmeFJKWlBtS1hnQXE3Y3h2?=
 =?utf-8?B?SGcvb2o3UW1zVUo4ZDloZjVXVThXeHkwSnRTZUlWc21TcmZ5NlliZ2Q1bHhq?=
 =?utf-8?B?cTZRMmp5YkEzclhLRWE0dmJSU3I3aE1IdG5qZ2lwVFFTci9BRUt0cUZwWU1D?=
 =?utf-8?B?Q1VvR0hXdFRmejBBYi9DL05neFpaOSt6UHdVd2Rkb002RS9IQlp4b2V5bXpq?=
 =?utf-8?B?SWE3d2tPeFVoTmUwYVExd0JoT1IrT3ZDT29sUkV1alVjOWFKeWw1K1Z6MFdW?=
 =?utf-8?B?a3ZHeTdhQU5xUWliWlpTaTFxSmkvSzNUOFhrcXN2NWZXekRIY1hXa3Nsd0ZJ?=
 =?utf-8?B?TTFGK3RLSzRSRGhlNTEyLzQxZlR5Zmxlc2Y1ZmxOOXVWdEtZQ1ozRWpaaDNM?=
 =?utf-8?B?WC9aeGpFNE02bmNiVy9neHcvRzFUTnpvNnFJOHpMd3hRMk9NRkpicmU3WitT?=
 =?utf-8?B?MFhZN1BaS3dXeGpBR0ZGU0xxUElzK0h5L1phWW5WcDFXMnJxZ1BaMmlFdzQx?=
 =?utf-8?B?MU5YbVdkSTBqbzRFUkpQZ0ZRUGNMamFWaStkRURzbm9rdnBUMC9WRGhwU2lw?=
 =?utf-8?B?Q01BUXF1S2hHZnBZc3J2NmM1aHhXTC9BMjNBeU95TUFSei82eHJzZDI5Q1dq?=
 =?utf-8?B?TlFKNWpjN0loYWNHa0dVNDVGeFRLZDFXOVpDaUIzVUY0Q1dTckRJVzBBeTFy?=
 =?utf-8?B?UVBaZ1RVL1hGUlRvODYyOUp3TnRxY0t4UElwMmkxSTRqUk82aXBEUmJEdUY0?=
 =?utf-8?B?eExMTzRCTmNZSzVPZkN3dEJwT1JlREFHMkRsUWxQc2pTelloWE92OEVJL3ow?=
 =?utf-8?B?M0ZhMmM5TUdKZklrODFCR3VZN3Z4VkJoc3podDBETldaZDRCWmpjMWUybDg4?=
 =?utf-8?B?ekpwUmwwckdQOURRWTNoL2VxZy8xbHBtR3o1N1BaZ0k5VW44Ny92ekFmcjJn?=
 =?utf-8?B?cFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d180ab-fd0f-4555-4791-08dd9e3606cd
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2025 22:21:43.7948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kgeT5m023hKJBL9zFlWdbAasMXQU+nOsMLwe6tB+YOT4CFAL4iI3eYV8AKlYrMLZV8gDTjSndVk6Dwg//Qmv09rNMqZwvitXfWtxBwFeVR0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8471
X-OriginatorOrg: intel.com

Hi Tony,

On 5/28/25 2:38 PM, Luck, Tony wrote:
> Hi Reinette,
> 
> I've begun drafting a new cover letter to explain telemetry.
> 
> Here's the introduction. Let me know if it helps cover the
> gaps and ambiguities that you pointed out.
> 
> -Tony
> 
> 
> RMID based telemetry events
> ---------------------------
> 
> Each CPU on a system keeps a local count of various events.
> 
> Every two milliseconds, or when the value of the RMID field in the
> IA32_PQR_ASSOC MSR is changed, the CPU transmits all the event counts
> together with the value of the RMID to a nearby OOBMSM (Out of band
> management services module) device. The CPU then resets all counters and
> begins counting events for the new RMID or time interval.
> 
> The OOBMSM device sums each event count with those received from other
> CPUs keeping a running total for each event for each RMID.
> 
> The operating system can read these counts to gather a picture of
> system-wide activity for each of the logged events per-RMID.
> 
> E.g. the operating system may assign RMID 5 to all the tasks running to
> perform a certain job. When it reads the core energy event counter for
> RMID 5 it will see the total energy consumed by CPU cores for all tasks
> in that job while running on any CPU. This is a much lower overhead
> mechanism to track events per job than the typical "perf" approach
> of reading counters on every context switch.
> 

Could you please elaborate the CPU vs core distinction?

If the example above is for a system with below topology (copied from 
Documentation/arch/x86/topology.rst):
                    
                                                                                
[package 0] -> [core 0] -> [thread 0] -> Linux CPU 0                    
			-> [thread 1] -> Linux CPU 1                    
	    -> [core 1] -> [thread 0] -> Linux CPU 2                    
			-> [thread 1] -> Linux CPU 3   

In the example, RMID 5 is assigned to tasks running "a certain job", for
convenience I will name it "jobA". Consider if the example is extended
with RMID 6 assigned to tasks running another job, "jobB".

If a jobA task is scheduled on CPU 0 and a jobB task is scheduled in CPU 1
then it may look like:
[package 0] -> [core 0] -> [thread 0] -> Linux CPU 0 #RMID 5
			-> [thread 1] -> Linux CPU 1 #RMID 6            
	    -> [core 1] -> [thread 0] -> Linux CPU 2                    
			-> [thread 1] -> Linux CPU 3   

The example above states:
	When it reads the core energy event counter for RMID 5 it will
	see the total energy consumed by CPU cores for all tasks in that
	job while running on any CPU.

With RMID 5 and RMID 6 both running on core 0, and "RMID 5 will see
the total energy consumed by CPU cores", does this mean that reading RMID 5
counter will return the energy consumed by core 0 while RMID 5 is assigned to
CPU 0? Since core 0 contains both CPU 0 and CPU 1, would reading RMID 5 thus return
data of both RMID 5 and RMID 6 (jobA and jobB)?
And vice versa, reading RMID 6 will also include energy consumed by tasks
running with RMID 5?

Reinette
