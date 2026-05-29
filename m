Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8C43A5E97
	for <patches@lists.linux.dev>; Fri, 29 May 2026 19:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780081610; cv=fail; b=Zv3mZkd5VAJvq5v0yD+P9QP5nEMYMixfbQp6UPmXUL97TdpG2kmvIPDbbzaKAykkibgHFDnPRB1lBMrMVax85bNw0Eu99NiQjYcQ9ZR+fkC3KBNAp9C3NuMGdm24LyHvKn1pv7i8DLSf6ixL1CE2QYQzogMcnuNAu47QB6uzubE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780081610; c=relaxed/simple;
	bh=NdxK56xpN4XUr/5+wmOBhHaPvZuGcisotoNpnoGVlkU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=X7rK0V6/LqYJG1rPwzC5w7V258psC5UBsk4UrTZo/VQRYsCJ9BQ36/MjGuJXGHkrUF0BL3my8xegn1kongb/XUeKexy3rgE3EJofh8yL/RWlashdvUlAl4cgpxsQv1nCwUVU7USNCk+U0n+m4aa4WwbWEHfGTG1B2NnzKU+u5UU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dSvndZmZ; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dSvndZmZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780081609; x=1811617609;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NdxK56xpN4XUr/5+wmOBhHaPvZuGcisotoNpnoGVlkU=;
  b=dSvndZmZZohGDBtCWCxUTrZfU646uGgMzzAIZf7sfp53oLvCsDQf5YrT
   ebC5N9yFUP0jxnK0Temt9584CpnZqvwGwXseoQyhTSNQbP3pwTiKTpEkk
   o5MgcgFvw9mLNHPKTD0iNh2PDeNwdOU6bsbe9pleIg8hjuN7dV1qH185G
   per+2Kw0f9G+8LUTeFMdti9WOIjJ+egX3cegzSVGf6zmqHqgMXtQ5FB7Q
   WLmdlPiaI/GQYFNdOZijuwDZNkCjmbyo3LPuXUadMMg1aCB2muXKVVgyz
   TSFKZA78bnVgoSD9Gytg4TuaPHSmzWTe75i1gjrIQd/Lxe6k0l+Pc75Wd
   g==;
X-CSE-ConnectionGUID: sVKZdK5pSneybVZKI1UomA==
X-CSE-MsgGUID: UZlLvxBLRSeWTh0gzY/vJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="106391030"
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="106391030"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 12:06:48 -0700
X-CSE-ConnectionGUID: T+e6aM2kS0yIZYwfVXY1mQ==
X-CSE-MsgGUID: eEeySr/QRUGxoe02XTaj1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,175,1774335600"; 
   d="scan'208";a="242134458"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 12:06:48 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 12:06:47 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 29 May 2026 12:06:47 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.59) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 29 May 2026 12:06:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I+YxwbSac21UzvghTZxVCwmJDbSCCLY4lK2Ge48t6/tJw1CIHQR142T1VP3zvg5NZl2yF4reJ52r4ANEyBMZxAWbVWRmO/DogsTVb3Rna1t4u4ytvNwo1O6tnvi58FTl30GVkhgL14CP1EtxM6jTq0mLmejqsGwz1hT49ODDG6B8XvH2kUeXxb+6orpkVfO8Q5JFDk1AUZD9R/j8KwZu7DrroLOcmjzAocwIOgD4g0w1wCgr/oR205t1hUZs/HR09QO19NZjOXQHvZjarHeUqdXT9sZVOkKkRUCKcxZVYpO3dsnfuC9BI0RjDKEL1kTnzS3UqtpBk4beWWwdczpQRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NdxK56xpN4XUr/5+wmOBhHaPvZuGcisotoNpnoGVlkU=;
 b=Ifbe9j53XbeeHc0OJm/WeyWgXz2OLXA0V1UUjHJG7sch5yuTrcNF29PF4jJIr18/tn4H58G+zB40NMKqAerZdCrnxaxeZ0xgHnZd852qUmZ5JyTUiPNWNEF9VPTCGfJ0gOIJC1xHDa1KyJkbfuB2pMThn+dcFZ0fbVz6a6nj3YJnKJX0QUefpvrLqjz37RjD2xzPpNngI2jmIAbvpgGQzw6AIX06R8vKRLRJHRp7WbR0fjfKIHrdVgQ1H0gK8O2hpqoxTKJBolcfHwDjqyfV8pj1YFHn2IhoqaqjuZ2U3X7yq2+6Ac7npKi4mOnTY5qtEuef0vQppCQujW3hQEFBxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by DS0PR11MB7577.namprd11.prod.outlook.com (2603:10b6:8:142::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.14; Fri, 29 May
 2026 19:06:37 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.21.0071.011; Fri, 29 May 2026
 19:06:37 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
CC: "james.morse@arm.com" <james.morse@arm.com>, "Dave.Martin@arm.com"
	<Dave.Martin@arm.com>, "babu.moger@amd.com" <babu.moger@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "ben.horgan@arm.com"
	<ben.horgan@arm.com>, "fustini@kernel.org" <fustini@kernel.org>,
	"fenghuay@nvidia.com" <fenghuay@nvidia.com>, "peternewman@google.com"
	<peternewman@google.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH v3 0/9] x86,fs/resctrl: Fix long-standing issues
