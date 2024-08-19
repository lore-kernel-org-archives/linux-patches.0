Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010000.outbound.protection.outlook.com [52.101.228.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A76726AD3
	for <patches@lists.linux.dev>; Mon, 19 Aug 2024 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.228.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724080693; cv=fail; b=d/wu+2tHVotVP5Zc5bcU3vLmKlLau+JTdKl1zygdn/tVUq5Jwr/PTUHJTz9h/F3zU+I3rKDlyvM4JrG8Zwl54F0dgmbHK3YtCxk9TW+pmwdKrkf+eu69sdUqT01aaPNJnkKYflbB65psEHbzzR2AfEhijpqOajU7iiqPxjlYlLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724080693; c=relaxed/simple;
	bh=2Oy7USXRjt1gFKM96NnTUKNVOwXUwKxW8H4o5zunLIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AaqeS8h+KPP/222xBW0JNAC9tFLTwiOja1unhVKY2s5PgbbGD0w6AqdW0lLPwUWgwouBcw6wTma0U/E6KlGQieV4lKjmgzlPM9yW1EZNF0KAkAEWut9KMZQKuol9COD/s6lavmUdwG2wK/msGdsXWf27blvjuK52mtixQnoQ0Gs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=jrPy881n; arc=fail smtp.client-ip=52.101.228.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="jrPy881n"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yOVDDjZkfQT9qF6zQ2U2vJUq8kI5XCwv/8sY2rm53SNweoUGl99QboNaLQeHEdYZoTOsiN0YD5MZ5Pvfmpx2l5eHLHfTZi3zf4r6/r8zvXvaAoMT1mmZdkf9agOTPuKA8oIFDuKIm5oFs8N6L66cSAXiQ4oyyDn/gKuK3qi2HQJVrVExoeoQdcxYGgSmuy2NMsejB9ppZVbVuHp+EDYgYDBO+sYU3YS+90ynkvbYAzFJCzfLgLwP4L9SKlMx+T0V2boWoS5OVfnHWJ7j/eL2lWMM/YzG0zWyTZ915v5pwo7LAtBX4DnmrGoqh24ZUyhslZHnmIlFMIFPNBCc4XVRRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KOUb/QyY3QKBs5tKBYkNLKBhctDLVDeGoGO5sxiNm1E=;
 b=I/3p20tiP6wsnECk74RHofMkef0tVrW5qV1X1685hld9UMGA6Oy6V2dFZWrLbzj9myz9p9vrkerC7M54mE6+7iHrEWedddQBDKbhjYqe8ZsBq2H2ETgd3h3VHe94ATGIfwJiK3PkXfbsxBAsF2ldEm9ydsarzqgAAY7TKhh2aszFJ8r2VsLQkfiRFsJyhTp/IsNmhjk3Ku5eL8GziwQk4U9jhKulNYKNeGN3AHSeEyF0QA9548L+y0aF1ZB5XzadJtJTYvn/xb1VK07RN6WaHT9KyiZo2SGYOjCsx79+nKcH5BJO8ZeI1mpL70Sn/dlxXCYuoQw361e3Vg8zbrItog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KOUb/QyY3QKBs5tKBYkNLKBhctDLVDeGoGO5sxiNm1E=;
 b=jrPy881nIixufMbQOWkCZzipO6wfNdfH8PV8YH6iyDVJB5GUiyogJJ8R4CeRFs1LRhExxGdLKvSyUp9OIoHGK1Vsm3vMEaPTTNVWiQZgsqtBwXL00rbUKAPp/kRrhmGmRelycwaotB6fW5JNl9U4zDQkkm0weQ6ibBY+aFtMyzc=
Received: from TYYPR01MB12402.jpnprd01.prod.outlook.com (2603:1096:405:f7::12)
 by TYWPR01MB10631.jpnprd01.prod.outlook.com (2603:1096:400:2a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Mon, 19 Aug
 2024 15:18:06 +0000
Received: from TYYPR01MB12402.jpnprd01.prod.outlook.com
 ([fe80::64e8:dbea:c288:5e87]) by TYYPR01MB12402.jpnprd01.prod.outlook.com
 ([fe80::64e8:dbea:c288:5e87%3]) with mapi id 15.20.7875.019; Mon, 19 Aug 2024
 15:18:05 +0000
From: Chris Paterson <Chris.Paterson2@renesas.com>
To: Pavel Machek <pavel@denx.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux@roeck-us.net"
	<linux@roeck-us.net>, "shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, "jonathanh@nvidia.com"
	<jonathanh@nvidia.com>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>, "rwarsow@gmx.de"
	<rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
	"allen.lkml@gmail.com" <allen.lkml@gmail.com>, "broonie@kernel.org"
	<broonie@kernel.org>
Subject: RE: [PATCH 6.10 00/25] 6.10.6-rc3 review
Thread-Topic: [PATCH 6.10 00/25] 6.10.6-rc3 review
Thread-Index: AQHa8Uwq4UX2gcIIcE6Fe8Gz65f67bIuTk0AgABbtxA=
Date: Mon, 19 Aug 2024 15:18:05 +0000
Message-ID:
 <TYYPR01MB12402A34A443D1F3A6556D902B78C2@TYYPR01MB12402.jpnprd01.prod.outlook.com>
References: <20240817085406.129098889@linuxfoundation.org>
 <ZsMNYtjBBUE5Ehqy@duo.ucw.cz>
In-Reply-To: <ZsMNYtjBBUE5Ehqy@duo.ucw.cz>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYYPR01MB12402:EE_|TYWPR01MB10631:EE_
x-ms-office365-filtering-correlation-id: 4de40c7d-8f64-4c1a-ad5f-08dcc0621fac
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?eGZ7Q3eJQllY7Ota7aKTDF06pdR1vXljLWn8FRt9UvjjpOzdBUh608lk?=
 =?Windows-1252?Q?76/VvQKxNiZrsNwhixYVlHou4bsidhv9xL5GKpgAEohRTO2mAHC+RLj4?=
 =?Windows-1252?Q?blsULvokJzMdkCBixwiarNXZ9ME0h0LJOl3S3vIZbSex2g7EHYsCLNGf?=
 =?Windows-1252?Q?fXyeJe5ZiPTx0TeGx+/jXGFuGckTdCYGhX8DxY9J/K4EbxuOoQHvILrg?=
 =?Windows-1252?Q?w9VQMb/q3KPv9GZc8Bum7yNqN39fasfPQCEZ2acHwNHuWVGFVZwLryJK?=
 =?Windows-1252?Q?rKKEksesi/AegyhNflJFoKgwl5wtkWUSV+dEJozECplk1UBxx02gRn8l?=
 =?Windows-1252?Q?pmu5GpJlTgy0HCV0wL7qN2aFuqA1BhsB7R4r0NcuYQPtHad277zWWrYn?=
 =?Windows-1252?Q?8Oe8gKNV956+4aESTaomce7jbrmGg6wfeAgKp6WExWXipB5McU+0QBpc?=
 =?Windows-1252?Q?voqq+xmClCNCmva3uVtKRey4UZ4wM3rDp7bXKXnFkq4zJ4l7TlRSvwPk?=
 =?Windows-1252?Q?1hGIfLGtNlWPDb6cfTFnoRK5zAtbXcNeydcVCqano1620Qxkvim83ZiT?=
 =?Windows-1252?Q?s0TSSrgUONBMmNnyoZFldUFM/QlsIMpVGe+KTXbYDhg0xeuDYkFGmqD0?=
 =?Windows-1252?Q?Jh20FEn5zytNbLakDfDmIYxYv2JAFQCrlUa+0XWObnmG1IX84kLIyKRh?=
 =?Windows-1252?Q?jbWbVETASWFyxPyX00kkHsaK4A+0Yrb06AaM/7Ua5DEKoUH7QtkkgUHq?=
 =?Windows-1252?Q?rI0aimjo1XWHBqZIKNJSuU7SSA4NIWBsFIF0QXzs4ERxRmXK/p6wHohL?=
 =?Windows-1252?Q?0QSMT3Op5M1kNeLN41Kct3qCheKfeAPxMqwGienIOIe9ATZ95xiqNuqo?=
 =?Windows-1252?Q?1TaIh7C0e4JYeP5/STOsQbIQ/dHLtpAOa+t3Cxx3eis68+JRSOP5TzMi?=
 =?Windows-1252?Q?RxIhAtFmcKTjO2eToR0c1R7ncMYD8VYfbAMHWEYKgKs4dYtCBnIgD7/7?=
 =?Windows-1252?Q?gHNhjcan1iJMqy0dv9gGr7lkEddRqS0ZyT6wnXcukIhguOAnwgtRJpQN?=
 =?Windows-1252?Q?DyROwkS0kedAdQPLqkHVl2iXzjsJ4JGKAUX0NTeP3vOLKk3KO/m2qAVR?=
 =?Windows-1252?Q?g96YLSRe6aVqk3dqZqGt6xiMWDjc0TIoj1eWfEsy21+Xa80gt176uuB0?=
 =?Windows-1252?Q?JAi7Z7NebTjKumlEAaRAjobXt1McmlkqujmR6+Ta9H5K+RDyMbfQY34d?=
 =?Windows-1252?Q?yai0CCtPXYjiwvBhQkzPiu8C+5p+jtayquCtWDAXMa9whxQ6AMd3vBZx?=
 =?Windows-1252?Q?CRI0VUJ9AHhZlsQkEMiXjKTtI9JSuR+L0Y9v6fX+02bS631n2dKxswcI?=
 =?Windows-1252?Q?67F4YsTaWneXeub/b8g8KCyd0bY6dxlpMuHBEMQxy/u9N314jIn5LENm?=
 =?Windows-1252?Q?4JQoNnxaiZKAJPHRJ4wrGgyUcHe2mJrwvJ8UE1B5xvY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB12402.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?CQw9ZviUCyl1NMZeFpQfufB2Aj5RLtnpV8YjUEkyrO7/82OoeImIa7s0?=
 =?Windows-1252?Q?7k4J3ytbDQjqQJGVQIy2Y4B98vkTCu4Rn3pd55k20npX05BJTZlOZYuz?=
 =?Windows-1252?Q?nHuDhwBwj9jid0DIlQM/vHSRkBtGSwOheNEzCl/IElPF77QR/EbJtQGP?=
 =?Windows-1252?Q?a9OdXH43Z0l0BmKtPQ/TYXVU4wEQJpZjRkLc+sYw/flp+4EMi32JHKI+?=
 =?Windows-1252?Q?W5LfSC3d6j177OKWzSDPIvicHYNKS74qA73np9eLKTv8roV+C8b6VEbD?=
 =?Windows-1252?Q?nuoCfObQCo/tE8lgJOr7dopCRLe9d4WWJaNym5nGa6jrvv1suOjOsq6n?=
 =?Windows-1252?Q?A1bf+XUIlKDLj4rxNPu4gGm7CjO8sUee6COxv2E4H7de1b8svq5DUlzQ?=
 =?Windows-1252?Q?Srs71LbJuHQvRsBVRO8c06ODD4HTO1qZbMVHJN1n6N2TGqA7jlYK6N+M?=
 =?Windows-1252?Q?6qhWADBlvfzKUB/Oek8DwTJSl41Nksiqycv4sqXVyjAAQX/G+FXdyq1q?=
 =?Windows-1252?Q?rfFATjx3Zl/nPoT9UUo4+G5CeXq8vGWC3n6QQW/kYJteyO/jGcaz1uhx?=
 =?Windows-1252?Q?MYW+AW6w/FelnvLzhdvgas3oX5LtcQ+LDeRtoGYGpVdEU15mxgpwOvdn?=
 =?Windows-1252?Q?f73n+/wrg82sVloNYsFDh9SJI7wD9Rss6d2JNzdUslQo3J2dHxnZR+Jf?=
 =?Windows-1252?Q?I2NqZcFn/Ve6ad7ChG79Yi2uF0UnE25KG3Xbqk2FP6Wxl3c5mLlp8vZy?=
 =?Windows-1252?Q?1TYPNxRS3kyElfdOPo5Qtaqa6xmqtdPdONubSwiGN0Y2UXWFlRrXfaa0?=
 =?Windows-1252?Q?67rS+DsievKB92C0JoRkYSld+xPKAZuxWlaxxAj8deKBses8jjN/gljS?=
 =?Windows-1252?Q?kuZU0bWd8Itioi6jvh7eSGUo9KX6Glp15PwAqr1QP7Qud6Z7QY2sszVU?=
 =?Windows-1252?Q?RqN3ZEpQEE1RwJcvTl/zZsSKuN43M2QNGa0qhur9OKTNQyccQoIYjyNU?=
 =?Windows-1252?Q?epOyas2AVH5zoOo9aUiNXe6EOIR9oPb29Pq25D50jOF75lHQQgROWXWe?=
 =?Windows-1252?Q?LXPYibCTTZEioejyowrv6IZE/8YtlbDSmAsBWltxqOb2AUiTX1UQ8ANd?=
 =?Windows-1252?Q?x1p17NkxzaEUChzvMAc7OlIV4k7koEpD/qODafPTRbejbmf6uE7QtpiV?=
 =?Windows-1252?Q?fZ10IngwxSgAD8eba0bAEyDMH0cVK/+GFXLj94rBsbY3+JQk1pLc5m+6?=
 =?Windows-1252?Q?qewT91H2nkiJ3GU89Yc41uTJZtOBfbrta/AX7cznSqZ02NKsCSs/Eb2K?=
 =?Windows-1252?Q?EW8HcMKsZN5VLt5kZH28zR6AnGtObRl2G+iMxCw0PfB7+ONo2GF+KKcB?=
 =?Windows-1252?Q?CoR3f/svRo2n8AUL4yQqsTk5RXwzo9K0Ff9ZT8ZDusy+5v9T88WRHyi9?=
 =?Windows-1252?Q?CaJ4MceLBnIoYQsDhefG5DjF7m+CiMoCTpvUyGCrr9u37DSfUvjP5d6i?=
 =?Windows-1252?Q?L9yEDUDUYqTpbJjjKCYx0lM0kacl6lRx5sKOo660R3WybXa7MjlOf9o7?=
 =?Windows-1252?Q?p4m395Z3oKPwqo2Zd/SczK1h2wQgw5KXP8mKbExeqZ6WN1EEtmgNwXRY?=
 =?Windows-1252?Q?EwBubmZ1mP6Lj8QGwtSrg79GSBRYXJhuPr9oIh2CS5aiY+ri6+DBvqle?=
 =?Windows-1252?Q?JtBtTxHvogMo9xP9NomZNcfp7oAhJjPKE2d/9AeRPtGjUmxt6SxxNw?=
 =?Windows-1252?Q?=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB12402.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4de40c7d-8f64-4c1a-ad5f-08dcc0621fac
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2024 15:18:05.0158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DYerDboVfSxIlGt+UG3jsJWwt77+j2sPJLarVbG+xFleh7x3cBC5CAKkfbNK5PqklcoLJJU11FHc/78Z+cj2U3TbYRWpmfXsfKoUP+knYXE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB10631

Hello Pavel,

> From: Pavel Machek <pavel@denx.de>
> Sent: Monday, August 19, 2024 10:16 AM
>=20
> Hi!
>=20
> > This is the start of the stable review cycle for the 6.10.6 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> This one fails our testing.
>=20
> https://lava.ciplatform.org/scheduler/job/1181715
>=20
> [    0.493440] ThumbEE CPU extension supported.
> [    0.493646] Registering SWP/SWPB emulation handler
> [    0.515073] clk: Disabling unused clocks
> login-action timed out after 119 seconds
> end: 2.2.1 login-action (duration 00:01:59) [common]
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
> /jobs/7610484202
>=20
> Failure does not go away with retries.
>=20
> Now... I believe I seen similar failures before, but those did go away
> with retries. I guess I'll need help of our Q/A team here.

All the failed retired jobs from this pipeline ran on the same qemu LAVA ma=
chine.
I've rerun the same test jobs on different qemu machines and they have boot=
ed okay, e.g.
https://lava.ciplatform.org/scheduler/device_type/qemu?dt_dt_dt_search=3D&d=
t_dt_dt_length=3D100&dt_dt_length=3D100&dt_dt_search=3D6.10&dt_length=3D100=
&dt_search=3D6.10.6#dt_

So we could blame it on the qemu-cip-siemens-muc machine, however, it was q=
uite happily booting 6.10.6-rc1 a few days ago:
https://lava.ciplatform.org/scheduler/job/1180857
6.10.6-rc2 was also okay:
https://lava.ciplatform.org/scheduler/job/1181017


So it's an intermittent issue, however I can't say it's with the kernel or =
the qemu machine, maybe not so helpful, sorry.

Kind regards, Chris


>=20
> Best regards,
> 								Pavel
> --
> DENX Software Engineering GmbH,        Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
