Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C88A50
	for <patches@lists.linux.dev>; Wed, 13 Nov 2024 00:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731459232; cv=fail; b=YvR4zmHlp/4LYHcyxrXT0eYG62e4f/p08aFKWYdQFnxM5L5O9Whf1kas/lhCbIxqOn9VykRlrlKnylIBFS7tIskH0d0FYZ5STN+Lq/r+Pw5K0AH/my84CRNGizufC53dbO49EvKI6StA4HvNcENjn2SnquT5SjNluipq6p1MQ0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731459232; c=relaxed/simple;
	bh=AnQNb2V7QSKLsl384sw615P1XvQBIa2V+3FuQBB3/6A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eSpmuk5FHhMQtC00E39G/c6TvOnPPnBBRlpbTVbM+MsR+btvCyUSnTOomIxXp/B00Jd7PZLTRq2N1dzTh79UVHpwXWJWjf9YwHU6GVUpaZFT4VHH+UcH3H8PE3iFep9CjO0GUFdXvd4Py+oJT91t7HBo8qTu0CLAw9Cj67/9cIA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6F0QsFa; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6F0QsFa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731459231; x=1762995231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AnQNb2V7QSKLsl384sw615P1XvQBIa2V+3FuQBB3/6A=;
  b=m6F0QsFa0pAyAsWAmV+LvGnNjwHhajvhjVAe50UKQ9EdR7sqkeKrb5Wr
   U8ve0qsdFi6o0pJZn+HPF8pgnwKSni0onBjthyy1PzbF3X/1wJntdvxv9
   HD5cURgGUaW6LY6nARr7YQa4py2hm1q6QWVHbV26HRhpH5AQXyxXaXcmi
   iEK4qgtPq/bt8CevejBmprU8qOFnLoGFEJMDWZjqOFFGynhSPTNx6PuKD
   rXdnBUwy8/7Yq/YycK0FVWePzmrJ7tO+RF2hyVBd0jrnVaisRtMI3RI71
   w/DePIvgMUb/YrMWKc6Q+j5e84xdVQHiFag5O7BpDwDWh/5vwo1tr8Ev9
   A==;
X-CSE-ConnectionGUID: axuJYd8IQDG76pZP9MPZyQ==
X-CSE-MsgGUID: sDfkxqS1RFezRi5zgYWoGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="31292343"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="31292343"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 16:53:50 -0800
X-CSE-ConnectionGUID: zlZpvcwKSua9UhUUZYyBMg==
X-CSE-MsgGUID: Uxv5bp0uRYOQMUtcLwW33w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,149,1728975600"; 
   d="scan'208";a="87446097"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 16:53:50 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 16:53:49 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 16:53:49 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 16:53:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xREdOfSBUA6hRNKLcN1IcsgXSWeajLD5OcnrdyrvilEnFexl/HnvpN32v6dVTJNFe6ZudzVVUk/soAFrYi+e7OCbF4LVb8RPzfOpsQyLXsoYvHdqdICqsog1PBvYNDIN3GQVqlJ/evmdJF6ZG0nd1iG24t7bWqZoCJCdUGn0s4A4TTi50VXLIdyc8DOw647GU/0WjL5mYoukPRvgqJ8u/sLI4a2KvOtkHs0C+Y5fgByOFEj3GcfMeN9i4YGH9++fDsOScUSHaAnmJAMUteRQeE3aZ94uXkpzhEm13vaysAv6hjcNxd7dhfhtVVmpMe2XBJbIxeT14RIh47wRpA2lMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AnQNb2V7QSKLsl384sw615P1XvQBIa2V+3FuQBB3/6A=;
 b=uhAARyczw1rYcTEvB+6+Hk5SBuAQrKA3cCLLqrcaCfISye/NrQWiYr2uNWugVwETXOulTewb2at9eTlXR8yLTwcEwQdHkQwLtCBESQ+KbVzTnbj/4rG1Z9cwXa6Ynp23L/zmhh98HjD1vU8OqPhArSyG47TI4wqzsvuPVotg2soTXSvClxnLW+wr7ovLzCRd+81HVpVTNcreTZfc/ErOGYja29l8i9s7qnN4JcM53tsCIvlLRdVk7XvjoEWNa0huHJBPlCrAAGlrecdUycl6vu0ruyppXk+PIrdLZ/Fvwf5QbBDzlGJ7F7Dy5CpYaC1YdNM1l8fpVS64RhCbSfHgMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB5867.namprd11.prod.outlook.com (2603:10b6:a03:42a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.29; Wed, 13 Nov
 2024 00:53:46 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%3]) with mapi id 15.20.8137.022; Wed, 13 Nov 2024
 00:53:46 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, Peter Newman <peternewman@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	"x86@kernel.org" <x86@kernel.org>
