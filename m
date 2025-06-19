Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C333242D71;
	Thu, 19 Jun 2025 05:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750311750; cv=fail; b=ritCCzYHjKVRbYD8X4biBxzEXpBleDQ/luOQ1g1lrU7PwccsD878hLqqQkqQnIJsioSkEbWpo7t6rMOKg3pkJyB9+G7pJfItaxJRfabtBbdthVotAmajTQMnhjaBYDX0l4r34FmDnGXtiGhpYGHWS2b9ZFngbMrfI/wcPuAJv4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750311750; c=relaxed/simple;
	bh=5ZvveUcYQpTv93nQHPj0F9ii6AWMFcJPcOEOhG/pMEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=L1LNFAIw2qAuw90qDTcpOVuEPDeOq0//GyCcuJ98cjo2X+/UY4eVO93TvTCyloonYyFddt5Abxkry1fXc8l5oHeu5dvTu2lhcCJ/l3rAxiNse4jMHdHRUCtTgloJGmRfHPSIHncbacfqM8oH5UscAzTNa9hkaZW7TwT8Vb8XZ3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eA4gyUTE; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eA4gyUTE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750311749; x=1781847749;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=5ZvveUcYQpTv93nQHPj0F9ii6AWMFcJPcOEOhG/pMEc=;
  b=eA4gyUTEwNV9B879Gb4fvcscVM5O2/3+eb9BqeO5bCHCeLl2XsdmY3DP
   X3eYvwzZ4fJCGXHMs9qTgD3+7z8mvT7Pv4mjvGxWyu5gOYGbdHD/rpUGU
   HG+Zx7wzQZ23xb5xjY+MOxsh6796U9pxRnXmv5t17h2/RfwjzfbC8bZsx
   OeBVSWK3xKp1fQGhir4DvjZPSYBM/jls+WJdXUakVxvm4xO3LpSjEs4zo
   1g+DP/66I8M9KIJNEOfjq9RVaFNUJWvfIOpM1m2bGA8vHkPYEnseTvwhw
   1Jfn9dd+RUv3u3cCf+LVWa+68NsZLHINmVCZmQViG8oO8+Oi//o7PvTCt
   Q==;
X-CSE-ConnectionGUID: SslTVd1vSpKi+Jbt4lAyhQ==
X-CSE-MsgGUID: RKgZPsqCSuOuAjGgMyjnmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="51662219"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="51662219"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:42:26 -0700
X-CSE-ConnectionGUID: 2XfKIht2Twyuj2dNUApe/w==
X-CSE-MsgGUID: ezUfSL4QS8Gyd0Mhz6gTsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="149968901"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 22:42:26 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:42:25 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 22:42:25 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.75) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 22:42:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yx/L9csCkOVm19Vn+H6Jf7gBIxnNGzArvRl0Q7Me64/vG0yCSYZb3FQ52ztyHQuITH2TrED/OPfSuvr56dsGF9q1pwpQcqzqogSoEfe5sY/uZoJIsixVZaml2zGrkWzFTNxhc5MLsbbUMy5/gaO7d2Las5TDbghU45TXG+vF28mVkoX31CsB0uryN1AWBdHrR2wOdEGg6Qnhhn7c5Dfocjg910Im09Om3sF2wyluzKkBEw36gH55l6IDkqO0kmFKt0lmH7uo0F38th4sfg8U0eM3SxRWAdb+/jbiHj6ywNJOYOIc7hupjt1GI23HjkJi7hFGqnKSVanH/LsRx4fJ0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=clciSem5sijrMJ6nH/twaBIhTV9PNv/WQ4zJmONeR3g=;
 b=suIIiBmc/bzlfNd8C5rjRHe2Ay3XMhO7OvVIx3ImYo8SBIRvoUihp8wWcVnMDtMa1frBmvk0F4qL4cipjkbWEj9eJJ0DRFQbRHu9N/0uSaLigaGnY6kkMiXz/QkcRJRQIp4VmlNXlcWLIIPzPSxTqZXD9rSRoGeOwghDjNSZOVpkPCEJctF1P+uFtWwnGwoRueB8DNoKBSccbG68MYyKE4VuhzxrTW9ZiaNB+0W2ZNb+VZkUeYjE+HpezVhlLrnR/xIEAww39o17bC7KRD1GJRrfEjI/MWeFQosKVDyMk8IW8NRuofWkHK/2oHOcE8fcOcxGxfc/PwbQIwVjaNpIHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Thu, 19 Jun
 2025 05:42:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8857.016; Thu, 19 Jun 2025
 05:42:21 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"praan@google.com" <praan@google.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v2 06/14] iommu: Introduce get_viommu_size and viommu_init
 ops
