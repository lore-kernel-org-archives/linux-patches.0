Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794221708;
	b=c9PkjHdHfh0xgr5L8baaBJT8xIctHIKwDXeQmXGBc80VEjnS6JhtRFov7Eq3/rxfWPcd
	 BPOld9+egAPRtJAwEQRltCnVSAJ3aaPopEPhDnF2xaanBcLQoYsrO4fOf7nX7HmsZ+/RP
	 nPqLlWnQo+BGFxGxm55iFRFk3hLznU7GS19CFqiu0W5A9jOxjoXOBEqSN2Ho9QqyEkOAl
	 2zadrkm9+WeaUnsArRz3Te1raSYVrnENOVaJXoZA+P1nYsJsJMspz49hnPYs391bMIUsM
	 bcoe9U0ujNautiiIox+t+3Hh0dHvJoKSGUKHrtw/JBeeJWPxYk3iqEG4g1VrKxLFteA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794221708;
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
	bh=khBLwigcW8QAwP36q9mSCCf5kYXoyK9KA6T5r9xAZr4=;
	b=2/INuHc9mV5zlj0Pps0H/SzzC8lB22Y11da0gHHbTlb9DytwkDK0CE8uNjYyVtPcT0a5
	 rUFm7PhWVXtx+QUo9RT4sAXeaIGu96aA6fvaHYpHzrCXnLpanicKHz0oLabQxNG7ngjXK
	 cOvJRJ82231rfmGv0SLqux3a3JmfsfzXJEb7g0jPrOd+2BLJ1XCvWqDV9b7GZq27gfRPM
	 +trQIZ+9gGEsDyr5DcluYp77IwUcmnQxgTJ3OqxUMjicpUvFwM8jIpiDCtgEzXCxz1rsw
	 5ik+tnQbn+BzeukvdI4RxOrU0U4ZqbZJfrVilHQ9TDVcIwtCyZ4+qyQojBQfhxpqhcw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ckRJhFca;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A344606A322;
	Mon,  9 Nov 2026 10:55:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2A344606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ckRJhFca
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794221707; x=1825757707;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=khBLwigcW8QAwP36q9mSCCf5kYXoyK9KA6T5r9xAZr4=;
  b=ckRJhFca298v+duuBIp9L44DE4xgUvTs+2EeNKhObQbtq1eCOovPe2sn
   8pQ/mKK6styXSUNhQXpAFijMPlVlXQx6qFZ0RUIGsm3+G+ZJcs2+HUHOZ
   0+U6BBr7jvEwUZ/GNN9ddlLy3vAMCaHLrTs+Uy/TKzNjXxZ/ROzXZP63o
   Pr1D7gXWZrsdt8wXYD/WF6laJjXLa5S8w9GWTlg445J2czLhiqITi9M9S
   Y/EDjdBJBL35Mrn3QBLX45noV8kJaxy6fG9P744AfIt2HbNFgu7z+KX61
   yTsau65ox+ghhcIPeJYsrGw06kLOECv2cgkrXeE9/iW34bmfAxZlEptrL
   Q==;
X-CSE-ConnectionGUID: b9hYE9gXQLmBVoU9XqOTHw==
X-CSE-MsgGUID: yTZpE5fSTlmVkmIwu94qkw==
X-IronPort-AV: E=McAfee;i="6800,10657,11960"; a="2979670"
X-IronPort-AV: E=Sophos;i="6.27,203,1787036400"; 
   d="scan'208";a="2979670"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 02:55:06 -0800
