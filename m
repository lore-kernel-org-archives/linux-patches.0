Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41041A0B15
	for <patches@lists.linux.dev>; Tue, 18 Nov 2025 23:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763507544; cv=fail; b=ZUQoHUzJ0U2iTT5WhFVE8OdhrTpotU0iEENqYoigP6+Sbu8QCbhvIpRhfIp7yZ070dpEp17wpgj/BudK96u5xE5UoNKLPx6PftjB3kZosNzzdTWyZ+nFMbq3FGnZIawQJIr8KA28Bde5gX0Hz9ihL1ddTtmZbvldxHR87XP8mNs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763507544; c=relaxed/simple;
	bh=X1Zp0s/vcqVf3moHbELMuP21YPC/AufZlwx7TSCo5nQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sc3UBeI4gOnnUXozR9A8iyTntGZaY0QMSIeNnUBPT8cOBZG7FgMnQ/HbrbXywnx/0ciwLqVgoc9PBBif8tw6CsQ8IWecOECO/wkuC74cEQr8O3tTOLLgubV8/y+p6dmPfnebl6VVmfs0Ae16KX4O/y4br1WhNbAnk98d9ARZ4FM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GLYxdaIE; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GLYxdaIE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763507542; x=1795043542;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=X1Zp0s/vcqVf3moHbELMuP21YPC/AufZlwx7TSCo5nQ=;
  b=GLYxdaIE23T9SKgcFl+f9eSaN5lWrep4UQJW+hqXN4uwR5rfJDNAebcd
   v8STKReDJWKrzm+Kkh5fy9PN2AefcohxBZEQmX1qqm7+ETsGOStKHvZ0c
   6YEYX8ajwlV0uNRqpNr+c0TMWjChcnSqDg8YoFeHxAs/RoVW0JkHX7M77
   uPtzmHbhu1Ky+2V+KR9zTjhSWPvG5KxfWnyRZrgysAL/uSMkBabGfCPlM
   JYdsr1LSvcYVKBN8TD6ERu00QwyDmPXM4UoCEIjFteCwHFgUgZGT7kfo4
   TvY4IVgg8Se7Q3iUZ+CyFkgmoqeuhfONpkfNvp6iOeVMLIha3ZK1bTM/U
   A==;
X-CSE-ConnectionGUID: 0rmTUDySTCaRytmyxF7BoQ==
X-CSE-MsgGUID: hQVLSFViQx2gu4iAYLYkWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11617"; a="91018101"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="91018101"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 15:12:22 -0800
X-CSE-ConnectionGUID: pHZSEaXZTJKyA6AmLq+O+g==
X-CSE-MsgGUID: F2g8Zyd3TV2saskio2fo1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190164627"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 15:12:22 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 15:12:21 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 18 Nov 2025 15:12:21 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.41) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 18 Nov 2025 15:12:21 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+lCKXtUwRjBowNm14o0lgwAYxSAyiB8K6gjQlNRkaZhMve95ZhV9IKb5D/PuJxpmtKOAMI7c4xBIrgOuwERZG8Mqb0/e5biedbU9f/H2jwl17X/tNmB8t7R4PZnzWwUTSZfIp8kVFH8igWReVtLaCoCa2u2AK5an4Tf39nimlXPF9ulUVzWAsuLEUvYUrUBtLYe58Jv6aqWU7Mi5h/oU/r6aOdA+oilnogy/Sm1h4DUr25on6oIkEE/AhpN3SDyUx+0rbgkdZpiN0/gPiWUSpBTXz7rAaGNfKwf09HhxmbTRThmQEiroI9c80dmMGX0YNhZstke66UtRV6zmBm64Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X1Zp0s/vcqVf3moHbELMuP21YPC/AufZlwx7TSCo5nQ=;
 b=qJ56cHxbrDg4FRHdd1WOMlb/JilJkd5TTk6eO1TBRiNJsL8x/weQrulMG6eRFRfJAFDPaZ0/B58fMV6MeR7lWsqZMDq88Cfm/g5c3JQ2mg77MeNp8v0pYy7DZfbGtn39Fm/XAstuM355zoHjob5pjwODE9sqm8oVKcNE+mR2wRsoZafjhhV7Ff5ThQrIahjPSy/P0or90aqydEOKCVE5Cfg7savgijaEi+fUgWAN7dpPAdCeIXvY8X+QVdj5YFIE/Q0dcDKPFdnSSi0lUjxorEnFfViClk1r8HeppD6p78kSGGh6HNcUX/4gJaos8Lyfgobn7Io7BsX2J9lAzn9Qeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH3PR11MB7348.namprd11.prod.outlook.com (2603:10b6:610:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 23:12:18 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%7]) with mapi id 15.20.9343.009; Tue, 18 Nov 2025
 23:12:17 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Drew Fustini <fustini@kernel.org>
