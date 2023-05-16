Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD92523D6
	for <patches@lists.linux.dev>; Tue, 16 May 2023 07:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684221802; x=1715757802;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XW0HyaytQ9E9LFxQzWXp2nWpkwNXrdVkAMajBSC4trQ=;
  b=Ik+u3cZ9VyU4fp8E6zzNLNQSnMsebx0nG0+sV9FAe/RAgEwDzm589b6P
   1S6ay5v0+VE198ZUHl2RLlt+sGacKFkUf7chHqJi9mD/9dzzfVs3Kcw+b
   euXkWb4rJ6j42zEtw+A9Kz/bK/UZj4O7mU5p7LrFYNW5HJMGiRV1wLdo0
   Hjd2IYxB9ZUMmIrrmQ0bSahbrD95BsaBMKlkcY5fSZ1dkw2ixazSZVk78
   lgZNVSChkYMQ2djhd1X4jXaNLEUWKw/AFfF88OFMWKA1dofDEgXWdZ55b
   WwCextcuasW5yAMvui4v1BD/MybF3yg/96TaFy3EReBg/8VmehyMpAvyD
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414811896"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414811896"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:23:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770931484"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="770931484"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2023 00:23:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 00:23:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 00:23:19 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 00:23:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmgIPxwqcGJdTbrVnT6/HKMTdFRbiAxdpAgAvBdIffV91cBqvbonpPbu8ADxmPjklyTw4EIKiNmWwasLhx9EMvjgXetwEJhX4WQyfdkaMUhwLEFg9xdmNMMuOZ9WK8Rk753X0hQ9669ZjhhxGIQ0WFAvwQ+yZTT+h2sZlfPMt+NG4efSzd3ylqDKXG+hCvorSAPZUBFA7wDdtxPJ8CwsHJpuiNu1nUa7UAp79j7wNv95MMTncHUdSzWfQxUPAHt/SZNcAzvhKqDS8eKs8nppah7yD64pk0ywqgv5FDPP8Gigh49IQqgyd3HdXdii+gUadHnTgjxmA2WFVV95RrUCgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XW0HyaytQ9E9LFxQzWXp2nWpkwNXrdVkAMajBSC4trQ=;
 b=jAcaACnvJVze9aguvkceyb+BTOieGnKtgvvV25Yj6mCzuS5ltM/Y2OhV/WAYcCp/FbJcOvOrxagiF26YwrEVEoZrMTGPwwLOpcWi7GRPxcmmec7pNsSmRNJNHqmKp9NRIkwrGbVoX/WZsdF2c9slaCFjodlngK8EEe6llFnCnedBbQNh+yqnd1B1zdcWlVtTO6Q3eM0slFOIs0C+LmjVyH3xyZePKmPTSgBRvw//oQkzxOAS69f3h+AFN5XCgum5brnnC6n1UBHox356Y8eeQeb8vJMOhjL697m/BtfawLsCY6FJmqdehHfnmb0cq/xSWZXXCx8YtR17gPcvAnpfGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13)
 by IA1PR11MB7175.namprd11.prod.outlook.com (2603:10b6:208:419::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 07:23:12 +0000
Received: from DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9]) by DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 07:23:11 +0000
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Sripada,
 Radhakrishna" <radhakrishna.sripada@intel.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "sashal@kernel.org" <sashal@kernel.org>, "Manna,
 Animesh" <animesh.manna@intel.com>, "Lisovskiy, Stanislav"
	<stanislav.lisovskiy@intel.com>, "Souza, Jose" <jose.souza@intel.com>
Subject: Re: [PATCH 6.1 197/239] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Topic: [PATCH 6.1 197/239] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Index: AQHZh1B/NsIoW8Fr8EWOK2bjSz8ZnK9cfRSAgAACCwCAAADIAA==
Date: Tue, 16 May 2023 07:23:11 +0000
Message-ID: <714b3a8a0d32d7ef4d0137cb2bc64bed5a0c0a59.camel@intel.com>
References: <20230515161721.545370111@linuxfoundation.org>
	 <20230515161727.643480643@linuxfoundation.org>
	 <d3bb810d9b1bc5d210ab414d7eed140be62e97e2.camel@intel.com>
	 <2023051652-corrode-grape-809e@gregkh>
