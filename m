Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE1354774
	for <patches@lists.linux.dev>; Tue,  2 Dec 2025 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764693150; cv=fail; b=cpZHEoEP1yB4qeWJq0o91qS/5gYI+8/v4KQ3HVMPsUhSNcrm16+sghcS3a793AaQ7Zu+2bcmjTSeNQe8G59N6FLZik0d9OVnuj9GoE2G6uBiit1eCVoGazG6mrsp36rPTBKYaiX77qITluEw5Ki2lg7JaSNKVT+SB/t2t7sPL6A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764693150; c=relaxed/simple;
	bh=hrjvpKCJ1n2TJ4E6GklPY2lsVE2MjYdaNNDzfewNfRw=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P2Wq08i1REI6MMK24Z8Gtt4mvUJMddXKbsFbzlJtHf70lzex6lTswMPa/20tzmeYZM/9crpiXH8nPnuZzFKZ3zHXDD5iAXMNiR2kKPXMi91KOXSJoEmZc564MiXeFRiifQcqHflRHA5vMBYSElcLmAZW+u9lyx3wlUqGF6W7Jzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjWOFAnP; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjWOFAnP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764693149; x=1796229149;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hrjvpKCJ1n2TJ4E6GklPY2lsVE2MjYdaNNDzfewNfRw=;
  b=CjWOFAnP0pjKxrzoJgQayzircBso81j00hR1giUbeuNEa7vJ9qhIgnYM
   qlATprhK78jCHedfYf2a+l7NmxBQjlBFOX8X+ucriA9/kBw8WGXpa8751
   tOPhZ/RAONNEi4qTTp6VTJUx2rT79nZdxu65Pm9WlY4oLeug+UjWIsn6T
   f9mUoryxRSRxodthVsMbY39ocKLb9Gh+fRL6UNDZopp3ND9M57ch+Gi3C
   dka3t0cce0aF9Ny97lC7EraQyPuVtaeCS9jIMTx9YTXDqh++lFZdhcABb
   lxnWRTA18DxoOXp0p2k3vpyY4iLcQf1oPLwFDp6MK5b3JEibnzEdveNo6
   A==;
X-CSE-ConnectionGUID: YkxbthfbSHig7IAGFnaLSA==
X-CSE-MsgGUID: z49Yr+pyR9eU4dUkA24fQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66559279"
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="66559279"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:31:50 -0800
X-CSE-ConnectionGUID: nwWwuIqTR268QSasYLRv1g==
X-CSE-MsgGUID: iWwFjkM2Qx6S3LhS0t00UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,243,1758610800"; 
   d="scan'208";a="225112003"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2025 08:31:51 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:31:49 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 2 Dec 2025 08:31:49 -0800
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.26) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 2 Dec 2025 08:31:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f+nxX4cX3RRuU/GUcjc52yiroeQZ0gfcuHVFOsxEzN8UaRA75xMqC5a1Wc4MPo2iSPIscl2EUIJEeK9Igzdw+2/xAeJZJQF78jMYffe8r6eB5xfueXD4rMBvvEhduzKMh04XZDbRGUsjbeOhhbWcwvnzQWQjg+MeQnIFKyEzpIfcYGQRZ7uDnyLNZHy8a+BZ8Zvgnn7jmcD67ZG4wWlAeS63dfuWpfELGQG39KwGhFKnV5wK7tlCtjf/HfUhVeuyXYD+vjTjz15caeViQAEumo+EyA1pUnTaQRg+37nOQpHaHZU9FugJ/q9K2XA07b4t4J8r8MozT0pcIP3TyRQPCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7637dIqV/BXmMm43ry+igPVWF+y1mJ5DBBHR25XToC0=;
 b=UAON9tpBd3JePI/T8o/r5iAjfzDQCH8mclZT/Q1cPB0fWqMAMPkSOczQ8rspL8mgx+YUptIBAT+qa4Tju2XOmij9+zYszws2Gmgr347K774KR3WOAQPzyTxqxiURLW6egmLbarUpcH31Rq3pCK5tK/hmRi4nqFzOJ9l5hreQkwR5OALvSNjFUlmN9878GPFf6i3u91fwk1ru/Nf0hKKrTm37Wi1ka7tJDjkHWxh/Wwkz42UJGzV1fqfygeEWcg+CqIZG/1lCsR4y1CMmtzWHhB8mo8ru/NjecmGe4gkmkntL7buOZgb46MPbG31gF0rCLP0X66P9brepVd7af/Ql7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by PH3PPF2B89F77E0.namprd11.prod.outlook.com (2603:10b6:518:1::d11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 16:31:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 16:31:47 +0000
Message-ID: <0480a4a6-4b85-408f-8248-c7d28500b13e@intel.com>
Date: Tue, 2 Dec 2025 08:31:44 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 25/32] x86/resctrl: Handle number of RMIDs supported
 by RDT_RESOURCE_PERF_PKG
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20251124185412.24155-1-tony.luck@intel.com>
 <20251124185412.24155-26-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20251124185412.24155-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0200.namprd04.prod.outlook.com
 (2603:10b6:303:86::25) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|PH3PPF2B89F77E0:EE_
