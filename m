Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE08342067
	for <patches@lists.linux.dev>; Thu, 23 May 2024 19:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716491112; cv=fail; b=jtmp3CnsOSl/vcj5uSPTCQToIixMCEt9QciDusyw0n+56QC3QOwC887f4Hz1jCzYB7u3qACRF22v6pW79bXCPD6rlNsd40MRhO12l9vuO6+GyYIxi8fxR6Wzbrz/4rW2zYEHixXpVEXq7ZPuyEk4fvGFw+pdfSMR2EWvRFB4VbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716491112; c=relaxed/simple;
	bh=xRq3Vq7KwBTtcQwuvKX6nWX/nu+k1Q4leSdGdTeQyXk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CoMwjpFOgF9cC/jGyXslman6kKDRflxjVex5UcYo3zlVl57rFGyCw36+/rX/wwybC25ko+ygxk40RQsojBC1h8RUyHSi6FikfvBGETBoEUHm4ubwNNi0T9bDYikuGb/8ZGeZ63l3Is7lu1d46/ToBEiwxJYDrHn4Le95ThGSV8c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HnSZNvkT; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HnSZNvkT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716491111; x=1748027111;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xRq3Vq7KwBTtcQwuvKX6nWX/nu+k1Q4leSdGdTeQyXk=;
  b=HnSZNvkTpfEKMrzpA6K4BFZMasmQfMRQDNkAVRMy4bFAx0B0nBPB+PRQ
   Uev/5ug44X3C/snQu526HhwHd3WH9tvSlV+5+FLg0InHXaiiA0trcUWuD
   LE6jombg2eWc2sZyhk6WzcgARyFtnhpqXIsUAPvA29F17InwwI6801/Z4
   o8NtDLT9WuL6k/ptAbP+Ps1PU4EwTPCAqtQ547XHfy3vcG0tgqIgBhoR4
   G8CfN7FixXE7ANw0iecCSFphw2pWi3YjcoOhr0j7vBgtM/wN9O0sb250X
   ZKxE4B/MuETnZU10MCDkT2Nodw/2xjy/HXunf3PaN9/fPGfQIaVTrGG3Q
   w==;
