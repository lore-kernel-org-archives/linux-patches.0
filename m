Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DA322068B;
	Fri, 13 Jun 2025 09:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749807110; cv=fail; b=cYVQajDEoPiv0zEMKFfEiQOmBV7d40VfmesM/ejIB40NohqYcFwcF2QUsQDznN1lzU4TcRE9GzbbzDKTCMOx1HL6C1YUkkJpisKYD84ThQKj4pu9SeMfm1+VPYEdyZfWCIFd5FkKweviG+1X5HJDtoM+zO9ITPhICQiupLRiPNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749807110; c=relaxed/simple;
	bh=Huelum2p56y/eWAonMbb793keFNNs9oYiK56CrKg17s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=S+mlq5iSjOtsChGggeNLb1uqouv2k56GYVXXBDKmQPqUiF907Z40kmpGom/AqTpt6N9BD6EyLmOnTc7eb4BgoU7oMlfyUrirbh4R4RU46NYTg4NDHdJUcVyIzpHCJi6NM5r8UqSUVv7k2Be2Vi2Bf5expjGgMSpssiAR0BkpWhU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EuO8HUfZ; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EuO8HUfZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749807109; x=1781343109;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Huelum2p56y/eWAonMbb793keFNNs9oYiK56CrKg17s=;
  b=EuO8HUfZYSBQ4xGOV8HXT5GHJ4i6rK8XEkienQ0rH5WJQqRbUL12Jszd
   bETl3hs+IUfJjoT8Rhy6/Lr5+A4xeFzWrchZ3FSdU4HFxoMIs4ZhHx894
   BpZTuT6S0ICfXLn6bORyq7Twc2MMs/wLRmzRHJFAxzEQMBC7hw2K83/oD
   Uuvm9EA0brh++78tuZXZpajVLQmxzXn7/42u47wae3s4HxKBtVr+dXqxf
   714trATVa8zkrzOltdjrNtJqFcJB6XWyhctPfdURLL+hcfJIj5qqzEM5C
   D9Qr1RIA8LAh9mshBimiT9jn5b1fq1Qd6+4WYAC8324cipFTq71X+EXUb
   Q==;
X-CSE-ConnectionGUID: fEAw66VUTd2FWriTegNFag==
X-CSE-MsgGUID: uO211KujRGil7HvZRVIchw==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51244127"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="51244127"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:31:48 -0700
X-CSE-ConnectionGUID: 6l954+gDSGivwEiNn5bBpw==
X-CSE-MsgGUID: MkbfIxAyRoGdtdqU4jGtOw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="152545445"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 02:31:48 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:31:47 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 02:31:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 02:31:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TeTBRArKquye/6KXKKnylzXqF7/SCpDtfHMvYWN2KruD+jbVP5GmLqIoqgiZ/yBorRJ6anQ3sacvvrXpwMlZWm7gSuIk7X69gh6mVzFsD37Rtrgvbx0yq5cqG9+5Hjvx3tTheYGO/rqyEOb46jYdqgq7HZbgYa6v8P9y0QxLc/gUKO5maUkiA2pB7tdTLkc4su6wvPwkRZq1ASViHidKVqPLKbpju+S6R8ILNmuZphsbcTAoy68ruDhGQ2zCfi7hwUlUzY/FLf7ytCg7mX0Ysm6I+pR+0jOfuE3q92fKvySlvP8damtCRxR9iXJ2FFksFZQ43H7uizLcmtiDCuDRxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Huelum2p56y/eWAonMbb793keFNNs9oYiK56CrKg17s=;
 b=YrLtZwhpOw22vW/Fzbn8A8tPkFdtS9NS0KSPc0IK+Qbt51BOIXzXD/ehhm2o9jNdEhGvHUYLhuLsFxu0tk+dfSY0dsOsnzWe2u7V6i8myOm5Bxz71LdnWj7o9OUR2mxXdr1fXR7XemQr0K/O6SUkrxqw0RUT+6GDbaGy/7saYMLK1yzt0CwihmVf09Q6sIpg00uQH0Js2jqlmCRzJmpl93kCPmVvVWsdrmQ+jQnkullWHocQMZ3OClivl8BTzpwFTLCjqqUIz53jYFex4wDaGBVHqnhdmU8g1+crkHSnQCEfujJl/eK6ncNquptFkxbW0GWAOtKob15ZzBO3KevtGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by LV3PR11MB8674.namprd11.prod.outlook.com (2603:10b6:408:217::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.23; Fri, 13 Jun
 2025 09:31:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 09:31:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v2 1/7] iommu/vt-d: Lift the __pa to
 domain_setup_first_level/intel_svm_set_dev_pasid()
Thread-Topic: [PATCH v2 1/7] iommu/vt-d: Lift the __pa to
 domain_setup_first_level/intel_svm_set_dev_pasid()
Thread-Index: AQHb26bSVZcmeavgEECKEu30d2mRDrQA1IlQ
Date: Fri, 13 Jun 2025 09:31:44 +0000
Message-ID: <BN9PR11MB52760E43BCFD34B050F4D4BB8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
 <1-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
