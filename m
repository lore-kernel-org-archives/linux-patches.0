Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D0718E3F
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752018715; cv=fail; b=U/MurNVopnsYFgz8GtDCWWVbC7gLVRS/3hhPYOWz3ljlrwydg0DTOEKKcr4vixil+mmM6YXhftFKw3siTlTKUH7CByCZtrSDmaZwbMb++YMwXE9vf7wExXACYG44wf2NkmZsvZSP8edAPCNqWLRc/MTvB57kJJNqLxcw7gqEFb4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752018715; c=relaxed/simple;
	bh=9XzmkNE/b7sMjJHhRZMOFWIbhbb3DV7ehuhpwMyaUqU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dxKFyBTr8dY7t0jB3t9PrFSmJWmvCxmDSoDOXH0Bqfucm8QIcMfUSAXluQJRqmVuTONhh83Se0eieqzSL+alNs0RDrejGz9coPT5cfYaiwDLuMT2nmpMo2ULtFd4lPghQSQCarRzmZdl6r0NXVq2RdsbvjLciGR6HyDV4VcMTao=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y31oFTrr; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y31oFTrr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752018713; x=1783554713;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9XzmkNE/b7sMjJHhRZMOFWIbhbb3DV7ehuhpwMyaUqU=;
  b=Y31oFTrrAFTENwXN9/aQSEAg/HELXKL3WAocCBQfY7kuYj9WAG3AO1tT
   NRLg89RnD+sh4A5W/vhqq85nO3lEcLjiCblERyojho77GhUOacrL6deTk
   Ve/hwzs7+nRXalyW57vzGPpVCos0DB6exswd1QIAVCJ+w/V6BWl0dKFUl
   lFW/9cq50t7SbS0eP5k+7HjsqTfsUiGELUclfLzQOi0sQ/gAQdmsmrGrC
   c3kvjJL8EpSAQoDqtyNOxtf/pVzNGsAZMaENRuu2kMODY5hwzA7ws+Ljt
   AYdksSCvI+CCviMhGQ2JGdukDxPhyFPxMTJ6rL4cGWeu9Rm4bvZbAt2rB
   g==;
