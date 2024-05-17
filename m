Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407053C489
	for <patches@lists.linux.dev>; Fri, 17 May 2024 20:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715979278; cv=fail; b=LgC4d+b/GKSTtbagiyFaPDg3s6zs7gi3S2IOtFPGvtaTcl2gkcIuBBJuDV7v9zkedAtLaC38XvEBC2HoeHtjkAcc4sJDaetFS+VojUiBlIgrgnk0rUqG1hf09t8vAaZOvL7ns3r8A4NVnrZpSKvKRIK6NouPpy/Nqxdf3tyOpJ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715979278; c=relaxed/simple;
	bh=ouotGHYiQTzPM3z9BadtfBPMHowQiO4LCq2cbu6n6to=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S3j/shPnuuWCAL+OnkrdvEG0boYQ0dLIO0KgoFET40raxX3C39vQjfpght+KRBKJbnHaJ5BAfkU+NRe+5CrHD1dUpEyxK+xyue/zbrSjoBA3hYETRbl86DhqpXtE/Ch1GAyl2+zSfbuOn67egPQC/YfhcTpURffzpvZBt7ZYgYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gH/gUzup; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gH/gUzup"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715979277; x=1747515277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ouotGHYiQTzPM3z9BadtfBPMHowQiO4LCq2cbu6n6to=;
  b=gH/gUzup0Tyx2dK0sJCw7y8kdIaRx9YY1D5SHcDuJLi5S/AQ2dcVFka3
   7S4iAeprUdlKgz3SLwdccPY02Ikp5LOhi4AHDMWqMWx8wjJh2ACQ6AxG7
   4ZoiOJ02xPPJQAKQhwvAyTefKI9kUuiiroU9nIpVDRMiQfouAbAH3Cbia
   xuOY60YEILDgoIboW2O08FJlCgUD35XMlWHgnEUf52kNuaRYx5SL40Vwx
   0dVzFRzm/JxzMVn1GOqtaACCf4fWUsaTjbbwz7wkZlD1gKc7mTtyAWqWz
   zRkKcHHcWTim+DN2N2u+FARhdF5y0agnM3S5m0zLr3zNxvT8abQ7oM1nW
   w==;
