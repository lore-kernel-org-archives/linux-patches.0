Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893CD3B6364
	for <patches@lists.linux.dev>; Tue, 25 Aug 2026 18:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787684136; cv=fail; b=s8FAWsAzua8g0Xd1QdZB3iwvYm6Glr5zv5ONX9Cp1DvwXGzJTJrKI5f0iQTNFcMmZHKBCbvFugai9JaYslgz6RrKAjQfqCEMhs62V+nlHQ9mtKeCY0UGzOLUgTTtbqAx4qnqPrcobxzAubWuzaBap/czV9TCYE4ilv+oz2DRT3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787684136; c=relaxed/simple;
	bh=5ahY66JZD3uUPe77e+liBbetDXGhX3Ec+KScm58LpiA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dymmXzXO6Pkr+/X7HEKg7ohm4FY8eBrLyfLeXZXLw9SEbIcY/nN5XwEIDnBGtwHi9p+xR5splVc7MjAvfWc8da2OI4qWE9XbHN+1bAvCK+WDeXAjIlH94Ov2PyQUM7fpDsWnvczvvppZLDsrtMooGZwvl2jMm+ti2+7EODpZHL4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YoK7xYCc; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YoK7xYCc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787684133; x=1819220133;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ahY66JZD3uUPe77e+liBbetDXGhX3Ec+KScm58LpiA=;
  b=YoK7xYCcD/y3hQyIsfi0Nc9RAoTfKYoRxG3g1Q0u0wGX/TDVr5jopYhG
   W4m6yNJl8BRSckGaUYFm0AvWXOvJTRpRdNX7EibD3OE3Cq1yTnB+RU2w5
   8NtOEaWxJcp0FYmkj5FAA22NCZ60la5B0BXAwPm8J0EMvhgfEEn1a47Yg
   TPKBvqu6Didj15o17DpEb9V/B5Et4WMuqEITMD5dFs0OvKfi+2ZIbj3Tv
   xQtmAToqOnfhxj6D6LAi/lOEd0yPCjdTyrU/YXRq+U9aR94wDhbkL+b8k
   jvg05sESClBs37pu7c6l+APNV0FEHJGiwE8z9YjatFtA1yvsVoXBIxHlB
   A==;
X-CSE-ConnectionGUID: 2l8ohMEeTlq8djfOPh3vog==
X-CSE-MsgGUID: 91PMqWqMRjCEcQN8fXl24g==
X-IronPort-AV: E=McAfee;i="6800,10657,11886"; a="90673054"
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="90673054"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:55:32 -0700
X-CSE-ConnectionGUID: njuRlxItSqyZ404uDN2Yqg==
X-CSE-MsgGUID: aATENSksT3mQOZMyOugHtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,243,1779174000"; 
   d="scan'208";a="263070008"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2026 11:55:32 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 25 Aug 2026 11:55:31 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45 via Frontend Transport; Tue, 25 Aug 2026 11:55:31 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.66) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Tue, 25 Aug 2026 11:55:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MJA+uCzpeCUrbrurMpPYV40oM94Bb6DNGimjLRqdepTDX+9obnb/byJTFABTqXWfx2ABNxlGdWcpHcxLRFEbR+6ZSEezaDZJMofrQBjVzIT7P7V0+VzM2Jco334QDI8eG9VsmMYGQgONVjcWkgygu+lZbLagVeORnQP8Ane39L3dxJlT23X5N04j7Cgoiogm/UU/KnWd8wZ8ibIeAo5DJ0GQA78lppJKSXx2D5U3VAALD5Tcbxrwk5iJ2DBV3GHo+BC2/Y6CSdJBx4lpWqdnlY22tUfnkVCIzBH5SRsuPZbSY1wxZZONBEBm6yg2jueLUd0AHQpjJu5mEqakXxts3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ahY66JZD3uUPe77e+liBbetDXGhX3Ec+KScm58LpiA=;
 b=FZrzdKJWpbixVHedZ1dWcAIXfj0lX54JSJ4XzrxWVuHYpisAnq1wTYlI9ACfyLwdVKIuEZ4xvzJD5TClcbYYyRWc6Nb/jjE+hfi7bchMYBVXm2TU36OhVoInANDHs5MN/fXJvhcoWWlzOY28xeYvOKU6ulkPI+mVAbTURpoyBldywySO1JV+2n3m4JfQLEqIpaR4n12aaIFKblZsufJHjoJGfj/pp6xJwrDftvmLeVFgNVTHcN29t8Lz4OdMWKbw5nf+EirtUvR8eE5ONh985vJzyqhtGJSqhtlHaD0zBOk/YFs+NPXWL0jVqbrw/OTgav/FmvrIpyFPyWSG2bruzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by PH7PR11MB7988.namprd11.prod.outlook.com (2603:10b6:510:243::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.6; Tue, 25 Aug
 2026 18:55:27 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::3454:2577:75f2:60a6%4]) with mapi id 15.21.0339.012; Tue, 25 Aug 2026
 18:55:27 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>
