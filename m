Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737CC20307
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 09:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BC4YLKV+";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="lQdKLf8E"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704359504; x=1735895504;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=67kdtLBiysaWrkxW8jddebv95IoRPKqJVtF6KqNDuxE=;
  b=BC4YLKV+TvErzW17GM8zx4NMMUYQEaaBIb1L5e2U0kv9Bg4qVliJjyM6
   rTLtsklEqfCF5hb5S7ktIT97Fvk3kPw2f2Mvtpk8n2/WFwZlWlcbKQA0g
   71W/TOZfmdxWKXzqwaDephz0OoGNXYNQT4Hb2Ht53xRlloutECt93zxz+
   OZ3uZZ0StY7/Fg/XIJLe+1ybMpgn589Gdsu8akZ6GbNNv7ndxqg0cWx5N
   Vowy9KlemrMUUOpBbxkr6LOQ8t6M+ct7dAnMaWHuUjkjvBrlvFiTsMEzf
   oJdJG015CNafL33myuotGAcUxLuvElTQHeQrBEQyv3+7gBIQ99Ky5iVs6
   Q==;
X-CSE-ConnectionGUID: UdEf09Q1SJaBqli76p9F+w==
X-CSE-MsgGUID: OFOYNVISRgKgPUin3U3rig==
X-IronPort-AV: E=Sophos;i="6.04,330,1695657600"; 
   d="scan'208";a="6244732"
