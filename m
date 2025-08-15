Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA80191
	for <patches@lists.linux.dev>; Fri, 15 Aug 2025 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755272843; cv=fail; b=QkF//rOB4mySxZqQqyaz8GnMyFKrNgu5Gx9doXFkslkMQXfKRGv98F5FLJymZcB4yz3Ir9k9KPEs/ewsGsX0OIIBSxrVzw9TYItG3d2yZCdTN5U1WxytOGDaXBsyboGnlyJUgOMnlYDiAcLfyMo2qxMqgOrKNTSUEDVVVF9ORQ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755272843; c=relaxed/simple;
	bh=oNFSfr4/jY0Si5BuNp2C1ndCfRe5uxhtGXXA0HebJjk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q+VCMQQg36pk2wKccAHdH+K9j6qS39plAFlgqKm9PcXHcSzOL5PV2HxhusmknR689ytSU5Y1zS/dPfo/XkJY0BSIrPluKGVPi+OnHdpzF5M/ovt6oQ7Z+PrKlFDGx+EewDrxqM56uH4toNvtUjM2qJHD+6UqvHlJ2UBsj7Cqn7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l8wC//ce; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l8wC//ce"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755272842; x=1786808842;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=oNFSfr4/jY0Si5BuNp2C1ndCfRe5uxhtGXXA0HebJjk=;
  b=l8wC//ceXac591RN/3I6Y4wnGMcJHCYNcoet18gFD99/nn18pLT6+jhY
   gU/WzPXSQmePoFHxfRt/tlANDLdbBrhsNh+yWzcfL5T6xBOdK35FhEbhQ
   T+TstHEpZ2c0kscdzKTkcT3OizewALEpMkEU/mfJFDFrxMORMmI3gb+Xg
   XVINg2EURnmingt9bu5CDmNBIHKZuWwdhpTYg+8ANDUV5Y4/qy4z5fCBo
   /fLS4qVNzPIaIjQd1W4ADKgHqMsXn2fzByz5lTo48zh6ojN8GyidyjUta
   LDxSwG5gzIuO4r0w3zVptgq5C+r0Nyv9StFqiMT8OnMa3npGynq2NR4Pq
   w==;
X-CSE-ConnectionGUID: 7RJuFNKDRIKxolU/zRcsfA==
X-CSE-MsgGUID: jz3u57YeSx28lML2j59boA==
X-IronPort-AV: E=McAfee;i="6800,10657,11523"; a="57521174"
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="57521174"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 08:47:21 -0700
X-CSE-ConnectionGUID: hChcI+qESpWSAtAvpCZaEg==
X-CSE-MsgGUID: GCqO+VuYSGaDT6HsNrDnhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,290,1747724400"; 
   d="scan'208";a="171490848"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2025 08:47:21 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 08:47:20 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Fri, 15 Aug 2025 08:47:20 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.68)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 15 Aug 2025 08:47:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auZ8K/n866i+WHgwtxIOiGmDTkQoi3cikN3W59o4wkKr/NV2O4wwGsAtLgpjzBEfcFG0TXTPOr1khMHWcvwx7cAwahlonClnDjyybIsq3hmOQ1gAjajYx8YbeibprtZI0FWCwkYpe2X4Hgpnv+HcpD8vazFuODn6SU6k0F8mevxrV0z4vn0QG75RH9+mquIjL3nLp09646hWmHlMFco4ZXIdvwUWsk56wvDSz4YDbACh4zkMM8OtGntJMW/r7+WKfH4+wmkfVseH6R1OBmqndtF2aZ+KeCmQSt2JUypLSrbc1aDN1tyXnM0kicesGS2qmayB0p/mjWbP+5lM1JsR4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNFSfr4/jY0Si5BuNp2C1ndCfRe5uxhtGXXA0HebJjk=;
 b=vEQZZ22/ScDlngAnM+3zUpj/ezMmf6BcJDCoTxeeNPin/V563tcSYj38XPWDp1r7w/RhE9UuZadNJLt/gS8mqyQb84Sn4b2G//MryoTdkyCNxfe8ERsFl2dV4DU6tCHiDbgFRFhqsdCd8QAfnhnUHgWTAsJ9U5rWUMEhSOFowcoTanJcpgW3cP3hx0yUv2/1u7s6e8/6FxXYia3bVLebtginE6Ym+EtVU9mOFB6iRnpYHTvPvbh6v97i+SVKAZrNIdlPVc/CsBoaBfUxjbts+pRraRONxkxFKQPWhNViCCxQTE1dBZ0Q3MaTv/ZsgQi8kDd1sQiwNeNneSdhQLiC0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by IA1PR11MB6466.namprd11.prod.outlook.com (2603:10b6:208:3a6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.19; Fri, 15 Aug
 2025 15:47:17 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%4]) with mapi id 15.20.9031.014; Fri, 15 Aug 2025
 15:47:17 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Chatre, Reinette" <reinette.chatre@intel.com>, Fenghua Yu
	<fenghuay@nvidia.com>, "Wieczor-Retman, Maciej"
	<maciej.wieczor-retman@intel.com>, Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>, "Drew
 Fustini" <dfustini@baylibre.com>, Dave Martin <Dave.Martin@arm.com>, "Chen,
 Yu C" <yu.c.chen@intel.com>
