Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3421622097
	for <patches@lists.linux.dev>; Mon,  5 Jan 2026 20:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767644147; cv=fail; b=izPAPm1gGMxIiD0SpHwnZtQQUqXEoxt7QXbe1D0o2emeKro+yoj+brcAcP88MQkFgc91bo56LCjGRfAco5EriJy0rI6JjKwYiXMAcVdCQFOqVS0GyJLVJ5QMPG3i32Slx5HoJ2OQFEw6F4y/EOVd7BHXBe4sQz7JojQqWb1Ajy0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767644147; c=relaxed/simple;
	bh=iRq0J440dgt2gz6qPASxq2fkOVjQNM6YsfrrNOyz9Gc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=amCM4KXDu7bbpAxpxY/VwH50Pa2cBFvuxMND2dgvTtTX0z6JVgW8zKSr7Wiv5zBQlg7CZpkDqozChzPCg6gkdFD8m3zBRngG9msGtrz8yUOYNijWI/n+8EhKIKOEjR+m1m6h8YEqCgE7vVQF3HgoxHRjtj3dWU74zWbyCANtthc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nUr777CB; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nUr777CB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767644145; x=1799180145;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iRq0J440dgt2gz6qPASxq2fkOVjQNM6YsfrrNOyz9Gc=;
  b=nUr777CBmYZgpPRIm3GLgLpAhS/xd73jdiwAtiTx/aApsidNEhsuUcnr
   k/tBlIZlNTtI0jUm6npPHOO6LRgSbf1n7/dIlzJ1wV2rIj6jk0Mh/UlDk
   g1tFasbrdrilAqX9VbfbJKeZ2p5FVPx4kA0sw2GmDsqemUZtqhXEU6lQE
   fIIy9scOKLysOYzCZat/W2GYCH4u3EdE0lakFruVV7Y+YAJmtkFfnL7zW
   doLd/e/XifNrcEvt+XNfnL6Pl7Unc/rgBj8pV032yKMqOhM7hT5R3mYKy
   Kwzv8WVKVxC/aRNPGL5q9yXfWPGy9kTq1fjM06jC0unI5OPY1TnVhkAQN
   w==;
X-CSE-ConnectionGUID: u1QvXAT5SKaBowlwy0LS8A==
X-CSE-MsgGUID: FIrjkw/EStSysmzJFGQSWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="69056067"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="69056067"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 12:15:44 -0800
X-CSE-ConnectionGUID: 0KmNK6oPRX6Kbql6auav7A==
X-CSE-MsgGUID: BwjGfiKvSPK5Q90RF73erw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207507220"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2026 12:15:44 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 12:15:43 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 5 Jan 2026 12:15:43 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.14)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 5 Jan 2026 12:15:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mCHwsj9dz5nOKitorGzQ4gXpe3Woiqktu//CqhlXW004Lt/SG4cXapUn08NGDwOU4P2vMrPYZkR5zQTCiFK9Iobf78GZ6jOUqhCg03YA9YAClP7Lba/hKXl83/7jN6yHDFs5F8P3+Ju0qUpiqYjSW8Cqz4bCBHYsKgmIxX0WZPilpSay9m3pA/Bo/cL7w5NNd8BsILTKmvI9N6AB1dV+OZuCqlRu2YHhfHrvBIwMgx1KfCmZnYJl5jN22fAOcZLQlVToXD2uTo62nLTsMKgf46cvb7kpQe3RW/zsFYJNbkM/H3Ca1uoWXiHWNlx/gzh3WVPTErEebvH3dWbF0eWSFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRq0J440dgt2gz6qPASxq2fkOVjQNM6YsfrrNOyz9Gc=;
 b=FkVGmuCOPKIl6RRuNMPZyB7czjXJJtDE23yop/TruXgYgOT0YLcM2k+4gogiP29s0C8lzjiScQjPNg0fcDZ6Vd3FpTf/hYat1Whe8XWiDlV/viVOw9U5GJ5VdUMH4gPd8Fk7ly20NdURytDriIqfqXTi0cMHfbSJcV3GZaWQg3FfljvPl6SuTTEtiezV6iJUz6si4qnv3Tatddo/yB3GkAPnUWMIMwm71wD5zxF3aOBqyAS5DIRgmjJ3kUP2oheXhAhoQkwp7SsofOSYswY9FRpOqL/TyLueJD+ElfRLQTFVdU6lHUz83otaYX0BrYkpIxfdhqPPzrlgtfYYumcV6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CYYPR11MB8305.namprd11.prod.outlook.com (2603:10b6:930:c1::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 20:15:35 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%3]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 20:15:35 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>, "Chatre, Reinette"
	<reinette.chatre@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Thread-Topic: [PATCH v17 13/32] x86,fs/resctrl: Add an architectural hook
 called for each mount
