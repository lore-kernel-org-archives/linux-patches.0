Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.17
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793730223;
	b=JB60e9vV90L5b7kUX5qQkNs+Hz2KeRRIoxkfCtze3yJyh1nLNVSQDL7S0F47I9F0YHcj
	 2ggESsZ9PA+HJTER06WE/w/4osACUMfum/LF4l4Cr3T5mIZRJ6kFUfadmeczxWewbCxBc
	 gjd/dP/MQhpizU7skcSzTI7TnmifgsjbJXor5u0OwLHgmFWkNx5vQHKsusHu2uaZMWTjL
	 a4fGz0vy+hOR0DIpS0BCkB8SSj4WWBCyzA+s/n6vfhOLkY3+ggjvY+s6VxNhPCiLyR/1i
	 lm4d10XIbUDR3MDRkK9W1NvHWKQqzrKozCeyLrcsqFXPyf2WFg/LqFIZkNZnYScfH2Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793730223;
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
	bh=8eCJ+uAAMRphS5gHfXBf62HSUNTM9amJzIDpT3/q5nM=;
	b=uoNTpkf3SgmYjea7urdv4Bjkf66FBfOqpXPlVOpPUm791dYrimthxaUtV33eB3E8bzPI
	 3So81A2ATvkqgtUP0h0CAN/EKHLI6L61/yJsLEJq5m3BymA0eIbOulUlY1GmVeR1oBehI
	 9awlWQXu7KdrUQO7BkfqrS9Hcr+DbzfHbTNl8r/WacoGzLs1/tJcjiX6cZkwtmEp+9lVC
	 FnDM+SQ6MO3TjZSyp1U9NQOPWrTcB1GFN1A3O4XN0LaavUl6PCIjmKYhdmg1z+WSD6jLf
	 ZciheBEg67+NWTs4P/xqTpiP+7VJ+cjCKPoPJK3AiqlyL7yt4Mu4DTBsGHyFmeBXcnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dCDalqGw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7543606A334
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 18:23:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E7543606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=dCDalqGw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793730221; x=1825266221;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8eCJ+uAAMRphS5gHfXBf62HSUNTM9amJzIDpT3/q5nM=;
  b=dCDalqGw+AXzrn/M8VWbOpHbna3TN3IhRcnxYRq+mNeA/W0EdvpdjivF
   ktIfZAFBaXaf46y92l7Bw1HeB0VrC0+4dX59e19T/dPiklzeUndnoSbMj
   rfKqPy98KHNmredLJYIfVwG3kUiDggUmeveYxO+aVEA2P/FMZOjQ3Z/EZ
   /1hTmfXo7bCfRtUzmPXgFw9lfusrn1oD3QoF46h7XbX8u7D2cGolrTRAR
   CSJOoSuNsyuHo53BfJE2H+2uo6r4mxILiLGQwTdtYyji7vZgHBdwUdMFC
   Ulw29snmz/LawPd3tj2LIQoc0Z0pDdLhMEIEywaxXVmo0VCYtb5/GR/Jr
   g==;