X-MS-Office365-Filtering-Correlation-Id: 0572105f-6c6f-458e-8c75-08de31c04976
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YnlKOUh6RFNBRGtsNnVTM21LNjEzQlJOR0JEQVdsaVlGZU5xTmdDSzJrazBV?=
 =?utf-8?B?cUJVZW1Bb1FDYWgydXZIM2NOVWlEZTFtSDZCQTNTeEluY2picEg1V1VBVFFG?=
 =?utf-8?B?Ym1TR0M0YXlMVndSZHFsNklpRlI3QlhndFVaTzVqZXVJYkpZMVFsc01iU0xh?=
 =?utf-8?B?clNVWWN2MTVaeExqYXd1VVh0NHc1SXdSRUQrRVhWK1M4dEpqRmdQM0paS0Nh?=
 =?utf-8?B?WmptMElmK1NMUDJrWUJlL1pseTJBT2EyYjRBNS9KYnRoN1BNR2l3Z3Y2T0tV?=
 =?utf-8?B?b0pVUFhrYzJxQndDNE5odTA3dkNFWEU1M3dRWmpBVU1BSzFja3YxK3kyTmdw?=
 =?utf-8?B?SXhnQi9TSjJ1eU5rM1ZEcHg5YlVwNldMdERHY2JqT0Qzcm5wREU4MVFNOW45?=
 =?utf-8?B?dHprNW9rMnhLbXRGeE92alM0ZzdvUEgxOG15U1E5R2JZQlN4akJKdTNsVmlk?=
 =?utf-8?B?dGtpVkpHd3huWmxwZTdmZDdVNjJpcFVObDVCWnpGSnZFd1JVaTRoamtLeHV4?=
 =?utf-8?B?MkZNMGZZdzZubUFZaVVUOHlFbFNDSWtJUXFTOHZDeVQ0Z0s3UWJ4QklxY1Bv?=
 =?utf-8?B?WGlGY0FPQlo3SGcxaTJIUVVFeldUWEdNblI4dk5wV2V5SmNxT0NheFYxUTZW?=
 =?utf-8?B?bVpYVlJoeFV6VHRJSTRXN29TSmRxdFFpMTN1ODhTalZISWR4SUpoZlV5UUli?=
 =?utf-8?B?NjZtV1VGeVBETDBWbExZeEdzZXFPUE5QU09OQUVKNHU2ZU5hdU5CVUViTWIz?=
 =?utf-8?B?UVhVK3Vvdjl6dCthMHlkM1VCTkVkNUtQR1ZUZVp1VmJkNzl0cG9xQkVUYXA2?=
 =?utf-8?B?dU5iV1pDVEpkMW55NFlOalp1azFQZ2RQbjdGSDRhOThFVzExS3pFRUl3MUVr?=
 =?utf-8?B?SW8vNUI0aFdSZldjUG9oTEhuRGpPdm51MTBleENqS2lsbzJRbktBSFQyYzFT?=
 =?utf-8?B?RkE3ZkNNb0g2NzkyUFRYV1I1NmREbHdQNXZ0MXBZNnJMd3lrTW4waDlONzB5?=
 =?utf-8?B?dFBQdThjR3RZVTM5a3ZXekdHdkJwY0h2WUxxbTdkc01nckNNZWcvWjlUTUtT?=
 =?utf-8?B?YmpTaC9lU2c1T3h4L0MwZmJCRVlWd1IzeDBTS1l2S2V3YXhmV1dmb1pUOFly?=
 =?utf-8?B?VVJ4dnlPNlh6Zk1YV2lwbEtKUHJtb1BwcElhT3ZxS2xpYzk3Tnk0V1Fod09K?=
 =?utf-8?B?N1Vodmx5dFFvZUhZbGdLZ0RTeGRqZkliSHZIM1hBcThQeE1YdFBBcmFWM0V5?=
 =?utf-8?B?dURYVmxjWUQxUlI1b0o3WjVsVFV5YXBGUHh2K0JnRnJrQTdkYmVyOUFyUnFL?=
 =?utf-8?B?Nk9IYlJ3NHV3Y0RNclhQVGJERGwxbXR2QWJ5VjU5NlVKdWkvbHZmTnpMOUVv?=
 =?utf-8?B?bE52VkkxUHVhU1RvVEJiSHpZcXpJRjlvSDZ2VjU5UEd6VG5HbVBpeGJBQzE1?=
 =?utf-8?B?ckthNmJ3SnUzMFF3YTRtWmNZS3R6aGI2K1VrNURVVE5ySzYwMGNRRElaQUto?=
 =?utf-8?B?RlF4bnFZSlRmOHc0UVZMZVBnV00yRHZMRmJIdWRPM1lZSWNjejhVR0FMNnFu?=
 =?utf-8?B?Vy9aRW5DMjBnMThQT2VOSGtwL1NMUnlKZkZVSFljVGRQbHZ5TC9qQ0lQY01M?=
 =?utf-8?B?Tm5sMnVkcldTNjVJOGg5M3ZOanRpakVWYVlSSGlMVE1nc0EzU0QwWXQ2U2JH?=
 =?utf-8?B?cU16VlJQMW9WRTJkUGtkTHZrc2puZjZlVzE2KzRyaGxuYWxGelVlQjNVemM3?=
 =?utf-8?B?cmJxa2FENnBJQzUzVDVDODhFUzFvL1ZCTERlbWJ6K3Mydi9ZRnoya1FmQnVR?=
 =?utf-8?B?eE5aTW11dlR4bFdLTU53aVhrNlFrNmsreTFmTVhNaDVXOVN0Q2NuNUlhNHps?=
 =?utf-8?B?S3Q2cVRydFBLcUlCR0lUNlgyVXVZR3F6ZkUyblJyRFRUR3haWlFCVmRXdTgz?=
 =?utf-8?Q?iRosVhFcYKodk7+iQ4wrjHFJB4w7SE6z?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QVZnUnpORk10eStCbFhzdCswZVk5K2RiYkV3WnpVamxFWUQ3L1E2VVFrYTZH?=
 =?utf-8?B?czNGQWJrM0V4RUVYUDdZM1BPaDQ0Vm1YdDYxVEpHZ0krcmFMd1R0SHZub1ox?=
 =?utf-8?B?VUtBcG5rZEswU3c5OEJSUTY4QWNmZXVKR2FNSFFrcElrOTFsbU5KQkRQWjFm?=
 =?utf-8?B?TlpHMHcwWEtPb3dZT1FRME8raHBYMTdqNCtmSEpjMWdvQW90cVlwTFREdXNk?=
 =?utf-8?B?NVpIdmRyM0F1OTJQa0dqRzFhUm9iWC9vVnExZ0FTa0xVWVAzeVdsWDhraHJ5?=
 =?utf-8?B?QjdRd2IvRG5SbG1VRVJGa3BDVldQYWlXVFM5Z0I5eFJCVkVvTUVRcDRjUllJ?=
 =?utf-8?B?UFl3QURzRHhSTjBMTjJMVzZyeUI5UG95T0lUUk9FM3JIdy93VURUdGxNZzZx?=
 =?utf-8?B?OEl3ZVRoUDhrYUVJVENZU1I1NGVJblZFblFsT3ZQREJKUDBQQzlKWGpvRWsr?=
 =?utf-8?B?Zi8xQ2YxV1lrY1YvckRXaDBheDdsT2Z5R21qbVRkcmhCdFBXdUJSL3NtZXR4?=
 =?utf-8?B?T0hyMjJVQVVvZ21FUnpkZm10ckpVRkVWMG9KWWVNaVc5bjBDMVp3d20xUjgx?=
 =?utf-8?B?ajI5aVFCSUFCSzhSME9kTU5UOFBoSzZobDNwckZaNU1TK0cxSEVCUGVKSFhR?=
 =?utf-8?B?QktYKzJYVUpkbmFNTDY5WklPekM2RmtGT1N5UnlYYXBKbGpYSWdKamRFa1hR?=
 =?utf-8?B?WVhXcXVteUpFOFh4TGFoYlZ4MUVZY3RxNFcyVXFsdUJTSXpPWHdybFF0bVpU?=
 =?utf-8?B?My91RWtlUHloV0k1ZzRDT2tOT0QzMXE4SkkyZloxd2pBMTVSam52Tkl5YWJs?=
 =?utf-8?B?U0R5L3N3ZDRGVURwWUNraWdPOUFKZlRwMCsrdGVUWnluSTdZTHI1RzRUZU1F?=
 =?utf-8?B?RUdxc1hxUTcxQ3BQRlpkMFRBM0tJOFNIVUltcnc5TUNqY2UvZjR5emRuNHFi?=
 =?utf-8?B?Q042dVZLUVNvZFJ1NzZxZTlJYzRzVC93cVltV3htclFPS3BZNk16NUw2YWs3?=
 =?utf-8?B?ZVlzd21LVXRhTFdTWXRGMzRZMFVxU2JUbVpHakIzUlFkdDRkRkVLVUFxUzFk?=
 =?utf-8?B?V2pDY3BRTjBHSk9UMldvN3pWbjRnQ3JiOUpYdms2TS9uVC83cE80M25IeDRW?=
 =?utf-8?B?dWh2YVFoOHhLSmJlem44RC9VM29EYTFWaFZzZGEvWE5sY3BsZS9uR2JZNm4v?=
 =?utf-8?B?NWdoejArOVpFS21lSWNKN2Nic1NVWWlTa1JOdzJZSXVPakJxRVRncnppaEda?=
 =?utf-8?B?VExHMHNvazYyVkltNm1nL1BwZzUxMkpCQ0hQbjdGc2JYSVl6TkJuNzMySlNk?=
 =?utf-8?B?bXpGTnBMeSsvRkQ0b25OYU9UNldsenlZeHRkUkVHVTZ0VW16OW5ZQjVWN3Y1?=
 =?utf-8?B?ekJWOEU4TnpSYWtaM1ZkbDhpVW9wQ1dJcklzQjdtMU9hdG45N0NicGhRTzI3?=
 =?utf-8?B?cE1ERnU5V0ZrMDJMOERYLytSbmhaZTI3cUNjM1hHMmVGR0szS3JDMkRGYWJR?=
 =?utf-8?B?YlMxU01iRUQ2MnBqMC9MZUIvOWlUSXVLZlo4SnlHVEtUMUkyN3pMMStueURH?=
 =?utf-8?B?SFhTeE54Ni9FVDBFNktKN1Uva2F6RWEzNzRmMFBPWi9uc3lMSXFKMkdKcmVh?=
 =?utf-8?B?QzNXN2RtUTYxRFFMbmwrdUNHWWdZNjFiZDU0bEtSbkRGUHpOZ0RMekphQ2c4?=
 =?utf-8?B?VWppU1QzUzRQdzNmSUxSTENzS2Jmc2Uycmc2Q2s4ZklFWGIyVmtmWXlvYW5M?=
 =?utf-8?B?MnA5TEJ3KythZFFleUd0MEpJZFRGS0xycWF0R00ra2g4V1R2YjR5RHJCOWtS?=
 =?utf-8?B?Njdva2R1VnBmVyt0cUhkZXJxTTVITXBUYTlVOG9TejVSM2dZM0N1YW1saVcw?=
 =?utf-8?B?WkdWSG93cmF4TWM1OGpsTW1XeGhWVVVtdnA0Y09kRnMvVUJKc002MXFJQksw?=
 =?utf-8?B?WWRBN1F2cDRIUjJGcEFPNm9yQkRkcWlwZDczdTdyOUlJNDFyRStNRFoxNHNo?=
 =?utf-8?B?WVN5MnVJYWx2YzRQR3J4RjM1YTJtK25uUkJvYk5URDkvTGlBQjRsbVJTQk5B?=
 =?utf-8?B?K0h6SE9VODBWZzM5LzhNVHBkeGdQd0RJZmcxcmlySndnUjFwVTN1WDRTRSti?=
 =?utf-8?B?cE4wU3lQL0ZiVndUaHgvajFXNEVlSktoa1B4ZHltWkhPMjBjU0FUQ0xGVU1Q?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0572105f-6c6f-458e-8c75-08de31c04976
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 16:31:47.0445
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PtTzSw8iX1jbOCAEsQFQVxnOU3FqavVSMtquzNW6XN/SmVczx6/oMMDNuhkQLwzEnjvkdiEZu5Tyz6FFIM6YjZ70YRfTfYdTtK+BsRWBEI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF2B89F77E0
X-OriginatorOrg: intel.com

