Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D646F2C3774;
	Fri, 13 Jun 2025 07:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749800203; cv=fail; b=uKUK6BN4R0B0xYQ1hsGtUANDJTFGZRmM1gAQIctOjkFIf8T+kkZHDs25LojGXN03aE4qRk96J1mrbBqx26S5Fq1zF+ADIN4TwG7d70E13CN3K0uHSe5xxH8Q6I4Ng8/BecAoiWjxBLccHx3ZCEJucOUaTN8sEoBdhO2RXaUqdIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749800203; c=relaxed/simple;
	bh=IAiPDKDHTC5sNQq8Sj+cOnpwfO2Vm884Rvkpb+tpC/o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ex6ip+NMwafRXPOS0b3NEjrujKNY/7sp/ki8/EkgPnoBWZvhk0J9etQInmACoX6tQALlBwNGDf29EdYNSnLuaxIUXFzAF/X78g4CHVz7GupMK7Eighm0R7KNVv6+i6CrJR4QK1HaqgDkAXft9TaJTeXMEEOVfYHR96h8hnLrEU4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PlUCwHJG; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PlUCwHJG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749800201; x=1781336201;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IAiPDKDHTC5sNQq8Sj+cOnpwfO2Vm884Rvkpb+tpC/o=;
  b=PlUCwHJGhre38GKaeWcTN+1qhQCEmWqSgB6YIwwDgd5BXQyBvuOn8gO5
   g2BcFT/ZmkyNUU8l9DiUBL0y83bdbmutAq0qkmkkYtLi1S7muKQs30mku
   rxQSLNhn/iAGPJJ2/0OYiG5YrOuTWZKdeE5FWgCpTUMDi7vpRNW77El1A
   LNm2j+Qtg9OwB9I1sBEVOQ8Z6ew+kvBsNjsnpEnqEYxpPr6Cco9m4rwL9
   ZS1CIofGLEUHqqPR7WPfx/1rCEUAEtdnSeqXE44Cb4HU6w1Fisr7ajueU
   HEKg0hesAc5Rb29L6ycl86gIwC6s0lrKuCmAAxis0xCiN1ShwbOZUhpmT
   A==;
X-CSE-ConnectionGUID: pw8y71z7RU63bR7Z+ctoiA==
X-CSE-MsgGUID: 1xAPPEvfReCroo8bI6tqZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51927377"
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="51927377"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 00:36:40 -0700
X-CSE-ConnectionGUID: vOjxpx9+TYa9KUL6EKsf7g==
X-CSE-MsgGUID: uryrwITwTYucXZAb8D/lMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,233,1744095600"; 
   d="scan'208";a="147633859"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2025 00:36:39 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 00:36:39 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 13 Jun 2025 00:36:39 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.66)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 13 Jun 2025 00:36:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X2YxuMpxSQr3RWBEaUMNxFhQhXa/APaBmIjnjIRglyk1TOcBQ8JwQoUUGYXQJ77w/TGpOXpOz/nyoA51TjsFcwSIOyaHCAFxGy5IPwPzN/HvLGNr5Xx+zJEGB1PiiAOauS1udsH4uoSdU9AztwtTG1bElm9i8VXk3jLR9PVghFm84p8JHhndTZtxYyl5N8SCeZtSxoeQ4HC3Vi+NSOKpi/e5DIeL5akAurBLa/ZTVBb5tSv+RNns5pBZLez+nhkoRwCdFytnKsjqj/NS2I5bi176mx+T/POgMbDs77Pe3u93BlR7MRw1RxuTRUhkWqOUhbEkV6AGG8p267t8aCupyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mT/6KouluPvz9HWKyo9zcKuSmWsMLV/OP5cETSTtMw0=;
 b=Nubyb7THk7J6dCuj7tj1WSvAYQK5oNuRi0e+vVgigGQMJamxgqoe6wsB9vm0HtJ82iyZ2LWfdj3QX05zTSn2cxvPEj8UJlQXwD/nRev86IIUTO4n4rjyRxW5dZlozJV0PIMEhy8Flnb+9jIUcQmlA66wEInk8ExLcIlpKW2IBjtJgClQHVObUqgU8pxjI2LqQfF1Nab0mFcGqIPe0nRVU9coceFgfKs1PrxL0U1GV8/oFUgmCWv5GNd+gVMFftzKIJy9aBP0koNYLMtaw/V1+cZ6zX4KiioMKQUzj2RdKyFLphFnG0g0FcbrYkK45nbZX/IyvGreymZwjgSxTqMfPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6202.namprd11.prod.outlook.com (2603:10b6:a03:45b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.29; Fri, 13 Jun
 2025 07:36:31 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%4]) with mapi id 15.20.8835.025; Fri, 13 Jun 2025
 07:36:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Nicolin Chen <nicolinc@nvidia.com>
