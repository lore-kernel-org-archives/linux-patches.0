Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2CE17A2EC
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 04:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755144558; cv=fail; b=djZOsbPW3v/vwY4fzcQfC9Y50WimLGauw0V8reSuu8nGtiYXKgW04EmLUcBb1SymG7ZtyowcGQjq8Xw8Bt+NmT4FhYmMUGySStnLu9BPjiTnzNe6KRdXDCIoJRy6EO0pFqUqSgB5u+ee96rle7gclCw+p9eOUs8XuswWD4rZ+DE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755144558; c=relaxed/simple;
	bh=tE18G1bRxn7uNw4tRONxJWZRcvSRnu/eSXiRp8M4MVc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=k828AeN7wTcSBWIsiMw1hWOAPy1zYu7bFIgHyy1b+Fa73PJk8CVWEuBxPcvJysOVtzuqBB6kjqYS7ltlsOigb38BzGpYzewdvftaOgi/c2zd5beiQbsPcNxgAaidcxCkfTJjNVu11gXBMThxEYYzDJirovrI7vJIsUXwzNfBbiY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XeaUUmL7; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XeaUUmL7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755144556; x=1786680556;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tE18G1bRxn7uNw4tRONxJWZRcvSRnu/eSXiRp8M4MVc=;
  b=XeaUUmL7WMW/3IG6as1Qzo86gMHgKMwsvt43w/KBPit2Tln1bYBoErE6
   6HWDkYEBy+7ZYLcLKgPABsyA2kPcjExfHuSrkWgdwY+hTj7hNHAkax0Za
   +GGeBlzYxLqRELv7konGsOqDa8Bhbor16BG0c+n3Fl1gIy14g2GjAKrjM
   H8P6Px9pgZjJ7mwyRf3QUazTBIRE6Nq+/FRDQkh5stXc6YEaq2jGpXSvT
   Gs3U7MQOyByG381ejmEEBSNIREYJAWs7/Oucx5cYmh5lSr1RkRiODHd9G
   DisWchh/i4Jq4qNDU71umiSXPjrTBvPsEKUcurxnfGSlHNxABXyVAnpcy
   A==;
X-CSE-ConnectionGUID: rq6uD4cOSoicD1EcyjMpKA==
X-CSE-MsgGUID: naPkB1+RRbyoFKGQopfdfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80029854"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80029854"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:09:16 -0700
X-CSE-ConnectionGUID: ZZVCnbhFSl6x1rxa1GjR5Q==
X-CSE-MsgGUID: IPHaYFVZTsabjBvib4QRag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166567914"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 21:09:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 Aug 2025 21:09:15 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 13 Aug 2025 21:09:15 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.48)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 13 Aug 2025 21:09:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GP053vBNNOiH+ELOl/QZBoRRr/p6Y8Qnbc7/YFvGVIsK8vKZ5Q5ymnljNjPxoOGWkNlGdklszX25GiSuPRsBDIV9ptFfE+g9JiZnPrLgUmz13NooqUczlcLX/2gwGhaBhuZOcO3oA9WNoWLFyBNQidUQ9f309zTw8MJg19BQzDb0F9v0qxPn967BKl4JDlfMkETOplggRKCpeeyghgCCFagG59EWNwrcTkMounZL+c6cNDEJ8Oj0r967t5jTFJ0wAdc7XcLd87i4QLJ0WlPNktgwAs4hNxQi23Sug8tchVdWyButn0QZ2bcV6jK7GdQAEXvsbP1eSteT1HPqIWIKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3tU2X4fwfuX/K0y6IZ5asJwvAwehn365JoyFxkCMsU=;
 b=AZe3/DjLAg+0fikZ3L1JKx1dDI05t37chlmgJ5TRqTJGUr70avevG56w0/gElVXS9ebHPpaju6A9c1cw2RYH+273zyTin9jJiRHHDJXlLsryIp6ey5JUc18qXCAS9j1PqpH06gNBWTfcmWAFG3xatokqXP/pZeFAaKNpIdO4dYjEvSIy6J9e1SE8Wu0e6dvQEY4VyhKXoH6Ucpmtgnum72+9NlvVxI1ZHBLg98zV5ZztkUhKAIU7DxYlaVX5YNSLLAIIRqnghzpLznzRbAgVA5/2jBvuxHpv6iutWJzDdva0Ts5/D9mULxuG25/jJ6tcvgb1ytMAt3hH2twgQlkC3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SN7PR11MB6946.namprd11.prod.outlook.com (2603:10b6:806:2a9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.16; Thu, 14 Aug
 2025 04:09:13 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%4]) with mapi id 15.20.9031.012; Thu, 14 Aug 2025
 04:09:13 +0000
