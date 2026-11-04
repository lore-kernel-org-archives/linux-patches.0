Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793783068;
	b=MzB7qEtBfGCcSpVfBDY+9rzfM7cn4uKFV6Mc+L0uu13L4uNp+Ulx+unX4hLMaiqFynV3
	 +95TBJ1It4GK9HqA9y91tf0+d8Y1oJm5RUcQ5MPCm8OvsHoezKEcOvSrPLjVGpfayc9SG
	 NUhuNyOfQdUi4oRORdcIksAUBvd1kVV3+6l3EY2SHSRftEdcLu+wdFUGo36diDWT9sfDT
	 dnXU/ELHZBBaP/ywSWhSoxmFxd6C/5VUXGLt5yIOqp6nWn0+J7nvpIZ+CWAN8wgGhRQq5
	 /YiV/G9vTb/KKbKIj1+mtq5O1kVE/Er8Qwve8nS2LZatJQv7tEtAWfjERN11miBZINw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793783068;
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
	bh=qV1NhXwjfcsCYsFNSu9K/JYObqVjkga5J3sfuc6wTTc=;
	b=z2f5+KOgfX780EtayvoaWTsNCe+GR9r3xhG9vsJf4hR47x71ERRRlnMmoW6OMUiXELbZ
	 4DoCr1nXK4upMuRfJ2g0HP/o+LTPCjHUgKG0begPhIgVg1tepyaETQ1CqM7hAHTAFzsvn
	 J1PCC3xEtwYc3iJI+QuZOc9Gk78FmXaRGiZmDExKL67YdHdJ/I2XVSQQE7dUbOJv7/5H4
	 ShFAZyhsuGgnZa4DFJVHK8urC0m8O71mEEY9uoe6EswbnsKTzOjdN0k7JK9rvL0tiRWU6
	 /9kXmNlALgbK/eXvRHNHUNdc3cd4WvRTYz6/axKjdhQtptN6hK/YAR24V0s7Bp7I6HQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="Yu7/glnV";
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.18
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73149606A326;
	Wed,  4 Nov 2026 09:04:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 73149606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Yu7/glnV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793783067; x=1825319067;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qV1NhXwjfcsCYsFNSu9K/JYObqVjkga5J3sfuc6wTTc=;
  b=Yu7/glnV6HRmfYRoC5vI8B2+XqIfc0wXsIqZs2mCMIcwpm2v4/j6ocjZ
   7+AnjqGU3GKUZYmEccO6ta0LSlPwG1zK8fdymuw8ZHNP7Y7KN4JhsmVS8
   g0XYi7b+5y2ptH9orBNRQQ2i0sFLHgyY3uZB4lyG1mZ65aeM9Fs8Y2Dp+
   UDEaZZKKIdJJ3LfMmtWSL2BBQf8MDzTQQeZms+qAU1WgIRGzAssIKOU/e
   xeTGxc1o5VAFpLiun5M6FgvB5A7gvL36AZ2mOq9b8OBK4GO3X9EhZ2dLU
   qqgAG8SP7Pd8NlWhrLp3RE1KhAKxCw3vIa8Ww0lueCI/MvWKWuiSe1gH3
   Q==;
