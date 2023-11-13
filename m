Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A88923742
	for <patches@lists.linux.dev>; Mon, 13 Nov 2023 20:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dT/UdQla"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699908553; x=1731444553;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iRuikSGHOYD3OlJ7iGWAVFWeOvQKtVrL6h80tQodIUU=;
  b=dT/UdQlar7iTbd9kwSiBcMfo/9c9ptEqXdwKXaxd4joRXobxCzn8kim6
   qtay3fnFS4hstpNRauG9/m+ImrrsYlL4flMfdW2TaATpSPfpuwCfbBCxj
   jFBoIfXOtojE690GRDgZb0c51VHKV1ghdbAEAS8G2XwXvHxSdJZWPRMmN
   gXEnT5DnF1GPk0NqY2MNcJq2QHkNfUfjIlc8SeCZerHsNXcpa16qtXwIw
   26pzdJstvmKBqEsle/91RK8buQ7358yN/czE2Zt9Nd7TZ1QSFtiZCwVou
   tEdWyki9Ip1tU6gqUqcFO/9cJiqCYIW/vu1d6zbQBm3+ZzMmZA3xqY6f+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="9152396"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="9152396"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2023 12:49:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10893"; a="855073206"
X-IronPort-AV: E=Sophos;i="6.03,299,1694761200"; 
   d="scan'208";a="855073206"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by FMSMGA003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2023 12:49:09 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 13 Nov 2023 12:49:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 13 Nov 2023 12:49:08 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 13 Nov 2023 12:49:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WiDNb6lUClNtxg9uiHZtH6Md1qiQxTdhpELPSQ6vdWKWgm0nlFoCTr5looCAIaqhgve45yHL2UUGjQA3ktNceyFyN1I0JoJvuGoEGTmvZla4FpSE5OLIjOja0aPiwMncoa5jTZNk+qSwAKG7spPmQEb8H6xaQh92nXYzVsegjV7FiosgRWB5r7zB1BqgWdD+B0m2vyXnQGdiSis14j7AeOwq+G6jIy6yt9MB0VqI9YlHTptP23aegIUEjmC20mljBcrJSOGKuT6mZ9dk9/nUABDtoN03BXmn/vjkatuUQecaaBmx6Y7oWLMj9YOdsI+0iiv/WoOr66u98TFeV+tvkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRuikSGHOYD3OlJ7iGWAVFWeOvQKtVrL6h80tQodIUU=;
 b=JyNauQ32xtP1HbPqjgP5MV56wo2xnl6n/zc3Jv5Y0A11Bq+cc5w0Iy/ANAygNzELSRnKdz7suTX2cHma0jA1idrrEWqZOQXLCLXY7POMWVFzBWbUBZEwADITslxcp4wtlpPS1hkvDMl/JBX0f9Yah9iqWUJ2xbYzWQCboaYrdobmHMD06/aGduYf6WSeX2XsJX/T0xU2RkmnxS2KkoJB8n/jptnjYi7lM/t9yKPYZqOIBdX+nzAfIxhIGM82CkTuprspzUcCyEkooYHkx8SwZ6nDQ928MZyCrXYAbZquf4NB5aAuDr/35s/DyBGCizkIMTb0SggsyN7uhZcWGAt8yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by CH0PR11MB5426.namprd11.prod.outlook.com (2603:10b6:610:d1::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Mon, 13 Nov
 2023 20:49:05 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::2b58:930f:feba:8848]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::2b58:930f:feba:8848%6]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 20:49:05 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "babu.moger@amd.com" <babu.moger@amd.com>, "Yu, Fenghua"
	<fenghua.yu@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, Peter
 Newman <peternewman@google.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, "x86@kernel.org" <x86@kernel.org>
CC: Shaopeng Tan <tan.shaopeng@fujitsu.com>, James Morse
	<james.morse@arm.com>, Jamie Iles <quic_jiles@quicinc.com>, Randy Dunlap
	<rdunlap@infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v11 1/8] x86/resctrl: Prepare for new domain scope
