Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5640C1C3BEB;
	Thu, 10 Apr 2025 05:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744264560; cv=fail; b=qlJBMquSYX0TVR5sIYl2aTxgWUo6Jko7X3M/P3HaxDI4AtBJeYvglS5m9036F8DL7QBlva4V5y8OZrrpZK8B6/R2I9rrrmA75sicn1cUdbKpQUCdviFaSglR6yZ4/JynaxHjgRf6iQqFt8hPcVmFfoqt36sN2hLXzRfR4WSdrXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744264560; c=relaxed/simple;
	bh=lP3YwTW4QTzZgp3rU6mtnj3DHoPWK52yZhyGZOGI1wc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GgE5zAWFx6KqnkOjK8mBOvnrpIXdc9er5KbtJECzC50dwG0BENUmsSzU3IXdkvXmQxlkp42BYIs/zKB4XSrXJd8ldjTaw7SRnZTxcME4sY5T6Rt8HWblgFiz26Hcu5YKY2MwTmFPFyZFWrjo75X8wXiLbeSrtcN6kdUNc1wHA6c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HFPOxxDu; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HFPOxxDu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744264559; x=1775800559;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lP3YwTW4QTzZgp3rU6mtnj3DHoPWK52yZhyGZOGI1wc=;
  b=HFPOxxDuR2DxmNwFWAttVwAMHF9sxZWoQVs2nkcrhRszyLlYKnAbYAev
   duAiIIhOAE9id3aWEgpVNf8TyKXeZZijv7PLLo7xMOuK8YGezCAIUj1D2
   6ajaZXOLyCyWXIpZu2pIWdJeW6bW1z1B07HVuBuJMx6eP6WbxOyzxSwP8
   kTg2qoKc7jFrX3BjrwOHkZnDG1sUzKqi6CP9cjVKfFc9AcWbndBSjKECk
   IFDXx22SvWUJcGS7J83hCaoB8Q1c3LsjBw+/Pha42AnICKwNDrFTrBO8d
   rIU5RRZ8LWKkG892n1wltkm2K4ViqTFZVZ+MMgdXzvreTsOoA5g+mmOkq
   A==;
X-CSE-ConnectionGUID: o/JTbsb0REaow35chtvMVA==
X-CSE-MsgGUID: WrKvvhtDRKWCIxqJ0kMSFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="49605084"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="49605084"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:55:57 -0700
X-CSE-ConnectionGUID: 4Erw6yiHSOiJA4iMtOpFFA==
X-CSE-MsgGUID: pA0e9QDeSDyerngVH+/t1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="159778369"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2025 22:55:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 9 Apr 2025 22:55:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 9 Apr 2025 22:55:56 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 9 Apr 2025 22:55:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n1bg7o4SoLPV+RiOkyO/OoQ5/9Wuxrk7+j7YH4wEXvNlA7hKKg0dfglxMnbgIT+IUrL21U8i7ZvBDXbga9n7sW2ZVt7+MPEN2fwVpT7iSkVanjsxRm66vxuZvZYXq4TEyLf4NDXp5qpBcHPYVrsfNlsroSbC8PaTlD9CJZ9CPzJI1/46TgCfhXIhDeJWyNbjFECz9KPFgsqZ+Nek4G3xsVkwk1gYNHtZZNW3Dr+0MS5wafRzZl2cN+axevZalEfHIHWKrNswoL2TqeBMXjft8GU5RgkaMkYYpxLZgQqYEXGFTXruIIi6b+MAyEaEoXRktvQ5tZJgEHVhr+8Xqit+jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jrram8jLa8X7CYypXyUDZZNTX6qTThKmUD0YBF68vNY=;
 b=Mkn3fE+1t4l0Na0H2nemOrt8yMCb5QUICIZ/6Bh73FduEygzbEwOFuFa1zB835W+RF3QZMJeHY7reb3aiSlGUxNzFbUq6tNNNNLxD8iclbNGgvrHNYMdHX3wHDzeL78zUE8roeyzwyYDT4hlIFQeuehY1kni01PMIG+ZTCSMF7OsvMDRC2YmpRFQrIbZ9fWcbeu7QAEPcaDfNLHpTSBNFvWt5jj3HSJyWnkBrJcOq1SA5RPbkv9nCjGs/++qzJccuc+dYLlnPcR8i4Jc9EDyKv523nJclpt2J0NnnachAYX2BVOAztJ05TQYXtFr/FW0eUhhHUxdsNry0XDwGULt/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB6690.namprd11.prod.outlook.com (2603:10b6:303:1e8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.34; Thu, 10 Apr
 2025 05:55:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 05:55:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>, Will Deacon <will@kernel.org>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v4 3/5] iommu/virtio: Move to domain_alloc_paging()
