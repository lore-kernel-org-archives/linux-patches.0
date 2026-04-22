Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812BC37DE83
	for <patches@lists.linux.dev>; Wed, 22 Apr 2026 21:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776895192; cv=fail; b=uzTxq3zA75IaXMRzFphlq9ArmO3V3V6uaCrMK8Igj4riQz3F655WyOQ9zQ3LzneJXzyXwgxVXXy6ApADsiQZACgdDBUlmm9vmWa9OaSmc4TYqUufO2/vrDfaJIeCxlRyDPqDzzVhxdXWvk7G0uxTqN6ZR4qkWm7Ikq6AvS8f5Rk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776895192; c=relaxed/simple;
	bh=TNjqZyZpO1yGS7y6a8a7LXGVyUuhV+ScuM6lJ63ttGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=JalWLdpZNd+Rvz3p6FjQeuvXHN8eawvb7BvuyBqNMGpWjhwjUq8pKwfXMH7/knseTX/KYa3NZ/MSJB5T+gSK4KVk/8+Z3ecTV2oKqHLoK/C2foF+3U/jMWi+zqbNOSRDEE78HMmygyeD1V+Itit3M9mlSqIIPRlQ0lcbxfIjQn0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A/3FIll0; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A/3FIll0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776895192; x=1808431192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TNjqZyZpO1yGS7y6a8a7LXGVyUuhV+ScuM6lJ63ttGY=;
  b=A/3FIll00CFPSapoMDivPCvAcdHs/SkddlrGEIKN6mRQiKLFjYOB0Q0b
   IvRPTNobTkwVb5UsuSUc5rUFWjAX9SOtHK6iixxNzVYr9dxWERSSqVhme
   8V2QyVYiz73HRoRIM7q+0Z68AU33Ux8lba2iFJTe1D0YAnU+q2bs/5pWF
   xSQd3GoNgXFXXq3sO2a4EV8Vf3LpfNjpLkc9C09wbgVy/WdaYvujQDgBb
   NwYhjZ9LeN3auS/fJQUI5u10/+L4FE84tgyaWS7W8mzVKg13q4SPcqCr9
   3mvn4ep/ieyXak+EzPZFtt+dqYqx8t84TWXWAcenMMcHcNTtRk0Up9c0g
   w==;
