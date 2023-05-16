Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1806123D6
	for <patches@lists.linux.dev>; Tue, 16 May 2023 07:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684221735; x=1715757735;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=sAQ0IL4uzm1+0H68Yr5HD4KONdmMQd7XWJl7kjApHbQ=;
  b=lxZcPhIKmkMxgoXIUIsAxKOvWrsOuvfsXGvrWslUbD9uP9yzqjWnPaQR
   n6UCiXl/YUK8M9LOasUD0hVO7NYrxgGQAGjPdJGgGAbaFsWCkY6uJBD2e
   Xsd5fK5xlJiJxP8argv+R7oGUHkPOJ+G0aQC34t8WCrbMflMWv2lrhA6Z
   rBj40N49hruTqz6Q/oFnNAwn/wyTlpY8inXKOalBov6p5OZLUjspgCR/K
   nXY8lwSBL3+2v9hWN/xPK/TNlkGEBSTIygpOp98G5D/Nc1/yywWNZs45k
   xKU0bjZWJrAHw2sgQ+5sUH+9cV8qdQcNCnUF6Nn8m6GVEfdFIHdetxlaN
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="414811688"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="414811688"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:22:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="770931245"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="770931245"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 16 May 2023 00:22:14 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 00:22:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 00:22:13 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.45) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 00:22:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGYuO9mo8wcmKbt1rOo8wdxEnrF/keFcw0W3VbpLfCQqVAfQADYmCFWv7wh0o4j7Xz/40tk8iYQk9w5l1FghJ0gupft6O/WMFI8yQoJkAC/+BxIXn5IuTTtuZ2sIw9PqN4d0xmPtB84IKHKsKJzB3iH3M95ds+IoqMnB67loMV+lWIXw0RVddhafvpHNjAKMTZ89sHL7iMQCyLk9oLro0t+23NW/9R8tQq55jjVZvgzamKvy0mEP20Ey9OaUqhKRtKPs8VZmfMr3tc02cF8rytEjunokwmFOQrG96bo/6lqH5v/cZcfnlpieAq2nf2PMJLc4aSav7MvPctdmJOgR6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sAQ0IL4uzm1+0H68Yr5HD4KONdmMQd7XWJl7kjApHbQ=;
 b=OWWul7hb+uADAq+KSzXfsMwoycvYPRkUMYilPQFbkfYgc7zMcPd2MM0r64CvtpjO5dHVzBW2H3DbwAJXnTUoFf3LZ3x9ceNScYH8h9aM7WzqBZUYfJqxwp6kOtHKXuaXzwLQ5947xrj0yHrkaP7NulQH7XhSF2wRd34iHTzHfodFYjMo7VsAHibx3+BgU/fWM/QONX8pukQqTQ/hDP/T8GNHEz1DqKAygvf6d7BTF9CVQNoV6sO6IrzMp/bzZA4VWkXFfNd/QGyLoHaW1kGg0XNt2A8rakHdaBhw+53P/OwUoJpNfvt8xunAR+1RdqsengJyZaPj3rZWYg6LFzI6SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13)
 by IA1PR11MB7175.namprd11.prod.outlook.com (2603:10b6:208:419::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Tue, 16 May
 2023 07:22:04 +0000
Received: from DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9]) by DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 07:22:03 +0000
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Sripada,
 Radhakrishna" <radhakrishna.sripada@intel.com>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "sashal@kernel.org" <sashal@kernel.org>, "Manna,
 Animesh" <animesh.manna@intel.com>, "Lisovskiy, Stanislav"
	<stanislav.lisovskiy@intel.com>, "Souza, Jose" <jose.souza@intel.com>
Subject: Re: [PATCH 6.2 213/242] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Topic: [PATCH 6.2 213/242] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Index: AQHZh1IZhNKk8tqmAEWmMZdxPhFgXa9cfT6AgAABoYCAAAC0AA==
Date: Tue, 16 May 2023 07:22:03 +0000
Message-ID: <8c674e01b694d5457e1fccd01dab45c11126d72c.camel@intel.com>
References: <20230515161721.802179972@linuxfoundation.org>
	 <20230515161728.319620707@linuxfoundation.org>
	 <51bf59b96c22c2e79d81e38c3dc1b006959a14c8.camel@intel.com>
	 <2023051607-rocker-refinish-8c6c@gregkh>
