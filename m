Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8833A168B0;
	Tue, 21 Nov 2023 03:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SbLbf4z4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700538166; x=1732074166;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FDLhTTDvCyij9Gl7X0GuKbcadXi8bXMXDYnmos+ky5I=;
  b=SbLbf4z4gmtSkNYjNb0K1o4dIzg89g8VcYEQxWURqAohPMbZnwa4/wnX
   kL+Iftu/QqlUTHnbdlXlKGhwjMELTR14KunLEOUdw7x1Ghc04WPKbIMqc
   iCnH3QBiEjSCRIYwdJmeHAbuYcFIsdb28tLveguBeJC174hKTE+u0DJ4+
   mZVtgKWfXVSRtGHTflMukAE6ZllUSUDgvPDTM249U1QW6S1Qe400GUgWz
   iVfKSdP/sYb5/HAFYCCIBlHCYZiqw1bDZ8ZngLTxLgNLhppAnB2Ezu9+A
   7nD0USHT0OGCFxBbjvbERJj9BfVKkFeo91ByxQemCB599CcT4ol0EHxT6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10900"; a="371100549"
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="371100549"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2023 19:42:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,215,1695711600"; 
   d="scan'208";a="7930555"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Nov 2023 19:42:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 19:42:42 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 20 Nov 2023 19:42:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 20 Nov 2023 19:42:42 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 20 Nov 2023 19:42:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IBBs9GP13cAEVjIPdcc8LesmQpac3Ys9qNZNu6mOTUGzhGFRAdb/j8KbYYNgo18h+DyM98T+6Oz8EMdOik6yVhMhX9u5Mcj9T/aNjFrL4bHs4vjF7/V40HP5cvxGIoqbZ3G0qnuooeSDJk13le2AYTdcwjXhdnt76332S/Q/Yan2zhaDa3wtY/zFGlwgDgtVq7TklcsK7t88amoYNAU4BFYrxkHYc5GF5mkjRb6p86zgebxIFo4IbmbLU5JAi1oQchkfygvOC0p+jGYjaC1q5E/2mo1ABmyi3LrS9fYwW0toZN8se/3OQEnUmOvKvPEiisoUL6gT+hfABYtpP+pKbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDLhTTDvCyij9Gl7X0GuKbcadXi8bXMXDYnmos+ky5I=;
 b=Bbz1BWwKncxXDb7faQ93Dyzn4TG4iiMo7lb9MXGaWS9QJ4gO0qbG+r/f2M9Yc5GAjXZKcApEdBKTxA9CcHxVyY5cur3yBjmrloueV5Pl9fBAXqAy5uqW4ihMjOMeoWjjw05/5eWlNQpZenooDHRAGm7mtos4esTQcJI0dXRKRhWqa64on00lCZa1YcpuGLQUvCd+Zbl84K5/yMjlZ/D4idXvTucGMCrE4IYcE2Pxt6MaGVaR1R+m+VmxEplLdfV2JgqHRiooD8P7oxrTDMle4k8mGQSOv1A6DwJZXhQWyaieWw3aErjRoDV9XMCzv7hBs4MKLoEoN9HdhKWgjrodlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB8593.namprd11.prod.outlook.com (2603:10b6:806:3ab::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7002.26; Tue, 21 Nov
 2023 03:42:34 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7002.027; Tue, 21 Nov 2023
 03:42:33 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>, "iommu@lists.linux.dev"
	<iommu@lists.linux.dev>
CC: Lu Baolu <baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>,
	Lixiao Yang <lixiao.yang@intel.com>, Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
	"syzbot+7574ebfe589049630608@syzkaller.appspotmail.com"
	<syzbot+7574ebfe589049630608@syzkaller.appspotmail.com>,
	"syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com"
	<syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: RE: [PATCH rc 1/2] iommufd: Add iommufd_ctx to iommufd_put_object()
Thread-Topic: [PATCH rc 1/2] iommufd: Add iommufd_ctx to iommufd_put_object()
Thread-Index: AQHaHBoYL7FOzvtXz0i1oBVpevS93LCEITrg
Date: Tue, 21 Nov 2023 03:42:33 +0000
Message-ID: <BN9PR11MB5276B085AB24AA994C8B53F28CBBA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
 <1-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
In-Reply-To: <1-v1-4c9a7fbb5702+107a-iommufd_syz4_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB8593:EE_
x-ms-office365-filtering-correlation-id: b7439a1c-18a9-47c9-5316-08dbea43e576
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OeUBIFrcWgD+XhPBcfa5yd0pBwkxm2e8fLOvUcDNHkzfcPZTmDEV2JqbTWvkicxP6a3VeKg4p4Plor1yVvPhZOROOiD/431vHRKZ+edX9w6sHdrWw6XHQ/8vTng66fXNNy17fHXdyrLpOgS3CpZh0oabA4NXTmwl11uBO+59/ZldelfAMHtLvzq0w2v1zpvJqIqH16RUvnWANJYdJXcqutOL3L6MK9B13K6QD6BitOIBQE4sx2rTeFthiX4D+InQ6+tm8VSOAddIs8tTN8brAyrNzMYl+gwAZiJRRuWM+/PDh5ofbBGuWINmx/CXwV6st3TGQGDxdUEDK6w5JvyaNDGHWzBV1HIGvG01P2eOEyrjaCK0QntKX4+wwaNdAr9CUJ4Jysj03PVVDOD2ESzYfOKVsm6DOlzvuA3wedxn/1XdBtmTMaSo75o+Q1OO1A82aDMD8IGBOUkRLU5GkZwAhTSXErswrX9+2gWWLQBLxU0i+q0my0YYFEQPu6C0YzyECg7jhnBnlghTBamI0ls65+eWaIEbck98vjY0bvMVI3RI2L3Vu6P6xuKmoVGn0tl6/SHs78eVtPOQ3nHlbOaTSS0/Kf55ZTbf4xknJNUy/K8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(366004)(39860400002)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(54906003)(64756008)(66446008)(66476007)(316002)(55016003)(2906002)(5660300002)(41300700001)(8676002)(8936002)(7696005)(71200400001)(478600001)(76116006)(66946007)(110136005)(52536014)(4326008)(38100700002)(9686003)(6506007)(82960400001)(122000001)(66556008)(26005)(33656002)(558084003)(86362001)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kv3vs2FM7meLdJF3kKnajS5/pw9+ucrjNFW1hkpp5xaUke3OpX8GzQh+hqps?=
 =?us-ascii?Q?WUR/ahzp0W6o820thuoofH8vtCjI6FDEF/+nql1AeyZ+fKtRNwnnUEE1D598?=
 =?us-ascii?Q?wpvklJRs4hMjr44nHuNinoL0rmcoFeDW8W2oXyFok9ZjN66IDW22bUGC7oUV?=
 =?us-ascii?Q?Umk/kS3bxupIAQ0/Pugxz8/vS3pHsb8SS2mXxQadmAIpCJvWPiKFh36n5s1X?=
 =?us-ascii?Q?LsYWTOBc59L7wpspkBo/Lc15gxhS7zQdJWeLp1QyT0XPxfVTUxYB4OFBk4xV?=
 =?us-ascii?Q?XWEJKumVeTeiXPZy9PXJkZLLttIc8u7ndDUmzifxZVthBfsmBUdma+59JmbU?=
 =?us-ascii?Q?OPwj+PgvPZGzik812rt2g0emPRA08kOO7BwxwMN8nFO1ESkLZiz3xdVBAlSQ?=
 =?us-ascii?Q?cQRGGHdm5Twwpgd0Kkc/9ETMiwesHd/KaXt1L/hqFV5yLXUt0BIJHVZi7FDu?=
 =?us-ascii?Q?xpSsqato6aMTqD65xaPFwnmLkbWA1aV31Xw7/yKb3urqCGNPNGpBhDhHRcrF?=
 =?us-ascii?Q?hr6AoHjy27M5V4PmfknASDrZm+JTBkf9zqZZ2yyiKkHQ/g9rlg1q4SCJiuEm?=
 =?us-ascii?Q?NMJrM9FRIjKHRfleCKpx40nljVKOJYgZw5i3CAdtfolv7DxB+vlofhfgszat?=
 =?us-ascii?Q?LI+nau420Cjg5yWXEElFZt7FXsvuFpI2/VPrDLhh8HlovByw3rGady2mvxxa?=
 =?us-ascii?Q?jogBKVlDdyDjpcnkEK5kRmWyM/bb6Cnvu2fLvpReEGrkuuZlSfmtO9l9/FwV?=
 =?us-ascii?Q?mSPyJMR9TopWyLNEb2aRNKdb5jNzk44Ax4WHr8x7kvFWofzHZzQVXgBslmw3?=
 =?us-ascii?Q?KSXg6eVLurGcuvG0C3Dzz29SXdiGR4GNAX1NQi4M+taGBf+gNPBQ9Xf8F7rc?=
 =?us-ascii?Q?RvGs9hor67RL58fLsgdAQdE8ZsBIzv6AFy3rttS5YaOG3EkL4wfQP5CRWQ8l?=
 =?us-ascii?Q?NeC3M0Jm2zLfPcHP1s8b5SYO2ZdNOHyB+OZwisc0ULCaec7LgJh+59Zd8dHv?=
 =?us-ascii?Q?tupqug0j2ddTMHZbue/yWgLpuxUHJqTdFoCXu2q6adLEZxgdx1uvsdd1e9RZ?=
 =?us-ascii?Q?GWauMv8+3zIg+TCMQMo8g4eoFMkXS13zdpN9zd4lcJgv6sXHSgbFZhvVcm5U?=
 =?us-ascii?Q?Oq9FMkKvSSAGfue8jHniPWzyBu7KJIBJY49YvwEpXRzAR9PMUjKuioX6P8AW?=
 =?us-ascii?Q?a/axzXbzcsQeLHGvIZAOVWQqxduvVFhYTqhb+aVkrHzRxP4Pd/Bn74/g3q83?=
 =?us-ascii?Q?gGdCdnksE8F2LD6X5I6H7kUKGIktOH6vvhcDAblb36CcWTvYaMnZ+vFY3Bnc?=
 =?us-ascii?Q?LKBzkHkSSn2zOMvaWcHHsHf4RrBkYs3gd1wxwu+FgxYdbWecmz3f1Uw8vqYt?=
 =?us-ascii?Q?Qg8JQymxNNYV7o4AGh3HEBpcOU1jLgRWKm9l1XRLeQduAi12M++KqH0NhAAx?=
 =?us-ascii?Q?FEK9qopB+md8AIm+wsZOtZZN8Km/XKBgnPgZtYrMyPWkmjVVDHYWmlXX+sI+?=
 =?us-ascii?Q?0oJ5ifH7Yo6NYxWKWBnbgsCiquSjpNEM4igs3SZYTCDa+OqMG7+DDQ6QAWS3?=
 =?us-ascii?Q?QB+jIRicDXSNfCd/am8oaVv+FnhoXIVxdu46Tb1F?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: b7439a1c-18a9-47c9-5316-08dbea43e576
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2023 03:42:33.5930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GxQkH6fddV2hWegveSfVn+bZ9gbZ9gfYmJO50uNrg3ItwKlRfHKNT/IrQc3m8xg6y/KDq48FeGnenwo9gqhVLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8593
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, November 21, 2023 9:28 AM
>=20
> Will be used in the next patch.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
