Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10A5F8C11
	for <patches@lists.linux.dev>; Wed,  4 Jun 2025 22:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749077232; cv=fail; b=QDssLtp31rV28AD/iKZ/O+oJb2qTnMl3P1K2+v/SY/BzGVerocqhj+dB41Ea6ymtLcOIsadvnibPdI5UWbCf0QAd9gJvohuHUmUpQnNwb8twcFZEQJ6SIGs0YvlEnQ6Ih9UtDSh+//eXOMXRZoD4NOO4RoCIaUIdkKNli78TjpQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749077232; c=relaxed/simple;
	bh=vGb4ozV/enoHvdY/HZKPOV1PpbXyQOwBhrBEisVblRg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FMwQqFRa79BWPv8+mXCzEv1NVu0IS3it1xwvTdeMSAV0QtnQXzbdqANyZT+qgj+DOkahl3K+MJ6AErWrj9SCiYzsJVZ+6inyGgOlookUzQnKSXXYM2zUqclOK2aAeNbXJgDlpOZxixm6c5QEz5NANdUr48UxxerjsmxK9jPhZ8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ByYk6xKk; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ByYk6xKk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749077231; x=1780613231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vGb4ozV/enoHvdY/HZKPOV1PpbXyQOwBhrBEisVblRg=;
  b=ByYk6xKk2w9zivPzhcKT9FV+z2MpailUIKhWG+IlBR5ToFUksCjCn0o1
   eiqsHV0keTb6JnNhazWUb8KPAvoCziGzttkUP4e2DD2CpAPBH59TCgtDj
   Nxr0zD2SnrjJicBJHwwMj4fG6IIGYmfZsMvzNaVx6usRfr/HY/qFE7aJk
   wTLzYtTxKrC9CA8dNOGWAlKQNMhE5mNM6CPR/cSJwKgrJ+kr2PcdranBm
   kgttmfs6GHS9/Z3lptQNwFApxyw4KCRm1qkmE9QVnqkTRHt0DN55LVcI/
   EwGA8XDjkShjNENs5KbG+FEfSwt3t/KkA8dzeqJgRWcQQFaysV8CgDZWe
   g==;
X-CSE-ConnectionGUID: 2iENUqQIQeuSKpEKPOczDQ==
X-CSE-MsgGUID: u3UI0PWST763k/EQAzQoWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11454"; a="76579007"
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="76579007"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:47:10 -0700
X-CSE-ConnectionGUID: g7efuzOYQf+88R5108sOHg==
X-CSE-MsgGUID: BQBaslmvTx+JTVkQFJniUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,210,1744095600"; 
   d="scan'208";a="150114354"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jun 2025 15:47:11 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 4 Jun 2025 15:47:09 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 4 Jun 2025 15:47:09 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.65) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Wed, 4 Jun 2025 15:47:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WwGbkoZVW/AUxr2p4iCE+Va5tPmklzN0a9/xeIdjZOAk8GunxsKBwMGPycqtvaVBHX6c95YucDATBqf67AJBCyOumIa1vCvUMa72XrQ0OYqzKg5ehXYsrxCFGi09UjuPrLMHNUWRmtY+orjBBIydkDVY5xsRB3kNSvYdqK8lVAYBmUUiYFU8NfgqEP8d7N88uDb3JGFluQsouKW1b8CKXnLD1r7GsC9B9LhmkAnxpOg7DOuoW1DKTWUV96wH57WoWFHUnWcuIr47nPMhC1RBeKyJ3SCpoyzdk5ZrOna3cTdQdP0ydONA1aVll/HVbYJgXE/9hKiGmIGhHb8ldxVShg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vGb4ozV/enoHvdY/HZKPOV1PpbXyQOwBhrBEisVblRg=;
 b=cWko2BM6tF/QEmH70tC7o/SEm5MCH0quHWkHGRQvmGn7YPiiEHyBhMTBTld/kwvEyuPEtmtJdyYadFNI3143OL2+o/ioESFCD01stvBIkX89ER/7+DM0KVOedejVSabNJPCH8UcP6kYjMpPoewLUPUVtGHc/j9qIHwOx57Rz9tB7wBe32wdjO+3Wisa/j2bgfi51AzJxmuSRHKFBF90sCjyfgVxq/u1Ii1LttFTKU91hnlo7QiZ/yA5sPD2kFhkn+0xozR7X4LGWV3vTOiGrE3up8UgBwTNVVS5ouk6H83bRw4BKnSuvyf80viZ3miMSM3yU66DyrK4xMj+lVAuG6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7507.namprd11.prod.outlook.com (2603:10b6:8:150::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.32; Wed, 4 Jun
 2025 22:47:04 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8769.037; Wed, 4 Jun 2025
 22:47:03 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Dave
 Martin <Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v5 1/4 UPDATED] x86,fs/resctrl: Consolidate monitor event
 descriptions