X-CSE-ConnectionGUID: gtjBBkjaRTmbH4KVM1L5Yg==
X-CSE-MsgGUID: EbQ/LOLXTrSxdUEHN+7g8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="88936843"
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="88936843"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 14:59:52 -0700
X-CSE-ConnectionGUID: lxMVLGelTieZxBZmEo6qfg==
X-CSE-MsgGUID: DTTU7UmBS2uJibAkwuNXiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,193,1770624000"; 
   d="scan'208";a="229807425"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 14:59:51 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 14:59:50 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 22 Apr 2026 14:59:50 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.22)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 22 Apr 2026 14:59:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2MmI5kZ0sbcUOEB2NUVctg8qxKcXclwvES/HalbZ4Jj1poe49xbw5pQo9kLdurwkerSt6G4VZabqIeIYi6UpCbIJwjpnme2c/EL5X8rSc9CoHgu2f9Iz/R2B2v9YZeZu0+YWCJzGCQdBetghhILr5jDoqrYiJNr7CDawiE4TJyseL5GvGJEFNEE+XpO25wHoWWz08Sehj8gPd1ple5YL+EGWx2fIuqouvNB2yT0dCNFgj9oAajqfduzzRwX1tyy/1bD5OiF/hxOfLqM308xXfqedxd4o4LQPT5QtudO9J1Fh03QsO0F9G7pmiUPCr8odrlWZ9YJcB/uw//7aH56JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TNjqZyZpO1yGS7y6a8a7LXGVyUuhV+ScuM6lJ63ttGY=;
 b=mW7Iyprir/77d+a0KcHQZg54d7imPEuP72UAZqTzjFfFKn8T5gPCgcYwWL5ZTxY87O1PR2nfyxpQCM2D7M7qvZ/gB28Yh9NpLYKN6UFa7KTSbUWtf8oBcOKp8jbucOmP++UgZzh6wYwrg4ZmYzBnXjIlOWDHRPNrEb0k+TnKU/VkcVdsb6OuWBvrs13qL4HJCCsfmep17ImlnQBteemmgVrObqYrSZ0RxuX5IXAfSHTjSLlxu6Run3yYJ6RLBx7+eZ5rqSvxwIWmP7k07yT//WTXJsOeEoWBhQKdzqMm1Z6ER65YBV1EkKcwJVPRT2IXfY9Pt+rc2l9wAOyucMLY3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB8260.namprd11.prod.outlook.com (2603:10b6:510:1c3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.16; Wed, 22 Apr
 2026 21:59:42 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9846.016; Wed, 22 Apr 2026
 21:59:42 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Thread-Topic: [PATCH v4 4/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Thread-Index: AQHcwI5HlovBdt4MTkK5Ga90lG495bXOGYQAgARvGACAAAugAIAEq10AgAE5ZgCAAD4VAIAAJ9SAgBE53wCAAaP7AIAABvfA
Date: Wed, 22 Apr 2026 21:59:42 +0000
Message-ID: <SJ1PR11MB60831D6EBFDB4E1968B69E1FFC2D2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
 <aefdJG4y8JS_aTse@agluck-desk3>
 <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
In-Reply-To: <1633a669-ac1f-4ef4-b733-e12bb1c6a5eb@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB8260:EE_
x-ms-office365-filtering-correlation-id: 96d138c7-8958-4bb4-9d3f-08dea0ba754e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|18002099003|56012099003|22082099003|38070700021;
x-microsoft-antispam-message-info: KsGaCTt9ChGkU6lTCxQSG1EQY4Kpp3qKzTSsHLmmhurtLOZ9+eftUtedvBq4pJRJjPzwKwjfntlMUYeSDouKTrwtjQZ6Lts6s2FzCsL0V6/BoFcsD9vgxR7tG5M9xb2o+4M3pBPlmC4jHjnSVEsnDpytG6EWjTQnHCORUkj6E8BkTV5izvYTOoGOH6s45jtUTOhkt+qEHpAYQJJlY451QEDcEGHbGKFWZsAKh1e9KP8Wj0Rns0eZzTJmVXmR2tNuQg6I0OHopTesjh0hklbxoqcTXqiwLvrC5ANifTDwkjOsq9UmVkI5KLX2/lfFJyAIWh74Op9N1YeDt2u+ctWyQpAFEOpDpMbC5fd7hYgvLouaM/iG1S68VtUhm4DDExnJyaBX1u4xdGanJMSTKdhwe8e//6al0YWfmZDmvmu5L1dShMeXiqik9sqvkaPZEYWc+pc0w2fl7phJGqbcUxRa9yozoaFTL2/qWm2kT1/UkPH22SY6DvVFB/qWCqHWby3AT5Zsi+kaMBrqWq40ahHy6EAtvQpfP27m67ZW1pcTcDVlJji+G4Ep4GgrsEdk60WPK5AJ07/B1yfSpA4qln6unwBaWsENNEk7QNpIqSQV4Fp/ZObcZXfkHF52wVm2jjcOfEPiQXlJfqiqBwjJ6t0nBtpR9VrOl08MJfq8ysPPKrfRD6hslyzU5Lw4ctofcjgZXvbzuBu7K5v7Nf+6KHfIa8sObFlhpAW6dZ2HugUZY1BC8FppOA6jtsYAKD5KOy6bU+Alo6MS0+RmcrIrIJ0xopaxDInCUrFGUbwzIxv11Sg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(18002099003)(56012099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NWNRYm1lclI2V1BvTHFQQXplcEVnb3pxSDN0N2N4UXQ4c291eXdvZUZPTlNq?=
 =?utf-8?B?eG9YTjA1N29qUUN6UTN2MitsSVByaE1WazEyWDkwdTNVb3d2bWtvMVFHUGV0?=
 =?utf-8?B?QVM3SUtsOUJSYUh0UnJ5cnFLQ1FEamQvZnliWWlrM0FDN3laNXFqUk5EVE4r?=
 =?utf-8?B?NXU0eno2bHJpSEdZZWY2azdXMVRKOWprMXJFTGtKZFA5NFNlWFRSRkUxTWFy?=
 =?utf-8?B?WjNGZ1l3N0FhaFhuQStxVXVRa2l3NFQ0ckl1T0VHYmhpUlZxOWVrMExwWlB0?=
 =?utf-8?B?bWp1bDRYTkJnb2VtSDYyTDN0d28vRG0rNTVVMVlnNzhHd00yeW84OFdUYmsr?=
 =?utf-8?B?Ymp2cEtwaG4rbllwTWlTNmxseXArTUxlemUyRDU2M2JZL1VoTlZrVGVHck5O?=
 =?utf-8?B?aGNYMFF5bGVhU0VqR1VVQWtaYm5Belh1Z0xLQ3VvdkR0cDVESWFMQlYxbkU1?=
 =?utf-8?B?RktMV254K01MTUlNWnlUVXgxTG1sYUJRL3pKWnZpWFVqRWNKd2NZVlBmWWdU?=
 =?utf-8?B?TXJUVmtNc01sOVdXK1ducUliejY5dnEzT1FKczRDRExjckFIaVlEV0kzcEF6?=
 =?utf-8?B?TURPM1FVY1VYUHRQakxkTU8xcGpJZEdHSkZEN3g2Tlo3RUswN1ZDcWJEVkVQ?=
 =?utf-8?B?ejlhbW1HR05ubk96WGwwOVkrcnl0dlE0bGFlZCtMbkZzRXZ2bm9WbE9jMFgv?=
 =?utf-8?B?SnVmb0FuMmpXNnV5OGZxd25aZGIxWDNaN1pZazBzeEJLdjJTWGcyUzVDZ1dB?=
 =?utf-8?B?bXdGWmNveVYwT1BhRUkzYk1ORVhGeEE0Y0E5MzFMb29vZjdlMXByZkRPZWw1?=
 =?utf-8?B?NVFBaS85Q2djeFl6L0Rla1gxQmlsYXdqc0lJVmgzOS9UZC8ydFNDb0J6TWlO?=
 =?utf-8?B?cDZJVFRhTFpBRVBodVl2VHFhWEUydFVobkhONVYzTE1odUlRQnJNUjJVQkxx?=
 =?utf-8?B?NDBZRDRPQUpTOHRiUVBydzQ4YWpBMXBCb1RHK29BejNmRGZuK0lwMGc5Mi9F?=
 =?utf-8?B?OHNtWTJlWFZQM2h2a29TaFFjZW5Nd25EOHZscXZkRWwxeWpiSFZucFdFQTkv?=
 =?utf-8?B?TnlrMzl1cjJNcVNCWmhIWStzTmw4MnRqZm5XdGVMdWZSNjVURzNCOEgxbThn?=
 =?utf-8?B?TWVQcGVnN1Z1ZGxkeGNBOVVKUWVkMGNwU2RvT2NQWTFyWmJTZE1uYmwrdVZB?=
 =?utf-8?B?QWdaUDdPMFBITFFNUnZWUlBpZEZMV0hRVU9iWTVZdi94bkNIa09MUHlySGRD?=
 =?utf-8?B?SkViSFJwWHRxQXFqOE5XMm5ob3NVaklaa0Z3eUh3TDBIUGxNcm4wVndKclFU?=
 =?utf-8?B?dXlEY0xLRnI4MFEvWDg1RmdjTk5Xc0p3L1V4RjNGbEZHTVBydXlHWXlDQVdQ?=
 =?utf-8?B?bzBFRWljRk0vb0ZMdUwyN1lDQ01Ed1U2SzBldGVKNU1hK0NmZ2lOc0duV3hX?=
 =?utf-8?B?Z1oxd2t0TE9CMDNtNjN1blFOdm9vNlRLUVdZWU1GQitpTFk1NGd4bFpYcUJt?=
 =?utf-8?B?dlBydGRiUUhtUnpsc3RBejJBSkFEd0lOZGhOQzZhanc2ZFNWeVVlV0o3R0o5?=
 =?utf-8?B?c1h1M0FudnNmNndCSkpnQTZVdEJvOUE3alVITXpXQ3p4STN1bEVCdEZtMFl1?=
 =?utf-8?B?KzdWaU1MZUwwYmdlNU1ock5acnhVSFBQbG1hcnlUZGdydmw4cFJtWW9QMFdq?=
 =?utf-8?B?WVdJVWFtN1luQm0zM2hlazVQQlJMMnJNZmFSZEZWQXRiUmM4VUpOVGVzR3Zh?=
 =?utf-8?B?L2IwVWhZeEZ5bnJsUll1STBBTzJudHdHU1NwMUhYRVJ5UmVZall1dzdqVTRP?=
 =?utf-8?B?UzZ6MzBuVGU2RDRoUTlld2luWlZWaTMrbUZiMlZpNnZSSEVSSElBYThxM09h?=
 =?utf-8?B?Yks4L3JzM1MzZElFbmRKM3pZcDJYTFBCSWd3SEQwUzN0WG1hVkZoUERzS2RG?=
 =?utf-8?B?T0VQVWtwNkhLZ2p5dG1IM3lzazZqaElvbDhuOGZVSDdqNjhXVFB3OWxQbjNV?=
 =?utf-8?B?a3k5N2pyVThLOUZINWQ4UFV6UmVMY3R1RmUzbmVYN1pkMDl0aW00d3NDdElw?=
 =?utf-8?B?dEJDWDdZcGVsRVM5cDd3d1dqd0E3blJyaVpwTFZVSi8rMGFheDdUbXEzTSs4?=
 =?utf-8?B?THJEUGFzNXRsS0dCemtmRlBzaWIvenZBdjBzTkJsZllwenJidXFBVGpuNWhw?=
 =?utf-8?B?TGVxRlRWVm9YaDd0QVgyMFBDMEZlWGJHZ1JOajFuVDh5Z3dmMmJ4RGY3djJ5?=
 =?utf-8?B?TGIyNWg2dWFqTHVaelVFcU5wWHNjMTJUc0JucTFtMGRmSmY2VzY4emszNElL?=
 =?utf-8?Q?ZgtQ9gTT8CfQppL+JW?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: mtW+gHhRkkVM0/1lhbEc3cEhTRgr2bjG/XZ2inkKvVuptH9vdy4lAK04UjD/05JHiswlxdtRhjM1DPfBVkUQwL9jm4onSaKJS3zRjebpuTVPztLcFt5EznCFdOpMIyGyFRf+Bfzc7/BvDU9hInM1vXacliXSFIxsRXAoztIlaAhZGOS/QAnq1nGrxNx4HDBdB0uf9JbRjg+/i4ZI4sFqdnbDA8HuUxEOfIL5Rhjr4c3feQzvV/4RCwrQi+xsSCPp/qnTbq7fmX6Yh9UTTHhEvfQOxJVOiNXxhPW4bHHTBmLw1ioK2WOhyf4ojb0K6C9gGXzbbZolLfi9bQEiMpJ/0g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96d138c7-8958-4bb4-9d3f-08dea0ba754e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2026 21:59:42.5545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WIdfLkRXWPAYMAIdcMaQ1OMG79JdB1RxJA188IBTPOydslyYImWU7BnIOeVPzQ3cPsGNGtYqOXmDtX0wLIkogA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8260
X-OriginatorOrg: intel.com

PiA+IFNlZW1zIE9LLiBCdXQgdG8gbWFrZSBzdXJlIHRoYXQgZXZlbnRzIGFyZSBhY2Nlc3NpYmxl
LCBhcmNoaXRlY3R1cmUgd2lsbA0KPiA+IG5vdyBoYXZlIHRvICJob2xkIiB0aGUgcG10X3RlbGVt
ZXRyeSBtb2R1bGUgcmVnYXJkbGVzcyBvZiB3aGV0aGVyDQo+ID4gcmVzY3RybCBmaWxlIHN5c3Rl
bSBpcyBtb3VudGVkLg0KPg0KPiBDb3VsZCB5b3UgcGxlYXNlIGVsYWJvcmF0ZSB3aHkgdGhpcyBp
cyByZXF1aXJlZD8gaWYgSSB1bmRlcnN0YW5kIGNvcnJlY3RseSB0aGUNCj4gImhvbGQiIG9uIHRo
ZSBwbXRfdGVsZW1ldHJ5IG1vZHVsZSB3aWxsIGJlIGRvbmUgYnkgaXRzZWxmIGJldHdlZW4gdGhl
DQo+IGludGVsX3BtdF9nZXRfcmVnaW9uc19ieV9mZWF0dXJlKCkgYW5kIGludGVsX3BtdF9wdXRf
ZmVhdHVyZV9ncm91cCgpIGNhbGxzLg0KDQpJZiBhcmNoaXRlY3R1cmUgY29kZSBydW5zIGNvbXBs
ZXRlbHkgYXN5bmNocm9ub3VzbHkgdG8gcmVzY3RybCBtb3VudC91bm1vdW50DQp3aGVuIHdvdWxk
IGl0IGJlIHNhZmUgdG8gY2FsbCBpbnRlbF9wbXRfcHV0X2ZlYXR1cmVfZ3JvdXAoKT8NCg0KLVRv
bnkNCg0K
