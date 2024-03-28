Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779A11EB5C;
	Thu, 28 Mar 2024 03:23:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711596216; cv=fail; b=IS+jw6glYBHkBGq6+YFx+UFf2uqZ0qKgjQxh532HQNKa8oPQy8BYRmk8JdKsxKyn1iALKt2HL8M97uInAW5Quo6g5rI9GsD1NZY8gllIVZYp0a2gsK0HoPeCjL8pr6i5N/NHee+uQ0xKnffyNijn05UWlvkwKQkfzdfnw0mi3lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711596216; c=relaxed/simple;
	bh=MTX/XMMHbQnVG8Bc7/U8L6ulWN9U6hSblgdwmSsGeKk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LQTyk9OYLoWHAkrS/65ZHgWcUQ4Cz0rKdu/9s6kCs1t1Z1jFivtwBKF2obH1RA8Et47lVBcCSogNIbENJ73nSpdVhO5x9MkP770nfkh2Cbul6T5PDa4Tv5HZyeHQ5evSnBA6Ph+0tWa6JDVuWMhKQJNhIbRGp8b0VI4CPSblsvY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PLIpcP+Y; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PLIpcP+Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711596214; x=1743132214;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MTX/XMMHbQnVG8Bc7/U8L6ulWN9U6hSblgdwmSsGeKk=;
  b=PLIpcP+YQ9eynAibiuqqKIp3MS4Um3TMePH4ZtAV6XdcOhYZrhlhXapV
   upx4jdPtFkJ3+Qi8xihgYHCpIWxcFkI/VtO1c4OLRfJdgOq/v2LMkHdt9
   idoCX2IxNYzaTXwbepg7Du0X01DAdIN9QHA1ndMUu6v+XpZlujjLK8cll
   XHgfJQJKch2Y0Tezl8X5eV3tmjwN5XQUwigfckFEgpzbMKrfwhdZR2Tep
   vHJ7GgEYolProz9HhiPUQ46VvZmrpoyYiC0fI+xY8ph5U/Dg0AwKgRUww
   zcLD20l0c6vAhvPZdYcrecZMbP0pUt2i5x6JFJzckEJmYTINXJahGMUF4
   A==;
X-CSE-ConnectionGUID: ui1nH99OREeAJucW2sQcmg==
X-CSE-MsgGUID: wqIL1TAMRlifxMxesKj39A==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6862062"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6862062"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:23:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16578258"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:23:33 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:23:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:23:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:23:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:23:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YpHO4vxGe40ZIB7Yf+saGWmOgQZ0sRYpOgO+WPjptsJfl+jVf8rMUFm7t+DImYx1q5jSYka0pIMuTG/5sNVZGSlDT8u9qJG5gYabuXw1V/naf5fQbtCjIgcWu/S7Dhcs14JifWC8cyAOzTTrTkXttg2GD/STM2VK2Q2ZNYOLk43eYIBL/9YVlNxiONE1U0Ec7m/EwlMySRj8A9wR2dQxBlvJkyGS/lDNiU02UZmKuwd8JCp5dvnLSkQgITrM64G1/ctbw2dDnNPUj9fljpXLinByriv2OecbM2Rra5aG7yyoDRsS27qmAD3dKJ6T6f+UrQHYfMV3R3MC4LGCcT/5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MTX/XMMHbQnVG8Bc7/U8L6ulWN9U6hSblgdwmSsGeKk=;
 b=WXrrjDU6Zsii5XsB7cY22/b6e0ZloZWhflG1jg+c0Sly3ybVPVWO4p+QhoYS7qS4ocdQJNieFp/AOuUQnv7FA8O+buFlIeSbkSAaxExm2mcki1QdAMFU28pVSN0Iic5F9i92WEQk/KxdV/0kkKlxI2pvm80rXU5y0O87eCq3s1fslX5sqEhDUnUGE7rbl0A49wGg0Q0KgtsNGx4NwPI8iJpXEH+YDSwg0pii5AwhxAYdtijFCfKbfG5D1MG3hwZ48Qcvyzfh7wcy+4tYwmznb/i3UeUBKdJXF4ora7gCiw32HOjHuDzGqhJFlYRxEb1EZshCrBDCJ6pSccQCbXjbVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.10; Thu, 28 Mar
 2024 03:23:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 03:23:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Jean-Philippe Brucker
	<jean-philippe@linaro.org>, "Rodel, Jorg" <jroedel@suse.de>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>, "Zhu, Tony"
	<tony.zhu@intel.com>, "Liu, Yi L" <yi.l.liu@intel.com>, Zhangfei Gao
	<zhangfei.gao@linaro.org>
