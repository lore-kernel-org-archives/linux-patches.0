Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D31168AB;
	Tue, 21 Nov 2023 03:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VyGZxytz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700538629; x=1732074629;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cSdvgS7y1ha6YXinLE8bpeoHH1lO/k/gpLL6AVvDdqw=;
  b=VyGZxytzvewPzsOZLOZdicLfvxYZiklZJvD7LGILFZeTXrE62HJLk3dD
   vNmr2Bp6bkc4zRg0W+FGDVO6J9PkJCQMl8xaSykpFbEO6CTfW57c699p6
   132gJs/LUXxhHQICujuOc15D0Dh5uO8kiH1MrGO03PMnX2qU3y2kKEvU3
   YoziiOTxdWW+sseCvaoL+7RUzMXp+3+Zievdx7VlB7epENXSqUgnN4/TL
   Ec39Dx611vp0/LcvYYyDUGXxN/OLTZx1yB+sZOapd7RJMb1IXSXQVgO3W
   plEp241xI+dnKO90bv9oRX7ojx0WtdJdEXbYVUEldcQgvW8Cw1LuBptUv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="458254161"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="458254161"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 19:50:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="884057452"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="884057452"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2023 19:49:59 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 19:49:59 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 20 Nov 2023 19:49:59 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 20 Nov 2023 19:49:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QgbZIQcpiooDNtcnTA8LBRqfQ1RjkENE0SDVXLQsw63JbYqqcp9laFhMCQC7/Zo7mkgCOv4Hm8hkeNCuxJIKh2YknSZHK3DYMn3eUBQef0ZYmrd81YN59lbLVBcm0+glnG3kE6l/8R8LHiL1S4hqNHXWpd3pF9MI9p8wb88Bm6Q1oPUSQE/R/AxBbnCtTFqsgTpez616zv1SYWy3yWSjLtX2U9GL8XsDcDQadN2+VwWolKoJXgo+QLgzX5tN9dLLuasY4S6YuoPmsBs106IZcXYLTtZj6KtUZ7anoCtAtG5p89shOsjEnMHU9/h636tVqZn5zJXC//Pd5IOqK/5FJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sTxYSeWpl5v29bmRfDv0xQ1gDRTIBb4Z5mGe0MSX9FE=;
 b=Hbjx1WjTvoqSA68tl6lOm6G9YVf4KSqlnfqU7DIRF0vptn3bWIdX7ofxixDfFQgDLo6VcxhuVLO6rkWu5TTXXHgRAuV5a1Jz3A6OmyMnGwOyjGY7TrEt/Fg2STmsivIwq7lGFxyDqV6jt7XptjdioZ6fZgKOEn0MJzk/VAptvncjZTyCmCLge9ifhfDebdz0MbMmGjvbPCX90zwcesxaqyRj51HU23xW3cAphuxD2OB9cwy/JY2AFryFRy4lFhSZulgrq5KrlGNeE3msDC1IatNFXDCx6ZMkHpeaFdBjm4Ild7U91BMP9CBQLHovlzyNqEHx2VZYOcpTqhcc3cu0og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8593.namprd11.prod.outlook.com (2603:10b6:806:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Tue, 21 Nov
 2023 03:49:56 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 03:49:56 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
	"syzbot+7574ebfe589049630608@syzkaller.appspotmail.com"
	<syzbot+7574ebfe589049630608@syzkaller.appspotmail.com>,
	"syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com"
	<syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: RE: [PATCH rc 2/2] iommufd: Do not UAF during iommufd_put_object()
Thread-Topic: [PATCH rc 2/2] iommufd: Do not UAF during iommufd_put_object()
Thread-Index: AQHaHBoPrXYCNjlEgE+quPQR2dHSCLCEIVTw
Date: Tue, 21 Nov 2023 03:49:55 +0000
Message-ID: <BN9PR11MB527644B411E7F9EEC11F49898CBBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
 <2-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <2-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8593:EE_
x-ms-office365-filtering-correlation-id: e11f5c93-cf21-4e7b-8537-08dbea44ecfc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NdshDE+8Twhojk3MxgNgr7I6cwfCgjuDJieRAc401ihS5gcz6g98f3OY0xht+VnA6hfN2lLIaZ3JBUNVK3wqCZu15YZBxcD1je+UrbZlYgxuD71/oMxncNHu7j3kQni27q958paQjefVaAjbeRsYxove0DEeqjRS6LiyVnKyRiGdLwLwgsi3nt0SJjk9XbhMQJmlXWMoW0EwQaocCMqvUbg+P2xomUrAqYJ0RXpirokCR6H3YUSBjh1zvx9NsGthisXFzOVhn7NFZPVkthNhdLp26YmdRJEgi/yGp+XViBL/OSAGxxuNXwEX0iGZ5CAxt4ON+9QaH/ngXcL96X28lzMfSMIuVVgKKt9QcdCpSTMRHwel20rcax86urGG/V8zac3JTkL3+EO5WSYd3PRC2yEKDCvQgeu2EtsWWtoVf9sANCE/E3/ZiMes20BnbkaFVWsLBFbSdq+JT+Px7crOjWvARlhtQLpZq48Hlkhr9Mf3WXG0vQubWOxoAy406SXUcjY9Ih1WLTLr2Ym8LufmJuQ62AQcTH9MaP0A1cyhpl4ooa49OSqh77SzNLt0epmMqj2nHRjKBy20yc/1vLjPYAccdDp04Ga5ibSB8ySJ5M2hEMZMTwVcTfnJIodrVvcy
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(366004)(39860400002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(54906003)(64756008)(66446008)(66476007)(316002)(55016003)(2906002)(5660300002)(41300700001)(8676002)(8936002)(7696005)(71200400001)(478600001)(76116006)(66946007)(110136005)(52536014)(4326008)(38100700002)(9686003)(6506007)(82960400001)(122000001)(66556008)(26005)(33656002)(86362001)(38070700009)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lmnGSzoIH2zpqy38imjsFe5Hprz1gnyALjvkz/1/TLhqYzIaC0wPCG1Lt6fT?=
 =?us-ascii?Q?hO/bEMAjZZEp8tkATNJdMEQ2KSivu9gHWsK+pfT/vyB7eq/fBwkZn8Y38u+A?=
 =?us-ascii?Q?DpK8GxUkMLsaipUDeYpGWwdgocd/89f3H7+LCFACiPjXxDaT3jBpZLxkA6Y6?=
 =?us-ascii?Q?Ff0v5rVYC5g3cB0YIGyRCVHBNKH15ygxiDY5yE1/q/D6nMmuBuyZhxYg/Yj4?=
 =?us-ascii?Q?jEfcTBh2nLxWl+jpPWRqueV0p37fpxMuOT6ABv2JkV3XAfZDbA9T0FZv2RJH?=
 =?us-ascii?Q?kk+diilKH0b0ZdRAO1h8PHHA9Y7yMffjbGRO81gh7U9hn4pn+X217AaeWJ/9?=
 =?us-ascii?Q?VIZgDQ/CgDldFRmVVOF7yXv0eoDb4GQyQRh4dYfoG9j+cUg56OmcdkR/c69J?=
 =?us-ascii?Q?G6GjXnSpTbPTjKxxIuz2Y0aTCIdXqxMpabSCfuyknX5uipgTZIgpXogTl8HX?=
 =?us-ascii?Q?X4QBKVnil1XBZBWU3opQotqvxsy6RkV0kDkMz03aFB0p8J7ejI3TIH6/YqCF?=
 =?us-ascii?Q?4iThHl+lnjG1YGoG5gN57cv8iEyEQMlnd7THmJ6EDJdwGlRwFn8sGKBqp7GO?=
 =?us-ascii?Q?82mA2L168/QumMdIM9QNm5WLFHa9Ty33GG0HzFVgv5OrxYywnDPmZSX4bWKC?=
 =?us-ascii?Q?8EmlRNyW7H7sazA4YHSH2V0wSc3oVQueY6ozf6ZkcAk/K9BW1TTgSeUUT735?=
 =?us-ascii?Q?PFeIOCEwZ2VY+Afx4Wxz4beeMNYBUJf1xkbjPRCjGC+GwVXPs6d/c4PCGgpS?=
 =?us-ascii?Q?tdvysqqwrgmNvbpmt1l/y5eGIptbyYP1DI8ogzCce524EG7PCDS1XF5+0Ojj?=
 =?us-ascii?Q?mXEdI3CjX3erEbOBZ0lYLIvONxGWqKpABvBGsScJjSGjkWMpE7XLvddaquAl?=
 =?us-ascii?Q?+co8frMfbN7M/0/W6nlV9ZO7Y27xHAe2EndHoUAJJhLAJzBKYmQDoRBZJeHj?=
 =?us-ascii?Q?YnzFaiDLmHXdfZOA6Kw2QDxPwuXBg2vxcRO6v6WixvOaBDygNN3tGc/wI4SA?=
 =?us-ascii?Q?pWoPLu9gfitxbcBHkf4FZe+brqpUNeAsLrklfWa+ASYURC7umj2jFUdJwH5b?=
 =?us-ascii?Q?muyTBPEEflT71hc2eO13LJWywSy4zlikj99V2LQiTE9YcLpPHWe5a/hxOTJq?=
 =?us-ascii?Q?VnibXp6+At2DEhVxYmEzpCCzha962Km+oKKzgPkhjCSkav6apUeG7Z5l16Sf?=
 =?us-ascii?Q?TIw2PFEqY/bSDMd0pjnvD3xdpyq079k8Wu1R05vGw8Jdap7TE+NwP8OxvPN6?=
 =?us-ascii?Q?SGJjN0SCF81m9qbBKhtcutCHz0ZpauxnpaK10QAUTUxTHBVfsJNhv3H6Uzq/?=
 =?us-ascii?Q?XZu05lk6eyWwgGRWMWmfIQUfB5fqyM38u38ERCSlZq8MFN/KOF2j6nWgygwq?=
 =?us-ascii?Q?+MuXKEd2VumbtypbZkBaDUQT5xU51MJbgcNVtacq05GuQwV96nfbtbp9M4h+?=
 =?us-ascii?Q?rP8N9H8r6hGJ143dQrRJ0TTS493IFBfhX8dBeUUBUiy2HiERnuaDOvRN6X3b?=
 =?us-ascii?Q?snaR0WRIypRbKiNRwQ3slUwVDVtn1hUzgYYJvBzySgnjzN3lAmQL1oJeS0Ut?=
 =?us-ascii?Q?DHr27bX40wTiFVMWmA1IQqr/xFs6bLhHd0Jz9H3W?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11f5c93-cf21-4e7b-8537-08dbea44ecfc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 03:49:55.7282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tSUvnLDuwsOT2ryXLw6uv8Gt/ILHBkZAYdwIuSU8FXgCQvTskbGMSuaPYZpVxHAsDfffCNfqjdw2NKBITcbWHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8593
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 21, 2023 9:28 AM
> +
> +/*
> + * The caller holds a users refcount and wants to destroy the object. In=
 all
> + * cases the caller no longer has a reference on obj.

It's unclear which refcnt is being talked here given we have two now.

Actually none of them matches this description e.g. if wait shortterm timeo=
uts
then both users and shortterm_users are left intact.

> + */
>  static inline void iommufd_object_destroy_user(struct iommufd_ctx *ictx,
>  					       struct iommufd_object *obj)
>  {
> -	__iommufd_object_destroy_user(ictx, obj, false);
> +	int ret;
> +
> +	ret =3D iommufd_object_remove(ictx, obj, obj->id,
> REMOVE_WAIT_SHORTTERM);
> +
> +	/*
> +	 * If there is a bug and we couldn't destroy the object then we did put
> +	 * back the caller's refcount and will eventually try to free it again
> +	 * during close.

This also needs more clarification. obj->users is not recovered upon error.
only obj->shortterm_users is put back.

> +	 */
> +	WARN_ON(ret);
>  }
> +
> +/*
> + * Used by autodomains to clean up the hwpt object if it was not used
> manually.
> + */
>  static inline void iommufd_object_deref_user(struct iommufd_ctx *ictx,
>  					     struct iommufd_object *obj)
>  {
> -	__iommufd_object_destroy_user(ictx, obj, true);
> +	iommufd_object_remove(ictx, obj, obj->id, 0);

since there is a flag parameter now can we introduce a new flag bit
to represent extra_put? having both obj and obj->id in one invocation
as the hint for extra_put is a bit vague.