CC: "jgg@nvidia.com" <jgg@nvidia.com>, "will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>, "joro@8bytes.org"
	<joro@8bytes.org>, "ddutile@redhat.com" <ddutile@redhat.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"jsnitsel@redhat.com" <jsnitsel@redhat.com>, "praan@google.com"
	<praan@google.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>, "baolu.lu@linux.intel.com"
	<baolu.lu@linux.intel.com>
Subject: RE: [PATCH v1 07/12] iommu/arm-smmu-v3: Implement
 arm_smmu_get_viommu_size and arm_vsmmu_init
Thread-Topic: [PATCH v1 07/12] iommu/arm-smmu-v3: Implement
 arm_smmu_get_viommu_size and arm_vsmmu_init
Thread-Index: AQHb2WHzLJ2ABt636UCLQu+hzyE9l7P/MiKAgACXFACAAO+RsA==
Date: Fri, 13 Jun 2025 07:36:30 +0000
Message-ID: <BN9PR11MB52768A39F3D0594B3A79686A8C77A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1749488870.git.nicolinc@nvidia.com>
 <55b1d69b2cceb685d4eb728a7a53572a9147993a.1749488870.git.nicolinc@nvidia.com>
 <BN9PR11MB52764E40612C1293699E43F98C74A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <aEsL2mxfO0x3isog@nvidia.com>
