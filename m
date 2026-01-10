Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE205280A29
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 23:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768087780; cv=fail; b=SDit0RWtqhcn5InYsPIY/jX6yd6V9EbPXv1qaqvIlGMmwL05T4NhaAkBRFn1fnepGJuCNRry5i4Ns+sUL9mcS1Yu/bDnjf0yXvqlQpg4oJP0KxXWtEYoOUWBzaAXFNNr2qmnR7vh+sFlQ2gqANS/Oo+ITb6mSEUP3mKCqSaJOBE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768087780; c=relaxed/simple;
	bh=JyuC8n6XR7NU7eLM3mQvH3NKeiouBvOJoxqnQodBG1A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bHu71gwBDuGVQ7zeZyLeftM36VVNcTI542Ha2vqKgmDUawiPciG+3Uy28snI6gP1A0ZpGwGpbAwj3XXuDRvjkJvVpJBo9aWgS697DUS37XCo1LwPbrpUGZ/ph2k7tDkYLlUhw2YLmiw9BOnAUYgbPvUb0StNbBN1CIYxivzmJJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxVbAdPO; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxVbAdPO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768087779; x=1799623779;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=JyuC8n6XR7NU7eLM3mQvH3NKeiouBvOJoxqnQodBG1A=;
  b=OxVbAdPOV1iotOuJXb7hwsEiuZ4MDe7Y6Fg80m8vH0DozGJUgH3rLysL
   j9g0oU1QWvxd3pEqO7Y/ZqAl+Bqi9HrXQlnwCqrt1YdV4T3bGvnNfzQfP
   U7M+34lDUhoiP91/Fv50STvF8c84gnI9Kb0Xsxm3H6GBCuFR8U4N2IP3q
   BZ4MX+b68EdPv+L6+H+0eYff2+LINicGJrRTyn5KjGJvp4CSlZuB14vkd
   lpFRDMEabtp+E/UOOVsSGWVjQx/z4bM8UPFYNE447zi53ENdXBBpdMKIN
   MmzgXctGAoJ/GTuLtgOHXs882V3HYvLJKxGXRcSNMVEfeaPlHSU7r18Ts
   g==;
X-CSE-ConnectionGUID: /3KcvpOEQLmrZcdy05ipdQ==
X-CSE-MsgGUID: E+++VSrkQcak/cnCxnlJDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11667"; a="69348443"
X-IronPort-AV: E=Sophos;i="6.21,217,1763452800"; 
   d="scan'208";a="69348443"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2026 15:29:38 -0800
X-CSE-ConnectionGUID: PPWT3G4CT/y3tE4L+1y3tQ==
X-CSE-MsgGUID: QznDd2wYRM+f44O8Mhe6pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,217,1763452800"; 
   d="scan'208";a="208248826"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2026 15:29:38 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 10 Jan 2026 15:29:37 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sat, 10 Jan 2026 15:29:37 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.2) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sat, 10 Jan 2026 15:29:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fldN910eePIHGfPzB5FfkBD8itKe4z20JGT3NzSGLscau6AZdNmNttQsVkS0ftJ84ykx2FcSC6QC8lUqqBigu/DbAd/BOmvEZpV3o/cHgqeXtDPtwcvUlM2OgEZ15Y/BH73m2gIPnp5x+i8l0b7UmIj3WGJCWUvjlTdelDFHd4qfDp5yz2EgWAUF3x4Muim1tUbO5QUDX0RP4WymTZ5B/uiTcqfVcPp8vqp9hN+btqcWJnMY2uJOKEfZt/ovGJwvZR/5IPJkEApVkkRv/ZmJMbYoTw3q7l0o7T6k6HilpauxuOhoOJ+UPjfiEdXYC5F+UAg4QcvSxneQh721EwCkLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JyuC8n6XR7NU7eLM3mQvH3NKeiouBvOJoxqnQodBG1A=;
 b=EyUKvQZ8N42ON5tDIA/R2M/MpEf9r4MxUmaF7R3si7if3Ea3Msx2FhYFmvZDXuq6dHp0DIsJyPRJXadRSV5x4f3Nvw2rgHT7fK+gjzLZcjtyo8DpmQbCeexQ1JF5VZW0n8EH2HIox4v9qOiR2b7JZs9oXM9DsB2ltcSWlU1uXbxemdWslssoMkpS9pzcuOkFHyG/bHBk2eUAcLOiW8TO/2z5KHJwJAkjood7cWcnvNqX/po+ok0MXnWbl+GPcBbKM2iYo+G9Nbg3GxyjhFcZmk5yeeUD/RqkD5y1U/VH9C6LgECVWWjYZ6+P8bz9gvhZQBD0sh+wG+C5aWMQDuQRPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS4PPFD667CEBB6.namprd11.prod.outlook.com (2603:10b6:f:fc02::53) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.3; Sat, 10 Jan
 2026 23:29:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9499.005; Sat, 10 Jan 2026
 23:29:35 +0000
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
Subject: RE: [PATCH v17 30/32] fs/resctrl: Provide interface to create
 architecture specific debugfs area
