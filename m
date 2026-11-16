Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.14
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794836397;
	b=rbG7PSkA2oau56NYDL8PfagY3cf2cKiCXnMT5c6WSHEgOsS2mYwtySeTR6EX4UgEqIUG
	 OqWWpQiin55xSr+hkcnHTMfgIZFFvGtEaupCSDZaRbrR62VwKGD29giJt3rTNi/9szKLL
	 CfO7z2Y9GVoWFDYc0z7sTErFpBj8QOF60S+VlPag/VdFRGVUKLMnSgmjteE1qil6UxzyL
	 4A8B/heyZqgGrhjDQzI065CFtotTQa7HQsxAd/rse9mXBKWO6DFW8aIRlcJy562LllRDo
	 nYuQ2dwJNL3LZ2QspG45XtFyB8Sik9pgYLZn7uIqtD7FOxlu6VN+ow2KWi6aAMuNoXQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794836397;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Received:
	 Received:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
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
	bh=9ly6N1N6mKivMkYmv+oWV05ZMsKw3IGJWwBbvlkVGiA=;
	b=Enwol5pk8civPvZoNLVQK1mudJN8k1tG+TwkaeE+cKZeOErL88OQrr9Cb21Aqzp9VHHJ
	 R/2QgUTQ+abAX7wABr+6plRm9PJ6UlL6sX4RTkcS/h5fbyKnrdTDTm+vyMPZyuHMJ9CTl
	 vWdkpki73iMWOL5zW/Gzd4GR7Tbe+bEmgH6FhboRHpmJs9GpZyJwHmRWI1IePlg697jc6
	 abnq2Mif/H7XJVEIxSBbW7Q1BHDoZKOHPECqdgri/ZT0zHs3IAuBIQjY8wZtomdUkgoUK
	 oqQu1H+LDjwKg+9KDvNYspeKmihLUdAbU5AhwJK7jxHE/JdVuTkAgxE3dA0CqP6O9AQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gCZHelMB;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=cFR9zFSV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.14
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7233A606A31C;
	Mon, 16 Nov 2026 13:39:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7233A606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=gCZHelMB;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=cFR9zFSV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1794836397; x=1826372397;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9ly6N1N6mKivMkYmv+oWV05ZMsKw3IGJWwBbvlkVGiA=;
  b=gCZHelMBabzuFTD55mc+c/C2bHbqgcRmfF5ibumbRylNiIP97SkWubnf
   7BwePM2utkcrhvsAKgqc2iBKHeYKxcK0W4+eIh4xxaLDfHWDaAD7lSPYL
   JhTyFfCyvqds+MmW7KQLWBt2rQ3v8CWnhaVRsZs5aiARFISXAu3ZteJJ2
   L0hQXSS4L8O6IkYh5TdLC4B91UIS+xW3yBb6MOeprbdeHPiykgSojkeQr
   2nVcBebSWJ5hM24AAgGG00v7AVuYx5rOm0CQsooMLfLPsVVkwDx8SQ2VY
   eyQqjdM/JYaZXOjo6tKnKKoKhzeNawV+F3sV+0aY7Pm8CMvuIj8GN6xKs
   g==;
