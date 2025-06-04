Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A6086250
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749010442; cv=fail; b=fGv3li21KCbNGvElqnCf4n3fhz88DgOrKKhGReGBPKDPB65rLqdh05LJY9cLGA7EDriGMb8cvLHl7cjqzrdcSJkf5mEt2maKPcSey6av8F6CcwXPHgFhYzusRBNbjQ1n28tEukS/zE1jNmIK1BIT33CZVPsCpYbrVa8bvjrss2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749010442; c=relaxed/simple;
	bh=P7HU8IJg5W/owP7vbwGCdJZInHYJ1wMx00nT9hHdsRs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jw9SqnWanb6tG8g1yAcDOJXr9Kzq8ZrUoel+DRM9X56Sirpv/3dG5mVDo45a9sOxPmG266zB8GFxzbEPQ0Bbc9rNEG4yvp+/MXHcUTed3QcwKQjIU6mMAwyGGNdGCLKModstLZqyTBwG3VgEEoj+veT1AFKAbtF47kv1Nq3ACJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BW2Dz2fI; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BW2Dz2fI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749010440; x=1780546440;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P7HU8IJg5W/owP7vbwGCdJZInHYJ1wMx00nT9hHdsRs=;
  b=BW2Dz2fIj0zIQTZLcf88LqXdwoK5LxV4VuAVIJLDOri+kfro3LHWzUmU
   sYHaJIGx1iTjrs5ktUPbub2gIjNW2TwMcNlKjzG6+anEs5qyJu6nT/toY
   rCDoP9wnPab8V8zhTAqNPSCkXF0xIkFSeaFsGEOqpnUupIIV+nhe0WNdW
   bizNu7NGaNsCWYSjIiCkYQcnq+2iH8Ed7HBIRW+WYziATV8WkL7bW27Kz
   uc4zHza5UcZ/XYPVjilQgbFHuitUKh9AHNnBt+TUe/J790nt8P7DBTzS0
   8KQs96vGCMvSw58e7hKP72ho1Jv40jxtjyMuVQaFTQjnbgVlYeC5svKjU
   Q==;
X-CSE-ConnectionGUID: 53lHoxFmTrmsCQkcdyNk2w==
X-CSE-MsgGUID: uy1onV9YRqaGJyQ+RBjVPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11453"; a="50942516"
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="50942516"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:13:59 -0700
X-CSE-ConnectionGUID: Fk1v8SvJQDa3F6AQ3m2v6w==
X-CSE-MsgGUID: wAeguXIUQiuWlHkM8t9dmg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,208,1744095600"; 
   d="scan'208";a="144929965"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2025 21:13:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 3 Jun 2025 21:13:58 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 3 Jun 2025 21:13:58 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.42)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 3 Jun 2025 21:13:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pcf7zlzJPmLwA52auV+dUS5ckfLAj8uqlRWN+h1eic+N5s4jhCpVl67AftoFdnVwDV+2xQWPpDfvGtKsgdJdBSnYnMfFezR7b4LaUTWLvgmsk8WvqJCusf5HxGKx5D6Bab9pVZL5yzbXQaGypABaOe7ZlSJbc+5+KBmE7/A0XRAZ95DB79LtvRpD0hnsKJ3Qpp6O6HEgMXjg5UvKzbr1MFei2NZeFLXjOPRRZwQZ26E3TC3EJCxidFWaYTo6IA2SlPpCNJbCsdtxbkK2qqq0//h47g1Nty80sOHDURW/J4gho8gOO9TwPc5R/Unk50TGShButeDarXyuixVNytIPBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PWwlmZWPG2P0PPSJmmBfpM28WfQyhnvhAdvlD6H+zfE=;
 b=kj6Wm3/9YNSo7cDaUHE2HDtcxVq4F2KNRWBRbiGCUqG/YaX49NlOq1TTwG2Y/kVFZGLJ2WELPGc6qfclusYwLtG/mDgbDwy+VpZLyEVsMW163NIoiEWIn/9Hn0erjU8Zjt6AfEFWETmknxGxVb5Me37I69GtNrBU7CC2V3C2c+UYdDiGz0dMkm8Cb3pNpe9xmnB7U+2DRRMyowFcTp8rTNrMZV4CwQtDIdqxMJda8lPKfP+gLcwHwRL3+4IPK6yIm+yRx5sCUhBFmwIiiXVOKSjciTLtMMaxgws1dxQVfWopa5H2rwZDUOq3VG+sCOrAE6sAdkU0S4mh/lppyGHE8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DM3PR11MB8714.namprd11.prod.outlook.com (2603:10b6:0:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8792.34; Wed, 4 Jun 2025 04:13:55 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%6]) with mapi id 15.20.8792.034; Wed, 4 Jun 2025
 04:13:55 +0000
