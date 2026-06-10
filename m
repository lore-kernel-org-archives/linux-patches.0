Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB43B344029
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 17:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781112306; cv=fail; b=t6Uyzq6UU7LGjXd3vS8h0QaCt/9ikKFdjzC7xIpSIccOC1Nvi4fCQenqpstp6N6lthXMrUzxh+m9KGhjusJv5xQJBdQQu1xICjuU5ohNF7MziixEC4e3CJltCxAzihQs+XenSFyA8qJZSNdmFEibxI4pSv4fGn93Z1AEEyLyCoA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781112306; c=relaxed/simple;
	bh=CiGKgpOfhDTyAWRqYH+k7Pt/FUK2OFt4fC0Fe0CT2co=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i62vre74wS5B3nztxr4dr5dVXyECWVZ+tFi28kv/oSXyVmCbN7/miGzMdhD5q2YwejDDkH2T+Kl9yOpRCCW+8RSL4Qa4Xded4qX7u189x9E0SjQ+oyEglO6pIKMGUlJpKsDypBjmKOqJyirHVESztJkiM/HdSJF3Os4rYBrIU00=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBhY5wQX; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBhY5wQX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781112305; x=1812648305;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CiGKgpOfhDTyAWRqYH+k7Pt/FUK2OFt4fC0Fe0CT2co=;
  b=WBhY5wQX54dQbby2cxoX+p8tV4Gz82l4tXX2rk95mKruNkm5fftVqYXh
   +BCtCFKqUreEOUeDNQcEXWNCYAfJOebgNfuKVH2jpvJcPInuc9n74f8Zl
   4WGGrWa7IdQ6M0zbDKgG+zwdfYZgoKjRGro3mzlVld+m7xjflDAxHr1+g
   dArgAMiQ15g50Y2NArp4BdfgshP+N9g0chLGzPkk60Ek8hBh4tSp8mQHz
   oIvNsKbVP89wugKLVd+iXlUmk9AXz8673X7mUb0tKAMqgbtWQKJwV+avs
   S9ftHkyzKDJBQwyK/rIQkyeEqBDowt7udfRrnVvOazzhJbl42p0kxxnZy
   g==;
