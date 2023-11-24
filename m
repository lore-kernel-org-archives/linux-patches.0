Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA2D4416;
	Fri, 24 Nov 2023 06:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gM8+CwfD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700808549; x=1732344549;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WlrNT77f08xi71ilPxNx9roqM06EKAO59Jld8Tizvcs=;
  b=gM8+CwfDza37bdYorKC7AQDNKGt0rTkswJJutF7Sltv15PySML0pJmPg
   R8lJoWzkkA3SGcVda3lc4yNquwbK1S5wvmONU8tKTcJyWKSbmfkdOeyvQ
   DxMuMCY542dBlCXTqCfdEd5qI1YboxHsEDpbOz2fQ/x/TrCBpDUzRA0/a
   RKleizNMO4XK/CB8Kjwugmx105ohP4a2Hes286Z5WOiYwEcPW6VyqSIGv
   bM7RWZMR/sk1s5cfTPZ4rNYVHhpAB4BSyaWU43rH15IKyeT6K4DQO8PcU
   KCQiZUjzq3COWpRrf9UQWFiQDgTaKx98juVCzXWvOa1iJGAg2AKDThNTG
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="456717522"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="456717522"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2023 22:49:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10902"; a="940834856"
X-IronPort-AV: E=Sophos;i="6.04,223,1695711600"; 
   d="scan'208";a="940834856"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Nov 2023 22:49:08 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Thu, 23 Nov 2023 22:49:08 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Thu, 23 Nov 2023 22:49:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Thu, 23 Nov 2023 22:49:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VnlrMKTf8CvA4W99L0dtaweDRzxcxSzXi0if0EcUIPkmNgCiXOs8SpagCJUCK8uvz6VluICskdveA5F3lE/nPw9QRZE3g52iO2rDwAKs/S1DSmER0tr2O4R19KaqfgvpoBlnSAIhH4Rmq9cHdIw6iG9ekWekC4I1bVND9Ds5nLshs6X9qadVbzX8Fm3vjJdBOUpyw2fgmOdaeQLNtKvflGhWNBtQ22k+s8SJkcZwIe86JTy+pvNcZxHDmEs82PmI59/7jAE348YD/guOgNmJd3GaU88/m7rosdQmRyeDz5D7/lISMOvH0JvUh9TvAR/KGqdlfS83/0+MkisN7wq4zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PQ2cyi/RBTjmV6mpQbEBbduRnzMSV9zqbJKh0ZMTAwY=;
 b=PDbcZGp0/oacyMNyYzpCdHlq983g1svWuE4H2jDbhOMmc4niaLjWfIFEP0gQtw6CUGlxo29GI81Krz1EDFIzzcJO+P9ENOM6/AY+zW+6q8EwKyQ7SgIT6X6PMUFmyy0JuyBELRlh1dO57ValYQNhJTa6vLDjKAp/uSZt/THy7H4bUf0GMFvwiqX6PkXoCLqlm9fHrK9SKOxLcF6lr6i7149L1yENhDmDLgnAvdYURKX0rPYT59HHHh8w2/vzLYAZRB1AyewGMH0Hf771turkYkSHtOEsntXU+P8xrxZfsc2skxQGLqp10VFaCV1qOnpcDlrpxT0NE1vpw+IcWUZZ7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS7PR11MB7805.namprd11.prod.outlook.com (2603:10b6:8:ea::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.19; Fri, 24 Nov
 2023 06:49:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7025.021; Fri, 24 Nov 2023
 06:49:00 +0000
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
Subject: RE: [PATCH rc v2 2/2] iommufd: Do not UAF during iommufd_put_object()
Thread-Topic: [PATCH rc v2 2/2] iommufd: Do not UAF during
 iommufd_put_object()
Thread-Index: AQHaHUW3Ok4tHNXWeUy+EXR6vsomLrCJAo8A
Date: Fri, 24 Nov 2023 06:48:59 +0000
Message-ID: <BN9PR11MB5276FE18B63A22DB64EBD8098CB8A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <2-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <2-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS7PR11MB7805:EE_
x-ms-office365-filtering-correlation-id: d8e23089-6dcc-4391-b023-08dbecb96fc6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6YY399/zaylXQ14KHlayu7rzrlHAftnvJ1OeuGN2VqlwYm1t/HscACpf06XUdDlrb6bqtOzltfJnCgtmELvxRMfsnSbN8jin7JYgZfp/f3vDzNPO9HFrCC+7skYvY0yBpSSJrpLM7Gb5uAoLN5R27wqHQE2ULWr7gQu48tZs4jkeoLezQHuIj9AIZ8GEwl3BzYs2JVdVrNrRdP2LrAB3mKvZNsSJiF7MvyPyX7xmRhg0a/rmBM4WWztxdRYFuGXrd2RzlmhNt4zhOAxNmluhDWGyjElv7IvN5G70QhT3RBoAmciSppVtTxFLA3qrFc67IDiuPaNX1yg9dExplxT8T+JBDBpHalL20sauzZyr1/eRALD1SLS8ffLE0unTRFe7SCQpBVZROlQ8+CqBE5MLsESboZ42fLcFt+UFh/Olqo/bhnTW/HGVmuQHLOpo5fzdHbJBxvaHiIEhIhskWTY9Um7+G9K4wvCEjicLIsoXyKOzjY9XhsRh9Ia8EGmw9xS5Ents0sNWemy3v1e9+ifYF+Jwt2250wfjm+Wv7Gc6130g9+3dWoHINP8hsWkRz0KvgymsljF5z7lCPJYurUGElHoJ9O+UrpVDiW2Ge4ku31LcO8N8N5Le/ma9EEfDowrli/lhlNSeYG7V1YOXx6ryItF+loQSfNN6imYKPlayde0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(136003)(366004)(39860400002)(346002)(376002)(230273577357003)(230173577357003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(41300700001)(2906002)(5660300002)(55016003)(52536014)(8936002)(66556008)(4326008)(8676002)(54906003)(64756008)(316002)(66476007)(66446008)(76116006)(66946007)(86362001)(33656002)(122000001)(478600001)(82960400001)(38100700002)(71200400001)(110136005)(7696005)(9686003)(6506007)(38070700009)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pSIflTuuv0YKxZZ2y6pRnyk2oTecjl4VhLjKOxNYxm/luu3cdIT0Ez2oXxGL?=
 =?us-ascii?Q?EC/S7WLuuMc3FMou95wqB6r0hG8RZw5JfdzcLiQTwRHJqzf3xiMJHmQ7WitT?=
 =?us-ascii?Q?YvX28ku33GTJQpgbeg4j76F2pafG2em5VJG1rDcYMQxSlySjNIBvHM+3BjYt?=
 =?us-ascii?Q?uvgiRc+MLqDjk+5bGucsQm/baaQLAUa/D5j61gpPv1Wrom2gSxwfMH8PhE3P?=
 =?us-ascii?Q?hO0grRHoXmppNedtjJV+489giIaK5/pgVVnMPpHTrl9DTpQVZKyAdNzmvoyY?=
 =?us-ascii?Q?ZtO+UgOMsb4GW7WAK06J1+PAvctFso2XV3RPyfly++5pRmnk+BZTfoTJmZ3R?=
 =?us-ascii?Q?4ZzRKJ5323o1qprk+9UKp3bgjwz0+lerqdAbqbyCyVFT2d9tVTdEKlW00SyQ?=
 =?us-ascii?Q?BFJY0ymLLfFbFgr2THx555NwCkMKPpvb2Ws8/Xw9ZiFlfXfyQHe2u1KhW3o3?=
 =?us-ascii?Q?I0fnzu8ECRfUr1iW12VGtgTjwkp+J1roeYMRA3O9yG9sJOBg4WnVTXmxldbx?=
 =?us-ascii?Q?8NoOc46mfClFSAtI+BFMPEKCV8gnw1ruaYDXB5R2znopDFxYE+MtikAlG5Bc?=
 =?us-ascii?Q?beAOoikTFV8QzMwxu6+/DvCfTaUa/dTI4FeNOBdmp0xQLT/D0q9+Nwu2xY5F?=
 =?us-ascii?Q?f0gYAtUCfL8wq27+51ujfeCRRu2Y5T2UQmkR8hMt+JXvUoeB4MKeJtwKt3Dx?=
 =?us-ascii?Q?TFQ/als4xBny8qAINVenHSWCU6ZDlYTWMIN4XiY7hm8zNPNHY26gUCdTUJgE?=
 =?us-ascii?Q?rf/0tXQX5IhDL15dgdWEdNCqMO/c33LN2gTYn34caOzB1Wi9uET5RhVpUVao?=
 =?us-ascii?Q?6dfXBrXq3MxudBQ3IzkyWAK+iGRX8kXYCBoLSQQ/mpV1RCZfSTES8tsSdx5L?=
 =?us-ascii?Q?8TW7GTM1ugDCN/B7gxg9tYGbUtHB4YSXs5pBA3gDEb9fqYXyfrrZHJQrZ02B?=
 =?us-ascii?Q?5kp99qih67bp4Ud72vKSSf+3JvLsD7glqw1Ct4gSZcJhGkNJG6gUnbO8l6uE?=
 =?us-ascii?Q?csnzGEpqzQeaZa24NpZv8Q2wpEaWDbsBm+3x0kXJ1eH2i7dKBhE0kdo3tQyz?=
 =?us-ascii?Q?2eY1vAYOTrvJCcO6fGPujA62o43e+x3sM0Ed5kCWheLnLnaNXU8RyEd7djJW?=
 =?us-ascii?Q?WcCDqMzcSgW+gkHsJP967oP2mbVQv30q6F+X0Ki1o/ds+zKubX6DIzfr3Oph?=
 =?us-ascii?Q?QCPmX40uNsfXyNsBjaf7o1ba0hDBYmOAcFAs2S9fuJSsHb3e2cRC9vICGon4?=
 =?us-ascii?Q?PQmTdevSEZ86IOzKSIzpqI+Dqo/vRWHL34/5G2dwf65u6wMyuHqJqzbGG65f?=
 =?us-ascii?Q?cE2yqYPCAf8UjSYVt0aiaXhHrlGdDIkl5qrhxNujkIV/K3YBgoNpN3kk2Nx9?=
 =?us-ascii?Q?kXnOAh9M9ocUO6R1HIPCKrn0RCEW72zBLDcca2kiWo1W8AwFMNWiwGKKK0fy?=
 =?us-ascii?Q?D9Tpzs/KKooZn2VzQF9PmuurDE4XZ030sbIKiDOK+MsJAl5ZEoo9uNl9cDMK?=
 =?us-ascii?Q?OVm/qR6YgGhynYnSUIqq7FWVYRTH67rMAzxbEGIVHl7d1cV2MFKJ6eX4j4Ad?=
 =?us-ascii?Q?67/LUJfr/zRUKSMoTxyOLbtHzFeF8bQ6DoINwXPT?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e23089-6dcc-4391-b023-08dbecb96fc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2023 06:48:59.1328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HT0EdcGRh2lRtOQR8LFZGwjyGUe2Hl6xl9rh2WWqCg92RmD2pN1GY4+FHdSzYLk2IgPXYZ6KFSvu2bw9Ypzokw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7805
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, November 22, 2023 9:13 PM
>=20
>  static inline bool iommufd_lock_obj(struct iommufd_object *obj)
>  {
> -	if (!down_read_trylock(&obj->destroy_rwsem))
> +	if (!refcount_inc_not_zero(&obj->users))
>  		return false;
> -	if (!refcount_inc_not_zero(&obj->users)) {
> -		up_read(&obj->destroy_rwsem);
> +	if (!refcount_inc_not_zero(&obj->shortterm_users)) {
> +		/*
> +		 * If the caller doesn't already have a ref on obj this must be
> +		 * called under the xa_lock. Otherwise the caller is holding a
> +		 * ref on users so this cannot make it zero.
> +		 */
> +		refcount_dec(&obj->users);
>  		return false;

I'm not sure what the comment is explaining. This path can be reached
only if the earlier refcount_inc_not_zero(&obj->users) succeeds and
in that case certainly refcount_dec(&obj->users) cannot make it zero.

> +
> +/*
> + * The caller holds a users refcount and wants to destroy the object. In=
 all
> + * cases the caller no longer has a users reference on obj. At this poin=
t
> + * the xarray will be holding a shortterm_users reference.

iiuc shortterm_users will be held only if the destroy operation fails
otherwise it's meaningless given the object is already freed. It's clearer
to replace "at this point" with "if any error"

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
> +	 */

this is still inconsistent with last comment which says "the caller no long=
er
has a users reference" but here "we did put back the caller's refcount"

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

I forgot why autodomains can tolerate failure to not wait here. Can you
take this chance to add some comment to clarify?

> +int iommufd_object_remove(struct iommufd_ctx *ictx,
> +			  struct iommufd_object *to_destroy, u32 id,
> +			  unsigned int flags)
>  {
>  	struct iommufd_object *obj;
>  	XA_STATE(xas, &ictx->objects, id);
> +	bool zerod_shortterm =3D false;
> +	int ret;
> +
> +	/*
> +	 * The purpose of the shortterm_users is to ensure deterministic
> +	 * destruction of objects used by external drivers and destroyed by
> this
> +	 * function. Any temporary increment of the refcount must
> increment
> +	 * shortterm_users, such as during ioctl execution.
> +	 */
> +	if (flags & REMOVE_WAIT_SHORTTERM) {
> +		ret =3D iommufd_object_dec_wait_shortterm(ictx, to_destroy);

missed a check that to_destroy must be valid when this flag bit is set

> +		if (ret) {
> +			/*
> +			 * We have a bug. Put back the callers reference and
> +			 * defer cleaning this object until close.
> +			 */
> +			refcount_dec(&to_destroy->users);

explain why refcount_dec means 'put back'? also 'put back' is
inconsistent with the earlier comment "In all cases the caller no
longer has a users reference "

