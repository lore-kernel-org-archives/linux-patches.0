Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9072A35AC00;
	Tue, 14 Jul 2026 01:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783991475; cv=fail; b=XwqMhjBohY/Hcyy6ksfpvyBb13CMUtCVNNbNLIUznMCpRl85T2zxXLjWVSBb3+28l3o0A84CQTQDgIYL7pwdvckSAwWEpzw6vqmulx+NG2oLBX3eogv628pNrfzud+5VXyG5xoUxLN7ON6CoNo0G5+9p2TBrjKVcjxiK5lN7FyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783991475; c=relaxed/simple;
	bh=aLg8Db73UpCe2fPyztv5Ymxq6lQZCAvm2lhPVHKC5Kg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SF1gNk2XZJbFYm7geS9WWB2ZFIOzjvFVsPq0wj2GOcaaHKt1k5CCh1eMVIdJh4bgM4k/77Dit1Un/94gkhVwO+sc3nl+QdC4to23R1DO95FsddIBIaAyEs5febav33nZeEnPE/UJP6hUHKwExVrh8CSKuqV430hlKBm4aCQyThU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DdIfHfH0; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DdIfHfH0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783991473; x=1815527473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aLg8Db73UpCe2fPyztv5Ymxq6lQZCAvm2lhPVHKC5Kg=;
  b=DdIfHfH0G5faoxOf9CBLCeqwtbwBjExJkumMZL382v8OdbopPxt++pK0
   9W580MbKdRlTO5AIgR52DKUI5BvPTwKol6NYuCHywvFxlByykFoz43Qcq
   nRLZ1/pe/PxUxYq6jJuSYijmCkKQPRL9A2q9IEyXfBnjV/DOXfbG+XbcM
   saSd6r3HJJNRNYnIWNfqu6i0Qo7FSDUtcOKU36FZJjRdgL8vO2dLM135G
   xxH+JsDdn5icJzER4zRoaJWSuUUOEYgx/qsXut1byraSNrpzCOjPvsX5w
   frKPWfntuJmSf6rS6K6z90HTcjE32MKUjZY5dVTDzhWQL0EbyBgm6r2D5
   A==;
X-CSE-ConnectionGUID: yYV51dQyTPS15I/HkoCaLg==
X-CSE-MsgGUID: rB4hISlAQtmvjzfX8PXpUA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="88506782"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="88506782"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 18:11:12 -0700
X-CSE-ConnectionGUID: 4h6+31unSpiE+O7mkZ490A==
X-CSE-MsgGUID: xnIhkFLcTKewXffrecU5Ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="280124474"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2026 18:11:13 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 18:11:12 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 13 Jul 2026 18:11:12 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.10)
 by edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 13 Jul 2026 18:11:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=J5HWA69evGfOSyuSJGoq8D5v57z2cPGh09KvOw8MsYhargCQJv5Wz04Q0l0HVemueqlgKlHGkBGFr+rBz1fbmEYfCJfDfJVltZxEAXTZquVOYAkSYEdYpd+9DNHU2jtLTBbYjBbJfD4YIhI6CdzSafpZrIoAeclwaFBoa0OF2YOfzaLgZxdlAFlO+Wn1bou4nRiqi0kmTs5hE/drJqhdXUWxgCcF9DqQ/hFVrU9GUpJqRvuZbuwTg9zMnb/z1dfJwVRWhZyoBGbOECYUCPEkGr+8kqvHWHRmH34Yif0bZcDp+ljgrfAvqQrZpHny0xx5/GFYo2wSW3TgEiF2ihNXSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IXxsliC53rAPo1V8uqYPca+D+oY16uhcOOtOPSxA3A=;
 b=EsiKN7e2CokeiGhtbwQi3U4E/xIDrKIJxtN0mE6zWaBAq+olYp8uskb6d7kzJq4JKiXc8e8wP0QBTzQCRZCO9F8EEJ0+/YwalMiyppiLgdh+c0RcpUyOUF3YdYACcHIv9f3LuRvEZ0tP2LTqs8zQiuuYnaaKOfe+5YrCIHdrDA8f79mEP0X+PyceXxM3TCLhGCy5ZySM5bgFwt5q6vHts4GGsSmHRdbY6nx2OpBVwvw9VSHTBK1vIDIRdCyIUD6/Be2zhdMDbDDBW1lxN7wN3y8gRzA6pYqpjbuK26nLf3YJXzKxezsWUhOrttCSnhDL1R2nV514ElwgdrICFpw5Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4835.namprd11.prod.outlook.com (2603:10b6:303:9e::22)
 by MN2PR11MB4759.namprd11.prod.outlook.com (2603:10b6:208:26a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.19; Tue, 14 Jul
 2026 01:11:09 +0000
Received: from CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225]) by CO1PR11MB4835.namprd11.prod.outlook.com
 ([fe80::d051:d948:c209:9225%5]) with mapi id 15.21.0202.018; Tue, 14 Jul 2026
 01:11:09 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "Joerg Roedel (AMD)" <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, Nicolin Chen
	<nicolinc@nvidia.com>, "patches@lists.linux.dev" <patches@lists.linux.dev>,
	Peiyang He <peiyang_he@smail.nju.edu.cn>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: RE: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Thread-Topic: [PATCH] iommufd/selftest: Simplify iommufd_device_remove_vdev()
