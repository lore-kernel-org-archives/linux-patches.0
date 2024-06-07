Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ADF6FC6
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 00:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717720334; cv=fail; b=IyqLiG9ZkAsVbAULpmfb2HfiSYzD+Se520f5Xs8smM3Z7vVjDoeLWmhe+We3BRZf5U2rt+//Au2wvtusHIYcbBn3hGMsflzc91IQNJJbApAIu3ZEI1qllOv5J4IBQVwCGS4bINq307Md1HzkFi2+CBGj0drZAp87NKx8x45JECE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717720334; c=relaxed/simple;
	bh=MinPvLZ72WDIsnak9egHBSlwWVjPzYXydhLDT29BxF8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=J0GTkF//pbxBfkDDIO6fvdq+BZYb68/vv1ExK1yIsfszaQdXWvvj8yp145S+3b88+AKRC3zfFvBqdfj9i5gSiSzJAkXw3Ihe50u3b5lruJFBYppmV2/kl6kJ+3FAVih+qiPjaqb7uhp6xSvXr14pTc/5Xe8FU0znaQfvoPb0SNU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jhcfc3tj; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jhcfc3tj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717720333; x=1749256333;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MinPvLZ72WDIsnak9egHBSlwWVjPzYXydhLDT29BxF8=;
  b=Jhcfc3tjk2Oc5RqTuxoAyilI6HhDojzx/rsWSmAn8Lk6DExpl/jXv1+r
   C/f2XPeUYcvX+cmxpjXqhXK3avf0z9KQ9EIZFg/cBCEiOaENcA4f/sWCY
   r0CwPqhq3ZBGdNHQ2hA2NUIPBVlnVxd+uoq0kEWOROz4mY75pZpPOOdxB
   R/uPelipmZvKuRaR2Y0bs1shO6MRM4gE8v6aC+jqiJbdgiZKepzvIocA8
   mXBOw0SuD4SBDZhLh8AvIDbP0P8yBqmhGWI80A54f1yCydfAzAXLW9ZJB
   c1rOJCUxNCZmFBZrwksvYrpvm/CsMzQn/OECafMnCwYP/cVdFujH1jYzL
   w==;
