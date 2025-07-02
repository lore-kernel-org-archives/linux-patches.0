Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5580923BD01;
	Wed,  2 Jul 2025 09:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447755; cv=fail; b=sz1VV4N5McmP29z3lsKbf2m38ecKT0RkFs7i39Duk3A8o0DxFFDRbaSGcTncG/rZdjCWh1OdLVwqBcXGDGuawNCULAWf5MgzKGt/Wkx/tp4vAoSD0LNWwVz9OVanB7awCfh3+uHktlwli1qOmCE8+L0tW0FfyiKJTaY+fIFoYA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447755; c=relaxed/simple;
	bh=+HRhTnq9D7JhWGQ6i+FhesFxG4AL8C/zuQBsFjYsxMU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HpQdUAXW8XaYybr9vGVbGRSUQdCZe21zA9vY+dOImm/f0nxbmY+daI/yAxbabAx7rOUZbm6Bad/vfrWXhM7mHCaIEh/JZBOzdUiE9wo7NdjcREUNkS+PBGb4ACYy5z1hNfw7fqHzToihITnHoj9OgY/F6DPvJu5eL31QBjX9Swo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KJqK+5hW; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KJqK+5hW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751447754; x=1782983754;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+HRhTnq9D7JhWGQ6i+FhesFxG4AL8C/zuQBsFjYsxMU=;
  b=KJqK+5hWVQaXSoR10K77huqDaoqG/ELzua5SUaPAejLlmA0bwqVeI9kY
   9vrnUepI8VW3AM2zD4FWjll3tUj9fXumyFtFsWbS59Yhrpa56O5gEFRBm
   e7LgoKWJdx2Ws0Y/iDzNN6pByl2qLtdrIBPtjqDlu4Ek+FAaMybqb+7vZ
   HHJxQ3x0A3a1wXQbk2gGm8Em5gNaWs1wcEbrzV+33IZ2oOz5uuqD5+Inp
   K/N85qzKWMEqZRBgVRVp729WHbJI6Gc0Q6z9zZoTdpT3I7Lb8QphQ6+1l
   LQ6hObbomPaNfY6k/bJEbHeVaKXgoI2luB4C5QCldqE5GPo8yLAZNVHR9
   w==;