X-CSE-ConnectionGUID: 7NJ6o1kuRNeL4yzr90nUiw==
X-CSE-MsgGUID: DK0rbK+PScm/Aen+42EYjQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11075"; a="29688335"
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="29688335"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 13:54:36 -0700
X-CSE-ConnectionGUID: 30dAcYSaQx2n4GIk1ijVDA==
X-CSE-MsgGUID: LvyZLV+oSGqK0lv+/BptXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,168,1712646000"; 
   d="scan'208";a="31923308"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 13:54:36 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 13:54:35 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 13:54:35 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 13:54:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxZv65ZVzUtUlxj74Z7JCWdZKcVH5DtQi5jrto+rIiUFMWjoneNQkecZLzzEUkDEFRbkBFryk/ZGjReKWlPAiF2VqVbsZ0qijh48kW8Y9n/wkdxJKUroqGzUpGFW5X/zaY5G1g8dg+HW78FuTtNASVgFZUxJamqwHXZvkkp+EePP4MmiR8VPQw6VygxPSZRRX4OlSfbuuTudsbWx08btUXyrmXMV7QXrQL2ZuIzs21DUZL0nh7GOuLryMxFWsmsNzgoeBrztSCEXqclDRKqJ9GRdGJz5KsrFa9rZT9EBT4iljeQnrNhc/tewNPnWbQg9QBairPLW9sQPrhPe4LHkGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ouotGHYiQTzPM3z9BadtfBPMHowQiO4LCq2cbu6n6to=;
 b=iUntqp2o/qyioL73VjUmIsTwzygouGowkU5Uh7aRs9TuB3PqOb1TFsuKrqXEJvqQWi7a7G7TjGGkiAssqp7TWcvQUgtL2h7OGZCmU/YOJ/Pg3JgO+Q3kjfWtqMVCmWC/ab/lYzymx8zSf2q4fRG0vo7I6S3GUQkg9ZEmGT7Y+c/y8BwuT/TN4mbAulrtCc2Hu2OUW/JVeJ4K2HcTW7OsjJKDcVkpsv5UvFXTlQaS+HFy2WCTvMV+Ea9ljvkeCnv4hiqBgQlA9b35byyK5osDA1e8lkSPEWlkrCTfabuIhVjPFpXw9xyMjUzeJ81695Fr3DM84/JVa/71F8iv4jkt7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7878.namprd11.prod.outlook.com (2603:10b6:8:f6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.30; Fri, 17 May
 2024 20:54:33 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 20:54:33 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
	Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, Uros Bizjak <ubizjak@gmail.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
	<mjguzik@gmail.com>, Thomas Renninger <trenn@suse.de>, Greg Kroah-Hartman
	<gregkh@suse.de>, Andi Kleen <ak@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Topic: [PATCH v2] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Thread-Index: AQHap65BNQUQc7djfEG+qeIcEyvEqbGbgbkAgAAwIoCAADPvgIAAAzOA
Date: Fri, 17 May 2024 20:54:33 +0000
Message-ID: <SJ1PR11MB60835EAF2929D72D9C245ACEFCEE2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20240516162925.79245-1-tony.luck@intel.com>
 <20240517144312.GBZkdtAOuJZCvxhFbJ@fat_crate.local>
 <863D0F06-1217-4C94-B2CA-816FC4ABB103@zytor.com> <87h6ewjhn2.ffs@tglx>
In-Reply-To: <87h6ewjhn2.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7878:EE_
x-ms-office365-filtering-correlation-id: 58f7dc94-6496-4c84-dba0-08dc76b38e27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?us-ascii?Q?GrFTRaOdFa2hwXDkq3XDO61e5tw07m8WLZGYnos5+Q0lOQRq37sdiSvOqlQZ?=
 =?us-ascii?Q?cYZsRgxL/8lZQD0tEK9M+qU5GwtC2SzCJEKW3FY+ab0dbYC/hqPe8pTUgqd7?=
 =?us-ascii?Q?Lu+Rk1vRg5DiL/Qtx5vc3eFaRChkdeLocluZdql0Qj3jaD61WYNLy6uzY3uJ?=
 =?us-ascii?Q?OWwTquPqkwIgxUTrJFP0xOft1Xu3+D1ifpyOr3LRebn0PxPZFmQjTiI/DbBg?=
 =?us-ascii?Q?tabKiksyeQbkw2iXIc6VvhDzqTM/k0teye9SzGjTNeXM6ykjfGE5h1mW50lI?=
 =?us-ascii?Q?JWeSgI83UWvywm6Z9RNVEMvRWQWpuGQ+Mq260T0xULRZhhYmg+9uImFbucDS?=
 =?us-ascii?Q?PkHCCJMvpxLuxO+z+vjd06EZHDfSWvcsVlE7EcV1Wxnsr+1e+z9R4dsFNM0z?=
 =?us-ascii?Q?I9ScLK0uG1eMsM9uBt9emvMOlAdM9x6jo93wrKPuDgRdC5zLn/TbqL/baX4V?=
 =?us-ascii?Q?5da9dGO8jZ8ItXCFc02BkPDRUsr2tGLl99/qtg2Prh5zaKSdvzCgLYIaDIcY?=
 =?us-ascii?Q?OGUKM/nIOYfQwHJlsMoBlqBhBxGES6HtP5RItIAQhBZInlE23n6idHBaWRRr?=
 =?us-ascii?Q?cLl5OAe8KrTv9snb54R0HYsJvU633mvCzbuBoAA0gpQMldH9zbMZjb8LYDbq?=
 =?us-ascii?Q?04/VQHr4L1Dpq4da3ystpKjC7O7SvyCJjPmIMVL9dbawEN6PYRRavP70qJgs?=
 =?us-ascii?Q?p7gfoojTHZsKMD/pMRK5NrsnImDd8Zf34YvTiuZcOWEVEZe9L8xa04BT5np6?=
 =?us-ascii?Q?bo9qncYewxPK215HLjQJj0xMmtIpFwEvMAqkgi96ev/gU+bY0GsGAVYB+JQv?=
 =?us-ascii?Q?4uiHi1Pb9gwhQQrCz2doK89Q0cnKesIFgerSWhxf7LueTAGkvyRkBalsVb6D?=
 =?us-ascii?Q?HzaULuhOYdDPG2I3Ap1Yqhz1m47a2DWE3LoQtEwvp9OYBLFlEXkvPzYeKl/n?=
 =?us-ascii?Q?LGff4rdmjEy6Fo9eE6VdA5EE4HiIuMsKL3bxJsALxsAQv2ZrIbUvUx/nsSAG?=
 =?us-ascii?Q?AY5O6p5sadKACaYogUZ3XxqV+mKnmsFS1jQwmxcXm4h/ppSrMqlKOc3f5J8W?=
 =?us-ascii?Q?n/k0PAYVmWllWOk0Y1gacWBLgSNb4u6iQRMdgMch8140tQbjjfdvmuN9i2Wi?=
 =?us-ascii?Q?20xRJJV8XX97DmqmEZVjUFfjfrLDNhKKTjXAqrf7pVnXVhPMnHv601R9M59G?=
 =?us-ascii?Q?zE29OgLwVL7/ay0ptfQLhWklnyA3hhe/PWdxEGqUui7Y7r3aoDR3C8UON+c8?=
 =?us-ascii?Q?iszuIrUFK0qoXHqdtBw9y+4W2JQyF85hcxn75fTVXTyICbHLx/xmAL8WZGHb?=
 =?us-ascii?Q?5hshwZugzOyJJVZtKQBgvt5pf0mZrrsxqSS2d3xy0TVvDg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VXRsTi00QoFvDMYpQdmTtLxEgBnUMWK8VAi4idQgEvPyuujaF+VBGKvCfWwe?=
 =?us-ascii?Q?EzwDxr/PO9rEuljSK8xir9whLZoY0dyIOA4bZ4qvQv2XHrujl0r6V+XXjUO2?=
 =?us-ascii?Q?6FhB/4d34MoXNvSv3nLoBFpj/bZoSyCuJZUYpjYikeHXvA4d0wvO5J+EfigB?=
 =?us-ascii?Q?U47BJw8MNV+aDsDBd5cyLDQGqLhCFjCCZpfX4RoLXpWiBwSbmJqnFm0nWQQq?=
 =?us-ascii?Q?Tc13gIloHeumZEkFeCP0ViYiveQiOe+eTPzKWAv8/NZn0+RuQWA7ymt0zcd7?=
 =?us-ascii?Q?CtXb2ac5rOGmyr3QO0D4RKABBWJi4h38mqDHnIYeniPMkYubxJE3E3T5AJx1?=
 =?us-ascii?Q?BOweWL9zb6TReeQ1n02RSozRZzJKY2LcAjpPYrDr2iyuivwH/6zqF/7g0CUM?=
 =?us-ascii?Q?NOhiTevE3/bYaroN83w9mFNOgXYOfOmCZ/mTCZ9RtJ/RXVpU40kEkNe9B8Sr?=
 =?us-ascii?Q?lzTlSz8WPUWHeUwlQl2Sc9lcB7HR9O62TqIwHKjfV3QrN3tlq83yfZ0o3re1?=
 =?us-ascii?Q?ViJgkfK2ZoFkCpqYgMzv1LC7Hpn23TsmMj3ryg6nmCwabn+2faaGv/ZBPmTW?=
 =?us-ascii?Q?SwxEPAcbyroNKs72ey3dL/XOXYnIrJigRQmHCCpN740ctr+UzXh7Pmy51oDG?=
 =?us-ascii?Q?hsgM+QI0VuqWy6w0UbuZh0mpfdlmqBC78PCOrqPaGrLWJZSAgBxCgynyEk6L?=
 =?us-ascii?Q?9pgI+cFOFDKzyxGMNMChI84iHa2CqvwYFantYNVEFqBme1q1v1p+EcemdPyv?=
 =?us-ascii?Q?xHB58wMYUGTSwRIkn8wZuDUUzaqvGOTZbNxISeEV+Wo3wNOrKxiq1pGHi8HU?=
 =?us-ascii?Q?tTcTl23G7HJEpL4x9aLfbzW8kmAbLTWNyiTxmQUwW3k1Dv2O8QC9YI2NiPoQ?=
 =?us-ascii?Q?77QW5ImtKA5k2cXpqKF9tlUlMLLQeQSHVk9Uq9AALfWsbd1FqH1Fr4y7N7TZ?=
 =?us-ascii?Q?LTSv7xmvFHtHOf7F24ahbEUK2SRFybZXSDTy0KBTlbWdx9HjdADZrAi5B4IK?=
 =?us-ascii?Q?pito5qVVSTukPQe/QLYGV0q+06W/hrnQZIT9Tj6XcQJN9AB320vusD7ijA19?=
 =?us-ascii?Q?ZmTeq1DWoR1pALs37ssIpPeR/wWlrIoBzkFC4QidY49k5xovCMlBgQVTGmyO?=
 =?us-ascii?Q?Z9u1bGcOmkS+K8XgZUVXzVUaCbO4wuNtuTSJwuAQCzeyw/2V4PrVZbbNXInn?=
 =?us-ascii?Q?x8ySuVzPkVvqI85FUrL6GUaMOflfChcZPSg7jNSNR1MPbcPIiZwvL6ef0dA8?=
 =?us-ascii?Q?0KYHBuAlfx3Ki73vMaIEWbWKc3rOmf2pvChj0iuUSxAKTjjc1AU0PdIwk3J/?=
 =?us-ascii?Q?wKLBr1PXbPPTVvA34lllqVdj2iJ9kCEeMQGD5Ee4+9d7HWXQw2uDgtmU5k0j?=
 =?us-ascii?Q?jKEyfjgc2rD+FuZ/4Mgc0CztNTPzJmic8+s9//Ex51TFDGaDmO3YDRrte1cx?=
 =?us-ascii?Q?RzfbZ3prn7b1XfvMLItn4772iHpujraQXTDpCjsVSYU2AYpi1lMCmGGxhcjM?=
 =?us-ascii?Q?e+ZmVMzdDbutBcOIIuDjbcl7hViS5sPacUQak/YjG507n9hgI6wtOLmz9Lok?=
 =?us-ascii?Q?tfnKqc783S/lLrcFD7eaxqC1S5p3IvDrhihpaYsJ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f7dc94-6496-4c84-dba0-08dc76b38e27
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2024 20:54:33.5526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d8zG+cJ7uts7vy48d6brOYyDph+NenukgWugDfLbfgw9n8CcbPYB8ec57HVVFVvjEo09q2lqf7nS0wAZ/drbvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7878
X-OriginatorOrg: intel.com

>> This is particularly pathetic as there already is a canonical string
>> representation of the vendor ID!
>
> I agree, but that train has left the station long ago,

Is that "GenuineIntel" and "AuthenticAMD"? While canonical, 96-bit values s=
eem less
easy to use than simple small integers.

-Tony