Thread-Topic: [PATCH v11 1/8] x86/resctrl: Prepare for new domain scope
Thread-Index: AQHaE2HVE2enl7pt+EqCPfX8h7wjVrB4qoeAgAASpgA=
Date: Mon, 13 Nov 2023 20:49:04 +0000
Message-ID: <SJ1PR11MB608303EA4CD81FB434CC0507FCB3A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20231031211708.37390-1-tony.luck@intel.com>
 <20231109230915.73600-1-tony.luck@intel.com>
 <20231109230915.73600-2-tony.luck@intel.com>
 <fdfefd2b-28c0-4961-8bec-6bf5c5fe58a2@amd.com>
In-Reply-To: <fdfefd2b-28c0-4961-8bec-6bf5c5fe58a2@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|CH0PR11MB5426:EE_
x-ms-office365-filtering-correlation-id: 59f54663-d3d1-42f0-a2cd-08dbe489f973
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /xDqtCPwtnYFjFetwVzCsCjd+RL8hBLpYtdccvFhto10hGqdbOTXx7rvEf0iEsW7TBhLXJX3N0KZx2coc1vzdbLCr/JpaYGYgcLhggwzpGKnJcKZ/HM9eQLXMvkwNjy9OEcWIqComcKX09IZs4J3dGlQd+Bd2mEVBVrfZHgNtoOilllNQ18wEBcsZeE0jeJdbtfmSfD9A+GughW5MUQCmH3FnGwawoxJtOVcqWLv7sgApyA6pTcFZEoLP+8pKLmWI4m/pE2toY8vCwBT5RNWFLw+ROAQpZgTN19trEpMjsLIMjVsT/or3JkES4RSgQwkK26X8vnIQtWKWEah1oo9rnUxQ9WIaP5+8x1JWdMhVrY53pvPLuc4/dN3JNI4QfDG2uS0O4DYS/YKlTv1jwhDJF7t88MQKSHkF55OSI+/nWvrJh2TKqa66eWoDv+UYxEHpqegOOUGEQnNDtcOTsM7aDjO7VsQzuhwMUPI5EneAZUfzmUKYX+EcJWIwuVFgLDFtRQFCMZCXGyNMMPtYBbK3gR7ruzj0J1qJSuvvT+S0ujELJ718Gej8SD1KIqsPvJy9Clj7/42c8gmdD2i8MICQTpIF5Q+4HHnncik6MaHzG5rOwdIu+sJ20c8Uxla8qSS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(376002)(346002)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(55016003)(26005)(66556008)(64756008)(66946007)(66476007)(66446008)(54906003)(76116006)(38100700002)(122000001)(38070700009)(33656002)(86362001)(82960400001)(9686003)(71200400001)(6506007)(7696005)(4326008)(2906002)(478600001)(110136005)(316002)(8676002)(7416002)(8936002)(4744005)(5660300002)(41300700001)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NkpmRk93Q3JaeU1CRzhxeFVpMVNDZ0FON1RqUFExL2FLdEV4a0ZIdHhBbXl1?=
 =?utf-8?B?ZjN1bXJWUjN3eXFZa1E5YTZBdS9ZQXJoMkxZMUtXR2ZtZ3JtbGxoZG9SZ3JM?=
 =?utf-8?B?QTE0MERJSmY0c3QvbXpYVUN3VmN6OHYrT2JuR204TCt1UDFIWHg2ZG9JSlJt?=
 =?utf-8?B?Uk5OSisxV0JFWlZCdlNPS2gwRU1JSnhrSWJXYS8xcnh6andWZUVZd1EzYWM0?=
 =?utf-8?B?VnpQSlJ0c1NRSlF3S2JNcWpKeTArME1VZFQwckppTkZCU01QalF2WStTSFQx?=
 =?utf-8?B?MWJ0NzJFeDhYSVlSOEtCREN2eWhGM3FRT1dHcGdUL28weHA1dyt4YmlLeXFM?=
 =?utf-8?B?VlJlV2RIeUpaa0ZyL1FaMldER090MFM1dmhpeHd6aC84OVFXKzA3ekQwT29Y?=
 =?utf-8?B?Mm94RkhaNDA1NW8wQis2c2hEdTR6b0hyakVWV3A2RU83a1l3ZW1FRVdtTFdQ?=
 =?utf-8?B?SW5pZm9mYWRTUVplSHllRVd4UzVEODdIVVZhRDBTVFNDNFZHUU0zMndsK24r?=
 =?utf-8?B?Yml1TFAxckNLOUppTjJFTGpiZWI5aElsTEthQkl0dDF5QjA3TVhWYmxSUVJG?=
 =?utf-8?B?TGJNZFBacFFYV25EcHFDeVkyWWRxbUt2K0s2OFVQcDlLRjl4QS8yeDRycTBx?=
 =?utf-8?B?SlJnUjA1UmhtM2N1RmdIQjh3VmNyem9IMkdYODZ5aDl1QXhxZWhBOEd1YVhk?=
 =?utf-8?B?VVdQTDlERnB2WE9EY3pza0Mrd0xQTWFqbjh5b0U4L0NEUWJCRGlkUUJoalNL?=
 =?utf-8?B?SWNYZEUyU2hCdmsrUll3aW9ITWl5THZVTUtxLzZVRjJKcFNqR09uQWZEQ2Fw?=
 =?utf-8?B?c1dHUDBPMkxPTjNIRHArVFV5Z3JDeFBtdE1XclhRYzdpTk1WckEwNkNuTkZJ?=
 =?utf-8?B?SFNLY0Z6bE5yRmpxSnI2SHNyYXR2aDJuRzByTlFjVWppb0p4TW50YXRENzZD?=
 =?utf-8?B?QjlhYnhUeFVtOHh2YXIxNTA2ZGlJdmdwM1M2S2NYa1hFQUl5UjZDTnRKVXRj?=
 =?utf-8?B?QUo4L21qa0tCcFZ6a0o3THFPazdFcVBhWGREZVFkTUFvYkVLZHF4YWdHekpG?=
 =?utf-8?B?a0VwOGc4MzJzVVMwZjNDMUZOL1JYTzhxQjdxYWJFV1RNOWo3UXVWRUpMQ09S?=
 =?utf-8?B?blV5Zk91cWNQZzlaeDlOQ1pyMGp6bnoxTVE5SUVVVzQ1N2UrbmdONlJkbjhS?=
 =?utf-8?B?VGMzczMxeU55SVB4c01sbGFXS1kzK2R1N1M2amxmcDd5anhNWDg4cXpUbDkw?=
 =?utf-8?B?Z0ZBbGs4L0Z4SldUU3orSURxQmZiei9YM091WDRScTAvV25SVGlqWm1RYldz?=
 =?utf-8?B?TVduQW9id21MRUM4Q0xySnJFME9hKzBpRjFJOWg0UjlGN2J2U01lamZ4UGo0?=
 =?utf-8?B?WWpRNTlJcUFxUUVzcTBWUFM3TmFHc3dPSUVucTVacmNkYzdxR254WWF1cDVQ?=
 =?utf-8?B?L3FtQU8xcDFsbGw4WmhnWFFVVzlvL2JkSHRsd0EzZmNMS1pEUnlPa0NKdGpJ?=
 =?utf-8?B?OENYSHRZa2lrYTZIR2JWdnpIckpzSWlwSEVCWVhPTmJodW9QMnErUEFsTjBE?=
 =?utf-8?B?SGVOa1ZUOFBzL0x3eXdBOEpZb3dVM3pFYnVjVUJENmJxVHZqK3lsZ2M3VXNV?=
 =?utf-8?B?VkpFVzlCK2NrbEFsSG00WXZTTmt1dFdNQ0pSZTZ5Z2prS0JyWEZFUFEraUw4?=
 =?utf-8?B?eEsxMjRTdmRobW8vVHQ3emJDWVR1RHRucStoOTAzVTJvSFhOMUtGaVBSekI0?=
 =?utf-8?B?THpwa05IOUhabEU3bk5tanBQWk1HKzVyMGcrMVAzN0w4ZEFTUDdqUEs2eGh5?=
 =?utf-8?B?WnBKeW1uTkliZ2M1TmpFLy9jQUxvNS90R0JOZnlzclhxZ1h3czF2c0xkNnpQ?=
 =?utf-8?B?ZkF5R3hQcWNhNlVqRmxsTlpqR2o0bWpvc1R5WXBwM3phNmFMYnQ1VENDTUlZ?=
 =?utf-8?B?KzFrczE3anZKQWI3UnNUS0dsTFdBM3UyNEJGV3dnZmVFdkY3UnRheFB1OUJU?=
 =?utf-8?B?eG9tbWt1RGVSNXlJcmVCQzBOblZSTVdWdXBuK3dLZVM2YUdMRmdiclB5QnhY?=
 =?utf-8?B?T213aE94MG1MTkJ3Z0JjUFZIR1ljRFhJaHhJVnRoQnFMTTY5Y1NaSk5ISitE?=
 =?utf-8?Q?oHsm3Lol61n1p89qab5VVdtHN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 59f54663-d3d1-42f0-a2cd-08dbe489f973
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2023 20:49:04.9727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EbGeGcJTEunJQtMMszkBMU5A5Q5VN8XYNt71h4ebEACITtXJ8Qg13KR5zD47nzGv1E6AKXAAfji9Vt2DiYHK9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5426
X-OriginatorOrg: intel.com

