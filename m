Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025374F881;
	Tue, 27 Jan 2026 07:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769499213; cv=fail; b=QW/UMNylqeDkarEfKpmEaidUnyv4/i77hMsB5bEb5vY+DDsKtffhAsflZUfDjybur91tT/0z/ZUwCZFIBQ6S/yt4/jkV2aQd/8/OWzwH0LlrJcBnGRhPT7ihA0hNioc/cs3A7DNiEVaA85ZATZYbM8xc4u8+OIXDBaJkl2ylWJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769499213; c=relaxed/simple;
	bh=F4HgHPEr7WmKMM4n33jUH2Iw/S4BdIGcRhZQZBXMkh0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QatGF0U86FKtuf+V9oMAz6X2aZ9ayOtMYjvvm79fB8ZM6botJcrZZWRTzzd8Pu8/An6SVZ7RGoSoQo1BWNKwWHFqCwxjnZEvle644+QDN0ibrstLm7vYAxoJgvm2xoISjTZR3WJ8abs4jJvJO87xjvsPVMN0UPm+5DaoS4YiFIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fyV1QILL; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fyV1QILL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769499211; x=1801035211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F4HgHPEr7WmKMM4n33jUH2Iw/S4BdIGcRhZQZBXMkh0=;
  b=fyV1QILLEkURtXHN/lCHbM6qkl2XYtvjNwX1eg43kT7/XEKSVpuTX4Mg
   TSKBhOSNcX4LVEIbKcmkoilTHBNfejEZbKGToo2EICvysaIy2LHjgfR5m
   a4S5y0NRepDF9C17c5VggsLV1OJCjnc3WReWfzCvUsCdxPYzafKeGLiUj
   sAH4EQGscEBnltRFNLItE2f8e5koGxpFXEOL4tLDKqfCZ2rT/ujqKMT/o
   c6kexNewYwtWIloNPrMky+idXUqi5pVH+VaupXgv07a6EQFOrm6b/dTz3
   590i7xSOIh4s0v1dVs0eR1MQbgokPEctrjafqvVhBkWCOLFslPzrB7j/Z
   w==;
X-CSE-ConnectionGUID: 7l8njWJoTtGDd7SSXzkNSQ==
X-CSE-MsgGUID: KGQsOAhCSnyvQjcAZrZezQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70588616"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="70588616"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:33:20 -0800
X-CSE-ConnectionGUID: 5IRkAcHoSzW1J1/awrQC6w==
X-CSE-MsgGUID: t0/wqkEnT+KNdXoRhDfKZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="245511533"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:33:13 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:33:12 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 23:33:12 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.62) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:33:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dh664GuRx1NnPxYup2VHlkWVMmPfHk7aFW+PblhwDl2xXQ9bW25DzM6Lqk/NQNHJh+fWwOuFUO/B9GUgdTrVNSuvQIBcfchdY65zJ7Z5N2EvNDXOwbGesjnOLT2o6MAbV6f311GZXQpcdlO6SIPkDYJCfoXNiIZYJLbyQocAyfBV7tstmQVrYCpAO10dDIZaxKtrjv7SWSPRkirWJxJiCXLU+e8cG+eU4bMjftsvQrRKSzCQz18Oa8/tff6NqcpEhbnpRpY/g1L7Ra02neYR+OAS2hTEPFtMuNDI9fv/06FBxUyiiuVNdtuu+wbImCWOUlCyNEz+aXehkoNcM3kyjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jZ8GMWRQEdZ0BcrUy/x79g6f3QPA6kH8xsALh/5L4+c=;
 b=odRWMEJhLt1nd/ZmNXE2UDFR56kfQaQCuhazITcIkPy6aUTrQMOz9/7J1/pwmXKJ1e2x+7AdSk1T2QM5Ml7OHO37IKVmFwN6aeIWq0u2XhMrMDO5IwN+AVa5PwdB9gEHIlZlj6HCfScmfVSYuTlarE1Qjd+R4Gf77KeZww6CfZDyNMue067OwfNtB7/pmCrrFKpaAKd1HjZIIVbh5PxW+ycIY0OqJcx2SDWhQyVoptobhA4v2p9WPJ2pfFJjYYcrWv+dhPB48dr6yDBIbxJwKiD9IyEpWMIogRx+Pquygtt4C0Kk3wokyE1UUrbgAPc38MaAlv4mUjmHR7OvsHDWWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB7473.namprd11.prod.outlook.com (2603:10b6:a03:4d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Tue, 27 Jan
 2026 07:33:04 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f997:762f:f079:134f%5]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 07:33:03 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Joerg Roedel
	<joro@8bytes.org>, "Brost, Matthew" <matthew.brost@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Will Deacon <will@kernel.org>, "Dugast, Francois"
	<francois.dugast@intel.com>, Joerg Roedel <joerg.roedel@amd.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: RE: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Thread-Topic: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Thread-Index: AQHcjXSSUrfgiyXzp0aDYIe7CuoQ4LVkD5fAgABxlYCAASHO8A==
