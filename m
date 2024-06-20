Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A29376041
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718918480; cv=fail; b=g0X6OjKMIfoQ+So+m2teeGljhlfBAxQS1j82TmPV8oiyPkSWtBE6+LQcvBcsYl/JXQ1zESYTR+hpTEqfYyUSrOa+cQehN4YzQZYqLnFHor9f2DhCyNcuBu+CVZx9lJD3ivsZ6z4IRJ/7p4YpwoQJRPwAqn1Km2RLa0S3ehAwJbY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718918480; c=relaxed/simple;
	bh=gl0n/Kn++TXylwGXceUszhLI2gL0FY8pZnsggY81afw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EwgL+QiZf53wFNhxEGSxnwmurWqkqF68emGfobLuMVEdd//moJYZWb5O9/acPeUmOJ/Dilalg71NEXpAzuaFFdocv2W691WAlQGAiN1Qla9Bf3MTZ/502+tHtzykscmpd1D23TGEUhrxfUnJ55aIAmGF5sDTP2b+Ful6/rq33a4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gF9vAciK; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gF9vAciK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718918479; x=1750454479;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gl0n/Kn++TXylwGXceUszhLI2gL0FY8pZnsggY81afw=;
  b=gF9vAciKcN7BwnRAZjpaaK+alBWourTNv6KLTH3asdI3uzf3ru4yWHOL
   xTk1PNRnJ2ZUlzDsz4pnK/PAmBX/Pfd/anQUiyfhI79uabAbN59f71EH9
   X0JJqOh7pZ8l/Q3EShLui3mCkVaG6SIYf9cVgr8UgdCEVhpfOXpaYYSyI
   YI6nnqk6wU5CBjNfnjMtv7W0MA3Y4LSSZo1ReXmuFKntu1vo8w5ZZPOR/
   B1P7Q2I974tEKxBO0mixsD9dxBqbaRGWRx8M+V+ZICqvUzrtUUHc/c+Km
   Umw/+66MPQUjeKVSGN7LYkBtW5/j3nlirZb7GS+KOEGmezZjbsfbBou4c
   Q==;
