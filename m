Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E2F20A5F1;
	Thu, 12 Jun 2025 08:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749716244; cv=fail; b=ASMgol6D3V4uaQnXOEUw3D8EqSrGgO5isR2T6Wh2qtPyNDxfdz1z+kiq0qSOHYE8TLlkQODVnsEsYGR7VlJ5pLDBU9CI++U2fC9EX5OGKVMFWbGS9i38fVFTQGXIjYfuG79HIgiNn8QM6ZS38/ZL2nsL0ZI7fjn4/6QJTh1kXKo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749716244; c=relaxed/simple;
	bh=yxlCvG+yhzHsV9jAw1KTFu+RoZ1mu0XHaU5o598QyPg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q8pGk6QYY5AYjIL5LoqO14bSKlj14bAG54kKC3iwjt15hNXDNMUKws2wQ/9OG2BYLt861rx90rVMgBdchJhg+N55JMDaryeVZQByJ2PIJ8yHNpePn6spytwCba+eEgNsxbrCWEd7ELD96N71m46QA3NcG4KRbj/A1JtOtU+OSUU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ShfB+JF8; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ShfB+JF8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749716243; x=1781252243;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yxlCvG+yhzHsV9jAw1KTFu+RoZ1mu0XHaU5o598QyPg=;
  b=ShfB+JF8L+NukwKsPWz2D6CbBNZi8n4XvEA4SFIFgeCtIeSDqFfxlNk+
   t/YP5W0kgR6Xvfzj9jTr7maErTkn+XfAWtIAfCf/5ohDSO7RF3Eji8zAp
   9CMAh7NdRsnVIgY40O5j2hhLz4f8s1xYJk62gMsaFx2kLybGYXXrkQOan
   orsnCDAn8ZMJj9nH6/8rGdLczUUBZFrBeNx1AtZhUzmlUvRVdeW0UgdQZ
   gasPsFsc8lChQs7DDLnVVTgTs6aH15hU87sPk3jDEMh0uYsJ9Qg9UsnFT
   DLDpjn00UbyNBt1plO5Frpjpt8HxMGnuD33MTi4vF0dEF29MQQOmq2hYb
   A==;
X-CSE-ConnectionGUID: EuMywwN9TdCZzPeT2YIOpw==
X-CSE-MsgGUID: wyV2Smx8QuulSAXZ3c2EFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11461"; a="51967748"
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="51967748"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:17:23 -0700
X-CSE-ConnectionGUID: Qy0rUeFqT0yrKpEVxgeLJg==
X-CSE-MsgGUID: fO1xrJrLSNSNkclWB0j2Lg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,230,1744095600"; 
   d="scan'208";a="147354921"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 01:17:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:17:22 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 01:17:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.76) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 01:17:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ekUKxRPeZMR3xLlq1X0zDUqSJtGaqTJ7a9s9xzoBmkEOtqsTBOsqpPznDR+/BCN01uVePl4kIEqhkCiuqk6mj0uzvjbXHlnoSHlTtEeaMIfxg/U9KqQD1VK3ndFHmVtxqBRtxkpRvbeiK3fwhIaS5BxeXHi+AVuOQv1Fk5SvtdTydqDm8bruOiuZGZ40sScUp5OeNlsyBSn0v7anSK0VN/9mkFS6hRJyf4KXma9OEaqfXakkRQ6VqSsMhgQHemHZe1flZSkww/so3RJ9m8Wwyyj9x9d7coQwc/cPW4BJYhLgyITIMLCpRgQFnVKzVpXx0WMxhG4jJLsBZUAXqhiqbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yxlCvG+yhzHsV9jAw1KTFu+RoZ1mu0XHaU5o598QyPg=;
 b=u0NnJ4ycqEDzFwkVbSyRF6V8rwVkApNvVTxPzZjHbEVTr556CGbmusVjYyYD/qFuNRY5gyECjG9ylXJxXcXtbFvT9E5U1nHtlx9+a5Vtl9YAUs/53XJw+yzRkqeMzaPaeSldE3zqVCizdW7u4K/R26Bxbi4T25BHBHXjRyrUiJospSTpeSJ58wnrSjVDPmIOSslBNbdUILIVLQ2jQ1KTCYYcHMt9F3FUZt8sU69et2xNt8BU2vxrHwG4mZVW0rY9AtMKjyTX/74B4dfjiyZXIUKPcnpFRjpMHMXppZfaaVzb7jlfoKG1RMH6Uj4eT/ZOMlN18AoTIH43K4GthF6auA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5936.namprd11.prod.outlook.com (2603:10b6:303:16b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.19; Thu, 12 Jun
 2025 08:17:19 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.018; Thu, 12 Jun 2025
 08:17:19 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>
CC: "will@kernel.org" <will@kernel.org>, "robin.murphy@arm.com"
	<robin.murphy@arm.com>, "joro@8bytes.org" <joro@8bytes.org>,
	"ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L" <yi.l.liu@intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "jsnitsel@redhat.com"
	<jsnitsel@redhat.com>, "praan@google.com" <praan@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 06/12] iommufd/selftest: Implement mock_get_viommu_size
 and mock_viommu_init
