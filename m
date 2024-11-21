Received: from SJ2PR03CU002.outbound.protection.outlook.com (mail-westusazon11023115.outbound.protection.outlook.com [52.101.44.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E621AB6C0
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.44.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732207864; cv=fail; b=dL3xOQXDZHtA36Fo0QF9Nhil/kyXl8LYVI7sYwWwIcDDqjE8KA/+JnZ0SF7mMJEjF+tdVHY4MUJIGSXEJLSqv0Zl3QCvryJv1/KKwbmCZoZQ6LVTWepvqswYILTQdgvb3hZU4x4NeyKAgAI/iwrASDM9uexoYl1WDKJQRredcZY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732207864; c=relaxed/simple;
	bh=ZuwdpiBGbeOBCfY8bqkEWLp0GTrpRortJ4SHKKMBJNQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hpQ6erZzgNe8beJMM+Rq8VhRGqAi0nzA+K6VEauilbyDHIQeTL98ALV+9U2Gx6VXlbHd8z3YV7U0IaM/7v8+qvsn6eP5mK4gxsIzqhPvh/FktV/20dqW6ZnPlgDZ24AV62jWVy4ZVBCDD1VT4h/OOiYRBbOInr/trH7I6iFIBaM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com; spf=pass smtp.mailfrom=microsoft.com; dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b=LJfoH+iI; arc=fail smtp.client-ip=52.101.44.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="LJfoH+iI"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mXSxyc1DYcRCB7JQ6qs2pk2ykMHtozfY7tjmMCMdtTP13OrTcm3MZbTBhSvkhwIOa6lwS4RBOmKx8rWqt+kVeKrVtliWlTzR4SfX1ZGVevRw252tCWkLI83M54P+Se7SjbE7UuhYD3jUFS8OXtLAlL1oKWO1wO7+NJLBiVAmqsUh2bXMyxoBCj8vyfgNJygD2UF2+A2za316VlbFV7NOpJxs23mzTKCdO4X8hshX+akuqnSFPm+vgdBaUPRU1baT1qiDh437ww8jmWFx3NhktxYq79HUvSXIryBQQYHK9Z/Hm/KQeHmK06num+Nh+t+X08X0o9wmYdep0eys0W5yaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuwdpiBGbeOBCfY8bqkEWLp0GTrpRortJ4SHKKMBJNQ=;
 b=tf39vWXMtpKVWOJZwkdWGUfd2X68ZhS6yRGg39p+deKHWBvCzOgTIycEo0iZ3XQJ+jglDDDc2wuwWy/2E0lbmmQckNRlMoATvCaWOmnIlieBzLH6MmzrUPiHFexBh5HkkXgFGF5frywfz8QsVVHUTv+H9SizD3hgOQLLUJCJ1dY4u8pLzpZOe2xlZv1eDKstcZcY4RFm2bNPMLljtdsnm1wP2JKUcomU5VoLvsTMZkX1b3/DlpgYpQKjjih4K4b7RfAttwztqQV+7hpR/gf8mpvVD0mHyD8c4ze5St/f2aeQouSYYWgB2J+m9/ecRllRb9SZ8E3FRarB01W1ExvqZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuwdpiBGbeOBCfY8bqkEWLp0GTrpRortJ4SHKKMBJNQ=;
 b=LJfoH+iIWahMxajsdTzfYKolvQ6+nKW8up6jURo7ol3wRQb5KbGpplFvZCrHeM0Z6guu00JwZowWC1h2vpdw00utr311ZP/Cwny92qm7BgC2hprPbq9VncwkqQwX8RQ1xP6u/pl1DkT430kDo0mWeW5MXNrtFnxcwhdYu5bHK+s=
Received: from IA3PR21MB4269.namprd21.prod.outlook.com (2603:10b6:208:51f::13)
 by BL4PR21MB4664.namprd21.prod.outlook.com (2603:10b6:208:4e6::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.16; Thu, 21 Nov
 2024 16:50:59 +0000
Received: from IA3PR21MB4269.namprd21.prod.outlook.com
 ([fe80::2ad3:451a:7a41:c069]) by IA3PR21MB4269.namprd21.prod.outlook.com
 ([fe80::2ad3:451a:7a41:c069%5]) with mapi id 15.20.8182.014; Thu, 21 Nov 2024
 16:50:59 +0000
From: Hardik Garg <Hardik.Garg@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux@roeck-us.net"
	<linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, "pavel@denx.de" <pavel@denx.de>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "sudipm.mukherjee@gmail.com"
	<sudipm.mukherjee@gmail.com>, "srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
	"broonie@kernel.org" <broonie@kernel.org>
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Thread-Topic: [PATCH 6.1 00/73] 6.1.119-rc1 review
Thread-Index: AQHbPDWKasQvKh1uGkyknrzjO+sBLw==
Date: Thu, 21 Nov 2024 16:50:59 +0000
Message-ID:
 <IA3PR21MB426998846BC2A2CEE3445DA9E1222@IA3PR21MB4269.namprd21.prod.outlook.com>
References: <20241120125809.623237564@linuxfoundation.org>
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2024-11-21T16:50:58.772Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR21MB4269:EE_|BL4PR21MB4664:EE_
x-ms-office365-filtering-correlation-id: aa438fc7-7dcc-49ae-def5-08dd0a4cad21
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?hPeC/ohyrFifqjwkARcF+o8LQEqS7UgMPm6WSD5cf2A8WCuySFAwI+SbiW?=
 =?iso-8859-1?Q?E2UuMXgCf/mQTIKmOZ3YL3r34v+AYA58+l9uMbo7bf5diEiXM/r+Kkab3+?=
 =?iso-8859-1?Q?j/eCbUbpvK26FXFcbDeVrkW8PqK+DmtAu7PVlYNw+CAK8ImLJglF8ZW2AT?=
 =?iso-8859-1?Q?6nTisGgSs6tAiG2ysxLnwf5afp9WxP8f9omVpwaLfKH0SX/G2GhjpwqyI4?=
 =?iso-8859-1?Q?hVcr1uuJqM4jQjxi0rruROog7mc+K0dWJM1yDUuwfJ4ZhOS4j1MydaHMFM?=
 =?iso-8859-1?Q?ibw8UGzsF05HRMDldMqaEosoiD8oAG4y9y3t8tVNjuYkjjq+FSbn6uGWTv?=
 =?iso-8859-1?Q?w6tG5eziy9blTvUg6iPMjHlQjVnKzHAGLyvc5kBNGBd9EHcGVhijFIKo8f?=
 =?iso-8859-1?Q?wnGfb5xyJpjJJ2wbFbQwOKnmmNWNUWWpG9UmniUQu3G6ThuZ2E+18gt13I?=
 =?iso-8859-1?Q?Swqj81vylAveetVDV4YQGy/K3aSykZrT4CJPaNYEn+huQEea4nft+Wp78d?=
 =?iso-8859-1?Q?WEGuY9xHdx4c/+ODIXFlkVuX/Qi2dwZgcIyqjj8IsBkuT6FyZV1rS7ebRY?=
 =?iso-8859-1?Q?2H89I7eDBIgn4tmf1K+SPoQbqz6+uyILPkByICgJahFwdoXGOpn8XxJjCG?=
 =?iso-8859-1?Q?Pa7n+tHm/VLhMlGORr3kthRxYd8Ro3PNBqFsgNJyVXx+GyPKBaToA18Z2j?=
 =?iso-8859-1?Q?hcRKCCystNozVuc2VeZELgF56ohOYlsNybSWr/LRHJr83Ne/m4rbcQd+MC?=
 =?iso-8859-1?Q?S+rH8T4Wou4zOkMAFDfKXBrtJwf0gSM1ksbK94RcPaDyXr7lvGNxPktOmP?=
 =?iso-8859-1?Q?IlQ3srXP+dPMHlHHo3frLhPCvjUyz5nJP62QRkkO1Mgs6dGb1TN6A1o6mi?=
 =?iso-8859-1?Q?8Ihiyla6/hq25UfAZ5LtN8ZGcZZJpyXI0Lq19JV+GG9La0aHcOadFXDmJJ?=
 =?iso-8859-1?Q?VHYgEVrssWE2B6lJndDFOP+lscMora0FgzXS5MaC033aMtL5KOe/E/7yFv?=
 =?iso-8859-1?Q?xoDNDAOI0YerQ9+o4iGLkAvQpgQ1Kno6XhqIZSG3nYkZzT8QG6AAZ/NjJg?=
 =?iso-8859-1?Q?kKUc3aQUAqT2F6M0ggWBVNAdzLx75rNze2gmIJuHBbl1Y3BXHKuwfWv1ra?=
 =?iso-8859-1?Q?CLoZit/4k8/CMNqCCxvUrawh5FNZrL+aoz+iL61QCp2zxaGfmK9HDQk7rv?=
 =?iso-8859-1?Q?xJMfBc0KPMNClt6tL5v8axYtIqM8pwi+8BJUPHf5OXeK8RoSUiLETV3a7f?=
 =?iso-8859-1?Q?uJweDuFL9DELWn1G3AXda+Dn7cA4IxCEF5NxuHtlUq2B6NdKG30rvjMT7G?=
 =?iso-8859-1?Q?SJ0PYpU4u0yqq0aG0Q5nWb9jbivHUnjVhtqOsQ6VPjOlQ1/L77v8odw49Y?=
 =?iso-8859-1?Q?BbpQoTq6EKTBoABGXlAQVO12nfM/B51LqVixQkIAEphF1JSFR2az4=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR21MB4269.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?5bNjHQXccsGoKpr9y9xtgFJmStEXrJoT1yN/BOg2UNiFC2pXMjPcp/6Ydw?=
 =?iso-8859-1?Q?AT174yC+Z3u00BkzZOGmFpXO44YnlCSXyt7lKtmiFbVUgZs0ilXerqVnws?=
 =?iso-8859-1?Q?gu/dQKNy8Ru090ELKmY4PFcnZvsdzzhAfW5Rg1qr6mDehDbKSOK4YSitPr?=
 =?iso-8859-1?Q?athMpjJ4WPKsGg1gS8bxlxsJ8l0wtg1u2Olnj7JNxsIKC/NGXZc+h1n4/7?=
 =?iso-8859-1?Q?1W3WrkOPaoqzIaHlunFIaILC9z0SBnFoOiibDaPh47TD7Um5hgSBOxygLc?=
 =?iso-8859-1?Q?gcRG8ezOg8f93XqXQdC89H+Qnv8COD2bG9rXPECHb95r3kuMJWizMyeMY3?=
 =?iso-8859-1?Q?Bkjk/dsptMc96Ro6Jvu0aruts6m6oDXylgLomwkP2w3cn2BhCVgi1Dajyd?=
 =?iso-8859-1?Q?oawOrJrSRIZRQvipkN7/zQPGuO/hWwHMkPwSmngJ+aBtnE91TGc9mRGHWY?=
 =?iso-8859-1?Q?YQ1NlaJ0yRCPFZOxpJ327U56QRoyT2H7YdMG3wptsOhaXBf2AFfh7N3tqh?=
 =?iso-8859-1?Q?hQnqBclUls/xOTf8dk2OGeEn6uo66L0DCk4DlgCLCFpy/8w4PTDgMPCSfA?=
 =?iso-8859-1?Q?P+JS8g+j2dRUyVE7i6sE27EKD1nmAEFeWAio1spAFabZjJxjQ9Y/Vx0cQ/?=
 =?iso-8859-1?Q?QMnK94Pt/V2oMgwTtjaWM+ePlwXa1D2ns1Vdf8B2kx74VEGYTzqWZqIske?=
 =?iso-8859-1?Q?IGDC1XBFZWGwHhAGeLTVxZzB7rKKJ29C4aY9JJDDz9CR6ZB+z6s28ETCpR?=
 =?iso-8859-1?Q?7J81O+Dk0HHe3cTCaV6towEoO4QPVCh2tywb5H0r35xdcvRJF3YD4bKNkj?=
 =?iso-8859-1?Q?+bM5D7m7+x2nfz490nENwNfjXTU5A4O/6K+I2m7CDHwQzPdfxirW16Njsu?=
 =?iso-8859-1?Q?iGFgm7FkfrCQhcbK0Z3h1i9BcvtXcrvBrJkHwk+oNP7Vaz21PrFaXVcWOJ?=
 =?iso-8859-1?Q?SGp7bL42yXL8r9GMeJifKRNBravYX4TNRR1TsFTsJB6rJuGGtMKul0TouX?=
 =?iso-8859-1?Q?b0bPCVc4BZ6C3i6KRcoDjAHTpiX53i6qlchv/sJlw3hPgHj3paNJYA4OCE?=
 =?iso-8859-1?Q?xpl189kdo47L/WibjUhZkqkraBowPcammu2AQrTCGrKXcS1ee9gYd+yBt4?=
 =?iso-8859-1?Q?MWPEEqMD4sD6Av+XU5IBXtjokGYcymPccdFq7tBS5Fo/Hq1IT4e2uwyj45?=
 =?iso-8859-1?Q?B7rRn729xTi8hddFfP1TlbtzN5X/VgCjJszsri0tWnNFIybXEUIIpTPND/?=
 =?iso-8859-1?Q?ua0XL5JKy/2bEkPnV8RF/67+zzKu9FcSvgxrpee3T4tKbLML3jjFMNJHBC?=
 =?iso-8859-1?Q?BIOUWvoup5WMi0z3F88RMK5q9u4S/LvjJISJR03HRA/OEwNhAKneNSieFH?=
 =?iso-8859-1?Q?F/i3iYrZHZtzjkMmo2p2dDTuiZIY3GAUORM9muxlf31J5iDrlYbCA6PzcL?=
 =?iso-8859-1?Q?Eo+6jYZBFDvg9Prv2pWKoQtS/kbYRpWNhOuYqvLy0yD8b2n2zbIJveulRA?=
 =?iso-8859-1?Q?X8uLgrlas9PFVpRLsTDz4vU0C4d6a2F97ZEU/diOBhXXDWC/mMPgy0H/z9?=
 =?iso-8859-1?Q?Y+xOXpAqU6aZtb/xBe5/vBSAOsqzZwoNmIvboKVlmTdL6LZUpDoxW5IMGT?=
 =?iso-8859-1?Q?muCM706ZOXJjF7/khHFCAKKqVjKXoBjh62?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR21MB4269.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa438fc7-7dcc-49ae-def5-08dd0a4cad21
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2024 16:50:59.4658
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8V9ru+rp6OI204h9bDkyQ+58+H/S5yxQdXwEpHyKC1NHuAuqj9GuSW3KAYBovAKbeQkNREcGIaKgFumMfLeNMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL4PR21MB4664

The kernel, modules, BPF tool, and kselftest tool for 6.1.119-rc1 builds su=
ccessfully on both amd64 and arm64 Azure Linux VMs.=0A=
=0A=
Tested-by: Hardik Garg hargar@linux.microsoft.com=0A=
=0A=
=0A=
=0A=
Thanks,=0A=
Hardik=
