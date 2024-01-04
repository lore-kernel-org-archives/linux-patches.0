Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7819720303
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 09:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CAgyNR3t";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="GFkpN5Xy"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704358957; x=1735894957;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Dc1FU8Jm5NI6JuLTg9NXxN7lvBQRwrPSlR2WOs7SK1c=;
  b=CAgyNR3t0xgYvOrc85bdLR1gV2qqCAArwS6/az4vtBFS6TA5NM2Bs2vz
   EL8z2WtAy6NG9A18APn1cye9WSrdkxTzXd8F/rUuOXxKjBci4IjhNWzwP
   2COp/3toUiENNXC2MiEuGE7izpkADik173MKc8m4q8s1EryLOOCGlA6SG
   X9mpfCNZqZEESFQ7Tmg5YjsU/sdrrAr+2wH1gXni6s6D+6Y/yVnHppSj3
   RXvpsrMuiuGMOJWNrBLE07Rw5vUXRYhQ6/uwRVckUG+2o0P4qI3yCe16e
   tahsjK0t5aJeV00aDDrhP19M0zQRSVejPu22+RyE2AuUjvBOi8O0G2ov5
   Q==;
X-CSE-ConnectionGUID: orLbMiOJRYS90l/ziwhCIw==
X-CSE-MsgGUID: 6mZU3BGXSbe2ItY0LT7olQ==
X-IronPort-AV: E=Sophos;i="6.04,330,1695657600"; 
   d="scan'208";a="6360886"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2024 17:01:27 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8dFBogSC96Mc2pZ4ZeeXvCdQo7n27SQl9glO7XSXOZCVmEiFN5uPE6/cK6IGi9wDQWuX4Ps4LgsrC7Sp7bQaTxFDtiZkE7dEjO2yS4W9xZa2A60vyVRrk8O3M7DW5wzyrIa3MHk1xTrw/cduKUVM+qLDUAe+WXrzWhF7coJGo8e5ZWIWyKo6Vy555Z1cQeS1ok42uAmwYEzhVDtd7WvfzpL9fHzGz+p2NCp222L/41/geqWXajeZKR9npNqYi+YYpSMQvL38W8qEWXBJVXzV3Y8w18Hzd969NgBmmQFGOrNqeVHXTuzE1uc0mN40C/GZ6AGaqfYtiSJy8m/WvSpDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ub+XRtoL++xI2hH3rk/xmASTfwmg3h3Am8BBPk/gjEc=;
 b=Fch3i2MVJOd2BbyksvdKhqHwjoLDvu3Qrn/WryNJgGce8tJm/zx22GVcpuhGYNNJBguZZbfekL3xjkZxapdU5bPnvMJ4W4Ld3ASZel6wBBUsVQlwALSNpOXNZI1pBGvTt7H7PyksvN94mcNPp8tYwbpVMY94/TAq1DAKgsZgAQThAr2zkt4So7WLrWRcmf0t2tVBfsBaI6vsqO84x1VwkpyhoTeKP2JOWMftYb5MXxwYWkFTqXcMfiolJGSpszJXXKTWyJ/byO/YJVw7AM8/YCi7htX6VnPFrZMWcUia0IEV+YyjW9iYRePH54X74KGwmbx0DCYyJwhQ7SS65SXkxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ub+XRtoL++xI2hH3rk/xmASTfwmg3h3Am8BBPk/gjEc=;
 b=GFkpN5XykCIC4/1eDWxIi6tAnSVun5E2KM4o4mS0cQYR66z/Sle9Y8YlNzCxfH+VPSf/YCqVr4Q6yQKlEMvVuaRNHkFSCbBn1c16kgWy0mvCOFOis1z0EsjsJmCRAmmV+KCgiTOJwvNA0X7TAIYTsDH46TkJ3G3RhVck510ce08=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 IA0PR04MB9036.namprd04.prod.outlook.com (2603:10b6:208:492::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Thu, 4 Jan
 2024 09:01:25 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7159.015; Thu, 4 Jan 2024
 09:01:25 +0000
From: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, =?iso-8859-1?Q?Ilpo_J=E4rvinen?=
	<ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.6 36/49] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Thread-Topic: [PATCH 6.6 36/49] platform/x86: p2sb: Allow p2sb_bar() calls
 during PCI device probe
