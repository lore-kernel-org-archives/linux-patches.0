Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E581D54EE
	for <patches@lists.linux.dev>; Fri, 15 Nov 2024 16:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689995; cv=fail; b=QtysIq3b3soX3Yso5tt/z/jE4/JR4US6AOJzxkFL7j0LAYKEbgH3PVoUUop/gFefoIikn3SmjH237UldTyCQnL57XgrFlj3k98pc5huBI0rh7UDotDxMt88Rbfny5ujdGhI6BRQ3fjWwhjmH7+aev2GIBYu0619hN9xMquD5hPE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689995; c=relaxed/simple;
	bh=Mts4MR1PQsVcxud4POPKar/j5Jt2ohMV5EaYJ6N1hAY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mPKUlc9xIkJWdNCLFXof+9lqm451EYKWVYAEYln5VU0f1ZDVcheYF+Z2Jmv+VjGIyliXm6m+05qtM3eEHN8ZG+7fBPb22qrtFs2d/LggEr0UAlaOBAhwn25O/TJ7ve2C1bV35J05bFx9jhAd9uNnonRuZ6FAYUwJcAMex+EDvUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TRWOx8i7; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TRWOx8i7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731689993; x=1763225993;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Mts4MR1PQsVcxud4POPKar/j5Jt2ohMV5EaYJ6N1hAY=;
  b=TRWOx8i7YvjK7iqTRpo//YbKdeUC3PGuNkq+JEAuqhq0YP6LiNSp20w3
   UVUxiIr9U1WvmhbWYKJ+gIoOr/wOCTFcxepYNomfdb+aiE9Tns90ClicK
   ENQ3hH5h87+sqvGedqhRVXM9PqteChsv672C0whjt692pfamkpQudgA1W
   ntV0S2FTHo3Bge3kmuAPY0mSFDkxRoF1+PaYXxlBLvG49OQ+bVStLEIQY
   PWgn06JOIcg5BteBouTYZFRTwMcmTM1yP6EttrDbM56d9xmuw2uvZ7oSq
   994pxwEB63l5vMUXNTVJ9AOfShDZNKq6SSq2X7S9kceJ4AG8vYhLvLbZA
   Q==;
X-CSE-ConnectionGUID: bqOiHzLrQdyik6e78FBcoA==
X-CSE-MsgGUID: 37DNc6qQTJCL3xorJb+Q4Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11257"; a="42237537"
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="42237537"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 08:59:52 -0800
X-CSE-ConnectionGUID: Uc72OD0DSa+HlvjbMHJz3w==
X-CSE-MsgGUID: j1Hy1R/3QXqEv6lnhGVlRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,157,1728975600"; 
   d="scan'208";a="89022465"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 08:59:52 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 08:59:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 08:59:51 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 08:59:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PrQ/GuraA3ZjMSWZvkVaG353MX10pcv73aJFx48StXDmuKhnC2vcdeOXhMLzne1Yrh5i/qm+OIxVVUjNvFmLqrwsaCYIbxj5J1ZYG6Svte+haICZ2aSkDbcwlobaBRRxgm6YZwkFWebS1XSNFuub/Cej7EBmAcfk8OhTLJKPV/3MxemU9GdZ2bQ4G4vdmYiVMouo70k/DCMQWn5pORJBu2U4vTa+BLJ+p/E6N74fpwTfW0T/8oOk5MO+Cfc4xKHANvHCShN3c0xqXlY7Np35enL9q+YyTPl5I/9/neJyOTaRNaf9V+D+A3pxtzq9oya39K+cGPMwLPwDBueVAKi+0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mts4MR1PQsVcxud4POPKar/j5Jt2ohMV5EaYJ6N1hAY=;
 b=YnCSKjplcON76TRHjED+hD603dsHiOB5OTRtsIW2bNXSGAnCReSu+REEVD4xOjnPp7WITaJ4IrLl3UoGfdaYInfBuX7T9avGiXhsAkOXp9y/9iNvweqoybXplz0p2hSZbPvM01af7qVCS4yj+CUkQGl3J6c3cx9WoF4DkvR9rSyRKzFM500pmBh4JitM0YrucxOntzUnAlG55hFAFIqwlJYWLbu8a8hiiuqJkS+jCyUwlNfBSsVt9watnRH0bEjnlczFlFI3BB41qvNbvc8Ll0ODHra7x7JP6fjZzwLXncZRmJTMm6GKPLe0agyVfoZdKTnyu0D8/vtbNM1DHg6JAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SA0PR11MB4637.namprd11.prod.outlook.com (2603:10b6:806:97::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.18; Fri, 15 Nov
 2024 16:59:48 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%3]) with mapi id 15.20.8158.013; Fri, 15 Nov 2024
 16:59:48 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Peter Newman <peternewman@google.com>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, Jonathan Corbet <corbet@lwn.net>,
	"x86@kernel.org" <x86@kernel.org>, James Morse <james.morse@arm.com>, "Jamie
 Iles" <quic_jiles@quicinc.com>, Babu Moger <babu.moger@amd.com>, Randy Dunlap
	<rdunlap@infradead.org>, "Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v9 4/9] x86/resctrl: Compute memory bandwidth for all
 supported events
