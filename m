Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BD7517BB8
	for <patches@lists.linux.dev>; Tue, 22 Sep 2026 23:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790118468; cv=fail; b=lpUVV7HFu3hPnPw30TERPAznenODjqtgAWImI78+H+FG5G2VZAw1KEsihRQBKdkjfYU32+vARChb/8m15ZLwtBkub8u47/IOEXhg0W9eqwbmU0tfT9rXZzVfFhRU8/jdpEtjALcVOchkS6sD6jiheodCctk+e8ybusVADW8Rvc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790118468; c=relaxed/simple;
	bh=EceUSlhFw1ZUdrVNIzTOkztTNGHuXWvUTeGwam59+o0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ie0MZXbge8IywvEp6ezHvQGzHF0/YJGwoMxggERnv/o0n8mAyo52gSDlGmDKZTZrMxmwfyfJ2c05hQuwgzylUHvHF42WNB4aJKRvBQI3YGA0gnplIQpOem9jL1aOSj9Mk9LaizC26BDdY+ZmvA2YiXST0pTgdpnlQfHREH2b+lM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=InKDiK01; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="InKDiK01"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790118465; x=1821654465;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EceUSlhFw1ZUdrVNIzTOkztTNGHuXWvUTeGwam59+o0=;
  b=InKDiK01rYhSJtjE2r72Xw6EiNxP8P0LAw/bcYFLIkutUBiTaLZ7mQq5
   BV+Sd/AHGJb0Mth14g61jdJvqDGuC+LaTjQgJjuIqMFjvd3QBf8ScKTjA
   ihJ37nU8yO+R0ais47K9MUvpE6zs7WiJC0YN9lUxugdUCmH//u6O1XUyX
   Wk0txk2FMdweU8HtRt0XwSjlUGQEffscDko/9IDmfREUvXEXQQz8/Zp6F
   qEOTOEnfnvRuZ/cgF+ynNY3e333kBe5YHhpLeX6qpSnrYqvD99dZlCoKQ
   VG4Squb7MoScMA587857EL75OqzPgmpzr4f7qYVTP9d9vAsrgSHhCxpM9
   g==;
