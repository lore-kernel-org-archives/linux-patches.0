Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6E78821;
	Thu, 10 Jul 2025 05:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752125552; cv=fail; b=rBEEj+/tVQWi8AuUePbof5NUKc/leyI40bLIlQLT6yB7hQtZxO57O0/vXS963BffCXKAekYyVGk6XLq9IaoH4qA28oUeNay9fouMVGFoA93w3eUdTvVtJj38fdgcza4YI9DrVVI51+7YVGhq2F2npxdLw3Kuvr/7cSvS4LKuCNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752125552; c=relaxed/simple;
	bh=RcyeYn6X+wAR6BX9QilZNMFInsMpAlUuKH5JyRu0IuI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C+pAt+jGItgPvDG2gseVaWCffzAU9mTGo9MXXlD6qwOo33vjQxi4XmGocy7MmIVq1yJekpj9CuRIj9/hAAotRpZAIC5qJE8Wi/nLaWyxvDNBAKS8VV5Wra2UU+eQhgAYq4F1VuJEmbMWZJhnZ1H13C+mIRlE+tMPHQjJF4VY7Q4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SL5ky9YX; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SL5ky9YX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752125551; x=1783661551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RcyeYn6X+wAR6BX9QilZNMFInsMpAlUuKH5JyRu0IuI=;
  b=SL5ky9YXWQSw2VeZWPAFQe4oFKttFc4Yv/bMaqbkDZQ8KJovOpxaH0Bn
   MSPO3unpj64jqHwo82EJjVDI+aIOi+0tNk2YzVT028npDCHfiVra+qX+J
   I8Izi+P9U+ASqG82MU9huGXQl7aVPRtlaOQEKV3y/pX5gMincPgkur0u7
   tqbb5tOs3qXdANa3GpBoWPRlcKIu/XPDJhWMCT86gxO2coDiLEou1Fe+e
   PCl/fq3B7dA1RJ1JHz3qJi4fsZtXBJ1wGkzbswm9buc2ZBG0xfQK11H7a
   ZuTU5m01cwRfMUvwkLQhvzjR7yLheIOW6DqZyF4aKSN+htfbDnPRIyuLm
   Q==;