Thread-Topic: [PATCH v9 4/9] x86/resctrl: Compute memory bandwidth for all
 supported events
Thread-Index: AQHbNiqk7zoJj7XLw0SAJI47mv0GT7K4XzSAgAAvC8A=
Date: Fri, 15 Nov 2024 16:59:47 +0000
Message-ID: <SJ1PR11MB60833AE650A03028470CAA86FC242@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241114001712.80315-1-tony.luck@intel.com>
 <20241114001712.80315-5-tony.luck@intel.com>
 <CALPaoCgFRFgQqG00Uc0GhMHK47bsbtFw6Bxy5O9A_HeYmGa5sA@mail.gmail.com>
In-Reply-To: <CALPaoCgFRFgQqG00Uc0GhMHK47bsbtFw6Bxy5O9A_HeYmGa5sA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SA0PR11MB4637:EE_
x-ms-office365-filtering-correlation-id: 735b97f6-6feb-41bc-75b5-08dd0596e9ae
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Tm0rQW5MZDh4T3ZOdXp3QWdqV0xGYUkxSHMwR0FDTElBSisyeDBtb3QyT0dD?=
 =?utf-8?B?THA3ZkVBRjQ0LzloTjgxRXRtQWZBZTZiRVJBQXh1bHV5bzh6WUtOK2IrWFB3?=
 =?utf-8?B?alNGU1ZoaG1nV3JTSGEzdjRxRENiL3F0Y0ZoSU9HWDYzQWtCS2xJZ0VScFdk?=
 =?utf-8?B?WjN0V2pTSXJGT21qUEdKQ1FYZVhLdnpjcTc5MWdabzZhdWpOelNGdmdEcitk?=
 =?utf-8?B?d0ZIY1I4RFE2S0x0a2NkSjZvUDUvOXlFQk5wRXpzUVdCSnBxcnVhc0JtRW9Z?=
 =?utf-8?B?UnZ4QlhVN3VmWGNBWDAxaG16eGJnMEozZkxSR2VXNTFzdlgyVEZGRytqVVdi?=
 =?utf-8?B?MjhEWDRodjdNbXlVTi9NdWdlT1Q1eWs0ZUk5NDAvS0dsWmFIcHNhUGIxWjY5?=
 =?utf-8?B?VFZiRXgwN0dvT0FrVW1valNCNWpXa2Jtd1FXaFloY0dmL1BZL0hUalpYUkp5?=
 =?utf-8?B?OFlVbnJVb2R5czdOWGE1NDFkL0tBckFIb3VLZFgxSGZ4U2hnRTBhRmk0VjhQ?=
 =?utf-8?B?VHlpRW9QY0ErL0JKVXBZbkdNWXhXWmRZRGNmcU9nc01VWnhFa0dyWlltMUEw?=
 =?utf-8?B?c3dZV2hpRkQ3SXQ0cEJ1SWY5KzNIWEhDSWpDTXVBZ1RtU2FkbW9CT2YvVGJL?=
 =?utf-8?B?emx0d1VSVms3aEFuVWhHYjh3S1FSMk1jTHBjazcwMUpueVZlTjkzYW9LVXcr?=
 =?utf-8?B?ZVZ0N0NrOUUxWms5bnJsOXpyN0FTcUZWYnFZMVorSkUzQTNSekh0ME9kZ0o3?=
 =?utf-8?B?V085ZzhvZHFtU0o0b1pvd0s2ZlI1S2ZZb053aUdFL3FReDQvdW52MWVhNFBK?=
 =?utf-8?B?VFAyUXEyU0IwVXBzNTRlQnFvZ2NIbVorcU1EM2JhRE4rb0lVZ0UzSW1EYXl4?=
 =?utf-8?B?Q0F1UnBVbGNWcjhNTk13VGdaVzlOeWNzQ21jQ283dUhleXhPSituVUVMbWtG?=
 =?utf-8?B?Z1NyVjdkR2pSNmVKWkFUdEJsc2l0TlJkMG9wMVdCMml2Y0dYNm9NaDBhQUpE?=
 =?utf-8?B?dUNLZlVlRnJ5MS9XZ0REekNuQjRXTERxdmdoRGRqLzgraURXMWkxblBJUVBr?=
 =?utf-8?B?UnErTHU5emxZTEtOVVgrek5zVzlXZ3FrTDVzdm5hU3p3MGNxek1tdlkwZjRy?=
 =?utf-8?B?elNLRlNBRDhFendSOEFLUTA0OXpncnpqbEkxSFlXVUlLSXMyL25HcEhuWk9u?=
 =?utf-8?B?TTR5eW9ydTV1U3pHTmVIRmtGRURGU3BscGlyc2VranFxbGFGc3F3Qmh4amQz?=
 =?utf-8?B?QUhBQmkzQ2RlTGxlODkzZUwxK0F4eFBtVW9PRWhUVnFFV0pvZGhCZGV6cGM3?=
 =?utf-8?B?aU1hK0EyZTMxRW9Za0s5RExVTDNvcWNIT3QrVVdMWEZrSUJrUUZNdHFrVWRs?=
 =?utf-8?B?SWhPSk5od0R1NGFVZ0ZhWmFhOFF6Sld6Z3V3UG5IdmQxRGRrb3VBZUhzSUtL?=
 =?utf-8?B?d1Z6Uk5rK3FKL2p4R1lZczRydFpuUXZZV0x3SlJNbTZrWXVmYkdtZ3VZbGlt?=
 =?utf-8?B?cnBMdlJ6SkFnTCtCTEl4b0tUTS9Ydk9Ca212M3J4MEN4Mk4xN0IzMWt3Q25v?=
 =?utf-8?B?OTBWdUMxMVJ6R3M3cjRyZ09JNUhVUjI5bHlEUzBNMTZpOGpZcmVxWHpXR2x4?=
 =?utf-8?B?dU8va3ozLzRpbisxWkxOQnMrV2ZLSHVsWVBJMmhGWVoxRGVlbkxWYzB5MUZ2?=
 =?utf-8?B?TlRFUW5pazB1U0l4cEdzVk5ZeSticjRQM2UreDdzY0Q4ZVVsZ1NKdVQrQ1RU?=
 =?utf-8?B?YmdyV0xsWjBtSHNici8zVzk4anRSTS9tUHl5dFJNM043eHlPZVBwL3M0OXR6?=
 =?utf-8?Q?k1B8Zkftz2P0g5uamD/1t56dfxWcumY+b06hA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y21uTmVPOG9iUnZmd1dJMUNzZHpDTnV0a3FRQS9XNjdUZHA2dVpSbjQwcHU4?=
 =?utf-8?B?SXdBUzZUMFROUWhQZGNBQis5bStBN0hmWEYxcmt2aktBRGZ2aXpaNVErMFc5?=
 =?utf-8?B?SFp0bzFnMHJYYXhTQjJiQ3F5a0krbkpTZmI4MkRiTXh6bitxRjQ3M3B0MTND?=
 =?utf-8?B?eW1mTmFGWTRaa1AvVUYwK1FRMlRkdGg4SWdZakVzUFVrU3NxMHVsV252Vm5Z?=
 =?utf-8?B?aWdhNitoSjg1VGppYk90dUtUK0ZsTko1STZpYjNRZndwY1ZoK0I4ZUtrVHY2?=
 =?utf-8?B?emNwdThtY1RJcHdYUTFwaERpL283bXJmVUpoSENDU0Q1RUZzUXdYNy9EUVd1?=
 =?utf-8?B?V3hZblZLZDNsejl6UzBFZ2lVaWhLNHVSZmVubFAzYXk1M2NhRTBwemVZU3Jh?=
 =?utf-8?B?RHZpZ2pjQ0VJMXBudEVoNDZsRU1NR1RGT2dMNzNORXVtS3BGdDM4YWhhMm5G?=
 =?utf-8?B?b2pNMDN5OUl5VzcycFF5YjVtMTNRMXd5RXZVQXVNdHptQ0V4WnhlTUdPLzA1?=
 =?utf-8?B?c29kbHdDQWlFSVpMRnhWSE83YmFZMUpBVjB2VXdVY2NzRVFSQ0VlRVNGWkY1?=
 =?utf-8?B?QUdIUVI5ODcyaktDdGZiUzEwOTRIMGxTZld4ZU1YcTZUbmVDaTlpbGJzYXcx?=
 =?utf-8?B?eTFRRmY4VVNna1hjNTVRb0ZxTS9FdEZRT0Q1YU4zK2VYS0hhdnZIdituWXJ5?=
 =?utf-8?B?Szc0RHFZN3o5WHpnVDFCYjdQdG1QVy84WUJHbkhGTEd4clo0NVIxNEFCVGN2?=
 =?utf-8?B?R1p5aVhka1RNdnZ3aFJkcEx3SllNODVob0pHcFk1N2s0YlFnVUhYdWd4RDEz?=
 =?utf-8?B?NGNrdWlVajQ2MzJVK0lHemRTcEJ5UjdLR0R0TTcwdDNoNkd0SDVrVC85TklM?=
 =?utf-8?B?UElZam1UV3JwYmh3cWZFRE5BckRFVUhxTStWMGY3NTN5WVFycGNRZGlBZXo2?=
 =?utf-8?B?aG5FQVJ4bnZJY1pZVWlxYWRJTHVReWJhdS9HUWJwSnowMXZMQXdNUXFXakJv?=
 =?utf-8?B?ZlJTRllvc2xHSzdHSFpuMFg4Q3lXUnZJQXJtaER4aUZYclZEUXNoYjFTM1RN?=
 =?utf-8?B?SVMzTHhoUGRVcVZ1V3g5Vmx2cXZoajlXeGlBSVNqVW9LU3R4VDB4OEw2Tm1U?=
 =?utf-8?B?Z25ZbjgvYTJLdEFlSTNQaDQvRDFFL2p1RVZ1b0tncFNnaEt2SU9mLzRxMDB3?=
 =?utf-8?B?QU8wdGtIN2ZwNjNoVGhGSmJHRXptcWpDKzdsTWhzNXhKVm1vcEl5ZkJEZCsv?=
 =?utf-8?B?WFdoVHpWc2J5aVBzb3d2b0JVb1dPeXFXS3Nxb3I1M1dIUjc0VmtFYm0yVWl4?=
 =?utf-8?B?ZWJaaWY5WVJuOEpaZWdJbE81amhZV1hTckFDUGRXSU41SnlYVUtPbTEvR0tV?=
 =?utf-8?B?U1ByeVJLYS9WaWJDaGxLbGVTRGtYS2tSd1lQbkk5TU9haVdGNm4wamdqRkkr?=
 =?utf-8?B?dk9hVjVNUFVsV3JoNTFxMjlRQUM3ZFhPVkwydjEyaFpFTmR2ZVMrSzZvcXlS?=
 =?utf-8?B?YktvRDlrWkZVK0dxT3NoQ1FVOURUUHRTMGI4NTYvR1VERmRRSHhxNU54SDRT?=
 =?utf-8?B?NnVWb0M3UFVKMXk3VEtITlQyV2N3OTROaFJVaG5jV0o1VFoycVNYUXJDQlRD?=
 =?utf-8?B?Yllya3dzZmgvemZqSFhMZTNzT2NsQzc1T3RSYmR3VWFkb1pXYjN4cnNYWEF1?=
 =?utf-8?B?T2RjUDhwNWpOc05WRlQ3alE3Y2ZBK1Z1V0xsV2RXSUdNUGpvNWRocW9wNE8z?=
 =?utf-8?B?eDBrNEZydGJVcmM0TWt1cUVoM205M21kOXBTM0xiOWhtbWkrWGpmaXRaMERk?=
 =?utf-8?B?U1E2L1Y1VUNYeHdnV0NvYVFuQWpmUjE5MEUreDVLczk1Vm1KdStwcS9YK3hM?=
 =?utf-8?B?dWtEcVUzTVc2UHYrOHlGMmJrbXlLd2FCN0N1V1FDVEgvSU9vajdzRFd3TXJx?=
 =?utf-8?B?MHMwcWQxNi92cUlIeE1LZjhzYVZOZUtqT0FvZkhTNEVyQ0pGdXJtSTRLOUc4?=
 =?utf-8?B?VkJURENHcE5saTB3NEMvRk5LYU9zUzNzeERUcjJCUzdOZERRRTFaME5meHd0?=
 =?utf-8?B?MWhqdys0YnR3b0dsZDkvZGpobkpMWDZCMG1Hcld1ZGptWkpLdEdKV1pUell5?=
 =?utf-8?Q?5cEbOdour3bfmNN/CELR+fBpH?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 735b97f6-6feb-41bc-75b5-08dd0596e9ae
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 16:59:47.9636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yje/ei1qoRezeRQgOV9olPUHfSRFE5KwQdu8BDSrRH395fX6HFYLixKNosbzEEJ4juhH3Rpu2B1QS7v0mfSzrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4637
X-OriginatorOrg: intel.com