X-CSE-ConnectionGUID: xZp9kG/hT0e7kFRDfJDixw==
X-CSE-MsgGUID: ZUsjLMXlRhO7KMOpcRwxHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11968"; a="3466914"
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="3466914"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 05:39:56 -0800
X-CSE-ConnectionGUID: CN5Pz3b4T32vs5eITB7B9g==
X-CSE-MsgGUID: D2XvTiz9R9qi2fBr7GAsmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,216,1787036400"; 
   d="scan'208";a="9742281"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2026 05:39:56 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 05:39:55 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Mon, 16 Nov 2026 05:39:55 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.2) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Mon, 16 Nov 2026 05:39:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VV9P+VBsjnE3zqoQBq7u6C7TCWTHfbvIbq5njTeJsQDm5Mm9c0Und373sKV/l77e401IUOeEXPKPl3FoB4+XfdNn78EQa+QouH9hWyo1pR8Hc2OuYGwkyukHzT0lC4Fz8JWc53slbWPr7bJ/sozJTh/Ld9mAWy2yaz82dyo6M8Lg+0Sc+ifQmSiD73E9i/qZ3CKsxeA/dvyS9tRqzr993XM1ovIgOrzewUzO2/tbDzXbHv6LcQ7a9ck+dMeUPk4hqv5MAMmgcqjyOqaL1hJswW1hiUi4j721/N/Ief7x/lY1gAsGrupKLr+gMdk4j/2F6BVxRdFw59eMwvhU0SfTbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ly6N1N6mKivMkYmv+oWV05ZMsKw3IGJWwBbvlkVGiA=;
 b=lnpRPCqxGLiVSTgW0mMe31plfThr6fx2NZixqq/k2bGIHaW6nfhE5C45JPfMizTgLb04FEs3ECIwLrwX5Clw7PBc/nm7cZI53tFZF9f0QiWdtd8nXg9BYu3eh+5p849o0fm4Ilt34DUKhZAoa7z94nS/YqHAslR0DbcLY7/CYLAn9w1kHpw9Nc/ZALQd0gsVroo/W/aWI1C8QuRFPxyimnTzGNbpdQSkyFtDMu5U7uynnOEzKUwHSM1bsDARlpYStHe6VtcmKZo1G6GPOLFdNf4sEjaa9zSupqRFTay5k/uk+JlkHVCtzNVJ+ldyI5B4sZLtew9peLBYMsRpEVbs6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ly6N1N6mKivMkYmv+oWV05ZMsKw3IGJWwBbvlkVGiA=;
 b=cFR9zFSVEdw+peK3sErP6SPBYBS15dEAXxpJBMwb+gxbDfp0Ddg2QVkwu+K+VuxIznUDSZD1DKocGQoEMiAu2gotknagjD0gSHf7um7hWrnVluTbWzF2PHfcJ2PtYbiz40FI+mxtnTP4AdcrtQeeJh4Ffc32j8kcZ3MgtIRDhvI=
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by CY5PR11MB6464.namprd11.prod.outlook.com
 (2603:10b6:930:30::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.10; Mon, 16 Nov
 2026 13:38:50 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0615.013; Mon, 16 Nov 2026
 13:38:50 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Aneesh Kumar K.V
	<aneesh.kumar@kernel.org>
CC: "Jiang, Dave" <dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>, Jiri Pirko
	<jiri@resnulli.us>, "Tian, Kevin" <kevin.tian@intel.com>, "Alexey
 Kardashevskiy" <aik@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, Steven Price
	<steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
	Ashish Kalra <ashish.kalra@amd.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	Alistair <alistair23@gmail.com>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABGSiAgAAXIXCAAEdkgIAANdmAgAMTyoCAADyIAIAIyGyAgABYEACABi9HwA==
Date: Mon, 16 Nov 2026 13:38:50 +0000
Message-ID: <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <aurmtTe4ObBQhC4S@yilunxu-OptiPlex-7050>
 <DS4PPFA84FA90FCDC94900C2FC6CEF4D428E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261104134119.GR274202@nvidia.com>
 <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
In-Reply-To: <20261112145254.GL738765@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|CY5PR11MB6464:EE_
x-ms-office365-filtering-correlation-id: 56d2b088-4f66-4c04-8b9a-08df43e6f2ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|261009223027099003|38070700021|261026140227099003|10067099003|11063799006|4143699003|261021121427099003|5023799004|56012099006|261021135927099003|261022075727099003|261022113327099003|261022105027099003|261102123227099003|261028144727099003|261026121527099003|261102130727099003|18002099003|22082099003|6133799003;
x-microsoft-antispam-message-info: cWsaL/SNcKHkQdSX3a2RTXOjoaRH0KAPzXB6dH1+XHQKClYRras4xOqcFhNv5JLZHsuFpGsRNuFrnNL1RUbGb3V9gZlEQ8cVIHxMft7a3OB2yKAzVaffy1DStewxt1s6ZtK5RYkG8xaRljdYJCPs4ZR4cpj2m/7VrENlZ/JLai+qBP+a++fSciFn0Xw8MqI3D+e1kBpsLSPB26sgCPp/IyHovEQhY6UerM2BzLzvXaHjiEpAk/JQcVLDEh49rU2IRsNlppw0k70Jjn7y3A8JKRggAN+/lsOOTioY9a81sLUmbv8p+xjDz3Sa7VLcxDYjEPPvjR+EofXeyBhX0cfKn91/1UmJYcakuvSBqlyTA0OIgchh/+JpdtSRDPSYoshbVBqrlCmrjMwPFHJ4EMeE8XKaG3II/FESlK+8jFelCfozXA7jxaDWxVd54TlrEAbXARS2ZWXnGmc8t+oGFW+2lyjDDj40PqwCCLUj2AQp/KIDGYYYtcNCvrbJwf5hTQHJaAHd97g8rUqIUzwugm/uvwpoLuNK3Vz0Otd+Tjz02NI+lUte09UBwkpHOrIn/FPqavTzLoB2OXdM8oX+wLhIH3Y5Wx+RFvvoHO41H/avcLzRMHLqSqzdB1SYrR4r87SmKF3IfDwS9Qn6f01jiYMUNOjtMFi7TLuKQ4aT2vLusyKze/sImKIeLi6j2/d/H7eSz3AMQJBvPRm/Fo4vM3PsFQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(261009223027099003)(38070700021)(261026140227099003)(10067099003)(11063799006)(4143699003)(261021121427099003)(5023799004)(56012099006)(261021135927099003)(261022075727099003)(261022113327099003)(261022105027099003)(261102123227099003)(261028144727099003)(261026121527099003)(261102130727099003)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTdtU3FYVkdwdC84SVRiNHlmTTJqclN2enJhTUV6SXZEZTlpSUVUdUwybjJj?=
 =?utf-8?B?ZGxOd3BvOHR1RFlnamFsbXA1OTUzcXp2eitjSEM1ekxKTkJsRnhmaXAydHY2?=
 =?utf-8?B?dTRjMkEydDNJam9EaVlKV1NKa21MaUorOERSY21STy83RUdoRGhyME16NVcz?=
 =?utf-8?B?eCs0bWhpcVNGWWpGQjJzMUlWK3JHN004SXFaYnlWZkJkQzkvRGlNZmNlMk5i?=
 =?utf-8?B?Qlp1M01lQVkvRWJYRTNBMS9kN0hJT1JNRDV4MzhyN253bXVxVVMxbW1IOEJI?=
 =?utf-8?B?RURJcmRUTlA3cVd0V1VaVnlGY2hpWTdBR3hiK0xrMWxidWMvMURRbkorSnps?=
 =?utf-8?B?Mkk5WGZyTWc3L3RhOTcxZU1DQmF0SS9kOHN5N1FMY0Y3aEJ6ZGIvKzZRMU5p?=
 =?utf-8?B?dkNMZG1aVW1BMmpUZjdnZVc5TGRVYldkeGQzbVNFLzJYcnBvSHVoSk1PSTB2?=
 =?utf-8?B?ZlAxYjRHTmJOT3BBOG1IQXpCUWw2cENQTVJOcXdySGJVeWJUNVhDc0granZw?=
 =?utf-8?B?SHg2MUl5UlplVVZ1VHVPQ1ppa3NkSVMrb2tPbkVPZC9MTGE2bFVWZjZWa3dK?=
 =?utf-8?B?WWtWZ2tQN1EzaE80MldKNmQ2NDFSZGRFbmYzVWpFRXk0WUZZa09IbU4yL2xB?=
 =?utf-8?B?aHhxZWlaU2lueFJMdmdrV2JVdzk1THJSbDlpVUMzZGdOZkgveEhEVWhkYWhC?=
 =?utf-8?B?Sm15T3I2c3VvS2laRmh5VWNpR0VNWmpLay82bEJvWDAzbnhiTXlMNGxWUjRR?=
 =?utf-8?B?ZjB2Wm14NGdXQms5WGJ5RXJLM0UvV3JYRnVlb0dpMVYrSlQ4VlRlT3JpZVlQ?=
 =?utf-8?B?RHVjVWFLMUJHMzMxZjZEbklRUGI4cFRSR0JMZHcrVkhid2Z1d0pnSUg5YmF2?=
 =?utf-8?B?cEtVYTNHazR6UzZ4MXlrY05CbGIwL1VXYUVUZW82cTJOR2RHemlUclRjTkhy?=
 =?utf-8?B?bVZtZ0tuMEdmYU1weDNJNEhaQncyd3hZd2t5Q0FaVXRLK0NqVWhTUjk5WUcw?=
 =?utf-8?B?a1VyVy9xSjN0clhMcnVkVVVseDV3Sit2OHJZK0RMZXBvNXhiQ29pOG5rdFdI?=
 =?utf-8?B?SFl3R2JnWEplU0tRS0pJY3FkWkhSdFNpZU8xMkk4WXlrUy9JQm11YnVVcjUy?=
 =?utf-8?B?ZHc2N1Y1S2V6aFRJL2JYQ2xmRmxZNktGUjFId3RlekpVOHNnakR1THV1NVMz?=
 =?utf-8?B?ODR4NDhSbHR4c054bEZvaDhSNWpCYTZMdUcvQy9XSXRHWkRTZnIrcWY1Z3E0?=
 =?utf-8?B?aVhlZUphbkdUVU1yRnZXbFlNWS9qL05rQVZWclpzVGlpNTFlVEoxTXZpUlRj?=
 =?utf-8?B?VlBSQ05yQVdGaDVrS2o4L2hZRGI3YkhjdkJNTHRhcldDSzRwdUFGbEFPOW1w?=
 =?utf-8?B?dFpyQU5HZU5zY2FwSkNuaWMycjJMMGxLeFViaHA2OFRST1FJT1pQTmdsbDRH?=
 =?utf-8?B?SDc1cmVmZUV6Y3M3Q04va2RBdDVuR3ZRSVZKZUowa2x1b281MkJiM3FiY0RP?=
 =?utf-8?B?bVMvT3c5Y3BJYVlRbm16OG05blRWNjFDQU52ZGk1OGhwajRMcEkrRjQyQTUw?=
 =?utf-8?B?UE9IeUVHM0kvZkpoSndFZzdxSnQrUlBZRjkrRHcrSEptODVtOEpsbFpZODFV?=
 =?utf-8?B?ODlhNm1IUXhrRjhpUTUvR0cwZWNSdVlsTW1yRm1mSC9vMjlncXlNVVN5RlBE?=
 =?utf-8?B?cUlqMTJCYzdPbEd1NVhvMk9YTHJCaTA5MkNQcm95Rm9PK1VXVmxocHhWQ2NU?=
 =?utf-8?B?dVhwWTMyRGhCZWhSbjJ1QVJjK1ZZa2cwZDBlVVNoRGNBQU0vb0x5b3JlK0cv?=
 =?utf-8?B?OGJSL2NCa3hLN0UrMFdaWnBVeHI1NStYWDQ3bWNMb1RkQkdsWVdPRnpZQ2s2?=
 =?utf-8?B?ZGxuR0JFVDVBUGxxNmhEY0J4RWdDZnJrQUxxNGp2OGRTdDBld1hsdkNYanpU?=
 =?utf-8?B?VjUyYjZQeHNNZ3dzcXpIckltSzh0emRRcEdMSThOZUkrSFdRNlJSZjFHNjRZ?=
 =?utf-8?B?WXlOdTJTUkE0Zmk1YmhHaU1VbG0zaU1ITkpoY01aa2lCcTFPbTVpWVJVT0VB?=
 =?utf-8?B?QlNjeGN0bE82VllPaXNTc1BGQTZkNXMxMCtTY1ZMMlhydStIRTRlcDBSaEVS?=
 =?utf-8?B?R2kzL2MzdHlYckpac2QwTzJRWUF5bnJOOC8wM2VTN1B3akMzYUIydWJLZ3lX?=
 =?utf-8?B?NVpyYlN4ZFAwclIzRFgvNU1wRm8vdWtLMFVabWhyaWZHVjROSzVZSWcyNlkz?=
 =?utf-8?B?VGdlR2toaDN1YVpOZVRrVDJLdWhkdkVjWXlwZFA1STlGNDJUZnJBUmV1ZFJC?=
 =?utf-8?B?cVR3cnNiMk1IazVvSVdSZ3I0a2NybUU0VW9HVG9VdDl1TTVTdG1sUT09?=
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
X-Exchange-RoutingPolicyChecked: C7DUqI28Uuy3Zy76S6YMrf+RFSC2oLpMGwj7txrZPTfoZO/EPmftyReMIfrTyo2UVMPoJxVW5555q6OtpWKEop0v6kOphg+mIJ1SPqsoFcIqKbL9uEYR4jquglpp7yfGvyi5yao2nbMM7g08fzbjgvusDbFN9OHK+Pf/+0lXUhIKN5T/m93F/bYuGKz3lTnabpoMsZ3F2bxTc7dWP9czz44SYsjog6KVPhbWupFw2JJWvbcm7zM/XagOCNvlnd/GRD4NXyqJX+E0qeoIhlbz1+HRtW5Y5A84g1XQ7XMHrPzyspa6mFo5IhF71rhqfSx19qokONzwnMh/TRtyHpcXVg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56d2b088-4f66-4c04-8b9a-08df43e6f2ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2026 13:38:50.3609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DFISALVXDlYHfW22h0s8hUbjLjGWLghrznKXQ4zusLikdzLHPisn8mE+gvtk2ZWE4AAnNlzzG20Ypl6oSD3y1pE5eapDLzGagSvYRddRXOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6464
X-OriginatorOrg: intel.com

PiBJbnRlbC4uIElzIHdyb25nIElNSE8uIEl0IGlzIHN0aWxsIHVucmVsZWFzZWQsIGlzIGl0IHRv
byBtdWNoIHRvIGhvcGUNCj4geW91IGNvdWxkIGp1c3QgY29weSBtb3JlIGZyb20gQVJNPw0KDQpJ
IGFtIGxvb2tpbmcgbm93IGludG8gd2hhdCBjaGFuZ2VzIHdlIG11c3QgaGF2ZSB0byBzdXBwb3J0
IDEuMg0KKG11bHRpa2V5IHdpbGwgbmVlZCBldmVuIG1vcmUgY2hhbmdlcyBhbmQgSSBhZ3JlZSB3
aXRoIG92ZXJhbGwgDQpkaXJlY3Rpb24gdGhhdCB3ZSBoYXZlIGNvbnZlcmdlZCBpbiB0aGlzIHRo
cmVhZCkuDQoNCj4gIDEpIE5vIGVhc3kgd2F5IHRvIGdldCB0aGUgVkNBLCBubyBlYXN5IHdheSB0
byBkbyBjYXB0dXJlDQoNCk15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBWQ0EgbXVzdCBoYXZlIGJl
ZW4gaW5jbHVkZWQgaW50bw0KU1BETV9ERVZJQ0VfQVRURVNUQVRJT05fSU5GT19UIGZyb20gdGhl
IGJlZ2lubmluZywgaXQgd2FzIG9taXR0ZWQNCmJ5IG1pc3Rha2UgYW5kIHdlIGFza2VkIHRvIGZp
eCBpdCBhcyBEYXZlIGFscmVhZHkgcG9pbnRlZCBvdXQuIA0KVGhhdCBmaXggb2YgY291cnNlIGRv
ZXNudCBoZWxwLCBpZiB5b3UgcmVqZWN0IHRoZSBleGlzdGVuY2Ugb2YgDQpTUERNX0RFVklDRV9B
VFRFU1RBVElPTl9JTkZPX1QgdG8gYmVnaW4gd2l0aC4gDQoNCj4gDQo+ICAyKSBXcm9uZyBkaWdl
c3RzIGRlc2lnbiBmb3IgdGhlIGd1ZXN0LiBTUERNX0RFVklDRV9BVFRFU1RBVElPTl9JTkZPX1QN
Cj4gICAgIGlzIGEgdGVycmlibGUgaWRlYSBzaW5jZSBpdCBpcyBub3QgZ3JvdW5kZWQgaW4gYW55
IHNwZWMuIFRoZSBvdGhlcg0KPiAgICAgdHdvIGhhdmUgbXVsdGlwbGUgZ3Vlc3QgZGlnZXN0cyBj
b21wdXRlZCBkaXJlY3RseSBvdmVyIHNwZWMNCj4gICAgIGRlZmluZWQgb2JqZWN0cy4NCj4gDQo+
ICAzKSBFdmVuIGlmIHlvdSBsaWtlIFNQRE1fREVWSUNFX0FUVEVTVEFUSU9OX0lORk9fVCBpdCBp
bmNsdWRlcw0KPiAgICAgVERJU1BfQ0FQQUJJTElUSUVTIGZvciBzb21lIGJhZCByZWFzb24uIE5v
Ym9keSBlbHNlIGV2ZW4NCj4gICAgIGV4cG9ydHMgdGhpcyBpbmZvIGZyb20gdGhlaXIgVFNNIG9y
IGRpZ2VzdHMgaXQuIFRodXMgSW50ZWwgd291bGQNCj4gICAgIG5lZWQgdW5pcXVlIEFQSSBmb3Ig
dGhlIFZNTSB0byBldmVuIGJ1aWxkDQo+ICAgICBTUERNX0RFVklDRV9BVFRFU1RBVElPTl9JTkZP
X1QuIE5vdCBuaWNlLg0KDQpJIGRvbnQgdGhpbmsgdGhlcmUgaXMgYW4gZXhwZWN0YXRpb24gdGhh
dCB0aGVyZSBuZWVkcyB0byBiZSB1bmlxdWUgQVBJDQp0byBidWlsZCB0aGlzIHN0cnVjdHVyZSAo
SSB0aGluayB3ZSBjYW4gaGlkZSBpdCBpbiB0aGUgdGR4LXNwZWNpZmljIGNvZGUpLCBidXQNCnlv
dXIgcG9pbnQgYmVsb3cgaXMgdmFsaWQ6IHRoaXMgU1BETV9ERVZJQ0VfQVRURVNUQVRJT05fSU5G
T19UIGJsb2INCm5lZWRzIHRvIGVuZCB1cCBvbiB0aGUgZ3Vlc3Qgc2lkZSBiZWNhdXNlIG9ubHkg
dXNpbmcgdGhpcyBibG9iIHRoZSBndWVzdA0KY2FuIGN1cnJlbnRseSB2ZXJpZnkgdGhlIGV2aWRl
bmNlIG9mIHRoZSBTUERNIGNvbm5lY3Rpb24gZXN0YWJsaXNobWVudC4gDQoNCj4gDQo+ICA0KSBI
b3cgZG9lcyBmdXR1cmUgZXh0ZW5zaW9uIHdvcms/IE9oIHlvdSBwcm9iYWJseSBoYXZlIHRvIHBh
c3MNCj4gICAgIFNQRE1fREVWSUNFX0FUVEVTVEFUSU9OX0lORk9fVCBhcyBhbiBvcGFxdWUgYmxv
YiB0aHJvdWdoIHRvIHRoZQ0KPiAgICAgVk1NLiBMb3ZlbHksIHNvIG9ubHkgSW50ZWwgbmVlZHMg
YSBzcGVjaWFsIEludGVsIHNwZWNpZmljIGJsb2INCj4gICAgIHVBUEk/IEJhaC4gVGhpcyBpcyBh
IHZlcnkgYmFkIGlkZWEuDQoNCkhvdyBkb2VzIHRoZSBldmlkZW5jZSByZXRyaWV2YWwgd291bGQg
YmUgc3BlY2lmaWVkIGJldHdlZW4gdGhlIGhvc3QgYW5kDQp0aGUgZ3Vlc3Q/IFdlIGFjdHVhbGx5
IGhhdmVu4oCZdCBkaXNjdXNzZWQgdGhpcyBwYXJ0IHNvIGZhciwgYnV0IGZvY3VzZWQgc29sZWx5
IA0Kb24gdGhlIGhvc3QgcGFydC4gSWYgeW91IGVudmlzaW9uIHRoYXQgTGludXggd291bGQgc3Rh
bmRhcmRpemUgb2JqZWN0cyB0aGF0DQpndWVzdCBjYW4gYXNrIGhvc3QgdG8gcHJvdmlkZSwgaS5l
LiAiZ2l2ZSBtZSBWQ0EiLCAiZ2l2ZSBtZSBhbGwgYXZhaWxhYmxlIGNlcnQNCmNoYWlucyIsIGV0
Yy4gVGhlbiB5ZXMsIGhhdmluZyBhIHN0cnVjdHVyZSBsaWtlIGFib3ZlIHRoYXQgaW5jb3Jwb3Jh
dGVzIGFsbCB0aGVzZQ0KcGFydHMgaXMgYSBwcm9ibGVtIHdlIG11c3Qgc29sdmUuIA0KQ291bGQg
eW91IHBsZWFzZSBzaGFyZSB5b3VyIHZpZXcgb24gdGhpcyBvbmUgYWxzbz8gVGhpcyBpcyBhbHNv
IGltcG9ydGFudA0KcGFydCBvZiBvdmVyYWxsIGRlc2lnbi4gDQoNCj4gDQo+ICA1KSBTZXZlcmFs
IHVubmVjZXNzYXJ5IGNvbGxlY3Rpb25zIGR1cmluZyBjb25uZWN0aW9uIHNldHVwLg0KPiANCj4g
IDYpIENvbmZ1c2luZy9iYWQgaW1wbGVtZW50YXRpb24gb2YgJ1RTTSBzZWxlY3RlZCBub25jZScg
YW5kDQo+ICAgICAicmVjb2xsZWN0aW9uIg0KPiANCj4gIDcpIExhY2sgb2YgYW4gQVBJIHRvIGRv
IGV2aWRlbmNlIGNvbGxsZWN0aW9uIGZvciB0aGUgaG9zdCwgdGhlIG9ubHkNCj4gICAgIHByb3Zp
ZGVkIEFQSSBhbHdheXMgY2hhbmdlcyB0aGUgZ3Vlc3QgdmlzaWJsZSBpbmZvcm1hdGlvbi4NCj4g
ICAgIE5vdCBuaWNlLg0KDQpDb3VsZCB5b3UgcGxlYXNlIGVsYWJvcmF0ZSBtb3JlIG9uIHRoaXMg
b25lPyBJZiB5b3UgbWVhbiBpbml0aWFsDQpldmlkZW5jZSBjb2xsZWN0aW9uLCB0aGVuIGl0IGRv
ZXNudCBjaGFuZ2UgYW5kIG11c3Qgbm90IGNoYW5nZQ0KKHdlIGNvbmNsdWRlZCB0aGlzIGFscmVh
ZHkpLiBJZiB5b3UgbWVhbiBjb2xsZWN0aW5nIG1lYXN1cmVtZW50cw0Kb25seSB0aGF0IGd1ZXN0
IGNhbiBhc2sgbGF0ZXIgb24gKHdpdGggZ3Vlc3QgcHJvdmlkZWQgbm9uY2UpLCB0aGVuDQpkaWRu
dCB5b3Ugc2F5IHlvdSB3YW50IHRoaXMgdG8gYmUgYWx3YXlzIHJlZmxlY3RlZCB2aWEgdHJ1c3Rl
ZCBkaWdlc3QNCmV4cG9zZWQgdG8gdGhlIGd1ZXN0PyANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEu
DQoNCj4gDQo+IEphc29uDQo=
