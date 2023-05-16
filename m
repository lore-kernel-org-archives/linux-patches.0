Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1F1D2B4
	for <patches@lists.linux.dev>; Tue, 16 May 2023 07:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684221191; x=1715757191;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=E4Y+QzjhF4vXu3eYpPLdOTYeCo0+GmK+j0IFCsOQAd0=;
  b=R7s0x1uBQdZL0645oPR+QTJwZwofXuEfsWoIGc/ORqqqeW/lsQKM6WDm
   dYTDegVxt5LTaP6Ak4jSn/dZsPSxNja9fQ7vTRmSjgjK0AP1pA+nwhNXj
   GZb+elKEi4W/HzyY5xUJkmedRtwTJ/D9PtlIDg49RzUZN4jHk5fu3s6LL
   Oh9iNXTwYvBH3uR//B9TLayORC/WRg0NcsxwFkS9KfeMGiAZrItqTSsDl
   M65ouV/0HkV8l8GeigDeYBWh4br2FZwpkL/+1eDNWQGi0tJMvkKoWEUU2
   M/k7kVH6eTd2CRjUjpxERWUMK5nnTM+gXWWsPoqW4DPkpTtwLIROYtoWa
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331766746"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331766746"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:13:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="947730458"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="947730458"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 16 May 2023 00:13:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 00:13:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 00:13:07 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 00:13:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxtzigmsM5V5L9hfKhiWneRnkLv0EMA74ZIj0bFgIZb7kOPFSVZHweU/RK1LKnOVPpEc0WOoOJbjtl87X3ICUM629aKNyiLEXbjtCEb8RPTH/m4K9DhipN3klB5hMOu14kTQRgJFr27QGzdb7Xpu8XPGyheQcYWWKBguZ3PbLyVtWjV5YHd48a4TCx8x5LmdFlxaIwb7Di0ArdhSvqtz2C25R232DCG2FhHK/I5I1DxNhmVx2PNkvwsT3FwH7f4PZbEc2TJ9+9ODPdM11AHJWpuE99QtZpha3FKtrcLWxuXRX1FNpqFc6avY6+pi02Tsid0L3glnp5LRrFqf86jVfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E4Y+QzjhF4vXu3eYpPLdOTYeCo0+GmK+j0IFCsOQAd0=;
 b=X93fy/94dHlzFfTea2YYU7HS1MMNg8I59+gH0aQcYUB/mhiR+JWBEbf9/WMs/ftJMLk+afAAfm2SMgZgVPqhGbGo8CKveqs7yLzKKcqkXzt2MXiCXr4dhQlgTRF8eIW9AQo6K68Fe1YS684sLKLa9Wpms89H7svOr+T066a1zGG6hU0Y80qjMzPrfZfkDpzSyHwj3MZs0EWMPVHeoRT94rOo8WMcfIDw3hpvDifG8qcdN47i+5iS7aThCGdPdV7+tdPJW7dJbt+kcSpS/yHYy0UkXIZUZKAcc0voMCLmVcmNyRxZpjwEHibgmp/5ElWfBM2qAFCrLN+ovLdoZ7KZ7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13)
 by CY8PR11MB7136.namprd11.prod.outlook.com (2603:10b6:930:60::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.32; Tue, 16 May
 2023 07:13:05 +0000
Received: from DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9]) by DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 07:13:05 +0000
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Sripada,
 Radhakrishna" <radhakrishna.sripada@intel.com>, "sashal@kernel.org"
	<sashal@kernel.org>, "Manna, Animesh" <animesh.manna@intel.com>, "Lisovskiy,
 Stanislav" <stanislav.lisovskiy@intel.com>, "Souza, Jose"
	<jose.souza@intel.com>
Subject: Re: [PATCH 6.1 197/239] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Topic: [PATCH 6.1 197/239] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Index: AQHZh1B/NsIoW8Fr8EWOK2bjSz8ZnK9cfRSA
Date: Tue, 16 May 2023 07:13:05 +0000
Message-ID: <d3bb810d9b1bc5d210ab414d7eed140be62e97e2.camel@intel.com>
References: <20230515161721.545370111@linuxfoundation.org>
	 <20230515161727.643480643@linuxfoundation.org>
