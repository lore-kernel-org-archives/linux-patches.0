Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E37F1E539
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 08:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="fzYdVk88";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="Hkw4Ye60"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704358562; x=1735894562;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MwUWMSwb4+mOAADkLdURUFVMmfsKVAEZZdeYLmgIVDQ=;
  b=fzYdVk88H9WyvkMgLC1yYeqGB6nwYuwBBNrKP4GpEZlHPIx438OR3Ae0
   5HKl+RvMCGHv09ZZtGqHI1FvW/D3lJ018XDPRiV+RlUeJqbEC1jxMK5sM
   6QahZFbTSfU7NGvK/VDylgEJLAlOW8pAtbThUCaLd1mA6tE3XUXPupEF0
   rotVAVchcOUr4RGQKR0B0K+5ZdBoZPFVS87Jd7HbhS5SyzmVaPIhOzP2K
   fz5aDDq26ihfRARm40WWGBS7dtxwU5821cU8QL7kij54V+Be9M4KtlCCJ
   Tn7fT073gy5tVOta3TI3Ecwu3X1uv9O260zcHE5ZudJ87tbFRVyTE+jFO
   w==;
X-CSE-ConnectionGUID: tEuGMd5ORvy4JYFCcxZcNQ==
X-CSE-MsgGUID: Ra0++VsEQx+IQtAyDCFHig==
X-IronPort-AV: E=Sophos;i="6.04,330,1695657600"; 
   d="scan'208";a="6243776"
