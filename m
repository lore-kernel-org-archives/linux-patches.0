Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793613916;
	b=25E0GK63Yc61jcv3NiimzmYvUF1/ZVqBDVTwIH/wXVkvyFET7TpO0ux7+0mjxZvFSPNq
	 PpKUu6na83iMNTQYQ6PgpA6o/FBl7747NXkpYfM130AgJsJyHrtO0mm77CwXx9G3tYXHO
	 KGaPawh478pDwD7eD6r+qdcaFcdGnXTQRYFYdQDLeMbLhiqwTuDjHdCgFxvAPR/H5RkpA
	 kB5BavuwlqKIe0fvG3PiS9T9s2nuGtH9za7uDcqw3zWe7147b4jKAHEZsKmU2ikz+E6bt
	 kBasnGV45bcSEZE/ZwrqzgsgQj8INiqWXnXVLaOxd43aRUWbaTu8ukYYXZqX/AWyWQg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793613916;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=3DJPUo+rplJMNCUmOCvS0k9MLI1EiA7oxwoBUCzpBYE=;
	b=m2wEPtgeIWlUtSp40kwN7SLLlcKL5qtpnX6GP7paW35Zm668NPL1HX/TWOWwoeHG1i+e
	 M/JoWlM27DYpzwkSScpJ+1Aa3rLSzCuf/RDJqzdfTy5EWJMq0nmPpoI3FGiH/c6withXi
	 qShlB4TJYRZlsgFG6Vl0kKJQSlRdmZcbxiAMd13L1QkRK2qGup6SG7KxLS3YFwe00ElYP
	 nlgiGfUXSX1D5Tdlunj+MBK8EAljyN+e2/fzZmB2R8fCHD3pU4JRLg3YkqEMZSLEUySeX
	 qPQ2L0/KihbnJKFKM6f798yTHejTPye533SaZVHPeKastnzOxkFI/PUWNH1edO6IcPw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CC0QTzsa;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECF8606A33E;
	Mon,  2 Nov 2026 10:05:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BECF8606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=CC0QTzsa
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793613916; x=1825149916;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3DJPUo+rplJMNCUmOCvS0k9MLI1EiA7oxwoBUCzpBYE=;
  b=CC0QTzsa6KMDF9Xvc3CgG95We3SSbK4FnbPQo4oISP4fafkqneXKISTP
   YPvRLtxG0J1f06YrURtqNcZTRcH9HfQzGh5HQE2JmtqLnby3SDSMfruoT
   P1N4IUQpztsvUtLmfMB+1rucAZqh3yrE6MIfkptINWeyh/cXIUC5/mJiy
   27QGnxjbQwnLFsS8VXMGa3ZG/s0FEJ61dTsdTifjJsdXjf1FfHdicp6/8
   ucDBqY7MUgbjvRl+Rrh0kFGYh3qruQBjEGiyuBoHtTA0bKZlhNxoX6uWp
   8FNQxBqCcqhy1Hh4WlfBrdjJym46THbJhlWO+x8o1oJTcWn0cfQ9Ha3EP
   A==;
