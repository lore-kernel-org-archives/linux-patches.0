Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AD633F59D
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 23:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772580391; cv=fail; b=QBct1qXZEr5NFhvocj1COXIyy3OeFopXWJp9pnA3l4HEOHSxJ6IT2I4Z4MwNa5U0O5JUE+1l/bU1kGnO/THwru5RSGaIFHPD8lTKObwBWJ4GFlvXUdEAmWPgLTo3+rot7kgXvUNfsvmEdEHALMAXFJqvKO4Ptdk5fLsfZNv6RyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772580391; c=relaxed/simple;
	bh=SaT8bQNOF31fWamiSqqesrCs0TzuAPgFhbZWPO7YR5Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YgJwyZ1QRPIBx6PW5Oc874Rh44GKeaE0uBlkMLwmxnTndg5UgU0cllYNuMgQGAVqQqYoukpplZP4p0EMxjwIriEEty8mPuXekPw0Nl1j7InciQACBwhwt/lflGePvblGEo3qoSzKnNA2lu0BQB8l+1xiuMt/G8pE0mk6CaPv7hE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AozXOPxb; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AozXOPxb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772580390; x=1804116390;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SaT8bQNOF31fWamiSqqesrCs0TzuAPgFhbZWPO7YR5Y=;
  b=AozXOPxbORN5SNt+1LnB62vaaoSRrn3ECqm7Xo79Rhv3hzZCPNynow+4
   6C18rHyeJRV/iQJ3/wVJBIOSt3bKRG8xLbnglFRW7snfqxKVlRZXCYvQI
   bjBBncOuTWFOlTHGcmholHDhp8I3AXVO/IYfkgv0OLTMWPo1myRLKrmSt
   wsU8R9nxnHhIwjseVQTevtTAFgeku8I9y34AFeFhYUyylKqCk/dthfnhO
   n/o+zp67xdt7nN3eICAWgLRiiaN/GvOqeOcH0cv7TFgJ88OCDoaf64C7Y
   YqsdANv0b2kTARkkVsggN5UA32oSdNj51TuHw7n7KT1T/N6jT8xjU/TUo
   g==;
X-CSE-ConnectionGUID: 02v1jLifStKR4UocN+hymw==
X-CSE-MsgGUID: YbTirVCEQxOCs6azG0fupg==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="72833093"
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="72833093"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 15:26:29 -0800
X-CSE-ConnectionGUID: 6QtsAjlvS+qh59gRUv+4Og==
X-CSE-MsgGUID: KEai6590SliRBIk17qiO0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,322,1763452800"; 
   d="scan'208";a="222821339"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 15:26:29 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 15:26:28 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 3 Mar 2026 15:26:28 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.16) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 3 Mar 2026 15:26:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F4UqMcaCgIYPt1oZFsaZY0s40A/in9gMF0XQCv7IWMbKko2eigi6COE81K+5i+z904kvKC/Y0lREEZJuGHhamW9Mp9pm1qCvCflNIbevSBfEc5EH7C59L5HTCSqXHmE5uD8YCuRPhTWUl/Y6RTxrwa8OrOnnQh7l/mZr3D8GdFApyYsDRJS/RiH4OI+rZX180ORXcMcQg5jC77Tsmuw+DstTJHgxHurMLMSiiPRo1EhZ1Dl/RIRQKMnNzkQKhHMxUSANrCX9EbOfspO93l+DDFT7uTgGJOFpFsF14ZH1mIlA2rheGgnoKLrEs8zqx4fugZe5AShCApqoH/oG9lsUEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SaT8bQNOF31fWamiSqqesrCs0TzuAPgFhbZWPO7YR5Y=;
 b=uOWmqdjivx7o2kVV1ZSCbxI4sDmoxtmoTVWylXvCDk8qX65QA9PPccui/M/vNGH3hVw9fpipkB2ZD3OW++BWM2ldZFyFi6Gnq5FukPyaN/VkdVv5YHHkHwCUfw3vlllMV1paasRoC+ZYKZsSkXxw0p9sAefBEPydiK5avESDV+BJdDaNlfm3e7fqIrRwM4bLkeinPsqwQ60BJmfFAbZJ64+QbTb0aywFKBrsDHX0M6rCxigQp1rzuw/8bL4FqW1UYG1fpyFo9MeV2I0W1yOsxAHSc893l3wmI10vFJYeFvhAhNCYr36Yf3CA5dI+ih8fDzNGBHh+cHbJ45DaFozxFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH8PR11MB6880.namprd11.prod.outlook.com (2603:10b6:510:228::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Tue, 3 Mar
 2026 23:26:25 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9654.022; Tue, 3 Mar 2026
 23:26:24 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "james.morse@arm.com" <james.morse@arm.com>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "fustini@kernel.org" <fustini@kernel.org>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "peternewman@google.com"
	<peternewman@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH 05/11] fs/resctrl: Use accurate type for rdt_resource::rid