Received: from mail-bn8nam11lp2169.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.169])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2024 17:11:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lVoTr7UY8eP+YQxEolNDkkivN5yp+5Lx4XJeM7vMBTyqEqPj8j6KGix0iYusMkEZxLG3LaoCv5twVB6FnxmkkR2eJYNDCncrppt4tAqgTeLeq5S6WvR4oi7bZQRo0hGa2Pe2qCVcTxJSvZ8n8bbY393M8GjYNiyShkVp6GiZwjnIogRi3aViqfTXT9wUawYHx4UOPEqoJHlJWSUYl9sp+7M3fvV7p43SR6ZuKgmwJwsGLy1TTg7EC4bLGI0d1Vwf2DHRd62S4khcRnIw+l9aLyQKTaFzKtm0vtfG5LZoQqN6WLyftDW2OcX7+uSn25uiG6DGZdBxRr/nwvdyDYzkQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1WXcYRm1FfJm1mK86IPzGqEURWbnJzG8e4rtp8s3tlA=;
 b=aGHC0YBn0qDEvhBVedsOrGeXipYk7ek8ODTmAOnehlsk2fqEkPDz1TMzU600AyLz29+SNThxwEIcp7wg+BOJHt53xbQ0AK6nHpzRHRNNEOH3sxty86FVDU/LoTJ/c6XYIV2tw10zfPyQPB83JNQ7eI4sTLHPo42PpE9TCsiO2WwgXNuoBQdoOQS+Bz7j8JhxaaygM4o0l0mOo349zkqDTBYVfHNLDHxuGDkAQ6H7HA6i0Sf+V45104/hx/5vH1lCZhFm28J9nAHNW7NbNemi5p536lid4wqetaXVvDdOJRfI+6YSxGDhG42dsE4MMqAKmCVd0AtOdaioCPO6VKHJQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1WXcYRm1FfJm1mK86IPzGqEURWbnJzG8e4rtp8s3tlA=;
 b=lQdKLf8EoniO/DFEMPc/5Jj0xLRg68omYu764/rtJRFtu0yDge4JKgXu+TvebPAsvHvosBZob+TCUThe9c8y5Gy9Vmm0HVuGunTB+aWPSCaybUMIHWpHKxQaeDmCVEJdxBlzBQJK/scjFJO6DAD1KrLbXFf6hTLVpRP5FDqNq+g=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 SA0PR04MB7417.namprd04.prod.outlook.com (2603:10b6:806:ee::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.14; Thu, 4 Jan 2024 09:11:41 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7159.015; Thu, 4 Jan 2024
 09:11:41 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, =?iso-8859-1?Q?Ilpo_J=E4rvinen?=
	<ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Thread-Topic: [PATCH 6.1 086/100] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Thread-Index: AQHaPmZ5dT+u7aMqMU21DVnXSPiX77DJWomAgAABIICAAAOXAA==
Date: Thu, 4 Jan 2024 09:11:41 +0000
Message-ID: <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
References: <20240103164856.169912722@linuxfoundation.org>
 <20240103164909.026702193@linuxfoundation.org>
 <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>
 <2024010401-shell-easiness-47c9@gregkh>
In-Reply-To: <2024010401-shell-easiness-47c9@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|SA0PR04MB7417:EE_
x-ms-office365-filtering-correlation-id: e04e7c03-0941-4a5f-688b-08dc0d052a03
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ptYNeX+zYNYCXT9cwqzvIBQQ7P4NudWW7ErAwmAXPhfWPRpkKTtLf1CFmKifooh6C4VG6l9DsTqZtuFR1gGcHVtCIbDoRnuKQNNxVDubuAweMd/2NkPuqtEmynyoXEtmGHDTTRRgmgBQL8cuxL+uVmA57U3yGEfx/5PRd2xuc6aKr1l0F9kix0SkRsQ22pc2lP8daTuP3n+vUDGeYwLViX3WutJZib8zJN3HmZ0jI0oRj3PVF1hfSRNcZdWyOgDYgzaBLY6DddJIAybkAJNyzJh9DtOAHXG0o2YVvTKtvQ1RKsdBoUbCcwBajgiUz62HCKrtrRuWe8wOwAWpiEwvuhdWHodD30RgLZtPP1Mdlv3AhubW7ZWSLne5AX7BTXkKpzeM68ipn0P5BrMK45f7qfBICYpRq9KFiqxobCN8TlRpYT7mnD60g5g2ahV6LbftKcRbmbRP50oDHrOC9g7BoppwKQVAGyfWEwZprpXU8jOkE99cAC7OhitJx79ptO4kR9s3i3BgclGOwhqezlrpCiWtfovupPn/JqiejBaOAFLXkm7mmD8jn7wTFU0PSOm9qOwcF+dy9zrjFfwLexp7GQxRl1F7iu09EQBnSC/QZMg=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(376002)(346002)(396003)(366004)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(82960400001)(4744005)(122000001)(5660300002)(38100700002)(86362001)(41300700001)(6486002)(26005)(966005)(44832011)(2906002)(6512007)(38070700009)(9686003)(478600001)(6506007)(4326008)(71200400001)(8676002)(8936002)(316002)(66446008)(91956017)(66946007)(66556008)(33716001)(66476007)(64756008)(6916009)(76116006)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?+1l8c/B+InMZXI/Hk70P5zK8SAdAWIx/GW55BHgE2Fcmb13Pt/+DqizIfI?=
 =?iso-8859-1?Q?jSj+ivyKrY/9++xaAyS6lCe5qW38FsdLHTIOwLle65cOb/rnVpHwlhPwlo?=
 =?iso-8859-1?Q?fmdpZyfFZKaYw7ZgReG5Z9ladDsFw0av5x0NY3RpeH2hxM3YxtdCfiHxPn?=
 =?iso-8859-1?Q?3HF8WuF0yT5rz82cD3712REAbATrqwx/SVmZ+ytbqnpK16VzXJoX9Fbqq9?=
 =?iso-8859-1?Q?nWfFMIdTYQdDwwMVO33UYwxsJgngSWsiISrvrZo3YWx3WCVU0EaWxznMeB?=
 =?iso-8859-1?Q?qLO8mWSCYpK069U/PcXl+TEHdFIAUlFbeD3TMlTixmJlNpkIWje86cIMWH?=
 =?iso-8859-1?Q?mZXwPGHdQY8LTCa+XOEyEHbXpEiiEmd7HpzrIR3AULCWJky2jeOVWaY6B1?=
 =?iso-8859-1?Q?Xih0mJm4sFEcosyAxOSdsN3ZtpI9AizAa19HaluJEIicxzgjuW2atA7cxK?=
 =?iso-8859-1?Q?1LY2XbBqTRxgdPbfeTbPFfAaVDVr3/viHzMW/4agbKqU3eQog+DXiZ4C75?=
 =?iso-8859-1?Q?uBnHfRGt4IUd0T43C9+lX18UpAUPqN32TbqQTpSHiWiZ2jAjZdQMZ70Xrg?=
 =?iso-8859-1?Q?FcpLlirW8jH4Yiyg1xXZlZ9N7QGyEtL+7yQLOOv8s2gBR36QVnud3DL31X?=
 =?iso-8859-1?Q?+bA/9hBfpyr5fHCKqJ/yv5cjKPNgt2MaVpGxdD1j12uVOx2dQl31ONneTF?=
 =?iso-8859-1?Q?g30uvnQeQG5NRKSf1nAcsFWSUp9ZU2fjgwT3pq+TALE84UVXZ0i1HTIGLL?=
 =?iso-8859-1?Q?40wBbHei2HXFQ/oFxyJ+XD1HcdZehnAQlhTpiJ0jkgCiWGXcZtJRIfg5Vt?=
 =?iso-8859-1?Q?GOWIT0B5dRKaRjlkWmdmsNaXD/jZxzMeGyeqikQT3d4kt30N5THTiLalJc?=
 =?iso-8859-1?Q?O1WkuzozEupV0BYsBZ9FSf4Oy+MopOcQTq2g2u03DtGd9jhVwxAKb7joAV?=
 =?iso-8859-1?Q?TtCzVcHX1ltkJS1n3tadzJTYQcXCNs1dDK7iTsKXwokum9nojMwmBqTwDU?=
 =?iso-8859-1?Q?L7c9ER2pD1UIEU/4wi4M2GqMEP1ztVh7YDLgZ5kQ4e+YZmTJKPlrUM3D24?=
 =?iso-8859-1?Q?FUsnSbdk6lSf/14+oQGJNUYmlhhLnQCm9vo5Qzi5MZnbS+rzift8id1uW3?=
 =?iso-8859-1?Q?5QOwRqnou0UuosZE03JmOr3eRhHp85wbEegbqRqZE4fjcxgOhc2/LmH61+?=
 =?iso-8859-1?Q?+LlKsqb7r6X4Odl1yLSJCnWISaXTxbp88bw7o4AM9uL5BhHavCmpsQm0Yt?=
 =?iso-8859-1?Q?RJabyVeI58gw6L+IDcrqlTe3NWFoQJZnWN+e30ZCLm5EMTOlBEWO8DEtyD?=
 =?iso-8859-1?Q?0Mj4zyjYe4Jkee69QqsN5yLz+/+BbmiO1M29F1juaUOze/5QYNinPMPK77?=
 =?iso-8859-1?Q?azhWyv/IDuDluljOFgFdV3KgZ9p7Af6W9YGEN7m9+eSnU/vOdvJE87uYZB?=
 =?iso-8859-1?Q?nGaFIcoGGDIHdq4/WuTItlol+veUDpxxD0B3uR/f3Be/961A5dmIWenLOV?=
 =?iso-8859-1?Q?JlpGe4VTRzDRY+4SIKSOspbfrBr3d4QumT3c/hws+RTIwx+UpPQZxGqLVz?=
 =?iso-8859-1?Q?ZBqDowJHLSTqJhxZcyKy5PmeNQBn4rcZdvqYEADbqRpJBSrsZ0fUz08Hrv?=
 =?iso-8859-1?Q?W2zxX0isKCachST5f/rNjuHAEF5aAi88rRI3Ljioiyrat5mrT222N4V6Jv?=
 =?iso-8859-1?Q?F0CoWeeqfmqI/5BRKvg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <26C53EA4A7D4DC478DEBE119F52CC1BB@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JqWj27FTTL8HkM//xPE473QwLa7el+eyGA1Wbwn3N8fPim6lI6B5FXLKePSxvUvcyp0h329ztZS4UGpXV9JYivbvyaMchqffY73Bp61qFXXo7Xk9VTURhe12StZhw6hvKD1lXy3rmcsKshHjH0OVA2laSx2T3/61xq0Zc0xkETtHkKhzusU6HM5WJ3/3lypMzR0OV/+lHaQaB9rMDEYD6qACRHgLzEOCiFwE4ELxklMS+cEYpbvkP050Zp0yRqb/A4bIpgA6WQwbAdPjYascOerR3r1oLCXtRf9E04oUv3ceCcgqzwtuP4bLBkKP9AexC677gj76/q8cL2FhMzHh2tAdaO81otyLW5d4/XyJMJ3z/RSHg5VrmXs7RMQVllDQd9blwQ3A3Tz8L3GvCOFYCvIbiAfPw0282fNpdeps7qfk4LFcVbiyx5ik5q6yx43dgvFwcuaYFziMQmR99MtPcortX6Qrm7/Xy/JZicDx/huXhPcYDut6BiYTba2RBw8sXA5j8EslJeoGtDLZ4Q/gOPcn7FEYUWSK4+z7+6H+GowQRucOQjnmYbmFq8VbLIlq1mkKW2pSUjOPIGPIEHjXWuhl0V7QjjPBOoWsxjXawKoRyRXlnXDuXSgisRm+zRVT
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e04e7c03-0941-4a5f-688b-08dc0d052a03
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 09:11:41.0276
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rJ/p5XW4IVG2niCNBd4MRieMXEQlGXHK3zYQfRIv21DNGAGp0x3leUtjJFoRDyTbleWiT0b3NiCnPUgXYgk7l6eBdOaxKemD+1tkH/VZ8kg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR04MB7417

On Jan 04, 2024 / 09:58, Greg Kroah-Hartman wrote:
> On Thu, Jan 04, 2024 at 08:54:48AM +0000, Shinichiro Kawasaki wrote:

...

> > Greg, please drop this patch from 6.1-stable for now. Unfortunately, on=
e issue
> > has got reported [*].
> >=20
> > [*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg3=
94bP6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
>=20
> What about 6.6.y, this is also queued up there too.

Please drop it from 6.6.y too.

> And when is this going to be reverted in Linus's tree?  6.7-rc8 has this
> issue right now, right?

Yes. I agree that revert action is needed.

Ilpo,

As I commented to the response to the bug report, fix does not look straigh=
t
forward to me. I guess fix discussion with x86 experts' will take some time
(Andy is now away...). I will post a revert patch later. May I ask you to h=
andle
it?=