X-CSE-ConnectionGUID: GjNlky/oRU28M7HAXpJOEw==
X-CSE-MsgGUID: dEj25un2SfWq+E7qMTw6Qw==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2565161"
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="2565161"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 01:04:26 -0800
X-CSE-ConnectionGUID: e5WlTXJUQWGhFOtaSy2B6g==
X-CSE-MsgGUID: tSSMSQUtR4CQ8lZ0h3W19A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,194,1787036400"; 
   d="scan'208";a="6822474"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2026 01:03:25 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 01:03:24 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Wed, 4 Nov 2026 01:03:24 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Wed, 4 Nov 2026 01:03:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VaZ9nYPG1a0Yjn/g+HHsrydi5VyOJCL/YHEcjTbSyim6GXE47S1b5INrVWWzv+fh4bm2jqs3pIFW8ydPUwGM1CEiBCcbVCrL3fFiSap7GsJfgpKZoA9TRI+KLYIIFIm41ebgNB7nMQyin4mgR4gIFu6SI9TRX/Wc+YXvbJ8CjC3uMqiy6uR0wINswZFV++z89aqXp9UeTDPKkNezsCQjmP8ysfH04WGeplN2LVlMCCMisuASKJkCMiWfEOJSiBCdCZ8wTUKDDZLeRxXhT+Hi09YIE2yzW8mPV1b7cJOcoqCBAJeYN34ZVvK6bmLvhaXn8eIuodkIssYKNE4RPzWOAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qV1NhXwjfcsCYsFNSu9K/JYObqVjkga5J3sfuc6wTTc=;
 b=qDUqt7EFThfh0CfWaFqlJ2PTTfWYZwrrmJMo3U0Me+moe9vWihLyGeAKa260Xh1Hyfw0k++hDCvFr9dDht2eKKXGeNO+UhTiJ5fcDCBahTHBA2KkyGJtBRlIwudVxKM4RCwzwN6SzepKd5QKeCM2l6ioUszyC5lEs/Kbj4R04g/jKuAD1FlFNLtD7IPyToLHOZ3R6jHIANL3Vo0v1NoCTCIwnt+YFv2UM2V43+7CLyugzdr5Gb/BNw6ut7Gkj8PhqBO4dT7loC6In/+jZxD54YJlV7NpQjIvugkxztuHNDs4lypBoWzEWKhiG/Zfc1wbLGZ2a30uQPnorxEGqtB/LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by IA3PR11MB824491.namprd11.prod.outlook.com
 (2603:10b6:208:626::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.592.8; Wed, 4 Nov 2026
 09:03:21 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0569.011; Wed, 4 Nov 2026
 09:03:20 +0000
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
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABJysA
Date: Wed, 4 Nov 2026 09:03:20 +0000
Message-ID: <DS4PPFA84FA90FC858A44B5D42AB80471B0E7682@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-11-aneesh.kumar@kernel.org>
 <26c24a66-be3d-40ac-8cb4-294deb0108db@intel.com>
 <20261029171053.GD3734323@nvidia.com>
 <DS4PPFA84FA90FC768B30DCFEBDE71F31CFE76D2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261030131543.GH3734323@nvidia.com> <yq5apkwqa5ve.fsf@kernel.org>
 <DS4PPFA84FA90FCEFB18E5620217FDCA728E76A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261102172640.GB274202@nvidia.com>
 <DS4PPFA84FA90FC31B41ECA1F6ACF6D0600E7692@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261103151643.GI274202@nvidia.com>
In-Reply-To: <20261103151643.GI274202@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|IA3PR11MB824491:EE_
x-ms-office365-filtering-correlation-id: 5168f290-b801-40f1-d6cb-08df3a52796d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|10070799003|7416014|376014|1800799024|366016|6133799003|10067099003|22082099003|18002099003|3023799007|38070700021|11063799006|56012099006|5023799004|4143699003|261026140227099003|261021121427099003|261102123227099003|261022075727099003|261022105027099003|261028144727099003|261026121527099003;
x-microsoft-antispam-message-info: 4BtucJuHrBP0urDkPKJh4nJiViiSb993CjzPtGzBqdAfgqhzf/giL0Y8fGkgGFy4nNCdqcwRl2+l81WUD1/pMbRkTOdnTlj/RpgniJ4Z45FJJIe314DHIISrSeNNgi76me+LNVGe4B85mMIzQtquJkMQJkzLkSZeSP1Y3xqFx9rMqEEXjs5UI00kRqHPH7dgH6cjJgx1SQODktGixXYhuuI9xzFhdioOz9xM4a5xUBWKR9iK4bTTn4s6NhOzbb9nGfu1g2Lyoon2R1sjupJgGrp/El9BusUjVFpKh6XFJKm5I8Bw/CA8NGYmiF0Nk5cq0/6bA+Hab00DjyRklaUv/EUagdw9LU8N6w1g9EfWSrm/izz0vofbC+tUuIm1LiVdOFuiDaMHyvp12c7IIxZ3IyGKk3ASyEZpWuoD25QYG9ACd4Z6jy+os+H0F2ofSfWGsppBNs3SjGsZxfyGKNz77OGAuDJXIaJCzKSFCNPBiZJjK2F2vxKApv3+92lOnRKeNh3lF3JQg5T1pGO1nArPSO5Pg3Gu3Oa0nSZ2e7wMom5KwIwuQb6+5v5kS+nKPt/LzLueJPX1RPqPHn1+jSCFXgcC0xzATc2srAQEwiyP4VnLBDfu8z7Ufbne1iw5dKJIyH3eY5Mi32dSpS5g3dgOpiyj50MVCbpsmLkClgIrwNcbUj3AgY23PAija9YD4CM05uSap3M4VXcRsSP/1WDHWSb2h9bIMWGFhLezahfHI9k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(10070799003)(7416014)(376014)(1800799024)(366016)(6133799003)(10067099003)(22082099003)(18002099003)(3023799007)(38070700021)(11063799006)(56012099006)(5023799004)(4143699003)(261026140227099003)(261021121427099003)(261102123227099003)(261022075727099003)(261022105027099003)(261028144727099003)(261026121527099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTl1WVNSelpvTkd3bkpCcmZ4eEhUdWtZU2dYNEdLWGtDVjNoWGtRdjh0Ymxv?=
 =?utf-8?B?b0V3T2NFa3lxeDBUWWFnZGI0c0VGSFlvaG00SVpseDRNb2J2eEpNaXBPa09S?=
 =?utf-8?B?QnJuSU5WS2xFZXNQWUNSZnlQL3B0MU5RSmpEaktLNGtvRlhwa1V6OGZ5bkVI?=
 =?utf-8?B?T09za1N2VENtVFkydkpSY29yY2k0RThCVHcxd25UQmNJVERTaXRjUVpFTjJy?=
 =?utf-8?B?Mkx1aDFveGlobXh2WGk0VWN3Ym50YzNTWUxFMjRmYlQ0QmlJWCsrV0N3ZmVD?=
 =?utf-8?B?bGJTS2J3Uk1lZWpnSFpjdVZaT1lEaEtqT0plRnlrejRURFJRczlDNzNjenJu?=
 =?utf-8?B?eEpSbTFIejRERVU1NE5TaUNpSnhnTytCVHV3UE1qK3RGbVFTNnVJVGdrZ0hZ?=
 =?utf-8?B?VXZpelpSRHliMUZFdlB0K0VtbG5qU2pySUR0Nmd4WDNPK0ZSWk1tSWV0aEpm?=
 =?utf-8?B?ekJ6UVI3OE50cnNXUDFzblZpQ0h4S0xDbnVkQVlBaWZUb3dKdFQyY0UvaFYz?=
 =?utf-8?B?dUpnTzhHc3J3RzBGWXN1OTZQR0puWklVSjVvN0taSG5VL2VDd1ZDaG80Sm0w?=
 =?utf-8?B?ZmxXNlZ2Q2p5OUJ4MHdwMVdUeUdJKzNZVy8rbWhzcnZwb2czTm55S0xHamNl?=
 =?utf-8?B?dzIyOHRyNFdnRE91V1AweCtSRUxnQlVqWXhkSXhVdGNoVmRaOEo0Q1lTK3BI?=
 =?utf-8?B?eDNvOG1LTndoYnFwWG1PV2g1RlROYitKRk1rYVg3UnJuaThuQ3VudDYzOXNx?=
 =?utf-8?B?dUJiLzJnalI3T00xdy9GSHQ5M2VhY3VoeE94cVpTSHlEYUREZXN3c1VJeHM1?=
 =?utf-8?B?SDZKNzFrZkxreUk3RXFTT1VYTVhGMlZtRk9rdXdhbEVqcW9GM2NGbmpteE4w?=
 =?utf-8?B?em51VzlxeUpIcGZueHFnN0lpQlo0a3N0Slp6Y2cwcnVuWXJmcDNWNmFSZ09k?=
 =?utf-8?B?K0VOZ3g0VEFMQVdRNnZRUTBHOE5FOFJRdGhFOHlBQ1VHcm5oSmtJOHVqRjBH?=
 =?utf-8?B?MEoxUGtxZmhCUSszaVFxV252K3NmWHRzaEtkNk1aTWNWRjVhcC8yQU8yM0lF?=
 =?utf-8?B?QWt0U0Z0Y2krVGxiUE53MjdFejBYUFBXVlFoamhOcjYxRFh6OEFjN25HZ1Uw?=
 =?utf-8?B?QlEwQVRVMzN3RXVrS0NJSEFUaWxsbkFaTE84S0dEbHZBTHAxQnFiQXZPSDlv?=
 =?utf-8?B?T2ZYV3BaVFVrY28vSzFpeGZTODFMZGplblRWTm1MVVFkMDJoZnZEbEUwbkd0?=
 =?utf-8?B?NFhSa0hMU2NBMXNJcFN4WGQvK1VmRmlOSExUNHJYK3hEY2pNcExCRmVUVnZZ?=
 =?utf-8?B?MlpNRkhuYmNTMUZVWEVhNnJDZTlDSVdDMzM0UnMxK3JBUWZwRlZyL3FQc0xo?=
 =?utf-8?B?aW1WbWUzTFJJYktGZTdCUXpIa0xqV2J5UklyZWRHMjhWdFI3TjIrdlNaZm1v?=
 =?utf-8?B?bGJPNFJkWUpqWEF6K2NsWWk2ZEErTTcvREs5N2RRWmlvUkZtbDhXL2V5bVlH?=
 =?utf-8?B?N09VMzdZd0VCWXF0Rmcxd0RKRS9STGpaUW9Wa2RMUkhtMTh0RlRIakVIWDZD?=
 =?utf-8?B?R2ZRVmlLZXg0RnFYL0F2ZXFPWjU0RFNPK0FTVUdydkhjU0s5dGR5bE95TTV0?=
 =?utf-8?B?ZFhDU2tzTk9HQmhaQTFsaHI0ZDY5eHhHam1YQ3haZkFFTnJ0RUNhMXU0d0ln?=
 =?utf-8?B?ZnhSNTdWOEhxczhXb2lBVGpacTRnbyt2U1hSVEthOExZY2hDUm1BZTl5VERH?=
 =?utf-8?B?Q2kyUTkxK21tYXUyM3lsWjVnZWkyTVRvYTBKNUQ5S0VLRUhicHcxZzI2RjZq?=
 =?utf-8?B?OGp4Tks2OU8zTjFzNXJ6czEzeGZyVklUYStHS0FlVk02VjRHcUZNbm9XZEQ5?=
 =?utf-8?B?VGhGdDcwSTJBTHRscUlFaWNoZEdUYzZQdWV5SDFHQkJuenhUQ2xuZ3RlZ01t?=
 =?utf-8?B?MlBmTE8zeTluaTFOTTJOcmJZc1pMbGVPL2ZDaFIyRHQvYnZKb1BZaDU0V3cv?=
 =?utf-8?B?TnF6aWk0MjhWdUtpOTZXMnZBMzlOc0FBazdMb2ErbjdvVTEvRnU1QTFvNHVG?=
 =?utf-8?B?a2ZuRjZxcmp4c3V5T0tabmV6OGk5QjRNdTg1bmlsY04wTUxuRmM2RnpYMmdm?=
 =?utf-8?B?enZ1cUFkWjlqWENoRDRCSlQwNFRjSFNONmtaNHdSMVBGQlJjVDVyL09hcHlz?=
 =?utf-8?B?ZFVkVDdoNzd4bURRQzZVdWV1RXJlb2ZacVRVOWVoczNFNGt6MkVJRHpsbWdY?=
 =?utf-8?B?L251L3VKeHhnOHVuR28va0drTTFmcDhXZG4zUXV1a0kyZnNSMVI3M1FOdFdR?=
 =?utf-8?B?bzhzQll5bmxmYlhHZnFmNkxSNVB3WnZiYk1tMVJwazdBQ1J0YjZralpwdGoz?=
 =?utf-8?Q?aG5ryW2hOujFtAgA3y6i0OIH4+m0+T8O4W5EhxGruOjjo?=
x-ms-exchange-antispam-messagedata-1: YLJysa019ltbIA==
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
X-Exchange-RoutingPolicyChecked: W5OS2z89HCZxmZq9bkInynTd0C7lYWAafXwgu1FWwmbwyxSFryLSlmQ+XDEE2RTZZR9mgn1wk/lb2uUz3eoXkGS/oUq0DjiO+HKl3BvElvvS2icvYS5u3XIsyvPVK0Y6P+8SjH3mPcMBlC9Sp+jFSVYb0CwIc6LUDlZCrd3SKF8UOCJtsa7ovH8/XJSRiujOXJvk2WOq3jqWNGW4XDXeBfLYH+BZiLnYbisq3s0nL3sERK+bdxb8cMUnMUqcaNfFwwfph8rwWxCTFceCHKPHbrSrE4EQb4NKNF1DMHLiiXBy/sQUMwGxM44n7Lk2MeRR7J5ElngnQ572fwWlk4/8sQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5168f290-b801-40f1-d6cb-08df3a52796d
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2026 09:03:20.5568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /qu7YozOK6/hAr+l36uKGRzV7ihn153dw+m/tnrhz+lGRWolpFDd1OVoSqmCM5TcW4jeteg+1u3zDKWFQ6L2b16bg28Ljnm4fPir1V9Mog4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB824491
X-OriginatorOrg: intel.com

c25pcCANCg0KPiA+IFRoZSBmbG93IHJlYWxseSBiZWNvbWVzIGFzOg0KPiA+DQo+ID4gMSkgRG8g
dmlhIFJ1c3RTUERNOg0KPiA+IEdFVF9DRVJUSUZJQ0FURSAvIENFUlRJRklDQVRFDQo+ID4gMikg
VXNlcnNwYWNlIHNlbGVjdHMgc2xvdHMNCj4gPiAzKSBUU00gbW9kdWxlIGRvZXMgc3RhcnR1cA0K
PiA+IDQpIFZlcmlmeSB0aGUgY2VydCBjaGFpbiBvZiBwdWJsaWMga2V5IHVzZWQgZm9yIFNQRE0g
c2Vzc2lvbiBlc3RhYmxpc2htZW50DQo+ID4gdG8gZGV0ZXJtaW5lIGlmIHRoZSBrZXkgaXMgdHJ1
c3RlZA0KPiA+DQo+ID4gRm9yIHRoaXMgVFNNIG11c3QgZXhwb3NlIGluIGEgdHJ1c3RlZCB3YXkg
dGhlIGZ1bGwgY2VydCBjaGFpbiBhbmQgcHViIGtleQ0KPiA+IHVzZWQgZm9yIFNQRE0gc2Vzc2lv
biBlc3RhYmxpc2htZW50IG9yIG9ubHkgYSBmdWxsIGNlcnQgY2hhaW4gYW5kIGd1YXJhbnRlZQ0K
PiA+IHRoYXQgdGhlIHB1YiBrZXkgb24gbGVmdCBjZXJ0IGNoYWluIHdhcyB1c2VkIGZvciBzZXNz
aW9uIGVzdGFibGlzaG1lbnQuDQo+ID4gVGhpcyBpcyBkb2FibGUgZm9yIFRTTS4NCj4gDQo+IFRo
ZXJlIGlzIG5vIHNpZ25hdHVyZSBjb3ZlcmluZyB0aGUgc2xvdHMgaW4gdGhpcyBjYXNlLiBVc2Vy
c3BhY2UNCj4gdGVzdGVkIHRoZW0gYmxpbmQgd2l0aG91dCBrbm93aW5nIHRoZXkgYXJlIGFjdHVh
bGx5IGluIHRoZSBkZXZpY2UuIEl0DQo+IGlzIG5vdCBpZGVhbC4NCg0KQWN0dWFsbHkgeW91IGFy
ZSByaWdodCwgSSByZS1yZWFkIFNQRE0gMS4yIG5vdyBhbmQgcmVhbGl6ZWQgdGhhdCBJIGZvcmdv
dA0KdGhhdCB0aGUgZmluYWwga2V5IGV4Y2hhbmdlIHNpZ25hdHVyZSAqb25seSogY292ZXJzIHRo
ZSBjaGFpbiBzZWxlY3RlZCBmb3INCnRoZSBhdXRoZW50aWNhdGlvbiBhbmQgbm90IHRoZSB3aG9s
ZSBtZXNzYWdlIGV4Y2hhbmdlIChpbmNsdWRpbmcgR0VUX0NFUlRJRklDQVRFUykuDQpJIGhhdmUg
YmVlbiB0ZWFjaGluZyBwZW9wbGUgc2VjdXJlIGRlc2lnbiBvZiBjcnlwdG8gcHJvdG9jb2xzIGZv
ciBxdWl0ZSBhIHdoaWxlDQppbiBwYXN0IGFuZCB1c3VhbGx5IHRha2UgaXQgZm9yIGdyYW50ZWQg
dGhhdCBhbnkgZmluYWwgdHJhbnNjcmlwdCBtdXN0IGNvdmVyDQoqYWxsKiBleGNoYW5nZWQgbWVz
c2FnZXMgd2l0aGluIEFLRSAodGhpcyBpcyBxdWl0ZSBiYXNpYyBzZWN1cml0eSBwcmluY2lwbGUN
CnRoYXQgcGVvcGxlIHVzdWFsbHkgdHJ5IHRvIGZvbGxvdy4uICkuIE5vdCBzdXJlIHdoeSBTUERN
IDEuMiBkaWQgaXQgZGlmZmVyZW50bHkuDQpUaGF0IHNhaWQsIEkgdW5kZXJzdGFuZCBub3cgeW91
ciBwb2ludHMuIA0KDQo+ID4gSSBhbSBub3QgdmVyeSBmYW1pbGlhciB3aXRoIFJNTSwgYnV0IGlm
IHlvdSBkbyB0aGluZ3Mgd2l0aGluIGEgc2luZ2xlDQo+ID4gU1BETSBzZXNzaW9uIChqdXN0IHN0
b3BwaW5nIGFmdGVyIHlvdSBoYXZlIGZldGNoZWQgdGhlIGNlcnRzIGZyb20gYWxsIHNsb3RzDQo+
ID4gYW5kIHBhc3NlZCBpdCB0byB1c2Vyc3BhY2UgdG8gc2VsZWN0IHRoZSBrZXkvc2xvdCksIHRo
ZW4geW91IGRvbnQgbmVlZCB0bw0KPiA+IGNvbXBsaWNhdGUgbWF0dGVycyBieSBpbmNsdWRpbmcg
R0VUX0RJR0VTVFMvQ0hBTExFTkdFLg0KPiANCj4gVGhlIHB1cnBvc2Ugb2YgQ0hBTExFTkdFIGlz
IHRvIGF1dGhlbnRpY2F0ZSB0aGUgY2VydGlmaWNhdGVzIHRvDQo+IHByZXZlbnQgYW55IE1JTSBm
cm9tIHRhbXBlcmluZyB0aGVtLiBJdCBpcyBjaGVhcCBhbmQgY2xvc2VzIHRoaXMgaG9sZSwNCj4g
SSB3b3VsZCBkZWZpbmF0ZWx5IGV4cGVjdCBpdC4NCg0KQWdyZWUgbm93IGdpdmVuIHRoYXQgR0VU
X0NFUlRJRklDQVRFUyBhcmUgbm90IGF1dGhlbnRpY2F0ZWQuIA0KDQo+IA0KPiA+IFRTTSBpbiB0
aGlzIGNhc2UganVzdCBtdXN0IGVuc3VyZSB0aGF0IFNQRE0gc2Vzc2lvbiBlc3RhYmxpc2htZW50
DQo+ID4gaGFzIGhhcHBlbmVkIHVzaW5nIHRoZSBrZXkgY29ycmVzcG9uZGluZyB0byBzZWxlY3Rl
ZCBzbG90LiBUU00gY2FuDQo+ID4gZG8gdGhpbmdzIGxpa2UgdGhpcyBiZWNhdXNlIGl0IGhhcyB0
aGUgZmluYWwgU1BETSB0cmFuc2NyaXB0IGFzDQo+ID4gcmVzdWx0IG9mIHNlc3Npb24gZXN0YWJs
aXNobWVudCBhbmQgY2FuIHZlcmlmeSBpdCBieSBpdHNlbGYuDQo+IA0KPiBBdCBsZWFzdCBpbiB0
aGUgUk1NIGZsb3cgdGhlIE9TIHByb3ZpZGVzIHRoZSBQVUJLRVkgdG8gdGhlIFJNTSBzbyB0aGlz
DQo+IGlzIG5ldmVyIGluIGFueSBkb3VidC4gSSBhZ3JlZSB0aGF0IHRoZSBUU00gaW1wbGVtZW50
YXRpb24gaGFzIHRvDQo+IHByb3ZpZGUgdGhlIHByb3BlcnR5IHRoYXQgdGhlIFBVQktFWSdzIHNp
Z25hdHVyZSBpcyBjaGVja2VkIGR1cmluZw0KPiBLRVlfRVhDSEFOR0UgYW5kIHRoZSBPUyBtdXN0
IGRlZmluaXRpdmVseSBrbm93IHdoYXQgUFVCS0VZIHdhcyB1c2VkLg0KPiANCj4gPiA+IEZ1cnRo
ZXIsIGlmIHlvdSBoYXZlIGEgdHJhbnNjcmlwdCB0aGF0IGluY2x1ZGVzIEdFVF9ESUdFU1RTIHRo
ZW4geW91DQo+ID4gPiBkb24ndCAqaGF2ZSogdG8gc2VsZWN0IHRoZSBzbG90IGVhcmx5LiBUaGUg
ZWFybHkgc2xvdCBzZWxlY3Rpb24gbWl4ZXMNCj4gPiA+IHRoZSBjZXJ0aWZpY2F0ZSBoYXNoIGlu
dG8gdGhlIEtFWV9FWENIQU5HRSwgYnV0IGlmIHdlIGRpZCBHRVRfRElHRVNUUw0KPiA+ID4gdGhl
biB3ZSBhbHJlYWR5IGhhdmUgdGhhdCBtaXhlZCBpbi4gT25jZSB5b3UgaGF2ZSBhIHNpZ25lZCBH
RVRfRElHRVNUUw0KPiA+ID4gdGhlbiB5b3UgY2FuIGp1c3QgcmVxdWVzdCBtZWFzdXJlbWVudHMg
b24gd2hhdGV2ZXIgc2xvdCB5b3UgbGlrZQ0KPiA+ID4gd2l0aG91dCBhbnkgcmVsYXkgYXR0YWNr
Lg0KPiA+DQo+ID4gWW91IGxvc3QgbWUgb24gdGhpcy4gSWYgeW91IG1lYW4gZmluYWwgU1BETSB0
cmFuc2NyaXB0IGluIHN0ZXAgMywNCj4gPiBJIGRvbnQgdW5kZXJzdGFuZCBob3cgaGF2aW5nIEdF
VF9ESUdFU1RTIGhlbHBzLi4uLg0KPiANCj4gT25lIG9mIHRoZSBpc3N1ZXMgd2l0aCAxLjIgaXMg
eW91IGdldCBhIHNpZ25hdHVyZSBvdmVyIG9ubHkgb25lIHNsb3Qncw0KPiBjZXJ0aWZpY2F0ZXMg
ZHVyaW5nIEtFWV9FWENIQU5HRS4gU28geW91IGNhbid0IHVzZSB0aGUgb3RoZXIgc2xvdHMNCj4g
Y2VydGlmaWNhdGVzIGJlY2F1c2UgeW91IGRvbid0IGhhdmUgYW55IHNpZ25lZCBldmlkZW5jZSB0
byBzaGFyZSB3aXRoDQo+IHRoZSB2ZXJpZmllci4NCj4gDQo+IEluIDEuMyB3ZSBjYW4gZG8gR0VU
X0RJR0VTVFMgYW5kIGluY2x1ZGUgaXQgaW4gdGhlIHRyYW5zY3JpcHQgdGhhdA0KPiBLRVlfRVhD
SEFOR0Ugc2lnbnMuIFRoZSBjbGVhciBwdXJwb3NlIG9mIHRoaXMgc3BlYyBjaGFuZ2UgaXMgdG8g
c2lnbg0KPiBhbGwgdGhlIHNsb3RzIGNlcnRpZmljYXRlcyBpbiBhIHdheSB0aGUgdmVyaWZpZXIg
Y2FuIHNlZS4NCj4gDQo+IFRoZSBuZXQgcmVzdWx0IGlzIHlvdSBjYW4gbm93IGZyZWVseSB1c2Ug
R0VUX01FQVNVUkVNRU5UUyB3aXRoIGFueQ0KPiBzbG90IHdpdGhvdXQgYW55IGJpbmRpbmcgaXNz
dWUuIEJvdGggdGhlIHNsb3QncyBsZWFmIGtleSBhbmQgdGhlDQo+IGNlcnRpZmljYXRlIGNoYWlu
IGFyZSBzaWduZWQgYnkgS0VZX0VYQ0hBTkdFLg0KDQpBZ2FpbiwgbWFrZXMgc2Vuc2Ugbm93IGlu
IHRoZSBsaWdodCB0aGF0IGl0IHdhc27igJl0IGRvbmUgaW4gU1BETSAxLjIuIA0KDQo+IA0KPiA+
ID4gVW5mb3J0dW5hdGVseSBSTU0gZG9lc24ndCBwcm92aWRlIGFuIEFQSSBmb3IgdGhlIGd1ZXN0
IHRvIHNlbGVjdCB0aGUNCj4gPiA+IHNsb3QgZHVyaW5nIEdFVF9NRUFTVVJFTUVOVHMgYW5kIHdl
IGRvbid0IGhhdmUgYW55IHdheSB0byBwYXNzIHRoZQ0KPiA+ID4gY2VydGlmaWNhdGVzIGZyb20g
b3RoZXIgc2xvdHMgdG8gdGhlIGd1ZXN0LiBTbyBmcm9tIGEgZ3Vlc3QgUk1NDQo+ID4gPiBwZXJz
cGVjdGl2ZSB0aGUgc2xvdCBpcyBmaXhlZCwgYXR0ZXN0YXRpb24gc3Vic3lzdGVtIHNob3VsZCBy
ZXBvcnQgdGhlDQo+ID4gPiBzaW5nbGUgZml4ZWQgc2xvdCAobWF5YmUgbm90IHplcm8pIGFuZCB0
aGUgb3RoZXIgc2xvdHMgYXJlIGJsb2NrZWQuDQo+ID4NCj4gPiBURFggY3VycmVudGx5IGFsc28g
dXNlcyBhIGZpeGVkIHNsb3QgMCBhbHNvIGZvciBzdGVwIDMsIEJVVCBpdCBkb2VzIHJldHVybiB5
b3UgYWxsDQo+ID4gY2VydCBjaGFpbnMgZnJvbSBhbGwgc2xvdHMsIHNvIHlvdSBjYW4gYWN0dWFs
bHkgbWFrZSBhIGZ1bGwgZGVjaXNpb24gYWZ0ZXINCj4gPiBzdGVwIDMgd2hlbmV2ZXIgeW91IHRy
dXN0IHRoZSBzaW5nbGUga2V5IHVzaW5nIGFueSBhdmFpbGFibGUgY2VydCBjaGFpbg0KPiA+IHNs
b3QuDQo+IA0KPiBJTUhPIHRoaXMgaXMgbm90IHVzZWZ1bC4gQWdhaW4gd2l0aG91dCBzaWduaW5n
IGl0IGlzIGFsbCBmb3JnYWJsZSBmcm9tDQo+IHRoZSB2ZXJpZmllciBwZXJzcGVjdGl2ZS4NCg0K
QWdyZWUuIA0KDQpCZXN0IFJlZ2FyZHMsDQpFbGVuYQ0K