CC: =?utf-8?B?SWxwbyBKw6RydmluZW4=?= <ilpo.jarvinen@linux.intel.com>, "Hans de
 Goede" <hansg@kernel.org>, Breno Leitao <leitao@debian.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH 0/7] Intel platform driver to reset bitfix filters
Thread-Topic: [PATCH 0/7] Intel platform driver to reset bitfix filters
Thread-Index: AQHdNL3KBG0+Aye9xUOF/Z8XSC4le7avFbKAgAAE30A=
Date: Tue, 25 Aug 2026 18:55:27 +0000
Message-ID: <SJ1PR11MB6083BCCECCB6C5037B0B2B62FCAF2@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20260825181526.13203-1-tony.luck@intel.com>
 <20260825182857.GBao3e6Qv_Xg0LCXFM@fat_crate.local>
In-Reply-To: <20260825182857.GBao3e6Qv_Xg0LCXFM@fat_crate.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|PH7PR11MB7988:EE_
x-ms-office365-filtering-correlation-id: d6b977c4-0a20-4111-388e-08df02da6d9f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|23010399003|366016|10067099003|56012099006|4143699003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: 4ztmBSd3eAIKDF7rXtpXqFonqfLH5N1bLFtR5gmEnEg7dj5iUAUqWaIi2Sbh7U/1uaRfNeZIYgdad2AsApX9zSKiDkDRCECb1V+TZTJ04M7bb1s38urHZq6NeF+IFvJjKATvZ4NAY7iRWEB1yO9d99RfYOfJhPwn8MBKM3N5LJxTdoERA6ttOjSdeHl+l/QfjQ3lG3m+X1lWwwHa1vBbfNdXvjQsbKyCJuvXnZFRBcWHXHigeMgXtywBkhV/+++orO4gP7qraXW2IK0/zMVSLYQUeLK2zsWxFFv9refsRX08Vjl+fc/lKAZjWeQ4lS0urdnpw1VjgyWaO4ruE6V+MB0b8Z8mWAc1LKHPhSDQKcCCWq8xQEwCDQjElzuJgJDEMXJ9Rk5sPWQROfcoFsumYPTSqbQ1LtRRTgXC03Q4j8CfGG2ee9JgltCSuFyqO1Z+y6EwWnvftnBAKPfFc/yhlDDu2MC9S+4TZwiknr9kjfVm4aGGlmi2E3sKmu4MF+TPo99JxAb1Zy+KD0J4UPL5NInc2YDY1Zyfr1afwtiLQPRNl5yOdNNKW1w0jo2+1aJtQSw7nR/PlBFFBzEPT8AUUOjvIVpNHvi9fWyd30CwY9VJzu63pcNvP69jzT2XLi8SsJjTcIo7+oBoiFcBk0YVWSdvMhSSpjI8h1nrhK/IjymPPUKemwE80ZBIIPvIvkQZxBulLJ+qMcak7BlkdCnBgtSdBf3iM3IVOvWdSkTbqGE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WlRZbW9EQ09jb1N5Yno2WWVYcEFtNHU3TGlVTEhMdldUb0VSeDBrM1ViUFds?=
 =?utf-8?B?amZDMmE0bDBrdFY3QnJFb2x0dGIxeUkyUWN1UnJFdDFzSFlUTi9MQkJJRGY3?=
 =?utf-8?B?SHRwcE00U1o0T0hWazAxSmlBVFlHNkI3Y2phVnJweU5yZDM3VmhzRFE4OGNx?=
 =?utf-8?B?bWR0L1ZwdGtQaHlBbTNaVWZtRTZLSW5uZEUwaGVtaWtxN3VYYVorYmhCZnZL?=
 =?utf-8?B?ay9PaVVDL0pvU0UraWtSOU1KNGxNRnBsTk40emxmeXU2VG5ZU09kNnplN08z?=
 =?utf-8?B?MnQyYmtPNWJSRUhKRlIvcDVOMkVRT2M1SEpIdTltSlQ1Ym9UOEd0QzJMaCtu?=
 =?utf-8?B?aXRna01idHZvMXVRdW1sSVhJNFJneFNNaGtBY0NkL0JLNXo1OGtBZUY4cHRn?=
 =?utf-8?B?N1BlREFjdDRlNDQxaTBOTThaMEVpdXA1NlNpZGwzRUZuNHNOZ0lJdHdIOVVh?=
 =?utf-8?B?cTBTZ2xKR2FCOHE3bzVLL0ZOSFl2ZUgwcmM3NVpNV1I0cmF0TXNoMG5YZGlO?=
 =?utf-8?B?YkduKzdiN3FFMmM5OGQwWWxXVytQUjBTZmFJNHQyOTJiS3dCVUEvL05UQnZm?=
 =?utf-8?B?d1A4SDNsNXE3bHo1Q2xnRXJpajR1WXZWRk1waU9qenB1Z1pUbWRoWXU0akpI?=
 =?utf-8?B?OURiOTZabDE0WE9FdjRMRXZDZWI0M0d0S2VVK3pJZWdwcFhFR3NZRGNQNXpO?=
 =?utf-8?B?N3huU3o4YUw5NzZOQWdRT2ZXT1BWRHV4eHl0QTZVR1BPSTJTMFpJS1VkTXdT?=
 =?utf-8?B?cllUQmFSSUpVKzdtZzlUZ1FYWjZzaUEyUEs1QTNRK3dUNjgrQ09jcm9tR3FG?=
 =?utf-8?B?S3FrcDFhTzJuTk1HZ3lPd1dkZmtSVzdRR05YYWFwM1IxMStMU1Z3QnU0b25x?=
 =?utf-8?B?NzZDU28yYkx6OSt1VmJNSU9idlZ1eS91a3RURTFoY29KazBQRXZGRnU2YzMx?=
 =?utf-8?B?c0pET2hUNk1DRlAwdjNIMjFyMkQveE5RUy9Xb0hNb2R1aEdkaHNtTlF1SjVL?=
 =?utf-8?B?MUtwa090T3hML2IrVnExd0JrU0JGdWVrL1JrbDluVlA3dXNGWXpXRmNpTklX?=
 =?utf-8?B?bWt4Mkx4bklTVFR2UFhPcTRvbWdTeExWMFRSeTFwa21mTlorS2l3RDE2MUhy?=
 =?utf-8?B?emZOQWp4SDkwOS82bTFBbkg1Z0RxRE9NT0lJOTV5QWhIcFEvVEhjZ2JKKytC?=
 =?utf-8?B?VXo4a01oekFrVTQxOTNCSGgzSHp5d1gwNmlUWmlkbEd2eFM4RjlJYjFWc2RJ?=
 =?utf-8?B?cERvTmo5TmRnV0dObDdkUjJac1F3aWUzZ2d6NGlSRVhXWTNTbE1VYkVzeWNu?=
 =?utf-8?B?R2dyQm1SZWIwbElJT29PMTU3ZWgvQ1BQTm95L0FiQnVxTm0yVzM4dTcyVGlN?=
 =?utf-8?B?VW5rSStzRDMzU1l1aFAvUnJxUnQ2Y1YvUWZtOURRUk9pWHJGaEZETG9laEwz?=
 =?utf-8?B?a2JoSk43SDZ0OEhrTWdFdk1HWnZhQ3RHL0xOMkJtSVJKQVdjSHRyeTJCalFX?=
 =?utf-8?B?a0Foazhzb0FOTC9wUS9DMWNQWjJsQ0tvS3p0VEtaYTFPOXJibTZMS0pid3lQ?=
 =?utf-8?B?YmhrdDFTZDNnTkVKcDdIZ3VHLzlpMGdxYjBZOHUyVzNGa01aYlkvaGNiQ0hj?=
 =?utf-8?B?T1RmTC9OVVIxWWJhbzhoWnh3ZDJ0cGtod3hzNU5wdnZIb1daejdFRDlscHZL?=
 =?utf-8?B?eXFUM0tyQVkyeEc1em9GVDBDOVV1T3hiWmdEWDhRdjIrVlNjVU1ZVXYxTGtF?=
 =?utf-8?B?dFlJRFBJOFRoVGEvenBHS3RUOVV3K0UxdEg0TGljd0oxdjdSUVNhSEVoU0lp?=
 =?utf-8?B?c3dudjhIS0M2SENYR2hudU5BS1V6WnBvWVR4c1UySmZHQUJLeXJUdVpETGFn?=
 =?utf-8?B?TkN2NW1DQUY0YU9OVlQ0Y0dvdFF1WU9YbTdYQ2RVT3IvS1BpKzhWSTM2YVBW?=
 =?utf-8?B?NzJsNFNSYWZ5anJLaHMxajZ4Ukl0eEd2WDE4eDhMZ0hHNkFzMVd2MWIydTR1?=
 =?utf-8?B?d3pyYzFFYllOWmIwUEFQTDFTY2UvaDI1Y2d3VW5Tc2RQU0RFZzZvZm1WSFNn?=
 =?utf-8?B?TjF0aHNkNUZzVDl1R3BhV1ZibzB5ZTJoVUhDb1FXdlRhR3ZuQnl3REZRcWF3?=
 =?utf-8?B?NW1kNnpkTzFYTEwzRkVzWXJpNFZFS0hhUGhBbm85R05RaXd1M3BmNkVXUnZH?=
 =?utf-8?B?U0ZEdXJMN3pXWXdGcWdZNVNYbWFsQzhKRCttSVpsMUhVTDR6VGFwcHBiL0xP?=
 =?utf-8?B?bXZIQnhBNnFtMU8yLzI4Q2VwOVdOZkZNcVdhSDFIK3lPUlpZeDIxZ0Y1dDg1?=
 =?utf-8?Q?GZqIC5YIo4MRWzWqts?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: 4Tg4nifzdhepZQvwbg8DK2nwHc86lFofUekwGnTXAb+V+wUPAhyK2EJ1QYVyB2UDLAgEkqIQ4MPX/b9lB707qOACQkpFi6NYNl7g8nE3ZONW8odwBw17ZldqaRSB28WWiH/PpTgJc34T4n/oU5w4x36NCHNElaZ/jjQh6CV9/A1SWMjFOlGIYygi6+VTfgR1AHtLWLvkPJjlM7Awr7AqmkQS42LHbafeLE8ad+ZRpRgFjbDC74ngCPOjhpvH2OrXkXrjDrc/sjj00BQAagYIKTPKyP7mjRC/vKw1e0yF4Yi5xGV+asxiu4toF+0S95+LCkjGgF61O1lIi7/GpNCAgw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b977c4-0a20-4111-388e-08df02da6d9f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2026 18:55:27.4781
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5aX5v/j/16000PWsgjZ5Ppc2drgDRyEVnX823+vp+ymQBRefx4eRBHjsbp5mr7MODinCtTskUupcaQPzNel2Sw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7988
X-OriginatorOrg: intel.com

