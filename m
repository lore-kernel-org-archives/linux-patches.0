Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23854EAEB;
	Mon, 26 Aug 2024 06:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724652625; cv=fail; b=FCP7s2Lk8yRm+DfmnAudcP8MaFUeOG7m9Ft3Hyj/KclaAR1uE0XXtFWDgL8AzdWBGFsLe7I00uivMbXEOL2S96ZCBZk/cys3etlXHZnusv3OdnjMCF8n0UWwrjy9qEGaUC4SzzCtsvMkEzv/KlTbYoRU6XTUFZg4kLSIpx5drhk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724652625; c=relaxed/simple;
	bh=W2BRajDuDoZ9T39Qdm2pF5y/atz32sDKnJsoMR2HEto=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rvMqtLHZk60bFCHXVyvMtJ2T0RmHIooI3ydye0kaLIQP527maGdf0S3xHjP4E769jGJhMelcntJDVGjvE9QwAQ+dDKSpkUwBmiAwZHMtZvB56nDvA0PyRL41mwBMuDH8g2BU795OoN4sCqsinwUvkdoVYE3FcqF8ihWQ9pU4ujw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GhBnnnxY; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GhBnnnxY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724652624; x=1756188624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W2BRajDuDoZ9T39Qdm2pF5y/atz32sDKnJsoMR2HEto=;
  b=GhBnnnxYOIK/grFIT43t34Xd60JHsbwjADAoKUNohxtMCem/Lxn0rbpc
   CXiqtu5EQqR7BszhqnaEcy8GoMxJJG6UEEr4UnXeq3Op1km5W28TxqETC
   aC/3M0RM0ZkZ2+BcoCBplBsZA+4/Yjhjg6GlYXOUE8x5QKqET/6QWMDXs
   Qh71YugWqPqM9nHSeYludfC7HrbtHk4q2sqHRB9KENBI7ZIEyj8p00va3
   F9rKBh6bNyyo7u3RIKfYztRESigvoNgOFGmupu5r+8ttJj4b5D08XWL/5
   Vb6yKpPlcbo7SQSJPpQ5vQqswDdKULigmSuT40LxDW8XLVRjoRG0ypYQt
   g==;
X-CSE-ConnectionGUID: vRLDTHOrTbaiI1HjOJJwIA==
X-CSE-MsgGUID: vekhYw7rTI6xdashlzdAGg==
X-IronPort-AV: E=McAfee;i="6700,10204,11175"; a="23210721"
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="23210721"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 23:10:20 -0700
X-CSE-ConnectionGUID: NiBnr6U5T2+hmZC5gVtz2g==
X-CSE-MsgGUID: HKoZ0WuQSSqWLUKWPp8iDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,176,1719903600"; 
   d="scan'208";a="62097960"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Aug 2024 23:10:21 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 25 Aug 2024 23:10:19 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 25 Aug 2024 23:10:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 25 Aug 2024 23:10:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M59N4GL/2i823qj6dsR4fV+k8gd7lWB7q8MhMkJ3MU/m28pfcTpQeuEPNeE6a8xdQYzJ6hwIuE8rmW8Kesb2aV0wulsBQ+smnEzG74zsUl3qQXdqoLoCvsK9Hz6wLFqjIedD+lK45xzc6jZjFL3QEvif18SIirQ0n92RdmcjPP0iXGUaZ05iLiJ3OhvCT6cVLMuN6YTHANnBb7dKwHnjH/zgospsYeF1HEakJyH/9gJLQyOlc3Mv1EETgxskQxyEt09qpRSIHpfaTmUO8kpNshjzKcSV2y1D0XSLBP/ji1Om0vpLHytJRZMTvSlSWU/c8rM22aYqrk7g0o6ddUtiHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W2BRajDuDoZ9T39Qdm2pF5y/atz32sDKnJsoMR2HEto=;
 b=K38UGBrx8ecuuUuoyNxdUj9fPlV1oSt/8BqDbsw9L6+SQcZURG2jzlO4AKXyC4Ypt2DlCdd1QSAFdrQ9b1L3fgjI4h3RbutRNEh6XDhoXhfKjmzlQOz+ObG7MbIQMyuNRBJjTUvnBjCxlhV0qaP9D5OgTk3DUMTzhWVLu+7BagoRsYOCqeSzXTwM/f+S3z5JR90w5ZwFxNkSOyn6IHqeGxmUlt5WGFjKdckCtuTbf2Fg7ZE51tRNuM0KW4soDEE1ipinzgmFoQgtiesw5j0njv/uexS5YjuC/TluxCuXYcDYU3sQxfZdMSVm5bZNKYP3u1lD6Bt+78KU10VNN04tEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7751.namprd11.prod.outlook.com (2603:10b6:208:43a::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.20; Mon, 26 Aug
 2024 06:10:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%3]) with mapi id 15.20.7897.021; Mon, 26 Aug 2024
 06:10:16 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Will Deacon
	<will@kernel.org>