In-Reply-To: <aEsL2mxfO0x3isog@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6202:EE_
x-ms-office365-filtering-correlation-id: cc4ee7de-9b15-46a0-0281-08ddaa4d03ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?us-ascii?Q?YPisDWgf5RgSeJH6GVLM5/YmxH1Mkc/qQF4kPJ4JA2gJrjVpRIwvZzMhGWsA?=
 =?us-ascii?Q?2Ev+32jqExpNTnwcsJEN/VG11yRaU9cIFarFELTjDK8UB88N2dLNO6JJvXDT?=
 =?us-ascii?Q?3PM6nu2PjZvp49BnTF01WXw7h0vwb2JE0lUy4HihHQneghkmM+FkbpKd5yeR?=
 =?us-ascii?Q?OX1IgCFJmNAJO7+NVq2FZUfsFBwobgybFdS1PwXWo+LnDYDeHDpJ/qZ0xNJ+?=
 =?us-ascii?Q?3yRuN+d9Y4qKor8dGpx87mH9pFre6csRSf0jwg9l30O8Lyawhat+qVP2Y1Bd?=
 =?us-ascii?Q?l/FHBbAENn1d7xDnIyw+MtoepVzAJNsp7j2V2ESOs0Y0fN5zN376Z1NeFz9Y?=
 =?us-ascii?Q?fbiHfurN5DGFMrUNnbA+BngZypRt6I6ValuTCP+dp3iU5RKL4irPyoX1i3gk?=
 =?us-ascii?Q?MGA+W9LxH7XAIykNDTHy00FZU3ac/kyKw1DVhENiYVLnujqFcP8kpv5EryJr?=
 =?us-ascii?Q?gSd2nBShshrJGypBraT9D7LPvZTUXDJzNmx48vjgfyAcdkpUA0xgJ470fnEE?=
 =?us-ascii?Q?wHXwLRubQbJJ9+aGLpF7WFBp0Mz2n1qPG8ryFrMtOo0bLCUbhNPPn4AJ/eKJ?=
 =?us-ascii?Q?DDW21La8ZKcJald0IaZg6jx42npBp5sBnuXSyaLz/tqWXQwvDX6tfKrnBOyc?=
 =?us-ascii?Q?QUyfg8DW18bFGzY5S4iy/cLNbXW5bMTqV04zmvwhmYmlASkqD2DEvtR0mgKV?=
 =?us-ascii?Q?x/s4f29Tejd94BGq7pUhb+AttR/fMoy2dACJ6mkXYBlxu9ragfjLf2FvgxAc?=
 =?us-ascii?Q?lzmpt4lsJTxr4UIInlYeGqrYksb6Am6OSV4FDKFPtuc6/pAphqgSvYNLTods?=
 =?us-ascii?Q?VTin0NrGd3ddvA7gFr9Kpv+Kt60Q5BtHi+c7Ajor8UiGmsnIwl4dlXWdSnfk?=
 =?us-ascii?Q?c3QyOsAMGj9/1Pr35KI7i4pOHBuJBRrRM4tWHBGrxWGagyXTW1TYc99kMx3i?=
 =?us-ascii?Q?WfIRbOyJDqpy/HgI+Hw+YbYy64fTSBmUZJBf23SFL4/h6mh39Zt3Hl9kj95/?=
 =?us-ascii?Q?vK8f19ot8PUS7X2sX1ofwHNtQDoo0la+86e4eMbhUSfrtQHq/SpF+D6GkuW9?=
 =?us-ascii?Q?JtwILnTryprgs0uns4kPeb0Qxwud+aivzGy+jVDjrhVyn3rCY+g759UtrXPC?=
 =?us-ascii?Q?iNxYLWopflK79IHJKNb8pFkO5FIzoZVTkgp5swhelzIN3f6WzplobqMBRln2?=
 =?us-ascii?Q?jIOBl3FUopIf0bHocLo2SHHSgDgAyOe2AaB+s64La7JflmtDNwYDXnPKQaDD?=
 =?us-ascii?Q?Obb2OWP6p5mZM496zXO9x9rjmL7NntXZmTyD8M4fXD+BVUCHz5ZvOK/+MNyL?=
 =?us-ascii?Q?gp7A9mHW0mjLmd33DmunSwKd75L2mXpowEAhKY+nPCF9iUqj0Rp7eAEVPjVq?=
 =?us-ascii?Q?c0HyxQZY/4CoiBYnpFU+Bl7cw4HLaYZfwW7Ai7QYXP9A0iq9QEL1qjunwRZq?=
 =?us-ascii?Q?l9S4VqCQKrlmHcuXRZX36WatowZ1q169OevPT4d8n6f7jtlsDIim2A=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HnO5l2hseF20G3JuD2b+6L5A1JD8mZjpR/qceZeITUuCbVT6xgsXD9YSXcIw?=
 =?us-ascii?Q?s3CAP8sIyhAFG4Nmt1Fcyy9AmXsyLnR0INNe2CC3DQ3ob+aGVnDDrg2bb1+L?=
 =?us-ascii?Q?uOALdxKZWakARLFHgfma3FWAps7XjGLsaxrIjwxuoLi/d8aTC55BEs8k1hRe?=
 =?us-ascii?Q?XbvN2sgBvY0WwNwrRfMp6o2NW83P26A4whOeczAq901I5ow1CD4qRRRETJmZ?=
 =?us-ascii?Q?Zs9mIRMah6S1arPokPFH/G0HNYnkWS+VgKcdAKnhItwT3C3i0TX9/yIB7JZ8?=
 =?us-ascii?Q?m3INBUAkGpgNvi1doEimAocBtsx/dXy0bN5j66+JC+WqHk1IT1moPwG39o0c?=
 =?us-ascii?Q?1eSJECE/zyYJas3X0EsKFxmhkA+++q08fGcNNStChPyR8LJPNc0kNZlQe5Dg?=
 =?us-ascii?Q?rFE7P22izj3jAxc8hv0wegMSi1liC8Ex/mdAFNNN4K+GStC0JLXqrD7/3hOv?=
 =?us-ascii?Q?6YSlrXElNsatkEhMhOOzwO0lB/mIL0GC009jb57nJmS5fc4UomwynDZDgr+G?=
 =?us-ascii?Q?Ps6urFkBfDq5NQutY9rsR0uSthEYnPS+SjF9mlhwt8B30C0qAm1lNTDIOuN0?=
 =?us-ascii?Q?9CP/yubWfF+C1QOPxl5hBdmOds3gbSlXnhLQTJLwdxkYIaxOJt8ngBqo4XoG?=
 =?us-ascii?Q?5UCg9JAPTonIcUaqxT0v1gNIYuKiTv2adyBkcNu3XK22P1MgW9uG0Yv/TCNv?=
 =?us-ascii?Q?+irXY8pRYTgV8FE6ZxtigAf7N5sQd3WWmp2YXQ5u+5+4moaM7TmrUb2aPNRo?=
 =?us-ascii?Q?G/le1Ue5X2oYOSRDHrD0+/j7onpUU9gQiN2+kyGbP2+yh1nzsf5xXE8UWS7d?=
 =?us-ascii?Q?ZnTFI1Bk7e92pAK12vsDrAYE2P+qIcqF3iRaGqIsFc9KpkVUdE9FDn6g/TfY?=
 =?us-ascii?Q?bQbgd4dqSUaVDw4Gj6u5yzHmpmWufWnVyR8NGwC5Dan0wG+WrVC/Cg5JcgU+?=
 =?us-ascii?Q?m5O1bqzKNlXUGoUMMNOOWZ9J9SA6rPzzj0eOtS7yYg+HhRxDZOJfrkevS9jn?=
 =?us-ascii?Q?RKNcYX4EZHH9e3vRpkxA9iBzrHDJetxw254y8jlHj3NZspdIN7zrr2+gwEx2?=
 =?us-ascii?Q?7niLQn5TQTHUM07CBRkREVpWsyXZQeauONLENwME9UglQ0fOjviIhJjUmbKI?=
 =?us-ascii?Q?3hMFGmDiwV/yBLb3rUkmtpDTDgA1h2xTElIbNRRdFzZYdU3Bh6h0Ceabhxaw?=
 =?us-ascii?Q?4YIoB7vyzrOWjOW7LAwxg1/AAKQ4OAHIChpJtVkhY2z3cOcw+A4AvcFZCOaq?=
 =?us-ascii?Q?SH1B6SMHrbFQvKsLR1UI0H8boD40qaP9009L+OOzygbYL9CNuvM9vEsWO5zI?=
 =?us-ascii?Q?IAIxmlh7K/4tUKTzW9A/eAzcT6QpeeY+ooQwn83YxVDZOWU80u73kBoUbXeX?=
 =?us-ascii?Q?y9m1q9caNt02GiK+eOaDw8/0IbH3oWbDNE6/JBlDTOVbSuGOt6Vl4a71JVD5?=
 =?us-ascii?Q?h7qkmBIeGivB47BDfm6DgScp1cd8Z2is7AK9JjefmtlFh3l0rRkdVwIvznoS?=
 =?us-ascii?Q?CrhWyx45nlPGTzckik50T7IsTZHyt2Cgg/K0XIDk631KalN98lmvCcszTzSW?=
 =?us-ascii?Q?dE6xqCdRXTwVAmSKzir59JRFVsW0Ty591+WJI+U9?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cc4ee7de-9b15-46a0-0281-08ddaa4d03ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2025 07:36:30.7811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nzIECLd8umLHMsiFcvU7glxXb3E+xSAO6iWSVp5ZakBg+++qoIMezVtCRZfJCbSBkrYIn9sB+zJ3B5IEH/kXiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6202
