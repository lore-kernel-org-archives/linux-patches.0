Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7EE23BD01;
	Wed,  2 Jul 2025 09:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447790; cv=fail; b=hOptnrOaSmGnUCHxTQu4yi9JoiURR0IHvZM45SF3GyTozds8Zdc3Hp341/AgW1c+V4ytzs5ALVVuul1fa5Bu7xAlUQQIsIVEJOurZoTNywDaXI914+ef97B8C/7QISbc5ficUmBl99ilZ9wcSve1oq4+E6g97kOs2tVFQhrgK0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447790; c=relaxed/simple;
	bh=wCHmhnE7H2uVjDPrDFgvEVkNhVx6m88fFGbn7dMD/Nk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SWd1SIvYPyORIABJog1/sY3Pm+9kPokhCC8bpU1KygwNWqFHQ6S8HSyhQJyrRMrhBxEqeoJsUEeAbkcgDYtgmOV0dUaTTpMtrzSoHuoSxZvBuADjoXmivvyTVeCdT+cmIRJ922+/HmvjouoVmiPIOykGYo10Nf5v0UXHFyLZDm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xp9dWY7x; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xp9dWY7x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751447789; x=1782983789;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wCHmhnE7H2uVjDPrDFgvEVkNhVx6m88fFGbn7dMD/Nk=;
  b=Xp9dWY7xSaHgaCMnyo9e5qtG6CSYL+Qn03M902g+mLjnrZp8j2mqKDVS
   xFnhhbX7Eo9RVfwnvKFKIo4i5IGNhckzJ9ywArKCCyzRUG6wqU7L6X4CP
   nXpd3fC4C/At4wseU3I3gQ0qJ6WO6K8gt651a/YCkAbyt23gcnWtYnnh8
   UcV3ZXibcOZZrggpAJQZIfRoxQSFSMyH0zJi6fx7w2j17qHouYZSrF/gf
   UUYA0N0aK6IduPUrlZKsveQyOwRtU4gz0iz4uMSdSZCxpT2i7YU/jGJt9
   szNQhWtTn1OPnKce+ur0WZ/bLXP3OgRKiX6Yx3vXT7aDPVkVcBRscS9Ew
   A==;
X-CSE-ConnectionGUID: 34cy7lpbTQmHaDTxFsZ5WQ==
X-CSE-MsgGUID: dztQOU+BTLCl01hEBHDKfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64782370"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="64782370"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:16:28 -0700
X-CSE-ConnectionGUID: rCFWh0bwRZeZXYF+PlEVJQ==
X-CSE-MsgGUID: AIdQ/PM4R2iUSGnM0wbu7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153794807"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:16:28 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:16:28 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 02:16:28 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.51)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:16:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m1R2XNGo9Ruct4YhkbNDQR1af+EMhFs6/pWOuom3UbbpBciYdJrsMdrPbP8jHGCWiYbYllMZX6C6MnbrNYQoh8VTgueyT0tiqwj3TYtgPBXFaANmxJk9CKFPv1ygEuz0LrUbjPM3ypdO/5lMWYpH0ZwNszQrz1n/0d4E2i6vntbPWBqeK1vyN3f+hQLLXeYGd5ySsxdoZvTq436EarhD4Rug1Dno+ieTKoZnpz7qdJyfwjdjv+R6QHLwtaDlwkm6T1RXMhJzBgNJo4uxbU32q5+PUlEpB/RVbLjSBKIDuxx1AydpZAtwPoCQojZk4B678wgiai7cdk+9fW3FU3BXvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wCHmhnE7H2uVjDPrDFgvEVkNhVx6m88fFGbn7dMD/Nk=;
 b=tpbE9HwmMDj7yBYqEmqbVdDlWdGX1DA1PFZEZY/SJnULLGhrJEPawnJqo3Awc2pSEEiJ9VOjUj62bnCYafpIfW5/B1vfbK+xc3BdLJwfO6Jf6gCj3BSJ0zQaAUgtheXyRjD1OuDVBKQwPGjR6XdJEQ/prNOKm1WkIXdFOhaQWBpzJETkYzetlbXaDoqOSjvqt+hsGpfrnX85YS+WvZNJYXQYUMvtYAcbXaOAQdRO2P161/WUcbqNDpEM9wg9x8Jk3gmt155LKEq11RxEKkL4nflds6BCCtmLjplSj2OFAcOXc2On2WSPocpE15iY4sg37Vpf+th7L9bvWy+jUNAI+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7653.namprd11.prod.outlook.com (2603:10b6:806:306::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 2 Jul
 2025 09:16:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 09:16:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v3 7/7] iommu/vt-d: Split paging_domain_compatible()
Thread-Topic: [PATCH v3 7/7] iommu/vt-d: Split paging_domain_compatible()
Thread-Index: AQHb6dA/eXiRSU04QUua+g3z9rJ607QekDCA
Date: Wed, 2 Jul 2025 09:16:11 +0000
Message-ID: <BN9PR11MB5276C643BD28236A01F1F3CE8C40A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
 <7-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <7-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7653:EE_
