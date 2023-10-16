Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020003.outbound.protection.outlook.com [52.101.56.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7DE4286BC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="f2MLs0M9"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=msU9r8VAuXwctH83fP3F9/nUdRKO7+vR0zvEs35YXMhZWJwds+Umdz+q2Z/0+lCZvJRK5L11ueCnRnxtW8jLu/Q+dcCJJUXfKDYdKxLnBsFDNwXEXaK0ybPEfgdMFpm+Hq0DgOI+wAjpU01mI542A1sopXzCJkoyO4uUTrlSvSYbyl2vqextae/CnCU215Y1VQ3hmLsV3u6ioMRl/7rwPqgLKlm6XFDjBR3XpKJSVNY0vL14RePAq8BARZx9CDgZed2RkDpfV8fjIjPfu1WX9ODq0mI4p2QYIdcXGcpBbFwuwYKvhUeulLvKR5O2sXgRZ9V70+KO4QXhXWcbRI3etw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wPf/+hbrA2FgDbi2nLIySQDIVrxGi+npuhMcmrWmyjg=;
 b=VjvcVfme/dRH5xr1upHpoTaDDWSx/NnLy6Sjhw43W+l265bzjxrczwIVf9zeYKu3c95EZUqL3ecAXdFmW8b4BBEPbzLgeToFMsdUv0FQrCbN2/fUuGlV+1OJoDwoWVW31EE2T/umMXlCtC9ycMP9vnHwMdrokB7HhuhKB9ofZfpj3ZBcKUYq0HrvRPHtWOh3nYXUZU8bL3DEIytdX+wYwjr6ozA3dhW/JhfEaVKCebNG+U4/kR/Y56HvCaDtsXqllbYvQoKyT/oONHLVzWjchbNVSxLoKN8wYXQ0HU9JHZxP0jJGurs1HFiumGZCkznxZ6n8Rvr8Hv/RLXCa1U+DXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPf/+hbrA2FgDbi2nLIySQDIVrxGi+npuhMcmrWmyjg=;
 b=f2MLs0M98jjeHU+66sieFxoYqcI9xsp0rSvbIajZo1Ku3cEON4IcAbohgXvlOd5kRxFcpJG80jESMJ9znv8suwZZqin6vDTuf6P/iVWmlPpGaZgmadOpS7DVpbrPfH4q/0wunXBmwVXWfBZO1kC9BAZopVpGETy9IySMH+DdEas=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by SA1PR21MB2049.namprd21.prod.outlook.com (2603:10b6:806:1b4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.2; Mon, 16 Oct
 2023 15:35:28 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::36cd:bd05:8d58:e8f0]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::36cd:bd05:8d58:e8f0%4]) with mapi id 15.20.6933.003; Mon, 16 Oct 2023
 15:35:27 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, Simon Horman
	<horms@kernel.org>, Shradha Gupta <shradhagupta@linux.microsoft.com>, Paolo
 Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
Thread-Topic: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
Thread-Index: AQHaAA4APWTc7iWb/EKRsUrvDwZfW7BMezBQgAAD0QCAAAz5sA==
Date: Mon, 16 Oct 2023 15:35:27 +0000
Message-ID:
 <PH7PR21MB311624F90B8FC50D05200712CAD7A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <20231016084000.050926073@linuxfoundation.org>
 <20231016084000.092429858@linuxfoundation.org>
 <PH7PR21MB31164DEC6C6E7FBBC7CAE008CAD7A@PH7PR21MB3116.namprd21.prod.outlook.com>
 <2023101613-verbalize-runaround-f67f@gregkh>