Thread-Index: AQHcb3meeV5DFUqPs0KzzVX1okMZoLVEENWAgAAGO4CAAAcDgIAAAUnw
Date: Mon, 5 Jan 2026 20:15:35 +0000
Message-ID: <SJ1PR11MB60837B0B18CA663282190AE8FC86A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20251217172121.12030-1-tony.luck@intel.com>
 <20251217172121.12030-14-tony.luck@intel.com>
 <20260105191711.GBaVwON5nZn-uO6Sqg@fat_crate.local>
 <aVwTcX7V_HN2j6SW@agluck-desk3>
 <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
In-Reply-To: <20260105200435.GCaVwZU2gFV3LhJnMR@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CYYPR11MB8305:EE_
x-ms-office365-filtering-correlation-id: 6f8c0006-75bd-4f50-28b0-08de4c972fba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NFRNdC9hU1Vva29jakp6U0tYdTlwbHlJcE5Qa0dObGoyK3pzdFB5QVR0Z1FX?=
 =?utf-8?B?Z1ZWNU51N20zZkQ0a1FHU1A3YnBBbHZPbFVFSEVEbDJFekxLYnBGM2xCaXgv?=
 =?utf-8?B?bmFWR2M1ZGtxd01EbHcwaWQ0K1RMV0VvT0JqWllqTXNjS05oajdUZkFuUTJI?=
 =?utf-8?B?b0NDTGZIbmlqREhLcmFWWTZHYXRnZUd2Q2ZUQmtZUEFBU1plR01hSDVFbnNE?=
 =?utf-8?B?NEdqaGhsV1ZIYldpVkN4M0lsVHczMlpVYjZtN2kyQjBIenhBTWxxRXZNNGwz?=
 =?utf-8?B?VVJLUjdVYVB1K0ZmWDdFZXRpYUYrV0tpTkxkSlNkOXFPS0h5OERjdTRVOURO?=
 =?utf-8?B?SGR2UUs4NUNSclpnd0tZTWx6dFRFL00vUGVjcUtBWU1EVjBuMUNyOUlrUXFH?=
 =?utf-8?B?RUZRS2o0SjJRelVyQjBpL0M3YW9wTlo4SEQ1Zm1CUmpIVXlBSkhoTDdjNGpW?=
 =?utf-8?B?ZHQvNkhBcnRIRXIrdnVOQzc0QmJUUFpJdFBTZGRHZTF4YkxKZm9TQzRaQTIz?=
 =?utf-8?B?eTFXZE9sNWJkUWkxancyNis5blVLNktURjZybjZYQktLRmZiL2hFT2Z1UlBW?=
 =?utf-8?B?TFZVaStOSWp3SVhYeTFiV3pNTEFHQUs0bWlxTjFsU3N0NE95ZjNBekxGdHJK?=
 =?utf-8?B?cnpqVEg4RTJxb04reXFBL3kyNzlsUWtpS29DY09JVUg3K3NNS2NyWE93b0RN?=
 =?utf-8?B?YmFUbE5DL1NZUGQveDQ1aGNVb05HNnQ0b3R3Nkw5MGZvY1dscEFhYjJKQXJG?=
 =?utf-8?B?QTE0RFcyd3dCQUFNZFUzZTVBOFZYZmw1WnlWTkVuQ3ZFUi9ybWIyUktQT2lT?=
 =?utf-8?B?VDgyUWR5OHkwYk1LTGN1ZUZLL1laQUFwejRicmFaaGg0Y0pwdTRwSU1hdWh1?=
 =?utf-8?B?NUh6N01mSzdZc0hKT3N6dE50aEpOdjNnNHgyTGZYSnQwZ3NqTXBTZWFmYW80?=
 =?utf-8?B?Q1lNaWtlcDlqS0YxOVB5RHZTRFVKMER6UEs2QjBGL0l3MkpRSVM0QXhPSnJr?=
 =?utf-8?B?eVo2cjBqUHBWNW5zMFNhWkFOTS9qVTVGSVZ3Qkp5aFVsMnZFZGp2TkkrNEN5?=
 =?utf-8?B?ZHFnVHJJaW8xd1Fzalg0Q0kraTl2Z0F0d0VKcmhSMmhabnZrcmNFYVZLRmFO?=
 =?utf-8?B?N3lUK3BzTWtMbi9wQWJ4SXdPUC80NFdpMGRJQkhVbHJwRmlBaDB1R0VrRllS?=
 =?utf-8?B?cXdMK3M0SkcybENBUzJyemV6NUN0bnlETEYyMlpQa2hyQyswUVk4NllndEM2?=
 =?utf-8?B?NGtGUVVJUkw5b3c1Tzh5NENkOTZraTZ1R0lDY2FLWkFON1lwVlF5RzZERDRJ?=
 =?utf-8?B?dXhmQ1dycGZ2TW16dko4cEZ2UnlBa2J3MGhPanNVUlNRc0lsVjliUDNibXhk?=
 =?utf-8?B?UThLQzc1Z1NtSzFtcE45Q3Jqd2pkOG9nbVNnbFZEam9uK3JOL1lHeGxrOWFP?=
 =?utf-8?B?RUxlOXc0a0tKTU02amdqVHpXbFRicDdHc2F2azk3UEZSRjR4YkwrQ1AvbzZJ?=
 =?utf-8?B?eW9xZFIvaE1RdXIvQUoxYTJiUTV4eVZNTEhwRXFuR1ZIQmN0K25qaE1Ma3Z0?=
 =?utf-8?B?aTJmSjRRUVNDTkpOM0U5RWswb0FRa2JTYjBpeVJ3b2xkV293djhWVjJGZ0Nj?=
 =?utf-8?B?TXZQb2FOVFJmSWM2NWhNaHlORHlyazFJdWt2b1RxaG0wUU5KVEg4cm9DNytu?=
 =?utf-8?B?RXFvVjc3SzFOcmpMQ2lBU3BCTVlyYnVsekVJMk12aEpBbTdqd1g5b25xT1Vj?=
 =?utf-8?B?ZFN4NG5NVmRJSGZNbXFKc04yYkFva1doWWZ3czlLUGJSZ1gwZXhiWTduTEdV?=
 =?utf-8?B?Nmp4ejlsalFsZGVrNlphRyt4UWJaRGI0T3Nua3NhYUd5U1N2TDdxNGVHcHkw?=
 =?utf-8?B?ZzRRSTVLM1JZZFpTNFZ4U1U3MmVHUHF5YWhsRjk4dDY2TTZrUWpHSjBiNUZs?=
 =?utf-8?B?a1BQVlBzbi9xQVU0Ri9uS3Joc3JOYis5QVc0a29QZkdrTU1PUisyTm9KNE9m?=
 =?utf-8?B?L09CMWVYQWJaSGtxUzJMZEhpQ0lObERaOXQ1RXp1aDFvRkpIcmlUUkhqd2NS?=
 =?utf-8?Q?IaQ1Ff?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WXo1MzBMT3ZzWE1xZTlMekF0YjArOW1kUnNleDcvMnZLYTBpbjNNeWdmMFhJ?=
 =?utf-8?B?R3ZIS29DcHk3MGZXZUIxbkVFaUFQR0FLSWp5MEtINGZLS2JMYTYvVWZkSzJv?=
 =?utf-8?B?bkNOZkFmckxlVjlxdWJZTlFpNlRDbU9iNGYvZDZmczU3VHZ1NjJCZUl2Vmpj?=
 =?utf-8?B?cVowM2VEcXUxbWtrdVFPTkJGU2VtS1pPQjB1SVhjcUhMRllvU0dSUnYvSm5M?=
 =?utf-8?B?SWcyQVZJa0RzdjJuU3NqL29ENHBGZzU2Wk1tSlVndXY4bE1oQ3Q3YUJvaEhk?=
 =?utf-8?B?bVM0WWx2RmNnQktMUzhZYytXUGVFdU91OHhoUG1ZSkYvTTdrM01aVmhpUkxD?=
 =?utf-8?B?Zm9mZG1Xbk5oaWJMbVN1UXl2WVEzV0NKQ29iamEzZ09oZ3R1bk5oZFZUOUdO?=
 =?utf-8?B?WFBLOUdET1dET0pkUTkzWk5qa2g3ZFNGM0VxYlI0RTlvOHdYRlhBUmo3bWNV?=
 =?utf-8?B?Q3VxOVphMFhZYm82MDJuY25zL2R2V2hzcjRVTnZpTkFMaUlxcUdSMlFmZVdG?=
 =?utf-8?B?ZkNVVEdvNkhUY2w5Umd2YTlyQUxqRis0MGVHZnlJbU10ckhXV1A4K3R6aEVX?=
 =?utf-8?B?all5c0ZxbER1clRUYlg2Zzl3a1cvampBcXRWM3V5S3F0VitpNnZRMXUrcEV4?=
 =?utf-8?B?R1ZOenRpem9TWXJqTXp6ekFvdXF5c3FaOHpUaHQ3QzlPbWtoOGo0a09uRDkr?=
 =?utf-8?B?R3Y4enBNMDZkV0h2RVdTdjJMSEExR3doSmxSK0x4TnRiT2VYSlJEVTJBN01N?=
 =?utf-8?B?TGNNM2thYU52L1pYUDIrR2h5bVRIam1JSGl6K0xYYXFiSHlZVmsvYnFadlUv?=
 =?utf-8?B?clBwUTRYbHNUNDVMREVCUGxCVUxPNUh4eE5XWGtWeUhvRjNqL2ptdjlXKzJu?=
 =?utf-8?B?KzJSL2JsN2FFeFFZR0pTQ3pQS0JVQ3hRZXMwOUZoNlZnaC9YZ1hVb1MzOGJJ?=
 =?utf-8?B?VnBtWUI2ekR2N2ZhR1ByNlFwdHYxZW9wd0hXRTkrcitnL2tjUjk0cWh0bXUv?=
 =?utf-8?B?b1Z0OVUzR3Jya0dIWm1RR2lIa2JjaHBOMGNJWWRjZ3l0Mkk2WHErRkljVzZn?=
 =?utf-8?B?bzlPajFsM2tPUFdRNEwwRWozT1QrM2wxS2FzcmJIRXBQbGNQSE5wZW1saDF1?=
 =?utf-8?B?Y2tidHdSUkRDUklhMi9IZTZsTlFZYnBBTjErOUQ1NEMvMU9TVWlwY2xSaWNy?=
 =?utf-8?B?T1VlUk9zbXF5azJVWkdxVXIvaVpZazlXeCtmY3B1SVROMlVoTVhkU3dMUlhz?=
 =?utf-8?B?emM3RW1HNWRQeHBhN2x5TUUvdlhTQ1hldnRNWjdDNERlMWpNMEp1c21uM3Ri?=
 =?utf-8?B?ZEFRL0FaSkF5bTJkZzdCb0c2K09tSzZSbHVaTG5kOFZ3aGdlc3NFWWVsamtJ?=
 =?utf-8?B?Rjk5ektZTmxGOFNTaExxZWlOa2Q5aWhVZERqN0E4K2ZaZnFJM1o3U0NjWHYv?=
 =?utf-8?B?eUNhNEd2WDZpbE1Wa0JGM3MyZmJwUTI4ZERKNGFDeThrMWgvYzRuV1BVLzEz?=
 =?utf-8?B?OHhzOTRKSnBSQXcwa1k4N1diM2NLWmIzV29INUxuSjVhU1hjU2wrakhCTUsr?=
 =?utf-8?B?UDRxT3lDTjdNZnoxaUthcHY1ZDg3QjNlQ0FBeEV6eTRkcUpqYWRKQytzcU9r?=
 =?utf-8?B?bmRDRG1wREJZcEN3d2pkQXVvbkRyRWZ3UENXcmhjbDBxcjNtd2xHVjduSENF?=
 =?utf-8?B?TjRmUVNUK2tHOTY0bEhycGFUVy9uOVdGYjNtSVpiV1RVT1R2VkNJemg5VDA2?=
 =?utf-8?B?UGY4eFgzZnZJSEV6WHZNS3NyVS82RnR2NS9NMlNMMjBJek1HZVFIYVJWZElh?=
 =?utf-8?B?TG5mdVZ4RG5CaS82Ym1vZi9ZeW9vRG9yNmo0MmNGTkNJNUZET1Y3VGlkT1JW?=
 =?utf-8?B?UVBnd3A1QkZFaTA1cWl3WDdXWWtMUjR0TXhRQ2RERWxnV3VMdVhLbTBYK0k1?=
 =?utf-8?B?THV5OUR6c2QxR2tYUnF4Mmd0c2d1emV4UFBoT0tIalQ3UWxBSDNabVB1MTA5?=
 =?utf-8?B?VUlEMDJTOHZpell3NDJzSnJHTW4wbVNrM0ljcUlNdGVUQm9RS1RtV1plVFNk?=
 =?utf-8?B?c2N3UTc3eEh1WXRUaEFDU1E5eGtlMnRMTitIRUJRd29acVQ3V1dnTWYyd1dN?=
 =?utf-8?B?Q3c4ZnpPR2h2dk1qd2NmYnVoY3FOTEtGRWF2ZzlENW01VlNqdXNuOGxVOHhC?=
 =?utf-8?B?NWN6OHJFdmxrRGFBN0RZTWk2NXhhUWowQ0doK25OUVpXa1NPbE5OQkxWTUVz?=
 =?utf-8?B?aTVHZkx3Rk5OVXIvTTU1MVZkZ3JWRlBGTUUyRllGbHNzSFdSanFKcGc2L25a?=
 =?utf-8?Q?JXXpr2Wyd9zeM+4E3h?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f8c0006-75bd-4f50-28b0-08de4c972fba
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Jan 2026 20:15:35.7480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YaE19lzL4/hnkZCn2cRPpGDi6rmdhDZUdf4i4IHkORpdL4At0ZU/YpDo0OekNwh6nzdbv2csA91fQSWguke/LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8305
X-OriginatorOrg: intel.com

