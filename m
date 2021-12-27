Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F58729CA
	for <patches@lists.linux.dev>; Tue, 28 Dec 2021 15:46:19 +0000 (UTC)
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 1C9AB1EC03C9
	for <patches@lists.linux.dev>; Tue, 28 Dec 2021 16:46:13 +0100 (CET)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Tue, 28 Dec 2021 16:46:20 +0100
Resent-Message-ID: <YcsxTE00kkrzD5Dx@zn.tnic>
Resent-To: patches@lists.linux.dev
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Mon, 27 Dec 2021 12:59:56 +0100
X-Sieve: CMU Sieve 2.4
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2051.outbound.protection.outlook.com [40.107.255.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id E527F1EC0136
	for <bp@alien8.de>; Mon, 27 Dec 2021 12:59:45 +0100 (CET)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UyZCZW/AU2wr5rBxF99cqaNOd+N5VzSLCTE655FyjiypNxt8c4XsVNuK9h737Y2+J3Qkild5SGNgU5A6VUZPu2WuWZV4+eh93w1fvmMSxuDgft5Ho46nUVisXDfMyZwmnJCNrhJ+X/JwMR7mlc+BfaXxw6ac53vlU8yToptxKGijo2AcHY3DPX7akWuQTv+hnfVQDJVqGtt3KQVSfW57JDg5vUHYvvnmvspUUX9SMd+OXYoMLrUudru6ApiUNhno971EzF7rqZ8SC/3T8zL2H4vjt5GMFK3UcwMP8CsYI2OWXGa2fc7Y2kAv3U36xI/vSuz6SFfkC4Z+3p9TmtVE8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XZd4QOQEHUjPNnPkVTmDkZz5TucxryGITmdHdeuNIj8=;
 b=FCZk4F54DZ4PWPfe9lr50WvC5NrOBqWXMQJBfDKSKdlbExG6fK6w+Zb5/o8+mSozTfXzcySQRJ2EoDDGyIy2wMXSFHoF/ioDzT9jXLhw/r4OAwgKV6/i/VLa2c7dwVeHyX1iCtw9TlVD2R0TfRyJ4Zg3mI2JrS9ur+KRQ1ZDXkn4wohcVVhIqFIkGKOq9q3brQvtMWwdWH0M4tOh6rsFRm0imLxhcO7ZWEds9BzG3E8K1Cn+qAIiEW1lvMXKKDvFlzICvvMKgfiaDHZmUpR0zWGFsq8xeIYQNkF7ga38c/iCVL5fnEj+8AaMfUf1jLYixqV6iiHj7NqbA8VZifpgrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oppo.com; dmarc=pass action=none header.from=oppo.com;
 dkim=pass header.d=oppo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oppo.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XZd4QOQEHUjPNnPkVTmDkZz5TucxryGITmdHdeuNIj8=;
 b=FfnqegWumGwUoCFtLmsU2NgUn0nzogpubbK0rf0NRducdMShhjYEqEjM65UXkQXvlX1nEq7p9xWXVmeNMgQtiGrYvis6a9go2MQDqNl9lJHGBBGkNZGNisw2GLS0x1dXBMQLrXxW0XIGCfahQXFK4UcCSgEi+RAAYH52YMmuvkU=
Received: from TY2PR02MB2815.apcprd02.prod.outlook.com (2603:1096:404:50::15)
 by TY2PR02MB3615.apcprd02.prod.outlook.com (2603:1096:404:af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.21; Mon, 27 Dec
 2021 11:59:37 +0000
Received: from TY2PR02MB2815.apcprd02.prod.outlook.com
 ([fe80::e5df:6f76:4d67:8c0]) by TY2PR02MB2815.apcprd02.prod.outlook.com
 ([fe80::e5df:6f76:4d67:8c0%5]) with mapi id 15.20.4823.022; Mon, 27 Dec 2021
 11:59:37 +0000
From: =?gb2312?B?1cXX09GrKFpoYW5nIFppeHVuKQ==?= <zhangzixun1@oppo.com>
To: "tony.luck@intel.com" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: A stack overflow found in flags_write()
Thread-Topic: A stack overflow found in flags_write()
Thread-Index: Adf7GBJH85T8IWM4T3uj+/KU6Rw/SQ==
Date: Mon, 27 Dec 2021 11:59:37 +0000
Message-ID:
 <TY2PR02MB2815A59F6B963F9C068CBB8A8E429@TY2PR02MB2815.apcprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0825a270-9c32-4da8-07af-08d9c9305b16
x-ms-traffictypediagnostic: TY2PR02MB3615:EE_
x-microsoft-antispam-prvs:
 <TY2PR02MB3615D29BE171D1950CA092E98E429@TY2PR02MB3615.apcprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 iqEf7GYFO6omf1ClDBdYgtS/M4XOeTeJqW80B5gz1i28IoSK5M76F2Aq0IULZzgKSaJJZitRlIRovxt83dIDB7DBnoipMIoP4/Q8PW9UNJRRPo8WA5qpUEmwYdav2NiMCwyRYp2K62E7QL//e9zMmz8iNkk9gxSzKWhg18XW+4nBUvlhaiXinCtusFyndbaTp7fG2qI1Y2gDtXa/kANMxIouQHRZOVpjvw3B4097DIS3lctTQd9IcLbs4LSfPKq0IMvewaYxvZXQPmcJ+Wfh4s3WcnutACCF8dKDxnBEW9cSlJYt+CEmA52Ed0VzkLbR/mWLZF0pyLu7KPY2fzFHBjFpwio/zzUqCcptqGCehVqTTu0RqmyorqUMFm1z3L2HNMnmf6kS5UM5eEftlHoL4sEW9FvqfNFyWbFu5c2vfbthTw3LbCQjOPSAUrdtzWwB68wWPEQpTyimP1Mq4lsnzcligFqJrhQMYkkQ5mKBzl9Znz9/aYB8X5wAl1tO7/iHwUFBYD76pecgbvmraBmHw3M1O0/q5Ht/s4v6vwkLwH4o1aNZ7LYribrIlhnnsLZ2rL0sL7qqu+twd0soL/Fxllx8AyOfse4ks92fJqeQ4qJEeTIDlXFb3AoYViiXuWE3jOVv8KMhJQNfY04dl2Ku/EleLEJWrrtOwUptepyMCNWysaEfOeXHI/mYv4u1qFLwtbn6Kj/1JZCYU1hS84RrtbDaG7/cbfnGDQh5dpeamWs=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR02MB2815.apcprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(66446008)(64756008)(76116006)(66476007)(83380400001)(4326008)(66556008)(186003)(38070700005)(33656002)(85182001)(38100700002)(66946007)(55016003)(5660300002)(71200400001)(54906003)(8936002)(122000001)(508600001)(4744005)(9686003)(86362001)(110136005)(316002)(99936003)(8676002)(2906002)(6506007)(52536014)(7696005)(11606007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?QUhwMm1vcVJmV1QxdGxWRUtSRVpWQ2FmSENvdDZ2YWE4eFlkSEtUTHRPblBn?=
 =?gb2312?B?MEhvL2VUb2ZkemNrSDFzZzE5Vk5qanpnNFRjRTU3Tk8xeEVvc3haWHhMRWx1?=
 =?gb2312?B?WjNqR1NzOHlCdXkwdXdMOXFrakpBd3U3VlBLTXlYV1VNNm13TGE3NUJqcFZQ?=
 =?gb2312?B?ZzRjeHpkS2c2V1g1VTdybUxyUnpsaEJPanljQzU5ejZvMlovNXFTanU1TVpF?=
 =?gb2312?B?d3VuVGMvOWwrVTQzZk5JQU11U1hsVno3bUVvaXRzZjIzZ3pCd2lkQVVBQnQ2?=
 =?gb2312?B?L2JQMDByUUtYUFVuSkN3d3pBenVRT0NqQkFyaTQwVytJb0lRcG1SdmFuU1FH?=
 =?gb2312?B?c0ZiQjAzTDVFZXY0RE9zTDhpbmFuMUNRbXRySjdqUlFueVZseU1Ca1U2Vy9t?=
 =?gb2312?B?bTA5UUVReU5qMSswOTBVSjNVeUMxYmRkTUhVdmRnL1dXMFZCeGROelNEU25R?=
 =?gb2312?B?enB4V2FoUCtENnRUMS9GMWpLa3lTa05YMDJ2bU1nM0hOdkh0aWk2bWZ1aGNZ?=
 =?gb2312?B?Mi9meHJMRyt5aXZxcmlUZTRlc2hxaXhSZ25ZaEU4UWRWWVN4ejlodm1TWDdN?=
 =?gb2312?B?aHZXRFJCMDVVVTBNcHlUOUxoaUxEUERmbGhRRVNMMkxmbWp3L2lxRm82ZWJk?=
 =?gb2312?B?b0wzZDBvUG92ZWVlRy9Nc1k4M0NmUEpUUnlublV2TmFyN3cxb1RxdUtIV2wr?=
 =?gb2312?B?R0c4TWh6akI3dmE4ejltVWxGNStNVnpxWTl6NmlnSktiM0dnWVNrNS81ZU15?=
 =?gb2312?B?Q1IwTERzTDRIc2VwM0hwQnRVZHIwd0tFVWVFUmlwc2hEZ2thMmNqU1VBK05y?=
 =?gb2312?B?aFhXRVZCZGhQL2xKUjFxWXlGUm54Qm1FYWV2Wm9CSHM3QjJYYzVLdllvaVdV?=
 =?gb2312?B?YXlOWmJIdXNWZ3J3TytwdXZKeHQrc0l3eVdwMFBkR1RIMHQwcTlNWVBvUUs3?=
 =?gb2312?B?U21mRno1dndwZzFaM01aVDhQZ1FvaGFSVW5LWVJEWHZUQ0xnUmFwV2tCYllH?=
 =?gb2312?B?cFRhQ3FXQlE1bGZIOUg1azhROFdIVmFNcnJreVU4aWNCejBRbjRjZHM4dTVu?=
 =?gb2312?B?WVMvSDIyUWZpdEVCV3BCb0d0a3VFU2orZnN1RWRzbXIxdlFMaDIyWVNoOWxZ?=
 =?gb2312?B?QU84YWJUcjVvczRzRWNBYXlKU3RYeEVzOGtyKzhrbkFWbGRwbDZQMjVxdVZz?=
 =?gb2312?B?ellSOThGV1VGUVhoWmErYlk3N0ttOWtnRFV4U2dIMnRaRnh2ME12NlNBTGc4?=
 =?gb2312?B?L3pLWEt0TzE3WFAxSm1hcEwwYTFzd3o3emVmY1hXQVQyeVRhWEVqZzJlcENo?=
 =?gb2312?B?dzVlTUZxT3RrT21jVlRsVWRhcndnKzhmSGZONnBWRzBJT3JndFNIQ2hZTmha?=
 =?gb2312?B?eFZYdytWelo4YlRSSVkydk9rTVBTSFZGL2FkN2MrNGFuTG9pSFR5Tjl1S3NJ?=
 =?gb2312?B?VGllMHRQWTY5NmRzV1IzMncvcnRZYW9PZTlwdy8xREdhNkh2S2JUa1FJNmVK?=
 =?gb2312?B?OFZrVkdvRVdGd1hTRGFBSThUVG9WVXYvaTdiV0p0SDdiMDFpZlJaay8xaGZZ?=
 =?gb2312?B?VFNVaGlncFI2OTQ4bGtkVnVhekdzYUdFSFJ3RENiWXVvaW42aENPMjJheXhx?=
 =?gb2312?B?UnhLcUNpTnoyRXlsRGt0RjlPV0c4OTJkYzNSRVdnVHgyQUlYOWYyYzA1MTNU?=
 =?gb2312?B?L05rVFlKdU8zdHU5Vm9jeTAvOHc4UW9HQmMrenFjT2RlcmtGYXYvbG1GSWJx?=
 =?gb2312?B?alpSMnhPZzlMT0VNaFB2QUtkcWtmbU04S2lLRzMwcFByVVAweTVnR2xFNHRY?=
 =?gb2312?B?eis5Z25wbTNxNjhKYUJEeUozZ0E2NE9mMzVKV2lpVGtqODZVKzRjOWlVbW5v?=
 =?gb2312?B?YUEzKzh2bmZ6UGVKeE5nM3J6ekJjSnpWRnZod1dSR2p5YkhpN0Y0QW1Ya2Jk?=
 =?gb2312?B?b0NxV3JCYzdyaGt1dkF4U1JPdjJBTzdhSWhJaEV5SFJBVjFISmlOcklSYmVR?=
 =?gb2312?B?LzZSbktxS2libVgrbUQ4bFc1NE9NT2lQL1dHT20vRmdrZ1l5TUlKTC9WWFFW?=
 =?gb2312?B?OUdNMldFV3JhS0VWejdjSGVKci80MGxIaHorZXpwbXNicm1hbkRrbXhHWm1W?=
 =?gb2312?B?ckdkMmJtblBsWGRHRTM1QWJIWTdlSEJnMWRjK0p4YkpVc2lvWlNWV3FuRGZM?=
 =?gb2312?B?U1E9PQ==?=
Content-Type: multipart/mixed;
	boundary="_004_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_"
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: oppo.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR02MB2815.apcprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0825a270-9c32-4da8-07af-08d9c9305b16
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Dec 2021 11:59:37.1388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f1905eb1-c353-41c5-9516-62b4a54b5ee6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R9cPAFapIOTJAlVaq6VgvlgjlGAV7aZgfwO/EDeTXMSnEzBpV+/W0WeKa4AWakFRgGdYV6kgC5KQCOGzqyeNAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR02MB3615
Authentication-Results: mail.skyhub.de;
	dkim=pass header.d=oppo.com header.s=selector1 header.b=FfnqegWu;
	dmarc=pass (policy=quarantine) header.from=oppo.com;
	spf=pass (mail.skyhub.de: domain of zhangzixun1@oppo.com designates 40.107.255.51 as permitted sender) smtp.mailfrom=zhangzixun1@oppo.com
X-Spamd-Bar: ------

--_004_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_
Content-Type: multipart/alternative;
	boundary="_000_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_"

--_000_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64

SGksDQpJIGZpbmQgYSBwcm9ibGVtIGluIGZsYWdzX3dyaXRlKCkgaW4gYXJjaC94ODYva2VybmVs
L2NwdS9tY2UvaW5qZWN0LmMuIFRoZXJlIGlzIGEgcGFyYW1ldGVyIGNudCBpbiB0aGlzIGZ1bmN0
aW9uIGFuZCBpdCB1c2VkIGluIGNvbXB1dGUgd3JpdGUgc2l6ZSBieSAiYnVmW2NudCAtIDFdID0g
MCIuIElmIGNudCA9PSAwLCBidWZbY250IC0gMV0gd2lsbCBjaGFuZ2UgYnVmWy0xXSBhbmQgb2Nj
dXIgb3ZlcmZsb3cuIFRoaXMgcHJvYmxlbSBjYW4gYmUgZml4ZWQgYnkgcGF0Y2ggSSBwcm92aWRl
ZC4NCg0KVGhhbmtzDQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KT1BQTw0KDQqx
vrXn19PTyrz+vLDG5Li9vP66rNPQT1BQT7mry761xLGjw9zQxc+io6y99s/e09rTyrz+1rjD97XE
ytW8/sjLyrnTw6OosPy6rLj2yMu8sMi61+mjqaGjvfvWucjOus7Iy9TazrS+rcrayKi1xMfpv/bP
wtLUyM66ztDOyr3KudPDoaPI57n7xPq07crVwcuxvtPKvP6jrMfrwaK8tNLUtefX09PKvP7NqNaq
t6K8/sjLsqLJvrP9sb7Tyrz+vLDG5Li9vP6how0KDQpUaGlzIGUtbWFpbCBhbmQgaXRzIGF0dGFj
aG1lbnRzIGNvbnRhaW4gY29uZmlkZW50aWFsIGluZm9ybWF0aW9uIGZyb20gT1BQTywgd2hpY2gg
aXMgaW50ZW5kZWQgb25seSBmb3IgdGhlIHBlcnNvbiBvciBlbnRpdHkgd2hvc2UgYWRkcmVzcyBp
cyBsaXN0ZWQgYWJvdmUuIEFueSB1c2Ugb2YgdGhlIGluZm9ybWF0aW9uIGNvbnRhaW5lZCBoZXJl
aW4gaW4gYW55IHdheSAoaW5jbHVkaW5nLCBidXQgbm90IGxpbWl0ZWQgdG8sIHRvdGFsIG9yIHBh
cnRpYWwgZGlzY2xvc3VyZSwgcmVwcm9kdWN0aW9uLCBvciBkaXNzZW1pbmF0aW9uKSBieSBwZXJz
b25zIG90aGVyIHRoYW4gdGhlIGludGVuZGVkIHJlY2lwaWVudChzKSBpcyBwcm9oaWJpdGVkLiBJ
ZiB5b3UgcmVjZWl2ZSB0aGlzIGUtbWFpbCBpbiBlcnJvciwgcGxlYXNlIG5vdGlmeSB0aGUgc2Vu
ZGVyIGJ5IHBob25lIG9yIGVtYWlsIGltbWVkaWF0ZWx5IGFuZCBkZWxldGUgaXQhDQo=

--_000_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_
Content-Type: text/html; charset="gb2312"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" xmlns:o=3D"urn:schemas-micr=
osoft-com:office:office" xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" xmlns=3D"http:=
//www.w3.org/TR/REC-html40">
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3Dgb2312">
<meta name=3D"Generator" content=3D"Microsoft Word 15 (filtered medium)">
<style><!--
/* Font Definitions */
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:=B5=C8=CF=DF;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@=B5=C8=CF=DF";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
/* Style Definitions */
p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:=B5=C8=CF=DF;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:=B5=C8=CF=DF;
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;
	font-family:=B5=C8=CF=DF;}
/* Page Definitions */
@page WordSection1
	{size:612.0pt 792.0pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;}
div.WordSection1
	{page:WordSection1;}
--></style><!--[if gte mso 9]><xml>
<o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
<o:shapelayout v:ext=3D"edit">
<o:idmap v:ext=3D"edit" data=3D"1" />
</o:shapelayout></xml><![endif]-->
</head>
<body lang=3D"ZH-CN" link=3D"#0563C1" vlink=3D"#954F72" style=3D"word-wrap:=
break-word;text-justify-trim:punctuation">
<div class=3D"WordSection1">
<p class=3D"MsoNormal"><span lang=3D"EN-US">Hi, <o:p></o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">I find a problem in flags_write=
() in arch/x86/kernel/cpu/mce/inject.c. There is a parameter cnt in this fu=
nction and it used in compute write size by &quot;buf[cnt - 1] =3D 0&quot;.=
 If cnt =3D=3D 0, buf[cnt - 1] will change buf[-1] and
 occur overflow. This problem can be fixed by patch I provided.<o:p></o:p><=
/span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US"><o:p>&nbsp;</o:p></span></p>
<p class=3D"MsoNormal"><span lang=3D"EN-US">Thanks<o:p></o:p></span></p>
</div>
<hr>
<div style=3D"font-size: 12px;"><strong style=3D"color: rgb(0, 107, 55); fo=
nt-family: ArialMT;">OPPO</strong></div>
<div style=3D"font-size: 12px;"><strong style=3D"color: rgb(0, 107, 55); fo=
nt-family: ArialMT; font-size: 14px;"><span style=3D"font-size: 12px;"><br>
</span></strong></div>
<div></div>
<div style=3D"color: rgb(49, 53, 59); font-family: Helvetica; font-variant-=
numeric: normal; font-variant-east-asian: normal; line-height: 22.4px; wido=
ws: 1;">
<span style=3D"color: rgb(202, 202, 200); font-family: ArialMT; font-size: =
12px;">=B1=BE=B5=E7=D7=D3=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=AC=D3=D0<s=
pan style=3D"font-stretch: normal; line-height: normal;">OPPO</span>=B9=AB=
=CB=BE=B5=C4=B1=A3=C3=DC=D0=C5=CF=A2=A3=AC=BD=F6=CF=DE=D3=DA=D3=CA=BC=FE=D6=
=B8=C3=F7=B5=C4=CA=D5=BC=FE=C8=CB=CA=B9=D3=C3=A3=A8=B0=FC=BA=AC=B8=F6=C8=CB=
=BC=B0=C8=BA=D7=E9=A3=A9=A1=A3=BD=FB=D6=B9=C8=CE=BA=CE=C8=CB=D4=DA=CE=B4=BE=
=AD=CA=DA=C8=A8=B5=C4=C7=E9=BF=F6=CF=C2=D2=D4=C8=CE=BA=CE=D0=CE=CA=BD=CA=B9=
=D3=C3=A1=A3=C8=E7=B9=FB=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=D3=CA=BC=FE=A3=AC</s=
pan><span style=3D"font-family: ArialMT; color: rgb(202, 202, 200); font-si=
ze: 12px;">=C7=EB=C1=A2=BC=B4=D2=D4=B5=E7=D7=D3=D3=CA=BC=FE=CD=A8=D6=AA=B7=
=A2=BC=FE=C8=CB=B2=A2=C9=BE=B3=FD=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=
=A1=A3</span></div>
<div style=3D"color: rgb(49, 53, 59); font-family: Helvetica; font-variant-=
numeric: normal; font-variant-east-asian: normal; line-height: 22.4px; wido=
ws: 1;">
<p style=3D"margin: 0px; font-stretch: normal; line-height: normal; min-hei=
ght: 15px;">
<span style=3D"color: rgb(202, 202, 200);"><span style=3D"font-size: 12px; =
font-family: ArialMT;">This e-mail and its attachments contain confidential=
 information from OPPO</span><span style=3D"font-size: 12px; font-family: A=
rialMT; font-stretch: normal; line-height: normal;">,</span><span style=3D"=
font-size: 12px; font-family: ArialMT;">&nbsp;which
 is intended only for the person or entity whose address is listed above. A=
ny use of the information contained herein in any way&nbsp;</span><span sty=
le=3D"font-size: 12px; font-family: ArialMT; font-stretch: normal; line-hei=
ght: normal;">(</span><span style=3D"font-size: 12px; font-family: ArialMT;=
">including</span><span style=3D"font-size: 12px; font-family: ArialMT; fon=
t-stretch: normal; line-height: normal;">,</span><span style=3D"font-size: =
12px; font-family: ArialMT;">&nbsp;but
 not limited to</span><span style=3D"font-size: 12px; font-family: ArialMT;=
 font-stretch: normal; line-height: normal;">,</span><span style=3D"font-si=
ze: 12px; font-family: ArialMT;">&nbsp;total or partial disclosure</span><s=
pan style=3D"font-size: 12px; font-family: ArialMT; font-stretch: normal; l=
ine-height: normal;">,</span><span style=3D"font-size: 12px; font-family: A=
rialMT;">&nbsp;reproduction</span><span style=3D"font-size: 12px; font-fami=
ly: ArialMT; font-stretch: normal; line-height: normal;">,</span><span styl=
e=3D"font-size: 12px; font-family: ArialMT;">&nbsp;or
 dissemination</span><span style=3D"font-size: 12px; font-family: ArialMT; =
font-stretch: normal; line-height: normal;">)</span><span style=3D"font-siz=
e: 12px; font-family: ArialMT;">&nbsp;by persons other than the intended re=
cipient</span><span style=3D"font-size: 12px; font-family: ArialMT; font-st=
retch: normal; line-height: normal;">(</span><span style=3D"font-size: 12px=
; font-family: ArialMT;">s</span><span style=3D"font-size: 12px; font-famil=
y: ArialMT; font-stretch: normal; line-height: normal;">)</span><span style=
=3D"font-size: 12px; font-family: ArialMT;">&nbsp;is
 prohibited. If you receive this e-mail in error</span><span style=3D"font-=
size: 12px; font-family: ArialMT; font-stretch: normal; line-height: normal=
;">,</span><span style=3D"font-size: 12px; font-family: ArialMT;">&nbsp;ple=
ase notify the sender by phone or email immediately
 and delete it!</span></span></p>
</div>
<div></div>
</body>
</html>

--_000_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_--

--_004_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_
Content-Type: application/octet-stream;
	name="0001-Fix-flags_write-overflow.-If-cnt-0-buf-cnt-1-will-ch.patch"
Content-Description:
 0001-Fix-flags_write-overflow.-If-cnt-0-buf-cnt-1-will-ch.patch
Content-Disposition: attachment;
	filename="0001-Fix-flags_write-overflow.-If-cnt-0-buf-cnt-1-will-ch.patch";
	size=833; creation-date="Mon, 27 Dec 2021 11:57:25 GMT";
	modification-date="Mon, 27 Dec 2021 11:39:26 GMT"
Content-Transfer-Encoding: base64

RnJvbSBhODkyYmYyYzAyNTM1NDcxZTA3OTY4NTI1MDM0OWU3YzU4ZDU0YTcwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBzdGFycnkgPHpoYW5nMTMzMDEwQGljbG91ZC5jb20+CkRhdGU6
IE1vbiwgMjcgRGVjIDIwMjEgMTk6MzQ6MTggKzA4MDAKU3ViamVjdDogW1BBVENIXSBGaXggZmxh
Z3Nfd3JpdGUoKSBvdmVyZmxvdy4gSWYgY250ID09IDAsIGJ1ZltjbnQgLSAxXSB3aWxsCiBjaGFu
Z2UgYnVmWy0xXSBhbmQgb2NjdXIgcHJvYmxlbS4KCi0tLQogYXJjaC94ODYva2VybmVsL2NwdS9t
Y2UvaW5qZWN0LmMgfCAyICstCiAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVs
ZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9pbmplY3QuYyBi
L2FyY2gveDg2L2tlcm5lbC9jcHUvbWNlL2luamVjdC5jCmluZGV4IDBiZmMxNDA0MWJiYi4uMDdk
ZTMwYjhhMTI3IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9pbmplY3QuYwor
KysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L21jZS9pbmplY3QuYwpAQCAtMzUwLDcgKzM1MCw3IEBA
IHN0YXRpYyBzc2l6ZV90IGZsYWdzX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxwLCBjb25zdCBjaGFy
IF9fdXNlciAqdWJ1ZiwKIAljaGFyIGJ1ZltNQVhfRkxBR19PUFRfU0laRV0sICpfX2J1ZjsKIAlp
bnQgZXJyOwoKLQlpZiAoY250ID4gTUFYX0ZMQUdfT1BUX1NJWkUpCisJaWYgKGNudCA+IE1BWF9G
TEFHX09QVF9TSVpFIHx8ICFjbnQpCiAJCXJldHVybiAtRUlOVkFMOwoKIAlpZiAoY29weV9mcm9t
X3VzZXIoJmJ1ZiwgdWJ1ZiwgY250KSkKLS0KMi4zMy4wCgo=

--_004_TY2PR02MB2815A59F6B963F9C068CBB8A8E429TY2PR02MB2815apcp_--