X-CSE-ConnectionGUID: /Ni37/D0Qaqfn/Sixqq9RA==
X-CSE-MsgGUID: +kku3PD2Sk6/2Xc79ZYMgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11109"; a="41336598"
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="41336598"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2024 14:21:18 -0700
X-CSE-ConnectionGUID: fkZCaZ1WSeeBTx3IzEGgNQ==
X-CSE-MsgGUID: 709eT8ORSu+TYh9w99OB+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,252,1712646000"; 
   d="scan'208";a="42333398"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Jun 2024 14:21:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:21:17 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 20 Jun 2024 14:21:17 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 20 Jun 2024 14:21:17 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 20 Jun 2024 14:21:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MmYEn+GKpxyYJULmYQixZAFRWRGFk58X9THa6v7HcMfoX3+ecRE5Gz9ICpYbxALuvb9YMCctlBjwmgCbs2fbjUggn6elWf6+gJ4vQVkeIpngNytiQsk6JE0Cpe6qMIrw6ntdePFbttzsCUv46AFXfaDefKP1VbeIAFaf+zApGRgiC1E8zT+2rjQSjL/CfD+H9+A71liGm4BkHyckpw1PuaiBv9mInbx17EdIfsMkOR5GH5JlUGRwQLRkW3lqVXBRZ4OTN+0B3IDbBZ4MQKGSVYIIH8xRaVHUo9YVelck7AMStlULGlRCke1jb/za35g5TCXkVL3FQo43Jav9HH+10g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6qMHAVzL67h1vLhaU/G0N6PWrhd/HlZG7gIlOjxH2i8=;
 b=oSm1oaJCV4WRMDS0YSS1HCxqAmhoVNtPjZpFfLCe5p78x2hrEmY9GvcB46KeWyfkP8X5Wmja3VpnerGfKH/BT1olS8rUyiz8LD+5izkU/LUxqGUlcXyXKFTHM4r6/zHxdZ5A8lxv4VKUdVI/TQJLocxB89k6db0YcCEHIct9iDSA7TIqh78jX/otsUvC1q0Rhm3ODsXOcZPsbTDKHeWrs8hL/oVsxylCf2/enk+uMf27ZesHyGdyOajqgS3tQU2FyJKpNIjuAxfih7nCxs2/ErcuFJco140+c2UQ71gjVG5HqQpAPmW4SkZOYr+z3Hb7y1NnW0XoqHCp0BLUwT8bbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by CY8PR11MB7924.namprd11.prod.outlook.com (2603:10b6:930:7a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Thu, 20 Jun
 2024 21:21:15 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7698.017; Thu, 20 Jun 2024
 21:21:15 +0000
Message-ID: <649913a3-0694-48b6-b4fc-0ec6e5e85bbc@intel.com>
Date: Thu, 20 Jun 2024 14:21:12 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v20 07/18] x86/resctrl: Block use of mba_MBps mount option
 on Sub-NUMA Cluster (SNC) systems
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, Maciej
 Wieczor-Retman <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20240610183528.349198-1-tony.luck@intel.com>
 <20240610183528.349198-8-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20240610183528.349198-8-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0024.namprd03.prod.outlook.com
 (2603:10b6:303:8f::29) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|CY8PR11MB7924:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a4aec75-ae3b-43f1-ed99-08dc916eeab7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|1800799021|366013|376011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MVA4a3diUXUxNW84ZEx5UUttWXhTS2ZTKzlHSDhPUExmMHdEeVpYSDRqY2NL?=
 =?utf-8?B?eHRKNlp2YVJPODJJcVhqVGZjUk9vV0MxcDc3VzM1RWNaQnlyREw0Zjh1MFVq?=
 =?utf-8?B?eW5XY2dEMmZUd2ZRaVc5RDdqTkYrZ0taaWpqUEkzV1krYVYyKzFhOXlmYkRi?=
 =?utf-8?B?eDczcGhIUjZ6S05JRG1iNTBLTzRGZDFpWTlXbENsMmNMWUVZQnJCcE80L2U3?=
 =?utf-8?B?NXNyNU1YRjJpaUVFeGhYd1dEeVVyaGhIT0RWVC9wZVI2T01aSmVuR1Q1K3FH?=
 =?utf-8?B?TXdtc1NEa0tlR3B2WGcxWHNwVi9BK1czVXNDa1l4M3JQclU1N0I4UGR2ZGtV?=
 =?utf-8?B?VUgvbTlFN29xWXFkL3JudUtpSzM5aUtaRHRJbzYyTUF0RjdRcXMzdFByKzVQ?=
 =?utf-8?B?SFF0ZGVpY2VHTUFuQWxXNEhpc05DY2w3WkRUTzZxYzNkQ01YVEJuby82c1ZW?=
 =?utf-8?B?UmxxUEVuQkxWLzY5ZU04a0E5MnlPYXJtQ2dhdUhIWTA2cUREZEErZjFZSW0x?=
 =?utf-8?B?ODdJRG00a3F4Mnk3NEtELzRaWGdxaGJSbGdBTWNVUE9PSTN5ZExhTUJKaDRV?=
 =?utf-8?B?eGt6T3hxNCszUSt0N3BmUitSajV4ekFxME9zZFpNNnk0b3RncWVLRWUxZzBN?=
 =?utf-8?B?S2xQcWZxODdyM2Z5S3d4b1ZjSnFMWFY2QkNINUJYSXpocjR2UkRtSmNMQVZt?=
 =?utf-8?B?OWNoZHdZdnRvUEppNDJTMkc0dUFVWGE5VFhRRUw1eE1USldIOWVZMTBRVjdC?=
 =?utf-8?B?SkNUTVdQWFIyU3lSc1VjY1JHNVpCTUJRckd1VXF2TVg2MW9ubUVzS3lTT2gx?=
 =?utf-8?B?eG41ZWVxaEwyKyt2RWpsMnNCREEvaDFWd29GZS9nc1J4QUxFdG9BZU9ZZTRY?=
 =?utf-8?B?SytIVmZUY21ES3A4QkNMYUdVbkNkK2xLbXNpRUtabEZUVEZpVWdMd1N4RFFs?=
 =?utf-8?B?UFMrZ01sVzJ3Q3lmRjU1N3E0RUxSNUQrWWh5Z0xYMVRsL0NLQWltUWc3bmxZ?=
 =?utf-8?B?TDMwd09KcUM2dVZGKzZVVUFXR0RBNVR6NHlQZitraGpRbHFna1FyZ2pSK1Yr?=
 =?utf-8?B?U3kza0dTc1E2YlMvRXlpaXp6OUxJTUxjdEFnSVJKWmI0Sm9JejRuck1HS3Nz?=
 =?utf-8?B?bDF1bDdIU3R5Yk56Z2haZVBFcjZHYTIyMVNwdTdBN29mKzc3MjJWQjZNU2lx?=
 =?utf-8?B?MjhjNEpkemhHSno4MHJJRG1aWnlvQ1RFSWhQWm1VV2h0YlArVFE5SXc2Y29y?=
 =?utf-8?B?YlpIWjhxb3k3ZzllMkcvTllxNVh4dWlWZDFuZWplbGpJL1MxRzk5Z0dwQ0lK?=
 =?utf-8?B?UGJJMFhXZEZ5Vms0bkJMOVNyWWl5UXVuQzZwU2tLRU45bytTaUl4eEhXOVBj?=
 =?utf-8?B?eXFvUEV0a1pOQlFlUTdpUUVFL25rMVh1MjlpMHZYRVlxZW1lSkN3QmlYd29U?=
 =?utf-8?B?VDFBWUtNcFdoZjBBNmI3ZU9kVzRYOXJSbEQram40SUF5RHVFY2hFbzJTRjY5?=
 =?utf-8?B?RjkyTUlYalg0WFVhQUhtOXNFdVl6ek4rN0FacWs1cWtoUEhud0Z1S3JaT09n?=
 =?utf-8?B?MDYwSHJHcWpSU2FVZUhPbVdEN2J6RU1RYnFiNlU1bTl1aFNRTVZOR3VVUWk3?=
 =?utf-8?B?THJZT1h2UWlDNUFBWTZKV1JqNjV4QTlWRkN3ek9IKzlXV25CZTU2T3U2WnVo?=
 =?utf-8?B?WWFQMU40Q0p2aWZxc3ZReVpjeW8rdDJLTlpXYXFUMHlHbUZhVjVWQmlHQ3Ro?=
 =?utf-8?Q?YkvXern3TA1ODagWHaPG81CME1SAJ4LonlojX1y?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(1800799021)(366013)(376011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0gvQVplM1B1elExZjljVjJGMlpQM2MwRFM4b3VRY2l6MTlPNWZHc0RGUG5W?=
 =?utf-8?B?OERaRDV4T1kzRDlBYVJmK2RIOEdtQ0lSM1FGOXBiUkxad0c5dEEwOElsT2k4?=
 =?utf-8?B?S0dxazZWV3FPTURRVWl6QkZ3M1gzbFVMcDBIREFTN1ZhRkYydWxYZ28zaUJV?=
 =?utf-8?B?VVNQSGR6TDR4eW1jMkMyUXhtYmQ4T29UM1Q0dEhmNklEa0VFRnN4aWRwUXpm?=
 =?utf-8?B?ZnRrZ2VpYTVxNzhsMEpCVnlNdTRWb3l2a3pwa3NoSHBvQ3pxLzcyVzdpTllP?=
 =?utf-8?B?aEJWUTMwM0xaZnlQOHNaRldleVlXem5JblhxNWoxNU85NDlwTWlWY2VVUmJW?=
 =?utf-8?B?RTB2YWwvdGJsYVNTNDh1L0VTTGEwYmd1YlEzUEtIQWdBMEc5Tlk5VUh0ejdw?=
 =?utf-8?B?K0dZQzQxZEhIdmtlMk9JcVd3TDJVcUdEU0F2UjFNdUs4azZWaWFlZFU0TzRk?=
 =?utf-8?B?cUxHNzZWZlh6bHBuZ1JoNHpNS09ta1JuYWYzNlp1Ukd5WkFnQi9LVFh0UTRD?=
 =?utf-8?B?cFZCQk1UYlpRcWNTOXFXdUhtS3pzUVVEeUtwbGZxSHR6OXd2ZHRMUU5lVEVL?=
 =?utf-8?B?QVRaTE5oOFpHb2wzY1E5aHErbnBIWFd0SzZVWGNaTVM0NVdNRThxbUVzK0ZR?=
 =?utf-8?B?TGVWOWxXcG9JazNHVm5YZUZEekhhaUZwaDVnUkE3RTdKZkpMMDhiOGFzNnhx?=
 =?utf-8?B?bXNJMmZWallDdE5KdW5JNDlyY3NoREhjbGp6enlucFlJT2VSK0YrYzQ4NlYw?=
 =?utf-8?B?NUlpc2ZvRWtQeEd3bGVDNmF4bFkzczcraVBXRkFaTWRkamMwVzFvaC90SHIw?=
 =?utf-8?B?d2ZNd0twQ21zV0QzYVIxVHZqdUg2dXJEVkZBaXJwWjdieXlkK0hRTWFSdVFj?=
 =?utf-8?B?TlNLck1hczFoempIeWxOUEVSeXg5eHN0U24zTmhBaWZaZHdia0NDTnlRbXVo?=
 =?utf-8?B?Z1FuL29GYVhVUnA2V0lpUFRtNmZqdXFQcGd5YmxqZVYrRjN0cWVILzMrVmx4?=
 =?utf-8?B?MTB0b1dFb3V5MW83RnZuVnFueWQ1ZjdzeGQ1WTV2SjJScGxrSGc2ZldLNzEx?=
 =?utf-8?B?QW9BeFh5bWVyWHNPU3FZanlwRGJUR3hocGU4bmJ3T1lOenB2cmR4dzRvekJm?=
 =?utf-8?B?Rml4RVZhNmVBQ2V4enJVcWhBdnZGTVhqMXl2UXZoSks4OE9SUDUzZ0hyYVFX?=
 =?utf-8?B?WWpsdWc3YUYxd3BsYUxiV045akowVTBXNklTUHY3STI1RDVCb1BuSGlkb1dU?=
 =?utf-8?B?cmlYelVJa0RVSjVnYTQ2dE9ZWTEvVVUvbGZ5WDh1NXl2WkhlRUdxNUJoRmVV?=
 =?utf-8?B?b1VXUnA1TWN1WHdrS2JFVzRSazdPSG9mMTRCK2Rwd3c0cTAya0NsbTRhRzNk?=
 =?utf-8?B?TisyZEJ1UUR4aFNRVHNPNU1jcFNxaEx3VnNuaENweTFTUjZXMTYzbXJqWTIz?=
 =?utf-8?B?cSsyWnFaYnJHcHBoYTA4UFFuRnNiNHY1M0xKa1RoaVBFUEdFeWtGYkFTcWty?=
 =?utf-8?B?dXFrdDNxWlp6ajd2bk5LRVhBeXg2SVBUeWFuQ0FuZFZVL3lzam1MeTBWTVhM?=
 =?utf-8?B?dXNSUllKSFNHem5YdEJuK0svNzBNdEFXeUpZUjFrWFMxQ2o3T1VOMHJBK1Vv?=
 =?utf-8?B?ZzI3VFZRQkg0ZFY5RzNTU2JvajNYQVZZUlV5OWVtSHY3UzloNmk2MmJxQ1BT?=
 =?utf-8?B?ZlhzNGl4Rmg1ZmZXcWhoYkRXbGs4NEs2Wk4yTldrbW5JL3EzSE9Tc3Y3a1Fs?=
 =?utf-8?B?ZURZZEtKYXJ2aTROb0NyTEtwRmpuZG4yK2pGM1A0b2JNSzNJRVVvMG9UQm1x?=
 =?utf-8?B?eVpVTFpycHFISzVjWUJ1dENZakZXdkJCRTRDMENyRHBxaUEwYngyei92MUh4?=
 =?utf-8?B?Y2hPTXppNWs5cTJtblpTQjlVaUdBYVl0T0xXZTUva0VJYmpOdjJGcTRKUlNv?=
 =?utf-8?B?QlRSK2FGUERRZlQyZktjSW5mUTZmS3NyaXlNOG1mK0JvcTd2a3J3MzJDQnhU?=
 =?utf-8?B?MHlEWHUyNHp0UzRURm5Bb0srRFU3NWNPeGlGc0xnYndJZ3lPN0xoMVpjTXpO?=
 =?utf-8?B?SzdNdTBYLzhnRUljWWxtSEM4aVJqOXJsbzBlLzF2UklRTUJ2bGZIVVcwbTR3?=
 =?utf-8?B?aGhxWjNZdVBMSlVOazY5RmpaZ3A5Vy9ZS1dzSDhoM3pFT1I0andlT2trZTk0?=
 =?utf-8?B?OHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a4aec75-ae3b-43f1-ed99-08dc916eeab7
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jun 2024 21:21:15.1209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TE+4PoC8HqehknbBuSiqfju9NqasL6YV82qKuzdH3ZyGssqWba0p5imS6VT4ZFfucir7ZPtnu62hOw1UFx0PZOVDBBPM6hKaP8pn/bTDo+E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7924
X-OriginatorOrg: intel.com

Hi Tony,

On 6/10/24 11:35 AM, Tony Luck wrote:
> When SNC is enabled there is a mismatch between the MBA control function
> which operates at L3 cache scope and the MBM monitor functions which
> measure memory bandwidth on each SNC node.
> 
> Block use of the mba_MBps when scopes for MBA/MBM do not match.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   arch/x86/kernel/cpu/resctrl/rdtgroup.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> index eb3bbfa96d5a..a0a43dbe011b 100644
> --- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> +++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
> @@ -2339,10 +2339,12 @@ static void mba_sc_domain_destroy(struct rdt_resource *r,
>    */
>   static bool supports_mba_mbps(void)
>   {
> +	struct rdt_resource *rmbm = &rdt_resources_all[RDT_RESOURCE_L3].r_resctrl;
>   	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_MBA].r_resctrl;
>   
>   	return (is_mbm_local_enabled() &&
> -		r->alloc_capable && is_mba_linear());
> +		r->alloc_capable && is_mba_linear() &&
> +		r->ctrl_scope == rmbm->mon_scope);
>   }
>   
>   /*

The function comments of supports_mba_mbps() needs an update to accompany
this new requirement.

I also think that the "mba_MBps" mount option is now complicated enough to
warrant a clear error to user space when using it fails. invalfc() is
available for this and enables user space to get detailed log message
from a read() on an fd created by fsopen().

Perhaps something like (please check line length and feel free to improve
since as is it may quite cryptic):
	rdt_parse_param(...)
	{


	...
	case Opt_mba_mbps:
		if (!supports_mba_mbps())
			return invalfc(fc, "mba_MBps requires both MBM and (linear scale) MBA at L3 scope");
	...
	}


Reinette

