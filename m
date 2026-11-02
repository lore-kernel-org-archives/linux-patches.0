Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793614966;
	b=3J2xrDm5PAC3hjMvKbuZDjYWewEnupniLcCDCgcebSwnvMPm3LRySvElYhhuzfedSWdK
	 pnEkdPrW+eqOl+zYYYIHiOUQ/VYjlyPRKcyegDXiRTLCll69r4opKXuM5aU/YjCEYc+H0
	 5Mzv+boL8616QZMu7XCHT3aNjW2P2HwIBd0XsvBreqLjpqGrm7dxLLQav2KKkizNGUTrc
	 srhfgfZqRqIKFRo/poLbeQrHaoikGLjqZcZn5axH8AlEBTtaWYGywwlF8nDYl3qHgdkXT
	 fn9+slmGnmU8PI8iBkWsE78PXPbWTuTK4d9znR47h3UHjFhnvwEeF+2sViH3DyUR7eA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793614966;
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
	bh=8lNcNSr9FScFstrP15E/1yZRn5G0m/IBUpfCXFICjXo=;
	b=NFCANoo/ExfzSBar1FYgfp7j0sNUEbr+eGDCoZY3GrGIrx5/2js1GJqPtKEUqtxiY+dp
	 40kUHi/IIBjNYHNmLlthyw5YiE7KYYBNga2ZJDDl20/oySq6FKWXBkrB0ILzm+XW/yDff
	 mV6MeqcRdi25KEMuBgUG4RQmEfjTAq0ZQ78lfkVAJ4+zwrDuR6JocHkLsP8SAxNQeqvqw
	 QL84QNyVizvFd5SFFTpxsTIPFZ7EtXXngsP/aBLrZpmvhbhyA8h+Pv74t0UN8jwk64gm0
	 ZdR5wgqmiJFcxUUcSN+FMUtuk6vlDRKkXJxCt5a1FyuKOuEc3876SByqDr6546k5eZw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FykeoPf3;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E65606A324;
	Mon,  2 Nov 2026 10:22:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1E65606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=FykeoPf3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793614965; x=1825150965;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8lNcNSr9FScFstrP15E/1yZRn5G0m/IBUpfCXFICjXo=;
  b=FykeoPf32k+DJmw9R5ZoGSRIs82yGqf6m7H1E3lIP50S1Kkiah12IOrQ
   xMhEK1RhT1FPu/4gEf3XEL5KzY8AQLN7XxpDm0K8vCpD3AE7cGlHAImX1
   snLjRIC5bciQuUusTpa/Ebutr7Dpw3A+po9dRqErOrIFwoNhMu+JNGDNz
   8AwE5tJSxFfYk8FNew0EOruooOzq+WA/b/PVvDj80Wfk5YMhlK1EyIvAj
   l7mnSdwC7SUKJgbjEPNd4qzesHDAeVa4r2MHzuISwVxM/y3V1NRouC6IO
   FIU37GlTmA1T3qJu0j0ly7HKxCAm5ted8VCnzU733LC0gOM1c1qzxAxmi
   g==;
