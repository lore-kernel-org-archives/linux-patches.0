Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010034.outbound.protection.outlook.com [52.101.229.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279501E4929
	for <patches@lists.linux.dev>; Fri, 18 Oct 2024 09:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729244643; cv=fail; b=R5Rt7YCUa87bzr89fsN+aj2u4m78THufUbtemjjwiXOPLDuRm7yialDbM+wLgPv11G0N2XHhPf/M8vxDuHnUTsYEr7wTxBYGb44/J11+dLe2zVVQBge5WDnISfOB6EHfZqb2uw16oSyb2yMbTSlbPooP7TXI4wgl+hKGw2B7qPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729244643; c=relaxed/simple;
	bh=cTbfEl21RWc2WyMVdUL46NXxAY6M9rc3EudAivQNqms=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g/ESdgfMJJRDaxZ9xcvLaZoFszum2nt6//cOyzLipUXKzxggeQqJ2GFYTfzniNuT4+YjAoRqzW3g35uXAnBuk61lEmTRTVnPt1cB+f39YagrpDiD2GW8RnNbAT4glSbWHfAPtYEBEn5ntl5/AP8qJM8kcZZihysUem6ZDBvmUQI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=FlLqaNCl; arc=fail smtp.client-ip=52.101.229.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="FlLqaNCl"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DGbSt/HESZcW+5iOiz54/6tu3j9+i9iG1FIgEXXlVHg9ZKYk6DWgwFet/v0D1w/pnuZ+DPw7OQpbdH7sQR4VNs7a5h32/f2gA5ctby7AW29jTjPmWxeGSvdOynV0QVKezekOsArrd+We1ehas7avPuiPu+FsrgE0MPvDL8G2tCA8AEa51WEol135n4aYVMm0+CjHwzSH6YaSfhgB6nde8lpQne341nWzHI8Lgn7iYxfmBnRtcvyTQBCkHlvLfxHrojwGkYz7NSNjvmIWVpwCuAk7wiEU/k9cmaIN7F3omZxTh7S1ergY/VP0t98Ucqc96vcoiK0Dv2chySeIELn/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1DuCwrUls+Y4fM2yhdvuqJ4lNbl/ZcyIBd4U4Q+0TJY=;
 b=xfvYd0nDYum2UCfC06aH0N3dE7MC5LnA7pDgX35sCx3CSoEiMf3uGth3L5s66RDbxYyS7Emon/M9036aHwpvGHrN+Je7jqlpmM0TNwN0xwetUntLSMIeGTQBZSkGR4j24YjaDCWYiTGLf0cmCShXaMfYNaO1opaJOZ/Y9G4v80lTlwVeZAVK7xOwq1DHzKR0pf3q2pDVG18odhYVL0ynjZk3DsNutTToQrQ4MbCDM97FvsDYZtRBuuhULo8J/DXaf08V4DbUksce2IkyUSUXZow2VKtg3SHCvHAT5sne6FNxu5JNpKowiYsTZ2wo4HXs845SHKmFUzJ52L1aPAg25Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1DuCwrUls+Y4fM2yhdvuqJ4lNbl/ZcyIBd4U4Q+0TJY=;
 b=FlLqaNClJcPsx3Qzj3CnPRvAyYtMPgRZ30gLP2ZZP1rTktybLJA9oX4ZfbtHFJRdxpoczopYzzd1zwHurKQvEAYNBtUVYQ++pA/NmgxHv8UKiaXzesbt/ARkjdYYMZhur3gy3PDMfpvbKS1BjpoqMfCDi4XB0kME4gXFV7fae/Y=
Received: from OSOPR01MB12395.jpnprd01.prod.outlook.com
 (2603:1096:604:2d8::14) by TYWPR01MB9453.jpnprd01.prod.outlook.com
 (2603:1096:400:1a2::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.23; Fri, 18 Oct
 2024 09:43:57 +0000
Received: from OSOPR01MB12395.jpnprd01.prod.outlook.com
 ([fe80::b9e:fc48:b9af:c1a7]) by OSOPR01MB12395.jpnprd01.prod.outlook.com
 ([fe80::b9e:fc48:b9af:c1a7%6]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 09:43:57 +0000
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
Subject: RE: [PATCH 6.6 000/211] 6.6.57-rc2 review
Thread-Topic: [PATCH 6.6 000/211] 6.6.57-rc2 review
Thread-Index: AQHbHvUGJU6ts1fzyEWz8le2pEo6jLKJHSIAgAMoMzA=
Date: Fri, 18 Oct 2024 09:43:57 +0000
Message-ID:
 <OSOPR01MB123952B556B05E821B4D19E49B7402@OSOPR01MB12395.jpnprd01.prod.outlook.com>
References: <20241015112327.341300635@linuxfoundation.org>
 <Zw+G2Exqt3JTfT/b@duo.ucw.cz>
In-Reply-To: <Zw+G2Exqt3JTfT/b@duo.ucw.cz>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSOPR01MB12395:EE_|TYWPR01MB9453:EE_
x-ms-office365-filtering-correlation-id: 559105e8-4754-4fff-baca-08dcef596347
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?Windows-1252?Q?tiELoYs6eCHr6WxY5Oz4WMmTElDULGABfXuBMH+d2S8JrEs7wrX2iWeB?=
 =?Windows-1252?Q?CpOVh8pvAHnMq8lo0s7qAJjrQrLm/DWIf9rAUUOZaIz4d5rls837SS18?=
 =?Windows-1252?Q?5574UOIVLXJNVmXZfw+68lRh477j+VXpVFEV2M5CgX2j6dl3Y5VEFGsn?=
 =?Windows-1252?Q?3w2wd3vv2RMRpw00BlXOQPZScMOtQgw7t7ErLRAN6YTmWKM4o1nNZjf8?=
 =?Windows-1252?Q?Kq9kRFZCLwmpAeUwx3ZzQBvuBpUw6rvtbiDxHWomYrGvQG/eAaFRs82L?=
 =?Windows-1252?Q?buEv5TquTlCoNlx92B66C3yaZvdSRVEPRy00TjiKkVMEysECEKdkBQk5?=
 =?Windows-1252?Q?un/D5RNUVsWARi0MfjwDARsWuS5ElUULrIujSfUDI3C8yiss4zZF6fl8?=
 =?Windows-1252?Q?Fo1VgeLA74G9zK+y4KlUNLHWgTx2wUXHeZvTWYaZd2AqM/14gyMXAk8Z?=
 =?Windows-1252?Q?AQGMXr1nrOG2jldjHK5zxlfhmvJ+WxdJnSqb+QQEzAfJ+4VpwnNtgLhe?=
 =?Windows-1252?Q?DxRCE5XEiGzP4gax71pfzNxfZQx3gr4dES0T97Mys5YWAzsbM3nt2em2?=
 =?Windows-1252?Q?0PUd925S2JFIOJO7yEvRCt1zPiB7VIPEWhkCStY9n4LmZn/zyMf61ZmC?=
 =?Windows-1252?Q?vuwYAk7ycuA/FBf8WdUB9udNSUSySxwfgMuqRGsw9xzAnqw+8QreyLwN?=
 =?Windows-1252?Q?+DQmKtITFIVJsLOu4rK9sJcFwpEpYDaF1l2OnWEJ1vS1lT0P1igob0wn?=
 =?Windows-1252?Q?8pMiwdAV0cn6SZwPu2ppx5WjjT7FlDx+e5OdEnsqZ39Ng7LRR+QuRhMo?=
 =?Windows-1252?Q?+iLylNVKdhCWCB/KUSU8ITV+KIfVVsKw0urfX9g09vDPylzi4U7F1vSb?=
 =?Windows-1252?Q?Y7subbRejYImHcrUHI2KXqwMI03EdTRCJhVQvTuFgvWYuK4qHCaaj2Pj?=
 =?Windows-1252?Q?XKSa9l9gyowjpyqXiIZDD3FFdt0biETrL1YiZjsYy0aJ+ohHC1jgpu+b?=
 =?Windows-1252?Q?Wvr8OchhtUzXvFlkR97RysTPSiANF3hz6j5yjrhaKY8fmdwJ0ssOc+wH?=
 =?Windows-1252?Q?2T0QPuhuv8cephX4WMXWCWdfvK6fXsWNwl3ev/WArnsF1IOvwH+BaQBR?=
 =?Windows-1252?Q?vd2N1BAWm5tpuQO4IpYc22b2MlORzDU0ZPU1/kVhUh0Tp95sVaBsZWKr?=
 =?Windows-1252?Q?3JeCNjZsjQkPnbL6CCkF65Tfwgc60+FV/dz8Nar9+NCnRWTpyYUOp/CP?=
 =?Windows-1252?Q?FOmCw+nZKGpFmMOko27HXwyCXPqqgTWBHO6HkWKBAsfjcmzom9EJk0eI?=
 =?Windows-1252?Q?t4YDiwAGoG22VHzX1nSEzB2zoXWtFg2gM7+6J1eorc9lkXLBohexzC93?=
 =?Windows-1252?Q?5p/Nv2YS0JDdvULyoD1PhuKof9gYCgEYgh/Vie0SWTEXBG0LCLloHuK0?=
 =?Windows-1252?Q?1JRw0ytzFM04psri+7ZGqdQHk3/OxLLbujy6+USDiB2bkHL4lWJEp/55?=
 =?Windows-1252?Q?DkJyIMBr?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSOPR01MB12395.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?KcBzFnHBoFHeZTXgRwSneakhPp+hepAs1aIYaqAI0M0Hti9dv8599blv?=
 =?Windows-1252?Q?5+/SEjxt8KoKbaz/q0fzFfMzpY3fNc4wbTua3QfVWKikBj9DElkh2JqX?=
 =?Windows-1252?Q?ry9HspxJrxfz9o4hnHQ3jlbr1MoS6WEHxjChc0O43yN1uZoQx1fiYZfg?=
 =?Windows-1252?Q?GTeiadUgIbwY4Efp17LZU5tyLAC9FWbz4JpMc8dTcJ+c6Jy9ZS0UKc8A?=
 =?Windows-1252?Q?iNvD2dlfCYooeolru67XcQEGLfpb+GqgjFTXXWyMxG4tp5JC6wTkK+Fy?=
 =?Windows-1252?Q?H3Ku3yK3V6b4M4IPZVBGPZOcNCvYHfd1kHefmVhkNmb6TtJ7+pZTk5K9?=
 =?Windows-1252?Q?qRGTyyABx9dDHhp3xFZ5ctukB5hTMG+BVynxFzNfmKZiYOw5RHms8NRy?=
 =?Windows-1252?Q?GJJ5uYCag2XuNqKZObIIRbjS8FOaU3GRHa/A/AHiYNUUOaxldVY5tZHA?=
 =?Windows-1252?Q?1CrcBwbRYZd2N/U5MSiaXqEzcSaIE8ErYSlERwPSc7gMSIcfXFDgrgAu?=
 =?Windows-1252?Q?85rZFXiro3W6/YCjAC+Y6Nxy2k1F3pmRzH5QISMW0RxHbqgQtUt4HD6S?=
 =?Windows-1252?Q?yR2oaZDwtpT/3ZEk3tFFibDUnJZYRzS6n5qHA4j7lbE7NdxoD+elrT4V?=
 =?Windows-1252?Q?tqCLBI+zNpvwQIfDC1qphBUTBRI1pis9HVBnnLEo7RiTZh8Zbajmuy0k?=
 =?Windows-1252?Q?apNCWtbWgaMb1R+AZrA5hrt0Q7qS/9olpY1DtNZvpr88K/qM5YkOhiE0?=
 =?Windows-1252?Q?M4EyZEX77zG6zxFNp7PCUlHF8SZkJdvVIIli4jXZknYG2tnpz2fRc57z?=
 =?Windows-1252?Q?Uh6rZy+I/k3p+uSSPqycZ0zCfcu0/4+wNhac+sS3bdXF0VbQ9cuBRxje?=
 =?Windows-1252?Q?qZZrkzqUZuM1Ij3gNRT3fq/vTNHndQhztImd4FXNRXQYRTaGKBR7bSCF?=
 =?Windows-1252?Q?zBS2IwTTSSEtwSGi/EkmBTPGViwS6iVvfK1c5JHdkKa+r0LduICoJs5c?=
 =?Windows-1252?Q?GyfEx36YEOUXa9OLlsDE0hLCpXbErNMkdaViC4JgCQ6UM9+CumrDkjVT?=
 =?Windows-1252?Q?N9rOxCMEYroQjBqhDufYtezLVoBTWGONcsw+pyAEbtyxk7d3tC1qbzrX?=
 =?Windows-1252?Q?6pEpzSLYC29OqsgY927Xk+rgdHhfK1VTv4iZdgUqW8jcpyFYzT35gjAQ?=
 =?Windows-1252?Q?9H6YDGw5eaAZzxiC3K8aRayBjQJJag7Oq9zI+GGhGFtaiWyHFd3usA8T?=
 =?Windows-1252?Q?heXuoXyywv9j1XkuZ4FIL9w2pj4Q/REI/08qps3voFfpOwRF417kF+sz?=
 =?Windows-1252?Q?CHL63pNxlUDG3ztyxBqb/XBepA4sTuftHMZ3YrSgJiU5KheWKj9MLJpX?=
 =?Windows-1252?Q?fWjL/DgBeHpFtnDCMlZ6zwMfjjJhJRMwrsQZU3GYo0G36sKmtzzl0pb/?=
 =?Windows-1252?Q?tMTAHiQbZCwUl8x69GFrQmCWcCkKAM3IxGmnPrFoREUUd8+UDnizlqn+?=
 =?Windows-1252?Q?S1rbs6RT+4yoVCjL28jBKD1NnzO0F9Wt9HkvC5Orttw8gpbNnxxc/GHB?=
 =?Windows-1252?Q?/PNPUQiWlI+/JpAV7paWo6OepW0mxLCRaBKnNXOWOgoI5tUHD+DFi0sX?=
 =?Windows-1252?Q?vPUqy05Am4q9oi+vEgt57AHPOj5ZEgPpo7DC1TB/yALieM0isfvCNHeu?=
 =?Windows-1252?Q?zAm9ZplMrthoTW7l0Z65pKL8p4aD0rvolkIfwNDtH/SoVQD84a3QfQ?=
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
X-MS-Exchange-CrossTenant-AuthSource: OSOPR01MB12395.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559105e8-4754-4fff-baca-08dcef596347
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2024 09:43:57.6164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yWAO/bWdQ9mB9ehTI35bRmKUzUTf3iuLe4zXd/8oKcVxtMpK91j9ltdwIoIdJ1mef2wuPYnm45kflYIXcM7SpIS3vMcOUGLelljZJKa1cPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYWPR01MB9453

Hi Pavel,

> From: Pavel Machek <pavel@denx.de>
> Sent: 16 October 2024 10:27
>=20
> Hi!
>=20
> > This is the start of the stable review cycle for the 6.6.57 release.
> > There are 211 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
>=20
> There's regression inherited from mainline according to our testing.
>=20
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
> /pipelines/1497863007

This turned out to be an issue our end.
It's working now:
https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/812224=
6812

Sorry for the noise.

Kind regards, Chris

>=20
> 6.11 is affected too, lets discuss it there.
>=20
> Best regards,
> 								Pavel
> --
> DENX Software Engineering GmbH,        Managing Director: Erika Unter
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