Thread-Topic: [PATCH v5 1/4 UPDATED] x86,fs/resctrl: Consolidate monitor event
 descriptions
Thread-Index: AQHb1ZbBYimCtT1AgUS6fjhJqNBRdbPzkusAgAACZwCAAAMFgIAAASwQ
Date: Wed, 4 Jun 2025 22:47:03 +0000
Message-ID: <SJ1PR11MB6083B072C126CEBD6C2D52BAFC6CA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250604212208.49080-1-tony.luck@intel.com>
 <20250604212208.49080-2-tony.luck@intel.com>
 <bb7badd8-dddf-41f3-b509-42cdd4539fbd@intel.com>
 <9e8c9810-1b5c-4e30-8b10-c3702810b529@intel.com>
 <2953c1ec-cd92-490e-9b7a-04b10fb98e14@intel.com>
In-Reply-To: <2953c1ec-cd92-490e-9b7a-04b10fb98e14@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7507:EE_
x-ms-office365-filtering-correlation-id: ee85a212-135e-4b22-4ca8-08dda3b9b9d3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MVd4L1NITnVJZXpTeVhUdW1MaGJnSVhCMGRKbm1WRFd6U1JGaG03MXJTMjZU?=
 =?utf-8?B?VnRIbFBPYWI0Wk9xM3ZrUkUzZDFHdHpteU1HN3N0VkVzYm5MU0Vlck1NODdp?=
 =?utf-8?B?Q21zb0F1QTlvUVVKblI0VTdLWXQ0akp2U3loYm5IYWI2NUFGZGlEbC9oUHhP?=
 =?utf-8?B?SWxyL2JLYmJjYWJBM2RTWHlLL210ZVJPNjBQa0o3aXBOYmpHRFR2ekowQnpO?=
 =?utf-8?B?c3cwMlFLQWxPdDRxY0hvTXlMTnprMWRWTFo4d3k2K0U3enY1TlEzQ1Q4OVlz?=
 =?utf-8?B?VjcxcFl5NHRFeHNZSlNIcjZOc2hOK2t5NUMvNk5SbmtjZkdaMU15bGIydEhp?=
 =?utf-8?B?djNVWU1DOXF1RzJ4QVZlL1dyU3Q2WEUwRXMxd0R5MlArNTN6WnJhc0drTk9x?=
 =?utf-8?B?ZlhsUENzZ2QzQ3Flbm9IcE9lVGREN0cyYmloOWRRVDd2Q3ZpN1FiTG55bkJy?=
 =?utf-8?B?WmhBRE5QR3d6N3ZFWUlDclByd0hBQmdIRER4ZGlIVTFpMXJCenZ2Nk5BcHVD?=
 =?utf-8?B?Z0c3MStyZkVGNnNmNjBMMHh0OTNVc2FMR3M2Ujd5bjlMT0VKYkVBU2laMUNR?=
 =?utf-8?B?L2Fjc3NCY0Zpek1CYk5IcmlGMkVqTXhvTVNsS2xHek9Qd0ZqZjdrNTQrbW40?=
 =?utf-8?B?QVRQdUJZRG5VcWRqWjhMQTh6YS9sem45NUthR2hTMmRTYmZzaldaVERjSVd3?=
 =?utf-8?B?KzZyOVhQKzdKS2tTdkxtSWdtQ2lMVGFQR1p3ZHVRNkZqL21yVURLTnpwZ1Rk?=
 =?utf-8?B?YTJMbDJxd1lXWFQvd3pvKzhGUFRBQTBpZDlNcnhJemFJMzQ4d1owRU1xN1gw?=
 =?utf-8?B?d1B0aFZSSkJZNVJDL2ZBMHRDYS9DdGRRUm1EWDBVb3AwV082NXpBZFRyNmVx?=
 =?utf-8?B?b2w4WGZCYmtaVHhSc1VaaU9kMnMzMlIxTmRTVnYwckx2bmM5bWJ6RENlUDVQ?=
 =?utf-8?B?UzNhV0Y1Z29ZZkpJNkFpSHBLTmYrYXVlM2VjRSsxVVNYc0Q5akt0THFyak5N?=
 =?utf-8?B?Q2JHR3ZPRFJYdmZCZzZtMi9XUHhSeG1zZENVY3F1cFhTd1RuampZdCtpTjF4?=
 =?utf-8?B?cVV5YmdLcjVDTVcwNngzZGMyV3VnMVFUS1R3NUk1Umh5TnJhY3hCT3lBMjRL?=
 =?utf-8?B?L0VsTEZtL1Q4a0dibEdiNzVWajFHTmgyTi9mMENHbnVHZXU4cEhuWEI4TUFv?=
 =?utf-8?B?dFFIYlYrWGRQRlBkRkFCMU04WGczTFZqM1F0bnlhMGU1bGFyVVgxU0NnQ1lQ?=
 =?utf-8?B?QnBVb0VlNVc4RTZNVzR4cmx1ZHFBZ0RjTEFSUnR1MGNXOTJvNFM3Y3l3anJr?=
 =?utf-8?B?L3hHSDJDT2VlWDRkQmRSZE94R1RQZzRnWkRaSEVWdkFYL0U4WC9mV1h3bHVi?=
 =?utf-8?B?bnNlK1JLQzBWSTNoM3NGekdqb1NIMkJCMVZ1ZE94ckh6R3NFbDE3SnNLSmE0?=
 =?utf-8?B?bnM3L1BObUcrNVhxbEVueWJsQm0zWVE2RXFnZ0MyM3g0VlBNTVBpQmpvdGhZ?=
 =?utf-8?B?Mkl5WlFyRXNHa0dKV2lSN3huaDM3UnhyaEJUQ3ZqWFR0WVJlcE9YRTJaN3JY?=
 =?utf-8?B?czlINFp6NVM3S0RQU2xHc0EvRFcyWWRPejlHTFpDL2VkRHlwUGlUM2tsTkdk?=
 =?utf-8?B?Y2k2OFVHdDY0NmVDTGNPQnJwT1l3RHhUVnY3UGpMZ1NmZE1JaTdJRG8wNFVR?=
 =?utf-8?B?aVhRUEd4TTNaMldsOEMyR0VKU3V2Vjl5VEMraUFiZy9udmlWZDl3SjNWQWtt?=
 =?utf-8?B?OURUeFJkRGFkaUJjSG1aRnBaZjgrODVBTzl4Qm5KM1FPTmEvMS80TlhWZFho?=
 =?utf-8?B?ZzZKVjNQc3VjS25aaTdOYi9SV2J4T2NUTGxOMjFkUTc4KzhXbDZiZGR5aUho?=
 =?utf-8?B?NUN3UXIxSGRjdGk1Q1Bvc0pQMjgzc1d3bk1pbHIrb2NORHJJck82VU80NG9M?=
 =?utf-8?B?K0J0ZGNsYVJKekZRQTJ5SWF3TUZWcmVsNysxSGdyUHh4b2hmZFI4b3FYU3U4?=
 =?utf-8?Q?gxlMThvAbtFFLWBU3syGUPxwNFKTCI=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WE82eFlwU0ljaDNIQ1FQQmxpMFhiUURoNmZWNCtBeS9tT25xWXEzaUkzdDRv?=
 =?utf-8?B?dzlwS2VWQ1FRQko0c09aSUtZa3l2UGk0WTdBSUFHQk4rYjdNKzFnTlFBdFhu?=
 =?utf-8?B?Nmx2RENiZWFLT3lvcWZiVHkxNDhMMlN0NUkya0xSVi9ndjJnenhteWZlc1ZS?=
 =?utf-8?B?dlBVMDhVbUlTL01NZ1lINTRRVXpKdjVtQkhXK0VVTTA3b2FxWGtrSmlGVWt4?=
 =?utf-8?B?dUg4OE1SaEc1djlmcm9KdEZ0QnhXTkFCaTdGNFh0YlF1UFZNOGhJKzkwdW02?=
 =?utf-8?B?R1NUOW5QcC9sajg2UVdkL2JPUkVEVHR4RGFXRWJ4QmJRSkhyUlBldHdCVld4?=
 =?utf-8?B?QTRUWkdMeDhKQ285SEFuVEFaNFBCaTBRNWhSVU9IZ1k0M3hSS3VUMzE1TzM5?=
 =?utf-8?B?bmdYZUxOTlFRcU9FZjJlM1NrRHFVZEZEZzhVZ3NwdnBvK2xwaG1PTXNNOHpM?=
 =?utf-8?B?ODA5cTZjNXVhRWdkdG9tMzExUytiWTVQUFNFRThhNHp6TllFNFhVKzUrM25T?=
 =?utf-8?B?Znk3azFBd2RUVFFwdmp3bXJXOG9veXp3WjlFN1BFS2ZXSHg2WkNaeXdTUml2?=
 =?utf-8?B?ZmZvNmczMG1jell6Vk1oTEduZkpmbWM3VkZLUkUxc0w3TkREMHhjMUlFL3V4?=
 =?utf-8?B?d1ErZHpRRG1xRUl5WDU0LzdHT1hqL09yZS9BelZBVDUvYjRDVlM0Z1hmTWEx?=
 =?utf-8?B?TitVQzBYd0Y0alFtZ1VXeXRFeTBxNUR2eWFRalJaZDlvRzRRZXlnSi9Kbm9q?=
 =?utf-8?B?cVVYSmV1SkN1aHJ3WVVNQ1FabXlPMnJwS3hkZS9MalY5NGVSQUQyc3ZpbFNn?=
 =?utf-8?B?RkJKL1JYNU96Z085Y1orbXVoTTgvUU9IdGNmelVqU3RxOXJQOHdCSCtjeHJa?=
 =?utf-8?B?VEhKWEtDSTBzOVVEeG5wVUdLaTRFYzFvNEpPbXFQTEt4WHFJRlRDaGpRLzM3?=
 =?utf-8?B?WmIyUlZ4Mkt4M2tQWHFjUmozazJBMXBMSExrK1hoREVLd0lxQ1V4RFRKTEdJ?=
 =?utf-8?B?dTVHOW13SDNUUVQweDRaVjIvOWNLWExmZUk4dm0wS1IxME9yMkViVStPb2R1?=
 =?utf-8?B?WWNrYURJUUphS1VUZGRRT0FuNWc2RVBxTjVNNklHOFV1bDBjVUdmZEpIM3Zp?=
 =?utf-8?B?L0ppZjZ2VTBvd2JBNk9YL3pURkV1VkM3NDNJNWJHQysyRGFRMytIY3Q1dG11?=
 =?utf-8?B?bU9Kc1YxQmxWdElhMVpUaGlWS2o0em9vajNuL0Y0RS9rdG9UTW9wVi8xOWt3?=
 =?utf-8?B?RHdkdm5UUmFDNndHZjlySy8wR3BURlZTK2F1ajVtUjlhN3NzTFRxTEplRyt3?=
 =?utf-8?B?WFRLQUMzUWROWnJvWmxyUEdWYTFsY1pxWnhGYjBFRTdSK3lUQnVtbGp5Nkto?=
 =?utf-8?B?Rk93eWhiYkZvU1ZUem9samljTlRLb1QweU9xZ1ZTMHdtRmRLN1pyczFsMDIw?=
 =?utf-8?B?U2xRaWlPRmY1TnNidXRGc3RNNUZkdnMvZldGU0dZdUNSaU82cmFoSWU1UkVh?=
 =?utf-8?B?V3FYTjd2SFA1ZFpGcUwzZGVQb0R4OWgyNVhQcnliM21HczlJTzNhV284cTJs?=
 =?utf-8?B?dEJFOWxrRkVxOGF4NXVIaThVSUV3cGR2bHJJMm1oenNjMFQ5aDFXaVZtMXE0?=
 =?utf-8?B?cExpMEpURjBCUlFzSjhBR3pLRDR4L001ZkJWS284LzhmbzlyYXY4TGtLNmQv?=
 =?utf-8?B?TjNyelk1TE9QcmpZU0lyS0JzMDgxKzZNMTJwNytJTkswQjB0T1VIZDZyL2xR?=
 =?utf-8?B?SmkvaXBzRE05MDBSbTRZYXliNkg2cWh1Vm11dklYOWZLMFRFa3d2TSt4RnBo?=
 =?utf-8?B?MGsycXFLNWIxR2pORVdyMVJ1K3I0OWkyRXBoUURwR25uUkZNWnFhb0pFamVl?=
 =?utf-8?B?ODNjUWhLK25lSkZ4RFFGUm8rREhyOWlSTTN0UUJaQlRHSU43WjJLYmJQeHor?=
 =?utf-8?B?NjdIY2F3eGo1Znhnb0RyOW94S0pnSzJUNmF4Tk5rd0tWK2s1SE5aQi9xQXV1?=
 =?utf-8?B?MWpwR0dMbmxLTE1kZDRta05ES2ZxRDRLUTRIWDdUWkEwZitDZnc2TVJVaE5q?=
 =?utf-8?B?T2RRWFp6OFd5NGF6QS9HNGRYYTVzUmYwRXdsS0RiNlQ0aGcvNTh3b2VwR2d3?=
 =?utf-8?Q?184o6P/nGyD1syHUPO56EcHKc?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: ee85a212-135e-4b22-4ca8-08dda3b9b9d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jun 2025 22:47:03.8312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sivQ8sWVWwYVsIxQ89cN18CilI6fLffiieFtACPGl2gEls0N6z0KfYyUeCKlpuyJsZ7AaBRmokQGVEsm7OFyww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7507