X-CSE-ConnectionGUID: fQVIKg5KRqipq90ApX0jcg==
X-CSE-MsgGUID: 4q3iV8a3ShymwJQ/S/oBXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="79174849"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="79174849"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:15:54 -0700
X-CSE-ConnectionGUID: 6/fDdfMRTf2wtvN/m6hSBQ==
X-CSE-MsgGUID: mdWR9JFtS6C3yyXjF1ezuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="177706485"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:15:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:15:53 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 02:15:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.57)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:15:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Spfef041vChtcVoWGA7C7WCy0x4GPZ7eEHDt8OAMJwNHU0aXuT8NyiJWgdPU0NY9WHipeh7Y7T80wdNAGk/MP6Z85AMbcZ2aAG3I134lvev1wBTrew02oVzuq/Xw5XWwZrlV61ZvW7Q16i6ovuZjK5Axw5da+uKV8zra692aABceducNNAnIijYzY2zOlF5PZ/1rWVRhMxyaDZw8jUMjdxy7nU7VlP7hN2aVjH9fV5A+DKuow5TM/xp4taMtLUQkyP7QDiGWfXhicOE3PbGrlN1lD91tQv5y2lfxkNSwEsCKpO350cLbHL64awQc5qgBcqX1a9P7cXGOXqhdrk6lcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+HRhTnq9D7JhWGQ6i+FhesFxG4AL8C/zuQBsFjYsxMU=;
 b=UIt4YrSh+ZR3y/CkTqanlrCU8LNFrLIbvJ6ssEqkP09UYMQc9DYucOoiZ6iTSfftIIVeBMcNTueqFw2+R1XuA0zY6M1HkUgaJfdhgKnkPxFtlVYqg3Qv33yldjqVMtoM2OQ5IPs96hIxHvrk0fmoaE8n8yHYJ9HUjDYXVQWHE9f+VEESWGtoB1wrK6drjCjmuQ9P2LInjruGtOBolCdySszx8ovfW1a9jRWojqHo9QsMV5JwxZpcEuPePsy/EWVTq+tEwj6fhC4jrnV3d58Oc3ELvqH9j/atAZPT2N6CARP79vx3G5OeEyjx/wDbof7ShnuvwYoJO8LE1dxytWLFGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA3PR11MB7653.namprd11.prod.outlook.com (2603:10b6:806:306::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Wed, 2 Jul
 2025 09:15:50 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8880.029; Wed, 2 Jul 2025
 09:15:50 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Lu Baolu <baolu.lu@linux.intel.com>,
	David Woodhouse <dwmw2@infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>
CC: "patches@lists.linux.dev" <patches@lists.linux.dev>, "Wang, Wei W"
	<wei.w.wang@intel.com>
Subject: RE: [PATCH v3 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
Thread-Topic: [PATCH v3 6/7] iommu/vt-d: Split
 intel_iommu_enforce_cache_coherency()
Thread-Index: AQHb6dBAIc/TMjnGJ0q7456haBiG07QekBJg
Date: Wed, 2 Jul 2025 09:15:50 +0000
Message-ID: <BN9PR11MB5276DC937E3D5BA67256ABE28C40A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
 <6-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
In-Reply-To: <6-v3-dbbe6f7e7ae3+124ffe-vtd_prep_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA3PR11MB7653:EE_
x-ms-office365-filtering-correlation-id: 27bf4a7b-895b-4a29-3d65-08ddb94909a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?4rO7L2SdA/p2FcbWA66IQYeX+iZildR0pSy0TjTRod+ma7000JFj2SxYhJHT?=
 =?us-ascii?Q?ixsqVfdvdzWvFQG6215wwOJlqQ2+miHFpgVM0NyQKSryGrEcLBjVQwLyZcKw?=
 =?us-ascii?Q?ed9oHU/RAKbE6yVeyL3UO+V4oZFCWM/PkIEXN6qE/VEYsZ+eQo64plz1qLMb?=
 =?us-ascii?Q?bvJQ6nomjaAF9+3UoD3065bZZH3RMXDKokVi23HLhpyHj6nk2Ws0/9kWr0B2?=
 =?us-ascii?Q?ZhTvJXhgE+X5lfV5R9wi8uNx+nnAaOeTAzMRL5iBwACjTPd0QwNErpMNvAwb?=
 =?us-ascii?Q?uEvEzQKLsGop5HBvKDH8+DGuJ1mqV5LtN7K1sL7B/mXQeNZuQA/zMWOYPQSZ?=
 =?us-ascii?Q?dm2Ncn74bMDaXIh4UB8i4Qpq+E6ZaxpfGC0BJt/F2696O4H/j0pv0BxO2VZK?=
 =?us-ascii?Q?lruxbwR6inGs2XXDRq/b6hZz9E8rhp14N7Ek6EPfV1Su3uH4C0HxPU/PwXwO?=
 =?us-ascii?Q?YJNcS9JynsqVhz8/DDCWFSahLaIQRLWOGsr82c1rmKzE6rv2DQbXpqykK70x?=
 =?us-ascii?Q?PtOLT5ta1Z8PbLRm49rOn7zJkOw6sb/3SEIAo92chenBM5r6+3TZOE75efdK?=
 =?us-ascii?Q?NnWS/Z1OmfUqzH6uzaTgwPpu83xYshmzEDLA+uGIhntHwMIUSXG3CCL7MPwv?=
 =?us-ascii?Q?/kF/XFrSI8dlpEEhCmNwgQSZg+9LWZTI4OPZ8Xto9CVWkonwgiW9iiQksJo6?=
 =?us-ascii?Q?LNuksLTPSDC2Wc6qQMW3CY6lR3TBoA7kjNsAa8TaYRvk/ELcDcxlgT4ow1aH?=
 =?us-ascii?Q?XoCTpEIRNoxMMy+pcDNHoPovv71MvLSXOvVj8RlW6CVB/PIlvPS+hllk+Dlr?=
 =?us-ascii?Q?oncy8hL2g8+4vD6EdtBsJutCI8e2kTz6Mvcg+rHiLJ9kINM0dPLJZO/pjP//?=
 =?us-ascii?Q?xmi3iSI616KMI8LabECU4AJvM8Y1Q2f23KqMduUijRrFMeNzj98hX4MYIp7C?=
 =?us-ascii?Q?f6M1cZG9mruYnvoIiHkkrfdkR3EOnzCBqJ73ITFJkyM9eVrLLHfyP1qWrfjg?=
 =?us-ascii?Q?3vPG40eiEMn4jUywtb4KZI3QJ82mjuE4jfxvbINTxNeSff2B1qQDKOgUS5BB?=
 =?us-ascii?Q?Wt8tB44dc/JKGvrZ99yrmEc8wDf7kroJavCxF/e+iZ0NHAPW4hLaW7YOOUcg?=
 =?us-ascii?Q?QR0mTY1NLzhVlMSa+iNTF+09HO+hz4uru5L2eN54nGDHZARrC64i+dKc8D58?=
 =?us-ascii?Q?wEedal6xM8brNfUtVrRb0tlbvDW0m03M2axC6mv8gHOnnQbc+4GaZLtZk3oK?=
 =?us-ascii?Q?8QmgnB9AmWqjobG7ziyBuoJCP5CM12lnaUJT3wqWqfbtMtAGNTBPtNNaT4sB?=
 =?us-ascii?Q?9EK7K4caKfNmxEbMX7yQA2C0k27fhvT7AL2YCN4rykohMr2PJVGtqrr5ONU3?=
 =?us-ascii?Q?HQ1J7NBgy+Y8H+JEhMNYQEVwFRO5hoifnMbDmh1dk8wkFpKRg6u/usqtu+Jg?=
 =?us-ascii?Q?9f6WDWtFYUTHF9mmSFaexPIA9j8Pg27JjhZLOfbXbg8S3JxRDB3/mg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PrrESKJ5n7fePFOD4Utjgn7ZTebbNXo+XR321twSe+Oyq5chcw2Wr8ojBX+c?=
 =?us-ascii?Q?3kzjE3Wgpw3P9annLPZULvmXolAUX5ZKEADs6wzPiJne0Pzo2VRLJ8kiU0Ku?=
 =?us-ascii?Q?6RaB77R1cJSkcCJFgapk8H5n7PgsYw5DBa8Q14+b7jLXqp/hZNdoCY/6FHGH?=
 =?us-ascii?Q?QDmR+i6G5hjhIXdRkEhNNuQxZTV5eogMyYP4l2bQdC8tIbOV48S7F1twfreO?=
 =?us-ascii?Q?FR6d1bZ6rQf5reaDy3Zq2EWlu0QAObKZ8vplNABWraA7u225pNnqe2SS+YnW?=
 =?us-ascii?Q?n3Osc1d13ZTKuL382ZkYoX+ID83bzUlUGN6380wIkS9opg24xeAclKlpuuhB?=
 =?us-ascii?Q?K/GCC1/N5OfjuwhZaX09LzP5phjfuRKCI67t+crpp4z/DtrS/jZg3/OK1equ?=
 =?us-ascii?Q?JMvHEHFK5nxN53GSC/5xo3Dw+aw2GajPe+jwU0iXZkckCUZ8bHA9Xye0KhIl?=
 =?us-ascii?Q?vNCpNEbxt57h9dEGjPdweHlcGRn4EFG4gUrJMTNgx2JA7iLvR8/wOT4u0xl9?=
 =?us-ascii?Q?6DBE0Z48JiPg4eTP68L4bl3wWPFP7ESfiwFAvhV+T6Ao2pQB6ijn2HSgOg/l?=
 =?us-ascii?Q?pAUnciQmtjoWvaAwd6PUPjTXO5Tf582N+IchsuVlhmBpS3btvi9QHfWlZVUU?=
 =?us-ascii?Q?nudPBkc01N4ZPI6R/EloipH+Verp/jhJIFbBmdlulgudXRs/GovEgcORKSTF?=
 =?us-ascii?Q?EcYB65y/yHJaafWdecmvPnqm1hq4nKjZcbzqBa3Hka1XQkV+vWMv4SQ04hzx?=
 =?us-ascii?Q?56r1FUgKCiAQbg2xtOymuHMBNabo3hUaMT1hYCaAE1BCXcOrGmzJpsryUgV+?=
 =?us-ascii?Q?0PNXQ7QA2TtadJsIDq/MQmhQYldS4bEmYuLRyXZxokNx1AJOJtxqD2D7Hm+4?=
 =?us-ascii?Q?YNYjLEeO21vV5e0YJDHOWwtiYrUO6U+aWN8MbVCbayEShr/90DyNKO9xxONL?=
 =?us-ascii?Q?cGuCIIzRo76Z2oLOqb+XjT3OI+vbomA76owo4GoxmcC59kebcrB53dINOMom?=
 =?us-ascii?Q?tEt6C9BR6eQSA5GUtJAeQqseGP5G9Yi5ZnvH5toUK5cH65qpfFfxPy1fOCpu?=
 =?us-ascii?Q?LtsPRWtYk94XAAadBomBwUSItF8gC6P8CaGC1e19MHNL100nbDvR62oYiUow?=
 =?us-ascii?Q?IIBROCUlUnnL2FOb32p3F+rDaHegmyByuZ53nNBOuhHmupfy7nuVJ0CYoYfI?=
 =?us-ascii?Q?+UnQ7F5jqZOMxNOwfwY17OaGguZ7wR9e3oPldS3O8Q5AUits+KgdKAwHyvq5?=
 =?us-ascii?Q?kfsnZLu07kuQYu9+f/X69ECUhUtVTLYx7u+DUIX3GkdsdGM8EfK8HsVZzlkW?=
 =?us-ascii?Q?JzH0g4GDjbnXxPeMGLu0q/X/ietbaGmJmoqIkVF5UqeAYIEwBAYOpHbVY7YW?=
 =?us-ascii?Q?XqNn1EjNxp4iFy4W6YJlByiiWXbDKwWqXcwHh473q8KiJW/riQFaupM3xJy1?=
 =?us-ascii?Q?h7E+0HyudPAYdh7buXR0mzyzqVil8K1pLpsFBN3UC92oMEkdZ7CsxUwAYSYp?=
 =?us-ascii?Q?5DHrsBSD9wWoF1EHnnxze8vw6y+hIGNowQWTUvKCyWAckiVABLG81W3P8o4F?=
 =?us-ascii?Q?BfMttkaz5odoXPqE7oHfLLHoxm5pXHKvi+EQXmkG?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 27bf4a7b-895b-4a29-3d65-08ddb94909a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 09:15:50.1302
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VHHCe+oJUNEWa8FfBudj3GJlR+Z5RxeCNuBeVlUSRbiDgnfWrUdLZDJ1xFjNTtECitmWGGnY6cH6bG1zNq8ydw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7653
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, June 30, 2025 11:04 PM
>=20
> First Stage and Second Stage have very different ways to deny
> no-snoop. The first stage uses the PGSNP bit which is global per-PASID so
> enabling requires loading new PASID entries for all the attached devices.
>=20
> Second stage uses a bit per PTE, so enabling just requires telling future
> maps to set the bit.
>=20
> Since we now have two domain ops we can have two functions that can
> directly code their required actions instead of a bunch of logic dancing
> around use_first_level.
>=20
> Combine domain_set_force_snooping() into the new functions since they are
> the only caller.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
