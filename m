Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613BA101EC
	for <patches@lists.linux.dev>; Tue, 16 May 2023 07:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684221233; x=1715757233;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=F0e0ibTVdpVhYAMn/GYoLns1eiK3RlMKYeyjMtXuv2o=;
  b=dztPg6+jXngmv+qK4zjVyPa+RlB1SOPJW9UZJsLeZp4QAk5ntfYvdVjb
   we/RmH0ozNgvqBsbm29MZ3/UQsplYDLBG7ke1V7nN7ATz2WdmqTyy/h3b
   qmTX2PYcnwCwFPYAyQL/kT5u+BqdQ5lh0v0bsekGhXR1UhnOoRe7yUu2d
   0kPJOjaP4v/IYzMQEhCaHW03cA2ISKcpbpZrUcZ+KVlrRnXAHtIjQEeNy
   LxB34+w5DqBOhaHLk+Zuf6+OH75s/2fmxYgulx2yenBVrUPP4u+sIVspv
   0dn+BSvzYQW1OxUZJlvn6P56+QBk9lGeJL+Na6lcT01eAGrHAtXE79GNH
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="331766962"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="331766962"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2023 00:13:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10711"; a="947730545"
X-IronPort-AV: E=Sophos;i="5.99,278,1677571200"; 
   d="scan'208";a="947730545"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 16 May 2023 00:13:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 00:13:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 16 May 2023 00:13:45 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 16 May 2023 00:13:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GgVZMZhvIhzW23+whths+g9C/1T7kAwC3anycbFp+ToUY67+LbYIn4EWEEnnqn05oWLYbn9m864AYMC1IK1pq7QbnY4XeovzJM7Vh5FipKoY9nuFAWcpBSS/wfasQlQpz5FenPsn3DboritEg9f1OHf9AV4vW1b+hUz8dQinzMpiYMER60z3SDfMHEbTNAthYuzL+hEf0M97ogwhIRwWT2yYgEmd6fYZ/WbxOE8CzFAycOH1ScZs35MyE+DCZIgpu70i+SIfHOlb9m9bndqaQz94oKd2teW7aJFhFU44bUv7ORJtsHMtaeRUDNQ7YS3m/oT/7Qv2CFPmLV8CaYgLhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F0e0ibTVdpVhYAMn/GYoLns1eiK3RlMKYeyjMtXuv2o=;
 b=dPmGcVnoheXbj4i7Z6spk39+fpOGWdmuvzHvv/GxMHsS26zyHBOhD35LTS/f79za2YWU31SjIGX61sbA4bePS1JjhPj1cB4jojMzOCnMEvr2huXADto0lDBgd8GJNxlFWHHYI7OxtJJpRqpqTPZXfDdyN38ZvdCQqYEwOSg+pqYFt8AW3iBNUhn2tR3dVyF7Y1vXm3XRB+0IHESCyL6kaGFYl+4Z3UR2WG/yeUvySTytwr0L52kjld7IeSDYPCblHGob0p+Y9Csz7AKQgVHgg//BNaHq+awx+RTFG9EkCVrOZ5Z//v/esFvyy4su8zVeiZRS2pcz8DAtxjeiwO+NGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7382.namprd11.prod.outlook.com (2603:10b6:8:131::13)
 by CY8PR11MB7136.namprd11.prod.outlook.com (2603:10b6:930:60::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.32; Tue, 16 May
 2023 07:13:43 +0000
Received: from DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9]) by DS0PR11MB7382.namprd11.prod.outlook.com
 ([fe80::7c95:e842:18f6:92f9%6]) with mapi id 15.20.6387.030; Tue, 16 May 2023
 07:13:43 +0000
From: "Coelho, Luciano" <luciano.coelho@intel.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Sripada,
 Radhakrishna" <radhakrishna.sripada@intel.com>, "sashal@kernel.org"
	<sashal@kernel.org>, "Manna, Animesh" <animesh.manna@intel.com>, "Lisovskiy,
 Stanislav" <stanislav.lisovskiy@intel.com>, "Souza, Jose"
	<jose.souza@intel.com>
Subject: Re: [PATCH 6.2 213/242] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Topic: [PATCH 6.2 213/242] drm/i915/mtl: update scaler source and
 destination limits for MTL
Thread-Index: AQHZh1IZhNKk8tqmAEWmMZdxPhFgXa9cfT6A
Date: Tue, 16 May 2023 07:13:42 +0000
Message-ID: <51bf59b96c22c2e79d81e38c3dc1b006959a14c8.camel@intel.com>
References: <20230515161721.802179972@linuxfoundation.org>
	 <20230515161728.319620707@linuxfoundation.org>