X-CSE-ConnectionGUID: mOP58IejTX+PBCyZCk01Uw==
X-CSE-MsgGUID: 1MoO1312RiSqB3V23wyoQw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="65332082"
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="65332082"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 16:51:52 -0700
X-CSE-ConnectionGUID: s6wzBEmiQQiGmKdqpnOmNg==
X-CSE-MsgGUID: T7lTvy1qQ1SQSv/qEWGLGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,298,1744095600"; 
   d="scan'208";a="155708858"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 16:51:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 16:51:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 16:51:50 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.47) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 16:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CLhCSPJdhzIGfOVKBXxHMv+Wq7PFYF5BlI+ZSOC85JZW8w9E9h6yX5xbpPdRZDK7PeVr9w7ltIvtPIklshF7TPRwDh5Z++kHR9ezYB4kDwBDwTwp1xxsthCi/3TXsz08e12sU3qab5U5AsERUc5dUFI5vamRqo2tYvhT3FStvN+eExe8RsqbXgMulHh7c/YFFZvfG0wKOAoAIP4kxw0Oq3fzBrJn5GfJwOxwtxg7x7yBemDb0z8cvUPPZ0gI6CtmjOl6egL0sGVZiGZwmcFAvBLET5Piiot707+CaW5YVwx26iTNzEgo6CtKUgDigjH+EtCFjDpLGKDaILzhX48tSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gR9U6T05eskcA8J9aujAOW+1CJi7gDfn6eCBh75WVc0=;
 b=uUz41Bpl3J9JUPCtSrqbkk2U8KyniGL7qQ/iLtxDomuxIvsV8vtyAGjHjuZKXG+PxNlMh1wA79k7AtMGSrAkS3rRLFrklCNUPzu9+xpgYMMCGJNdleFWb3LbjsAU+ZF2EIHN1SdJ5AGAZzSHV90JgiVofwVGq2BMEbJ4dZA3w0Rc+hOHuKI+cmHX/qOXC7Mc9ZnYH4exrYmb4k6pd3AzKRnMpeFyqWCy20LvVIOcToupVZQE92hXRK3nPJfDzWWri7GaEWEn+1JhlwWVmMs+YSfcM+z4IbPys7V5SI8V/u7IXHb93L8YSPyLDE6OvEFPKKUY6CUqtJFyt8cx9BSUVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA4PR11MB8963.namprd11.prod.outlook.com (2603:10b6:208:55c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Tue, 8 Jul
 2025 23:51:47 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8901.018; Tue, 8 Jul 2025
 23:51:47 +0000
Message-ID: <1dbf47a3-dab3-4fbd-8146-9d4ce1787aa1@intel.com>
Date: Tue, 8 Jul 2025 16:51:45 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 17/30] x86/resctrl: Discover hardware telemetry events
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250626164941.106341-1-tony.luck@intel.com>
 <20250626164941.106341-18-tony.luck@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20250626164941.106341-18-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:303:16d::35) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA4PR11MB8963:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b024b6e-54b1-41f7-8c0d-08ddbe7a66af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?bFBxVjlSSzJ0R0s4R3FFWnc4UTBVVVczRmUzaHNSWGI2MForem5iRjV4cm5Z?=
 =?utf-8?B?MGFLNGNGUVRUTVd6bC93N2VzaDhtYkpHR1NoYisvN3pXa0JSQkVhL0FuRTAw?=
 =?utf-8?B?NHVKYzhqNkQxek0ra04ySTdDS21CWm53OE9vWnJJeGljWnVQQVlBU1lYTTRm?=
 =?utf-8?B?WEtYL0ljbHVlcjZ0OXY4cUNmZnB3UkhXZWcvbGo5U1pzbmdGQkZQUmwwcXhx?=
 =?utf-8?B?S3hkVlVZSG5BeWg1bFFxZGpIRTNWNXBUcWI3ZzJaQ3VwcVgvZ0VmUVA0cWUy?=
 =?utf-8?B?Z3VBbTVXV0dydFhhdFhxWkJxTmFZT2pGUXVmbVJmV0Zxam5zcXRrYVFUNGRo?=
 =?utf-8?B?UlNuSWJGZnIrVUpXY09qUlRXczRKdTgxT0h5WlNJdmFnOFNVaXB0VjdEK3h3?=
 =?utf-8?B?VHJoUmFyZTg0cTVWWG8wZHY1L3lPNE9PVFhyMVUxemh6azJ0MGM1ZDdrc3NT?=
 =?utf-8?B?MXRIdGpEV3UvZ3VjVjZBZ21vVlhRYXVoYmJueHNkM2ZkaU5SaXZ2ME93UEVJ?=
 =?utf-8?B?TGVoS2xFcmp1MmVJTDFEeDd5SUNmZGhpbjNLL0QvaTFEeEZhMUk1eU1scUlX?=
 =?utf-8?B?eEVKckE0TGI0OWg0UEpnQzg5WnY2SUJaTnMzbnVZSUhJS3NqOUIvV1dwOGN2?=
 =?utf-8?B?eFFVWlFabGRaMTBXZ0p5a3JsVVZMN1NLZFhQRUY5cGdvS0ZuNlYyYUlwSVFS?=
 =?utf-8?B?TEpzTXFpemJNWmZGdlFFdzd5cHlXNXR2bVl5RXk0aThyQjJVYi9obWYreU9K?=
 =?utf-8?B?c0xjTzQvRGZTNWpWNGpETi9BZ1ZFTkdWRTQ3OUhJTUZzdTFkNzZkZFJ4OUx4?=
 =?utf-8?B?MUNhelAzUEpSNGs3cVpteXN3dkFOVHRrS1JvanJKOFRsbHQ3VklHdTAzS2xR?=
 =?utf-8?B?QUgzdk9SWkFCckFTMHJHcENIYWhIb3dYaVBJWnp1bXU5LzdNY3l2RHhld3By?=
 =?utf-8?B?YmwxQlI5aDZIWFNZZ2NnSldlVVBhbGNvZlgxSTljcVB1bWJ0U25rNzgxL1JS?=
 =?utf-8?B?aEJpcFM1MHNmcDk1cjRsMTFaSzBJTzE0V0FHK2xOM3BsZGdWR0F2c0huRnd3?=
 =?utf-8?B?Yk9lQ1NrNU1mOUUrNVF1Qkp5S3VRKzJQK0xabW9BcDVoQnQxaGRXRHlEcElS?=
 =?utf-8?B?NkJRcFp2RTVrNS9aaksrZTNEWWdGaHI5K1dqUStUY0RhUDBjS3NUVlU2UzNz?=
 =?utf-8?B?ak5JOWhvWTVsekQ5Vk5CZ25nMUZzeW5zLzBCWERobTVMOENCYnNKM3ZHeXl1?=
 =?utf-8?B?OGFicDEvVVh1Rkl4dkhLd1Y4MUZmNG1JbHdRaUc5azFoOGl1cTVyWnRFZjFW?=
 =?utf-8?B?SGFnajl4QmM4Z05FUjlLNFB4cEtNTzdtT0JYWXQwTnFDRFNISTVZSFlNYVVm?=
 =?utf-8?B?SWtqVCt2MkpKdmtaTmNlWUNaUnV3bHE2QXgzVzdjK2lmK2QyaEU1VGhTdE1V?=
 =?utf-8?B?RDlhTGdRMGlKS2srak0xeW5jMFZsQXF3RkNNT2hpTjdzc3FaQ1k0Y0hIdThK?=
 =?utf-8?B?aldBT1lNL2FLM1lwSmpuS1pucFFXWXBZUTVMK2ttc0wvS2IwQWJ2UThtakNT?=
 =?utf-8?B?NTR0eS9BcU1nc1NkT0ZMZXlzdC8xVjM5U0czbXZsQnNwa1BJNjd6Qkk5NTZ4?=
 =?utf-8?B?WXR2UmI1QmEwVFRjbThzNGVZZDFJUFlqQUJvdUpjelkwYVVKRnN4K3N4dkNW?=
 =?utf-8?B?QnVYMURuMUpEV3JCT0lSMyt6SkJVS2dOUzZvZHFXaWE2dzRJeTM0b1Z5d3dQ?=
 =?utf-8?B?SllPQm9aSnA5Z1V2Y251U0JONy95UFgzaC9reGJJQ3Q5MGdsU2F4VzNybk1i?=
 =?utf-8?B?YVBBR3FXLytxQXErYnl6WW5aVVhDMjlxVzI3Y2xDZ1BGbG1ROGZJaWxPdlM1?=
 =?utf-8?B?MjlmeFNiR2UvaTVYRjFkU1lPZzVyOExPRHJyTUl4ZkU4TmV1MkcyRWNHQzJa?=
 =?utf-8?B?RTU3NUJRVHhyOEhCQldXR2IzeVRyWlh0SXJKM3pKU0FLcDJPRVBRZGVkQm5q?=
 =?utf-8?B?NVhlS21URy9nPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aEZpSndmUUxueUNDZkxkblhLYm9FcWpTN2JUbjRKOFhpeHByaFlPVmRHRXhC?=
 =?utf-8?B?WW9pQXJNQ05QY21ZT2F0VWc5MWRLUDZveHpTSWQvVDFwTmZSaVFhMzAxUXc2?=
 =?utf-8?B?QUNEbUxnNnQyRW5aWEcvWTFpWUhnTWFwbHY3NVN1NlFUaWl4UVQ5MnI3QzQw?=
 =?utf-8?B?dy9qT3R0bEtjU0J6eUVpWXJGcnQ1MHhnSjlNeS8ySEpIWkJIK2dnZDU1ZW56?=
 =?utf-8?B?T2hpSy85SmtZSm1HM0tvWUxwd09VYlZOVDhybnhDaE5WYlVEZEVsaU9uMjlU?=
 =?utf-8?B?ZWs2T0Vub1FieEZGTHRucmRyTFFjb01SKzRHMlFTRWdkYVVBYnZCM1RhMGVS?=
 =?utf-8?B?bFdJQUNjV2VsS252VkZFNHFVU2hnd01kRVJ3SHB0Y2hudWZWTitYWUllcUx0?=
 =?utf-8?B?V2FOcWx4SW9RWFF0NE1vYlV3TFpyOE95YVdPWEtVZ1RPOWdVa2Jhd24vbEJ2?=
 =?utf-8?B?MzR6MFJ0bjBzZThSU0lxMVd0dldMTHpLWldUM3d6NmtyTU1pRTB2Zk13MFB2?=
 =?utf-8?B?L1RLZXdscE5VTFdjVFNkY3RnRExVVUE5dldSbVR1MGU3ZDdZZWdzaVJ3TFVS?=
 =?utf-8?B?V0d1NTFtb3p3QmtwRFRaQXhYaEZVMS9IOXlzaVIvR0l2blhiWWRSbDRjZjJZ?=
 =?utf-8?B?dm1WQXFHK1VkbzczR1VoYU5Bcm9LS0lDaVJhOWQxcTJOanZaaTJUc3JLd0xa?=
 =?utf-8?B?L1hMRUxtL2ZuZFlZMG9tZUdZdHUrcEhyc3M4YU9sOGJFUGlrYXQ0UGhUUXUr?=
 =?utf-8?B?STdCbXhRekVlaU9FWVIyV0kvUmxKellwUzQ0QnVPNTIyT1BkSjJHWUtrQmtS?=
 =?utf-8?B?MWdsTmFCVjVlQmkvS1oyRG0wUVNpVTVlbzd6Sy9EVnFxYURWTDVRdlhIQmRQ?=
 =?utf-8?B?eDlwMXFFd0dwREErdVJEMEVNSUJvS3N4OWZtcC93UURMOWRIRzQyK1dRbjYy?=
 =?utf-8?B?TEN3ZEV6QXEvUTlmSUJHclNoOUJvOHMzdk15K2ovWU9GNVJ6aHd6K0FDZGlX?=
 =?utf-8?B?aFU4cWk2TnhrVTdUTW05Z3lXNWFkYjdRNGVQUkxybUVBQy9hd1pGVnJMQ3BN?=
 =?utf-8?B?VHNRMmkvWTUveFFkTmVVVzFjREkzVjBzQnZVTE9abUxKZ0RWQTJGUm5NOGd5?=
 =?utf-8?B?cjIrTFJHRzRQNU8zWUIwdzNRbDNVUVc2djROZkVsWWNmMXdrYWlKUHFCbXYy?=
 =?utf-8?B?UFI4QnRlWnljbStQNGFTYnMySW80Y0x4UGhRTWVzVDFNT2JGR1lrdk1SUWxO?=
 =?utf-8?B?RHM2R0xpK2xaSFZ6SjZlQk1DNzF3Qy9GTGJoUlV4NkkreHEwRnFLRnhkR0FR?=
 =?utf-8?B?bHh4R0xtbVdlbkVQbmt0YXhkd3gyRnJlZCt2ZG1hWlpmblJUM0szd3dIcmF5?=
 =?utf-8?B?N3djK1Uyd3A5TWEvcjdZbjljekJndkxUcStGd21aTnhvRXpETWcwUE9PTlhl?=
 =?utf-8?B?YTV3VVg1QUl0dnFpK0dXNkFvRndNaFM2WjJ5SWZxcHJDRytvTVdRZXBaeEpG?=
 =?utf-8?B?TXpRYXVQVW51ckN6MHdRaXNNQWpyTDNxSmtWSzA1cFdlR1ZoWHY1KzZEUHVM?=
 =?utf-8?B?Z1lNZ0djQ292Vnl4ck9wb24wenJmbC8rWHEyS2dzUCtMd1ZNU3NFSE9LN2Y1?=
 =?utf-8?B?UXY3aHhrSmZYQzF6YVZZWkhPUEEwSWpLSlNNMHNuY1hZUGpLM0Y3WHJQbHhI?=
 =?utf-8?B?RzlabWtzejA0QzdoMGh4RS8xcWUyV1FKOGxYUUVrQmZkbE9qL2t4cnQ5dFJ2?=
 =?utf-8?B?UlAvTm9KL0tBdFF5WTMrc2hHUEIvNUd4V3BHdUNYdlVvalpaRTNndkF6L3JM?=
 =?utf-8?B?bWpWZE9XWFBKdHMrY1BZWklNNDZhTEFFcnFhZDJJb2V2Sjk1L1cxMnA2MHpB?=
 =?utf-8?B?NlVkZkZyaWpQUFg4TmZCZTZxQVllM1JTSUViWmFnNm5xNGFTcXFUbThQZTZp?=
 =?utf-8?B?VmVrNC9KdEw5RlRmdE41NHdMLytaazNjbG9lY2ttUVpxVVBXc3hIcGFLUktk?=
 =?utf-8?B?NndQd1ZTUmxuMnpQbEZuK2c1ZkI4aXpwVEhJd3pSK1hwM2UrSmdhSGRObU9S?=
 =?utf-8?B?V0ppRUs5YS9xSDlCRTFaN21lbnlhSmtmWEhnVXZjcis4SmplZTRqWkFwL1Av?=
 =?utf-8?B?bkFuRkF1K2lMWjZhTjBuSWwyUVg3VDZWRmJkSWN6eWswQWlzUU8xTzg2Qmo0?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b024b6e-54b1-41f7-8c0d-08ddbe7a66af
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jul 2025 23:51:47.6367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GBCeh0Y+GFt068OMYJ5sd9IU3KNw8eikPkoOmlbyNYqQ0vZdVLF9KkseVeD0ddwJp+66T1qBL5wAqH+Ls8nahtg5etmbROqMLgeumDnmhRw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8963
X-OriginatorOrg: intel.com

