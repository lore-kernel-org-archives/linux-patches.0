Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9278C14A97;
	Tue, 28 Nov 2023 08:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UooFzOGK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701158458; x=1732694458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=591Hm9BTWi4FtBpTI/KUlM7GS2PqgNWlFyEAP5kQTlY=;
  b=UooFzOGKxZZZqDOyymHProsAGIZy/uaR2uJDsXTqY3zbUNzGcgDfJXpS
   e3PotzXPUcjKJ3n+oaTye+l3rGDwgPxRuZGLRtpEeY4BfmuYxUDNMeNva
   WNY3ZlsWI+tFbOlSjbgsNLS8KQBTDNDg4vWQTGNQr4WkVLUVf04Zpa4Nr
   ZfJYU/AS1NiqJ4TPxHHYaHlJwgGimDRSuf6xSQXIt60Z/irBhKmmQe9uZ
   pKVP4rIbKCE931uIjh2xc2XSsBdeA/Mmibj6874D982dNSfkF6emv7gfw
   PAfQQajGwNfAaQXFSGMa0foiP0I+P+XiH6SJYCMupvdZuMgHBbO+UMDrR
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="457203711"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="457203711"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 23:59:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="941839340"
X-IronPort-AV: E=Sophos;i="6.04,233,1695711600"; 
   d="scan'208";a="941839340"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Nov 2023 23:59:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 23:59:32 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Mon, 27 Nov 2023 23:59:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Mon, 27 Nov 2023 23:59:32 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Mon, 27 Nov 2023 23:59:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cq/HgHevEBWMU5d52chTcCKsCrkjbb+Yd43gz/b9g4jn2B1Qo7F6eDoIXI1iMQ/lDE8mNFLaKXqxLX5SotruLgWpEOVvzgRVEnoXEzUiPZ78z+iJxvapNwVj1LIpVmT3PHDQQ6NptiKTwf43UCGkJy8NL2BTIJ9tB8YBeffW2lxhQ16jPL3zw9FHsUPJmchCNaEWjS+IXHRUXxwzYtYo0hZ95YOoOie9R9iHqbd35HJOrAbA7MS6Pz3hD5rJ5xZjnFmskewuwLzB0vJueGUN63lmKDlEervvxWQH+xcR1EWj4/gE25Z+lLSpo72a+KnelB9x7fvkSQl5DEH8RQOHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RKClg6grt7ZE6dh3iX0WTYY2+zknfMnmKFeFH8tNxi0=;
 b=cFAkjUUWQSGVf5V0oQVEkTt01yYgiagJvvxEzZckzHPO4bNh3fF36dGhVMDWjhPMO+E6QOw8QczowN7UEZcyETMR0eDLj8haXF/hbb+F4/dGq/FmG8vi4UC1G/ZoyfL84QOlq4gDsF+NPYbzo1REhQzpTFbQnMvrj36G4AVNxvZgKZeCi6Vi6H7SrkCao9pNkYpZu4pOWkUImMqYSXm9mMnIhge9DL6X/orMpVAZMhZn6Mvw/o3T9v036nuTlzfVWBgtXs7NWIBVcn7MytvxtTIn1hF0S9Ogantin0IP/pqqSt/LM6PXjQb9Fny79seqt0agpc4OpC5AhfhVf4Inig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH8PR11MB6952.namprd11.prod.outlook.com (2603:10b6:510:224::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 07:59:30 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::e7a4:a757:2f2e:f96a%3]) with mapi id 15.20.7025.022; Tue, 28 Nov 2023
 07:59:30 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: "iommu@lists.linux.dev" <iommu@lists.linux.dev>, Lu Baolu
	<baolu.lu@linux.intel.com>, Eric Auger <eric.auger@redhat.com>, Lixiao Yang
	<lixiao.yang@intel.com>, Matthew Rosato <mjrosato@linux.ibm.com>, "Nicolin
 Chen" <nicolinc@nvidia.com>, "patches@lists.linux.dev"
	<patches@lists.linux.dev>,
	"syzbot+7574ebfe589049630608@syzkaller.appspotmail.com"
	<syzbot+7574ebfe589049630608@syzkaller.appspotmail.com>,
	"syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com"
	<syzbot+d31adfb277377ef8fcba@syzkaller.appspotmail.com>, "Liu, Yi L"
	<yi.l.liu@intel.com>
Subject: RE: [PATCH rc v2 2/2] iommufd: Do not UAF during iommufd_put_object()
Thread-Topic: [PATCH rc v2 2/2] iommufd: Do not UAF during
 iommufd_put_object()