Thread-Topic: [PATCH 05/11] fs/resctrl: Use accurate type for
 rdt_resource::rid
Thread-Index: AQHcqnTlWVUnwzR6X0CNTY4AreCz1bWdH/+AgAAM4ACAAA1FgIAAK2oAgAAOwYA=
Date: Tue, 3 Mar 2026 23:26:24 +0000
Message-ID: <SJ1PR11MB6083F6CC8D8B848FF56C5D8FFC7FA@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
 <956a7f8c9ff85b873ec85159a66d5e3c8b468d70.1772476561.git.reinette.chatre@intel.com>
 <aacmf_CM52gHRMot@agluck-desk3>
 <a3343e9b-e481-4282-a775-651a516164a1@intel.com>
 <aac8baGgAWgpWSH2@agluck-desk3>
 <29ae7f66-9e98-4350-9dd6-6781dcd5d0c0@intel.com>
In-Reply-To: <29ae7f66-9e98-4350-9dd6-6781dcd5d0c0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH8PR11MB6880:EE_
x-ms-office365-filtering-correlation-id: b01298bd-b98a-41ee-d041-08de797c4976
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700021;
x-microsoft-antispam-message-info: +1jTEe+FIRuXCluCmqknj0PTx7O6JGR4GEaKnaQUNDv4XMjb+L2hGGGQLUphVhDI+Cv9uc3KkBC3+tK4pT47guNKn2ReMYFjF7Mo73MNo5KHqeTUxCKc962CGhtLG8AVm4CFhaT/l54+0BeK/8AnnX/XKna+uu/blU+0plQkfVRVnAYXBGHlV3g+BfE11SoPwdy7AmyJcFFXkgKyA9GpKAmFsiBw20Jl+JbqE/1D0h7fvt146U4jljOnZM78Go+FDUonk8D2kD4r1MLGHtVHJB/Uyx8I7f79lmVEJ7tMpkt4WWYCxfgGyUOqruuSR/VmaRkH8BYciiCbeFbtBGFlcOGjkETLB6GH159WFddNBvA4JNwZtNqQtu8SqmB5l2+7nG7DBxlTv83GqP/ZRg9BtclQF4sBSssJKDOg9AkFS7c1fB5qfUTx7Puj+CsUMIex7TO2qLZDUdXuBS2DeK0N6mA0fZqdrOs7hodx6K/ft0522qlnJe0K+oSL/vACw0tN+COBP+RaZ3+6AgNnhEX5UvzpDWXgod37GADYwNCTH0kM8bddlv54EdoDWdBfCJsgb0eu7NH1LE8pOhECES1+jvBkp1Yedvh2mX8M7sAGb9oBlg6DB8ivnWfIlVlYK0sa4or1TNz3tDglssz5o+5Ca8E9DkMbuOPgQFE1t1GXAbfC0cjRn6L6uAZ5U+b4pUuDFZ5HdQad+ED7iKOcL47bkSYW8QdnztXF1TuU5UZxiemiDp4RgqUfTLluI85PEMqunx/Fr5uD47uZoj+IvZiW1EoecDNJZF7UXXsJoV4wvt0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWlYVE0xdnVuZjlvVVRENXUyak9VYk95V1g1eDhSOGNSdmUwK3k3VlRPMU5o?=
 =?utf-8?B?cEQvWU9mMGRodFRSZm05cFhQQm9lVUlFN2w2V0xTcWViNCtrU2xUSEYxM2U0?=
 =?utf-8?B?NGFWaVlUOEs4R2kyMElFVkV4dnVqbWF3dTdzdjJ4M0x3a0daS25ndU85Z0Jz?=
 =?utf-8?B?M00ycG1FTEV2YTJVbmkzbVFUVjF4TXlmbnQwZmlXTlhaQWgyL2puM3hhbTlV?=
 =?utf-8?B?ZjNKcWlDWDhUR1UrbnBhdmRYOHBIV0IyZFpLR2VNeUNtMW1LQk9qODZFNmVx?=
 =?utf-8?B?MnI5ODh0dVRpdUcxdlFId0pyVGx6YmsvWWU0WXFYTWR0TWN0d2QxRG1IZDV4?=
 =?utf-8?B?QjV4blk4RlNJTFJDQWR4SUVPTjZ2WEtadDBmY3FIdDFPeFFsNFZlOVUyVXJs?=
 =?utf-8?B?bWU5M3ZEVElGMnBTb0s0ZzFia0E1dHZ6SXhybTlHOU9VeThBd3VaWE9DaHJ4?=
 =?utf-8?B?Q2hLM3FoZFg1NEpLTnNHYk1iK2tJYVNCQko2ZHY3dXUyamZpdDljWHRCbmt0?=
 =?utf-8?B?NisxeDI2OTBXU2RkNmcvU3lZTDVMV0Urd0RTRHRqTXorQ2hTRWlIdnB1Y1pP?=
 =?utf-8?B?bnlQSUpTWHo4ZWJoWnBPaG44ZjBvR0p5N2EzUDFkSndrSEJicVNxZzVLK0kr?=
 =?utf-8?B?WTNJVXhXNUpoQkp6ZTkzeWZJakdYY3Jld0ZyTnB0NS8yN0Z6OHVFcUNyVnVX?=
 =?utf-8?B?T0R0LzIyUjNzbGhvQis4RndDWldaZjRkOE15bjhWVDhlZFJ1R0pQVXRySk9o?=
 =?utf-8?B?S0xqUWVRc3QyZTlNUU5zU21jZk5UQU1iL2JMWms0Nmh0UFBGdDZjUWhCaXVR?=
 =?utf-8?B?RlViT3haampIbWlqYTNqQWI2ckxUSmRpNkVVbFFGdHgydmZPMlQ4QXAzVVda?=
 =?utf-8?B?bEw0TVJuYVVuZDJ6VlpLVTBNNWZVQzJTWFZuaUlLYitGMmd6R3NZLzU3aFR1?=
 =?utf-8?B?cE9OQzhaamYvTHZLT2M3azJaMGVzdHQyNXZ2clBtQTBqK0JYY0NqVjU4VlpB?=
 =?utf-8?B?bTljYkEyS3cxVndSajV4Q3c2dFQvZjVZSEVaWDgxTXVwM1pMWUc5UGNKQUdr?=
 =?utf-8?B?dTQwSlI4MDh4eDQvUHVsOEhpMzg4bXRYTGF3b2c2TUhwTkNQN0tkd2t6WE1o?=
 =?utf-8?B?cVJzMEEwaDVVaHRkaHVxZTVkdmNFblhzaThiYkdramREenYvUGJoczFFRFY4?=
 =?utf-8?B?d0x3SHlTa2s3SkVTSlQzSjMya0JoOGY1WnBkazRFZnJwMHhSRXk0Z1dOSk9t?=
 =?utf-8?B?bE5WbVFRY1pwVStkNVRySE1PUVhNUXBzZ2doNVIxNVhEL25HaVVVbkRnbExC?=
 =?utf-8?B?QlRuK2k1Y1dJMW5JdjZ0MmN1TlhCRnJFeTVGa29NdUt1bHQ3YWtlSjdLUytI?=
 =?utf-8?B?QzYxSkZuVHNreG9NUDY2K1ZvMU02TEJ4U3g0YUhYRXUxQ3ZIMDU1aUtKcGQ5?=
 =?utf-8?B?eG9FRHlQUEd2a1YvUW1iUlE4OHBKRkMvR0Q4eDVESHZmb0lWLzJkN1RERlVa?=
 =?utf-8?B?NHh5cEtERE5hanZxL1FmZXNtWjdqbUM2UTErWmFtOWZFR2tsOTBHc3lQRi9Q?=
 =?utf-8?B?VkJzQm5TdlhseE1mclhXQ1J5aXRyV0tjakJIVDRRaG9xaTdDaWViQVBnVmR2?=
 =?utf-8?B?SHpzRi9RT0wwclRSMlRzQlBtYU0vOVVzWnZkdTlNaG45Z0h6VGFXMzhUUWx6?=
 =?utf-8?B?SGdWRnBrN29yR2N2eUlCSWlQN1JUdzFXZHFBam5JTk5xNnpYVFF4ZnZVbkJl?=
 =?utf-8?B?Y3NSaE9jeFluL2YzMVhuYUl1cm5xK2VCMExLOG1OYVBOQ3E1V2xRdDAveUxt?=
 =?utf-8?B?cjN1RVBHbThWc3ZQeE5yU3p6QmVnK1ZncGNtR0g0YjNMeE1wTmhtUThaQ2hC?=
 =?utf-8?B?Q2JXaHhUQnUrUm5wbzRaS3lDcERkVFl5cDBLME9GeGZCTVhlbFhVVGdQVThG?=
 =?utf-8?B?aDhCQmJGMndHTUV1cjYycE8ydEJDbzk1OHkwTnVacHNHN3lNeG54OUk2ZXIr?=
 =?utf-8?B?UHhRSXVYTkFkRGtQTDlaMWRQU25mYkpNZnExSTROS0N3U3ZsUTlpMnJxZm1U?=
 =?utf-8?B?emtaS1p6LzQrNk1mUTFpY05UQWZ4NndLeFUyNHd6cVo0bmNJanl0d04weDVF?=
 =?utf-8?B?WUZYM0FBQXhSaUt5ZlU2S0prd1BoQXBndld2TkhkZmVLbjNwTDNVaU5LamVp?=
 =?utf-8?B?b21Fczg3cUNTL3dLcXhiZHVWOGdWdGNsZnpGb0VvMXEyUWJKQlk4bE5lYkFt?=
 =?utf-8?B?NldSeXhxQ3hJVEhnK0FKbnVDRnJGejBoa1dJTVdXTXlNMVk2Q0RLelcvSGpa?=
 =?utf-8?Q?UF4J48n6Gxsvx1FlkQ?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b01298bd-b98a-41ee-d041-08de797c4976
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2026 23:26:24.8097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ylLlNRJyF4qlqFfx2+3DvSzlibtdwgN5SjV4HVCjMqY67O/0zM98f5AX3zTLq+5jdwM5KIokk0vEWjTu6xmKyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6880
X-OriginatorOrg: intel.com