Thread-Topic: [PATCH v4 3/5] iommu/virtio: Move to domain_alloc_paging()
Thread-Index: AQHbqKRnB3V4rrgnnkamsWXu7cV1CbOcaE5g
Date: Thu, 10 Apr 2025 05:55:50 +0000
Message-ID: <BN9PR11MB52762A98AB82CD58C41A47D58CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
 <3-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
In-Reply-To: <3-v4-ff5fb6b03bd1+288-iommu_virtio_domains_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB6690:EE_
x-ms-office365-filtering-correlation-id: 665970b3-b3d9-4e9e-b3a3-08dd77f45903
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?201f9NVLHTxAURUP0AT6AYU4LKmd0+Gw6MyAFW9NlcOLOAXqZqRlgGdXnWmF?=
 =?us-ascii?Q?McjhM2sUqc6eQdBQqjPJjtsuHcJinY/4zdZS6JjbdPIYCJJ4B8EJOruAKPzU?=
 =?us-ascii?Q?pSZ8JfakUaDw1FVxvi7SCZ2MELW7HhRnnxlK35OX87IvxcMbRwJDbQbgsK+i?=
 =?us-ascii?Q?KIj8OezeswdVcYSgWdCLZ5d0SPGf7OIONrg5QGx9v/2/tG5CSdaUmj9n8QcA?=
 =?us-ascii?Q?w8INQ1aKY3ZtPTcIqF+hbxVZuUqKr5grupf/hwoQ5wPxrPw8F9qrp18bPzoj?=
 =?us-ascii?Q?x9IC2XC0YLVJoo8WcJJ9Ps4GruTKIeftKp8n3bGsRZqST2AMgYbEPPzuBmmg?=
 =?us-ascii?Q?sFxU2Sdb/338sv9ok8Y/pLBvD0H33gzEVSDkwdUpojnYxnQqX2vl8pHqWNAI?=
 =?us-ascii?Q?cLSdCCEh1dTUC3XadR18vSH/V6qlg464hhRpCb/58qRsmYLtLsSU5rnWDwJd?=
 =?us-ascii?Q?ZBCKmFSStdjRVejfVhLNDpLu1SArgCgJTjgvaynYr0tfdr6W+2L7HCXGu3qt?=
 =?us-ascii?Q?h2Noipcrrxy76Rp6hOOLStlq7p0/5tVD+8sg1v7AslTwsb9z0qso2pGfjiBu?=
 =?us-ascii?Q?/kUUGsrX4RZ+tcmuc7utjL5hJR/Y7M28yiO9BMhCRUYOP0z8JRVwDTv3JN02?=
 =?us-ascii?Q?3Bhzue9eijuCG+ThVNsDWnzMlyXGjPNTKjLIOsYTjB7VfZXo+5niQei/WHaS?=
 =?us-ascii?Q?Sxkmuc0dg4hov9dMrexY3rQHkhv+PTmc72JE4SoKHiqcZ9KlAtlqLiXoQvQE?=
 =?us-ascii?Q?38Ae4RHHEVhyo+HRhhvb4f+pLR4wMNzrGoZUhNk0Y0YfA2JofpSmBmtWcs8m?=
 =?us-ascii?Q?1OROyVa4YtNsN68EQH0M+bDGdyuNE2TysAtDh56/lYlyzySfLIMG1Gwofs22?=
 =?us-ascii?Q?xKQVnWdLBMkRITOSKSc42hrF9/XvgPv0BKnY466TiUPsdoOnvMLvKo54ZVZG?=
 =?us-ascii?Q?XL8Jw7ORojANI/StbyDL5yIcklhfC5Sd5xH7a8VuSQ8j+0RnO7jBpYMRILiK?=
 =?us-ascii?Q?Zj+e7/5DU73NuQfld/YeVQoD4PR8l42Jt9RX06cOWM8JJjdJ6zhZZYDagSjH?=
 =?us-ascii?Q?S6J1eoGoBF6Ie9BamadqHqjzSAvH8Li5asbvb/dcYH4GtPO+x12HWRGXJDlW?=
 =?us-ascii?Q?tQhgskIN0jduWy3MaUGUdMSC+nefvteVqxFH0QsvCUnHbsHpiDdqVcxwPh4F?=
 =?us-ascii?Q?AZtETp/oeozogVvyNEVmiwTZaXxsQIzWHf/yUkWxbFIYtqUbYyYxaCUJGv1T?=
 =?us-ascii?Q?UyKto3b/kY6eOMLrUORJm6Mwsx469jSPF1/x5Kf5QWlxOe/GhRVivIbXKrg3?=
 =?us-ascii?Q?3zMv3EaMiBuEaT7o6Oo/Q6DiOJ0a/tzDVBb0Xa6wtZFJplSxQFxOvfAsij5T?=
 =?us-ascii?Q?Rdc0gr1uG2PIwyax82q5GdPEB3RE8R8tpgzp2udMx8v7xuC8VnMXsIpICqYO?=
 =?us-ascii?Q?mpNIeRcszavI64ldHFIbTCd+4D8qFElT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?pVwLGZX/ca22vvBn0WEINHIrS5curNXE2+X9jxfgQL1mNTwY9TPyeasaDWAh?=
 =?us-ascii?Q?SZkjrxxAnJcbB/qA2tUhIH23auTpvN6M5qOTX0QzM6OPUrnS+mUldqbTwOw6?=
 =?us-ascii?Q?37XzJvQBujPzQWljJNjCV6zPrZzvGkbQX3Hs3psz2ay83On7up+OcrNVKLcx?=
 =?us-ascii?Q?aaTJTRR5YrQbZ1L8p+jjJXDYhCno/MNfgVZDgjalPocaM9UIpfVLfWlJ8trq?=
 =?us-ascii?Q?3XIPWEaggw8WUddEXvWII2ATJuWrfYXV5Zqy9YVbIU46KmrRo3IsqZmWY5Ck?=
 =?us-ascii?Q?EYrCRfRtu69fxW3wrQI/7vPhczGd79c/BBm2pI5rZ67ZpzEFAsGmNt2C2WYb?=
 =?us-ascii?Q?dsMoCdbu14qZdD5sDWiEnvhp9D0fPrP6RRvzQDlvX8GA2/HU24bPQmAMyCdd?=
 =?us-ascii?Q?WWOBLrwiz0ePZ7xOa8wTyX8Hw2bO52/uOWyAel7aVQ780OBi/Av7IB99sto+?=
 =?us-ascii?Q?eLF4gKyO79beSGnTKsoBogtP3bSE2s4eO/U2Xjo3nkZ1AmlDwszCU8m8+jkE?=
 =?us-ascii?Q?kVQVwKom8Q37ktQGIp4VTpfGd/YzAtWdAqCFjYpSIt2ErsJFSE0Bx09tWSgt?=
 =?us-ascii?Q?Mxg7f+AYzfRRGye+JGGuQaojYtWqLDHYRlhxxuhl6YdDh4fXmigkeMyKRMXV?=
 =?us-ascii?Q?bhFQ7SrHQaAk/RW4vAObbvNkRWbkXViGG6q4RMATfH2TCAf4w7S7e3nagTkc?=
 =?us-ascii?Q?6/qpeOBUOXkahKuvZOfMtVHHuYjejjAqYklTMPpZd/Jtz/YCIP86U9rKxGCA?=
 =?us-ascii?Q?gfmSFEfRsOTyj3iQ/LiyH0trEOxzkh9NbTYxhTa+PiiYph3w3eSLRmDy1WHz?=
 =?us-ascii?Q?Zn0sSJwPUyu3l4WMlo/q8o8oR091vUeJWKOQO9XshA+39bXnKG1xZbalrK6q?=
 =?us-ascii?Q?J/Mh8MLJzTygP4y9YYCfAIUJN4z7+U7Bfw04obp3kJ3p0oiJsIyoLXk26kTe?=
 =?us-ascii?Q?cRI7LmL6wTQqsn2mhH+6f4vtjTSPcRU0ejnVsxeSUr2Ncj2qSH0g+ebPrS1c?=
 =?us-ascii?Q?TGZ6nS4QkvgjrckQBzJItNI7tIQLvq254olQSI5QviajLEM8DaOmzERzkq4+?=
 =?us-ascii?Q?R8842oM8QqAEXI5813xVYVh4HKfiwcZIW67x7v/9iAVCO/FXAtcXGyL3+78X?=
 =?us-ascii?Q?qosgBQpZniRBDGovMYfno2BG0TV0AZT2U3YgFLz2/+WPQsFLCrSSH0vpOrgw?=
 =?us-ascii?Q?JiwHPH9J6ocvlD508t1nsN7fmqcJ+3/XaUJjZ+23MRAp3p3D1CnH7qNa8ZvY?=
 =?us-ascii?Q?sZFJQpCDiUAWrJFP34rHXMwUiU7lN1h3ygCWHO+/KzrNxY/6gZBL/2NlRUOg?=
 =?us-ascii?Q?L3ltqwdOZi9vf6iZBb4KH7tchkI0oofKkc8wODyouDF/xNBThhcHB0teByxT?=
 =?us-ascii?Q?l6B2bdzbV0aY3QUUZ+2Shl7yPEGbY/fj46rDdvkVjpJlVzq//vuED/7/q+bA?=
 =?us-ascii?Q?eMrafeCBi7DbRUe8G3S1JNq3aQsFaeleEWoxATD/w06V9AkGJPhpQQYwOC8E?=
 =?us-ascii?Q?55/8MAbYpqWmAbnKO8t3UAegwLEPGBs2ZAvZ5Il5kCTuIdMJ1zOc96d4LiN7?=
 =?us-ascii?Q?9jmsHUT0bjN6bF4m/142xwD92nkHmXTfbc6RVYGL?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 665970b3-b3d9-4e9e-b3a3-08dd77f45903
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 05:55:50.4997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BINQhKRq0DndzdS1NN5yDjc89eMXJvfz8n1jDE+M9WWoJpBUpXrdCE1KhEM3YHZCczXyiJVxHKCY5fq4rlO+kg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6690
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, April 9, 2025 12:36 AM
>=20
> +static struct iommu_domain *viommu_domain_alloc_identity(struct device
> *dev)
> +{
> +	struct viommu_endpoint *vdev =3D dev_iommu_priv_get(dev);
> +	struct iommu_domain *domain;
> +	int ret;
> +
> +	if (virtio_has_feature(vdev->viommu->vdev,
> +			       VIRTIO_IOMMU_F_BYPASS_CONFIG))
> +		return &viommu_identity_domain.domain;
> +

Does it make more sense to keep the @identity_domain field (same
as all other drivers) and rename this new ops to=20
@domain_alloc_sw_identity() so it's clear that the new op is only
used when identity is emulated using paging?

Except that nit:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