In-Reply-To: <2023101613-verbalize-runaround-f67f@gregkh>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=60eb988a-e530-4c02-9b90-0c1a6e92aca6;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-10-16T15:32:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|SA1PR21MB2049:EE_
x-ms-office365-filtering-correlation-id: f4466429-8ed8-4955-30f4-08dbce5d85fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 pZsbv6WNDJZvrDeCbmxujvJLMmtWhtiTfPaw76WTBGF3LEmG/HKM/A56tsekbvwedURu8Izxnt1CzCsa6jbYkVK/mBuk+3h3a1/0dqRrDlpweCU37bB2g9hiiKwhKI5ua2VzV3pftnqEhnAoiJIyjWXXhrwCE71PZn7fRSanlVCZNMg3yZT8uAe5lGM9031LEf6DNEGVA7h/6YP0o/PbE0MRIgfsFT7Eqp3obOz0gDdFL2CN8YckrDQzvSvEnA06SSojPTEgNqTVzMRKx7orK2J182zsTysabeDZye6Nr7NJNUow7/VGzTnWy+ugLcXTfTD8cFCkpCNlZ+nH2zDw3GVmG0Xu/xJdsIQakj/dIsA9oHqxg2AH6c6lhzt7T22+2fZBh3ohwlwaWNyM9cdMVo2BKCD6kAZB7iRtJPcxj1zjBXczh2Qka0BgkEdxH4glyNan309WR1q3TTJp/OBpSg+aBmTEewA1DTO8LSwKOcqRRY7/DjDd8ZNU6lyHA3xeUCfgzita27D9mSE/4lTZ3i9e14lErx9mfCWMRGcE2wdlykWc7OO13unWXH/MEOk9IdN0J7zwAH5TyFClr4H0oGitplaapaVxTSiatMRLNtW9aiN08t2MB6DG3N6jB2xAd+6pdfeWHULfYv00Mnzgxw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(39860400002)(396003)(136003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(966005)(8990500004)(26005)(6506007)(53546011)(7696005)(71200400001)(55016003)(9686003)(478600001)(76116006)(10290500003)(2906002)(38070700005)(41300700001)(86362001)(4326008)(52536014)(83380400001)(5660300002)(8936002)(8676002)(6916009)(82960400001)(122000001)(38100700002)(316002)(82950400001)(54906003)(66446008)(66476007)(64756008)(66556008)(66946007)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?2boi/QhFX7fihX+0ssN+Y89qW4Pt1WTFlAphh6rSU3c380Wec2zHL4HDFp+j?=
 =?us-ascii?Q?8ycO9W9VXbUJyVVjjD3HjFaRuGBC+wLGscWAsEwT6DhmX6OVgpqdGk9FDo1c?=
 =?us-ascii?Q?t3ty4HgelVpVA+a4ZRh1Gazx1G+br/D/SyPqtPgnjjHpWhSB4rQyiMFs0VK9?=
 =?us-ascii?Q?O/X/Nxc0zg/DhFYmVpfix0c1Et8XoY7QyFumS+E7M2Hxd3tcXktr6qWph32m?=
 =?us-ascii?Q?UKETAJSF2UyRG6+9vGRpb0G/QZ7+QSkwhJc7lMoP5E7AawX+Nb9ITLD64Iqf?=
 =?us-ascii?Q?G2Ig18Yz64xe52wwfgrSEkmOU/XVweSQUSd1JMhgIjIR5sabxMMEwB7gKt+r?=
 =?us-ascii?Q?0qJ92sQbptct35asLZrU1cJgWSveQVZZd8FX9ZiVP3+mzcjBs1+hT6VMxWwj?=
 =?us-ascii?Q?zND+AJV4NyuQpiMntSIA+8Ywps41ZfdNI8JzR9tPE5qov/lYVllmyTbt6WRz?=
 =?us-ascii?Q?0PgqR50bzq/omQc7YgkxQdkWbVvccJklpvtDBkehy8E2xqL/xjqRQDj48229?=
 =?us-ascii?Q?IY3glX+p/Mmzo7HiNn+UZgvHDbpp3S3IQWrLTKFZWZEntZ6FUTDpKUOMRpTb?=
 =?us-ascii?Q?1dYkX23QQ9as3E1yw80xPSaRpOyA9jtqafumR+pLQSHnCs5z2txQjXU3O7VO?=
 =?us-ascii?Q?771iKD6eq4f8mHvqxapYqGz/o2SVu277YujRs+HwHMsn4bJ8OP99lVcDyrWW?=
 =?us-ascii?Q?C7PccGc8lNnVehhm8YSYrR3nQ9C4//W4nTClEvIBLD3NZLVoTw7dod1oBHDf?=
 =?us-ascii?Q?wyaQJdJUPx4nsY+M6n5F0XDlPh0sJ2STPq9Y5RRLAYwTaWOERJZfqQdZo7cP?=
 =?us-ascii?Q?jaCIUjjpKvBQStbVqfnVuqsqzjkw9GJE81xpIptMTJrBW3U6ulR+Nqdcj5Wh?=
 =?us-ascii?Q?W45rRQVZQaWdkN19Cz0XskzkVSI4xYZs+oxDJuwdq9EmL5pMq69Vt1h1x2fe?=
 =?us-ascii?Q?DV06EFagGm9lQzCmTaruqlF4jbopJubEB9bhU5fgFMQPHsN33I9+GrvvTc/c?=
 =?us-ascii?Q?CIMbalcmC1UTOij3arE3LX25VuPgPlIKnmQl+02ZPogEXGGFjQb4O+QoBLhP?=
 =?us-ascii?Q?maseOs9/0B2yu6NmKbusDKrdlq1FGoWs9wmoVsXrDIqj9SC3mNPGLBHnX42k?=
 =?us-ascii?Q?FZHclsbig3YO8Q/DK77iHxmSDkzKtWDWXnoKumE2f6Ts8dZAjrIU437Xmr99?=
 =?us-ascii?Q?L5ppgYY+SxDHDb9hE5TM48Jbludg0CvcSAX1fu84dwnbEN3DYn45TapSedVt?=
 =?us-ascii?Q?XE1cLGK344Re2TVnnmiPsbVkBBHoakElT5Ei1Inf/e7jDDb8czutf5hRmcPa?=
 =?us-ascii?Q?Ld+VBV1Vq+i4can25r2+RUL8wS7cc8sf14+hP3rI9IoCeThC0frD30t/Egvh?=
 =?us-ascii?Q?WD0PRmx3RFWT7/+aWzTIH8u3LmYJdbXoMBHIKupHeSoIp3Aq2RIy4HNGPUBZ?=
 =?us-ascii?Q?MCeh+Jk6tgaevK3Yq+MPYPaP3foPTwdDFDd6ltJFKzXsvLpJIX1jR4Ls0auo?=
 =?us-ascii?Q?a28b1Qi+4I6fi6z06DzX8sJscZS72dDrz+fuS5t1z5ROraYN8xtfEbiyiQe7?=
 =?us-ascii?Q?Eknz/Xs8KnHFE/8RIz4UmxxeW7GLDIaHgmy3Iv87?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: f4466429-8ed8-4955-30f4-08dbce5d85fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 15:35:27.7722
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2mLOmimZO8OALkmCiAdPKvvw4qufCh7YeEye6Vmm412pFsLaHEBcpGYkWZ7+FWqHqrKbxSPBlOsFZsxdda2CVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR21MB2049



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, October 16, 2023 10:47 AM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: stable@vger.kernel.org; patches@lists.linux.dev; Simon Horman
> <horms@kernel.org>; Shradha Gupta <shradhagupta@linux.microsoft.com>;
> Paolo Abeni <pabeni@redhat.com>; Sasha Levin <sashal@kernel.org>
> Subject: Re: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
>=20
> On Mon, Oct 16, 2023 at 02:35:15PM +0000, Haiyang Zhang wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Sent: Monday, October 16, 2023 4:40 AM
> > > To: stable@vger.kernel.org
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > > patches@lists.linux.dev; Haiyang Zhang <haiyangz@microsoft.com>;
> Simon
> > > Horman <horms@kernel.org>; Shradha Gupta
> > > <shradhagupta@linux.microsoft.com>; Paolo Abeni
> <pabeni@redhat.com>;
> > > Sasha Levin <sashal@kernel.org>
> > > Subject: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
> > >
> > > 6.1-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Haiyang Zhang <haiyangz@microsoft.com>
> > >
> > > [ Upstream commit b2b000069a4c307b09548dc2243f31f3ca0eac9c ]
> > >
> > > For an unknown TX CQE error type (probably from a newer hardware),
> > > still free the SKB, update the queue tail, etc., otherwise the
> > > accounting will be wrong.
> > >
> > > Also, TX errors can be triggered by injecting corrupted packets, so
> > > replace the WARN_ONCE to ratelimited error logging.
> > >
> > > Cc: stable@vger.kernel.org
> > > Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure
> Network
> > > Adapter (MANA)")
> > > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > > Reviewed-by: Simon Horman <horms@kernel.org>
> > > Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> > > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/net/ethernet/microsoft/mana/mana_en.c | 16 ++++++++++------
> > >  1 file changed, 10 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > index 4f4204432aaa3..23ce26b8295dc 100644
> > > --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> > > @@ -1003,16 +1003,20 @@ static void mana_poll_tx_cq(struct mana_cq
> > > *cq)
> > >  		case CQE_TX_VPORT_IDX_OUT_OF_RANGE:
> > >  		case CQE_TX_VPORT_DISABLED:
> > >  		case CQE_TX_VLAN_TAGGING_VIOLATION:
> > > -			WARN_ONCE(1, "TX: CQE error %d: ignored.\n",
> > > -				  cqe_oob->cqe_hdr.cqe_type);
> > > +			if (net_ratelimit())
> > > +				netdev_err(ndev, "TX: CQE error %d\n",
> > > +					   cqe_oob->cqe_hdr.cqe_type);
> > > +
> > >  			break;
> > >
> > >  		default:
> > > -			/* If the CQE type is unexpected, log an error, assert,
> > > -			 * and go through the error path.
> > > +			/* If the CQE type is unknown, log an error,
> > > +			 * and still free the SKB, update tail, etc.
> > >  			 */
> > > -			WARN_ONCE(1, "TX: Unexpected CQE type %d: HW
> > > BUG?\n",
> > > -				  cqe_oob->cqe_hdr.cqe_type);
> > > +			if (net_ratelimit())
> > > +				netdev_err(ndev, "TX: unknown CQE
> > > type %d\n",
> > > +					   cqe_oob->cqe_hdr.cqe_type);
> > > +
> > >  			return;
> >
> > This should be changed to "break", because we should "still free the SK=
B,
> update
> > the queue tail, etc., otherwise the accounting will be wrong":
>=20
> Is that an issue in Linus's tree, or is this unique to the stable
> backport?

It's just a stable backporting issue.

Linus's tree is fine:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3Db2b000069a4c307b09548dc2243f31f3ca0eac9c

Thanks,
- Haiyang

