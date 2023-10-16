Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020015.outbound.protection.outlook.com [52.101.61.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E766428E1A
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=microsoft.com header.i=@microsoft.com header.b="D/cxf6qs"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ilqw+VusGKYI1V221fQMiZr7rKVGRc7/UK65jwL7eT5HL9H5O0SDZwHzjPU+Flx/gRt1A81bvQRf8FpeLToa2NBPQBSCHBK3828W961wZmYLpFb9f95VCYtjS8/vESdC/86eJv8RNCW+itkMYDe/cTcdECBDKIen0n4ye1AXWbbZVwJ6IruFdb2x6aK1ceSO6jHEkgketImq46NAn22s2ZOdiSgvm8siS6TEcUtNZCL2yNrceFGcIQUrh8+BPrzmppyoAmjqiubF42fKtRuT5e0Qoq7vCs06EVHwJXgrq20/Rhk1eHkgnQRSg0MeCSHPzbLNfnCJdLxrxoDlZ1tedg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=taE5FbUUs862nC12xIwXYmyTd0idh55PMN43iN/PG9o=;
 b=HVBTv2m8nF4ZygJuP9MBNVGxEvbDAQajfLE22gre9ZAK0WP7B3XWIwQjBXKywIiZEP0f1ScXPbBt8s4S5j1Ml4oDYrpX+9ZF17n7Uwbw9GoFETEtsu3527jBe+PWfEFItUjFRIbQHYURt+1RILDdF3fQz+SCng+9DJd9mYjMSU15CTvNHw1ddWZ9ILrHgtDJLO71ZMk610vEM3ylnXf2v/TwEyX3frg+ju0/JWPqt7nFwSmS7f+lKDUSd3BAbuOljr96YOor75cfINw0YaVSuyi06R82skn+ox3vMxFCgx8PrjNilZASPlUC1uTjfbXaDrpzA/+yXFHf0EZEUHBtfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=taE5FbUUs862nC12xIwXYmyTd0idh55PMN43iN/PG9o=;
 b=D/cxf6qsouwpF6tkvti2dh2ur3XaCGA4sPiATZ/2oJSku3/Wvc2mfwBzY7PoMH1dPxHLePrR89BLkYxSF5LiBkTihuVWHfVjnSvtd3K6D7OZSAJ5hYTx0mZYOEPnrzHB6cJ+ewjXUFEQNgB5ZdkIrSQDYqO4vX15+Q0J+xiq7gM=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by PH7PR21MB3214.namprd21.prod.outlook.com (2603:10b6:510:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.2; Mon, 16 Oct
 2023 14:35:15 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::36cd:bd05:8d58:e8f0]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::36cd:bd05:8d58:e8f0%4]) with mapi id 15.20.6933.003; Mon, 16 Oct 2023
 14:35:15 +0000
From: Haiyang Zhang <haiyangz@microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "stable@vger.kernel.org"
	<stable@vger.kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, Simon Horman
	<horms@kernel.org>, Shradha Gupta <shradhagupta@linux.microsoft.com>, Paolo
 Abeni <pabeni@redhat.com>, Sasha Levin <sashal@kernel.org>
Subject: RE: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
Thread-Topic: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
Thread-Index: AQHaAA4APWTc7iWb/EKRsUrvDwZfW7BMezBQ
Date: Mon, 16 Oct 2023 14:35:15 +0000
Message-ID:
 <PH7PR21MB31164DEC6C6E7FBBC7CAE008CAD7A@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <20231016084000.050926073@linuxfoundation.org>
 <20231016084000.092429858@linuxfoundation.org>