CC: Joao Martins <joao.m.martins@oracle.com>, Matt Ochs <mochs@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
Thread-Topic: [PATCH] iommufd/selftest: Fix buffer read overrrun in the dirty
 test
Thread-Index: AQHa9KJC5rASZoZxjUaZ3EUMurkWFbI5E+QQ
Date: Mon, 26 Aug 2024 06:10:16 +0000
Message-ID: <BN9PR11MB5276F3A505C14AC8416450E88C8B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
In-Reply-To: <0-v1-113e8d9e7861+5ae-iommufd_kasan_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7751:EE_
x-ms-office365-filtering-correlation-id: e47c5214-4798-4207-d2c3-08dcc595c19e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?35EGWlqk9Uv7rQAzUnAAS49YmZlo1h1kLcLvGGbxIBL7tKODKXkoW/kS4923?=
 =?us-ascii?Q?yOwDMbBzQCcz7O5v8vvWQ4K2nCiLHHkLyGfQ56h9JHVkwnQBNGDPCPbEtXcl?=
 =?us-ascii?Q?ar2FQWKNcsBz9y+PdCR2SsjymYHMnvnKfAXkYffBNNaKPy769kv9rvj+4a9l?=
 =?us-ascii?Q?W+Jjk/+bqSLfslUFaRDbCvZuWrNk2w3WPliXFhU2dJVIMiHslU++cIeEtueJ?=
 =?us-ascii?Q?ldocxnFWIHQ/VdwaiIcZLn8CxoLBosmsYD/oGJg7y0SG8TjuXCmFFxxGNppC?=
 =?us-ascii?Q?dvsvYArm53l6ktDNyehVFetvKa/lyH4J0MgnmaU4KiaxUyxjgU1WMa0V2bg6?=
 =?us-ascii?Q?Qu8V2hh/hC/WHs04fSjz9eDUBQFgX9yDRgDfoGMiPLhgY3rC1w95Dy/E63rS?=
 =?us-ascii?Q?zVP6N2aHOUJsdGyxXL45XoAn/TE50OiSfdaSv1fvaERuQ46zNIKN5Aa+IiZX?=
 =?us-ascii?Q?DE9Z964ZgB2tvc80Z7ekDHrxD4OwYzFiKIPqQKBpOoLYFBqtDQroW654Vb26?=
 =?us-ascii?Q?eNsPr2eXkGzMEWP5Ky+Riz6Cc8roNv3FebvZA+XeJnhdJLCCWlzCdCdqsEE6?=
 =?us-ascii?Q?GqhQJjHneZ2GbdK0Z1Uqcis20dvpyq98JAp4AskdE9baepj73PblGfN20FBm?=
 =?us-ascii?Q?Z+s+ZI+i3pkbDlgnw8WuYiaAeZoT3EVY+VdjSX2PIz70unXhubn8iHhihP+T?=
 =?us-ascii?Q?K1sw1n6t/moanAJCUy4nPSYceZq9smcI1GBhIbzxcUCaeSuzu1pUQA/1B9Ia?=
 =?us-ascii?Q?+SkagZMh7ZiX4L17TYyzZix70sUPa4fPwwOzyAyoNxB6GvIrhYoyJ4XS/sup?=
 =?us-ascii?Q?Orm0OmskaOJYG3nwvknR3gHi6ksoHwZ4NRfwuYaXWjRDEUOZvX9cPhTznprn?=
 =?us-ascii?Q?O/4/uWPHKqh5a5c+2ccqoc4pz6OABKImDqZCGuiBiXDGsBeWVZ0yh+rNcTma?=
 =?us-ascii?Q?uzpVyNkf5+5SMNhETVNNVNOwiKPVzt50AiFTcwi0pt/Lxv3cKJN+TAlm0Xr0?=
 =?us-ascii?Q?qd8POCTmx8MQThp23uUmxpz+nYJE6KOCa5ME4WLMPnnJ5LI/WNMHVqBDhoct?=
 =?us-ascii?Q?LGD6jjV4AaW51eXJqLihlgfxKKhcwsTel7E4gN3S4MzbPmtU9iMeUCs+BYrj?=
 =?us-ascii?Q?vaATWPvdUti5qaQ9CTOWrWQYh/idtBEy0Qm3mjN1YEqjz5D3F5z0gEbVP1wo?=
 =?us-ascii?Q?MpXC5bZUzFCi+znCc4F1yHRILkzx48ObkizPOqZOFVlpTThmkraKsO7lEX3m?=
 =?us-ascii?Q?/CtlcNNaAuJ36S/7irVNSe0NBayVAPv4d4WRng0r/osCp6Nj0XS9vCkMwzFv?=
 =?us-ascii?Q?IxBBTx0hgMUmq9MhL01aURfrpscBYRX1ad7YhwVVKbAX11abKRcvWtxRY2rc?=
 =?us-ascii?Q?LomJexOfkzSxE7oJ8/hUYQi9UVvArDOPIfuwluXKeExS/QQnnw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NVaI57RTGYxBSM/TlV/KLVg51NNKGkj7Y9x7vo+3iN05o/XbITZErDxEKJvN?=
 =?us-ascii?Q?I2og7M0NvcV7UM0OH0jgahoYhuMzvwSijsXR2JfmOlyNAwhRDzFpATk4vVNZ?=
 =?us-ascii?Q?JRKd3Y1PvV7Uad10BaBSeCZ7k08ZXbI+3eYqXqDGOi8bAIcWTWB9rt7HyRPk?=
 =?us-ascii?Q?gy66Iw/6cWDKGJkT8hYlqiOweAqDgfpfKoAdNz/w5EGmA0ewOnF1jncXQvzz?=
 =?us-ascii?Q?fhC9IRf6ZslU5QaE9L81OXmVEGoGIRcrrOpB45jA+W9iI2KdqZmXNMSXZV3V?=
 =?us-ascii?Q?rSK7WkNZfIiIXH78CfmBOQ9gmZ+ygEuUGgt/8IHU7OAyWSiheYwZIBZSM29L?=
 =?us-ascii?Q?DEWIBVtTrFyK5JxMlyRWQx6eJTQMoFRhpOjimD7wiZGTYLLZorJ50FTetFw0?=
 =?us-ascii?Q?DwditBYFl4Iz1aFMJF8GBGLy5DmLarQ2rGQwRzql4b8ZuOgpTPyjg0IxGB17?=
 =?us-ascii?Q?sMiPIwwrKmRVP+eemK1D57p0yO0X01dPHvU9KM/hbEoi9WyirvPl0WphnpKn?=
 =?us-ascii?Q?slwsvvSznKHkCLGi2rWwoF4w/oDBBXs6JkNCQWjxIuXDfkcAK0JEk3i03k5v?=
 =?us-ascii?Q?iY0XMfmzapJA8rDC2NMW4/HUM/x30F2zNleZiLKExA40STfUc4sqzvxafbDQ?=
 =?us-ascii?Q?gGz+gsMkXmBE1SaDdX79JBUsBo+H3PaBfaV1n7MZ+kvbvdrpqoZ25LV7Yd9h?=
 =?us-ascii?Q?jcEf53Hn1EDOh24KzlHSWELCagzZhZ4bkGh4ZiqKE1VB9l82gBS8Ug53LbiG?=
 =?us-ascii?Q?orw7bhJiVpSsKNVTb2t+uEpgc9ZMnG6GO4ZWjrJ4BJLjW+GFjN69XKjqeaYc?=
 =?us-ascii?Q?5k8QHCsZq19x5Hipadkwk2r7FwyBtrNodkIS+KQwXb8k3RdGSfQDuX8sQOBP?=
 =?us-ascii?Q?UXzD9R1lvVQHqYHtu6K/M85jXGhT9KyaQRfCuEAgT6Ri2orEacdeqIg/96ff?=
 =?us-ascii?Q?6szHEvSiyb2K+8JXDE5eSiF8++B3E0nq27AuD0t04d6hSV6+HBS3wZ9CvaQo?=
 =?us-ascii?Q?m91wQ5xwZEb5x4AEi8EfuA+q71NV/ePIW/ICqEkJN/0wJxuI4K4MF8DnrYEL?=
 =?us-ascii?Q?uQ+H3XGLMH/+7BkwmIeGgCAogbSjPI3tNU1mbVXPT4ZK8F6XrW4aCAK9zcP7?=
 =?us-ascii?Q?qAI9mebvmPjVYCas9z3hhXNGT0Dho93Pw81tdA0THH93CMTN2byPSzV1baBu?=
 =?us-ascii?Q?W+nYl4RIA7x35b0kmlIgHr4FTn1UgyZG5b+PxONRvFw5AtltNYxVjlCXXyeu?=
 =?us-ascii?Q?VjSL2KnLytlA6t98BhnZAKbu4Fep3jP2ccnNvGkAkPlYKmAT5pK3Cu6vSFQI?=
 =?us-ascii?Q?S1HYp8z9nKHeWnltD/4zskv/B91w8XNRMO18Z+C1aWXqHjiIJiceYakgr5G3?=
 =?us-ascii?Q?BNfn+SW7SZsX+y9aptnRl9TXAcR4tYGvILtHpwRUTuRSQpvBqa+gNhODv3GS?=
 =?us-ascii?Q?9HCzvXS9LlG83cQaQx35kvZj8lovEN+NNtZnLwEBOyW6sEh0Gt8iq8dsUXf1?=
 =?us-ascii?Q?g0YjVlF5g1zlzpN2ZSn21Qq4XB1+lSVmU3nuZneYSurr+nG7kU1dN0FjQ4W2?=
 =?us-ascii?Q?cyd9Wbm83LEz7/LJgyT8M0LkLxfXZQ0s+KcPwO/l?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: e47c5214-4798-4207-d2c3-08dcc595c19e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2024 06:10:16.8823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cc5p7wLC60vhSS61XwmOjELfSNPiR1TyVv7RyLMw/JJHt5d/GYueS3+esBLRPym7qyRR82cWJyWg1ZgM+Uzycg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7751
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, August 22, 2024 10:47 PM
>=20
> test_bit() is used to read the memory storing the bitmap, however
> test_bit() always uses a unsigned long 8 byte access.
>=20
> If the bitmap is not an aligned size of 64 bits this will now trigger a
> KASAN warning reading past the end of the buffer.
>=20
> Properly round the buffer allocation to an unsigned long size. Continue t=
o
> copy_from_user() using a byte granularity.
>=20
> Fixes: 9560393b830b ("iommufd/selftest: Fix iommufd_test_dirty() to handl=
e
> <u8 bitmaps")
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
