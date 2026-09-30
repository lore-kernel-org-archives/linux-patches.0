Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D581F515989
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 17:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788303; cv=fail; b=SpsK+/4+ajB3Jz0QUosFWKpMACkpGw+4EGc4IhZyE7lY/UGGWZb9VeohhJcBRyZOgz/PvU/vMoHq9CLMrVM8UKIcXTROo8HQIWku67HDohZ4Zt3bMAI/VOmZfyYzxIDvhUJANoZcWupqJ8twSFwYMBAVxGlp7NKG5biCGrlL8iA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788303; c=relaxed/simple;
	bh=LZvyJ+CV1kUzcPkjfTCGrjCLZ7v6GMA/51ST0kb0F2E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ISi5y9U7nhI4E9TN54Rh/+XmzkJVhANgfN7kMgzFI330TEaVtTD6onNWDJYzbCLNkLp93PzOsKYUZnDJnibH+PI8H2Dfhdy9ktmMhZ3xYZhzwss8wzY8JvxOoDlFCXI+5BDnzZJ85bdc11JiZx2nHPsN2AL2AQRuFgJkfyJ35Mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YimyeA/B; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YimyeA/B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790788301; x=1822324301;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=LZvyJ+CV1kUzcPkjfTCGrjCLZ7v6GMA/51ST0kb0F2E=;
  b=YimyeA/B8JmG+XaeWqW6AKeMfCBvF/Vbo3bOxUmHYscG7xm63Ru6UqfL
   5lngwPlF1PiGry+b8nrAhKLiafz8bjuBTPhR2NTW1tsDE+oZlZeKSmw8o
   HkPUw7ozvVGTFUbcKIDPiCG1ULyzAQffJZyKecze0LSMRf0HumXJ6lv50
   qcZkGOlbXw5MN2oTAzQY+JsIePkc65ALFzBxjv50IutspWV94gvAYNbjx
   iOrwNcLkWWiUIMiWenKRiEjXLLgkz9I0xf3ZaXCzqZOVkH+GROsm7j0AZ
   l12D4u88aCEYjULux60I/HJn+iB0qs9Awmth7JoSgBam7dGD3s3IHyYwg
   A==;
X-CSE-ConnectionGUID: BkV79PAbRQeR3XeftHafvA==
X-CSE-MsgGUID: NOwaqOzpRF65lx7YtFBXzQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11921"; a="90588718"
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="90588718"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 10:11:41 -0700
X-CSE-ConnectionGUID: 685Qhne2R/6hYbpPNq0f+A==
X-CSE-MsgGUID: iPaIRsN/SMaAMgmsWq4Hqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,132,1787036400"; 
   d="scan'208";a="272190092"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2026 10:11:40 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 10:11:39 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 30 Sep 2026 10:11:39 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.6) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 30 Sep 2026 10:11:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mIGIMl6c1dD7xZuN4b7nQfPBuzrrH/XiqUKjliIFylAlXC2X+UlDrx9jks7I55nI7xQh5I/ywuoTnEMYvdQsO+xjHBwacM0bJPEYybiOpHujsde0dLtr5OTNZS64F+MsRPQz0kPV26s8bgIsIG0ftulcqhTxZ7+rR5tS3cnQHixt8/csoZvjmEiUPbwhAPiwJ+0zt72FaQx0Nz6qUBVYZFyOtiEfgdJi0/DaEjZOkKNk/isY8R4q8qzj33hKYbWCKA7M4fXjMP3nx7CAy5j6dvzzo5N6qQUdm9evdr6sDhSGdBO9d4ZfuSWvKF9Zhhm1r8G2AIsHPrWXfSoFg3wG4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IQmSb40QGLH44o2pA2p8R9V00HnrzoJQzViy8ja8Kxk=;
 b=eirJKTzF1KdlIrWyZ4Gl98EEtQDRj6/8SbQXxuyLKTtvg+xyJXZ8jSUOUV/xXc5BLKxsftLsiSGSTct3zU67QOw1ie43wtoXkFl8omOJvfII7uzs90bh1vwPWdRLobB9/CCGtTVoECaOnOlBPugZxjOhPMAMn+M2SSJnswYiM7luyV6Hrcu7gkDDcxVN7jZZ5ZBhwyCTZdkAoSgKhT7LRsKNhlAqycPUJYU6O5+7iwx069gSRrSX5o4McTnFZgnqaWwFYQ+EbmZYJ2c9+hjrrwxLjgwFeQd+3jtnsEGWw5uzbXRDr64ubLB0mWbcNMIQVYYUt2aa7f3JreaW+X3hnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB6865.namprd11.prod.outlook.com (2603:10b6:930:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.472.16; Wed, 30 Sep
 2026 17:11:32 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0472.015; Wed, 30 Sep 2026
 17:11:30 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v3] x86,fs/resctrl: Add event group descriptions for Intel
 Diamond Rapids