Message-ID: <f1249675-a3dd-4222-a3df-a20b9db3047b@intel.com>
Date: Tue, 3 Jun 2025 21:13:53 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 25/29] x86/resctrl: Handle number of RMIDs supported by
 telemetry resources
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250521225049.132551-1-tony.luck@intel.com>
 <20250521225049.132551-26-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250521225049.132551-26-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0067.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::12) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DM3PR11MB8714:EE_
X-MS-Office365-Filtering-Correlation-Id: 1637e9d5-4de1-4fe8-e0a9-08dda31e3876
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?KzFIV0pQNDU4RU03ZkJoWHRqakxKSEdWV1hQVU00aGdZandDMWFPTTJ3NWp1?=
 =?utf-8?B?TnB6TmJXbjdVdGdTOENXYWI5b2JEWnhwUUExUGtGaENuVWxtdWtROHRaM2Nm?=
 =?utf-8?B?dWM0cUV2Yy9lNW92SzByMjVKK01MNGF3T0RSSnF4Z2xXNk5hT0RkYUxGT1Bn?=
 =?utf-8?B?K3ZxR3BwRFBJdjdha0lBc1pIU0NWZ1B6ZVFrRTJQMWNad1JYeThDNTliUmU4?=
 =?utf-8?B?MGNVc0JIOE45QldZRzlJMzdwc2NSbk9jaUlnS3hGN0lKQ1hocE1RS3B3MnJJ?=
 =?utf-8?B?NW9HNG5HOGwyTFpWNGcwVmNmM1VCeGVBQVpxTnlrWVlENUp6TGJNMlgralBE?=
 =?utf-8?B?c0pwRmhUQ04yRVBqV3dPOTZkcnM0dlJPUVVDTjNWUDdIWnZBcnYwWlpCVHlv?=
 =?utf-8?B?Z3dqZGJreW53Zzkzb2VIR2JxSXAzWlVBWHFEaG1wYmtDakRTQTl6QWxKUmxN?=
 =?utf-8?B?bG1ZSDVXaElLMDVad2taWVY3NnJ3M04veUtEbFEyb2JzeUpjdHFxYXRCZDVQ?=
 =?utf-8?B?UWdDV251MHR3UTZuTXdzd3JXQ2tJUVJ1Si80SHdKTzNnbDhQSEUvN01rNTVQ?=
 =?utf-8?B?bDNGQktzT0hGVFBVWWV0UWhSV3E5dkNXblFGOEhXTkRVUkNCVFhtb01UNmQz?=
 =?utf-8?B?QlJwM1NlRmtKVXlLd05DdUwxNUhjLzRsQmFiUStqUHdtSVpHS3EwRDlIY3Fh?=
 =?utf-8?B?RGUzdlBja2FuKzA0d2pyaGdpTHBrWHd1a3lRL2UybjVLRkJpUS9UaVVDUnFE?=
 =?utf-8?B?SjVWZ1prZ3M3L1dHSFpWdjIrZllLdGUvbGhCVkJoRTJvallhMFpTWEEwU25R?=
 =?utf-8?B?ZEpmd01JSkh4cTJ2NFVkNytvZ2NoOVJOVXZPR1g0UWhBSE9PSnhYSlo1YVdU?=
 =?utf-8?B?c0RHRFVHeGpVUEVFdkMxVVJ2em95VFBWa1RjejJRaWpnOHA3SWd1L0R0eExi?=
 =?utf-8?B?ZDN5cXVLelFlcXJpcXF5cjRET1lXTWl4YVV1amJSa1V0OUpNTFhFenUwQ0wx?=
 =?utf-8?B?TERoOGlkalUvQ0l2M3pTOFk1ZHp4NkpaNlBnV2txckFkelBKWGtUMnl5VnJz?=
 =?utf-8?B?cGMzZURranpURDRRS3hYRGRxUHRPTXpPZUhBMVlrUzRkNjRXR2ZWSFVaT0VK?=
 =?utf-8?B?eFRTaThpc3BvWDl6QlBVR1h1ek4wYVRrRkMxdEZoaWE0NThsUkFDUDFoKzdo?=
 =?utf-8?B?ZWdubmcwYjNudkxMaGdvVlVuTmNUb2c2MXVJcUJGN1B5VDMrSmxiRXRwOWcr?=
 =?utf-8?B?SnZWb3F5azZyTDE5Q2lVV2dBbzN5bFhROHg2V2xrbWE5Mnl6VDE3dTM1WWVo?=
 =?utf-8?B?TlgvTE43em90MTZhRjA3YSs1MlFmK1NLbjNzQVJ1TE5ySUt0R1EzeUpNdWx3?=
 =?utf-8?B?cXVNZmI5Y3AvbjJsYll1cWZVOGg5MktQZW93c1RSeVhLOVROa3ZDQmdpcXN4?=
 =?utf-8?B?aE5pcEc3QURzN0RwMzkya0M2QUJaNlFWa1E2QTdRMHRPSldvM1RJQW5sUDZs?=
 =?utf-8?B?b1ZWRXdzdEZYU1VtaHpSNDBlRDQvN3RIOHdzeG9CUzQ5K3ovd1FtKzRadUlY?=
 =?utf-8?B?ZEJFTXI3NTJ5QUhSdnlOOVFvTnFoR2tRQnFFak5LaTN0bk9nRTRya3p2cHJX?=
 =?utf-8?B?a214ZHk0S1NGUTI5dFlvSXNIS2FMU2FVTStqZ0tvN1VySzFPc2pINzhvZzNq?=
 =?utf-8?B?QmpkNDdEWURNYnAxVkJqTktYU08yRm96ejh1L1dGekRLY3V3S2d4eGJ0SGxa?=
 =?utf-8?B?bDBGLzJocEFtRHozQnZCb042ZGMwQXhHaWlaM1MvQzhOOWlQTmZlL0VtdXQv?=
 =?utf-8?B?RW5LVVZjSER1aWtacm9UUlBuNWhvUUdTNXRoNUhXekxoeWlTdTYrSjZGNW1r?=
 =?utf-8?B?VEhpazhadE11TEdKSldtSkZkQjB0NlNUMHBubkxabU5RcGFOanBvek0yMzVo?=
 =?utf-8?B?dkkzeW5sWlJPZ0VIQ2tGZ3RPckRPTGMvVFJoTDNMVlRGZ3FHcHVVVG1tdlUv?=
 =?utf-8?B?MVo1VVZrcmlnPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnMwL3A3VjNRdXlkaVMxc1RHanB0czdLd3dMRVB3RmlmSThWbG0zQ3NUclRV?=
 =?utf-8?B?aGZqcjFxVTdqckNzT25mV0czdU9idDhYa0Z0SUhXdWxjaHprckJpbllyb2hw?=
 =?utf-8?B?T2RNayttb1YrQUR5aVdqWUVEMzJ6Y3dabEFLOUJtRUhTQmdWMitDdndzUjBZ?=
 =?utf-8?B?dUw5bFo0TkdFOHNhR1k2dG1VZ0dsSCtzNC9URE9yM0d4RjZZVTU0ZkpuZVlD?=
 =?utf-8?B?bWtwck1nWmpGS0RtTmNYZS9XWFByVjVWVzlHajMvbDRhSXFCKzhiRThnZU1R?=
 =?utf-8?B?OS9wbVc2SzV2aTVTamhMNW82WEcrUExBUTVjMm14SU9jSDJMV2FIcG4xQ1B0?=
 =?utf-8?B?eFRIbm9UUlJTY3FQNHZ5Z0NSUlpITmYybzZlNGc5Z2xoWUtOZVY1Ynh3VW54?=
 =?utf-8?B?QWdSaTBSSnZIRVBVbURRR01LS0pFNitYNndiLzlxa3huWFBLRHc1UVVZR2M5?=
 =?utf-8?B?SUJVTWdoRFF0QzJwV0ViN0xzWm5yQkpSN05UMUNZZzNsc0pnekhXYUdSSjRC?=
 =?utf-8?B?WUdwbnRGY29kSVlXYXVPeGpOaDA1N0VySHJCeDVHVE5ieDZmcW1FTEZpUUsx?=
 =?utf-8?B?aXVaa3U2Z2dkQmFueEtmQ2EyeU4zdmtEU3BrZTU4U3RUY1FaNGVpWHJYME9Z?=
 =?utf-8?B?RWVQTlIrNVhyV2FjZlpOWmlGR2RPNGF1Tzg3N0Y4NkVOSTVxRHBLMHJRNTA0?=
 =?utf-8?B?ZHRaVjZybHFLaFRTTEs1UU5UTVJCTEJ1VmhXTE14MFdtcmh0NkMzdFFtZVpI?=
 =?utf-8?B?SHN6akRJalJRQUFzajltd0FsYm5IWVgrN2ZrWGdoRUx2Sk9iNlhOekF4K3hw?=
 =?utf-8?B?M25TdU1sQThtVzJJRnRsSDBaQ2FIY1NpVlFzbmFkUjZwTkVYY05MN3VVS0Np?=
 =?utf-8?B?ci9FSUdlY0hyWUdudVBod0ZlOXVCdnFWOUh6MEN2NEw0eWhDcEs5QldWSkk5?=
 =?utf-8?B?RG5Cck9jWjc0all1MnA4MGIyNjF1ZDZzWjlySzdrTGQzVFlzQ0Nnd0grR0dw?=
 =?utf-8?B?ZVBwanJvR1k4MUlnVWhEYW9WTDQ3SFdqYzJESUtVOCtnSXdaRXVXR1RlcEZz?=
 =?utf-8?B?OWJCeUZJTWtrRlNoVHJhMUN2bjkrR0VqNnBpdEk2L2FNSmpCMWd5NjB1Zktu?=
 =?utf-8?B?ZHFTSEYrQ0FHb1oxcXdlblFWNSs1SzRFRlBWWG5CdmVIb3ZzSllVUVdTMkM2?=
 =?utf-8?B?N25BNHZsQzQ3UmNITW40OC9TOWo5UzdOK1YrKy9vL0x6a01GNUh3MHNrbUJk?=
 =?utf-8?B?bU1ONVpSQ2N4bk1RQlRZcVRQeE1mOXVxaThrb2NvRll1T2ZIOXhabVJCbUR0?=
 =?utf-8?B?anNRR3ZXSm5rOHNaT3VxT1g4NGc5aW01M0d5cDQzQ2dXSnpkOEE3KzVHbHEv?=
 =?utf-8?B?VndCTWEyOHExblA1bkZWYnRGUXQ5OXpDTlFJL1Fta2cybTdsb0dhcy8yNi9B?=
 =?utf-8?B?U21VM3ZmUTZHZWF3dVZOOEVHbGVGbnpLREtVRVNsc3B1MHVrR1JjZ0E2a0hq?=
 =?utf-8?B?MmRuTGpuMzVid1ZjVFliMitCYk9vZHFCSHZtSDlZSEZMc0w4ZFhuMVY2NHJu?=
 =?utf-8?B?U01JNjAzUVR1a1h2dzVwY2lWUFN1MHJTQVE1SnVkWDAwMEs4RlN5bUdwU2lF?=
 =?utf-8?B?ZlJ0MnVKQklEd3ozdE1VWkFrTkNJR2pNU21vTTZyVmVOODFzUFRYYjI0aWhz?=
 =?utf-8?B?RE40R1NWN0M5TkhBQkcxNjkwN2d0NEFabWY1RTI4d0pUQWRUaWdMbUJjbXh1?=
 =?utf-8?B?RzUzY2F6QWU0SklFQnJnOTU3dHkvM3loZzJaMVBZcWViMHNTVTgyaWRCUm9M?=
 =?utf-8?B?MXRTenZpb01TUkFFZmFqejcyZHNsVFBVOHB3eEw2dEVWTGpCMmh1SzVxdXRP?=
 =?utf-8?B?MmMvYkJHZkF4ekRnY2VzQVR1RGpuc0RjVWNxeXFjSzNORVUvbENXZGt1NEVX?=
 =?utf-8?B?SStnelk0eWFyRFdCOWNNL2Y0WU5QMmF0cXdJQnRhYXRES2xJdWttcnRjN0tm?=
 =?utf-8?B?QkIvSDU5Qm5scW1nS1p3d3hqb0p6YVQwTmMxV0c2OUN2c3YweTdnVytsdTVO?=
 =?utf-8?B?c2VJZFBLMSt5dkVtQVdrbGFzRUgxRFZTeWVpaXlaVnNTa1dqYmtnMUExb3R4?=
 =?utf-8?B?QUhQNDBRZHdnZ1YzWGwvM0FhcWZvUVNtb0VHWm5Na21VR1Y2WG5BeXNxa3Nj?=
 =?utf-8?B?VVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1637e9d5-4de1-4fe8-e0a9-08dda31e3876
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 04:13:54.9274
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Li6TxoH2GN2xfZzTzjopyGRxP9FNyPny5MPo0CcPOIE7bz9RnuhBPNsEo6URn2V9rNOsgPcRLTqNJcfhO0yyIYliybFTsjNNTHkKDDHlux4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8714
X-OriginatorOrg: intel.com

