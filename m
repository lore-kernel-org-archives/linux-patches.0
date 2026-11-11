Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794402590;
	b=hSvOCC/kL3G7anKUij5QIk4XnkxfFuvPYP6ddIO8RzKuNuE1dj7NtNtaLfFTecBPfOIR
	 dF7eZWoSlB6blV7yPKE+oWgMF/xOSni8xvICpNoVf2Ig5nvQIvcgtIVryv8qkR9HxW9+s
	 HK4gqoGZUAqAXeo6XSekYz0igfLLMz2cCDdxD0Wp34NePFS3pEeJ6WNb8dW0zI9FejQDY
	 8Ro+Tl8XQo6YeoEhtyB82aq6vvkVkKSaeSrz+vJrd7ep6LPr9QmL8Rx9BPa9fuk/UeLnJ
	 7JNptAAFwnZ+ZMITRqR3mGJHa7nUhkHyzZT7D8tE9fMSxiR8fbAT9wzFZQkajeRT9ow==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794402590;
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
	bh=ZwdySdHoTCYZ3TikOUrwMtE5vjfPnaTbdFdPYYYobKA=;
	b=XQcGpaTJt26+8GwRhb6wqMmb45IoZBeuAsQCu4PlXr/sE7PzgfAlVZESCcAR5HL8R73k
	 wuW0ZDWvojnmCRQb2HG4fP2t49bc3ilV7UCqD+DOlFRHF0MNG3Vh3n6Ca6VlXg+4TrTob
	 kO0jBtrZHnLwvOLitABsz1Cyx5+RJFom6zn/QPrDc2/zJs+8xuqoEyV9dGyw9HyFEcVW5
	 BQYeMEgP2GFwefOoLOllMG4ffendowBx9PCzxF7xSLXnIoU9ENYsI+lmK2eUUvYM+nY2v
	 tKr3+F7txxJ8WmDNUvjUwwUhhIn7RZxdAB2WSyugLz+UtcNNOnV70uY7fJBwoR1EZ7g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PNmiTQ7T;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBF9606A324;
	Wed, 11 Nov 2026 13:09:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BBF9606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=PNmiTQ7T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794402589; x=1825938589;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZwdySdHoTCYZ3TikOUrwMtE5vjfPnaTbdFdPYYYobKA=;
  b=PNmiTQ7Ti3a03A2/HWj1JGmm5RyiEHc/XKbos7mXbvttqoT0JgWBuZJ3
   N9rqzZPedF3FZ0kSp0Ab2hsCQdy3FA6d/hZr3IA3ocvm1mc/B+UpPvl1k
   VUoC43J9EsqrmULsg6djKFWIhGxmubNs2eGj6udIuuoqbI07xBNanaTJv
   iAFxzzk1xJcse/B/Vwm5iQpvFeKGWvZnpVhCRmcKEmvVojNo+gS84YJi/
   VFBViPDVzO5ojbIbR1Ve64rVlaua5Tmv0kFOveI298EqkwAXsnmuuT8Et
   m97ZWK/z/w/e5OSznUUCLgLwh1qHueZrKhgu9CaIgGiC+WnUPfiQtJJEX
   w==;
X-CSE-ConnectionGUID: 3QOBLCPHQyKOFxCFlodWSA==
X-CSE-MsgGUID: jzxpfHIcSNihQbIx2CIt3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11962"; a="3203966"
X-IronPort-AV: E=Sophos;i="6.27,207,1787036400"; 
   d="scan'208";a="3203966"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 05:09:48 -0800