CC: "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Thread-Topic: [PATCH v8 00/32] x86,fs/resctrl telemetry monitoring
Thread-Index: AQHcCuw1uJ+c6s9abkKfAjwTQIKC47Ri2J+AgAEH+4A=
Date: Fri, 15 Aug 2025 15:47:17 +0000
Message-ID: <SJ1PR11MB6083A9FDABF6F33456CD14A4FC34A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250811181709.6241-1-tony.luck@intel.com>
 <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
In-Reply-To: <c1d03d2c-9f5d-4fcf-91ba-dfe2c5907292@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|IA1PR11MB6466:EE_
x-ms-office365-filtering-correlation-id: a65c6959-0175-4a90-80db-08dddc130384
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eUVxY3BCQkNaQWFTbHJReHJ3Z0hvczBHTlBydzhNUTY2ck5ZMzBIUHRPUmJ2?=
 =?utf-8?B?TytLN1pVNGZBU1hWMmVmaHdnRGYxSUJyaHR0T1Nsb0tIdWxzTDlyOWoraDJp?=
 =?utf-8?B?OGtTaGd6djU1a1V2a1QyUWZ3bkdNY2lRTktySDA4TldjUTFiQnA4NmU1SkJn?=
 =?utf-8?B?cmEzWE5IQTNMOGlFYUFSRFFRemIxQ2hjdEd1Y1VNYVVJMzFJL2JMRkwzRmZB?=
 =?utf-8?B?KzRHdVJNeUZ5N3M1T2F3LzdlNWlYUU1Nb2RERlpIcTQ1K0x4UXY3ODg3SFVE?=
 =?utf-8?B?ZEk5MTdaaWwzd0kvNm9aWDhjRW5nd0J4c0lPVlRKSHkzM3gwWUtzWmJYdU5m?=
 =?utf-8?B?SnpKcDhiOWdjekVUMFU1MGNLZ2Jra2Jtd0dNZStPVjBON1BxSlZITnl2WnhT?=
 =?utf-8?B?YnFueXhySHNySGhlYk84ZFNldTVPM3I2RTQ0M2s3cGFZbkI3ZXFvbFlqMkpZ?=
 =?utf-8?B?NUR1c1pSbTZWUXZ5M3FtRW1tM21wL3JDUnl2a1hMZ2syVkRRaDdNZDVSZWIr?=
 =?utf-8?B?VkkrVTh3Nk5OdVBZZ0YrZ1BBZjZnWHdlRW5SaGhpdDRGVEZiRHkxNEJKMnpo?=
 =?utf-8?B?WEhYa1AwU2dFZVVyL3hzN3ZucXh6KzBMU2tQWThJakRZVkFzK2ljRGZxaUVy?=
 =?utf-8?B?NzFRUnhBZEdnM2kxN1B6aTYwOVpDcmNaVkplRkxzdGxxOWFZR0gxYjhXZnVy?=
 =?utf-8?B?TmJhS29qMkNnQ3A2UUQyNzVhRTgwdDFBOVFIQU5hOHNHSGJla0dpT1l6Vk5t?=
 =?utf-8?B?WGxkdm54RFZJY0xvd1lFMmlnQmxtWmNpUDg2T1ZaTXdHQ0xzQURSSE9Xd1JL?=
 =?utf-8?B?Znh0OHVNSFk3TDVXSldJOXNGT3pNaUUvQjdRWE1yQWtpaEhJS2ZsSHZkWTJZ?=
 =?utf-8?B?SWFDc0wxa0tlOE1lN1BPTFMyejJOUXBVN0p1RzlteUJrelVqTnRTR0VJenpt?=
 =?utf-8?B?RmRKSWd4Q3ZSRzZvdUdzTDMyb1hZTlFhTnAwbVZ1V0liMUJCM0RCSmFiTndT?=
 =?utf-8?B?ek11SmNqSWY1citrdWw0cmUyWUh2c1JFaUplSStCNXdGQWRNQjNmbFBualZB?=
 =?utf-8?B?NHRXOUZFbFlEejZPYXVkSjNGR2VraE9LM2ZyMVM3NGkrdFV3RUxuU0llVk1z?=
 =?utf-8?B?TmhESTJ4QlVuN0l4dlgwVmZ3T2k5YkFLYTFXM0d6Sy8yd1dxdTczdU5tcENh?=
 =?utf-8?B?VGxaME1IQkw1L1VqcHdvMk5VYnk3UDg0elRtdC9QeVBVNkdnTUdNS0Z3WWN2?=
 =?utf-8?B?SndNZEVhMDZtTmUzWENwT1A5SjlaOG5WK3BvQi9FYkJ2a2RyRkYwNWszQjNT?=
 =?utf-8?B?cWcxTHNjcGNUdmI4UTNweGl5ZEVvWkdvUjFLMFQ4TUw2bE1VTUQvQ1Jhc3VG?=
 =?utf-8?B?R1dBSTYwb0xhZmxBUE0rSlNHZlg2ZnhTakY0REJycWptQmUzdVBSZCs3VVZS?=
 =?utf-8?B?RHBsQnZTUHRidER6cDVFVjZHaWV4aFpINWg2NG1WbkpYc3oyMS9ScWd2cEQr?=
 =?utf-8?B?bE1kc29hb2Iwa1ViR3EvZkwyK0lFSEtGWWFEdkptTTBtK0F4WU9PVnNPUlpP?=
 =?utf-8?B?WWhidS9JVnpoQW13ZnNFd0k3Q2xpVXgrTk9Xb0NqVENDbStyTno2WHhKVFNw?=
 =?utf-8?B?NHNuanBRd1g1VG1WcmN1amY5QzRmVUNwWGFQQThMbmR3VGcveUtlM1FGdlpu?=
 =?utf-8?B?ZGx0d25yMENsQ2pld0dCS3U3eW1zY0kycGYwMlJUTzlBVUw5SFpmOGhpMkNT?=
 =?utf-8?B?eVVsUnJ5WEVXbTNsZEJ4K3RpYUJqaHFZOG4xaVpoUzVXeHREbTZoVHNWYkY3?=
 =?utf-8?B?eVA4bnRaZjZHQ0xCMEpMSm45cFJyaTBiTlQyWklLeUkzWUN2aURYMTBpZGYr?=
 =?utf-8?B?ZEpqcjNlL2RScXNHRHMrTmV5dFZkdVJGSFA0SUdyMmFFVEVCOVdRczZmSGJH?=
 =?utf-8?B?TWpKQmxmaDBrNDdZcCtEbXVKRkJPaWhiZWovUVZPK0NJcWRMS0RSTGhPMkZY?=
 =?utf-8?Q?X12DpN+tmwWnPudCpZxy5Rq4MsqdXM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFcyMmI3alRWMGlINDBFaHJFcGxCZzJUbjN3NEw4UnI0WjhOUUowdUJxYTVn?=
 =?utf-8?B?ektBU0RUd1ZFNit6QWF0aGtnc0NWeUdSU0pJd1NRZ3RLcjQ1OG5seVkwZGk0?=
 =?utf-8?B?T295eW1LZzZrZkF5dDJOOUJXa2JNUWJrSWNUb1g2d0NrNWlXNUpkeHVjTzFn?=
 =?utf-8?B?MEJ1ZTdBUGc1bkN1NXZGMkxwWjAyR2ZiaklUZmE3elJWeVRoMzhJSWcwR1Fj?=
 =?utf-8?B?b2R5TStkS25Ub3J5dklnVGdzdmFjL01TRC95ZENPaUJuZyszblBubC9oK3lB?=
 =?utf-8?B?SFZ4RitsZ25BcW15YzV6dGxvdVRtL0FHUkxjNGlrUlBZeEJYK1pMT0ZmWVZF?=
 =?utf-8?B?VktJVHEvS0dRd0ZiTUxvL25VZ0ZhcHFHUGptenJFWHp6RjN5cWNsTkJ6S1Ni?=
 =?utf-8?B?TmVuUkFrUHJJMUpzM2M4WmNlaEx6aGNBd3pKWkhwWkVDSWpyTVRNRU1EdWVQ?=
 =?utf-8?B?b1hxR0FIajZsRXMrRzMvT3VudEtpUnVSYmxvYW1HeWxmNHdzdUFua1dxWUNm?=
 =?utf-8?B?NmNHZlMwMXBCSElNUW9CYklueFJaTE5sdVY3RTdGVXh4cXFVUEJZMkRpRStm?=
 =?utf-8?B?dzgyemxCdGdOSCtHaHVFUWRQbmhPQThxZlNaU0YvSUEyWkhGOGl6RmEzVkhW?=
 =?utf-8?B?b2t4MDIwblV2MEVaSy91UVQ5YWljOEk5Wk5sTEZMeVNJby9Oc1F6RVYvSHJz?=
 =?utf-8?B?Qk54ZnVEeGVKMWlNU0kvTDZBUzBBUWtnVEg2YzJFRk9kMVNuUXp6RTM2MEJF?=
 =?utf-8?B?N2wrR0dUM3NZRHo3L1lxNjhzdjg2dUZmUWRPWXBwVW5PTDRDb2pnbmg1TUd4?=
 =?utf-8?B?OE8rdlRNOEIzUU0rb2FNYllYK3ZITDhON2daRWNwbDVlMzNRanowaUI1cXhK?=
 =?utf-8?B?YnZ4YWNNanI5OTZhenlaNXoyZGZ5bWtjNWdSaGRYOGdLNDZObHZNODZ4ZDVH?=
 =?utf-8?B?eFhpWHFBR2kzY1dsVnEyMER4TW5TeFJEbUpmaTRRM0UwMXdUVzBteFZHaWlh?=
 =?utf-8?B?YnRoZFpNd1NXbXBGbW9FaCtNdGJQb2dKcTVqdTI0R3NzLzBZaTdaMC9TSHZz?=
 =?utf-8?B?NmVUNDVhR1hUV0d4S3A2Q29RWGdySWZwN1NmWklhaHpLbHpDUENJV0I5RVVh?=
 =?utf-8?B?SURkTk5ySC96RGlpeWQyRGlRYjREd3AyUFA5aVoycjEwaGFGUUVXTy81TzBs?=
 =?utf-8?B?WWpqcVJxdUErQmZFbHZibXozTWdqUEVFRjJXUmY4VWc5MGdReFh3NDlKd1ZK?=
 =?utf-8?B?YjFWSzlza3BpdWxlbzV4eDMwZC91MWlkeHFRUW9rVmQ0QnJQNk93VzNrMUl1?=
 =?utf-8?B?U3ZRcUNyd0xKTHJQOFk5TGl2R3BmVXR5M3VwdFFCZzVVSG9wNENWdWdjN1Vm?=
 =?utf-8?B?REhmenRKWkl5cmdSVGNDQmhPMEpIT0w5dXpVNFVqNVIwd3FwZyt3Z2xqeXM3?=
 =?utf-8?B?cW1EaHdUbWxyWE5sZFMxT0Yra25XUThkb3BmRjZsenpTbHdOZktsRDJrZ004?=
 =?utf-8?B?MmozcUxFSE52WWo3YzBDNVhDd0s2V2lHZGZFUjIyOUo2dGZZOEIvUG5Qc2ZM?=
 =?utf-8?B?S0x2Z1VxUXVxQkgwbTVQSmdZRExhUmFqeXYwZTFLeHZNRjc5ckJpVlNhK1JB?=
 =?utf-8?B?ZG1Hd1BaY2xtcU9HSmxxemFWYzdrcndwUWNibXl3TmNRV0UzQU40TllqTk1l?=
 =?utf-8?B?VExocTkzcXhEb2NFNG51OXhEbXZtWU5lKzNhb1ZLZzBLWVNsSGs3dUlWK1Va?=
 =?utf-8?B?SlRBQkRKaEs4VlFQNHFvN0JYeW1hNUEwZmp5ajYyb2J5K3Y4emZ6cXNtcVJ6?=
 =?utf-8?B?eXlPSzRwaDRtTysxdVcyWU5JUXltTkk2SVpySHhCOTJwdVBKSEs4NFI2UVRh?=
 =?utf-8?B?MnQwc1cvUXg1bkZJSWJxL1ZOcnhPK3ZYRWdxMzBiTHh1YkY3aFd4c3QxczIw?=
 =?utf-8?B?cmZiRVlCdzJzcTJKQ3J5eUFGa1MzR0xzcDZ1aE51ckxmaTVUM3pIQkZ2bEs3?=
 =?utf-8?B?NWxKSUJMa3Vtam9lUkNGem9DMURXeFN4c0g4Qnk0SisrYVppS2xwbFZQazAz?=
 =?utf-8?B?WkNuc2RPZmpNUzNjaXlXdTNOdFFBVTFWOE5uc01taGMxazBxNGQxY1VrL2pD?=
 =?utf-8?Q?gN6A=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a65c6959-0175-4a90-80db-08dddc130384
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2025 15:47:17.7445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UK9uU4tClLAsPu07BFuSb6uOee7dMOZedao+5AfN4pLzY72EYqITeSk077DHN7hCea9iEUWrBiUEMmmnUcNZ/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6466
X-OriginatorOrg: intel.com

