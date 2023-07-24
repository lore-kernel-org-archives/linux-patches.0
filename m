Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F2F101E0
	for <patches@lists.linux.dev>; Mon, 24 Jul 2023 19:38:27 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9rKoV3O4BKE4CYcGY/BZtJVlkgzn85yOgo98+K6RISAOdlBp1khoZ8+3/MVgm6k1hYG0i24Id55F0WvuZwE+BjrC+vcJkfsl/r+0X0GgjxPx3mHkxGGbAJUMtBJ7wyiXwlD6kWfpAjNTyatHWhnMf6+PyAtBDYyCJT4nGqFHaYCUhctJ0CyeT4eFMVAwzjXhP+JCweIE9RxN+RY6Zgp5j3Ejv9chTqEcR6YDd097CNXXZWOf+eSNhxOzC/Om+otrzzXJOhU5+JmN7SGVm57i/PweBX5QULLB/a4OSyoGyzsRuzXTatBA7FVb023r5SearsksWeLCsmi6iGeB7naig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37htcgLdzXns9FL4GjHTZPQANMtCWi+JLOnWaVberDE=;
 b=VeEgNsy44UpXb8aCoiMaDHNCWMKAi/EUoS/3ullJncVkeCn8uBsIEfpt62Y4Rbiq1i4F4t+O6hCHgjdDb+FY7gH0leRZTtq9ZF79x4zHId3hNyhTHtnxk+3JlyBR83GcBelHTauoaSxiNjeipC22I18UQiLj6LWsnifmiDC6qU8ZTAWfXtlc4Md0pG5iqsHt65UytWi9w9nVer+3YDs3WDYtb+oXhsogQ7jpdX4Vo3w/MsIfEzSE9gJQ+huwyJ7wnGy5uKyLCjiMJZl9XvCQQIMgI7hLvaErzbH4DNKhDmReIPYtIoHiCKctp6Gd8tYRk7W6vzBLLyLTFYGj6LHBlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37htcgLdzXns9FL4GjHTZPQANMtCWi+JLOnWaVberDE=;
 b=NElM60KQiR3JMdtkb0Ip15Yv8OSrQnNthrV6LvZwgWvJqQMoD8S9f/3hH8bQ6YWc5s8yuT+ZD2Pmpwn+YR8uL7nk/aDe2pJPlX0r5FAd2SdfUYLWHtxVFXjwowAk687rFXu5ReHhh4HEYpLgjnXhTleBBbytpkokZoiKLgCmce0=
Received: from BL1PR12MB5144.namprd12.prod.outlook.com (2603:10b6:208:316::6)
 by CH3PR12MB7642.namprd12.prod.outlook.com (2603:10b6:610:14a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.32; Mon, 24 Jul
 2023 19:38:24 +0000
Received: from BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::bcfa:7757:68bd:f905]) by BL1PR12MB5144.namprd12.prod.outlook.com
 ([fe80::bcfa:7757:68bd:f905%5]) with mapi id 15.20.6609.032; Mon, 24 Jul 2023
 19:38:24 +0000
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Alex G. <mr.nuke.me@gmail.com>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Limonciello, Mario"
	<Mario.Limonciello@amd.com>, "Wang, Chao-kai (Stylon)" <Stylon.Wang@amd.com>,
	"Wu, Hersen" <hersenxs.wu@amd.com>, "Li, Roman" <Roman.Li@amd.com>, "Wheeler,
 Daniel" <Daniel.Wheeler@amd.com>, "eniac-xw.zhang@hp.com"
	<eniac-xw.zhang@hp.com>
Subject: RE: [PATCH 6.1 146/223] drm/amd/display: edp do not add non-edid
 timings
Thread-Topic: [PATCH 6.1 146/223] drm/amd/display: edp do not add non-edid
 timings
Thread-Index: AQHZvAj6buwkqWQYo0mM3JSjtc7v2K/JUIaAgAAEEpA=
Date: Mon, 24 Jul 2023 19:38:24 +0000
Message-ID:
 <BL1PR12MB5144A568ECEB3E9E18BA74C4F702A@BL1PR12MB5144.namprd12.prod.outlook.com>
References: <20230721160520.865493356@linuxfoundation.org>
 <20230721160527.097927704@linuxfoundation.org>
 <18e9e042-12ec-8e09-1225-ca44810e2b82@gmail.com>