Thread-Topic: [PATCH v3 0/9] x86,fs/resctrl: Fix long-standing issues
Thread-Index: AQHc6h9hp0PcUPzKIkO4OAily9NwubYj51UAgAF4vwCAAAeaQA==
Date: Fri, 29 May 2026 19:06:37 +0000
Message-ID: <SJ1PR11MB60834F92DB5EF84B6DDA2BFCFC162@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <cover.1779476724.git.reinette.chatre@intel.com>
 <ahigzj0ewXQE-baI@agluck-desk3>
 <8acb01f9-edd2-4279-89fd-a9a0091743c5@intel.com>
In-Reply-To: <8acb01f9-edd2-4279-89fd-a9a0091743c5@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|DS0PR11MB7577:EE_
x-ms-office365-filtering-correlation-id: 860270e0-192f-4848-0449-08debdb5685d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|22082099003|18002099003|38070700021|11063799006|4143699003|56012099006;
x-microsoft-antispam-message-info: sF/pV4nK6feXTHd/5guNdisJKtDeAS3gMkeRLN08LNiJuYl/A0Neh+F8aeL3LTJ523mt3a6iob3sS5Sxw+sPXNvtC2nZOCifnWXom2EKxAcd5Bc6sbxtuzqUpbYC77a6b6Z3b/6rGzvT/vs3SxhR0ktpypL8luJ0xh1pQhEvRy0bz0iECkP4wfVXa6CHZ2NIzS4a6rpkNIimU+Bp+vdxSlANlXynDYFPLcR4xOeFkm5kAZ14JJW2N9lhWTAYti7CppSD2geTS7TGV5yDmQmsIngbBpRGDqcnFxZ6v612dfZqI8CWn0F0RXddI3PD/e5tjfz6CJNCldgkubs9mEfxpQPBKNGFdpBZLyWWuoVmdRpsFV32OFZ3ANbYH19BHIzHG6L9NFnIpr88Ffs9pB97EugmmuyK/5QUFSLYifNXlA4Juzke2jjOmvEPLDULB3d5g1sUnG+sztMCM5rtMzhcfct2eAo5H89J9c+ZYHEM3AtNsSm1ed/rDl2b96jGhPhN84f4DIzmeEvMpF8MDCPDkZNrTOrFOO2jYH792mNickKcxSqv2fOeS/F8Sgf5vVbzFh1OIrInNkJ6rwgL5ZDI1xNbwhiWjTUAHIY+QUFbdKPLJjb9O8ICy7geTkupKwOL+3+w4+SsleOFF8iXpN8Qe+Y8kZhR8IQF1VoeGeNxHBRP+PN+Uu4lOX/q4SKC4+zZ4pNs74RCdSxBNMj+zAZXRtx7EdalvvBWxCYUI3C7qF7ljNlwNYRVdlwyr5QfkYhY
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(22082099003)(18002099003)(38070700021)(11063799006)(4143699003)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SWMxSXdSRFFqUDBFQmlMc3N2VHMyQ1IwTjhoTm03T09tNzRtMzRuWkI3dWFk?=
 =?utf-8?B?Q2RnWUZqVFMvYnFvdm1WYUZvaVREZndZeVhva21EZENxQTJlUytvbTEvRS83?=
 =?utf-8?B?Um9WZUc2UGtXUTJCaE9NbCtwODd6WlQxeEorQlVTY05xMnVlWWwwYUJRS1lu?=
 =?utf-8?B?T25qOVlmaWl4ckZqenRSeW5iT2twZlJUY1oyN2w1Q00ra1BRV05VT3E5dnJq?=
 =?utf-8?B?SFhvZ2syWGliMmt3eHlzZTNNbGxlT01Yc0EzS01WbU00Z1RydVlST1N3Y2l5?=
 =?utf-8?B?SEpFeU1YZ203RW4rRWVVQ3VRcGM2WDI4KzlVN3pYQ2o3U2phaDNMK3hzVFkz?=
 =?utf-8?B?YWdiWm5NWXlBNnFXd1VsVDR6ZERvSEs5ajI0eGd4RnRuYmxYVzJZWGs0eXln?=
 =?utf-8?B?Mk9ENGt3Q0VvUTF5YVNLZnRRdXI2YnJGVTVTL1h5N3ZVYThPRytzWHNsb3FN?=
 =?utf-8?B?aWNYeSs3UEtNMWcyS0k5d29SYzJ3OVhNVVIzbEhkNVpadjE5VFlDK2xzZ1Ar?=
 =?utf-8?B?clM1OFRrd2h5TlZtWWd3SlRPRVgzOGQ3T3VwSWxRRU1FYU9BMTRTM2pLQWo4?=
 =?utf-8?B?L3RVLzRPeWxNTnhRV2ZKSUMvQ0tFcDU2Y0dmajVqR3JaTkNTOWhaUlRoYkIy?=
 =?utf-8?B?UjIxdGZhbW9HWm1ubkxUQmkrd3kyZThpazcrY3NyOWtmSHIwajUwREYzZnZa?=
 =?utf-8?B?ZGdpcWF5OG1sQVorWEhMWWJxV1NBL2dUQUphMVVZK3pzc0lhaFI3TWZNYWZJ?=
 =?utf-8?B?ajBkTktpTUkvUHI0cWtFcjUzeTFKSy9PK2hBQS93RlQzN2ZJQVJjOGxxekhS?=
 =?utf-8?B?Y2cvNGcwMjlBNTBHZWtzZzE4S1FwOUczaFg1a01NVXVyamhPOE9YWWZPSnF2?=
 =?utf-8?B?RGhwNFdGVjZyd2RaYWZJYlVzYUxXVTlRMXJwaGZac0JMelJReVAvOXlER0dZ?=
 =?utf-8?B?QWkzU3grenlLNEVDYWpqOXMxT2t6QmFaeUdWZGV5ZWxIdks5aWVQWTQvTDYy?=
 =?utf-8?B?WkcxNDFDNHJzcVpuU1Btb3pMRjZFRTZjTWcwa2VhbXZrcWExcnMzM1orM3FZ?=
 =?utf-8?B?a1QxU1pYUTI3ZHVOWkpoVnpxSU11TG1CdWkrSnB0Nks3MXIxUGx2ejhzeHZI?=
 =?utf-8?B?WEVDK0dnR21RaWdvZlkzSEs0VVVOTVoyNmpSUDJVV1VBUHpwRnNTOVJxU0FO?=
 =?utf-8?B?dlpDUzVUZWFjWmNDK284VEZkOXFZWGdXcEg3UTQ3SFR0WXdWUXFWNUx2c2Fj?=
 =?utf-8?B?NEI4bFpSSWhhVjJOVk9ETnE1UjJMU2VyMDZmZWNOeVdlVUZIYVZaQ29Namdp?=
 =?utf-8?B?ay80cTh4MlVIZHhqeDhuSlhBSFI1MUlhUGJKUUhJUTdXNEZ4NU1Fd3hybGZy?=
 =?utf-8?B?UmFiU3FqcFZFZnJBNFFrd3FubS9NblZFM1c4RS9qSnA0ZG5scG1IZk42QVZF?=
 =?utf-8?B?S1Frd0xQQndpRlluZDkxT1NrSlZHSlFtUGJPK3NpdWVWamR0WFdnZXIrbUIv?=
 =?utf-8?B?VjJWdDBGZ3RSZ0hPYXBjYll0a21sQ2hsNE1aU2RRZENKUHY1NzhsbWNZSTVV?=
 =?utf-8?B?RERRZ2JYOWM3OVpycGt6UktQLzlJMG5IM000bEdrSHErdjZteEFrUUpaMWNQ?=
 =?utf-8?B?RkVSeWpQdFRVa09wd0h3cGJCVVpPa1ZSZVhqVlFGbXBzd21Yd0djbHlqSURy?=
 =?utf-8?B?d3BRNWo1d2F5MHJXVzVkZm1HdXBWQ2lFQUNBUFVXUG1LWGROQ2lYM2Q2T3Rj?=
 =?utf-8?B?WmxUSEd5S0U1NFV4L2FPdURXMTRwMDFUUjFlT0hIVVpiTjdhM1UvUGgyOXg0?=
 =?utf-8?B?RHpTNTBBYWNZcFByOTVtc010cVM1YXloU2VNSWxmUFNzNVBOY0dyamNtQVdy?=
 =?utf-8?B?Wk5qOU1BejMrOU0zU1Voa0JzY1N5ZlpFYlIvSWhJbFNmVThZVWE4QVV0KzZR?=
 =?utf-8?B?RW9BWGIvS2JTRHdJdTRQaUxHQm80d2F1a2dlNW8yNGdSYTloQ2JSekhEem56?=
 =?utf-8?B?L0ErVmlnL050NUVLdEt1UVZhZCtXK1QybU9aNUpJSmhVTTZ4eWJodmltaitr?=
 =?utf-8?B?YkgrS2o4cy9LeENOYlFTSGVVdFEwVjFHSnRFM3JYZVdXSVZQYjJiMFJWR2tB?=
 =?utf-8?B?bkhjOW9SYUpSZUhCT29RN1JMb1dXamRLMWdJemY2RGVZd29JN2VaWVJvZG5p?=
 =?utf-8?B?Tng4TUZIbTBHZUJXbjMwYUxWTTlZdmtoQXZEWnlRZ0VOZEExRzVyT0xhZS82?=
 =?utf-8?B?bzYxMkF1STlIM1hPeDhWOW1ENkFyb2lNSDh0dE1PMUNUYjBRd3JNMlFVQ3NF?=
 =?utf-8?Q?PBtODdenR591l/+qSG?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: POR7WsEr6JC8EyJX124Yl2sTG63rxeaL7CTy+3n6BrkZ3XfYt0FaXXp0ZymJBcExLuiK0fFRjia/jveMPCC/4GU8MpWkyub8gbSUxxYY80pjWyPOGjXwsovtbVAHRaNnJbIIR/zToFE7dYnJmXwAMqrWUoci/nrSdYv2nMjaLcm9pAfTkiDYP6u1kPwteZHeCJCZjxQ7iCy7n4Vu0q6ob7xki7CjynvKgNDIuhag+dnvA5flWfVShfRD9Q9tNM/jzw/YKAYgyfkTkFbRqxHGiZIJRchk03yneCfg37AvAP9n1Ho3j3IY22thTnmvBnYEeU04mfC/4H39gLVTSbpQvw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 860270e0-192f-4848-0449-08debdb5685d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2026 19:06:37.0431
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 81P0LkBD1wmOxqfzDA4io1WEyseujkdwgvaNX1iR+IJWBVJH42iMvzP9uzcHirmZey97jVV9HZCiV7vthUEXyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7577
X-OriginatorOrg: intel.com