x-ms-office365-filtering-correlation-id: fdeb8eca-2a38-47b7-59d8-08ddb9491656
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?iMvEcFCsoT9nICULExAEYQTx4UDBPnqGdmj4pHNPcYJnQR24dbMATTxpm2/e?=
 =?us-ascii?Q?iNOi+oF0sKVB2G0fFSdm62AQRQEomMrcFBrpz/rN7CPzBPMBOoT57ZUJNyjg?=
 =?us-ascii?Q?mh7tLYdhKk3WcUSURBqjL9GzMnyw0PjajWj7IyMp3mNT1i0CiBWXfIz1s2QB?=
 =?us-ascii?Q?1m29MqGz95j4bYdcVVjgeOZOFxwWQAvz+qhf6WHaINxF77PNJhYJ+Qtb0Ph7?=
 =?us-ascii?Q?rokAHWuxIw1cUKt+MbU4NYSFrcvWd9u7BbIWqaX67XYtiAE3sFH5piO2bsvO?=
 =?us-ascii?Q?VYi9wHm2p6mWxp505EqmtOufCDD/zIrTglBcramouRHrop6gB2R/dFzelBpz?=
 =?us-ascii?Q?epkIsyCMJ9PrfP5DgUZrHZkUVY0cuI/Gvt6IwzQdN+VtsDdtA9g2Q46BBvEg?=
 =?us-ascii?Q?Vqg8VZu1Bis7v2Q7N0Jawh6sZhHabi+doSpO7fwUV2W2y532jh5jDFGrvoyp?=
 =?us-ascii?Q?m/i1C+r3beHkbohYuOXqYQuDs9L8a0elnIM9V0x4vp913nIG+ff6DVT9rMBr?=
 =?us-ascii?Q?RhvOLOIXIgmjREwUYikjCfHF2cLQ8hR1aJMEkX0TBb/wQDjZSPZFTscZlqtO?=
 =?us-ascii?Q?8OXiY6dTIzSiiLZgptyq9gDHfqfTKF339shgdLG73NNEb9eEjT9X+K2q/TFg?=
 =?us-ascii?Q?ToxMpELX0w6Nx/bYyXyE2qoN/zQ6Z6CE1x0ebTxqb2VE09HFLa33FyW0Cf6g?=
 =?us-ascii?Q?CG13aYwtLX4ZdRkv3LMJUe5YhdUV4U8+1dw05X0O/AjPXZds2GutlS9dECMd?=
 =?us-ascii?Q?ikx/IAwbReLC7Su9hj8fhcrKFu3+HHuVVapVsCJAb9MavKnCbeYqSiEW9F+B?=
 =?us-ascii?Q?zFMMBoXpDczO3T8tlvnygubTfKJ/hBY6Wx4KdzjNc9e6YM1igjcj/3qtI3vT?=
 =?us-ascii?Q?O+R+fSHv4jnlb7SmpE76J6RShz/EDLQUqzHnmJ5hJLvMrkZQzWcN8gVC1BXe?=
 =?us-ascii?Q?RXG8YwuJAzi1l3ClfFXr0Wn6y932Agvz06ysXanMOYZQr/lZEcA631ZSdOSd?=
 =?us-ascii?Q?RAiSqXFZaiFUxQftRH4rAT09fOcN6fYXTHbyK9gAxl7kBDpTwsnRDsAoo8xr?=
 =?us-ascii?Q?E9diiGGiBHDasDw/auurlRJuDy0mbREoZQVlGlgmUOUiuM3p7BKavdyojpkv?=
 =?us-ascii?Q?yiat2uM1/ejLtIQwHVHpxO3kPg90GkmI1RTMU6rXElyU4hu1tBv0pxTvxQq4?=
 =?us-ascii?Q?NU6bFSTqtLCy22W++nyY9iNkjceteSdPhP0bJHw9Kx57qGkYD7vBNQtoLmlg?=
 =?us-ascii?Q?yV2kQK1gEci1QKEf5rLzSH0LDe5ew72XJd2vbFoRVUMSz1J5/pkGIJiXKCIf?=
 =?us-ascii?Q?Ht1i4fbL94Cg/zZfWyirY6DcgAO2WP0GpiniqT1rBgu4rn9b8kSFIIXGhxZh?=
 =?us-ascii?Q?BLIOx8V6ffw8IWfocDehTJLu0zJyGJI7pcdn3SpxB/v2baLMFmH9an40tM5e?=
 =?us-ascii?Q?EWDiY+AiX1TAWJ2piIPX9zHQT1nFInmuN4CFzVsyVOmvMlkYeYhnPw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xaYKwR//xWGVMWLHF9RKUES1NSBv41+df5mcc4ZaBMMlmpqTKfHzTgm9/YZV?=
 =?us-ascii?Q?L4nKjZ6TTL6qU4yt6QP0IcnxF+m8DH9Gc1bf6OykRfNzlwdGTYtQvVRRXoQt?=
 =?us-ascii?Q?Oen9vKo8yjH2nTRoCZu+HoHDmS9Z73mCT6XhQ4F1gI/U1zk6P+5vHF6FOjcb?=
 =?us-ascii?Q?Gyku9jvR8OPIhZMbR1gGlbkNCahgIOdW9lzK5yOlDGoUtGNYEl/YSG3QcjuU?=
 =?us-ascii?Q?4pKXwlSX+t+UMo6eQIhkXKhY8RJW510EDF8aVd6ek/3cBcml/rm2Mv98RZQW?=
 =?us-ascii?Q?u2ceW0fVyoiib+kuAZp1zj8ifWVEM/fP/IfQ0MPG3/zCLj8SM4ALvBe0Yn01?=
 =?us-ascii?Q?r5YGSPwGUf+ftWy40FRdREMufTH4I4CVd+rMr76m6sbadl+SZZ4GvPpmYyNV?=
 =?us-ascii?Q?Iqxnn+hyNo7OWfehOA1VaJAz5dZA5BORxbKouLNVeVzmvk5drN2YSIVrbmjE?=
 =?us-ascii?Q?nJNFoZqPFx/FqMepUrFnHW8zKkfyZDLTxa2aTxO7dvwZUyLrn/MjOIpEjGt5?=
 =?us-ascii?Q?4I15vJS5htp4poRmPYmBWEYseko1mfGpa4tmUcvZ8z7UWtGmSVKXL6bt7ek1?=
 =?us-ascii?Q?E9l0sGu7xwm7q8mTukN5YTDuwZxDhp5z2tgRKzpxAdR9EE6lU+caEAc7QreO?=
 =?us-ascii?Q?sH4jseVxbrUxmy1Sn5h+YLCgBJx7FeBReHyXvTNmSGDttKsJkuWuxP+v/Zrt?=
 =?us-ascii?Q?PjenHaZ5BJ74rX9lgrZfmOxQ28qA3kUDggJg9DBnSilPKIJrWZAVtrR7KrEf?=
 =?us-ascii?Q?Jd5efpIVfRBPflaro0PffaEBYo3n68G7hEZza3CCfFcn8En9qA/xWemy0LjO?=
 =?us-ascii?Q?xvAb3TtTa4HPJ1DXMJzolAiqPvrRHWnocr3TFcS1KTQr/lQCff2KhjmyCgwC?=
 =?us-ascii?Q?/wzGGJgNODqCVEwLTvtph4SNVVK1NsqOzIg/ZaPO78GZVRR1pIfPpe6j7cum?=
 =?us-ascii?Q?QFHnpIva+kZdp2WGHLvWBssSxorUZLttLMPIZJGLXOvTHSnwPDsZ0zX8A09q?=
 =?us-ascii?Q?JVsp3lpdjKNfFpXgZ/QNMkqueYfZQC0vSbSEsRib7tkJF+Vf9VmGi/5tzrq4?=
 =?us-ascii?Q?dq1UDamOiGcRX3G4bnVcxNeE2UZ57iWoht4qHVxc7tRzPOLXf7LxgIYGROt8?=
 =?us-ascii?Q?q71/4t3fXpLJHk6qZVcXMMM9H77qjDVHeSTHuVVX3kYvP9lltGhvXZch3KcQ?=
 =?us-ascii?Q?rVcD8jtn/xbiIBLmC0Cw207HQ+Ny0+jpQr7HHwUvgXtXxPV+A91E6Ni9xHrW?=
 =?us-ascii?Q?5OG/uzAD9u6qFUaRybxgl6jy2VbI8dO+FPBAnS/K0OCNKtgenjfI1A+roIBl?=
 =?us-ascii?Q?Vg7hGzYx5zeUF752gPlet5MGokaUzJ3CidRNA8DV3thveOwgrCEVKaQA5q5w?=
 =?us-ascii?Q?/+N/P1GOfQuNh8e9yedro111Yl9o9bQenC6iz+v7SvhMsONaTCwmS/2jzkSG?=
 =?us-ascii?Q?tGbJA1ExNPbe6/V1pJKLoeP0smEaWmrhU1ISL8ppB8EIDB+JCuECeQfCpThK?=
 =?us-ascii?Q?ntnpLlMb2eK2tU7EAbGzu95COCMJQR3wl7EPSAM5FzkjvPzAPM71S8EYNMag?=
 =?us-ascii?Q?h3bdJbzy5T7iOXz4ZqEvM35ZpE9PoiN9uAPBULG6?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fdeb8eca-2a38-47b7-59d8-08ddb9491656
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 09:16:11.4306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zsKjhDXVqKRere8108v+lTEevEzJlACBbl4f1g5KPlHJaUsLJXNXLlVmx4pEfMZqIMadNI1o6iQnK/MElI+6Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7653
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, June 30, 2025 11:04 PM
>=20
> Make First/Second stage specific functions that follow the same pattern i=
n
> intel_iommu_domain_alloc_first/second_stage() for computing
> EOPNOTSUPP. This makes the code easier to understand as if we couldn't
> create a domain with the parameters for this IOMMU instance then we
> certainly are not compatible with it.
>=20
> Check superpage support directly against the per-stage cap bits and the
> pgsize_bitmap.
>=20
> Add a note that the force_snooping is read without locking. The locking
> needs to cover the compatible check and the add of the device to the list=
.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
