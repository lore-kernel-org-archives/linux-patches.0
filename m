Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEA81E487
	for <patches@lists.linux.dev>; Tue, 14 May 2024 18:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715711178; cv=fail; b=jxx/eA1BqpoARHlGAPftExDCb302txsmFlDMuDXhpL3VJCRoqorDFEFpz5aAPKrLv/zHPSVDhi2BRdEd1X0mabfw5R0h8dQKHPTrFitDpSCA5tLRiVn72nvUrz9AyOzzD4MWBwx3eSUxKmrGEkFGTC1FqC8cH1n07ENVMiosQFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715711178; c=relaxed/simple;
	bh=j/vHVDZrn6yZzLptaGc31XAeQjudrEjtx9C+2yaUaLs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GXv0e1n4yXbwg83hNRdY19aRZDyDzO1B042FtR4frPxljtX6VCL/js7ZsqdLpt7MCWVniCkgvM9QlpcS3UFZJLJ6e9lv+P7cm6+IQpwT9g1kovkSmYQbaq9To154lEfXOOfJxgc3BhCS2gbdWp7L/4Mj1TmhQBWACfTG6LzSlKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=io6MF7fR; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="io6MF7fR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715711175; x=1747247175;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j/vHVDZrn6yZzLptaGc31XAeQjudrEjtx9C+2yaUaLs=;
  b=io6MF7fRQhftfKsqom1htCWwLynabh8kZj5cZ8303so6eezMASkf6GUo
   lqP6QzzJX5EC5QsJjD6+l37VSqw8GZpWrgQBeByZa9WBPJBjT/bmjsw5z
   c44B6mgfZbYm0qjMTynSsjHF4kMIgogG5UJ4JMiWiyxSdR9RTPwjTzU6/
   Iw8utJJRut6cizQT90rMHzYDMR31CAaitNIyxAP8KtMpjkDLZPyUISGhu
   SPqsXyyIDqigHp3jSz6/wbD4/45gOPXx087y5oVLgghK3MRA5YiSXjEpw
   t1Zm/LCW9x6ltfqJ7k9TqkPnMecg/oarKLetaso85knzifVTfobLP3LK7
   A==;
X-CSE-ConnectionGUID: 83J53zceRMS2UOvYi0ZEnw==
X-CSE-MsgGUID: z7bQfJAMSa67Xtk0qPLNEw==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="29203396"
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="29203396"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 11:26:13 -0700
X-CSE-ConnectionGUID: tNiO+WWkSwCMX1uC+vkPAg==
X-CSE-MsgGUID: oJe5P97UTA2T9+0r/1Q/kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,159,1712646000"; 
   d="scan'208";a="30849053"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 May 2024 11:26:13 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 14 May 2024 11:26:11 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 14 May 2024 11:26:11 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 14 May 2024 11:26:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqnVfYW7XcxAVIRVIDJ34laoJAQK1q9+BEhuQMQHaWTTeV2keLc1izCZTs6y78jZMmv6i5wkBKu2gXsObtZJY7Ckl2gjzLifK4qlR0zGTsB3anKTcquJyyAffZW+6bnfEShGMkzigvoynBJkTLE5L0kMeQkhqE/huTKBb/31G9Bb7DBYKkWqQ4fTp2up2VIuGFv4jPbylmXGIlhb6GbxtWlImLpxiMFsjwl/VwW+4lvb4HByiV/xvFYSZDhwkkIC3EAptRtZK+l6aybCv51ftObhQt7WrcZBF8UjtQgPHi56URBol8pHfPh08lv9t1fH1xK9wgkaTQ1xB00eLXX/Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/vHVDZrn6yZzLptaGc31XAeQjudrEjtx9C+2yaUaLs=;
 b=HssnGF+Tjwx9gzFXHHfRaMCzp3udWKBVooOjL93zqH+NOpP74Sue2qd1tPFIAmaMhYoGHJ5IrgiM8nmMa1pP36wOm2IizrJ4ql9aoqN+WVABSc5ZmKXnUs6aKZUK57w5bObs6ErazdnU9FaP6+RitTBH44+x3kaVtzf+A4TKI7488hGYRnEVvSazqIul7TxiRCz0ZWQHb0Baf7CRFqIsW3wBVltBMpWDeltAQcXcPGdlBwnE/vIoC5xxj+Yd41aXVl4Bmkx0bEWTn3iG50ipnUYKuNz+cKPCyRNBcUTz40rd+9LkxBuhpOHopeXYlWHZD0m0/wsUkFkMRIkbr0VWWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB6608.namprd11.prod.outlook.com (2603:10b6:510:1b3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Tue, 14 May
 2024 18:26:09 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::fca9:7c00:b6d0:1d62]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::fca9:7c00:b6d0:1d62%5]) with mapi id 15.20.7544.052; Tue, 14 May 2024
 18:26:09 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
