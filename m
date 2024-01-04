Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF28921366
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 12:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jH0IwWR3";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="fMRsB0/l"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1704370662; x=1735906662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FF/F5FZSwdOhz4EGi8YBp/V4CzBaVkzFnzsbShTiY00=;
  b=jH0IwWR399/E9ABkdPXVBA4k8q5f5Y9tiTDFz2jcAvb73jmu3kXDwx3e
   ustmKRgKqZG/zNSCbcTVxyGW+6RsDjmhIbX6jXQgRDqqgMg5+lmi1q7om
   K9wZyW+nkorq2lYWggIkIsgcKkPgGKwrtYcbkQPyzI8mMTEALyad52CcU
   3DDo+P2FK+bc5JeDegdabXHVO2r+61IlmthOuHhm/lj0y2cXLGxTqJ1Pz
   4S5MVJHICMMT+RubTVmTigqqycMarGkbRXBTL9BH5amLLMTsTQnkRIaKj
   cjVEQNHTFL/H9wFuXNmbuBOf9JB0TiQ3hffoPwqmcXngw0qYsNMrxwuNn
   w==;
X-CSE-ConnectionGUID: mI9e4SPmShqKIqzYGZ6CAQ==
X-CSE-MsgGUID: 9hqqMc/VS2C2G7pqLQBklQ==
X-IronPort-AV: E=Sophos;i="6.04,330,1695657600"; 
   d="scan'208";a="6254017"
Received: from mail-bn8nam11lp2168.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.168])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2024 20:17:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlqfRbbUNX8FJCnXbOrqFuf+rH9o/6CpWWwdL2Oed5qth+YmxzW5CATo2ODBvP+ANWAh24SXHJv92PSFFG4uG6Uk3CpfymsI/B97eAa6SLH0jeG+3WlTuQ0Mi5b+8k6f/GAYdxXiDKFbdgAxVnUZKDvvAPW6UnE9bdzjJTaV9bs+kkB3fmcaXh0HHQkxKqJh/zNBv4k7ADdgUxRetgOQu7GIlf3TrzpJRTe4CV2n0ju4/5+IoK/U0KjWpzBPUWKJ3GMLfOsuQzgrJWbsnbSF6EPoXs7meOLln83/7hzIPs8DvRsH+yS5dOWkZrjDBdCN6YWCdfROntPOcBnu3k94iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hPDy6DdKZ0HVVB9PDxKv74KZ20QjNn+E+eSOkqOJYR8=;
 b=XOCDrRdhnZ/D/GXNj0Ir1BIhuOaAl7iFN3Yb28eETLY9JQcYCLA2NTAO0BFErKbkFCUCixHNp0WFzUwdHSaD+DG13IIcSYwh18S9gmDlTaYV6pH13S2tmls93UX4g9ZmpZVVr1A1tCeIDV15kZ3Xb/KT77JmfOQ+z9t3l4uCTI1f9K/RtwHCpe/VuRcLtSLTp6K9U332XNrDe1mQjv67qU4dJKaQfjqdNLriq/3MDp/ins8tPl6q68B9R1gfyQm/L1k9fVWjWP8f0d5PXqQ36pQ09VRh0v75nreTpNabygmnJFUssP2Hegzrkl28qlP3B36Nzf8FbLoEJL7s+tdoog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hPDy6DdKZ0HVVB9PDxKv74KZ20QjNn+E+eSOkqOJYR8=;
 b=fMRsB0/lNdcXs81e9pyGArg65pfCarsnakwZAd77BKqtskLSkSPXLYVxVGEFq4RyxOljhPUN5ADixehuiZBmZuox1Aar8dx3hRDn8mgcXLK8DcvfNbl3oozJvatMVqkciDH/Zb9BNaP1DlSP0ugPnw0WeQjzwZAQYWLPF8pbIQU=
Received: from DM8PR04MB8037.namprd04.prod.outlook.com (2603:10b6:8:f::6) by
 BN8PR04MB6387.namprd04.prod.outlook.com (2603:10b6:408:d7::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7159.13; Thu, 4 Jan 2024 12:17:38 +0000
Received: from DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4]) by DM8PR04MB8037.namprd04.prod.outlook.com
 ([fe80::81a9:5f87:e955:16b4%3]) with mapi id 15.20.7159.015; Thu, 4 Jan 2024
 12:17:37 +0000
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
Thread-Index: AQHaPmZ5dT+u7aMqMU21DVnXSPiX77DJWomAgAABIICAAAOXAIAAAoiAgAAxawA=
Date: Thu, 4 Jan 2024 12:17:37 +0000
Message-ID: <xxv4w35xbjwrp6bccnkkmrpnmlgfa4zcainttybhnobsgllz7v@jkhvuaoqcznj>
References: <20240103164856.169912722@linuxfoundation.org>
 <20240103164909.026702193@linuxfoundation.org>
 <ikeipirtlgca6durdso7md6khlyd5wwh4wl2jzlxkqr2utu4p4@ou2wcovon7jt>
 <2024010401-shell-easiness-47c9@gregkh>
 <djjzvybh5z5q5ojn3isltl6g32gpvhcilzfr3rznb5hlijjavm@z3itpol7wec7>
 <2024010438-myth-resupply-7a83@gregkh>