X-CSE-ConnectionGUID: 0IC32yS3R5ydIwb899flaw==
X-CSE-MsgGUID: Vn2vEg7DS/WUxem00wyjiQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11953"; a="2327219"
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="2327219"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 02:22:44 -0800
X-CSE-ConnectionGUID: RFy19GzXQWOrO5dGa8wN5w==
X-CSE-MsgGUID: 4v/4tyfKQm+J+ObWvM1Z/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,191,1787036400"; 
   d="scan'208";a="6214702"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2026 02:22:43 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 02:22:43 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 2 Nov 2026 02:22:43 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 2 Nov 2026 02:22:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aXuv/HyBhbGxB/XqPmYMAUb/V5yXuVozaLBsm8dN+v0fDP7rdNZoA4qfCiSlOIQ3lavsf2J1qCyL4K1pCkBR/aWPUpdAf6GpAE2uYOoOj7kF8za6IgkuTTc213YsgNOo8Cf4359IXlvs1Q7+g33DzhLJ2RkXZ9piA69onl4fO/tZ1dmdxx57ftS8hBY9+m9zgw6D125cbhRkFBkoMrf6Hj4QyBE8Y7itczlg463bXW8tlBzbQya9IPaG5E+KL2lgIg/21l1MmdKuhRlADXQ9tqnSI3cE3LNHM7yOLrZTAwolH/g9IDuAH8qLmtfxBFFmPc+CZY/Ht7dYJeNaEF+mWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8lNcNSr9FScFstrP15E/1yZRn5G0m/IBUpfCXFICjXo=;
 b=tGb6qSLfSlQDI/QPY8iqRojGpOSVNohs5UbL+J2K/tRWcwJduc/3zhLb+aMtVSu/6KIkq2CrtzpkaRBMe0tHSM4zZZR1BJJ46pWbcrJauhxa0+DXPgt6fzDDcrWnTxL3Z2tRG9hbDGNRS2EdmY2RD3Jrj+kMw9LCUsKtQ8Lb9jmPYgc57e8DY/xv5SXMgSfD0AnjrH2I0vr4pM7s0zZszm0FdSFVhFQDTmxjheK8bYAkXcuENrkGA8qDLB51JYBMj9PsTyIbnQQUPqbEWtjDIY/LBr7sLgty48SZV7b7fBjmEjacI6UdGhem6dudvvKaZINB8mJYW/W57k1OIdCtrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by IA0PR11MB7751.namprd11.prod.outlook.com
 (2603:10b6:208:43a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.11; Mon, 2 Nov
 2026 10:22:17 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0569.011; Mon, 2 Nov 2026
 10:22:17 +0000
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
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgASDuQA=
Date: Mon, 2 Nov 2026 10:22:16 +0000
Message-ID: <DS4PPFA84FA90FCBFA0773CA4564A0DB095E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
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
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|IA0PR11MB7751:EE_
x-ms-office365-filtering-correlation-id: 041cf0fc-4a2b-456e-41ec-08df38cb2b98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|7416014|376014|38070700021|4143699003|5023799004|11063799006|56012099006|261028144727099003|261026121527099003|261021121427099003|261022075727099003|261026140227099003|261022105027099003|10067099003|22082099003|18002099003|6133799003;
x-microsoft-antispam-message-info: Orwrotj7gLUOSkmoKQlEzD2O87tkGk7BtQCC/1BOvnlPoPAZA0d5sQ8tMuWM4YGOoAJISujril1X6U6pXWkJ0Bekvk0e9ChiLb2t7pRLNV7FEyGYZwzHhWdNotF/awHB9mpdY0tWrqa3L8omHnT34ezlujmLHos+dUm9PN1l8voJqfYN7meBXEBGaYhAWsYmWIQvosK07lbCoPtaPaiBLXIQqht7X2Y6BDbwWltDsA+asUlkU0xCxKX2oCpBCYmncMfc3BSF713AEAhkaIGBEdny9POUf6eIvTScDdTXGkHMUt46S30NpC4a3odKvfPEEKqYI7BqoU0XMDTeWAUB43MhkaiMJm2EC590GE/pQ/IootujLsLMevjK3pkAsxIJMAZGuUAaSUXj1moAmciETuSRBVHYr8nYV3y5gKfxhyxF4G+gVg4lx53f7qOip9Wh08NS4ZYJj5Dra8QktTIwquOCVjXVV4b3MR3sUleR9eEc3qHRbo6TIgeXrjjQbtCSQIzRLYjjNVHYmXWc3RXO+aWjtBUXZUerdO01lk4a1+RlbA65AXi0Eaa22NZZY5nYrGX6Uayy2fl7Woc1kZ41WORHfnNeaTCqXzNJb9pgY1RIYQIj6RoLOn6zMKjPpALanIwbSq3M3dfKhM9TRFvLa7RtQ40p6s9oCazQagsmJ+eVZ9PHWxumXsoPgGcizLFr7cF/pKztllqrqknmJnv4Dzib+E/o9NoR68N4ZDq4f24=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(7416014)(376014)(38070700021)(4143699003)(5023799004)(11063799006)(56012099006)(261028144727099003)(261026121527099003)(261021121427099003)(261022075727099003)(261026140227099003)(261022105027099003)(10067099003)(22082099003)(18002099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TE1PdCtLQkRoenlyNjJsS0MrZ2MzS1dJVnNEY0NEY2dGM24rMzc3c2F1Rzho?=
 =?utf-8?B?bzZlNXpqckE4b2gyUDBVUk1VanFBVG9hWHV4MjgyWTYwMkJUNHB5R0ozWEVr?=
 =?utf-8?B?dWp5ck1idk15Y3g3clA5dkwvRzErOXF0VC9ML0FjZnhYZkp4SmlpN1I4YVpk?=
 =?utf-8?B?QkwyQW96eFZCOGxNNjJiM2JpdG9rYWxRa2xHV2JMMG1uSzVxbnNaUjFzNTFF?=
 =?utf-8?B?WmkvRWVkV1ZEamZYbWlqU0dSV21od2h2bThZSTFocEVHVTMzTUdLMk1UV1k5?=
 =?utf-8?B?VDlrcjY0bHVDR1ZtUDNQMERKK0wrci9oVWNUaFdOYU5YSE4xYWplalVHUkgw?=
 =?utf-8?B?dWRETzdUV3NvclNXcDFUVHBDSmxLTjMrRWxjN01GM0dQeFQwSmNteDRRZGhv?=
 =?utf-8?B?U21ZYlovbmx5RFlZSHBseldEcE13SXRkTllzdlJUZlBDK01iZmErNHB2U1VC?=
 =?utf-8?B?UGhjVFkzZXpMRnN3TWxvTVc5aFF3M1NqWXBVUTcxVnVWbkpZTjAxbzkxN1dF?=
 =?utf-8?B?MFpCN0QzUDBXR2M1VHdMQk41alNhRlRZT2RHSy9pNE1ETk5ocTNqUFBNdlVw?=
 =?utf-8?B?SmZrVzZ6R0thaFJ6V0FvZGJmNVR0UHVnTFVRVk5Oa0xDb3VPTE5CNXlsUmJS?=
 =?utf-8?B?WmxtazExZEsyUE0waXcvRkVwNWY2dFg3UC8vdGZSdlF3bXhPVG5NL0R5cC9W?=
 =?utf-8?B?WFdLNWlqMnNGUHZKVXMwM3BCT291eFVzK2tmbG9uQlZvYytKSHU4L3VpenpB?=
 =?utf-8?B?eVVYNnRwLzJkTjByam1GOEc3ZkJNSzBsSEZWc3pORVN6Snp2S0RIcTA0bUM1?=
 =?utf-8?B?QnFUeEVKWk9MbGVaUU1LOWxRNjFFdzlNekxxZVJObE1xWWw2cVZvdXdGamky?=
 =?utf-8?B?aERsTkNQSXBoeDBOVW1aWnVGam94QkRIZ01ZUjEzME5kS1ZRZCtOWnNyVVA0?=
 =?utf-8?B?c1ZDa3g2clM1YjNSMmNUV3FJeGJ6LzNkbC9DeldoZ0hrTjZndmszaVVQeGRC?=
 =?utf-8?B?S0FCNUc4aVNJb24vYkJTcHRqZGQyVTNaQzRGbjA2eFM5aEZpeUFhcnVoalFT?=
 =?utf-8?B?QkRKWmdCYzFlUEh0QWV2WXRUeWtqcmVqYzRYUVkxTnh1M0s5d3YrNEozVGdi?=
 =?utf-8?B?SmFDdmhzRmIyMWJ4UlpmbmptQ1crcEdyZGZQZmVOaDI0Z01rblppSld6Zlkz?=
 =?utf-8?B?ZnVSSDlCZEFLajhETGpUL09SdkwvU2RFSjVDVHo1Qi9vM2lUNjRPT2pXdEdv?=
 =?utf-8?B?emh3UWNnckxBcUJpVjdvb2xCMlV2TlVaNHc1ZU4zUUd5OGxITDNkUXVlYlFP?=
 =?utf-8?B?WEUxNDZqV2dxclN0dTJCdWc1R1grMEFaOURXU0pZSHlFbjhuNHhjS3o5Wjh0?=
 =?utf-8?B?bmRCR3NGejIySmY0WW5PRDJJYnkrTnZLUHdkTXBCdjFNTjdxNmlVTFI2RkpS?=
 =?utf-8?B?YUtXVzBRc3NLaFlVVjN3bE55KzBGZnZOUEN0Sm9sS0M2NzJrVHI0bTFkY0Uz?=
 =?utf-8?B?SzNWdkxQdUxQNW84VTZUcFY1RkFUU3JCRVUyNmorVDYySkllWHVnRXR0dXkx?=
 =?utf-8?B?YmVzZHZMUXZEQmRlY1lETmxPcC9LbHBwcW5RcWhWVVB5Ti8rOC80MVp4SW1M?=
 =?utf-8?B?YXMzb29tMFhEa2ZRVitPY1YrSmZ3Y092cVV0YVFISDJoZEhnOEl5Umo4dVF2?=
 =?utf-8?B?Wm4vRWwySW5vTXRZTTJwcWNiQVZabEpDYXQwQ3ptekVIaDE0YVdVdE9Vcmxx?=
 =?utf-8?B?REFkdCtESnBPaE03TUZENEw2ZlJ6Vk9jZUMraTJPbUhmczk1aW5aVDYxK0Zh?=
 =?utf-8?B?bnhTZS9lUVBCMXoyQkF1OEVETFdXanNxb1hFMGtvb3pYVjlpSFZaVVRCM0Jm?=
 =?utf-8?B?VVpzNjBmM1hpK1FqUHlqS2szQ215dlVENVcveTd6U1RQMkhXcHN0NjZ2d0Vt?=
 =?utf-8?B?b2NCVnVrQXZKenJkdFRueU9pMGdhTVJ1dElNMG9LQVp6aVptdWpGTUJDWUhJ?=
 =?utf-8?B?S0dDSUErTkVFU2k4NVBubTZZZUlYSHRpUit2TWRKeFlqMkhXMTA1RXNaak1X?=
 =?utf-8?B?YWVhSHdXa3hYSms2dnBCOUdzY3pKWlUwKzZ4NG9aa0FTQUUwVEV5R0Z3QVNl?=
 =?utf-8?B?a1FSd1RqaHN4N0J1ODRuVG15UlZGQ3hrTTRZS1M5N1hRNWZxNEdYcGVuK3pK?=
 =?utf-8?B?QXNNSndtdTVxTUI2a043Y1RaTzFyL01PaTdFTDJ0anFTcnVBRlFsditrVXIv?=
 =?utf-8?B?OGFxcmgwM2h4TDlQT3ZNT2JwS0JZaWhWUlVSOTZva05YK2lRS1JHQk1yTUxt?=
 =?utf-8?B?djU2UE5JMmlHZ0hkOFE5NjBjRjJFVW41MFVIUWhNMUR0Q1gyRlBxdz09?=
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
X-Exchange-RoutingPolicyChecked: mBkcN8F1LMvLt7oXjmi7LpNRSMZj72PRfzP7UEHv+S12ZGbI9YN4O+lR4kXcyDLk9dPW7cwtPUwBSDbaVTWdBuaNDx++ngDpi7B7giulQ8HYuKSakQpoTggzB/D3JcPZC9wqd5ucnMGojJmWQJTWBhx/tGzh3OuA9NjzdRLKXOoowIr/v4jKPP3aG3tDBYXENC92evh21itrQNPCO8X+xF5+rjcDe6W6TBlYKBm7vKvgKP+3e3Dfa5tSU5belGBpR4wJ7CGgyHgGsS+3xK/79mvzvX0wrzApVS++E31rpICX02q0/xv/PO4Ka8CqvnxMRaPrD/eJXZ0HwOKUV2gk3A==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 041cf0fc-4a2b-456e-41ec-08df38cb2b98
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2026 10:22:16.9984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUQ5uW5k0h76xkBoCGiKHK5WbkTneKzHYmeS6WP43OI4kWCuCEr+5jucW+q5VhpdaHQGf7Rk1a5LmxkRpnhe8xILenF1rJ8+le5Bv8cHDQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7751
X-OriginatorOrg: intel.com

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gR3VudGhvcnBl
IDxqZ2dAbnZpZGlhLmNvbT4NCj4gU2VudDogRnJpZGF5LCBPY3RvYmVyIDMwLCAyMDI2IDM6MTYg
UE0NCj4gVG86IFJlc2hldG92YSwgRWxlbmEgPGVsZW5hLnJlc2hldG92YUBpbnRlbC5jb20+DQo+
IENjOiBKaWFuZywgRGF2ZSA8ZGF2ZS5qaWFuZ0BpbnRlbC5jb20+OyBBbmVlc2ggS3VtYXIgSy5W
IChBcm0pDQo+IDxhbmVlc2gua3VtYXJAa2VybmVsLm9yZz47IGxpbnV4LWNvY29AbGlzdHMubGlu
dXguZGV2OyBKaXJpIFBpcmtvDQo+IDxqaXJpQHJlc251bGxpLnVzPjsgVGlhbiwgS2V2aW4gPGtl
dmluLnRpYW5AaW50ZWwuY29tPjsgQWxleGV5IEthcmRhc2hldnNraXkNCj4gPGFpa0BhbWQuY29t
PjsgWHUgWWlsdW4gPHlpbHVuLnh1QGxpbnV4LmludGVsLmNvbT47IENhdGFsaW4gTWFyaW5hcw0K
PiA8Y2F0YWxpbi5tYXJpbmFzQGFybS5jb20+OyBTdXp1a2kgSyBQb3Vsb3NlIDxzdXp1a2kucG91
bG9zZUBhcm0uY29tPjsNCj4gU3RldmVuIFByaWNlIDxzdGV2ZW4ucHJpY2VAYXJtLmNvbT47IEtp
cnlsIFNodXRzZW1hdSA8a2FzQGtlcm5lbC5vcmc+Ow0KPiBFZGdlY29tYmUsIFJpY2sgUCA8cmlj
ay5wLmVkZ2Vjb21iZUBpbnRlbC5jb20+OyBEYXZlIEhhbnNlbg0KPiA8ZGF2ZS5oYW5zZW5AbGlu
dXguaW50ZWwuY29tPjsgSm9uYXRoYW4gQ2FtZXJvbiA8amljMjNAa2VybmVsLm9yZz47IEJqb3Ju
DQo+IEhlbGdhYXMgPGJoZWxnYWFzQGdvb2dsZS5jb20+OyBBc2hpc2ggS2FscmEgPGFzaGlzaC5r
YWxyYUBhbWQuY29tPjsgVG9tDQo+IExlbmRhY2t5IDx0aG9tYXMubGVuZGFja3lAYW1kLmNvbT47
IEpvaG4gQWxsZW4gPGpvaG4uYWxsZW5AYW1kLmNvbT47DQo+IFdpbGwgRGVhY29uIDx3aWxsQGtl
cm5lbC5vcmc+OyBNYXJrIFJ1dGxhbmQgPG1hcmsucnV0bGFuZEBhcm0uY29tPjsNCj4gcGF0Y2hl
c0BsaXN0cy5saW51eC5kZXYNCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0ggdjEgMTAvMTFdIHZp
cnQ6IGNvY286IGFybS1jY2EtaG9zdDogUHVibGlzaCBzbG90IHplcm8NCj4gYW5kIGVzdGFibGlz
aCBzdHJlYW1zIGFmdGVyIGFjY2VwdGFuY2UNCj4gDQo+IE9uIEZyaSwgT2N0IDMwLCAyMDI2IGF0
IDA5OjU4OjAzQU0gKzAwMDAsIFJlc2hldG92YSwgRWxlbmEgd3JvdGU6DQo+ID4gPiA+IEl0IGNh
bid0IGRlZmVyIHRoZSBzZXNzaW9uLiBUaGUgVERYIE1vZHVsZSBydW5zIHRoZSB3aG9sZSBTUERN
DQo+ID4gPiA+IHNlc3Npb24gc2V0dXAgaW5zaWRlIFRESC5TUERNLkNPTk5FQ1QsIGFuZCB0aGUg
aG9zdCByZWxheXMgaXRzIERPRQ0KPiA+ID4gPiBtZXNzYWdlcyB3aXRob3V0IGludGVycHJldGlu
ZyB0aGVtLCBzbyB0aGVyZSBpcyBubyBkZWZpbmVkIHBvaW50IHRvDQo+ID4gPiA+IHN0b3AgYWZ0
ZXIgdGhlIGNlcnRpZmljYXRlcy4gVGhlIGNoYWlucyBjb21lIGJhY2sgaW4gdGhlIGRldmljZSBp
bmZvDQo+ID4gPiA+IG9ubHkgb25jZSBUREguU1BETS5DT05ORUNUIGNvbXBsZXRlcyAoVERYIENv
bm5lY3QgQUJJIFJlZmVyZW5jZQ0KPiBTcGVjDQo+ID4gPiA+IDIuMSB2MC42NiwgNC4yLjIwLjEp
Lg0KPiA+ID4NCj4gPiA+IFllYWgsIGl0cyBmaW5lLiBURFggd2lsbCBoYXZlIHRvIGRvIHdoYXQg
QW5lZXNoIHByb3Bvc2VkIGZvciBBUk0sIGFuZA0KPiA+ID4gdXNlIHVzZSB0aGUgUnVzdCBTUERN
IERyaXZlciB0byBvcGVyYXRlIERPRSBwcmlvciB0byBjYWxsaW5nDQo+ID4gPiBUREguU1BETS5D
T05ORUNULiBUaGlzIHdpbGwgYWxsb3cgZGlzY292ZXJpbmcgd2hhdCBpcyBpbiB0aGUgc2xvdHMg
YW5kDQo+ID4gPiBwYXNzaW5nIHRoYXQgaW5mb3JtYXRpb24gdG8gdXNlcnNwYWNlLg0KPiA+DQo+
ID4gSSBhbSBzb21ld2hhdCBjb25mdXNlZCBieSB0aGlzLg0KPiA+DQo+ID4gMS4gWW91IGFyZSBz
YXlpbmcgdGhhdCBwcmlvciB0byBlc3RhYmxpc2hpbmcgYQ0KPiA+IHNlY3VyZSBTUERNIHNlc3Np
b24sIHlvdSB3aWxsIHVzZSB1bnNlY3VyZSBET0UgbWVjaGFuaXNtIHRvIGRpc2NvdmVyDQo+ID4g
YXZhaWxhYmxlIGNlcnQgY2hhaW5zLiBIZXJlIHlvdSBoYXZlIHRvIHRha2UgaW50byBhY2NvdW50
IHRoYXQgYW55dGhpbmcgeW91DQo+ID4gZ2V0IGF0IHRoaXMgc3RlcCBpcyBub3QgdHJ1c3RlZC4g
QSBtYWxpY2lvdXMgZGV2aWNlIGNvdWxkIHNlbmQgeW91IGFueSBjZXJ0DQo+ID4gY2hhaW5zIGZy
b20gYW5vdGhlciBsZWdpdGltYXRlIGRldmljZS4NCj4gDQo+IEkgcG9rZWQgYXQgdGhpcyB3aXRo
IEFJIGZvciBhIHdoaWxlLi4gV2hpbGUgbm90aGluZyBhYm91dCBTUERNIHNsb3RzIHNlZW1zDQo+
IHBhcnRpY3VsYXJseSBjbGVhbiBpdCBjYW4gYmUgbWFkZSB0byB3b3JrLiBJdCBsb29rcyBsaWtl
IDEuNCBpbXByb3Zlcw0KPiB0aGluZ3MgbWVhbmluZ2Z1bGx5Lg0KPiANCj4gPiAyLiBOZXh0LCB5
b3Ugd2lsbCBjaG9vc2UgYSBjZXJ0IHNsb3QgdG8gYmUgdXNlZCBmb3IgU1BETSBhdXRoZW50aWNh
dGlvbiBhbmQNCj4gPiBzZWN1cmUgc2Vzc2lvbiBlc3RhYmxpc2htZW50IChzbG90IDAgaW5pdGlh
bGx5IGluIHRoaXMgcGF0Y2gpIGFuZCBhbGxvdw0KPiA+IGV2ZXJ5dGhpbmcgdG8gaGFwcGVuLg0K
PiANCj4gWWVwDQo+IA0KPiA+IE5vdywgd2hvIGd1YXJhbnRlZXMgdGhhdCBhIGNlcnQgY2hhaW4g
dGhhdCB5b3Ugc2F3DQo+ID4gYXQgc3RlcCAxIGZvciB0aGUgc2VsZWN0ZWQgc2xvdCBpcyB0aGUg
c2FtZSB0aGF0IGlzIGdvaW5nIHRvIGJlIHVzZWQNCj4gPiBpbiBhY3R1YWwgU1BETSBjb25uZWN0
aW9uPyBXaG8gaXMgdmVyaWZ5aW5nL2Vuc3VyaW5nIHRoaXM/DQo+ID4gS2VybmVsPyBVc2Vyc3Bh
Y2U/DQo+IA0KPiBOb3Qgc3VyZSwgaXQgd291bGQgbWFrZSBzZW5zZSBpZiB0aGUga2VybmVsIGNh
biBkbyBzb21lIG9mIHRoaXMgd2l0aA0KPiBydXN0c3BkbSwgYnV0IHRoZXJlIGFyZSBhbG90IG9m
IGRldGFpbHMgaGVyZSB0aGF0IEkgY2FuJ3QgZ3Vlc3Mgd2hhdA0KPiBpcyBiZXN0Lg0KPiANCj4g
QUkgdGVsbHMgbWUgdGhlcmUgYXJlIGEgY291cGxlIG9mIHJlYXNvbmFibGUgd2F5cyB0byBpbXBs
ZW1lbnQgc2xvdA0KPiBzZWxlY3Rpb24gYW5kIGF2b2lkIGRvd25ncmFkZSBhdHRhY2tzOg0KPiAN
Cj4gMSkgV2l0aCAxLjQgbWF0Y2ggR0VUX0RJR0VTVFMgYW5kIE1VTFRJX0tFWV9DT05OX1JTUD10
cnVlDQo+ICAgIDEpIERvIHZpYSBSdXN0U1BETToNCj4gICAgICAgICBHRVRfRElHRVNUUyAvIERJ
R0VTVFMNCj4gICAgICAgICBHRVRfQ0VSVElGSUNBVEUgLyBDRVJUSUZJQ0FURQ0KPiAgICAyKSBV
c2Vyc3BhY2Ugc2VsZWN0cyBzbG90cw0KPiAgICAzKSBUU00gbW9kdWxlIGRvZXMgc3RhcnR1cCBh
bmQgYWxzbyBpc3N1ZXMgJ0dFVF9ESUdFU1RTJyBhcyBwYXJ0IG9mDQo+ICAgICAgIHRoZSBzaWdu
ZWQgdHJhbnNjcmlwdA0KPiAgICA0KSBDb25maXJtIHRoYXQgdGhlIGRpZ2VzdHMgZnJvbSAjMSBt
YXRjaCB0aGUgZGlnZXN0cyBmcm9tICMyIGluDQo+ICAgICAgIHRoZSBUU00gdHJhbnNjcmlwdC4N
Cg0KV2UgY2FuIGFsc28gc2ltcGxpZnkgdGhpcyBmdXJ0aGVyIGJ5IG5vdCB1c2luZyBHRVRfRElF
R0VTVFMgYnV0DQphc3N1bWluZyBUU00gY2FuIHJldHVybiB0aGUgY2VydCBjaGFpbiBmb3Igc2Vs
ZWN0ZWQgc2xvdCBiYWNrIHRvDQprZXJuZWwvdXNlcnNwYWNlIGluIGEgdHJ1c3RlZCB3YXkuIFRE
WCBkb2VzIGl0IGJ5IHJldHVybmluZw0KdGhlIGNlcnQgY2hhaW4gKGFjdHVhbGx5IGZvciBhbGwg
c2xvdHMgaWYgYXNrZWQsIGJ1dCBpdCBpcyByZWR1bmRhbnQgaGVyZSkNCm9uIHN1Y2Nlc3NmdWwg
U1BETS5DT05ORUNUIGFuZCB0aGVyZSBpcyBhIHRydXN0ZWQgVERYIE1vZHVsZQ0KcHJvdmlkZWQg
ZGlnZXN0IGNvdmVyaW5nIHRoaXMgaW5mby4gIA0KDQpTbywgb3B0aW9uIDEgYmVjb21lcyBsaWtl
Og0KDQoxKSBXaXRoIDEuNCBtYXRjaCBHRVRfRElHRVNUUyBhbmQgTVVMVElfS0VZX0NPTk5fUlNQ
PXRydWUNCiAgICAxKSBEbyB2aWEgUnVzdFNQRE06DQogICAgICAgICBHRVRfQ0VSVElGSUNBVEUg
LyBDRVJUSUZJQ0FURQ0KICAgMikgVXNlcnNwYWNlIHNlbGVjdHMgc2xvdHMNCiAgIDJhKSBDYWxj
dWxhdGUgYSBkaWdlc3QgZm9yIHRoZSBzZWxlY3RlZCBzbG90DQogICAgMykgVFNNIG1vZHVsZSBk
b2VzIHN0YXJ0dXAgDQogIDQpIEV4dHJhY3QgY2VydCBjaGFpbiAob3Igb25seSBpdHMgZGlnZXN0
KSBmcm9tIGluZm8gcHJvdmlkZWQgYnkgVFNNLg0KVmVyaWZ5ICB0aGF0IHRoZSBkaWdlc3QgZnJv
bSAjMmEgbWF0Y2ggdGhlIGRpZ2VzdCBjYWxjdWxhdGVkIGJhc2VkIG9uIHRydXN0ZWQgaW5mbyBw
cm92aWRlZCBieSBUU00uIA0KDQpPcGluaW9ucz8gDQoNCkJlc3QgUmVnYXJkcywNCkVsZW5hLg0K