Thread-Topic: [PATCH v3] x86,fs/resctrl: Add event group descriptions for
 Intel Diamond Rapids
Thread-Index: AQHdUP4YW0ZP2CET1kqlh096AlSCULbnWuTA
Date: Wed, 30 Sep 2026 17:11:30 +0000
Message-ID: <SJ1PR11MB608384F55437367EAD49863BFC8B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260930170522.12522-1-tony.luck@intel.com>
In-Reply-To: <20260930170522.12522-1-tony.luck@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CY8PR11MB6865:EE_
x-ms-office365-filtering-correlation-id: 885e4d4a-275a-4cb3-4a37-08df1f15df2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|376014|1800799024|38070700021|921020|56012099006|11063799006|10067099003|22082099003|18002099003;
x-microsoft-antispam-message-info: kpQ4ND5q9WWPwuUa4pEf34luD0infZjpNkb/e02vUae89EvhA1EPId53KCENL3YZvkaaWkWfchvNZAGZONJqJsB/0UzKW+ewjAl0zS4LBF+n1591C3bDPle4Z+Ld2BuUlBCl4Cjg9Q9+3ZhVmOZ9tdFm1kbpbZBo9A2WbQIdT+yo8hzIYYAwa1Leut5gkE+3Sxn1jqT/dBWtvtoBMelkR77SRTWfYM0GjBM2Ob/1MI3yEWc7al+sTm9ZUXVJRv0zvr/1dvQtRO7H4z/hoOkXAiMNwUhtd+NG+L1OnojAItAValJAPPld+wVVSbUsxCRExb5GUb0Vy+1omALLZkSALG2JUprc09Onx5Uzc7ifiFM1iAnsWBcxXq0fzqeaH8jDKGdJLYlgwBqvDjZsTtLcuVtmimWKHIW5f38E0w3k6hikzSru4/2JER+yIVH3unYR4s8eb4g5A1AJlExyMxQ5nxdI6Vwlrbl1pAKhDOt2YjgtbJvkUfX8jX+lBxepIed7nDJf4F7N2/jPjMfd9XgzSH5jCY43v1BjMukLC6lQRMpc42FUHa10WhV0imfdElxLc1adb5IPeKY+IeQxRO4YrnTkqvCHpznW+JQ0YmGSVXNSslTwdZqxjrNl2qGtCdoSGXoFM2CrsPdojF5a/8RW8NNXUq51SKFcD/X4fu8OZUT5FLBb3kQkGzFUf3/lUTrn8edXJBF3qwz0B1UoXlrTei00FsaW5KGiPZqnnU455PlmNqHhyQF7v1OeIZ9WLoXc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(1800799024)(38070700021)(921020)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Mhqx4eImCLE3J5dW7Hw7zBEYwD1DvmhZsXtwt8KrBfBCbCtUg/8zT/ldd958?=
 =?us-ascii?Q?vf/EXGIwW6XWw3g5ExJZJ7l3olWzm1tsPAEPjyjBs/sLLK0ZeD0ZMN97dhSg?=
 =?us-ascii?Q?P6YDJhv8Ue8vIe6J+GrzcGrtJVgExZUF4q+zrH46Yfdtgr6kuox1tA4wxsYG?=
 =?us-ascii?Q?wFIv1T8aTbayTlfFgOsi1Uew8jPU88s0Xg2l8W2bwOmPyuVjeTMD+0R9pZzB?=
 =?us-ascii?Q?P4cyp0L0auwqBwZp3Ro7vQ+quRitBizfJbex1KPPBxqv5BG08ljzKOXmoQVv?=
 =?us-ascii?Q?MtqlpfHuqPkKnZ1/dNyudXX06rZOIA+lbHGsRi5uitS8cC69SVWxuv97i1CN?=
 =?us-ascii?Q?Uyad6HzAFMPW33X79lK2o3G23bmisYVENnXRIXINnh7TfK/9MhNmLJwAdNB2?=
 =?us-ascii?Q?kUGJ9iSviFPu1zqCJ3Vf6a2rDilMxLPZorISGIXtvPql4kEjCAAmedXH0Pyw?=
 =?us-ascii?Q?pxCveBl8SLN4n5ZyRiF988RebdwgP4cwRbZ1/3egu4ObKMo+NJpYXsz9WQRH?=
 =?us-ascii?Q?ahsI3w/Xq35lDEJm+TGqaBJx2yj2n2kfUetLhs8BH6vdLx44aDOlnKCUb/tx?=
 =?us-ascii?Q?BojSraoT+N4ofJh3ptUVPEP/bXdMLkWRwA7hjnrFRbXbD/xshl9wb+bR2TGr?=
 =?us-ascii?Q?H6GIMBR380DCSDqrCck6WD1YMKJWlLVdcLrcUKCen+rqSev1O71T9/PpkldP?=
 =?us-ascii?Q?B3WBxP068QT4WN6V5nGmGHJYdD5hoYdrd4hNDb+K/QT5xznHvUrNRJNGiJq7?=
 =?us-ascii?Q?rfBTmBAM7y9/TY3f2WUMem3EfeQVT+NqQDQImRUBtanlBKLN120ww1xpbngo?=
 =?us-ascii?Q?jHfPmvvMfB3OQCJ8DTe7DlV0tDJWUtkaePrNMMAcz2tKIXPghr+XIzjhoikp?=
 =?us-ascii?Q?+LrZFwEhEoqJ9DK3LqUVHZi+pTNPOFUy5o1D9mioMZNLGfbozt28yvsbOB+q?=
 =?us-ascii?Q?HzNAFKXYnKHzh64eDZAEWKRKRZN1xtTMsOBZce+eA8hGsytsLSAGG67VJdeQ?=
 =?us-ascii?Q?TVqa2cgHB/7qItCYaLxF7V1znv9+S+xO2yfsL9ZvaQ+uF+OKANsyDWHadRRB?=
 =?us-ascii?Q?3RgOUaQ4byN9L3spL5ydfzxgz7wRk3i5BkmXBXofHoRS7DSGAtz4OB+wFQnW?=
 =?us-ascii?Q?0NpsF7ii3/PX35LldHFjrjbMOuwr3RmGkTBJeJrEbYRyNfB8xldz4k6bXpWr?=
 =?us-ascii?Q?2WwjrALHBgUbsYKp75c7L+RWUH05bDdYnwSpaJbJ1QAHSrLzLHV/G8R59z75?=
 =?us-ascii?Q?Q4Me3DlGXBTi0xkq+44ZXS6b9QbBNgbcV9b3sW+xlg8ZQQxodNgL1c341owG?=
 =?us-ascii?Q?S5dln3gvCRq2jSsh7fdwVbnUgHFDpZctpg4xHiiy/pxknJbrtvs6nLNLKS5n?=
 =?us-ascii?Q?L1/zNIE/FNRCRgfktgfNXLykmW434zAu8nTVRHi1ZDEBUEpuzoLi01+kPN3B?=
 =?us-ascii?Q?Qz7UnORDPjpdeKlssq/fOgmmeiixgwQS+E0IkrzG5btA0dFbg8fGsojAfYa6?=
 =?us-ascii?Q?BnSDLp43Q1HeZYd5E84M1cwH+PgqJerTsWvUMMQkOJJ+IHYk41aWgTL2Ekmf?=
 =?us-ascii?Q?CaG0Zqm71F2TC+xGVFpGDt/wPrr48D+FnC0SyIuYUqVduaroMONDmr/LrExm?=
 =?us-ascii?Q?hdafMVmDPMmNz2iw67LPIJde91FZbsNxUKs/Rfe2dchmclsp8q6Y9Es3MXYT?=
 =?us-ascii?Q?cLeECAsi+pVlSolaYxllvKdAlE8JkHMIg/Mqu9NTgtnAv7iU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: xKLdKa467Du51DQz50+OMEDuPPgGgA1nkvHiHYs2Cq78hGiimhkjA9La6wdHeEmnwWFE+MjSM0yf1hSKay5UG6PhNseymyrAspWjQP+xXQ8m6qNfYLClkLM3KtXTHhX+Qei32s5YyO+Un9lkMHjn5RfUvUvVrP16EenZjH6SmFlZzva/iSuSrAV6xAD4Ai4aly2+UHYxM7wnlP8SJA8iP1fRUOP/AmrEOAV2uoLw4QbESHoVxQAlEi6xrVRVbG8K+BSIT5wE8D9fvCCdRum1j726EmH3V+lCvtLEF22j2fnpbxIFJkbFlTnH2EvUpoPp2yIMXVhQMpNUhcFldCS9Gw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 885e4d4a-275a-4cb3-4a37-08df1f15df2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2026 17:11:30.8741
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6dCcj+tu4P9fOv//aOsmQ+x7ZU4Hy7yzq7R1zKH64hWuTRDpLcrluO44KW8PPrsD9VkIQ419gHO5EaYwGku4OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6865
X-OriginatorOrg: intel.com

Do we still have "brown paper bags"?

> static struct event_group *known_event_groups[] =3D {
> 	&energy_0x26696143,
> +	&energy_0x47903099,
> 	&perf_0x26557651,
> +	&perf_0x1415910A,
>  };

Famous last words: "That change is so simple, no need for a test build".

v4 coming soon with the extra s/A/a/

-Tony