Thread-Index: AQHdEuyicOWalwUmL0Wyp5x7DAbEBbZsMfYw
Date: Tue, 14 Jul 2026 01:11:09 +0000
Message-ID: <CO1PR11MB4835796C5B8DD7575E5F80908CF92@CO1PR11MB4835.namprd11.prod.outlook.com>
References: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
In-Reply-To: <0-v1-719003d53a5b+38b-iommufd_fault_inj_vdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB4835:EE_|MN2PR11MB4759:EE_
x-ms-office365-filtering-correlation-id: 362a1ed7-5fc1-4ed4-41f4-08dee144c9ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|38070700021|56012099006|11063799006|18002099003|22082099003;
x-microsoft-antispam-message-info: fTZ67tCCVQ2geRuTziK1xMfuH5EOtUBHFEg8WuGQKU6ihAVI8kSKWGz8v3XDDATV+GkweEDBn90a58J8rofy8ja1Eqr4DyJudFQikXi6IH53dAXGmSVt6xtq1+Add13sXXA2tMex85ayfL0koSgBBREbi9MN4BsaIRx2ysHzhBzK4g66ievrESFcV92Ou6wES0/urXVFo2Fl2LWli4AohnTF1oAIj5dGf/PozZ0FdqWdqWM+2YzWNDE+m93E4uPAS20iePbdIFeNanBd2wiB6JJaXVllqaMkR1VNTVzhiPflOUrQ3W6Vbv7oz2lyuXaaHl2rGKg0xJK3biJQ5XDq7yG+1ufGptP7qwv9tdsslPLo+LD/zp1zy5HO/A9mjZqM7qky/55H55khNySgLAoUqGZvlbRZGqch3d3ny7oQL2Vg+1hufC0ICIGPki7rXyHFSWt8MFI3YVXg28nOO+OT9URPx0mCRT83pRZ9U1K7U7zB7MjwvxX2fau4hs0jJtxzDD3LHtyu/XKjGNa8uJjrw8gCJR5SM78wcbpBcdwSI8rg6qeRrGOCrbZ4h4xPdy5h+TJODRtEzKfsaRRrkJNLRfNA6+bky8x84ClXKLqkrXOFgu95P8mzJ2Oay8PE/qnEaqtVvfId/sTtuf5pzVuHiCwsgQkmY9ApKmWZRcae3dYNOWqx/QAoxvkLtTMO0vYVFYJ2rhyCbmPjOuyBNsZ1lxQ2Sxl2w3PWUJBaHEtpoms=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4835.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(38070700021)(56012099006)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nM2v9LHBwtrNIyudk6WJdPGLTfILXwMSJSnlYJzGHC6CBtiiut/iKA25va+w?=
 =?us-ascii?Q?MB4i1rSIk+rrGGBQwPFngmwKC7qeHQ7shToCa8SKU8XGk09lKVlAk9N8JsXa?=
 =?us-ascii?Q?+BSIEpEiuRZzYlLaTg7DWMIMcFoVbgSXcgtvwxNul8G6u13OduAUJmcMjLpr?=
 =?us-ascii?Q?abNEOx0j959/4cbu4SXwJrgWtxP0syuMTJMnp8KKWxeZ4OeCAevhpsDEBxaU?=
 =?us-ascii?Q?+I2Wj2FWUsK+f3XXZ8MREon0LRF4CueHxy84IPgtT8EQ5SSLlM+fvDZrIAxI?=
 =?us-ascii?Q?14pPxgUeuxP3ijKelge/CqYmjvvb/3cbT79J8PjlJB/V3yrXar4Yl5O5PKox?=
 =?us-ascii?Q?WDQlZ6nfSJNhjhU6OI+VnFOKjIzM5Q5Q6PEQ5Nlqhg5D7DAt/eFtX9+Eyx7/?=
 =?us-ascii?Q?/FL8vMmLlQ0SavWJR0eKJFugqZoldj2SY+6yNijjkXKQ/VMF0cZheA2UOSWW?=
 =?us-ascii?Q?XrIiAfFIBcKjE6l6rOJHW61KptWPHoO1HhW/994AZvMLj0aaSWyklhmoeMlW?=
 =?us-ascii?Q?xKNutERbEXhz6d6jM0Ymw/SRKc4ECXtJq1cUdeaIiFkZkWUB6GGMgK8TZPzp?=
 =?us-ascii?Q?tMdRZjpdAlsG604JjMFte3IWPLYWC37e4SEvZ5dLsZtgFIKMc8PnrOLnEPYA?=
 =?us-ascii?Q?ZNTl1pnU2QNs/uUg5fLa3xPXE/M4FCL7coCY6e1pQ6nA3t0rjN2lSCA93sBR?=
 =?us-ascii?Q?YeFXh17SQ5iJ/35s8xEYn+V6ykFxBQcAGLd8r2aHuZ8IF9L/7ly24CBm1tRI?=
 =?us-ascii?Q?3eupawsFIjAP7F+M2H4i92o0EspvO3QF0Qcl4HZfg4yNQLU9cP9rNWyjF02i?=
 =?us-ascii?Q?aeaoVg81FekT6bYC+/Sjz9oaNFkXo0r4D2AIaVqmuYDfsDby7rsaqj1V91RN?=
 =?us-ascii?Q?ijOIc1zXOEIBkWIkozITJOnnl5dDkSfIeJiKbSYtO1pu3COECtO646SUr3Jo?=
 =?us-ascii?Q?BlSJNLpSFmv/ra9On/lyiLUmgp9yrMZ12kJkjG0Llqj6wO6KlcnFTW+gQ+i1?=
 =?us-ascii?Q?b9+f026z4ZNZosqIr3meYQWZtIvAh9APEtyOrySQn9EkwWxLsSo8Ft0cvv2e?=
 =?us-ascii?Q?hRqH+QcQWe5lmfZMhmFFY5ej0NbloEG6ckk5jI2znHYwOY3Gk3s6A5IQHnqM?=
 =?us-ascii?Q?Uf0wiwhfCHMQDYc3SWSKOV/Ur2vkF1Od8csC0tNO+dPKfWYnkV0nIVZ3qu7Y?=
 =?us-ascii?Q?zYiw53FucbY098ezstox7YsIojeGbEEyYTJO5G2QGoCAd3/NsNrgKz4JKqF9?=
 =?us-ascii?Q?JpnFrJzdkYtYKS98SKPrNywXeL64BlXGnAcX9oPmPVKajdrQdOmXpglW0eAJ?=
 =?us-ascii?Q?i3bKuhYu0UkClxdRbc1BRUg+/s56pHjinpY+/uERBiS8T5TeugLcBBhk9iGe?=
 =?us-ascii?Q?vI+Mc5r5n8/qxcAgcptk/bB9lmGwuA/xjr9pEQOrzGMhn8sR4WQ1wlcNCTRz?=
 =?us-ascii?Q?0TTM97vKjclodv5yJL5fUdtLukvSrg8UJtE8Oh3EcB7xwiJPKLQ3sCfUkE/f?=
 =?us-ascii?Q?FcCS3y5xlWeb2DDnFfizKJ7iEev1YZ7I6VwRaAAl9tj8KhrnjpDPH0YhP45K?=
 =?us-ascii?Q?2HGcsF2ORJ+YtikLrOrRa+fpoyvdjUiA70xcprYHwAdf00yA+u5wqFeQOH2P?=
 =?us-ascii?Q?RADBHb2ZYWanK3Or5oeH6wpBy0dCrsIAmuaK31n+ol9VA44y6McjSe6b7xBU?=
 =?us-ascii?Q?w034gw2UiaVnFxYYbvFKXoXvKtYNX3iQnzcD9LzJSLivXC3m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: o9Yn51FIjnFaMzuCQQCx9WAxwFkT4fuumYYJCDIjx8pLd3KnEwZjMVxGMEerB9XBdXye6yU78prr2zHTXiOrIDH27XvMRcDbghkOGqgtXrfcl4OQW+k3MKv0guT4VjYUQ0wLEWKIoZQUBIaHP9y6DKjBYidmjMCTAs2LcwKg7g5dkzmA9E7f7eHFHx7n6V4o/7abi9V5JPDzpil/fZ1OYJZwKy4CQ8wjx8JfkQ2GZLoZFlaVEQoZTY+Olvx3tdsHJxa+8peh2Nfa9PXB1BEwoZH45k0E4qlh0oqt4sx4Y8t9XAkltlbvi/REggFZoyw9b8/DoV3ADTicpotOnXVaaQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4835.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 362a1ed7-5fc1-4ed4-41f4-08dee144c9ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jul 2026 01:11:09.4279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gak2ygMLZQbNWbe7fwGUQRthaZRkEAI/3MJGxb9aMHzG53gnNGDE06PUkvHP13a20Ii+xOIys1UOj97+H/V7OQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4759
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, July 14, 2026 1:25 AM
>=20
> Peiyang reports that this function indirectly includes a fault injection
> point through iommufd_get_object() that was intended to cover the uAPI us=
e
> of object IDs, not in places like this that cannot fail.
>=20
> On deeper inspection this can be written using a dedicated helper to
> obtain a users refcount relying entirely on the xa locking instead of
> going through the whole get/put scheme. The new helper doesn't need the
> fault injection point.

I thought a plain refcount_inc_not_zero() in iommufd_device_remove_vdev()
could work too, but having the new helper check xarray is more defensive.

>=20
> +/*
> + * Increment the users count of an object outside the context of an ioct=
l
> + * that has already locked it. The users refcount cannot be increased un=
less

this is a bit misleading as existing refcount_inc() in iommufd_device_bind(=
)
etc. is also outside the ioctl context but they don't need call this helper=
=20
as the object is already held.

> + * the object is installed in the xarray, otherwise things are racing wi=
th
> + * a parallel destruction.
> + */
> +int iommufd_inc_users(struct iommufd_ctx *ictx, struct iommufd_object
> *obj)

iommufd_try_inc_users()?

> +{
> +	struct iommufd_object *cur;
> +
> +	xa_lock(&ictx->objects);
> +	cur =3D xa_load(&ictx->objects, obj->id);
> +	if (cur =3D=3D obj)
> +		refcount_inc(&obj->users);
> +	xa_unlock(&ictx->objects);
> +	if (cur !=3D obj)
> +		return -EBUSY;
> +	return 0;
> +}
> +

otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