X-CSE-ConnectionGUID: tnOAzQCJT1aKtP+z8CvkuQ==
X-CSE-MsgGUID: n09Tof7RSQ2d464P4HVsnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2327604"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2327604"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 02:05:14 -0800
X-CSE-ConnectionGUID: 2j3PCUImRHiYeUHIk+uefQ==
X-CSE-MsgGUID: chGRlB8vRzWwsKqrK0sPzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6630445"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 02:05:14 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 02:05:13 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 02:05:13 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.33) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 02:05:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fgK1asCVHEpC7hiJmL7ltXqsA9YGPRf/tyPy0l/NfJPxmPYiuD3Hh1n1ikjV2BB7A4vRyb1+nI75eS82xxcfmgDc2salo/5yVSOfOBdjPID/4n3nO32O4z1q2VYT78BAsVTk3So8YGPU+/I5RLf4CJChVW1O9jbM8d1PT6woLxB/2nLvTCG4+mjWDAZ0a/ptn2jwfxTrML+xDqVJhWqG8oEYg8mvtHUtZw+3us1GRyzE0LiPWTMgMsLoZh4yWs9tGqjZZA4dy+K2aUp1CphNu6fRXiZLZxKpiF0WCoPBKORNnizZEjhvDxunqgF8cSsse5b41/PDtgxNr7gYeQCIFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3DJPUo+rplJMNCUmOCvS0k9MLI1EiA7oxwoBUCzpBYE=;
 b=E+UX+M6U5+PivW9HzUDmvERHYKtuSbRsVryOy4Ub0C7ALMLlZzSvvJK70jZJeo5UHjtVmkCDd4I6Ut9Kn+vCGBoQHr4xfQoODJJJhWzaMnv7wEbt84QrEo3xw9JnFkHbbyCy7AGYc617K3H3JJva3XppkYsImO1Z2YKzUNdIclWHV/fpkEoIzBUwNQMYrBJRC0YLySeB4qBFhioGTCGD6l1+xsxBO9H/ReMoWrx5uLnu/8ubTVJSuJbZK5KV5vD21OozxKWlXOETKlyLxenojhdNATuj5t+oqlibLXLA+qiLC0nG+zmk+APkmzE4q5FIxvA1e3hlM6UGOHnu/+iCFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by DS3PR11MB9841.namprd11.prod.outlook.com
 (2603:10b6:8:364::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Mon, 2 Nov
 2026 10:05:10 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 10:05:10 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, "Aneesh Kumar K.V (Arm)"
	<aneesh.kumar@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin"
	<kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Xu Yilun
	<yilun.xu@linux.intel.com>, Catalin Marinas <catalin.marinas@arm.com>, Suzuki
 K Poulose <suzuki.poulose@arm.com>, Steven Price <steven.price@arm.com>,
	Kiryl Shutsemau <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgASAKUA=
Date: Mon, 2 Nov 2026 10:05:10 +0000
Message-ID: <DS4PPFA84FA90FC4C6D52AB3E899DFA2F9DE76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com>
In-Reply-To: <20261030131543.GH3734323@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|DS3PR11MB9841:EE_
x-ms-office365-filtering-correlation-id: 6e625177-3d79-41e1-a3e2-08df38c8c77d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|6133799003|10067099003|18002099003|22082099003|38070700021|56012099006|11063799006|5023799004|4143699003|261022105027099003|261026121527099003|261026140227099003|261022075727099003|261028144727099003|261021121427099003;
x-microsoft-antispam-message-info: JvU9QuiI6hymsX3P1BOopq0A6drgSMNzD6N6gUdYQdDbBVK3k0D2iSf5qRAgyyMKfiOe4P1XlGf1c84AdeF9mzy/dlcXcvuruoqa0LIIF4ES2oTXCYt0929BA8SU4h+c3RKMwc84YuvjBHRvApL3a+evf+vfYNmyUDAhIw2v23XPVr7ArvF6do66NIfi49AL6gSYraMm6UQsFsaDhgBj4wt6aLzFlvGho/EoMR3bVKAukk9nox0NAtuDU4C0v59GcwD9S2LQ2MqlvEgLus8aZRAq32SI5Vql+h+l39ySNnasAGZlN6K5beViDkhC2FNfm7EfXaoZp40TA9GhNH3aFNJLZUDI5SizjkInOEn2wWjn4SUxNFRBT/kwbWzt588Lh7lVSQOYWjL2e8Is2gPfKLh0bzIt5LfyYukbsneGCY3lJ1IhKJK6W2zG9zctKjFemysgFAzJDJTeOLLnX0VAJgdARL3M/mrXHLBsTN76EERU8ELPHcv07QseSlitZ7ChyvgTMFLljcfHETPYzFGqZykfux7IvDUfGF+LQZ0biSLTxzTOnVCYYejjY6arNFKEFei3igT7y8jTIykjyoO88vuvmJ34odnOchE1Ro4x7fB3J2StxXjR0L4lQSmxp+yrtnygF/f9FXMcp9yxOcQdJjIJ+JmkZcFu+2gTL/STJwEKQkqIPNYRC8Zi+226jfwlxn9ypGGU35pnE3eY/TV9s/H17QWNaU+lqohI0wyrcog=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(6133799003)(10067099003)(18002099003)(22082099003)(38070700021)(56012099006)(11063799006)(5023799004)(4143699003)(261022105027099003)(261026121527099003)(261026140227099003)(261022075727099003)(261028144727099003)(261021121427099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NGYxS1dTcTRKL1FmMDdNNU53UzNnSCtMNHYwWi9RN0E0Mkc2VXBtWG5XbDJT?=
 =?utf-8?B?N2JucStwKzgzeVdQRjV6azZFdjBBajRWR25ia29Eb1NPWEFBN09ZMTgzMGFP?=
 =?utf-8?B?WnJMOU5IclQ0WFpEVi9FTDVFcTVaM3BuREpEbTJHZnRFLzFUUXR2M1JtQlRw?=
 =?utf-8?B?elNSQVJhSVIzZ2JMTVdIYnlZY0p0QncxRDd3Rm9FSTc4MmhtVzhheVRrYnJl?=
 =?utf-8?B?SmZjakJKeld0Qk5jbmhsbk50Z0pBR3htR2pvUmdLblltSlZHTTZvVklRMXB5?=
 =?utf-8?B?Ky9xWXZhN3luK0pMbyt2ZVZZTHRpd1MzaWxmeXVFMzhEOTZhcUswaVBiYlcz?=
 =?utf-8?B?a3ZEYXpYNHlqREVwVW01TjZUdnZiTEkyTlFpbDlENXVtTm5KK3h0dGEyZWEz?=
 =?utf-8?B?b0ZuVmdWeWJOVmp2aEhpamx2T1VrNWd0T05yVmpvejhUaEFNbFhISjYxQTFv?=
 =?utf-8?B?TjVZcnVueXd5ZkYxNkdHeW1yVDhFNENjVFAyS0tBQ2lNQ0QrbVdab3Zkakhl?=
 =?utf-8?B?QmFmVThvWVpoVjFwVnFacGhCSStac0lCdS85RWgrRXNPZ2NPMWFvalYxc1RK?=
 =?utf-8?B?Uy9qZmxud3BMdHdHYnNZL3MxNFF3a3lYM1dsQmg5d1ByeldtUklCVVhTVTc1?=
 =?utf-8?B?MUJxZW1GRWFPWVdNSkNOTmRlTk5SZ1dndFkva3FVMG40ZCtvSlFZVEwzNURT?=
 =?utf-8?B?Q1c2R0tyY3YzTmI0NDROcWlhQmdQSFZ1OUNJRE1UUWZuaTRTN0Q2d01pN1pR?=
 =?utf-8?B?dnVrZ211ODRpZUwvekVyMEVhemFvSFVIdHI3dU9VMkVnZmFjRzVGRnk3eHJW?=
 =?utf-8?B?em81YzZwYmZKQ2dxWFFQSXlSanFQMyt0OGtEbFRYcGhYUWJtV1FBdUFBR201?=
 =?utf-8?B?a1pCdTJGNmQ1dVJyN3p4bXYwOFpjalRLaEYxU1dIdCt2QTVYWUxINEYxU2lp?=
 =?utf-8?B?V1N2U0JQc1BDYnFxZlg0TWczUCtQQmQrVEJmUHBpV1c3OC91Q1pQQXlMRnQz?=
 =?utf-8?B?bU1GZEpmOTQ2c1BYYUxRZ2V4ZUFvQ09oSlhqcWZzakpubmlLZTdKSlpZNThQ?=
 =?utf-8?B?bjZVemlVelZmY0dnOEFYeUkvQUlPc3FZZ0xYTW9rUm5laEQxa3JqaFFxOCtx?=
 =?utf-8?B?VmJVekUrRFRrNWNzdEhXWHFkM1BkYnBnM0NwVXJETUZvU3JFdHdsUk9ISWVO?=
 =?utf-8?B?d3lNSnFoWjgySklWWHVaWWtqdXQvOWd0NG5heEltOHl4VWE1dC9ZZlcxbCto?=
 =?utf-8?B?ekFxajNSNnZSZTVxRWJrTkkzWU16RTRkbmVKcFIwb1l0TUlvY0RmdTJxTzlv?=
 =?utf-8?B?emphUWdiaVJKZkJERjBsNWZ6NTFnMmVMVHFpT2lPcWRCMVhibjRoRUsweXVV?=
 =?utf-8?B?VE1aajR1Uk1Kc2QwMkNsbU44V2dtUXFIZUhrNmtPUFU2QU5wMHRKNENOSXYy?=
 =?utf-8?B?dHJ1QmYwa3FINUxMSjZ0Si9RY2o1YmUxZGpiZit3Mlo2UkRObHlaeHVWemd5?=
 =?utf-8?B?YWtkRnpmeXNPNDY2NitCODZGbXF6RDVwc0QxSVA1ek9oNjlwOGI5WFYySFR3?=
 =?utf-8?B?VTV5ZWVSa3JBQjFaSWFjLzBGV0Era1BsV1QyY1J5dDFkN2hHdG5vSTM4U0xW?=
 =?utf-8?B?TVk0RUw5K0JPNGNJZG9XaVhUbTlQVTdNM2ZzVjNreWtEYTZXcWhmRGVBalk0?=
 =?utf-8?B?cWg0M2p2aTMwOFdVdVdLVm9PeGpZWHRlc2ZFZGRCWVQwQUw2bzg0eU04NGZW?=
 =?utf-8?B?SFVlOE9KMDUxTFYwTnNRdG9KeHhFenhNK05EZGw3RlNRVzZ6c2JlQXdwUmlR?=
 =?utf-8?B?bUpsV1Voci9wbW5VT090NHptbUpBMlVhazdiSGJUOC9hdmpZeWtTNFg4MjNr?=
 =?utf-8?B?VzRRa2lHekltekxwMG84ZmVDSGp6ZEdmWEQ2Vm5xS1N1Z1FTZWR4VVdqYjBH?=
 =?utf-8?B?Tk9PWDZOM2hzM3hKVDdLeWJGeUZ1dWpmWFM0dUR5WVcxaUd5TUVka3ZJUW5z?=
 =?utf-8?B?WWg4WG54TVRsUW03S2tQa21Nd1FKaC9oUzYvNEJuN2lMcS9nSFF0SFcwQW5J?=
 =?utf-8?B?QVlndXd2d1FVOEkyOS9aWmhvRFJLVkdacHlFTHlPOFVKM1d3bVJrNzJmZ0Jq?=
 =?utf-8?B?djZxWGNsVXV1ZUhyVUNTQnE0d25RWmRMVk9DVUhNRlZNcjdnVUtVLzNTcVRH?=
 =?utf-8?B?amdwcWUyMWVXNUdNdGoxbUZBZ3ozRnVMRzhiUGx5WEtEKytXbUl5UDR4ZUY5?=
 =?utf-8?B?RG1YT0hzQnBLelR3OGZqRlZQUldWcnE4L0Q1YTI2NEs4VUgyWHp2SU5ocXI1?=
 =?utf-8?B?c2JzN2hlNGk0aHl5cWkwVUhudXArc0l2TU5hMDd2ZmViUXNNSDY1UT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: w1XwAFd61dcaYeIp1sITcUw8+HF9rEyIpJihl8+tgf62/kPGP6gRD0jLhrq76dvbn6IikpzmW/JA2xJvnHceBLXS7n2oQtFK+mP0I75PyO/Cwrtyur4xbW/++XFI8K/2DideV+iTos5YHDWkBrlT/ZMKd1ssJ048F/34cL2esIRkBbQH1QnyR1MhMYWsDH3fLRjovNmEeo8aaOK9oMjfmjHdoDaup0KA+iMHgkZuyfC4LNMfMNOYtq8onVlLXfUEXdBxw6YIVT9Z8Qjo5p4SJ4ptK9Wvupx3t96cCi+RrZct/URPnbOWYF+TIpZ0hLfnLL8VR5ptFdKTrknM1L5nTg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e625177-3d79-41e1-a3e2-08df38c8c77d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2026 10:05:10.1294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3debAMZni2QyMlvEV3upxUaLjQZVhQE+OIf76kAgnzSEsRQTH8cGK72M+qogM5CNnuEC4V943ExYBqWdA+6z631nB1rT6zHrzKu9XB9dotY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS3PR11MB9841
X-OriginatorOrg: intel.com

PiANCj4gT24gRnJpLCBPY3QgMzAsIDIwMjYgYXQgMDk6NTg6MDNBTSArMDAwMCwgUmVzaGV0b3Zh
LCBFbGVuYSB3cm90ZToNCj4gPiA+ID4gSXQgY2FuJ3QgZGVmZXIgdGhlIHNlc3Npb24uIFRoZSBU
RFggTW9kdWxlIHJ1bnMgdGhlIHdob2xlIFNQRE0NCj4gPiA+ID4gc2Vzc2lvbiBzZXR1cCBpbnNp
ZGUgVERILlNQRE0uQ09OTkVDVCwgYW5kIHRoZSBob3N0IHJlbGF5cyBpdHMgRE9FDQo+ID4gPiA+
IG1lc3NhZ2VzIHdpdGhvdXQgaW50ZXJwcmV0aW5nIHRoZW0sIHNvIHRoZXJlIGlzIG5vIGRlZmlu
ZWQgcG9pbnQgdG8NCj4gPiA+ID4gc3RvcCBhZnRlciB0aGUgY2VydGlmaWNhdGVzLiBUaGUgY2hh
aW5zIGNvbWUgYmFjayBpbiB0aGUgZGV2aWNlIGluZm8NCj4gPiA+ID4gb25seSBvbmNlIFRESC5T
UERNLkNPTk5FQ1QgY29tcGxldGVzIChURFggQ29ubmVjdCBBQkkgUmVmZXJlbmNlDQo+IFNwZWMN
Cj4gPiA+ID4gMi4xIHYwLjY2LCA0LjIuMjAuMSkuDQo+ID4gPg0KPiA+ID4gWWVhaCwgaXRzIGZp
bmUuIFREWCB3aWxsIGhhdmUgdG8gZG8gd2hhdCBBbmVlc2ggcHJvcG9zZWQgZm9yIEFSTSwgYW5k
DQo+ID4gPiB1c2UgdXNlIHRoZSBSdXN0IFNQRE0gRHJpdmVyIHRvIG9wZXJhdGUgRE9FIHByaW9y
IHRvIGNhbGxpbmcNCj4gPiA+IFRESC5TUERNLkNPTk5FQ1QuIFRoaXMgd2lsbCBhbGxvdyBkaXNj
b3ZlcmluZyB3aGF0IGlzIGluIHRoZSBzbG90cyBhbmQNCj4gPiA+IHBhc3NpbmcgdGhhdCBpbmZv
cm1hdGlvbiB0byB1c2Vyc3BhY2UuDQo+ID4NCj4gPiBJIGFtIHNvbWV3aGF0IGNvbmZ1c2VkIGJ5
IHRoaXMuDQo+ID4NCj4gPiAxLiBZb3UgYXJlIHNheWluZyB0aGF0IHByaW9yIHRvIGVzdGFibGlz
aGluZyBhDQo+ID4gc2VjdXJlIFNQRE0gc2Vzc2lvbiwgeW91IHdpbGwgdXNlIHVuc2VjdXJlIERP
RSBtZWNoYW5pc20gdG8gZGlzY292ZXINCj4gPiBhdmFpbGFibGUgY2VydCBjaGFpbnMuIEhlcmUg
eW91IGhhdmUgdG8gdGFrZSBpbnRvIGFjY291bnQgdGhhdCBhbnl0aGluZyB5b3UNCj4gPiBnZXQg
YXQgdGhpcyBzdGVwIGlzIG5vdCB0cnVzdGVkLiBBIG1hbGljaW91cyBkZXZpY2UgY291bGQgc2Vu
ZCB5b3UgYW55IGNlcnQNCj4gPiBjaGFpbnMgZnJvbSBhbm90aGVyIGxlZ2l0aW1hdGUgZGV2aWNl
Lg0KPiANCj4gSSBwb2tlZCBhdCB0aGlzIHdpdGggQUkgZm9yIGEgd2hpbGUuLiBXaGlsZSBub3Ro
aW5nIGFib3V0IFNQRE0gc2xvdHMgc2VlbXMNCj4gcGFydGljdWxhcmx5IGNsZWFuIGl0IGNhbiBi
ZSBtYWRlIHRvIHdvcmsuIEl0IGxvb2tzIGxpa2UgMS40IGltcHJvdmVzDQo+IHRoaW5ncyBtZWFu
aW5nZnVsbHkuDQo+IA0KPiA+IDIuIE5leHQsIHlvdSB3aWxsIGNob29zZSBhIGNlcnQgc2xvdCB0
byBiZSB1c2VkIGZvciBTUERNIGF1dGhlbnRpY2F0aW9uIGFuZA0KPiA+IHNlY3VyZSBzZXNzaW9u
IGVzdGFibGlzaG1lbnQgKHNsb3QgMCBpbml0aWFsbHkgaW4gdGhpcyBwYXRjaCkgYW5kIGFsbG93
DQo+ID4gZXZlcnl0aGluZyB0byBoYXBwZW4uDQo+IA0KPiBZZXANCj4gDQo+ID4gTm93LCB3aG8g
Z3VhcmFudGVlcyB0aGF0IGEgY2VydCBjaGFpbiB0aGF0IHlvdSBzYXcNCj4gPiBhdCBzdGVwIDEg
Zm9yIHRoZSBzZWxlY3RlZCBzbG90IGlzIHRoZSBzYW1lIHRoYXQgaXMgZ29pbmcgdG8gYmUgdXNl
ZA0KPiA+IGluIGFjdHVhbCBTUERNIGNvbm5lY3Rpb24/IFdobyBpcyB2ZXJpZnlpbmcvZW5zdXJp
bmcgdGhpcz8NCj4gPiBLZXJuZWw/IFVzZXJzcGFjZT8NCj4gDQo+IE5vdCBzdXJlLCBpdCB3b3Vs
ZCBtYWtlIHNlbnNlIGlmIHRoZSBrZXJuZWwgY2FuIGRvIHNvbWUgb2YgdGhpcyB3aXRoDQo+IHJ1
c3RzcGRtLCBidXQgdGhlcmUgYXJlIGFsb3Qgb2YgZGV0YWlscyBoZXJlIHRoYXQgSSBjYW4ndCBn
dWVzcyB3aGF0DQo+IGlzIGJlc3QuDQo+IA0KPiBBSSB0ZWxscyBtZSB0aGVyZSBhcmUgYSBjb3Vw
bGUgb2YgcmVhc29uYWJsZSB3YXlzIHRvIGltcGxlbWVudCBzbG90DQo+IHNlbGVjdGlvbiBhbmQg
YXZvaWQgZG93bmdyYWRlIGF0dGFja3M6DQo+IA0KPiAxKSBXaXRoIDEuNCBtYXRjaCBHRVRfRElH
RVNUUyBhbmQgTVVMVElfS0VZX0NPTk5fUlNQPXRydWUNCj4gICAgMSkgRG8gdmlhIFJ1c3RTUERN
Og0KPiAgICAgICAgIEdFVF9ESUdFU1RTIC8gRElHRVNUUw0KPiAgICAgICAgIEdFVF9DRVJUSUZJ
Q0FURSAvIENFUlRJRklDQVRFDQo+ICAgIDIpIFVzZXJzcGFjZSBzZWxlY3RzIHNsb3RzDQo+ICAg
IDMpIFRTTSBtb2R1bGUgZG9lcyBzdGFydHVwIGFuZCBhbHNvIGlzc3VlcyAnR0VUX0RJR0VTVFMn
IGFzIHBhcnQgb2YNCj4gICAgICAgdGhlIHNpZ25lZCB0cmFuc2NyaXB0DQo+ICAgIDQpIENvbmZp
cm0gdGhhdCB0aGUgZGlnZXN0cyBmcm9tICMxIG1hdGNoIHRoZSBkaWdlc3RzIGZyb20gIzIgaW4N
Cj4gICAgICAgdGhlIFRTTSB0cmFuc2NyaXB0Lg0KDQpXZSBkb24ndCBpc3N1ZSBHRVRfRElHRVNU
UyBjdXJyZW50bHkgaW4gb3VyIFNQRE0gZmxvdywgYnV0IGl0IGNvdWxkIGJlDQpjaGFuZ2VkIGlu
IHByaW5jaXBsZS4gDQoNCj4gDQo+IDIpIERvIHNsb3Qgc2VsZWN0aW9uIGFuZCB1c2UgQ0hBTExF
TkdFIHRvIHByZXZlbnQgZG93bmdyYWRlIGF0dGFja3MuDQo+ICAgIDEpIERvIHZpYSBSdXN0U1BE
TToNCj4gICAgICAgICBHRVRfRElHRVNUUyAvIERJR0VTVFMNCj4gICAgICAgICBHRVRfQ0VSVElG
SUNBVEUgLyBDRVJUSUZJQ0FURQ0KPiAgICAgICAgIENIQUxMRU5HRSAvIENIQUxMRU5HRV9BVVRI
ICh1c2luZyBzbG90IDApDQo+ICAgIDMpIEtlcm5lbCBSdXN0U1BETSBjYW4gY2hlY2sgdGhhdCBD
SEFMRU5HRV9BVVRIIGlzIHNlbGYgY29uc2lzdGVudA0KPiAgICAyKSBTdXBwbHkgdGhlIGNlcnRp
ZmljYXRlcyB0byB1c2Vyc3BhY2UNCj4gICAgMykgVXNlcnNwYWNlIGNob29zZSBhIHNsb3QNCj4g
ICAgNCkgVFNNIGRvZXMgS0VZX0VYQ0hBTkdFDQo+ICAgIDUpIENvbmZpcm0gdGhlIGNlcnRpZmlj
YXRlIG9mIHRoZSBzZWxlY3RlZCBzbG90IHNpZ25zIHRoZQ0KPiAgICAgICB0cmFuc2NyaXB0IGZy
b20gVFNNDQo+ICAgIDYpIFZlcmlmaWVyIGNvbmZpcm1zIHRoYXQgdGhlICMxIHRyYW5zY3JpcHQg
aXMgYWNjZXB0YWJsZQ0KPiANCj4gICAgSSB0aGluayB0aGlzIGlzIHdlYWtlciB0aGFuICMxLCBi
dXQgbm90IHRoYXQgbXVjaC4uDQoNCkl0IGlzIGRlZmluaXRlbHkgbW9yZSBjb21wbGV4IG92ZXJh
bGwuIFRoZSBvbmx5IHBvc2l0aXZlIHBhcnQgb2YgdGhpcw0Kb3B0aW9uIEkgY2FuIHNlZSBzbyBm
YXIgaXMgdGhlIGFic2VuY2Ugb2YgR0VUX0RJR0VTVFMgaW4gdGhlIHN0ZXAgNC4gDQoNCj4gDQo+
IDMpIERvIHNsb3Qgc2VsZWN0aW9uIHdpdGhvdXQgQ0hBTExFTkdFIGFuZCB0aGVuIGRvIGl0IGFn
YWluIGFmdGVyDQo+ICAgIGVzdGFibGlzaGluZyB0aGUgc2Vzc2lvbiB0byBjb25maXJtIG5vdGhp
bmcgaGFzIGNoYW5nZWQuDQo+IA0KPiAgICBSZXF1aXJlcyBUU00gdG8gYmUgYWJsZSB0byByZXR1
cm4gc2xvdHMgYWZ0ZXIgb3BlbmluZyB0aGUgc2Vzc2lvbiwNCj4gICAgQ0NBIGNhbid0IGF0IGxl
YXN0Lg0KDQpURFggY2FuIHJldHVybiB5b3UgYWxsIHNsb3RzIGFzIGEgcmVzdWx0IG9mIFNQRE0g
c3VjY2Vzc2Z1bCBzZXNzaW9uIA0KZXN0YWJsaXNobWVudCwgYnV0IEkgZG8gdW5kZXJzdGFuZCBu
b3QgZXZlcnlvbmUgY2FuLiANCg0KPiANCj4gSXQgbWF5IGJlIHdlIHNpbXBseSBkb24ndCBzZWN1
cmVseSBzdXBwb3J0IG11bHRpLXNsb3QgdW50aWwgMS40IHNwZWMNCj4gc3VwcG9ydCBpbiBUU01z
LiBQZXIgMS4yIGNhbiBiZSBmbGFnZ2VkIGFzIGxlc3Mgc2VjdXJlIGluIHRoZSBBUEkgb3INCj4g
c29tZXRoaW5nPw0KDQpXZSBjdXJyZW50bHkgZG9uJ3Qgc3VwcG9ydCBtdWx0aS1rZXkgZWl0aGVy
LCBzbyBpdCBpcyBpbiBjb250cm9sIG9mIA0KYm90aCBTUERNIHJlc3BvbmRlciBhbmQgcmVxdWVz
dG9yIHRoYXQgc3VjaCBTUERNIGNhcGFiaWxpdHkgaXMgbm90DQpzZWxlY3RlZCBkdXJpbmcgaW5p
dGlhbCBleGNoYW5nZS4gSWYgVFNNIHJlZnVzZXMgdG8gZW5hYmxlIGl0LCBpdCBzaG91bGQNCmJl
IG9rLg0KQnV0IHRoZSBvdmVyYWxsIGRlc2lnbiBhbmQgZXNwZWNpYWxseSB1c2Vyc3BhY2UgQUJJ
cyBzaG91bGQgYmUgaW1vDQpmdXR1cmUgcHJvb2YgYW5kIHdlIGtub3cgbXVsdGkta2V5IGlzIGNv
bWluZy4gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0KDQo+IA0KPiBKYXNvbg0K
