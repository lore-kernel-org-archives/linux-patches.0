Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8674D797E
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 15:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.6
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789573925; cv=fail; b=aMv2QffcRhIZIaBT/DM83Wrsv9OEXoNkD2A0O+V9ysa2I1lh36koOyjR2nPp6+lluub7/b8wyC1rcQ8LeeG3Uc9al0+ibpTxtdEmAuN5blITgiXdNh6zwnskjg9znCXx7Yby1gyZ1DbBImCAe6GDKi3n5j8SzyETptoMbVkcG3M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789573925; c=relaxed/simple;
	bh=ukak1UwFFgoMUSaNDF6XuzLQGGHhgx60eNw7gIb6eJI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=R05/gLCsb5IDb3sIkmap9nitCBOAMyfDOFktIbjtwa1P1f/kw4EiOQL2NWF/UI7OCB6l28cy8BLOhr6QFTlJFh5g3TfreheG6YiAOnvkD4O8/DF7IAhLi9rxBzB8GVIa7uMJJkJz+ZkwtX/TOHFFQbUT6vx0yBOmq+syxHil7JY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QwbjTRIo; arc=fail smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QwbjTRIo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789573924; x=1821109924;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ukak1UwFFgoMUSaNDF6XuzLQGGHhgx60eNw7gIb6eJI=;
  b=QwbjTRIoysb1LDaEw49xBhAaYP1rKarhETcD7OnnyK1W5PYtd3s4IEDg
   kzIg/Zs0LurCm6M9W/vJHmdMSw3hnBX1Ntibz/04doSOkjpON9H2eN+Mn
   2Stc+JYmeXlk4w7EWpLEhUoBp8RVCnz2ms1gBMNCRajLbO0HoCCkUwGv8
   b4fiQAfo2pK+zzviMc78m13GR/UsALPN3ReyUMOrbZHN5iBKdMtTSO7VL
   xCyfWmcK0lsf5TyBZkNlL4Slboel5/uAk8x/OihSt252yr3W3sJGxa6xf
   BiaDqnVFKJsbrbzOO04qq/yzleI5EzzCcfsdUBt1NNZou89pZOkZ44VL9
   g==;
X-CSE-ConnectionGUID: wXFHlR1dRC6HPTAjcKI1Hg==
X-CSE-MsgGUID: JLSpG7s/RI6Jz2txtws//A==
X-IronPort-AV: E=McAfee;i="6800,10657,11905"; a="458778"
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="458778"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 08:52:03 -0700
X-CSE-ConnectionGUID: z3IBfgxhRS6IpLVHKXSDQg==
X-CSE-MsgGUID: 7t6ckqR0RxWxN9Uet+JFYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,103,1787036400"; 
   d="scan'208";a="1774356"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa013.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2026 08:52:02 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 08:52:01 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 16 Sep 2026 08:52:01 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.60) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 16 Sep 2026 08:52:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xt3UwyklUQiFNjP6OH0A3T4C7/SJAJU/88TTRtXZgxsfu24GDYovhdPrt1lHbwz38r2+E36fqb+5dDmLFnTHfm5i43IRyuOmpo2DCkWFuicirM09nO73bUlmYfnSHoipcXyXDr+z/fmWpOq+OuYyj+JvkxlHuYvI2KPcLlbMrDcJ0+hQyWCWjdGdD0v0fR+ZMPTINaPEg1NX0W2YL853jVDhaTJbdEV0vhoMa8/960jrWNL64DIvfhr2DB4nV+zD/JMQZ0O0x4hlP3c1f5XKbXVXg/7dvPdwMO4dc3TP+nEiTB1IDYQcqlj+dYXIlEF7XOhCMHpYFFC2rCST5HdAqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukak1UwFFgoMUSaNDF6XuzLQGGHhgx60eNw7gIb6eJI=;
 b=TM4mqXKxOU1yKyS/NWqOrzncn8yK68NbDwUGV9AItGQO06dZTR8GlIvCl+shOvDCOpav8cgMaz5gSjyzRf6iAkA4maZwAAa55cw98EwXQhNZs7Wh/qVRv77z1Lin4XiJf2S9ouPiE2Uaco7uqla/5A4VdJV2IAoZtwehORR56OlMcUtBtuspmOE0hQWdOI/TNmtIRz2xICPWqydGOVu6xrMQghqjKVrzaCbkM2qV+S0oNs/7loqBwHbumslDsCzwNrmLOTos7zlbxK3sAytvIRy1S2dc8OFHlY1tfg0DUKVfXNylJFizaQJQagredNnKsoKNOblOgQzUlpXbjSjZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SN7PR11MB7468.namprd11.prod.outlook.com (2603:10b6:806:329::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 15:51:57 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0406.007; Wed, 16 Sep 2026
 15:51:57 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] x86/resctrl: Update documented unit for the "activity"
 event