In-Reply-To: <20230515161728.319620707@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.46.4-2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7382:EE_|CY8PR11MB7136:EE_
x-ms-office365-filtering-correlation-id: e9dde742-ec38-4b89-f6ac-08db55dd14f1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fNOVNZzSVKrd+L5Nb4AGsFy/U6b0fq9T7hAAvlTovZKEK6GaTA8ozaIMyZ2edX/hSXC1y64Q3gDch+V4SQBOR1lmEiLeJa5pVTuybV4YP7t+qs0Cem+GpEd9EBkfoHBADY7E7qcFX7xuoPKxsYBlgirgYSJrgJL0BeYLInm7QBmpHb+y5xWjMW4jaUoL4QI4UNGyAD5ivKa62/W+bTXEiskMEgNn+wxp5+SXhLkLhuAVHVkVBx8yixMvLlNX3L4UIXyFsavDWnE3oZ63bxlqw5LFrXYallPxRbiWQQLWdHlHlS3jHlW38KZvn9XScb95NZhJwFtPt6JFxodtgiIJR4v5ZGATiwONcJnF2h/KJYhmlYJRr7PJPJRpSDLoblYRJH3NougZBwjN7LR4q1uxT/LTbw/9KanKZAWhI3AbxWBaFjHcVLU6bRtuPec/wo/iahtKRTbQjbeXOXQQ9CbhwrnKYtTcayW99agm0IFrb8MV5CiUn4ezX9g86U8oOdlKNwa5apKg9G7yfzhmxvZu10Wr7FxIoMGKc4gCxRgljCA7PaA2IxEfNjFVRRRp76P0
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7382.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199021)(5660300002)(64756008)(76116006)(91956017)(66476007)(66446008)(66946007)(4744005)(66556008)(2906002)(38070700005)(41300700001)(316002)(86362001)(4326008)(110136005)(54906003)(8676002)(8936002)(478600001)(71200400001)(38100700002)(122000001)(82960400001)(6486002)(36756003)(966005)(186003)(107886003)(26005)(6506007)(6512007)(2616005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bjlxV3R4M1J5YjVFeXk2eWhsNjJadTloaktSTXlCYnNjcXpJbFRXNEVZa0xp?=
 =?utf-8?B?UzJQTmxQbjlZVlozOHdaL0JUVzdlM1VCRXVOd1AzRzdyMGNCVk1nNE9jUk9q?=
 =?utf-8?B?Q1hiaWdJS3UwUDV0OEUvUDRFaElrTlVvMkxTWE9FeUhsSWNMdzd0dGNYVDZ4?=
 =?utf-8?B?dEptbVB0VGtPVWlqTGxGMkZYeTFNcEZlSm4yT0xPUFp0c0dqNTd4YmVTcHR1?=
 =?utf-8?B?bTVaNDNtVVlLUGtpVmt4dFlhd2FtR0tBTU9YM2pzbVZvV2w0NndOMWtkKytB?=
 =?utf-8?B?MDJEY25HbUUvaGg4aG4za09wdVNPeEpkNkRFRmkxOTRuYkdncnZtcnM2ZXBp?=
 =?utf-8?B?MzQwczgxZXBDOUdwVHVvbHk4RTZITVBvTjlUZDVoeDNoT3N3eGxSSE9nalQw?=
 =?utf-8?B?MWUvZzBrVzArTldmUEpuRGZoTlRmaExwNHBMbDRWd29wWjU3ME8xY1V4QW5R?=
 =?utf-8?B?RExoRS9IT1BTY3pDK3l3cE13Zkp3cDBucmRXa0NxY1pZS0c3V0dPWEgwaHYx?=
 =?utf-8?B?MlRpLzBGUCtzUkxQVzgyL3JNOXI5TUdEUFNLMFJjdGh3ejlhMFphdnM3QnF4?=
 =?utf-8?B?K29ZTDlYaStNRnZCbVY3Y1dRQWpZM1c5aS83VnA3ZXVuUGdLRHZrR0xDendW?=
 =?utf-8?B?STBJR1QySVZ1c3d4NHRjYVhhLzVZUExBZ1pTZ2Npb2xRVCtKbXZZZk90TVdM?=
 =?utf-8?B?NUtBb0oyWkcrYjVzdzkvY25Tdm5VeWdOYjVMOEFXbjVTdklmMjl2VFRMQUJB?=
 =?utf-8?B?U3FUaEhSNjFxNnJQY3psYytQV1RXS0x6NW5RWDN3empDdThMb1pBSTE2TjFJ?=
 =?utf-8?B?QmNpZVR1QjU4NDRzT2xkejhhZ0h2cGtHN1pLRENIZjRDVksxZlBUbUc0QVVU?=
 =?utf-8?B?Rk5rNEgwVEJvQTU4eG9tUGdNQXgyS0ovZVlWenpDWUJZOFZuZ0NmRlVzUC9y?=
 =?utf-8?B?bFpVV1B0MS9laXNDdDR4ZFNZaUlnemM3Qlp2bHV5NFRGclhQYTZtKzRJSTRk?=
 =?utf-8?B?eDd0WDVqZzlMcHpSYlhOSEt5WDFnK2ZJQWM0eFNOZCttSlJDVkpTcW9ra0I5?=
 =?utf-8?B?SW9IWjlUSXhOVDg1Z1hFdE81bjlvZ2Y4M0ppNFczMENnWkd2aTRzMDRaNmNL?=
 =?utf-8?B?SVVvd1h1WmdsazhGWVROOWV0QmVqMEppZ2VHaWNvOGl3eUt4dmJLNE4wS1p5?=
 =?utf-8?B?aFZTVTFIWGEwSXNtcWR0RjJjMUpZVkd5MHdpenF1T0JOcC9lbGhKSVVWR3pu?=
 =?utf-8?B?WHI3QUZhcCsrVmMwRTBEUDZWR2NNMERWcHE2VlJYTzBXaEhQeUh5bVB1eXY4?=
 =?utf-8?B?RURwb0hZdjZxYUpNOU0xdmZnd1BodS9ZSUJNTjNhcC90dlA3RDE0bHBldTIv?=
 =?utf-8?B?cCtnTERYSzlONDFDazBxdnlRTmpJSXRTVXlmYVpoZGZkekNqMElUWC9iS0RX?=
 =?utf-8?B?WkI2T2FmUStKZkZVbVFpSERVRGxBRXVIaFNITzB3aC9pUjNrV2ZUT1ZYT3BW?=
 =?utf-8?B?MGUxSzNZTVdXRkI0S3FpbWZtUHpmaHNhcEUwV3FQdGZtWGpWL3gySkpHaXVT?=
 =?utf-8?B?emN5RW03bGMxRWdmNnVTQk4yRitjdzVqVFdIQkVISno2N0dOeFg4cytiT1ht?=
 =?utf-8?B?RzZKSG1VcUJ1cENJYmlUVkw3Z3hEQnNpNEdrUENZc0pUeldaTXlaWm8wUnJm?=
 =?utf-8?B?YlFRWU5UUGRhdHZkbm1FZld6amduNVk4OS8vWWFJdDl5cW16NHN0cXIyVFpn?=
 =?utf-8?B?dVRkZEdZTW5yN0Fmb3pRRkg3MUhBdllzTGt0VlVwUGJrODZYQlNvZ0xETGND?=
 =?utf-8?B?TUNlVk1qZnZqQlU0WnZkWEJvck4yV1Vod001ZlIvRnNBVHFwR2djM1dFZFpq?=
 =?utf-8?B?M3NqN1dITGZPR2RZRThRZGxHbWY0UWZLZWpFVldHMkJZV1hGR3NLLzFSbGFB?=
 =?utf-8?B?bG1ZWnFYUTRITVV4Sm1HOWNkMzc0SFFyRFVLWEVrcTNzVzhMTTF5SnJSS21Y?=
 =?utf-8?B?MVlzaUdteGMrbjRXRjAzYXFSWEVHZm9PRVlpRzU2aXROcHllTWt1dGtJOHkv?=
 =?utf-8?B?OG9GVTBiVWQzRnRmZFFwNit2QkpwbFVFV0Qza3ZVSUV2K0JCbWNhUnhKcUlF?=
 =?utf-8?B?d3FnWmpUNVowSlF2YUhxOVAvd2hiMXlrUWVtWlcyRFNhekw4akZLTHhNdUN0?=
 =?utf-8?B?aFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <641214670543804AA2933EC272E3BCE1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7382.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9dde742-ec38-4b89-f6ac-08db55dd14f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2023 07:13:43.0035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lmkbb3ao1aRWjAEszdoQmvM/nu7WK9HnvnvbdTKAMv4AGqaVGcs639vMmitghih/2TIwAV6mlu4Js11oljAZlOVGdTY0+fQCUqYNP3+7T5M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7136
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDIzLTA1LTE1IGF0IDE4OjI4ICswMjAwLCBHcmVnIEtyb2FoLUhhcnRtYW4gd3Jv
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
aXMgbm90IGZ1bGx5IHN1cHBvcnRlZCBvbg0KdjYuMiB5ZXQsIHNvIEkgZG9uJ3QgdGhpbmsgd2Ug
bmVlZCB0byBjaGVycnktcGljayBpdCB0byB2Ni4yLg0KDQotLQ0KQ2hlZXJzLA0KTHVjYS4NCg==
