Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982E189528;
	Fri, 15 Nov 2024 08:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731659244; cv=fail; b=YhePlSZh6GH8F2vAPDIwmoMcOHCE19+buO2fOHUsWjxkRWhTpE0+qxvnckku+ZxkNAYNrn8qJgpS1m0aXH4E5p1lMylVA7lvM9A5YfE7qt+gvuogQ+MO7J3Ik75uBevFI7FebFTb1ZSoWjK3lKlto3WMRJdiTatGEboH8SzV22M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731659244; c=relaxed/simple;
	bh=n/5/pYs/t8T6NiSFjcUcI9LapsE235/eMppp+IFuSCw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ar6W58huQETZoBj5H/qEGyLlUURn0qb5hAmbOC4Nar6UoUxYa723RFh/fQVZzYLgiVF9Jwj1DD1MKgBkTIfNiLz6kVYLtSmysSkOYsEOGLho83mOvvlyBTYVTY5BECk3lewHWGeQ0wqrCGScLkDddmvyrKsuOIc2jLbmFiInqLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i4M9qATz; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i4M9qATz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731659241; x=1763195241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=n/5/pYs/t8T6NiSFjcUcI9LapsE235/eMppp+IFuSCw=;
  b=i4M9qATzkQ5dYh4Tismu9s4Rshth3m6fGJOI2nUzTIp14HQOvxj5TwWm
   f57oUR4n9nR9tvmS2TuYG4mLBfwugR82+0PGOWOp7TZKMPR5dfsLAmsZ0
   1CiOlOswDZf/KMJ5QUR7WO5J+OujA6LVBtt98TeEQ1nzanTY/caFEzbYZ
   jspXEiy2rxPVRzu+L8BvjpQKm0MwE2QuY1dEiYF8k+GQ/kaK9I2yZcZSq
   1n2+skps1tHfixVDJrxaxwUfNh0ZYnJm0h/brATpwyk3noxbwrZ4+GnwQ
   YpIXP+XBI6AF+eB8ZHBb4tf4GXqIPcI9aoZqfgp4veuMZaDXr7wYJ1eiN
   g==;