In-Reply-To: <20231016084000.092429858@linuxfoundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=aac67431-27b0-4aef-bfd0-e431e88347f7;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2023-10-16T14:32:53Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|PH7PR21MB3214:EE_
x-ms-office365-filtering-correlation-id: 0dad83e2-0494-4c14-f1e5-08dbce551ced
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 lz/35CGt2CHgUhuZnRrwW/+MLN9IHBbp5G+F4QlFmT9E9HP+1/TiqEabcA0pcirLtqqSO61zI+N5wrG6mPHe/oBjeqYrEDDOBpoqoLzD3e1Qg9zrSDBs4pjol45ofe+tOyG8b9iWr8GSTR2Nd0x8r2BQbBY01fZbUvepkKUBuTOUx5rdTKh/s9SlBg0h5o4AMEjqnKImBJFjvbXz6kZhloNyn4rSNyxjyDoXb75qZ1wpceHLAo3/6JnvA68AoC01S+F/Q5P1vPRoHMMLpBQQNOhMQQxnYAeUBn5yel2VAClcIaL3kQP79a2Wy/ClNv5viKA/lNkL9rkGNbFMJ0HuoerXQAPfK6qnFabI06TKQPhdL0XyzlCD+5Db9NIFyM8bVHTtCwJxZLKHiNWEXK/6w9wUm48YwpmIPM4aAsIfBzpQF+rmGM/Oo/1PAK0vVTnXomiiP9ciGMXsmUrS1JerInnP37kUF6Zt1ADqqnPxrFAdQJlSzQ6QCsRp07IoQ38Wz0I9HyL6Z9zkc0ULq82WDCvX7WvC6X01IVgl4DG0XRvAfPyiaxHoivGMWErLrCaNA5Tqx1K/NLdo7Fw7tDlb68FBXss9IE/yQ6j8PgyZ8DIPzw4ruIbnfWUz56IyDZkfm4Ntj+0NSzkqKTGldi3WdXIk5Dk/iQyPbo8OZTdkWP8=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(366004)(376002)(396003)(136003)(230922051799003)(186009)(1800799009)(64100799003)(451199024)(26005)(7696005)(53546011)(6506007)(9686003)(2906002)(83380400001)(8936002)(8676002)(4326008)(316002)(52536014)(5660300002)(71200400001)(41300700001)(10290500003)(478600001)(66446008)(66556008)(66476007)(66946007)(64756008)(8990500004)(54906003)(110136005)(76116006)(33656002)(38070700005)(86362001)(82950400001)(82960400001)(122000001)(38100700002)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?h3G/Sjtj+6u3j8PHXNUgxE15TalBgt4+qbwhUOO1AkTbr6qisFBNeZgBJ7jL?=
 =?us-ascii?Q?jQetVu5dDDt1XJFZkK+LRoWUWDDyugI3c5iAQGG4vjiDmhc9WHxLguco6vO3?=
 =?us-ascii?Q?9ez5zQrZqT/BiyvWX72d9Zoh8h2M7q+/brtXW6DGieJX9knpHqEOagE7rsei?=
 =?us-ascii?Q?CI59ObAz7UQeGhuGbW61oWG1a9xwrLBfTdQZESuzZ2pfaz1dOc6HyEiRhE8S?=
 =?us-ascii?Q?vhw0DlbqRSuouqffnCTpRCj2z4oSK/SiI6gxXj8zr/3lkdsfaDKN3fe/i5Ys?=
 =?us-ascii?Q?L1G6bvI5PUcSPK5GVcjrb61Q069VNmYs71MkzQQRzwoAeYUZxKafmhr9fZ0M?=
 =?us-ascii?Q?cvId1eDBfQEXKOXGILeCpN08htZa45gOQ5kJXo+2mvsQX6RB55ggZQw/2VbG?=
 =?us-ascii?Q?jENWuEGTOLLQwFfqrvWiBWHnZRny9kVAQeMTLC9krAXxXst+t18JHaEBEIU7?=
 =?us-ascii?Q?+bQ/e+NU9FfvQ9N4rr+LTFDNtK4wDExrrQ4QEUPl5UGqTYUqV3R6DJ1I3Zkv?=
 =?us-ascii?Q?jGk+LzBTm+GAikEEv6GVmSTWn0sOi1ghu1X/062mlx0YnOC5MHIPgX2I9FOO?=
 =?us-ascii?Q?vNkPogDDZYE22/UhmfGXK2S4kKIDBDSIRrHGY5D5EQi7kRGJYLTZhcGZTaX0?=
 =?us-ascii?Q?07xdKjhuTZIYmE4Ahg48yPYMAUJOEkdGTzf+1YYtqlElAErOvH/v2m8qQvTY?=
 =?us-ascii?Q?5obmP/nHlz7/sp4kfZXKHxfnHovLPFeLVji4woie5KWk2vnGD1ztRB5dnRap?=
 =?us-ascii?Q?MbvtMl8YXmo0z1RRtgrqLxMTMemP9J3aBCAvgG4YjZXcfFT84uWPGqHNL7V+?=
 =?us-ascii?Q?WlugkrfmUQ2f2UcfpMO3uVlcIPoeqssiA20MRpBZLtZ85x/Gm0BuFJDs62hh?=
 =?us-ascii?Q?4Zj12IDg//roCcHFtN1CElCBmEAWT3h8h2L66Xj2mlLmLEEfTJt7jsl3GQdV?=
 =?us-ascii?Q?uZHAFc4vGConN+u15vKKQzbsqQgM6tIjJdi/s2iKCbYCNpsGg2zz5tZLX4ro?=
 =?us-ascii?Q?1rQMGpK8OmpjyqStjmsYInHp/WQO9vvXom0wl7oLZMD5OBewW8x/vmlsJPhY?=
 =?us-ascii?Q?6ihUy+LTiRt8FvpMnnqyTLjiVHH5Hnd4QotyJQHnmmqYwNNCwd/WTpXdH+re?=
 =?us-ascii?Q?ASHGx++Xc7dI1N17pTShqy652Tq44oMKstp+NMZLoWFVEjQUToaGJtbbRWES?=
 =?us-ascii?Q?ogQAKncUFEjiihdBzuIWtQ/uQoUmo5XFbr4qtkg/xdzQLLe6W8jFI8MP4j2A?=
 =?us-ascii?Q?a8MxdPZrjv0K8wMHVkLVaLCsPgQz17ksp8B4iYybX9/7oNzJ2PEFRIdvG+Zm?=
 =?us-ascii?Q?RnciJuLKCEJm8lPT6A6e5bVyB6GjgrzU6gjrt6SoXOJZ9aE4PF7TCzdIax2A?=
 =?us-ascii?Q?IBla6hmB3AQp7/UMQJKMQEm+gfja+OS/rwlo/Iv+XZOweyeov8RkJbBvOkps?=
 =?us-ascii?Q?wrLcPaWGANdQXS4jwaGPb9d0JpPjTnGINxvK6q0I7ZTymSaH0JBHiP06u5zN?=
 =?us-ascii?Q?mB0FlYprYGBTDiVzXt+ZHVzDc1t+E9+QkYWPmVIIcs1zz5bVMd8xsunygpB1?=
 =?us-ascii?Q?DwRIguIZcSF/0mDHx8BmO830zub71Huea5LikJHT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dad83e2-0494-4c14-f1e5-08dbce551ced
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2023 14:35:15.5502
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Pims6njdy8f2+0DrhAz9W0i4AX/w6isZbDfyjLOCF0jiM0ytdpfhLt5HsXy4FOVBolE1l/viKNMvYVhis4ylgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR21MB3214