Thread-Index: AQHaPmhRcPxyh6k/jkm5O3TgPvqec7DJXF4A
Date: Thu, 4 Jan 2024 09:01:25 +0000
Message-ID: <qszotcvi2tl4aldn6nsifqqelfgtm6sip6zp2r3subd3wgdi2k@c6tuabotwxkc>
References: <20240103164834.970234661@linuxfoundation.org>
 <20240103164840.618631289@linuxfoundation.org>
In-Reply-To: <20240103164840.618631289@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|IA0PR04MB9036:EE_
x-ms-office365-filtering-correlation-id: fb731ac3-2484-4a52-57cf-08dc0d03bb50
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 UCb+yxg0NIuAs14pTYblBim4Db5ZjtX+RTuMaUvqRi4daCQUDvkOlBsmRlmEVt1hgQmiqg+WgJEhUiy9dl7rPBfPFUvctbUOUkI27JZ3WRF2+LVlgaKRoLeFYsUns3NrIO5o14IokmUJhZdM84bj3JvOxQaW2KhctqlHnxAusKTR0k4VWwDO8Wu9b2TciFjhNjs4zwf1dSJfCUku4pbLXx4tRLOV3n2RrXNcK3BQA9vXsFwXJx0i+z+8M7BeDLseqdcm2TLobHbqmCnm8tfPxr7dz43BZ2O+sZKPnEfzSbCQ+bozTK19fhB7m633wzqX6RNCmjjQACl1e27YckR5hgELZPt9nLpY5omG+FmkLzYFv9L/6IMqifbke3vyShtacKgCFzmAIShzlibazh9tOqRG3jghhR9cqJTaZBpsrW0sLJ1gb9FY5k+Wa+Lw0AR/LLOThz+Ethq0RNky7mWSf+JCY1sn3Xv2mPBockaKUZLBk3fZ3+Ovwgb6FiR8k3XBlixJ14/mqj38Xogv7szdKKT50eHb6FBQmTRXg270lhrmRFPmr6TpGxMs6JefZxB4yuUpCaopoDvrfcYmoAHteUHdnXrZ6qu3aMALkDupx3g=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(346002)(396003)(39860400002)(136003)(366004)(376002)(230922051799003)(64100799003)(1800799012)(186009)(451199024)(6486002)(2906002)(83380400001)(44832011)(4326008)(38100700002)(66574015)(122000001)(41300700001)(82960400001)(33716001)(26005)(8676002)(8936002)(316002)(966005)(71200400001)(478600001)(5660300002)(54906003)(6512007)(66946007)(76116006)(66446008)(6506007)(66476007)(91956017)(9686003)(6916009)(66556008)(86362001)(38070700009)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?nMBK/kppATp0bbQ32vHn/gUz5+9XfMJP1ng+0JrrGklms52AjmO2aYodeR?=
 =?iso-8859-1?Q?W5jMUB5T21XuCbvEiMimepHgkgJm8dX7b+dNOa0U0JsfDgKtQSxBZQRTJu?=
 =?iso-8859-1?Q?GZZiTci7y4uFBsO9zGEiqaPc/atxlS8c6k+q4TmqTQ0w6RkR8RsVZRzX7l?=
 =?iso-8859-1?Q?fdcNwBOWRTcs8IRzz+Ch8yZOhw/9Jm1uAMKSCVdA9Y4NcNWfKAUBimsLPa?=
 =?iso-8859-1?Q?JM+mjyjXzcO8qt2GXRm4Z3tqiE/lanGGLqgyLYn3zKmy+dQ211NxkoTRLm?=
 =?iso-8859-1?Q?N53381A6i2CcQDV0IcyjMhmGVpdJbRNIU4dT+eiNTSevZCPrEZfWGOb95F?=
 =?iso-8859-1?Q?434AsFOcyJNxRSiAdEm0ugjo3qsWr2sys7Uxi8soQkW+FyDd4UPU/U+md3?=
 =?iso-8859-1?Q?fZMJwct6vDEhaAEX8WRBDldhQMN80EOb1MB9bLGCBAiRvNDe5v7MuCNDRc?=
 =?iso-8859-1?Q?eXfgDvw0Q272qQ07dpLy59nO1oUblE+9oeEBS38r+eKcsM4fOEXpi64I68?=
 =?iso-8859-1?Q?xBX6ZyL/Gz2HsneQgvLA5NaRA3r40aR9mDr9vewBtkKlHy/UDCsFRoTZuo?=
 =?iso-8859-1?Q?V4it/bMzvMnSY04tDB+V58vExHprl0LiWplBb+lWwRhOsw03g1zEfeh/QO?=
 =?iso-8859-1?Q?L4b1Tt7gM7tQD7TA321bmNuQ3M7pgM71WC5GZxz9fEUby3DOWmYbtCvSiR?=
 =?iso-8859-1?Q?pjot+RvWPDPRv1tSguZD8OhlHMXTJJrL9Fh52Imx5j5FKtEVZFrkxYL4GS?=
 =?iso-8859-1?Q?2+C3oVAefanyeSYOnYEW5vObr0B5QWm8AiyZ5SJoNDifflOQjfgBkhHPQn?=
 =?iso-8859-1?Q?dzwRLrtmHqzHxsgn8/+u9lrmIJMsBDwyoSFxNIdxRncSqWPv2KUMsciuVr?=
 =?iso-8859-1?Q?mTUxITy9w5yidIfWQeDW9D4qwRa7hlQwjjkP5IMNqHKA7DZ+u/apqzSVpJ?=
 =?iso-8859-1?Q?kHOGssxdWIVyE5LlMWvuyEiPv7PilD4+ARmVg1NFCCAY+UMBYA6yI1+Ha1?=
 =?iso-8859-1?Q?z4OfHP5JWf96JboaX/L9XYjeAuJPJP73KZtOJuD9yRMuJhXpGp+7u0+Wfx?=
 =?iso-8859-1?Q?HPdoRLRN72QObrBUrAGyavqDHXrMAxOKUjBOPt2plnHbVB3/1BoY9APppv?=
 =?iso-8859-1?Q?mcNX/Xd32jedPc+F8wZtHZJPaGTi8CMlREj2TeTJP3MCB9s2QTIeRJyrAr?=
 =?iso-8859-1?Q?aP8aLq/ydQSCrbfDqm3Om+SmZW+Dt4gy2xHLo0n0+V75WsunYVamZMBwru?=
 =?iso-8859-1?Q?hcsC96yCo6aRK7XqZgN3S3RGDZRZ2wI5eXgXf4Ds72V9QN/VNe43Ydxja7?=
 =?iso-8859-1?Q?doPJPMpnKC2PPKWuwUTxwV7bVw9Qi6LXdNCQSVGm2OCUx2B9oHVs5SVy4H?=
 =?iso-8859-1?Q?nl6TQBwnGBlbOflEi+m50DDUFZw9mn3k9jzLmO5jNvMgzq56/pgpKQyNun?=
 =?iso-8859-1?Q?KewCovLHwMhvnmeI8QP3WdL/yua/mdbotHXj7ikSXUkkBH8Fc8IjzXOvEp?=
 =?iso-8859-1?Q?yo1wXMvcdq2I3G4DnGkjiaWAQ+um9zYuYi7DXunyjynzt283wCnV3j2SA8?=
 =?iso-8859-1?Q?ZH6vEa87ojIWIj+asmdWMwJlchh/RPgMAcyvSm1EHsTWoN8MHGFUkyOTbN?=
 =?iso-8859-1?Q?yFXdlaC565x3Msuiim0e8UdSsYRbjoUlZwpvIE22FLpZ9j/0ndi/0iEarR?=
 =?iso-8859-1?Q?84VtPwpfNnWtIIwSGEU=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <53D4548170D6DF4590E47BD93307066A@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gPInMhq+yQyO1SsiD45MK18sVLOjbLqX1laTG/PgPXeKeYNbVDIllGmG0oKMC2Ld+0Mdj60S/zW8hF3kY2DxPS2jw5tyg0nQDTnn5oFPs/VvGj9g+E6CipfrhVHSFPy99ZDYvaD2iwXY+S8mptoNuJXyzKuEYXby4qAg1yJWAjOIJV68FmOn8f3m6zFjO/SqHAThtNkJv6uX5xYDpo1LSdOxSVQlDc7Yr353ho0SrxQ2OiLQ5rBC3zp6bmCAVGaMD9zLt7gEf+qnPhJjZxcFLTM69RJf+7fmgZ0gJIJSVr2Yn07mYDU4edy0XKMYa7yWIKyeDfdCf9M+XN88OvV8s6ShRN2QaD5spSbSj4BZUjCstxWwAD3BlVt8niiH2v6CaUdnkZk0RF1ria+dN3axizgpFMkxyFLI81Su9y0Z8JXfFXI9pSSH3b0AT5CR1Ip+gaMNUeeDyn7ws197pBPjby6+qJquAvxVdCX4AEWzq/puGvtFzZ21hZUkXiLnWZJfiBp+EBntJE3Sq7wG1o4CFhtRzq6Ho7jiR5puQb3O5iCwPXELS0YEqaJXzO3rpKlddzuINUDj0tooJzubKmjbYtFXen/m0OCPJCudahhoNLC0+JfWr9IbhBtNBqg21Uqi
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb731ac3-2484-4a52-57cf-08dc0d03bb50
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 09:01:25.7927
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EVdUNWJkHyARynqI0XHzyh6Z4GecBKyfcjwLJ59PERsTEIaOWoB2hVaYhxbTjEqgFFyfZdIuC2tzZJHWRoD+KxJxSB3iJXnVuidmmU66JVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR04MB9036