PiA+ICtzdGF0aWMgaW50IGdldF9kb21haW5faWRfZnJvbV9zY29wZShpbnQgY3B1LCBlbnVtIHJl
c2N0cmxfc2NvcGUgc2NvcGUpDQo+ID4gK3sNCj4gPiArICAgc3dpdGNoIChzY29wZSkgew0KPiA+
ICsgICBjYXNlIFJFU0NUUkxfTDJfQ0FDSEU6DQo+ID4gKyAgIGNhc2UgUkVTQ1RSTF9MM19DQUNI
RToNCj4gPiArICAgICAgICAgICByZXR1cm4gZ2V0X2NwdV9jYWNoZWluZm9faWQoY3B1LCBzY29w
ZSk7DQo+ID4gKyAgIGRlZmF1bHQ6DQo+ID4gKyAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgIH0N
Cj4gPiArDQo+ID4gKyAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICt9DQo+DQo+IFRoaXMgZnVuY3Rp
b24gaXMgbWVhbmlnZnVsbCB3aGVuIHlvdSBpbnRyb2R1Y2Ugbm9kZSBzY29wZSBSRVNDVFJMX05P
REUuDQo+DQo+IENhbiB5b3UgcGxlYXNlIG1vdmUgdGhpcyB0byBwYXRjaCA1Pw0KDQpDb2RlIGhh
cyBiZWVuIHRoaXMgd2F5IHNpbmNlIHY1LiBJJ2xsIG5vdGUgeW91ciBvcGluaW9uIGFuZCBpZiBv
dGhlcnMgYWdyZWUgSSdsbA0KbW92ZSBpdC4gQnV0IEkgdGhpbmsgdGhpcyBpcyBhIHJlYXNvbmFi
bGUgcGFydCBvZiB0aGUgZmlyc3Qgc3RlcCBtb3ZpbmcgYXdheSBmcm9tDQpwdXJlbHkgY2FjaGUg
c2NvcGUgZm9yIGRvbWFpbnMuDQoNCi1Ub255DQo=
