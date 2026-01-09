Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8732ED846
	for <patches@lists.linux.dev>; Fri,  9 Jan 2026 22:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767997266; cv=fail; b=OI2ekSLU3b1wVFieQz5DMClfwVwSmJ0IGLNntfy550yr9rAfRP8kp8fSunfRYz93dzE/pgoAai0IwnUouuxN0S8rNLeNHZmC7OyYXSIY0GjyuL24Spry7T78UAqQqLuhZsTjPYkBBUlfoz4HWBXhXiG/u50m3UeMvMR6o6Iip1k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767997266; c=relaxed/simple;
	bh=p7utC9W9oACO+m4u2Xk2baBQ9EaC1wzihnSxrC1aFM4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YXZCzauGSKX+YL016m+Mh8wL2K+19826pUjWWP5mVMfptISE9fngyr4AZNXyAkWeoAXCl3Gjui8AKwnvqI4ymAgDKLTByEVeTpOI+DQcc9HgHvaey5379Ytatw99lRwZnzP/k18bph+0mqsDb9f2ZdvEDH+0HmZaGjlSXfyBXqk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k39brwI0; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k39brwI0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767997265; x=1799533265;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=p7utC9W9oACO+m4u2Xk2baBQ9EaC1wzihnSxrC1aFM4=;
  b=k39brwI0nwlp1rySd5BY59rXuWWLWRBcvr41Pvg3n/wHB9rDV/4zJkRZ
   wXplbSrgUn3pLd+eL6rNqjK/37kNPAmmUICOK9xmqsL88NaAnQIe85yha
   ou5TfgDwgUI4DBasMGSZAso0gMUwj52JkP7UUEcitGS19U7EpkG0XwQny
   fL67P6RHNgUZlG3W2oUb4lKLiIyqnfFuOIsZLV3STYvQ5jhPY59MtBi7b
   cpfB3p9w8f4vOfQmbfZbsHzRCNHo2VSNewZjjLmq36U7npTOsREWQ7aHr
   /CydrE9TekvTy/d1NBn81PfftWXpuvHdLWV5RFxvlhYrnQVA/MBwQ+bSc
   Q==;