In-Reply-To: <2023051652-corrode-grape-809e@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7382:EE_|IA1PR11MB7175:EE_
x-ms-office365-filtering-correlation-id: e9d18366-b8e6-4897-3308-08db55de67f3
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Il4Z28CHLttuaWwEGW90K+yufhX5VmZJy0Ck79tprw4TqO+op/R37Q41rvtdnIRHmCrSMCrQpohaQwE+pfArRs4rrCIrnmkM7Y13PfQjzLQOOB9i8/G6sduxE9UpMhgeftoRAB0xxRaOpC066D8DQ4nBOo88Tq/jmFgXMT8YIgCj+SAOtrizLYCRZvSM570IbbHyzB2L8jq1tCbEOA/ON1pqp3QO5Xmj2l8mweyl+RDYcJ3gfJLi85aKrEcuC5j8E/191zNnLZaW/1omcaXXaILkjGIgYm4VXJBRtJ8p8iy4sc7s9VbGSM8AkZRtp0l67HwlcFoIOdfeyff6oS3dnlVmjhflMoJTH062SCYKSehcQf5Whl5DOgWru80a4EeMz8GViBKZkTSQPQd7SzaEqz0DCsLe0nZWAiTi6ITbCSNw+mR/LSQnOKBsf8kmLD+e49Yn/1mGv4ENyiXl3hhRF8maDTLqyIPVL0XCusYUAjtK5LFcqko3SDOezk5EGjek8M/2ts70nKvSeUJ6OdDRzBpb3YUYJrrFboZ7oGxcLUS6J+XrlPgN5FeHdYSOHloh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7382.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(2616005)(76116006)(2906002)(107886003)(66946007)(66446008)(6486002)(66476007)(478600001)(64756008)(66556008)(966005)(91956017)(186003)(6512007)(8676002)(8936002)(26005)(6506007)(6916009)(316002)(4326008)(41300700001)(71200400001)(5660300002)(54906003)(86362001)(82960400001)(38100700002)(122000001)(38070700005)(36756003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TGd1T2U0azNwUTB0ZEtldS9HTmxsV0tTSitsb0x1TzN5SUJDT2dnUlcrNDNF?=
 =?utf-8?B?cmJ3YTZqVHRmYWwza3R3QzlSZHhIY0xSeGlORFpsMHNETytnY09TVC9CYi82?=
 =?utf-8?B?U1NSejJQSVlMRXlEb0RMRkc1NDNZbmRKZHlDQm1iS1FnZmpPcy9qOVZKUCtu?=
 =?utf-8?B?dVcybTJpSnV0OHNtUGFDaXpkbzNzd08vUmJmdDBxNEdra2JwTmkvTFVqMmFp?=
 =?utf-8?B?UitFS0hLcGxsMEVGZzU4TS9DaXdmbU5Pd2ZaVEM2NnpiVVMvQUx2cDlsSHV0?=
 =?utf-8?B?dmM1T1FHT3R0c2xrblV4TEYwOGVzNGxPT3lWTkZXa2JpaFhlYmZpVTRLRDNM?=
 =?utf-8?B?Z05FZmx0RFBGTEJ4ZzBxTWF0N2RGNElxYWpJVlZKWS80Qk02dHA5TmMwaHA5?=
 =?utf-8?B?MmZQNTJoeXFGVVhiRjc0N05XOCtNdFRFbklFeW1DVGNlTDg3WDZrcUxLcERF?=
 =?utf-8?B?TGt4Y1lTSWZxbFBCeW9rdm5FR3NqbzN0Y2o5SHkydktzaWllNi9ZRUhYMkcw?=
 =?utf-8?B?VURERjlrMk5Jbm51NGw2dWxVeFByQUtESHJLMU1uaDU0TlorUVpyNVR6SU04?=
 =?utf-8?B?R29hajB1L2NjQTBUd1hZYUZPVFgraEtlcmtzQ3NjZnRNSGVEWlZVTVkvaDVU?=
 =?utf-8?B?Q1RWT1ZodDhjclJVTStPb3FmS2dFREI0Q0hBTUdHMXBrVTNtMWREdjZ5OS9L?=
 =?utf-8?B?VFA5TTVmUU9Ud1BDTXdVRldNZWJOYTM1RTVNVTV4bEVxSUVxcHE1UklHTnk1?=
 =?utf-8?B?NFZyS2JZT1RGcVVhdVNNNllSelNEWnVwR09INnZ6S3N4eS9tRk02UDVqS1Fh?=
 =?utf-8?B?MFo2K1FnU0JOZDJVeGxmOEh4V2puWE9IZHlKOFloa0t6blg2YVpoMXJlTUtV?=
 =?utf-8?B?K0xiZldYUEMySEJwNTlsSklUMVNEdjBySW95dEF3TlZwYUVSdHhCWU9JYWdh?=
 =?utf-8?B?a3FJTTFMMVZVTVp1RHpZYmNsbGtxTU1MS2ZiTzZLR0tDRXN0VURUM2M2dURt?=
 =?utf-8?B?MXFUWVdzdXR4Mm5TRG8zY2FrU2h6VTRNcDg2cTVrM0FSeXhtWTJTMUNraGVW?=
 =?utf-8?B?ek43SXJqaVBacVdldlVUbjErT2cwcktrbkt3UmY1OWNpSlh2M2xRdm9NS2Nx?=
 =?utf-8?B?bDBDQXo2eVZTZmEvWlJodDhrSnFCTGdEZHdpVUo4RGpDcVBjKy9naFU1VWVH?=
 =?utf-8?B?SGhSNklLS2Mrd0RSOElUU1c3WjljL0ZKakJCZktqNDVNWEVrNzdLYUlER2FW?=
 =?utf-8?B?Nmc2eWlqYVFjVndFUnoxa3pUY2xybGd4d21BVTVWejhlTmZWYjNIY01vcG1p?=
 =?utf-8?B?aWluNW9iblZQVHA5VXJKK01VYVRJNmVlU1hYcXJMWGJDcENnR3JBUFdRTmlI?=
 =?utf-8?B?RVBnRWV2T05oNFdhaUpHL3FGV3lWRk1keFBoU1ovMm94bUd4a0lONzkxbjNx?=
 =?utf-8?B?akRXUDN1cHp1U1lSUWYyUzJmNUFhNk9wRWpiTytkU0I1eHl1VGRjTHpXa01B?=
 =?utf-8?B?dlcrVkpTNlk1QkxyWWhjd1FrWHpadjhOTlJYYU5DaDRuN0dBdURMWnQwRU8y?=
 =?utf-8?B?MUVQZ2lEMXp2aFJGN1VmdGE0UGVneTdaQ1g1ckhnSWlMbEtzMWlXcnBMN2FP?=
 =?utf-8?B?TjBQZ3B3amp4TzA3VlFnc09hb1hWamU5NTFONlRkU1lSaHprc0pBN0pHNE9T?=
 =?utf-8?B?OTJIWWR5V0Vyc2pGNVpaZ0MwZVRlVzFOeHR6UVhTZ2U2NkU2T0Q1RWRvNENZ?=
 =?utf-8?B?VTdnSUlhUEJjcW5rUWVxa01BdVMva0M4YVlOWiszUnhoZWpJREdJOUJRNmxN?=
 =?utf-8?B?QWZUS3E3dDhWSWo5UmRqQ1JxWTBuelVnTC82ZENhZTVtdEZmR2phblMxSFJt?=
 =?utf-8?B?dWFkUW9aTU5ST1diUkJvMkNGaThzYUxHaHMwTnFmclYvZlZDa3huanpDckFO?=
 =?utf-8?B?VHZ6bkEvWldseVp0MTlaNmZmb0pWbEp3SGs2OFZiU0psWUREV05FdFBWQzYv?=
 =?utf-8?B?TFlwOG9OcDJBSm4zOVhBOFB2ZHZzRTdnaVFjM3k3SUZkMnRnM0F4ZERRaGJr?=
 =?utf-8?B?bzZMUkRQdmNUV2lrQnprNUkwNys4T2hGaG5CR0JsSjlkYlRGN3hpZWk4N1dJ?=
 =?utf-8?B?ZGJCUTcrUDZqRGlDTmc4QmQrL2JiaWR4bjF0NHlEUEd6eDhoaHk3TFNoYko0?=
 =?utf-8?B?R1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E5CE4D9082916D4A830593A655A91A97@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7382.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9d18366-b8e6-4897-3308-08db55de67f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 07:23:11.7740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UHQb86DMVaSZG0jFPjl9htJsTNCtjjH0q9yWATHG8E2xXugrQc4aFAhKQlMRk5Lll+gwsEdB9Dv4NiBml8OY4BMaBWtUUYlp6tSSW2S/4Fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7175
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTA1LTE2IGF0IDA5OjIwICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVHVlLCBNYXkgMTYsIDIwMjMgYXQgMDc6MTM6MDVBTSArMDAwMCwg
Q29lbGhvLCBMdWNpYW5vIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0wNS0xNSBhdCAxODoyNyAr
MDIwMCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiA+ID4gRnJvbTogQW5pbWVzaCBNYW5u
YSA8YW5pbWVzaC5tYW5uYUBpbnRlbC5jb20+DQo+ID4gPiANCj4gPiA+IFsgVXBzdHJlYW0gY29t
bWl0IGY4NDA4MzRhOGI2MGZmZDMwNWYwM2E1MzAwNzYwNWJhNGRmYmJjNGIgXQ0KPiA+ID4gDQo+
ID4gPiBUaGUgbWF4IHNvdXJjZSBhbmQgZGVzdGluYXRpb24gbGltaXRzIGZvciBzY2FsZXJzIGlu
IE1UTCBoYXZlIGNoYW5nZWQuDQo+ID4gPiBVc2UgdGhlIG5ldyB2YWx1ZXMgYWNjb3JkaW5nbHku
DQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IEpvc8OpIFJvYmVydG8gZGUgU291emEgPGpv
c2Uuc291emFAaW50ZWwuY29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogQW5pbWVzaCBNYW5uYSA8
YW5pbWVzaC5tYW5uYUBpbnRlbC5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBMdWNhIENvZWxo
byA8bHVjaWFuby5jb2VsaG9AaW50ZWwuY29tPg0KPiA+ID4gUmV2aWV3ZWQtYnk6IFN0YW5pc2xh
diBMaXNvdnNraXkgPHN0YW5pc2xhdi5saXNvdnNraXlAaW50ZWwuY29tPg0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogUmFkaGFrcmlzaG5hIFNyaXBhZGEgPHJhZGhha3Jpc2huYS5zcmlwYWRhQGludGVs
LmNvbT4NCj4gPiA+IExpbms6IGh0dHBzOi8vcGF0Y2h3b3JrLmZyZWVkZXNrdG9wLm9yZy9wYXRj
aC9tc2dpZC8yMDIyMTIyMzEzMDUwOS40MzI0NS0zLWx1Y2lhbm8uY29lbGhvQGludGVsLmNvbQ0K
PiA+ID4gU3RhYmxlLWRlcC1vZjogZDk0NGVhZmVkNjE4ICgiZHJtL2k5MTU6IENoZWNrIHBpcGUg
c291cmNlIHNpemUgd2hlbiB1c2luZyBza2wrIHNjYWxlcnMiKQ0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogU2FzaGEgTGV2aW4gPHNhc2hhbEBrZXJuZWwub3JnPg0KPiA+ID4gLS0tDQo+ID4gDQo+ID4g
VGhpcyBwYXRjaCBpcyBvbmx5IHJlbGV2YW50IGZvciBNVEwsIHdoaWNoIGlzIG5vdCBmdWxseSBz
dXBwb3J0ZWQgb24NCj4gPiB2Ni4xIHlldCwgc28gSSBkb24ndCB0aGluayB3ZSBuZWVkIHRvIGNo
ZXJyeS1waWNrIGl0IHRvIHY2LjEuDQo+IA0KPiBBZ2FpbiwgdGhpcyBpcyBhIGRlcGVuZGVuY3kg
Zm9yIGEgZGlmZmVyZW50IGZpeCwgd2hpY2ggSSB0aGluayBpcw0KPiByZWxldmFudCBmb3IgNi4x
LnksIHJpZ2h0Pw0KDQpZZXMsIGFnYWluIHlvdSdyZSByaWdodC4gIEkgbWlzc2VkIHRoZSBkZXBl
bmRlbmN5IGxpbmsgYW5kIHRoZSBwYXRjaA0KdGhhdCBkZXBlbmRzIG9uIHRoaXMgb25lIHNob3Vs
ZCBpbmRlZWQgYmUgYXBwbGllZCBvbiB2Ni4xIGFzIHdlbGwuDQoNClNvcnJ5IGZvciB0aGUgbm9p
c2UuDQoNCi0tDQpDaGVlcnMsDQpMdWNhLg0K