X-CSE-ConnectionGUID: vobQFqqdRTO7XExHo7nnuw==
X-CSE-MsgGUID: c3BydCJUTKWraDDVZuNA5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,207,1787036400"; 
   d="scan'208";a="8388299"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 05:09:48 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 05:09:47 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 11 Nov 2026 05:09:47 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.71) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 11 Nov 2026 05:09:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n721OT2GI+LCvLU7AaNIdtWMyzl9JmI9FXCrRq28HL+EWhmigdGZa1fbZWhTji7qL75LiI3jfA4NY/RagVP3ZlsOFA2i4rSmyN/kGKUWy7Jv+Id217lx0k3B/EsuXcVfe9NxltFWNsfZoDJMvXcedUVERUU4S6J9CL6N1tyJ5JKQSPVKYh6jkHYXTjTjrmo+uHIQlIcA0yRQmXjgsD3GV9XJXyHnjm6/ecm4HzPmwH7ksvmHIbZ9P386JDy0JArJDNvp+cwf8UMjHUrseyHlXsj6GL0SMSl6QpZ67q+Vgnx47bKboVB0zae1Cv2r5xBbsmQbbN+39S70Ip/yGBLPtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZwdySdHoTCYZ3TikOUrwMtE5vjfPnaTbdFdPYYYobKA=;
 b=JyZqfueut6dsNHwGdem2sX5id7ZqYr3NBOjW7aEPQ/prRIqJ6EA3S/XGas6HcvuZtk3Yoc/tiwZLKTRcyJpkN9ZlrsXpGsjv6LvyR9XDH18aVQMoUPCsDUzfAfWF4hW3DMRKEoBQzvGeRi2cPVXGCWnz1ntSfvrIIE5fQXldpon0ZnAFPwmH0eoRUTT1YaoIJKkYE26zVB4Z7RWugfeE7t5CZ7d422PzpM1SBTtH1C8EdDTUjg/zbULWlStTbJ7KNQ3n2RRSqKzFu9LP4T5yGm3Qh/8jpN9at3492e3Kova8gM5NztA7lYH3OWeHNckwl3uVWJg52ge0B3jO6AxhRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by DM4PR11MB6165.namprd11.prod.outlook.com
 (2603:10b6:8:ae::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.8; Wed, 11 Nov
 2026 13:09:43 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0615.007; Wed, 11 Nov 2026
 13:09:43 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	Aneesh Kumar K.V <aneesh.kumar@kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, Jiri Pirko <jiri@resnulli.us>, "Tian, Kevin"
	<kevin.tian@intel.com>, Alexey Kardashevskiy <aik@amd.com>, Catalin Marinas
	<catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, "Steven
 Price" <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Jonathan Cameron <jic23@kernel.org>, "Bjorn
 Helgaas" <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, "Tom
 Lendacky" <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, "Will
 Deacon" <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABGSiAgAAXIXCAAEdkgIAANdmAgAMTyoCAADyIAIAANPsAgALf2ICAAYKUAIAAFT2AgAAiAYCAAC5DAIAA4I+wgAAVVwCAAXY/QA==
Date: Wed, 11 Nov 2026 13:09:43 +0000
Message-ID: <DS4PPFA84FA90FC31803C37BDCA2C11FCFCE7712@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
 <2b89b830-f1e4-4304-93ee-40287a4b5b2d@intel.com>
 <20261109185315.GS770409@nvidia.com>
 <e1fe8fa5-7bcd-46e3-bfe8-368582304222@intel.com>
 <20261109234032.GT770409@nvidia.com>
 <IA3PR11MB91609724D29DA39CB0AAE25AE7722@IA3PR11MB9160.namprd11.prod.outlook.com>
 <20261110142038.GE738765@nvidia.com>
In-Reply-To: <20261110142038.GE738765@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|DM4PR11MB6165:EE_
x-ms-office365-filtering-correlation-id: 24babc3e-cb0d-4dd0-320f-08df3ff50d4b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|23010399003|366016|10067099003|261009223027099003|261026121527099003|261028144727099003|261026140227099003|261021135927099003|261022105027099003|261102123227099003|261022075727099003|261021121427099003|11063799006|56012099006|38070700021|4143699003|18002099003|22082099003;
x-microsoft-antispam-message-info: TxJT2XO4BHorX/0/zIVvPTmyBScMpRagpZ3BiW8f9/V+t2+YxEh41l1Ck/i4EBOEcV9npRkt9/zERY4ZDcAdAiBOAXGlAZbOKDbhF3uNkPkC6+vCK/u3ZHuTVwCq/i3EaWa/TXoVxT6nHd55vNjQO3d+y9n7MpxBZI4zsIzGGT5Vt+pxrTduqGmG/fc8fL/+WjSWSE6dsa84oKTxAOeUZxP1P7q6frxD8CfoiYFNBL3K02BFLVRjtFTgg2XGEbOUsR+2t458cASp+dpLvQzSZFAmF89GqF5vWGpBEBqNI3jcAuHPuHzl1IgYw3GEWREnmnO8oNdtphB9eqJtfLIbXJzfVaBYBN1dkXIVibj/WnsPqRy68ZgwCMgtGg6GMT8UqfwREpC+4y7nu5yRkQHd4q+e3Hr5POKu0zqmlICdZvGEk/q/75vTIzU79HcAM8y4Zd1xQ2y1S2KV9+rZumruhYAGsrBju3wQggCgBRO9Gduh1DivWZlJRCGs7aDaN1W9ETd4BauiaKarn2ecEzMepM02mKXRbE4yLUy3w7mCEzrzKJWY6Aanl9cAHoY/p8bLvaiLf19blPYz1pX7wDGroGrqJzx26cz8e2o+DeP6MAzuQV/GWTCWJ2/KT0MK49e9kKR5RCKQwJUE9jOTyab3NC1a76BlgD5VBOL63GBC+eKVSRXmzGgmHtuQ4R+iNY/Bbo6AYvaTvM4oxlq8mbEeCbUifhNR4qoP+lmPtK6N9f8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(23010399003)(366016)(10067099003)(261009223027099003)(261026121527099003)(261028144727099003)(261026140227099003)(261021135927099003)(261022105027099003)(261102123227099003)(261022075727099003)(261021121427099003)(11063799006)(56012099006)(38070700021)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFBsMTY1YzBuUWJPU3ZBTHAzS29NY2U3OUJMNTRSZXFlVGhNU0ZRUnc2SHpw?=
 =?utf-8?B?N1RYck9xcHJTeklHd1pHY1BZelRMU05DNWJxQmc0enhsek5HRy9lSi9PV05X?=
 =?utf-8?B?dmlvOFFQWTJISDI4eVdJN1g4azkvWEU1WjdKaFMyZGxBQmtnN1ZnbTFmT05n?=
 =?utf-8?B?U3d4MFEwby9HM0ZXdDUrd1hlSWFzUlQrdFhXZ0RRTVNRL1NZVDhmRUtSRFlQ?=
 =?utf-8?B?TU1YWGE2WGpJZmM0K2NpL0JweXh0R3FnUG5ydHg1RTNNRzI1dXBkb2ZtU2I5?=
 =?utf-8?B?b3BMVzA1R1BEUlJHTmozU0hqdXFGa0NuczBONUhGV1hwanVCZmQyYXdzRnVK?=
 =?utf-8?B?WDh2ZlA5TjdLamE2ZHArT2xZSG9tRlh3UzVYWnVOVVNHQ2c4TEVqWWMwdDJ1?=
 =?utf-8?B?TUlDQlFKNmxZejVJQlBxbHVlMVpvOHlxNVVZUVNKT3JXZ0lHNjc0Nmp2K3Jr?=
 =?utf-8?B?SDJIa2l6RndmL1RNS0NaZjJDQ25NMlZGeDk0ZEtPeFI5NlloZEErOFpxNzI5?=
 =?utf-8?B?N0pNRlVkUkJ6RmlCU25WUXdhK1YzdzBRWG5wWkd1czQ1cUtUd2JRSWNUWFpW?=
 =?utf-8?B?UDkzRllnTVhDU3R1dzVkQmE2b1JTZE9zTW5FSk9rcTg3NU0rYVdZdSt3UnM0?=
 =?utf-8?B?U09ZUnR4RitvK25TcXVldzU1Yk5SdHdwM0xwN3pKcGtHV0ZOeThyTzRuL2pP?=
 =?utf-8?B?OHBHR3I5NGlZS0tlTXFEZFN0dTloc0pFNVVRS0J1YVRYcDRMQWpvNFNMVjMz?=
 =?utf-8?B?bDd2VFcvREFyZUxoN1BFK08reEpKdUdJVStrK3F4UVRMTjBkMHU5eWlvMmVH?=
 =?utf-8?B?SmN0R3BSV3lXSytiWCtSYmEzN1VJdWdPU0R6eWE4UHJITk9nci9Yd2F6eEFT?=
 =?utf-8?B?N2s2ZkhIU3dYd1cyNWtnMGVLVG9kM1JqZ0x4QmpRQXpMK2liTlFISlJ3Y0F6?=
 =?utf-8?B?VlhLU09CYUZnZVNsRGUxQ1g2S0tjQUdHOUxXTmdKL2hMSS95ZWVUS3paZTU3?=
 =?utf-8?B?U0dqMlNUTEF1YThuYTVlcU5NbmdMWGQyZDJiV0JYb3RjZmdGOGh1KzlaRWFZ?=
 =?utf-8?B?cHFmY29iTitXQUJtbEVLQ2pkZEt5THZxV1Z5NWduUTVXNkEwQ0VFbGxsM2tS?=
 =?utf-8?B?ZERhbHlkM1VOc3FsT2pldVA4OTRBbnNSQlFBbGpIOHY3am5xaXQ2dGtENUJ1?=
 =?utf-8?B?WldGNFdFWkNSNmhuZkx1R09rUkV2R0NnU0lDUkduV3hJcHdoWWRvNkFPUFpi?=
 =?utf-8?B?Rm5mZWNoUzl1aTZUWEpoRmZBc1Y1dGtFTEdsUHg3YlV1amM1ZVRMSTlONUdv?=
 =?utf-8?B?YnJ4dHNOTXcvSk1rTXg4TFMrVERpYkVueDJINEd1eWsxWjNjL0thLzljNHVi?=
 =?utf-8?B?eXNXdXA5aUx1TnhCQ0hKS001RWU2Zy9ES0lxNkI2V2ZlcGJSOU41Y0p1U09U?=
 =?utf-8?B?d2RGNERzbmQzemdaQldRRDNTR25yczF5VUJOWFVSMU4yaGpOM2lwTmJMQ3lK?=
 =?utf-8?B?MXk3WFR1eTlNcTY0VEYvMEFFZnhVakQzbjZKeTJwODd3eUVFQ1c1SXp3MXc2?=
 =?utf-8?B?VkNUbVRxTGdqdjVSaFc0bHVnZ2xGQ3NPZGl3b3ZYclI2SXJmS0NPczdrTmRz?=
 =?utf-8?B?MzhGWXNsN29LektBQlRFWnlMdnNHV3QzQm5CWWJaYjJ3b3BONUt1ZysrR2VD?=
 =?utf-8?B?eCtRWFF3TndobTlBWnMvZGFRYnJKYmIxMDhDWnVuUmYwSnlzUVFFY0poVW5S?=
 =?utf-8?B?WlpJb0s5ZnFidHYzWU1WMzc0ZHVwdjRSZVFXOW5MejZaUi8wTEMwOHRES1dk?=
 =?utf-8?B?TjhtdzlOd0VCTVBUeWxxNnl3MEpwaWlad0tZeE1aSmtDNWFMSHd5MVNwdGxN?=
 =?utf-8?B?Qk5zcEdabUh2cGxDNUJjMm9WSGMzWWV3UnJNbG9keEFyNmp3anUzS2dsSXZh?=
 =?utf-8?B?UjZkM1RjTndqaEZXOTlZUndwZEtrWStlRmpnL2pFQnV0WmltVjk2M3c2Tkc3?=
 =?utf-8?B?VG5vVHFKYTFnV0ltaC9LNksxVit1N3NYQ1VHOHJ2ZjF6L0NSOTFPY1J6ZllI?=
 =?utf-8?B?elVuSEtUMktqTzRyeHpBbGZxVHgxV2I2K2QxQlgwWHpvUytIcncxOWhCd0lw?=
 =?utf-8?B?QkdTVlltUDN1Mkd6c1U4ejNzZGtPakFKdnFrN05tdmp5dlZEMHFZRVFDRUtH?=
 =?utf-8?B?NmVjWUJ0MHdCVlY1aDgzUktIeDE3ak9jbkNPODlnNHpUWEZtYUtmcmtMNlFN?=
 =?utf-8?B?UWVtRWtscjV4UmdHSHEzZDUwOVhhUDFjSVlweXpySUx3b1VOMzNpcDVlZU03?=
 =?utf-8?B?ZHgzakh1N0t5dVVhMEdQT21ZMldQMmc5YVltdEVDTExpOG1Bd2d2UT09?=
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
X-Exchange-RoutingPolicyChecked: EEjKhAWLc5XLWC6jfswk3SejXKkGDGhFiiunofuXvfI5QDgfpqy5m+SE5zPmZnl+kzGPrQYeLB/DXUlp8+b4wYWsXtf1mzxWMixUNIR/X/J0/7QyeNFGOtoST7t7zRqdBX8ymzkFUIO3ufTcNZQJV+cJaTKsS+G2Vi6NbVWvRLyUQicsnfXw4GHz00d1cl41euPYt6dhB7v1HZLyssy13DvzELBGpNeeasJp2suSZL2OoSdkgj129AdTzOHwoa8PcNY48I+YVSaPAcLvYHbRsJrkhG7bUYCrq+p83E/IYDod71ptRiWAe/qWwyKS2bC33T+4IWMRLrz5CR2LLMYWOg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24babc3e-cb0d-4dd0-320f-08df3ff50d4b
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2026 13:09:43.1573
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8G75tVP/JCZOkPkvGogcaMKIgsTJY/IrjAMJ9IgZqnLuKrfXEc1nUANlWYs6CxPIODvIpRsDhJEqi/kBMVUB1lLKd/PC+S3yWACXadF7duY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6165
X-OriginatorOrg: intel.com

PiANCj4gT24gVHVlLCBOb3YgMTAsIDIwMjYgYXQgMDE6MTU6MDZQTSArMDAwMCwgUmVzaGV0b3Zh
LCBFbGVuYSB3cm90ZToNCj4gPg0KPiA+ID4gT24gTW9uLCBOb3YgMDksIDIwMjYgYXQgMDE6NTQ6
NTdQTSAtMDcwMCwgRGF2ZSBKaWFuZyB3cm90ZToNCj4gPiA+ID4gPiBXaHk/IFNlZW1zIGxpa2Ug
YW5vdGhlciB3YXN0ZWQgb3BlcmF0aW9uLi4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIFREWCBtb2R1
bGUgcnVucyBpdCBhcyBwYXJ0IG9mIHRoZSBjb25uZWN0IGFuZCB3aXRoIHRoZSBjdXJyZW50DQo+
ID4gPiA+IG1vZHVsZSB0aGUgaG9zdCBjYW4ndCBza2lwIGl0LiBJJ2xsIGRpc2N1c3Mgd2l0aCBF
bGVuYSBhbmQgc2VlIGlmDQo+ID4gPiA+IHRoaXMgY2FuIGJlIGRpZmZlcmVudC4NCj4gPiA+DQo+
ID4gPiBEb2VzIGl0IGNvbWUgb3V0IGFueXdoZXJlIGFuZCBiZWNvbWUgdmlzaWJsZSB0byB0aGUg
aG9zdCBvciBndWVzdD8NCj4gPg0KPiA+IFllcywgaXQgaXMgdmlzaWJsZSB0byB0aGUgaG9zdCBr
ZXJuZWwgYXMgcGFydCBvZiB0aGUgaW5pdGlhbGx5IHJldHVybmVkDQo+ID4gU1BETV9ERVZJQ0Vf
QVRURVNUQVRJT05fSU5GT19UIHN0cnVjdHVyZS4gVGhlIGd1ZXN0IGNhbiBnZXQgdGhlDQo+ID4g
cmVmZXJlbmNlIGhhc2ggb2YgdGhpcyBzdHJ1Y3R1cmUgZnJvbSB0aGUgVERYIE1vZHVsZS9UU00u
DQo+IA0KPiBUaGF0J3Mgc2VjdXJpdHkgYnJva2VuLg0KPiANCj4gVGhlIGd1ZXN0IG11c3QgbmV2
ZXIgc2VlIGEgbWVhc3VyZW1lbnQgZnJvbSAqYmVmb3JlKiB0aGUgZ3Vlc3QgZGlkDQo+IExPQ0tF
RC4NCg0KV2hpbGUgSSBhbHNvIHBlcnNvbmFsbHkgcHJlZmVyIHRvIGRvIG1lYXN1cmVtZW50IGNo
ZWNrcyBhZnRlciBMT0NLDQooYmVpbmcgYSBzZWN1cml0eSBwZXJzb24sIHlvdSB0ZW5kIHRvIGJl
IHBlc3NpbWlzdGljIGFuZCByZXF1aXJlIHN0cmljdGVzdCksIA0KSSBkb250IHRoaW5rIGFueXRo
aW5nIGluIFREU0lQIHN0YW5kYXJkIHNheXMgdGhhdCBMT0NLIGZvcm1hbGx5IGFmZmVjdHMNCm1l
YXN1cmVtZW50cy4gVGhlIG1lYXN1cmVtZW50cyB0ZWxsIHdoYXQgZGV2aWNlL2Zpcm13YXJlIGlz
Lg0KSXQgaXMgdGhlIFRESSByZXBvcnQgdGhhdCB0ZWxscyBpdCBob3cgdGhpcyBwYXJ0aWN1bGFy
IFRESSBoYXMNCmJlZW4gY29uZmlndXJlZCBhbmQgbG9ja2VkIGZvciBhc3NpZ25tZW50Lg0KDQpB
Z2FpbiwgeW91IGVzdGFibGlzaCBhIHRydXN0IGluIGEgZGV2aWNlIGF0IHRoZSB0aW1lIG9mIFNQ
RE0gY29ubmVjdC4gDQpHdWVzdCBjYW4gaW5zcGVjdCBWQ0EgYW5kIHRoZSBjZXJ0IGNoYWluIGZv
ciBzZWxlY3RlZCBTUERNIGF1dGhlbnRpY2F0aW9uDQpzbG90IHRoYXQgd2FzIGZpeGVkIGR1cmlu
ZyBTUERNIGNvbm5lY3QgYW5kIGRlY2lkZSB3aGVuZXZlciBpdCB0cnVzdHMNCnRoaXMgZGV2aWNl
IG9yIG5vdC4gVGhpcyBkZWNpc2lvbiAqbWlnaHQqIHJlcXVpcmUgdG8ga25vdyB3aGF0IGFyZSBk
ZXZpY2UNCm1lYXN1cmVtZW50cyBhdCB0aGUgdGltZSBvZiBjb25uZWN0IGFsc28uIFRoaXMgY2Fu
IGJlIG5lZWRlZCBpZiBndWVzdCdzDQp0cnVzdCBpbiB0aGlzIGRldmljZSBkZXBlbmRzIG9uIGl0
cyBjdXJyZW50IG1lYXN1cmVtZW50cywgaS5lLiBJIHRydXN0DQpkZXZpY2UgQSB3aXRoIGEga2V5
IEIgY2VydGlmaWVkIGJ5IGEgdHJ1c3RlZCBpbnRlcm1lZGlhdGUgQyBidXQgb25seSBpZg0KaXRz
IGZpcm13YXJlIG1lYXN1cmVtZW50IFNWTiBpcyBoaWdoZXIgdGhhbiAxMiAoYmVjYXVzZSBJIGFt
IGF3YXJlDQp0aGF0IGRldmljZSBtYW51ZmFjdHVyZXIgcmVwb3J0ZWQgYSBjcml0aWNhbCBzZWN1
cml0eSBidWcgaW4gU1ZOIDExKS4gDQpJZiBhbGwgdGhlc2UgY29ubmVjdCB0aW1lIGNoZWNrcyBh
cmUgc2F0aXNmaWVkLCBndWVzdCBjYW4gdHJ1c3QgdGhlIGRldmljZQ0KKmdpdmVuIHRoYXQgbWFu
dWZhY3R1cmVyIHNwZWNpZmllZCB0aGF0IHJ1bnRpbWUgZG93bmdyYWRlcyBvZiBTVk4gYXJlDQpu
b3QgYWxsb3dlZCogbm90IHRvIGRvd25ncmFkZSBpdHMgbWVhc3VyZW1lbnRzIGJldHdlZW4gU1BE
TSBjb25uZWN0DQphbmQgTE9DSywgbW9yZW92ZXIgaXQgY2FuIHRydXN0IHRoZSBkZXZpY2Ugbm90
IHRvIGRvd25ncmFkZSBtZWFzdXJlbWVudHMNCndoaWxlIGl0IHN0YXlzIGFsaXZlIChhbmQgd2hp
bGUgY29ycmVzcG9uZGluZyBTUERNIHNlc3Npb24gc3RheXMgYWxpdmUpLiANClNvLCB0aGUgZmFj
dCB0aGF0IFNQRE0gc2Vzc2lvbiBzdGF5cyBhbGl2ZSBpbiB0aGlzIGNhc2Ugd291bGQgYWxzbyBn
dWFyYW50ZWUNCnNlY3VyaXR5LiANCkRvIHlvdSBzZWUgdGhlIGxvZ2ljIGluIHRoaXMgcmVhc29u
aW5nPyANCg0KDQo+IA0KPiBUaGUgZW50aXJlIHNlY3VyaXR5IGFyZ3VtZW50IG9mIHRoZSBndWVz
dCBpcyB0aGF0IGl0IGxvY2tzIHRoZSBkZXZpY2UNCj4gc28gdGhlIGhvc3QgY2Fubm90IHRhbXBl
ciB3aXRoIGl0LiBDb2xsZWN0cyBhIHBvc3QtbG9jayBtZWFzdXJlbWVudCB0bw0KPiBzaG93IHdo
YXQgc3RhdGUgaXQgaXMgaW4gYWZ0ZXIgbG9ja2luZywgdGhlbiBtYWtlcyBhIHBvbGljeSBkZWNp
c2lvbi4NCg0KRm9ybWFsbHkgbWVhc3VyZW1lbnRzIG9mIHRoZSBkZXZpY2UgY2FuIGNoYW5nZSBl
dmVuIGFmdGVyIExPQ0sgaWYgeW91DQpkb250IGV4cGxpY2l0bHkgZm9yYmlkIHRoaXMgdmlhIExP
Q0tfUkVRVUVTVCBmbGFncy4gQW5kIGZvciBkZXZpY2VzIHRoYXQNCmd1YXJhbnRlZSB0aGF0IEZX
IFNWTiBjYW4gb25seSBpbmNyZWFzZSBpbiBydW50aW1lLCB5b3UgYWN0dWFsbHkgY2FuIGJlDQpk
b3duZ3JhZGluZyBzZWN1cml0eSBieSBub3QgYWxsb3dpbmcgdGhlbSB0byBhcHBseSBzZWN1cml0
eSBidWcgZml4ZXMgb24NCnRoZSBmbHkuIA0KDQpBZ2FpbiwgSSBhbHNvIGRvbnQgbGlrZSBoZXJl
IHRoYXQgaXQgYWxsIGJlY29tZXMgcmVzcG9uc2liaWxpdHkgb2YgYSB2ZXJpZmllcg0KdG8gY2hl
Y2sgd2hlbmV2ZXIgdGhpcyBwYXJ0aWN1bGFyIGRldmljZSBpcyBvayBvciBub3Qgb2sgdG8gYWxs
b3cgdGhpcywgYnV0DQpmb3JtYWxseSB5b3UgY2FuIGRvIHRoaXMgaWYgdmVyaWZpZXIgaXMgaW1w
bGVtZW50ZWQgY29ycmVjdGx5IGFuZCBoYXMgdGhlDQppbmZvcm1hdGlvbiBpdCBuZWVkcyB0byBt
YWtlIHN1Y2ggZGVjaXNpb25zLg0KIA0KPiANCj4gQ2FwdHVyaW5nIGEgbWVhc3VyZW1lbnQgYXQg
U1BETSBzZXNzaW9uIHN0YXJ0dXAsIHdoaWxlIGluIHVubG9ja2VkLCBhbmQNCj4gdGhlbiB1c2lu
ZyBURFggbW9kdWxlIHRvIHRyaWNrIHRoZSBndWVzdCBpbnRvIGFjY2VwdGluZyBpdCBhcyBhDQo+
IHBvc3QtbG9ja2VkIG1lYXN1cmVtZW50IGlzICplbnRpcmVseSogdW5hY2NlcHRhYmxlIGFuZCBJ
IHdpbGwgb3Bwb3NlDQo+IGFueXRoaW5nIGxpa2UgdGhhdCBpbiBMaW51eC4NCg0KVGhlcmUgaXMg
bm8gdHJpY2tpbmcsIGl0IGlzIHNwZWNpZmllZCBpbiBURFggdGhhdCB0aGVzZSBtZWFzdXJlbWVu
dHMgYXJlIGZvciANClNQRE0uQ29ubmVjdCB0aW1lIGFuZCBub3QgYWZ0ZXIgTE9DSy4gQW5kIGlm
IHlvdSB3YW50IHRvIGhhdmUgbGF0ZXINCm1lYXN1cmVtZW50cywgdGhlbiB5b3UgbXVzdCB1c2Ug
cmVjb2xsZWN0aW9uIGZ1bmN0aW9uYWxpdHkuIA0KDQo+IA0KPiBUaGlzIGlzIGFuICphdHRhY2sg
dmVjdG9yKiBmcm9tIHRoZSBob3N0IGFuZCB0aGUgY29udHJhY3QgYmV0d2Vlbg0KPiBndWVzdC9U
RFggbXVzdCBiZSBhYmxlIHRvIGRlZmluaXRpdmVseSBjbG9zZSBpdC4NCg0KT25seSBpZiB0aGVy
ZSBpcyBtaXN1bmRlcnN0YW5kaW5nIGluIHdoYXQgZ3VhcmFudGVlcyBhcmUgcHJvdmlkZWQuIA0K
DQo+IA0KPiBUaGUgZ3Vlc3QgbXVzdCBiZSBhYmxlIHRvIGFmZmltaXRpdmVseSBzYXkgdGhhdCBh
IGZyZXNoIG1lYXN1cmVtZW50DQo+IHdhcyBjb2xsZWN0ZWQgYWZ0ZXIgbG9ja2VkIGFuZCB3aGVu
IGl0IGdldHMgdGhlIHJlZmVyZW5jZSBoYXNoIGl0DQo+IG5lZWRzIHRvIGtub3cgaXQgaXMgZnJl
c2ggYWZ0ZXIgbG9ja2luZy4NCg0KSWYgaXQgd2FudHMgdGhpcywgdGhlbiBpdCBtdXN0IGRvIHJl
Y29sbGVjdGlvbiBhbmQgd2UgcHJvdmlkZSB0aGlzDQpmdW5jdGlvbmFsaXR5LiBXaGF0IGlzIG1p
c3NpbmcgZnJvbSB0aGlzIGN1cnJlbnRseSBpcyBURFggbW9kdWxlIGRvZXMNCm5vdCByZWZyZXNo
IHRoZSByZWZlcmVuY2UgaGFzaCBiZWNhdXNlIHRoZSBhc3N1bXB0aW9uIGN1cnJlbnRseQ0KaXMg
dGhhdCB0aGUgc2FtZSBrZXkgbXVzdCBiZSB1c2VkIHRvIHNpZ24gcmVjb2xsZWN0aW9uIG1lYXN1
cmVtZW50cw0KdGhhdCB3YXMgc2VlbiBkdXJpbmcgU1BETSBjb25uZWN0IChhbmQgcHJvdGVjdGVk
IGJ5IGEgcmVmZXJlbmNlDQpoYXNoKS4gSSBhbHJlYWR5IGZsYWdnZWQgdGhpcyBhIHdoaWxlIGJh
Y2sgdGhhdCBpdCBkb2VzIHB1dCBhbiBhZGRpdGlvbmFsDQphc3N1bXB0aW9uIG9uIHRoZSBndWVz
dCB0byBjcm9zcyBjaGVjayB0aGUga2V5cyAod2hpY2ggaXMgZG9hYmxlLCANCmJ1dCBtb3JlIHdv
cmspLCBhbmQgSSB3b3VsZCBiZSBzdXBwb3J0aXZlIHRvIHByb3ZpZGUgYSBoYXNoIGZvciANCnJl
Y29sbGVjdGlvbiBhbHNvLiBUaGlzIHdvdWxkIGJlIGV2ZW4gbW9yZSBpbXBvcnRhbnQgd2hlbiB3
ZSByZWFjaCANCm11bHRpLWtleSBjYXNlIGluIHRoZSBmdXR1cmUuIA0KDQo+IA0KPiA+IFRoaXMg
d2FzIGRvbmUgb3JpZ2luYWxseSB0aGlzIHdheSAoYXMgZmFyIGFzIEkgdW5kZXJzdGFuZCB0aGUg
ZGVzaWduKSB0bw0KPiA+IHN1cHBvcnQgYSBzaW5nbGUtc3RlcCBhdHRlc3RhdGlvbiBhdCB0aW1l
IG9mIFNQRE0uQ09OTkVDVCB0aGF0IGENCj4gPiBndWVzdCBjYW4gZ2V0IGFsbCBpbmZvcm1hdGlv
biBpdCBuZWVkcyBmcm9tIHRoaXMgc2luZ2xlIHN0cnVjdHVyZSwgYW5kIG5vdA0KPiA+IHJlcXVp
cmVkIHRvIGFzayBUU00gZXhwbGljaXRseSB0byBkbyBHRVRfTUVBU1VSRU1FTlRTLg0KPiANCj4g
U29tZW9uZSByZWFsbHkgbWlzdW5kZXJzdG9vZCB0aGlzIHJlcXVpcmVtZW50IGlmIHRoaXMgaXMg
d2hhdCB3YXMNCj4gYnVpbHQ/DQo+IA0KPiBBUk0gaW1wbGVtZW50ZWQgc29tZXRoaW5nIHNpbWls
YXIsIHRoZXkgY2FsbGVkIGl0ICdSTU0gY29udHJvbGxlZA0KPiBub25jZScuIEluIHRoaXMgbW9k
ZSB0aGUgUk1NIGl0c2VsZiBkZWNpZGVzIHRoZSBub25jZSBhbmQgdGhlIGd1ZXN0DQo+IGNhbm5v
dCBzcGVjaWZ5IGl0LiBUaGlzIGFsbG93cyB0aGUgaG9zdCB0byBhdm9pZCByZWNvbGxlY3Rpb24g
aW4NCj4gY2VydGFpbiBjYXNlcy4NCj4gDQo+IEhvd2V2ZXIgKEFGQUlLKSB0aGUgZ3Vlc3Qgc3Rp
bGwgaGFzIHZpc2liaWxpdHkgaW50byB0aGUgc2VxdWVuY2UNCj4gbnVtYmVycyBhbmQgY2FuIHRl
bGwgdGhhdCB0aGUgc2VxdWVuY2U6DQo+IA0KPiAgTE9DS0VEDQo+ICBHRVRfTUVBU1VSRU1FTlRT
DQo+ICBDSEVDS19SRUZFUk5DRV9IQVNIDQo+IA0KPiBBYnNvbHV0ZWx5IGRpZCBhIG5ldyBjb2xs
ZWN0aW9uIGFuZCB0aGUgdHJ1c3RlZCBDSEVDS19SRUZFUkVOQ0VfSEFTSA0KPiBpcyByZXR1cm5p
bmcgYSBmcmVzaCBwb3N0LWxvY2sgaGFzaC4NCj4gDQo+IEFnYWluIEkgaW5zaXN0IHRoYXQgdGhl
IExpbnV4IGd1ZXN0IGNhbiB0ZWxsIHRoYXQgdGhlIG1lYXN1cmVtZW50cyBhcmUNCj4gcG9zdC1s
b2NrZWQuIE5vYm9keSBpcyBnb2luZyB0byBnZXQgdGhpcyAnVFNNIG5vbmNlJyBmZWF0dXJlIHVu
bGVzcw0KPiB0aGV5IGNhbiBzdHJvbmdseSBwcm92ZSB0aGF0IGZyb20gdGhlIGd1ZXN0IHNpZGUu
DQoNCkkgZG8gYWdyZWUgdGhhdCBpdCByZXF1aXJlcyBtb3JlIGNoZWNrcyBvbiB0aGUgZ3Vlc3Qg
c2lkZSBhbmQgdGhpcyBjYW4gYmUNCmEgcHJvYmxlbSBpZiBndWVzdCBpcyBub3QgZG9pbmcgdGhl
IHZlcmlmaWNhdGlvbiBjb3JyZWN0bHkuIA0KDQo+IA0KPiAoYXQgbGVhc3QgZm9yIFBDSWUgZGV2
aWNlcywgdGhlcmUgaXMgc29tZSBvdGhlciBzaXR1YXRpb24gZm9yIHBsYXRmb3JtDQo+IEhXIHRo
YXQgaGFzIHRvIGJlIGFjY2VwdGVkIGJ5IHBsYXRmb3JtIGZpcm13YXJlIGJlZm9yZSBMaW51eCBl
dmVuDQo+IGJvb3RzKQ0KPiANCj4gPiA+ID4gPiBJbiBwcmFjdGljZSB0aGlzIG1lYW5zIGFsbCB0
aGUgVFNNcyB3aWxsIG5lZWQgdGhlIGtlcm5lbCB0byB0ZWxsIGl0DQo+ID4gPiA+ID4gd2hhdCBT
UERNIHZlcnNpb25zIGl0IGNhbiBnbyB1cCB0by4NCj4gPiA+ID4NCj4gPiA+ID4gVERYIGhhcyBu
byBpbnB1dCBmb3IgdGhhdCB0b2RheS4gV2lsbCBkaXNjdXNzIHdpdGggRWxlbmEuDQo+ID4gPg0K
PiA+ID4gTm9ib2R5IGRvZXMsIGJ1dCBJJ20gaW50ZXJwcmV0aW5nIHRoYXQgYXMgbWVhbmluZyAx
LjIgZG9lc24ndCByZXF1aXJlDQo+ID4gPiBhIGZsYWcgYW5kIGlmIGFueW9uZSBkb2VzIDEuMyB0
aGV5IHdpbGwgdGhlbiBuZWVkIHRvIGFkZCBhICdlbmFibGUNCj4gPiA+IDEuMycgZmxhZyBmcm9t
IHRoZSBrZXJuZWwsIGZvciBleGFtcGxlLg0KPiA+DQo+ID4gV2hhdCBhYm91dCB3aGVuIGl0IGlz
IG5vdCBhYm91dCBTUERNIHZlcnNpb24sIGJ1dCBhYm91dCBjYXBhYmlsaXR5DQo+ID4gKHNhbWUg
d2hhdCBBbGlzdGFpciBwb2ludGVkIG91dCBmb3Iga2VybmVsKT8gSS5lLiBpdCBzdXBwb3J0cyAx
LjMsIGJ1dA0KPiA+IGRvZXMgbm90IHN1cHBvcnQgbXVsdGkta2V5Pw0KPiANCj4gVGhpbmdzIHRo
YXQgY2hhbmdlIHRoZSBTUERNIGZsb3cgaW4gYSB3YXkgdGhlIGtlcm5lbCBuZWVkcyB0byBpbnRl
cmFjdA0KPiB3aXRoIHdpbGwgbmVlZCB0byBiZSBmZWF0dXJlIG5lZ290aWF0ZWQuDQo+IA0KPiBT
byBtdWx0aS1rZXkgd2hlcmUgeW91IGNoYW5nZSB0aGUgZmxvdyB0byBwYXVzZSBhZnRlciBHRVRf
RElHRVNUUyBhbmQNCj4gYWxsb3cgdGhlIGtlcm5lbCB0byBzcGVjaWZ5IHRoZSBzbG90IGxhdGVy
IG9uIGlzIG9mIGNvdXJzZSBlbnRpcmVseQ0KPiBkaWZmZXJlbnQgYW5kIG11c3QgYmUgb3B0ZWQg
aW50byBieSB0aGUga2VybmVsLg0KPiANCj4gQnV0IGV2ZW4gaWYgeW91IGp1c3Qgd2FudCB0byBk
byAxLjMgbWVzc2FnZXMgdGhlbiB5b3Ugc3RpbGwgd291bGQgbmVlZA0KPiB0byBtYWtlIHN1cmUg
dGhlIGtlcm5lbCBjYW4gcGFyc2UgYW5kIHNpemUgdGhlbSB0byBmb3JtIHRoZQ0KPiB0cmFuc2Ny
aXB0Lg0KPiANCj4gVGhlcmUgYXJlIG90aGVyIG9wdGlvbnMgaGVyZSwgYW5kIEkgdGhpbmsgb25j
ZSB3ZSBnZXQgdGhpcyBidWlsdA0KPiBwZW9wbGUgc2hvdWxkIHRha2UgYSBjYXJlZnVsIGxvb2sg
YXQgaG93IHRoZXkgZGVzaWduIHRoZWlyIDEuMw0KPiBtdWx0aWtleSBBUEkgdXBncmFkZSB0byBk
byBhIGJldHRlciBqb2IgZm9yIHdoYXQgTGludXggd2FudHMgb3ZlcmFsbC4NCj4gDQo+IE1heWJl
IExpbnV4IHNpZGUgY2FuIHJlY29tbWVuZCB3aGF0IHRoZSBUU00gRlcgZmxvdyBzaG91bGQgbG9v
ayBsaWtlDQo+IHNvIHdlIGhhdmUgc29tZSBiZXR0ZXIgaWRlYXMgYW5kIGNvbnNpc3RlbmN5Lg0K
DQpJIGFncmVlIGl0IHdvdWxkIG1ha2Ugc2Vuc2UgdG8gdGhpbmsgYWJvdXQgdGhpcyBpbiBhZHZh
bmNlIGJlZm9yZSB3ZSBhbGwNCmJha2UgaXQgaW50byBhcmNoaXRlY3R1cmVzIGFuZCB0aGVuIGhh
dmUgdG8gbWFrZSBjaGFuZ2VzIHRvIGFsaWduLiANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuDQoN
Cj4gDQo+IEphc29uDQo=