Message-ID: <87f8af1e-24de-4f1e-814a-2904dc1d2e56@intel.com>
Date: Wed, 13 Aug 2025 21:09:11 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 10/32] x86,fs/resctrl: Rename struct rdt_mon_domain and
 rdt_hw_mon_domain
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghuay@nvidia.com>, "Maciej
 Wieczor-Retman" <maciej.wieczor-retman@intel.com>, Peter Newman
	<peternewman@google.com>, James Morse <james.morse@arm.com>, Babu Moger
	<babu.moger@amd.com>, Drew Fustini <dfustini@baylibre.com>, Dave Martin
	<Dave.Martin@arm.com>, Chen Yu <yu.c.chen@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
	<patches@lists.linux.dev>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <20250811181709.6241-11-tony.luck@intel.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <20250811181709.6241-11-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0238.namprd04.prod.outlook.com
 (2603:10b6:303:87::33) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SN7PR11MB6946:EE_
X-MS-Office365-Filtering-Correlation-Id: 22089cc0-32ca-49e9-7fed-08dddae85411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?d0c2V3B1MzY5Vkd0NUFsY01OZllFNzRkTFM1RHYvUDZzMXNWZmQ5NUM5aytT?=
 =?utf-8?B?UWdiMEFVSFU4NjFYMHJHQW1pTUdjVDNlSVNJZEJiYUlKdGgvUGMyNE5qNTZi?=
 =?utf-8?B?cHRnL2xNRGY1aXRDSmRHcllhN214TFNDY1o2a0I2M0MrMHkwUlNoRmpFWVl3?=
 =?utf-8?B?TmVVelFGdDlHNk9xQk9zV3ZHK3ZjQ0xiaHZLSTZIYmN0eFhjYmI1dVdPbEhX?=
 =?utf-8?B?UWMzYnRBNnlvdjBVSzRrd1dhTERja0gvQ2tzWlRsYWNYOFphWG5KWmlsdjAy?=
 =?utf-8?B?S2tnTUZrLzFTVU5hQ2J2Y3Znd3AvYnNkR0ZZTjhoUHV0eThOQnFqVHduZTIr?=
 =?utf-8?B?dGpMOTAxTTIzWU1ST3lhRXFlTDRaZlJLczA3WUZGRkRLbzBxL0FQb3E1K0d3?=
 =?utf-8?B?b0wyd3duaG83RzNBb1ZXWEx5YlUyQXIzeDBNOW5mWDN1MXhmdUxQZFUrR0dF?=
 =?utf-8?B?aWdYczVnODhLRlA3anNsUHBTR3c4N1NkcTJzREVMY0ZxOGdiUHdYQzcwaG5S?=
 =?utf-8?B?WVNRRTNwWFNpUytUak00LzZGQzBOdy9ZNkdNVEt6aDRpODVzaUxDT1F0Z25n?=
 =?utf-8?B?TnQ0Sk80RVRTRXhpTkRQN0pIWHVvUGs1Ymw5UytvSkhPM3QxYStua2dsK01V?=
 =?utf-8?B?RVBGNXZQMkZ2dG0vdnIyNzBWZ1c3ZTJackdkWjlDYm9YUDMxL0dySmdKLzJR?=
 =?utf-8?B?UnZONjlNRE5ZYmM1c1RNWFlneVZadVMwbzJSaklocGh2S0kvblBsc3ZjQVpu?=
 =?utf-8?B?RHJKSHd2QTlBN1B4MlpaT0tEU1kxbFR2TSttOUNjMjdVLzlMblRTTEdQVm1J?=
 =?utf-8?B?NUZtNFgza0NDTTUyenVuTlhHeFBHZ0laanVyQXdBRFVzUGRodFpTOWZtNldu?=
 =?utf-8?B?YkowZVRVK0xva2xXNFdrRlgvN094bGpETjZoT213dGxYMXJ6LzlwaVVyOVVI?=
 =?utf-8?B?RGJpWHJxZnRFOFVUQlFTekpCQTdtNHNIV1c0U1B1MzkzcDIzUkhKWS9WcGZp?=
 =?utf-8?B?cHZJUG1jaFMzeE0rWXlJZC82Y0JRVjBvek5VR2M4QkdTcHFZeVhrM2lNV09j?=
 =?utf-8?B?L3orSTVKRUs1M1lRa09MeEpVWDBjL1lkR3ZQeHE2RjB3ZXpGV0E2bTgvcjlk?=
 =?utf-8?B?TTZBSFV3bTVhWitOeXVKYzVUTWErMEM0aVY1dlhuOEtJMDRidjZvTytQMGZj?=
 =?utf-8?B?eHZ3N2x5K0NIQk00eWJBL2ViMnF0Q3FMOFErL3J0bVIrSkJOZDlWd29mcUUy?=
 =?utf-8?B?S1JqVTBOZnMrR0dBWWJ0a2NHaktDcWZnOEVidExMRnVuWHRvZGNkTFVoMm1n?=
 =?utf-8?B?Zm41aWpEdWkxV1lDeDBqeFNsLzlHUFdqYmVxNDdmV2Z1S2VKdncrQ2xrN2pG?=
 =?utf-8?B?M0hVUjUrTnJyNjhubFBRS1IvNnRxcWtPVlEyL2xNVytVamxSaHRlYmNMa3F3?=
 =?utf-8?B?UUFYV1pCYmlJWWNzZWszdGk4STZDSnNDZlVuSmRVMDgwMnZyRnB3SEVFTlBI?=
 =?utf-8?B?RGJFWXE0K3doMkJkNFVYdmdlU3U0ZHRzTUpybllnQ3VuQ0ordkdJTTlueVJj?=
 =?utf-8?B?cjhkTGdNL2JBUTlqb0NlRTBzaGJ2WFB5YWZvSzd3UFEzWHlsMVMxZnRGcHdN?=
 =?utf-8?B?cWRZZHVpK2FSV2d0WHRNeC9PVUdxaS9Eai9JclpwTi9SSzdSK2s2VWRjL015?=
 =?utf-8?B?QmQ3eWwybVRJR3F3Y01ya0NjOEE0ZFVIckJRRXZjRE50YkYrbzM1Z01JMlI3?=
 =?utf-8?B?T3FWZ0E2THBSaXJFNktyc0hXdXZLNGZnTm1MOEdOcFU4TG1lUEZVU3Vla3Vm?=
 =?utf-8?B?Q1hSeG5YYXdLN2ZrNG5BQnRFYkQrMHB5NHBrYy9BQzNTV3cvaFAyTzN0MXpP?=
 =?utf-8?B?NkNTUW4wMngyRWRKZ2dnaFNqWE54YnRXNGtGWTZBNE4ycElhc1NPYkp6SWU4?=
 =?utf-8?Q?Ia+s5M2KqP4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDYvc0dZdUE0UFM0TWlpTlRKNk50WDM1alR3Z1BjdEdzVlVzUk9RbENicmty?=
 =?utf-8?B?MWdDdlpwMVd2TFpMcDB0NjltUlk1UXcxZEhsRklsYkVaNldISmliQmlqZ1Vv?=
 =?utf-8?B?bXY3c1hlNFp4Zmg3RFZUMDI0aHArb2dCdEpJOG9JWHpGTVc4WUQ3WnVzTGFE?=
 =?utf-8?B?RFh5eXRXNHdYeVRUbWdVMEdZNms2d0lNcWlId0NROHZIVDN2d053ZCtJQW9j?=
 =?utf-8?B?ZVVTL2o3ZTE1bUtaSkxkNjFWL0kvK2ltNzJDckloK0VpVmFZaU1saGdwSzNs?=
 =?utf-8?B?YVgvRDcvTlNUSmxIdEZnNzZsVmx0Mnh2L3dSTE9Tbm1JNUwzRmV4V1V2VWl2?=
 =?utf-8?B?azJMVmZWTkI1d0s4Z3gzRXR3b0xNc1VickE5TEkxcDQ5ZkRRYytSVDhrQ2ZB?=
 =?utf-8?B?R3E4ZTdLMnZQUlNnSUV4Wm94V0ZpNkZDeENiTTJMUzZQQlV2dDZFTHZXMXA2?=
 =?utf-8?B?R09KT0tMM2hqQ3U4Zkp6SEpSa0xZR21uTlMzaUJudEpkSGFtZUM4ZDZsc1VB?=
 =?utf-8?B?dHVicVZrOTNvWmRiTUNHZGxiN0xkMVpvL0VXbFN4TGlhY2lQeWtGZEozZUcz?=
 =?utf-8?B?T3JGV3c4eFZkTklTOWU4R1JvcEc0ZmxvYUJwYnNKdE5XSTVOcG1xR0hFdG1p?=
 =?utf-8?B?YWpMQ1RuZ3g2MUJNalFpNDlJQlRUZUltUmZFMzNuTWs5RFplMXVNNk1DN1Bj?=
 =?utf-8?B?R3ltcVJ5N2JtQXJZME1iUFhPQzBYc0VYcWwzK3dkOUpMMVo2UmxzMTR4WVdP?=
 =?utf-8?B?ZDhwQ01nK0QzOGZKaFBMeXFlZkgrS3I0VmprMmpLOTAraVRRVDd6Y1hqQ0V4?=
 =?utf-8?B?ZUV3OTcvR2NueDlXekhabmRVS2o0eXpNa0VCbHZQaEN6R1BubWN1c1RnODdS?=
 =?utf-8?B?eGx6WGh1Zmw0TVI3WFZEU3kxMGZ2aEppUFVsRFIzVWVxVGNFVjFPanZPeUtt?=
 =?utf-8?B?dkV4cGVybC85alpiWEE5ZEFwaGJPVXZDemRsV2pBSmp0Z0tiOFpsZW9DMklo?=
 =?utf-8?B?ZW1Qdm1CZGlYNnY0anREWjIyYk04bk5SZjRyZkxFNEMyWkFsL0tMaWRwekVI?=
 =?utf-8?B?cFQvcXhLZTJnZmhWMXpmY0FYaHBvMHZ4RDFvcHJmbWtFS3dFVm9MSlRGWGVk?=
 =?utf-8?B?ZUUxQ09SaVJ4M0hxTkZDTzUxREZoOXFNdmZOdmtZajQveVBHa0JYMTNaREoz?=
 =?utf-8?B?eW5RT21OVmlxMWtha01SUlZoVjlsWHhnTEdPbi92WjJTMGMvYkx4TEM5eHVO?=
 =?utf-8?B?c3FxTkhNdGYxc3hVTUZCOXRqL2Y0T0g4UXMzVk5FaUc4OTVwa3dFZ0lOL202?=
 =?utf-8?B?eXNobmQrdFFMRi91V0JRdFFhYTl0cG42bmJmZGw2a1Vtam9LcW5MeHc5K1Jw?=
 =?utf-8?B?RDB1UHV4ZmZiVFFnbXA3Vzc5VGNOb1phODYwS2xRTzBMTGRLVHJIZXZURldT?=
 =?utf-8?B?UVNxaGhRT3diWUJjU0k3VERSQzREZzcxcVNEaW13VE5iRlBaNW1hUVFUWjdv?=
 =?utf-8?B?L1NROEdHV1RJVFpENFNtczZWQmtkR1hLN1VtQ0QzT2tHSU9md2s3NnQ4MjNV?=
 =?utf-8?B?a1kzM3h6RC8vaXJVaFpuYnRJaHkxWHgzSzBHVUJZeGVCYVJ5aXM5ZjRXdDRG?=
 =?utf-8?B?QzczeWt3RHJzdXNWQ2ZOMGdULytYWUEyeldNUHFFSkF6YjdEMzZVWEZmeXJ5?=
 =?utf-8?B?MmREcWNNUXJHWG1XWVRtTFR3YnNNY0ZsckwxQWNvZnZqRHRYQUZUNVY5bmJ4?=
 =?utf-8?B?TFRGc3NzS1pHb2dlNXdDUHNmUmVuRXdVNmpTZmN1bkQ1SkhDV3o4TVZBNXVq?=
 =?utf-8?B?Y3Arc3dURUhVa0RKUnJsVDFIcllBTk1KckdQQUE0REdmWjU5SG5qdmw0VThJ?=
 =?utf-8?B?b0Jtb090RkhjWlNRcnl3aWREeVFEby9ZK25ocGxYUWU5TU1CSlNzdUdkNkRv?=
 =?utf-8?B?Ny93TmNySlM1TTNjclIrcXFiT25NZHY1VGJ5cFk3b0t6WEJRd1NxRHJNSFdw?=
 =?utf-8?B?MHJrWG0yMldaTm5KQnYxZ1RxMmZOOUozbHl3QTc5OEFTUm15UlJpYktreW9p?=
 =?utf-8?B?dFNBUkw4STk2dnFBb2R2N0hBd1UzV0lUaHp6WWJIMjB5c0VaSE1tRWVDMThj?=
 =?utf-8?B?K0VpRklwZFgycVFHNE01My8xa3VBRGRkY1lsdUNNZ3o1YkoraGVPeWZNVHZl?=
 =?utf-8?B?R3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 22089cc0-32ca-49e9-7fed-08dddae85411
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2025 04:09:13.5524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JF9DFNlJSI46i+Yd4/zn9ML6Civ4FDk0DQNsBEzLEK14kfNTP1rorc0DZRBJr1obyg5H2ZnnTsMWgW26AdiS3sPAU/RAkW68A8BWH8uA8f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6946
X-OriginatorOrg: intel.com

