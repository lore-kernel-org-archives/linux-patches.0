Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.21
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793969394;
	b=dL/fj2xCwEvp9R1I/mB5fp6ZJftdjTchfYCWPXUbV2edFdk0hZ/Z2R1ky1lWnZE1k6mp
	 daiHB2vGgmauwRuDHZXj71RxNgEG2QO1DyknFeuqX/JVsOuKoCan+CRIMrV/jrhmxrkua
	 4I1nZa+Qjmo/iPWP0/OHFfyREWhBAyNUKvC5vxE6m93lgK87HotrQn7TSKAgC0GvcPMQ8
	 PaViTrwln9MK+bvklbQcisFXHN7QXhNndTRv1/kI29+Zd97p16bvVSN8a7srnuFvEDXQi
	 cnwNLavtCH4szDW7tfs230WevM3MpRskfgkBL9fBKU59EJRQIiK2rrdU1hfe10rocrw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793969394;
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
	 x-ms-exchange-antispam-messagedata-0:
	 x-ms-exchange-antispam-messagedata-1:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:
	 X-Exchange-RoutingPolicyChecked:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
	bh=Z86eYFUM+MfHmijJX10hjtxcwOL8ZqDJ7iXkmhu3Nb4=;
	b=yxhcRzGy8ZLIcI8lUTsgzkvRJ/OmTdJR19sgC0AXCgnHf3Xem49Se9szBZ0gnoAWZCXK
	 8Rl02nhf2XTrmZpltsmt0/wrtvVO0INoBMJUGKFUkvtGGcf+KxD6PlGd1EXzYYrDWMdN/
	 3DlNo5CLEdf5/xwA062a2Hitt91AwfvfPoPWMsIH125NA8RCunlw8qo4iKMvPqFDrdEYx
	 TkBCH5hwwlMW+OAu9olkUsrveiCpZMWoG/9VRdHYejHBksIKeH9JheIUd6hlt4RwrtnBE
	 sO+NUbJpm2gPSX1IwhP7HGm7qS3MqT31+2OmC95a/v2nTjBN773QiSaaFLB2fVI2y4A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ww3bgMMM;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.21
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D11606D811;
	Fri,  6 Nov 2026 12:49:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 31D11606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Ww3bgMMM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793969394; x=1825505394;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z86eYFUM+MfHmijJX10hjtxcwOL8ZqDJ7iXkmhu3Nb4=;
  b=Ww3bgMMM/YGkbgZxz6rCcwhJahAdwv8Kiv+EiSqiJL7sNrVX2EKmVKNj
   vV/QZpZFyANROorlieyrka8yoXugH/zfxfBc9yPgnRX4HaIImbTpxh4pl
   SPZyWav/hiAG4zAJFRTbJNciXI6E+zC7vLVE4Ewa4oxxMNQB1DmGMb/hy
   NnZRFCW0QzS8I8PiGG7cLajYfVAQarEDp9Tdf29WKLpjIfefFdDv5sUNW
   u4ETIpHqmX53lqosTMTqGQx0av8k5iRjr6lkalWGhTVjN8ixPhDBojfHO
   mZbM45zKUj1Ik+QK+xnzvpNDyax34VvDHYjpldhFeZQ9GSrSfZnBNcr91
   w==;