X-CSE-ConnectionGUID: L5v27IOcRRKjB9Q+TpLVVA==
X-CSE-MsgGUID: huIQVlTBQP6qaH+DP3lb8Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11955"; a="2476156"
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="2476156"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 10:23:36 -0800
X-CSE-ConnectionGUID: KAsBFsrTRPebiCVFz8hKOw==
X-CSE-MsgGUID: YHe1rYHKSs23noSOuaPBww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,193,1787036400"; 
   d="scan'208";a="6621425"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2026 10:23:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:23:36 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Tue, 3 Nov 2026 10:23:36 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.14) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 10:23:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w3sUEAQ7pTLBNxlXDgInAesbMUaXp1lGBhu5i6WVX+EYkKYuenPINmGL7wOYPk48rSFPzE7EYfS5st+GsdK2wVbFYzeexIioOLHWBsKAuwnDuEMJNtzDeBgKKm2X4ssK5QXi0v9gB2u1WNgsCkOGeHKg3/onG7UupFumAeDCpWIB8riQpTl46TPk8jlUQhvdIJ2aZsSzf9093rLwieCwFuhRP+KJm2rbyt8siYztn840G6YdU2fuI71+TUD2iO5g8m/SH1U49wyJdw0GAFlybRnnkVx6T6XDkuySxFpMQ6iBSsXM9a1qb6YJCco0sekjsTKoRo7Hsm0jAkS6PA31iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8eCJ+uAAMRphS5gHfXBf62HSUNTM9amJzIDpT3/q5nM=;
 b=Ou64iB4ljwAoj1darZWKAwPyayXLdVQN8mKY03E8Ti/xbBTBfFyIy+ng5CaaXv8oFfz1vrYZSuJP6dkH77NI4iSE1p1s2B4WNf+hynihkYWNm2DpOVpb9Hn0WTSJKK78nuX/K3C1ZwW4wxZcYwk1lMCPL62bLxCl38L3TMUxkbsfB1XrqjsrQW0zRDAYKyMbHRU0pp84MPtc2ODpwWq3xC61BAL12iO/p7rTLrmKNJMzhAvS9vGL7DJvMr6I3zYEYduHx3V+Wi0kikrIsQ/mxroEP11K7fPfWcjY0l2RQwJJFZ2m8Rb4zI5dQNWQ7oH3XSSqpDnnrok1Cs8Sq8HRow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH8PR11MB403433.namprd11.prod.outlook.com
 (2603:10b6:610:32f::10) by IA1PR11MB6418.namprd11.prod.outlook.com
 (2603:10b6:208:3aa::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Tue, 3 Nov
 2026 18:23:32 +0000
Received: from CH8PR11MB403433.namprd11.prod.outlook.com
 ([fe80::b087:96e4:50ea:b5de]) by CH8PR11MB403433.namprd11.prod.outlook.com
 ([fe80::b087:96e4:50ea:b5de%4]) with mapi id 15.21.0592.007; Tue, 3 Nov 2026
 18:23:32 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: Fenghua Yu <fenghuay@nvidia.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>,
	"x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [RFC PATCH 6/8] arm,x86,fs/resctrl: Prepare for asymmetric caches
Thread-Topic: [RFC PATCH 6/8] arm,x86,fs/resctrl: Prepare for asymmetric
 caches
Thread-Index: AQHdZZUHXVQvkN7mMkK5PWQeujo9U7cchY4AgAAvosA=
Date: Tue, 3 Nov 2026 18:23:32 +0000
Message-ID: <CH8PR11MB403433A347D1959387008CAE19FC692@CH8PR11MB403433.namprd11.prod.outlook.com>
References: <20261026215718.16810-1-tony.luck@intel.com>
 <20261026215718.16810-7-tony.luck@intel.com> <aun+Qt5iTECdwogN@chenyu-dev>
In-Reply-To: <aun+Qt5iTECdwogN@chenyu-dev>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH8PR11MB403433:EE_|IA1PR11MB6418:EE_
x-ms-office365-filtering-correlation-id: 46b14ade-afc9-4f08-2017-08df39d790f7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|23010399003|1800799024|10067099003|22082099003|18002099003|56012099006|4143699003|261022105027099003|261026121527099003|11063799006|261028144727099003|261026140227099003|38070700021;
x-microsoft-antispam-message-info: EAjc11xQyeDGjPe4+YVJrL1qhWbjFbgGCIsiy5TRfxOt2NbfWnl93+ywgwhTcjJ5ZBmpHUqURdbNE9OTI4hRiKCLDNGm+b3U5UQavU1lGv/lWkXhT+XfDNRyag0ag1POgtsUFnFM46GssanS36mHsoP5jlbmiK5gN+bKjeHNtaD9Hm41XneNLIgBbOLSBoyQux6YbIqfGunIY99VZjIA6kDrrtbMitk3ce1ysexVythzmsxDbLjGRmuDc+Z8OxYK0MKXs3RY2rv06Ue9Z33iQSdZLJebmbjVCCBfbIVNMv5454UzZdaMeGBR7ESJnN1agzFK5oN5kBJeI2hWrsCYc1fiRc9G8ceSNMOqkWBUApdOIxKYd3FdrCKw/8d5r7Dh1TxDQFPgzLxQpJv3/3elRZ6Is31y43769DwDanaA1+jBF7/dJEcSIqEMVVGugE+BBm3V7p3JFHiwDyDd+X7HBb+AMFpxV/eSaoxG+x3/YYLFttuK6I8fRg9c/blzimuCyTA3aPByIKpbWlTxGBjCvBKOPvwFmign4vD1DzC0y1DSd4ZTwowx4bBmKM32UfwbB8m0WqUVVtUrlwHVaPwDEYOIZaakts+1Vr41Y/SwjvlmBjQFJFRNi7tp5t3YIML5fiuKdS6m0/mziJxfDmV2Idlpy77QSXrDpnwz4J5maEQB345noIm6infPO62n0+WW9TEp+gJHgJufxDxhoLczb+JAwoUNyezzXTr6vPoysVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH8PR11MB403433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(23010399003)(1800799024)(10067099003)(22082099003)(18002099003)(56012099006)(4143699003)(261022105027099003)(261026121527099003)(11063799006)(261028144727099003)(261026140227099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2eArrEfjD9NjC6T318222WW5Ox/7P70xUBSWkmUh/vEdkbB8AunZxLlJ1SD8?=
 =?us-ascii?Q?c0xzZNY9wMSQQTQtWHi4qKd31NdOLzjzjIpmx18kaF/94V49nNK656sDUKl1?=
 =?us-ascii?Q?x41E9Wock3or3m22MFPDwqJ+Zm3Z2x0ZosyD/Ugqib+bHQFIpii5uXvlm/Tb?=
 =?us-ascii?Q?TDd4s9qoLu6V2D3rN4vjnAwS4CeeOuigCHKpFAfMRb7ZHmbIUO0Oj8a0do0h?=
 =?us-ascii?Q?iPJWdSy2cTHF1k1Tc/1ipenSOV126FwI8lG5Y/h7ol1B4UefP9pL9rP6tCY3?=
 =?us-ascii?Q?V3PzCWdKPUkSpctWZukfvsyKzQAIk3b0/gg5j0n+iNZgBBWPm9QDbdJSNXzA?=
 =?us-ascii?Q?3U7/NPdiJxvEfIIz6D4Udc5Hx+j8i5cxykILuTccBegIdt4zIaadr6IjZBM8?=
 =?us-ascii?Q?Ju6mOSzYAjkrPXcjtuWRFtqWNjx78IKqq/V00jI1Rojd2mgfiAyxLulsmHKY?=
 =?us-ascii?Q?2mTRijSpsTmMB2XOY877eK4tbwYud98TXKbsGRT581l20ga08OD0J/ad84+T?=
 =?us-ascii?Q?sXRG2p8lFwyxmfwqo9qrVwxK8t4Chu1fYpsFYBtK+NpwOo/+Aow895o+81/j?=
 =?us-ascii?Q?MESnqRXe3wwb3gyIdH/CJTL0IfOdjc6NiOTQmZ8xS66+ApYB2vAV7HPmcEF6?=
 =?us-ascii?Q?TLSMWMC3CqHD/YGcHk1NrdutGK8ZMnHjynWXLiaL6x1QwNAO9KI78Z14sofR?=
 =?us-ascii?Q?6detWJSjwvaHW50ApCsXYxfwqvXaI8NNrtHEaMusQfvsMIYYYDwbaEY6coFy?=
 =?us-ascii?Q?qgZ2wnAYUJA8NXnpRmaf07cDgC04vrvOZJUmF43svN5BzId7p0yBBJTSFVQ6?=
 =?us-ascii?Q?U5RMmkMuEv/0k4aG1Z/6jS4uD32eDpADH5XnhXPyT3DRaVdkUdt3P99erHI0?=
 =?us-ascii?Q?524/ddSRlEeSGsvcGxKHrWKonlExggR48KnBsPoUyyzyAHxYgKiHEB7uLu83?=
 =?us-ascii?Q?/7wTtXspRrZSEzzwR5W3t8l9mf9kJcrpqWz2dHlBl5F/gh5T//9+Khw4c+/5?=
 =?us-ascii?Q?X/njwY2wjZPw1OxAU5emlULA44Y29DRp2dz7BjbMZ2NTakWd7mRdU6eQzWjD?=
 =?us-ascii?Q?VwxT1EhI/4isc3UaRByt9dT7zWD0D5xUxqM7OdRBaPbS0ibMsdoDhgeQ780J?=
 =?us-ascii?Q?l590iyyKyFTBPB5lmtC25GRRBaMm9KyQDEsiq1PQ9w2wCVT0/Bnv7tLiT3w1?=
 =?us-ascii?Q?Lw0rxHd1cMKh529hbD82XYWzYqX3qHOybEPBUoDgAdv/9VFh6b7CfRGMHbKM?=
 =?us-ascii?Q?khFyL+/NXKDOnXn1C0GxmJH99HfYz8Q38TACuvbred8kiTGdOwEHntKsksnZ?=
 =?us-ascii?Q?ikHxVADy34I7d5svF8ryWdKuL9tDUQ2dq5FXdeBz4YC8re4FYAdZvfOo6XyY?=
 =?us-ascii?Q?KnzrEWQsdCjLEGKA9fL4V8xJv5UktwX1gnRwVpw6Yywo55JcbFZsTfMW5lfl?=
 =?us-ascii?Q?ZLS978qdaDri3Ad9EIMbESB3czUFn1je66fr88qCEH17pPw6T/r+tVkXGk9V?=
 =?us-ascii?Q?/pUtb73WJzvlQGuE+msgpkabERlwgbrciRKvw+I3abWZuWPLZs/QWKS9cylx?=
 =?us-ascii?Q?I5/FOWeOqWyWH+tkTBLxjjuRGAwjeEVMR8VISWPoF5beLTWmMFRfCnxpTq3e?=
 =?us-ascii?Q?qoRN6xEImHTk7AxUGeqdLhh0wwZBI/XoA/FRfcThQsWanoHz7IwgbyKWpwNQ?=
 =?us-ascii?Q?bYSkl0998iQsznmjaOwM03guOkakFwE+bqSI0ZaG+KouOf0F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ShUeSjRa6JexgQb55GEJAknsErxZtgoX6k31WvRa8IbYUqIyp3GRFI/LkOf5XESiRXUkwm03aohvaWK46roZa5rHR/2yHIhGOMRCWRCyXIflUdQw8ipDChQQ7o7zqKTcTmMEuB868Z4exiNoM+xtA1czb1UCcUeHCjLxQ2UAwxwRWmZcdd8fHDtBa8k61SQLe1i1jpARQ49oyY6xiXIsKA2ZHDWahgZfItDBLtbF5gCLPZ7JIP51mSoqE/U+9TdnSEtA7WBH6+AWIwtnt4XJlwhDKz/GqIyU58a6J/cnR8HI52NAAi9kEtt8E+HNZ/tSuW1GUsgjCJUW8zH7lXD2Aw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH8PR11MB403433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46b14ade-afc9-4f08-2017-08df39d790f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2026 18:23:32.2416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D3eQ8rA0OwatY/VgVVxRbviPkz/PnyjnnwWSZZ7M999DR2k5gM/T2nebTOGkfvSm7MOMT8ffAsvfWE7oA03clQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6418
X-OriginatorOrg: intel.com

> maybe we can let rdt_sync_ctrl_bitmap() receives the resctrl_ctrl from
> domain_add_cpu_ctrl() then we don't need to iterate the controllers under
> resource?=20

Good point. Maybe not even worth having a helper function. I'll look at how
much code I need inline.

-Tony