X-CSE-ConnectionGUID: mxjeHQaURh+LqnB5fwfAjQ==
X-CSE-MsgGUID: 0X9h4DwXQHCc9J5c/3ifTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,203,1787036400"; 
   d="scan'208";a="8175302"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2026 02:55:07 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 02:55:05 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 9 Nov 2026 02:55:05 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.52) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 9 Nov 2026 02:55:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=afYNAaVd52VvXxE7ccHIaYTSW9DtEYGFlQj/RC08oF+DUuzteVSFhkl0gpsWDigLnaFZjS57ELDakeX3fJROeh7u/6Pdg/fgL+TGIC4wOa5kfQmkum0pE99HkuPizvI9FZmoLYredKWV/3oAPoG5vpeiQsuYtlpGcUegftB/fy+XSjyfjR4niR0R5yVoy2e55V5D+00AjfFRshIAHeIwmslHgQ4j7jB4pzJnmGhmReDhTBUbjT5MlqoM/Js/BFzo47yjOl2/5c4l401mE+r3KpVIXlaXzDLM1FwdSoK6g8zEPbz8SlXsqvbHboOLTsL4mQV0OFeJUeqlg387UtutWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=khBLwigcW8QAwP36q9mSCCf5kYXoyK9KA6T5r9xAZr4=;
 b=FKWZt6fYTyuEAYkkaIN6y3aiWe1eaz4YGpUus8ex72/idVIzyOtarmIAwA7jTrpzbH+5Rkp/fOvju3J5z+zPIuQyoQ8LrCJI+ts087Uha18NXIO8GRLwugRc3ntk5Hon9xC0m8Ozwi75M2Fh3MMZVTgpaq/p1pz3kccjFJwGDbsc6PQUYkw63SFdiAymw853fiSK/EGHpM1223CBIsuupO8er4nvVOsEeO4aKc6+/KJS7DxRvINxNoxidPkrgpvBa6wTyOoGCO+opBcYyhINemC70JNPe6xlw7UFN/BfDAoHGMhxBE4n3+HmbJMTjw7b6fOs7VtAB3zCo1zhapX91w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by DS0PR11MB6400.namprd11.prod.outlook.com
 (2603:10b6:8:c7::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.12; Mon, 9 Nov
 2026 10:55:02 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0592.010; Mon, 9 Nov 2026
 10:55:02 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "Jiang, Dave" <dave.jiang@intel.com>
CC: Xu Yilun <yilun.xu@linux.intel.com>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>, "linux-coco@lists.linux.dev"
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
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABGSiAgAAXIXCAAEdkgIAANdmAgAMTyoCAADyIAIAANPsAgALf2ICAAQujcA==
Date: Mon, 9 Nov 2026 10:55:02 +0000
Message-ID: <DS4PPFA84FA90FC12B59A447BBEFE2053D8E7732@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com>
 <53bc57bf-1ee1-407a-b48b-bc6b2deee12a@intel.com>
 <20261108183337.GL770409@nvidia.com>
In-Reply-To: <20261108183337.GL770409@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|DS0PR11MB6400:EE_
x-ms-office365-filtering-correlation-id: f2b111cc-dc4f-45b8-a00a-08df3e4fe7fe
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|376014|7416014|1800799024|22082099003|18002099003|38070700021|4143699003|5023799004|11063799006|56012099006|10067099003|261028144727099003|261026121527099003|261102123227099003|261022075727099003|261022105027099003|261021121427099003|261026140227099003;
x-microsoft-antispam-message-info: KzL9iwzvxiROEaD7Z2sxBNDwROse0GdIylrLbrMq+OPy3WPT7680QF9fEngVuauCDtVlbjfdF8jhs+8JTc4e/B9Wo4tRVECYA3ZE4SEDricSTgDmihkBVuyVsqC7TPxwal1Aq2I5h7D8FTqaaW0QGyqXABNjsjMwgwD5mx8eyYyoWpx5ZVDMjEu9LoUakLBQr0x358u7Vr2/9b0oQ4rjH6RhHPjXdO0mAJTZMAS1N8h7TdP+vSn16B4c1kThHvOuITe7510CZkq+LceVY/+VLWucXElvWM1QRUKOMik8ldYBJjsxSzLxLG4ijThgBHCYNCbX1YOhNK2QRWIrgb8pcJ5K7eXy6EUJks1lb25aLKdVrtc+70tWMHqpkTiaiBXsK+eq3TuzMrpp+IhSV2B2393cJ99q9hWWpqU7lrQe9ikgS9Pp/5lOiv2g0SD4HbH563uEixjyk7JcNaKy9PQrtfxr1l08VOraM89Ru4/SXUQ4M43t66OO1Otwbg7FbLH4qZASzpM/GcYTLRgi1MXoGpTWxP1PWigtuFCabmvSWjrQy7Aj4hv5swMe2ZL/O1gPxn1rXjdHTzztHnOIodNTBhr8mGo6gC6CvJZC8yeiRWDgFsTZ51lj/XBmwRXMIGUkWP5noLDPyE8WOD0OfPEkW8Sm+j4zA0fsn+kjXYszXCb0YH2/ngpZXgPA9KZ5vgZESsgI3LC2RuOnX/74Jw+r+RA7ASg5tNg6MS2ccUOE0sE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(376014)(7416014)(1800799024)(22082099003)(18002099003)(38070700021)(4143699003)(5023799004)(11063799006)(56012099006)(10067099003)(261028144727099003)(261026121527099003)(261102123227099003)(261022075727099003)(261022105027099003)(261021121427099003)(261026140227099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0RvOUpFekZYL0djNHVHTUNCeXhXNHkzUWJCbEovVGVsWlJ6NU94Qkc2MmdI?=
 =?utf-8?B?UUtFQ2NBTFRIcjVUeDdMeVRyK1NBZkw5Q3RDdnBLMWJIV2ZIRGExREFaWGhq?=
 =?utf-8?B?WVpBUEJ6NWR3cGo0blFPOE5CQ2loeXJNMlluekFRN1pYcy9oVy9sS3JPRks0?=
 =?utf-8?B?OFZheUYyMDNZcUp2Z3ZWTHg4YjhlRjkzbDI4UitwNmZsOG9iNUtNN3FnWGpy?=
 =?utf-8?B?VGJIU1FETVE2UkhUSlFUOTZXa1RYZlpoQnBGYmIyNWdGN1RHWGNCa1BoT2hv?=
 =?utf-8?B?b3YxNnE3Z3dGY3RuWXBiNVlVMWI0b3hWOVd3eHY2NDZmcGF4Mm8vbCsxdjkr?=
 =?utf-8?B?Vm4xQlBRT2krMWxqNkNQQWNuZ2NHa0VGczFoWXJVbEczN3Z3eW9IRkxRdk1L?=
 =?utf-8?B?ZjRZeldJT2E3U0ViemNXbEw2aDNIb3Z1NW5jVVBNME1xRVQ2dmw2SHNjTVdz?=
 =?utf-8?B?UGJQLzJ5eVR6ZURCRENMK3NhT2tzbHhBME9kRWkrd3lkbjhFekNjcDkzK0Vs?=
 =?utf-8?B?ZnMxanVvTWNudE9oZkQrajBtSWc5RWpjZzQ3aXVqYi9BTzJzc2tKTlg1R0Mz?=
 =?utf-8?B?Y2JDMWtpbG5DMjBsQ3NobEVrVFN3enFvM0xCNFBpZEsyck15VHk0cG1uYWl1?=
 =?utf-8?B?SFBVMVplQSsvMHVJYTRna3FWbmJ4S1RYYnBCYlBHZHAveld1M294ak5DVjEz?=
 =?utf-8?B?ZDcvS3NnMklDUUxwU1hPVW1zVE5oMTcrSlJaZUJlKzJQT3UyY3EzWEFNUzdD?=
 =?utf-8?B?dGN2L0h0TkF6TUhydWd3WTJpNVBBNmRKeHdCV2thYmFGZW9Vc0NXTzJscXZV?=
 =?utf-8?B?MUFBcnZzaDlHY1Q0MGtsTlEyNDFWNmpBSWRqTmt2MVBLYkg0V1BIUHBrWUxH?=
 =?utf-8?B?ODlhZTJMZndFdC9MMUhvN2ZGTHN4Uk16a1hQbmFYME5BblZIaFhDN08rRHdi?=
 =?utf-8?B?TnhjWmxUVDhOb1dPMlIyLzFuaFRUMGIvb1ZUN1JNT0Y3QUNHcmNCNzhCcXZr?=
 =?utf-8?B?Z1RLei8xZktnMTRPWlRFdWVBank1RkJRWVRSeHBXa0FsUTA4a0ZtVmpPemRj?=
 =?utf-8?B?aUt2NTZid2dYbjkydzZGRTdxejBVZ1J6dldqVmIzL3IwYmJUbm9uMGhNU3Ew?=
 =?utf-8?B?YzNCYmZKcUpKV2FNS0NKSXpXUUdqWVN3WjVxaFRsZXRiVk5pSkh5QWx5Qk1t?=
 =?utf-8?B?QkQwaE5JQlJlRGczbzJCSnA5ZU5RWWlzWENYYS91SnVKdUdvSDFuV0dxS3RZ?=
 =?utf-8?B?MDJNbnQvaStYVStMTDVPeGE5TkRuTnZqb3VuTGNsblRva2F6aUU0OVNPbENG?=
 =?utf-8?B?ZHFaQ3JCSFdhVXMyRFNHOUtnZ3F4ZHh0eExqSmhGTmFOY2IrRmhWTDY5WHZI?=
 =?utf-8?B?U1publdLYnBCVUs1cTRkd0xoTFhtNGVGTTFYSHZhQUFJTnJUMEVxTitzZ3R0?=
 =?utf-8?B?bW9WTk00MkJWSmVvKzREVEtDNmlWbHhDc1VqQ01xRGdrSHhYYkUxclNFZEpQ?=
 =?utf-8?B?SUNQeFR4Vmh4SGdSSHNuUzB0L2RyM0J4a0VVV1VPbVA1N3JYQkl6b0xidUpL?=
 =?utf-8?B?K2t0Wm8xM3UxT2Yyd2FYWVBHRlU0TndXdVI2VU1pOVRNWmhkZEhQWExIZ29E?=
 =?utf-8?B?cDMzUWUxZGdRcEF5d3h5cmZ3elBRS0tjRWNnN3BUMDZDZkFmWGJsREE1Mmk3?=
 =?utf-8?B?alZ6cG5yd2tNWlZSaTg2Qy9UbDJ2WCtvdy95cWc5WGhoSGx1VW5ON0I0am9x?=
 =?utf-8?B?czJLWVppcHZnQ0tGaE9tTGlOaFQxTWJmYjlhNzNEOVRNTkR1NDIyNXBKS2Rz?=
 =?utf-8?B?OWFoVEdxQWhCNTRITWV3TWNFV2tCSjl5ZUQreitJenI2ZEwwclJNMi9FRDVC?=
 =?utf-8?B?K0NKNUM4RWlycGJLUHZ6QWNjdzlXdHd6ZXVMNUVySmV4NjlSYWx6TGRhY0VH?=
 =?utf-8?B?RnN0SGgyRWc4d0x4aFQ5SEJ4TUJLVk9EVmgyMmc2UWZDU1ppeFp4QnZadjlo?=
 =?utf-8?B?OStFLzBKK1ZwWThhNjRxRzdKTmlnRW1JVXB5QlNRVE5ZODlKT3Jia1duNzRG?=
 =?utf-8?B?RW1xS2FKVTRjeks4Q0ZBY29UaWdjZHRpVWtyZklWZ29EdFpqeFgyZnVjd1ox?=
 =?utf-8?B?K05sN0xNcUczZFlqbG9kZHN4cG56OUhuKzBDWWdWZVE3QWtncEJKK0QwdzNV?=
 =?utf-8?B?K0sxMkNoTDkreEN6VFh6Z2ZETGgyNjlFWHRSV29lTkNVMWhHNFE1RTdoYmdq?=
 =?utf-8?B?bWdKS3NiSDA2a1VpNlZTdEErdHJ0aDJBcUd5aGhIMVZ6M0xabTJzNjBlTDRm?=
 =?utf-8?B?eUZSaWVmbmwyNWdhVThvdW1KcXhRejlQZkxGZndDQ1lINzRYWUg5dz09?=
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
X-Exchange-RoutingPolicyChecked: j11GzDX6e1/O5cf8QU63Pf7EbnwZU6zVqhMVOMTuGMQo6s9a7yEpZNWBj7uJwRGmkMJnpYfGl5g3EEu91GCwEc41o/S4tOjCTD1U6IBlRwOvzCo9RaNhsptFBvyjFx3Ua+NKmlXChShHvoAbVj+Hi6V6CcCrZp2wk+muIBekTQjJ744RKxjiJl0pX8jyNngvSggdDWgQepSmpQ7k7rrxLUKVoGpKk//wn1xMCjlSKasKnj6qMrr6NvFW1D5UsO46gHDHFp73StNYv6x9rL9cxMPYNmkUk1xXbhLT9A/v5r7vbU9XWwj1voX1qpYZw1SBVo83q/3oQ3Ed/kPaFPsAUQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2b111cc-dc4f-45b8-a00a-08df3e4fe7fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Nov 2026 10:55:02.5205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LmmbclshDuxQP5kvCxx5nMHoLiP1S+YhIFQp3U3fSMKYcZ36DPXxmxaIRrc9sglUrrLvVLI5WHsuIrNT+JdzYXg27Pbom549ii52bkptLSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6400
X-OriginatorOrg: intel.com

PHNuaXA+DQogDQo+ID4gSSB0cmllZCBkaXN0dXJiaW5nIHRoZSBzZXNzaW9uIGZyb20gdGhlIGhv
c3Qgd2l0aCBhIHRlc3QgaGFjayBpbg0KPiA+IHRkeC1ob3N0LCByaWdodCBiZWZvcmUgS0VZX0VY
Q0hBTkdFLiBBIGJhcmUgR0VUX1ZFUlNJT04gbWFrZXMgdGhlDQo+ID4gZGV2aWNlIHJlamVjdCBL
RVlfRVhDSEFOR0UuIFJlcGxheWluZyB0aGUgVkNBIHdpdGggb25lIGZpZWxkIGNoYW5nZWQNCj4g
PiBnZXRzIGEgS0VZX0VYQ0hBTkdFX1JTUCBiYWNrLCBidXQgdGhlIFREWCBtb2R1bGUgcmVqZWN0
cyBpdC4gU28NCj4gPiBLRVlfRVhDSEFOR0UgZG9lcyBibG93IHVwIHdoZW4gdGhlIGhvc3QgaW50
ZXJmZXJlcywgYXMgeW91IHNhaWQgaW4NCj4gPiB0aGUgb3RoZXIgcmVwbHkuDQo+IA0KPiBZZXMs
IHRoaXMgaXMgYSBjcml0aWNhbCBzZWN1cml0eSBmZWF0dXJlLg0KPiANCj4gVGhlIGhvc3QgY291
bGQgaW5qZWN0IEdFVF9DRVJUSUZJQ0FURVMgb24gaXRzIG93biByaWdodCBiZWZvcmUNCj4gS0VZ
X0VYQ0hBTkdFLCBhbmQgSSdtIHdvbmRlcmluZyBpZiB3ZSBlbmQgdXAgd2l0aCB0aGlzIHNjaGVt
ZSBpZiB0aGUNCj4gMS4zIG1vZGUgc2hvdWxkIHNpbXBseSBoYXZlIHRoZSBob3N0IGlzc3VlIEdF
VF9DRVJUSUZJQ0FURVMgYW5kIHRoZQ0KPiBUU00gc2lkZSBqdXN0IGRvZXMgR0VUX0RJR0VTVFMu
DQoNCldoaWxlIGl0IG1pZ2h0IGJlIG9rIGZyb20gc2VjdXJpdHkgcG92LCBpdCBsb29rcyBzb21l
d2hhdCBoYWNreS4uLg0KIA0KPiA+IE9uIFREWCB0aGUgcmUtcmVhZCBvZiB0aGUgY2hhaW5zIGNv
bWVzIHdpdGggdGhlIG1lYXN1cmVtZW50DQo+ID4gcmVmcmVzaC4gVGhlIGtlcm5lbCBkb2Vzbid0
IGFzayBmb3IgaXQgc2VwYXJhdGVseS4gRm9yIG9wdGlvbiAoQSkgSQ0KPiA+IHRoaW5rIHRoZSBr
ZXJuZWwgY2FuIGRyb3AgdGhlIHJlLXJlYWQgY2hhaW5zIGFuZCBwYXNzIHVwIG9ubHkgdGhlDQo+
ID4gbmV3IE1FQVNVUkVNRU5UUy4gSXQgYWxyZWFkeSBoYXMgdGhlIGNvcHkgS0VZX0VYQ0hBTkdF
IHNpZ25lZC4NCj4gDQo+IEkgZG9uJ3Qga25vdyB3aHkgeW91IGd1eXMgZG8gdGhpcywgSSB3b3Vs
ZCB0YWtlIGl0IG91dCwgSU1ITy4gSnVzdA0KPiB3YXN0ZXMgdGltZS4gWWVzLCBrZXJuZWwgc2hv
dWxkIGZvcndhcmQgdGhlIGNoYWluIGl0IGNvbGxlY3RlZCB3aXRoDQo+IEtFWV9FWENIQU5HRSwg
aXQgaXNuJ3QgYWxsb3dlZCB0byBjaGFuZ2UgYW5kIHRoZXJlIGlzIG5vIG5lZWQgdG8NCj4gcmVj
b2xsZWN0IGl0Lg0KDQpJIHdhc27igJl0IHBhcnQgb2YgdGhlIG9yaWdpbmFsIGRlc2lnbiwgYnV0
IGFzIGZhciBhcyBJIHVuZGVyc3RhbmQgaXQgd2FzDQpkZXNpZ25lZCB0aGlzIHdheSB0byBhbGxv
dyBjYXNlcyB3aGVuICpzb21lKiBjZXJ0IGNoYWlucy9rZXlzIGNhbg0KY2hhbmdlIGR1cmluZyBk
ZXZpY2UgcnVudGltZSBhcyBhIHJlc3VsdCBvZiBhIGRldmljZSBGVyB1cGRhdGUuDQpFc3BlY2lh
bGx5IHdoZW4gd2UgdGhpbmsgb2YgbXVsdGkta2V5IGNhc2UsIGRpZmZlcmVudCBkZXZpY2Uga2V5
cyBtYXkNCmhhdmUgZGlmZmVyZW50IGxpZmUgc3Bhd24gYW5kICpzb21lKiBrZXlzL2NoYWlucyB3
aWxsIGJlIGNoYW5nZWQgd2hlbg0KYSBGVyB1cGRhdGUgaGFwcGVucyBvbiBhIGRldmljZS4gSSB0
aGluayB0eXBpY2FsbHkgU1BETSBzbG90IDAgKGlkZW50aXR5KQ0KcmVtYWlucyBzdGFibGUsIGJ1
dCByZXN0IG9mIHRoZSBrZXlzIGNhbiBjaGFuZ2UuIA0KDQpCdXQgb2YgY291cnNlIGluIG9yZGVy
IHRvIHN0YXkgc2VjdXJlIGluIHN1Y2ggY2FzZXMgeW91IHdpbGwgbmVlZCB0byBoYXZlDQphIGNy
eXB0b2dyYXBoaWMgYmluZGluZyBiZXR3ZWVuIHRoZSBvbGQgYW5kIG5ldyBrZXlzLiBUaGlzIGNh
biBiZSBkb25lDQpnaXZlbiB0aGF0IHJlLWNvbGxlY3Rpb24gaGFwcGVucyBpbnNpZGUgcHJldmlv
dXNseSB2ZXJpZmllZCBhbmQgZXN0YWJsaXNoZWQNClNQRE0gc2VjdXJlIHNlc3Npb24gYW5kIHlv
dSBjYW4gcHV0IGFkZGl0aW9uYWwgc2VjdXJpdHkgcnVsZXMgb24gdG9wIGFsc28NCmlmIGRlc2ly
ZWQgKGkuZS4gcmVqZWN0IGlmIHNsb3QgMCBrZXkgY2hhbmdlZCwgcmVxdWlyZWQgc2lnbmF0dXJl
IG9uIHVwZGF0ZWQNCm1lYXN1cmVtZW50cyBzdGlsbCB1c2luZyBzbG90IDAga2V5LCBldGMuKS4g
QWxzbywgdGhlcmUgaXMgYSBub24tc3Bva2VuDQphc3N1bXB0aW9uIGhlcmUgdGhhdCBpZiB5b3Ug
dHJ1c3QgdGhlIGRldmljZSBhdCB0aGUgdGltZSBvZiBTUERNIGNvbm5lY3QNCihhZnRlciB2ZXJp
ZnlpbmcgYWxsIHRoZSBldmlkZW5jZSkgdGhlbiB5b3UgdHJ1c3QgZGV2aWNlIHNlY3VyaXR5IHBv
bGljeSBub3QNCnRvIGRvIGZ3IHJ1bnRpbWUgdXBkYXRlcyB0aGF0IGNhbiBkb3duZ3JhZGUgc2Vj
dXJpdHkgb2YgYSBkZXZpY2UuIA0KDQo8c25pcD4NCg0KPiA+ID4+ICgzKSBUREguU1BETS5DUkVB
VEUgcnVucyBmaXJzdC4gVGhlIGtlcm5lbCBzZXRzIENFUlRJRklDQVRFX1NMT1RfTUFTSw0KPiB0
bw0KPiA+ID4+ICAgICAweDAxLCBzbyB0aGUgVFNNIHJlYWRzIG9ubHkgc2xvdCAwJ3MgY2hhaW4u
IEl0IGNvdWxkIGFsc28gcmVhZCBzbG90cw0KPiA+ID4+ICAgICAxLTcgaW5zaWRlIHRoZSBzZXNz
aW9uIFtHVUlERSBCLjEuMSwgVGFibGUgQi0xXSwgYnV0IG5vIHNpZ25hdHVyZQ0KPiA+ID4+ICAg
ICB3b3VsZCBjb3ZlciB0aGVtOiBLRVlfRVhDSEFOR0UgaGFzaGVzIG9ubHkgdGhlIGNoYWluIG9m
IHRoZSBzbG90IGl0DQo+ID4gPj4gICAgIG5hbWVzIFtTUERNIDEwLjE4LjFdLiBTbyAoYSkgZG9l
c24ndCByZXBvcnQgdGhlbS4NCj4gPiA+DQo+ID4gPiA/IHRoaXMgaXMgY29uZnVzaW5nLiBLRVlf
RVhDSEFOR0Ugc2xvdD0wIGluY2x1ZGVzIHRoZSBoYXNoIG9mIHRoZQ0KPiA+ID4gY2VydGlmaWNh
dGUgY2hhaW4gaW4gc2xvdCAwLiBJZiB0aGUgVFNNIGRvZXNuJ3QgZXZlbiByZWFkIHRoYXQgc2xv
dA0KPiA+ID4gZHVyaW5nIHRoZSBwcmVtYWJsZSBpdCBpcyBpbXBvc3NpYmxlIHRvIHZhbGlkYXRl
IHRoZSBLRVlfRVhDSEFOR0UuDQo+ID4gPg0KPiA+ID4gV2hhdCBwcnVwb3NlIGlzIHRoZXJlIGZv
ciB0aGlzIGNvbmZpZ3VyYWJsZSAidGhlIGtlcm5lbCBzZXRzDQo+ID4gPiBDRVJUSUZJQ0FURV9T
TE9UX01BU0sgdG8gMHgwMSIgPyBJZiB0aGUga2VybmVsIHNldHMgZm9yIHNsb3QgMSB0aGVuDQo+
ID4gPiBLRVlfRVhDSEFOR0UgbXVzdCBmYWlsPw0KPiA+DQo+ID4gTm8sIGl0IGRvZXNuJ3QgZmFp
bCwgYW5kIHRoZSBub3RlIHdhcyBjb25mdXNpbmcuIFRoZSBtYXNrIGRvZXNuJ3QNCj4gPiBjb250
cm9sIHNsb3Qgc2VsZWN0aW9uLiBJdCBvbmx5IHBpY2tzIHdoaWNoIG9mIHNsb3RzIDEtNyB0aGUg
bW9kdWxlDQo+ID4gYWxzbyByZXR1cm5zLiBTbG90IDAncyBjaGFpbiBpcyBhbHdheXMgcmVhZCBh
bmQgcmV0dXJuZWQuIFRoZSBtb2R1bGUNCj4gPiByZWFkcyBpdCBpbiB0aGUgY2xlYXIgYmVmb3Jl
IEtFWV9FWENIQU5HRSwgZXZlbiB3aXRoIGJpdCAwIGNsZWFyLg0KPiA+IFNsb3RzIDEtNyBhcmUg
cmVhZCBpbnNpZGUgdGhlIHNlc3Npb24gYWZ0ZXIgS0VZX0VYQ0hBTkdFLiBTZXR0aW5nDQo+ID4g
MHgwMSBqdXN0IHNraXBzIHJlYWRpbmcgY2hhaW5zIG5vdGhpbmcgc2lnbnMuDQo+IA0KPiBPSy4u
IFdlaXJkLCBub3Qgc3VyZSBJIHNlZSB0aGF0IGFzIHVzZWZ1bD8NCg0KVGhpcyBpcyBjdXJyZW50
IGRlc2lnbiBmb3Igc2luZ2xlLWtleSBjYXNlIChtdWx0aS1rZXkgaXMgbm90IHN1cHBvcnRlZCku
IA0KR2l2ZW4gdGhpcywgaXQgbWFrZXMgc2Vuc2UgdG8gdXNlIGZpeGVkIHNsb3QgMCB0byBhbHdh
eXMgZXN0YWJsaXNoIFNQRE0NCnNlc3Npb24gKHNpbmNlIG90aGVyIHNsb3RzIG11c3QgaGF2ZSB0
aGUgc2FtZSBrZXkgYW55aG93KSwgYnV0IGFsbG93DQpWTU0gdG8gY29uZmlndXJlIGlmIGl0IHdh
bnRzIHNpbmdsZSBzbG90IChmYXN0ZXIsIGxlc3MgZmV0Y2hpbmcpIG9yIGFsbA0Kc2xvdHMgb3Ig
YSBzdWJzZXQgb2Ygc2xvdHMuIElNTywgaW4gYSBzaW5nbGUga2V5IGNhc2UgaXQgbWFrZXMgc2Vu
c2UgdG8gZmV0Y2gNCmFsbCBzbG90cyBhbmQgY2hhaW5zIGF2YWlsYWJsZSBhbmQgcGFzcyB0aGlz
IGluZm8gdG8gdGhlIGd1ZXN0IHRvIG1heGltaXplDQpjaGFuY2VzIHRoYXQgZ3Vlc3Qgd2lsbCBm
aW5kIGF0IGxlYXN0IG9uZSBvZiB0aGVzZSBjaGFpbnMgYWNjZXB0YWJsZSBwZXIgaXRzDQp0cnVz
dCBwb2xpY3kuIA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYS4gDQo=
