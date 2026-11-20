Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795179705;
	b=LdvqeEGTcjvpTlteppYlv2PBJkQ7b4HnDIioq3PnutruZ6xtfNAUg+gXcb0p7Audl1WZ
	 lkvBxiO1ophOjnaDs7MAulCxArpWeP8rsv7Lgvv+OveE3q8xd0MVnbmqwzdXdb6eK10LC
	 XHfWEk0Ns1RvGUZMdqyv5dsgbrdbJNRDmpynThlbe+UenEG94ZjTThybYfwkMhp/E9TSg
	 SLHupfY6aTD/Fj3TN2yLY/+kWzIxevrA4GmULqQP2MdPTo2eii3GUSUoxGd9CUA+52Ybo
	 Ala8Ugu78ghn+6lb98V8pKi+LM4S6zB0nfGyQd9aVcYFYk2eBZmDxCSixEyjPcun7Hg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795179705;
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
	bh=45VchVJJOs5dvYFoGBkz39DaiCtAkpdRw7gXI7g3ink=;
	b=Hid67flM0TDdCIIhihRnfxYO5ey7ilKOu/w3RVS9II70a+EYZx9KRGX/05xv/IDD2yb0
	 yqi6fpn57K37b6snbTSM7uIa2jQMNJeb8LrdVXGp9Qa+scy/qAX5XaLU7lCHvb11WYJIg
	 4Str1qzEHP14hOFg0FtW6mjF0FS7NKd1Z4CAtUlE4yzbyOHJKQ4QkmEvHoDJE7i++5aPM
	 0q6L5b6jUa5MPpUH8dutXr6WUXlO//9AcQH8z5tKW+N9q1uxVSL2QfmG/hKGuM62/fMSy
	 uuGafsoV6FEQJ82/Tvy5IxV/SXHGtEJXTLvFWKOX9GBZLZWlPLIT8j7Yr3m9bgMWXIQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RUmfLvq+;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=RNyUrEYT;
	arc=pass header.oldest-pass=0 smtp.remote-ip=198.175.65.19
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76E0606A320;
	Fri, 20 Nov 2026 13:01:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E76E0606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=RUmfLvq+;
	dkim=pass (1024-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=selector1 header.b=RNyUrEYT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795179706; x=1826715706;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=45VchVJJOs5dvYFoGBkz39DaiCtAkpdRw7gXI7g3ink=;
  b=RUmfLvq+atST+XXQaP/x/UprAnoqpFCyi4pmAPuMbfPAxvLeb2nara60
   fyL00Evf1+kh2mlH4KD/97JShfReAOuPfBaF3mxubvMJHyUr3pW6NBkeL
   in5svtKbFHimH/Ay6Y6/tQlRb0AB7ketgqocsSXkuPU+gnA9Z+W66sjSh
   qpgGs9VGOfYc7ehGayU1oyfO9es3nTNLdsgbUjivULfL1f6QB0yU2+zQQ
   CNSp2RxtG/9l1oYGWwxd48No3/7D83hBu4OMal1WBBKnCggLK5Y0LzpOS
   n3W5Exz0mbMLE5q1Sn0hVhwYxEW3/4Dg8cI3sqzX7cuC+IsHlbUUUIKXS
   Q==;
X-CSE-ConnectionGUID: 6cKcn9nSQW6TKnFQW0YsAw==
X-CSE-MsgGUID: yh9KR+kSTFamglHGMVENZw==
X-IronPort-AV: E=McAfee;i="6800,10657,11971"; a="4100285"
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="4100285"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 05:01:44 -0800
X-CSE-ConnectionGUID: 6wAXLn1GTZ+5ueKk3Zcy5g==
X-CSE-MsgGUID: hEopMgOlTQGReAZcEE34VA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,223,1787036400"; 
   d="scan'208";a="11266254"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2026 05:01:41 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 20 Nov 2026 05:01:39 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Fri, 20 Nov 2026 05:01:39 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.35) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Fri, 20 Nov 2026 05:01:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=od1IGsjju+LsIEfqA+kbN+y3J7b/WPe14owoFhg+QFn8F4eq27HbKNufPxj38gvgvbfX7Z0OT//Jsa2G3vNdszKcnzpbFGz2tBLYUFNPWewRcVxif/FPidJzjQ64JDA7A88iVOLhPtfROUTpzYdUy1/7A1UGFyin1VCV2EXrqKDswzhZTAVHgT38+kMd8WChvL5+pzBwaQ9GOTsJhQUXC4dw7lnBt26iL+MKjw4PcVzY5+Bg2kce1fTxmS9I0WDvebtFJsmmpRADwYBHsqkYEboLB+GeSraKOcIa+ec06imkamN9+KNXCbBGbcf5om2/PQ1z/LGoiGePGjGN7tmCpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45VchVJJOs5dvYFoGBkz39DaiCtAkpdRw7gXI7g3ink=;
 b=uCDjWC4ZB2K+w5zY8gfdsUiyW6NemOwKXT7c8OIZvaBTen3yjbBfMe1qv//AzkTgvBQZ4NBgXQMb0cu+NNDiw0kBXCWcCSVyuvblSN9Ig8yhlXn/mYKzKah6VQNzUZyTVjfOQ7VdNinS7Pm7vcVbA+CbG416sZIFQBIz0cvZkJpeikO8AitbZwaeHcJs9x+cbJbTh7Yb4hU10578On8uiihk/v+LJFzlS9ehisrmHsokyDVF/m9IaL62qWwo4C49SqMGI5ZGb5jJIqcbWGXhSjvJm7Zb0PFYMHct24+bFK1ZzKxBZebNvnnDs95uy+DgRZ/Dkxr1mwrUqFaFcMn23w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=45VchVJJOs5dvYFoGBkz39DaiCtAkpdRw7gXI7g3ink=;
 b=RNyUrEYTn4/J2FmIBuaBg2pTUt48B3KSi9M6nDyJTCuVYUuC3ggsyXFalYNQe7nPMJtXWyAUIUqHDelLJQbZtndKuV20pREL/MvltOIm+xmTPlD71hnDc89NUE19JUD6G+fBg/h9tKc4hXzvNR7DaBnOv1cDft8ShgF5cWdvWrI=
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 (2603:10b6:f:fc02::43) by IA3PR11MB8985.namprd11.prod.outlook.com
 (2603:10b6:208:575::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Fri, 20 Nov
 2026 13:01:29 +0000
Received: from DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7]) by DS4PPFA84FA90FC.namprd11.prod.outlook.com
 ([fe80::6aa4:1f69:47d6:56c7%7]) with mapi id 15.21.0639.010; Fri, 20 Nov 2026
 13:01:29 +0000
