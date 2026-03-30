Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81203374737
	for <patches@lists.linux.dev>; Mon, 30 Mar 2026 15:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774885827; cv=fail; b=fxOtJVP2+2j5gB93Ig2/0tj7PZm4ze/Qy/5VSCci5EYvohoz3pqVByqELPbDTLbE+wiFlwDq3HSJlYSlVyuwWXfPpENJyDKX+/RWrwYOO4GCJZFy3GEo/3j2wJAG/afz8mg0fXcdRaaPs+XoaAXNU5ylBd/DsPqMAINCAq18n3A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774885827; c=relaxed/simple;
	bh=frFU0nNqKuk4aJ6AfCL9OFki2J5/eLu4Qj6E/VAHTEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rqi3QdCn306g4tBc489iFL56wHjoo5a9y25J72rzjWX+7/8ozC8CCHcRiuUm+37bY2RwOTWKO+iAQqqro/ENBwFUpC4D6T/Sam91ZdWvEhtH6Bqg7eO53KB0k6cAJsKtNNuF3ddrcAAA9Qp9b8IHrk5pMcDP//V9w62v1U8lIIM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lRdLQcLb; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lRdLQcLb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774885826; x=1806421826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=frFU0nNqKuk4aJ6AfCL9OFki2J5/eLu4Qj6E/VAHTEc=;
  b=lRdLQcLbcOA2Loq53Iyouigv0cFeX246pdyn2xI/J3ph+UcFOrTHGz0K
   80qg0DiEYnuG/jk/tlwEODf6r92dDUqT0Z4RKisKsXdci0NIWV9kQWXuE
   TMLX0o7pDlxQ0YFB7BqCjB7TKA57LZ74rXJkLGgBgM5yiyrDm9dMevPFe
   22rVbhsyaxXpTC9HjF88UDYKPhzbQEkiM04RB4hImrdQFfj/gnE4LEQnS
   aNDW+ONitDJ/z85i2XcbHzKeUj0Hw17nGz0x07pj1ukX2qbaZdv8ty+Dj
   vJE5n4yzGx5X/eLv4PWrNkIdjuF2NIhuvKjv9FDm4iMF6xEN+8IHwqPJY
   w==;
X-CSE-ConnectionGUID: Jvq6fREyTgWmeT6/Q8iyLg==
X-CSE-MsgGUID: Mpary2X9RfGEAFBzl6MzIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11743"; a="86501851"
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="86501851"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 08:50:25 -0700
X-CSE-ConnectionGUID: 9+tJT8DZSGabTnFNsZSHgg==
X-CSE-MsgGUID: 4AjS/IjxSGuogCmyAsXTfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,150,1770624000"; 
   d="scan'208";a="226346852"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2026 08:50:24 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 08:50:23 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Mon, 30 Mar 2026 08:50:23 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.52) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Mon, 30 Mar 2026 08:50:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpffS/+pJ5GyRDRuI1Ac0BKtav7IutLKHg5lQ83R6BICArydfapTAPFj7B7ObOCKpXA83qgxrraR4LDYvUhHSE18eNEG0pUzvqCrKNvz0bxQfElLPK57uHXQXbS9sontf0XORwplYhwDUvwUraBSjs8QDOvIUBeiesXcsGivkzsxF/ZaUroAUKiPel7tuDbuhlIGP788kUd3VuWelugmihxDF+desYq4y3pWia0Pz1awD2s/euBB+MXZL9a5KGjkdZtO7QlxI9EcqsQ0pN1tuSuHyVTdvy1EGEFTQ9NbsfHPXatBcRxJ2+JSSoul4+ZTw7pR6pTWxennfMzHfcJ+JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frFU0nNqKuk4aJ6AfCL9OFki2J5/eLu4Qj6E/VAHTEc=;
 b=eI2pXjM1GGMjOSm+sCDIBhRrgcCvqu03YAm/2FHpUxfR9kIme6lG5mr47GDb/7aq80qVJTW2UI+FTF/kp6NI3uAONycWkoi//nZk/LRWQRY86KS+J4JIGe2XHhkrldDA7pWXlrELOoebnviSMUzHPId5Mu1McH961JuQEicwmmJeTs7xzJtOAQQE7DLugqmL8SPTfxyDAfI2QMT6VFbZrMw2NbccTKeA38ponf2UHuk56AfIsQoOHsgunujsulVrIGv8rnqAC/DHV60TgSu6Pjcs634iavKRLICF8T6Kz8vzzYgI6pmhDSf8iw9CtZAhpLZPgcJ9UHp/9D/SjkkbJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CY8PR11MB6865.namprd11.prod.outlook.com (2603:10b6:930:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.7; Mon, 30 Mar
 2026 15:50:20 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%7]) with mapi id 15.20.9769.014; Mon, 30 Mar 2026
 15:50:18 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chen, Yu C" <yu.c.chen@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Fenghua Yu
	<fenghuay@nvidia.com>, James Morse <james.morse@arm.com>, "Wieczor-Retman,
 Maciej" <maciej.wieczor-retman@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, Babu Moger <babu.moger@amd.com>, Peter Newman
	<peternewman@google.com>, Dave Martin <Dave.Martin@arm.com>, Drew Fustini
	<dfustini@baylibre.com>, "Box, David E" <david.e.box@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH v3 3/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Thread-Topic: [PATCH v3 3/7] fs,x86/resctrl: Add architecture hooks for every
 mount/unmount