On Jan 03, 2024 / 17:55, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
>=20
> commit b28ff7a7c3245d7f62acc20f15b4361292fe4117 upstream.
>=20
> p2sb_bar() unhides P2SB device to get resources from the device. It
> guards the operation by locking pci_rescan_remove_lock so that parallel
> rescans do not find the P2SB device. However, this lock causes deadlock
> when PCI bus rescan is triggered by /sys/bus/pci/rescan. The rescan
> locks pci_rescan_remove_lock and probes PCI devices. When PCI devices
> call p2sb_bar() during probe, it locks pci_rescan_remove_lock again.
> Hence the deadlock.
>=20
> To avoid the deadlock, do not lock pci_rescan_remove_lock in p2sb_bar().
> Instead, do the lock at fs_initcall. Introduce p2sb_cache_resources()
> for fs_initcall which gets and caches the P2SB resources. At p2sb_bar(),
> refer the cache and return to the caller.
>=20
> Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Fixes: 9745fb07474f ("platform/x86/intel: Add Primary to Sideband (P2SB) =
bridge support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Link: https://lore.kernel.org/linux-pci/6xb24fjmptxxn5js2fjrrddjae6twex5b=
jaftwqsuawuqqqydx@7cl3uik5ef6j/
> Link: https://lore.kernel.org/r/20231229063912.2517922-2-shinichiro.kawas=
aki@wdc.com
> Signed-off-by: Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

In same manner as I requested for 6.1-stable, please drop this patch from
6.6-stable due to the new bug report [*].

[*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP=
6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