X-CSE-ConnectionGUID: DJRlhwI+QiOrK9LLPIjqTw==
X-CSE-MsgGUID: t+LCmi5VTlKPLHCGeR/gBQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11666"; a="69539124"
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="69539124"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:21:05 -0800
X-CSE-ConnectionGUID: 18gO1vMkR8OiljG0nQNETA==
X-CSE-MsgGUID: YVxBK0YkT4u2FEmXagDPHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,215,1763452800"; 
   d="scan'208";a="234776243"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jan 2026 14:21:04 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 14:21:04 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 9 Jan 2026 14:21:04 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.48)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 9 Jan 2026 14:20:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FJ1AGmMWTrM+HY/ucDG+kFClOcO1DaNTj6ZyZMBMzBZaIoneZJmrfHzY/+XrCzn5D89ErNpZ8P6MjJAUFGNEaDKbOnyegRcvHvk7R8l2Y1lb31RnYGf+QnROvteRVjpy7YnVoO6i2izmN1rVZXGkgCnUQ1lDbJ5PLgO9TExAS4Yq9KQPgXSzE4WVIph3mlAJzebXj6TOjdoUZj1R5j8+5vT+O8LU0GhuuJiOtXIIwSnhmfDa9oPdf4vMvTAf6u5XxJJijinG3guSvGxEMxCb3EdRlCBmAf3msGe9XmdRBjtwYpT77IeyhzEMqKnGPOBXqqCZgdRCpr2mCvpqCAy/OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p7utC9W9oACO+m4u2Xk2baBQ9EaC1wzihnSxrC1aFM4=;
 b=uDBcc4ZWtKGp6v3HzYuN+hRdA12fONoL9SqGcsvNxXmpha6CWZAmKdwN+8wNxCR2k9QDAUGB1W4WkDZREHTBWSC9m0lWDYfRrfkU3ct+NMOFnbamUbqm4gG5qTqa3Zwi7vQ4u4cIcNg/AZz2o8HkrKzHiydT5RboyMzxB0c/zrZbDSJGN1CvQvSnAdZKFPf+engI1rHEsbJ8N8P9ZR2oLR3CT90ELvdTjApsQLYXvdgqmHWXY46icndlDhV0fzEFU5coU58ZJHxCoeTGg1JOR3WW0HFAzpps5Zumm2UbkbEsBhgBxyOMOe7J75kjRXI6tuvWlTkw+zXuwW63daW3lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7449.namprd11.prod.outlook.com (2603:10b6:510:27a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 22:20:56 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 22:20:56 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v17 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
Thread-Topic: [PATCH v17 24/32] x86/resctrl: Add energy/perf choices to rdt
 boot option
Thread-Index: AQHcb3mg3U9HxXHy5k62mhz8EmspGrVKjB+AgAABKwA=
Date: Fri, 9 Jan 2026 22:20:56 +0000
Message-ID: <SJ1PR11MB60831E566531790291D10B9BFC82A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-25-tony.luck@intel.com>
 <20260109221601.GIaWF-IRmxb7WgQOWj@fat_crate.local>
In-Reply-To: <20260109221601.GIaWF-IRmxb7WgQOWj@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7449:EE_
x-ms-office365-filtering-correlation-id: 8b2399a3-54d8-4d52-6b59-08de4fcd5c13
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RFp2VWhSV2M4MTJuK1hRR0pSNDJpNjNPZktIN2lNWjVVZzNaRUNjS242RW81?=
 =?utf-8?B?TUZNLzc4U2V2OVJ2dUhYY0RYMjNzNDZqUEQ1WngvL1hadnBpZTBNU2RXd1A4?=
 =?utf-8?B?WGlMS1NSaEV6WWt1UmRJWFoxRGYzOURObDFjRHJjR0lxSDFIMXU2SnV0TUI1?=
 =?utf-8?B?bktxckZIODlnMTdvVFZwZzJmRW83N1d1UFl3Y0xBSXhPSXprVUkvMElJL3NX?=
 =?utf-8?B?eFJ4bWIrNDRqMDVPUDZFRnNFTDF2SlNmd2xXYnhQRDBFQlA3RHpyenRYRDc2?=
 =?utf-8?B?YnhqTlFiNzJyMFR5R3gxWXl5NWlsQ1hZZHVzM0FEMU9oU290Tno5ak9KbTYv?=
 =?utf-8?B?UUNSK1hwUnpqNmlxZnpYSWVwbjVBVU51NGFkM1hIV0VuL1Rsc1piNWVIN3ZY?=
 =?utf-8?B?ZXgvbzZlSHBya0RWWE8wWndVS3BadmhINWpkNlYweGtodG14OGtPcldnK3Fs?=
 =?utf-8?B?VENyOGNKYmhRV0kzVTRiVlBqU0E0MXNiZ2JJZ20zWkN4QlN5RUVUZjBQUGg4?=
 =?utf-8?B?TUllQWJjdDB6d00yVTN3Ni8weXlQOXJzTjF0RFFKaG5tM3pBS005ME5aMWhz?=
 =?utf-8?B?eXZZRDBFaHNVSFhqbkVKcXhEZVljTnpFeTZVNldpUTl6dngxWWFMblF4Z3dN?=
 =?utf-8?B?dEZtazg4cUw5dHhuUjFlUFh6TFlxaE1KUTM4OGRzNlhXNkYzcU5YUzRuTmhB?=
 =?utf-8?B?NGM3TyszRS9GeFVjQmFkWWdkMGxLVXVCMjlVQ0xvWXlDeG1Fb3ZzbUZMYTFT?=
 =?utf-8?B?THd3T2NsRG8xMTBraWFCZmlJdXczbXM4YTlRbDB5c0htdlZ5WlEya25lUjZM?=
 =?utf-8?B?c3NTMGxML0hjRTZyTjN3UkVQZCtoSjJwMmhQcElZVnFyWUJKMTR5WU1GZXl4?=
 =?utf-8?B?aU1DMkM4dzZKZEorU1Jick84WnJwZG9rZG5oYktLVmk0ck9QQld5eGtGQWwy?=
 =?utf-8?B?RmJkaTRIbWkrSGZvUUVqK2M2R2NUVTZIYlo4Z0VQdlFnc2ZCK3NSSldzWmhU?=
 =?utf-8?B?WVRPY0Z3ek4wNGo2QVRQQTJ1OEk4bHV4SVNkVjhuZUM3NUthbSt1L1JqYXB2?=
 =?utf-8?B?dGVMNE5qTEMxdzY0ZXpFRGhTWFYreEZzMjJaUm5MMTZNQklLQTRVT3F2RjJY?=
 =?utf-8?B?ck1ZS3U2QzQ1d2w4TDM5WnlZRitGNy9kWnpUSHBrbnFjWXFLUFluc1l0aXJU?=
 =?utf-8?B?NVZSd2g3Z0doOUR2UEpCNXFJWFRFMVF1clFucUhFVlBGWW84UXZDZXVGUTNJ?=
 =?utf-8?B?Q1g3dWd4M1NLbTZZc2JpMHhlb2tHSFpqb1oyKzcyZXJhVjNITWFRUFRzOVJO?=
 =?utf-8?B?WVVMaXhMTElSZmZiOHdlbjEvQWFBcWNaU2JsWUlFaGNhRnhqcU40ZHNLbmtE?=
 =?utf-8?B?QnhkZ3d4bk1VOTEvY3dqUi96WHVVeWV0ZUQ5Y3M4T0Rnc0FhaGVWM0dMTFhv?=
 =?utf-8?B?VkFxRHlxM2pKL1A1RThEYWxqWURCbnEvMnQvck9DS3pyMlE3cnFadS9GMGRt?=
 =?utf-8?B?TjhtRnVrb1M4WkliL1Z6aER6aTk0bFAzNURjK2R6R09xaWxqVDhEaitoZnZZ?=
 =?utf-8?B?cWIxR0pZU3dRN3E5eXZ1akk0Zk1QZk1mWE9DQldGdXFRMWVIQmtXaWVEdVNM?=
 =?utf-8?B?ckQ3OGxpNE5tcTBXL0NuSXlTdW9WZDh2MkVVN0dmOTI5TXdROTRiQ29idXZN?=
 =?utf-8?B?NHkwcVBUT0lOMUpuNkhKdG5PMkt3aGJuMlMyaVBFS0VSSEFzV3U5RDlsbmkr?=
 =?utf-8?B?ZUM1RU5VUTB3ZWRIYUgybjRwWTVxMEVvMlNPdHlDU1NpUDVuR25oYnVRSUZK?=
 =?utf-8?B?cUQrTy9FU2pmQjZYRmtlcC9kZzNnQWpaek9xN01SY1dhbEMwRCtKTXdOaFgy?=
 =?utf-8?B?ZVJ4T3RFandsVUh1S1B4bzRTZzJyNkdHZ1o1VGt1OUZiOGc0WThEREpsZy9a?=
 =?utf-8?B?UDYwVUdSRi8vZnFCN0YzK0tiaHM2WGxMczB0cTFWV2o4MVBiTmRLTmFGSHlv?=
 =?utf-8?B?bzF0Y2xaUnNPMi8zNVgyZ1ZES04xNzc4bjBVdElRRDRtVWFSSlNyRWFFRXVn?=
 =?utf-8?Q?ow9zXY?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZnhhQXVleEVGQkwxTFZJNzdUME1wcFI5TU4yeFQyd1BJMC9CSzFHRG9Cb2g3?=
 =?utf-8?B?b3d5ekE4bDk0aW5XWm9TekJFdmduVnVLZEVrQUpVUXVMS3B4WHJZL2V3SEk2?=
 =?utf-8?B?UkJaRjl3cVJyejhQVys3TjV3SGxWNUZKd21OTVRSTW1lcGhXV2FTYXI1STl4?=
 =?utf-8?B?QitNRkwyZ3dZOU1vN3FqOUo1VWR6Vi9Xc2VBQzd2cVpjN1VmOWorcmFhbVJU?=
 =?utf-8?B?bDE0Sm9GRkhRWlltNmMrRTJZS05ZUzMrbWZyaE9KRzBHM0lzTGtrcktDbUNJ?=
 =?utf-8?B?K2lqYXZRbDhSUE9FUkphd1kwdnNSYzZMaWovd25YUmtEZXdTK3dVYzBsbWtB?=
 =?utf-8?B?TFhKN2JhUG9vUGYrL3hEQ0l1SGFlNE1jeUVJM2tPaXEwd0hvbXdjVXkvWXo3?=
 =?utf-8?B?UVVLeElyaW9ockJweFJYNnN5ZTV3Z1hWQXI2dytmdDRaY0JmOWk1RTNOZCtE?=
 =?utf-8?B?OHNqVEZ5NjVOdFRCVm8xSUtrNUt5VTArYXpZOHlINEFBTUlZUmhNWHFhMVdF?=
 =?utf-8?B?VU4yYk9wdFV1SzlYcDU3TTRYT2pwQzNGK0JFQXV1RWdmYXk4NGhoSkI3Ulhm?=
 =?utf-8?B?MUNBT25iaXh3c2NYaCs0QzVlZXFacTBKNXY5Vk1pdm5GNDhSek5FS01GcUQw?=
 =?utf-8?B?ZVlQL2RFajd2d0duUjk1NGg1RjNuUHgvUlJURTliK1p1bnFkT3JFWVcwQXBx?=
 =?utf-8?B?TTVPQWgwdWZPajVmVHBaMnYyd1QyWW1GVXQ2Z1BZTkR4VW93VkxlUlFTU0JP?=
 =?utf-8?B?NVRjMDhFaWRrTmtqZmZicHRVZnhqRmRXNU1hL2VSbHFYVzRra21wRVNTQWty?=
 =?utf-8?B?bG5mZUV2ZGtWQ1kvQzByN2tpM3MzLys3cUZFZ3VoZGVXOHdyZksvV1ZKWDNJ?=
 =?utf-8?B?b3NITGRBUlRtZldvSGM0YkpTZWVoSmx0OHhqZEEyOVhENjkyZXVwUysyTlpi?=
 =?utf-8?B?Z2YrNjNJZGU1RHRWZ1ZnUzYxbG1uSlhMNGdVRElzQW5valF5S0luYzBtTlhw?=
 =?utf-8?B?THZRbGo4Y3RnSE1Wc3dlNktTa1h5dmZWQWttaEZDMnJ6WXpQcVJVZStqSVp2?=
 =?utf-8?B?ZEdaMnVSMHBMMjNIcjlvZy83ZVZ0S09QNENOK0JuWi9MRlM2eXVjZ1VGTUoz?=
 =?utf-8?B?MXFDQUU0ZXpsdDlRSDVZTldDL3FzSGVncVhkd2FTN0tBZ1FKbEVFd0V1K0RH?=
 =?utf-8?B?RE1pdm5RUnJzNEFKWDEyNk4wdHF0elF3TlRGNWZKY2MzWGQ3SGNEVGVxNjFi?=
 =?utf-8?B?MzEzU2hmdVM2RlZaMTNRMUh3cEpIK25TS1A4ZFE3QWtHTVFCNjEzUVp4Tklv?=
 =?utf-8?B?SkFST1F6aEh2WFhsRlVBU3lnd2ttbVdFRmtyRUhnMW42c1g1ZC9QZWhpVVN0?=
 =?utf-8?B?RkdXaXd2VTU1ei9UQWVPTVVHOWpxbjROUVhwdHdTSWZSRy8rNDd4MlF3NE8x?=
 =?utf-8?B?VHhaS2dMQW1HakN0aXVyL0JDVXFWaGl2REl4cGFUYTRTYy9jcVNzTkI5MzVw?=
 =?utf-8?B?RzhKT2FDL0U5YzdQMEF2Z0lMYWc5NElRZlg5QWFMTlp6NzhFdkh4VjBLUTdn?=
 =?utf-8?B?cE56QzI4UFlFU1VhOGdQNW9nQjdzcUxBeCtsVS9BVWxvRGxqLzFSY2pxNldl?=
 =?utf-8?B?YzhwZ25LOWNvbVZOSFJiYzdLb3M5SEJKZi9kaTZ2NFdoMG92eWlEck5MeEVT?=
 =?utf-8?B?aWR5dGJpTWV1dGZHeG9MR0gzTnlZMnN5NEc1WmUrZHhjZDlKWjErSTN3eDAy?=
 =?utf-8?B?TWRlbFcvRllHcXA0c3dKemxkOUxjU2VZenVFbTdJTkRDak1wd0Q4VW9CUnBo?=
 =?utf-8?B?WVZqaGQ4b1l0VTdnd0FsdTZOajAwTFFTUnRDWUlUcmJ2Vnd6L3RsSkVrSC9l?=
 =?utf-8?B?cjBRdmJiQjA3b25leE4vOVhlcmwzWTJGY1VTN081WkxIZUZsZGUzQWZBejVI?=
 =?utf-8?B?L1I3aGJ1YVBSY3F5dkhnSURyaE5vb3FZQVdQdEdEbC9JOWhjKytjcHM0aDBj?=
 =?utf-8?B?NXc3RVEzdUlBZUJBRy80WDlCSnZvK01ZRkx3R2tpejBTeStzSTNCYlBrTCts?=
 =?utf-8?B?d2I4bWdUb1J5RmR1YWlYRmZuVWpzbVBZaTZOck94OHpEVWhIYzVjeVBlL2dh?=
 =?utf-8?B?QzVzSVVJSXVzdEkyUkVWa1pRZEFoVzNvdEZYalA3VTVQeURhOExMSW5jVnA1?=
 =?utf-8?B?R1RiMVBPa2t3cnFHblFYT0RnVmxZVkFnc0lXMS8vVDh6ZVJHc05yam4zY3JP?=
 =?utf-8?B?WkJZUVFKMFdKMlVNNEs5RWFkVzU2S2FwMyt5K0wzQXQ1WmhzQThuMW1WaWZw?=
 =?utf-8?Q?Nuhm/h+gEufsCeOQOT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b2399a3-54d8-4d52-6b59-08de4fcd5c13
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jan 2026 22:20:56.3932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 40FZ40ExkDN0yrtqigv1BBRVIhI1uD1RNEJkfDySQayTIoc7Jptd2ic8efZf07RaRWQUQb4JDxqDSHm9V+yT2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7449
X-OriginatorOrg: intel.com

PiBJT1csIHlvdSBuZWVkIGEgdmVyYiBpbiBpdHMgbmFtZSBzbyB0aGF0IGl0IGlzIGNsZWFyIHdo
YXQgaGFwcGVuczoNCj4NCj4JaWYgKGludGVsX2hhbmRsZV9hZXRfb3B0aW9uKCkpDQo+CQlibGE7
DQoNCll1cC4gVGhhdCByZWFkcyBiZXR0ZXIuDQoNCi1Ub255DQo=