Thread-Index: AQHcvj3c5vYhJyO6skicWPJ9/UeG7LXFbTGAgAHOdDA=
Date: Mon, 30 Mar 2026 15:50:18 +0000
Message-ID: <SJ1PR11MB6083C76EAB7D6A3EC96754FAFC52A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260323163452.25044-1-tony.luck@intel.com>
 <20260327230208.18094-1-tony.luck@intel.com>
 <20260327230208.18094-4-tony.luck@intel.com>
 <7323f542-8e97-40f4-bb32-728d79b48025@intel.com>
In-Reply-To: <7323f542-8e97-40f4-bb32-728d79b48025@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CY8PR11MB6865:EE_
x-ms-office365-filtering-correlation-id: 40549b69-1bc3-44e5-9ed9-08de8e740ae8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: OS6WrF5uyh4i1GESH4uF43zlskeokelwO1kwMikP0Hl267hcCEV0DKvlP2Owt8ZrDmo6dVjMSZ+WgKC2E7rLNSi5HZm2TwoVgwQrfQpwU+I6JRmQ7QusJwkjRLy3eLwiDM7EJJipg5bhGkMQjXdN/c3Z9S5tw/qo1tZEpTCLloXSdCquwi2g16aC9id8IfncmXXamBL7G/8nXSlwecSqnZMige0/vTJ0wDve6RNcVtvZ/PUbWO/JeG92mA0aeSFeGtSAgALvM/39ZRY8LKatG/P/ELgZf2Uav+WmqsL2+ILN7dnXHenACRe/4Ff5paE+URWiQ/abV3KD0BHiPKCbD8Tfr2dQbdaYrGRAjSXnpkd0UR959BEW4gesIhuHkDRHt2ZEdl0LW1GE2BKQoLmh2h4IXnAuozu5/wswGXkoccdnJ58vSwbEUonN1iyhev3C2PD0HUykcM63Kz+sgwcxhZ0X/373kvbFwCOrH26DA6dprAN8kPTeH13DrAZXskahuKcvR+dgii8+hBHcXAAIwdFqENOdJjR61kVbKy6PVJv0RhshVoUIh5YaPAfpAWHyRLrfQ/eOsP5aDKnzx4qLWSgPAXIhC6fXJRiPhAi9NaA5XCsrkNs1TV1ggPRNm6fZ6+EMR5NscaEw8r6s3VMu5JFadjMKnG9wdxL1rEysIMkpOq2r/mnS/i4RBnIG/J48aZ/1NLHqo4Y+LvWJw54oUSBZXWWNCLAL+4ZDs114HxNPLJD0fgTI2bttC92m1ZLrZFQ/6yTSHXXp/28mVH3xmLgXLh4f7vLN/Bz2bMriCdM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?LzREYlp1S1RZU1RRVW91ZmtIWWZLeHJMYnZMRjl1ektIMkkySXl0eGduNDhS?=
 =?utf-8?B?YlErYkpoa0J5aDJYSzJUSU9JcWFmbWg2UjBMUXc4djFJZ1hZSmFsMWJXUVYw?=
 =?utf-8?B?NzZVVzdoNnJjcXlDSW1nb1llN2ZxQnpCcVlaQVNIb0o5UlZBUld4R05Ib082?=
 =?utf-8?B?OTNSZEdEUkpZSUJFemNKRUV0aUVTOVRudEt3ZU5OSy9xUGpzaGJzNnJXQklS?=
 =?utf-8?B?MlkxVWszMnZxZU9UKytGTjhIellubzkra1lpSmxqTXNoQXRkZ0kvSzlQSzlE?=
 =?utf-8?B?ZDFKVElMbHZFdm9rclUwRGZtcG84SkFWUGg1RWxUQUtkV0lnNHhVSlZlS0o3?=
 =?utf-8?B?TWpLVWZhRWxCSGpLL2Y2SjNKWWxRUlFneXdTZnNIMlZOTWlmMzVheWZVcS9T?=
 =?utf-8?B?UDZJRGJIclB3RjBpVFJ1NjlWdXZHa2FIQVV3Vms1UWtTMXUwWFY0YWFHaXVL?=
 =?utf-8?B?by9QY0ZNaEhhcnE0ZUxERGIzbGJuV0hHZm5Rd3JRV1J2Unl0c1dMWStLbGlo?=
 =?utf-8?B?NU1tODk4bVExUkdLVFFuZkE5NmVBdlZ3dTZYWCs4VTdDbkxrbDFWMWttU3ZR?=
 =?utf-8?B?aFdHUjlsZ0NyWnhvcnZFOThqaUNKZDNZQ04yTXVKRVJobGxNSzRQdEZpdHR6?=
 =?utf-8?B?TEM5TXJBT21QQzY0a1hLemhMaldpaE80NUxjSVd5VmlQUmRZdjhtc3JncGFP?=
 =?utf-8?B?OXJpL05xRy9FK0dHaXdwYzhhbVFDcGFTbVlOU285NDhPcGJWenh2YjBsbmdL?=
 =?utf-8?B?Y3JmMkVWcFF4M0JMZ3dvUlhQa3FseWZhdGRiWTIxeDRMR2FrNUdKK3RJR0FR?=
 =?utf-8?B?RW1WVk15ajl5U0tUZFpwVllVQVNiTUNlQm51UnUwWThVV0xiOTJKdEk4MXVX?=
 =?utf-8?B?aldMVS9oNjZYSk5iL25FNEZZT2Urb25CcldLSHh0ekh5bTlvRG1nbGhjTVN0?=
 =?utf-8?B?Ym9WbkdmQmNqM0dwaXhPaVMrWEJ3NVIzUnRXYjBrUUl4aGRVT09qRGsxUGJ0?=
 =?utf-8?B?ZVNxTkZHM2VuaVVZTDFYSFhueTdGcTFJYVVUYTFTd3cySU5ub2hreW9HcXg1?=
 =?utf-8?B?UFh0NkZra0lmSkIwRkNxUlR5cGxvR3E3WWpyZGYyek5ZVUVtOHhLRDIxY282?=
 =?utf-8?B?QVRDN1FPSUxHV3c2VWE0aGlETkdwVEwrcVE1OW55WFQyd2VHM3VveDlCN2RN?=
 =?utf-8?B?MFJtWGFWZldLbis0b0FxclVZbkpzZkZ2QXY4UlJjVWdSZm04QmtoNjgyWGg2?=
 =?utf-8?B?N0RMZjNPelQ4Qm1qc0c5NnNmdWdCWWc2M0dZUHVPZ285WEtWY2IwU0V1RmtL?=
 =?utf-8?B?THBDSnhPazV4MTRWUEZoMmpCSmFLNTA5eFk4cjd4RXRzYTNXVGJFa1VkZnUy?=
 =?utf-8?B?RUI1T245L3B1TGZnbStRWGJRY0dOQkdhRlhzejUvbW5XUk9FVjJoOHdVNkxH?=
 =?utf-8?B?RFVxR1dZRGhzUk1NbkY0R21MMzhPamZjYXpFNjg2QlgvR1lSNlg3Y0Rzbkta?=
 =?utf-8?B?Y2NNU1VIR0VtZFliZU1JdDNYNy9SMTJ0K0ZGcTFTVGx4cTFITXg0RlVXc1VC?=
 =?utf-8?B?UnBoNzVLeXlPQVZ3SWRVaFNONTlSNUZaWHorZVdmejREM05XdzB4SU5FSThS?=
 =?utf-8?B?V3pmWFQyYytpbm1aeW5iWkJMUzhGTGxlUEo2ZzArYjdzbDhlL2RzbE9qbFQ5?=
 =?utf-8?B?OFkwSTF1N3krVTl5bDlaYS9vUVNFME9kejB2YVlIMDZ5UDU3U1pMTGh5MU5o?=
 =?utf-8?B?eGJzbytoYWd4WXpRS3lUZ0p3eGYwMTNXaFZNMS9oaUxpb2ZJaGQ0ZnBRMUVu?=
 =?utf-8?B?OW00Zk1ScU9QZXA3S24ySDQ5YXhESWdmZnJlSlVaSFZXUllRYVlrcmRNd280?=
 =?utf-8?B?bTVHWjg4UmJmU1o5WDROZVFiazlEckFNeEM2MFJmVmFDZnoxWGwvc0NzZU5u?=
 =?utf-8?B?eVZaOE43T1FWaEhHdThabFRORFdzTzl0bXJsNzBmZjJtWWI3SGpPemFzODcr?=
 =?utf-8?B?VTYxTElYdkZPb2pndlRmOFpTVWFQekFsYnJQYXd4QjBpVVZXVjlGVS9SeGFs?=
 =?utf-8?B?d0c5TVBsWlV5b0pUM1VESHN0WWN4ZG80K293bG5ZUXNLVk14eitYTVg2WnUz?=
 =?utf-8?B?U3BQWWJwUUdKVFRyemllUWZod0V1NEhYWUpZSWIrQ0RHY005SnVPY09XTzhs?=
 =?utf-8?B?aFc4VllucExEVG9IczByVFZEQ2VYZE9tS3FVNnZrWU5FR002M2NsQTlmWGdo?=
 =?utf-8?B?TVlmNzJjaVZpTlVyTERyKzV5YmVldjlrQTRna0lydGxPTTJvZnlqTmVKZ3RC?=
 =?utf-8?Q?DBPXEvvfY/PfaDa3VZ?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Wa2R0zczvwnk60qsVD6ptylx9lpyo68wl8OvPo5Hdi49TRd06Ju9gIyQh+qJ+4ov7DMa1hi+5dxNxVqAaIOiXJs//7Oe0w8SkzaxG0IT+IRJMBZf+pqVws7y2OsN5MzPnQ/jWJ+xPl9ef+CadCHC8aX0rtNZTB2sr5cxwraz+sRVqx/P1rGWYXW3pefC3eDH9+ioNstEsNdoMfdL9JQgDLkB7DqinqrldRvQb0Y0ywiX6i4wbM+hXgvOpNHZ0Y3uiqDgZpNytzskxG5+XsB0GCjUYCiO3d1b10RGiUqiya/9WlWH5RSJHEbjSgmtXB3DHHUTrPe/MPhekMwsJqT9OQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40549b69-1bc3-44e5-9ed9-08de8e740ae8
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2026 15:50:18.2807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DWN+EY7HwLiY1XgXhG3rAYcDV8nlvUDTKjv/WEm/RPR3mLx4NgPmE1Yd6sfZEer/rWEdq6yaQKFQhDTYIEkTkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6865
X-OriginatorOrg: intel.com

