Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C0532D42B
	for <patches@lists.linux.dev>; Fri, 10 Apr 2026 23:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775862208; cv=fail; b=kRKsXxU1p5O44O65//8Dsw/Tesegd5PtI6mOxaQAQ/M9Gqt6YPc41ippiCt6SNsfITbcZzokYHnMbnMpCrqTpH53+1NxdlH/qzpcUDoyw7vkTTS4ACy+1tW9q06BVreEvqUVrK6KSsL/cUMsHCd1ufEMJC+Ao2/0Z5o1rmZ1OcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775862208; c=relaxed/simple;
	bh=vfauW9o0Hq0smBsw+XUeiBdmRR+oOJ5nOowvjj8VWvc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mESqxwyjFkkV0J3q3886BKKBg+tVOfsJvsDCsZyxRjRJZQ7PMlpRum7z0eUx0AXokQvutSA9pDKAJ/BXoOVl/UFezxJLKxzlTKoSuOteArLhDsISxUE3FyoA8Ln9phKI7lhM1ULxKY8cZC31i6JHmS9CTv//dDp0tnbQSbYZDGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N0VQlfVM; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N0VQlfVM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775862207; x=1807398207;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vfauW9o0Hq0smBsw+XUeiBdmRR+oOJ5nOowvjj8VWvc=;
  b=N0VQlfVMNBFD13YzqxvX+KDAs3B6YGOWlcK1Xn51gt1bg38LoDCgqq1T
   1TR0+AvO5vPlH7fGZ7TvnRzFnUMdRgWd5oHXfxoVeU1obB3q4U6xRQSSE
   GdG10UYuunZ0K9+EjYkPv5f7E/Pj750erLw1UxK2UjMdIM1jAV+UKK8Rb
   P4FIrovuAfhXuLRqbsp9PkiEVveEmF7TN1tr66b+PikW00V0yh+U3zM8c
   1fy8AsL+2OJMs0VFYx5TJQ4MhSNnV0sfrKlvc5Drfyy+E0khSaNgNLMJk
   QZAVuWawWCiKxvaSk64p5lnUIuY4BJLVSnj0E8+93TbE3EC3jBZ6ZGrdU
   g==;