In-Reply-To: <1-v2-e5c01fc5ce82+26216-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|LV3PR11MB8674:EE_
x-ms-office365-filtering-correlation-id: 3f0dc8f3-21cd-4df0-11c1-08ddaa5d1c96
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?kV+MDIBkjNh3PE+Fqeeq3qJiR4Wt9/qv2Cq0VVgUIFxqq9VKxZxz2EoPvJt3?=
 =?us-ascii?Q?NtXfB7rS6EoQay2BnsRS7viPpYzSNq6j4Q5lWwGOywJ2EfRPj/pUQz4lDtJh?=
 =?us-ascii?Q?zdEhCYnHeo2BRwuUfsKvsszerHBrawsf7f5jo6c/fO3PCDjWmoXF1i0Siok7?=
 =?us-ascii?Q?Ti60cjv0iYGq2J1cDsHTzavW6TNsz4UEU6wjpmQSMlnpWjw7rQuKuKN13GuR?=
 =?us-ascii?Q?heTUMvnVPU5LlMGn6+/KBN4gWMwKa97Os432beMktKiH1ByyYTZNWzNz9xc/?=
 =?us-ascii?Q?UuJHPqes6UdX/49a7vtmqpDIHtgTBAEEnxrp75tp/FHglLg7FcS2wC2R4duq?=
 =?us-ascii?Q?h11uC7t+M8N4hJ/bHQgEg2zE5QurD9QO+g1o4kRMVhzf2HLDM+c68xPK4+zf?=
 =?us-ascii?Q?Rrk6e9VAzCv5YqGJ6m9Od0euO4bLfa2w0ScEf8WaJ6dfh4mM5b5A40MPa/O6?=
 =?us-ascii?Q?lZIAQ4J/XTlbQE9PBdrYfc3P0PuXtyt60zJL+ld+LJKpt+Yu6TNm7UWi4Tin?=
 =?us-ascii?Q?vRaI1cWQCZlVGKr6D9vYsERNLvtciwWBp5cpr7Qiz6JKmQm6T1F4cBhAFufJ?=
 =?us-ascii?Q?azfagY82PjnkGr4o6QDZhbB32q/JycccjLOEL3rkq1Afd8G8rzObkcZVFLdQ?=
 =?us-ascii?Q?BWI8zNTqw17ANrflLUyHvtorPl1nVgpOAk82Rajm4usuTfEfIAywouhxMDLs?=
 =?us-ascii?Q?c1QKc2CnJQNpt1fTKFHaB283305XjJHVsRXbjnDDInZ8ryDhTFCW9yQxD16Q?=
 =?us-ascii?Q?VqkRRcj+o8V7j4ftEHMNnv61JxexiOxj125TbqYObT8NVK9nSCt2djYjeXdf?=
 =?us-ascii?Q?/g/d3iFPjQJEXk7nb1f4d3ff0GBkfZ1Nv6YWtxzfnpvdCj+mgfQGTAN4spYM?=
 =?us-ascii?Q?HxQcROgGDuwc95cpAWkvifOgiHBUaVTGN3sFUextWmVuin2Od8TPttI1awxb?=
 =?us-ascii?Q?4Tt5D85u1udQOSPaARjBFg1mDwzg7P9tlumxbBjATFxVrAl/0g/JT02pv/UP?=
 =?us-ascii?Q?jVGUV58smLGG7UX5ceyo6kbEjB3H++c6lK2MAVr5U/OwsWaem8glvRSf8it2?=
 =?us-ascii?Q?EbP/InmPz7e/zFgDK4iMxqMeKIVg8f9HNMBBduK47kKlg8qACNbf1y5rYwnB?=
 =?us-ascii?Q?g7vY2I0f9S16sWxWyJLrlDPNqFx8qAml6S6eskChHsXRFcYVhguAGeibXIIG?=
 =?us-ascii?Q?xl3C3uBO6wewzFVNmHK8uGq+7KpbgeF07D50et+64SUOAIPP3XtGv/OpIwS2?=
 =?us-ascii?Q?TaoYYbxoVA72wg0g5asvL+3f4DIg+9ujQPBmShV2AHaN4O1Yt9MjnyCCerzH?=
 =?us-ascii?Q?01TkFliroVgyqPflwWjumv1En6YwOnLYTlm9SAzMXBfKitB1RE+SIlmOr/jX?=
 =?us-ascii?Q?iuBTc8TDJ/AEC9cSVgL4+IMcTayBgw38i5K6BloctTTR/+Zm6Qxi7o8mSs33?=
 =?us-ascii?Q?hFtPURGNbtQDiTC3qYICUsOO5NZkNLV7G1fPK/1oRfRhQ8b3lCwjiw=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sGlgzv2yAm+vcI9xcMXzhFd1u5hFek5eGsELNSnjrOacaWattoewrQ0BUv2H?=
 =?us-ascii?Q?RAge0PN4XvO85Qqf+VUriWWXFAZDHrTPOZbJNK1g3ru1ySQt9yQlN9NalM+g?=
 =?us-ascii?Q?w7V1xWJwDJrBUVrSV/WieEQCrB/DvrJJ1CzcLytDjNJtCjeSryQOMyHXbCYA?=
 =?us-ascii?Q?6630pB5dE3jQ08cMOn/pX9MUVLHC3v242jKU18zJeE44LM7kyZxAyJPbYKdG?=
 =?us-ascii?Q?HhjrcfADws6pO9rYbeSEB+NznQ558z+0kRVwQaFdurphOqrt+RJbjO2kWdJ1?=
 =?us-ascii?Q?f3SHf3ayMNCnG5RkaJduIlWsaavhO/ryrwlT+ybkJcnJBrX9IynctC/wmEo5?=
 =?us-ascii?Q?ggX3Z0NhZl6Vq2XO620rK6goF8hS232J1PxZMFm7MAleI/qy+7hBJevhwUDs?=
 =?us-ascii?Q?oBi9EUfcz5svYaT1DOz+f5Ej+vbrqMf/Abl4AMhN1pzbAr2Y4ZAFDM+gLQE1?=
 =?us-ascii?Q?s9Q5OaiD47lwnD/DvDpA9A06LTipl+wwuInk/87eYJTI7V3ClvtGxf/c2Hgb?=
 =?us-ascii?Q?AviIoXGkLZpiEGmf6aQl1Q8HXMQ7DdBoGatOtuBQ/eLBUg7vzTC+gRMykFC1?=
 =?us-ascii?Q?5vALJKl6HNWw9YhmNEiAM63oep/UoaXL1EJq8lh2K9u07glYg9WJTbehwtr/?=
 =?us-ascii?Q?NKH9kxXIzZoo6I1y1lv/Hr2Pt0Fdu1zldRqxz0BjL769Yy0cLni22hGGaGd9?=
 =?us-ascii?Q?EQq5T8e8/awmTScdRdMU5eThZ6q/Hy5inhMteqHPgRJj0Fe/bGHnIc43jeBo?=
 =?us-ascii?Q?KI9GhHRupZWktFSjDupGfjo3L05+gixUpFE7LfRIYSssdU6AU6jRCjBRxHV0?=
 =?us-ascii?Q?dUvwtv5PKWnEYdl9w/Ilzn1lN6Sm+KPiR+IlO5i3ywnB6azVt/+cXfzMgrWZ?=
 =?us-ascii?Q?DXAACidVt25DBjDsf8N2xR7k+5v6FjWhPi5XU4jrJxSlB9SCHqwZGg20DJMn?=
 =?us-ascii?Q?nIwhvTBaHVnpaOwOEeyL4u72j6dAGHlnH6/GaxMM3ZBLSbfqCIAbyRoo6wHW?=
 =?us-ascii?Q?Z3nw30l8xwXTy1ztrul+Cb0GFnKmU6s/JBX2A+N9fAMToeTDSnqljUh/DEYI?=
 =?us-ascii?Q?CAQKXLeHyIHp6vvoKgTH9OC1rcsxp41bRSzedcsgwdaplwxgIlxxA+O3yAHX?=
 =?us-ascii?Q?0nTcxw0cofd+zZLOBKxlX22nUNzocOGsjZsAt/4F19dhQ+tDIv1Ecp0J/9iY?=
 =?us-ascii?Q?Puj4qxE9WRmPXs/AblUNYI9Yi65pxu6BF5shSFQwsIe9bRVWNG5qkv6CmOiW?=
 =?us-ascii?Q?56DwTu4atCOX/UR4fc9VGc8iGtRcBrQSBoFczst0XjaBAtOZzRWIccrcKTht?=
 =?us-ascii?Q?9NcB+N9o31N/JBiS27IKtT/1+1cU1AlQOt2uu0+hsx6kuM6dx4lg/o6lddK0?=
 =?us-ascii?Q?ZwMbGDIOWDMTRWn1DmwCc6WqWjtxyRQ7VGEMfvEklc///Sm2UPfc7vtxz+nI?=
 =?us-ascii?Q?2+onGUAfQLNT1yrdYzIRKTXNBVuq8WrMpSSO41vo7QTqo36FOdyVy2L1dxDf?=
 =?us-ascii?Q?YhinXdOBiLO6notqyZTFTWK10Kn7NxoJ78QaphU1OnT9NA8iMQarGnhKoIIk?=
 =?us-ascii?Q?NjgyOfsYs7OLonT3NyHvQjtn17fn1L9ns9wi1nIM?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f0dc8f3-21cd-4df0-11c1-08ddaa5d1c96
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 09:31:44.4695
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VJQoIeAk23NMYGUho7sqN0KCqbpqqbZdrxlcWUJc+3RZZWeYAaEybDlj4InVShiv1m3Zlg94uQkHAxB8XIX3Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8674
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, June 12, 2025 10:32 PM
>=20
> Pass the phys_addr_t down through the call chain from the top instead of
> passing a pgd_t * KVA. This moves the __pa() into
> domain_setup_first_level() which is the first function to obtain the pgd
> from the IOMMU page table in this call chain.
>=20
> The SVA flow is also adjusted to get the pa of the mm->pgd.
>=20
> iommput will move the __pa() into iommupt code, it never shares the KVA o=
f
> the page table with the driver.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