CC: Drew Fustini <pdp7pdp7@gmail.com>, Fenghua Yu <fenghuay@nvidia.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v13 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcSPAYySEZmJcLb0uXaCTwnPhdjbT1rNKAgAGE+WCAAfuQAIAAAYwg
Date: Tue, 18 Nov 2025 23:12:17 +0000
Message-ID: <SJ1PR11MB60834DA9A58E911044679909FCD6A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251029162118.40604-1-tony.luck@intel.com> <aRoLSz6or2UK4tDu@x1>
 <SJ1PR11MB6083B1C8D6D9EF5B44AFE2DCFCC9A@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <aRz7XF1ikjcA89Rx@x1>
In-Reply-To: <aRz7XF1ikjcA89Rx@x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CH3PR11MB7348:EE_
x-ms-office365-filtering-correlation-id: 89188528-71e9-4782-5463-08de26f7eb33
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?U4NJjl9Erv5E2foH+bTMENCNaBni36jS1v3iD56Hk/eJAcqz/9j+lmzppMhq?=
 =?us-ascii?Q?ZWLC4QOooMBZ7oD3Hiqg064IAByqWsZJxsB97rWx8Tcb2MrUGbczhuj4wjuj?=
 =?us-ascii?Q?mHyLHT07TQB0qSxVeJ9HS9B6dO/E1pacQas81aoZYf1wX4eOopg8x26NWDT6?=
 =?us-ascii?Q?yksKgNLjmrZ40mdOqbOEJZHpgeyqUMRUtusyMpOW8eYy9Y5/U1l8aMJzaXXm?=
 =?us-ascii?Q?6t38m2fnVCQANfNqd2g4C9NFD/igv4a+1zbcKLEHaVua68KxZkIo+di2Ryqk?=
 =?us-ascii?Q?KJlo8EA+uLpd4mM//ReP63fiaDmH5+RzLdFXhXQy06TE/81sChmnV50ZKCeP?=
 =?us-ascii?Q?RyVXfGfF/XAdw5vC1UjFHHUIYahOznY5eHafVbrAVA6F0RImFKcu5y0ohQkG?=
 =?us-ascii?Q?U1RCMbrLfHkQgTzWM682p/VbyM987lJ2lENeiAOw9r3zXUyudBIyjHTvct0A?=
 =?us-ascii?Q?Jej+pi080RB0uxnYaV5bl0/BVVbZt4x4Q4Vu8vWaqOi59AfBSJzALg6PxeKx?=
 =?us-ascii?Q?YrmE2G6q8lmrNZaC/LntUtjGbvZXtfz6cEeXKr+4qeAjvmCIYs+x5y345NAt?=
 =?us-ascii?Q?qJvATvCtbTvsgRlTat21yVWf/hEw9e0SLSXaoyC5i2wM68gxCp4ryD0osB8U?=
 =?us-ascii?Q?eEd10WpLYKQlHcVOlzv3GbyPvVY+k7gBmyE3nxQCaobDBQOlMbDPpWtacHFb?=
 =?us-ascii?Q?eo7h6GfRe4ToD6Yo38xelkKUIN0iNdXzn1FNy27dUkOzXVAlkpAkTIb1LquL?=
 =?us-ascii?Q?i6gHinm2FKIKISaAbIJxKyRUC9UtQP/URGzW/hiYWq/PTzPvvit/RAW0kiOt?=
 =?us-ascii?Q?4JAy4ZqvomDoCwCD8y98NTVbLu/21RemqSAJkSILX55YfVF/ejlVus6TnVGr?=
 =?us-ascii?Q?1C8W+A5SN01J548QZCJKL/vDFHv7/jM+wS0tsCUAMt6UiZOkfP6PM7YMne+s?=
 =?us-ascii?Q?YDgEfRvyixuYgfd5a1oTPJGxuwcIq9bXRy0vpCvuZiLb+D8kLO3JY93PoeXx?=
 =?us-ascii?Q?+BvLhvC+wceAFwk+X0FYyzxZ8A4Sptn2Coj2BJz9uNLx/gzvrTvFUd/i5NV1?=
 =?us-ascii?Q?WnX88CPS4fYuPfhWU12wNfSazGDHmNRM1j6bCiNKLH2Q3zE8TN/EPh5Ba0iW?=
 =?us-ascii?Q?F4PyCP3GwlO3aD3vDJKbBE+HBGFDhwx/jL0LZ7pElukbVt/cpzLBRa13lXuP?=
 =?us-ascii?Q?X7+paFu8KTgLIhz0ae8NTTXNqIR2FhqBXu1Sqh/oHwxYQXg4ttQofVLDdvlO?=
 =?us-ascii?Q?fLGBgyQBwpRkJsAZWSopxB+V8KjnEQKyPdDPEONdfuDTE6/IcFyxVJKzizzW?=
 =?us-ascii?Q?ZkomT5bQGfbiTO19uWWGr5tRzn68LEV98rqge3aXiFEgVveUi+6nbRLRohnC?=
 =?us-ascii?Q?tqon+r468+EAgv5NWSaOyJpaZPSfn7Fo6auF/V6MC171JrGhj8qmZZWekpzk?=
 =?us-ascii?Q?QC6kusm472aqGYdMU17f6jv12sLex1CYLURsl8DJ6ub+L/asAfavRwhwzSzE?=
 =?us-ascii?Q?OJfDGq6jl4SzL63AkO4Sj/JbcQslahMe2mGA?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?aXEIuFcf/T32+h1WiB8D8Nq7x+vRNBj/Dpt9xu7mLpMypXplr3bKxahutk8a?=
 =?us-ascii?Q?vrPp/fG/8j2gyKF5Nm+6eBQOX0iShC/chXy3ks5bbs0mXR+yj3ZLzTkZnht9?=
 =?us-ascii?Q?zKM/GyTIYweOoXSLXXF+roMARvyNG3aYrjL7bzNZ/bVX++l8dF/0lH8g/+jx?=
 =?us-ascii?Q?zkFkhk0qfMqsAHkMJ5Rf1JXuboQZmTR+xoLWAy4Nr3CH+/576jNaNVqQp55Q?=
 =?us-ascii?Q?qYz8p11Pns/4yv+J0iVthaL3xbzRNFUW8ddqdUrvwatbT/cb50Fl3xtjhfl+?=
 =?us-ascii?Q?spC9367DQi4Xrm4NQb9DqpL9SgtJ9+Z4iuMy3r675ciQImFA6oe5T2sMSW8D?=
 =?us-ascii?Q?I6w6d8LEVJwZJyZ9ueHQ3iawHIyAoVwCMIjzH/RaGhNKmBkoljMhFTTRSTTC?=
 =?us-ascii?Q?j6Xq09iAcLX1QcVTbomJXzZMMP/b8CpdIiytpd5KDE7gJojKpD7QOna9BrcH?=
 =?us-ascii?Q?2tM1Mp0KVFaatYhmXaqYkm0iRK56dTx2fRkYeU9/cnYZGkJ2s1InvkqfUTwL?=
 =?us-ascii?Q?xh/JGoAaz/ss1E7WczBUPHaT5yjise5eERYivfbhw6KrtrJFiVoG4UGaEiQ0?=
 =?us-ascii?Q?Dhi/DQBkePhkGZwFKChXr/Aj/xA15gMXQ61wZGIVMzm1s6VCaCQGV49EkdNA?=
 =?us-ascii?Q?AJ9ZbK40zhgHPtKvoVYGbNnI4MEt/GkFYa5BXeWCgf6D1pEkXpRctY67rGVb?=
 =?us-ascii?Q?6OUD0tZj3KWhFJLuFeO/5f9nUjLFu64cToiG6Bl1MOhRSafMltOub/pUHhUJ?=
 =?us-ascii?Q?uoMRONCfSPcH6e8+CFbJtPdoVV43+tzyfF5Ewcp+bUenG9M15wrK/7KgLn7p?=
 =?us-ascii?Q?VF8n+4cps6dRYaufep1QP73U+M9ucO0QfIyBWrRQ7OcJCUR96qdgrgXl8Jyd?=
 =?us-ascii?Q?8uHLNfJE76QlZkUXekVHbklASWt75w7bXlJlXCRL4n5JmyZ7an8OqOzLEQVc?=
 =?us-ascii?Q?K6PGV2CfzzuIiBPc7ELcXxUEZ7Qy+Bka49j1ok5n7gHOqWNLCUO03OcjtaRG?=
 =?us-ascii?Q?xoSxfqUxSh8mMQgZbpIcodFh8K9a17zL0h06ogk7GbMgVgMMDsqF/MIRRWTT?=
 =?us-ascii?Q?v0t13Wg6lgAWYvrXRNG+jJ8oALimUmJLlYJ1BLt05xKzeQAQliq3d6M4ALfu?=
 =?us-ascii?Q?rgXOiGErJgDPAn6m1j765CAmOvjdYRUAfC6PIqUw7H90gXQeDC24S4TdjXqa?=
 =?us-ascii?Q?aC2aNEc+e6fLb9/fbLLptHUm2nk/E7mdTW6PvkkApvMQT6OBDrbcwU9fWQhz?=
 =?us-ascii?Q?6uWzOqfZnTiPEh4lhkJ7WdDxxDjq9Hu+MaZrNhEHNRXeMwlrDSrztM11fJVR?=
 =?us-ascii?Q?23VxlVgWXQxH4gN/M+kiRVMSWoLQ5rCrvoH6M82dDhevA738I3rGEgk5dgCP?=
 =?us-ascii?Q?JSGNXpGVAh/u27Lxi6M/fpsHtD2fRCB2w7WC4w2cNlEZ/9J+hOj+NoCGR7e8?=
 =?us-ascii?Q?8jwOu+EJQM4K0C8yMSogj+gmdaFufoG0Gvwqz/smctwNAbOrYPG/NWHHMBgG?=
 =?us-ascii?Q?07OnkuXrZFCAKsoJq6R7XA9XyXLtreg9smAV6kLbA/OxvTSQkkyY/AaOFYfL?=
 =?us-ascii?Q?TaeQM9FxhbtokarXOLx+oiuPTBj724MAkDwMSkGz?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 89188528-71e9-4782-5463-08de26f7eb33
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2025 23:12:17.7788
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jWDoLFJtdo2TmAMIGa75Vo34ptWlX5XQiydZ8avaeS0NhtowaNE4sgDAxEGJRxROWggme5hjFKX6ecP8jOX8eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7348
X-OriginatorOrg: intel.com

> Thanks for letting me know. Do you know what Xeon parts I should look
> for if I want to try out the SNC support?

Drew

Granite Rapids (a.k.a. "Intel(R) Xeon(R) 6" (with P-cores ... there's also =
a Xeon 6 with E-cores called Sierra Forest)

-Tony