X-CSE-ConnectionGUID: AaajBOovT0CvR6JjRnNqWg==
X-CSE-MsgGUID: Cw7MHEV5R3ivyCv9sCtvbQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11095"; a="25830007"
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="25830007"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2024 17:32:12 -0700
X-CSE-ConnectionGUID: Omk/KL3qTEK+Lm+TIdzASQ==
X-CSE-MsgGUID: BQKKrwupQZOUpnOBPKa1JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,219,1712646000"; 
   d="scan'208";a="37990234"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Jun 2024 17:32:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 6 Jun 2024 17:32:11 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 6 Jun 2024 17:32:11 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 6 Jun 2024 17:32:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FEfB6xSl1PXRs0jMXzOa1uOmhWfDCeDEqCFPLytYpatVrsN+x36RM8yVrQae9Xlo8IeS5tuoGLDbZeoJGPcl7v5b4tHhtmKU9UqxgMj5sMvWpGzYtBALDa5TjHgn1udhq8kLNmIJTAVJD37Kgx6oInTqcQ4puXXVhIpkObASXI+L2wyUK3hLKJ4zmk5w+owSR4MaNkz4X4/eKgxieMF7XNl8AMNh3pUHGubNo0TPqxAzisaiwWvvd/LzOpQAAefjyeeQK4ATFu4KMB/XFpXPZJoauYr4+YI0cXXIpMqziC3g+1r+7w2o6pEZOayH/d6g3o0+phC0bsh8RUnFioIj1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MinPvLZ72WDIsnak9egHBSlwWVjPzYXydhLDT29BxF8=;
 b=WT9fKFU/kpPNK//GtUIKuCcMcUZ2bHxKX2xCIhXbTgNOFY80sGfIGTnj1CxavMRwRu0DatxdXi8dFEdxLTdbTkbj1b/fC3bdb5yfcNMisIYj5Pru6sMvrQJS57GnCqvTd5cUHxF1V7thA4pUP1IsxgaR3iofCoOal0ByOdDEMe4DU9STiMpQWRlx0ryevoS9y+PQvk/HqBD+O2gw7QCs4IfPCz1HAMgjwE8jP4RmMokKeFIVpeAV8e7ujKU4yx0l0XjFY4V7/rN80yc7z6SmQkPgQ4Rtj2TIVjAtLW1CcIVbMPDAY45ZmJJehyZ1GGC9nQWBd38EX9ty8J5+WKM/Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6605.namprd11.prod.outlook.com (2603:10b6:510:1b0::16)
 by SN7PR11MB7419.namprd11.prod.outlook.com (2603:10b6:806:34d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Fri, 7 Jun
 2024 00:32:07 +0000
Received: from PH7PR11MB6605.namprd11.prod.outlook.com
 ([fe80::91a:711e:b675:edac]) by PH7PR11MB6605.namprd11.prod.outlook.com
 ([fe80::91a:711e:b675:edac%4]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 00:32:07 +0000
From: "Zhang, Rui" <rui.zhang@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>, "hui.wang@canonical.com"
	<hui.wang@canonical.com>, "Brandt, Todd E" <todd.e.brandt@intel.com>,
	"Lifshits, Vitaly" <vitaly.lifshits@intel.com>, "Keller, Jacob E"
	<jacob.e.keller@intel.com>, "horms@kernel.org" <horms@kernel.org>,
	"naamax.meir@linux.intel.com" <naamax.meir@linux.intel.com>, "Nguyen, Anthony
 L" <anthony.l.nguyen@intel.com>, "sashal@kernel.org" <sashal@kernel.org>,
	"kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH 6.6 723/744] e1000e: move force SMBUS near the end of
 enable_ulp function
Thread-Topic: [PATCH 6.6 723/744] e1000e: move force SMBUS near the end of
 enable_ulp function
Thread-Index: AQHauB0D0dmYp64YWUmREHlq1FeddrG7dASA
Date: Fri, 7 Jun 2024 00:32:07 +0000
Message-ID: <3eb7ce5780ccbd08f1d1d50df333d6fc7364b2e9.camel@intel.com>
References: <20240606131732.440653204@linuxfoundation.org>
	 <20240606131755.652268611@linuxfoundation.org>
In-Reply-To: <20240606131755.652268611@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR11MB6605:EE_|SN7PR11MB7419:EE_
x-ms-office365-filtering-correlation-id: ae46cdcf-ff5a-4f95-e13c-08dc86894317
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?UTdtTmRNcDd3QmY0UHk2NEh2QkJGc1N3T2k3cXVzUlN0bnFrWkNTNWJobDVO?=
 =?utf-8?B?THJTRjZyYmwvVnJaWGJCRWZqdFdUeld6SG4xMWJEMjA1SWIzMVV2ejd6bGV0?=
 =?utf-8?B?R2QyRmx2MlNSUmp6TlZmazdCZDd0L3RhSW0xemxVUzVnQzZod1loeXAzWFFj?=
 =?utf-8?B?Q2dacTl1dm1sOFVCblpUZWpCV0V1OUJEUmxKd2Z0cUltSldoMWN4WDVXYU94?=
 =?utf-8?B?cm5YM3NxRk41WWxoS2hHUGdhSlNGc1ZSZE5VcUlZdUZYQzhmT3N5UERZOTFs?=
 =?utf-8?B?UzdnVEtYV3lPaUtsa0NTSDJ0K2F2NHdRUnhXOVlLTTdhYS9MVDBKRHYxeTVs?=
 =?utf-8?B?Y2drRTRkUlRHVW1QaFJhUGt5SVgrUTZXY1lzZmlXOWpuS1kwTE9WUXk0M2px?=
 =?utf-8?B?aXM0eGJjaWkzcGNoMkw3R1IyM2hqNjcyRUFOVEdNRzlLWVlTM1I0ZGppK1No?=
 =?utf-8?B?RW5ncTB2R0tyaXZ0b0Q5dkU4akgrck9QV2kyc01jV1J2ZnhMSnV0Uk8rQXMz?=
 =?utf-8?B?L3dxU2ZuTjU5Mi9oeXduZWcwSFJRNEduUmZ2Q3QvSU9ZSlViK3g2RjREZ0lx?=
 =?utf-8?B?V3R5Vm5kVDhmdmZvZzE0K01pTm1XdmhLK0RBak9KaE1naHduYkZqcVU2K2dh?=
 =?utf-8?B?N2pRdXVkeWEzM2hYRkRlRjNyRFAvU0huQTFmMDFSSEVibXVkdXhmL2hsVWpB?=
 =?utf-8?B?OGRJTkJ1WUhSbVZLU1NWWUZPY2hNRUdrMUN0bmxtSEhKdmFEOW54UjM4T1VP?=
 =?utf-8?B?djdob1B5b1V1OXBtTTZQTHM1VFFLektqWmJ5NEJtM3lWQm9vMkw4NFk0c0tE?=
 =?utf-8?B?N1hFNjJTM2l2U0lyamxiNENmb3VWMXAyZU5Wa3R3cmxmaXg1cVpoMWVucjM5?=
 =?utf-8?B?dTExaFFPRHU0OXdNTkkxbjFTWHp3OFpjSCtOS1RVbnhSUE12dVhyc0lCTDBh?=
 =?utf-8?B?T2QveFFvWjVaVGFnN3QwUnc0c0p3NUkyODhvczVxUGpxTkk3NlNudWJCWVd5?=
 =?utf-8?B?T0p2enA0VDdvU3h6NjZrN2lSZExIMjJDa0wrZlhDTVEvNFY4aGhwZzAwSUg5?=
 =?utf-8?B?RFJnT2c3M3dkZ2xVZ2F3eVZ2MnlZZmdVNU1CNkM1ZFNHcmEwdW5uVzkyblZ6?=
 =?utf-8?B?UXB1dDhOV3dod0hFSXRwS21Qb3ZhVTRaSTZMSG1ZNWJiRTZMZ0pvdlNKdHpP?=
 =?utf-8?B?eFpCdVZhR2FIU0JvWkFpWGxwd2hSVFFMQkx2L1NOZ0RNcXJndDFtZUc5ZHdG?=
 =?utf-8?B?cjRiTmcyTGNHMFFOVGtFMTZONkRqbFVPL2ZWNFpzTHU0ZEZkeXNNU2dxK0pp?=
 =?utf-8?B?b1RUVEVTaFBMdHVWY08wdEJpOVQ5SjNBci96WTEyQlk4Z2Yrc3pCUE0vWCtM?=
 =?utf-8?B?L0ExZng5bzlPMi9saU9oQXhsYjh0NzgzQkFaMENZTy9PeWhnQms5M1REZTJn?=
 =?utf-8?B?ZElrVmE2OUdFZ0RlNTFYRDl6bktVM3VzK3piY1ZtK0JvUWZFRlRhdmM5TTJB?=
 =?utf-8?B?NUk5MVUzdzM5Q0h0bjFFckFSejF2MVhtWGdHTGNKTHk5MXQ5bzRveC81a3ZF?=
 =?utf-8?B?MHJSWUF5SnRFRkt4dmc0aTBjT0Q4WXJVREZuTzQwWGpWalZ4aWd6RDJyZGo4?=
 =?utf-8?B?ZlN3SEg4OCs1R1RzdlIra2JUVVNSM3AxUElITWpmd2NETzZEY3FMQU11emt1?=
 =?utf-8?B?VkszcDdEOXZLb0poMlFQcW9rdnU1aTFLcUVEZDY3cENUYUdIbTF1eC9KZTd2?=
 =?utf-8?Q?rgdnFHobDNNr0OdrezIM+85XDVTHmcM203pfh6J?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWtHOGR4ck5Eam5oVkZnbXhSQzRCN3NCcE5PRGI3TUFpRWtqdjFlcXViMzRM?=
 =?utf-8?B?a0NkQnBWcEFhK29KQkdqVFE0d2ZGTDg5VzNEdHNuSW8xelc1YU5QaVFJbTVI?=
 =?utf-8?B?SEdEQndndERUdzFlSU1JUjdGMlU1UkJMSzN2Zm0xZXdpMWRtUWlLcFlOZE9r?=
 =?utf-8?B?dU1qZU93UlhyQjQyTUUycHdCUXZ5Z3NFUEZPelFsVitrQ2NUc2NJZEpoeUFx?=
 =?utf-8?B?MHpld2wwZkRlQ20yeXJpZDBJZnBGWEtRajFKbFh0ZFVOM1R5NTh5K21PREZ4?=
 =?utf-8?B?MnhHNUdlcitLRVpiRlMyc1B5bEgwT1V4V0lUcjFHUENpWFBRV216eGNYdXhD?=
 =?utf-8?B?TExrSHFVRkVKUXFpSk8za1BJb29RMWY5NTRtb1hXbEJSdE1mQi9FZ0lsQlRt?=
 =?utf-8?B?NHkvcTJDbVZoMXVrVHBrNEEydWVYNWZCdVFJa3duRHh1QVFpNnpFMzlSWnly?=
 =?utf-8?B?OUYyZkU3dVB4WnQ1L0lRTUZDNWFKeW90QzhUMmRxaHpTdG56dzMrTnEvd3ZN?=
 =?utf-8?B?bGMwLzRnQzBFT2hFUXErOEx3aHdENStBNkxBU2w2SHYxTHdSMnVYN09qMHVz?=
 =?utf-8?B?TCtYQUkybHFJNlBWWGpWTzgrNnlLMDdYRHY5TXJET0ZuZ052dWg5OFVyWHha?=
 =?utf-8?B?SkdQVVdqMTM2aFo1L0lzamNkbGJZUUhMV3FPTk5kamx2WEtFSlRHZDNoQ2Mv?=
 =?utf-8?B?S0FZZmw0dlZQK0lKdjJZTTFZaVpwZEZxbHVzR1J2RUp3d3QrSzlVRjNOcWlM?=
 =?utf-8?B?Q1R5RlZCc1BHYU1BeCsvZVFTNm1Wd0VqK0ltT2tYZFZxRnNwdEloN01LRnVM?=
 =?utf-8?B?ZnhaUmRmbmxRY24yaGhOOTZucFdPOWE2ZndxYWxEemNaNFd3b1ZXT2pyeE5l?=
 =?utf-8?B?RXJld2dpK3JEOGVhMks4WXhCZVJ6M0ZDb2xjWmg4N0NKZjhIdlZFbzlDS25a?=
 =?utf-8?B?L2J5OGdjYUlmRkN5MnhrRFgyelRNajVFTTlvV2ZCdU93aHR2OTVtR1ljTExS?=
 =?utf-8?B?S2JGdG9KSDU0V2lLNXcyK0RwYXUyVWZSRENweEwwRVJEQ0FlOEhFSWdTb3BH?=
 =?utf-8?B?elF6emZQSmErVDVpM2w0cVo5dCtWOHBIWVZQS1lGZUhCOWVDTGV6OXBoM041?=
 =?utf-8?B?QmNPUDYzWTlyRjBSQkdnS0JXU0FOUHdCWElITS9DUTlkbTRyMzYzTmh0K3lV?=
 =?utf-8?B?T0NkS1VTUE4wZHFGeFhnTGJGZ0JoN0dzU3A5MWNiR1JpYVlzU0FJWjY1RzFk?=
 =?utf-8?B?K2dsdUNXMXpFTVB1UUNndm1qb3RHVXIxMGVIRjhwQWlRWm12Q2RlVnlhYXBq?=
 =?utf-8?B?TVA3Z2VyS2g0NGFkUFhSNFFPczNXRXVqdnh4NlNnSHhhTDBmb3ZneXZIUlhN?=
 =?utf-8?B?RXhuRjJkN2pCVjBvaDZXTFZ4Z2ZvVTR4M2lzTkU3V0xEcjdvMzZmazNlTU9H?=
 =?utf-8?B?WEl3aXpzZll5dkJXeUFKaWFUN00yNmMrcVNRbmc0SkVIem1BcWxOM0dWNytt?=
 =?utf-8?B?ZjE1NjBFbHI2eGJpSWJZZDB4SzYyMnN0UU5UZThOWUNKeXIvdmNmLzZ5bmF3?=
 =?utf-8?B?MTNseFdocTdKaHczR0wwZTBQTTIyOXdOSnNEenJiS1hNVFlUenhjVFRDZTJk?=
 =?utf-8?B?L1pqTHB5QW5FZUZXdGFvTW9QU1lhR3M2NFBFODh0Sk41MjJOTWZZY09peVhh?=
 =?utf-8?B?SituTlc4TVgzT3lNSGtGNTRHUExVZ3RRSnNXR3dOcHRTM1hCODNRa2cxR2JU?=
 =?utf-8?B?YkhSTEU1MnI1Yy9PUzQ3ZVpSdHAvRVo3MkV3VU16MU50bW1HK1ZPajFSdkZC?=
 =?utf-8?B?QUFtZkhuUnlTZWtnMFF0U3hRMFJYT1hSUEUwOCtzcUxGaXV3TllpUVpST2Jp?=
 =?utf-8?B?VXNwTlZoenRHZXFCNDVNZmVvaHJYdUM1YlpHY1YwYS9MeG8rMlRmOE8yaEFV?=
 =?utf-8?B?eGcyWXpuU3k4cVVveDVaZU9NMGRVeHUzRXkrSmdNd1ZhVmtpL29ZcmUwOU1s?=
 =?utf-8?B?VGVlY0Vua2lOOGxJVlV3a29BV2lQQitvSXRoY1dRR3cxV0o5ODhmMWlCN0h0?=
 =?utf-8?B?U25FbGwxNnFldkVmN09aSnpnYjl2NlZUT0gvQUJiSXgyeXVzSUJ1WmtKcWNR?=
 =?utf-8?Q?qknMJCrX8zuvC+I4vBwf4CgRw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33E78D34A024DD42A7C38B39E2B37F91@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae46cdcf-ff5a-4f95-e13c-08dc86894317
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 00:32:07.3456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1+Pz8komsSUkZ076WWp38mfX3y51FegRLoCyu1xFOBr5J5QpYJiSOTO37C8uOAhkETbA5Ew57Ck6657vw9Euaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7419
X-OriginatorOrg: intel.com

QWRkIFRvZGQuDQoNClRvZGQgZm91bmQgYSByZWdyZXNzaW9uIGNhdXNlZCBieSB0aGlzIGNvbW1p
dC4NCmh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE4OTQwDQoN
CkkgdGhpbmsgd2Ugc2hvdWxkIG1ha2UgdGhhdCBjbGVhciBmaXJzdC4NCg0KdGhhbmtzLA0KcnVp
DQoNCk9uIFRodSwgMjAyNC0wNi0wNiBhdCAxNjowNiArMDIwMCwgR3JlZyBLcm9haC1IYXJ0bWFu
IHdyb3RlOg0KPiA2LjYtc3RhYmxlIHJldmlldyBwYXRjaC7CoCBJZiBhbnlvbmUgaGFzIGFueSBv
YmplY3Rpb25zLCBwbGVhc2UgbGV0IG1lDQo+IGtub3cuDQo+IA0KPiAtLS0tLS0tLS0tLS0tLS0t
LS0NCj4gDQo+IEZyb206IEh1aSBXYW5nIDxodWkud2FuZ0BjYW5vbmljYWwuY29tPg0KPiANCj4g
WyBVcHN0cmVhbSBjb21taXQgYmZkNTQ2YTU1MmUxNDBiMGE0YzhhMjE1MjdjMzlkNmQyMWFkZGIy
OCBdDQo+IA0KPiBUaGUgY29tbWl0IDg2MWU4MDg2MDI5ZSAoImUxMDAwZTogbW92ZSBmb3JjZSBT
TUJVUyBmcm9tIGVuYWJsZSB1bHANCj4gZnVuY3Rpb24gdG8gYXZvaWQgUEhZIGxvc3MgaXNzdWUi
KSBpbnRyb2R1Y2VzIGEgcmVncmVzc2lvbiBvbg0KPiBQQ0hfTVRQX0kyMTlfTE0xOCAoUENJSUQ6
IDB4ODA4NjU1MEEpLiBXaXRob3V0IHRoZSByZWZlcnJlZCBjb21taXQsDQo+IHRoZQ0KPiBldGhl
cm5ldCB3b3JrcyB3ZWxsIGFmdGVyIHN1c3BlbmQgYW5kIHJlc3VtZSwgYnV0IGFmdGVyIGFwcGx5
aW5nIHRoZQ0KPiBjb21taXQsIHRoZSBldGhlcm5ldCBjb3VsZG4ndCB3b3JrIGFueW1vcmUgYWZ0
ZXIgdGhlIHJlc3VtZSBhbmQgdGhlDQo+IGRtZXNnIHNob3dzIHRoYXQgdGhlIE5JQyBsaW5rIGNo
YW5nZXMgdG8gMTBNYnBzICgxMDAwTWJwcw0KPiBvcmlnaW5hbGx5KToNCj4gDQo+IMKgwqDCoCBb
wqDCoCA0My4zMDUwODRdIGUxMDAwZSAwMDAwOjAwOjFmLjYgZW5wMHMzMWY2OiBOSUMgTGluayBp
cyBVcCAxMA0KPiBNYnBzIEZ1bGwgRHVwbGV4LCBGbG93IENvbnRyb2w6IFJ4L1R4DQo+IA0KPiBX
aXRob3V0IHRoZSBjb21taXQsIHRoZSBmb3JjZSBTTUJVUyBjb2RlIHdpbGwgbm90IGJlIGV4ZWN1
dGVkIGlmDQo+ICJyZXR1cm4gMCIgb3IgImdvdG8gb3V0IiBpcyBleGVjdXRlZCBpbiB0aGUgZW5h
YmxlX3VscCgpLCBhbmQgaW4gbXkNCj4gY2FzZSwgdGhlICJnb3RvIG91dCIgaXMgZXhlY3V0ZWQg
c2luY2UgRldTTV9GV19WQUxJRCBpcyBzZXQuIEJ1dA0KPiBhZnRlcg0KPiBhcHBseWluZyB0aGUg
Y29tbWl0LCB0aGUgZm9yY2UgU01CVVMgY29kZSB3aWxsIGJlIHJhbg0KPiB1bmNvbmRpdGlvbmFs
bHkuDQo+IA0KPiBIZXJlIG1vdmUgdGhlIGZvcmNlIFNNQlVTIGNvZGUgYmFjayB0byBlbmFibGVf
dWxwKCkgYW5kIHB1dCBpdA0KPiBpbW1lZGlhdGVseSBhaGVhZCBvZiBody0+cGh5Lm9wcy5yZWxl
YXNlKGh3KSwgdGhpcyBjb3VsZCBhbGxvdyB0aGUNCj4gbG9uZ2VzdCBzZXR0bGluZyB0aW1lIGFz
IHBvc3NpYmxlIGZvciBpbnRlcmZhY2UgaW4gdGhpcyBmdW5jdGlvbiBhbmQNCj4gZG9lc24ndCBj
aGFuZ2UgdGhlIG9yaWdpbmFsIGNvZGUgbG9naWMuDQo+IA0KPiBUaGUgaXNzdWUgd2FzIGZvdW5k
IG9uIGEgTGVub3ZvIGxhcHRvcCB3aXRoIHRoZSBldGhlcm5ldCBodyBhcyBiZWxvdzoNCj4gMDA6
MWYuNiBFdGhlcm5ldCBjb250cm9sbGVyIFswMjAwXTogSW50ZWwgQ29ycG9yYXRpb24gRGV2aWNl
DQo+IFs4MDg2OjU1MGFdDQo+IChyZXYgMjApLg0KPiANCj4gQW5kIHRoaXMgcGF0Y2ggaXMgdmVy
aWZpZWQgKGNhYmxlIHBsdWcgYW5kIHVucGx1Zywgc3lzdGVtIHN1c3BlbmQNCj4gYW5kIHJlc3Vt
ZSkgb24gTGVub3ZvIGxhcHRvcHMgd2l0aCBldGhlcm5ldCBodzogWzgwODY6NTUwYV0sDQo+IFs4
MDg2OjU1MGJdLCBbODA4NjoxNWJiXSwgWzgwODY6MTViZV0sIFs4MDg2OjFhMWZdLCBbODA4Njox
YTFjXSBhbmQNCj4gWzgwODY6MGRjN10uDQo+IA0KPiBGaXhlczogODYxZTgwODYwMjllICgiZTEw
MDBlOiBtb3ZlIGZvcmNlIFNNQlVTIGZyb20gZW5hYmxlIHVscA0KPiBmdW5jdGlvbiB0byBhdm9p
ZCBQSFkgbG9zcyBpc3N1ZSIpDQo+IFNpZ25lZC1vZmYtYnk6IEh1aSBXYW5nIDxodWkud2FuZ0Bj
YW5vbmljYWwuY29tPg0KPiBBY2tlZC1ieTogVml0YWx5IExpZnNoaXRzIDx2aXRhbHkubGlmc2hp
dHNAaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IE5hYW1hIE1laXIgPG5hYW1heC5tZWlyQGxpbnV4
LmludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFNpbW9uIEhvcm1hbiA8aG9ybXNAa2VybmVsLm9y
Zz4NCj4gUmV2aWV3ZWQtYnk6IFBhdWwgTWVuemVsIDxwbWVuemVsQG1vbGdlbi5tcGcuZGU+DQo+
IFNpZ25lZC1vZmYtYnk6IFRvbnkgTmd1eWVuIDxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT4N
Cj4gVGVzdGVkLWJ5OiBaaGFuZyBSdWkgPHJ1aS56aGFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1v
ZmYtYnk6IEphY29iIEtlbGxlciA8amFjb2IuZS5rZWxsZXJAaW50ZWwuY29tPg0KPiBMaW5rOg0K
PiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjQwNTI4LW5ldC0yMDI0LTA1LTI4LWludGVs
LW5ldC1maXhlcy12MS0xLWRjODU5M2QyYmJjNkBpbnRlbC5jb20NCj4gU2lnbmVkLW9mZi1ieTog
SmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogU2FzaGEg
TGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiAtLS0NCj4gwqBkcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9lMTAwMGUvaWNoOGxhbi5jIHwgMjINCj4gKysrKysrKysrKysrKysrKysrKysrDQo+
IMKgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jwqAgfCAxOCAtLS0t
LS0tLS0tLS0tLS0tLQ0KPiDCoDIgZmlsZXMgY2hhbmdlZCwgMjIgaW5zZXJ0aW9ucygrKSwgMTgg
ZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvZTEwMDBlL2ljaDhsYW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAw
ZS9pY2g4bGFuLmMNCj4gaW5kZXggNGQ4M2M5YTBjMDIzYS4uZDY3OGNhMDI1NDY1MSAxMDA2NDQN
Cj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL2ljaDhsYW4uYw0KPiAr
KysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9lMTAwMGUvaWNoOGxhbi5jDQo+IEBAIC0x
MjI1LDYgKzEyMjUsMjggQEAgczMyIGUxMDAwX2VuYWJsZV91bHBfbHB0X2xwKHN0cnVjdCBlMTAw
MF9odw0KPiAqaHcsIGJvb2wgdG9fc3gpDQo+IMKgwqDCoMKgwqDCoMKgwqB9DQo+IMKgDQo+IMKg
cmVsZWFzZToNCj4gK8KgwqDCoMKgwqDCoMKgLyogU3dpdGNoaW5nIFBIWSBpbnRlcmZhY2UgYWx3
YXlzIHJldHVybnMgTURJIGVycm9yDQo+ICvCoMKgwqDCoMKgwqDCoCAqIHNvIGRpc2FibGUgcmV0
cnkgbWVjaGFuaXNtIHRvIGF2b2lkIHdhc3RpbmcgdGltZQ0KPiArwqDCoMKgwqDCoMKgwqAgKi8N
Cj4gK8KgwqDCoMKgwqDCoMKgZTEwMDBlX2Rpc2FibGVfcGh5X3JldHJ5KGh3KTsNCj4gKw0KPiAr
wqDCoMKgwqDCoMKgwqAvKiBGb3JjZSBTTUJ1cyBtb2RlIGluIFBIWSAqLw0KPiArwqDCoMKgwqDC
oMKgwqByZXRfdmFsID0gZTEwMDBfcmVhZF9waHlfcmVnX2h2X2xvY2tlZChodywgQ1ZfU01CX0NU
UkwsDQo+ICZwaHlfcmVnKTsNCj4gK8KgwqDCoMKgwqDCoMKgaWYgKHJldF92YWwpIHsNCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGUxMDAwZV9lbmFibGVfcGh5X3JldHJ5KGh3KTsN
Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGh3LT5waHkub3BzLnJlbGVhc2UoaHcp
Ow0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZ290byBvdXQ7DQo+ICvCoMKgwqDC
oMKgwqDCoH0NCj4gK8KgwqDCoMKgwqDCoMKgcGh5X3JlZyB8PSBDVl9TTUJfQ1RSTF9GT1JDRV9T
TUJVUzsNCj4gK8KgwqDCoMKgwqDCoMKgZTEwMDBfd3JpdGVfcGh5X3JlZ19odl9sb2NrZWQoaHcs
IENWX1NNQl9DVFJMLCBwaHlfcmVnKTsNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqBlMTAwMGVfZW5h
YmxlX3BoeV9yZXRyeShodyk7DQo+ICsNCj4gK8KgwqDCoMKgwqDCoMKgLyogRm9yY2UgU01CdXMg
bW9kZSBpbiBNQUMgKi8NCj4gK8KgwqDCoMKgwqDCoMKgbWFjX3JlZyA9IGVyMzIoQ1RSTF9FWFQp
Ow0KPiArwqDCoMKgwqDCoMKgwqBtYWNfcmVnIHw9IEUxMDAwX0NUUkxfRVhUX0ZPUkNFX1NNQlVT
Ow0KPiArwqDCoMKgwqDCoMKgwqBldzMyKENUUkxfRVhULCBtYWNfcmVnKTsNCj4gKw0KPiDCoMKg
wqDCoMKgwqDCoMKgaHctPnBoeS5vcHMucmVsZWFzZShodyk7DQo+IMKgb3V0Og0KPiDCoMKgwqDC
oMKgwqDCoMKgaWYgKHJldF92YWwpDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9lMTAwMGUvbmV0ZGV2LmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9l
MTAwMGUvbmV0ZGV2LmMNCj4gaW5kZXggMzY5MmZjZTIwMTk1OS4uY2M4YzUzMWVjM2RmZiAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvZTEwMDBlL25ldGRldi5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2UxMDAwZS9uZXRkZXYuYw0KPiBAQCAt
NjYyMyw3ICs2NjIzLDYgQEAgc3RhdGljIGludCBfX2UxMDAwX3NodXRkb3duKHN0cnVjdCBwY2lf
ZGV2DQo+ICpwZGV2LCBib29sIHJ1bnRpbWUpDQo+IMKgwqDCoMKgwqDCoMKgwqBzdHJ1Y3QgZTEw
MDBfaHcgKmh3ID0gJmFkYXB0ZXItPmh3Ow0KPiDCoMKgwqDCoMKgwqDCoMKgdTMyIGN0cmwsIGN0
cmxfZXh0LCByY3RsLCBzdGF0dXMsIHd1ZmM7DQo+IMKgwqDCoMKgwqDCoMKgwqBpbnQgcmV0dmFs
ID0gMDsNCj4gLcKgwqDCoMKgwqDCoMKgdTE2IHNtYl9jdHJsOw0KPiDCoA0KPiDCoMKgwqDCoMKg
wqDCoMKgLyogUnVudGltZSBzdXNwZW5kIHNob3VsZCBvbmx5IGVuYWJsZSB3YWtldXAgZm9yIGxp
bmsgY2hhbmdlcw0KPiAqLw0KPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHJ1bnRpbWUpDQo+IEBAIC02
Njk3LDIzICs2Njk2LDYgQEAgc3RhdGljIGludCBfX2UxMDAwX3NodXRkb3duKHN0cnVjdCBwY2lf
ZGV2DQo+ICpwZGV2LCBib29sIHJ1bnRpbWUpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoGlmIChyZXR2YWwpDQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZXR1cm4gcmV0dmFs
Ow0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0NCj4gLQ0KPiAtwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgLyogRm9yY2UgU01CVVMgdG8gYWxsb3cgV09MICovDQo+IC3C
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBTd2l0Y2hpbmcgUEhZIGludGVyZmFjZSBh
bHdheXMgcmV0dXJucyBNREkgZXJyb3INCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCAqIHNvIGRpc2FibGUgcmV0cnkgbWVjaGFuaXNtIHRvIGF2b2lkIHdhc3RpbmcgdGltZQ0KPiAt
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICovDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBlMTAwMGVfZGlzYWJsZV9waHlfcmV0cnkoaHcpOw0KPiAtDQo+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBlMWVfcnBoeShodywgQ1ZfU01CX0NUUkwsICZzbWJfY3Ry
bCk7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBzbWJfY3RybCB8PSBDVl9TTUJf
Q1RSTF9GT1JDRV9TTUJVUzsNCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGUxZV93
cGh5KGh3LCBDVl9TTUJfQ1RSTCwgc21iX2N0cmwpOw0KPiAtDQo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBlMTAwMGVfZW5hYmxlX3BoeV9yZXRyeShodyk7DQo+IC0NCj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC8qIEZvcmNlIFNNQnVzIG1vZGUgaW4gTUFDICovDQo+
IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBjdHJsX2V4dCA9IGVyMzIoQ1RSTF9FWFQp
Ow0KPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY3RybF9leHQgfD0gRTEwMDBfQ1RS
TF9FWFRfRk9SQ0VfU01CVVM7DQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBldzMy
KENUUkxfRVhULCBjdHJsX2V4dCk7DQo+IMKgwqDCoMKgwqDCoMKgwqB9DQo+IMKgDQo+IMKgwqDC
oMKgwqDCoMKgwqAvKiBFbnN1cmUgdGhhdCB0aGUgYXBwcm9wcmlhdGUgYml0cyBhcmUgc2V0IGlu
IExQSV9DVFJMDQoNCg==
