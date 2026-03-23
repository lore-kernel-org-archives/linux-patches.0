Received: from OS0P286CU011.outbound.protection.outlook.com (mail-japanwestazon11010032.outbound.protection.outlook.com [52.101.228.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF48C1A6815
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.228.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275221; cv=fail; b=L09pXpOPVQvdlcAILnkUzzQv2Zsyl6W84KfR+/WDAmDuEM0kRI/OGDF0gfPDk6Co4+XGNEi0pMY8g9R/ptf8q0mAoHzkMtd2z/eDayHHmoDNuSwmKsSQyu4DW/oquG1PDoIwwoH2n146frFagTNDF+ypA/S0UCf/PPCPp17bLpI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275221; c=relaxed/simple;
	bh=hgQMvIlqffU02/0EDtXcrvEPOYOWXzb+8NyDbe6xpNo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZeBphF4MrFFl7mtx7shgRDFrJFplDLHz6sws2+OiqKe8QTXNtMoBpdIVRRVmDGJFxeGJA/79jogqLH9HvxDsgRxF3YHVNEJxIrLjaxJxvtUNR0eUoBES/aqrGxu5QkMUVmNSlBv5v6eGX7nfwYRrA910uxXs8easAikztir8aEk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com; spf=pass smtp.mailfrom=renesas.com; dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b=kPYQXIYH; arc=fail smtp.client-ip=52.101.228.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=renesas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=renesas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=renesas.com header.i=@renesas.com header.b="kPYQXIYH"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IFRR2yyhe2DzVPG+oeN9i+hbzsGMWqGMbmB+4G63RDONott/NfdcWAaT9EiWeZUWkvW4iGIlnxPWMUPTyOgZXJFzrJBfUyAxFYkx9KSg2RkEtF1Lp6W108FM+dz5lUTQGyQeuB0ufmWBkVQ7OTg6BuCGuaTJECy4R7Q+FPkSshaCWu1VbtkoqWQcmHc1nz3LQldqgCwU4ySULSGElvDUdZ0QpcR15Np057gocn13VdStCJuptg2SdQm152qnZh30hvTGgNuvYebVO70/uHCUl6O91S/tWyiOt17FlmrS1BL73hqL6kpuxe/2GgXtxKMz06FGkLwl0e65QkwLt5vVUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jleKLoTWxLIMsXO/Ftc3Bts4Y7oOa36RoWeL9obfgQ=;
 b=Ub+g3urJpVIgCEUpxgIrHfTI660KtjfQSEfYbQpz4seLONN7KACrLHcZqwWCA00V9hxv4Jyec2BLRpCmoE/49oDilRJIkvBWRBSTymTdRavegQJHGknITU3U6S0s+Ze07oMlDxKwdyCq6YNHEEixJ4DRUUWks6pcbMDlEd8dHe9t3BxQDLpggo18QdJ8WipaC9n5RBw1WoDyEuhwUnXzyTSnocTkQoze35VoN4OHAPbV5+2HJRAGgR8TGmp0B3Lpk499fEk07qb1JLMJvW4chUjfCngeZcFwNUrtYW8kPPYMsodK+jciqfgW1Pt65VMufmZUmTKwMAJkRenr64kiQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jleKLoTWxLIMsXO/Ftc3Bts4Y7oOa36RoWeL9obfgQ=;
 b=kPYQXIYHATXUBEWy2TkhcOuk3rKr7g2/yFF0XZ0NJfvuyF9PvWyA9Xz4q+0S5a1uRQtz7F5uNLHnE/gxM2gIGh5BZ7+zF+m8bblHmVqOxPD2KS4LPkqbT0xeeXmS7Hdb9vt7XNOgVzCrR6Lak7wbn+uWpWqvFPzFvkBBeK4Ody4=
Received: from TY7P301MB1984.JPNP301.PROD.OUTLOOK.COM (2603:1096:405:38d::6)
 by TYYP301MB1389.JPNP301.PROD.OUTLOOK.COM (2603:1096:405:30a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.31; Mon, 23 Mar
 2026 14:13:35 +0000
Received: from TY7P301MB1984.JPNP301.PROD.OUTLOOK.COM
 ([fe80::5b4b:dd0c:b302:7911]) by TY7P301MB1984.JPNP301.PROD.OUTLOOK.COM
 ([fe80::5b4b:dd0c:b302:7911%5]) with mapi id 15.20.9723.030; Mon, 23 Mar 2026
 14:13:32 +0000
From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Geert Uytterhoeven
	<geert+renesas@glider.be>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.18 114/212] arm64: dts: renesas: r9a09g057: Add RTC node
Thread-Topic: [PATCH 6.18 114/212] arm64: dts: renesas: r9a09g057: Add RTC
 node
Thread-Index: AQHcus5MumOzht+1YEWtvXgjHd8uQ7W8KCJw
Date: Mon, 23 Mar 2026 14:13:32 +0000
Message-ID:
 <TY7P301MB1984B713A54BEE0BF4F248A5D34BA@TY7P301MB1984.JPNP301.PROD.OUTLOOK.COM>
References: <20260323134503.770111826@linuxfoundation.org>
 <20260323134507.379115286@linuxfoundation.org>
In-Reply-To: <20260323134507.379115286@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY7P301MB1984:EE_|TYYP301MB1389:EE_
x-ms-office365-filtering-correlation-id: 3b9cd0cf-cac8-4638-8aef-08de88e65d8f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003|38070700021;
x-microsoft-antispam-message-info:
 RSH/uLR7EDIkk/jwZox6E2LaJJhpNbiqBOTV51gJzQNOTQC3CFFD06hSigbfFZ3GjsBObtgMWaZ9MRuWZrVHDb4mORzC9C9uRCj7VXDtBtTFck1uj1XDR1hpuqIr4lMmDea4rGEvQqkrtLjLpOwXQ1oejDgz20Gin+LgoWP6qNzJ36x5UYa89B5asNeurRxJ6EHdUfIkZr9Qd0MsgkLB2rHyySjaeGv9QFyLEUFeLbS+PxfWaYwdjd17GfRyc6vNbmQSJxU0qEUSK1wHETuM+D8LbNgOdBLMJ91X+JjNcq+F9vQmGl9SSSYzNiiiesnzuRwCbBohkKWlIem8vsD+TZci4ZQBkPTLmJHh3sO/QiRpCH+JIAUIc/AVYOAVQvJyBjkkSgVQpD+4clc0lJk6qHFnoufwaEZ4G70AYYAw8gMbgSN6Y5toPVoLFunTU4IonvTXce2bkM8P9H8t30HOna0q9zEtndUX8uxQIb9ueV87nF1OsefXjG4odxWZ1b6ucvTTgfSiFZ/c74Vo8LU3I8AzxRMWkbG7p1wv1FAPw/4AObhg+fV6VTGfe3s6lXMpUu9WOt/mXyb6T6JwdNNH/KHyz8XZREjfAImA8RDZBbMlytgdXrgGZIBWB4sZaHwyS25MbQ2h24XFEi7mwuD5Feard77DOVzKzDCkK4cmiIEE2epnFVNCU3t6WF9+VCKPsLHmJ3h50GahFJyMWpmMXosG6D5NRPWLMWuBahBVxdk2R8caNO3sCY4hXOrxLIiK
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY7P301MB1984.JPNP301.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?GcOcVLT/98nQef4yfSnw9Wu5+Uy2zb4WrFasN4cfOERCitlE35Aoc0HS+8dp?=
 =?us-ascii?Q?GXTyChRqLy66xMAuYpf5PKIT4qiEU2CuKvsWyO8YM0pfdBTnB/07zB4lRbNV?=
 =?us-ascii?Q?zX9bIlspJlasTH+/9jZYRm/omotp/5sQjjVIsfzLAjXJB7up93LZ7Ga58PpM?=
 =?us-ascii?Q?nwGgBvypqjnn5Ybvq3NS9FtAF0nAIR3BOFlnPbF9Q0lDAfwXTCgrtdohhr8m?=
 =?us-ascii?Q?p5fnPYPz5+wJXlMzFbZdH7MlfCaegS1UigUSnWQbh0F/it+9vBQKPRfTVij+?=
 =?us-ascii?Q?qX0/fUlU1H2Egs8NCvq4OGgyfYlI7/3IeNazW57aFtq20HwTqE1xFMQNR80Y?=
 =?us-ascii?Q?PVi4gaQJWXQRb0y/iXZGu2hAR4GLGTBfwy0CzZNBKTHASvzo3K4lwJiBNnlA?=
 =?us-ascii?Q?C+PQHkouxgYweDzVGhQGZUKzxW+05zAATwipHiJTchNWyYBtB8LoTlGquHkK?=
 =?us-ascii?Q?cPyXPgJSpsMe4omYexKae4bUBpKhROjGmmr8N3F3dq5FSyM45dfLxnOSH2iu?=
 =?us-ascii?Q?FfXRrzci/6H9iocBgUpgcgKs/tRaocoY7lGWX7AzT+iiXlafax9jWsMQ/2Rz?=
 =?us-ascii?Q?5J94nDHks7H94vRDAZH0CGHS+6PcmYH/+hAq13k64/kAqiSioZ/3fs4rvgS5?=
 =?us-ascii?Q?yvXg0WBpjVu0M2odWiUceY5AqOeZI8FReouaqQ/GCE2BS5OrYosfzQ7mIVVw?=
 =?us-ascii?Q?nPXUzUgytk5AfyIEDhCXNujl9nxW63zfLoWIDNDA5O28f8U0PxmibgmAsrWS?=
 =?us-ascii?Q?57x+dSXbAX6QaMdbe8xRWsbOcBPvIvT27RDyRZtuSlixAFSXkNi1cdpHSOqG?=
 =?us-ascii?Q?+GfWUrhTPNHIQkuMofZ8cXKFp1mlziWwexB10JOVCfNlHPSPHQREawee7BUW?=
 =?us-ascii?Q?jQat4f2H6cknOyksHDZ8f1dcm4rt/2qNINwQNVXpL9CLA2c/Q5OwBeIc595/?=
 =?us-ascii?Q?Ds+0m18VGVcrsgKa2jU74b5AFZMgV/g3QJRAw2MKJayXAdgr667vCoA2c5e6?=
 =?us-ascii?Q?GBtvWBvALxzvF4VwvEO60hD9QXNpm8niUP86UZb4F48nF5Br1PjqFC778YGI?=
 =?us-ascii?Q?5epHAfwy+rdoPpd7QRbwd2OXCaRCY4Dj7XmAMWYKEdBsWQtkAYjAI6VMyZdk?=
 =?us-ascii?Q?2Cswd2WV6SAsr1XChS/q89wZhS0FMBrmbcXN6yraGwptOvHLsiaOIFkfO0JW?=
 =?us-ascii?Q?fIAzuStclB3DU2j3/4BWfGVN3V3MEUehFODCtD92WFux9psB0aCjwo2sbZTc?=
 =?us-ascii?Q?7iqJm8B79JAdUiZ5ChjsBbj1SEZCf5OkWne9NGHEbXSAKzfZMLmb9Zj/cX6A?=
 =?us-ascii?Q?kP6cWcEPVy0vnmeaJ4jvlx298Lpq8/FvbqfhIRMuDlBF4y6A/B1NeB4isHHO?=
 =?us-ascii?Q?QgCwLEdgIFjigpRv5qP1SfC8bv2CN71Twg3cZ+yCKQ/RM9hq0eEJFEXq+GhM?=
 =?us-ascii?Q?iV3l+yGuKtM8XC7KPdKsTtKILGzc0q+wcDkl54XOwoJLRhWNc7NjuuPU+apT?=
 =?us-ascii?Q?AVHS9LFVZCpOlUeqzbE0mht9PXh1pFAPOxo4t6ZXdllmqEb5VEWhakDqRtQY?=
 =?us-ascii?Q?JNRfEJvnpSGFcpIJ8jZKYwPec0a2XP/7ormbGfuIGcbvPnVkpmfT3UF9Nl3x?=
 =?us-ascii?Q?UaU5NXUdGHXfBJGCDO8akb+1cQoFh7K/Ls5y2JMUGlDmNasR9Gd6u+3+v+FH?=
 =?us-ascii?Q?SLYMuxbp13EJ456H6C7ApBrI0WFBuxIKz1BVMt2ZtcbnEvU9fdYSR9E5Ko2W?=
 =?us-ascii?Q?aK0D7mqOK/uOmNTnxlzIs7V45orHj5A=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY7P301MB1984.JPNP301.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9cd0cf-cac8-4638-8aef-08de88e65d8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2026 14:13:32.6715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zt/e1JOeAMRcMWiO6JRRULRayOv7T7IG+qSy5Q/VwO+ERk0owCoHakhR9reqISeTksHy02gT3u+r+2g3Liju3BgOeK4VnKji/cRAodXsWoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYYP301MB1389

Hi,

> 6.18-stable review patch.  If anyone has any objections, please let me
> know.
>=20
> ------------------
>=20
> From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
>=20
> [ Upstream commit cfc733da4e79018f88d8ac5f3a5306abbba8ef89 ]
>=20
> Add RTC node to Renesas RZ/V2H ("R9A09G057") SoC DTSI.
>=20
> Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
> Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Link: https://patch.msgid.link/20251107210706.45044-4-
> ovidiu.panait.rb@renesas.com
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Stable-dep-of: a3f34651de42 ("arm64: dts: renesas: r9a09g057: Remove
> wdt{0,2,3} nodes")

I think this patch needs to be dropped from the stable queues, it adds
the dts node for RTC but there is no support in the driver for this
platform in older kernels.

It looks like it was pulled in as a dependency of an unrelated watchdog
fix.
=20
Ovidiu

> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/arm64/boot/dts/renesas/r9a09g057.dtsi | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
> b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
> index 630f7a98df386..f59c3040f536a 100644
> --- a/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
> +++ b/arch/arm64/boot/dts/renesas/r9a09g057.dtsi
> @@ -586,6 +586,21 @@ wdt3: watchdog@13000400 {
>  			status =3D "disabled";
>  		};
>=20
> +		rtc: rtc@11c00800 {
> +			compatible =3D "renesas,r9a09g057-rtca3", "renesas,rz-
> rtca3";
> +			reg =3D <0 0x11c00800 0 0x400>;
> +			interrupts =3D <GIC_SPI 524 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 525 IRQ_TYPE_EDGE_RISING>,
> +				     <GIC_SPI 526 IRQ_TYPE_EDGE_RISING>;
> +			interrupt-names =3D "alarm", "period", "carry";
> +			clocks =3D <&cpg CPG_MOD 0x53>, <&rtxin_clk>;
> +			clock-names =3D "bus", "counter";
> +			power-domains =3D <&cpg>;
> +			resets =3D <&cpg 0x79>, <&cpg 0x7a>;
> +			reset-names =3D "rtc", "rtest";
> +			status =3D "disabled";
> +		};
> +
>  		scif: serial@11c01400 {
>  			compatible =3D "renesas,scif-r9a09g057";
>  			reg =3D <0 0x11c01400 0 0x400>;
> --
> 2.51.0
>=20
>=20