Thread-Topic: [PATCH v17 7/9] x86/resctrl: Add new monitor files for Sub-NUMA
 cluster (SNC) monitoring
Thread-Index: AQHanZkyIQcDzwQ9FEGR2mJMAXARJLGRBZyAgASM2X2AAVOCn4AANKkQ
Date: Tue, 14 May 2024 18:26:09 +0000
Message-ID: <SJ1PR11MB60838E2DB2984EF95D34C692FCE32@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240503203325.21512-1-tony.luck@intel.com>
 <20240503203325.21512-8-tony.luck@intel.com>
 <0178e84e-d55f-47bf-b8b0-58e05fcaa108@intel.com>
 <ZkJIZdU2knEUJN7Q@agluck-desk3>
 <f49931b0-d9bf-45f0-ab35-93b1a78f6b97@intel.com>
 <ZkKupOKRu5S7Rkgx@agluck-desk3>
 <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
In-Reply-To: <2efcae46-736a-4809-8530-7dde3977f3ce@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB6608:EE_
x-ms-office365-filtering-correlation-id: defb4664-69a0-4b28-026a-08dc744353a3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?RzczZkF5cU54UmNkdXZXK01wdkUxWE03aWxDYlBjMWxaam14TU5KbDdyclFF?=
 =?utf-8?B?RWVqVERaRXFWMmRlVmZMaHJRdmhLV0ZGTTBUbWFHcm04Tmc4MW56bHBTS0Y4?=
 =?utf-8?B?UVNRRUxLY1V1c2Z2MEZpWlEwSWRvbWJsSnRJN1Fpb3VuOWN2VHh2cm91MTB1?=
 =?utf-8?B?bktKeVpEYTF1VFpsSXFsRW5jV05nNmFqdlgrQXVJZERwUVRoYVQ2bzBSNzhZ?=
 =?utf-8?B?T3ZqN3RUOHBEdG44dUtEVi9JdlNSTnZZOTZiajJvbm5SOEhzbkorZjhVdHBP?=
 =?utf-8?B?QTltM2ZLelc2SjJENk4zaVp0dVZUdGRYdUpGTUpZbXk4Zlh6WkEvK3RCN2Vs?=
 =?utf-8?B?UVlvWGVnVTVCUkhlMlZQWFpWV2lSTVI1bHRYMGlhTDFCUjQ3aElaRG9sTlFu?=
 =?utf-8?B?VndweERNakNNZENQQ2ZjZHJQWW5WQ2d1TzB3SlNpT0J4VnVXTEZqNkFXVk1G?=
 =?utf-8?B?VDBTOGpPWVdRNDBLdEN6VzdBTWMzMkRibUNmRE5ldDRGbHcyajlhU0d0R0Yv?=
 =?utf-8?B?d0dlUlR2cGo5RUVzNlFkUENWK0NFblE2MERQQm1KcW1FYzNJS3F2OVNqcFhk?=
 =?utf-8?B?S0xKc0l4cTRzQ0NQREZCeklJQ2tIazNwOUk0dXlscUI1ZXZqQ2ZhenAva2E3?=
 =?utf-8?B?K2pXR3QvdHBFUCtiY1BsMnNiVmNKNVl2SitYcnpkcGY4T0JnZnV5SmR5UWpt?=
 =?utf-8?B?MTB3ZURibGpuVUUzaE02dFp2NWhlSXpDQ0xXb3JTWFlkWEs5WWVyN2tSMWtU?=
 =?utf-8?B?MWhWQ3VhazhBMmxDVkNna283OXZaODhjOFBqTklVZVU3NW9PK01hWSswVFBG?=
 =?utf-8?B?UWtsK0dNV2hmSmszUHNQTU5EV2xvZFJ0MmxRUm1VTTBJcFVtTEZvK09EUk9D?=
 =?utf-8?B?NzNJMWZIR2p1OXUwTFhsdG9Hdlo2S3FoN1h6bHhTaXl6Q3Q4S1VoZlA3TTdJ?=
 =?utf-8?B?NkdyOWVYVGpLQ0FNRWtrY0RhODhKRThJSzNSTTlmdGRSY0JRTFdQQmRQMUNw?=
 =?utf-8?B?OTdLMWI5NzlHNnN1RWJ6b1UwVU5sWjRvaHlqZkxwUXZySUUvVjJmeTA1VzVu?=
 =?utf-8?B?c25BeEtyWmx2Z3UxRHllMGsxVlphOUtiejl6bUJYSm0xbGdlTVRuV1I3QWxB?=
 =?utf-8?B?bE5NdmowMW1yS0FxWXlYS2JEK2R1bVRXYURJVEFHMEU0RDg5d2FYU0JGWWl0?=
 =?utf-8?B?RWk4cmF0Q3pJNnpFR3VQUTJXazc2cnJuenN3UG9UMXJJdnJhczZjeVQvVStj?=
 =?utf-8?B?V2oxOXZHWElkUEJ2U1VNek4zYzlpVmlCTm9RRTM3ckk4cVBrcWxJa2R3NGxM?=
 =?utf-8?B?cEpJbE5ybk1YeFRyQ3ZSeTJ1UWJkQ2NYV2xXRVdnYmdOVENob2E1ZEU5d3h1?=
 =?utf-8?B?ZERWcWlWM2dDbTRoQlE4TmpkL2x6NExzT29zaXdJK25NczAwWFR6SzNuZ1VX?=
 =?utf-8?B?VktCL3ZaMzRjdG4wajZpS0I0QlpKTThhdEkrYVZ0Ui9tTmNLYnpydUpabGl2?=
 =?utf-8?B?alBydzNweWlmc1JYTFBORUIwTXc3WGsxc2V2dmJwMkxMNHlBS3V4WWJRRjI5?=
 =?utf-8?B?a3BQbENpOElra1RmUVNvMWJITENVQ1I5UkdzRnduOWc1c09RMGE2U1J4aURZ?=
 =?utf-8?B?ZFdIM0U3VldsR0hDOFdMTlJjaVNQOHRmYTN1dEsxU2xhSEpYaUhTSlVoaHVE?=
 =?utf-8?B?dU1VZk15VVJMREdlVjdEd3V5QmJ5L2NjTGlTM0hxdm44Y1hoV2F6MVNEQytk?=
 =?utf-8?B?Q3djdklPc1cwZU03OGFIV3l2bVVrSVVlYm9sMkhDTWMvK09zTVQ4K0hoNzJh?=
 =?utf-8?B?ZkZoLzhtWkhaZjIyajI2dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak5jbjdGK2ZjWUp6T2pya2NwVmpvOUJRUW1ZYjFmcUhMY0ZYKzFDdFBLTG14?=
 =?utf-8?B?MWlsTFBUdHUwNjFTeEREK0ZiUW5Mb2MvSVJDaUY1dlZJNXptR2hnSVBiSGRF?=
 =?utf-8?B?b3o1Z2hEZ205NXljMXBJK0lzQnFHelczUzZYNHZsbEJqay81Qm12a0pCRytM?=
 =?utf-8?B?c2t2SmhtT3o5ZFlPN0huR2d3UXByWmxHaFg0NnJPc0NEVXltWTB3emllWFVJ?=
 =?utf-8?B?M25zN0d0aE44V1o2bFBJU3hRbkZnU0pTVzZMZUpweUZNS1piUmtjWmQvKzEv?=
 =?utf-8?B?bzRQK1UrTy9iZGxOVFhmU0Vyak9yclFuYVpyWjJkRmxJV21qVVVTT0ZURlBJ?=
 =?utf-8?B?SmNVWGNFa1RObVZ3QmFueElqbXB1NEJtMVlpbjZuR0pnMnJqR2VFaWpHV0lK?=
 =?utf-8?B?YzNKRmx4MGJCWkdkWUVpbFp6VEJ4Q3dMU3Z5TVNrZVhPY1FpVEY0djJuR2Zr?=
 =?utf-8?B?T09ib1VSWm5QS25yOTN0enAwVko2Vm9XVm5CWkpIcUNIOC82eWU1WlVBU3hx?=
 =?utf-8?B?aXdaeTBHZEdTOEVDNzFOMHZhN1daMzgvTzhiQURkM0luYlk4d2VkZTBiaGpG?=
 =?utf-8?B?K2YybWZTZEZDT2NPVjJFK0VoSmkrclRzSmNVa3pkQTg5ekJMZ0VLaTJ5ZlZw?=
 =?utf-8?B?ZXRiMm9QZDdZKzlrUExGQVVYbVZUdDZXVXpFbmdMN0FZMml2SHRJdjRmRFFu?=
 =?utf-8?B?dTJZTDNxblJONEhmQXlRUVJLMktHNm9Cbys1RVU3MW9rUFJQU2NabkE5OEJu?=
 =?utf-8?B?SWxLUGIvR1pNMm1SSkhIbk9OOEhWVm05ZlFZbXhma2IySnpualFjblBvTENP?=
 =?utf-8?B?dzFLU1FMdUZuYzZNL0VyTklHemM2QUI1TzhKVTQ0SDRkcDY5U3FhVVhIcFE0?=
 =?utf-8?B?UUhpS2Jabloya2FNS05rQm05S3E2RmRTV21ETnRSTk1obnZYTmxvNTlNaFhZ?=
 =?utf-8?B?VXpYMitNNyt1TmFKT0wrdDdDbkRlbXhTZ1hTTjgzTDBCTjh3VlF5Y3A5VVda?=
 =?utf-8?B?WkJxN2FYdWthdmErOGRPbFlDMU5haTJtWWpPN3pmak4vTStIMEI4NlIxcGpa?=
 =?utf-8?B?Q1JGTnJoVHJFYWRaOElmNWc2YUpyKzVINDJESDN6TnMvZXdsVzN6cThQbXlB?=
 =?utf-8?B?emdDV3B4TDF1TmYxYjJiSDZmb0llUFdGTHFpRGxIK3RsN2syY05SaTdoSndZ?=
 =?utf-8?B?MWpmbUtWSk9sWWpZWUIzSFhOUUk1cTU5UHhzamIycXJ4NTRTWnZwK0NGTHcv?=
 =?utf-8?B?U2dwanFLQk1DMjZuNE80NTFkbnJTUDY2S3VKbVlwQmdtRFpTUnljZmd5cmp6?=
 =?utf-8?B?bVR0L1FwazVEa1NpMWQvUGdUd0ZTUkxjbDRrKzNxU29NbDE4NDdURERiTUZ1?=
 =?utf-8?B?VlZpbHlFYzZ2THlraFgybUlzOGdJWENPS2I2dzdGdENiQUtKdkZab2ZPYy9E?=
 =?utf-8?B?c1JJMzVsQ29yZnJhUjB1azgzWlZKMmlFUGVkaXEzMnJXNnNoNmdFK3IzYXll?=
 =?utf-8?B?aWNxUmxRbXFpUHNJT3dMbWNMRkhXeTcxWlFRbThrUGFIdWNIaWpGaGdvb2xw?=
 =?utf-8?B?dEU5NEhmUXNmNlpaSDlEWERrTVFKQisvblpYTkVNKzN6azdWbzNIcEpXbkpX?=
 =?utf-8?B?NE1GSDczckdTL0tqb0had0hWd2VCUGtwbDA0QkdrVEpsM2xJbHh2ZG1jV0tw?=
 =?utf-8?B?SGdLNTBwM3RnOGNCdWpjcUo3QXlqSXpRYlhzTlBFYVZmejlvTnFRUnVlYmY3?=
 =?utf-8?B?NGNKVnRPMEsrcHlhSDN5Q296ZjRrQndETWhMdmdUU3ljRFducUNIVUxodHZ3?=
 =?utf-8?B?V1U1dW5rZnJmNzRLVVpwOGw2WDI2a0wyaUtERXFWN05vclFFM0dFSUdNUi9B?=
 =?utf-8?B?Rno2ZUZTeDIvNDlwNGRwYjBVNFhpbGxROUFBU25hNGY0b0JhakFzc0VMUDU0?=
 =?utf-8?B?MWRWODVtRkk1Z28vUEF2Z0pkS3I4Z0dmYWtlVmZxbCtNbmp5cndmZkNFeGNR?=
 =?utf-8?B?SDN6eDBXVjc3ckE1MnZwbXBSYmh4cWdlenQ4U0c3c09LUkF3M2pLVWJqSEhZ?=
 =?utf-8?B?emtNSGlJMWs3ZUtqNlpLUzhGSmg4bEhtUllNaFFtN0Q4aWFJYktvTUw2ZUtG?=
 =?utf-8?Q?FnQA5HHJEhWWMpgSUQriGs2eK?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: defb4664-69a0-4b28-026a-08dc744353a3
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2024 18:26:09.4374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pf+ahE/wrQ3+SNBJrHixH2Kp3Bs6qT40uEKmkF00DdgQuQ+DfSXxtABuPwD2o0S4u+XQ5CgEuaqfIhxUwtYc5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6608
X-OriginatorOrg: intel.com