Hi Tony,

On 6/26/25 9:49 AM, Tony Luck wrote:
> Hardware has one or more telemetry event aggregators per package
> for each group of telemetry events. Each aggregator provides access
> to event counts in an array of 64-bit values in MMIO space. There
> is a "guid" (in this case a unique 32-bit integer) which refers to
> an XML file published in the https://github.com/intel/Intel-PMT

"an XML file published in the" -> "an XML file published in"?

> that provides all the details about each aggregator.
> 
> The XML files provide the following information:

"The XML files provide" -> "The XML file provides"
(First paragraph refers to a single XML file so I assume it means
all this information is available from one XML file?)

> 1) Which telemetry events are included in the group for this aggregator.
> 2) The order in which the event counters appear for each RMID.
> 3) The value type of each event counter (integer or fixed-point).
> 4) The number of RMIDs supported.
> 5) Which additional aggregator status registers are included.
> 6) The total size of the MMIO region for this aggregator.
> 
> Add select of X86_PLATFORM_DEVICES, INTEL_VSEC and
> INTEL_PMT_TELEMETRY to CONFIG_X86_CPU_RESCTRL to enable use of the
> discovery driver that enumerate all aggregators on the system with
> intel_pmt_get_regions_by_feature(). Call this for each pmt_feature_id
> that indicates per-RMID telemetry.
> 
> Save the returned pmt_feature_group pointers with guids that are known
> to resctrl for use at run time.
> 
> Those pointers are returned to the INTEL_PMT_DISCOVERY driver at
> resctrl_arch_exit() time.