In-Reply-To: <18e9e042-12ec-8e09-1225-ca44810e2b82@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ActionId=ab10542e-9424-464b-a500-b99f0bb2032d;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_ContentBits=0;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Enabled=true;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Method=Standard;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_Name=General;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SetDate=2023-07-24T19:37:51Z;MSIP_Label_4342314e-0df4-4b58-84bf-38bed6170a0f_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR12MB5144:EE_|CH3PR12MB7642:EE_
x-ms-office365-filtering-correlation-id: 0b7035fb-617c-483e-f34e-08db8c7d8bcb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 zSiYui4+KJU+OcrGGcGtIe8BFUzDF/KxT4OEVT0VDkjvgi2Up8Z21BoT2A7jlp/RApYI++32ahUoSZYM9z8trEZTDcN1ktnfeZNMpJbLjfjdIi2TqqgpxJep+ooA2vKGrKTtnqE2/A2sPa0lmgsKhe0czradFwRy5yo8kqrGyL3i2RHkzjtuGBi/fsFS4vRiVG1+PJ8N1QtxMvoaoq60kq2W6YzSYxRIA8QhbsRCCOP2FWwQKTFJ9YqtgnN2+v/sdhDXpOFplyksOh+fg0LsoXeyjWv/OYMWjCzQYVWaXvxecRxRKgyFyNUsofNcn8h2Wiw3Y9LfrzQzOwZZlDAJX31XzJqlWDJM0OWHcmt/K65uIDUPqjcNRKOM5w8Oa9IjHJ7EWqDTldpRJ5B4g2B3Z92GhpO/NeT4sQtsz839OJqafUXy2AWtCBHTmwjXcR75D18w6dtnSCHTwEVZOd5+5g/l70UlA/xJulQf3Var5OK570Ui9HOWzDbF3nrduqvj2vivxyziYY9sOWTh8x3QZKXTd4JI5+i7tOvodwZJYRl0pvvMMS8bWZReAaZ7jOxzVbreDcgycyEhYhTp4bKugHORS+zTU6vgCzNQFS0ekqJSEjrNI33tHfVv+l4KgdEv
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5144.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(136003)(39860400002)(376002)(346002)(396003)(451199021)(33656002)(38070700005)(86362001)(55016003)(38100700002)(66446008)(66476007)(64756008)(66556008)(4326008)(110136005)(478600001)(54906003)(66946007)(41300700001)(76116006)(316002)(52536014)(5660300002)(8676002)(8936002)(9686003)(7696005)(2906002)(71200400001)(6506007)(186003)(26005)(122000001)(83380400001)(53546011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?a08zUlNRendScHR2cXgyZU9tYUIxSWhJNUtKdmV6YlM0S0pvbm5McnAwOGFx?=
 =?utf-8?B?SW1sUkdQZXdBL2FYUzdsajJFb3NFT0tNZUhPeVJLZGZ6K2NsWlVaME5DOTVp?=
 =?utf-8?B?SGpkTjZXcXkweGNnZmFoTFUzSmRiZDFBWkxMT1JuVVFaWVRuMCtjSXhzdWw2?=
 =?utf-8?B?cFU1TVFxeHNiZmhYZ3ZOcWlucUtqdzlucGl6amxZeHJXWmRXOElpVXZRMDVt?=
 =?utf-8?B?cDFQVlJ5ZGdQUHIwTWpFODVHQm9GQVdHSGtIM2RtdCtFaDM4OU51S3UzZmg0?=
 =?utf-8?B?WHZuYmgxQ0R0dGpzL0R0WFp2dGxXS21TWGZZb2h4QmRCN0g2WHZlclFCSlcw?=
 =?utf-8?B?UTlDUWtYRFBDRzFJb2U0eWhkRHRhNFpmK2doNTR0MXRMQ0d0NFhTZXhCdWhW?=
 =?utf-8?B?ZTVoR0wzQ0FFbG9peDZrdjdBOExOTnRibnJKbkxZUnFkajNXQWNXRmx5bnZo?=
 =?utf-8?B?TTVKVTREZnRVeExQOWlaSWhLNC84bVZkMUcrZGdCa3NxQlpPOU1nWGl2cDBJ?=
 =?utf-8?B?UCtkL1RlRDM4RldDMTJuclJPMXV5bUJQMEcxTTBhSVJzc0xFWEJQOFA3L2Nw?=
 =?utf-8?B?WTYxcGJBL3JLREFjUXRyUGVjVWFzQml4K29peEx1TUR3a2FWK0NGQXJjUmwy?=
 =?utf-8?B?QUV1UEtOSlFYanl5K2xzOEVrNWF4MzlVdkN5NkRHTDFGWFpLdkZJUURaSkJT?=
 =?utf-8?B?WUYwOEtGZXMvQkovYVJpekhpU2luL0djMzZxZmVvM244QTBWWDFGSVd6R0Vr?=
 =?utf-8?B?UTJBOGNIWDUrVERlWXhzTWVnMzd6cUhZN3Q2OXFUSkE1SEU5QnlTeEVXU041?=
 =?utf-8?B?TVp3NGQ3TDdlcTFWWWUxWEdaM2RsTE55azc5MWczRGNlRVpZQW85TFladEI2?=
 =?utf-8?B?Vkpmdit2RFlUcFhpSWMvODVBN2cxeGZkeDBZUjVkV093VXZ5Q3g0VHlsc2hl?=
 =?utf-8?B?Z0hnRnJYbGpqNUMzWERUTVh3cnV2cjdjOUswTUtEd2YyREdxakpXeFdGVktI?=
 =?utf-8?B?c0tQVHE2a1JYUk5FZlUrVmxCNWZaR1hHdTRqMk4xMmd3NjJBSERtVVpMeXM0?=
 =?utf-8?B?UzZYU0tENDNuQVpBTUc4WmI0WE56QVMvTDJ2Q0huTmR4aTZWR0RMd2tmczRQ?=
 =?utf-8?B?UmIwemRkR3BrQkw4cDBsUFZRUmxlMWc3NE85WjJQN0dxRkRwbENWaXNyRWMy?=
 =?utf-8?B?SGozZDFEbkZDTUhNbStZS2NueEZDRkRHczMrcjNldVFQU3IxTXlDWjVYY2p0?=
 =?utf-8?B?RTBlK1V6MDJiRWhYdHVTNmNUOGNsR2xUUGt5S2RxWlkwZi9qei9PdGI4S01S?=
 =?utf-8?B?aU9UZXZ2NWVmM1IzY0hKcXA1c1NPTHAwcmtnbDgvZWw1WDVhT0dhRGpFK0pW?=
 =?utf-8?B?VmFVV2N3UjVrVjNoZ01RSzNVeG5wRDdRYUJHeDh1bWdEVWNaNU5NdWJsbzNW?=
 =?utf-8?B?SzZ5enFTbHFNNVg5MVhodDlKWFYxNTJLMXJkWFhHOFk2QUowSHFnTThEZFk3?=
 =?utf-8?B?UUUxNUNDMnlBQlZNU1pXRUJmYnVwamZ5VEt3RlEwSzQxbXExbzZFOUd4QU5G?=
 =?utf-8?B?YWx1Q3ZoV3FTRElXc29jL0FuZVl2NU1NMG1Wb05rSXRCdzFWZi9SbmhvNE5r?=
 =?utf-8?B?a2NvdTZxNTlNa2pGb3liOTNpdDI1ZythUFZVRnJMSDlsNkdZU2s1WUhaN3hQ?=
 =?utf-8?B?c3VjWXd0V2szdWtZdUVyL0l6cjdPMzJSR3F4WjZ2Uk1Qd1h6Z0hYdTVDLzlK?=
 =?utf-8?B?OC9tbUV5eHVGd1A1by8yUmtCZ2hka2FJL0dld0M5MXpnMGpPRmlOWjd1WExJ?=
 =?utf-8?B?bzdFcXh4Ull3RjhXYklVaDdIUWhZR2JYL1VFcHhNOVAydzlaMVMySzhHcmdB?=
 =?utf-8?B?NFkzRkdORkdBb3pDSi9EdXk4cENaVkZFNnNIZ2FkZitlZU5aaGpVcFBUWUZY?=
 =?utf-8?B?Z2pHK3o0OEpLOGt2ZGZQblpoY1ROV3FlUHM3T1NKcmNMUmVvZTNvK2U5OXpw?=
 =?utf-8?B?NkxYZGRVSVQ3RExXT0ZRUFY0dzlnblp2QnUwOGFkeTFRbmdiSUJDS3R3ZFMv?=
 =?utf-8?B?MCtRTzVNbDVuMGZEd29nVFBxUWMxNXQ2eW42cGZpclNkSXZJcmptYXY5SzFQ?=
 =?utf-8?Q?rV9w=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5144.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b7035fb-617c-483e-f34e-08db8c7d8bcb
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2023 19:38:24.6804
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cPOT8GnKgxev8Jexh5+rJ0wIUMDVcnodyvas0KTnjYNtSPe5M7i2f/ev9XYDtDn3LV7XWPOqeEEKotyxbsu7/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7642

W0FNRCBPZmZpY2lhbCBVc2UgT25seSAtIEdlbmVyYWxdDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gRnJvbTogQWxleCBHLiA8bXIubnVrZS5tZUBnbWFpbC5jb20+DQo+IFNlbnQ6
IE1vbmRheSwgSnVseSAyNCwgMjAyMyAzOjIzIFBNDQo+IFRvOiBHcmVnIEtyb2FoLUhhcnRtYW4g
PGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPjsNCj4gc3RhYmxlQHZnZXIua2VybmVsLm9yZw0K
PiBDYzogcGF0Y2hlc0BsaXN0cy5saW51eC5kZXY7IExpbW9uY2llbGxvLCBNYXJpbw0KPiA8TWFy
aW8uTGltb25jaWVsbG9AYW1kLmNvbT47IERldWNoZXIsIEFsZXhhbmRlcg0KPiA8QWxleGFuZGVy
LkRldWNoZXJAYW1kLmNvbT47IFdhbmcsIENoYW8ta2FpIChTdHlsb24pDQo+IDxTdHlsb24uV2Fu
Z0BhbWQuY29tPjsgV3UsIEhlcnNlbiA8aGVyc2VueHMud3VAYW1kLmNvbT47IExpLCBSb21hbg0K
PiA8Um9tYW4uTGlAYW1kLmNvbT47IFdoZWVsZXIsIERhbmllbCA8RGFuaWVsLldoZWVsZXJAYW1k
LmNvbT47IGVuaWFjLQ0KPiB4dy56aGFuZ0BocC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCA2
LjEgMTQ2LzIyM10gZHJtL2FtZC9kaXNwbGF5OiBlZHAgZG8gbm90IGFkZCBub24tZWRpZA0KPiB0
aW1pbmdzDQo+DQo+IEhpIEdyZWcsDQo+DQo+IFRoaXMgcGF0Y2ggd2FzDQo+ICAgICAgKiBvcmln
aW5hbGx5IGFkZGVkIHRvIHY2LjEuMzUNCj4gICAgICAqIHJldmVydGVkIGluIHY2LjEuMzkNCj4g
ICAgICAqIGFkZGVkIGJhY2sgaW4gdjYuMS40MA0KPg0KPiBUaGlzIHBhdGNoIGlzIHN0aWxsIHJl
dmVydGVkIGluIG1haW5saW5lLiBXYXMgdGhpcyBwYXRjaCByZS1hZGRlZCBieSBtaXN0YWtlIGlu
DQo+IHY2LjEueSBzdGFibGU/DQoNClllcywgdGhpcyBwYXRjaCBzaG91bGQgc3RheSByZXZlcnRl
ZC4NCg0KQWxleA0KDQoNCj4NCj4gQWxleA0KPg0KPiBPbiA3LzIxLzIzIDExOjA2LCBHcmVnIEty
b2FoLUhhcnRtYW4gd3JvdGU6DQo+ID4gRnJvbTogSGVyc2VuIFd1IDxoZXJzZW54cy53dUBhbWQu
Y29tPg0KPiA+DQo+ID4gY29tbWl0IDdhMGUwMDVjNzk1NzkzMTY4OWEzMjdiMmE0ZTczMzNhMTlm
MTNmOTUgdXBzdHJlYW0uDQo+ID4NCj4gPiBbV2h5XSBtb3N0IGVkcCBzdXBwb3J0IG9ubHkgdGlt
aW5ncyBmcm9tIGVkaWQuIGFwcGx5aW5nIG5vbi1lZGlkDQo+ID4gdGltaW5ncywgZXNwZWNpYWxs
eSB0aG9zZSB0aW1pbmdzIG91dCBvZiBlZHAgYmFuZHdpZHRoLCBtYXkgZGFtYWdlDQo+ID4gZWRw
Lg0KPiA+DQo+ID4gW0hvd10gZG8gbm90IGFkZCBub24tZWRpZCB0aW1pbmdzIGZvciBlZHAuDQo+
ID4NCj4gPiBDYzogTWFyaW8gTGltb25jaWVsbG8gPG1hcmlvLmxpbW9uY2llbGxvQGFtZC5jb20+
DQo+ID4gQ2M6IEFsZXggRGV1Y2hlciA8YWxleGFuZGVyLmRldWNoZXJAYW1kLmNvbT4NCj4gPiBD
Yzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiA+IEFja2VkLWJ5OiBTdHlsb24gV2FuZyA8c3R5
bG9uLndhbmdAYW1kLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBIZXJzZW4gV3UgPGhlcnNlbnhz
Lnd1QGFtZC5jb20+DQo+ID4gUmV2aWV3ZWQtYnk6IFJvbWFuIExpIDxyb21hbi5saUBhbWQuY29t
Pg0KPiA+IFRlc3RlZC1ieTogRGFuaWVsIFdoZWVsZXIgPGRhbmllbC53aGVlbGVyQGFtZC5jb20+
DQo+ID4gU2lnbmVkLW9mZi1ieTogQWxleCBEZXVjaGVyIDxhbGV4YW5kZXIuZGV1Y2hlckBhbWQu
Y29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEdyZWcgS3JvYWgtSGFydG1hbiA8Z3JlZ2toQGxpbnV4
Zm91bmRhdGlvbi5vcmc+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL2dwdS9kcm0vYW1kL2Rpc3Bs
YXkvYW1kZ3B1X2RtL2FtZGdwdV9kbS5jIHwgICAgOCArKysrKysrLQ0KPiA+ICAgMSBmaWxlIGNo
YW5nZWQsIDcgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiA+DQo+ID4gLS0tIGEvZHJp
dmVycy9ncHUvZHJtL2FtZC9kaXNwbGF5L2FtZGdwdV9kbS9hbWRncHVfZG0uYw0KPiA+ICsrKyBi
L2RyaXZlcnMvZ3B1L2RybS9hbWQvZGlzcGxheS9hbWRncHVfZG0vYW1kZ3B1X2RtLmMNCj4gPiBA
QCAtNjk3Miw3ICs2OTcyLDEzIEBAIHN0YXRpYyBpbnQgYW1kZ3B1X2RtX2Nvbm5lY3Rvcl9nZXRf
bW9kZXMNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZHJtX2FkZF9tb2Rlc19ub2Vk
aWQoY29ubmVjdG9yLCA2NDAsDQo+IDQ4MCk7DQo+ID4gICAgIH0gZWxzZSB7DQo+ID4gICAgICAg
ICAgICAgYW1kZ3B1X2RtX2Nvbm5lY3Rvcl9kZGNfZ2V0X21vZGVzKGNvbm5lY3RvciwgZWRpZCk7
DQo+ID4gLSAgICAgICAgICAgYW1kZ3B1X2RtX2Nvbm5lY3Rvcl9hZGRfY29tbW9uX21vZGVzKGVu
Y29kZXIsDQo+IGNvbm5lY3Rvcik7DQo+ID4gKyAgICAgICAgICAgLyogbW9zdCBlRFAgc3VwcG9y
dHMgb25seSB0aW1pbmdzIGZyb20gaXRzIGVkaWQsDQo+ID4gKyAgICAgICAgICAgICogdXN1YWxs
eSBvbmx5IGRldGFpbGVkIHRpbWluZ3MgYXJlIGF2YWlsYWJsZQ0KPiA+ICsgICAgICAgICAgICAq
IGZyb20gZURQIGVkaWQuIHRpbWluZ3Mgd2hpY2ggYXJlIG5vdCBmcm9tIGVkaWQNCj4gPiArICAg
ICAgICAgICAgKiBtYXkgZGFtYWdlIGVEUA0KPiA+ICsgICAgICAgICAgICAqLw0KPiA+ICsgICAg
ICAgICAgIGlmIChjb25uZWN0b3ItPmNvbm5lY3Rvcl90eXBlICE9DQo+IERSTV9NT0RFX0NPTk5F
Q1RPUl9lRFApDQo+ID4gKw0KPiAgICAgICBhbWRncHVfZG1fY29ubmVjdG9yX2FkZF9jb21tb25f
bW9kZXMoZW5jb2RlciwgY29ubmVjdG9yKTsNCj4gPiAgICAgICAgICAgICBhbWRncHVfZG1fY29u
bmVjdG9yX2FkZF9mcmVlc3luY19tb2Rlcyhjb25uZWN0b3IsDQo+IGVkaWQpOw0KPiA+ICAgICB9
DQo+ID4gICAgIGFtZGdwdV9kbV9mYmNfaW5pdChjb25uZWN0b3IpOw0KPiA+DQo+ID4NCj4gPg0K