Received: from mail-co1nam11lp2169.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.169])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2024 16:54:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkAZWuue852CoCQIBoqR9NEIZ/ZWIFF23zGOM74uapW5hLDOTbp3qP7iPLExRR6DcT1KulunwlGhwrRBaPQHfUkqAQQhm/PyfW4XlbDLiuqKwxWgzvotghmJTbMDy528oV7NJZmE4d/HhNLMnQkIKG0XeRx8lW9zXCI277LQupvBOWvkBzOV+CFAz36EoyH4XnbA86UN9SSSxM82U2CbtUGK3Wm9k27Bil8MbVqPPS8HVV/IDBltcDUZY89349/Ndkv03caXxZ85rAZoRh1KTaEBg3/+Rjfc+pswWnOZDIC/aNMF4/hVb5bhVLjuX/9uk6Zk+7dT537OymBPuIQ4YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1+eHbPzjq6s+QvcAZLBOprTzZInNv6OX/CvxxUy8POs=;
 b=cTDt0tHK+9F5JsMHhQdNOYWDNIZLt/FBURDalIlZ8UktEKmTQvfu2aqd4Psah/Woxh6Qa6iP20Op0Zbw29lVYp6haesmh9X+hyaVRVv+C/ElABQ+ZNGRQMAvwoPiy8faCB8wMmgc+m+V+r7aC7sZhSLj/kqRvkpg8aDTOOL98xmTTZeqLfG+NX6APRqemrtFjKTuaEJQyX+bg0mOvpzJD+3I8lpoHvS9UBcZscWEDfvEH/z/YQrH1J0TpivrLb8u6yXfxkmeq3DB2ZMWI7YWaaFd5J7uJDak/8iIFm0AtG0+B4L3piib8Lk3NPmWEPdlLxp4AZvO7S+bwi4g8FU6RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1+eHbPzjq6s+QvcAZLBOprTzZInNv6OX/CvxxUy8POs=;
 b=Hkw4Ye606sfKyvjgCqOdyI3BSv4w3aNoeZIJHhHXZAWFMQM3z0EfLip2sgVjtRE2QMudJyhphqx5ZJsCGZugEw1WV+HTkSiv60be8apU5wHPUrdckWYsSN7gAWmA1xB2YhI0vqQXpvPGTxnX10QFAAKVMqRK93nIuqoImnnEjWs=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BY5PR04MB6453.namprd04.prod.outlook.com (2603:10b6:a03:1e6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.14; Thu, 4 Jan
 2024 08:54:48 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7159.015; Thu, 4 Jan 2024
 08:54:48 +0000
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
Thread-Index: AQHaPmZ5dT+u7aMqMU21DVnXSPiX77DJWomA
Date: Thu, 4 Jan 2024 08:54:48 +0000
Message-ID: <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>
References: <20240103164856.169912722@linuxfoundation.org>
 <20240103164909.026702193@linuxfoundation.org>
In-Reply-To: <20240103164909.026702193@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BY5PR04MB6453:EE_
x-ms-office365-filtering-correlation-id: 5e6461b5-8443-4166-6cce-08dc0d02ce6c
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 gK0DTKFD1rBo3R6UoDASPAMuo2nV49dgGdEKtgof55kPziGbinn/GTWOTXGr/uuL5IgdMElcm79UnkIzf4ntYfCRSJ+Scbln8Y6wAFc/rNQtfKumMM1J7OM32FiESw0bAQy4LKGiHK8FsBQbNx72Orw9gotwZfE026ZXasTEoUmk2Y60lgYktMKht3vuZQhvOd1GYXjCG2B6Li4HntT2FvPV7xmnWbjlqIklB/Vk/5MShoqlrSH9eLcxfVuTLxtixP7Q7owkCJEvDZofjzTpkCWdIQfOxcprywHiJnYCjUcx9ootj4JcyZi5IRWt2jASn8FEhXihbGdNo3CO5BwRO88k/jTj4aNRtnzSMN1z1WrQ9X/Qn3S7ls2GnxeHYHlugljdLS+Oj8v3PTky6K4RUUcfnNv9wFH/kVDhT8/FFw+RrbD0KMTlxaCGkV2kW3ij3jXvWsN0YIf5HX4bgiq+kZtxtyyA9nZoh+IaaLy8fsiPjgEondV9wtKs3wFRRH6pVwoIaM1zkXWKefw0o1d75FOPxGqmZexeSDL9/TVgfhqBzThO6hZIrB/SMH+zkeLlUQQypDR8uq0AFK5F+8FBR59L0SHiV4fbuRZNOvlQcHo=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(396003)(366004)(376002)(136003)(39860400002)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(4326008)(44832011)(5660300002)(2906002)(8676002)(8936002)(316002)(54906003)(6916009)(66946007)(91956017)(66556008)(66476007)(66446008)(76116006)(6486002)(41300700001)(478600001)(6506007)(64756008)(966005)(38070700009)(71200400001)(9686003)(26005)(66574015)(6512007)(83380400001)(82960400001)(33716001)(122000001)(86362001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?LpCc8WCF5XV3Nv2XZtMsJZvKJgwXbTsKEKOxZy6iLcLTfmafeKeWDiXK2K?=
 =?iso-8859-1?Q?6uRO3h+vza2HPUIeCmKmCe9viaEpDvpIu0MiQr+fdDH2EThaccRy2bJ/Za?=
 =?iso-8859-1?Q?atI2IkVGeXnNAI4vbSUuTJlnN8RvFV0yZoM7MrMcSP6LSMwIFQvAekChSd?=
 =?iso-8859-1?Q?vB7BigjUrEqlKiUvgIZiCysOJxBffnIFS/7fHS/oMUAtlZpi+1AscgHXk+?=
 =?iso-8859-1?Q?L8V8QjzrIWpcmwlmatAWrdTr7YC0fQYDdGvRw8aDqMDQSyKIQSAexRTbtX?=
 =?iso-8859-1?Q?g+BlVqmuLj/q4B+61waXAWBrXJ7xxhagW8n6VSXRuqef85YU0TV0ha6er2?=
 =?iso-8859-1?Q?1TJ74UK3tOeXnEwAuGy/y8qEYBD3t+GJ1rqd9j7P928kXceyQ4ryZDlP7G?=
 =?iso-8859-1?Q?7kyGnFbsiRVDWCiipFoh99fSpk78YWMOOFHTFm5FMaDzAFMYgQrGHr3klD?=
 =?iso-8859-1?Q?7f+q3qdeVktVUoRxJ8UoNPzFziGx88PGpMsFKIiaoOyERxgEqzzogcmaWd?=
 =?iso-8859-1?Q?t3UitEVn9xfiHyT++yDAD5D5cQc6sF//3s8GaylwFFCkpjwRAO6LJXISo5?=
 =?iso-8859-1?Q?tuAPvpGgs9gh9TUFEYm8W122/vsdsSn/sDDXfmyog8eAPYkzGB2wENjAdt?=
 =?iso-8859-1?Q?YTqeqRJRRHReiO85/O/pu/18MKBzyRnq4G+M+P1Aoq7q5bGsS4kLJdM4vx?=
 =?iso-8859-1?Q?ffpOfVRwtdcQZ6xDynWHSZmrBI+QLLk+HpjQCfCZdFM3083ubQ4HyZF77f?=
 =?iso-8859-1?Q?kesThkk5j9ZXDFKOS8GepS1trIo4Dhs80i0P2yvOYafech61gzYPIQvvg2?=
 =?iso-8859-1?Q?IUfzOt307ljb7C+rPf3ORi0ZNSxZbAOHg0h8F90/vd/G8W7dUh2w93SqlP?=
 =?iso-8859-1?Q?nZnaHoEfrg1A1fmje6uXeqmP5XxngzzkG9XzuphNCvZmPiUcwkyFrXNGvp?=
 =?iso-8859-1?Q?L4hqlJX/GpZiUq+aC5pD/kND54HifwnNbhHo9UV68mB1rlrRVWo5OX6hMI?=
 =?iso-8859-1?Q?nzJSq/eO4gU50SB+Gi7K1HZM+vS/xCu/aQB+ooLYzl7e1oOb8jSGbAqnG6?=
 =?iso-8859-1?Q?7h+EjX0FaTrO54l+IQEfMzT1+YdZJU+p+hRFmOyXm0Ek6j9IUUVEDHxb8G?=
 =?iso-8859-1?Q?DC9F1Dz06jit+u3I5kXtD5IwU2HdY0hjYyy+7e5BqMOqgGgjxMq0ulZnoF?=
 =?iso-8859-1?Q?+DtoyuB7vul48uTLtD2nWJubCuxfdGz1xmb72+4wY3p1TSndIGISEjGTX3?=
 =?iso-8859-1?Q?KxGeKL1LYXSLvkxxFuwR/VDhyE63fDoEGaJBR+PYWrsCsm21DvPNIa9nSU?=
 =?iso-8859-1?Q?CGudcmPY5MTutodAG4zrwz4Jg3ybBBFE/jaf4ooiG0jTqOs2v9GkhucNLr?=
 =?iso-8859-1?Q?Rv125hgTGRvnCm5Y225IoQsmZZGlkavvatqYhpihP1GiVG0S/KLhqPDdqq?=
 =?iso-8859-1?Q?G+fvuaaJTsNCYBCB77WW+cZaEzLI57yYBcLOsEW2Ik1Tghk3CVjCkC1xWU?=
 =?iso-8859-1?Q?Q8AGzrdvYedZzBVCbnuR6GIzVUOJf4oNNZiBuUnK8hVUsGiuc9piOXSxsZ?=
 =?iso-8859-1?Q?/AFPN5ZON7vk9xNGem27z0Krx2wG68JYnxu6tdWXMEq5wcVzoOdJ/RKjYO?=
 =?iso-8859-1?Q?ymV3HumlOA1A0uh0qCX1Kqx78bvPtNYB3XKzYrfcxEb4xlWpP+3v4SpuxZ?=
 =?iso-8859-1?Q?a0eBHQdrZbIsgZRNaBY=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <25947FD745D12645B20322766676CE30@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9j60/XVeNMxhyDtMMJL1pna9tK4prjJcLkXWYLqpDpqHs1iPNI/RBRYT2W4d8ANGQktxntNgrybFx7eF0aEkLovG3HCdSlBSbUDVDhxu1lJ6xhfUSM+vaOaxO9BXrquvbhMaQZYCZ6I5UtY5wokUZAVpsLz7Xrkka7Byd3QhugIpTg00Ds099oEx1C2lxQQuJVkj8UZR6B/7v3gFdhb7tP9iLPAtqH6Vd41hB9rIvIX+Vnbim/p4TAT7mFZtxmwZMb8WhMTM4KIz/cOUPDok3uMvMALry635zZ7sFg3RapY5rpMg4jFVHyzZX2OIZkFRJa07/A50ewAnf5zTR5G434Maj6RKB3jOGuZ9Xk9oEHK4IxhlK/eeukWmAIjdOMYzR884C+bHL3UsgE0xnCIpx2bIUG0JZqygNfNEHfaBgZdotwhc+jFMDHCokW9i11xOdIF6jpWLiI5f5Qe+sWn3CEMKHj/QmjmdATp+MRU9CFpQ0cI7ZTa6GLTYmsWuiMVw2rcz735/dOxInrCE/2ZShUd+yUjrFTgcqEL4dQ4E9ws+HdpTMQD8n8dzSLxA9K1LdVPE4xqv0hyPdPUNhszaO55LZRvD9dAH7gcg8thmGCzdW+FkA6EAFbWb4UlWm/Nk
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e6461b5-8443-4166-6cce-08dc0d02ce6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 08:54:48.4013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YXLky5ebgFN2yePo698VoieoAhO5q6Mtp9d9EJQ1AXuXMDLXJhfEFgU9w/HPpMywcQibMU7gLC3338F4PshDU5egbCaf+QTSAwnzhszlQLI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB6453

On Jan 03, 2024 / 17:55, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
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
> ---

Greg, please drop this patch from 6.1-stable for now. Unfortunately, one is=
sue
has got reported [*].

[*] https://lore.kernel.org/platform-driver-x86/CABq1_vjfyp_B-f4LAL6pg394bP=
6nDFyvg110TOLHHb0x4aCPeg@mail.gmail.com/T/#u