In-Reply-To: <2024010438-myth-resupply-7a83@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR04MB8037:EE_|BN8PR04MB6387:EE_
x-ms-office365-filtering-correlation-id: e2e98f67-8442-4503-6c1d-08dc0d1f23d1
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 QFnDJcyuMj7JG1Tcd4ORJnq3bZYtEzOXd8tlrSR2srEyzY50a+ZxecUT6u7AyGvUuhTblFsNd0fdhhSwPXIT0o39I/iF1Bf1sCV/l0gxmzyk2/bFSqAjq9R+6gmTCsWhQLO7TRGk+1RumcQrUd2LuBGEsVuvvaTtkCe7wfwoIEbQMr6az/bIuaJ0Km/R8IVbcxpZ5XIg7jL2bNmaDHdgpwF7f/kdp/aDjLefNK4RWtTJM4jRfD/p6YDjUTLsGmfvW6bj89cSp06JkCfSFzo0DQCVfmstsHEr59sI7giuCC0XwiCb3e+u+DxawPZA8E424qHI1RO4N1PcetFT3pPnkIqp6GMiM4nwo/Z6/ENgSu30LGi74EVbNUx54Cw9d7FM7U3P1J0dYxxUaGYAfpqgDnw+tGIKbFnE56smWR5QWKqAMW2NK30Y365Fne5SuQB2rUPkVDMhPit482eev58v7CZmUCtq6CvLXPYxZD1kFvCR9WOLELoyT1a4nh0ieAw1XkdkEYxSJAYKJr0fVSk46J99SK7k5hF8K+V0HGu+bsPg57rYsv2aUyUk8wywEyaBYaRJKSWbgTsDHhL9FwB2hUp8936dNA/CbFkFyv7HR2TAlrvLorK1addLoYZe08Sh
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR04MB8037.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(376002)(366004)(39860400002)(346002)(396003)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(26005)(41300700001)(5660300002)(6486002)(33716001)(86362001)(38070700009)(558084003)(91956017)(6916009)(966005)(2906002)(66946007)(478600001)(76116006)(316002)(44832011)(64756008)(66446008)(66556008)(8676002)(54906003)(8936002)(6512007)(6506007)(9686003)(66476007)(4326008)(38100700002)(71200400001)(122000001)(82960400001)(27256008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?aXcQMcDW1+0IT7njTHZKeqeDfpL2Bivo5Y3OLVz/kFfvW9oKQrnz2qZQld?=
 =?iso-8859-1?Q?SQlI4h1hTghcyRBSetncN+lH5TJZ/HMFai7yrX9ACQiMWyMnKCiT1btnrJ?=
 =?iso-8859-1?Q?S1MZRggC09ceYwUCiAY1OMU20/1ZhSsC047bhM4rod1dLkfOp1l685SN43?=
 =?iso-8859-1?Q?8kroYs8DsDznymhOObXXx4C4tUl71bw7brEEMlp5XSJBFQdwrx4pAxXlML?=
 =?iso-8859-1?Q?ZxEO8RDubfzSxyAA6g9DwqoUPfUS6MUC+0/4bVFW4PMOVVwXTujg2QuPdd?=
 =?iso-8859-1?Q?mN3FOfIcsvaKofKUdHgHGG8QPibjd91jX1aYyEtfvVB4cO1XyuHgZ7Wgkb?=
 =?iso-8859-1?Q?VEoPOxSEVbZ47WrBka7hlD6EL10h3iImzaSNTYX4BKgxJm1mLn6V1GQRZY?=
 =?iso-8859-1?Q?JyHtcpYTgYQmAjDcy5TyyCjOl4GnlwRaSDZm18UBg85Ga00dLZAJRrMEmj?=
 =?iso-8859-1?Q?BVfSJs2lItIkSjJauRNjnCs/t5ie6aCMbAKmKIPYnOgqabIJPZwSA3m4l1?=
 =?iso-8859-1?Q?VIduiKi8KlYhtWBxGQKp3EMZocbctxuonddLRUtXWt3F/AeYTGZJ4QUp4X?=
 =?iso-8859-1?Q?Mi/U3AH0brCGrOFuGMjVrX/nzRszioaLJwfBDFaoSZzyjaz6Rpt3AsC1nz?=
 =?iso-8859-1?Q?D46N9F6JAu5nqa30Nfm9sYuMpIQ+I8jeeuhIw5eWrtQ2sSLhu6LtWCjRhR?=
 =?iso-8859-1?Q?RyYwRgXBrK10BsBMT5Z/yJnpW0BQfYAMWFkP1gryGAXD0MljdztH2Ro2rU?=
 =?iso-8859-1?Q?P+O7fPw6Ni52L5lRisNr+rSCbaVcWLsvBWz38m68iC8Td66hdAR1MoKbb+?=
 =?iso-8859-1?Q?8PBzQ+T+3jjgjfbRKrZwiaLWDk9IGSWgyXAvKYrjo18SWHRUuIf00Z3cPa?=
 =?iso-8859-1?Q?9r31YZ417VbgcAELVqZoNSSedcwy1Fgydk5opTiGTTqfPAF21EjV4jH4S/?=
 =?iso-8859-1?Q?JHZmV8g5g07kgv0uJSYyNPq7lzn3NmXlg04QaRgwUwwX44YwGhPfRyXj/m?=
 =?iso-8859-1?Q?GvSbvSS/Tj3QydWUSAsGiB23FdvFzoqDfu9Qbp3maMUPsu/Zc9fE9TxIZl?=
 =?iso-8859-1?Q?F2hCxCpLhu3eKfQCIT0fsa6legGBxm2XIdIq5ZrJCqFF3yqXCb5RjE1nlV?=
 =?iso-8859-1?Q?rEjytqJ9Ro+HUlgurysvAcZZzJTauF+889eHz+Xm577Jyj8lFLXnvOL3bx?=
 =?iso-8859-1?Q?0ne4vkzaQ2U7YQdaqx034Wo/sVzl75nSw35fM17KnDB6AKXW6hGWTmgZ1e?=
 =?iso-8859-1?Q?dCrJBOlS2OXZ8yyAOHxgequT/hZLdBQJ/JbFy5VDOH+CEuUROsWdSs+pMt?=
 =?iso-8859-1?Q?djl1jQhjwmkJyW7WH5khttZGtJj/u9Kg6C6bdN8klTlQhuIdb/eBsjraQm?=
 =?iso-8859-1?Q?j6hnPR8xMjprolimZsQuiEiiqbd6kFlGJz4wzYpXg2hgHX/bWgCwWo0/Hz?=
 =?iso-8859-1?Q?wzS9DuYjyiJbscSM6BW1FSkuQAr7B1SCOSofCg4oS1f6ZzJYh2yDz3ZLUj?=
 =?iso-8859-1?Q?YafXU90x+x27vJZ2oX3cJMgdV3VMio8pkV92+pkrp9+95DcB9zBFZPEN4z?=
 =?iso-8859-1?Q?yhYO1hmr8KwrheQFxPNmJ+V8eoAeo+MEqvMZV5WpcsqE03Ganl/WQlLN6V?=
 =?iso-8859-1?Q?s6W+uckAo2YccWW/VaBPcBdfCGWQHd2nxuRlsCFCOMBUsK8omAMJFRgtb6?=
 =?iso-8859-1?Q?KwebI4OAIwcQbqeHI+8=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F1FF6D306B3538468F046B7806DCEFCC@namprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4wPoTfvexxVL0M/z8fKHDGH5mKhVr4wnl8+cBlKjMrscIyEtClvYm4dRaVL/1EqBzfALIRrEJohE/ihdqqaEPrg4DyJDY04WtQXb6iFhBHOcUlI6N3qx0gcU83DcGDFdTr1jvhBPK/yI5sHSRmJvePlMmwFIkklOLSls2sljsQQCQMafcW9tod5U2SEqzo+anDsgPVTpukKHjAFvMtRHZJOtSancRlXYDxneXM+KnW9zl8fVdPEcYI8i8nCjSoGP6fkN2qmLhazYvYdAIVN27ozg0yCN75tnJOmr2BG8nth3pp+DK40jAyMDMd1ZsvkXI+LUz/AcNbDxd9hcflviDvoJn0B4zpkoWbxAZa3PgcKJA0ICtpbnLB4xdCWMdHYbtXAbWCwFn+7pZUJKHcIezbVHlqYkuHjKIUZuEu7mD4aN9E+CGxs/tZ2aUCeOJ37lqU+2jE70kyMd1WNPr+47ZT/GHSAZXr8MJKIq6f+ez0fY4qgGkrTwoe7sdcbx/+q0yAO/NCvb9fEnOx6Td8eflbvsscSNLpdrM2EleQg/WoYy5v8UTsi/lo3AMKRwfGHmdt5VYSGIiugnXuPuHhrliOlJrzZrRBkSy19LbqOF3RPADEp7Hg14tw5iDra0y5Yf
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR04MB8037.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2e98f67-8442-4503-6c1d-08dc0d1f23d1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jan 2024 12:17:37.5783
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gQfhXsMUYqcEKcqDkyTrTTHPxvyjYXW0qY9U0MMC1uQeJ7O+MM5TqfuB5nxIjHymhUWq8IVJPAA7on8RoE5CvnqEgAQhPNitZrKrevn+L94=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR04MB6387

On Jan 04, 2024 / 10:20, Greg Kroah-Hartman wrote:
...
> Please submit the revert and then we can apply that here as well, that's
> easier to track properly.

I see, have submitted it:

  https://lore.kernel.org/platform-driver-x86/20240104114050.3142690-1-shin=
ichiro.kawasaki@wdc.com/=
