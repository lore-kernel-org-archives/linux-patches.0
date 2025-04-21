Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C60613BC02;
	Mon, 21 Apr 2025 08:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745222596; cv=fail; b=ldRlk4Plrgkzm+H5gCnqsAkFPC3JMdfhBvs7lQetLH/RKadA5TNOjxdth9Rw18tORjQP6u1EugmWmpOjdnHZmiVluEWlAT/hDUmY+qxYioW2myDGju6j6zB/oE5q/qquLjyaTyoYh5Olf2t8b7boKX2m99d5hWdNJ0GeNZ7kqXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745222596; c=relaxed/simple;
	bh=3aNvKMqjqAwmV0PFhOH6Q2A660VsQEbHXG/mUGJGO68=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KmB3EoRYyaYSeAYkAdEDv/fT/jEHQjlHAj+oPjNA5G96KhRAvgpKrWqwRKKf1BK6IAHiHM010gWwX9Jvwkf/e3qiS/qhvV84n6XaeZRZKmkeYUfDBRlpN2W4RXWP7h99QNEFEmeEHC67kG9F6OBEiWb6xCHSytozD5C0IXlVdIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hrh5tfoV; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hrh5tfoV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745222595; x=1776758595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3aNvKMqjqAwmV0PFhOH6Q2A660VsQEbHXG/mUGJGO68=;
  b=hrh5tfoVB9V33ajIyISz+OUbDfVS9SY4CAqJNhiK3jLQP2zjA8j3pwvw
   KzF9UMyuyzRqhj7Nt7FZjG4SSSJR2SnsD2oH9B/Cx/B9UnmHDHvGtbNeL
   buJgPKVJoev6jSjPYIspdOGL/pnRB0NCpfg2kuL5EHbgeY1lUIJ6m78V7
   gQYBS7ZdQQyk+FDr2oTiTPxcvpWJ9gFkiJTeP8EjrmZebxqmSN7ySfWy5
   el+FidOoM98c8M3uVEXOkCp3b+ofisAP/bbeaqD3IfoG1GUq1vy76LogC
   CdZiduzF5SlQ/ICZPzAIjPcXFWTWGc66ulDIgLXNndt1RiK1zMqSXKg8b
   g==;
X-CSE-ConnectionGUID: BP1KhYgwRqiUW02XaW8Gsw==
X-CSE-MsgGUID: c8MhB3c1TcKfqgSovopXXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11409"; a="57411022"
X-IronPort-AV: E=Sophos;i="6.15,227,1739865600"; 
   d="scan'208";a="57411022"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 01:03:13 -0700
X-CSE-ConnectionGUID: uy04CdrHTKu15emeOfB+uw==
X-CSE-MsgGUID: WN5exNyWQBKGjwnVaG6Fdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,227,1739865600"; 
   d="scan'208";a="132178190"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2025 01:03:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 21 Apr 2025 01:03:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 21 Apr 2025 01:03:12 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 21 Apr 2025 01:03:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t4gn42wzN7MaM5F0hhx446pjYouRqp+/9lto85+lI7Yrl54etEby2ss7zJpqOhz/5rdfM0I1urdHOeUz7SvNiTEHwKlNxLZVeCqTXq12rhmPG5pNkR0N3RYrj/QoXkggMBQgtyivDjusHLPC0v2haHhfmDFnipuyOgMe9rL4mhh6DyyK/vmti/biIq5koBdi7r6rK8E+6xHOoGDeZjw4N9czSrkcnxQSd4xt0zRRV+bLDo5/7ohQajRI9cVbIP2+VX3knDxujyrm4I1rNF++DrGd+/toNAD4LFnYanGgPCdOu0DLudaWn8qc3YTxEMtquHaeT4M8w2yfoMjvFlp7lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3aNvKMqjqAwmV0PFhOH6Q2A660VsQEbHXG/mUGJGO68=;
 b=ITXuy187pS/nHevZiUnWu9Udo09c+YVj6R9RxUBZqk7ldcRII2cj4oORvPxMj8GQ7pCiyOZNbunpv5H+8cfmOGRMZt+N57NESlMsWmbV3o5HxuW1pTUmioiLrWOc5XWLTKH23KO6aKhutm7QVHVFLVyDFf4t47A8c8W8w+RBg8fJUDL7jGGLUdkdmDoQhE9oUL07TmQNcNmDslm1CWdwg1TRMW/fZ5ikb+lsqL5mvGvua6rnGH+mSSluAxtDyGBng9AaGtqr0Hhb+8bL4L4NddZuRR3ItcVRvxqzwCbbchsGkkejFTmMg6h83FhoNMAVXT/xZSypOk0pHVcB0FiluA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ5PPF5DFCDEDFC.namprd11.prod.outlook.com (2603:10b6:a0f:fc02::82e) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Mon, 21 Apr
 2025 08:03:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%6]) with mapi id 15.20.8655.033; Mon, 21 Apr 2025
 08:03:01 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "will@kernel.org" <will@kernel.org>