X-CSE-ConnectionGUID: 8/TVOME0ShicVu3oIO7/Xw==
X-CSE-MsgGUID: LP2Q5ek8R3mmrwKEV6C6Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11489"; a="65096107"
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="65096107"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 22:32:30 -0700
X-CSE-ConnectionGUID: iCOvLXylSDe65+RLXG1TLg==
X-CSE-MsgGUID: y96L5vYoQr2yKJZUuIKecA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,299,1744095600"; 
   d="scan'208";a="186955589"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2025 22:32:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 22:32:29 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 9 Jul 2025 22:32:29 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.50) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 9 Jul 2025 22:32:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v5hLp7udIN2VJsY/xIZwHTBREksmkjaxLgYEJw+kkghXnxvFC7y3SsMgcR9J4eVyUixL3lIHlizs1kBi6vHdV5JQRRKavcX4l+s2QAC9MxsL3P3yI6OjHqx0dAKkGqVCyg5pKf/uEkCVsCUQ9dMyRgkcNXAaDMnrBtLRferwNtl7mxWDzMpMvj61q06HAbm+nAEyi3tW4qxmBE7tcj6tB4xgZ8ClCM9ACc2JZGGpwcN2/FBhoDdjtS/f0KGWBvGt9siKqlkIhqhD+xexNYFSTtGgBwgg9i+VgC6pbQvRnRRce+gETNOHlVP9rn8E3FtOe1lm3+WMI2f9L0prg7LgaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CQjmF8mRxDGzkLSMNMm7dyBN+ZMDw9bK7dPzHYm+bpc=;
 b=SEADWBNb31vX0L48J4yvQgl5lcyO3ANJnI2Zygff19B1WZ4Ma63sV63N9C+EXC247wskQ8TAk0GXSC4VYc1QuhsT+8MEnCj1BTPwDz2AWAiQ8iDwOPYu2/YrIFRMYpbLgt1JAYLp1PfA7IM/jv2FUJltFgKMXoqZarTF4TNkf9x/i00kFrBrGvZqR3IxqKL47vuO3YG9cgqSnJ+BCACwYPG39WghqGUzMoST/HN1kxoNpWR864haXn5TPVPaFqLZW4WQFcWOOkj4hHWHsl9ebhUtR9soX1f4ldpfWMrEFYvffP0v2W8fhD0OBnE7uqObAIBC3cBmHef/8BeuGQi0kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4743.namprd11.prod.outlook.com (2603:10b6:208:260::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Thu, 10 Jul
 2025 05:32:13 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8901.024; Thu, 10 Jul 2025
 05:32:13 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Xu Yilun <yilun.xu@linux.intel.com>, Nicolin Chen <nicolinc@nvidia.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "praan@google.com" <praan@google.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
Thread-Topic: [PATCH v2 13/14] iommufd: Introduce iommufd_object_alloc_ucmd
 helper
Thread-Index: AQHb3Pat0PkyUA+BQUmger6eZELdqrQpa4aAgAGQ60A=
Date: Thu, 10 Jul 2025 05:32:13 +0000
Message-ID: <BN9PR11MB52769CFD429C3E8E0918674A8C48A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749882255.git.nicolinc@nvidia.com>
 <e7206d4227844887cc8dbf0cc7b0242580fafd9d.1749882255.git.nicolinc@nvidia.com>
 <aG3+s8rzcjeKazG8@yilunxu-OptiPlex-7050>
In-Reply-To: <aG3+s8rzcjeKazG8@yilunxu-OptiPlex-7050>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4743:EE_
x-ms-office365-filtering-correlation-id: 31c03331-d092-4dbb-855e-08ddbf732024
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?ILWMigvj2jwD1d1LyroYWp9boat79K1aqGKuuzpggfVSly7VDrKgYCUBFGOt?=
 =?us-ascii?Q?1M0HMFqI/hp4CAvNU541AR9nsGP6mDyIwrXF6AwoFMofK9MauP6Ro6FD+snh?=
 =?us-ascii?Q?29j4rmLgW6IYVyTmku/t8393PNH3Ry5sEO+TSZ4FFurWz8FG9WBNjCxlMF/j?=
 =?us-ascii?Q?MyYFFbEQvlOLm9ASoWGOdN3hB/XxPJGbHeVxiz5VMmgZ99rV/pzagBbYe7Mj?=
 =?us-ascii?Q?oYDps+YqU44zvEb/n5glBhktKKQj8puCNtysFgF8WRV6SWGOsTTBN0rO4zA5?=
 =?us-ascii?Q?C8QnCKk3wNuR78A6hKbJSGCimYJRqP5g45WN2Ftio3N/AEJDNdLAodfNmtvA?=
 =?us-ascii?Q?/goCtGuSTL8nY2P1VdsQNwDkkiZUci9xKdhuXvBJBZwT0QpUsWDwAfYcjNXZ?=
 =?us-ascii?Q?PfmKgSNYyNlRf8/0eDxl5VbqZvSvTu8ViVnm2jAZNa54JNpVOm7W07tviP1b?=
 =?us-ascii?Q?FpaVRE09TN/88OX0ztUAoXANFXM9SYRiEk2znNZ9fDaggSTojVDiK3EmKhMJ?=
 =?us-ascii?Q?fC8DHVf1Ndlrns5M5PqO1Cy04HyFkSnkQVqf+rf6FWrUm29IE5zdM0w1Y2JA?=
 =?us-ascii?Q?vER5KOzSSuBtk89HIY+zAUQb/Fr7F3XShOhX8n+oEt51CmmkqUTUWvQPyC2O?=
 =?us-ascii?Q?ixAHqSkEVqxdI6EtF0i2Imc7IqLi/17WkYLU0iFqs9o88jYMi1TnTrDeTvC8?=
 =?us-ascii?Q?7jR2DYqSGMd9sxWFvaP7wQ3iAzXOF8ZeoV6mY8LzrV1m3zJWZYhf5+f43xu+?=
 =?us-ascii?Q?HGoEH8r0HyVz67IEjpHurV3etDV4bjWW/efWhwjCvW2UUddW05i6bSO8uqxE?=
 =?us-ascii?Q?GGE1Ot9QbuaKfcimjoSb5g+47x5ASc784f0m4M2RvnQB9vQeoNkv27WimL9k?=
 =?us-ascii?Q?AIe0K1trSAWyIGR8jJPd68Ds/KpNPI7XlR5YLRPoEwlIfMtSgtksAPbVGbcp?=
 =?us-ascii?Q?QIJSvO5jxgXO7AA9U8LAJbHDdrQl/cQLgHh//it31kI55wV+wVD4dr9TIKrR?=
 =?us-ascii?Q?1nZKbJPHaXyqVvbbWbETrs0Wt+6P9mPn5+rdz9KA3fBRr2o8Ab+ftNG0cNG3?=
 =?us-ascii?Q?e6L51eZrkLz0BlIDB5gInpP1HvbyDIxb6u+y2+Q6aRuSbYZsu6ECWJvqR4wm?=
 =?us-ascii?Q?OacifW9RFu0/z/jv7FRQY04Vxgol5Yj8CBhLlywHyz5OCw5lrK9WRhQaA7Re?=
 =?us-ascii?Q?/qETY0BpmHrFSC2HM4jsGA0WghxjkWIuCY2XN0k5ozSgEeySbITCjLREeX1N?=
 =?us-ascii?Q?CuAMmW7NXzQqP51BTMuaGNN8dZdRJAUdSBKXL1HU+0J1V+eqizBU6OP+e5pg?=
 =?us-ascii?Q?yoVnZHzGGYeFyDvKnZht7R3ULFeAGTIqxxX8qhX8RvrA86hzIgg3xIifZKoT?=
 =?us-ascii?Q?Z9cEbiAFMai4eCbA988nx5tMoVKnTQMZveSEkkZaTHE4wv7dT1rZANS87dXe?=
 =?us-ascii?Q?Y6ZPUSQkbWM2eT9zYTJP2j/lxsvmCa/C74ygNP0+H/SUd1VItah/XA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Rlz4AcHCoXJYkYxpjCM+gwoBO/aUqBZc7I/KwQtUgQdmoCCHoreIXuCjopXC?=
 =?us-ascii?Q?F+Ge8lAyfWFdqARQFuu1dMf2rcza4j0ucO9D7vfi7+iroF1fPtSmAs5d6DSM?=
 =?us-ascii?Q?FPfDati28LNjQqIcM5n2z/Sn8y40MjrIy34yhlvJWiMpMoqiC0lVV9fkPcxH?=
 =?us-ascii?Q?DZ7vB9O45kkiBlkQaiVDfL5XaWhUZKWtRKpSCRfBSVNXPBI5WUTnOK0iI3Ij?=
 =?us-ascii?Q?L5002RVnKBGYaTyHz6FJTFMGzNExiSa14ujAWJK8jv7KtV2/eR+CB5v/s2u+?=
 =?us-ascii?Q?e1uIxwyNXmp4kKXwPXW2S56cKEWRLjPxDbwbcM0VLCNyrXzq/QcIln8P0qo2?=
 =?us-ascii?Q?HJdQGAMV+gCGeIOmHl32gDA8V45RL/JmdDqAq+J8WTEziu6pkdwxt/G98wBB?=
 =?us-ascii?Q?2QOcuaFxr5b8a39MPpIObJzirP2WTAfbddKT2ysaDn+7Ij7JM+UQCXpRp0sV?=
 =?us-ascii?Q?HjCS43tx+6xUMdinGu+eUeAKEGiWlQO1cA83Tv0Jjlmb1DPDt2BFio1gLZS0?=
 =?us-ascii?Q?6uzPRvvtGAc10CvID7xSLxv5RGLZWdGvUJOhjzH9cgb25npRms3SHNfic9Zf?=
 =?us-ascii?Q?ZEzD1KlBJcYDMALUlgOIjoPWW4I7JkU705B1xbsRmcoLJz7KX2kQ5joRcOsc?=
 =?us-ascii?Q?bBYO7qJRNe2PLBi/NNO1DfpKvjMe4ciy7LVhmZeS8CzUBpY2tTSKxKVry/b+?=
 =?us-ascii?Q?3cfvsZMj/zAJ40ASFMFzHwuNvGYYRSJQV0wtcIEn1hUN9usNTPEhRFG5xfYs?=
 =?us-ascii?Q?GvlGmhgaaFH/ca304lfbDbR8XKHpyKQkKuiDHUp4rwdsIVp7V+3k9UT1l8Z3?=
 =?us-ascii?Q?VDFebXsuMBvBCGGOzBhW9TwdWKV/hGMAbljl/X0uCX7eEoks1p7NjkXK7ahf?=
 =?us-ascii?Q?VKG58mOrzv/f3D12faKBt5lpkWHcEEHadViroOc2n5dztLS2hmjjOI/4w60X?=
 =?us-ascii?Q?+Mfw/pG37PMEfCJdHOaLzINiAhWUo8DTPD4flihvGOdpL2muzel6FZLafHbR?=
 =?us-ascii?Q?mkTohQtZeUlkqyQLfFVUbsSCrPxStUTqu+uscHc4AuZup6KAeWGXZFP5Vxuy?=
 =?us-ascii?Q?Wex0z9U2zVMAqEsszwi09oK4KhV7Tmz1yRDRQINFoeOdoE8SJUGqnpQK4dUM?=
 =?us-ascii?Q?zg7KAv1bbR8Qr0TXJTsd02Ubqavsbus3/yEdYg7+x1AF1npZfIg9yXciqGSK?=
 =?us-ascii?Q?rdeKhRcmeKvtzz/wQhDlPqVIr0GhWhCbHRPb+JQHi84y9z9s0JceesESVDwK?=
 =?us-ascii?Q?NSlYYfR0wNnFSvdZO89W3oP4uTYBVT8YMt75qj/wlQSLcBewv0GIrbsu03Zx?=
 =?us-ascii?Q?gMNYMNfbIb10k53M7Bks/wLpbR7nbGfQE8mZHpt2Q37bEyd3Y+i53U0HVGmY?=
 =?us-ascii?Q?IZl7qiCMEWpw89xHh8y9+DMcKlhcy1cxwM74ruZGctCweIthXpdCGiIq+r+N?=
 =?us-ascii?Q?40i62xKciuuOkFgs2UJ9wnNI4/QP+7NMq1bQ72mg3238lYB1vLHMKNWW5ZgG?=
 =?us-ascii?Q?3YT3zp2YjYKED02I5UzLTImO7/5WfZeknRESujWjDMaaXSkbreTZORJoAKpd?=
 =?us-ascii?Q?UqMxomaWoLKLmjbjrnYEvMD3zHkOwnkF7g9FBRBN?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 31c03331-d092-4dbb-855e-08ddbf732024
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 05:32:13.7246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f0FncW+HBUJmN1xn5+bSsEDI9rMs87nZcmcRahltVKdFYmjDgOGUGjfIFIxk9KEYOJRbeRF5fQr+dCDriphq+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4743
X-OriginatorOrg: intel.com

> From: Xu Yilun <yilun.xu@linux.intel.com>
> Sent: Wednesday, July 9, 2025 1:32 PM
>=20
> > @@ -61,6 +61,24 @@ struct iommufd_object
> *_iommufd_object_alloc(struct iommufd_ctx *ictx,
> >  	return ERR_PTR(rc);
> >  }
> >
> > +struct iommufd_object *_iommufd_object_alloc_ucmd(struct
> iommufd_ucmd *ucmd,
> > +						  size_t size,
> > +						  enum iommufd_object_type
> type)
> > +{
> > +	struct iommufd_object *new_obj;
> > +
> > +	/* Something is coded wrong if this is hit */
> > +	if (WARN_ON(ucmd->new_obj))
> > +		return ERR_PTR(-EBUSY);
> > +
> > +	new_obj =3D _iommufd_object_alloc(ucmd->ictx, size, type);
> > +	if (IS_ERR(new_obj))
> > +		return new_obj;
> > +
> > +	ucmd->new_obj =3D new_obj;
> > +	return new_obj;
> > +}
> > +
> >  /*
> >   * Allow concurrent access to the object.
> >   *
> > @@ -448,6 +466,13 @@ static long iommufd_fops_ioctl(struct file *filp,
> unsigned int cmd,
> >  	if (ret)
> >  		return ret;
> >  	ret =3D op->execute(&ucmd);
> > +
> > +	if (ucmd.new_obj) {
> > +		if (ret)
> > +			iommufd_object_abort_and_destroy(ictx,
> ucmd.new_obj);
>=20
> Sorry I didn't follow this thread before and maybe missed something.
>=20
> According to 70eadc7fc7ef, abort op is for the object that can assume
> the caller is holding the lock. But here is for no locking, so calling
> iommufd_object_abort_and_destroy() is quite confusing.
>=20
> Is it better we change to:
>=20
> 	if (ret) {
> 		iommufd_object_ops[obj->type].destroy(obj);
> 		iommufd_object_abort(ictx, obj);
> 	}

I'd keep the original way. The function name describes what to do,
not what to be called exactly inside. Lacking of the abort method
doesn't change the meaning of the function which is about abort
and destroy (just like how it's called before introducing @abort).

>=20
> Also explicitely assert iommufd_object_alloc_ucmd() and abort can't be
> used at the same time.
>=20
> in _iommufd_object_alloc_ucmd():
>=20
> 	if (WARN_ON(iommufd_object_ops[type].abort))
> 		return ERR_PTR(-EFAULT);
>=20

but this check sounds necessary.
