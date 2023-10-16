Received: from DM5PR00CU002.outbound.protection.outlook.com (mail-centralusazon11021027.outbound.protection.outlook.com [52.101.62.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D7F328B0
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="gXmi6Ust"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WxLCVI8EcvdvFziXWsEptV4ifMIHJ1xOAzfYjZ7uP3tGsPdJTuN+KmlT11aeI52n6frGbz9eImyexo010NKeaPcmU8pQEAKoyW65LCMFx9PiPB799BFMXPVfOIZkuAxUYKh4vJ6gh+kdCoHkU3nnfHp49NY2au2NYYk0gnPrX6u1djClsdypFd/mIJwCNHtA+D5LVYK6+ToMEM386Z/ll4aPTlLOLJk+fiSeiQr4t/tsOSdYIR+vHQ3GuFC0yow53rNrLCobwdC+ZhTuP2HzK1kIVVS8AolpAlE/sRvL8JOdX8/AIURJICtubuOCLVpwORNVsHCMjP5bQ+iOKpS1ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zfa0iWVpYMb4SVIkGwYoLk7/um68qt2x7W0kfbmGOCw=;
 b=FlpNL7ruqMLFpzuB9kzufRCcdwQj/N2PqXazk/iCVZALxpA1xHGnwNfwF+7vx0sGFA4TuTi1gikBphcVIujv4nLO/zL5BAOXP5T8W0dWqtw9443TAeJ6wZd6zOcR6uGeuYlOf/XkG00fvJFlgYYlLUTvXIX/gPka2V5B+oAly832oNIPG31A6Ii4OjuXbD3OUmvgkZIDYuG0fEMAs4Hnw6EA3zJLSMn/X1GhnUwtpV0rrpcnmiZmiud1vpU/YC1fRTO2LY0H4Mz/jY+l0XOCWHo3kCyBElWwHULfK80wyCh+2cnyYNAixD2LnyzN9D0zt7Tnni3LKeEh07ZHmn0V2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfa0iWVpYMb4SVIkGwYoLk7/um68qt2x7W0kfbmGOCw=;
 b=gXmi6UstmVTWCtzCJDYWw8TmFuNhUNn6MY/iu1xBCbUJjqqLB75Ojl6qOqH+LL+fpchjqz+kC+HMhfgQ7mVV+4bLfcR1s39v0d5YMXBwgs0RPyav0pXZ0e1GEQvhKjBKz5i/WEJd3h2vLovP/m7GhG8vd/nxS4VboQRTDSM+xhw=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by LV2PR21MB3276.namprd21.prod.outlook.com (2603:10b6:408:172::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.3; Mon, 16 Oct
 2023 17:55:04 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::36cd:bd05:8d58:e8f0]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::36cd:bd05:8d58:e8f0%4]) with mapi id 15.20.6933.003; Mon, 16 Oct 2023
 17:55:04 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Simon Horman
	<horms@kernel.org>, Shradha Gupta <shradhagupta@linux.microsoft.com>, Paolo
 Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
Thread-Topic: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
Thread-Index: AQHaAA4APWTc7iWb/EKRsUrvDwZfW7BMezBQgAAD0QCAAAz5sIAAGOgAgAAOo9A=
Date: Mon, 16 Oct 2023 17:55:04 +0000
Message-ID:
 <PH7PR21MB3116D9350E9E2AF99CA0C4A8CAD7A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <20231016084000.050926073@linuxfoundation.org>
 <20231016084000.092429858@linuxfoundation.org>
 <PH7PR21MB31164DEC6C6E7FBBC7CAE008CAD7A@PH7PR21MB3116.namprd21.prod.outlook.com>
 <2023101613-verbalize-runaround-f67f@gregkh>
 <PH7PR21MB311624F90B8FC50D05200712CAD7A@PH7PR21MB3116.namprd21.prod.outlook.com>
 <2023101659-bronco-maybe-0dc7@gregkh>