PiA+IC1zdGF0aWMgaW5saW5lIGJvb2wgaW50ZWxfYWV0X2dldF9ldmVudHModm9pZCkgeyByZXR1
cm4gZmFsc2U7IH0NCj4NCj4gVGhlIGRlY2xhcmF0aW9uIG9mIGludGVsX2FldF9nZXRfZXZlbnRz
KCkgd2FzIHJlbW92ZWQsDQo+IGFuZCB0aGUgZnVuY3Rpb24gZGVmaW5pdGlvbiBzdGlsbCByZW1h
aW5zIGluIGludGVsX2FldC5jLg0KPiBOb3Qgc3VyZSBpZiB0aGlzIHdpbGwgdHJpZ2dlciBhIHdh
cm5pbmcgbGlrZQ0KPiAibm8gdXNlciBmb3IgaW50ZWxfYWV0X2dldF9ldmVudHMiLiBTaW5jZSBp
bnRlbF9hZXRfZ2V0X2V2ZW50cygpIGlzDQo+IHJlbmFtZWQgdG8gc3RhdGljIGdldF9ldmVudHMo
KSBpbiBhIHN1YnNlcXVlbnQgcGF0Y2gsDQo+IHBlcmhhcHMgd2UgY2FuIG1hcmsgaW50ZWxfYWV0
X2dldF9ldmVudHMoKSBhcyBzdGF0aWMgaW4NCj4gdGhpcyBwYXRjaCB0b28/DQoNCkkgbmVlZCB0
byBleHBsYWluIG1vcmUgaW4gdGhlIGNvbW1pdCBtZXNzYWdlLiBPciBmaW5kIGEgYmV0dGVyIHdh
eSB0byBkbyB0aGlzLg0KDQpJIHdhbnRlZCB0byBzcGxpdCB0aGUgZmlsZSBzeXN0ZW0gY2hhbmdl
cyBmcm9tIHRoZSBhcmNoaXRlY3R1cmUgY2hhbmdlcyB0byBtYWtlDQpyZXZpZXcgZWFzaWVyLiAg
QnV0IGRvaW5nIHRoZSBmaWxlIHN5c3RlbSBmaXJzdCBtZWFucyB0aGF0IGFyY2hpdGVjdHVyZSBp
cyBub3cNCmNhbGxlZCBvbiBldmVyeSBtb3VudCwgYW5kIGl0IGlzbid0IHJlYWR5IGZvciB0aGF0
LiBTbywgSSBjaGVhdGVkIGJ5IGJyZWFraW5nDQp0aGUgZW51bWVyYXRpb24gb2YgQUVUIGluIHRo
aXMgcGF0Y2ggYW5kIGZpeGluZyBpdCBpbiBuZXh0IHBhdGNoLiBUaGUga2VybmVsDQpidWlsZCBp
cyBvaywgc28gYW55b25lIGJpc2VjdGluZyBzb21lIG90aGVyIGlzc3VlIHdvbid0IHNlZSBhIHBy
b2JsZW0gKG90aGVyDQp0aGFuIEFFVCBub3QgZW51bWVyYXRlZCkuDQoNCi1Ub255DQo=