It is not clear to me why this work needs to use two different terms for
the same thing.
Assuming it is required, up until this point this work has only used the
term "aggregator" and within this patch is where this work starts
using "telemetry region" interchangeably. When reading this patch
"telemetry region" is first used in struct event_group without the term
introduced to the reader.

Could you please add a snippet in changelog to help with this transition?

> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/resctrl/internal.h  |   3 +
>  arch/x86/kernel/cpu/resctrl/core.c      |   5 +
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 122 ++++++++++++++++++++++++
>  arch/x86/Kconfig                        |   3 +
>  arch/x86/kernel/cpu/resctrl/Makefile    |   1 +
>  5 files changed, 134 insertions(+)
>  create mode 100644 arch/x86/kernel/cpu/resctrl/intel_aet.c
> 
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 224b71730cc3..e93b15bf6aab 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -169,4 +169,7 @@ void __init intel_rdt_mbm_apply_quirk(void);
>  
>  void rdt_domain_reconfigure_cdp(struct rdt_resource *r);
>  
> +bool intel_aet_get_events(void);
> +void __exit intel_aet_exit(void);
> +
>  #endif /* _ASM_X86_RESCTRL_INTERNAL_H */
> diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
> index a5f01cac2363..9144766da836 100644
> --- a/arch/x86/kernel/cpu/resctrl/core.c
> +++ b/arch/x86/kernel/cpu/resctrl/core.c
> @@ -734,6 +734,9 @@ void resctrl_arch_pre_mount(void)
>  
>  	if (!atomic_try_cmpxchg(&only_once, &old, 1))
>  		return;
> +
> +	if (!intel_aet_get_events())
> +		return;
>  }
>  
>  enum {
> @@ -1086,6 +1089,8 @@ late_initcall(resctrl_arch_late_init);
>  
>  static void __exit resctrl_arch_exit(void)
>  {
> +	intel_aet_exit();
> +
>  	cpuhp_remove_state(rdt_online);
>  
>  	resctrl_exit();
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> new file mode 100644
> index 000000000000..b09044b093dd
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -0,0 +1,122 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Resource Director Technology(RDT)
> + * - Intel Application Energy Telemetry
> + *
> + * Copyright (C) 2025 Intel Corporation
> + *
> + * Author:
> + *    Tony Luck <tony.luck@intel.com>
> + */
> +
> +#define pr_fmt(fmt)   "resctrl: " fmt
> +
> +#include <linux/cleanup.h>
> +#include <linux/cpu.h>
> +#include <linux/intel_vsec.h>
> +#include <linux/resctrl.h>
> +
> +#include "internal.h"
> +
> +/**
> + * struct event_group - All information about a group of telemetry events.
> + * @pfg:		Points to the aggregated telemetry space information
> + *			within the OOBMSM driver that contains data for all
> + *			telemetry regions.
> + * @guid:		Unique number per XML description file.
> + */
> +struct event_group {
> +	/* Data fields for additional structures to manage this group. */
> +	struct pmt_feature_group	*pfg;
> +
> +	/* Remaining fields initialized from XML file. */
> +	u32				guid;
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-ENERGY/cwf_aggregator.xml
> + */
> +static struct event_group energy_0x26696143 = {
> +	.guid		= 0x26696143,
> +};
> +
> +/*
> + * Link: https://github.com/intel/Intel-PMT
> + * File: xml/CWF/OOBMSM/RMID-PERF/cwf_aggregator.xml
> + */
> +static struct event_group perf_0x26557651 = {
> +	.guid		= 0x26557651,
> +};
> +
> +static struct event_group *known_event_groups[] = {
> +	&energy_0x26696143,
> +	&perf_0x26557651,
> +};
> +
> +#define NUM_KNOWN_GROUPS ARRAY_SIZE(known_event_groups)
> +
> +/* Stub for now */
> +static int configure_events(struct event_group *e, struct pmt_feature_group *p)
> +{
> +	return -EINVAL;
> +}
> +
> +DEFINE_FREE(intel_pmt_put_feature_group, struct pmt_feature_group *,
> +		if (!IS_ERR_OR_NULL(_T))
> +			intel_pmt_put_feature_group(_T))

As you state in cover this snippet cannot make checkpatch.pl happy.
I would propose that the issues trying to appease checkpatch.pl are
documented in the maintainer notes of this patch.

> +
> +/*
> + * Make a request to the INTEL_PMT_DISCOVERY driver for the
> + * pmt_feature_group for a specific feature. If there is
> + * one the returned structure has an array of telemetry_region
> + * structures. Each describes one telemetry aggregator.
> + * Try to configure any with a known matching guid.

I interpret "configure" to involve "write" activity where, for example,
settings are changed and things are ... configured. The way this is
written it seems that resctrl is configuring (i.e. making changes to)
events known to it. This is not the case though (?), resctrl is just
doing discovery of events here. How about above is instead:

	Try to discover any with a known matching guid

and configure_events() -> discover_events()?

> + */
> +static bool get_pmt_feature(enum pmt_feature_id feature)
> +{
> +	struct pmt_feature_group *p __free(intel_pmt_put_feature_group) = NULL;
> +	struct event_group **peg;
> +	bool ret;
> +
> +	p = intel_pmt_get_regions_by_feature(feature);
> +
> +	if (IS_ERR_OR_NULL(p))
> +		return false;
> +
> +	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
> +		ret = configure_events(*peg, p);
> +		if (!ret) {
> +			(*peg)->pfg = no_free_ptr(p);
> +			return true;
> +		}
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Ask OOBMSM discovery driver for all the RMID based telemetry groups
> + * that it supports.
> + */
> +bool intel_aet_get_events(void)
> +{
> +	bool ret1, ret2;
> +
> +	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
> +	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
> +
> +	return ret1 || ret2;
> +}
> +
> +void __exit intel_aet_exit(void)
> +{
> +	struct event_group **peg;
> +
> +	for (peg = &known_event_groups[0]; peg < &known_event_groups[NUM_KNOWN_GROUPS]; peg++) {
> +		if ((*peg)->pfg) {
> +			intel_pmt_put_feature_group((*peg)->pfg);
> +			(*peg)->pfg = NULL;
> +		}
> +	}
> +}
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 71019b3b54ea..8eb68d2230be 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig

Kconfig has its own thread.

Reinette