> -----Original Message-----
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Sent: Monday, October 16, 2023 4:40 AM
> To: stable@vger.kernel.org
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> patches@lists.linux.dev; Haiyang Zhang <haiyangz@microsoft.com>; Simon
> Horman <horms@kernel.org>; Shradha Gupta
> <shradhagupta@linux.microsoft.com>; Paolo Abeni <pabeni@redhat.com>;
> Sasha Levin <sashal@kernel.org>
> Subject: [PATCH 6.1 001/131] net: mana: Fix TX CQE error handling
>=20
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> [ Upstream commit b2b000069a4c307b09548dc2243f31f3ca0eac9c ]
>=20
> For an unknown TX CQE error type (probably from a newer hardware),
> still free the SKB, update the queue tail, etc., otherwise the
> accounting will be wrong.
>=20
> Also, TX errors can be triggered by injecting corrupted packets, so
> replace the WARN_ONCE to ratelimited error logging.
>=20
> Cc: stable@vger.kernel.org
> Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network
> Adapter (MANA)")
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/microsoft/mana/mana_en.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c
> b/drivers/net/ethernet/microsoft/mana/mana_en.c
> index 4f4204432aaa3..23ce26b8295dc 100644
> --- a/drivers/net/ethernet/microsoft/mana/mana_en.c
> +++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
> @@ -1003,16 +1003,20 @@ static void mana_poll_tx_cq(struct mana_cq
> *cq)
>  		case CQE_TX_VPORT_IDX_OUT_OF_RANGE:
>  		case CQE_TX_VPORT_DISABLED:
>  		case CQE_TX_VLAN_TAGGING_VIOLATION:
> -			WARN_ONCE(1, "TX: CQE error %d: ignored.\n",
> -				  cqe_oob->cqe_hdr.cqe_type);
> +			if (net_ratelimit())
> +				netdev_err(ndev, "TX: CQE error %d\n",
> +					   cqe_oob->cqe_hdr.cqe_type);
> +
>  			break;
>=20
>  		default:
> -			/* If the CQE type is unexpected, log an error, assert,
> -			 * and go through the error path.
> +			/* If the CQE type is unknown, log an error,
> +			 * and still free the SKB, update tail, etc.
>  			 */
> -			WARN_ONCE(1, "TX: Unexpected CQE type %d: HW
> BUG?\n",
> -				  cqe_oob->cqe_hdr.cqe_type);
> +			if (net_ratelimit())
> +				netdev_err(ndev, "TX: unknown CQE
> type %d\n",
> +					   cqe_oob->cqe_hdr.cqe_type);
> +
>  			return;

This should be changed to "break", because we should "still free the SKB, u=
pdate=20
the queue tail, etc., otherwise the accounting will be wrong":

-			return;
+			break;

Thanks,
- Haiyang