In-Reply-To: <20230515161727.643480643@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7382:EE_|CY8PR11MB7136:EE_
x-ms-office365-filtering-correlation-id: c72646c0-6ecf-4979-8b15-08db55dcfe67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jBpEUNp6xDzbF+K1taSs7wobwm9pSNPAMAq9BjzjytmulihXt414u1yi9fuPjySzCXyTjZEfP1CDCNsVBVm7izZrAnfenk9V8UDrG0Ofk9BvivMf9Ez2kTX16sSjvy6nqz0eUvAMLl0qLzSti5ZpXGh9rWEle/5A+spUgd/N2JOlMjoeixfIMHY9zMlOuXMZFi6LDIRFOHGLQX6G9TM9qk9sViE4YhOxPRmhTK966hKe6DaEQ2BGTi901PaSvfB2f6mO7nkkaptZyK94Xggv1GW/CI0mZagqdgzBeIy3H5Jt+KuN/aTJXUmHAp+SysJcaaWFGL5c4AzLQhk5XS5ekztfqm28yzNsFNNV5Tl+1TZmIpLse+K3SjhEnKqanGqwLSSCe9Wh5n2zkXMaaSMEMgXyWeLhnAd/bOnjyZ7RBnqbv3Tcyx9dzNkE3ZNO8tOz2fyb7LDZrQ4OCrtBWy/Y569GLa0JMIPCFcyx5vYRBMgYdctzjOpvo6vOLEnWJTm3oAmZRJtWz6O4NAuE7gfpH1DOBQDSfgJN3mUK4EsnEUzu5PUOGiHORc9MMnKyUkux
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7382.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199021)(5660300002)(64756008)(76116006)(91956017)(66476007)(66446008)(66946007)(4744005)(66556008)(2906002)(38070700005)(41300700001)(316002)(86362001)(4326008)(110136005)(54906003)(8676002)(8936002)(478600001)(71200400001)(38100700002)(122000001)(82960400001)(6486002)(36756003)(966005)(186003)(107886003)(26005)(6506007)(6512007)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjB1UThIcnlQcVBuekpHSVUzcExHWk1xVE54S0VJcXp6NWhQQTRpd3JHUDZX?=
 =?utf-8?B?eFNOUFB6ZXIwSytBbFVDUUFIM25icjc1ZG1VU1NDWmMwRm1MMnVmSDhxWHRt?=
 =?utf-8?B?WnNCcDZGeXlPdWtGa1h5eHQ5YlFKRDFFZ1dwK1ZTVmxLV2tEK2dsU0pzN2J0?=
 =?utf-8?B?TFM0QWVyRFlPMDlRQmhQRjg4U3JXU2JmMGROOW5nK0lqY2tVZHZqb0cwNlRD?=
 =?utf-8?B?ZWI5aWNML09zdHNsYlNuOVVROU9WK1hHVU5CVDFJOVFqMUFRN0oxU1JpV3FP?=
 =?utf-8?B?OXA1SnZuN0VKUDFrMXN6T3lzVVlYVk5DRzlLbWcyd0wxNlRYN2xWaWRqN3E2?=
 =?utf-8?B?VE9wN3oyVHdnQzRraWN5dmNsUnFRZVo5dUtnTXVwdHR3Ri9tQkpoY0lBL0JZ?=
 =?utf-8?B?Q3BvTjVxUkhWR1h6bUVhSEpRZGdSVy90bitSdjBhUGJudlZrVEEyTmM4bC9z?=
 =?utf-8?B?ZU1mQXZ4VUs4aE9QY0VHeG9sZ1hObEJlTFBZaElEdHVZbHp4UXNVa1NTcFpU?=
 =?utf-8?B?b3Z1cVNoUlhGYkNXQm9MS2JjVmNtby83QXA2QW8rK3JwU0RjM1p4ZGZNS25G?=
 =?utf-8?B?TjMwdC9nMlJOV2tHRTE1dm5yV29RTjhpUUovbkp6QXNOaUVzeitNN0YwYjVl?=
 =?utf-8?B?aExldHMzU2tjNG0zL2lFQkxLcktYZi9XbkpvVVNNZGl4dnFROFcyRlRHVEV4?=
 =?utf-8?B?ZmRvVmRVNGFJMUNYTHFRTXBYRFJTMkk1QWJGV0hRY09YWlVGZEVJYUF3SnZ6?=
 =?utf-8?B?d3V1cG9NTG5kL3FTdWlMV2tiM3RMSG5ObHFjZWNFQjAvOTBXMDk1OXkrWDZL?=
 =?utf-8?B?ZmU3UTZXdExxWWlncnl0ZGRWSzlHM3VuZXU3alZFKzY2SExYdDBOeXpXd3pu?=
 =?utf-8?B?TnFYUkNIb0xHNndIWVNDMW15YTVpWFJnMWZYbmhNbENEMXRhYzNSc1lNSzFJ?=
 =?utf-8?B?QjJKQjZ1SExIaE84Y3RFVjRRbnAvRTR4MEJ2dzdNcTNVc1oyMlo2c0Y3WTNC?=
 =?utf-8?B?clVFZDBjdlczQmw4V2VMZXhiUWRSNlZsTm13aVBSdkQvY1pSdnpiSHVlaDhX?=
 =?utf-8?B?WXRkTTBPTG9Mczd6dEk2WnptSmo1ZUlOTUpaMm94YkdwZ0VZY1pQRi9MQlNC?=
 =?utf-8?B?cXFXb2tteFIvNmg3U0pSWFdkV3l1eDFuRGIyb3ZwcWZMcldFSXR1QlFxK0NP?=
 =?utf-8?B?SHVwVk01T0NzWWc2ZlloT1hLTTlMc0tZVzAxYzF6bjZNNFFWVjBIR0hBdW15?=
 =?utf-8?B?V29zbExtUzRoeUdjYys0R3pqQkpHSHhRaEJ4RFdlaFF1YU5vOG9SN1lIS3FP?=
 =?utf-8?B?QTBaUCsrc1RieTBFMTdQZjlUanpaWStnczhnQWhhTVd5WnEvcVRMTkhLdHpa?=
 =?utf-8?B?MFJhZGt6d1pPVzFUbVRycHdnV2RPTXdEck1velFxRDhEaFYyY1dPRktsSTlr?=
 =?utf-8?B?K2NieXMyZEd5SHVQajZvOTljMWR4UEpwTnFJY3VwSkk0WXlLNGl1NUQrRkln?=
 =?utf-8?B?bGNoL1NwRXFHOElyWDJ3aWc5OHVPK2lETkhjbnBtMXcrVU1iOC9IeFRJYVhV?=
 =?utf-8?B?N09LS3p3SGJDSE1TYUs5ZldPMHNrQ09RZTE4UlgrVmFVd3NuUjNvc3F1QXlP?=
 =?utf-8?B?dnYxakpPQkJJcDBCclh5ZmpNMzVhODlueWQ4dDk4SVpKK1BOWWxGcDZ4REVD?=
 =?utf-8?B?RUNEbmNWWXpGTmFGWGpNYTMyMjFoa0ZuTCtETzJHTDhXcXFKVFl0bk1BS1Fp?=
 =?utf-8?B?OTMvL2FLZjFiYWVRODB1VVhMd2cwZEw5STRRcGU3V28xYlIwcGRRbEZReWtR?=
 =?utf-8?B?Z0tTSmpEeldPeWpIVmg2MHJmZSt2aWN4U25Mc3JocXgzYmZNOVlvUmYzbXJK?=
 =?utf-8?B?elJicy9QOXMzV205TG9XcjRzanlzYS9Xa1RZVlZGNGhXL0YremNQSHdmMm1F?=
 =?utf-8?B?OFdJZnozVjA2ZEVKYWRRQnVOVGx6cFJRbVhrSlNmZWJvTnNTd1IyRWdhdElF?=
 =?utf-8?B?UUlkM25pTzluZEFoSDlCalN2Z00wd0hnT0FLQWpwWWFKbDdiZ0RRbVFKVWM5?=
 =?utf-8?B?Z09hL3gxL3cxNkxIL2I1WWtIa3hpclBTRVhnYlFXOHJIRkp6ZWJXSTh0Wktr?=
 =?utf-8?B?RVFRenhpTkVTWkJvalV3UEN4S3hMUURYZzByRzVoa0YxMFd0L0I0RjB6NzE5?=
 =?utf-8?B?T1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF233EAD65B9B5498C432FDAFE3D934A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7382.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c72646c0-6ecf-4979-8b15-08db55dcfe67
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 07:13:05.2107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ZH3s5hfPeHRIDQRKZnulOVzCMTuzVyiwyJmDD2IaPGNDLLfoq2wWlI/216gbzerypocQcPlqJfsWVNF+oYsrNJHZe6fyqLNTA+kXv8ktb0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7136
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA1LTE1IGF0IDE4OjI3ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
dGU6DQo+IEZyb206IEFuaW1lc2ggTWFubmEgPGFuaW1lc2gubWFubmFAaW50ZWwuY29tPg0KPiAN
Cj4gWyBVcHN0cmVhbSBjb21taXQgZjg0MDgzNGE4YjYwZmZkMzA1ZjAzYTUzMDA3NjA1YmE0ZGZi
YmM0YiBdDQo+IA0KPiBUaGUgbWF4IHNvdXJjZSBhbmQgZGVzdGluYXRpb24gbGltaXRzIGZvciBz
Y2FsZXJzIGluIE1UTCBoYXZlIGNoYW5nZWQuDQo+IFVzZSB0aGUgbmV3IHZhbHVlcyBhY2NvcmRp
bmdseS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEpvc8OpIFJvYmVydG8gZGUgU291emEgPGpvc2Uu
c291emFAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmltZXNoIE1hbm5hIDxhbmltZXNo
Lm1hbm5hQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogTHVjYSBDb2VsaG8gPGx1Y2lhbm8u
Y29lbGhvQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFN0YW5pc2xhdiBMaXNvdnNraXkgPHN0
YW5pc2xhdi5saXNvdnNraXlAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBSYWRoYWtyaXNo
bmEgU3JpcGFkYSA8cmFkaGFrcmlzaG5hLnNyaXBhZGFAaW50ZWwuY29tPg0KPiBMaW5rOiBodHRw
czovL3BhdGNod29yay5mcmVlZGVza3RvcC5vcmcvcGF0Y2gvbXNnaWQvMjAyMjEyMjMxMzA1MDku
NDMyNDUtMy1sdWNpYW5vLmNvZWxob0BpbnRlbC5jb20NCj4gU3RhYmxlLWRlcC1vZjogZDk0NGVh
ZmVkNjE4ICgiZHJtL2k5MTU6IENoZWNrIHBpcGUgc291cmNlIHNpemUgd2hlbiB1c2luZyBza2wr
IHNjYWxlcnMiKQ0KPiBTaWduZWQtb2ZmLWJ5OiBTYXNoYSBMZXZpbiA8c2FzaGFsQGtlcm5lbC5v
cmc+DQo+IC0tLQ0KDQpUaGlzIHBhdGNoIGlzIG9ubHkgcmVsZXZhbnQgZm9yIE1UTCwgd2hpY2gg
aXMgbm90IGZ1bGx5IHN1cHBvcnRlZCBvbg0KdjYuMSB5ZXQsIHNvIEkgZG9uJ3QgdGhpbmsgd2Ug
bmVlZCB0byBjaGVycnktcGljayBpdCB0byB2Ni4xLg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