CC: James Morse <james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>,
	Babu Moger <babu.moger@amd.com>, Randy Dunlap <rdunlap@infradead.org>,
	"Shaopeng Tan (Fujitsu)" <tan.shaopeng@fujitsu.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to ctrl_mon
 directories
Thread-Topic: [PATCH v8 5/7] x86/resctrl: Add "mba_MBps_event" file to
 ctrl_mon directories
Thread-Index: AQHbKigGh0B6ec32lkmFla4NSGoe2rK0S6OAgAAW5uCAAAzFAIAABxAA
Date: Wed, 13 Nov 2024 00:53:46 +0000
Message-ID: <SJ1PR11MB6083ACCB3B5D602CDA9F2269FC5A2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20241029172832.93963-1-tony.luck@intel.com>
 <20241029172832.93963-6-tony.luck@intel.com>
 <bb4741f3-009a-41f6-b495-3408d9abbff7@intel.com>
 <SJ1PR11MB6083839383802DC9127C5CD2FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
 <c748f9d5-ef10-499e-bde5-1bce20a44d2d@intel.com>
In-Reply-To: <c748f9d5-ef10-499e-bde5-1bce20a44d2d@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB5867:EE_
x-ms-office365-filtering-correlation-id: adbd3c63-3572-4520-e5b6-08dd037da133
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0V4aFRiSFRIVEVQeHBPNmtHWmk1QVIvYkx0UUl1VlJML1hLK3JZK2dERUg4?=
 =?utf-8?B?L2dneHJFVTNrYm9JRyszTTF2MGVMQWhEMDR2YXlFeTAxbE1JOHZYempKV3F0?=
 =?utf-8?B?QW0vZWhHUDR0MDMxU2ZkVFpKYjA1b2lCZHVOekFUK2VFZUdDVmVYNGdtOUYr?=
 =?utf-8?B?NWRFZitHclBmZmxqUXJPSEd3QnJ5UEEvdHFrL1hscmpabjFCV2UzcHM4OXM1?=
 =?utf-8?B?aklYSUEvbnJ5eTl0bWttc3N2R2M5MkdFZ0YzOXJ5VGFmREliWUJNUE85M0tl?=
 =?utf-8?B?dlRTRUFtenhOQmZtSGZad3RCSE9tNnJMNyt3Z05DOUMwUDFXRjZhbGhnU2hp?=
 =?utf-8?B?OG1SekQ0a1o5cGdVTWtOL3Fsenh6OS9rdjl0a3AzVXgzUVBncEpuZ3BSejdv?=
 =?utf-8?B?ZXk5ZHFWWFcweG5TbFNzTnhHUzNMRHY0WTNuZ0Q5ZzErVE00YW5TeHpxdFZQ?=
 =?utf-8?B?OUhabTcxNlZMSFc1aFVXYjBFRk0rR0VPelRrWDdjZ1plUkVsSGtBQXR2eG1l?=
 =?utf-8?B?T1E2RGNzSTI3RjFKUkFXN2VQMEFHd0NsSEJFYmxMaHhXaXczdkprOXd6MHNW?=
 =?utf-8?B?bmJMS2JwUEp6aGl5VUNlbjJTWUNlaVdCTVc2cElpRFhkUlZQWXlGQ3p6cWxR?=
 =?utf-8?B?UDlFUituU3FkQW82bjZ1cTU0dk5BOFBBbFlmbEx3aml5VDg4N0I5eHNXbTg4?=
 =?utf-8?B?bUM1UHlMaTIvYnkyVEVaeVptMXRuYklkaGF4a0J6Wm5vT3RscTJlT0JjT3JL?=
 =?utf-8?B?RzhPMW5OL2FHQUhzaXVUcXR6Ryt6dXVDZTdpTVVJZWNFWlN0TkxtZGljVTI3?=
 =?utf-8?B?Y2lEc3RwcVhrcFNNMG5EN2N5anRSVGVYWHFwQ3YxWlYvVjBnQVNoR0lUV3JS?=
 =?utf-8?B?ZEhvWGRiMEZqdmZVUTYxK0J1WjdsSlU0dVp0ZFdQOTE0R2JCL2lRWkM0VVFa?=
 =?utf-8?B?bkFLRGx6OXZwY1JnN0M0NXBSSG1oRGFRekpLUzM4ZVhJeDR1SUxuMHdkOU1s?=
 =?utf-8?B?Zmo0cXZXVUJNancxUUlTSUJhUzU4dzBDb0VML2ZYZGx6ZHZEdE51SVM2cWUz?=
 =?utf-8?B?Q1lVTEgrM1Bsckl0YW04d3Q2OU13U1pPYytmcDRHN0V3Um91R2ZCb2pYY1BQ?=
 =?utf-8?B?cU1GUzBYRWlsUEdDVENiNC9KYlV1OXJKT2pONVhyM0Qwb2YwSkxOaENEMDZh?=
 =?utf-8?B?N2N5RzdvNldrT1JiYVVxZzZPd1VrV3pDdHRseFd2YU5BVjZhdERwWnlzWTlq?=
 =?utf-8?B?UGtDdHFWTVNwVTZ1N1ZQWis0RlhENHMwTXFsWnh5K1JKM3p5Z3BaK2ljNFpX?=
 =?utf-8?B?NFlXemJWZ2Z1SGttbWNoWGlUbWpwU2o1U3F2WDlSZTVCbmNTNDJPdWhSSmhw?=
 =?utf-8?B?dExoR3kveDRHYnU1eTJNcGtFbWwwWEJRaFhiV0R0anprZHhLdENQa3FDYXg1?=
 =?utf-8?B?aXlxdkVjRXVjNG4wUnNvWnRRUlV5bTQvREF1YllGREJJdm9JSkQrMDJjQ1Ro?=
 =?utf-8?B?WFFuT1BmZVhkY0l4YTUwekxKamt5K0JRNy9xR3NrWXRPMjhpNGFmLzM1eXU2?=
 =?utf-8?B?WUU0TUI0c3l3OXdvU3UxWHUvV1k4ZjdjMXJCSFN5c2ZNcGpUcXFtcTlBU0Zx?=
 =?utf-8?B?OEp0TjFZVml2a3MyNTFtRVRKVHpIcW9QbW5RWVlWaGdpMFZwL1RYZktVTmNK?=
 =?utf-8?B?WmFEUksxdTFLQlluM2E0YUdTWTZSQ2lmcllUOUdwQk5uMCtrRTVoNkJEeEF5?=
 =?utf-8?B?TmVKV0kzUVkvb29oV005eGZqWFRwTVhpZnFRSFliaHNqSGt6cTlJbGlVVkY0?=
 =?utf-8?Q?ejJjS96oJFRUZoOc5/XHrcffSm8hsblmKLHy8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDNMNkJ3TE1hOWVIU3hCLzYvcmVma29rY285RW9FWjdZZ08raGt3a0tZeTlq?=
 =?utf-8?B?Um8vOTgrSFVzMnYrZ1VhVnBaaHRuRXZyeXp3MjI1c0x2dTNTZys0Und4azZW?=
 =?utf-8?B?d3hCZkNUNWpBYkFZREtMNnVrT0hEOGJzdHdBZEtQcWpBdTY1bHNucXM2VThK?=
 =?utf-8?B?M21icDJ3M09qQ0k5Yy9KQUJRNjdBaEI0czNqaUZaanp6TlpnUU1lOC9VdWtG?=
 =?utf-8?B?eGtvK252ZjJJZGVzcC9ibmt2SkNEZ3J0RmgyY2FOUTYvM0lramM3YklqejQv?=
 =?utf-8?B?eVJOLzlqcXBQSzd0dHRRdDV6akpBN3dKRDBobC9EcXdwMGtqaDdoQ2VvdWRN?=
 =?utf-8?B?WElTTlpIa1FpWXZtREFqTzNuUDNjUTJnNFRYT0xDeTdrQTVDcXdOR3FUMnVO?=
 =?utf-8?B?TnVoZEJJb1RhbHluMkhWREp6ekFqeWZWdFVkL1IwUkxmYkQ2WlgrRnQ4VGZu?=
 =?utf-8?B?OG9FRDJKWW41TGtXaDBIV2tZWmk4U0E4a0hQUHZ2dWh0eXB2MkwwakxQNk9s?=
 =?utf-8?B?TXRsc3NxelFKeEl3VFhhdFlFaFE4U3JGZWtCaXl0ZTVSK09oL0tlVEF4ei9z?=
 =?utf-8?B?NitPSkxrbUx6UUd3NCsvbjRiWU1MWG5MSjZ0SlJXWjdrTy8yeEJQbXR3SllH?=
 =?utf-8?B?TklmdUF3U09WYnBYT043T3V2enVVVEVtTlV1MWxuVm5BT2x2cnpJYVVySkNt?=
 =?utf-8?B?bmQ1TUxzMGVmdGdQQVZDSDVFMU5uQTZPc3VtY0I3ekNKaWx0YmVxYkJhNmVY?=
 =?utf-8?B?Nnk0ak9pcHM0VVlSS1BkV1o5N1pBb1hLSkVJd3FSajVHOFdVZ1N4eFRaR0lV?=
 =?utf-8?B?SFRlQ0Z6aThYUHREVlhhdmhXUkpud1ErSFVwWGd2SFpYb0t0OXYrS0xCZ1hX?=
 =?utf-8?B?a3N1MXFGdXN0MVQ5bnJreUdSTHZsak1LOUtGemZFTU81TDZXU3JkemF3Mzcy?=
 =?utf-8?B?UzRmbDJKc2w2OUFEMEtXdmZoc0VLUkVVZXlLTjBlVE5TQ1VjSTRMcElLT29P?=
 =?utf-8?B?ZDd6ZVNxQmU0a2FDdS8yVEFEZVNjRmZCRG5jT2U1TW55TGV6Mnd0eS9lYVpE?=
 =?utf-8?B?a1FMNm00aTVWVFdNSHM3dzJndGxQU3B4RUZYbThtcTNOZnpSbzdndGNnRDI3?=
 =?utf-8?B?eDZzMkJocWxhcnIxL1R3eFYrS0FlU1NmZ0dZMjlIaHQrY3g4c0ZVR1pXN0w0?=
 =?utf-8?B?Zy9iZEVGRDNkZFRudVhCK0UwVHpoNHBWb0s4UC9ocjJaVW5TWFpEVVlWdXA5?=
 =?utf-8?B?TEFFVnkyeFdqM3UrNFB3OW5wNVNwVEtXNnk3aEZMakZiRVNFenIwc1lKWjRJ?=
 =?utf-8?B?NTQ0L3k1c1pRWXlMUGdGeitXbjg4WnlCbXNuKzRBaFFveWFiKyt0TGxMdTE1?=
 =?utf-8?B?NW1xVTBBWm1QZWZsL1UrMHppZlRRSVgyelE3WnNqa20rL1dES3dkTmhHMTFm?=
 =?utf-8?B?dUpEZkYzb1RHV1h3WURFQ1ZHMnduUkhxOFRySzFsR3lUcXBZd2JYR0MyR0Jp?=
 =?utf-8?B?ZmwrTnRka1p4Y2xWQmhENGdOM0tRS0ZXVDRIejR3VVBLS3g1aWxPNElFUi81?=
 =?utf-8?B?UkFwNForbmcydDZESnhZSGIxK0hSUWE2QThEYXhIL1p5c1orbGFmNEh3T3JZ?=
 =?utf-8?B?RFBCWllEejFVTVN3OUpHQlo1cFlLOC9Vb3k1SDNvOXFXazFJR25JeTFibkdO?=
 =?utf-8?B?eVdhUWlUbDJqSXJ5UlRGRTg1RTRzZTJlYmI3RkxqL3hjRmgzTG1XMGZzZGhP?=
 =?utf-8?B?bThnaFhuRHVTYUg5czZWRmRsK2xXNFJmOUtoUjA0VlRQN3A1cCtmWEpxYnI0?=
 =?utf-8?B?UCtxcWUyaHRDOEdyVlh3SS92bEhMNVp2VlJzVTZKK2greTN6aHNac0hlRnZ0?=
 =?utf-8?B?MVNIaExVRlBvNElKUnl1WXpGUlJzN1ZTSFUxUW1oZUxiSE1OWFN1RGw3cDlz?=
 =?utf-8?B?aS9mS1JRY0tqWXQxUlh5UXdKRmE5NDNPSzBqeGQwMzJCUzFQYVdxYnU0K0tH?=
 =?utf-8?B?VDBuMkorc3Z5V2NFQmlMNVB1SndZVk4xcWkzNFppVys2U3hmdlRmUFhVT1h0?=
 =?utf-8?B?VTFNdE5XQmtsb0VqMnZkdzZpM3MzZFFLUDhnOTVwdjJaVkpUd3EzbW5iZThP?=
 =?utf-8?Q?sJqgKlrnBboA7BQHef1ZMvQmu?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: adbd3c63-3572-4520-e5b6-08dd037da133
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2024 00:53:46.6686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Twvcm/Lo7xqH/rvZ3C+80fO7/n9JJ/jZj9YnciFnOuEV5qkQiRYAEoRECkQ/TVjxg/7frJt0Ycre2GmiYDjutw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5867
X-OriginatorOrg: intel.com