Thread-Topic: [PATCH] x86/resctrl: Update documented unit for the "activity"
 event
Thread-Index: AQHdRUUZST826LRTU0eFqILhQWbeyLbRS7OAgAAO+aA=
Date: Wed, 16 Sep 2026 15:51:57 +0000
Message-ID: <SJ1PR11MB608379318A8C7AF99DF341D9FCB92@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260915190431.18189-1-tony.luck@intel.com>
 <3bf4859f-bba8-4b98-990e-f49124d61412@intel.com>
In-Reply-To: <3bf4859f-bba8-4b98-990e-f49124d61412@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SN7PR11MB7468:EE_
x-ms-office365-filtering-correlation-id: 359fbedd-a7b2-40d7-734f-08df140a706b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|10067099003|4143699003|18002099003|22082099003|56012099006|11063799006|921020|38070700021;
x-microsoft-antispam-message-info: jkP1zngNRFBz25Ddx//HRv1+FekjpA19CewoJ6piFacFHJlgDNANUxa1tcNIYKOKJmsO0N53ifgVJ58ubV2cmwZEce05I1Fik7L/DhVYFT9P4YHcsQNWd01z9lD8SFaVDvEmcjvBa4T3xkAg/J1H2dZEe+rl+JaZ8TIqjF+ovx5EiuGalXJ/FiaOT8p/HMeG2cBN40IoAqznISMy5Plzm0NR0tBBLm27oKIOjvX9kQJ3jQT/ctVanwPj0LnGW0dr7/IWD5JWUGFMBXQxOoS9804lT6FWzinfT53aEX/CCfj0P12djZuq4njRn7+pFL340ToDJwtFrIwXq0jNtmK7xYCxo3gOEyN+sEw8kbEkLDUGFKFw8bNHnoQdnWfs5kyFXwKf4JG8/rEK0mEYT7n6tkG686ys/Gu5ohDe8eXrjaLQ0Pj9xNMMwHzIyXxfFKqXy26hsvuSTGHcW7ogaWgJBH4I6bVyTy9Axjsw7+chCxiO5WRvRbBKBBe+a0KADgAn1iPIb8ii16EoZjEYr7OAKKK5hR6+ZG55L+lmSiv67s37+oYTGfiv0d7yzrIYNovUeThyqFp8Dk7Ty+wKHjG45l1LAaacybZ/E4VWHOMC/xFfbzGLaVouC7+fNa/E+4nHHTlmGAgQNdCr2JrJRDdvFvMOt+n06BBTMfRTHUz2DTTDluNGzV7DZHsKaEnypwrIfFmiQiFThdl2vtjarPncispboncFVsBIufzHWRJDV8IyD9dzrvZj08MFVI2FbzdO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(10067099003)(4143699003)(18002099003)(22082099003)(56012099006)(11063799006)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dHRPcy9kNnBRU01ycEszYldWL2pSc3hYT1gzWGVpMUNzZkdzeldlakNqVVR5?=
 =?utf-8?B?ejI1Rm5VVVhrZHNSTU1iMlZYaklzTFl6UmJzVUE3WGNTYkp3Z0pHSHE4cUFq?=
 =?utf-8?B?Z0tTVjBsOGE5azNGbFFyVFRjWlBzVHJXM2h1V051bEIxcVhzMVpMcXIxS3cw?=
 =?utf-8?B?WUVBM2FpbEgxbGp3Q2xDZDlNclFIYjVtem1sMmE5UENlVEYzNEIxQ3BualI0?=
 =?utf-8?B?dlZReE5ZaUtycXFsZXluNVNIOE9IYi9ORzlyaTdqUjNBV1lUY0cxRmx6Lzl0?=
 =?utf-8?B?cVI5WDBKQ3RKZkFwTlE1cmFRay9SUDVzOXN0Qk9HOWhab0RTYzdJOWNJL0pZ?=
 =?utf-8?B?WTVMOFBQckN3WE1tN1BMUUlQNHpQbjJ4YmNKNWVoNzJpSFVVUFl2aVRybGw4?=
 =?utf-8?B?TGw2ZlMwdFFRRkFoeXBlTzY2bjVTZ281bEdTaHk5ZE10cG5aVXhLL1Fzbk5W?=
 =?utf-8?B?YzducExxWU5YS2lKSHVwRm41K2RqWWpoWTI0ZDUrRkppbCt1MEFhZUxtTGZG?=
 =?utf-8?B?YStaYjIra3ZkeWV0V2o4Y0ttSng3MGVsWnBwUDhHYnovTHZ0UURYcXhSUGNL?=
 =?utf-8?B?aW1yVnlWNkRoNFRqZmIzYVZVOEFwbXZ0dmdqR3ZqMlhETGo4Zkt1MG03TExi?=
 =?utf-8?B?bEx6WmpaaUhLcWJMKzlRbEtZL3NLT2tiRng2amNIZVEveU93Z0RzZ0lpQnhP?=
 =?utf-8?B?WjBvNnk0UmNTcnVYWVVSMzFwR0ZZTGF3UDFQeUtzUTJVZjlISjUxTWlaYVZl?=
 =?utf-8?B?MnAvV1BZNnRiditlRkxTUi91QjhJVU4wdGFucFhzK0ZqZXhDc0E0L3pVRENI?=
 =?utf-8?B?eHV1Z244RXdMYnNtaGhvb1BMQ0JmcU5xanRaczgzOXVpd2NjYnFyKzJ6UlZT?=
 =?utf-8?B?STlXb0V1T0gxMW9CeTFoT3RpUnVaQWZWVEtiVlZyV3pVZEdxYnFJVjdLalJG?=
 =?utf-8?B?N0hlR2RkV0cwNE9WQzNFTlZCZWh3UEJEVU9rdElqNUt0bWtYZHBlOFNtWFUy?=
 =?utf-8?B?WVE4ellnSkdzRW5VQktwNVlHMFRUSS9IZzVIT3ZHQkFxQXZZUUJ3OHBMeEN3?=
 =?utf-8?B?VHBsNENhYkdLaEJGcktzT3Bsd0JTLzJDMEVmTlJsU0xPMXI0UGFXbmx6cHFX?=
 =?utf-8?B?emNBYnJRWXdWZUJMOXV1SU9DTlBqMnExZHlCK2k0Szc5am9OVjZlM3p3VmJs?=
 =?utf-8?B?eTJJdU1UeTgvTG1uVWFtMHBXbGoyVEJmMmM2WENYV2JXeWQrTTRBZEk5Yk5o?=
 =?utf-8?B?TUlFalphdXRTazg4Tkl2TG9TS3M3ckpEcGNlbi9Qb1lTcEtMS1lKTzZCUXFh?=
 =?utf-8?B?RHRlVVdRNFdoRU0vSnhjcjlsMkRWM1BQM1NMUlkvRGgzVHJySEpMWUtkN3RQ?=
 =?utf-8?B?Vkx1aENrREJnbThLbmR2cTVlZXpHY3I0NksydTVuS0U3Q1pOcGpIeGJYeDVj?=
 =?utf-8?B?MFJqbFA0OHlzMmZmTDJHTlJkeWtXc2tRVldubVVHUDF0UEJkWSthSEdGZWMx?=
 =?utf-8?B?QXl6SjUzdllkazlKOXJPTG9LVnJWUFoyUHExLzhtNkpnbHNNWjZhUGZsNHpi?=
 =?utf-8?B?eE1kUmM0UUxmQXVNYkR5QVpicW1hTXBJTDBPQ2xBQXhYb3FkYk0zZUhHdlNx?=
 =?utf-8?B?a2UxOUtCSzFhcjFBblU3SVlmTmVhR2VvSTJpUklxa0dJejVjb1QxRkpXTlpq?=
 =?utf-8?B?UmZ1WnFlR1cwcVhyKzRmZ25GYlNPUVhYTjViNEpOcVRXdWdUM2xXKzNYZ0lM?=
 =?utf-8?B?M2dtODZwMHl0blNvOG5YL3YxbGJpVm01bHdheXp1R3BsUGdCT3lvdGUrRTdn?=
 =?utf-8?B?dW93ZG14eTFRdkJjWXJ4a2lWQlNkOXRtN0NjckI3T0ErUjdIVlIyZ1J1ZEJS?=
 =?utf-8?B?WUdwOEtUV1UwZVpON3B5bTM4YTVmOWhmenZOUTdBekU3SkVCOUFrOEtVejhF?=
 =?utf-8?B?bEZ2OGc3cGhBQWVPRmVhWGNNTUdxT1BFUUVyOTI1NmJDbWFjUDlxSkRITzhY?=
 =?utf-8?B?WGk1UDB4eGZhU1lBRCt3azNVZjlkV1ZKNW9FTnE4TWlHN2g3UVZuMkdLM1Nv?=
 =?utf-8?B?NGRyTUpYNXd5RXo3S0dIcnkyZTUrK0c0Ukxia050ZnNqL1MxN09uQTE5Nm81?=
 =?utf-8?B?WE9SRFhFbWJhUG5xWnc3S1NpZDVtWk51K1E4QkpBQlkxRk4xUWtiUjcxZEJn?=
 =?utf-8?B?ZUdWWkQ5NUo5Z3NqcE1uNG9kR2pXUy9DU3AzWTBLUFJTUWpoU21tYTg1VTBV?=
 =?utf-8?B?dnpRL0V3Z09hMkxFWnZWYmhqQUlDTFFZcVQ0a2NXYzBZbjdGV0x3ZElvSEJp?=
 =?utf-8?Q?vhKbhdOkCT2DkulObN?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: llVQnpKgWB1v1m8PY2BLBib7RuO673tjmqYfnR6qqQ2M6kJ2fVf33wAan1k1NUswyLbK3BVZsTaz7je+xFX1ioLrDP10DgNo8cL2pl+Gp914DbYji11qm4+aO06rmo7pj8OFSvIwwv7n36r/r2G6+5Hc7M4lA+PZ7MPfjFrJP9hRqBV3s2jtBi7Ih9/z7JpKMsLjGI2df+vKaj0PzdJkb+0gGkYJKlkzZdf6OwiUjk8Ix7updMifFNPgufmYcDt2pMGx7+3FX0MIRJd5PPy76D75HUsBZwPNLpLqd4s2eCJ7ah1yjrQ80Z8yjGM57RGxVodIdWDmEr2SZ5dPSrVNMw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 359fbedd-a7b2-40d7-734f-08df140a706b
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Sep 2026 15:51:57.8071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S0kIE9C+rTaS+O1sazeP2jyBeuI6s8S32wUPgnPCZsBpklKMFssIRvs9HSdQQDtJTigb3E4U1xWjNSibAoO1vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7468
X-OriginatorOrg: intel.com