From: "Reshetova, Elena" <elena.reshetova@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Aneesh Kumar K.V <aneesh.kumar@kernel.org>, "Jiang, Dave"
	<dave.jiang@intel.com>, Xu Yilun <yilun.xu@linux.intel.com>,
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
Thread-Index: AQHdZvIx/4WLyAKeS0CHM51th/PLq7cUvvoAgAAECYCAARZEYIAAOl2AgADzg4CAA46ocIAAevEAgAEloGCAAEhmgIABGSiAgAAXIXCAAEdkgIAANdmAgAMTyoCAADyIAIAIyGyAgABYEACABi9HwIAAFJOAgAFOxlCAAD/3gIABZsjggAAf2QCAAxhV4A==
Date: Fri, 20 Nov 2026 13:01:28 +0000
Message-ID: <DS4PPFA84FA90FC5CBC7769BB1213B1724FE7782@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
References: <a3f95140-c49f-42fc-b92c-73c8cf98336d@intel.com>
 <e05a71df-3b20-45a3-bb46-fb1bdad164c8@intel.com>
 <20261106193018.GK770409@nvidia.com> <yq5a5wy2qtjs.fsf@kernel.org>
 <20261112145254.GL738765@nvidia.com>
 <DS4PPFA84FA90FC465DE2D4A57521CEB991E77C2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261116143319.GA2245175@nvidia.com>
 <DS4PPFA84FA90FC9031C253514720694AFBE77B2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261117142027.GI2245175@nvidia.com>
 <DS4PPFA84FA90FCA6CFA44F36D6B9DE24F9E77A2@DS4PPFA84FA90FC.namprd11.prod.outlook.com>
 <20261118133834.GO2245175@nvidia.com>