PiBJIGV4cGVyaW1lbnRlZCB3aXRoIGFsbC1ncm91cHMsIHBlci1kb21haW4gY291bnRlciBhZ2dy
ZWdhdGlvbiBmaWxlcw0KPiBwcm90b3R5cGUgdXNpbmcgdGhpcyBjaGFuZ2UgYXMgYSBzdGFydGlu
ZyBwb2ludC4NCj4NCj4gSSdtIGhhcHB5IHRvIHJlcG9ydCB0aGF0IHRoZSB2YWx1ZXMgcmVwb3J0
ZWQgbG9va2VkIGZhaXJseSByZWFzb25hYmxlLg0KPg0KPiBUZXN0ZWQtYnk6IFBldGVyIE5ld21h
biA8cGV0ZXJuZXdtYW5AZ29vZ2xlLmNvbT4NCg0KVGhhbmtzIGZvciB0aGUgdGVzdCByZXBvcnQu
DQoNCj4gT24gYW4gQU1EIEVQWUMgN0IxMiA2NC1Db3JlIFByb2Nlc3NvciwgSSBzYXcgYSBjb25z
aXN0ZW50IDEuMDIxLTEuMDI2DQo+IHNlY29uZCBwZXJpb2QuIElzIHRoaXMgZW5vdWdoIGVycm9y
IHRoYXQgeW91IHdvdWxkIHdhbnQgdG8gZGl2aWRlIGJ5DQo+IHRoZSBhY3R1YWwgcGVyaW9kIGlu
c3RlYWQgb2YgYXNzdW1pbmcgYSBkZW5vbWluYXRvciBvZiAxIGV4YWN0bHk/DQo+IFdlJ3JlIG1h
aW5seSBjb25jZXJuZWQgd2l0aCB0aGUgcmVsYXRpdmUgYmFuZHdpZHRoIG9mIGpvYnMsIHNvIHRo
aXMNCj4gZXJyb3IgaXNuJ3QgbXVjaCBjb25jZXJuIGFzIGxvbmcgYXMgaXQgZG9lc24ndCBmYXZv
ciBhbnkgZ3JvdXAuDQoNCkkgc2VlIHByZXR0eSBtdWNoIHRoZSBzYW1lIGRlbHRhX3Qgb24gSW50
ZWwgSWNlbGFrZS4gV2UgY291bGQNCnVzZSBqaWZmaWVzIHRvIGdldCBhIGJpdCBtb3JlIHByZWNp
c2lvbiAoZGVwZW5kaW5nIG9uIEhaIHZhbHVlKS4NCg0KPiBUaGUgb25seSB0aGluZyBJJ2Qgd29y
cnkgYWJvdXQgaXMgaWYgdGhlIHVzZXIgaXMgdXNpbmcgc2V0aXRpbWVyKCkgdG8NCj4ga2VlcCBh
IGNvbnNpc3RlbnQgMSBzZWNvbmQgcGVyaW9kIGZvciByZWFkaW5nIHRoZSBiYW5kd2lkdGggcmF0
ZSwgdGhlDQo+IHdpbmRvdyBvZiB0aGUgcmVzY3RybCB1cGRhdGVzIHdvdWxkIGRyaWZ0IGF3YXkg
ZnJvbSB0aGUgdXNlcnNwYWNlDQo+IGNvbnN1bWVyIG92ZXIgdGltZS4NCg0KT25lIG90aGVyIHRo
aW5nIEkgZGlkIGluIG15IHJlc2N0cmwyIHN1bW1hcnkgY29kZSB3YXMgdG8gcGF0Y2gNCnRoZSBt
b2RpZmljYXRpb24gdGltZSBvZiB0aGUgc3VtbWFyeSBmaWxlIHRvIHdoZW4gdGhlIGtlcm5lbCBy
YW4NCm1ibV9oYW5kbGVfb3ZlcmZsb3coKS4gVGhhdCB3b3VsZCBhbGxvdyB1c2VycyB0byBjaGVj
ayB0aGUNCnVwZGF0ZSB0aW1lIHRvIHN0YXkgaW4gc3luYyB3aXRoIGtlcm5lbCB1cGRhdGVzLg0K
DQotVG9ueQ0K