In-Reply-To: <2023101659-bronco-maybe-0dc7@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=950d3532-8d92-4bfb-9eeb-1c17005b9891;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-10-16T17:54:31Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|LV2PR21MB3276:EE_
x-ms-office365-filtering-correlation-id: 6f44dd1a-6bad-4a55-3d97-08dbce7106f2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 oLbb44A6Du3n5Yjc9ghkTi6XJCK455aUNg7pKffnIzp52nNLEGPci7V+Lo/zWXjZIi8AohfqmNmuh240N3W5cBiKBf7JBT1nU7vTPdNBIFqvX8LRtpPkgWxr+QXgP00OTZo6uveJVjjgrC+TMJl517/sgSOm/ChDAmXoMhaS/VInxpr2S0Nypjnq8260jomUW8ohvmAWh+D/jr6AOIa5o0bMz7BcMuygDB0TRmtTcxIdNVen1ABLIV/wdwXK7cs9Ike/IVF4fCwF0GrYqEEhX8ZCETShtZoRQPadRfs5RcCiZIJndlU05M48Ig6KIUtY3WfKLXPqVWmEgQSXrkJ0wi9hnJNh9ZJkpQTqxKXOXHnzWQz9IaDdZv69s/QAyicKsaEROmiwWoPEl2hL1vlA/XAassW0CvOsB2taSIE2rg5213MQEyaWM6veCDIbHeft7L7ReGiX1fa0khkCS0+YwhSFNdWEKH2+BduJ/TapkOfdYT5LwcjC5WeWaG03oz+KOcBb4KdgWXM810wh8AkXbFRHDZeb1nHoHIcCi1rds4bkw6x4xl3awxPFpllcuAfZoGvidMQHGDeAMmhbFuyWwEtHn9aJdme/JfGU0wm+8l+oSL6kQK6ODKZ3ksixeDgvPUkhwHmf2oVZwii+V3RAIg==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(396003)(346002)(136003)(39860400002)(376002)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(55016003)(966005)(82950400001)(122000001)(38070700005)(38100700002)(83380400001)(82960400001)(6506007)(9686003)(71200400001)(26005)(7696005)(8990500004)(76116006)(66946007)(66556008)(66476007)(64756008)(66446008)(54906003)(316002)(478600001)(10290500003)(2906002)(6916009)(53546011)(41300700001)(33656002)(86362001)(8936002)(8676002)(5660300002)(52536014)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Xl2Jdx/DRowljEcfw2sz4yB/K9YNQVfl6YUJxkxbmc4r04eL5fU8ZyEUxEpQ?=
 =?us-ascii?Q?nsg7n7E5jRX5uNqsaFSeIK2xKE3Iy4TFlc1zjrjb3XElLpTzYNGLvZ9iUn+7?=
 =?us-ascii?Q?3q/nAHUbvoaiw7TckxqSWpyXPUSYDqEhWg5z+XNgF7Qxp9HpRd97NpS3cQ5R?=
 =?us-ascii?Q?hqcebAwgVf73wWfUEXxnYGCOw23qg+BangQHwx4UNeEVgsFP5e0z4C5DQzOE?=
 =?us-ascii?Q?/WI5c2AmK/H8xfrfINRnQGGLCPj4Jz73pNi7sC/Lek+Bs4XQ8GFj7ceV8Pf7?=
 =?us-ascii?Q?bRD+O2BYOJimR3B9fXYd+h1LwisAnpqJNt1guPNyIIPQjggPmwGvp9m/LSkc?=
 =?us-ascii?Q?iweRiWnyU6S7PhhWaCKYgXUjhP9/NijAA3ngejn/a6VNwb3y8bepI9I4saq/?=
 =?us-ascii?Q?FOJ5/bCwVxutBU98xDd24u+xpY8Fvg2fVJ43obfL7f4NtbDHw68rq8Fsd2mZ?=
 =?us-ascii?Q?CzvXyaGLnRfFbAAT5mhqzvG8shEba6rDwSjmverheytkTl5CGxNvvUn7epSh?=
 =?us-ascii?Q?7atj3tldS/0SS+8t6+nZwm2USSaPPD9M1MAUT2O0W83c13sx9Vur+iRZ/23/?=
 =?us-ascii?Q?75DvWaeiLWbNfHvlqxNO2dM08QAHPWA4JcM7gkF8KrxIXIIMZh+FTn5Mnwei?=
 =?us-ascii?Q?ZTdPDaqO+vDsU4+HOEOuKpj39ZFY3SqidU++NjAaZwon6V4RgfEK37L7NaU4?=
 =?us-ascii?Q?aBcJNYX5VmTE+mzQ03Nwq0ix81pHIDq/BFm98Tn5tyH5HufuTH539x1TtY+c?=
 =?us-ascii?Q?zjJFIaoEJO5K5ddBQxxGc8unMkzsGuGO1y5+ZgzgNJqsGBdj64l/6zQnSIcY?=
 =?us-ascii?Q?HEs0kmv6Qzq6+IqiYyAy1pXJU+dUvAiueZKzS8QiwfwEF8IhFFl+bIeYpr/L?=
 =?us-ascii?Q?zHu1fVmXWERUPndY3wTXx9/YMS1XME0/Ln7wyDal3XboTlatK8CYtaKifkBV?=
 =?us-ascii?Q?F5JmH5ukdz+eplzmuFE1IVFB2DL0HwzPJMwQIwFxSFHmVOB/7MFQSeHCRlVf?=
 =?us-ascii?Q?jVGS/609/ckhRfR9Xexdw2XPtb7jVUltsuDXTMaqkp1/jjaUtc0wxUBwKfRC?=
 =?us-ascii?Q?vjewZIESLclMpZvQQyBlh2etVTxBLF44yZHQXYdbgsa/DESjLlJMa3dPxS2d?=
 =?us-ascii?Q?oYWLZhX0Zb+po6X4pRFZVJonyma/jUuGLC5ofbr8P8Eh8vozy4QpOU9tp4TC?=
 =?us-ascii?Q?YBfTPhJerRAxD7k1vn0rYfiykguXeeqr0zXSgj82JdzgCuMjxqSnT5k+Ugy7?=
 =?us-ascii?Q?vmO2DhZCFXywxjwmkDz/dIMjzywHdAPUHXL9w/1ki6rqdRTWu3DsM6JXsK8N?=
 =?us-ascii?Q?NoGguIdYMguwIgfisdoZv1AglvDYPiimGD6JO07wZHy0wBpx5b3hvm0LRb7E?=
 =?us-ascii?Q?dQfonnWLWDlaiklbibtcMWO445VI72bShEKM2RzOR4ptJWc3rNp5F6x88CYk?=
 =?us-ascii?Q?Pe9d1BIFJJ5udumW3U8SlDHoZRzGVR+jIIMaBKfy07eh5Xc3xP7h2q/VZ+Rb?=
 =?us-ascii?Q?ppS16hyCc70qwGkUgA639TIoPkU3pvYgvuedZ6xDuLPur0Mnx5LMuAKgRzdH?=
 =?us-ascii?Q?llzJ8R3XGaThXB1PlV+GXh9pMg6kHJjU591y17FA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f44dd1a-6bad-4a55-3d97-08dbce7106f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 17:55:04.5932
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5A0P0FwFpxXgY4NBlr0iUbqwFl6ZRGk3OKchkCZkC26mMFV5HDIkgCN45KBwCvOQeYa/4WLpv8Zy7OD0n4z/Ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB3276



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, October 16, 2023 1:02 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stable@vger.kernel.org; patches@lists.linux.dev; Simon Horman
> <horms@kernel.org>; Shradha Gupta <shradhagupta@linux.microsoft.com>;
> Paolo Abeni <pabeni@redhat.com>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
>
> On Mon, Oct 16, 2023 at 03:35:27PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, October 16, 2023 10:47 AM
> > > To: Haiyang Zhang <haiyangz@microsoft.com>
> > > Cc: stable@vger.kernel.org; patches@lists.linux.dev; Simon Horman
> > > <horms@kernel.org>; Shradha Gupta
> <shradhagupta@linux.microsoft.com>;
> > > Paolo Abeni <pabeni@redhat.com>; Sasha Levin <sashal@kernel.org>
> > > Subject: Re: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
> > >
> > > On Mon, Oct 16, 2023 at 02:35:15PM +0000, Haiyang Zhang wrote:
> > > >
> > > >
> > > > > -----Original Message-----
> > > > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > Sent: Monday, October 16, 2023 4:40 AM
> > > > > To: stable@vger.kernel.org
> > > > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > > > patches@lists.linux.dev; Haiyang Zhang <haiyangz@microsoft.com>;
> > > Simon
> > > > > Horman <horms@kernel.org>; Shradha Gupta
> > > > > <shradhagupta@linux.microsoft.com>; Paolo Abeni
> > > <pabeni@redhat.com>;
> > > > > Sasha Levin <sashal@kernel.org>
> > > > > Subject: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
> > > > >
> > > > > 6.1-stable review patch.  If anyone has any objections, please le=
t me
> know.
> > > > >
> > > > > ------------------
> > > > >
> > > > > From: Haiyang Zhang <haiyangz@microsoft.com>
> > > > >
> > > > > [ Upstream commit b2b000069a4c307b09548dc2243f31f3ca0eac9c ]
> > > > >
> > > > > For an unknown TX CQE error type (probably from a newer hardware)=
,
> > > > > still free the SKB, update the queue tail, etc., otherwise the
> > > > > accounting will be wrong.
> > > > >
> > > > > Also, TX errors can be triggered by injecting corrupted packets, =
so
> > > > > replace the WARN_ONCE to ratelimited error logging.
> > > > >
> > > > > Cc: stable@vger.kernel.org
> > > > > Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure
> > > Network
> > > > > Adapter (MANA)")
> > > > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > > > Reviewed-by: Simon Horman <horms@kernel.org>
> > > > > Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> > > > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > > > ---
> > > > >  drivers/net/ethernet/microsoft/mana/mana_en.c | 16 ++++++++++---
> ---
> > > > >  1 file changed, 10 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > > > b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > > > index 4f4204432aaa3..23ce26b8295dc 100644
> > > > > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > > > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > > > @@ -1003,16 +1003,20 @@ static void mana_poll_tx_cq(struct
> mana_cq
> > > > > *cq)
> > > > >               case CQE_TX_VPORT_IDX_OUT_OF_RANGE:
> > > > >               case CQE_TX_VPORT_DISABLED:
> > > > >               case CQE_TX_VLAN_TAGGING_VIOLATION:
> > > > > -                     WARN_ONCE(1, "TX: CQE error %d: ignored.\n"=
,
> > > > > -                               cqe_oob->cqe_hdr.cqe_type);
> > > > > +                     if (net_ratelimit())
> > > > > +                             netdev_err(ndev, "TX: CQE
> error %d\n",
> > > > > +                                        cqe_oob-
> >cqe_hdr.cqe_type);
> > > > > +
> > > > >                       break;
> > > > >
> > > > >               default:
> > > > > -                     /* If the CQE type is unexpected, log an er=
ror, assert,
> > > > > -                      * and go through the error path.
> > > > > +                     /* If the CQE type is unknown, log an error=
,
> > > > > +                      * and still free the SKB, update tail, etc=
.
> > > > >                        */
> > > > > -                     WARN_ONCE(1, "TX: Unexpected CQE type %d: H=
W
> > > > > BUG?\n",
> > > > > -                               cqe_oob->cqe_hdr.cqe_type);
> > > > > +                     if (net_ratelimit())
> > > > > +                             netdev_err(ndev, "TX: unknown CQE
> > > > > type %d\n",
> > > > > +                                        cqe_oob-
> >cqe_hdr.cqe_type);
> > > > > +
> > > > >                       return;
> > > >
> > > > This should be changed to "break", because we should "still free th=
e SKB,
> > > update
> > > > the queue tail, etc., otherwise the accounting will be wrong":
> > >
> > > Is that an issue in Linus's tree, or is this unique to the stable
> > > backport?
> >
> > It's just a stable backporting issue.
> >
> > Linus's tree is fine:
> >
> https://git.k/
> ernel.org%2Fpub%2Fscm%2Flinux%2Fkernel%2Fgit%2Ftorvalds%2Flinux.git%
> 2Fcommit%2F%3Fid%3Db2b000069a4c307b09548dc2243f31f3ca0eac9c&d
> ata=3D05%7C01%7Chaiyangz%40microsoft.com%7Cea8eae85691b47b1674b0
> 8dbce69a49a%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63
> 8330725380724334%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAw
> MDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7
> C%7C&sdata=3DrOwj5G7r%2BjkBUWImNrdcjqXneCjq4TG3EiLFYfKKGGE%3D&r
> eserved=3D0
>
> Thanks, I've fixed this up now.

Thank you, Greg!

- Haiyang