PiA+IEFwYXJ0IGZyb20gcGF0Y2ggNiB0byBmaXggc2FzaGlrbyByZXBvcnRlZCBpc3N1ZXMgaW4g
cHNldWRvLWxvY2tpbmcNCj4gPiBldmVyeXRoaW5nIGxvb2tzIGdvb2QuIEkgYWdyZWUgd2l0aCBS
ZWluZXR0ZSdzIGFzc2Vzc21lbnRbMV0gdGhhdA0KPiA+IHB1cnN1aW5nIHRoZSBiaXphcnJlIGNv
cm5lciBjYXNlIHJhY2VzIGZvciBwc2V1ZG8tbG9ja2luZyBzaG91bGQNCj4gPiBub3QgYmUgYSBw
cmlvcml0eS4gVGhhdCBwYXRjaCBjYW4gYmUgZHJvcHBlZC4NCj4NCj4gVGhhbmsgeW91IGZvciB0
YWtpbmcgYSBsb29rLg0KPg0KPiBBZnRlciB0aGlua2luZyBhYm91dCBwYXRjaCA2IG1vcmUgSSBw
bGFuIHRvIGRyb3AgdGhlIGZpeGVzIHN1cnJvdW5kaW5nIHRoZSByYWNlcw0KPiBidXQga2VlcCB0
aGUgZml4IGZvciB0aGUgUk1JRCBkb3VibGUtYWRkLiBTaW5jZSB0aGlzIHdpbGwgdG91Y2ggcHNl
dWRvLWxvY2tpbmcgcmVnaW9uDQo+IGxpZmV0aW1lIG1hbmFnZW1lbnQgSSBleHBlY3QgU2FzaGlr
byB3b3VsZCBicmluZyB1cCB0aGUgcHNldWRvLWxvY2tpbmcgcmFjZXMNCj4gZHVyaW5nIGl0cyBy
ZXZpZXcgYnV0IEkgYmVsaWV2ZSB0aGlzIGlzIGEgd29ydGh5IGZpeC4NCg0KU2VlbXMgZ29vZC4N
Cg0KPiBBcyBhIHN1bW1hcnkgb2YgeW91ciB0YWdzIGZvciB0aGlzIHNlcmllcyBJIHNlZToNCj4g
LSBwYXRjaGVzIDEsIDIsIDMsIDQsIGFuZCA5IGhhdmUgeW91ciBTaWduZWQtb2ZmLWJ5Lg0KPiAt
IHBhdGNoZXMgNSwgNywgYW5kIDggZG8gbm90IGhhdmUgYW55IHRhZ3MgZnJvbSB5b3UuDQoNCllv
dSBjYW4gYWRkIG15IFJldmlld2VkLWJ5OiBUb255IEx1Y2sgPHRvbnkubHVja0BpbnRlbC5jb20+
IHRvIHBhcnRzIDUsNyw4DQoNCi1Ub255DQo=