PiA+Pj4gK3N0YXRpYyBpbnQgc2V0X21iYV9zYyhib29sIG1iYV9zYykNCj4gPj4+ICt7DQo+ID4+
PiArICAgc3RydWN0IHJmdHlwZSAqcmZ0Ow0KPiA+Pj4gKw0KPiA+Pj4gKyAgIHJmdCA9IHJkdGdy
b3VwX2dldF9yZnR5cGVfYnlfbmFtZSgibWJhX01CcHNfZXZlbnQiKTsNCj4gPj4+ICsgICBpZiAo
cmZ0KQ0KPiA+Pj4gKyAgICAgICAgICAgcmZ0LT5mZmxhZ3MgPSBlbmFibGUgPyBSRlRZUEVfQ1RS
TF9CQVNFIDogMDsNCj4gPj4NCj4gPj4gSSB0aGluayB0aGlzIHNldHMgdGhpcyBmaWxlIHRvIGJl
IGNyZWF0ZWQgZm9yIGFsbCBDVFJMIGdyb3VwcywgZXZlbiB3aGVuIG5vdCBzdXBwb3J0aW5nDQo+
ID4+IG1vbml0b3Jpbmc/DQoNCkkgdGhpbmsgSSBtaXN1bmRlcnN0b29kIHlvdS4gSSB0aG91Z2gg
eW91IHNhaWQgdGhlIHRoZXNlIG1iYV9NQnBzX2V2ZW50IGZpbGVzDQp3b3VsZCBiZSBjcmVhdGVk
IGV2ZW4gaWYgbW9uaXRvcmluZyBpcyBub3Qgc3VwcG9ydGVkLA0KDQpCdXQgbm93IEkgd29uZGVy
IHdoYXQgeW91IG1lYW4gYnkgImFsbCBDVFJMIGdyb3VwcyIuDQoNCj4gPiBOby4gVGhlIGNhbGxp
bmcgc2VxdWVuY2UgaXM6DQo+ID4NCj4gPiByZHRfZ2V0X3RyZWUoKQ0KPiA+ICAgICByZHRfZW5h
YmxlX2N0eCgpDQo+ID4NCj4gPiAgICAgICAgIGlmIChjdHgtPmVuYWJsZV9tYmFfbWJwcykgew0K
PiA+ICAgICAgICAgICAgICAgICByZXQgPSBzZXRfbWJhX3NjKHRydWUpOw0KPiA+ICAgICAgICAg
ICAgICAgICBpZiAocmV0KQ0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0X2Nk
cGwzOw0KPiA+ICAgICAgICAgfQ0KPiA+DQo+ID4gU28gc2V0X21iYV9zYygpIGlzIG9ubHkgY2Fs
bGVkIHdoZW4gdGhlIG1iYV9NQnBzIG1vdW50IG9wdGlvbiBoYXMgYmVlbiB1c2VkLiBTbw0KPiA+
IG1iYV9tYnBzX2V2ZW50X2luaXQoKSBpc24ndCBjYWxsZWQuDQo+ID4NCj4gPiBOb3RlIHRoYXQg
b24gdW5tb3VudCBvZiB0aGUgcmVzY3RybCBmaWxlIHN5c3RlbSByZHRfa2lsbF9zYigpIGNhbGxz
IHJkdF9kaXNhYmxlX2N0eCgpDQo+ID4gd2hpY2ggY2FsbHMgc2V0X21iYV9zYyhmYWxzZSkgd2hp
Y2ggd2lsbCBjbGVhciByZnQtPmZmbGFncyBvbiBzeXN0ZW1zIHdoaWNoIHN1cHBvcnQNCj4gPiBt
YmFfTUJwcy4NCj4NCj4gSXQgc291bmRzIGFzIHRob3VnaCB5b3UgYXJlIHNheWluZyB0aGF0IHNl
dHRpbmcgdGhlIHdyb25nIGZsYWdzIGFyZSBvayBhcyBsb25nIGFzIGl0IGlzDQo+IGRvbmUgaW4g
c29tZSBzcGVjaWZpYyBjYWxsaW5nIHNlcXVlbmNlLiBJcyB0aGlzIGNvcnJlY3Q/IFJlbHlpbmcg
b24gY2FsbGluZyBzZXF1ZW5jZQ0KPiBpbnN0ZWFkIG9mIGNvcnJlY3QgZmxhZ3MgcmVxdWlyZXMg
bW9yZSBpbi1kZXB0aCBrbm93bGVkZ2Ugb2YgY29kZSBmbG93cyBhbmQgbWFrZXMgY29kZQ0KPiBo
YXJkZXIgdG8gbWFpbnRhaW4uDQo+IFdoeSBub3QganVzdCBtYWtlIHRoaXMgIlJGVFlQRV9DVFJM
X0JBU0UgfCBSRlRZUEVfTU9OX0JBU0UiIHRvIG1ha2UgaXQgY2xlYXIgdGhhdCB0aGUgZmlsZQ0K
PiBhcHBsaWVzIHRvIENUUkxfTU9OIGdyb3Vwcz8gV2hhdCBhbSBJIG1pc3Npbmc/DQoNClRoZSBk
aXJlY3RvcmllcyB3aGljaCBuZWVkIHRoaXMgbmV3IGZpbGUgYXJlIHRoZSBzYW1lIG9uZXMgdGhh
dCBnZXQgYSAic2NoZW1hdGEiIGZpbGUuDQoNClRoZSBpbml0aWFsaXphdGlvbiBvZiBmZmxhZ3Mg
Zm9yIHRoZSBzY2hlbWF0YSBmaWxlIGp1c3QgdXNlcyBSRlRZUEVfQ1RSTF9CQVNFOg0KDQogICAg
ICAgIHsNCiAgICAgICAgICAgICAgICAubmFtZSAgICAgICAgICAgPSAic2NoZW1hdGEiLA0KICAg
ICAgICAgICAgICAgIC5tb2RlICAgICAgICAgICA9IDA2NDQsDQogICAgICAgICAgICAgICAgLmtm
X29wcyAgICAgICAgID0gJnJkdGdyb3VwX2tmX3NpbmdsZV9vcHMsDQogICAgICAgICAgICAgICAg
LndyaXRlICAgICAgICAgID0gcmR0Z3JvdXBfc2NoZW1hdGFfd3JpdGUsDQogICAgICAgICAgICAg
ICAgLnNlcV9zaG93ICAgICAgID0gcmR0Z3JvdXBfc2NoZW1hdGFfc2hvdywNCiAgICAgICAgICAg
ICAgICAuZmZsYWdzICAgICAgICAgPSBSRlRZUEVfQ1RSTF9CQVNFLA0KICAgICAgICB9LA0KDQpJ
IGRvbid0IHNlZSBhbnkgZmlsZXMgdXNpbmcgLmZmbGFncyA9ICJSRlRZUEVfQ1RSTF9CQVNFIHwg
UkZUWVBFX01PTl9CQVNFIg0KDQotVG9ueQ0KDQo=