X-CSE-ConnectionGUID: z47V8d4RS2aBcnnpucBpYQ==
X-CSE-MsgGUID: MA+H+SI/RjGBEZeaAAtfig==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81888988"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81888988"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 10:25:04 -0700
X-CSE-ConnectionGUID: PWuVTXK/SZaFl0NOzEdtnQ==
X-CSE-MsgGUID: YZN380wjQH2H74z1TEFCcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="245112739"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 10:25:04 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 10:25:03 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 10:25:03 -0700
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.0) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 10:25:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gHwyHaUpL1Caz0zdFZA5+XxGDvobjhD9R0DJyzZntqRIGuVZv3aXhVpMw9SuKegmR+G+mBCW06do/tm8fwcKsViiOpppPoYNI3zAIbvnJwqvy1ap9xknRv9JEj3AdlcWKXtgDahbCew+l1Fe9UWERdu0lWRPZwEGbbjAtZCvddB2AOzd2x5zvHSjLcJ2iNS7Vd00WAtscXcjLPPILvOGs2AXAeAsfuP3Py1IZs606eclA/zCdCMX0LuiWJXaA3Cu66AyDadXRGdqhvNvbB8BcPzMhQnGMg/k09uPk/6QopYCkVoZ8hm0IF9BDwMULbYbuoaUbT5qYARF/VRqG8ihMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CiGKgpOfhDTyAWRqYH+k7Pt/FUK2OFt4fC0Fe0CT2co=;
 b=auwvjikiK1vJlp+OzZR4HmrrWJQTe0XLfUdypZNiiDiqcx0BkDn+N3uNbh/YF/VPXnitSY1EcYEBukbNF1QI8U24xfCSXR5M9BBFfZa+f0L5ad8QRhLM57fyOx/nxBZLuLF75La+kTt1hIIy1cvElMDZDBLBVIHJdIOfP3rw8GjfxL05EmL187F6qu+/6jQ5c4KZGWwA5ur78ZkAhrOpoGLQBXwl0fb609l2LCOwFSh9VxVurcA2loGEHZ8W2VSkuI9Hawm+fUaYHEhTJuomAfMLVuYUOP8Vc4KG3FiE5DBijvR3Wx9UnLyRkkCavfAdjMWNDnH3LjYUxY6KfKtc+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by LV8PR11MB8747.namprd11.prod.outlook.com (2603:10b6:408:206::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.13; Wed, 10 Jun
 2026 17:24:59 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0092.007; Wed, 10 Jun 2026
 17:24:58 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, Christoph Hellwig <hch@infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Thread-Topic: [PATCH v7 11/14] mpam,x86/resctrl: Resolve INTEL_PMT_TELEMETRY
 symbols at runtime
Thread-Index: AQHc8gDM+JX1kLesKEOCfGpiX0KTArY1WEiAgAGeJICAAQDNgIAABjaAgAAI0wCAAAOhgIAAA5IAgAAIlsA=
Date: Wed, 10 Jun 2026 17:24:58 +0000
Message-ID: <SJ1PR11MB60838C247727AE7CC324BB25FC1A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260601195632.15876-1-tony.luck@intel.com>
 <20260601195632.15876-12-tony.luck@intel.com>
 <03d45c09-b392-420a-9b38-1c1f213a7dcc@intel.com>
 <aiiq55x6fs2ddS91@agluck-desk3>
 <387cc53d-7e55-4c1a-bf0d-635f4f7590f6@intel.com>
 <aimHif2ZC3PIjHw1@agluck-desk3>
 <19f35a7b-711b-43e0-b938-3792ae723a59@intel.com>
 <aimR-7ld7-EE_YCb@agluck-desk3>
 <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
In-Reply-To: <8ec6b46e-dd18-491e-97f9-04cbba827370@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|LV8PR11MB8747:EE_
x-ms-office365-filtering-correlation-id: 878057c0-3a36-4f48-f7bf-08dec7153261
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|23010399003|376014|366016|1800799024|18002099003|22082099003|4143699003|11063799006|56012099006|38070700021;
x-microsoft-antispam-message-info: WNZt8Cs2C/TptIb362RqvDW+Ji+fJV0NbhiGThjJMFc5stVcGPTxW+leTexaSCR6rgcB50Lg81wLI9rVEV6aGpsS8ESjrQWH/dnB3g0+M8OiIzGdz9GGCotUWzbnUyFFC8XIYKDQPHksxnM/st/if4zEegCiwyPr9MnWgIcRrZqJbVcXZC3qE1gXfcNJvcpAiP0Sh/i/yZHULz0BaZe44GC4Lk5rjSIETCM6VXrY/Q0b1QyvnqbxwetZhj1ISrbTtVkU8FteKc44pwDPsvWFT5aZ47+WQjL1Jv0T1+ZlTRt4wdkphSs8tHDUVNT2CUSuGoyyc7GwwptnPK07hXrFzerhiZnSfu8FlFauD3jlm8ilv8zrhQfur2e6UC6MijXz9tOmvJezKGvoFavXzsVIHZvBskbNFONl5N9pGFsImbV6TTSd0A8CPt53wivSFs77mm9BIFEMDZgpd1EHHq6nucoHgv2EV/8rBWTIXnokLyFKPBmFNSgyvNv9nh5HDsvG653mOjoNpmfor11gDL7rdL6aMdGjLiqwxPx2gbQS0VgpRvzaatDV0nh/6Rl71tXGeVTSdlOkVgc3aw8dAfVcysCNuBVY1DLdCLXjMELg30lecDU9tpxH5EOClRXDIoLZCjSlSzgTrgVTnb2W4Ox9y1FYnAIgiBKBhAlBi7YCxOADzvcXBwbw9PgasBi9dyY60aSMZUGkFH4P4DpwmscauuwsrXTRIUc3+HLHDi3rWlRj4HlFMRSn1whvcbODtYzU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(376014)(366016)(1800799024)(18002099003)(22082099003)(4143699003)(11063799006)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZlR2RDE2OVhMWmVldk1PZVJ1ZnF2N1NUc0JhNmJQOFRwUUg5UjNRL1M1RzJF?=
 =?utf-8?B?eFpQdlBVTVRNeWtvT3kxajg5YStCNytIcU1wRnlsRVFFR3BXY3VuTXBxb1hz?=
 =?utf-8?B?OVdjalZaQktxWUNMOFUvUWtEOHlQUWQreWNZUktCQzZ0VEcyRGdqd2thLzZn?=
 =?utf-8?B?dkNWbXJBellqK0l2QWo5RnNMbHNSdmU4d1ZlcUJ4ejZBRUxpRFZyVzdoZko0?=
 =?utf-8?B?Z1hOMEp0L2doaVJOVjB6ZEFBaHE0bURTSVVqVCs2MUlSRklOcU1Dd09oWFA1?=
 =?utf-8?B?VmQzbDF0YnpVNkI3Q0hZY3dOMkxlem05TFBrZHBOOFlySVlxSkNKQzlnU04r?=
 =?utf-8?B?S2w5Vm9hWENicXQzMjBuVGNPUDAyZDZ6RzRKN3k1bGRQQnBOc0s1T1U5S2ZI?=
 =?utf-8?B?VG9Sd2RMenBmT05XbzhoZEVjSHMvNUdjUXJvWnFWNElTWlJuSDVvcWI5U3I1?=
 =?utf-8?B?YVliQWpWR1Jnb2R1YjBZS0c3aUhiOUh1NFdodzR5andGMFFRN2tPc01OR1ZZ?=
 =?utf-8?B?OGlIOS9taDBhVmlESUEvelhTSnIwNWE3NGVqTyt0ZiswWHBSaFd5VDRKVnpN?=
 =?utf-8?B?RDRkSFBldFhPczY3VVRWd2p4QmdEbDViNHZKbGhlSWVCTVhKcnZCeGt1cHBa?=
 =?utf-8?B?QldXNjZUVlpETkt3dFpuMUpISUs4TFpRNHZ5NnZubmdqdytnMWhrQ3NKbVB0?=
 =?utf-8?B?aFJTOThOMitNNmhkbmNpOEtMTXVNQnY0VU9BeDZZOUU2TlhRcFc3R2FqZDlN?=
 =?utf-8?B?OEtYWUhKdWlMZ3FCZG43SUxwQ2laeGJ5QThRUlBYeThGUGlyVW8xcHVPQXNE?=
 =?utf-8?B?RC81a2w0LzR3azhTS2g5NFFteW5BYTZhZkIwMkdRRW1JSEt3K2tmMUtKSGRw?=
 =?utf-8?B?NEQ2UEZjUW1meXNXaDFuQ2RwM1hSTDFYcHBNbVplTVhXVTRWcjNJMGVlMlJi?=
 =?utf-8?B?NUxMVEZhejlqTEZIN2FIc0R6T2czenRnT2NlSFdZVTZDZXV0N2RDLzdoV2kr?=
 =?utf-8?B?N3Z2OUxhRmUyWDNmdDJoajFTSHV4UHdZTzgvdFAwUmhQYkdXOWNLeTY5VVcr?=
 =?utf-8?B?R0JFaktkemJCcGlNTmJxa2loVm16dnFNNC9RbS9jUVhTL1poc0R3NWY3djdv?=
 =?utf-8?B?ajdKbGlWNG1kNjJTMVg3VVNMcnk0T0pWZ2NUSGZBRTNFa0J0NmxUdEc3UDQ2?=
 =?utf-8?B?RjFWMzRxN1ZvU2x0YkVNZy94Y1UwcTVQWFNPUnAwTDF5VnZXWkdiaDFWQWdi?=
 =?utf-8?B?RzhIZ1JqVTFYOFdVb05pL1pnaG15OUk5VUZ4UEt2ZFJ1WTJTVVoxMHVkTzY2?=
 =?utf-8?B?NmV2dU4wbG5USUNlS0FmWFBKcE9Nb2hDRzY5QjYwdjA4RkdLb21SczAzUlFJ?=
 =?utf-8?B?TGtGVzliSmxGL0RQUnBLZTZ2Y1pIVC9zeDhIMXcrTGhpM2xSa0Q3TU5tMlpP?=
 =?utf-8?B?NVhIeExmTVBwMHk3WGkxZEJkOUdMU3hQdWZIZmZCODM5TjhscVVvOHVWMVd1?=
 =?utf-8?B?OFA5K2l2TWNidzFCSy8rUnR2MnVFcTc4bTQrSVR0NlNoYS9jYmdGbkNBUHdQ?=
 =?utf-8?B?eUxTcVpDYVVBYTQwM0FIbHJhTjNqMzl6NnRtckVna2RDWnZTSEZOTUJRYWo5?=
 =?utf-8?B?RnFjMkk5SzBkd0x3aERCd3d2SGpwbFRBNlViS1VsalFJZWJyUmF0ZmtPeU16?=
 =?utf-8?B?NEU5TWVUdjdaQWlXTnVZdHVHTkd0ZHR4WVBOTGQraENMTHN4aHRubGtoamFN?=
 =?utf-8?B?UFl0aTU0VFVUc2NTS3JnRjkwbm1OYUN6MFplTThTaGRYVm80OTVvU2FYWkNs?=
 =?utf-8?B?RkIra3JkSmttWlRtY2pUWVpxdXdKaTJydzBkV1Z2L0NFWjJCbTErbDJlQ0RD?=
 =?utf-8?B?OGkrY1R3cUEvUVZlS0hOQVJPWUl2aGEzZFgyVmw3U0g0Q1JGM1p6bFdjZkRI?=
 =?utf-8?B?U09BVkIrWGRMNStoRzl2UGU2R1F3ODJCdkJMRVFrSWxXci9TcEJrWUhUZjYy?=
 =?utf-8?B?bDF2RVNnYzRibkVZbHlOZmlJNVNISzliZnltVWVuUjVRelViTVZWSFlXYnc3?=
 =?utf-8?B?V1BoUGZSL0lvelk3NTBoSU54c2FFRGpuUVRBQ3ErL1RxSEQwT05rMVJuSlNB?=
 =?utf-8?B?YlViczVGVzVFbkFiWGVLRFFmSnUzUEVER05LVDIzR0t3RUNkSXU2Uys5TGlQ?=
 =?utf-8?B?SDBETmwwV1hwVmNvTEJlUHNPVk1LTzk5WnpaVXpHeUVVQjltT0FGQkxJUmt0?=
 =?utf-8?B?dkN2bUkycTd5L1gyYWVOc3dSb0JLOHJOcnJhN2hGQ3BWbmsvTlg0M3RxN3VO?=
 =?utf-8?Q?FOWeo6jmoPjYNYZqqb?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: TM4qwj7McLDUax2V+S7ceIyIvLl3KUnxbMj3c2KBU34kwTCfD1YTgmOqEC2tvXD3Hn4OlwntNebShg6ZkhBpoY14583TP/YoYRz9/ijDe2WSs7UpkyN/aAyg1JxJ2h8Dyq09f9GafxZDSjsN89nr2yXyqanCuuau5vpjo63Jqo79U1LfFXgUc/l22BDcCAmIdOTq/8DmvD99Q0be0yDOVgyL+tsUqp06sC9CC0ACjn1EamNQEAQhThH5chn6bhFMJ9K2psPtv/ILe+ci9xDblr/9XB33rwqVtNLLDCwxQL3Wgy0RXVOW8hXFjl9WVBUb8+YzBAF+BJ0XW/es422pbQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 878057c0-3a36-4f48-f7bf-08dec7153261
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2026 17:24:58.5271
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hmwmlbFXcHT1eC94da7eP36USVhtpSONuKY+ATlwDKSNy9K4WuEHq7hQmM50cJHvGVRnt4PjkSYiDBo4MB4vBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8747
X-OriginatorOrg: intel.com

PiBJIHNlZSBtYW55ICJpZiAocG10X21vZHVsZSkiIGNoZWNrcyAuLi4gaW50ZWxfYWV0X3ByZV9t
b3VudCgpIGV2ZW4gY2FsbHMgaXQgdHdpY2UuIEFyZSB0aGV5IGFsbCBuZWNlc3Nhcnk/DQo+IEl0
IGNyZWF0ZXMgdGhlIGltcHJlc3Npb24gdGhhdCB0aGUgUE1UIG1vZHVsZSBjYW4gYmUgeWFua2Vk
IGZyb20gQUVUIGF0IGFueSB0aW1lLCBzb21ldGhpbmcgd2hpY2gNCj4gaW50ZWxfYWV0X3VucmVn
aXN0ZXJfZW51bWVyYXRpb24oKSBzZWVtcyB0byBhbGxvdy4gSSB3YXMgaG9waW5nIHRoYXQgdGhl
cmUgY2FuIGJlIHNvbWUgZ3VhcmFudGVlDQo+IHRoYXQgaWYgUE1UIGlzIGF2YWlsYWJsZSBkdXJp
bmcgcHJlX21vdW50KCkgaXQgd2lsbCBjb250aW51ZSB0byBiZSBhdmFpbGFibGUgYXQgbGVhc3Qg
dW50aWwNCj4gdW5tb3VudCgpIGNvbXBsZXRlcy4NCg0KcG10X21vZHVsZSBpcyBOVUxMIGlmIENP
TkZJR19JTlRFTF9QTVRfVEVMRU1FVFJZPXkgLi4uIGkuZS4gYnVpbHQtaW4gdG8gdGhlIGtlcm5l
bC4NCg0KSW4gdGhhdCBjYXNlIGl0IG9idmlvdXNseSBjYW4ndCBnbyBhd2F5LCBhbmQgZG9lc24n
dCBuZWVkIG1vZHVsZV9nZXQoKS9tb2R1bGVfcHV0KCkuDQpUaGVyZSdzIG5vIHNwZWNpYWwgY2Fz
ZSBmb3IgdGhpcy4gdHJ5X21vZHVsZV9nZXQoKSB0YWtlcyBhIGZhdWx0IG9uIE5VTEwgZGVyZWZl
cmVuY2UuDQoNCldoZW4gQ09ORklHX0lOVEVMX1BNVF9URUxFTUVUUlk9bSB0aGVuIHRoZSBnZXQv
cHV0IHNob3VsZCBzdG9wIGl0IGdvaW5nIGF3YXkNCihJIHRyaWVkIHJtbW9kIHdoaWxlIHJlc2N0
cmwgbW91bnRlZCBhbmQgaXQgZmFpbHMgdG8gcmVtb3ZlIGFzIGV4cGVjdGVkKS4NCg0KLVRvbnkN
Cg==