Date: Tue, 27 Jan 2026 07:33:03 +0000
Message-ID: <BN9PR11MB5276CAE7540825644463250C8C90A@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
 <BN9PR11MB527689AC9554360C2339E7598C93A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20260126141411.GJ1134360@nvidia.com>
In-Reply-To: <20260126141411.GJ1134360@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB7473:EE_
x-ms-office365-filtering-correlation-id: 501ae9e1-3020-48b0-9dae-08de5d764e94
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?us-ascii?Q?qfwcyez5obVClySmcN1d5RRVSjm57XdoiCSZKVjA7O6Bj6VhzCgxI5PPqFnp?=
 =?us-ascii?Q?KKX3NZMnrnByidoYTF7CQwKmEFf6mceqQ0L+f7DItqLRYNVPB7C8IPMkJQGs?=
 =?us-ascii?Q?LISel/NoYRvznV/x160BGui6ZRb/SHtdbnT7BSss40mumUoRCpM/k/7BkRm/?=
 =?us-ascii?Q?vdcChaaw+N3hTUQsfs/oqVqxMRRRIm03n8sxnq2WAdPKBJWc5O+v3eVZlqZt?=
 =?us-ascii?Q?J4EpwGYyyHl9R64hLJlNix74ErlKTMOrOtTi7InmUuXK8K8ETmNUDhzEdiH/?=
 =?us-ascii?Q?dTFxMfWyBRIov2v3B8PmFAYiCRUv3rnPNtIILo5TdOHA8tWbYKfLJrLWj2FF?=
 =?us-ascii?Q?0nd1drTXO+rrDWB19gR/IEpEO6JKSrMpN7yRLQWen4vKlbKSmY32yxruxE2+?=
 =?us-ascii?Q?OZ7yxlR48KtuYRWcU/4Ch8XbdUzfFqaeylecawiHvI9wbZbpbng4EYL9bIFz?=
 =?us-ascii?Q?lj2aGtZgY8NeBi+TEoKBCtxQwOMQw1DUqFu6mzETZgy7mjn0LLrJ368R6iYz?=
 =?us-ascii?Q?mZ+54tQ46ZogoZFfKIHSZSpsy84iOE3EvL8uiBe0FmOmohAsulKjYpFW4ia+?=
 =?us-ascii?Q?R8XtzUUuR0KvgsbGXohthIdaQ1MMg1wdO1Sb4GNBANEUZwb3PsZJJni7K/KK?=
 =?us-ascii?Q?iX9MIWcWpBnz2NWqYGwmgJvcTq5SV5lwGpKLBA24y2F/dA2eyH6lzxUg0uz3?=
 =?us-ascii?Q?6Bdf1QwlKExWC0ZEtapNIBQSyk2RDEvtttViCZUWdR4gjgFQY1MVvFJmRImw?=
 =?us-ascii?Q?cV15s1sAlnY21dLUlWPwRNlpfJQiUbk0DKcS0NK0lv4TitfMjp4Yn8Ueq7jG?=
 =?us-ascii?Q?a9O16Q2MzbvqEmV+Hqd9XGIXeQmlxF1v850P3sk/9kkdG6sUvxlJspGPzrHY?=
 =?us-ascii?Q?wUzcLaWKSCPUpYHplUIrg5Q1Ks/qAlSkxrbgXmaysUweq5BBBL/XQeRP0B0K?=
 =?us-ascii?Q?rWk60sI0IeBB1EjLWllW4+ji/xCKqXi4iqo95FHpkJQWbzsg+nO4dFZO/Fds?=
 =?us-ascii?Q?42A0Yw59v+QRH67BY75FHgRRr4kddS0eb7R+gaWlPQjHOS//h/fjsPj+b0im?=
 =?us-ascii?Q?MpZljajzD02aNgJqvGKiOUF9Ng2xfsorJUG4tzui6LreLoluchtnZJ8URGiG?=
 =?us-ascii?Q?iCossl9eQzndDT/wrbQXZj7kXKj1Rod41gPXps6E23i8GV1fqPYe3oGm6cwO?=
 =?us-ascii?Q?pvFKZXMrJDSYWxPluJWzS7Pl9sBb7FMCnCIx7rhihbXqd5qLE+fQ8wzZUgQI?=
 =?us-ascii?Q?exuReO7Z0d/l2vfIeG9UsSymovdJ6/qoHIYwGhOeJTvFk/qisfWcaVIpUNS3?=
 =?us-ascii?Q?HKF6ymLIRnQ/L+WvlqJtyO6aT4ZWWtPSRVvD6fy/6Umfar+cLSk+oJGDBUjy?=
 =?us-ascii?Q?mpdVIr0+WNYb+EQsMSvvg8D/EUay7jEWTFSXSTnfk0ONbiMmzypNOfy7AmJy?=
 =?us-ascii?Q?7H326srytVLgJk+HbgoqzW9ygfiqMlsy8LuO0+cHhW9xi+1f6ssIMNVvijTj?=
 =?us-ascii?Q?2+IWnpZZLws+gduWzUA1iIMYAjZoycoDzL9QNpmQE5WqS8DVjoTAN5dHLT+p?=
 =?us-ascii?Q?ICVQ6boxxqGbETlHBTLtU6VP2IK29F1IzDsB2P5qyqHGvJFK/U31TkffrH9r?=
 =?us-ascii?Q?NA=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xx+X3nAG/XwMiNpHjpS/utHiS7idvzSu/dlH4VGHaXXZug5rGs53IA6XYt5B?=
 =?us-ascii?Q?O1bakexeILt4fPNeilfgVQA8HaduhUKl80qEnmZxhOtMFNqwhVJ0Y1fmw9a4?=
 =?us-ascii?Q?WnrSBzFCuHvxsPQgb2HU3DU1V8PqpzPIdMXyEMqs41sTX4kvzJzd7/z8WcmU?=
 =?us-ascii?Q?VN+ZGmYZsfo3k5r92L6p1Wm44L9oXz+LvlIRpn4+oaxkSe9iI4hvMXx1fuPc?=
 =?us-ascii?Q?NhyciR8CuWzjPq3uQBpVO5S6ksT+UYKAK1TZGRvMcWDA8YXIwbO+7N00IPwE?=
 =?us-ascii?Q?1e1FLu36cUKx7OSLBf+/XoIWOw8X+BN2ChAIt0//w2vtnghzLxueq+4vkisu?=
 =?us-ascii?Q?WA1BI08zXd5dRIISAuYJETEepvAMjTLExECN+SaeKbeDlo2VggLz012FoWKG?=
 =?us-ascii?Q?jphtw1rvnAR9WU6qtKQj8w5l6GBqO1oHBFT+fsKhTR15piAwwadpnTQM/qi0?=
 =?us-ascii?Q?ssuC300L2PWSn/SMFp16Gk2e+9Jfpbcgc3JZfWAJ9BoWZx2c4U4dJmsDyYfT?=
 =?us-ascii?Q?Fbcna+jgeARAZQ2+s6ajlnl/6HzCA+fpUdl6x+RjTsgXpHi7xX+5CMYeLJWs?=
 =?us-ascii?Q?LUqnXQiCBdwZk9OA/pc/yqZ6lJghi9gtVsQ09qNjMsZOfLoXuGGjKVZIHKU4?=
 =?us-ascii?Q?hqPzo0njvAhNlrTlToNVZLRzftdXohfz31hc36WM1xhG9BoJUTCFNSK9vJ9b?=
 =?us-ascii?Q?sTZO6McQ09UpvKX/ep2fHE7nw099JASC2rb7e9MZ4WjbMtBaS6zsXEP5km69?=
 =?us-ascii?Q?JAsMupo1agJ/oZ8ecd6Sa1NfJ3l1MFv736I8zo99If2gGqSF3DSqBBhAqlnN?=
 =?us-ascii?Q?vXCDevHMFFKPZZfdm4clD9Yg5oJeVivHUyMJquH88QCkI3k353KvETorpj4A?=
 =?us-ascii?Q?ArzsQMXPhkVVDOAxTupL9MPi+VYQsH1bUm5Q6Ag9rR92o2bxwy+L/B5zfgLi?=
 =?us-ascii?Q?xUvUEB1faM3AXtTSbiTeZTR8PLZRasJStI4kKCChYkrD2xTzUpU0BDqsgdhn?=
 =?us-ascii?Q?7QkPVxfRBKEc9HKwxdoizmEUquobdD2cKEBa/bFFjm2fe3/sW+wzht5snl3h?=
 =?us-ascii?Q?5Ej5V7wCrAl7AKTP+jytySH2kkB2dmH3yKND4boAjzArKicnF6saelYj+z+O?=
 =?us-ascii?Q?7lnfGc7PSy3EP4yq/6keuSGDrAEbRKlIFe0RIilElchCneBeZnwIFwxUOlPh?=
 =?us-ascii?Q?IUogr5vcP6sEaOr7WhdVENDPj3Yny9UYcVKi13wE+OolYKq4bDF8l08NzwR9?=
 =?us-ascii?Q?PXW9VC+SfGPVxCNNDz8Y7+Q+FtzYyM48EfNCy5rkDLzS6YmFFG4xnSyhs37z?=
 =?us-ascii?Q?HDQ8rebstpg22Eax1fAHMr900UkSXNNfoZ57pQmLAZC5shAn9/jk6xdyKjHH?=
 =?us-ascii?Q?M5TuEyfKaMglhlFKVNPdAA6mctQdfQ1OeZUIiWYgueoh4x3PZR844S13mWlV?=
 =?us-ascii?Q?JAVQr296QpNxfP7lAdvxNbMvBz0S0Udqerq+8bEGsMvAd3Bj5xqAg6psebdS?=
 =?us-ascii?Q?J6xMkAxyeXVWnTjmS5RYe5XWAORV/2g6mvM+CZkZq+rMUZJtCnUoXCZgScGG?=
 =?us-ascii?Q?ZfHzlXAl02Z6j5YuUYlHol9eYFf/n1wnuM771FxAMt6VbEQMdqm2nY2b41AR?=
 =?us-ascii?Q?jw7WTKbwN+rtZ4Hxb4xzPM1rsMPABIsp5CZMgDrW4OghRgnjsFkgWLKOw7bR?=
 =?us-ascii?Q?mCyQAMNvLd1vw/171Bkp51GbMVwlj8LdCVY1lCPQN8gUqQq12JM1LPFFZ4X1?=
 =?us-ascii?Q?1Y3p5ABMfQ=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 501ae9e1-3020-48b0-9dae-08de5d764e94
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2026 07:33:03.8297
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YSVOhhu02pSeS1kvcsdA/3ODrKWEGQnzfYfZvDpEROHCT53jg2wA2iE+z/yuP//F4xIP86FC5zIHLLQE5rL6qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7473
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, January 26, 2026 10:14 PM
>=20
> On Mon, Jan 26, 2026 at 07:33:21AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Sunday, January 25, 2026 5:00 AM
> > >
> > > The cache flush was happening on every level across the whole range o=
f
> > > iteration, even if no leafs or tables were cleared. Instead flush onl=
y the
> > > sub range that was actually written.
> > >
> > > Overflushing isn't a correctness problem but it does impact the
> > > performance of unmap.
> > >
> > > After this series the performance compared to the original VT-d
> > > implementation with cache flushing turned on is:
> > >
> > > map_pages
> > >    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
> > >      2^12,    253,266   ,     213,227     ,   6.06
> > >      2^21,    246,244   ,     221,219     ,   0.00
> > >      2^30,    231,240   ,     209,217     ,   3.03
> > >  256*2^12,   2604,2668  ,    2415,2540    ,   4.04
> > >  256*2^21,   2495,2824  ,    2390,2734    ,  12.12
> > >  256*2^30,   2542,2845  ,    2380,2718    ,  12.12
> > >
> > > unmap_pages
> > >    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
> > >      2^12,    259,292   ,     222,251     ,  11.11
> > >      2^21,    255,259   ,     227,236     ,   3.03
> > >      2^30,    238,254   ,     217,230     ,   5.05
> > >  256*2^12,   2751,2620  ,    2417,2437    ,   0.00
> > >  256*2^21,   2461,2526  ,    2377,2423    ,   1.01
> > >  256*2^30,   2498,2543  ,    2370,2404    ,   1.01
> > >
> >
> > that is great!
> >
> > Out of curiosity - why would an optimization in the unmap path also
> > lead to better efficiency in the map path (in some cases map improves
> > even more than unmap, e.g. with 256 pages)?
>=20
> I cannot explain this, but it is how the test behaves on my system -
> before this patch:
>=20
> map_pages
>    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>      2^12,    530,237   ,     450,207     , -117.17
>      2^21,    417,231   ,     375,208     , -80.80
>      2^30,    325,233   ,     275,217     , -26.26
>  256*2^12,   3020,2658  ,    2599,2492    ,  -4.04
>  256*2^21,   2892,2839  ,    2585,2721    ,   4.04
>  256*2^30,   2794,2836  ,    2548,2712    ,   6.06
>=20
> unmap_pages
>    pgsz  ,avg new,old ns, min new,old ns  , min % (+ve is better)
>      2^12,    444,257   ,     410,230     , -78.78
>      2^21,    378,244   ,     353,225     , -56.56
>      2^30,    300,245   ,     281,229     , -22.22
>  256*2^12,   2975,2604  ,    2536,2403    ,  -5.05
>  256*2^21,   2887,2523  ,    2489,2417    ,  -2.02
>  256*2^30,   2799,2525  ,    2471,2397    ,  -3.03
>=20
> Perhaps it is an artifact of how the test is constructed and
> subsequent maps are suffering because the cache for the already
> populated levels is in a poor state due to the extra flush?

that's a possible reason.

>=20
> Mapping requires an atomic on the cache line so maybe that interacts
> poorly with a clflush somehow?
>=20

depend on the concurrency of mappings vs. clflush...

anyway since it's fixed the regression:

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