X-CSE-ConnectionGUID: Pw1Q6pasSnW5s3ujbaof5w==
X-CSE-MsgGUID: U/EIwmvfSZa4b4QL+fu+fQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="77071306"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="77071306"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:03:26 -0700
X-CSE-ConnectionGUID: RuCS0cnhTc6o6jRKugTLKg==
X-CSE-MsgGUID: anSY4cPkQ8C+LwfMjOqr5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="226504643"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:03:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 16:03:25 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 10 Apr 2026 16:03:25 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.58) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 16:03:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a2ImFb+WKwnCdaZiumw/p98T6oigWWtyu0SSS6qdLfM4Q/P+VWNKa0XyGoWhJo8oDO0KbN+1S6Jy0FSqEYHW6L+6ZFI2FEOx0iqogE6ZFWpJRHVocbavWEZvjpBiShlVWOwP6F49b1YyjnN6hxbMUGCDEZVVCbt0BJF0tLoE3imFIr48GjtWa4xpWwFDkPbxmHsDDmmW1Whx0ASxZU2SwaiA+nDvlKmnhWV9GvG2Y5re8AQFZDX245/0t01mySZEb5vzXI5nEB70ZEylUYc8cgxXrom+sidK3wd43stfIerPQC1K3HGLdmnU4vZMJtXMpWWhXLe7lNW8K0iZY+Frbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfauW9o0Hq0smBsw+XUeiBdmRR+oOJ5nOowvjj8VWvc=;
 b=Ud/Er/sLLHeAXEtQusMjabF+heTN8CHWw7LLUjqQZMz5j1FZPYvwYUjhtsNJgz0iIB6hE9CjppfJC5gu6VyejBesc6QRRsjKUFvULfXarIexfhDDDDuUjdMXALkvTS/71eGwq4uFT2lJ8WHt5QR4pon2wB93b0sO6gcZ6Wuq6lsXCX/QjaZ+MsdELIiuN7VN0MCBK+eeRMNF3BVGSSSCorfT7byTDb/oRZmZpS12YAefFGm0dxTvzBdCNXT82ddIgpHlc+L8r8aedgxRW9t193hdLTPMvoZswZv1eSp+JE2DOL901+Z0K5S9GmXDj0ZgkU3FTSmdnYjGKGAiy3rdlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH0PR11MB5064.namprd11.prod.outlook.com (2603:10b6:510:3b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9791.32; Fri, 10 Apr
 2026 23:03:23 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.041; Fri, 10 Apr 2026
 23:03:22 +0000
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
Thread-Index: AQHcwI5HlovBdt4MTkK5Ga90lG495bXOGYQAgARvGACAAAugAIAEq10AgAE5ZgCAAD4VAIAAJ9SAgAAbHOA=
Date: Fri, 10 Apr 2026 23:03:21 +0000
Message-ID: <SJ1PR11MB60830F421D22C05C8F6A27C2FC592@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260330214322.96686-1-tony.luck@intel.com>
 <20260330214322.96686-5-tony.luck@intel.com>
 <45436044-202b-4d77-b552-2156be47a52d@intel.com>
 <adQY_m8I2jUiR88k@agluck-desk3>
 <e85cd466-2202-4b40-82ed-91e421d8e073@intel.com>
 <adgNfJSeHVyBXumt@agluck-desk3>
 <c948c358-1dcb-4896-9c0d-239e99d89e72@intel.com>
 <adlIdusn61pKB3oq@agluck-desk3>
 <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
In-Reply-To: <5a62a2b8-fef8-4808-bbcc-c268f9013651@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH0PR11MB5064:EE_
x-ms-office365-filtering-correlation-id: f60184ba-34c2-4615-853a-08de97555cde
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|38070700021|56012099003|18002099003;
x-microsoft-antispam-message-info: oZTPKS+6pXiprnCV1xeBhgDDtKQlStvP9vOmlSfm9OwbZ0BdA93VI6Qu8u5yOs6VNNdwJJOu9Dw6ntKgORAbL1/yrpMdVntB6YUI5huEpVSmT/SMNOSXRXWnDoYsHDv8vhCo1qGcAAHXLQCfWX3OZHc61JtL8Xzv3ahpSmk+MUMzaicB18rozWSm67srMExOdBoEFuco4/xGnGYX2xMF8Zq4KUGSuV6/0fqQqhoMxXkPjx4dUsb0gm6PSyPBcNGNoDa237N5XhET0JGugDZD7+7dPr/eeOeFxa/x66vXrn/Z8vQrY1g5IVAOOnGf+QNHbyiHDWsyp4TPQlYe1CKMY442ZuysRDkqcGMIvkMHRI96Se3CtLogZSDlD8HRIosBmmnMdOROhtS8DV4ndc2TVHgutnW2+Th0zYAq0edLUt0wb+PY9b+jRKA7wf8CB+1DORldQbPTgr3qxOxzRIqT7XsDHDt2kC26bxO2m+tEt2QdaD+5sB9o/sgrWu6CGE5FDvR4Fd1f/BJIUzm1QdEHcXhPJcO9nhT7xpRjpdIV1EttvaY/LVQkeFebkOBYJNqJZnt+LF0l18RVN2uzA6L5fPkCIDm4RGTPhvj19p7yIQ8qGJrc4trMaKIC6nXGZFf5Cuv7NwoAQBHC6bnQw/BJm5Lmdpxq32fx2k8X/Ml4Yhi4tKx+bbSj33GrNVMdakDuTXOU+u8fNj6kooscX9xkg9h8DPAaNB5EBDXnlPc40pAI6m7LXGyr8o9Nt7nHzJSfLjrjvIj1yIOwpHNxncUPaAlD4bJeaSjjiUs/47/yI4w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(38070700021)(56012099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N1F5NS9uaXJ2aTdvcTQxQ3RxUmx0NGxPSXpUYW1QNkFML0o3MTdBVTE0amhs?=
 =?utf-8?B?dk11aE1rcjJpRW9Ca0JNRERZeDlybm02cWdQb1oxZW5LSWVBVzhuT1pJL3hj?=
 =?utf-8?B?SHpaQmQwZWtyZmFET0U3TkFxMGdSVGtYa2pBSnlvZkdvcDhDbkJRWnl4dlVV?=
 =?utf-8?B?TVFUZEtrbXZzdHZVMkVjOUdScVpwbWtrQktoVWpWUkQreWlEQkI4UURmTTEx?=
 =?utf-8?B?M2dmdDFiSlgvd0lrTTdEL0EyTTE1dDI4aGFpVXpyQ1JmQWtwT0FtWStUb2Jl?=
 =?utf-8?B?cURPUHdBMkNpUXRMSVdLd0x1OHd3clpiSXd4TzVRazlUWVpkOUt1UzQ3aXpT?=
 =?utf-8?B?Q0dNMExpMUJPcHB0VFo4NFJMeTZuT1JCOU84b0dmbGlBME9ubjRMWWRKSmdr?=
 =?utf-8?B?NG8rT2YrWXN2ZmJtR3FkQ2xQL1FMdCtsTnk3L0cycWt6RWx4bDVvQnpHa1Yz?=
 =?utf-8?B?VGI0YjU3bWVxT0JTc3RwU1dRb2JSbi95L2hzS3lPOUY1MTV4Q1FkaE02S2lN?=
 =?utf-8?B?a1hyNnlmUk0wVWNmTzhKS3Z4STRsU05tWlhmNkx4UndyRVFrOHFVUUg5emth?=
 =?utf-8?B?c3JieHI1OHZ5Q2xMcUFTbXhXbXVqbnVGMjhVaUFSTVBzUll3cHpqWU1IdktV?=
 =?utf-8?B?S1I2SVo1UEM1eGkrWUR4Q05nTlpiQTZ0UEFiSXg5dGMyRGxBQmhWYU9kblp3?=
 =?utf-8?B?aG5acEUxWXZ4VDlEeDVvVWlDSUdNL0hTZFlWaWVwM1ZoUVk2QzhXc21rTS8r?=
 =?utf-8?B?K2drck5oTWlEd29ybGU1NXFHY0QxV0FpeVV2NUFyTU94dmtuWXc0TStyT0VT?=
 =?utf-8?B?dGw0c2l5REwyemQvTERLYmRKeHZCWFRERXFQSmt4VmJDejIrT2lOenM1ZDhs?=
 =?utf-8?B?SGJuVjNXY0MxMjNnQUdSQTMrZ01SaTdObERxeDgvY2ZsYzlaSkRodDdYem1D?=
 =?utf-8?B?ZXhpMWs3Y2lqaFVybHVWbGhYNTRtcUl6SGxUczlxcUJTOWNpU0tlRm5JdTZv?=
 =?utf-8?B?WVo0d3NGaGN1c29hK2FOUWtMQ2Vlb1FmZU9XZGdlRmdSRXhPaFFQajAvdy9M?=
 =?utf-8?B?QlMrNUJ3ejVJa24zTWxZa20wRmphTmFldXlraklvT3ZlWjNGR29DbzJrNEJj?=
 =?utf-8?B?b09uYWFOclZqN3huQS92aUl1TUdxWUk4VmJsOUJXUkZjaTB4L3I2ak43eGV2?=
 =?utf-8?B?QVoxaHNFT0xLRlRYZWViV09Yd0F5M2RzdzlIUDU4NHZLOVpUb21OVEJTakU1?=
 =?utf-8?B?cS9STXcvMFp5YzlOMitVTERIcGFpdkdJOTBQOE1nN2FKekUrRzZxd1hXSzFh?=
 =?utf-8?B?bmhqKy9pTlBJY1NIN0NIVTFJYTlYc001cllOb2dMMnJIU1lCUmRqNUFyTEQ4?=
 =?utf-8?B?ZDRsUGFCNXBPV24zZnNsRXRPV2l0MktlWDBxUEY2VCtjcWhiRVlvRFVkZzBy?=
 =?utf-8?B?R25jQnArNCtob0dKc0ROS2JsRlNod2RyQ3p1VVJDVitMdVFWYnBQTHNhRkk4?=
 =?utf-8?B?TTNBczFERWZYYzlmRVRkdlFUVFBLWC92dEhZaFFCOHVWc282K0crbERvZVhh?=
 =?utf-8?B?NjhwUUxOTXhXNWpZWUluVkRXL0VpRkpKS0ZVT2F3RDRtUDZ1YWMwMklXbUg4?=
 =?utf-8?B?b2Z2QXZHOVl3YlBoZEFqQ0NiaDE2YjcveXZMT0Q0Wmt6ZWRHRWIvSTFzNjMr?=
 =?utf-8?B?OTFVY0x6bHlCMnVnTWlMcitNMFovaHdyQ2ZxOXdnbFpGWk55OExyWEtYNGxS?=
 =?utf-8?B?cEZMWUJ3Q1R4Rmp3TnNzTzJrclR6SFp2Q2xwaWhhZWVzOTNzalhkanpEYnZp?=
 =?utf-8?B?d3F1ZmR0U3hES2hpa0N2WUtNUmNSekNmeEVxSWxMdlkrcFltNTREYjQ2by9R?=
 =?utf-8?B?WGtzeFZoTUpaYk4wSlg3ditwTVp1aXVHNEJSL3hVMDhnL2ZIYk8ralBKTmtw?=
 =?utf-8?B?RDZqZUxadjN5bjRDQm5TRlJhSTZicENVVWY1N2k0cG0zV1o1bjQ1SUZHSnh6?=
 =?utf-8?B?cGtMaWFmZmVUR0I5UEJKNEpFdTArem40MnFwaFprL3NmTnJxL0R6aFU3dWt3?=
 =?utf-8?B?dUQ0MFBVUXYzS3VvamZrNzJwb3VIa0svbGdGY2F0aXV6RlFEUThOVU52Z083?=
 =?utf-8?B?Q3dGdVp4cm85Q2xEWXhTVnR6di9wYVcvelo4dGpwQ3k2cnpJMXhrL2hnN0V0?=
 =?utf-8?B?RC9waUxiaEtxRUxFZDRBQjVTY3JSdndoSDZ3ay93eUhSMDJuTnFHOXJqcThX?=
 =?utf-8?B?U0RXU0x2b0hSbW1VS2lxcjFkOWdjR2VhYVZMLys1bEdHVkNZSExyMFZ4OTVY?=
 =?utf-8?Q?m1zWRHH+qLwe3RKUNX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: GZ+lorP1jnz/bBvbsA1dwo6CWIRwqM/lrZ6GO5MvB57KazItkV8RNnKQuYduQ+CauSpuCifbJcLqhc58rVvZfVaa7rLG9BqjdYruKalvQD+G/p1l1K2fWGqLdWvnfu6xun8/PR314FyfhD0otQG7KeyZ1RBrGP48UXVY8xRBnFphgA5izlk6wweSaVeVun41LrOZlAPAl5AKdoBgwFCLmbXCwo4fPE9/qO/3cegAgF3kx9khBWeZxsIANFLzVwhOQovGWJn12dhtnKYq+kzoC7a6+jzYketFnS5zwFBsC3PIdFyT1/+tH+XG8Gdh7a1bN+CrOBRaWx8O5iToOxOCOA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f60184ba-34c2-4615-853a-08de97555cde
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2026 23:03:21.8889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dYKMuMMvB+7LBBAvaxvXAkfgQaa2hc3D8Q/Xf5VoK/1ZOa/dflx3H/Y6E4ENdXM9v28QqiegkXMMkbjVCf930Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5064
X-OriginatorOrg: intel.com

PiA+PiBJIGRvIG5vdCBoYXZlIGEgY2xlYXIgdW5kZXJzdGFuZGluZyBvZiBob3cgdGhlIG5ldyBp
bXBsZW1lbnRhdGlvbiB3aXRoIHJlZ2lzdHJhdGlvbg0KPiA+PiBmdW5jdGlvbiB3aWxsIGxvb2sg
dG8gdW5kZXJzdGFuZCB0aGUgcmFjZXMgaW52b2x2ZWQuDQo+ID4NCj4gPiBJIHRoaW5rIEknbSBy
ZWFkeSB3aXRoIHY1IG9mIHRoZSBzZXJpZXMuIEkgY2FuIHBvc3QgKGFzICJSRkMiKSBzbyB5b3UN
Cj4NCj4gWW91IGNvbnNpZGVyIGl0IHJlYWR5IHdpdGhvdXQgY29tcGxldGluZyB0aGlzIGRpc2N1
c3Npb24/IEkgaW50ZXJwcmV0IHRoaXMgdG8gbWVhbiB0aGF0DQo+IEkgYW0gd2FzdGluZyBteSB0
aW1lIHRyeWluZyB0byBkaXNjdXNzLg0KPg0KPiA+IGNhbiBzZWUsIGFuZCBjb21tZW50LCBvbiB0
aGUgZGV0YWlscy4NCj4NCj4gLi4uIGFuZCBpdCBpcyBhbHJlYWR5IHBvc3RlZCAuLi4gYmVmb3Jl
IHRoaXMgZGlzY3Vzc2lvbiBpcyBjb21wbGV0ZSAuLi4gdW5sZXNzIHlvdSBmZWVsDQo+IHRoYXQg
dGhlIGhvdXIgYmV0d2VlbiB5b3VyIHJlc3BvbnNlIGhlcmUgYW5kIHRoZSBwb3N0aW5nIG9mIHRo
ZSBuZXcgdmVyc2lvbiBpcyBzdWZmaWNpZW50DQo+IGdyYWNlIGZvciBtZSB0byByZXNwb25kLg0K
PiBUaGUgZmlyc3QgZm91ciB2ZXJzaW9ucyBvZiB0aGlzIHdvcmsgd2VyZSBhbGwgc2VudCB3aXRo
aW4gb25lIHdlZWsuIEkgdHJpZWQgdG8NCj4gY29sbGFib3JhdGUgd2l0aCB5b3Ugb24gdjQgYnV0
IG5vdyB5b3Ugc2VudCB2NSB3aXRob3V0IGNvbXBsZXRpbmcgdGhlIGRpc2N1c3Npb24uDQo+IEkg
Y2Fubm90IGNvbGxhYm9yYXRlIHdpdGggc3VjaCByYXBpZCBhdHRlbXB0cyBhdCB0aHJvd2luZyBz
dHVmZiB0byBzZWUgd2hhdCBzdGlja3MuDQoNCk15IGludGVudCBpbiBwb3N0aW5nIChhcyBSRkMg
YXMgc3VnZ2VzdGVkIGJ5IHlvdSBmb3IgY29kZSB0aGF0IGlzbid0IHJlYWR5IGZvciB1cHN0cmVh
bSkNCndhcyBzaW1wbHkgdG8gZ2l2ZSB5b3UgdmlzaWJpbGl0eSB0byB0aGUgcmVnaXN0cmF0aW9u
IG1lY2hhbmlzbSB0aGF0IEknZCBpbXBsZW1lbnRlZCBpbg0KcmVzcG9uc2UgdG8gQ2hyaXN0b3Bo
J3MgY29tbWVudCB0aGF0IEkgc2hvdWxkIG5vdCB1c2Ugc3ltYm9sX2dldCgpIG9yIHN5bWJvbF9y
ZXF1ZXN0KCkuDQoNCkknbSBsb29raW5nIGF0IHlvdXIgc3VnZ2VzdGlvbiBmb3IgYXN5bmNocm9u
b3VzIHVwZGF0ZSBieSBhcmNoaXRlY3R1cmUgZm9yIHVzZSBvbiBuZXh0DQptb3VudC4NCg0KLVRv
bnkNCg==