PiBJIHRoaW5rIHRoaXMgc2VyaWVzIGlzIGNsb3NlIHRvIGJlaW5nIHJlYWR5IHRvIHBhc3MgdG8g
dGhlIHg4NiBtYWludGFpbmVycy4NCj4gVG8gdGhhdCBlbmQgSSBmb2N1c2VkIGEgbG90IG9uIHRo
ZSBjaGFuZ2Vsb2dzIHdpdGggdGhlIGdvYWwgdG8gbWVldCB0aGUNCj4gdGlwIHJlcXVpcmVtZW50
cyB0aGF0IG1vc3RseSBpbnZvbHZlZCBzd2l0Y2hpbmcgdG8gaW1wZXJhdGl2ZSB0b25lLiBJIGRv
IG5vdA0KPiBleHBlY3QgdGhhdCBJIGZvdW5kIGFsbCB0aGUgY2FzZXMgdGhvdWdoIChhbmQgSSBt
YXkgYWxzbyBoYXZlIG1hZGUgc29tZSBtaXN0YWtlcw0KPiBpbiBteSBzdWdnZXN0ZWQgdGV4dCEp
IHNvIHBsZWFzZSBlbnN1cmUgdGhlIGNoYW5nZWxvZ3MgYXJlIGluIGltcGVyYXRpdmUgdG9uZQ0K
PiBhbmQgdXNlcyBjb25zaXN0ZW50IHRlcm1zIHRocm91Z2hvdXQgdGhlIHNlcmllcy4NCj4NCj4g
SWYgeW91IGRpc2FncmVlIHdpdGggYW55IGZlZWRiYWNrIG9yIGlmIGFueSBvZiB0aGUgZmVlZGJh
Y2sgaXMgdW5jbGVhciBwbGVhc2UNCj4gbGV0IHVzIGRpc2N1c3MgYmVmb3JlIHlvdSBzcGluIGEg
bmV3IHZlcnNpb24uIE9mIGNvdXJzZSBpdCBpcyBub3QgcmVxdWlyZWQNCj4gdGhhdCB5b3UgZm9s
bG93IGFsbCBmZWVkYmFjayBidXQgaWYgeW91IGRvbid0IEkgd291bGQgbGlrZSB0byBsZWFybiB3
aHkuDQo+DQo+IFBsZWFzZSBub3RlIHRoYXQgSSB3aWxsIGJlIG9mZmxpbmUgbmV4dCB3ZWVrLg0K
DQpSZWluZXR0ZSwNCg0KSSB0b29rIG9uZSBmYXN0IHBhc3MgdGhyb3VnaCBhbGwgeW91ciBjb21t
ZW50cy4gSSB0aGluayB0aGV5IGFsbA0KbG9vayBnb29kIChhbmQgSSBiZWxpZXZlIEkgdW5kZXJz
dGFuZCBlYWNoIG9uZSkuIFRoYW5rcyBmb3IgYWxsDQp0aGUgc3VnZ2VzdGlvbnMuDQoNCkknbGwg
dHJ5IHRvIGtlZXAgKGJldHRlcikgbm90ZXMgb24gd2hhdCBJIGNoYW5nZSBhcyBJIHdvcmsgdGhy
b3VnaA0KZWFjaCBwYXRjaCBzbyBJJ2xsIGhhdmUgYSBzdW1tYXJ5IG9mIGFueSBhcmVhcyB0aGF0
IEknbSB1bnN1cmUNCmFib3V0IGZvciB5b3UgdG8gcmVhZCB3aGVuIHlvdSBnZXQgYmFjayBiZWZv
cmUgSSBwb3N0IHY5Lg0KDQpFbmpveSB5b3VyIHRpbWUgYXdheS4NCg0KLVRvbnkNCg==