X-CSE-ConnectionGUID: /eT7DLV3Q8+6TxWKJ7BXoA==
X-CSE-MsgGUID: qkvXVefgSy2YIe8bbRiGxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11913"; a="90637798"
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="90637798"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:07:45 -0700
X-CSE-ConnectionGUID: eugOO0MyT+G8qd2sioZKrQ==
X-CSE-MsgGUID: ULU0Y198TbKB1faW/rt4NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,117,1787036400"; 
   d="scan'208";a="269856320"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2026 16:07:45 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 16:07:44 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Tue, 22 Sep 2026 16:07:44 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.58) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 22 Sep 2026 16:07:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HYrs1rwt2vg8Bj2+uel6LkIDQQxzPadIEtS4iM845VY/3UxiWjpTV9W1L9CXGUqv43Y7koZrPd1lQRpW30jL9cXXWgkDb5xh2Ge3FU0T4W6ZL5eFBqRUEKLVfLv33dvf6CeOUFyru8ULzoBNnl/gWkQ84KKpzeUCwb2ilka4MRrhPQOd9ZQJ0fENL6IoFYaS8WT8bFpAYDFGVOzhbPrl6J+w+VNBUUu4No3Mw6k8yhFc1zO/k+LzgaUrGU9ktBLgbzc1gSE1nLp9zCMAjCCiNyrKXYWJANWlhJYxKAJEpIuXZXdw5h55EhodjqwlZoB0Z7+sLwzFtTu7gboQ0Fa2iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EceUSlhFw1ZUdrVNIzTOkztTNGHuXWvUTeGwam59+o0=;
 b=vewU6JdRx1KSXTyHTwGspLgPL3Zda2t5WOma7k5BP8DIfFP+wh3nEKrx6OGGfMj/tJvpfi/TxW4SmP/0L6VyN7mXJizJm1hjjtceA+K5mHr2RuJcElirddPF27Hv7xjmuTMjklAv7slp+hXrcfDMppRsYxZOZvmYyRxEylfR4lAn7qRhit2lqLAcyW+57UlgREg9ky775j/xU0JzRkI61VzamsEYgjVml4mGihb7RU7MUf3XS6+ONfwO3FqNC9yXc2l8dj1BTP8IrRgFkjyX06dUfTfGeADtx6aVnbIJ0RkWCTxaT4gww9r+QoND9g2V786dwG0SvGgcYe4Wbn2bNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA4PR11MB9154.namprd11.prod.outlook.com (2603:10b6:208:55e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Tue, 22 Sep
 2026 23:07:41 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0451.014; Tue, 22 Sep 2026
 23:07:40 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Moger, Babu" <bmoger@amd.com>, Babu Moger <babu.moger@amd.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Drew Fustini <dfustini@baylibre.com>, Dave
 Martin <Dave.Martin@arm.com>, "Chen, Yu C" <yu.c.chen@intel.com>, "Box, David
 E" <david.e.box@intel.com>, "x86@kernel.org" <x86@kernel.org>, Christoph
 Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each
 mount
Thread-Topic: [PATCH v12 14/25] fs/resctrl: Rebuild free RMID list on each
 mount
Thread-Index: AQHdRjEGmhlXIGqpDky2ZmL1judTGbbZVbkAgAHAXACAACkxAIAAAdqg
Date: Tue, 22 Sep 2026 23:07:40 +0000
Message-ID: <SJ1PR11MB60836386E446E04EEF226029FC832@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260916231320.14502-1-tony.luck@intel.com>
 <20260916231320.14502-15-tony.luck@intel.com>
 <8bd7c456-c11f-4c8e-9b95-6825a00194ad@amd.com>
 <arLlcFYZiu7OcBFc@agluck-desk3>
 <a6a2e7a1-9b07-40f1-971b-9e9866bee048@amd.com>
In-Reply-To: <a6a2e7a1-9b07-40f1-971b-9e9866bee048@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA4PR11MB9154:EE_
x-ms-office365-filtering-correlation-id: 62cefaec-0404-4061-8f93-08df18fe4d65
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|23010399003|376014|7416014|1800799024|10067099003|22082099003|18002099003|11063799006|4143699003|56012099006|38070700021;
x-microsoft-antispam-message-info: kxhXGrKxOakD+9Q+6F1ObE7jJQs78oOI0stNn8CJFOO0FbyCM29sT9++2LuLDTjxdmjuRBmuzLMR+Ifb5pbpIIJR5Hffl2gZ+OXDgp2SSrSO8ac4OMBFknLzHlCw/R0olREkpDTMmH6h69m4jqT2IBxv5fwKChItkHiThrwJTDDW3SAmTir6DJJtpNA/Yrjk9ERj0FjwpN2f8dirDcNKkZSnK/iP+RYjYSWNipnRwiJDdwRj4QTANcTWdLp7ncOc4lsjJzy89un8+MdTs8nRKrbO06MJMNKCQQf/dRh4yEUt+y3+bW0O7Hx/zRfWRplXF9uyBrPu/RoidgYXYOyw+0aLc9o34MSzrJgt0RNrQqv/jyrgis2fl9Z4KPkUqNoUHzNLByKuA2cHXNMHkJwZdenYmEpO8ZrajTiW4qFSCdDtaD8DO7DOujw1rvHyFDV+HCw5GhglaDz7Gj+RzoU+m9FGvsChIpp5K/G4ipUEZmXvmWWVZm/XRItukMN52nzjC5nji5f+b+AHAhGzRyEUzjnSiFEC2gUwYJlX+kLiYkDuKMc9AkKTUDcHu8UnTdhcZtKSnVlvZ/LZXLgK51S/SHvUH0thVIu7m+QtkvJjAOLGuYcJUboyTB1lcxCGk1Cs2KRy/gL6QPUsaKp3C0jf0IrRLHfDLbYtBdLML3lnD64EowamhvLyhkvBkutPXgx4qkYXTzLAS0Cwaxv3RiJGiyVVw+uy/aiSaMp6YiZ8XWY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(376014)(7416014)(1800799024)(10067099003)(22082099003)(18002099003)(11063799006)(4143699003)(56012099006)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkdZQWE0SUdUcWw1TEpIVVJoOVoyTm1PWXE5Ni9iZzVPdFpBNHRmN2Z5UEpT?=
 =?utf-8?B?TUJKdkg1TGQxQjZ6bHdsSkJEVEhyR0lyNWMzUkkvdklOZklmbnAyelpMamVL?=
 =?utf-8?B?bFgrL3ZUanFMWUFmb0VLcUhjdDFwa0R1cCs5b3JHcVpGbDNMTlhnRVlBNTBX?=
 =?utf-8?B?dW52ZE4ydjU4eHFsSzB4ZVY0bmU4YlJXMHM2S1pBbk9zVUc5aEwya3RlMk53?=
 =?utf-8?B?M3M1V2s3eUUxMERIRmJqL05YTHpMckVQUm9kTU44bGlsdFM3amtoZFZKbUNo?=
 =?utf-8?B?WFBOdHlwbyszalpmRGp6REVPOTR6TVZjU1RSZW94KzBOMWNBdlNSc2ljaFBk?=
 =?utf-8?B?cnNDdVB4NW5VUzFqWGFWdGlmbHFCZUo5bEl5NXA4b2t2MWtuLytjSWpOdUs0?=
 =?utf-8?B?OWNKUyt0cWZEZU9CUHJ6anErZVNGL2ROMWU4VWlMZW1ndmR5Tm4xSjIreFAv?=
 =?utf-8?B?K1NVZVN4VlMrTG5iMnl2cUd4K2VMdTNhQmNNQ3dYZVo5OTVFM2dzNUl2QWhi?=
 =?utf-8?B?ejVQMjRxbEg1Yy9kM0lyeHdORnhVNWdsVFp1UlpuQ1RMVXU4clJmOHI4b0ZJ?=
 =?utf-8?B?N3FEckRrTWs2WXUweEI2eUxZd0wzT0N0Z0tVbGpNVEQ1Qy9peWE0U2wxWFAy?=
 =?utf-8?B?b0ExMFEranV2V0taQmdLZzg4YUFqN3RWVTBLbE8xUk8wREx4NStpTjZla2Mx?=
 =?utf-8?B?T0wzZU03Nmw4VGJua05TaDJUeEh2Ni9MMkJUcFVUVmo4NE0yREEvcGoyTHRl?=
 =?utf-8?B?SEl3c0FBUld2SmlnNXNmQjQvNC92Y1dBaE5kVnFHMzZud05GSjkyTmlPamla?=
 =?utf-8?B?M2Z2WUs1OEdsbGlNNmhTNW1OTzZsWWtFVlExNkhIQWNGaGhKSTBMWlk3WXpI?=
 =?utf-8?B?Zm5PRGtHYmFTTjltcG9LclNXbmZCdG5lTkVqcnRWNUpubDZVcUo5aHNiQTJY?=
 =?utf-8?B?QXpWWmZIQWphcEU1azUwRmR5djZDVGdsemdpN2xsYkU5UlpHeDRtdkhBMklD?=
 =?utf-8?B?V0hXSk95aHp3RGtXZ0tBdkpib2t4bDVJV0hUWEJlTnR3UE9XTDgvZFdlOVZW?=
 =?utf-8?B?OVhMRGc2MmlkZkpSR0VxeUpES0lNQkhKMnlUUHlOZU5jRG1zNW1RSGQrRnBU?=
 =?utf-8?B?bTQxTGZBdWwxQmJ6Z0JuN3NJdjhab1VXc1Bha21VUVZSVEN1QW1RSVQxQ004?=
 =?utf-8?B?eUpzN3VxalhKYzVISElPUzRtZk84dlQzOHliM05pTUw0T1ZqMXZLQzIyRG1k?=
 =?utf-8?B?S0ROR3dGU21SRjRwZjN4OWJiWjJMVEo4SDdpYnJ1VjlCcWVEajNBRHRtWUU5?=
 =?utf-8?B?cjJtRHRGRXpUYkNITmllOHlPL283Sy9kT2kxUS9yTkNwb3dSTVJUS1hZUTZO?=
 =?utf-8?B?VG5rbVN0WHB3SFViais5dHZNMW5vdzdGeDBZSm8reGl5VG1iMzV0WVRLaDNB?=
 =?utf-8?B?UmJmbThna0tUdSt2d1h4eTBIc0NlZUFCUzhERFZBOFcyWUVLYzBBR3FTaG9H?=
 =?utf-8?B?QUlaTVZ1TXBlb0xYbXhmRGtBNkVsRUFySjVzNzBMZFFXQWNXNUM2bVQrbk1r?=
 =?utf-8?B?SzU3UG03MCt6ZEJ1K29iQWQ4cnNaR28yU2kxTGljUjFvN0M2T0V2djN5UVhj?=
 =?utf-8?B?V0Ntb3NTME5sRXpDYTcyMWI0VDBRQzdVUHBNR09iUlJDci91ZUFEbGVOQWR1?=
 =?utf-8?B?U3JVQXhXUWg1OEtZOFdHVlFJZkZjRHkrQnc1aDk0NlpjUEtIb2RYSy91dzV1?=
 =?utf-8?B?YmE4Wm90bjdlZHRkcCs0eU4yWUhVNmt4ODFvU2R1VzdiSkpDUE9JNEVkZ0Jp?=
 =?utf-8?B?d1hkRUpzMW1yVmoxcHJBWDRRc0tyNTk0clZRWlo5bjUvQ21ubzhudENhc1Aw?=
 =?utf-8?B?UllrUDdydVZZK2t5NFdPeGZmMlowZXZIbVR5bmYxSDB1TTBtQnFQMFMyYlQy?=
 =?utf-8?B?V21QWHppWE1lNVRNSEY0OGhqUUYwdkxHdXJmK3ZraTVJb0lqcTRYVEZDYk9I?=
 =?utf-8?B?ZDZWRWpHR0d4b0Q3ZGRCOEw5MTc0K1dUOFRIc3VCMVJVOTF5Umppdm9KbGRW?=
 =?utf-8?B?VlJZRmFOK1RIYnM1UjlFcU95d0l1TDQ0NUZlMnhRcTBQeUhoeXdtM2JVTDl0?=
 =?utf-8?B?c2I0THk0K3NSS2owSCtKUG56Slo2dVZaSUwwNzMvT0JBQnNhNk96SlpxdmU4?=
 =?utf-8?B?WHdUUkxsSHBWTWx6ZVZPNUZpVzUwbUhWeHpPcVMxS0h1MFE5MnRQL29CdUhL?=
 =?utf-8?B?WXZQNURUU3BnWXFKbkVpZ2FzdEVWZlNwUXMyZFhUNVZWeGZORzdkbHJNV01H?=
 =?utf-8?Q?Br34/6YGtE7ojM8+O6?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ke7HXsOs9r15bKB4BSjFqN0fsup4sIwGXYHNvMWh5gVmDXqtKSx50BaYDqYlWmZ82MpmmneRrPOWAiO3QGc9noRW2B4grQNou4nkSwyjt8+bp6IA6ux7CnfqNO+NDLG0HU5HfT/69m1XMoCQNGmYqlyZxCdkoNfQ19X5xXTqr9aOqbD0MOJDe2/w7XHYMfb1FEKolgmshHf0KT+Yw+Xwl7WdRTauWuCG4wT30LQe3lM7nBFDC/J9MRu2LIK/VczismmKZYJPGKtATZ0r0+QA0n052iHMImU1aP67/rncmxC1Euil3TYrRnUoOGNVGNDc6pwgoen9G7UWMISlRqLJyQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62cefaec-0404-4061-8f93-08df18fe4d65
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2026 23:07:40.8807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /SZyoUo8xKXqD6WybICI13SOdCd1kesTVFiIU3NO+Qoame+mYo0qzrp760oVkTuoqq7GcCo4UucKPKlE8C93Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9154
X-OriginatorOrg: intel.com

PiBXaWxsIHNvbWV0aGluZyBsaWtlIHRoaXMgd29yaz8NCj4NCj4gbGlzdF9mb3JfZWFjaF9lbnRy
eV9zYWZlKGVudHJ5LCB0bXAsICZybWlkX2ZyZWVfbHJ1LCBsaXN0KQ0KPiAgICAgICAgICAgICAg
IGxpc3RfZGVsKCZlbnRyeS0+bGlzdCk7DQo+IElOSVRfTElTVF9IRUFEKCZybWlkX2ZyZWVfbHJ1
KTsNCg0KSXQgd291bGQgd29yayAuLi4uIGJ1dCBkZWZpbml0ZWx5IGdvaW5nIHRvIHByb3Zva2Ug
YSAid2hhdD8iDQpyZXZpZXcgY29tbWVudC4gSWYgeW91IHJlbW92ZSBhbGwgZW50cmllcyBmcm9t
IHRoZSBsaXN0LA0KdGhlIElOSVRfTElTVF9IRUFEKCkgYmVjb21lcyBwb2ludGxlc3MuDQoNCi1U
b255DQo=