Thread-Topic: [PATCH v17 30/32] fs/resctrl: Provide interface to create
 architecture specific debugfs area
Thread-Index: AQHcb3mfiyEkmBgxyUuv7JpyYSar37VLYQIAgACKfwCAAAgCgIAAP0kQ
Date: Sat, 10 Jan 2026 23:29:35 +0000
Message-ID: <SJ1PR11MB60831EA12EC917C5740D8370FC83A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-31-tony.luck@intel.com>
 <20260110105758.GAaWIwtlX9o_oVXIM_@fat_crate.local>
 <aWKk5BYP8BJjYhs6@agluck-desk3>
 <20260110194219.GCaWKrmyJCU_y3vfDD@fat_crate.local>
In-Reply-To: <20260110194219.GCaWKrmyJCU_y3vfDD@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS4PPFD667CEBB6:EE_
x-ms-office365-filtering-correlation-id: a3b452cc-3af5-40c0-5ff2-08de50a01dae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bUNPbndRS2JTcmk3YTlZTnI0bWRoclB3azM3RXdPc05IVlpXaHJlbnNzN20v?=
 =?utf-8?B?MHVxOUM3ZUFvVFlPN2tiQ1BSelBWMXp0UFZDaGJwZWFYZVJHRGRvNjNqVnJr?=
 =?utf-8?B?TkUwUCt5Z04zZnZCOEdFN3pVMEc3TU9FT3RNek1NcUNjUzRpNGN5RzNjaTEx?=
 =?utf-8?B?VmgwTFo3MUJUZGUvRkN1empjQXZER0Vua0phUUE1Zk1OemN5WWtMRWE4bkwx?=
 =?utf-8?B?TmI0RTlpTUlTeVRYR1NacS9WcEFiTVVNa3VMZVRtcjZXK0p4YUpOdUJSUnA2?=
 =?utf-8?B?UzBkYWh1K21scUtjWVBYdXJsMllQR29sWlFlYUlXTitFbkdUQ25KK3RzUmxX?=
 =?utf-8?B?cVhrVTl3ZnVUZE9td2Rob2Q3RjlWNmxmUFpwT2pwMTFmZDErT3VsMDF3cXNk?=
 =?utf-8?B?L2dsYnN6TmMyUE5mY3owR2RHVGdkQzRyUWRWN3Z1WVB4TlVCWlhaMC9KVkVM?=
 =?utf-8?B?VWROUWt1eTFtRDBMZFB1eGhJOHRqUXZ2SkgrMmxwencrdHlqQzlUeExROG9p?=
 =?utf-8?B?b1JRM3RaZ1ZINnV3N3NHdmtOaHI5bFE2Nm0rUFZkQXdpWVAzQVBPajFDdXB6?=
 =?utf-8?B?Q1hmNWFIc2dsWGIvY3RERitCM3VEL21DdlgyOWd0dldpSlpTanFmM1hiUFhF?=
 =?utf-8?B?bmVXTXZHcDhKcFRhanJCRkJybVVpRUZaNktNek1KekhndU5RVEtNblFyU3JP?=
 =?utf-8?B?ZWRieE1rZlF0Q0hMKzhEcERuSk9JQ0dpTUc4VDArN3BFUHByMG00T2Q0WHNK?=
 =?utf-8?B?ZlhsdlgwVDB1azRBSzNCYzl5aHFGczNJMHNKR1NjZUZ1ajJKOEE0RDdMVGk5?=
 =?utf-8?B?UmVCcGlLUVQ3ZHJBZU9sNncrRnlnNkh4QnVGbnlUTDJYeHBUM0NSM3BOR1hs?=
 =?utf-8?B?R1RkMU5TUHJLcUorZzk2SkVpc0I0WEFhdXdzZHZPME41OU9Qdy81eXErWUN5?=
 =?utf-8?B?R01keEk4eVcyOVhJSkJreVQxNUlqMlFBMi9kMUl4RWtuQVZGQUpReVN4S09l?=
 =?utf-8?B?R3dtUTlLazRCUStSbE5ScW94NUU1RzVRYy9qZDd5VUdZRHA4djdqUDF1a1l3?=
 =?utf-8?B?bVlVZ1JzTFdDeTMwZ0lSdWRpd3BScTR5VENRaHcwRmUyaE9LREFyU2sycGlI?=
 =?utf-8?B?L2dMTEVBS2xhUlFVanhXYXRJZTc1aFRlK0lLUWNQMzQ3SlpXWHFwUEFXSUlt?=
 =?utf-8?B?V2RCYTBJSXBuaHgvRGZlYXAvNWFKRlZVMFBLcTE3Z0VSSk5VU1BlQkFhbEdx?=
 =?utf-8?B?VEtaRElORkVKNmxvL0lheDJBL2gzelB2azY1U3JoQVIvaFgwbVh2SjBvM1RX?=
 =?utf-8?B?YkN2c1Vjc0VjajVFYndZVUpwNnMvNlFqQUtjU2hWRkdVOC9TK3luTzNCVGR2?=
 =?utf-8?B?bnZGbXE0WkE5WE1RMHNCNE1tQnYwWHg1cTBCTjQwTjVwWFFXRG1ZVU1KZVFM?=
 =?utf-8?B?ZXE0ajZSdVhrcHY1N3ZobWNDajNKeDZDSDNCY1o5WS9lWlJVM2thUVhocmta?=
 =?utf-8?B?SVNacEM4eUlQcWtEbzZoZjdtZURvV1FTRVg1VFg2MFIyUkxoZkxvK3hjbDVS?=
 =?utf-8?B?R0JYVm14TnoxNE1QZFlkc3dWSFRXQU92cVk1TnNtdkhCblFiS011WFU1VVQw?=
 =?utf-8?B?MlFDOU1xUldBYnBTc0ZSVit3TnkwR242Nm41aVdHU21HUW1pZDFRZTJzUTNO?=
 =?utf-8?B?QktZbks0ekJIeXN5NlRIZXcyd01TRmI2TlYwWkRjUnZvQXhSTVJlZGxaZ295?=
 =?utf-8?B?TEtzVEN5WHl3T0EwL1BpaFYrNHRHVkwxei9tTEFmQVA5WUMxeGVJdWxmeFpK?=
 =?utf-8?B?RU5PT3Z6emJ5UTFFL250NmcwejZSejF2angrS09ZQ0xUNkE2ZEZka0lxUVV0?=
 =?utf-8?B?dHlXTmlBVytwKzc5NTFLUTFzK1o3U3daTUlSMzF4NTZSdlFmMDhhL0pzbXA5?=
 =?utf-8?B?K0xWTGJWNFhYd3h6ajI0WWV4akthL2RXQkNrb3hRbzZKVklTTHRaK0NJUTlO?=
 =?utf-8?B?VW5GU2pGNEFlVkNINEhDWGpaRGlXOWxDUjZGc3Z4ZVVoWEVLQmpWWGh4S2c0?=
 =?utf-8?Q?A71dQq?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0FpRnhyODhGN2RBVXNOTytFU2pBWnJkM1ErNzFKTTIvRUwzM0QybWtDdDht?=
 =?utf-8?B?M0cza3RHdVVkbkJ5d0Z0a0l5ZkVjY0ZqZkF4a2ZKcVBNcUowdVlWMEplcDA4?=
 =?utf-8?B?UklOYzh1U1h1empwTytJYTVaaXBxWFJUT3F5WHFIaHFVM3l4UDJ5MkZvMTRQ?=
 =?utf-8?B?U3RBbERGSWZudTRTUzc0M2pDZVFtbm1yajJtTmtqU2FqRTFEVFQwbDFFc0ZW?=
 =?utf-8?B?OHBpVWs4ZHZrOXZiVjhlUEx1cHplZGk0RysxdVRiMHM2MjMyL1JkeFFJQTYv?=
 =?utf-8?B?NHlEUFhQMy9rY2ZSWUlHMjQrd0J3NllRYVRWSURwMWhDaVV2YmpWZ28zQzRN?=
 =?utf-8?B?c3NBeGxIV1VXeVJnYnhQR3RCUVViVlRJOC9mRTV4b1l5eENXdFVDNEJaWWJ3?=
 =?utf-8?B?RmdMNmlUT0pjWTFSd0FGOTEycEUvUldXTk40c1VpZDV1UlFGVC8xckxQMUEx?=
 =?utf-8?B?U1Y3SnpUOEhZSGJ3TmFaU2ZMd0x4dW9oR2lnallvUlA0ekhNV1V3Si9wMTFS?=
 =?utf-8?B?a21zMkRBMW00dll0L0xBNFZJbGZYMXVzQ0N3R0J1L2U2RnBGRUtZdStiQmFR?=
 =?utf-8?B?TmhnMkVVQU5HMFFpUDZhRFBzQ21DcE4xU0liUjFTeWdhYkVSV0ZUSG54MXJv?=
 =?utf-8?B?RUtnbytUVEtEVmV6dFRqNUgyemFmQjhuSmdqd1Rmb2I3cmRaRFJBZzk1SDFY?=
 =?utf-8?B?K3JsVXhTQURwaWNLV3haaWpOai96dGJ6aklJM3VBenRzYnVaZUdOUmIvQkFF?=
 =?utf-8?B?RDV5TUM1bFhXNU5KZ1lOK2lNS05hTnVvSVVZNHppN2tRQmtkQktnLzlvd3h2?=
 =?utf-8?B?dGVqMjVyekRXaExIaWF0ZTFxNkU0a2dWaE1BVXhrNFNkUXlIVWJGMGM3dWFo?=
 =?utf-8?B?R3lmbGdKMmtjanNmdHdwNFA4VUF5Y0NsZzNFc2tWbXhFZU5tTEhxR2xWNU42?=
 =?utf-8?B?ZkJ2cy9XUkJBd3VsaEpzWUxyQjY0QkZ2bFNHbTlDSmRDeitpeXVjVzJSMFhj?=
 =?utf-8?B?Z3lzanFsd21zNGc2aFg3VzVvWHRsZG5VcTU2d3Q3VFhtMUpnMUg5a2NpTTNt?=
 =?utf-8?B?OG9mRzUzU1pXR2dSVktEMDc3eG8xV2E2U25VN1lMMkFWeTdKTmdOTk1ZK3B6?=
 =?utf-8?B?M0puRXlxOVVuNnd0SFRKRjdOemZBbE9OQ2lGRCtVaGlPVUNpQ0dubVd4SkJ1?=
 =?utf-8?B?MzFSYXRJN1ZZdjRsdGl1a3lpc1Y2NWJNdktWa0M0Q1BNYkJCdVVaSzZ3NENK?=
 =?utf-8?B?OHRLUGRuNHZ3MFROSkdJVC9qNjVCYkpuQnNQUGhldDdKTXlLRmRIeVgzMHRW?=
 =?utf-8?B?bW1VMG5KajNud1lRZHdkYldrQUdob3NDWWlhaGZtTVQxUVp0Mk4xOHlCQm9a?=
 =?utf-8?B?VzBDellZVDRxS3d1TUlSK1doRkhHbjEwUGFXcFpqbGZzZS9hZlYwa0libzU0?=
 =?utf-8?B?c1lLaTRqNnlaT3lxYU5vNkI5RUx0UERKZjdyZ3lDQ21nUjIwZnROMDNGazZT?=
 =?utf-8?B?S0FWT2VrZzFGMVZoRExsNDV5ZkY3ejhlR2tRWGNZdXI4YndxNmZyWE1FN0dR?=
 =?utf-8?B?MWF6RkxmRWFRSUdVa0RTNGcyNGZMNFNUa1ZCWUF4MFpKNHlLWkJjTnBDUGRi?=
 =?utf-8?B?MkdiWU51anRmZm1laWxzVVBWbDY1TFdVZk53RTdvY3RJbzc5d1BaOHdRWGlm?=
 =?utf-8?B?ZnFpelIwNSswWEdDbXpwbk1tUEV1RGRNUU0va3dldW9TaXVwK1VNMThGUVEr?=
 =?utf-8?B?YTIwOVRkZjRGZjNmZDVFaHNiTjZ0VUNmS0N3aTUzMng4N1o1aW1tbVpobkJN?=
 =?utf-8?B?OHE3QzltYVBnR2hyVUhkT1RYMHovM1J1RTZxU0U0RkMwVE0zU2w1T2JMWmZM?=
 =?utf-8?B?dGRXeVppV0pPYk41NmNadGtqbUdiNWx4OU5VZ1VqcDBZekZ2eDBJSlMzNXhR?=
 =?utf-8?B?VFZxQ0pjN2NNUE5DaGxCTmtZRUlaVTk2ZnJ4dzZYbWo5UFdEMkFnYi93ZVdD?=
 =?utf-8?B?MzRVY2FOZmNHSC9TTmN6dytZa0o2T3Z2dEJtcFZsL0RGVXpHWXdDd20yODBH?=
 =?utf-8?B?Yjd1WmdCNjRMUmNGL1ZJVkFJS1FFSE0weW03RHR3dWcrR1lmejJ3YlY4L0tq?=
 =?utf-8?B?RjVHZkI3Wm9vQlBGaXdodEVEVHZya25JaVpTUXlwWjlDTTRQYzZuVDBYVkdI?=
 =?utf-8?B?UkpWeWpFSFByN0Q2T1RFNmNnWlBPNW1SaUpuQ25sQ1oyTTJpVW5kc0FvS2Vu?=
 =?utf-8?B?NlpZaVlFUzl6dG10anN4ejB2S0xFY2w2UVIyNDBFYXRsR0xUbzJ3OTM4ZUc4?=
 =?utf-8?Q?ONSoCMxsRak9UtBIqH?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b452cc-3af5-40c0-5ff2-08de50a01dae
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2026 23:29:35.5627
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2YZtyI4TjYFZgYfbJECX0aIbvd0AiRbuvm3phvVy1TfruQi6+gToTN3z6W/AIVmKPzb871JNnjsG1uQdcHEPnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFD667CEBB6
X-OriginatorOrg: intel.com

PiBJJ3ZlIHB1c2hlZCBvdXQgdGhlIGJyYW5jaCwgeW91IGNvdWxkIGhhdmUgYSBsb29rIGFuZCBs
ZW1tZSBrbm93IHdoZXRoZXINCj4gc29tZXRoaW5nJ3Mgc3RpbGwgYW1pc3MuDQoNCkJhc2ljIGJ1
aWxkIGFuZCBzaW1wbGUgdGVzdHMgcGFzcy4gU28gbG9va3MgZ29vZCBzbyBmYXIuDQoNClRoYW5r
cw0KDQotVG9ueQ0K