Subject: RE: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Thread-Topic: [PATCH rc] iommu: Validate the PASID in
 iommu_attach_device_pasid()
Thread-Index: AQHagEyGBouAvMHt5USs6RhFgnOzxLFMfenQ
Date: Thu, 28 Mar 2024 03:23:30 +0000
Message-ID: <BN9PR11MB527637E64572A542DE44C2138C3B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
In-Reply-To: <0-v1-460705442b30+659-iommu_check_pasid_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6936:EE_
x-ms-office365-filtering-correlation-id: 76a730f1-a003-4dac-d421-08dc4ed670cf
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wSAklkeXlYLFz3xLzxfyvers46BuJHF4gwOIAdAsSpwwziyX64uuJQqlsTgOyqbciFhgQNZp0MW5s2AAB+cFU89f94231VBBuc56rNJiVncaEiFiqv2yux3eeLMoaDWsJskNh9XiTF89vwhbfR02nHVf5nySKiJIFrooq9+4Eyl8VJk2hPpTJ5cWpr0p4mAXh9fiSMTtcfjvJJgL775z7xRP3zqhy0vMre43K6XWyPHKHgCU40jjEzbhCG/4ltuwKPcqsI/WX12YRElcuYyh8aJ7WEkm74mgxx4pAFBOt3N4DeQ36a4VEeMqUf8i8qu0Hot22WK/kFI9SIwEgK4mI2y2ixgCRTEPLR8vJNZWJPbrxrp6caiXn1kIpef/OCQBFZ4vpMqKP7p1fcxZP8hZ85IeAYT+ARDYKQUMIcZjiamm4gTkhfcwfsu1grd0mYFBsaSi1moN79FRJPbceealEL+AxYJ5J9mgh5Ri/ly3Amli0WClV7j0oNdDe7c/hWHTUJZE86brEjnlWb3yUUisfT+LngLg/jhgR/KkYK7igF+s45q5k2BhXrSV/v7Udjt4XeXzlAgfG0oQRdXsHc23fsx6T5NxACNIKWKzJFdY0cG7/2wFeJp0q/LBN3/7KIPLHVecOt9+iSweKUCbnJMKeSHcxnbjC5EhxI3Xysj5vHTDZELpWsnOMH3qis14kigMVzE/IGQoIOf9SXR45GojWSCaFZ3XiVK6ItdwJmoEF14=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uouIqmULxRZXVbWgLj23mMSprqixdoOr4/4q53726CGmhRQKZSume7yh0w1z?=
 =?us-ascii?Q?W3jAwFkuj9NQIxGRg0bx1TCW3v4jYXoEz39c+jrVmBOQwqmF2crOfefyA65m?=
 =?us-ascii?Q?3s28TuGykYDePY97bY0XaIjM0DuNtjm5NFQt1t235TRhYZAqk2kmeBu99wYi?=
 =?us-ascii?Q?8T3t7G7ZL6uToCJ5UFeSSygs/P2Ix+0BUNvUwIuEV0uqmsXrQDrlqkeDQpE3?=
 =?us-ascii?Q?f+arxcmasnGeoAKA5NtP0t7Snoz5y9N/vIDCfhhmguZPow40Ywi/ubm6AVa2?=
 =?us-ascii?Q?53KrQGgkOkCuEsB1lzTKYUj6d/GJV5AaFZgfZM6dtGII+Oq1alNLNdcW5rki?=
 =?us-ascii?Q?dyYwmaLQzsXce58hSlrxsRUloPQz3334pJwmhtUyb8tNa6xHUCDTdEmEeKGZ?=
 =?us-ascii?Q?2CVqThCKgzKiXh5uha6iW/TtsV9LO43UqAE4+Ldz91EOGTt5J3EuljCaw4q3?=
 =?us-ascii?Q?unSsnQ65O989cz5T+rALnEkjO4cJVgu4QVQg3oGqpi/V0diqCi0crqrYDIjQ?=
 =?us-ascii?Q?KxMYJnHIR8WGjN0m8kM7Q3/ZIM6d23rkdjHk/F091Tx/+IYVil5CqKGrvvE8?=
 =?us-ascii?Q?mqGEK7cJKaplg6Pq5PRChizH2+mlNNGmvS5PsAAQqAWjCx25l1Q8qcHWpHi8?=
 =?us-ascii?Q?mi1/A0dCMIGYtwG+e1uRDudouFv+1/EiZSU1q3O0hfJqPKc4lAjhaqrAsnFM?=
 =?us-ascii?Q?lrx8v5C3dcBTGbdJNyhvZ80BTt3Agq7oJ5ucZsLKP+Py5QxmdJ0Ti+Mmve84?=
 =?us-ascii?Q?7hF/UyEiF8CyhpLKZBduTfR3l9HBBY791fSSl7eOBXskKibZEGsN4/cVtxju?=
 =?us-ascii?Q?/4SKSw3a/SeShz6Cm9P7aWqninl4lj22BsbbAUK+My1G+W1Xlr6w/ICxnMeb?=
 =?us-ascii?Q?YzAFO7l9+48Lpykm82z0g0Qgmqk4kxsswWfY23K6WDQ0Ox2OVuohWK2i2Uf4?=
 =?us-ascii?Q?zptXUhRXwY/62AQliAGRI/0uqoFQtdxEbQGONZpxGrluUvgXmmLo1RLpFqVq?=
 =?us-ascii?Q?wWmwDXPEDbnMgqY+q77cRkLCvO50RZ0RjjhmZ+Tv+G9D2enfwai16Oc0BX59?=
 =?us-ascii?Q?oCrEJBE9ms4gzPpr1/LAO3XalCHrml+tlcxaedeqD3b4WqIDtG9as6oaGZGX?=
 =?us-ascii?Q?vJOU/Vlj8SFlfhg8JJtKdxBt2raVXq6oHzTZnOOkuSK8gouLol7vdhKJ9Zzi?=
 =?us-ascii?Q?ECiVKoOEoqx4//QHs9O84D4Khv1IRW6NRZ69ukauDJj2PXGPjiJOt/mIx90J?=
 =?us-ascii?Q?jfAwOYAqB5dsGFNiU5f4TZjd+CixZr+xEwWtsSwMUwRcRj5VBtZAIX/h1+91?=
 =?us-ascii?Q?B6Y6nFjVQAzvRIdxyTqtDpFVRRaf9faNnB9qj1gSIDnfZgOJFsKSq44kx5IU?=
 =?us-ascii?Q?P8NODSX6501J0uJZpn2SDdXALtyKDdci2392rNe/qSo3QZrYtXHMpg5iXk7b?=
 =?us-ascii?Q?yXUjq6fv758L3z0GAyF6DvDgX5gbe1U/6Y19wOL1Qmls+kehJOtn1ePBGEyk?=
 =?us-ascii?Q?NAute7aKgYUQ6LsterJUFoCCSb12JPHOwqJixmB6/Wi9J9i9278nXkQbkrOc?=
 =?us-ascii?Q?Th1oXjl2Spfu1iznRSyzqFEvy12Avj7HedTiMG79?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 76a730f1-a003-4dac-d421-08dc4ed670cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 03:23:30.1929
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VVdR8R1O5D0x7PWeexYGINvYOZqhJB2Zo/2J4p8wi6UymFr6DPJZxf8PY/DJZdpSGzIc1GEG3QGJLUYhHe9gLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6936
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 27, 2024 9:42 PM
>=20
> The SVA code checks that the PASID is valid for the device when assigning
> the PASID to the MM, but the normal PAGING related path does not check it=
.
>=20
> Devices that don't support PASID or PASID values too large for the device
> should not invoke the driver callback. The drivers should rely on the
> core code for this enforcement.
>=20
> Fixes: 16603704559c7a68 ("iommu: Add attach/detach_dev_pasid iommu
> interfaces")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