Hi Tony,

On 11/24/25 10:54 AM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into
> MSR_IA32_PQR_ASSOC. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.

Please check line lengths.

> 
> 2) The number of registers in MMIO space for each event. This is enumerated
> in the XML files and is the value initialized into event_group::num_rmid.
> 
> 3) The number of "hardware counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to

"from the call to" -> "by" ?


> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "hardware counters" to track all RMIDs are
> difficult for users to use, since the system may reassign "hardware counters"
> at any time. This means that users cannot reliably collect two consecutive
> event counts to compute the rate at which events are occurring.

Please ensure changelogs remain coherent. Dropping the paragraph that describes
how under-resourced event groups are disabled may reflect new implementation but it
makes the changelog difficult to understand since the part that mentions how
a user can request to enable a disabled event group remains.

Even so, can the arch not still be expected to disable an under-resourced event group?
(more below)

> 
> Limit an under-resourced event group's number of possible monitor resource
> groups to the lowest number of "hardware counters" if the user explicitly
> requests to enable it.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG resource
> "num_rmid" value to the smallest of these values as this value will be used
> later to compare against the number of RMIDs supported by other resources
> to determine how many monitoring resource groups are supported.
> 
> N.B. Change type of resctrl_mon::num_rmid to u32 to match its usage and
> the type of event_group::num_rmid so that min(r->num_rmid, e->num_rmid)
> won't complain about mixing signed and unsigned types.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 58 ++++++++++++++++++++++++-
>  fs/resctrl/rdtgroup.c                   |  2 +-
>  3 files changed, 59 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 14126d228e61..8623e450619a 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -295,7 +295,7 @@ enum resctrl_schema_fmt {
>   *			events of monitor groups created via mkdir.
>   */
>  struct resctrl_mon {
> -	int			num_rmid;
> +	u32			num_rmid;
>  	unsigned int		mbm_cfg_mask;
>  	int			num_mbm_cntrs;
>  	bool			mbm_cntr_assignable;
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index 50c8b4c50790..6eff606541ad 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -25,6 +25,7 @@
>  #include <linux/intel_pmt_features.h>
>  #include <linux/intel_vsec.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/overflow.h>
>  #include <linux/printk.h>
>  #include <linux/rculist.h>
> @@ -68,6 +69,10 @@ struct pmt_event {
>   * @force_on:		True when "rdt" command line overrides disable of
>   *			this @guid due to insufficient @num_rmid.
>   * @guid:		Unique number per XML description file.
> + * @num_rmid:		Number of RMIDs supported by this group. May be
> + *			adjusted downwards if enumeration from
> + *			intel_pmt_get_regions_by_feature() indicates fewer
> + *			RMIDs can be tracked simultaneously.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
> @@ -81,6 +86,7 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmid;
>  	size_t				mmio_size;
>  	unsigned int			num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -97,6 +103,7 @@ static struct event_group energy_0x26696143 = {
>  	.feature	= FEATURE_PER_RMID_ENERGY_TELEM,
>  	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmid	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 2, 3),
>  	.num_events	= 2,
>  	.evts		= {
> @@ -113,6 +120,7 @@ static struct event_group perf_0x26557651 = {
>  	.feature	= FEATURE_PER_RMID_PERF_TELEM,
>  	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmid	= 576,
>  	.mmio_size	= XML_MMIO_SIZE(576, 7, 3),
>  	.num_events	= 7,
>  	.evts		= {
> @@ -208,8 +216,25 @@ static bool group_has_usable_regions(struct event_group *e, struct pmt_feature_g
>  	return usable_regions;
>  }
>  
> +static bool all_regions_have_sufficient_rmid(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	struct telemetry_region *tr;
> +	bool ret = true;
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (!p->regions[i].addr)
> +			continue;
> +		tr = &p->regions[i];
> +		if (tr->num_rmids < e->num_rmid)
> +			ret = false;

e->force_off can be set here to ensure that the event group's state accurately reflects that
it is force disabled.

> +	}
> +
> +	return ret;
> +}
> +
>  static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
>  	int skipped_events = 0;
>  
>  	if (e->force_off)
> @@ -218,13 +243,44 @@ static bool enable_events(struct event_group *e, struct pmt_feature_group *p)
>  	if (!group_has_usable_regions(e, p))
>  		return false;
>  
> +	/*
> +	 * Only enable feature with insufficient RMIDs if the user
> +	 * requested it from the kernel command line.

(line length)

> +	 */
> +	if (!all_regions_have_sufficient_rmid(e, p) && !e->force_on) {
> +		pr_info("Feature %s:0x%x not enabled due to insufficient RMIDs\n",

The generic kernel parameter terminology of "feature" does not seem appropriate here. This can be
made specific with, for example, "%s %s:0x%x monitoring not enabled ...", (added %s for the resource
name) that matches the terms used in "detected" messages added in patch #29. Open to ideas.

> +			e->name, e->guid);
> +		return false;
> +	}
> +
> +	for (int i = 0; i < p->count; i++) {
> +		if (!p->regions[i].addr)
> +			continue;
> +		/*
> +		 * e->num_rmid only adjusted lower if user (via rdt= kernel
> +		 * parameter) forces an event group with insufficient RMID
> +		 * to be enabled.
> +		 */
> +		e->num_rmid = min(e->num_rmid, p->regions[i].num_rmids);
> +	}
> +
>  	for (int j = 0; j < e->num_events; j++) {
>  		if (!resctrl_enable_mon_event(e->evts[j].id, true,
>  					      e->evts[j].bin_bits, &e->evts[j]))
>  			skipped_events++;
>  	}
>  
> -	return skipped_events < e->num_events;
> +	if (e->num_events == skipped_events) {
> +		pr_info("No events enabled in %s %s:0x%x\n", r->name, e->name, e->guid);
> +		return false;
> +	}

Unrelated change.

> +
> +	if (r->mon.num_rmid)
> +		r->mon.num_rmid = min(r->mon.num_rmid, e->num_rmid);
> +	else
> +		r->mon.num_rmid = e->num_rmid;
> +
> +	return true;
>  }
>  
>  /*
> diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
> index ac3c6e44b7c5..60ce2390723e 100644
> --- a/fs/resctrl/rdtgroup.c
> +++ b/fs/resctrl/rdtgroup.c
> @@ -1157,7 +1157,7 @@ static int rdt_num_rmids_show(struct kernfs_open_file *of,
>  {
>  	struct rdt_resource *r = rdt_kn_parent_priv(of->kn);
>  
> -	seq_printf(seq, "%d\n", r->mon.num_rmid);
> +	seq_printf(seq, "%u\n", r->mon.num_rmid);
>  
>  	return 0;
>  }

Reinette