Hi Tony,

On 8/11/25 11:16 AM, Tony Luck wrote:
> All monitoring events are associated with the L3 resource.

With a bit more context:
	All monitoring events are associated with the L3 resource.
	The per L3 domain resctrl fs monitoring state is maintained in the
	generically named struct rdt_mon_domain while the per L3 domain
	architecture specific monitoring state is maintained                       
	in the generically named struct rdt_hw_mon_domain.

> 
> This will change when support for telemetry events is added.

	Upcoming telemetry event monitoring will be tied to another resource
	and requires new domain structures. 

> 
> The structures to track monitor domains of the L3 resource at both the
> file system and architecture level have generic names. This may cause
> confusion when support for monitoring events in other resources is added.

	Rename the L3 resource specific domain data structures to include
	"l3_" in their names to avoid confusion between the different
	resource specific domain structures:
	rdt_mon_domain		-> rdt_l3_mon_domain
	rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> Rename by adding "l3_" into the names:
> rdt_mon_domain		-> rdt_l3_mon_domain
> rdt_hw_mon_domain	-> rdt_hw_l3_mon_domain
> 
> No functional change.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---

Running "git grep rdt_mon_domain" with this series applied found one more spot
that needs to switch:
arch/x86/kernel/cpu/resctrl/monitor.c: * nodes that share an L3 cache). Linux creates an rdt_mon_domain for

Reinette