Hi Tony,

On 5/21/25 3:50 PM, Tony Luck wrote:
> There are now three meanings for "number of RMIDs":
> 
> 1) The number for legacy features enumerated by CPUID leaf 0xF. This
> is the maximum number of distinct values that can be loaded into the
> IA32_PQR_ASSOC MSR. Note that systems with Sub-NUMA Cluster mode enabled
> will force scaling down the CPUID enumerated value by the number of SNC
> nodes per L3-cache.
> 
> 2) The number of registers in MMIO space for each event. This
> is enumerated in the XML files and is the value initialized into
> event_group::num_rmids. This will be overwritten with a lower
> value if hardware does not support all these registers at the
> same time (see next case).
> 
> 3) The number of "h/w counters" (this isn't a strictly accurate
> description of how things work, but serves as a useful analogy that
> does describe the limitations) feeding to those MMIO registers. This
> is enumerated in telemetry_region::num_rmids returned from the call to
> intel_pmt_get_regions_by_feature()
> 
> Event groups with insufficient "h/w counter" to track all RMIDs are

I'd like to highlight that the above sentence follows a section with
heading "There are now three meanings for "number of RMIDs":" ... following
such a section with a sentence that then refers to "all RMIDs" is bound
to make reader wonder which of the three RMIDs are being talked about.