CC: "robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
	"vdumpa@nvidia.com" <vdumpa@nvidia.com>, "jonathanh@nvidia.com"
	<jonathanh@nvidia.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"praan@google.com" <praan@google.com>, "nathan@kernel.org"
	<nathan@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>, "Liu, Yi
 L" <yi.l.liu@intel.com>, "jsnitsel@redhat.com" <jsnitsel@redhat.com>,
	"mshavit@google.com" <mshavit@google.com>, "zhangzekun11@huawei.com"
	<zhangzekun11@huawei.com>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-tegra@vger.kernel.org"
	<linux-tegra@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>
Subject: RE: [PATCH v1 08/16] iommufd/viommu: Introduce IOMMUFD_OBJ_VCMDQ and
 its related struct
Thread-Topic: [PATCH v1 08/16] iommufd/viommu: Introduce IOMMUFD_OBJ_VCMDQ and
 its related struct
Thread-Index: AQHbqqxdpMEow2/7uka4hFYHk+wYmLOt0Z7w
Date: Mon, 21 Apr 2025 08:03:01 +0000
Message-ID: <BN9PR11MB527607DFB6B66CB9B502B2648CB82@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1744353300.git.nicolinc@nvidia.com>
 <db035b1fad8987558b5c435ad7f9350ffa34aa1e.1744353300.git.nicolinc@nvidia.com>