PiA+IFRoaXMgY29kZSB3YXMgb3JpZ2luYWxseSBkZXZlbG9wZW5kIGJ5IFFpdXh1IGFzIGFuIGFk
ZC1vbiB0byBhbiBFREFDDQo+ID4gZHJpdmVyLiBCdXQgbm90IGV2ZXJ5b25lIHdhbnRzIHRvIHJ1
biBhbiBFREFDIGRyaXZlciwNCj4NCj4gSW50ZXJlc3RpbmcsIHdoYXQncyBzbyBiYWQgYWJvdXQg
RURBQyBkcml2ZXJzIHRoYXQgbWFrZXMgeW91IG1vdmUgYWxsIHRoYXQNCj4gZnVuY3Rpb25hbGl0
eSB3aGljaCBpcyBjbGVhcmx5IFJBUy9NQ0UvRURBQyBpbnRvIHNvbWUgcmFuZG9tIHBsYXRmb3Jt
IGRyaXZlcj8NCg0KTW9zdGx5IHRoYXQgbm90IGV2ZXJ5b25lIHdhbnRzIHRvIHJ1biBFREFDIGRy
aXZlcnMuDQoNCj4gVGhlcmUncyBhbHNvIGFyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2ludGVsLmMg
YW5kIHRoYXQgZG9lc24ndCBmaXQgZWl0aGVyPw0KDQpQbGF1c2libHkuIEJ1dCBpdCBpcyBtb2Rl
bCBzcGVjaWZpYy4gTmVlZHMgdG8ga25vdyBob3cgaC93IGJhbmtzIGFyZSBzaGFyZWQNCmJldHdl
ZW4gbG9naWNhbCBDUFVzIHNvIGl0IGNhbiBnZXQgdGhlIHRpbWUgY29tcGFyaXNvbnMgcmlnaHQg
d2hlbiBhIHNoYXJlZA0KYmFuayByZXBvcnRzIEJGRiBvdmVyZmxvdyBvbiBkaWZmZXJlbnQgQ1BV
cy4gSW50ZWwgZG9lc24ndCBoYXZlIGFueSBlbnVtZXJhdGlvbg0KZm9yIGJhbmsgc2hhcmluZywg
YW5kIGNoYW5nZXMgdGhpbmdzIG9mdGVuLg0KDQpJdCdzIGFsc28ganVzdCBmb3Igb25lIChub3Qg
eWV0IHJlbGVhc2VkKSBDUFUgbW9kZWwgdG9kYXkuIFNvLCBidWlsZGluZyBpdCBpbnRvIHRoZSBN
Q0UNCmNvZGUgd291bGQgYmUgb3ZlcmhlYWQgZm9yIGFsbW9zdCBldmVyeW9uZS4NCg0KQnV0IEkg
Y2FuIG1vdmUgaXQgaWYgeW91IHRoaW5rIHRoYXQgaXMgYSBiZXR0ZXIgcGxhY2UgZm9yIGl0Lg0K
DQotVG9ueQ0K