X-OriginatorOrg: intel.com

> From: Nicolin Chen <nicolinc@nvidia.com>
> Sent: Friday, June 13, 2025 1:18 AM
>=20
> On Thu, Jun 12, 2025 at 08:20:30AM +0000, Tian, Kevin wrote:
> > > From: Nicolin Chen <nicolinc@nvidia.com>
> > > Sent: Tuesday, June 10, 2025 1:14 AM
> > >
> > > +int arm_smmu_get_viommu_size(enum iommu_viommu_type
> > > viommu_type,
> > > +			     struct device *dev, size_t *viommu_size)
> > > +{
> > > +	struct arm_smmu_master *master =3D dev_iommu_priv_get(dev);
> > > +	struct arm_smmu_device *smmu =3D master->smmu;
> > > +
> > > +	if (!(smmu->features & ARM_SMMU_FEAT_NESTING))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	/*
> > > +	 * FORCE_SYNC is not set with FEAT_NESTING. Some study of the
> > > exact HW
> > > +	 * defect is needed to determine if arm_vsmmu_cache_invalidate()
> > > needs
> > > +	 * any change to remove this.
> > > +	 */
> > > +	if (WARN_ON(smmu->options &
> > > ARM_SMMU_OPT_CMDQ_FORCE_SYNC))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	/*
> > > +	 * Must support some way to prevent the VM from bypassing the
> > > cache
> > > +	 * because VFIO currently does not do any cache maintenance.
> > > canwbs
> > > +	 * indicates the device is fully coherent and no cache maintenance =
is
> > > +	 * ever required, even for PCI No-Snoop. S2FWB means the S1 can't
> > > make
> > > +	 * things non-coherent using the memattr, but No-Snoop behavior is
> > > not
> > > +	 * effected.
> > > +	 */
> > > +	if (!arm_smmu_master_canwbs(master) &&
> > > +	    !(smmu->features & ARM_SMMU_FEAT_S2FWB))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	if (viommu_type !=3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
> > > +		return -EOPNOTSUPP;
> >
> > it's more intuitive to check it first.
>=20
> Agreed. But I kinda intentionally left it here. The SMMU driver
> will have something like an impl_op->get_viommu_size in the HW
> queue series. That can simply insert a piece:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> @@ -415,6 +415,12 @@ int arm_smmu_get_viommu_size(enum
> iommu_viommu_type viommu_type,
>             !(smmu->features & ARM_SMMU_FEAT_S2FWB))
>                 return -EOPNOTSUPP;
>=20
> +       if (smmu->impl_ops && smmu->impl_ops->vsmmu_size &&
> +           viommu_type =3D=3D smmu->impl_ops->vsmmu_type) {
> +               *viommu_size =3D smmu->impl_ops->vsmmu_size;
> +               return 0;
> +       }
> +
>         if (viommu_type !=3D IOMMU_VIOMMU_TYPE_ARM_SMMUV3)
>                 return -EOPNOTSUPP;
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Oh I see.

>=20
> Otherwise, this following patch has to move the type check again.
>=20
> > btw does it make sense to also add below here?
> > 	if (s2_parent->smmu !=3D master->smmu)
> > 		return ERR_PTR(-EINVAL);
>=20
> I can't find a legit reason to forward the s2_parent to run this
> sanity. "struct device *" is forwarded since the driver needs to
> know the smmu pointer: A for the compatibility checks; b for the
> smmu->impl_ops mentioned above.
>=20

yes
