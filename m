Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34F33537DF
	for <patches@lists.linux.dev>; Wed,  8 Apr 2026 17:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775667721; cv=fail; b=HXpR1/OKwEWK3kRJ7rBoGm4aR5bvPJJEo3u+nnLm+AL8bMJQwaC7oCZ+XE6mVA4elSCPTDjxAlIqA4L09gVX75iOzL5Po3PdAqznYKl5281D8RCGRvTeE7EC5MT6qnijUtLs8DOIBEJrSuj2zxjzk0dEFJ9DS0oM00lalXG7XS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775667721; c=relaxed/simple;
	bh=HCKsYYDfNVMqclbaTu6d0Jn8ozY423C49itrRJQjbCk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EZo7z282MRoLqhbizdU8+gTN3AVO/HNheKSzl3wP7CUm+dsMTZ7EgvqEiMTNa8zkzBCmGcFD0M4MZYnp9ef4jLZf568nXPqxRTy9+wB480BNT8+WmT3MRYdDUkQsqLEYa86sYQikMBC1sjllFjCk/x69azWzBtnfDkYCUvr/VOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fd+qARte; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fd+qARte"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775667720; x=1807203720;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HCKsYYDfNVMqclbaTu6d0Jn8ozY423C49itrRJQjbCk=;
  b=fd+qARte5AghZN75douTyCkMeRvFnVwqMlMuqhfxbkG5dw/MwJoUggRH
   hgsWzTI9caMEAp8gnIq03C2GRSSgTnR+h5KlxeQhFFaCn/6uYfKgET2Nl
   oKt0Lf7n0/2Pmt27rbTHg49GSjg6ng4bCz4V2ha+tiL0gMjM0lVhSN/lu
   ZqXzSlaC+SI7BR1fBwojWQvbBsTlzOl8rwN0et+Agiae2Rfss3A9I1cv6
   8T6Pl1b4+6Xk3Sq2WHtFQEAHeR1xN31ZgMh2i1cydpTj5+6+NAZVFjc3Y
   WUQNXz3x4lANZhJMOulUuBw3qhYetnS/LVSFaPHD1WRxpQKETUybuMwQK
   g==;