Thread-Index: AQHaHUW3Ok4tHNXWeUy+EXR6vsomLrCJAo8AgABsZQCABfY+AA==
Date: Tue, 28 Nov 2023 07:59:29 +0000
Message-ID: <BN9PR11MB5276CF21A13C701838CD309B8CBCA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <2-v2-ca9e00171c5b+123-iommufd_syz4_jgg@nvidia.com>
 <BN9PR11MB5276FE18B63A22DB64EBD8098CB8A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231124125006.GC436702@nvidia.com>
In-Reply-To: <20231124125006.GC436702@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH8PR11MB6952:EE_
x-ms-office365-filtering-correlation-id: 2994aa31-b553-4a9d-f514-08dbefe7f333
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sXpkSHS9CPbufywfa2Tqa3u6qsdQzpAO8qk0cHa9c2QHzfdifMBMb32OcP4cQXGoASh+8fp0W8qfbHYRnrZ7TBPAYCX8lKWYMRsf9CZBQhdEIMAvHnd+y+Ro0yumRoP8Wb02lVJSc9Y64w/0dzRagovrs37MGkOVH1NIGwKoQC7DWRFPwQqgVhdAHfaKJ/2C/XWW/bC68IqBHqcsgg5Xt32BWW2FzsD5D2j/GI41Vfgk4907ev/tLhKnnHuMdLXv4qfVMbkZaaACT6Xqkve2rwr11nxoSp1ifjFs7u8T4YJCsVePk8jCaDY7K/aDovVzykyaq1BjJSeHWPQXq18ZZA+FwP6T0cRL+psX65Id7RkX2INsQhvtF/eRuDBRZ42IL2fLLRjvThOBskTuyw4ctfHdrH86gjJRJV7Rpnzlb21KmAkxrf8yscCByaLWYR479LwK+VrGkL6PeK1ADZvzIJrIibB7rswboMCh9GniG58eFd3BZYYIlfEtfX6I63dEBivi9zlnSYfEOortlw7W8Faczs2ygDL5dzEeNJMkp1mH4icm74xkB1VPS1wsLsrhtO7aVNGx8Qo/uRhHhVeyqieMS5YgQqVSUkFhyMBkq6mQmcV3kR43Cf4o66XlQVBW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(136003)(396003)(346002)(376002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(26005)(6506007)(7696005)(9686003)(83380400001)(71200400001)(41300700001)(4326008)(8936002)(5660300002)(52536014)(8676002)(2906002)(316002)(478600001)(6916009)(54906003)(66946007)(66446008)(64756008)(66556008)(76116006)(66476007)(82960400001)(86362001)(33656002)(122000001)(38100700002)(38070700009)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BAB3e4alYlvMM85JR8OdxxTwlDjCSP9TR0B1MK5ErQc1LjZzXpU+eq9yWBEj?=
 =?us-ascii?Q?X+iQmJ7Z94lPuO1tXK3Dy49X0+A/DjtGC3C0P3q9Hc27LqVYnbkXqii9f15h?=
 =?us-ascii?Q?PFHH6n/XMXNXAKF1JMiyvcCElzQwrttgj6nIs6S+iFvlxTFqVlRqj1EdncGK?=
 =?us-ascii?Q?N+ycw+6L589HaXpy2lfOuVsTJofoTPBxC2PLejlfSoHbhERc/rzmr2tXAE6D?=
 =?us-ascii?Q?/u7F8e29TOyndoCRjOd67WmZLoD6mN7voID75fYJIZh6evomQMcsfreCE39/?=
 =?us-ascii?Q?/DbrQBTrpysiFa7X8oTAhMhV7R8rJDDLQFsn8zHK2/xm9uq4dr+tQJhEwFxj?=
 =?us-ascii?Q?qmIHu9yamVCs7dFK+Wf6LyRYtaImIbZYlPCfkYZgT4pjNVbTK1EiXA+yudWr?=
 =?us-ascii?Q?AfdKX43tedkvc65bi9ubu1yrR9NZh9+3WM16kC7tIPvZGlMYrSk/GKy0/BaJ?=
 =?us-ascii?Q?vKH/pYfxYnJjp0tuIm0/2WKYf4qt5hnykTs+1mzvAQuL6gQGNmOSSRJd/SzH?=
 =?us-ascii?Q?q3/EmaHzzbCOkMUOw7F7hTCLdlivONqaAFZXM3zlbdLxohmaS5T3yCCpIiE/?=
 =?us-ascii?Q?z///t+IXRzn7Pg+n/gZAP6Vt1Wqn995I4Iux37FCAb5E9oYNn0bjedxLS3II?=
 =?us-ascii?Q?MybMSJL7vZISOZdYU3VJ0m/jJ+ArZprNIpol/6nBdDqK8pPrYb6oL71AI3SS?=
 =?us-ascii?Q?hr7Zw+jirCRaeIBlPrsNCHaoxyzEhYPb0iW2mF+qCJ18txlvURd88SFNTkVn?=
 =?us-ascii?Q?KxnM8+O5iW+aNSNsdsIVwEdeZ9YPSiPUgThOVdIQ0n4widaE0gU9HXz5Wbs/?=
 =?us-ascii?Q?BymdWXwFRxnsMlKA6cZl6LzCpxL7poYhhEfC5XjOa+FaHeNWAh04B8XMOP/M?=
 =?us-ascii?Q?qTNxARgPkdBgwjmYiMpSD3g6WSO7K2KxHu0UzygkKLazdSGiP1FXTcTxm6ml?=
 =?us-ascii?Q?o6+v7VRbMtsYHAUQAcVICyeA8tyokJ880iM1WvCGODpGQJfAIdC62KyCoRwK?=
 =?us-ascii?Q?WeEtqefp+Tg9m99i5q9Ydkg+Afik26sN0BqPfIJrpfx2VbNKSOG+bamx/Ywf?=
 =?us-ascii?Q?BezjOZ4Opy2vIRxgiKj8cluBf+NXAF4BABNVZxDEIoeAbw78W1PZu2bMvZl0?=
 =?us-ascii?Q?DwK9ZrlNU6OTDhUPBfcMT8m4Qti3pc3DYKWVfYmJz3EvrEXN/pctc5+kd26W?=
 =?us-ascii?Q?fd9pfGgWeFQWnJ9fN9k4S/W1Scch1cP/IVdKFkxqwGr1apYF0/825tq6AITG?=
 =?us-ascii?Q?i85pZG6RiKH3ChWcKLklrY0xF2MoUBbcVeJEQHoaBHohpWycxQMAVrEfMueS?=
 =?us-ascii?Q?+xDvNI2T0x88UsFkf3ngJSymCFPKnfA/YXwtqFgqmkWxuwOF77q5YGlBN4XB?=
 =?us-ascii?Q?0Aqx8UJBnZbOECqp0XkazEk2FhNvoPLyfmvnPwliVdhNXY+O+T/JnbFomhq4?=
 =?us-ascii?Q?73ehZrwCDtskFB3eeDF7GUwwQnW9Q0nX55tKLlwXwCmFEtmsAv27o94uRgxR?=
 =?us-ascii?Q?Uv1k4K4XTnxW3VtYdE36PAJwfQNsyQHDOGK/2DPzqzzryH1YNzYOUw101Fcw?=
 =?us-ascii?Q?S89cOIFFVAklDcUVCeonGrcbLB7G1ojuLBNAOdKi?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 2994aa31-b553-4a9d-f514-08dbefe7f333
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2023 07:59:29.9419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FyqngnmWra54OGYSI+KGEnaj8E4EIQUAA6XzIS00LDodTPMTv+OGfjf5QwgMMOk92mKeT1DQSCW0T5Ev8GUibQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6952
X-OriginatorOrg: intel.com

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, November 24, 2023 8:50 PM
>=20
> On Fri, Nov 24, 2023 at 06:48:59AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, November 22, 2023 9:13 PM
> > >
> > > +		if (ret) {
> > > +			/*
> > > +			 * We have a bug. Put back the callers reference and
> > > +			 * defer cleaning this object until close.
> > > +			 */
> > > +			refcount_dec(&to_destroy->users);
> >
> > explain why refcount_dec means 'put back'? also 'put back' is
> > inconsistent with the earlier comment "In all cases the caller no
> > longer has a users reference "
>=20
> As above, "put back" means to have effectively done iommufd_put_object()
>=20

Probably just my English problem on the confusion that here 'put back'
means removing the users refcnt of the caller while later 'put back'
means adding back the shortterm refcnt in the error path:

+err_xa:
+	if (zerod_shortterm) {
+		/* Put back the xarray owned reference */
+		refcount_set(&obj->shortterm_users, 1);
+	}

anyway I didn't spot other issues with your explanation. Thanks!

So,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