X-CSE-ConnectionGUID: XHh1DpXBTOSTBvPpLskRAw==
X-CSE-MsgGUID: rqbEeEl4QVyK1M33Q+m1Fw==
X-IronPort-AV: E=McAfee;i="6700,10204,11256"; a="19267385"
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="19267385"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2024 00:27:16 -0800
X-CSE-ConnectionGUID: RxRyCQCGQb+QkBQFjmrkOg==
X-CSE-MsgGUID: Xci9jINFR+i2F9dL9uC54Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,156,1728975600"; 
   d="scan'208";a="119425854"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Nov 2024 00:27:16 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 15 Nov 2024 00:27:15 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 15 Nov 2024 00:27:15 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 15 Nov 2024 00:27:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ht4253YSC0yJK8IO5b6CVS2v5p5HqclUDd05Zdehe26Hs5unufX/HhYQjxPWTpRXq3SlBDBsIW2sgDSUpy9oW1i+/LGTqvB1M6FjDZalca6rxUcTQVt5y1atSxWX9Hr3hAoowDyk56YHYSCCleUTtBslvMEhsjqnoemQkIikRH5kOD9y1DvnBmg0OLAnXg/n3/cU9DKyjcAQ+AMa235TJq2eK6cZgdvJ5Z62N39qwtD4w9SQOtKVIS/4WR8GWzYL96mrLVspF9EP4ghBfmG6M55u3sSEUFPpbnfC0xuOq4myjs/rjbFMw8C/LDZ0ROxENTyAqdvP9blVtAUIOLjTig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIGuCfuRn4V1xBnsu4KaygW+yjCut6U99PnYz7wEtZc=;
 b=sogzlZRjUnh2XLe0z+mkzfIOmp6JuJVdtkH+3o24g12pt9Svx1p82jNkJ0f2++yarx/4nb/+E5rJZBv89HJtHaEHvXAdmcEdrskLfAdmphGvUU44GQd+gv0GdnSPD4A8mm0wl2HrjO9Zr7CuR1qjqpNzAuvC+9MW65ukngXNaD5+5/Q7TYkm6tkC6NQUTVBlj5+6HlLoUqo5oajokyQx1bJjwGNb4wx9rbV2X75Cf+XsFipTOUKKJcDzv7mcXA1myViKf08wVLB/kGfM68lXHEWMlVlWEYkPmjrs4vxusG9IRSgEkgvlzQ8zk1thx78KvcuJRdco9JTClcPbvoj+Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB8100.namprd11.prod.outlook.com (2603:10b6:208:445::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.33; Fri, 15 Nov
 2024 08:27:12 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8158.017; Fri, 15 Nov 2024
 08:27:12 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommu/arm-smmu-v3: Improve uAPI comment for
 IOMMU_HW_INFO_TYPE_ARM_SMMUV3
Thread-Topic: [PATCH] iommu/arm-smmu-v3: Improve uAPI comment for
 IOMMU_HW_INFO_TYPE_ARM_SMMUV3
Thread-Index: AQHbNTP0HhswaalbMkqgtEOdE0PE/7K4ApeQ
Date: Fri, 15 Nov 2024 08:27:12 +0000
Message-ID: <BN9PR11MB527626CD708AAAC3473F7BF98C242@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-191e5e24cec3+3b0-iommufd_smmuv3_hwinf_jgg@nvidia.com>
In-Reply-To: <0-v1-191e5e24cec3+3b0-iommufd_smmuv3_hwinf_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB8100:EE_
x-ms-office365-filtering-correlation-id: a3a13e7d-c9ac-4678-aa81-08dd054f4dec
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?5s77GMP9BAnDOB3D/ozDG+koy/wB7BXP6d80xfI3/uaMTTmvXgJzG9Uw9ylv?=
 =?us-ascii?Q?hdKrF0xwQfEoBm6wckao/hshyQkgP3e9DrruwzOaGcVnxlpaRpX8XlYUxnJL?=
 =?us-ascii?Q?C5Z2X7rynk/MmrWbeBGDiTNP71jjk7Ow/OYW4CPPggKO0ZfzrwTT/X6SOr2r?=
 =?us-ascii?Q?qkzz7Lj0cSKNxACviil+CVgUIt6HKZlEekQxJEy36RbAhiSLv/6jkumXzySP?=
 =?us-ascii?Q?FtDEQ9WRyvuRH7CLlMeBKfi63xJhF0aU35AMXJ7dSAOyTu2MuS0POK1jr0mW?=
 =?us-ascii?Q?wdBv3Jt2yyTUuixQWG11Si4DeF8WbTcsHxc/bzpiHA2n13YNMTtWvTheI0IE?=
 =?us-ascii?Q?RdromFSZ42XSkK/cSNvNHKK3T3TktA9J+MdrCuQd++uv7h7V5lHdShuTW1Yt?=
 =?us-ascii?Q?paqypl7jJaamOZw35i7HeW7TTRmsLWBK5TXjLMeLg2uOrWgfwPSrbyRszkkl?=
 =?us-ascii?Q?tqkIYDzGXiauwqUeK2wAaGEpbxSJTFva0k+68ORPVHdpK2srdCWl9+H6+l9m?=
 =?us-ascii?Q?Ont4S02HhoT3VdOiJqtS41ZXKhulFMxfx6ID7EU713rUI+zgUo/bP5Px2UgQ?=
 =?us-ascii?Q?avTldfzbxJmwafk+j6fAxFTTCTZ62PRci/2Px+UBIhhABMDXvZUaopyQNAl0?=
 =?us-ascii?Q?zteUyImEOXRM+QVe4lstJn/FMj9Th16WSKuOtQqUJOb1gbjI25oWGXwshY4s?=
 =?us-ascii?Q?XAWg9FYimF9Fjb/nGLxYi0DCf7B6hsXj8H0JZnO8EZJmtBPB7D/agRzZcnX+?=
 =?us-ascii?Q?VAMwnGaB9/nuKaiXLt0Nm80KC5r2Kte+ZHMuy9khkLk7Olcg6LjLur1g8R9R?=
 =?us-ascii?Q?mfoBHMv0j2JBj2J/ur22nje4BVy/fmSBcg8bD3Lz563LfdHy/IU8AjC52tCQ?=
 =?us-ascii?Q?qgNRwbUA5I8XnF20i0JBkz7iBHi8/12WRi7yIxNhX7hAe6sszv9nXZuh5jnY?=
 =?us-ascii?Q?A1xjslapyGA99yvszf1SB2/98mPuc/+Zcfg4LhYgVWFaxC5kLYcQVxKBpEXn?=
 =?us-ascii?Q?htg+KVThSc8/Tt2v9tbS0Y+OMhExIHkJpBFWCpBogb4dG8JUD7EjqtO3N0sS?=
 =?us-ascii?Q?lGkUzVS5vjmHXS2GyrH98JqiFbALR3U8zWW1zoeZmTIOfUv9Xr0IpKjsZNko?=
 =?us-ascii?Q?BmZ0A/epEwL7deCEXaqrN9sZ6viGf9Z4pudaoCJ9Bb0hRzJ4WaJ3oKW+2wqM?=
 =?us-ascii?Q?tXV2dT9if7zDZHofRQWd2OURJk5FSRekZwp1c+Tigwhe+hRQcHfO6F1fU9is?=
 =?us-ascii?Q?SL3/9ZYFL436ZZy8kRmrM6nbYVtgP+eafn8sw2zu5N582cnk3a0AgjXXVymk?=
 =?us-ascii?Q?ec0arR+odjbZPSIWD+Ir69fUnrOq0Z7XtEf2VTtNnSL1h4kcCE0VZjoBVCX/?=
 =?us-ascii?Q?k/GH8io=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vyLI/JfuHnc837+F61IkU7Iyxh4vitC50z2YFghw5zzPQvpd2zMqviewlkCO?=
 =?us-ascii?Q?BcOgznPMOCduixFZ0EcD/qWH4V3WFlE5Rh7tXltJ7f+fpmtrhH8sBGtjU960?=
 =?us-ascii?Q?9X79c5kj2bi2pcHxK9IM1nO9JTAyOGQa7xIZ5d63gFNU+GP8X+eVHkMbMgNn?=
 =?us-ascii?Q?IUWoeYWrWuPKNsNTszuC6qrV+NEDNvMAd2Pp59NUa+jztA+XdtsoaLXT5Fyp?=
 =?us-ascii?Q?bZqQb3g8ABTNjXBLh8DTC+f2yvNmTBPUQThkhcSeSnrBLhpIiBDzZhYQTT9n?=
 =?us-ascii?Q?bBQQUMgjPcHCg/rCO7UIs+ADqw9lc10V8uKFPAe5GFzOqeiBSI9CSAvtYEOq?=
 =?us-ascii?Q?H6FvDSXJ01Mtn8dp1cWq0wBuOUV0HNeAl87vH4b5ux62qgqYWFzjFooSRRg2?=
 =?us-ascii?Q?br6JoUYRuLbjAnzn5G0KBCK9ysrUvrrf6MWEBxjW1W7QxhehEo+v7CXBA96L?=
 =?us-ascii?Q?V1+HTH23vQ/Wl6QesqF+X2TeUwXVFUp1C34eSwjy/p2Y1lFNBQCiKuRIl2H+?=
 =?us-ascii?Q?heRNtqMlwMjMMDGJgBtMlUFwtDlrybCd79y9YS1osvKtIWxDLQIarvsk+UjE?=
 =?us-ascii?Q?ZGjFKEqW2PDEgiPbEa2K1/Go7cTdXtLzf+M6fjuWHpheVBnOH/q2HeIMLx+j?=
 =?us-ascii?Q?1TC+oC26oFZdxFrO75N5pvpArB+a9oXdww4GRABw/JEMdIXQ8uPgYFW9lK0P?=
 =?us-ascii?Q?43uILQxwSpIEyRX+dSZBGIVeeEcch7ftxFXEEL1xCxrtnw0N0daKcUuuXZkk?=
 =?us-ascii?Q?Aiy7tjkMkUQh3KNNHslyg2x7pBiuMDb46uIIFU7zshN72N3EzZzwqQVTj/9n?=
 =?us-ascii?Q?eJACutMKqo0wiJOoqVzrBnHxPW5JRPS/Y6ViaUG82lgBWu4HNXLVfseZfDmg?=
 =?us-ascii?Q?gHVlQPurOeVF5KyesnP8SYm2cxttulrQ3ux5ZqxaQkLtai4VCAjwE3MCm/B5?=
 =?us-ascii?Q?HTIbPf24BtxQbLP1mvrT5GRB5Jb7ujsO45hABH3cga5aHxCOZh37CkuGulhV?=
 =?us-ascii?Q?dF/H+92EKWCHQXm0MJUJa3gFd22lT0v/IklcDdqetgN5lBo432Srs9bOI8kW?=
 =?us-ascii?Q?gvswDhwIb+pG5qBJPP8RXLP35bbRuShs2ZCOqoGHd7zZL//3zNTiwDct97+T?=
 =?us-ascii?Q?nY7Ule8EJDmJ9ybPAEdIAmcUbMqwwJMU+RcEOFtcKmQ4UKuA6tZP4ELoLs7l?=
 =?us-ascii?Q?ZzTV7g/0SWo06L2rwCDijmVM2NIfp89FyXqYEVWhjmEQn8VMvrhxE/EE1VXB?=
 =?us-ascii?Q?PFVzvvUpipDnX3u6t61XZkY2LcCOuD+MQg+E7x2vRqMfHaRAer8/OmDZvGfc?=
 =?us-ascii?Q?/wlZaWtI230VqhquzJw1z7yl91VJ/lOgc3+QJgsxAS0qqYJRyY7g8t6c7vDq?=
 =?us-ascii?Q?SIbiyt/PQsZ+bs9cocLCP/eui8CQyr6iLDwGJAmZIXmvRCeOq0PGC/8rMkoR?=
 =?us-ascii?Q?1nWV871LV6BuL6sV37HTVYYgK7hMR5pOCUUiL1nPhXJAlC4t8RlBbBKfQ07X?=
 =?us-ascii?Q?5AIIZRcj28YxAWsILKGHkYxLBILLl9qoVdgZf8MzdmR6+zqPIQrCPYOC4HqE?=
 =?us-ascii?Q?VVIAnJDqU6xaEAOrh0MLQ9nQLI9Rskay/NjkdjBi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a13e7d-c9ac-4678-aa81-08dd054f4dec
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Nov 2024 08:27:12.4293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F7JJ/0WoBHYY6KP0NVBhYWKobEHM7ILXmXSfuK+wYEhIl1TpxACbVU7F3ccXkbJqj/39lmp/1+EA0UR4wIZRtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8100
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, November 13, 2024 2:52 AM
>=20
> Be specific about what fields should be accessed in the idr result and
> give other guidance to the VMM on how it should generate the
> vIDR. Discussion on the list, and review of the qmeu implementation

s/qmeu/qemu/

> understood this needs to be clearer and more detailed.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  include/uapi/linux/iommufd.h | 25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
>=20
> As posted in the other thread, it is a enough of an improvement I'd like =
to
> pick it up for the iommufd PR.
>=20
> Thanks,
> Jason
>=20
> diff --git a/include/uapi/linux/iommufd.h b/include/uapi/linux/iommufd.h
> index 747d3d9baa3dda..1e0345a62a3ab8 100644
> --- a/include/uapi/linux/iommufd.h
> +++ b/include/uapi/linux/iommufd.h
> @@ -549,16 +549,25 @@ struct iommu_hw_info_vtd {
>   * For the details of @idr, @iidr and @aidr, please refer to the chapter=
s
>   * from 6.3.1 to 6.3.6 in the SMMUv3 Spec.
>   *
> - * User space should read the underlying ARM SMMUv3 hardware
> information for
> - * the list of supported features.
> + * This reports the raw HW capability, and not all bits are meaningful t=
o be
> + * read by userspace. Only the following fields should be used:
>   *
> - * Note that these values reflect the raw HW capability, without any ins=
ight if
> - * any required kernel driver support is present. Bits may be set indica=
ting
> the
> - * HW has functionality that is lacking kernel software support, such as=
 BTM.
> If
> - * a VMM is using this information to construct emulated copies of these
> - * registers it should only forward bits that it knows it can support.
> + * idr[0]: ST_LEVEL, TERM_MODEL, STALL_MODEL, TTENDIAN , CD2L,
> ASID16, TTF
> + * idr[1]: SIDSIZE, SSIDSIZE
> + * idr[3]: BBML, RIL
> + * idr[5]: VAX, GRAN64K, GRAN16K, GRAN4K
>   *
> - * In future, presence of required kernel support will be indicated in f=
lags.

probably add a umbrella sentence to mark out following features not
reported via IDRs

> + * - S1P should be assumed to be true if a NESTED HWPT can be created
> + * - VFIO/iommufd only support platforms with COHACC, it should be
> assumed to be
> + *   true.
> + * - ATS is a per-device property. If the VMM describes any devices as A=
TS
> + *   capable in ACPI/DT it should set the corresponding idr.
> + *
> + * This list may expand in future (eg E0PD, AIE, PBHA, D128, DS etc). It=
 is
> + * important that VMMs do not read bits outside the list to allow for
> + * compatibility with future kernels. Several features in the SMMUv3
> + * architecture are not currently supported by the kernel for nesting: H=
TTU,
> + * BTM, MPAM and others.

Not sure why HTTU etc. are remarked separately instead of appending to
the list of E0PD etc. there is a reason for kernel not reporting a certain
feature now, no matter it's because the kernel hasn't supported it or
supported it but just doesn't want to report. Knowing the difference=20
doesn't help the business in VMM...

>   */
>  struct iommu_hw_info_arm_smmuv3 {
>  	__u32 flags;
>=20
> base-commit: d68beb276ba26cec47350a6d468e967673ee0c56
> --
> 2.43.0

If ARM maintainers are OK with the list of the baseline features:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