PiBJIGFtIHNlZWluZyB0aHJlZSBkaWZmZXJlbnQgdmFsdWVzIGJlaW5nIGNvbnNpZGVyZWQ6DQo+
IC0gVGhlIG51bWJlciBvZiByZXNvdXJjZXMgc3VwcG9ydGVkIGJ5IHJlc2N0cmwgZnMuDQo+IC0g
VGhlIG51bWJlciBvZiByZXNvdXJjZXMgc3VwcG9ydGVkIGJ5IGFyY2hpdGVjdHVyZS4NCj4gLSBU
aGUgbWF4aW11bSByZXNvdXJjZSBpZCBzdXBwb3J0ZWQgYnkgYXJjaGl0ZWN0dXJlLg0KPiAgQXQg
dGhpcyB0aW1lIFJEVF9OVU1fUkVTT1VSQ0VTIGlzIHVzZWQgZm9yIGFsbCB0aHJlZSBvbiB4ODYg
YnV0IHRoZXNlIHRocmVlDQo+IG51bWJlcnMgY2FuIGJlIGRpZmZlcmVudC4NCg0KQWdyZWVkLg0K
DQo+IExldHRpbmcgcmR0X251bV9yZXNvdXJjZXMgYmUgdGhlIG1heGltdW0gcmVzb3VyY2UgSUQg
c3VwcG9ydGVkIGJ5IHRoZSBhcmNoaXRlY3R1cmUNCj4gd2lsbCBub3QgYXZvaWQgdGhhdCByZXNj
dHJsX2FyY2hfZ2V0X3Jlc291cmNlKCkgYmUgY2FsbGVkIGZvciBhIHJlc291cmNlIHRoYXQgaXMN
Cj4gbm90IHN1cHBvcnRlZCBieSB0aGUgYXJjaGl0ZWN0dXJlIG5vciBkb2VzIGl0IGF2b2lkIHJl
c2N0cmwgZnMgY2FsbGluZw0KPiByZXNjdHJsX2FyY2hfZ2V0X3Jlc291cmNlKCkgZm9yIHJlc291
cmNlIElEcyBsYXJnZXIgdGhhbiB0aGUgbWF4aW11bSBzZXQgYnkNCj4gdGhlIGFyY2hpdGVjdHVy
ZS4NCg0KSSBoYWRuJ3QgY29uc2lkZXJlZCB0aGUgb3RoZXIgY2FsbHMgdG8gcmVzY3RybF9hcmNo
X2dldF9yZXNvdXJjZSgpDQoNCkRyb3AgbXkgaWRlYSBhbmQgc3RpY2sgd2l0aCB5b3VyIHBhdGNo
IDUuDQoNCi1Ub255DQo=