X-CSE-ConnectionGUID: XnOUrOUOSuK7HCMTjBCqgw==
X-CSE-MsgGUID: EqVH78b1Tke8608rwd9QKw==
X-IronPort-AV: E=McAfee;i="6600,9927,11081"; a="23503323"
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="23503323"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2024 12:05:09 -0700
X-CSE-ConnectionGUID: UDc+YjrzTNqdg8tUp6vsNw==
X-CSE-MsgGUID: TctbP1WMQx6tleSvnXEjyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,183,1712646000"; 
   d="scan'208";a="38751301"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 May 2024 12:05:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 23 May 2024 12:05:03 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 23 May 2024 12:05:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 23 May 2024 12:04:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CdyymGcwXKOtU3KlIaTKSetXWDOQNLMKhRvHqrpX77W3fEba+COrb7naVO2x9tUK85ngn80yGw6pGS/pdPlNaQRFA+tUzJ/q8AcNUMEr7rvuUooC9n/icNABufD/olG3pPqWfyVAplOfWgeFcqPtUEFw6iWV+dH5VISk/icRVvizun0bGZ1Zthx2M/7ir0i4sEPZmwjM4JFxutSvG7ex2y/9AnRs5Bx7VohOCcS2xeYNry2my7IXN2CvwOmnoDRVQqY8S3mZlASZKmP9YZXtPChOB/jdyEaBM1SbU2Ku/KhFu6/U7rBRHDvWBhopXSTao8D5bfg0iEv7RIJIOaNoiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRq3Vq7KwBTtcQwuvKX6nWX/nu+k1Q4leSdGdTeQyXk=;
 b=nD8lbZ0PmIOrfQEXY6Va1yXkWDFXCw7ofP2gVEnogJFIpv91KGHF7osBFG2Jw+D/wYioX2zhWFmCF1leBCt69y/9iPLcK4pSfvQVyncGlo3TxocB4+Un5jKsUy7oxZEIevl0uhX8nseYgJqOfiEpBg7WadSkbQ8WFTU6htWWEN6+dwsaR0Ww9bmUbKmS2vWm5WGs9IHcNT3WaJroqSh8YWCEiB5p9sosirKyLigpG9Vrm2jKd1sGssojP4n8zv9uTk9IJ+PDASDI1ppdpyg/vgkYEPB2XRzMa6YCwJmszW4iGksFasbxgL+GEB9Y5e95nVNkeXVRJ+SdBOy6WNn3qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DM4PR11MB6239.namprd11.prod.outlook.com (2603:10b6:8:a7::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19; Thu, 23 May
 2024 19:04:53 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Thu, 23 May 2024
 19:04:53 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
Thread-Topic: [PATCH v18 06/17] x86/resctrl: Introduce snc_nodes_per_l3_cache
Thread-Index: AQHapxaLlE5h/oF4QUmt1DBuxjvwvLGjyhSAgAFrFfA=
Date: Thu, 23 May 2024 19:04:53 +0000
Message-ID: <SJ1PR11MB6083117715CD53FA4360C56CFCF42@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
 <20240515222326.74166-7-tony.luck@intel.com>
 <beee3369-0075-462e-8449-88fee807463e@intel.com>
In-Reply-To: <beee3369-0075-462e-8449-88fee807463e@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DM4PR11MB6239:EE_
x-ms-office365-filtering-correlation-id: 03cfddfa-4b9c-41e0-4bef-08dc7b5b3abe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009|921011;
x-microsoft-antispam-message-info: =?utf-8?B?SXd6a0tXaFdnVXdSZzczblZkYzZscUFJOUZKOUxXQXVVR1RDM0xBSjlyTnNF?=
 =?utf-8?B?NmNWSENaaFFnYWpIeGl4WE50MElsLzhLZENaQzFTQTdRWUd5R0pTZC9IVk5k?=
 =?utf-8?B?Q293R09iWUIvc1JhOHRpNDArZ1FBSzRVMzNWZ0lyaVRhTGxDcVBhMERjUTMw?=
 =?utf-8?B?ai9idnYxT2FwZStGeTB5ZFNSNFQxQ3ZiS0NBR2NIYjVya1MrM3RyQ2UxYm1Z?=
 =?utf-8?B?RXJMSlkzcW1DUHpaUTdtSlVnN0c5Q2ZZYmFkUUJQbE1FVitseXd2c0dNWmhn?=
 =?utf-8?B?ZEVnUGFEWEYvcFNvejJXWTdCa0sxNnlLeGZBWElBcDE1aW9Ha0JOS29UM29P?=
 =?utf-8?B?aXZxdHlNWmNkbHhLbStNR0U3YXhWUHZNRnB0MFlNY3JYd1M1eFR6MENWaTJl?=
 =?utf-8?B?eDRvOXZnZWVtU1hDUmErUFpkZnloWmRWdDZjKytkTEJLQTVqdFJqWkhLSEwr?=
 =?utf-8?B?NVZCZER5M0x4Q3pKN3RaZDBiZXpZRmNsTzZKa05TOGh3Yk54Mjd2TzRiSFlS?=
 =?utf-8?B?bWUzK05tRy9jV0xPRXFQZUFJUG95OGVLc25UWVJDd3ZldC90UmQ2SjgwMGV3?=
 =?utf-8?B?NktuV3QrK3NRQXBIdUlWV0FDZXRVOThjb3dKbTJ3K1U5alNrTjA1QmplV05D?=
 =?utf-8?B?Nml3MExPVXZMeXlkbXN6bnVpMU52TDdEYWYvL2dvNzNFb3hIYUc0R1BDL09D?=
 =?utf-8?B?TUs5UG91UnhOc1lNYVNaamJaSTNXb2IwN2VXOHpxRnRTdXVpUTczUEpWOGhi?=
 =?utf-8?B?cU5wTnh3TjEvN0pLWnRub1N5T2ZzMWF5WHNpY2xVR2NmVzNLdnlqZzJNaUUz?=
 =?utf-8?B?ZmROSlRzR0gxUUF3S0JtYXFoaE9nTUx3V1FIMXpaY1dPSFMzNEFxUlprUyt1?=
 =?utf-8?B?emlvbG83UXVwN2dTMG94UFdKeXZ5am5ka2dPa3NtcmRtanI2K3VOYnA2dWdX?=
 =?utf-8?B?OFp1ZTZJMG42Ny9FZ3dxMFdhU3dMR1FPaWgvRXlHUFB2OHVvZkc3eFlncThx?=
 =?utf-8?B?L0FoNXgzM3QwMk1OZHBNY1R4Wk5TMHY4UmJjd2tnQjJNN2dOaDF3YXNidWts?=
 =?utf-8?B?cGoySlV2Q01ENEI0SlhpWlorSFM3azAwMjhDRTBmcE9hNFpqZEMwQmNyZkdr?=
 =?utf-8?B?T0hCOWc0Tm1lZGhFcWpjajQxUlFrZC91OUYzblJ3emlDNVhXTzBSVXRFWnQ3?=
 =?utf-8?B?ZmdNS0FubTlzQ1NxWFcyajhwaUViMzk1MmdsWi9MQmUrRmhFZVkzUnFLcXRR?=
 =?utf-8?B?a1Y1cmdVU2NSQTlKalhmaENVbUpwK0dTcXljQ1hhdG1XL0pVOWVHdHQrSGFm?=
 =?utf-8?B?VzZHQVVNM1dYSW05aGZnN3NvdjF1TTRXRnhJVDlObE5rZTZIbWRLekdvellQ?=
 =?utf-8?B?V1dzYnZKWGZJTk9icTVzVkV0NVdGZmlNdWtaK2Z6TjNEOWhXdnlrMjNDaHN0?=
 =?utf-8?B?Mi9NZUF0cjFZUFo3VktKOGNHTTdlUXlZcjllVXYrNFgyYzhyV25TRDh2ZVhm?=
 =?utf-8?B?RWNBbjF1M2xvRVFFbWFXSUgyZGtTTTZpNVR5YS9LQUxjNURWclFUa3Q3WEZW?=
 =?utf-8?B?ZDBkSzNYQ1BVYzh5OURBT21QSWg0T0NpTmJ6SXBkVVVPdjdzNk1EeVZJdWV4?=
 =?utf-8?B?NHhGQ2FyL01NWndZQWUyUHM4QlJmWlN6bG92WUE5OUJ4a2xyY05sdTNVbjUz?=
 =?utf-8?B?RWp2LzVuTTFTVXlrcG9uSSs3MVRlem03QkE2VmlkTUtqS0ZFbVlYZWRsRXRP?=
 =?utf-8?B?bjBUVVNEUXE0ZWhoTzZCOTRLTGFBakJCTUQxQWVuNW9SYS91b0wvS1JZRHQ2?=
 =?utf-8?Q?bx7/mojc89RSEeRAfVtPU52bfKXzYxp6cpFMQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009)(921011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bDlTaEpSeWNKaWd6RS9kK0VwQlhRME50UE8vcjNvQzJnSDhKcElLaG5aWjB3?=
 =?utf-8?B?SUhXVmsrMXZwLzJUL09xc3UzM2VNQzVOc0NxQ211TGN4YTZ0YlNsamI3SnFT?=
 =?utf-8?B?RWRuaE43NXdMMUVKQ0ZianBlSHBFSkgrZDFTV2VIem9RQ1VndjhWempqMk5u?=
 =?utf-8?B?ZE0zSmk2dWxrQnVIZXA5QUdxRUR1akZNdXNydjI4ZGIwSE8wdjNvSlM5dWZY?=
 =?utf-8?B?N1BYUEJBTGFxWDVmanBFWG9LR1daK0lkUFcxUmhGN3plV2FrcmxKbGtwNW1o?=
 =?utf-8?B?Q0dZWnkvVjkzbUl4OFVMeER4eWxKQ1pCa3NBZWkyVjM0UVJNVUNFRHl5UTV2?=
 =?utf-8?B?TDQ5WW5qV29LUk1NU1QyVTEyMk1HSUY2LzNXSFpKWDhNVDhYZFZQbGhUTTJP?=
 =?utf-8?B?YzBuOGtNb1hPVk1kRWZSLzhTMzc3UU8wdHM2NGVSNGRvTFNUY2tlVWFOamZl?=
 =?utf-8?B?Y251cHRCejRNbWlUQUtBV3JKNGxGank2UUtLYi85N1FXem5HT0RnYkVVb2dE?=
 =?utf-8?B?bTd5cEpVQWRTdnFOWWNMZk9DT3Y2Zk9mTG44UXNVMjRpdHZBcVp6ZHlCdUNu?=
 =?utf-8?B?eTJhL2I1cWxKNjJjYkMwc2poUnFCTUYrZ0xuWC9waDVkUy91bUsxK2RNd1lR?=
 =?utf-8?B?TVRDUi8zdEZZTHFaOWgyZkRvNUE2ZzE3anhKYk1DSnkrNUJrSjlXdmRocEty?=
 =?utf-8?B?N3dLSy9odWN6cGJyQkpBUWtRanl0ODRkK0MxSzByMW1tRzY4QTZHbEFBS0xl?=
 =?utf-8?B?RzB0Z3ZIczJoRWNmQTZuMVFMZy9XZkpFbHN3NmJOUHRvWFhkNFZ2eUtZanRY?=
 =?utf-8?B?NXRhQVNsZmZyMm5vOXhhS3NmY2tRaVU1dGFDQW1ybGdnNzFnSit0cjh0UFRS?=
 =?utf-8?B?L2hrMnRoWVFuUEtaWVJxRnJxQllQY091RkVNcXJvK1A5VkRoUWlRenY5RUl0?=
 =?utf-8?B?dFZ2TnBSUFhhZW5zV3lrbnoxU1V0dzlyb0ErZlVZM1N4aWRJOU5DL3RzV1J1?=
 =?utf-8?B?ZkdGQVVTVk5CZkFabVZTakp3dmw1dmx2UFBNTE5BU1RVZTcrbjRqSVAxK1pp?=
 =?utf-8?B?UHI1Mm5ld3FvUWxEY1plTEttWmxTanU4VmwvQUpPSFBsMjVNa0lHcWt4bmY2?=
 =?utf-8?B?RmFSUkpTWXE1MGYvTUtUSmtwYU81bS9uWGFKMlVDckt3NHRNMCtpY1Q1ZE9T?=
 =?utf-8?B?M2d4eUxsVDZNcWduYkFIMld1dkJTSmhCelU4KzNXanRkMmhGUXlTT1Z1WnpX?=
 =?utf-8?B?b2IzVVdLMFI0NmREYjFHNnZyVXAzTWhOV3c1T1BQQkt5RlRoUWpIdW9KNGZB?=
 =?utf-8?B?bjFKeFJaVzRiZ05DUjRTeER5R3NqTDZ4RGw5blBHejZCQ1RoK1dHanN3VFlN?=
 =?utf-8?B?Z29rdk5QYnFZckFCbWJVWmVZNEZHWktJd3grRWRmbDZodjBDVlFkRy9PbjBy?=
 =?utf-8?B?OC9BQlBnSy9zdUNZeXRnQnZWK3Fma09SbTdaWHAvRVpRMjN3TXVvdllOTnJi?=
 =?utf-8?B?N2YxMVJUN3NYbnB4TUczVlVMTHF5dnVnZWxRY3plS3ZFMm80TVNRTTQ3S1JQ?=
 =?utf-8?B?MkIveDU1ZUlOeFppcjZkRHA4OVBBMVJXcTlTTjYzdUJDSVZmMTU2N2pXYVov?=
 =?utf-8?B?ZTd5YVpWTzEwb0FmbDBiVTlNR1ZaMWV0SzBoR3JGUnhiK3ZKZTNpekp4VjQ1?=
 =?utf-8?B?OUdnQ2JOTlVKTU5RN1ZkZldYZUluMWtwMTdxdVdEbWQ0MHZDMmxxNGZNcjhI?=
 =?utf-8?B?ZHFvYXJtRFpJS0U2d1Q1VFoxNVlETmhxWXVKVCtYSFVmU0xTc0QxUUovWC9l?=
 =?utf-8?B?bWF4MGZ2QldleThYUjQ1QjZCRnVWc2lrNGJGeGplVUtxYmRBVW8wR2lMTjVT?=
 =?utf-8?B?MFI3eG4zT2xoSVphNnRkV2o1TjFMcnllSFJhUmtBbjhZT1BQS3N2bCtvY2Ir?=
 =?utf-8?B?WCtPamxqcXcybVJFSGFZREpDVDZSSWJXS3lRSXFYSGY5alVJdVpWeXZVd3cz?=
 =?utf-8?B?MGNIdTdCaUpCT1NLSy9rNDY1Wkp2bGllaGRTYWF4WVl6NG02Mm9YY2JoVS85?=
 =?utf-8?B?SFRRODkrMEQ5d05Xamhpbkl0VytqWEtkck1Sb2dVdElYZHlKTWhYNk1Pcmg1?=
 =?utf-8?Q?9cZP/VxBrXtewMLzvjM+pxOky?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 03cfddfa-4b9c-41e0-4bef-08dc7b5b3abe
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2024 19:04:53.7092
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xUSRSsk4H6deHyyxrQcjYIfSnTC0mV2q10HoBSHmBB0A6NUaxTQ5Y+s55ct82jLkmeFCGkplv3Bq6nj0wnk1Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6239
X-OriginatorOrg: intel.com

PiA+ICAgICByZXR1cm4gKGlzX21ibV9sb2NhbF9lbmFibGVkKCkgJiYNCj4gPiAtICAgICAgICAg
ICByLT5hbGxvY19jYXBhYmxlICYmIGlzX21iYV9saW5lYXIoKSk7DQo+ID4gKyAgICAgICAgICAg
ci0+YWxsb2NfY2FwYWJsZSAmJiBpc19tYmFfbGluZWFyKCkgJiYNCj4gPiArICAgICAgICAgICBz
bmNfbm9kZXNfcGVyX2wzX2NhY2hlID09IDEpOw0KPiA+ICB9DQo+ID4NCj4gPiAgLyoNCj4NCj4g
U2luY2UgdGhlIHNvZnR3YXJlIGNvbnRyb2xsZXIgaXMgYSBmaWxlc3lzdGVtIGZlYXR1cmUgdGhl
IGFib3ZlDQo+IG5vdyByZXF1aXJlcyB0aGF0IHNuY19ub2Rlc19wZXJfbDNfY2FjaGUgYmVjb21l
cyBwYXJ0IG9mIHRoZSByZXNjdHJsDQo+IGZpbGVzeXN0ZW0gY29kZSBhbmQgZXZlcnkgYXJjaGl0
ZWN0dXJlIHdpbGwgbmVlZCB0byBzZXQgc25jX25vZGVzX3Blcl9sM19jYWNoZS4NCj4gRXZlcnkg
YXJjaGl0ZWN0dXJlIHdpbGwgdGh1cyBuZWVkIHRvIGludGVycHJldCB3aGF0ICJTTkMiIG1lYW5z
IGZvciB0aGVtDQo+IHVzaW5nIHRoZSB0ZXJtIGludHJvZHVjZWQgaGVyZS4gVGhhdCBtYXkgYmUg
b2sgLi4uIGJ1dCB0aGUgdGVybSAiU05DIg0KPiB3aWxsIHRoZW4gc3VyZWx5IG5vdCBpZGVudGlm
eSBhbiBJbnRlbCBmZWF0dXJlIGFuZCBJbnRlbCBuZWVkcyB0byBiZSBvaw0KPiB0aGF0IGFueSBh
cmNoaXRlY3R1cmUgY2FsbHMgdGhlaXIgInNpbWlsYXIgdG8gU05DIGJ1dCBub3QgcXVpdGUgaWRl
bnRpY2FsIg0KPiAiU05DIi4NCj4NCj4gSSBhc3N1bWUgbm93IHRoYXQgYXMgcGFydCBvZiB0aGUg
ZnMvYXJjaCBzcGxpdCB0aGVyZSBuZWVkcyB0byBiZQ0KPiBhIG5ldyBoZWxwZXIgdGhhdCBhbGxv
d3MgZGlmZmVyZW50IGFyY2hpdGVjdHVyZXMgdG8gc2V0IHRoaXMNCj4gZmlsZXN5c3RlbSB2YXJp
YWJsZT8NCg0KSSBjYW4gY2hhbmdlIHRoaXMgY2hlY2sgdG8gYmV0dGVyIHJlZmxlY3QgdGhlIHVu
ZGVybHlpbmcgcmVhc29uIHRvDQpkaXNhYmxlIHRoZSBzb2Z0d2FyZSBjb250cm9sbGVyLiBXaGlj
aCBpcyB0aGF0IHRoZSBNQk0gbW9uaXRvciBzY29wZQ0KZG9lcyBub3QgbWF0Y2ggdGhlIE1CQSBj
b250cm9sIHNjb3BlLiBUaGlzIHNlZW1zIGxpa2UgYW4gYXJjaGl0ZWN0dXJlDQpuZXV0cmFsIGV4
cHJlc3Npb24uDQoNClNvIGNvZGUgd291bGQgbG9vayBsaWtlIHRoaXM6DQoNCglzdHJ1Y3QgcmR0
X3Jlc291cmNlICpybWJtID0gJnJkdF9yZXNvdXJjZXNfYWxsW1JEVF9SRVNPVVJDRV9MM10ucl9y
ZXNjcmw7DQoJc3RydWN0IHJkdF9yZXNvdXJjZSAqcm1iYSA9ICZyZHRfcmVzb3VyY2VzX2FsbFtS
RFRfUkVTT1VSQ0VfTUJBXS5yX3Jlc2NybDsNCg0KCS4uLg0KDQoJIHJldHVybiAoaXNfbWJtX2xv
Y2FsX2VuYWJsZWQoKSAmJg0KICAgICAgICAgICAgICAgIHItPmFsbG9jX2NhcGFibGUgJiYgaXNf
bWJhX2xpbmVhcigpICYmDQogICAgICAgICAgICAgICAgcm1ibS0+bW9uX3Njb3BlID09IHJtYmEt
PmN0cmxfc2NvcGUpOw0KDQpJJ20gYWxzbyBjb250ZW1wbGF0aW5nIGRyb3BwaW5nIHNuY19ub2Rl
c19wZXJfbDNfY2FjaGUgZnJvbSBiZWluZyBhDQpnbG9iYWwgdmFyaWFibGUgYW5kIG1ha2luZyBp
dCBhIGZpZWxkIGluICJzdHJ1Y3QgcmR0X3Jlc291cmNlIiAob25seSBuZWVkZWQNCmZvciB0aGUg
UkRUX1JFU09VUkNFX0wzIHJlc291cmNlKS4gTi5CLiBCYWJ1IGhhZCBzdWdnZXN0ZWQgaXQNCnNo
b3VsZG4ndCBiZSBnbG9iYWwgbWFueSBwYXRjaCB2ZXJzaW9ucyBhZ28uDQoNClBlcmhhcHMgbmFt
ZSBpdCAuZG9tYWluc19wZXJfbDNfY2FjaGUgb3IgLnN1YmRvbWFpbnNfcGVyX2wzX2NhY2hlPw0K
DQpCYWQgaWRlYT8gR29vZCBpZGVhIChidXQgeW91IGhhdmUgYSBiZXR0ZXIgbmFtZSBmb3IgdGhl
IGZpZWxkKT8NCg0KLVRvbnkNCg0KDQo=