In-Reply-To: <2023051607-rocker-refinish-8c6c@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7382:EE_|IA1PR11MB7175:EE_
x-ms-office365-filtering-correlation-id: e44bedf8-4905-4dae-5fa1-08db55de3f6c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: u1cxlDBunme+KAuqqOdUNTH2dzc08C7Th2sgcDHLnvnm4l7BspyadiW1mYAixLds9WCkaT9JZAGoN8Ag+y+GGODHpnTSc929+lFRyseBhc5592w/99gyPvd/V0WR86wdZsICGpanbK1pX1kmMerYXhNC9M+1A4geeGvj12/26Qfem9KAJKsKOalljXxeMD8U9HMZdhwoVikReQz5Rv7AmG1ROu0oBikE63xl8wBmu66Usas/d73w2jwM3Zs1mmKb9iKOy7OoukS/gt3PYVlgdh94r3UMm0fNTIoPiXciczOWebYvm25qSprNrF6lnUzV1fdnxSGYJtl/Ft5F2iulzWvbslIOOT5WQ6khsp3Fp6QJjz8p3QDpeZi4cDNZeT2PNkM4I8R6/KbklygqQ3krpyMXwlgMD7KfDW8r6KWL1tFn/ZKRx+YI0vfbL7GZtq1vgjfxHVQatNB69iWLRofonFbu60qg64Vwe+eUmDwmLvBw7HHfD3I+jX1AxDDU2WoY2csJggQLZvZ2t4ELvqbKB9prvV685AOLU4fA61qqgxKmWX5P5Barp19/U4Jkn0Nq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7382.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(366004)(39860400002)(346002)(451199021)(2616005)(76116006)(2906002)(107886003)(66946007)(66446008)(6486002)(66476007)(478600001)(64756008)(66556008)(966005)(91956017)(186003)(6512007)(8676002)(8936002)(26005)(6506007)(6916009)(316002)(4326008)(41300700001)(71200400001)(5660300002)(54906003)(86362001)(82960400001)(38100700002)(122000001)(38070700005)(36756003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGZxQ1RTU0RsbG5zOTl3VFByZzk2MHAxYU5sK0hVTVZicFNnaloyakJaRGZL?=
 =?utf-8?B?ZFhDQWRzNEFEOWRWNTE1YWRKdEFMZzJKbHBsWXdYbVZmcUNaWHhwYUxMRDQz?=
 =?utf-8?B?S2tIdEFLMUxFSDF1TWorYjFJdVNRZXhlUW1UdnNaRThaM3IrazFlV2xIUTRr?=
 =?utf-8?B?eE9rUk52UjlCbUlpU1I1dHZkbktSZS95MWhpQlpTekZ6eGllSUZWVWJhSVlC?=
 =?utf-8?B?TVdTMWVrcVI0QXgybVhOMUhvRW4rV3lWN296U1hYb0sxRFEvdzJpZXZSUGhK?=
 =?utf-8?B?bk1rU015TkZJRUVVYjZGTkZ0c1l2Wm9UUE1rVFB5NDhDQVVVdlpIZkEvRGI4?=
 =?utf-8?B?WEk1N2RzNk5lTk5yaFUra1A5emJxcjF4a0t0QUd2aDZqZVY5S3BwWWpjazgz?=
 =?utf-8?B?eXNHdUJYcExOVFpRTnM5TVI2Y3pzT1RnMmpHZVZ1S0gya3FvaHJCaGpYQkJy?=
 =?utf-8?B?RFpsNUhDcHk5ci9UYnpQcUZBTU1Fa2RjS2lLQWpQdVRXektSWEZvK1hOZy9C?=
 =?utf-8?B?azBmMnoyb2FDb0hvS2dibVFRYXQvemNEWnBJN1pGN2szOG1kaVVGZzFYcDlT?=
 =?utf-8?B?aTJQU3NFVGo2RlRwNTh0UzFKSlR4V2s5SWVVclFJOGpYaUhQYkQyQ3JlREJp?=
 =?utf-8?B?R1I1SzBXa0RvWGEyZEk1d3lDNzFLS1NuZzBxM21CQ0pnZTdNWHJiTGhqQ2ow?=
 =?utf-8?B?ME5jejZ1NGtKUUZzcHpMNklUK1RPZ3QwUnhYcFRMQmZ0b2NoZU8vb3FJMU5w?=
 =?utf-8?B?aCtJRlIxdVNscGE0N3dOV1VFa0drNjBBMnRVQThvR1ZPWm41VnR2U05SMW55?=
 =?utf-8?B?alhtSDlwWEhJOWJMNThUTnVOcXFUcXBtSmpSclFDRUZ2andZRGNxd1g3NVBE?=
 =?utf-8?B?UTRlYzF2RGVuN2VDZy9EV2RtU1FnUWdtQkpGOW81cjNCNjg1TmlrWk55Vkov?=
 =?utf-8?B?d0VsK0tNSmREOE9kMitGeHJzRjY4NHFKMS8zR2YxUDI4M1NuR3JsVGs3L29C?=
 =?utf-8?B?ZldobjhwVjk5WmJDakNlUVRxdXBTbEdTSXpWYnB1c3p6WXptV21tUnprcjB2?=
 =?utf-8?B?bi9pak8zc1lMMmRMTktNSjdoWE5qS2RtR3h2dVY3TGUxcENSY1JHNFVaSVAw?=
 =?utf-8?B?bGFBWTI5VFVSZjJ2ZHlva3VXakMwRXAvbXczWWpMaTIwbEFmL3Z3dFhBZzha?=
 =?utf-8?B?SmR0VEJuMmFtRElBN3hINWtvMFdnbVBtWlJjb0hhMjBDdVh3VndnT05XbjNF?=
 =?utf-8?B?Ymg2UzVxSTlqZTFDQ1UwMEF2UzA4aTc5djdXYzYyNEJxNlJWSG9qZ1ZLK3B5?=
 =?utf-8?B?dlJvMFlUbWcxY3B2MnJwdjJMRWdlOG1iRmNpenk4YzgyRFptcTQ0SkdQSkp5?=
 =?utf-8?B?RGhLVXFMd2x5akYrMjM5QWFSRVcrVFBoU2t1blVKNkJyNk94OGVWdTJUSHo4?=
 =?utf-8?B?SjlJaUxteDJ0MUl2WFlIanBFYkFMaHBzU0RMOHE2aDRqRlhhN1FvUStjMG9U?=
 =?utf-8?B?Mk5GZzQyQkNVeFR6SzRUbVVpbDU5dmdTaStMRUlreTVxcGlFOUE1dGdiWXBv?=
 =?utf-8?B?UXdsMXVDUzhkbm53M0dXSlFPd3F4N1NkbjB6Zm5DNXVwTHQvdFJiZTRsVktK?=
 =?utf-8?B?N3YwaE4wNVY3WnVTSFc4NStUcnNmS0ltQUZacUh0QVR4b3hvdUVxdHNGT05K?=
 =?utf-8?B?RHhsS2R6eWdCMndUOHZaTFlack02eXp4cFYzZVdsK0dwd1d2YVprU25NaUdp?=
 =?utf-8?B?OGtuOWVXd1FjSmJmRWRtTVltREtWcElwMWpHcUozZGtKTEZaWDBGZG5XeDVY?=
 =?utf-8?B?a3NGVTRuZFJieEJURE9CTmF3TnlsaExka2dLNkxDU1JpQ0RISnp0Q2hNaEda?=
 =?utf-8?B?NE1VYmZIYXo0RTQ5c0pieVBtMnBUNERxeHZVVjRvU0hnV2x1NkdrNlUxS2Iw?=
 =?utf-8?B?cXJBNXFvTlNsMUZ0TkVlT2tuT1laWXRNRzFoS2VRR3YwOXZGZGxOU3lhRnZj?=
 =?utf-8?B?NWRxeE1PQTFOaHJHeDNyWFk3d3ZreGx5a3RQNzhRNlRVOVU4UE9kenpCSkFK?=
 =?utf-8?B?a29LTG93aXJxNGh3Tk9ob2ZNVVNOV2RNZzhVNSsxQVlraS80SVo5QnEzUHRk?=
 =?utf-8?B?anV6NGdVLzVrRm0rbklEOUtLL3cyQzhwTEQwa0lLdW1vQkppRnltQ2FoUWtK?=
 =?utf-8?B?ZUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CBE777164220ED45970E4256F20422BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7382.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e44bedf8-4905-4dae-5fa1-08db55de3f6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 07:22:03.7904
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YgJRL2qICWLgpLWsJiE5kAjzcmk/UB2+dzNBWZ7LJt7GFjQxW5WrmRTewOv709B1qsH6sHaNC2Lu3eyYm+PBA4VXKDdjRZ1KMyfOKqABj28=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7175
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDIzLTA1LTE2IGF0IDA5OjE5ICswMjAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gVHVlLCBNYXkgMTYsIDIwMjMgYXQgMDc6MTM6NDJBTSArMDAwMCwg
Q29lbGhvLCBMdWNpYW5vIHdyb3RlOg0KPiA+IE9uIE1vbiwgMjAyMy0wNS0xNSBhdCAxODoyOCAr
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
dXBwb3J0ZWQgb24NCj4gPiB2Ni4yIHlldCwgc28gSSBkb24ndCB0aGluayB3ZSBuZWVkIHRvIGNo
ZXJyeS1waWNrIGl0IHRvIHY2LjIuDQo+IA0KPiBEb2VzIGl0IGJyZWFrIGFueXRoaW5nIG9uIDYu
Mj8gIElmIG5vdCwgSSB0aGluayB5b3Ugd2FudCBpdCBhcyBpdCBpcyBhDQo+IGRlcGVuZGFuY3kg
Zm9yIGFub3RoZXIgZml4LCByaWdodD8NCg0KQWgsIEkgbWlzc2VkIHRoZSBkZXBlbmRlbmN5IGxp
bmsgdGhlcmUuICBJIHdhcyBhYm91dCB0byB3cml0ZSB0aGF0IGl0DQpkb2Vzbid0IF9odXJ0XyB0
byB0YWtlIGl0LCBqdXN0IHRob3VnaHQgaXQgd2FzIGlycmVsZXZhbnQuDQoNClNvLCB0aGlzIHBh
dGNoIF9jYW5fIGJlIHRha2VuIGlmIHNvbWV0aGluZyBlbHNlIGRlcGVuZHMgb24gaXQuDQoNCi0t
DQpDaGVlcnMsDQpMdWNhLg0K