PiBPaywgaWYgaXQgd29ya3MgYW5kIHBhc3NlcyB0ZXN0aW5nLCBJIGNvdWxkIHdhaXQgZm9yIHlv
dSB0byBzZW5kIG1lIGFuIHVwZGF0ZWQNCj4gcGF0Y2ggYW5kIGRyb3AgdGhpcyBvbmUuDQoNCkJ1
aWxkaW5nIGFuZCB0ZXN0aW5nIG5vdy4NCg0KUmVpbmV0dGU6IFdoZW4gb3JpZ2luYWxseSBkZXZl
bG9waW5nIHRoaXMgeW91IHN1Z2dlc3RlZCB0aGF0IHJkdF9nZXRfdHJlZSgpDQpzaG91bGQgY2Fs
bCByZXNjdHJsX2FyY2hfcHJlX21vdW50KCkgb24gKmV2ZXJ5KiBtb3VudCAodG8gbWFrZSBpdCBn
ZW5lcmFsbHkNCnVzZWZ1bCBzaG91bGQgZnV0dXJlIGNoYW5nZXMgbmVlZCBzb21ldGhpbmcgdG8g
YmUgZG9uZSBpbiBhcmNoaXRlY3R1cmUgY29kZQ0Kb24gZWFjaCBtb3VudCkuDQoNClRoYXQgZmxl
eGliaWxpdHkgaXNuJ3QgbmVlZGVkIGZvciBlbnVtZXJhdGluZyB0ZWxlbWV0cnkgZXZlbnRzLiBC
b3Jpcycgc3VnZ2VzdGlvbg0KdG8gdXNlIERPX09OQ0VfU0xFRVBBQkxFKCkgd291bGQgcmV2ZXJ0
IHRvIHdoYXQgSSBoYWQgaW4gc29tZSBlYXJsaWVyDQp2ZXJzaW9uIHdoZXJlIHJkdF9nZXRfdHJl
ZSgpIG9ubHkgY2FsbHMgdGhpcyBob29rIG9uIGZpcnN0IG1vdW50Lg0KDQpBcmUgeW91IE9LIHdp
dGggdGhpcz8gT3IgZG8geW91IHN0aWxsIHRoaW5rIHRoYXQgdGhlIGhvb2sgc2hvdWxkIGJlIGNh
bGxlZCBvbg0KZXZlcnkgbW91bnQ/DQoNCi1Ub255DQo=