In-Reply-To: <db035b1fad8987558b5c435ad7f9350ffa34aa1e.1744353300.git.nicolinc@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ5PPF5DFCDEDFC:EE_
x-ms-office365-filtering-correlation-id: 62b7bcad-8813-4460-4392-08dd80aaeff5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?S/2k+ttA1RI00DOzKggQnnfUe2YkX3EUwhs1eDY2np71hrDU7Xmfa2P1woW1?=
 =?us-ascii?Q?pvQFy4lRDIOdUX1EM0pxCSTA21QF6lPdwsBXbyEQ874aYMyIsJjOo4sq4ZGf?=
 =?us-ascii?Q?IS0j5ntZNoRNdzLG7z7CkbJxyTRQx0sB3f0rZI4s8DvBLFJh1mrANAwXZqkt?=
 =?us-ascii?Q?CHI2JMCOjtNO7NdlSK8lyc4d0H5z7StSCwQBiD0AtPdpllrgYfAA/+vBXuw4?=
 =?us-ascii?Q?eFrnBg8PAwq7QARrKnI+CJiWaDFwlSnxIMSJj4Q0Olfp6yiR53DWJpRr6H9w?=
 =?us-ascii?Q?yz+pehCpCs73g9gX4IVF9Y/BQ7WWEiLx7MwA9fXkpvwnw4sHrZ1Gj2HhVrLq?=
 =?us-ascii?Q?29Ov6pI5h7S9qxdCNKPAOfyLoTro/k8uZX8Oh7+u1PpjDbI9vWrHsP7D9+NE?=
 =?us-ascii?Q?vp9M4BiZGTjJ5O9HKT7gJf1LsRJCkzV8hlZMi1KwatYjy7dkd0KWTkkKPflm?=
 =?us-ascii?Q?ZkWmD7q76aO3aTQgU/ntFwZcg1NcGThDqZbB3hqi+P9ILvW2Vl9phIra1adj?=
 =?us-ascii?Q?W+wli01XKOgafXZgxdJSjwC/Be2k65i4Gj6SWYwxWsGAh5MoXR2IutcUnCnk?=
 =?us-ascii?Q?7xcfhJXgKUiZT+vGanWzw4VSw0gM5+WG3YDFDfQICT9b4zkRUATc2VtSsjAO?=
 =?us-ascii?Q?JRxTqcyCxQRtkLOZj9QNLYL60zPIXg3ElZ/VoCzJsg08JssaAw38zP+noYWC?=
 =?us-ascii?Q?RwEWEsEzSbX9GZvT8JeI9dpR21X2q8mhQZRO1Qnds30RcP5TTq05Yu7YIKQ6?=
 =?us-ascii?Q?5m5V+vSatGwpQf7KcVSj6rzeGX/tBCZLBZm37yOp8DfBJspNo/+z/Xn79BAx?=
 =?us-ascii?Q?dpwKSVWw0ARrHVBAQDsz9tNfb3eigCfjxUfL2nO63tz76kmgAzSnVpmm57uu?=
 =?us-ascii?Q?5Tfd+47O0ALaN7z9+u5Z9Ze3GB+o1EmBFBnPzKr1TsVI+X1X/8R3lXMfaSYK?=
 =?us-ascii?Q?hTvjRgelIbg6xE4bhbKw0rtRNQrT6sw0eGy9ChDXqP5DWZdMg6dEXIxbCFp0?=
 =?us-ascii?Q?BCf0sCo6guckJd955pRyyplzZkFgzh+wD1P3F1q8zJ+N7BYcHJaK8ItG4RpP?=
 =?us-ascii?Q?UQ2HVgq7Nzhiwjl/DBfkP+jskqeb71Cxkd9Lc/le1QqamG/O8f6C12XoJGbI?=
 =?us-ascii?Q?yG+S7RZqRA25Ndvm9UkvlWI+qFRpkhmmZTXyKX5GxSvgnEcWqScIbvJlX34G?=
 =?us-ascii?Q?iLQIF/MSVUDJT4U/jh6OYLCqhWxRoEKblOmYQXmJLFDJifME2iXL82ngZrJr?=
 =?us-ascii?Q?s8XaajZEAOoMgmt+QWHED4e1VvHJym9doCRx5AMxoy4psU803uqYWyXV77sj?=
 =?us-ascii?Q?3kbM++NFTG1JbXcutL1sjwpCUufCt5AI52mwA1IT1rs0+NQLeBgXiWN7/j7s?=
 =?us-ascii?Q?DjhppxsgzzDablw5CAfxSAN3mUfgZniTLmTmHwZebb8QsQ+13znfz6aNZIff?=
 =?us-ascii?Q?l12Ze4UgJGLCkmf5v+XjE7lrBPo44urX1EtJqAFIhbwS9AaWYkGFs2jIFu//?=
 =?us-ascii?Q?Uyj/PLVKX0VRWZY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RUf6c+2MG4Phi8dhqRqtFGihOnTuKerZoYsMZrpHBRxAT9uwgIXPTPV3dpFu?=
 =?us-ascii?Q?5ugGga6eQMb1HP4En9ZeB8k87GosXP7vGS7lv+/sjW4GgqBpfCW3iLdiOd+i?=
 =?us-ascii?Q?ALyySyORxNTW11h6MSrUtJFFaACS9llPZy7Q8E0/fGlwkN281I718suqecGG?=
 =?us-ascii?Q?Fj5pkKXxC8+LIQZgJix/q7I6us3kieuoa+oyvxL4bdJ5tcjI7GvZMZv2QjpA?=
 =?us-ascii?Q?QXKfJ1U47PGBHmHwNMIJUcgvWRusO8b1TPuIKJh1EymfJE/5aKBnmucSHBGg?=
 =?us-ascii?Q?ILW0Q0Q4+hGK5k+axWv/HD8RBhhjKFyW3+l692gJ0/uj9kJOiecwj4e6YsFO?=
 =?us-ascii?Q?U0MGNvaRh0t2Wr4CuMX96hP5nxf+QtRlPhdYP/pVDmSXZsxqn2+eR77/VWn5?=
 =?us-ascii?Q?7TAeMg+KyD3LUu6ku3g2ulCNCqkmoTURXsf+iRFS9HeTlxEMm5xHWZJ2IaJT?=
 =?us-ascii?Q?CDSlOe3rNYn/CbS1vhPslyRVumBMEvt3plpp8I8SP8I+qzMtlLJ+PPQcjnN+?=
 =?us-ascii?Q?y7VttJahXW7cleT5Iod/IOuTuBnHsoU/g5eK/SKVizlR4RX9JnI7os7+sJiJ?=
 =?us-ascii?Q?het0Tvrs53EZR89dILGKpKH9c7Ch+9ptHxr8mf0pB40xcSVUEreXLYkfeKiM?=
 =?us-ascii?Q?+0OSurN30P5T45JynqeWgbeI7Jh42ppzPGdkqAY4Vi4+hg/GgNELfl6e3vIB?=
 =?us-ascii?Q?5M4i3CUm9qmjRB2voHnS87lcokDGAibEta5E+r8tXTqMVG6Kc4MrBsdUWGLR?=
 =?us-ascii?Q?tuHXSAf6NneY8VdqnpSJfb2Dfhu9EU58BEh01b9QB9plVw6aBCi74DO8CsPm?=
 =?us-ascii?Q?keScYiuY8Hq2B9IBKIxWx5iEEX7zKJkGo9pvaLie7qio7KMDV2eOwgclVKZe?=
 =?us-ascii?Q?jpCHI8wcEaDJZmvNjbL/Z/4B+vLw1MdvZ9zn+8w5tLKHxxgYogT6k908mPA0?=
 =?us-ascii?Q?cgbT2/7/+d26aJLn5Ls0m3QLlAQFHm3P65dCzPDZZoaopZvT437Y+FPwXgBn?=
 =?us-ascii?Q?Z2udcpe7v37eL/JL8uCm3KhRfZSnyqA1jUTpBLqNNY7N1CcbCIAh6B+CX/RX?=
 =?us-ascii?Q?aPR3u1oQRquR1ZiAui7mCk1D1R4Y6UTH8l/x6TSjZGsKY/FwxjBXbpgwiN/E?=
 =?us-ascii?Q?6fjcx/ipHE+0qvT2pyDfc2pvNf3tZq8Onb93eiyzVyM3n8ffZI0W7zh8SI+D?=
 =?us-ascii?Q?ZxApz7v5kfxmBn2jk5aTDQXEz9hObO2KxXdEcrCoNpLoYY2g6lseVGpXB2qP?=
 =?us-ascii?Q?mHENnRbxQUrv0V6Ub+9c00mOIapO/S3DMjMoghSLmc8tXUiUWcfz3ha6wUIL?=
 =?us-ascii?Q?LLm7fgszpgPDcCVdud9eGd6gZYujrM1s7j8spKXn6rjzu+RRIrynOqeLPRFP?=
 =?us-ascii?Q?mv0Cg3hRoWExS2C58Xjkjj33VUELmgCI4HiXcHGsspR9G0FlJjSxsaK7RCPU?=
 =?us-ascii?Q?6LQmt+DLaTJ7owHtIYwpQUeDkA+peuPRyMJ3RR+fbbQpnJTx8wtQNFFUo1Is?=
 =?us-ascii?Q?7hKqolQ9lYSEjyoD1rvyQ1oXnq8zIesLQW37IF9IrU0Jj+BktHZNOKY17nv9?=
 =?us-ascii?Q?+vx3dKL4zikW81caMpnpWHLBKLqUaqu57+/sNnbI?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b7bcad-8813-4460-4392-08dd80aaeff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2025 08:03:01.5008
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EUhSlH7/DZEWgPzg9RomnL90wH1IUYijSIRSF5JK/ZDRI6+GW49rxfzrgGwFt7Trzwevi4aSBa2Hhar9e5BTJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF5DFCDEDFC
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, April 11, 2025 2:38 PM
>=20
> Add a new IOMMUFD_OBJ_VCMDQ with an iommufd_vcmdq structure,
> representing
> a command queue type of physical HW passed to or shared with a user
> space
> VM.=20

what is the implication of "or shared with"? Do you intend to support
an usage in which a CMDQ is coordinated by both guest and host (which
sounds insane)?