Perhaps something like "Event groups with insufficient "h/w counter" to
track all values that can be loaded into the IA32_PQR_ASSOC MSR ..."

> difficult for users to use, since the system may reassign "h/w counters"
> as any time. This means that users cannot reliably collect two consecutive
> event counts to compute the rate at which events are occurring.
> 
> Ignore such under-resourced event groups unless the user explicitly
> requests to enable them using the "rdt=" Linux boot argument.
> 
> Scan all enabled event groups and assign the RDT_RESOURCE_PERF_PKG
> resource "num_rmids" value to the smallest of these values to ensure
> that all resctrl groups have equal monitor capabilities.
> 
> N.B. Changed type of rdt_resource::num_rmids to u32 to match.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  include/linux/resctrl.h                 |  2 +-
>  arch/x86/kernel/cpu/resctrl/internal.h  |  2 ++
>  arch/x86/kernel/cpu/resctrl/intel_aet.c | 27 +++++++++++++++++++++++++
>  arch/x86/kernel/cpu/resctrl/monitor.c   |  2 ++
>  4 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/resctrl.h b/include/linux/resctrl.h
> index 4ba51cb598e1..b7e15abcde23 100644
> --- a/include/linux/resctrl.h
> +++ b/include/linux/resctrl.h
> @@ -286,7 +286,7 @@ struct rdt_resource {
>  	int			rid;
>  	bool			alloc_capable;
>  	bool			mon_capable;
> -	int			num_rmid;
> +	u32			num_rmid;
>  	enum resctrl_scope	ctrl_scope;
>  	enum resctrl_scope	mon_scope;
>  	struct resctrl_cache	cache;
> diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
> index 524f3c183900..795534b9b9d2 100644
> --- a/arch/x86/kernel/cpu/resctrl/internal.h
> +++ b/arch/x86/kernel/cpu/resctrl/internal.h
> @@ -18,6 +18,8 @@
>  
>  #define RMID_VAL_UNAVAIL		BIT_ULL(62)
>  
> +extern int rdt_num_system_rmids;
> +
>  /*
>   * With the above fields in use 62 bits remain in MSR_IA32_QM_CTR for
>   * data to be returned. The counter width is discovered from the hardware
> diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> index c1fc85dbf0d8..1b41167ad976 100644
> --- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
> +++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
> @@ -14,6 +14,7 @@
>  #include <linux/cleanup.h>
>  #include <linux/cpu.h>
>  #include <linux/io.h>
> +#include <linux/minmax.h>
>  #include <linux/resctrl.h>
>  #include <linux/slab.h>
>  
> @@ -57,6 +58,9 @@ struct pmt_event {
>   *			telemetry regions.
>   * @pkginfo:		Per-package MMIO addresses of telemetry regions belonging to this group
>   * @guid:		Unique number per XML description file.
> + * @num_rmids:		Number of RMIDS supported by this group. Will be adjusted downwards

"Will be adjusted" -> "Adjusted"

> + *			if enumeration from intel_pmt_get_regions_by_feature() indicates
> + *			fewer RMIDs can be tracked simultaneously.
>   * @mmio_size:		Number of bytes of MMIO registers for this group.
>   * @num_events:		Number of events in this group.
>   * @evts:		Array of event descriptors.
> @@ -69,6 +73,7 @@ struct event_group {
>  
>  	/* Remaining fields initialized from XML file. */
>  	u32				guid;
> +	u32				num_rmids;
>  	size_t				mmio_size;
>  	int				num_events;
>  	struct pmt_event		evts[] __counted_by(num_events);
> @@ -81,6 +86,7 @@ struct event_group {
>  static struct event_group energy_0x26696143 = {
>  	.name		= "energy",
>  	.guid		= 0x26696143,
> +	.num_rmids	= 576,
>  	.mmio_size	= (576 * 2 + 3) * 8,
>  	.num_events	= 2,
>  	.evts				= {
> @@ -96,6 +102,7 @@ static struct event_group energy_0x26696143 = {
>  static struct event_group perf_0x26557651 = {
>  	.name		= "perf",
>  	.guid		= 0x26557651,
> +	.num_rmids	= 576,
>  	.mmio_size	= (576 * 7 + 3) * 8,
>  	.num_events	= 7,
>  	.evts				= {
> @@ -253,6 +260,15 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>  			if ((*peg)->guid == p->regions[i].guid) {
>  				if (rdt_is_option_force_disabled((*peg)->name))
>  					return false;
> +				/*
> +				 * Ignore event group with insufficient RMIDs unless the

"insufficient RMIDs" -> "fewer RMIDs than can be loaded into the IA32_PQR_ASSOC MSR"?
Please feel free to improve.

> +				 * user used the rdt= boot option to specifically ask
> +				 * for it to be enabled.
> +				 */
> +				if (p->regions[i].num_rmids < rdt_num_system_rmids &&
> +				    !rdt_is_option_force_enabled((*peg)->name))
> +					return false;
> +				(*peg)->num_rmids = min((*peg)->num_rmids, p->regions[i].num_rmids);
>  				ret = configure_events(*peg, p);
>  				if (!ret) {
>  					(*peg)->pfg = no_free_ptr(p);
> @@ -272,11 +288,22 @@ static bool get_pmt_feature(enum pmt_feature_id feature)
>   */
>  bool intel_aet_get_events(void)
>  {
> +	struct rdt_resource *r = &rdt_resources_all[RDT_RESOURCE_PERF_PKG].r_resctrl;
> +	struct event_group **eg;
>  	bool ret1, ret2;
>  
>  	ret1 = get_pmt_feature(FEATURE_PER_RMID_ENERGY_TELEM);
>  	ret2 = get_pmt_feature(FEATURE_PER_RMID_PERF_TELEM);
>  
> +	for (eg = &known_event_groups[0]; eg < &known_event_groups[NUM_KNOWN_GROUPS]; eg++) {
> +		if (!(*eg)->pfg)
> +			continue;
> +		if (r->num_rmid)
> +			r->num_rmid = min(r->num_rmid, (*eg)->num_rmids);
> +		else
> +			r->num_rmid = (*eg)->num_rmids;
> +	}
> +
>  	return ret1 || ret2;
>  }
>  
> diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
> index c99aa9dacfd8..9cd37be262a2 100644
> --- a/arch/x86/kernel/cpu/resctrl/monitor.c
> +++ b/arch/x86/kernel/cpu/resctrl/monitor.c
> @@ -32,6 +32,7 @@ bool rdt_mon_capable;
>  
>  #define CF(cf)	((unsigned long)(1048576 * (cf) + 0.5))
>  
> +int rdt_num_system_rmids;
>  static int snc_nodes_per_l3_cache = 1;
>  
>  /*
> @@ -350,6 +351,7 @@ int __init rdt_get_mon_l3_config(struct rdt_resource *r)
>  	resctrl_rmid_realloc_limit = boot_cpu_data.x86_cache_size * 1024;
>  	hw_res->mon_scale = boot_cpu_data.x86_cache_occ_scale / snc_nodes_per_l3_cache;
>  	r->num_rmid = (boot_cpu_data.x86_cache_max_rmid + 1) / snc_nodes_per_l3_cache;
> +	rdt_num_system_rmids = r->num_rmid;
>  	hw_res->mbm_width = MBM_CNTR_WIDTH_BASE;
>  
>  	if (mbm_offset > 0 && mbm_offset <= MBM_CNTR_WIDTH_OFFSET_MAX)


Reinette

