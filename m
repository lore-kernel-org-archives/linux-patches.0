Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazon11010060.outbound.protection.outlook.com [52.101.229.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1263411670
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.229.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782920511; cv=fail; b=f+mirJ+gRPerC59/flTV87PexP1F9OCTaIqaXN+k5uVW83lnbt53Pm8y0kyspNs4HMR4eLgGYc1dyiu469yIBRPnktRF5/QGjuiJ/dvqBDq7CfRL6+0ysLItg8/DJ7668fFx3e7hjFqRs3Cl+QGMquI7kwM9Ak2avl2k0k7NJAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782920511; c=relaxed/simple;
	bh=XlONfHf0nXrZ5EvsgZRgyfd/XnPDWeariGCpXkbocB4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BngWnKZRGldZc6VRYzqpSJF75QW07u4JdUUYFdQfN0jvp8BMpUB18Lc/d18GVUg+Bu3HbwxX0EfZW2vF/bV7z6XIhbC3nO7yQhB4VL594Mogg3VtZyDVwpmIcOce9udX0YRaxrLckyqsrTJDgYuewy92K8NuQ5MxVf8uJylD6I4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=Lm0HVP3t; arc=fail smtp.client-ip=52.101.229.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="Lm0HVP3t"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oxicwP3FqDBE+/WIOGgk043rdw5PpG2KPwzaigdutH3Mx381nRAA9FLnn2FG8fDbN92vSemQlrcrmhvNdpu4GS/VmrXV08evFklpuSCj6yE531gBcjjdgbBJNAFTM2p1rqn5Z9wGSGvSjrYbe74qkM1nHIPu4YzkpWUIaZyYO+5PizYa2Y8ZB8dAv1TFw6D+sw9SOUe1OSW9QIC8ZkAlq7FW+xnwzT53m24388j7Aj8p+k3NUfXxGo9qqG8+9N7l+wljJljZJpinhMXT5nEH+dwAzfmzww29H/xEXAgy9PVU6Wa4Gj7JSUbF16DFjpayJboMCgNEDc9tdKL6bimjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWvygYj1Rhwa6XDivp0D/M+AEPv8bI6C4RJUNG8UIX0=;
 b=YIO4HVw0CBLXT+5YIRxS5Wo+u6A8LMnx2d52NL92pBJnWJmI17Kgl0YKNnZWshqYTtFnZLkBD8PCzMo4CAIMqe5GocvE+IpL2ibIAPPm+3XjFusMbZefchgmTiA+4KR9sSfmTtg0PD8GuoPV45k64WYw/Qir4AivLXL6o7YdhX1QMJqWF7hFL9lkokR9CvxcoaXzW8ds92ZnaUcIrRtBwc1q/CQ+TcglOjMbqY3p/9zLIph8ik2WEUfxkn9aOAPB4oUbaHxshurSMMQUAiAsq6XrpDh6he1svNWrVJG97KFmqtcLiq51LnryvIS+c5viasqf1EZ8CsS4u+sPt2LnJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gWvygYj1Rhwa6XDivp0D/M+AEPv8bI6C4RJUNG8UIX0=;
 b=Lm0HVP3tN2Q+ybm0B53Gl9mD+IjiyJCsYdeIcHUN/Lq4FfKqjYKIRZQqR3WIFj2IBtKK0v/Lr2utDw9UVTaqZHUO5KtZXzxjkGR7bGwhFsqLlZxd9AoqUl2gIwlrzWLQS6JOiSC42rMNbcpqkr28NqvXEHQYQemJqADylHE2LpQ=
Received: from OSZPR01MB8123.jpnprd01.prod.outlook.com (2603:1096:604:165::7)
 by TYCPR01MB6769.jpnprd01.prod.outlook.com (2603:1096:400:b0::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.10; Wed, 1 Jul
 2026 15:41:45 +0000
Received: from OSZPR01MB8123.jpnprd01.prod.outlook.com
 ([fe80::f2ff:7635:979f:c31a]) by OSZPR01MB8123.jpnprd01.prod.outlook.com
 ([fe80::f2ff:7635:979f:c31a%3]) with mapi id 15.21.0181.008; Wed, 1 Jul 2026
 15:41:45 +0000
From: Chris Paterson <Chris.Paterson2@renesas.com>
To: Pavel Machek <pavel@nabladev.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "linux@roeck-us.net" <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>, "patches@kernelci.org"
	<patches@kernelci.org>, "lkft-triage@lists.linaro.org"
	<lkft-triage@lists.linaro.org>, "jonathanh@nvidia.com"
	<jonathanh@nvidia.com>, "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>, "rwarsow@gmx.de"
	<rwarsow@gmx.de>, "conor@kernel.org" <conor@kernel.org>,
	"hargar@microsoft.com" <hargar@microsoft.com>, "broonie@kernel.org"
	<broonie@kernel.org>, "achill@achill.org" <achill@achill.org>,
	"sr@sladewatkins.com" <sr@sladewatkins.com>
Subject: RE: [PATCH 7.0 00/49] 7.0.14-rc1 review
Thread-Topic: [PATCH 7.0 00/49] 7.0.14-rc1 review
Thread-Index: AQHdBKPjSaObmJ+GvkG4AIwATb2ZubZQs62AgAAFbACACB2PIA==
Date: Wed, 1 Jul 2026 15:41:45 +0000
Message-ID:
 <OSZPR01MB8123B6D80AFC66536D35EE35B7F62@OSZPR01MB8123.jpnprd01.prod.outlook.com>
References: <20260625125637.527552689@linuxfoundation.org>
 <aj5ho8stx819px0w@duo.ucw.cz> <aj5mMP6X3NUx5XZM@duo.ucw.cz>
In-Reply-To: <aj5mMP6X3NUx5XZM@duo.ucw.cz>
Accept-Language: en-US, en-GB
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: OSZPR01MB8123:EE_|TYCPR01MB6769:EE_
x-ms-office365-filtering-correlation-id: 3d057051-6a7d-4210-0af7-08ded7874191
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|7416014|56012099006|11063799006|4143699003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info:
 BN3EJo+IBr8KxN4lT6IT1RjpiSd1sxb/VM1QChzPWUExsgsonyhNhOziXhu5KqwmrBs5dxsRtMqCvVNUMmsHehDy9nHuSGtngUqcg4zEBS/ebK8SiL/IGaCCidusDdhIzSDaXElLZC7VCV1AKjeaUvQuh2hwowiJJkeHG0zwrFAmwlqf14f49VEodBGpOxs3NWb+/XTNbFHWH0UM4A864z28S37YFY1VJzLmqG9Z9lVOcUGLsW53kQ4B5Z+QgU07JJnG8YWJ2ZGJ8Kw0UBSDpHdB0LXh68Ge9wQ514r7COT6k4pTFapXnvXwTg9s9CAr4Gj6aBttkEyZ1BZdnzUjlT3Ponf/2ro6bzEHvsYDjzmy57wsZEQCnP/X/KUskm9fhW2NBYR/eJCN4wfS+SieKlMcFFEg3y0zCeDC/ubmIKLbbA19iVKMz7wUnrmXr7aceEo4gkHxngJCCtV3WCXd+zXbWGC6/nxJiAqbybNSY8nE67YF8E1+Bz9NzNhKuSOtYyMAwKpacDyy7pfj6+B10vnxWLRxw27Bei1iJ3xzTiJUaNcMnTKw4b+QHCRYaHh0szY0ScIfr3/LSvzRJiX+QC4476yJk/e83qYp/1IdyYioGkDInnM2iyC7zMNmSOKS/9dumnWXVoOJpe8/3q0d0dQSfntS/GfSPPtWENx8pPnvGfgBR2elML2IOovdzwxZ0clQcT42bcz6ZlLnRUIht0VaBvdmBELoI7H4sahc3DE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSZPR01MB8123.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(7416014)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?zCrQGHq69xNlGPGz0WbU4KaGxrmyyb2yeqsvg+Pb9J9LxVU5YHQIW2xc?=
 =?Windows-1252?Q?/9CRATQq8caJvsQKS27ZHrV+DuMRx6LeSrry64efi97Qo2dQ4sNvk58v?=
 =?Windows-1252?Q?VK5j64mAecDwWCtbv93lXF05BOxaokDfZzdKPEx+moLgpLsEgtEkF3E1?=
 =?Windows-1252?Q?2ZdavOh30awpUGjqMQHgAFasyg0N4j9h2NxMFb+B4Da3qjJMmrK9HMsW?=
 =?Windows-1252?Q?7M5BShpnzXAtlat/4UFxY45eVjl0Q7BzgE5Nh2bzy1MNxMAK2I/HJ+FS?=
 =?Windows-1252?Q?WjQLRTMJfpNNzXZh0W8liEA7Oj3E4t7TcbsmLfosPkUoaqe9Fpc7G36Z?=
 =?Windows-1252?Q?bB3ikaZQYE7eZTIMs7EvC8FEkp5XAiDFuABc4XG2G6sBWasNPcDsAbSj?=
 =?Windows-1252?Q?Hce4Awzp2yCKHu8vYVLbllwKH4opNKSveTSJJyDV6YeTh/KUMsyZOikJ?=
 =?Windows-1252?Q?DZydorf8DYIk6bg9rg9spnTn0YRJIbUtbYbcJNUcOOGmwiJNt6iSQ4Ps?=
 =?Windows-1252?Q?HckIqVGocK1ZZuSno1nGSh5SjAQIbIUWm0jQGhsLMve+C1qXKuoUrj4C?=
 =?Windows-1252?Q?TAPiigaiJP4yY/LdTglpetuwe6W+eveHt2wSTsd9oB9uWOLPbIxvxKs2?=
 =?Windows-1252?Q?NL5bB4+jNdwfnWjh9WgXnz7AWZvqrFVe/Rp4p1EHY4q11nYYypJ3Wmst?=
 =?Windows-1252?Q?uw7MzBHT8CEZAlxLESB41S2r7s5gb8su3EiTaBRMy1cGcnixFylM3EVG?=
 =?Windows-1252?Q?wEXlkzKNd4b8q8J/DLY/bQSw1Pio28AZSJuN/s2dK4NCjkSKKddmOCWM?=
 =?Windows-1252?Q?tLvELljufYYD6eHcQtz2YPF3hG+bYLMhBiOV4bKci9xdmK2dh/mADHP4?=
 =?Windows-1252?Q?Ew6MHJHjbCvEDhb43M3lQ7LavMpQ7iO91MXLslXkfEHTr8q4CGEcvIm/?=
 =?Windows-1252?Q?SF1S2OZe14S13y7aP694JfG0YQoAiyY0ZPy4RCK3flKOkJbgy2hSiP7O?=
 =?Windows-1252?Q?Kt1MkzoLyFmJm1kNk498CmH8pFfjJj0GeoRSBiftJEoPRroIGCZLLONz?=
 =?Windows-1252?Q?3p3j/vryG789VfW3kxymH5YXOOM/8df9k7ARzKF2uvPbRQQkxwMmGTkq?=
 =?Windows-1252?Q?NtWKr+RfM9YjhdI7h1+vGolIZNNn31GCLnoLHUe27sTItV0jPTEennKS?=
 =?Windows-1252?Q?pE1j83LHXHoHURf3RlHokPyB2CV5svkcZE2TKZYs9oIYprtxgoJk9lTx?=
 =?Windows-1252?Q?5uLUWDBpq+lI+S2w039GrzAbNSj9ndwf7RPhJ6q2YMaPjRjHPCgiJhP0?=
 =?Windows-1252?Q?XNR0q6vDoxlhM67Ve7NcdPyUEM87Y+lIxGgo0IOOprC2H1WhIGk0kV9c?=
 =?Windows-1252?Q?lOtQ0YwbEGfI4icSU2pAKZj6BE3/jxTVPoj04CwSh0nYHRzttyvDNCTy?=
 =?Windows-1252?Q?5gj3qfaHHS+yFgdYvSFaBFs8Mk6YbUH1lSrFCm2BHX3VBJgS4lF1Qca+?=
 =?Windows-1252?Q?t8UfOjMrpkUi97CAo5aAs0z/MFrqzdQ7uxTb0AcnA46NkG0+DbxnKG/a?=
 =?Windows-1252?Q?sLD4vZuJeDt0fV8ONhsxwjHTug8kYlbtfHW87+tgy4QgoWHQndWJJjzl?=
 =?Windows-1252?Q?VZ1ykLj/caAVq+p8Cl/AFQX8iOlrpmUNtCQ3f21PJf95kNEWSariOq5A?=
 =?Windows-1252?Q?HqXoSbQ6+syf6hIoc4RnvV3U2VFMnYPrqUQ2Nw+2wTorrwCApkk3S2KK?=
 =?Windows-1252?Q?CCEhxwXJjWhQbiE5K01q8lHJJ6aHK5IOptNf+qKZP30eM/cCRWtUnOUS?=
 =?Windows-1252?Q?/rDJ9yN93mevoMpHuFrVcm8wLHAr4I8dRnFXupQImp1ZbCm3eA06iQaN?=
 =?Windows-1252?Q?S5Vnmkb7cTFVIA=3D=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: OSZPR01MB8123.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d057051-6a7d-4210-0af7-08ded7874191
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2026 15:41:45.3659
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r8Az6F0I2BjWsKUp5zaXX8PlUt1LgK8JBMmr4mbdHpVBS0ECQWJxwp+hpbMVsnLtunXp6EmaEv3yT+t8BhZt5D3+yrN/m4pGICP0Ak8HQSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCPR01MB6769

> From: Pavel Machek <pavel@nabladev.com>
> Sent: 26 June 2026 12:45
>=20
> On Fri 2026-06-26 13:25:23, Pavel Machek wrote:
> > Hi!
> >
> > > This is the start of the stable review cycle for the 7.0.14 release.
> > > There are 49 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied,
> please
> > > let me know.
> >
> > CIP testing did not find any problems here:
> >
> > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-
> /tree/linux-7.0.y
>=20
> Disregard this, too. For some reason, this release is not yet tested
> on gitlab. I'm putting Chris on cc, perhaps he has an idea what is
> wrong there.

Fixed now.
Issue caused by an expired token.

Kind regards, Chris