In-Reply-To: <20261118133834.GO2245175@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS4PPFA84FA90FC:EE_|IA3PR11MB8985:EE_
x-ms-office365-filtering-correlation-id: b2411ecb-c0b6-405f-4dbf-08df47066467
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|23010399003|376014|366016|18002099003|22082099003|261009223027099003|3023799007|11063799006|56012099006|4143699003|261026121527099003|261022075727099003|261026140227099003|261022105027099003|261028144727099003|261021123027099003|38070700021|10067099003;
x-microsoft-antispam-message-info: 4FUS8I9pjG5irdQim+BcSLveBvHDOvT58Mt++6i3uuB/hA8z2ZjonRcanwlY7r9zpn9kUDgw8W1IRNlfckmI6IZpiO1q51GAMOHOobOrmKnZ9IPouCdrm6n9+VUHIeih6Oxq8ARH+AAAL59e3BImYmh4MPOULN+z57gUSJIkwy43lDmFGgl6ZzMsjLYAkEPLVxq4ZufWV+hl4+fItVwt9fIISFyrIRnweSA6wKkvwBaXBkBW919d0s9gMv1R2cmUBKph9sPHXFowbXAhzyU5gZAaXCDtLcbHFuewkbWHBn82fSHlyQZOJ3maRQHac35jm2r6bW8sCijW8oe9+Y6dHAioP1ic/2nRjka2MJaGXllsmaqyGv8qnAvHnnA5QjuxMhr9yETg9DAAZzJNm6VXmNLg4K9+48S7VX85CMDeCXvdYPVyT7RHXC5kXY+GPqN8/ICOBZUgBGacIn/SFOAZZAh9/piQL4qn2eIBolEKZmGEZ9OLP+fNDuPZOzR1GTGO86xrrKDh6QKSUZkH3Uagr4Y1izx2eeyP/DgTgK85E/JhSBYXZWaGAsxYhfoyomkPNMS9QV36WVtjLG9/SjOtjEOABdi4P6ikWCIIhZMSsv0dI+FIfDieC0j3+MGe+2NkoHGOofiblwGAo8HmcEU/H2v+OKpglVPbTkc/uSEaTxbONnnRdva6psoU4HSnFBDdpNYcS4wTlVyTAdzHhKqQ2F7e4Rb93c63YiphYX4K+rE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS4PPFA84FA90FC.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(23010399003)(376014)(366016)(18002099003)(22082099003)(261009223027099003)(3023799007)(11063799006)(56012099006)(4143699003)(261026121527099003)(261022075727099003)(261026140227099003)(261022105027099003)(261028144727099003)(261021123027099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZmVoZDZ2b1hvYTJUVzBMNlYrczY1dExTU1piS2hTYTBMRC9McWVRdTFVSGxR?=
 =?utf-8?B?VU16MmNuZ3R0Z0JxaEY1TzJyUENKZnpYMGNzaFdtcTk4MUFFTEVnbWFCMTN5?=
 =?utf-8?B?RFBjSVNyRzJWZXJIcVNzVDhhUUhNcThNdm9RU3ZCb3MrVUxlaWw0WXFUakds?=
 =?utf-8?B?K3Zubks0cUswcitBa1VXVndUQ1hUcEMySUNRSTlOTkRPRmFlMUNPN2EvbEZn?=
 =?utf-8?B?MEE5SENVdkp2T09wUGZWUTdSTDhQZG04QnoxTklSWXFvQXBFL291Z1hHSExG?=
 =?utf-8?B?QnUxcHpRSkVENjdUbzhPUnB3RkExRGdhT3dpN0R4dXNTL1c4VkRXaUowZk5V?=
 =?utf-8?B?WEQ3UzUzNThjdDJSUmcyY0pxNm1yQlRub2ZqelFIM2RMbDhMRStzSWdFcldR?=
 =?utf-8?B?dFZJTzVQOWRNYjJYWnR5dERORTdnT09BalpKUG5qQWd2d1paemdTejQzbUsr?=
 =?utf-8?B?RXhYaHZGWDF4Y2FnYmJEdkVka3AwRTN5V0Fka2EvWTZqSXhrS1U5OTZQMXEy?=
 =?utf-8?B?U3JBeUhRL3lOWmxrdjdZSWJxZTA0TEtpRjVDNkNJUXhKeWF1SGNPUEN2R1Rj?=
 =?utf-8?B?eWJNL0htaTlWbm9HYVNxSXk3THVzVHlWT2Jhb0JVeFJ2NjU4dm9vVVk5YUx2?=
 =?utf-8?B?WHVyVWdLRHhGeWlLazUzcXVCVWpmS1l3bXl4QjlBc0pKaFFZa2pqd1Ywdjhp?=
 =?utf-8?B?K3RLd2Z4SUt0bUZWZGtONUtRYTRQTjhYOTZ6RnlBN21sbnlZc3VlYUluM3U5?=
 =?utf-8?B?MW5vN2ZFTXFnUGl3dTArVk5VSHN4QVNFZVhhL0pMemFLM2tSbUNvOGJBQUNz?=
 =?utf-8?B?dXVhSXFhdjBVY2lYNGYvWkl1OWdqUFZTL0QrYTlOZ0RYZW85WWpIVWorOENK?=
 =?utf-8?B?Q28yTi9mUUF1WEZrOFhSaDd5MFN2TE1CUFp1bjRrbGVjT0hsN1lNWmtrSENG?=
 =?utf-8?B?WERwUHdFZmQwMmVkdGtVVEdBT09vbU81TmNBYUtpWmZoZnZvc2czOWV6ZzRy?=
 =?utf-8?B?amRrSmRwYTNVMHh0dW1RUHhOc0hjSGFxMmR3SVoyMFZZa3hMNUZWZ25DZTk4?=
 =?utf-8?B?Y1FUcXN3em5uVkZuQ3NWcUlTTnFlaDE1U3ZSNzEzNmp2NUtCTHA1ZkVuK0RF?=
 =?utf-8?B?ekhOQ2JuUzl2SHpGQXRZeXQwUENaNnd5RVdvTWxKR2gxTmpzRUdFaHlxbmxC?=
 =?utf-8?B?SG9uaGZRNS9nTG5EUDZYcUx1YTR3bm9KYTZhVHQxKzRBTXM5MnlqQnVBUnNN?=
 =?utf-8?B?R1FKZmNZbGtsZHZPcTh4Q2x4MTNxbFJGcm9DckRHSFp1cVpBM1ZFMDMzaHhu?=
 =?utf-8?B?OW5nWXFOOGV2b3ZxM1N2bFpJdjh0NHNjK3d0RVg4dWZvSjdMNHpETlErTVhL?=
 =?utf-8?B?Uys3V0FxZGtlWFA1VHA1OXdaeHNST20yVkNWZTdiMnJLVmhTaGRrRzl3ZUEr?=
 =?utf-8?B?cURSZDhlc0xGUTl3Z0E5M2piYTN2QkZyTFh3VHpjZ0F0SURqQys0WDYvY2tW?=
 =?utf-8?B?K01TOEFPRS9GWHQxdWtJVzM5dWxBWkJKQWl2UUFGRlA3YjVObUl4dVlOQ1Nx?=
 =?utf-8?B?YXB6TW90ZCtFMnVlTjFNeFFpcHVaZjNEM2k2ZmZWN2FJekdBNUwvdXpOZWdv?=
 =?utf-8?B?azZRRlNTb3BMZGdaUkkvdjB0WHM5Z0lJT25HdkUrcHUrREIrSWJaTElES3Nj?=
 =?utf-8?B?YkJVU1lBVzRwZ2lxVzR3Z3I4YitOeCtVNmNyVkRKRTd6a1BtcXkvODdVRjZo?=
 =?utf-8?B?K21RUHNFRW5iYythRjltRGY1ZWM2VmtYdWdVZndYemZqanM5N2JPeDVNQml0?=
 =?utf-8?B?dDYxdjhyc003NUM2Y3VSejUrSHNaOVIvd1JvNllXNDVacmMzbHVIOTZza3dn?=
 =?utf-8?B?aTZ1NjBhVTRTdS9JblhFMzNVMHJBejd3VkNsVEhhUGlQT0Q5VmE4eGZ1VzhL?=
 =?utf-8?B?UUlacEpwMEtUL3d2Q2ZKcWhvMjQ5ZXdUNVJvNjhsYnQ5U1lVSXlSb2FwVFpY?=
 =?utf-8?B?SVo0RzY1YmpnYlFmOS8wWlM0RlNNbkR0azNxaGRRa21LZVNBS3JrRHBvbnNE?=
 =?utf-8?B?eGlVN1NJdWxuTzhkeHF4VWdJbDNUUGIwdFFXWVBMTEo1NjlGZHhJWUpJeFNt?=
 =?utf-8?B?OExORTA4cW9WVktvRnRNcldQc3RKaExadW1GL1VIdVYxNWNoUzdQQ1JEWWRQ?=
 =?utf-8?B?YVpwUmVORTl0UU9kVkhIRnJ1c1Y2NHpnV0xrcTlOaTFsWFphNnN1aFNLY1NP?=
 =?utf-8?B?MXRIaFVlVmVueGhZak9sOW44Z090VTV0MjdOTEtVQXpvLzIvcHA1WW1zT1lw?=
 =?utf-8?B?dTdRNXBIemZINWg0MXlGeGJSSzV6dFZBUzcxKzdWS3NsdGs5eG4vUT09?=
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
X-Exchange-RoutingPolicyChecked: RB8veTWXkgk87VtMSMVETUZ1iS7wevQgtNuoqU6UlBbcvZf5dHpmkccQtYzRau2D17pTWeGEH+MuzMNHVJ6rY0P/sWK+pFXy4FApHOPMn/H4uFWNqRWNRQ1KFR6KAlnmpQoBILZieQ8qFMiYg6Xd7a9A+QPsCvxeRpgMCZ7ldzUGBuQ+99s0pPVvPjH8i94g2uPghToHA8GE7Gygzd6Zr5VOdh3Hxh4q3opmhsnBljJ8AkPE6S10IAHhKw9ToweEIxdS0wU7Jl9o4vZM8Z2tn/SFywh9uuDqhflDB7UVhFe0EYzLajt84TgvxAvzz0+zhjg+nCxluRbd0IOKS30NSA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS4PPFA84FA90FC.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b2411ecb-c0b6-405f-4dbf-08df47066467
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2026 13:01:28.9523
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /kN4pqkBqxObLuoEvT856K047qmrZIbQHaG8YcOXtL0lL3KzevYG/O+gJs4fM8O5BCO6XqK0jbGsm6MrHEE3os5KLdxOlI3UYG33APj/+Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB8985
X-OriginatorOrg: intel.com

DQo+ID4gPiA+IEFuZCB0aGlzIGlzIHdoZXJlIGluIG91ciBvcmlnaW5hbCBTUERNX0RFVklDRV9B
VFRFU1RBVElPTl9JTkZPX1QNCj4gPiA+ID4gc3RydWN0IFZDQSBzaG91bGQgaGF2ZSBsaXZlZCBp
bnN0ZWFkIG9mIGJlaW5nIGEgc2VwYXJhdGUgc3RydWN0dXJlIHdpdGgNCj4gZGlnZXN0Lg0KPiA+
ID4gPiBXb3VsZCB0aGF0IGJlIGFjY2VwdGFibGU/DQo+ID4gPg0KPiA+ID4gSSdtIG5vdCBzdXJl
IHdoYXQgeW91IGFyZSBwcm9wb3Npbmc/DQo+ID4gPg0KPiA+ID4gTXkgY29uY2VybiBpcyB5b3Ug
aGF2ZSB0aGlzIGRpZ2VzdCBvdmVyIGEgc3RydWN0IHRoYXQgaXNuJ3QgYSBwcm90b2NvbA0KPiA+
ID4gc3RydWN0LCBzbyB3ZSBoYXZlIHRvIG1ha2UgYSBzcGVjaWFsIEFQSSB0byBwYXNzIHlvdXIg
c3BlY2lhbCBzdHJ1Y3QuDQo+ID4gPg0KPiA+ID4gVW5sZXNzIHdlIGNhbiBnZXQgcmlkIG9mIHRo
YXQgSSBkb24ndCBrbm93IGlmIEkgY2FyZSB3aGF0IHlvdSBwdXQgaW4NCj4gPiA+IHRoZSBzdHJ1
Y3QsIGJ1dCB0aGUga2VybmVsIHdpbGwgaGF2ZSB0byBicmVhayBpdCB1cCBhbmQgeW91ciBkcml2
ZXINCj4gPiA+IHdpbGwgYmUgbW9yZSBjb21wbGljYXRlZCB0aGFuIGl0IG5lZWRlZCB0byBiZS4N
Cj4gPg0KPiA+IEkgYW0gdHJ5aW5nIHRvIHNlZSBob3cgYnJlYWsgdGhpcyBzdHJ1Y3QgdGhlIGJl
c3QuIEFuZCB0aGUgb25seSBvcGVuDQo+ID4gcXVlc3Rpb24gSSBoYXZlIHNvIGZhciBpcyB3aGVy
ZSB0byBwbHVnIFZDQSAocmVzdCBpcyBjbGVhcikuDQo+IA0KPiBBUk0gaGFzIGl0IG5lYXJseSBy
aWdodCwgVkNBIGlzIGNhcHR1cmVkIGluIHBsYWluIHRleHQgYXMgdGhlIHNlc3Npb24NCj4gdHJh
bnNjcmlwdC4gVGhpcyBUU00gZGlyZWN0ZWQgY2FwdHVyZSBwcmltaXRpdmUgaXMgd2hhdCB5b3Ug
bmVlZCBmb3INCj4gMS4zIGJlY2F1c2Ugd2Ugd2FudCB0byBjYXB0dXJlIEdFVF9ESUdFU1RTIGFu
ZCB0aGVuIHBhdXNlLg0KDQpTbWFsbCBxdWVzdGlvbiBoZXJlOiB3aHkgZG9lcyB0aGUgaG9zdCBu
ZWVkIHRvIGNhcHR1cmUNCkdFVF9ESUdFU1RTIGdpdmVuIHRoYXQgd2UgdHJ1c3QgVFNNIHRvIHZl
cmlmeSB0aGUgdHJhbnNjcmlwdCBhbmQNCmludGVncml0eSBvZiBwcm92aWRlZCBjZXJ0IGNoYWlu
cyB0byB0aGUgaG9zdD8gDQoNCkkgdW5kZXJzdGFuZCBpdCBkb2VzbnQgaHVydCBhbnl0aGluZywg
YnV0IEkgd291bGQgbGlrZSB0byBhbHNvDQp1bmRlcnN0YW5kIHRoZSBwdXJwb3NlIG9mIGVhY2gg
c3RlcC4gDQoNCg0KPiANCj4gPiA+IDQuIFRTTSBjb250cm9sbGVkIG5vbmNlDQo+ID4gPg0KPiA+
ID4gQSB3YXkgdG8gcHV0IHRoZSB2ZGV2aWNlIGludG8gInRzbSBjb250cm9sbGVkIG5vbmNlIiB3
aGVyZSB0aGUgdmRldmljZQ0KPiA+ID4gZXZpZGVuY2UgY29sbGVjdGlvbiBubyBsb25nZXIgYWNj
ZXB0cyBhIGd1ZXN0IG5vbmNlIGFuZCB0aGUgVFNNDQo+ID4gPiBwcm92aWRlcyBpdHMgb3duIHJh
bmRvbSBvbmUuIFRoaXMgd291bGQgYmUgYSBwZXJtYW5lbnQgY2hvaWNlIHdoZW4gdGhlDQo+ID4g
PiB2ZGV2aWNlIGlzIGNyZWF0ZWQuDQo+ID4NCj4gPiBXaGF0IGlzIHRoZSB1c2VjYXNlIGZvciB0
aGlzIGdpdmVuIHdlIGhhdmUgYWJvdmUgMyBpdGVtcz8NCj4gDQo+IFRoZSBvbmUgeW91IG1lbnRp
b25lZCwgc2luZ2xlIGV2aWRlbmNlIGNvbGxlY3Rpb24uIElmIHRoZSBkZXZpY2UgaXMgaW4NCj4g
IlRTTSBDb250cm9sbGVkIG5vbmNlIiBtb2RlIHRoZW4gdGhlIGhvc3QgY2FuIG1ha2UgYSBzaW5n
bGUNCj4gY29sbGVjdGlvbiBhbmQgcHJlc2VudCBpdCB0byB0aGUgZ3Vlc3Qgb3ZlciBhbmQgb3Zl
ciBhZ2Fpbi4NCg0KU28sIHlvdSBtZWFuIGhlcmUgbGlrZSAiaW5pdGlhbCBkZXZpY2UgYXR0ZXN0
YXRpb24gZXZpZGVuY2UgYXQgdGhlDQpTUERNIGNvbm5lY3QgZXN0YWJsaXNobWVudCB0aW1lIj8g
SWYgeWVzLCB0aGVuIEkgdGhpbmsgDQpUU00gY29udHJvbGxlZCBub25jZSBpcyBtaXNsZWFkaW5n
LCBpLmUuIGl0IGlzIG5vdCBhYm91dCBub25jZSwNCml0IGlzIGFib3V0IHRoZSB0aW1lIHdoZW4g
ZXZpZGVuY2Ugd2FzIGNvbGxlY3RlZC4gDQpBbmQgZG8geW91IHBsYW4gdG8gc3VwcG9ydCB0aGlz
IG1vZGVsIGluIExpbnV4PyANCg0KQmVzdCBSZWdhcmRzLA0KRWxlbmEuIA0KDQo+IA0KPiBHdWVz
dCBjYW4gc2VlIGl0IHdhcyBhbiBhdXRoZW50aWMgbWVhc3VyZW1lbnQgd2l0aCBhbiBhdXRoZW50
aWMgcmFuZG9tDQo+IG5vbmNlIGJlY2F1c2UgVERYIG1vZHVsZSB0ZWxscyBpdCB0aGlzIGlzIGhh
cHBlbmluZyBhbmQgZ2l2ZXMgaXQgdGhlDQo+IGRpZ2VzdC4NCj4gDQo+IEphc29uDQo=