Thread-Topic: [PATCH v2 06/14] iommu: Introduce get_viommu_size and
 viommu_init ops
Thread-Index: AQHb3PawxaJbcK/FBEqTOclLBTX8H7QJ/59w
Date: Thu, 19 Jun 2025 05:42:21 +0000
Message-ID: <BN9PR11MB52769429DBEC752093C89E678C7DA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
In-Reply-To: <3ab52c5b622dad476c43b1b1f1636c8b902f1692.1749882255.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB5777:EE_
x-ms-office365-filtering-correlation-id: 595e5163-7220-4478-750e-08ddaef40f78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?VSIsgz/AUahjY5thTeld3E8Cw5B7nbyX/LiH8TECL9HzXUkeJatrREqaS5zp?=
 =?us-ascii?Q?5xCZVH6kEOiL4TqXI9tIPQpjAI4egT3a2YDCMbhgcDud1BOM/uWVu+/yGdhQ?=
 =?us-ascii?Q?bz/CyCOqjo39nvJXcUe9tr/K6ckIJvlkla8DB/Da5UEYm3JMfWHvhcRM0QO3?=
 =?us-ascii?Q?36u/OKJANSoTZemK6sMax1/V4DnRtWpHgZr7mUg446ut42U/EEojvazYu+A5?=
 =?us-ascii?Q?nHhAQs8m+EN/uEpfFybThNftB/eKTeP2TUrdxW6RpqKPSDwB4PAwPsh3+E4j?=
 =?us-ascii?Q?iZwrvk9pNV/XOULZXe6Geg/X7U4sA2TD917DZj8A/E3hCzyqCugOGDmNd5V7?=
 =?us-ascii?Q?Wye5nLPnLn4YnzbfG9ZsuyGvJUiU1UWOpjjIbiI+QOoMlPghhsMmvOj3OIGw?=
 =?us-ascii?Q?HOOq/TMap1UILCcCe0H04lQPWC5pS7ADGGwXANAtdKoSBSgQGymTVF+hzcK0?=
 =?us-ascii?Q?KX7lq7Zdni2pyJJluh//VKy2UchgRWjs7Cp8rFgkeItSSEeZdTsUHlORHCis?=
 =?us-ascii?Q?jPMfgQ6Akg2zY5aKs3ENAtjOjB3RCRkw+0B6woQqPUhq7S37m3awe2IBqFIP?=
 =?us-ascii?Q?dLagZ3hZztuX10Qu4SHoXVy9esyD4d1dSRlWF1xLw9eP3GxlRT1UayMYEO+b?=
 =?us-ascii?Q?7Y7ipkBHQxbnsB6AT+Yr5tsGjOAVvdm7eOySliPcArfIVyMIHjJUfFcr1whY?=
 =?us-ascii?Q?4cSotA6D+xaJ+TYzTqH/NXvbpba4Z248Xg0xtJF0UUVeH4eWBQrOPEcmN+21?=
 =?us-ascii?Q?JdvK0lerNP309B98tS3n2rJALWNQB4UISQl/t9yw2cGQUvAjowVVQpyfJuUW?=
 =?us-ascii?Q?9AM2CDUxmoyU7+XbrmiK0RYE6nm3MGIJuM9WFDIrG56JsEUPJlT6byMBtugo?=
 =?us-ascii?Q?rxz99zLN0ppMmivol8Onp0mRoGBOvx6VXqn9vX7SFVzqYCleSyJRxupdKlsQ?=
 =?us-ascii?Q?CpJjeSBT38unMzndNFDk0Lb93WGD/+PfiDWjMswPReRvZyRpI/5ic/ZJzVt4?=
 =?us-ascii?Q?xSlBYFTEV/ADbqX+A8gaAY9avkqqPUGG82Q1HFQ1x2mG+d5t24LWX7uDpv7p?=
 =?us-ascii?Q?lN4g1jPho70mHrRrh9mmVaiIuixEsrLiJEGjsbPKmpTaXLxLX6TUgpROirtS?=
 =?us-ascii?Q?7vFR4lFQ50DbwUAMov/KKlwlBWQle4EHJwH9S+4NLjsyeBVBq5Kktu3GHztq?=
 =?us-ascii?Q?hoQUSn3gM2W5tpAXUrmTkGQBXlnPj+sdBLMBuBat/72p30IIPuveV9JlmY8q?=
 =?us-ascii?Q?inNaarUU3uktiB6hU9x3y7iUKbZ5Z32w3v3YeAeZ+8zyFTg7CmqIQSky5PHZ?=
 =?us-ascii?Q?EG06T9FWul5hRHv3E7I9IFbvJ9ej990yeklxorS2ZF7LVWAkTCcXnFNbjtPy?=
 =?us-ascii?Q?mKVU2j0lMQFPbC1LZc1TYHQQErHmUiaMu3ki/NU/REIXNJ9Z/dErqUUnHfYw?=
 =?us-ascii?Q?jO2cCNp4cA7PYeMQV769xwBQY+Sa+Cd2KEXKx6biGIF5CVZsiaqPZuPfUfmj?=
 =?us-ascii?Q?3zPn9zGO1XzocFA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q25JaOGoLyyMGT5fKp/8GJtpn3ZREg85130OTr/29rVs95onUaNM0qlc7zXr?=
 =?us-ascii?Q?xR48kKsm9iToRYyHK6sx2Dn2OKcYuPlpNocJJY1/Xf1hnPaWQN+ZigidR+Ha?=
 =?us-ascii?Q?GKWAkLxIXe2ue0WmrLydGOQ09Y8tCqFA9GB0WAh5lzFzguP/ucDmL7Us2w52?=
 =?us-ascii?Q?g1NbS3jqrwnUBXWqlngswMOh6hjHZYlHK5iZ/RE9RpbwdydxmzWF8U9SHREd?=
 =?us-ascii?Q?LXuvUxpkOElE4UbuthvQzYiXZDAcaiF64n+r26+Z2QDId+rKwfNhIa23OTU4?=
 =?us-ascii?Q?g7IbiYDjipqDwJI6Y16rbPeZkvOsy75AihtuPL4GB0iGE8mn9GEsdqSEWU2p?=
 =?us-ascii?Q?5bu8ogp04qYgM3hChZVnkTTa01kQRn7/+gGDyxs0AmgUHsIfmMOX3w4HDCE5?=
 =?us-ascii?Q?qkD++eX/BLBc9ko5ckQN4ouZNLdJAihacPSs/6zd+CP/TEiWdtLpcj/ltJWJ?=
 =?us-ascii?Q?OfnesTkOhFKQ+hzzn0WSfVExalCawV1IRF8YlJTPTOoHFDJ6UKDNe9ggiABs?=
 =?us-ascii?Q?img0LiA0BIUFlbT9yHEbwi9FZOASMt+2+IDa4CEDZLKbppImyzmIRcMJjpsS?=
 =?us-ascii?Q?E5y/ilQrzT4C8+coYbTavybJNghV36lfVf5IcFv0T5DQCns7G5igzsYU6dp8?=
 =?us-ascii?Q?DcuMNYRRyItksPJh22s1/1dHw9Sf85LZeaYMjk7KO5TbaeXxsMasFQ80xjIz?=
 =?us-ascii?Q?5zwvjr2xZkTXL8pscG2l6Yuztg+1DZ8hI1DvKMPQzbygbP8+VLsm+Z3CYFVG?=
 =?us-ascii?Q?QBfIcWv6DYm0Y8aPbHTRSnJ0ekmhIqnMNeUeT6CpjjpSX49O81x4iz6ssnc5?=
 =?us-ascii?Q?FWUv3BkVD9L24uOfGz8KSZ4ODajDUhHdOBxJ0J+XURag2mbPxYIGI84SV3kQ?=
 =?us-ascii?Q?xsP0EZ7TSVY3d9iHEjEobwYY3dVABVjqL7auRkPu+bX52zi3rR/Huu1MdLQl?=
 =?us-ascii?Q?PDCS04xPX/Z4uzLz5ETgKgoiUfqnMWkZv9Vj+x5WFthSoqufstxSNfKvTdL/?=
 =?us-ascii?Q?WKn1IKeQ1nj7HsTPE260oJvDYVbgB2z3DrvtWB36OanQqYYNI+pPlneE7/76?=
 =?us-ascii?Q?qy0bRNEaH0m238C6qKjCCVX2HaAYZJ1kp7HtgK4z8/lzO+ql96xbX3QKu9+E?=
 =?us-ascii?Q?gY06gZZsY3QlltSOd+NonDQbRAifjZObbHPvRPYUjbrXvFuMfbmS+m7z9MUW?=
 =?us-ascii?Q?P7Qo2bSi5uW8Spxo1Yd+HPsemDAwY9MXdngJm6FKNcb81cImRwnd59+L50ow?=
 =?us-ascii?Q?Q0+2Vc+1g99cTMEYIj0AipO0Ret9iXaoqLyte4VyYW7zBXYwcxBtGliJPH1v?=
 =?us-ascii?Q?fz2zf5Tl1SM0ehXWNhvd043VAQVECbvmWf3PTwE6FDrCgEA3fbKhGXFw72Xg?=
 =?us-ascii?Q?1AFq7wEncSQjMB6N4yAhHBh8pu6doFO6LV6O130k2NIkSX/aZGbtueoBPtoI?=
 =?us-ascii?Q?E5J99wy61q9TlNV3a+VPU5JwCwDmbJX6gXw9V3Mh76dIUReiCIRbyiQXZviL?=
 =?us-ascii?Q?CL+MM2/44jqpZiBX4040BcZzcLRk3iU3gNTo581sqdJ9bJNRrIuqh4G6B+id?=
 =?us-ascii?Q?UYVx2SU0g/2VOjZeEyQY7x15C8qu45Z3PSadQ6ej?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 595e5163-7220-4478-750e-08ddaef40f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2025 05:42:21.0946
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: moynkjlzjlGtVBafz+TOXe6P41eBFLjYRyb6p++Hp3g6RuBfBDtgsdvYOr7fXFLlXRHRPqnmKF4mosAKrup4ew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Saturday, June 14, 2025 2:35 PM
>=20
> So far, a vIOMMU object has been allocated by IOMMU driver and initialize=
d
> with the driver-level structure, before it returns to the iommufd core fo=
r
> core-level structure initialization. It has been requiring iommufd core t=
o
> expose some core structure/helpers in its driver.c file, which result in =
a
> size increase of this driver module.
>=20
> Meanwhile, IOMMU drivers are now requiring more vIOMMU-base
> structures for
> some advanced feature, such as the existing vDEVICE and a future
> HW_QUEUE.
> Initializing a core-structure later than driver-structure gives for-drive=
r
> helpers some trouble, when they are used by IOMMU driver assuming that
> the
> new structure (including core) are fully initialized, for example:
>=20
> core:	viommu =3D ops->viommu_alloc();
> driver:	// my_viommu is successfully allocated
> driver:	my_viommu =3D iommufd_viommu_alloc(...);
> driver:	// This may crash if it reads viommu->ictx
> driver:	new =3D iommufd_new_viommu_helper(my_viommu->core ...);
> core:	viommu->ictx =3D ucmd->ictx;
> core:	...
>=20
> To ease such a condition, allow the IOMMU driver to report the size of it=
s
> vIOMMU structure, let the core allocate a vIOMMU object and initialize th=
e
> core-level structure first, and then hand it over the driver to initializ=
e
> its driver-level structure.
>=20
> Thus, this requires two new iommu ops, get_viommu_size and viommu_init,
> so
> iommufd core can communicate with drivers to replace the viommu_alloc op:
>=20
> core:	viommu =3D ops->get_viommu_size();
> driver:	return VIOMMU_STRUCT_SIZE();
> core:	viommu->ictx =3D ucmd->ictx; // and others
> core:	rc =3D ops->viommu_init();
> driver:	// This is safe now as viommu->ictx is inited
> driver:	new =3D iommufd_new_viommu_helper(my_viommu->core ...);
> core:	...
>=20
> This also adds a VIOMMU_STRUCT_SIZE macro, for drivers to use, which
> would
> statically sanitize the driver structure.
>=20
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