X-CSE-ConnectionGUID: zYlz4iMhQvSaaOWgNohgpg==
X-CSE-MsgGUID: ifCDOUwpTk2Nozg2t0i2HQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11753"; a="76675223"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="76675223"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 10:01:59 -0700
X-CSE-ConnectionGUID: TbMDMamAReOfc/xwzEPerQ==
X-CSE-MsgGUID: dEId5fCRQ1O5qvTqCotAgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="225352122"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 10:01:59 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 10:01:58 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 8 Apr 2026 10:01:58 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 10:01:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Pje3ga17wIyCPT1omUK0Q2lhSUm+1szADKJn7xBow5u5zsrK4fy9ieCLuMPmWy5kmGvbuForgBKBv/O1EW6IsQaUP210eLu2z0VNEWynfOkY3n2dwLaHdL5wI9Ssi3r/eT9k682AYpwZCZUDUxNyn9iwp7oezGFa960xEmBCr32w3s6yl6XzbQG3gidIZsG+FxelDyMKw741e9VEUS2V5Eop1G2BWWhzWtcCnisXj3BHBtmmZJBEjjlmBm4TYQxXyIYyHICIErQn9WaMpNAkZOj3YiTyqMWnwDVAugeDMu5Ku3tslEn5W0omvfZOm0OmS+jsjRyMyllJVaRZd2my5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Je38u1YcUtPBIaMTu4XkU6NoGxk/wK96X2dG+Rc1sJo=;
 b=DmaBnYzaDI0fnnle0vjGmTo5/yP7AgczxmJigRdNS4Xeu3pbBf8fF2FYBMfgCYjYTxZ2OhApBGUgrMwlNq58pYo6/GsoTbnMqlhFKv0mAXs+DpKrOX2RVuUyKxwq9a2sgXIEnxmH+hLhWZJ+MVUG/b4Xed7UTkt6L+5kuUe/o3KX0mHksasjKdpqu++HpqfrLP9fX/JJdn01Etl/3Qy4mzKR3YZPuBtKegt6nfYOP29IkDNl4HiuqEv/xI9xb9UNyAMa/8hzFe/mAgkbNIWLAzB0bsOzk6NNDxORF0LndKISZdiDKPYSzw4i2ctAVXLJMhcB1ppNwwzxEYVG7jIuZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB7447.namprd11.prod.outlook.com (2603:10b6:510:28b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.20; Wed, 8 Apr
 2026 17:01:54 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.016; Wed, 8 Apr 2026
 17:01:54 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration
 functions as GPL
Thread-Topic: [PATCH v4 1/7] platform/x86/intel/pmt: Export PMT enumeration
 functions as GPL
Thread-Index: AQHcwI5FAO2G+kncS0WX9CtnqwxMsrXUqiqAgADFdRA=
Date: Wed, 8 Apr 2026 17:01:54 +0000
Message-ID: <SJ1PR11MB6083ECB77F9AC85C2E8F94F0FC5B2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-2-tony.luck@intel.com> <adXiozY7LdDNvAd-@infradead.org>
In-Reply-To: <adXiozY7LdDNvAd-@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH0PR11MB7447:EE_
x-ms-office365-filtering-correlation-id: b29b0f45-f2f6-45a1-b1be-08de9590893e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|38070700021|56012099003|22082099003;
x-microsoft-antispam-message-info: 7UTRSCH+/eOgu/LtFEtGHW2M0qpCu6ap83erBMn24aF++idBKfOPREBZpmdEO/7H1DuRApy+ghmmhBYOCaggaQZmVdbjabDotoVEr8LnzLpa9D24x0cCw2Z8ehdg3QOO0D8rJrVlJjnEP0OZXDWjtHq4tn6bXoW6tcyCIIUUT+zxF8/fMapcVEA9m8EV7aAJKKkYtkfHoquOZXki4qs/aEF3409/SlI8B4AB6Z4xh4S7gIzIhspMcYj9Lw3vBvInjPDgjWWnFqhOxy5DEkq7kUpUJvXXnfhmVk3GTJeN9NqzvPatKddXfKeP6Fzj0AHtf836BnypO3BqmfN1e+yvcW1lcdARvAAagc+cgaAjNK1XN4hvGbWpgmYPKJk9zygtq8nOBJIppVnCvZPf23ZzQBydBpRL1xC28cIvt7t9a/SfG20VSd8YGi9JQCfhSL1Cv7RoyP4PohT2TLbZ+K1pCV4DceOYteV824pcvdDkW2g6MRSGZyf40GWZ0eQ16KQvFInIez+wJYtVffidKebMmv6GBd5bZy2Rxwl4Cv6V08EXgMBLUOpDMd6cBwi8Rh2L/3bZKOxi0JCflFVeB5VQDfccExE5VR6ZrWR3Jdl2BNR9nRroF/g+YxcZPLDJjg7NW9W17tN3eeZzbmyzwC49UAsXd6KqgW5PxOrUI7hsjPFGjGQynPvN+Oh27vb/tH538NWDocbwhhnuj79PRRt+0qCGTP9nMUEzT9ePI0HotwRhCdnasnQmQ/F1PJkBpD2cpP+bz5GGTHxFq7RcppPLPoWILC8ItyRhUPlLdHvY5No=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(38070700021)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZnfWIwtpwLXGSqflBkGGWOXYRVn6u9gG6RQSrVVxpD8idsLo4I74WCE6pLCM?=
 =?us-ascii?Q?2LrovPRowS36IotmrwZWgRNLkwCt7iIipfhYlHj9RRz0HD66bwEqvtgc1knr?=
 =?us-ascii?Q?qYjUy8mxqlifQBfF2rkzEOLtwdNaSYZ3OblmdU8y66VoYgAw5/ZsQq6mHkPb?=
 =?us-ascii?Q?ouSYkBq4fkExfVHHO+7Po5mvCmSfni0oEETLcN2UMeGvg3xbOmrYaAQr64SX?=
 =?us-ascii?Q?cbcLFPQ+GDLdJ7bl3vPnKbMIM9IsjWVzKVX4ax4Pst6VuZeE0+/7qCvfJhDH?=
 =?us-ascii?Q?r2I/3OoM/TTkE92CnC80d7NUzcUUcuss79oZKwQGZvXaHWDuxeBYM99c1IsF?=
 =?us-ascii?Q?FopMI162aJrk7aYpyiAcyCSKf6HlYN92ZbkSouAvzpVDW5n9Yqzv2CZ6RSJp?=
 =?us-ascii?Q?iv7e8yOoAPS70m8RyPd2U7PbN9fs5yjNy2s+uLWb2jcNtCJMxLctoWZ1WUwA?=
 =?us-ascii?Q?g18muAO+DfS29W4cajycEmG8J53MCDvgB0ROdSAc7ceAe5HSive1JaO2QVxC?=
 =?us-ascii?Q?6sHT4fuvGngHHEJIUFwS+h0+P4IvdVJ++XmHiwIOLyz0qF9wSSI21RvL6kir?=
 =?us-ascii?Q?RBU47CumtulUN3byiyCbiQa/qcJFx+6RbPW4XJZpZPuhWcEzAHPEdPVKcPki?=
 =?us-ascii?Q?dChYrUX6e1L2+p70shh8oMH5zpCNqatSdyEUKT+2rySfsbuqpAnM7Jp1mCUV?=
 =?us-ascii?Q?qtK+bxaALbb+eQKtIp4FAUvAuOxqhaFsh+r7YcIK/H2OS9a4Sh3XAJIPO1jO?=
 =?us-ascii?Q?SZC8VvBivfqSGvOKepiFSFudai5RiEQzIEHD8iqWzqh6dnxAzDcphnss7ZMd?=
 =?us-ascii?Q?EZiBbKl93Hqb0mYYVZgLPJ5K704893EtxE3PqQOFOX3cFJkypEeepmVnDN/c?=
 =?us-ascii?Q?TOBrWlWoK13/e6PH5p+355Kk5gSvhJJUtNOMxGvzrtmoIGg6Dm9vkM92K2Ee?=
 =?us-ascii?Q?RjcZxBobPkI1vCG/2cNtCozwX50YmY6Bce6tcDk80B159ttHErpQWneLcyzo?=
 =?us-ascii?Q?SojudLn+rZZ4AWzizmrEZEPHFRmyJM0VdDj+hOt1X32DA+6EWEaRnzy7Ntcx?=
 =?us-ascii?Q?tQ6yaGTUNOvEojDyWDdPKgjgQIFKfkIJOBV4NX0PW0pYY8i/gSe9IZjmb0sY?=
 =?us-ascii?Q?MLS5VG4k2/6Vy5n7EpNQ+AcQI4ZzSqOOw5jXu+EWBSUJ+ActL0K69KnqIXFj?=
 =?us-ascii?Q?VcihDdHs/Q7xFiYwdRCYBHAmejNQHg/uX8WxHfI7y6LNDAVGKKCL0F5y4Fz1?=
 =?us-ascii?Q?rUN3TLgyezPiterHX5J3BvI38l3fgpiWG0DTW2el7A9jS0YX5cMekNBeWhSg?=
 =?us-ascii?Q?7bL5M2ikRYfwwGzFZ838fzL1MiF5EGpE5KM8kJdBsA9ea5fw+Apu9iKMOHPX?=
 =?us-ascii?Q?bG0JDvdNM3PpCSqu3c6HcBu3tSJKigPT0bBjb0DzEKWw4U+/j9Qg43uYMKPS?=
 =?us-ascii?Q?ZWJPrZzIi881eC7Drupv1ANQF8nSH2eTYmPUPsVq/zGVLdi46RfuTqoaJo7H?=
 =?us-ascii?Q?/qakVnZiG+QWcc7ysj51bC4q3Wawxv2+AXOUHs1BguTK1kPKdC06cQie8j3f?=
 =?us-ascii?Q?3cpMgKTMo9tcVS0U0v7NARZfIn9ekr2FjeubrLqAp551IX4vphtZuKVUZ+pw?=
 =?us-ascii?Q?e8SWRejS1nnNyxxMKVtzFJzdeaJ4zKn3+CgV9XPOmlzsUjGNIQNJmyOOngDm?=
 =?us-ascii?Q?LRG8dfsNLjmScKa57V19VKG/62/6xVmezhgmwndzQ6YFa9kZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: QC+bwcugiQO0CDnCf8CF/BHnB1U/uJc3Zca8G8Po3JelpX6yIi0LSXozIHZQRDUe2NmEdke9YUG0mdyYqHS9QC0gFjLYs4vsAVyf44oXDSjmj7/OF2ilwdVk1iZmI3aeOElVIoeVs/ZhSriaSlcmqierkY87Y4J8VmcAX0OLB77p/ayrg7fHAWjN5xrp3dqCgIGkHHkWGIksK7aTGHfLKxNg+IZ10dDdvgjF4ghXG5xrZm6NXCwnG91xup/iOxp8FfgEuxLgnAJl5l9kI0czSb/UeCbdwJKDe7VX0bz3bYtGhBtF4Is7Y9Hq2bmtglK/sN061ivvQDI8LJ/3Hqg7+A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b29b0f45-f2f6-45a1-b1be-08de9590893e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2026 17:01:54.3111
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /QykvrLZ/1nZw/v4LhtavcgtAG5q4iooAkCDLAMjucrDnl4T1aBCXbiE8G6vhTP/e1EgZsyufQKJs9NcZU8gEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7447
X-OriginatorOrg: intel.com

>> The symbol_get() function requires that objects be GPL licensed.
>
> Please don't add new uses of symbol_get, as we've been slowly trying
> to kill it off.  If you have bidirectional dependencies just add an
> registration module in the middle to resolve it.

In my case I have "resctrl" (which is built-in, and likely to stay that way=
) that
needs functions from the "pmt_discovery" module to enumerate which
event counters are present.

Should I add  EXPORT_SYMBOL_GPL(some registration function) to resctrl

and have the pmt_discovery code call that to provide pointers to resctrl?

Thanks

-Tony

P.S.

When killing of some function, it would be nice if you added it to:

    Documentation/process/deprecated.rst

to make this obvious to unwary developers.