PiA+IFRoZSB1bml0IGZvciB0aGUgQUVUIChBcHBsaWNhdGlvbiBFbmVyZ3kgVGVsZW1ldHJ5KSBh
Y3Rpdml0eSBldmVudFsxXSBpcyBuRiwgbm90IEYuDQo+ID4NCj4gPiBGaXhlczogYTg4NDhjNGI0
M2FkICgieDg2LGZzL3Jlc2N0cmw6IFVwZGF0ZSBkb2N1bWVudGF0aW9uIGZvciB0ZWxlbWV0cnkg
ZXZlbnRzIikNCj4NCj4gU2hvdWxkIHRoaXMgZ28gdG8gc3RhYmxlPw0KDQpQb3NzaWJseS4gVGhv
dWdoIEknbSBub3Qgc3VyZSBpdCB3b3VsZCByZWFsbHkgaGVscCBhbnlvbmUuIEkgZG9uJ3QgZXhw
ZWN0IGFueW9uZSB0byBjaGFuZ2UNCmFueXRoaW5nIGJhc2VkIG9uIHRoZSB1bml0cyBoZXJlLiBB
bnlvbmUgd2hvIHdhcyB1c2luZyAiYWN0aXZpdHkiIHRvIG1vbml0b3IgY2hhbmdlcyBpbg0KcG93
ZXIgY29uc3VtcHRpb24gcmVzdWx0aW5nIGZyb20gY2hhbmdlcyB0byB0aGVpciBjb2RlIHdvdWxk
IGp1c3QgaGF2ZSBjb21wYXJlZCB0aGUNCmJlZm9yZS9hZnRlciB2YWx1ZXMuIEtub3dpbmcgdGhh
dCBib3RoIG51bWJlcnMgYXJlIG5GIHJhdGhlciB0aGFuIEYgd291bGRuJ3QgY2hhbmdlDQphbnl0
aGluZy4NCg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRvbnkgTHVjayA8dG9ueS5sdWNrQGludGVsLmNv
bT4NCj4gPiBMaW5rOiBodHRwczovL2dpdGh1Yi5jb20vaW50ZWwvSW50ZWwtUE1UL2Jsb2IvbWFp
bi94bWwvQ1dGL09PQk1TTS9STUlELUVORVJHWS9jd2ZfY29tbW9uLnhtbCNMOSAjIFsxXQ0KDQot
VG9ueQ0K