X-OriginatorOrg: intel.com

PiBTb3JyeSwgSSBqdXN0IHBpY2tlZCBhIHJhbmRvbSBoZWFkZXIgZmlsZSB0aGVyZS4uLi5pZ25v
cmUgdGhhdCBwYXJ0IGJ1dCANCj4gbXkgcmVhbCBzdWdnZXN0aW9uIHdhcyB0byByZWR1Y2UgdGhl
IGxpbmVzIHdoZW4gZGVjbGFyaW5nICJzdHJ1Y3QgDQo+IG1vbl9ldnQgbW9uX2V2ZW50X2FsbFtd
IiB3aXRoIGFib3ZlICNkZWZpbmUgc28gbW9yZSBldmVudHMgY2FuIGZpdCBpbiANCj4gb25lIHNj
cmVlbiB3aGVuIHZpZXdpbmcgdGhlIGNvZGUuDQoNClRoZSBtYWNybyBjYW4gZ28gaW50byBmcy9y
ZXNjdHJsL21vbml0b3IuYyAuLi4gaXQgaXNu4oCZdCBuZWVkZWQgaW4gYW55DQpvdGhlciBmaWxl
Lg0KDQpTb3VuZHMgbGlrZSBhIGdvb2QgaWRlYS4NCg0KLVRvbnkNCg0K