X-CSE-ConnectionGUID: FL7kdB05R2u3NY0gOXPXww==
X-CSE-MsgGUID: zlhvcsjeQrmRKkNffwbQ/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2871348"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2871348"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 04:49:53 -0800
X-CSE-ConnectionGUID: 2t2lcfLIQfySvESOf0ttSg==
X-CSE-MsgGUID: IEix6h1hS5W/q84QV62MXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7312026"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 04:49:53 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 04:49:51 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 6 Nov 2026 04:49:51 -0800
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.67) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 6 Nov 2026 04:49:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zxn/XUX4fCv19mX3hSJwcYRnqxEy7VtMfP+AUQ2o954+xjC5F3LStlG8oQ97A00177LOlpg1pLSRTL4AZPNflREjhJpXZxwx42HrQJwxBd2Nq2z6A+xhe81ZV87Y8kR1+TImCpB1AX0Tnnpznag912vtaspjn6cBAvdrcsB0Ox4qv6iUSgH1O6pJM2w8/wcgPOC4V0szsjD8T8XNCoDXJqSOSUOoupbvagHdHKxwwAvfkdMCClYuTMuVrdJ/HH2hk9y81iDy+bqbXZM6XUWQ0/ZePpHWVA0DEyFHpj0kJGy/WC1W3qU/lPtPZ94b+KuTBT8x4ePSRLW5InnSepUjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z86eYFUM+MfHmijJX10hjtxcwOL8ZqDJ7iXkmhu3Nb4=;
 b=QoHWMewmBnnMSg61TPR+dBbSJM2godZZD1wL4bwQnft1hwCZfNifZ79MAiLYGKp2j6o07BIlAaqOxqjzWmKG171hFAbEmVnSwccBYOpgQG66cZYn2M508Mzrpd5oeN0qSclag6jxnm6nVzzVxzRYL7skgV1VoinXH7kznC2MsJqdMcoCKreWEi+wfnh/wJVPWvmyZ5Yu3eMo4crZuwVBfk8oGuRNZcfUsLldA5DIlJbC4Sl5hDGdVxQl80yNAvlRqjGTrcv45n30GoPPbSsGp3PS961gkzAFJ+UShqffSrOkwh6KF6BTL8MjEfbf4NMHA6ei2n460eIxYCcGSpCtKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by IA1PR11MB6321.namprd11.prod.outlook.com
 (2603:10b6:208:38b::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.10; Fri, 6 Nov
 2026 12:49:44 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0592.010; Fri, 6 Nov 2026
 12:49:44 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, Jason Gunthorpe
	<jgg@nvidia.com>
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
	<mark.rutland@arm.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Topic: [RFC PATCH v1 10/11] virt: coco: arm-cca-host: Publish slot zero
 and establish streams after acceptance
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIAEQ8OAgABIWNA=
Date: Fri, 6 Nov 2026 12:49:43 +0000
Message-ID: <DS4PPFA84FA90FC3969F2B8388087CDDF67E7762@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com> <yq5ay0b6pdu6.fsf@kernel.org>
In-Reply-To: <yq5ay0b6pdu6.fsf@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|IA1PR11MB6321:EE_
x-ms-office365-filtering-correlation-id: 93f23918-cecf-484a-db2c-08df3c046e60
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|7416014|376014|366016|10070799003|1800799024|6133799003|18002099003|22082099003|3023799007|38070700021|261021135927099003|4143699003|10067099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|11063799006|56012099006|261022105027099003|261021121427099003;
x-microsoft-antispam-message-info: BlgT2LYA8XxmLYv5cLWNuBKTbyVk5qPg576BAz+W6YxDJRnuBrANv2HqauQ/epcYn6pbnin0ktj1k8+RWFRUoFiK+9lXegoNe3ZQ2Ja8mH4Yb2+Q68NtYXURlyRfaiTNBaNE3hPyuGjvA2czIRq9ZqAdOQJoSeSBcEL3tf9YcqmJfk+pVIZN0UpudLqoX7FWpJwoE34ydeZE1pvcp9DsvY+2/x41xl4ZVrjzGBQmh9x2vVYa46Yb0vmzTmWHiW91+paLhBU0yFGU1ctmUqBw58Jwz3u08TlwHhk1YJoz1r22PGjnYjWUsVlNpWDZeCiPzs5JDN3hygObHWtIxo/+THJsrkb1fAG5+zWpjDuvDHWSKXTdYqHCYBSL/PISg41hLQuAEH1ebmJyQUbcOHf0Mj/A6HUO4xFqEpm57wA/7QixB3xeMyZAFDsZjpLLIDYp7IyOzC1vByYhr/SsYyUf7SZ4dL9EVQiyt8WqqJ3woDHn6Ibx5PognwMeO1vUVZTC+pZOtaVYfItR11PSEMc8h9KGFxTDCVmttp1XNR1dsKzNKCRV9ko26zBsWbIKrYPV/19duz7i0/XG4UvcOWwJ0NUkbW/JIXBBajTtw8XANByugOgwL43Bzie/HdhfBDqOc+r5fiqxZrmi7pZHN22V4Wqt6G7Tr7SkM8SJYUXmdS/IOOpEUuwZhv9ISgQGB0J0XlnbGX3hwIvzOQT++7V9iRR7SduLq64p9J1JlWrhgA8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(376014)(366016)(10070799003)(1800799024)(6133799003)(18002099003)(22082099003)(3023799007)(38070700021)(261021135927099003)(4143699003)(10067099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(11063799006)(56012099006)(261022105027099003)(261021121427099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHAraFU3M0ZUd2UxNzU4T2RaeWJHcUtFV0trc2IwbzFtOUxnZnJVclhUdis3?=
 =?utf-8?B?YzlIeGhoZk4zRzdEK3B5ZVlrVDVNNmVoTm1vOXhFMGVEbFFCSHRJQVJPeUov?=
 =?utf-8?B?MlR0bmhtbWRsdzVXaUNLeHljckQ1eDBEK1dYeGZjaXYyR2FlRWVXK3JwY3NH?=
 =?utf-8?B?WmRtMnBITDY4dTFGczVHaE41clRsNURLSzFHZ0xGTXNNSjd3aXBMSnB1Z3dJ?=
 =?utf-8?B?NjE2U0U1NDJtMUVYRHZQbmd6eTFMZEdNSktZaWQyQ1pWRDBHNGpkZm9RYVpW?=
 =?utf-8?B?ZDNkVTIrckNDSzVqZ1N4WHJuaDl5cXhNUitnOTBSYWpYSzk1dnIxbEU2bGQ0?=
 =?utf-8?B?a0RxS3gxTnVpcldNYkRhMGZkMWpKVUlxZjJwejlQNGhqUnNaVjlzbVBoK2ZX?=
 =?utf-8?B?TWI3bGU1SnVsbWNtK2ZIVTNUdHpxbWMzVWJOWVk5ZS9PUm1Jc0JXdTZnL3Y4?=
 =?utf-8?B?SmNkbzBEeVZCZmNPdkordUIrdTRqbXJoTWNHV3pQaVZVUU5mTGQ5akR1OXlN?=
 =?utf-8?B?am41UXE5ZDZISk0rOGZTK0JGaTBTdEdFazlKNWw3Um9yMTdlZFdjbGVmSmdG?=
 =?utf-8?B?cFdBY205bGVDM3BjMVNMR3YwcXNqbW1HcUpCeElOd2NCMjJ2cStscTl1WkQ3?=
 =?utf-8?B?dTVNcGRDV3laQmlZSm5yYWdQQW43bW9lTyt0cmU5b0dmVmhPTmlOcHhFaThB?=
 =?utf-8?B?TVoxaENybTYwSjdJWWVCTDNLeXhNekxIZk1ZU2lva1NFdWt4MUpvMEgvS2ZO?=
 =?utf-8?B?bzErMEV6VWVZT0JMY3NxRUJoTkttRkhXSS8yT3gwTktQRlVJS2l5eE9kK2pn?=
 =?utf-8?B?dFNhYXgvUUtGWHJjby9mR3gwSFZ2aVRyMFo3T3hBL1YwUWRJQzhtdnM3ZHlm?=
 =?utf-8?B?dlhENi95bGRib21yWGZFdktEUFlSYWpBUDhRRFdUUFhlMXA2dTk4WHBZQ25z?=
 =?utf-8?B?OUZERFh4VkRSc1BJSHExakx6NytYdHdkUkYzYXVtcTdnRFVsaDMrWi83NjNi?=
 =?utf-8?B?RHUzZHBRQmExRzhXemF4azhWVTZCUTh0b1duRmt3QmdOSDZrYVAwcXZWbk8y?=
 =?utf-8?B?dFdkT3diVDZ0MnRUUWJjTmlZVEJRSjlJZDdhTDhYWkU0bWNyM2dkVHRQU3VE?=
 =?utf-8?B?TWkzWW9HZ3NIWDErMzRvdnJGLzZMS2w5bkQxd3VQN0dwaTlSSEpBaDdEREU5?=
 =?utf-8?B?RHgzd0dsSzFjTEI3YXg3S3VDbkFjcjM0OXFsbGtiOXA0NHc4VFhNdzVnY1Iv?=
 =?utf-8?B?VlIzWEtGUHNhMVZnN01DZ3hDd1RKdVJOME81eElVNllsRW5hbFRUVXV5K052?=
 =?utf-8?B?MXZzbTNTUXFzVVR1d21qL1NNRXdGa2drc0x4dWs4SENGUDVYY2VZM2U4OHdQ?=
 =?utf-8?B?Zmd5TG81eG9YSW13YXkzRTlGQ0VPQ1NhdExmQ1RqLzNqWUlpWkdnSE5WRTFQ?=
 =?utf-8?B?cVRXS0pxVTA0eFdmNE5TQjQ0bkxyRG5JOTZETjRaT0FhbUViRFNNM1BkVllD?=
 =?utf-8?B?R3RieXNCbW0zdkcxcWFGNGx5MkJhaUMxNElPNGJydlpSTkUza2JrbGQyUGds?=
 =?utf-8?B?ZlhUdlVnemc4RlgyRXdsbGZyN0RaQUtBMElac05WYm0xMHFVbWlFTkpybzRi?=
 =?utf-8?B?MUNDdVZlV1cxODBTdXFINDVMRGcwZm5CcDROUFNxWkxObVRYU3BBUGc0ZjIz?=
 =?utf-8?B?ZnNDNDB5M0RJeGZseXRDN0hONGlVRVZsd0dIMUlrMmdkeExRckx3d25rNDQ0?=
 =?utf-8?B?VkNwMnFpUE5qNjFnaWY3ZWtjSlpjbDdhanY5SmE3N0dCWHB3M201Rkh1WEtZ?=
 =?utf-8?B?MlQraitOeHJsNDF3bHF0L0JacjdpWjZGZWFUcktPMjl2UG9iTDRTdDJ5Q3Zk?=
 =?utf-8?B?ZXErejFqTk1NVGJQNXBJS3hSVnBhUUM5SWUvZml4NzFsMHMralBDc2pSb0s5?=
 =?utf-8?B?N2lzYXRtSmZUZnE2M2xiclFEaktaRWV5N3ZtYTkxUHFYSEw4SEVBWGNlNTVj?=
 =?utf-8?B?SXFpYlFJdGYxUVEzR2dBczg0UWtXRDJjaXozUHgyRWgybzlla1ZzaXZkbXgr?=
 =?utf-8?B?K0RxeVBNWllYVkhrRHpBbTV0YTBjbjgwMjVsblVXZFlndGJubWhSSXoyTDJV?=
 =?utf-8?B?VnhrVlRWVHlHM3BnZmZ2MUIzeVluZnM1eEdnSklEbFgxYjYzMXl5WXZESm1Q?=
 =?utf-8?B?M2dibVptSG1hUWM1NTZtamNDUWNGUmlyR1lrbUVPYWs3SUhad0twVDRDTDJB?=
 =?utf-8?B?Vm1TMnc0MEJLZzVWTmk5dDZtQlIzTVNJOExYdFRNeUllZjFHeFI0bkgxZnZp?=
 =?utf-8?B?dUxDNEczajQvNGV1Z2hsZ2w2MlVNck1hcExibGQxQmNQNjU0ZmtwRTZCSFJm?=
 =?utf-8?Q?izWl8gEC6sTFlxf3Yf3wc4AHvQcXTtCndi8S3rdEsjfhZ?=
x-ms-exchange-antispam-messagedata-1: Ax9lqISwYxeVjg==
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
X-Exchange-RoutingPolicyChecked: Z4PZH8NKLQDys3fPtml/HF3Sc4JEeAVTAasnJp3DkVD16axBIyKoAnWIp6Jje2+q0FZG68Jn3Eccf1NXZwaxUQNrfLQ7d0l2UwAW5NoIWYDtbQCN6wwbU/xjQovwCKkmV3+EmvsyVNIltTX7gUBeRB7zWjl9PqtKbYMcWUu0FFTHoY4lzKuAXNsDNuFJT/RUQsrLdloiKA45qv8/h+RnXWmUol5BtFc6fgV3Hr+Gd8tKPt1W71doTcmv2dxgMGoRZd8/UsB92vb1WHtw17797E5lglHsiiOSHzmBY1eMsgtXEON5rmdJVf8sJrllWmcJ7T43vh9VLmZBMzcvCH7OJg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93f23918-cecf-484a-db2c-08df3c046e60
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2026 12:49:43.8948
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rgkMzChl4j3z6Tc1EXr3tFJqxeHN/GiDgdT/4Q6TuIWZIcGVL6/hsiREt1vGyf6/pBP64KKajhC5twbut+q11yGfwszVIbyrpWqapHXVNKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6321
X-OriginatorOrg: intel.com

PiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPiB3cml0ZXM6DQo+IA0KPiA+IE9uIFR1
ZSwgTm92IDAzLCAyMDI2IGF0IDEyOjAxOjQzUE0gKzAwMDAsIFJlc2hldG92YSwgRWxlbmEgd3Jv
dGU6DQo+ID4NCj4gPiBXZSB3aWxsIG5lZWQgc29tZSBtdWx0aS1zdGVwIHNlcXVlbmNlIGZyb20g
dGhlIHVBQkkgcGVyc3BlY3RpdmU6DQo+ID4NCj4gPiAxKSBDVExWIGNvbW1hbmQgU1RBUlQgQ09O
TkVDVDoNCj4gPiAgICAgVFNNIGRvZXM6DQo+ID4gICAgICBHRVRfVkVSU0lPTiAvIFZFUlNJT04g
ICAgICAgICAgICAgICAgICAgICAgICAgIChWQ0E6IFZlcnNpb24pDQo+ID4gICAgICBHRVRfQ0FQ
QUJJTElUSUVTIC8gQ0FQQUJJTElUSUVTICAgICAgICAgICAgICAgIChWQ0E6IENhcGFiaWxpdGll
cykNCj4gPiAgICAgIE5FR09USUFURV9BTEdPUklUSE1TIC8gQUxHT1JJVEhNUyAgICAgICAgICAg
ICAgKFZDQTogQWxnb3JpdGhtcykNCj4gPiAgICAgIEdFVF9ESUdFU1RTIC8gRElHRVNUUw0KPiA+
DQo+ID4gMikgQ1RMViBjb21tYW5kczoNCj4gPiAgICAgcXVlcnkgY2VydGlmaWNhdGVzLiBUU00g
d2lsbCBpc3N1ZSBvbiBkZW1hbmQ6DQo+ID4gICAgICBHRVRfQ0VSVElGSUNBVEUgLyBDRVJUSUZJ
Q0FURSAgICAgICAgICAgICAgICAgIChldmVyeSBzbG90IGluIHRoZSBzbG90IG1hc2ssIGFsbA0K
PiBjaHVua3MpDQo+ID4gICAgIHF1ZXJ5IFZDQSBpdGVtcw0KPiA+DQo+ID4gMykgQ1RMViBjb21t
YW5kczoNCj4gPiAgICBGSU5JU0ggQ09OTkVDVCB3aXRoIHNsb3Q6DQo+ID4gICAgIFRTTSBmb3Ig
MS4yIGRvZXM6DQo+ID4gICAgICBDSEFMTEVOR0Uoc2xvdCAwLCBmcmVzaCBub25jZSkgLyBDSEFM
TEVOR0VfQVVUSA0KPiA+ICAgICAgS0VZX0VYQ0hBTkdFKHNsb3QgUykgLyBLRVlfRVhDSEFOR0Vf
UlNQICAgICAgIChjbGVhciB0ZXh0KQ0KPiA+ICAgICAgRklOSVNIIC8gRklOSVNIX1JTUCAgICAg
ICAgICAgICAgICAgICAgICAgICAgIChpbiBzZXNzaW9uLCBvcGFxdWUgdG8gaG9zdCkNCj4gPiAg
ICAgT3IgZm9yIDEuMyBtdWx0aS1rZXkgZG9lczoNCj4gPiAgICAgIEtFWV9FWENIQU5HRShzbG90
IFMpIC8gS0VZX0VYQ0hBTkdFX1JTUCAgICAgICAobm93IGluY2x1ZGVzIERJR0VTVFMNCj4gYW5k
IENFUlRJRklDQVRFKQ0KPiA+ICAgICAgRklOSVNIIC8gRklOSVNIX1JTUCAgICAgICAgICAgICAg
ICAgICAgICAgICAgIChpbiBzZXNzaW9uLCBvcGFxdWUgdG8gaG9zdCkNCj4gPg0KPiANCj4gDQo+
IERvZXMgdGhpcyBzcGxpdCByZXF1aXJlIHVzIHRvIGd1YXJhbnRlZSB0aGF0IG5vIEdFVF9WRVJT
SU9OIGNhbiBiZQ0KPiBpc3N1ZWQgaW4gYmV0d2Vlbj8gDQoNClllcywgaW4gbXkgb3BpbmlvbiBU
U00gbXVzdCBlbmZvcmNlIGl0IGJlY2F1c2UgYXMgeW91IHNhaWQsIEdFVF9WRVJTSU9ODQpyZXNl
dHMgZXZlcnl0aGluZy4gDQoNCkFub3RoZXIgR0VUX1ZFUlNJT04gaW4gdGhlIHNhbWUgcmVxdWVz
dGVyIGNvbnRleHQNCj4gYmV0d2VlbiBTVEFSVCBDT05ORUNUIGFuZCBGSU5JU0ggQ09OTkVDVCB3
b3VsZCByZXNldCB0aGUgcmVzcG9uZGVyJ3MNCj4gbmVnb3RpYXRlZCBzdGF0ZSBhbmQgdHJhbnNj
cmlwdCwgcmlnaHQ/DQo+IA0KPiBJZiBzbywgY2FuIHdlIGF2b2lkIHRoaXMgc3BsaXQgYW5kIGFs
d2F5cyB1c2UgUnVzdFNQRE0sIHdpdGggb3Igd2l0aG91dA0KPiBtdWx0aS1rZXkgc3VwcG9ydD8N
Cj4gDQo+IFNvbWV0aGluZyBsaWtlOg0KPiBLYzogcHVibGljIGtleSB1c2VkIHRvIHZlcmlmeSBD
SEFMTEVOR0VfQVVUSCBmcm9tIHNsb3QgQy4NCj4gS3M6IHB1YmxpYyBrZXkgc2VsZWN0ZWQgZm9y
IHNlc3Npb24gZXN0YWJsaXNobWVudCBieSB1c2VyIHVzaW5nIHNsb3QgUy4NCj4gQyBhbmQgUyBt
YXkgYmUgZGlmZmVyZW50IHNsb3RzLg0KPiANCj4gSG9zdCAvIFJ1c3RTUERNOg0KPiAgICAgVkNB
IC0+IEdFVF9ESUdFU1RTIC0+IGZldGNoIGNlcnRpZmljYXRlIGNoYWlucw0KPiAgICAgQ0hBTExF
TkdFKEMpIC0+IHJldGFpbiB0aGUgbWVzc2FnZXMgYW5kIENIQUxMRU5HRV9BVVRIIHNpZ25hdHVy
ZQ0KPiAgICAgU3RvcCBjb21tdW5pY2F0aW5nIHdpdGggdGhlIGRldmljZS4NCg0KR0VUX0RJR0VT
VFMgb25seSBnZXRzIHlvdSBkaWdlc3RzLCB5b3Ugc3RpbGwgbmVlZCBHRVRfQ0VSVElGSUNBVEVT
DQp0byBhY3R1YWxseSBmZXRjaCBjZXJ0cy4gDQoNCj4gDQo+IEhvc3QgLyB1c2Vyc3BhY2U6DQo+
ICAgICBFeGFtaW5lIHRoZSBkaXNjb3ZlcnkgcmVzdWx0cy4NCj4gICAgIFNlbGVjdCBzbG90IFMg
YW5kIHZhbGlkYXRlIGl0cyBjZXJ0aWZpY2F0ZSBjaGFpbi9rZXkgS3MuDQo+IA0KPiBIb3N0IC0+
IFJNTS9maXJtd2FyZToNCj4gICAgICAgICBTdXBwbHk6DQo+ICAgICAgICAgICAtIEMgYW5kIEtj
LCBTIGFuZCBLcw0KPiAgICAgICAgICAgLSBBbGdvcml0aG1zDQo+IA0KPiAgICAgRnJlc2ggR0VU
X1ZFUlNJT04gLT4gQ0FQQUJJTElUSUVTIC0+IEFMR09SSVRITVMNCg0KSG93IGRvIHlvdSBwcm9w
b3NlIHRvIGRlYWwgd2l0aCB0aGUgZmFjdCB0aGF0IGhlcmUgVFNNDQptYXkgYWdyZWUgd2l0aCBh
IGRldmljZSBvbiBkaWZmZXJlbnQgcGFyYW1zIHRoYW4gcnVzdFNQRE0NCmFib3ZlPyANCg0KDQo+
ICAgICBHRVRfRElHRVNUUyBpbW1lZGlhdGVseSBhZnRlciBWQ0ENCj4gICAgIEdFVF9DRVJUSUZJ
Q0FURShDKSwgR0VUX0NFUlRJRklDQVRFKFMpDQo+ICAgICBDaGVjayB0aGF0IEtjIGlzIHRoZSBs
ZWFmIHB1YmxpYyBrZXkgaW4gY2hhaW4gQy4gLy8gQ2FuIHRoZSBzbG90IG51bWJlciBjaGFuZ2UN
Cj4gYnkgbm93ID8NCg0KSW4gYWRkaXRpb24gdG8gVkNBIGluZmx1ZW5jaW5nIHRoZSBjb250ZW50
IG9mIHRoZSBzbG90cywgDQphIGRldmljZSBjb3VsZCBoYXZlIGEgRlcgdXBncmFkZSBpbiBiZXR3
ZWVuIHJ1c3RTUERNDQpzdGVwIGFuZCB0aGlzIHN0ZXAgYW5kIHRoaXMgY291bGQgY2hhbmdlIHRo
ZSBjb250ZW50IG9mDQp0aGUgc2xvdHMuIA0KQnV0IGlmIHlvdSBmdWxseSB2ZXJpZnkgdGhlIGFj
dHVhbCBjZXJ0IGNoYWluIGFuZCBrZXkgaXRzZWxmDQp5b3UgY2FuIHJlamVjdCBzdWNoIGNhc2Vz
LiBTbyB5b3VyIHdheSBpcyBhbHNvIGRvYWJsZSB3aXRoDQphZGRpdGlvbmFsIGNoZWNrcywgYnV0
IEkgYW0gd29ycmllZCBhYm91dCB0aGUgcHJvYmxlbSB0byANCmFncmVlIG9uIHRoZSBzYW1lIFZD
QS4NCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmENCg0KPiAgICAgLy8gRG8gd2UgbmVlZCBydXN0IHNw
ZG0gY2hhbGxlbmdlIGF1dGggcmVzcG9uc2UgaGVyZT8NCj4gDQo+IElzIGl0IHBvc3NpYmxlIHRv
IHZhbGlkYXRlIEtjIGFuZCBLcyBpbiB0aGUgc3RlcCBhYm92ZT8NCj4gDQo+IC1hbmVlc2gNCj4g
DQo+IA0KDQo=