Thread-Topic: [PATCH v1 06/12] iommufd/selftest: Implement
 mock_get_viommu_size and mock_viommu_init
Thread-Index: AQHb2WHztBj7S2Bb1UaLrnu3BFfNbbP/MVJg
Date: Thu, 12 Jun 2025 08:17:19 +0000
Message-ID: <BN9PR11MB52760F8C5A8B6331CE5588778C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
In-Reply-To: <5880f4d754b2b7a7c4bc8664a5b954821c73aab7.1749488870.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MW4PR11MB5936:EE_
x-ms-office365-filtering-correlation-id: 111f02cb-5d14-40b8-cd04-08dda9898cad
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?Wkju+znu+bvtVjtUn3BwA0T4CDy5bqyqjNh/4xRw0sOnRtpN45Q1YLhgNsfK?=
 =?us-ascii?Q?T1H0lSN8ajyxjOpHcG8kIyPebnfKfs0mX3lyKGeZvjJEPCa+O35Zdi2IbAW0?=
 =?us-ascii?Q?n3stFj4/wRaOoyZ/tPfW7r+kzgeqty9rCOcB0hsw/9vP1yot6uaeL+wV+z6g?=
 =?us-ascii?Q?jO7xrmJG/Qgiaq1HTAaqPRXipqBzoa4YkUME4Xy+Fl7Qr9F632OmrHo6S1X1?=
 =?us-ascii?Q?ZjDQhd539mwMA7RsSJleSQrrlx6oBEGDRE1LDasXls5DkpDRqRgBLItN6Kfw?=
 =?us-ascii?Q?l1vii0j6z6XRY4D4buJ6fVsb7v+lT6ay2Z8BKO8fefXy9MYMlRDfbb0MoM9q?=
 =?us-ascii?Q?I0pQxYzLCQgMq+r11vV9rz0+nUOR8U6U+vC2YcFhKIcqr2QdbIQt4qhwLCgK?=
 =?us-ascii?Q?ypva99s2pGg2Y6vTmGEiNrQOGvbwRlUvvh7HAwbeTc31q1cXsNuDMlCFV/+f?=
 =?us-ascii?Q?9QRNHheaqtqCYlUmeB77DX4ahI0yToj+cTNhTR1P1zmAiADWLmJxPXsjxvsp?=
 =?us-ascii?Q?u18sn4K5PLvSNv//8GAOuXTGawA8WiiWGQ9bVkvoYSuv7oK8ECHX9XsmwhD1?=
 =?us-ascii?Q?iKOonyYVOS4SiWdpeqlbAtecEDh3FEvP7udmbyXSTA3R7mKVl0Xlno9E1zBu?=
 =?us-ascii?Q?/ZCdKDtiBWUrr2+du0QGBydGg2xmzp4H9s0MV3WetHVrj9+ZHCvl+DmW2SBv?=
 =?us-ascii?Q?O0G3xi+bL/UV/5hrHCJH9rIj1ESRPF3VvRDwaVkrRPwDFDA6imh3c1AJb2Uz?=
 =?us-ascii?Q?Umxz5RaT0vW3XwcvgTHMXXnJYK9WCmzSP4ATJzpLtCvDT81CybqPIouvEn19?=
 =?us-ascii?Q?wFXMSAVcI1vlRmexHrknUjxdFNgZhrAZa4inc+g0pu53VDfaQllfZuAieAmV?=
 =?us-ascii?Q?tNIUgdK576eQWl8QrpqN3aukXM6a8WYWIAhAIgg9WaK42abK35uzXcETq7Lt?=
 =?us-ascii?Q?SUad2IAYKvn6ZZFhVVv+u9YUzOEolbEuII6kmrq0a0oRiL2u8btFLGlEVYzI?=
 =?us-ascii?Q?11ssBUsFnAVHusWiaJNzV/5H6xrnkQrAHva3594yYtD6iWSjLjedwhSLi/5e?=
 =?us-ascii?Q?2k4SYAIMkDF4JW7aq+MhbiMoJ5pM1loYxVi3K+aFdAtJtvtuwF3XLMHv09eV?=
 =?us-ascii?Q?Z639sMK4AFln9kpt8oPy9y87iGFFj2IRzt5eQXf4dPFBQsWHYfGrYaA/a8wP?=
 =?us-ascii?Q?MdQpG/l4BIro8wJEiathwjXkX/4WbT4GOD7BodwyPhNk3gIrNy+1wR0OOwcA?=
 =?us-ascii?Q?rsepqg/0TbkdIvwjnmngG/7SVGQVbBFPb2C4zZXUwbS6ZVvGoMW4QRryE7Qz?=
 =?us-ascii?Q?JEN25lh7Wy85RIw5XnwQIrcXhfYwIUixGeyM4ToiFHvUoYhxL3sgvYGzpolF?=
 =?us-ascii?Q?Krj/pLrUvsfvIlAe2Ba2Ph7L9ZLYYu3ym38L1Trj1tXp7wRZfqfQdpKJ1CJ5?=
 =?us-ascii?Q?shMWzAViaRgKNhRTnwsYJcuiGhImQVYRGNMiMoHEEvyxLG6nPUl0Wg=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7C3Z5WR3jwxWxqnKqJK3xR689CYAoxuUFvJyYoUU/ZgvetouiDVS0ZM9tXiT?=
 =?us-ascii?Q?EMLO5+Ud+dseW2R+oExByPvac13VO73ycocya7l4ilKRNbGtWAfwrLlTfypa?=
 =?us-ascii?Q?Hn5QymNxx+Vj0F8HazabQOnwKCoa+iRbZfqLu8SS6tCZo2OI996stQC1D2oY?=
 =?us-ascii?Q?HVdfy5pFmgk97d8xFPvEOZ8XI45LgaDY+bCg+4clQBGeXezTQc3PQ09YmQfN?=
 =?us-ascii?Q?9atbuOkT3k7b5g12pFY7durvnfRF/kvqsUHD6U8fbcs28GSZktyoBApAVC3B?=
 =?us-ascii?Q?EdvPUp+qzCIJ2lWIHUaRBc8FihOgdJZtAiHjqKazDq8rTtT59VLQOnkZcM1R?=
 =?us-ascii?Q?rwqN+igKpugYUSx+HgYMKbHKeFT7Htv7WAs3hJRd90ATp1Rmx3SxaII2fY6r?=
 =?us-ascii?Q?/3Nk5li059Aqm8KVitB2q0p/R6+fi8VM80sv901IpwQFSkXFhSIMKZZcBO44?=
 =?us-ascii?Q?uJtPQmaiJPUzwSRvKZVTnoR/ZoIh4tBX3KI1VSUBFfCFr7nl01GtbUDg+0cE?=
 =?us-ascii?Q?aNbMURPqS6wkJFLVKHdKLRDX4zW/HgygDeExSGhZ49Q5LPZ0bEN/jSite47X?=
 =?us-ascii?Q?XSkknN4Tqr1IodTdKKGA5OHYJnaMztp2Une6lkEKdmPAAnbpqLIJrj0LilxO?=
 =?us-ascii?Q?ecq6/1+gIVpFWOb+NbNi3c7HLxU6NJJ1i8IMbV4dTzvbs5YNE/u7fFjljqe+?=
 =?us-ascii?Q?mfBISABZXDluwoIpTd3unLhVsOUuwZWKdVxs8x1h4ZhBsp4nMPOkCZEW46VE?=
 =?us-ascii?Q?qjfd16HjdaLfHRtXdmR5RLoND0yeSUs8t5sfLuksMkWuaK9s9oTArsgMZ7EU?=
 =?us-ascii?Q?Ol5ciaKdbg8hx1FtYGicWGpFtaqnBWOMH2OuSLsDIm2MnU6/a0oG6BtTYZ9d?=
 =?us-ascii?Q?pOCLrbXMHtxfmApaeUzVFj8bBYNNw4H2Tem07Fmr04if3CgO62F/Ws8QeNP5?=
 =?us-ascii?Q?Bx4qFIn6lESONgKvURFDcO/SZYWq9RIcBUM/LllwQ5kd1+ZWtd3FKl0HE6j5?=
 =?us-ascii?Q?en+xd7kSfzJfYe9+J6faUC7JctKWHyHheHHI+ciL4Eu5KP6/UTojPfHyMNty?=
 =?us-ascii?Q?hQXCZuby+X6i2//x4rBOHzu1acl5NDwEK61Xt7vg7arL7E9tlittAaiqYFm5?=
 =?us-ascii?Q?lzJiti6vK07ILMPNP2AmINSyrWPIsnJCoj+l1tfOPZRRm/UoTszU4hqNiOXg?=
 =?us-ascii?Q?HPt2PJP5J2AOf34EZ1bwqfrv1BvBRW/BELsOxrqsU1N0WFgxgQME26iqINpT?=
 =?us-ascii?Q?Wu3YdKhFDq8F6u48ozTVxBT90w+TVT65mU6c+HCox+Rq5Te3MD7CvYQoCj+v?=
 =?us-ascii?Q?bZoCCSA5+PhPCIsQczfTEOPO3p5cJqJng3P8VTyvyINZrUaPS6CnTMcaFecM?=
 =?us-ascii?Q?6iIzWyfHe/jYDf4l41ByQO+ryfNb8O5klvVad4+SLz0T0ju1/fDXwcMnoS83?=
 =?us-ascii?Q?A3rdN9qLm/0JJ+A+Thcb4frf+bZ2tgy1ECTBoyDqzF0f4DnYdU4F88zTDPM9?=
 =?us-ascii?Q?4TT6m0YXB5XDv4h8TEJWZDXYOws2zhmRqcETASuHnHS1pmxL9OFp1JesE0WF?=
 =?us-ascii?Q?cQxw0wcOnKF+FBPR+SjoA9kFbKvFMReB8pNBpmOA?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 111f02cb-5d14-40b8-cd04-08dda9898cad
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 08:17:19.1737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: twRsMLy2LHlX4mEO/4wsNEl3JZBf3DNpoxNHzf5RJJ5DC169pv5ZHmw0zuVN4NvGd+3n7c+JE20Rvhdup1OUiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5936
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Tuesday, June 10, 2025 1:13 AM
>=20
> Sanitize the inputs and report the size of struct mock_viommu on success,
> in mock_get_viommu_size().
>=20
> The core will ensure the viommu_type is set to the core vIOMMU object, so
> simply init the driver part in mock_viommu_init().
>=20
> The mock_viommu_alloc() will be cleaned up once the transition is done.
>=20
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

btw I didn't see where mock_viommu->s2_parent is set in the original
code. Is it a bug or oversight?