PiBPbiA1LzEzLzIwMjQgNToyMSBQTSwgVG9ueSBMdWNrIHdyb3RlOg0KPiA+IE9uIE1vbiwgTWF5
IDEzLCAyMDI0IGF0IDExOjUzOjE3QU0gLTA3MDAsIFJlaW5ldHRlIENoYXRyZSB3cm90ZToNCj4g
Pj4gT24gNS8xMy8yMDI0IDEwOjA1IEFNLCBUb255IEx1Y2sgd3JvdGU6DQo+ID4+PiBPbiBGcmks
IE1heSAxMCwgMjAyNCBhdCAwMjoyNDoxM1BNIC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+ID4+PiBUaGFua3MgZm9yIHRoZSByZXZpZXcuIERldGFpbGVkIGNvbW1lbnRzIGJlbG93LiBC
dXQgb3ZlcmFsbCBJJ20NCj4gPj4+IGdvaW5nIHRvIHNwbGl0IHBhdGNoIDcgaW50byBhIGJ1bmNo
IG9mIHNtYWxsZXIgY2hhbmdlcywgZWFjaCB3aXRoDQo+ID4+PiBhIGJldHRlciBjb21taXQgbWVz
c2FnZS4NCj4gPj4+DQo+ID4+Pj4gT24gNS8zLzIwMjQgMTozMyBQTSwgVG9ueSBMdWNrIHdyb3Rl
Og0KPiA+Pj4+DQo+ID4+Pj4gKENvdWxkIHlvdSBwbGVhc2Ugc3RhcnQgdGhlIGNoYW5nZWxvZyB3
aXRoIHNvbWUgY29udGV4dD8pDQo+ID4+Pj4NCj4gPj4+Pj4gQWRkIGEgZmllbGQgdG8gdGhlIHJk
dF9yZXNvdXJjZSBzdHJ1Y3R1cmUgdG8gdHJhY2sgd2hldGhlciBtb25pdG9yaW5nDQo+ID4+Pj4+
IHJlc291cmNlcyBhcmUgdHJhY2tlZCBieSBoYXJkd2FyZSBhdCBhIGRpZmZlcmVudCBzY29wZSAo
Tk9ERSkgZnJvbQ0KPiA+Pj4+PiB0aGUgbGVnYWN5IEwzIHNjb3BlLg0KPiA+Pj4+DQo+ID4+Pj4g
VGhpcyBzZWVtcyB0byBkZXNjcmliZSBAbW9uX3Njb3BlIHRoYXQgd2FzIGludHJvZHVjZWQgaW4g
cGF0Y2ggIzM/DQo+ID4+Pg0KPiA+Pj4gTm90IHJlYWxseS4gUGF0Y2ggIzMgbWFkZSB0aGUgY2hh
bmdlIHNvIHRoYXQgY29udHJvbCBhbiBtb25pdG9yDQo+ID4+PiBmdW5jdGlvbnMgY2FuIGhhdmUg
ZGlmZmVyZW50IHNjb3BlLiBUaGF0J3Mgc3RpbGwgbmVlZGVkIGFzIHdpdGggU05DDQo+ID4+PiBl
bmFibGVkIHRoZSB1bmRlcmx5aW5nIGRhdGEgY29sbGVjdGlvbiBpcyBhdCB0aGUgbm9kZSBsZXZl
bCBmb3INCj4gPj4+IG1vbml0b3JpbmcsIHdoaWxlIGNvbnRyb2wgc3RheXMgYXQgdGhlIEwzIGNh
Y2hlIHNjb3BlLg0KPiA+Pj4NCj4gPj4+IFRoaXMgbmV3IGZpZWxkIGRlc2NyaWJlcyB0aGUgbGVn
YWN5IHNjb3BlIG9mIG1vbml0b3JpbmcsIHNvIHRoYXQNCj4gPj4+IHJlc2N0cmwgY2FuIHByb3Zp
ZGUgY29ycmVjdGx5IHNjb3BlZCBtb25pdG9yIGZpbGVzIGZvciBsZWdhY3kNCj4gPj4+IGFwcGxp
Y2F0aW9ucyB0aGF0IGFyZW4ndCBhd2FyZSBvZiBTTkMuIFNvIEknbSB1c2luZyB0aGlzIGJvdGgN
Cj4gPj4+IHRvIGluZGljYXRlIHdoZW4gU05DIGlzIGVuYWJsZWQgKHdpdGggbW9uX3Njb3BlICE9
IG1vbl9kaXNwbGF5X3Njb3BlKQ0KPiA+Pj4gb3IgZGlzYWJsZWQgKHdoZW4gdGhleSBhcmUgdGhl
IHNhbWUpLg0KPiA+Pg0KPiA+PiBUaGlzIHNlZW1zIHRvIGVuZm9yY2UgdGhlIGlkZWEgdGhhdCB0
aGVzZSBuZXcgYWRkaXRpb25zIGFpbSB0byBiZQ0KPiA+PiBnZW5lcmljIG9uIHRoZSBzdXJmYWNl
IGJ1dCB0aGUgb25seSBnb2FsIGlzIHRvIHN1cHBvcnQgU05DLg0KPiA+DQo+ID4gSWYgeW91IGhh
dmUgc29tZSBtb3JlIGlkZWFzIG9uIGhvdyB0byBtYWtlIHRoaXMgbW9yZSBnZW5lcmljIGFuZA0K
PiA+IGxlc3MgU05DIHNwZWNpZmljIEknbSBhbGwgZWFycy4NCj4NCj4gSXQgbWF5IG5vdCBlbmQg
dXAgYmVpbmcgdG90YWxseSBnZW5lcmljLiBJdCBzaG91bGQgbm90IHByZXRlbmQgdG8gYmUNCj4g
d2hlbiBpdCBpcyBub3QuIEl0IG1ha2VzIHRoZSBmbG93cyBkaWZmaWN1bHQgdG8gZm9sbG93IHdo
ZW4gdGhlcmUgYXJlDQo+IHRoZXNlIHVuZXhwZWN0ZWQgY2hlY2tzL3F1aXJrcyBpbiB3aGF0IGNs
YWltcyB0byBiZSBjb3JlIGNvZGUuDQoNCkRvIHlvdSB3YW50IHNvbWUgc29ydCBvZiB3YXJuaW5n
IGNvbW1lbnRzIGluIHBpZWNlcyBvZiBjb2RlDQp0aGF0IGFyZSBTTkMgc3BlY2lmaWM/DQoNCj4N
Cj4gPj4+Pj4gICAgICAgICB9DQo+ID4+Pj4+ICsNCj4gPj4+Pj4gKyAgICAgICByZXR1cm4gMDsN
Cj4gPj4+Pj4gK30NCj4gPj4+Pj4gKw0KPiA+Pj4+PiArc3RhdGljIGludCBta2Rpcl9tb25kYXRh
X3N1YmRpcihzdHJ1Y3Qga2VybmZzX25vZGUgKnBhcmVudF9rbiwNCj4gPj4+Pj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgcmR0X21vbl9kb21haW4gKmQsDQo+ID4+Pj4+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IHJkdF9yZXNvdXJjZSAqciwg
c3RydWN0IHJkdGdyb3VwICpwcmdycCkNCj4gPj4+Pj4gK3sNCj4gPj4+Pj4gKyAgICAgICBzdHJ1
Y3Qga2VybmZzX25vZGUgKmtuLCAqY2tuOw0KPiA+Pj4+PiArICAgICAgIGNoYXIgbmFtZVszMl07
DQo+ID4+Pj4+ICsgICAgICAgYm9vbCBkb19zdW07DQo+ID4+Pj4+ICsgICAgICAgaW50IHJldDsN
Cj4gPj4+Pj4gKw0KPiA+Pj4+PiArICAgICAgIGRvX3N1bSA9IHItPm1vbl9zY29wZSAhPSByLT5t
b25fZGlzcGxheV9zY29wZTsNCj4gPj4+Pj4gKyAgICAgICBzcHJpbnRmKG5hbWUsICJtb25fJXNf
JTAyZCIsIHItPm5hbWUsIGQtPmRpc3BsYXlfaWQpOw0KPiA+Pj4+PiArICAgICAgIGtuID0ga2Vy
bmZzX2ZpbmRfYW5kX2dldF9ucyhwYXJlbnRfa24sIG5hbWUsIE5VTEwpOw0KPiA+Pj4+PiArICAg
ICAgIGlmICgha24pIHsNCj4gPj4+Pj4gKyAgICAgICAgICAgICAgIC8qIGNyZWF0ZSB0aGUgZGly
ZWN0b3J5ICovDQo+ID4+Pj4+ICsgICAgICAgICAgICAgICBrbiA9IGtlcm5mc19jcmVhdGVfZGly
KHBhcmVudF9rbiwgbmFtZSwgcGFyZW50X2tuLT5tb2RlLCBwcmdycCk7DQo+ID4+Pj4+ICsgICAg
ICAgICAgICAgICBpZiAoSVNfRVJSKGtuKSkNCj4gPj4+Pj4gKyAgICAgICAgICAgICAgICAgICAg
ICAgcmV0dXJuIFBUUl9FUlIoa24pOw0KPiA+Pj4+PiArDQo+ID4+Pj4+ICsgICAgICAgICAgICAg
ICByZXQgPSByZHRncm91cF9rbl9zZXRfdWdpZChrbik7DQo+ID4+Pj4+ICsgICAgICAgICAgICAg
ICBpZiAocmV0KQ0KPiA+Pj4+PiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIG91dF9kZXN0
cm95Ow0KPiA+Pj4+PiArICAgICAgICAgICAgICAgcmV0ID0gbW9uX2FkZF9hbGxfZmlsZXMoa24s
IGQsIHIsIHByZ3JwLCBkb19zdW0pOw0KPiA+Pj4+DQo+ID4+Pj4gVGhpcyBkb2VzIG5vdCBsb29r
IHJpZ2h0LiBJZiBJIHVuZGVyc3RhbmQgY29ycmVjdGx5IHRoZSBwcml2YXRlIGRhdGENCj4gPj4+
PiBvZiB0aGVzZSBldmVudCBmaWxlcyB3aWxsIGhhdmUgd2hpY2hldmVyIG1vbiBkb21haW4gY2Ft
ZSB1cCBmaXJzdCBhcw0KPiA+Pj4+IGl0cyBkb21haW4gaWQuIFRoYXQgc2VlbXMgY29tcGxldGVs
eSBhcmJpdHJhcnkgYW5kIGRvZXMgbm90IHJlZmxlY3QNCj4gPj4+PiBhY2N1cmF0ZSBzdGF0ZSBm
b3IgdGhpcyBmaWxlLiBTaW5jZSAiZG9fc3VtIiBpcyBlc3NlbnRpYWxseSBhICJmbGFnIg0KPiA+
Pj4+IG9uIGhvdyB0aGlzIGZpbGUgY2FuIGJlIHRyZWF0ZWQsIGNhbiBpdHMgImRvbV9pZCIgbm90
IHJhdGhlciBiZQ0KPiA+Pj4+IHRoZSAibW9uaXRvciBzY29wZSBkb21haW4gaWQiPyBDb3VsZCB0
aGF0IG5vdCBoZWxwIHRvIGVsaW1pbmF0ZQ0KPiA+Pj4NCj4gPj4+IFlvdSBhcmUgY29ycmVjdCB0
aGF0IHRoaXMgc2hvdWxkIGJlIHRoZSAibW9uaXRvciBzY29wZSBkb21haW4gaWQiIHJhdGhlcg0K
PiA+Pj4gdGhhbiB0aGUgZmlyc3QgU05DIGRvbWFpbiB0aGF0IGFwcGVhcnMuIEknbGwgY2hhbmdl
IHRvIHVzZSB0aGF0LiBJIGRvbid0DQo+ID4+PiB0aGluayBpdCBoZWxwcyBpbiByZW1vdmluZyB0
aGUgcGVyLWRvbWFpbiBkaXNwbGF5X2lkLg0KPiA+Pg0KPiA+PiBXb3VsZG4ndCB0aGUgZmlsZSBt
ZXRhZGF0YSB0aGVuIGJlIHRoZSAiZGlzcGxheV9pZCI/DQo+ID4NCj4gPiBZZXMuIFRoZSBtZXRh
ZGF0YSBpcyB0aGUgZGlzcGxheV9pZCBmb3IgZmlsZXMgdGhhdCBuZWVkIHRvIHN1bSBhY3Jvc3MN
Cj4gPiBTTkMgbm9kZXMsIGJ1dCB0aGUgZG9tYWluIGlkIGZvciBvbmVzIHdoZXJlIG5vIHN1bW1h
dGlvbiBpcyBuZWVkZWQuDQo+DQo+IFJpZ2h0IC4uLiBhbmQgdGhlcmUgaXMgYSAic3VtIiBmbGFn
IHRvIHRlbGwgd2hpY2ggaXMgd2hpY2g/DQoNClllcy4gc3VtPT0wIG1lYW5zIHRoZSBkb21pZCBm
aWVsZCBpcyB0aGUgb25lIGFuZCBvbmx5IGRvbWFpbiB0bw0KcmVwb3J0IGZvciB0aGlzIHJlc2N0
cmwgbW9uaXRvciBmaWxlLiBzdW09PTEgbWVhbnMgdGhlIGRvbWlkIGZpZWxkIGlzDQp0aGUgZGlz
cGxheV9pZCAtIGFsbCBkb21haW5zIHdpdGggdGhpcyBkaXNwbGF5X2lkIG11c3QgYmUgc3VtbWVk
IHRvDQpwcm92aWRlIHRoZSByZXN1bHQgdG8gcHJlc2VudCB0byB0aGUgdXNlci4NCg0KSSd2ZSB0
cmllZCB0byBjYXB0dXJlIHRoYXQgaW4gdGhlIGtlcm5lbGRvYyBjb21tZW50IGZvciBzdHJ1Y3Qg
bW9uX2V2ZW50Lg0KSGVyZSdzIHdoYXQgSSdtIHBsYW5uaW5nIHRvIGluY2x1ZGUgaW4gdjE4IChP
dXRsb29rIHdpbGwgcHJvYmFibHkgbWFuZ2xlDQp0aGUgZm9ybWF0dGluZyAuLi4ganVzdCBpbWFn
aW5lIHRoYXQgdGhlIHRleHQgbGluZXMgdXAgbmVhdGx5KToNCg0KZGlmZiAtLWdpdCBhL2FyY2gv
eDg2L2tlcm5lbC9jcHUvcmVzY3RybC9pbnRlcm5hbC5oIGIvYXJjaC94ODYva2VybmVsL2NwdS9y
ZXNjdHJsL2ludGVybmFsLmgNCmluZGV4IDQ5NDQwZjE5NDI1My4uMzQxMTU1N2Q3NjFhIDEwMDY0
NA0KLS0tIGEvYXJjaC94ODYva2VybmVsL2NwdS9yZXNjdHJsL2ludGVybmFsLmgNCisrKyBiL2Fy
Y2gveDg2L2tlcm5lbC9jcHUvcmVzY3RybC9pbnRlcm5hbC5oDQpAQCAtMTMyLDE0ICsxMzIsMTkg
QEAgc3RydWN0IG1vbl9ldnQgew0KICAqICAgICAgICAgICAgICAgICAgICAgYXMga2VybmZzIHBy
aXZhdGUgZGF0YQ0KICAqIEByaWQ6ICAgICAgICAgICAgICAgUmVzb3VyY2UgaWQgYXNzb2NpYXRl
ZCB3aXRoIHRoZSBldmVudCBmaWxlDQogICogQGV2dGlkOiAgICAgICAgICAgICBFdmVudCBpZCBh
c3NvY2lhdGVkIHdpdGggdGhlIGV2ZW50IGZpbGUNCi0gKiBAZG9taWQ6ICAgICAgICAgICAgIFRo
ZSBkb21haW4gdG8gd2hpY2ggdGhlIGV2ZW50IGZpbGUgYmVsb25ncw0KKyAqIEBzdW06ICAgICAg
ICAgICAgICAgU2V0IHdoZW4gZXZlbnQgbXVzdCBiZSBzdW1tZWQgYWNyb3NzIG11bHRpcGxlDQor
ICogICAgICAgICAgICAgICAgICAgICBkb21haW5zLg0KKyAqIEBkb21pZDogICAgICAgICAgICAg
V2hlbiBAc3VtIGlzIHplcm8gdGhpcyBpcyB0aGUgZG9tYWluIHRvIHdoaWNoDQorICogICAgICAg
ICAgICAgICAgICAgICB0aGUgZXZlbnQgZmlsZSBiZWxvbmdzLiBXaGVuIHN1bSBpcyBvbmUgdGhp
cw0KKyAqICAgICAgICAgICAgICAgICAgICAgaXMgdGhlIGRpc3BsYXlfaWQgb2YgYWxsIGRvbWFp
bnMgdG8gYmUgc3VtbWVkDQogICogQHU6ICAgICAgICAgICAgICAgICBOYW1lIG9mIHRoZSBiaXQg
ZmllbGRzIHN0cnVjdA0KICAqLw0KIHVuaW9uIG1vbl9kYXRhX2JpdHMgew0KICAgICAgICB2b2lk
ICpwcml2Ow0KICAgICAgICBzdHJ1Y3Qgew0KICAgICAgICAgICAgICAgIHVuc2lnbmVkIGludCBy
aWQgICAgICAgICAgICAgICAgOiAxMDsNCi0gICAgICAgICAgICAgICBlbnVtIHJlc2N0cmxfZXZl
bnRfaWQgZXZ0aWQgICAgIDogODsNCisgICAgICAgICAgICAgICBlbnVtIHJlc2N0cmxfZXZlbnRf
aWQgZXZ0aWQgICAgIDogNzsNCisgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgc3VtICAgICAg
ICAgICAgICAgIDogMTsNCiAgICAgICAgICAgICAgICB1bnNpZ25lZCBpbnQgZG9taWQgICAgICAg
ICAgICAgIDogMTQ7DQogICAgICAgIH0gdTsNCiB9Ow0KDQotVG9ueQ0K
